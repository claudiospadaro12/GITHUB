"""Genera il file `abtg_news.csv` per gli Expert Advisor (filtro news).

Gli EA (PostNews, e i filtri news degli altri) leggono un CSV in
MQL5\\Files con separatore ';' e colonne:  data ora ; impatto ; valuta ; titolo

Questo modulo scarica il calendario di Forex Factory (stesso feed gratuito
usato dal report) per la settimana corrente + la prossima, tiene gli eventi
ad alto impatto, e NORMALIZZA i titoli di ECB e FOMC in modo che contengano
sempre le parole "ECB" / "FOMC" (che è ciò che l'EA cerca).

Uso:
    from agent.news_export import write_abtg_news
    write_abtg_news("abtg_news.csv")
"""

from __future__ import annotations

import sys
import time

from dataclasses import dataclass
from datetime import datetime
from zoneinfo import ZoneInfo

import requests

# CLASSE 461 (19/09/2026) -- DUE DEI TRE FEED NON ESISTONO PIU'.
# Misurato sul runner di GitHub alle 17:51 UTC, con i ritentativi gia' in
# funzione: `ff_calendar_thisweek.json` risponde e da' 105 righe grezze,
# mentre `ff_calendar_nextweek.json` e `ff_calendar_lastweek.json` rispondono
# **404 Not Found**, quattro tentativi su quattro, tutti e due.
# 🔴 Questo SMENTISCE la causa scritta nella classe 460 ("il fornitore rifiuta
# le richieste ravvicinate"): non era una limitazione di frequenza, erano due
# indirizzi morti. L'attesa crescente non serviva a niente -- e' stato il LOG
# a trovare il guasto, non il ritentativo. Correzione riportata nella 460.
FEED_PRINCIPALE = "https://nfs.faireconomy.media/ff_calendar_thisweek.json"

# Provati a ogni corsa e LOGGATI, ma la loro assenza non e' un guasto: servono
# ad accorgersi il giorno in cui tornano (o in cui ne troviamo di validi).
FEED_OPZIONALI = [
    "https://nfs.faireconomy.media/ff_calendar_nextweek.json",
    "https://nfs.faireconomy.media/ff_calendar_lastweek.json",
]

FEEDS = [FEED_PRINCIPALE] + FEED_OPZIONALI

# Ogni corsa di collect_news() riempie questa lista con i feed OBBLIGATORI
# falliti: e' quello che decide se il workflow va rosso.
FALLITI_OBBLIGATORI: list[str] = []

# parole-chiave per riconoscere gli eventi di politica monetaria
ECB_KEYS = ("ecb", "main refinancing", "monetary policy statement",
            "rate statement", "deposit facility", "marginal lending")
FOMC_KEYS = ("fomc", "federal funds rate", "fed ", "economic projections")


@dataclass
class NewsRow:
    dt: datetime
    impact: str
    currency: str
    title: str


def _fetch_feed(url: str, tz: ZoneInfo, timeout: int = 20,
                tentativi: int = 4) -> list[NewsRow]:
    """Scarica UN feed, con ritentativi e log esplicito.

    CLASSE 460 (19/09/2026) -- QUESTA FUNZIONE INGOIAVA OGNI ERRORE E
    RESTITUIVA UNA LISTA VUOTA, IN SILENZIO. Il `except Exception: return []`
    originale faceva sembrare "nessuna notizia" quello che era "non sono
    riuscito a chiedere". Misurato: il 18/09 alle 05:00 UTC il report
    giornaliero ha scritto `abtg_news.csv generato: 0 eventi`, il file e'
    rimasto a 0 byte, il commit-se-cambia non e' scattato, e lo script sul
    VPS ha copiato zero byte USCENDO 0. Quattro strati che tacciono in fila.
    Il file in repo era fermo al 26/07/2026.

    E la causa della lista vuota e' la fretta: i tre feed di faireconomy
    venivano chiesti uno dietro l'altro senza pausa, e il fornitore limita
    le richieste ravvicinate. Prova del 19/09: una corsa a mano alle 17:27
    UTC ha riportato 16 eventi -- ma SOLO quelli di `thisweek`, cioe' solo
    il PRIMO dei tre feed. `nextweek` e `lastweek` erano stati rifiutati, e
    nessuno se n'e' accorto perche' l'errore spariva qui dentro.

    Ora: si ritenta con attesa crescente, si mette una pausa fra un feed e
    l'altro (in collect_news), e ogni esito finisce su stderr con il nome
    del feed. Un guasto resta un guasto, ma diventa VISIBILE.
    """
    nome = url.rsplit("/", 1)[-1]
    ultimo = ""
    for k in range(tentativi):
        if k:
            time.sleep(2 ** k)          # 2s, 4s, 8s
        try:
            r = requests.get(url, timeout=timeout,
                             headers={"User-Agent": "market-agent/1.0"})
            r.raise_for_status()
            raw = r.json()
            break
        except Exception as exc:
            ultimo = f"{type(exc).__name__}: {exc}"
            # CLASSE 461: un 404 NON e' transitorio. Ritentarlo quattro volte
            # con attesa crescente costa 14 secondi per feed e non cambia
            # niente: il 19/09 ne sono stati bruciati 56 su due indirizzi
            # morti. Si esce subito e si dice che l'indirizzo non c'e' piu'.
            risp = getattr(exc, "response", None)
            if risp is not None and risp.status_code in (404, 410):
                print(f"[ERRORE] feed {nome}: l'indirizzo non esiste piu'"
                      f" (HTTP {risp.status_code}). Non ritento.", file=sys.stderr)
                return []
    else:
        print(f"[ERRORE] feed {nome}: fallito dopo {tentativi} tentativi -- {ultimo}",
              file=sys.stderr)
        return []
    out: list[NewsRow] = []
    for item in raw:
        ds = item.get("date")
        if not ds:
            continue
        try:
            dt = datetime.fromisoformat(ds).astimezone(tz)
        except ValueError:
            continue
        out.append(NewsRow(
            dt=dt,
            impact=(item.get("impact") or "").strip(),
            currency=(item.get("country") or "").strip(),
            title=(item.get("title") or "").strip(),
        ))
    print(f"[info] feed {nome}: {len(out)} righe grezze", file=sys.stderr)
    return out


def _normalize_title(currency: str, title: str) -> str:
    """Se e' un evento ECB/FOMC, garantisce la parola chiave nel titolo."""
    low = title.lower()
    if currency == "EUR" and any(k in low for k in ECB_KEYS):
        return title if "ecb" in low else f"ECB - {title}"
    if currency == "USD" and any(k in low for k in FOMC_KEYS):
        return title if "fomc" in low else f"FOMC - {title}"
    return title


def collect_news(tz_name: str = "Europe/Rome",
                 keep_impacts=("High",)) -> list[NewsRow]:
    """Eventi (deduplicati) dalle 3 settimane, filtrati per impatto."""
    tz = ZoneInfo(tz_name)
    seen = set()
    rows: list[NewsRow] = []
    keep = {k.lower() for k in keep_impacts}
    FALLITI_OBBLIGATORI.clear()
    for n_feed, url in enumerate(FEEDS):
        if n_feed:
            time.sleep(1)
        righe_feed = _fetch_feed(url, tz)
        if not righe_feed and url == FEED_PRINCIPALE:
            FALLITI_OBBLIGATORI.append(url.rsplit("/", 1)[-1])
        for r in righe_feed:
            if r.impact.lower() not in keep:
                continue
            r.title = _normalize_title(r.currency, r.title)
            key = (r.dt.strftime("%Y-%m-%d %H:%M"), r.currency, r.title)
            if key in seen:
                continue
            seen.add(key)
            rows.append(r)
    rows.sort(key=lambda x: x.dt)
    return rows


def write_abtg_news(path: str, tz_name: str = "Europe/Rome",
                    keep_impacts=("High",), rows: "list[NewsRow] | None" = None) -> int:
    """Scrive il CSV nel formato dell'EA. Ritorna il n. di righe scritte.

    CLASSE 461 -- `rows` si passa quando il chiamante ha GIA' raccolto.
    Prima il `__main__` chiamava collect_news() e poi write_abtg_news(), che
    la richiamava: ogni corsa scaricava i feed DUE VOLTE. Si vede nel log del
    19/09, dove i tre feed compaiono due volte e i 404 sono otto invece di
    quattro. Non era solo spreco: raddoppiava le richieste al fornitore.
    """
    if rows is None:
        rows = collect_news(tz_name, keep_impacts)
    lines = []
    for r in rows:
        # formato data che StringToTime di MT5 legge: "AAAA.MM.GG HH:MM"
        stamp = r.dt.strftime("%Y.%m.%d %H:%M")
        title = r.title.replace(";", ",")  # ';' e' il separatore
        lines.append(f"{stamp};{r.impact};{r.currency};{title}")
    # MT5 FILE_ANSI = codepage Windows occidentale (cp1252)
    with open(path, "w", encoding="cp1252", errors="replace", newline="\n") as f:
        f.write("\n".join(lines) + ("\n" if lines else ""))
    return len(rows)


def summarize(rows: list[NewsRow]) -> dict:
    """Conteggi utili per il log (quanti ECB/FOMC trovati)."""
    ecb = sum(1 for r in rows if "ecb" in r.title.lower())
    fomc = sum(1 for r in rows if "fomc" in r.title.lower())
    return {"totale": len(rows), "ECB": ecb, "FOMC": fomc}


def conta_futuri(rows: list[NewsRow], tz_name: str = "Europe/Rome") -> int:
    """Quanti eventi sono ANCORA DA VENIRE.

    CLASSE 460-b -- E' LA MISURA CHE MANCAVA, ed e' l'unica che dice se il
    filtro serve a qualcosa. Un filtro news blocca il trading PRIMA di una
    notizia: un calendario di soli eventi PASSATI e' un filtro spento, anche
    se il file esiste, e' fresco di data e la catena ha risposto "tutto ok".
    Il 19/09 la riparazione del VPS ha dato verdetto "A = canale vivo" con
    16 eventi tutti fra il 14 e il 18/09: catena giusta, contenuto inutile.
    Da qui in avanti il numero che conta si stampa accanto al totale.
    """
    adesso = datetime.now(ZoneInfo(tz_name))
    return sum(1 for r in rows if r.dt > adesso)


if __name__ == "__main__":
    out = sys.argv[1] if len(sys.argv) > 1 else "abtg_news.csv"
    rows = collect_news()
    n = write_abtg_news(out, rows=rows)      # CLASSE 461: non riscaricare
    futuri = conta_futuri(rows)
    print(f"Scritte {n} righe in {out}  ({futuri} ancora DA VENIRE)")
    print("Riepilogo:", summarize(rows))
    for r in rows:
        if "ecb" in r.title.lower() or "fomc" in r.title.lower():
            print("  ", r.dt.strftime("%Y.%m.%d %H:%M"), r.currency, r.title)
    # CLASSE 461 -- QUANDO SI VA ROSSI, E QUANDO NO.
    # La prima stesura (classe 460) usciva 1 ogni volta che gli eventi futuri
    # erano zero. Sbagliata, e lo dice il calendario: con il solo feed
    # `thisweek` vivo, dal venerdi' sera alla domenica sera NON CI SONO piu'
    # eventi futuri nella settimana corrente -- quindi il workflow sarebbe
    # andato rosso ogni fine settimana, da sano. Un cancello che grida al lupo
    # ogni sabato si impara a ignorare, ed e' il difetto che CLAUDE.md nomina
    # per primo. Quindi:
    #   ROSSO  = il feed OBBLIGATORIO e' caduto. Non e' ambiguo: e' un guasto.
    #   GIALLO = zero eventi futuri con i feed a posto. E' il buco strutturale
    #            dei 404 (manca la settimana prossima), va DETTO forte ma non
    #            e' un guasto di oggi.
    if FALLITI_OBBLIGATORI:
        print("[ERRORE] il feed OBBLIGATORIO e' caduto: "
              + ", ".join(FALLITI_OBBLIGATORI)
              + ". Il file gia' in repo NON viene sovrascritto.", file=sys.stderr)
        sys.exit(1)
    if futuri == 0:
        print("[AVVISO] il calendario non contiene NESSUN evento futuro: per un"
              " filtro news e' come essere spento fino al prossimo evento."
              " Con il solo feed 'thisweek' vivo questo e' NORMALE dal venerdi'"
              " sera alla domenica. Se succede in settimana, guarda le righe"
              " [ERRORE] dei feed qui sopra.", file=sys.stderr)
