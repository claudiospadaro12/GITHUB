# Aperture del Dow: mappa dei motori, costo per TF, orologio e le tre misure (03/10/2026)

Mandato di Claudio (03/10): lavorare sulle aperture intraday del Dow (`U30USD` su BCM, `US30.cash` su FTMO), breakout e retest, long e short sempre entrambi, TF da M5 a H4.
Autore: `cercatore-parametri`. Perimetro: **sola lettura del repo** (HEAD `dcf9f960`, branch `lavoro`) piu' due file prova nuovi. Nessun backtest lanciato, nessuna riga di lancio scritta, nessun EA, preset, taglia, conto o terminale toccato.
Etichette: **[MISURATO]** = letto o ricalcolato da un file del repo · **[DERIVATO]** = calcolo su numeri misurati, convenzione dichiarata · **[INFERITO]** = ragionamento · **[NON MISURATO]** = buco.

---

## 0. In dieci righe

1. **La premessa "abbiamo lo storico ampio" per il Dow NON regge.** BCM `U30USD` parte il **2024.09.26** (M1 650.255 barre, 67,6 milioni di tick) [MISURATO, `risultati_archivio/misura_tick/REFERTO_MISURA_TICK_U30USD.txt`]. HistData il Dow non ce l'ha; Dukascopy `USA30IDXUSD` si' (dal 2012) ma **non e' stato scaricato un byte** oltre la finestra di validazione (222 giorni, 2024-10 -> 2025-06) [`report/COME_ALLUNGARE_STORICO_INDICI_2026-09-09.md` r.133-145]. Quindi **ogni numero Dow di questa mappa e' un solo regime** (toro, con il crollo di aprile 2025): l'Emendamento C non e' soddisfatto da nessuna cella.
2. **Esiste UNA sola cella d'apertura del Dow che passa insieme PF >= 1,10 in IS e OOS e n >= 150 in tutte e due**: il breakout a due lati, range 15', filtro EMA H4 (il "candidato #1"). Centro dell'altopiano misurato: `InpEmaSlow=220`, TP1_R 0,50: **IS 1,25920 su 157, OOS 1,48133 su 199, DD 7,17 / 6,62 % a rischio 1 %** [MISURATO, `risultati_archivio/ROUND_CORTI_B_2026-09-27/ROUND_R262b/`].
3. **Ma non e' schierabile**, per quattro motivi misurati: (a) a rischio 2,00 % **0 celle su 48** stanno sotto il muro del 10 % (muro fra 1,25 e 1,50 %: R263); (b) **in fase con la cash** (cio' che FTMO fa tutto l'anno) il candidato fa **PF 0,964 su 132** nella finestra A [R250], il merito sta tutto nell'armare **1h prima** (8:30 New York); (c) finestra vergine 01/07-18/09/2026 (tutta estate): **PF 0,514 su 39, DD 8,38 %**, sopra il p95 della sua promessa [R248]; (d) copre il **96 %** dei giorni della sedia viva `770202`.
4. **La sedia viva `770202` (retest long) in fase con la cash perde**: estate PF 0,886 su 84 posizioni, d'inverno alla cash PF 0,916 su 40; serie "come FTMO" PF 0,836 su 123 (sospesa: G1 di R246a/c ancora aperto) [R246, R246 inverno]. Il suo contratto (OOS 1,270 su 96 posizioni) mescola due tempistiche.
5. **Il lato short e' misurato e non regge** (R54a OOS 0,840 su 73; R255 in fase 0,78 su 46); gli unici indizi (Supertrend H8/H12) hanno n 39-46 e una cella sola isolata: **"non c'e' una configurazione robusta"** (R255 M4).
6. **TF, il numero che serve**: sul motore d'apertura il TF del grafico e' una manopola **inerte per sorgente** (range letto su `PERIOD_M1` cablato): M15, M30, H1, H4 darebbero gli stessi CSV di M5. I TF che mordono davvero sono **sei input separati** (filtro EMA, trailing, Supertrend, OPENCONFIRM...), e **cinque su sei non sono mai stati messi ad asse sul Dow**. Escluso per costo, col numero: nessun TF sul breakout/retest (stop = range, non barra); sul FADE M5 11,4x e M15 19,8x; sui motori a barra (EMA200 `U30USD`) M5 4,96x, M15 14,4x, M30 28,1x contro 40x (BCM 1,90, k 0,968 [DERIVATO]).
7. **Costo del candidato: 41,25x "al pelo"** (stop 123,75 su spread prudente 3,00) e **il 47,5 % delle giornate sta sotto 40x** (212/446, ricalcolato qui). Con lo spread FTMO US30 2,63 [MISURATO n=1 tick]: 47,1x alla mediana, **40,8 % delle giornate sotto frontiera** (182/446, ricalcolato).
8. **Orologio**: BCM e' UTC+1 fisso sugli indici su tutto l'arco 2024.09.26+. Dal **02/11/2026** (USA solare dal 01/11) `14:30` BCM = 8:30 New York, un'ora prima della cash. **Quasi tutte le celle misurate mescolano le due tempistiche**; non la mescolano R246, R246 inverno, R250 (finestra A), R255 (curve per stagione) e R248 (tutta estate).
9. **Le tre misure proposte**: (1) **R280** (file prova nuovo, 16 passate, ~5 minuti): il filtro del candidato su H1, l'unico TF la cui griglia e' identica su BCM e FTMO; (2) **rilettura di R250 finestra B** con l'eccezione dei festivi gia' firmata per R255: **0 minuti macchina, 1 firma**; (3) **R215a** (gia' scritto e verde, 8 passate, ~3 minuti): lo stesso dubbio sulla sedia viva `770202`.
10. **Cosa dice sul default**: nessuna cella di nessun asse misurato batte il default oltre il rumore. `InpEmaSlow` 160-280 e' un altopiano piatto (R262: "il 200 va bene"); TP1_R, offset, BEatR sulla sedia viva: **"il default va bene"** (R172D, R197B, R202A). E' un risultato.

---

## 1. La mappa: motore x direzione x TF

Finestra BCM per tutti: `2024.09.26 -> 2026.06.30` (salvo dove scritto), tick reali modello 4 (salvo dove scritto), IS fino a meta' 2025, OOS dopo. **n in colonna = quello scritto dalla fonte**: dove la parziale e' accesa e' il numero di **deal**, non di posizioni (classe 550); lo dico accanto.

### 1.1 Apertura Dow, RETEST (sedia viva `770202`: range 35', buffer 1000, offset 400, TP1_R 1,0, parziale 50 %, BE, trailing PREVBAR M5, filtro EMA H4 1/50, 1 operazione/giorno)

| direzione | TF | stato | PF / n / DD | finestra, regime | fonte |
|---|---|---|---|---|---|
| **LONG** | **M5** | [MISURATO] | IS **1,22173** / 74 deal / 5,67 % · OOS **1,27175** / 130 deal (**96 posizioni**) / 4,39 % (rischio 1 %, banco 80k) | IS 2024.09.26-2025.06.09, OOS 2025.06.10-2026.06.30; un regime (toro) | `risultati_prove/R202A/ABTG_Dow_Apertura_US_U30USD_{IS,OOS}_R202A.csv` riga TP1_R 1,00; registro `REGISTRO_TEST.md` r.4143-4153 |
| LONG | M15, M30 | **[NON MISURATO]**, inerte per sorgente | R214a/b (4+4 passate) scritti, **mai girati** | — | `prove/R214a_tfgrafico_M15_DOW_770202.txt`, `R214b_...M30...` |
| LONG | H1, H4 (grafico) | [NON MISURATO]; nessun file scritto | — | — | stessa lettura di sorgente |
| LONG | M5, per stagione | [MISURATO] | estate PF 0,886 / 84 pos · inverno 1,493 / 68 pos (netto: 118 % dall'inverno) | A+B, calendario USA | `report/IL_MERITO_E_D_INVERNO_2026-09-25.md` §2.2 |
| LONG | M5, orologio | [MISURATO, SOSPESO G1] | -1h estate 1,038 / 137 pos · d+1 inverno (alla cash) **0,916 / 40 pos** · serie "come FTMO" 0,836 / 123 pos | R246 | `report/REFERTO_R246_2026-09-24.md` §5.1; `report/LETTURA_R246_INVERNO_2026-09-29.md` |
| LONG | M5, finestra vergine | [MISURATO] | `770202` PF 0,837 / 11 pos / DD 1,45 % (rischio coerente) | 01/07-18/09/2026, estate | `report/REFERTO_R248_2026-09-25.md` |
| **SHORT** | M5 | [MISURATO] | solo short: IS **1,511** / 73 / 2,68 % · OOS **0,840** / 73 / 8,62 % (DD fisso ~17,5 % a 2 %, limite superiore) | 14:30 BCM tutto l'anno, 100k, 1 % | `risultati_archivio/REFERTO_ROUND54_LATI_DOW.md`; `report/SEDIA_SHORT_DOW_FTMO_2026-09-26.md` §6.2 |
| SHORT | M5, **in fase**, filtro EMA | [MISURATO] | OOS in fase PF **0,775 / 46 pos** (IS in fase 0,771 / 40 pos; DD 5,13 %; BOCCIATA per rischio R2) | R255, 2 orologi | `report/LETTURA_R255_2026-09-28_B_EMENDATA.md` §6 |
| SHORT | Supertrend filtro H8 / H12 / D1 | [MISURATO] | OOS in fase PF 2,404 / 46 pos · 1,262 / 39 · 0,555 / 28; IS in fase 0,968 / 37 pos (H8) | stesso | idem, righe `ESITO stH8/stH12/stD1`: **merito sospeso (n < 150), M4 "non c'e' una configurazione robusta"** |
| entrambi i lati | M5 | [MISURATO] | long+short IS 1,372 / 147 · OOS 1,096 / 203 / 8,68 %: lo short **scalza** il long (ribaltamento IS->OOS) | R54a / R6 | `REFERTO_ROUND54_LATI_DOW.md`, `REFERTO_ROUND6_DOW.md` |
| (entry mode) | M5 | [MISURATO] | stessa cella: BREAKOUT IS 0,96503 / OOS 1,18772; **RETEST IS 1,21214 / OOS 1,25384** (rischio 2 %, 80k) | R197A | `REGISTRO_TEST.md` r.4143 |
| (offset) | M5 | [MISURATO] | offset 400 = centro dell'altopiano (OOS 1,07-1,28, DD OOS 8,75-9,44 a 2 %) | R197B | r.4144 |
| (TP1_R, BEatR) | M5 | [MISURATO] | TP1_R 1,00 e' il bordo dell'asse: R202A 0,25 / 0,50 / 0,75 / **1,00** = OOS 0,93 / 1,10 / 1,14 / **1,27**; BEatR 0-0,90: nessuno batte la viva | R202A, R172D | r.4152, r.4140 |
| (durata del range) | M5 | [MISURATO] | OOS PF 15': 1,42, 25': 1,48, 30': 1,36, **35': 1,28**, 45': 1,68, 50': 1,66, 60': 1,17; Spearman IS->OOS -0,13; "crinali, non altopiani" | R35 | `risultati_archivio/REFERTO_ROUND35_RANGE_APERTURA.md` |
| (filtro EMA acceso/spento) | M5 | [MISURATO su altra config.] | spento PF 1,03 / DD 14,9 % · acceso 1,24 / 6,9 % (gestione nuda, 2024.01-2026.06) | `risultati_archivio/Dow_Apertura/DOW_MOTORE.md` |

### 1.2 Apertura Dow, BREAKOUT a due lati (candidato #1: `ABTG_Nasdaq_Apertura_US` su `U30USD`, range 15', buffer 200, filtro EMA H4 1/N, TP1_R 0,50, `ClosePct 0`, trailing PREVBAR M5)

| direzione | TF | stato | PF / n / DD | finestra, regime | fonte |
|---|---|---|---|---|---|
| **due lati** | **M5** | [MISURATO] | centro **220 / 0,50**: IS **1,25920** / 157 / 7,1736 % · OOS **1,48133** / 199 / 6,6241 % (n = posizioni) | IS 2024.09.26-2025.06.30, OOS 2025.07.01-2026.06.30; deposito 10000, rischio 1 % | `ROUND_R262b/ABTG_Nasdaq_Apertura_US_U30USD_{IS,OOS}_R262b.csv` (letti qui) |
| due lati | M5, altopiano | [MISURATO] | `InpEmaSlow` 160-280 passa (3 TP su 4), 300/320 no; **centro 220**; vs 200: +0,0023 ("il 200 va bene") | R262 | `REGISTRO_TEST.md` r.4574 |
| due lati | M5, griglia 40 celle | [MISURATO] | OOS 40/40 con PF >= 1,10 (1,267-1,560, mediana 1,374), n OOS 186-198; **IS n 138-154: solo 12 celle su 40 arrivano a 150**; Spearman IS->OOS -0,357 (PF), -0,384 (DD) | archivio 05/08 (binario d'agosto) | `report/DOW_BREAKOUT_DUE_LATI_IL_BUCO_2026-09-22.md` §3 |
| **LONG** (lato) | M5 | [MISURATO] | IS 0,92-1,01 (84-93) · OOS **1,46-1,59** (156-171) | R245e/f, EmaSlow 160-260 | `report/REFERTO_R245_2026-09-24.md` §5 |
| **SHORT** (lato) | M5 | [MISURATO] | IS **1,58-1,84** (68-79) · OOS 0,79-1,20 (30-42): i lati **si scambiano i ruoli** fra IS (crollo 2025) e OOS (toro) | idem | idem |
| due lati | M5, rischio alla taglia | [MISURATO] | DD OOS 7,01 / 8,73 / 10,43 / 12,15 / 13,81 % a rischio 1,00...2,00; **0/48 celle sotto il 10 % a 2 %**; muro a 1,25-1,50 % | R263 | `REGISTRO_TEST.md` r.4575 |
| due lati | M5, finestra vergine | [MISURATO] | PF 0,514 / 39 pos / DD 8,38 % (p95 7,31, p99 9,30): RISCHIO SOPRA BANDA | 01/07-18/09/2026 (estate) | `REFERTO_R248_2026-09-25.md` |
| due lati | M5, per stagione | [MISURATO] | estate 0,982 / 199 · inverno 1,800 / 152 (102 % del netto d'inverno); replica vera solo l'IS (+0,420, p 0,206) | R247 + merito_inverno | `IL_MERITO_E_D_INVERNO` §2.1, §2.3 |
| due lati | M5, orologio (finestra A) | [MISURATO, B nulla] | d0 1,2518 / 154 · -1h estate **1,155 / 82** · +1h inverno 0,907 / 53 · curva **IN FASE PF 0,964 / 132** · curva **PRE-MERCATO (8:30 NY) PF 1,2911 / 157, DD 8,92 %** | R250 A | `report/LETTURA_ROUND_CORTI_A_2026-09-28.md` sezione R250 |
| due lati | **TF filtro H1-H4** | **[NON MISURATO]** | mai in nessun CSV (InpFilterTF varia in 0 CSV su 221 della famiglia) | — | `report/RIESAME_MORTI_APERTURE_2026-09-22.md` punto 5; **R280a** lo prepara |
| due lati | TF trailing | **[NON MISURATO]** sul Dow | solo il Nasdaq RETEST: M5 resta (unico TF positivo in IS e OOS con DD OOS < 10 %) | R200A | `REGISTRO_TEST.md` r.4149 |
| due lati | TF grafico | [NON MISURATO], inerte per sorgente | — | — | `report/MAPPA_COSTO_SIMBOLI_TF_2026-09-24.md` §1 |
| (blocco finale) | M5 | [NON MISURATO] | sovrapposizione con `770202`: 96 % dei giorni (R247); correlazione e DD additivo 9,56 % sui 10 giorni comuni della finestra vergine | R247/R248 | `report/CENSIMENTO_ORB_2026-09-29.md` M6 |

Studio d'apertura (OHLC M5, 14:30, buffer 200, TP 2R, **non e' un verdetto**): sui 446 giorni il breakout cieco vale **+0,074 R/trade** (LONG +0,095 su 231, SHORT +0,052 su 215), col filtro H4 +0,126 (212) — il Dow e' il primo degli 8 indici [MISURATO, `risultati_archivio/studio_apertura/Studio_U30USD_RIEPILOGO.csv`].

### 1.3 ORB_Ottimizzato su `U30USD` (sedia `770611`; copia di prova `770621`), M5, range 14:30-14:45, solo long, EMA200 + trailing EMA9

| direzione | TF | stato | PF / n / DD | fonte |
|---|---|---|---|---|
| **LONG** | M5 (`InpExecTF`=5 in tutte le passate) | [MISURATO] | HALFRANGE IS 1,250 / 71 / 7,89 % · OOS **1,674** / **119** / 9,76 % (100k, 1 %); OPPRANGE OOS 1,642-1,844 / 119 / DD 3,70-5,87 %, **IS 0,934-1,087 (0/12 celle >= 1,10)** | `risultati_archivio/r88_csv/ABTG_ORB_Ottimizzato_U30USD_{IS,OOS}_r88a.csv`; `report/CHI_E_PIU_VICINO_AL_CAMPO_2026-09-24.md` §3.3 |
| LONG | n | **n e' INVARIANTE a 71/119 su tutte le 48 celle**: lo stop non crea ingressi; nessuna griglia sullo stop portera' questa sedia a 150 | idem |
| **SHORT** | M5 | [MISURATO] | OOS **0,520**, DD 26,37 % (asimmetria strutturale); due lati 1,0475 / n 219 / DD 17,16 % | R54b, `CENSIMENTO_LATI_SHORT_2026-08-25.md` r.48 |
| LONG | TF != M5 | **[NON MISURATO]** | R133b e' etichettata M30 nel registro ma gira `-Periodo M5`: **la casella TF non e' chiusa** (C5 del censimento) | `CENSIMENTO_ORB_2026-09-29.md` §9 C5 |
| LONG | forward | [MISURATO, n = 15] | 3 vinte su 15, -295,58; fuori dalla rosa il 18/09 | idem M13 |

### 1.4 Altri motori che girano sul Dow (non "apertura", ma nel mandato: EMA200, SuperWave, ApertureCore, R-rounds)

`ApertureCore` e' un **include condiviso** (`ABTG_ApertureCore.mqh`, DAX/Dow/Nasdaq), non un EA: nessuna cella propria [`report/UNA_FAMIGLIA_O_DUE_2026-09-18.md` r.78].

| motore | direzione | TF | PF / n / DD | fonte |
|---|---|---|---|---|
| **EMA200 `U30USD`** (771531) | due lati | **H1** | IS **1,20110** (237 deal, 132 pos) / 5,73 % · OOS **1,52365** (517 deal, 257 pos) / 7,83 % (1 %) | `prove/R110_CSV_EMADOW/*_00_metro.csv`; `report/EMA200_DOW_COSA_MANCA_PER_IL_1_OTTOBRE_2026-09-17.md` §3.2 (132 / 257 posizioni) |
| EMA200 `U30USD` | **LONG** | H1 | IS 1,162 / 112 / 2,64 % · OOS 1,241 / 241 / 8,90 % | `prove/R110_CSV_EMADOW/*_01_long.csv` (deal) |
| EMA200 `U30USD` | **SHORT** | H1 | IS 1,232 / 125 / 4,51 % · OOS **1,891** / 302 / 2,66 % | `*_02_short.csv` (deal) |
| EMA200 `U30USD` | due lati | **M15 / M20 / M30 / H1 / H2 / H3 / H4** | IS: 0,771 / 1,117 / 1,034 / **1,201** / **2,599** / 2,152 / 1,660 · OOS: 0,954 / 0,833 / 0,907 / **1,524** / 1,173 / 0,908 / 1,425 · DD OOS: 26,3 / 30,7 / 15,9 / 7,8 / 6,1 / 9,0 / 4,4 % · deal OOS 2020 / 1642 / 1268 / 517 / 266 / 170 / 116 | `risultati_prove/dal_vps/ABTG_EMA200/ABTG_EMA200_U30USD_{IS,OOS}_cemad05.csv` (letto qui, colonna `InpTF` 15, 20, 30, 16385, 16386, 16387, 16388) |
| EMA200 `U30USD` | stagione | H1 | estate 2,053 / 169 · inverno **0,868 / 88** (un solo inverno, finestra 2025.06.12-2026.06.26) | `IL_MERITO_E_D_INVERNO` §2.5 |
| EMA200 `U30USD` | per lato, regime | H1 | `LATI_A1/A2` (discesa/toro, 4 file) scritti, **mai girati**; `R234a` (TF corto), `R190a`, `R208a` scritti, mai girati | `prove/` |
| **SuperWave DOW H1** (770511) | due lati | H1 | R103 +7.280 / PF 1,28 / DD 4,14 % / 290 deal (OHLC); tick OOS 1,220 / 184 / 4,21 % | `R103_REFERTO_BLOCCO1_INDICI.md`; `R110_REFERTO.md` |
| SuperWave DOW H1 | **LONG** / **SHORT** | H1 | long OOS **3,280** / 100 / 2,14 % · **short OOS 0,429** / 84 / 7,53 % | `R110_REFERTO.md` |
| SuperWave `U30USD` | due lati | **M30** | IS 1,204 / 122 · **OOS 0,9305** / 290 (deal), DD 4,79 / 8,48 %: scartata | `REGISTRO_TEST.md` r.2987 |
| **SupRev DOW H1/H4** | due lati | M15 ... H8 | H1 IS 0,923 / 118 · OOS **1,436 / 155**; H2 IS 3,502 / 54; H4 IS 4,758 / 35 · OOS 1,941 / 46; M15/M20/M30 OOS 0,732 / 0,623 / 0,995. H4 a tick: **0,79, promozione revocata**. Ancora del Nasdaq (R240): OOS 0,971, il lungo non regge | `report/SUPREV_DOW_H1_ALTOPIANO_2026-09-09.md`; `CLASSIFICHE.md` |
| Apertura Dow, FADE | due lati | M5 | PF **0,806**, n 324, DD 19,7 % | `report/DUELLO_GEMELLI_DOW_SPX_2026-09-18.md` §1c |
| Apertura Dow, DELAYED | due lati | M5 | PF max 0,978, DD fino a 24,3 % | idem |
| Apertura Dow, BREAKOUT nudo (archivio 05/08) | due lati | M5 | PF max 0,997 (96 celle) / 1,106-1,214 (143 celle), DD fino a 15,7 % | idem |
| Apertura Dow, CLOSECONFIRM | — | — | **MAI misurata** (e' una modalita' di `ABTG_Apertura_3Ingressi`) | idem |
| Apertura Dow, GAPFILL / OPENCONFIRM (modi del motore) | — | — | **[NON MISURATI] su U30USD**; sul DAX OPENCONFIRM OOS 1,035 / 250 / 13,52 % | `INVENTARIO_MOTORI_APERTURA_2026-09-24.md` §0.2 |
| PreOpen Dow (livello pre-apertura, `RangeMode=1`, M15) | long / short | M15 | **[NON MISURATO]**: 5 file scritti il 28/08, "non devono girare finche' i criteri non sono firmati"; **oggi falliscono `controlla_prova.py`** (manca la riga `# EA:`) | `prove/PREOPEN_*_DOW_M15*.txt`, `REFERTO_PREPARAZIONE_PREOPEN_DOW.md` |
| GapFill / PunteLarry / PTE Dow, HVAncora, AtrExhaust M15 | — | — | R103: GapFill n 30 PF 1,45; PunteLarry n 55 PF 1,91; PTE n 68 PF 1,34. HVAncora OOS 1,038 / 35 (il tappo e' il meccanismo). AtrExhaust: estate 1,058 / inverno 0,852 (long), 0,961 / 0,849 (short) | R103; `CHI_E_PIU_VICINO` §2 riga 14; `IL_MERITO_E_D_INVERNO` §2.5 |

### 1.5 Che cosa NON e' mai stato provato sul Dow (manopole mai ad asse), per nome

[MISURATO, grep sui CSV: `RIESAME_MORTI_APERTURE_2026-09-22.md` punto 5, riconfermato su R215a par. 1]: **`InpFilterTF`, `InpLevelTF`, `InpStTF`, `InpVwapTF`, `InpCorrTF`, `InpPrevWindowMin` non variano in nessuno dei 221 CSV della famiglia.** `InpTrailTF` varia in **un** round (R200A, Nasdaq RETEST). Sul Dow Apertura **nessuno** dei nove assi di gestione R172a,b,c,e,f,g,h,i,j e' mai girato (esiste solo il CSV di R172D).

### 1.6 Scritti, verdi al cancello, mai girati sul Dow (coda a costo noto)

Passate = celle x 2 finestre da `controlla_prova.py` (eseguito oggi su ognuno, 0 problemi). Costo a **0,333 min/passata** (R245: 84 passate in 28 min, stesso EA/simbolo/TF/tick [MISURATO]); bordo basso 0,085, tetto 2,25 (135 s, R240, altro EA).

| gruppo | file | passate | min @0,333 | che cosa decide |
|---|---|---:|---:|---|
| TF filtro, sedia viva | `R215a` | 8 | 2,7 | fragilita' della sedia viva al TF del filtro (la griglia H4 di FTMO e' sfasata) |
| TF grafico, sedia viva | `R214a`, `R214b` | 4 + 4 | 2,7 | casella 5 del certificato; **atteso: identico alla cifra** |
| gestione sedia viva | `R172a,b,c,e,f,g,h,i,j` | 14,14,4,14,22,4,4,44,4 = 124 | 41 | trailing start, ora di chiusura, BE, TP1_R oltre 1,0, **TF del trailing**, SL mode, pavimenti |
| duello ingressi | `R180u0..u2b`, `uV` | 7 file x 4 = 28 | 9 | stop / limit / conferma, a parita' d'armi |
| ORB | `R211a` (8) · `R125a-f` (66) | 74 | 25 | stop OPPRANGE: **non crea campione (n invariante 119)** |
| EMA200 Dow | `LATI_A1/A2` (16) · `R234a` (10) · `R190a` (4) · `R208a` (10) | 40 | 13 | lati per regime, TF corto, taglio, TP |
| short Dow | `R267c` (4) · `R267d` (10) | 14 | 5 | uscita a 90', volumi |
| PreOpen Dow | 5 file | — | — | **non passano il cancello; criteri non firmati** |

---

## 2. Il costo: frontiera `stop >= 40 x spread`, per TF, col numero accanto

### 2.1 Gli spread veri (ricalcolati dai CSV, non assunti)

| fonte | ora | mediana | P95 | max | etichetta |
|---|---|---:|---:|---:|---|
| BCM, tick d'archivio 2024.09.26-2026.06.30 (`spread_flotta/spread_orario_U30USD.csv`, 4,93 M tick) | **14** (cash USA d'estate, pre-mercato d'inverno) | **2,00** | 3,00 | 47,00 | [MISURATO] |
| idem | 15 (cash d'inverno) | 2,00 | 2,60 | 36,00 | [MISURATO] |
| idem | 13 | 2,60 | 3,00 | 101,00 | [MISURATO] |
| BCM, logger vivo 04-11/09/2026 (`data/spread_vivo/SPREAD_VIVO_2026-09-12_orario.csv`, GG=5) | 14 | **3,00** | 3,00 | 9,00 | [MISURATO, 5 giornate, estate] |
| FTMO `US30.cash` | ora 16 BCM (un tick) | 2,63 | — | — | [MISURATO n=1] `STOP_VS_SPREAD_FTMO_2026-09-20.md` §5.2 |
| FTMO `US30.cash` | ora 10 server FTMO | 2,10 | 2,48 | — | [MISURATO GG=1, **non all'apertura USA**] `SPREAD_APERTURA_FTMO_2026-09-21.md` |
| FTMO `US30.cash` all'apertura USA | 16:30 server | **[NON MISURATO]** (il logger si e' fermato alle 10:50) | | | |

Disaccordo dichiarato: sull'ora 14 l'archivio (per tick) dice 2,00 e il logger (per secondo) 3,00. **Prendo il peggiore (3,00) per il verdetto**, e riporto 2,00 e 2,63 accanto.
Frontiera = 40 x spread: **80,0** a 2,00 · **105,2** a 2,63 · **120,0** a 3,00. Pavimento duro 13,3x.

### 2.2 Motori d'apertura: lo stop e' il range, non la barra (TF-indipendente)

Stop breakout = range 15' + 2 x buffer = `119,75 + 4,00 = 123,75` punti indice [R15 mediano MISURATO n=446, `studio_apertura/Studio_U30USD.csv` colonna `ampiezza_pt`/100; buffer 200 pt LETTO nei CSV]. Stop retest `770202` = range 35' + (buffer 10,00 - offset 4,00) = R35 + 6,00 con **R35 = R15 x radice(35/15) = 182,9 [INFERITO, mai misurato direttamente]**: stop mediano 188,9.

| geometria | stop mediano | su 3,00 (120) | su 2,63 (105,2) | su 2,00 (80) | giornate sotto la frontiera (3,00 / 2,63 / 2,00) | M5 / M15 / M30 / H1 / H4 |
|---|---:|---:|---:|---:|---|---|
| breakout 15' | 123,75 | **41,3x** | 47,1x | 61,9x | **47,5 % / 40,8 % / 30,9 %** (212 / 182 / 138 su 446, ricalcolato) | **identico a ogni TF**: nessun TF escluso per costo |
| retest 35' (`770202`) | 188,9 [INF] | 63,0x | 71,8x | 94,5x | 30,5 % / 27,4 % / 20,9 % [DERIVATO] | idem |
| pre-mercato 8:30 NY, range 15' | ~0,58-0,62 x 123,75 = **72-76** [DERIVATO] | **24,0-25,4x** | 27,4-28,9x | 36,1-38,1x | [NON MISURATO] | **sotto 40x a tutti e tre gli spread**; escluso per costo come candidata finche' il range delle 8:30 NY non e' misurato (sopra il duro 13,3x) |

Fonte del 0,58-0,62: rapporto mediano dei volumi d0 / -1h = 0,615 (A, 139 giorni comuni) e 0,583 (B, 178), "~ inverso del rapporto degli stop, sporcato dal passo 0,1 lotti" [`LETTURA_ROUND_CORTI_A_2026-09-28.md` sezione R250 costo]. Il pre-mercato ha un range piu' stretto della cash: **il merito del candidato sta dove il costo e' peggiore.**

### 2.3 FADE e motori a barra: qui il TF morde

| motore | M5 | M15 | M30 | H1 | H2 | H4 | etichetta |
|---|---:|---:|---:|---:|---:|---:|---|
| RANGE_FADE `U30USD`, stop 1,5 x ATR(TF), spread 3,00 | **11,4x** | **19,8x** | 28,0x (42,0x a spread 2,00) | 39,6x (59,4x) | — | ~79x | [DERIVATO, legge radice(T), validata a H1/H4 con errore 0,3-1,5 %]; `MAPPA_COSTO` §8; H4 calcolato qui: ATR = 379,5 x radice(240/1380) = 158,3, stop 237,4. Il FADE ha gia' **PF 0,806 su n 324** (non serve il costo per bocciarlo) |
| EMA200 `U30USD` (stop 104,3 a H1, n=8 forward), spread BCM 1,90, **k = 0,968** misurata su una coppia (SuperWave 77,1 H1 contro 295,5 H4) | **4,96x** | **14,4x** | **28,1x** | **54,9x** | 107x | 210x | [DERIVATO]; M30 = 28,1x riga di `REGISTRO_TEST.md` r.3003 |
| EMA200 `U30USD`, **k = 0,50** (radice del tempo, ASSUNTA) | 15,8x | 27,4x | 38,8x | 54,9x | 77,6x | 110x | [DERIVATO], l'altro bordo: **M30 sfiora i 40x, M5 e M15 no** |
| EMA200 `U30USD` su FTMO (spread 2,63) | — | — | — | **39,7x (-1 %)** | — | — | `STOP_VS_SPREAD_FTMO` §4: H1 e' sotto di un soffio |
| SuperWave `U30USD` M30 | | | **19,7x** | (98,6 / 77,1 idx: 37,5x / 29,3x a 2,63) | | | `REGISTRO_TEST.md` r.3003; `STOP_VS_SPREAD_FTMO` §4 |

**TF escluso per costo, con il numero**: sui motori a barra del Dow **M5 (4,96-15,8x), M15 (14,4-27,4x) e M30 (28,1-38,8x)**; H1 e' al bordo (54,9x BCM, 39,7x FTMO); da H2 in su passano. Il dato empirico concorda: EMA200 `U30USD` a M15/M20/M30 fa PF OOS 0,954 / 0,833 / 0,907 e **DD fino a 30,7 %** (cemad05, sopra). Sul FADE: M5 e M15 esclusi, M30 sul Dow non deciso (28,0x contro 42,0x a seconda dello spread), H1 al bordo.
**Per breakout e retest nessun TF e' escluso per costo**: la barra non entra nello stop. Questo vale a **Modello 4 (tick reali)**; a Modello 1/2 (OHLC) il TF del grafico genera i tick e un asse TF misurerebbe il simulatore [`MAPPA_COSTO` §1.2].

### 2.4 Che cosa il TF fa davvero nel motore d'apertura (sei input, non uno)

Letto nel sorgente (`MAPPA_COSTO` §1.2 e `R215a` par. 2, riconfermati): il range d'apertura si legge su `PERIOD_M1` **cablato**; il TF del grafico entra solo nell'ATR di gestione (inerte con `InpSLMode=0`), nel filtro volumi/ATR (spenti) e in `InpOCTimeframe` (solo OPENCONFIRM). Le manopole TF **vive** sono input separati: `InpFilterTF` (filtro EMA; **mai ad asse**), `InpTrailTF` (trailing; **mai ad asse sul Dow**), `InpStTF` (Supertrend; asse H4-D1 in R255 sullo short), `InpLevelTF` (solo `RangeMode=2`), `InpOCTimeframe` (solo OPENCONFIRM), `InpPrevWindowMin` (solo `RangeMode=1`).

---

## 3. L'orologio: quali celle mescolano le due tempistiche

BCM = **UTC+1 fisso** sugli indici su tutto lo storico 2024.09.26+ [MISURATO, 4 ancore indipendenti: `report/OROLOGIO_BCM_2026-09-24.md` §0, §3.2]. Quindi 14:30 BCM = **9:30 New York d'estate** (cash) e **8:30 New York d'inverno** (un'ora prima della cash, dati USA delle 8:30 ET). Gli USA cambiano ora **domenica 8/3/2026** e **domenica 1/11/2026** [calendario ricalcolato qui]; BCM non cambia mai: dal **lunedi' 02/11/2026** la 14:30 BCM e' le 8:30 NY. L'ora legale europea (25/10) per BCM e' irrilevante; per FTMO no (UTC+3 oggi [MISURATO 20/09], dal 25/10 [NON MISURATO], tre ipotesi). Sul Dow la settimana 26-30/10 e' una delle tre ipotesi a rischio (armo 10:30 NY).

| cella | orologio | mescola due tempistiche? | note |
|---|---|---|---|
| R6, R35, R54a, R16c, R47c/d, R88a, R118a, R15 (ORB), R101, R107, R172D, R197A/B, R202A, R212, R245, R262, R263, archivio `Dow_Apertura` | 14:30 BCM tutto l'anno | **SI** | `770202`: 44 % delle uscite da mesi "sfasati", PF **0,78** (n 73) allineati contro **1,66** (n 57) sfasati; candidato: 152 posizioni d'inverno su 351 (43 %) [`OROLOGIO_BCM` §5.1.1; `IL_MERITO_E_D_INVERNO` §2.1] |
| EMA200 H1 `U30USD`, SuperWave H1, SupRev | nessun ingresso orario | no (ma stagione nei numeri) | EMA200: estate 2,053 / inverno 0,868 -> "differenze di quella taglia le fa il mercato da solo" |
| **R246** (Dow, 770202: d0, -1h x A, B) | 4 orologi, stagione per data di chiusura | **NO** (separa) | **Dow SOSPESO** per G1 (un centesimo, R246a/c) |
| **R246 inverno** (d+1, armo alla cash d'inverno) | +1h | **NO** | Dow: S1 sbloccata da firma 29/09, G1 dei riferimenti ancora aperto |
| **R250** (candidato: d0, -1h, +1h x A, B) | 3 orologi, per stagione | **NO**, ma **B nulla**: R250d (Venerdi' Santo 2026) e R250f (vigilia del 4/7/2025, seduta ridotta) cadono su S1 | zone solo su A: "OROLOGIO", **concordanza A+B non verificata** |
| **R255** (short Dow, 24 file, 14:30 e 15:30) | 2 orologi, curve IN FASE / PRE-MERCATO / CONTROLLO | **NO** (separa) | S1 emendata per i festivi: firmata 28/09 **solo per R255** |
| **R248** (finestra vergine 01/07-18/09/2026) | 14:30 BCM, tutta estate | **NO**: in fase con la cash | e' per questo che il PF ~1 (0,514 sul candidato) non e' una sorpresa |
| `PreOpen`, `R214a/b`, `R215a`, `R172*` | 14:30 BCM tutto l'anno | SI (se girati cosi') | vanno letti per stagione o girati in fase |

**Conseguenza per FTMO** (che e' in fase con la cash tutto l'anno se segue il calendario europeo): la cella da guardare e' **"in fase"**, non il contratto. Per `770202`: PF 0,886 estate / 0,916 inverno (n 84 / 40, **sospeso**, G1 aperto); per il candidato: PF 0,964 su 132 (finestra A). **Nessuno dei due contratti descrive quello che FTMO fara' d'inverno.** Decisione di Claudio entro il 25/10 (BCM) / 02/11 (USA).

---

## 4. Lo "storico ampio" del Dow: misurato, non assunto

| fonte | che cosa c'e' | stato |
|---|---|---|
| BCM nativo | `U30USD` M1 650.255, M5 130.126, tick 67,6 M **dal 2024.09.26** (muro identico su 3 simboli misurati in 3 date diverse, quindi non e' una finestra mobile) | [MISURATO] `misura_tick/`; `DOW_BREAKOUT_DUE_LATI_IL_BUCO` §2 |
| HistData | il Dow **non esiste** (`UDXUSD` e' l'indice del dollaro) | [MISURATO] `REFERTO_HISTDATA_FATTIBILITA.md` §2a |
| Dukascopy `USA30IDXUSD` | tick dal **2012** ("2011 = 404") | [MISURATO sonda] `REFERTO_SONDA_DUKASCOPY.md` r.212; `REFERTO_DUKASCOPY_FATTIBILITA.md` r.41 |
| `U30USD_DK` | 2024-10-01 -> 2025-06-16, 222/222 giorni, 870,9 MB: era la **validazione del decoder, dentro** lo storico nativo; 5/6 giorni sotto soglia, peggiore **0,0696 % il 2024.11.20** contro il cancello <= 0,05 %: **in frigo per la lettera del criterio** | [MISURATO] `COME_ALLUNGARE_STORICO_INDICI` r.133-145 |
| Dukascopy profondo | 0 byte scaricati. Motore `curl`: 222 giorni in 0,2 h; **12 anni (~3.300 giorni) ~3 ore [DERIVATO, non misurato su finestra lunga]** | [NON MISURATO] r.294-301 |
| uso consentito | **SOLO_PROVA_REGIME** (D-C del 25/08, firmata solo per `NASUSD,SPXUSD`), barre M1 importate: **il Modello 4 non esiste su `_EXT`**, quindi OHLC = screening | `STORICO_INDICI_CRITERI.md` |

**Conseguenza**: per il Dow la prova di regime richiede (a) riaprire il cancello zero per `U30USD_DK` (decisione di Claudio: il criterio dice 0,05 %, la misura 0,0696 % su un giorno), (b) estendere D-B al Dow, (c) ~3 ore di download. **E' il buco piu' grosso e l'unica misura che compra n e regime insieme**: non la metto nelle tre perche' costa ore e due firme, ma e' quello che farei subito dopo.

---

## 5. Le tre misure, con la loro attesa

Ordine = quanto avvicina una sedia schierabile / costo. **Nessuna e' lanciata.** Costo in tempo macchina con base dichiarata.

### Misura 1 -- R280: il filtro del candidato su H1, la griglia che BCM e FTMO condividono (FILE PROVA PRONTO)

- **Perche' prima**: e' l'unica che attacca CE-4, "il piu' grave dei cinque" contro-esempi del candidato (`DOW_BREAKOUT_DUE_LATI_IL_BUCO` §4): il merito sta in un filtro che legge **candele H4**, e la griglia H4 di FTMO e' sfasata di 2h da quella BCM (1h con FTMO UTC+2). Un filtro **H1** ha la griglia **identica** su qualunque server a scarto d'ore intere [DERIVATO]. Se il candidato regge su H1, il suo merito non e' un artefatto della griglia BCM; se non regge, lo sappiamo **prima** di schierarlo.
- **File**: `backtest_pipeline/prove/R280a_filtrotf_h1_memoria_candidato_dow_U30USD.txt` (asse `InpEmaSlow` 220 -> 1320 di 220, `InpFilterTF`=H1: **6 celle, 12 passate**) e `R280e_ancora_g1_candidato_dow_U30USD.txt` (asse tecnico magic 798711/798721: **G1 + G0**, 2 celle, 4 passate, da girare per primo). Pin = copia riga per riga di `R262b` (diff eseguito: cambiano solo `InpFilterTF`, `InpEmaSlow`, `InpMagic`); stesso EA, deposito 10000, finestre IS 2024.09.26-2025.06.30 / OOS 2025.07.01-2026.06.30. `controlla_prova.py`: **ESITO OK, 8 celle, 16 passate, 0 problemi**; `controlla_riga.py --oggetto prova`: **nessun difetto meccanico**, ASCII puro. Magic `7987xx` e sigla `R280`: zero occorrenze nel working tree e in tutta la storia git (verificato oggi).
- **Una variabile**: la memoria del filtro in ore (EMA di periodo N su H1 = N ore; su H4 = 4N). La cella **880** ha la stessa memoria dell'ancora viva H4/220: separa la griglia dalla memoria.
- **Attesa scritta nel file prima dei numeri**: H_MEMORIA, l'altopiano su H1 coincide con quello gia' misurato su H4 (n IS 138-158 che **cresce con la memoria**, in parte e' il seme dell'EMA: R245 par. 4; PF OOS 1,30-1,60; DD 5-8 % a rischio 1 %). Le celle corte (220, 440) cadono **solo sul campione IS (n < 150)**, non sul merito. Cella 880: n IS 152-162, PF IS 1,15-1,40, OOS 1,35-1,60. Frequenza ~0,78 posizioni/giorno, tetto strutturale 1/giorno.
- **Soglie congelate**: C-a PF >= 1,10 in IS e OOS · C-b n >= 150 · C-c DD <= 10 % (a rischio 1 %, a qualunque n) · altopiano = almeno 3 celle contigue, centro mai il picco · rumore |dPF| <= 0,15 e |dn| <= 8 · "meglio del default" solo se batte l'ancora di piu' di 0,15 in entrambe le finestre senza DD peggiore; altrimenti **"il default va bene"**. Zone: V1 filtro portabile · V2 solo campione · V3 griglia legata (CE-4 confermato) · V4 nullo (S2 manopola muta, G0/G1 falliti).
- **Contro-esempio**: "la 880 coincide con l'ancora perche' il filtro da' lo stesso bias nel 95 % dei giorni (manopola quasi muta)". Si separa con la colonna `Trades` (uguale all'ancora al +-2 e PF alla seconda cifra = quasi muta). **Buco dichiarato**: manca la cella "filtro spento" a questa configurazione (un asse per volta: file successivo). Il rovescio: se tutte le H1 falliscono, la 880 dice se e' memoria o griglia.
- **Costo**: 16 passate x **0,333 min** (R245 misurato) = **5,3 min = 0,09 ore**; forbice 1,4-36 min (0,085-2,25 min/passata). Tetto 100.000 barre: `U30USD` M5 intero 130.126 barre, spezzato in ~56.000 (IS) e ~74.000 (OOS) [DERIVATO], sotto il tetto.
- **Non fa**: non promuove, non propone nessun preset FTMO, non tocca taglie. Mescola le due tempistiche come l'ancora: i confronti sono fra celle con lo stesso orologio.

### Misura 2 -- R250 finestra B riletta con la S1 dei festivi: **0 minuti macchina, 1 firma**

- **Che cosa**: R250d (-1h, finestra B) e R250f (+1h, B) sono NULLI **per una sola uscita ciascuno** dopo una chiusura di calendario: R250d il 05/04/2026 23:05:02 (Venerdi' Santo 03/04: **gia' in elenco** nell'emendamento S1 firmato il 28/09 per R255), R250f il 03/07/2025 23:05:00 (vigilia del 4 luglio, seduta ridotta [INFERITO dal calendario NYSE/CME, non dal feed]: **NON coperta** da quell'emendamento) [`LETTURA_ROUND_CORTI_A_2026-09-28.md` diagnosi S1]. La gemella G1 le ripete identiche: e' il calendario, non il pin. Rileggere R250d con la S1 emendata (firma di Claudio **estesa da R255 a R250**: criterio cambiato dopo i numeri, classe 900, dichiarato) dara' la curva **PRE-MERCATO (8:30 NY tutto l'anno) su A+B**; per la curva IN FASE su B serve in piu' un'eccezione per le sedute ridotte (R250f): una seconda firma.
- **Perche' vale**: decide se il vantaggio del pre-mercato (A: PF 1,291 su 157, DD 8,92 %) si replica in B (l'OOS) e quindi **quale orologio** ha senso per il candidato su FTMO (15:30 server FTMO = 8:30 NY se FTMO segue il calendario europeo, tranne le settimane sfasate). E' la decisione del 25/10-02/11.
- **Attesa scritta prima**: PRE-MERCATO A+B PF 1,20-1,50 su ~350 posizioni (B: d0 inverno 2,126 su 77 e -1h estate attesa ~1,15 come in A); IN FASE (solo A letta) 0,96 su 132, B attesa 0,90-1,05. **Contro-esempio**: se -1h estate B < 1,00 (come sul Dow 770202: 1,038 STAGIONE), la zona e' STAGIONE e il pre-mercato non e' un'ancora; falsifica l'ipotesi "8:30 NY".
- **Costo**: 0 minuti di tester; 1 firma (criterio S1). Il costo 40x del pre-mercato resta [NON MISURATO] (stima 24-25x a 3,00): qualunque lettura e' di sola ricerca, non di schieramento.

### Misura 3 -- R215a: lo stesso dubbio sulla sedia che opera oggi (GIA' PRONTO)

- **File**: `backtest_pipeline/prove/R215a_filtrotf_DOW_U30USD.txt` (asse `InpFilterTF` H1/H2/H3/H4 sulla cella viva `770202`, EmaSlow 50 pinnato; **4 celle, 8 passate**, `controlla_prova.py` OK, gia' con ancora a due round, attese, soglie e contro-esempio). Mai girato.
- **Perche'**: `770202` **opera oggi su FTMO con la griglia H4 sfasata** e il filtro e' "la manopola che fa il Dow" (spento 1,03 / DD 14,9 %, acceso 1,24 / 6,9 %). R215a dice se la sedia e' fragile su questo asse. Condivide con R280 la domanda ma sulla sedia con n < 150 (merito sospeso: si legge solo DD e direzione).
- **Costo**: 8 passate x 0,333 = **2,7 min** (0,05 ore). Va girato dopo R280e/R280a (il verdetto di R280 dice se la griglia conta; R215a dice quanto).
- **Aggiunta consigliata, a costo 4 passate** (1,3 min): `R214a/b` (TF grafico M15/M30), **atteso identico alla cifra**: chiude la casella 5 e permette corse a TF piu' alti.

### Perche' non queste

- **Griglie su ingresso/stop di motori morti** (FADE, DELAYED, nudo, Nasdaq breakout, ORB short): regola del 19/08.
- **ORB `R211a`**: misura lo stop, non il campione (n invariante a 119): "non produce una sedia".
- **La prova di regime con Dukascopy** (§4): la piu' importante, ma ore e due firme.
- **Allargare `InpEmaSlow` o TP1_R del candidato**: gia' piatti ("il default va bene").

---

## 6. Dichiarazione "meglio del default?"

- **Candidato, `InpEmaSlow`**: il centro 220 batte il 200 di +0,0023 (A9 di R262): **"il 200 va bene; lo spostamento e' solo di regola"**.
- **`770202`**: offset 400 centro dell'altopiano (R197B), TP1_R 1,0 sul bordo e massimo (R202A), BEatR nessuno batte la viva (R172D), range 35' non e' un picco ma neanche un centro (R35, crinali). **Il default va bene su tutto cio' che e' stato girato.**
- **R280 / R215a**: nessuna dichiarazione di vittoria prima dei numeri; l'attesa scritta e' "il default va bene" su quasi tutto.

---

## 7. I buchi dichiarati

1. **Un regime solo** su ogni cella (toro 2024-2026), un broker: Emendamento C non soddisfatto; il Dow profondo (Dukascopy) non e' scaricato (§4).
2. **n < 150** per ogni sedia viva del Dow (`770202` 96 posizioni, short 46, ORB 119 invariante): il merito resta sospeso.
3. **Lo spread FTMO all'apertura USA e le commissioni FTMO** sono [NON MISURATI]: ogni "x" su FTMO qui e' un tetto.
4. **R35 (range 35') e' [INFERITO]** (radice di 35/15 sul range 15'): lo stop del retest e' inferito, non misurato; il costo del retest e' piu' largo del breakout per costruzione ma non l'ho misurato.
5. **Il range pre-mercato (8:30 NY d'estate) non e' mai stato misurato**: lo `Studio_U30USD` non ha date (solo `idx`), quindi non si separa per stagione; il 0,58-0,62 e' un derivato da rapporti di lotti arrotondati a 0,1.
6. **G1 di R246a/c** (un centesimo sul primo deal USD->EUR) ancora aperto: il Dow di R246 e R246 inverno resta sospeso.
7. **Stato in campo di `770212` (short Dow, firmata il 26/09) e del preset FTMO a 2 %**: non riletto in questa sessione.
8. **R172a-j, R180, R214, R125, LATI_A1/A2, R234a**: scritti, mai girati; i loro verdi al cancello sono meccanici (`controlla_prova.py`), non di giudizio.
9. **I ritmi macchina**: 0,333 min/passata e' misurato su R245; 0,085 e' una stima di altro referto (base non ritrovata); 2,25 e' di altro EA. La forbice e' scritta in ogni costo.
10. **Gemelli del candidato** (NASUSD, D30EUR, SPXUSD) con filtro EMA H4 a due lati: non misurati. SPXUSD e' escluso per costo su BCM (tetto 35,6x [INFERITO]) e ammissibile da 53 minuti di range su FTMO (US500.cash 0,60): quel feed non e' il banco.

---

## 8. Fonti

`backtest_pipeline/risultati_archivio/ROUND_CORTI_B_2026-09-27/ROUND_R262{a-d}/` · `.../R245/` · `.../ROUND_R255_SHORT_DOW_INFASE_2026-09-28/` · `.../studio_apertura/Studio_U30USD*.csv` · `.../spread_flotta/spread_orario_U30USD.csv` · `.../misura_tick/REFERTO_MISURA_TICK_U30USD.txt` · `.../Dow_Apertura/` · `.../REFERTO_ROUND{6,35,54}_*.md` · `.../CENSIMENTO_LATI_SHORT_2026-08-25.md` · `.../R110_REFERTO.md` · `backtest_pipeline/risultati_prove/R202A,R172D,R197A,R197B/` · `.../dal_vps/ABTG_EMA200/*_cemad05.csv` · `backtest_pipeline/prove/R110_CSV_EMADOW/*.csv` · `data/spread_vivo/SPREAD_VIVO_2026-09-12_orario.csv` · `backtest_pipeline/REGISTRO_TEST.md` (r.2987-3003, 4143-4153, 4574-4575) · `report/` (`OROLOGIO_BCM_2026-09-24`, `IL_MERITO_E_D_INVERNO_2026-09-25`, `REFERTO_R245/R246/R248_*`, `LETTURA_R246_INVERNO_2026-09-29`, `LETTURA_R255_2026-09-28_B_EMENDATA`, `LETTURA_ROUND_CORTI_A_2026-09-28`, `DOW_BREAKOUT_DUE_LATI_IL_BUCO_2026-09-22`, `MAPPA_COSTO_SIMBOLI_TF_2026-09-24`, `STOP_VS_SPREAD_FTMO_2026-09-20`, `SPREAD_APERTURA_FTMO_2026-09-21`, `CHI_E_PIU_VICINO_AL_CAMPO_2026-09-24`, `CENSIMENTO_ORB_2026-09-29`, `INVENTARIO_MOTORI_APERTURA_2026-09-24`, `RIESAME_MORTI_APERTURE_2026-09-22`, `DUELLO_GEMELLI_DOW_SPX_2026-09-18`, `SEDIA_SHORT_DOW_FTMO_2026-09-26`, `COME_ALLUNGARE_STORICO_INDICI_2026-09-09`, `SUPREV_DOW_H1_ALTOPIANO_2026-09-09`, `FIRME_2026-09-26/28/29`).

Strumenti: `python3 backtest_pipeline/controlla_prova.py` (R280a, R280e: OK, 16 passate) · `python3 backtest_pipeline/controlla_riga.py --oggetto prova` (nessun difetto meccanico). **Secondo strato (`controllo-preventivo`) non ancora fatto: i due file prova NON escono verso il PC di backtest senza.**

*Referto del 03/10/2026, `cercatore-parametri`. Nessun candidato promosso o archiviato.*
