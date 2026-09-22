# 🔎 IL SUPERTREND MISURATO FUORI CASA — **40 celle, zero passa**. E il rumore batte una famiglia

**22/09/2026** · richiesta di Claudio: i due Pine incollati in chat
(SuperTrend classico + `[LUX] SuperTrend Oscillator`) *«**sembrano validi come segnali, da provare**»*

---

## 0. 🎯 CHE COS'E' QUESTA MISURA, E CHE COSA NON E'

**Non è un round.** È uno **screening** su dati esterni M1, fatto **prima** di spendere
giorni di tick reali, per decidere se il round si merita la macchina.
Strumento: `backtest_pipeline/sonda_supertrend_segnali.py` (556 righe, ASCII puro, **autotest 10/10**).

🔴 **E i criteri sono stati dichiarati PRIMA dei numeri**, dentro il file:
1. il verdetto è sul **PF NETTO**, non sulla % di falsi — *(correzione mia, fatta prima
   di girare: la % di falsi è la metrica di LuxAlgo ed è **insufficiente**, un sistema
   può sbagliare il 60% delle volte ed essere profittevole)*;
2. merita un round solo con **PF netto ≥ 1,10 su ≥ 2 simboli E su tutti e due i lati**
   (regola di casa del 25/08);
3. 🧪 **contro-esempio obbligatorio**: la stessa catena gira su una **passeggiata
   aleatoria a volatilità appaiata**. Se una famiglia guadagna anche lì, **la misura si
   butta**.

### Le cinque definizioni di segnale — tutte prese dai due Pine, nessuna inventata
| | che cos'è | da dove |
|---|---|---|
| `S1_FLIP` | cambio di stato del Supertrend | Pine 1, il flip classico |
| `S2_AMA_ZERO` | la media adattiva cambia segno | Pine 2 |
| `S3_OSC_80` | `osc` attraversa ±0,80 | Pine 2, le due `hline(80)` |
| `S4_HIST_ZERO` | l'istogramma cambia segno | Pine 2 |
| `S5_OSC_AMA` | `osc` incrocia `ama` | Pine 2 |

✅ **E qui devo correggerti una cosa che avevo detto io**: avevo scritto che l'oscillatore
*«come motore d'ingresso non aggiunge niente»*. **Sbagliato, e tu avevi ragione**: il
pannello espone **quattro definizioni di segnale che NON sono il flip** — e infatti
l'autotest `T10` lo verifica per costruzione. Le ho misurate **tutte e cinque**.

### I dati e il costo — misurati, non stimati
- **4 simboli**: oro (Oanda `XAU_USD`) · DAX (`GRXEUR`) · S&P500 (`SPXUSD`) · Nikkei (`JPXJPY`)
- **2013-2018**, **2 TF** (H1 e H4), **2,08 milioni** di barre M1 sul solo oro
- **costo per lato, dal NOSTRO archivio tick**: DAX **1,7676 pt** (mediana pesata su
  20,9 milioni di tick, ore 08-17) · oro **0,2003 $/oncia**. 🔴 S&P e Nikkei sono
  **[NON MISURATI]** sul nostro broker: usato il costo in **punti base** ricavato dal DAX,
  e dichiarato come tale.
- **2 costi per inversione** (si chiude e si riapre), ingresso **all'apertura della barra
  dopo** il segnale — nessun look-ahead, e l'autotest `T5` lo prova troncando il futuro.

---

## 1. 📊 I NUMERI — 40 celle (4 simboli x 2 TF x 5 famiglie)

### PF **NETTO** (soglia dichiarata: 1,10)

| famiglia | oro H1 | oro H4 | DAX H1 | DAX H4 | S&P H1 | S&P H4 | Nikkei H1 | Nikkei H4 |
|---|---|---|---|---|---|---|---|---|
| `S1_FLIP` | 0,981 | 0,989 | 0,905 | **1,089** | 0,907 | 0,891 | 0,986 | 0,891 |
| `S2_AMA_ZERO` | 0,971 | **1,179** | **1,104** | 1,036 | 1,041 | **1,094** | 1,005 | 0,891 |
| `S3_OSC_80` | 0,975 | 0,993 | 0,924 | **1,090** | 0,903 | 0,892 | 0,967 | 0,894 |
| `S4_HIST_ZERO` | 0,985 | **1,281** | 0,900 | 1,079 | 0,776 | 0,927 | 0,907 | 0,909 |
| `S5_OSC_AMA` | 0,776 | 0,998 | 0,858 | 1,058 | 0,813 | 0,893 | 0,909 | 0,883 |

> ### 🔴 **Zero famiglie su cinque passano il criterio. Su nessun simbolo.**
> Il massimo assoluto è **1,281** — ed è proprio la cella che il contro-esempio uccide.

### 🧪 IL CONTRO-ESEMPIO CHE HA MORSO: `S4_HIST_ZERO` su oro H4
```
        dati VERI   ->  PF netto  1,281
        RUMORE PURO ->  PF netto  1,296     <-- PIU' ALTO
```
🔴 **Sulla passeggiata aleatoria quella famiglia guadagna DI PIU' che sui dati veri.**
La media mobile a 72 barre dell'istogramma **fabbrica** un PF apparente dove non c'è
niente. Senza quel controllo, avrei potuto portarti 1,281 come un risultato.
👉 **`S4_HIST_ZERO` non è "debole": è una misura da buttare.** E lo stesso succede su DAX H4
(rumore 1,176) e Nikkei H4 (1,256).

### ❌ E la % di falsi — il numero che l'indicatore ti mostra sul grafico
**Fra 59,8% e 73,7% in tutte e 40 le celle**, mediana ~65%.
📌 Io avevo dichiarato *«sopra il 55% è morta»*: **nessuna cella scende sotto il 59,8%.**
E il contatore di LuxAlgo è pure **ottimista**, perché non toglie lo spread: il suo numero
sul grafico è più basso di questo.

---

## 2. 💡 LA SCOPERTA VERA — e spiega perché sul grafico sembra funzionare

Guarda i due lati separati, invece del totale:

| | PF long | PF short |
|---|---|---|
| **DAX / S&P / Nikkei** (indici) | fino a **1,42** | giù fino a **0,66** |
| **ORO** | giù fino a **0,74** | fino a **1,46** |

🔴 **L'asimmetria è ROVESCIATA fra indici e oro. E non è un edge: è la direzione
in cui i mercati sono andati dal 2013 al 2018.** Gli indici salivano, l'oro scendeva
(da ~1.670 a ~1.280 $). Il Supertrend non ha previsto niente: **ha seguito il drift**, e
il lato controtrend ha pagato il conto.

> 👉 **Ecco perché "ad occhio sul grafico va molto bene": stai guardando il lato che
> il mercato ha regalato, sul periodo in cui glielo ha regalato.** Il lato opposto — che
> per la regola del 25/08 si misura SEMPRE — sta sotto 1,00 quasi ovunque.

---

## 3. 🏁 IL VERDETTO, E PERCHÉ STAVOLTA È UN **CERTIFICATO**

Il certificato di morte esige che un candidato sia misurato in **almeno due modi diversi**.
Adesso lo è, e i due modi **non si parlano fra loro**:

| | cosa dice | su cosa |
|---|---|---|
| 🏠 **In casa**, 16 EA della famiglia | PF OOS **0,75-1,01** su n 290-640 | BCM, tick reali, 2024-2026 |
| 🌐 **Fuori casa**, questa sonda | PF netto **0,78-1,09** su n 364-5.054 | Oanda/HistData, 4 simboli, 2013-2018 |

> # 🔴 **Due strade indipendenti — dati diversi, anni diversi, strumenti diversi, broker diversi — arrivano allo STESSO numero: PF ≈ 1,00.**

💀 **Il segnale grezzo del Supertrend, in tutte e cinque le definizioni che i due
indicatori espongono, non ha edge oltre il costo.** Questo è il certificato che alla
famiglia mancava da luglio.

### ⚠️ E i limiti, dichiarati — perché un certificato onesto li ha
- 🔴 **È il SEGNALE, non la STRATEGIA.** Qui non c'è stop, non c'è target, non c'è
  gestione dell'uscita: si sta sempre a mercato. 👉 Resta vero che *la gestione
  dell'uscita non è mai stata messa ad asse* sul flip puro. **Ma una gestione non crea
  edge dal nulla: lo rimodella.** Con il 60-74% di segnali falsi **già al lordo**, non c'è
  molto da rimodellare — e i nostri 16 EA, che una gestione ce l'hanno, atterrano allo
  stesso 1,00.
- **Finestra 2013-2018**: sei anni, contiene il 2015 e il 2018, ma **non è la prova a
  quattro regimi** (regola C del 16/08). È storia contigua.
- **OHLC M1 aggregate, non tick**: niente slippage, niente spread variabile intraday.
- **S&P e Nikkei**: costo **[NON MISURATO]** sul nostro broker.
- **Parametri fissi** (10 / 2,0 / 72, i default dei due Pine). 🔴 E **non si allarga la
  griglia**: la regola del 19/08 lo vieta su un motore senza edge, perché una griglia più
  fitta trova **picchi di rumore** — ed è esattamente quello che `S4_HIST_ZERO` ha appena mostrato
  di saper fare.

---

## 4. 💰 QUANTO È COSTATA

**Zero minuti di Strategy Tester. Zero righe da lanciare. Zero VPS.**
Ha girato qui, sui dati che scendono dal proxy. 👉 E ha chiuso una famiglia da **16 EA**
che era ferma senza certificato da **luglio**.

🔵 **Niente toccato in campo.**

---

## 📁 FONTI E RIPRODUCIBILITÀ
| cosa | dove |
|---|---|
| strumento | `backtest_pipeline/sonda_supertrend_segnali.py` |
| referti grezzi | `backtest_pipeline/risultati_prove/SONDA_SUPERTREND_SEGNALI_20260922.txt` · `backtest_pipeline/risultati_prove/SONDA_SUPERTREND_ORO_20260922.txt` |
| dati | `FutureSharks/financial-data` (GPL-3.0): Oanda `XAU_USD`, HistData `GRXEUR` `SPXUSD` `JPXJPY` |
| costo DAX | `backtest_pipeline/risultati_archivio/spread_flotta/spread_orario_D30EUR.csv` (mediana pesata, 20.975.948 tick, ore 08-17) |
| costo oro | `report/ORO_1530_CANCELLO_COSTO_2026-09-10.md` 2.4 |
| i 16 EA di casa | `FLOTTA_ATTIVA.md` · `report/CENSIMENTO_PF_MISURATI_2026-09-09.md` |
| riga per rifarla | `python3 backtest_pipeline/sonda_supertrend_segnali.py --da 2013 --a 2018 --tf 60,240 --simboli <lista> --fuori <referto.txt>` |


---

# 5. ⏬ E I TF PIU' BASSI? **MISURATI — e peggiorano in modo pulito**

Domanda di Claudio: *«non riusciamo a testarli con TF più bassi?»*. 🟢 **Sì, e in due
minuti**, perché lo strumento prende il TF come parametro. M5, M15, M30 su DAX e S&P,
stessi dati, stessi costi, stesso contro-esempio.

🔮 **Attesa dichiarata PRIMA di girare**: TF più basso = più inversioni = più costo,
quindi PF netto **in discesa monotona**. Se invece fosse salito, il mio modello della
famiglia era sbagliato — e sarebbe stato il risultato del giorno.

## 5.1 `S1_FLIP` — PF **lordo** contro PF **NETTO**, per TF

| TF | n DAX | DAX lordo | **DAX netto** | n S&P | S&P lordo | **S&P netto** |
|---|---:|---:|---:|---:|---:|---:|
| **M5** | 11.996 | 0,993 | 🔴 **0,761** | 22.266 | 0,959 | 🔴 **0,572** |
| **M15** | 3.873 | 1,075 | 0,928 | 7.108 | 0,987 | 0,743 |
| **M30** | 2.048 | 1,024 | 0,925 | 3.485 | 1,004 | 0,829 |
| **H1** | 1.056 | 0,973 | 0,905 | 1.733 | 1,041 | 0,907 |
| **H4** | 364 | 1,137 | **1,089** | 476 | 0,955 | 0,891 |

> ### 🔴 **Il PF LORDO sta fra 0,955 e 1,137 a OGNI timeframe. Il segnale grezzo e' una monetina ovunque.**
> 👉 **Quello che cambia scendendo di TF non e' il segnale: e' il CONTO.** Da H4 a M5 le
> inversioni sul S&P passano da **476 a 22.266** (x47) e il PF netto crolla da 0,891 a
> **0,572**. L'attesa dichiarata prima era la discesa monotona: **è quello che è uscito.**

## 5.2 💀 Il caso estremo, che vale come promemoria
`S5_OSC_AMA` sul S&P a **M5**: **60.037 inversioni**, PF lordo **0,981**, PF netto **0,425**,
**80,16%** di operazioni in perdita al netto.
👉 Sessantamila giri per regalare al broker quattro quinti del capitale. **Non è un
motore: è una pompa di spread.**

## 5.3 📐 E IL CONTO DI CASA LO AVEVA GIA' PREVISTO — **misurato, non stimato**

La frontiera del costo di casa dice `stop >= 40 x spread`. L'ho **misurata** sul DAX: distanza mediana
prezzo -> linea Supertrend(10 / 2,0), 2013-2018, contro lo spread **misurato** di 1,7676 pt.

| TF | stop mediano (pt indice) | volte lo spread | frontiera 40x |
|---|---:|---:|---|
| **M5** | 13,60 | **7,7x** | 🔴 sfondata |
| **M15** | 25,82 | **14,6x** | 🔴 sfondata |
| **M30** | 38,41 | **21,7x** | 🔴 sfondata |
| **H1** | 54,88 | **31,0x** | 🔴 sfondata |
| **H4** | 94,70 | **53,6x** | 🟢 **passa** |

> ### 🎯 **La frontiera del costo cade fra H1 e H4. E H4 e' l'UNICO TF dove il flip sul DAX chiude sopra 1,00 (PF netto 1,089).**
> 👉 **Due misure di casa indipendenti — il cancello del costo e il PF netto — indicano
> lo stesso punto.** Non e' una coincidenza: e' lo stesso fenomeno visto da due lati.

🟢 Quindi la risposta alla domanda *«non riusciamo con TF piu' bassi?»* non e' un "no"
di pancia: e' **"no, e sappiamo di quanto"**. M5 e' a 7,7x quando ne servono 40. Il TF basso
su questa famiglia e' **escluso PER COSTO, col numero accanto** — che e' esattamente il modo
in cui la regola del 09/09 chiede di escludere un TF.

⚠️ E anche a H4, dove il costo passa, il PF netto e' **1,089 sul DAX ma 0,891 sul S&P e
0,891 sul Nikkei**: passa il cancello del costo e **non passa quello del merito**. Sono due
cancelli diversi, e vanno superati tutti e due.

📌 Referto grezzo: `backtest_pipeline/risultati_prove/SONDA_SUPERTREND_TF_BASSI_20260922.txt`


---

# ✏️ CORREZIONE DEL 22/09 SERA — **il costo era sbagliato di 2x, ed era colpa mia**

🔴 La sonda toglieva **due** costi per operazione, chiamando «per lato» quello che la
fonte chiama **giro**. `report/ORO_1530_CANCELLO_COSTO_2026-09-10.md` par. 2.4 scrive testuale:
*«**Costo pieno di un GIRO COMPLETO** sull'oro: 0,16 (spread) + 0,0403 (commissione) =
**0,2003 $**»*. E un'operazione in questa sonda **e' gia' un giro completo**: si apre a un
flip e si chiude al flip dopo, quindi lo spread si attraversa **una volta**, non due.
Lo stesso vale per lo spread degli indici.

🟢 **Il verso dell'errore era PESSIMISTA**: toglievo il doppio del dovuto, quindi i PF netti
pubblicati sopra erano **piu' bassi del vero**. 👉 **Percio' non l'ho dato per scontato: ho
rifatto la misura.**

## 📊 I numeri col costo giusto — **e il verdetto non cambia**

| | PF netto **prima** (2x) | PF netto **corretto** | passa? |
|---|---:|---:|---|
| DAX H1 `S1_FLIP` | 0,905 | 0,939 | 🔴 no |
| DAX H4 `S1_FLIP` | 1,089 | 1,113 | 🔴 no (short 1,013) |
| DAX H1 `S2_AMA_ZERO` | 1,104 | 1,135 | 🔴 no (1 simbolo solo) |
| oro H4 `S2_AMA_ZERO` | 1,179 | 1,203 | 🔴 no (**long 0,973**) |
| oro H4 `S4_HIST_ZERO` | 1,281 | 1,307 | 🔴 **la misura si butta: il rumore fa 1,317** |

> ### 🔴 **Zero famiglie passano il criterio anche col costo dimezzato.** Il certificato regge.

🟢 E la cella che sembrava la migliore resta quella che il **rumore batte**: 1,307 contro
**1,317** su una passeggiata aleatoria.

## 🧪 E l'autotest e' stato corretto, non cancellato
Il controllo `T6b` diceva *«il costo tolto e' 2 per operazione»*: **quel test codificava
l'errore**, ed e' il motivo per cui l'errore e' sopravvissuto a 10 controlli verdi.
Adesso dice **UNO**, e accanto c'e' il **contro-esempio `T6c`**: *«il vecchio criterio (2 per
op) ora NON torna»*. 👉 **Un autotest che verifica il comportamento sbagliato non e' una rete:
e' una conferma.** E' la stessa forma della classe 581.

📌 Referti col costo corretto: `backtest_pipeline/risultati_prove/SONDA_SUPERTREND_COSTO_CORRETTO_20260922.txt` · `backtest_pipeline/risultati_prove/SONDA_SUPERTREND_ORO_COSTO_CORRETTO_20260922.txt`. Classe **587**.
