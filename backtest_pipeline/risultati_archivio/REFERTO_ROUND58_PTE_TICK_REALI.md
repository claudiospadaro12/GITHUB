# 🎯 REFERTO R58 — PTE GBPUSD sui TICK REALI DI BCM

_15-16/08/2026. **Modello 4 = tick reali del nostro broker**, 70.491.074 tick
scaricati. Simbolo `GBPUSD`, periodo `H1`, storico che parte dal **2024.07.05
misurato** (non ipotizzato). 2 lanci, 32 righe di risultato, igiene 32/32._

**La domanda del round:** _dopo R57 — dove cambiare solo il modello aveva
ribaltato il segno dell'orso — quale dei due numeri e' quello vero **sul
broker su cui giriamo i soldi**?_

---

## 1. ✅ COSA HA GIRATO DAVVERO — l'evidenza, non il ricordo

Il file `gen_ABTG_PTE_GBPUSD_*_r58.ini` (archiviato qui accanto) e' cio' che
MT5 ha ricevuto. Riga per riga:

```
Expert=ABTG_PTE.ex5
Symbol=GBPUSD          <- il MIO file (quello vecchio dice XAUUSD)
Period=H1
Model=4                <- TICK REALI
Deposit=100000  Currency=EUR  Leverage=100

IS    FromDate=2024.07.05   ToDate=2025.04.21
OOS   FromDate=2025.04.22   ToDate=2026.06.30
```

**[VERIFICATO]** modello, simbolo, periodo e le due finestre. I CSV **non**
portano il suffisso `_ohlc`: un OHLC non puo' aver sovrascritto un tick reale.

### ⚠️ E cosa NON torna — dichiarato, non spiegato

Le stesse `.ini` contengono anche queste due righe:

```
InpTP1_ATRmult=0||0||0.5||1.5||Y      <- GRIGLIA (vecchia)
InpTF=16388||16385||1||16388||Y       <- GRIGLIA (vecchia)
```

Il mio file `ABTG_PTE_R58.txt` chiedeva **una cella sola**, con i flag `N`.

> 🔴 **[INCERTO] Non so spiegare perche': le direttive `@` del mio file sono
> passate (simbolo, periodo, data), le righe di parametro no. Non lo invento —
> resta aperto.**

**Cosa cambia per i numeri: niente in peggio.** Il tester ha misurato **16
celle invece di 1**, tutte a tick reali sulle finestre giuste. La cella viva
c'e' dentro, ed e' misurata esattamente come doveva. Le altre 15 sono
informazione in piu' — e la useremo al punto 3, che e' la parte piu'
importante del referto.

---

## 2. 🟢 LA CELLA VIVA — `InpTF=16385` (H1) · `InpTP1_ATRmult=0,5`

**Congelata PRIMA**, in `backtest_pipeline/prove/CELLE_REGIME.txt`, copiata
dal deploy in forward. Non e' stata scelta guardando questa tabella.

| | IS (2024.07.05 → 2025.04.21) | OOS (2025.04.22 → 2026.06.30) |
|---|---:|---:|
| **Profitto** | **+4.745,22** | **+2.091,17** |
| **Profit Factor** | 4,92 | **1,378** |
| **Equity DD** | 2,04% | **3,27%** |
| **operazioni** | 25 | **49** |
| Expected payoff | 189,81 | 42,68 |
| Recovery factor | 2,32 | 0,63 |
| Sharpe | 12,93 | 4,27 |
| **peggior giornata** | −1,71% | **−1,0244%** |
| serie perdente peggiore | −1.057,33 | −2.055,77 |

### Il cancello di sempre — quello di R48, R36, R29 — quattro voci

| criterio congelato | valore | esito |
|---|---:|---|
| profitto OOS **> 0** | +2.091,17 | ✅ |
| **PF OOS ≥ 1,10** | **1,378** | ✅ |
| **DD OOS < 10%** | **3,27%** | ✅ |
| **n ≥ 20** in entrambe le finestre | 25 e 49 | ✅ |

> ✅ **Quattro su quattro, a tick reali del nostro broker.** E l'IS e'
> positivo: non e' una cella che vive solo fuori campione.

E la peggior giornata OOS a **−1,02%** e' il numero che interessa al metro
prop: a **0,65%** di rischio quella giornata vale ~**0,67%** del conto,
lontanissima dal 5% giornaliero.

---

## 3. 🔴 IL NUMERO PIU' IMPORTANTE DEL ROUND: **Spearman = −0,60**

Le quattro celle H1 (`InpTF=16385`), l'unica riga che sopravvive fuori
campione:

| `InpTP1_ATRmult` | IS | OOS | PF OOS | DD OOS | n OOS |
|---|---:|---:|---:|---:|---:|
| 0,0 | +6.716 | **+3.166** | 1,46 | 3,05% | 55 |
| **0,5** ← _la cella viva_ | +4.745 | **+2.091** | 1,38 | 3,27% | 49 |
| 1,0 | +7.545 | +159 | 1,02 | 4,54% | 44 |
| 1,5 | **+10.065** | +1.134 | 1,10 | 4,22% | 42 |

| | rango IS | rango OOS |
|---|---:|---:|
| 1,5 | **1°** (la migliore in campione) | **3°** |
| 1,0 | 2° | **4°** (ultima) |
| 0,0 | 3° | **1°** |
| 0,5 | **4°** (la peggiore in campione) | **2°** |

> 🚨 **Spearman IS→OOS = −0,60.** La **migliore in campione** (TP1 1,5, +10.065)
> arriva **terza** fuori. La **peggiore in campione** (TP1 0,5, +4.745) arriva
> **seconda** — ed e' quella che gira in forward.

**Anche coi tick veri del nostro broker, su 24 mesi, scegliere la cella
migliore in campione resta controproducente. Dodicesima misura negativa su
tredici — e la prima fatta sui tick reali.**

Non e' piu' un artefatto dei dati sintetici o della finestra corta: e' il
comportamento del nostro feed, sul nostro simbolo, sul nostro periodo.
La regola "mai la cella migliore, sempre il centro dell'altopiano" ha appena
avuto la sua conferma piu' pulita.

### E l'altopiano c'e', ed e' l'intera riga H1

**Tutte e quattro** le celle H1 sono positive fuori campione. **Tutte e
dodici** le celle H2, H3 e H4 sono negative:

| timeframe | celle OOS positive |
|---|---|
| **H1 (16385)** | **4 su 4** ✅ |
| H2 (16386) | 0 su 4 |
| H3 (16387) | 0 su 4 |
| H4 (16388) | 0 su 4 |

La cella viva non e' un picco isolato fra vicini rossi: sta **dentro una riga
intera che regge**. E' esattamente la forma che cerchiamo, ed e' il motivo per
cui la griglia non richiesta ha finito per essere utile.

---

## 4. ⛔ COSA QUESTO REFERTO **NON** DICE

- 🚫 **Non dice che PTE_GBPUSD sia robusta ai regimi.** I tick reali di BCM
  partono dal **2024.07.05**: qui dentro **non c'e' l'orso 2022** e **non c'e'
  il crollo 2020**. R58 valida il **riempimento**, mai la robustezza di regime.
  Quella risposta la danno solo i dati lunghi (Dukascopy / HistData).
- 🚫 **Non e' un confronto diretto con R56/R57.** Feed diverso (BCM vs `_EXT`),
  finestre diverse, periodo diverso. Chi mette le tre tabelle una accanto
  all'altra sta confrontando cose che non sono confrontabili.
- 🚫 **Non ribalta R57.** La promozione di rango di PTE_GBPUSD e' caduta in R57
  per il criterio B nell'orso, e **resta caduta**: R58 non misura l'orso.
- 🚫 **Non promuove niente.** Quello che dice e' piu' semplice e piu' solido:
  **la cella che gira in forward, sui tick veri, sui 24 mesi che abbiamo,
  supera il cancello.**

---

## 5. 📌 CONCLUSIONE

| | |
|---|---|
| 🟢 **La cella viva passa il cancello a tick reali** | 4 criteri su 4 |
| 🟢 **L'altopiano e' una riga intera** | H1 4/4 positive, H2/H3/H4 0/12 |
| 🔴 **Spearman −0,60** | ottimizzare in campione resta controproducente |
| ⚠️ **[INCERTO] aperto** | perche' la griglia vecchia sia finita nelle `.ini` |
| 🚫 **Fuori portata** | orso 2022 e crollo 2020: BCM non li ha |

> ### **Nessun parametro degli EA in forward e' stato toccato.**

---

### Materiale

- `backtest_pipeline/risultati_prove/tick_reali_r58/ABTG_PTE_GBPUSD_IS_r58.csv`
- `backtest_pipeline/risultati_prove/tick_reali_r58/ABTG_PTE_GBPUSD_OOS_r58.csv`
- `backtest_pipeline/risultati_prove/tick_reali_r58/gen_ABTG_PTE_GBPUSD_IS_r58.ini`
- `backtest_pipeline/risultati_prove/tick_reali_r58/gen_ABTG_PTE_GBPUSD_OOS_r58.ini`
- cella congelata: `backtest_pipeline/prove/CELLE_REGIME.txt` riga `PTE_GBPUSD`
- file prova (cella singola): `backtest_pipeline/prove/ABTG_PTE_R58.txt`

### Da fare, in coda a questo round

1. ~~Capire l'`[INCERTO]` del punto 1~~ ✅ **FATTO il 16/08 — vedi in fondo.**
   Causa trovata: il mio file R58 aveva **zero assi spazzolati** e il driver
   **rifiuta di lanciare** in quel caso. Un pezzo resta aperto, ma da oggi
   si vede prima con `-SoloControllo`.
2. Misurare il **DD OOS originale di COST_EURJPY**: e' l'unico numero che
   separa quella cella da una promozione di rango (criterio A di R59).
3. Indici a tick reali su BCM (`D30EUR`, `U30USD`) — la riga e' pronta.

---

## 🔎 AGGIORNAMENTO 16/08 — l'[INCERTO] del punto 1 e' **in parte risolto**, e la colpa e' mia

Promesso in fondo a questo referto: _"capire l'[INCERTO] leggendo
`walkforward_generico.ps1` col file prova in mano, **prima** di rilanciare
qualunque cosa con `-Prova`"_. Fatto. Ecco cosa c'era.

### La causa che ho trovato: **il mio file R58 non poteva girare, per costruzione**

`ABTG_PTE_R58.txt` aveva **tutte le righe col flag `N`**:

```
InpTF=16385||16385||0||16385||N
InpTP1_ATRmult=0.5||0.5||0||0.5||N
InpRiskPercent=1.0||1.0||0||1.0||N
```

E il driver, alla riga ~374, fa questo:

```powershell
if($flag -notmatch '^[Yy]'){ continue }      # blindata di proposito -> NON entra nello sweep
...
if($Sweep.Count -eq 0 -and $Errori.Count -eq 0){
  [void]$Errori.Add("nessun parametro da spazzolare: sarebbe un backtest singolo, non un walk-forward")
}
...
Write-Host "=== NON LANCIO. Prima si sistemano questi ==="
```

> 🔴 **Un file prova con zero assi spazzolati fa RIFIUTARE il lancio.**
> Il mio file R58 chiedeva **una cella sola**: per questo driver non e' una
> prova, e' un errore. **Non e' stato MT5 a fare i capricci: ho scritto un
> file che quel driver non puo' eseguire**, e la corsa e' andata avanti con
> la griglia di default di `prove\ABTG_PTE.txt`.

### Cosa resta [INCERTO], e lo lascio aperto

Le direttive `@` (simbolo, periodo, data) nell'`.ini` **sono le mie**, mentre
le righe di parametro **sono quelle vecchie**. Se avesse letto un solo file,
verrebbero entrambe dallo stesso. **Questo pezzo non lo so spiegare e non lo
invento.**

### 🛡️ Ma da oggi non serve piu' spiegarlo per proteggersi: **si VEDE prima**

Il driver ha `-SoloControllo` (usato in R59). Stampa, **senza lanciare
niente**, esattamente cosa passera' a MT5:

```
    parametri in [TesterInputs] : N
    spazzolati                  : N
        InpLookback               6 celle
    celle per finestra          : 6
```

**Se quelle righe non sono quelle attese, ci si ferma li'** — in un minuto,
non dopo due ore di tick reali. Da oggi **entra nella
`CHECKLIST_RIGA_DI_LANCIO.md` come punto 5: prima di ogni `-Prova`, un giro a
vuoto.**

### E un difetto gemello, gia' documentato nel driver stesso (riga ~393)

> _"un pin scritto `Nome=35` imposta il VALORE ma NON spegne il flag di
> ottimizzazione che MT5 ricorda dall'ultima griglia di quell'EA -> il tester
> rispazzola la griglia vecchia nonostante il pin."_

**MT5 si ricorda i flag della griglia precedente di quell'EA.** E' il motivo
per cui il driver scrive sempre i pin in forma completa `v||v||0||v||N`.
Nel nostro caso e' un'aggravante: sullo stesso EA erano gia' girate griglie.
