# RESOCONTO EA - GRUPPO G1 (APERTURE DAX / DOW / NASDAQ + LIVE5M + DAX_M3) - SCHEDE (FASE 2) - 05/10/2026

> **DOCUMENTO INTERNO. NON ESCE.** Fase 2 della richiesta di Claudio del 05/10/2026 (*"resoconto di tutti gli EA con PF sopra 1 e
> sotto 1: che backtest, che anni, che tipologie di mercato, se migliorabile e cosa serve"*). Piano e regole: `report/RESOCONTO_EA_PIANO_2026-10-05.md`
> (sez. 5 regola di classificazione, sez. 6 scheda-modello, sez. 7 gruppo G1, sez. 8 punti dubbi).
> **Perimetro**: sola lettura d'archivio. Nessun round lanciato, nessun EA / preset / parametro / taglia / conto toccato, nessun file di altri agenti toccato.
> **Metodo**: ogni numero e' ripreso da una fonte con il suo tipo di dato (`[T]` tick reali BCM, `[B]` barre OHLC, `[E]` esterno, `[G]` generato).
> Cinque gruppi di CSV primari sono stati **riletti qui** (R199B, R262b, r47a, r47c, R270d, `Marco_Emiliano/*`: i numeri tornano al quinto decimale) e i diff dei sorgenti sono stati **eseguiti qui** (sez. 5).
> Dove un numero non c'e' sta scritto `NON MISURATO`. **Nessun verdetto di archiviazione e' scritto qui**: una cella "SOTTO 1" e' "sotto 1, non ancora morta" finche' il certificato a 5 caselle non e' completo.
> **Il forward demo sta in colonna a parte e NON classifica** (solo conto demo piccolo `50503392`; forward FTMO challenge/trial in colonna ancora piu' a parte, per completezza interna).
> **Stato del cancello**: strato 1 (`controlla_riga.py --oggetto md`) da eseguire alla consegna; strato 2 (`controllo-preventivo`) eseguito il 05/10: **FAIL corretto in questo file** (sez. 8bis); **niente di questo file esce verso Claudio senza PASS**.

---

## 0. LEGGENDA E TRE AVVERTENZE CHE VALGONO PER TUTTO IL GRUPPO

- **Classe** (piano sez. 5): SOPRA 1 / SOTTO 1 / NON MISURATO, **per cella** (EA x simbolo x TF x lato x configurazione). **Affidabilita'**: A = n OOS >= 150 pos, OOS vero, >= 2 regimi; B = n OOS >= 150 ma un solo regime; C = n 30-149 (merito sospeso, valvola R59); D = n < 30. `C*` = nessun OOS (massimo assegnabile: C).
- **Un regime solo**: tutti i numeri `[T]` degli indici BCM coprono **2024.09.26 -> 2026.06.30 (~21 mesi)**, rialzo con la discesa feb-apr 2025 dentro la finestra. Orso / laterale / crollo = `NON MISURATO` su ogni cella tick di questo gruppo. Storici esterni: DAX 2010-2018 **scaricato mai importato**; Nasdaq 2010-2026 a barre **usato solo da 770250**; Dow **0 byte** oltre la validazione.
- **TF del grafico = INERTE per sorgente** sui motori d'apertura (range letto su `PERIOD_M1` cablato, `report/MAPPA_COSTO_SIMBOLI_TF_2026-09-24.md` §1; sorgente r.941-954): M5, M15, M30, H1, H4 sono **la stessa cella** a tick. I TF che mordono sono input separati: `InpTrailTF`, `InpOCTimeframe`, `InpLevelTF`, `InpFilterTF`, `InpMgmtTF` (solo 770411), e sul **Nasdaq 770260** il TF del grafico morde perche' il filtro volumi legge la barra del grafico (r.2530).
- **n**: la colonna `Trades` del tester conta **deal di uscita**; con parziale al 50% una posizione fa 1-2 deal (fattore 1,00-2,31). Dove ho il per-trade scrivo **pos**; altrove **deal** e non confronto con 150.
  **(Cancello 05/10)** Di conseguenza la lettera **B** sulle celle con n solo in deal (1g, 1h, **8a**, **8c**, 10c, 14e, 14j, 21, 23) e' **provvisoria (B o C)**: con fattore fino a 2,31 la soglia di 150 pos e' garantita solo da 347 deal in su. Caso limite: **23** (175 deal = 88-175 pos). Le SOPRA in deal (1c, 1e, 1f) sono state messe a C; **8a (SOPRA B, 311 deal) resta B ma provvisoria come le SOTTO** (seconda passata del cancello 05/10: la prima stesura di questa riga la ometteva, come 8c). Stesso conto in basso: la **C** di 14g short (59 deal OOS, parziale 50% in `R107_NAS_01_short`) e' **provvisoria (C o D)**, 26-59 pos.
- **Finestre IS/OOS NON uguali fra le celle**: contratti del 20/09 (DAX, Dow): IS 2024.09.26->2025.06.09, OOS 2025.06.10->2026.06.30; contratto Nasdaq (walkforward_aperture) e candidato Dow R262b: IS ->2025.06.30, OOS 2025.07.01->2026.06.30; R199B: taglio 0,40 (IS ->~2025.06.09). I confronti fra celle vanno fatti sapendolo.
- **Banco**: deposito e rischio% sono dichiarati ovunque (DD a 1% e a 2% non si confrontano). Il DD "@2%" dei contratti e' `[DERIVATO]` lineare (forbice 0,28-6%), mai una misura.

---

## 1. TABELLA RIASSUNTIVA PER CELLA (EA, classe, PF OOS, n, anni, regimi, verdetto, migliorabile)

Sigle: **M** = migliorabile `SI` / `NO` / `NMI` (non ancora misurabile). Anni: finestra `2024.09.26-2026.06.30` salvo scritto. Regimi: "toro*" = un regime (rialzo con discesa feb-apr 2025), resto `NM` = NON MISURATO.

| # | EA / sedia | cella (simbolo, TF, lato, configurazione) | classe + aff. | dato | PF IS / OOS | n IS / OOS | DD IS / OOS (banco) | anni · regimi | verdetto di casa | M |
|---|---|---|---|---|---|---|---|---|---|---|
| 1a | `ABTG_DAX_Apertura_EU` 770101 | D30EUR M5 **long** RETEST, range 35', buf 5,0 idx | **SOPRA B** | T | 1,126 / **1,397** | 132 / 193 pos | 5,44 / 7,23% (100k, 1%) | 21 mesi · toro* | MERITO SOSPESO sull'IS (132<150) · costo FRAGILE (33% giornate sotto 40x) | SI (poco) |
| 1b | idem 770105 | D30EUR M5 **short** RETEST | **CONTESA -> NON MISURATO** (piano 5.2.6; cancello 05/10) | T | R270d: 0,965 / **0,957** · R251b/FASE M (**stessa config**, OOS dal 2025.07.01, 10k): 0,846 / **1,065** | R270d 138 deal / 257 deal (194 pos OOS `[INFERITO]`: il per-trade `786324` e' della passata 2, TrailMode 2, 199 deal / 194 pos; stessi ingressi) · R251b 152 / 243 deal (**181 pos** OOS) | R270d 7,47 / **12,31%** (100k, 1%) · R251b 10,54 / 12,05% (10k, 1%) | 21 mesi · toro*; estate 1,390 (96) / inverno 0,899 (85) **= taglio R251 (PF 1,065 su 181 pos), NON il taglio 0,957** | NO PER RISCHIO (R1: DD>9% a 1%, su **tutti e due** i tagli) · merito **CONTESO** (0,957 su 194 pos contro 1,065 su 181 pos, lati opposti di 1) · **NON ANCORA MORTO** (manca R252 in fase + G0 di riconciliazione a parita' di finestra e banco) | NMI |
| 1c | idem | D30EUR M5 due lati RETEST range 35' (FASE M) | SOPRA(OOS) **SEGNO INVERTITO** C | T | 0,998 / 1,237 | 224 / 316 deal | 8,41 / 10,49% (1%) | 21 mesi (finestra 2024.01 dichiarata, tick dal 26/09) · toro* | `ZONA GRIGIA` (IS<1, "sostituisce, non somma") | NO |
| 1d | idem | D30EUR M5 due lati BREAKOUT (gestione vecchia) | **SOTTO C** | T | 1,271 / **0,966** | 179 / 243 deal | 7,86 / 14,54% | 21 mesi · toro* | NO PER RISCHIO · ribaltamento IS->OOS · **per lato, a gestione di oggi e in fase: NON MISURATO** (PRV_DAXAP_04, scheda 1 §11b) | NMI |
| 1e | idem | D30EUR M5 due lati OPENCONFIRM (+ `InpOCTimeframe` M5/M15 a range 15') | SOPRA(OOS) **SEGNO INVERTITO** C | T | 0,935 / 1,035 | 186 / 250 deal | 10,64 / 13,52% | 21 mesi · toro* | NO PER RISCHIO · bocciato regola "due mercati" (Nasdaq -365) | NMI |
| 1f | idem | D30EUR M5 **long** DELAYED CANDLE | SOPRA(OOS) C | T | 1,499 / 1,100 | 142 / 194 deal | 4,70 / 8,65% | idem | "nessuna cella batte il retest in entrambe le finestre"; **short NM** | NMI |
| 1g | idem | D30EUR M5 RANGE_FADE due lati (24 celle) | **SOTTO B** | T | OOS 0,608-0,928; **0/24 celle PF>=1** | 205 / 302 deal | fino a 33,9% | idem | **ESCLUSO PER COSTO** (stop 1,5xATR M5 = 13,7x) | NO |
| 1h | idem | D30EUR M5 `InpRangeMode` 1 e 2 (livello pre-apertura / candela H1), due lati | **SOTTO B** | T | 1,109 / **0,861** (RM1) · 1,080 / **0,884** (RM2) | 239 / 320 · 238 / 326 deal | 10,86 / 15,57 · 10,00 / 14,94% | idem | segno invertito; serve "tesi nuova" per riaprire | NO |
| 1i | idem | D30EUR M5 GAPFILL | **NON MISURATO** | T | n/d | 7 / 9 deal | n/d | n/d | campione inesistente (il "gap" del CFD e' lo stacco D1) | NO |
| 2 | `ABTG_DAX_Apertura_EU_Ottimizzato` 770111 | D30EUR M5 **solo long** breakout, range 15', buf 600 (A2) | **SOPRA C*** (citazione di registro) | T? | **1,49** (media 1,25) | 314 tr (finestra unica) | 3,8% (finestra unica) | `2024.01.01->2026.06.30` dichiarata, **tick BCM solo dal 2024.09.26** (~29,5% finestra non su tick reali: `[INFERITO]` per analogia) · toro* | **NON ANCORA MISURATO su OOS**; CSV originale NON in repo | NMI |
| 3 | `ABTG_DAX_Apertura_EU_Pin9fca` | copia pin `9fca63d9` (= binario in campo FTMO) | EREDITA 1a/1b | - | - | - | - | - | eredita; diff vs HEAD = **+460 righe, tutte del filtro SPAZIO opt-in OFF** (sez. 5) | - |
| 4 | `ABTG_DAX_Apertura_EU_TrailFix` | pin + guardia trailing (25/09), NON in campo | **NON MISURATO** | - | - | - | - | - | prova di neutralita' mai girata | SI |
| 5 | `trailfix/CLAU12_DAX_Apertura_EU` | idem (versione corretta dal cancello 25/09) | **NON MISURATO** | - | - | - | - | - | idem; soglia **equivalente** a TrailFix, log diverso | SI |
| 6 | `standalone/ABTG_DAX_Apertura_EU` | monolite v1.00 del **26/07**, default ora 9, range 15, trail 410 fissi, rischio 2 | **NON MISURATO** | - | - | - | - | - | **motore diverso**, non eredita (diff 1.944 righe) | NO |
| 7a | `ABTG_Apertura_Marco` | D30EUR M5 solo long, buf 600 (`valid_Marco_DAX_base`) | SOPRA C* | T? | 1,244 | n 309 (finestra unica) | 4,69% (10k) | `2024.01.01->2026.06.30`, deposito 10k · toro* | doppione di 1a; ritirato 06/08 per **rischio doppio**, non per PF | NO |
| 7b | idem | D30EUR M5 due lati (buf 400/600/800) | **SOTTO C*** | T? | 0,789-0,858 | 443-446 | 5,8-11,3% | idem | negativo, finestra unica | NO |
| 7c | idem | NASUSD M5 (22 celle, base + "emiliano") | **SOTTO C*** | T? | 0,502-0,842 (22/22 < 1) | 122-454 | 5,0-15,0% | idem | 22/22 negative | NO |
| 8a | `ABTG_Apertura_3Ingressi` (R83) | D30EUR M15, RETEST a limite (`r83d1`) | **SOPRA B** | T | 1,078 / **1,188** | 197 / 311 deal | 7,03 / 10,60% (1%) | 21 mesi · toro* | laboratorio; "il retest vince sul DAX" (altro setup della sedia: RangeMode 2, 15', TP1 1R) | NMI |
| 8b | idem | D30EUR M15 stop oltre (`r83d0`) / market chiusura (`r83d2`) | SOPRA(OOS) 1,041 / **SOTTO** 0,984 | T | 1,047/1,041 · 0,804/0,984 | 220/325 · 212/322 | 7,93/13,26 · 8,97/8,69% | idem | - | NO |
| 8c | idem | NASUSD M15 stop / retest / market (`r83n0/n1/n2`) | **SOTTO B** (3/3) | T | 1,254/0,873 · 0,947/**0,624** · 0,705/0,978 | 156/291 · 187/303 · 198/313 | 6,14/17,07 · 9,71/**29,14** · 9,48/6,18% | idem | R84: **9/9 celle OOS negative** (ablazione criteri) | NO |
| 9 | `DAX_MASTER_PROP` | DE40 M15 (Tickmill demo), consolidato v2.0 + 5 protezioni | **NON MISURATO** | E,G | (1,51 dichiarato, esterno) | 69 tr in 2 anni | 5,45% (10k) | **2023-2024, 0% tick reali, solo IS** · rialzo | screening esterno modellato, senza OOS: non classifica | NMI |
| 10a | `ABTG_Dow_Apertura_US` 770202 | U30USD M5 **long** RETEST, range 35', buf 10 idx, filtro EMA H4 1/50 | **SOPRA C** | T | 1,222 / **1,270** | 56 / 96 pos | 5,67 / 4,39% (100k, 1%) | 21 mesi · toro*; estate 0,886 (84) / inverno 1,493 (68) | MERITO SOSPESO (96) · **orologio G1 aperto** (in fase estate 0,886, d+1 inverno 0,916/40) | NMI |
| 10b | idem | U30USD M5 **short** RETEST (R54a) | **SOTTO C** **SEGNO INVERTITO** | T | 1,511 / **0,840** | 73 / 73 | 2,68 / 8,62% | 21 mesi · toro* | in fase PF 0,775/46 pos (R255): BOCCIATA PER RISCHIO; Supertrend H8/H12 n 39-46 = indizio isolato | NMI |
| 10c | idem | U30USD M5 breakout nudo / FADE / DELAYED | **SOTTO B** | T | breakout max 0,997 (96 celle) / 1,106-1,214 (143) · FADE 0,806 · DELAYED max 0,978 | FADE 324 | DD fino a 24,3% | 21 mesi | - | NO |
| 11 | `ABTG_Dow_Apertura_US_Pin9fca` | copia pin | EREDITA 10a | - | - | - | - | - | **identico** a HEAD e al pin (diff 0 righe) | - |
| 12 | `ABTG_Dow_Apertura_US_TrailFix` | guardia trailing, NON in campo | **NON MISURATO** | - | - | - | - | - | neutralita' mai girata | SI |
| 13 | `trailfix/CLAU12_Dow_Apertura_US` | idem | **NON MISURATO** | - | - | - | - | - | idem | SI |
| 14a | `ABTG_Nasdaq_Apertura_US` 770260 | NASUSD M5 **due lati** RETEST range 35', buf 200, vol ON, TP1 0,5R + parziale 50% (**cella in campo dal 21/09**) | **SOPRA C** | T | 1,221 / **1,215** | 82 / 102 pos (135 / 172 uscite) | 7,31 / 7,86% (**80k, 2,00%**) | 21 mesi · toro*; stagione NON divisa (per-trade assente) | MERITO SOSPESO (102) | SI |
| 14b | idem (**contratto 20/09**, ClosePct 0) | NASUSD M5 due lati RETEST, stessa cella a parziale spenta | **SOPRA C** | T | 1,145 / 1,109 (altra finestra) | 91 / 94 pos | 5,95 / 3,68% (**10k, 1%**) | IS ->2025.06.30, OOS 2025.07.01-> | cella **diversa** da 14a (sez. 4.1): non e' una contraddizione | - |
| 14c | idem | NASUSD M5 **long solo** / **short solo** sulla cella viva | **NON MISURATO** | - | - | - | - | - | R231a scritto, mai girato | SI |
| 14d | idem (770250) | NASUSD **M15** breakdown **short gated** (EMA 50x200 H4), 0,65% | **SOPRA C** (PF ~1) | T | - / **1,097** | OOS 104 | OOS 4,54% | tick 21 mesi toro*; OHLC `NASUSD_EXT` 2020-2024 (crollo + orso 2022): **1,84 su 93** (screening, mai tick) | `ZONA GRIGIA` (1,097 su 104: indistinguibile da 1); ferma dal 25/09 | SI |
| 14e | idem (770201, SPENTA 18/08) | NASUSD M5 breakout due lati (RangeMode 2, 15', buf 200) | **SOTTO B** **SEGNO INVERTITO** | T | 1,241 / **0,859** | 165 / 316 | 6,30 / 16,21% (1%) | 21 mesi | NO PER RISCHIO; WF 19/20 celle OOS negative | NO |
| 14f | idem | NASUSD M5 breakout con vol ON | **SOPRA C** | T | 1,071 / 1,063 | 114 / 108 | 5,85 / 4,13% (1%) | 21 mesi | mai provato con la gestione d'uscita viva (R275) | SI |
| 14g | idem | NASUSD M5 RETEST "geometria Dow" short / long (R107) | **SOTTO C** short **SEGNO INVERTITO** (n 58/59 in **deal**: C provvisoria, C o D, 26-59 pos) · **SOPRA C** long (1,110 su 113) | T | short 3,220 / **0,460** · long 1,080 / 1,110 | 58 / 59 · 85 / 113 | - / 11,34 · - / 5,62% | 21 mesi | "la geometria del Dow non si trasporta" | NO |
| 14h | idem | NASUSD M5 GAPFILL | **SOPRA D** | T | 2,083 / 1,937 | 23 / 19 | 4,64 / 3,28% | 21 mesi | bloccato da regola FTMO (gap trading) | NMI |
| 14i | idem | NASUSD M5 OPENCONFIRM / DELAYED (vol ON) | **SOTTO C** | T | 1,816 / **0,956** · 1,710 / **0,696** | 108/104 · 56/51 | 3,75/6,72 · 3,72/4,61% | 21 mesi | IS che brilla, OOS no (sovra-filtro) | NO |
| 14j | idem | NASUSD M5 `InpRangeMode` 1 / 2 due lati | **SOTTO B** | T | OOS 0,798 / 0,665 | 321-329 | 17,35 / 26,29% | 21 mesi | RM0 (35') e' la migliore | NO |
| **14k** | idem **su U30USD** (candidato #1 Dow) | **U30USD M5 due lati breakout**, range 15', buf 200, filtro EMA H4 1/220, TP1 0,5R, ClosePct 0 | **SOPRA B** | T | 1,259 / **1,481** | **157 / 199 pos** | 7,17 / 6,62% (10k, 1%) | IS ->2025.06.30, OOS 2025.07.01->2026.06.30 · toro*; **in fase PF 0,964 (132)**; vergine 01/07-18/09/2026: **0,514 su 39, DD 8,38%** (**in fase e vergine misurati sulla cella vicina `InpEmaSlow=200`**, centro R245 - `R250a`/`R248a` -, **non sulla 220**: scarto 200/220 in R262 A9 +0,0023, MW §0, cancello 03/10) | NON ANCORA MISURATO come sedia: costo FRAGILE (41,3x, 47,5% giornate sotto 40x), **0/48 celle sotto il muro 10% a 2%** | SI |
| 15 | `ABTG_Nasdaq_Apertura_US_Ottimizzato` 770211 (spenta 18/08) | NASUSD M5 RangeMode 2 (H1), range 25', buf 100, trail fisso 500 | **SOPRA C*** (senza OOS, rischio rosso) | T? | 1,34 (finestra piena) | 340 tr | **11,6%** | 25/07/2026, finestra piena, 34% combo positive · toro* | NO PER RISCHIO (DD>10%); **geometria gemella 770201 fa 0,859 in OOS** | NO |
| 16 | `ABTG_Nasdaq_Apertura_US_Pin9fca` | copia pin | EREDITA 14 | - | - | - | - | - | diff vs HEAD = 22 righe (commenti) | - |
| 17 | `ABTG_Nasdaq_Apertura_US_TrailFix` | guardia trailing, NON in campo | **NON MISURATO** | - | - | - | - | - | - | SI |
| 18 | `trailfix/CLAU12_Nasdaq_Apertura_US` | idem | **NON MISURATO** | - | - | - | - | - | - | SI |
| 19 | `esterni/Nasdaq_PreOpen_Breakout_EA` (+ `.ex5` orfano) | NASUSD M5 candela 14:25-14:30 | **NON MISURATO** | - | - | - | - | - | **ESCLUSO PER COSTO** (13,33x al pavimento duro) + fuso cablato; `.ex5` senza sorgente: non misurabile | NO |
| 20 | `standalone/ABTG_Nasdaq_Apertura_US` | monolite del 26/07 (ora 15, magic 770201) | **NON MISURATO** | - | - | - | - | - | motore diverso (diff 1.702 righe) | NO |
| 21 | `ABTG_DAX_Live5m` | D30EUR M5 candela pre-apertura 5', due lati, cancello d'ampiezza spento | **SOTTO B** | T | 0,935 / **0,857** | 225 / 342 deal | 26,07 / **39,74%** (@2%) | `2024.01.01->2026.06.30` (parte su tick non reali) · toro* | NO PER RISCHIO; costo sotto il duro; **NON ANCORA MORTO** (2/5 caselle piene + (5) parziale) | NMI |
| 22 | `ABTG_DAX_Live5m_v2` | D30EUR M5 long-only, cancello 1500/4000 | **SOTTO C** | T | 1,006 / **0,925** | 80 / 202 | 4,70 / 14,16% (1%) | idem | **ESCLUSO PER COSTO** M5 (11,5-13,1x < 13,3x) | NMI |
| 23 | `ABTG_Nasdaq_Live5m` 770203 | NASUSD M5 candela 5' pre-apertura, due lati | **SOTTO B** | T | 1,015 / **0,956** | 116 / 175 deal | 12,3 / 22,5% (2%) | idem | NO PER RISCHIO; ESCLUSO PER COSTO (13,33x); **NON ANCORA MORTO** | NMI |
| 24 | `ABTG_DAX_M3` | D30EUR **M3** Supertrend H4 bias + EMA200 + ADX | **NON MISURATO** (zero CSV) | - | n/d | n/d | n/d | `.ini` 2024.01.01->2026.06.30, `Model=1` (OHLC), **mai girato con risultato in repo** | il "33% positive" del piano **non e' verificabile**; ZERO PUNTI SU CINQUE | SI |
| 25 | `DAX_M3_Supertrend` | riscrittura v2 (esterna) | **NON MISURATO** | - | n/d | n/d | n/d | - | nessun CSV, nessun referto | SI |
| 26 | `standalone/ABTG_DAX_M3, _DAX_Live5m, _Nasdaq_Live5m` | copie del 26/07 | **NON MISURATO** | - | - | - | - | - | diversi dalla root (131 / 212 / 212 righe di diff), non diffati nel merito | NO |

**Conteggi di questo gruppo** (26 righe del piano, un file o un gruppo di file per riga): sez. 8.

---

## 2. SCHEDE (una per EA; per i file con piu' celle il dettaglio sta nelle tabelle delle schede)

### Fonti comuni lette per tutte le schede
`report/APERTURE_DAX_MAPPA_2026-10-03.md` (**MD**) · `report/APERTURE_DOW_MAPPA_2026-10-03.md` (**MW**) · `report/APERTURE_NASDAQ_MAPPA_2026-10-03.md` (**MN**) ·
`report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` (**CT**) · `backtest_pipeline/REGISTRO_TEST.md` (**RB**; r.84-135 aperture/Live5m, r.3616-3825 R83/R84/R180/R183, r.4560-4640 CORTI B) · `REGISTRO_TEST.md` root (**RR**, round 21-28/09) ·
`backtest_pipeline/risultati_archivio/CENSIMENTO_PF_TUTTI_2026-09-09.csv` (**CSV9**) · `report/RIESAME_MORTI_APERTURE_2026-09-22.md` (**RM**) · `report/PICCOLO_PF_PER_EA_2026-10-01.md` (**PICC**, forward demo) ·
`report/ORB_NASDAQ_PERCHE_E_SPENTO_2026-09-23.md` (**ON**) · `report/IL_RETEST_SUL_NASDAQ_LA_RICONCILIAZIONE_2026-09-18.md` (**RN**) · `backtest_pipeline/RISULTATI_OTTIMIZZAZIONE.md` (**RO**).

---

### SCHEDA 1 - `ABTG_DAX_Apertura_EU` (famiglia AP-DAX, G1) - sedie 770101 (long) e 770105 (short)

1. **MOTORE**: dopo l'apertura cash del DAX misura il range dei primi 35' (letto su M1), attende la rottura e il ritorno sul livello (RETEST con ordine limite), 1 operazione/giorno, parziale 50% + BE + trailing sulla candela precedente (M5).
2. **SIMBOLI/TF**: D30EUR M5 (cella di contratto); gemelli del meccanismo: F40EUR (r138a), 100GBP (negativo), E35EUR/E50EUR (esclusi per costo), Dow e Nasdaq con gli EA fratelli. Strumenti collegati: `ABTG_Apertura_Study_EA` (studio apertura, un passaggio), `ABTG_SondaOrologio` (ramo DAX: LONG = -SHORT esatto), `ABTG_SpreadLogger`.
3. **BACKTEST FATTI** (tick `[T]`, D30EUR M5, banco 100k, rischio 1%, `@DAQUANDO 2024.09.26`, IS ->2025.06.09, OOS 2025.06.10->2026.06.30): R47a (long, **193 pos OOS**, `risultati_prove/aperture_r47/*_r47a.csv` riletto: IS 1,12634 / 175 deal / DD 5,4362; OOS 1,39709 / 270 deal / DD 7,2328) · R270b/c/d/e (uscita; short R270d riletto: IS 0,96513 / 138 deal / 7,4732; OOS 0,95734 / 257 deal / 12,3052) · R246 (orologio, tre orologi per stagione di chiusura) · R251 (short, per-trade 792520) · R273 (`InpTrailTF` M5..M30) · PRV_DAXAP_02 (`InpCloseHour`) · ptd (griglia range x buffer: 180 celle) · r35 (durata range 15-60') · r26/r27 (volumi, DELAYED) · r42/r43 (FADE) · r137a-c, r138a (F40EUR), q770be (ClosePct 0 + BE) · FASE A-M del 05-08/08 (`Walkforward_Aperture/DAX_*`, 2024.01->2026.06) · `Openconfirm/` (05/08, finestra intera senza split).
4. **ANNI e REGIMI**: 2024.09.26 -> 2026.06.30 (IS ~8,5 mesi, OOS ~12,7). **Toro con discesa feb-apr 2025: MISURATO come un'unica finestra**; orso, laterale, crollo: **NON MISURATO** (HistData DAX 2010-2018 scaricato, 1,72 M barre M1, **mai importato**; spec di regime del 05/10 pronta, non girata). Per stagione (R246, stagione = data di chiusura, orologio BCM UTC+1 fisso): d0 estate (cash) PF 1,108 su 157 pos · d0 inverno (arma 1h **prima** della cash) 1,389 su 168 · d+1 inverno (alla cash) 1,184 su 138 (0,627 pos/g); serie "come FTMO" **1,143 su 295 pos, DD saldo 9,50% a rischio 1**. Short in stagione (R251, solo OOS): estate **1,390 su 96**, inverno ora 8 **0,899 su 85**: tutto il DD OOS cade nell'inverno sfasato. **Attenzione (cancello 05/10, ricalcolato dal per-trade `R251/PERTRADE/..._792520.csv`: 243 deal, 181 pos, 96 + 85)**: questi due numeri sono del taglio R251 (OOS 2025.07.01->, banco 10k), il cui PF OOS complessivo e' **1,065 su 181 pos** (DD 12,05%), **non** del taglio R270d (0,957 su 194 pos). Stessa configurazione (confronto colonna per colonna dei CSV: differiscono solo `InpMagic` e `InpUsaGuardian`).
5. **NUMERI per cella**: vedi tabella 1a-1i. Long: PF 1,126 / 1,397, 132 / 193 pos, DD 5,44 / 7,23%. Short: 0,965 / 0,957, DD 7,47 / 12,31% (R270d) **contro** 0,846 / 1,065, DD 10,54 / 12,05% (R251b, stessa config): **CONTESA**. Griglia long: **20 celle su 180** con IS e OOS >= 1,10; range 35 buffer 100-600 (6 contigue): la sedia sta **dentro l'altopiano**. Manopole di uscita (R270/R273/PRV_DAXAP_02): TrailMode ATR/PREVBAR/FIXED, TP1_R 0,5-2, TrailTF M1-M30, CloseHour 11-17 -> **"il default va bene"** su 4 manopole. ClosePct 0 + BE: OOS 1,491 (+0,094 = dentro il rumore 0,147), firma pendente di Claudio. Peggior giornata: -1,0793% (q770be).
6. **TIPOLOGIE DI MERCATO**: (a) classe di strumento: **indice europeo (DAX)** long SOPRA; F40EUR OOS 0,770 SOTTO (DD 11,82% = FAIL rischio), 100GBP best 0,904 SOTTO. (b) regimi superati: **solo il rialzo 2024-26** (dentro, la discesa del 2025); gli altri `NON MISURATO`.
7. **FORWARD DEMO** (piccolo 50503392, 30/04-30/09/2026, PICC, per etichetta commento; n = posizioni-gamba, parziali separate, **campione sottile, non classifica**): "DAX Apertura EU" n 34, PF 0,24, netto -747,24 EUR; "DAX Apertura EU RETEST" n 16, PF 13,46, +174,97 (n piccolo). Attribuzione al magic NON VERIFICATA. **FTMO (non demo)**: challenge 21-30/09, flotta DAX+Dow 11 pos, netto -4.500,93, PF 0,31 (aggregato, non per sedia); trial 01-02/10: 770105 1 posizione stop pieno -3.110,48 EUR (-1,002 R), 770101 non risulta nel profilo del trial.
8. **CLASSE**: **MISTA** - 770101 long **SOPRA / B** (n OOS 193 >= 150, IS 132 < 150, un regime, `[T]`) ; 770105 short **CONTESA -> NON MISURATO** (piano 5.2.6: stessa cella, due OOS >= 150 pos da parti opposte di 1: R270d 0,957/194 pos a 100k dal 10/06/2025, R251b-FASE M 1,065/181 pos a 10k dal 01/07/2025; correzione del cancello 05/10, prima stesura "SOTTO / B"); il rischio non e' conteso (DD 12,31% e 12,05%, tutti e due > 9% a 1%); i due lati insieme (1c) hanno IS < 1 / OOS > 1.
9. **VERDETTO**: 770101 long = `MERITO SOSPESO` (IS) e merito OOS leggibile positivo; costo `FRAGILE` (stop mediano 86,5 idx = 50,9x lo spread BCM 1,70 `passa`, ma **23-44% delle giornate sotto 40x** a seconda della stima, due stime non riconciliate: 33,4% e 43,7%). Rischio: DD OOS 7,23% a 1% (R1 passa); a 2,00% sarebbe 14,47% `[DERIVATO lineare]` > muro 10%: **la taglia e' decisione di Claudio, non toccata qui**. 770105 short = `NO PER RISCHIO` (12,31% a 1%; 12,05% sul taglio R251) con merito **CONTESO** (0,957 su 194 pos contro 1,065 su 181 pos sulla stessa config: non e' "merito leggibile negativo"). **Certificato 770105**: (1) PF OOS `[T]` 21 mesi: SI ma **conteso** (0,957 / 1,065) · (2) n 194 pos / DD 12,31% (100k, 1%): SI · (3) uscita ad asse: SI (R270: TrailStartR, TrailMode, parziale 0, TP1_R, Supertrend H4..D1; nessuna passa R1 con merito; H12 isolata IS 1,214 / OOS 1,771 su 61/126 deal = "non c'e' una configurazione robusta") · (4) gemelli: **PARZIALE** (short su Nasdaq/Dow misurato negativo; DAX europei esclusi per costo, F40EUR girato solo long) · (5) TF: **NON APPLICABILE** al grafico (range su M1 cablato, `MAPPA_COSTO` §1); `InpTrailTF` M1-M30 provato sul long, non sullo short. -> **`NON ANCORA MISURATO`, manca: R252 (short in fase), `InpTrailTF` sullo short e la riconciliazione 0,957/1,065 (G0 a parita' di finestra e banco: 2 passate, ~1 min `[DERIVATO da R245 0,333 min/passata]`, PC di backtest, nessuna firma).**
10. **MIGLIORABILE?** 770101 long: **si, di poco** (il default e' al centro di 4 manopole; il beneficio atteso sta nel regime e nella frequenza, non nel PF). 770105 short: **non ancora misurabile** (le domande aperte: se il DD 12,31% / 12,05% e' un artefatto dell'orologio, e quale dei due tagli 0,957 / 1,065 descrive la cella).
11. **COSA SERVE** (nessuna e' stata lanciata; costi dalle fonti): (a) **R252** short in fase (24 passate, 5-8 min dichiarati, 7,2-12,6 min con PRV_DAXAP_04): **zip mai tornato**, serve lo zip sul Desktop del PC di backtest `DESKTOP-H4D7CAJ` o via libera a rilanciarlo; **firma/via libera di Claudio**; **lavoro**: il lettore dei round R252/04 non esiste · (b) **PRV_DAXAP_04a-h** (breakout/openconfirm per lato, in fase; file pronti e passati dallo strato 1, strato 2 NON fatto; 32 passate) · (c) **prova di regime DAX 2010-2018**: spec `report/REGIME_DAX_SPEC_2026-10-05.md`, 32 passate 3-11 min (56 con variante B 6-19) + conversione/import 2-4 min; **tre firme richieste D-J/D-K/D-L**; il costo vero e' scrivere il convertitore con DST per giorno e il lettore · (d) **seconda sessione 14:30** (M2, ~8-9 min + una passata di studio per l'ampiezza 14:30): leva di **frequenza**; rischio cluster col Dow/Nasdaq · (e) `InpOCTimeframe` M5..H1 (M3, ~8 min, **condizionata** a PRV_DAXAP_04c/d/g/h >= 1,00 su >= 150 pos) · (f) decisione sull'orologio BCM entro il 25/10 (dal 26/10 le sedie a ora fissa armano 1h prima della cash).
12. **COSTO MACCHINA**: tutto sul **PC di backtest**, mai sul VPS finche' la challenge/trial e' viva (firma 21/09). Totale (a)+(b)+(d)+(e) = ~0,4-0,5 h di tester `[DERIVATO da MD §6]`; (c) 3-11 min + 2-4 min.
13. **FONTI**: MD intero; CT §2; RB r.91 (A2), r.3616-3640 (R83); CSV riletti: `risultati_prove/aperture_r47/*_r47a.csv`, `ROUND_R270_USCITA_DAX_2026-09-28/ROUND_R270d/*.csv`, `R251/ROUND_R251b/*.csv` e `R251/PERTRADE/..._792520.csv` (cancello 05/10). **Conflitto fra fonti**: il piano scrive "short DD 7,5/12,3%, 0,97/0,96": coincide (CSV 0,96513 / 0,95734). **Conflitto sulla cella viva 770105 short**: 0,957 (R270d) contro 1,065 (R251b) sulla stessa config = CONTESA (sez. 4, riga 12); nessun conflitto sul long 770101; due stime di quota-giornate-sotto-40x non riconciliate (dichiarate).

---

### SCHEDA 2 - `ABTG_DAX_Apertura_EU_Ottimizzato` (AP-DAX) - variante storica 770111

1. **MOTORE**: stesso motore della scheda 1 ma con la config "A2" del 26/07: **solo long**, range 15', buffer 600, Supertrend OFF, floor stop 200, slippage 100, rischio 1%, trailing sulla candela precedente (sorgente: `ABTG_DEF_*` del file: buffer 600, risk 1,0, trail mode 1).
2. **SIMBOLI/TF**: D30EUR M5. Gemelli: nessuno per questo file.
3. **BACKTEST**: RB A2 (r.91, 26/07/2026, "real tick"): **PF 1,49 (media 1,25), DD 3,8%, 314 trade, cluster 100% positivo**; **il CSV originale NON e' in repo** (RM §8.1-2): numero **non riverificabile**, citazione di registro. Cella analoga **riverificabile** su altro EA: `Marco_Emiliano/valid_Marco_DAX_base.csv` solo-long buf 600: PF 1,244, n 309, DD 4,69%, deposito 10k (corrisponde alla "media 1,25 / ~314").
4. **ANNI/REGIMI**: finestra dichiarata `2024.01.01 -> 2026.06.30` senza split IS/OOS; il tick BCM D30EUR parte il 2024.09.26: ~29,5% della finestra su tick non reali `[INFERITO per analogia con L1/L2: RB r.124]`. Un solo regime (toro*). Orso/laterale/crollo `NON MISURATO`.
5. **NUMERI**: PF 1,49 / n 314 / DD 3,8% (finestra unica, rischio 1%). PF IS/OOS e n IS/OOS: `NON MISURATO`.
6. **TIPOLOGIE**: indice europeo, solo long; regimi: `NON MISURATO`.
7. **FORWARD DEMO**: non in tabella PICC (commento "DAX Apertura EU OTT" assente: nessuna operazione o n<4). FLOTTA 02/08: "apertura validata (770111) - fix gestione + RETEST pronti".
8. **CLASSE**: **SOPRA C\*** (PF di finestra piena, senza OOS, citazione); contro-indicazione: sullo stesso EA la cella RETEST che e' diventata la sedia (scheda 1) ha **sostituito** questa config. Da D3 del piano: etichetta "(senza OOS)".
9. **VERDETTO**: `NON ANCORA MISURATO` su OOS; "il 1,49 e' il massimo di una griglia (media 1,25)": **non** e' la cella al centro dell'altopiano. Certificato (non e' SOTTO ma e' senza OOS): manca OOS, manca CSV.
10. **MIGLIORABILE?** **non ancora misurabile** (il numero di partenza non e' riverificabile; il motore ha gia' una cella migliore documentata).
11. **COSA SERVE**: riprodurre A2 una volta con split IS/OOS sulla finestra tick vera (2024.09.26->2026.06.30): 2 passate, ~1 min `[DERIVATO da R245 0,333 min/passata]`, PC di backtest; **nessuna firma** per una riproduzione, ma la config e' spenta/storica: ha senso solo se Claudio vuole riesumare il breakout long. Valore: basso (il retest long e' gia' misurato meglio).
12. **COSTO**: ~1 min tester.
13. **FONTI**: RB r.91, r.99; RM §8; `CLASSIFICA_PF.md` #11 (PF 1,49, DD 3,8); CSV `Marco_Emiliano/`. **Conflitto**: RO (25/07) dice che "DAX_Apertura_EU = 3% combo positive, nessun edge" e che l'Ottimizzato (**magic 770102 in RO**, 770111 in sorgente/CLASSIFICA) "NON e' validato": e' la config A1 (due lati + Supertrend), superata dalla A2 del 26/07 (piu' recente). **Punto dubbio nuovo DN1** (magic).

---

### SCHEDA 3 - `ABTG_DAX_Apertura_EU_Pin9fca` (AP-DAX) - copia del binario in campo FTMO (commit `9fca63d9`)

1-13. **EREDITA la scheda 1** (stesso codice del binario compilato sul terminale FTMO il 20/09). **D12 verificato qui**: `git show 9fca63d9:mql5/Experts/ABTG_DAX_Apertura_EU.mq5` contro il file Pin9fca = **0 righe di differenza**. Contro la **root HEAD** (2.885 righe contro 2.425) la differenza e' **+460 righe** (225 non-commento): dalla lettura le righe viste sono tutte del **filtro SPAZIO** (`InpSpaceMode` default OFF, "solo misura" o "attivo", nessuna soglia accesa = non blocca mai) + commenti; **non ho letto le 225 righe una per una** (D12 chiuso con riserva). Quindi i numeri di R47/R270/R246 valgono per il pin **se i round girarono su un binario equivalente**: "G0 al centesimo in 3 round" (MD) e' la prova.
Classe: EREDITA. Migliorabile: come scheda 1. Cosa serve: niente di proprio; per rendere questa riga una misura propria basta un G0 (cella viva) sul pin: 2 passate ~1 min.

---

### SCHEDA 4 - `ABTG_DAX_Apertura_EU_TrailFix` e SCHEDA 5 - `trailfix_9fca63d9/CLAU12_DAX_Apertura_EU.mq5` (AP-DAX)

1. **MOTORE**: pin `9fca63d9` + **una sola modifica**: guardia del lato del prezzo prima della `PositionModify` del trailing (se il nuovo stop e' dal lato sbagliato o dentro `StopsLevel` non parte nessuna richiesta), per evitare la raffica di `[invalid stops]` vista su FTMO il 24/09 (#170199888: 38 rifiuti in 16,9 s) e sui BCM l'11 e il 17/09.
2. **SIMBOLI/TF**: sedie 770101/770105, GER40.cash M5 su FTMO. Mai usate in un tester.
3. **BACKTEST FATTI**: **nessuno**. La prova di neutralita' PRIMA/DOPO (deal identici al centesimo, righe `invalid stops` da N a 0, finestra con 11/09 e 17/09) e' **descritta** in `trailfix_9fca63d9/LEGGIMI.md` e `report/MODIFY_A_RAFFICA_FTMO_2026-09-25.md`, **mai girata**.
4. **ANNI/REGIMI**: n/a.
5. **NUMERI**: PF/n/DD `NON MISURATO`. **Diff eseguiti qui (D12)**: Pin vs `CLAU12` = **53 righe** (51 aggiunte + 2 tolte: coincide col LEGGIMI); Pin vs `TrailFix` = 58 righe; **TrailFix vs CLAU12 = 75 righe** ma la soglia e' **equivalente**: TrailFix `newSL <= bid - sd + 0,5*_Point` con `sd = StopsLevel*_Point` ⇔ CLAU12 `bid - newSL >= (StopsLevel - 0,5)*_Point`; cambiano il nome della funzione di log (`TrailSaltoLog` per candela / `TrailRinvioLog` per ticket per candela) e la testa. Quindi i due file sono **due forchette della stessa guardia**, non due logiche.
6. **TIPOLOGIE**: n/a.
7. **FORWARD**: n/a (non in campo).
8. **CLASSE**: **NON MISURATO** (mai girato).
9. **VERDETTO**: `NON ANCORA MISURATO`. Il certificato non si applica (non e' una strategia: e' una riparazione di esecuzione). **Manca: la prova di neutralita'**.
10. **MIGLIORABILE?** **si** (e' esso stesso il miglioramento: toglie una raffica di richieste respinte).
11. **COSA SERVE**: (a) prova di neutralita' sul PC di backtest, "Ogni tick basato su tick reali", preset FTMO, **tre file** (DAX anche col preset SELL 770105), finestra con 11/09 e 17/09, e nella corsa del pin le righe `invalid stops` devono essere **N > 0** (se 0 la prova non prova niente); `StopsLevel` BCM `NON MISURATO`; (b) **firma di Claudio** per portarla in campo; (c) ricompilazione CLAU12 **solo** sul terminale FTMO `541452707` (`C:\FTMO`), senza posizioni aperte, **mai sui BCM**; (d) scegliere **quale dei due file** e' quello da provare (CLAU12, corretto dal cancello 25/09 notte).
12. **COSTO**: ~3 file x 2 passate `[STIMA]` poche decine di secondi ciascuna a 0,333 min/passata (R245), piu' preparare la riga e il cancello: costo vero = lavoro e firma.
13. **FONTI**: `mql5/Experts/trailfix_9fca63d9/LEGGIMI.md`, diff eseguiti qui. **DN7**: due forchette della stessa guardia coesistono (root `ABTG_*_TrailFix` e `trailfix_9fca63d9/CLAU12_*`).

---

### SCHEDA 6 - `standalone/ABTG_DAX_Apertura_EU.mq5` (AP-DAX)

1-13. **Il piano la dava EREDITA: NON LO E'** (D12 chiuso). Il file e' un **monolite v1.00 del 26/07/2026** (commit `a86089c8`): default **ora 9**, **range 15'**, trailing **410 punti fissi**, **rischio 2%**, magic 770101; diff contro il pin = **1.484 righe**, contro HEAD 1.944. **Non e' il motore della sedia 770101**: nessuna delle misure della scheda 1 vale per lui. Misure proprie: **nessuna**. Classe: **NON MISURATO**. Migliorabile: **no** (e' uno snapshot storico). Cosa serve: niente; se si volesse usarlo bisogna rifare tutte le misure (valore nullo, esiste il file corrente). Fonti: diff eseguiti qui; `git log` del file. (Lo stesso vale per `standalone/ABTG_Nasdaq_Apertura_US` = scheda 20 e per le copie Live5m/M3 = scheda 26.)

---

### SCHEDA 7 - `ABTG_Apertura_Marco` (AP-DAX) - sedia 770301 RITIRATA 06/08

1. **MOTORE**: copia del motore DAX_Apertura_EU (aperture, 1 operazione/giorno); ritirata perche' **doppione esatto**: stesso trade allo stesso secondo, 2%+2% = 4% su un segnale; il 06/08 -205,92 EUR insieme al gemello.
2. **SIMBOLI/TF**: D30EUR M5 e NASUSD M5 (`ini/valid_Marco_*.ini`: `Model=4`, deposito 10k, `FromDate=2024.01.01`, `ToDate=2026.06.30`). **Il piano dava "nessun PF proprio": c'e'** (`risultati_archivio/Marco_Emiliano/`, 4 CSV, riletti qui).
3. **BACKTEST**: ottimizzazione su finestra **unica** (nessun IS/OOS), tick `[T?]`: DAX "base" 6 passate, "emiliano" 16; NASUSD "base" 6, "emiliano" 16. Le config "emiliano" aggiungono filtri (EMA, correlazione, volumi).
4. **ANNI/REGIMI**: `2024.01.01->2026.06.30` dichiarata; ~29,5% su tick non reali `[INFERITO]`; un regime; NM il resto.
5. **NUMERI** (letti dai CSV): DAX solo long: buf 400 PF 1,047 (n 316, DD 5,74) · **buf 600 PF 1,244 (n 309, DD 4,69)** · buf 800 PF 1,135 (n 304, DD 3,64); DAX due lati: 0,789-0,858 (n 443-446, DD 5,8-11,3); DAX "emiliano": best 1,244 / 1,209 (n 264-309); NASUSD: **22/22 celle < 1**, range 0,502-0,842, max 0,842 (n 335, DD 5,96) (base 0,634-0,842; emiliano 0,502-0,760).
6. **TIPOLOGIE**: DAX long-only positivo su finestra unica; Nasdaq negativo.
7. **FORWARD DEMO** (PICC): "Apertura Marco" n 8, PF 0,20, -179,51 EUR (n piccolo; coerente con l'incidente del 06/08).
8. **CLASSE**: **MISTA** - DAX long-only **SOPRA C\*** (senza OOS), DAX due lati e NASUSD **SOTTO C\***.
9. **VERDETTO**: `NON ANCORA MISURATO` per il merito (nessun OOS); il ritiro e' per rischio (doppione) non per PF. Certificato per le celle SOTTO: (1) PF si · (2) n/DD si · (3) uscita: no · (4) gemelli: Nasdaq e DAX si (due simboli) · (5) TF: non applicabile (range su M1, come famiglia). Manca: uscita ad asse, OOS.
10. **MIGLIORABILE?** **no**: il motore e' lo stesso della scheda 1, gia' misurato meglio; questo EA e' un duplicato.
11. **COSA SERVE**: niente (non rimetterlo in campo: due EA identici sullo stesso simbolo sommano il rischio). Eventuale: archiviare la riga con il certificato dopo la riconferma.
12. **COSTO**: 0.
13. **FONTI**: `Marco_Emiliano/valid_Marco_*.csv` (letti), `ini/valid_Marco_*.ini`, `report/PACCHETTO_DEL_MATTINO_2026-09-23.md` §6.1, A95 di `CENSIMENTO_SCARTATI_PROSA`, FLOTTA_ATTIVA riga ~70. **DN2**: il piano dichiarava "nessun PF"; ce n'e' uno (finestra unica).

---

### SCHEDA 8 - `ABTG_Apertura_3Ingressi` (AP-DAX/NAS) - laboratorio R83/R84 (mai in campo)

1. **MOTORE**: stesso scheletro d'apertura con **tre stili d'ingresso a parita' di livello/orario/stop/gestione**: STOP oltre il livello, LIMIT sul retest, MARKET a chiusura oltre. Attenzione: `InpEntryMode=2` = CLOSECONFIRM in questo EA, RETEST nel core (trappola nota).
2. **SIMBOLI/TF**: D30EUR e NASUSD **M15**, RangeMode 2 (candela H1 prec.), 15', TP1 1R. Mai Dow (R180 preparato, non girato).
3. **BACKTEST** (R83, 18-19/08, `risultati_archivio/r83_csv/`, tick `[T]`, `@DAQUANDO 2024.09.26`, canarini di equivalenza 291/291 e 311/311 trade identici): sei celle (tab. 8a-c). **R84** ablazione criteri NASUSD M15: 9 celle, **9/9 OOS negative**. R183 (volume + ingresso a chiusura) PREPARATO, mai girato.
4. **ANNI/REGIMI**: 2024.09.26->2026.06.30, un regime.
5. **NUMERI** (RB r.3632-3639, riletti da CSV9 identici): `r83d1` D30EUR retest **1,0781 / 1,1878** (197 / 311 deal, DD 10,60% OOS, +999,42) · `r83d0` stop 1,047 / 1,041 · `r83d2` market 0,804 / 0,984 · NASUSD `n0` 1,254 / 0,873 (DD 17,07) · `n1` retest 0,947 / **0,624** (DD 29,14, -2.411) · `n2` 0,705 / 0,978. Meccanismo ricontato per posizione: retest Nasdaq 260 pos, 70,4% vinte, |vinc/perd| 0,259; retest DAX 245 pos, 73,9%, 0,420.
6. **TIPOLOGIE**: indice europeo: retest **SOPRA**; indice USA: **SOTTO** in tutti e tre gli stili (regola uscita: "ogni estensione a un altro indice RIFA' il duello").
7. **FORWARD DEMO**: nessuno (mai in campo).
8. **CLASSE**: **MISTA** (D30EUR retest SOPRA B; D30EUR stop/market e NASUSD 3/3 SOTTO B).
9. **VERDETTO**: D30EUR retest `MERITO LEGGIBILE (311 deal)` ma `NO PER RISCHIO` di margine (DD 10,60% > 9%); NASUSD `NO PER RISCHIO` (29,14%). Certificato (celle SOTTO): (1)(2) si · (3) uscita: no (gestione identica per costruzione, mai ad asse) · (4) gemelli: D30EUR/NASUSD si, **Dow no** · (5) TF: M15 solo (R83); **M5 non provato sullo stesso motore**. -> `NON ANCORA MISURATO`.
10. **MIGLIORABILE?** **non ancora misurabile**: e' un laboratorio, non una sedia; il suo contributo e' il duello (il retest vince sul DAX, perde sul Nasdaq).
11. **COSA SERVE**: R180 (duello sul Dow: 7 file x 4 = 28 passate, 2,3-10,5 min `[STIMA]`, **preparato non girato**, il Dow e' l'unico indice mancante); R183 (22 passate, 2-9 min). Nessuna firma richiesta dai file; costo vero: lavoro di lettura.
12. **COSTO**: R180 ~15 min (pianificato), R183 2-9 min, PC di backtest.
13. **FONTI**: RB r.3616-3825; `report/IL_RETEST_SUL_NASDAQ_LA_RICONCILIAZIONE_2026-09-18.md`; CSV9 righe `Apertura_3Ingressi`. Conferma: "6 righe OOS n>=100: 2 sopra / 4 sotto" (1,188 e 1,041 sopra; 0,984 0,978 0,873 0,624 sotto). **Il piano e' confermato**.

---

### SCHEDA 9 - `DAX_MASTER_PROP` (AP-DAX) - esterno

1. **MOTORE**: consolidato prop-firm del `DAXMasterEA v2.0` (catena di 24 EA DAX): ORB mattutino M15 (2 candele), segnale corpo-candela oltre l'ORB + MA200 + buffer, filtri ADX>=24, distanza MA200, bias D1, 4 anti-shock, news; uscita parziale 50% a +45, BE a +20, trailing ATR(D1). Piu' **5 protezioni low-DD** (daily loss su equity, kill-switch DD totale, stop su SL consecutivi, fail-safe filtri, ecc.). Versione 3.10 nei referti CODA.
2. **SIMBOLI/TF**: DE40/D30EUR M15. Nessun gemello.
3. **BACKTEST FATTI**: **uno solo, di terzi**: `docs/Analisi_Backtest_DAX_v1.md` (19/06/2026): DE40 M15, **Tickmill demo**, 2023-2024, deposito 10.000 EUR, **0% tick reali (dati modellati)**, **solo in-sample**.
4. **ANNI/REGIMI**: 2023-2024; regimi `NON MISURATO` (rialzo).
5. **NUMERI**: PF **1,51** (dichiarato), +636 EUR (+6,4%), DD equity 5,45%, win rate 65%, **69 trade in 2 anni**, payoff < 1 (avg win 41,85 < avg loss 51,95), max 5 perdite consecutive; SHORT 35 trade 77,1% vs LONG 34 trade 52,9% (asimmetria da regime, non da forzare). Il documento stesso dice: "**NON costituiscono una validazione**".
6. **TIPOLOGIE**: indice europeo, modellato.
7. **FORWARD DEMO**: nessuno.
8. **CLASSE**: **NON MISURATO** (screening esterno `[E,G]` senza OOS e senza tick: regola 5.3; il PF dichiarato da terzi non entra).
9. **VERDETTO**: `NON ANCORA MISURATO`. Certificato: (1) PF: solo esterno modellato, **no** · (2) n 69, DD 5,45% esterno · (3) uscita: mai · (4) gemelli: mai · (5) TF: M15 solo. Il censimento 22/09 lo giudica "contenitore di protezioni, non un'inefficienza nuova".
10. **MIGLIORABILE?** **non ancora misurabile**.
11. **COSA SERVE**: baseline a tick reali BCM D30EUR M15 (Passo 0 del documento: 21 mesi, **un regime**, 2024.09.26 in poi) + OOS; il piano dell'autore (toggle R-multiplo, BE/trail a R, direzione, leve di frequenza) e' un A/B da fare **un toggle alla volta**. Costo: 1 passata baseline ~0,3-1,5 min `[DERIVATO, M15 non misurato su questo EA]`; i toggle +8-10 passate. **Nessuna firma**; **lavoro**: preparare il file prova e il pin.
12. **COSTO**: ~5-15 min tester per la serie base + 4 test `[STIMA]`, PC di backtest.
13. **FONTI**: `docs/Analisi_Backtest_DAX_v1.md`, `docs/Analisi_EA_DAX.md`, `report/CENSIMENTO_CASELLE_VUOTE_2026-09-22.md` riga 36.

---

### SCHEDA 10 - `ABTG_Dow_Apertura_US` (AP-DOW) - sedia 770202 (long)

1. **MOTORE**: come DAX, sul Dow: range dei primi 35' alle 14:30 BCM, RETEST con ordine limite (buffer 10 idx, offset 4), **filtro EMA H4 1/50**, TP1_R 1,0, parziale 50% + BE, trailing candela precedente M5, 1 operazione/giorno.
2. **SIMBOLI/TF**: U30USD M5. Gemelli provati: il motore e' stato girato su DAX/Nasdaq con EA fratelli; SPXUSD mai (sonda R185 non risposta). **Strumenti collegati**: `ABTG_Apertura_Study_EA` (Dow 1° su 8 indici: +0,074 R/trade cieco, +0,126 col filtro H4, OHLC, non e' verdetto).
3. **BACKTEST FATTI** (tick `[T]`, banco 100k, 1%, IS 2024.09.26->2025.06.09, OOS 2025.06.10->2026.06.30): R47c (contratto, riletto: IS 1,22247 / 74 deal / 5,6692; OOS 1,27013 / 130 deal / 4,3941) · R202A (TP1_R, 80k, 2%) · R197A/B (modo, offset), R172D (BE) · R35 (durata range) · R54a (lati) · R6 · R246 + R246 inverno (orologio) · R248 (finestra vergine 11 pos, PF 0,837, DD 1,45%) · R255 (short in fase, 24 file) · R267c/d (short, uscita a 90', volumi: nessuna cella batte l'ancora) · `DOW_MOTORE` (filtro EMA on/off) · **sospesi/mai girati**: R214a/b (TF grafico M15/M30), R215a (TF filtro, 8 passate), R172a-j (nove assi di gestione, 124 passate), R180 (duello), R211a, R125a-f.
4. **ANNI/REGIMI**: 2024.09.26 -> 2026.06.30 (U30USD M1 650.255 barre, 67,6 M tick): **toro con discesa feb-apr 2025**; per stagione (R246/IL_MERITO): estate **0,886 su 84 pos**, inverno **1,493 su 68 pos** (118% del netto dall'inverno); in fase "come FTMO" **0,836 su 123 pos**; d+1 inverno (alla cash) **0,916 su 40**. Orso/laterale/crollo `NON MISURATO` (Dukascopy `USA30IDXUSD` dal 2012: **0 byte scaricati**; `U30USD_DK` e' la validazione del decoder, 222 giorni, dentro il nativo, in frigo per il cancello 0,0696% contro 0,05%).
5. **NUMERI** (MW §1.1): long IS 1,222 / OOS 1,270 (56 / 96 pos; 74 / 130 deal), DD 5,67 / 4,39%. **Il default va bene** su tutto cio' che e' stato girato: offset 400 = centro altopiano (R197B), TP1_R 1,00 massimo sul bordo dell'asse 0,25-1,00 (0,93 / 1,10 / 1,14 / **1,27**: **il bordo non e' un centro**), BEatR nessuno batte la viva (R172D), range 35' "crinali, non altopiani" (R35: OOS 1,17-1,68, Spearman IS->OOS -0,13). Short R54a: IS 1,511 -> OOS 0,840 (73 / 73, DD 2,68 / 8,62): **SEGNO INVERTITO**; R255 in fase OOS 0,775 su 46 pos.
6. **TIPOLOGIE**: indice USA long SOPRA (un regime); short SOTTO.
7. **FORWARD DEMO**: non in tabella PICC (n<4 o non attaccato sul piccolo). **FTMO**: aggregato challenge DAX+Dow vedi scheda 1; trial: nessun ordine 770202 nel report del 03/10.
8. **CLASSE**: **MISTA** - long **SOPRA C** (96 pos < 150, merito sospeso); short **SOTTO C** con SEGNO INVERTITO.
9. **VERDETTO**: long `MERITO SOSPESO`; rischio DD OOS 4,39% a 1% passa; **orologio: G1 di R246a/c ancora aperto** (un centesimo sul primo deal USD->EUR): il Dow di R246 resta sospeso. Costo: retest stop mediano 188,9 idx `[INFERITO]` = 63,0x a 3,00 (passa), ~30% giornate sotto 40x. **Certificato del short** (SOTTO): (1) PF si · (2) n/DD si · (3) uscita ad asse: **si** (R255: stH6/H8/H12/D1, tp05, parz0, trail0, nudo; R267c/d) · (4) gemelli: **no** (NASUSD/SPXUSD short in fase non misurati) · (5) TF: Supertrend H6-H12-D1 si, TF grafico non applicabile -> `NON ANCORA MISURATO` (mancano gemelli e `InpTrailTF`). Via piu' corta: stH8/stH12 su finestra/simbolo con n >= 150.
10. **MIGLIORABILE?** long: **non ancora misurabile** (merito sospeso, orologio non risolto). Short: **non ancora misurabile**.
11. **COSA SERVE**: (a) **R215a** (filtro TF H1-H4 sulla sedia viva, 8 passate, 2,7 min; fa vedere se la griglia H4 sfasata di FTMO conta) · (b) R214a/b (TF grafico M15/M30, 8 passate 2,7 min; atteso identico alla cifra: chiude la casella 5) · (c) sblocco **G1 di R246a/c** (rifare la misura del primo deal USD->EUR) · (d) **prova di regime Dow**: Dukascopy `USA30IDXUSD` dal 2012 (ore di PC acceso 90-348 `[stima del piano 05/10; la vecchia "3 ore" e' sbagliata]`, tester 30-60 min), **due firme** (riaprire il cancello zero per `U30USD_DK`; estendere D-B al Dow), piano `PIANO_REGIME_DOW_DUKASCOPY_2026-10-05.md` con costo zero download nei primi tre passi (censimento PC, riconversione dell'orologio dalla cache, calibrazione) · (e) rilettura R250 finestra B con eccezione festivi: 0 min, **1 firma**.
12. **COSTO**: (a)+(b) ~5,4 min; (d) 90-348 ore PC acceso + 30-60 min tester; PC di backtest.
13. **FONTI**: MW intero; CT §2; CSV riletto `r47c`; RB r.4143-4153; `report/REFERTO_R246_2026-09-24.md`; `LETTURA_R255_2026-09-28_B_EMENDATA`. Nessun conflitto con la riga del piano.

---

### SCHEDE 11, 12, 13 - `ABTG_Dow_Apertura_US_Pin9fca`, `ABTG_Dow_Apertura_US_TrailFix`, `trailfix/CLAU12_Dow_Apertura_US.mq5` (AP-DOW)

- **Pin9fca**: **identico** al file alla root HEAD e al contenuto di `9fca63d9` (diff = **0 righe**, due volte, eseguito qui): **EREDITA davvero** la scheda 10 (la sedia 770202 gira con questo codice). Classe EREDITA; nessuna misura propria.
- **TrailFix** e **CLAU12**: stessa modifica della scheda 4/5 (guardia trailing; diff pin-CLAU12 = 53 righe, pin-TrailFix = 58 righe; TrailFix-CLAU12 = 75 righe di cui il resto e' nome/log/soglia equivalente). `NON MISURATO`, neutralita' da provare su 11/09 e 17/09 con N>0 righe `invalid stops`. Migliorabile: **si** (toglie la raffica). Cosa serve: come scheda 4 (firma, prova sul PC di backtest, ricompilazione solo `C:\FTMO`). Costo: ~2 passate, pochi minuti.
- Forward: n/a. Fonti: LEGGIMI trailfix, diff eseguiti.

---

### SCHEDA 14 - `ABTG_Nasdaq_Apertura_US` (AP-NAS) - sedie 770260 (RETEST due lati), 770250 (gated short M15), 770201 (breakout, SPENTA 18/08) + la cella su U30USD (candidato #1 Dow)

1. **MOTORE**: apertura Nasdaq (14:30 BCM): **RETEST** del range 35' con filtro volumi (volume della rottura >= 1,5 x media 20 barre); modalita' breakout, delayed, openconfirm, gapfill, fade; **770250** = breakdown solo short gated da EMA 50x200 H4 ribassista, M15, 0,65%->0,35%; **candidato Dow** = breakout a due lati su U30USD, range 15', filtro EMA H4 1/220.
2. **SIMBOLI/TF**: NASUSD M5 (770260, 770201), NASUSD M15 (770250), **U30USD M5 (candidato)**; mai SPXUSD. Gemelli del candidato (NASUSD, D30EUR, SPXUSD): non misurati. Strumenti collegati: `ABTG_SondaGapCash` (gap cash Nasdaq: segno rovesciato sui tick BCM, A69).
3. **BACKTEST FATTI**: 770260: **R199B** (tick `[T]`, banco **80k**, **2,00%**, `@DAQUANDO 2024.09.26`, taglio 0,40, rc driver 0, pin `28c18463`: letto qui) con Pass 0..3 = ClosePct 0/25/50/75; R196A, R198, R199A (verdetto scaduto), R200A/C/E, `NASDAQ_B_motore` (walkforward_aperture, banco 10k, 1%); R214c/d (TF M15/M30, scritti **mai girati**); R231a (lati, **mai girato**); R274a-d (orologio, **scritti non girati**); R209a (BEatR 0-0,5, gatato non girato). 770201: r25 (config viva) + RN. 770250: `REFERTO_SHORTGATE_2026-08-30.md` (tick 21 mesi + OHLC EXT 2020-2024). Candidato Dow: **R245** (6 file 84 passate, 28 min, G0 GIALLO), **R247** (per-trade, G0/G1 verdi), **R248** (finestra vergine), **R250** (orologio, finestra A letta, B NULLA per S1), **R262a-d** (48/48, altopiano 160-280, **centro 220**), **R263** (DD a 2%: 0/48 sotto il muro 10%).
4. **ANNI/REGIMI**: 770260: IS ->2025.06.09 / OOS 2025.06.10->2026.06.30, **toro***; giorni "pre-cash" (14:30 BCM = 8:30 NY d'inverno) = **90 su 183 nell'IS (49,2%) e 90 su 276 nell'OOS (32,6%)**: la cella mescola le due tempistiche; **per stagione NON divisibile** (per-trade assente). 770250: tick 21 mesi **+ OHLC `NASUSD_EXT` 2020-2024 = crollo 2020 + orso 2022: PF 1,84 su 93 (screening, mai tick, per-trade per regime MAI segmentato)**. Candidato: IS 2024.09.26->2025.06.30, OOS 2025.07.01->2026.06.30; in fase PF 0,964/132; vergine estate 0,514/39 (**entrambi della cella vicina `InpEmaSlow=200`**, `R250a`/`R248a`, non della 220). Altri regimi `NON MISURATO` (Nasdaq esterno 15,7 anni a barre, mai usato su 770260; spec di regime 05/10 pronta).
5. **NUMERI per cella**: tab. 14a-14k. Cella viva R199B (CSV riletto): IS 1,22116 / 135 uscite / DD 7,3069; OOS 1,21546 / 172 uscite (=**102 pos**) / DD 7,8576; Pass 0 (ClosePct 0): 1,11621 / 82 pos / DD 12,3568 -> 1,14894 / 102 / 9,1244. ClosePct 25/50/75: **altopiano vero**, il 50 e' il centro. Offset 0 = **bordo** (offset 200/400/600: OOS 0,955/0,838/0,838, IS 1,28-1,30: segno invertito 3 su 3: **picco al bordo, non altopiano**). TrailTF M5 unico positivo con DD OOS<10% (M1/M6 primi in una finestra e ultimi nell'altra). Candidato 14k: grid 40 celle OOS 40/40 PF>=1,10 ma **IS n 138-154: solo 12/40 >= 150**, Spearman IS->OOS -0,357; lati si scambiano fra IS (short 1,58-1,84) e OOS (long 1,46-1,59).
6. **TIPOLOGIE**: (a) indici USA (NASUSD) SOPRA con RETEST+volumi; Dow (U30USD) SOPRA col candidato; **short Nasdaq SOTTO fuori dalla sedia gated**; (b) regimi: toro* misurato; **770250 e' l'unica cella con screening in orso/crollo (OHLC, 1,84)**.
7. **FORWARD DEMO** (PICC): "Nasdaq Apertura US" n 15, PF 29,22, +282,24 (attribuzione al magic NON VERIFICATA: 770260 vs 770201; n piccolo); 770250: 2 operazioni 15-18/09, +7,56 (ON). **FTMO**: la 770260 sulla trial `1514806751` ha **saltato** il 01/10 per volumi insufficienti (NOTTE 02/10): il filtro fa il suo lavoro e la frequenza e' bassa.
8. **CLASSE**: **MISTA** (770260 SOPRA C; 770250 SOPRA C PF~1; 770201 SOTTO B con SEGNO INVERTITO; R107 short SOTTO C con SEGNO INVERTITO e long SOPRA C (1,110 su 113; prima stesura "SOTTO D", corretta dal cancello 05/10); candidato Dow SOPRA B con avvisi di orologio e finestra vergine **misurati sulla cella vicina `InpEmaSlow=200`, non sulla 220**).
9. **VERDETTO**: 770260 `MERITO SOSPESO` (102 < 150); costo 63,9x su stop mediano 115,0 / 46,2x su stima viva 83,2 (**passa**; al P95 spread 2,70 la stima viva dice 30,8x: sotto) ma ~**21% dei giorni sotto 40x** anche sulla viva; spread FTMO `US100.cash` alle 16:30 `NON MISURATO`. Rischio: DD 7,86% a 2,00% su 80k (sotto il muro 10%). 770250: `ZONA GRIGIA` (PF 1,097 su 104). 770201: `NO PER RISCHIO`. **Certificato per 770201/short/breakout**: (1)(2) si · (3) uscita: breakout con vol ON **mai** con la gestione viva; (4) gemelli: parziale (il binario e' solo NASUSD; i gemelli esistono per meccanismo: DAX/Dow) · (5) TF: **PARZIALE** - grafico solo M5 (a filtri spenti inerte), `InpTrailTF` M1..M15, `InpLevelTF` mai mosso, `InpSessionHour` mai ad asse. -> `NON ANCORA MISURATO` per 770250 e per il breakout vol ON; 770201 resta spenta ("12 configurazioni, 12 OOS negative": R83+R84).
10. **MIGLIORABILE?** **si**: 770260 (frequenza e orologio sono le leve, il default e' al centro dove l'altopiano esiste); candidato Dow (regime e orologio); 770250 (regime tick); breakout vol ON (gestione d'uscita mai provata, R275).
11. **COSA SERVE**: (a) **R274a-d**: orologio della cella viva (d0 14:30 / d+1 15:30), 4 file x 2 celle gemelle x 2 finestre = **16 passate, 5-24 min (centro ~13)**; **lo script di lettura (analogo di `r246_giudizio_d1.py`) non esiste: va scritto prima**; strato 2 NON fatto; soglie congelate R1 DD saldo serie >10% e R2 frequenza < 0,25 pos/g -> revisione di Claudio · (b) **R214c/d** (TF M15/M30: l'unica leva di **frequenza** perche' il filtro volumi legge il TF del grafico; 8 passate, 2,7-12 min) · (c) R275 (breakout vol ON + parziale: 4 passate, 1,3-6 min; descritto, non preparato; attenzione alla collisione con 770260 sullo stesso simbolo) · (d) R231a (lati sulla cella viva, 4 passate, scritto, mai girato; "spegnere un lato riduce la frequenza") · (e) **candidato Dow: R280a/e** (filtro su H1, 16 passate = 5,3 min, forbice 1,4-36; `controlla_prova` OK, strato 2 NON fatto) + **rilettura R250 B** (0 min, **1 firma** S1 estesa da R255 a R250) · (f) **prova di regime Nasdaq**: `NASUSD_EXT` 5,23 M barre dal 2010.11.14 (firma "FIRMO FRIGO NASUSD" del 26/08, rapporto 0,199 contro 0,20: bordo sottilissimo), **la gemella SENZA filtro volumi** (il volume EXT e' 0 in 822.911/822.911 righe misurate sull'S&P: la cella con volumi non gira), 34 passate **8-20 min**, orologio EXT "14:30 = cash tutto l'anno" ma SHORTGATE/FASE2/INVES armarono alle 09:30: **da rileggere**; con volumi veri servono **62-244 ore** di PC acceso e firma nuova.
12. **COSTO**: (a) 5-24 min; (b) 2,7-12; (c) 1,3-6; (e) 5,3 min; (f) 8-20 min; tutto sul PC di backtest; **le firme**: R250B (1), regime Nasdaq (una necessaria, tre opzionali), orologio BCM (25/10).
13. **FONTI**: MN intero; MW §1.2; CT §2; RB r.108-109 (A4 riscritto 22-23/09); `risultati_prove/R199B/` (CSV e referto riletti); ROUND_CORTI_B R262b (CSV riletto); RN; ON. **Conflitto D4 (770260: 1,14/1,11 su 91/94 vs 1,22/1,22 su 82/102)**: **RICONCILIATO per cause, non per prova** (sez. 4.1).

---

### SCHEDA 15 - `ABTG_Nasdaq_Apertura_US_Ottimizzato` (AP-NAS) - 770211, SPENTA 18/08

1. **MOTORE**: stesso motore del Nasdaq, config baked a tick il 25/07: **RangeMode 2 (candela H1 precedente), range 25', buffer 100, trailing fisso 500** ("idem, cella ottimizzata" rispetto al breakout 770201).
2. **SIMBOLI/TF**: NASUSD M5. Gemelli: nessuno per questo file.
3. **BACKTEST**: ottimizzazione genetica a **tick reali** del 25/07 (`RISULTATI_OTTIMIZZAZIONE.md`): "% combinazioni positive 34%" per il Nasdaq_Apertura_US; config scelta **stabile, non il picco**: **PF 1,34, Recovery 2,11, DD 11,6%, 340 trade**, finestra piena. **Nessun IS/OOS.** In piu' RB A4 (26/07, griglia long-only del 26/07, floor 0-400, buffer 50-350): "0% combo pos, best PF 0,91" (CSV originale non in repo).
4. **ANNI/REGIMI**: finestra piena **non dichiarata nella fonte** (RO non scrive le date; 2024.01 -> 2026.06 `[INFERITO]` dal pattern delle altre corse del 25-26/07); tick BCM dal 2024.09.26; un regime.
5. **NUMERI**: PF 1,34 / n 340 / DD 11,6% (finestra unica); IS/OOS `NON MISURATO`. Geometria gemella (770201 r25): **IS 1,241 -> OOS 0,859** (165 / 316), DD OOS 16,21%.
6. **TIPOLOGIE**: indice USA; regimi `NON MISURATO`.
7. **FORWARD DEMO**: non in tabella PICC; FLOTTA 02/08: NASUSDM5 "apertura".
8. **CLASSE**: **SOPRA C\*** (senza OOS) **con rischio rosso**; il piano la dava SOTTO (0,91): **riconciliato** perche' lo 0,91 e' il best della griglia **long-only** del 26/07 del motore base, non della cella baked.
9. **VERDETTO**: `NO PER RISCHIO` (DD 11,6% > 10%) e `NON ANCORA MISURATO` su OOS; la geometria gemella dice 0,859 in OOS: **NON CONFRONTABILE** finche' non c'e' un OOS di questa config.
10. **MIGLIORABILE?** **no** (la sedia e' spenta, la geometria breakout e' stata sostituita dal retest, 12 configurazioni su 12 OOS negative per il breakout sul Nasdaq).
11. **COSA SERVE**: niente di proprio; archiviarla col certificato quando (3) uscita, (4) gemelli e (5) TF sono scritti: oggi sono parziali.
12. **COSTO**: 0.
13. **FONTI**: RO; RB r.97-98; ON riga 3 (spenta 18/08); `FIRME_2026-08-18`. **DN1**: magic **970201** in RO, **770211** nel sorgente e in ON.

---

### SCHEDE 16, 17, 18, 20 - `ABTG_Nasdaq_Apertura_US_Pin9fca`, `_TrailFix`, `trailfix/CLAU12_Nasdaq_Apertura_US`, `standalone/ABTG_Nasdaq_Apertura_US`

- **Pin9fca**: binario in campo di 770260 (FTMO, 20/09). Diff vs pin (`9fca63d9`) = **0**; vs HEAD root = **22 righe di commento** (verificato dal MN con `git diff 9fca63d9..HEAD` e ricontato qui). **EREDITA** la scheda 14 (R199B, pin `28c18463`, fu girato su pin diversi ma equivalenti nel codice eseguibile).
- **TrailFix / CLAU12 Nasdaq**: come schede 4/5 (guardia trailing; stessa soglia equivalente); `NON MISURATO`; migliorabile **si**; serve prova di neutralita' + firma + ricompilazione solo `C:\FTMO`. In piu': il Nasdaq 770260 e' la sedia con **piu' rischio di raffica** perche' ha il parziale e il trailing sul 50% residuo.
- **standalone**: monolite del 26/07 (ora 15, range 15', magic 770201, rischio 2): **NON eredita** (diff vs pin 1.682 righe): `NON MISURATO`, migliorabile no.

---

### SCHEDA 19 - `esterni/Nasdaq_PreOpen_Breakout_EA.mq5` (+ `NasdaqOpeningBreakout_EA_v21_OPTIMIZED.ex5`) (AP-NAS)

1. **MOTORE**: breakout della candela 14:25-14:30 server (15:25-15:30 Roma) su M5, buffer 7 idx, MinRange 17 idx, stop al bordo opposto, target fisso +50 pt + 50% a +20, EMA50 pesa 70/30, nessun filtro spread/news/Guardian.
2-3. **SIMBOLO**: NASUSD M5; **mai girato** (RB A16); l'`.ex5` v21 e' un binario **orfano senza sorgente**: non misurabile per costruzione.
4-7. **ANNI/NUMERI/FORWARD**: nessuno.
8. **CLASSE**: **NON MISURATO**.
9. **VERDETTO**: `ESCLUSO PER COSTO` (stop minimo 24 idx / spread 1,80 = **13,33x** = pavimento duro; 12,63x al P95) **e** difetto strutturale: `InpLocalUtcOffsetHours=2` **cablato** + ancoraggio a Roma: dal 01/11/2026 al 14/03/2027 (~95 sedute) arma sulla candela delle 14:25, **un'ora prima, in silenzio**. Certificato: (1) PF mai (2) n/DD mai (3) uscita mai (4) gemelli mai (5) TF: **NON APPLICABILE** all'ingresso (candela fissa).
10. **MIGLIORABILE?** **no**. L'ingresso e' della stessa famiglia di `ABTG_Nasdaq_Live5m` (scheda 23), gia' misurata a tick e negativa.
11. **COSA SERVE**: niente (non si schiera: audit 12/09).
12. **COSTO**: 0.
13. **FONTI**: `report/AUDIT_NASDAQ_PREOPEN_2026-09-12.md`, `PREOPEN_NASDAQ_VALE_UN_POSTO_2026-09-12.md`, RB A16.

---

### SCHEDA 21 - `ABTG_DAX_Live5m` (LIVE5) - "morto" tenuto in osservazione

1. **MOTORE**: rottura secca della candela pre-apertura da 5', due lati, senza filtro di trend e senza cancello d'ampiezza, sul DAX.
2. **SIMBOLI/TF**: D30EUR M5 (`PrevWin=5`, ST OFF). Gemello: Nasdaq (scheda 23) e v2 (scheda 22).
3. **BACKTEST**: **L1** (RB r.107): le "27/27 combo negative" del 26/07 **non hanno CSV** in tutta la storia git; l'**unica cella con CSV** (`risultati_prove/ABTG_DAX_Live5m/*_D30EUR_{IS,OOS}.csv`): **tick** `[T]`, rischio **2,00%**, finestra `2024.01.01->2026.06.30` (girata contro un pavimento tick al 2024.09.26: ~29,5% su tick fabbricati), IS 0,93488 / 225 deal / DD 26,07% ; OOS **0,85701 / 342 deal / DD 39,74%**; gli stessi pin in **OHLC** `[B]`: IS 1,27364 / OOS **1,46853** (fattore **1,714**).
4. **ANNI/REGIMI**: 2024.01.01->2026.06.30, un regime; IS/OOS presenti.
5. **NUMERI**: vedi 3; n in deal; DD alla taglia di campo 2%.
6. **TIPOLOGIE**: indice europeo: SOTTO a tick; l'OHLC (+129k sul DAX nelle corse di luglio, RB nota sotto L3) e' un artefatto.
7. **FORWARD DEMO** (PICC): "DAX Live 5m" n 19, PF 1,41, +410,63; "DAX Live5m" n 12, PF 0,61, -149,27 (la prima etichetta e' il nome compilato di questo EA (`ABTG_DEF_NAME` = "DAX Live 5m"); la seconda **probabile v2** ("DAX Live5m v2" troncato), NON verificato). n piccoli, non classificano.
8. **CLASSE**: **SOTTO B** (OOS 0,857 su 342 deal, un regime).
9. **VERDETTO**: `NO PER RISCHIO` (DD 39,74%, quasi 4x il muro 10%) e **`ESCLUSO PER COSTO`** (stop minimo strutturale 1,2x-8,8x lo spread D30EUR contro 40x e contro il duro 13,3x). **Certificato (RB L1): (1) PF si · (2) n/DD si · (3) uscita ad asse NO · (4) gemelli NO (solo D30EUR; il Nasdaq e' provato ma non e' un gemello del cancello) · (5) TF: PARZIALE - grafico solo M5; `InpLevelTF` H1, `InpFilterTF` H1, `InpStTF` H1, `InpCorrTF` H1, `InpTrailTF` M1 mai mossi** -> **`NON ANCORA MISURATO`, NON morto**.
10. **MIGLIORABILE?** **si, ma solo sull'ingresso**: l'unico gradiente di TF dell'intera famiglia e' la finestra d'ingresso 5'->15' (v2: +0,077/+0,085/+0,089/+0,136 di PF e -5,64/-7,01/-9,26/-11,26 punti di DD su 4 coppie su 4). **30' e 60' mai provati**.
11. **COSA SERVE**: (a) finestra d'ingresso 15'/30'/60' **con split IS/OOS** (oggi finestra unica -> "best di 32" = selezione); (b) **uscita ad asse** (mai girata); (c) simboli gemelli col cancello **acceso** (U30USD/SPXUSD mai provati). **Regola del 19/08**: meccanismi e TF, **non** parametri dello stesso motore su M5. Costo: 44 passate ~**4 min** (RB, per il Nasdaq; il DAX `[STIMA]` simile), PC di backtest; **firma di Claudio** per toccare il TF dell'ingresso (RB L2 lo scrive esplicitamente).
12. **COSTO**: ~4 min per la serie del certificato (Nasdaq) / ~altrettanto DAX.
13. **FONTI**: RB r.30-33, r.107-112, r.2770; CSV9 righe Live5m; `RIESAME_MORTI_BREAKOUT_M5_2026-09-22.md` §3. **Riconciliazione**: il piano riportava "27/27 combo negative [B/T]" e "OOS tick 0,857 vs OHLC 1,47 (1,72)": **corretto** (le 27 passate non hanno CSV; la cella con CSV e' una).

---

### SCHEDA 22 - `ABTG_DAX_Live5m_v2` (LIVE5)

1. **MOTORE**: Live5m con cancello d'ampiezza (`InpMinRangePts`/`MaxRangePts` 1500/4000) e Supertrend; la griglia da 32 passate era **LONG-ONLY** (`InpAllowShort=0`) e **senza range filter** (0/0): descrizione corretta 22-23/09; 2 manopole su 5 erano inerti (32 passate = 4 celle distinte x 2 finestre d'ingresso x 4 ripetizioni).
2-3. **BACKTEST**: `risultati_archivio/Live5m/valid_DAX_Live5m_v2_D30EUR_realtick.csv`, tick `[T]`, rischio **1%**, **finestra unica**: best PF **1,04296**, DD 9,097%, n 239 (ST ON + PrevWin 15); resto 0,846-1,041, DD 9,10-26,08%. Cella con cancello acceso 1500/4000 (RB L2 (c)): **IS 1,00564 n 80 DD 4,70% / OOS 0,92490 n 202 DD 14,16%** (1%); OHLC OOS 1,71088 (fattore **1,850**).
4. **ANNI/REGIMI**: finestra dichiarata 2024.01.01->2026.06.30; un regime.
5. **NUMERI**: vedi 2-3. A 1% il DD raddoppiato vale 18,2-52,2%.
6. **TIPOLOGIE**: indice europeo, solo long: SOTTO a tick.
7. **FORWARD DEMO**: eventuale "DAX Live5m" n 12 PF 0,61 (vedi scheda 21, attribuzione non verificata).
8. **CLASSE**: **SOTTO C**.
9. **VERDETTO**: `ESCLUSO PER COSTO` su M5 (11,5-13,1x contro il duro 13,3x); `NO PER RISCHIO` (DD 14,16% a 1%). Certificato: (1)(2) si; (3) uscita NO; (4) gemelli NO; (5) TF: **PARZIALE** (grafico M5; finestra d'ingresso 5' e 15' provate, **30' e 60' mai**) e **manca lo split IS/OOS** della griglia -> `NON ANCORA MISURATO`.
10. **MIGLIORABILE?** **si** (la finestra 15' migliora PF e DD su 4 coppie su 4), **ma il costo su M5 lo esclude**: a M15+ lo stop strutturale cresce.
11. **COSA SERVE**: ritorno del TF effettivo: finestra d'ingresso 15'-60' con split IS/OOS e **un TF di grafico M15/M30** `[ma il TF del grafico e' inerte sul range; conta la finestra d'ingresso]`; uscita ad asse; gemelli col cancello acceso. Costo ~4 min per il pacchetto del certificato; **firma di Claudio** (TF ingresso).
12. **COSTO**: ~4 min, PC di backtest.
13. **FONTI**: RB r.109, r.2770; `CENSIMENTO_ORB_2026-09-29.md` riga 17 (lato short v2 `NON MISURATO`). **Dichiarato**: il lato short v2 non e' misurato.

---

### SCHEDA 23 - `ABTG_Nasdaq_Live5m` (LIVE5) - sedia 770203, spenta (ultimo trade 06/08)

1. **MOTORE**: rottura della candela 5' pre-apertura sul Nasdaq, buffer 700, MinRange 1700, MaxRange 4000, TP1 1R + 50% + trailing M1.
2. **SIMBOLI/TF**: NASUSD M5.
3. **BACKTEST**: RB L2 (12/09): tick, **2%**, `2024.01.01->` (finestra con ~29,5% non su tick reali): IS 1,01621 (n 116, DD 11,52%) / OOS 0,96265 (n 175 deal = 88-175 pos, DD 19,40%, -326,54); **r142a/b/c** (rilanciati, "riproduce"): IS 1,01472 / OOS 0,95624 (116 / 175, DD 12,3 / 22,5% @2%): ClosePct/uscita ad asse: l'asse morde (+0,11 PF) ma **nessuna cella arriva a 1,10**; senza trailing DD OOS 33,62%. OHLC stessa cella OOS 2,16249 (fattore **2,246**).
4. **ANNI/REGIMI**: un regime; IS/OOS presenti.
5. **NUMERI**: sopra; **due versioni dello stesso numero** (L2: 1,016/0,963; r142: 1,015/0,956): **si usa la piu' recente (r142)** e si dichiara; la differenza e' di pin/banco.
6. **TIPOLOGIE**: indice USA, SOTTO a tick.
7. **FORWARD DEMO** (PICC): "Nasdaq Live 5m" n 6, PF 1,74, +206,63 (n troppo piccolo).
8. **CLASSE**: **SOTTO B** (OOS 0,956 su 175 deal; "tutte < 1,10 con n >= 150").
9. **VERDETTO**: `NO PER RISCHIO` (22,5% a 2%) e `ESCLUSO PER COSTO` (13,33x = pavimento duro al decimale; 12,63x al P95: sotto). Certificato: (1)(2) si · (3) uscita: **si (r142a-c, voce 3 chiusa)** · (4) gemelli: parziali (D30EUR cancello SPENTO non e' lo stesso meccanismo; la v2 col cancello acceso esiste) · (5) TF: **NON APPLICABILE al grafico** (unica occorrenza di `PERIOD_CURRENT` r.296, ramo morto con `InpTrailStartR=0`); si chiude solo toccando `InpPrevWindowMin`/`InpLevelTF` (ingresso, **firma**) -> `NON ANCORA MISURATO` (mancano: (4) completo, (5) via firma).
10. **MIGLIORABILE?** **no per costo** a M5; **non ancora misurabile** per la finestra d'ingresso.
11. **COSA SERVE**: pacchetto "44 passate **3,99 min**" (RB L2, `PREOPEN_NASDAQ_IL_VERDETTO_2026-09-12.md` §8) con **firma sul TF d'ingresso**; U30USD/SPXUSD mai provati; larghezza finestra mai misurata ad asse controllato.
12. **COSTO**: 3,99 min, PC di backtest.
13. **FONTI**: RB r.108, r.3543-3545; MN §2.3; CSV9. **Contraddizione** fra L2 e r142 dichiarata sopra.

---

### SCHEDA 24 - `ABTG_DAX_M3` (DAXM3) e SCHEDA 25 - `DAX_M3_Supertrend`

1. **MOTORE**: Supertrend H4 come bias (moltiplicatore 3,5; periodo ATR **mai dichiarato dai documenti**, assunto 10 in entrambi gli EA), trigger M3, EMA200 + ADX>=25, gate operativo >= 09:30 CET; **non e' un breakout d'apertura M5** (errore di categoria del piano).
2. **SIMBOLI/TF**: D30EUR M3 trigger + H4 bias; `InpTriggerTF` e `InpBiasTF` **mai mossi**. Scheda 25 = riscrittura v2 esterna.
3. **BACKTEST FATTI**: **NESSUNO con risultato in repo**: `ini/ABTG_DAX_M3.ini` (26/07) = ottimizzazione `Model=1` (OHLC 1-min), 2024.01.01->2026.06.30, deposito 10k; **zero CSV in tutta la storia git** (riverificato 22-23/09 con `git log --all`). Il "**33% combo positive, short 0%**" del piano e di RB A8 e **NON verificabile**; RO (25/07) dice "21% combinazioni positive, DD 21%" `[B?]` senza CSV. Scheda 25: nessun round, nessun referto.
4. **ANNI/REGIMI**: n/a.
5. **NUMERI**: PF/n/DD `NON MISURATO`.
6. **TIPOLOGIE**: n/a.
7. **FORWARD DEMO** (PICC, solo scheda 24): "DAX M3" n 12, PF 0,52, -165,28 (n piccolo, non classifica).
8. **CLASSE**: **NON MISURATO** (il piano dava SOTTO per DAX_M3: **corretto**).
9. **VERDETTO**: `NON ANCORA MISURATO`, **ZERO PUNTI SU CINQUE**: (1) PF no · (2) n/DD no · (3) uscita (`InpTrailOnST`, `InpExitOnFlip`: zero occorrenze come asse) no · (4) gemelli no · (5) TF no (M3 e' il TF piu' caro della scala). `InpSLFixedPts` e' spazzolato su 6 valori ma `InpSLMode=SUPERTREND`: manopola **inerte** (6 passate identiche).
10. **MIGLIORABILE?** **non ancora misurabile**: la prima misura non esiste.
11. **COSA SERVE**: (a) una prima corsa **a tick reali BCM** con IS/OOS (finestra 2024.09.26->2026.06.30, un regime) sulla cella di default, poi TF di trigger M5/M15/M30 e bias H1/H4/D1, uscita (`InpTrailOnST`, `InpExitOnFlip`), simboli (Nasdaq, Dow); il periodo ATR del Supertrend e' parametro da sweepare (non e' "fedelta' al corso") · (b) lo spec `caccia_strategie/biblioteca/schede/SPEC_DAX_M3_2026-08-19.md` elenca i **buchi** (periodo ATR, zona ADX 20-25, ora di fine operativita', giorni esclusi, fuso del box asiatico). Costo: `[STIMA]` 3-7 min per ~10-20 passate a 0,333 min/passata (R245), **M3 piu' pesante di M5: bordo alto NON MISURATO**; PC di backtest; **nessuna firma**, lavoro di preparazione del file prova. Per la scheda 25: stessa misura sull'altra riscrittura, **dopo** la 24, e solo per decidere quale dei due file tenere.
12. **COSTO**: 3-7 min + preparazione.
13. **FONTI**: RB r.123 (nota 1), r.226 (O3); `report/CENSIMENTO_CASELLE_VUOTE_2026-09-22.md`; `backtest_pipeline/ini/ABTG_DAX_M3.ini`; `RISULTATI_OTTIMIZZAZIONE.md`. **DN3**.

---

### SCHEDA 26 - `standalone/ABTG_DAX_M3.mq5 · ABTG_DAX_Live5m.mq5 · ABTG_Nasdaq_Live5m.mq5`

Copie "tutto-in-uno" del 26/07: differiscono dalla root di **131 / 212 / 212 righe** (conteggio `diff` eseguito qui; non diffate nel merito, probabilmente versioni precedenti al filtro volumi). **EREDITA non dimostrata**: classe **NON MISURATO**; nessuna misura propria. Migliorabile: **no** (snapshot). Cosa serve: niente. Fonti: diff eseguiti.

---

## 3. LE CONTRADDIZIONI FRA FONTI E COME SONO STATE RISOLTE (usata la piu' recente, dichiarato)

| # | punto | fonti in conflitto | decisione |
|---|---|---|---|
| 1 | `ABTG_DAX_M3`: "33% combo positive [B]" | piano sez. 3-4 / RB A8 (26/07) contro RB r.123 (22-23/09) | **ha vinto il piu' recente**: il numero non e' verificabile, zero CSV in storia git. Classe corretta da SOTTO a **NON MISURATO** |
| 2 | `ABTG_Apertura_Marco`: "nessun PF proprio" | piano riga 7 contro `Marco_Emiliano/valid_Marco_*.csv` (4 CSV) | **il CSV batte la prosa**: ci sono 44 passate misurate (finestra unica): classe corretta da NON MISURATO a **MISTA** |
| 3 | Live5m "27/27 combo negative [B/T]" | piano / A4-A6 contro RB r.107 (22-23/09) | le 27 passate **non hanno CSV**; la cella con CSV e' una: usata quella |
| 4 | `ABTG_Nasdaq_Live5m`: 1,016/0,963 (L2) contro 1,015/0,956 (r142) | RB L2 (12/09) / CSV9 contro RB r.3543 (rilanciato) | **usato r142** (piu' recente, riproduce n 116/175) |
| 5 | `ABTG_Nasdaq_Apertura_US_Ottimizzato`: 0,91 'morto' contro 1,34 | CLASSIFICA_PF/A4 (26/07, griglia **long-only** del motore base) contro RO (25/07, cella baked, 340 trade) | **sono celle diverse**: la Ott e' **SOPRA C\*** (senza OOS, DD 11,6% rischio rosso); 0,91 e' del motore base |
| 6 | `standalone/*` "copie del 08/09, EREDITA" | piano D12 contro `git log` (26/07) e `diff` | **non ereditano**: motori v1.00 diversi (1.484-1.944 righe di diff sull'apertura) |
| 7 | TrailFix = CLAU12? | piano riga 4-5 ("stesso") contro diff eseguito | **due forchette della stessa guardia**: soglia equivalente, log e testa diversi (75 righe) |
| 8 | `Pin9fca` DAX = HEAD? | piano: "copia byte per byte della sedia 770101" | **= pin `9fca63d9` (0 diff)**, ma **non = HEAD** (+460 righe, filtro SPAZIO OFF): D12 chiuso con riserva |
| 9 | D4: 770260 1,14/1,11 su 91/94 contro 1,22/1,22 su 82/102 | CT / dossier contro MN / R199B | **riconciliato per cause** (sez. 4.1): sono due celle diverse |
| 10 | DD "7,5/12,3%" short DAX | piano contro CSV R270d | **conferma** (7,4732 / 12,3052; PF 0,96513 / 0,95734) |
| 11 | candidato Dow su `ABTG_Nasdaq_Apertura_US`/U30USD | assente dalla riga 14 del piano | **aggiunta come cella 14k** |
| 12 | short DAX 770105: 0,957 (R270d) contro 1,065 (R251b / FASE M) | due OOS della **stessa config** (CSV confrontati colonna per colonna), finestra 10/06 contro 01/07/2025, banco 100k contro 10k | **CONTESA -> NON MISURATO** (piano 5.2.6), aggiunta dal cancello 05/10; il rischio non e' conteso (12,31 / 12,05%) |

### 4.1 D4 (770260) in dettaglio
Le due misure **non descrivono la stessa cella**: (a) il **contratto del 20/09** e' `NASDAQ_B_motore` Pass 8, **ClosePct 0**, **10.000 EUR, rischio 1%**, IS ->2025.06.30 (91 pos) / OOS 2025.07.01-> (94 pos): PF 1,145 / 1,109; (b) la **cella in campo dal 21/09** (R199B Pass 2) ha **ClosePct 50** (firmato il 21/09 20:22), **80.000 EUR, rischio 2,00%**, taglio 0,40 (IS ->~2025.06.09): PF 1,221 / 1,215 su 82 / 102 pos. La **gemella a ClosePct 0 di R199B** (Pass 0) fa 1,116 / 1,149 su 82 / 102: confronta con 1,145 / 1,109 del contratto **a parita' di parziale**, differenza dovuta a finestra (06/09 contro 06/30) e a banco/rischio (pavimento del lotto a 10k e 1%). **Non e' provato con un G0 a parita' di pin e di banco**: resta `NON PROVATO`, ma la contraddizione apparente cade (non e' "1,14 oppure 1,22": sono due configurazioni).

---

## 5. D12 (copie, pin, TrailFix, standalone): cosa e' stato eseguito qui

| confronto | righe diverse (`diff`, righe vuote INCLUSE; ricontato dal cancello 05/10: senza le vuote DAX pin-HEAD 427, standalone 1.821 / 1.585 / 125 / 202 / 202) |
|---|---|
| DAX Pin9fca vs `git show 9fca63d9` | **0** |
| Dow Pin9fca vs `git show 9fca63d9` | **0** |
| Nasdaq Pin9fca vs `git show 9fca63d9` | **0** |
| DAX Pin9fca vs HEAD root | 460 (225 non-commento, filtro SPAZIO `InpSpaceMode` OFF) |
| Dow Pin9fca vs HEAD root | **0** |
| Nasdaq Pin9fca vs HEAD root | 22 (commenti) |
| Pin vs `CLAU12` (3 EA) | 53 / 53 / 53 (51 aggiunte + 2 tolte = LEGGIMI) |
| Pin vs `TrailFix` (3 EA) | 58 / 58 / 58 |
| `TrailFix` vs `CLAU12` (3 EA) | 75 / 75 / 75 (soglia equivalente; nome e logica del log diversi) |
| `standalone` vs root: DAX_Apertura_EU / Nasdaq_Apertura_US / DAX_M3 / DAX_Live5m / Nasdaq_Live5m | 1.944 / 1.702 / 131 / 212 / 212 |

---

## 6. ROUND R242-R269 E POST (controllati: hanno cambiato verdetti di questo gruppo?)

- **R246 / R246 inverno** (24/09, 29/09): **si**: separano per stagione DAX long e Dow; DAX long diventa "d0 inverno 1,389, d+1 inverno 1,184, estate 1,108" e il Dow resta **sospeso** per G1 aperto. (Aggiornati in schede 1 e 10.)
- **R247 / R248 / R250 / R245 / R262 / R263**: **si, per una cella nuova**: il candidato #1 del Dow (cella 14k), con avvisi (in fase 0,964/132; vergine 0,514/39, **entrambi della cella vicina `InpEmaSlow=200`**; 0/48 sotto il muro a 2%).
- **R251 / R270-R273 / PRV_DAXAP_02**: confermano il **default** del 770101 e bocciano per rischio lo **short** (12,31% R270d; 12,05% R251b); il **merito** dello short resta **CONTESO** (0,957 contro 1,065, sez. 4 riga 12).
- **R255 / R267c/d**: Dow short **bocciato per rischio** in fase; stH8/stH12 = indizio n<150.
- **R252, R274, R280, PRV_DAXAP_04, R214a-d, R215a, R231a, R275, R183, R180**: **nessun CSV in repo** (cartelle `risultati_archivio` verificate: esistono solo R251, R253, ROUND_ORB_R271, ROUND_R255, ROUND_R270, ROUND_R273 per questo gruppo). Sono **scritti, non girati** (o girati ma non tornati: R252).
- **R242-R244, R260-R269 (MaxMin, oro, EMA200)**: non di G1; R267g (DAX long, filtro S&P = 770411) e' del G3.

---

## 7. COSA MIGLIORARE PER PRIMA (max 5 misure, ordinate per valore/costo; nessun criterio abbassato)

1. **R252 + PRV_DAXAP_04 (short DAX in fase, e modi per lato)**: **0-12,6 min** di tester (0 se lo zip esiste sul Desktop di `DESKTOP-H4D7CAJ`). **Perche' prima**: la sedia 770105 e' in campo e il numero che la giudica **manca da 10 giorni**; decide se il DD 12,31% e' un artefatto dell'orologio (R251: tutto il DD OOS nell'inverno sfasato). Serve: lo zip o il via libera a rilanciare + il **lettore dei round** (lavoro). Firma: no per la lettura; si per eventuali modifiche in campo.
2. **Candidato Dow: R280 (5,3 min, 16 passate) + rilettura R250 B (0 min, 1 firma)**: e' **l'unica cella del gruppo con n >= 150 in IS e OOS e PF >= 1,25 / 1,48**; i quattro ostacoli (orologio in fase 0,964; finestra vergine 0,514 su 39; muro del DD a 1,25-1,50%; 47,5% giornate sotto 40x) decidono se e' una sedia o una finestra. R280 dice se il merito e' un artefatto della griglia H4 BCM (CE-4).
3. **R274 (orologio 770260, 16 passate, 5-24 min) + R214c/d (TF M15/M30, 8 passate, 2,7-12 min)**: la frequenza d'inverno del Nasdaq (indizio 0,69 pos/g d'inverno contro 0,22 d'estate, 1,3 sigma) e la leva del filtro volumi sul TF. Serve prima **scrivere il lettore** (non esiste); **strato 2 del cancello da fare**.
4. **Prova di regime con storico esterno**, in ordine di costo: **DAX 2010-2018** (32 passate 3-11 min + 2-4 min di conversione; 3 firme D-J/D-K/D-L), **Nasdaq `NASUSD_EXT`** (34 passate 8-20 min, gemella senza volumi, **orologio EXT da rileggere**), **Dow Dukascopy** (90-348 h di PC acceso + 30-60 min tester, 2 firme). E' l'unica misura che compra **regime** per le sedie vive: oggi `NON MISURATO` ovunque nel gruppo.
5. **Chiudere i certificati dei "morti" Live5m e DAX_M3** (non sono morti, **mancano 2-5 caselle**): Live5m finestra d'ingresso 15'-60' con split IS/OOS (~4 min, firma sul TF d'ingresso); **DAX_M3 prima corsa a tick con IS/OOS** (3-7 min `[STIMA]`, M3 non misurato). Valore: basso sul PF ma alto sull'**onesta' dell'archivio** (oggi due EA dichiarati "morti" con zero o un solo CSV).

---

## 8. CONTEGGI DEL GRUPPO G1 E PUNTI DUBBI NUOVI

**26 righe del piano -> classi finali**: **SOPRA** (solo celle SOPRA) **2** (righe 2 e 15, entrambe senza OOS) · **SOTTO** (solo celle SOTTO) **3** (righe 21, 22, 23) · **MISTA** (celle SOPRA e SOTTO insieme) **5** (righe 1, 7, 8, 10, 14) · **EREDITA** **3** (righe 3, 11, 16: ereditano 1, 10, 14) · **NON MISURATO** **13** (righe 4, 5, 6, 9, 12, 13, 17, 18, 19, 20, 24, 25, 26).
Letto "un EA e' in SOPRA se ha almeno una cella SOPRA" (piano 5.1): **7 righe** in SOPRA (1, 2, 7, 8, 10, 14, 15) + 3 ereditate = **10**; **8 righe** in SOTTO (1, 7, 8, 10, 14, 21, 22, 23) + 3 ereditate = **11**.
**Celle autonome della tabella 1** (50 voci, di cui 3 righe EREDITA che non contano come celle; le voci 8b e 14g hanno una cella SOPRA e una SOTTO e contano due volte): **SOPRA 17 · SOTTO 16 · NON MISURATO 16 = 49 celle** (ricontate dal cancello 05/10 a mano sulla colonna "classe"; prima stesura 16 / 17 / 15 = 48: mancava il long R107 di 14g, SOPRA C, e 1b passa da SOTTO a CONTESA -> NON MISURATO). Fra le SOPRA: **2 hanno SEGNO INVERTITO (1c, 1e)**, **con n OOS >= 150 in posizioni verificate solo 1a (193) e 14k (199)** (in deal, non confrontabili con 150: 1c 316, 1e 250, 1f 194, 8a 311, 8b 325), **nessuna ha affidabilita' A** (nessuna ha due regimi).

### Punti dubbi NUOVI (oltre D1-D13 del piano)
- **DN1** Magic dei file Ottimizzati: `DAX_Apertura_EU_Ottimizzato` **770111** (sorgente/CLASSIFICA) contro **770102** (RO, "creato prima"); `Nasdaq_Apertura_US_Ottimizzato` **770211** (sorgente/ON) contro **970201** (RO). Chiude chi legge i `.set`/preset in `mql5/presets` o il censimento ordini.
- **DN2** `ABTG_Apertura_Marco` ha 4 CSV propri (finestra unica): il piano li ignorava.
- **DN3** `ABTG_DAX_M3`: "33% positive" non esiste come numero verificabile; RO ne dice "21%, DD 21%": **due numeri non verificabili in conflitto**, nessun CSV.
- **DN4** La cella **U30USD sull'EA Nasdaq** (candidato #1 Dow) non e' nella riga 14 del piano; va tracciata in G1 o G2.
- **DN5** Il tipo di dato `T?` delle celle con `FromDate=2024.01.01` (Live5m, Marco, A2, M3, Nasdaq Ott): **il tick BCM parte il 2024.09.26**: ~29,5% della finestra e' su tick non reali `[INFERITO per analogia con RB r.124, mai misurato per ciascuna]`. Da dichiarare accanto a ogni numero di quelle celle.
- **DN6** `standalone/` e' del **26/07**, non dell'08/09 come dice il piano.
- **DN7** Due forchette della stessa guardia trailing coesistono (`ABTG_*_TrailFix` in root e `CLAU12_*` in `trailfix_9fca63d9/`).
- **DN8** Forward demo per **etichetta commento**, non per magic: "DAX Live5m" (n 12) potrebbe essere v2; "Nasdaq Apertura US" (n 15) potrebbe essere 770201; "DAX Apertura EU" (n 34) potrebbe essere la breakout storica e non la RETEST.
- **DN9** Finestre IS/OOS **diverse** fra le celle (06/09, 06/30, 06/10 contro 07/01): confrontare PF fra celle richiede di saperlo.
- **DN10** Il diff DAX Pin9fca vs HEAD (225 righe non-commento) e' stato **letto in parte**: se una riga fuori dal filtro SPAZIO toccasse l'ingresso, "EREDITA" cade.

---

## 8bis. AUTOVERIFICA (contro-esempi costruiti prima di consegnare)

- **"DAX_M3 e' SOTTO (33%)"**: ho provato a rompere la mia correzione cercando un CSV in tutto il repo (`git log --all` citato da RB; `find` sui `.ini`): nessun CSV; la correzione regge.
- **"Marco non ha PF"** (piano): ho aperto i 4 CSV e confrontato `valid_Marco_DAX_base.csv` buf 600 (1,244 / n 309) con la "media 1,25 / 314 tr" di A2: coincide (stessa finestra, stessa famiglia).
- **"Pin9fca = HEAD"**: ho diffato (0 righe per Dow, 460 per DAX): il Dow regge, il DAX no; chiuso con riserva dove ho letto solo in parte il diff.
- **D4 (770260)**: l'ipotesi alternativa "le due misure sono la stessa cella con numeri diversi" e' smentita dalla colonna `InpTP1_ClosePct` dei due CSV (0 contro 50) e dal banco (10k/1% contro 80k/2%): ma la gemella a ClosePct 0 (R199B Pass 0: 1,116 / 1,149) **non coincide** col contratto (1,145 / 1,109): la differenza e' attribuita a finestra e banco **senza prova** (resta `NON PROVATO`).
- **Cella 14k "SOPRA B"**: contro-esempio cercato nelle stesse fonti: in fase 0,964 su 132 e vergine 0,514 su 39 **la ribaltano**; per questo il verdetto e' `NON ANCORA MISURATO come sedia`, non "promossa".
- **Strato 2 del cancello (05/10, `controllo-preventivo`)**: FAIL corretto in questo stesso file - 1b CONTESA (0,957 contro 1,065 sulla stessa config; stagioni 96/85 ricalcolate e attribuite al taglio R251), 14k avvisi "in fase" e "vergine" della cella vicina 200 dichiarati, 14g C e non D + long SOPRA, 1d migliorabile NMI, lettera B provvisoria sulle celle in deal, intestazione dei diff, riga 21 "2/5 + 1 parziale", conteggi 17/16/16 = 49.
- **Non fatto dall'agente autore**: rilettura dei CSV di R246/R251/R253/R255/ROUND_ORB (i numeri di quelle righe vengono dalle mappe del 03/10 e dai referti, non ricalcolati da me).

---

## 9. FONTI (percorsi dal repo)

`report/RESOCONTO_EA_PIANO_2026-10-05.md` · `report/APERTURE_DAX_MAPPA_2026-10-03.md` · `report/APERTURE_DOW_MAPPA_2026-10-03.md` · `report/APERTURE_NASDAQ_MAPPA_2026-10-03.md` · `report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` · `report/CONTRATTO_GATEDSHORT_770250.md` · `report/ORB_NASDAQ_PERCHE_E_SPENTO_2026-09-23.md` · `report/IL_RETEST_SUL_NASDAQ_LA_RICONCILIAZIONE_2026-09-18.md` · `report/RIESAME_MORTI_APERTURE_2026-09-22.md` · `report/PICCOLO_PF_PER_EA_2026-10-01.md` · `report/TRIAL_SFORTUNA_O_EA_2026-10-03.md` · `report/FTMO_CHALLENGE_CHIUSURA_2026-09-30.md` · `report/REGIME_DAX_SPEC_2026-10-05.md` · `report/REGIME_NASDAQ_SPX_SPEC_2026-10-05.md` · `report/PIANO_REGIME_DOW_DUKASCOPY_2026-10-05.md` · `report/DOSSIER_EXPERT_PER_EMILIANO_2026-10-05.md` · `report/PACCHETTO_DEL_MATTINO_2026-09-23.md` · `report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md` · `report/CENSIMENTO_CASELLE_VUOTE_2026-09-22.md` · `backtest_pipeline/REGISTRO_TEST.md` · `REGISTRO_TEST.md` (root) · `backtest_pipeline/RISULTATI_OTTIMIZZAZIONE.md` · `backtest_pipeline/CLASSIFICA_PF.md` · `backtest_pipeline/risultati_archivio/CENSIMENTO_PF_TUTTI_2026-09-09.csv` · `backtest_pipeline/risultati_archivio/Marco_Emiliano/*.csv` · `backtest_pipeline/risultati_prove/R199B/` · `backtest_pipeline/risultati_prove/aperture_r47/` · `backtest_pipeline/risultati_archivio/ROUND_CORTI_B_2026-09-27/ROUND_R262b/` · `backtest_pipeline/risultati_archivio/ROUND_R270_USCITA_DAX_2026-09-28/` · `docs/Analisi_Backtest_DAX_v1.md` · `mql5/Experts/trailfix_9fca63d9/LEGGIMI.md` · sorgenti `mql5/Experts/` (diff eseguiti qui) · `FLOTTA_ATTIVA.md`.

---

## CHANGELOG
| data | cosa | perche' |
|---|---|---|
| 05/10/2026 | creato il file (FASE 2, gruppo G1: 26 righe del piano, 11 correzioni alle classi provvisorie, 10 punti dubbi nuovi) | richiesta di Claudio del 05/10/2026 sul resoconto PF sopra/sotto 1 per ogni EA |
| 05/10/2026 | strato 2 del cancello: FAIL corretto (1b CONTESA, 14k cella vicina, 14g C + long SOPRA, 1d NMI, B provvisoria in deal, diff, riga 21, conteggi 17/16/16) | `controllo-preventivo`, verifica alla fonte; checklist classe 1126 |
