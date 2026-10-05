# RESOCONTO EA - GRUPPO G2: EMA200 + SUPERWAVE + ORB (FASE 2) - 05/10/2026

> **DOCUMENTO INTERNO. NON ESCE. Non e' stato mandato a nessuno. Cancello di giudizio (`controllo-preventivo`) 05/10: FAIL, corretto in
> questo file (vedi CHANGELOG); seconda passata indipendente 05/10: altre celle trovate e corrette (conteggi 8/9/8); serve un lettore leggero sulle correzioni della seconda passata prima di qualunque uscita.**
> Piano: `report/RESOCONTO_EA_PIANO_2026-10-05.md` (sez. 4 'G2', sez. 5 regola, sez. 6 scheda, sez. 7 'GRUPPO G2', sez. 8 dubbi).
> Richiesta di Claudio (05/10/2026): per ogni EA con PF sopra 1 e sotto 1, **che backtest e' stato fatto, che anni, che regimi, se e'
> migliorabile e cosa serve**. Perimetro di questo file: le **14 righe / 15 file** di G2.
> **Sola lettura d'archivio.** Nessun round lanciato, nessun EA/preset/magic/sedia toccato, nessuna taglia proposta, forward = **solo demo**
> (demo piccolo 50503392, `data/statements/trades_auto.csv`, fino al 02/10/2026); le fonti nate per altri scopi sono usate **solo nelle parti backtest**.
> Etichette: `[T]` tick reali BCM (modello 4) · `[B]` barre OHLC M1 (modello 1, **screening**: non promuove e non boccia) · `[?]` tipo non dichiarato dalla fonte ·
> `[MISURATO]` letto da un CSV / referto, o ricalcolato da me dal per-trade (dichiarato) · `[DERIVATO]` calcolo mio su numeri scritti · `[DICHIARATO]` scritto
> in un referto, non riaperto · `[NON MISURATO]` il numero non esiste. **n**: dove non e' scritto "pos", e' **deal di uscita** (il fattore deal/posizioni misurato va da 1,00 a 2,31).
> Classe e affidabilita' secondo piano sez. 5 (A: n OOS>=150 pos + OOS vero + >=2 regimi · B: n>=150 ma un solo regime · C: 30<=n<150 · D: n<30).

---

## 0. TABELLA RIASSUNTIVA (una riga per CELLA; le celle contano piu' degli EA)

Finestra standard degli indici BCM: tick reali **2024.09.26 -> 2026.06.30**, IS fino al 2025.06.09, OOS dal 2025.06.10 (circa 21 mesi, **un solo regime**: rialzo, con la discesa feb-apr 2025 dentro l'IS). Rischio 1% salvo scritto.

| EA | cella (simbolo TF lato) | classe + aff. + dato | PF IS / OOS | n OOS | anni misurati | regimi superati | verdetto di casa | migliorabile? |
|---|---|---|---|---|---|---|---|---|
| `ABTG_EMA200` | **U30USD H1 L+S (sedia 771531)** | **SOPRA** · B · `[T]` | 1,201 / **1,524** | **257 pos** (517 deal) | 21 mesi | solo il rialzo; PF per regime fuori dal rialzo `[NON MISURATO]` | MERITO SOSPESO (IS 132 pos <150, non ricontabile) · FRAGILE (costo 33,6-45,2x) · rischio 7,83% a 1% | si' (rischio, uscita) / regime: non ancora misurabile |
| `ABTG_EMA200` | U30USD H1 solo long / solo short | SOPRA · C/B · `[T]` | L 1,162 / 1,241 · S 1,232 / 1,891 | L 241 · S 302 deal | idem | idem | NON ANCORA MISURATO come sedie a se' (n IS 112 / 125 <150) | non ancora misurabile |
| `ABTG_EMA200` | U30USD H2 / H4 L+S | SOPRA · C · `[T]` | H2 2,599 / 1,173 · H4 1,660 / 1,425 | 266 / 116 deal (~132 / ~58 pos `[DERIVATO]`) | idem | idem | NON ANCORA MISURATO (IS n 127 / 26 deal; frequenza) | non ancora misurabile |
| `ABTG_EMA200` | U30USD M15-M30-H3 L+S | SOTTO · B · `[T]` | M30 1,034 / 0,907 · H3 2,152 / 0,908 | 1268 · 170 deal | idem | -- | M15/M20/M30 ESCLUSI PER COSTO (28,3-32,0x a M30) e OOS <1 | no (costo) |
| `ABTG_EMA200` | **D30EUR H1 L+S** (gemello) | **SOTTO** · B · `[T]` | 0,928 / **0,783** | 568 deal | 21 mesi | -- | non si trasporta (EMAGEM2 04/10); certificato: manca l'uscita ad asse | no, non senza una tesi nuova |
| `ABTG_EMA200` | **NASUSD H1 L+S** (gemello) | **SOTTO** · B · `[T]` | 0,755 / **0,693** (DD OOS 20,97%) | 508 deal | 21 mesi | -- | idem | no |
| `ABTG_EMA200` | D30EUR H4 L+S (EMAGEM2) | **SOPRA nominale** · C · `[T]` | 1,133 / **1,052** (DD 2,34 / 5,54%) | 156 deal (IS 40 deal) | 21 mesi | -- | NON ANCORA MISURATO (IS 40 deal <150; OOS dentro la zona grigia D2, soglia **NON firmata**: firma di Claudio) | non ancora misurabile (campione) |
| `ABTG_EMA200` | D30EUR M30 / H2 / H3 L+S (EMAGEM2) | **SOTTO** · B/B/C · `[T]` | M30 0,657 / 0,954 · H2 1,407 / 0,798 · H3 0,941 / 0,753 | 1210 / 361 / 209 deal | 21 mesi | -- | sotto 1, non ancora morto (stesso certificato del gemello H1) | no |
| `ABTG_EMA200` | NASUSD M30 L+S | **SOPRA (OOS) con SEGNO INVERTITO** · B · `[T]` | 0,728 / 1,092 | 1043 deal | 21 mesi | -- | ESCLUSA PER COSTO (23,6x) | no |
| `ABTG_EMA200` | XAUUSD H4 L+S (base, R264d) | MISTA · screening `[B]` | **0,836** (2017-23) / 1,535 (2024-26) | 311 deal | **IS 7 anni 2017-23 + OOS 2,5 anni** | OOS: toro oro 2024-26; IS: PF per regime `[NON MISURATO]` | **NO PER RISCHIO** (DD IS 13,32% a 1%), certificato 5/5; OOS NON CONFRONTABILE (G0 ROSSO) | non ancora misurabile (separare 3 cause) |
| `ABTG_EMA200` | XAUUSD H1 L+S (R32a) | **SOPRA (OOS) con SEGNO INVERTITO** · `[T]` | 0,564 / 1,103 | 358 deal | 21 mesi | -- | IS in perdita su 30 celle su 30 | no (griglia su IS negativo vietata 19/08) |
| `ABTG_EMA200` | H4 nativi AUDJPY L, GBPJPY L, GBPUSD S, 200AUD L | SOPRA (senza OOS) · C · `[T]` finestra unica 2024.01-2026.06 | n/d (nessuno split) / PFmed 1,68-1,95 | 69-99 pos (138-200 deal) | 2,5 anni (primi ~6 mesi con tick generati) | un regime | FUORI PER ARITMETICA DEL CAMPIONE; G0 R264 ROSSO 4/4; **0 posizioni** in forward 30/03-11/09 | non ancora misurabile |
| `ABTG_EMA200` | AUDJPY H4, GBPUSD H4 su 16,5 anni | **SOTTO** (AUDJPY) / **SOPRA (OOS) con SEGNO INVERTITO** (GBPUSD 1,13) · screening `[B]` | AUDJPY 0,78-0,81 / 0,95-1,01 · GBPUSD 0,80-0,84 / 1,13 | 1292-1345 deal | **16,5 anni (2010-2026)** | GBPUSD segno invertito su 4 celle su 4 = REGIME | FAIL rischio (DD 15-20% a 1%) | no |
| `ABTG_EMA200` | EURUSD H4 solo corto (R265/R271) | NON MISURATO (indizio debole) · `[B]` | 1,106 / 1,314 (SLatr 1,5) | ~104 pos | IS 2017-23 + OOS 2024-26 | IS comprende piu' regimi, PF per regime `[NON MISURATO]` | a SLatr 1,0 ESCLUSO PER COSTO (35-37x); a 1,5 costo ok (53-55x), merito SOSPESO | si' (long, H1) |
| `ABTG_EMA200_Ottimizzato` | XAUUSD H4 (971501) | SOPRA (OOS) con SEGNO INVERTITO · C · `[T]` | **0,658** / 1,495 (n 39 / 67 deal) | 67 deal | 21 mesi + 22 anni `[B]` solo per il rischio | toro oro 2024-26 | **NO PER RISCHIO**: DD 22 anni **45,91%** a 1% contro 4,40% promesso (firma 23/08: nessuna taglia) | no (rischio) |
| `ABTG_EMA200_Ottimizzato` | XAUUSD M15 / M20 (TF scan) | **SOTTO** · B · `[T]` | M15 0,675 / **0,868** · M20 0,524 / **0,975** (DD OOS 26,0 / 11,4%) | 1415 / 1008 deal | 21 mesi | -- | sotto 1, non ancora morto (certificato non compilato; la sedia e' gia' NO PER RISCHIO) | no |
| `ABTG_EMA200_Multi_BANCO` | -- | NON MISURATO | -- | -- | -- | -- | NON ANCORA MISURATO (copia di banco, v0.10) | non ancora misurabile |
| `standalone/ABTG_EMA200` | -- | NON MISURATO (EREDITA) | -- | -- | -- | -- | stessa riga di `ABTG_EMA200` (9 input in meno, logica non diffata) | -- |
| `ABTG_SuperWave` | **U30USD H2 (770531)** | **SOPRA** · C · `[T]` | 5,571 (n 32) / **1,762** | **50 pos** (88 deal) | 21 mesi | solo il rialzo; stagione: PF 5,83 (42 deal) / 1,23 (46) `[DICHIARATO]` | MERITO SOSPESO (n 50 pos); DD OOS 4,27% (CSV) contro 2,96% (censimento): non riconciliati | non ancora misurabile |
| `ABTG_SuperWave` | GBPUSD H2 (770532, SPENTA 24/08) | MISTA · C `[T]` / `[B]` | tick 1,833 / 1,837 (n 30 / 63 deal) | 39 pos | tick 21 mesi; barre **6,5 anni** | **4 regimi `[B]`**: orso 2022 0,96 (51) · crollo 2020 1,07 (17; anno intero 0,86 su 69) · toro 2021 **0,56** (65) · laterale 2019 0,80 (61) | 6,5 anni PF **0,79**, DD 13,4%, 5 anni su 7 negativi | no (regime) |
| `ABTG_SuperWave` | D30EUR H1 · NASUSD H1/H4 · XAUUSD · SPXUSD | **SOTTO** · `[B]`/`[T]` | DAX H1 max 0,84 (DD 17%) · NASUSD H1 OOS 0,73-0,84 su 9 celle su 9 (n 58-63) | 58-63 deal | 21 mesi (tick) | -- | NASUSD H1: FAIL G3+G4; oro ~1,0/negativo | no |
| `ABTG_SuperWave_DOW_H1_Ottimizzato` | **U30USD H1 L+S (770511)** | **NON MISURATO (CONTESA)** · `[T]` | 1,849 / 1,328 **oppure** 1,482 / 1,243 | n pos `[NON MISURATO]`, forbice **62-143** (143 o 131 deal) | 21 mesi | solo il rialzo | MERITO SOSPESO; contratto conteso fra binari (DD 3,91 vs 4,17%) | si' (riconciliare; uscita) |
| `ABTG_SuperWave_DOW_H1_Ottimizzato` | U30USD H1 solo short | **SOTTO** · C · `[T]` | n/d / **0,429** | 84 deal | 21 mesi | -- | DD 7,53%; NON MISURABILE (n 84) | no |
| `ABTG_SuperWave_DOW_H1_Ottimizzato` | U30USD H1 L+S, asse d'uscita R120 a trailing **spento** (b00 10k, e00 100k) | **SOPRA (OOS) con SEGNO INVERTITO** · C · `[T]` | b00 0,903 / **1,187** · e00 0,978 / **1,284** (DD OOS 6,23 / 6,53%) | 90 / 130 deal | 21 mesi | -- | non e' la cella di contratto; senza trailing l'IS va sotto 1 = REGIME, non edge (il trailing porta l'edge) | no (e' l'asse gia' misurato) |
| `ABTG_SuperWave_DAX_H4_Ottimizzato` | D30EUR H4 L+S (770512, non in campo) | SOPRA (senza OOS) · C · `[T]` finestra piena | **1,285** (n 56, DD 3,32%) / -- | -- | 2024.01-2026.06 nominale, nessuno split | un regime | MERITO SOSPESO (56 <150); frequenza 0,12 op/g | non ancora misurabile (campione) |
| `ABTG_SuperWave_DAX_H4_Ottimizzato` | D30EUR M15-M20-M30-H1-H2-H3 (TF scan del file Ott, `InpStMult`=3) | **SOTTO** · B/C · `[T]` | OOS 0,61-0,96 (M15 0,837 / 0,954 su 630; M30 0,559 / 0,962 su 328); H4 3201 (n 8) / 1,064 (48) | 56-630 deal | 21 mesi | -- | sotto 1, non ancora morto; nella validazione 3x3 a finestra piena anche una cella 0,86 | no |
| `ABTG_SuperWave_EA` | D30EUR M3 (variante A) | NON MISURATO | -- | -- | confluenza H4/M3: DAX 2010-18 + oro 2006-20 e 2021-26 `[B]` | -- | timing H4/M3: **NULLO 6 celle su 6** (misura d'effetto, non PF) | no |
| `ABTG_ORB` | NASUSD M5 (R7a, range 5' pre-apertura) | MISTA · B · `[T]` | 0,824 / **1,050** (DD IS 24,84 / OOS 19,41%) | 355 deal | 21 mesi | -- | SOPRA solo nominale (IS invertito; "indistinguibile da 1" = soglia di zona grigia D2 **NON firmata**: firma di Claudio, qui solo segnalata); **NO PER RISCHIO**; costo 26,5x | no |
| `ABTG_ORB_Ottimizzato` | **U30USD M5 solo long (sedia 770611)** | **SOPRA** · C · `[T]` | 1,250 / **1,674** (banco 100k; R15 a 10k 1,223 / 1,657) | **119 pos** (71 IS) | 21 mesi | solo il rialzo | MERITO SOSPESO (n 119); DD OOS 9,76% (muro 10% 'per 8 centesimi'); con slippage 1,5 pt >10%; costo 29,5x | si' (TF, gemelli, regime) |
| `ABTG_ORB_Ottimizzato` | U30USD short · NASUSD (R97) · D30EUR (R11) · XAUUSD (R10) | **SOTTO** · B/C · `[T]` | short OOS 0,52 (DD 26,4%) · NASUSD OOS 0,84-0,91 (n 135) · DAX 0,94-1,02 · oro 0,87-0,999 | 135 / 173-376 deal | 21 mesi | -- | breakout secco: chiuso con i numeri; certificato incompleto | no (gemelli provati) |
| `ABTG_ORB_Fibo` | NASUSD M5 (R272) | **SOTTO** · C · `[T]` | **0,803 / 0,851** (OHLC 0,835 / 0,968) | 75 deal | 21 mesi | -- | SOTTO 1, non ancora morto (mancano uscita, gemelli, TF) | no su questa cella |
| `ABTG_Londra_ORB` | GBPUSD / EURUSD M5 ore 7-8-9 (R258), `InpMinRangePips`=0 (default del sorgente r.40) | **SOTTO** · B · `[T]` | GBPUSD 0,70-1,05 / **0,74-0,97** · EURUSD 0,65-1,18 / **0,70-0,91** | 293-306 deal per cella | tick (forex dal 07/2024) `[date non dichiarate dalla nota]` | -- | 6 celle su 6 OOS <1 a F=0, DD 30-55% (deposito fisso); certificato INCOMPLETO | no, salvo la tesi dell'uscita |
| `ABTG_Londra_ORB` | GBPUSD M5 ora 8, `InpMinRangePips`=10 (R258a) | **SOPRA nominale** · B · `[T]` | 1,088 / **1,034** (DD equity 14,17 / 23,32%) | 253 deal (IS 156) | idem | -- | **NO PER RISCHIO** (DD 23% a qualunque n) + ESCLUSA PER COSTO (9,5-15,5x); zona grigia D2 non firmata. Stesso blocco: EURUSD ora 7 F=10 OOS 1,123 su 116 deal con IS 0,819 (**SEGNO INVERTITO**, C); R258w GBPUSD ora 8 `InpRangeStartMin`=30: IS 0,788 (202) / OOS **1,091 (304)**, DD equity IS 35,28% (**SEGNO INVERTITO**, B, NO PER RISCHIO) | no (rischio, costo) |
| `ORB_OpeningRange` | -- | NON MISURATO | -- | -- | -- | -- | NON ANCORA MISURATO: nessun CSV in tutta la storia git | non ancora misurabile |
| `ORB_DAX_BASE_EA` · `ORB_DAX_PM_EA` | -- | NON MISURATO | -- | -- | -- | -- | idem | non ancora misurabile |

**Nessuna cella di G2 ha affidabilita' A** (nessuna ha >=2 regimi misurati con n OOS >=150): l'unica con 4 regimi e' SuperWave GBPUSD H2, a barre, n 17-65 per regime, spenta.

### 0.1 Conteggi (per RIGA/EA di G2: 14 righe = 15 file)

| classe | EA | quali |
|---|---:|---|
| **con almeno una cella SOPRA 1** | **8** | `ABTG_EMA200` · `ABTG_EMA200_Ottimizzato` · `ABTG_SuperWave` · `ABTG_SuperWave_DOW_H1_Ottimizzato` (solo celle d'uscita R120 a trailing spento, SEGNO INVERTITO; il contratto resta CONTESA) · `ABTG_SuperWave_DAX_H4_Ottimizzato` · `ABTG_ORB` (solo nominale, vedi sez. 3) · `ABTG_ORB_Ottimizzato` · `ABTG_Londra_ORB` (solo nominale, GBPUSD ora 8 F=10, NO PER RISCHIO; corretto dal cancello 05/10) |
| **con almeno una cella SOTTO 1** | **9** | `ABTG_EMA200` · `ABTG_EMA200_Ottimizzato` (TF scan M15/M20) · `ABTG_SuperWave` · `ABTG_SuperWave_DOW_H1_Ottimizzato` (solo short) · `ABTG_SuperWave_DAX_H4_Ottimizzato` (TF scan) · `ABTG_ORB` · `ABTG_ORB_Ottimizzato` · `ABTG_ORB_Fibo` · `ABTG_Londra_ORB` |
| **solo NON MISURATO** | **5 righe (6 file)** | `ABTG_EMA200_Multi_BANCO` · `standalone/ABTG_EMA200` (EREDITA) · `ABTG_SuperWave_EA` · `ORB_OpeningRange` · `ORB_DAX_BASE_EA` + `ORB_DAX_PM_EA` |
| **cella di contratto NON MISURATO (CONTESA)** | 1 | `ABTG_SuperWave_DOW_H1_Ottimizzato` (+ lato short SOTTO, + celle d'uscita R120 SOPRA con SEGNO INVERTITO) |

Un EA puo' stare in piu' di una riga (regola sez. 5.1 del piano): 8 EA stanno sia in SOPRA sia in SOTTO (`ABTG_EMA200`, `ABTG_EMA200_Ottimizzato`, `ABTG_SuperWave`, `ABTG_SuperWave_DOW_H1_Ottimizzato`, `ABTG_SuperWave_DAX_H4_Ottimizzato`, `ABTG_ORB`, `ABTG_ORB_Ottimizzato`, `ABTG_Londra_ORB`); solo SOTTO: `ABTG_ORB_Fibo`. Conti rifatti dalla seconda passata del cancello 05/10 (classe 1127, anche nel verso SOTTO) rileggendo cella per cella EMAGEM2 b/c, TF scan di `EMA200_Ottimizzato` e di `SuperWave_DAX_H4_Ottimizzato`, R120b/e, R258 a tick; **gli altri round (R97, R10, R11, R23, R264, scan SW nativo) non sono stati riletti cella per cella** `[NON VERIFICATO]`, ma nessuno puo' cambiare i conteggi per EA (i loro EA sono gia' in entrambe le liste). **Nessun EA e' dichiarato MORTO**: i SOTTO senza certificato 5/5 sono "sotto 1, non ancora morto".

### 0.2 Riconciliazioni con la classe provvisoria del piano (usata la fonte piu' recente, dichiarato)

| EA | piano (provvisoria) | qui | perche' |
|---|---|---|---|
| `ABTG_SuperWave_DOW_H1_Ottimizzato` | SOPRA (contratto conteso) | **NON MISURATO (CONTESA)** | piano sez. 5.2.6: due misure discordanti sulla stessa cella -> NON MISURATO finche' non si riconcilia. Entrambe le versioni stanno sopra 1,20 in OOS: se si riconcilia, e' SOPRA in ogni caso `[INFERITO]` |
| `ABTG_ORB` | SOTTO (a tick R97) | **MISTA** | R97 (0,84-0,91 su n=135) e' una prova di `ABTG_ORB_Ottimizzato` su NASUSD, **non** di `ABTG_ORB`; le celle di `ABTG_ORB` (R7a/R7b/R8, 8 CSV) danno OOS 1,050 / 0,93 / 0,98-1,03 |
| `ABTG_Londra_ORB` | NON MISURATO (verdetto compromesso dal fuso) | **MISTA: SOTTO a F=0 (6/6), SOPRA nominale a GBPUSD ora 8 F=10; certificato incompleto** | **R258 (28/09)**: 24 file (blocchi a tick, blocco L a barre) con ore 7/8/9; il difetto del fuso era di R45 (pre-apertura). 6 celle su 6 OOS <1; la console dice NULLO su 22 file ma e' un artefatto del parser (G2-11) |
| `ABTG_ORB_Fibo` | SOTTO (OHLC, 29% celle positive) | **SOTTO a tick** | **R272 (29/09)** a tick reali: 0,803 / 0,851, peggio dell'OHLC |
| `ABTG_EMA200` gemelli DAX/Nasdaq | `[NON MISURATO]` L+S a tick (EMA200_GEMELLI_STATO 03/10) | **MISURATO, SOTTO** | **EMAGEM2 (04/10)**: il primo giro del 03/10 era NULLO per il cancello T1 (0,01 EUR di residuo); il secondo e' PASS |
| `ABTG_EMA200` EURUSD H4 corto | ESCLUSO PER COSTO / NON ANCORA MISURATO (R265) | **NON MISURATO, indizio debole** | **R271 (29/09)**: a SLatr 1,5 il costo e' rispettato |
| `ABTG_EMA200` oro H4 | SOTTO | **MISTA** | R264d: IS 0,836 (SOTTO) ma OOS 1,535 (SOPRA), `[B]`, NON CONFRONTABILE |
| `ABTG_SuperWave` U30USD H2 | "U30USD SOPRA?" | **SOPRA, C** | CSV R23d letto e per-trade ricontato da me (88 deal = 50 pos) |

---

## 1. FAMIGLIA EMA200

**Fonti comuni della famiglia** (lette per intero o per le parti citate): `report/EMA200_GEMELLI_STATO_2026-10-03.md` · `report/EMA200_RIMBALZO_STATO_DELLARTE_2026-09-30.md` (tabelle 2.1-2.2) ·
`backtest_pipeline/risultati_archivio/R136_R137_LA_NOTTE_CHE_I_CSV_SONO_ARRIVATI_2026-09-13.md` (sez. 2) · `report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` (3.1-3.3, solo le parti backtest) ·
`REGISTRO_TEST.md` root (R264/R265, 28/09) · `backtest_pipeline/REGISTRO_TEST.md` (r.2478-2650, r.2975-3010, r.3510-3550) · `backtest_pipeline/risultati_archivio/ROUND_EMAGEM2_20261004_2217/` + `report/EMAGEM2_PRELETTURA_2026-10-04.md` ·
`report/LETTURA_ROUND_CORTI_C2_2026-09-28.md` · `report/LETTURA_ORB_R271_R272_R273_2026-09-29.md` · `report/EMA200_H4_D1_FOREX28_MISURA_2026-10-03.md` · `report/EMA200_RIMBALZO_MISURA_2026-10-01.md` · `report/EMA200_D1_SU_M5_MISURA_2026-10-02.md` ·
`report/DECISIONE_EMA200_RESTA_SUL_DEMO_2026-09-18.md` · `report/OROLOGIO_BCM_2026-09-24.md` (5.1) · `report/DOSSIER_EXPERT_PER_EMILIANO_2026-10-05.md` (B2 sched. 6) · CSV `risultati_archivio/R112_CORSA_20260826/`, `risultati_prove/dal_vps/ABTG_EMA200/`, `risultati_prove/ABTG_EMA200_Ottimizzato/`.

**Misure di FENOMENO collegate (non sono PF di un EA, ma dicono cosa NON c'e' sotto il motore)**: il "rimbalzo al primo tocco" della EMA200 e' **NULLO**: H4 su 6 coppie forex Oanda 2005-2020 (15,4 anni) P 0,487 long / 0,470 short contro surrogati 0,478 / 0,491
(n_cluster 634 / 591); M5-H1 su DAX/oro/S&P (oro 2006-2020 e 2021-26, DAX 2010-18): 13 NULLO e 8 ZONA GRIGIA su 21 celle, nessun EFFETTO; D1 sul grafico M5: ZONA GRIGIA (oro A 0,435 / 0,469, n 191 / 194). Il verdetto sul fenomeno resta **NON ANCORA MISURATO** a H4 dentro i regimi (4 classi su 5 ZONA GRIGIA per imprecisione) e a D1 (n_cluster 86 / 84 <150).
Conseguenza di lettura: **il guadagno del motore Dow non puo' venire dal rimbalzo come frequenza**; resta l'ipotesi (non misurata) che venga dalla coda di prosecuzione catturata dal trailing (56,4% delle posizioni OOS esce in utile via pareggio/trailing, solo il 4,3% al TP) `[INFERITO]`.

---

### 1.1 `ABTG_EMA200`   famiglia: EMA200   gruppo: G2   ruolo: sedia 771531 (U30USD H1) + gemelli H4 nativi 771511-15 (mai operanti) + celle di prova

1. **MOTORE**: due ordini LIMIT a 0,20 e 0,30 ATR dalla EMA200 quando il prezzo sta fra 0,3 e 1,5 ATR dalla media e la EMA14 e' dallo stesso lato; stop 1 ATR oltre il secondo; parziale 50% sulla EMA14, poi pareggio e trailing, TP 2R; **una sola posizione o un pendente alla volta per simbolo e magic** (long e short si escludono, quindi n(L+S) non e' n(L)+n(S)); scadenza dei pendenti 6 barre (`ABTG_EMA200.mq5`, 690 righe; stato dell'arte sez. 1).
2. **SIMBOLI / TF provati** (cella di contratto: **U30USD H1 L+S**): U30USD M15-H4 · D30EUR M30-H4 · NASUSD M30-H4 · SPXUSD M30/H1/H4 · XAUUSD M30/H1/H4 · 225JPY H1/H4 · EURUSD H1/H4 · AUDJPY, GBPJPY, GBPUSD, 200AUD H4 · screening OHLC su 47 simboli a H4 e 48 a H1. **Strumenti collegati**: `ABTG_EMA200_Ombra` (ombra di sola simulazione sulla tabella, v1.03, **NON COMPILATO**, cancello da fare), `ABTG_MIS_SIZING_EMA200` (strumento di misura, mai su un conto). Copie: `Multi_BANCO` (1.1.3), `standalone` (1.1.4).
3. **BACKTEST FATTI**

| round | dato | deposito | rischio | finestra IS | finestra OOS | file |
|---|---|---|---|---|---|---|
| R110 / R112 / r136a-d / cemad02 / cemad05 / EMAGEM-a (riprodotto 4 volte) | `[T]` | 100.000 | 1% | 2024.09.26-2025.06.09 | 2025.06.10-2026.06.30 | `risultati_archivio/R112_CORSA_20260826/ABTG_EMA200_U30USD_{IS,OOS}_00_metro.csv` r.2 |
| R29b (30 celle, 30/30 positive) | `[T]` `[?]` | 10.000 (default del driver) | 1% | fino al 2025.06.09 | 2025.06.10-2026.06.30 | `risultati_prove/ABTG_EMA200/ABTG_EMA200_U30USD_{IS,OOS}_r29b.csv` |
| valid H1 real-tick Dow (genetico, 137 righe) | `[T]` con i primi ~6 mesi **generati dalle M1** | 10.000 | 1% | finestra UNICA 2024.01.01-2026.06.30 | -- | `risultati_prove/risultati_valid_ABTG_EMA200_H1_realtick/` |
| scan OHLC 47 simboli H4 / 48 H1 | `[B]` | 10.000 | 1% | UNICA 2024.01.01-2026.06.30 (dichiarata dal driver, non dal CSV) | -- | `risultati_archivio/EMA200/{H4,H1}_OHLC/` |
| valid H4 real-tick, 8 simboli | `[T]` (primi ~6 mesi generati) | 10.000 | 1% | UNICA 2024.01-2026.06 | -- | `risultati_archivio/EMA200/realtick_H4/` |
| R32a XAUUSD H1 / R32b 225JPY H1 | `[T]` | n/d | 1% | da 2024.09.26 | -- | `prove/R32a_ema200_xauusd.txt`, `risultati_prove/ABTG_EMA200/*_r32a.csv` |
| R139a AUDJPY H4 / R139b GBPUSD H4 | `[B]` | n/d | 1% | storico lungo (AUDJPY 16,5 anni) | OOS 2024-26 | `risultati_prove/dal_vps/ABTG_EMA200/*_r139{a,b}.csv` |
| R234a-c (corto H2-H4 Dow, corto DAX/Nasdaq M30-H4) | `[T]` | 100.000 | 1% | 2024.09.26-2025.06.09 | 2025.06.10-2026.06.30 | **CSV NON in repo**: numeri dal referto `REFERTO_13_ROUND_2026-09-23.md` |
| **EMAGEM2** DAX e Nasdaq, TF M30-H4 (cancello T1 PASS) | `[T]` | 100.000 | 1% | idem | idem | `ROUND_EMAGEM2_20261004_2217/` |
| R264c-d (G0 su 4 simboli) | `[T]` | 10.000 | 1% | moncone | 2024.01.01-2026.06.30 | `ROUND_CORTI_C_2026-09-28/` |
| **R264d1-d4** oro H4 griglia 3x3 + uscita ad asse | `[B]` | 100.000 | 1% | **2017-2023** | 2024-2026 | `ROUND_CORTI_C2_2026-09-28/` |
| R265a / **R271** EURUSD H4 solo corto, `InpSLatr` 1,0/1,25/1,5 | `[B]` | 100.000 | 1% | 2017-2023 | 2024-2026 | `ROUND_ORB_R271_2026-09-29/` |

4. **ANNI e REGIMI**
   - **Dow H1 (la sedia)**: IS 2024.09.26-2025.06.09 (~8,5 mesi), OOS 2025.06.10-2026.06.30 (~12,7 mesi). Un solo regime (rialzo). **Il Dow non ha storico esterno** (HistData non lo ha; il secondo fornitore non e' stato scaricato; il pezzo importato cade dentro il nativo): `NON MISURATO` per orso, laterale, crollo.
   - **Stagione**, non regime: sul per-trade R112 (`pertrade_00_metro_763400.csv`, ricontato da me: 517 deal = **257 posizioni**, PF per deal 1,5236 e per posizione 1,5237, vincite 60,7%) i mesi apr-ott danno **PF 1,93 su 317 deal** e i mesi nov-mar **1,08 su 200** `[DERIVATO, taglio per mese di chiusura]`; con il taglio per orologio il censimento scrive 2,05 su 347 deal contro **0,87 su 170** (`OROLOGIO_BCM` 5.1.1). I due tagli concordano nel verso: **d'inverno il PF cala**. Il motore non ha ingressi orari: l'effetto non e' dell'orologio ma del mercato.
   - **Concentrazione del profitto** (contro-esempio costruito da me sul per-trade): settembre 2025 vale **+9.220 su +23.321** (40%); senza quel mese il PF resta **1,33 su 230 posizioni** (era 1,52). Nov-gen 2025/26: tre mesi di fila negativi (-2.712, -1.085, -2.304).
   - **Oro H4**: IS 2017-2023 = laterale 2017-18, toro 2019-20, laterale 2021-22, toro 2023 (un solo PF per 7 anni: **PF per regime `NON MISURATO`**, il per-trade parte dal 2024.01.05); OOS 2024-26 = toro dell'oro. R100 (22 anni, 2004-2026 `[B]`): DD 55,02% a 1% per la base.
   - **Forex H4 su 16,5 anni** (AUDJPY 2010-2026): PF IS 0,78-0,81 contro OOS 0,95-1,01; GBPUSD segno opposto su 4 celle su 4: **regime, non edge**.
   - Per regime non esiste altro. Le 4 finestre (toro/orso/laterale/crollo) **non sono mai state girate su `ABTG_EMA200`**.
5. **NUMERI per cella** (rischio 1%; DD a 0,65% = DD x 0,65 per il confronto col campo):

| cella | PF IS | PF OOS | n IS | n OOS | DD IS | DD OOS | note |
|---|---:|---:|---:|---:|---:|---:|---|
| **U30USD H1 L+S** `[T]` 100k | **1,2011** | **1,5237** (deal 1,52365) | 237 deal (**132 pos, MISURATO FUORI REPO**, forbice **103-237**) | 517 deal = **257 pos** | 5,73% | 7,83% | peggior giornata -2,45% sui chiusi / -1,98% equity `[DICHIARATO]`; con costi prop PF 1,43-1,46 `[DICHIARATO]`; **stop = 33,6-45,2x lo spread: FRAGILE** |
| U30USD H1 solo long | 1,162 | 1,241 | 112 | 241 | 2,64% | 8,90% | `prove/R110_CSV_EMADOW/..._01_long.csv` |
| U30USD H1 solo short | 1,232 | 1,891 | 125 | 302 | 4,51% | 2,66% | riprodotto da R234a |
| U30USD H2 | 2,599 | 1,173 | 127 | 266 | 2,42% | 6,12% | cemad05 |
| U30USD H3 | 2,152 | 0,908 | 36 | 170 | 2,18% | 9,00% | |
| U30USD H4 | 1,660 | 1,425 | 26 | 116 | 2,37% | 4,45% | fuori per frequenza (OHLC 77/85 celle positive, n 15-82) |
| U30USD M30 | 1,034 | 0,907 | 508 | 1268 | 10,92% | 15,87% | ESCLUSO PER COSTO |
| U30USD M20 / M15 | 1,117 / 0,771 | 0,833 / 0,954 | 918 / 1168 | 1642 / 2020 | 9,13 / 27,77% | 30,71 / 26,34% | ESCLUSI PER COSTO; M5 mai girato (11,5-13,1x < duro 13,3x e 132.000 barre) |
| **D30EUR H1** (EMAGEM2) | 0,928 | **0,783** | 295 | 568 | 11,50% | 15,18% | H2 1,407 / 0,798 (si ribalta) · M30 0,657 / 0,954 · H3 0,941 / 0,753 · H4 1,133 / 1,052 (n 40 / 156) |
| **NASUSD H1** (EMAGEM2) | 0,755 | **0,693** | 244 | 508 | 15,35% | 20,97% | M30 0,728 / 1,092 (DD OOS 5,99%, si ribalta) · H2 0,735 / 0,771 · H3 0,742 / 0,488 · H4 0,321 / 0,734 |
| XAUUSD H1 (R32a) | 0,564 | 1,103 | 270 | 358 | 15,23% | 8,79% | 30 celle IS su 30 in perdita |
| 225JPY H1 (R32b) | 1,356 | 0,719 | 291 | 504 | 6,88% | 13,43% | ESCLUSO PER COSTO (4,7-7,2x) |
| XAUUSD H4 (R264d, `[B]`) | **0,836** (9 celle 0,810-0,836) | 1,535 (1,22-1,65) | 777 | 311 | **13,32%** | 6,02% | PF su TUTTA la storia 0,993 (-614 EUR su 9,5 anni, lordi) |
| EURUSD H4 corto SLatr 1,5 (R271) | 1,106 | 1,314 | 614 deal (~300 pos) | 239 deal (~104 pos) | 5,41% | 2,84% | SLatr 1,0: 1,076 / 1,271, DD IS 10,20% (R1 violato) · 1,25: 1,047 / 1,261 |
| EURUSD H1 L+S (R29) `[?]` | 0,986-1,222 | 1,076-1,224 | -- | 583-759 | 8,36-10,15% | 9,05-11,98% | 7/30 celle PASS: bocciata per rischio |
| EURUSD H1 solo long `[T]` finestra unica | -- | PFmed 1,274 (34/34 in utile) | -- | 530-754 | -- | 6,22-8,25% | genetico: celle non campione uniforme; **ESCLUSO PER COSTO a H1** (20,8x), H4 41,7x passa |
| H4 nativi (tick, finestra unica) | -- | AUDJPY L PFmed 1,86 · GBPJPY L 1,76 · GBPUSD S 1,68 · 200AUD L 1,95 · SPXUSD L 1,59 | -- | 138-200 deal (69-99 pos) | -- | 1,4-5,9% | GBPUSD L 8/31 celle in utile (PFmed 0,96): **stesso simbolo, segno opposto** |
| AUDJPY / GBPUSD H4 16,5 anni `[B]` | 0,78-0,81 / 0,80-0,84 | 0,95-1,01 / 1,13 | 757-768 / 856-875 | 1322-1345 / 1292-1321 | 15,4-16,9 / 17,7-20,3% | 16,9-20,4 / 10,1-11,0% | FAIL S3 rischio |

6. **TIPOLOGIE DI MERCATO superate**: (a) classi/simboli con PF>=1 in OOS **tick**: indici = **solo il Dow H1** (+ H2/H4 con campione sottile); forex = H4 long su AUDJPY/GBPJPY e short su GBPUSD **solo a finestra unica 2024-26**; oro = H4 solo in OOS toro. **Sui due gemelli indice con la cella intera H1 (DAX, Nasdaq) non passa**; fuori da H1 restano due celle sopra 1 da non perdere: **DAX H4 1,133 / 1,052** (IS 40 / OOS 156 deal, DD 5,54%: SOPRA nominale, campione IS sottile) e Nasdaq M30 0,728 / 1,092 (SEGNO INVERTITO, ESCLUSA PER COSTO). (b) regimi: solo il rialzo 2024-26; sui regimi lunghi (forex 16,5 anni, oro 2017-23) **non passa**.
7. **FORWARD DEMO** (solo demo, campione sottile): **771531** 23 posizioni dal 14/08 al 22/09, netto **-54,71**, 10 vinte, **PF 0,68** (`trades_auto.csv`; stato dell'arte 2.6); al 11/09 erano 21 pos con DD 2,72% a rischio 0,5% contro 7,21-7,83% promessi, tasso di vincita 47,6% contro 60,7% del backtest (1,2 sigma: **nessun verdetto sul merito**). Frequenza 1,00 pos/giorno feriale contro 0,93 promesse (un referto scrive 1,31 dividendo per 16 giorni: **due fonti non concordano, uso la piu' prudente**). **Famiglia EMA200 sul demo**: 39 pos / -126,27 all'11/09; 47 pos, ancora in perdita, al 02/10 `[DICHIARATO dal dossier]`. 771501: D30EUR 6 pos -77,31 · XAUUSD 3 pos +24,80; 971501 XAUUSD 13 pos +0,43. **771511-15: 0 posizioni** in tutto il periodo. Criterio di merito (18/08): scattato a 20+ operazioni, **revisione di Claudio conclusa il 18/09: restano accese sul demo** (campione che cresce a costo zero).
8. **CLASSE**: **MISTA** (SOPRA: Dow H1 e sue celle H1-H4, forex H4 senza OOS, DAX H4 nominale; SOPRA (OOS) con SEGNO INVERTITO: oro H1, NASUSD M30, GBPUSD H4 16,5 anni `[B]` (OOS 1,13) · SOTTO: DAX M30-H1-H2-H3, NASUSD H1-H2-H3-H4 (EMAGEM2c OOS 0,49-0,77), Dow M15-M30-H3, AUDJPY 16,5 anni `[B]`). Dow H1: **SOPRA, B, `[T]`**, SEGNO non invertito, **NON CONFRONTABILE/REGIME: no** (IS e OOS sopra 1).
9. **VERDETTO**: Dow H1 = **MERITO SOSPESO** (IS 132 pos <150; OOS 257 ok) + **FRAGILE** (costo, la soglia 40x cade dentro la banda 33,6-45,2x; `[NON RICONCILIATO]`: con un'altra formula 39,0-44,1x, `EMA200_GEMELLI_STATO_2026-10-03.md` r.79; FRAGILE in tutte e due) + **regime `NON ANCORA MISURATO`**; rischio 7,83% a 1% (dentro 10%; a 2,00% = 15,66% `[DERIVATO, metro lineare]` fuori: **taglia = firma di Claudio**). Nota informativa, non decisione: sulla Free Trial FTMO la 771531 e' stata accesa a 2,00% (`PIANO_REGIME_DOW_DUKASCOPY_2026-10-05.md` r.114: a quel metro il muro corrisponde a ~4,7% di DD a 1%, che l'OOS 7,83% supera gia'). **Certificato per le celle SOTTO**:

| cella SOTTO | (1) PF | (2) n e DD | (3) uscita ad asse | (4) gemelli | (5) TF | verdetto |
|---|---|---|---|---|---|---|
| DAX H1 L+S | 0,783 `[T]` | 568 deal / 15,18% | **MANCA** (solo sul Dow) | Dow, Nasdaq, SPX, oro | M30-H4 (EMAGEM2) | **NON ANCORA MISURATO** nel certificato (manca la casella 3) |
| NASUSD H1 L+S | 0,693 `[T]` | 508 deal / 20,97% | **MANCA** | idem | M30-H4 | idem; ma DD sopra il muro a **qualunque n** |
| oro H4 base (R264d) | 0,836 IS / 1,535 OOS `[B]` | 777 / 13,32% | R264d4 `InpTP1Pct` 0/25/50/75 | R139a AUDJPY, R139b GBPUSD (OHLC) | R32a XAUUSD H1 | **NO PER RISCHIO, certificato 5/5** (su questo storico: **o regime, o storico M1 diverso, non separati**) |
| oro H1 (R32a) | 0,564 `[T]` | 270 / 15,23% | a H1 `NON MISURATO` | -- | H1 | NON ANCORA MISURATO (griglia su IS negativo vietata dalla regola del 19/08) |
| EURUSD H1 L+S | 1,076-1,224 OOS | 583-759 / 9-12% | **MANCA** | -- | H1/H4 | NON ANCORA MISURATO; ESCLUSO PER COSTO a H1 (20,8x) |

10. **MIGLIORABILE?** **Si', in parte, e solo per il RISCHIO e per la PROVA; non per il PF.** Il Dow H1 ha tre candidati scritti, **nessuno promuovibile** oggi: `InpTP1_ATRmult` 0,25 (OOS PF 1,590, **DD OOS 2,10% contro 7,83%**, ma IS 0,994: segno IS peggiora); `InpUseTrailing` 0 (OOS 1,771, IS 1,107, **segno invertito fra IS e OOS** = "c'e' un CANDIDATO", effetto non attribuibile al solo trailing: i tre meccanismi non sono additivi); `InpSLatr` 0,8 (OOS 1,612: +0,088 sotto il rumore 0,10, e per A8 non si sceglie il picco). Il resto e' **chiuso con misura**: default `InpSLatr` va bene (altopiano 0,8-1,6, centro 1,2 non batte la viva), taglia del parziale **inerte** (25-75: 1,518-1,526), **spegnere il parziale porta il DD OOS a 13,94%** (sopra il muro), H1 e' un PICCO sul TF (altopiano da una parte sola). Sugli altri simboli: **no** (DAX/Nasdaq sotto 1; oro: NO PER RISCHIO).
11. **COSA SERVE** (costi: PC di backtest `DESKTOP-H4D7CAJ`, mai il VPS; ritmi misurati: EMAGEM 24 passate = 10 min; R264 C 24 job = 51 min (2,1 min/job); C2 4 job = 5 min):
    - **IS in posizioni**: ricaricare dal VPS il per-trade di `cemad02` (magic 766620/766621, esiste, mai committato) **oppure** una corsa sola, gamba IS, magic vergine, `-Deposito 100000` (~45 s). Chiude il dubbio D1 del piano. **Zero macchina o ~1 min. Firma: no.**
    - **G0 dell'oro col binario `0953846c`** (separa H_BINARIO / H_STORICO / H_SPEC, sblocca le 12 griglie SALTATE di GBPJPY/GBPUSD/AUDJPY H4 e rende confrontabile l'OOS 1,22-1,65): **~4 job x 2,1 min = ~8-10 min** [STIMA da R264]. Firma: no (round di misura).
    - **Prova di regime del Dow** (piano storico esterno Dukascopy, P0->P1->firma F1): **90-348 ore di calcolo** [DICHIARATO]; **firma di Claudio (spesa/storico)**. E' l'unica misura che puo' portare un EA indice da B ad A.
    - Trailing OFF / `InpTP1_ATRmult` 0,25 su **finestra nuova** o prova di regime (A6 punto 5): 1 corsa, **dopo** il regime Dow.
    - **EURUSD H4 corto**: lato LONG (6 passate) e H1 con SLatr 1,25 (la frontiera di costo potrebbe rientrare): minuti [STIMA 0,1 min/passata].
    - Dati da raccogliere: **forward per simbolo x TF** dall'**ombra sulla tabella** (v1.03, da compilare e passare dal cancello; trimestre di misura, "nessuna cella arriva a n=150": misura RISCHIO e frequenza, merito solo per famiglia). **NON si fa**: griglie su DAX/Nasdaq H1 (motore senza edge su quei simboli, regola 19/08) ne' nuovi gemelli indice a H1 (la cella e' del Dow).
12. **COSTO**: vedi sopra; tutto sul PC di backtest. **Il Guardian**: il binario in campo sul demo piccolo non e' HEAD (344a11b del 04/08, 486 righe, zero `InpUsaGuardian`): non cambia queste misure (girano su HEAD) ma e' un divario campo-vs-misura.
13. **FONTI/CONFLITTI**: IS 132 pos = `LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.80-81, **non ricontabile dal repo** (grep su 130 per-trade: il file IS di cemad02 e' 0 byte per scelta `@FRAZIONEIS 0,002`); la gemella senza parziale **non** conta le posizioni (165 contro 257: toglierlo cambia gli ingressi). **Unita' dossier**: il dossier scrive "OOS estate 2,05 su 169 uscite, inverno 0,87 su 88": 169+88 = 257, sono **posizioni**, non uscite (i deal sono 347 e 170). Forward 21 (dossier, all'11/09) contro 23 (22/09, ricontato da me su `trades_auto.csv`): stessa fonte, date diverse. Il binario di EMAGEM2 e' il pin del 03/10; il binario del contratto 20/09 non e' HEAD.

---

### 1.2 `ABTG_EMA200_Ottimizzato`   famiglia: EMA200   gruppo: G2   ruolo: sedia 971501 XAUUSD H4 (26/07), **firmata "prop NO a nessuna taglia" il 23/08**

1. **MOTORE**: lo stesso di `ABTG_EMA200` (748 righe) con la cella ottimizzata del 26/07 (O1 0,05 / O2 0,6 / TP 2 nei CSV di TF; Pass 311 O1 0,30 / O2 0,4 / TP 2,5 a 10.000 nel genetico).
2. **SIMBOLI / TF**: XAUUSD su 11 TF (M15-D1), cella di contratto **H4**. Altri simboli: nessuno col proprio nome. Fratello di campo: magic 771501 su D30EUR/XAUUSD (EA nativo).
3. **BACKTEST FATTI**: (a) 26/07 real-tick, **finestra piena** 2024.01-2026.06, PF **1,92**, DD "basso", `CLASSIFICA_PF.md` #6 `[T]` (nessun OOS); (b) TF scan a 11 TF **tick e OHLC**, IS/OOS: `risultati_prove/ABTG_EMA200_Ottimizzato/ABTG_EMA200_Ottimizzato_XAUUSD_{IS,OOS}{,_ohlc}.csv` (finestre 40/60 del driver, deposito non dichiarato nel CSV, 1%); (c) **R100 (23/08)**: 22 anni OHLC M1 (2004-2026, storico nativo dell'oro), finestra piena, senza split.
4. **ANNI e REGIMI**: 21 mesi di rialzo dell'oro (tick); 22 anni a barre **solo per il rischio** (DD 45,91% a 1%, peggior giorno -1,91%); **PF per regime NON MISURATO**.
5. **NUMERI** (H4, `[T]`): **IS PF 0,658, n 39 deal, DD 2,20% · OOS PF 1,495, n 67 deal, DD 4,49%** (OHLC: 0,658 / 1,745, n 39 / 69). Tutti i TF hanno IS <1 salvo H12 (n=4): **0,52-0,82 su 9 TF su 9** (con n>0); OOS 1,10-2,53 su M30 e H1-H8, <1 su M15 (0,868), M20 (0,975), D1 (n=3), H12 (n=10).
6. **MERCATI**: oro, **solo nel toro 2024-26** (IS invertito su tutti i TF); nessun altro simbolo.
7. **FORWARD DEMO**: 971501 XAUUSD 13 pos, netto +0,43, PF 1,00 (05/08-23/09) `[DERIVATO da trades_auto.csv]`: campione che non dice nulla.
8. **CLASSE**: **MISTA**: cella H4 **SOPRA (OOS 1,495), C, `[T]`**, **SEGNO INVERTITO** (IS 0,658) = REGIME, **NO PER RISCHIO**; celle TF scan M15 (0,868 su 1415) e M20 (0,975 su 1008) **SOTTO**, B, `[T]` (seconda passata del cancello 05/10). Il PF 1,92 e' finestra piena senza OOS (D3 del piano: "SOPRA (senza OOS)" ma qui l'OOS esiste e lo smentisce nel verso).
9. **VERDETTO**: **NO PER RISCHIO** (DD 22 anni 45,91% a 1% = **10,4 volte** il 4,40% promesso; a 0,25% ~11,5%, ancora oltre il muro) + MERITO SOSPESO (n 67) + SEGNO INVERTITO. Non e' un morto da certificato: e' un **NO per rischio** deciso il 23/08 da Claudio, che vale a qualunque n (Emendamento B).
10. **MIGLIORABILE?** **No sul rischio** (il DD e' un fatto accaduto nei 22 anni). Il merito e' lo stesso fenomeno dell'oro H4 di `ABTG_EMA200` (R264d: IS 2017-23 0,81-0,84, OOS 2024-26 1,22-1,65).
11. **COSA SERVE**: la stessa misura 'G0 col binario `0953846c`' della sez. 1.1 (8-10 min) per sapere se l'IS negativo e' storico o regime; nessuna griglia nuova. Taglia/rischio: firma di Claudio. **Non si ripropone come sedia.**
12. **COSTO**: ~8-10 min, PC di backtest.
13. **FONTI**: `report/CENSIMENTO_CONTRATTI_v2.md` r.313 (4b) · `backtest_pipeline/risultati_archivio/R100_REFERTO.md` · `CLASSIFICA_PF.md` #6 · CSV sopra. **Conflitto fra fonti** (D3/D4 del piano): bt 1,92 (finestra piena) contro IS 0,658 / OOS 1,495 (stesso EA, finestra spezzata): **non e' una contraddizione**, e' la media di un periodo in cui il primo 40% perde e il secondo guadagna.

---

### 1.3 `ABTG_EMA200_Multi_BANCO`   famiglia: EMA200   gruppo: G2   ruolo: copia di banco (mandato 01/10: "indici e oro", due ordini pendenti, size fisse o %, multi-simbolo e multi-TF da un solo grafico)

1. **MOTORE**: cuore identico a `ABTG_EMA200` (1.411 righe); aggiunge InpSymbols/InpTFs, lotti fissi per ordine o rischio %, Guardian fail-open nel tester. **Non e' una sedia, non ha taglia approvata**; rifiuta i conti reali e i conti di campo (blocchi nel codice).
2. SIMBOLI/TF: parametrizzabili; **nessuna cella provata**.
3. BACKTEST FATTI: **nessuno** (nessun CSV, nessuna riga di registro; v0.10).
4. ANNI/REGIMI: **NON MISURATO**.  5. NUMERI: **NON MISURATO**.  6. MERCATI: **NON MISURATO**.  7. FORWARD: nessuno (non e' una sedia).
8. **CLASSE**: **NON MISURATO**, aff. D (non applicabile).
9. **VERDETTO**: **NON ANCORA MISURATO**. **Certificato**: (1) PF **manca** · (2) n e DD **manca** · (3) uscita **manca** · (4) gemelli: provati solo con `ABTG_EMA200` · (5) TF: idem. **Cosa manca: tutto, per costruzione** (e' uno strumento di banco).
10. MIGLIORABILE? **non ancora misurabile** (e' un contenitore).
11. **COSA SERVE**: un round di banco con il cuore identico alla 771531 per riprodurre al centesimo l'OOS 1,52365 (cancello G0) **prima** di qualunque cella di lotti fissi: ~1 min per 2 passate [STIMA 0,1 min/passata]. Firma: no per la misura; **si'** per qualunque taglia.
12. COSTO: ~1-5 min, PC di backtest.  13. FONTI: header del sorgente (README in testa); `report/CENSIMENTO_CASELLE_VUOTE_2026-09-22.md`.

---

### 1.4 `standalone/ABTG_EMA200.mq5`   famiglia: EMA200   ruolo: copia 'tutto-in-uno' (08/09)

1. **MOTORE**: stesso cuore (380 righe contro 690). **Diff fatta oggi sui soli `input`** (D12 del piano): **9 input in meno** nello standalone (`InpUsaGuardian`, i quattro `InpUseAdrFilter/AdrDays/AdrDistMin/AdrDistMax`, `InpFridayClose`, `InpFridayCloseHour`, `InpLogImbuto`) e **tutti gli altri identici per nome e default**. La **logica** non e' diffata riga per riga `[NON VERIFICATO]`.
2-7. nessuna misura propria; eredita le righe di `ABTG_EMA200` **solo per le celle che non toccano i 9 input** (tutte, salvo Guardian/ADR/Venerdi').
8. **CLASSE**: **NON MISURATO (EREDITA)**.  9. **VERDETTO**: NON ANCORA MISURATO in proprio; certificato 0/5.  10. MIGLIORABILE: no (non e' un candidato; e' una copia).
11. COSA SERVE: niente, salvo una diff di logica se qualcuno volesse usarla. 12. COSTO: ~10 min di lettura. 13. FONTI: `diff` degli `input` di `mql5/Experts/ABTG_EMA200.mq5` e `standalone/ABTG_EMA200.mq5`, 05/10.

---

## 2. FAMIGLIA SUPERWAVE

**Fonti comuni**: `backtest_pipeline/REGISTRO_TEST.md` r.722-760 (SuperWave 26/07 e validazione real-tick) · `report/CENSIMENTO_CONTRATTI_v2.md` 4a e 4b (r.306, r.317) · `report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` sez. 5-6 (solo parti backtest) ·
`report/SUPERWAVE_LE_56_PASSATE_FERME_2026-09-23.md` · `backtest_pipeline/risultati_archivio/R110_REFERTO.md`, `REFERTO_ROUND50_REGIME.md`, `REFERTO_ROUND59_REGIME_CAMPIONE.md`, `R103_REFERTO_FINALE.md` ·
`report/H4_M3_CONFLUENZA_MISURA_2026-10-01.md` · `report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md` A27-A31, A90 · CSV `risultati_prove/ABTG_SuperWave/`, `risultati_prove/dal_vps/ABTG_SuperWave*/`, `risultati_archivio/SuperWave/`, `risultati_prove/trades_candidati_r23/`.
**Motore (una frase per tutta la famiglia)**: incrocio EMA14 x EMA200 accettato solo se concorde col Supertrend (ATR 10, moltiplicatore 2,5-3,5); ingresso frazionato (un terzo subito, il resto a pendenti di 20 pip), stop sull'estremo delle ultime 5 barre piu' buffer, TP1 1R 50%, TP finale 2-3R, trailing sul Supertrend (`mq5` 766-774 righe).

---

### 2.1 `ABTG_SuperWave` (nativo)   famiglia: SW   gruppo: G2   ruolo: sedia 770531 U30USD H2 (candidata/demo), 770532 GBPUSD H2 **SPENTA 24/08**

1. **MOTORE**: vedi sopra, versione nativa (cella `StMult` 3,5 / `TP_RR` 2 sui candidati H2).
2. **SIMBOLI / TF**: scan 11 TF (M15-D1) su U30USD, D30EUR, GBPUSD, NASUSD, SPXUSD, XAUUSD, USDJPY, 225JPY, GBPJPY (tick e OHLC); cella di contratto **U30USD H2**; candidato GBPUSD H2. Strumenti collegati: `ABTG_MIS_SIZING_SWDOW` (misura del sizing, non una sedia), ombra SuperWave v4.1 (specifica 05/10, nessun codice).
3. **BACKTEST FATTI**: (a) 26/07 screening OHLC griglia 3x3 (StMult 2,5/3,0/3,5 x TP 2,0/2,5/3,0) su 7 simboli/TF; (b) **R23 (d, e)** walk-forward a tick 100.000, 1%: `ABTG_SuperWave_{U30USD,GBPUSD}_{IS,OOS}_r23{d,e}.csv` + per-trade `trades_candidati_r23/` (88 deal / 50 pos U30USD, 63 / 39 GBPUSD, **ricontati da me**); (c) **scan TF a 11 TF** tick+OHLC IS/OOS su 9 simboli (cella StMult 3,5 / TP 2); (d) **R50 / R56 / R59** prova di regime a barre M1 esterne 2018-2024 (GBPUSD_EXT, 2,55 milioni di barre, scarto dal feed BCM 0,0041-0,0052%) su SW GBPUSD H2 StMult 3 / TP 2; (e) **R103** 6,5 anni OHLC GBPUSD H2; (f) **R126d** NASUSD H1 a tick (9 celle).
4. **ANNI e REGIMI**: U30USD H2: IS 2024.09.26-2025.06.09 (32 deal), OOS 2025.06.10-2026.06.17 (ultima chiusura nel per-trade) = **un regime**. **GBPUSD H2 e' l'unica cella di G2 con i 4 regimi misurati**, a barre: **laterale 2019: PF 0,80 su 61 (-938, DD 3,23%) · crollo 2020 (3 mesi): PF 1,07 su 17 (+115) / anno intero: 0,86 su 69 (-1.055) · toro 2021: PF 0,56 su 65 (-3.187, DD 5,48%) · orso 2022: PF 0,96 su 51 (-205, DD 4,04%)** `[B]` R59; **0 regimi su 4 con PF>=1,10**. Il fuori campione a tick (1,837 su 63 deal) fa +3.560; nel toro 2021 stesso numero di operazioni, **segno opposto**.
5. **NUMERI per cella**

| cella | PF IS | PF OOS | n IS | n OOS | DD IS | DD OOS | note |
|---|---:|---:|---:|---:|---:|---:|---|
| U30USD H2 `[T]` (R23d, magic 770521/22) | **5,571** | **1,762** | 32 deal | 88 deal = **50 pos** (PF per posizione 1,845, 36 vinte) | 1,55% | **4,27%** (equity CSV) | DD censimento **2,96%** [non riconciliato]; mio ricalcolo a saldo chiuso dal per-trade 3,31% `[DERIVATO]` |
| GBPUSD H2 `[T]` (R23e, 770523/24) | 1,833 | 1,837 | 30 deal | 63 deal = **39 pos** (PF per pos 1,894) | 1,81% | 2,29% | candidata B25; **SPENTA 24/08**; il per-trade fa +3.615,90 contro +3.559,59 del CSV (scarto 56,31 `[NON RICONCILIATO]`, swap? `[INFERITO]`): il PF per pos 1,894 non e' al centesimo (U30USD invece si': 4.371,06 = CSV) |
| GBPUSD H2 6,5 anni `[B]` (R103) | -- | **0,79** | -- | -- | -- | **13,4%** (12,9x il promesso) | profit -7.501; **5 anni su 7 negativi** |
| TF scan U30USD `[T]` (StMult 3,5, TP 2) | M15 1,236 · M30 1,204 · H1 1,106 · **H2 5,937** · H3 3,181 | M15 1,012 · M30 0,931 · H1 1,058 · **H2 1,734** · H3 0,525 | 270 / 122 / 75 / **22** / 12 | 551 / 290 / 137 / **61** / 37 | 5,4 / 4,8 / 5,1 / 2,0 / 2,8% | 8,5 / 8,5 / 4,8 / 5,5 / 8,4% | **fra i TF con n OOS >=30 deal, H2 e' l'unico con IS e OOS entrambi >1,10, ma con n IS 22 deal: picco isolato fra vicini H1 1,058 e H3 0,525, non altopiano** (H6-D1 hanno n 0-8: nessun PF leggibile) `[DERIVATO dalla riga TF]` |
| D30EUR H1 / H4 (scan) | 0,546 / n/d | 0,892 / 1,054 | 80 / 8 | 149 / 46 | 6,3 / 1,0% | 8,9 / 3,3% | H1 morto (max 0,84 a barre, DD 17%) |
| NASUSD H1 (R126d, 9 celle) | 0,71-1,13 | **0,73-0,84** | 35-38 | 58-63 | 1,72% | 2,7-3,2% | FAIL G3+G4: PF OOS <1,10 su 9 celle su 9; n OOS <95 |
| NASUSD H4 · XAUUSD H1/H4 · SPXUSD · USDJPY · 225JPY · GBPJPY | scan | OOS mediano 0,69-0,97 | -- | -- | -- | -- | NASUSD H4 n 16-18 negativo; oro ~1,0 / negativo; USDJPY OOS 0,81, 225JPY 0,80 |

6. **TIPOLOGIE superate**: classi: **indice** (Dow H2, a campione sottile) e **forex** (GBPUSD H2 a tick, ma a barre e per regime **non regge**); oro e Nasdaq no. Regimi: solo il rialzo; GBPUSD: 0/4 a barre.
7. **FORWARD DEMO**: **770531** U30USD 13 posizioni (14 righe), netto **-41,68**, 3 vinte, PF 0,81 (19/08-09/09) `[DERIVATO da trades_auto.csv]`; frequenza 0,18 pos/giorno promessa. **770532**: spenta, **zero operazioni in tutto il file**. Campione sottile.
8. **CLASSE**: **MISTA**. U30USD H2: **SOPRA, C, `[T]`** (PF IS 5,57 su 32 deal = **indizio, non lettura**: n IS <30 posizioni). GBPUSD H2: SOPRA a tick, **SOTTO a barre su 6,5 anni** -> regime. D30EUR H1, NASUSD H1/H4, oro: **SOTTO**.
9. **VERDETTO**: U30USD H2 = **MERITO SOSPESO** (50 pos) + DD non riconciliato (4,27 contro 2,96%). GBPUSD H2 = **NO PER RISCHIO a 6,5 anni** (13,4% contro 1,04% promesso; spenta) e segno che cambia col regime. **Certificato per le celle SOTTO**:

| cella | (1) PF | (2) n e DD | (3) uscita ad asse | (4) gemelli | (5) TF | verdetto |
|---|---|---|---|---|---|---|
| NASUSD H1 | 0,73-0,84 `[T]` | 58-63 / 2,7-3,2% | **MANCA** (solo sul Dow, R120) | U30USD, D30EUR, GBPUSD... | M15-D1 (scan) | NON ANCORA MISURATO (manca la 3) |
| D30EUR H1 | 0,84 max `[B]` | n/d / 17% | **MANCA** | idem | scan | NON ANCORA MISURATO; **ma DD 17% > 10% a qualunque n** |
| oro H1/H4 | ~1,0 / negativo `[B]` | n/d | **MANCA** | idem | H1/H4 | NON ANCORA MISURATO ("l'oro rende col SupRev, non col cross") |

10. **MIGLIORABILE?** **U30USD H2: non ancora misurabile** (n 50 pos; una sedia da 0,18 op/giorno promesse non arriva a 150 posizioni in OOS prima di due anni). Il motore va bene SOLO sul Dow (H1 e H2) e fa PF 1,8-1,9 su GBPUSD H2 solo a tick 21 mesi.
11. **COSA SERVE**: (a) **per-trade con la cella H2 su finestra piu' lunga**: storico Dow esterno (firma F1, 90-348 h) -> unica via per salire di n e di regimi; (b) riconciliare il DD 2,96 / 4,27% (lettura, zero macchina: diff fra aggregazione e `Equity DD %`); (c) uscita ad asse su H2 (TP1Pct, TP1_R, BE, TP_RR: **i file di SW H1 non valgono per H2**): ~10 passate x 0,10 min = ~1-2 min + 2 min di avvio per round; (d) GBPUSD: 4 regimi a **tick** non esistono (i tick forex BCM partono dal 07/2024): **non misurabile finche' non c'e' storico a tick**. **NON si fa**: griglie nuove sul motore su Nasdaq/DAX/oro.
12. COSTO: sopra; PC di backtest.  13. FONTI: sopra. **Conflitti**: R50 dava il toro 2021 -2.419 / PF 0,63 / n 63; R59 (stesse celle, finestra piu' ampia) **-3.187 / 0,564 / 65**: uso R59 (la piu' recente, "riproduce al centesimo le quattro finestre di R56"). La riga 'U30USD H2' del censimento dava DD 2,96%, il CSV 4,27%: **non riconciliato**.

---

### 2.2 `ABTG_SuperWave_DOW_H1_Ottimizzato`   famiglia: SW   gruppo: G2   ruolo: sedia 770511 U30USD H1 (cella 'Pass 3' del 26/07)

1. **MOTORE**: SuperWave su Dow H1, `StMult` 2,5, `TP_RR` 3,0, trailing sul Supertrend **acceso**, uscita sul flip (inerte quando il trailing e' acceso), `InpTP1Pct` 50, ingresso frazionato (774 righe).
2. **SIMBOLI / TF**: U30USD H1 (cella); gemelli: NASUSD H1 (R126d), D30EUR H1/H4, XAUUSD, SPXUSD; TF: **sulla cella Ott il TF non e' mai stato cambiato** (R190b M30 vs H1: preparato, mai lanciato); sul **SuperWave nativo** (stesso motore, StMult 3,5) esiste la scan a 11 TF (sez. 2.1) e a M30 su U30USD: IS 1,204 su 122 / OOS 0,931 su 290 (scartata: OOS in perdita e n IS 122 <150).
3. **BACKTEST FATTI**: (a) **26/07 validazione real-tick, FINESTRA PIENA** 2024.01-2026.06 nominale, 9 celle (3x3), **9/9 positive**, PF 1,14-1,52, DD 4,0-5,4%, n 209-227 deal; **la cella di contratto (Pass 6, StMult 2,5 / TP 3,0, PF 1,52140) e' la cella a PF PIU' ALTO della griglia**: **picco, non centro** (le celle vicine fanno 1,26-1,41); (b) **split IS/OOS** (corsa `r3` del 26/07, 10.000): IS 1,849 (84 deal, DD 3,73%) / OOS **1,328** (143 deal, DD 3,91%); (c) **r120b11 (12/09, 10.000, stessa cella, 41 input su 41 identici)**: IS 1,482 (72) / OOS **1,243** (131), DD 4,04 / 4,17%; **r120e11 (100.000)**: 1,397 (106) / 1,220 (184), DD 3,48 / 4,21%; (d) **R120b/e: 2x2 completo `InpTrailOnST` x `InpExitOnFlip`** a tick, due banchi: **il trailing sul Supertrend porta l'edge** (spento: IS 1,489 -> 0,903, RF IS -0,18; OOS profit sale 273,91 -> 344,12 mentre il DD scende 6,23 -> 4,17%); `InpExitOnFlip` **inerte** a trailing acceso (OOS identico cifra per cifra); (e) R126a/b (lookback 5): "ancora grado C", PF IS 1,48166 contro 1,84892; (f) R110: lato short.
4. **ANNI e REGIMI**: finestra 2024.09.26-2026.06.30 a tick (il nominale 2024.01 non ha tick indici prima del 26/09): **un solo regime**; IS ~8,5 mesi, OOS ~12,7. **NON MISURATO** fuori dal rialzo. Stagione/orologio: la sedia **non ha ingressi orari** (`InpUseTimeWindow=0`): non e' sfasata dall'orologio; il proxy 770521 (cella H2, non questa) fa PF 5,83 / 1,23 fra mesi allineati e sfasati `[DICHIARATO]`.
5. **NUMERI**: PF IS/OOS **1,849 / 1,328** (archivio 26/07) **oppure 1,482 / 1,243** (12/09): **CONTESA**. DD OOS **3,91% oppure 4,17%** (r120e11 a 100k: 4,21%) a 1%; DD promesso: banda **3,91-4,21%**; **n posizioni `NON MISURATO`**, forbice **62-143** (stima ~81 col fattore 1,76 della gemella H2 = 0,294 pos/giorno). Costo: stop = **38,5x** lo spread (96% della frontiera), **minimo delle gambe misurate 12,7 idx = 6,3x, sotto il pavimento DURO 13,3x**. Short: OOS **0,429** su 84 deal (profit -6.090, DD 7,53%).
6. **TIPOLOGIE**: indice Dow H1 solo; Nasdaq H1: 0/9; DAX H1 0,84 a barre.
7. **FORWARD DEMO**: **770511** U30USD **14 posizioni** (16 righe: 2 aperture con uscite parziali), netto **+344,33**, 10 vinte, **PF 16,8** (27/07-09/09) `[DERIVATO da trades_auto.csv]`. **PF 16 su 14 posizioni e' un'eccezione di campione**, non una misura: **frequenza 0,516 contro ~0,294 promesse**.
8. **CLASSE**: cella di contratto = **NON MISURATO (CONTESA)** (piano 5.2.6); lato short = **SOTTO, C**; celle d'uscita R120 a trailing spento (b00 0,903 / 1,187 su 90; e00 0,978 / 1,284 su 130) = **SOPRA (OOS) con SEGNO INVERTITO, C** (seconda passata del cancello 05/10). Provvisoria del piano: SOPRA. Nota: **entrambe le versioni sono sopra 1,20 in OOS**.
9. **VERDETTO**: **NON ANCORA MISURATO** per contesa + **MERITO SOSPESO** (n pos <150 in ogni lettura: 62-143) + **FRAGILE sul costo** (38,5x; minima gamba 6,3x) + rischio dentro 10% (3,91-4,21% a 1%). Il contratto e' contestato **non per colpa dei parametri**: stesso EA, stessi 41 input, stesso deposito: cambia il **binario** (26/07 `a4107cf` contro `872dba82` del 19/09 che contiene il fix del pavimento del lotto) **oppure** lo storico tick ricaricato. **Certificato (cella)**: (1) PF contesa · (2) DD ok, n pos **manca** · (3) uscita: TrailOnST/ExitOnFlip **fatti**; TP1Pct, TP1_R, BE, TP_RR, SLBuffer, TF M30: **7 file (30 celle / 60 passate) gateati il 16-19/09 e MAI lanciati** (0 CSV con i loro magic) · (4) gemelli: NASUSD, DAX, oro, SPX provati · (5) TF: **sulla cella Ott NON provato** (R190b mai lanciato); sul motore nativo si': scan a 11 TF.
10. **MIGLIORABILE?** **Si'**: (i) riconciliare il contratto, (ii) mettere ad asse l'uscita rimasta, (iii) provare il TF intermedio H2? (la cella gemella H2 ha IS 5,6 su n piccolo: picco). **Per merito: non ancora misurabile** (n pos, regime).
11. **COSA SERVE**: (a) **riconciliazione**: rilanciare la cella 00 sul binario `872dba82` (quello che vola) alla stessa finestra e deposito **con l'export per-trade acceso** = ~1 min di tester (B2+B3 del contratto): dice quale dei due numeri e' il contratto e conta le posizioni **gratis**; firma: no; (b) **i 7 file preparati**: 30 celle / 60 passate = **34,1 minuti** (non 4,7: avvio 2,0 min x 7 round), `@DAQUANDO 2024.09.26` verificato, tutti e due i cancelli PASS il 23/09; **sospesi in coda dal 21/09** (regola 'i round non girano piu' sul VPS', firma 21/09): serve una riga di lancio sul **PC di backtest**, non sul VPS; firma: no (taglia invariata); (c) **DD fra binari** a deposito 80.000/100.000: ~1 min; (d) prova di regime Dow: **firma F1**, 90-348 h. **NON si fa**: manopole di ingresso fuori dall'altopiano; il trailing OFF **non va provato** (misurato: vince acceso).
12. COSTO totale (a+b+c) **~40 min** su PC di backtest.  13. FONTI: `CONTRATTI_DELLE_SEDIE_FTMO` sez. 5-6 (parti backtest) · `SUPERWAVE_LE_56_PASSATE_FERME` §1-2 · `R126*` in `LETTURA_BACKLOG_NOTTE_2026-09-13.md` · CSV `risultati_prove/dal_vps/ABTG_SuperWave_DOW_H1_Ottimizzato/` · `risultati_archivio/SuperWave/valid_SuperWaveRT_U30USD_H1_realtick.csv`. **Conflitti dichiarati** (3): contratto 26/07 contro 12/09 contro 100k; "1,52" della classifica 26/07 = finestra piena; il dossier dice "n posizioni non misurato (84/143 uscite)" **e** "stimo ~81": uso la forbice 62-143.

---

### 2.3 `ABTG_SuperWave_DAX_H4_Ottimizzato`   famiglia: SW   gruppo: G2   ruolo: 770512 D30EUR H4, **NON IN CAMPO**, ripescata 08/09 per frequenza

1. **MOTORE**: come 2.1/2.2 su DAX H4, `StMult` 3,0 / `TP_RR` 2,0 (737 righe).
2. **SIMBOLI / TF**: D30EUR H4; DAX H1 morto (max 0,84, DD 17%); Nasdaq H4 morto (n 16-18); Dow H4 StMult 3,5 PF 2,5 su **23** operazioni (screening).
3. **BACKTEST FATTI**: 26/07 OHLC screening griglia; **validazione real-tick, FINESTRA PIENA**, 9 celle (`valid_SuperWaveRT_D30EUR_H4_realtick.csv`), 1%, 7/9 positive; nessuno split IS/OOS; scan TF 11 TF a tick del file Ott (`InpStMult`=3 nel CSV): H4 OOS **1,064 su 48** deal (IS n=8), M15-H3 OOS 0,61-0,96 (seconda passata 05/10: qui c'era "StMult 3,5: 1,054 su 46", che e' la riga D30EUR H4 dello scan del SW **nativo**, sez. 2.1 `[INFERITO]`).
4. **ANNI/REGIMI**: nominale 2024.01-2026.06 (i tick indici partono 2024.09.26): **un regime**; **DAX esterno 2010-18 (~8 anni, 1,72 milioni di barre M1) scaricato e mai importato**: prova di regime sul DAX in specifica (770101/770105; SW DAX H4 **non** nell'elenco).
5. **NUMERI** (cella contratto, Pass 1): **PF 1,285 · n 56 deal (nessuna chiusura parziale rilevata nel contratto: 56 pos) · DD 3,32% · +277,69**; le 9 celle: PF 0,86-1,28, DD 3,3-4,9%, n 54-59; frequenza **0,12 op/giorno**.
6. TIPOLOGIE: indice DAX H4 solo.  7. **FORWARD**: mai in campo -> nessun dato.
8. **CLASSE**: **MISTA**: contratto **SOPRA (senza OOS)**, C (n 56), `[T]` finestra piena; TF scan M15-H3 **SOTTO** (OOS 0,61-0,96, n 56-630), `[T]`.  9. **VERDETTO**: **MERITO SOSPESO** (56 <150) + frequenza fuori pavimento di famiglia; **la cella di contratto (Pass 1, StMult 3,0 / TP 2,0, PF 1,285) e' la cella a PF PIU' ALTO della griglia 3x3** (le altre: 0,86-1,246): **picco, non centro** (regola "centro, mai il picco" non rispettata); l'altopiano e' 7 celle su 9 positive e **crolla a 0,86 a StMult 3,5 con TP 2,5/3,0**.
10. **MIGLIORABILE?** **non ancora misurabile**: il numero che manca e' il campione; la regola del 07/09 dice che una sedia sotto 1,00 op/giorno non e' scartabile per sola frequenza se la famiglia arriva al pavimento, ma torna **in coda, mai in campo in automatico**.
11. **COSA SERVE**: storico DAX piu' lungo (importazione DAX 2010-18 + qualita' del feed: orologio spostato di un'ora, regole della specifica Regime DAX) -> n e regimi; **firma**: l'importazione e' lavoro di dati (nessuna spesa) ma l'uso come prova di regime e' soggetto alle firme D-J/D-K/D-L della specifica Regime DAX.
12. COSTO: ore di calcolo per l'import (non misurate); le passate su M1 esterne 0,1-0,5 min.  13. FONTI: `CENSIMENTO_SCARTATI_PROSA` A31 · `RIPESCAGGIO_FREQUENZA_2026-09-08.md` R1 · `CORSIA_DEMO_SUPERWAVE_DAX_*` · `CLASSIFICA_PF.md` #13 · CSV sopra.

---

### 2.4 `ABTG_SuperWave_EA`   famiglia: SW   gruppo: G2   ruolo: variante A (Supertrend H4 + inversione M3, a mercato, 3 target 40/30/30); magic 990001, D30EUR M3 sul demo

1. **MOTORE**: direzione dal Supertrend H4 (ATR 10, molt. 3,5); ingresso quando il Supertrend M3 **si inverte nello stesso verso**; stop sulla linea del Supertrend M3 con floor in ATR; tre target a livelli di price action, 40/30/30 con break-even (376 righe).
2. SIMBOLI/TF: D30EUR, grafico M3; nessun'altra cella.
3. **BACKTEST FATTI**: **nessun PF dell'EA** (nessuna riga in `REGISTRO_TEST`, nessun CSV col suo nome). **Misura d'effetto** sul meccanismo: `H4_M3_CONFLUENZA_MISURA_2026-10-01` su DAX (HistData 2010-18), oro A 2006-20 e oro B 2021-26, S&P secondario, orizzonti 30-240 min.
4. ANNI/REGIMI: DAX 2010-18 (~8 anni), oro 2006-2026 (feed Oanda, non BCM); regimi non isolati.
5. **NUMERI**: effetto del segnale a 60 minuti da **-0,018 a +0,015 ATR(H1)** (IC95 a blocchi di giorni dentro **[-0,043; +0,041]**), n 2.638-9.473 per cella: **6 celle su 6 NULLO** (DAX long **al filo**: 21 semi su 40 darebbero ZONA GRIGIA negativa). Il costo pesa **2-4 volte** qualunque effetto; rendimento medio netto a 60 min **negativo in 6 celle su 6** (-0,016/-0,093 ATR H1); P(+1R prima di -1R) 0,491-0,534; aspettativa netta **-0,035/-0,130 R** per operazione.
6. MERCATI: nessuno.  7. **FORWARD DEMO**: 990001 D30EUR **5 posizioni** (13 righe: uscite parziali dei 3 target), netto **-29,22**, 3 vinte, PF 0,58 (28/07-07/08) `[DERIVATO da trades_auto.csv; il conteggio per righe sarebbe 13, per aperture 5]`.
8. **CLASSE**: **NON MISURATO**, aff. D.  9. **VERDETTO**: **NON ANCORA MISURATO** per l'EA; **NULLO** per il timing di confluenza H4/M3 (misura d'effetto). **Certificato**: (1) PF **manca** · (2) n e DD **manca** · (3) uscita ad asse **manca** (il 3o scaglione `InpTP3_R` non e' mai stato provato) · (4) gemelli: la misura d'effetto copre DAX e oro, non l'EA · (5) TF: il meccanismo **nasce** su M3 (TF piu' caro della scala): per l'EA **mancante**.
10. **MIGLIORABILE?** **No sul timing** (6/6 NULLO, il costo mangia l'effetto). L'EA come PF: non ancora misurabile.
11. **COSA SERVE**: un round a **tick** sul solo D30EUR M3 (2024.09.26-2026.06.30; il tetto di ~100.000 barre del tester da' circa 1,3 anni a M5, quindi **~0,8 anni a M3 [DERIVATO]**: la finestra va spezzata in tranche e dichiarato) per dare **un PF** al "nessun PF"; ~2-10 min [STIMA]; la misura d'effetto dice che l'attesa e' **PF <1**. **Costo/beneficio basso**: va fatto solo per chiudere il certificato (non per cercare edge). Firma: no.
12. COSTO: ~10 min.  13. FONTI: `H4_M3_CONFLUENZA_MISURA` (punti 1-3) · `CENSIMENTO_CASELLE_VUOTE_2026-09-22.md` r.84 ("misurato, 40 CSV" si riferisce ai CSV di `ABTG_SuperWave` nativo, **non** di questo EA) · `AUDIT_USCITE_2026-09-09.md` r.180.

---

## 3. FAMIGLIA ORB

**Fonti comuni**: `report/CENSIMENTO_ORB_2026-09-29.md` (intero: tabella, sez. 3-11) · `report/ORB_NASDAQ_PERCHE_E_SPENTO_2026-09-23.md` · `report/LETTURA_ORB_R271_R272_R273_2026-09-29.md` · `docs/PER_GEMINI_LONDRA_E_NIGHTLY_2026-09-28.md` · `backtest_pipeline/REGISTRO_TEST.md` r.800-862 (finestra del range) · `report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` (parti backtest) · `report/OROLOGIO_BCM_2026-09-24.md` 5.2 · CSV `risultati_prove/ABTG_ORB*/`, `risultati_archivio/r88_csv/`.
**Regola della famiglia (CENSIMENTO_ORB, punto 3)**: il **breakout nudo al tocco e' chiuso** con i numeri nostri (R12 48/48 negative, R45 0/48, R97 0/4 con n=135, ~210 celle); **quello che paga e' il RETEST** (famiglia Apertura, G1) e, sul Dow, il breakout filtrato con EMA H4. "ORB = chiusi" e' vero per il **breakout secco**, non per la famiglia.
**Orologio** (vale per `ABTG_ORB`, `ABTG_ORB_Ottimizzato`, `Londra_ORB`): BCM e' UTC+1 fisso; dal 02/11 (USA) il range 14:30-14:45 srv cade prima dell'apertura cash. **Nessun numero di contratto e' pulito da questo**; fase d'inverno `NON MISURATO` sull'ORB.

---

### 3.1 `ABTG_ORB`   famiglia: ORB   gruppo: G2   ruolo: 'marginale' nativo Nasdaq M5, sedia 770601 **spenta il 10/08** (bug `InpOneTradePerDay` non letto, non per il rendimento)

1. **MOTORE**: breakout stop del range dei **5 minuti PRE-apertura** (14:25-14:30 srv), due lati, filtro volumi opzionale, stop OPPRANGE (`SLMode` 0) (949 righe).
2. SIMBOLI/TF: **solo NASUSD M5** (8 CSV, mai su un altro simbolo); range 5' (R7a) / 35' (R7b) / 30' con volume (R8).
3. **BACKTEST FATTI**: R7a, R7b, R8 `risultati_prove/ABTG_ORB/ABTG_ORB_NASUSD_{IS,OOS}_r{7a,7b,8}.csv` (tick, 1%, deposito non dichiarato nei CSV; finestre IS/OOS standard); R44b `[ORB_Ott]`; screening OHLC `..._ohlc.csv`. **Registro O1 "PF 1,15 / DD 16% / 625 tr" NON riproducibile dai CSV in repo** (C6 del censimento): il 1,15564 e' di `ORB_Ottimizzato r44b`.
4. ANNI/REGIMI: 21 mesi, un regime; **NON MISURATO** fuori. Il range 5' e' "dentro il rumore per costruzione".
5. **NUMERI** (`[T]`): **R7a config viva: IS 0,824 (n 222, DD 24,84%) / OOS 1,050 (n 355, DD 19,41%)**; R7b (range 35): IS 1,057 (244) / OOS 0,931 (379, DD 6,13%); R8 (volume ON, range 30): IS 1,49 (177) / OOS 1,03 (190, DD 4,85%), volume OFF OOS 0,984 (381); costo: stop 47,70 idx = **26,5x** BCM, 31,2x con spread di un'altra piattaforma `[DERIVATO]`: **sotto 40x**.
6. TIPOLOGIE: Nasdaq M5 solo; **nessuna cella con IS e OOS entrambi >=1,10 e DD sotto 10%**.
7. **FORWARD DEMO**: **770601** NASUSD 20 posizioni (20/07-10/08), netto **+351,51**, 10 vinte, PF **1,85** (poi -86,40 su 7 posizioni dal 03/08, **PF 0,54**): **stessa sedia, due finestre: n=20 vale zero** `[DERIVATO; DICHIARATO dal referto 23/09]`.
8. **CLASSE**: **MISTA**: R7a OOS 1,050 -> **SOPRA solo nominale** (la differenza da 1 sembra dentro l'errore tipico, ma la soglia di zona grigia **D2 del piano NON e' firmata**: segnalato, non deciso); R7b OOS 0,931 e R8 volume OFF 0,984 -> SOTTO. Aff. **B** (n OOS >=150, un regime), **IS INVERTITO** in R7a e R8.
9. **VERDETTO**: **NO PER RISCHIO** (DD 19,41-24,84% a 1%, a qualunque n) + SOPRA solo nominale; **certificato**: (1) PF si · (2) n e DD si · (3) uscita **MANCA** (`InpBreakeven`, `InpUseTrailEMA`, `InpTP1Pct`, `InpExitOnEmaClose` **mai ad asse**) · (4) gemelli **MANCA** (mai su un altro simbolo) · (5) TF **MANCA** (`InpExecTF`=M5 in tutte le passate): **NON ANCORA MISURATO**, non morto.
10. **MIGLIORABILE?** **non so / no sul rischio**: il filtro volumi e' l'unica leva che ha migliorato tutti e 4 i confronti in entrambe le finestre (R8), ma su `ORB_Ottimizzato` NASUSD **non ha mai morso** (24 coppie su 24 identiche): "l'abbiamo provato" voleva dire "l'abbiamo girato senza che cambiasse niente".
11. **COSA SERVE**: gemelli (almeno un simbolo diverso), uscita ad asse, `InpExecTF`; **non** altri parametri di ingresso (regola 19/08). ~6-12 passate = ~1 min [0,10 min/passata]. Firma: no. Il bug `InpOneTradePerDay` e' un lavoro di codice prima di qualunque riaccensione.
12. COSTO: ~1-2 min + compilazione.  13. FONTI: `CENSIMENTO_ORB` righe 12 e M12, C6, C7, V8 (CSV riletti: identici) · `ORB_NASDAQ_PERCHE_E_SPENTO` §2.

---

### 3.2 `ABTG_ORB_Ottimizzato`   famiglia: ORB   gruppo: G2   ruolo: **sedia 770611 U30USD M5 solo long** (la "ORB Dow")

1. **MOTORE**: breakout stop del **primo quarto d'ora** (14:30-14:45 srv = 15 min) del Dow, **solo long**, filtro EMA200, stop OPPRANGE/HALFRANGE (variante 'mezzo range' = riferimento), trailing EMA9; una operazione al giorno (1.483 righe).
2. **SIMBOLI / TF**: U30USD M5 (cella). Gemelli **provati e negativi**: NASUSD (R97), D30EUR (R11), XAUUSD (R10), forex; EURAUD H1 (istanza di campo mai misurata: `InpEntryPoints` 10,0 x `InpK` 1,0 = +10,0 **in prezzo** su un cambio a 1,62 -> **zero riempimenti**, nessuna misura). **TF: `InpExecTF` = M5 in tutte le 216 passate**; l'etichetta "M30" di r133b e' sbagliata (C5: i numeri sono identici alla cella M5 di R88a).
3. **BACKTEST FATTI**: **R15 (09/08)** IS 1,223 (71) / OOS 1,657 (119), DD 8,63 / 9,92%, a 10.000; **R88a / R118a (banco 100.000, 1%)** `risultati_archivio/r88_csv/..._U30USD_{IS,OOS}_r88a.csv`: HALFRANGE IS 1,250 (71) / OOS **1,674** (119), DD 7,89 / **9,76%**; OPPRANGE+buffer 500: OOS 1,8385, DD 3,84%; solo `SLMode` 3->0: OOS 1,680, DD 4,30%; R54b short; R55 slippage; R97/R11/R10 gemelli. **R125 (66 passate, ~7 min): preparato, mai girato**.
4. **ANNI/REGIMI**: tick 2024.09.26-2026.06.30 (IS ~8,5 mesi, OOS ~12,7); **un solo regime**; **n invariante 71 IS / 119 OOS in tutte le 48 celle** (il buffer sposta lo stop, non decide se si entra). **Orologio dal 02/11: `NON MISURATO`** (il range 14:30 diventa 8:30 NY). **Per-trade in repo** (`risultati_prove/trades_portafoglio/abtg_trades_ABTG_ORB_Ottimizzato_U30USD_770612.csv`, **ricontato da me**: 119 deal = 119 posizioni, PF **1,6742**, +41.057,00 = R88a OOS al centesimo, vincite 48 su 119 = 40,3%, 2025.06.11-2026.06.29, DD a saldo chiuso 9,72%, peggior giornata **-1.780 su 100.000**): divisione per stagione (mesi di chiusura, bordi a ±1 settimana) **73 pos PF 1,65 contro 46 pos PF 1,70**: **nessun divario stagionale visibile** `[DERIVATO]`. **Concentrazione**: gennaio-febbraio 2026 valgono +20.091 su +41.057 (49%); senza febbraio PF **1,56 su 107**, senza gennaio e febbraio **1,44 su 99** (regge); ottobre-novembre 2025 e marzo e maggio 2026 sono negativi.
5. **NUMERI** (n = posizioni: nessuna chiusura parziale, 119 contate dal file per-operazione):

| cella | PF IS | PF OOS | n IS | n OOS | DD IS | DD OOS | note |
|---|---:|---:|---:|---:|---:|---:|---|
| **HALFRANGE (sedia)** 100k | **1,250** | **1,674** | 71 | **119** | 7,89% | **9,76%** | banco 10k: 1,223 / 1,657, DD 8,63 / 9,92% |
| OPPRANGE (stop all'estremo opposto) | 0,93-1,09 (0/12 celle >1,10) | 1,68 | 71 | 119 | -- | **4,30%** (3,70-5,87% su 12/12 vs 7,96-12,02% HALFRANGE) | **non passa il cancello IS**; il buffer 500 e' un picco su 5 metriche su 5 |
| solo SHORT (R54b) | -- | **0,52** | -- | -- | -- | **26,4%** | **SOTTO** |
| NASUSD (R97, 4 geometrie, tick) | 1,13-1,32 | **0,84-0,91** | -- | 135 | -- | 8,2-12,4% | R13 "primo altopiano" 1,10-1,16 **smentito** da R97 |
| D30EUR (R11) | -- | 0,94-1,02 | -- | -- | -- | 17,5-29,7% | 11 ribaltamenti IS/OOS, Spearman -1,0 |
| XAUUSD (R10, 4 celle) | 0,60-1,003 | 0,87-0,999 | -- | 173-376 | -- | 3,5-8,6% | nessuna cella verde in entrambe |

6. **TIPOLOGIE**: indice **Dow** long solo; Nasdaq, DAX, oro, forex **no**. Regimi: solo il rialzo.
7. **FORWARD DEMO**: **770611** U30USD **8 posizioni** (11/08-03/09), **1 vinta**, netto **-209,18**, **PF 0,27**; un referto le attribuisce 15 posizioni / 3 vinte / -295,58 ma quelle sono **tutta la famiglia ORB** (7 Nasdaq + 8 Dow): `NON` della sola ORB Dow `[DERIVATO da trades_auto.csv + dossier B2 sched. 7]`. **Campione sottile: non decide.**
8. **CLASSE**: Dow long = **SOPRA, C, `[T]`** (n OOS 119 pos). Gemelli/short = **SOTTO** (B/C). EA = **MISTA**.
9. **VERDETTO**: Dow long: **MERITO SOSPESO** (119 <150) + **rischio al muro** (DD OOS 9,76% a 1%, "passa il 10% per 8 centesimi"; **con slippage 1,5 punti il DD sfonda il 10% `[DICHIARATO]`**) + **costo 29,5x** (sotto la frontiera 40x, sopra il duro 13,3x) + **regime `NON ANCORA MISURATO`**. **Certificato per le celle SOTTO**:

| cella SOTTO | (1) PF | (2) n e DD | (3) uscita ad asse | (4) gemelli | (5) TF | verdetto |
|---|---|---|---|---|---|---|
| NASUSD breakout | 0,84-0,91 `[T]` | 135 / 8-12% | stop, TP, trailing: provati; BE, `AtrSLmult`, `SLFixedPts`: **mai** su NASUSD | provati (D30EUR, oro, forex) | **MANCA** (M5 ovunque) | **NON ANCORA MISURATO** nel certificato |
| short | 0,52 `[T]` | n/d / 26,4% | **MANCA** | -- | **MANCA** | NO PER RISCHIO a qualunque n; lato **mai un asse** (216 passate (1,1)/(1,0)/(0,0)) |
| D30EUR / oro | 0,87-1,02 `[T]` | 17-377 / 3,5-30% | parziale | solo se stessa ricetta | **MANCA** | idem |

10. **MIGLIORABILE?** **Si', in due direzioni diverse e opposte per valore**: (i) **rischio**: OPPRANGE dimezza il DD (4,30% contro 9,76%) ma l'IS e' 0,93-1,09 (0/12 celle >1,10): non passa; (ii) **prova**: TF diverso da M5 e gemelli sul Dow (NASUSD/SPXUSD/D30EUR) **mai** provati con questa ricetta. Sul merito: **non ancora misurabile** (n 119, un regime).
11. **COSA SERVE**: (a) **R125** (6 file, 33 celle, 66 passate, **~7 min**): preparato, **non produce una sedia** (dichiarato nei suoi criteri), serve a leggere l'altopiano OPPRANGE; (b) **TF**: `InpExecTF` M5 -> M10/M15 sul solo Dow: ~4-8 passate = ~0,4-0,8 min [0,10 min/passata]; il costo cambia **a favore** di stop piu' larghi; (c) **gemelli sul Dow**: NASUSD/SPXUSD/D30EUR **con questa cella**: 6 passate = ~0,6-1,2 min; (d) **prova di regime Dow** (firma F1, 90-348 h); (e) l'**orologio**: il per-trade 770612 c'e' (divisione per stagione fatta sopra: nessun divario), ma **nessun numero descrive il range 14:30 dopo il 02/11** (ingresso un'ora prima dell'apertura cash): una corsa con `@ORARIO_INVERNALE` (classe 763 risolta) **e' la misura che manca**, ~2 passate = ~0,2 min. **Firma di Claudio**: solo per (d) e per qualunque taglia (DD al muro: taglia = firma; ricordare che l'istanza su EURAUD H1 e' un difetto di configurazione, non una misura). **NON si fa**: griglie sull'ingresso breakout (regola 19/08).
12. COSTO: (a)+(b)+(c) **~8-10 min**, PC di backtest.  13. FONTI: `CENSIMENTO_ORB` righe 13-15, M13-M15, V7, V10 (CSV riletti identici) · `CONTRATTI_DELLE_SEDIE_FTMO` e `CENSIMENTO_CONTRATTI_v2` (costo 29,5x; parti backtest) · `trades_auto.csv`. **Conflitti**: C5 (etichetta M30), C7 (forward 3 su 15 contro OOS: finestre diverse, campione 15), registro 04/09 (range "14:25-14:30 per entrambe": **falso per ORB_Ott**: 14:30-14:45).

---

### 3.3 `ABTG_ORB_Fibo`   famiglia: ORB   gruppo: G2   ruolo: 'morto' (osservazione), mai in campo; magic 770602/770603

1. **MOTORE**: OR 30', la rottura fissa la **direzione**; ingresso con **LIMIT nella Golden Zone 50-61,8%**, stop al 78,6% = un **retest**, non un breakout (564 righe).
2. SIMBOLI/TF: **NASUSD M5** (OR 30' e `InpExecTF` M5 in tutte); mai su altro simbolo.
3. **BACKTEST FATTI**: screening **OHLC** IS/OOS (1 passata utile per finestra; l'asse dei CSV e' il magic); **R272 (29/09) a TICK REALI**, 10.000, cella di default, gemelle G1 identiche, `ROUND_ORB_R271_2026-09-29/`.
4. ANNI/REGIMI: 21 mesi, un regime; PF per regime `NON MISURATO`.
5. **NUMERI**: **tick: IS 0,803 (91 deal, DD 4,32%) / OOS 0,851 (75 deal, DD 3,66%)**; OHLC: 0,835 / 0,968 (91 / 75, DD 3,02 / 3,10%). **Il tick peggiora** (fattore OHLC->tick misurato su altra famiglia: 2,25). n OOS 75 <150. Costo derivato 9,1x BCM / 10,7x altra piattaforma: **sotto il duro 13,3x**. Deposito 10.000: il lotto puo' stare sul pavimento (DD non "a rischio 1%").
6. TIPOLOGIE: nessuna.  7. FORWARD: mai in campo.
8. **CLASSE**: **SOTTO**, C, `[T]`, **nessuna delle due finestre sopra 1**.
9. **VERDETTO**: **SOTTO 1, non ancora morto**; **ESCLUSO PER COSTO** (9,1x <13,3x) a qualunque PF. **Certificato**: (1) PF si (tick) · (2) n e DD si · (3) uscita **MANCA** · (4) gemelli **MANCA** · (5) TF/`InpORMinutes` **MANCA**.
10. **MIGLIORABILE?** **No su questa cella** (il lettore: "nessuna ragione per spendere altre celle"): il costo la chiude prima del PF. **Si' solo per completare il certificato.**
11. **COSA SERVE**: 3 caselle = **~1-2 min** (0,10 min/passata) **se** si vuole la lapide valida; con stop piu' larghi (OR piu' ampio) il costo potrebbe rientrare: **nessun numero**. Firma: no.
12. COSTO: ~1-2 min.  13. FONTI: `LETTURA_ORB_R271_R272_R273` (R272) · `CENSIMENTO_ORB` riga 16, M16, V9 · `ORB_NASDAQ_PERCHE_E_SPENTO` §2.

---

### 3.4 `ABTG_Londra_ORB`   famiglia: ORB   gruppo: G2   ruolo: 'morto' (osservazione), mai in campo

1. **MOTORE**: canale 06:00-07:00 srv, ingresso al breakout con buffer, tre ore di sessione provate (7, 8, 9), soglia minima del range (`InpMinRangePips`) (490 righe).
2. SIMBOLI/TF: **GBPUSD, EURUSD, M5**; ore 7/8/9; asse della soglia di range.
3. **BACKTEST FATTI**: **R45 (14/08)** GBPUSD M5 a tick: 0/48, DD 23%, ma con `InpRangeStartHour=7` (la **pre-apertura**: il difetto del fuso, 03/09); **R258 (28/09)**: 24 file (blocchi T/G/B/D/F a tick, walk-forward IS/OOS, deposito 10.000, scansione di `InpMinRangePips` F=0..., gemelli M30, buffer, inizio range; blocco L a barre OHLC dal 2008 `[non letto qui]`); commissione addebitata verificata (992 deal, -2.560 EUR). **Nulli veri: 2 file su 36** (R258k, R258s: **una gamba** assente per guasto del tester "OnTesterInit works too long": R258k ha solo IS, R258s solo OOS). **La console della riga scrive NULLO su altri 22 file di R258 (24 in tutto con i due veri): e' un artefatto del parser** (virgola in `InpNewsCurrencies` sposta le colonne, classe 883): il lettore ricuce le colonne e dichiara **P0 VERDE** (592 confronti) e T1/X1/S1 VERDI; `HANDOFF.md` r.88-89: "fa fede il lettore". Numeri validi.
4. **ANNI/REGIMI**: tick forex BCM dal ~07/2024 (finestre IS/OOS **non dichiarate** nella nota: `NON VERIFICATO`); screening OHLC 2008-2024 (blocco L: **non letto qui**, n/d); regimi `NON MISURATO`.
5. **NUMERI** (OOS tick, n deal ~300, DD a deposito fisso):

| simbolo | ora | PF IS / OOS | DD IS / OOS | n OOS | stop mediano | costo |
|---|---:|---|---|---:|---|---|
| GBPUSD | 7 | 0,70 / **0,74** | 34,6 / 54,9% | 306 | 3-8 pip | ESCLUSO PER COSTO |
| GBPUSD | 8 | 1,05 / **0,97** | 19,9 / 38,2% | 296 | 8-13 pip | escluso (13,3x) |
| GBPUSD | 9 | 0,80 / **0,82** | 29,7 / 32,3% | 294 | 13-18 pip | FRAGILE |
| EURUSD | 7 | 0,65 / **0,87** | 35,1 / 37,0% | 306 | 3-8 pip | ESCLUSO PER COSTO |
| EURUSD | 8 | 1,18 / **0,91** | 15,7 / 30,0% | 296 | 8-13 pip | escluso (13,3x) |
| EURUSD | 9 | 0,83 / **0,70** | 26,4 / 53,0% | 293 | 8-13 pip | escluso (13,3x) |

   Le righe sopra sono `InpMinRangePips`=0 (default del sorgente). **Corretto dal cancello 05/10**: a F=10 GBPUSD ora 8 fa **IS 1,088 (156) / OOS 1,034 (253)**, DD equity 14,17 / 23,32% (`ROUND_R258a/*_OOS_R258a.csv` pass 1; `LETTURA_ROUND_CORTI_A_2026-09-28.md` r.201: "BOCCIATA PER RISCHIO", costo 9,5-15,5x) = cella **SOPRA nominale** con n OOS >=150; EURUSD ora 7 F=10: 0,819 (49) / 1,123 (116), SEGNO INVERTITO; **R258w** GBPUSD ora 8 con `InpRangeStartMin`=30: IS 0,788 (202) / OOS 1,091 (304), DD equity 35,28 / 12,48% = SEGNO INVERTITO, NO PER RISCHIO (seconda passata 05/10: era fuori anche dalla correzione). Da F=20 in su il campione scende **sotto 100 operazioni** salvo GBPUSD ora 9 (150, PF 0,822). L'ora **non decide** (delta PF 0,33 a n~300 = rumore). Un'ipotesi da PDF ("Londra apre alle 7 server") **non confermata**.
6. TIPOLOGIE: nessuna.  7. FORWARD: mai in campo.
8. **CLASSE**: **MISTA**: **SOTTO**, **B** (n>=150, un regime), `[T]`, **6 celle su 6 OOS <1 a F=0**; **SOPRA nominale** GBPUSD ora 8 F=10 (1,034 su 253, B, NO PER RISCHIO).
9. **VERDETTO**: **NO PER RISCHIO** (DD 30-55% a deposito fisso, a qualunque n) + **ESCLUSO PER COSTO** a 4 celle su 6 + **SOTTO 1, non ancora morto**. **Certificato**: (1) PF si · (2) n e DD si · (3) uscita **MAI ad asse** (in mano a Gemini dal 28/09) · (4) gemelli: GBPUSD ed EURUSD **si** · (5) TF: **si'**: R258g/R258h su grafico **M30** = riga F=0 di R258a/R258d su M5 **al centesimo** (T1 VERDE, `LETTURA_ROUND_CORTI_A` r.177-178): il TF del grafico e' **inerte** per questo motore (range a orario). **Cosa manca: la casella 3** (le assi `InpMinRangePips`/buffer/`InpRangeStartMin` sono d'INGRESSO, non d'uscita). Corretto dalla seconda passata 05/10: qui c'era "TF: M5 solo, manca la 5".
10. **MIGLIORABILE?** **non so**: il DD a deposito fisso e' enorme (30-55%): con un deposito vero e rischio % la lettura cambierebbe di scala ma non di segno (PF <1).
11. **COSA SERVE**: uscita ad asse (parziale, BE, trailing, stop in ATR): ~12-24 passate = **~1-2,5 min** (un TF diverso NON serve: il TF del grafico e' inerte, T1); le due gambe perse per guasto (R258k/R258s: una gamba ciascuno, l'altra c'e') da rilanciare: ~0,2 min. **Il blocco OHLC 2008-2024 (screening) non e' stato letto**: da leggere (zero macchina); la seconda passata 05/10 vi vede celle OOS >1 `[B]` (R258o F=20 1,074 su 355; R258s F=20 1,089 su 528, F=30 1,334 su 136, **senza gamba IS**; DD equity 29-31% sulle prime due), da leggere con IS e regime prima di qualunque giudizio. Firma: no.
12. COSTO: ~3 min.  13. FONTI: `docs/PER_GEMINI_LONDRA_E_NIGHTLY_2026-09-28.md` · `CENSIMENTO_ORB` riga 25, M25, C4 · `ROUND_CORTI_A_2026-09-28/` (RIEPILOGO). **Conflitti**: registro O4 "Londra ORB non ha MAI avuto un CSV" **dopo** R258: **la riga e' da correggere**; "sigillato" non regge.

---

### 3.5 `ORB_OpeningRange`   famiglia: ORB   gruppo: G2   ruolo: esterno semplice (generico)

1. **MOTORE**: chiusura confermata oltre il range di 30 min, RR 2, rischio 1% (533 righe).
2-7. **Nessuna misura**: nessun CSV in tutta la storia git; "duplica famiglie ORB gia' sepolte"; il meccanismo (chiusura confermata) e' quello di R8/R10/R11 gia' misurato "pareggio". Offset CET `ServerToCET` fisso a 0: non segue l'orologio BCM.
8. **CLASSE**: **NON MISURATO**, aff. D.  9. **VERDETTO**: **NON ANCORA MISURATO**. Certificato: (1) PF **manca** · (2) **manca** · (3) **manca** · (4) **manca** · (5) **manca**: **0/5**.
10. MIGLIORABILE: **non ancora misurabile** (non e' un candidato).
11. **COSA SERVE**: 4 passate (M6 del censimento, D30EUR e U30USD) = **~0,4-0,8 min** per dare **un numero** al "nessun CSV"; attesa scritta: PF OOS 0,9-1,05. Firma: no.
12. COSTO: <1 min.  13. FONTI: `CENSIMENTO_ORB` riga 22, M21-M22, §6 M6.

---

### 3.6 `ORB_DAX_BASE_EA` e `ORB_DAX_PM_EA`   famiglia: ORB   gruppo: G2   ruolo: esterni (toolkit del webinar 02/03/2026)

1. **MOTORE**: OR 09:00-09:30 CET (BASE) / 15:30-16:00 CET (PM); trigger = chiusura M5 oltre il range + filtro EMA9/21; **rischio di default 3%**, RR 2,5 (703-704 righe). `InpBrokerCETOffset` **fisso** a 0.
2-7. **Nessuna misura**, nessun CSV in tutta la storia; "bozze mai integrate" (giacimento 03/09).
8. **CLASSE**: **NON MISURATO**, aff. D.  9. **VERDETTO**: **NON ANCORA MISURATO**; certificato **0/5**.
10. MIGLIORABILE: **non ancora misurabile**.
11. **COSA SERVE**: una passata per EA sul DAX M5 con il rischio portato a 1% **e l'offset CET portato sull'orologio BCM** (dal 26/10 d'inverno cambia): ~0,2-0,4 min; **prima** la lettura del cancello sull'offset (come per l'oro v3.21). Firma: no per la misura; **si'** per qualunque rischio sopra 1%.
12. COSTO: <1 min.  13. FONTI: `CENSIMENTO_ORB` righe 21, M21-M22.

---

## 4. COSA MIGLIORARE PER PRIMA (max 5 misure, ordinate per VALORE / COSTO; nessun criterio abbassato; nessuna griglia su motori senza edge)

| # | misura | cosa chiude | EA toccati | costo (PC di backtest, mai VPS) | firma? |
|---:|---|---|---|---|---|
| 1 | **IS in posizioni della 771531**: ricaricare il per-trade di `cemad02` dal VPS **oppure** una corsa sola (gamba IS, magic vergine, 100.000) | D1 del piano: la riga IS **132** diventa un numero ricontabile (oggi forbice 103-237) | `ABTG_EMA200` | **0 macchina** (trasferimento) o **~45 s** | no |
| 2 | **Riconciliare il contratto di SW 770511**: cella 00 sul binario `872dba82`, stessa finestra e deposito, **export per-trade acceso** | contesa 1,849/1,328 contro 1,482/1,243 (DD 3,91 contro 4,17%) **e** le **posizioni** (oggi forbice 62-143) | `SuperWave_DOW_H1_Ott` (e la lettura dei dubbi su SW H2) | **~1 min** + 2 min di avvio | no |
| 3 | **G0 dell'oro col binario `0953846c`** (separa H_BINARIO / H_STORICO / H_SPEC) | sblocca 12 griglie SALTATE (GBPJPY/GBPUSD/AUDJPY H4) e rende confrontabile l'OOS 1,22-1,65 dell'oro: oggi "o regime o storico" non separati | `ABTG_EMA200`, `EMA200_Ottimizzato` | ~4 job x 2,1 min = **~8-10 min** [STIMA da R264] | no |
| 4 | **SW 770511: i 7 file gia' pronti** (TP1Pct, TP1_R, BE, TP_RR, SLBuffer, TF M30) | casella (3) del certificato su una sedia SOPRA, in una sola corsa; costi e frontiera del TF | `SuperWave_DOW_H1_Ott` | **34,1 min** (30 celle / 60 passate; 2,0 min x 7 round di avvio) | no (taglia invariata; sospesi in coda dal 21/09 per la regola dei round fuori dal VPS) |
| 5 | **Prova di regime del Dow** (P0 -> P1 -> firma F1 -> download -> prova): l'unica misura che porta un EA indice da B ad A | **regimi** `NON MISURATO` su tre EA di G2 (EMA200 Dow H1, SW Dow H1, ORB Dow) e su G1 | `ABTG_EMA200`, `SuperWave_DOW_H1_Ott`, `ABTG_ORB_Ottimizzato` | **90-348 ore di calcolo** [DICHIARATO] | **SI' (F1: spesa/storico)** |

**Fuori classifica (a costo bassissimo, da fare per completezza, non per cercare edge)**: certificato di `ABTG_ORB_Fibo` (~1-2 min) · uscita ad asse e TF di `ABTG_Londra_ORB` (~3 min) · R125 e TF M10/M15 dell'ORB Dow (~8-10 min) · un PF per `ABTG_SuperWave_EA` a tick (~10 min).
**Fuori dall'elenco per regola**: griglie sull'ingresso breakout dell'ORB (motore senza edge dichiarato, 19/08); gemelli indice di `ABTG_EMA200` a H1 (EMAGEM2 li ha chiusi); griglie sull'oro H1 (IS negativo su 30 celle su 30).
Ordine di valore: la 5 vale di piu' di tutte, ma costa la firma e giorni di calcolo; le 1-3 costano meno di 15 minuti in totale e **tolgono tre ambiguita'** (IS n, contesa, causa del ROSSO) prima di spendere sulla 5.

---

## 5. PUNTI DUBBI NUOVI (oltre D1-D13 del piano; "chi lo chiude" accanto)

| id | punto | chi lo chiude |
|---|---|---|
| G2-1 | **D1 resta aperto**: 132 posizioni IS di 771531 `[MISURATO FUORI REPO, artefatto assente]`; nuova prova: la gemella senza parziale non conta le posizioni (165 contro 257) | misura 1 della sez. 4 |
| G2-2 | **Unita' del dossier**: "OOS estate 2,05 su 169 uscite, inverno 0,87 su 88" = **posizioni** (169+88=257), non uscite; il censimento scrive 347 e 170 deal | dossier da correggere (zero macchina) |
| G2-3 | **Forward demo: il conteggio per righe sovrastima le posizioni** quando c'e' un'uscita parziale: 770511 16 righe = 14 posizioni; 990001 13 righe = **5** posizioni; 770531 14 = 13. Il contratto di `770511` usa "16 posizioni" | chi tiene la tabella forward; stessa regola per tutto il resto del progetto |
| G2-4 | **DD di 770531 (SW H2)**: 4,27% (Equity DD % del CSV) contro 2,96% (censimento) contro 3,31% (saldo chiuso dal per-trade, mio) | lettura: diff della definizione (equity contro saldo chiuso, deposito) |
| G2-5 | **La cella di contratto di SW 770511 e' il PICCO della griglia 3x3** (Pass 6, PF 1,52140; vicini diretti 1,264 e 1,407, diagonale 1,163: `valid_SuperWaveRT_U30USD_H1_realtick.csv`), non il centro: regola "centro, mai il picco" | misura: R155a/R191b (gia' gateati) mettono `TP_RR` ad asse |
| G2-6 | **Il TF H2 di SW U30USD ha n IS 22-32 deal**: PF IS 5,57-5,94 e' rumore di campione; **non e' un altopiano** (H3 0,525 OOS, H1 1,058) | storico Dow piu' lungo |
| G2-7 | **R50 contro R59** sul toro 2021 di SW GBPUSD (-2.419/0,63/63 contro -3.187/0,564/65): usato R59 (piu' recente, riproduce R56) | verifica del per-trade R50 (non in repo?) |
| G2-8 | **Londra ORB**: le date IS/OOS di R258 e il blocco OHLC 2008-2024 non sono nella nota letta | lettura del REFERTO_ROUND_R258* |
| G2-9 | **D2 (zona grigia del PF) morde 3 volte in G2**: ORB nominale 1,050; ORB R8 1,03; SW Dow 1,243 | soglia da fissare **prima** di riempire i verdetti (Claudio / cancello) |
| G2-10 | **`EMA200_Ottimizzato` H4: IS 0,658 su 39 deal** e **tutti i TF IS <1**: il PF 1,92 del 26/07 va letto come finestra piena in cui il primo 40% perde | G0 col binario `0953846c` (misura 3) |
| G2-11 | **La console della riga dice "R258 NULLO" su 22 file ma il lettore li dichiara validi** (virgola di `InpNewsCurrencies`, classe 883); un lettore che si fermasse alla console classificherebbe `Londra_ORB` come NON MISURATO (e' la provvisoria del piano) | gia' chiuso da `HANDOFF.md` r.88-89 e da `LETTURA_ROUND_CORTI_A`; da scrivere nel registro (O4 e R258) |
| G2-12 | **Il PF 16,8 forward di SW 770511 (14 pos) e il PF 1,85 forward di `ABTG_ORB` (20 pos, poi 0,54 su 7)** mostrano che con n 14-20 il forward oscilla da 0,27 a 16,8: non va in nessuna classifica | regola gia' scritta (colonna a parte) |
| G2-14 | **Celle sopra 1 rimaste fuori dalla tabella riassuntiva nella prima stesura** (trovate dal cancello 05/10): `ABTG_EMA200` DAX H4 1,133 / 1,052 (n 40 / 156 deal) e `ABTG_Londra_ORB` GBPUSD ora 8 F=10 1,088 / 1,034 (156 / 253). La prima e' il gemello indice che EMAGEM2 **non** ha chiuso: n IS sottile, non un morto | DAX H4: IS piu' lunga (storico DAX esterno, specifica Regime DAX); Londra F=10: nessuna, NO PER RISCHIO |
| G2-15 | **Magic 971501 compare su AUDCHF** in `trades_auto.csv` (30/09 e 01/10, 2 righe) oltre alle 13 XAUUSD: collisione di magic o riuso `[NON VERIFICATO]`; le righe XAUUSD della sez. 1.2 restano 13 fino al 23/09 | chi tiene la tabella forward |
| G2-16 | **G2 contro G3 sulla stessa cella `Londra_ORB`** (seconda passata 05/10): classe **uguale** (MISTA: SOTTO a F=0, SOPRA nominale/formale a F=10), DD su metri diversi ma etichettati (G2 equity CSV 14,17 / 23,32%; G3 DD_fisso 15,35 / 27,18% da `LETTURA_ROUND_CORTI_A` r.201). **Discordi nel certificato**: G3 4.15 scrive casella (3) "parziale" citando `InpMinRangePips`/buffer/`InpRangeStartMin`, che sono assi d'**ingresso**: per G2 l'uscita resta **MAI ad asse**. G3 cita R258w, G2 la cita da questa passata; G2 cita EURUSD ora 7 F=10, G3 no | allineare G3 4.15 (non toccato da questa passata) |
| G2-13 | **Il per-trade 770612 di `ORB_Ottimizzato` e' in `trades_portafoglio/`, non in `r88_csv/`**: il censimento ORB dice "119 ricontate dal file per operazione" senza dire dove | nota di percorso (zero macchina) |

---

## 6. CONTROLLI FATTI SU QUESTO DOCUMENTO (contro-esempio, prima della consegna)

- **Numeri ricontati da me dalla fonte primaria** (non solo copiati): per-trade R112 `pertrade_00_metro_763400.csv` -> **517 deal / 257 posizioni / PF 1,5237 / vincite 60,7%** (= contratto); per-trade R23 SW -> **88 / 50** (U30USD) e **63 / 39** (GBPUSD); per-trade ORB_Ott 770612 -> **119 pos, PF 1,6742, +41.057** (= R88a OOS); CSV di R23d/e, scan TF SW, TF scan `EMA200_Ottimizzato`, valid SW U30USD e DAX H4: PF/n/DD riletti; forward per magic da `trades_auto.csv`.
- **Contro-esempi costruiti**: (1) "771531 e' sopra 1 grazie a un mese": tolto settembre 2025, **PF 1,33 su 230 posizioni**: regge; (2) "il forward in righe e' il numero di posizioni": **no** (G2-3); (3) "la classe SW 770511 provvisoria SOPRA regge": **non** secondo 5.2.6, ma entrambe le versioni >1,20 (dichiarato); (4) "ORB nominale SOPRA": 1,050 sta dentro l'errore: dichiarato; (5) "gli EA standalone ereditano": diff degli input -> 9 input in meno, **logica non verificata** (dichiarato).
- **Cosa NON ho fatto**: non ho riaperto R97, R125 (mai girato), i CSV R234 (non in repo), le specifiche Regime DAX/Nasdaq; nessun round; nessuna riga di lancio; **nessun numero e' stato mandato a nessuno**. **Questo file non e' passato dal cancello.**

---

## CHANGELOG
| data | cosa | perche' |
|---|---|---|
| 05/10/2026 | creato il file (FASE 2, G2: EMA200 + SuperWave + ORB, 14 righe / 15 file) | richiesta di Claudio del 05/10/2026 sul resoconto PF sopra/sotto 1 per ogni EA, gruppo G2 del piano |
| 05/10/2026 | cancello di giudizio (`controllo-preventivo`): FAIL corretto. Aggiunte le celle DAX H4 (EMA200) e Londra GBPUSD ora 8 F=10; `Londra_ORB` -> MISTA, SOPRA da 6 a 7, EA in tutte e due le liste da 4 a 5; oro H1 e NASUSD M30 riclassificati SOPRA (OOS) con SEGNO INVERTITO (stessa regola di `EMA200_Ottimizzato`); D2 marcata "non firmata"; vicini SW 770511 corretti (1,264/1,407); banda costo 771531 e per-trade SW GBPUSD dichiarati non riconciliati; nota 2,00% trial (informativa) | contro-esempio: celle SOPRA classificate o omesse come SOTTO |
| 05/10/2026 | seconda passata indipendente del cancello (`controllo-preventivo`) sulle correzioni: 9 punti riletti alla fonte e confermati (EMAGEM2 DAX H1/H4, 770511 r3 e r120b11, griglia 3x3 1,52140 con vicini 1,407/1,264, 770612 119 pos 1,6742 e 1,44 su 99, R7a, R272, R112 517/257/1,5237, R258a F=10, per-trade SW GBPUSD). **Trovato e corretto**: la classe 1127 ricadeva nel verso SOTTO (`EMA200_Ottimizzato` M15/M20 e `SuperWave_DAX_H4_Ottimizzato` TF scan sotto 1, fuori dalla lista SOTTO) e nel verso SOPRA (`SuperWave_DOW_H1_Ottimizzato` R120 b00/e00 SEGNO INVERTITO; `Londra_ORB` R258w): **SOPRA 7 -> 8, SOTTO 7 -> 9, in entrambe 5 -> 8**; certificato `Londra_ORB` casella 5 = si' (TF inerte, T1); SW DAX H4 scan 1,054/46 -> 1,064/48; R258k/s una gamba; D2 non firmata anche in sez. 3.1; GBPUSD 16,5 anni SEGNO INVERTITO; nuova G2-16 (discordanza col certificato di G3) | contro-esempio: una cella SOTTO omessa fa sembrare "solo SOPRA" un EA che ha anche celle perdenti |
