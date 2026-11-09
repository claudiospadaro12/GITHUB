# D160 oro: risultati (09/11/2026) -- 24 passate a deposito 160.000 EUR contro le passate a 80.000 EUR

**Natura: MISURA, parziale.** Sono arrivate solo le componenti oro (riga `RIGA_LANCIA_D160_ORO`): 15 celle (5 componenti x 3 anni). Mancano Gold Trade Pro Combo e Daytrade Pro Max9 (6 celle, righe pronte `BOOT_RIGA_D160_GTP/DTP`). Criteri e previsioni: `CRITERI_D160_2026-11-08.md` (con revisione 09/11). Dati: `D160_dati/` (`parse_d160.py`, `analisi_d160.py`, `d160_oro.json`, `d160_celle.json`). Solo tester, Modello 1, nessun input cambiato, nessun consiglio di lotto.

## Validita
24 passate lanciate, 23 con report. **1 KO**: `R1_L3_GR_2020` (finestra salvataggio report, nessun .htm); la cella Reaper L3 2020 usa quindi **una sola** ripetizione (banda minima 0,10, dichiarato). Tutte le 23 hanno deposito 160000 nel report, qualita storico 99-100%, **zero stop out e zero righe "no money"**.

## Per cella (R = netto 160k / netto 80k; per le rumorose media delle 2 ripetizioni a 160k contro la singola passata a 80k)
| Componente | Anno | Netto 80k | Netto 160k | R | DD rel. 80k -> 160k | Lotto max x | Passate 160k (spread) | Esito |
|---|---|---|---|---|---|---|---|---|
| Goldbot Prop (L0) | 2013 | 18.168 | 36.687 | 2,019 | 3,03 -> 3,07 | 2,02 | 1 | SCALA |
| Goldbot Prop (L0) | 2020 | 12.491 | 25.220 | 2,019 | 2,08 -> 2,06 | 2,02 | 1 | SCALA |
| Goldbot Prop (L0) | 2025 | 8.677 | 18.014 | 2,076 | 2,31 -> 2,37 | 2,00 | 1 | SCALA |
| Goldbot Combo (L3) | 2013 | 14.089 | 28.502 | 2,023 | 2,58 -> 2,59 | 2,03 | 1 | SCALA |
| Goldbot Combo (L3) | 2020 | 9.867 | 19.831 | 2,010 | 1,64 -> 1,64 | 2,00 | 1 | SCALA |
| Goldbot Combo (L3) | 2025 | 6.680 | 14.171 | 2,121 | 1,88 -> 1,90 | 2,00 | 1 | SCALA CON SCARTO |
| Phantom Gradino 1 (L1) | 2013 | 10.873 | 23.934 | 2,201 | 4,74 -> 5,03 | 2,02 | 2 (6,7%) | SCALA CON SCARTO |
| Phantom Gradino 1 (L1) | 2020 | 10.919 | 23.889 | 2,188 | 2,67 -> 2,83 | 2,02 | 2 (3,5%) | SCALA CON SCARTO |
| Phantom Gradino 1 (L1) | 2025 | 20.183 | 40.883 | 2,026 | 2,38 -> 2,42 | 2,08 | 2 (3,4%) | SCALA |
| Phantom Prop (L0) | 2013 | 5.487 | 10.750 | 1,959 | 2,01 -> 2,33 | 2,08 | 2 (21,9%) | SCALA |
| Phantom Prop (L0) | 2020 | 4.367 | 10.582 | **2,424** | 1,22 -> 1,13 | 2,09 | 2 (0,5%) | NON SCALA |
| Phantom Prop (L0) | 2025 | 7.806 | 16.923 | 2,168 | 1,09 -> 1,10 | 2,00 | 2 (13,7%) | SCALA |
| Reaper Combo (L3) | 2013 | 4.534 | 13.267 | **2,926** | 3,84 -> 3,51 | 2,08 | 2 (8,8%) | NON SCALA |
| Reaper Combo (L3) | 2020 | 7.194 | 11.577 | **1,609** | 1,47 -> 1,59 | 2,04 | 1 (KO la R1) | NON SCALA |
| Reaper Combo (L3) | 2025 | 8.794 | 17.616 | 2,003 | 1,56 -> 1,52 | 2,00 | 2 (6,6%) | SCALA |

Totale: **9 SCALA, 3 SCALA CON SCARTO, 3 NON SCALA** (su 15). Deterministiche (Goldbot): 5 SCALA su 6; rumorose (Phantom, Reaper): 4 su 9.

## Lettura onesta
- **Cio che scala in modo pulito**: i **lotti** (lotto massimo per posizione x2,00-2,09 in 15 celle su 15), le **operazioni** (x0,97-1,02), il **DD in punti percentuali** (scarto massimo +0,33 / -0,33 punti; 15 su 15 entro 1 punto) e il **peggior giorno** (circa il doppio in euro, quindi uguale in % del conto).
- **Il netto**: R aggregato sui 3 anni = Goldbot Prop 2,03, Goldbot Combo 2,04, Phantom Gradino 1 2,11, Phantom Prop 2,17, Reaper Combo 2,07. Cioe **a 160k il netto e stato il doppio o poco piu (+2/+9%)**, mai meno nel complesso. Solo 2 celle su 15 sotto 2,00 (Reaper 2020 e, di poco, Phantom Prop 2013).
- **Perche tre celle NON SCALA**: nelle tre componenti rumorose (Randomization 50) l'**80k e una passata sola** e il rumore del Reaper e 6-46% (O-3b): il rapporto con una singola passata a 80k mescola rumore e scala. Phantom Prop 2020 ha le due ripetizioni a 160k quasi uguali (spread 0,5%) ma a 80k il tester aveva 77 aperture su 1.163 al lotto minimo 0,01 (e Phantom Prop 2025: 733 su 1.135): **ipotesi** (non verificata) che l'arrotondamento del lotto a 80k abbassi il netto 80k e gonfi R. Non e una prova che 160k renda "piu del doppio" in avanti.
- **Reaper 2020**: una sola ripetizione a 160k, rapporto 1,61: **non decidibile**; una seconda passata 80k e 160k lo chiarirebbe.

## Combo ricalcolate (solo parte oro, netti medi a 160k contro 80k, 3 anni)
| Combo (solo oro) | 80k (somma 3 anni) | 160k (somma 3 anni) | R | Scarto dal doppio |
|---|---|---|---|---|
| P1 oro: Phantom Gradino 1 + Goldbot Prop (= G-A) | 81.311 | 168.626 | 2,074 | +3,7% |
| P5 oro: Phantom Prop + Goldbot Prop (= G-B) | 56.995 | 118.176 | 2,073 | +3,7% |
| P4 oro: Reaper Combo + Goldbot Prop | 59.858 | 122.380 | 2,045 | +2,2% |
| P3 oro: Goldbot Combo | 30.636 | 62.504 | 2,040 | +2,0% |
Per anno, P4 oro: 2013 R 2,20; 2020 R 1,87; 2025 R 2,04 (rumore Reaper). Il verdetto P1, P3, P4, P5 interi richiede Daytrade Pro e Gold Trade Pro (non ancora girati).

## Previsioni (valutate sulle sole 15 celle oro; D8 e D12 provvisorie)
- **D1** (>= 18/21 SCALA): **falsa** gia ora (9 SCALA, e con 6 celle in piu al massimo 15) e c'e almeno una NON SCALA.
- **D2** (nessuna NON SCALA): **falsa** (3).
- **D3** (|delta DD| <= 1 punto): **vera finora** (15/15); da chiudere con le 6 celle mancanti.
- **D4** (R < 2,00 in >= 12 celle): **falsa** (2/15).
- **D5** (rapporto dei lotti 1,90-2,10): **vera sul lotto massimo** (15/15); la somma dei lotti a 80k non e nei dati letti.
- **D6** (lotto massimo 1,9-2,1): **vera** (15/15).
- **D7** (le coppie piu scartate sono Goldbot/GTP): **falsa per Goldbot** (le piu pulite); GTP da vedere.
- **D8** (somme entro il 3% del doppio): **mista**: oro P4 +2,2%, P3 +2,0% entro; P1 e P5 +3,7% appena fuori 3%, dentro 5%. Sentenza completa dopo DTP.
- **D9** (zero stop out / no money): **vera**.
- **D10** (tutte valide): **falsa** (23/24; un KO).
- **D11** (spread >5% in >= 5 delle 9 celle rumorose): **vera** (5/9).
- **D12** (le deterministiche scalano meglio): **vera finora** (5/6 contro 4/9; GTP e DTP da aggiungere).

## Limiti dichiarati
Solo tester (leva 1:100), margine dell'oro su FTMO e limiti di lotto per ordine **NON** misurati; nessuno slippage di ordini piu grandi; costi per lotto non applicati (scenari F-E); un percorso per anno; riferimento 80k singolo per le rumorose; la prova "lotti uguali" usa il lotto massimo e non la somma dei lotti a 80k (non nei dati disponibili). Daytrade Pro e Gold Trade Pro Combo **non ancora misurati** a 160k.

## AGGIORNAMENTO: Gold Trade Pro Combo (riga `D160_GTP`, 3 passate, tutte valide)
Input imposti confermati dal report in tutte e 3 (Risk=3, MaxRiskPerStrategy 0,5, PropFirmMaxDailyDD 4,0), deposito 160000, zero stop out e zero "no money". Deterministico (Randomization 0): 1 passata per anno.
| Anno | Netto 80k | Netto 160k | R | DD rel. 80k -> 160k | Operazioni 80k / 160k | Peggior giorno realizzato 160k | Lotto max 160k | Esito |
|---|---|---|---|---|---|---|---|---|
| 2013 | 14.693 | 29.858 | 2,032 | 4,45 -> 4,48 | 325 / 325 | -4.350 (2,7%) | 1,24 | SCALA |
| 2020 | 6.529 | 13.087 | 2,005 | 5,94 -> 6,15 | 288 / 288 | -2.023 | 1,18 | SCALA |
| 2025 | 8.843 | 18.290 | 2,068 | 1,91 -> 2,00 | 276 / 276 | -1.696 | 0,45 | SCALA |
R aggregato 3 anni = 2,04 (scarto +2,0% dal doppio); operazioni identiche (x1,00); DD entro 0,21 punti. Il peggior giorno a 80k non e nei dati letti (`gtp_res.json` non lo contiene): il rapporto dei lotti non e misurato per GTP.
**Stato D160 a 18 celle su 21** (oro 15 + GTP 3; manca Daytrade Pro Max9): 12 SCALA, 3 SCALA CON SCARTO, 3 NON SCALA (tutte Phantom Prop 2020 e Reaper Combo 2013/2020, rumorose). Deterministiche: 8 SCALA su 9 (Goldbot 5/6, GTP 3/3). Combo P3 senza Daytrade Pro (Goldbot Combo + GTP Combo, 3 anni): 60.701 a 80k -> 123.739 a 160k, R 2,038 (scarto +1,9% dal doppio, dentro il 3%). Con Daytrade Pro il verdetto su P1, P3, P4 e P5 interi resta da chiudere.
