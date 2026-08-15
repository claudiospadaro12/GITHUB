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
