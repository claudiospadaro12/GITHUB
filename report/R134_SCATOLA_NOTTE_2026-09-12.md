# 🌙 LA SCATOLA DELLA NOTTE — R134 (12/09/2026)

> **Da dove nasce.** Claudio guarda un indicatore che disegna il massimo e il
> minimo della notte su **00:00–08:00 ora italiana**. I nostri preset vivi
> usano una scatola che finisce molto prima. Domanda semplice: **chi ha
> ragione?** In archivio c'erano 526 righe con `InpBoxEndHour`, quindi
> sembrava una domanda gia' mezza risposta.
> **Non lo era.** Ed e' saltata fuori una cosa piu' grossa.

---

## 1. 🔴 LA COSA GROSSA: UNA SEDIA VIVA GIRA UNA SCATOLA MAI BACKTESTATA

**`MaxMinNotte` oro, magic 770402.** E' viva davvero — **9 operazioni** nei
trade veri (`data/statements/trades_auto.csv`) — e in `HANDOFF.md:1121` ha un
**DD promesso del 5,3%**.

| | |
|---|---|
| scatola che gira **in campo** (`Presets/sedie_piccolo/sedia_MAXMIN_ORO_770402.set`, r.2-5) | **23:00 -> 04:59** |
| scatole effettivamente **backtestate** sull'oro, tutto l'archivio | **22:00 -> 06:59** (112 passate) · **22:00 -> 04:59** (4 passate) |
| passate sulla scatola che gira davvero | 🔴 **ZERO** |

👉 **Il DD del 5,3% e' promesso da una cella che non e' quella schierata.**
Non e' un errore di misura: e' una promessa che non copre l'oggetto.
Questo tocca il **CRITERIO DI USCITA, corsia RISCHIO** (firmato 18/08: *"DD
forward > DD promesso dal backtest della cella promossa -> revisione
IMMEDIATA"*). Qui il problema e' a monte: **manca il backtest della cella
promossa.**

### 🧪 Il contro-esempio, perche' questa non diventi un allarme gonfiato
La stessa prova sulla **gemella DAX 770411** (viva, `FLOTTA_ATTIVA.md:48`):
archivio = **23:00 -> 04:59, 154 passate**, cioe' **esattamente** la scatola
del preset. 🟢 **La gemella e' a posto.** Quindi non e' un difetto di
processo diffuso: e' **una sedia sola**, e si chiama per nome.

**Che cosa NON si fa**: non si tocca la sedia. Si misura la sua scatola vera
e si confronta col contratto. La sedia si tocca solo dopo, e lo decide
Claudio.

---

## 2. 📏 LA CORREZIONE SUL NUMERO: la scatola di Claudio in ora server e' **6**, non 7

Avevo scritto 7 ragionando sull'istante: 08:00 IT − 1 = 07:00 server. **Il
ragionamento e' giusto e il parametro e' sbagliato**, perche'
`InpBoxEndHour:InpBoxEndMin` **non e' il bordo escluso: nomina l'ULTIMA BARRA
M1 INCLUSA** (`ABTG_MaxMinNotte.mq5:301-320`, `count = |iS-iE| + 1` su
`iBarShift(...)`; lo scavalco di mezzanotte c'e' ed e' corretto).

> **00:00–08:00 IT** = fino alle 07:59:59 IT comprese = fino alle **06:59:59
> server** = `InpBoxStartHour=23 / StartMin=0 / **InpBoxEndHour=6** / EndMin=59`.

E non e' una deduzione: **il file che aveva gia' la risposta stava nella
stessa cartella** e concorda (`prove/…` r.120-121: *"BCM: 4:59 = 05:59 CET"*).
📌 Questa e' la classe del 10/09 — *"prima si cerca il file che ha gia' la
risposta"* — e stavolta e' stata applicata.

⚙️ **E il 7 e' escluso anche meccanicamente**: i pendenti si piazzano alle
**07:59 server** (`InpPlaceHour=7`/`InpPlaceMin=59`, r.126-127). Con
`EndHour=7/EndMin=59` la barra di fine scatola sarebbe **quella in
formazione** al momento del piazzamento: cella non deterministica. Fuori
dalla griglia, dichiarato.

---

## 3. ⛔ LA MISURA D'ARCHIVIO: gruppi confrontabili = **ZERO**

Dichiarato **prima** dei numeri. Le 526 righe ci sono (61 CSV), ma **non
contengono un confronto**:
- **nessuno dei 61 CSV** contiene due valori diversi della coppia
  `(InpBoxEndHour, InpBoxEndMin)`;
- a parita' di EA + simbolo + finestra + **tutte** le altre `Inp*`:
  **0 gruppi** con piu' di un valore di fine scatola.

La manopola e' **confusa al 100%** con altre due:

| `InpBoxEndHour` | `InpBoxStartHour` | passate | simboli |
|---|---|---:|---|
| **4** (`EndMin=59`) | 23 / 22 | 414 | D30EUR 154, 100GBP 72, E50EUR 72, F40EUR 72, EURUSD 4, +40 di un ALTRO EA |
| **6** (`EndMin=59`) | 22 | 112 | **XAUUSD e basta** |

> 🪦 **Verdetto: NON PRONUNCIATO** — e per la ragione giusta. L'asse non e'
> "provato con esito debole": **non e' mai stato girato**. Casella chiusa,
> non casella vuota. Secondo il certificato di morte del 09/09, un verdetto
> qui sarebbe stato abusivo.

---

## 4. 🧪 IL CONTRO-ESEMPIO — e ne e' uscito uno piu' grosso del previsto

Il numero cieco che un lettore frettoloso userebbe:

```
aggregato end=4 : 374 passate, Trades mediana 87,0, PF mediana 0,610
aggregato end=6 : 112 passate, Trades mediana 82,5, PF mediana 1,314
```

*"La scatola lunga raddoppia il PF!"* — **falso**. E il bello e' che
**l'ipotesi alternativa che avevo previsto non e' nemmeno quella che spiega
il dato**: pensavo *"scatola piu' larga -> meno rotture -> meno n -> PF
gonfiato"*, e invece **gli n sono uguali** (87,0 contro 82,5).

🔴 **Il confondente vero e' il SIMBOLO.** Le 112 passate a `end=6` sono
**tutte oro**; le 374 a `end=4` sono in maggioranza FTSE/CAC/Stoxx, cioe' i
tre simboli che `REGISTRO_TEST.md:456-458` dichiara **morti** su questo
motore (PF max 0,67 / ~1,0 / 0,59). **Quel 1,314 e' l'oro, non la scatola.**

### 📐 E il rumore, per una volta, e' MISURATO
`InpBufferPoints` fa la stessa identica cosa (allontana i livelli, taglia le
rotture) ed **e' stato girato davvero**
(`risultati_archivio/MaxMinNotte/valid_MaxMin_DAX_short_refine.csv`, D30EUR
short):

```
buf  700 / ATR 1,5 -> n 103  PF 0,9549      buf 1300 / ATR 1,5 -> n 102  PF 1,1756
buf 1000 / ATR 1,5 -> n 107  PF 1,1874      buf 1300 / ATR 2,0 -> n  96  PF 0,9475
buf 1000 / ATR 2,0 -> n 104  PF 1,2484      buf 1300 / ATR 2,5 -> n  96  PF 1,2295
```

Due cose che valgono oro:
1. allargare i livelli del **90%** (7 -> 13 punti indice) taglia `n` solo del
   **10%** e **non** alza il PF in modo sistematico: su questo motore la leva
   "meno rotture" e' **debole**;
2. 📏 **il rumore ha un numero**: due celle con lo **stesso n=96**, stesso
   simbolo, stessa finestra, differiscono di **0,282 di PF** solo cambiando
   il moltiplicatore ATR. 👉 **A n~100 qui, sotto 0,28 di PF non c'e'
   segnale.** Questa soglia e' congelata dentro il file prova, **prima** dei
   numeri.

---

## 5. ✅ IL FILE PROVA: `prove/R134a_scatolanotte_D30EUR.txt`

| | |
|---|---|
| asse | `InpBoxEndHour` -> celle **3, 4, 5, 6** (= 00:00–04:59:59 / 05:59:59 / 06:59:59 / **07:59:59 IT, la scatola di Claudio**) |
| magic | **779680**, vergine (cercato su tutto il repo, `.git` escluso) |
| modello | **4 = tick reali** |
| costo | **8 passate, 1,1–1,3 minuti** — calibrato su tre round della stessa taglia (`r88_csv/REFERTO_R88.txt:12-14`), non a memoria |
| cancello | `controlla_prova.py` **PASS** (`celle=4`), **ASCII puro** |

🧪 **Il contro-esempio e' DENTRO la griglia**: la cella **3** e' piu' corta
della viva e sta li' **apposta per farsi rompere**. Se la curva e' monotona
anche da 3 a 4, la manopola sta solo facendo il lavoro del buffer — e il
verdetto sara' **"non dimostrato"**, non "meglio".

🔒 **E il limite e' congelato prima**: nessuna cella potra' promuovere niente.
A ~1 operazione ogni 4-5 giorni su un lato solo, e coi tick BCM dal
2024.09.26, viene **n < 60 per finestra**. Merito **sospeso per
costruzione**; le due sole vie per arrivare a 150 sono nominate nel file coi
loro costi.

---

## 6. 🕳️ BUCHI DICHIARATI

1. 🔴 **Il fuso e' misurato SOLO in agosto** (`report/METRO_PROP.md:510`:
   *"BCM = italiana − 1 = UTC+1 in agosto"*). Se BCM segue l'ora legale
   europea, **d'inverno lo scarto non e' 1 ora** e una scatola scritta in ora
   server scivola di un'ora rispetto all'indicatore di Claudio **per mezzo
   anno**. Su un motore che vive di una finestra oraria non e' un dettaglio.
   **[NON MISURATO]** — si chiude con una sonda sul feed, non con un
   ragionamento. ⚠️ La *forma* della curva che R134a misura non ne dipende;
   l'etichetta *"questa e' la scatola di Claudio"* **si'**.
2. La scatola della sedia oro 770402 (par. 1) va misurata: e' un round in
   piu', non incluso in R134a (simbolo diverso).

---

*Misura prodotta dall'agente `cercatore-parametri`, verificata alla fonte e
messa a verbale nella sessione principale. Il file prova e' committato.*
