# 🚨 RILIEVO — 5 round della notte 12/13-09 segnalano un terminale NON bersaglio sparito

> ## ✏️ ERRATA DEL 13/09/2026 (architetto-prop, stesso giorno) — **LA CAUSA SCRITTA QUI SOTTO NON E' L'UNICA POSSIBILE, E PROBABILMENTE NON E' QUELLA**
>
> 🔴 **Cosa non regge**: qui (e nella **classe 309**) c'e' scritto che l'uscita 3
> significa *"esclusivamente"* un PID non bersaglio sparito. **Falsificato
> leggendo il codice**: `RIGA_ROUND_VPS.ps1` **r.745** e'
> `elseif($persi.Count -gt 0 **-or** $RILIEVI.Count -gt 0)` — l'uscita 3 scatta su
> **QUALUNQUE** rilievo, e i punti che ne generano uno sono **TRE**: **r.408**
> (`-Modello` diverso da 4: *"screening, non verdetto"*), **r.572** (tetto barre
> non verificabile), **r.725** (PID spariti).
>
> 🟢 **E la misura che sceglie fra le due spiegazioni**: incrociando `-Modello` e
> codice d'uscita sulle 36 righe ROUND del referto esce
> **`(Modello 4, uscita 0) = 30` · `(Modello 1, uscita 3) = 5` · `(Modello 4,
> uscita 2) = 1`**. 👉 **I 5 round a uscita 3 sono ESATTAMENTE i 5 lanciati a
> `-Modello 1`, e nessuno dei 31 a tick reali esce 3.** Il rilievo di r.408
> scatta **per costruzione** su ogni round OHLC: **non serve nessun terminale
> sparito per spiegare i cinque eventi.**
>
> ⚖️ **Cosa NON dimostra l'errata** (contro-esempio contro l'errata stessa): i due
> rilievi **possono essere scattati insieme**, e il log per-round e' stato
> sovrascritto (classe 307). Quindi **il rilievo resta APERTO** — ma l'ipotesi
> alternativa chiede **cinque** sparizioni-e-rientri, ognuna **esattamente**
> durante un round OHLC e **mai** durante i 31 a tick reali, con `r126a`
> (uscita **0**) proprio **in mezzo** fra `r127c` e `r127b`.
>
> ✅ **Quindi il punto 1 di "COSA SERVE PER CHIUDERE" qui sotto NON e' piu' la
> prima mossa.** La prima mossa e' il **punto 2**, e la domanda e' cambiata: nel
> referto dentro ogni zip l'esito e' `ROUND GIRATO CON RILIEVI (N)` (r.746).
> **N=1 → era solo il modello, il rilievo si chiude. N=2 → allora si', e allora
> si guarda il Giornale del reale `10105439`.** Dettaglio: `report/PIANO_PROP.md`
> **AREA K, riga K2** · buco **M42**.

**Turno continuo del 13/09, 09:11.** Verificato alla FONTE (codice, non riassunto):
il referto di stanotte (`REFERTO_RUNNER_20260913_033003.txt`) segnava **6 falliti** su
42 righe. Ieri erano stati letti come "6 round da diagnosticare, dati persi per il log
condiviso (classe 307)". **Non è tutta la storia.**

---

## 🔴 IL FATTO

`RIGA_ROUND_VPS.ps1` ha **tre** esiti possibili, non due:
- **exit 0** = `ROUND GIRATO` — tutto bene.
- **exit 2** = `NON MISURATO` — CSV mancanti/vuoti o zero trade. Problema di **dati**.
- **exit 3** = `ROUND GIRATO CON RILIEVI` — i CSV possono anche essere usciti bene: il
  codice segnala che **un terminale MT5 NON bersaglio, vivo prima della corsa, non è più
  vivo dopo** (r.717 `$persi`, r.725: *"CONTROLLA SUBITO IL CONTO REALE 10105439"*).

Dei 6 falliti di stanotte:
- **1** (`cemad02`) è exit 2 → problema di dati, non di sicurezza.
- **5** (`r127c`, `r127b`, `r139a`, `r139b`, `r139c`) sono **exit 3** → il parco
  terminali (che include forward E il conto REALE 10105439) ha perso un PID durante
  quella corsa.

## 🕐 QUANDO, con precisione al secondo (ora locale VPS, ricalcolato e verificato)

| round | inizio | fine |
|---|---|---|
| `r127c` (CostToCost) | 04:21:07 | 04:22:46 |
| `r127b` (SupertrendReversal XAUUSD) | 04:57:48 | 05:17:35 |
| `r139a` (EMA200 AUDJPY H4) | 07:46:44 | 07:53:58 |
| `r139b` (EMA200 GBPUSD H4) | 07:53:58 | 08:00:23 |
| `r139c` (FiboH4_Multi GBPUSD) | 08:00:23 | 08:07:59 |

Due finestre: **04:21-05:18** e **07:47-08:08**.

## ⚖️ COSA QUESTO NON DIMOSTRA, e va detto con la stessa forza

- **Non prova un guasto o un danno.** Il round successivo a ciascuna finestra (`R126a`
  dalle 04:22, e tutto ciò che segue le 08:08) è tornato a **exit 0** — cioè al giro
  dopo, tutti i PID non bersaglio risultavano di nuovo presenti. Potrebbe essere stato
  un riavvio pianificato di Windows, un intervento manuale, o qualcosa che merita
  attenzione. **Non lo so, e non lo invento.**
- **Non so QUALE dei terminali** (piccolo 50503392, 100k 50504263, reale 10105439,
  MT5_MANUALE) sia sparito in ciascun evento: quel dettaglio sta SOLO nel log per-round
  (`RIGA_SOTTILE_ROUND_*.log`), che il difetto classe 307 sovrascrive a ogni riga — nel
  repo resta solo il log dell'ultimo round della notte (`r142c`), che infatti mostra
  **tutti e 4 i PID non bersaglio presenti e stabili**, incluso `C:\BCM_Reale` (PID
  7824) — ma quello è lo stato delle **08:30**, non delle due finestre sopra.

## ✅ COSA SERVE PER CHIUDERE IL RILIEVO

1. **Il conto reale 10105439** va controllato (Giornale/Esperti del terminale
   `C:\BCM_Reale`) nelle due finestre `04:21-05:18` e `07:47-08:08` di stanotte: c'è
   un riavvio, un errore, una disconnessione registrata lì?
2. Recuperare gli **zip dei 5 round** (`Desktop\ROUND_r127c.zip`,
   `ROUND_r127b.zip`, `ROUND_r139a.zip`, `ROUND_r139b.zip`, `ROUND_r139c.zip`) dal
   VPS: ognuno contiene il referto con la riga **"MANCANO ALL'APPELLO: PID ..."**, che
   dice esattamente quale terminale è sparito.
3. Fino ad allora il rilievo resta **aperto, non archiviato**: cinque eventi nella
   stessa notte, in due finestre distinte, non sono un caso isolato da liquidare.

Loggato come **classe 309** in `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md`: il
codice d'uscita di un round non si legge come "fallito/non fallito", si legge riga per
riga nello script che lo produce.

---

## 🟢 E LA NOTIZIA BUONA, nello stesso referto

Il "tappo" descritto in `IL_TAPPO_2026-09-11.md` (R120/R125/R126/R127 "mai girati") si
sta sciogliendo per davvero: stanotte sono girati con **exit 0** (dati prodotti, in
attesa di lettura una volta caricati i CSV dal VPS): `R132c`, `R133b`, `R133c`,
`R136a-d`, `R126a`, `R126b`, `R126d`, `cemad05`, `R120b` (4 varianti), `R120e` (2
varianti), `canfrz`, `R137a-c`, `R138a`, `R141a-d`, `q770be`, `R142a-c`. **~30 round
con dati veri, pronti da leggere appena arrivano i CSV.**
