# Stato a fine serata 22/10/2026 e prossimi passi (Claudio a letto, Claude resta in comando solo per carte e righe)

**Limite**: Claude non ha accesso al PC di backtest ne al VPS e non puo lanciare righe. Il runner notturno del VPS ha le righe ROUND sospese dal 21/09 e non viene riattivato. Tutto cio che richiede una macchina aspetta Claudio.

## Letto oggi (tutto archiviato e pushato su `lavoro`)
- PF3 (Prop Firm su BCM, rischio 0,25/0,5/0,75%): `PROPFIRM_RISCHIO_BASSO_LETTURA_2026-10-22.md`.
- PF4 (Prop Firm su FundedNext): `PROPFIRM_GMT_FUNDEDNEXT_LETTURA_2026-10-22.md`. In sospeso per scelta di Claudio.
- R277 (regola di Emiliano sul Nasdaq): `R277_EMILIANO_NASDAQ_LETTURA_2026-10-22.md`.
- Webinar 22/10: `ANALISI_LIVE_EMILIANO_2026-10-22_WEBINAR_LEZIONE4.md`.

## Righe pronte da incollare sul PC DESKTOP-H4D7CAJ (MT5 chiuso, una dopo l'altra)
1. `RIGA_LANCIA_R278_DOW.txt` (pin eec5e0f6): la regola dei 5 minuti sul Dow, 12 passate, circa 6-10 minuti. Zip `ROUND_R278_<data>.zip`. Lettore `r278_giudizio.py`.
2. `RIGA_LANCIA_R279_NASDAQ_INVERNO.txt` (stesso pin): la regola sul Nasdaq d'inverno con apertura 15:30 server, 16 passate, circa 4-8 minuti. Zip `ROUND_R279_<data>.zip`. Lettore `r279_giudizio.py`.
Attese e criteri congelati dentro i file prova `backtest_pipeline/prove/R278*.txt` e `R279*.txt`.

## Scadenze vere
- **Lun 26/10**: BCM (UTC+1 fisso) = ora italiana. Controllo dal vivo sul terminale 50503392: ora dell'ultima candela M1 contro l'orologio di Windows (OROLOGIO par. 6.3).
- **Entro 25/10 (DAX) e 01/11 (USA)**: decisioni di Claudio sull'orologio, vedi `DECISIONE_OROLOGIO_INVERNALE_BCM_2026-10-11.md` (sedie con ora fissa ancora attive: MaxMinNotte oro 770402, ORB argento, ORB EURAUD sul reale 10105439, EasyTrend, PostNews; FOMC del 09/12 da portare a 20:40/21:45; Guardian reset 23 diventa 23:00 italiane).
- Nessun preset, sedia, conto o taglia e stato toccato.

## In sospeso
Prop Firm (build nuova del .ex5, tick reali, forward), R276b (passata singola, bassa priorita), DAX Morning Scalp, EA di Wim, comodita di lancio da cellulare.
