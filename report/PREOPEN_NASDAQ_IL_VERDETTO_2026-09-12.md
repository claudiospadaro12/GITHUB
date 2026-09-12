# 🪦 IL PREOPEN NASDAQ DI CLAUDIO — **NO**, e i due agenti si contraddicevano su un punto

_Claudio ha caricato `Nasdaq_PreOpen_Breakout_EA.mq5` il 12/09 sera chiedendo
«questo lo abbiamo mai analizzato?». Due agenti in parallelo: uno sul codice,
uno sull'imbuto. Questo file **chiude la contraddizione fra i due** e tiene il
verdetto._

---

## 1. 🔴 LA RISPOSTA ALLA DOMANDA DI CLAUDIO: **l'EA no, IL MECCANISMO SI'**

`NPO_PREFIX`, `InpEntryBufferPoints`, magic `20260617`: **zero occorrenze** nel repo.
🔴 **Ma il MECCANISMO ce l'abbiamo, ed e' gia' misurato.**
`mql5/Experts/ABTG_Nasdaq_Live5m.mq5`, magic **`770203`**, intestazione r.7-12 —
verificata da me alla lettera:
> *"candela TRIGGER = i 5 minuti PRIMA dell'apertura (15:25-15:30 IT), non la
> candela H1 precedente · ordini a **7 punti indice** oltre max/min (buffer 700)
> · FILTRO ampiezza candela: opera solo se e' tra **17** e 40"*

**Trigger, orario, buffer 7, soglia 17, stop all'estremo opposto, 1 trade/giorno:
identici al punto indice.** Stessa fonte (la live del 17/07/26).
👉 Il sospetto *"il nostro prende l'apertura, questo la candela prima"* era
**giusto sul `770201` e sbagliato come conclusione**: di EA ce n'erano **tre**,
non due.

---

## 2. 💀 I NUMERI, LETTI DA ME DAI CSV GREZZI

`backtest_pipeline/risultati_prove/ABTG_Nasdaq_Live5m/`:

| finestra | modello | PF | n | DD% | Profit |
|---|---|---:|---:|---:|---:|
| IS | tick reali | 1,01621 | 116 | 11,5160 | +98,96 |
| **OOS** | **tick reali** | 🔴 **0,96265** | **175** | 🔴 **19,4006** | 🔴 **−326,54** |
| IS | OHLC M1 | 1,36567 | 125 | 8,0081 | +2.403,74 |
| **OOS** | **OHLC M1** | 🟡 **2,16249** | 198 | 7,3108 | 🟡 **+8.943,56** |

### 🏆 E QUESTO E' IL NUMERO PIU' UTILE DELLA GIORNATA, e non riguarda questo EA
**Stessa cella, stessa finestra OOS, cambia SOLO il modello:**
- profitto: **+8.943,56** contro **−326,54** -> divario **9.270,10 EUR**
- drawdown: **7,31%** contro **19,40%** -> peggiora di **x2,65**
- 🔴 **e il SEGNO SI RIBALTA.**

👉 Questa e' la misura che **quantifica** perche' `Modello 1` e' **solo
screening** e non un verdetto. Vale per tutto l'archivio, non per questo EA.
🔴 **E vale anche come avvertimento**: se qualcuno mostra la curva di questo
motore, sta quasi certamente mostrando quella da **+8.943**.

---

## 3. ⚖️ LA CONTRADDIZIONE FRA I DUE AGENTI — e come l'ho chiusa

| | dice |
|---|---|
| **agente 1** (audit codice) | *"la strada giusta e' `InpPrevWindowMin` = 10/15/20/30: a 15 minuti il range atteso fa x1,73 -> **17,5x**, sopra il pavimento duro. Zero righe di codice."* |
| **agente 2** (imbuto) | *"pre-apertura OOS-negativa a **ogni** larghezza: 5' **0,963** · 60' **0,798** · H1 **0,665**."* |

**Ho aperto io il CSV** (`Walkforward_Aperture/NASDAQ_L_rangemode_OOS.csv`):
```
RangeMode=1  PrevWin=60  ->  PF OOS 0.79830   n 329   DD 17.3476
RangeMode=2  (candela H1) ->  PF OOS 0.66483   n 321   DD 26.2917
```
🔴 **L'agente 2 ha ragione, e il suo dato uccide la proposta dell'agente 1.**

**Il punto che scioglie il nodo**: l'agente 1 ragiona sul **COSTO** (allargare la
finestra allarga il range, e la frontiera migliora — ed e' **vero**). L'agente 2
misura l'**EDGE** (allargare la finestra lo peggiora — ed e' **misurato su tre
punti**). 👉 **Migliorano il costo e peggiorano l'edge, e l'edge perde.**

🔬 **E l'onesta' sul limite di questo argomento**: 10/15/20/30 **non sono
misurati**. Sono pero' **racchiusi fra due misure** (0,963 e 0,798) che stanno
**entrambe sotto il cancello 1,10**. Per passare dovrebbero fare un **PICCO** fra
due valori negativi — ed e' esattamente la cella *"verde per caso"* che la regola
del 19/08 vieta di inseguire.
👉 **Quindi non si spendono passate. E se un giorno si spendessero, il verdetto
onesto sarebbe `[NON MISURATO]`, non "promettente".**

---

## 4. 📐 E LA FORMA DEL MOTORE E' UNA TENAGLIA

Il parziale del 50% a +20 (r.661-690 dell'EA caricato) fa si' che la vincita
piena valga **35 punti, non 50**:

| range | stop | RR **vero** (35/stop) | win% per PF 1,10 | `stop/spread` |
|---:|---:|---:|---:|---:|
| **17** | 24 | 1,46 | 43,0% | 🔴 **13,3x** (= il pavimento duro, al decimale) |
| 40 | 47 | 0,74 | 59,6% | 26,1x |
| **65** | 72 | 0,49 | 🔴 **69,4%** | ✅ **40,0x** |

🔴 **Non esiste un range che passa il COSTO e il PAYOFF insieme.** E' **algebra
sulla forma** (target fisso, stop variabile), non un problema di parametri.
📌 E il mio RR di ieri sera (2,08 / 1,56 / 1,06) era **ottimista**: non avevo
contato il parziale.

🧪 **Il contro-esempio, costruito per far cadere il verdetto**, su **447 breakout
veri** (`studio_apertura/Studio_NASUSD.csv`): *"a range largo il breakout tiene di
piu'"* -> **falso**: win rate **piatto** (36-40% in tutti e quattro i quartili) e
attesa **monotona al ribasso**, da **+0,055 R** sul quartile stretto a
**−0,069 R** su quello largo.

---

## 5. 🟢 E DUE COSE SONO USCITE A FAVORE — vanno dette

- **Campione**: ~**420 posizioni** misurabili a tick reali nei 24 mesi -> **sopra
  le 150**. Il campione **non e' il blocco**.
- **Frequenza**: **0,82 op/giorno** su un simbolo; con U30USD+SPXUSD la
  **famiglia** supera il pavimento di 1,00. La frequenza **non e' il blocco**.
- 🟢 E quattro accuse al codice sono state **smontate dai contro-esempi**:
  la chiamata prima della definizione **compila** (provato su un nostro EA che ha
  prodotto CSV veri), `InpPointSize=1.0` e' **corretto** (nessun fattore 100), i
  pesi 70/30 **non raddoppiano** il rischio, e il pattern hedging e' giusto.

---

## 6. 🚨 MA TRE DIFETTI VERI RESTANO, e uno e' una bomba a orologeria

1. 🔴 **`InpLocalUtcOffsetHours = 2` CABLATO** (CEST) + ancoraggio a **Roma**
   invece che alla **borsa**: dal **1 nov 2026 al 14 mar 2027** (~95 sedute) arma
   sulla candela delle **14:25**, un'ora prima, **in silenzio**. E metterlo a 1 il
   25 ottobre **peggiora**, perche' nelle due settimane di sfasamento DST i due
   errori si compensano.
2. 🔴 **Doppio fill possibile** con posizione **orfana** non gestita, e
   `g_tradesToday` che ne conta **1**.
3. 🔴 **`InpTimeframe != M5` da' ZERO trade in silenzio** — trappola diretta per
   il punto 5 del certificato (*"il TF cambiato almeno una volta"*).
Piu': **nessun filtro di spread, nessun filtro news, nessun Guardian**.

---

## 7. 🪦 IL VERDETTO
> ## **NO.** Non vale un posto nell'imbuto a 19 giorni.
> **E non e' un no da stanchezza**: e' un meccanismo **gia' misurato in casa a
> tick reali** (PF OOS **0,96265**, DD **19,40%**, n **175**), la cui **forma**
> rende impossibile passare costo e payoff insieme, e cha ha l'edge **monotono al
> ribasso** su tre larghezze di finestra e quattro quartili di ampiezza.

🔴 **La riga per `REGISTRO_TEST.md` e' PRONTA e NON INCOLLATA**: un verdetto che
archivia un candidato passa dal cancello (regola 09/09), e il secondo strato non
e' ancora tornato.

⚠️ **E una segnalazione che vale piu' del verdetto**: `REGISTRO_TEST.md` r.35
dice `⏳ in coda` per una cosa **gia' girata e che vale 0,96** — e' proprio
`Live5m 770203`. E' **esattamente** il buco che il CERTIFICATO DI MORTE doveva
chiudere: un motore misurato e bocciato che il registro descrive come "da fare".
