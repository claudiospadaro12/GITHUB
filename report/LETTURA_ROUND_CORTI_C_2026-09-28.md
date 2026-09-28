## PER CLAUDIO, IN 5 RIGHE

_Scritte a mano dal cancello (controllo preventivo, 28/09/2026). Da "# LETTURA DEL ROUND CORTI C" in giu' c'e' l'output del lettore `backtest_pipeline/leggi_round_corti_c.py`, identico byte per byte: si ricontrolla con `tail -n +13` di questo file contro una rigenerazione con `PYTHONHASHSEED=0`._

1. **Chiuso per COSTO: EMA200 EURUSD H4 solo corto.** Stop mediano della gamba 2 = 23,4-24,4 pip, cioe' 35,3-36,8 volte il pedaggio, sotto le 40 volte (26,54 pip): ESCLUSO PER COSTO con `InpSLatr` 1,0, e R265b non parte. Il candidato pero' **NON e' morto: e' NON ANCORA MISURATO**, perche' la larghezza dello stop (`InpSLatr`, la leva nominata dalla testa R264 par. 11) non e' mai stata messa ad asse.
2. **Il banco NON rifa' l'archivio EMA200 H4 su 4 simboli su 4**, sempre nello stesso verso: n piu' alto di 5-105 operazioni, PF piu' basso di 0,017-0,091. Quindi le 12 griglie non sono partite e i confronti OOS col genetico sono NON CONFRONTABILI. **La causa NON e' dimostrata.** Su GBPJPY, GBPUSD e AUDJPY non c'e' nessuna posizione al lotto minimo, quindi il lotto 0,01 non puo' essere la causa comune; gli input sono uguali al genetico (verificato colonna per colonna: cambiano solo magic e commento). Restano tre ipotesi, per nome: il binario (H_BINARIO), lo storico dei tick (H_STORICO), le specifiche del simbolo (H_SPEC). La misura che le separa e' lo stesso G0 girato col binario del genetico (`0953846c`).
3. **NON ANCORA MISURATO, con cosa manca.** Box asiatico GBPUSD/EURUSD: 6 file, PF 0,88-1,28, tutti H0, e il DD a 1% (7,2-21,6%) viola il rischio a qualunque n; mancano l'uscita ad asse e il TF. DAX long filtrato (R267g1, PF 0,957 sulla cella di mezzo): mancano i gemelli. Oro 770402 solo long col trend (R260d): PF 1,557 su 238 operazioni, ma DD 3,38% a 0,5% contro un tetto di 2,00-2,06%, quindi **RISCHIO VIOLATO** a qualunque n.
4. **Indizi, col merito SOSPESO (nessuno si promuove).** Oro EMA200 col filtro ADR: PF da 1,309 a 1,559, DD da 6,07 a 4,63, e M1 e M2 passano, ma il banco e' ROSSO. Oro 770402 con box minimo 1300-2600: PF 1,67-1,93, ma su 98-199 operazioni. Dow short con uscita alle 16:00: PF da 1,108 a 1,278, circa 55 posizioni per era.
5. **Cosa parte adesso: C2**, cioe' le 4 griglie dell'oro rilanciate a 100000. La guardia e' stata rifatta sul RIEPILOGO vero e passa (23 coppie su 67 al pavimento). A 100000 il pavimento del lotto sparisce, ma il ROSSO comune del punto 2 resta: la griglia si legge IS da sola, e l'OOS resta NON CONFRONTABILE. **Nessuna taglia, nessuna sedia, nessun preset toccato.**

---

# LETTURA DEL ROUND CORTI C -- R264 (EMA200 H4: G0 tick, ponte AUDJPY, griglie OHLC) + R265 (EURUSD solo corto: G0+K1, walk-forward) + R266 (box asiatico GBPUSD/EURUSD) + R260d (oro solo long col trend dell'oro) + R267 (11 manopole a costo zero; R267a ESCLUSO)

Generato da `backtest_pipeline/leggi_round_corti_c.py` sulla raccolta `/home/user/GITHUB/backtest_pipeline/risultati_archivio/ROUND_CORTI_C_2026-09-28`.
Criteri congelati PRIMA dei numeri: `prove/R264_TESTA.txt.in` par. 5-9, `prove/R265_TESTA.txt.in` par. 2-4, `prove/R266a_asia_box_GBPUSD_TESTA.txt` par. 5-8, `prove/R260d_oro_770402_solo_long_trend_oro.txt` par. 3-4, `prove/R267a_news_oro_770402.txt` par. 0 e `prove/R267_GENERA.py` (B/C/V/E/U/D). Etichette: [MISURATO] dal CSV/per-trade della raccolta; [DERIVATO] da una formula della testa; [STIMA]; [NON MISURATO]; [NON VERIFICABILE]. Posizioni contate per position_id; sul forex/oro ogni saldo toglie k x volume (classe 844: k = (somma net - Profit)/lotti). **R4/B6/C6/V5/U6/D6/E4: NESSUNA cella si promuove. NESSUNA PROPOSTA DI TAGLIA: ogni riga di taglia e' un riferimento, non una proposta. Nessun preset, EA, sedia o conto e' toccato.**

Pre-lettura della riga (RIEPILOGO_ROUND_CORTI_C.txt): presente, 112 righe -- si RILEGGE, non si crede: i cancelli qui sotto sono rifatti dai CSV e dai per-trade, e i NULLI della riga si UNISCONO (classe 873).

- CLASSE 166 dalla riga (il lettore non ha i sorgenti compilati: la legge e la unisce): MOTORE = PIN in tutti i 24 round partiti
- NULLI della riga: 0 (nessuno) | SALTATI della riga: 13 (R264c1, R264c2, R264c3, R264c4, R264d1, R264d2, R264d3, R264d4, R264a1, R264a2, R264a3, R264a4, R265b)

## DIVERGENZE fra la riga e il lettore (per nome, classe 873)

- nessuna

## 0. Cancelli di nullita' (secondo strato, indipendente dalla riga)

| file | lanciato | esito | motivi / note | tetto barre |
|---|---|---|---|---|
| R264c | si | NON NULLO | E0, asse, P0, C0, L0, G1 ok; _IS 0 byte: moncone IS, ATTESO; P0 pin dal CSV ok (80 confronti + asse), prova da raccolta, SHA256 = hp= della riga | tetto barre : MaxBars=100000000 |
| R264d | si | NON NULLO | E0, asse, P0, C0, L0, G1 ok; _IS 0 byte: moncone IS, ATTESO; P0 pin dal CSV ok (80 confronti + asse), prova da raccolta, SHA256 = hp= della riga | tetto barre : MaxBars=100000000 |
| R264a | si | NON NULLO | E0, asse, P0, C0, L0, G1 ok; _IS 0 byte: moncone IS, ATTESO; P0 pin dal CSV ok (80 confronti + asse), prova da raccolta, SHA256 = hp= della riga | tetto barre : MaxBars=100000000 |
| R264b | si | NON NULLO | E0, asse, P0, C0, L0, G1 ok; _IS 0 byte: moncone IS, ATTESO; P0 pin dal CSV ok (80 confronti + asse), prova da raccolta, SHA256 = hp= della riga | tetto barre : MaxBars=100000000 |
| R264b1 | si | NON NULLO | E0, asse, P0, C0, L0, G1 ok; _IS 0 byte: moncone IS, ATTESO; P0 pin dal CSV ok (160 confronti + asse), prova da raccolta, SHA256 = hp= della riga; per-trade 796512 IDENTIFICATO (classe 850, regola fx): cella InpTP_RR=3.0 (Trades 322, Profit 990.79, k 1.1877) | tetto barre : MaxBars=100000000 |
| R265a | si | NON NULLO | E0, asse, P0, C0, L0, G1 ok; _IS 0 byte: moncone IS, ATTESO; P0 pin dal CSV ok (80 confronti + asse), prova da raccolta, SHA256 = hp= della riga | tetto barre : MaxBars=100000000 |
| R264c1 | NO | SALTATO / non nella raccolta | SALTATO: G0 R264c di GBPJPY ROSSO -> testa R264 par. 10: se il G0 di un simbolo e ROSSO la sua onda 2 si ferma finche non si capisce perche; si rilancia dopo la lettura del referto (NON un nullo di catena) | - |
| R264c2 | NO | SALTATO / non nella raccolta | SALTATO: G0 R264c di GBPJPY ROSSO -> testa R264 par. 10: se il G0 di un simbolo e ROSSO la sua onda 2 si ferma finche non si capisce perche; si rilancia dopo la lettura del referto (NON un nullo di catena) | - |
| R264c3 | NO | SALTATO / non nella raccolta | SALTATO: G0 R264c di GBPJPY ROSSO -> testa R264 par. 10: se il G0 di un simbolo e ROSSO la sua onda 2 si ferma finche non si capisce perche; si rilancia dopo la lettura del referto (NON un nullo di catena) | - |
| R264c4 | NO | SALTATO / non nella raccolta | SALTATO: G0 R264c di GBPJPY ROSSO -> testa R264 par. 10: se il G0 di un simbolo e ROSSO la sua onda 2 si ferma finche non si capisce perche; si rilancia dopo la lettura del referto (NON un nullo di catena) | - |
| R264d1 | NO | SALTATO / non nella raccolta | SALTATO: G0 R264d di XAUUSD ROSSO -> testa R264 par. 10: se il G0 di un simbolo e ROSSO la sua onda 2 si ferma finche non si capisce perche; si rilancia dopo la lettura del referto (NON un nullo di catena) | - |
| R264d2 | NO | SALTATO / non nella raccolta | SALTATO: G0 R264d di XAUUSD ROSSO -> testa R264 par. 10: se il G0 di un simbolo e ROSSO la sua onda 2 si ferma finche non si capisce perche; si rilancia dopo la lettura del referto (NON un nullo di catena) | - |
| R264d3 | NO | SALTATO / non nella raccolta | SALTATO: G0 R264d di XAUUSD ROSSO -> testa R264 par. 10: se il G0 di un simbolo e ROSSO la sua onda 2 si ferma finche non si capisce perche; si rilancia dopo la lettura del referto (NON un nullo di catena) | - |
| R264d4 | NO | SALTATO / non nella raccolta | SALTATO: G0 R264d di XAUUSD ROSSO -> testa R264 par. 10: se il G0 di un simbolo e ROSSO la sua onda 2 si ferma finche non si capisce perche; si rilancia dopo la lettura del referto (NON un nullo di catena) | - |
| R264a1 | NO | SALTATO / non nella raccolta | SALTATO: G0 R264a di GBPUSD ROSSO -> testa R264 par. 10: se il G0 di un simbolo e ROSSO la sua onda 2 si ferma finche non si capisce perche; si rilancia dopo la lettura del referto (NON un nullo di catena) | - |
| R264a2 | NO | SALTATO / non nella raccolta | SALTATO: G0 R264a di GBPUSD ROSSO -> testa R264 par. 10: se il G0 di un simbolo e ROSSO la sua onda 2 si ferma finche non si capisce perche; si rilancia dopo la lettura del referto (NON un nullo di catena) | - |
| R264a3 | NO | SALTATO / non nella raccolta | SALTATO: G0 R264a di GBPUSD ROSSO -> testa R264 par. 10: se il G0 di un simbolo e ROSSO la sua onda 2 si ferma finche non si capisce perche; si rilancia dopo la lettura del referto (NON un nullo di catena) | - |
| R264a4 | NO | SALTATO / non nella raccolta | SALTATO: G0 R264a di GBPUSD ROSSO -> testa R264 par. 10: se il G0 di un simbolo e ROSSO la sua onda 2 si ferma finche non si capisce perche; si rilancia dopo la lettura del referto (NON un nullo di catena) | - |
| R265b | NO | SALTATO / non nella raccolta | SALTATO: R265b parte SOLO con K1 di R265a = PASS (testa R265a par. 2-4); qui K1 = FAIL -> EURUSD H4 ESCLUSO PER COSTO col numero accanto (stop mediano ordine 2 sotto 26,54 pip) | - |
| R266a | si | NON NULLO | E0, asse, P0, C0, L0, G1 ok; P0 pin dal CSV ok (192 confronti + asse), prova da raccolta, SHA256 = hp= della riga | tetto barre : MaxBars=100000000 |
| R266b | si | NON NULLO | E0, asse, P0, C0, L0, G1 ok; P0 pin dal CSV ok (192 confronti + asse), prova da raccolta, SHA256 = hp= della riga | tetto barre : MaxBars=100000000 |
| R266c | si | NON NULLO | E0, asse, P0, C0, L0, G1 ok; P0 pin dal CSV ok (192 confronti + asse), prova da raccolta, SHA256 = hp= della riga | tetto barre : MaxBars=100000000 |
| R266d | si | NON NULLO | E0, asse, P0, C0, L0, G1 ok; P0 pin dal CSV ok (192 confronti + asse), prova da raccolta, SHA256 = hp= della riga | tetto barre : MaxBars=100000000 |
| R266e | si | NON NULLO | E0, asse, P0, C0, L0, G1 ok; P0 pin dal CSV ok (192 confronti + asse), prova da raccolta, SHA256 = hp= della riga | tetto barre : MaxBars=100000000 |
| R266f | si | NON NULLO | E0, asse, P0, C0, L0, G1 ok; P0 pin dal CSV ok (192 confronti + asse), prova da raccolta, SHA256 = hp= della riga | tetto barre : MaxBars=100000000 |
| R260d | si | NON NULLO | E0, asse, P0, C0, L0, G1 ok; _IS presente (ha scritto righe: si guarda nel REFERTO, non conta): moncone IS, ATTESO; P0 pin dal CSV ok (96 confronti + asse), prova da raccolta, SHA256 = hp= della riga | tetto barre : MaxBars=100000000 |
| R267b | si | NON NULLO | E0, asse, P0, C0, L0, G1 ok; _IS presente (ha scritto righe: si guarda nel REFERTO, non conta): moncone IS, ATTESO; P0 pin dal CSV ok (240 confronti + asse), prova da raccolta, SHA256 = hp= della riga; per-trade 796702 IDENTIFICATO (classe 850, regola fx): cella InpMinBoxPts=2600 (Trades 98, Profit 6734.29, k 1.7435) | tetto barre : MaxBars=100000000 |
| R267d | si | NON NULLO | E0, asse, P0, C0, L0, G1 ok; _IS 0 byte: moncone IS, ATTESO; P0 pin dal CSV ok (385 confronti + asse), prova da raccolta, SHA256 = hp= della riga; per-trade 796712 IDENTIFICATO (classe 850, regola usd): cella InpVolMult=2.0 (Trades 28, Profit 265.03, k 0.0000) | tetto barre : MaxBars=100000000 |
| R267c | si | NON NULLO | E0, asse, P0, C0, L0, G1 ok; _IS 0 byte: moncone IS, ATTESO; P0 pin dal CSV ok (154 confronti + asse), prova da raccolta, SHA256 = hp= della riga; per-trade 796711 IDENTIFICATO (classe 850, regola usd): cella InpCloseHour=17 (Trades 142, Profit 529.24, k 0.0000) | tetto barre : MaxBars=100000000 |
| R267g2 | si | NON NULLO | E0, asse, P0, C0, L0, G1 ok; _OOS 0 byte: gamba OOS DEGENERE, ATTESO; P0 pin dal CSV ok (96 confronti + asse), prova da raccolta, SHA256 = hp= della riga; per-trade 796742 IDENTIFICATO (classe 850, regola usd): cella InpUseTrailing=1 (Trades 103, Profit -3952.27, k 0.0000) | tetto barre : MaxBars=100000000 |
| R267g3 | si | NON NULLO | E0, asse, P0, C0, L0, G1 ok; _OOS 0 byte: gamba OOS DEGENERE, ATTESO; P0 pin dal CSV ok (96 confronti + asse), prova da raccolta, SHA256 = hp= della riga; per-trade 796743 IDENTIFICATO (classe 850, regola usd): cella InpBreakeven=1 (Trades 103, Profit -3952.27, k 0.0000) | tetto barre : MaxBars=100000000 |
| R267g4 | si | NON NULLO | E0, asse, P0, C0, L0, G1 ok; _OOS 0 byte: gamba OOS DEGENERE, ATTESO; P0 pin dal CSV ok (192 confronti + asse), prova da raccolta, SHA256 = hp= della riga; per-trade 796744 IDENTIFICATO (classe 850, regola usd): cella InpTP1Pct=75 (Trades 103, Profit -1899.87, k 0.0000) | tetto barre : MaxBars=100000000 |
| R267g1 | si | NON NULLO | E0, asse, P0, C0, L0, G1 ok; _OOS 0 byte: gamba OOS DEGENERE, ATTESO; P0 pin dal CSV ok (240 confronti + asse), prova da raccolta, SHA256 = hp= della riga; per-trade 796741 IDENTIFICATO (classe 850, regola usd): cella InpCorrTF=16408 (Trades 128, Profit -6889.51, k 0.0000) | tetto barre : MaxBars=100000000 |
| R267e1 | si | NON NULLO | E0, asse, P0, C0, L0, G1 ok; _IS 0 byte: moncone IS, ATTESO; P0 pin dal CSV ok (80 confronti + asse), prova da raccolta, SHA256 = hp= della riga; per-trade 796721 IDENTIFICATO (classe 850, regola fx): cella InpUseAdrFilter=1 (Trades 235, Profit 446.09, k 2.3292) | tetto barre : MaxBars=100000000 |
| R267f1 | si | NON NULLO | E0, asse, P0, C0, L0, G1 ok; _IS 0 byte: moncone IS, ATTESO; P0 pin dal CSV ok (80 confronti + asse), prova da raccolta, SHA256 = hp= della riga; per-trade 796731 IDENTIFICATO (classe 850, regola fx): cella InpFridayClose=1 (Trades 239, Profit 491.12, k 2.3313) | tetto barre : MaxBars=100000000 |
| R267e2 | si | NON NULLO | E0, asse, P0, C0, L0, G1 ok; _IS 0 byte: moncone IS, ATTESO; P0 pin dal CSV ok (80 confronti + asse), prova da raccolta, SHA256 = hp= della riga; per-trade 796722 IDENTIFICATO (classe 850, regola fx): cella InpUseAdrFilter=1 (Trades 290, Profit 1174.98, k 1.8555) | tetto barre : MaxBars=100000000 |
| R267f2 | si | NON NULLO | E0, asse, P0, C0, L0, G1 ok; _IS 0 byte: moncone IS, ATTESO; P0 pin dal CSV ok (80 confronti + asse), prova da raccolta, SHA256 = hp= della riga; per-trade 796732 IDENTIFICATO (classe 850, regola fx): cella InpFridayClose=1 (Trades 286, Profit 605.23, k 1.8547) | tetto barre : MaxBars=100000000 |

fonte: `ROUND_<t>/<EA>_<sim>_<gamba><_ohlc>_<t>.csv`, `ROUND_<t>/<prova>` (P0), `PERTRADE/abtg_trades_<EA>_<sim>_<magic>.csv`, `ROUND_<t>/REFERTO_ROUND_<t>.txt` (tetto barre). Regole: E0 righe attese e Trades>0 (classe 766); P0 pin dal CSV (classe 780); C0 righe = Trades e somma per simbolo (classi 844/855); identificazione stretto-poi-largo, AMBIGUO non nullo (classe 850); L0 lato; G1 gemelle.
- **R267a** (`R267a_news_oro_770402.txt`): ASSENTE, ed e' ATTESO: ESCLUSO E DICHIARATO dalla riga e dalla testa par. 6-A (canale news aperto). NON e' un file NULLO per guasto: resta in coda finche' il par. 6-A non e' chiuso (A1 codice o A2 sandbox).

**D0 DATI (R264 par. 8 S0: tasso IS in deal/anno fra 0,5 e 2,0 volte il tasso OOS della stessa cella, altrimenti storico M1 sospetto -> NULLO)**
- R264c1: D0 NON VERIFICABILE (NULLO o SALTATO)
- R264c2: D0 NON VERIFICABILE (NULLO o SALTATO)
- R264c3: D0 NON VERIFICABILE (NULLO o SALTATO)
- R264c4: D0 NON VERIFICABILE (NULLO o SALTATO)
- R264d1: D0 NON VERIFICABILE (NULLO o SALTATO)
- R264d2: D0 NON VERIFICABILE (NULLO o SALTATO)
- R264d3: D0 NON VERIFICABILE (NULLO o SALTATO)
- R264d4: D0 NON VERIFICABILE (NULLO o SALTATO)
- R264a1: D0 NON VERIFICABILE (NULLO o SALTATO)
- R264a2: D0 NON VERIFICABILE (NULLO o SALTATO)
- R264a3: D0 NON VERIFICABILE (NULLO o SALTATO)
- R264a4: D0 NON VERIFICABILE (NULLO o SALTATO)
- R265b: D0 NON VERIFICABILE (NULLO o SALTATO)

**G2 INCROCIATO (R264 par. 6.3: cella TP1Pct=50 del file x4 == cella O1=0,20 del file x2, IS e OOS al centesimo)**
- GBPJPY: G2 NON VERIFICABILE (R264c2 o R264c4 NULLO/SALTATO)
- XAUUSD: G2 NON VERIFICABILE (R264d2 o R264d4 NULLO/SALTATO)
- GBPUSD: G2 NON VERIFICABILE (R264a2 o R264a4 NULLO/SALTATO)

## 1. R264 / R265a -- G0 DEI BANCHI (testa R264 par. 5, R265 par. 3) e K1 DAL LOTTO (classe 846)

- **G0 R264c GBPJPY** gemella 796521 OOS 2024.01.01 -> 2026.06.30: Trades 242, Profit 588.25, PF 1.22354, Equity DD % 4.1244 [MISURATO] contro Pass 55 O1 0.10 / O2 0.4 / TP 1.5 (n 221, PF 1.24037, DD 4.4220, Profit 609.52): |dn| 21 (1% = 2.21, 3% = 6.63), |dPF| 0.017, dDD rel 0.067 -> **ROSSO: il banco NON rifa' l'archivio**: le letture OOS contro il genetico (ponte, OOS delle griglie) diventano NON CONFRONTABILI; l'IS resta leggibile da solo
  - K1 R264c dal LOTTO [DERIVATO dal per-trade abtg_trades_ABTG_EMA200_GBPJPY_796521.csv, R = saldo x 0,5% per gamba, k 2.3323 tolto]: posizioni 144, coppie gamba1/gamba2 53, singole 38, vol2/vol1 mediano 1.500 (atteso 1.50, fuori [1.20 ; 1.875] in 0 coppie), ATR da gamba 1 e 2 oltre +-12% in 0 coppie (INFORMATIVO: la testa R264 par. 5 congela solo vol2/vol1, la riga aggiunge i 12% e puo' dire NULLO dove la testa no (classe 875)); stop gamba 2 MEDIANO: limite basso 66.36 pip, alto 71.10 pip (gamba 1 ~100.70); soglia: GBPJPY: comm. 0,8645 pip + spread NON MISURATO -> soglia >= 34,6 pip + 40 x spread: K1 NON DECIDIBILE finche' lo spread non c'e' -> **K1 SOLO LETTURA** (nessuna soglia decidibile su questo simbolo: numero riportato)
  - R264c: posizioni 144, PF in posizioni (k 2.3323 tolto) 1.225, EP 4.09 EUR/pos, DD a saldo chiuso 3.502 % (picco 2025.09.23, fondo 2026.05.22), peggior giornata -1.221 % (2026-05-22, denominatore = saldo a inizio giornata), deal/posizione 1.681 [MISURATO dal per-trade]
- **G0 R264d XAUUSD** gemella 796531 OOS 2024.01.01 -> 2026.06.30: Trades 292, Profit 776.35, PF 1.30881, Equity DD % 6.0743 [MISURATO] contro Pass 311 O1 0.30 / O2 0.4 / TP 2.5 (n 187, PF 1.38074, DD 6.1446, Profit 991.09): |dn| 105 (1% = 1.87, 3% = 5.61), |dPF| 0.072, dDD rel 0.011 -> **ROSSO: il banco NON rifa' l'archivio** (causa NOMINATA prima, par. 5: lotto 0,01-0,02 a 10000 sull'oro, parziale che non parte, BE di 344a11b9; contro-esempio nel K1: gambe 1 con volume >= 0,02)
  - K1 R264d dal LOTTO [DERIVATO dal per-trade abtg_trades_ABTG_EMA200_XAUUSD_796531.csv, R = saldo x 0,5% per gamba, k 1.8560 tolto]: posizioni 187, coppie gamba1/gamba2 67, singole 53, vol2/vol1 mediano 1.750 (atteso 1.70, fuori [1.36 ; 2.125] in 20 coppie), ATR da gamba 1 e 2 oltre +-12% in 9 coppie (INFORMATIVO: la testa R264 par. 5 congela solo vol2/vol1, la riga aggiunge i 12% e puo' dire NULLO dove la testa no (classe 875)); stop gamba 2 MEDIANO: limite basso 12.33 USD, alto 15.42 USD (gamba 1 ~25.51); soglia: XAUUSD: 10,41 $ = 40 x 0,2603 (logger 0,220 + comm. 0,0403); di casa alle 08/14: 10,01 $ -> **K1 PASS**; gambe 1 con volume >= 0,02: 44 su 67 (contro-esempio della causa nominata per il GIALLO/ROSSO d'oro: se >= 0,02 la causa lotto e' SBAGLIATA)
  - K1 R264d, DIVERGENZA DICHIARATA (classe 889): 23 coppie su 67 (34.3%) hanno la gamba 1 al PAVIMENTO 0,01 [DERIVATO: N - X da 'gambe 1 con volume >= 0,02: X su N']; li' il rapporto vol2/vol1 e' QUANTIZZATO (0,01/0,01 = 1,0 e 0,03/0,01 = 3,0 cadono fuori banda anche con gambe identificate GIUSTE). rapporto vol2/vol1 fuori [1.36 ; 2.125] in 20 coppie su 67, NON oltre la meta' (33.5): il cancello del rapporto NON dice NULLO. Il criterio congelato del K1 NON cambia (riguarda il COSTO dello stop); la lettura della griglia d1-d4 (par. 3.2) NON dipende dal K1: dipende solo dal G0 (testa par. 5/10).
  - R264d: posizioni 187, PF in posizioni (k 1.8560 tolto) 1.310, EP 4.15 EUR/pos, DD a saldo chiuso 4.058 % (picco 2024.12.09, fondo 2025.07.07), peggior giornata -3.779 % (2026-02-02, denominatore = saldo a inizio giornata), deal/posizione 1.561 [MISURATO dal per-trade]
- **G0 R264a GBPUSD** gemella 796501 OOS 2024.01.01 -> 2026.06.30: Trades 408, Profit 654.48, PF 1.19894, Equity DD % 8.5287 [MISURATO] contro Pass 139 O1 0.25 / O2 0.2 / TP 2.0 (n 362, PF 1.23105, DD 7.2048, Profit 728.66): |dn| 46 (1% = 3.62, 3% = 10.86), |dPF| 0.032, dDD rel 0.184 -> **ROSSO: il banco NON rifa' l'archivio**: le letture OOS contro il genetico (ponte, OOS delle griglie) diventano NON CONFRONTABILI; l'IS resta leggibile da solo
  - K1 R264a dal LOTTO [DERIVATO dal per-trade abtg_trades_ABTG_EMA200_GBPUSD_796501.csv, R = saldo x 0,5% per gamba, k 2.3387 tolto]: posizioni 212, coppie gamba1/gamba2 87, singole 38, vol2/vol1 mediano 1.467 (atteso 1.45, fuori [1.16 ; 1.812] in 0 coppie), ATR da gamba 1 e 2 oltre +-12% in 0 coppie (INFORMATIVO: la testa R264 par. 5 congela solo vol2/vol1, la riga aggiunge i 12% e puo' dire NULLO dove la testa no (classe 875)); stop gamba 2 MEDIANO: limite basso 29.18 pip, alto 30.72 pip (gamba 1 ~43.40); soglia: GBPUSD: 33,7 pip = 40 x 0,8425 (logger 0,300 + comm. 0,5425); col metro della sonda 29,7 pip -> **K1 NON RISOLTO** (la soglia sta fra le due mediane o entro +-15%: INDICATIVO, serve la lettura diretta: corsa singola con InpVerbose o ATR(14) H4 sul grafico)
  - R264a: posizioni 212, PF in posizioni (k 2.3387 tolto) 1.202, EP 3.09 EUR/pos, DD a saldo chiuso 7.324 % (picco 2024.12.12, fondo 2025.10.01), peggior giornata -1.112 % (2025-09-05, denominatore = saldo a inizio giornata), deal/posizione 1.925 [MISURATO dal per-trade]
- **G0 R264b AUDJPY** gemella 796511 OOS 2024.01.01 -> 2026.06.30: Trades 270, Profit 1021.21, PF 1.42240, Equity DD % 6.2755 [MISURATO] contro Pass 411 O1 0.05 / O2 0.4 / TP 3.0 (n 265, PF 1.51365, DD 6.2606, Profit 1181.78): |dn| 5 (1% = 2.65, 3% = 7.95), |dPF| 0.091, dDD rel 0.002 -> **ROSSO: il banco NON rifa' l'archivio**: le letture OOS contro il genetico (ponte, OOS delle griglie) diventano NON CONFRONTABILI; l'IS resta leggibile da solo
  - K1 R264b dal LOTTO [DERIVATO dal per-trade abtg_trades_ABTG_EMA200_AUDJPY_796511.csv, R = saldo x 0,5% per gamba, k 1.1918 tolto]: posizioni 148, coppie gamba1/gamba2 60, singole 28, vol2/vol1 mediano 1.467 (atteso 1.45, fuori [1.16 ; 1.812] in 0 coppie), ATR da gamba 1 e 2 oltre +-12% in 0 coppie (INFORMATIVO: la testa R264 par. 5 congela solo vol2/vol1, la riga aggiunge i 12% e puo' dire NULLO dove la testa no (classe 875)); stop gamba 2 MEDIANO: limite basso 40.30 pip, alto 42.05 pip (gamba 1 ~59.18); soglia: AUDJPY: spread e commissione NON MISURATI: SOLO LETTURA dello stop, nessun verdetto -> **K1 SOLO LETTURA** (nessuna soglia decidibile su questo simbolo: numero riportato)
  - R264b: posizioni 148, PF in posizioni (k 1.1918 tolto) 1.427, EP 6.90 EUR/pos, DD a saldo chiuso 5.423 % (picco 2025.03.26, fondo 2025.08.08), peggior giornata -1.057 % (2025-06-03, denominatore = saldo a inizio giornata), deal/posizione 1.824 [MISURATO dal per-trade]
- **G0 R265a EURUSD** gemella 798501 OOS 2024.01.01 -> 2026.06.30: Trades 206, Profit 396.42, PF 1.27239, Equity DD % 5.1117 [MISURATO] contro Pass 94 O1 0.30 / O2 0.5 / TP 1.5 solo corto (n 180, PF 1.32379, DD 4.3273, Profit 441.21): |dn| 26 (1% = 1.80, 3% = 5.40), |dPF| 0.051, dDD rel 0.181 -> **ROSSO: il banco NON rifa' l'archivio** -> l'IPOTESI sul banco della scansione e' FALSA: R265b perde l'ancora ma resta leggibile da solo, K1 resta valido
  - K1 R265a dal LOTTO [DERIVATO dal per-trade abtg_trades_ABTG_EMA200_EURUSD_798501.csv, R = saldo x 0,5% per gamba, k 2.0000 tolto]: posizioni 104, coppie gamba1/gamba2 36, singole 32, vol2/vol1 mediano 1.857 (atteso 1.80, fuori [1.50 ; 2.2] in 0 coppie), ATR da gamba 1 e 2 oltre +-12% in 0 coppie (clausola della testa R265 par. 2: oltre meta' delle coppie = K1 NULLO); stop gamba 2 MEDIANO: limite basso 23.40 pip, alto 24.40 pip (gamba 1 ~43.72); soglia: EURUSD: 26,54 pip = 40 x 0,6636 (logger 0,200 + comm. 0,4636); al P95 38,54; col metro della sonda 34,56 -> **K1 FAIL**
  - R265a: posizioni 104, PF in posizioni (k 2.0000 tolto) 1.276, EP 3.81 EUR/pos, DD a saldo chiuso 4.196 % (picco 2025.02.12, fondo 2026.01.20), peggior giornata -1.000 % (2025-11-13, denominatore = saldo a inizio giornata), deal/posizione 1.981 [MISURATO dal per-trade]
- **DIAGNOSI DEL ROSSO (classe 913, [MISURATO] dal CSV e dal per-trade della gemella; banco contro genetico)**: R264c GBPJPY: n +21, PF -0.017, posizioni al pavimento 0,01: 0 su 144 | R264d XAUUSD: n +105, PF -0.072, posizioni al pavimento 0,01: 61 su 187 | R264a GBPUSD: n +46, PF -0.032, posizioni al pavimento 0,01: 0 su 212 | R264b AUDJPY: n +5, PF -0.091, posizioni al pavimento 0,01: 0 su 148 | R265a EURUSD: n +26, PF -0.051, posizioni al pavimento 0,01: 0 su 104 (banco della scansione NON VERIFICATO: si riporta, non entra nella firma) -> **CAUSA NON DIMOSTRATA. Lo stesso segno (n del banco PIU' ALTO, PF PIU' BASSO del genetico) su tutti i 4 ROSSI di R264, e 3 simboli (GBPJPY, GBPUSD, AUDJPY) SENZA nessuna posizione al pavimento: il lotto 0,01 (causa nominata dalla testa R264 par. 5 per l'oro) NON e' la causa COMUNE, e l'attesa VERDE della testa sui forex e' SMENTITA. Sull'oro il pavimento resta una causa AGGIUNTIVA possibile, NON dimostrata. Ipotesi per nome: H_BINARIO (il sorgente a HEAD non e' 0953846c del genetico: 3af47ed9 lotto da OrderCalcProfit, 344a11b9 breakeven); H_STORICO (i tick BCM di oggi non sono quelli del 01/08); H_SPEC (commissione/swap del simbolo nel tester di oggi). La misura che le separa: lo STESSO G0 col binario 0953846c (rifa' l'archivio -> H_BINARIO; non lo rifa' -> H_STORICO/H_SPEC)**

- metro tick EMA200 H4 (dalla riga, si riporta): METRO TICK EMA200 H4 MISURATO OGGI dal primo job R264c: 3.9 min per file (2 finestre piene + 2 monconi + compilazione) = ~1.95 min per finestra piena; era [NON MISURATO] (classe 751: il 135 s di R240 

## 2. R264b1 -- IL PONTE AUDJPY (testa par. 9: le 4 celle di R139a sulla finestra del genetico, a OHLC)

- TP 1.5: Trades 312, Profit 1033.70, PF 1.48326, Equity DD % 4.4541 [MISURATO] -- archivio: tick d'archivio PF 1.71095 n 276 DD 2.8888
- TP 2.0: Trades 319, Profit 949.96, PF 1.42624, Equity DD % 4.4640 [MISURATO] -- archivio: tick d'archivio PF 1.62295 n 283 DD 2.9009
- TP 2.5: Trades 321, Profit 982.75, PF 1.43986, Equity DD % 4.4590 [MISURATO] -- archivio: NON visitata dal genetico
- TP 3.0: Trades 322, Profit 990.79, PF 1.44346, Equity DD % 4.4590 [MISURATO] -- archivio: tick d'archivio PF 1.64064 n 286 DD 2.9174
- celle con PF >= 1,45: 1 su 4; sotto 1,25: 0 su 4 -> **NON CONFRONTABILE (G0 R264b ROSSO, testa par. 5: il banco non rifa' l'archivio; la parola CONFERMA/SMENTITA non si scrive)**
- per-trade 796512: cella InpTP_RR=3.0 -> posizioni 164, PF in posizioni (k 1.1877 tolto) 1.448, EP 6.04 EUR/pos, DD a saldo chiuso 3.607 % (picco 2025.03.26, fondo 2025.06.13), peggior giornata -1.029 % (2026-04-07, denominatore = saldo a inizio giornata), deal/posizione 1.963 [MISURATO dal per-trade]
- previsione della testa: CONFERMA. Riserva scritta al par. 2.1: InpTP1Pct su AUDJPY resta MAI MISURATO (casella 3 riempita col TP_RR, che il motore scavalca).

## 3. R264 -- LE GRIGLIE 3 x 3 (testa par. 6-8: CENTRO = la cella di MEZZO O1 0,20 / O2 centrale, MAI il picco; classe 845)

### 3.1 GBPJPY (G0 R264c: ROSSO) -- IS 2019-2023: fine ciclo pre-Covid, crollo Covid 2020, inflazione e rialzi 2022-2023 (yen debole)

- S2 NON VERIFICABILE: un file della griglia e' NULLO o SALTATO (R264c1 SALTATO, R264c2 SALTATO, R264c3 SALTATO)
- USCITA R264c4: NON VERIFICABILE (SALTATO)

### 3.2 XAUUSD (G0 R264d: ROSSO) -- IS 2017-2023: laterale 2017-2018, toro 2019-2020, laterale 2021-2022, toro 2023

- S2 NON VERIFICABILE: un file della griglia e' NULLO o SALTATO (R264d1 SALTATO, R264d2 SALTATO, R264d3 SALTATO)
- USCITA R264d4: NON VERIFICABILE (SALTATO)

### 3.3 GBPUSD (G0 R264a: ROSSO) -- IS 2020-2023: crollo Covid, dollaro debole 2020-2021, rialzi Fed e mini-budget 2022, laterale 2023

- S2 NON VERIFICABILE: un file della griglia e' NULLO o SALTATO (R264a1 SALTATO, R264a2 SALTATO, R264a3 SALTATO)
- USCITA R264a4: NON VERIFICABILE (SALTATO)


## 4. R265b -- WALK-FORWARD EURUSD SOLO CORTO (testa R265 par. 4: griglia a UNA dimensione, O2 0,1..0,4; parte SOLO con K1 di R265a PASS)

- regime: IS 2017-2023 (R265 par. 4): euro in salita 2017/2020, in discesa 2018/2021-2022, 2023 laterale-rialzista -> bilanciato per H_DERIVA; OOS 2024-2026 = la finestra della scansione (NON cieca a livello di vicinato, R264 par. 4)
- SALTATO (non lanciato, NON un nullo di catena): SALTATO: R265b parte SOLO con K1 di R265a = PASS (testa R265a par. 2-4); qui K1 = FAIL -> EURUSD H4 ESCLUSO PER COSTO col numero accanto (stop mediano ordine 2 sotto 26,54 pip) -> K1 di R265a = FAIL
- **EURUSD H4 solo corto ESCLUSO PER COSTO a InpSLatr 1,0**: stop mediano della gamba 2 [23.40 ; 24.40] pip = 35.3-36.8x il pedaggio all-in 0,6636 pip, contro 40x = 26,54 (testa R265 par. 2) [DERIVATO dal lotto]. Certificato di morte (09/09) del CANDIDATO EMA200 EURUSD solo corto: coperte da QUESTO round: (1) PF, (2) n e DD, (4) gemelli, (5) TF; NON ANCORA MISURATO (mancano: (3) uscita ad asse) [(5) TF dall archivio R29a/R140a, non da questo round; G0 R265a: vedi par. 1] -- la leva del costo nominata dalla testa R264 par. 11 e' InpSLatr (la larghezza dello stop), MAI messa ad asse; TF: H1 escluso per costo 20,8x (R140a), H4 qui

## 5. R266 -- BOX ASIATICO 00:00-07:59 GBPUSD / EURUSD (testa R266a par. 6.3 HN/HE/H0, par. 7 R2/R3/K1/D1, R4 nessuna cella si promuove)

- regime dichiarato (Emendamento A/C): IS 2015-2019 (R266 par. 8): QE BCE e dollaro forte, shock Brexit 2016, compressione 2017-2019 = SHOCK + LATERALE/COMPRESSO (gli anni della sonda); OOS 2020-2026: crollo Covid, trend del dollaro e rialzi 2021-2022, laterale 2023-2024, dollaro debole 2025 = CROLLO + TREND + LATERALE
- il per-trade che sopravvive e' quello della gamba OOS (par. 9): le posizioni IS sono DERIVATE da Trades IS / (deal per posizione dell'OOS).

- **R266a GBPUSD DUE LATI**: IS Trades 1398, Profit 1524.12, PF 1.05717, Equity DD % 21.6147 | OOS Trades 1707, Profit 1437.64, PF 1.05264, Equity DD % 13.8850 [MISURATO dal CSV]
  - per-trade OOS 796601: posizioni 999, PF in posizioni (k 2.3119 tolto) 1.053, EP 1.44 EUR/pos, DD a saldo chiuso 13.087 % (picco 2025.11.07, fondo 2026.03.24), peggior giornata -1.018 % (2021-02-12, denominatore = saldo a inizio giornata), deal/posizione 1.709 [MISURATO dal per-trade]
  - D0 STORICO (par. 7, scritto PRIMA del merito IS): prima data dello storico nei log: 1993.05.11 (0002_Tester_logs_20260928.log), contro l'inizio IS 2015.01.01 [MISURATO dal giornale; non dice di quale gamba; la testa non congela una data-soglia: si scrive, non decide]
  - banda n attesa (posizioni, par. 6.2): IS 529-1129, OOS 687-1467 -> IS DERIVATE 818.2 dentro, OOS 999 dentro
  - D1 CIFRE: ok (Trades IS 1398 >= 20)
  - **R2 MERITO: H0 piatto / niente (R2 violato: PF IS 1.057, PF OOS 1.053, almeno uno < 1,10)**
  - R3 RISCHIO a 1% (a qualunque n): DD IS 21.61 / DD OOS 13.88 -> a 2,00 [38.56 ; 43.23] % [DERIVATO, R193b B3] -> FUORI da S3 a 2,00 (d > 4,00 lineare e > 4,08 moltiplicativa) (d = il DD piu' alto fra IS e OOS: IS); OHLC = limite inferiore; VIOLATO (DD IS e OOS a 1% <= 4,08 (S3 di R193b tradotta); boccia a qualunque n, Emendamento B)
  - K1 a campione sul per-trade OOS (classe 846, q_min 0,80, R = saldo x 1%): limite alto dello stop minimo 35.24 pip contro cancello 33.70 pip, posizioni sotto: 0 su 999 -> costo GARANTITO per costruzione (stop = W + 2 x buffer >= 40x)
  - R2 anno per anno OOS (posizioni, k tolto): 2020: 200 pos PF 1.107, 2021: 154 pos PF 0.830, 2022: 200 pos PF 1.239, 2023: 173 pos PF 1.013, 2024: 83 pos PF 1.362, 2025: 126 pos PF 1.099, 2026: 63 pos PF 0.690
  - spezzato OOS (informazione, non cancello): mesi SFASATI (orologio BCM, par. 3) 80 pos PF 0.566, mesi ALLINEATI 919 pos PF 1.115
- DD alle taglie [DERIVATO, R193b B3, da Equity DD % OOS a 1.00%]: 0.50%: 7.20-6.94%; 1.50%: 20.09-20.83%; 2.00%: 25.84-27.77% -- **NESSUNA PROPOSTA DI TAGLIA**
  - certificato di morte (09/09): coperte da QUESTO round: (1) PF, (2) n e DD, (4) gemelli; NON ANCORA MISURATO (mancano: (3) uscita ad asse, (5) TF) [PF IS 1.057, OOS 1.053] -- R4: un H0 NON e' un certificato di morte (gestione = default dell'EA, TF fisso H1)
- **R266b GBPUSD SOLO LONG**: IS Trades 739, Profit 1160.66, PF 1.08912, Equity DD % 12.7534 | OOS Trades 910, Profit 870.18, PF 1.06044, Equity DD % 10.8701 [MISURATO dal CSV]
  - per-trade OOS 796602: posizioni 539, PF in posizioni (k 2.3118 tolto) 1.061, EP 1.61 EUR/pos, DD a saldo chiuso 10.383 % (picco 2021.01.21, fondo 2023.10.24), peggior giornata -1.021 % (2022-03-31, denominatore = saldo a inizio giornata), deal/posizione 1.688 [MISURATO dal per-trade]
  - D0 STORICO (par. 7, scritto PRIMA del merito IS): prima data dello storico nei log: 1993.05.11 (0002_Tester_logs_20260928.log), contro l'inizio IS 2015.01.01 [MISURATO dal giornale; non dice di quale gamba; la testa non congela una data-soglia: si scrive, non decide]
  - banda n attesa (posizioni, par. 6.2): IS 268-573, OOS 349-745 -> IS DERIVATE 437.7 dentro, OOS 539 dentro
  - D1 CIFRE: ok (Trades IS 739 >= 20)
  - **R2 MERITO: H0 piatto / niente (R2 violato: PF IS 1.089, PF OOS 1.060, almeno uno < 1,10)**
  - R3 RISCHIO a 1% (a qualunque n): DD IS 12.75 / DD OOS 10.87 -> a 2,00 [23.88 ; 25.51] % [DERIVATO, R193b B3] -> FUORI da S3 a 2,00 (d > 4,00 lineare e > 4,08 moltiplicativa) (d = il DD piu' alto fra IS e OOS: IS); OHLC = limite inferiore; VIOLATO (DD IS e OOS a 1% <= 4,08 (S3 di R193b tradotta); boccia a qualunque n, Emendamento B)
  - K1 a campione sul per-trade OOS (classe 846, q_min 0,80, R = saldo x 1%): limite alto dello stop minimo 35.55 pip contro cancello 33.70 pip, posizioni sotto: 0 su 539 -> costo GARANTITO per costruzione (stop = W + 2 x buffer >= 40x)
  - R2 anno per anno OOS (posizioni, k tolto): 2020: 113 pos PF 1.292, 2021: 86 pos PF 0.895, 2022: 108 pos PF 0.904, 2023: 89 pos PF 1.069, 2024: 42 pos PF 1.258, 2025: 65 pos PF 1.412, 2026: 36 pos PF 0.739
  - spezzato OOS (informazione, non cancello): mesi SFASATI (orologio BCM, par. 3) 44 pos PF 0.615, mesi ALLINEATI 495 pos PF 1.115
- DD alle taglie [DERIVATO, R193b B3, da Equity DD % OOS a 1.00%]: 0.50%: 5.59-5.44%; 1.50%: 15.85-16.31%; 2.00%: 20.56-21.74% -- **NESSUNA PROPOSTA DI TAGLIA**
  - certificato di morte (09/09): coperte da QUESTO round: (1) PF, (2) n e DD, (4) gemelli; NON ANCORA MISURATO (mancano: (3) uscita ad asse, (5) TF) [PF IS 1.089, OOS 1.060] -- R4: un H0 NON e' un certificato di morte (gestione = default dell'EA, TF fisso H1)
- **R266c GBPUSD SOLO SHORT**: IS Trades 818, Profit 717.11, PF 1.04518, Equity DD % 20.3726 | OOS Trades 927, Profit 1109.02, PF 1.07472, Equity DD % 12.6967 [MISURATO dal CSV]
  - per-trade OOS 796603: posizioni 540, PF in posizioni (k 2.3103 tolto) 1.076, EP 2.05 EUR/pos, DD a saldo chiuso 11.871 % (picco 2020.04.21, fondo 2021.10.25), peggior giornata -1.014 % (2023-02-10, denominatore = saldo a inizio giornata), deal/posizione 1.717 [MISURATO dal per-trade]
  - D0 STORICO (par. 7, scritto PRIMA del merito IS): prima data dello storico nei log: 1993.05.11 (0002_Tester_logs_20260928.log), contro l'inizio IS 2015.01.01 [MISURATO dal giornale; non dice di quale gamba; la testa non congela una data-soglia: si scrive, non decide]
  - banda n attesa (posizioni, par. 6.2): IS 317-677, OOS 412-879 -> IS DERIVATE 476.5 dentro, OOS 540 dentro
  - D1 CIFRE: ok (Trades IS 818 >= 20)
  - **R2 MERITO: H0 piatto / niente (R2 violato: PF IS 1.045, PF OOS 1.075, almeno uno < 1,10)**
  - R3 RISCHIO a 1% (a qualunque n): DD IS 20.37 / DD OOS 12.70 -> a 2,00 [36.59 ; 40.75] % [DERIVATO, R193b B3] -> FUORI da S3 a 2,00 (d > 4,00 lineare e > 4,08 moltiplicativa) (d = il DD piu' alto fra IS e OOS: IS); OHLC = limite inferiore; VIOLATO (DD IS e OOS a 1% <= 4,08 (S3 di R193b tradotta); boccia a qualunque n, Emendamento B)
  - K1 a campione sul per-trade OOS (classe 846, q_min 0,80, R = saldo x 1%): limite alto dello stop minimo 36.47 pip contro cancello 33.70 pip, posizioni sotto: 0 su 540 -> costo GARANTITO per costruzione (stop = W + 2 x buffer >= 40x)
  - R2 anno per anno OOS (posizioni, k tolto): 2020: 109 pos PF 0.903, 2021: 77 pos PF 0.795, 2022: 105 pos PF 1.937, 2023: 103 pos PF 0.984, 2024: 43 pos PF 1.710, 2025: 71 pos PF 0.814, 2026: 32 pos PF 0.723
  - spezzato OOS (informazione, non cancello): mesi SFASATI (orologio BCM, par. 3) 46 pos PF 0.513, mesi ALLINEATI 494 pos PF 1.155
- DD alle taglie [DERIVATO, R193b B3, da Equity DD % OOS a 1.00%]: 0.50%: 6.56-6.35%; 1.50%: 18.43-19.05%; 2.00%: 23.78-25.39% -- **NESSUNA PROPOSTA DI TAGLIA**
  - certificato di morte (09/09): coperte da QUESTO round: (1) PF, (2) n e DD, (4) gemelli; NON ANCORA MISURATO (mancano: (3) uscita ad asse, (5) TF) [PF IS 1.045, OOS 1.075] -- R4: un H0 NON e' un certificato di morte (gestione = default dell'EA, TF fisso H1)
- **R266d EURUSD DUE LATI**: IS Trades 1384, Profit -140.23, PF 0.99392, Equity DD % 21.4765 | OOS Trades 1614, Profit 1004.92, PF 1.03785, Equity DD % 15.8686 [MISURATO dal CSV]
  - per-trade OOS 796604: posizioni 935, PF in posizioni (k 2.0000 tolto) 1.038, EP 1.07 EUR/pos, DD a saldo chiuso 15.277 % (picco 2025.06.06, fondo 2026.03.24), peggior giornata -1.015 % (2021-02-24, denominatore = saldo a inizio giornata), deal/posizione 1.726 [MISURATO dal per-trade]
  - D0 STORICO (par. 7, scritto PRIMA del merito IS): prima data dello storico nei log: 1971.01.03 (0002_Tester_logs_20260928.log), contro l'inizio IS 2015.01.01 [MISURATO dal giornale; non dice di quale gamba; la testa non congela una data-soglia: si scrive, non decide]
  - banda n attesa (posizioni, par. 6.2): IS 378-1129, OOS 491-1467 -> IS DERIVATE 801.8 dentro, OOS 935 dentro
  - D1 CIFRE: ok (Trades IS 1384 >= 20)
  - **R2 MERITO: H0 piatto / niente (R2 violato: PF IS 0.994, PF OOS 1.038, almeno uno < 1,10)**
  - R3 RISCHIO a 1% (a qualunque n): DD IS 21.48 / DD OOS 15.87 -> a 2,00 [38.34 ; 42.95] % [DERIVATO, R193b B3] -> FUORI da S3 a 2,00 (d > 4,00 lineare e > 4,08 moltiplicativa) (d = il DD piu' alto fra IS e OOS: IS); OHLC = limite inferiore; VIOLATO (DD IS e OOS a 1% <= 4,08 (S3 di R193b tradotta); boccia a qualunque n, Emendamento B)
  - K1 a campione sul per-trade OOS (classe 846, q_min 0,80, R = saldo x 1%): limite alto dello stop minimo 27.57 pip contro cancello 26.60 pip, posizioni sotto: 0 su 935 -> costo GARANTITO per costruzione (stop = W + 2 x buffer >= 40x)
  - R2 anno per anno OOS (posizioni, k tolto): 2020: 162 pos PF 1.155, 2021: 135 pos PF 1.106, 2022: 197 pos PF 1.104, 2023: 160 pos PF 0.957, 2024: 76 pos PF 1.593, 2025: 144 pos PF 0.867, 2026: 61 pos PF 0.692
  - spezzato OOS (informazione, non cancello): mesi SFASATI (orologio BCM, par. 3) 80 pos PF 0.590, mesi ALLINEATI 855 pos PF 1.100
- DD alle taglie [DERIVATO, R193b B3, da Equity DD % OOS a 1.00%]: 0.50%: 8.28-7.93%; 1.50%: 22.83-23.80%; 2.00%: 29.22-31.74% -- **NESSUNA PROPOSTA DI TAGLIA**
  - certificato di morte (09/09): coperte da QUESTO round: (1) PF, (2) n e DD, (4) gemelli; NON ANCORA MISURATO (mancano: (3) uscita ad asse, (5) TF) [PF IS 0.994, OOS 1.038] -- R4: un H0 NON e' un certificato di morte (gestione = default dell'EA, TF fisso H1)
- **R266e EURUSD SOLO LONG**: IS Trades 766, Profit -1587.89, PF 0.87622, Equity DD % 21.0914 | OOS Trades 869, Profit 1150.14, PF 1.08896, Equity DD % 9.8240 [MISURATO dal CSV]
  - per-trade OOS 796605: posizioni 503, PF in posizioni (k 2.0000 tolto) 1.091, EP 2.29 EUR/pos, DD a saldo chiuso 8.985 % (picco 2025.06.27, fondo 2026.03.24), peggior giornata -1.016 % (2021-02-24, denominatore = saldo a inizio giornata), deal/posizione 1.728 [MISURATO dal per-trade]
  - D0 STORICO (par. 7, scritto PRIMA del merito IS): prima data dello storico nei log: 1971.01.03 (0002_Tester_logs_20260928.log), contro l'inizio IS 2015.01.01 [MISURATO dal giornale; non dice di quale gamba; la testa non congela una data-soglia: si scrive, non decide]
  - banda n attesa (posizioni, par. 6.2): IS 192-573, OOS 249-745 -> IS DERIVATE 443.4 dentro, OOS 503 dentro
  - D1 CIFRE: ok (Trades IS 766 >= 20)
  - **R2 MERITO: H0 piatto / niente (R2 violato: PF IS 0.876, PF OOS 1.089, almeno uno < 1,10)**
  - R3 RISCHIO a 1% (a qualunque n): DD IS 21.09 / DD OOS 9.82 -> a 2,00 [37.73 ; 42.18] % [DERIVATO, R193b B3] -> FUORI da S3 a 2,00 (d > 4,00 lineare e > 4,08 moltiplicativa) (d = il DD piu' alto fra IS e OOS: IS); OHLC = limite inferiore; VIOLATO (DD IS e OOS a 1% <= 4,08 (S3 di R193b tradotta); boccia a qualunque n, Emendamento B)
  - K1 a campione sul per-trade OOS (classe 846, q_min 0,80, R = saldo x 1%): limite alto dello stop minimo 28.11 pip contro cancello 26.60 pip, posizioni sotto: 0 su 503 -> costo GARANTITO per costruzione (stop = W + 2 x buffer >= 40x)
  - R2 anno per anno OOS (posizioni, k tolto): 2020: 85 pos PF 1.257, 2021: 70 pos PF 1.170, 2022: 103 pos PF 0.976, 2023: 96 pos PF 0.884, 2024: 36 pos PF 3.263, 2025: 79 pos PF 1.104, 2026: 34 pos PF 0.777
  - spezzato OOS (informazione, non cancello): mesi SFASATI (orologio BCM, par. 3) 45 pos PF 0.796, mesi ALLINEATI 458 pos PF 1.129
- DD alle taglie [DERIVATO, R193b B3, da Equity DD % OOS a 1.00%]: 0.50%: 5.04-4.91%; 1.50%: 14.37-14.74%; 2.00%: 18.68-19.65% -- **NESSUNA PROPOSTA DI TAGLIA**
  - certificato di morte (09/09): coperte da QUESTO round: (1) PF, (2) n e DD, (4) gemelli; NON ANCORA MISURATO (mancano: (3) uscita ad asse, (5) TF) [PF IS 0.876, OOS 1.089] -- R4: un H0 NON e' un certificato di morte (gestione = default dell'EA, TF fisso H1)
- **R266f EURUSD SOLO SHORT**: IS Trades 720, Profit 3090.02, PF 1.27939, Equity DD % 7.1559 | OOS Trades 829, Profit 82.50, PF 1.00601, Equity DD % 13.1692 [MISURATO dal CSV]
  - per-trade OOS 796606: posizioni 482, PF in posizioni (k 2.0000 tolto) 1.006, EP 0.17 EUR/pos, DD a saldo chiuso 13.078 % (picco 2024.09.20, fondo 2026.06.08), peggior giornata -1.011 % (2026-05-20, denominatore = saldo a inizio giornata), deal/posizione 1.720 [MISURATO dal per-trade]
  - D0 STORICO (par. 7, scritto PRIMA del merito IS): prima data dello storico nei log: 1971.01.03 (0002_Tester_logs_20260928.log), contro l'inizio IS 2015.01.01 [MISURATO dal giornale; non dice di quale gamba; la testa non congela una data-soglia: si scrive, non decide]
  - banda n attesa (posizioni, par. 6.2): IS 226-677, OOS 294-879 -> IS DERIVATE 418.6 dentro, OOS 482 dentro
  - D1 CIFRE: ok (Trades IS 720 >= 20)
  - **R2 MERITO: H0 piatto / niente (R2 violato: PF IS 1.279, PF OOS 1.006, almeno uno < 1,10)**
  - R3 RISCHIO a 1% (a qualunque n): DD IS 7.16 / DD OOS 13.17 -> a 2,00 [24.60 ; 26.34] % [DERIVATO, R193b B3] -> FUORI da S3 a 2,00 (d > 4,00 lineare e > 4,08 moltiplicativa) (d = il DD piu' alto fra IS e OOS: OOS); OHLC = limite inferiore; VIOLATO (DD IS e OOS a 1% <= 4,08 (S3 di R193b tradotta); boccia a qualunque n, Emendamento B)
  - K1 a campione sul per-trade OOS (classe 846, q_min 0,80, R = saldo x 1%): limite alto dello stop minimo 27.62 pip contro cancello 26.60 pip, posizioni sotto: 0 su 482 -> costo GARANTITO per costruzione (stop = W + 2 x buffer >= 40x)
  - R2 anno per anno OOS (posizioni, k tolto): 2020: 88 pos PF 1.109, 2021: 71 pos PF 1.060, 2022: 104 pos PF 1.225, 2023: 76 pos PF 1.142, 2024: 42 pos PF 1.078, 2025: 71 pos PF 0.645, 2026: 30 pos PF 0.612
  - spezzato OOS (informazione, non cancello): mesi SFASATI (orologio BCM, par. 3) 41 pos PF 0.464, mesi ALLINEATI 441 pos PF 1.082
- DD alle taglie [DERIVATO, R193b B3, da Equity DD % OOS a 1.00%]: 0.50%: 6.82-6.58%; 1.50%: 19.09-19.75%; 2.00%: 24.60-26.34% -- **NESSUNA PROPOSTA DI TAGLIA**
  - certificato di morte (09/09): coperte da QUESTO round: (1) PF, (2) n e DD, (4) gemelli; NON ANCORA MISURATO (mancano: (3) uscita ad asse, (5) TF) [PF IS 1.279, OOS 1.006] -- R4: un H0 NON e' un certificato di morte (gestione = default dell'EA, TF fisso H1)

**L0 STRUTTURA per simbolo (par. 6.2: posizioni OOS n_long + n_short >= n_due_lati; se no un pin di lato non e' arrivato)**
- GBPUSD: long 539 + short 540 = 1079 contro due lati 999 -> ok (OCO: una posizione al giorno)
- EURUSD: long 503 + short 482 = 985 contro due lati 935 -> ok (OCO: una posizione al giorno)

- R4: NESSUNA cella si promuove (sei configurazioni fisse). Se un file esce HE il passo dopo (altopiano buffer/cutoff + riprova a tick) e' una FIRMA di Claudio.

## 6. R260d -- ORO 770402 SOLO LONG COL TREND DELL'ORO (testa R260d par. 3-4: T3, S0, T5, partizione HN/HQ/H0/HG/HR)

- regime: 2020.01-2026.06 (R260c par. 5): toro 2020, laterale 2021-2022, toro 2023-2026; meta' esatta al 2023.04.01
- T5 ORDINE: G0 di R260c (esterno, ESTERNI/ della raccolta): Trades 693, Profit 24736.49, PF 1.30771, Equity DD % 5.3158 contro R103 693 / 1.308 / 24736 / 5.32 -> **VERDE**
- ancora R260a: R260a: CSV e per-trade 795301 presenti (ESTERNI/ della raccolta), 375 righe, 279 posizioni, chiusure 2020.01.03 -> 2026.06.26 -> IDENTIFICATO cella InpMagic=795301 (k 1.8113)
- T3 FILTRO ESEGUITO? R260d Trades 238, Profit 13231.81, PF 1.55682, Equity DD % 3.3848 contro R260a Trades 375, Profit 14062.14, PF 1.33476, Equity DD % 4.5172 -> T3 ok: il filtro ha morso (Trades 238 contro 375; Profit 13231.81 contro 14062.14; Profit Factor 1.55682 contro 1.33476; Equity DD % 3.3848 contro 4.5172)
- S0 SOTTOINSIEME (ogni chiusura di R260d in close_time|deal_type|price esiste in R260a): righe 238, trovate 238, parziali ammesse 0, senza gemello 0 -> S0 ok
- PARTIZIONE (posizioni, PF con k tolto): R260d 171 pos PF 1.559 (prima meta' < 2023.04.01: 70 pos PF 1.768; seconda: 101 pos PF 1.418) R2 rispettato | R260a 279 pos PF 1.336 = TENUTE 171 pos PF 1.558 + RIMOSSE 108 pos PF 1.051 (quota tenuta 0.613, stima 0,55-0,75) ==> **HR il cancello TAGLIA, non separa (R2 ok ma le rimosse non erano peggiori di 0,90, o il guadagno di PF sta sotto 0,10) -- la previsione scritta prima**
- RISCHIO (a qualunque n, Emendamento B): DD R260d a 0,5% 3.38 contro 2,00 (lineare) / 2,06 (moltiplicativa) = S3 di R193b tradotta a 0,5% -> NON sta sotto S3 a 2,00 (a 2,00: 12.87-13.54 %); VIOLATO (DD a 0,5% <= 2,06; boccia a qualunque n, Emendamento B)
- per-trade 795304: posizioni 171, PF in posizioni (k 1.8069 tolto) 1.559, EP 77.38 EUR/pos, DD a saldo chiuso 3.141 % (picco 2023.07.18, fondo 2024.02.27), peggior giornata -0.503 % (2025-01-10, denominatore = saldo a inizio giornata), deal/posizione 1.392 [MISURATO dal per-trade]
- DD alle taglie [DERIVATO, R193b B3, da Equity DD % a 0,5% a 0.50%]: 1.00%: 6.66-6.77%; 1.50%: 9.81-10.15%; 2.00%: 12.87-13.54% -- **NESSUNA PROPOSTA DI TAGLIA**

## 7. R267 -- LE MANOPOLE A COSTO ZERO (R267a par. 0: magic fisso, per-trade IDENTIFICATO classe 850; R267a NON LANCIATO)

### 7.1 R267b -- oro 770402, InpMinBoxPts 0/650/1300/1950/2600 (B1-B6; regime 2020.01-2026.06 (R260c par. 5): toro 2020, laterale 2021-2022, toro 2023-2026; meta' esatta al 2023.04.01)

- B1 G0 in-file: cella 0 Trades 693, Profit 24736.49, PF 1.30771, Equity DD % 5.3158 contro R103 -> **VERDE** | cella 0 contro R260c girato (795303, ESTERNI/ della raccolta): IDENTICA al centesimo
- B3 morde e toglie soltanto: Trades(2600)=98 < Trades(0)=693 si; crescite oltre 2 deal lungo l'asse: 0
| InpMinBoxPts | Trades | PF | DD a 0,5 (contro 2,06) | DD/DD0 | n/n0 | passa B4+PF+n |
|---|---|---|---|---|---|---|
| 0 | 693 | 1.308 | 5.32 (> 2,06) | 1.000 | 1.000 | no |
| 650 | 508 | 1.368 | 3.03 (> 2,06) | 0.571 | 0.733 | no |
| 1300 | 199 | 1.926 | 2.00 (<= 2,06) | 0.376 | 0.287 | no |
| 1950 | 124 | 1.670 | 2.69 (> 2,06) | 0.506 | 0.179 | no |
| 2600 | 98 | 1.916 | 1.76 (<= 2,06) | 0.331 | 0.141 | no |

- B4: un DD che scende in proporzione a n NON e' una leva (si legge DD/DD0 accanto a n/n0); OHLC = limite inferiore.
- B5 ALTOPIANO, MAI IL PICCO (>= 3 celle contigue con DD <= 2,06, PF >= 1,10, >= 203 deal; CENTRO del tratto): NESSUNO: NON C'E' UNA CONFIGURAZIONE ROBUSTA; il PICCO di PF sta a 1300 (1.926); celle che battono la cella 0 di >= 0,10: 1300, 1950, 2600
  - M1-M2 cella 650 contro il CONTROLLO cella 0 dello stesso file (sul CSV; M3 non verificabile: una gamba sola): M1 passa, M2 fallisce, M3 NON VERIFICABILE
  - M1-M2 cella 1300 contro il CONTROLLO cella 0 dello stesso file (sul CSV; M3 non verificabile: una gamba sola): M1 passa, M2 passa, M3 NON VERIFICABILE -- sotto 203 deal: INDIZIO
  - M1-M2 cella 1950 contro il CONTROLLO cella 0 dello stesso file (sul CSV; M3 non verificabile: una gamba sola): M1 passa, M2 passa, M3 NON VERIFICABILE -- sotto 203 deal: INDIZIO
  - M1-M2 cella 2600 contro il CONTROLLO cella 0 dello stesso file (sul CSV; M3 non verificabile: una gamba sola): M1 passa, M2 passa, M3 NON VERIFICABILE -- sotto 203 deal: INDIZIO
- per-trade 796702: cella S=2600 -> posizioni 75, PF in posizioni (k 1.7435 tolto) 1.918, EP 89.79 EUR/pos, DD a saldo chiuso 1.473 % (picco 2025.04.21, fondo 2025.10.22), peggior giornata -0.496 % (2026-06-09, denominatore = saldo a inizio giornata), deal/posizione 1.307 [MISURATO dal per-trade]
- H_GIORNO/H_EPOCA nella finestra 2024.01.01 -> 2026.06.30 del per-trade di R260c (795303, esterno), cella S=2600: TENUTE 69 pos PF 2.015, TOLTE 132 pos PF 1.647 -> H_GIORNO (il box stretto e' un giorno peggiore anche a parita' d'epoca: leva vera)
- B6: nessuna cella si promuove (materiale per Claudio, con riprova a tick).

### 7.2 R267c / R267d -- Dow short (base R255a; C1-C6, V1-V5; regime 2024.09.27-2026.06.30 (R255a): ~21 mesi, UN solo regime, orologio BCM UTC+1 fisso (due ere IS/OOS di R255 al 2025.06.10))

- C1/V1 G0 esterno = R255a: R255a: CSV e per-trade 793101 presenti (ESTERNI/ della raccolta), 146 righe, 111 posizioni, chiusure 2024.10.01 -> 2026.06.11 -> IDENTIFICATO cella InpMagic=793101 (k 0.0000) | R255a 793101: Trades 146, Profit 308.41, PF 1.10790, Equity DD % 8.5112, Peggior Giornata % -1.0584
- R267c: C4 G2 Trades 16/17/R255a = 117/142/146, Profit diversi True -> ok
  - cella 16:00 Trades 117, Profit 609.07, PF 1.27809, Equity DD % 5.2641, Peggior Giornata % -1.0521 -> CODA (il pomeriggio restituiva)
  -   M1-M2 cella 16:00 contro il CONTROLLO R255a (esterno, stesso banco): M1 passa, M2 passa, M3 NON VERIFICABILE -- ~55 posizioni per era: INDIZIO
  - cella 17:00 Trades 142, Profit 529.24, PF 1.20131, Equity DD % 6.4716, Peggior Giornata % -1.0584 -> DENTRO: il default 17:30 va bene
  -   M1-M2 cella 17:00 contro il CONTROLLO R255a (esterno, stesso banco): M1 passa, M2 fallisce, M3 NON VERIFICABILE -- ~55 posizioni per era: INDIZIO
  - C3 orologio morde (cella 17:00): uscite dopo le 17:00:59 = 0 -> ok
  - C2 sottoinsieme (deal con close_time < 17:00:00 con gemello in R255a 793101): 131 deal, senza gemello 0, parziali ammesse 0 -> ok
  - per-trade 796711 cella 17:00: posizioni 107, PF in posizioni (k 0.0000 tolto) 1.201, EP 4.95 EUR/pos, DD a saldo chiuso 6.233 % (picco 2025.07.16, fondo 2026.02.02), peggior giornata -1.058 % (2024-12-24, denominatore = saldo a inizio giornata), deal/posizione 1.327 [MISURATO dal per-trade]; tetto R2 4,272 a saldo chiuso (curva CONTROLLO) -> DD 6.233 % VIOLATO (DD saldo chiuso <= 4,272; boccia a qualunque n, Emendamento B)
  - C5 rischio: DD e Peggior Giornata per cella contro R255a (sopra, informativo; muro giornaliero FTMO -5,00); n ~55 posizioni per era: MERITO SOSPESO PER ARITMETICA; C6 nessuna cella si promuove; la curva IN FASE NON si ricompone qui (buco dichiarato)
- R267d: V1 G0 in-file: cella 0,0 contro R255a 793101 -> IDENTICA al centesimo
  - V2 morde e toglie soltanto: Trades(2,0)=28 < Trades(0,0)=146 si, crescite oltre 2 deal: 0
  - r = Trades(1,5)/Trades(0,0) = 0.390 -> **H_R84 (il precedente NASUSD si trasferisce: ammazza-DD)**
  | InpVolMult | Trades | PF | DD | Peggior Giornata % | DD/DD0 | n/n0 |
  |---|---|---|---|---|---|---|
  | 0.0 | 146 | 1.108 | 8.51 | -1.0584 | 1.000 | 1.000 |
  | 0.5 | 146 | 1.108 | 8.51 | -1.0584 | 1.000 | 1.000 |
  | 1.0 | 115 | 1.028 | 7.05 | -1.0462 | 0.829 | 0.788 |
  | 1.5 | 57 | 0.995 | 5.54 | -1.0359 | 0.651 | 0.390 |
  | 2.0 | 28 | 1.440 | 3.13 | -1.0351 | 0.367 | 0.192 |
  - M1-M2 cella 0.5 contro il CONTROLLO cella 0,0 dello stesso file: M1 passa, M2 fallisce, M3 NON VERIFICABILE -- ~73 deal: INDIZIO, merito SOSPESO
  - M1-M2 cella 1.0 contro il CONTROLLO cella 0,0 dello stesso file: M1 fallisce, M2 fallisce, M3 NON VERIFICABILE -- ~73 deal: INDIZIO, merito SOSPESO
  - M1-M2 cella 1.5 contro il CONTROLLO cella 0,0 dello stesso file: M1 fallisce, M2 fallisce, M3 NON VERIFICABILE -- ~73 deal: INDIZIO, merito SOSPESO
  - M1-M2 cella 2.0 contro il CONTROLLO cella 0,0 dello stesso file: M1 passa, M2 passa, M3 NON VERIFICABILE -- ~73 deal: INDIZIO, merito SOSPESO
  - V4: attesa DD(1,5)/DD(0,0) fra 0,27 e 0,95 sotto H_R84, ~1 sotto H_DILUITO; il tetto R2 4,272 solo sulla cella identificata
  - per-trade 796712: cella 2.0 (attesa 2,0): posizioni 20, PF in posizioni (k 0.0000 tolto) 1.440, EP 13.25 EUR/pos, DD a saldo chiuso 2.919 % (picco 2024.12.23, fondo 2025.01.03), peggior giornata -1.035 % (2024-12-24, denominatore = saldo a inizio giornata), deal/posizione 1.400 [MISURATO dal per-trade]
  - V3 sottoinsieme (cella 2.0 contro R255a 793101): 28 deal, senza gemello 0, parziali ammesse 0 -> ok
  - V5: celle che battono la 0,0 di >= 0,10: 2.0; PF atteso sotto 1 in tutte le celle; nessuna promozione

### 7.3 R267g1-g4 -- DAX long (base R261a corr=1; U1-U6, D1-D6; regime 2024.09.26-2026.06.30 (R261a): tranche unica, ~21 mesi, riscaldamento EMA100 (classe 834) sulle celle alte)

- G0 esterno R261a: R261a: CSV e per-trade 795401 presenti (ESTERNI/ della raccolta), 103 righe, 72 posizioni, chiusure 2024.10.01 -> 2026.06.17 -> IDENTIFICATO cella InpUseCorrelation=1 (k 0.0000)
- U1/D1 chiedono anche T1 (R261d) e T2 (R261c) di R261 VERDI -- la riga rimanda 'al referto della riga B' (classe 888): T1 VERDE, T2 VERDE (dal RIEPILOGO della riga B: /home/user/GITHUB/backtest_pipeline/risultati_archivio/ROUND_CORTI_B_2026-09-27/RIEPILOGO_ROUND_CORTI_B.txt) [si riporta, non decide]
- celle-ancora di g2/g3/g4 identiche fra loro (G interno): R267g2 == R267g3: identiche | R267g2 == R267g4: identiche | R267g3 == R267g4: identiche
- **R267g2 (InpUseTrailing)**: U1 G0 in-file: cella-ancora InpUseTrailing=1 contro R261a corr=1 (esterno) -> IDENTICA al centesimo
  - 0: Trades 107, Profit -40.95, PF 0.99884, Equity DD % 7.8726 -> NULLA; M1-M2 vs ancora: M1 fallisce, M2 fallisce, M3 NON VERIFICABILE; DD a 1% > 4,08: FUORI da S3 a 2,00 (U5)
  - 1: Trades 103, Profit -3952.27, PF 0.88300, Equity DD % 7.8243 (ANCORA); DD a 1% > 4,08: FUORI da S3 a 2,00 (U5)
  - U2 morde: Profit(0) -40.95 contro Profit(1) -3952.27 -> la manopola ha morso
  - per-trade 796742: cella 1: posizioni 72, PF in posizioni (k 0.0000 tolto) 0.883, EP -54.89 EUR/pos, DD a saldo chiuso 6.878 % (picco 2025.06.05, fondo 2026.06.17), peggior giornata -1.091 % (2025-02-14, denominatore = saldo a inizio giornata), deal/posizione 1.431 [MISURATO dal per-trade]
  - U4 stessi ingressi (giornate della cella 1 contro il per-trade 795401 di R261a corr=1): 72 contro 72, solo qui 0, solo in R261a 0 -> ok
  - n ~35-63 posizioni: MERITO SOSPESO PER COSTRUZIONE; effetto di lato R151a: BE e trailing spostano anche TP2; U6 nessuna promozione -- VALUTATA (classe 909(1), rumore = M1 e M2 contro l'ancora, M3 NON VERIFICABILE): celle che battono l'ancora su M1 e M2: nessuna -> IL DEFAULT VA BENE = casella (3) riempita
- **R267g3 (InpBreakeven)**: U1 G0 in-file: cella-ancora InpBreakeven=1 contro R261a corr=1 (esterno) -> IDENTICA al centesimo
  - 0: Trades 103, Profit -5603.50, PF 0.84132, Equity DD % 8.3367 -> NULLA; M1-M2 vs ancora: M1 fallisce, M2 fallisce, M3 NON VERIFICABILE; DD a 1% > 4,08: FUORI da S3 a 2,00 (U5)
  - 1: Trades 103, Profit -3952.27, PF 0.88300, Equity DD % 7.8243 (ANCORA); DD a 1% > 4,08: FUORI da S3 a 2,00 (U5)
  - U2 morde: Profit(0) -5603.50 contro Profit(1) -3952.27 -> la manopola ha morso
  - per-trade 796743: cella 1: posizioni 72, PF in posizioni (k 0.0000 tolto) 0.883, EP -54.89 EUR/pos, DD a saldo chiuso 6.878 % (picco 2025.06.05, fondo 2026.06.17), peggior giornata -1.091 % (2025-02-14, denominatore = saldo a inizio giornata), deal/posizione 1.431 [MISURATO dal per-trade]
  - U4 stessi ingressi (giornate della cella 1 contro il per-trade 795401 di R261a corr=1): 72 contro 72, solo qui 0, solo in R261a 0 -> ok
  - n ~35-63 posizioni: MERITO SOSPESO PER COSTRUZIONE; effetto di lato R151a: BE e trailing spostano anche TP2; U6 nessuna promozione -- VALUTATA (classe 909(1), rumore = M1 e M2 contro l'ancora, M3 NON VERIFICABILE): celle che battono l'ancora su M1 e M2: nessuna -> IL DEFAULT VA BENE = casella (3) riempita
- **R267g4 (InpTP1Pct)**: U1 G0 in-file: cella-ancora InpTP1Pct=50 contro R261a corr=1 (esterno) -> IDENTICA al centesimo
  - 0: Trades 72, Profit -11536.72, PF 0.67912, Equity DD % 12.2986 -> PEGGIORA (PF 0.679 < PF ancora 0.883 - 0,05); M1-M2 vs ancora: M1 fallisce, M2 fallisce, M3 NON VERIFICABILE; DD a 1% > 4,08: FUORI da S3 a 2,00 (U5)
  - 25: Trades 103, Profit -5970.35, PF 0.82106, Equity DD % 9.1928 -> PEGGIORA (PF 0.821 < PF ancora 0.883 - 0,05); M1-M2 vs ancora: M1 fallisce, M2 fallisce, M3 NON VERIFICABILE; DD a 1% > 4,08: FUORI da S3 a 2,00 (U5)
  - 50: Trades 103, Profit -3952.27, PF 0.88300, Equity DD % 7.8243 (ANCORA); DD a 1% > 4,08: FUORI da S3 a 2,00 (U5)
  - 75: Trades 103, Profit -1899.87, PF 0.94443, Equity DD % 6.7699 -> NULLA; M1-M2 vs ancora: M1 fallisce, M2 fallisce, M3 NON VERIFICABILE; DD a 1% > 4,08: FUORI da S3 a 2,00 (U5)
  - U2 morde: Trades(0)=72 < Trades(50)=103 si, Profit 25/50/75 non identici si -> ok
  - per-trade 796744: cella 75: posizioni 72, PF in posizioni (k 0.0000 tolto) 0.944, EP -26.39 EUR/pos, DD a saldo chiuso 5.938 % (picco 2025.06.05, fondo 2025.09.12), peggior giornata -1.093 % (2025-02-14, denominatore = saldo a inizio giornata), deal/posizione 1.431 [MISURATO dal per-trade]
  - U4 stessi ingressi (giornate della cella 75 contro il per-trade 795401 di R261a corr=1): 72 contro 72, solo qui 0, solo in R261a 0 -> ok
  - n ~35-63 posizioni: MERITO SOSPESO PER COSTRUZIONE; effetto di lato R151a: BE e trailing spostano anche TP2; U6 nessuna promozione -- VALUTATA (classe 909(1), rumore = M1 e M2 contro l'ancora, M3 NON VERIFICABILE): celle che battono l'ancora su M1 e M2: nessuna -> IL DEFAULT VA BENE = casella (3) riempita
- **R267g1 (InpCorrTF H4/H6/H8/H12/D1, classe 287)**: D1 G0 esterno: R261a: CSV e per-trade 795401 presenti (ESTERNI/ della raccolta), 103 righe, 72 posizioni, chiusure 2024.10.01 -> 2026.06.17 -> IDENTIFICATO cella InpUseCorrelation=1 (k 0.0000) | R261a corr=0: Trades 147, Profit -4479.57, PF 0.90464, Equity DD % 7.9153
  - H4 (16388): Trades 108, Profit 2035.90, PF 1.06247, Equity DD % 5.7533; DD a 1% > 4,08 FUORI da S3 a 2,00
  - H6 (16390): Trades 109, Profit 1339.76, PF 1.04005, Equity DD % 5.7533; DD a 1% > 4,08 FUORI da S3 a 2,00
  - H8 (16392): Trades 114, Profit -1577.44, PF 0.95701, Equity DD % 6.7557; DD a 1% > 4,08 FUORI da S3 a 2,00
  - H12 (16396): Trades 116, Profit -4902.72, PF 0.87057, Equity DD % 8.3209; DD a 1% > 4,08 FUORI da S3 a 2,00
  - D1 (16408): Trades 128, Profit -6889.51, PF 0.83424, Equity DD % 8.9612; DD a 1% > 4,08 FUORI da S3 a 2,00
  - D2 sottoinsieme di struttura (Trades <= corr=0 + 2): ok | D3 morde (celle con Trades IDENTICI a corr=0 = bias tornato 0 = NON ESEGUITA): nessuna
  - per-trade 796741: cella InpCorrTF=16408 (D1: guardare il mese del primo deal 2024.10.01, riscaldamento EMA100 classe 834): posizioni 93, PF in posizioni (k 0.0000 tolto) 0.834, EP -74.08 EUR/pos, DD a saldo chiuso 7.872 % (picco -, fondo 2026.06.18), peggior giornata -1.093 % (2025-02-14, denominatore = saldo a inizio giornata), deal/posizione 1.376 [MISURATO dal per-trade]
  - partizione sulla cella centrale H8 (MAI il picco): PF 0.957, celle contigue >= 1,10 al massimo 0 -> **H0 il filtro non salva il long (PF(H8) < 1,00): la previsione scritta prima**; ~55-80 posizioni: MERITO SOSPESO; D6 nessuna promozione
  - certificato di morte (09/09): coperte da QUESTO round: (1) PF, (2) n e DD, (3) uscita ad asse, (5) TF; NON ANCORA MISURATO (mancano: (4) gemelli) [PF(H8) 0.957]

### 7.4 R267e1/f1/e2/f2 -- EMA200 GBPJPY / XAUUSD, InpUseAdrFilter e InpFridayClose (E1-E5; OOS 2024.01-2026.06 = la finestra del genetico: conferma DEBOLE (R264 par. 4), NON cieca a livello di vicinato)

- **R267e1 (GBPJPY, InpUseAdrFilter)**: E1 G0 in-file: cella 0 contro R264c (gemella 796521, stesso PC, stesso giro) -> IDENTICA al centesimo; contro il genetico: ROSSO -> il file si legge SOLO al suo interno
  - cella 0 Trades 242, Profit 588.25, PF 1.22354, Equity DD % 4.1244 | cella 1 Trades 235, Profit 446.09, PF 1.16670, Equity DD % 5.1568 | E2 morde: Profit diversi, la manopola ha morso | **H_MORDE (Trades fuori +-2% o |dPF| >= 0,02): il rapporto ATR(H4)/ADR 0,41 e' sbagliato o gli shock sono frequenti -> PEGGIORA (PF 1.167 < PF ancora 1.224 - 0,05)**
  - M1-M2 cella 1 contro il CONTROLLO cella 0 dello stesso file: M1 passa, M2 fallisce, M3 NON VERIFICABILE -- ~100-120 posizioni: INDIZIO, merito SOSPESO
  - E3 rischio: DD 0/1 4.12/5.16 a 1% contro 10,0 -> sotto, derivato a 2,00 x1,956-1,990: 10.09-10.26
  - per-trade 796721: cella 1: posizioni 141, PF in posizioni (k 2.3292 tolto) 1.168, EP 3.16 EUR/pos, DD a saldo chiuso 4.536 % (picco 2025.09.23, fondo 2026.05.22), peggior giornata -1.212 % (2025-11-09, denominatore = saldo a inizio giornata), deal/posizione 1.667 [MISURATO dal per-trade]
  - E4 nessuna promozione -- VALUTATA (classe 909(1), rumore = M1 e M2 contro la cella 0, M3 NON VERIFICABILE): la cella 1 NON batte la 0 su M1 e M2 -> IL DEFAULT (spento) VA BENE; E5 K1 = quello di R264c
- **R267f1 (GBPJPY, InpFridayClose)**: E1 G0 in-file: cella 0 contro R264c (gemella 796521, stesso PC, stesso giro) -> IDENTICA al centesimo; contro il genetico: ROSSO -> il file si legge SOLO al suo interno
  - cella 0 Trades 242, Profit 588.25, PF 1.22354, Equity DD % 4.1244 | cella 1 Trades 239, Profit 491.12, PF 1.19512, Equity DD % 3.9336 | E2 morde: Profit diversi, la manopola ha morso | **NULLA** | chiusure di venerdi' dalle 20:00:00 nel per-trade della cella 1: 14 (cella 1: attese le chiusure forzate)
  - M1-M2 cella 1 contro il CONTROLLO cella 0 dello stesso file: M1 passa, M2 fallisce, M3 NON VERIFICABILE -- ~100-120 posizioni: INDIZIO, merito SOSPESO
  - E3 rischio: DD 0/1 4.12/3.93 a 1% contro 10,0 -> sotto, derivato a 2,00 x1,956-1,990: 7.69-7.83
  - per-trade 796731: cella 1: posizioni 147, PF in posizioni (k 2.3313 tolto) 1.197, EP 3.34 EUR/pos, DD a saldo chiuso 3.321 % (picco 2025.09.23, fondo 2026.05.22), peggior giornata -1.167 % (2026-05-22, denominatore = saldo a inizio giornata), deal/posizione 1.626 [MISURATO dal per-trade]
  - E4 nessuna promozione -- VALUTATA (classe 909(1), rumore = M1 e M2 contro la cella 0, M3 NON VERIFICABILE): la cella 1 NON batte la 0 su M1 e M2 -> IL DEFAULT (spento) VA BENE; E5 K1 = quello di R264c
- **R267e2 (XAUUSD, InpUseAdrFilter)**: E1 G0 in-file: cella 0 contro R264d (gemella 796531, stesso PC, stesso giro) -> IDENTICA al centesimo; contro il genetico: ROSSO -> il file si legge SOLO al suo interno
  - cella 0 Trades 292, Profit 776.35, PF 1.30881, Equity DD % 6.0743 | cella 1 Trades 290, Profit 1174.98, PF 1.55853, Equity DD % 4.6308 | E2 morde: Profit diversi, la manopola ha morso | **H_MORDE (Trades fuori +-2% o |dPF| >= 0,02): il rapporto ATR(H4)/ADR 0,41 e' sbagliato o gli shock sono frequenti -> LEVA (DD 4.63 <= 0,85 x 6.07 e PF >= PF ancora - 0,05)**
  - M1-M2 cella 1 contro il CONTROLLO cella 0 dello stesso file: M1 passa, M2 passa, M3 NON VERIFICABILE -- ~100-120 posizioni: INDIZIO, merito SOSPESO
  - E3 rischio: DD 0/1 6.07/4.63 a 1% contro 10,0 -> sotto, derivato a 2,00 x1,956-1,990: 9.06-9.22 [ORO a 10000: lotti 0,01-0,03, il DD% NON e' quello a 1% dichiarato; il confronto 1/0 resta valido]
  - per-trade 796722: cella 1: posizioni 185, PF in posizioni (k 1.8555 tolto) 1.560, EP 6.35 EUR/pos, DD a saldo chiuso 4.058 % (picco 2024.12.09, fondo 2025.07.07), peggior giornata -0.997 % (2024-01-17, denominatore = saldo a inizio giornata), deal/posizione 1.568 [MISURATO dal per-trade]
  - E4 nessuna promozione -- VALUTATA (classe 909(1), rumore = M1 e M2 contro la cella 0, M3 NON VERIFICABILE): la cella 1 batte la 0 su M1 e M2 (PF 1.559 contro 1.309, DD 4.63 contro 6.07) -> il default (spento) NON e' confermato: INDIZIO, merito SOSPESO; E5 K1 = quello di R264d
- **R267f2 (XAUUSD, InpFridayClose)**: E1 G0 in-file: cella 0 contro R264d (gemella 796531, stesso PC, stesso giro) -> IDENTICA al centesimo; contro il genetico: ROSSO -> il file si legge SOLO al suo interno
  - cella 0 Trades 292, Profit 776.35, PF 1.30881, Equity DD % 6.0743 | cella 1 Trades 286, Profit 605.23, PF 1.25109, Equity DD % 6.1834 | E2 morde: Profit diversi, la manopola ha morso | **COSTO (PF 1.251 < PF ancora 1.309 - 0,05)** | chiusure di venerdi' dalle 20:00:00 nel per-trade della cella 1: 17 (cella 1: attese le chiusure forzate)
  - M1-M2 cella 1 contro il CONTROLLO cella 0 dello stesso file: M1 passa, M2 fallisce, M3 NON VERIFICABILE -- ~100-120 posizioni: INDIZIO, merito SOSPESO
  - E3 rischio: DD 0/1 6.07/6.18 a 1% contro 10,0 -> sotto, derivato a 2,00 x1,956-1,990: 12.09-12.30 [ORO a 10000: lotti 0,01-0,03, il DD% NON e' quello a 1% dichiarato; il confronto 1/0 resta valido]
  - per-trade 796732: cella 1: posizioni 189, PF in posizioni (k 1.8547 tolto) 1.252, EP 3.20 EUR/pos, DD a saldo chiuso 4.869 % (picco 2024.11.07, fondo 2025.07.07), peggior giornata -3.848 % (2026-02-02, denominatore = saldo a inizio giornata), deal/posizione 1.513 [MISURATO dal per-trade]
  - E4 nessuna promozione -- VALUTATA (classe 909(1), rumore = M1 e M2 contro la cella 0, M3 NON VERIFICABILE): la cella 1 NON batte la 0 su M1 e M2 -> IL DEFAULT (spento) VA BENE; E5 K1 = quello di R264d

## 8. Riepilogo dei file, dopo la lettura (i cancelli di lettura -- D0, G2, L0 struttura, T3/S0, B3/V1/V2/V3/C2/C3/C4/U1/U2/U4/D2 -- si aggiungono a quelli del par. 0)

- FILE NULLI (escono da OGNI conteggio): nessuno
- FILE SALTATI (non lanciati, NON nulli di catena): R264c1, R264c2, R264c3, R264c4, R264d1, R264d2, R264d3, R264d4, R264a1, R264a2, R264a3, R264a4, R265b
- FILE NON NULLI, per nome: R264c, R264d, R264a, R264b, R264b1, R265a, R266a, R266b, R266c, R266d, R266e, R266f, R260d, R267b, R267d, R267c, R267g2, R267g3, R267g4, R267g1, R267e1, R267f1, R267e2, R267f2
- R267a: ESCLUSO E DICHIARATO (par. 6-A), non conta ne' fra i nulli ne' fra i saltati.

**NESSUNA PROPOSTA DI TAGLIA. Nessuna cella si promuove. Nessun preset, EA, sedia o conto e' toccato.**

**Cosa resta a mano (non e' in questo script):** la classe 166 (SHA256 del motore e dell'include dopo ogni job) e gli rc dei job il lettore NON li ricalcola (non ha i sorgenti compilati): li legge dal RIEPILOGO e li UNISCE (sezione DIVERGENZE); senza RIEPILOGO restano [NON VERIFICATI]; il D0 dei log di R266 e' letto dai LOG_TESTER (sezione 5) e resta [NON VERIFICATO] se l'agente non scrive la riga 'history ... from' in ottimizzazione; il K1 di R264 segue la testa R264 par. 5 (solo vol2/vol1): la riga aggiunge i +-12% dell'ATR di R265 e sull'oro a 10000 puo' dire NULLO dove la testa no (e la riga usa quel NULLO per fermare l'onda 2 dell'oro dopo un G0 ROSSO); lo spread in memoria del terminale (classe 394) NON e' pinnato da questa corsia; la commissione e la griglia H4 di FTMO sono [NON MISURATE]; ogni decisione su taglie, sedie, R265b dopo un NON RISOLTO, R267a (par. 6-A) e i round d'altopiano dopo un HE/PASSA e' una FIRMA di Claudio.
