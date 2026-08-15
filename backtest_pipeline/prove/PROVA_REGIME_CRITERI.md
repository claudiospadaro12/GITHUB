# PROVA DI REGIME — criteri scritti PRIMA dei dati (14/08/2026)

_Richiesta di Claudio: "rifacciamo i calcoli con qualche anno in piu', anche
quando il mercato era in fase calante, per capire se entrano altri EA o se
qualcuno deve uscire". Sono d'accordo: e' il test che oggi manca di piu'
(vedi `report/ASPETTATIVE_REALISTICHE.md`, "IL LIMITE DELLA FINESTRA"). Ma
un test cosi' puo' distruggere lavoro buono se i criteri si scrivono dopo
aver visto i numeri. Quindi si scrivono adesso, e non si spostano._

## 1. Cosa si testa (e cosa NON si tocca)

- Si testano **le celle GIA' PROMOSSE**, esattamente come sono: parametri
  **CONGELATI**, nessuna ottimizzazione, nessuna griglia. Una cella = un
  lancio.
- **Vietato** cercare parametri nuovi sui dati vecchi: sarebbe overfitting
  su una finestra piu' lunga, cioe' lo stesso errore con piu' anni.
- Perimetro: le famiglie con dati esterni affidabili (forex e metalli: BB,
  GAP, LARRY, COST, EasyTrend, PTE/SW forex). Gli INDICI entrano solo se
  il feed esterno passa la validazione (vedi punto 2).

## 2. Cancello ZERO: senza validazione del feed, non si guarda nulla

L'import produce un referto di sovrapposizione (differenza media fra le
chiusure H1 importate e quelle NATIVE di BCM nel periodo comune). Regola:

- differenza media > **0,05% del prezzo**, oppure meno dell'**80%** delle
  barre H1 in comune -> **il simbolo NON si usa**. Prima si sistema il feed
  (fuso, festivi, fonte), poi si misura.

  **CORREZIONE DICHIARATA (14/08, prima di guardare qualunque numero di
  performance).** La prima stesura diceva "2 points": era un'unita' di
  misura sbagliata, non una soglia severa. Due points su EURUSD sono 0,2
  pips, cioe' MENO dello spread: nemmeno due feed dello stesso broker la
  soddisferebbero. La soglia in percentuale di prezzo vale identica su
  EURUSD, oro e indici. Con la soglia corretta: EURUSD_EXT 0,0041% e
  GBPUSD_EXT 0,0052% passano larghi (copertura 99,6%, zero proprieta'
  guaste). La correzione riguarda la QUALITA' DEI DATI, non il merito
  delle strategie, ed e' stata fatta a P/L non ancora osservati. Decisione
  delegata da Claudio ("fai come e' meglio").
- Il confronto di merito si fa **SEMPRE sullo stesso feed**: periodo
  calante vs periodo crescente **sui dati _EXT**, mai "_EXT 2022 contro
  BCM 2025". Spread e commissioni diversi rendono il confronto assoluto
  fra feed privo di significato; il confronto RELATIVO dentro lo stesso
  feed invece regge.

## 3. Le finestre (fissate ora)

| Finestra | Periodo | Che cos'e' |
|---|---|---|
| **ORSO** | 2022.01.01 - 2022.10.31 | mercato calante + inflazione: il buco vero del nostro campione |
| **CROLLO** | 2020.02.01 - 2020.04.30 | shock Covid: volatilita' estrema, gap, spread larghi |
| **TORO** | 2021.01.01 - 2021.12.31 | anno di riferimento crescente, per il confronto relativo |
| **LATERALE** | 2019.01.01 - 2019.12.31 | quarto contesto, se i dati arrivano fin li' |

## 4. I criteri di giudizio (congelati)

Per OGNI cella promossa, misurata a rischio 1% su 100k:

**A. SOPRAVVIVENZA (il minimo sindacale).** Nelle finestre ORSO e CROLLO
il drawdown non deve superare **il doppio** del DD misurato nella finestra
OOS originale, **e comunque mai il 20%**. Chi sfonda entrambe le finestre
avverse va **declassato**: peso dimezzato, oppure gli serve un filtro di
regime prima di tornare a peso pieno.

**B. TENUTA.** Nelle finestre avverse il PF deve restare **>= 0,90**.
Attenzione, e' un criterio di NON-SANGUINAMENTO, non di profitto:
**quasi tutte le nostre celle sono long-only**, ed e' NORMALE che un
long-only guadagni poco o niente in un mercato che scende. Bocciare un
long-only perche' non guadagna nell'orso sarebbe un errore di lettura;
bocciarlo perche' si distrugge, no.

**C. PROMOZIONE DI RANGO.** Chi nell'ORSO fa **PF >= 1,10** con DD dentro
il criterio A sale di rango: e' un motore che lavora in entrambi i regimi
-> priorita' in prop e candidato al peso pieno. **Questi sono gli EA che
cerchiamo davvero**, ed e' anche il modo per far entrare in squadra
qualcuno che oggi e' in panchina.

**D. REGOLA DEI DUE BANCHI.** Nessuna decisione (ne' uscita ne'
promozione) da UNA sola finestra: serve la stessa direzione in ORSO e
CROLLO. Un solo periodo avverso e' un aneddoto.

**E. RIPESCAGGI.** Le celle oggi in panchina o in osservazione (riserve
regime della fascia B, gap Dow/Nikkei, Easy Trend, EURGBP short) si
rimisurano con gli stessi criteri: se superano A e C, tornano in gioco
con un round di portafoglio dedicato — **non entrano per simpatia**.

## 5. Cosa questo test NON puo' fare

- Non rende i dati esterni buoni per TARARE: la taratura resta su BCM.
- Non copre gli indici se il feed non passa il cancello zero.
- Non trasforma 21 mesi in 8 anni di certezze: aggiunge **contesti**, non
  garanzie. Il DD peggiore possibile resta sconosciuto per definizione.
- Non sostituisce il forward: il vivaio continua per la sua strada.

## 6. Sequenza operativa

1. Import + referto di validazione (agente in corso).
2. Cancello zero su ogni simbolo: passa / non passa.
3. Lancio delle celle congelate sulle 4 finestre (round **R50**).
4. Tabella unica: cella x finestra -> Profit, PF, DD, n.
5. Verdetti secondo A-E, referto, e SOLO DOPO le decisioni su squadra e
   portafoglio.

## APPROVATO (Claudio, 14/08/2026)

> "Voglio fare i controlli del caso. Ci servono piu' anni. Ce la dobbiamo fare."

I criteri A-E sopra sono **CONGELATI da questo momento**. Non si spostano
per nessun motivo, nemmeno se i numeri faranno male a un EA a cui teniamo:
e' esattamente il momento in cui una regola scritta prima vale qualcosa.
Da qui in avanti ogni verdetto della prova di regime cita il criterio che
lo produce.

---

## CORREZIONE DICHIARATA n.2 — il criterio B parlava di celle che non ci sono

**Fatta il 14/08/2026 sera, a R50 in corso e a NUMERI NON ANCORA VISTI.**
Nata da una domanda di Claudio: *"se un EA e' tarato solo su long, il test
valuta se lo short sarebbe potuto entrare?"*.

Andando a controllare i lati veri delle 8 celle in prova, viene fuori che
**nessuna e' long-only**:

| cella | lati | da dove |
|---|---|---|
| BB_GBPUSD, BB_EURUSD | **entrambi** | `ABTG_BreakingBand` non ha nemmeno gli input `InpAllowLong/Short`: opera nei due sensi per costruzione |
| GAP_GBPUSD, GAP_EURUSD | **entrambi** | idem per `ABTG_GapFill` |
| PTE_GBPUSD | entrambi | default `InpAllowLong=true`, `InpAllowShort=true` |
| SW_GBPUSD | entrambi | idem |
| EZ_GBPUSD | entrambi | scritto esplicitamente nella cella |
| LARRY_GBPUSD | **SOLO SHORT** | `InpAllowLong=0; InpAllowShort=1` nella cella |

Il criterio B diceva: *"quasi tutte le nostre celle sono long-only, ed e'
NORMALE che un long-only guadagni poco o niente in un mercato che scende"*.
**Per queste otto celle e' falso.** Sette lavorano nei due sensi e una e'
short-only.

### Cosa cambia, in concreto

- **La clemenza del criterio B qui NON si applica.** Un motore che opera in
  entrambi i sensi e nell'orso 2022 fa PF sotto 0,90 non ha l'attenuante
  "e' long-only": sta sbagliando in un mercato in cui poteva anche guadagnare.
  La correzione rende il giudizio **piu' severo**, non piu' morbido: e'
  l'unica direzione in cui e' lecito correggere un criterio dopo il via.
- **LARRY va letto al contrario.** E' short-only: l'orso 2022 e il crollo
  2020 sono il SUO terreno. Se non guadagna li', e' un dato pesante; se
  guadagna SOLO li', e' un motore di regime e va etichettato cosi', non
  promosso come motore per tutte le stagioni.
- La frase originale del criterio B resta valida per **altre** parti del
  portafoglio (le celle sugli indici), che pero' in R50 non ci sono perche'
  HistData non ha gli indici.

### Perche' era sbagliata

L'avevo scritta al mattino ragionando sul portafoglio nel suo insieme,
**senza aprire il file delle celle**. E' lo stesso errore di metodo della
giornata: dedurre invece di leggere.


---
---

# 📐 EMENDAMENTO 1 — IL CAMPIONE MINIMO (15/08/2026)

_Richiesta di Claudio: "non pensi che dobbiamo abbassare leggermente i
parametri di valutazione? Rischiamo di scartare EA che sarebbero
profittevoli"._

**Aveva ragione, ma il difetto non era dove pensavamo lui e io.** Non erano
le soglie a essere troppo severe: era che **le stavamo applicando a campioni
che non esistono**.

## E.1 Il conto che ha fatto scattare l'emendamento

Operazioni per cella, nelle due finestre avverse di R56:

| finestra | celle con **n >= 20** | con n 8-19 | con **n < 8** |
|---|---|---|---|
| **ORSO 2022** | **7** su 14 | 3 | 4 |
| **CROLLO 2020** | **1** su 14 | 6 | **7** |

> 🚨 **Sulla finestra CROLLO, UNA sola cella su quattordici ha un campione
> sufficiente** (`COST_EURJPY`, n=23). Sette celle stanno **sotto le otto
> operazioni**.
>
> E su quei numeri erano stati scritti dei verdetti: `PTE_USDJPY` "le due
> finestre dicono il contrario" poggiava su **n=7**; `LARRY_GBPUSD` su
> **n=3**. **Non avevamo un test del crollo Covid: avevamo l'illusione di
> averlo.**

## E.2 LA REGOLA (vale dal prossimo round)

Per **ogni cella, in ogni finestra**, prima di leggere qualunque numero di
merito si guarda `n`:

| campione | cosa si puo' dire |
|---|---|
| **n >= 20** | ✅ **verdetto pieno**: i criteri A-E si applicano |
| **8 <= n <= 19** | 🟡 **VERDETTO SOSPESO — campione sottile.** Il numero si scrive, la decisione no |
| **n < 8** | ⬜ **NON MISURATO.** La finestra e' scoperta per quella cella |

**La soglia 20 non e' inventata: e' gia' la nostra.** In R48 `EURGBP` fu
bocciato pur avendo la cella migliore in entrambe le finestre, *"solo perche'
in campione ha 14 trade invece dei 20 richiesti"*. Lo stesso numero, con la
stessa severita', anche quando ci farebbe comodo il contrario.

### ⚠️ E.3 LA VALVOLA — il campione sottile sospende il MERITO, mai il RISCHIO

Questa distinzione e' il cuore dell'emendamento: senza, la regola diventerebbe
una scappatoia.

| grandezza | che cos'e' | vale a n basso? |
|---|---|---|
| **PF, profitto, payoff** | una **STIMA** su un campione | ❌ sotto n=20 e' rumore |
| **Drawdown, peggior giornata** | un **FATTO ACCADUTO** | ✅ **SI', sempre** |

**Un drawdown del 18,9% e' successo.** Non e' un'inferenza statistica, e non
si annulla dicendo "erano solo tre trade". Quindi **il tetto assoluto del
criterio A (mai oltre il 20%) vale a QUALUNQUE n**, e una cella che si
distrugge resta declassata anche con campione sottile.

> **Si sospende il giudizio su "quanto e' bravo", mai su "quanto puo' farmi
> male".**

### E.4 Retroattivita', asimmetrica

L'emendamento si applica ai referti gia' scritti **SOLO per SOSPENDERE
verdetti**, **mai per emetterne di nuovi**.

- Togliere un verdetto = ammettere di non sapere -> **sempre lecito**.
- Aggiungerne uno dopo aver visto i numeri = **mai**: e' la cosa che il metodo
  esiste per impedire.

## E.5 Cosa cambia in R56, applicando la regola

| cella | prima | dopo |
|---|---|---|
| `COST_EURJPY` | D non passa | ✅ **REGGE** — unica con entrambe le finestre piene (43 e 23). Il PF 0,02 nel crollo e' **vero** |
| `COST_GBPCAD` | declassato | ✅ **REGGE** — orso n=48 pieno, **piu'** il DD 18,9% che vale a qualunque n |
| `PTE_USDJPY` | "le due finestre dicono il contrario" | 🟡 **SOSPESO** — il crollo era **n=7** |
| `LARRY_GBPUSD` | D non passa | 🟡 **SOSPESO** — crollo **n=3** |
| `EZ_CHFJPY` · `EZ_GBPUSD` | tenuta persa nel crollo | 🟡 **SOSPESI** — n=9 e n=10 |
| `EZ_AUDJPY` · `SW_GBPUSD` | tengono | 🟡 tenuta confermata **solo nell'ORSO** (n=35 e n=51) |
| `BB_*` · `LARRY_ORO` | non giudicabili | ⬜ confermato **NON MISURATO** |
| `PTE_GBPUSD` | promosso -> ritirato da R57 | 🟡 sarebbe stato **SOSPESO comunque**: crollo n=11 |

> 🔍 **La nota che conta**: la promozione di PTE sarebbe caduta **per due
> strade indipendenti** — il modello (R57) e il campione (questo
> emendamento). Due controlli diversi che dicono la stessa cosa valgono piu'
> di due indizi.

## E.6 EMENDAMENTO 2 — la finestra CROLLO e' troppo corta, e si sdoppia

Tre mesi non bastano per accumulare venti operazioni: e' un **difetto di
progetto della finestra**, non delle strategie. Ma allungarla diluirebbe lo
shock, che e' proprio cio' che vogliamo misurare. Quindi si sdoppia, coerente
con la valvola E.3:

| finestra | periodo | a cosa serve |
|---|---|---|
| **CROLLO** | 2020.02.01 - 2020.04.30 | **il RISCHIO**: drawdown e peggior giornata, che valgono a qualunque n |
| **CROLLO_ANNO** *(nuova)* | 2020.01.01 - 2020.12.31 | **il MERITO**: PF e profitto, con abbastanza operazioni per contarli |

Le altre tre finestre restano **identiche**. Nessun altro criterio si muove.

---

**Firmato prima di rilanciare qualunque cosa.** Le celle vive in forward non
cambiano di un parametro per questo emendamento.
