# 🧪 G1-PAOLO — I TRE VALORI DELLA LIVE DEL 27/08, MESSI SUL BANCO

**Referto di PREPARAZIONE.** Scritto il **28/08/2026**, **prima di qualunque
numero**. Contiene l'ipotesi, il disegno del round e **i criteri di lettura
congelati**. Nessun risultato: il round non è ancora girato (in questo ambiente
non esistono MT5, MetaEditor né Strategy Tester).

> ⛔ **NESSUNA AZIONE SULLA FLOTTA.** Non un parametro, non un magic, non una
> sedia. I magic di questo round sono **vergini (blocco 778xxx)** e quelli delle
> sedie vive sono nella **lista dei vietati** del driver.

| | |
|---|---|
| **Origine** | `risultati_archivio/ANALISI_LIVE_PAOLO_2026-08-27.md` §3, §7, §10 (spunti **P1**, **P2**, **P5**) |
| **File prova** | `prove/G1PAOLO_00_suprev_base.txt` · `_01_suprev_ema50.txt` · `_10_invert_base.txt` · `_11_invert_adx25.txt` · `_12_invert_stochoff.txt` |
| **Driver** | `righe/RIGA_G1PAOLO.ps1` (marcatore `MARCATORE_RIGA_G1PAOLO_v1`) |
| **Riga da mandare** | `righe/RIGA_G1PAOLO_DA_MANDARE.md` |

---

## 1. 🔴 LA CORREZIONE CHE CAMBIA IL DISEGNO DEL ROUND

Il mandato chiedeva **4 celle su un EA solo**: baseline + `InpAdxMin=25` +
`InpEma2=50` + `InpUseStoch=false`. **Non si può fare, e il motivo è nel
sorgente.** Verificato per grep il 28/08, file per file:

| input | dove vive DAVVERO |
|---|---|
| **`InpEma2`** | **solo** famiglia **SupRev** — `ABTG_SupertrendReversal.mq5` (riga 64) e tutti i derivati (`_Ottimizzato`, `_Multi`, `_Multi_Ottimizzato`, `SupRev_DAX_H1/H4`, `DOW_H1/H4`, `NAS_H1`, `CAC_H4`) |
| **`InpAdxMin`** | **solo** `ABTG_SupertrendInvert.mq5` (riga 65) |
| **`InpUseStoch`** | **solo** `ABTG_SupertrendInvert.mq5` (riga 69) |

Il conteggio secco, per non doverlo rifare a memoria:

```
ABTG_SupertrendReversal.mq5                    adx=0  ema2=2  stoch=0
ABTG_SupertrendReversal_Ottimizzato.mq5        adx=0  ema2=2  stoch=0
ABTG_SupertrendReversal_Multi.mq5              adx=0  ema2=2  stoch=0
ABTG_SupertrendReversal_Multi_Ottimizzato.mq5  adx=0  ema2=2  stoch=0
ABTG_SupRev_DAX_H4_Ottimizzato.mq5             adx=0  ema2=2  stoch=0
ABTG_SupRev_DAX_H1_Ottimizzato.mq5             adx=0  ema2=2  stoch=0
ABTG_SupRev_DOW_H4_Ottimizzato.mq5             adx=0  ema2=2  stoch=0
ABTG_SupRev_DOW_H1_Ottimizzato.mq5             adx=0  ema2=2  stoch=0
ABTG_SupRev_NAS_H1_Ottimizzato.mq5             adx=0  ema2=2  stoch=0
ABTG_SupRev_CAC_H4_Ottimizzato.mq5             adx=0  ema2=2  stoch=0
ABTG_SupertrendInvert.mq5                      adx=2  ema2=0  stoch=4
```

🔎 **La famiglia SupRev non ha né un filtro ADX né un filtro stocastico**: non
sono spenti, **non esistono**. E l'Invert non ha `InpEma2`: usa
`InpEma50Period`/`InpEma200Period`, che sono un'altra cosa (il filtro STRONG).

**Conseguenza:** l'ablazione si spezza su **due motori con due baseline**, per
un totale di **5 celle**. È la stessa filosofia a stella — un interruttore per
volta contro la propria baseline — solo che le stelle sono due.

> 🚫 **E soprattutto: NON è stato aggiunto nessun input a nessun EA.** Aggiungere
> un `InpAdxMin` alla famiglia SupRev per far tornare il disegno del round
> avrebbe voluto dire modificare **quattro EA con una sedia viva** per comodità
> di chi scrive il round. Non è stato fatto, e non va fatto senza che Claudio lo
> chieda esplicitamente.

---

## 2. 🎯 LE CINQUE CELLE

### ⭐ Stella A — motore **SupRev**, `ABTG_SupertrendReversal` su **XAUUSD H4**

| cella | file prova | delta contro la baseline | magic gemelli |
|---|---|---|---|
| **00_suprev_base** | `G1PAOLO_00_suprev_base.txt` | — (baseline: `InpEma2=89`) | 778000 / 778001 |
| **01_suprev_ema50** | `G1PAOLO_01_suprev_ema50.txt` | **`InpEma2` 89 → 50** | 778100 / 778101 |

### ⭐ Stella B — motore **Invert**, `ABTG_SupertrendInvert` su **XAUUSD H1**

| cella | file prova | delta contro la baseline | magic gemelli |
|---|---|---|---|
| **10_invert_base** | `G1PAOLO_10_invert_base.txt` | — (baseline: ADX 20, Stoch ON) | 778300 / 778301 |
| **11_invert_adx25** | `G1PAOLO_11_invert_adx25.txt` | **`InpAdxMin` 20 → 25** | 778400 / 778401 |
| **12_invert_stochoff** | `G1PAOLO_12_invert_stochoff.txt` | **`InpUseStoch` true → false** | 778500 / 778501 |

Ogni cella differisce dalla **sua** baseline di **due righe sole** (il delta + il
magic), e **il driver lo verifica prima di aprire MT5**. I **dieci magic sono
vergini**: blocco `778xxx`, cercati uno per uno in tutto il repo il 28/08 →
**zero occorrenze**.

### 🥇 Perché ORO come banco di prova

`CLASSIFICHE.md` §"SQUADRA FORWARD": **SupRev · Oro XAUUSD H4 · PF reale 1,46 ·
DD 1,2% · magic 770921** è la sedia SupRev più forte a tick reali, e in
`FLOTTA_ATTIVA.md` l'oro H4 gira col **SupertrendReversal nativo** (grafico
`XAUUSDH43`), cioè **proprio l'EA dove vive `InpEma2`**. Un valore che migliora
un motore già forte è una notizia; un valore che lo peggiora è una notizia più
grossa ancora. E l'Invert ha anch'esso un grafico su oro (`XAUUSDH14`, H1),
sullo stesso simbolo: **i due banchi restano confrontabili fra loro.**

---

## 3. 🏛️ IL BANCO — due, e sono dichiarati

Non è un vezzo: è la **tensione strutturale del progetto**, già battezzata in
R76 — _"o la finestra lunga o il riempimento vero, mai tutti e due"_.

| banco | modello | finestra | cosa dà | cosa NON dà |
|---|---|---|---|---|
| **S** (screening) | **1 — OHLC M1** | **2020.01.01 → 2026.06.30** | il **CAMPIONE** (misura agli atti su questo banco: **n≈208**, R103/R114) e **quattro regimi** (crollo 2020, toro 2020-21, orso 2022, toro 2023-26) | un verdetto. Il driver generico lo scrive alla riga 65: _"1 = OHLC M1: SOLO screening, mai verdetti"_. L'illusione OHLC ha già revocato una promozione in casa (SupRev DOW H4) |
| **V** (verdetto) | **4 — TICK REALI** | **2024.07.05 → 2026.06.30** | il **riempimento vero** (spread, slippage, fill) | il campione: su oro H4 la misura agli atti è **n=44** contro i **150** dell'Emendamento regola A. E copre **un solo regime** |

**Split IS/OOS 40/60** in tutti e due i banchi (default del driver generico).
Quindi **quattro sotto-finestre per cella**: `S-IS`, `S-OOS`, `V-IS`, `V-OOS`.

### ⚠️ Il caveat da leggere prima dei numeri del banco V

**La profondità TICK di XAUUSD NON È MAI STATA MISURATA.** `R86_CRITERI.md`
§2.0 e `R87_CRITERI.md` §2.0 lo dicono per esteso: l'unica riga `TICK` mai
prodotta nel repo è quella di **GBPUSD** (probe del 15/08, `2024.07.05`). Il
`2024.07.05` di questo round è quella data **estesa per analogia**:
**[INFERITO, NON MISURATO]**.

➡️ Per questo la riga di lancio ha un **PASSO 0 opzionale ma raccomandato** che
misura la profondità tick dell'oro *prima* di girare. Se i tick partissero
**dopo** quella data, **i numeri del banco V non si leggono** e la finestra si
riscrive (è il **difetto n.18** della checklist di casa).

---

## 4. ❓ L'IPOTESI, E COSA MUOVE OGNI INTERRUTTORE — letto nel sorgente

### 4.1 `InpEma2` 89 → 50 — **direzione NON prevedibile, e va detto adesso**

`ABTG_SupertrendReversal.mq5`, righe 239-246:

```
bool ConfluenceOK(double level,double atr){
   int hs[4]={hE1,hE2,hE3,hE4};
   for(i=0..3) if(MathAbs(level-EMA_i) <= InpConflAtr*atr) return(true);
   return(false); }
```

È un **OR su quattro medie**. Portare la 89 a 50 **non allarga e non stringe**:
**sposta una delle quattro finestre**. Con 14/89/100/200 due bande su quattro
(89 e 100) sono quasi sovrapposte su oro H4; con 14/50/100/200 le quattro sono
distribuite — ed è il set che il docente dichiara di usare oggi.

> 🔴 **Chi scriverà "me lo aspettavo" dopo aver visto il segno si sta
> raccontando una storia.** La direzione dell'effetto sul numero di operazioni
> **non è deducibile a tavolino**: è scritto qui, con la data, apposta.

⚠️ Vale **solo** se `InpUseConfluence=true` (lo è). Se qualcuno lo spegnesse,
`InpEma2` diventerebbe **inerte** e la cella non misurerebbe niente. Per questo
la riga è scritta esplicita nei file prova ed è controllata dal gate **come
valore assoluto**, non solo per differenza.

### 4.2 `InpAdxMin` 20 → 25 — **meno operazioni, per costruzione**

`ABTG_SupertrendInvert.mq5` righe 227-234: `AdxOK()` legge il buffer allo
**shift 1** e fa `if(a[0] < InpAdxMin) return(false)` più `InpAdxRising`. Il
cancello si stringe e basta: **non esiste un ramo che aggiunga ingressi**.

📌 Nota tecnica che il docente stesso ha dettato (r.145): _"la DX parte sempre
con una candela di ritardo"_. Il nostro filtro legge **su barra chiusa**: quel
ritardo **c'è ed è dichiarato**, non è un difetto.

🟡 E va detto che questo **non è una seconda strada indipendente**: il commento
del nostro sorgente diceva **già** `// ideale >=25`. Il docente **conferma una
nota che era già in casa** — stessa fonte, due voci.

### 4.3 `InpUseStoch` true → false — **più operazioni, per costruzione**

Si toglie un anello da una catena di cinque cancelli in AND (righe 206-211):

```
if(InpRequireStrong      && !IsStrong(...))     return;
if(InpUseADX             && !AdxOK())           return;   <- cella 11
if(InpUseStoch           && !StochOK(isLong))   return;   <- cella 12
if(InpUseStochH4         && !StochH4OK(...))    return;   (off di default)
if(InpUseExtensionFilter && !ExtensionOK(...))  return;
```

> 🔴 **E la trappola, dichiarata adesso: "più operazioni" NON è un
> miglioramento.** Un motore che passa da 2 a 200 trade e perde è **peggio** di
> uno che non opera, perché perde soldi veri. Il conteggio **apre la porta** alla
> lettura del merito, non la sostituisce.

---

## 5. 🧭 I CRITERI DI LETTURA — congelati PRIMA dei numeri

### 5.0 Il numero che si guarda per primo: **n**, non il PF

Vale **soprattutto per la stella B**. Lo stato misurato dell'Invert è
`REFERTO_CODA_FASCIA_B.md` riga 31: _"1/8 — **non opera**. Su USDJPY, unico
promosso: **0 trade su 10 TF su 11**"_ + bocciato su oro H1
(`report/PULIZIA_VPS_10-08.md`).

- **`n(10_invert_base) = 0`** → il PF non esiste. Le celle 11 e 12 diventano un
  **conta-operazioni**, e va scritto così. **`n=0` contro `n=0` non è
  un'ablazione**: è una cella muta.
- **`n < 20`** in una sotto-finestra → quella riga **non giudica il merito**
  (cancello storico di casa: minimo 30 trade OOS; sotto 20 non si legge nulla).

### 5.1 La regola di concordanza — **4 sotto-finestre, un solo segno**

Per ogni cella di ablazione si guarda il **delta contro la propria baseline** su
`S-IS`, `S-OOS`, `V-IS`, `V-OOS`.

| concordanza del segno | esito congelato |
|---|---|
| **4/4** nella stessa direzione | 🟢 **A — effetto MISURATO.** Solo qui si può scrivere una **proposta** per Claudio (che resta **sua** la decisione) |
| **3/4** | 🟡 **B — indizio, NON proposta.** Si dichiara il segno e la finestra discorde, e si ferma lì |
| **2/4 o meno** | ⚪ **C — nessun effetto leggibile.** Il valore del docente **non si adotta**: non perché sia sbagliato, ma perché **su questo banco non si vede** |
| **segno opposto fra banco S e banco V** | 🔴 **D — CONFLITTO DICHIARATO, e non si risolve.** È già successo (R73 tick contro R78 OHLC): due domande diverse, non un errore. **Nessuna proposta**, e il conflitto va agli atti |

### 5.2 E il **RISCHIO** si legge sempre, anche quando il merito è sospeso

Emendamento regola **B**: _"non si boccia un motore perché non guadagnava nel
2012; SÌ si boccia se nel 2020 avrebbe fatto un drawdown del 25%"_.
➡️ La colonna **DD** delle celle si legge e si scrive **in tutti i casi**, anche
con `n` sotto soglia. Un drawdown è **un fatto accaduto**, non una stima.

### 5.3 Cosa questo round **non potrà dire**, scritto prima

1. ❌ **Non promuove e non boccia nessuna sedia.** Cinque celle non sono un
   round di merito, e nessuna cella è la configurazione viva.
2. ❌ **Non dice niente sugli altri simboli.** Un delta misurato su oro **non si
   estende** a Argento/DAX/Nikkei/Nasdaq. Se `InpEma2=50` vincesse sull'oro, la
   domanda per le altre quattro sedie SupRev **resta aperta**, e si misura.
3. ❌ **Non valida la strategia del docente.** Misura **tre numeri**, non un
   metodo. La stessa fonte in 48 ore ha spostato i confini della "golden area" e
   ha portato il 78,6 da invalidazione a ingresso (referto 28/08 §2).
4. ❌ **Non sostituisce il forward.** Un backtest profittevole non è un profitto
   live.

---

## 6. 🧾 L'IGIENE DEL BANCO

- **Gemelli**: l'unico asse spazzolato è `InpMagic`, con due valori. Le due
  righe del CSV devono uscire **identiche al centesimo**. Se non lo sono, il
  banco non è deterministico e **il numero non si legge**.
- **Un solo asse `Y`** per file prova, e deve essere `InpMagic`: il driver si
  ferma se ne trova un secondo (senza almeno un asse spazzolato il driver
  generico si rifiuta di partire; e un pin scritto `Nome=v` secco **non spegne**
  il flag di ottimizzazione che MT5 ricorda — per questo tutti i pin sono in
  forma completa `v||v||0||v||N`).
- **Gate della baseline per valore assoluto**, non solo per differenza: una riga
  storta **uguale in tutte le celle** passerebbe il diff (lezione R110).
- **`AllowLiveTrading=false`** negli `.ini`: lo scrive il driver generico. Sul PC
  di backtest il terminale è collegato al **conto vivo** — il 14/08 un backtest
  ha piazzato un ordine vero.
- **Include**: tutti e due gli EA fanno `#include <ABTG_PausaGuardian.mqh>` e
  `walkforward_generico.ps1` **non lo installa**. Lo installa la riga di lancio.
  (Nel tester il Guardian è **fail-open totale**: le sue GlobalVariable non
  esistono, quindi non altera nulla e i numeri restano confrontabili.)

---

## 7. 📋 COSA RESTA APERTO — le domande, non le assunzioni

| # | domanda | perché non l'ho decisa io |
|---|---|---|
| **Q1** | La profondità **TICK di XAUUSD** | mai misurata in tutto il repo. Il `2024.07.05` è **[INFERITO da GBPUSD]**. Il PASSO 0 della riga la misura |
| **Q2** | Vuoi che la stella A giri **anche** su `ABTG_SupertrendReversal_Ottimizzato` (magic vivo 970901, stesso oro H4)? | sono **due sedie diverse sullo stesso simbolo**, con parametri diversi. Misurarle insieme raddoppia il costo; misurarne una sola lascia l'altra scoperta. **Decisione tua** |
| **Q3** | Se `InpEma2=50` risultasse migliore, lo si prova **anche** sulle altre 4 sedie SupRev (Argento/DAX/Nikkei/Nasdaq)? | è un round nuovo, non un corollario. Un delta su oro **non si estende** |
| **Q4** | La `@DAQUANDO 2020.01.01` del banco S è una scelta, non una misura | XAUUSD ha barre dal **2004.06.11** (sonda 17/08, misurata). Il 2020 è la finestra dell'antenato R103/R114, scelta **per confrontabilità**. Volendo si può allargare a 2010 o 2004 — ma allora il confronto con l'antenato salta, e va detto |

---

_Preparazione fatta leggendo **il sorgente**, non la memoria: ogni riga citata ha
il numero di riga. Nessun EA è stato modificato, nessun input è stato aggiunto,
nessuna sedia viva è stata toccata. **I numeri li può dare solo la corsa.**_
