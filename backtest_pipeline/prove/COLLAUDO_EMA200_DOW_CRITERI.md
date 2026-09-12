# COLLAUDO PROP -- `ABTG_EMA200` U30USD H1 (cella viva, magic 771531)

> **CRITERI CONGELATI IL 12/09/2026, PRIMA DI QUALUNQUE NUMERO NUOVO.**
> Un collaudo senza questo file committato prima dei numeri non e' un collaudo:
> e' una spazzolata. Commit di questo file: **prima** di lanciare/leggere
> qualunque prova di stress elencata sotto.

---

## 0. LA CELLA ESATTA, e da dove arriva

| voce | valore | fonte |
|---|---|---|
| EA | `ABTG_EMA200` (`#property version "1.00"`) | `mql5/Experts/ABTG_EMA200.mq5` |
| simbolo / TF | **U30USD** / **H1** (`InpTF=16385`) | idem |
| magic di provenienza | **771531** (sedia viva, demo piccolo 50503392) | `mql5/Presets/sedie_piccolo/recupero2/sedia_ABTG_EMA200_771531.set:49` |
| cella | `InpOrder1Atr=0.2` · `InpOrder2Atr=0.3` · `InpTP_RR=2.0` · `InpSLatr=1.0` · `InpMinRR=1.0` · `InpTP1_ATRmult=0.0` · `InpTP1Pct=50.0` · `InpBreakeven=true` · `InpUseTrailing=true` · `InpUseCutoff=false` · `InpMaxTradesPerDay=0` · `InpMaxSpread=0` · **L+S** | `backtest_pipeline/prove/R112_00_metro.txt` r.56-102 |
| referto di validazione da cui arriva | **R112** (G0-B: riproduce R110 al centesimo) · a monte R31/R110 · dossier `report/DOSSIER_SCHIERAMENTO_EMA200_DOW_2026-09-09.md` | `risultati_archivio/R112_REFERTO.md` |
| banco della base | **Modello 4 (tick reali)**, deposito **100.000**, rischio **1,0%**, finestra **2024.09.26 -> 2026.06.30**, split 40/60 (OOS 2025.06.12 -> 2026.06.26) | `righe/RIGA_R112_EMADOW_CONTRATTO.ps1:204` · per-trade R112 |
| numeri della base (OOS, tick) | **PF 1,52365 · DD equity 7,8323% · 517 deal di uscita = 257 POSIZIONI · +23.321,47** | `risultati_prove/ABTG_EMA200/ABTG_EMA200_U30USD_OOS_r31.csv` · `risultati_archivio/R112_CORSA_20260826/pertrade_00_metro_763400.csv` |
| numeri della base (IS, tick) | **PF 1,20110 · DD 5,7325% · 237 deal** (posizioni **[NON MISURATO]**, stima 102-118) | `..._U30USD_IS_r31.csv` |

**Identita' preset vivo / cella collaudata -- VERIFICATA MECCANICAMENTE oggi:**
**41 chiavi identiche su 42 comuni; unico delta `InpMagic`** (771531 vs 763400).
L'EA ha **44** `input`, il `.set` **42**, `R112_00_metro.txt` **43**: due input
non sono coperti dal `.set` e prendono il default compilato —
`InpUsaGuardian=true` e `InpLogImbuto=true` (quest'ultimo **solo log**).
⚠️ **ERRATA del 12/09**: la prima stesura diceva *"46 chiavi su 46"*, che e'
**sopra l'universo** (l'EA non ha 46 input). Numero corretto dal cancello di
giudizio, **classe 263**. 🟢 **La tesi non cambia** — la cella collaudata e'
quella che gira — cambiava solo il numero, ed era gonfiato.
=> **si sta collaudando la cella che gira davvero.** Questo controllo esiste
perche' il progetto ha gia' pagato due volte `InpTP1_ATRmult=0` contro 0,5.

## 0.1 LA COSTANTE DI CONVERSIONE, dichiarata

- **1 punto indice U30USD = 100 punti MT5** (`R118_PAVIMENTO_STOP_CRITERI.md` §4.4: 2000 punti MT5 = 20 punti indice).
- **valore del punto indice = 0,861 EUR per 1,00 lotto** (misurato su 6 stop pieni del conto vivo, `DOSSIER_SCHIERAMENTO_EMA200_DOW_2026-09-09.md` §4.1; **in conflitto** con `CONTRACT_SIZE 10` di `R114_CORSA_20260827/REFERTO_R114.txt` r.52, e vince la misura viva).
- spread U30USD **misurato**, 64,7 M tick, ora per ora: `risultati_archivio/spread_flotta/spread_orario_U30USD.csv`. Mediana **1,8-2,0** punti indice nelle ore **14-21 server**, **2,6-2,8** nelle ore **0-13 e 23**. Ore in **ORA SERVER BCM** (= ora italiana - 1).

---

## 1. LA SCALA DI STRESS -- completa, e con i suoi limiti dichiarati

### PROVA A -- SPREAD A SCALA
Scala di casa, sullo spread **mediano misurato** della fascia in cui il motore
lavora (**1,9 punti indice = 190 punti MT5**, ore 14-21 server, dove cade il
55,7% delle uscite):

| gradino | spread | in punti MT5 | stato |
|---|---|---|---|
| base | tick reali registrati | `Spread=0` | gia' misurato (R31/R110/R112) |
| +25% | 2,375 pt indice | **238** | da misurare |
| +50% | 2,85 pt indice | **285** | da misurare |
| +100% | 3,8 pt indice | **380** | da misurare |

**BLOCCO DICHIARATO PRIMA, e non e' aggirabile:** non si sa se MT5 onori la
riga `Spread=` dell'`.ini` a **Modello 4**. Non e' un'opinione, e' scritto in
casa: *"La riga `Spread` dell'`.ini` a Modello 4 e' [NON MISURATO]: non
sappiamo se MT5 la onori. Chi volesse aggiungerlo deve prima passare il
CANARINO (stesso EA con spread assurdo -> numeri DIVERSI)"*
(`prove/R118_PAVIMENTO_STOP_CRITERI.md` §4.3, ripetuto in
`REFERTO_R118_PAVIMENTO_STOP.md` §8.2 punto 6).

=> **La PROVA A non parte finche' il CANARINO non ha risposto.**

⚠️ **ERRATA del 12/09, classe 262 — e cambia QUALE prova e' il canarino.**
La prima stesura dava il ruolo a `COLLAUDO_EMADOW_00`, che mette ad asse
**`InpMaxSpread`** (il filtro **interno dell'EA**) e gira **senza `-Spread`**:
sono **due variabili diverse**, e se i suoi numeri non si muovessero la lettura
sarebbe **ambigua** — uno spread costante e' anche la firma di una riga
`Spread=` **onorata**. 👉 **Il canarino e' la prova `01` girata due volte sulla
stessa cella, SOLO gamba OOS: `-Spread 0` contro `-Spread 99999`** (2 celle x 2
corse x 1 gamba = **4 passate**). La `00` resta utile per conto suo — misura la
**manopola `InpMaxSpread`**, cioe' la **riparazione candidata del C3** — ma
**non e' un cancello**.

- **CANARINO PASS** (numeri diversi con `Spread=99999`): la scala A gira a
  Modello 4, ed e' il gradino che decide (R57).
- **CANARINO FAIL** (numeri identici alla cifra): la scala A a Modello 4
  **non esiste**. 🔴 **E si scrive «non misurabile», non «robusta allo
  spread».** Allora, e solo allora, si ripiega su:
  (a) **PROVA B** come stress principale (il costo di spread in piu' e'
      aritmeticamente lo stesso di uno slippage all'ingresso, e si dichiara);
  (b) la scala di spread a **Modello 1/2** come **solo screening**, mai come
      verdetto (regola di casa: OHLC non e' mai un verdetto).

### PROVA B -- SLIPPAGE/LATENZA (post-processing sui per-trade della base)
Scala: **0 / 1 / 2 / 5 punti indice** peggiorati su **ogni ingresso**
(= 0 / 100 / 200 / 500 punti MT5).
Aritmetica: ogni deal di uscita perde `N * volume * 0,861 EUR`; sommato sui
deal di una posizione da' `N * volume_gamba * 0,861` per gamba, perche' la
somma dei volumi chiusi di una posizione e' il volume della gamba.

**[APPROSSIMAZIONE DICHIARATA]**, e va riletta ogni volta che si cita il numero:
1. peggiora **solo il costo d'ingresso**; **non sposta il grilletto** (lo
   slippage vero fa anche non-partire dei trade: `n` resta fisso qui);
2. non modella **requote, rifiuti, riempimento parziale, no-fill del LIMIT**
   (e questa cella entra con **due LIMIT pendenti**: per un LIMIT lo slippage
   sfavorevole all'ingresso e' **strutturalmente meno probabile** che per un
   ordine a mercato -> **questa prova e' PESSIMISTICA per costruzione**);
3. non ricalcola i **lotti** (a stop invariato il lotto non cambia: corretto);
4. il DD si calcola sulla **curva dei chiusi**, che e' un **PAVIMENTO** del DD
   vero: il muro prop guarda il **flottante**, e il flottante resta
   **[NON MISURATO]**.
Questa cella **non** e' un'apertura di sessione (Live5m/Apertura), quindi
prende la scala standard, non quella severa.

### PROVA C -- COMMISSIONI E NOTTE
- **Commissioni della prop: [NON MISURABILE]** oggi. Nessun profilo
  commissioni di una prop e' agli atti in forma di numero utilizzabile; il
  banco gira a **commissione 0**. Si dichiara, non si stima.
- **Swap / rollover: [NON MISURABILE]** da questi CSV. Rilievo che conta per
  questa cella e non per altre: `InpUseCutoff=false` e `InpMaxTradesPerDay=0`
  => il motore **tiene posizioni overnight** e apre anche all'ora 23 (p95
  dello spread **7,0**, massimo misurato **101** punti indice).

---

## 2. LE SOGLIE DI SOPRAVVIVENZA -- congelate ORA, col numero accanto

Metro: i muri di casa (`report/PIANO_PROP.md`): **DD totale 10%**, **muro
giornaliero 5%**. Base OOS a rischio 1%: DD **7,8323%**, peggior giornata
chiusi **-2,448%**, netto **+23.321,47** su 100.000.

| esito | condizione, per ogni gradino della scala |
|---|---|
| **PASS** | a **+50% di spread** (o al gradino **2 punti indice** della PROVA B): netto **> 0** E **PF >= 1,10** E **DD <= 10,0%** a rischio 1% E peggior giornata chiusi **> -3,50%** (margine dichiarato sul muro del 5%: -3,50% a 1% = -2,28% alla taglia di migrazione 0,65%) |
| **FRAGILE** | positivo a **+25%** (o al gradino **1 punto**) ma non a +50% (o a 2 punti). Si scrive quanto margine reale resta e **la decisione passa a Claudio** |
| **BOCCIATO** | il **segno del netto si ribalta gia' a +25%** (o a 1 punto), **oppure** il DD sfonda il 10% **in qualunque gradino**, **oppure** la peggior giornata chiusi sfonda -3,50% in qualunque gradino |

**Soglia di frontiera del costo (C3), congelata a parte:** `stop >= 40 x spread`
alla **mediana** dello spread dell'ora in cui l'operazione vive.
- **PASS C3**: **entrambe** le gambe sopra 40x alla mediana della fascia 14-21.
- **FRAGILE C3**: la gamba 2 fra **30x e 40x** (e' quella col 60% del lotto).
- **BOCCIATO C3**: una gamba sotto **30x** alla mediana della fascia in cui
  cade la maggioranza delle operazioni.

**REGOLA DI CASA CHE NON CAMBIA (R59, Emendamento B):**
**il campione sottile sospende il giudizio sul MERITO, mai sul RISCHIO.**
Un DD accaduto vale a qualunque n. Quindi: se un gradino della scala produce
un DD oltre il muro su 40 operazioni, quel gradino e' **BOCCIATO** anche se n
non arriva a 150.

## 2.1 UNITA' DI CONTO -- dichiarata prima, perche' ribalta due cancelli
In questo collaudo **l'unita' e' la POSIZIONE**, non il deal di uscita
(classe 226; rapporto misurato oggi su 8 per-trade: **2,0117 - 2,3143**,
guidato da `InpTP1Pct`). Motivo: e' l'unita' in cui e' scritto il rischio
(uno stop = una posizione). **Costo dichiarato della scelta**: l'IS della cella
(237 deal) sta **sotto le 150 posizioni**, quindi il MERITO in IS e'
**non leggibile** per l'Emendamento A. Il RISCHIO resta leggibile (regola B).
**La scelta dell'unita' per i cancelli di schieramento resta [FIRMA DI CLAUDIO]**
-- qui vale solo dentro questo collaudo.

---

## 3. COSA QUESTO COLLAUDO NON COPRE (si scrive prima, non dopo)
1. **Requote, rifiuti, no-fill del LIMIT, profondita' del book**: MT5 non li
   modella. Nessun backtest rispondera' mai.
2. **L'esecuzione della prop vera**: sconosciuta. Il demo BCM **non simula lo
   slippage** e `ABTG_SlippageLogger` sul reale ha **0 deal**.
3. **Il flottante**: tutte le peggior-giornata di casa sono sui **chiusi**.
4. **La prova di regime dell'Emendamento C**: lo storico BCM sugli indici
   parte dal **2024.09.26** (sonda 17/08, stato COMPLETO = il broker non ce
   l'ha). Dentro i 21 mesi c'e' **una** discesa vera (2025.02.01-2025.04.30):
   e' una prova di **robustezza**, **non** la prova di regime a quattro
   finestre. Quella, sugli indici, **non e' eseguibile in casa**.
5. **Il tetto per cluster/valuta al 3,0%**: firmato il 07/09, **implementato**
   in `ABTG_Guardian.mq5`, ma **non valorizzato in nessun preset** e **assente
   dalla versione in campo**. Aggiungere l'11a sedia sul Dow oggi vuol dire
   aggiungerla **senza** il tetto firmato apposta per questo. Non e' un buco di
   questo collaudo: e' un buco del campo, e va detto insieme al verdetto.

_12/09/2026 -- collaudatore prop. Nessun EA, preset, magic o sedia viva
toccato. Nessun backtest lanciato da questo file: MT5 gira sul banco 50504400
(`C:\MT5_Backtest`) e i lanci sono di Claudio._
