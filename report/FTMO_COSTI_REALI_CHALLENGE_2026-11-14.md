# Costi REALI di FTMO misurati sulla challenge 80k 2-Step 541452707 (21-30/09/2026) e sulla Free Trial (14/11/2026)

**Fonte**: `data/statements/FTMO_541452707_cronistorico_2026-09-30.xlsx` (branch `origin/lavoro`; storico completo, 13 posizioni, 40 ordini) e `FTMO_541452707_chiusura_2026-09-30/README.md`; trial: `LIVE_dati/STORICO_REALE_TRIAL_TABELLE_2026-11-12.xlsx` (solo aggregati per EA). Esito challenge: Max Loss violato il 30/09 (equity 71.968 contro 72.000). Calcolo mio, riproducibile dallo xlsx. **Campione piccolo**: indici DAX (GER40) e Dow (US30) con gli EA, oro solo con 3 lotti MANUALI. Nessun deal degli EA oro nella challenge.

## Commissioni (letto dallo storico)
| Simbolo | Lotti | Commissioni | Per lotto |
|---|---|---|---|
| GER40.cash | 145,4 | 0,00 | **0** |
| US30.cash | 27,62 | 0,00 | **0** |
| XAUUSD | 3,0 | -15,28 EUR | **-5,09 EUR/lotto** (andata+ritorno) |
Coerente con 0,0014% del nozionale su 4.140 USD x 100 oz (circa 5,8 USD = 5,0 EUR) e con la trial (Reaper -11,03 EUR su 2,15 lotti = 5,13/lotto; Phantom -4,41 su 0,86 = 5,13/lotto). **Conferma: commissione oro FTMO circa 5,1 EUR/lotto andata+ritorno**, indici zero.

## Slippage misurato
Ordini limit/stop (entrata, 11 posizioni indici): scarto medio **+0,04 punti** (da -2,92 a +2,25; piu o meno a favore quanto contro) = praticamente zero. Stop-loss (uscite, "contro" positivo):
| Strumento | Stop | Scarto contro (punti) |
|---|---|---|
| GER40 | 7 stop | 0,08 / 0,38 / 0,65 / 0,65 / 0,88 / 1,08 / 1,88, media **0,80 punti** |
| US30 | 2 stop (stessa mossa, stesso prezzo) | **7,83** punti |
| XAUUSD (manuale) | 2 stop | 0,09 e 0,16 USD/oncia = **9-16 USD/lotto**, media circa 12,5 USD (circa 11 EUR/lotto) |
Escluse 2 uscite che erano chiusure parziali a mercato, non stop (GER40 24,59 lotti, US30 4,84 lotti). 1 punto indice = 1 EUR/USD per lotto.

## Spread (UNA fotografia, non una misura)
`PREVOLO_FTMO_specifiche_2026-09-20.csv` (20/09/2026 ore 17:08, subito dopo l'apertura): XAUUSD 47 punti (0,47 USD), GER40 143, US30 263, US100 153, USDJPY 20 punti. **Non rappresentativo**: sono i valori a ridosso dell'apertura di domenica. Lo spread vero durante le ore degli EA oro NON e misurato.

## Cosa cambia per le nostre stime
- Costi "centrali" 36 EUR/lotto oro = commissione + spread + slippage totali sopra il tester. Commissione FTMO oro (5,1) e swap sono gia uguali a BCM nel tester (`FTMO_COSTI_ANALISI_2026-11-11.md`); resta da misurare spread+slippage extra. Lo stop manuale sull'oro (11 EUR/lotto, 2 casi) rientra nella fascia 10-20 EUR/lotto della tabella di sensibilita (centrale 20): **compatibile, non una conferma** (n=2).
- Sugli indici lo slippage e piccolo e simmetrico in entrata; ma uno stop del Dow ha scivolato di 7,83 punti: in giornate veloci gli stop possono costare molto piu della media.
- **Resta NON MISURATO**: slippage e spread degli EA oro su FTMO (Reaper, Phantom, Goldbot, GTP) nelle loro ore; swap oro; slippage sui nuovi ordini pendenti dell'oro; Swing contro Standard.
- Come misurarlo davvero: la Free Trial in corso (1515150476) ha gia ordini oro reali; serve lo storico completo con prezzi richiesti e SL dei suoi deal (non solo gli aggregati), e per lo spread una fotografia a 3-4 orari (08, 09, 15:30 server) di XAUUSD.
