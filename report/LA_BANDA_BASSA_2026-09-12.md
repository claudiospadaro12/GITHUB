# 📉 LA BANDA BASSA — «dobbiamo trovare M5, M15 e M30 x le prop». **La risposta è misurata, e non è quella che sembrava.**

**12/09/2026 (sabato).** Alla challenge restano **~19 giorni**, di cui **13 giornate di borsa**.
Referto di **sola lettura d'archivio + lettura di sorgente**. 🛑 **Nessun backtest eseguito. Nessun EA,
preset, magic, sedia o parametro di forward toccato. `CODA.txt` NON toccata** (40 righe, chiusa sotto
cancello per stanotte). Taglie, rischio e accensioni restano **firma di Claudio**.

> 🚦 **CANCELLO: primo strato VERDE, secondo strato DA LANCIARE.** I tre file prova passano
> `controlla_prova.py` (**OK 3/3, 0 problemi**) e `controlla_riga.py --oggetto prova` (**EXIT 0, ASCII
> puro 3/3**). 🔴 **L'agente `controllo-preventivo` NON l'ho potuto invocare io: lo lancia il
> coordinatore.** Finché non torna, niente di questo referto va verso il VPS.

---

# 0. 🥇 LA RISPOSTA IN SETTE RIGHE

1. 🔴 **Claudio ha ragione sulla CODA e ha ragione a metà sulla FLOTTA — e la differenza cambia cosa si
   deve fare.** Misurato: nei 28 round in coda `H1 16 · M5 6 · H4 5 · M15 1 · M30 0` (riprodotto al
   file). Ma nella **flotta viva di 42 sedie** ce ne sono **12 sotto M30**: `M1 1 · M5 7 · M15 4`,
   contro `H1 22 · H2 2 · H4 6`. 👉 **Sedie a TF basso ne abbiamo già. Quello che manca è M30: ZERO
   su 42.**
2. 🟢 **MA di M30 in ARCHIVIO non c'è "niente": ce n'è TANTISSIMO, e nessuno l'aveva letto.** Misurati
   da me oggi: **168 CSV con una cella M30**, di cui **68 a TICK REALI**, su **12 simboli** e **8
   famiglie di motori**, più **4 round M30 dedicati** già chiusi col numero (R95, R111, P0 IBRetest,
   P0 LVNArbitro). Il "zero" del grep è un artefatto: l'asse è `InpTF` **dentro** file etichettati
   `@PERIODO H1`. **E stanotte in coda M30 c'è davvero** — dentro
   `COLLAUDO_EMADOW_05_tf_U30USD.txt`, che ha `InpTF=16385||15||1||16388||Y` = M15/M20/M30/H1/H2/H3/H4.
3. 🔴 **E il verdetto di quell'archivio è brutale: 34 coppie IS/OOS a tick reali con la cella M30,
   ZERO con `PF ≥ 1,10` in ENTRAMBE le finestre.** A M20 anche zero. A M15 due, e una delle due ha
   **n = 2**. Negli stessi 34 sweep, a **H1 sono 4** e a **H4 sono 9**. 🔴 **E il campione NON è la
   scusa**: 15 delle 34 coppie M30 hanno `n ≥ 150` in entrambe le finestre, e la più grossa arriva a
   **n = 1.151** (`EMA200` GBPUSD M30 OOS).
4. 📏 **IL RIFRAMING DELLA MISSIONE È GIUSTO, E LO PORTO UN PASSO OLTRE — con il codice alla mano.**
   Non è il TF che decide il costo, è lo stop: vero. Ma c'è una **legge più forte e più scomoda**:
   👉 **i motori il cui stop NON si stringe scendendo di TF sono ESATTAMENTE i motori che, scendendo
   di TF, NON guadagnano nemmeno un'operazione.** Non è una coincidenza: le due proprietà nascono
   dallo stesso fatto, cioè che il setup è ancorato a un oggetto di **CALENDARIO** (la sessione, il
   box notturno, la candela D1, il gap, un numero fisso di pip) e non alle barre del grafico.
   **Provato su tre motori riga per riga** (§4), non argomentato.
5. 📊 **E l'altra metà della legge è MISURATA su 58 serie**: sui motori a stop **scalante** (ATR,
   swing, banda) scendere di un gradino compra **×1,97 operazioni** (H1→M30, mediana, banda
   1,13-3,33) e **×1,85** (M30→M15) — ma lo stop si stringe di **×0,71** (legge assunta) a **×0,51**
   (legge **misurata** in casa). 🔴 **E il DD mediano OOS sale MONOTONO scendendo: H4 2,74% → H1
   4,82% → M30 6,61% → M15 8,63%.** Il baratto è sfavorevole su ogni riga.
6. 🪦 **La cella M30 migliore di tutto l'archivio è un PICCO, e si vede sull'asse**:
   `ABTG_SupertrendReversal_Multi_Ottimizzato` XAUUSD M30, **IS PF 1,256 (n 257) / OOS PF 1,087
   (n 427)**, positiva in tutte e due le finestre. I **vicini immediati sullo stesso asse**: M20
   `IS 0,709` e H1 `IS 0,984`. 👉 **Centro dell'altopiano, MAI il picco: è un picco. Scartata, col
   numero** (§6). 🟢 E va detto anche il rovescio: il suo **DD 22,06% è a taglia 2,0%**, non 0,65% —
   scalato alla taglia firmata fa **~7,17%**, dentro il muro. **Non muore di rischio: muore di
   regola di selezione.**
7. 🎯 **QUANTI MOTORI NOSTRI POSSONO LEGITTIMAMENTE SCENDERE? POCHI, E IL NUMERO È QUESTO: 5 su 42
   sedie passano il 40x a M30 con l'esponente PESSIMISTA — e TUTTE E CINQUE sono di classe G, cioè
   scendendo non guadagnano NIENTE.** Dei 19 motori a stop scalante, a M30 col `k` misurato **ZERO**
   passa il 40x. **La banda bassa per le prop non si compra col TF: si compra con i SIMBOLI** (firma
   del 07/09) — ed è esattamente dove puntano i tre file prova che consegno.

---

# 1. 🔬 LA VERIFICA DEL VUOTO A M30 — «cercalo e se c'è, dillo». **C'è, ed è grosso.**

## 1.1 Il metodo, e perché il grep di stamattina ha visto zero

Il TF di una corsa in casa nostra sta in **DUE posti diversi**, e solo uno è `@PERIODO`:

| dove | chi lo usa | esempio |
|---|---|---|
| `@PERIODO` nel file prova | il **grafico** del tester | `@PERIODO M30` |
| `InpTF` (input dell'EA) | il **TF OPERATIVO**, che su molti EA è l'unica cosa che conta | `InpTF=30` |

🔴 **Otto famiglie di motori leggono il TF da `InpTF`, non dal grafico** — verificato nel sorgente:
`ABTG_SuperWave.mq5` r.52 · `ABTG_SupRev_*_Ottimizzato.mq5` · `ABTG_EMA200.mq5` r.49 ·
`ABTG_BreakingBand.mq5` r.269 · `ABTG_PTE.mq5` r.51 · `ABTG_CostToCost.mq5` r.149 ·
`ABTG_EasyTrend.mq5` r.179 · `ABTG_GapFill.mq5` r.128. 👉 **Su quei motori `@PERIODO` è un'etichetta e
`InpTF` è la misura.** Un censimento fatto su `@PERIODO` non vede la banda bassa.

## 1.2 📊 IL CENSIMENTO VERO, contato oggi

Scansione di **tutti** i CSV di `backtest_pipeline/` cercando una colonna `Inp*TF*` con **più di un
valore** e almeno un valore sotto H1:

| cosa | numero | dettaglio |
|---|---:|---|
| CSV con una **cella M30** | **168** | asse completo `M15/M20/M30/H1/H2/H3/H4/H6/H8/H12/D1` |
| di cui a **TICK REALI** (senza suffisso `_ohlc`) | **68** | gli altri 100 sono lo **stadio 1 di screening** |
| **coppie IS/OOS complete** a tick con 11 celle | **34** | è l'insieme su cui si può giudicare |
| famiglie di motori coperte | **8** | `SuperWave` 34 CSV · `WOL` 28 · `EMA200` 26 · `SupertrendInvert` 20 · `SupertrendReversal` 18 · i cinque `SupRev_*_Ottimizzato` 18 · `EMA200_Ottimizzato` 4 · `SuperWave_*_Ottimizzato` 8 |
| simboli coperti | **12** | `D30EUR` 24 · `XAUUSD` 24 · `U30USD` 22 · `NASUSD` 18 · `225JPY` 10 · `USDJPY` 10 · `GBPUSD` 8 · `SPXUSD` 8 · `XAGUSD` 8 · `GBPJPY` 4 · `EURUSD` 4 · `F40EUR` 2 |

E i **quattro round M30 dedicati**, tutti già chiusi con un certificato:

| round | motore · simboli · TF | esito misurato | dove |
|---|---|---|---|
| **R95** (23/08) | `ABTG_LiquiditySweep` EURJPY, sweep **M30/H1/H2/H3/H4** | **0/30 passate**, PF 0,65-0,80, DD 27-99,9% (OHLC, dichiarato) | `risultati_archivio/R95_REFERTO.md` |
| **R111** (26/08) | `ABTG_BreakingBand` GBPUSD/EURUSD/AUDUSD **M30**, tick | **0/3**. GBPUSD il migliore: IS **0,997** / OOS **1,087** su n 181/174. Verdetto: *"il confine sta fra H1 e M30"* | `risultati_archivio/R111_REFERTO.md` |
| **P0 IBRetest** (09/09) | `ABTG_IBRetest` D30EUR/U30USD/NASUSD **M30**, tick | **PF famiglia 0,7798** su n 344. Scartato dal cancello C0 | `REGISTRO_TEST.md` r.1941 |
| **P0 LVNArbitro** (08/09) | `ABTG_LVNArbitro` U30USD **M30**, tick | **n OOS 618** (1,57 op/g!) ma **DD 11,33% e 18,01% a 0,65%**, e 11,76%/19,35% a deposito 100k. **BOCCIATO PER RISCHIO** | `report/P0_LVNARBITRO_2026-09-08.md` |

## 1.3 🚦 E IN CODA STANOTTE M30 C'È

`backtest_pipeline/prove/COLLAUDO_EMADOW_05_tf_U30USD.txt` r.126:
```
InpTF=16385||15||1||16388||Y
```
= **M15 · M20 · M30 · H1 · H2 · H3 · H4**, 7 celle × 2 finestre = 14 passate, su `ABTG_EMA200`
U30USD a tick reali. Il file è etichettato `@PERIODO H1` (r.73) — **ecco perché il grep ha detto
zero**. 🔴 E il `REGISTRO_TEST.md` (12/09) ha **già pre-dichiarato** quelle tre celle
*"INFORMATIVE E NON PROMUOVIBILI: qualunque numero diano, sono escluse per costo in anticipo"*, con
i numeri: M5 **11,5-13,1x** (sfonda il duro), M15 **20,0-22,6x**, M20 **23,1-26,1x**, M30
**28,3-32,0x**.

> ## 🎯 **VERDETTO DEL §1: il vuoto a M30 esiste SOLO in campo (0 sedie su 42) e nella COLONNA `@PERIODO` della coda. In archivio M30 è una delle bande più misurate che abbiamo — e il suo esito è 0 su 34.**

---

# 2. 🧮 L'INVENTARIO PER STOP — la tabella che la missione chiede

## 2.0 🔴 PRIMA LA CLASSIFICAZIONE, perché è il cuore della consegna

Ogni motore ricade in **una** di due classi, e la classe si legge nel **sorgente**, non nel nome:

| classe | come è fatto lo stop | lo stop scala col TF? | i segnali scalano col TF? |
|---|---|:---:|:---:|
| **G** — ancorato al **CALENDARIO** | finestra in **MINUTI** (sessione, box, range d'apertura), candela **D1**, **gap**, o **pip FISSI** | 🟢 **NO** | 🔴 **NO** |
| **S** — ancorato alle **BARRE** | `N × ATR(InpTF)` oppure estremo di **N barre** di `InpTF` | 🔴 **SÌ**, come `T^k` | 🟢 **SÌ**, ×1,97 per gradino |

**Ripartizione delle 42 sedie vive** (elenco per nome, mai "tutto ciò che non è X"):
- **CLASSE G — 21 sedie:** `DAX_Apertura_EU` 770101 · `Dow_Apertura_US` 770202 ·
  `Nasdaq_Apertura_US` 770250 · `ORB_Ottimizzato` 770611 · `MaxMinNotte` 770402 ·
  `MaxMinNotte_DAX_Short_Ott` 770411 · `GapFill` 772231/2/3/4/5 · `GapContinuation` 774101 ·
  `PostNews` 771201/2/3 · `PunteLarry` 772341/2/3/4/5/6
- **CLASSE S — 19 sedie:** `SuperWave` 770511/770531 · `SupRev_DAX_H4_Ott` 970912 ·
  `SupRev_NAS_H1_Ott` 970913 · `SupertrendReversal` 770901/770924 ·
  `SupertrendReversal_Ott` 970901 · `EMA200` 771531 · `EMA200_Ott` 971501 ·
  `PTE` 771321/771322/771332 · `BreakingBand` 772161/2/3 · `CostToCost` 772361/2 ·
  `EasyTrend` 772421/2
- **NON CLASSIFICABILI — 2 sedie:** `BREAKOUT_EA_JPY_v3` USDJPY M15 e `Gold_Ichimoku_TK_ATR_EA`
  250604 XAUUSD M5 — **il sorgente non è nel repo**. Restano **⚪ NON ANCORA MISURATO**.

## 2.1 📐 LA TABELLA, con le due leggi di scala tenute SEPARATE

**Pedaggio all-in:** sugli **indici** e sull'**oro** è lo **SPREAD e basta** — commissione **0,0000
MISURATA** su n=302 deal (`CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.181-183). Sul **forex** NO: la
commissione è **0,004% del nozionale in valuta base** e vale il **73,1%** del pedaggio su GBPUSD.
I due casi **non si mescolano in una colonna**. Forex calcolato con
`backtest_pipeline/calcola_pedaggio_forex.py` (marcatore `_v3`, **autotest tutto VERDE lanciato
oggi**, USD/JPY = 159,36 letto dal disco).

**Le due leggi**, e non si mediano:
- **`k = 0,50` ASSUNTA** — la radice del tempo, validata al 4,3% in `ORO_1530_CANCELLO_COSTO`, usata
  dalla casa in `CANCELLO_COSTO_FLOTTA` r.405.
- 🔴 **`k = 0,968` MISURATA** — sull'**unica** coppia a due TF dello **stesso codice** e dello
  **stesso simbolo** che possediamo: `ABTG_SuperWave` U30USD, stop **77,1 idx a H1 (n=4)** e
  **295,5 idx a H4 (n=8)**, geometria identica riga per riga (`ABTG_SuperWave.mq5` r.365-367 ≡
  `ABTG_SuperWave_DOW_H1_Ottimizzato.mq5` r.365-367, unica differenza `InpTF`).
  `ln(295,5/77,1)/ln(4) = 0,968`. 👉 **La radice del tempo predice 147,8 idx a H1 e il misurato è
  77,1: sovrastima del 92%.** E sbaglia nella direzione **ottimista** per la discesa di TF, quindi
  la colonna `k=0,968` è quella prudente.

| # | motore · simbolo (magic) | TF0 | cl | **stop tipico misurato** (fonte) | **pedaggio all-in** | **x a M5 / M15 / M30** `k=0,50` | **x a M5 / M15 / M30** `k=0,968` | **TF minimo che passa 40x** (`k` prudente) | **op/g guadagnate scendendo** |
|---:|---|:--:|:--:|---|---:|---|---|:--:|:--:|
| 1 | `PunteLarry` **XAUUSD** (772343) | H1 | **G** | **61,48 $** [MIS] n=1 · `trades_auto.csv` | 0,2603 $ | 236,2 / 236,2 / 236,2 | idem | 🟢 **M5** | **0,00** |
| 2 | `MaxMinNotte` **XAUUSD** (770402) | M15 | **G** | **32,94 $** [MIS] n=2 | 0,2603 $ | 126,5 / 126,5 / 126,5 | idem | 🟢 **M5** | **0,00** |
| 3 | `PunteLarry` **U30USD** (772341) | H1 | **G** | **274,2 idx** [MIS] n=2 (113,1 / 435,2) | 2,60 | 105,5 / 105,5 / 105,5 | idem | 🟢 **M5** | **0,00** |
| 4 | `Dow_Apertura_US` **U30USD** (770202) | M5 | **G** | **~102 idx** [INF] · `ROUND_ORB_ATR_PS5` §2.2 | 2,00 | 51,0 / 51,0 / 51,0 | idem | 🟢 **M5** (già lì) | **0,00** |
| 5 | `Nasdaq_Apertura_US` **NASUSD** (770250) | M15 | **G** | **~67 idx** [INF] (`InpLevelTF`=H1, input **separato**) | 1,80 | 37,2 / 37,2 / 37,2 | idem | 🔴 **nessuno** (93% del 40x) | **0,00** |
| 6 | `GapFill` **U30USD** (772234) | H1 | **G** | **98,0 idx** [MIS] n=1 | 2,80 | 35,0 / 35,0 / 35,0 | idem | 🔴 **nessuno** (88%) | **0,00** |
| 7 | `DAX_Apertura_EU` **D30EUR** (770101) | M5 | **G** | **56,1 idx** [MIS] n=2 (geometria viva) · 71,9 [MIS] n=7 | 1,70 | 33,0 / 33,0 / 33,0 | idem | 🔴 **nessuno** (82%) · 🟢 duro passato ×2,5 | **0,00** |
| 8 | `ORB_Ottimizzato` **U30USD** (770611) | M5 | **G** | **59,0 idx** [MIS] n=7 | 2,00 | 29,5 / 29,5 / 29,5 | idem | 🔴 **nessuno** (74%) | **0,00** |
| 9 | `PostNews` **EURUSD** (771202) | M5 | **G** | **25,0 pip** — `InpSLpips` **FISSO**, r.98 | 0,864 pip | 28,9 / 28,9 / 28,9 | idem | 🔴 **nessuno** (72%) | **0,00** |
| 10 | `PostNews` **USDJPY** (771203) | M5 | **G** | 25,0 pip **FISSO** | 0,937 pip | 26,7 / 26,7 / 26,7 | idem | 🔴 **nessuno** | **0,00** |
| 11 | `PostNews` **EURJPY** (771201) | M5 | **G** | 25,0 pip **FISSO** (15,0 dopo il trail, r.105) | 1,139 pip | 21,9 / 21,9 / 21,9 | idem | 🔴 **nessuno** | **0,00** |
| 12 | `GapContinuation` **225JPY** (774101) | M1 | **G** | **479 idx** [MIS] n=1 | 35 🟡 [LETTURA UNICA, ora sbagliata] | 13,7 / 13,7 / 13,7 | idem | 🔴 **nessuno** | **0,00** |
| 13 | `MaxMinNotte_DAX_Short` **D30EUR** (770411) | M15 | **G** | 🔴 **[NON MISURATO]** — 0 gambe in stop su 5 trade. ATR su **`InpMgmtTF`** (r.76), input **SEPARATO** dal grafico | 1,70 | [NM] | [NM] | ⚪ **NON MISURATO** | **0,00** |
| 14 | `PunteLarry` **GBPJPY** (772344) | H1 | **G** | 58,6 pip [MIS] n=1 | 🔴 **[NON MISURATO]** (sonda: `SpreadPt=0`) | [NM] | [NM] | ⚪ **sospesa** | **0,00** |
| — | `PunteLarry` EURAUD/GBPUSD/EURCAD · `GapFill` GBPUSD/EURUSD/AUDUSD/225JPY | H1 | **G** | **[NM]** (0 gambe in stop / 0 trade) | vari | [NM] | [NM] | ⚪ | **0,00** |
| 15 | `EMA200` **U30USD** (771531) | H1 | **S** | **104,3 idx** [MIS] n=8 (`1,0×ATR(InpTF)`) | 1,90 | 15,8 / 27,4 / **38,8** | 5,0 / 14,3 / **28,1** | 🟡 **H1** (la sedia viva, C3 **FRAGILE**) | **×1,97** |
| 16 | `EMA200_Ott` **XAUUSD** (971501) | H4 | **S** | **42,28 $** [MIS] n=4 | 0,2603 $ | 23,4 / 40,6 / **57,4** | 3,8 / 11,1 / **21,7** | 🟡 **H1** (42,4x) | **×1,97** |
| 17 | `SupertrendRev_Ott` **XAUUSD** (970901) | H4 | **S** | ~35,31 $ [INF] dal gemello | 0,2603 $ | 19,6 / 33,9 / **48,0** | 3,2 / 9,3 / **18,1** | 🔴 **H2** | **×1,97** |
| 18 | `SuperWave` **U30USD** (770531) | H4 | **S** | **295,5 idx** [MIS] n=8 | 2,00 | 21,3 / 36,9 / **52,2** | 3,5 / 10,1 / **19,7** | 🔴 **H2** | **×1,97** |
| 19 | `SupRev_DAX_H4_Ott` **D30EUR** (970912) | H4 | **S** | ~170 idx [INF] | 1,70 | 14,4 / 25,0 / **35,4** | 2,4 / 6,8 / **13,4** | 🔴 **H2** | **×1,97** |
| 20 | `SuperWave_DOW_H1` **U30USD** (770511) | H1 | **S** | **77,1 idx** [MIS] n=4 | 2,00 | 11,1 / 19,3 / **27,3** | 3,5 / 10,1 / **19,7** | 🔴 **H2** | **×1,97** |
| 21 | `EasyTrend` **GBPUSD** (772422) | H1 | **S** | **35,0 pip** [MIS] n=1 | **0,742 pip** (0,2 spread + **0,5425 comm**) | 13,6 / 23,6 / **33,4** | 4,3 / 12,3 / **24,1** | 🟡 **H1** (47,2x) | **×1,97** |
| 22 | `PTE` **U30USD** (771321) | H1 | **S** | ~65 idx [INF] — 0 gambe in stop | 2,00 | 9,4 / 16,2 / **23,0** | 2,9 / 8,5 / **16,6** | 🔴 **H2** | **×1,97** |
| 23 | `SupRev_NAS_H1_Ott` **NASUSD** (970913) | H1 | **S** | **51,65 idx** [MIS] n=4 | 1,80 | 8,3 / 14,3 / **20,3** | 2,6 / 7,5 / **14,7** | 🔴 **H2** | **×1,97** |
| 24 | `BreakingBand` **EURUSD** (772162) | H1 | **S** | **22,1 pip** [MIS] n=1 (`3,0×ATR`) | **0,864 pip** | 7,4 / 12,8 / **18,1** | 2,3 / 6,7 / **13,1** | 🔴 **H2** | **×1,97** |
| 25 | `CostToCost` **EURJPY** (772361) | H4 | **S** | **29,2 pip** [MIS] n=3 | **1,139 pip** | 3,7 / 6,4 / **9,1** | 0,6 / 1,8 / **3,4** | 🔴 **nessuno** (25,6x già a H4) | **×1,97** |
| 26 | `CostToCost` **GBPCAD** (772362) | H4 | **S** | **38,9 pip** [MIS] n=2 | **1,952 pip** | 2,9 / 5,0 / **7,0** | 0,5 / 1,4 / **2,7** | 🔴 **nessuno** (19,9x a H4) | **×1,97** |
| 27 | `SupertrendReversal` **225JPY** (770924/770901) | H2 | **S** | **477 idx** [MIS] n=1 | 35 🟡 | 2,8 / 4,8 / **6,8** | 0,6 / 1,8 / **3,6** | 🔴 **nessuno** (13,6x a H2) | **×1,97** |
| 28 | `EasyTrend` **CHFJPY** (772421) | H1 | **S** | 47,0 pip [MIS] n=2 | 🔴 **[NON MISURATO]** | [NM] | [NM] | ⚪ **sospesa** | **×1,97** |
| — | `BreakingBand` GBPUSD/AUDUSD · `PTE` GBPUSD ×2 | H1 | **S** | **[NM]** (0 gambe in stop) | vari | [NM] | [NM] | ⚪ | **×1,97** |

**Spread MISURATI usati** (e sono tre file, non tre memorie):
`risultati_archivio/spread_flotta/spread_orario_{D30EUR,U30USD,NASUSD}.csv` —
`D30EUR` ora 08: **mediana 1,70 · p95 2,70 · max 12,0** su **1.847.049** tick a quell'ora
(30.974.789 in totale) · `U30USD` ora 14: **2,00 · 3,00 · 47,0** su **4.931.660** tick
(64.711.285 in totale) · `NASUSD` ora 15: **1,80 · 2,60 · 6,1** su **15.360.447** tick
(156.146.398 in totale). **Oro**: 0,2603 $ = spread 0,22 + commissione **0,0403 MISURATA**.
🔴 `F40EUR`, `AUDJPY`, `225JPY`, `GBPJPY`, `CHFJPY`, `EURAUD`, `AUDUSD`: **[NON MISURATO]** — alla
sonda del 17/08 leggono `SpreadPt = 0`, che vuol dire *"nessun tick in quell'istante"*, **non**
*"spread nullo"*. Le loro righe sono **sospese, non promosse**.

## 2.2 🎯 LA GRADUATORIA CHE LA MISSIONE CHIEDE — ordinata per **op/g guadagnate scendendo**

Ed è una graduatoria con **due soli valori**, ed è questo il risultato:

| posizione | chi | op/g guadagnate per gradino | passa il 40x a M30? | verdetto in una riga |
|---|---|:--:|:--:|---|
| **1ª (a pari merito, 21 sedie)** | tutta la **CLASSE G** | 🔴 **0,00 — MISURATO DAL CODICE** | **4 sì · 8 no · 9 [NM]** | **scendere non costa e non serve** |
| **2ª (a pari merito, 19 sedie)** | tutta la **CLASSE S** | 🟢 **×1,97** (mediana su 58 serie) | **0 su 14 misurati** con `k` misurato (+ **5 [NM]**) | **scendere serve e non si può** |

### 🔴 Perché la classe G guadagna ZERO — con il file:riga, non con un ragionamento
| motore | la riga che lo prova | conseguenza |
|---|---|---|
| `ABTG_DAX_Apertura_EU` | r.1007-1020: il range d'apertura si legge su **`PERIOD_M1` CABLATO**; r.679: la macchina a fasi gira su `nowMin = TimeInMinutes(now)`, **minuti d'orologio**; r.181 del preset: `InpOneTradePerDay=true` | **1 setup/giorno a QUALUNQUE TF**, e stop identico |
| `ABTG_Dow_Apertura_US` · `ABTG_Nasdaq_Apertura_US` | r.226 / r.205: `InpOneTradePerDay = true`, guardia reload-safe sullo storico del giorno | idem |
| `ABTG_ORB_Ottimizzato` | r.135: `InpOneTradePerDay = true`; stop `HALFRANGE` su finestra **14:30-14:45** (minuti) | idem |
| `ABTG_PunteLarry` | r.142: *"`InpTF`: TF operativo: **scandisce il tempo** (i pattern restano su **D1**)"*; r.415-420: `iOpen/iHigh/iLow` su **`PERIOD_D1`**; r.283: `iATR(_Symbol, PERIOD_D1, ...)`; r.152-153: stop = estremo della candela **D1** + `0,1×ATR(D1)` | **stop e segnali 100% ancorati a D1**: il TF non li tocca |
| `ABTG_GapFill` | r.128: `InpTF` rileva **il cambio di settimana**; r.245: `iATR(_Symbol, **PERIOD_D1**, ...)` | **1 gap a settimana** |
| `ABTG_MaxMinNotte` (e `_DAX_Short_Ott`) | r.51-54: box notturno **23:00-04:59 ORA SERVER**; r.76: `InpMgmtTF` è un **input separato** e l'ATR si legge lì (r.139), non sul grafico; r.79: esiste anche `MM_SL_FIXED` = 3000 pt = 30 idx | **1 box a notte**, stop indipendente dal grafico |
| `ABTG_PostNews` | r.98: `InpSLpips = 25.0` **PUNTI FISSI** | stop costante, frequenza dettata dal **calendario news** |
| `ABTG_GapContinuation` | nessun `input ENUM_TIMEFRAMES`, nessun `iATR`: stop sull'estremo del **gap** | **1 gap al giorno** |

### 🟢 Perché la classe S guadagna ×1,97 — **MISURATO su 58 serie, non stimato**
Dentro lo **stesso CSV** (stessa corsa, stessa finestra, stesso modello, stesso simbolo: la finestra
si elide), con `InpTF` come asse:

```
H1 -> M30 :  n=58  mediana 1,97x   min 1,13   max 3,33
M30 -> M15:  n=58  mediana 1,85x   min 0,93   max 2,67
```

Esempi, per non lasciarlo astratto: `SupRev_DOW_H1` U30USD OOS **155 → 369 → 656** ·
`EMA200` GBPUSD OOS **585 → 1.151 → 1.934** · `SuperWave` D30EUR OOS **149 → 291 → 578**.

🔴 **E il prezzo, nello stesso posto**: il DD mediano OOS delle 34 coppie, per TF —
**H4 2,74% → H1 4,82% → M30 6,61% → M15 8,63% → M20 8,90%**. **Monotono scendendo.**
👉 **Un gradino compra +97% di operazioni e paga +37% di drawdown, e il PF non migliora** (§3).

---

# 3. ⚖️ IL MERITO A M30, MISURATO — e il campione non è la scusa

Le **34 coppie IS/OOS a tick reali** con l'asse `InpTF` completo, lette con i cancelli di casa:

| TF | coppie | `PF ≥ 1,10` in **ENTRAMBE** | + `n ≥ 150` in entrambe | `n ≥ 150` OOS | **PF OOS ≥ 1,10** | **PF OOS mediano** | **DD OOS mediano** |
|---|---:|---:|---:|---:|---:|---:|---:|
| **M15** | 34 | **2** (una ha **n = 2**) | **0** | 28 | 4 | 0,849 | **8,63%** |
| **M20** | 34 | **0** | **0** | 29 | 1 | 0,778 | **8,90%** |
| **M30** | 34 | **0** | **0** | 24 | 4 | 0,868 | **6,61%** |
| H1 | 34 | **4** | 0 | 12 | **14** | 0,990 | 4,82% |
| H2 | 34 | 5 | 0 | 6 | 11 | 0,918 | 4,57% |
| H4 | 34 | **9** | 0 | 0 | 12 | 0,978 | **2,74%** |

> ### 🔴 **LA RIGA CHE VA DETTA A CLAUDIO: a M30 e a M20, su 34 coppie fuori campione a tick reali, ZERO celle sono positive in tutte e due le finestre sopra il pavimento del PF. A H1 sono 4 e a H4 sono 9. E il campione non c'entra: 24 delle 34 coppie M30 hanno n ≥ 150 fuori campione, e la più grossa fa n = 1.151.**

🧪 **IL CONTRO-ESEMPIO CHE HO COSTRUITO CONTRO QUESTA TABELLA, e la corregge a metà.**
L'ipotesi alternativa è: *"a M30 non passa niente perché quelle 34 corse sono una famiglia di motori
debole, non perché M30 sia cattivo"*. **Quale numero produce l'altra spiegazione?** Produrrebbe uno
**zero anche a H1 e H4** dentro le stesse 34 corse. Misurato: **4 a H1 e 9 a H4**. 🟢 L'alternativa è
**falsificata sui dati**.
⚠️ **Ma la stessa tabella mi corregge**: la colonna *"+ n ≥ 150 in entrambe"* è **0 a TUTTI i TF**.
Quindi queste 34 corse **non contengono nessun candidato pieno a nessun timeframe**: sono un archivio
di **fase 0**, non di candidati. 👉 **La conclusione onesta è "a M30 il merito è misurato e negativo
su 34 serie", NON "a M30 non esiste un motore".** La differenza conta, e la scrivo.

---

# 4. 📏 LA LEGGE, scritta come una legge — e la frase di casa che la precede

La casa questa cosa l'aveva già scritta il **06/09**, e la cito perché è più bella della mia
(`backtest_pipeline/caccia_strategie/CACCIA_TFBASSO_FREQUENZA_2026-09-06.md` §6.3):

> 🎯 **«IL TIMEFRAME DELLE BARRE È GRATIS. LA TAGLIA DEL RISCHIO NON LO È.»**
> *"Non è 'M5 è morto': è 'uno stop da 20 punti è morto', su qualunque timeframe lo si guardi."*

Con gli stop **misurati in casa**: M5 **20,0 pt**, M15 **17,4 pt** (1R a taglia ATR) — entrambi
**sotto anche il pavimento DURO** sul DAX; M15 a 3×ATR ~52 pt (sopra il duro, sotto il lavoro);
M30 a 2×ATR **50-80 pt** (ATR M30 = 25-40) → **dentro la banda di lavoro**.

## 🔴 E QUI AGGIUNGO IL PEZZO CHE MANCAVA, ed è il contributo di oggi

> ### **LA LEGGE DELL'ANCORAGGIO**
> **Un motore guadagna operazioni scendendo di TF se e solo se il suo stop si stringe scendendo di
> TF.** Le due cose non sono correlate: sono **la stessa cosa**, guardata da due lati. Se il setup è
> ancorato alle **barre** (`ATR(InpTF)`, estremo di N barre), allora dimezzare il TF raddoppia le
> occasioni **e** dimezza l'ampiezza; se è ancorato al **calendario** (minuti di sessione, candela
> D1, gap, pip fissi), non cambia né l'una né l'altra.
> 👉 **Conseguenza per la challenge: la banda bassa non è un serbatoio di frequenza. Non lo è per
> costruzione.** La frequenza sta nei **SIMBOLI**, ed è esattamente la firma di Claudio del 07/09
> (pavimento 1,00 op/giorno per **FAMIGLIA**).

🧪 **E il contro-esempio contro la MIA legge, perché una legge senza contro-esempio non vale niente.**
L'ipotesi che la romperebbe: *"esiste un motore di classe G la cui frequenza cresce scendendo di TF"*.
**Ne ho cercato uno e ne ho trovato il candidato**: `ABTG_ImpulsoApertura`. È di classe **mista**
(stop = range della barra operativa, quindi **S**; trigger = una barra al giorno, quindi **G**).
Scendendo di TF **perde** su entrambi i fronti — lo stop si stringe **e** i segnali restano uno al
giorno (r.409: `if(d.hour!=InpOpenHour || d.min!=InpOpenMinute) return;` · r.413-415:
`UN SOLO TENTATIVO PER SEDUTA`). 👉 **Non rompe la legge: la peggiora.** È l'unico caso in cui
scendere costa **due volte**, e va detto perché è controintuitivo.

---

# 5. 📦 I TRE FILE PROVA — 6 celle, **12 passate, 2,72 minuti**

Metro di casa: **`T(min) = 0,6 + 0,077 × passate`, per ROUND.**

| ord. | file (scritto oggi, **entrambi i cancelli verdi**) | simbolo · TF | asse | celle | passate | **T (min)** | cosa chiude |
|---:|---|---|---|---:|---:|---:|---|
| **1** | `prove/R140a_impulso_M30_D30EUR.txt` | D30EUR **M30** | `InpMagic` (**tecnico**, G1) | 2 | **4** | **0,91** | il **PASSO 0** del solo motore M30 mai misurato, e **ripara un file non lanciabile** |
| **2** | `prove/R140b_impulso_M30_U30USD.txt` | U30USD **M30** | `InpMagic` (tecnico) | 2 | **4** | **0,91** | il **secondo simbolo della FAMIGLIA** — e su U30USD **M30 è il TF più alto LEGALE** |
| **3** | `prove/R140c_tfingresso_M15_770101_D30EUR.txt` | D30EUR **M15** | `InpMagic` (tecnico) | 2 | **4** | **0,91** | la **casella 5 del certificato della SECONDA SEDIA**: il TF d'ingresso, mai cambiato in 21 mesi |
| | **TOTALE** | | | **6** | **12** | **2,72** | |

## 5.1 🥇 R140a — `ABTG_ImpulsoApertura` D30EUR M30, PASSO 0

**Perché lui e non un altro.** È **l'unico** motore della banda M30 che sia insieme: **mai misurato**
(zero occorrenze in `REGISTRO_TEST.md`, zero CSV in archivio — verificato oggi), **a due lati nativi**,
e con **il cancello di costo di casa implementato DENTRO l'EA**: `InpMaxSpreadPctOfStop = 2.5` (r.155)
= *spread ≤ 2,5% dello stop* = **stop ≥ 40× spread**, e quando non passa **il trade si salta**.
👉 Su questo motore un TF fuori costo non produce trade brutti: produce **RIFIUTI**, e i rifiuti si
contano nella colonna `Reject`.

🔴 **E ripara un difetto vero, misurato oggi.** `prove/ABTG_ImpulsoApertura.txt` (08/09) è un ottimo
documento di criteri e un file **NON LANCIABILE**:
```
controlla_prova.py -> "2 assi Y: un file prova misura UNA variabile alla volta
                       (InpImpulseATRMult, InpRR)"     ESITO: FALLITO
```
Più due difetti che ho trovato leggendolo: **`InpAllowShort` pinnato a 0** mentre il suo **C2** dice
*"DUE LATI, SEMPRE (regola di casa 25/08)"* — il file contraddice il proprio criterio; e **salta il
suo stesso PASSO 0** (il C0 chiede un conteggio prima di qualunque griglia, e il file è una griglia
5×4). R140a è quel PASSO 0, scritto come lo chiede lui. Il file del 08/09 **non l'ho toccato**.

**Il costo, calcolato PRIMA e dichiarato come BANDA:**
```
spread D30EUR ora 8 (SERVER): mediana 1,70 idx -> il 40x chiede stop >= 68,0 idx
ADR D30EUR 186,5 idx [MIS, 49 giorni]  x sqrt(30/1440) = 26,9 idx          ->  15,8x
                                        x 3,05 (fattore d'apertura MIS)     ->  48,3x
BANDA: 15,8x - 48,3x
```
✅ **CLASSE 278 verificata: l'esito positivo È RAGGIUNGIBILE.** Il limite superiore (48,3x) sta
**sopra** il pavimento di lavoro: esiste un valore dentro la banda derivata dai nostri numeri
misurati che produce il PASS. Se il limite superiore fosse stato **sotto** 40x, il round sarebbe
stato *"una condanna travestita da test"* e il file **non andava scritto**: si andava a H1.
⚠️ Il fattore **3,05** è misurato sul DAX **a 15 minuti**: applicarlo a 30 è un'estrapolazione
**ottimista** (l'esplosione d'apertura è concentrata all'inizio). **48,3x è un limite superiore, non
una previsione.**

**Attesa dichiarata, con tre uscite:** (a) Trades 120-420, Reject < 40%, PF ≥ 1,10 in entrambe →
candidato M30; (b) **e me l'aspetto più probabile** Reject ≥ 60% → *"a M30 non arriva alla frontiera,
si sale a H1"*, che è il suo stesso C1 applicato **col numero**; (c) **catena rotta, che non è una
risposta**: gemelli diversi, zero passate, Trades = 0 **con Reject anche zero**.

## 5.2 🥈 R140b — `ABTG_ImpulsoApertura` U30USD M30. **E qui c'è un vincolo di CODICE**

`ABTG_ImpulsoApertura.mq5` r.329-332:
```
if(((long)MinutiDelGiorno_Calc(InpOpenHour,InpOpenMinute)*60) % PeriodSeconds() != 0)
   -> "ERRORE: l'ora d'apertura NON cade su un confine di barra del TF:
       la barra d'apertura non esisterebbe MAI e l'EA non opererebbe, in silenzio."
      (OnInit RIFIUTA)
```
Dow e Nasdaq aprono alle **14:30 ORA SERVER** = 870 minuti:
`870 % 30 = 0` → **M30 LEGALE** · `870 % 15 = 0` · `870 % 5 = 0` · 🔴 **`870 % 60 = 30` → H1
ILLEGALE** · 🔴 `870 % 120 = 30` → H2 ILLEGALE.

> ### 🎯 **Su U30USD e NASUSD questo motore NON PUÒ girare a H1: M30 è il TF più ALTO legale. Qui la banda bassa non è una preferenza — è l'unica banda esistente.**
> E ha una conseguenza sul verdetto: se il round dice no, **non c'è un TF più alto a cui salire**. Il
> verdetto **chiude il simbolo** invece di rimandarlo — che è meglio di un verdetto rimandato.

Costo: spread U30USD ora 14 **mediana 2,00** (su 4.931.660 tick) → il 40x chiede **≥ 80,0 idx**;
ADR 314,5 × √(30/1440) = **45,4 idx (22,7x)** senza amplificazione, **138,5 idx (69,2x)** con il
3,05. **Banda 22,7x - 69,2x**, positivo raggiungibile. 🔴 Orientamento indipendente: la sedia
**770202** sullo **stesso simbolo alla stessa ora** con range 15' ha stop ~102 idx = **51,0x** — e
una barra da 30 minuti è più ampia di una da 15, quindi il nostro stop atteso sta **più in alto**.
⚠️ **È un ALTRO motore e lo uso solo per orientare la banda, non come attesa**: 770202 mette lo stop
all'estremo **opposto** del range, qui è l'estremo della barra dalla parte del segnale.

🔴 **E il cancello duro C4, scritto prima**: alle 14:30 su U30USD operano già **770202** e **770611**,
**entrambe SOLO LONG**. Un terzo ramo long negli stessi giorni **triplica il rischio sullo stesso
evento** con il tetto per cluster **firmato il 07/09 ma NON attivo**. Il ramo LONG è promuovibile
**solo** se i giorni-segnale non coincidono: si misura sui per-trade, **zero passate**
(`sovrapposizione_sedie.py`, `chi_va_con_chi.py`). 🟢 Il ramo **SHORT** non collide con nessuna sedia
viva sulle aperture USA: **è lì che sta il valore atteso**, e lo scrivo prima per non farmi ingannare
dopo da un long verde.

## 5.3 🥉 R140c — `770101` D30EUR **M15**: la casella 5 del certificato della SECONDA SEDIA

`report/LA_SECONDA_SEDIA_2026-09-12.md` §3.2, casella 5, testuale:
> *"il TF del grafico è M5 in TUTTE le corse; sono stati cambiati `InpTrailTF` (M1→M20),
> `InpFilterTF` (H1/H4) e `InpLevelTF`. **Il TF D'INGRESSO, MAI.** Buco dichiarato."*

`770101` è la **seconda sedia proposta per il 1° ottobre**. La regola del 09/09 dice che un candidato
non si archivia con una casella mancante; **schierarlo** con una casella parziale è lo stesso difetto
al contrario. **4 passate la chiudono.**

**La previsione è LETTA NEL SORGENTE, prima della corsa — e non è "più o meno uguale": è IDENTICO:**

| # | il fatto | la riga |
|---|---|---|
| 1 | il range d'apertura e quindi lo **stop** si leggono su **`PERIOD_M1` CABLATO** | r.1007-1008 `iBarShift(..., PERIOD_M1, ...)` · r.1015-1016 `iHighest/iLowest(..., PERIOD_M1, ...)` · r.1019-1020 `iHigh/iLow(..., PERIOD_M1, ...)` |
| 2 | la macchina a fasi gira su **minuti d'orologio**, non su barre | r.679 `int nowMin = TimeInMinutes(now);` · r.687/711/717/723/729/738/744 tutte `if(nowMin >= ...)` · r.586-589 `ABTG_OnTick()` gestisce **a ogni tick** |
| 3 | le **tre** dipendenze da `PERIOD_CURRENT` che esistono sono **INERTI con i pin della cella viva** | r.437 `iATR(..., PERIOD_CURRENT, ...)` → serve solo a `SLMode≠RANGE` (**=0**), al trailing ATR (`TrailMode`=**1** FIXED), al filtro ATR (**false**) e a `InitialSL` r.2028-2032, il cui `riskDist` alimenta **solo** `profR` (inutile: `InpTrailStartR=0` ⇒ `trailArmato` sempre vero) e `beTarget` (inutile: `InpBEatR=0`) · r.1370 `octf` → solo ramo **OPENCONFIRM**, e il modo è **RETEST** · r.2202 `VolumeOK()` → filtro **false** (r.2155 esce `true`) |

🔬 **L'ho cercata, la candidata più probabile a rompere l'invarianza, e non rompe**: l'obiettivo
della **parziale** (r.1909) usa il `riskDist` calcolato con `partialDone = false`, che torna `curSL`,
cioè lo stop **vero** del range — **non passa dall'ATR**.

**Attesa dichiarata:** (a) **IDENTITÀ** con R47a alla quinta cifra — IS `175 / 1,12634 / 5,4362%`,
OOS `270 / 1,39709 / 7,2328%` ⇒ *"il TF d'ingresso è INERTE, misurato oltre che letto"*, casella 5
**chiusa**; (b) **i numeri differiscono** ⇒ *"770101 ha una dipendenza dal TF NON DICHIARATA"*, e
**questa uscita è più importante dell'altra**, perché è un rilievo su una sedia che va in campo il
1° ottobre; (c) catena rotta.

🔴 **E LA VERIFICA OBBLIGATORIA, che è anche il contro-esempio:** se i numeri tornano identici alla
quinta cifra, **un'identità perfetta può essere una misura o un artefatto**. Se `@PERIODO` non fosse
arrivato al tester, la corsa girerebbe **a M5 due volte** e produrrebbe **lo stesso CSV**. 👉 **Si
legge il `.ini` generato dal driver e l'intestazione del Giornale**, dove il TF del simbolo è
scritto. Non è facoltativo: è l'unico controllo che separa una misura da un'identità algebrica.

## 5.4 ✅ IL CANCELLO SUI TRE FILE, riprodotto qui

```
byte >127 (contati con python3, MAI con grep '[^\x00-\x7F]'): 0 · 0 · 0
controlla_riga.py --oggetto prova : EXIT 0 su 3 file su 3 ("file prova ASCII puro")

=== CONTROLLO FILE PROVA ===
  R140a_impulso_M30_D30EUR.txt            ABTG_ImpulsoApertura.mq5   pin=20 celle= 2  OK
  R140b_impulso_M30_U30USD.txt            ABTG_ImpulsoApertura.mq5   pin=20 celle= 2  OK
  R140c_tfingresso_M15_770101_D30EUR.txt  ABTG_DAX_Apertura_EU.mq5   pin=81 celle= 2  OK
file: 3 | celle totali: 6 | passate (celle x 2 finestre): 12 | problemi: 0
ESITO: OK
```
Igiene che i cancelli **non** controllano e che ho verificato a mano:
- **`-Modello 4` = TICK REALI · `-Modello 1` = OHLC M1** (classe 273): nei tre file il modello **non
  è pinnato**, arriva dalla riga di lancio, dove il default del driver è **4**
  (`walkforward_generico.ps1` r.180). I commenti **non sono invertiti**.
- **Il pavimento dei tick sugli indici è `2024.09.26`**, ed è `@DAQUANDO` in tutti e tre. Nessuno dei
  tre chiede una finestra più lunga dei tick, quindi **nessuno dei tre è screening**: sono verdetti.
- **`InpSessionHour = 8` = ORA SERVER BCM** in R140c · **`InpOpenHour = 8`** in R140a ·
  **`InpOpenHour = 14`, `InpOpenMinute = 30`** in R140b. Se in un CSV uscisse **9** o **15**, l'ora è
  ITALIANA e la corsa **si cestina**.
- **Nessun pin di stringa**: `InpComment` e `InpNewsCurrencies` sono lasciati al default compilato
  (un pin di stringa **vuota** MT5 lo ignora in silenzio — è la classe che è costata il round FiboH4).
- **Magic VERGINI**, `grep -rl` repo-wide il 12/09 con `.git` escluso, **0 file**: `787701`/`787751`
  (R140a) · `787702`/`787752` (R140b) · `787704`/`787754` (R140c). Nessuna collisione con le **28
  etichette in coda** (blocco `R14x` mai usato: le etichette in coda arrivano a `R139c`).
- 🔴 **UN SOLO agente locale** in MT5 → Strategy Tester → Agenti (**classe 129**): in tutti e tre i
  file la coppia gemella **è** il cancello d'identità, e con più agenti divergerebbe.

---

# 6. 🪦 GLI SCARTI, COL NUMERO — e le righe che vanno in `REGISTRO_TEST.md`

| candidato | TF | modello | **n** (IS / OOS) | **PF** (IS / OOS) | **DD** (IS / OOS) | 🚧 cancello che lo ferma | verdetto |
|---|---|---|---|---|---|---|---|
| **LA BANDA M30 come tale** — 34 coppie IS/OOS a tick, 8 famiglie, 12 simboli | M30 | 🎯 tick | fino a **1.151** OOS | **0 su 34** con PF ≥ 1,10 in entrambe | DD OOS mediano **6,61%** | **PF in entrambe le finestre**, e il campione non è la scusa (24/34 con n ≥ 150 OOS) | 🪦 **la banda M30 sui motori a stop SCALANTE è misurata e negativa** |
| **LA BANDA M20** | M20 | 🎯 tick | fino a 594 | **0 su 34** | 8,90% | idem | 🪦 idem |
| `ABTG_SupertrendReversal_Multi_Ott` **XAUUSD** — 🥇 *la migliore cella M30 dell'archivio* | M30 | 🎯 tick | **257 / 427** (deal; `TP1Pct=50` ⇒ posizioni **[NON MISURATE]**) | **1,25637 / 1,08718** | 10,66% / **22,06%** *(a taglia **2,0%**)* | 🔴 **PICCO, non altopiano**: i vicini sullo stesso asse fanno **IS 0,709 (M20)** e **IS 0,984 (H1)** · 🔴 PF OOS **1,087 < 1,10** (a 1,3% dalla soglia) | 🪦 **scartata per REGOLA DI SELEZIONE.** 🟢 **NON per rischio**: il DD 22,06% è a 2,0%; scalato a 0,65% fa **~7,17%** [DERIVATO, lineare] — dentro il muro |
| `ABTG_EMA200_Ottimizzato` **XAUUSD** | M30 | 🎯 tick | 460 / 674 | **0,78220 / 1,10258** | 16,91% / 9,68% (a **1,0%**) | 🔴 **IS in perdita** · DD IS 16,91% > 10% | 🪦 scartata |
| `ABTG_SupRev_DOW_H4_Ott` **U30USD** | M30 | 🎯 tick | 163 / 362 | **0,66190 / 1,36960** | 7,78% / 5,24% | 🔴 **IS in perdita** (merito incoerente fra finestre) | 🪦 scartata |
| `ABTG_SuperWave` **U30USD** | M30 | 🎯 tick | 122 / 290 | **1,20400 / 0,93050** | 4,79% / 8,48% | 🔴 **OOS in perdita** · n IS 122 < 150 | 🪦 scartata |
| `ABTG_SupRev_DAX_H1_Ott` **D30EUR** | M30 | 🎯 tick | 181 / 328 | **0,60690 / 0,98750** | 12,00% / 9,41% | 🔴 tutte e due sotto 1,10 · DD IS 12,00% > 10% | 🪦 scartata |
| `ABTG_SupRev_NAS_H1_Ott` **NASUSD** | M30 | 🎯 tick | 84 / 185 | **0,78190 / 0,86810** | 3,74% / 4,21% | 🔴 tutte e due sotto 1,10 | 🪦 scartata |
| `ABTG_SupertrendReversal_Multi_Ott` **XAUUSD** | **M15** | 🎯 tick | 511 / 882 | **0,75290 / 1,14283** | **42,58%** / **18,48%** (a 2,0%) | 🔴 IS in perdita · 🔴 **DD 42,58%** = **13,84% a 0,65%** [DERIV.], sfonda il muro | 🪦 **scartata per RISCHIO** |
| **la DISCESA DI TF su tutta la CLASSE G** (21 sedie, elencate per nome al §2.0) | M5/M15/M30 | — | — | — | — | 🔴 **guadagno di frequenza `0,00`, MISURATO DAL CODICE** (`InpOneTradePerDay`, box notturno, candela D1, gap settimanale, pip fissi) | 🪦 **non si scende: non c'è niente da comprare** |
| `ABTG_CostToCost` EURJPY / GBPCAD | M30 | — | — | — | — | 🔴 **COSTO**: 9,1x e 7,0x (`k=0,50`), **3,4x e 2,7x** (`k` misurato) — **sotto il DURO 13,3x** | 🪦 **escluso PER COSTO, col numero** |
| `ABTG_SupertrendReversal` **225JPY** | M30 | — | — | — | — | 🔴 **COSTO**: 6,8x / 3,6x. ⚠️ e lo spread 35 è una **[LETTURA UNICA]** presa alle 01:34 di Tokyo, cash chiuso | 🪦 **escluso per COSTO** — ⚪ con la riserva sullo spread |
| `ABTG_PTE` U30USD · `ABTG_BreakingBand` EURUSD · `ABTG_SupRev_NAS_H1` NASUSD · `SuperWave_DOW_H1` U30USD · `SupRev_DAX_H4` D30EUR · `SupertrendRev_Ott` XAUUSD · `SuperWave` U30USD | M30 | — | — | — | — | 🔴 **COSTO**: da 16,6x a 21,7x col `k` misurato — sopra il duro, **sotto il 40x** | 🪦 **esclusi PER COSTO, col numero** |
| `ABTG_Nasdaq_Apertura_US` 770250 · `ABTG_GapFill` U30USD 772234 · `ABTG_DAX_Apertura_EU` 770101 · `ABTG_ORB_Ott` 770611 · `PostNews` ×3 · `GapContinuation` 774101 | **qualunque** | — | — | — | — | 🔴 **COSTO a QUALUNQUE TF** (classe G, il rapporto non cambia): 37,2x · 35,0x · 33,0x · 29,5x · 28,9/26,7/21,9x · 13,7x | 🪦 **sotto il 40x, sopra il duro** (tranne 774101, al limite) — e **scendere non cambia il numero** |

🔓 **E LE ESCLUSIONI "PER SOLA FREQUENZA", rilette con la firma del 07/09** (pavimento dalla SEDIA
alla **FAMIGLIA**):

| caso | come era scritto | come si legge **oggi**, col numero | dove va |
|---|---|---|---|
| `ABTG_MaxMinNotte_DAX_Short` 770411 D30EUR M15 | *"frequenza 0,078 op/g = 13× sotto il pavimento"* | 🔓 **La famiglia MaxMinNotte a due sedie (D30EUR + XAUUSD) resta sotto 1,00.** E 🔴 **scendere di TF non aiuta**: il box è 23:00-04:59 (ore server) e l'ATR sta su `InpMgmtTF`, input **separato** → 1 setup a notte a qualunque TF. **La frequenza qui si compra solo con altri SIMBOLI** | **in coda all'imbuto**, mai in campo in automatico |
| `ABTG_EMA200` H4 su AUDJPY/GBPJPY/200AUD/SPXUSD/GBPUSD | *"frequenza"* | 🔓 già rilette in `LA_SECONDA_SEDIA` §2.1: famiglia a 5 simboli **0,55-0,80 pos/g**, sotto 1,00. 🆕 **E la discesa a M30 non le salva**: `EMA200` U30USD a M30 fa **28,1x** col `k` misurato, e le celle M30 di `EMA200` su GBPUSD/AUDJPY/GBPJPY/SPXUSD/XAUUSD sono **0 su 5** con PF ≥ 1,10 in entrambe (n da 415 a 1.151: **campione abbondante**) | **in coda**, per **dopo** ottobre |
| `ABTG_LVNArbitro` U30USD M30 | *"bocciato per RISCHIO"* | 🔴 **resta bocciato, e la firma del 07/09 non lo tocca**: era bocciato per **DD**, non per frequenza (la sua frequenza era **1,57 op/g**, la migliore del parco). La porta di rientro è un **meccanismo di gestione nuovo**, non un parametro | **chiuso** |
| `ABTG_IBRetest` M30 ×3 indici | *"C0: PF famiglia 0,7798"* | 🔴 **resta chiuso**: è un PF **misurato e brutto**, non un numero mancante. Ciò che si può riprendere è **la GESTIONE DELL'USCITA** (misurato: **il 62% dei trade muore del flat di fine seduta**), e sarebbe **un motore nuovo, non una cella nuova** | **chiuso** — la gestione è una tesi nuova |

---

# 7. 🕳️ I BUCHI DICHIARATI — elencati **per nome** (classe 180)

| # | cosa manca | perché | conseguenza, in numeri | costo per chiuderlo |
|---:|---|---|---|---|
| 1 | 🔴 **L'ESPONENTE `k` della legge di scala ha UN SOLO punto di misura** | `SuperWave` U30USD H1 (n=4) contro H4 (n=8), due epoche diverse | **k = 0,968 contro k = 0,50 assunto**: su `SuperWave` U30USD a M30 la differenza è **52,2x contro 19,7x**, cioè PASSA o NON PASSA. **È il buco più importante di tutto il dossier** | un round diagnostico sulla distribuzione degli stop a due TF |
| 2 | **lo spread orario di `F40EUR`, `AUDJPY`, `GBPJPY`, `CHFJPY`, `EURAUD`, `AUDUSD`, `225JPY`** | `spread_flotta/` ha **3 file su 12 simboli**; alla sonda del 17/08 leggono `SpreadPt = 0` = *nessun tick in quell'istante*, **non** spread nullo | le loro righe della graduatoria sono **⚪ sospese**, mai 🟢 e mai 🔴. Su `225JPY` due sedie hanno un verdetto di costo che poggia su **una lettura sola alle 01:34 di Tokyo, cash chiuso** | `ABTG_SpreadOrario` / `ABTG_SpreadLogger`, **ZERO passate di tester** |
| 3 | **lo spread al MINUTO dentro l'ora** | l'istogramma è **ORARIO** e le ore 8 (DAX) e 14 (USA) **contengono la campanella** | **tutti i rapporti di questo dossier sugli aperture sono OTTIMISTI PER COSTRUZIONE**. Indizio nel dato stesso: `U30USD` ora 14 ha mediana 2,00 e **max 47,0** | un passaggio di `ABTG_SpreadLogger` con granularità al minuto |
| 4 | **il pedaggio si paga DUE volte** e l'ora dell'**USCITA** è `[NON MISURATA]` su ogni sedia | il cancello 40x è definito contro **UNO** spread e resta così per confrontabilità | **il pedaggio vero è circa il doppio**, su tutte le righe | — |
| 5 | **il fattore d'apertura 3,05** | misurato sul **DAX** e su una finestra di **15 minuti** | su `U30USD` è [INFERITO] **due volte** (altro simbolo, altra finestra), e nel verso **ottimista** | misura diretta della distribuzione dei range 8:00-8:30 / 14:30-15:00 |
| 6 | **`n` in POSIZIONI delle celle M30 dell'archivio** | i loro per-trade non sono in archivio, e `InpTP1Pct = 50` ⇒ deal ≠ posizioni | le `n = 257 / 427` della cella migliore sono **DEAL**: in posizioni sono **[NON MISURATE]**, e col rapporto 2,0117 misurato altrove sarebbero ~**128 / 212** — 🔴 **il che porterebbe l'IS SOTTO il pavimento dei 150** | 2 passate con l'export per-trade |
| 7 | **la finestra delle 34 corse `InpTF`** | i file prova `ABTG_Sup*`/`ABTG_SuperWave*`/`ABTG_WOL*` **non hanno `@DAQUANDO`**: la finestra arrivava dalla riga di lancio del 07-11/08 | 🟢 **non tocca i miei verdetti**, perché tutti i confronti fra TF sono **DENTRO lo stesso CSV** (stessa corsa, stessa finestra): la finestra si elide. 🔴 Ma i **valori assoluti** di PF e n di quelle celle non sono datati | rileggere lo zip della corsa dell'11/08 |
| 8 | 🔴 **il valore di «Max barre nel grafico» sul PC di backtest** (terminale **50504400**, `C:\MT5_Backtest`) | **`walkforward_generico.ps1` NON scrive `[Charts] MaxBars`** (verificato: grep, zero occorrenze). Lo scrivono solo i driver dedicati `RIGA_R107`, `RIGA_R111`, `RIGA_STORICO_INDICI` | 21 mesi di `D30EUR` a **M5** sono ~**126.000 barre** [DERIVATO: ~23 h/giorno × 12 barre/h × ~459 sedute], **sopra il tetto delle ~100.000**; a M15 ~42.000, a M30 ~21.000. 🟢 **Che il tetto abbia tagliato l'IS di R47 è FALSIFICATO** (§8), ma il valore del tetto resta ignoto | **ZERO passate**: si legge da MT5 → Strumenti → Opzioni → Grafici |
| 9 | **la PROVA DI REGIME sugli indici** | storico BCM dal **2024.09.26**, stato **`COMPLETO`**: il broker non ha nulla prima | 21 mesi = **UN regime, toro**. La regola C dell'Emendamento della Finestra **non è soddisfatta e non lo sarà il 30/09**. Nessuna cella di questo dossier è promuovibile senza | dati esterni (`NASUSD_EXT`), e solo come **screening** |
| 10 | **il valore del punto di `D30EUR` e `F40EUR`** | la riga `D30EUR` della sonda del 17/08 non ha `TickValue` leggibile | derivato coerente **~1 EUR/idx/lotto**. Sentinella: se una cella larga torna con `Trades` basso **e** profitto ~0, il sospetto è **lotto nullo**, non edge | una passata della sonda |
| 11 | **la sovrapposizione dei giorni-segnale** di `ImpulsoApertura` con `770101` (DAX) e con `770202`+`770611` (Dow) | non ricavabile dai CSV di riepilogo | 🔴 **il verdetto del ramo LONG di R140a e R140b è CONDIZIONATO a questa misura** (cancello C4). Tre sedie long sulla stessa campanella con il tetto per cluster **spento** non sono tre rischi: sono **uno** | **ZERO passate**: `sovrapposizione_sedie.py`, `chi_va_con_chi.py` sui per-trade |
| 12 | **l'ORA dei trade riempiti** | le colonne dell'`OnTester` non la contengono (buco già dichiarato dal P0 IBRetest del 09/09) | la sentinella S4 di R140b si verifica sui **pin** del CSV, non sull'**esito**: se `InpOpenMinute` uscisse 0, l'EA misurerebbe la barra delle 14:00 — **che esiste**, quindi la corsa **sembrerebbe riuscita** | 8 righe di codice nell'`OnTester` |
| 13 | **`NASUSD`, il terzo simbolo della famiglia `ImpulsoApertura`** | non l'ho scritto per non consegnare 12 passate quando la domanda si decide sulle prime 8 | la sua riga è **identica a R140b** (apre alla stessa ora, 14:30 server) | 4 passate, file da scrivere |
| 14 | 🔴 **`ABTG_HVAncora` U30USD M30: il file c'è, il cancello è VERDE, e non è MAI STATO LANCIATO** | — | 4 passate già scritte e mai spese. Stesso cancello di costo in codice (`InpMaxSpreadPctOfStop = 2.5`), due lati, attesa già dichiarata (*"130-350 ancore e 50-200 operazioni, 0,11-0,45 op/g"*) | **ZERO passate da scrivere**: `prove/ABTG_HVAncora_00_conta.txt`, magic 776900/776950 |
| 15 | **`BREAKOUT_EA_JPY_v3` USDJPY M15 e `Gold_Ichimoku_TK_ATR_EA` 250604 XAUUSD M5** | **il sorgente non è nel repo** | due sedie vive su 42 **non classificabili**: non so se il loro stop scala col TF. Restano ⚪ **NON ANCORA MISURATO** | recuperare i due `.mq5` |

---

# 8. 🧪 IL CONTRO-ESEMPIO CONTRO IL PRIMO CLASSIFICATO — costruito da me, e non cade

Il primo della consegna è **R140a** (`ABTG_ImpulsoApertura` D30EUR M30). Il contro-esempio non è
contro il round: è contro **la ragione per cui lo metto primo**, cioè *"a M30 non è ancora stato
misurato niente che valga"*.

## 8.1 La trappola A — **«hai messo primo un motore mai misurato su una banda già bocciata otto volte»** · e in parte HA RAGIONE
È il rischio che la regola del 19/08 esiste per fermare. **Quale numero la distingue?**
La regola vieta di allargare **i parametri di un motore già dichiarato senza edge con un PF
misurato**. `ABTG_ImpulsoApertura` **non ha nessun PF misurato**: zero occorrenze in
`REGISTRO_TEST.md`, zero CSV in archivio, verificato oggi. E le otto bocciature M30 sono su **otto
ALTRE famiglie**, tutte di **classe S**, mentre questo è un **motore d'apertura**: cioè la sola classe
che a M30 non è **mai** stata provata. 🟢 **Passa.**
⚠️ **Ma il limite va scritto**: la classe S a M30 è 0/34, e questo motore ha lo stop di **classe S**
(range della barra operativa). Quindi **erediterebbe il difetto di costo**, non il difetto di merito.
**È esattamente ciò che R140a misura, e il suo esito atteso più probabile è (b), il numero brutto.**
Chi legge questo referto e si aspetta una sedia da R140a, non ha letto questa riga.

## 8.2 La trappola B — **«il tetto delle barre ha tagliato R47, quindi il tuo confronto in R140c non ha metro»** · **FALSIFICATA, con il numero**
**L'ipotesi alternativa**: a M5 la corsa di R47 ha sbattuto contro il tetto delle ~100.000 barre
(21 mesi di D30EUR a M5 sono ~126.000 [DERIVATO]), la finestra vera è più corta della nominale, e le
193 posizioni stanno su meno storico di quanto crediamo.
**Quale numero produce l'ALTRA spiegazione?** Il tetto taglia lo storico **più vecchio**, cioè l'**IS**.
Allora la frequenza dell'IS dovrebbe essere **molto più bassa** di quella dell'OOS.
```
IS : 132 posizioni / 183 giorni feriali = 0,721 pos/giorno
OOS: 193 posizioni / 265 giorni feriali = 0,728 pos/giorno
scarto: 1,0% su 325 posizioni totali
```
👉 **L'alternativa prevede uno scarto grande e la misura ne trova l'1,0%: falsificata sui dati, non
sul nulla.** *(Le due frequenze non le ho stimate io: sono `position_id` distinti contati nei
per-trade di R47, `risultati_prove/aperture_r47/abtg_trades_..._{772501,772503}.csv`, e lo stesso
conto sta in `LA_SECONDA_SEDIA` §1.3.)*
⚠️ **Limite dichiarato**: questo falsifica *"il tetto ha tagliato l'IS"*, **non** *"il tetto è alto"*
(buco #8).

## 8.3 La trappola C — **«il tuo ×1,97 è un'identità algebrica: dimezzi il TF e raddoppi le barre»**
🔴 **È il difetto che oggi abbiamo pagato altrove, e me lo sono chiesto.** Se il rapporto fosse un
artefatto della costruzione, uscirebbe **2,000** (o un numero costante su tutte le serie).
**Cosa esce invece?** Mediana **1,97** con banda **1,13 - 3,33** su 58 serie, e il secondo gradino
fa **1,85** con banda **0,93 - 2,67** — 🔴 **e una serie sta SOTTO 1,00** (`WOL` GBPUSD, 0,93: a M15
fa **meno** trade che a M30). 👉 **Una dispersione da 0,93 a 3,33 e un gradino diverso dall'altro
non sono un'identità: sono una distribuzione.** Se fossero usciti **2,000 al quarto decimale su
tutte le serie**, la risposta giusta sarebbe stata *"torna per costruzione"*, e non avrei scritto il
numero.
🔬 **E c'è una verifica contro numeri scritti da qualcun altro**, che è la prova che conta: `R108`
(BreakingBand M15) e `R111` (BreakingBand M30) sono **due round indipendenti**, girati il 25 e il
26/08 da un'altra sessione, sulla **stessa epoca 2022-2026** e sullo **stesso GBPUSD** a tick reali.
`n M15 = 227` contro `n M30 = 174` ⇒ **×1,304**. 👉 **Sta DENTRO la mia banda (0,93-2,67) ed è ben
sotto la mediana**: il mio numero non è tarato su quello, e quello non lo smentisce. 🔴 **E aggiunge
una cosa che il mio dato non diceva: il moltiplicatore dipende dal MOTORE.** Su una banda fa 1,30,
su un supertrend fa 1,85. **Non si usa un solo numero per tutti, e l'ho scritto come mediana con la
banda proprio per questo.**

## 8.4 🚫 E cosa NON ho potuto rompere, quindi resta in piedi
- **La prova di regime.** Non esiste e non esisterà entro il 30/09. Vale per tutti e tre i file.
- **L'esponente `k`.** Ho **un** punto di misura. Con `k = 0,50` sette motori di classe S passano il
  40x a M30; con `k = 0,968` **zero**. 🔴 **Il verdetto del §2 sulla classe S cambia con quel
  numero**, e il numero ha n=4 e n=8. L'ho scritto in due colonne invece di scegliere.
- **La sovrapposizione con le sedie vive della campanella.** Senza quella misura il ramo LONG di
  R140a/R140b **non è promuovibile**, qualunque PF esca.

---

# 9. 🏁 LA RISPOSTA A CLAUDIO, senza addolcirla

> ## 🔴 **«Quanti motori nostri possono legittimamente scendere a M5/M15/M30?» — POCHI. Ed è questo il numero.**

| | quanti | chi | il numero accanto |
|---|:--:|---|---|
| 🟢 **Passano il 40x a M30 con l'esponente PRUDENTE** | **4** su 42 | `PunteLarry` XAUUSD (236,2x) · `MaxMinNotte` XAUUSD (126,5x) · `PunteLarry` U30USD (105,5x) · `Dow_Apertura_US` U30USD (51,0x). *(Il quinto candidato, `MaxMinNotte_DAX_Short` 770411, e' **[NON MISURATO]**: 0 gambe in stop su 5 trade.)* | 🔴 **tutte e cinque di CLASSE G: scendendo guadagnano `0,00` operazioni.** Il permesso c'è, il motivo no |
| 🟡 **Sotto il 40x ma sopra il duro, a qualunque TF** | **8** | `Nasdaq_Apertura` 37,2x · `GapFill` U30USD 35,0x · `DAX_Apertura_EU` **33,0x** · `ORB_Ott` 29,5x · `PostNews` ×3 (28,9 / 26,7 / 21,9x) · `GapContinuation` 13,7x | classe G: **il numero non cambia col TF**. Sono "raccomandazioni", non scarti per aritmetica |
| 🔴 **NON possono scendere a M30: costo** | **14** di classe S (su 19; le altre **5 sono [NM]**) | `EMA200` 28,1x · `EMA200_Ott` XAU 21,7x · `SuperWave` ×2 19,7x · `SupertrendRev_Ott` XAU 18,1x · `PTE` 16,6x · `SupRev_NAS` 14,7x · `SupRev_DAX` 13,4x · `BreakingBand` 13,1x · `EasyTrend` GBP 24,1x · `CostToCost` ×2 3,4x e 2,7x · `SupertrendReversal` 225JPY 3,6x | col `k` **misurato**, **ZERO** dei 19 motori di classe S passa il 40x a M30 |
| 🔴 **NON possono scendere: merito già MISURATO e negativo** | **8 famiglie** | `SuperWave` · `WOL` · `EMA200` · `SupertrendInvert` · `SupertrendReversal` · i `SupRev_*_Ott` · `EMA200_Ott` · `BreakingBand` (R111) | **0 su 34 coppie IS/OOS a tick** con PF ≥ 1,10 in entrambe, a M30 e a M20 |
| ⚪ **NON ANCORA MISURATO** | **16** | `MaxMinNotte_DAX_Short` (stop) · `PunteLarry` GBPJPY/EURAUD/GBPUSD/EURCAD · `GapFill` GBPUSD/EURUSD/AUDUSD/225JPY · `EasyTrend` CHFJPY · `BreakingBand` GBPUSD/AUDUSD · `PTE` GBPUSD ×2 · `BREAKOUT_EA_JPY_v3` · `Gold_Ichimoku` 250604 | **[NON MISURATO]**, e per 7 su 10 manca lo **spread**, non lo stop: si chiude con `ABTG_SpreadLogger`, **zero passate di tester** |
| 🟢 **La casella DAVVERO libera a M30** | **3 motori** | `ABTG_ImpulsoApertura` (→ **R140a** e **R140b**) · `ABTG_HVAncora` (**file già pronto e mai lanciato**, 4 passate) · la via `GAPCASH_RICONQUISTA` | sono i **soli tre** con zero PF misurato a M30, due lati nativi e il cancello di costo **dentro l'EA** |

🔢 **E i conti quadrano, perche' una tabella che non somma non e' una misura:**
`4 + 8 + 14 + 16 = 42` sedie. Per classe: **G 21** (4 passano · 8 sotto il 40x · 9 [NM]) ·
**S 19** (14 misurate, tutte sotto il 40x a M30 · 5 [NM]) · **non classificabili 2**
(`BREAKOUT_EA_JPY_v3`, `Gold_Ichimoku_TK_ATR_EA`: sorgente non nel repo).

## 🎯 E LA COSA PIÙ UTILE CHE ESCE DA OGGI, in una riga
🔴 **Non è che M5/M15/M30 siano vietati: è che non contengono la frequenza che stiamo cercando.**
La frequenza in questo progetto ha **un solo interruttore misurato**, e non è il timeframe: è il
**numero di SIMBOLI** (firma di Claudio del 07/09, pavimento 1,00 op/giorno per **FAMIGLIA**).
👉 **La mossa più economica in assoluto verso il 1° ottobre non è un round: è aggiungere un simbolo a
una famiglia che funziona.** `R138a` (già in coda) fa esattamente questo su `770101`
(`0,728 + 0,28 = 1,00`), e `R140b` lo fa su `ImpulsoApertura`.

## 🙋 LE TRE COSE CHE CHIEDO A CLAUDIO, e costano meno di dieci minuti in tutto
1. 🖥️ **Sul PC di backtest** (finestra PowerShell, e **nessun terminale MT5 da toccare**): leggere
   `MT5 → Strumenti → Opzioni → Grafici → «Max barre nel grafico»` sul terminale **50504400**
   (`C:\MT5_Backtest`). **Zero passate**, e chiude il buco #8 che oggi rende il confronto di R140c
   interpretabile solo con una riserva.
2. 🔓 **Una firma, non un round**: `prove/ABTG_HVAncora_00_conta.txt` è **pronto, gatato e mai
   lanciato** dall'08/09. Sono **4 passate = 0,91 minuti** sulla banda M30 che lui stesso ha chiesto.
   Serve solo la decisione di metterlo in coda — **e la coda è sua, non mia**.
3. 💱 **`ABTG_SpreadLogger` con `F40EUR`, `225JPY`, `AUDJPY`, `GBPJPY`, `CHFJPY`, `EURAUD`, `AUDUSD`
   nella lista.** **ZERO passate di tester** (è un logger dal vivo) e sblocca **10 righe sospese**
   della graduatoria. Lo segnalano **otto cacce di fila** e non è mai stato fatto.

## 🟢 E COSA È ANDATO BENE, perché un elenco di difetti senza le vittorie descrive male la realtà
- 🏺 **L'archivio era pieno e nessuno l'aveva aperto**: **168 CSV M30**, 68 a tick reali, un asse
  `InpTF` a 11 celle su 12 simboli. Quella è una **caccia da settimane** che era già stata pagata
  nell'agosto 2026 e mai letta oltre la cella viva (il referto dell'11/08 lesse solo *"la famiglia
  SupRev respira sui TF alti"*). **Oggi quei numeri hanno un verdetto.**
- 🧩 **Una legge nuova, falsificabile e già falsificata una volta** (dal caso `ImpulsoApertura`, che
  la peggiora invece di romperla): **l'ancoraggio dello stop e l'ancoraggio del segnale sono la
  stessa proprietà.** Costa zero applicarla al prossimo candidato e fa risparmiare round interi.
- 🔧 **Un file prova non lanciabile trovato e riparato** prima che qualcuno ci spendesse una notte.
- 📐 **Un vincolo di codice trovato che nessuno aveva scritto**: su Dow e Nasdaq
  `ABTG_ImpulsoApertura` **non può girare a H1** (`870 % 60 = 30`, `OnInit` rifiuta). Se qualcuno
  avesse provato a "salire di TF" avrebbe avuto un EA che non parte, in silenzio.
- 🪑 **La seconda sedia ha una casella in meno aperta**, e per 4 passate.

---

## 📚 FONTI — tutte sul branch `lavoro`, tutte aperte e ricontate oggi

**🥇 MISURATO (rango 1), riletto sui file grezzi:**
`backtest_pipeline/risultati_prove/ABTG_{SuperWave,WOL,EMA200,SupertrendInvert,SupertrendReversal,SupRev_*,EMA200_Ottimizzato,SuperWave_*}/` (**168 CSV con la cella M30**, 34 coppie IS/OOS a tick) ·
`risultati_prove/ABTG_{IBRetest,LVNArbitro}/` e `risultati_prove/ibretest_p0/` (i due P0 M30) ·
`risultati_archivio/spread_flotta/spread_orario_{D30EUR,U30USD,NASUSD}.csv` (30,9 + 64,7 + 156,1 milioni di tick) ·
`risultati_archivio/{R95,R111,R108}_REFERTO.md` · `risultati_archivio/REFERTO_FUORILISTA.md` (l'11/08 che lesse quegli sweep) ·
`risultati_prove/aperture_r47/` (8 CSV + 8 per-trade) · `risultati_prove/ABTG_PunteLarry/notte/scan_larry_*.csv` (48 simboli, `InpTF` **pinnato a H1**) ·
`backtest_pipeline/coda/CODA.txt` (40 righe, **sola lettura**) · `backtest_pipeline/prove/COLLAUDO_EMADOW_05_tf_U30USD.txt` r.126 ·
`backtest_pipeline/calcola_pedaggio_forex.py` (`_v3`, **autotest tutto VERDE oggi**)

**📖 SORGENTI LETTI RIGA PER RIGA:** `mql5/Experts/ABTG_DAX_Apertura_EU.mq5` (r.437 · 679 · 687-745 · 1007-1020 · 1370 · 1896-1955 · 2007-2032 · 2155-2202) ·
`ABTG_ImpulsoApertura.mq5` (r.108-160 · 316-332 · 409-415 · 476-484) · `ABTG_PunteLarry.mq5` (r.142 · 152-157 · 283 · 415-420) ·
`ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5` (r.45-79 · 139 · 273-286) · `ABTG_SuperWave.mq5` e `ABTG_SuperWave_DOW_H1_Ottimizzato.mq5` (r.52 · 78-80 · 259 · 365-367, **identici**) ·
`ABTG_GapFill.mq5` (r.128 · 245) · `ABTG_CostToCost.mq5` (r.149 · 401) · `ABTG_EasyTrend.mq5` (r.179) · `ABTG_BreakingBand.mq5` (r.269 · 501) ·
`ABTG_PTE.mq5` (r.51 · 294-296) · `ABTG_EMA200.mq5` (r.49 · 260) · `ABTG_IBRetest.mq5` (r.139-205) · `ABTG_LVNArbitro.mq5` (r.126-164) · `ABTG_HVAncora.mq5` (r.228-239) ·
`ABTG_Dow_Apertura_US.mq5` (r.226) · `ABTG_Nasdaq_Apertura_US.mq5` (r.205) · `ABTG_ORB_Ottimizzato.mq5` (r.135) · `ABTG_PostNews.mq5` (r.98 · 105) ·
`backtest_pipeline/walkforward_generico.ps1` (r.173-185; **e NON contiene `MaxBars`**) · `backtest_pipeline/controlla_prova.py` (i cinque controlli)

**🥈 REFERTI E CRITERI:** `report/LA_SECONDA_SEDIA_2026-09-12.md` · `report/INDURIMENTO_PROP_DUE_SEDIE_2026-09-12.md` ·
`report/CENSIMENTO_USCITE_MAI_PROVATE_2026-09-11.md` · `report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` ·
`report/ROUND_ORB_ATR_PS5_2026-09-10.md` · `report/MISURA_SPREAD_FOREX_2026-09-12.md` ·
`report/EMA200_I_DUE_REQUISITI_2026-09-12.md` · `report/CACCIA_M30_INDICI_2026-09-08.md` ·
`backtest_pipeline/caccia_strategie/CACCIA_TFBASSO_FREQUENZA_2026-09-06.md` §6.3 (*«il timeframe delle barre è gratis»*) ·
`report/P0_LVNARBITRO_2026-09-08.md` · `report/EA_IMPULSO_APERTURA_2026-09-08.md` ·
`backtest_pipeline/REGISTRO_TEST.md` (r.1941 IBRetest · r.2270-2290 i TF esclusi per costo su U30USD) ·
`report/FIRME_2026-09-07.md` · `report/IL_GUARDIAN_IN_CAMPO_2026-09-12.md`

> **Se un referto e questo dossier divergono, comanda il referto** — tranne sui numeri che questo
> dossier **ricalcola dai file grezzi e dichiara come misura nuova** (§1.2, §2.2, §3).
