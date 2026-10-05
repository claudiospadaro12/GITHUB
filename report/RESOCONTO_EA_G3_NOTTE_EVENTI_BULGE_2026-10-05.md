# RESOCONTO EA - GRUPPO G3 (NOTTE, PTE/WOL, POSTNEWS, BULGE, LONDRA) - SCHEDE RIEMPITE - 05/10/2026

> **DOCUMENTO INTERNO. NON ESCE.** Fase 2 del resoconto richiesto da Claudio il 05/10/2026 (*"un resoconto di tutti gli EA con PF sopra 1 e sotto 1: che backtest e' stato fatto, che anni sono stati misurati, che tipologie di mercato hanno superato, se sono migliorabili e cosa serve"*).
> Piano e regola di classificazione: `report/RESOCONTO_EA_PIANO_2026-10-05.md` (sez. 5-8). Questo file riempie le schede del **gruppo G3**: 14 file (12 EA, 1 copia `Nightly_Ottimizzato`, 1 copia di sola misura `..._MFE`) piu' 1 scheda di confine (`Londra_ORB`, assegnata a G2 ma toccata dal punto dubbio D6).
> **Perimetro**: sola lettura d'archivio. Nessun round lanciato, nessun EA/preset/sedia/conto toccato, nessun altro file di altri agenti toccato. Forward = **solo demo** (niente challenge/trial). **Stato del cancello**: bozza dell'agente G3, lo strato 2 (`controllo-preventivo`) **NON e' stato invocato**: il documento non va mandato a nessuno prima di quel PASS.
> **Regola di precedenza usata**: il CSV primario batte il referto, il referto batte la prosa; fra due fonti dello stesso rango vince la piu' recente e lo scrivo (sez. 3). Dove il CSV primario **non e' nel repo** lo dichiaro `[SOLO REGISTRO]`. Dove un numero non c'e' scrivo **NON MISURATO**.

---

## 0. COME LEGGERE (convenzioni)

- **Tipo di dato**: `[T]` tick reali BCM (modello 4; sul forex i tick veri partono dal **05/07/2024**, sugli indici dal **26/09/2024**, sull'oro dal **10/07/2024** secondo il giornale del tester di R268) · `[B]` barre OHLC M1 (modello 1) = **screening**: non promuove e non boccia, il PF a barre eccede quello a tick di 1,72-3,51x (`REGISTRO_TEST` sez. 0) e il DD e' un limite inferiore · `[G]` tick generati dalle M1 · `[E]` feed esterno.
- **n**: `D` = deal di uscita (colonna `Trades` dei CSV, con `InpTP1Pct=50` una posizione puo' dare 2+ deal) · `P` = posizioni. Il fattore D/P misurato in casa va da 1,00 a 2,31; dove non ho un per-trade scrivo solo `D` e la forbice.
- **Deposito / rischio** dichiarati accanto al numero quando la fonte li da'.
- **Affidabilita'** (§5.4 del piano): A = n OOS >= 150 P + OOS vero + >= 2 regimi misurati uno per uno · B = n >= 150 P ma un regime · C = 30-149 P (merito sospeso) · D = < 30 P (indizio). Aggiungo **"(senza OOS)"** quando il PF e' su finestra piena, e **SEGNO INVERTITO** quando IS e OOS stanno da parti opposte di 1.
- **Sorgente di un solo regime**: sugli indici BCM la finestra e' ~21 mesi dal 26/09/2024 (toro, con la discesa feb-apr 2025). Tutto il resto dei regimi e' `NON MISURATO`, mai stimato.
- **"Tipologie di mercato"** si legge in due modi e riporto entrambi: (a) **classi di strumento / simboli** con PF >= 1 in OOS, (b) **regimi** (toro / orso / laterale / crollo) con il periodo e se misurato.
- Soglia di "ZONA GRIGIA" sul PF **non esiste** (D2 del piano): un "SOPRA 1" con PF 1,00-1,10 e' scritto **SOPRA formale (indistinguibile da 1)**, mai "buono".

---

## 1. TABELLA RIASSUNTIVA (una riga per cella o gruppo di celle)

Legenda classe: SOPRA / SOTTO / NM (NON MISURATO). PF OOS = PF fuori campione se esiste, altrimenti PF di finestra piena marcato "(s.OOS)". `n` in D o P come dichiarato.

| # | EA / cella | dato | PF OOS (IS) | n | anni misurati | regimi misurati | classe + affid. | verdetto di casa | migliorabile |
|---|---|---|---|---|---|---|---|---|---|
| 1a | MaxMinNotte XAUUSD H2 due lati (geometria del preset 770402) | [B] 0,5% dep 100k | 1,308 (s.OOS) | 693 D = 511 P | 6,5 anni: 2020.01.01-2026.06.30 | toro 2020 · laterale 2021-22 · toro 2023-26; anni negativi 2021 e 2023 | SOPRA, B (s.OOS, [B]) | MERITO leggibile solo come screening; **NO PER RISCHIO a 2,00%** (DD ~19,6-21,3% derivato) | si (taglia = firma; serve tick lungo) |
| 1b | MaxMinNotte XAUUSD **solo long** tick | [T] 0,5% dep 100k | 1,453 (s.OOS) | 93 P (118 D) | 2 anni: 2024.07.10-2026.06.30 | toro 2024-26; resto NM | SOPRA, C | MERITO SOSPESO (n<150); DD 2,34% | si |
| 1c | MaxMinNotte XAUUSD solo long, **22 anni** | [B] 0,5% dep 100k | 1,096 (s.OOS) | 725 P (950 D) | 22 anni: 2004.06.11-2026.06.30 | per anno: **11 anni negativi su 23** (2005, 2006, 2008 PF 0,54, 2010, 2011, 2013 PF 0,41, 2014, 2015, 2019, 2021, 2023) | SOPRA formale (~1,10), B (s.OOS, [B]) | RISCHIO **fuori contratto (D3)**: DD equity 10,30% contro 10,0% (R100, altra configurazione); decide Claudio | si (decisione di rischio di Claudio) |
| 1d | MaxMinNotte XAUUSD solo short | [B] 0,5% | 1,254 (s.OOS) | 232 P (318 D) | 2020.01.01-2026.06.30 | idem 1a | SOPRA, B (s.OOS, [B]) | lato debole; non attivo | si |
| 1e | MaxMinNotte XAUUSD geometria R17/R19 (22:00-06:59, buffer 250, H2) | [T]? 1,0% | 1,908 / 2,452 (IS 1,33 / 1,42) | 82 D / 92 D (33-68 P) | IS 2025.03-2025.09, OOS 2025.09-2026.06 (~16 mesi) | 1 regime (oro raddoppiato di volatilita') | SOPRA, D | ASTERISCHI dichiarati dal referto R17 | no (geometria superata) |
| 1f | MaxMinNotte **D30EUR LONG** (due lati/solo long, 41 celle distinte) | [T] 0,65-1,0% | max 0,947 · R261a filtro S&P acceso 0,883 (s.OOS) | 85-206 D · 72 P | 2024.09.26-2026.06.30 (~21 mesi) | 1 regime (toro) | **SOTTO**, C (s.OOS) | NON ANCORA MISURATO (manca: gemelli col filtro acceso) | si, ma solo per chiudere il certificato |
| 1g | MaxMinNotte F40EUR / E50EUR / 100GBP | [T] 1% dep 10k | max 0,9985 / 0,8398 / 0,6717 (s.OOS) | 52-238 D | 2024.01.01-2026.06.30 nominale (dati dal 2024.09.26) | 1 regime | **SOTTO** (0/54 celle per simbolo) | NON ANCORA MISURATO (TF mai cambiato: `InpMgmtTF`=15 su 216/216) | priorita' bassa |
| 1h | MaxMinNotte EURUSD M15 | [B] 2% | 0,00 (IS n=1) | 1 / 0 D | fase 0 | - | **NM** | Trades~0 = NON e' una misura | si |
| 1i | MaxMinNotte NASUSD | - | - | 0 | mai girato | - | **NM** | casella libera; 2 file prova pronti (R187) | si |
| 2a | MaxMinNotte_DAX_Short_Ott (770411) D30EUR M15 short + filtro S&P | [T] 1%, dep 100k | 2,160 (IS 1,878) | **14 P** (21 D) | 2024.09.26-2026.06.30; IS ~8,5 mesi, OOS ~12,7 | 1 regime (toro) | SOPRA, **D** | MERITO SOSPESO; DD OOS 1,92% | si |
| 2b | idem, cella "arma alla cash d'inverno" (d+1) | [T] 1% | 0,996 (d0 inverno 2,558; d0 estate 1,450) | 17 P (16 / 11 P) | 2 stagioni invernali dentro la finestra | stagione, non regime | **SOTTO (~1)**, D | INDIZIO debole (STAGIONE) | si |
| 3 | MaxMinNotte_DAX_Short_Ott_MFE | [T] misura MFE | nessun PF (12,93 R vs 6,60 R) | 29 | 2024.09.26-2026.08.24 | - | **NM** | NON MISURABILE (n=29 < 30) | no |
| 4 | BreakinBox D30EUR M15 | [T] 1% | 1,007 (gamba A) / 1,106 (gamba B RR 2,0) (s.OOS) | 416 D / 354 D | 2024.09.26-2026.06.30 | 1 regime | SOPRA formale (~1), B (s.OOS) | **NO PER RISCHIO** (DD 24,1% / 19,7% > 15%) | no (capitolo chiuso, Regola 19/08) |
| 5a | Nightly EURCHF M5/M15 | [T] 1%, dep 10k | 0,814 (IS 0,891) | 85 D (63 IS) | 2024.09.26-2026.06.30 | 1 regime | **SOTTO**, C | NO PER RISCHIO (DD 11,1/15,4%) | si (finestra lunga + uscita) |
| 5b | Nightly EURUSD / USDCHF | [B] 1% | 0,861 / 0,970 (IS 1,049 / 0,863) | 164 / 131 D | 2024.09.26-2026.06.30 | 1 regime | **SOTTO**, C-B | NO PER RISCHIO (DD 14-15%) | si |
| 5c | Nightly GBPUSD | [B] 1% | 1,040 (IS **0,586**) | 163 D | idem | 1 regime | SOPRA formale, **SEGNO INVERTITO** | NO PER RISCHIO (DD IS 22,6%) | si |
| 5d | Nightly sei simboli R259 (AUDUSD, USDJPY, XAUUSD, XAGUSD, D30EUR, U30USD) | [B] 1% dep 10k | 0,951 / 0,675 / 0,996 / NULLO / 0,964 / 0,860 (IS 0,756 / 0,701 / 0,752 / - / 0,603 / 1,123) | 500 / 480 / 140 / - / 163 / 130 D | forex+metalli 2019.01.01-2026.06.30; indici 2024.09.26-2026.06.30 | 7,5 anni non separati per regime | **SOTTO** (5 su 5 validi) | NIENTE a questa gestione (4 simboli) / NON ANCORA MISURATO (3 con n<150) | si (uscita, stadio 2) |
| 6 | Nightly_Ottimizzato | - | - | - | - | - | EREDITA (= Nightly) | stesso sorgente salvo default e magic | = Nightly |
| 7a | PTE GBPUSD H1 tick (config viva) | [T] 1% dep 100k | 1,378 (IS 40,98 su 20 D) | 49 D = 27 P | 2024.07.05-2026.06.30 (IS->2025.04.21) | 1 regime (a tick); orso 2022 con feed generato 0,75 | SOPRA, D | MERITO SOSPESO | si |
| 7b | PTE USDJPY H1 tick | [T] 1% | 1,285 (IS 1,004) | 35 D = 20 P | idem | 1 regime | SOPRA, D | MERITO SOSPESO; funziona solo nel laterale (R80) | si |
| 7c | PTE U30USD H1 tick (771321) | [T] 1% | 1,171 (IS 1,178) | 40 D = 23 P | 2024.09.26-2026.06.30 | 1 regime | SOPRA, D | MERITO SOSPESO; DD CSV 3,22% (contratto dice 2,18%: D16) | si |
| 7d | PTE GBPUSD H1, **13 anni** OHLC | [B] 1% | viva **0,972** / candidata B25 **1,095** (IS -14.808 / -6.273) | 447 D / 477 D | IS 2000.01.01-2013.03.31, OOS 2013.04.01-2026.06.30 | per anno non separato; DD 17,68% / 9,87% | viva SOTTO, B-screening; candidata SOPRA formale (<1,10) | a 13 anni la sedia viva **perde** | si |
| 7e | PTE USDJPY H1, 13 anni OHLC | [B] 1% | 0,935 (miglior cella 1,011; IS +6.626 -> OOS -2.317) | 456 D | idem | SEGNO INVERTITO fra IS e OOS | **SOTTO**, B-screening | "su USDJPY questo motore non ha edge" (R78) | no |
| 7f | PTE oro H4 (FASE 0) / D30EUR / NASUSD / 225JPY / SPXUSD / XAGUSD | [B]+[T] | oro 0/16 celle; DAX H1 BE0 1,34 su 33 D; altri n<=15 | 6-43 D | 2024-2026 | - | oro **SOTTO**; altri NM per campione | OOS spettacolare con IS rosso = REGIME non edge | si |
| 8 | PTE_Ottimizzato (buffer in ATR, R74) | [T] GBPUSD/USDJPY, [B] U30USD | GBPUSD 1,18-1,98 (14/14 sopra 1) · USDJPY 0,86-1,43 (10/14) · U30USD 0,77-1,47 (7/14) | 47-52 D · 42-44 D · 40-42 D | IS 2024.07.05-2025.04.21, OOS ->2026.06.30 (U30USD dal 2024.09.26) | 1 regime | SOPRA (GBPUSD) / MISTA, **D** | NON e' una cella di contratto: 14 celle di griglia | si |
| 9a | WOL, TF D1 (default) | [T]+[B] 1% dep 10k | n 0-19 D in ogni finestra, PF 0,00-0,52 (un 31,2 su 11 D) | 0-19 D | 2024.01.01-2026.06.30 | - | NM (campione) | la cella di default **non si misura** | si |
| 9b | WOL, 11 TF x 9 simboli (sweep) | [T]+[B] | tick: celle con PF>=1 sia IS sia OOS = 3 (NASUSD H1, NASUSD H2, SPXUSD H8) su 55 coppie | OOS fino a 263 D | idem | 1 regime | SOPRA (3 celle coerenti, **profitti +5..+190 su 10.000**) e SOTTO (la maggioranza) | "profitti da spread / spiccioli" (referto 11/08); DD 0,4-1,3% | si |
| 9c | WOL oro D1, 22 anni | [B] | PF NON PUBBLICATO | - | 2004/2008-2026.06.30 | - | NM (solo DD 1,17%) | senza metro | si |
| 10a | PostNews ISM (EURUSD, 15:15 server) | **[B]** | 0,79 (IS 0,76) | 312 / 234 D | IS 2010-2015, OOS 2015-2023 | non separati | **SOTTO**, B-screening [SOLO REGISTRO] | PF<1 su entrambe le finestre | no (meccanismo; "uscita a tempo 30'" e' epoca 2010-11) |
| 10b | PostNews 13:30 (USDJPY, blocco CPI/Retail/PPI) | **[B]** | 0,90 (IS 0,66) | 253 / 151 D | idem | non separati | **SOTTO**, B-screening [SOLO REGISTRO] | PF<1 su entrambe | no |
| 10c | PostNews sedie reali 771201 ECB EURJPY / 771202 FOMC EURUSD / 771203 NFP USDJPY | - | **nessuno** (4 CSV con Trades=0) | 0 | mai misurate | - | **NM** | contratto `[NON MISURATO]` | si |
| 11a | Bulge v5.20 AMPIA, 22 cross H1 | [B] 0,80% dep 10k | 0,816 (IS 0,871) | 363 / 410 D | **4 mesi**: IS 2026.03.02-04.30, OOS 2026.05.02-06.29 | 1 regime | **SOTTO**, C-B | DD 13,7 / 22,8% | si (misura M1 lunga) |
| 11b | Bulge v5.20 sul solo GBPUSD / su 8 cross dollaro | [B] 0,80% | 1,212 (IS 0,867) / 1,096 (IS 0,742) | 42 D / 233 D | idem | 1 regime | SOPRA formale, **SEGNO INVERTITO**, D / C | 2 celle di diagnosi, non contratto | si |
| 11c | Bulge: backtest di partenza di Claudio (PF 1,599, n 268) | tick 40% | 1,599 | 268 | 2022.01.01-2026.03.30 | - | **escluso dalla classifica** (regola 5.2.5: non e' una misura nostra) | - | - |
| 12 | BULGE_MASTER | - | - | - | - | - | **NM** | consolidamento esterno, nessuno merita spesa (A106) | no |
| 13 | LondonFx (3 motori) EURUSD/GBPUSD M15 | [T] 0,65% dep 100k | EURUSD 0,843 / 0,898 / 0,923 (IS 0,795 motore 2) · GBPUSD 0,763 (IS 0,688) | 1.132-2.253 D | IS 2024.07.05-2025.04.21, OOS 2025.04.22-2026.06.30 | 1 regime | **SOTTO**, B | **NO PER RISCHIO** (DD 31-61%) | no (chiuso 2 volte) |
| 14 | AllineaLondra EURUSD M15 | [T] 0,65% dep 100k | tick 0,70-0,88 (4 celle) / OHLC 0,68-1,01 | 248-930 D | tick 2024.07.05-2026.06.30; OHLC 2022.07.01-2026.06.30 | 1 regime | **SOTTO** (tick), una cella OHLC ~1,01 | passo 0: PF letto, non giudicato | si, ma prior pessimo |
| 15 | (confine G2) Londra_ORB GBPUSD/EURUSD M5, ora 08:00 server | [T] | 0,975 (IS 1,054) GBPUSD ora 8 / 0,906 (IS 1,175) EURUSD ora 8 | 296 D / 296 D | 2024.07.05-2026.06.30 | 1 regime | **SOTTO**, B | BOCCIATA PER RISCHIO + ESCLUSA PER COSTO (R258, 28/09) | no |

**Il punto D6 del piano e' CHIUSO per `Londra_ORB`**: R258 (28/09) l'ha misurato **all'ora giusta** (sezione 4.15). Per `Nightly` resta aperto (sezione 4.5).

---

## 2. CONTEGGIO (EA del gruppo, non celle)

Regola del piano §5.1: un EA sta in SOPRA se ha **almeno una cella SOPRA**, in SOTTO se ha **almeno una cella SOTTO**, in NM se **non ha nessuna cella con un PF**. Un EA puo' stare in due liste.

| lista | quanti dei 14 file | quali |
|---|---:|---|
| **SOPRA** (almeno una cella) | **9** | MaxMinNotte (oro) · MaxMinNotte_DAX_Short_Ott (14 P, D) · BreakinBox (PF ~1,007/1,106, formale) · Nightly (GBPUSD OOS 1,04, SEGNO INVERTITO) · PTE · PTE_Ottimizzato · WOL (3 celle di sweep, spiccioli) · Bulge (2 celle di diagnosi, SEGNO INVERTITO) · AllineaLondra (una cella OHLC ~1,01, formale) |
| **SOTTO** (almeno una cella) | **10** | MaxMinNotte (DAX long, indici EU) · MaxMinNotte_DAX_Short_Ott (cella d+1 inverno 0,996) · Nightly · PTE (13 anni, oro) · PTE_Ottimizzato (U30USD/USDJPY) · WOL · PostNews (2 candidati) · Bulge · LondonFx · AllineaLondra |
| **solo NON MISURATO** | **3** | MaxMinNotte_DAX_Short_Ott_MFE (strumento) · BULGE_MASTER (esterno) · Nightly_Ottimizzato (EREDITA: stesso motore, nessuna misura propria) |
| in **entrambe** SOPRA e SOTTO | 8 | MaxMinNotte · DAX_Short_Ott · Nightly · PTE · PTE_Ott · WOL · Bulge · AllineaLondra |
| solo SOPRA | 1 | BreakinBox |
| solo SOTTO | 2 | LondonFx · PostNews (che ha anche 3 sedie NM) |

**Letture oneste da tenere accanto al conteggio:**
1. **Nessun EA del gruppo ha un'affidabilita' A**. La B compare solo su celle **a barre** (oro, PTE a 13 anni, Nightly AUDUSD/USDJPY, Bulge a 22 cross) o su celle SOTTO a tick (LondonFx, Londra_ORB); le celle SOPRA a tick sono C o D.
2. **Otto** delle nove "SOPRA" hanno **PF <= 1,10 oppure SEGNO INVERTITO oppure n < 30 P** (fa eccezione la sola cella oro di MaxMinNotte): la regola formale le mette in SOPRA, ma **non vuol dire "buono"** (D2).
3. L'**unica** cella SOPRA con **tick + n >= 30 P + nessuna inversione di segno** e' l'oro solo-long (93 P, 1 regime); PTE a tick (20-27 P) e 770411 (14 P) stanno in D. **Nessuna** arriva a 150 P.

---

## 3. RICONCILIAZIONI FRA FONTI (usata la piu' recente, dichiarato)

| # | punto | fonti in conflitto | decisione |
|---|---|---|---|
| R1 | oro "tick 1,45 su 93 pos" del dossier | il dossier lo mette come "MaxMin oro long"; il piano (#41) lo scrive "oro: tick OOS 1,45" senza dire il lato | e' il **SOLO LONG** a tick (R268a, CSV `ROUND_R268a`: PF 1,45273, 118 D, 93 P, DD equity 2,3434%), **non** il preset a due lati; il due lati a tick non esiste con la geometria del preset |
| R2 | DAX long "0/7" (piano #41, R242) | `STATO_MAXMIN_DAX_LONG_E_ORO` (34 righe), poi R261a/b/c e R267g (27-28/09) | **superato**: 0 celle su 41 distinte a tick >= 1,00; con filtro S&P acceso 0,883 su 72 P; uscita ad asse (R267g2-g4) e TF (R261b) ora riempiti, resta il solo punto (4) gemelli col filtro acceso |
| R3 | contratto `770411`: 1,92% vs 3,1% | `CONTRATTI_DELLE_SEDIE` §4.2 (CSV `_ptb` OOS Equity DD 1,9213% @1%, riprodotto da R81a/R246i/R261d al centesimo) vs registro 26/07 (3,1% @1%, n 41, PF 2,05, finestra unica) | vale il **1,9213%** (piu' recente, riprodotto 3 volte); il 3,1% e' di un'altra corsa/binario. **Il doppio contratto (B8) resta aperto come decisione**, non lo chiudo io |
| R4 | PostNews candidati ISM/13:30 "[T]" nel piano | `REGISTRO_TEST` r.1515+ dice "screening Modello 1 OHLC" | sono **[B]**, non [T]. I 4 CSV primari **non sono nel repo** (`[SOLO REGISTRO]`) |
| R5 | PTE 771321 DD: 2,18% vs 3,22% | `CENSIMENTO_CONTRATTI_v2` §4a (2,18% @1%) vs CSV `ABTG_PTE_U30USD_OOS_r23a.csv` (Equity DD % 3,2166; IS 3,2357) | **comanda il CSV**: 3,22% OOS. L'origine del 2,18% (aggregazione per giornata?) e' `[NON VERIFICATA]` |
| R6 | Nightly TF M5 vs M15 | `RIESAME_MORTI_NOTTURNI` e `R220a`/`R259` scrivono M5; registro A40-A41 e piano scrivono M15 | etichetta contraddittoria; il TF **non e' una manopola** su questo EA (box da M1 r.183-193, ATR da H1 r.120). Riporto "M5 (R259/R220)" per i round recenti |
| R7 | WOL "5 celle OOS n>=100 con PF 0,02-0,46" (piano) | `CENSIMENTO_PF` ha colonne `oos_trades_max` < mediana (aggregazione guasta) | **ricalcolato dai 28 CSV primari** (sez. 4.9): lo sweep ha anche celle OOS sopra 1 (U30USD 6/8 a tick) e 3 celle coerenti IS+OOS |
| R8 | `Londra_ORB` "R45 0/48 + fuso sbagliato" (piano #38) | `ANALISI_PDF_LONDRA` (zero CSV prima del 28/09), poi R258 in `LETTURA_ROUND_CORTI_A_2026-09-28.md` | **R258 ha misurato l'ora giusta** (08:00 server): il verdetto compromesso dal fuso e' sostituito. Il "R45 0/48" era di `ABTG_ORB_Ottimizzato`, **non** di `Londra_ORB` |
| R9 | oro forward: 12 trade PF 1,86 (23/09) vs 11 pos PF 1,45 (17/09) | `STATO_MAXMIN` §B.1 vs `CLASSIFICA_CAMPO_50503392` | stessa serie a due date; **lotto sempre 0,01** sul piccolo: il PF non e' confrontabile col backtest a 0,5% |
| R10 | R259 non e' nel registro di backtest_pipeline | `REGISTRO_TEST.md` r.686-699 dice ancora "causa [NON MISURATO]/non lanciati" | il round **e' girato il 28/09** (`LETTURA_ROUND_CORTI_A`): registro indietro (classe 576). Uso la lettura |

---

## 4. LE SCHEDE

### 4.1 `ABTG_MaxMinNotte` - famiglia NOTTE - G3 - ruolo: sedia 770402 oro H2 (campo, demo piccolo); EA generico per i simboli gemelli

1. **MOTORE**: box notturno letto su M1; due ordini stop OCO a rottura piazzati poco prima dell'apertura (DAX 07:59, oro 07:00 server), una operazione/giorno; SL ad ATR o estremo opposto del box; TP1 1R 50% + BE + TP2/EMA200/trailing; filtro di correlazione S&P opzionale (EMA14 contro EMA100 su H1 di `InpCorrSymbol`).
2. **SIMBOLI/TF**: D30EUR M15 · XAUUSD H2 (cella di contratto 770402) · F40EUR/E50EUR/100GBP M15 · EURUSD M15 · NASUSD mai girato. TF vero = `InpMgmtTF` (il box e' sempre M1): oro M5/M15/M30/H1/H2/H4 (R17 + `oro_maxmin_fase1_*`), DAX long M15-H4 (R261b), indici EU solo 15. **Sonda collegata**: `mql5/Scripts/ABTG_Notte_Study.mq5` (sola lettura, tasso di rottura notte per notte).
3. **BACKTEST FATTI**:
   - `valid_MaxMin` 26/07: [T], 10.000, 1%, ini 2024.01.01-2026.06.30 (dati dal 2024.09.26), 4 indici x 72 passate, finestra unica; `risultati_archivio/MaxMinNotte/*.csv`.
   - R242a (7 celle) e R244b (9 celle): [T], 100.000, 0,65%, 2024.09.26-2026.06.30, `@FRAZIONEIS 1.0` = **nessun OOS**; CSV in `risultati_archivio/R242` e `R244/ROUND_R244b` (PF riletti da me: 0,547-0,941).
   - R261a/b/c/d e R267g1-g4 (27-28/09): [T], 100.000, 1%, tranche unica 2024.09.26-2026.06.30; `ROUND_CORTI_B_2026-09-27`, `ROUND_CORTI_C_2026-09-28`.
   - R103 / R260a-c (24/08, 27/09): [B], 100.000, 0,5%, 2020.01.01-2026.06.30, `ROUND_CORTI_B`; R260c riproduce R103 alla cifra (G0 VERDE).
   - R268a-d, R269a-c (28/09): R268a [T] 2024.07.10-2026.06.30; R268b [B] stessa finestra; R268d [B] 2004.06.11-2026.06.30; R269a/b [B] 2020-2026 con flat alle 13:00; R269c [T] DAX long -1h.
   - R17/R19 (10/08): 20 celle, buffer x TF M30-H4, IS 2025.03-2025.09 / OOS 2025.09-2026.06; tipo dato `[INFERITO]` tick (nome file senza `_ohlc`). `oro_maxmin_fase1/2_{M5,M15,M30,H1}`: [B] griglie a 12/4 celle.
   - EURUSD M15 `ABTG_MaxMinNotte_EURUSD_{IS,OOS}_ohlc.csv`: [B], rischio 2%, **1 operazione IS, 0 OOS**.
4. **ANNI E REGIMI**: oro: 6,5 anni (2020-2026) e 22 anni a barre; per anno (R268d, solo long, posizioni per chiusura): 2005 PF 0,00 (5) · 2006 0,85 · 2007 2,34 · **2008 0,54 (45 P, -3.869)** · 2009 2,01 · 2010 0,90 · 2011 0,97 · 2012 1,12 · **2013 0,41 (31 P, -3.827)** · 2014 0,60 · 2015 0,67 · 2016 2,08 · 2017 2,44 · 2018 4,89 · 2019 0,82 · **2020 1,50** · 2021 0,92 · 2022 1,29 · 2023 0,85 · **2024 1,79** · 2025 1,49 · 2026 2,59 (17 P). Etichette di regime della finestra 2020-2026 (`R260c` par. 5): toro 2020, laterale 2021-2022, toro 2023-2026. **Crollo**: 2008 e 2013 sono i due anni peggiori. Indici: ~21 mesi, un regime; **orso/laterale/crollo NON MISURATI** (la prova di regime DAX del 05/10 dichiara `770411` **INAPPLICABILE** sul feed 2010-2018: il box notturno sta fuori dal feed e il filtro S&P richiede SPXUSD, che e' in frigo).
5. **NUMERI PER CELLA**: tabella 1a-1i. In piu': oro due lati OHLC 2020-2026 anno negativo 2021 e 2023, peggior giornata -0,50% @0,5%; a 2,00% DD ~19,6% (moltiplicativo) - 21,3% (lineare) [DERIVATO] contro il muro statico del 10%. Curva DD(taglia) a tick del solo long (R268c, DD equity MISTO tick/generati, non decide): 2,34 / 4,75 / 7,14 / 9,43% a 0,5 / 1,0 / 1,5 / 2,0%. **Costo (frontiera 40x)**: stop mediano 22,9 $ (minimi) - 54,8 $ (massimi) contro 18,0 $ = 40 x 0,45 $: K1 VERDE, quota sotto frontiera [0 ; 38,7]% (R268a); la mediana 32,94 $ misurata sul campo e' su n=2 e non decide.
6. **TIPOLOGIE SUPERATE**: (a) **oro** (sopra 1 a barre su 6,5 e 22 anni, a tick su 2 anni); **indici europei/DAX long: no**; EURUSD NM. (b) regimi: oro positivo nei toro 2020/2023-26 e in 2009, 2012, 2016-18, 2022; **negativo nel crollo 2008, nel 2013, nel laterale 2021**.
7. **FORWARD DEMO (solo demo, campione sottile)**: oro 770402 sul piccolo 50503392: 12 trade 11/08-23/09, PF 1,86 (calcolato in `STATO_MAXMIN`), lotto sempre 0,01 -> **non confrontabile** (R9). 
8. **CLASSE**: oro = SOPRA (1a, 1c formale ~1,10 con 11 anni negativi, 1d; 1b a tick C); DAX long e indici EU = SOTTO; EURUSD/NASUSD = NM.
9. **VERDETTO + CERTIFICATO**: oro: `MERITO SOSPESO` a tick (n 93 < 150), `NO PER RISCHIO` a 2,00% e fuori contratto sui 22 anni (10,30% contro 10,0%). **DAX long**: `NON ANCORA MISURATO` - (1) PF si (0/41), (2) n e DD si, (3) uscita si (R267g2-g4: "il default va bene"; `InpTP2_R` x6 in archivio), (4) **gemelli**: si **solo a filtro spento** (F40EUR 0,9985, E50EUR 0,8398, 100GBP 0,6316: tutti long, tick, griglie del 26/07), **col filtro S&P acceso NO**, (5) TF si (R261b M15..H4: 0,883 / 0,869 / 0,705 / 0,823 / 0,761 / 0,724 / 0,721; R267g1 `InpCorrTF` H8 0,957). **F40EUR/E50EUR/100GBP**: (5) TF **NO** (`InpMgmtTF`=15 su 216/216) -> NON ANCORA MISURATI.
10. **MIGLIORABILE?** Oro: **si** sul rischio, non sul merito (flat 13:00: PF 1,302 contro 1,336, DD 3,91 contro 4,52 = taglia il rischio meno di un quarto; `InpMinBoxPts` 1300-2600: PF 1,67-1,93 su 98-199 D, indizio, merito sospeso; filtro trend oro R260d: PF 1,557 ma DD 3,38% > 2,06% -> rischio violato). DAX long: **non conviene**: 41 celle su 41 sotto 1.
11. **COSA SERVE**: oro - (a) **firma di Claudio** sulla taglia (a 1,0% DD 22 anni ~19,5-20,6%, il contratto e' 10,0% a 0,5%); (b) un preset a due lati con magic nuovo; (c) **storico oro lungo a tick**: non esiste (tick dal 2024.07.10); l'esterno 2006-2020/2021-26 e' "scaricato non importato, non concatenabile" - **costo `[NON MISURATO]`, decisione di Claudio**; (d) le due caselle R193b (curva DD(taglia) sul due lati) non girate: ~8 passate, ~2 min [STIMA da 10,2 s/passata]. DAX long - solo i gemelli col filtro acceso (nessun file prova: da scrivere, ~3-6 min); **non lo proporrei prima del resto**.
12. **COSTO TEMPO** (PC di backtest, mai VPS): R193b ~2 min; gemelli DAX col filtro ~3-6 min; tick oro lungo: n/d.
13. **FONTI**: `STATO_MAXMIN_DAX_LONG_E_ORO_2026-09-26.md`, `REFERTO_R242/R244`, CSV `R242`/`R244`/`ROUND_CORTI_B/C/D`, `LETTURA_ROUND_CORTI_B/C/D`, `R17`, `REGISTRO_TEST.md` r.633+ e r.4219-4635, `REGIME_DAX_SPEC_2026-10-05.md` §2.3.

### 4.2 `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` (770411) - NOTTE - sedia (campo, demo)

1. **MOTORE**: stesso del generico, **solo short**, filtro S&P acceso (`InpUseCorrelation=1`): la correlazione porta il PF da 1,19 a 2,05 e dimezza il DD (registro 26/07).
2. **SIMBOLO/TF**: D30EUR M15 (gestione). **Cella di contratto**: buffer 1000, SL 2,5 x ATR, TP2 3,0, TP1 1R 50%, rischio 1%. Sonde: nessuna dedicata (R246 misura l'orologio).
3. **BACKTEST**: contratto = `..._D30EUR_{IS,OOS}_ptb.csv` [T] 1%, dep 100.000, 2024.09.26-2026.06.30 `@FRAZIONEIS 0.40` (IS ~8,5 mesi, OOS ~12,7); **R81** (18/08, sei uscite, `r81_csv`); **R246** (24/09, orologio d0/-1h, finestre A+B) e **R246m-r** (29/09, inverno: arma alla cash); R244 (cutoff, famiglia `ABTG_MaxMinNotte`); R261d/R246i la riproducono al centesimo. Dato OHLC gemello (`_ohlc`): OOS 2,442 / IS 2,058 [B] -> rapporto OHLC/tick 1,114.
4. **ANNI/REGIMI**: ~21 mesi, 1 regime (toro). Stagioni: d0 estate PF 1,450 (11 P) · d0 inverno 2,558 (16 P) · **d+1 inverno 0,996 (17 P)**. La prova di regime su 2010-2018 e' **INAPPLICABILE** (R: `REGIME_DAX_SPEC`); via lunga = Dukascopy `DEUIDXEUR` dal 2012, **34-133 ore di PC per ~25 posizioni** (non proposta).
5. **NUMERI**: IS PF 1,878 / OOS 2,160 · n **20 D / 21 D = 14 P (OOS)** · DD 3,10 / 1,92% (Equity, 1%; a 2,00% 3,84% [DERIVATO]). Uscite (R81, OOS PF / DD / n D): scala piena 2,160/1,92/21 (la sedia) · tutta spenta 2,202/6,14/14 · **solo BE 2,695/3,73/22** · trail 3,5 ATR 1,785/2,46/21 · trail 1,0 ATR 1,486/3,10/15 · spenta + TP 2R 1,875/4,08/14.
6. **TIPOLOGIE**: indice DAX, lato short, **solo toro**; le due gemelle su F40EUR/E50EUR/100GBP short: max 0,59 (E50EUR) e 0,67 (100GBP).
7. **FORWARD DEMO (sottile)**: piccolo 50503392: 5 P dal 18/08 al 31/08, **+155,78**; 100k 50504263: 4 P in 7 gg. Frequenza di campo 0,50 op/g contro 0,051 promesse (10x, su 10 giorni: non decide). PF/DD forward NON MISURATO.
8. **CLASSE**: contratto = SOPRA, **D**; cella d+1 inverno = SOTTO (~1), D.
9. **VERDETTO**: `MERITO SOSPESO` (14 P). Certificato (non obbligatorio, ha una cella SOPRA): (1)(2) si, (3) **si** (R81 sei varianti), (4) gemelli short misurati (sotto 1), (5) TF **NO**: M15 e' l'unico gestito; `R214g` scritto, **mai girato**. R244: il campione **non si allarga col cutoff** (PF marginale 12->17 = 0,588 su 48 D, indizio WHIPSAW; max ~105 P a C=17).
10. **MIGLIORABILE?** **si, ma per CAMPIONE non per PF**: il PF e' alto, mancano le posizioni. R81c (solo BE) batte la sedia in IS e OOS (+0,54) ma a 14 P e' rumore.
11. **COSA SERVE**: (a) asse `InpPlaceHour` (R244 par. 3g); (b) TF `InpMgmtTF` M15-H4 (R214g); (c) la sonda `ABTG_Notte_Study` (sola lettura) per sapere **quante notti il box esiste** e se una configurazione porta il campione >= 150 senza sfondare 40x; (d) il doppio contratto B8 (1,92% contro 3,1%); (e) **storico**: il broker non ha di piu' (D30EUR M15/M5/tick "COMPLETO" dal 2024.09.26); +14,3% se si arriva a oggi.
12. **COSTO**: R214g-tipo ~10 passate x 0,70 min = **~7 min**; sonda Notte_Study minuti; PC di backtest.
13. **FONTI**: `CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` §4 (solo parti backtest), `REFERTO_R244`, `REFERTO_R246`, `LETTURA_R246_INVERNO_2026-09-29.md`, `REGISTRO_TEST.md` r.3895-3940 (R81), CSV `risultati_prove/ABTG_MaxMinNotte_DAX_Short_Ottimizzato/`.

### 4.3 `ABTG_MaxMinNotte_DAX_Short_Ottimizzato_MFE` - NOTTE - copia di sola misura (R104)

1. MOTORE: copia di 770411 senza effetto sul campo, scrive MFE/MAE. 2. D30EUR M15. 3. R104 (25/08, 42 s): [T] 2024.09.26-2026.08.24, magic 750010. 4. 23 mesi, un regime. 5. **n=29: NON MISURABILE** (una sotto il cancello G1 = 30); conteggi: 16/29 toccano 1R, 5 operazioni restituiscono in media 1,25 R dal picco; sistema vero 12,93 R contro 6,60 R "incassa tutto a 1R". 6-7. nessuna tipologia / nessun forward. 8. **NM** (e' uno strumento di misura, non una strategia). 9. verdetto: "il trailing largo e' NET-POSITIVO forte su questa finestra". 10. no. 11. **nulla**: il suo dato e' gia' assorbito dal 770411. 13. `risultati_archivio/R104_REFERTO.md`.

### 4.4 `ABTG_BreakinBox` - NOTTE - candidato chiuso (31/08)

1. **MOTORE**: falsa rottura del box notturno -> entra in verso opposto (reversal) con conferma differita, flat a due tempi.
2. **SIMBOLI/TF**: D30EUR M15 soltanto.
3. **BACKTEST**: corsa del 31/08 14:43, pin 131b6f5, [T] 2024.09.26-2026.06.30, rischio 1,0%, due gambe x due gemelli identici; `REFERTO_BREAKIN_2026-08-31.md` **[SOLO REFERTO: nessun CSV nel repo]**, file prova `prove/ABTG_BreakinBox.txt`, `..._RRFISSO.txt`. Deposito non dichiarato nel referto.
4. **ANNI/REGIMI**: 21 mesi, un regime; nessun IS/OOS (finestra unica).
5. **NUMERI**: A (TP al lato opposto del box = la tesi) PF **1,007**, n 416 D (193 long / 223 short), DD 24,1%, peggior giornata -2,05; B (RR fisso 2,0) PF **1,106**, n 354 D, DD 19,7%, peggior giornata -2,04. Overnight veri 0/770.
6. **TIPOLOGIE**: indice DAX, entrambi i lati; frequenza ~20 P/mese, due lati vivi.
7. **FORWARD**: nessuno (non e' in campo).
8. **CLASSE**: SOPRA formale (~1), B (s.OOS; n >= 150 P anche col fattore massimo 2,31); la tesi del TP strutturale e' **FALSIFICATA** dal controllo.
9. **VERDETTO**: `NO PER RISCHIO` (DD > 15% a qualunque n). **Certificato**: (1)(2) si · (3) **parziale** (TP lato opposto contro RR 2,0; trailing/BE/parziale mai) · (4) **NO**: solo D30EUR (e il referto nomina la geometria in 4 famiglie bocciate: CRT, Turtle Soup, R95 0/30) · (5) **NO**: solo M15. Quindi **non si puo' scrivere MORTO**: e' "chiuso" per la regola 19/08, ma il certificato e' a 2/5.
10. **MIGLIORABILE?** **no per il motore** (la Regola della Seconda Caccia vieta la caccia all'RR); **si come mattone**: box-engine + conferma differita + flat a due tempi sono autotestati. Il referto stesso dice "se una caccia futura porta una GESTIONE diversa sulla stessa geometria, il banco e' pronto".
11. **COSA SERVE**: (a) un simbolo gemello (DAX e' l'unico; FTSE/CAC/Stoxx per il box notturno hanno gia' PF<1 sul motore MaxMin) - ~2-4 min a simbolo; (b) un TF diverso (M5 escluso per costo sugli indici, resta M30/H1); (c) una **gestione** nuova (non un RR).
12. **COSTO**: 4 passate per cella ~3 min [STIMA da 0,70 min/pass]; PC di backtest.
13. **FONTI**: `REFERTO_BREAKIN_2026-08-31.md`, `CENSIMENTO_SCARTATI_PROSA` A50-A51, `RIESAME_MORTI_NOTTURNI` §0.

### 4.5 `ABTG_Nightly` - NOTTE - candidato (fade notturno, EURUSD "edge EURUSD" mai provato)

1. **MOTORE**: fade a mean-reversion di notte (dal PDF `ABTG-NIGHTLY`, 33 pagine): box da M1, filtro volatilita' QB (`ATR(H1)/PipSize` < 45), rifiuto per nome di JPY/AUD/NZD (`InpBlockNightActive`, r.167).
2. **SIMBOLI/TF**: EURCHF, EURUSD, GBPUSD, USDCHF (campione vero) + AUDUSD, USDJPY, XAUUSD, XAGUSD, D30EUR, U30USD (sbloccati da R259). TF: M5 (round recenti) / M15 (registro): **non e' una manopola** (R6).
3. **BACKTEST FATTI**: weekend 08/08 (EURUSD) e coda fascia B 10-11/08 (GBPUSD, USDCHF): [B] 1%, 10.000, 2024.09.26-2026.06.30, IS 40%; P0 EURCHF 09/09 [T] (`report/P0_NIGHTLY_EURCHF_2026-09-09.md`); **R259** (28/09, [B] Modello 1, 10.000, 1%, forex/metalli `@DAQUANDO 2019.01.01 @FRAZIONEIS 0.50`, indici `2024.09.26 0.40`; `ROUND_CORTI_A_2026-09-28/ROUND_R259_*`); R220a-d (SL pips ad asse su 4 coppie) **scritti, mai girati**; nessun CSV.
4. **ANNI/REGIMI**: forex 21 mesi (4 coppie) e 7,5 anni (R259), non separati per regime; EURCHF ha storico nativo dal 1993/1999 **non usato** (finestra scelta col pavimento degli indici: il difetto D6); XAGUSD IS vuoto.
5. **NUMERI** (PF IS/OOS · n IS/OOS in D · DD IS/OOS): EURCHF [T] 0,891/0,814 · 63/85 · 11,10/15,39 · EURUSD [B] 1,049/0,861 · 106/164 · 10,80/15,49 · GBPUSD [B] 0,586/**1,040** · 96/163 · 22,62/11,28 · USDCHF [B] 0,863/0,970 · 81/131 · 11,42/14,16 · AUDUSD 0,756/0,951 · 477/500 · 62,10/26,59 · USDJPY 0,701/0,675 · 348/480 · 50,65/68,24 · XAUUSD 0,752/0,996 · 98/140 · 14,75/9,46 · **XAGUSD NULLO (0 operazioni IS: storico/motore, i numeri sono diagnosi)** · D30EUR 0,603/0,964 · 79/163 · 17,38/18,56 · U30USD 1,123/0,860 · 76/130 · 7,02/11,86. Frequenza di famiglia **1,937 op/g** (889 P su 4 coppie in 459 feriali): **il motore piu' veloce della flotta notturna**.
6. **TIPOLOGIE**: forex EUR/USD/CHF: sotto 1 in 6 finestre su 8; GBPUSD OOS 1,04 con IS 0,59 (SEGNO INVERTITO); i mercati attivi di notte (AUD, JPY) **peggio** dei dormienti (H_PDF non contraddetta). Costo: D30EUR **ESCLUSO PER COSTO** (18,4-20,9x), U30USD **FRAGILE** (39,0-44,1x).
7. **FORWARD DEMO (sottile)**: EURUSD 2 P 06-10/08, +1,88 (PF 1,03).
8. **CLASSE**: SOTTO (EURCHF, EURUSD, USDCHF, AUDUSD, USDJPY, XAUUSD, D30EUR, U30USD); SOPRA formale (GBPUSD, SEGNO INVERTITO); XAGUSD NM. Affidabilita' C (n 85-164) / B (AUDUSD, USDJPY n 480-500, **ma [B]**).
9. **VERDETTO + CERTIFICATO**: `NO PER RISCHIO` (DD > 10% a 1% su quasi tutte; a 2,00% 21-31%). (1)(2) si · (3) **MAI**: 20 CSV su 20 muovono solo `InpMagic` (R220a-d non girati) · (4) si (10 simboli) · (5) **NON APPLICABILE, cablato** (box M1, ATR H1). Quindi: **`NON ANCORA MISURATO` (casella 3)**; il verdetto "0/8 non si e' guadagnato il posto" riguarda **3 mercati**. **Il difetto D6 e' APERTO**: "giudicato su 21 mesi per errore di copia" (`ABTG_Nightly_EURCHF_00_conta` r.73 `@DAQUANDO 2024.09.26`).
10. **MIGLIORABILE?** **si**, ed e' la voce n.1 della sez. 5: ha la **frequenza** (1,94 op/g) che nessun altro G3 ha; muore su merito e rischio, e di rischio si decide a barre e su finestre lunghe. Attesa onesta scritta prima (`NIGHTLY_SEI_SIMBOLI` §4): puro caso PF fino a ~1,26 a n=300 e ~25% di probabilita' che almeno un simbolo su sei passi per caso.
11. **COSA SERVE**: (a) **finestra giusta**: 4 coppie native (16 celle = 32 passate, **4,8-11,2 min**, proposta #4 di `I_MORTI_E_LO_STORICO`), con verdetto limitato a RISCHIO e FORMA (un DD OHLC contro un DD OHLC), mai al PF; (b) **uscita ad asse**: R220a-d (`InpSLpips` su 4 coppie, 2019.01.01-2026.06.30), file pronti; (c) stadio 2 R259 sui soli simboli che passano S0/S1; (d) spread di EURCHF/USDCHF su BCM (`[NON MISURATO]`, serve il logger sul VPS: fuori perimetro). **Nessuna firma** per (a)-(c) (file prova per il PC di backtest).
12. **COSTO**: (a) ~5-11 min, (b) 4 file ~10-20 min [STIMA], (c) fino a ~29 min [STIMA R259]; **PC di backtest**.
13. **FONTI**: `NIGHTLY_SEI_SIMBOLI_2026-09-26.md`, `RIESAME_MORTI_NOTTURNI_2026-09-22.md`, `LETTURA_ROUND_CORTI_A_2026-09-28.md` (sez. R259), CSV `risultati_prove/ABTG_Nightly/` (20 file), `I_MORTI_E_LO_STORICO_2026-09-23.md` §0.5, `classifica_campo`.

### 4.6 `ABTG_Nightly_Ottimizzato` - NOTTE - copia

EREDITA da `ABTG_Nightly` (439 righe; `diff` = solo default e magic, `NIGHTLY_SEI_SIMBOLI` §2). Nessuna misura propria. Classe **NM (eredita)**; vale la scheda 4.5. Migliorabile / cosa serve: come 4.5.

### 4.7 `ABTG_PTE` - PTE-WOL - sedie 771321 U30USD H1 · 771322/771332 GBPUSD H1 (duello) · 771323 USDJPY (spenta 24/08)

1. **MOTORE**: mean-reversion sugli estremi di un canale (TMA/ATR) con candela doji di rifiuto, EMA200 come trend; stop = ATR + buffer, TP1 parziale (`InpTP1_ATRmult`, 0,5 in campo) + TP2.
2. **SIMBOLI/TF**: H1 su GBPUSD, USDJPY, U30USD, D30EUR, NASUSD, 225JPY; H4 su oro/XAUUSD (FASE 0 0/16); TF H1-H4 per nome (fascia B), H3 = pattern REGIME. Sonde: nessuna.
3. **BACKTEST FATTI**: R23 (tick, 100.000, 1%, GBPUSD/USDJPY IS 2024.07.05-2025.04.21 OOS ->2026.06.30; U30USD da 2024.09.26); R56-R57 (feed `_EXT` 2019-2022, OHLC e tick generati); **R58 e R73 (tick reali, riprodotti al centesimo: +2.091,17 PF 1,378 DD 3,27% n 49)**; R67-R69 (16 anni GBPUSD/USDJPY OHLC IS 2010.07.06-2016.11.26 / OOS ->2026.06.30; U30USD 21 mesi); R72-R74; **R77-R79** (13 anni OHLC IS 2000.01.01-2013.03.31 / OOS 2013.04.01-2026.06.30, due lati); **R80** (4 regimi x 2 giri, 40 CSV); R100 (oro H4 22 anni DD 24,22% "senza metro"); R103 (6,5 anni, GBPUSD PF 0,96 DD 13,1%). CSV in `risultati_prove/ABTG_PTE/` e `csv_R69..R79`.
4. **ANNI/REGIMI** (R56/R80, feed `_EXT`, OHLC, finestre 2019-2022, **MISURATO**): GBPUSD orso 2022 **1,616 (18)**, crollo feb-apr 2020 1,068 (11), toro 2021 **1,447 (37)**, laterale 2019 **1,838 (51)**; USDJPY orso 0,813 (46), crollo 2,084 (7), toro 1,044 (36), laterale **1,900 (40)** (e crollo-anno 0,716 su 52). **Il giro NATIVO diverge in segno 4 volte su 16 celle** (calo sistematico di operazioni 20-55% = M1 locali mancanti): sospeso, non smentito. A tick generati (R57) GBPUSD orso **0,75** (cambia segno).
5. **NUMERI**: tabella 7a-7f. Cella viva `buf 5 / TP 2,0` a 13 anni: GBPUSD **-2.125 PF 0,972 DD 17,68%** (447 D); USDJPY **-5.012 PF 0,935 DD 20,04%** (456 D). Candidata `buf 25 / TP 3,0`: GBPUSD +4.323 PF 1,095 DD 9,87% (477 D); USDJPY -2.317 PF 0,955. Pin `InpTP1_ATRmult` 0 invece di 0,5 **ribalta il segno** della cella viva USDJPY (-837 contro +979, R72/R73).
6. **TIPOLOGIE**: tick 2024-26: GBPUSD, USDJPY, U30USD sopra 1 (D); a 13 anni: **GBPUSD solo la variante buf 25** (sopra); **regimi**: USDJPY **solo il laterale**, GBPUSD candidata nell'orso e viva nel laterale/toro (R80). Dow H1 DD 2,7-3,2% (altopiano BE 0/0,5/1).
7. **FORWARD DEMO (sottile)**: 1 P ciascuno: GBPUSD short +22,16 (14/08) · USDJPY long +9,29 (19/08) · U30USD short +3,78 (03/09) · XAUUSD short -35,60 (06/08, config oro). 771332: **zero operazioni in tutto il file**.
8. **CLASSE**: SOPRA a tick (D) e SOTTO a 13 anni: **SEGNO INVERTITO fra feed/finestre**. USDJPY: SOTTO a 13 anni; oro: SOTTO.
9. **VERDETTO + CERTIFICATO**: `MERITO SOSPESO` (20-27 P) e `NON MORTO`: (1)(2) si · (3) **si** (`InpTP1_ATRmult` 0/0,5/1/1,5, TP2, buffer R67-R69/R72-R74, parziale) · (4) si (9 simboli) · (5) si (H1, H2, H3, H4). **Certificato completo ma su dato [B]**: "morto" non si scrive perche' la sedia a tick e' positiva e il giro nativo e' sospeso.
10. **MIGLIORABILE?** **non so**: il numero decisivo (nativo vs `_EXT`) e' sospeso; "se dopo il download la divergenza restasse, riguarderebbe R50, R56, R59" (R80 par. 2).
11. **COSA SERVE**: (a) **scaricare le M1 2019-2022 con `ABTG_HistoryDownloader` e rifare R80 sul nativo** (chiude la divergenza `_EXT`/nativo); (b) la prova di regime x due lati `LATI_B0/B1/B2_PTE_GBPUSD` scritta il 09/09, **mai lanciata** (6 file); (c) contratto 771322 conteso (2,64% R23 / 13,1% R103 / 17,68% R78): **la scelta e' di FIRMA** (il tick lungo non esiste); (d) 771332 attaccata? (M-C9).
12. **COSTO**: (a) scarico M1 + 40 CSV OHLC `[NON MISURATO]`, ordine di decine di minuti; (b) 6 file ~?; **PC di backtest**.
13. **FONTI**: `REFERTO_ROUND80/78/73/74/57/58/67/68/69`, `CENSIMENTO_CONTRATTI_v2` §4a, `REGISTRO_TEST` r.2577, CSV `ABTG_PTE`, `FLOTTA_ATTIVA`, `CLASSIFICA_CAMPO_50503392`.

### 4.8 `ABTG_PTE_Ottimizzato` - PTE-WOL - variante con buffer in ATR (R74)

1. MOTORE: PTE con `InpSLbufferMode` (buffer in ATR invece che in pip: sul Dow l'asse in pip era morto, 28 celle identiche in R69). 2. H1: GBPUSD, USDJPY, U30USD. 3. **R74** (8 CSV, 14 celle ciascuno, 28 celle identiche a R73 al centesimo come G0): GBPUSD/USDJPY [T] IS 2024.07.05-2025.04.21 OOS ->2026.06.30; U30USD [B] dal 2024.09.26; 1%. 4. 21 mesi, un regime. 5. OOS PF (celle): GBPUSD 1,18-1,98 (14/14), n 47-52 D, DD 2,1-4,3; USDJPY 0,86-1,43 (10/14), DD 3,7-5,1; U30USD [B] 0,77-1,47 (7/14), n 40-42, DD 2,5-3,0; **escursione dell'asse sul Dow: 4.055 EUR contro 39**; IS GBPUSD PF 2,77-37 su 24-26 D (artefatto di campione). 6. GBPUSD tick positivo; Dow dipende dal buffer. 7. forward: nessuno. 8. **SOPRA (GBPUSD) / MISTA, D**; sono celle di griglia, non di contratto. 9. `NON ANCORA MISURATO (campione D; TF H1 soltanto)`: certificato (1)(2)(3 buffer ATR) (4 tre simboli) **(5) NO**. 10. **non so**: l'asse ora morde, ma 47-52 D = ~27 P. 11. **Serve**: n >= 150 (storico che non c'e' a tick) o regime; TF H2-H4; **costo di tempo `[NON MISURATO]`**. 13. `REFERTO_ROUND74_BUFFER_ATR.md`, CSV `csv_R74`.

### 4.9 `ABTG_WOL` - PTE-WOL - osservazione (D1 oro/indici)

1. **MOTORE**: "WOL" sul D1 (candela doji vicino a un canale TMA, Heikin Ashi, conferma di chiusura); in campo previsto oro D1; uscita BE+trailing.
2. **SIMBOLI/TF**: 9 simboli (D30EUR, EURUSD, GBPUSD, NASUSD, SPXUSD, U30USD, USDJPY, XAGUSD, XAUUSD) x **11 TF per nome** (M15, M20, M30, H1, H2, H3, H4, H6, H8, H12, D1); cella di contratto: XAUUSD D1 (osservazione; zero trade nello statement 30/03-21/08).
3. **BACKTEST FATTI**: coda fascia B 10-11/08: `risultati_prove/ABTG_WOL/` **28 CSV** (tick [T] e `_ohlc` [B], IS e OOS, 11 passate = 11 TF), `ABTG_WOL.ini`: 2024.01.01-2026.06.30, Model 4, deposito 10.000, 1%; R100 oro D1 22 anni (DD 1,17%, "finestra accorciata dal 2008").
4. **ANNI/REGIMI**: ~21 mesi un regime (indici dal 2024.09.26; forex tick dal 2024.07.05); oro 22 anni solo DD.
5. **NUMERI (ricalcolati dai CSV primari)**: **D1, la cella di default**: n 0-19 D per finestra (tick: D30EUR 0/3, GBPUSD 4/17, NASUSD 0/1, SPXUSD 4/19, U30USD 1/9; OHLC XAUUSD 3/1, USDJPY 13/11, EURUSD 11/5) con PF 0,00-0,52 (unica eccezione EURUSD IS 31,2 su 11 D). **Sweep TF**: tick, coppie IS/OOS con PF>=1 e n>=10 in entrambe: **3 su 55** (NASUSD H1 IS 5,86 n21 / OOS 1,33 n43; NASUSD H2 2,34 n18 / 4,63 n53; SPXUSD H8 3,63 n15 / 8,28 n59 +189,8); OHLC **7 su 99** (GBPUSD M30 1,31 n85 / **2,82 n99**, U30USD M15 1,88 n41 / 2,01 n84, ...). U30USD tick OOS **6/8 celle >= 1** ma IS **0/4** (SEGNO INVERTITO). Tutti con **profitti +5...+231 su 10.000** e DD 0,1-1,3%.
6. **TIPOLOGIE**: indici USA (U30USD, NASUSD, SPXUSD) e GBPUSD M30 a barre; **oro, EURUSD, USDJPY, argento, DAX: sotto 1**.
7. **FORWARD**: zero trade dichiarati sull'oro (R100).
8. **CLASSE**: SOPRA (3-7 celle coerenti, spiccioli) e SOTTO (maggioranza); D1 = NM. Affidabilita' D.
9. **VERDETTO + CERTIFICATO**: referto 11/08 "profitti da spread, artefatto, nessun candidato". (1)(2) si · **(3) NO** (le 11 passate muovono solo `InpTF`: `InpTP_RR`, BE, trailing mai ad asse) · (4) si (9) · (5) **si, 11 TF per nome**. Quindi **`NON ANCORA MISURATO` (casella 3)**, non morto.
10. **MIGLIORABILE?** **non so**: il motore su D1 non opera (n<20); sulle TF basse opera ma rende spiccioli e il segno IS/OOS si inverte.
11. **COSA SERVE**: uscita ad asse sulle 3-7 celle coerenti (NASUSD H1/H2, SPXUSD H8, GBPUSD M30); un test di **regime** (indici USA: esterno Nasdaq 15,7 anni a barre esiste, usabile solo con firma); misura del costo (spread) sulle celle a n piccolo. **Nessuna firma** per l'uscita.
12. **COSTO**: ~6 celle x 4-6 valori x 2 finestre ~ 10-20 min `[STIMA, nessuna base misurata per WOL]`.
13. **FONTI**: CSV `risultati_prove/ABTG_WOL/` (28), `ini/ABTG_WOL.ini`, `REFERTO_CODA_FASCIA_B.md`, `R100_REFERTO.md`, `CENSIMENTO_SCARTATI_PROSA` A108.

### 4.10 `ABTG_PostNews` - POSTNEWS - sedie 771201 ECB EURJPY · 771202 FOMC EURUSD · 771203 NFP USDJPY (solo demo piccolo)

1. **MOTORE**: due ordini stop (BUY/SELL) sul range post-notizia, OCO opzionale, SL 25 pip, TP 50 pip, trailing a +25 -> SL +15, opera solo con la notizia nel CSV calendario.
2. **SIMBOLI/TF**: M5 su EURJPY (ECB 14:00 server), EURUSD (FOMC 19:40), USDJPY (NFP 13:45); candidati ISM EURUSD 15:15 e blocco 13:45 USDJPY (magic 774701/6, 774801/6). Sonde: nessuna.
3. **BACKTEST FATTI**: (a) 07/08 "nessun edge" = **4 CSV con Trades=0**: **RITIRATO** (causa: calendario 2026-27 + `FileOpen` senza `FILE_COMMON`, filtro spento in silenzio; v1.10 corregge); (b) **05/09 passo 0 + screening Modello 1**: candidato A ISM/PMI/CB 15:15 EURUSD IS 2010-2015 / OOS 2015-2023; candidato B CPI/Retail/PPI 13:45 USDJPY idem, calendari `abtg_news_ism1500_2010_2023_UTC.csv`, `..._usd1330_...`, **[SOLO REGISTRO: CSV primari assenti dal repo]**; (c) **seconda caccia 05/09**: 7 varianti di meccanismo su barre M1 esterne Oanda 2010-01-03->2020-05-14 (EURUSD 3.719.294 barre, oro 3.594.016; 686 giornate-evento), con controllo a ingressi casuali; (d) il 04/09 collaudo NFP e il 10/09 ECB sul campo.
4. **ANNI/REGIMI**: 2010-2023 a barre (candidati) e 2010-2020 (sonde); regimi **non isolati**; "prova dell'epoca": uscita a tempo 30' ISM EURUSD **2010-2011 PF 3,14 (n 73, +7,87 pip)** contro **2012-2020 PF 1,12 (n 298, +0,36 pip)** = 84% del profitto dal 20% del campione.
5. **NUMERI**: A ISM EURUSD IS **0,76** (n 234, -4.651,72, DD 6,92%) / OOS **0,79** (n 312, -5.633,01, DD 6,94%); B 13:45 USDJPY IS **0,66** (n 151, -4.084,87, DD 4,75%) / OOS **0,90** (n 253, -1.979,08, DD 4,56%). Sonde: fade ISM PF 0,85 (t -1,26) EURUSD / 0,73 oro; **doppio riempimento** 24,8% (ISM) e 23,5% (13:30) senza OCO. Sedie reali: **nessun PF, n, DD**.
6. **TIPOLOGIE**: forex (EURUSD, USDJPY, EURJPY) e oro: **nessuna cella sopra 1** nelle letture pulite; "cambiare simbolo non salva la famiglia".
7. **FORWARD DEMO (n=1-2)**: ECB 771201 10/09: **-83,22** (1 P; **lotto 2,3x il contratto**: 1,49% invece di 0,65%; causa: default compilato `InpRiskPercent`=3,0 mentre il pannello F7 mostrava 1,3, come e quando sia tornato a 3,0 `[NON RICOSTRUITO]`; il 02/10 il preset riporta 1,30); NFP 04/09 collaudo **+37,36** (1 P). FOMC: 0. Il calendario e' stato ricostruito il 02/10 (sei eventi: 28/10, 29/10, 06/11, 09/12, 17/12, 04/12): **prima notizia utile il 28/10**.
8. **CLASSE**: candidati SOTTO ([B], B-screening, n >= 150); sedie **NM**.
9. **VERDETTO + CERTIFICATO**: candidati `ESCLUSO PER EDGE/PF` (PF < 1 su entrambe le finestre, campione pieno) ma il motore **non e' morto**: "e' un meccanismo, non un mandato". Sedie `NON ANCORA MISURATO`, **zero punti su cinque**: (1)(2) no · (3) **no** (30 coppie mai mosse; l'uscita a tempo e' misurata come meccanismo, non come EA) · (4) parziale (EURUSD/EURJPY/USDJPY/oro nelle sonde) · (5) M5 soltanto.
10. **MIGLIORABILE?** **non ancora misurabile** sul contratto; **no sul merito** per gli ISM; la seconda caccia lascia **un solo meccanismo vivo**: la **SORPRESA (actual vs forecast), un solo lato**, non misurabile da qui (prezzi esterni finiscono 2020-05, calendario con sorpresa parte 2021-01: zero giorni in comune; 1.667 eventi USA 2021.01.05-2024.10.29). Lascito: se riparte, **finestra viva ~30 minuti, non 70-85**.
11. **COSA SERVE**: (a) **primo PF/DD/n delle tre sedie** con il calendario da 599 eventi 2010-2025 (143 ECB, 84 FOMC, 186 NFP, 186 Unemployment): `POSTNEWS_NFP_00_conta.txt` **esiste ed e' pronto**, gli altri due da pinnare; vale **solo sul RISCHIO** (12-16 eventi/anno: n < 150 per costruzione); (b) decisione di Claudio su `InpUseOCO` della 771203 (1,30%/evento); (c) il rinnovo del calendario entro meta' dicembre; (d) i 1.667 eventi con forecast/actual -> misura della sorpresa **dopo** aver letto il sorgente dell'attrezzo CB 52977.
12. **COSTO**: (a) ~2 min per cella (B7), 3 celle ~6 min [STIMA]; PC di backtest; (d) piu' lungo, `[NON MISURATO]`.
13. **FONTI**: `POSTNEWS_TRE_SEDIE_2026-10-02.md`, `LE_POSTNEWS_NON_TRADERANNO_2026-09-20.md`, `CONTRATTI_DELLE_SEDIE_FTMO` §7 (parti backtest), `POSTNEWS_ECB_ESITO_2026-09-10.md`, `CONTRATTO_POSTNEWS_ECB_771201`, `REGISTRO_TEST` r.164-215 e r.1500-1640, CSV `risultati_prove/ABTG_PostNews/` (4, tutti Trades 0).

### 4.11 `ABTG_Bulge` - BULGE - "Bulge viola" (mean reversion su bande, H1, 22 cross; in campo demo piccolo, versione v5.20)

1. **MOTORE**: mean reversion su Bollinger "Bulge" (larghezza BB >= 1,1x la media a 50), entra in controtendenza dopo l'impulso, SL 3 ATR fisso, **TP = mediana BB dinamica riscritta ad ogni tick** (sempre verso l'ingresso: 6/6 nel campione), kill switch (4 SL / 3 consecutivi / -2%).
2. **SIMBOLI/TF**: H1 **cablato** (r.605-607, 849, 1092-1095); 22 cross (cella di campo: Viola solo, 15 cross). Sonde: nessuna.
3. **BACKTEST FATTI**: R92 (21/08, v5.10 col difetto barra 0, 1 cross per passata, 2022.01.01-2026.06.30 [B]: 106 operazioni su 22 cross, senza senso); **R92b (30/09) MAI girato** (`OnTesterInit works too long`); **R92BAB (01/10)**, v5.20 AMPIA, [B] Modello 1, **10.000, 0,80%**, IS 2026.03.02-04.30 / OOS 2026.05.02-06.29, 6 lavori (`ROUND_R92BAB_20261001_2201`, 12 minuti); **tutto il resto e' del forward** (antenato `BULGE_MULTI_SIGNAL` 01/04-08/06; piccolo xlsx 30/04-30/09). Il solo numero buono (PF 1,599, WR 80,22%, n 268, 2022.01-2026.03, rischio 3%, **tick sul 40% dei dati**, nessun IS/OOS) e' **di Claudio, non nostro** (esclusa dalla classifica).
4. **ANNI/REGIMI**: **4 mesi, un regime**. La misura 2010-2026.06 (IS 2010-2021, OOS 2022-2026) e' **scritta e non girata** (`BULGE_M1_cella_campo_lunga.txt`).
5. **NUMERI (CSV riletti)**: A (22 cross, 153 caratteri) IS PF **0,871** n 410 DD 13,67% / OOS **0,816** n 363 DD 22,78% (-1.149,43); B (solo GBPUSD) IS 0,867 n 40 DD 5,21% / OOS **1,212** n 42 DD 2,60%; C (8 cross) IS 0,742 n 242 DD 13,04% / OOS non girato; D (8 cross, 153 caratteri) OOS **1,096** n 233 DD 10,55%. Payoff OOS A: vincita media 19,03, perdita media 63,64, WR di pareggio 77,0% contro 73,8% osservato. Forward antenato 297 P PF **0,83 (lordo di commissioni e swap 0,92)**; piccolo xlsx 159 P PF 0,86; v5.20 forward 24 P PF 0,27. Costi = 56% della perdita forward dell'antenato. Dispersione per cross = rumore (permutazione p~0,29 backtest, 0,75 forward).
6. **TIPOLOGIE**: forex cross a 4 mesi: **nessuna cella sopra 1 sul cesto intero**; B e D (OOS sopra 1) hanno IS sotto 1 (SEGNO INVERTITO) e sono diagnosi.
7. **FORWARD DEMO**: vedi sopra (n 297 / 159 / 24; **non indipendenti**: stessa tempesta di maggio-giugno del backtest R92BAB).
8. **CLASSE**: SOTTO (cesto AMPIA, forward) e SOPRA formale (B, D); affidabilita' C-D.
9. **VERDETTO + CERTIFICATO**: `NON ANCORA MISURATO`, non morto: (1)(2) si ma solo 2026 · (3) **NO** (BE a 1R, trailing 1,5 R e parziale a 1R sono **inerti per costruzione**: vincite a mediana ~0,3 R) · (4) **NO** per i 7 cross fuori dai 15 · (5) **IMPOSSIBILE** con l'EA com'e' (H1 cablato; M30 **escluso per costo**: NZDCHF budget 0,30 pip contro 0,41 di sola commissione).
10. **MIGLIORABILE?** **si, e il documento del 03/10 lo dice con 9 ipotesi** (H-A..H-G + M1): ma "la forma del motore e' il problema" (payoff 0,30, pareggio al 77% di vincite) e per la regola del 19/08 **niente griglie sull'ingresso**.
11. **COSA SERVE**: (a) **M1**: 4 passate, 15 cross, 2010-2026.06, **15-60 min [DERIVATO]**, nessuna firma, decide il ramo (PF OOS < 1,05 = niente griglie; 1,05-1,30 = si apre l'uscita; >= 1,30 = tick); (b) **telemetria** (open_time, TP/SL d'ingresso, MFE/MAE): copia di banco, `mql5-ea-developer` + cancello, firma per il campo; (c) **spread per cross** `[NON MISURATO]`; (d) TF e uscita = modifica codice (**firma**); (e) calendario news (`data/abtg_news.csv` vuoto).
12. **COSTO**: M1 15-60 min; sonda spread minuti; R92b "3,7 minuti a passata di 16,5 anni su 22 cross"; PC di backtest.
13. **FONTI**: `BULGE_COME_MIGLIORARLO_2026-10-03.md`, `BULGE_PICCOLO_PER_CROSS_2026-10-01.md`, `FIRME_2026-09-29_BULGE_R92B.md`, `R92B_DIAGNOSI_CRITERI.md`, `docs/Analisi_EA_BULGE.md`, CSV `ROUND_R92BAB_20261001_2201/*`, `data/statements/trades_auto.csv`.

### 4.12 `BULGE_MASTER` - BULGE - esterno

1. Consolidamento esterno di 8 versioni "Bulge Multi Signal". 2-7. nessuna misura propria. 8. **NM**. 9. `NON ANCORA MISURATO`: certificato a 0/5; per la classificazione e' "fade Bollinger gia' sepolta (R108/R111)", "nessuno merita spesa" (`CENSIMENTO_SCARTATI` A106). 10-11. **no**: il motore sta in `ABTG_Bulge`. 13. `GIACIMENTO_DI_CASA_2026-09-03.md` §6-7.

### 4.13 `ABTG_LondonFx` - LONDRA - contenitore R116, tre motori (canale / canale+RSI / 5 medie)

1. **MOTORE**: canale SMA5 + RSI nella sessione di Londra (08:00-16:00 server), SL 8 pip / TP 15 pip fissi su entrambe le gambe; 3 motori a interruttore (nudo, +RSI, 5 medie).
2. **SIMBOLI/TF**: EURUSD e GBPUSD, M15 (M5 solo conta-occasioni). Sonda collegata: `ABTG_SondaLondonFx` (passo 0 superato 03/09: 12/12 righe vive su EURUSD M15, 24/24 su GBPUSD).
3. **BACKTEST**: R116 (03/09, `r116_londonfx/CORSA_EURUSD_2026-09-03_1751_BOCCIATA.txt` e `..._GBPUSD_..._BANCO_SPORCO.txt`): [T] modello 4, deposito 100.000, rischio 0,65%, IS 2024.07.05-2025.04.21, OOS 2025.04.22-2026.06.30, M15, ora 8, slippage 0 (fase 2 non dovuta). **Criteri congelati prima**: E OOS >= 0,075 R, PF >= 1,15, DD <= 8%, peggior giornata >= -4%, n >= 150 per gamba.
4. **ANNI/REGIMI**: 23,8 mesi, **un solo regime** (dichiarato).
5. **NUMERI**: EURUSD motore 2: IS PF 0,795 (-36.353,98) / OOS **0,843**, E OOS -0,1078 R, n 1.132, DD **37,14%**; motore 1 OOS 0,898 DD 45,29% (strozzato dal tetto giornaliero: 38%/22% dei giorni oltre soglia); motore 3 OOS 0,923 DD 31,26% (n 1.343); GBPUSD motore 2 IS 0,688 / OOS **0,763** E -0,1726 R DD **55,03%** (motori 1 e 3: 55-61%). Spread misurato: EURUSD mediana 0,200 pip IS / 0,100 OOS.
6. **TIPOLOGIE**: forex majors a M15 in Londra: nessuna cella sopra 1.
7. **FORWARD**: nessuno.
8. **CLASSE**: **SOTTO**, B (n >= 150, un regime).
9. **VERDETTO + CERTIFICATO**: `NO PER RISCHIO` (a qualunque n; previsione "NO probabile" confermata 2 volte; **banco GBPUSD sporco: gemelli del motore 3 divergenti, classe 129**, ma la bocciatura e' per rischio). (1)(2) si · (3) **NO** (SL/TP fissi, mai ad asse; l'ablazione a 3 motori non e' uscita) · (4) si (EURUSD+GBPUSD) · (5) **NO** (M15; la finestra Londra e' ancorata a 08:00). **MORTO non scrivibile** (3/5).
10. **MIGLIORABILE?** **no per il motore**: "il costo e' 1,7-3,3x l'edge richiesto" e la fase 2 non e' dovuta. La seconda caccia (03/09) ha trovato **un meccanismo diverso sulla stessa inefficienza**: la **deriva oraria di Breedon-Ranaldo** (short EURUSD 08:00->16:00 server), "misurata oggi e passata su entrambe le finestre" ([SOLO RIFERIMENTO]: `OROLOGIO_VS_BREEDON_2026-09-03.md`, **non e' un EA nostro**).
11. **COSA SERVE**: nessuna misura sul motore; per la deriva oraria: rileggere `OROLOGIO_VS_BREEDON` e farla diventare file prova (2 celle, ~2-4 min) **se Claudio la vuole**.
12. **COSTO**: ~4 min per la deriva oraria [STIMA]; PC di backtest.
13. **FONTI**: `REGISTRO_TEST` r.1156-1301, `CORSA_*` in `r116_londonfx`, `CENSIMENTO_SCARTATI` A53-A56, `CACCIA_LONDRA_ALTERNATIVA_2026-09-03.md`.

### 4.14 `ABTG_AllineaLondra` - LONDRA - allineamento di 5 medie dentro la finestra di Londra (P2 28/08)

1. **MOTORE**: allineamento di cinque medie mobili nella sessione 03:00-10:29 (finestra), una gamba long e una short, slot e tetto giornaliero uniti per i due lati.
2. **SIMBOLI/TF**: EURUSD M15 soltanto; 4 celle: `00_finestra`, `01_nofinestra`, `02_long`, `03_short`.
3. **BACKTEST**: **PASSO 0** del 03/09 (`allinealondra/REFERTO_PASSO0_2026-09-03_1651.txt`, 5 min): banco S [B] 2022.07.01-2026.06.30 (screening) e banco V [T] 2024.07.05-2026.06.30, split 40/60, 100.000, 0,65%. **E' un conta-operazioni, non un round**: "il PF si legge ma non si giudica".
4. **ANNI/REGIMI**: V 23 mesi un regime (il 2024.07.05 e' il pavimento misurato su GBPUSD, **inferito** per EURUSD); S ~4 anni non separati.
5. **NUMERI** (PF IS/OOS, DD OOS, n IS/OOS D): `00_finestra` V 0,90/0,80, 26,26%, 343/545 · S 0,85/0,87, 35,31% · `01_nofinestra` V 0,60/0,75, 46,62% · S 0,79/0,68, 79,96% · `02_long` V 0,74/0,70, 19,25% · `03_short` V 1,12/0,88, 10,44% (297 D) · S 0,89/**1,01**, 16,31% (+1.352, 562 D). Peggior giornata -1,46% (00_finestra). Esiti A/B/C del conteggio: **MISURATA**.
6. **TIPOLOGIE**: EURUSD: nessuna cella sopra 1 a tick; una cella OHLC ~1,01 (formale).
7. **FORWARD**: nessuno.
8. **CLASSE**: SOTTO (tick, B-C); SOPRA formale ~1 su una cella OHLC.
9. **VERDETTO + CERTIFICATO**: `NON ANCORA MISURATO` come merito; il rischio si legge a qualunque n: DD OOS 10,4-80,0% (banco V 10,4-46,6%): sopra il tetto 8% in 8 celle su 8; profitto negativo in 7 su 8 -> `NO PER RISCHIO`. (1)(2) si · (3) NO · (4) **NO** (solo EURUSD) · (5) **NO** (M15). **Contenuta in `LondonFx`** ("contiene #19" nel `CENSIMENTO_CASELLE_VUOTE`): vale il verdetto 4.13.
10. **MIGLIORABILE?** **no**: stessa sessione, stesso simbolo, stessa famiglia bocciata.
11. **COSA SERVE**: niente, salvo che Claudio voglia un round vero (con criteri firmati prima). 12. ~12 passate ~5 min [STIMA, referto 5 min]. 13. `REFERTO_PASSO0_2026-09-03_1651.txt`, `CENSIMENTO_SCARTATI` A65.

### 4.15 (confine G2) `ABTG_Londra_ORB` - ORB/LONDRA - scheda di confine per D6

1. MOTORE: ORB della sessione di Londra (canale 60' + stop +3, SL al centro), straddle. 2. GBPUSD/EURUSD M5. 3. **R258** (28/09, `ROUND_CORTI_A_2026-09-28`): blocco T [T] 2024.07.05-2026.06.30 `@FRAZIONEIS 0.40`, **all'ora giusta (08:00 server = apertura Londra)** + controlli a 07:00 e 09:00 + blocco L [B] 2008-2026 (screening) + F (frequenza). 36 lavori, 126 min; R258k e R258s hanno perso una gamba per `OnTesterInit works too long` (nulli, rilanciare). 4. 21 mesi un regime; il blocco L ha "ALLARME DI REGIME". 5. **GBPUSD ora 8**: IS 1,054 / OOS 0,975, n 199/296, DD fisso 19,86/38,21%; ora 7: 0,701/0,736; ora 9: 0,796/0,820; **EURUSD ora 8**: 1,175/0,906, n 199/296, DD 15,74/30,02%; ora 7: 0,654/0,865; ora 9: 0,828/0,703. `InpMinRangePips` 20-40 porta n OOS a 7-86 (merito sospeso) e il DD OOS resta 6-19%. 6. nessuna cella sopra 1 con n >= 150 in OOS. 8. **SOTTO**, B. 9. `BOCCIATA PER RISCHIO` + `ESCLUSA PER COSTO` (stop 8-13 pip = 9,5-15,5x contro 13,3x duro; commissione all-in GBPUSD 0,840 pip / EURUSD 0,664 pip). Certificato: (1)(2) si, (3) parziale (`InpMinRangePips`, buffer, `InpRangeStartMin`), (4) 2 coppie, (5) M5 e M30 (T1: il TF e' inerte). 10-11. no. **Il piano (#38) va aggiornato da G2: non e' piu' NON MISURATO.** 13. `LETTURA_ROUND_CORTI_A_2026-09-28.md` sez. R258, `ANALISI_PDF_LONDRA_2026-09-26.md` §7.

---

## 5. COSA MIGLIORARE PER PRIMA (max 5 misure, ordinate per valore / costo, **nessun criterio abbassato**)

Il criterio di ordine e' la bussola del mandato (una sedia schierabile che porti **frequenza**), poi il costo in tempo macchina, poi se serve una firma.

| # | misura | EA | cosa chiude | costo (PC di backtest) | firma? |
|---:|---|---|---|---|---|
| 1 | **Nightly: finestra giusta + uscita ad asse** (4 coppie native 16 celle/32 passate + R220a-d + stadio 2 R259) | `ABTG_Nightly` (+Ott) | D6 (il "morto" su 21 mesi), casella 3 del certificato; **e' l'unico G3 sopra il pavimento di frequenza (1,937 op/g)** | **~5-11 min + ~10-20 min + fino a ~29 min** [STIME]; verdetto solo su RISCHIO/FORMA | no |
| 2 | **PostNews: primo PF/DD/n delle tre sedie** con il calendario 2010-2025 (599 eventi; NFP `POSTNEWS_NFP_00_conta` gia' pronto) | `ABTG_PostNews` | contratto `NON MISURATO` su 3 sedie vive (rischio 1,30%/evento) | ~2 min per cella, ~6 min [STIMA]; vale solo sul rischio | no (file prova) |
| 3 | **Bulge: M1 sulla cella di campo a 16,5 anni** (4 passate, IS 2010-2021 / OOS 2022-2026.06) | `ABTG_Bulge` | decide il ramo (niente griglie / apri l'uscita / tick); chiude "nessuna misura copre la cella in campo" | **15-60 min** [DERIVATO] | no |
| 4 | **MaxMin DAX short: campione e TF** (sonda `ABTG_Notte_Study` + `InpPlaceHour` + `InpMgmtTF` M15-H4, `R214g`) | `770411` | se esiste una configurazione >= 150 P senza sfondare 40x; casella 5 | **~7 min** + sonda minuti | no |
| 5 | **PTE: chiudere la divergenza `_EXT` / nativo** (scarico M1 2019-2022 + rifare R80) | `ABTG_PTE` (+Ott) | decide se R50/R56/R59/R80 reggono; sblocca il duello GBPUSD | scarico + 40 CSV, decine di minuti `[NON MISURATO]` | da confermare |

**Fuori classifica (e perche')**: oro MaxMin non ha misure da fare ma **decisioni**: taglia (DD 22 anni 10,30% a 0,5% contro il contratto 10,0%), preset a due lati con magic nuovo, e se allungare lo storico a tick (non esiste) - **firme di Claudio**. Londra (3 EA) e BreakinBox: **no** (capitoli chiusi con numero; la Regola del 19/08 vieta le griglie sul motore morto).

---

## 6. PUNTI DUBBI NUOVI (aggiungono D14.. a quelli del piano sez. 8)

| id | punto | perche' conta | chi lo chiude |
|---|---|---|---|
| D14 | `Londra_ORB` (piano #38, G2) e' **misurato** da R258 (28/09), il piano lo dava NM; e il "R45 0/48" era di `ABTG_ORB_Ottimizzato` | la riga del piano e' obsoleta | G2 / aggregatore |
| D15 | PostNews candidati ISM/13:30: nel piano `[T]`, nel registro **[B]**; CSV primari **assenti dal repo** | tipo di dato e verificabilita' | aggregatore (declassare a [B] `[SOLO REGISTRO]`) |
| D16 | PTE 771321 DD 2,18% (contratti v2) vs 3,22% (CSV R23a) | quale e' il contratto | chi ha scritto il censimento |
| D17 | Nightly TF M5 vs M15 nelle fonti | etichetta; TF inerte | chi aggiorna il registro |
| D18 | Il `CENSIMENTO_PF` ha colonne WOL incoerenti (`oos_trades_max` < mediana): **non va usato per WOL** | rischio di classi sbagliate | aggregatore |
| D19 | Doppio contratto `770411` (1,92% contro 3,1%): **decisione**, non misura | corsia RISCHIO ambigua | Claudio |
| D20 | `Nightly` GBPUSD OOS 1,04 (IS 0,586), Bulge B/D, WOL U30USD: la regola 5.3 li mette in **SOPRA** con SEGNO INVERTITO; propongo che **SEGNO INVERTITO = "NON CONFRONTABILE / REGIME"**, non SOPRA | 8 EA su 14 finirebbero in SOPRA per celle che non reggono | Claudio (regola) |
| D21 | `REGISTRO_TEST.md` (backtest_pipeline) non ha le righe di R259, R268, R269 (solo le `LETTURA_*`) | classe 576: lo stato si legge dall'archivio | chi tiene il registro |
| D22 | BreakinBox e Londra hanno solo il referto, **nessun CSV in repo** | verificabilita' | archiviare i CSV |
| D23 | WOL: lo sweep ha `InpTF` come unico asse e profitti di spiccioli: se il 11/08 "profitti da spread" fosse **sbagliato** per GBPUSD M30 (PF 2,82 su 99 D a barre) non lo so: **il referto non ha il costo** | possibile cella persa | G3 (se Claudio vuole) |
| D24 | L'unita' **P** per le celle OHLC a 13 anni (PTE) non e' misurata: stimo >= 193 P con il fattore massimo 2,31 | classe di affidabilita' | per-trade da rilanciare |

---

## 7. COSA NON HO FATTO E COME HO VERIFICATO

- **Letti dai CSV primari e ricalcolati da me**: tutte le 28 `ABTG_WOL_*`, i 36 `ABTG_PTE_*` e `csv_R74`, `R242a/b`, `R244b`, `R261a-d`, `R260a-c`, `ABTG_MaxMinNotte_{EURUSD,XAUUSD_r19}`, `ABTG_MaxMinNotte_DAX_Short_Ottimizzato_*` (10 file), `ROUND_R92BAB_*`. **Letti dai referti** (CSV non in repo): BreakinBox, LondonFx, AllineaLondra, PostNews candidati, R17 (cella), forward.
- **Contro-esempio provato**: (i) "il PF 1,45 dell'oro e' del preset a due lati" -> falso, e' il solo long a tick (R1); (ii) "Nightly e' morto" -> il certificato ha la casella 3 vuota; (iii) "WOL e' tutto spiccioli" -> ricontato: 3 celle coerenti a tick e 7 a barre, ma D1 non misura niente.
- **Non toccato**: nessun file diverso da questo; nessun round, nessun preset, nessun conto.
- **Cancello**: strato 2 `controllo-preventivo` **non invocato**; da fare prima di consegnare qualunque numero.

---

## CHANGELOG
| data | cosa | perche' |
|---|---|---|
| 05/10/2026 | creato il file (FASE 2, gruppo G3) | richiesta di Claudio del 05/10/2026 sul resoconto PF sopra/sotto 1 |
