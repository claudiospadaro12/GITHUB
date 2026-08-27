# 📑 ANALISI MATERIALE ABTG — Outlook settimana 24-28/08/2026 + Checklist Conferme

**Data referto:** 27/08/2026 · **Analista:** estrattore trascrizioni/documenti
**Mandato:** estrarre OGNI valore, OGNI meccanismo, OGNI regola. Non riassumere.
**Regola di casa che vale sopra tutto:** ⛔ **nessun parametro della flotta si
muove da materiale esterno.** Questo referto è LETTURA e CONTESTO, non azione.

---

## 0. 🗂️ LE QUATTRO FONTI (e cosa sono davvero)

| # | Fonte | Che cos'è | Peso |
|---|---|---|---|
| **A** | `Analisi_PreMarket_DAX40XAUUSDEURJPYNZDUSDEURUSD_23082026.pdf` (7 pag.) | Report integrale pre-market 5 strumenti. Autore PDF: "Un-named", creato **23/08/2026 14:23 UTC** | Fonte primaria dei LIVELLI |
| **B** | `WEEKLY_COT_OUTLOOK_2428_Agosto_2026.pdf` (5 pag.) | COT settimanale. Autore metadati: **ABTG**, creato **23/08/2026 13:32 UTC** | Fonte primaria del POSIZIONAMENTO |
| **C** | `Analisi_PreMarket_EXECUTIVESUMMARY_23082026.pdf` (2 pag.) | Sintesi operativa di A+B. Creato **23/08/2026 14:27 UTC** | **Derivato**: non è una terza fonte |
| **D** | Infografica settimanale (letta in chat il 27/08) | Riassunto grafico di A/B/C | **Derivato**: non è una quarta fonte |
| **E** | **"CHECKLIST DELLE CONFERME DI ENTRATA — MODULO OPERATIVO"** di **Emiliano Monza (FTD)**, .docx | Modulo didattico su conferme d'ingresso. Contenuto già estratto e fornito al referto | Fonte primaria di METODO (§7) |

🔴 **PRIMA COSA DA CAPIRE, e non è un dettaglio.** A, B, C e D **non sono
quattro fonti indipendenti: sono UNA sola.** C è la sintesi di A+B, D è la
sintesi di C. Il COT dentro A (§1.3) è **copiato da B** — A lo dichiara
testualmente: _"Fonte: WEEKLY COT OUTLOOK, Emiliano Monza."_ Quando più avanti
si legge "converge in 3 documenti", **converge in un documento solo ripetuto
tre volte.** L'unica cosa che i tre PDF verificano davvero l'uno dell'altro è
la **coerenza interna della trascrizione dei numeri** (che, come si vedrà al
§5, in due punti non regge).

🟡 **SECONDA COSA.** Il report A dichiara in chiaro di essere stato prodotto
**dentro un assistente AI su una macchina Windows dell'utente**:

> _"Screenshot non recuperabili dall'ambiente Claude (salvati sul filesystem
> Windows locale dell'utente — verificato in sessione: `C:\Users\bardolla_91\...`).
> Fallback: tabella testuale dei livelli. `draw_clear` eseguito su ciascun chart
> prima del tracciamento dei livelli della settimana corrente."_ (§4)

Non è squalificante — è anzi *onesto*, perché i limiti sono dichiarati. Ma
cambia il peso: **non è l'occhio di un trader su un grafico, è l'output di una
catena di tool con bug dichiarati** (§5, bandiera B3).

---

# ⭐ PARTE 1 — LA SINTESI CHE CONTA

## 1. 🚨 IL DATO OPERATIVO NUMERO UNO: IL CALENDARIO

> **La finestra di rischio evento è DOMANI POMERIGGIO, non oggi.**

| Data | Ora [come scritta] | Evento | Stato al 27/08 |
|---|---|---|---|
| Lun 24/08 | 20:00 | Treasury Sec. Bessent Speaks (USD) | ✅ passato |
| Mar 25/08 | 16:00 | CB Consumer Confidence (USD) — medio impatto | ✅ passato |
| Mer 26/08 | 03:30 | AUD CPI m/m (prec. −0,1% → forecast 0,9%) + Trimmed Mean CPI (0,3% → 0,3%) — **alto** | ✅ passato |
| Mer 26/08 | 14:30 | **USD Core PCE** + Prelim GDP q/q (1,5% → 1,5%) + GDP Price Index (6,2% → 6,2%) — **alto** | ✅ passato |
| **Gio 27/08** | — (nessun orario dichiarato) | **Jackson Hole Symposium — Day 1** | 🟡 **OGGI** |
| **Ven 28/08** | **14:30** | CAD GDP m/m (0,3% → 0,2%) — **alto** | 🔴 **DOMANI** |
| **Ven 28/08** | **16:00** | **Fed Chairman Warsh Speaks — keynote Jackson Hole** — **alto** | 🔴 **DOMANI, IL PICCO** |
| Sab 29/08 | — | Jackson Hole — Day 3, chiusura | mercati chiusi |

Tutti i valori sopra: **[DICHIARATO ABTG]**, fonte A §1.5 + C. A dichiara la
provenienza: _"Fonte: screenshot ForexFactory caricato da Paolo, settimana
Aug 23-29, ora riferimento 15:35"_.

### ⏰ IL FUSO — e perché non lo do per buono
🔴 **Il fuso orario di quegli orari NON È DICHIARATO in nessuno dei quattro
documenti.** ForexFactory mostra gli orari nel fuso impostato dall'utente: uno
screenshot non porta con sé il proprio fuso.

**[INFERITO — non dichiarato]** Gli orari sono quasi certamente in **ora
italiana (CEST)**, e lo deduco da un solo numero che fa da chiave: il **Core
PCE USD alle 14:30**. Il rilascio standard dei dati macro USA è **08:30 ET**,
che in agosto (EDT) corrisponde esattamente alle **14:30 CEST**. Coerente anche
il CAD GDP alle 14:30 e l'AUD CPI alle 03:30.

**Se l'inferenza è giusta, in ORA SERVER BCM (italiana − 1):**

| Evento | Ora dichiarata (IT, inferita) | **Ora server BCM** |
|---|---|---|
| CAD GDP, ven 28/08 | 14:30 | **13:30 server** |
| **Warsh keynote, ven 28/08** | **16:00** | **🔴 15:00 server** |

⚠️ **Questo numero — 15:00 server — è [INFERITO], non [DICHIARATO].** Chi lo
usa deve sapere che poggia su una deduzione, non su una riga di testo. Un
orario col fuso sbagliato è peggio di nessun orario (regola di casa).

### 🧩 IL BUCO DOCUMENTALE CHE QUESTO MATERIALE CHIUDE
`caccia_strategie/ANALISI_LIVE_EMILIANO_2026-08-24.md` porta questa correzione:

> _"⚠️ **CORREZIONE sulla data**: nella trascrizione del 25/08 Paolo dice solo
> **'venerdì'** e **'fine agosto'** — le date **27/28 NON sono nel suo parlato**.
> La finestra gio-ven resta come prudenziale, ma non è attribuibile a lui."_

✅ **Ora le date ci sono per iscritto.** A §1.1 e §3.0: _"Jackson Hole
Symposium (27–29/08): evento dominante, rischio binario elevato su tutte le
valute, in particolare **venerdì 16:00 (keynote Warsh)**"_. C mette la stessa
riga in tabella. **La finestra prudenziale gio-ven diventa una data
documentata** — dalla stessa accademia, quindi non è una seconda fonte
indipendente, ma è la fonte *scritta* che al 24/08 mancava.

---

## 2. 📊 TABELLA DEI LIVELLI — tutti i numeri, tutti etichettati

Tutti **[DICHIARATO ABTG]**. Nessuno di questi prezzi è stato verificato da noi
contro i dati BCM: sono i numeri della fonte, non misure di casa.

### DAX40 (bias laterale/ribassista · punteggio **54/100** · rischio evento ALTO)
| Voce | Valore | Fonte |
|---|---|---|
| Weekly High (liquidità primaria) | **26.520,93** | A §3 + A §4 + C + D |
| Weekly Low (liquidità primaria) | **25.911,42** | A §3 + A §4 + C + D |
| FVG **bearish** 17/08 | **26.328,34 – 26.383,64** | A §2, A §4 (C arrotonda a "26.328-26.384") |
| Range 1H recente | **25.911 – 26.130** | A §2 |
| "massimi di periodo" | **area 26.579** | A §2 — ⚠️ **contraddizione**, vedi §5/C1 |
| Scenario principale | pressione ribassista verso **WL 25.911,42** | A §3 |
| **Zona di invalidazione** | **chiusura DAILY sopra 26.520,93** | A §3, C, D |
| Scenario alternativo | rottura+chiusura sopra 26.520,93 → nuovi massimi, invalida il ribassista | A §3, C |
| R:R dichiarato | **~1,7:1** | C — ⚠️ **non ricostruibile**, §5/B1 |
| Derivazione FVG | **manuale a 3 candele** (LuxAlgo ha restituito 0 box) | A §2 — ⚠️ §5/B3 |

### XAUUSD (bias BULLISH · punteggio **78/100** · rischio evento Medio-Alto)
| Voce | Valore | Fonte |
|---|---|---|
| Weekly High | **4.632,15** | A §3, A §4, C, D |
| Weekly Low | **4.324,68** | A §3, A §4, C, D |
| FVG **bullish** 19/08 (area di ricarico) | **4.436,23 – 4.450,745** | A §2, A §4, D (C arrotonda "4.436-4.451") |
| Struttura 1H | impulso rialzista deciso **da area 4.480 a 4.632** | A §2 |
| Scenario principale | continuazione BULLISH, **estensione oltre 4.632,15** | A §3, D |
| Pullback | verso FVG 4.436,23-4.450,745 **come ricarico, senza invalidare il bias** | A §3 |
| **Zona di invalidazione** | **chiusura DAILY sotto 4.324,68** | A §3, C, D |
| Regola d'ingresso | **"no chasing"** | C |
| R:R dichiarato | **~2,5:1** | C — ⚠️ **non ricostruibile**, §5/B1 |
| Derivazione FVG | **manuale a 3 candele** (stesso bug LuxAlgo) | A §2 |

### EURJPY (LONG **solo su pullback** · punteggio **58/100** · rischio evento ALTO)
| Voce | Valore | Fonte |
|---|---|---|
| Weekly High | **186,022** | A §3, A §4, C, D |
| Weekly Low | **183,921** | A §3, A §4, C, D |
| FVG **bullish** 20/08 (zona d'ingresso) | **184,939 – 185,434** | A §3, A §4, D |
| Regola d'ingresso | **"Pullback Only", "mai chasing"** (Extension Risk HIGH) | B, C, A |
| **Zona di invalidazione** | **chiusura DAILY sotto WL 183,921** | A §3, C, D |
| Scenario alternativo | nuovo intervento MoF/BoJ → **gap risk**, invalida il setup **indipendentemente dal COT** | A §3, C |
| R:R dichiarato | **~1,1:1** | C — ✅ **l'unico che torna**, §5/B1 |
| Status | **fallback**: nessuna coppia "Preferred" disponibile | B, A §1.4bis |

### NZDUSD (short strutturale in **Reversal Watch** · punteggio **50/100** · NESSUN TRIGGER)
| Voce | Valore | Fonte |
|---|---|---|
| Weekly High | **0,59878** | A §3, A §4, C, D |
| Weekly Low | **0,58604** | A §3, A §4, C, D |
| FVG bullish 19/08 | **0,59089 – 0,59238** | A §4 (**solo nella tabella**, assente dal testo di struttura) |
| Stato | **non operativo — solo monitoraggio, nessun trigger** | A, C, D |
| Trigger di reversal | **rottura sopra 0,59878 con volumi** → conferma reversal tattico, in **controtendenza al regime** | A §3, C |
| Numeri COT | Pctl LF **0,8** · ΔNet **+6.655** · Pair COT Index **−53,42** · ★★★ | B |

### EURUSD (Reversal Watch **secondario** · punteggio **52/100** · NESSUN TRIGGER)
| Voce | Valore | Fonte |
|---|---|---|
| Weekly High | **1,17115** | A §3, A §4, C, D |
| Weekly Low | **1,15605** | A §3, A §4, C, D |
| FVG bullish 19/08 | **1,15882 – 1,16692** | A §3, A §4 (C arrotonda "1,1588-1,1669") |
| Stato | **non operativo** — coerenza solo MODERATA ★★ | A, C, D |
| Scenario negativo | rottura sotto **1,15882-1,16692** → indebolisce la tesi di reversal | A §3, C |
| Numeri COT | Pctl LF **4,6** · ΔNet **+2.884** · Pair COT Index **−12,95** · ★★ | B |

---

## 3. 🔒 I MECCANISMI DI PROTEZIONE E INVALIDAZIONE (il pezzo tecnicamente utile)

Questi sono i **meccanismi**, separati dai livelli. Sono la parte del materiale
che ha una struttura logica, non solo un'opinione direzionale.

| # | Meccanismo | Come è formulato | Etichetta |
|---|---|---|---|
| **M1** | **Invalidazione a CHIUSURA DAILY, non intraday** | Tutte e tre le zone di invalidazione (DAX 26.520,93 · oro 4.324,68 · EURJPY 183,921) sono espresse **"in chiusura Daily"** | [DICHIARATO ABTG] — filtro anti-rumore esplicito, il livello toccato non basta |
| **M2** | **Il COT non è mai un trigger** | _"Il COT non viene utilizzato come trigger di ingresso… l'eventuale ingresso operativo dovrà essere successivamente validato attraverso una distinta analisi tecnica sul timeframe H1"_ (B, pag. 1) — ripetuto in C e in A | [DICHIARATO ABTG] — **separazione netta bias/trigger** |
| **M3** | **Scala d'affollamento → regola d'ingresso** | Extension Risk **HIGH → "Pullback Only"** · **VERY HIGH → "No Chasing"** · **LOW → continuazione ammessa** | [DICHIARATO ABTG] — la forza direzionale **non autorizza** l'inseguimento |
| **M4** | **Soglie di percentile (numeriche)** | NORMAL = Pctl **10-90** · EXTENDED = Pctl **5-10** o **90-95** · EXTREME = Pctl **<5** o **>95** · REVERSAL WATCH = estremo **+ ΔNet in direzione opposta** | [DICHIARATO ABTG] |
| **M5** | **Soglia di neutralità** | **\|Pair COT Index\| < 10 = NEUTRAL** (esempio dato: GBPJPY −0,68) | [DICHIARATO ABTG] |
| **M6** | **Coerenza a stelle = concordanza di segno** | ★★★ = AM e LF stesso segno · ★ = segni opposti → _"Caution e non Preferred"_ (esempio: EURGBP, AM +70,44 vs LF −22,14) | [DICHIARATO ABTG] |
| **M7** | **Controllo staleness del dato** | Rilevazione 18/08, pubblicazione 21/08, **età 5 giorni → OK**. E: _"il dato CFTC è rilevato il martedì e pubblicato il venerdì (lag 3gg); ritardi aggiuntivi vanno considerati prima di usarlo per l'operatività di breve periodo"_ | [DICHIARATO ABTG] — ⚠️ **la soglia numerica oltre cui è "stale" NON è dichiarata** |
| **M8** | **Controllo di continuità del dataset** | _"294 osservazioni dal 2021; non risultano gap superiori a 8 giorni. Tutti i record utilizzati sono Futures Only. Per i percentili vengono utilizzate esattamente le ultime 260 rilevazioni"_ | [DICHIARATO ABTG] — è **una sonda dello storico**, mentalità gemella alla nostra |
| **M9** | **Controllo di coerenza col regime (§1.4bis)** | Ogni selezione viene ricontrollata contro il regime dominante e **declassata** se conflittuale (EURJPY: da "favorevole" a **"Conflittuale/mitigato"**) | [DICHIARATO ABTG] — meccanismo di **auto-declassamento** |
| **M10** | **Rifiuto di risolvere le contraddizioni a forza** | _"Regime dominante: risk-off leaning CON CONTRADDIZIONI INTERNE dichiarate e **non risolte forzatamente**"_ | [DICHIARATO ABTG] — 🟢 onestà metodologica, la stessa che pretendiamo in casa |
| **M11** | **Il bias non autorizza** | D (chiusura): _"il bias prepara lo scenario, non autorizza l'ingresso"_ | [DICHIARATO ABTG] |
| **M12** | **Rifiuto di introdurre soglie non previste** | _"il protocollo non definisce una soglia quantitativa per distinguere RISING da STRONG RISING; **per non introdurre soglie esterne**, l'aumento del +1,49% viene classificato semplicemente come RISING"_ | [DICHIARATO ABTG] — 🟢 disciplina rara |

### Formule COT dichiarate (B, pag. 1) — riproducibili
```
Net            = Long − Short
Net %OI        = (Long − Short) / Open Interest × 100
ΔNet           = Net corrente − Net settimana precedente
Currency Directional Score = (AM Net %OI + LF Net %OI) / 2
AM Differential = AM Net %OI BASE − AM Net %OI QUOTE
LF Differential = LF Net %OI BASE − LF Net %OI QUOTE
Pair COT Index  = (AM Differential + LF Differential) / 2 = Score BASE − Score QUOTE
Percentile empirico = posizione del Net %OI corrente nelle ultime 260 osservazioni
```
Finestra statistica: **260 settimane**. Dataset valute: **CFTC TFF Futures
Only**. Dataset oro: **CFTC Disaggregated Futures Only, GOLD COMEX 088691**.
Proxy USD dichiarato imperfetto: _"USD INDEX - ICE FUTURES U.S. (DXY/TFF)…
**non è una misura bilaterale perfetta**"_.

---

## 4. 🔀 CONVERGENZE E CONTRADDIZIONI

### ✅ Convergono (fra A, B, C, D — ma ricordando che sono UNA fonte sola: la convergenza qui prova solo la **coerenza di trascrizione**)
| Valore | A | B | C | D | Esito |
|---|---|---|---|---|---|
| DAX WH 26.520,93 / WL 25.911,42 | ✔ | n/d | ✔ | ✔ | **3/3 identici** |
| Oro WH 4.632,15 / WL 4.324,68 | ✔ | n/d | ✔ | ✔ | **3/3 identici** |
| Oro FVG 4.436,23-4.450,745 | ✔ | n/d | ✔ (arrot.) | ✔ | **3/3 coerenti** |
| EURJPY FVG 184,939-185,434 | ✔ | n/d | ✔ (arrot.) | ✔ | **3/3 coerenti** |
| NZDUSD 0,58604 / 0,59878 | ✔ | n/d | ✔ | ✔ | **3/3 identici** |
| Gold BULLISH, MM ACCUMULATION, Ext.Risk LOW, Rev.Watch NO | ✔ | ✔ | ✔ | ✔ | **4/4** |
| NZD LF Pctl 0,8 / ΔNet +6.655 | ✔ | ✔ | ✔ | ✔ | **4/4** |
| EUR LF Pctl 4,6 / ΔNet +2.884 | ✔ | ✔ | ✔ | ✔ | **4/4** |
| Warsh ven 28/08 16:00 | ✔ | n/d | ✔ | ✔ | **3/3** |
| Nessuna coppia "Preferred" questa settimana | ✔ | ✔ | ✔ | — | **3/3** |

**Zero errori di trascrizione fra i tre PDF sui livelli.** È l'unica cosa che
questa "convergenza" dimostra, ed è comunque un buon segno.

### ⚠️ CONTRADDIZIONI — quattro dichiarate dalla fonte, tre trovate da me

**Dichiarate dalla fonte stessa (🟢 le apprezzo: sono ammesse, non nascoste):**
1. **USD forte da COT (+24,11, il più alto) vs DXY tecnicamente bearish**
   (_"rottura sotto 98,80"_, A §1.1). Testuale: _"in tensione diretta col dato
   COT… **Divergenza dichiarata**."_
2. **RBNZ narrativa restrittiva vs NZD la valuta più debole in assoluto**
   (score −29,31). Testuale: _"in tensione diretta col dato COT…
   **Divergenza dichiarata, non risolta arbitrariamente**."_
3. **NZDUSD: short strutturale MA Reversal Watch** — cioè il segnale tattico
   punta contro il bias strutturale. C: _"Reversal Watch in sé andrebbe
   controcorrente — **cautela addizionale**."_
4. **EURJPY long in regime risk-off**: C lo bolla **"Conflittuale"** (short JPY
   safe-haven dentro un risk-off), salvato solo dal fattore idiosincratico
   post-intervento. **Declassato da "favorevole" a "Conflittuale/mitigato"**.

**Trovate da me, NON dichiarate:**
- **C1 — DAX: "massimi di periodo area 26.579" vs "Weekly High 26.520,93".**
  Il primo numero è **più alto** del secondo. O il "periodo" è più lungo della
  settimana (plausibile), o uno dei due è sbagliato. **[INCERTO]** — nessuna
  riga del documento chiarisce quale.
- **C2 — il target DAX è già stato toccato.** A §2 dice che il range 1H recente
  è **25.911-26.130**: il fondo del range **coincide col Weekly Low 25.911,42**,
  che C indica come **target**. Un target già visitato dentro la settimana non
  è un target: è il bordo del range in cui si sta già.
- **C3 — punteggi non confrontabili fra loro.** A dichiara in nota: _"DAX40:
  fattore COT (peso 30%) non applicabile per assenza dataset CFTC su indice
  Eurex — punteggio su pesi residui (tecnica+evento+geo, **tot. 70**)."_ Quindi
  il **54/100 del DAX** è calcolato su una base da **70 punti**, il **78/100
  dell'oro** su 100. **Metterli nella stessa colonna "Punteggio*/100" è un
  confronto fra unità diverse.** Non è dichiarato se il 54 sia stato
  riscalato: **[INCERTO]**.

---

## 5. 🚩 BANDIERE ROSSE

> Nessun trucco anti-prop, nessuna martingala, nessuna griglia, nessun
> recovery, nessun "no stop loss". **Su quel fronte il materiale è pulito.**
> Le bandiere qui sotto sono di tipo **metodologico**, e vanno pesate.

### 🔴 B1 — DUE R:R SU TRE NON SONO RICOSTRUIBILI DAI LIVELLI PUBBLICATI
Il documento C pubblica stop, target e R:R ma **non pubblica l'entry**. Ho
ricostruito l'entry implicito. Il metodo si legge da EURJPY, l'unico che torna:
**entry al bordo della FVG più vicino allo stop**.

| Asset | Entry (bordo FVG) | Rischio | Reward | **R:R ricalcolato** | **R:R dichiarato** | Esito |
|---|---|---|---|---|---|---|
| **EURJPY** | 184,939 | 1,018 | 1,083 | **1,06:1** | **~1,1:1** | ✅ **torna** |
| **DAX40** | 26.328,34 | 192,59 | 416,92 | **2,17:1** | **~1,7:1** | ❌ |
| **DAX40** (altro bordo) | 26.383,64 | 137,29 | 472,22 | **3,44:1** | **~1,7:1** | ❌ |
| **XAUUSD** | 4.436,23 | 111,55 | 195,92 | **1,76:1** | **~2,5:1** | ❌ |
| **XAUUSD** (altro bordo) | 4.450,745 | 126,065 | 181,405 | **1,44:1** | **~2,5:1** | ❌ |

Per far tornare il **1,7:1 del DAX** serve un entry a **26.295,2** — un prezzo
che **non compare in nessuno dei quattro documenti**. Per far tornare il **2,5:1
dell'oro** serve un target a **~4.715** (contro i 4.632,15 pubblicati) oppure
un entry a **4.412,53**, sotto la FVG — **nessuno dei due è pubblicato**.
📌 **Conclusione:** i R:R di DAX e oro sono **numeri non verificabili con i
livelli forniti.** Vanno letti come *impressione*, non come misura. C stesso
avverte: _"R:R indicativi non tengono conto di leva, dimensionamento posizione
o costi/commissioni."_

### 🔴 B2 — ZERO GESTIONE DEL RISCHIO. LETTERALMENTE ZERO.
In **7 + 5 + 2 pagine** non compare: **nessuna percentuale di rischio per
trade**, nessun cap giornaliero, nessun numero di posizioni massime, nessuna
regola di correlazione, nessun dimensionamento, nessun break-even, nessun
trailing, **nessun riferimento a regole prop di alcun tipo.** Il materiale è
**direzionale puro**. Non è un difetto del documento (non è il suo scopo), ma è
**decisivo per noi**: da qui **non esce un solo numero utilizzabile come
parametro**, perché di parametri non ce ne sono.

### 🟠 B3 — I LIVELLI CHIAVE SONO DERIVATI A MANO PER UN BUG DICHIARATO
> _"⚠ **OB/FVG DAX40 e XAUUSD: LuxAlgo ha restituito 0 box** (problema noto,
> confermato in sessione). Fallback: derivazione manuale a 3 candele, **lettura
> non algoritmica** (Metodologia M.7)."_ (A §2)

Le **due FVG che reggono tutta l'operatività su DAX e oro** (26.328,34-26.383,64
e 4.436,23-4.450,745) **non vengono da uno strumento: le ha tracciate una
persona a occhio.** Va detto, perché la stessa fonte lo dice.
Bug collaterale dichiarato in §4: _"horizontal_line in sostituzione di
rectangle **per il bug noto**"_.

### 🟠 B4 — TUTTA LA SEZIONE GEOPOLITICA È NON VERIFICATA (e la fonte lo ammette)
> _"⚠ **Limite dichiarato**: lo strumento web search (COMPOSIO) restituisce
> sintesi con citazioni numerate **ma senza URL verificabili**, anche con query
> mirate ripetute. **Non soddisfa lo standard '2 fonti indipendenti + URL'**
> di M.6 — trattato come contesto indicativo, **non come notizia a doppia
> verifica**."_ (A §1.2)

Cade sotto questo cappello **ogni numero** di §1.2 e §1.1: Treasury 30Y ~5,32%
_"quasi massimo da 2 decenni"_, Brent 93-94$, VIX in rialzo, STOXX 600 sotto
pressione, intervento coordinato USA-Giappone _"a difesa dello yen da minimi a
40 anni"_ con stime di spesa **discordanti fra fonti (~36,6 vs ~59 mld$)** —
_"dato da trattare con cautela"_, testuale. Idem: Fed tassi **3,50-3,75%**,
consensus **69% fund manager**, ECB deposit rate **2,25%** hold 23/07, RBA
**4,35%** con **~50%** di probabilità di rialzo entro fine 2026, DXY rottura
sotto **98,80**. 🔴 **Nessuno di questi numeri va usato per niente.**

### 🟠 B5 — I PUNTEGGI SONO DICHIARATI NON BACKTESTATI
> _"Rubrica: Metodologia M.5. **Non backtestato.**"_ (A §3, nota)

I punteggi **54/100 · 78/100 · 58/100 · 50/100 · 52/100** sono una **rubrica
soggettiva a pesi**, che la fonte dichiara **non validata su storico**. In casa
nostra un numero non backtestato non è un numero: è un'opinione con la virgola.

### 🟡 B6 — MATERIALE VECCHIO DI 4 GIORNI, LETTO A SETTIMANA INIZIATA
Creato **23/08 pomeriggio**, letto **27/08**. Dei 7 eventi in calendario, **4
sono già passati** (compreso il Core PCE, il più pesante dopo Warsh). Le
strutture 1H descritte ("range compresso 25.911-26.130 nelle ultime sessioni")
sono **fotografie di domenica**: 4 sedute dopo possono non esistere più.
📌 **Il pre-market letto a mercato già corso non è più un pre-market.**

### 🟡 B7 — ORDINAMENTO SBAGLIATO NEL CALENDARIO DI C
La tabella di C elenca **"Ven 28/08 16:00 Warsh"** *prima* di **"Ven 28/08
14:30 CAD GDP"**. Le righe sono in ordine cronologico ovunque tranne lì. È un
errore **di ordinamento, non di valore** (i due orari coincidono con A §1.5) —
ma su una tabella che si legge di corsa per pianificare una giornata, una
riga fuori posto è un modo perfetto per sbagliare l'ora.

---

# ⭐ PARTE 2 — LA SEZIONE PER LA CASA

## 6. 🏠 COSA CI SERVE DAVVERO (e cosa no)

### 6.1 🗓️ IL CALENDARIO — **l'unica cosa con valore operativo immediato**

> 🔴 **Il picco di rischio evento è DOMANI, venerdì 28/08, ore 16:00 italiane
> = ~15:00 server BCM [ora INFERITA, fuso non dichiarato]. Non oggi.**

Oggi 27/08 è il **Day 1** del simposio: **nessun orario è dichiarato per
giovedì** in nessuno dei quattro documenti. Il documento indica il **keynote di
venerdì** come *"l'evento a rischio binario elevato per tutti gli asset"*.

**Cosa significa per la veglia della flotta — solo constatazioni:**
- Le nostre sedie girano **senza filtro news** (criterio R101: news OUT). È una
  scelta già firmata, non si riapre qui.
- La rete è il **Guardian**: pausa **4,0%** · emergenza **4,9%** e **9,9%** ·
  reset ore **23** (firma 18/08) + **S1 stop a obiettivo raggiunto**
  (`report/GUARDIAN_S1_2026-08-23.md`, default **spento**).
- Il **Guardian non sa cos'è Jackson Hole**: reagisce alla perdita, non
  all'evento. Domani pomeriggio la protezione è la stessa di sempre. Va **saputo**,
  non cambiato.
- 📌 **Uso corretto di questa informazione:** quando leggeremo i numeri di
  venerdì 28 e del lunedì successivo, **si leggono col contesto dell'evento**.
  Esattamente come già scritto in `ANALISI_LIVE_EMILIANO_2026-08-24.md`:
  _"Da sapere, non da agire: se le giornate fossero selvagge, i numeri di quei
  giorni si leggono col contesto."_
- ⚠️ **Slippage:** il referto della live del 24/08 registra Paolo che prende
  _"il doppio dello stop"_ su una candela news del DAX. Su una giornata di
  keynote Fed è lo scenario da tenere a mente per i nostri stop sugli indici.

### 6.2 📈 LIVELLI DAX/ORO COME **CONTESTO DI LETTURA** — non come parametro

> ⛔ **SCRITTO ESPLICITO, COME RICHIESTO: nessun parametro, nessuna soglia,
> nessuna taglia, nessun orario, nessun filtro di nessuna sedia viva si muove
> da questo materiale. Zero. Questi livelli servono a LEGGERE quello che
> succede, non a DECIDERE cosa fa un EA.**

**Perché la regola è questa e non è formalismo:** una sedia della flotta è
promossa da un round misurato su anni di storico e con una cella scelta al
centro dell'altopiano. Un livello weekly tracciato **a mano** (bandiera B3)
dentro un documento con **due R:R su tre non ricostruibili** (B1) e **punteggi
dichiarati non backtestati** (B5) non è materiale che possa toccare quella
catena nemmeno di striscio.

**DAX — sedia viva interessata:** `ABTG_MaxMinNotte_DAX_Short_Ottimizzato`
(magic **770411**, D30EUR **M15**, rischio 1,0 +0,65, DD promesso **1,27%**,
`CONTRATTI_SEDIE.md` riga 84). Forward: **+122,65 su 4 posizioni**
(`ANALISI_TRADEEXPORTER_2026-08-27.md`).
- Il materiale dà DAX **laterale/ribassista** verso 25.911,42, invalidazione
  sopra 26.520,93. **Il lato coincide con quello della sedia (short).**
- 🚨 **E qui va detta la cosa scomoda: la coincidenza di lato NON è una
  conferma.** È l'errore mentale più facile della settimana. La sedia opera su
  **M15 in finestra notturna**, orizzonte **incompatibile** con un bias weekly
  discrezionale. Se questa settimana andasse bene, **non sarebbe merito del
  bias ABTG**; se andasse male, **non sarebbe colpa sua**. Usare l'accordo come
  rinforzo sarebbe attribuire a una fonte esterna un merito che non ha.
- ✅ **Uso ammesso:** se la sedia lavora vicino a 25.911 o 26.521, sapere che
  lì c'è la **liquidità primaria weekly** aiuta a *capire* uno stop-hunt o un
  riempimento anomalo. **Lettura a posteriori, mai decisione a priori.**

**ORO — sedie vive interessate** (`CONTRATTI_SEDIE.md`, `FLOTTA_ATTIVA.md`):
| Sedia | Magic | TF | Rischio | DD promesso |
|---|---|---|---|---|
| `ABTG_SupertrendReversal_Ottimizzato` | 970901 | H4 | 1,0 | 9,0% (R99, 22 anni) |
| `SupertrendReversal_Multi_Ottimizzato` | — | H4 | — | PF bt 3,17 |
| `ABTG_EMA200_Ottimizzato` | 971501 | H4 | **0,25** | 11,5% (R100) |
| `ABTG_MaxMinNotte` (oro notte) | 770402 | — | **0,5** | 10,0% (R100) |
| `ABTG_PunteLarry` | 772343 | — | **0,3** | 9,0% (R100) |

- Il materiale dà oro **BULLISH 78/100**, estensione oltre **4.632,15**, area
  di ricarico **4.436,23-4.450,745**, invalidazione **sotto 4.324,68 in
  chiusura daily**, Extension Risk COT **LOW**, Managed Money in
  **ACCUMULATION** (+3.986 contratti, Pctl 88,8), OI **RISING +1,49%**
  (400.309 → 406.260).
- ✅ **Uso ammesso — uno solo, e vale la pena:** la fascia **4.324,68** è un
  livello di **cambio di regime dichiarato da terzi**. Le sedie oro H4 sono la
  concentrazione più pesante della flotta (12 grafici su XAUUSD,
  `FLOTTA_ATTIVA.md`). Se l'oro rompesse quella fascia e le sedie oro andassero
  in sofferenza contemporaneamente, **quel livello è un'ipotesi di spiegazione
  da verificare in casa** — non una previsione, non un trigger.
- ⚠️ **Nota di rischio nostra, indipendente dal materiale:** su un evento Fed
  binario, **12 grafici correlati sullo stesso strumento** si muovono insieme.
  Questo è già scritto in `FLOTTA_ATTIVA.md` (_"Concentrazione ORO altissima…
  tanta roba correlata sullo stesso strumento"_) ed è governato dal cap rischio
  aperto **3,25%** (C1, firma 18/08). Il materiale ABTG non aggiunge e non
  toglie niente a quel governo.

### 6.3 ⚖️ REGOLE PROP E CONSIGLI OPERATIVI — il confronto con quello che la casa sa per iscritto

**Regole prop citate nei PDF: 🔴 ZERO. Nessuna. Nessun drawdown, nessun target,
nessun daily loss, nessuna prop nominata, nessuna regola di consistency, nessun
tempo minimo in posizione.** Il confronto con `report/METRO_PROP.md` (le 12
domande) **non si può nemmeno impostare: il materiale non risponde a una sola
delle 12.** Questo va detto chiaro perché è la domanda che Claudio fa sempre.

**Consigli operativi presenti, e il confronto con la casa:**

| # | Consiglio ABTG (testuale) | Cosa dice la casa per iscritto | Esito |
|---|---|---|---|
| 1 | _"Il COT non è mai un trigger di ingresso — richiede sempre validazione tecnica H1 successiva"_ | La nostra regola gemella è la **separazione bias/misura**: nessuna promozione senza round. E l'**emendamento della finestra** (16/08): _"la regola di selezione va dichiarata insieme al numero"_ | 🟢 **Stessa filosofia**, applicata a oggetti diversi |
| 2 | _"No Chasing"_ / _"Pullback Only"_ su affollamento | Non abbiamo un equivalente misurato. È un **filtro di crowding**, concetto che nella nostra flotta **non esiste** | 🟡 **Buco nostro dichiarato** — nessuna azione, solo constatazione |
| 3 | Invalidazione **a chiusura Daily** (M1) | Convergente con la nostra diffidenza verso i tocchi intraday; ma i nostri EA lavorano su barre chiuse per costruzione | 🟢 Coerente |
| 4 | Sonda dello storico prima di usarlo (M8: _"294 osservazioni, nessun gap > 8 giorni"_) | **Identica** alla nostra regola misurata (R102: pavimento gen-1999 sondato, non assunto; regola 25/08 sugli indici: _"la profondità reale si MISURA, non si assume"_) | 🟢 **Convergenza metodologica vera** |
| 5 | _"per non introdurre soglie esterne"_ (M12) | Gemella della nostra _"i criteri si cambiano prima dei numeri, non dopo"_ (emendamento 16/08) | 🟢 **Convergenza vera** |
| 6 | Contraddizioni **dichiarate e non risolte forzatamente** (M10) | Gemella della **valvola R59**: _"il campione sottile sospende il giudizio sul MERITO, mai sul RISCHIO"_ | 🟢 **Convergenza vera** |
| 7 | Jackson Hole = _"rischio binario elevato"_, evento da evitare | `ANALISI_LIVE_EMILIANO_2026-08-24.md` + `ANALISI_LIVE_PAOLO_2026-08-25.md`: Paolo, testuale, _"giorni di altissima volatilità che non sai dove va il mercato […] non si fa quella"_ | ⚠️ **NON è una seconda fonte**: Paolo, Emiliano e questi PDF sono **la stessa accademia ABTG**. Una fonte, ripetuta |
| 8 | _"il bias prepara lo scenario, non autorizza l'ingresso"_ (M11) | La nostra versione: **una cella verde non è un edge finché non passa l'imbuto** | 🟢 Stessa frase, altro dominio |

---

## 7. 📋 IL QUARTO DOCUMENTO — "CHECKLIST DELLE CONFERME DI ENTRATA · MODULO OPERATIVO" (Emiliano Monza, FTD)

_Fonte: .docx caricato da Claudio; contenuto estratto e fornito al referto. Tutti i punti sotto sono **[DICHIARATO ABTG/FTD]**._
_⚠️ Nota di provenienza: **è la stessa firma** che sta sul WEEKLY COT OUTLOOK (Emiliano Monza). Documento diverso, **non fonte indipendente**._

### 7.1 🧱 LA STRUTTURA: 2 obbligatorie + 4 conferme, con soglia BINARIA

**Le 2 condizioni OBBLIGATORIE** (senza queste non si guarda nemmeno il resto):
1. **A favore del trend**
2. **Visione multi-timeframe a favore**

**Le 4 CONFERME** (se ne servono almeno 3):

| # | Conferma | Nota della fonte |
|---|---|---|
| C1 | **Ritest di struttura** | — |
| C2 | **Livello di Fibonacci coerente** | — |
| C3 | **Livello psicologico** (numero tondo / mezzo / quartile) | dichiarato **"meno discriminante"** |
| C4 | **Evidence** = pattern candela coerente (doji, morning star, engulfing) | — |

### 7.2 🔢 LA SOGLIA — il numero che rende il modulo meccanizzabile
> **Entrata ammessa SOLO con `2/2` obbligatorie **E** `≥3` conferme su 4.**

**Combinazione valida esplicitamente dichiarata:** **ritest + Fibonacci +
evidence**, anche **senza** il livello psicologico. (Coerente con l'aver
marcato C3 come la meno discriminante: è la conferma sacrificabile.)

📌 **Perché questo è il documento più interessante dei quattro:** è **l'unico
che contiene una soglia numerica binaria e riproducibile.** Gli altri tre
producono livelli e opinioni; questo produce **una regola con un `>=` dentro.**

### 7.3 ⚙️ LE REGOLE DI ESECUZIONE (i meccanismi)

| # | Regola | Tipo |
|---|---|---|
| E1 | **La zona si definisce PRIMA** | anti-improvvisazione |
| E2 | **Mai entrare al tocco** | anti-anticipo |
| E3 | **Attendere l'evidence sulla zona** | trigger separato dal livello |
| E4 | **Rieseguire la checklist alla comparsa dell'evidence** (non fidarsi del conteggio fatto prima) | ricontrollo obbligatorio |
| E5 | **Rinuncia senza esitazione sotto soglia** | regola d'astensione |

### 7.4 ❌ I 9 ERRORI DA EVITARE (dichiarati)
Fra quelli elencati: **una sola confluenza non basta** · **mai contro trend** ·
**FOMO** · **allentare le regole dopo le vincite** · **paura dopo le perdite** ·
**non confondere la checklist con il trading plan**.

🔎 Nota: gli ultimi tre sono **errori di disciplina umana**. Su un EA **non
esistono per costruzione** — un EA non ha FOMO e non allenta le regole dopo tre
vincite. È esattamente il motivo per cui in casa si è scelta la strada degli
expert (`ANALISI_TRADEEXPORTER_2026-08-27.md`: _"il comparto discrezionale ha
bruciato in 4 mesi più di quanto la flotta abbia mai rischiato in un giorno"_).

### 7.5 🎯 LA REGOLA FINALE (testuale)
> **"Se le conferme ci sono, entro. Se non ci sono, non entro. Punto."**

### 7.6 🏠 LE TRE LETTURE PER LA CASA

**(1) 🟢 LA FILOSOFIA È IDENTICA AI NOSTRI EA — e la convergenza è indipendente**

| Regola FTD | Come vive già nei nostri EA |
|---|---|
| soglia **binaria** (2/2 + ≥3/4) | i nostri EA entrano su **condizioni booleane**, non su "sensazioni" |
| **zona definita PRIMA** (E1) | i livelli sono calcolati **su barra chiusa**, prima del tick d'ingresso |
| **mai entrare al tocco** (E2) | è la differenza fra breakout puro e **retest** |
| **attendere l'evidence** (E3) | è la **candela di conferma**, non il livello |
| **rinuncia sotto soglia** (E5) | se il filtro non passa, l'EA **non apre**. Punto |

🔴 **E QUI C'È LA CONVERGENZA CHE VALE DAVVERO — da annotare, non da agire.**
Il meccanismo **"ritest di struttura + attesa dell'evidence"** (C1 + E2 + E3)
è **esattamente il meccanismo del nostro RETEST**. E il RETEST è, in questo
momento, **l'unico lato VERDE della famiglia Aperture DAX in forward**:

> `ANALISI_TRADEEXPORTER_2026-08-27.md`, testuale: _"Aperture DAX resta la
> famiglia in corsia MERITO (BUY −266,60 su 15 pos + SELL −392,22 su 9 +
> OTT −88,42; **RETEST +64,76 su 6: sempre verde**)."_

Due strade **arrivate per vie diverse alla stessa conclusione**: un didatta che
insegna "mai al tocco, aspetta il ritest e la conferma", e il nostro forward che
misura **+64,76 su 6 posizioni, sempre verde**, proprio sul lato retest mentre
i tre lati fratelli sono in rosso. ⚠️ **Il campione è di 6 posizioni: non prova
niente da solo** (soglia MERITO di casa: 20 operazioni). Ma è una convergenza
**da mettere agli atti**, perché quando due misure indipendenti puntano nella
stessa direzione, quella direzione merita il prossimo round, non il prossimo
dibattito.

**(2) 💡 SPUNTO PER IL VIVAIO — etichettato SPUNTO, non candidato**

> 🏷️ **SPUNTO. Non è un candidato, non è una proposta di round, non entra in
> nessuna coda.**

La **soglia a confluenze** (`ritest + fibo + evidence ≥ 3/4`) è, a differenza di
tutto il resto del materiale, **meccanizzabile**: sono quattro booleani e un
contatore. Sarebbe testabile come **FILTRO D'INGRESSO** su un motore d'apertura
in un round futuro **con criteri nostri**:
- gradini possibili: motore nudo · +1 conferma · +2 · **+3 (soglia FTD)** · +4;
- misura di casa: **≥150 operazioni** in IS (emendamento della finestra, punto A),
  cella al **centro dell'altopiano, mai il picco**;
- ⚠️ **prerequisito non negoziabile:** passa dal **`REGISTRO_TEST.md`** — la
  lista dei caduti — **prima** di entrare nell'imbuto, come ogni candidato
  (regola della seconda caccia, 19/08). Il capitolo breakout M5 DAX è già
  chiuso (`REGISTRO_TEST.md` riga 40): se lo spunto ci ricadesse dentro, muore lì.
- 🚩 rischio da dichiarare subito: **più filtri = meno operazioni**. Un filtro a
  3 conferme su 4 può portare un motore d'apertura sotto la soglia dei 150
  trade e renderlo **non misurabile**. Da verificare **prima** di spendere un round.

**(3) ⛔ NESSUN PARAMETRO VIVO SI MUOVE DA QUESTO MATERIALE.**
Non un filtro, non una soglia, non un orario, non una taglia. Il modulo FTD è
**didattica discrezionale per operatore umano**; la nostra flotta è codice
promosso da round misurati. Il ponte fra i due si costruisce **solo** con un
round, mai con una lettura.

---

## 8. ✅ COSA COPIAMO / COSA SCARTIAMO — il verdetto secco

| Elemento | Verdetto |
|---|---|
| **Data e ora di Warsh (ven 28/08, 16:00 IT ≈ 15:00 server)** | ✅ **SI TIENE** — unico contenuto con valore operativo immediato. Chiude il buco documentale del 24/08 |
| **Livelli DAX/oro/EURJPY/NZDUSD/EURUSD** | 🟡 **SOLO CONTESTO DI LETTURA** — mai parametro |
| **Meccanismi M1-M12 (soglie percentili, coerenza, staleness, no-chasing)** | 🟡 **ARCHIVIO METODOLOGICO** — griglia di lettura del COT, riproducibile se un giorno servisse |
| **Formule COT (Net %OI, Pair COT Index, percentile 260w)** | 🟡 **ARCHIVIO** — riproducibili, ma non abbiamo nessun motore che le usi |
| **Checklist FTD: soglia 2/2 + ≥3/4** | 💡 **SPUNTO PER IL VIVAIO** (§7.6.2) — l'unica cosa meccanizzabile del pacchetto |
| **Convergenza RETEST ↔ "mai al tocco + evidence"** | ✅ **AGLI ATTI** — nota di convergenza, campione 6 pos, non prova |
| **R:R dichiarati (1,7 / 2,5 / 1,1)** | ❌ **SCARTATI** — 2 su 3 non ricostruibili (B1) |
| **Punteggi /100** | ❌ **SCARTATI** — dichiarati non backtestati (B5), e non confrontabili fra loro (C3) |
| **Tutta §1.2 geopolitica + i tassi di §1.1** | ❌ **SCARTATI** — la fonte stessa li dichiara sotto lo standard di verifica (B4) |
| **Regole prop** | ⚪ **ASSENTI** — zero, non c'è niente da confrontare col METRO_PROP |
| **Bandiere anti-prop / martingala / griglia / no-SL** | ⚪ **NESSUNA** — materiale pulito su questo fronte |

---

## 9. ❓ LE DOMANDE PER CLAUDIO

1. **Il fuso del calendario.** Lo screenshot ForexFactory di Paolo era impostato
   su **ora italiana**? Se sì, Warsh = **15:00 server BCM** e chiudiamo il punto.
   Se era su ora EST/altro, **il numero cambia** e va rifatto.
2. **Il .docx di metodologia.** C rimanda due volte a
   `"Analisi_PreMarket_METODOLOGIA.docx"` e a "Allegato Metodologia M.1/M.2/M.3/
   M.5/M.7/M.3bis". **Quel file non è stato caricato.** È lì che stanno le
   definizioni delle soglie e la rubrica dei punteggi: senza, §B5 resta aperta.
3. **Gli screenshot TradingView.** A §4 dichiara che i grafici con i livelli
   tracciati sono **sul PC Windows di chi ha generato il report**
   (`C:\Users\bardolla_91\...`), non nei PDF. Se Claudio li avesse, il DAX a
   26.579 vs 26.520,93 (contraddizione C1) si chiarirebbe a occhio.
4. **L'infografica**: è materiale ABTG ufficiale o un riassunto fatto in casa da
   qualcuno del gruppo? Cambia se sia una quarta ripetizione o solo un appunto.
5. **Il modulo FTD**: esiste una versione con **backtest allegato** della soglia
   2/2 + ≥3/4, o è solo didattica? Se esistesse un dato, cambierebbe il peso
   dello spunto §7.6.2 da "idea" a "candidato".

---

## 🛑 CHIUSURA

> **NESSUNA AZIONE SULLA FLOTTA DERIVA DA QUESTO MATERIALE.**
>
> Nessun EA toccato. Nessun parametro modificato. Nessuna taglia cambiata.
> Nessun filtro acceso o spento. Nessun orario spostato. Nessuna sedia accesa,
> nessuna spenta. Nessuna soglia del Guardian rivista.
>
> Ciò che esce da qui è **una data da tenere a mente (venerdì 28/08 pomeriggio)**,
> **cinque insiemi di livelli da usare solo per capire cosa è successo**, e
> **uno spunto per il vivaio che dovrà passare dal registro dei caduti come
> tutti gli altri.**
>
> Il materiale esterno informa la lettura. **Non muove mai una manopola.**
