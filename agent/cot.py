"""Posizionamento COT (Commitments of Traders) dalla CFTC.

Scarica il report settimanale "Legacy - Futures Only" dal portale dati
pubblico della CFTC (Socrata, nessuna chiave richiesta) per Oro e le 6
valute majors, e calcola il posizionamento NETTO dei Non-Commercial (i
"grandi speculatori") e la variazione settimanale.

Uso analitico: un net-long forte e crescente segnala bias rialzista
speculativo (e viceversa); estremi molto sbilanciati avvertono del rischio
di "unwind" violento (chiusura forzata delle posizioni).

⚠️ Dato con lag strutturale: rilevato il martedì, pubblicato il venerdì
successivo. Va usato come contesto di fondo, non come segnale intraday.
Se la rete non risponde, le funzioni restituiscono lista vuota e il report
prosegue lo stesso (nessun blocco).
"""

from __future__ import annotations

from dataclasses import dataclass

import requests

# Endpoint Socrata della CFTC: Legacy Futures-Only.
CFTC_URL = "https://publicreporting.cftc.gov/resource/6dca-aqww.json"

# Codici contratto CFTC (stabili nel tempo) -> etichetta leggibile.
# Filtrare per codice evita ambiguita' tra contratti con nomi simili.
COT_CONTRACTS: list[tuple[str, str, str]] = [
    # (codice, etichetta, valuta/asset)
    ("088691", "Oro (COMEX)", "XAU"),
    ("099741", "Euro (EUR)", "EUR"),
    ("096742", "Sterlina (GBP)", "GBP"),
    ("097741", "Yen (JPY)", "JPY"),
    ("092741", "Franco svizzero (CHF)", "CHF"),
    ("232741", "Dollaro australiano (AUD)", "AUD"),
    ("090741", "Dollaro canadese (CAD)", "CAD"),
]


@dataclass
class CotRow:
    label: str
    asset: str
    report_date: str        # YYYY-MM-DD della rilevazione (martedì)
    noncomm_net: int        # Non-Commercial long - short (grandi speculatori)
    noncomm_net_prev: int   # settimana precedente
    change: int             # variazione settimanale del netto
    open_interest: int

    @property
    def bias(self) -> str:
        if self.noncomm_net > 0:
            base = "net-long (spec. rialzisti)"
        elif self.noncomm_net < 0:
            base = "net-short (spec. ribassisti)"
        else:
            base = "neutro"
        if self.change > 0:
            trend = "in aumento"
        elif self.change < 0:
            trend = "in calo"
        else:
            trend = "stabile"
        return f"{base}, {trend}"


def _to_int(v) -> int:
    try:
        return int(float(v))
    except (TypeError, ValueError):
        return 0


def _fetch_contract(code: str, label: str, asset: str, timeout: int) -> CotRow | None:
    """Ultime 2 rilevazioni di un contratto -> netto + variazione."""
    params = {
        "cftc_contract_market_code": code,
        "$select": ("report_date_as_yyyy_mm_dd,open_interest_all,"
                    "noncomm_positions_long_all,noncomm_positions_short_all"),
        "$order": "report_date_as_yyyy_mm_dd DESC",
        "$limit": "2",
    }
    try:
        resp = requests.get(CFTC_URL, params=params, timeout=timeout,
                            headers={"User-Agent": "market-agent/1.0"})
        resp.raise_for_status()
        data = resp.json()
    except Exception:
        return None
    if not data:
        return None

    def net(row) -> int:
        return _to_int(row.get("noncomm_positions_long_all")) - \
               _to_int(row.get("noncomm_positions_short_all"))

    last = data[0]
    net_last = net(last)
    net_prev = net(data[1]) if len(data) > 1 else net_last
    date = str(last.get("report_date_as_yyyy_mm_dd", ""))[:10]
    return CotRow(
        label=label, asset=asset, report_date=date,
        noncomm_net=net_last, noncomm_net_prev=net_prev,
        change=net_last - net_prev,
        open_interest=_to_int(last.get("open_interest_all")),
    )


def fetch_cot(timeout: int = 20) -> list[CotRow]:
    """Posizionamento COT per Oro + 6 majors. [] se la rete non risponde."""
    rows: list[CotRow] = []
    for code, label, asset in COT_CONTRACTS:
        r = _fetch_contract(code, label, asset, timeout)
        if r is not None:
            rows.append(r)
    return rows


def cot_currency_bias(rows: list[CotRow]) -> dict[str, int]:
    """Mappa valuta/asset -> segno del netto (+1 long, -1 short, 0 n/d)."""
    out: dict[str, int] = {}
    for r in rows:
        out[r.asset] = (1 if r.noncomm_net > 0 else (-1 if r.noncomm_net < 0 else 0))
    return out
