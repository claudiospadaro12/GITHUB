# RESOCONTO EA - GRUPPO G6a (CAC-B: cacce web breakout / struttura / volatilita' / sessione) - SCHEDE RIEMPITE - 05/10/2026

> **DOCUMENTO INTERNO. NON ESCE. BOZZA, NON PASSATA DAL CANCELLO.** Fase 2, ondata 3, sottogruppo G6a del resoconto richiesto da Claudio il 05/10/2026
> (*"un resoconto di tutti gli EA con PF sopra 1 e sotto 1: che backtest e' stato fatto, che anni sono stati misurati, che tipologie di mercato hanno superato, se sono migliorabili e cosa serve"*).
> Piano e regola di classificazione: `report/RESOCONTO_EA_PIANO_2026-10-05.md` (sez. 5-8). Formato e lezioni dei cancelli: `report/RESOCONTO_EA_G4_FOREX_AGOSTO_2026-10-05.md`, `report/RESOCONTO_EA_G5_SUPERTREND_GOLDEN_ORO_2026-10-05.md`, classi 886/938/1126/1127/1128 di `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md`.
> **Perimetro**: i **17 EA CAC-B** del piano (`ABTG_CRT_TurtleSoup`, `ABTG_IBRetest`, `ABTG_LVNArbitro`, `ABTG_OpeningReversalB`, `ABTG_OutOfNoise`, `ABTG_NySessionRetest`, `ABTG_DaxReEntry`, `ABTG_DaxValueArea`, `ABTG_HVAncora`, `ABTG_AtrExhaustVol`, `ABTG_IntradayMomentum`, `ABTG_LiquiditySweep`, `ABTG_FvgRetest`, `ABTG_ImpulsoApertura`, `ABTG_VolExpBreak`, `ABTG_CanaleLento`, `ABTG_Cycle`). **Nessuno dei 17 ha copie in `standalone/`, `trailfix_9fca63d9/` o `esterni/`** (elenchi letti il 05/10): il punto D12 del piano **non si applica a G6a**.
> **Sola lettura d'archivio.** Nessun round lanciato, nessun EA/preset/magic/sedia/conto toccato, nessun file di altri agenti toccato, VPS non toccato. Il forward e' **solo demo**: per i 17 EA **non esiste nessun forward** (verificato: `CODA_01_sedie_attaccate_20261005` non nomina nessuno dei 17; nessun magic dei 17 compare in `data/statements/*.csv`).
> **Stato del cancello**: bozza dello Sviluppatore G6a. Prima del PASS di `controllo-preventivo` resta INTERNA e non va a Claudio (CLAUDE.md, cancello del 09/09).
> **Precedenza delle fonti**: il CSV in repo batte il referto, il referto batte la prosa. Un numero che esiste solo in un referto o in prosa (nessun CSV in repo) e' marcato **`[DICHIARATO]`** o **`[NON RIPRODOTTO]`** e non e' ricalcolato da me. Dove un numero non c'e': **NON MISURATO**.

---

## 0. COME LEGGERE (convenzioni di questo file)

- **Tipo di dato**: `[T]` tick reali BCM (indici dal **26/09/2024**, forex dal 05/07/2024) · `[B]` barre OHLC M1 BCM nativo (screening: PF a barre eccede quello a tick di 1,72-3,51x, il DD e' un **limite inferiore**: **mai** la parola "RISCHIO PASSATO" su un DD a barre, classe 886) · `[E]` feed esterno `_EXT` (barre M1 di un simbolo custom, 2018-2024) · `s.OOS` = finestra piena senza taglio IS/OOS.
- **Finestre standard** (salvo scritto): tick indici `2024.09.26 -> 2026.06.30`, `@FRAZIONEIS 0,40` = **IS 2024.09.26-2025.06.09 (183 feriali), OOS 2025.06.10-2026.06.30 (276 feriali)**. Fonti: `REFERTO_PASSO0_OUTOFNOISE` r.3-6 (date esatte), `REFERTO_13_ROUND` e `LA_VIA_PIU_CORTA` (stessa convenzione). Dove il referto non scrive le date (P0 di settembre) le date sono **`[INFERITE]`** dalla stessa regola e lo dico.
- **n**: colonna `Trades` dell'OPTFRAME = **deal di uscita**. Per i motori **senza parziale** deal = posizioni (verificato negli input: `IBRetest`, `LVNArbitro`, `HVAncora`, `IntradayMomentum`, `OpeningReversalB`, `DaxReEntry`, `CanaleLento`; `AtrExhaustVol` e `LiquiditySweep` hanno `InpTP1Pct=0` nei round letti; `DaxValueArea` ha `InpTP1_ClosePct=0` in R141e). Per i motori **con parziale 50%** (`CRT_TurtleSoup`, `NySessionRetest`) il fattore deal/posizioni e' 1,35 misurato (`NySessionRetest`: 623 deal / 460-462 posizioni, referto 31/08); per `CRT` e' **NON MISURATO** e scrivo la forbice.
- **Affidabilita'** (piano 5.4): A = n OOS >= 150 pos + OOS vero + >= 2 regimi misurati uno per uno · B = n >= 150 ma un regime · C = 30-149 · D = < 30. **Nessuna cella di G6a ha affidabilita' A** (su tick BCM il regime e' uno solo: il rialzo 2024-26). **SEGNO INVERTITO** = IS e OOS da parti opposte di 1.
- **Classi**: SOPRA / SOTTO / NM per **cella** (EA x simbolo x TF x lato x config). Riferimento = **PF OOS a tick**; senza OOS, PF a tick su finestra piena marcato `s.OOS`; con solo barre/esterni la cella e' **SCREENING** e porta il suffisso `-scr`. **Conteggio doppio** (sez. 2): **(A)** con le celle screening, **(B)** solo con le celle a tick, cosi' un lettore che vuole solo i tick li trova senza ricalcolare.
- **Soglia di ZONA GRIGIA sul PF non esiste** (D2 del piano): un PF 1,00-1,10 e' scritto "SOPRA formale (indistinguibile da 1)". "SOPRA" non vuol dire "buono".
- **Letture dei cancelli G1-G5 applicate** (classi 1126/1127): per ogni round citato ho letto **tutte le righe** del CSV nei **due versi** (celle SOPRA nascoste E celle SOTTO nascoste), non la sola riga di default; e per ogni numero di contorno scrivo round, cella e finestra del suo taglio. Righe lette alla sez. 7.
- **Certificato di morte a 5 caselle** (PF · n e DD · gestione dell'uscita ad asse · simboli gemelli · TF cambiato): se ne manca una il verdetto e' **NON ANCORA MISURATO** e scrivo **cosa manca**. Mai "MORTO" senza le cinque. Il rischio (DD a qualunque n) e' un cancello a parte e non ha bisogno del certificato.
- **Orologio (caveat che vale per TUTTI i 17)**: `report/OROLOGIO_BCM_2026-09-24.md` (24/09) misura che BCM e' UTC+1 **fisso**: d'inverno le sedie a ora fissa armano **un'ora prima** dell'apertura cash. Quasi tutti i round di G6a (28/08-20/09) usano ore server fisse **da estate** e **non sono stati ricalcolati**. Quota di giorni feriali "inverno" della finestra standard `[DERIVATO da me]` con le regole DST di USA (EST: 03/11/2024-08/03/2025 e 02/11/2025-07/03/2026) ed EU: **IS 49,2% USA / 60,1% EU · OOS 32,6% USA / 39,9% EU · tutta la finestra 39,2% / 47,9%** (459 feriali). Vedi punto dubbio G6a-4.

---

## 1. TABELLA RIASSUNTIVA

### 1.1 Una riga per EA (17 righe)

`classe A` = con le celle screening `[B]/[E]`; `classe T` = solo celle a tick. `PF IS / OOS` e n sono della **cella piu' avanzata o di contratto** (nessuno dei 17 ha una sedia: scrivo la cella con il campione piu' grande o il numero piu' citato). **Nessun EA di G6a e' MORTO con certificato 5/5.**

| # | EA | cella di riferimento | dato | PF IS / OOS | n IS / OOS | anni misurati | classe A | classe T | aff. | verdetto di casa | migliorabile? |
|---:|---|---|---|---|---|---|---|---|---|---|---|
| 1 | `ABTG_CRT_TurtleSoup` | NASUSD M15, meno peggio dei 30 | [T] + [E] | 0,656 / 0,726 (gated tick 0,459 s.OOS) | 222 / 276 deal (gated 1460) | tick 2024.09.26-2026.06.30 · `_EXT` 2020-2024 | ENTRAMBE | SOTTO | C/B (deal) | NON ANCORA MISURATO (certificato 2/5); non deployabile nel toro | non so (serve tick del regime di range) |
| 2 | `ABTG_IBRetest` | U30USD / NASUSD / D30EUR M30 | [T] 10k | 0,382 / 0,697 · 0,563 / 0,593 · 1,211 / 0,965 | 42/53 · 35/49 · 58/107 | 2024.09.26-2026.06.30 | SOTTO | SOTTO | C | scartato dal cancello C0 (famiglia PF 0,7798 n 344), NON ANCORA MORTO (certificato 2/5) | si' ma senza griglia (1 manopola) |
| 3 | `ABTG_LVNArbitro` | U30USD M30 | [T] 10k e 100k | 0,979 / 1,051 (100k: 0,975 / 1,052) | 392 / 618 | 2024.09.26-2026.06.30 | SOPRA | SOPRA | B | SOPRA formale, SEGNO INVERTITO; NO PER RISCHIO (DD 11,3-19,4%); certificato 2/5 | non so (tesi nuova) |
| 4 | `ABTG_OpeningReversalB` | U30USD M5 | [T] 10k | 1,826 (n 2) / n.d. | 2 / 0 | 2024.09.26-2026.06.30 | NM | NM | D | NON MISURABILE (campione vuoto: 0 operazioni su 11 passate OOS) | non so (tappo a valle dei punteggi) |
| 5 | `ABTG_OutOfNoise` | NASUSD M15 | [T] 100k | n.d. | 0 / 0 | 2024.09.26-2026.06.30 | NM | NM | - | NON MISURATO: EA a n=0 anche dopo il fix v1.01 | si' (diagnostica v1.02 mai girata) |
| 6 | `ABTG_NySessionRetest` | U30USD M15, slope 75 | [T] s.OOS 100k | 1,374-1,427 (nudo 1,002) | 114-115 deal (~85 pos) | 2024.09.26-2026.06.30 | ENTRAMBE | ENTRAMBE | C | MERITO SOSPESO; certificato 3/5; gate slope reale | si' (campione) |
| 7 | `ABTG_DaxReEntry` | D30EUR M5 long, break 20/40 | [T] s.OOS | 1,159 / 1,69-1,80 (s.OOS) | 92 / 57 | 2024.09.26-2026.06.30 | ENTRAMBE | ENTRAMBE | C | long SOPRA sospeso (n<150); short SOTTO; certificato 3/5 | si' (M1 scritto, mai girato) |
| 8 | `ABTG_DaxValueArea` | D30EUR M15 (R141e, 4 celle) | [T] 100k | n.d. (CSV non in repo) | n.d. | - | NM | NM | - | NON MISURATO: R141e GIRATO (5 notti) ma CSV non in repo; il "morto" del 09/09 e' un argomento, non un numero | si' (leggere i CSV: 0 min) |
| 9 | `ABTG_HVAncora` | U30USD M30, `InpStopAtr` 1,0-2,5 | [T] 100k | 1,385 / 1,921 (k=1,0) | 22 / 31 | 2024.09.26-2026.06.30 | ENTRAMBE | ENTRAMBE | C/D | MERITO SOSPESO; tappo a monte misurato (91+165 ancore scadute); certificato 3/5 | si' (meccanismo, non parametri) |
| 10 | `ABTG_AtrExhaustVol` | NASUSD M30 `InpProxMode` 1 (ATR) | [T] 100k | 0,972 / 1,229 (PERC: 0,711 / 0,952) | 70 / 96 (PERC 153 / 224) | 2024.09.26-2026.06.30 (R109: -2026.08.21) | ENTRAMBE | ENTRAMBE | C (PERC B) | cella ATR sospesa; cella PERC e R109 NO PER RISCHIO; certificato 4/5 (manca l'uscita) | si' (gemello + uscita) |
| 11 | `ABTG_IntradayMomentum` | NASUSD M30 L+S (e gemello U30USD) | [T] 100k 0,65% | 0,609 / 1,243 (U30USD 0,599 / 1,035) | 146 / 261 | 2024.09.26-2026.06.30 | ENTRAMBE | ENTRAMBE | B (OOS) / C (IS) | SEGNO INVERTITO su 4 celle su 4; NON ANCORA MISURATO; D5 risolto (sez. 3) | si' (D30EUR + orologio) |
| 12 | `ABTG_LiquiditySweep` | EURJPY (struttura M30-H4) · GBPUSD M15 | [B] 10k + [T] | R95 0,65-0,80 (0/30) · R89 0,232 / 1,057 | R95 149-3641 · R89 14 / 24 | EURJPY 2015.07.01-2026.06.30 [B] · GBPUSD 2024.07.05-... [T] | ENTRAMBE | ENTRAMBE | D (tick) | R95 0/30 su barre; certificato 3/5 (uscita mancante); NON ANCORA MISURATO | non so (tesi nuova) |
| 13 | `ABTG_FvgRetest` | D30EUR (M15/H4: due fonti) | - | n.d. | 0 / 0 | mai girato | NM | NM | - | NON MISURATO; il "DD 42,9%" e' ritirato (nessuna fonte) | si' (1 passo 0, file pronti) |
| 14 | `ABTG_ImpulsoApertura` | D30EUR / U30USD M30 (R140a/b scritti) | - | n.d. | 0 / 0 | mai girato | NM | NM | - | NON MISURATO: scritto, mai girato (non in coda, non nel runner) | si' (2 file prova pronti) |
| 15 | `ABTG_VolExpBreak` | NASUSD / U30USD M30 (R145a/b) | [T] 100k | n.d. (CSV non in repo) | n.d. | - | NM | NM | - | NON MISURATO in repo; R145a/b GIRATI (7 notti, exit 0) | si' (leggere i CSV: 0 min) |
| 16 | `ABTG_CanaleLento` | XAUUSD D1, 20 celle | [B] 100k 1% | mediana 0,87 / 1,11 (non cella) | 29-112 / 47-164 | IS 2009.07.16-2016.04.27 · OOS 2016.04.28-2026.06.30 | ENTRAMBE | NM | screening | non scegliibile (la cella del metodo perde in OOS), certificato 2/5 | no senza tesi nuova |
| 17 | `ABTG_Cycle` | NASUSD M30 (R148a/bL/bS) | [T] 100k | n.d. (CSV non in repo) | n.d. | - | NM | NM | - | NON MISURATO in repo; R148a/bL/bS GIRATI (6 notti, exit 0) | si' (leggere i CSV: 0 min) |

### 1.2 Una riga per cella (o gruppo di celle di UNO stesso round con la STESSA classe)

Dichiaro per ogni round **la riga dell'asse usata** e **scorro tutte le righe** nei due versi (classe 1127). `INV` = SEGNO INVERTITO. Nomi dei round: `Rxxx` = prova nel repo; file: vedi sez. 4 (campo 13).

| id | EA | cella | classe | aff. | dato | PF IS / OOS | n IS / OOS | DD IS / OOS | fonte e note |
|---|---|---|---|---|---|---|---|---|---|
| C01 | CRT | NASUSD M15, 30 celle (WickFactor x MidGate x Side), tick | SOTTO | C/B | T | IS 0,43-0,66 / OOS 0,47-0,73; meno peggio 0,656 / 0,726 | 222 / 276 deal (meno peggio) | 13,7 / 12,8% | `REFERTO_CRT_2026-08-30` r.14-27 `[DICHIARATO]`; 0/30 sopra 1 in IS e OOS |
| C02 | CRT | NASUSD M15 gated ADX(D1)<=30, tick, s.OOS | SOTTO | B | T s.OOS | 0,459 | 1460 deal | 67,2% | `REFERTO_CRT` sez. "VERDETTO TICK DEL GATED" `[DICHIARATO]`; DIAG ungated 0,462, n 2039, DD 76,5% |
| C03 | CRT | NASUSD_EXT M15 OHLC 2020-24, 30 celle | SOPRA-scr | - | E s.OOS | 13/30 con PF >= 1; cella robusta 1,18 | 320 deal | 5,9% | `REFERTO_CRT` agg. TIEBREAKER `[DICHIARATO]`; **17/30 sotto 1** (SOTTO-scr nello stesso round) |
| C04 | CRT | NASUSD_EXT M15 gated ADX<=30, 20 celle, s.OOS | SOPRA-scr | - | E s.OOS | picco 1,92 (AdxMax 25), centro 1,65 (30) | 147-201 | 2,09-2,60% | `REFERTO_CRT` sez. "GATE DI REGIME MISURATO" `[DICHIARATO]`; non confermato a tick (C02) |
| I01 | IBRetest | U30USD M30 | SOTTO | C | T | 0,382 / 0,697 | 42 / 53 | 7,38 / 7,61% | CSV `risultati_prove/ABTG_IBRetest/ABTG_IBRetest_U30USD_{IS,OOS}_P0_IBRETEST.csv` (2 righe, gemelle per magic), 10k |
| I02 | IBRetest | NASUSD M30 | SOTTO | C | T | 0,563 / 0,593 | 35 / 49 | 5,80 / 5,31% | CSV `risultati_prove/ibretest_p0/..._P0IBRTNAS.csv` |
| I03 | IBRetest | D30EUR M30 | SOTTO (OOS) | C | T | 1,211 / 0,965 **INV** | 58 / 107 | 2,80 / 5,25% | CSV `risultati_prove/ibretest_p0/..._P0IBRTDAX.csv`; IS sopra 1 con n 58 (C), OOS sotto 1 |
| I04 | IBRetest | famiglia 3 simboli (pooled da me) | SOTTO | C per cella | T | IS 0,7356 / OOS 0,8124 / tutto 0,7798 | 135 / 209 / 344 | n.d. (non sommabile) | **RICALCOLATO da me** da profitto e PF di 6 righe: coincide col referto (6.273,89 / 8.046,02) |
| L01 | LVNArbitro | U30USD M30, 10k | SOPRA formale, INV | B | T | 0,979 / 1,051 | 392 / 618 | 18,01 / 11,33% | CSV `ABTG_LVNArbitro_U30USD_{IS,OOS}_P0CONTA.csv` |
| L02 | LVNArbitro | U30USD M30, 100k | SOPRA formale, INV | B | T | 0,975 / 1,052 | 392 / 618 | 19,35 / 11,76% | CSV `..._P0_100K.csv`; peggior giornata IS -2,47% (10k) / -2,80% (100k), OOS 100k -2,45% (`P0_LVNARBITRO` r.19, r.100-107) |
| O01 | OpeningReversalB | U30USD M5, 11 passate IS + 11 OOS | NM | D | T | IS 1,826 su n 2; 3,562 su n 3; PF n.d. su n 1 (1 vincita, 0 perdite) / OOS n.d. | IS 1-3 / OOS 0 | IS <= 0,96% / 0 | 8 CSV, 22 righe lette: **OOS Trades=0 su 11 righe su 11** |
| N01 | OutOfNoise | NASUSD M15, 3 celle (00_nudo, 01_long, 02_short) | NM | - | T | n.d. | 0 / 0 | - | `REFERTO_PASSO0_OUTOFNOISE_2026-08-29` (v1.00 e v1.01: **tutte e due n=0**) |
| Y01 | NySessionRetest | U30USD M15 nudo (gate OFF), s.OOS | SOTTO-limite (PF 1,002) | C | T s.OOS | 1,002 (sl5) / 0,95 (sl7) | 625 deal / 462 pos | 12,87 / 14,5% | `REFERTO_NYRETEST_2026-08-31` v5 `[DICHIARATO]`; 1,002 e' SOPRA formale, 0,95 SOTTO |
| Y02 | NySessionRetest | slope 15/30 | SOPRA e SOTTO | C | T s.OOS | 15: 1,02 / 1,01; 30: 0,99 / 1,03 | 449 / 295 deal | 9,8 / 5,9% | idem; **0,99 (slope 30, sl5) e' una cella SOTTO** |
| Y03 | NySessionRetest | slope 45 / 60 | SOPRA | C | T s.OOS | 45: 1,174 / 1,166; 60: 1,137 / 1,195 | 211 / 160 deal | 5,8 / 5,6% | idem |
| Y04 | NySessionRetest | slope 75 / 90 | SOPRA | C | T s.OOS | 75: 1,374 / 1,427; 90: 1,248 / 1,280 | 115 / 75 deal (~85 / ~55 pos) | 3,7 / 2,2% | idem; n sotto 150 -> MERITO SOSPESO |
| Y05 | NySessionRetest | U30USD H1 | NM (zero trade per costruzione) | - | T | n.d. | 0 | - | geometria: nessuna barra H1 di seduta puo' entrare |
| D01 | DaxReEntry | D30EUR M5 long, break 20/30/40, 6 celle | SOPRA | C | T s.OOS | 1,159 (break 20) · 1,25-1,29 (30) · 1,69-1,80 (40) | 92 / 71 / 57 | 4,6 / 3,0-3,5 / 2,5-2,9% | `REFERTO_DAXREENTRY_2026-08-31` `[DICHIARATO]`; finestra unica |
| D02 | DaxReEntry | D30EUR M5 short, break 20-40 | SOTTO | C | T s.OOS | 0,38-0,54 | 45-94 | 8,8-23% | idem |
| D03 | DaxReEntry | D30EUR M5 both | SOPRA e SOTTO | C | T s.OOS | 0,67-1,03 | 102-186 | n.d. | idem; mista |
| V01 | DaxValueArea | D30EUR M15, `InpSlBufferPts` 800/2800/4800/6800 | NM | - | T | n.d. | n.d. | n.d. | R141e girato 16-20/09 (5 notti, exit 0), CSV non in repo |
| H01 | HVAncora | U30USD M30, k=1,0 | SOPRA | C | T | 1,385 / 1,921 | 22 / 31 | 3,42 / 2,06% | CSV `r141d` IS/OOS, Pass 0 (reject 5/16, ancore scadute 91/165) |
| H02 | HVAncora | k=1,5 | SOPRA (OOS 1,038 formale) | C | T | 1,783 / 1,038 | 25 / 35 | 2,45 / 3,84% | Pass 1 |
| H03 | HVAncora | k=2,0 | SOPRA | C | T | 1,619 / 1,333 | 26 / 36 | 2,15 / 2,79% | Pass 2 |
| H04 | HVAncora | k=2,5 | SOTTO, INV | C | T | 1,361 / 0,930 | 26 / 37 | 2,24 / 3,12% | Pass 3 |
| A01 | AtrExhaustVol | NASUSD M30, `InpProxMode` 1 (ATR) | SOPRA, INV | C | T | 0,972 / 1,229 | 70 / 96 | 5,69 / 4,14% | CSV `r141c` Pass 1 |
| A02 | AtrExhaustVol | NASUSD M30, `InpProxMode` 0 (PERC dell'autore) | SOTTO | B | T | 0,711 / 0,952 | 153 / 224 | 19,25 / 13,45% | CSV `r141c` Pass 0; NO PER RISCHIO |
| A03 | AtrExhaustVol | R109: 6 celle M15 (3 indici x 2 lati), s.OOS, floor spento | SOTTO | B | T s.OOS | 0,831-0,978 | 655-927 | 44,1-67,8% | **RICALCOLATO da me** dai 6 per-trade `R109_deal_anomali` (n, profitto, PF al centesimo come nel referto) |
| M01 | IntradayMomentum | NASUSD M30 L+S, R141a Pass 0 | SOPRA, INV | B (OOS) | T | 0,609 / 1,243 | 146 / 261 | 7,76 / 3,03% | CSV `r141a` (100k, 0,65%) |
| M02 | IntradayMomentum | NASUSD M30 secondo segnale, R141a Pass 1 | SOPRA, INV | C | T | 0,463 / 1,486 | 71 / 133 | 5,65 / 1,37% | idem |
| M03 | IntradayMomentum | U30USD M30 L+S, R141b Pass 0 | SOPRA formale, INV | B (OOS) | T | 0,599 / 1,035 | 146 / 261 | 6,42 / 4,41% | CSV `r141b` |
| M04 | IntradayMomentum | U30USD M30 secondo segnale, R141b Pass 1 | SOPRA, INV | C | T | 0,461 / 1,250 | 76 / 130 | 5,36 / 1,79% | idem |
| M05 | IntradayMomentum | NASUSD M5, R98 `a` (no overnight) | SOTTO, INV | B | T | 1,22 / 0,80 | 165 / 261 | n.d. / 9,4% | `R98_REFERTO` `[DICHIARATO]` (100k, 1%) |
| M06 | IntradayMomentum | NASUSD, solo SHORT (R98 diag) | SOTTO | C | T | 0,37 / 0,92 | n.d. / n.d. (R235: 61 / 120) | n.d. | `R98_REFERTO`; R235 NASUSD short OOS -986,89 su n 120 `[DICHIARATO]` |
| M07 | IntradayMomentum | NASUSD, solo LONG (R98 diag) | SOPRA, INV | C | T | 0,78 / 1,54 | n.d. (R235: 85 / 141) | n.d. / 2,0% | idem; R235 NASUSD long OOS +7.687,72 |
| M08 | IntradayMomentum | U30USD, short / long (R235) | SOTTO (short) / SOPRA (long) | C | T | n.d. | IS 70 / 76 · OOS 123 / 138 | n.d. | `REFERTO_13_ROUND` `[DICHIARATO]`: OOS short -1.352,36, long +2.434,37 |
| S01 | LiquiditySweep | EURJPY (struttura M30-H4) x 3 swing, 30 passate | SOTTO-scr | B-scr | B | 0,65-0,80 (tutte) | 149-3641 | 27-99,9% | `R95_REFERTO` `[DICHIARATO]`, OHLC, 10k 1% |
| S02 | LiquiditySweep | GBPUSD M15 nudo (R89a), struttura H4 | SOPRA formale | D | T | 0,232 / 1,057 | 14 / 24 | 7,74 / 5,87% | CSV `r89agbp` (2 righe gemelle) |
| S03 | LiquiditySweep | GBPUSD M15 finestra Londra (R89b), 9 celle | SOPRA e SOTTO | D | T | IS 0,00 (n 1-4, solo perdite) / OOS 1,392 / 1,392 / 1,391 (n 9), 0,940 (n 4), 0,00 (n 2) | 1-4 / 2-9 | <= 3,75 / <= 3,53% | CSV `r89bgbp` 18 righe lette: OOS 3 celle 1,392/1,392/1,391 (n 9); 3 celle 0,940 (n 4); 3 celle PF 0 (n 2) |
| F01 | FvgRetest | - | NM | - | - | - | 0 | - | mai girato, nessun referto |
| P01 | ImpulsoApertura | - | NM | - | - | - | 0 | - | mai girato |
| W01 | VolExpBreak | NASUSD e U30USD M30, `InpKStop` 1,0-2,5 | NM | - | T | n.d. | n.d. | n.d. | R145a/b girati (7 notti), CSV non in repo |
| K01 | CanaleLento | XAUUSD D1, ExitMiddle=1 (10 celle) | SOPRA-scr, INV | screening | B | IS 0/10 sopra 1 (0,843-0,987) / OOS 10/10 (1,113-2,017) | 44-112 / 66-164 | 8,2-10,2% / 5,6-14,6% [B: limite inferiore] | CSV `Notte_16-08/..._{IS,OOS}_ohlc_cl1.csv` (40 righe lette) |
| K02 | CanaleLento | XAUUSD D1, ExitMiddle=0 (10 celle) | SOPRA-scr (3/10 in OOS) e SOTTO-scr (7/10 in OOS) | screening | B | IS 2/10 sopra 1 (0,607-1,123) / OOS 3/10 (0,856-1,100) | 29-75 / 47-116 | 5,5-9,8% / 6,9-15,3% [B] | idem; **cella del metodo 20/20/0: IS 1,123 n 49 -> OOS 0,976 n 86** |
| X01 | Cycle | NASUSD M30 | NM | - | T | n.d. | n.d. | n.d. | R148a/bL/bS girati (6 notti), CSV non in repo |

---

## 2. CONTEGGI (verificati con script; EA, non celle)

Regola del piano 5.1: un EA sta in SOPRA se ha **almeno una cella SOPRA**, in SOTTO se ne ha **almeno una SOTTO**, in NM se **non ha nessuna cella con un PF di riferimento**. Un EA puo' stare in due liste. Unita': **17 EA**.

| lista | **(A) con screening `[B]/[E]`** | **(B) solo tick `[T]`** | quali (A) |
|---|---:|---:|---|
| **SOPRA** (almeno una cella) | **9** | **7** | LVNArbitro · CRT_TurtleSoup (-scr [E]) · NySessionRetest · DaxReEntry · HVAncora · AtrExhaustVol · IntradayMomentum · LiquiditySweep · CanaleLento (-scr [B]) |
| **SOTTO** (almeno una cella) | **9** | **8** | IBRetest · CRT_TurtleSoup · NySessionRetest · DaxReEntry · HVAncora · AtrExhaustVol · IntradayMomentum · LiquiditySweep · CanaleLento (-scr) |
| in **entrambe** | **8** | **6** | CRT · NySession · DaxReEntry · HVAncora · AtrExhaustVol · IntradayMomentum · LiquiditySweep · CanaleLento |
| solo SOPRA | 1 | 1 | LVNArbitro |
| solo SOTTO | 1 | 2 | IBRetest (A) · IBRetest + CRT_TurtleSoup (B) |
| **solo NON MISURATO** | **7** | **8** | OpeningReversalB · OutOfNoise · DaxValueArea · FvgRetest · ImpulsoApertura · VolExpBreak · Cycle (+ CanaleLento in B) |
| controllo | 1 + 1 + 8 + 7 = **17** | 1 + 2 + 6 + 8 = **17** | |

Script: `conta.py` (modello a celle del par. 1.2, 17 EA, 2 viste); l'output coincide con la tabella. **Letture oneste da tenere accanto al conteggio**:

1. **Nessun EA di G6a ha affidabilita' A. Nessuna cella a tick SOPRA con n OOS >= 150 e IS coerente**: le uniche celle SOPRA con n OOS >= 150 sono `LVNArbitro` (n 618, **PF 1,05 e DD 11,3-19,4%: NO PER RISCHIO**, IS 0,98 = SEGNO INVERTITO) e le due `IntradayMomentum` L+S (NASUSD 1,243, U30USD 1,035; **IS 0,60 in tutte e due**, n IS 146 = quattro operazioni sotto 150). Tutte le altre SOPRA sono C o D.
2. **Le celle SOTTO con n >= 150 e dato a tick** sono `AtrExhaustVol` PERC (OOS 0,952, n 224, DD 13,45% = NO PER RISCHIO) e R109 (6 celle, n 655-927, DD 44-68%, floor spento). `IBRetest` ha n >= 150 solo se si **sommano tre simboli diversi** (famiglia 209 in OOS, ma n per cella 49-107): v. G6a-6.
3. **Sette EA su 17 sono NON MISURATO, e per TRE di loro il numero ESISTE ed e' solo irraggiungibile da qui**: `DaxValueArea` (R141e), `VolExpBreak` (R145a/b), `Cycle` (R148a/bL/bS) sono stati **girati** sul banco 50504400 (uscita 0, 5-7 notti) e i CSV non sono nel repo. Altri due sono NM per **campione vuoto** (`OpeningReversalB`: 0 operazioni OOS su 11 passate; `OutOfNoise`: n=0 anche dopo il fix) e due sono **mai girati** (`FvgRetest`, `ImpulsoApertura`). In piu' `IntradayMomentum` (R98 a-e, R235) e `LiquiditySweep` (R95) hanno round girati i cui numeri stanno **solo nei referti**: vedi sez. 3-bis.
4. **Regimi**: sui tick BCM il regime e' uno (rialzo). L'unica prova di regime a barre dei 17 e' `CRT` su `NASUSD_EXT` 2020-2024 (crollo / toro / orso / 2023: **screening [E], mai a tick**) e `CanaleLento` su 17 anni di oro D1 ([B]). Il resto: **regimi superati = NON MISURATO**, mai stimato.
5. **CONTESE (regola 1126/5.2.6): 0.** Per nessuna cella esistono due OOS >= 150 pos da parti opposte di 1. Esiste **un'ambiguita' di taglio, dichiarata**: `IntradayMomentum` NASUSD ha tre misure dello stesso config con IS n 146 (R141a), 148 (R98 tabella), 149 (R98 canarino) e OOS n identico 261 (R98 su M5, R141a su M30): non e' una contesa di segno (tutte IS < 1 e OOS > 1).

---

## 3. D5 (e D12) RISOLTI, E RICONCILIAZIONI FRA FONTI

### 3.1 D5 - `IntradayMomentum` e `DaxValueArea`: due verdetti "che sono due cose"

**Verificato in `prove/`, `CODA.txt`, referti runner, `dal_vps/`, `REGISTRO_TEST.md`.** R141a-e **sono girati**. Il conflitto fra le date nasce da **quattro documenti che si guardano a vicenda senza guardare l'archivio**.

| punto | 09/09 (censimento) | 12/09 (`I_QUATTRO_INVISIBILI`) | cosa dicono davvero i file |
|---|---|---|---|
| `IntradayMomentum`: "OOS 0/6" | `CENSIMENTO_SCARTATI_PROSA` A77: *"0/6 celle, COSTO C3 -0,31 pt/op"* | *"NON ANCORA MISURATO, zero CSV, zero righe di registro"* | **Entrambe le frasi hanno un pezzo falso.** (1) Il "0/6" di R98 (23/08) e' **0 celle che passano i cancelli firmati** (S0 impossibile: netto medio per operazione -0,31 punti su 410 operazioni), **non** "0 celle con PF OOS sopra 1": nelle 6 celle di `R98_REFERTO` il **PF OOS e' >= 1 in 5 su 6** (rif 1,24 · b 1,48 · c 1,22 · d 1,24 · e 1,24; solo `a` fa 0,80). Chi legge "OOS 0/6" come PF sbaglia di cinque celle. (2) "Zero CSV e zero righe di registro" del 12/09 e' falso **per l'EA** (R98 ha un referto e una riga in `REGISTRO_TEST.md` r.1245) ed e' stato vero **solo per R141a/b**, che a quella data non erano ancora girati. |
| `IntradayMomentum`: R141a/b | - | "misura proposta" | **GIRATI**: runner notturno 13-20/09, **8 notti, tutte `uscita 0`** (99-266 s a round). CSV **in repo** (`risultati_prove/dal_vps/ABTG_IntradayMomentum/*_r141a|b.csv`, 4 file, 8 righe, copiati il 15/09), **letti il 13/09 alle 23:32** (`LETTURA_BACKLOG_NOTTE` r.119-120). Poi **R235** (lato ad asse, 4 file, 16 passate, `DESKTOP-H4D7CAJ`, referto `REFERTO_13_ROUND_2026-09-23`): numeri **solo nel referto**, CSV non in repo. |
| `IntradayMomentum`: oggi | `COSTO C3` | `NON ANCORA MISURATO` | **NON ANCORA MISURATO resta il verdetto giusto**, ma per una ragione **nuova e misurata**: IS 0,609 (NASUSD) / 0,599 (U30USD) su **n 146** (4 operazioni sotto 150) contro OOS 1,243 / 1,035 su n 261: **segno invertito su 4 celle su 4 e su 2 simboli su 2**. Non e' ne' "0/6" ne' "mai girato". |
| `DaxValueArea` | A105: tutte le colonne `[NON MISURATO]`, cancello `ALTRO (morto su due gambe: tick-volume su CFD + fade dei bordi R42/R60)` | *"NON ANCORA MISURATO, R141e 5 celle in coda"* | Il "morto" del 09/09 e' un **argomento per analogia** (`GIACIMENTO_DI_CASA` r.80: "su due fronti: tick-volume su CFD; fade bordi R42/R60; breakout R45 0/48"): **nessun numero dell'EA**. Un morto senza PF, n, DD **non e' un morto** (CLAUDE.md, 09/09). R141e e' stato **corretto il 15/09** (classe 347, `NOTTE_2026-09-15` r.97) e **girato 16-20/09**: **5 notti, tutte `uscita 0`, 61-92 s**. **CSV R141e non in repo** (`git ls-files` per `r141e` = 0). |

Cosa chiude D5 **per le righe del piano** (#96 `IntradayMomentum`, #93 `DaxValueArea`): `IntradayMomentum` passa da *"NON MISURATO (conflitto)"* a **ENTRAMBE, NON ANCORA MISURATO** (celle in 1.2 M01-M08); `DaxValueArea` resta **NON MISURATO ma con numero prodotto e irraggiungibile da qui** (V01).
**Perimetro, non misura**: il 21/09 ~09:29 il tester di `IntradayMomentum` su NASUSD M30 a tick reali (finestra OOS) ha inchiodato il VPS (CLAUDE.md, 21/09). Dalla foto del 05/10 (`CODA_05_foto_fresca_20261005`, solo date dei file) i per-trade `abtg_trades_ABTG_IntradayMomentum_NASUSD_784101.csv` (15,8 KB, 21/09 08:10) e `..._U30USD_784102.csv` (15,8 KB, 21/09 09:37) sono ancora in `Common\Files` del VPS: **non letti**.

### 3.2 D12 - copie `standalone/` e `trailfix_9fca63d9/`

Nessuno dei 17 EA ha una copia in `standalone/` (22 file), `trailfix_9fca63d9/` (3 `CLAU12_*` + 3 patch) o `esterni/` (elenchi letti il 05/10). **D12 non si applica a G6a.**

### 3.3 Riconciliazioni (usato il CSV, poi il referto, poi la prosa; dichiarato)

| # | punto | fonti in conflitto | decisione |
|---|---|---|---|
| R1 | **`IntradayMomentum` "OOS 0/6"** | piano riga #96 e `CENSIMENTO_SCARTATI` A77 ("OOS 0/6") contro `R98_REFERTO` tabella (OOS PF 1,24 / 0,80 / 1,48 / 1,22 / 1,24 / 1,24) | **0/6 = cancelli, non PF** (sez. 3.1). Nel mio file le 6 celle R98 sono in 1.2 (M05-M07) con i loro PF OOS: 5 SOPRA e 1 SOTTO. |
| R2 | **TF di R98**: A77 dice **M15**, `R98rif_nuda_NASUSD.txt` r.99 dice **`@PERIODO M5`**, R141a-b **M30** | A77 contro prove | **M5 in R98, M30 in R141.** Il TF del grafico e' inerte per costruzione (`ABTG_IntradayMomentum.mq5` r.57-58: *"IL TF DEL GRAFICO NON CONTA: le misure si fanno su barre M1"*) e **lo prova il dato**: OOS **n 261 identico** su M5 (R98) e su M30 (R141a). Il TF NON e' una casella (5) applicabile a questo EA. |
| R3 | **n IS di `IntradayMomentum` NASUSD**: 149 (canarino R98), 148 (tabella R98), 146 (R141a, R235) | R98 (100k, 1%, M5) contro R141a (100k, 0,65%, M30) | **NON SPIEGATO**: OOS n identico (261), IS differisce di 2-3 operazioni. Non cambia il segno. Dichiarato, non risolto (il rischio 0,65% contro 1% puo' scartare 2-3 ingressi per lotto minimo, ma non e' provato). |
| R4 | **`CRT_TurtleSoup` "CHIUSO 31/08" e "sepolto"** | `REGISTRO_TEST` r.863 ("CHIUSO ... senza edge a tick nel toro, gate compreso") contro `REFERTO_CRT` ("PARCHEGGIATO come candidato-chop", "si riapre SOLO con tick del regime range") e `I_BOCCIATI_HANNO_UN_CERTIFICATO` §4.b | **Non e' un morto**: certificato 2/5 (manca uscita, gemelli a tick, TF). Il 31/08 ha dato un verdetto tick **nel toro**, non nel regime del motore. |
| R5 | **`OutOfNoise`: "corretto in v1.01/v1.02 e MAI RIGIRATO"** (A109, piano riga #90) e *"passo 0 mai corso"* (`CENSIMENTO_CASELLE_VUOTE` r.176) | `REFERTO_PASSO0_OUTOFNOISE` sez. "AGGIORNAMENTO 29/08 ore 23:02" (git: `e9b607b3`) | **Falso a meta'**: il passo 0 **e' corso** il 29/08 17:38 (v1.00, n=0 su 3 celle) **e di nuovo alle 23:02 con la v1.01** (fix del `need` del cono): **ancora Trades=0 su 3 celle su 3**. Il fix non era la causa. Solo la **v1.02** (14 contatori per-cancello) **non e' mai girata**. |
| R6 | **`AtrExhaustVol` "6 celle OOS 0,83-0,99 su n 655-927"** (piano riga #95) | `CENSIMENTO_SCARTATI` A59-A64: `[FINESTRA UNICA]`; `R109_REFERTO`: finestra **2024.09.26 -> 2026.08.21** | **Non c'e' OOS**: R109 e' **una finestra sola** e **non** finisce il 30/06/2026 ma il 21/08. Le 6 celle sono **s.OOS**. **Riprodotte da me** dai 6 per-trade `R109_deal_anomali` (4.952 deal: n, profitto e PF coincidono con il referto, sez. 7). |
| R7 | **`NySessionRetest` e `DaxReEntry`: "OOS"** (piano righe #91-#92: *"slope 75 OOS 1,37-1,43"*, *"long OOS 1,69-1,80"*) | `CENSIMENTO_SCARTATI` A46-A49: `[FINESTRA UNICA]`; `REFERTO_NYRETEST`/`REFERTO_DAXREENTRY`: una sola finestra 2024.09.26 -> 2026.06.30 | **Non c'e' OOS**: PF su **finestra piena**, e la cella "migliore" (slope 75; break 40) e' **scelta sullo stesso campione** (il PF sale entrando nel bordo dello sweep). Le classi sono **s.OOS**, affidabilita' C al piu', e **mai** "OOS". |
| R8 | **`CanaleLento` "n=20"** e **"1.768 trade OOS"** | `CACCIA_STOP_STRUTTURALE` r.384 (*"PF IS 0,87 / OOS 1,10 su n=20"*), `REFERTO_ROUND63_64` (*"1.768 trade OOS"*), `CENSIMENTO_PF_MISURATI` r.400 (colonna `n` = 20) | **"20" = 20 CELLE**, non 20 operazioni; **1.768 = somma sulle 20 celle** (47-164 per cella, ricalcolato da me); **0,87 / 1,10 = mediane di 20 celle**, non una cella. Il piano riga #101 ("1 riga (XAUUSD) con n<100") e' cosi' **anche sbagliato in n**: 29-112 IS, 47-164 OOS. |
| R9 | **`LiquiditySweep` "R95b-e mai lanciati"** | `CENSIMENTO_CASELLE_VUOTE` r.162, r.404 (*"i 4 file prova R95b-e esistono gia' e sono VERDI"*) contro `R95_REFERTO` (23/08: *"tutti e 5 i timeframe (M30, H1, H2, H3, H4), tutte e 3 le celle per timeframe, in IS E in OOS": 30 passate*) e `R95b_liqsweep_h1_EURJPY.txt` r.11-12 (*"UNO DEI CINQUE GRADINI DELLA STESSA SCALA: R95a = M30 ... R95e = H4"*) | **L'asse TF-struttura E' stato girato** (30 passate, 0/30). L'intestazione "NON SI LANCIA FINCHE' R95_CRITERI NON E' FIRMATO" dei file prova e' **rimasta da prima della firma**; il censimento del 22/09 non cita `R95_REFERTO` su questo punto (non so se l'abbia letto: `[NON VERIFICATO]`). La casella (5) e' **chiusa per la struttura** (TF del segnale resta M15). |
| R10 | **`HVAncora` "attesa NON RAGGIUNGIBILE, ~zero operazioni a k=1,0"** | `I_QUATTRO_INVISIBILI` r.25-30 contro `LETTURA_BACKLOG_NOTTE` §4 e CSV `r141d` | **Smentita dal dato**: a `InpStopAtr`=1,0 il motore fa **22 (IS) e 31 (OOS) operazioni** e ne rifiuta per costo 5 e 16 (Reject): il cancello interno **non era il tappo**. Il tappo e' un altro: **91 ancore IS e 165 OOS scadono** senza convertirsi. |
| R11 | **`FvgRetest` TF "M15 (H4 in un'altra fonte)"** | A119; `GIACIMENTO` r.71 ("H4") | **M15**: tre file prova su tre hanno `@PERIODO M15`, D30EUR. L'"H4" e' `InpRegimeHTF = PERIOD_H4` (il TF di lettura delle EMA, default dell'autore, r.179 del sorgente), non il TF operativo. |
| R12 | **modello dei P0 di settembre** (`IBRetest`, `LVNArbitro`, `OpeningReversalB`) marcato `[NON VERIFICATO]` in `CHI_ALTRO_PUO_SCHIERARSI` r.439-448 | `REFERTO_ROUND_*.txt` in repo, riga `modello : 4 (tick reali)`, `periodo`, `deposito` | **VERIFICATO**: i **9** referti `REFERTO_ROUND_*.txt` in repo (IBRetest x3, LVNArbitro x2, OpeningReversalB x4) dicono tutti **`modello : 4 (tick reali)`, `da quando : 2024.09.26`**, periodo M30 (IBRetest, LVN) o M5 (OpeningReversalB), deposito 10.000 salvo `P0_100K` (100.000). Le classi `[T]` di IBRetest/LVN/OpeningReversalB sono quindi fondate. |
| R13 | **costo del lotto R141a-e**: `REGISTRO_TEST` ("quattro EA invisibili R141a-e = 5,16 minuti", piano sez. 6) | referti runner: mediane per round **R141a 190 s, R141b 117 s, R141c 223 s, R141d 172 s, R141e 87 s** (somma **789 s = 13,2 min**; min-max 61-308 s) | **La stima 5,16 min era una formula** (T = 0,6 + 0,077 x N); sul banco VPS il costo misurato e' ~2,5 volte. Per le stime di sez. 5 uso le **mediane misurate**, sul banco VPS (la velocita' del PC di backtest e' `[NON MISURATA]`). |

---

## 3-bis. ROUND DI G6a GIRATI O SCRITTI, MA SENZA CSV IN REPO

Fonte: `backtest_pipeline/coda/referti/REFERTO_RUNNER_*.txt` (righe `-Etichetta ... ESEGUITO in Ns, uscita C`; contate da me con script), `CODA.txt`, `IL_TRASPORTO_E_FERMO_2026-09-17`. Codici (`RIGA_SOTTILE_ROUND.ps1` r.88-91): **0 = ROUND GIRATO, CSV freschi con operazioni** · 2 = NON MISURATO · 3 = girato con rilievi. Tutti i round sotto sono `uscita 0` **in ogni notte**; il runner ha riesecuto lo stesso round ogni notte finche' e' rimasto in coda (la coda e' sospesa dal 21/09). **Non ho letto nessun numero**: i CSV stanno sul VPS (`abtg_round\risultati_prove`) e non sono mai entrati nel repo (trasporto fermo dal 13/09).

| round | EA - simbolo TF | asse | notti runner (uscita) | durata mediana | esito per il resoconto |
|---|---|---|---|---:|---|
| R141e | DaxValueArea D30EUR M15 | `InpSlBufferPts` 800/2800/4800/6800 | 5 (16-20/09), tutte 0 | 87 s | **GIRATO, CSV NON IN REPO**: 8 passate; le celle 800 e 2800 erano **pre-dichiarate non promuovibili per costo** (4,7x e 16,5x, `REGISTRO_TEST` r.3295) |
| R145a | VolExpBreak NASUSD M30 | `InpKStop` 1,0-2,5 | 7 (14-20/09), tutte 0 | 328 s | **GIRATO, CSV NON IN REPO** (`IL_TRASPORTO_E_FERMO` r.60) |
| R145b | VolExpBreak U30USD M30 | `InpKStop` 1,0-2,5 | 7 (14-20/09), tutte 0 | 193 s | idem |
| R148a | Cycle NASUSD M30 | `InpVerso` (2 celle) | 6 (15-20/09), tutte 0 | 257 s | **GIRATO, CSV NON IN REPO** (`IL_TRASPORTO_E_FERMO` r.52) |
| R148bL | Cycle NASUSD M30 | lato long | 6 (15-20/09), tutte 0 | 258 s | idem |
| R148bS | Cycle NASUSD M30 | lato short | 6 (15-20/09), tutte 0 | 258 s | idem |
| R148g | Cycle NASUSD M30 | minimo locale (verso) | **non in coda** | - | scritto, **mai girato** |
| R98 a-e, rif, diagNoLong/Short | IntradayMomentum NASUSD M5 | 6 celle + 2 diagnostiche + slippage | 23/08, 32 passate | 0,3 h | **GIRATO**, numeri **solo in `R98_REFERTO`** (tabella par. 1.2 M05-M07); nessun CSV in repo |
| R235a-d | IntradayMomentum NASUSD/U30USD M30 | lato (L+S / solo L / solo S) | `DESKTOP-H4D7CAJ`, 133 min per 13 round | - | **GIRATO**, numeri **solo in `REFERTO_13_ROUND_2026-09-23`**; nessun CSV in repo |
| R95 a-e | LiquiditySweep EURJPY M15 | struttura M30..H4 x 3 `InpSwingBars` | 23/08, 30 passate | - | **GIRATO**, numeri **solo in `R95_REFERTO`** (OHLC) |
| R109 (6 file) | AtrExhaustVol 3 indici x 2 lati M15 | nessuno (6 celle, 1 per lato) | 25/08 | 17 min | **GIRATO**; **riprodotto da me** dai per-trade `R109_deal_anomali` (le tabelle OPTFRAME non sono in repo) |
| P0 CRT (6 corse) | CRT NASUSD M15 tick e `_EXT` | vedi scheda 4.1 | 30-31/08 | - | **GIRATI**; numeri **solo in `REFERTO_CRT_2026-08-30`**; 4 corse su 6 "mai partite" (classe skip-senza-Rifai) e invalidate |
| NySessionRetest (3 corse) | NY Retest U30USD H1/M15 | gate slope | 31/08 | - | **GIRATI**; numeri **solo in `REFERTO_NYRETEST_2026-08-31`** |
| DaxReEntry | D30EUR M5 | `InpBreakPts`, `InpSlFracRange`, `InpSide` | 31/08 | - | **GIRATO**; numeri **solo in `REFERTO_DAXREENTRY_2026-08-31`** |
| R140a / R140b | ImpulsoApertura D30EUR / U30USD M30 | `InpMagic` (tecnico) | **non in coda, non nei referti runner** | - | scritti (12/09), **mai girati** (`APERTURE_DAX_MAPPA` r.116: *"round mai girato"*) |
| A1_DAXREENTRY_M1_00_long | DaxReEntry D30EUR **M1** | gemelli magic, TF | **non in coda** (0 occorrenze in `CODA.txt`) | - | scritto 09/09, **mai girato** |
| A1_NYRETEST_NASUSD_00_nudo | NySessionRetest NASUSD M15 | nudo | **non in coda** | - | scritto, **mai girato** |
| NOISE_M30_D30EUR_ancora / _NASUSD_gemello | OutOfNoise M30 | `InpSlMode` | **non in coda** | - | scritti (12/09), **mai girati** |
| PASSO0_FVGRET_01_long / 02_short | FvgRetest D30EUR M15 | lato | **non in coda** | - | scritti (28/08), **mai girati**; nessun referto |
| R89a / R89b | LiquiditySweep GBPUSD M15 | nudo / finestra Londra | 23/08 | - | **CSV IN REPO** (4 file, 22 righe): letti per intero |

**Conteggio dei round "girati e senza CSV in repo" (solo quelli con un'etichetta runner)**: **R141e, R145a, R145b, R148a, R148bL, R148bS = 6 etichette**, in **5-7 notti ciascuna** (esecuzioni notturne dichiarate `uscita 0`, contate da me nei referti: R141e 5 + R145a 7 + R145b 7 + R148a 6 + R148bL 6 + R148bS 6 = **37**). Piu' **i round pre-runner con numeri solo in referto** (R98, R95, R235, i P0 di CRT/NY/DaxReEntry, R109 OPTFRAME) e **9 file prova scritti e mai girati** (R148g, R140a, R140b, A1_DAXREENTRY_M1, A1_NYRETEST_NASUSD, NOISE_M30 x2, PASSO0_FVGRET x2: vedi tabella).

**Un dato che la foto del banco aggiunge (inferenza, non referto)**: i `Common\Files` del VPS al 05/10 portano per-trade datati **21/09** per `AtrExhaustVol` (08:04), `HVAncora` (08:07), `IntradayMomentum` (08:10 e 09:37), `VolExpBreak` (10:00-10:03), `Cycle` (12:37), `DaxValueArea` (13:31): il giro notturno del **21/09 ha quindi riesguito questi round** fino alle ~14:00 (poi l'ultimo giornale del banco e' 21/09 14:51), ma **il `REFERTO_RUNNER` del 21/09 non e' in repo** (l'elenco salta dal 20/09 al 23/09). `[DEDOTTO dalle date dei file; non verificato da un referto]`. E' coerente con l'incidente del 21/09 e con la sospensione della coda.
