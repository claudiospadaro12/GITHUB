# CRITERI CONGELATI — LE QUATTRO MANOPOLE DI `770101` (12/09/2026, sera)

**Cella in esame**: `ABTG_DAX_Apertura_EU` · `D30EUR` · `M5` · **LONG only** ·
magic **770101** in campo sul terminale **`50504263`** (`... MT5 Terminal -V3`,
profilo `SQUADRA 100K`) · `InpEntryMode=2` (RETEST, BUY LIMIT) ·
`InpRangeMinutes=35` · `InpSessionHour=8` (**ORA SERVER**) · `InpCloseHour=17:30` ·
`InpBufferPoints=500` · `InpSLMode=0` (stop sul bordo opposto del range) ·
`InpTP1_R=1.5` · `InpRiskPercent=0.65` in campo.

**Referti da cui arriva**:
- `report/PANNELLO_770101_IN_CAMPO_2026-09-12.md` (+ ERRATA in fondo)
- `report/VERBALE_CHIUSURA_770101_2026-09-02.md` (C1-C4)
- `report/INDURIMENTO_PROP_DUE_SEDIE_2026-09-12.md` (collaudo prop, tick-free)
- `backtest_pipeline/prove/COLLAUDO_DAX101_CRITERI.md` (criteri del collaudo A/B/C)

**Banco dati** (letto, non assunto):
- `backtest_pipeline/risultati_prove/aperture_r47/abtg_trades_..._772501.csv`
  = cella **VIVA** (`InpTP1_ClosePct=50`), **270 deal / 193 posizioni**
- `..._772503.csv` = cella **REGALO** (`=0`), **193 deal / 193 posizioni**
- 🔴 separatore **PUNTO E VIRGOLA**, intestazione
  `close_time;symbol;magic;position_id;deal_type;volume;price;net_profit`
- `data/spread_vivo/SPREAD_VIVO_2026-09-12_referto.txt` = spread **VIVO**
  (650.484 campioni a passo **5 s**, 04/09-11/09, ora SERVER)
- `backtest_pipeline/risultati_archivio/spread_flotta/spread_orario_D30EUR.csv`
  = spread **A TICK** dello storico BCM (**30.974.789 tick**), che e' il feed
  su cui il backtest delle 193 posizioni ha davvero girato
- `data/statements/trades_auto.csv` = il campo (demo `50503392`)

🛑 **Questo file NON esegue niente.** Nessun EA, preset, magic, parametro di
forward, riga di coda (`backtest_pipeline/coda/CODA.txt` **mai aperta in
scrittura**). Taglie, rischio e protezioni sono **firma di Claudio**.
🚦 Il **secondo strato** del cancello (agente `controllo-preventivo`) **lo lancia
il coordinatore**: lo dichiaro e non lo do per fatto.

---

## REGOLA ZERO — CHE COSA VALE COME MISURA, DICHIARATO ADESSO

| rango | che cos'e' | cosa puo' fare |
|---|---|---|
| **M** MISURATO | letto da un CSV di risultati, da un per-trade, o da un istogramma di tick/campioni | puo' **promuovere** e puo' **bocciare** |
| **D** DERIVATO | ricostruito da una formula del sorgente su grandezze misurate | puo' **bocciare**, **non** puo' promuovere da solo |
| **C** VERO PER COSTRUZIONE | il numero che esce **non puo' che uscire cosi'** dato come e' fatto il dato | 🔴 **non vale niente**, e va dichiarato tale |
| **N** NON MISURATO | i dati in casa non lo contengono | si scrive `[NON MISURATO]` + la **via piu' corta al numero** col costo in passate |

🔴 **La trappola del giorno, scritta prima**: oggi un Δ PF costante al quarto
decimale si e' rivelato un'**identita' algebrica**, e un conteggio "0 su 193" di
un tetto multi-EA sarebbe **vero per costruzione** (nel tester gira UN solo EA).
**Ogni numero che torna troppo bene va classificato in questa tabella prima di
essere citato.**

🧊 **E la valvola di casa non si tocca**: *il campione sottile sospende il
giudizio sul MERITO, mai sul RISCHIO*. Un DD accaduto vale a qualunque `n`.

📏 **E il metro che sta sopra tutto** (`CLAUDE.md`, 08/09): **la frequenza e' il
requisito principale.** Una protezione che costa operazioni costa una sedia.

---

## M1 — `InpMaxSpread` (oggi **0** = nessun limite)

**Che cosa fa, da sorgente** (verificato riga per riga):
`SpreadOK()` = `ABTG_DAX_Apertura_EU.mq5` **r.2133-2139** — legge
`SymbolInfoInteger(_Symbol, SYMBOL_SPREAD)` (**punti MT5**, su `D30EUR`
**1 punto indice = 100 punti MT5**) e confronta con `InpMaxSpread`.
In modalita' RETEST la chiamata e' **UNA SOLA**, a **r.1441 dentro
`ArmRetest()`**, cioe' **a fine range (08:35 server), una volta al giorno**.

### Le soglie, congelate

| esito | condizione |
|---|---|
| ✅ **FIRMABILE al valore V** | il tetto V **costa ≤ 2,0% delle 193 posizioni** (≤ 4 posizioni) **E** e' dimostrato che ha morso almeno una volta nel campione |
| ⚪ **INERTE — si dichiara inerte, NON si firma come protezione** | il tetto V non taglia **nessun** campione nella finestra misurata. Si puo' proporre come **assicurazione a costo misurato zero**, ma **e' vietato chiamarla protezione misurata** |
| 🟠 **FRAGILE** | costa fra il 2,0% e il 10,0% delle posizioni |
| 🔴 **BOCCIATO** | costa **> 10,0%** delle posizioni (la frequenza e' il requisito principale) **oppure** il PF sale **solo** perche' `n` scende (test S/P qui sotto) |

### 🔴 IL TEST «SELEZIONE o PROTEZIONE» (S/P) — obbligatorio, deciso adesso
Un tetto che alza il PF tagliando operazioni **non e' una protezione: e' una
selezione**. La distinzione si fa con **un numero**:
- si calcola il **PF del sottoinsieme TAGLIATO** e il **PF del sottoinsieme
  TENUTO**;
- ✅ **PROTEZIONE** se il PF del tagliato e' **< 1,00** e il tagliato porta una
  quota di perdita **maggiore** della sua quota di operazioni;
- 🔴 **SELEZIONE** se il PF del tagliato e' **≈ il PF globale** (banda
  **±0,10**): allora il tetto sta togliendo operazioni **a caso**, e il PF che
  sale e' un artefatto del denominatore.

### 🔴 IL CONTRO-ESEMPIO OBBLIGATORIO (lo costruisco io)
L'ipotesi comoda da rompere e': *«su `D30EUR` nelle ore cash lo spread non ha
coda (max = P95 = 1,700), quindi qualunque tetto sopra 1,70 e' inerte e gratis»*.
La **ipotesi alternativa** che va misurata e' esattamente l'opposta: *«quel
"niente coda" e' un artefatto del campionamento a 5 secondi su 5 giornate, e il
feed a tick su cui il backtest ha girato ha una coda»*.
👉 **Se le due fonti danno numeri che differiscono di un fattore ≥ 3, la
conclusione "inerte" e' NULLA**, e l'esito e' `[NON MISURATO]` con la via al
numero. Le due fonti sono dichiarate: il **vivo a 5 s** e il **tick storico**.

### Scala dei tetti da provare (in punti indice e in punti MT5)
**1,70 / 2,00 / 2,70 / 3,40 idx** = **170 / 200 / 270 / 340 punti MT5**.

---

## M2 — `InpMaxPosSimbolo` (A1, oggi **0** = spento)

**Che cosa fa, da sorgente**: dichiarato a **r.258**; il cancello e' a
**r.694-701**, dentro `case PH_BUILDING` dello `switch(gPhase)`;
`EsposizioneSimbolo()` e' a **r.923-937** e conta **posizioni + pendenti** sul
simbolo **ignorando il magic** (tutti gli EA). Se scatta: `gPhase = PH_DONE`,
cioe' **la giornata e' persa**, non solo l'ordine.

### Le soglie, congelate

| esito | condizione |
|---|---|
| ✅ **FIRMABILE al valore V** | **(a)** e' dimostrato **da codice** che con V la sedia **non puo' auto-bloccarsi** (il suo pendente non esiste ancora quando il cancello gira) **E (b)** il numero di giornate che V avrebbe bruciato su **dati veri di campo** (non del tester) e' **0** |
| 🟠 **FRAGILE** | (a) vale, (b) non e' misurabile: si firma V **solo** dopo la lettura della lista Expert del terminale bersaglio |
| 🔴 **BOCCIATO al valore V** | esiste **anche un solo** caso misurato in cui un altro EA teneva posizione o pendente su `D30EUR` nella finestra **08:00-08:35 server**: allora V=1 costa **giornate intere** |

### 🔴 IL CONTRO-ESEMPIO OBBLIGATORIO
Due trappole, e le dichiaro entrambe prima di contare:
1. **"0 volte su 193 posizioni" e' rango C, VERO PER COSTRUZIONE**: nel tester
   gira **un solo EA**, quindi `EsposizioneSimbolo()` dal punto di vista degli
   *altri* EA vale **sempre 0**. Quel numero **non e' una prova di sicurezza**.
   La misura buona sta nel **campo** (`trades_auto.csv`: magic diversi sullo
   stesso simbolo, sovrapposti in orario).
2. 🔴 **La frase del verbale del 02/09 va provata, non ripetuta**: *«e' la
   protezione che avrebbe impedito le due SELL gemelle dello stesso secondo»*.
   Va verificato **contro il commento dell'EA stesso** (r.918-921). Se il
   cancello gira **prima** che uno dei due piazzi, **due EA nello stesso tick
   non si vedono** e A1 **non** avrebbe impedito niente. Se e' cosi', **si
   scrive che il verbale sovrastima la protezione**.

---

## M3 — `InpMinStopPts` (floor, oggi **0** = inerte) e `InpSlippagePts` (oggi **0**)

**Che cosa fanno, da sorgente**: `InpSlippagePts` r.344, `InpMinStopPts` r.345,
`InpSkipIfTight` r.346 (**oggi `true`**, confermato dal CSV di R47).
Nel ramo RETEST che e' quello vivo: **r.1493-1497** (BUY) e **r.1526-1530**
(SELL). Con `InpSkipIfTight=true` il trade si **SALTA**; con `false` lo stop
si **allarga** a `InpMinStopPts` e il **lotto scende** (r.1497).
🔴 `InpSlippagePts` **non tocca il RETEST**: peggiora l'entry solo nei rami
BREAKOUT (r.1059) e DELAYED. Va verificato e dichiarato.

### Le soglie, congelate

| esito | condizione |
|---|---|
| ✅ **FIRMABILE al valore F** | F taglia **≤ 5,0% delle 193 posizioni** (≤ 9) **E** passa il test **S/P** di M1 come **PROTEZIONE** **E** F copre almeno il **pavimento duro 13,3x** allo spread base misurato |
| 🟠 **FRAGILE** | taglia fra il 5,0% e il 10,0% |
| 🔴 **BOCCIATO al valore F** | taglia **> 10,0%** delle posizioni, **oppure** il tagliato ha un PF **≥ 1,00** (si stanno buttando via trade buoni) |

### Il legame col **19,7%** del collaudo prop, dichiarato adesso
A spread **+100%** il **19,7%** delle 193 posizioni sta sotto il pavimento duro
**13,3x**. Il floor che chiude *quel* buco e' `F ≥ 13,3 × spread(+100%)`.
👉 Il conto va fatto e va detto **quanto costa in operazioni**: se per coprire il
19,7% bisogna tagliarne il 19,7%, **il floor non e' una difesa, e' la stessa
perdita pagata in anticipo** — e va scritto con queste parole.

### 🔴 IL CONTRO-ESEMPIO OBBLIGATORIO
1. **Il post-processing del floor e' di PRIMO ORDINE e lo dichiaro**: saltare
   una posizione cambia il **saldo**, quindi cambia il **lotto** di tutte le
   successive (`CalcLotByRisk` usa `ACCOUNT_BALANCE`, r.1793). La quota tagliata
   e il PF del tagliato sono **robusti**; il "profitto che si perde" e' una
   **stima di primo ordine**, mai un risultato.
2. **Lo stop non e' misurato, e' DERIVATO** (rango **D**): si ricava
   invertendo `CalcLotByRisk`, e l'arrotondamento `MathFloor` sul `lotStep`
   (r.1824) lascia un **intervallo**, non un punto. Si riporta l'intervallo.
   La derivazione si valida contro uno stop **scritto da qualcun altro**
   (`report/CANCELLO_COSTO_FLOTTA_2026-09-10.md`: mediana **71,9 idx**, n=7)
   e contro la mediana **77,8 idx** pubblicata nell'indurimento.

---

## M4 — `InpTP1_ClosePct` **50 → 0** (il regalo non incassato)

### Le soglie, congelate

| esito | condizione |
|---|---|
| ✅ **RACCOMANDATO** | allo **spread VERO misurato** il regalo batte la viva su **profitto E PF E DD di equity E peggior giornata di equity**, e l'**allungamento dell'esposizione** misurato **non** peggiora la peggior giornata oltre il muro giornaliero |
| 🟠 **RACCOMANDATO CON RISERVA** | vince su tutto tranne l'esposizione, e l'esposizione in piu' e' quantificata |
| 🔴 **CADE** | si inverte su **un solo** indicatore, **oppure** l'allungamento porta la peggior giornata oltre **−2,50%** |

### 🔴 IL CONTRO-ESEMPIO OBBLIGATORIO, e qui e' il cuore
🔴 **Il Δ PF costante al quarto decimale (+0,0941 su tutti e quattro i gradini)
NON e' una prova di robustezza: e' un'IDENTITA' ALGEBRICA**, perche' le due
celle hanno le **STESSE 193 posizioni** e il pedaggio incrementale e' una
funzione quasi-identica del volume. **Non lo cito come argomento.**
Restano **due** argomenti che NON sono identita', e vanno misurati:
1. **il segno del pedaggio**: il regalo paga **piu'** pedaggio (volume +2,9%) e
   vince **lo stesso** → il vantaggio non e' un risparmio di costo. Questo e'
   un fatto sui **volumi misurati**, non un'identita';
2. **l'esposizione**: a `ClosePct=0` la posizione resta **intera** piu' a lungo.
   👉 **Domanda che decide**: **di quanti minuti** si allunga la permanenza, e
   **cosa fa al muro giornaliero del 4,9%**? Si misura confrontando il
   `close_time` **dell'ultimo deal** posizione per posizione, sulle stesse 193.

---

## E LA VIA PIU' CORTA AL NUMERO, quando il numero non c'e'

Metro di casa: **T = 0,6 + 0,077 × passate**, **per ROUND**.
Ogni misura dichiarata `[NON MISURATO]` deve portare in fondo al referto la sua
riga: *quale file prova, quante celle, quante passate, quanti minuti* — e, se il
tester potrebbe non onorare il meccanismo, **un canarino che uccide la prova**
prima che produca un numero falso.

🔴 **Congelato il 12/09/2026, sera, PRIMA dei numeri delle quattro manopole.**
