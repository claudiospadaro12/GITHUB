# EMA200 e il RIMBALZO: stato dell'arte dell'archivio (30/09/2026)

Sola lettura d'archivio + questo referto. Nessun backtest lanciato, nessun EA / preset / magic / sedia / file prova toccato, nessun terminale, nessun forward. Le uniche cose calcolate sono ricontrolli in Python sui CSV gia' in repo (scratch, non committati).
Richiesta: Claudio, 30/09/2026 (piu' due aggiunte: la testimonianza della collega, H1/H2, e l'osservazione "su M1/M5 la EMA200 non e' forte", H3).
Etichette: [MISURATO] letto da un file; [DERIVATO] calcolo mio da numeri misurati (formula scritta); [INFERITO] deduzione; [NON MISURATO] non esiste in archivio; [NON VERIFICABILE] il file non porta l'informazione.
Questo referto NON archivia nessun candidato e NON promuove niente: descrive lo stato e propone una misura. Nessuna taglia e' proposta (rischio e lotti sono di Claudio).

---

## 0. I FATTI, in dieci righe

1. **Una misura del rimbalzo sulla EMA200 nel repo NON esiste.** Ne' "quante volte il prezzo rimbalza dopo il primo tocco prima di sfondare" (H1 di Claudio/collega), ne' "quante volte uno sfondamento viene ritestato" (H2), ne' un gradiente per TF della frequenza (H3). Tutto quello che c'e' sono PF di un MOTORE (`ABTG_EMA200`), che mescola frequenza di rimbalzo, gestione dell'uscita, costo e regime. Ricerche fatte: sez. 5.1.
2. **L'unica sedia viva e' U30USD H1 (771531)**, non H4/D1: tick reali, n OOS 257 posizioni (PF 1,52365, DD 7,8323% a rischio 1%), IS solo 132 posizioni (sotto i 150). Forward sul demo piccolo: 23 posizioni, netto -54,71, 10 vinte, 23/23 chiuse con motivo `sl` (sez. 2.6).
3. **H4, dove il PF di screening e' bello, NON regge la finestra lunga sui tre simboli dove e' stata provata**: AUDJPY (2010-2026) DD 15,4-20,4% e PF max 1,008 in OOS; GBPUSD IS PF 0,80-0,84, DD 17,7-20,3%, segno opposto fra IS e OOS su 4 celle su 4; XAUUSD IS 2017-23 PF 0,810-0,836, e a 22 anni (R100, OHLC) DD 55,02% a rischio 1%. Il PF alto dell'H4 e' la finestra 2024-2026 (sez. 2.3).
4. **A H4 l'"edge" e' quasi sempre a UNA gamba sola**: su 47 simboli, 12 hanno un lato con >=80% di celle positive e l'altro <=20%; solo 3 (CADJPY, EURJPY, XAUUSD) hanno entrambi i lati >=80%. Un rimbalzo "della EMA200" dovrebbe funzionare da entrambe le parti; questo schema e' quello di un segno di deriva della finestra (long dove il sottostante e' salito, short dove e' sceso) [INFERITO, non provato] (sez. 2.2).
5. **D1: una sola cella di default su sei simboli, n = 0-41 deal per finestra** (sez. 2.4). Non e' misurabile, non e' "morto". **M1/M5: mai misurati** in nessuna riga di nessun CSV (il TF piu' basso mai provato e' M15). Il gradiente del PF per TF esiste gia' nell'archivio (M15-M30 in utile in 1 cella tick su 30, H4-H8 si', D1 non misurabile) ma e' un gradiente di PF, non di frequenza di rimbalzo (sez. 2.5).
6. **La definizione di "rimbalzo" dell'EA non e' MAI stata messa ad asse**: `InpMinDistAtr` 0,3, `InpMaxDistAtr` 1,5, `InpUseEma14Bias` 1, `InpUseOrder2` 1, `InpPendingExpiryBars` 6, `InpBreakeven` 1, `InpEma14Period` 14 hanno UN valore in tutti i CSV EMA200 del repo (sez. 4). E il periodo 200 e' stato sondato una volta sola (SPXUSD H4, R3): in IS 150 fa meglio (2,46), 175 e' pari (1,80 contro 1,85), 225 e 250 perdono (0,63 / 0,42); in OOS 200 e' il picco (1,595 contro 1,094 e 0,889) (sez. 2.3).
7. **Un dato che smonta il "quasi sempre" senza aver misurato nulla**: in una passeggiata casuale senza drift la probabilita' di toccare +X prima di -Y e' Y/(X+Y). Con X piccolo e Y grande viene alta da sola (X=0,25 ATR, Y=1,0 ATR: 0,80). E il "ritest prima di scappare" di H2 con soglie plausibili vale gia' 0,71-0,83 in un random walk (sez. 5.3). Qualunque misura di H1/H2 deve battere QUEL numero, non lo zero.
8. **"Pochi punti" = payoff asimmetrico**: con costo dell'ordine di 0,03 R, un TP a 0,25 R chiede una vincita >= ~82% per pareggiare [DERIVATO]. I dati di casa dicono che avvicinare il primo bersaglio alza la frequenza di tocco ma non il PF (DAX Apertura R202B; EMA200 Dow R136b) (sez. 6).
9. **"Aumentare i lotti"**: nessuna misura su scalare/piramidare l'EMA200 esiste; c'e' solo l'analisi di flotta sul "dial delle taglie" (26/08). Lotto uniforme piu' grande = rischio (firma di Claudio); aumentare dopo una perdita = martingala = scarto a vista (sez. 7).
10. **Il disegno della misura (sez. 5) costa ZERO passate di tester**: e' Python su barre M1 storiche. Tempo macchina [NON MISURATO].

---

## 1. Che cosa fa il meccanismo, dal sorgente (e cosa NON e')

`mql5/Experts/ABTG_EMA200.mq5` (HEAD, 690 righe). A ogni barra nuova del TF operativo (`OnNewBar`, r.319):
- salta se ha gia' una posizione o un pendente (r.322: massimo 2 posizioni contemporanee = le due gambe di un segnale);
- vuole `MinDistAtr(0,3) x ATR <= |close1 - EMA200| <= MaxDistAtr(1,5) x ATR` (r.331): il prezzo deve stare in una fascia di distanza dalla media;
- direzione = lato del prezzo: sopra la EMA200 -> BUY LIMIT, sotto -> SELL LIMIT (r.338); con `InpUseEma14Bias` la EMA14 deve stare dallo stesso lato (r.341);
- piazza DUE LIMIT (`PlaceOrders`, r.354-366): il 1o a `EMA200 +/- InpOrder1Atr x ATR` (default 0,10, verso il prezzo), il 2o oltre la media a `InpOrder2Atr` (default 0,35); stop unico `InpSLatr` (1,0) ATR oltre il 2o; rischio totale diviso per due gambe (`riskPct = InpRiskPercent/nOrders`, r.361); scadenza dei pendenti `InpPendingExpiryBars` = 6 barre (r.378);
- gestione (`ManageAll`, r.392+): parziale del 50% sulla EMA14 (r.414), poi stop in pari e trailing sulla EMA14 (r.436); TP finale a `InpTP_RR` = 2 R.

Conseguenza che serve a questo referto: **il motore non misura "il rimbalzo", misura un pacchetto** (fascia di distanza + conferma EMA14 + due limit + stop a ~1,3-1,35 ATR dalla media + parziale + trailing). Un PF alto o basso non separa "il prezzo rimbalza" da "la gestione lo fa sembrare". Sulla sedia Dow le uscite del backtest OOS (257 posizioni) sono: utile via BE/trailing 145 (56,4%), perdita parziale via BE/trailing 23 (8,9%), stop pieno 78 (30,4%), TP finale a RR 2,0 solo 11 (4,3%) [MISURATO, `report/EMA200_I_DUE_REQUISITI_2026-09-12.md` sez. 7]; nel forward 23/23 uscite con motivo `sl`.
Da questa ripartizione (assunto: BE e trailing esistono solo dopo il parziale, `ABTG_EMA200.mq5` r.436) esce l'unico numero d'archivio vicino a "quante volte il primo bersaglio arriva prima dello stop pieno": 179/257 = **69,6%** (145+23+11) [DERIVATO da quella ripartizione]. Ma il primo bersaglio (EMA14) e' a distanza variabile e non misurata, lo stop e' a ~1,3 ATR, sono posizioni gia' riempite (non tocchi), due gambe per segnale, finestra unica rialzista del Dow. Vedi sez. 5.3: 0,70 e' quello che un random walk da' gia' con X ~ 0,57 ATR.

---

## 2. LA TABELLA DI CIO' CHE E' STATO MISURATO

Convenzioni: "L" = solo long (`InpAllowLong=1, InpAllowShort=0`), "S" = solo short, "L+S" = due lati. Unita' di conto: `Trades` del CSV = DEAL di uscita, non posizioni (classe 226): sull'EMA200 Dow il rapporto deal/posizione e' 2,0117 in OOS (517 -> 257) e 1,79545 in IS (237 -> 132) [MISURATO, `report/EMA200_LA_PORTA_DEL_TRAILING_2026-09-18.md` sez. 3]. Ovunque sotto "n" = deal, salvo dove scritto "pos".

### 2.1 La sedia: U30USD, H1 e dintorni, tick reali

Finestra dei round R110/R112/R234: 2024.09.26 -> 2026.06.30, split 40/60 (IS 2024.09.26-2025.06.09, OOS 2025.06.10-2026.06.30), Modello 4 (tick reali), deposito 100000, rischio 1% (`report/EMA200_DOW_COSA_MANCA_2026-09-12.md`; header `prove/R112...`). Regime contenuto: UN solo mercato, Dow rialzista 2024-26 (lo storico BCM sugli indici parte dal 2024.09.26, stato `COMPLETO`: `report/LO_STORICO_ESTERNO_MAPPA_2026-09-23.md`); NON esiste un Dow esterno.

| TF | lato | IS: PF / n / DD% | OOS: PF / n / DD% | file fonte | stato |
|---|---|---|---|---|---|
| H1 | L+S | 1,20110 / 237 / 5,7325 | 1,52365 / 517 / 7,8323 | `risultati_archivio/R112_CORSA_20260826/ABTG_EMA200_U30USD_{IS,OOS}_00_metro.csv` | VIVO (demo 50503392, "non proposta per la challenge": `report/DECISIONE_EMA200_RESTA_SUL_DEMO_2026-09-18.md`) |
| H1 | L | 1,16183 / 112 / 2,6377 | 1,24103 / 241 / 8,8973 | `prove/R110_CSV_EMADOW/ABTG_EMA200_U30USD_{IS,OOS}_01_long.csv` | NON ANCORA MISURATO come sedia a se' (n IS 112 < 150) |
| H1 | S | 1,23153 / 125 / 4,5113 | 1,89147 / 302 / 2,6628 | `prove/R110_CSV_EMADOW/..._02_short.csv`; riprodotto cifra per cifra da R234a (`report/REFERTO_13_ROUND_2026-09-23.md` T1) | NON ANCORA MISURATO (n IS 125 < 150) |
| H1 | L+S, 30 celle | PF 1,05-1,33, n 194-238, DD 4,4-5,8 | PF 1,44-1,61, n 402-500, DD 6,0-8,5 | `risultati_prove/ABTG_EMA200/ABTG_EMA200_U30USD_{IS,OOS}_r29b.csv` (30/30 celle positive) | altopiano vivo |
| H1 | L / S / L+S, singola finestra | -- | L 31/31 in utile PFmed 1,261; S 26/26 PFmed 1,487; L+S 27/27 PFmed 1,400 | `risultati_prove/risultati_valid_ABTG_EMA200_H1_realtick/valid_ABTG_EMA200_H1_realtick_U30USD.csv` (137 righe; Optimization=2 genetico, le celle non sono un campione uniforme) | conferma a tick |
| M15 | L+S | 0,77131 / 1168 / 27,77 | 0,95408 / 2020 / 26,34 | `risultati_prove/dal_vps/ABTG_EMA200/ABTG_EMA200_U30USD_{IS,OOS}_cemad05.csv` | ESCLUSO PER COSTO (gamba 2 / spread 20,0-22,6x; frontiera 40x) e PF < 1 |
| M20 | L+S | 1,11669 / 918 / 9,13 | 0,83338 / 1642 / 30,71 | idem | ESCLUSO PER COSTO (23,1-26,1x) e OOS < 1 |
| M30 | L+S | 1,03404 / 508 / 10,92 | 0,90713 / 1268 / 15,87 | idem | ESCLUSO PER COSTO (28,3-32,0x) e OOS < 1 |
| H2 | L+S | 2,59887 / 127 / 2,42 | 1,17278 / 266 / 6,12 | idem | NON ANCORA MISURATO (passa il costo 56,6-64,0x; sotto 150 in IS) |
| H3 | L+S | 2,15163 / 36 / 2,18 | 0,90825 / 170 / 9,00 | idem | OOS < 1; IS n=36 |
| H4 | L+S | 1,66012 / 26 / 2,37 | 1,42483 / 116 / 4,45 | idem; OHLC 2024-26: `risultati_archivio/EMA200/H4_OHLC/scan_ABTG_EMA200_H4_U30USD.csv` (77/85 celle positive, n 15-82) | fuori per FREQUENZA (21-41 pos), non per edge |
| H2 / H3 / H4 | S (solo short) | H2 2,821 (n33), H3 1,877 (n20), H4 3,501 (n9) | H2 0,789 (n111), H3 0,669 (n63), H4 0,367 (n20) | numeri dal referto `report/REFERTO_13_ROUND_2026-09-23.md` sez. 2 (R234a): **i CSV R234 NON sono in repo** | short-only H2-H4 negativo in OOS; il long-only a H2-H4 [NON MISURATO] |
| M5 | -- | [NON MISURATO] | [NON MISURATO] | mai girato | ESCLUSO PER COSTO: gamba 2 / spread = 11,5-13,1x, sotto il pavimento DURO 13,3x (`report/EMA200_I_DUE_REQUISITI_2026-09-12.md` sez. 4.3, legge di scala dichiarata +-20%); in piu' 21 mesi a M5 = ~132.000 barre > tetto ~100.000 del tester |

Cost-frontier H1 Dow: gamba 2 / spread di sessione = 33,6-45,2x, "la soglia 40x cade dentro la banda misurata" (FRAGILE, non PASS) [MISURATO/DERIVATO, stessa fonte]. H2/H3/H4: 56,6-64,0x / 69,3-78,3x / 80,0-90,5x.

Gestione dell'uscita messa ad asse su questa sedia (R136a-d, `risultati_prove/dal_vps/ABTG_EMA200/ABTG_EMA200_U30USD_{IS,OOS}_r136{a,b,c,d}.csv`): `InpSLatr` 0,4-1,6 (OOS PF 1,26-1,61, IS 1,07-1,25); `InpTP1_ATRmult` 0-1,5 (0,25: IS 0,994 / OOS 1,590, DD OOS 2,10; 0,50: IS 1,014 / OOS 1,409); `InpTP1Pct` 0/25/50/75 (0: OOS PF 1,28144, DD 13,9367%, n 165; 25/50/75 quasi identici, OOS 1,518-1,526); `InpUseTrailing` 1 -> 0 (IS PF 1,201 -> 1,107; OOS 1,524 -> 1,771: segno invertito fra IS e OOS = "non misurabile come miglioramento"). Il parziale e' cio' che tiene il DD sotto il 10%.

### 2.2 Screening OHLC a finestra unica: 47 simboli a H4, 48 a H1 (per lato)

Fonte: `backtest_pipeline/risultati_archivio/EMA200/H4_OHLC/scan_ABTG_EMA200_H4_<SIMBOLO>.csv` e `.../H1_OHLC/scan_ABTG_EMA200_H1_<SIMBOLO>.csv` (magic 771501, rischio 1%, griglia su `InpOrder1Atr` x `InpOrder2Atr` x `InpTP_RR` e su L/S). Finestra dichiarata dal driver `scan_market.ps1` r.72-73: 2024.01.01 -> 2026.06.30, Modello 1 (OHLC), deposito 10000, UNA finestra, nessuno split [il CSV non riporta la finestra: NON VERIFICABILE per singolo file]. Ultima colonna: validazione a TICK REALI H4 (2024.01.01-2026.06.30, Model=4, Optimization=2 genetico) `.../EMA200/realtick_H4/valid_ABTG_EMA200_H4_realtick_<SIMBOLO>.csv`, solo 8 simboli.
Come si legge una cella: `pos/vive PFmed nX DDY` = celle con profitto > 0 su celle con almeno un trade in quel lato; PFmed = mediana del PF sulle celle con n >= 20; nX e DDY = n (deal) e DD% della cella col PF massimo con n >= 20. E' una misura di ROBUSTEZZA DELLA GRIGLIA in una finestra, non di edge. "n/d" = nessuna cella viva.
Controllo che il mio conteggio non e' circolare: le celle positive/vive per simbolo coincidono con quelle scritte indipendentemente da un'altra sessione (U30USD H4 77/85, SPXUSD 75/86, D30EUR 54/92, F40EUR 52/92, 200AUD 58/92, 100GBP 50/91, 225JPY 64/83, E50EUR 0/81; H1: SPXUSD 1/79, D30EUR 0/85, F40EUR 0/88, NASUSD 1/85) [confronto con `report/EMA200_I_DUE_REQUISITI_2026-09-12.md` sez. 2].
`NASUSD` a H4: il file NON esiste (unico buco della matrice) [NON MISURATO].

| Simbolo | H4 L | H4 S | H4 L+S | H1 L | H1 S | H1 L+S | tick H4 L / S / L+S |
|---|---|---|---|---|---|---|---|
| 100GBP | 27/27 1.36 n93 DD4.1 | 3/35 0.79 n76 DD4.2 | 20/29 1.07 n185 DD3.9 | 9/30 0.92 n284 DD9.7 | 0/28 0.67 n382 DD13.5 | 0/35 0.81 n583 DD18.1 | - |
| 200AUD | 29/29 2.15 n88 DD1.4 | 0/34 0.75 n63 DD1.7 | 29/29 1.28 n143 DD1.3 | 13/30 0.99 n431 DD4.1 | 0/31 0.72 n326 DD7.4 | 0/26 0.88 n705 DD8.2 | 25/25 1.95 n83 DD1.4 / 0/34 0.75 n63 DD1.7 / 28/28 1.24 n143 DD1.3 |
| 225JPY | 20/28 1.11 n28 DD0.4 | 23/29 2.14 n23 DD0.3 | 21/26 1.15 n50 DD0.6 | 0/25 0.66 n83 DD0.6 | 27/29 1.18 n126 DD0.3 | 14/31 1.00 n167 DD0.7 | 22/29 1.10 n29 DD0.3 / 24/35 1.92 n33 DD0.2 / 24/27 1.18 n53 DD0.5 |
| AUDJPY | 30/30 1.87 n180 DD3.1 | 15/30 0.99 n141 DD2.2 | 27/27 1.52 n311 DD3.6 | 20/37 1.00 n723 DD9.3 | 7/37 0.94 n552 DD6.6 | 7/19 0.98 n1320 DD15.2 | 24/24 1.85 n180 DD2.5 / 16/32 0.99 n136 DD1.9 / 28/28 1.52 n306 DD3.6 |
| AUDUSD | 14/28 1.00 n213 DD6.8 | 0/21 0.53 n148 DD8.9 | 0/26 0.75 n319 DD9.8 | 17/34 1.00 n511 DD6.9 | 2/25 0.93 n623 DD8.1 | 2/26 0.94 n1157 DD9.6 | - |
| CADCHF | 0/30 0.66 n252 DD2.9 | 34/34 1.38 n217 DD3.0 | 13/24 1.03 n458 DD4.7 | 0/33 0.77 n666 DD19.7 | 19/23 1.06 n757 DD9.0 | 0/24 0.88 n1250 DD15.8 | - |
| CADJPY | 23/24 1.41 n164 DD2.7 | 33/37 1.15 n120 DD3.4 | 31/31 1.22 n280 DD3.7 | 0/25 0.75 n460 DD25.2 | 0/27 0.90 n555 DD6.8 | 0/36 0.82 n1026 DD15.8 | - |
| CHFJPY | 6/26 0.84 n186 DD5.7 | 31/37 1.15 n135 DD3.5 | 8/20 0.93 n259 DD8.2 | 9/35 0.97 n621 DD7.2 | 0/22 0.54 n527 DD18.4 | 0/30 0.75 n1127 DD19.8 | - |
| D30EUR | 30/30 1.44 n115 DD3.8 | 1/34 0.77 n64 DD4.0 | 23/28 1.16 n180 DD4.7 | 0/31 0.79 n368 DD7.5 | 0/26 0.87 n358 DD10.8 | 0/28 0.81 n659 DD11.4 | - |
| E35EUR | 0/27 0.33 n25 DD3.6 | 0/24 -- n12 DD3.5 | 0/34 0.29 n36 DD5.7 | 5/23 0.87 n89 DD5.1 | 16/31 1.00 n114 DD3.8 | 1/27 0.88 n245 DD6.1 | - |
| E50EUR | 0/21 0.73 n81 DD4.6 | 0/29 0.50 n59 DD3.4 | 0/31 0.68 n146 DD5.7 | 0/25 0.65 n210 DD7.1 | 0/32 0.35 n233 DD16.6 | 0/31 0.50 n460 DD25.3 | - |
| EURAUD | 1/23 0.90 n156 DD2.7 | 26/26 1.36 n181 DD5.1 | 32/33 1.13 n389 DD8.5 | 0/21 0.86 n617 DD11.3 | 3/29 0.95 n606 DD18.1 | 1/30 0.91 n1281 DD12.9 | - |
| EURCAD | 21/29 1.02 n227 DD4.8 | 4/31 0.88 n206 DD5.4 | 7/24 0.94 n401 DD9.3 | 0/39 0.78 n761 DD16.2 | 0/20 0.74 n611 DD15.0 | 0/21 0.77 n1288 DD27.5 | - |
| EURCHF | 0/25 0.60 n194 DD7.8 | 11/23 0.99 n186 DD3.6 | 0/30 0.77 n315 DD9.1 | 0/24 0.74 n640 DD12.9 | 22/32 1.08 n873 DD12.9 | 4/33 0.89 n1342 DD18.4 | - |
| EURGBP | 0/28 0.50 n170 DD12.0 | 8/35 0.94 n204 DD8.8 | 0/25 0.72 n332 DD12.6 | 0/33 0.79 n652 DD10.0 | 0/22 0.86 n703 DD14.9 | 0/26 0.82 n1488 DD22.1 | - |
| EURJPY | 27/30 1.36 n222 DD4.4 | 31/31 1.52 n157 DD2.0 | 23/23 1.51 n335 DD4.6 | 2/32 0.94 n683 DD8.2 | 0/25 0.76 n624 DD16.2 | 0/32 0.88 n1309 DD18.8 | - |
| EURNOK | 1/31 0.84 n115 DD5.5 | 0/19 0.69 n178 DD4.1 | 0/30 0.74 n248 DD7.9 | 0/26 0.75 n538 DD14.9 | 0/31 0.64 n600 DD23.2 | 0/37 0.70 n961 DD31.8 | - |
| EURNZD | 24/32 1.20 n156 DD7.0 | 13/26 1.01 n167 DD3.9 | 25/28 1.09 n325 DD7.1 | 1/31 0.93 n679 DD12.0 | 25/28 1.12 n673 DD5.6 | 23/35 1.03 n1191 DD9.9 | - |
| EURPLN | 0/24 0.47 n213 DD6.0 | 0/33 0.67 n248 DD8.5 | 0/22 0.66 n440 DD11.3 | 0/29 0.55 n508 DD29.8 | 0/27 0.32 n694 DD65.9 | 0/31 0.43 n1144 DD69.6 | - |
| EURSEK | 0/28 0.89 n226 DD6.0 | 13/27 0.99 n241 DD3.5 | 14/33 0.98 n301 DD4.3 | 0/29 0.55 n539 DD31.6 | 0/28 0.73 n598 DD19.5 | 0/28 0.69 n1041 DD44.1 | - |
| EURUSD | 0/28 0.79 n129 DD4.2 | 26/26 1.32 n200 DD4.4 | 24/31 1.04 n357 DD5.0 | 32/32 1.34 n629 DD6.9 | 33/33 1.11 n566 DD11.2 | 28/28 1.22 n1309 DD9.1 | - |
| F40EUR | 30/30 1.33 n111 DD3.2 | 0/30 0.71 n81 DD4.1 | 22/32 1.06 n151 DD4.2 | 0/30 0.81 n250 DD7.8 | 0/28 0.58 n165 DD9.0 | 0/30 0.74 n384 DD12.7 | - |
| GBPAUD | 3/30 0.91 n219 DD4.5 | 0/23 0.51 n167 DD6.3 | 0/28 0.66 n381 DD10.2 | 0/36 0.62 n464 DD17.8 | 22/23 1.08 n724 DD8.8 | 0/30 0.87 n1221 DD19.1 | - |
| GBPCAD | 0/27 0.83 n241 DD6.8 | 5/27 0.90 n200 DD3.5 | 0/30 0.84 n387 DD8.4 | 0/30 0.76 n670 DD16.9 | 0/33 0.91 n594 DD8.5 | 0/25 0.82 n1302 DD17.0 | - |
| GBPCHF | 13/35 0.98 n180 DD4.9 | 24/29 1.04 n186 DD4.3 | 18/28 1.01 n370 DD5.2 | 0/32 0.76 n648 DD19.6 | 0/32 0.67 n583 DD23.8 | 0/26 0.72 n1310 DD36.5 | - |
| GBPJPY | 24/24 1.81 n149 DD3.4 | 0/35 0.61 n74 DD3.2 | 37/37 1.27 n204 DD3.8 | 1/30 0.89 n745 DD14.9 | 0/24 0.73 n538 DD14.1 | 0/28 0.80 n1182 DD20.2 | 32/32 1.73 n146 DD3.4 / 0/40 0.59 n73 DD3.1 / 19/19 1.24 n208 DD3.8 |
| GBPNZD | 0/30 0.85 n177 DD4.2 | 2/24 0.80 n182 DD4.1 | 1/24 0.73 n314 DD4.5 | 0/22 0.67 n536 DD17.6 | 0/31 0.67 n536 DD15.9 | 0/33 0.67 n908 DD30.4 | - |
| GBPUSD | 12/29 0.97 n167 DD4.8 | 30/30 1.81 n171 DD4.3 | 24/24 1.35 n272 DD6.3 | 1/19 0.91 n701 DD10.4 | 0/34 0.86 n629 DD13.3 | 0/37 0.90 n1215 DD13.4 | 8/31 0.96 n168 DD4.9 / 32/32 1.67 n141 DD4.2 / 24/24 1.23 n274 DD7.1 |
| NASUSD | NON MISURATO | NON MISURATO | NON MISURATO | 1/29 0.83 n255 DD5.7 | 0/30 0.77 n273 DD6.0 | 0/26 0.75 n550 DD10.6 | - |
| NZDCAD | 0/32 0.86 n152 DD7.7 | 6/28 0.94 n236 DD4.0 | 0/25 0.86 n393 DD11.1 | 0/29 0.63 n598 DD24.1 | 0/33 0.78 n818 DD17.6 | 0/20 0.72 n1257 DD26.2 | - |
| NZDCHF | 7/36 0.90 n195 DD5.7 | 27/27 1.19 n247 DD3.1 | 25/30 1.03 n448 DD4.5 | 0/23 0.79 n608 DD13.6 | 0/30 0.69 n865 DD25.5 | 0/21 0.72 n1316 DD28.0 | - |
| NZDJPY | 26/26 1.39 n226 DD5.3 | 0/34 0.58 n149 DD4.9 | 18/28 1.03 n388 DD6.7 | 0/30 0.84 n633 DD11.3 | 5/24 0.93 n660 DD13.4 | 0/31 0.88 n1269 DD15.6 | - |
| NZDUSD | 9/27 0.89 n165 DD4.7 | 0/31 0.63 n125 DD6.5 | 0/31 0.73 n335 DD6.4 | 0/27 0.64 n670 DD19.6 | 1/23 0.87 n574 DD12.8 | 0/31 0.76 n1068 DD27.7 | - |
| SPXUSD | 32/32 1.53 n85 DD1.9 | 14/25 1.07 n61 DD1.6 | 29/29 1.53 n127 DD1.9 | 0/27 0.70 n364 DD12.6 | 1/25 0.79 n316 DD5.4 | 0/27 0.76 n528 DD12.4 | 31/31 1.59 n74 DD2.6 / 20/28 1.15 n65 DD2.1 / 25/25 1.38 n116 DD1.9 |
| U30USD | 30/30 1.76 n32 DD2.5 | 19/27 1.47 n23 DD2.1 | 28/28 1.61 n42 DD2.6 | 23/23 1.26 n244 DD3.6 | 32/32 1.51 n300 DD3.8 | 26/26 1.41 n556 DD5.2 | - |
| UKOIL | 1/34 0.77 n57 DD3.3 | 0/34 0.70 n140 DD4.0 | 2/26 0.81 n169 DD5.5 | 0/30 0.84 n340 DD10.5 | 0/33 0.68 n269 DD13.5 | 0/24 0.76 n592 DD20.1 | - |
| USDCAD | 25/26 1.14 n181 DD3.6 | 5/36 0.89 n203 DD3.6 | 8/27 0.97 n333 DD6.4 | 1/33 0.88 n501 DD11.5 | 0/30 0.71 n473 DD11.7 | 0/31 0.82 n829 DD19.7 | - |
| USDCHF | 0/26 0.70 n115 DD6.1 | 0/26 0.73 n135 DD5.0 | 0/31 0.75 n258 DD9.8 | 10/29 0.99 n866 DD9.8 | 0/30 0.67 n639 DD17.2 | 0/25 0.80 n1125 DD21.4 | - |
| USDJPY | 4/24 0.96 n146 DD6.0 | 0/25 0.65 n106 DD4.0 | 0/30 0.82 n262 DD6.3 | 16/23 1.03 n557 DD6.7 | 0/35 0.75 n456 DD9.4 | 1/26 0.91 n943 DD8.9 | - |
| USDNOK | 10/21 0.96 n162 DD2.5 | 29/31 1.72 n176 DD2.8 | 32/34 1.36 n300 DD3.1 | 0/26 0.66 n503 DD15.4 | 0/30 0.60 n556 DD19.2 | 0/37 0.69 n963 DD30.0 | 5/32 0.86 n160 DD2.5 / 15/30 0.98 n162 DD2.3 / 12/26 0.93 n295 DD4.5 |
| USDPLN | 0/27 0.56 n124 DD8.2 | 11/22 0.93 n212 DD4.5 | 0/26 0.71 n307 DD8.5 | 0/27 0.53 n466 DD32.9 | 0/26 0.59 n630 DD34.0 | 0/27 0.58 n1051 DD57.0 | - |
| USDSEK | 0/25 0.69 n101 DD8.2 | 1/29 0.87 n168 DD4.1 | 0/32 0.77 n238 DD13.7 | 0/24 0.50 n508 DD27.4 | 0/31 0.49 n536 DD27.0 | 0/27 0.51 n1219 DD56.6 | - |
| USOIL | 0/22 0.59 n62 DD4.3 | 23/29 1.04 n116 DD4.5 | 10/31 0.99 n154 DD6.4 | 0/27 0.69 n371 DD17.2 | 0/26 0.69 n319 DD10.5 | 0/31 0.70 n510 DD21.9 | - |
| XAGUSD | 0/30 0.30 n41 DD13.4 | 10/32 0.79 n42 DD7.4 | 0/25 0.40 n86 DD13.3 | 0/31 0.57 n31 DD9.1 | 27/30 1.47 n21 DD3.1 | 13/25 1.01 n52 DD6.5 | - |
| XAUUSD | 33/33 1.48 n86 DD5.1 | 28/32 1.31 n68 DD3.7 | 25/25 1.29 n146 DD8.2 | 32/32 1.31 n455 DD6.8 | 18/27 1.02 n286 DD6.1 | 26/26 1.19 n745 DD13.1 | 33/33 1.45 n86 DD5.1 / 27/33 1.12 n66 DD3.8 / 29/29 1.38 n197 DD5.1 |
| XNGUSD | 23/31 1.30 n102 DD3.0 | 0/44 0.25 n86 DD14.8 | 11/23 0.93 n133 DD4.9 | 8/30 0.73 n159 DD6.4 | 0/34 0.61 n197 DD11.4 | 0/28 0.71 n324 DD13.6 | - |
| XPDUSD | 16/29 -- n7 DD48.6 | 28/31 -- n10 DD22.3 | 16/29 1.25 n33 DD59.6 | 0/14 -- n1 DD44.4 | n/d | 0/15 -- n2 DD67.8 | - |
| XPTUSD | 0/37 -- n2 DD65.4 | 22/22 -- n13 DD17.4 | 0/20 -- n13 DD65.7 | 0/18 -- n7 DD48.3 | 0/12 -- n7 DD25.9 | 0/17 -- n8 DD48.9 | - |

Che cosa dice la tabella, contato sulla tabella stessa (soglie di lettura mie, dichiarate): "lato robusto" = >= 80% di celle positive, "lato assente" = <= 20%.
- **H4 (47 simboli)**: entrambi i lati robusti solo su CADJPY, EURJPY, XAUUSD; lato unico (uno >= 80% e l'altro <= 20%) su 12 simboli: 100GBP(L), 200AUD(L), CADCHF(S), D30EUR(L), EURAUD(S), EURUSD(S), F40EUR(L), GBPJPY(L), NZDCHF(S), NZDJPY(L), USDCAD(L), XPTUSD(S). Nessun lato robusto: 11 simboli. Mezzi: 21.
- **H1 (46 simboli con >= 15 celle vive per lato)**: entrambi i lati robusti solo su EURUSD e U30USD (lo stesso insieme esce da una seconda scansione H1 in `risultati_prove/risultati_scan_ABTG_EMA200_H1/`, finestra non dichiarata nel CSV); lato unico 5 simboli (225JPY S, CADCHF S, EURNZD S, GBPAUD S, XAGUSD S); nessun lato robusto su 27 simboli.
- Sulla stessa finestra e con lo stesso motore, il segno di ogni lato segue chi e' salito/sceso (200AUD, AUDJPY, GBPJPY, indici azionari long; GBPUSD, USDNOK, EURUSD, CADCHF short): e' lo schema atteso da una deriva, non da un rimbalzo simmetrico [INFERITO]. Qui c'e' un altro caso gia' scritto in casa: sull'orologio degli indici DAX "in quasi tutte le celle LONG = -SHORT esatto: ogni ora verde era deriva del toro" (`HANDOFF.md` 07/09).
- Le validazioni a tick (8 simboli) confermano lato per lato quanto sopra; NON hanno split IS/OOS e sono un campione genetico (135 celle per simbolo su una griglia molto piu' grande), quindi "celle positive" non e' una frazione della griglia (`backtest_pipeline/REGISTRO_TEST.md` 12/09).

### 2.3 Finestra lunga, regime, periodo della media (H4, H1 non-Dow)

| candidato | finestra / modello | IS: PF / n / DD% (a 1%) | OOS: PF / n / DD% | fonte | stato |
|---|---|---|---|---|---|
| AUDJPY H4 L+S | 2010.01.01-2026.06.30, OHLC, split 40/60 di default (IS ~ 2010-2016, OOS ~ 2016-2026) [DERIVATO dal default 0,40 del driver] | 0,78-0,81 / 757-768 / 15,4-16,9 (4 celle) | 0,95-1,01 / 1322-1345 / 16,9-20,4 | `risultati_prove/dal_vps/ABTG_EMA200/ABTG_EMA200_AUDJPY_{IS,OOS}_ohlc_r139a.csv` | MORTO con certificato dichiarato COMPLETO (`report/CHI_E_PIU_VICINO_AL_CAMPO_2026-09-24.md` sez. 5): rischio 8 celle su 8; il 1,514 di una finestra unica descrive "una fetta" |
| GBPUSD H4 L+S | idem | 0,80-0,84 / 856-875 / 17,7-20,3 | 1,13-1,14 / 1292-1321 / 10,1-11,0 | `.../ABTG_EMA200_GBPUSD_{IS,OOS}_ohlc_r139b.csv` | FAIL rischio (S3) + segno opposto su 4 celle su 4 = "regime, non edge" (`backtest_pipeline/REGISTRO_TEST.md` righe r139a/b) |
| XAUUSD H4 L+S | IS 2017-2023 / OOS 2024-2026, OHLC M1, deposito 100000; 9 celle 3x3 su O1 x O2 | 0,810-0,836 / 654-880 / 12,73-17,05 (al centro 0,836 / 777 / 13,32) | 1,223-1,646 / 274-397 / 5,11-6,40 | `risultati_archivio/ROUND_CORTI_C2_2026-09-28/ROUND_R264d{1,2,3}/*_ohlc_*.csv`; lettura `report/LETTURA_ROUND_CORTI_C2_2026-09-28.md` | NO PER RISCHIO su questo storico (G0 ROSSO: OOS "non confrontabile", causa NON DIMOSTRATA; prova per regime dell'IS NON MISURATA) |
| XAUUSD H4, uscita | come sopra, asse `InpTP1Pct` 0/25/50/75 | PF 0,798/0,845/0,836/0,826, n 229/893/777/700 | PF 1,284/1,568/1,535/1,506 | `.../ROUND_R264d4/*_ohlc_R264d4.csv` | uscita ad asse: SI (parziale/BE/trailing regge, TP1Pct=0 peggiora) |
| XAUUSD H4 (base), 22 anni | 2004.06.11-2026.06.30, OHLC, rischio 1% | DD 55,02% (peggior giorno -2,36%) [EMA200 Ottimizzato 971501: 45,91%] | -- | `backtest_pipeline/risultati_archivio/R100_REFERTO.md` (tabella madre) | rischio a 22 anni ben oltre il muro; contratto 971501 "prop: NO a nessuna taglia" |
| EURUSD H4 solo SHORT | IS 2017-2023 / OOS 2024-2026, OHLC M1, deposito 100000, `InpSLatr` 1,0 / 1,25 / 1,5 | 1,076 / 1,047 / 1,106; DD 10,20 / 6,99 / 5,41; n 548 / 574 / 614 | 1,271 / 1,261 / 1,314; DD 5,24 / 4,41 / 2,84; n 235 / 233 / 239 | `risultati_archivio/ROUND_ORB_R271_2026-09-29/ROUND_R271/ABTG_EMA200_EURUSD_{IS,OOS}_ohlc_R271.csv` | NON CONCLUDENTE (H_EDGE e H_NIENTE entrambe non soddisfatte): stop 1,0 ATR escluso per costo 35-37x; a 1,5 ATR il costo passa (53-55x) ma OOS ~104 posizioni |
| GBPUSD / AUDJPY / GBPJPY / XAUUSD H4, G0 tick | 2024.01-2026.06, tick, deposito 10000, celle del genetico | -- (griglie IS SALTATE) | GBPUSD 1,199 / 408 / 8,53; AUDJPY 1,422 / 270 / 6,28; GBPJPY 1,224 / 242 / 4,12; XAUUSD 1,309 / 292 / 6,07 | `risultati_archivio/ROUND_CORTI_C_2026-09-28/ROUND_R264{a,b,c,d}/*_OOS_R264*.csv`; registro `REGISTRO_TEST.md` (radice) r.22-34 | G0 ROSSO 4/4: il banco NON rifa' l'archivio (PF -0,017..-0,091, n +5..+105), causa NON DIMOSTRATA; OOS non confrontabile |
| XAUUSD H4, manopole | tick/OHLC 2024-26 | -- | ADR filtro: PF 1,309 -> 1,559, DD 6,07 -> 4,63; chiusura venerdi': nulla | `.../ROUND_R267e2`, `.../ROUND_R267f{1,2}` | INDIZIO (banco rosso) |
| SPXUSD H4, periodo della media (R3) | 2024.09.26 -> 2026.06.30, IS/OOS, tick | EMA 150/175/200/225/250: PF 2,460 / 1,799 / 1,850 / 0,634 / 0,421; n 37/20/21/26/34 | 1,031 / 1,094 / 1,595 / 0,889 / 1,037; n 132/108/111/94/103 | `risultati_prove/ABTG_EMA200/ABTG_EMA200_SPXUSD_{IS,OOS}_r3.csv` | criterio scritto nel file prova ("promossa se 175 e 225 positive in ENTRAMBE le finestre"): NON soddisfatto (225: IS -140,26 / OOS -127,56). Verdetto scritto altrove: non trovato |
| EURUSD H1 L+S | 2024.09.26+, tick (R29a) | PF 0,99-1,22, n 311-433, DD 8,4-10,1 (30 celle) | PF 1,08-1,22, n 583-759, DD 9,1-12,0 | `risultati_prove/ABTG_EMA200/ABTG_EMA200_EURUSD_{IS,OOS}_r29a.csv` | 7/30 PASS pieni; bocciata a due lati |
| EURUSD H1 L / S, singola finestra | 2024.01.01-2026.06.30, tick, genetico | -- | L 34/34 in utile PFmed 1,270, DD 6,22-8,25; S 32/32 PFmed 1,106, DD 7,46-13,91 | `risultati_prove/risultati_valid_ABTG_EMA200_H1_realtick/valid_ABTG_EMA200_H1_realtick_EURUSD.csv` | NON ANCORA MISURATO (lato senza split IS/OOS); H1 escluso per costo 20,8x [DERIVATO da ATR M15 misurato] |
| XAUUSD H1 L+S (R32a) | 2024.09.26+, tick, 30 celle | PF 0,561-0,846, n 258-308, DD 9,3-15,3 | PF 0,843-1,110, n 345-387, DD 8,3-12,6 | `risultati_prove/ABTG_EMA200/ABTG_EMA200_XAUUSD_{IS,OOS}_r32a.csv` | IS in perdita in tutte le celle |
| 225JPY H1 L+S (R32b) | idem | PF 1,19-1,49, n 282-346, DD 6,9-9,5 | PF 0,70-0,85, n 451-578, DD 10,2-14,2 | `risultati_prove/ABTG_EMA200/ABTG_EMA200_225JPY_{IS,OOS}_r32b.csv` | segno ribaltato IS/OOS su 30 celle |

Non tutte le 47 righe H4 dell'archivio hanno un test di finestra lunga: solo AUDJPY, GBPUSD, XAUUSD, EURUSD (corto). Per gli altri 43 simboli il "PF alto a H4" e' una sola finestra di 2,5 anni.

### 2.4 D1: una cella di default, sei simboli

Fonte: `risultati_prove/ABTG_EMA200/ABTG_EMA200_<SIMBOLO>_{IS,OOS}[_ohlc].csv` (11 righe ciascuno: `InpTF` M15 M20 M30 H1 H2 H3 H4 H6 H8 H12 D1, cella di default `InpOrder1Atr` 0,10 / `InpOrder2Atr` 0,35 / `InpTP_RR` 2,0, L+S, rischio 1%; il file senza suffisso e' tick reale, con `_ohlc` e' Modello 1). Finestra esatta [NON VERIFICABILE: il CSV non la riporta e `prove/ABTG_EMA200.txt` non porta `@DAQUANDO`; default di casa 2024.09.26 -> 2026.06.30 con split 40/60 [INFERITO]].

| simbolo | D1 IS: PF / n | D1 OOS: PF / n | nota |
|---|---|---|---|
| 200AUD | n 0 (ohlc) | 0,49899 / 41 / DD 1,34 (ohlc) | -- |
| AUDJPY | 2,52499 / 16 (tick); 2,53923 / 16 (ohlc) | 335,62 / 12 (tick); 336,02 / 12 (ohlc) | PF 335 = 1-2 perdite su 12: artefatto, non un PF |
| GBPJPY | 0,90123 / 37 (tick); 0,92509 / 37 | n 0 | -- |
| GBPUSD | 1,50509 / 16 (tick); 1,51765 / 16 | 1,32513 / 41 (tick); 1,33854 / 41 | il piu' "pieno" |
| SPXUSD | n 0 | 0,92015 / 8 (tick); 0,91377 / 8 | -- |
| XAUUSD | n 0 | 1,26456 / 4 (tick); 1,25757 / 4 | -- |

Massimo 41 deal in una finestra; 7 celle su 22 hanno n = 0 (200AUD IS ohlc; GBPJPY OOS; SPXUSD IS; XAUUSD IS, questi tick e ohlc). **D1 non e' morto: e' non misurabile a questi n**, e mai su indici (Dow, DAX, Nasdaq mai a D1), mai per lato, mai con una griglia. Ipotesi non misurata sul perche' n = 0: la fascia `InpMinDistAtr`-`InpMaxDistAtr` (0,3-1,5 ATR) su un ATR giornaliero rende rari i segnali [IPOTESI: nessun log d'imbuto in archivio].

### 2.5 Il gradiente per TF che l'archivio ha GIA' (di PF, non di rimbalzo)

Stessi file di 2.4 (sei simboli: 200AUD, AUDJPY, GBPJPY, GBPUSD, SPXUSD, XAUUSD; 5 in tick perche' manca 200AUD; cella di default; solo celle con n >= 20; "pos" = profitto > 0). Ho ricalcolato io:

| TF | IS tick pos / PFmed | OOS tick pos / PFmed | IS ohlc pos / PFmed | OOS ohlc pos / PFmed |
|---|---|---|---|---|
| M15 | 0/5 · 0,739 | 0/5 · 0,653 | 0/6 · 0,778 | 1/6 · 0,810 |
| M20 | 0/5 · 0,667 | 0/5 · 0,664 | 0/6 · 0,775 | 0/6 · 0,816 |
| M30 | 0/5 · 0,760 | 1/5 · 0,923 | 1/6 · 0,846 | 2/6 · 0,936 |
| H1 | 0/5 · 0,705 | 1/5 · 0,826 | 2/6 · 0,822 | 1/6 · 0,917 |
| H2 | 1/5 · 0,746 | 3/5 · 1,018 | 3/6 · 1,057 | 3/6 · 1,037 |
| H3 | 1/5 · 0,743 | 2/5 · 0,995 | 1/6 · 0,630 | 3/6 · 0,998 |
| H4 | 4/5 · 1,382 | 3/5 · 1,018 | 4/6 · 1,255 | 5/6 · 1,343 |
| H6 | 3/4 · 1,356 | 3/5 · 1,062 | 3/5 · 1,253 | 3/6 · 1,073 |
| H8 | 2/5 · 0,887 | 3/5 · 1,306 | 1/4 · 0,877 | 4/6 · 1,349 |
| H12 | 3/3 · 2,000 (n ~ 20-50) | n/d (PF gonfiati: 335/350 su n 11-32) | 3/3 · 2,027 | 2/3 · 1,041 |
| D1 | 0/1 | 1/1 | 0/1 | 1/2 |

Lettura onesta: a M15-M30 la cella di default e' in utile in 1 cella tick su 30 (IS + OOS, 5 simboli x 2 finestre x 3 TF, n >= 20) e a H1 in 1 su 10; sopra H4 il campione collassa (n 8-50). La forma "sale col TF" c'e' fino a H4-H8 e non e' monotona (H3 cade: IS ohlc 0,630). E' un gradiente di PF con UNA cella per TF, sei simboli, una finestra corta; e' cio' che Claudio dice ("su M1/M5 non e' forte, sui TF alti si") solo per la parte bassa. **M1/M5: mai misurati** (valori di `InpTF` presenti in tutti i CSV EMA200 del repo: 15, 20, 30, 16385 (H1), 16386, 16387, 16388 (H4), 16390, 16392, 16396, 16408 (D1); nessun 1 ne' 5). Sulla sedia Dow: M15/M20/M30 tutti < 1 in OOS (0,954 / 0,833 / 0,907) e H1 1,524, H2 1,173, H3 0,908, H4 1,425 (`cemad05`): anche li' il gradiente non e' monotono.

### 2.6 Forward (demo 50503392) e stato in campo

`data/statements/trades_auto.csv` (statement fino al 29/09/2026 20:48), magic 771531 U30USD H1, [MISURATO da me]: 23 gambe/posizioni dal 2026.08.14 al 2026.09.22, netto -54,71; long 12 posizioni +3,18 (6 vinte); short 11 posizioni -57,89 (4 vinte); motivo di chiusura `sl` 23/23. Vinte 10/23 = 43,5% contro 156/257 = 60,7% del backtest OOS: con n = 23 e' dentro il rumore (Emendamento B: il campione sottile sospende il merito, non il rischio). Lo short ha PF OOS 1,89 nel backtest e 4 vinte su 11 dal vivo: non si conclude, si osserva.
Altre sedie EMA200 nello stesso file: 771501 D30EUR (6 gambe, net -77,31) e XAUUSD (3 gambe, net +24,80), 971501 XAUUSD (13 gambe, net +0,43); i cinque gemelli H4 771511-771515: **zero righe** nel file [MISURATO]. Secondo `CLAUDE.md` (sezione Guardian, 12/09) il binario in campo di 771531 e' `344a11b` del 04/08 (486 righe, senza `InpUsaGuardian`), non HEAD; se sia stato ricompilato dopo [NON VERIFICATO oggi]. Finche' e' cosi', il forward non misura HEAD.

---

## 3. IL CERTIFICATO DI MORTE, riga per riga

Regola (09/09): un candidato non e' MORTO se manca una fra: (1) PF, (2) n e DD, (3) gestione dell'uscita ad asse, (4) simboli gemelli, (5) TF cambiato. "Uscita ad asse" qui vale solo `InpTP1Pct`/`InpBreakeven`/`InpUseTrailing`/`InpTP1_ATRmult`/`InpSLatr`: `InpTP_RR` governa il 4,3% delle uscite (0% nel campo) e da solo NON chiude la casella 3 (`report/EMA200_I_DUE_REQUISITI_2026-09-12.md` sez. 7).

| candidato (simbolo TF lato) | (1) PF | (2) n, DD | (3) uscita ad asse | (4) gemelli | (5) TF | stato scritto | cosa MANCA |
|---|---|---|---|---|---|---|---|
| U30USD H1 L+S (771531) | SI tick | SI (IS 132 pos, OOS 257 pos, DD 7,83%) | SI (R136a-d) | SI (indici a H1: 0-1 celle su ~80; H4: SPX, D30, F40 OHLC) | SI (cemad05, R234a) | VIVO | prova di REGIME (LATI_A1/A2, 8 passate, ~3,02 min, scritte 09/09 e mai girate: `report/CENSIMENTO_CASELLE_VUOTE_2026-09-22.md`); IS in posizioni sotto 150; R146b/R147a/R208a scritti, CSV non in repo; binario in campo != HEAD |
| U30USD H1 solo S | SI | IS 125 deal, OOS 302, DD 2,66% | SI (per ereditarieta' solo sulla L+S) | SI | SI (R234a) | NON ANCORA MISURATO | n IS < 150; forward 4/11; uscita ad asse sul solo short |
| U30USD H1 solo L | SI | IS 112, OOS 241, DD 8,90% | idem | SI | SI | NON ANCORA MISURATO | n IS < 150 |
| U30USD H2-H4 L+S | SI | IS 26-127, OOS 116-266 | NO | SI | SI | NON ANCORA MISURATO | H2-H4 long-only e regime; frequenza (H4 21-41 pos) |
| U30USD M5-M30 | M15-M30 SI; M5 NO | M15-M30 SI | NO | -- | -- | ESCLUSO PER COSTO (20,0-32,0x; M5 11,5-13,1x < 13,3x duro) | M5 [NON MISURATO]; il costo da solo lo chiude, il PF a M15-M30 e' < 1 comunque |
| AUDJPY H4 L+S | SI | SI (R139a, DD 15-20%) | solo `InpTP_RR` | SI | SI (H1/H4, 11 TF) | MORTO per rischio (Emendamento B: un DD e' un fatto) | uscita: solo TP_RR (il DD 15-20% su 8 celle su 8 non dipende da quella manopola) |
| GBPUSD H4 L+S | SI | SI (R139b, DD IS 17,7-20,3) | solo `InpTP_RR` | SI | SI | FAIL rischio + regime | idem; lato SHORT da solo (tick 2024-26 32/32 in utile) mai testato su finestra lunga [NON MISURATO] |
| XAUUSD H4 L+S | SI | SI (R264d, R100) | SI (R264d4: TP1Pct) | SI | SI (R32a H1; sweep 11 TF) | NO PER RISCHIO su questo storico (certificato completo) | prova di regime dell'IS; G0 col binario `0953846c`; TP_RR/SLatr sul 2017-23 |
| EURUSD H4 solo S | SI | SI (R271) | `InpSLatr` (R271) | SI | SI | NON ANCORA MISURATO, indizio debole | lato L (mai misurato con split); H1 (costo 20,8x); OOS < 150 pos |
| SPXUSD H4 L / L+S | SI (OHLC + tick 116 deal) | SI, ma n = 21-74 pos | solo TP_RR | SI | SI | NON ANCORA MISURATO | finestra lunga (EXT 2010-2018 esiste e sta in frigo); n |
| 200AUD, GBPJPY, USDNOK, 225JPY, D30EUR, F40EUR, 100GBP, CADJPY, EURJPY H4 | SI (OHLC 2,5 anni) | screening | solo TP_RR | SI | SI | NON ANCORA MISURATO | finestra lunga, tick, uscita; GBPJPY G0 ROSSO in R264c (griglia saltata) |
| E50EUR H1+H4 | SI OHLC | SI | solo TP_RR | SI | SI | scartato nel REGISTRO 12/09 (0/88 e 0/81 celle, best PF 0,74 / 0,95) | per il certificato del 09/09 manca l'uscita ad asse e un test a tick |
| NASUSD H1 | SI OHLC | SI | solo TP_RR | SI | SI | scartato a H1 (1/85, best 1,02) | **NASUSD H4: file non esiste, NON MISURATO** |
| XAUUSD H1 (R32a), 225JPY H1 (R32b), EURUSD H1 L+S (R29a) | SI | SI | solo TP_RR | SI | SI | bocciate (R32a IS in perdita; R32b segno ribaltato; R29a 7/30) | EURUSD H1 lato per lato con split IS/OOS |
| D1 (6 simboli) | una cella | n 0-41 | NO | 6 simboli | SI | NON MISURABILE | tutto: indici, lati, griglia, campione |
| M1, M5 (qualsiasi simbolo) | NO | NO | NO | NO | -- | NON MISURATO | tutto (Dow M5: escluso per costo) |

---

## 4. LE CASELLE VUOTE (elenco per nome)

Per TF e simbolo:
- **D1**: mai sugli indici; mai un lato solo; mai una griglia; una cella di default su 6 simboli con n 0-41 (sez. 2.4).
- **M1 e M5**: mai (il TF piu' basso e' M15). Per l'EMA200 sul Dow M5 e' escluso per costo con il numero (11,5-13,1x); sugli altri simboli il costo a M5 e' [NON MISURATO].
- **H2, H3, H6, H8, H12**: solo la cella di default su 5-6 simboli (sez. 2.5) e, sulla sedia Dow, H2/H3/H4 in L+S e in S; il **long-only a H2-H4 sul Dow** non esiste.
- **NASUSD a H4**: il file non esiste.
- **Lato**: le validazioni a tick a H4 non hanno split IS/OOS per lato; EURUSD H1 L e S non hanno split; GBPUSD H4 corto non ha finestra lunga; EURUSD H4 lungo mai con split.
- **Finestre lunghe a H4**: 43 simboli su 47 hanno solo la finestra 2024-2026.
- **Regime**: LATI_A1/A2 sulla sedia (`prove/LATI_A1_..._DISCESA_{long,short}.txt`, `LATI_A2_..._TORO_{long,short}.txt`): scritti, gated, mai girati.
- **Round scritti senza CSV in repo**: R208a (`InpTP_RR` su 771531, 5 celle), R146b (`InpFridayClose`), R147a (`InpBreakeven`), R140a (EURUSD H4 L+S 2010-2026), R221a-c (`InpTP_RR`, due lati, GBPUSD/AUDJPY/XAUUSD), R190a (`taglio050`, EMA200 short U30USD; riga `RIGA_R190A` esistente), R234a-c (numeri solo dal referto).
- **Manopole mai ad asse in nessuno dei CSV EMA200 del repo** (ho letto tutte le righe di tutti i CSV con `InpEmaPeriod`): `InpMinDistAtr` = 0,3; `InpMaxDistAtr` = 1,5; `InpUseEma14Bias` = 1; `InpUseOrder2` = 1; `InpPendingExpiryBars` = 6; `InpBreakeven` = 1; `InpEma14Period` = 14; `InpAtrPeriod` = 14; `InpUseCutoff` = 0; `InpMaxSpread` = 0; `InpUseNewsFilter` = 0; `InpMinRR` = 1; `InpMaxTradesPerDay` = 0. `InpEmaPeriod` ad asse solo in R3 (SPXUSD H4). `InpUseAdrFilter` 0/1 solo in R267e (GBPJPY, XAUUSD). `InpFridayClose` 0/1 solo in R267f. Sono esattamente le manopole che DEFINISCONO il rimbalzo dell'EA (quanto vicino, quanto lontano, quale conferma, quante gambe, quanto attendere). Disciplina del 19/08: si allargano solo dove c'e' un motore vivo (Dow H1) e ogni cella si paga con una prova fuori campione o di regime; NON sui simboli H4 gia' morti per rischio.
- **Dati necessari per una misura descrittiva** (sez. 5.5): indici solo dal 2024.09.26 su BCM; DAX e SPX esterni 2010-2018; Dow esterno non esiste.

---

## 5. LE IPOTESI DI CLAUDIO E DELLA COLLEGA: esiste una misura? NO. Disegno proposto.

### 5.1 Ricerche fatte (per non dire "non esiste" a occhio)
`grep` sul repo (`.md` e `.py`, esclusi i worktree) su "rimbalz", "ritest|retest", "tocca la media|first touch|primo tocco", e ispezione di `backtest_pipeline/*.py` (nessuno script calcola tocchi/rimbalzi della EMA200). Trovato di vicino e NON equivalente:
- `backtest_pipeline/caccia_strategie/ANALISI_CORSO_FIBOH4_MEDIA200_2026-08-18.md` e `backtest_pipeline/prove/MEDIA200_CORSO_SPEC.md`: analisi del corso del rimbalzo EMA200. Dicono che "gli istituzionali mettono i soldi sulla media a 200" e' affermato cinque volte e MAI misurato (sez. 1); la lezione 25 si dichiara "statisticamente provata" senza numeri (n. operazioni, win rate, DD, periodo: "MAI, nemmeno una volta, in 45.944 caratteri") e in 5 lezioni non mostra un solo esempio perdente (sez. 9); la meccanizzabilita' del rimbalzo e' 48% (16 su 33 regole). Contiene anche la lezione 25 (break-in/break-out con retest, "segno opposto al rimbalzo") come "EA che non abbiamo": e' la sorgente di H2 nel corso. Nessuno l'ha mai misurata.
- `report/ANALISI_LIVE_EMILIANO_2026-04-10.md` r.357: il trader classifica i suoi casi A/B/C (rimbalza / sorpassa / rompe): e' selezione discrezionale, non una frequenza.
- Il numero 69,6% della sez. 1 (uscite dell'EA): e' un rapporto di uscite di un motore, non una probabilita' di rimbalzo (motivi in sez. 1).
- Nessuna dashboard con TF selezionabili e' in repo [NON VERIFICABILE].
Verdetto: H1, H2, H3 sono **caselle vuote**.

### 5.2 Le trappole della testimonianza (scritte PRIMA di qualunque numero)
La collega e' testimonianza di terzi: ipotesi, non dato, non criterio.
1. **Selezione a occhio**: un trader discrezionale ricorda/sceglie i casi dove "ha funzionato"; i tocchi ignorati o i trade non presi non entrano nel suo campione. La misura prende TUTTI gli eventi che soddisfano la definizione, meccanicamente.
2. **Payoff asimmetrico**: "quasi sempre profitto" e' compatibile con perdite rare e grandi (sez. 6). Si misura la frequenza E il payoff, mai la sola frequenza.
3. **Definizioni non dichiarate**: "tocco", "rimbalzo", "sfondamento", "ritest", "profitto" senza numero = non falsificabile. Sono congelate in 5.3 prima dei dati.
4. **Il random walk fa gia' la stessa cosa** (5.3): una probabilita' alta non e' un edge se la soglia scelta la produce da sola.
5. **Deriva e regime**: nei mercati che salgono i "rimbalzi long" vincono comunque (sez. 2.2); la misura tiene separati i lati e le finestre di regime.
6. **Look-ahead nella classificazione**: "sfondamento vero" si sa solo dopo; si dichiara come e' definito ex post e non si usa per entrare.
7. **Feed / orologio**: barre H4/D1 costruite da M1 dipendono dal fuso del broker e dell'esterno (BCM forex: cambio d'orologio fra 26/12/2024 e 02/02/2025; HistData esterni con shift +5, `LO_STORICO_ESTERNO_MAPPA_2026-09-23.md`). Risultato con feed cambiato = quattro cambi di segno in R80 (`report/LO_STORICO_ESTERNO_MAPPA_2026-09-23.md` sez. 5).

### 5.3 Definizioni e soglie CONGELATE (da confermare con Claudio prima dei dati)
Strumento proposto (NON scritto qui): `backtest_pipeline/misura_rimbalzo_ema200.py`, stile `anatomia_movimenti_m5.py` (legge M1, costruisce le barre, conta, non calcola PF/equity, nessuna promozione), referti in `backtest_pipeline/risultati_archivio/MISURA_RIMBALZO_EMA200_<data>/`.

**Barre e livello.** Barre del TF T costruite da M1 con ancoraggio dichiarato (H4: bordi UTC 00/04/08...; D1: bordo unico per classe di strumento, dichiarato per simbolo). EMA200 sul close di T (seme = primo close; si scartano le prime 600 barre). ATR(14) = media semplice del true range (come `iATR` di MT5, che l'EA usa). **Livello L = EMA200 alla chiusura della barra di approccio, CONGELATO** (e' quello a cui l'EA lascia il limit); lettura secondaria con livello mobile.
**Episodio (approccio).** Barra k che chiude con `0,3 <= |close - L| / ATR <= 1,5` (la fascia dell'EA), con EMA14 dallo stesso lato (come l'EA). Sopra L = episodio "long", sotto = "short". Episodi NON sovrapposti: il successivo puo' nascere solo dopo che il precedente si e' risolto. Lati SEMPRE separati (regola dei due lati). Lettura secondaria: fascia 0,3-3 ATR, senza filtro EMA14.
**Tocco (T0, primario).** Primo M1, entro `H = 6` barre di T (la finestra di riempimento dell'EA, `InpPendingExpiryBars`), in cui il prezzo raggiunge L. Varianti: T1 = L +/- 0,10 ATR (1o ordine dell'EA), T2 = L oltre di 0,35 ATR (2o ordine). Si riporta anche P(tocco entro H) = tasso di riempimento del limit.
**H1 (rimbalzo).** Dal primo tocco, primo evento fra: **B** = il prezzo si allontana di X ATR dal lato dell'approccio; **P** = penetra di Y ATR oltre L; **T** = nessuno dei due entro 12 barre; **A** = B e P nello stesso M1 (ambigua, riportata a parte). Cella PRIMARIA congelata: **X = 1,0, Y = 1,0** (simmetrica: null analitico 0,50). Celle descrittive (nessuna e' "la migliore"): X in {0,25; 0,5; 1,0} x Y in {0,5; 1,0; 1,35} (1,35 = dove sta lo stop dell'EA: 0,35 + 1,0 ATR). Si riportano B, P, T, A: mai si scartano i timeout.
**H2 (sfondamento e ritest).** Sfondamento = **chiusura** di barra oltre L di almeno b ATR (b primario 0,5; varianti 0,25 e 1,0; variante "due chiusure"). Dopo lo sfondamento, primo evento entro R = 20 barre: **RT** = il prezzo torna a L (+/- tol 0,10 ATR verso L); **RA** = si allontana di Z ATR oltre L (Z primario 1,5; varianti 1,0 e 2,0) senza tornare; **FB** = chiude di nuovo dal lato di partenza di almeno b ATR (falso sfondamento); **T** = timeout. Sfondamento "vero" = RA prima di FB (ex post, dichiarato); "esce senza ritest" = RA senza aver toccato L+tol; si riporta P(RT prima di RA), P(RA senza ritest | vero), P(FB).
**H3 (gradiente).** Stesso protocollo a M5 (riferimento), M15, H1, H4, D1 per simbolo. Statistiche: per simbolo, P_B(X=Y=1,0) e P_RT(b=0,5, Z=1,5) per TF; rango di Spearman TF-vs-P per simbolo e in aggregato per classe.

**Null e contro-esempi PRIMA dei numeri.**
- Null analitico, random walk continuo senza drift: H1 P(B) = Y/(X+Y). Con (X,Y): (1,0; 1,0) = 0,500; (0,5; 1,0) = 0,667; (0,25; 1,0) = 0,800; (0,25; 1,35) = 0,844; (1,0; 1,35) = 0,574 [DERIVATO]. H2: P(RT prima di RA) = (Z - b) / ((Z - b) + (b - tol)); con (b, tol, Z) = (0,5; 0,10; 1,5) = **0,714**; (0,25; 0,10; 1,0) = 0,833; (1,0; 0,10; 2,0) = 0,526 [DERIVATO]. Quindi "viene ritestata quasi sempre" e' gia' vero (~0,71-0,83) in una passeggiata casuale con queste soglie; l'ipotesi H2 non ha contenuto se non batte QUESTO. (Nota: i null sono calcolati con partenza esattamente a L per H1 e a b oltre L per H2; una chiusura di sfondamento piu' lontana da L da' P(RT) piu' bassa, quindi il null di H2 e' un limite ALTO: il confronto vero si fa sulla distribuzione reale delle partenze, cosa che i surrogati fanno da soli.)
- Null empirico (surrogati): le stesse serie con i rendimenti giornalieri rimescolati a blocchi (preserva media/deriva, volatilita' e forma intraday; rompe la relazione prezzo-EMA200), ricalcolando EMA, ATR e protocollo su ogni surrogato; N = 200 (N = 50 per la prima passata a M5/M15). Il valore reale conta come effetto solo se sta oltre il 95o percentile dei surrogati. Il surrogato tiene la deriva DENTRO il null: quello che resta e' struttura temporale attorno alla EMA200, non "il mercato sale".
- Placebo di livello: stesso protocollo con EMA100, 150, 250, 300 (e SMA200). Se 150/250 fanno lo stesso, "la 200" non e' speciale (R3 su SPXUSD H4 suggerisce che in IS non lo e': 150 fa meglio e 175 e' pari, sez. 2.3).
- Cancello di riproduzione (G0): sulla sedia Dow, con la definizione "come l'EA" (fill entro 6 barre, primo bersaglio EMA14, Y = stop a ~1,3 ATR) e stessa finestra (BCM M1 2025.06.10 -> 2026.06.30), lo strumento deve dare una quota di "primo bersaglio prima dello stop" nell'ordine di 0,70 (attesa: 0,696 +/- 0,08 per la differenza fra livello di posizioni e di segnali). Se non ci arriva, o lo strumento o la definizione sono sbagliati e nessun altro numero vale.
- Autotest dello strumento (in stile `anatomia_movimenti_m5.py`): (i) random walk sintetico con drift -> P entro +/-0,03 dal null analitico; (ii) serie con rimbalzo PIANTATO sulla EMA (ritorno alla media) -> P(B) >= 0,85 rilevato; (iii) serie con rottura PIANTATA senza ritest -> P(RT) < 0,20 rilevato; (iv) feed spostato di 1 ora a H4/D1 -> il risultato DEVE cambiare (se resta identico alla terza cifra lo strumento e' cieco al fuso: e' il difetto che il 10/09 aveva `finestra_dax.py` v1); (v) mutazioni (tolleranza di tocco 0 -> 0,5 ATR, ATR di un altro periodo, livello mobile invece che congelato) -> il numero deve muoversi.

**Attese dichiarate (scritte ora, con il perche').**
- A1: per FOREX/ORO a H4 e D1, cella primaria, l'effetto (reale - max(null analitico, p95 dei surrogati)) e' <= +0,05 su tutto. Perche': la stessa famiglia di celle a H4 vive solo dove c'e' deriva (sez. 2.2), e a finestra lunga muore (sez. 2.3).
- A2: H2 primario (0,5; 0,10; 1,5): P(RT prima di RA) tra 0,65 e 0,80, cioe' vicino al null 0,714. Se cade fuori da questa banda in una direzione, la collega ha visto qualcosa.
- A3: gradiente per TF (H3): il PF sale col TF fino a H4-H8 e questo si vede in sez. 2.5; ATTESA sulla frequenza di rimbalzo normalizzata in ATR: quasi piatta (differenza fra M15 e H4 entro +/-0,04 dal null), perche' un random walk normalizzato in ATR e' invariante di scala; le differenze tra TF, se esistono, vengono da micro-struttura (spread, rumore di tick) e non da "la EMA200 pesa di piu'". Se invece viene fuori un gradiente pulito e assente nei surrogati, e' un risultato vero.
- A4: G0 (Dow H1, definizione "come l'EA") a 0,70 +/- 0,08.

**Soglie congelate (H1, H2, H3): cosa conferma e cosa falsifica.**
- "Quasi sempre" (parola della collega) = P(B) >= 0,75 con estremo basso dell'intervallo al 95% >= 0,70, in cella con n >= 150 episodi per lato e finestra. Non e' una parola mia: e' una soglia mia che Claudio puo' cambiare PRIMA dei numeri.
- **Effetto di rimbalzo (H1) CONFERMATO** se, sulla cella primaria: (a) P(B) - max(0,500; p95 surrogati) >= +0,05 con estremo basso dell'IC > 0; (b) segno concorde in almeno 3 finestre di regime su 4 (toro/orso/laterale/crollo: le quattro di R50-R56-R59, Emendamento C; date da rileggere in R59, non riportate qui); (c) confermato sulla cassaforte (finestra piu' recente) con le soglie congelate in addestramento. **FALSIFICATO** se P(B) sta dentro +/-0,03 del null (analitico o surrogato) o se l'effetto compare in una sola finestra di regime.
- **H2 CONFERMATO** se P(RT prima di RA) supera il null (0,714 sul primario) di >= 0,05 con IC che esclude il null e esistono >= 150 sfondamenti "veri" per cella; FALSIFICATO se dentro +/-0,03 dal null. Si riporta anche quanti sfondamenti veri escono senza ritest (P(RA senza ritest | vero)): se il null da' ~0,29 e la misura ~0,29, la frase "difficilissima da superare senza ritest" non aggiunge informazione.
- **H3 (gradiente col TF) FALSIFICATO** se: (F1) non monotono: fra i cinque TF c'e' un'inversione fra TF adiacenti piu' larga della semi-ampiezza del suo IC, in piu' della meta' dei simboli; (F2) la differenza fra TF adiacenti e' dentro il rumore (|delta P| < 0,03 o IC sovrapposti); (F3) presente in una sola classe (forex / indici / metalli) o in una sola finestra di regime; (F4) presente anche nei surrogati (artefatto di geometria/tick). Confermato solo se nessuna delle quattro scatta.
- Il campione: cella con < 150 episodi per lato nella finestra = merito SOSPESO (Emendamento A); il rischio si legge a qualunque n. I 150 sono EPISODI, non deal.

### 5.4 Dati, addestramento/cassaforte, regimi
- Unita' = episodi, non anni (Emendamento A). Addestramento = la finestra piu' vecchia che da >= 150 episodi per cella primaria; cassaforte = il resto, aperta una sola volta, DOPO aver congelato soglie e definizioni. Le ipotesi si scrivono solo sull'addestramento. Si dichiara quale regime contiene ciascuna.
- Forex e oro: barre operative dal 1999 su BCM (R102: GBPUSD prima operazione 1999.01.14) e oro dal 2004.06.11 (22,1 anni) [`report/LO_STORICO_ESTERNO_MAPPA_2026-09-23.md`]; forex esterno HistData 2018-2024 (shift +5, confrontabile a 0,004-0,011% di differenza media). Il DAX esterno (2010-2018, 1.718.805 barre M1) e lo SPX (mirror 2010-2018) esistono; NASUSD_EXT e' importato e promosso; **Dow esterno non esiste**; **indici BCM solo dal 2024.09.26**.
- Conseguenza sul D1: la EMA200 a D1 ha bisogno di 200 giorni di riscaldamento (~9,5 mesi di 21): sugli indici BCM restano ~11 mesi, cioe' poche decine di episodi al massimo. D1 sugli indici e' misurabile SOLO su DAX/SPX/NASUSD esterni; sul Dow non e' misurabile. Stima degli episodi per simbolo/anno: dal n dei deal della cella D1 di default (4-41 in ~1 anno, sez. 2.4) e dal rapporto deal/posizione 1,8-2,0, ~2-20 posizioni/anno [DERIVATO, ordine di grandezza]: forex/oro con 22-27 anni arrivano a 50-500 episodi per cella, gli indici no.
- Feed: mai mescolare BCM ed EXT nella stessa cella (R80: cambia solo il feed e cambia il segno quattro volte). Si misura su un feed per volta e si confronta cella-per-cella.
- Fuso: H4/D1 costruiti da M1 nello stesso ancoraggio per tutta la serie; su BCM forex l'orologio cambia fra 26/12/2024 e 02/02/2025 (`CLAUDE.md`, fuso): o si taglia la serie li' o si ricostruisce in UTC.

### 5.5 Costo (frontiera stop >= 40 x spread) e M1/M5
La misura descrittiva NON usa il costo; serve per dire se un P alto si puo' convertire in R. La frontiera del costo sta accanto a ogni TF:
- Dow: M5 11,5-13,1x -> ESCLUSO PER COSTO (sotto il duro 13,3x); M15 20,0-22,6x, M20 23,1-26,1x, M30 28,3-32,0x -> ESCLUSI; H1 33,6-45,2x -> FRAGILE (la soglia 40x cade nella banda); H2 56,6-64,0x, H3 69,3-78,3x, H4 80,0-90,5x -> passano il costo ma a H4 n = 21-41 pos.
- EURUSD H4: stop 1,0 ATR = 35,3-36,8x (< 40x, escluso), 1,25 ATR = 44-46x, 1,5 ATR = 53-55x (R271; pedaggio all-in 0,6636 pip nel round R265); EURUSD H1: 20,8x (escluso) [DERIVATO].
- XAUUSD H4: soglia 10,41 USD = 40 x 0,2603; stop gamba 2 mediano 12,33-15,42 USD -> ~47-59x [DERIVATO da K1 di R264d]: PASSA.
- D1: non misurato; per la legge di scala dichiarata l'ATR sale di ~sqrt(24)=4,9 rispetto a H1, quindi il costo non e' il vincolo a D1, e' il campione.
- Per M1/M5 il numero da scrivere accanto e' il rapporto (ATR x moltiplicatore) / spread di sessione, con `calcola_pedaggio_forex.py` per il forex e lo spread orario misurato per gli indici (`risultati_archivio/spread_flotta/spread_orario_<SIMBOLO>.csv`). Sul Dow M5 e' gia' scritto (sopra). Sugli altri simboli [NON MISURATO]: non si esclude "perche' e' basso", si scrive il numero.
- Il progetto preferisce i TF bassi ("piu' operazioni = campione prima"): sulla EMA200 il TF basso costa (sopra) e il PF di M15-M30 e' > 1 in 1 cella tick su 30 (sez. 2.5). I TF bassi si INCLUDONO nella misura descrittiva (H3) senza aspettarsi che siano tradabili.

### 5.6 Costo in tempo macchina
- Passate di Strategy Tester: **0**. Nessun round, nessuna coda, nessun VPS; puo' girare sul PC di backtest o su qualunque macchina con Python (i round non girano sul VPS finche' la challenge e' viva).
- Tempo di calcolo: [NON MISURATO]. Riferimento di ordine di grandezza dello strumento gemello: `anatomia_movimenti_m5.py` ha letto 5.233.590 barre M1 (NASUSD, 4.071 giorni) in una corsa il cui tempo il log non riporta [NON MISURATO]. I surrogati moltiplicano per N. Proposta: prima passata SENZA surrogati su 12 simboli (4 forex, 4 indici, 3 metalli, petrolio) per verificare autotest e G0; poi i surrogati N = 50; poi N = 200 solo sulle celle che li meritano.
- Da fare prima: esportare M1 BCM dei simboli scelti sul PC di backtest (script gia' in repo: `mql5/Scripts/ABTG_HistoryDownloader.mq5`; export a CSV: [da scrivere o riusare, NON verificato]).

### 5.7 Che cosa chiedo a Claudio (un buco che puo' chiudere lui)
1. Confermare o cambiare PRIMA dei numeri: X e Y della cella primaria (1,0 / 1,0), b/tol/Z di H2 (0,5 / 0,10 / 1,5), la soglia "quasi sempre" (0,75), i 4 regimi.
2. Sentire dalla collega la SUA definizione di tocco, sfondamento e "profitto" (su quale TF, con quale distanza, con quale gestione): la misura misura la SUA definizione se e' numerica, non la mia.
3. Quali simboli e TF sono nella "dashboard": non e' in repo.

---

## 6. IL NODO "POCHI PUNTI" (TP piccolo, SL largo)

Aritmetica (senza dati, [DERIVATO]): con TP = k R, perdita 1 R, costo c per operazione, la vincita che serve per pareggiare e' `p* = (1 + c) / (1 + k)`. Con c ~ 0,03 R (dal rapporto misurato stop/spread Dow H1 33,6-45,2x: c = 1/45,2..1/33,6 = 0,022-0,030; e' solo lo spread, il resto e' a parte): k = 2 -> 0,34; k = 1 -> 0,52; k = 0,5 -> 0,69; k = 0,25 -> 0,82; k = 0,10 -> 0,94. **Un TP a un quarto dello stop chiede >= 82% di vincite solo per non perdere.** E la trappola e' quella del profilo "win rate alto, perdite grandi": un evento su otto o dieci che rovina l'equity. A titolo di riferimento di casa (non un dato EMA200): il profilo dichiarato da Claudio per `Bulge` e' win rate 80,22%, perdita media 2,47 volte la vincita media (`report/R92b_CRITERI.md` par. E6), con criterio S3 "win rate >= 65% e profitto > 0"; a k = 1/2,47 il pareggio e' p* = 0,71 [DERIVATO], quindi il margine e' di ~9 punti di vincita.

Che cosa dicono i dati di casa:
- **DAX Apertura (770101)**, `InpTP1_R` (primo bersaglio del parziale, ma anche `TpTotalR = InpTP1_R x 3`, r.2081-2087, quindi muove anche il TP finale) da 0,25 a 1,00 R: IS PF 1,094 / 1,059 / 1,112 / 1,127, OOS 1,364 / 1,242 / 1,299 / 1,395, DD IS 4,05 / 6,06 / 5,32 / 5,41, DD OOS 4,85 / 7,76 / 7,57 / 7,25, n OOS 339 / 306 / 289 / 270 (`backtest_pipeline/risultati_prove/R202B/ABTG_DAX_Apertura_EU_D30EUR_{IS,OOS}_R202B.csv`). La frequenza con cui il bersaglio scatta sale (sull'altra sedia: 65-69% a 0,5 R sul Nasdaq R199B contro 28-35% a 1,0 R sul Dow R46b, header di `prove/R202b_obiettivo_DAX_D30EUR.txt`; sul DAX la quota non e' riportata [NON MISURATO]), il PF NON sale: il massimo e' a 1,00 R in entrambe le finestre. Decisione di casa del 22/09: la sedia resta a 1,0; la 0,25 e' sotto la frontiera del costo con due stime indipendenti (8,1x e 10,6x contro il duro 13,3x) (`report/NOTTE_2026-09-22.md`). Il DD piu' basso della 0,25 e' in due finestre e ha un meccanismo (il pareggio a TP1 tronca la coda), non e' rumore.
- **EMA200 Dow H1**, primo bersaglio (R136b `InpTP1_ATRmult`, 0 = EMA14): 0,25 ATR: IS 0,994 / OOS 1,590, DD IS 3,08 / OOS 2,10, n 252 / 495; 0,50: IS 1,014 / OOS 1,409; 0,75: IS 0,900 / OOS 1,436; 1,0: IS 0,869 / OOS 1,549; il default (EMA14) IS 1,201 / OOS 1,524. Registro: "altopiano 0,25-0,75, centro 0,50 NON batte il default"; il DD scende con il bersaglio vicino, il PF in IS no (`backtest_pipeline/REGISTRO_TEST.md` riga r136b).
- **`InpTP_RR` (TP finale)**: mediana del PF per cella con n >= 20, non isolata dalle altre manopole: XAUUSD H4 1,22 / 1,30 / 1,40 / 1,50 per TP_RR 1,5 / 2,0 / 2,5 / 3,0; SPXUSD H4 1,37 / 1,46 / 1,50 / 1,31; AUDJPY H4 1,56 / 1,31 / 1,46 / 1,40; U30USD H1 1,42 / 1,46 / 1,37 / 1,47; AUDJPY H4 (R264b1, 4 celle, stessa O1/O2): 1,483 / 1,426 / 1,440 / 1,443 (`risultati_archivio/ROUND_CORTI_C_2026-09-28/ROUND_R264b1/`). Il TP finale piu' vicino NON migliora il PF; su H1 e su AUDJPY e' quasi inerte, su XAUUSD H4 sale con il TP piu' lontano. `InpTP_RR` governa il 4,3% delle uscite Dow.
- **Parziale/BE/trailing (la parte "pochi punti" dell'EA)**: e' gia' dentro (50% sulla EMA14 + pareggio): il Dow senza parziale fa PF OOS 1,281 / DD 13,94% contro 1,524 / 7,83% (R136c), XAUUSD H4 a `InpTP1Pct` 0 fa il peggior PF e il peggior DD (R264d4). Cioe' "chiudere qualcosa presto e mettere lo stop in pari" e' la variante che i dati sostengono; "TP piccolo per tutto" no.
- **Costo**: la frontiera `stop >= 40 x spread` sta sullo STOP, ma un TP piccolo peggiora il rapporto guadagno/spread: DAX 0,25 R = 8,1-10,6x sotto il duro. Sul Dow H1 la distanza del primo bersaglio (EMA14) non e' misurata [NON MISURATO]: il "pochi punti" dell'EA non ha ancora un numero.

---

## 7. IL NODO "AUMENTARE I LOTTI" (Claudio decide le taglie; qui solo cosa esiste)

- **Non propongo nessuna taglia.** Rischio e lotti sono di Claudio.
- Cosa esiste nel repo: (a) `backtest_pipeline/risultati_archivio/ANALISI_DIAL_TAGLIE_2026-08-26.md`: analisi di flotta (35 sedie, 481 giorni) su "quanto si puo' alzare la manopola" con scala lineare, avvertenze dichiarate (lo scaling lineare e' un'approssimazione ottimista: il lotto sbatte su `SYMBOL_VOLUME_MAX` e pavimenti, lo slippage cresce con la taglia): nasce dalla richiesta di Claudio del 26/08 "aumentare i lotti confidando nel Guardian". E' un'analisi del lotto UNIFORME sulla flotta, NON sull'EMA200. (b) `report/MISURA_LOTTI_U30USD_2026-09-19.md` e `mql5/Experts/ABTG_MIS_SIZING_EMA200.mq5`: misurano il DELTA di lotti fra due binari (calcolo del lotto), non lo scalare. (c) Sul motore: nessuna misura di piramidare dopo una vincita o di scalare dopo una perdita.
- Distinzioni, come le scrive la casa (`report/METRO_PROP.md` sez. 13, **BOZZA da firmare**, non congelata):
  - **Lotto maggiore UNIFORME** = piu' rischio per operazione, stessa struttura: cambia il DD in modo (approssimativamente) lineare (es. DD 4,35% a 0,65% -> 13,38% a 2,00% sulla `770101`, misurato 14,14%: `report/IL_DD_DELLA_SEDIA_VIVA_2026-09-24.md`); e' una firma di taglia. L'EA da' gia' rischio TOTALE fisso ripartito su due gambe (r.361).
  - **Il secondo ordine "piu' grande"**: l'EA lo fa gia' a rischio uguale per gamba: sull'oro H4 la gamba 2 ha volume mediano 1,750 volte quello della gamba 1 (K1 di R264d, attesa 1,7); sul Dow il rapporto non e' riportato in questi file [NON MISURATO] e stop unico [MISURATO]. Test T1-T5 del METRO_PROP (stop depositato: SI; numero massimo di ingressi costante: SI, 2; perdita massima nota prima: SI; si riarma sulle perdite precedenti: NO; size cresce verso lo stop: SI, 1,7-1,75x) => "averaging a cap fisso con stop unico", misurabile alle condizioni G1-G6 della bozza (non lette qui). Il corso lo motiva psicologicamente ("mindset") e non e' martingala (MEDIA200_CORSO_SPEC sez. 5).
  - **Aumentare i lotti DOPO una perdita = martingala/recovery = bandiera rossa, scarto a vista** (T4 = SI): precedente `Mean_Reversion` scartato il 16/08 su `LotExponent 1,44` + `Max_Trades 10`.
  - **Piramidare dopo una vincita** (anti-martingala): non e' scartato dalla regola, ma non esiste misura in casa e non e' un'ottimizzazione dell'EMA200: sarebbe un EA/uscita nuova, con proprio certificato.

---

## 8. BUCHI DICHIARATI (riassunto)

- H1, H2, H3: nessuna misura; disegno in sez. 5, attese e soglie da confermare.
- M1/M5: mai su EMA200; D1: una cella su 6 simboli.
- Le finestre esatte degli scan H1/H4 e del sweep 11 TF non sono nel CSV.
- R234a-c, R208a, R146b, R147a, R140a, R221a-c, R190a: scritti, senza CSV in repo.
- Forward: n 23, binario in campo non HEAD.
- Il verdetto scritto del test del periodo della media (R3) non l'ho trovato.
- Tempo macchina della misura descrittiva: [NON MISURATO].

## 9. COSA E' STATO CONTROLLATO PRIMA DI CONSEGNARE (lo Sviluppatore contro l'Agente dei Controlli)
- I conteggi celle/simbolo delle tabelle coincidono con quelli scritti da una sessione indipendente (elencati in 2.2): non e' un controllo circolare.
- Il mio "PF mediano per TF" e' stato ricalcolato dai CSV, non copiato; i PF 335/350 sono segnalati come artefatti (n 11-32).
- Il null analitico (H1, H2) l'ho verificato a mano con la formula di rovina del giocatore; il contro-esempio e' esplicito: H2 a soglie ragionevoli fa 0,71-0,83 anche senza EMA200.
- Numeri che NON ho potuto ricontrollare alla fonte e ho riportato dal referto che li cita: R234a-c (CSV assenti), K1 di R264d (`report/LETTURA_ROUND_CORTI_C2_2026-09-28.md`), R100 (`R100_REFERTO.md`, CSV assenti), 21/09 costo frontiera Dow (`report/EMA200_I_DUE_REQUISITI_2026-09-12.md`).
- Nessun criterio e' stato abbassato; nessun candidato e' stato archiviato o promosso.
