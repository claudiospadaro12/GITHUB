# 🔬 R123 BLOCCO B — **COSA AGGIUNGE LA RICOSTRUZIONE DA ZERO** (e cosa NO)

**12/09/2026.** Il cancello, chiudendo il blocco D, ha consigliato di rifare su
B e C la stessa ricostruzione dai CSV grezzi — *"visto com'e' andata qui"*.
Fatto su **B**. Questo **non e' un nuovo referto del blocco B**: quello esiste
(`report/R123_RISULTATI_2026-09-09.md`) ed e' gia' stato **corretto** dall'errata
del 12/09 su A4 e A7. Qui sta **solo cio' che la ricostruzione AGGIUNGE**.

🪞 **Le due lezioni di stamattina, applicate PRIMA di toccare un numero:**
- **classe 258** — file prova aperto per primo: `R123b_U30USD_01_stmult.txt`,
  criteri A1-A8 e **attesa cella per cella** alle righe 140-190;
- **classe 269** — cercato **chi aveva gia' letto questi CSV**. ⚠️ **Il primo
  censimento ne aveva trovati tre; sono CINQUE**, e quello mancante e' il piu'
  diretto: `backtest_pipeline/risultati_prove/r123/REFERTO_ROUND_R123BSTMULT.txt`
  — il **referto di round scritto dalla RIGA DI LANCIO** (09/09 18:50, pin
  `7cd7b27e`, `modello: 4`), che stampa **gia' tutti e 40 i numeri**. ⚠️ **Non
  lo scrive il driver**: `grep REFERTO_ROUND walkforward_generico.ps1` da'
  **zero** — lo scrivono `RIGA_ROUND_VPS.ps1` e sorelle. 🟢 Per me e' una buona
  notizia: e' la **conferma indipendente** della ricostruzione. Gli altri
  quattro: `R123_RISULTATI_2026-09-09.md`, `ROUND_ALTOPIANO_SUPREV_2026-09-09.md`,
  `IL_WIP_E_DIAGNOSTICA_2026-09-12.md`, `MANOPOLE_INERTI_v2_2026-09-12.md`.
  **Quello che dicono gia', qui non lo rivendico** — e la regola 1 della classe
  269 (*cercare in `report/` e `risultati_archivio/`*) **ha un buco: il lettore
  piu' diretto stava in `risultati_prove/`**.
- E il **magic riletto dal CSV**: **784110** _(il blocco C e' 784120, il D
  784130: tre magic diversi per tre blocchi — copiarlo dal referto accanto e'
  proprio l'errore pagato stamattina)_.

> 🚫 **PERIMETRO**: si legge e basta. Nessun EA, preset, sedia o backtest.

---

## ✅ Cosa CONFERMA (e che era gia' scritto — nessun merito mio)

I 40 numeri rifatti da zero **tornano tutti**. `A1` fallita (una sola cella
ammessa, `3,5`). `A3` **zero cloni**. `A8` centrata **2 volte su 3** da
`StMult 4,5` — ma **questo il referto del 09/09 lo dice gia'** (riga 74 in
tabella e riga 80: *"la regola asimmetrica congelata prima fa il suo
mestiere"*). E `A4`/`A7` sono gia' nell'errata del 12/09.

---

## 🆕 QUELLO CHE LA RICOSTRUZIONE AGGIUNGE

### 1. 📉 **L'ANELLO ROTTO E' IL *PASSO 2* — e la sua dispersione si misura su CINQUE celle**

Il file prova (r.140-160) aveva costruito una **stima derivata** del PF OOS in
due passi: **PASSO 1** da OHLC a tick (banda misurata su 8 coppie, +0,054 a
+0,157) e **PASSO 2** da periodo intero a OOS (rapporto **1,202**). E aveva
dichiarato il proprio punto debole:

> *"Questo rapporto e' misurato su **UNA cella sola**. E' **l'anello debole
> della catena** e va detto: **se le altre celle hanno un'asimmetria IS/OOS
> diversa, la stima sbaglia**."*

🎯 **E la meta' che avevo troncato nella prima stesura e' esattamente quella che
i numeri di oggi dimostrano**: la tabella `0,859 - 1,223` piu' sotto **e'** la
misura di quell'asimmetria diversa cella per cella. La profezia, citata per
intero, vale il doppio del troncone.

| StMult | PF OOS **atteso** | **misurato** | scarto | anelli usati |
|---|---|---|---|---|
| 2,5 | ~**1,18** [1,11-1,24] | **0,91405** | **−0,266** | 🔴 **DUE** (OHLC→tick, poi ×1,202) |
| 3,0 | ~**1,25** | **0,95320** | **−0,297** | 🔴 **UNO** (base a tick misurata, solo ×1,202) |
| 3,5 | **1,43648** | **1,38944** | −0,047 | ✅ **nessuno**: e' l'**ancora**, la sentinella S2 |

🎯 **E la colpa si localizza**: `3,0` **non ha mai usato il PASSO 1** — partiva da
un numero a tick gia' misurato — ed e' quella che sbaglia **di piu'**. Quindi
**non e' la conversione OHLC→tick a rompersi: e' il rapporto 1,202.**

#### 🔬 E il PASSO 2 si puo' MISURARE su tutte e cinque le celle, dai CSV di oggi

Il PF di periodo intero e' ricavabile esattamente da Profit e PF
(`GL = Profit/(PF−1)`, `GP = PF·GL`, e il PF dell'unione e' la **mediante**):

| StMult | PF IS | PF OOS | PF unione | **rapporto OOS/intero** |
|---|---|---|---|---|
| 2,5 | 0,87674 | 0,91405 | 0,89785 | 1,018 |
| 3,0 | 1,08369 | 0,95320 | 0,99619 | **0,957** |
| 3,5 | 0,98837 | 1,38944 | 1,20662 | **1,152** |
| 4,0 | 0,72133 | 1,09271 | 0,89342 | 1,223 |
| 4,5 | 2,01707 | 1,41820 | 1,65142 | **0,859** |

➡️ **Il 1,202 assunto sta al BORDO ALTO di una banda misurata `0,859 - 1,223`.**
E l'ancora stessa, ricalibrata sulla cella viva col **binario di oggi**, vale
**1,152**, non 1,202.

⚠️ `4,0` e `4,5` hanno **n OOS sotto 150**: entrano qui **solo come aritmetica
sul metodo**, mai a favore di A1 _(soglia A2, non sfiorata)_.

⚠️ **E i test indipendenti della catena sono DUE, non tre** (`3,5` e' il punto di
calibrazione). La regola di metodo qui sotto nasce da **n=2 sugli scarti** e da
**n=5 sulla dispersione del PASSO 2**: si dichiara, non si nasconde.

#### 🎁 E i test indipendenti sono QUATTRO, non due — i due in piu' erano gia' nel repo

Il **blocco C** usa **la stessa catena** (`R123c...txt` r.128-152). Le sue due
celle stimate, confrontate coi CSV di C _(punti segnalati dal cancello, numeri
riverificati da me sul file prova e sui CSV)_:

| cella | atteso | misurato | scarto | anelli |
|---|---|---|---|---|
| `C · AtrP 8` | ~1,09 [1,03-1,16] | **1,16409** | **+0,074** | **DUE** (solo OHLC 1,015 come base) |
| `C · AtrP 10` | ~0,85 | **0,61023** | **−0,240** | **UNO** (base tick **0,706** × 1,202 = 0,849) |

➡️ **E la localizzazione sul PASSO 2 si irrobustisce invece di diluirsi:**

| | casi | esito |
|---|---|---|
| **solo PASSO 2** | `B 3,0` −0,297 · `C AtrP 10` −0,240 | 🔴 **2 su 2, tutti e due OTTIMISTI, un quarto di punto** |
| **due anelli** | `B 2,5` −0,266 · `C AtrP 8` **+0,074** | ⚪ **segni OPPOSTI** — e `AtrP 8` cade **dentro** la sua banda dichiarata |

👉 **La regola, con la sua base:** quella catena — e in particolare il **PASSO 2
calibrato su una cella sola** — va usata per **DIMENSIONARE, mai per DECIDERE**,
e chi la usa scrive la banda **±0,3**, non ±0,1. **Base: n=4 sugli scarti**
(due per R123b, due per R123c) **e n=5 sulla dispersione del PASSO 2.**

✅ **E una preoccupazione e' stata CHIUSA**: il letterale `1,202` fuori da
`ROUND_ALTOPIANO_SUPREV` **non esiste**, e il metodo compare in **cinque file
soli** — i due file prova, il piano del round, questo referto, e
`R135a_U30USD_atrperiod_oltre12.txt`, che e' **RITIRATO** (*"NON METTERE IN
CODA, NON LANCIARE"*). 👉 **La catena non ha mai stimato nessun motore fuori da
R123.** _(Misurato dal cancello, su mia richiesta: era la cosa che mi
preoccupava di piu'.)_

_(⚠️ **Classe 269, e stavolta morde me**: che la stima fosse fallita su `2,5` e
`3,0` **e' gia' scritto** in `R123_RISULTATI` r.103-105, coi due numeri. Qui e'
nuova la **quantificazione contro le attese cella per cella**, la separazione
**STIMATO/MISURATO**, la **localizzazione sul PASSO 2** e la **banda misurata su
cinque celle** — non il fallimento.)_

### 2. ⚖️ **Sul CAMPIONE la stima ha tenuto MEGLIO — ma non "cinque su cinque"**

| StMult | n OOS atteso | misurato | scarto | com'era ottenuto |
|---|---|---|---|---|
| 2,5 | ~252 | **261** | +3,6% | 🔴 STIMATO |
| 3,0 | ~198 | **200** | +1,0% | 🔴 STIMATO |
| 3,5 | 155 | **152** | −1,9% | ✅ **MISURATO**: e' la sentinella S2 |
| 4,0 | ~121 | **112** | −7,4% | 🔴 STIMATO |
| 4,5 | ~94 | **117** | **+24,5%** | 🔴 STIMATO |

⚠️ **Le previsioni vere sono QUATTRO, non cinque**: il `155` di `3,5` e' il
numero d'archivio e — per la stessa disciplina di §1 — **non puo' contare come
previsione**. Quindi: **due su quattro entro il 5%**, una al 7,4%, e **`4,5`
sbaglia di un quarto**.

🔴 **E la conclusione NON e' "ottima sul campione".** In termini **relativi** gli
errori sul PF (−22,5% e −23,7%) sono **della stessa taglia** dell'errore su
`4,5` (+24,5%). Cio' che separa le due meta' **non e' la dimensione dell'errore,
e' la CONSEGUENZA**: un `n` sbagliato del 10% non sposta nessuna decisione; un
PF sbagliato di **0,28** sposta una cella da *"passa 1,20"* a *"sotto 1,00"*.

### 3. 🛑 **IL RAMO "ERA RUMORE" E' SCATTATO — ma la premessa NON E' MAI STATA MISURATA**

Il file prova aveva dichiarato **prima dei numeri**:

> *"SE ERA RUMORE mi aspetto **3.0 sotto 1.05** — il che **contraddirebbe** il
> suo numero a tick di periodo intero (**1.040 con l'IS rosso dentro**) e
> **sarebbe gia' di per se' una scoperta**."*

**Misurato: `StMult 3,0` fa PF OOS 0,95320 → il ramo e' scattato.**

🔴 **Ma la premessa non regge, e per due motivi diversi:**

```
1,040 = periodo intero, a tick, ARCHIVIO 26/07         <- BINARIO DEL 08/08
        (valid_SupRevRT_U30USD_H1_realtick.csv, cella 3.0 / AtrP 9 / TP_RR 3.0, n 346)
StMult 3,0  IS : +108,26  PF 1,08369  n 144            <- BINARIO DI OGGI
            OOS: -123,22  PF 0,95320  n 200            <- BINARIO DI OGGI
```

**(a) Di quel 1,040 non esiste da nessuna parte una scomposizione IS/OOS**:
prima di R123 la cella `3,0` non era mai stata girata con split (file prova
r.108-110, *"mai con split IS/OOS su U30USD"*). **L'"IS rosso dentro" era
EREDITATO dalla cella viva, non misurato su questa.** Non si puo' contraddire
una premessa mai misurata.

**(b) E il confronto con l'archivio era gia' stato dichiarato MORTO.** File
prova r.278-281: *"la sentinella **S2** NON e' un cancello di validita' del
round. Se fallisce, il round resta leggibile ma **muore il confronto con
l'archivio, e il referto deve dirlo forte**."*
🔴 **S2 E' FALLITA, e proprio sul PF IS**: `0,92343 → 0,98837`, **+0,065**
contro tolleranza **±0,05** (`R123_RISULTATI` r.46). **Quindi 1,040 e 1,08369
non sono dello stesso banco**, e questo referto lo dice forte come era stato
chiesto.

✅ **La conclusione — nessuna scoperta da incassare — regge lo stesso, e regge
MEGLIO**, perche' ora c'e' anche l'argomento aritmetico: il PF dell'unione e'
`gross profit / gross loss`, cioe' la **MEDIANTE** di due frazioni, e una
mediante **sta SEMPRE fra le due**. Con l'IS **sopra** 1,040, un periodo intero
a 1,040 **OBBLIGA** l'OOS a stare **sotto**. ➡️ **Un OOS a 0,953 non e' una
sorpresa da spiegare: e' cio' che il 1,040 richiede.**

🔎 **E il contro-esempio, costruito apposta perche' questa conclusione sbagli:**
trasponendo l'unico scarto di binario misurato (+0,065), l'IS vecchio di `3,0`
sarebbe **~1,019** — ancora verde, ma con un margine **quattro volte piu'
sottile** di come l'avevo presentato. E l'unione calcolata dai numeri **di
OGGI** vale **0,99619**, non 1,040: lo scarto di binario **non e' uniforme fra
le celle**.

> 🔎 **E qui il contro-esempio morde davvero, piu' di quanto avessi visto**:
> **1,019 sta SOTTO 1,040.** Nella trasposizione la condizione della mediante
> **non regge nemmeno**, e la mediante pretenderebbe un OOS **sopra** 1,040 —
> l'opposto di quello che serve. 🔴 **Le due letture del 1,040 sono
> incompatibili fra loro**: e' questo, piu' di tutto il resto, che rende quella
> scomposizione **[NON RECUPERABILE]** — non semplicemente *"non misurata"*.

_(Nella prima stesura avevo scritto *"l'IS non e' rosso: e' VERDE"* come se
fosse un fatto acquisito. E' il difetto che il cancello ha nominato meglio di
me: **nei due punti in cui il risultato mi dava ragione avevo smesso di provare
a rompermi.**)_

---

## 🚦 Cosa cambia nel verdetto di R123

**Niente.** `A6` — *"non c'e' una configurazione robusta"* — regge, e reggeva
gia'. Questa ricostruzione **non riapre il blocco B**: aggiunge un fatto di
**metodo** (la catena di stima) e **toglie** un bonus mai guadagnato.

⚠️ **E una cosa NON l'ho fatta**: la stessa ricostruzione da zero sul **blocco C**.
Li' i 56 numeri sono gia' stati rifatti **tre volte** (due da me, una dal
cancello) e l'attesa e' gia' confrontata nel suo referto — ma **l'attesa di C
non e' stata esaminata con questa lente**, cioe' chiedendosi *quali celle erano
STIMATE e quali MISURATE*. Resta aperto, dichiarato, e costa poco.

## 📎 Fonti

- CSV: `backtest_pipeline/risultati_prove/r123_dal_vps/..._{IS,OOS}_R123BSTMULT.csv`
- File prova: `backtest_pipeline/prove/R123b_U30USD_01_stmult.txt` (attesa r.140-190, criteri r.193-237)
- Referto del blocco B: `report/R123_RISULTATI_2026-09-09.md` + **errata del 12/09** su A4 e A7
- Blocchi C e D: `R123_BLOCCO_C_2026-09-12.md` · `R123_BLOCCO_D_2026-09-12.md`
