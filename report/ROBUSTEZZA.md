# 🧱 "EA CHE SI ADATTANO A QUALSIASI MERCATO" — perche' NON e' la strada

_15/08/2026. Claudio: "dobbiamo avere degli expert che sono in grado di
adattarsi a qualsiasi tipo di mercato, robusti e solidi."_

**Sull'obiettivo siamo d'accordo: robusti e solidi.** Sulla parola
**"adattarsi"** no, e non per opinione: per i **30 ribaltamenti** che abbiamo
misurato noi.

---

## 1. Il conto dei ribaltamenti e' il documento piu' importante del progetto

Un "ribaltamento" e' una configurazione che vince **in campione** e perde
**fuori campione**. Ne abbiamo contati **trenta**. Ogni volta che abbiamo
provato a rendere un EA piu' intelligente, piu' reattivo, piu' adatto, e'
successo questo:

| round | cosa avevamo aggiunto | in campione | fuori campione |
|---|---|---|---|
| **R46** | struttura "TP 3R secco" sul DAX | **la MIGLIORE**: +48.904, PF 1,54 | **la PEGGIORE**: −14.343, PF 0,88, DD 22,5% |
| **R44** | target 2x/3x sul Dow | PF 1,66 → **1,955** (+64%) | DD 9,92% → **10,8-11%**: cancello bocciato |
| **R54** | il lato short del Dow | promettente | **PF 0,840** su 73 trade |
| **R45** | ORB su sessione di Londra | — | **zero celle verdi su 48** |
| **R51** | la cella di riserva | — | peggior giornata **da −1,07% a −2,06%** |
| **R49** | Easy Trend in portafoglio | promossa da sola | **alza TUTTE le code** |

> 🔥 **Il numero che riassume tutto: 63.000 euro.** Tanto separa le due
> finestre della **stessa identica ricetta** in R46. Non due strategie
> diverse: la stessa, guardata su due periodi.

**Trenta volte** la versione "piu' adatta" si e' rivelata adatta **solo al
passato che aveva visto**.

## 2. Perche' "adattivo" e "robusto" sono in CONFLITTO, non alleati

Un EA che si adatta e' un EA con **piu' parametri**: una soglia di volatilita',
un filtro di regime, un moltiplicatore che cambia col mercato.

**Ogni parametro in piu' e' una manopola che il backtest gira verso il
passato.** Piu' manopole = piu' modi di sembrare bravi su dati gia' visti =
meno tenuta su dati nuovi. Non e' una teoria: e' la meccanica dei nostri 30
ribaltamenti, uno per uno.

E abbiamo gia' la frase scolpita in un referto, R45:

> _"un filtro non salva un motore morto, per l'ennesima volta"_

## 3. ✅ Cosa produce robustezza secondo i NOSTRI dati

### A. Poche regole, pochi parametri
Le sedie che reggono in forward sono le piu' stupide. Il DAX Apertura fa **un
trade al giorno, alla campanella, su un lato solo**, e ha win rate **81,0%**
con payoff 0,327.

### B. Il centro dell'altopiano, mai la cella migliore
Regola congelata da sempre. La cella migliore e' quella che ha avuto **piu'
fortuna**; il centro dell'altopiano e' quella che resta buona **anche se il
mercato si sposta di un po'**. E' l'unica forma di "adattivita'" che funziona:
**non nel codice, nella scelta**.

### C. 🎯 LA ROBUSTEZZA STA NEL PORTAFOGLIO, NON NEL SINGOLO EA
E' il punto che conta piu' di tutti. Un EA da solo non puo' andare bene in
ogni mercato — **ma un portafoglio di regole semplici e scorrelate si'**,
perche' quando una soffre un'altra lavora.

Per questo lo standard di ammissione e' **"aggiunge profitto E abbassa le
code"**, ed e' successo **quattro volte in tutto il progetto**. Quattro. E'
severo apposta: e' la severita' che tiene in piedi il portafoglio a 27 serie
con **DD 5,50%** e p99 12,47%.

### D. Il verdetto dei 15 trade
Nessuna famiglia si giudica prima. E' la difesa contro il rumore.

## 4. 🚀 E la notizia di oggi: lo strumento che chiedi tu, l'abbiamo appena costruito

**La prova di regime non rende gli EA adattivi: misura quali lo sono gia'.**

Oggi abbiamo verificato che **Dukascopy ha gli indici dal 2012** — DAX,
Nasdaq, S&P, FTSE, CAC, Stoxx — e che **il Dow c'e'** (`USA30IDXUSD`, 49.445
byte). Sono **quattordici anni** e almeno **quattro regimi**:

| regime | anno |
|---|---|
| crollo Covid | 2020 |
| orso + inflazione | 2022 |
| Volmageddon / Q4 storto | 2018 |
| svalutazione yuan | 2015 |

Contro i **21 mesi e un solo regime** di BCM.

**I criteri sono congelati dal 14/08** (`backtest_pipeline/prove/PROVA_REGIME_CRITERI.md`),
e la regola numero uno di quel documento e' esattamente la risposta a questa
domanda:

> _"Si testano le celle GIA' PROMOSSE, esattamente come sono: parametri
> **CONGELATI**, nessuna ottimizzazione, nessuna griglia. **Vietato** cercare
> parametri nuovi sui dati vecchi: sarebbe overfitting su una finestra piu'
> lunga, cioe' lo stesso errore con piu' anni."_

## 5. 🧭 La strada, in una riga

> **Non "rendiamoli adattivi": vediamo chi sopravvive al 2020 e al 2022
> SENZA toccare un parametro.**

- Chi passa **e' robusto — dimostrato, non sperato**.
- Chi non passa esce, o resta a taglia ridotta con l'avvertenza scritta.
- Chi non ha abbastanza dati resta in vivaio.

E' meno eccitante di un EA che "capisce il mercato". Ma e' l'unica versione
di questa frase che, nel nostro progetto, non e' stata ribaltata trenta volte.

---

### ⚠️ Cosa NON sto dicendo

Non sto dicendo che ogni idea nuova sia overfitting. Sto dicendo che **il
posto giusto dove metterla e' un round con la sua tesi e i suoi criteri
scritti prima**, come abbiamo fatto 55 volte. Se un'idea adattiva passa un
walk-forward con i cancelli congelati **e** la prova di regime, entra. Le
regole non cambiano per l'entusiasmo, e non cambiano nemmeno per la prudenza.


---

# 🔄 PRECISAZIONE DI CLAUDIO — e una correzione a quanto ho scritto sopra

_15/08/2026: "adattarsi intendo che se il mercato va long o short o laterale,
i nostri EA devono capire il mercato e quindi entrare o non entrare."_

Questa e' una cosa **diversa e molto piu' precisa** di "EA adattivo": e' un
**filtro di direzione/regime**. Ed e' testabile — anzi, **l'abbiamo gia'
testata parecchie volte**. I risultati si dividono in due gruppi netti, e la
riga di separazione **non e' quella che avevo scritto sopra**.

## A. ❌ Filtro APPICCICATO a un motore gia' tarato: 0 successi su 5

| round | il filtro | esito |
|---|---|---|
| **R20** GBPUSD | **ADX 25** — il filtro canonico "trend o laterale" | unica cella IS verde (**PF 1,46**) = **la PEGGIORE OOS** (PF 1,08) |
| **R12** Nasdaq | EMA200 + volumi sull'ORB, 48 celle | **tutte e 48 negative OOS**. Con EMA200 l'IS migliora (−1.306 → −299) e l'**OOS resta rossa**. 12o ribaltamento |
| **R26** DAX | filtro volumi | baseline OOS **+1.811**; col filtro **+1.649 / +893 / +1.138** → **0 su 3**, non si adotta |
| **R45** ORB Londra | filtro volumi | _"attenua ma non inverte mai"_ |
| **R54** Dow | il lato short ("se scende, vendi") | **PF OOS 0,840** su 73 trade, bocciato |

> 🔍 **R26 e' il piu' istruttivo di tutti.** Alla soglia 1,8 il filtro fa
> **salire il PF a 2,37** e **scendere il DD a 2,59%** — sembra un trionfo. Ma
> il **profitto crolla da 1.811 a 1.138**, perche' i trade passano da 270 a 62.
> **Il filtro migliora la qualita' dei trade e peggiora il conto**: taglia piu'
> vincitori che perdenti. Un filtro che "capisce il mercato" **sembra** sempre
> bravo se lo guardi col PF.

## B. ✅ Filtro che E' IL MOTORE, nato con lui e validato dall'inizio: il nostro miglior risultato di sempre

**`ABTG_EMA200` sul Dow** e' esattamente questo: **entra solo dalla parte in
cui sta il mercato rispetto alla media a 200**. Cioe' letteralmente _"capire
se va long o short, e quindi entrare o non entrare"_.

**R29 — walk-forward:**
> **30 celle su 30 a PASS PIENO.** PF OOS da **1,44 a 1,61** (nemmeno una sotto
> 1,10). DD OOS **5,97-8,50%** (nemmeno una sopra 10). 400-500 trade OOS per
> cella. **_"Mai, in 29 round, una regione intera aveva superato il cancello."_**

**R31 — in portafoglio (la SEDIA 12):**

| | 11 serie | **12 serie** |
|---|---|---|
| Netto OOS | +102.933 | **+126.255 (+23%)** |
| MAX DD storico | 10,08% | **9,50% — SCESO** |
| MC p99 | 14,79 | **14,45 — giu'** |

> _"Prima volta che un ingresso abbassa il DD storico E le code MC mentre
> aggiunge il 23% di profitto."_

## ✍️ La correzione che devo a Claudio

Sopra avevo scritto che "adattivo e robusto sono in conflitto". **Detta cosi'
e' troppo larga, e i nostri dati la smentiscono**: l'EMA200 e' un filtro di
direzione, ed e' una delle nostre sedie migliori.

**La riga di separazione vera non e' "filtro si' / filtro no". E' questa:**

| | esito |
|---|---|
| Filtro **aggiunto dopo** a un motore gia' tarato | **0 su 5**. Aggiunge un parametro, taglia trade, e fuori campione perde |
| Filtro che **E' la strategia**, con i suoi cancelli fin dall'inizio | **puo' essere il migliore in assoluto** (R29: 30/30) |

**Non e' l'idea a essere sbagliata: e' il momento in cui la si aggiunge.**

## 🌍 E la prova di regime dice una terza cosa, ancora piu' importante

R50 ha misurato **8 celle congelate su 4 regimi veri**. Guarda cosa esce:

| cella | ORSO 2022 | CROLLO 2020 | TORO 2021 | LATERALE 2019 |
|---|---|---|---|---|
| **PTE_GBPUSD** | +1.245 | +70 | +1.362 | +5.284 |
| **LARRY_GBPUSD** | +1.587 | **−708** | +4.095 | **−6.445** |
| **BB_EURUSD** | +932 | +502 | **−1.561** | **−2.381** |

- **PTE e' positivo in TUTTI E QUATTRO i regimi** — senza nessun filtro di
  regime. E' gia' robusto: non gliel'ha insegnato nessuno, ce l'ha nella
  meccanica.
- **LARRY muore nel laterale** (−6.445) e **BB muore nel toro** (−1.561)... ma
  **BB regge dove Larry crolla** (crollo 2020: +502 contro −708).

> 🎯 **"Capire il mercato" non lo fa il singolo EA: lo fa il PORTAFOGLIO**,
> tenendo insieme motori che vivono in regimi diversi. E questo non e' una
> teoria: sono i numeri di R50.

## 🧭 Quindi, in pratica

1. **Non aggiungiamo filtri di regime alle sedie vive.** Cinque tentativi su
   cinque hanno perso OOS, e le sedie vive sono collaudate.
2. **Se vuoi un EA che legge la direzione, si costruisce come motore nuovo**,
   con la sua tesi e i suoi cancelli — come e' nato l'EMA200. **Quella strada
   e' aperta e ha gia' dato il miglior risultato del progetto.**
3. **La prova di regime dice CHI COPRE COSA**: e' la mappa che serve per
   scegliere la prossima sedia. Oggi ce l'abbiamo solo sul forex (R50); con
   Dukascopy 2012 la avremo **sugli indici**, dove stanno le sedie grosse.
