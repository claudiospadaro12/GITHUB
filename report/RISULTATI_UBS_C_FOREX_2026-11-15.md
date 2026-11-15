# UBS C forex — 20 set x 2 periodi (15/11/2026): risultati della Fase 2 (M1)

**Fonte:** `ANNO_ORO_GRADINI_UBSCF_20261115_1641.zip` (riga `553e01e4`, tester pin `70181fd2`, tetto barre 400.000). **40 passate su 40 `OK`**, qualità storico 99–100%, nessuno stop out. Set V9.0 come consegnati, EA `Ultimate_Breakout_EA_WSC_V9.5`, BCM, Modello 1 (NON tick reali), deposito 100.000 EUR, `Risk=0` e `StartLots=0.1` imposti. P1 = 2013-2018, P2 = 2019-2025. Criteri: `UBS_OTTIMIZZAZIONE_A_C_CRITERI_2026-11-14.md` (Fase 2) e `UBS_COMBINAZIONI_PIANO_2026-11-15.md`.

## Controlli fatti
- **Copertura:** ogni finestra ha operazioni in TUTTI gli anni (6 e 7). I dati forex BCM partono davvero dal 2013. Il tetto di barre 100.000 era un falso allarme (148.468 e 173.971 barre M15 senza troncamenti).
- **Lotto NON uguale per tutti.** I set `CLI_*` (client) scalano il lotto col saldo anche con `Risk=0`: HJP09/HJP10 a 0,15-0,9 lotti (media 0,4), **HANG1 a 2,5-4,4** e **HANG4 a 1,2-2,3 lotti**. Tutti gli altri 16 set sono a 0,10 fisso. I netti e i DD dei CLI non sono confrontabili con gli altri.
- **Il PF del report è netto di commissioni/swap** (nei calcoli sui singoli affari uso il profitto lordo, per questo i miei PF sono piu alti: EU_SL17 report 3,13/1,84, affari 3,87/2,21). Le decisioni usano il PF del report.

## Esito per set (criterio: operazioni >= 150 in entrambi i periodi, PF >= 1,20, netto > 0, nessuno stop out)
| Set | Op P1/P2 | PF P1/P2 | Netto P1/P2 (EUR) | DD equity P1/P2 | Esito |
|---|---|---|---|---|---|
| SCALP_EU_SL17 (EURUSD H1) | 1230/1192 | 3,13/1,84 | 3.688/1.833 | 0,11%/0,19% | **PASSA** |
| SCALP_EU_SL22 (EURUSD H1) | 1221/1204 | 3,57/2,15 | 4.126/2.285 | 0,13%/0,10% | **PASSA** |
| SCALP_GU_H1 (GBPUSD H1) | 1038/1041 | 3,39/2,82 | 3.977/2.778 | 0,50%/0,14% | **PASSA** |
| SCALP_UJ_H1 (USDJPY H1) | 1333/1632 | 2,94/2,48 | 3.978/3.864 | 0,09%/0,21% | **PASSA** |
| SCALP_UJ_H4 (USDJPY H4) | 1523/1729 | 1,88/1,70 | 3.574/3.237 | 0,11%/0,23% | **PASSA** |
| VOL_f (EURUSD) | 187/156 | 1,54/1,30 | 886/503 | 0,14%/0,19% | **PASSA** |
| VOL_o (EURUSD) | 199/171 | 1,20/1,40 | 491/818 | 0,23%/0,24% | **PASSA al limite** (PF 1,20) |
| CLI_HANG4 (USDJPY D1) | 235/282 | 1,62/1,35 | 20.116/13.280 | 3,91%/6,55% | passa NUMERICAMENTE, lotto 1,2-2,3 e DD fino a 6,5%: **non confrontabile, rischio alto** |
| VOL_C10 (EURUSD M15) | 169/152 | 1,19/1,46 | 438/930 | 0,44%/0,29% | non passa per 0,01 di PF (fascia "buono ma non abbastanza") |
| OTH_EU_a (EURUSD D1) | 176/206 | 1,25/0,91 | 2.163/-1.171 | 1,12%/3,29% | **NON PASSA** (P2 in perdita) |
| CLI_HANG1 (USDJPY D1) | 195/230 | 1,09/1,69 | 4.480/36.212 | 10,69%/7,14% | **NON PASSA** (PF 1,09 in P1; lotto 2,5-4,4) |
| VOL_C20 | 175/149 | 1,39/1,53 | 780/1.052 | 0,35%/0,41% | NON VALUTABILE (149 op in P2) |
| VOL_C37 | 137/111 | 1,35/1,38 | 605/582 | 0,32%/0,16% | NON VALUTABILE |
| VOL_C63 | 158/130 | 1,61/1,17 | 681/173 | 0,17%/0,22% | NON VALUTABILE |
| VOL_e | 137/106 | 2,04/1,72 | 960/646 | 0,12%/0,14% | NON VALUTABILE |
| VOL_k | 97/89 | 1,48/1,76 | 496/698 | 0,11%/0,17% | NON VALUTABILE |
| OTH_EU_b | 80/107 | 1,38/1,18 | 913/647 | 0,45%/1,11% | NON VALUTABILE |
| OTH_GU_a | 134/159 | 1,67/1,35 | 1.894/1.420 | 0,53%/1,00% | NON VALUTABILE (134 op in P1) |
| CLI_HJP09 | 119/130 | 1,70/1,74 | 1.914/2.077 | 0,58%/0,35% | NON VALUTABILE |
| CLI_HJP10 | 120/129 | 1,81/1,86 | 2.322/2.428 | 0,59%/0,33% | NON VALUTABILE |

**Conteggio:** 8 passano (7 a lotto 0,1 + HANG4 a lotti grandi), 1 al limite, 2 non passano, **9 non valutabili** (sotto 150 operazioni in almeno un periodo). Il criterio di stabilità del DD (rapporto DD01 fra periodi) NON è applicato: il DD01 a 0,01 lotti non è stato misurato per questi set; i DD in % sono 0,1-0,6% per quasi tutti, troppo piccoli per giudicare la stabilità.

## Incertezza (bootstrap sulle operazioni, intervallo 90% del PF sui profitti lordi)
- **Scalper** (oltre 1000 operazioni): intervalli stretti, per esempio EU_SL22 P2 2,16-3,19; il PF resta sopra 1,5 in tutti i casi. I campioni sono grandi.
- **VOL e daily** (100-200 operazioni): intervalli larghi. Per esempio VOL_f P2 1,04-1,82, VOL_o P1 0,99-1,60: il PF vero può essere 1,0.

## Tenuta ai costi (netto medio per operazione a 0,1 lotti, ovvero quanto costo extra per operazione azzera il guadagno)
- **SCALP_EU_SL17:** 3,0 EUR (P1) / 1,5 EUR (P2). **SL22:** 3,4 / 1,9. **GU_H1:** 3,8 / 2,7. **UJ_H1:** 3,0 / 2,4. **UJ_H4:** 2,3 / 1,9.
- Un costo extra di 0,5 EUR per operazione (spread/slippage reali sopra quelli del tester) riduce il PF degli scalper di circa il 15%; con 1 EUR del 30% (per esempio EU_SL17 P2: da 2,2 a 1,5 sui lordi). Non cancella i profitti, ma P2 di EU_SL17 e UJ_H4 restano con poco margine.
- **Lo spread reale NON è misurato** (foto di lunedi a mercato aperto ancora da fare).
- **VOL_f/VOL_o:** netto medio 2,5-4,8 EUR per operazione, un po' piu robusti ai costi in valore assoluto, ma con poche operazioni.

## Correlazione (settimanale, profitto realizzato, 679 settimane, i due periodi uniti)
Fra i passati: **bassa** (|r| <= 0,20) fra famiglie diverse; **alta dentro la stessa famiglia**: EU_SL17-EU_SL22 0,71, VOL_f-VOL_o 0,59, UJ_H1-UJ_H4 0,56. HANG4 non è correlato con nessuno (|r| <= 0,05). **Mancano le correlazioni con l'oro** (serie oro non rielaborate qui) e il flottante (non abbiamo le barre M1 forex): le correlazioni sono sul realizzato e probabilmente piu basse del vero.

## Cosa NON dice questo risultato
1. **Gli scalper sono i piu sospetti.** PF 1,7-4,4 per 13 anni, DD 0,1-0,5% e 1000-1700 operazioni sono numeri molto belli. Modello 1 (tick generati dalle barre M1) e noto per favorire gli scalper: ordine di tocco di SL/TP all'interno della barra, spread storico fisso. Nel pilota (2025) USDJPY H4 aveva PF 1,82, coerente con 1,70-1,88 qui, ma e lo stesso tester. **Va fatto un anno a tick reali** (se i tick BCM del forex esistono per quell'anno: non verificato) prima di fidarsi.
2. **Il passaggio da P1 a P2 peggiora quasi tutti gli scalper** (EU_SL17 PF 3,13 → 1,84; UJ_H4 1,88 → 1,70; EU_SL22 3,57 → 2,15): regime piu difficile o fine di un vantaggio? Non si sa.
3. **I lotti dei CLI non sono uguali**: la regola "stesso lotto per tutti" è rispettata solo da 16 set su 20.
4. **9 set non valutabili** non sono scartati: con piu anni o piu simboli potrebbero entrare. La soglia 150 li ferma per 1-60 operazioni.

## Previsioni
- **C-1** (passano 2-6 set forex): **FALSA**: ne passano 7 a lotto 0,1 (8 con HANG4). Avevo dato 25% a "piu di 6".
- **C-2** (correlazione con l'oro <= 0,30 per l'80%): **NON VERIFICATA** (manca la serie oro).
- **C-6** (ORB fuori dal portafoglio finale): in piedi, nessun ORB in questa corsa.
- **O-7** (tempo): 40 passate, circa 60-88 secondi ciascuna in orologio.

## Candidati per F3/F4 (regole del piano, scritte prima)
Un solo set per famiglia, correlazione <= 0,60, massimo 4 EA non oro, portafoglio separato dall'oro, obiettivo meno rischio di fallire. Pool dopo la regola "uno per famiglia": **EURUSD scalper H1 (SL22 o SL17), GBPUSD scalper H1, USDJPY scalper (H1 o H4), VOL_f o VOL_o**; HANG4 escluso (lotto non uguale, DD fino a 6,5%). **Attenzione:** il criterio "migliore per recovery factor" favorirebbe gli scalper (DD minuscolo), cioè proprio i set che il tester M1 tratta meglio. Prima di scegliere serve la verifica a tick e lo spread reale.

## Prossimo passo proposto
1. **Verificare i dati tick forex BCM** (da quando esistono) e fare un anno a tick reali sugli scalper del pool.
2. **Misurare lo spread** di EURUSD, GBPUSD, USDJPY (foto di lunedi).
3. **Serie giornaliere e correlazione con l'oro**, poi il fail-rate del portafoglio non oro.
4. **Per i non valutabili:** valutarli a gruppo (VOL_C20/C37/C63/e/k) o con un terzo periodo, dopo.
