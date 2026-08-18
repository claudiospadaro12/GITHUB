# 🏆 TORNEO JPY (R82) — CRITERI CONGELATI PRIMA DEI NUMERI

**Scritti il 18/08/2026 sera, PRIMA di qualunque corsa.**
Ordine di Claudio, parola esatta: _"fai fare agli agenti le analisi per avere
magari solo 1 vincitore tra tutti i cross jpy"_.

EA in prova: **`mql5/Experts/ABTG_BreakoutCorso.mq5` v1.00** — implementazione
fedele della strategia BREAKOUT del corso di **Manuela Negro** (lezioni 34-40),
ricostruita in `prove/BREAKOUT_CORSO_SPEC.md`.

---

## 1. 🎯 LA DOMANDA, una sola

> **Esiste UN cross (al massimo uno) su cui questo motore, implementato
> fedelmente, ha edge?**

Non "il paniere JPY funziona?" — quella domanda ha gia' una risposta agli atti
(**−20.853 € su 7 cross, 2022-2024, PF 0,67-0,95 su TUTTE**,
`docs/Portafoglio_Strategie.md`). E non "quale cross e' il migliore?": il
migliore di sette perdenti resta un perdente.

⚠️ **Cosa e' cambiato dal backtest del 2024 e giustifica un secondo processo:**
1. il vecchio `BREAKOUT_EA_JPY.mq5` **non aveva il vincolo delle 20 candele
   dall'ingresso in zona** (spec §4.5) — poteva aprire su un rettangolo fatto
   in maggioranza di candele **precedenti** la fase che il corso vuole misurare.
   E' la divergenza piu' seria trovata dall'analisi, e qui e' implementata;
2. il nuovo EA tratta le uscite come le vuole il **PDF** (slide S8: SL / TP /
   segnale contrario, **e nient'altro**), senza la regola discrezionale del
   video (§7.4) che nel vecchio EA era accesa dentro `CloseOnOppositeSignal`.

---

## 2. ✍️ LA REGOLA DI PORTAFOGLIO, FIRMATA PRIMA DEI NUMERI

> ### 🔒 **Dalla famiglia JPY entra al massimo UNA sedia. Mai il paniere.
> Qualunque cosa dicano i numeri degli altri sei.**

Nasce dall'intuizione di Claudio del 18/08 sulla correlazione, ed e' gia' scritta
in casa: _"7 EA sui cross JPY = un'unica scommessa sullo yen"_
(`docs/Portafoglio_Strategie.md`, riga 13). Il corso, dal canto suo, **non nomina
mai la correlazione fra i suoi 7 strumenti** (spec §11, buco n.4).

Conseguenza operativa, congelata adesso: se due o piu' cross passassero tutti i
cancelli, **non si promuovono tutti**. Si promuove **quello con il DD piu' basso
a parita' di cancelli superati**, e gli altri restano scritti nel referto come
"passati ma non presi, per regola di portafoglio". **Questa riga esiste per non
doverla decidere davanti a una tabella verde.**

---

## 3. 🔬 COSA SI MISURA, E COME — due giri, dichiarati adesso

### 3.1 Il vincolo che decide l'architettura del round

> **A BCM i tick reali partono dal 2024.07.05** (misurato, R58/R72/R76/R78).
> **O la finestra lunga, o il riempimento vero: mai tutti e due.**

Quindi il torneo si fa in **due giri**, e nessuno dei due da' da solo un
verdetto.

### 3.2 GIRO 1 — screening, storico lungo, **modello OHLC M1**

| voce | valore | fonte |
|---|---|---|
| simboli | i 7 cross JPY, nomi BCM esatti | sonda storico 17/08 |
| TF | **M15** | corso, spec §1 |
| finestra | **2007.02.12 → 2026.06.30**, IDENTICA per tutti e 7 | vedi §3.4 |
| modello | **1 = OHLC su M1** | **SOLO screening** |
| deposito | 10.000 | default di casa |
| celle | **1 sola** (cella congelata) + magic gemello di controllo | §4 |

🚫 **Il giro 1 NON promuove niente e NON boccia da solo.** Regola di casa
dell'08/08: _"l'OHLC promuove ipotesi, non candidati"_, e sotto M15 lo screening
OHLC e' stato misurato **fuorviante, non impreciso**. Qui siamo **esattamente
su M15**, cioe' sul bordo: si usa per (a) **contare le operazioni** — cioe' per
sapere se la regola dei 150 e' raggiungibile — e (b) vedere il segno su
quattro regimi veri (2008, 2011-13 Abenomics, 2020, 2022).

### 3.3 GIRO 2 — verdetto, **tick reali** (modello 4)

| voce | valore |
|---|---|
| finestra | **2024.07.05 → 2026.06.30** (i tick veri di BCM, misurati) |
| modello | **4 = ogni tick su tick reali** |
| chi ci va | **solo i cross sopravvissuti al giro 1** (max 3) |

⚠️ **Il giro 2 misura il RIEMPIMENTO, non la robustezza di regime**: niente 2020,
niente 2022. E' lo stesso caveat di R58/R72, e si scrive accanto al numero.

### 3.4 Perche' la finestra del giro 1 parte dal **2007.02.12** e non da prima

Date **misurate** (sonda `ABTG_InfoBroker` del 17/08, `PrimaDataTF` H1):

| simbolo BCM | prima data del BROKER | stato sul disco |
|---|---|---|
| `USDJPY` | 1971.01.03 | da scaricare (parziale) |
| `CHFJPY` | 1992.02.18 | da scaricare (parziale) |
| `GBPJPY` | 1993.04.18 | da scaricare (parziale) |
| `EURJPY` | 1993.04.26 | da scaricare (parziale) |
| `AUDJPY` | 1993.05.16 | da scaricare (parziale) |
| `CADJPY` | **2007.02.12** | da scaricare (parziale) |
| `NZDJPY` | **2007.02.12** | da scaricare (parziale) |

**2007.02.12 e' la data piu' giovane dei sette**: e' l'unica finestra che tutti
e sette possono avere per intero. In un TORNEO le finestre diverse falsano il
confronto piu' di qualunque parametro — quindi la finestra la detta il simbolo
piu' povero, non la media.

🔴 **`da scaricare (parziale)` vuol dire che sul SERVER c'e' e sul DISCO no.**
Prima del round va eseguito il **passo 0 (scarico storico)** e va **letto il suo
referto**: se un simbolo non arriva al 2007, **il round si ferma e si ridichiara
la finestra** — non si gira su meta' finestra vuota (errore gia' pagato sugli
indici, `walkforward_generico.ps1` lo dice in testa).

---

## 4. 🧬 LA CELLA: UNA SOLA, CONGELATA — zero gradi di liberta'

Il torneo **non spazzola nessun parametro della strategia**. Tutti gli input
sono pinnati ai default del sorgente, che sono la lettura fedele della spec:

| input | valore | perche' |
|---|---|---|
| `InpTF` | `PERIOD_M15` | spec §1 |
| `InpWilliamsPeriod` | **140** | lez.35, **confermato da Claudio il 18/08 riascoltando il video** |
| `InpSuperTrendATR` / `InpSuperTrendMult` | **10 / 3.0** | ⚠️ **ASSUNZIONE NOSTRA**: il corso non li detta (verificato da Claudio). Decisione di Claudio: standard |
| `InpCandeleRettangolo` | **20** | slide S4 _"deve contenere 20 candele"_ |
| `InpIncludiCandelaRottura` | **false** | i livelli si misurano sulle candele che precedono il segnale (§4.4) |
| `InpAttesaCandeleZona` | **true** | spec §4.5 — **la divergenza del vecchio EA, qui corretta** |
| `InpTargetR` / `InpMinRR` | 3.0 / 2.0 | lez.40 / lez.37 |
| `InpBreakEven1R` | true | §7.1, sulla **chiusura del segnale** |
| `InpChiudiSuSegnaleContrario` | true | **slide S8: e' un obbligo** |
| `InpChiudiSuWilliamsOpposto` | **false** | §7.4 **non e' nel PDF** → non e' strategia |
| `InpRischioMode` / `InpRiskPercent` | `RISCHIO_PER_OPERAZIONE` / 1.0 | il parlato (lez.35/37) |

**L'unico asse spazzolato e' `InpMagic`, su due valori gemelli.** Motivo tecnico
identico a R81: il driver **pretende almeno un asse** (`walkforward_generico.ps1`
riga 372) e il magic e' l'unico inerte sul risultato. **Le due passate DEVONO
uscire identiche al centesimo: se differiscono, qualcosa e' rotto e il round non
si legge.** Magic nuovi (7791xx / 7792xx) = niente cache del tester.

> 🎯 **Conseguenza importante, dichiarata:** siccome non si sceglie nessuna
> cella, **la regola "centro dell'altopiano, mai il picco" qui non ha nulla su
> cui mordere** — e infatti il rischio di curve-fitting in questo round e'
> **zero per costruzione**. Quella regola torna vincolante **nella fase 2**
> (§7), che e' l'unica in cui si guarda una superficie.

### 4.1 Sul rischio "1% per operazione" contro "1% COMPLESSIVO" (spec §8.1)

L'EA ha l'input per **entrambe** le letture (`InpRischioMode`), ma **su un
backtest a simbolo singolo le due letture non sono distinguibili**: cambiano
solo la taglia del lotto (fattore 7), quindi profitti ed euro scalano e le
**percentuali (PF, DD%) restano le stesse**. Il torneo gira in
`RISCHIO_PER_OPERAZIONE`; **la lettura "complessivo" si legge dividendo gli euro
per 7**. La differenza vera esiste solo a livello di **portafoglio**, e la
regola di portafoglio del §2 la rende ininfluente: **una sedia sola**.

---

## 5. 🚦 I CANCELLI DI PROMOZIONE (soglie dichiarate PRIMA)

Un cross e' **VINCITORE** solo se supera **TUTTI** questi cancelli, in
**entrambi** i giri (screening lungo **e** tick reali):

| # | cancello | soglia |
|---|---|---|
| C1 | **profitto netto** | **> 0 in IS E in OOS**. Positivo in una sola finestra = niente |
| C2 | **Profit Factor** | **>= 1,10 in IS E in OOS** (il minimo assoluto della missione e' PF > 1; la soglia di casa e' 1,10 e vince la piu' severa) |
| C3 | **Equity DD %** | **< 10%** in entrambe le finestre, a rischio 1% (muro prop di casa, usato in R76/R78) |
| C4 | **campione** | **n OOS >= 30** (regola dell'08/08). Con **n < 150 per finestra** il MERITO resta **dichiarato sospeso** (emendamento della finestra, regola A) |
| C5 | **clausola di segno** | **non si promuove niente che perde.** "Perde meno degli altri sei" non e' una promozione |
| C6 | **test della singola operazione** | tolta l'operazione migliore della finestra OOS, i cancelli C1-C3 devono reggere ancora. Se il vantaggio sparisce, **il round non ha trovato niente** |

### 5.1 🟥 ZERO VINCITORI E' UN VERDETTO VALIDO

> **Se nessun cross passa, il verdetto e': la famiglia JPY resta SPENTA.**
> Non si abbassa nessuna soglia, non si cerca "il meno peggio", non si allarga
> la finestra finche' non esce un numero verde. Il round finisce li' e la
> spec del corso resta agli atti come **documentazione**, non come sedia.

E' l'esito **piu' probabile a priori**, ed e' bene averlo scritto: il paniere
misurato nel 2024 faceva PF 0,67-0,95 su **tutte e sette**.

### 5.2 Se passano in due o piu'

Vince **uno solo** (§2). Ordine di scelta, dichiarato: **DD piu' basso** in OOS
a tick reali → a parita', **PF piu' alto** → a parita', **n piu' alto**.
**Mai il profitto in euro come primo criterio** (e' la variabile piu' rumorosa).

---

## 6. ⚖️ COSA QUESTO ROUND *NON* FA

- **Non tocca il forward.** La sedia `BREAKOUT_EA_JPY_v3 USDJPY` e' stata
  **SPENTA il 18/08** (FIRMA 5, `report/PIANO_PROP.md`) e **resta spenta**:
  un eventuale vincitore rientra dalla **porta di rientro** dei criteri di
  uscita (`report/FIRME_2026-08-18.md`), cioe' con **firma di Claudio** e
  **contratto** (DD e frequenza promessi), non da questo referto.
- **Non ottimizza niente.** Una cella sola, congelata (§4).
- **Non giudica il corso.** Giudica **la nostra implementazione della spec**.
  Finche' i parametri del SuperTrend sono nostri (§4), qualunque numero misura
  **la nostra versione**, e va detto accanto al numero.

---

## 7. 🔧 FASE 2 — la disambiguazione, SOLO sul vincitore

Se e solo se un cross vince, **e su quel cross soltanto**, si aprono i due assi
di ambiguita' della spec, uno alla volta:

| asse | valori | ambiguita' della spec |
|---|---|---|
| `InpCandeleRettangolo` | **15** vs **20** | §4.2 — la lez.36 dice "15" due volte e poi si corregge contando fino a 20; il PDF scrive 20 |
| `InpIncludiCandelaRottura` | **false** vs **true** | §4.4 — "compresa, se vogliamo, la candela di rottura" contro "le 20 che precedono" |

**Regole della fase 2, congelate qui:**
1. e' una **disambiguazione**, non un'ottimizzazione: serve a sapere **quale
   lettura del corso** regge, non a trovare il numero migliore;
2. **se la cella scelta non e' quella di default, si sceglie col metodo di casa:
   centro dell'altopiano, MAI il picco** — e la regola di selezione si scrive
   accanto al numero, altrimenti il numero non vuol dire niente;
3. se le quattro combinazioni danno risultati **tutti diversi e senza
   altopiano**, il verdetto e': **il motore e' fragile a una candela**, e questo
   **annulla la promozione** invece di rifinirla.

---

## 8. 📣 IL CONFRONTO COL CLAIM DEL CORSO

La lez.39 dichiara **+133% su 5.000 € in due anni**, rischio 1%, 7 cross JPY,
**"quasi 4% di drawdown"**. Nessun documento a supporto: nessun estratto conto,
nessun numero di operazioni, nessun win rate, nessuna data, nessun broker
(spec §9).

**Il torneo lo misura, e la misura si scrive in tre righe:**
1. cosa fa la **somma dei 7** nel giro 1 (e' la cosa piu' vicina al suo claim);
2. cosa fa il **migliore dei 7**;
3. il **DD massimo** misurato, contro il "quasi 4%" dichiarato.

⚠️ **Onesta' preventiva:** il nostro numero e **il suo** non sono la stessa
misura. Il suo "drawdown effettivo/atteso/stimato" non e' mai definito nel
corso; il nostro e' `Equity DD %` da report MT5. **Si confrontano gli ordini di
grandezza e il SEGNO, non i decimali.**

---

## 9. 🕳️ I LIMITI, TUTTI, SCRITTI PRIMA

1. **SuperTrend 10/3.0 e' NOSTRO**, non del corso (buco bloccante, spec §3.3).
2. **Tick reali solo dal 2024.07.05**: il giro lungo e' OHLC.
3. **Un solo broker** (BCM), spread e commissioni suoi.
4. **Nessun filtro news**, per fedelta' al corso: nell'esempio-principe della
   lez.37 si entra proprio su un rilascio macro.
5. **Il pip su JPY = 0,01** e' una nostra deduzione dall'esempio numerico
   (spec §6.3): il corso non lo definisce mai.
6. **Il test-case numerico del corso non chiude per 1 pip**: 155,96 − 155,57 =
   **0,39 (39 pip)**, mentre il corso dice **40 pip** e da li' calcola il target
   154,37. L'EA usa il valore esatto (39 pip → TP 154,40) e lo **stampa in
   OnInit** (`InpAutoTest`). E' una **discrepanza del corso**, non dell'EA.
7. **Il campione**: se n < 150 per finestra, il **merito e' sospeso** e il round
   puo' al massimo dire _"candidato"_ — mai _"vincitore"_. Il **rischio** (DD)
   si giudica lo stesso, a qualunque n (regola B, valvola R59).
