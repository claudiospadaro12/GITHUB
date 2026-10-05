# ADDENDUM AL CONSOLIDATO: COSA CAMBIANO I CSV TRASPORTATI - 05/10/2026

> **BOZZA, NON PASSATA DAL CANCELLO.** Strato 1 (`controlla_riga.py --oggetto md`) e strato 2 (`controllo-preventivo`) da fare prima che esca verso chiunque. Niente di questo file va a Claudio ne' al VPS senza un PASS. Nessuna riga di lancio dentro.
> **Cosa e'**: un ADDENDUM a `report/RESOCONTO_EA_CONSOLIDATO_2026-10-05.md` (qui "il consolidato"). **Non riscrive** il consolidato, **non riscrive** i sette gruppi G1-G6b, **non corregge** nessun documento sbagliato: dice cosa cambierebbe, con il rimando.
> **Perche' esiste**: il consolidato e i sette gruppi scrivevano "NON MISURATO" o `[DICH]` per molti round perche' i loro CSV non erano nel repo. Il 05/10 Claudio li ha trasportati (254 CSV in `backtest_pipeline/risultati_prove/dal_vps/`, transcript in `backtest_pipeline/risultati_archivio/TRASPORTO_CSV_20261005/`) e tre letture, tutte passate dal cancello `controllo-preventivo` (PASS CON RISERVE), li hanno letti:
> **A** = `report/LETTURA_CSV_TRASPORTATI_A_FOREX_2026-10-05.md` (G4 forex + PTE + SupRev 225JPY e oro; 82 CSV) - **B** = `report/LETTURA_CSV_TRASPORTATI_B_SEDIE_2026-10-05.md` (sedie e candidate G1, G2, G3, G5; 134 CSV) - **C** = `report/LETTURA_CSV_TRASPORTATI_C_CACCE_2026-10-05.md` (G6a cacce breakout; 38 CSV).
> **REGOLA FERREA**: **nessun numero nuovo.** Ogni cifra in questo file viene da A, B, C o dal consolidato, e accanto c'e' il rimando (lettura + sezione o riga; consolidato + sez. o `#` di riga). Le uniche cose mie sono **i conteggi della sez. 2** (ricalcolati con uno script che rilegge i quattro file: Appendice A), l'**ordine** delle tabelle, e le righe marcate **[ADDENDUM]** (incrocio di due fonti gia' scritte, mai una misura). Dove le tre letture e il consolidato si contraddicono lo scrivo (sez. 7).
> **Perimetro**: sola lettura d'archivio. Nessun round lanciato, nessun backtest, VPS non toccato, nessun EA / preset / parametro / taglia / conto toccato, nessun documento esistente modificato. Nessuna soglia abbassata, nessun rischio o taglia proposto da noi.
> **Stato dei verdetti**: tutto cio' che segue come "dopo la lettura" e' **la proposta del lettore** (V-numerata in A e in B, tabella 5.d in C). **Niente e' applicato**: i conteggi della sez. 2 valgono solo dopo la firma di Claudio sulle etichette (sez. 2.3).
> Legenda dei rimandi: `A 4.2` = lettura A sez. 4.2; `A V4` = riga V4 di A sez. 7; `B 5.f.3` = lettura B sez. 5.f punto 3; `C 5.d` = lettura C sez. 5.d; `cons. #56` = consolidato sez. 1, riga numero 56 del piano; `cons. 3(a)` = consolidato sez. 3(a).

---

## 0. IN 12 RIGHE: COSA CAMBIA

1. **Trasporto**: 254 CSV letti in tre blocchi (A 82 + B 134 + C 38). Dal transcript: 156 nuovi, 35 aggiornati (cifre uguali salvo `r139b` e `r139c`: sez. 3 righe 6 e 17), 63 identici; 191 scritti. Il consolidato dava per non leggibili **35 round di G4 e 6 di G6a** (cons. 3(a)): ora **34 su 35 di G4** (manca solo `r161c`, che sta nell'ARCHIVIO del Desktop VPS) e **6 su 6 di G6a** sono leggibili. **I 5 round di G6b restano non leggibili** (B 7.5; A 9.1). `[ADDENDUM: 35+6+5 = 46 sigle del consolidato; ne restano 6]`
2. **Conteggi proposti** (sez. 2, script in Appendice A): **solo la lettura C sposta classi di riga** (`DaxValueArea` NM -> SOTTO, `Cycle` NM -> SOTTO, `VolExpBreak` NM -> ENTRAMBE; C 5.d). Con screening: SOPRA **59 -> 60**, SOTTO **65 -> 68**, entrambe 53 -> 54, solo SOTTO 12 -> 14, NM **40 -> 37**. Solo tick: SOPRA 57 -> 58, SOTTO 64 -> 67, NM 41 -> 38. **Sono PROPOSTE, non applicate.**
3. **A e B non spostano nessuna classe di riga**: A lo scrive per G4 (A sez. 7, "cosa NON cambia"), B per G1/G2/G3/G5 (B 6). Cambiano celle, etichette, caselle del certificato e numeri (sez. 1).
4. **La correzione piu' pesante e' B su `770250`** (Nasdaq gated short M15): lo "OOS 1,097 su 104" di G1 e' la **finestra piena**. Con lo split: IS **1,257** su 57 deal -> OOS **0,948** su 47 deal = SEGNO INVERTITO, SOTTO, aff. C o D (B 4.3, B V1). La sedia e' ferma dal 25/09.
5. **`770511` (SuperWave U30USD H1)**: il contratto "conteso" si restringe. Due letture su tre sono riprodotte dai CSV (10k **1,482 / 1,243**; 100k **1,397 / 1,220**); **la terza, 1,849 / 1,328, non la riproduce nessuno dei 13 round**. In piu' una cella SOTTO che G2 non elenca (`r120b01`: IS 1,406 -> OOS 0,983). Qualunque cambio alla sedia e' solo di Claudio (B 4.6, B V2).
6. **Larry XAU (`772343`)**: la cella che G4 teneva "SOPRA D" su 21 mesi e' **SOTTO su 22 anni in 14 celle su 14, PF 0,872, n 213, DD 29,74%** (A 4.6, A S4, A S8). Il consolidato la elencava fra le SOPRA dell'oro (cons. 2.1).
7. **Round dati per "mai girati"** ora con i numeri: Dow `770202` r172a-j (69 celle, 10 assi d'uscita; l'ancora riproduce il contratto in 9 round su 10), `ORB_Ott` R125 (64 righe), `SupRev_NAS_H1` R163a (7/7 SOPRA in IS e OOS), `SuperWave_DOW_H1` (5 file su 7), EMA200 `r146b`/`r147a`, `SupRev` 225JPY `r166a` (B 5.f.1-9; A S7).
8. **Le tre cacce NM di G6a ora hanno un numero, e non e' buono**: `DaxValueArea` 8 celle su 8 SOTTO su n 211-407, DD 10,8-38,8%; `Cycle` 12 su 12 SOTTO su n 630-2072, DD 17,1-55,1%; `VolExpBreak` una sola cella SOPRA su 8 in OOS (U30USD kStop 2,5: PF 1,042, n 111, **DD 12,22%** = NO PER RISCHIO per la soglia del file prova) (C sez. 1, 4.2-4.4). **Nessuna e' MORTA**: certificato 2/5 su DaxValueArea e Cycle (C 5.c).
9. **Certificato di morte**: caselle chiuse e ancora aperte EA per EA in sez. 4. In sintesi: la casella 3 (uscita) si chiude **a livello di EA** per BB, C2C, GapFill, GapCont, Larry, EZ (A 6.2) **ma resta aperta per cella** dove l'asse d'uscita non e' mai girato su quella cella (A 9.3). Nessun EA diventa MORTO.
10. **Cosa NON cambia**: regime = uno solo (rialzo) su ogni CSV a tick; **nessuna cella A**; nessuna cella nuova SOPRA a tick con n >= 150 e IS dalla stessa parte: le celle B con IS sotto 1 sono tutte SEGNO INVERTITO (C sez. 3; A sez. 7 "cosa NON cambia").
11. **Smentite**: 41 righe in sez. 3 (documento sbagliato, dove sta la correzione). **Nessun documento e' stato modificato**, ne' dai lettori ne' da me.
12. **Decisioni di Claudio** (sez. 6): `770250`, `770511`, `770202`, `EMA200` breakeven, floor `770101`, taglia Larry XAU, le tre etichette D-1/D-2/D-3 e la lettura dell'asse di stop nel certificato (C-1). **E la scadenza del ~14/10 del consolidato 3(a) non pesa piu' per i CSV trasportati.** `[ADDENDUM: incrocio cons. 3(a) con A sez. 1 e C sez. 1]`

---

## 1. TABELLA PER EA / FAMIGLIA: PRIMA (CONSOLIDATO) E DOPO (LETTURE)

**Come leggerla.** Una riga per ogni EA / famiglia **letta** dalle tre letture (32 righe: A 10, B 13, C 9). `#` e' la riga del piano come nel consolidato sez. 1. La colonna "consolidato" riporta classe e affidabilita' **come scritte nel consolidato**; la colonna "dopo la lettura" **copia** dalla lettura (non ricalcola), con rimando. La colonna "proposta" dice **di chi e'** la proposta di cambio verdetto: **V-numerata** (A V1-V13, B V1-V12: righe numerate delle sezioni "verdetti" delle letture) oppure **del lettore, non V-numerata** (C 5.d, che non numera le sue proposte; oppure frasi "Cambia?" delle schede) oppure **nessun cambio**. L'ultima colonna dice se la **classe di riga** (SOPRA / SOTTO / entrambe / NM) cambia: e' la sola cosa che tocca i conteggi.
Dati: `[T]` tick reali, `[B]` barre (screening), `s.OOS` finestra piena senza OOS, `INV` = SEGNO INVERTITO, n in **deal** salvo scritto, `pos` = posizioni.

### 1.1 Lettura A (G4 forex, PTE, SupRev 225JPY e oro) - 10 righe

| # | EA | consolidato (classe; aff.) | dopo la lettura (copiato dalla lettura) | proposta di cambio | classe di riga |
|---:|---|---|---|---|---|
| 55 | `ABTG_BreakingBand` | ENTRAMBE; D | GBPUSD H1 pattern 2 [B], viva: IS 1999-2012 **0,714 / 261 / 21,95** (SOTTO) -> OOS 2012-2026 **1,123 / 260 / 10,31** (SOPRA) = **INV** (B-scr entrambe); IS 20 celle su 20 SOTTO, OOS 19 su 20 SOPRA. EURUSD **1,075 / 276 / 8,24** SOPRA formale s.OOS. **Casella 3: da "misurata ma illeggibile" a LETTA; 5 caselle compilate a livello di EA**; per cella aperta su M15, M30, AUDUSD. **AUDUSD (`r161c`) NON LEGGIBILE** (A 4.1, 6.2, 9.1) | **V-numerata**: A V2 (casella 3), A V3 (il 27,5 anni 0,897 / n522 scomposto in IS 0,714 / OOS 1,123) | invariata (ENTRAMBE) |
| 56 | `ABTG_CostToCost` | ENTRAMBE; C-screening (r127c: B-screening) | WF R40/R41 sono **tick [T]**, non barre (r146a/r146c identici a r41 al centesimo). EURJPY viva IS **1,016 / 48** (SOPRA formale; IS 8 celle su 9 SOTTO) -> OOS **1,741 / 64 / 9,45**; GBPCAD IS **1,298 / 44** -> OOS **1,443 / 62**; aff. C. r127c [B] OOS 1,523 / 242 / 12,26 (B-scr). **Casella 3 chiusa a livello di EA; aperta per cella** su short, L+S, CHFJPY, XAG, GBPCAD 6,5 anni [B]. NO PER RISCHIO (r127c) invariato (A 4.2, K2, V4) | **V-numerata**: A V1 (etichetta [B] -> [T], aff. C-screening -> C), A V4 (nessun cambio di verdetto) | invariata |
| 57 | `ABTG_EasyTrend` | ENTRAMBE; C | GBPUSD [B]: IS **1,184 / 583** e OOS **1,053 / 254** entrambi SOPRA (B-scr) ma **DD > 14% in 14 celle su 14**; CHFJPY IS **0,824 / 338** -> OOS **1,066 / 265** = INV 7/7, DD 22-35%. La gamba OOS e' la finestra di R103, **non un OOS indipendente** (K3). **Casella 5 (TF) aperta** (A 4.3) | **V-numerata**: A V5 (si arricchisce, nessun cambio) | invariata |
| 59 | `ABTG_GapFill` | ENTRAMBE; D | **4 celle SOTTO su 76** (SLGapMult 0,4 su 3 simboli; MaxHours 12 su U30USD); il resto SOPRA ma su n 11-30 e (salvo r178a) senza OOS = D (U30USD n 30 C al limite). 20-25 trade in 27,5 anni per simbolo forex, **nessuna operazione prima del 1999**. Casella 3 chiusa: **manca solo la 5 (TF)** (A 4.4, S2) | **V-numerata**: A V6 | invariata |
| 60 | `ABTG_GapContinuation` | ENTRAMBE; C | r162a finestra intera 225JPY M1: **9/9 SOPRA**, PF 1,269-1,582, n 84-124 deal, **DD > 10% in 8 celle su 9**; viva **1,385 / 109 / 11,59**. SOPRA s.OOS, C. **NO PER RISCHIO a 1% invariato**. Caselle **4 e 5 aperte** (A 4.5) | **V-numerata**: A V7 | invariata |
| 61 | `ABTG_PunteLarry` | ENTRAMBE; C (U30USD, EURAUD), D le altre | **XAUUSD long [B] 22 anni: 14 celle su 14 SOTTO, PF 0,872 / 213 / 29,74** (G4 lo dava "non pubblicato" e SOPRA D sul WF). EURAUD, EURCAD: IS vecchio **SOTTO 14/14** (DD 40,45 e 18,86), INV sull'OOS; GBPJPY e GBPUSD SOPRA in entrambe le gambe. OOS = finestra R103. Casella 3 chiusa (6 simboli); **manca la 5** (A 4.6, K3, K6) | **V-numerata**: A V8 (la revisione R100 perde la parte "merito ignoto") | invariata (restano SOPRA U30USD, EURAUD, GBPJPY, GBPUSD) |
| 62 | `ABTG_FiboH4_Multi` | ENTRAMBE; C-screening / B-screening | GBPUSD singolo r139c [B] **6/6 SOTTO** in IS e OOS (IS 0,791-0,830; OOS 0,939-0,968; n OOS 725-737 deal): numeri della **versione del 05/10**, diversi da quelli del 13/09 (il runner ha rigirato: K10). Caselle 3 e 5 aperte (A 4.7) | **V-numerata**: A V9 (solo numeri) | invariata |
| 47 | `ABTG_PTE` | ENTRAMBE; D | r153a GBPUSD [B] IS **0,874 / 439** -> OOS **1,088 / 477** deal = INV (6/7); r164a (771322) **0,791 / 414 -> 0,966 / 447** SOTTO in entrambe; r158a U30USD tick 5/7 SOPRA, viva **1,170 / 68** deal (C/D). Certificato invariato (A 4.8) | **V-numerata**: A V10 (solo numeri) | invariata |
| 67 | `ABTG_SupertrendReversal` | ENTRAMBE (15/14/1); C | r166a 225JPY H2 tick, 7/7 SOPRA, PF 1,434-1,848, n 79-89 deal, DD 0,29-0,77% (scala 225JPY, D7), **s.OOS, C**: la cella che il consolidato teneva NM diventa SOPRA s.OOS. Certificato invariato (A 4.9) | **V-numerata**: A V11 | invariata (era gia' ENTRAMBE) |
| 68 | `ABTG_SupertrendReversal_Ottimizzato` | ENTRAMBE (5/1/0); D | r127b oro H4 [B]: valori **identici** a quelli del 13/09 e a G5 U05 (K11); IS 7/7 SOTTO / OOS 7/7 SOPRA (A 4.10) | **V-numerata**: A V13 (nessun cambio) | invariata |

**Non toccati da A** (nessun CSV nelle dieci cartelle): `EasyTrend_EURUSD` (#58), `FiboH4_Corso` (#63), le copie `standalone/` (#64), `BreakoutCorso` (#65), `BREAKOUT_EA_JPY` (#66). Restano come nel consolidato.

### 1.2 Lettura B (sedie e candidate G1, G2, G3, G5) - 13 righe

| # | EA (sedia) | consolidato (classe; aff.) | dopo la lettura (copiato dalla lettura) | proposta di cambio | classe di riga |
|---:|---|---|---|---|---|
| 1 | `ABTG_DAX_Apertura_EU` (770101 long) | ENTRAMBE; B (IS 132 < 150: merito sospeso sull'IS) | 770101 long **riproduce il contratto in 4 round**: 1,126 / 175 / 5,44 -> 1,397 / 270 / 7,23 deal; SOPRA, **aff. B se si accettano le 193 pos** del contratto (dai soli CSV: 270 deal = B o C provvisoria), IS 132 pos < 150. **F40EUR**: IS **1,440 / 130** -> OOS **0,770 / 195** (DD 11,82) = **INV**. Floor `r137a` 6800: 1,233 / 1,420 (B 4.1, 5.c) | **V-numerata**: B V10 (scrivere l'IS di F40EUR), B V11 (citare la misura del floor) | invariata |
| 10 | `ABTG_Dow_Apertura_US` (770202 long) | ENTRAMBE; C | long **SOPRA aff. C** (130 deal < 150). **Ancora = contratto** 1,222 / 74 / 5,67 -> 1,270 / 130 / 4,39 **in 9 round su 10**; **69 celle, 10 assi d'uscita, 138 passate**; nessuna cella batte l'ancora in IS e OOS insieme **salvo TP1_R 1,50 e 1,75**; TP1_R altopiano OOS 1,252-1,294 (da 1,0 a 2,0) (B 4.2, 5.c) | **V-numerata**: B V3 | invariata |
| 14 | `ABTG_Nasdaq_Apertura_US` (770250 gated short M15) | ENTRAMBE; C (14k: B) | `r170a` (ricetta a 0,65%, non il preset di campo a 0,35%): IS **1,257 / 57 / 4,54** -> OOS **0,948 / 47 / 3,63**; 57 + 47 = 104 deal, PF combinato 1,0996: **l'1,097 e' la finestra piena**. **SOTTO, aff. C o D, INV** (B 4.3, 5.c) | **V-numerata**: B V1 (14d da SOPRA C ZONA GRIGIA a SOTTO) | invariata (restano SOPRA 14a = 770260 e 14k) |
| 23 | `ABTG_Nasdaq_Live5m` (770203, spenta) | SOTTO; B provvisoria | 18 celle: OOS sopra 1 in 6 su 18, **nessuna arriva a 1,10** (max 1,070); DD OOS 17,6-34,3% al 2%. Casella 3 chiusa dai **quattro assi** (r150a e' la quarta) (B 4.4) | **V-numerata**: B V12 (nessun cambio di verdetto) | invariata |
| 27 | `ABTG_EMA200` (771531 U30USD H1) | ENTRAMBE; B | 771531 **riproduce il contratto in 7 round**: 1,201 / 237 / 5,73 -> 1,524 / 517 / 7,83 deal; SOPRA **aff. B** (517 deal >= 346), IS 132 pos dichiarato. **`r146b` e `r147a` non citati da G2**: breakeven spento = deal OOS 769 (+49%) a PF 1,528, **profit OOS -31%, DD OOS 8,90 (contro 7,83)**; se sia leva di frequenza e' NON LEGGIBILE (serve il per-trade). AUDJPY H4 [B] SOTTO; GBPUSD H4 [B] SOPRA, INV 4/4 (B 4.5) | **V-numerata**: B V4 | invariata |
| 31 | `ABTG_SuperWave` (770531 U30USD H2) | ENTRAMBE; C | `r154a` finestra piena: PF 2,238-2,565, **n 120 (= 32 + 88)**, DD 3,60-4,29, **SOPRA s.OOS C\***; NASUSD H1 **SOTTO 9/9** (OOS 0,732-0,843, aff. C) (B 4.7) | **V-numerata**: B V9 | invariata |
| 32 | `ABTG_SuperWave_DOW_H1_Ottimizzato` (770511) | NM (CONTESA); short SOTTO; celle R120 SOPRA (INV); C | contratto **CONTESO -> NM** (e' di G2); due letture riproducibili, **SOPRA**: 10k 1,482 / 1,243 (72 / 131 deal), 100k 1,397 / 1,220 (106 / 184); **1,849 / 1,328 non riprodotta da nessuno dei 13 round**. Cella **`r120b01`** (trail OFF, flip ON) IS 1,406 / 71 -> OOS **0,983 / 125** SOTTO, assente dalle liste G2. TP1Pct 0 e 25 e TP1_R 0,5 battono la sedia in IS e OOS (B 4.6, 5.c) | **V-numerata**: B V2 (la riga **resta NM** finche' non si riconcilia 1,849) | invariata (era gia' contata ENTRAMBE) |
| 36 | `ABTG_ORB_Ottimizzato` (770611 U30USD M5) | ENTRAMBE; C | sedia **riproduce** R88a / contratto in 3 round: 1,250 / 71 / 7,89 -> 1,674 / 119 / 9,76 (119 deal = 119 pos), SOPRA aff. C. **NASUSD 7/7 IS sopra -> OOS sotto** (0,767-0,864); D30EUR short SOTTO (0,858 / 56 -> 0,650 / 97); **D30EUR long OPPRANGE = MISTA** (OOS 0,997-1,372, aff. C o D). La ricetta R11 e' un'altra: non smentita (B 4.8) | **V-numerata**: B V5 | invariata |
| 41 | `ABTG_MaxMinNotte` (770402 oro H2) | ENTRAMBE (+ celle NM); C | 1a oro H2 [B]: la stessa corsa con split da **IS 1,108 / 265 -> OOS 1,438 / 428** (= 693 deal): "senza OOS" cade, screening classificato SOPRA, **non promozione**. `r133c` D30EUR short senza filtro S&P: IS 1,997 / 38 -> OOS 1,016 / 65 (DD 9,05) (B 4.9) | **V-numerata**: B V7, B V8 | invariata |
| 42 | `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` (770411) | ENTRAMBE; D | `r170c` **identico al contratto**: 1,878 / 20 / 3,10 -> 2,160 / 21 / 1,92; SOPRA aff. D; `CloseAtEnd` inerte (B 4.10) | **nessun cambio** | invariata |
| 45 | `ABTG_Nightly` | ENTRAMBE; C (B su AUDUSD, USDJPY) | `P0_EURCHF`: 0,891 / 63 / 11,10 -> 0,814 / 85 / 15,39, **SOTTO aff. C**; coincide con G3; certificato incompleto (B 4.13) | **nessun cambio** | invariata |
| 72 | `ABTG_SupRev_NAS_H1_Ottimizzato` (970913) | ENTRAMBE; C | `r127a` 1,298 / 71 -> 1,613 / 87 (9/9 sopra); **`r163a`** (100k): **7 celle su 7 SOPRA in IS e OOS**, IS 1,432-1,542 (n 76), OOS 1,485-1,615 (n 96, DD OOS 1,10-1,34). SOPRA aff. C. **Costo 28,7x NON misurabile dai CSV** (B 4.12) | **V-numerata**: B V6 (R163a da NM a misurato) | invariata |
| 73 | `ABTG_SupRev_DOW_H1_Ottimizzato` (970916, spenta) | ENTRAMBE; C | cella viva 0,988 / 117 -> 1,389 / 152 = **INV** (IS sotto -> OOS sopra), aff. B o C provvisoria; **0 differenze** con G5 (B 4.11) | **nessun cambio** | invariata |

**Non toccati da B** (altri EA di G1, G2, G3, G5): per esempio `DAX_Apertura_EU_Ottimizzato`, `Apertura_Marco`, `Apertura_3Ingressi`, le copie `Pin9fca` / `TrailFix` / `standalone/`, `ORB`, `ORB_Fibo`, `Londra_ORB`, `GoldenCross`, gli altri SupRev. Restano come nel consolidato.

### 1.3 Lettura C (G6a cacce breakout) - 9 righe

Classe di riga scritta come nel consolidato: "classe A (con screening) / classe T (solo tick)". Per le tre righe che cambiano, la proposta vale per le due viste (i dati sono tutti [T]).

| # | EA | consolidato (classe A / T; aff.) | dopo la lettura (copiato dalla lettura) | proposta di cambio | classe di riga |
|---:|---|---|---|---|---|
| 87 | `ABTG_IBRetest` | SOTTO / SOTTO; C | **identico** (6 confronti, 0 differenze). OOS SOTTO 3 su 3; D30EUR IS 1,211 / 58 -> OOS 0,965 / 107 = INV; famiglia 0,7798 su n 344 (C 4.7) | **nessun cambio** | invariata |
| 88 | `ABTG_LVNArbitro` | SOPRA / SOPRA; B | **identico**. OOS **SOPRA formale** 1,051 (10k) / 1,052 (100k), n 618; IS 0,979 / 0,975 = INV; DD IS e OOS **> 10%**; il DD non scende con la taglia (C 4.6). C 5.a la nomina fra le "celle SOTTO nascoste" (IS) ma 5.d scrive "nessun cambio": **sez. 7 punto 2** | **nessun cambio** (5.d) | invariata |
| 89 | `ABTG_OpeningReversalB` | NM / NM; D | **identico**: OOS `Trades = 0` in 11 righe su 11; IS n 1-3 (PF 1,826 su n 2 = rumore) (C 4.5) | **nessun cambio** | invariata |
| 93 | `ABTG_DaxValueArea` | NM / NM; - | **SOTTO 8 celle su 8** [T]: IS 0,773-0,823, OOS 0,755-0,974; **n 211-407, aff. B**; **DD 10,8-38,8% (8 su 8 oltre il 10%) = NO PER RISCHIO** (soglia del file prova R141e). "Legge dell'ancora unica" **non falsificata**. **NON ANCORA MISURATO come morto (2/5)** (C 4.4, 5.c, 5.d) | **del lettore, non V-numerata** (C 5.d): NM -> SOTTO [T], aff. B | **cambia: NM -> SOTTO** |
| 94 | `ABTG_HVAncora` | ENTRAMBE / ENTRAMBE; C-D | **identico** (8 confronti). OOS SOPRA 3 su 4 (1,921; 1,038 formale; 1,333), k 2,5 **INV** 1,361 -> 0,930; n OOS 31-37 (C 4.8) | **nessun cambio** | invariata |
| 95 | `ABTG_AtrExhaustVol` | ENTRAMBE / ENTRAMBE; C (PERC: B) | **identico** (4 confronti). PERC IS 0,711 / 153 -> OOS 0,952 / 224 SOTTO (B); ATR IS 0,972 / 70 -> OOS 1,229 / 96 SOPRA (C), INV (C 4.9) | **nessun cambio** | invariata |
| 96 | `ABTG_IntradayMomentum` | ENTRAMBE / ENTRAMBE; B (OOS) / C (IS) | **identico** (8 confronti). OOS SOPRA 4/4 (U30USD L+S 1,035 formale), IS SOTTO 4/4 (0,461-0,609) = **INV 4/4**; **NON ANCORA MISURATO** invariato (C 4.1) | **nessun cambio** | invariata |
| 100 | `ABTG_VolExpBreak` | NM / NM; - | **ENTRAMBE** [T]: 1 SOPRA formale (U30USD kStop 2,5: IS 1,123 / 78 -> OOS **1,042 / 111 / DD 12,22**) e 7 SOTTO in OOS; **aff. C, MERITO SOSPESO**. Il cancello (pre) del file prova **scatta in 4 finestre su 4**: asse **NON ANCORA MISURATO**. NASUSD **INV 4/4** (IS 1,22-1,32 -> OOS 0,76-0,96). **NO PER RISCHIO in 7 celle OOS su 8**, compresa l'unica SOPRA. Certificato 3/5 + (3) parziale (C 4.2, 5.c, 5.d) | **del lettore, non V-numerata** (C 5.d): NM -> ENTRAMBE [T], aff. C | **cambia: NM -> ENTRAMBE** |
| 102 | `ABTG_Cycle` | NM / NM; - | **SOTTO 12 righe su 12** [T], n 630-2072, **aff. B**, PF 0,761-0,981, **DD 17,1-55,1% (8 su 8 oltre il 10%)**, E per operazione negativa in 8 celle-finestra su 8; Peggior Giornata OOS verso 0 -4,11%. Le uscite (A)-(E) del file prova **non scattano alla lettera**. **NON ANCORA MISURATO come morto (2/5)** (C 4.3, 5.c, 5.d) | **del lettore, non V-numerata** (C 5.d): NM -> SOTTO [T], aff. B | **cambia: NM -> SOTTO** |

**Non toccati da C** (letti solo i 9 EA con CSV trasportati): `CRT_TurtleSoup`, `NySessionRetest`, `DaxReEntry`, `LiquiditySweep`, `OutOfNoise`, `FvgRetest`, `ImpulsoApertura`, `CanaleLento` (CSV in `risultati_archivio/Notte_16-08`, non in `dal_vps`; C 8). Restano come nel consolidato.

---

## 2. I CONTEGGI NUOVI (PROPOSTI, NON APPLICATI)

### 2.1 Definizione (scritta prima dei numeri)

- **Unita'**: la **riga di EA / famiglia del piano** (116, come nel consolidato sez. 0.1). Non la cella, non il file.
- **ENTRAMBE** = la riga ha almeno una cella SOPRA **e** almeno una cella SOTTO. **Solo SOPRA**, **solo SOTTO**: solo da una parte. **NM** = nessuna cella ne' SOPRA ne' SOTTO (solo non misurato). **EREDITA** = copie e pin che valgono la riga della madre (5 righe, non cambiano).
- **"Almeno una cella SOPRA"** = entrambe + solo SOPRA. **"Almeno una cella SOTTO"** = entrambe + solo SOTTO. Quindi una riga ENTRAMBE sta in **tutte e due** le liste: e' per questo che 53 righe stanno in tutte e due (cons. 0 punto 3).
- **Come ho ricavato la classe di riga**: dalla colonna "classe" della tabella principale del consolidato (sez. 1), non dai gruppi. Regola dello script: la riga e' ENTRAMBE se la classe comincia con ENTRAMBE o se nomina insieme SOPRA e SOTTO (caso della riga 32: "NM (CONTESA); short SOTTO; celle R120 SOPRA"); EREDITA se comincia cosi'; altrimenti SOPRA / SOTTO / NM. Per G6a la colonna ha due classi ("A / T"): le calcolo separate. **Prova di tenuta**: con questa regola lo script ritrova i conteggi per gruppo dichiarati nel consolidato 0.1 (8 su 8 UGUALI, Appendice A) prima di applicare qualunque cambio.
- **Cosa viene applicato**: **solo** le tre proposte di cambio di classe di riga **scritte da una lettura** (C 5.d: righe 93, 100, 102). Per A e per B lo script verifica che le transizioni di cella che propongono non cambino la classe di riga (tabella nell'Appendice A, 9 transizioni, tutte invariate) e che le loro stesse asserzioni "il conteggio non cambia" siano nel testo (A: "non cambia per nessuna delle 12 righe"; B: "I conteggi per EA dei gruppi ... non cambiano").

### 2.2 Il risultato

| gruppo | righe | entrambe | solo SOPRA | solo SOTTO | solo NM | EREDITA | almeno 1 SOPRA | almeno 1 SOTTO | cambia? |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| G1 | 26 | 5 | 2 | 3 | 13 | 3 | 7 | 8 | no |
| G2 | 14 | 8 | 0 | 1 | 5 | 0 | 8 | 9 | no |
| G3 | 14 | 8 | 1 | 2 | 2 | 1 | 9 | 10 | no |
| G4 | 12 | 7 | 0 | 1 | 4 | 0 | 7 | 8 | no |
| G5 | 19 | 12 | 2 | 0 | 4 | 1 | 14 | 12 | no |
| G6a, vista con screening (consolidato) | 17 | 8 | 1 | 1 | 7 | 0 | 9 | 9 | |
| **G6a, vista con screening (proposto)** | 17 | **9** | 1 | **3** | **4** | 0 | **10** | **12** | **si'** |
| G6a, vista solo tick (consolidato) | 17 | 6 | 1 | 2 | 8 | 0 | 7 | 8 | |
| **G6a, vista solo tick (proposto)** | 17 | **7** | 1 | **4** | **5** | 0 | **8** | **11** | **si'** |
| G6b | 14 | 5 | 0 | 4 | 5 | 0 | 5 | 9 | no |

| totale sui 116 | entrambe | solo SOPRA | solo SOTTO | solo NM | EREDITA | controllo | **almeno 1 SOPRA** | **almeno 1 SOTTO** |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| consolidato, G6a con screening | 53 | 6 | 12 | 40 | 5 | 116 | **59** | **65** |
| **PROPOSTO, G6a con screening** | **54** | 6 | **14** | **37** | 5 | 116 | **60** | **68** |
| consolidato, G6a solo tick | 51 | 6 | 13 | 41 | 5 | 116 | 57 | 64 |
| **PROPOSTO, G6a solo tick** | **52** | 6 | **15** | **38** | 5 | 116 | **58** | **67** |

**Cosa si e' mosso, riga per riga** (tutto da C 5.d): `DaxValueArea` (#93) NM -> SOTTO; `Cycle` (#102) NM -> SOTTO; `VolExpBreak` (#100) NM -> ENTRAMBE. Quindi: NM -3; solo SOTTO +2 (le prime due); entrambe +1 (la terza). "Almeno 1 SOPRA" +1 (solo `VolExpBreak`); "almeno 1 SOTTO" +3 (tutte e tre). Lo script ritrova **identica** la tabella di G6a che C scrive in 5.d (vista con screening 10 / 12 / 9 / 1 / 3 / 4; solo tick 8 / 11 / 7 / 1 / 4 / 5).
**Inventari delle letture, non additivi ai conteggi sopra** (unita' diverse: righe-passata, celle, finestre): A 414 righe-cella = 286 SOPRA + 128 SOTTO (A 6.1; "un INVENTARIO, non un'evidenza"); B 630 righe-passata = 607 celle-finestra = 310 celle, di cui 297 con IS e OOS (B sez. 2); C 98 righe-passata, 43 righe di tabella per cella (C sez. 1, 3).

### 2.3 Cosa questi numeri NON sono (e la firma che serve)

- **Sono PROPOSTE.** Nessuna riga del consolidato e' stata cambiata; i numeri del consolidato (59 / 65 / 40) restano quelli scritti li'. **Non vanno citati come "i nuovi conteggi" prima della firma.**
- **Le sette regole di conteggio dei gruppi non sono identiche** (consolidato 0.4: celle a barre senza OOS, righe EREDITA, SEGNO INVERTITO, unita' di n, zona grigia). Un totale e' la **somma di sette regole**: si legge come un conteggio, **mai** come "60 EA buoni su 116". Questo addendum **non le uniforma**.
- **La riga vale solo dopo la firma di Claudio sulle etichette** (consolidato 3(d)): **D-1** (D2: soglia di ZONA GRIGIA sul PF, non firmata), **D-2** (classe "NON CONFRONTABILE / REGIME" per i SEGNO INVERTITO), **D-3** (celle a barre / `_EXT`: contano in SOPRA / SOTTO o sono NM come merito? "con o senza screening"). Nessuna delle tre e' firmata; nessuna delle tre abbassa una soglia di promozione o di rischio; **non sono applicate** qui.
- **Una dipendenza esplicita da D-1**: l'unica cella SOPRA di `VolExpBreak` e' una "SOPRA formale" (PF 1,042, C 4.2; D2 non firmata). **Se D-1 la lasciasse fuori da SOPRA, la riga #100 passerebbe a solo SOTTO** e i totali diventerebbero: con screening almeno 1 SOPRA **59**, almeno 1 SOTTO **68**, entrambe 53, solo SOTTO 15; solo tick almeno 1 SOPRA **57**, almeno 1 SOTTO **67**, entrambe 51, solo SOTTO 16 (script, Appendice A). Le altre dipendenze da D-1, D-2, D-3 **non sono ricalcolabili da queste letture** e non le calcolo.
- **I conteggi dicono quanti EA hanno celle da quella parte, non quanto valgono.** Le uniche celle SOPRA con n OOS >= 150 trovate dai CSV nuovi hanno l'IS sotto 1 (IntradayMomentum L+S, LVNArbitro: INV) o DD > 10% (C 4.1, 4.6).
