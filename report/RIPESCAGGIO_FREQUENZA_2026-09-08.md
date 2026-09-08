# 🎣 RIPESCAGGIO PER FREQUENZA — la rilettura sistematica degli scarti dopo la firma del 07/09

> # 🔢 **RIENTRANO IN CODA ALL'IMBUTO: 7 CANDIDATI.**
> # ⚠️ **VERDETTI DA RIFARE/RISCRIVERE (motivo misto o scritto male): 3.**
> # 🔴 **RESTANO FUORI COL MOTIVO GIUSTO: 35 righe del censimento corsia demo + 3 sedie dei `SCARTATI` di flotta + tutte le lapidi da sonda e da paper.**
>
> 🔴 **E la riga che viene prima di tutte: NESSUNO DI QUESTI SETTE VA IN CAMPO
> PER EFFETTO DI QUESTO REFERTO.** La regola firmata dice *"tornano in coda
> all'imbuto, **mai in campo in automatico**"*. Questo documento **non promuove,
> non accende, non tocca nessun EA, preset, magic o sedia viva. Decide Claudio.**

_Compilato l'**08/09/2026** in sola lettura d'archivio, su mandato che cita
Claudio testuale: **"troppi scarti che magari avrebbero retto il mercato"**,
**"magari tra quelli scartati abbiamo qualcuno che potrebbe davvero essere
utile"**._

---

## 0. 🧊 LE REGOLE DI LETTURA, CONGELATE PRIMA DEI NUMERI

1. **La firma del 07/09 cambia UNA cosa sola: l'unita' di misura.** Il pavimento
   resta **1,00 operazione/giorno**; si applica alla **FAMIGLIA** (motore ×
   simboli schierabili), non alla sedia. Fonte: `report/FIRME_2026-09-07.md`,
   `CLAUDE.md` §PAVIMENTO DI FREQUENZA.
2. 🛑 **Non tocca nessun criterio di RISCHIO.** Un DD accaduto vale a qualunque
   n e a qualunque unita'. Chi e' stato scartato per un drawdown **resta
   scartato, e non lo discuto**.
3. 🛑 **Non tocca nessun criterio di EDGE.** 0 celle positive, PF sotto 1,
   superficie di rumore, falsificazione contro ingressi casuali → **resta
   scartato**.
4. 🛑 **Non tocca la regola dei 150** (Emendamento della Finestra, punto A).
   Un candidato bocciato perche' il campione IS non arriva a 150 operazioni
   **non e' un caso di questo referto**: quella e' la regola del campione, non
   il pavimento di frequenza. È una distinzione che qui morde davvero (§3.3).
5. **Ogni numero ha il suo file, citato per nome.** Dove il numero non esiste
   la riga dice **NON MISURATO** e scrive **cosa servirebbe** per misurarlo.
6. **L'aritmetica di famiglia e' sempre esplicita:** `op/giorno per simbolo ×
   simboli schierabili`, e il numero di simboli che servono per arrivare a 1,00.

---

## 1. 🧮 IL CONTO, SUBITO E PER MOTIVO

| classe | quanti | dove sta |
|---|---:|---|
| 🟢 **scartato SOLO per FREQUENZA → rientra in coda all'imbuto** | **7** | §2 |
| 🟡 **motivo misto o dichiarato male → il verdetto va rifatto o riscritto** | **3** | §3 |
| 🔴 **scartato per RISCHIO (DD, stop assente, cumulo)** | almeno **12 righe nominate** | §4.1 |
| 🔴 **scartato per MANCANZA DI EDGE (falsificato, 0/N, PF<1)** | almeno **23 righe nominate + ~20 lapidi da sonda/paper** | §4.2 |
| 🔴 **scartato per CAMPIONE (< 150 op nell'IS)** — *non e' il pavimento* | **6 famiglie di eventi macro** | §3.3 |
| ⚪ fuori perimetro (sedie vive, lati di sedie vive) | 7 | §5 |

### 🔎 E una correzione a un documento di casa, dichiarata subito

`report/CORSIA_DEMO_CANDIDATI_v2.md` §1.2 scrive:
> _"Nel repo esiste **UNA SOLA** esclusione motivata SOLO dalla frequenza della
> sedia singola"_ (= G4 SuperWave DAX H4).

🔴 **Non e' esatto, e il conto di oggi lo mostra: sono SETTE.** Il v2 aveva
guardato il perimetro **delle sedie e dei candidati di casa**; le altre sei
stanno nei **dossier di caccia** (`CACCIA_FREQUENZA4_*`, `CACCIA_FREQUENZA5_*`,
`CACCIA_TFBASSO_FREQUENZA`) e in **un referto di sonda** (`REFERTO_SONDAM0PB`),
dove il cancello che le ha uccise si chiama **C2** o **F1** — cioe' lo stesso
pavimento, con un altro nome. **Il v2 non e' sbagliato: e' incompleto, ed e'
incompleto perche' cercava la frase e non il cancello.**

---

## 2. 🟢 RIENTRANO IN CODA ALL'IMBUTO — **7**, ordinati per vicinanza al 1 ottobre

> ⚠️ **"Vicinanza al 1 ottobre" significa: quanto manca perche' quella riga
> possa REGGERE UNA DECISIONE.** Chi ha gia' una cella promossa e un DD
> dichiarato sta in cima; chi ha bisogno di un round intero (o di un EA che non
> esiste) sta in fondo, **col costo scritto**.

---

### 🥇 R1 — **SUPERWAVE DAX H4** (`ABTG_SuperWave_DAX_H4_Ottimizzato`, magic 770512)

| voce | valore | fonte |
|---|---|---|
| **motivo dello scarto** | *"Fermato da **n 56 < 150** e dalla **frequenza della singola sedia** (~2,7 op/mese = **0,12 op/gg**, sotto il vecchio pavimento 1,00)"* | `report/CORSIA_DEMO_CANDIDATI.md` §2 G4 |
| **perche' e' frequenza-only** | n<150 **sospende il MERITO, non boccia** (Emendamento §A + valvola R59). Il **RISCHIO e' misurato e sta dentro i muri**. Quindi l'unica esclusione vera era il pavimento | `CLAUDE.md` §EMENDAMENTO |
| **cella promossa** | ✅ **validazione a TICK REALI 26/07**: `StMult 3,0 / TP_RR 2,0` | `backtest_pipeline/REGISTRO_TEST.md` **riga 477** |
| **numeri** | **profit +278 · PF 1,28 · DD 3,3% (a rischio 1%) · n 56** · 7/9 celle positive | idem |
| **op/giorno** | **0,12** (~2,7 op/mese) | `CORSIA_DEMO_CANDIDATI.md` §2 G4 |
| **peggior giornata** | 🔴 **NON MISURATA** — e con DD 3,3% e' *implicata* come pavimento, non provata (`R112`: *"PeggGio e' un PAVIMENTO — il muro prop guarda il FLOTTANTE"*) | `CORSIA_DEMO_CANDIDATI_v2.md` §2 |
| **stato in flotta** | 🔴 **NON IN CAMPO** (770512 assente da censimenti ed Esperti 25/08 22:15) | `FLOTTA_ATTIVA.md` |
| **cosa manca per il 1 ottobre** | **un preset** (in `mql5/Presets/` non esiste), **una compilazione**, un magic (770512 riusabile o nuovo). **ZERO EA da scrivere** | `CORSIA_DEMO_CANDIDATI_v2.md` §2 |

#### 🧮 L'ARITMETICA DI FAMIGLIA — **e non torna, e va detto**

| sedia SuperWave | op/giorno | fonte |
|---|---:|---|
| `ABTG_SuperWave_DOW_H1_Ott` **770511** (in campo) | **0,50** | `report/CENSIMENTO_CONTRATTI.md` r.135 (~10,8 op/mese, n 227) |
| `ABTG_SuperWave` H2 **770531** (in campo) | **0,18** | `CENSIMENTO_CONTRATTI.md` r.124 (~4 posiz./mese) |
| 🆕 `SuperWave DAX H4` **770512** (candidato) | **0,12** | sopra |
| **TOTALE FAMIGLIA** | **0,80** | |

> 🔴 **La famiglia SuperWave con il DAX H4 dentro fa 0,80 op/giorno: e' ANCORA
> SOTTO IL PAVIMENTO DI 1,00.** Per chiudere servono **+0,20 op/g**, cioe'
> **2 simboli in piu' a 0,12** oppure la cella **NASUSD H1** — la cui frequenza
> e' 🔴 **NON MISURATA** (screening OHLC 26/07: PF 1,26 · DD 2,0% · n 95, e la
> finestra dello screening non e' dichiarata nel registro).
> 👉 **Quindi il ripescaggio di R1 NON risolve da solo il pavimento della sua
> famiglia. Lo avvicina.**

🔴 **La contro-evidenza, scritta prima che la trovi qualcun altro:** la famiglia
SuperWave ha **due morti misurati** — GBPUSD (`R103_REFERTO_FINALE.md` pos. 23:
PF 0,79 · DD 13,4% · 5/7 anni negativi, spenta il 24/08) e il **lato short del
Dow** (R110: PF OOS 0,429). Il DAX H4 non e' mai stato smontato per lati.

---

### 🥈 R2 — **FAMIGLIA DEL GAP DI SESSIONE CASH** (D30EUR · U30USD · SPXUSD)

| voce | valore | fonte |
|---|---|---|
| **motivo dello scarto** | chiuso **per pura aritmetica di frequenza**: *"un gap di apertura e' UNO al giorno per costruzione: nessuna implementazione puo' superare il pavimento"* | `caccia_strategie/CACCIA_TFBASSO_FREQUENZA_2026-09-06.md` §1 · `CACCIA_FREQUENZA5_IMPLEMENTAZIONI_2026-09-03.md` §5.6 |
| **perche' e' frequenza-only** | ✅ **e' l'UNICA ragione** su DAX/Dow/S&P — verificato riga per riga | `CORSIA_DEMO_CANDIDATI_v2.md` §4.1 (*"l'unica riga che cambia colore in tutto il documento"*) |
| **strumento** | `mql5/Experts/ABTG_SondaGapCash.mq5` — **ESISTE e ha gia' girato** (prima compilazione 0 errori/0 avvisi) | `CORSIA_DEMO_CANDIDATI_v2.md` §3.3 |
| **op/giorno per simbolo** | **0,14** `[MISURATA su NASUSD]` | idem |
| **DD misurato** | 🔴 **NON MISURATO** su DAX/Dow/S&P — la sonda **conta occasioni, non apre ordini** | idem |
| **costo del passo che serve** | passo 0 conta-occasioni sui tick BCM, **un simbolo per volta** | idem |

#### 🧮 ARITMETICA DI FAMIGLIA
`0,14 op/g × N simboli ≥ 1,00` → **servono 8 simboli**.
Con i 4 indici che quotiamo (NASUSD + D30EUR + U30USD + SPXUSD) → **0,56 op/g**:
🔴 **ancora sotto il pavimento anche da famiglia.**

> 🔴 **E L'AVVISO CHE VIENE PRIMA DEL ROUND, ripetuto perche' e' pesante:**
> sull'unico simbolo portato ai tick BCM il meccanismo e' **MORTO PER SEGNO**
> il 07/09 — dato esterno **+0,0988%** evento contro **+0,0112%** controllo;
> tick BCM **−0,0487%** contro **−0,0134%**, **monotonia rotta 4 volte su 7**
> (`risultati_archivio/REFERTO_GAPCASH_PASSO0_2026-09-07.md`).
> **Rientra perche' la regola lo impone, non perche' prometta bene.**

---

### 🥉 R3 — **`IU Gap Fill Strategy` · l'ingresso alla RICONQUISTA CONFERMATA**

| voce | valore | fonte |
|---|---|---|
| **motivo dello scarto (03/09)** | testuale: *"Stesso tetto strutturale: **1 gap al giorno**, e in piu' filtrato a `pec_gap = 0.2%` → sui nostri indici restano poche sedute l'anno"* | `caccia_strategie/CACCIA_FREQUENZA5_IMPLEMENTAZIONI_2026-09-03.md` riga S18 |
| **perche' e' frequenza-only** | la riga non contiene nessun altro rilievo; anzi chiude con *"un pezzo da rubare, e lo scrivo perche' e' gratis"* | idem |
| **stato** | 🟢 **GIA' RIAPERTO oggi 08/09** da un'altra caccia, con la stessa motivazione della firma | `report/CACCIA_APERTURE_ORO_2026-09-08.md` §3 |
| **il pezzo che vale** | l'ingresso **NON e' all'apertura**: e' alla **riconquista confermata** (`low < chiusura_cash_ieri and close > chiusura_cash_ieri` + `barstate.isconfirmed`), con **stop vero** = trailing ATR×2 | `CACCIA_FREQUENZA5_IMPLEMENTAZIONI` S18 · `CACCIA_APERTURE_ORO` §3 |
| **perche' tocca un buco vero** | il ramo **gap-giu' → riconquista fallita → SELL** genera **DAX SHORT e DOW SHORT in apertura**, che nel censimento dei lati **non esistono** (770101, 770202, 770611 sono tutte SOLO LONG) | `prove/R52_CENSIMENTO_LATI.md` |
| **op/giorno** | 🔴 **NON MISURATA** — e' esattamente cio' che il passo 0 deve contare | `CACCIA_APERTURE_ORO_2026-09-08.md` §3 |
| **DD misurato** | 🔴 **NON MISURATO** | idem |
| **costo** | sonda `GAPCASH_RICONQUISTA` (**conteggio**, due lati, 3 indici) ≈ **mezza giornata** | `CACCIA_APERTURE_ORO_2026-09-08.md` r.445 |

#### 🧮 ARITMETICA DI FAMIGLIA
**Non calcolabile: manca il numeratore.** 1 gap/giorno per simbolo e' il tetto
teorico, ma il filtro `0,2%` lo taglia di quanto **nessuno ha mai contato**.
👉 **È la misura che manca, e per questo il file prova e' un CONTEGGIO, non una
griglia.** Con {D30EUR, U30USD, NASUSD} × {long, short} il pavimento e'
raggiungibile **solo se** la quota di sedute con gap ≥0,2% supera **~33%**.

---

### 4️⃣ R4 — **M27 · DERIVA OVERNIGHT CONTRO DERIVA INTRADAY sugli indici**

| voce | valore | fonte |
|---|---|---|
| **motivo dello scarto** | *"**(b) Frequenza: 1/giorno.** 🔴 **C2 fallita per definizione**"* | `caccia_strategie/CACCIA_FREQUENZA5_TASSONOMIA_2026-09-03.md` §M27 |
| **perche' e' frequenza-only** | il verdetto e' **C2**, e C2 e' il pavimento (li' a **≥2 segnali/giorno per lato**, cioe' **il doppio** di quello firmato). Non esiste nessuna misura contraria: **"IN CODA DAL 23/08, MAI MISURATO"** | idem |
| **evidenza esterna** | Knuteson, *"Strikingly Suspicious Overnight and Intraday Returns"*, **arXiv:2010.01727** · Lou, Polk & Skouras, **Journal of Financial Economics 134(1), 192-213 (2019)** | idem |
| **op/giorno per simbolo** | **1,00 per costruzione** (una finestra overnight al giorno) `[DERIVATA DALLA MECCANICA]` | idem |
| **DD misurato** | 🔴 **NON MISURATO** (nessuna corsa mai fatta) | idem |
| **cosa serve** | il **PASSO 0 e' gia' scritto** dal 23/08: *"rendimento medio e mediano di D30EUR fra le 16:30 e le 08:00 server, al netto dello spread misurato e dello swap reale"* | `report/SWEEP_MECCANISMI_2026-08-23.md` §5 N1 |
| 🔓 **cosa e' cambiato** | lo **spread notturno adesso e' MISURATO**: D30EUR fuori sessione **3,5-3,9 punti indice** (contro 1,6-1,7 in sessione). Il passo 0 e' **finalmente eseguibile con un numero vero al posto di una convenzione** | `risultati_archivio/SPREAD_FLOTTA_MISURA_2026-09-03.md` |

#### 🧮 ARITMETICA DI FAMIGLIA
`1,00 op/g × 1 simbolo = 1,00` → **basta UN simbolo.** Su 3 indici = **3,00
op/g**. 🥇 **È l'unico dei sette che supera il pavimento anche a UNITA' VECCHIA
(per sedia).** Il pavimento non era mai stato il suo problema vero contro la
firma del 07/09: era il C2 **a ≥2/giorno per lato** delle cacce.

🔴 **I due cartelli che vanno appesi accanto, e non sono misure ma nemmeno
opinioni:** (a) **swap ogni notte, 450 volte**, e il paper misura **lordi**;
(b) lo spread DAX di notte e' **piu' del doppio** di quello di sessione.
🎯 **E il valore vero per noi non e' un motore overnight: e' un BIAS
DIREZIONALE.** Se la deriva **intraday** degli indici e' negativa, e' un
argomento a favore del **lato SHORT intraday** — che e' il **buco n.1** del
portafoglio (`R52_CENSIMENTO_LATI.md`: quasi tutte le celle long-only, l'unica
short pura e' MaxMinNotte DAX).

---

### 5️⃣ R5 — **M0PB (Momentum Pull Back)** — *il ripescaggio che nessuno aveva visto, e il piu' scomodo*

> 🔬 **Questa riga e' il pezzo NUOVO di questo referto**, e la argomento con
> cura perche' contraddice due documenti di casa.

| voce | valore | fonte |
|---|---|---|
| **verdetto in archivio** | *"MORTO 12/12"* alla sonda di conteggio `ABTG_SondaM0PB` (contatore puro, **zero ordini**, corsa 31/08 19:35) | `risultati_archivio/REFERTO_SONDAM0PB_2026-08-31.md` |
| **i cancelli CONGELATI del passo 0** | **F1: < 1 segnale/giorno → scarto** · **F2: take mediano < 6,0 punti indice → scarto** | `backtest_pipeline/REGISTRO_TEST.md` r.706-707 · `prove/M0PB_FREQUENZA_BOZZA.txt` |
| **esito F2 (take)** | 🟢 **12/12 VERDI** (27-119 punti indice) | `REFERTO_SONDAM0PB` r.59 |
| **esito F1 (frequenza)** | 🔴 **0/12** contro la soglia **per lato** | `REFERTO_SONDAM0PB` r.44-45 |
| **esito H8 (RR ≥ 0,70, FIRMA 2 del 31/08)** | **7/12 sotto · 5/12 SOPRA**, a 0,712-0,743 | `REFERTO_SONDAM0PB` r.51 |

#### 🧮 I DODICI NUMERI, COPIATI DAL REFERTO (righe 35-40)

| corsa | lato | sig/gg | RR | H8 (≥0,70)? |
|---|---|---:|---:|:--:|
| U30_M5 | L / S | 0,504 / **0,520** | 0,677 / 0,679 | ❌ / ❌ |
| U30_M15 | L / S | 0,147 / 0,205 | **0,712** / **0,743** | ✅ / ✅ |
| **NAS_M5** | **L / S** | **0,492 / 0,500** | **0,716 / 0,739** | ✅ / ✅ |
| NAS_M15 | L / S | 0,187 / 0,167 | 0,539 / 0,697 | ❌ / ❌ |
| DAX_M5 | L / S | 0,451 / 0,490 | 0,625 / 0,693 | ❌ / ❌ |
| DAX_M15 | L / S | 0,211 / **0,172** | 0,679 / **0,718** | ❌ / ✅ |

#### 🎯 IL CONTO DI FAMIGLIA, CHE E' IL PUNTO

| aggregato | somma op/giorno | contro il pavimento 1,00 |
|---|---:|---|
| **NASUSD M5, due lati, un simbolo solo** | **0,992** | 🟡 al pelo |
| **le 5 celle che passano H8** (U30_M15 L+S, NAS_M5 L+S, DAX_M15 S) | **1,516** | 🟢 **SOPRA** |
| **M5 su 3 indici, due lati** (1,024 + 0,992 + 0,941) | **2,957** | 🟢 **quasi il triplo** |

> ### 🔴 E qui c'e' una cosa di metodo che va scritta, perche' e' una regola di casa
> Il referto uccide M0PB **anche** con questa frase: *"win rate necessario
> **62-70%** … la zona che in casa non ha mai pagato"* (`REFERTO_SONDAM0PB`
> r.51-54). 🛑 **Ma "62-70% di win rate" NON e' un cancello congelato.** Il
> cancello firmato e' **H8: RR ≥ 0,70** (`FIRME_2026-08-31.md` FIRMA 2), e
> **cinque celle lo passano**. Il win rate richiesto **e' la stessa cosa detta
> in un altro modo** (`p ≥ 1,075/(RR+1)`), aggiunta **dopo** aver visto i
> numeri. La regola di casa e' esplicita: **_"i criteri si cambiano prima dei
> numeri, non dopo"_** (`CLAUDE.md` §EMENDAMENTO).
> 👉 **Conclusione onesta: il certificato di morte di M0PB poggiava su F1
> (decaduta il 07/09) piu' un argomento non congelato. Non regge come
> bocciatura. NON significa che M0PB funzioni — significa che non e' stato
> misurato.**

🔴 **QUANTO COSTA DAVVERO, e per questo sta al 5° posto e non al 1°:**
- **DD: NON MISURATO. PF: NON MISURATO. Peggior giornata: NON MISURATA.** La
  sonda **non apre ordini**: di M0PB conosciamo **frequenza e geometria**, e
  **nient'altro**.
- **Non esiste un EA di casa**: esiste solo `ABTG_SondaM0PB` (contatore).
  Serve **scrivere l'EA** (motore gia' descritto: RSI(6) estremo nel verso +
  rientro su EMA(5), uscita al massimo mobile a 12 barre, stop 2,75·ATR(10),
  **un solo input libero**, due lati simmetrici) e poi **un round intero**.
- ⚠️ **Costo aggiuntivo dichiarato:** su **NASUSD M5** lo stop mediano e'
  **42,0-64,1 punti indice** — 🟢 **sopra il pavimento DURO (21-24 pt)** e
  **dentro/vicino a quello DI LAVORO (64-72 pt)** della frontiera del 06/09.
  Su **DAX M5** (44,3/58,4) e **U30 M5** (69,4/81,0) idem o meglio.
  *Non e' un motore che muore di spread come i breakout M5.*
- ⏱️ **Stima onesta del costo: EA nuovo + round a tick = giorni, non ore.
  🔴 NON e' materiale da 1 ottobre.**

---

### 6️⃣ R6 — **`RSI Ea MT5`** (MQL5 Code Base id 59303)

| voce | valore | fonte |
|---|---|---|
| **motivo dello scarto** | testuale: 🟠 ***"SCARTO PER FREQUENZA, e NON per difetto: e' il codice meglio scritto dei sette."*** | `caccia_strategie/CACCIA_FREQUENZA4_CB_PAPER_2026-09-02.md` §4.1 S4 |
| **perche' e' frequenza-only** | e' scritto **nella riga stessa**, ed e' l'unico scarto di tutta la battuta etichettato cosi' | idem |
| **cosa ha di buono (letto nel sorgente, 804 righe)** | ATR-stop `VolatilityFactorSL=2` / `VolatilityFactorTP=3` → **RR 1,5, passa H8**; **rischio in %** opzionale (`ENUM_RISK_BASE`); filtro di sessione; scale-out; legge **barra chiusa** (`CopyBuffer(..., 1, 2, ...)` r.643) | idem |
| **cosa lo ha ucciso** | grilletto di **coda**: `CurrentSignal > 20 && PreviousSignal <= 20` su `iRSI(14)` → *"non accade due volte al giorno: accade qualche volta al mese"*. Piu' **`MaxOpenPositions = 1`** | idem |
| **op/giorno** | 🔴 **NON MISURATA** — la stima *"qualche volta al mese"* e' `[DERIVATA DALLA MECCANICA]`, mai contata | idem |
| **DD misurato** | 🔴 **NON MISURATO** | — |

#### 🧮 ARITMETICA DI FAMIGLIA
🔴 **Non calcolabile: manca il numeratore.** `MaxOpenPositions = 1` fissa il
tetto a **1 posizione per istanza**, quindi la portata la fa **solo** il numero
di simboli. Se la frequenza fosse ~3 op/mese (≈0,14 op/g) servirebbero
**~7 simboli**; se fosse ~1/mese (≈0,046) ne servirebbero **22**.
👉 **Il passo che manca e' una SONDA DI CONTEGGIO** sullo stesso stampo di
`ABTG_SondaM0PB`, prima di scrivere qualunque cosa.

---

### 7️⃣ R7 — **`Power Hour Money Strategy` + `ICT Opening Gap Strategy [Momentum1]`** (primo taglio 02-03/09)

| voce | valore | fonte |
|---|---|---|
| **motivo dello scarto** | gruppo **"1 trade al giorno per costruzione"** → *"🔴 **C2 fallita per definizione**: un gap/una fascia/un livello di giornata da' un'occasione al giorno, non due"* | `caccia_strategie/CACCIA_FREQUENZA4_GH_TV_FF_2026-09-02.md` §4.4 |
| | `ICT Opening Gap`: *"scaricato ma **NON letto riga per riga**, e lo dichiaro. Scartato al primo taglio: stessa famiglia (**1 occasione/giorno**)"* | `CACCIA_FREQUENZA5_IMPLEMENTAZIONI_2026-09-03.md` §5.6 |
| **perche' e' frequenza-only** | il gruppo e' definito **dal cancello di frequenza**, e per questi due il sorgente **non e' mai stato aperto**: non esiste nessun altro rilievo, ne' a favore ne' contro | idem |
| **op/giorno** | 🔴 **NON MISURATA** (~1/giorno per costruzione, `[DERIVATA]`) | idem |
| **DD misurato** | 🔴 **NON MISURATO** | — |
| **costo del primo passo** | **leggere il sorgente riga per riga. Zero macchina, zero MT5.** | — |

#### 🧮 ARITMETICA DI FAMIGLIA
`~1,00 op/g × 1 simbolo` → in teoria **basta un simbolo**. 🔴 **Ma "in teoria"
non e' una misura**, e i due sorgenti non sono mai stati letti: potrebbero
cadere al §4 (griglia/no-SL/martingala) alla prima riga, come e' successo al
gemello `Gap Filling Strategy` (S17: **nessuno stop**, morto per il §4, non per
la frequenza).

> ⚠️ **Dei SEI titoli del gruppo "1 trade al giorno per costruzione", solo
> QUESTI DUE rientrano.** Gli altri quattro finiscono in §3.2 (tre cadono in
> famiglie chiuse da un numero) e in §4 (`Gap Filling Strategy` = §4, nessuno
> stop). **Non ho gonfiato il conto.**

---

## 3. 🟡 MOTIVO MISTO O DICHIARATO MALE — **3**, e vanno rifatti o riscritti

> _"Un verdetto che non dice perche' non e' un verdetto."_ Queste tre righe non
> rientrano e non restano fuori: **hanno un'etichetta sbagliata addosso.**

### 3.1 **M10 · Deriva oraria del forex** (EURUSD SHORT 08:00-16:00 server)

| ragione **DECADUTA** il 07/09 | ragione **CHE REGGE** | esito |
|---|---|---|
| *"**C2 non raggiunta su un simbolo solo**; si raggiunge **con piu' simboli**"* (`CACCIA_FREQUENZA5_TASSONOMIA` §M10) — 🔓 **e' letteralmente l'argomento della firma del 07/09** | 🔴 **l'ESECUZIONE**: *"Even 1 basis point will destroy the profitability"* — dichiarato **dall'autore del codice di replica** (`fx-bizday`, QuantRocket, Apache 2.0). Edge lordo **0,17-1,7 pip per gamba** contro ~1,0 pip di spread | 🟡 **NON DECIDIBILE** |

- 🟢 **Il merito, per completezza, e' misurato**: la cella A (EURUSD short
  08:00-16:00 srv, **la** previsione del paper) **passa il cancello C1 su
  ENTRAMBE le finestre** — IS +32,13 punti / C1 4,59 su **n 1.607**; OOS / C1
  **5,31** su **n 2.411** (`risultati_archivio/OROLOGIO_VS_BREEDON_2026-09-03.md`).
  **Campione pienissimo: qui il merito NON e' sospeso.**
- 🧮 **Aritmetica di famiglia:** 1 gamba/giorno per simbolo × i major che BCM
  quota (≥5) = **≥5,00 op/g**. 🟢 **Il pavimento non e' piu' un problema.**
- 🔴 **Cosa manca, ed e' tanto:** *"non esiste un EA, non esiste uno SL, non
  esiste un DD"* (`CORSIA_DEMO_CANDIDATI.md` §4 riga 10). E soprattutto:
  **lo spread BCM su forex e' NON MISURATO** (riga **H12** di `PIANO_PROP.md`,
  aperta da sette dossier di caccia). 👉 **Il killer dichiarato e' un COSTO, e
  il costo non l'abbiamo mai misurato: il verdetto poggia sulla parola di un
  autore esterno, non su un nostro numero.**
- ➡️ **Cosa serve per chiuderlo:** **H12** — lo spread forex BCM, misurato.
  Prima di quello, "morto per esecuzione" e' un'ipotesi, non una misura.

### 3.2 **I TRE titoli del primo taglio 02/09 che cadono in famiglie chiuse**

`ORB Heikin Ashi SPY 5min Correlation` (2.305 like) · `Mou Value Areas` ·
`Previous Day High Low only for Long` — `CACCIA_FREQUENZA4_GH_TV_FF_2026-09-02.md` §4.4.

- **Motivo SCRITTO:** *"C2 fallita per definizione"* = **solo frequenza**.
- **Motivo VERO, che esiste ma non e' nella riga:**
  - `ORB Heikin Ashi` → famiglia **ORB/breakout**, chiusa da **~210 celle a
    tick** (R45 **0/48**, R12 **48/48 OOS negative**);
  - `Mou Value Areas` → **value area**, morta su due gambe in casa
    (`ABTG_DaxValueArea`: tick-volume su CFD + fade dei bordi R42/R60,
    `GIACIMENTO_DI_CASA_2026-09-03.md` §6-7);
  - `Previous Day High Low only for Long` → **rottura di livello di giornata**,
    stessa famiglia, **piu' un lato solo senza ragione strutturale** (C7).
- ➡️ **Esito: RESTANO FUORI, ma la riga va RISCRITTA col motivo giusto.**
  Se resta com'e', al prossimo giro di firma qualcuno li ripesca — e sarebbe
  un ripescaggio sbagliato.

### 3.3 **Le sei famiglie di eventi macro "scartate per frequenza"** — 🔴 **e non e' il pavimento**

`CACCIA_POSTNEWS_ALTRE_FAMIGLIE_2026-09-04.md` §5:

| famiglia | numero | come e' scritto | cosa dice davvero |
|---|---|---|---|
| **BoE Official Bank Rate** | 8/anno, n 130 in 14 anni | *"frequenza fatale"* | 🔴 **sotto il pavimento di casa (IS ≥150 op)** — cioe' la **regola del campione**, non 1,00 op/g |
| **BoC Interest Rate** | 8/anno | *"orario buono, frequenza no"* | idem |
| **RBNZ** | 7/anno | | idem |
| **SNB** | 3,8/anno | *"con ≥150 operazioni per finestra servirebbero ~40 anni"* | idem — **il testo lo dice gia' bene** |
| **RBA** | 8/anno **+ ora server non fissa** | | 🔴 **misto**: c'e' anche un difetto d'orario misurato |
| **M30 pre-FOMC** | ~8 eventi/anno | *"C2 fallita di due ordini di grandezza"* | 🔴 **resta fuori anche da FAMIGLIA**: 8/anno × 3 simboli ≈ **0,10 op/g**, un decimo del pavimento (`CACCIA_FREQUENZA5_TASSONOMIA` §M30) |

> ✅ **ESITO: RESTANO TUTTE FUORI, e il verdetto e' giusto.** Ma il motivo va
> chiamato col suo nome: **e' l'Emendamento della Finestra (IS ≥ 150
> operazioni), che la firma del 07/09 NON tocca.** Chiamarlo "frequenza" invita
> un ripescaggio che la firma non autorizza. **Riscrivere l'etichetta costa
> zero e chiude la porta.**

---

## 4. 🔴 RESTANO SCARTATI — e non li discuto

_Perimetro di riferimento: `report/CORSIA_DEMO_CANDIDATI.md` §3 (**35 righe**,
confermate senza modifiche da `CORSIA_DEMO_CANDIDATI_v2.md` §4)._

### 4.1 🩸 Per **RISCHIO** — DD misurato fuori dai muri prop (10% totale / 5% giornaliero)

Le undici nominate una per una in `CORSIA_DEMO_CANDIDATI_v2.md` §4.2:

| candidato | il numero | fonte |
|---|---|---|
| `RELATIVO` gamba **D30EUR** | **DD OOS 25,01% + peggior giornata −5,20%** = due muri insieme · PF 0,452 | `REGISTRO_TEST.md` §R117 |
| `ABTG_LondonFx` EURUSD / GBPUSD | **DD OOS 37,14% / 55,03%**, controlli 31-61% | `risultati_archivio/r116_londonfx/` |
| `ABTG_AtrExhaustVol` | **DD 44,3-67,8%** su 6/6 celle, **peggior giornata −9,72%** | `risultati_archivio/R109_REFERTO.md` |
| `ABTG_AllineaLondra` EURUSD | **DD OOS 10,44%-46,62%**, 7/8 corse in perdita | `risultati_archivio/allinealondra/` |
| **FASE 2 Nasdaq** drive-following | **DD OOS 11,73% gia' a 0,65%** | `REFERTO_FASE2_CASSA_2026-08-30.md` |
| `CrossEmaApertura` (R96) | **DD 29-35%** | R96 |
| `ABTG_PTE` USDJPY 771323 | **DD 11,5%**, 3/7 anni negativi | `R103_REFERTO_FINALE.md` pos.17 |
| `ABTG_EasyTrend` AUDJPY 772423 | **DD 15,9%** | `R103_REFERTO_FINALE.md` pos.19 |
| `ABTG_CostToCost` XAGUSD 772363 | **DD 16,4%**, 6/7 anni negativi | `R103_REFERTO_FINALE.md` pos.24 |
| `ABTG_SuperWave` GBPUSD 770532 | **DD 13,4%**, 5/7 anni negativi | `R103_REFERTO_FINALE.md` pos.23 |
| `Nasdaq_Apertura_US` breakout 770201 | **DD 17%** a tick, 19/20 celle OOS negative | `report/CONTRATTI_SEDIE.md` r.45 |

➕ **Tre righe di rischio che aggiungo io, perche' qualcuno potrebbe provare a
farle passare per "lente":**

| candidato | motivo | fonte |
|---|---|---|
| `ABTG_SupRev_DOW_H1_Ottimizzato` **970916** | 🔴 **RISCHIO: DD 9,8-10% a rischio 1%** — etichetta d'archivio *"❌ DD troppo alto"* / *"DD 10%"*. 🛑 **Compare in coda nel `CORSIA_DEMO_CANDIDATI_v2` §3.1, ma per il CRITERIO 1 (il TF H1 ammesso), NON per la frequenza.** Non e' materiale di questo referto e non lo ripesco | `FLOTTA_ATTIVA.md` §SCARTATI · `risultati_archivio/CLASSIFICHE.md` r.14 |
| `ABTG_SupRev_DOW_H4` **970914** / `SupRev_CAC_H4` **970915** | 🔴 **EDGE: promozioni REVOCATE**, PFmed a tick **0,79** e **0,96** contro OHLC 2,58 e 7,37 = *illusione OHLC* | `FLOTTA_ATTIVA.md` §SCARTATI |
| `ABTG_GapFill` **772234** U30USD | 🔴 **RISCHIO di portafoglio: esclusa da R37 per il CUMULO DEL LUNEDI'** (porta 100k chiusa). ⚠️ Fa **0,069 op/g**: sembra un caso di frequenza **e non lo e'** | `report/CENSIMENTO_CONTRATTI.md` r.150 |

### 4.2 🧪 Per **MANCANZA DI EDGE** — falsificati con una misura

Le righe 1-3, 7-15 e 23-35 di `CORSIA_DEMO_CANDIDATI.md` §3, piu' le ~20 lapidi
di §3.4. **Non le riscrivo: comanda quel documento.** I capisaldi:

- `ABTG_VwapRevert`: **S0 negativo su 4 celle su 4** (−0,11 / −0,21 / −0,14 / −0,21)
- **FADE degli estremi del range** (R42): **0/48**, IS **e** OOS, n 195-333
- **Londra ORB** (R45): **0/48** · **Rimbalzo ORL/ORH** (R43): **0/8 + 0/8**
- **R95 sweep+reclaim JPY**: **0/30**, con 21.354 livelli creati (*non e' fame di segnali*)
- `ABTG_CRT_TurtleSoup`: **0/30** a tick, e **il gate ADX non salva** (0,459 gated vs 0,462 ungated)
- **Micro-pivot sweep M5/M15**: delta contro ingressi **CASUALI** della stessa geometria **−0,2 punti su 22.616 segnali**
- **Compressione ATR → espansione**: delta contro il caso **−1,2 punti su 9.723 segnali** *(⚠️ la meta' "frequenza" del suo certificato di morte E' decaduta il 07/09 — l'altra meta' no, e basta lei)*
- **Lead-lag S&P→DAX M5**: frequenza **PASSAVA** (2-7/gg), **8/8 celle negative al netto**
- **Numeri tondi (Osler)**: 93.000+ segnali, **5 letture su 6 negative**
- **Asta LBMA sull'oro**: **72 celle su 72 negative**
- **RSI+EMA V8**: il filtro RSI toglie **9-13%** degli incroci EMA su 7 corse = e' un incrocio di medie travestito
- **RTH Confluence / London Signal B**: **irriproducibili** (classificatore GMM mai pubblicato)
- **Fix valutari (JF 2024)**: quota di rientro **0,038-0,082** → il fade non esiste

---

## 5. ⚪ FUORI PERIMETRO — non sono scarti

Le sette righe di `CORSIA_DEMO_CANDIDATI.md` §5 (sedie vive, lati e dial di
sedie vive), **invariate e non contate**. In particolare:

- **`ABTG_GapContinuation` 774101** (Nikkei M1) fa **~3,7 op/mese** ed e'
  descritta come *"passeggero per fascia oraria, non portata"* — 🔴 **ma e' IN
  CAMPO dal 16/08**, quindi non e' uno scarto (`FLOTTA_ATTIVA.md`).
- **Le 5 sedie `ABTG_GapFill`** (772231-235) sono **SOSPESE per campione**, non
  scartate. Somma di famiglia misurata: `0,028 + 0,032 + 0,041 + 0,069 + 0,055`
  = **0,225 op/g** → per arrivare a 1,00 servirebbero **~22 simboli**
  (`CENSIMENTO_CONTRATTI.md` r.147-151). Numero utile da avere davanti quando
  si parla di "allargare la famiglia".
- **EMADOW lato SHORT** (R110: PF OOS 1,891 · n 302 · DD 2,66%): **lato di una
  sedia VIVA**, non uno scarto. Portarlo in campo e' **una firma di Claudio**,
  non una conseguenza della regola del 07/09.

---

## 6. 🧮 LA TABELLA DELL'ARITMETICA — tutti i sette in una schermata

| # | candidato | op/g **per simbolo** | simboli **misurati** | totale famiglia **oggi** | simboli per **1,00** | DD misurato | cella promossa |
|---:|---|---:|---:|---:|---:|---|---|
| R1 | **SuperWave DAX H4** | **0,12** | 1 (+2 vive: 0,50 · 0,18) | **0,80** 🟡 | **+2 simboli** a 0,12 | 🟢 **3,3%** @1% tick | 🟢 **SI** (tick 26/07) |
| R2 | **Gap sessione cash** | **0,14** | 1 (NASUSD) | **0,14** · 4 indici → 0,56 🔴 | **8** | 🔴 NON MISURATO | 🔴 no |
| R3 | **IU Gap Fill / riconquista** | 🔴 **NON MISURATA** | 0 | 🔴 n/c | 🔴 n/c | 🔴 NON MISURATO | 🔴 no |
| R4 | **M27 overnight→intraday** | **1,00** `[DERIVATA]` | 0 (mai girato) | **1,00** 🟢 (3 indici → 3,00) | **1** | 🔴 NON MISURATO | 🔴 no |
| R5 | **M0PB** (5 celle H8-pass) | 0,147-0,500 | 3 indici × 2 TF ✅ misurati | **1,516** 🟢 | **gia' sopra** | 🔴 NON MISURATO | 🔴 no (solo sonda) |
| R6 | **`RSI Ea MT5`** (CB 59303) | 🔴 **NON MISURATA** | 0 | 🔴 n/c | ~7 se 0,14 · ~22 se 0,046 | 🔴 NON MISURATO | 🔴 no |
| R7 | **Power Hour + ICT Opening Gap** | ~1,00 `[DERIVATA]` | 0 | 🔴 n/c | ~1 in teoria | 🔴 NON MISURATO | 🔴 no |

> ### 🔴 LA RIGA CHE CLAUDIO DEVE LEGGERE DUE VOLTE
> **Dei sette che rientrano, UNO SOLO ha una cella promossa e un DD dichiarato:
> `SuperWave DAX H4`.** Gli altri sei hanno **zero DD misurato**: non sono
> candidati per il 1 ottobre, sono **righe in coda all'imbuto**. E anche R1
> **non chiude da solo il pavimento della sua famiglia** (0,80 contro 1,00).

---

## 7. 💰 QUANTO COSTA OGNI RIGA — perche' il mandato lo chiede esplicitamente

| # | il primo passo che serve | macchina? | costo dichiarato | fonte del costo |
|---:|---|---|---|---|
| R1 | preset + magic + compilazione | ❌ nessun backtest | **ore**, zero round | `CORSIA_DEMO_CANDIDATI_v2.md` §2 |
| R1-bis | *(opzionale)* misurare la **peggior giornata** e i **due lati** del DAX H4 | ✅ tester | **un round corto** (l'EA e' compilato) | — |
| R2 | passo 0 conta-occasioni, **un simbolo per volta**, tick BCM | ✅ tester | **minuti per simbolo** (sonda gia' compilata) | `CORSIA_DEMO_CANDIDATI_v2.md` §3.3 |
| R3 | sonda `GAPCASH_RICONQUISTA` (conteggio, 2 lati, 3 indici) | ✅ tester | **mezza giornata** | `CACCIA_APERTURE_ORO_2026-09-08.md` r.445 |
| R4 | passo 0 gia' scritto dal 23/08 (rendimento 16:30→08:00 su D30EUR, netto spread **misurato** e swap **reale**) | ✅ tester | **una sonda** | `SWEEP_MECCANISMI_2026-08-23.md` §5 N1 |
| R5 | **scrivere l'EA** (non esiste) + round a tick con split IS/OOS | ✅✅ | 🔴 **giorni** — *non e' materiale da 1 ottobre* | questo referto §2 R5 |
| R6 | **sonda di conteggio** sullo stampo di `ABTG_SondaM0PB`, prima di scrivere qualunque cosa | ✅ tester | **una sonda**, poi porting | questo referto §2 R6 |
| R7 | **leggere i due sorgenti riga per riga** | ❌ **zero macchina** | **un'ora di lettura** — e puo' chiudersi li' (come S17, morto al §4) | `CACCIA_FREQUENZA4` §4.4 |

🥇 **Il piu' economico in assoluto e' R7** (zero macchina), 🥇 **il piu' vicino
a essere utile e' R1** (ore, e l'EA e' gia' compilato), 🥉 **il piu' promettente
sui numeri gia' in mano e' R5 — e costa di piu' di tutti.**

---

## 8. 🎯 IL RIASSUNTO, IN CINQUE RIGHE

1. 🟢 **Rientrano SETTE, non uno.** Il conto di casa (`CORSIA_DEMO_CANDIDATI_v2`)
   ne dichiarava **uno** perche' cercava **la frase** *"scartato per frequenza"*;
   cercando **il cancello** (`C2` nelle cacce, `F1` nelle sonde, *"pavimento"*
   nella tassonomia) ne escono **sette**.
2. 🥇 **Uno solo e' pronto in ore**: `SuperWave DAX H4` (**DD 3,3% a tick**,
   PF 1,28, n 56, EA gia' compilato). 🔴 **Ma anche con lui dentro, la famiglia
   SuperWave fa 0,80 op/g: sotto il pavimento.** Il ripescaggio lo avvicina,
   non lo chiude.
3. 🔬 **Il pezzo nuovo e' M0PB**: le **5 celle su 12 che passano il cancello
   H8 congelato** sommano **1,516 op/g di famiglia** — sopra il pavimento — e
   il loro certificato di morte poggiava su **F1 (decaduta)** piu' un argomento
   *(win rate 62-70%)* **aggiunto dopo i numeri**, che la regola di casa non
   ammette. 🔴 **Non significa che funzioni: significa che non e' mai stato
   misurato.** DD, PF e peggior giornata: **zero**.
4. 🛑 **Restano fuori tutti quelli che dovevano restarci**, e con numeri veri:
   **DD dal 9,8% al 67,8%**, **0/48 · 0/30 · 0/8 celle positive**, **delta
   contro ingressi casuali negativo su 32.339 segnali**. **Su questi non si
   spende un altro round.** E tre righe che sembravano "lente" sono in realta'
   scartate **per rischio** (`SupRev DOW H1`, `GapFill 772234`) o **per edge**
   (`SupRev DOW/CAC H4`): le ho messe in chiaro apposta.
5. 🔴 **E la risposta alla domanda che Claudio ha fatto quattro volte, senza
   sconti: SI, c'era del materiale buttato per il motivo sbagliato — ma non e'
   una flotta, sono sette righe, e SEI DELLE SETTE NON HANNO UN DRAWDOWN
   MISURATO.** Il lavoro di misura **non** era gia' pagato per loro: era pagata
   solo la **frequenza**. Quello che e' davvero pronto per il 1 ottobre e' **una
   riga sola**, e va comunque in **coda all'imbuto**, come dice la firma.

---

## 9. ⚠️ COSA QUESTO REFERTO NON COPRE — dichiarato

- 🔴 **Non ho riletto le esclusioni motivate dal TF.** Non e' il mio mandato:
  quella rilettura e' gia' fatta in `CORSIA_DEMO_CANDIDATI_v2.md` §1.1
  (criterio 1, M30/H1 ammessi) ed e' **a saldo zero verdi**.
- 🔴 **Non ho aperto nessun sorgente esterno** (R6 e R7 restano `[LETTO NEI
  DOSSIER]`, non `[VERIFICATO DA ME]`). Per R7 il sorgente **non e' mai stato
  aperto da nessuno**, e la riga lo dichiara.
- 🔴 **Non copre lo spread forex e oro**: riga **H12** di `PIANO_PROP.md`,
  **NON MISURATO**, aperta da sette dossier. Tocca direttamente §3.1 (M10) e
  R6. Ogni giudizio di costo qui dentro vale **solo sui tre indici**.
- 🔴 **Non copre il regime.** Tutti i numeri a tick sugli indici vengono da
  **21 mesi di UN SOLO REGIME (toro)**: pavimento tick BCM **2024.09.26**.
- 🔴 **Non copre la correlazione.** Il **tetto per cluster al 3,0%** e'
  **firmato il 07/09, implementato (Guardian v1.13) ma SPENTO DI DEFAULT, NON
  COMPILATO E NON COLLAUDATO** = **non e' una protezione**. E la firma gemella
  (famiglia = piu' simboli) rende quel buco **piu' probabile**: 🔴 **quella che
  allarga e' attiva, quella che protegge no.**
- 🔴 **Nessuno di questi sette e' un contratto.** Se uno va in demo, il suo **DD
  promesso** e la sua **frequenza promessa** vanno scritti in
  `report/CENSIMENTO_CONTRATTI.md` **prima** che apra la prima posizione, con
  le quattro righe di `report/CORSIA_DEMO_REGOLE.md` — altrimenti il criterio
  di uscita del 18/08 **non e' applicabile**.

---

## 10. 📮 COSA MANCA E CHI LO PORTA

| # | buco | chi | domanda esatta |
|---:|---|---|---|
| 1 | **peggior giornata di `SuperWave DAX H4`** e i **due lati** (regola 25/08) | 🤖 agenti (round corto, EA gia' compilato) | *"qual e' la peggior giornata sull'equity della cella `StMult 3,0 / TP_RR 2,0` su D30EUR H4, e cosa fa il lato short?"* |
| 2 | **frequenza di `SuperWave NASUSD H1`** | 🤖 agenti | *"quante op/giorno fa la cella NASUSD H1 sulla finestra tick 2024.09.26 → 2026.06.30?"* — 🎯 **e' il numero che decide se la famiglia SuperWave arriva a 1,00** |
| 3 | **conteggio del gap con riconquista ≥0,2%** su 3 indici, 2 lati | 🤖 agenti (sonda) | *"quante sedute l'anno hanno un gap cash ≥0,2% seguito da riconquista confermata?"* |
| 4 | **passo 0 di M27** (overnight vs intraday) | 🤖 agenti | *"rendimento medio e mediano di D30EUR fra 16:30 e 08:00 server, al netto dello spread 3,5-3,9 MISURATO e dello swap REALE"* |
| 5 | **sorgenti di `Power Hour Money Strategy` e `ICT Opening Gap`** | 🤖 **cacciatore-strategie** | *"passano il §4 (stop vero, niente griglia/martingala/no-SL) e il C7 (due lati)? Se no, si chiude qui e costa zero macchina"* |
| 6 | **sonda di conteggio per `RSI Ea MT5`** | 🤖 **cacciatore-strategie** | *"quanti segnali/giorno/lato fa `RSI(14) che rientra sopra 20` sui nostri simboli, e su quanti simboli servirebbe per 1,00?"* |
| 7 | **spread BCM su forex e oro** (riga **H12**) | 🤖 agenti + 👤 Claudio (una corsa) | senza, **M10 resta non decidibile** e R6 non ha un cancello di costo |
| 8 | **le tre etichette da riscrivere** (§3.2 e §3.3) | 🤖 agenti (sola scrittura) | *"riscrivere il motivo vero nelle righe di `CACCIA_FREQUENZA4` §4.4 e `CACCIA_POSTNEWS_ALTRE_FAMIGLIE` §5, cosi' nessuno le ripesca al prossimo giro"* |
| 9 | 🔴 **LA DECISIONE** | 👤 **Claudio, e solo lui** | *"dei sette, quali entrano in coda all'imbuto e con che priorita'? E R1 va in corsia demo sul piccolo **50503392** (`C:\Program Files\BCM Markets MT5 Terminal`), oppure resta in coda?"* |

---

_Compilato in sola lettura d'archivio. **Nessun EA, preset, sedia, magic o
parametro di forward e' stato toccato. Nessun backtest lanciato. Nessuna
promozione. Nessun candidato va in campo per effetto di questo referto.**
Se un referto e questo documento divergono, **comanda il referto**._
