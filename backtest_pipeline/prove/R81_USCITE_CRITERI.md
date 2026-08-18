# R81 — PROCESSO ALLE USCITE, capitolo `MaxMin DAX Short`

**Criteri congelati il 18/08/2026, PRIMA di qualunque numero.**
Round firmato da Claudio in chat ("si" al round + "preparami la stringa").

---

## 1. 🎯 LA DOMANDA, una sola

> **A PARITA' DI INGRESSI, la gestione attuale della sedia viva estrae piu'
> valore delle alternative?**

Nasce da un fatto, non da un'idea: il 18/08 la sedia `MAXMIN DAX SHORT`
(magic 770411, copia 100k a rischio 0,65%) ha chiuso **+324,48 EUR** e il
**trailing ha incassato prima di un rimbalzo che avrebbe riportato il prezzo
sopra l'ingresso**.

⚠️ **Quel trade e' un ANEDDOTO, e come tale entra qui**: e' la ragione per cui
si apre il round, **non** una prova di niente. Non e' agli atti in nessun
referto: e' riportato da Claudio in chat il 18/08. Un round si apre anche per
un aneddoto; **si chiude solo coi numeri**.

## 2. 🔒 COSA NON FA QUESTO ROUND

- **Non tocca il forward.** Nessuna sedia cambia, nessun `.chr` viene
  riscritto, nessun magic vivo viene toccato. Se una variante vince, **fa la
  trafila della candidata** (come la PTE B25: si valuta, si firma, si mette in
  duello) — non entra in campo da questo referto.
- **Non tocca il codice dell'EA.** Le sei varianti si fanno **SOLO con gli
  input esistenti** di `ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5` v1.10.
  Dove un input non basta, e' scritto qui sotto come si e' aggirato **e a che
  prezzo** (§4, nodo del breakeven; §5, nodo del TP secco).
- **Non ritara niente.** Le uscite non sono una griglia da spazzolare: sono
  **sei gestioni dichiarate**, ognuna con la sua logica scritta prima.

## 3. 🧬 LE SEI VARIANTI, input per input

Tutti gli altri input dell'EA sono **blindati al default del sorgente** dal
driver (`walkforward_generico.ps1`, §2 del suo codice): box notturno 23:00-4:59,
piazzamento 7:59, cutoff 8:30, flat 17:30, buffer 1000, **solo short**,
`SL = 2,5 x ATR(M15)`, **filtro correlazione S&P ON**, rischio **1,0%**.

**FONTE DEI VALORI PINNATI, dichiarata:**
1. **I default del sorgente** `mql5/Experts/ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5`
   (v1.10) — sono i valori "OTT" gia' commentati nel file (`InpAtrSLmult=2.5`
   "OTT DAX short real-tick", `InpBufferPoints=1000` "OTT DAX short",
   `InpUseCorrelation=true` "OTT: filtro correlazione S&P ON (chiave!)").
2. **Il censimento dei `.chr` del 18/08 09:41**
   (`risultati_archivio/censimento_rischio_2026-08-18_0941.txt`, righe 27 e
   48-49): la sedia gira a **`InpRiskPercent` 1,0** sul conto principale e
   **0,65** sulle due copie del dry-run 100k col Guardian. Il round gira a
   **1,0**, cioe' il default del sorgente **e** il valore del contratto
   (`report/CONTRATTI_SEDIE.md`: DD promesso 1,27% a rischio 1%). Gli euro
   della copia 0,65% si leggono moltiplicando per 0,65; le percentuali no.
3. **`FLOTTA_ATTIVA.md` riga 39**: grafico **D30EUR M15** → `@PERIODO M15`.
4. Il censimento dei `.chr` **non** registra gli altri input (registra solo il
   rischio): per tutto il resto la fonte e' il **sorgente**, ed e' dichiarato
   cosi'. Nessun valore e' stato scelto qui.

| input | **A** viva | **B** correre puro | **C** solo BE | **D** trail 3,5 | **E** trail 1,0 | **F** TP secco 2R |
|---|---:|---:|---:|---:|---:|---:|
| `InpTP1_R` | 1.0 | 1.0 *(inerte)* | 1.0 | 1.0 | 1.0 | 1.0 *(inerte)* |
| `InpTP1Pct` | **50** | **0** | **1** ⚠️ | 50 | 50 | **0** |
| `InpBreakeven` | **1** | **0** | **1** | 1 | 1 | **0** |
| `InpTP2_R` | 3.0 | 3.0 *(inerte)* | 3.0 *(inerte)* | 3.0 | 3.0 | 3.0 *(inerte)* |
| `InpTP2Pct` | **50** | **0** | **0** | 50 | 50 | **0** |
| `InpUseEMA200Target` | **1** | **0** | **0** | 1 | 1 | **0** |
| `InpTPfinal_R` | 4.0 | 4.0 | 4.0 | 4.0 | 4.0 | **2.0** ⚠️ |
| `InpUseTrailing` | **1** | **0** | **0** | 1 | 1 | **0** |
| `InpTrailAtrMult` | 2.0 | 2.0 *(inerte)* | 2.0 *(inerte)* | **3.5** | **1.0** | 2.0 *(inerte)* |
| `InpRiskPercent` | 1.0 | 1.0 | 1.0 | 1.0 | 1.0 | 1.0 |
| `InpMagic` (coppia) | 778110/11 | 778120/21 | 778130/31 | 778140/41 | 778150/51 | 778160/61 |

*"inerte" = il valore resta quello della sedia viva ma il codice non lo legge
mai in quella variante (il blocco che lo usa e' spento). E' scritto per tenere
i sei file DIFFABILI riga per riga: cambia solo cio' che deve cambiare.*

**Perche' i magic sono nuovi e sono in coppia:**
- il driver **pretende almeno un asse spazzolato** (`walkforward_generico.ps1`
  riga 372: "nessun parametro da spazzolare: sarebbe un backtest singolo"),
  e il magic e' l'unico asse **inerte sul risultato**: due passate che
  **DEVONO uscire identiche al centesimo**. Se differiscono, qualcosa e' rotto
  e il round non si legge. E' lo stesso trucco della FASE 0 di questo EA
  (`prove/ABTG_MaxMinNotte_DAX_Short_Ottimizzato.txt`).
- magic **mai usati prima** = **niente cache del tester** (il driver avvisa a
  riga 650: un pass ripescato dalla cache non riscrive i file per-trade) e
  **file per-trade separati per variante**.

## 4. ⚠️ IL NODO DEL BREAKEVEN — variante C, risolta e dichiarata

Il commento dell'input dice `InpBreakeven = true; // Stop in pari dopo la 1a
parziale`, e **il codice lo conferma**: lo stop in pari sta **DENTRO** il blocco
della prima parziale, che e' chiuso da questa condizione (`ManagePos`, riga 295):

```mql5
if(!gPart1 && InpTP1_R>0 && InpTP1Pct>0 && InpTP1Pct<100 && risk>0)
```

Con **`InpTP1Pct = 0` il blocco non viene MAI eseguito**: niente parziale **e
niente breakeven**. Quindi **"solo breakeven, zero parziale" NON e' realizzabile
in purezza** con gli input esistenti.

**Come si realizza C, dichiarato: `InpTP1Pct = 1`, parziale SIMBOLICA dell'1%.**
Motivo tecnico, riga per riga (righe 301-314):

```mql5
double cv=NormVol(vol*InpTP1Pct/100.0);
bool parzOK = (cv>0 && cv<vol && gTrade.PositionClosePartial(ticket,cv));
if(parzOK) gPart1=true;
...
bool beFatto = (InpBreakeven && (...lo stop in pari migliora lo stop...));
if(beFatto) gTrade.PositionModify(ticket,bePari,tp);
```

- il **breakeven non dipende da `parzOK`** (correzione del 07/08, documentata
  nel codice e in `report/BUG_BREAKEVEN_lotto_minimo.md`): scatta comunque.
- l'1% **contamina la misura di circa l'1% del lotto**, chiuso a 1R. E' una
  contaminazione **dichiarata e minuscola**, e va nella direzione di
  **avvantaggiare** C di un soffio: se C perde lo stesso contro A, il verdetto
  regge a maggior ragione.
- `InpTP2Pct = 0` in C **e' obbligatorio**: se la parziale dell'1% va a segno,
  `gPart1` diventa `true` e sbloccherebbe la seconda parziale (riga 321).
- ⚠️ Al deposito 100k il lotto e' molto sopra il minimo, quindi l'1% **si
  chiude davvero**. Se il lotto fosse < 1,00, `NormVol` arrotonderebbe a 0 e C
  diventerebbe "breakeven puro senza parziale" — **piu' pulita, non meno**.
  In entrambi i casi la variante e' leggibile; **quale dei due casi si e'
  verificato si legge nel file per-trade** (2 chiusure per posizione = parziale
  avvenuta, 1 sola = breakeven puro).

## 5. ⚠️ IL NODO DEL TP SECCO — variante F, come e' stata realizzata

La missione chiedeva `InpTP1_R=2.0` + `InpTP1Pct=100`. **Non e' realizzabile:**
la stessa condizione di riga 295 pretende **`InpTP1Pct < 100`**, quindi a 100
il blocco e' spento e **il TP a 2R non esisterebbe affatto** (si misurerebbe un
"lascia correre" travestito da TP secco — cioe' la variante B, due volte).

**Come si realizza F: `InpTPfinal_R = 2.0`**, cioe' il TP **sull'ordine stesso**,
piazzato alla creazione del pendente (righe 249-251, lato short):

```mql5
double dist=sl-sellPx;
double tp=NormalizePrice(sellPx-dist*InpTPfinal_R);
... gTrade.SellStop(lot,sellPx,_Symbol,sl,tp,...)
```

`dist` e' esattamente 1R (distanza ingresso-stop), quindi il TP e' a **2R esatti
dal prezzo del pendente**. Con tutto il resto spento, F esce **solo** per: TP 2R,
stop iniziale, o flat delle 17:30. **E' il TP secco vero**, ed e' piu' pulito
della ricetta originale.

## 6. 📏 IL METRO DI GIUDIZIO (dichiarato prima)

**Le finestre:** il driver spacca lo storico 40% IS / 60% OOS
(`2024.09.26 → 2026.06.30`, `-Fino` di casa). Qui **NON si sceglie niente
sull'IS**: ogni variante e' UNA cella congelata, non una griglia. Le due
finestre servono come **due sotto-periodi indipendenti** e valgono come
**controllo di coerenza**, non come selezione.

| corsia | metro | soglia dichiarata |
|---|---|---|
| **PROFITTO** | profitto netto della variante vs **A** | deve vincere **in TUTTE E DUE** le finestre. Vincere in una e perdere nell'altra = **niente** |
| **PF** | Profit Factor | in aiuto alla lettura; **non promuove da solo** |
| **RISCHIO** | `Equity DD %` | vale **a qualunque n** (valvola R59): una variante che alza il DD sopra il **DD promesso 1,27%** (contratto R16, rischio 1%) va dichiarata **anche se guadagna di piu'** |
| **CAMPIONE** | n | vedi §7: qui e' il vincolo che comanda |

🔴 **Clausola di segno** (congelata dopo R77, vale anche qui): **non si promuove
niente che perde. "Perde meno" non e' una promozione.** E la sua versione per
questo round: **una variante che batte A restando negativa non batte niente.**

🔴 **Test della singola operazione (obbligatorio prima di dire "vince").**
Con un campione di questa taglia, un solo trade sposta la classifica. Sulla
finestra dove abbiamo la serie per-trade (§8), si toglie **l'operazione migliore
della variante vincente**: se il vantaggio su A si annulla, **il round non ha
trovato niente** e va scritto cosi'.

## 7. 🚨 IL LIMITE PIU' GRANDE, detto ADESSO: IL CAMPIONE

La FASE 0 di questo EA ha misurato **20 "trades" IS e 21 OOS** su tutto lo
storico (`risultati_prove/ABTG_MaxMinNotte_DAX_Short_Ottimizzato/`), e
`report/CONTRATTI_SEDIE.md` avverte che **su questo EA il tester conta le
CHIUSURE PARZIALI**: le **posizioni** vere sono all'incirca **la meta'**
(~1,7 op/mese promesse).

Quindi, senza sconti:

- 📏 **L'emendamento della finestra (regola A) chiede >= 150 operazioni. Qui ne
  avremo ~20 per finestra, forse ~40 in tutto.** Siamo **un ordine di grandezza
  sotto**.
- ⚖️ **Regola B: il rischio si giudica lo stesso** (un drawdown e' un fatto
  accaduto), **il merito NO**. Con la valvola R59: n>=20 verdetto pieno,
  **8-19 sospeso sul merito**, <8 non misurato.
- 🎯 Percio' **questo round PROPONE, non promuove.** L'uscita massima possibile
  e': *"la variante X e' coerentemente meglio di A sui dati disponibili, con
  n=Y: candidata alla trafila"*. **Mai** *"la variante X e' migliore"*.
- 🔢 **Un conteggio gratis, da usare**: B, C e F **non parzializzano** (o
  quasi), quindi il loro numero di "trades" **e' il numero di POSIZIONI**. A,
  D ed E ne mostreranno di piu' perche' contano le parziali. **B e F devono
  avere lo STESSO numero di posizioni**: se non ce l'hanno, gli ingressi NON
  sono identici e il round e' invalido.

## 8. 🔬 LETTURA PER REGIME — e perche' qui NON si puo' fare

Le quattro finestre di casa (`prove/PROVA_REGIME_CRITERI.md` §3) sono
**ORSO 2022.01-2022.10 · CROLLO 2020.02-2020.04 · CROLLO_ANNO 2020 · TORO 2021
· LATERALE 2019**.

🛑 **Su `D30EUR` a BCM lo storico parte dal 2024.09.26** (misurato:
`scarica_storico.ps1`, e il valore e' gia' congelato in `prove/R2_MaxMinNotte_DAX_Short.txt`
come `@DAQUANDO`). **Tutte e cinque le finestre sono PRIMA dell'inizio dei
dati: la lettura per regime su questo EA NON ESISTE, e nessun numero verra'
inventato per riempirla.**

Il surrogato, dichiarato per quello che vale: **le due sotto-finestre IS/OOS**
(≈ set-2024→giu-2025 e giu-2025→giu-2026) sono **due pezzi dello stesso
regime**, non quattro regimi. Servono a vedere se una classifica **regge in due
periodi diversi**; non dicono niente su come queste uscite si comportino in un
orso o in un crollo. **Quel buco resta aperto** e va nominato nel referto
finale.

## 9. 🧪 IL CONTROLLO D'IGIENE CHE VIENE PRIMA DI TUTTO

La variante **A e' la sedia viva a parametri identici**, sullo stesso driver,
stesse date, stesso deposito (100k) dei CSV `_ptb` gia' agli atti:

| finestra | profitto | PF | Equity DD % | trades |
|---|---:|---:|---:|---:|
| IS `_ptb` | **+4.766,96** | 1,87803 | 3,0977 | 20 |
| OOS `_ptb` | **+6.143,38** | 2,15985 | 1,9213 | 21 |

🔴 **Se A non riproduce questi numeri, il round non si legge**: vuol dire che e'
cambiato qualcosa fra i due giri (dati, driver, pin) e la classifica sarebbe
costruita su sabbia. Si guarda **prima** questo, **poi** la tabella.

*(Nota: `_ptb` e' la corsa per-trade a 100k della serie R16; il TF del grafico
non sposta i numeri di questo EA — verificato: la cella buffer 1000 di
`_r2` a M15 riproduce al centesimo la FASE 0 a M5, +477,51 IS a deposito 10k.)*

## 10. 🧰 DUE OSSERVAZIONI DI REVIEW STATICA (non si correggono in questo round)

Trovate leggendo `ManagePos`, si scrivono qui perche' **influenzano la lettura**
delle varianti A/D/E, e perche' un round successivo possa raccoglierle:

1. **La R "deriva" dopo il breakeven.** `risk` e' calcolato come distanza
   ingresso-stop **corrente** (riga 291); dopo lo stop in pari diventa 0 e il
   codice ripiega su `ATR_ADESSO * InpAtrSLmult` (riga 292). Quindi **il
   secondo target "3R" non e' 3 volte la R iniziale**, ma 3 volte una R
   ricalcolata sull'ATR del momento. Vale per A, D, E. **Non si tocca qui**
   (nessuna modifica al codice in questo round), ma spiega perche' il TP2 di A
   e' un bersaglio mobile.
2. **Il trailing non puo' peggiorare il pari** (righe 348-349: si muove solo se
   `n > openP` per i long e `n < openP` per gli short). Percio' in A il
   trailing e' anche, di fatto, un secondo breakeven. **La variante D (3,5 ATR)
   e' la risposta diretta all'aneddoto del 18/08**: stesso impianto, respiro
   piu' largo.

## 11. ✍️ COSA USCIRA' DA QUESTO ROUND, detto adesso

- 🟢 **Se una variante batte A in ENTRAMBE le finestre, resta positiva, non
  peggiora il DD oltre il promesso e supera il test della singola operazione**
  → si scrive **CANDIDATA**, e parte la trafila (firma di Claudio → eventuale
  duello in forward su magic nuovo, mai una sostituzione al buio).
- 🔵 **Se A regge** → il round ha fatto il suo mestiere: **la gestione viva e'
  confermata da una misura**, non piu' solo da un'abitudine. E l'aneddoto del
  18/08 va archiviato come tale.
- ⏸️ **Se le differenze stanno dentro il rumore di due-tre trade** → si dichiara
  **NON MISURABILE con questo campione**, e si dice cosa servirebbe (piu'
  storico su D30EUR, oppure lo stesso processo su un EA con 10 volte le
  operazioni).
- 🛑 **In nessuno di questi casi si tocca il forward oggi.**
