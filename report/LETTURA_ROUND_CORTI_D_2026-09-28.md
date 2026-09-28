# ERRATA CORRIGE IN TESTA, PRIMA DI LEGGERE IL RESTO -- classe 903 (28/09/2026, causa corretta dal cancello strato 2)

La console della corsa (RIEPILOGO della riga, letta durante l'esecuzione sul PC di backtest) ha scritto
**"G0 di R268b ROSSO: il banco e' cambiato, R268 NON SI LEGGE"**, con l'esempio "posizione archivio 1361
(V 0.44, saldo 100000.00) contro nuova 4 (V 0.41, saldo 100000.00): banda [0.43 ; 0.46]".

**Quella riga della console e' SBAGLIATA, ed e' un bug del cancello INLINE della riga, non del round.**

- **Il saldo vero.** Dal CSV `archivio_CORTI_B_pertrade_795301.csv` (nello zip): prima della posizione
  archivio 1361 (primo deal 2024.07.10 14:55:40, ultimo 17:30:00) il saldo di R260a, dal 100000 del
  2020.01.01, e' **107.794,67 EUR col k 1,8113 x lotti** (classe 844; senza k sarebbe 107.945,46). E' lo
  stesso numero che la testa `prove/R268b_oro_long_OHLC_stessa_finestra_G0.txt` r.33-36 aveva scritto
  **PRIMA del round**: *"saldo di partenza 100000 contro 107.794,67 di R260a ... I LOTTI sono ~7% piu'
  piccoli"*. Con la formula G0-LOTTO della testa (`prove/R268a_oro_long_TICK_testa.txt` r.377-381) e B'/B =
  100000 / 107.794,67 = 0,9277: banda **[0,39 ; 0,42]**, e il valore osservato **0,41 CI STA DENTRO**.
  Con o senza k la banda e' la stessa.
- **La causa del bug (riprodotta al byte, NON e' "il deposito al posto del saldo").** Il codice inline
  accumula la storia correttamente, ma ordina i deal con `Sort-Object ... -Stable` (3 occorrenze, in `$ddChiuso` e `$lottoChk`).
  `-Stable` esiste **solo da PowerShell 7**: sul PC di backtest gira **Windows PowerShell 5.1** (gia' scritto
  in checklist par. 81), e la riga passa a `$ErrorActionPreference='Continue'` prima di quei blocchi, quindi il
  comando fallisce **in silenzio**, gli elenchi ordinati escono **vuoti** e **TUTTI E DUE i saldi** (archivio
  E nuovo) restano fermi a 100000. Il codice inline ESTRATTO dalla riga e rigirato sui file veri (in pwsh 7):
  con `-Stable` funzionante esce **fuori banda 0 su 92**; con il parametro reso inesistente sotto `Continue`
  (l'effetto della 5.1) esce **fuori banda 56 su 92, e la prima riga e' identica al carattere a quella della
  console**. [Emulazione: la 5.1 vera non e' stata girata qui.]
- **Lo stesso guasto svuota gli altri numeri a saldo chiuso della console**: "r a SALDO CHIUSO ... deal a: 0,
  b: 0 = n.d." e "DD saldo chiuso con k 0.0000 %" del per-trade 797203 (118 deal). Sono tutti numeri del
  RIEPILOGO, **nessuno** entra in questa lettura.

Il lettore gia' passato dal cancello (`backtest_pipeline/leggi_round_corti_d.py`, Python: nessun `-Stable`)
usa il saldo vero dell'archivio (tutta la storia dal 2020) e rilegge **G0 VERDE: G0-n ok, G0-STRUTTURA
119/119, G0-LOTTO fuori banda 0/92, G0-SOLDI 0**. Il round **SI LEGGE PER INTERO**: r, K1, la curva di R268c,
e R268d sui 22 anni. Dettaglio in `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md`, classi 903 e 904.

**Cosa significa per Claudio**: sul bug della console, nessuna azione tua: il round non e' da rilanciare, e
la riparazione della riga (togliere `-Stable`, ordinare con una seconda chiave d'indice) si fa prima del
prossimo uso della stessa riga. **Ma la lettura qui sotto ha una cosa che e' tua**: al par. 6, sui 22 anni il
solo long a 0,5% fa **Equity DD 10,3027%** contro il 10,0% del contratto (riferimento di un'altra
configurazione, R100) -> **D3, corsia RISCHIO per Claudio** (firma del 18/08).

Sotto: la lettura completa, coi criteri congelati della testa, con G0 rifatto correttamente e VERDE.

---

# LETTURA DEL ROUND CORTI D -- R268 (oro 770402 solo long: tick contro OHLC, K1, curva DD(taglia), 22 anni) + R269 (oro flat 13:00 long/short, DAX long -1h)

Generato da `backtest_pipeline/leggi_round_corti_d.py` sulla raccolta `backtest_pipeline/risultati_archivio/ROUND_CORTI_D_2026-09-28`.
Criteri congelati PRIMA dei numeri: `prove/R268a_oro_long_TICK_testa.txt` par. 0/6/7, `prove/R268c_*` , `prove/R268d_*` par. 2-4, `prove/R269a_oro_770402_long_close13.txt` par. 4-5, `prove/R269c_dax_long_meno1h.txt` par. 4-5. Etichette: [MISURATO] dal CSV/per-trade della raccolta; [DERIVATO] da una formula della testa; [STIMA]; [NON MISURATO]. Posizioni contate per position_id; sull'oro ogni saldo toglie k x volume (classe 844). **R4 di tutte le teste: NESSUNA cella si promuove, NESSUNA taglia si propone** -- ogni riga di taglia qui sotto e' un riferimento, non una proposta.

- NULLI della riga (RIEPILOGO) uniti a quelli ricalcolati: nessuno
## 0. Cancelli di nullita' (rifatti qui, indipendenti dalla pre-lettura della riga; tabella scritta a lettura FINITA: comprende E0, G1c, S-FLAT, S1)

| file | lanciato | esito | motivi |
|---|---|---|---|
| R268b | si | NON NULLO | E0 CSV_ohlc, C0, L0, G1 ok |
| R268a | si | NON NULLO | E0 CSV, C0, L0, G1 ok |
| R268c | si | NON NULLO | E0 CSV, C0, L0, G1 ok |
| R268d | si | NON NULLO | E0 CSV_ohlc, C0, L0, G1 ok |
| R269a | si | NON NULLO | E0 CSV_ohlc, C0, L0, G1 ok |
| R269b | si | NON NULLO | E0 CSV_ohlc, C0, L0, G1 ok |
| R269c | si | NON NULLO | E0 CSV, C0, L0, G1 ok |

fonte: `ROUND_<t>/ABTG_MaxMinNotte_<simbolo>_<gamba><_ohlc>_<t>.csv` e `PERTRADE/abtg_trades_ABTG_MaxMinNotte_<simbolo>_<magic>.csv`
- k (classe 844) R268b: 797202 1.8147 / 797252 1.8147 EUR/lotto [MISURATO: (somma net - Profit)/lotti]
- k (classe 844) R268a: 797201 1.8140 / 797251 1.8140 EUR/lotto [MISURATO: (somma net - Profit)/lotti]
- k (classe 844) R268d: 797204 1.6255 / 797254 1.6255 EUR/lotto [MISURATO: (somma net - Profit)/lotti]
- k (classe 844) R269a: 797211 1.8107 / 797261 1.8107 EUR/lotto [MISURATO: (somma net - Profit)/lotti]
- k (classe 844) R269b: 797212 1.8032 / 797262 1.8032 EUR/lotto [MISURATO: (somma net - Profit)/lotti]

- E0 ok: tick (R268a) e OHLC (R268b) differiscono (Trades 118, Profit 5165.82, PF 1.45273, Equity DD % 2.3434 contro Trades 119, Profit 5809.28, PF 1.51809, Equity DD % 2.3295)

## 1. R268 -- G0 DEL BANCO (R268b contro il per-trade 795301 di R260a ristretto alle chiusure >= 2024.07.06)

- archivio 795301: 375 righe, 279 posizioni; tratto >= 2024.07.06: 119 righe, 92 posizioni (attesi 375/279 e 119/92) [MISURATO] -- fonte: `archivio_CORTI_B_pertrade_795301.csv`
- R268b gemella 797202: Trades 119, Profit 5809.28, PF 1.51809, Equity DD % 2.3295 [MISURATO] -- fonte: `ROUND_R268b/ABTG_MaxMinNotte_XAUUSD_OOS_ohlc_R268b.csv`
- G0-n Trades = 119: ok
- G0-STRUTTURA (chiave close_time+price a molteplicita', classe 849): righe 119 contro 119, abbinate 119, nuove senza archivio 0, archivio senza nuova 0, deal_type diversi 0, raggruppamenti discordi 0 -> ok
- G0-LOTTO (V' in [floor(V B'/B) - 0,01 ; floor((V+0,01) B'/B) + 0,01], k archivio 1,8113 / nuovo 1.8147): posizioni 92 (attese 92), fuori banda 0 -> ok
- G0-SOLDI (|net'/vol' - net/vol| <= 0,01/vol' + 0,01/vol): fuori tolleranza 0 -> ok
- **G0 VERDE**
- R268b contro le bande [STIMA Monte Carlo della testa par. 6.3, NON cancello]: Profit 5809.28 (banda 5.480 -> 6.145), PF in posizioni 1.519 (1,481 -> 1,561), DD saldo chiuso con k 1.9531 % (1,877 -> 2,093; picco 2025.03.18 fondo 2025.07.04), Equity DD % CSV 2.3295 (attesa >= saldo chiuso)
- pre-lettura della riga (per confronto, NON decide qui): ROSSO

## 2. R268 -- P0-TICK (testa par. 0)

- caso (ii): ticks data begins from 2024.07.10 -- LOG_TESTER/*.log (2024.07.10)
- prima del 2024.07.10 MT5 GENERA i tick dalle M1: ogni lettura di R268a/b/c si fa sul PER-TRADE ristretto alle chiusure >= 2024.07.10; il DD del CSV di R268a/c e' MISTO e NON decide: decide il DD a saldo chiuso con k sul tratto ristretto.

## 3. R268 -- LO SCARTO r = DD_tick / DD_OHLC (testa par. 6.2)

| misura | R268a tick (797201) | R268b OHLC (797202) | r | fonte |
|---|---:|---:|---:|---|
| Equity DD % del CSV [MISURATO] | 2.3434 | 2.3295 | 1.006 | `ROUND_R268a/ABTG_MaxMinNotte_XAUUSD_OOS_R268a.csv`, `ROUND_R268b/ABTG_MaxMinNotte_XAUUSD_OOS_ohlc_R268b.csv` colonna Equity DD % |
| DD a saldo chiuso con k (per-trade ristretti alle chiusure >= 2024.07.10) [MISURATO] | 1.9668 (picco 2025.03.18, fondo 2025.07.04) | 1.9531 (picco 2025.03.18, fondo 2025.07.04) | 1.007 | `PERTRADE/*_797201.csv`, `*_797202.csv`, k 1.8140 / 1.8147 |

- scarto in punti (Equity DD): +0.0139 (si scrive, NON decide)
- DECIDE il saldo chiuso ristretto (caso ii): **r = 1.007 -> H-AFF (0,90 <= r < 1,10): OHLC AFFIDABILE per il rischio (dentro il prior di casa 0,864-1,094)**
- R268a: Trades 118, Profit 5165.82, PF 1.45273, Equity DD % 2.3434 [MISURATO], posizioni 93 (banda attesa 84-100; SOTTO 150: MERITO SOSPESO per costruzione), PF in posizioni con k 1.455 (si riporta, NON decide) [sul per-trade ristretto >= 2024.07.10]
- previsione della testa: H-AFF con r 1,00-1,10.

## 4. R268 -- K1: LO STOP DAL LOTTO (classe 846, testa par. 6.4) sul per-trade di R268a

- ancore q (due deal d'uscita di pari volume a prezzi diversi nella stessa posizione, q = (net1 - net2)/((p1 - p2) x vol x 100)): 10, banda [q_basso ; q_alto] = [0.4242 ; 0.9688], mediana 0.8542 [MISURATO] (tratto di R260a: 12 ancore, 0,8393 -> 0,9663); ancore ANOMALE fuori da [0,5 ; 1,5] (net piccoli arrotondati al centesimo: allargano la banda, si scrivono, la regola della testa e' [min ; max]): 2025.02.18 pos 190 q 0.4242
- stop in [ R/((V+0,01) x 100 x q_alto) ; R/(V x 100 x q_basso) ], R = saldo prima della posizione x 0,005 (saldo con k), V = somma dei volumi d'uscita [DERIVATO dal per-trade]
- n 93 posizioni; mediana degli stop MINIMI 22.93 $, dei MASSIMI 54.75 $; quota sotto frontiera 18,00 $ [pavimento ; tetto] = [0 ; 36] su 93 = [0.00% ; 38.71%]
- **K1 VERDE (mediana degli stop MINIMI 22.93 $ >= 18.00)** (attesa della testa: VERDE, mediana minimi 23,32 / massimi 27,98, quota [21% ; 40%]). K1 VERDE NON cancella la quota sotto frontiera: si scrive accanto.
- fonte: `PERTRADE/abtg_trades_ABTG_MaxMinNotte_XAUUSD_797201.csv` (volumi, prezzi, net), deposito 100000, k 1.8140
- **ANCORE MAL CONDIZIONATE (classe 877)**: 1 con amplificazione A > 100 (prezzi d'uscita quasi uguali: la deriva del cambio fra le due uscite domina): 2025.02.18 pos 190 q 0.4242 |p1-p2| 0.03 $ A 542. K1 SENZA di loro [DIAGNOSTICA, soglia NON congelata, NON decide]: VERDE (mediana degli stop MINIMI 22.93 $ >= 18.00) (stesso verdetto del congelato)

## 5. R268c -- LA CURVA DD(TAGLIA) A TICK (testa par. 6.5, R268c)

- G1c: ok (cella 0,5 == CSV di R268a al centesimo); Trades sulle 4 celle: 118/118/118/118 -> IDENTICI (R193b B5) ok; DD distinti 4 su 4 -> il pin morde; monotono crescente: si

| InpRiskPercent | Equity DD % CSV [MISURATO] | pavimento 1-(1-d)^(f/0,5) [DERIVATO] | tetto (f/0,5) x d [INDICATIVO] | posizione |
|---:|---:|---:|---:|---|
| 0.5 | 2.3434 | 2.34 | 2.34 | misurato (d) |
| 1.0 | 4.7464 | 4.63 | 4.69 | sopra il tetto di 0.06 punti (ammesso, si scrive) |
| 1.5 | 7.1353 | 6.87 | 7.03 | sopra il tetto di 0.11 punti (ammesso, si scrive) |
| 2.0 | 9.4253 | 9.05 | 9.37 | sopra il tetto di 0.05 punti (ammesso, si scrive) |

fonte: `ROUND_R268c/ABTG_MaxMinNotte_XAUUSD_OOS_R268c.csv` colonne InpRiskPercent, Equity DD %, Trades
- P0-TICK caso (ii): i DD del CSV sono MISTI, la curva NON decide nulla, si scrive.
- per-trade 797203 IDENTIFICATO (classe 850): cella InpRiskPercent=2.0, regola della testa G1c (righe = Trades e k entro +-0,01 dal k di R268a 1.8140), k 1.8148; 118 deal, 93 posizioni, DD a saldo chiuso con k 7.9974 % (picco 2025.03.18, fondo 2025.07.04) [ristretto >= 2024.07.10] [MISURATO] -- contro la cella 0,5 a saldo chiuso: [DERIVATO] pavimento 7.64 / tetto 7.87
- 2 anni, UN SOLO REGIME (toro dell'oro 2024-2026), merito sospeso: nessun valore dell'asse e' consigliato (R268c, classe 860).

## 6. R268d -- IL SOLO LONG SUI 22 ANNI, OHLC (testa R268d par. 2-4)

- D0 STORICO: prima chiusura 2004.11.17 -> **NON SODDISFATTO**: lo storico M1 del PC non arriva al 2004, la finestra vera parte da 2004.11.17 e si dichiara accanto a ogni numero [MISURATO]
- giornale (dal RIEPILOGO): XAUUSD,M1: history begins from 2004.06.11
- G0d tratto 2020-2026 (per-trade 797204 ristretto alle chiusure >= 2020.01.01: 375 righe) contro 795301 intero (375): abbinate 375, nuove senza archivio 0, archivio senza nuova 0, deal_type diversi 0, raggruppamenti discordi 0 -> VERDE-STRUTTURA; G0-SOLDI fuori tolleranza 0 -> ok ==> **G0d VERDE** (R268d e' la stessa sedia sui 22 anni)
- gemella 797204 gamba 2004.06.20 -> 2026.06.30: Trades 950, Profit 10274.19, PF 1.09604, Equity DD % 10.3027 [MISURATO], posizioni 725 (tetto atteso ~1.234, centro [STIMA] ~946), PF in posizioni con k 1.096 (si riporta: il VECCHIO giudica il RISCHIO, non il merito) -- fonte: `ROUND_R268d/ABTG_MaxMinNotte_XAUUSD_OOS_ohlc_R268d.csv`, `PERTRADE/*_797204.csv`
- RISCHIO a 0,5%: Equity DD % CSV **10.3027** contro 4,5172 (R260a) e 10,0 (contratto R100, altra configurazione) -> **D3**; DD a saldo chiuso con k 9.8291 % (picco 2006.04.25, fondo 2015.08.07) -> D2 = DIPENDE DALLA MISURA: decide l'EQUITY (contratto R100 criterio A)
- D3: il solo long a 0,5% sta FUORI dal contratto gia' alla taglia di oggi -> corsia RISCHIO per Claudio (firma del 18/08); nessuna taglia sopra 0,5 da qui
- previsione della testa: D2, centro ~8,5%.

### 6.1 Anno per anno (posizioni per data di chiusura, netto meno k x volume) e K1 per anno (q dalle ancore dell'anno; <2 ancore = banda dell'intero file, segnato ^)

| anno | posizioni | netto EUR | PF | ancore q | banda q | K1 stop mediano min/max $ | quota <18 $ [max<18 ; min<18] | K1 | ancore mal condizionate (classe 877) / K1 senza [DIAGNOSTICA] |
|---:|---:|---:|---:|---:|---|---|---|---|---|
| 2004 | 1 | +143.61 | inf | 0^ | [0.4394 ; 1.6857] | 3.09 / 11.98 | [1 ; 1] | NON LEGGIBILE | **3** (q 0.9152 dp 0.11 $, q 0.4394 dp 0.03 $, q 1.6857 dp 0.05 $) -> NON LEGGIBILE |
| 2005 | 5 | -1300.31 | 0.000 | 0^ | [0.4394 ; 1.6857] | 3.24 / 12.56 | [5 ; 5] | NON LEGGIBILE | **3** (q 0.9152 dp 0.11 $, q 0.4394 dp 0.03 $, q 1.6857 dp 0.05 $) -> NON LEGGIBILE |
| 2006 | 19 | -426.54 | 0.849 | 3 | [0.7868 ; 0.8290] | 9.03 / 9.66 | [17 ; 17] | NON LEGGIBILE | nessuna |
| 2007 | 9 | +723.92 | 2.340 | 1^ | [0.4394 ; 1.6857] | 3.32 / 12.88 | [8 ; 9] | NON LEGGIBILE | **3** (q 0.9152 dp 0.11 $, q 0.4394 dp 0.03 $, q 1.6857 dp 0.05 $) -> NON LEGGIBILE |
| 2008 | 45 | -3869.34 | 0.544 | 1^ | [0.4394 ; 1.6857] | 4.10 / 15.96 | [32 ; 45] | ROSSO | **3** (q 0.9152 dp 0.11 $, q 0.4394 dp 0.03 $, q 1.6857 dp 0.05 $) -> ROSSO |
| 2009 | 38 | +3873.94 | 2.009 | 3 | [0.6652 ; 0.7618] | 10.07 / 11.72 | [34 ; 36] | ROSSO | nessuna |
| 2010 | 36 | -700.72 | 0.896 | 3 | [0.7418 ; 0.7829] | 9.27 / 9.93 | [35 ; 35] | ROSSO | nessuna |
| 2011 | 52 | -255.92 | 0.973 | 8 | [0.6987 ; 0.7410] | 12.21 / 13.19 | [34 ; 35] | ROSSO | nessuna |
| 2012 | 43 | +814.82 | 1.121 | 8 | [0.7416 ; 0.8134] | 10.44 / 11.66 | [39 ; 39] | ROSSO | nessuna |
| 2013 | 31 | -3826.60 | 0.414 | 1^ | [0.4394 ; 1.6857] | 5.53 / 21.63 | [10 ; 30] | NON DECISO | **3** (q 0.9152 dp 0.11 $, q 0.4394 dp 0.03 $, q 1.6857 dp 0.05 $) -> ROSSO |
| 2014 | 39 | -2567.51 | 0.602 | 3 | [0.7270 ; 0.9152] | 8.28 / 10.60 | [36 ; 38] | ROSSO | **1** (q 0.9152 dp 0.11 $) -> ROSSO |
| 2015 | 30 | -1767.57 | 0.667 | 4 | [0.8395 ; 0.8989] | 9.43 / 10.28 | [30 ; 30] | ROSSO | nessuna |
| 2016 | 33 | +2275.60 | 2.078 | 8 | [0.8754 ; 0.9471] | 11.15 / 12.35 | [30 ; 31] | ROSSO | nessuna |
| 2017 | 15 | +1294.00 | 2.437 | 0^ | [0.4394 ; 1.6857] | 4.38 / 17.08 | [9 ; 15] | NON LEGGIBILE | **3** (q 0.9152 dp 0.11 $, q 0.4394 dp 0.03 $, q 1.6857 dp 0.05 $) -> NON LEGGIBILE |
| 2018 | 18 | +3071.80 | 4.890 | 3 | [0.7992 ; 0.8744] | 8.74 / 9.72 | [18 ; 18] | NON LEGGIBILE | nessuna |
| 2019 | 32 | -771.53 | 0.819 | 4 | [0.8833 ; 0.9017] | 9.72 / 10.10 | [31 ; 31] | ROSSO | nessuna |
| 2020 | 42 | +2831.48 | 1.501 | 6 | [0.8102 ; 0.9191] | 13.28 / 15.45 | [30 ; 34] | ROSSO | nessuna |
| 2021 | 35 | -536.54 | 0.924 | 5 | [0.4394 ; 0.8573] | 12.57 / 25.06 | [1 ; 33] | NON DECISO | **1** (q 0.4394 dp 0.03 $) -> ROSSO |
| 2022 | 40 | +1537.31 | 1.285 | 6 | [0.8786 ; 0.9961] | 12.08 / 14.03 | [31 ; 38] | ROSSO | nessuna |
| 2023 | 42 | -1176.87 | 0.849 | 4 | [0.9001 ; 0.9342] | 11.12 / 11.79 | [36 ; 40] | ROSSO | nessuna |
| 2024 | 56 | +5812.23 | 1.788 | 12 | [0.8941 ; 0.9408] | 13.86 / 14.98 | [42 ; 44] | ROSSO | nessuna |
| 2025 | 47 | +2873.06 | 1.492 | 5 | [0.8497 ; 1.6857] | 14.27 / 29.66 | [7 ; 33] | NON DECISO | **1** (q 1.6857 dp 0.05 $) -> VERDE |
| 2026 | 17 | +2221.86 | 2.586 | 2 | [0.8393 ; 0.8498] | 45.83 / 49.97 | [0 ; 0] | NON LEGGIBILE | nessuna |

anni negativi: 2005, 2006, 2008, 2010, 2011, 2013, 2014, 2015, 2019, 2021, 2023. Sull'oro vecchio (400-1000 $) lo spread in memoria (classe 394, OHLC) e' quello di oggi: gli anni con stop mediano sotto 40 x spread pagano un costo GONFIATO; se il DD massimo cade li' una parte del DD e' costo del modello, si scrive e NON lo si toglie. [MISURATO sul per-trade, K1 DERIVATO dalla formula 846]

### 6.2 La peggior finestra mobile di 12 mesi (testa R268d par. 3 (b)) [MISURATO a saldo chiuso con k]

- (b1) DD massimo INTERNO a una finestra di 365 giorni (picco e fondo dentro): **5.5134 %**, picco 2008.02.08, fondo 2009.01.22
- (b2) peggior netto su 365 giorni in % del saldo d'inizio finestra: **-5.6067 %**, dal 2008.01.25 al 2009.01.22
- contro il muro statico 10% x (0,5/f) come RIFERIMENTO (non cancello): a 0,5% 10,00 | 1,0% 5,00 | 1,5% 3,33 | 2,0% 2,50 -> (b1) 0.5% sotto | 1.0% sopra | 1.5% sopra | 2.0% sopra

### 6.3 DD alle taglie 0,5 / 1,0 / 1,5 / 2,0 [DERIVATO con le DUE formule] contro muro 10% e S3 8% -- RIFERIMENTI, NESSUNA PROPOSTA

d = Equity DD % CSV dei 22 anni 10.3027. Moltiplicativa 1-(1-d)^f (teorema, pavimento), lineare f x d (indicativo, tetto), f = taglia/0,5. OHLC M1: ogni DD e' un LIMITE INFERIORE. 8% = S3 di R193b, congelata SOLO per la taglia 2,00 sulla sua sotto-finestra: qui riferimento.

| taglia | moltiplicativa | lineare | contro muro 10% | contro 8% (S3) |
|---:|---:|---:|---|---|
| 0.5% | 10.30% | 10.30% | **sopra** | - (S3 congelata SOLO a 2,00: classe 860 b) |
| 1.0% | 19.54% | 20.61% | **sopra** | - (S3 congelata SOLO a 2,00: classe 860 b) |
| 1.5% | 27.83% | 30.91% | **sopra** | - (S3 congelata SOLO a 2,00: classe 860 b) |
| 2.0% | 35.27% | 41.21% | **sopra** | **sopra** |

Seconda misura (saldo chiuso con k, minorante): d 9.8291 -> 0.5% 9.83-9.83 | 1.0% 18.69-19.66 | 1.5% 26.68-29.49 | 2.0% 33.89-39.32
Il contratto (22 anni, R100, straddle geometria R17) e' un'altra configurazione; la taglia UNIFORME del preset FTMO e ogni scelta di taglia sono una firma di Claudio (R4).

## 7. R269 -- L'ORO ESCE PRIMA DI NEW YORK? (flat 13:00 BCM; testa R269a par. 4-5)

### R269a (LONG, gemella 797211, base 795301)

- S-FLAT (nessun deal alle 17:30, nessuno dopo le 13:59:59): 0 / 0 -> ok
- G0-POS posizioni 279 contro 279 -> ok | G0-PRE deal chiusi prima delle 13:00 contro i 64 di 795301 (chiave close_time+price, deal_type, net/vol entro 0,01/vol+0,01/vol): nuovi 64, abbinati 64, senza archivio 0, archivio senza nuovo 0, deal_type diversi 0, soldi fuori 0 -> ok ==> **G0 VERDE**
- N0 Trades 306 contro 306 -> ok
- Trades 306, Profit 6766.05, PF 1.30113, Equity DD % 3.9086 [MISURATO] -- fonte: `ROUND_R269a/ABTG_MaxMinNotte_XAUUSD_OOS_ohlc_R269a.csv`; k 1.8107
- MERITO (posizioni 279 >= 150: LEGGIBILE): PF in posizioni con k **1.302** contro base 1.3357 -> **P2 (1.25 <= PF_13 < 1.45): rischio SIMMETRICO, taglia vinti e persi (NON distinguibile dalla base 1.3357 +-0,1: bootstrap sd ~0,2)**; meta' al 2023.04.01: prima 135 pos PF 0.811, seconda 144 pos PF 2.111
- RISCHIO: Equity DD % **3.9086** contro base 4.5172 -> **Q2 (3.39 < DD_13 <= 4.5172): lo taglia meno di un quarto**; DD a saldo chiuso con k 3.7052 % (picco 2020.12.17, fondo 2023.04.11)
- STOP PIENI RIMASTI (1 deal in perdita prima delle 13:00, autopsia --close 13:00) [DERIVATO dalla forma dei deal]: **15** (attesi 15 ESATTI dalla testa), netto -7456.23 EUR; TIMESTOP alle 13:00: 242 posizioni, netto +10439.39 EUR, PF 1.700
- previsione della testa: P2 e Q1.

**Per MOTIVO d'uscita [DERIVATO]**

| chiave | n | vinti | persi | PF | net EUR | EUR/lotto |
|---|---:|---:|---:|---:|---:|---:|
| STOP_PIENO | 15 | 0 | 15 | 0.00 | -7456 | -1126.3 |
| TP1_BE | 1 | 1 | 0 | inf | +270 | +612.9 |
| TP1_RUN | 5 | 5 | 0 | inf | +1829 | +858.7 |
| TIMESTOP | 242 | 127 | 115 | 1.70 | +10439 | +120.4 |
| ALTRO | 16 | 16 | 0 | inf | +1684 | +287.9 |
| TOTALE | 279 | 149 | 130 | 1.30 | +6766 | +66.5 |

**Per ANNO (posizioni per data di chiusura, net con k)**

| chiave | n | vinti | persi | PF | net EUR | EUR/lotto |
|---|---:|---:|---:|---:|---:|---:|
| 2020 | 42 | 23 | 19 | 1.09 | +394 | +23.2 |
| 2021 | 35 | 17 | 18 | 0.60 | -1515 | -96.6 |
| 2022 | 40 | 20 | 20 | 0.96 | -169 | -10.3 |
| 2023 | 42 | 22 | 20 | 0.90 | -286 | -15.2 |
| 2024 | 56 | 30 | 26 | 1.69 | +2985 | +140.6 |
| 2025 | 47 | 28 | 19 | 2.41 | +3870 | +357.3 |
| 2026 | 17 | 9 | 8 | 4.02 | +1488 | +791.4 |
| TOTALE | 279 | 149 | 130 | 1.30 | +6766 | +66.5 |

**Per MESE (anno-mese)**

| chiave | n | vinti | persi | PF | net EUR | EUR/lotto |
|---|---:|---:|---:|---:|---:|---:|
| 2020-01 | 3 | 1 | 2 | 0.30 | -183 | -138.4 |
| 2020-02 | 3 | 0 | 3 | 0.00 | -640 | -477.9 |
| 2020-03 | 1 | 1 | 0 | inf | +136 | +971.2 |
| 2020-04 | 6 | 3 | 3 | 4.34 | +1086 | +468.1 |
| 2020-05 | 3 | 1 | 2 | 0.26 | -251 | -184.8 |
| 2020-06 | 3 | 2 | 1 | 0.57 | -158 | -124.8 |
| 2020-07 | 5 | 3 | 2 | 0.44 | -430 | -175.6 |
| 2020-08 | 4 | 4 | 0 | inf | +564 | +512.7 |
| 2020-09 | 3 | 1 | 2 | 0.02 | -967 | -819.3 |
| 2020-10 | 4 | 3 | 1 | 7.35 | +244 | +152.8 |
| 2020-11 | 3 | 1 | 2 | 4.12 | +413 | +299.5 |
| 2020-12 | 4 | 3 | 1 | 2.19 | +580 | +386.5 |
| 2021-01 | 3 | 1 | 2 | 0.07 | -754 | -810.8 |
| 2021-02 | 3 | 2 | 1 | 1.44 | +53 | +42.4 |
| 2021-03 | 3 | 1 | 2 | 6.57 | +323 | +290.6 |
| 2021-04 | 3 | 2 | 1 | 0.52 | -77 | -54.9 |
| 2021-05 | 4 | 2 | 2 | 0.53 | -272 | -147.6 |
| 2021-06 | 2 | 2 | 0 | inf | +220 | +252.8 |
| 2021-07 | 4 | 0 | 4 | 0.00 | -906 | -479.3 |
| 2021-08 | 3 | 0 | 3 | 0.00 | -391 | -249.2 |
| 2021-10 | 3 | 2 | 1 | 0.79 | -46 | -30.7 |
| 2021-11 | 4 | 3 | 1 | 0.97 | -17 | -10.1 |
| 2021-12 | 3 | 2 | 1 | 7.78 | +352 | +210.6 |
| 2022-01 | 2 | 0 | 2 | 0.00 | -215 | -216.9 |
| 2022-02 | 2 | 1 | 1 | 0.98 | -5 | -5.0 |
| 2022-03 | 3 | 1 | 2 | 1.09 | +22 | +17.6 |
| 2022-04 | 2 | 1 | 1 | 62.56 | +291 | +427.7 |
| 2022-05 | 3 | 1 | 2 | 0.66 | -144 | -132.4 |
| 2022-06 | 6 | 3 | 3 | 0.68 | -219 | -89.1 |
| 2022-07 | 3 | 0 | 3 | 0.00 | -437 | -446.2 |
| 2022-08 | 4 | 3 | 1 | 1.70 | +293 | +167.2 |
| 2022-09 | 6 | 5 | 1 | 4.86 | +660 | +289.4 |
| 2022-10 | 2 | 2 | 0 | inf | +441 | +573.0 |
| 2022-11 | 4 | 2 | 2 | 0.07 | -727 | -484.9 |
| 2022-12 | 3 | 1 | 2 | 0.15 | -127 | -81.7 |
| 2023-01 | 6 | 2 | 4 | 0.25 | -732 | -366.1 |
| 2023-02 | 7 | 1 | 6 | 0.04 | -765 | -277.2 |
| 2023-03 | 5 | 3 | 2 | 1.59 | +157 | +86.2 |
| 2023-04 | 4 | 1 | 3 | 1.20 | +46 | +26.5 |
| 2023-05 | 3 | 2 | 1 | 2.08 | +85 | +73.7 |
| 2023-06 | 1 | 1 | 0 | inf | +18 | +38.9 |
| 2023-07 | 6 | 5 | 1 | 52.29 | +889 | +253.1 |
| 2023-08 | 2 | 2 | 0 | inf | +188 | +167.9 |
| 2023-09 | 2 | 1 | 1 | 1.59 | +9 | +9.4 |
| 2023-10 | 2 | 2 | 0 | inf | +273 | +235.1 |
| 2023-11 | 2 | 1 | 1 | 0.94 | -3 | -2.8 |
| 2023-12 | 2 | 1 | 1 | 0.08 | -451 | -433.8 |
| 2024-01 | 9 | 3 | 6 | 0.68 | -193 | -47.1 |
| 2024-02 | 3 | 2 | 1 | 1.50 | +91 | +53.3 |
| 2024-03 | 4 | 3 | 1 | 124.65 | +855 | +474.8 |
| 2024-04 | 5 | 3 | 2 | 0.72 | -150 | -106.6 |
| 2024-05 | 2 | 2 | 0 | inf | +706 | +916.3 |
| 2024-06 | 3 | 2 | 1 | 20.78 | +1365 | +974.8 |
| 2024-07 | 6 | 4 | 2 | 3.36 | +619 | +276.4 |
| 2024-08 | 5 | 4 | 1 | 5.20 | +706 | +392.1 |
| 2024-09 | 2 | 1 | 1 | 5.14 | +468 | +550.7 |
| 2024-10 | 4 | 1 | 3 | 0.34 | -347 | -266.8 |
| 2024-11 | 7 | 4 | 3 | 1.19 | +118 | +59.1 |
| 2024-12 | 6 | 1 | 5 | 0.02 | -1251 | -669.0 |
| 2025-01 | 6 | 4 | 2 | 4.94 | +970 | +388.1 |
| 2025-02 | 2 | 1 | 1 | 0.13 | -146 | -260.7 |
| 2025-03 | 6 | 3 | 3 | 2.97 | +700 | +448.9 |
| 2025-04 | 3 | 2 | 1 | 1.40 | +84 | +255.7 |
| 2025-05 | 3 | 2 | 1 | 0.89 | -9 | -22.0 |
| 2025-06 | 3 | 1 | 2 | 0.12 | -371 | -562.0 |
| 2025-07 | 4 | 3 | 1 | 2.08 | +177 | +158.3 |
| 2025-08 | 3 | 1 | 2 | 0.52 | -148 | -189.1 |
| 2025-09 | 4 | 3 | 1 | 7.34 | +1107 | +1064.8 |
| 2025-10 | 7 | 5 | 2 | 1.48 | +216 | +263.7 |
| 2025-11 | 5 | 2 | 3 | 4.20 | +463 | +601.8 |
| 2025-12 | 1 | 1 | 0 | inf | +824 | +3170.8 |
| 2026-01 | 4 | 0 | 4 | 0.00 | -77 | -242.2 |
| 2026-02 | 3 | 3 | 0 | inf | +598 | +1759.2 |
| 2026-03 | 2 | 0 | 2 | 0.00 | -290 | -2416.9 |
| 2026-04 | 3 | 2 | 1 | 12.48 | +628 | +1794.2 |
| 2026-05 | 3 | 3 | 0 | inf | +640 | +1361.1 |
| 2026-06 | 2 | 1 | 1 | 0.85 | -10 | -37.5 |
| TOTALE | 279 | 149 | 130 | 1.30 | +6766 | +66.5 |

fonte: `PERTRADE/abtg_trades_ABTG_MaxMinNotte_XAUUSD_797211.csv` via autopsia_pertrade.aggrega(k=1.8107, close 13:00)

### R269b (SHORT, gemella 797212, base 795302)

- S-FLAT (nessun deal alle 17:30, nessuno dopo le 13:59:59): 0 / 0 -> ok
- G0-POS posizioni 232 contro 232 -> ok | G0-PRE deal chiusi prima delle 13:00 contro i 50 di 795302 (chiave close_time+price, deal_type, net/vol entro 0,01/vol+0,01/vol): nuovi 50, abbinati 50, senza archivio 0, archivio senza nuovo 0, deal_type diversi 0, soldi fuori 0 -> ok ==> **G0 VERDE**
- N0 Trades 257 contro 257 -> ok
- Trades 257, Profit 3001.24, PF 1.14289, Equity DD % 2.8022 [MISURATO] -- fonte: `ROUND_R269b/ABTG_MaxMinNotte_XAUUSD_OOS_ohlc_R269b.csv`; k 1.8032
- MERITO (posizioni 232 >= 150: LEGGIBILE): PF in posizioni con k **1.143** contro base 1.2545 -> **P3 (PF_13 < 1.15): il motore e' il timestop del pomeriggio, il flat alle 13 lo spegne (il contro-esempio)**; meta' al 2023.04.01: prima 123 pos PF 1.172, seconda 109 pos PF 1.112
- RISCHIO: Equity DD % **2.8022** contro base 4.0755 -> **Q1 (DD_13 <= 3.06 = 0,75 x base): il flat taglia il rischio di almeno un quarto**; DD a saldo chiuso con k 2.5661 % (picco 2024.05.29, fondo 2025.02.28)
- STOP PIENI RIMASTI (1 deal in perdita prima delle 13:00, autopsia --close 13:00) [DERIVATO dalla forma dei deal]: **9** (attesi 9 ESATTI dalla testa), netto -4491.53 EUR; TIMESTOP alle 13:00: 207 posizioni, netto +3264.50 EUR, PF 1.199
- previsione della testa: P2 e Q1.

**Per MOTIVO d'uscita [DERIVATO]**

| chiave | n | vinti | persi | PF | net EUR | EUR/lotto |
|---|---:|---:|---:|---:|---:|---:|
| STOP_PIENO | 9 | 0 | 9 | 0.00 | -4492 | -1283.3 |
| TP1_BE | 1 | 1 | 0 | inf | +253 | +505.1 |
| TP1_RUN | 4 | 4 | 0 | inf | +2012 | +1064.5 |
| TIMESTOP | 207 | 95 | 112 | 1.20 | +3264 | +42.5 |
| ALTRO | 11 | 11 | 0 | inf | +1964 | +498.4 |
| TOTALE | 232 | 111 | 121 | 1.14 | +3001 | +34.6 |

**Per ANNO (posizioni per data di chiusura, net con k)**

| chiave | n | vinti | persi | PF | net EUR | EUR/lotto |
|---|---:|---:|---:|---:|---:|---:|
| 2020 | 28 | 7 | 21 | 0.47 | -1908 | -198.7 |
| 2021 | 42 | 18 | 24 | 1.30 | +1071 | +52.3 |
| 2022 | 41 | 23 | 18 | 1.77 | +2299 | +130.6 |
| 2023 | 40 | 17 | 23 | 1.03 | +90 | +5.0 |
| 2024 | 31 | 19 | 12 | 0.99 | -36 | -3.2 |
| 2025 | 38 | 18 | 20 | 0.98 | -66 | -8.1 |
| 2026 | 12 | 9 | 3 | 2.83 | +1550 | +1033.5 |
| TOTALE | 232 | 111 | 121 | 1.14 | +3001 | +34.6 |

**Per MESE (anno-mese)**

| chiave | n | vinti | persi | PF | net EUR | EUR/lotto |
|---|---:|---:|---:|---:|---:|---:|
| 2020-01 | 1 | 0 | 1 | 0.00 | -132 | -300.2 |
| 2020-02 | 2 | 1 | 1 | 3.84 | +222 | +382.6 |
| 2020-03 | 5 | 0 | 5 | 0.00 | -693 | -602.6 |
| 2020-04 | 5 | 1 | 4 | 0.07 | -750 | -531.6 |
| 2020-05 | 2 | 1 | 1 | 0.59 | -104 | -127.9 |
| 2020-06 | 1 | 0 | 1 | 0.00 | -227 | -568.0 |
| 2020-07 | 2 | 1 | 1 | 16.74 | +135 | +149.5 |
| 2020-08 | 3 | 1 | 2 | 2.00 | +254 | +294.8 |
| 2020-09 | 2 | 1 | 1 | 0.62 | -22 | -33.6 |
| 2020-10 | 1 | 0 | 1 | 0.00 | -350 | -1093.2 |
| 2020-11 | 2 | 0 | 2 | 0.00 | -602 | -608.0 |
| 2020-12 | 2 | 1 | 1 | 4.19 | +361 | +331.3 |
| 2021-01 | 2 | 1 | 1 | 4.57 | +623 | +768.9 |
| 2021-02 | 5 | 2 | 3 | 0.63 | -185 | -88.2 |
| 2021-03 | 5 | 4 | 1 | 3.83 | +740 | +357.7 |
| 2021-04 | 5 | 3 | 2 | 1.58 | +164 | +64.7 |
| 2021-05 | 2 | 1 | 1 | 3.55 | +99 | +82.5 |
| 2021-06 | 4 | 2 | 2 | 1.01 | +3 | +1.7 |
| 2021-07 | 4 | 2 | 2 | 3.61 | +379 | +203.9 |
| 2021-08 | 1 | 0 | 1 | 0.00 | -195 | -325.5 |
| 2021-09 | 2 | 1 | 1 | 0.95 | -23 | -21.1 |
| 2021-10 | 4 | 2 | 2 | 20.96 | +739 | +360.5 |
| 2021-11 | 4 | 0 | 4 | 0.00 | -636 | -310.2 |
| 2021-12 | 4 | 0 | 4 | 0.00 | -637 | -284.3 |
| 2022-01 | 3 | 0 | 3 | 0.00 | -250 | -155.1 |
| 2022-02 | 4 | 2 | 2 | 1.23 | +114 | +48.0 |
| 2022-03 | 4 | 1 | 3 | 1.03 | +12 | +7.7 |
| 2022-04 | 3 | 1 | 2 | 0.08 | -690 | -522.5 |
| 2022-05 | 5 | 4 | 1 | 3.80 | +740 | +391.4 |
| 2022-06 | 3 | 3 | 0 | inf | +534 | +376.0 |
| 2022-07 | 4 | 2 | 2 | 4.11 | +295 | +182.3 |
| 2022-08 | 3 | 2 | 1 | 13.77 | +930 | +688.7 |
| 2022-09 | 3 | 2 | 1 | 0.93 | -11 | -10.5 |
| 2022-10 | 4 | 2 | 2 | 1.64 | +180 | +107.2 |
| 2022-11 | 3 | 2 | 1 | 1.44 | +129 | +126.2 |
| 2022-12 | 2 | 2 | 0 | inf | +316 | +427.3 |
| 2023-01 | 5 | 2 | 3 | 0.67 | -108 | -57.8 |
| 2023-02 | 3 | 2 | 1 | 0.97 | -5 | -3.7 |
| 2023-03 | 4 | 2 | 2 | 3.44 | +522 | +308.7 |
| 2023-04 | 2 | 1 | 1 | 8.58 | +351 | +362.0 |
| 2023-05 | 7 | 3 | 4 | 0.91 | -66 | -23.5 |
| 2023-06 | 7 | 3 | 4 | 0.53 | -294 | -72.6 |
| 2023-07 | 1 | 0 | 1 | 0.00 | -170 | -315.4 |
| 2023-08 | 3 | 1 | 2 | 0.03 | -203 | -142.9 |
| 2023-09 | 1 | 0 | 1 | 0.00 | -71 | -118.8 |
| 2023-10 | 2 | 1 | 1 | 0.08 | -349 | -339.3 |
| 2023-11 | 3 | 2 | 1 | 21.06 | +574 | +395.6 |
| 2023-12 | 2 | 0 | 2 | 0.00 | -89 | -241.0 |
| 2024-01 | 1 | 1 | 0 | inf | +234 | +709.0 |
| 2024-02 | 2 | 1 | 1 | 0.33 | -277 | -318.0 |
| 2024-03 | 2 | 1 | 1 | 1.79 | +108 | +123.1 |
| 2024-04 | 4 | 4 | 0 | inf | +498 | +418.5 |
| 2024-05 | 2 | 1 | 1 | 15.94 | +426 | +489.6 |
| 2024-06 | 1 | 0 | 1 | 0.00 | -383 | -1063.2 |
| 2024-07 | 5 | 3 | 2 | 0.40 | -451 | -263.9 |
| 2024-09 | 4 | 1 | 3 | 0.85 | -110 | -63.5 |
| 2024-10 | 4 | 2 | 2 | 0.19 | -591 | -394.3 |
| 2024-11 | 4 | 3 | 1 | 16.26 | +194 | +181.5 |
| 2024-12 | 2 | 2 | 0 | inf | +316 | +371.3 |
| 2025-01 | 4 | 1 | 3 | 0.02 | -1061 | -698.0 |
| 2025-02 | 5 | 0 | 5 | 0.00 | -545 | -412.8 |
| 2025-04 | 3 | 1 | 2 | 1.68 | +123 | +397.3 |
| 2025-05 | 3 | 2 | 1 | 4.81 | +274 | +914.9 |
| 2025-06 | 4 | 2 | 2 | 1.84 | +98 | +160.0 |
| 2025-07 | 3 | 3 | 0 | inf | +785 | +980.7 |
| 2025-08 | 5 | 4 | 1 | 80.23 | +891 | +546.7 |
| 2025-09 | 2 | 1 | 1 | 0.30 | -244 | -530.0 |
| 2025-10 | 4 | 1 | 3 | 0.32 | -659 | -1135.9 |
| 2025-11 | 3 | 2 | 1 | 1.58 | +187 | +504.4 |
| 2025-12 | 2 | 1 | 1 | 2.67 | +85 | +426.7 |
| 2026-03 | 3 | 1 | 2 | 1.55 | +268 | +994.2 |
| 2026-04 | 2 | 2 | 0 | inf | +159 | +636.9 |
| 2026-05 | 4 | 4 | 0 | inf | +1417 | +2778.0 |
| 2026-06 | 3 | 2 | 1 | 0.17 | -294 | -626.0 |
| TOTALE | 232 | 111 | 121 | 1.14 | +3001 | +34.6 |

fonte: `PERTRADE/abtg_trades_ABTG_MaxMinNotte_XAUUSD_797212.csv` via autopsia_pertrade.aggrega(k=1.8032, close 13:00)

### R269c (DAX LONG -1h, tick, tranche unica 2024.09.26 -> 2026.06.30, gemella 797213; testa R269c par. 4-5)

- S1 SENTINELLA DELL'OROLOGIO: per-trade DIVERSO da 795401, uscite dopo le 16:31: 0, uscite prima delle 08:00: 22 -> ok
- Trades 45, Profit -8771.98, PF 0.59122, Equity DD % 13.1066 [MISURATO], posizioni 35 (attese ~72, SOTTO 150: MERITO SOSPESO per costruzione -> INDIZIO DEBOLE: la distanza H-CAL/H-ASTA 0,818 -> 1,00 e' meno di una sd del bootstrap 0,290) -- fonte: `ROUND_R269c/ABTG_MaxMinNotte_D30EUR_IS_R269c.csv`
- PF per STAGIONE (ora legale UE per data di chiusura, net per posizione, commissione 0): ESTATE 30 pos PF **0.680** (d0: 45 pos, 0.818) -> **H-CAL (0,65 <= PF_estate < 1,00): la stagione e' CALENDARIO, l'orologio non cambia il long d'estate (d0 0.818)**; INVERNO (controllo) 5 pos PF 0.224 contro 1.030 d0
- STOP PIENI: 21; nell'ora 08: 11, nell'ora 07: 10 (d0: 24 su 33 nell'ora 08). Si scrive, NON decide (testa par. 3: a -1h la posizione d'estate e' ancora viva alle 08:00)
- RISCHIO a 1%: Equity DD % **13.1066** contro base d0 7.8243; DD a saldo chiuso 12.1374 % (picco 2025.07.21, fondo 2026.05.08); a 2,00% [DERIVATO, due formule]: 24.50-26.21 (equity) / 22.80-24.27 (saldo chiuso)
- previsione della testa: H-CAL.

**Per MESE (anno-mese), -1h**

| chiave | n | vinti | persi | PF | net EUR | EUR/lotto |
|---|---:|---:|---:|---:|---:|---:|
| 2024-10 | 2 | 0 | 2 | 0.00 | -2041 | -24.5 |
| 2025-01 | 1 | 0 | 1 | 0.00 | -1071 | -24.5 |
| 2025-02 | 1 | 1 | 0 | inf | +939 | +20.5 |
| 2025-04 | 2 | 1 | 1 | 1.85 | +861 | +29.6 |
| 2025-05 | 4 | 3 | 1 | 2.72 | +1779 | +16.1 |
| 2025-06 | 2 | 2 | 0 | inf | +876 | +11.4 |
| 2025-07 | 3 | 2 | 1 | 1.42 | +453 | +4.3 |
| 2025-08 | 4 | 1 | 3 | 0.28 | -2300 | -18.8 |
| 2025-09 | 2 | 0 | 2 | 0.00 | -2060 | -33.5 |
| 2025-10 | 5 | 2 | 3 | 0.19 | -2408 | -17.6 |
| 2025-11 | 1 | 0 | 1 | 0.00 | -983 | -33.1 |
| 2025-12 | 1 | 0 | 1 | 0.00 | -982 | -23.6 |
| 2026-01 | 1 | 0 | 1 | 0.00 | -1160 | -42.2 |
| 2026-04 | 4 | 1 | 3 | 0.81 | -553 | -7.3 |
| 2026-05 | 2 | 1 | 1 | 0.87 | -123 | -4.3 |
| TOTALE | 35 | 14 | 21 | 0.59 | -8772 | -8.6 |

**Per ANNO x STAGIONE, -1h**

| chiave | n | vinti | persi | PF | net EUR | EUR/lotto |
|---|---:|---:|---:|---:|---:|---:|
| 2024-L | 2 | 0 | 2 | 0.00 | -2041 | -24.5 |
| 2025-L | 22 | 11 | 11 | 0.75 | -2798 | -4.4 |
| 2025-S | 4 | 1 | 3 | 0.31 | -2097 | -13.0 |
| 2026-L | 6 | 2 | 4 | 0.83 | -676 | -6.5 |
| 2026-S | 1 | 0 | 1 | 0.00 | -1160 | -42.2 |
| TOTALE | 35 | 14 | 21 | 0.59 | -8772 | -8.6 |

**Filtro S&P spostato (CorrBias legge la barra H1 05:00-06:00 invece della 06:00-07:00) e confronto per GIORNATA con 795401 (d0)**

- giornate con posizione: -1h 35, d0 72, in comune 13, solo -1h 22, solo d0 59 -> le giornate che CAMBIANO (permesso del filtro O box non rotto: il per-trade non li separa) sono al piu' 81 [MISURATO]
- solo -1h: 2024-10-14, 2025-01-29, 2025-02-13, 2025-04-15, 2025-05-06, 2025-05-14, 2025-05-16, 2025-06-27, 2025-07-03, 2025-07-21, 2025-07-30, 2025-08-18, 2025-08-28, 2025-09-29, 2025-10-09, 2025-10-16, 2025-10-24, 2025-11-13, 2026-01-28, 2026-04-01, 2026-04-16, 2026-05-08
- solo d0: 2024-10-15, 2024-10-17, 2024-10-22, 2024-10-28, 2024-11-06, 2024-11-07, 2024-11-28, 2024-12-06, 2025-01-16, 2025-01-17, 2025-01-23, 2025-01-31, 2025-02-06, 2025-02-07, 2025-02-14, 2025-02-20, 2025-03-18, 2025-03-26, 2025-04-14, 2025-04-25, 2025-04-28, 2025-04-29, 2025-04-30, 2025-05-02, 2025-05-05, 2025-06-05, 2025-06-11, 2025-07-02, 2025-07-07, 2025-07-18, 2025-07-31, 2025-08-14, 2025-09-04, 2025-09-08, 2025-09-09, 2025-09-10, 2025-09-17, 2025-09-18, 2025-10-08, 2025-10-22, 2025-10-23, 2025-10-29, 2025-11-26, 2025-12-03, 2025-12-04, 2025-12-05, 2026-01-06, 2026-01-07, 2026-01-13, 2026-01-16, 2026-02-03, 2026-02-20, 2026-04-14, 2026-04-17, 2026-04-29, 2026-05-07, 2026-05-25, 2026-06-15, 2026-06-17

**Giorni in cui hanno operato ENTRAMBI (DAX LONG -1h e DAX LONG d0): 13**

| giorno | DAX LONG -1h net | DAX LONG -1h motivo | DAX LONG d0 net | DAX LONG d0 motivo |
|---|---:|---|---:|---|
| 2024-10-01 | -1030 | STOP_PIENO | -1033 | STOP_PIENO |
| 2025-04-23 | -1011 | STOP_PIENO | +749 | TP1_RUN |
| 2025-05-12 | -1032 | STOP_PIENO | +1398 | TP1_RUN |
| 2025-06-25 | +91 | ALTRO | -1091 | STOP_PIENO |
| 2025-08-12 | -1069 | STOP_PIENO | -983 | STOP_PIENO |
| 2025-08-13 | -1038 | STOP_PIENO | +647 | TP1_RUN |
| 2025-09-12 | -1040 | STOP_PIENO | -990 | STOP_PIENO |
| 2025-10-02 | -982 | STOP_PIENO | +2068 | TP1_RUN |
| 2025-10-10 | -1002 | STOP_PIENO | -1053 | STOP_PIENO |
| 2025-12-29 | -982 | STOP_PIENO | -1042 | STOP_PIENO |
| 2026-04-21 | -1003 | STOP_PIENO | +522 | TP1_RUN |
| 2026-04-24 | -928 | STOP_PIENO | -1019 | STOP_PIENO |
| 2026-05-27 | +835 | TP1_RUN | +822 | TP1_RUN |

- giorni solo DAX LONG -1h: 22; giorni solo DAX LONG d0: 59

fonte: `PERTRADE/abtg_trades_ABTG_MaxMinNotte_D30EUR_797213.csv` via autopsia_pertrade.aggrega(k=0, close 16:30); base `archivio_CORTI_B_pertrade_795401.csv`


---

**Cosa resta a mano (non e' in questo script):** la decisione sull'ora del flat (R269), sull'orologio d'inverno delle sedie (R269c, entro il 25/10) e su ogni taglia (R268c/d) sono FIRME di Claudio; il P0-TICK caso (iii) resta [NON VERIFICATO] finche' il giornale dell'agente non si legge a mano; la commissione FTMO sull'oro e' [NON MISURATA] (il tester usa BCM).
