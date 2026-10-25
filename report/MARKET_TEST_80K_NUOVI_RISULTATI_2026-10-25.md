# Test a fondo a 80.000 EUR degli 8 EA del Market: risultati (25/10/2026)
**Natura: MISURA + LETTURA.** Criteri e previsioni: `MARKET_TEST_80K_NUOVI_ATTESE_2026-10-25.md` (commit 03df470a, scritti prima dei numeri). Lettore congelato `backtest_pipeline/leggi_deep80k_nuovi.py` (commit 9d2608e7). Archivio: `backtest_pipeline/risultati_archivio/DEEP80K_MARKET_NUOVI_20261025` (il report di SixtyNine e' compresso .gz, 55 MB; i log del tester sono stati tolti). PC di backtest, XAUUSD H1, 01/01/2025-01/10/2026, tick reali 100%, 80.000 EUR, leva 1:100, input di default.
**Una correzione al lettore, dichiarata:** lo zip del 25/10 ha i report in `report\` e il lettore li cercava nella cartella dell'EA; ho aggiunto solo la ricerca in `report\` (percorso), nessun criterio toccato; autotest rifatto, OK. Prima di quella correzione avevo visto soltanto il riepilogo meccanico (netto e DD del manifest).

## Esito per le soglie scritte (letto dal lettore, nessuna soglia ritoccata)
**Nessun EA passa tutte le soglie.** Corse tutte valide (OK, nessuno stop out, nessun no-money, input identici al setaccio per tutti e 8).

| EA | op | netto EUR | PF | mesi + | meta' 1 / meta' 2 | DD equity dal picco | lotto max/min | esito |
|---|---|---|---|---|---|---|---|---|
| Umbra Vault AI EA | 434 | +195.101 | 6,20 | 19/21 | + / + | 21.195 (11,2% del picco) | 3,5 | NO: S-DD, S-NOSCALA |
| Gold Snap | 209 | +1.021.632 | 3,09 | 21/21 | + / + | 117.937 (12,4%) | 9,8 | NO: S-DD, S-NOSCALA |
| SixtyNine EA | 1127 | +302.346 | 1,99 | 16/21 | + / + | 42.899 (12,1%) | 5,2; fino a 7 posizioni insieme | NO: S-DD, S-NOSCALA |
| Microedge Neural Matrix EA | 304 | +112.199 | 2,81 | 17/21 | + / + | 27.755 (13,7%) | 2,5 | NO: solo S-DD |
| Rocket Breakout EA | 232 | +60.499 | 1,40 | 16/21 | + / + | 13.105 (8,9%) | 9,9 | NO: S-DD, S-NOSCALA |
| Vortex Turbo EA | 940 | +55.348 | 1,48 | 19/21 | + / **-24.490** | 48.522 (29,7%) | 16,4; fino a 4 posizioni | NO: S-H, S-DD, S-NOSCALA, S-COSTO (2,7x) |
| Entry Points Pro Robot | 224 | +3.038 | 1,06 | 10/21 | + / - | 8.636 (9,7%) | 31,5 | NO: S-M, S-H, S-DD, S-NOSCALA |
| ORB Revolution | 147 | -6.414 | 0,88 | 7/21 | - / - | 10.755 (13,3%) | 18,4 | NON MISURATO (147 < 150); comunque S-M, S-H, S-COSTO negativi |

S-DD e' la regola scritta il 25/10: DD equity ASSOLUTO <= 8.000 EUR (10% di 80.000). Lo stesso metro che il 19/10 ha dato NO a Prop Firm Gold EA (11.023 EUR). Nessun EA lo rispetta, nemmeno Entry Points (8.636) o Rocket Breakout (13.105).

## Cosa significa il "NO" qui (lettura, non una soglia nuova)
- **Quasi tutti scalano il lotto da soli**: nei default usano il dimensionamento automatico (`InpLotMethod=7` con `InpRiskPct=2.0` per Gold Snap, `AutoLotEnabled=true` per Umbra, `autoLot=true` per Microedge, `LotsMode=0/Risk=1.0` per SixtyNine: letti dal referto). Il saldo cresce (Gold Snap 13,8x, SixtyNine 4,8x, Umbra 3,4x) e il lotto con lui: Gold Snap passa da 6,0 lotti nei primi tre mesi a **45,1** negli ultimi tre; Umbra da 2,5 a 7,8; SixtyNine da 0,8 a 3,3. Per questo S-NOSCALA e il DD in EUR falliscono per costruzione. **Non e' martingala**: il lotto dopo una perdita / dopo una vincita e' 0,92-1,26 per tutti (indice: sopra 1,5 sarebbe un campanello).
- **Numeri irreali da non prendere per buoni**: 45 lotti sull'oro (4.500 once) e +1.021.632 EUR in 21 mesi sono fuori da cio che il tester sa dire su slippage, liquidita, margine e regole di una prop. Il tester non li misura (NON MISURABILE qui).
- **DD relativo (POST-HOC, calcolato dopo aver visto i numeri, non e' una soglia)**: DD dal picco del report 8,9-13,7% per i sei migliori (Rocket 8,9; Umbra 11,2; SixtyNine 12,1; Gold Snap 12,4; ORB 13,3; Microedge 13,7), Vortex 29,7%. DD sul solo saldo realizzato: 8,1-11,7% (Vortex 28,9%). Peggior mese realizzato in % del saldo di inizio mese: da -3,8% (Entry Points) a -11,7% (SixtyNine), Vortex -21,8%.
- **Primi 6 mesi (POST-HOC)**, quando il lotto e' ancora quello di 80.000: netto e DD dal picco in EUR sul solo realizzato: Gold Snap +77.011 / 5.248 (6,6% di 80K); Umbra +23.003 / 7.535 (9,4%); Microedge +31.337 / 9.194 (11,5%); Rocket +13.275 / 6.898 (8,6%); SixtyNine +7.256 / 6.495 (8,1%); Vortex +22.023 / 707; Entry Points +7.355 / 3.548; ORB -1.870 / 6.264. Il realizzato non vede il flottante: e' una stima per difetto del DD vero.
- Vortex Turbo: 19 mesi positivi di fila di piccola entita', poi giugno -11.244 e luglio -26.780 (2026): un profilo da coda (guadagni piccoli, perdita grossa).

## Previsioni scritte prima (P1-P7)
P1 corse valide >= 6 su 8: **SI** (8/8). P2 almeno 4 EA sotto 150 operazioni: **NO** (solo ORB, 147). P3 nessun EA passa tutto: **SI**. P4 PF a 21 mesi sotto meta' di quello del setaccio per Umbra, Microedge, Gold Snap: **SI** (16,4->6,2; 34,7->2,8; Gold Snap era "tutte vincenti" -> 3,09). P5 almeno un EA con DD > 10% di 80K dopo DD < 6% nei due mesi: **SI** (Umbra, Microedge, SixtyNine, Gold Snap, Rocket). P6 rapporto lotti > 3 in almeno 3 EA: **SI** (7 su 8). P7 ORB opera molto meno di 150: **NO** (147). 5 su 7.

## Cosa NON e' deciso
- Nessun acquisto, nessuna taglia, nessun lotto: **sono tue decisioni**. Questo test dice solo come si comportano i default a 80.000 e che cosa li rende "NO" per le soglie scritte.
- Il test e' sul default (dimensionamento automatico). **Un test con lotto fisso o rischio piu basso sarebbe una misura diversa** (i lotti li scegli tu, non io): finche' non esiste, "NO" per S-DD/S-NOSCALA significa "con i default compone", non "l'EA perde".
- S-CORR e S-PORT non sono stati calcolati: nessun EA arriva a quella fase.
- Sono 21 mesi con default del venditore (possibile ottimizzazione sul periodo): il 2026 da solo e' positivo per tutti tranne ORB (+1.286 anche lui) e Entry Points (+1.068), cioe' non c'e' nessun EA con il 2026 negativo; Vortex 2026 +6.061 ma con -24.490 nella seconda meta'.
- SomaGold e' a parte (seconda ipotesi in attesa), come Aetheris e Diagonal Resistance.
