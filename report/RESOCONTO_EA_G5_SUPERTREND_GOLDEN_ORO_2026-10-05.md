# RESOCONTO EA - GRUPPO G5: SUPERTREND REVERSAL + GOLDENCROSS + ORO ESTERNI (FASE 2, ONDATA 2) - 05/10/2026

> **DOCUMENTO INTERNO. NON ESCE. Non e' stato mandato a nessuno. Non e' passato dal cancello (`controllo-preventivo`): serve il passaggio
> prima di qualunque uscita verso Claudio.** Piano: `report/RESOCONTO_EA_PIANO_2026-10-05.md` (sez. 4 'G5', sez. 5 regola, sez. 6 scheda, sez. 7 'GRUPPO G5', sez. 8 dubbi).
> Richiesta di Claudio (05/10/2026): per ogni EA con PF sopra 1 e sotto 1, **che backtest e' stato fatto, che anni, che regimi, se e' migliorabile e cosa serve**.
> Perimetro: le **19 righe / 25 file** di G5 (11 SupRev + 3 GoldenCross + 4 copie `standalone/` + 7 oro esterni).
> **Sola lettura d'archivio.** Nessun round lanciato, nessun EA/preset/magic/sedia toccato, nessuna taglia proposta. Il forward citato e' **solo demo**
> (piccolo 50503392 = `data/statements/trades_auto.csv` fino al 02/10/2026; 100k 50504263 = `trades_100k.csv` fino al 24/09/2026), in una colonna a parte.
>
> **Etichette.** `[T]` tick reali BCM (modello 4) · `[B]` barre OHLC M1 BCM nativo (modello 1, **screening**: non promuove, non boccia, mai nella stessa colonna dei tick) ·
> `[E]` dati esterni (Oanda/HistData, altro broker) · `[MISURATO]` letto da CSV/referto, o ricalcolato da me (dichiarato) · `[DERIVATO]` calcolo mio su numeri scritti ·
> `[DICHIARATO]` scritto in una fonte, non riaperto · `[NON RIPRODOTTO]` il numero e' scritto ma nessun CSV in repo lo contiene · `NM` = NON MISURATO.
> **n = deal di uscita** (colonna `Trades` dell'OPTFRAME) **salvo dove scritto "pos"**: la famiglia SupRev/GoldenCross ha il parziale al 50% (`InpTP1Pct=50`) e **non ha un per-trade**
> (su `SupRev_DAX_H4_Ott` ne' la strada: `ExportTrades()` assente, `REFERTO_DRIVER_R110` r.38), quindi il **fattore deal/posizioni e' NON MISURATO** (in casa 1,00-2,31; EMA200 U30USD 2,01).
> **Affidabilita'** (piano 5.4) calcolata in **posizioni**: dove ho solo deal scrivo la **forbice** (deal/2,31 .. deal): n deal < 30 = D; 30-69 = D/C; 70-149 = C; 150-345 = C (B solo se il fattore fosse ~1); >= 346 = B.
> **Nessuna cella di G5 ha affidabilita' A** (nessuna ha >= 2 regimi misurati a tick con n OOS >= 150 pos): su tick BCM il regime e' **uno** (rialzo 2024-26).
> **Finestre standard** (salvo scritto): tick 2024.09.26 -> 2026.06.30, taglio 40/60: **IS 2024.09.26-2025.06.09, OOS 2025.06.10-2026.06.30** (~12,7 mesi); vale anche per l'oro
> (le celle FASE 0 dell'oro riproducono al centesimo le celle R2/R3 che dichiarano `@DAQUANDO 2024.09.26`, `REFERTO_ROUND2/3`). Forex tick BCM: dal 2024.07.05.
> **Rischio per trade**: 1% salvo scritto. **I CSV TF-scan dell'oro `_Ottimizzato` e `_Multi_Ottimizzato` sono a rischio 2%** (`InpRiskPercent=2` letto nei CSV: default del sorgente); `CLASSIFICA_PF.md` scrive "rischio 1%" per le stesse celle.

---

## 0. TABELLE RIASSUNTIVE

### 0.1 Come leggere (le regole che questo file si impone, dai cancelli G1-G3)

1. **Ogni round citato e' letto riga per riga, nei due versi**: dove una cella sta sopra e un'altra riga dello stesso round sta sotto, **tutte e due** compaiono nella tabella 0.3 (classi 1126/1127).
   Le righe **TF-scan a tick** (11 TF per file) e gli assi (`InpStMult`, `InpStAtrPeriod`, `InpNearAtr`, `InpSLBufferPips`, `InpAdxMin`) sono in tabella, raggruppati per classe.
   **Fuori tabella, dichiarati**: gli scan **OHLC [B] a finestra unica** (`SupertrendReversal/H1_OHLC`, `H4_OHLC`, `GoldenCross/H1_OHLC`, `H4_OHLC` su ~40-48 simboli: nel censimento 09/09 118 e 113 righe; `SupRevScr_*` 10 CSV) e i TF-scan **[B]** senza gemello a tick
   (`SupertrendReversal` D30EUR, `SupRev_CAC_H4` F40EUR): screening, citati nelle schede con i conti, **non letti cella per cella** `[NON VERIFICATO]`.
2. **Una "mediana" non e' una cella** (piano 5.1). Tutti i "PFmed" del censimento 09/09 su questa famiglia sono **mediane sulle 11 righe TF (o sulle 5 righe StMult)**, non celle: vedi **D4 risolto** (sez. 4).
3. Due misure della stessa cella da parti opposte di 1 con OOS >= 150 ciascuna = CONTESA (classe 1126). **In G5 non ce ne sono**: dove una cella ha piu' misure (SupRev NAS H1, SupRev DOW H1, SupRev DAX H4) stanno **tutte dalla stessa parte di 1**; le cifre diverse sono elencate (binari diversi, depositi diversi: difetto M45 non isolato).
4. **SEGNO INVERTITO** = IS e OOS da parti opposte di 1 (`INV` in tabella): su questa famiglia e' **frequente** (19 righe su 91, vedi sez. 4, D14).
5. **Il forward non classifica.**

### 0.2 Tabella per EA (19 righe; "celle" = righe della tabella 0.3)

| # | EA (file) | celle SOPRA / SOTTO / NM (tab. 0.3) | cella di contratto o piu' avanzata | classe + aff. + dato | PF IS / OOS (n IS / OOS deal) | regimi superati | verdetto di casa | migliorabile? |
|---:|---|---|---|---|---|---|---|---|
| 1 | `ABTG_SupertrendReversal` | 14 / 13 / 1 | NASUSD H1 L+S (770925, nativa); XAG/DAX/Nikkei H4 long-only (preset FW) | SOPRA · C · `[T]` (NASUSD H1) | 1,079 / 1,387 (53 / 85) | solo il rialzo BCM (21 mesi) | MERITO SOSPESO; costo H1 NASUSD ESCLUSO PER COSTO (stima di famiglia 28,7x); oro H4 default SOTTO | si' (misure mancanti, non parametri) |
| 2 | `ABTG_SupertrendReversal_Ottimizzato` (970901) | 5 / 1 / 0 (di cui 2 righe [B]) | oro H4 L+S, rischio 2% nel CSV | SOPRA · D · `[T]` | 4,752 / 2,253 (22 / 30) | solo il rialzo oro 2024-26; 22 anni [B]: IS 2004-13 sotto 1, OOS 2013-26 sopra (INV) | MERITO SOSPESO + PICCO su TF (vicini H3/H6/H2 sotto 1); 2,74 NON RIPRODOTTO | si' (G0 oro + zip R99) |
| 3 | `ABTG_SupertrendReversal_Multi` (771001) | 1 / 2 / 0 | oro H4 L+S default | SOTTO · D · `[T]` | 0,709 / 0,686 (15 / 14) | -- | SOTTO 1, non ancora morto (casella 3 vuota) | si', ma l'ottimizzata e' il suo sostituto |
| 4 | `ABTG_SupertrendReversal_Multi_Ottimizzato` (971001) | 6 / 2 / 0 | oro H4 L+S, rischio 2% nel CSV | SOPRA · D/C · `[T]` | 4,506 / 2,907 (33 / 49) | solo il rialzo oro 2024-26 | MERITO SOSPESO + PICCO; **DD 22 anni 16,90% a 1%: NO PER RISCHIO a 1%** | si' (ma rischio) |
| 5 | `ABTG_SupRev_DAX_H4_Ottimizzato` (970912) | 3 / 1 / 0 | D30EUR H4 L+S | SOPRA · D/C · `[T]` | 4,302 / 1,525 (26 / 60) | solo il rialzo (21 mesi) | MERITO SOSPESO; costo H4 NON MISURATO (27,8-184x) | si' (campione: non prima del 2027) |
| 6 | `ABTG_SupRev_NAS_H1_Ottimizzato` (970913) | 8 / 4 / 0 | NASUSD H1 L+S | SOPRA · C · `[T]` | 1,342 / 1,688 (69 / 86) | tick: solo il rialzo; `[B][E]` 2011-2022: 1 regime sopra (2011-12) e 1 sotto (laterale 2015-16) con campione, 4 finestre senza campione | MERITO SOSPESO; **ESCLUSO PER COSTO 28,7x**; DD 0,86-1,29% | **si', e' la cella piu' vicina a una sedia di G5** |
| 7 | `ABTG_SupRev_DOW_H1_Ottimizzato` (970916) | 4 / 2 / 0 | U30USD H1 L+S | SOPRA·INV · C · `[T]` | 0,923 / 1,436 (118 / 155) | solo il rialzo | PICCO su 2 assi su 3 + pettine TF; H1 costo FRAGILE (33,6-45,2x) | no, non senza una tesi nuova |
| 8 | `ABTG_SupRev_DOW_H4_Ottimizzato` (970914) | 3 / 1 / 1 | U30USD H4 L+S | SOPRA · D/C · `[T]` | 3,651 / 2,324 (30 / 49) | solo il rialzo | promozione REVOCATA 30/07: il "0,79" e' NON RIPRODOTTO | si', campione H4 non esiste |
| 9 | `ABTG_SupRev_CAC_H4_Ottimizzato` (970915) | 2 / 0 / 0 | F40EUR H4 (cella 2,5/9/2,5) | SOPRA·sOOS · C · `[T]` | -- / 1,794 (-- / 65, finestra piena) | -- | promozione REVOCATA: il "0,96" e' la mediana di 8 celle, non la cella | si' (split a tick: 54 passate, ~5 min) |
| 10 | `ABTG_SupRev_DAX_H1_Ottimizzato` (970911, spenta 11/08) | 2 / 1 / 0 | D30EUR H1 L+S | SOPRA·INV · C · `[T]` | 0,730 / 1,866 (67 / 156) | solo il rialzo | SPENTA 11/08 per IS rosso; pettine TF | no (decisione di Claudio resta) |
| 11 | `ABTG_SupertrendInvert` (770801) | 0 / 0 / 1 | tutte le 20 serie | NM | n 0-3 per cella | -- | NON MISURATO: "non opera" (n massimo 3); causa non diagnosticata | si' (diagnosi a costo ~0) |
| 12 | `ABTG_GoldenCross` (770331-33, 770301) | 6 / 2 / 0 | USDCHF/USDCAD/NZDUSD H4 (v1.00 in campo); oro H1 | SOPRA · D · `[T]` | 3,628 / 2,188 (20 / 17) USDCHF v1.00 | solo il rialzo | MERITO SOSPESO; **v2.00 (corretta) piu' debole**; 0 posizioni in forward | si', ma e' una decisione di Claudio (ricompilare) |
| 13 | `ABTG_GoldenCross_Ottimizzato` (970301) | 4 / 2 / 0 | oro H1 | SOPRA · D/C · `[T]` | 1,494 / 1,253 (32 / 57) | solo il rialzo oro; **DD 22 anni 25,18% a 1% [B]: NO PER RISCHIO a 1%** | MERITO SOSPESO; ADX 20/25 OOS sotto 1 | si' (rischio) |
| 14 | `ABTG_GoldenCross_V1` | 1 / 0 / 0 | frozen v1.00, 4 simboli | SOPRA · D · `[T]` | oro 1,494 / 1,253 (32 / 57) | -- | e' la versione IN CAMPO delle 4 sedie; non va in campo di nuovo (firma R87) | no |
| 15 | 4 copie `standalone/` | EREDITA | -- | EREDITA | -- | -- | input = sottoinsieme di quelli della root (GC: -12; ST: -5); non diffate riga per riga | -- |
| 16 | `Gold_Ichimoku_TK_ATR_EA` (250604) | 1 / 0 / 0 | XAUUSD H1 long-only, 2020-2026 | SOPRA·sOOS · B · `[B]` | PF 1,311 su 553 (nessuno split) | 4 anni su 7 negativi | **NO PER RISCHIO: DD equity 21,52% a 0,5%**; 2 trade veri persi | no (rischio) |
| 17 | `Gold_Scalper_TK_BB_BE_EA` | 0 / 0 / 1 | -- | NM | nessun CSV | -- | NON MISURATO; sorgente: "v1.10 apriva 1174 trade/anno e perdeva" `[DICHIARATO]` | non ancora misurabile |
| 18 | `IchiCross_Gold_722` · `IchiTrend_Gold_Base` | 0 / 0 / 1 | -- | NM | nessun CSV | -- | NON MISURATO; il PF 1,50 nel commento del sorgente e' `[DICHIARATO]`, non entra | non ancora misurabile |
| 19 | `ORB_GOLD_FIBONACCI_EA` · `_v3.21` · `GoldBreakout_Levels` | 0 / 0 / 1 | -- | NM | nessun CSV | -- | NON MISURATO; v2.20 e' commentata "Risk=5%" | non ancora misurabile |

### 0.3 Tabella per CELLA (una riga = EA x simbolo x TF x lato x configurazione, o un gruppo di celle di UNO stesso round/asse con la STESSA classe)

Colonne: classe (`SOPRA` / `SOTTO` / `NM`; `·INV` = segno invertito IS/OOS; `·sOOS` = finestra piena senza OOS, D3) · aff. · dato · PF IS / OOS · n IS / OOS (deal) · fonte.
Finestra standard dove non scritta altro. **Rischio 1%, deposito 10.000 per i TF-scan/round del 07-08/08 (default del driver, non scritto nei CSV), 100.000 per R110/R5/R240/R243.**

| id | EA | cella | classe | aff. | dato | PF IS / OOS | n IS / OOS | fonte e note |
|---|---|---|---|---|---|---|---|---|
| S01 | ST base | oro H4 L+S default (St 3,5/AtrP 10): TP_RR 2,0 / 2,5 / 3,0 | SOTTO | D | T | 0,337 / 0,765 · 0,414 / 0,413 · 0,498 / 0,337 | 11 / 9 | `SupRev_H4_r21/*XAUUSD*` + TF scan. **Il "nativo ~2,74" del piano NON e' questa cella** (vedi D15) |
| S02 | ST base | oro H4, R21 St 2,5 / 3,0 / 4,0 x TP 2,0-3,0 (9 celle) | SOPRA | D | T | IS 1,066-8,619 / OOS 1,066-3,415 | 5-7 / 9-28 | R21: IS "5-11 trade, non giudicabile"; 9/12 celle sopra in entrambe, le 3 a St 3,5 sotto |
| S03 | ST base | oro H3, R3 St 3,0 e 3,5 | SOPRA | D/C | T | 2,125 / 4,419 · 1,188 / 2,530 | 22 / 35 · 8 / 21 | `ABTG_SupertrendReversal_XAUUSD_*_r3.csv`; "cresta di due, mai altopiano" (`REFERTO_ROUND3` §5) |
| S04 | ST base | oro H3, R3 St 2,5 / 4,0 / 4,5 | SOTTO | D | T | 0,379 / 0,906 · 0,706 / 0,466 · 0,630 / 0,125 | 21 / 33 · 4 / 15 · 12 / 15 | idem |
| S05 | ST base | oro tick M15 M20 M30 H1 H2 H6 H8 H12 (D1 n 1-2: degenere) | SOTTO | C | T | OOS 0,952 (325) · 0,757 (224) · 0,932 (163) · 0,969 (49) · 0,488 (30) · 0,157 (7) · 0,114 (8) · 0,471 (12) | IS 168/165/96/53/23/4/2/4 | TF scan; H1 e H2 hanno IS 1,603 / 1,836 (IS>1, OOS<1) |
| S06 | ST base | XAGUSD H4 (+H3) L+S (770922: preset FW long-only) | SOPRA | D | T | H4 7,134 / 2,047 · H3 0,817 / 2,187 (INV) | 4 / 22 · 14 / 13 | TF scan; DD OOS 7,3% (10k); IS H4 n=4 |
| S07 | ST base | XAGUSD M15 M20 M30 H1 H2 H6 H8 H12 | SOTTO | C | T | OOS 0,629 (86) · 0,696 (85) · 0,552 (61) · 0,514 (31) · 0,398 (23) · 0,119 (5) · 0,426 (4) · 0,485 (5) | IS 5-14 | TF scan |
| S08 | ST base | D30EUR H4 L+S split OHLC (770923: preset FW long-only) | SOTTO | D/C | B | 4,606 / 0,843 | 20 / 45 | `ABTG_SupertrendReversal_D30EUR_*_ohlc.csv`; **non c'e' un gemello a tick** |
| S09 | ST base | D30EUR H4 tick finestra piena "PFmed 1,05, n 50" | NM | -- | T | PFmed 1,05 (mediana di celle) | ~50 | `CLASSIFICHE.md` §2 / `TICK_REALI_INDICI_H1vsH4.md`: **[NON RIPRODOTTO]** (nessun CSV), una mediana |
| S10 | ST base | 225JPY H2 (770901 Nikkei 100k), sizing corretto (R5, 100k) | SOPRA | D/C | T | 1,542 / 1,653 | 29 / 50 | `..225JPY_*_r5.csv`; DD IS 0,65 / OOS 0,88; "OOS guardata quattro volte" (`REFERTO_ROUND5`) |
| S11 | ST base | 225JPY H4 (770924 FW long-only), R5 | SOPRA | D | T | 1,356 / 1,621 | 30 / 26 | R5; il contratto 770924 dice "finestra piena, nessun OOS, n 21, DD 0,14%" |
| S12 | ST base | 225JPY R5 H1, H3, H6 (INV), H12 | SOPRA | C/D | T | 1,279 / 1,073 · 3,024 / 1,542 · 0,897 / 1,037 · 621 / 3,786 | 99/122 · 12/37 · 4/26 · 7/10 | R5; H1 OOS 1,073 su 122 (DD 2,06%): dentro il rumore (D2 non firmata) |
| S13 | ST base | 225JPY R5 H8 | SOTTO | D | T | 245 / 0,604 | 2 / 8 | R5 |
| S14 | ST base | NASUSD H1 L+S default (St 3,5/10/TP 2,0) (770925) | SOPRA | C | T | 1,079 / 1,387 | 53 / 85 | TF scan; DD 1,2 / 0,7 |
| S15 | ST base | NASUSD H1 corto, buffer 3 (R236a = R238a "spenta") | SOPRA·INV | D | T | 0,903 / 1,598 | 25 / 42 | `REFERTO_R238`/`REFERTO_13_ROUND` `[DICHIARATO]`; **CSV R236/R238 non in repo**; finestra oraria ON: OOS 3,524 su n 24 (non promuove) |
| S16 | ST base | NASUSD H1 lungo, buffer 3 (R236b = R238b) | SOTTO·INV | C | T | 1,545 / 0,948 | 44 / 76 | idem; la finestra oraria non fa niente sul lungo (0,961) |
| S17 | ST base | NASUSD tick H3 H4 H8 | SOPRA | D | T | 1,369 / 1,058 · 1,873 / 1,270 · 2,200 / 1,440 | 13/25 · 18/15 · 4/13 | TF scan |
| S18 | ST base | NASUSD tick M15 M20 M30 H2 H6 H12 | SOTTO | B/C | T | OOS 0,568 (254) · 0,792 (230) · 0,507 (141) · 0,911 (43) · 0,175 (7) · 0,000 (9) | IS 154-157/79/20/7/5 | TF scan |
| S19 | ST base | U30USD H1 corto, ancora Nasdaq 3,5/7 (R240a, finestra spenta) | SOTTO·INV | C | T | 1,094 / 0,971 | 70 / 76 | `risultati_archivio/R240/` CSV letti da me |
| S20 | ST base | U30USD H1 lungo, ancora Nasdaq 2,5/12 (R240b) | SOPRA | C | T | 1,055 / 1,330 | 95 / 114 | idem |
| S21 | ST base | U30USD H1 corto, ancora Dow 3,5/9 (R243a) | SOPRA | C | T | 1,292 / 1,643 | 68 / 78 | `risultati_archivio/R243/`; DD 3,70 / 3,34; costo 40x SOSPESO |
| S22 | ST base | U30USD H1 lungo, ancora Dow 3,5/9 (R243b) | SOPRA·INV | C | T | 0,693 / 1,206 | 62 / 90 | idem |
| S23 | ST base | GBPJPY H4 (R21/R22) St 4,0 x TP 2,0/2,5/3,0; e St 4,5 (INV) | SOPRA | D/C | T | St 4,0: 1,329-1,543 / 1,366-1,785 · St 4,5: 0,167-0,271 / 1,710-2,161 | 24/40 · 12/30 | R22 "falsificazione compiuta": crinale su una riga, non altopiano |
| S24 | ST base | GBPJPY H4 St 2,5 / 3,0 / 3,5 / 5,0 | SOTTO | C | T | IS 0,326-3,746 / OOS 0,260-0,890 | 13-70 | R21/R22; IS "forte" (2,9-3,7) e OOS tossico (16o ribaltamento) |
| S25 | ST base | AUDUSD H4, R21: 7 celle OOS >= 1 con IS < 1 | SOPRA·INV | D | T | IS 0,406-0,875 / OOS 1,067-2,106 | 19-37 / 24-31 | R21 |
| S26 | ST base | AUDUSD H4, R21: 5 celle OOS < 1 | SOTTO | C/D | T | IS 0,263-0,632 / OOS 0,736-0,965 | 19-39 / 27-55 | R21 |
| S27 | ST base | CHFJPY H4, R21 (12 celle) | SOTTO | C/D | T | IS 0,569-1,988 / OOS 0,234-0,843 | 21-52 / 14-56 | R21; IS > 1 solo a St 4,0 |
| S28 | ST base | E35EUR (IBEX) H1, R18 (12 celle) | SOTTO | D/C | T | IS 0,051-1,850 / OOS 0,427-0,923 | 7-43 / 32-52 | R18 "bocciato 0/12, 14o ribaltamento" |
| U01 | ST Ott | oro H4 L+S, cella viva (St 2,5/AtrP 7/TP 2,5), rischio 2% | SOPRA | D | T | 4,752 / 2,253 | 22 / 30 | TF scan; DD 0,79 / 2,08; **vicini H3 0,678/0,780, H6 0,531/0,568, H2 0,511/0,728: PICCO** |
| U02 | ST Ott | oro tick M15 (INV) | SOPRA·INV | B | T | 0,825 / 1,072 | 321 / 572 | TF scan; DD OOS 9,70% a 2%; M15 escluso per costo |
| U03 | ST Ott | oro tick H8, D1 | SOPRA | D | T | H8 2,526 / 2,042 · D1 n 1 / 1,221 | 15/4 · 1/8 | TF scan; campioni minuscoli |
| U04 | ST Ott | oro tick M20 M30 H1 (IS 1,316) H2 H3 H6 H12 | SOTTO | B/C | T | OOS 0,935 (420) · 0,917 (268) · 0,628 (147) · 0,728 (55) · 0,780 (35) · 0,568 (22) · 0,385 (10) | IS 270/177/77/54/27/10/7 | TF scan |
| U05 | ST Ott | **oro H4 22 anni [B], split ~2013.04** (r127b, 7 celle InpSLLookback 1-13, cella viva = 5) | SOPRA·INV | B | B | IS 0,792-0,855 / OOS 1,053-1,125 (viva 0,854 / 1,125) | 230 / 427 | `dal_vps/ABTG_SupertrendReversal_Ottimizzato/*r127b.csv`, 100k, **1%**; IS 7/7 sotto 1, OOS 7/7 sopra; DD IS 6,5-10,2 / OOS 5,9-8,4 |
| U06 | ST Ott | oro H4 6,5 anni [B], 2020.01.01-2026.06.30 (R103), 1% | SOPRA·sOOS | B | B | 1,330 (nessuno split) | 208 | `R103_REFERTO_DRIVER_FOREX_METALLI` r.1793-1850; DD 3,51%; anni 2020 -572, 2021 -2.292, 2022 +767, 2023 -200, 2024 +1.624, 2025 +4.807, 2026p +658 |
| M01 | ST Multi | oro H4 L+S default (St 3,5/AtrP 10/TP 2,0) | SOTTO | D | T | 0,709 / 0,686 | 15 / 14 | TF scan |
| M02 | ST Multi | oro tick H2, H3, M15 (INV) | SOPRA | D/C | T | H2 1,494 / 1,002 · H3 3,536 / 1,692 · M15 0,748 / 1,050 (INV) | 39/53 · 15/30 · 257/488 | TF scan; M15 OOS 1,050 su 488 |
| M03 | ST Multi | oro tick M20 M30 H1 H6 H8 H12 (D1 n 1-3: degenere) | SOTTO | B/C | T | OOS 0,767 (318) · 0,943 (226) · 0,527 (68) · 0,250 (8) · 0,497 (9) · 0,514 (16) | IS 244/152/78/6/3/6 | TF scan; M20 IS 1,087 (244) |
| O01 | ST Multi Ott | oro H4 L+S, cella viva (St 2,5/AtrP 12/TP 3,0), rischio 2% | SOPRA | D/C | T | 4,506 / 2,907 | 33 / 49 | TF scan = R3 St 2,5 (riproduce a 5 decimali); DD 3,15 / 4,50 |
| O02 | ST Multi Ott | oro H4 St 1,5 e 2,0 (R3) | SOPRA·INV | C | T | 0,496 / 1,714 (74/105) · 0,490 / 1,121 (42/75) | 74/105 · 42/75 | `*_r3.csv`: **e' la riga "OOS n 105, PF 1,71" del censimento: IS sotto 1, non e' la cella viva** |
| O03 | ST Multi Ott | oro H4 St 3,0 | SOPRA | D | T | 1,253 / 2,985 | 11 / 27 | R3; "cresta di due (2,5-3,0), il 3,0 su 11/27 trade" |
| O04 | ST Multi Ott | oro H4 St 3,5 | SOTTO·INV | D | T | 1,569 / 0,319 | 17 / 19 | R3 |
| O05 | ST Multi Ott | oro tick M30 (IS e OOS sopra) | SOPRA | B | T | 1,256 / 1,087 | 257 / 427 | TF scan; DD OOS 22,06% a 2% (~7,17% a 0,65% `[DERIVATO]`); `REGISTRO_TEST` r.2985 "PICCO: vicini M20 IS 0,709, H1 IS 0,984"; M30: `SupertrendRev_Ott` XAUUSD 18,1x a M30 (`REGISTRO_TEST` r.3005, k=0,968) = escluso per costo |
| O06 | ST Multi Ott | oro tick M15, M20 (INV) | SOPRA·INV | B | T | 0,753 / 1,143 · 0,709 / 1,010 | 511/882 · 369/594 | TF scan; DD IS M15 42,58% (a 2%): NO PER RISCHIO |
| O07 | ST Multi Ott | oro tick H1, H6 (INV), H8, D1 | SOPRA | C | T | H1 0,984 / 1,603 · H6 0,890 / 2,328 · H8 2,490 / 8,434 · D1 6.831 / 1,238 | 137/188 · 22/35 · 18/13 · 3/9 | TF scan; H1 e H6 INV; D1/H8 campioni minuscoli |
| O08 | ST Multi Ott | oro tick H2, H3, H12 | SOTTO | C | T | OOS 0,836 (72) · 0,635 (64) · 0,027 (8) | IS 68/37/11 | TF scan |
| X01 | SupRev DAX H4 | D30EUR H4 L+S (970912) | SOPRA | D/C | T | TF scan 4,302 / 1,525 (26/60) · R110 3,808 / 1,432 (31/65) | 26-31 / 60-65 | DD OOS 4,2 / 4,04; R103 [B] 21m: 2,05 (99); valid finestra piena 1,96 (86) |
| X02 | SupRev DAX H4 | D30EUR H4 lati (R110): long / short | SOPRA | D | T | 1,978 / 1,589 · 7,774 / 1,290 | 14/36 · 17/29 | R110 (CSV fuori repo, `[DICHIARATO]`); short n 29 < 30 "NON MISURABILE" |
| X03 | SupRev DAX H4 | D30EUR tick H2 (INV), H12 | SOPRA | D | T | 0,538 / 2,084 · 1,989 / 15,147 | 62/52 · 9/15 | TF scan; "H12 15,15 su n 15 e' la firma del rumore" (RIESAME 22/09) |
| X04 | SupRev DAX H4 | D30EUR tick M15 M20 M30 H1 H3 H6 H8 D1 | SOTTO | B/C | T | OOS 0,689 (648) · 0,661 (519) · 0,625 (376) · 0,996 (173) · 0,572 (74) · 0,263 (36) · 0,943 (28) · 0,109 (7) | IS 344/300/191/94/36/20/18/13 | TF scan; DD OOS fino a 30,0% |
| Y01 | SupRev NAS H1 | NASUSD H1 L+S (970913) | SOPRA | C | T | TF scan 1,342 / 1,688 (69/86) · R3 idem · R110 1,386 / 1,581 (76/96) · R127a-ancora 1,298 / 1,613 (71/87) | 69-76 / 86-96 | DD OOS 0,86 / 1,29 / 1,09; R103 [B] 1,65 (172); valid finestra piena 1,57 (155); **3 binari, 3 cifre, tutte sopra 1** |
| Y02 | SupRev NAS H1 | asse stop `InpSLBufferPips` 3-3003 (9 celle, R127a) | SOPRA | C | T | IS 1,298-1,523 / OOS 1,497-1,721 | 69-71 / 84-87 | `risultati_prove/r127a/`; 9 celle su 9 sopra; **binario con Guardian, non riproduce l'ancora R3 (-3,3% / -4,5%)** (`R127A_BINARIO_NON_RIPRODOTTO`) |
| Y03 | SupRev NAS H1 | asse `InpStMult` 3,0 e 3,5 (R3) | SOPRA | C | T | 1,342 / 1,688 · 1,365 / 1,475 | 69/86 · 53/83 | `*_r3.csv`; "cresta di due su DUE assi" |
| Y04 | SupRev NAS H1 | asse `InpStMult` 2,0 (INV, OOS n 154) | SOPRA·INV | C | T | 0,612 / 1,014 | 75 / 154 | R3; OOS n >= 150 sopra 1 ma a 1,014 e con IS 0,612 |
| Y05 | SupRev NAS H1 | asse `InpStMult` 2,5 e 4,0 | SOTTO | C | T | 0,907 / 0,930 · 0,786 / 0,973 | 78/131 · 35/79 | R3 |
| Y06 | SupRev NAS H1 | lati (R110): long / short | SOPRA | D/C | T | 1,311 / 1,448 · 1,511 / 1,870 | 47/62 · 29/34 | R110 `[DICHIARATO]`; short n 34 |
| Y07 | SupRev NAS H1 | tick TF H2, H8, H12, D1 | SOPRA | D | T | H2 1,027 / 1,356 · H8 0,526 / 3,572 (INV) · H12 4,232 / 1,165 · D1 n 0 / 2,360 | 34/39 · 15/4 · 3/6 · 0/2 | TF scan |
| Y08 | SupRev NAS H1 | tick TF M15 M20 M30 H3 H4 H6 | SOTTO | B/C | T | OOS 0,894 (320) · 0,680 (267) · 0,868 (185) · 0,334 (33) · 0,892 (30) · 0,792 (20) | IS 217/144/84/18/18/5 | TF scan; H4 IS 1,747 (18) |
| Y09 | SupRev NAS H1 | regime [B][E] `NASUSD_EXT` LATERALE 2015.01-2016.06 | SOTTO | C/D | B | 0,664 (metro; long 0,626, short 0,729) | 55 uscite | R113; "il rimbalzo senza trend paga il conto"; unica finestra con campione |
| Y10 | SupRev NAS H1 | regime [B][E] VECCHIA 2011-12 | SOPRA | C/D | B | 1,152 (long 1,228, short 1,049) | 94 uscite | R113 (SOLO rischio per criterio firmato) |
| Y11 | SupRev NAS H1 | regime [B][E] TORO 2021 / CROLLO_ANNO 2020 | SOPRA | D | B | 2,187 / 2,604 | 8 / 5 uscite | R113; campione inesistente |
| Y12 | SupRev NAS H1 | regime [B][E] ORSO 2022 / CROLLO 2020-02..04 | SOTTO | D | B | 0,958 / 0,396 | 7 / 3 uscite | R113; **in ORSO lo short non apre nemmeno una operazione** |
| D01 | SupRev DOW H1 | U30USD H1 L+S cella viva (970916): TF scan e R123 | SOPRA·INV | C | T | TF 0,923 / 1,436 (118/155) · R123/r132c 0,988 / 1,389 (117/152) | 117-118 / 152-155 | DD 6,3 / 4,8; valid finestra piena 1,20 (273) DD 9,77 |
| D02 | SupRev DOW H1 | assi R123: IS e OOS sopra: St 4,5 · AtrP 12 · NearAtr 1,25 | SOPRA | C | T | 2,017 / 1,418 · 1,177 / 1,359 · 1,005 / 1,322 | 97/117 · 106/133 · 122/172 | `r123_dal_vps/` |
| D03 | SupRev DOW H1 | assi R123: OOS >= 1 con IS < 1 (St 4,0 · AtrP 8 · NearAtr 0,25 / 0,75 / 1,5 / 1,75 / 2,0) | SOPRA·INV | C | T | 0,721 / 1,093 · 0,781 / 1,164 · 0,628 / 1,076 · 0,770 / 1,284 · 0,865 / 1,322 · 0,719 / 1,245 | 100/112 · 136/179 · 43/80 · 99/133 · 128/172 · 132/176 | R123 B/C/D + r132c |
| D04 | SupRev DOW H1 | assi R123: OOS < 1: St 2,5 e 3,0 · AtrP 6 7 10 11 · NearAtr 0,5 | SOTTO | B/C | T | 0,877 / 0,914 · 1,084 / 0,953 · 0,557 / 0,914 · 0,851 / 0,882 · 0,888 / 0,610 · 0,836 / 0,559 · 0,635 / 0,992 | 180/261 · 144/200 · 104/202 · 117/165 · 111/128 · 129/108 · 64/122 | **St 2,5 (n 261) e 3,0 (n 200) sono OOS >= 150 sotto 1**: la cella viva e' un picco |
| D05 | SupRev DOW H1 | tick TF H2, H4 | SOPRA | D/C | T | 3,502 / 1,147 · 4,758 / 1,941 | 54/109 · 35/46 | TF scan; "il pettine H2 3,50 / H3 0,49 / H4 4,76" |
| D06 | SupRev DOW H1 | tick TF M15 M20 M30 H3 H6 H8 H12 | SOTTO | B/C | T | OOS 0,732 (656) · 0,623 (408) · 0,995 (369) · 0,226 (65) · 0,229 (28) · 0,969 (41) · 0,000 (10) | IS 292/309/207/26/11/2/2 | TF scan; DD OOS fino a 22,3% |
| W01 | SupRev DOW H4 | U30USD H4 L+S (970914) | SOPRA | D/C | T | 3,651 / 2,324 | 30 / 49 | TF scan; DD 3,6 / 2,7 |
| W02 | SupRev DOW H4 | tick TF M30, H1 (INV), H8 | SOPRA·INV | B | T | 0,662 / 1,370 · 0,741 / 1,149 · -- / 1,599 | 163/362 · 132/180 · 0/37 | TF scan |
| W03 | SupRev DOW H4 | tick TF M15 M20 H2 H3 H6 H12 | SOTTO | B/C | T | OOS 0,671 (666) · 0,838 (434) · 0,846 (125) · 0,930 (57) · 0,921 (27) · 0,030 (17) | IS 324/334/41/21/5/4 | TF scan |
| W04 | SupRev DOW H4 | U30USD H4 8 celle, finestra piena tick (26/07) | SOPRA·sOOS | C | T | PFmed 1,772; PFmax 2,768 (n 79, DD 4,00); 6/8 positive | 79 | `valid_SupRevRT_U30USD_H4_realtick.csv`; **la "revoca 0,79" e' un altro oggetto** (D4) |
| W05 | SupRev DOW H4 | U30USD H4 "revalidation pulita PFmed 0,79 · 56 tr" | NM | -- | T | PFmed 0,79 | 56 | `CLASSIFICHE.md`: **[NON RIPRODOTTO]** (`REGISTRO_TEST` r.598-620) |
| C01 | SupRev CAC H4 | F40EUR H4 cella (2,5/9/2,5), tick, finestra piena | SOPRA·sOOS | C | T | PFbest 1,794 (65, DD 3,48); PFmed 8 celle 0,958 (4/8 positive) | 65 | `valid_SupRevRT_F40EUR_H4_realtick.csv`; mediana = "RT 0,96" |
| C02 | SupRev CAC H4 | F40EUR H4 split OHLC [B] | SOPRA·INV | D | B | 0,976 / 2,404 | 23 / 40 | solo `_ohlc`: **lo sweep TF a tick non esiste** |
| V01 | SupRev DAX H1 | D30EUR H1 L+S (970911, spenta) | SOPRA·INV | C | T | 0,730 / 1,866 | 67 / 156 | DD 5,5 / 4,5; valid finestra piena 1,45 (223); spenta 11/08 su "IS -240 / OOS +1.312" |
| V02 | SupRev DAX H1 | tick TF H4, H6 (INV) | SOPRA | D | T | 4,472 / 1,026 · 0,500 / 2,181 | 19/45 · 13/34 | TF scan |
| V03 | SupRev DAX H1 | tick TF M15 M20 M30 H2 H3 H8 H12 D1 | SOTTO | B/C | T | OOS 0,853 (556) · 0,486 (465) · 0,987 (328) · 0,428 (59) · 0,366 (98) · 0,703 (34) · 0,546 (22) · 0,635 (8) | IS 270/178/181/38/28/12/5/4 | TF scan; H3 IS 4,833 (28) |
| I01 | ST Invert | 20 serie (225JPY, D30EUR, EURUSD, GBPJPY, NASUSD, U30USD, USDJPY, XAGUSD, XAUUSD x IS/OOS, M15-H4) | NM | -- | T/B | n 0-3 per cella (USDJPY M15: PF 98 / 184 su n 2 / 2) | max 3 | 11 CSV su 20 a Trades=0 (`CENSIMENTO_CASELLE_VUOTE` §3); R100: "non misurata, EA del 2025" |
| G01 | GoldenCross | USDCHF / USDCAD / NZDUSD H4 v1.00 (R87a-V1, in campo) | SOPRA | D | T | 3,628 / 2,188 · 3,519 / 2,894 · 2,777 / 1,668 | 20/17 · 10/12 · 8/14 | `r86_r87_r89_csv/*V1*`; finestra da 2024.07.05; DD OOS 2,34 / 1,27 / 2,81 |
| G02 | GoldenCross | stesse 3 celle, v2.00 corretta (R87a) | SOPRA | D | T | 2,867 / 1,593 · 1,508 / 3,676 · 3,564 / 1,165 | 21/18 · 12/14 · 10/22 | idem; **n piu' alto in TUTTE le celle (FIX 1)**; NZDUSD DD OOS 4,68% |
| G03 | GoldenCross | forex H4 "FASE 0" OHLC [B], TF/finestra non dichiarati: USDCHF e NZDUSD | SOTTO | C | B | 1,489 / 0,700 · 0,451 / 0,815 | 44/63 · 39/65 | `ABTG_GoldenCross/*_ohlc.csv`; **n 44/63 contro 20/17 di R87a: non e' la stessa cella, non riconciliata** |
| G04 | GoldenCross | USDCAD FASE 0 OHLC [B] (INV) | SOPRA·INV | D/C | B | 0,865 / 1,062 | 40 / 49 | idem |
| G05 | GoldenCross | H4 forex tick, 96 celle x 8 simboli, finestra unica (31/07): USDCHF, USDCAD, NZDUSD | SOPRA·sOOS | D/C | T | PFmed 1,702 / 1,343 / 1,165; best 2,626 / 4,167 / 1,702; positive 72 / 48 / 54 su 96 | n max 52 / 30 / 48 | `GoldenCross/realtick_H4/` (mediane su celle di parametri, non OOS) |
| G06 | GoldenCross | R87b v2.00: celle con IS e OOS >= 1,10 (griglia 144 x 4 simboli) | SOPRA | D/C | T | USDCHF 18 · USDCAD 0 · NZDUSD 86 · oro 22 su 144 | NZDUSD n IS <= 10 | letto da me sui CSV; migliore per n (oro): 1,508 / 1,402 (52 / 84) |
| G07 | GoldenCross | R87b v2.00: celle con OOS < 1 (n > 0) | SOTTO | C | T | USDCHF 74 · USDCAD 68 · NZDUSD 28 · oro 98 su 144 | n OOS mediano 1-15 | idem; `R87_CRITERI`: "da R87b non puo' uscire un preset" |
| G08 | GoldenCross | oro H1 nativo (770301), FASE 0 tick | SOPRA | D/C | T | 1,467 / 1,066 | 31 / 52 | DD 2,27 / 5,75; R100 22 anni [B] DD 22,34% a 1% |
| H01 | GC Ott | oro H1 (970301), ADX 10 = 15 (identiche), v1.00 | SOPRA | D/C | T | 1,494 / 1,253 | 32 / 57 | R2 + FASE 0; DD 2,28 / 6,08; R87a "V1" identica |
| H02 | GC Ott | oro H1 R2 ADX 20 e 25 | SOTTO·INV | D/C | T | 1,579 / 0,888 · 1,467 / 0,994 | 31/53 · 27/45 | R2: "nono ribaltamento" |
| H03 | GC Ott | oro H1 v2.00 (R87a) | SOPRA | C | T | 1,721 / 1,194 | 47 / 66 | DD 2,41 / 6,31 |
| H04 | GC Ott | D30EUR H1 (R4) | SOPRA·INV | D/C | T | 0,506 / 1,133 | 32 / 60 | R4 |
| H05 | GC Ott | U30USD H1 (INV) e NASUSD H1 (R4) | SOTTO | C | T | 1,026 / 0,696 · 0,554 / 0,979 | 31/63 · 28/64 | R4 |
| H06 | GC Ott | GBPUSD e USDJPY H1, ADX 15/20/25 (R20, 6 celle) | SOPRA | D/C | T | GBPUSD 1,459 / 1,076 (ADX 25), 0,827 / 1,373 e 0,827 / 1,293 (INV) · USDJPY 0,914-0,942 / 1,401-1,823 (INV) | 26-44 / 40-61 | R20: "0/6 nei criteri", 5 celle su 6 INV |
| V1-01 | GC V1 | 4 simboli congelati v1.00 (R87a-V1) | SOPRA | D | T | oro 1,494 / 1,253 · USDCHF 3,628 / 2,188 · USDCAD 3,519 / 2,894 · NZDUSD 2,777 / 1,668 | 8-32 / 12-57 | e' la versione in campo |
| E-01 | Gold_Ichimoku_TK_ATR_EA | XAUUSD H1, long-only, 2020.01.01-2026.06.30, 0,5%, 100k | SOPRA·sOOS | B | B | 1,311 (nessuno split) | 553 | R103: +75.436 EUR al 0,5%; anni 2020 +44.077, 2021 -15.504, 2022 -6.549, 2023 +10.727, 2024 -3.253, 2025 +45.823, 2026p -835 |
| E-02 | Gold_Scalper_TK_BB_BE_EA | -- | NM | -- | -- | nessun CSV | -- | `[DICHIARATO]` nel sorgente: v1.10 "1174 trade/anno e perdeva" |
| E-03 | IchiCross_Gold_722 · IchiTrend_Gold_Base | -- | NM | -- | -- | nessun CSV | -- | commento del sorgente "PF 1,50, 198 trade, 5 anni, tick reali" = `[DICHIARATO]`, non riproducibile: non entra |
| E-04 | ORB_GOLD_FIBONACCI_EA · _v3.21 · GoldBreakout_Levels | -- | NM | -- | -- | nessun CSV | -- | `CENSIMENTO_ORB` r.63/271: "nessun CSV"; GoldBreakout: nessuna riga in nessun registro |

### 0.4 Conteggi (ricontati, sez. 6)

**Righe EA di G5: 19** (25 file). **Con almeno una cella SOPRA: 14** (righe 1-10, 12, 13, 14, 16). **Con almeno una cella SOTTO: 11** (righe 1-8, 10, 12, 13). **In entrambe le liste: 11** (righe 1-8, 10, 12, 13). **Solo SOPRA: 3** (9 `SupRev_CAC_H4`, 14 `GoldenCross_V1`, 16 `Gold_Ichimoku_TK_ATR_EA`).
**Solo NM: 4 righe / 7 file** (11 `SupertrendInvert` · 17 `Gold_Scalper` · 18 `IchiCross_Gold_722` + `IchiTrend_Gold_Base` · 19 `ORB_GOLD_FIBONACCI_EA` + `_v3.21` + `GoldBreakout_Levels`). **EREDITA: 1 riga / 4 file** (riga 15). 11 + 3 + 4 + 1 = 19.
**Righe della tabella 0.3: 97 = 60 SOPRA + 31 SOTTO + 6 NM** (di cui `·INV` 19, `·sOOS` 5). Le righe NM sono S09, W05 (due numeri `[NON RIPRODOTTO]`) e le 4 righe di EA mai misurati (I01, E-02, E-03, E-04). Le righe sono celle o **gruppi di celle di uno stesso round/asse con la stessa classe**: non sono 97 celle.
Il `SupRev_CAC_H4` non ha nessuna riga SOTTO in tabella perche' il suo unico TF-scan e' `[B]` e resta fuori tabella (sez. 0.1 punto 1): le sue righe OOS < 1 `[B]` sono nella scheda 1.9.

---

## 1. FAMIGLIA SUPREV (SupertrendReversal e derivati) - premessa comune

**Motore (tutte le 11 righe)**: rimbalzo sul Supertrend. Il prezzo tocca/viola il Supertrend con l'ombra e **chiude vicino** (perdita di forza); la candela dopo **apre dentro** e conferma;
**confluenza** con una EMA (14/89/100/200); ingresso frazionato (1/3 a mercato + 2/3 pendente); stop sul minimo/massimo delle ultime 5 barre (oltre la linea del Supertrend), TP in RR, **parziale al 50% a 1R**, stop in pari,
**trailing sul Supertrend** (`InpTrailOnST`) e **uscita sul flip** (`InpExitOnFlip`). `ABTG_SupertrendReversal.mq5` v1.01, 794 righe, `InpUsaGuardian`; `_Multi` = stessa logica con distanze in ATR (618 righe);
le sei `ABTG_SupRev_*_Ottimizzato` sono 615-652 righe con i parametri cotti. **Il TF operativo e' `InpTF`, non il grafico** (classe 'falso zero' del 22/09).
Gli ingressi frazionati e il parziale fanno **piu' deal che posizioni**: tutti gli `n` qui sotto sono deal.

**Fatto che governa tutta la famiglia** (`REFERTO R132`, `ROUND_USCITE_SUPERTREND`): lo stop iniziale sta sull'estremo a 5 barre; e' il **trailing** (`InpTrailOnST`, default `true` in 13 EA su 13) che lo stringe al primo tick.
**Nessuna delle tre manopole d'uscita (`InpTrailOnST`, `InpExitOnFlip`, `InpFirstFraction`) e' mai stata messa ad asse**: i file `R120a/c/d`, `A1_SUPREV_DOW_H1_01/02`, `G1PAOLO_00-12` sono scritti, **nessun CSV in repo**
(`CENSIMENTO_USCITE_MAI_PROVATE` §C, `I_FILE_FERMI` n.9). Gli assi d'uscita girati sono solo `InpTP_RR` (R18/R21/R22), `InpSLBufferPips` (R127a NAS, R236 NAS), `InpSLLookback` (R127b oro, R236c/d NAS OHLC) mentre `InpFirstFraction` e' scritto (R124a) ma non girato.

**Anni e regimi (comuni)**: tick BCM 2024.09.26 -> 2026.06.30 (IS fino 2025.06.09, OOS dal 2025.06.10): **un regime solo, il rialzo; la discesa feb-apr 2025 sta nell'IS**. `[T]` oro/indici.
Oltre i tick: oro nativo BCM **2004.06.11 -> 2026.06.30 a barre `[B]`** (R99/R100/R127b: 22 anni; R103: 2020-2026), con quattro finestre di regime **solo per il DD** (R99: ORSO 2022.01-10, CROLLO 2020.02-04, TORO 2021, LATERALE 2019: etichette di casa nate per gli indici, **non verificate sul prezzo dell'oro**); `NASUSD_EXT` HistData 2011-2022 `[B][E]` (R113, solo `SupRev_NAS_H1`);
il Dow non ha storico esterno, il DAX esterno 2010-2018 ha zero giorni in comune col nativo (`I_MORTI_E_LO_STORICO` §5). **Sonda collegata (non e' un EA)**: `sonda_supertrend_segnali.py` su Oanda `XAU_USD` 2013-2018 `[E]`, segnale = flip del Supertrend, nessuno stop, sempre a mercato:
PF **netto** oro H1 1,031 (n 1.448) / H4 1,015 (n 410), long 0,959 / 0,882 e short 1,104 / 1,151; il controesempio a rumore dice 0,950 / 1,003; **zero famiglie su 40 celle passano 1,10** (`SUPERTREND_IL_CERTIFICATO_2026-09-22`). E' una misura del segnale, non del nostro EA.

**Tre numeri del piano/censimento che NON sono celle** (D4 risolto, sez. 4): "OOS mediano 0,92-0,99" (Ott oro), "0,77-0,81" (Multi), "1,14-1,71" (Multi Ott), "0,79" (Dow H4) sono **mediane delle 11 righe TF (o delle 5 righe StMult)**: le ho rifatte dai CSV e coincidono al quarto decimale (Ott tick 0,9167, OHLC 0,9876; Multi 0,7669 / 0,8087; Multi Ott 1,1428 / 1,3026, r3 StMult 1,7144; Dow H4 IS 0,7407 / OOS 0,9208).

**Forward demo (solo demo, righe del `trades_auto.csv` = gambe 1/3 e 2/3 contate come righe, NON posizioni; campione sottile, nessun verdetto)**: vedi ogni scheda.

---

### 1.1 `ABTG_SupertrendReversal` (base)   famiglia SUPREV   gruppo G5   ruolo: sedie 770922 XAG H4 · 770923 DAX H4 · 770924 Nikkei H4 · 770925 NASUSD H1 (preset FW long-only su XAG/DAX/Nikkei/oro) + 770901 (collisione: oro sul piccolo, Nikkei H2 sul 100k) + celle di prova

1. **MOTORE**: come sopra, default St 3,5 / AtrP 10 / TP_RR 2,0 / EMA 14-89-100-200, `InpRiskPercent` 1.
2. **SIMBOLI/TF**: oro H4+H3+scan 11 TF; XAGUSD scan 11 TF; D30EUR scan 11 TF (**solo OHLC**); 225JPY scan 11 TF + R2/R5; NASUSD scan 11 TF + R236/R238; U30USD H1 R240/R243; GBPJPY, AUDUSD, CHFJPY H4 (R21/R22); E35EUR H1 (R18). **Cella di contratto**: nessuna scritta per tutta la riga; la piu' avanzata e' **NASUSD H1 L+S (S14)**. Sonde: `sonda_supertrend_segnali` [E].
3. **BACKTEST FATTI**:

| round | dato | deposito | rischio | IS | OOS | file |
|---|---|---|---|---|---|---|
| FASE 0 TF-scan 11 TF (07-08/08) | `[T]` + `[B]` | 10.000 `[DEFAULT driver]` | 1% | 2024.09.26-2025.06.09 | 2025.06.10-2026.06.30 | `risultati_prove/ABTG_SupertrendReversal/*{XAUUSD,XAGUSD,NASUSD,225JPY}*.csv`, `*D30EUR*_ohlc.csv` |
| R2 / R5 Nikkei (R5 = sizing corretto) | `[T]` | 100.000 | 1% | idem | idem | `..225JPY_*_{r2,r5,pta}.csv`; `REFERTO_ROUND2`/`_ROUND5_NIKKEI` |
| R3 oro H3, asse StMult | `[T]` | 10.000 | 1% | idem | idem | `..XAUUSD_*_r3.csv`; `REFERTO_ROUND3` §5 |
| R18 IBEX H1 / R21 non-indici H4 / R22 GBPJPY | `[T]` | 10.000 | 1% | idem | idem | `SupRev_IBEX_r18/`, `SupRev_H4_r21/`, `SupRev_GBPJPY_r22/` |
| R100 (oro 22 anni), R103 (Nikkei 770901/770924, 21 mesi) | `[B]` | 100.000 | 1% | finestra piena | -- | `R100_REFERTO.md`; `R103_REFERTO_BLOCCO1_INDICI.md` |
| R236a/b (tick), R236c-f (OHLC) NASUSD; R238a/b (tick) | `[T]` / `[B]` | 100.000 | 1% | idem | idem | **CSV non in repo**; numeri in `REFERTO_13_ROUND`/`REFERTO_R238` `[DICHIARATO]` |
| R240a/b (U30USD ancora Nasdaq), R243a/b (ancora Dow) | `[T]` | 100.000 | 1% | idem | idem | `risultati_archivio/R240/`, `R243/` (CSV letti) |
| `PASSATA_STOP_SUPREV`, R237a/b (D30EUR AtrP), R166a (Nikkei buffer), `G1PAOLO_00/01` | -- | -- | -- | -- | -- | scritti/armati; **nessun CSV in repo: NM** |

4. **ANNI e REGIMI**: tick 2024.09.26-2026.06.30 (rialzo; orso/laterale/crollo `NM`). Oro `[B]` 22 anni: DD 2,18% a 1% (R100), il piu' pulito delle sedie oro; PF/n R100 non pubblicati (zip fuori repo). Nikkei `[B]` 21 mesi (R103): PF 1,65 (n 82, 770901) / 1,72 (n 81, 770924), 1-2 trimestri negativi su 6-7.
5. **NUMERI**: tabella 0.3, righe S01-S28. Colpi d'occhio: NASUSD H1 L+S IS 1,079 (53) / OOS 1,387 (85); U30USD H1 corto ancora Dow IS 1,292 (68) / OOS 1,643 (78), DD 3,70 / 3,34; oro H4 default IS 0,337 (11) / OOS 0,765 (9).
6. **TIPOLOGIE superate**: (a) **indici**: NASUSD H1 L+S e corto; U30USD H1 (corto ancora Dow, lungo ancora Nasdaq e Dow); 225JPY H2-H4 (n 26-50); **oro**: H3/H4 solo su n 9-35 e con IS di 5-22 deal; **argento** H3/H4 (IS n 4-14); **forex**: **nessuna** (CHFJPY 0/12, AUDUSD solo celle INV, GBPJPY una riga a crinale). (b) **regimi**: solo il rialzo; sull'oro `[B]` 22 anni il PF per regime e' `NM`.
7. **FORWARD DEMO** (gambe, solo demo): 770901 XAUUSD S 3 righe -81,46 (30/07-05/08); 770924 Nikkei 5 righe +2,79 (27/08-17/09); 770925 NASUSD 2 righe -3,69 (03-10/08); 770901 Nikkei sul 100k 5 righe +17,96 (10/08-24/09). 770922/770923: 0 righe nel periodo. **Nessun verdetto**.
8. **CLASSE**: SOPRA (14 righe di tabella: S02 S03 S06 S10 S11 S12 S14 S15 S17 S20 S21 S22 S23 S25) · SOTTO (13: S01 S04 S05 S07 S08 S13 S16 S18 S19 S24 S26 S27 S28) · NM (S09). **SEGNO INVERTITO** (IS/OOS opposti) su S06 (H3), S15, S16, S19, S22, S23 (St 4,5), S25.
9. **VERDETTO**: **MERITO SOSPESO** su tutte le celle SOPRA (n deal <= 114 in OOS); `ESCLUSO PER COSTO` stimato 28,7x per NASUSD H1 (`IL_CORTO_DI_DAX_E_NASDAQ` r.450, `[DERIVATO]`, la FASE 1 che lo misura non e' stata lanciata); U30USD H1 corto: costo 40x **SOSPESO** (`REFERTO_R243` §4). **Nessun MORTO**: i SOTTO non hanno il certificato. **Certificato (celle SOTTO: S01 oro H4 default, S04, S05, S16, S19, S24-S28)**: (1) PF: tabella; (2) n/DD: tabella (DD oro H4 IS 1,11 / OOS 2,6 a 1%, 10k); (3) **uscita ad asse: PARZIALE** (TP_RR 2,0-3,0 in R21; SLBuffer in R236 su NASUSD; **TrailOnST/ExitOnFlip/FirstFraction/TP1Pct mai**); (4) gemelli: oro, XAG, DAX, Nikkei, NASUSD, Dow, GBPJPY, AUDUSD, CHFJPY, IBEX; (5) TF: M15 M20 M30 H1 H2 H3 H4 H6 H8 H12 D1 (per nome) **sull'oro, XAG, NASUSD, 225JPY**; U30USD solo H1; GBPJPY/AUDUSD/CHFJPY solo H4; E35EUR solo H1. => **NON ANCORA MISURATO**, manca la casella 3 completa (e i TF per Dow/forex).
10. **MIGLIORABILE?** Si', e **non per i parametri** (regola 19/08): il corto indici a H1 ha due misure indipendenti sopra 1 (NASUSD OOS 1,598 con IS 0,903 n 25/42; U30USD ancora Dow 1,643 con IS 1,292 n 68/78) ma con n 25-78 e IS invertito su NASUSD.
11. **COSA SERVE**: (a) **`PASSATA_STOP_SUPREV`** (pronta, PASS strato 2 del 24/09, pin `7e255a82`, sospesa il 21/09 per la challenge): 2 passate singole U30USD H1, misura la distanza ingresso->SL e chiude il costo 40x: **15-25 min** sul PC di backtest, firma no (round di misura); (b) **R120 (uscita ad asse)** sulla famiglia: ~1 ora [STIMA, vedi 5]; (c) **FASE 1 NASUSD** (test singolo con Print, `Optimization=0`) per il costo 40x del corto NASUSD H1: nessuno strumento del repo la lancia (`REFERTO_13_ROUND` §3) = lavoro di `mql5-ea-developer`/driver, **costo ~0,5 giorno `[STIMA]`**; (d) per l'oro: G0 col binario `0953846c` (~8-10 min) e zip R99/R100; (e) per il Nikkei: ricompilare il sizing (firma di Claudio: cambia il live).
12. **COSTO**: PC di backtest `DESKTOP-H4D7CAJ`, mai il VPS. Ritmi misurati: R240 18 min (8 passate tick), R243 23 min (8), R238 44 min (a/b 100k); R127a 18 passate stimate 3,7 min (`R127a` r.89).
13. **FONTI/CONFLITTI**: `risultati_prove/ABTG_SupertrendReversal/`, `SupRev_H4_r21`, `SupRev_IBEX_r18`, `SupRev_GBPJPY_r22`, `R240`, `R243`, `REFERTO_ROUND3/5`, `REFERTO_13_ROUND_2026-09-23` §3, `REFERTO_R238`, `REFERTO_R240`, `REFERTO_R243`, `R100_REFERTO`, `R103_REFERTO_BLOCCO1_INDICI`, `CENSIMENTO_CONTRATTI_v2` r.263/301. **Conflitti**: (i) magic `770901` sulla stessa sigla = oro (piccolo) e Nikkei H2 (100k) (`CENSIMENTO_CONTRATTI_v2` r.265-271, M-C8); (ii) il piano scrive "nativo oro H4 ~2,74 bt": e' l'assunzione "nativi ≈ ottimizzati" di `CLASSIFICA_PF.md`, **non una misura** (D15): la cella base misurata e' S01; (iii) il preset FW dell'oro e' long-only, il CSV R21/TF-scan e' L+S: **nessun CSV ha il lato del preset**; (iv) il "PFmed" `CLASSIFICHE.md` §2 (oro 1,46, XAG 1,37, DAX 1,05, Nikkei 1,05, Dow 0,79, ASX 0,78) e' `[NON RIPRODOTTO]`.

---

### 1.2 `ABTG_SupertrendReversal_Ottimizzato`   famiglia SUPREV   gruppo G5   ruolo: sedia 970901 XAUUSD H4 (26/07), rischio 2% nel sorgente e nei CSV

1. **MOTORE**: stesso cuore, parametri cotti St 2,5 / AtrP 7 / NearAtr 1,0 / TP_RR 2,5 / `InpRiskPercent` **2,0** (la sedia gira a 1% dal 18/08).
2. **SIMBOLI/TF**: XAUUSD su 11 TF (cella di contratto **H4**). Nessun altro simbolo col proprio nome. Collegati: R99/R100/R103/R127b/R114, `ABTG_SondaMargine` (R114).
3. **BACKTEST FATTI**: (a) CLASSIFICA 26/07: tick, finestra piena 2024.01-2026.06, **PF 2,74, DD "basso"**, rischio 1%: **`[NON RIPRODOTTO]`, nessun CSV in repo**; (b) TF-scan 11 TF IS/OOS tick + OHLC (08/08, 10k, **rischio 2%**): `ABTG_SupertrendReversal_Ottimizzato_XAUUSD_{IS,OOS}{,_ohlc}.csv`; (c) **R99** (23/08, 22 anni `[B]`, 1%, n 657, DD 9,02%, peggior giorno -0,68%, quattro finestre di regime solo DD: ORSO 0,71 / CROLLO 1,56 / TORO 2,69 / LATERALE 1,89%); (d) **R103** (24/08, 6,5 anni `[B]`, 100k, 1%): PF 1,330, n 208, DD 3,51%; (e) **r127b** (scritto 11/09, riletto 18/09; 22 anni `[B]`, 100k, 1%, asse `InpSLLookback`, split 40/60 ~2013.04 `[DERIVATO]`): vedi U05; (f) R114 (leva prop): **fermo dal canarino, zero numeri**; R120c (uscita) scritto, mai girato.
4. **ANNI e REGIMI**: tick 21 mesi (rialzo oro); `[B]` 2004.06.11-2013.04 (IS r127b, il grande toro dell'oro 2004-2011 incluso): **PF 0,792-0,855 (7/7 sotto 1, n 230)**; `[B]` ~2013.04-2026.06 (OOS): **1,053-1,125 (7/7 sopra, n 427)**; **segno opposto su 7 celle su 7**. Per anno (R103, 2020-2026): 2020 -572 (24), 2021 -2.292 (34), 2022 +767 (24), 2023 -200 (27), 2024 +1.624 (38), 2025 +4.807 (48), 2026p +658 (13): **3 anni negativi su 7** (`LE_QUATTRO_EPOCHE` r.136 scrive 4/7: non riconciliato, D22). PF per regime: **NM** (R99 pubblica solo il DD).
5. **NUMERI**: U01-U06. H4 a tick: **IS 4,752 (22) / OOS 2,253 (30)**, DD 0,79 / 2,08% a 2%.
6. **TIPOLOGIE superate**: oro, H4 a tick solo come **picco** fra TF adiacenti (H2 0,728 / H3 0,780 / H6 0,568 in OOS, tutti sotto 1) e solo nel rialzo; `[B]` 13 anni (OOS r127b) sopra di poco (1,05-1,13).
7. **FORWARD DEMO**: 970901 XAUUSD 3 righe -21,19 (28/08, 18-23/09). Campione che non dice nulla.
8. **CLASSE**: SOPRA · D · `[T]` (U01, U03) · **SOTTO** B/C · `[T]` (U04: M20 M30 H1 H2 H3 H6 H12) · SOPRA·INV (U02 M15, n IS 321 / OOS 572; U05 22 anni) · SOPRA·sOOS (U06). **D3**: il "2,74 finestra piena senza OOS" sarebbe "SOPRA (senza OOS)", ma l'OOS esiste e lo conferma sulla cella H4 (2,253).
9. **VERDETTO**: MERITO SOSPESO (n 30 deal) + **PICCO su TF**. Rischio: **DD 22 anni 9,02% a 1% = 0,98 punti sotto il muro 10%** (R99), a 2% ~18% `[DERIVATO lineare]`: **la taglia e' il verdetto, firma di Claudio**. Costo: ~135,7x `[INFERITO]` a H4 (`CENSIMENTO_CONTRATTI_v2` r.314): passa. **Certificato celle SOTTO (U04)**: (1) PF tabella; (2) n/DD tabella; (3) uscita: `InpSLLookback` ad asse in r127b (1-13), TrailOnST/ExitOnFlip mai; (4) gemelli: solo l'oro col proprio nome (i fratelli sono altri EA: base su XAG/Nikkei/NAS, Multi, Multi_Ott); (5) TF 11 per nome => **NON ANCORA MISURATO** (casella 3 parziale).
10. **MIGLIORABILE?** Non so: il 2,74 non si riproduce, il 2,253 e' un picco su n 30.
11. **COSA SERVE**: (a) **recupero dello zip `R99_ORO_22ANNI_CORSA_20260823_1333` / `R100_ORO_FLOTTA_CORSA_20260823_1449`** (PF e n per finestra di regime, `LO_STORICO_ESTERNO_MAPPA` N2): **zero macchina**, trasferimento; (b) **G0 oro sul binario attuale** (4 passate H4, ~8-10 min `[STIMA da R264]`): separa binario / storico / specifica e dice se l'IS 4,75 esiste ancora; (c) R120c (uscita ad asse, 4 celle x 2 finestre) ~10 min; (d) taglia: **firma di Claudio**.
12. **COSTO**: PC di backtest; (a) 0, (b) 8-10 min, (c) ~10 min.
13. **FONTI/CONFLITTI**: `risultati_prove/ABTG_SupertrendReversal_Ottimizzato/`, `dal_vps/..._r127b.csv`, `R99_REFERTO`, `R100_REFERTO`, `R103_REFERTO_DRIVER_FOREX_METALLI` r.1793-1850, `CLASSIFICA_PF` #3, `CENSIMENTO_CONTRATTI_v2` r.314. **D4 RISOLTO**: "2,74 contro OOS mediano 0,92-0,99" = tre oggetti diversi (vedi sez. 4).

---

### 1.3 `ABTG_SupertrendReversal_Multi`   famiglia SUPREV   gruppo G5   ruolo: sedia 771001 XAUUSD H4 (nativa, rischio 1%)

1. **MOTORE**: `_Multi` = distanze in ATR; default St 3,5 / AtrP 10 / TP_RR 2,0.
2. **SIMBOLI/TF**: oro, TF-scan 11 TF. Magic 771001 (preset `ABTG_SupertrendReversal_Multi_H1.set` e' H1!, il grafico FLOTTA e' H4).
3. **BACKTEST FATTI**: solo il TF-scan 08/08 tick + OHLC, 10k, 1%: `ABTG_SupertrendReversal_Multi_XAUUSD_{IS,OOS}{,_ohlc}.csv`; R100 (22 anni `[B]`, DD 7,36% a 1%, peggior giorno -1,60%); nessun round proprio dopo.
4. **ANNI e REGIMI**: tick 21 mesi; `[B]` 22 anni solo DD. Regimi `NM`.
5. **NUMERI**: M01-M03. H4 default IS 0,709 (15) / OOS 0,686 (14); H3 3,536 / 1,692 (15/30); H2 1,494 / 1,002 (39/53); M15 0,748 / 1,050 (257/488).
6. **TIPOLOGIE superate**: oro H3/H2/M15 (IS invertito a M15); nessun altro simbolo.
7. **FORWARD DEMO**: 771001 XAUUSD 4 righe -140,45 (30/07-05/08): tutte perse.
8. **CLASSE**: SOPRA D/C (M02) · **SOTTO** D (M01) · SOTTO B/C (M03) · tutte `[T]`.
9. **VERDETTO**: MERITO SOSPESO; la cella H4 default e' SOTTO su n 15/14. **Certificato**: (1) tabella; (2) tabella; (3) uscita: mai; (4) gemelli: solo l'oro (nessun altro simbolo provato col suo nome; i fratelli sono altri EA: base, Ott, Multi_Ott); (5) TF 11 per nome => **NON ANCORA MISURATO** (casella 3 vuota). **Non e' un morto.**
10. **MIGLIORABILE?** Sostituita dalla `_Multi_Ottimizzato`: non conviene misurarla a parte.
11. **COSA SERVE**: R120c condiviso con la Multi_Ott (nessun costo aggiuntivo se girano insieme).
12. **COSTO**: incluso in R120c (~10 min).
13. **FONTI**: TF-scan, `R100_REFERTO`, `FLOTTA_ATTIVA` r.60. Il "nativo ~3,17 bt" e' l'assunzione D15.

---

### 1.4 `ABTG_SupertrendReversal_Multi_Ottimizzato`   famiglia SUPREV   gruppo G5   ruolo: sedia 971001 XAUUSD H4 ('TOP' PF bt 3,17), rischio 2% nel sorgente e nei CSV

1. **MOTORE**: `_Multi` con St 2,5 / AtrP 12 / TP_RR 3,0, `InpRiskPercent` **2,0**.
2. **SIMBOLI/TF**: oro, TF-scan 11 TF (cella H4); asse StMult (R3).
3. **BACKTEST FATTI**: (a) CLASSIFICA 26/07 PF 3,17: **`[NON RIPRODOTTO]`**; (b) TF-scan IS/OOS tick+OHLC (08/08, 10k, 2%); (c) **R3 StMult 1,5-3,5** (08/08, tick): `..XAUUSD_*_r3.csv`; (d) R100 (22 anni `[B]`, **DD 16,90% a 1%**, peggior giorno -1,85%); (e) round cost M30/M15 (REGISTRO r.2985-2986, tick, 2%).
4. **ANNI e REGIMI**: tick 21 mesi; `[B]` 22 anni solo DD; regimi `NM`.
5. **NUMERI**: O01-O08. H4 **IS 4,506 (33) / OOS 2,907 (49)**, DD 3,15 / 4,50 a 2%; R3 riproduce la cella viva a 5 decimali; asse St: 1,5 IS 0,496 (74) / OOS 1,714 (105, DD 5,79); 2,0 0,490 / 1,121; 3,0 1,253 (11) / 2,985 (27); 3,5 1,569 (17) / 0,319 (19).
6. **TIPOLOGIE superate**: oro H4/M30 (**M30: unica cella di G5 oro con IS e OOS sopra e n OOS >= 150: 1,256 / 1,087, n 257/427, ma DD OOS 22,06% a 2% e M30 escluso per costo**), H1/H6 con IS invertito.
7. **FORWARD DEMO**: nessuna riga col magic 971001 nel periodo (le 4 righe -140,45 sono 771001, la Multi base).
8. **CLASSE**: SOPRA D/C (O01 O03) · SOPRA C (O02 INV, O07) · SOPRA B (O05, O06 INV) · **SOTTO** D (O04 INV) e C (O08) · `[T]`. **Le "3 righe OOS n>=100 tutte sopra 1 (1,14-1,71)" del censimento sono la riga St 1,5 di R3 (O02: e' la cella mediana dei PF OOS, con IS 0,496) e le due mediane TF (1,143 tick, 1,303 OHLC): nessuna e' la cella viva**.
9. **VERDETTO**: MERITO SOSPESO + PICCO ("cresta di due 2,5-3,0, il 3,0 su 11/27 trade", `REFERTO_ROUND3` §4; "H4 picco con H3 a -701"); M30 `scartata per REGOLA DI SELEZIONE` e M15 `MORTO PER RISCHIO` (RIESAME 22/09). **Rischio: DD 22 anni 16,90% a 1%: NO PER RISCHIO a 1%** (a 0,5% ~8,5% `[DERIVATO lineare]`): **taglia = firma di Claudio**. **Certificato celle SOTTO (O04 St 3,5; O08 H2/H3/H12)**: (1) tabella; (2) tabella; (3) uscita: TP_RR fisso, **TrailOnST ecc. mai**; (4) gemelli: Multi, Ott, base; (5) TF 11 per nome => NON ANCORA MISURATO.
10. **MIGLIORABILE?** Non so. Il PF 2,9 su n 49 deal e' un picco; il rischio a 22 anni e' il vincolo.
11. **COSA SERVE**: R120c (~10 min), G0 oro, zip R99/R100; **taglia: firma**.
12. **COSTO**: ~10 + 8-10 min; zero per lo zip.
13. **FONTI**: TF-scan + r3 (CSV letti da me); `REFERTO_ROUND3` §4; `REGISTRO_TEST` r.2985-2988; `R100_REFERTO`; `CLASSIFICA_PF` #1.

---

### 1.5 `ABTG_SupRev_DAX_H4_Ottimizzato`   famiglia SUPREV   gruppo G5   ruolo: sedia 970912 D30EUR H4 (in campo sul piccolo, 0 operazioni)

1. **MOTORE**: St 3,0 / AtrP 9 / TP_RR 3,0.
2. **SIMBOLI/TF**: D30EUR TF-scan 11 TF (cella H4). Lati separati solo in R110.
3. **BACKTEST FATTI**: (a) 26/07 `valid_SupRevRT_D30EUR_H4.csv` (8 celle, finestra piena tick 2024.01-2026.06 nominale, 1%): best **1,96 (n 86, DD 5,74)**, PFmed 1,313, 6/8 positive, `[T]`; (b) TF-scan IS/OOS tick+OHLC (08/08, 10k); (c) R103 `[B]` 21 mesi 100k: PF 2,05, n 99, DD 4,22; (d) **R110** (26/08, tick, 100k, 1%, lati): metro IS 3,808 (31) DD 1,67 / OOS 1,432 (65) DD 4,04; **CSV fuori repo**.
4. **ANNI e REGIMI**: tick 21 mesi, IS 8,4 mesi. Regimi `NM`; DAX esterno 2010-18 non confrontabile (zero sovrapposizione).
5. **NUMERI**: X01-X04. Frequenza ~0,22 deal/g (OOS 60 deal in ~267 giorni di borsa; `RIESAME` §2.3 usa 445 giorni di borsa per tutta la finestra).
6. **TIPOLOGIE superate**: indice DAX, H4 (e H2/H12 con n 15-52); **sotto H1 tutto sotto 1 con campione abbondante** (OOS 0,625-0,689, n 376-648, DD fino al 30%).
7. **FORWARD DEMO**: **0 righe** col magic 970912.
8. **CLASSE**: SOPRA D/C (X01) · SOPRA D (X02, X03) · **SOTTO** B/C (X04) · `[T]`.
9. **VERDETTO**: MERITO SOSPESO (n 60); costo H4 **NON MISURATO** (27,8-184x, "il 40x non e' piu' deciso" `IL_CORTO_DI_DAX_E_NASDAQ` r.454); lato corto n 29 `NON MISURABILE`. **Certificato X04**: (1)-(2) tabella; (3) uscita: **mai**; (4) gemelli: SupRev DAX H1, Nasdaq, Dow, CAC; (5) TF 11 per nome => NON ANCORA MISURATO, e a M15-M30 ESCLUSO PER COSTO (13,4x a M30 `[DERIVATO]`).
10. **MIGLIORABILE?** Non a breve: il campione H4 arriva a n 150 deal oltre il 2027 (`I_MORTI_E_LO_STORICO` §7: 5,0 anni stimati).
11. **COSA SERVE**: R120d (uscita, ~10-15 min), misura diretta dello stop (parte della passata stop se estesa al DAX); storico DAX esterno non sovrapponibile: **spesa/firma** (non si propone).
12. **COSTO**: ~10-15 min [STIMA da R243].
13. **FONTI**: `supertrend_indici_validazione/valid_SupRevRT_D30EUR_H4.csv`, TF-scan, `REFERTO_DRIVER_R110_20260826.txt`, `R103_REFERTO_BLOCCO1_INDICI`, `CENSIMENTO_CONTRATTI_v2` r.315.

---

### 1.6 `ABTG_SupRev_NAS_H1_Ottimizzato`   famiglia SUPREV   gruppo G5   ruolo: sedia 970913 NASUSD H1 (in campo sul piccolo, magic sul grafico 970925 nei referti)

1. **MOTORE**: St 3,0 / AtrP 10 / TP_RR 3,0; 652 righe (il piu' lungo dei sei).
2. **SIMBOLI/TF**: NASUSD H1 (cella di contratto), TF-scan 11 TF, assi StMult (R3) e SLBuffer (R127a); prove regime su `NASUSD_EXT`. Sonde/strumenti collegati: nessuno (il `RIESAME` 22/09 cita solo la sonda dei segnali Supertrend, vedi premessa).
3. **BACKTEST FATTI**:

| round | dato | deposito | rischio | finestra | file |
|---|---|---|---|---|---|
| 26/07 `valid_SupRevRT_NASUSD_H1.csv` (8 celle) | `[T]` | n/d | 1% | 2024.01-2026.06 nominale, **finestra piena** | `supertrend_indici_validazione/`; 8/8 positive, PF 1,229-1,575, best **1,575 (n 155, DD 1,17)** |
| TF-scan + **R3 StMult** (08/08) | `[T]`+`[B]` | 10.000 | 1% | IS 2024.09.26-2025.06.09 / OOS dal 2025.06.10 | `ABTG_SupRev_NAS_H1_Ottimizzato_NASUSD_*.csv`, `*_r3.csv` |
| R103 (24/08) | `[B]` | 100.000 | 1% | 2024.09.26-2026.06.30 piena | PF 1,65, n 172, DD 1,48%, 1/7 trimestri negativi |
| **R110** (26/08, lati) | `[T]` | 100.000 | 1% | idem, split 40/60 | `REFERTO_DRIVER_R110`: CSV fuori repo `[DICHIARATO]` |
| **R113** (27/08, regime) | `[B][E]` | n/d | 1% | `NASUSD_EXT` 2011-12 · 2015-16 · 2020 · 2021 · 2022 | `R113_CORSA_20260827/` (18 CSV letti) |
| **R127a** (14/09, buffer 3-3003) | `[T]` | 10.000 | 1% | idem | `risultati_prove/r127a/` (letti da me) |
| R120a (uscita), R132a (NearAtr), **R163a** (buffer 2253-4503) | -- | -- | -- | -- | scritti/armati, **nessun CSV in repo: NM** |

4. **ANNI e REGIMI**: tick 21 mesi `[T]` (rialzo); **`[B][E]` NASUSD_EXT**: LATERALE 2015.01-2016.06 **0,664 (55 uscite) SOTTO**; VECCHIA 2011-12 **1,152 (94) SOPRA**; TORO 2021 2,187 (8) e CROLLO_ANNO 2020 2,604 (5) **campione inesistente**; ORSO 2022 0,958 (7) e CROLLO 2020.02-04 0,396 (3) idem; **in ORSO lo short non apre nemmeno una operazione**. **Feed o epoca? NON separati** (la sovrapposizione 2024.09-2026.06 su `_EXT` non e' girata, 3 celle ~2 min proposte da R113). Su `_EXT` il motore fa 13,3 op/anno contro 77 del nativo: servirebbero 22,5 anni per 150 op.
5. **NUMERI**: Y01-Y12. **Una sola cella, tre binari, tre cifre, tutte sopra 1**: TF-scan/R3 (08/08, binario a 49 colonne) 1,342 (69) / 1,688 (86); R110 (100k) 1,386 (76) / 1,581 (96); R127a-ancora (14/09, binario a 50 colonne con `InpUsaGuardian`) 1,298 (71) / 1,613 (87). Lo scarto R127a-R3 (-3,3% IS, -4,5% OOS, n 71 contro 69) e' **6,7-8,9 volte la tolleranza** congelata: **non riconciliato**, causa NON isolata (`R127A_BINARIO_NON_RIPRODOTTO`); e il difetto M45 (n dipende dal deposito) non e' isolato. Il segno non cambia.
6. **TIPOLOGIE superate**: **indice Nasdaq, H1 (e H2 con n 34/39)**; asse stop: 9 celle su 9 sopra (buffer 3-3003); asse StMult: cresta 3,0-3,5. Regime: **solo 2011-12 e il rialzo**; il laterale 2015-16 e' sotto con campione pieno.
7. **FORWARD DEMO**: 970913 NASUSD **9 righe +53,48** (7 long +43,35 PF 2,69; 2 short +10,13 PF 2,53), 30/07-23/09; 770925 e' un'altra sedia (la base). Campione sottile, **nessun verdetto**.
8. **CLASSE**: **SOPRA · C · `[T]`** (Y01, Y02, Y03, Y06 D/C, Y07 D) · SOPRA·INV (Y04, n OOS 154 a 1,014) · **SOTTO** (Y05 St 2,5/4,0; Y08 TF M15-M30 n OOS 185-320, DD fino a 8,1%; Y09 laterale) · regimi `[B][E]`: Y09 SOTTO, Y10 SOPRA, Y11 SOPRA D, Y12 SOTTO D.
9. **VERDETTO**: **MERITO SOSPESO** (n 86-96 deal, ~37-96 pos); **ESCLUSO PER COSTO 28,7x** (`CENSIMENTO_CONTRATTI_v2` r.316, `IL_CORTO` r.450: stop swing 5 barre + 3 "pip" inerti, contro 40x; **misura diretta mancante**); rischio **assolto** (DD OOS 0,86-1,29% a 1%, regola B; R113: "su 16 anni non e' mai esploso", DD massimo 1,81%); contratto 970913 "PF 1,57 / DD 1,17% / n 155" = **finestra piena senza split** (classe 224): **non e' un OOS**. **Certificato celle SOTTO** (Y05 Y08 Y09): (1)-(2) tabella; (3) uscita: **buffer stop ad asse (R127a: 9 celle), TrailOnST/ExitOnFlip mai**; (4) gemelli: DAX H1/H4, Dow, CAC, oro; (5) TF 11 per nome => NON ANCORA MISURATO.
10. **MIGLIORABILE?** **Si'**: e' l'unica cella di G5 con IS e OOS sopra 1 in tre misure indipendenti, DD ~1% e un asse (stop) piatto. I due vincoli sono **il costo (28,7x) e il campione (n 86-96)**: il primo si attacca con la stessa manopola che R127a/R163a hanno gia' mosso (il buffer allarga lo stop; ma `R132_PAVIMENTO_SUPREV` §0.3 avverte che il trailing lo stringe al primo tick, quindi se allarghi lo stop **effettivo** e il costo non e' misurato; i CSV R127a mostrano PF e DD che si muovono, quindi la manopola non e' inerte sul risultato).
11. **COSA SERVE**: (a) **G0 col binario in campo** (1 passata, M45/binario, ~3-5 min): chiude le 3 cifre; (b) **R163a** (7 celle x 2 finestre = 14 passate, ~3-5 min `[STIMA da R127a]`, gia' scritta e armata 16/09, stato `[NON VERIFICATO]`): il buffer "che compra il cancello di costo"; (c) **FASE 1** (distanza ingresso->SL misurata, costo 40x): vedi 1.1/11(c); (d) **R113 coda: feed vs epoca** (3 celle ~2 min, firma lampo) per sapere se la prova di regime esiste; (e) campione: nessuna scorciatoia (4-6 mesi di forward per ~40 deal).
12. **COSTO**: (a)+(b)+(d) ~10 min totali sul PC di backtest; (c) lavoro di sviluppo.
13. **FONTI/CONFLITTI**: vedi sopra; `FLOTTA_ATTIVA` r.31 (magic 970925 sul grafico) contro sorgente 970913 (`ROUND_USCITE_SUPERTREND` §3.2: discordanza non risolta); `REGISTRO_TEST` r.159-171.

---

### 1.7 `ABTG_SupRev_DOW_H1_Ottimizzato`   famiglia SUPREV   gruppo G5   ruolo: 970916 U30USD H1 (SPENTA 12/08 da flat per DD ~10%; in osservazione)

1. **MOTORE**: St 3,5 / AtrP 9 / NearAtr 1,0 / TP_RR 3,0.
2. **SIMBOLI/TF**: U30USD H1 (cella), TF-scan 11 TF, assi StMult/AtrP/NearAtr (R123), r132c (riproduzione).
3. **BACKTEST FATTI**: valid 26/07 `valid_SupRevRT_U30USD_H1_realtick.csv` (8 celle, finestra piena: best **1,195 n 273 DD 9,77**, PFmed 1,072, 6/8 positive); TF-scan (08/08, 10k); **R123 A/B/C/D** (09/09, deposito `[NON DICHIARATO]`, split 40/60, gate + StMult + AtrP + NearAtr, `r123_dal_vps/`); **r132c** (12/09): 8 celle NearAtr 0,25-2,0; R123D x r132c = round NULLO (riproduzione 3 celle su 5, scarto 0,51-0,53 EUR su 10.000, n identico 10/10: **non e' il motore** `RIESAME` §1); A1/R120a (uscita) scritti, **mai girati**.
4. **ANNI e REGIMI**: tick 21 mesi, rialzo; il Dow non ha storico esterno.
5. **NUMERI**: D01-D06. Cella viva H1: IS 0,923 (118) / OOS 1,436 (155) [TF-scan]; 0,988 (117) / 1,389 (152) [R123/r132c]. Frequenza 0,58 deal/g in OOS (~0,3 pos/g).
6. **TIPOLOGIE superate**: Dow H1 solo come **picco su 2 assi su 3** (St: 3,0 -> 0,953 e 4,0 -> 1,093; AtrP: 8 -> 1,164 e 10 -> 0,610) e solo nel rialzo.
7. **FORWARD DEMO**: 970916 U30USD 5 righe +42,09 (10-11/08), poi spenta.
8. **CLASSE**: **SOPRA·INV · C · `[T]`** (D01, D03) · SOPRA C (D02) · SOPRA D/C (D05 TF H2/H4) · **SOTTO** B/C (D04 St 2,5 e 3,0 con n OOS 261/200; D06 TF).
9. **VERDETTO**: MERITO SOSPESO + **PICCO** + pettine TF; costo H1 U30USD **FRAGILE** (33,6-45,2x, soglia 40x dentro la banda); **DD valid 9,77% a 1%** (a ridosso del muro); spenta 12/08. **Certificato celle SOTTO (D04, D06)**: (1)-(2) tabella; (3) **uscita: mai** (A1/R120a non girati); (4) gemelli: DAX/Nasdaq/CAC/Dow H4; (5) TF 11 per nome => **NON ANCORA MISURATO**, anche se `RIESAME 22/09` scrive "MORTO": manca la casella 3.
10. **MIGLIORABILE?** No, senza una tesi nuova: il motore a H1 sul Dow ha un picco, DD 10% e costo fragile.
11. **COSA SERVE**: solo se Claudio vuole chiudere il certificato: A1/R120a (uscita ad asse) ~10 min. **Non si allarga `StMult` oltre 4,5** (R135a ritirato 12/09: asse dichiarato non robusto, A6).
12. **COSTO**: ~10 min.
13. **FONTI**: `r123_dal_vps/`, `dal_vps/ABTG_SupRev_DOW_H1_Ottimizzato/` (R123 e r132c, 10 CSV), TF-scan, `RIESAME_MORTI_TREND_REVERSAL_2026-09-22` §1-2, §5, `R123_BLOCCO_C_2026-09-12`, `REFERTO_FUORILISTA`.

---

### 1.8 `ABTG_SupRev_DOW_H4_Ottimizzato`   famiglia SUPREV   gruppo G5   ruolo: 970914 U30USD H4 (promozione REVOCATA 30/07; non in campo)

1. **MOTORE**: St 3,5 / AtrP 8 / TP_RR 3,0.
2. **SIMBOLI/TF**: U30USD TF-scan 11 TF; `valid_SupRevRT_U30USD_H4_realtick.csv`.
3. **BACKTEST FATTI**: valid 26/07 (8 celle, finestra piena): PF 0,487-2,768, PFmed 1,772, 6/8 positive, best 2,768 (n 79, DD 4,00); screening OHLC `SupRevScr_U30USD_H4`; TF-scan (08/08, 10k) IS/OOS tick+OHLC; `CLASSIFICHE.md` "revalidation pulita PFmed 0,79, n 56, DD 3,33" **[NON RIPRODOTTO]**.
4. **ANNI e REGIMI**: tick 21 mesi.
5. **NUMERI**: W01-W05. H4 **IS 3,651 (30) / OOS 2,324 (49)**, DD 3,6 / 2,7; TF: M30 0,662 / 1,370 (163/362), H1 0,741 / 1,149 (132/180): INV.
6. **TIPOLOGIE superate**: Dow H4 come picco (H3 0,930 e H2 0,846 in OOS sotto 1).
7. **FORWARD DEMO**: nessuna riga.
8. **CLASSE**: SOPRA D/C (W01) · SOPRA·INV B (W02) · SOPRA·sOOS C (W04) · **SOTTO** B/C (W03) · NM (W05).
9. **VERDETTO**: MERITO SOSPESO. **La revoca del 30/07 ("illusione OHLC, RT 0,79") si regge su un numero non riproducibile (0,79) e su una mediana TF (0,921) che include righe con n 0**: la cella H4 a tick, con split, e' SOPRA (2,324 su n 49). **Non la riapro**: il pettine (H2 3,353 / H3 0,526 / H4 3,651 in IS) e il campione la tengono comunque sotto la soglia di merito. **Certificato W03**: (3) uscita mai; (5) TF 11 per nome => NON ANCORA MISURATO.
10. **MIGLIORABILE?** Il campione H4 non esiste: servirebbero ~5,6 anni per 150 operazioni contro 1,8 disponibili (`I_MORTI_E_LO_STORICO` r.397).
11. **COSA SERVE**: niente di economico; la riga "illusione OHLC" andrebbe riscritta con la mediana TF spiegata (**D4/D16**).
12. **COSTO**: 0 (riscrittura nota).
13. **FONTI**: `supertrend_indici_validazione`/`SupRev_nuovi_indici/valid_SupRevRT_U30USD_H4_realtick.csv`, TF-scan, `REGISTRO_TEST` r.598-620, `CLASSIFICHE.md`.

---

### 1.9 `ABTG_SupRev_CAC_H4_Ottimizzato`   famiglia SUPREV   gruppo G5   ruolo: 970915 F40EUR H4 (promozione REVOCATA 30/07)

1. **MOTORE**: St 2,5 / AtrP 9 / TP_RR 2,5.
2. **SIMBOLI/TF**: F40EUR; TF-scan 11 TF **solo OHLC**; valid H4 finestra piena tick.
3. **BACKTEST FATTI**: `valid_SupRevRT_F40EUR_H4_realtick.csv` (8 celle, 26/07): PF 0,373-1,794, **PFmed 0,958**, 4/8 positive, best 1,794 (n 65, DD 3,48); TF-scan OHLC `_F40EUR_{IS,OOS}_ohlc.csv` (08/08, 10k). **Lo sweep TF a tick non esiste**.
4. **ANNI e REGIMI**: tick 2024.01-2026.06 nominale (~21 mesi effettivi); `[B]` split 2024.09.26.
5. **NUMERI**: C01-C02. OHLC H4: IS 0,976 (23) / OOS 2,404 (40); OHLC TF: M15 0,759 (502), M20 0,760 (442), H1 0,851 (164), H3 0,492 (56), H6 0,773 (49), H8 0,636 (22), H12 0,212 (25), D1 0,000 (10) in OOS **sotto 1** `[B]`; H2 1,699 (112) e M30 1,026 (301) sopra `[B]`.
6. **TIPOLOGIE**: indice CAC H4, solo nella cella migliore della griglia.
7. **FORWARD DEMO**: 970915 F40EUR 2 righe **+67,64** (06/08).
8. **CLASSE**: SOPRA·sOOS C (C01) · SOPRA·INV D (C02, `[B]`). **Il "SOTTO overfit RT 0,96" del piano e' la MEDIANA di 8 celle (0,958)**, non la cella.
9. **VERDETTO**: **NON ANCORA MISURATO** per il merito: il numero 1,794 e' una cella-picco senza OOS, lo split esiste solo a barre con segno invertito. **Certificato**: (1) tabella; (2) n 65 DD 3,48; (3) uscita mai; (4) gemelli SupRev DAX/Nasdaq/Dow; (5) **TF a tick mancante**. => NON ANCORA MISURATO.
10. **MIGLIORABILE?** Si': e' il "resuscitabile" #4 del RIESAME.
11. **COSA SERVE**: **27 celle OHLC -> tick** (54 passate, ~5 min `[RIESAME §5]`); attesa dichiarata PF a tick entro -15% dell'OHLC; **esterno `frxeur` HistData mai scaricato**.
12. **COSTO**: ~5 min PC di backtest.
13. **FONTI**: `valid_SupRevRT_F40EUR_H4_realtick.csv`, TF-scan OHLC, `RIESAME_MORTI_TREND_REVERSAL` §5 riga 4.

---

### 1.10 `ABTG_SupRev_DAX_H1_Ottimizzato`   famiglia SUPREV   gruppo G5   ruolo: 970911 D30EUR H1 (SPENTA 11/08 con delibera di Claudio, IS rosso)

1. **MOTORE**: St 3,5 / AtrP 10 / TP_RR 3,0.
2. **SIMBOLI/TF**: D30EUR TF-scan 11 TF; valid H1 finestra piena.
3. **BACKTEST FATTI**: `valid_SupRevRT_D30EUR_H1.csv` (8 celle): best 1,452 (n 223, DD 5,57), PFmed 1,049, 4/8 positive; TF-scan IS/OOS tick+OHLC; `REFERTO_FUORILISTA` (11/08): "IS -240 / OOS +1.312 su 223, DD 5,6%".
4. **ANNI e REGIMI**: tick 21 mesi.
5. **NUMERI**: V01-V03. H1 IS 0,730 (67) / OOS 1,866 (156).
6. **TIPOLOGIE**: DAX H1 solo in OOS (**IS invertito**), H4 e H6.
7. **FORWARD DEMO**: 970911 D30EUR 2 righe **+56,23** (29-31/07).
8. **CLASSE**: SOPRA·INV C (V01) · SOPRA D (V02) · **SOTTO** B/C (V03).
9. **VERDETTO**: IS rosso (regime, non edge): lo spegnimento dell'11/08 (su IS rosso) non e' toccato da questo resoconto; il merito misurato e' `SOPRA·INV`. Il costo H1 DAX: **>= 42,9x `[DERIVATO]` che una misura di casa contraddice** (`IL_CORTO` §6). **Certificato V03**: (3) uscita mai; (5) TF 11 per nome => NON ANCORA MISURATO (M15-M30 ESCLUSI PER COSTO: 28-32x a M30).
10. **MIGLIORABILE?** No: la decisione e' di Claudio e il pettine TF e' forte (H3 IS 4,833 / H4 4,472 / H2 0,232).
11. **COSA SERVE**: niente.
12. **COSTO**: 0.
13. **FONTI**: `valid_SupRevRT_D30EUR_H1.csv`, TF-scan, `REFERTO_FUORILISTA`, `RIESAME` §2.1.

---

### 1.11 `ABTG_SupertrendInvert`   famiglia SUPREV   gruppo G5   ruolo: 770801 XAUUSD H1 (osservazione; in campo "da verificare")

1. **MOTORE**: inversione del Supertrend H1 (ATR 10 / Mult 3,5), trigger = **chiusura** della candela di inversione; filtri ADX/stocastico; 567 righe, v1.00. **Nessuna uscita su flip** (non ha `InpExitOnFlip`).
2. **SIMBOLI/TF**: 9 simboli x TF-scan (M15-H4) in FASE 0 (10-11/08); R100 (22 anni): **non misurabile**, gate "EA del 2025".
3. **BACKTEST FATTI**: 20 CSV `ABTG_SupertrendInvert_*_{IS,OOS}{,_ohlc}.csv` (08-11/08, 10k): **n 0 su quasi tutte le celle; massimo 3 uscite in una cella; USDJPY M15 tick 2 IS / 2 OOS (PF 98 / 184 su n 2: degenere)**; G1PAOLO_10/11/12 (ablazioni, `CENSIMENTO_CASELLE_VUOTE`): scritte, **mai corse**.
4. **ANNI e REGIMI**: tick 21 mesi: nulla da dire.
5. **NUMERI**: I01.
6. **TIPOLOGIE**: nessuna.
7. **FORWARD DEMO**: nessuna riga col magic 770801.
8. **CLASSE**: **NM** (nessun PF leggibile: n 0-3).
9. **VERDETTO**: **NON ANCORA MISURATO**: l'EA "non opera" (`REFERTO_CODA_FASCIA_B`, `HANDOFF` r.1810) e la **causa non e' diagnosticata** (filtro troppo stretto? errore di logica? la pulizia VPS del 10/08 l'ha chiuso come "grafico acceso a vuoto"). **Certificato**: (1) PF: NM; (2) n: 0-3; (3) uscita: mai; (4) gemelli: 9 simboli; (5) TF: M15 M20 M30 H1 H2 H3 H4 (per nome, 6-7) => NON ANCORA MISURATO.
10. **MIGLIORABILE?** Si', ma prima serve sapere perche' non entra.
11. **COSA SERVE**: **diagnosi con una sonda a contatori (zero passate di tester)** come R89/`ABTG_SondaRsiEmaV8`: quante volte la condizione di inversione e' vera e quale filtro la uccide; poi G1PAOLO_10/11/12 (3 file, ~3-6 min).
12. **COSTO**: lettura + sonda ~0 min macchina; ablazioni ~3-6 min.
13. **FONTI**: `risultati_prove/ABTG_SupertrendInvert/`, `R100_REFERTO`, `REFERTO_CODA_FASCIA_B`, `CENSIMENTO_CASELLE_VUOTE` §3.

---

## 2. FAMIGLIA GOLDENCROSS - premessa comune

**Motore** (`ABTG_GoldenCross.mq5`, Masterclass ABTG "GOLDEN CROSS HA"): contesto prezzo sopra la EMA50; **trigger = EMA9 incrocia EMA21 dentro le ultime N barre**; allineamento prezzo > EMA9 > EMA21 > EMA50 inclinate; 3 Heiken Ashi concordi senza ombra contraria; ADX > 20 (meglio 25), crescente, DI+ > DI-; tradabilita';
uscite TP / chiusura oltre EMA21 / incrocio inverso, parziale + stop in pari + trailing (EMA21 o ATR); max 2 trade/giorno.
**Due versioni, e l'archivio le mescola**: **v1.00** (in campo sulle quattro sedie 770331/2/3 e 770301 fino al 19/08, **e ancora oggi sul VPS secondo `REFERTO_R86_R87_R89_NOTTE` §4**) e **v2.00** (19/08: tre fix meccanici che cambiano l'insieme dei trade).
`ABTG_GoldenCross.mq5`, `_Ottimizzato.mq5` sono v2.00 a HEAD (5 e 4 occorrenze di `CrossInWindow`); `ABTG_GoldenCross_V1.mq5` e `standalone/ABTG_GoldenCross.mq5` sono v1.00 (0 occorrenze).
**Tutti i round di GoldenCross fino a R20 (FASE 0, R2, R4, R20, sweep 31/07) sono sul codice v1.00**: lo prova che la cella "V1 oro" di R87a coincide al quinto decimale con la cella FASE 0 di `GoldenCross_Ottimizzato` (1,49425 / n 32 IS; 1,25313 / n 57 OOS). Solo R87a-v2.00 e R87b girano la v2.00.
**Tutte e tre le manopole d'uscita** (parziale `InpPartialR/Pct`, trailing ATR `InpTrailMode/InpTrailAtrMult`, uscita su incrocio `InpExitOnCross/InpExitOnHAflip`) **non sono mai state ad asse**: "4 assi mai toccati" (`AUDIT_USCITE` r.177).
**Anni**: forex tick dal 2024.07.05 (R87a/R87b: `@DAQUANDO 2024.07.05`, IS ~2024.07.05-2025.04 `[DERIVATO 40/60]`, OOS fino al 2026.06.30); oro/indici 2024.09.26-2026.06.30; R20 forex H1 `@DAQUANDO 2024.09.26`. Regimi: **un solo regime, il rialzo; il resto `NM`**.
**Forward demo**: **zero righe** col magic 770331, 770332, 770333, 770301 e 970301 su **entrambi** i file (piccolo 30/03-02/10: 1.387 righe; 100k 10/08-24/09: 40 righe) `[MISURATO]`: le sedie sono "in campo" in `FLOTTA_ATTIVA` ma non hanno operato.
**Sonde/strumenti collegati**: nessuno. **Screening [B] fuori tabella**: scan H1 OHLC su 40 simboli (`GoldenCross/H1_OHLC`: oro 117 celle, 76 positive, PFmed 1,489, best 2,014) e H4 OHLC; `CENSIMENTO_CASELLE_VUOTE` §3: XPD/XPT H1 "250 passate a zero": dato mancante.
**Il corto batte il lungo sul Nasdaq**: 27/48 celle contro 0/69 `[B]` (`IL_CORTO_DI_DAX_E_NASDAQ` §7).

---

### 2.1 `ABTG_GoldenCross` (base)   famiglia GC   gruppo G5   ruolo: sedie 770331 USDCHF · 770332 USDCAD · 770333 NZDUSD (short-only da preset) H4 · 770301 oro H1 (preset)

1. **MOTORE**: sopra (v2.00 a HEAD; le sedie girano la v1.00).
2. **SIMBOLI/TF**: forex H4 (3 sedie + 5 simboli di sweep), oro H1; TF fisso al grafico (nessun `InpTF`, `ABTG_GoldenCross.txt` r.28-30: si spazzola il magic per avere due passate identiche).
3. **BACKTEST FATTI**: FASE 0 (07-08/08): forex `_ohlc` `[B]` (TF e finestra **non dichiarati nel CSV**; n 39-65), oro tick IS/OOS; `GoldenCross/realtick_H4/` (31/07, 96 celle x 8 simboli, tick finestra unica, 6 assi `InpAdxMin/AllowLong/AllowShort/AtrSLmult/TP_R`); **R87a** (19-20/08, tick, v1.00 contro v2.00, IS/OOS); **R87b** (19-20/08, tick, v2.00, 144 celle su 6 assi `InpCrossLookback/HACount/AdxMin/RequireAdxRising/MaxDistATR/MaxDistEma21ATR`, 4 simboli); R100 (22 anni oro `[B]`: **DD 22,34% a 1%**, peggior giorno -1,95%).
4. **ANNI e REGIMI**: vedi premessa. Oro `[B]` 22 anni: solo DD.
5. **NUMERI**: G01-G08 + oro nativo G08. v1.00 -> v2.00 (R87a): n **sempre piu' alto** (20->21, 17->18, 10->12, 12->14, 8->10, 14->22, 32->47, 57->66) e PF OOS **piu' basso su 3 simboli su 4** (USDCHF 2,188 -> 1,593; NZDUSD 1,668 -> 1,165; oro 1,253 -> 1,194; USDCAD sale 2,894 -> 3,676 ma con IS 3,519 -> 1,508). Verdetto firmato: "**i fix peggiorano**" su USDCHF, USDCAD (IS), NZDUSD; la v1.00 non torna in campo (il suo vantaggio nasceva da incroci saltati per un difetto d'indice).
6. **TIPOLOGIE superate**: **forex USD majors H4** (USDCHF/USDCAD/NZDUSD, n 8-66 deal) e oro H1 (n 52-66), solo nel rialzo; **scarto**: nessun indice (R4 su Ott: D30EUR inv, U30USD/NASUSD sotto), nessun altro simbolo dello sweep con OOS.
7. **FORWARD DEMO**: 0 righe.
8. **CLASSE**: SOPRA D (G01 G02 USD majors) · SOPRA D/C (G08 oro; G05 sweep s.OOS; G06 R87b 18/86/22 celle) · **SOTTO** C (G03 forex OHLC; G07 R87b: 74/68/28/98 celle su 144 con OOS < 1) · SOPRA·INV (G04 USDCAD OHLC).
9. **VERDETTO**: **MERITO SOSPESO** (n deal 8-66). R87b: "una risposta SI/NO sull'esistenza di un altopiano... da R87b non puo' uscire un preset" (`R87_CRITERI` r.64, r.120): **USDCAD 0 celle su 144 con IS e OOS >= 1,10, USDCHF 18, NZDUSD 86 (con n IS <= 10), oro 22 (n OOS fino a 84)**: nessuna lettura di altopiano e' stata scritta nel repo `[NON VERIFICATO]`. **Rischio**: oro H1 **DD 22,34% a 1% su 22 anni `[B]`: NO PER RISCHIO a 1%** (limite inferiore: l'OHLC sottostima il DD). **Certificato celle SOTTO (G03, G07)**: (1) tabella; (2) tabella; (3) **uscita: mai (4 manopole)**; (4) gemelli: USDCHF USDCAD NZDUSD EURAUD EURUSD EURJPY CHFJPY XAGUSD oro; (5) TF: **solo il TF del grafico per nome H4/H1**; sullo sweep 31/07 H4 e H1 OHLC; M30-H12 non provati => NON ANCORA MISURATO.
10. **MIGLIORABILE?** Non so. La v2.00 e' piu' debole; l'unica via e' misurare le uscite.
11. **COSA SERVE**: (a) **decisione di Claudio: ricompilare le 4 sedie con la v2.00?** (R87: "decisione di Claudio, sapendo che e' un motore piu' lento e, su 3 simboli su 4, con numeri peggiori"); (b) round d'uscita (parziale/trailing ATR/uscita su incrocio, ~32 celle `AUDIT_USCITE`, ~5-10 min); (c) lettura dell'altopiano R87b (zero macchina, il CSV c'e'); (d) per il merito: n 150 deal a ~0,12-0,2 op/g = anni.
12. **COSTO**: (b) ~5-10 min `[STIMA da R87b 288 passate in 13,8 min]`; (c) 0.
13. **FONTI/CONFLITTI**: `risultati_prove/ABTG_GoldenCross/`, `GoldenCross/realtick_H4/`, `r86_r87_r89_csv/` (24 CSV; R87b letto da me con join sulle 6 chiavi), `REFERTO_R86_R87_R89_NOTTE` §1+§4, `R100_REFERTO`, `AUDIT_USCITE_2026-09-09` r.177. **Conflitto**: il FASE 0 forex `_ohlc` (USDCHF 1,489 / 0,700, n 44/63) e R87a-V1 (3,628 / 2,188, n 20/17) hanno n incompatibili: **TF o finestra diversi, non riconciliato**; i CSV `_ohlc` non dichiarano ne' l'uno ne' l'altra. `CLASSIFICHE.md` §2 scrive "GoldenCross H4 PF reale USDCHF 2,63, USDCAD 1,63, NZDUSD 1,70": USDCHF e NZDUSD coincidono con i **PFbest** dello sweep 31/07 (2,626 e 1,702), USDCAD 1,63 coincide con **una riga** (PF 1,626, n 29), non col PFbest (4,167 su n 16): la scelta della riga non e' dichiarata; sono celle di una griglia a finestra unica, non celle di contratto.

---

### 2.2 `ABTG_GoldenCross_Ottimizzato`   famiglia GC   gruppo G5   ruolo: sedia 970301 XAUUSD H1

1. **MOTORE**: v2.00 a HEAD (885 righe); **le misure del 08/08 (FASE 0, R2, R4, R20) sono sul codice v1.00**.
2. **SIMBOLI/TF**: oro H1 (cella); asse ADX (R2); indici H1 (R4); GBPUSD/USDJPY H1 (R20).
3. **BACKTEST FATTI**: FASE 0 oro tick+OHLC (08/08, 10k); **R2** ADX 10/15/20/25 (08/08); **R4** D30EUR/U30USD/NASUSD (08/08, tick, IS fino 2025.06.09); **R20** GBPUSD/USDJPY ADX 15/20/25 (10/08, `GoldenCross_forex_r20/`); **R87a** v2.00 oro; **R87b** v2.00 oro 144 celle; R100 (22 anni `[B]`: **DD 25,18% a 1%**, peggior giorno -1,96%).
4. **ANNI e REGIMI**: tick 21 mesi, rialzo; `[B]` 22 anni solo DD.
5. **NUMERI**: H01-H06. Cella viva IS 1,494 (32) / OOS 1,253 (57), DD 2,28 / 6,08; ADX 20: IS 1,579 / OOS 0,888 (53); ADX 25: IS 1,467 / OOS 0,994 (45): **"il live (15) sta sul bordo giusto di un dirupo che comincia subito sopra"** (`REFERTO_ROUND2`).
6. **TIPOLOGIE superate**: oro H1; forex H1 (GBPUSD/USDJPY) solo come **regime** (5 celle su 6 con IS < 1 e OOS 1,07-1,82: "il copione piu' pericoloso", `REFERTO_R20`); DAX con IS invertito.
7. **FORWARD DEMO**: 0 righe (magic 970301).
8. **CLASSE**: SOPRA D/C (H01, H06) · SOPRA C (H03 v2.00) · SOPRA·INV (H04) · **SOTTO** D/C (H02 ADX 20/25) e C (H05 U30USD/NASUSD).
9. **VERDETTO**: MERITO SOSPESO; vicinato ADX **non verde** (nono ribaltamento, R2); R4: "il pattern non viaggia: oro-specifico o rumore"; R20: **0 celle su 6** nei criteri; **DD 22 anni 25,18% a 1%: NO PER RISCHIO a 1%** (limite inferiore OHLC; a 0,4% ~10% `[DERIVATO lineare]`). **Certificato celle SOTTO (H02, H05)**: (1)-(2) tabella; (3) uscita mai; (4) gemelli: oro, D30EUR, U30USD, NASUSD, GBPUSD, USDJPY; (5) TF: H1 per nome (+ M15, H4, D1 via preset XAUUSD; mai a tick) => NON ANCORA MISURATO.
10. **MIGLIORABILE?** Non so: la cella e' un dirupo su ADX e il rischio a 22 anni e' alto.
11. **COSA SERVE**: round d'uscita (come 2.1), gemello oro v2.00 (R87a/b gia' fatti), **taglia: firma**.
12. **COSTO**: ~5-10 min.
13. **FONTI**: `risultati_prove/ABTG_GoldenCross_Ottimizzato/`, `GoldenCross_forex_r20/`, `REFERTO_ROUND2`, `REFERTO_ROUND4_GOLDENCROSS`, `REFERTO_ROUND20_GOLDENCROSS_FOREX`, `R100_REFERTO`, `CLASSIFICA_PF` #8 (1,58 finestra piena `[NON RIPRODOTTO]`).

---

### 2.3 `ABTG_GoldenCross_V1`   famiglia GC   gruppo G5   ruolo: v1.00 congelata (la versione delle sedie in campo)

1. **MOTORE**: v1.00 senza i 3 fix.
2. **SIMBOLI/TF**: NZDUSD/USDCAD/USDCHF H4, XAUUSD H1 (R87a).
3. **BACKTEST FATTI**: solo **R87a-V1** (19-20/08, tick, `r86_r87_r89_csv/ABTG_GoldenCross_V1_*`).
4. **ANNI e REGIMI**: tick 21-23 mesi, rialzo.
5. **NUMERI**: G01 (3 USD majors) + oro (V1-01): USDCHF 3,628 (20) / 2,188 (17); USDCAD 3,519 (10) / 2,894 (12); NZDUSD 2,777 (8) / 1,668 (14); oro 1,494 (32) / 1,253 (57).
6. **TIPOLOGIE**: USD majors H4, oro H1, solo rialzo.
7. **FORWARD DEMO**: 0 righe.
8. **CLASSE**: **SOPRA · D · `[T]`** (V1-01).
9. **VERDETTO**: MERITO SOSPESO (n IS 8-32, indistinguibile dalla fortuna: `REFERTO_R86_R87_R89_NOTTE` §1). **Non va rimessa in campo** (firma R87). Nessuna cella SOTTO: nessun certificato richiesto.
10. **MIGLIORABILE?** No: e' una versione congelata.
11. **COSA SERVE**: niente.
12. **COSTO**: 0.
13. **FONTI**: `r86_r87_r89_csv/`, `REFERTO_R86_R87_R89_NOTTE`.

---

## 3. COPIE `standalone/` E ORO ESTERNI

### 3.1 `standalone/ABTG_GoldenCross.mq5 · ABTG_SupertrendReversal.mq5 · ABTG_SupertrendReversal_Multi.mq5 · ABTG_SupertrendInvert.mq5`   ruolo: copie "tutto-in-uno" dell'8/09

D12 (piano) **diffato per input, non per riga**: `InpMagic` identici (770301/770901/771001/770801). Input: **GC root 59, standalone 47** (mancano `InpBBDev`, `InpBBExpandBars`, `InpBBExpandMult`, `InpBBPeriod`, `InpUseBBExpand`, `InpComment`, `InpFridayClose`, `InpFridayCloseHour`, `InpHAAutoCount`, `InpMaxDistEma21ATR`, `InpRequireAdxRising`, `InpUsaGuardian`);
ST root 45 contro 40 (mancano `InpComment`, `InpFridayClose`, `InpFridayCloseHour`, `InpLogImbuto`, `InpUsaGuardian`); Multi 42 contro 40; Invert 46 contro 44. Nessun input in piu' nelle copie.
**Conseguenza che corregge il piano**: `standalone/ABTG_GoldenCross.mq5` e' **v1.00** (`#property version "1.00"`, 0 occorrenze di `CrossInWindow`): **eredita la riga di `ABTG_GoldenCross_V1`, non quella della root** (v2.00). Le altre tre non hanno `InpUsaGuardian` ne' `InpComment`: la logica di ingresso e' **presunta** uguale, **non diffata** `[NON VERIFICATO]`.
**Classe**: EREDITA (nessuna misura propria); MIGLIORABILE: no; COSA SERVE: un `diff` riga per riga se qualcuno volesse usarle (0 macchina).

### 3.2 `Gold_Ichimoku_TK_ATR_EA`   famiglia ORO-EXT   gruppo G5   ruolo: esterno (Pine v3 "Claudio"); sedia FANTASMA 250604 (rimossa a giugno)

1. **MOTORE**: Ichimoku "Donchian" (Tenkan 7 / Kijun 22 / Senkou B 44, nuvola corrente), segnale = cross Tenkan/Kijun; filtro Kumo ON; **long-only di default**; uscita su cross; SL 1,5 ATR; rischio 0,5%; XAUUSD H1; **nessun OPTFRAME, nessun input `InpComment`** (misurato nel sorgente da R103). v3.00, 722 righe.
2. **SIMBOLI/TF**: XAUUSD H1.
3. **BACKTEST FATTI**: **R103 blocco forex+metalli** (24/08, `[B]` modello 1, 100.000, **0,5%**, **2020.01.01-2026.06.30**, finestra piena, nessuno split, numeri dai deal del report .htm): `R103_REFERTO_DRIVER_FOREX_METALLI_20260824_1922.txt` r.1866-1930; **R100**: "NON MISURABILE per costruzione" (non esporta); ERRATA R103 25/08: DD equity dal blocco statistiche dell'.htm.
   **Il piano scriveva "nessun PF in archivio" (CENSIMENTO_CONTRATTI_v2 §4e): non e' vero**, R103 ha PF e n (D18).
4. **ANNI e REGIMI**: 2020.01.01-2026.06.30 `[B]` (OHLC M1 nativo): il covid e' dentro; **per anno** (chiusure realizzate): 2020 +44.077 (81), 2021 -15.504 (87), 2022 -6.549 (79), 2023 +10.727 (85), 2024 -3.253 (87), 2025 +45.823 (88), 2026p -835 (46): **4 anni su 7 negativi**; il biennio 2020-22 ha scavato -26,9k del DD di squadra (-72.852 EUR). Regimi: la finestra intera e' la media di piu' regimi, **PF per regime NM**.
5. **NUMERI**: E-01: **PF 1,311, n 553, +75.436 EUR al 0,5% (+150.871 normalizzati a 1%)**; **DD equity 21,52% a 0,5%** (33.005 EUR; sul saldo chiuso 20,87%); peggior giornata -1,07%; `[B]` e' un limite inferiore del DD.
6. **TIPOLOGIE superate**: oro H1, **finestra piena senza OOS** (`SOPRA·sOOS`), `[B]` screening.
7. **FORWARD DEMO**: 250604 XAUUSD **2 righe -82,39** (09/06 -21,10; 19/06 -61,29): le sole due operazioni vere, poi rimossa. Campione che non dice nulla, ma 2/2 perse.
8. **CLASSE**: **SOPRA·sOOS · B · `[B]`** (screening: non promuove).
9. **VERDETTO**: **NO PER RISCHIO** a qualunque taglia sensata (ERRATA R103: ~43% a 1% `[DERIVATO lineare]`; per stare nel muro 10% servirebbe ~0,23%). Nessun certificato richiesto (non e' SOTTO ne' NM). Costo: stop/spread **NM**.
10. **MIGLIORABILE?** No sul rischio; "solo un motore Ichimoku DIVERSO, dall'imbuto, da capo" (ERRATA).
11. **COSA SERVE**: niente su questo EA.
12. **COSTO**: 0.
13. **FONTI**: `R103_REFERTO_FINALE.md`, `ERRATA_R103_ICHIMOKU_2026-08-25.md`, `R103_REFERTO_DRIVER_FOREX_METALLI_20260824_1922.txt`, `CENSIMENTO_CONTRATTI_v2` §4e, `trades_auto.csv`.

### 3.3 `Gold_Scalper_TK_BB_BE_EA`   ruolo: esterno, scalper oro M5 meccanizzato da UN giorno di trade manuale

1. **MOTORE**: due modi d'ingresso su M5 chiuso: (A) cross Tenkan(7)/Kijun(22) confermato da un altro TF; (B) media di Bollinger inclinata su M1 **e** M5; BE; 1.385 righe (il piu' lungo). Il sorgente dichiara "NON una replica fedele garantita".
2. **SIMBOLI/TF**: XAUUSD M5.
3. **BACKTEST FATTI**: **nessuno** (nessun CSV, nessuna riga di registro; `docs/Analisi_Trading_Manuale_Scalper.md`). Il commento v1.10: "in backtest apriva troppi trade (1174/anno) e perdeva" `[DICHIARATO]`, non riproducibile.
4. **ANNI e REGIMI**: NM. 5. **NUMERI**: NM. 6. **TIPOLOGIE**: NM. 7. **FORWARD**: nessuna riga.
8. **CLASSE**: **NM** (E-02).
9. **VERDETTO**: **NON ANCORA MISURATO**. **Certificato**: (1) PF mancante; (2) n/DD mancanti; (3) uscita mai; (4) gemelli: nessuno; (5) TF: solo M5. Costo: il pavimento 40x sull'oro e' **stop >= 8,01 $** (costo pieno 0,2003 $, `ORO_1530_CANCELLO_COSTO` §3); lo stop M5 di questo EA non e' misurato.
10. **MIGLIORABILE?** Non so.
11. **COSA SERVE**: un G0 + FASE 1 sullo stop (misura del costo) prima di spendere un round; **M5 sull'oro con il tetto delle barre (~1,3 anni per corsa)**. Costo: 1 sessione di sviluppo + ~5-10 min.
12. **COSTO**: ~5-10 min + sviluppo.
13. **FONTI**: sorgente; `CENSIMENTO_CASELLE_VUOTE` §3/§6.B (riga 32 "M5 sull'oro: vedi §6"); `ORO_1530_CANCELLO_COSTO_2026-09-10.md`.

### 3.4 `IchiCross_Gold_722` · `IchiTrend_Gold_Base`   ruolo: esterni oro M5 (Ichimoku 7/22/44 + Bollinger in espansione + ADX >= 30; la Base e' il sottoinsieme)

1. **MOTORE**: IchiCross: filtri ON (BB in espansione, ADX >= 30, Kumo, concordanza H1, ora server 8-22), SL 2,75 ATR, trailing 4 ATR, uscita su incrocio, 0,5%; v1.60, 553 righe. Base: direzione Ichimoku + innesco rottura Bollinger + SL/trailing ATR, 1 posizione (README); v1.1, 331 righe.
2. **SIMBOLI/TF**: XAUUSD M5. 3. **BACKTEST FATTI**: nessuno nel repo. Il **commento in testa a `IchiCross_Gold_722.mq5`** scrive "BACKTEST 5 ANNI (XAUUSD M5, tick reali, ADX 30 + orario 8-22): +1421 EUR, PF 1,50, DD ~4,9%, 198 trade, TUTTI e 5 gli anni positivi" = **`[DICHIARATO NEL SORGENTE]`**: nessun CSV, nessun referto, nessuna data, nessun deposito; **per le regole del piano (sez. 5.2.5) non entra** (al massimo apre un parametro).
4-7. NM / NM / NM / nessuna riga.
8. **CLASSE**: **NM** (E-03).
9. **VERDETTO**: **NON ANCORA MISURATO**; certificato: (1)(2) mancanti; (3) uscita: SL/trailing ATR mai ad asse; (4) gemelli: nessuno; (5) TF: M5. Il dichiarato PF 1,50 su 198 trade e' una **ipotesi da riprodurre**, non un numero. Il filtro orario 8-22 e' "ora server del broker" (il commento dichiara "se cambi broker ritara"): l'orologio BCM d'inverno cambia (`OROLOGIO_BCM_2026-09-24`).
10. **MIGLIORABILE?** Non so. 11. **COSA SERVE**: **riprodurre il dichiarato a tick su 21 mesi** (M5 oro, ~1,3 anni per corsa: entra) ~10-20 min + G0; la Base non merita un round a parte (sottoinsieme: `CENSIMENTO_CASELLE_VUOTE` #34).
12. **COSTO**: ~10-20 min.
13. **FONTI**: sorgenti, `README_IchiTrend_Gold.md`, `CENSIMENTO_CASELLE_VUOTE` r.131-132.

### 3.5 `ORB_GOLD_FIBONACCI_EA` (v2.20) · `ORB_GOLD_FIBONACCI_EA_v3.21` · `GoldBreakout_Levels`

1. **MOTORE**: ORB oro (webinar Monza): OR 15:30-16:00 CET (apertura New York), filtro OR in $, filtro **D1 EMA200** (solo long in bull trend), breakout confermato, **ordine LIMIT al 61,8% Fibonacci**, SL al 78,6%, TP al 0%, trailing EMA9 dopo TP1. **v2.20**: descrizione "Risk=5%"; **v3.21**: sessioni Londra 10:00-10:30 + NY, FIB1 61,8% / FIB2 50%, **rischio 1,5%**, MaxDailyLoss 2%, MaxMonthlyLoss 5%, **`InpBrokerCETOffset=-1` "per BCM"** (segno `[INFERITO]` dubbio, e **fisso** contro un orologio che d'inverno cambia: `CENSIMENTO_ORB` r.139). `GoldBreakout_Levels` v1.30: consolidamento di N candele vicino a un livello chiave (open D/W, max/min giorno prec., pivot, numeri tondi) -> breakout, SL oltre il box, trailing ATR, XAUUSD H1; "DA VALIDARE su backtest multi-anno + forward demo".
2. **SIMBOLI/TF**: XAUUSD M5 (ORB), H1 (Levels).
3. **BACKTEST FATTI**: **nessuno** su questi tre EA (`CENSIMENTO_ORB` r.63/271: "nessun CSV"; GoldBreakout: nessuna riga in nessun registro). **Evidenza vicina, di un altro EA**: `ABTG_ORB` su XAUUSD R10 (4 celle, OOS 0,87-0,999: "oro breakout ORB mai verde"), `ABTG_Londra_ORB` R45a 0/8, la sonda 15:30 su M1 (fenomeno assente + costo 5-6x): sono misure **del meccanismo**, non di questi EA.
4-7. NM. 8. **CLASSE**: **NM** (E-04).
9. **VERDETTO**: **NON ANCORA MISURATO**. **Certificato**: (1)(2) mancanti; (3) uscita mai (limite 61,8%, trailing EMA9); (4) gemelli: nessuno; (5) TF: M5 / H1 soli. **Il rischio dichiarato (5% v2.20, 1,5% v3.21) e' sopra ogni taglia di casa**: va dichiarato accanto a ogni futura misura.
10. **MIGLIORABILE?** Non so. 11. **COSA SERVE**: `CENSIMENTO_ORB` M9: v3.21 su XAUUSD OHLC M1 2020-2026 con commissione (2-4 passate, screening) + fuso (G0); l'ORB con range 30-60 minuti su M30/H1 sull'oro **e' mai misurato** (la frontiera del costo lo lascia passare: M30 con stop >= ~8,8 $, margine +9,7%; H1 +55%, `CENSIMENTO_ORB` r.277). **Nessun EA esterno e' schierabile**.
12. **COSTO**: ~5-10 min per M9.
13. **FONTI**: sorgenti, `CENSIMENTO_ORB_2026-09-29` r.17, 63, 139, 197, 271, 277.

---

## 4. PUNTI DUBBI: D3 e D4 CHIUSI, NUOVI APERTI

| id | punto | stato |
|---|---|---|
| **D3** | PF su finestra piena senza OOS = "SOPRA (senza OOS)" | **Applicata**: C01, C02 (CAC), W04 (Dow H4 8 celle), U06, E-01 (oro) e G05 sono `SOPRA·sOOS`. Dove una cella ha anche un OOS (Ott oro H4), vale l'OOS e il "2,74 finestra piena" non e' una classe. |
| **D4** | `SupertrendReversal_Ottimizzato` 2,74 contro OOS mediano 0,92-0,99 | **RICONCILIATO COME "OGGETTI DIVERSI", E IL 2,74 RESTA `[NON RIPRODOTTO]`.** (1) il **2,74** e' il PF "bt" della finestra piena 2024.01-2026.06 del 26/07 (`CLASSIFICA_PF` #3): **nessun CSV in repo lo contiene** (cercato `2.74`/`3.17` in tutti i CSV G5: zero); (2) la **cella H4** ha, con lo split 08/08, **IS 4,752 (22) / OOS 2,253 (30)** (stessa EA, stesso simbolo, stesso TF, finestra spezzata); (3) lo **"0,92-0,99"** e' la **mediana dei PF OOS delle 11 righe TF** del file TF-scan (tick 0,9167, OHLC 0,9876; **rifatta da me**): non e' una cella. Le tre cifre non si contraddicono perche' non sono lo stesso oggetto. Lo stesso vale per **Multi_Ott** ("1,14-1,71" = mediana TF tick 1,143 / OHLC 1,303 / mediana di 5 righe StMult 1,714), **Multi** ("0,77-0,81" = 0,767 / 0,809) e **Dow H4** ("PFmed IS 0,741 / OOS 0,921" = mediane TF). **Resta aperto** che il 2,253 e' un picco (vicini H2/H3/H6 sotto 1 in entrambe le finestre) su n 30 deal e che l'IS H4 4,752 su n 22 e' dentro il "pettine" gia' certificato (`RIESAME` 22/09). |
| D14 | **SEGNO INVERTITO come norma** | **19 righe su 91** (SOPRA·INV 15 su 60; SOTTO·INV 4 su 31; piu' celle INV dentro righe raggruppate, es. S06 H3, S23 St 4,5, H06, M02, O07, X03, Y07): S15 S16 S19 S22 S25, U02 U05, O02 O04 O06, Y04, D01 D03, W02, C02, V01, H02 H04, G04. La classe "NON CONFRONTABILE/REGIME" resta **una proposta di Claudio**: qui l'INV e' segnalato, non risolto. Il caso piu' pesante e' **r127b**: sull'oro `[B]` 22 anni il motore perde 7/7 celle nell'IS 2004-2013 (il toro dell'oro) e guadagna 7/7 nell'OOS 2013-2026. |
| D15 | **"nativi ≈ ottimizzati"** (`CLASSIFICA_PF` "Nativi oro ≈ ottimizzati, l'ottimizzato bake-a i parametri") | **non e' una misura**. Il nativo `SupertrendReversal` oro H4 (default 3,5/10/2,0) a tick fa **0,337 / 0,765**, il `Multi` 0,709 / 0,686: **il PF "~2,74 / ~3,17" dei nativi del piano e' l'assunzione, non un numero**. Le righe 'nativo' del piano (sez. 4 #67, #69) vanno riscritte. |
| D16 | mediane TF/StMult citate come "PF OOS" del censimento | vedi D4; **il metodo "un keeper si giudica sulla mediana"** (`REGISTRO_TEST` r.620) applicato a una mediana su 11 TF **include TF esclusi per costo e righe con n 0** (Dow H4 D1 n 0): e' una mediana che non risponde alla domanda "regge la cella?". |
| D17 | numeri senza CSV: 2,74 · 3,17 · 1,58 (GC Ott) · 0,79 (Dow H4) · PFmed 1,46/1,37/1,05 (CLASSIFICHE) | `[NON RIPRODOTTO]`: il CSV batte il referto. |
| D18 | `Gold_Ichimoku_TK_ATR_EA` ha una misura (R103, PF 1,311 su 553, `[B]`) | il piano dice "nessun PF": **corretto**. |
| D19 | **round scritti senza CSV in repo**: R120a/c/d, A1 `SUPREV_DOW_H1`, G1PAOLO_00/01/10/11/12, R124a, R132a/b, R163a, R166a, R190c, R237a/b, `PASSATA_STOP_SUPREV`; **R236/R238 hanno solo i numeri nei referti** | R163a/R166a risultano "ROUND_r163a/r166a" sul banco nei log 18-20/09 (solo il file prova): **stato di esecuzione `[NON VERIFICATO]`**. Tutti NM. |
| D20 | **magic**: `770901` = oro (piccolo) e Nikkei H2 (100k); `970913` (sorgente) contro `970925` (grafico NAS H1); `770925` = ST base NAS H1; `771001` forward = la Multi base | `CENSIMENTO_CONTRATTI_v2` M-C8; non risolto. |
| D21 | **R99/R100: PF e n per finestra di regime non sono in repo** (zip fuori) | PF per regime sull'oro `NM`; il DD dei 4 regimi c'e'. |
| D22 | `LE_QUATTRO_EPOCHE` r.136 scrive per `SupertrendReversal_Ott` "4/7 anni negativi" | la tabella del driver R103 (r.1822-1832) ne mostra **3** (2020, 2021, 2023): `[NON RICONCILIATO]`. |
| D23 | copie `standalone/` | vedi 3.1: GC standalone = v1.00. |
| D24 | **GoldenCross v1.00 in campo, v2.00 a HEAD**, e tutto il pre-19/08 e' v1.00 | decisione di Claudio (ricompilare); le celle del 08/08 vanno lette come v1.00. |
| D25 | **SupRev NAS H1: tre cifre per la stessa cella** (3 binari) | elencate in Y01, non riconciliate; stessa parte di 1: la classe non cambia. |

---

## 5. COSA MIGLIORARE PER PRIMA (max 5, nessun criterio abbassato, ognuno con costo e firma)

1. **`SupRev_NAS_H1_Ottimizzato` (970913): G0 sul binario in campo + R163a + misura diretta del costo.** E' la cella di G5 piu' vicina a una sedia: IS e OOS sopra 1 in 3 misure indipendenti, DD OOS 0,86-1,29% a 1%, asse stop piatto (9/9 sopra), asse StMult a cresta. Le tre cose che la fermano sono **il costo (28,7x contro 40x, stima di casa, misura diretta mai fatta)**, **il binario (3 cifre, scarto 6,7-8,9x la tolleranza)** e **il campione (n 86-96 deal)**. G0 ~3-5 min + R163a (14 passate) ~3-5 min `[STIMA da R127a]` + FASE 1 (sviluppo). **Firma: no per le misure** (round di misura sul PC di backtest; riga e prova passano dai cancelli); **la sedia/taglia sarebbero firme di Claudio**.
2. **`PASSATA_STOP_SUPREV` + R120 (uscita ad asse) su tutta la famiglia.** La passata (pronta, PASS 24/09, pin `7e255a82`, sospesa il 21/09): **15-25 min**, 2 passate U30USD H1: chiude il costo 40x del corto indici (R243a: IS 1,292 / OOS 1,643, n 68/78, DD 3,3-3,7%). R120a/c/d: `InpTrailOnST`/`InpExitOnFlip`/`InpFirstFraction` mai ad asse in 13 EA su 13 e **prerequisito della casella 3 per ogni SOTTO/NM di G5**: ~36 celle / 72 passate nel dossier del 09/09, **~10-60 min** a seconda dei simboli `[STIMA]`. Firma: no per le misure.
3. **Oro: recupero zip R99/R100 (zero macchina) + G0 H4 sul binario attuale (~8-10 min).** Dice se l'IS 4,75 / 4,51 esiste ancora, rende confrontabile l'OOS e da' finalmente il **PF per regime** sull'oro 22 anni (oggi solo il DD): senza questo i `2,74 / 3,17` restano `[NON RIPRODOTTO]` e il rischio a 22 anni (9,02% / 16,90% a 1%) non ha il suo merito accanto. Firma: no per le misure; **la taglia dell'oro e' di Claudio**.
4. **R113 coda "feed o epoca?"**: 3 celle ~2 minuti (firma lampo dei criteri): decide se sul Nasdaq la prova di regime e' possibile (il motore a 13,3 op/anno su `_EXT` contro 77 sul nativo) o e' un artefatto del feed. Senza questo il "regime" di `SupRev_NAS_H1` resta `NM` per costruzione.
5. **`SupertrendInvert`: diagnosi del perche' non opera** (sonda a contatori, **zero passate di tester**, poi G1PAOLO_10/11/12 ~3-6 min): oggi e' l'unico EA G5 che non ha nemmeno un numero leggibile. Firma: no.

*(Non in lista, per regola 19/08: nessuna griglia nuova sui parametri della famiglia SupRev (Dow H1: asse StMult dichiarato non robusto, A6; R135a ritirato) ne' sul GoldenCross (R87b: nessun preset da una griglia). Il SupRev su Dow/CAC/DAX H4 non ha campione prima del 2027.)*

---

## 6. CONTROLLI E RICONTEGGIO (Sviluppatore / Agente dei Controlli, prima di consegnare)

**Contro-esempi costruiti da me** (regola 10/09):
- *"La riga NAS H1 e' SOPRA su tre misure: forse e' un picco su TF."* Non lo e' alla maniera del Dow: H1 e H2 sono sopra (1,342/1,688 e 1,027/1,356), M30 e H3 sotto; ma lo StMult e' una **cresta di due celle (3,0-3,5)**, lo dice `REFERTO_ROUND3`. Lo scrivo: cresta stretta, non altopiano.
- *"L'asse stop R127a e' piatto quindi il costo e' risolto."* No: R132 avverte che il trailing puo' stringere lo stop effettivo; i CSV R127a mostrano PF e DD che si muovono (OOS 1,497-1,721; DD 0,98-1,31%), quindi la manopola **non e' inerte sul risultato**, ma **se allarghi lo stop effettivo (e il costo) NON e' misurato**.
- *"Il 2,74 e' sparito perche' lo split lo ha ammazzato."* No: l'OOS della stessa cella e' 2,253. Le due cifre non si escludono; il 2,74 e' solo non riproducibile.
- *"Le mediane TF le ho rifatte a occhio."* Rifatte con codice sui CSV: 0,9167 / 0,9876 (Ott), 1,1428 / 1,3026 / 1,7144 (Multi Ott), 0,7669 / 0,8087 (Multi), 0,7407 / 0,9208 (Dow H4 IS/OOS): coincidono con il censimento al quarto decimale.
- *"GoldenCross standalone eredita la root."* Falso: e' v1.00 (0 `CrossInWindow` contro 5).
- *"Il forward conferma/smentisce."* Non lo uso: 0 righe sui GC, 2-9 gambe sulle SupRev.

**Cosa NON ho verificato** (`[NON VERIFICATO]`): gli scan OHLC a finestra unica (censimento 09/09: 118 + 113 righe + 10 `SupRevScr`) e i TF-scan OHLC di `SupertrendReversal` D30EUR / `SupRev_CAC_H4` non letti cella per cella (solo citati con i conti); R110 per i lati (CSV fuori repo); R236/R238 (CSV fuori repo); lo stato di esecuzione di R163a/R166a/R190c/R237; il deposito dei round R123; la finestra esatta delle prove FASE 0 del 07/08 (dedotta dalla riproduzione al centesimo con R2/R3).

**Ricontaggio** (tabella 0.3, righe per classe, `grep` sulla colonna 4 del file):

| classe (tabella 0.3) | righe | `·INV` | `·sOOS` |
|---|---:|---:|---:|
| SOPRA | **60** | 15 | 5 |
| SOTTO | **31** | 4 | -- |
| NM | **6** | -- | -- |
| **totale** | **97** | 19 | 5 |

Per EA (da `grep`): ST base 14/13/1 · ST Ott 5/1/0 · ST Multi 1/2/0 · ST Multi Ott 6/2/0 · DAX H4 3/1/0 · NAS H1 8/4/0 · DOW H1 4/2/0 · DOW H4 3/1/1 · CAC H4 2/0/0 · DAX H1 2/1/0 · Invert 0/0/1 · GC 6/2/0 · GC Ott 4/2/0 · GC V1 1/0/0 · Gold_Ichimoku 1/0/0 · Scalper 0/0/1 · IchiCross+IchiTrend 0/0/1 · ORB_GOLD+GoldBreakout 0/0/1 (somma SOPRA 60, SOTTO 31, NM 6). **La tabella 0.2 (per EA), la tabella 0.3 (per cella), le schede e questo ricontaggio dicono la stessa cosa.**
Verifiche fatte prima di consegnare: ogni PF/n/DD di una riga con CSV in repo e' stato letto dal CSV con uno script (non ripreso dalla prosa); le righe senza CSV (R236/R238, R110 lati, R103, R99, CLASSIFICHE) sono marcate `[DICHIARATO]` o `[NON RIPRODOTTO]`; le mediane TF sono state **ricalcolate**; il fattore deal/posizioni NON e' stato inventato.

**Cosa resta da fare prima di qualunque uscita**: il cancello (`controllo-preventivo`, Opus) sui numeri; una seconda lettura indipendente sulle righe `[DICHIARATO]` e sul join R87b (calcolato da me, non da uno strumento di casa); una conferma di Claudio su **D2** (soglia di zona grigia: le celle con PF 1,00-1,10, S12 H1 1,073 e W04 PFmed 1,07 sono qui `SOPRA` per la regola del punto stima, ma sono **indistinguibili da 1** finche' D2 non e' firmata).

## CHANGELOG
| data | cosa | perche' |
|---|---|---|
| 05/10/2026 | creato il file (FASE 2, ondata 2, gruppo G5) | richiesta di Claudio del 05/10/2026: resoconto PF sopra/sotto 1 per ogni EA |
