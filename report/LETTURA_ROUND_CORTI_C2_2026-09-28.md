# LETTURA DEL ROUND CORTI C -- R264 (EMA200 H4: G0 tick, ponte AUDJPY, griglie OHLC) + R265 (EURUSD solo corto: G0+K1, walk-forward) + R266 (box asiatico GBPUSD/EURUSD) + R260d (oro solo long col trend dell'oro) + R267 (11 manopole a costo zero; R267a ESCLUSO) -- RACCOLTA C2: SOLI R264d1-d4

Generato da `backtest_pipeline/leggi_round_corti_c.py` sulla raccolta `/home/user/GITHUB/backtest_pipeline/risultati_archivio/ROUND_CORTI_C2_2026-09-28`.
Criteri congelati PRIMA dei numeri: `prove/R264_TESTA.txt.in` par. 5-9, `prove/R265_TESTA.txt.in` par. 2-4, `prove/R266a_asia_box_GBPUSD_TESTA.txt` par. 5-8, `prove/R260d_oro_770402_solo_long_trend_oro.txt` par. 3-4, `prove/R267a_news_oro_770402.txt` par. 0 e `prove/R267_GENERA.py` (B/C/V/E/U/D). Etichette: [MISURATO] dal CSV/per-trade della raccolta; [DERIVATO] da una formula della testa; [STIMA]; [NON MISURATO]; [NON VERIFICABILE]. Posizioni contate per position_id; sul forex/oro ogni saldo toglie k x volume (classe 844: k = (somma net - Profit)/lotti). **R4/B6/C6/V5/U6/D6/E4: NESSUNA cella si promuove. NESSUNA PROPOSTA DI TAGLIA: ogni riga di taglia e' un riferimento, non una proposta. Nessun preset, EA, sedia o conto e' toccato.**

Pre-lettura della riga (RIEPILOGO_ROUND_CORTI_C2.txt): presente, 35 righe -- si RILEGGE, non si crede: i cancelli qui sotto sono rifatti dai CSV e dai per-trade, e i NULLI della riga si UNISCONO (classe 873).

- **RACCOLTA C2** (`RIEPILOGO_ROUND_CORTI_C2.txt`, mini-riga `righe/RIGA_ROUND_CORTI_C2_R264D_ORO.txt`): rilancio dei SOLI R264d1-d4 (EMA200 H4 XAUUSD a 100.000, OHLC M1, IS 2017-2023 / OOS 2024-2026) che la riga C ha SALTATO; **i 33 job di C NON sono in questa raccolta e NON si leggono (non NULLI: ASSENTI PER COSTRUZIONE)**. G0 R264d e K1 R264d si RICOPIANO da `RIEPILOGO_ROUND_CORTI_C_letto.txt` [letto dalla riga C, non rifatto]; le sezioni 2 e 4-7 (ponte AUDJPY, R265b, R266, R260d, R267) non esistono qui: stanno nel referto della raccolta C.

- CLASSE 166 dalla riga (il lettore non ha i sorgenti compilati: la legge e la unisce): MOTORE = PIN in tutti i 4 round partiti
- NULLI della riga: 0 (nessuno) | SALTATI della riga: 0 (nessuno)

## DIVERGENZE fra la riga e il lettore (per nome, classe 873)

- nessuna

## 0. Cancelli di nullita' (secondo strato, indipendente dalla riga)

| file | lanciato | esito | motivi / note | tetto barre |
|---|---|---|---|---|
| R264d1 | si | NON NULLO | E0, asse, P0, C0, L0, G1 ok; P0 pin dal CSV ok (240 confronti + asse), prova da raccolta, SHA256 = hp= della riga; per-trade 796532 IDENTIFICATO (classe 850, regola fx): cella InpOrder1Atr=0.3 (Trades 397, Profit 8102.63, k 1.8183) | tetto barre : MaxBars=100000000 |
| R264d2 | si | NON NULLO | E0, asse, P0, C0, L0, G1 ok; P0 pin dal CSV ok (240 confronti + asse), prova da raccolta, SHA256 = hp= della riga; per-trade 796533 IDENTIFICATO (classe 850, regola fx): cella InpOrder1Atr=0.3 (Trades 364, Profit 10793.62, k 1.8178) | tetto barre : MaxBars=100000000 |
| R264d3 | si | NON NULLO | E0, asse, P0, C0, L0, G1 ok; P0 pin dal CSV ok (240 confronti + asse), prova da raccolta, SHA256 = hp= della riga; per-trade 796534 IDENTIFICATO (classe 850, regola fx): cella InpOrder1Atr=0.3 (Trades 343, Profit 10445.54, k 1.8171) | tetto barre : MaxBars=100000000 |
| R264d4 | si | NON NULLO | E0, asse, P0, C0, L0, G1 ok; P0 pin dal CSV ok (320 confronti + asse), prova da raccolta, SHA256 = hp= della riga; per-trade 796535 IDENTIFICATO (classe 850, regola fx): cella InpTP1Pct=75 (Trades 294, Profit 10516.22, k 1.8199) | tetto barre : MaxBars=100000000 |

fonte: `ROUND_<t>/<EA>_<sim>_<gamba><_ohlc>_<t>.csv`, `ROUND_<t>/<prova>` (P0), `PERTRADE/abtg_trades_<EA>_<sim>_<magic>.csv`, `ROUND_<t>/REFERTO_ROUND_<t>.txt` (tetto barre). Regole: E0 righe attese e Trades>0 (classe 766); P0 pin dal CSV (classe 780); C0 righe = Trades e somma per simbolo (classi 844/855); identificazione stretto-poi-largo, AMBIGUO non nullo (classe 850); L0 lato; G1 gemelle.
- **ASSENTI PER COSTRUZIONE (raccolta C2: NON letti, non NULLI ne' SALTATI): 33 job di C** (R264c, R264d, R264a, R264b, R264b1, R265a, R264c1, R264c2, R264c3, R264c4, R264a1, R264a2, R264a3, R264a4, R265b, R266a, R266b, R266c, R266d, R266e, R266f, R260d, R267b, R267d, R267c, R267g2, R267g3, R267g4, R267g1, R267e1, R267f1, R267e2, R267f2)

**D0 DATI (R264 par. 8 S0: tasso IS in deal/anno fra 0,5 e 2,0 volte il tasso OOS della stessa cella, altrimenti storico M1 sospetto -> NULLO)**
- R264d1 (IS 7.00 anni, OOS 2.50): 0.1: 96.9/116.5 = 0.83 | 0.2: 112.7/133.0 = 0.85 | 0.3: 125.8/159.0 = 0.79 -> D0 ok
- R264d2 (IS 7.00 anni, OOS 2.50): 0.1: 95.5/112.9 = 0.85 | 0.2: 111.0/124.6 = 0.89 | 0.3: 123.9/145.8 = 0.85 -> D0 ok
- R264d3 (IS 7.00 anni, OOS 2.50): 0.1: 93.5/109.7 = 0.85 | 0.2: 107.2/120.1 = 0.89 | 0.3: 119.2/137.4 = 0.87 -> D0 ok
- R264d4 (IS 7.00 anni, OOS 2.50): 0: 32.7/27.6 = 1.18 | 25: 127.6/130.2 = 0.98 | 50: 111.0/124.6 = 0.89 | 75: 100.0/117.7 = 0.85 -> D0 ok

**G2 INCROCIATO (R264 par. 6.3: cella TP1Pct=50 del file x4 == cella O1=0,20 del file x2, IS e OOS al centesimo)**
- XAUUSD: R264d4 TP1Pct=50 == R264d2 O1=0,20 in IS e OOS -> G2 ok

## 1. R264d -- G0 E K1 DELL'ORO [letto dalla riga C, non rifatto] (testa R264 par. 5; fonte: RIEPILOGO_ROUND_CORTI_C_letto.txt (112 righe))

- **G0 R264d [letto dalla riga C, non rifatto] -> ROSSO: il banco NON rifa' l'archivio**: `G0 R264d XAUUSD gemella 796531 OOS 2024.01.01 -> 2026.06.30: Trades 292 Profit 776.35 PF 1.30881 DD 6.0743 contro Pass 311 O1 0.30 / O2 0.4 / TP 2.5 (n 187 PF 1.38074 DD 6.1446 Profit 991.09): |dn| 105 (1% = 1.87, 3% = 5.61), |dPF| 0.072, dDD rel 0.011 -> ROSSO: il banco NON rifa l archivio`
- K1 R264d [letto dalla riga C, non rifatto] -> **K1 PASS**: `K1 R264d: K1 dal LOTTO (classe 846: stop in [R/((vol+0,01) x C x q) ; R/(vol x C x q)], R = saldo x 0,5% per gamba, saldo ricostruito togliendo k x lotti, gamba 2 = position_id che segue di 1 una presente): posizioni 187, coppie gamba1/gamba2 67, singole 53, rapporto vol2/vol1 mediano 1.750 (atteso 1.7, fuori [1.36 ; 2.125] (R265a: [1,5 ; 2,2] dalla sua testa; R264: 0,8x-1,25x) in 20 coppie), ATR da gamba 1 e da gamba 2 oltre +-12% in 29 coppie; stop gamba 2 MEDIANO: limite basso 12.33 USD, limite alto 15.42 USD (stop gamba 1 mediano ~25.51); gambe 1 con volume >= 0,02: 44 su 67 (contro-esempio della causa nominata per il GIALLO/ROSSO d oro: se >= 0,02 la causa lotto e sbagliata); soglia: XAUUSD: 10,41 $ = 40 x 0,2603 (logger 0,220 + comm. 0,0403); di casa alle 08/14: 10,01 $ -> K1 PASS`
  - K1 R264d, DIVERGENZA DICHIARATA (classe 889): 23 coppie su 67 (34.3%) hanno la gamba 1 al PAVIMENTO 0,01 [DERIVATO: N - X da 'gambe 1 con volume >= 0,02: X su N']; li' il rapporto vol2/vol1 e' QUANTIZZATO (0,01/0,01 = 1,0 e 0,03/0,01 = 3,0 cadono fuori banda anche con gambe identificate GIUSTE). rapporto vol2/vol1 fuori [1.36 ; 2.125] in 20 coppie su 67, NON oltre la meta' (33.5): il cancello del rapporto NON dice NULLO; clausola ATR +-12% fuori in 29 coppie su 67, non oltre la meta' (classe 875: la applica la riga C, la testa R264 par. 5 NON la congela; il pavimento non la spiega). Il criterio congelato del K1 NON cambia (riguarda il COSTO dello stop); la lettura della griglia d1-d4 (par. 3.2) NON dipende dal K1: dipende solo dal G0 (testa par. 5/10).

- metro OHLC (dal RIEPILOGO C2, si riporta): metro OHLC della riga C (c1-c4, a1-a4, stesso EA e modello, stesso PC): [NON LETTO dal RIEPILOGO C]

## 2. R264b1 (ponte AUDJPY) e sezioni 4-7 (R265b, R266, R260d, R267): NON in questa raccolta (C2), si leggono nel referto della raccolta C.

## 3. R264 -- LA GRIGLIA 3 x 3 DELL'ORO A 100.000 (testa par. 6-8: CENTRO = la cella di MEZZO O1 0,20 / O2 centrale, MAI il picco; classe 845)

- nota della testa R264 par. 5: G0 R264d ROSSO [letto dalla riga C, non rifatto] -> l'OOS 2024-26 contro il genetico e' NON CONFRONTABILE; l'IS 2017-23 si legge da solo (par. 4: S2 si legge in IS, l'OOS e' conferma DEBOLE). Il deposito 100000 NON e' una taglia (par. 0): e' la ragione del rilancio (a 100000 il pavimento del lotto non morde e la parziale al 50% parte).

### 3.2 XAUUSD (G0 R264d: ROSSO [letto dalla riga C, non rifatto]) -- IS 2017-2023: laterale 2017-2018, toro 2019-2020, laterale 2021-2022, toro 2023

| O1 \ O2 | O2 0.5 IS PF / n / DD -- OOS PF / n / DD | O2 0.6 IS PF / n / DD -- OOS PF / n / DD | O2 0.7 IS PF / n / DD -- OOS PF / n / DD |
|---|---|---|---|
| O1 0.10 | 0.810 / 678 / 17.05 -- 1.223 / 291 / 6.22 | 0.831 / 668 / 14.29 -- 1.446 / 282 / 5.87 | 0.824 / 654 / 12.74 -- 1.646 / 274 / 5.11 |
| O1 0.20 | 0.813 / 789 / 16.02 -- 1.310 / 332 / 6.18 | 0.836 / 777 / 13.32 -- 1.535 / 311 / 6.02 | 0.816 / 750 / 12.74 -- 1.625 / 300 / 5.22 |
| O1 0.30 | 0.811 / 880 / 16.61 -- 1.346 / 397 / 6.40 | 0.818 / 867 / 13.84 -- 1.547 / 364 / 6.31 | 0.813 / 834 / 12.73 -- 1.599 / 343 / 5.51 |

fonte: `ROUND_R264d1..R264d3/*_IS_ohlc_*.csv` e `*_OOS_ohlc_*.csv` [MISURATO dal CSV, PF sui deal]; OOS 2024.01-2026.06 = la finestra del genetico: conferma DEBOLE (R264 par. 4), NON cieca a livello di vicinato

- S5 INERZIA: O1 morde su tutti e tre i file
- S2 CENTRO = MEZZO O1 0,20 / O2 0.6: PF IS **0.836** (il PICCO della griglia e' O1 0.20 / O2 0.6 PF 0.836: si scrive, NON si sceglie); medie di fila 0,10/0,20/0,30 = 0.822/0.822/0.814, di colonna = 0.811/0.828/0.818; BORDO (fila esterna >= mezzo + 0,08; falso allarme simulato 0,2-8,8%): no; celle IS >= 1,10: 0 su 9; 4 vicini del mezzo >= 1,00: False; PF OOS mezzo 1.535 (conferma DEBOLE >= 1,10)
- S1 CAMPIONE: n IS al mezzo 777 deal >= 276 (= 150 pos x 1,838); OOS 311 deal >= 276
- S3 RISCHIO al mezzo (a qualunque n, Emendamento B): DD IS 13.32 / DD OOS 6.02 a 1% contro 10.0 -> **SOPRA IL MURO: NO PER RISCHIO**; derivato a 2,00 (x1,956-1,990) [DERIVATO]: IS 26.06-26.51, OOS 11.78-11.98 -- OHLC SOTTOSTIMA: sopra boccia, sotto NON dimostra
- S4 SEGNI: REGIME; S6 DEFAULT (proxy O1 0,10 / O2 piu' vicina a 0,35): O2 0.5 PF IS 0.810 (il centro NON la batte di 0,05: IL DEFAULT VA BENE); banda H (classe 178): FUORI dalle due bande (0.836): se e' alto il primo sospetto e' un baco o un pin non arrivato
- **VERDETTO S8 (per nome): NO PER RISCHIO (S3)** [G0 XAUUSD ROSSO: l'OOS contro il genetico e' NON CONFRONTABILE, l'IS resta leggibile da solo] -- S7: Modello 1 BOCCIA e non PROMUOVE: il massimo e' PASSA LO SCREENING -> serve il tick (2024.07.05 -> 2026.06.30 o storico esterno)
- Emendamento della finestra: l'IS si misura in operazioni (777 deal ~ 423 posizioni [DERIVATO 1,838 deal/pos]); il VECCHIO (IS) giudica il RISCHIO (DD IS 13.32), il RECENTE (OOS) il MERITO (PF OOS 1.535); rischio: VIOLATO (DD <= 10,0% @1% in IS e OOS; boccia a qualunque n, Emendamento B)
- DD alle taglie [DERIVATO, R193b B3, da Equity DD % max(IS, OOS) al mezzo a 1.00%]: 0.50%: 6.90-6.66%; 1.50%: 19.30-19.99%; 2.00%: 24.87-26.65% -- **NESSUNA PROPOSTA DI TAGLIA**
- per-trade 796532 (cella InpOrder1Atr=0.3, gamba OOS): posizioni 179, PF in posizioni (k 1.8183 tolto) 1.347, EP 45.27 EUR/pos, DD a saldo chiuso 5.888 % (picco 2024.11.08, fondo 2025.07.08), peggior giornata -1.095 % (2024-01-17, denominatore = saldo a inizio giornata), deal/posizione 2.218 [MISURATO dal per-trade]
- per-trade 796533 (cella InpOrder1Atr=0.3, gamba OOS): posizioni 164, PF in posizioni (k 1.8178 tolto) 1.550, EP 65.81 EUR/pos, DD a saldo chiuso 5.484 % (picco 2024.11.08, fondo 2025.07.08), peggior giornata -1.098 % (2024-01-17, denominatore = saldo a inizio giornata), deal/posizione 2.220 [MISURATO dal per-trade]
- per-trade 796534 (cella InpOrder1Atr=0.3, gamba OOS): posizioni 155, PF in posizioni (k 1.8171 tolto) 1.602, EP 67.39 EUR/pos, DD a saldo chiuso 4.403 % (picco 2024.11.08, fondo 2025.08.22), peggior giornata -1.094 % (2024-01-17, denominatore = saldo a inizio giornata), deal/posizione 2.213 [MISURATO dal per-trade]
- certificato di morte (09/09): coperte da QUESTO round: (1) PF, (2) n e DD, (3) uscita ad asse, (4) gemelli, (5) TF; certificato COMPLETO da questo round + archivio: un NO qui e' un NO con certificato [PF IS mezzo 0.836, OOS 1.535]
- USCITA R264d4 (asse InpTP1Pct sul centro; 0 spegne parziale, BE e trailing: deal = posizioni): IS PF 0/25/50/75 = 0.798/0.845/0.836/0.826 (n 229/893/777/700, DD 19.35/12.80/13.32/14.03); OOS PF 1.284/1.568/1.535/1.506 (DD 6.45/5.75/6.02/6.23); 25/50/75 entro 0,03: IS si, OOS NO (0.062); TP1Pct 0 piu' basso e con DD piu' alto del 50 (come sul Dow): IS si, OOS si -> **l'uscita a parziale/BE/trailing regge (nessuna notizia)**
  - M1-M3 TP1Pct 0 contro il CONTROLLO TP1Pct 50 dello stesso file (modello leggi_r255 par. 10, sul CSV): M1 passa, M2 fallisce, M3 fallisce -- calcolato anche sotto 150: INDIZIO, non verdetto
  - M1-M3 TP1Pct 25 contro il CONTROLLO TP1Pct 50 dello stesso file (modello leggi_r255 par. 10, sul CSV): M1 passa, M2 fallisce, M3 passa
  - M1-M3 TP1Pct 75 contro il CONTROLLO TP1Pct 50 dello stesso file (modello leggi_r255 par. 10, sul CSV): M1 passa, M2 fallisce, M3 fallisce
  - per-trade 796535 (cella TP1Pct=75, OOS): posizioni 158, PF in posizioni (k 1.8199 tolto) 1.509, EP 66.56 EUR/pos, DD a saldo chiuso 5.681 % (picco 2024.11.08, fondo 2025.07.08), peggior giornata -1.097 % (2024-01-17, denominatore = saldo a inizio giornata), deal/posizione 1.861 [MISURATO dal per-trade]


## 8. Riepilogo dei file, dopo la lettura (i cancelli di lettura -- D0, G2, L0 struttura, T3/S0, B3/V1/V2/V3/C2/C3/C4/U1/U2/U4/D2 -- si aggiungono a quelli del par. 0)

- FILE NULLI (escono da OGNI conteggio): nessuno
- FILE SALTATI (non lanciati, NON nulli di catena): nessuno
- FILE ASSENTI PER COSTRUZIONE (raccolta C2: i job di C NON sono qui e NON si leggono; non NULLI, non SALTATI): 33 (R264c, R264d, R264a, R264b, R264b1, R265a, R264c1, R264c2, R264c3, R264c4, R264a1, R264a2, R264a3, R264a4, R265b, R266a, R266b, R266c, R266d, R266e, R266f, R260d, R267b, R267d, R267c, R267g2, R267g3, R267g4, R267g1, R267e1, R267f1, R267e2, R267f2)
- FILE NON NULLI, per nome: R264d1, R264d2, R264d3, R264d4

**NESSUNA PROPOSTA DI TAGLIA. Nessuna cella si promuove. Nessun preset, EA, sedia o conto e' toccato.**

**Cosa resta a mano (non e' in questo script):** la classe 166 (SHA256 del motore e dell'include dopo ogni job) e gli rc dei job il lettore NON li ricalcola (non ha i sorgenti compilati): li legge dal RIEPILOGO e li UNISCE (sezione DIVERGENZE); senza RIEPILOGO restano [NON VERIFICATI]; il D0 dei log di R266 e' letto dai LOG_TESTER (sezione 5) e resta [NON VERIFICATO] se l'agente non scrive la riga 'history ... from' in ottimizzazione; il K1 di R264 segue la testa R264 par. 5 (solo vol2/vol1): la riga aggiunge i +-12% dell'ATR di R265 e sull'oro a 10000 puo' dire NULLO dove la testa no (e la riga usa quel NULLO per fermare l'onda 2 dell'oro dopo un G0 ROSSO); lo spread in memoria del terminale (classe 394) NON e' pinnato da questa corsia; la commissione e la griglia H4 di FTMO sono [NON MISURATE]; ogni decisione su taglie, sedie, R265b dopo un NON RISOLTO, R267a (par. 6-A) e i round d'altopiano dopo un HE/PASSA e' una FIRMA di Claudio.
