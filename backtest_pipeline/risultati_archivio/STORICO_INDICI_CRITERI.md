# 📜 STORICO ESTERNO DEGLI INDICI — I CRITERI DA FIRMARE

_Scritto il 25/08/2026 su richiesta di Claudio: **"per gli Indici cerchiamo di
fare i test con piu' anni di storico"**._

> ## ⚠️ QUESTO FILE E' UN CANCELLO, NON UNA NOTA
> `RIGA_STORICO_INDICI.ps1` **legge questo file al pin** e cerca le righe
> `@DECISIONE ... STATO=FIRMATO`. Finche' una decisione e' `DA_FIRMARE`, la
> fase che la consuma **non parte** e finisce nel referto come
> `NON ESEGUITA (decisione D-x non firmata)`.
>
> **Per firmare:** si cambia `STATO=DA_FIRMARE` in `STATO=FIRMATO` (e, se
> serve, il `VALORE=`), si committa e **si pusha**. Il pin nuovo e' quello
> che va nella riga di lancio. Non esiste un interruttore `-Firmato` da riga
> di comando, apposta: una decisione che si scavalca dalla console non e'
> una decisione.

---

## 0. 🧊 LA COSA CHE VA DETTA PRIMA DI TUTTO IL RESTO

**Scaricare piu' anni NON sblocca da solo i test sugli indici.** Lo stato
misurato oggi:

| | misura | dove |
|---|---|---|
| indici `_EXT` gia' importati | `NASUSD_EXT` `225JPY_EXT` `SPXUSD_EXT`, 2019→2026.07 | REFERTO_HISTDATA §14 |
| **cancello ZERO** (diff media H1 contro il nativo BCM) | **0,061% – 0,101%** contro il **≤0,05%** richiesto | REFERTO_HISTDATA §14-15 |
| cura DST (`_v2`) | **peggiora** del 7,7-8,6%: non e' il fuso | §15 |
| stato | **IN FRIGO: esistono e NON si usano nei round** | §15 punto 4 |

> ### 🎯 Cioe': oggi il collo di bottiglia degli indici **non e' la quantita' di storico, e' il CANCELLO ZERO che e' ancora chiuso.**
> Piu' anni servono — ma un `NASUSD_EXT` dal 2010 invece che dal 2019 resta
> **in frigo esattamente come quello di adesso** finche' quel numero non
> scende sotto 0,05% **o** finche' il metro non viene ridiscusso **con una
> misura e la firma di Claudio** (mai ammorbidito a occhio: §15 punto 3).

**Conseguenza pratica, e va scritta in testa al referto:** questo giro
produce **dati**, non **verdetti**. Il permesso di usarli e' un'altra firma,
che dipende dal cancello ZERO e non da questo file.

---

## 1. 🔭 QUELLO CHE E' GIA' MISURATO (non si rimisura)

### 1a. BCM sugli indici: 26/09/2024, e la parola e' `COMPLETO`
`REFERTO_SONDA_STORICO_17-08.md` §3: dodici simboli indice/energia con
`PrimaDataServer 2024.09.26` e stato **`COMPLETO`**. Non manca sul disco: **il
broker non ce l'ha.** Definitivo, non si risonda.

### 1b. La sonda Dow: **il secondo giro E' TORNATO** — anzi, il terzo
La missione chiedeva di verificare se un secondo giro fosse mai tornato.
**E' tornato, due volte**, ed e' agli atti in `REFERTO_SONDA_DUKASCOPY.md`:

| grafia | esito | giro |
|---|---|---|
| **`USA30IDXUSD`** | ✅ **OK, 49.445 byte** — **primo anno 2012** | giro 2 e 3 (15/08, 16:25 e 16:45) |
| `US30IDXUSD` · `USA30USD` · `WS30IDXUSD` | ❌ ASSENTE (404 **veri**) | giro 3 |
| `GERIDXEUR` | ❌ ASSENTE | giro 3 |
| `DJIIDXUSD` | ⚠️ `ERRORE 0` (rete) — **NON misurato**, non e' un'assenza | giro 3 |
| `USA2000IDXUSD` (controllo di schema) | ⚠️ `503` — **NON misurato** | giro 3 |

> **Quindi la fase 1 della missione e' gia' fatta: `USA30IDXUSD` E' il nome
> del Dow e parte dal 2012.** Il driver la dichiara `GIA' MISURATA (giro3
> 15/08)` e **non rilancia niente** — rilanciare una misura chiusa e' come
> non averla fatta. Restano fuori misura solo due caselle **che non ci
> servono**, e il driver le rilancia solo con `-RifaiSondaDow` (12 richieste,
> ~1 minuto), dichiarandolo.

### 1c. E LA NOTIZIA CATTIVA: **il crawl Dukascopy dei tick e' gia' stato misurato, ed e' fuori portata**
`REFERTO_DUKASCOPY_FATTIBILITA.md`, coda: corsa vera `DEUIDXEUR` dal PC di
Claudio, **25 giorni su 2389 in 1h43m** (503/reset/timeout continui) =
**~4 minuti per giorno di storico**.

| | giorni iterati (sabato escluso) | col ritmo misurato |
|---|---:|---:|
| DAX 2012→oggi | ~4.590 | **~306 ore = 12,7 GIORNI** |
| Nasdaq 2012→oggi | ~4.590 | **~306 ore = 12,7 GIORNI** |
| **i due insieme** | ~9.180 | **~25 giorni di crawl ininterrotto** |

**Non e' un'opinione sulla strada: e' il numero che la strada ha prodotto.**
Per questo la proposta D-A qui sotto non e' Dukascopy.

---

## 2. ⚖️ LE DUE STRADE, NUMERO CONTRO NUMERO

| | 🥇 **HistData** (`histdata_m1.py`, HD-M1-v4) | 🥈 **Dukascopy** (`dukascopy_m1.py`, DUKA-M1-v3) |
|---|---|---|
| che cosa scarica | **1 ZIP annuale** per simbolo per anno | **24 file `.bi5` al giorno** |
| richieste per simbolo-anno | **1** | **~7.500** |
| ritmo **misurato** | 4 simboli × 8 anni in **minuti** (56 zip, 0 falliti) | **~4 min/giorno** → 12,7 giorni per simbolo su 14 anni |
| primo anno disponibile | **2010-11** | 2012 |
| DAX | 🔴 `grxeur` **BOCCIATO** (righe marce, sessione ballerina 2020-06→2023-11) | ✅ `DEUIDXEUR` pulito sul giorno campione |
| Nasdaq | ✅ `nsxusd` **promosso** (2,5 M barre, banda OK, DST 91/91 mesi) | ✅ `USATECHIDXUSD` |
| Dow | ❌ **non esiste su HistData** | ✅ `USA30IDXUSD` dal 2012 |
| spazio (2 simboli, 14-17 anni) | **~0,8 GB** | **~9 GB** di cache `.bi5` |

**Le due strade non sono alternative: sono complementari, e lo erano gia'
il 15/08.** HistData e' la strada di volume; Dukascopy e' il bisturi per
quello che a HistData manca o e' sporco.

---

## 3. ✍️ LE DECISIONI

Le righe `@DECISIONE` sotto sono quelle che il driver **legge a macchina**.
Il testo intorno e' per chi firma; il driver guarda solo quelle righe.

```
@DECISIONE D-A CHIAVE=FONTE VALORE=histdata STATO=DA_FIRMARE
@DECISIONE D-B CHIAVE=SIMBOLI VALORE=NASUSD STATO=DA_FIRMARE
@DECISIONE D-C CHIAVE=USO VALORE=SOLO_PROVA_REGIME STATO=DA_FIRMARE
@DECISIONE D-D CHIAVE=FINESTRA VALORE=2010-2026 STATO=DA_FIRMARE
@DECISIONE D-E CHIAVE=SOGLIA_CANARINO_ORE VALORE=20 STATO=DA_FIRMARE
@DECISIONE D-F CHIAVE=STRADA_DAX VALORE=diagnosi_prima STATO=DA_FIRMARE
```

---

### 🅐 D-A — **barre M1, non tick pieni.** Fonte proposta: **HistData**

**Proposta: `FONTE=histdata`, e M1 come unita' — non per risparmiare, ma
perche' i tick pieni a valle NON SI POSSONO USARE.**

Il motivo e' scritto nello strumento che li consumerebbe,
`importa_storico_esterno.ps1` (riga 525):

> _"Il modello 4 (tick reali) NON si usa: su un simbolo costruito da barre M1
> i tick reali non esistono."_

Un simbolo custom MT5 nato da un import **e' fatto di barre**. Scaricare 9 GB
di tick per poi aggregarli a M1 e testarli a modello 1 non aggiunge **un solo
bit** di informazione utilizzabile rispetto a scaricare le M1 direttamente.
E infatti `dukascopy_m1.py` **non conserva nemmeno i tick**: li aggrega in M1
e tiene i `.bi5` solo come cache di ripresa.

> **Quindi la domanda "tick pieni o M1?" ha una risposta MISURATA, non di
> gusto: M1. I tick pieni sarebbero 9 GB e 25 giorni per un dato che il
> tester, su questi simboli, non puo' leggere.**

⚠️ **Il prezzo di questa decisione, dichiarato:** niente spread storico,
niente slippage vero. Sui motori a stop stretti il verdetto puo' spostarsi
(R55: **1,5 punti indice** sfondano il cancello del 10% sull'ORB). Vale per
entrambe le strade, tick o no: nel tester lo spread e' quello che si imposta.

---

### 🅑 D-B — quali simboli in questo giro

**Proposta: `SIMBOLI=NASUSD`.** Uno solo, e si dice perche'.

| simbolo | proposta | motivo, misurato |
|---|---|---|
| **NASUSD** (Nasdaq) | ✅ **SUBITO**, HistData `nsxusd`, 2010-11→oggi | e' l'unico gia' **promosso da tutti i cancelli dello strumento** (§13): banda OK, DST 91/91, 0 righe scartate. Estendere la finestra da 2019 a 2010 costa **minuti** |
| **D30EUR** (DAX) | ⏸️ **NON in questo giro** — prima la diagnosi, vedi D-F | `grxeur` e' **bocciato**: prezzo minimo **2.906** (un DAX sotto 8.000 non esiste) e apertura di sessione che cambia per 3,5 anni. Importarlo cosi' vorrebbe dire mettere in MT5 dati che sappiamo marci |
| **U30USD** (Dow) | ❌ **fuori**, e dichiarato | HistData **non ha il Dow**; Dukascopy ce l'ha (2012) ma costa **12,7 giorni** di crawl. Nessuna delle due e' una strada per stanotte |
| **SPXUSD** (S&P) | 🔜 **in coda**, gratis | gia' promosso e gia' importato per il 2019-2026: si estende con **la stessa riga**, aggiungendo `spxusd` a D-B |
| 225JPY (Nikkei) | 🔜 in coda | idem, gia' promosso |

> **Nessuno di questi cinque sparisce dal referto.** Anche `U30USD` e
> `D30EUR` ci compaiono, con la loro fase e il loro motivo:
> `FUORI GIRO (dichiarato)`. E' il difetto gia' pagato due volte — un simbolo
> chiesto e non comparso si legge come una domanda mai fatta.

---

### 🅒 D-C — limiti d'uso dei dati `_EXT`

**Proposta: `USO=SOLO_PROVA_REGIME`** — identico ai forex `_EXT`, piu' un
terzo divieto che il caso indici rende necessario.

1. ❌ **Non si tara NIENTE qui.** La taratura resta sui simboli BCM nativi.
   Un parametro pescato su un feed esterno e' **peggio di nessun test**,
   perche' sembra validato.
2. ❌ **Nessuna promozione di celle.** Una cella non entra in flotta, non
   cambia stato e non si sposta nelle classifiche per un numero uscito su un
   `_EXT`. La domanda ammessa e' una sola: **"questa strategia sopravvive a
   un mercato orso / a un crollo?"**
3. 🆕 ❌ **Finche' il CANCELLO ZERO e' chiuso (§0), gli `_EXT` indici non
   entrano nemmeno nella prova di regime.** Restano in frigo. Questo giro
   li **produce** e li **misura**; non li autorizza.
4. 📌 **Il confronto di merito si fa SEMPRE dentro lo stesso feed** (periodo
   calante contro periodo crescente sui dati `_EXT`), mai "HistData 2020
   contro BCM 2025".
5. 📌 **In testa a ogni referto** prodotto da questa riga: _questi sono dati
   di un ALTRO broker — spread, orari di seduta e prezzi non sono BCM._

---

### 🅓 D-D — la finestra

**Proposta: `FINESTRA=2010-2026`.** HistData pubblica gli indici da
**novembre 2010** (`PRIMO_MESE = 201011`, verificato su fonte terza e
ricontrollato da `--esplora` sul PC). Sedici anni.

Contro i **21 mesi** di BCM, e con dentro:

| regime | anno | dentro? |
|---|---|---|
| crisi del debito europeo | 2011-2012 | ✅ |
| taper tantrum | 2013 | ✅ |
| svalutazione yuan | 2015 | ✅ |
| Volmageddon / Q4 storto | 2018 | ✅ |
| **crollo Covid** | 2020 | ✅ |
| **orso + inflazione** | 2022 | ✅ |
| crisi 2008 | 2008 | ❌ non c'e', e non ci sara' |

⚠️ **E qui morde l'EMENDAMENTO DELLA FINESTRA (CLAUDE.md, regola C):**
sedici anni di fila **diluiscono**. Il modo giusto di usare questi dati non
e' "una corsa dal 2010 a oggi", sono **le quattro finestre di regime**
(toro / orso / laterale / crollo), macchina gia' fatta in R50-R56-R59.
Si scarica lungo **una volta**, poi si ritagliano le finestre.

⚠️ **E il tetto del tester resta:** ~100.000 barre per corsa (CLAUDE.md,
regola del 25/08) = M15 ~4 anni, M5 ~1,3 anni. Sedici anni si girano **su
H1**, o si spezzano in tranche **dichiarandolo**.

---

### 🅔 D-E — la soglia del canarino di ritmo

**Proposta: `SOGLIA_CANARINO_ORE=20`** (la stessa gia' usata in
`RIGA_NOTTE2_DUKA_R91.ps1`, decisa prima di misurare).

Il driver misura **il ritmo vero, oggi, su questa macchina** e proietta sulla
finestra chiesta. Se la proiezione supera la soglia, **non scarica niente** e
lo scrive. E' un **cancello**, non un consiglio: e' esattamente il controllo
che il 18/08 ha salvato una settimana di crawl inutile.

Vale per **entrambe** le fonti: HistData dovrebbe proiettare **minuti**, e se
proiettasse ore vorrebbe dire che qualcosa e' cambiato nel sito — e allora ci
si ferma lo stesso.

---

### 🅕 D-F — che si fa col DAX

**Proposta: `STRADA_DAX=diagnosi_prima`.** Tre strade, in ordine di costo:

| # | strada | costo | cosa risponde |
|---|---|---|---|
| 1 | 🥇 **`histdata_m1.py --diagnosi` sul `D30EUR_M1.csv` gia' sul PC** | **zero rete, minuti** | dove stanno le righe marce (per anno e per giorno) e cosa copre la sessione 02:00 del 2020-2023. Lo strumento c'e' gia' (HD-M1-v4) e **non e' mai stato eseguito sui dati veri** |
| 2 | 🥈 Dukascopy `DEUIDXEUR` **solo sulle finestre di regime** (crollo 2020 + orso 2022, ~370 giorni) | **~25 ore** di crawl, in due notti | un DAX pulito dove serve davvero, senza pagare i 12,7 giorni dei 14 anni |
| 3 | 🥉 bonifica dichiarata del CSV HistData | codice nuovo | da valutare **solo** se la 1 dice che le righe marce sono poche e isolabili |

> **Non si importa un DAX che sappiamo sporco per avere piu' anni.** Piu' anni
> di dati marci non sono piu' informazione: sono piu' modi di sbagliarsi.

---

## 4. 📋 ETICHETTE, una riga ciascuna

- **[VERIFICATO]** BCM indici `COMPLETO` a 2024.09.26 · `USA30IDXUSD` esiste
  e parte dal 2012 · ritmo Dukascopy ~4 min/giorno · HistData 2019-2026 per
  NASUSD/225JPY/SPXUSD promossi · `grxeur` bocciato · cancello ZERO chiuso a
  0,061-0,101% · shift +5 su 3 simboli su 3.
- **[INFERITO]** stime di **spazio** (0,8 GB HistData / 9 GB Dukascopy):
  estrapolate dai byte misurati su un'ora campione, non da una corsa piena —
  il driver le ricontrolla contro lo spazio libero **prima** di partire.
- **[INCERTO]** che HistData `nsxusd` sia pulito anche **prima** del 2019: la
  corsa promossa copre 2019-2026. Gli anni 2010-2018 **non sono mai stati
  guardati** e possono avere la stessa malattia del `grxeur`. Per questo il
  driver pretende la **banda** e la **mappa delle sessioni** anche sugli anni
  nuovi, e li dichiara anno per anno.

**Nessun parametro degli EA in forward cambia per questo documento.**
