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

1. **Trasporto**: 254 CSV letti in tre blocchi (A 82 + B 134 + C 38). Dal transcript: 156 nuovi, 35 aggiornati (cifre uguali salvo quattro file: `r139c` di A e `r139b` di B; sez. 3 righe 6 e 29), 63 identici; 191 scritti. Il consolidato dava per non leggibili **35 round di G4 e 6 di G6a** (cons. 3(a)): ora **34 su 35 di G4** (manca solo `r161c`, che sta nell'ARCHIVIO del Desktop VPS) e **6 su 6 di G6a** sono leggibili. **I 5 round di G6b restano non leggibili** (B 7.5; A 9.1). `[ADDENDUM: 35+6+5 = 46 sigle del consolidato; ne restano 6]`
2. **Conteggi proposti** (sez. 2, script in Appendice A): **solo la lettura C sposta classi di riga** (`DaxValueArea` NM -> SOTTO, `Cycle` NM -> SOTTO, `VolExpBreak` NM -> ENTRAMBE; C 5.d). Con screening: SOPRA **59 -> 60**, SOTTO **65 -> 68**, entrambe 53 -> 54, solo SOTTO 12 -> 14, NM **40 -> 37**. Solo tick: SOPRA 57 -> 58, SOTTO 64 -> 67, NM 41 -> 38. **Sono PROPOSTE, non applicate.**
3. **A e B non spostano nessuna classe di riga**: A lo scrive per G4 (A sez. 7, "cosa NON cambia"), B per G1/G2/G3/G5 (B 6). Cambiano celle, etichette, caselle del certificato e numeri (sez. 1).
4. **La correzione piu' pesante e' B su `770250`** (Nasdaq gated short M15): lo "OOS 1,097 su 104" di G1 e' la **finestra piena**. Con lo split: IS **1,257** su 57 deal -> OOS **0,948** su 47 deal = SEGNO INVERTITO, SOTTO, aff. C o D (B 4.3, B V1). La sedia e' ferma dal 25/09.
5. **`770511` (SuperWave U30USD H1)**: il contratto "conteso" si restringe. Due letture su tre sono riprodotte dai CSV (10k **1,482 / 1,243**; 100k **1,397 / 1,220**); **la terza, 1,849 / 1,328, non la riproduce nessuno dei 13 round**. In piu' una cella SOTTO che G2 non elenca (`r120b01`: IS 1,406 -> OOS 0,983). Qualunque cambio alla sedia e' solo di Claudio (B 4.6, B V2).
6. **Larry XAU (`772343`)**: la cella che G4 teneva "SOPRA D" su 21 mesi e' **SOTTO su 22 anni in 14 celle su 14, PF 0,872, n 213, DD 29,74%** (A 4.6, A S4, A S8). Il consolidato la elencava fra le SOPRA dell'oro (cons. 2.1).
7. **Round dati per "mai girati" (o non citati)** ora con i numeri: Dow `770202` r172a-j (69 celle, 10 assi d'uscita; l'ancora riproduce il contratto in 9 round su 10), `ORB_Ott` R125 (64 righe), `SupRev_NAS_H1` R163a (7/7 SOPRA in IS e OOS), `SuperWave_DOW_H1` (5 file su 7), EMA200 `r146b`/`r147a`, `SupRev` 225JPY `r166a` (B 5.f.1-9; A S7).
8. **Le tre cacce NM di G6a ora hanno un numero, e non e' buono**: `DaxValueArea` 8 celle su 8 SOTTO su n 211-407, DD 10,8-38,8%; `Cycle` 12 su 12 SOTTO su n 630-2072, DD 17,1-55,1%; `VolExpBreak` una sola cella SOPRA su 8 in OOS (U30USD kStop 2,5: PF 1,042, n 111, **DD 12,22%** = NO PER RISCHIO per la soglia del file prova) (C sez. 1, 4.2-4.4). **Nessuna e' MORTA**: certificato 2/5 su DaxValueArea e Cycle (C 5.c).
9. **Certificato di morte**: caselle chiuse e ancora aperte EA per EA in sez. 4. In sintesi: la casella 3 (uscita) si chiude **a livello di EA** per BB, C2C, GapFill, GapCont, Larry, EZ (A 6.2) **ma resta aperta per cella** dove l'asse d'uscita non e' mai girato su quella cella (A 9.3). Nessun EA diventa MORTO.
10. **Cosa NON cambia**: il regime e' **uno solo** (il rialzo) su ogni CSV a tick, quindi **nessuna cella ha due regimi misurati** (affidabilita' A: zero). A: nessuna cella SOPRA a tick con n >= 150 posizioni e OOS vero (A sez. 7). C: le celle SOPRA con n OOS >= 150 hanno l'IS sotto 1 (INV) o DD > 10% (C 4.1, 4.6). B: conferma le sedie gia' note (`770101`, `771531`) senza aggiungerne; `770511` a 100k ha 184 deal (B o C provvisoria) ma il contratto e' CONTESO (B 4.6).
11. **Smentite**: 36 righe in sez. 3 (documento sbagliato, dove sta la correzione). **Nessun documento e' stato modificato**, ne' dai lettori ne' da me.
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
- **Cosa viene applicato**: **solo** le tre proposte di cambio di classe di riga **scritte da una lettura** (C 5.d: righe 93, 100, 102). Per A e per B lo script verifica che le transizioni di cella che propongono non cambino la classe di riga (tabella nell'Appendice A, 11 transizioni, tutte invariate) e che le loro stesse asserzioni "il conteggio non cambia" siano nel testo (A: "non cambia per nessuna delle 12 righe"; B: "I conteggi per EA dei gruppi ... non cambiano").

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
- **I conteggi dicono quanti EA hanno celle da quella parte, non quanto valgono.** Nel blocco C le celle SOPRA con n OOS >= 150 hanno l'IS sotto 1 (`IntradayMomentum` L+S, `LVNArbitro`: INV) o DD > 10% (C 4.1, 4.6).

---

## 3. LE SMENTITE: COSA I CSV CORREGGONO NEI RESOCONTI

> **Non ho modificato nessuno di questi documenti**, ne' i lettori lo hanno fatto: le letture A, B, C li segnalano e basta. Qui sono messe in **un'unica tabella**. Colonne: il documento sbagliato (con la riga o la scheda), cosa dice, cosa dicono i CSV, **dove sta la correzione** (lettura + sezione: e' il posto da cui si copia), e quale riga o sezione **del consolidato** e' toccata (il consolidato eredita dai gruppi: dove e' ereditato lo scrivo). Ordine: A (1-12), B (13-30), C (31-36).

### 3.1 Tabella unica (36 righe)

| # | documento sbagliato | cosa dice | cosa dicono i CSV | dove sta la correzione | consolidato toccato |
|---:|---|---|---|---|---|
| 1 | G4 tab. 2a, 2e-2i; scheda 4.2 punto 3 | "C2C WF R40/R41 = dato [B] barre" | **E' tick**: r146a / r146c riproducono r41 (nome senza `_ohlc`) **al centesimo** (XAGUSD e CHFJPY solo dedotto dal nome: D1) | A sez. 8 S1; A 3 K2; A 7 V1 | cons. #56 (colonna dato e aff.) |
| 2 | G4 scheda 4.5 punto 11(a) | "R168a-c: 27,5 anni a barre, danno n e regimi a una famiglia che ne ha 8-20" | n = **21 / 20 / 25** (GBPUSD / EURUSD / AUDUSD) su 27,5 anni; r167 (da 1971 / 1993) e r168 (da 1999) danno **gli stessi n e profitti**: zero operazioni prima del 1999 | A S2; A V6 | cons. #59 ("migliorabile: si (campione...)") e sez. 2.3 (forex nativo) |
| 3 | G4 sez. 3-bis | "GapFill forex 0 operazioni 2020-2023: `Trades=0` e' un'ipotesi viva" (gambe IS dei round a uscita 2) | **nessuna gamba IS ha Trades = 0** (minimo n 20 sui 19 file a 0 byte); i file a 0 byte sono la gamba OOS di `@FRAZIONEIS 1.0` | A sez. 1; A S3 | cons. 3(a) (riga G4: "uscita 2 ... presenza di operazioni NON VERIFICATA") |
| 4 | G4 scheda 4.7 punto 11(c); tab. 6c | "XAU 22 anni: PF non pubblicato" | **PF 0,872**, n 213, DD 29,74%, **14 celle su 14 SOTTO** | A S4; A 3 K6 | cons. #61; cons. 3(c) ("PF di PunteLarry XAU a 22 anni (R100)") |
| 5 | G4 schede 4.1, 4.2, 4.3, 4.4, 4.6 punto 9 | "casella 3 misurata ma illeggibile / girata ma non leggibile da qui" | **leggibile**: 34 round su 35 (manca `r161c`) | A S5; A 6.2 | cons. #55, #56, #57, #59, #61 (colonna "migliorabile"); cons. 3(a) |
| 6 | G4 scheda 4.8 (r139c) | OOS "0,972 / 0,942 / 0,950", IS "0,798 / 0,794 / 0,831" | versione del 05/10: OOS **0,968 / 0,939 / 0,948**, IS **0,792 / 0,791 / 0,830** (il runner ha rigirato dopo il 13/09; nessun segno cambia) | A S6; A 3 K10; A 9.2 D4 | cons. #62 (cella "GBPUSD singolo 1999-2026 OOS 0,942-0,972") |
| 7 | G5 D19 / riga 226 | "R166a: stato di esecuzione NON VERIFICATO, nessun CSV in repo: NM" | **eseguito**: CSV IS presente (7 righe, tick, finestra intera) | A S7; A V11 | cons. #67; cons. 3(a) (riga G5, R166a) |
| 8 | G4 scheda 4.7 punti 2 e 6; tab. 6c | lato long XAU "SOPRA D" come lettura della cella | su 22 anni la stessa cella e' SOTTO 14/14: era un indizio D di 21 mesi | A S8; A 4.6 | cons. #61; cons. 2.1 (riga Oro: "Larry XAU long (61)" fra le SOPRA) |
| 9 | G4 sez. 3-bis (b) | "esiste sul VPS uno storico lungo [B] con IS/OOS a uscita 3" presentato come prova nuova per BB, EZ, Larry | per Larry e EZ l'OOS (2020.01.01-2026.06.30) **coincide con la finestra di R103**: non e' un OOS indipendente; **la gamba nuova e' l'IS 1999-2019** (per BB l'OOS e' 2012-2026, non coincide) | A S9; A 3 K3; A 9.2 D9 | cons. 3(a) (riga G4, "storico lungo [B]"); cons. 2.3 |
| 10 | G4 sez. 3-bis | "35 round GIRATI, CSV non in repo; 17 su 18 a uscita 2 con operazioni NON VERIFICATE" | **34 su 35 in repo**; in **tutti** i round a uscita 2 la gamba IS ha Trades > 0 | A 7 V12; A sez. 1 | cons. 0 punto 4; cons. 3(a) |
| 11 | G4 6h / 3g (R103) | Larry GBPUSD OOS "1,05"; EZ GBPUSD "1,059 (254, 15,77%)" | CSV: Larry GBPUSD **1,041**; EZ GBPUSD **1,053 (254, DD 15,84)**. Scarto 0,006-0,009 sul PF e 0,07 sul DD, **causa NON DIMOSTRATA** (binario preso dalla testa del ramo, deposito, lotto: nessuno provato) | A 3 K3; A 9.2 D3 | nessuna riga (numeri di dettaglio ereditati da G4) |
| 12 | G3 scheda 4.7 (R78) | PTE r78: viva 0,972 / 17,68 / 447; candidata 1,095 / 9,87 / 477 | r164a **0,966 / 17,91 / 447**; r153a **1,088 / 9,97 / 477** (n uguale; PF -0,006 / -0,007; DD +0,23 / +0,10); causa NON dimostrata | A 3 K12; A 7 V10 | cons. #47 (solo dettaglio) |
| 13 | G1 scheda 10 §3 | "R172a-j sospesi / mai girati (nove assi di gestione, 124 passate)" | **10 round, 69 celle, 138 passate**, CSV in repo; sette dei dieci erano gia' stampati nei log `CODA_07` del 18-20/09 | B 5.f.1; B V3 | cons. #10 (il consolidato non cita R172: tocca l'insieme degli assi d'uscita del long) |
| 14 | G1 scheda 10 §5 | "TP1_R 1,00 massimo sul bordo dell'asse 0,25-1,00: il bordo non e' un centro" | con l'asse esteso a 2,0: OOS 1,270 a 1,0 e **1,252-1,294 da 1,0 a 2,0**: l'ancora e' sulla spalla di un altopiano | B 5.f.2; B V3 | cons. #10 |
| 15 | G1 riga 14d (770250) | "SOPRA C (PF ~1), ZONA GRIGIA, OOS 1,097 su 104" | `r170a`: IS 1,257 / 57 -> **OOS 0,948 / 47**; 57 + 47 = 104; **1,097 e' la finestra piena** | B 5.f.3; B 4.3; B V1 | cons. #14; **cons. 3(d) D-1** (la cella 1,097 su 104 citata come esempio di zona grigia e' un SEGNO INVERTITO) |
| 16 | G2 scheda 2.2 / sez. 0 | "7 file (30 celle / 60 passate) gateati e MAI lanciati" (770511) | **5 file hanno CSV** (`r155a`, `r165a`, `r173a/b/c`; 21 celle); il TF M30 (`R190b`) no | B 5.f.4; B V2 | cons. #32; cons. 3(b) (riga "SuperWave 770511: i 7 file gia' pronti ... sospesi in coda dal 21/09") |
| 17 | G2 schede 3.2 e sez. 4 | "R125 (66 passate): preparato, mai girato" | **CSV in repo, 64 righe** (a-f); lo scarto 66 -> 64 e' previsto da `R125_ORB_COSTO_CRITERI.md` r.14-17 | B 5.f.5; B V5 | cons. #36; cons. 3(b) (riga "R125 e TF M10/M15 dell'ORB Dow"); cons. 5.2 (G2: "R125 (mai girato)") |
| 18 | G2 scheda 2.2 | "il trailing sul Supertrend porta l'edge (spento: IS 1,489 -> 0,903)"; "ExitOnFlip inerte (OOS identico)" | vale per (trail OFF, flip OFF); con **flip ON e trail OFF l'IS resta 1,406** (OOS 0,983); "inerte" vale per l'OOS, **non per l'IS** (1,489 contro 1,482) | B 5.f.6 | cons. #32 |
| 19 | G2 scheda 2.2 / sez. 0.1 | la cella `r120b01` non e' elencata fra le SOTTO | `r120b01`: IS 1,406 / 71 -> **OOS 0,983 / 125** (SOTTO); nessun cambio di conteggio per EA | B 5.f.7 | cons. #32 |
| 20 | G2 scheda 3.2 | "D30EUR (R11): OOS 0,94-1,02, DD 17,5-29,7%" | **non smentito** (R11 e' un'altra ricetta: finestra 07:00-08:05, niente trailing / parziale / BE, EMA 50) ma **incompleto**: OPPRANGE 08:00-08:15 con uscita R88 da' OOS 0,997-1,116, DD 6,32-9,80; `r125e` ha celle con IS e OOS sopra 1 (DD OOS 2,31-2,95, n sottile) | B 5.f.8; B V5 | cons. #36 (colonna SOTTO) |
| 21 | G5 scheda 1.6 / D19 | "R163a scritto/armato, nessun CSV in repo: NM" | **CSV in repo**: 7 celle su 7 SOPRA in IS e OOS | B 5.f.9; B V6 | cons. #72; cons. 3(a) (riga G5); cons. 3(b) (riga SupRev_NAS_H1: "G0 + R163a (14 passate)") |
| 22 | G5 sez. 6 | "deposito dei round R123 [NON VERIFICATO]" | il commento delle prove R123 dichiara **10.000**; stima dal CSV 10.046-11.051: **10k** | B 5.f.10 | cons. 5.2 (riga G5: "deposito dei round R123") |
| 23 | G5 D01 | "DD 6,3 / 4,8" accanto a "0,988 / 1,389 (R123 / r132c)" | 6,3 / 4,8 sono i DD del TF-scan; per R123 / r132c i DD sono **6,17 (IS) e 5,91 (OOS)** | B 5.f.11 | cons. #73 (la riga riporta la cella TF-scan 0,923 / 1,436 con DD 6,3 / 4,8: coerente; la cella R123 non e' nella riga) |
| 24 | G3 riga 1a | "oro due lati H2 [B] 1,308 (s.OOS), n 693, NM per piano 5.3" | stessa corsa con split: **IS 1,108 / 265 + OOS 1,438 / 428 = 693**; la premessa "senza OOS" cade | B 5.f.12; B V7 | cons. #41 (colonna cella: "1a due lati [B] PF 1,308 (NM come merito)") |
| 25 | G2 (non cita `r146b`, `r147a`, `r154a`); G1 (non cita `r147c`, `r150a` come misure d'uscita); G3 (non cita `r133c`, `r151a`, `r170b`, `r170c`) | omissione | i round esistono e hanno numeri (`r147a`: breakeven spento = deal OOS +49% a PF 1,528, profit OOS -31%) | B 5.f.13; B V4, V8, V9, V12 | cons. #27, #31, #1, #23, #41 |
| 26 | contratto 770511 (`CONTRATTI_DELLE_SEDIE_FTMO` §5) | lettura "1,849 / 1,328 (84 / 143 deal)" | **nessun CSV dei 13 round la riproduce**; il CSV non dice quale binario l'ha prodotta (B 8.3) | B 5.f.14; B 4.6 | cons. #32 (contratto "1,849 / 1,328 oppure 1,482 / 1,243") |
| 27 | nome del file `cemad02_..._OOS_...` | induce a leggere un OOS | il file `_OOS_` contiene **la finestra IS** (237 deal, 1,2011, DD 5,7325); G2 §13 lo scrive gia' correttamente | B 5.f.15; B 3.2 riga 23 | nessuna (avvertenza a chi legge il nome) |
| 28 | `IL_TRASPORTO_E_FERMO_2026-09-17` | `canfrz` fra i round con numeri prodotti | e' una corsa `-SoloControllo` (10 s): **per costruzione non ha CSV** | B 5.f.16 | nessuna |
| 29 | G2 scheda 1.1 (GBPUSD H4 `r139b`) | DD IS 17,7-20,3 e OOS 10,1-11,0 | CSV del 05/10: IS **17,95-20,41**, OOS **10,14-11,25** (versione 13/09: 17,73-20,32 e 10,05-11,05; screening [B], nessun verdetto cambia) | B 5.f.17; B 8.4; A 3 K10 | cons. #27 (colonna regimi: "GBPUSD H4 16,5 anni [B]: SEGNO INVERTITO su 4 celle su 4": il segno non cambia) |
| 30 | chi cita "l'ancora del round X" come cella viva | l'ancora e' la sedia | `r125a/c/e/f` (OPPRANGE), `r172j` (MinStopPts 8000), `r137c` e `q770be` (ClosePct 0) **non sono la sedia** | B 5.f.18; B 8.2 | nessuna riga: avvertenza per chi usa i CSV |
| 31 | G6a sez. 1.1, 3-bis, 5 misura 1 | "per `DaxValueArea`, `VolExpBreak`, `Cycle` il numero esiste ed e' irraggiungibile" | **raggiunto**: 36 righe, tutte con n > 0 ("uscita 0" del runner = round girato con operazioni) | C 5.e.1; C 5.d | cons. #93, #100, #102; cons. 3(a) (riga G6a) |
| 32 | G6a scheda 4.11 punto 10 | "`IntradayMomentum` e' l'unico dei 17 con n >= 150 in OOS per costruzione" | **non regge**: `Cycle` (n OOS 1036-2072) e `DaxValueArea` (350-407) hanno n OOS >= 150 in tutte le celle; `LVNArbitro` (618) e `AtrExhaustVol` PERC (224) lo avevano gia' | C 5.e.2 | nessuna (il consolidato non riprende la frase) |
| 33 | file prova R141e (`DaxValueArea`) | attesa n 180-530; "PF decrescente salendo la scala" | n osservato **561-658** (smentita al rialzo); il PF **non** decresce (IS +3,8% da 800 a 6800 contro +18% del gradiente nullo) | C 5.e.3; C 4.4 | cons. #93 |
| 34 | file prova R148 (`Cycle`) | attesa di durata 5,6-8,8 barre | osservato **5,47-5,55** (verso 0) e **4,28-4,33** (verso 1): sotto la banda; frequenza e ingressi/giorno dentro | C 5.e.4; C 4.3 | cons. #102 |
| 35 | G6a G6a-4 (ipotesi orologio invernale) | "l'inversione IS/OOS e' tipica degli EA a ora fissa" (implicita) | inversioni **in entrambe le direzioni** (6 celle IS<1 -> OOS>=1, 7 celle IS>=1 -> OOS<1); `VolExpBreak` (filtro orario spento) ha 5 celle su 8 invertite **nel verso opposto a `IntradayMomentum`**. L'ipotesi per `IntradayMomentum` resta **NON VERIFICABILE** (nessuna data per operazione nei CSV) | C 5.e.5; C sez. 6 | cons. #96; cons. 1.6 (intestazione G6a: "caveat orologio per tutti i 17") |
| 36 | G6a sez. 5 misura 1 | "controllare che IS e OOS di ogni round abbiano la stessa data e 8 righe" | **righe: confermate** (R141e 8, R145a 8, R145b 8, R148a 4, R148bL 4, R148bS 4); **date NON LEGGIBILI** (nessuna colonna di data); `Inp*` identici in IS e OOS in 19 coppie su 19 | C 5.e.6 | cons. 3(a) (riga G6a: "controllare ... 8 righe") |

Dalle tre letture risulta anche **una non-smentita utile**: per le sei famiglie di C gia' in repo (R141a/b/c/d, P0 IBRetest / LVN / OpeningReversalB) **31 confronti di cella, 0 differenze** (C 5.e.7, C sez. 7). Per A: 8 file su 8 identici ai log del runner (A sez. 10 punto 5). Per B: 54 CSV su 54 uguali alla tabella stampata nei log (B 1.5 punto 2).

### 3.2 Altre righe del consolidato rese superate o chiuse (stato, non smentite)

[ADDENDUM] Incrocio fra il consolidato e le letture; **nessuna modifica fatta al consolidato**.

| dove nel consolidato | cosa dice | stato dopo le letture | fonte |
|---|---|---|---|
| sez. 0 punto 4; sez. 3(a) (tabella dei 46) | G4 **35 round**, G6a **6**, G6b **5** "gia' pagati e non leggibili" | G4 **34 su 35** leggibili (manca `r161c`); G6a **6 su 6**; G6b **5 su 5 ancora non leggibili** | A sez. 1; C sez. 1; B 7.5 |
| sez. 3(a) riquadro SCADENZA ~14/10 - ~20-21/10 (finestra dei 30 giorni di `carica_risultati.ps1`) | i CSV 14-21/09 cominciano a uscire dalla finestra | per i **34 + 6 round gia' trasportati la scadenza non pesa piu'**. Restano fuori: `r161c` (solo nell'ARCHIVIO del Desktop VPS: il trasporto copia `abtg_round\risultati_prove` e li' non c'era) e i 5 round di G6b (gia' piu' vecchi di 30 giorni nel consolidato; sul PC di backtest `[INFERITO]` da G6b) | A sez. 1, 9.1 punto 1; consolidato 3(a) |
| sez. 3(c) "leggere i CSV di R141e, R145a/b, R148a/bL/bS appena trasportati" | da fare | **fatto** (C) | C sez. 1 |
| sez. 3(c) "recuperare ... PF di `PunteLarry` XAU a 22 anni (R100)" | da recuperare | **0,872** (A S4) | A 4.6 |
| sez. 3(c) "ricaricare il per-trade `cemad02` (771531) dal VPS"; sez. 3(b) "IS in posizioni di 771531" | aperto | **ancora aperto**: nessun per-trade nel repo | B 7.1; B 4.5 |
| sez. 3(b) "riconciliare il contratto 770511" | aperto | **ancora aperto**, ma ristretto: 1,849 / 1,328 non e' in nessun CSV | B 4.6; B 5.f.14 |
| sez. 3(b) "`SupRev_NAS_H1`: G0 sul binario in campo + R163a" | R163a da girare | **R163a ha il CSV**; il G0 sul binario in campo no | B V6 |
| sez. 3(b) riga `SuperWave 770511` (7 file, 34,1 min) | 7 file pronti, sospesi | **5 file su 7 hanno CSV**; manca il TF M30 (`R190b`) | B 5.f.4 |
| sez. 3(b) "R125 e TF M10/M15 dell'ORB Dow" | R125 mai girato | **R125 ha CSV** (64 righe); i TF M10/M15 no | B 5.f.5 |
| sez. 3(d) D-1 | esempio "G1 in 1c / 14d (1,097 su 104)" | il 14d e' un SEGNO INVERTITO, non una zona grigia | B V1 |
| sez. 2.1, riga Oro | `Larry XAU long (61)` fra le celle SOPRA | **SOTTO su 22 anni 14/14** | A 4.6 |

---

## 4. LE CASELLE DEL CERTIFICATO DI MORTE: CHIUSE DAI CSV E ANCORA APERTE

**Regola**: un candidato NON si archivia come MORTO se manca una casella (PF, n e DD, uscita ad asse, simboli gemelli, TF cambiato). **Nessuna delle tre letture scrive MORTO** per nessun EA; lo dicono A 6.2, B 5.d, C 5.c. "Chiude" = i CSV contengono un asse di quella casella per quella cella; **non** vuol dire che il certificato sia completo. Nella colonna "via piu' corta e costo" scrivo **solo cio' che le letture scrivono**: dove non e' scritto lo dico (e **non** lo ricostruisco). Tutto il tempo macchina e' **sul PC di backtest, mai sul VPS** (regola del 21/09); ogni lancio ha bisogno del via libera di Claudio.

### 4.1 EA per EA

| EA / cella | caselle CHIUSE dai CSV (che cosa) | caselle ANCORA APERTE | via piu' corta e costo (solo se scritti nelle letture) | fonte |
|---|---|---|---|---|
| `BreakingBand` | 3 **a livello di EA**: SL x7, BEMode, BEatATR, TPRefreshBars su GBPUSD H1; SL su EURUSD. Con 1, 2, 4, 5 = **5 caselle compilate a livello di EA** | 3 **per cella** su M15, M30, AUDUSD (nessun asse d'uscita girato su di loro); AUDUSD `r161c` NON LEGGIBILE | `r161c`: un trasporto da `Desktop\ARCHIVIO\2026-09-20\ROUND_r161c\` (o dalle altre due copie), **0 minuti di macchina**. Girare l'asse sulle celle M15 / M30: costo **non scritto** | A 6.2; A 9.1 punto 1; A 9.3 |
| `CostToCost` | 3 a livello di EA (SLBufferATR tick su EURJPY e GBPCAD; MaxBarsHold [B]) | 3 **per cella** su short (0,112), L+S (0,770), CHFJPY, XAG, GBPCAD 6,5 anni [B] | girare l'asse su quelle celle: costo **non scritto** | A 4.2; A 9.3 |
| `EasyTrend` | 3 (SLBufferPts letto + `InpTP_R`) | **5 (TF: solo H1)** | TF H2/H4: costo **non scritto** nella lettura | A 4.3; A 6.2 |
| `GapFill` | 3 (SLGapMult, MaxHours, SLMode + FillPct) | **5 (TF: solo H1)**. "Migliorabile per n con lo storico lungo: NO" (20-25 trade in 27,5 anni) | via = TF e simboli, non storico; costo **non scritto** | A 4.4; A V6 |
| `GapContinuation` | 3 (PartialTargetR + FinalTargetR) | **4** (nessun gemello) e **5** (solo M1) | costo **non scritto** | A 4.5 |
| `PunteLarry` | 3 (MaxDaysHold e SLBufferATR su 6 simboli) | **5 (TF: solo H1)** per XAU, EURAUD, EURCAD | costo **non scritto** | A 4.6 |
| `FiboH4_Multi` (GBPUSD singolo) | nessuna (r139c muove l'ingresso, non l'uscita) | 3 e 5 | costo **non scritto** | A 4.7; A 6.2 |
| `PTE`, `SupertrendReversal` (225JPY H2), `SupertrendReversal_Ottimizzato` | **invariato** (A: AtrExitPeriod letto su 3 sedie PTE; SLBufferPips su 225JPY; SLLookback gia' di G5) | come prima (G3 / G5) | - | A 6.2 |
| `Live5m` NASUSD M5 | 3 **chiusa** dai quattro assi (ClosePct, TrailTF, trailing on/off, TrailStartR) | 4 (gemelli completi: non nei CSV); 5 n/a | - | B 5.d |
| `770250` NASUSD M15 short gated | 3 solo `CloseAtEnd` (inerte in OOS) | 4 nessuno; 5 nessuno (M15 fisso) = "quasi tutto" | costo **non scritto** | B 5.d |
| `ORB_Ott` NASUSD long OPPRANGE (OOS 0,767-0,864) | 3 parziale (buffer dello stop 0-3000); 4 chiusa (D30EUR e NASUSD) | 3 (BE, AtrSLmult mai); **5 (`InpExecTF` M5 in tutti i round)** | costo **non scritto** | B 5.d; B 4.8 |
| `ORB_Ott` D30EUR short (OOS 0,650 / 97) | 4 chiusa | 3 (nessun asse: buffer 2000 pinnato); 5 | costo **non scritto** | B 5.d |
| `DAX_Apertura_EU` F40EUR long (OOS 0,770 / 195) | 4 chiusa (F40EUR long) | 3 (nessun asse su F40EUR: cella unica); 5 n/a (range su M1) | costo **non scritto** | B 5.d |
| `SuperWave` NASUSD H1 (9/9 SOTTO) | 3 parziale (buffer ATR 0-1,0); 4 (NASUSD) | 3 (TP1 / BE / trailing no); 5 non chiusa dai CSV | costo **non scritto** | B 5.d |
| `770511` (sedia, contratto CONTESO) | 3: R120, TP1Pct, TP1_R, BE, TP_RR, SLBuffer, SLLookback ora **con CSV** (5 file, 21 celle) | **5 (TF M30: `R190b` mai girato)** | riconciliazione del contratto: costo **non scritto nelle letture** | B 4.6; B 5.f.4 |
| `SupRev_DOW_H1` celle SOTTO (StMult 2,5 / 3,0; AtrP 6-11; NearAtr 0,5) | assi di ingresso e filtro, non d'uscita | **3 non chiusa**; 5 (TF-scan in G5) | costo **non scritto** | B 5.d |
| `MaxMinNotte` D30EUR short senza filtro (`r133c`, OOS ~1,0) | `MinBoxPts` e' un filtro d'ingresso: non conta | **3 non chiusa**; 5 (`InpMgmtTF` mai ad asse) | costo **non scritto** | B 5.d |
| `EMA200` AUDJPY H4 [B] (IS 0,780-0,807) | 3 (`InpTP_RR` 1,5-3,0, OHLC); 4 (AUDJPY e GBPUSD, OHLC) | **mancano i tick** | costo **non scritto** | B 5.d |
| `Nightly` EURCHF M5 (OOS 0,814 / 85) | nessuna (il CSV conferma solo il PF) | 3 (mai); 4 (solo EURCHF) | costo **non scritto** | B 5.d |
| `VolExpBreak` | 1, 2, 4 (NASUSD e U30USD; D30EUR non provato) = **3 caselle** + (3) **parziale** (l'asse e' lo stop `InpKStop`, letto col cancello (pre) scattato 4/4) | **3** (TP / parziale / BE mai variati), **5** (solo M30) e D30EUR | costo **non scritto** | C 5.c |
| `Cycle` | 1, 2 = **2/5** | 3 (uscita costante in 12/12 righe), 4 (solo NASUSD; U30USD e D30EUR mai), 5 (solo M30; M15 / H1) | costo **non scritto**; le uscite (A)-(E) del file prova **non scattano alla lettera** | C 5.c; C 4.3 |
| `DaxValueArea` | 1, 2 = **2/5** + (3) **parziale** (asse = buffer dello stop) | 3 (target / parziale / BE mai variati), 4 (solo D30EUR), 5 (solo M15; M30 / H1 argomenti del file, non misure) | il bootstrap sui trade veri di R141e **richiede i per-trade, non in repo**; la copia dal VPS richiede una firma; costo **non scritto** | C 5.c; C 4.4; C-9 |
| `IntradayMomentum`, `HVAncora`, `AtrExhaustVol`, `IBRetest`, `LVNArbitro`, `OpeningReversalB` | **nessun cambio** (numeri identici a G6a) | come in G6a | - | C 4.1, 4.5-4.9 |

### 4.2 Le tre cose che il certificato non decide (e che le letture segnalano)

1. **Un asse di STOP conta come "gestione dell'uscita messa ad asse"?** La regola 5.6 del piano non lo dice e G6a l'ha trattato in tre modi diversi. C ha scritto **PARZIALE** per `VolExpBreak` e `DaxValueArea` **senza decidere**: cambia "3/5" contro "2/5" (C-1). **E' una decisione di regola**, non una misura (sez. 6).
2. **Per cella o per EA?** A lo dice chiaro: la casella 3 e' chiusa **a livello di EA** ma **resta aperta per cella** dove l'asse non e' mai girato su quella cella; "prima di scrivere MORTO su una di quelle celle va girato l'asse su di lei" (A 9.3).
3. **L'OOS di Larry / EZ e' la finestra di R103** (A K3, D9): le caselle 3 si chiudono ma la gamba OOS di quei round **non e' una conferma indipendente**.

### 4.3 Costi che il consolidato scrive per gli stessi buchi (NON delle letture)

Fuori dalle letture, il consolidato 3(b) ha stime dei gruppi per alcune di queste caselle; le riporto **solo come rimando**, con la loro etichetta, e vanno moltiplicate per 2-3 (avvertenza del consolidato 3: stime ~2,5x sottostimate sul banco VPS, velocita' del PC di backtest non misurata): IS in posizioni di `771531` **~45 s** (o 0 con il per-trade `cemad02` dal VPS); riconciliare `770511` **~1 min + 2 di avvio**; casella 5 (TF) di GapFill / EasyTrend / Larry **~15 min (GapFill ~10 passate); ~3-5 min a file (EZ, Larry)** `[STIMA G4]`. Per le altre caselle della tabella 4.1 il consolidato non ha una riga corrispondente che le letture confermino: non ne scrivo.

---

## 5. COSA RESTA NON LEGGIBILE

Raggruppato per **perche'**. Tutto e' scritto dalle letture; non ho aggiunto buchi miei.

**5.1 Round i cui CSV non sono nel repo**
- **`r161c`** (BreakingBand AUDUSD, asse `InpSL_ATRmult`): IS 3,5 KB e OOS 0 byte esistono **solo nell'ARCHIVIO del Desktop VPS** (`Archivio_2026-09-16_1942\ROUND_r161c\`, `ARCHIVIO\2026-09-19\...`, `ARCHIVIO\2026-09-20\...`). **Costo del buco: 0 minuti di macchina (un trasporto)** (A 1, A 9.1.1).
- **I 5 round di G6b** (passo 0 VwapRevert 03/09, R96 CrossEmaApertura 23/08, INVES 30/08, CHAOS / CHAOSABL 31/08, R117 Relativo ~04/09): **solo referti, nessun CSV** (B 7.5; consolidato 3(a)). "Sul PC di backtest" e' `[INFERITO]` da G6b, non verificato dalle tre letture.
- **R252, R274, R280, `PRV_DAXAP_04`, R214a-d, R215a, R231a, R275, R183, R180** (G1), CSV R234 (G2), BreakinBox / LondonFx / AllineaLondra / candidati PostNews (G3), R110 / R236 / R238 / R99 / R100 / R120a-c-d / R124a / R132a-b / R190c / R237a-b (G5; **R163a e R166a sono ora letti**), R98 / R95 / R235 / R109 / P0 CRT-NY-DaxReEntry (G6a), i **9 file prova scritti e mai girati** di G6a: **non toccati dalle tre letture** (perimetro: A 9.1.6, B 7.5, C 8). Restano come nel consolidato 3(a).
- **`canfrz`**: per costruzione non ha CSV (B 5.f.16). **`R190b`** (TF M30 di 770511) e gli altri file "mai lanciati" di G2: nessun CSV (B 7.5). **Lato short di 770101 / 770202** (R54a, R255, R270, R251): non in queste cartelle (B 7.6).

**5.2 Dati che i CSV non contengono, per costruzione**
- **Per-trade** (data, lato, regime, posizioni): assenti in tutte e tre le letture. Conseguenze scritte: **posizioni NON LEGGIBILI** per i motori con parziale (GapCont, PTE, FiboH4, SupRev; tutte le sedie di B: ogni n e' in deal); **regimi NON MISURATI** (un solo regime a tick: il rialzo); lato non separabile (A 9.1.3; B 7.1, 7.2; C 8).
- **Finestre IS/OOS, modello di tick, deposito, TF**: **non nei CSV**; derivati dalla regola del driver / dai file prova / dalle righe del runner (A sez. 0 punto 4; B 1.2; C 0). **Le date delle finestre sono [DERIVATO], non lette.**
- **Costo** (frontiera `stop >= 40 x spread`), spread, slippage, orologio: nessuna colonna nei CSV (A 9.1.4; B 7.7). **Il costo `28,7x` di `SupRev_NAS_H1` resta NON misurabile dai CSV** (B 4.12).
- **Colonna `Peggior Giornata %`** assente in IntradayMomentum e AtrExhaustVol (C 8). **Giornale del tester** assente: restano NON LEGGIBILI le cause di S2 di Cycle (`|L-S| = 6`, 34 incroci non entrati), del -15,9% di Trades IS di DaxValueArea, dei `Lotto Tagliato` 9 contro 18 di Cycle (C 8).
- **Referti `REFERTO_ROUND_<etichetta>.txt`**: nello zip sul Desktop del VPS, non in repo (A 9.1.2; B 7.4). Il confronto referto/CSV e' stato possibile per 54 CSV su 134 (B), per `r162a` e `r178a` (A), per 0 dei 6 round nuovi di C (C 7).
- **Binario** che ha prodotto un CSV: non identificato (B 7.8). **Valuta di conto** dei CSV di banco: non dichiarata (B 7.9).

**5.3 Buchi aperti dalle letture stesse**
- **`DaxValueArea`**: `Flat Giorni` OOS = **305** contro 276 feriali (C-5), `Peggior Giornata` oltre il massimo teorico del file in 8 celle su 8 (C-10): **[NON MISURATO]**, chiudibili solo dal giornale del tester (C 9).
- **Round rigirati con binario diverso** (A K10, D4; B 8.4): `r139c` (A) e `r139b` (B) hanno cifre diverse fra 13/09 e 05/10; il driver prende l'EA "dalla testa del ramo, non dal pin". Dei **35 CSV "AGGIORNATI"** del trasporto: A 5 (2 con cifre diverse), B 28 (2 diverse), C 2 (nessuna diversa). **Non si sa quali altri round abbiano una versione precedente sovrascritta** (A D4).
- **Scarti piccoli CSV / referto non spiegati**: A K3 e K12 (righe 11-12 di sez. 3), B 8.5 (+17,56 EUR su 770250), C (nessuno: 31 su 31 uguali).
- **Soglie congelate dei file prova non applicate** (A 9.1.5; B 7.3): solo R161a (A) e `r173a` B2 (B) sono applicate; C applica quelle di R141e / R145 / R148 come scritte.
- **Per l'orologio invernale di G6a: NON VERIFICABILE** (nessuna data per operazione; il solo conto del calendario e' rifatto: 49,2 / 60,1 / 32,6 / 39,9 / 39,2 / 47,9%, uguale a G6a) (C sez. 6).

---

## 6. DECISIONI DI CLAUDIO E LAVORO NOSTRO

> **Regola scritta in testa a B 6 e ripetuta qui**: dove una proposta tocca **taglia, rischio, preset o una sedia in campo** e' **decisione di Claudio**, e qui **non e' proposta**. Qualunque cambio alle sedie e' **SOLO suo**. **Nessuna soglia viene abbassata, nessun rischio o taglia e' proposto da noi.** Le firme del foglio `report/FIRME_DA_FARE_2026-10-05.md` e le decisioni D-1...D-12 del consolidato 3(d) sono **richiamate, non ripetute**.

### 6.1 DECISIONI DI CLAUDIO che emergono dalle letture

| # | decisione | cosa dicono i numeri (dalla lettura) | scrive la lettura che e' sua? |
|---|---|---|---|
| **S-1** | **`770250` (Nasdaq gated short M15): riaccenderla o no.** Ferma dal 25/09 | OOS **0,948 su 47 deal** (IS 1,257 su 57), SOTTO, aff. C o D, INV; il 1,097 su 104 era la finestra piena. Nessuna azione proposta dalla lettura | **si'**: "decisione di Claudio se riaccenderla" (B V1; B 4.3) |
| **S-2** | **`770511` (SuperWave U30USD H1): qualunque cambio alla sedia**. I dati: TP1Pct 0 e 25, TP1_R 0,5, SLBufferPips 1003 e 5003, a 10k SLBufferAtr e SLLookback 3 / 7 / 9 **battono la sedia in IS e OOS** (es. TP1Pct 0: IS 1,674 / OOS 1,455 contro 1,397 / 1,220; TP1_R 0,5: OOS 1,928); breakeven spento IS 0,879 | "Sono dati, non una scelta: la regola di casa e' il centro dell'altopiano, mai il picco" | **si'**: B 4.6, B V2 |
| **S-3** | **`770202` (Dow long): qualunque cambio alla sedia.** Nessuna cella batte l'ancora in IS e OOS insieme **salvo TP1_R 1,50 e 1,75** (IS +0,104 / +0,095; OOS +0,024 / +0,015); i candidati forti in OOS (CloseHour 19-21, CloseAtEnd 0, SLMode 1) hanno tutti l'IS sotto 1 | la lettura **non propone nessun cambio** ("il default va bene") | **non e' scritta come decisione esplicita per 770202** da B: e' la regola generale di B 6 (una sedia in campo e' di Claudio). [ADDENDUM: lo scrivo cosi'] |
| **S-4** | **`EMA200` 771531: il breakeven spento** (`r147a`): deal OOS **769 (+49%)** a PF OOS **1,528** invariato, **profit OOS -31%** (23.321 -> 16.188), **DD OOS 8,90 contro 7,83**. Se sia una leva di frequenza (posizioni) e' NON LEGGIBILE | serve il per-trade prima di confrontarlo col pavimento 1,00 / giorno o con la frequenza promessa | **si'**: "ogni uso sulla sedia: decisione di Claudio" (B 4.5, B V4) |
| **S-5** | **`770101`**: usare il **floor 6800** (`r137a`: 1,233 / 1,420, n 178 / 272, DD 5,11 / 7,25) sul preset; e **`ClosePct 0 + BE`** (OOS 1,491, +0,094 = dentro il rumore 0,147; **firma gia' pendente**, G1) | e' la misura che serve alla questione "costo FRAGILE" | **si'** (B 4.1, B V11; B 3.2 riga 1; consolidato D-8) |
| **S-6** | **Larry XAU (`772343`): taglia.** DD 22 anni **29,74% a 1%**, PF 0,872 su 14/14 celle SOTTO | la revisione R100 ("taglia 0,3%, se il tagliando non la giustifica spegnere") perde la parte "merito ignoto" (A V8) | **taglia = firma** (consolidato D-11); A non la propone |
| **S-7** | **Le tre etichette D-1 / D-2 / D-3** (consolidato 3(d)), con i **nuovi esempi dai CSV**: D-1: `VolExpBreak` 1,042 (da cui dipende il +1 SOPRA), `HVAncora` 1,038, `LVNArbitro` 1,051-1,052; D-2: **13 celle INV in C** (6 IS<1 -> OOS>=1, 7 IS>=1 -> OOS<1), BB / Larry / EZ / PTE / SupRev Ott in A (**6 oggetti** IS SOTTO -> OOS SOPRA, tutti [B]), 770250 / F40EUR / `ORB_Ott` NASUSD in B; D-3: A e C hanno celle `[B]`/`[E]` | le tre letture **non le applicano**; i conteggi di sez. 2 dipendono da loro | si': sono etichette di Claudio (consolidato 3(d)) |
| **S-8** | **L'asse di STOP conta come "uscita ad asse" nel certificato?** (C-1) e **come si legge la banda di (b) per `Cycle`** (C-3: -0,0523 R in OOS, a 0,0023 dalla banda) | cambia 3/5 contro 2/5; e l'esito scritto nel registro per Cycle | C scrive "senza decidere" / "non decido": e' una **decisione di regola** (il certificato e' della regola del 09/09 firmata da Claudio) |
| **S-9** | **Copia dei per-trade dal VPS** (18 file per 9 EA di G6a; `cemad02`; ecc.) e **trasporto di `r161c`** dall'ARCHIVIO del Desktop VPS | chiudono C-4, C-5, l'orologio, il bootstrap di R141e, l'IS in posizioni di 771531, AUDUSD di BB | **si'**: "una copia dal VPS richiede una firma (perimetro del runner: sola lettura)" (C-9; consolidato D-7) |

### 6.2 LAVORO NOSTRO (nessuna firma sul contenuto; ogni riga e ogni script passa dai due cancelli; ogni lancio sul PC di backtest ha comunque il via libera)

1. **Mettere in pari i documenti sbagliati** (sez. 3): ognuno va corretto **nel suo file** dopo il cancello; qui sono solo elencati. Per il consolidato: le righe di sez. 3.2.
2. **Aggiornare il registro** (`REGISTRO_TEST.md`) con i round che i CSV hanno chiuso (B 5.f; C 5.e): niente MORTO, solo "NON ANCORA MISURATO + cosa manca" (regola del 09/09).
3. **Chiudere gli scarti non spiegati** (sez. 5.3): K3, K12, D4 (quali round hanno una versione sovrascritta), +17,56 EUR di 770250, C-4. **Costo: non scritto.**
4. **Riconciliare 770511** (contratto 1,849 / 1,328 contro le due letture riproducibili) e **IS in posizioni di 771531**: via e costo nel consolidato 3(b) (sez. 4.3); le letture dicono solo "serve".
5. **Applicare le soglie congelate dei file prova** dove non sono state applicate (A 9.1.5; B 7.3): e' un lavoro a parte, non un giudizio.
6. **Dopo la firma di Claudio sulle etichette** (S-7): ricalcolare i conteggi con lo script di Appendice A e riscrivere cons. 0.1 / 0.2 (**non prima**).
7. **Preparare** (non mandare) la riga per `r161c` e per i 5 round di G6b: passa da `controlla_riga.py` e da `controllo-preventivo`, **con il bersaglio dichiarato per esteso** (regola del 12/09); mandarla e' S-9.

---

## 7. DUBBI E CONTRADDIZIONI TRA LE LETTURE E IL CONSOLIDATO

1. **B 4.3 contro B 8 punto 5**: la scheda 4.3 scrive che l'identificazione `r170a` = `770250` e' **"dichiarata dalla prova"** (la prova nomina l'ancora e elenca tre differenze dal preset vivo: rischio 0,65 contro 0,35, Guardian ON contro OFF, magic 787310); il punto dubbio 8.5 la chiama **"dedotta"** e nota che il CSV ha `InpMagic` 787310, non 770250. La scheda e' stata corretta dal cancello, il punto dubbio no. **Cosa cambia**: V1 riguarda **la ricetta a 0,65%, non il preset di campo a 0,35%**; il PF combinato 1,0996 contro 1,097 e il profitto +17,56 EUR restano non spiegati.
2. **C 5.a contro C 5.d su `LVNArbitro`**: 5.a elenca fra le "celle SOTTO nascoste dentro EA che G6a vedeva SOPRA" l'IS 0,979 / 0,975; 5.d scrive "nessun cambio". **Con la regola del piano (classe sul PF OOS)** la cella e' SOPRA formale INV e la riga resta "SOPRA / SOPRA": e' cio' che applica lo script. **Se invece l'IS contasse** come cella SOTTO, `LVNArbitro` passerebbe da solo SOPRA a ENTRAMBE (-1 in "solo SOPRA", +1 in "almeno SOTTO"; `IntradayMomentum` e' gia' ENTRAMBE). Non applicato; **dipende da D-2**.
3. **Chi dice "il conteggio non cambia"**: A lo dice per G4 (12 righe), B per G1 / G2 / G3 / G5, **nessuno per G3 PTE-in-A e G5 SupRev-in-A** nel testo di A (righe #47, #67, #68): le ho verificate io con la tabella di transizioni in Appendice A (nessuna cambia classe di riga). **E' una verifica mia, da far controllare dal cancello.**
4. **Il consolidato e le letture contano "celle" in modi diversi**: A conta righe-cella con duplicati (la viva ricompare in piu' round: "286 e 128 non si sommano"), B celle-finestra deduplicate per `InpMagic`, C righe-passata. **Non sommarli** (sez. 2.2).
5. **Round "rigirati" e versione**: A e B trovano indipendentemente che `r139b` / `r139c` sono cambiati dopo il 13/09. Il consolidato e i gruppi hanno letto la versione vecchia. La causa non e' isolata (A D4, B 8.4): **i numeri del consolidato che vengono da referti del 13/09 potrebbero avere una versione piu' nuova** per altri round che nessuno ha confrontato. **Non so quanti.**
6. **Riserve ereditate dai cancelli delle tre letture** (le riporto, non le chiudo): A: casella 3 chiusa a livello di EA, **per cella** no; "lo cambia la finestra" e' una lettura descrittiva su 6 oggetti tutti [B] scelti per IS SOTTO, non un verdetto; OOS di Larry / EZ = finestra R103 (A 9.3). B: PASS CON RISERVE dopo 6 correzioni (r172b non identico al contratto, identificazione di r170a, breakeven EMA200 in deal e non in posizioni, R11 = altra ricetta, scarto R125 spiegato, regime = rialzo). C: aperti **C-5** (Flat Giorni) e **C-10** (Peggior Giornata). **La classe SOTTO di `DaxValueArea` non dipende da C-5**: le celle sono 8 su 8 sotto 1 in entrambe le finestre, quale che sia la data di fine dell'OOS; **dipende da C-5 il confronto con gli altri round**.
7. **I "5 round di G6b sul PC di backtest"** e' `[INFERITO]` da G6b; B 7.5 li chiama "dichiarati nel commit di trasporto" e non li ha cercati. Non ho riaperto il transcript del trasporto.
8. **Questo addendum e' una bozza**: non e' passato dal cancello; i numeri di sez. 1, 3, 4 e 6 sono copiati dalle letture e **ricontrollati con uno script** contro i quattro file (Appendice B), ma lo strato 2 non l'ha ancora letto.

---

## APPENDICE A - IL CONTEGGIO, RIFATTO CON UNO SCRIPT CHE RILEGGE I QUATTRO FILE

`conta_addendum.py` (sola lettura; legge dalla cartella `report/` o da `RDIR` il consolidato e le tre letture; **non scrive nulla**). Fa cinque cose: (1) rilegge la classe di riga dalla sez. 1 del consolidato e **ritrova i conteggi dichiarati nella sez. 0.1** (8 su 8) prima di fidarsene; (2) legge da C 5.d le proposte "NM -> ..." con regex; (3) cerca nel testo di A e B le frasi "il conteggio non cambia" e verifica con una tabella di transizioni che le loro proposte lasciano invariata la classe di riga; (4) ricalcola i totali e li confronta con la tabella 5.d di C (vista A e vista T); (5) quadra il trasporto (156 + 35 + 63 = 254; 156 + 35 = 191).

```python
# conta_addendum.py - sola lettura. Rilegge il consolidato e le tre letture CSV e
# ricalcola i conteggi PROPOSTI. Non scrive nulla nel repo. RDIR = cartella dei file.
import re, os, sys
R = os.environ.get('RDIR', '/home/user/GITHUB/report/')
rd = lambda f: open(R + f, encoding='utf-8').read()
CONS = rd('RESOCONTO_EA_CONSOLIDATO_2026-10-05.md')
LA = rd('LETTURA_CSV_TRASPORTATI_A_FOREX_2026-10-05.md')
LB = rd('LETTURA_CSV_TRASPORTATI_B_SEDIE_2026-10-05.md')
LC = rd('LETTURA_CSV_TRASPORTATI_C_CACCE_2026-10-05.md')
ok_tot = True
def cells(l): return [c.strip() for c in l.strip().strip('|').split('|')]

# ---- 1) classe di riga dal consolidato, sez. 1 (righe 1..116), per gruppo
GR = [('G1', 1, 26), ('G2', 27, 40), ('G3', 41, 54), ('G4', 55, 66),
      ('G5', 67, 85), ('G6a', 86, 102), ('G6b', 103, 116)]
sez1 = CONS.split('## 1. TABELLA PRINCIPALE')[1].split('## 2. PER TIPOLOGIA')[0]
rows = {}
for l in sez1.split('\n'):
    if re.match(r'^\|\s*\d+\s*\|', l):
        c = cells(l)
        rows[int(c[0])] = c       # c[1]=EA, c[3]=classe, c[7]=aff.
def kind(t):
    t = t.replace('*', '').strip()
    if t.startswith('EREDITA'): return 'EREDITA'
    if t.startswith('ENTRAMBE'): return 'ENTRAMBE'
    s, o = 'SOPRA' in t, 'SOTTO' in t
    if s and o: return 'ENTRAMBE'          # es. riga 32 "NM (CONTESA); short SOTTO; celle R120 SOPRA"
    if s: return 'SOPRA'
    if o: return 'SOTTO'
    return 'NM'
def classe(n, view):
    t = rows[n][3]
    if 86 <= n <= 102:                      # G6a: "classe A / classe T"
        a, b = [x.strip() for x in t.split(' / ')]
        return kind(a if view == 'A' else b)
    return kind(t)
def tot(cls_of, view):
    out = {}
    for g, a, b in GR:
        d = dict(entrambe=0, soloSOPRA=0, soloSOTTO=0, NM=0, EREDITA=0)
        for n in range(a, b + 1):
            k = cls_of(n, view)
            d[{'ENTRAMBE': 'entrambe', 'SOPRA': 'soloSOPRA', 'SOTTO': 'soloSOTTO', 'NM': 'NM', 'EREDITA': 'EREDITA'}[k]] += 1
        d['righe'] = b - a + 1
        out[g] = d
    return out
base_A, base_T = tot(classe, 'A'), tot(classe, 'T')

# ---- 2) dichiarato dal consolidato 0.1 (colonne: gruppo|righe|file|entrambe|soloSOPRA|soloSOTTO|soloNM|EREDITA)
dec = {}
for l in CONS.split('### 0.1')[1].split('### 0.2')[0].split('\n'):
    if l.startswith('| G') or l.startswith('| TOTALE'):
        c = cells(l)
        key = c[0].replace('*', '')
        nums = [int(re.match(r'\d+', x.replace('*', '')).group(0)) for x in (c[1], c[3], c[4], c[5], c[6], c[7])]
        dec[key] = dict(zip(('righe', 'entrambe', 'soloSOPRA', 'soloSOTTO', 'NM', 'EREDITA'), nums))
def dkey(g, view):
    if g == 'G6a': return 'G6a cacce breakout (vista con screening)' if view == 'A' else 'G6a (vista solo tick)'
    return {'G1': 'G1 aperture, Live5m, DAX M3', 'G2': 'G2 EMA200, SuperWave, ORB', 'G3': 'G3 notte, eventi, Bulge, Londra',
            'G4': 'G4 forex di agosto, Fibo, Corso', 'G5': 'G5 SupRev, GoldenCross, oro', 'G6b': 'G6b cacce reversal e medie'}[g]
print('BASE: consolidato sez.1 riletta contro 0.1 (dichiarato)')
for view, base in (('A', base_A), ('T', base_T)):
    for g, _, _ in GR:
        if g != 'G6a' and view == 'T': continue
        d = dec[dkey(g, view)]
        same = all(base[g][k] == d[k] for k in d)
        ok_tot &= same
        print('  %-3s %-4s righe %2d entr %2d soloS %d soloT %d NM %2d ERED %d | %s' % (
            view, g, base[g]['righe'], base[g]['entrambe'], base[g]['soloSOPRA'], base[g]['soloSOTTO'], base[g]['NM'], base[g]['EREDITA'],
            'UGUALE al consolidato' if same else 'DIFFERENTE !!! dichiarato %s' % d))

# ---- 3) proposte di cambio di classe: C 5.d (parsate), A e B (asserzioni lette + transizioni mappate)
prop = {}   # riga consolidato -> nuova classe (valida per A e T: dati tutti [T])
c5d = LC.split('### 5.d')[1].split('### 5.e')[0]
for l in c5d.split('\n'):
    if l.startswith('| ') and not l.startswith('|---'):
        c = cells(l)
        m = re.search(r'NM\s*->\s*(SOTTO|ENTRAMBE)', c[-1]) if len(c) >= 4 else None
        if m:
            ea = c[0].replace('*', '')
            n = [k for k, v in rows.items() if '`ABTG_%s`' % ea in v[1]]
            assert len(n) == 1, (ea, n)
            prop[n[0]] = (ea, m.group(1))
print('PROPOSTE DI CAMBIO CLASSE DI RIGA lette da C sez. 5.d:', {k: v for k, v in prop.items()})
# asserzioni di A e B sul fatto che nessun conteggio cambia (testo letterale cercato nei file)
a_ass = 'non cambia per nessuna delle 12 righe' in LA
b_ass = 'I conteggi per EA dei gruppi (EA con celle SOPRA / SOTTO) non cambiano' in LB
print('A dichiara "il conteggio ... di G4 non cambia per nessuna delle 12 righe":', a_ass)
print('B dichiara "I conteggi per EA dei gruppi (EA con celle SOPRA / SOTTO) non cambiano":', b_ass)
ok_tot &= a_ass and b_ass
# transizioni di A e B per cella: ciascuna lascia invariata la CLASSE DI RIGA (motivo scritto)
TRANS = [
 ('B V1 770250 14d SOPRA->SOTTO', 14, 'ENTRAMBE', 'restano SOPRA 14a (770260) e 14k'),
 ('B V7 MaxMinNotte 1a NM->SOPRA(screening)', 41, 'ENTRAMBE', 'era gia\' ENTRAMBE (+celle NM)'),
 ('B V6 SupRev NAS R163a NM->SOPRA', 72, 'ENTRAMBE', 'era gia\' ENTRAMBE'),
 ('B V2 770511 resta NM; +cella r120b01 SOTTO', 32, 'ENTRAMBE', 'conteggiata ENTRAMBE da G2 (CONTESA->NM, short SOTTO, R120 SOPRA)'),
 ('B V5 ORB_Ott +riga D30EUR OPPRANGE MISTA', 36, 'ENTRAMBE', 'era gia\' ENTRAMBE'),
 ('A V11 SupRev 225JPY r166a NM->SOPRA s.OOS', 67, 'ENTRAMBE', 'era gia\' ENTRAMBE (15/14/1)'),
 ('A V8 Larry XAU long SOPRA(D)->SOTTO 22 anni', 61, 'ENTRAMBE', 'restano SOPRA U30USD/EURAUD (G4 6a)'),
 ('A V2 BB casella 3', 55, 'ENTRAMBE', 'solo certificato'),
 ('A V1 C2C [B]->[T]', 56, 'ENTRAMBE', 'solo etichetta di dato'),
 ('A V10 PTE solo numeri', 47, 'ENTRAMBE', 'solo numeri (R78 contro r153a / r164a)'),
 ('A V13 SupRev_Ott r127b nessun cambio', 68, 'ENTRAMBE', 'valori identici al 13/09'),
]
for nome, n, atteso, perche in TRANS:
    got = classe(n, 'A')
    flag = 'OK' if got == atteso else 'DIFFERENTE !!!'
    ok_tot &= (got == atteso)
    print('  transizione (classe di riga invariata) %-45s riga %3d: classe %-8s atteso %-8s %s | %s' % (nome, n, got, atteso, flag, perche))

# ---- 4) conteggi proposti
def new_cls(n, view):
    return prop[n][1] if n in prop else classe(n, view)
new_A, new_T = tot(new_cls, 'A'), tot(new_cls, 'T')
def agg(t, skipT=None):
    s = {k: sum(v[k] for v in t.values()) for k in ('righe', 'entrambe', 'soloSOPRA', 'soloSOTTO', 'NM', 'EREDITA')}
    s['almenoSOPRA'] = s['entrambe'] + s['soloSOPRA']; s['almenoSOTTO'] = s['entrambe'] + s['soloSOTTO']
    s['ctrl'] = s['entrambe'] + s['soloSOPRA'] + s['soloSOTTO'] + s['NM'] + s['EREDITA']
    return s
for nome, t in (('consolidato  (G6a con screening)', base_A), ('PROPOSTO     (G6a con screening)', new_A),
                ('consolidato  (G6a solo tick)', base_T), ('PROPOSTO     (G6a solo tick)', new_T)):
    s = agg(t)
    print('%-34s righe %d | entrambe %d | soloSOPRA %d | soloSOTTO %d | NM %d | EREDITA %d | controllo %d | almeno SOPRA %d | almeno SOTTO %d' % (
        nome, s['righe'], s['entrambe'], s['soloSOPRA'], s['soloSOTTO'], s['NM'], s['EREDITA'], s['ctrl'], s['almenoSOPRA'], s['almenoSOTTO']))
    ok_tot &= (s['ctrl'] == 116)
# solo tick = vista T per G6a e A per gli altri gruppi (sono uguali, G6a e' l'unico con due viste)
# confronto con la tabella 5.d di C (solo G6a)
t5 = LC.split('**Conteggi di G6a (sez. 2) se le proposte fossero accettate**')[1].split('### 5.e')[0]
vals = {}
for l in t5.split('\n'):
    if l.startswith('| ') and not l.startswith('|---') and not l.startswith('| lista'):
        c = cells(l)
        if c[0].startswith('SOPRA'): vals['S'] = c
        if c[0].startswith('SOTTO'): vals['T'] = c
        if c[0].startswith('entrambe'): vals['E'] = c
        if c[0].startswith('solo SOPRA'): vals['sS'] = c
        if c[0].startswith('solo SOTTO'): vals['sT'] = c
        if c[0].startswith('solo NM'): vals['N'] = c
num = lambda s: int(re.search(r'\d+', s.replace('*', '')).group(0))
cA = dict(S=num(vals['S'][2]), T=num(vals['T'][2]), E=num(vals['E'][2]), sS=num(vals['sS'][2]), sT=num(vals['sT'][2]), N=num(vals['N'][2]))
cT = dict(S=num(vals['S'][4]), T=num(vals['T'][4]), E=num(vals['E'][4]), sS=num(vals['sS'][4]), sT=num(vals['sT'][4]), N=num(vals['N'][4]))
for lab, view, c in (('A', 'A', cA), ('T', 'T', cT)):
    d = new_A['G6a'] if view == 'A' else new_T['G6a']
    mine = dict(S=d['entrambe'] + d['soloSOPRA'], T=d['entrambe'] + d['soloSOTTO'], E=d['entrambe'], sS=d['soloSOPRA'], sT=d['soloSOTTO'], N=d['NM'])
    same = mine == c
    ok_tot &= same
    print('G6a vista %s: script %s | tabella 5.d di C %s | %s' % (lab, mine, c, 'UGUALE' if same else 'DIFFERENTE !!!'))
# sensibilita' unica: la cella VolExpBreak U30USD kStop 2,5 (PF OOS 1,042) e' "SOPRA formale" (D2 non firmata)
if 100 in prop:
    for vista, t in (('A', new_A), ('T', new_T)):
        a = agg(t)
        print('SENSIBILITA D2 (solo VolExpBreak), vista %s: se la cella 1,042 non contasse come SOPRA, la riga 100 passa a solo SOTTO -> almeno SOPRA %d, almeno SOTTO %d, entrambe %d, solo SOTTO %d' % (
            vista, a['almenoSOPRA'] - 1, a['almenoSOTTO'], a['entrambe'] - 1, a['soloSOTTO'] + 1))
# ---- 5) quadratura del trasporto, letta dai tre file
def g(rx, s): return [int(x) for x in re.search(rx, s).groups()]
nA = g(r'(\d+) NUOVI, (\d+) AGGIORNATI \(.*?\), (\d+) IDENTICO', LA)
nB = g(r'\*\*(\d+) nuovi\*\* \(entrati il 05/10\), \*\*(\d+) aggiornati\*\*.*?\*\*(\d+) invariati\*\*', LB)
nC = g(r'\*\*(\d+) NUOVI\*\* \(.*?\), \*\*(\d+) AGGIORNATI\*\*.*?\*\*(\d+) IDENTICI\*\*', LC)
S = [sum(x) for x in zip(nA, nB, nC)]
print('TRASPORTO nuovi/aggiornati/identici  A %s  B %s  C %s  somma %s = %d CSV (scritti = nuovi+aggiornati = %d; il transcript dice 254 trovati, 191 scritti)' % (nA, nB, nC, S, sum(S), S[0] + S[1]))
ok_tot &= (sum(S) == 254 and S[0] + S[1] == 191)
print('ESITO COMPLESSIVO:', 'TUTTI I CONTROLLI UGUALI' if ok_tot else 'ALMENO UNA DIFFERENZA')
```

**Output** (sul repo a HEAD `f49d76c3`, con i quattro file come committati):

```text
BASE: consolidato sez.1 riletta contro 0.1 (dichiarato)
  A   G1   righe 26 entr  5 soloS 2 soloT 3 NM 13 ERED 3 | UGUALE al consolidato
  A   G2   righe 14 entr  8 soloS 0 soloT 1 NM  5 ERED 0 | UGUALE al consolidato
  A   G3   righe 14 entr  8 soloS 1 soloT 2 NM  2 ERED 1 | UGUALE al consolidato
  A   G4   righe 12 entr  7 soloS 0 soloT 1 NM  4 ERED 0 | UGUALE al consolidato
  A   G5   righe 19 entr 12 soloS 2 soloT 0 NM  4 ERED 1 | UGUALE al consolidato
  A   G6a  righe 17 entr  8 soloS 1 soloT 1 NM  7 ERED 0 | UGUALE al consolidato
  A   G6b  righe 14 entr  5 soloS 0 soloT 4 NM  5 ERED 0 | UGUALE al consolidato
  T   G6a  righe 17 entr  6 soloS 1 soloT 2 NM  8 ERED 0 | UGUALE al consolidato
PROPOSTE DI CAMBIO CLASSE DI RIGA lette da C sez. 5.d: {93: ('DaxValueArea', 'SOTTO'), 102: ('Cycle', 'SOTTO'), 100: ('VolExpBreak', 'ENTRAMBE')}
A dichiara "il conteggio ... di G4 non cambia per nessuna delle 12 righe": True
B dichiara "I conteggi per EA dei gruppi (EA con celle SOPRA / SOTTO) non cambiano": True
  transizione (classe di riga invariata) B V1 770250 14d SOPRA->SOTTO                  riga  14: classe ENTRAMBE atteso ENTRAMBE OK | restano SOPRA 14a (770260) e 14k
  transizione (classe di riga invariata) B V7 MaxMinNotte 1a NM->SOPRA(screening)      riga  41: classe ENTRAMBE atteso ENTRAMBE OK | era gia' ENTRAMBE (+celle NM)
  transizione (classe di riga invariata) B V6 SupRev NAS R163a NM->SOPRA               riga  72: classe ENTRAMBE atteso ENTRAMBE OK | era gia' ENTRAMBE
  transizione (classe di riga invariata) B V2 770511 resta NM; +cella r120b01 SOTTO    riga  32: classe ENTRAMBE atteso ENTRAMBE OK | conteggiata ENTRAMBE da G2 (CONTESA->NM, short SOTTO, R120 SOPRA)
  transizione (classe di riga invariata) B V5 ORB_Ott +riga D30EUR OPPRANGE MISTA      riga  36: classe ENTRAMBE atteso ENTRAMBE OK | era gia' ENTRAMBE
  transizione (classe di riga invariata) A V11 SupRev 225JPY r166a NM->SOPRA s.OOS     riga  67: classe ENTRAMBE atteso ENTRAMBE OK | era gia' ENTRAMBE (15/14/1)
  transizione (classe di riga invariata) A V8 Larry XAU long SOPRA(D)->SOTTO 22 anni   riga  61: classe ENTRAMBE atteso ENTRAMBE OK | restano SOPRA U30USD/EURAUD (G4 6a)
  transizione (classe di riga invariata) A V2 BB casella 3                             riga  55: classe ENTRAMBE atteso ENTRAMBE OK | solo certificato
  transizione (classe di riga invariata) A V1 C2C [B]->[T]                             riga  56: classe ENTRAMBE atteso ENTRAMBE OK | solo etichetta di dato
  transizione (classe di riga invariata) A V10 PTE solo numeri                         riga  47: classe ENTRAMBE atteso ENTRAMBE OK | solo numeri (R78 contro r153a / r164a)
  transizione (classe di riga invariata) A V13 SupRev_Ott r127b nessun cambio          riga  68: classe ENTRAMBE atteso ENTRAMBE OK | valori identici al 13/09
consolidato  (G6a con screening)   righe 116 | entrambe 53 | soloSOPRA 6 | soloSOTTO 12 | NM 40 | EREDITA 5 | controllo 116 | almeno SOPRA 59 | almeno SOTTO 65
PROPOSTO     (G6a con screening)   righe 116 | entrambe 54 | soloSOPRA 6 | soloSOTTO 14 | NM 37 | EREDITA 5 | controllo 116 | almeno SOPRA 60 | almeno SOTTO 68
consolidato  (G6a solo tick)       righe 116 | entrambe 51 | soloSOPRA 6 | soloSOTTO 13 | NM 41 | EREDITA 5 | controllo 116 | almeno SOPRA 57 | almeno SOTTO 64
PROPOSTO     (G6a solo tick)       righe 116 | entrambe 52 | soloSOPRA 6 | soloSOTTO 15 | NM 38 | EREDITA 5 | controllo 116 | almeno SOPRA 58 | almeno SOTTO 67
G6a vista A: script {'S': 10, 'T': 12, 'E': 9, 'sS': 1, 'sT': 3, 'N': 4} | tabella 5.d di C {'S': 10, 'T': 12, 'E': 9, 'sS': 1, 'sT': 3, 'N': 4} | UGUALE
G6a vista T: script {'S': 8, 'T': 11, 'E': 7, 'sS': 1, 'sT': 4, 'N': 5} | tabella 5.d di C {'S': 8, 'T': 11, 'E': 7, 'sS': 1, 'sT': 4, 'N': 5} | UGUALE
SENSIBILITA D2 (solo VolExpBreak), vista A: se la cella 1,042 non contasse come SOPRA, la riga 100 passa a solo SOTTO -> almeno SOPRA 59, almeno SOTTO 68, entrambe 53, solo SOTTO 15
SENSIBILITA D2 (solo VolExpBreak), vista T: se la cella 1,042 non contasse come SOPRA, la riga 100 passa a solo SOTTO -> almeno SOPRA 57, almeno SOTTO 67, entrambe 51, solo SOTTO 16
TRASPORTO nuovi/aggiornati/identici  A [76, 5, 1]  B [68, 28, 38]  C [12, 2, 24]  somma [156, 35, 63] = 254 CSV (scritti = nuovi+aggiornati = 191; il transcript dice 254 trovati, 191 scritti)
ESITO COMPLESSIVO: TUTTI I CONTROLLI UGUALI
```

**Contro-esempio** (regola del 10/09: provare a ROMPERE lo strumento prima di fidarsene). Ho copiato i quattro file in una cartella a parte e **cambiato due cose**: nel consolidato la riga 100 (`VolExpBreak`) da "NM / NM" a "SOTTO / SOTTO"; in C la tabella 5.d (colonna "A dopo", riga "entrambe") da 9 a 10. Rilanciato con `RDIR` sulla copia, lo script **segnala DIFFERENTE** in tre punti: G6a vista A e vista T contro il dichiarato del consolidato 0.1 (NM 6 invece di 7 e 7 invece di 8, solo SOTTO 2 e 3 invece di 1 e 2), e G6a vista A contro la tabella 5.d di C ("entrambe" 9 contro 10), **ESITO COMPLESSIVO: ALMENO UNA DIFFERENZA**. Sui file originali: tutti uguali. Lo script **non e' un timbro**: vede le differenze. **Limite dichiarato**: la classe di riga dipende dal testo della colonna "classe" del consolidato; se un domani qualcuno la scrive con parole diverse dallo schema ENTRAMBE / SOPRA / SOTTO / NM / EREDITA, lo script puo' sbagliare in silenzio **solo se** anche il confronto con 0.1 coincide per caso: per questo il confronto con 0.1 e' la prima cosa che fa.

## APPENDICE B - CONTROLLO "NESSUN NUMERO NUOVO"

`verifica_numeri.py` rilegge le sezioni 1, 3, 4, 5 e 6 di questo file, estrae ogni numero (decimali con virgola, migliaia con punto, interi di 3 o piu' cifre; esclusi date, rimandi a sezioni delle letture tipo `A 4.2` o `B V1`, id di riga `#` e righe del piano) e controlla che compaia **come numero intero, non come parte di un altro** nei quattro file sorgente (consolidato + A + B + C). **Esito: 532 numeri controllati, 0 non trovati.**
**Secondo controllo, piu' stretto** (sez. 1, tre sottotabelle): i numeri della colonna "dopo la lettura" cercati **solo** nel file della lettura citata (A, B o C), quelli della colonna "consolidato" cercati **solo** nel consolidato. **Esito: 235 numeri, 0 non trovati.**
**Contro-esempio**: in una copia ho cambiato un solo numero ("PF combinato 1,0996" in "1,0997", riga 14 di sez. 1); lo script lo segnala in **tutti e due** i controlli (1 non trovato su 532; 1 su 235). Non e' un timbro.
**Limiti dichiarati**: (a) il primo controllo cerca il numero **in qualunque punto** dei quattro file, non nella riga giusta: un numero potrebbe esistere ma in un'altra cella (confusione di cella); il secondo e' piu' stretto ma resta a livello di file; (b) i **conteggi della sez. 2** non sono controllati cosi': sono miei e sono rifatti dallo script di Appendice A; (c) i numeri scritti in lettere o come aritmetica (per esempio "35 + 6 + 5 = 46", "-3", "+2") non sono estratti: li ho controllati a mano contro il consolidato 3(a) e contro le sez. 2.2 di questo file; (d) lo script **non e' in repo** (solo `conta_addendum.py` e' riportato qui sopra), come `verifica_numeri.py` del consolidato.

---

## CHANGELOG
| data | cosa | perche' |
|---|---|---|
| 05/10/2026 | creato l'addendum (sez. 0-7, appendici A-B): 32 righe di EA, conteggi proposti, 36 smentite, caselle del certificato, NON LEGGIBILE, decisioni; **bozza, NON passata dal cancello** | richiesta del 05/10/2026: aggiornare il consolidato con i CSV trasportati, senza riscriverlo |
