# ABTG_ORB_Emiliano v1.00 -- sala del consiglio V2 (23/10/2026)

**Stato: scritta, REVISIONATA da 2 agenti in lettura, MAI COMPILATA, MAI PROVATA.** Massimo esito possibile oggi: VALIDAZIONE_NECESSARIA. Prima prova: round R283 (prove R283a-d, lettore `backtest_pipeline/r283_giudizio.py`).

## Requisiti (dalle trascrizioni di Emiliano e dall'indicatore ORB_V15 1.14)
| # | Requisito | Stato nell'EA |
|---|---|---|
| R001 | Candela M5 14:25:00-14:29:59 server | `InpRangeEndExcl` (opt-in). Con 0 (v1.04) la barra M1 delle 14:30 entra nel range: difetto trovato dai revisori |
| R002 | Due pendenti a 10 punti oltre il range, K per strumento | `InpEntryPoints` x `KEff()`; `InpAutoK` opt-in. XAGUSD NON e' in tabella (usa InpK) |
| R003 | Filtro ampiezza (Nasdaq 17-38) | `InpMinRangeK/InpMaxRangeK`; per il Dow le soglie NON sono state dette: spento |
| R004 | Piano A (50 punti -> pari, meta' chiusa, resto in trailing EMA9) | `ManagePlanA`, per TICKET; runner sospeso finche' il Piano A non e' concluso |
| R005 | Fine giornata 22:59:59 | `DayEndMin()` limitato a 1439 |
| R006 | Festivi NYSE, ora solare USA | copiati dal Sicuro (compilato), +60 min con `InpAutoUSDST` |

## NON implementato (dichiarato)
Piano B; stop a tempo di 6 minuti; riarmo dopo rifiuto del broker (ora solo il log del retcode); anti-duplicato dopo un riavvio. **Stop e target finali di Emiliano non sono stati detti**: assunti (stop all'estremo opposto, TP 2R, trailing EMA9) e da misurare.

## Difetti trovati dai revisori e corretti (commit de9ac539)
1. Range include la barra delle 14:30 -> `InpRangeEndExcl`; rifiuto silenzioso dei pendenti -> log.
2. `gPlanA` per giorno e messo prima del pareggio -> `gPlanATk`/`gPlanAParzTk` per ticket, pareggio ritentato (max 20), mai due parziali.
3. Trailing EMA9 portava lo stop oltre il pari prima di +50 e annullava il Piano A -> runner sospeso fino al Piano A.
4. `DayEndMin` oltre 1439 -> `MathMin(1439,...)`; log del fuso server (solo live) se `InpAutoUSDST`.
5. `InpMaxLateMin=0` nei set -> 5; limite esteso alla fase ARMED.
6. Testo dell'intestazione (argento, Piano A spegne InpBreakeven/TP1Pct) e log "resta la gestione normale" corretti. Tolleranza 1e-9 sul filtro K.

## Verifiche fatte e NON fatte
Fatto (lettura): bilanciamento parentesi, nessuna funzione duplicata, funzioni chiamate definite, default = v1.04 per lettura, calendario NYSE 2026-27 ricalcolato, tabella K = parametri V17 in `docs/live_paolo`. **Non fatto: compilazione in MetaEditor, non-regressione al centesimo in tester (e' R283b contro R283a), comportamento reale di EndOfDay a 23:59 su un CFD con pausa serale, Guardian oltre la firma.**

## Rischi aperti
- Server BCM = UTC+1 fisso e' un'ipotesi da CLAUDE.md ("1 ora indietro, in questo periodo"): se segue l'ora italiana, +60 d'inverno sbaglia di un'ora.
- Un solo regime (2024-26, toro); lo storico esterno si usa solo dopo la firma di perimetro (NASUSD_EXT).
- Ordine dei risultati R283c/d: prova di impianto, non giudizio sulla regola.
