# Sonde senza macchina di backtest: risultato S4 e istruzioni per S1-S3 (23/10/2026)
Criteri scritti PRIMA (commit decf23ef): `report/SONDE_SENZA_MACCHINA_CRITERI_2026-10-23.md`. **Sola lettura: nessun ordine, test, modifica a EA/set/sedie/conti.**

## S4 -- giorni di chiusura nei per-trade OOS (ESEGUITA dal cloud: `backtest_pipeline/sonda_festivi_pertrade.py`)
Fonte: `backtest_pipeline/risultati_prove/trades_portafoglio/*.csv`, solo gamba OOS (giugno 2025 - giugno 2026). Per-posizione = somma dei deal in uscita. L'elenco dei giorni e' della mia conoscenza, non verificato su fonte ufficiale (scritto prima di leggere).
| EA | Posizioni | NYSE/Xetra chiuso | Mezza sessione | PF tutti -> senza i giorni dell'elenco | Criterio >= 3% |
|---|---|---|---|---|---|
| Dow Apertura 770206 | 96, netto 6722 | 5 (5,2%), netto **-1106** | 3 (3,1%), netto **+3475** | 1,270 -> 1,185 | MATERIALE |
| ORB 770612 | 119, netto 41057 | 2 (1,7%), netto **-2239** | 2 (1,7%), netto **+5195** | 1,674 -> 1,650 | MATERIALE (3,4%) |
| DAX Apertura 770115 | 193, netto 18030 | 0 | - | 1,397 | non materiale |
| MaxMin DAX short 770413 | 14, netto 6143 | 0 | - | 2,160 | non materiale |
- **Il PF 1,270 del Dow e 1,674 dell'ORB coincidono con R101 e R283a**, quindi questi per-trade sono la cella viva (DERIVATO dal confronto dei numeri).
- **Sui giorni di chiusura USA le due sedie hanno operato** (BCM quota l'indice anche li') e hanno perso: Dow 2025-07-04, 09-01, 11-27, 2026-05-25 e 06-19; ORB 11-27 e 05-25. Il peggiore: 2026-05-25 (Memorial Day) Dow -1065 e ORB -1419.
- **Sulle mezze sessioni invece pesano i vincitori:** 2025-11-28 (Dow +1297), 2025-12-24 (Dow +2133, ORB +3286), 2025-07-03 (ORB +1909). **Due giorni (28/11 e 24/12) valgono il 51% del netto OOS del Dow** (3430 su 6722: DERIVATO).
- Per DAX e MaxMin nessuna posizione nei giorni Xetra chiusi dell'elenco: o BCM non quotava, o l'EA non ha operato; **NON si sa quale**.
- Lettura: il filtro festivi dell'`_Sicuro` (`InpSkipUSHolidays`, solo giorni di chiusura) tagliarebbe le perdite dei giorni chiusi (Dow +1106, ORB +2239 sul netto OOS), **non** i vincitori di mezza sessione. **E' descrittivo: non promuove nulla ne' dice che il PF migliora** (campione 5 e 2 giorni, un solo regime). Il caso Dow/ORB e' coperto anche dal quesito "filtro festivi" gia' misurato per il Nasdaq (R282b).

## S1-S3 -- lo script (da far girare su un terminale; NON eseguibile dal cloud)
File: `mql5/Scripts/ABTG_SondeAperture.mq5` -- **SOLA LETTURA, nessuna funzione di trading** (grep di Order/Trade/Position: zero), **NON compilato** (parentesi bilanciate verificate; la compilazione in MetaEditor e' il primo controllo). Lettore congelato: `backtest_pipeline/sonde_giudizio.py` (autotest 9 casi OK).
**Come:**
1. Su un terminale BCM che veda U30USD, D30EUR e SPXUSD (consiglio il PC di backtest, **fuori dal tester e prima di lanciare qualunque round**: il driver si ferma se MT5 e' aperto): `File > Apri cartella dati`, copia lo script in `MQL5\\Scripts`.
2. In MetaEditor premi F7 (deve dire 0 errori). Se ne da', mandami il testo e correggo.
3. **Controlla i grafici: se ci sono sedie attaccate, non toccarle e non premere il pulsante generale Algo Trading.** Apri un grafico qualsiasi **senza EA**, trascina lo script (si apre la finestra Input: i default vanno bene) e premi OK.
4. Lo script gira da solo (circa 1-3 minuti: S1 fa 20 iterazioni con attese). Nel registro "Esperti" compaiono le righe `S1:`, `S2:`, `S3:`.
5. I tre file `ABTG_SONDA_SPX.csv`, `ABTG_SONDA_ORB.csv`, `ABTG_SONDA_BOX.csv` sono in `C:\\Users\\<utente>\\AppData\\Roaming\\MetaQuotes\\Terminal\\Common\\Files`. Mandameli senza aprirli; li leggo con `python3 backtest_pipeline/sonde_giudizio.py <cartella>`.
**Limiti:** S1 con la cache di MT5 gia' calda puo' non riprodurre il difetto del live (e l'esito e' "NESSUN DIFETTO RIPRODUCIBILE", non "il filtro funziona"); S2 e' un limite superiore; la storia M1 disponibile sul terminale puo' essere piu' corta di 450 giorni; il terminale e' loggato sul demo 50503392 (nessun ordine parte dallo script).
