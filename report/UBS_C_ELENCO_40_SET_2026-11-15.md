# UBS C (indici e forex): elenco FISSATO dei 40 set da provare (15/11/2026, scritto PRIMA di qualunque test)

**Natura: scelta per famiglia e simbolo, NON per risultato.** Segue `UBS_OTTIMIZZAZIONE_A_C_CRITERI_2026-11-14.md` (fasi, filtri, regole di arresto) e l'obiettivo di Claudio del 15/11/2026: EA non correlati all'oro, "aperture" (ORB) e forex. Pacchetto di base: **V9.0** (382 set; U5 ha mostrato che le differenze con i 283 sull'oro sono piccole). Fonte: `UBS_CATALOGO_dati/catalogo_UPDATED_SETS_V9_0_382set.csv`. Regola di scelta: per ogni famiglia/simbolo, tutti i set elencati o i primi N in ordine alfabetico dopo aver tolto i doppioni di nome; nessuna scelta guardando risultati.

## Indici (20)
- **ORB Master (12, tutti)**: USTEC_M15_a, USTEC_M15_e, USTEC_M15_g; DAX_M15_a, DAX_M15_c, DAX_M15_f; US30_M15_c, US30_M15_f, US30_M15_h; US500_M15_a, US500_M15_c, US500_M15_d. M15, filtro NFP acceso, flag fuso orario acceso.
- **Volatility Breakout (6)**: NAS_VOL_M15_A, NAS_VOL_M15_B; US30_VOL_M15_a, US30_VOL_M15_b; VolUS500_a, VolUS500_c.
- **Indicement (2)**: US500a, US100_1.

## Forex (20)
- **Volatility Breakout EURUSD M15 (4)**: EURUSD_M15_VolBrk_C10, _C20, _C37, _C63 (rischio 123).
- **Volatility Breakout EURUSD (4)**: EURUSD_e, EURUSD_f, EURUSD_k, EURUSD_o (filtro spread).
- **Advanced Scalper (5)**: eurusd_H1_SL17, eurusd_H1_SL22, usdjpy_H1_SL22, usdjpy_H4_SL14, gbpusd_H1.
- **Other sets (3)**: eurusd_a, eurusd_b, gbpusd_a (D1).
- **Client sets USDJPY (4)**: 9637034_Till_UBS-USDJPY-D1-HJP09, 9637035_Till_UBS-USDJPY-D1-HJP10, 9637057_hangsan_1, 9637058_hangsan_4 (D1).

## Cosa dobbiamo sapere PRIMA (nessuno di questi punti e verificato)
1. **Simboli e dati BCM**: nomi (DAX = D30EUR? Nasdaq = NASUSD o NASUSD_EXT, S&P = SPXUSD o _EXT, Dow = U30USD) e copertura M1 per anno. Riga di sola lettura pronta (elenca gli storici del terminale BCM). I set hanno `ForceSymbol`: va impostato col nome BCM.
2. **Fuso orario**: ORB e Indicement usano orari di sessione; server BCM GMT+1 fisso: ora legale = Italia -1, inverno = Italia (regola di casa). Per i test: separare estate e inverno o dichiarare il limite. I campi `tz` dei set vanno letti. Per Nasdaq/S&P `_EXT` l'apertura USA a 14:30 anche in inverno e a 13:30 in due settimane l'anno (diagnostica del 04/11).
3. **ORB Master**: Wim (08/10) l'ha dichiarato "NOT RECOMMENDED TO BUY"; dati live riportati su Discord: -10,8% con PF 0,86 e DD 17% (non verificati); Myfxbook easyalgos: -4,6% con DD 50%. **Prior sfavorevole**: la previsione e che pochi ORB passino.
4. **Contract size e DD01**: `HistoricalMaxDD` dei set e del broker di Wim: rimisurare a BCM (come U1b).
5. **Costi FTMO sugli indici** (misurati sulla challenge): commissione 0; slippage entrate stop/limit circa 0 in media, uscita a stop DAX circa 0,8 punti, Dow 7,8 punti in una mossa veloce.

## Previsioni (da `UBS_OTTIMIZZAZIONE_A_C_CRITERI_2026-11-14.md`, ribadite)
O-1 40 set testabili: 60%; O-2 passa il 10-40% in Fase 2: 60% (meno del 10%: 25%); O-4 dopo i tick restano >= 3: 55%, zero: 25%. **Aggiunta sugli ORB:** al massimo 2 dei 12 ORB passano la Fase 2: 75%.
