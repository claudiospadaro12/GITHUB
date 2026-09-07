# 🚦 CORSIA DEMO — **RILETTURA v2** con i due criteri nuovi del 07/09

_Compilato il **07/09/2026 (notte)** su mandato diretto di Claudio, testuale:_
> **"non una, QUANTE NE TROVATE. Piu' sono, meglio e'. Cosi' facciamo poi una
> selezione."** — e poco prima: **"vanno bene anche gli EA in M30 ed H1."**

> 🧊 **REGOLA DI LETTURA, congelata prima della tabella.** Questo documento
> **non promuove niente, non tocca nessuna sedia, non accende nessun EA, non
> lancia nessun backtest.** E' una **RILETTURA** di
> `report/CORSIA_DEMO_CANDIDATI.md` (07/09, 4 🟢 / 35 🔴 / 11 🟡) con **due
> criteri nuovi**, e **non sostituisce il primo documento**: sta accanto, cosi'
> si vede **cosa e' cambiato e perche'**. Dove il numero non esiste in archivio
> la riga dice **NON MISURATO**. **Decide Claudio.**

---

# 0. 🧮 IL CONTO NUOVO — SUBITO, E ONESTO

| colonna | v1 (07/09 mattina) | **v2 (07/09 notte)** | delta |
|---|---:|---:|---|
| 🟢 **PRONTO SUBITO** (numeri gia' in mano, va in demo domani) | 4 | **4** | **= 0** |
| 🟠 **SERVE UN ROUND** (prima serve una corsa che non e' mai stata fatta) | 11 _(erano "🟡 non decidibili")_ | **14** | **+3** |
| 🔴 **MORTO, e resta morto** | 35 | **35** | = 0 |
| ⚪ fuori perimetro (sedie vive / lati di sedie vive) | 7 | 7 | = 0 |

## 🔴 LA RIGA CHE CLAUDIO DEVE LEGGERE PER PRIMA

> **I 🟢 restano QUATTRO. I due criteri nuovi NON hanno prodotto nemmeno un
> verde in piu'** — e questo documento spiega, riga per riga, **perche'**.
> Quello che i due criteri hanno prodotto e' **+3 righe nella coda "SERVE UN
> ROUND"**, e **una colonna nuova sui quattro verdi che prima non c'era**: il
> **conto del costo secondo la FRONTIERA del 06/09** (`stop >= 40 x spread`).

**Perche' non ci sono verdi nuovi, in due frasi:**
1. **Nessun candidato in archivio e' mai stato scartato "per il solo TF".**
   Ho cercato la frase e la sostanza: le morti a M5/M15 sono morti da **DD
   fuori dai muri** (11,7% → 67,8%) o da **falsificazione con controllo**
   (delta contro ingressi casuali negativo su 32.339 segnali). La frontiera
   del costo **non le riapre**, perche' non erano morti da costo.
2. **Nel repo esiste UNA SOLA esclusione motivata SOLO dalla frequenza della
   sedia singola** — ed e' gia' stata riletta nel v1: e' **G4 SuperWave DAX H4**
   (`report/CORSIA_DEMO_CANDIDATI.md` §2, G4, riga _"Rilettura 07/09"_).
   La firma del 07/09 aveva gia' fatto il suo lavoro **prima** che questo
   documento nascesse.

⚠️ **E non ho gonfiato il conto.** Un candidato "verde solo a M30" senza nessun
round a M30 **non e' un 🟢**: sta in **SERVE UN ROUND**, come dice il mandato.
Le due code sono separate apposta.

---

# 1. 🧭 I DUE CRITERI NUOVI — cosa hanno mosso DAVVERO

## 1.1 📐 CRITERIO 1 — M30 e H1 sono ammessi, e la FRONTIERA DEL COSTO lo sostiene

**La fonte, citata col percorso:**
`backtest_pipeline/caccia_strategie/CACCIA_TFBASSO_FREQUENZA_2026-09-06.md` §6
(la frontiera) + `backtest_pipeline/risultati_archivio/SPREAD_FLOTTA_MISURA_2026-09-03.md`
(gli spread, **252 milioni di tick BCM**, 2024.09.26 → 2026.06.30, solo-bid 0,000%).

| simbolo | ore server | spread mediano **[MISURATO]** | 🧱 pavimento **DURO** (13,3×) | 🎯 pavimento **DI LAVORO** (40×) |
|---|---|---:|---:|---:|
| **NASUSD** | 14-20 | **1,6 - 1,8** pt indice | 21 - 24 pt | **64 - 72** pt |
| **U30USD** | 14-20 | **1,9 - 2,0** pt indice | 25 - 27 pt | **76 - 80** pt |
| **D30EUR** | 8-16 | **1,6 - 1,7** pt indice | 21 - 23 pt | **64 - 68** pt |
| **D30EUR notte** | fuori sessione | **3,5 - 3,9** pt indice | 47 - 52 pt | 140 - 156 pt |
| **forex / oro** | — | 🔴 **NON MISURATO** (H12 aperta) | — | — |

> 🎯 **La riga della frontiera:** _"Il timeframe delle barre e' gratis. La taglia
> del rischio non lo e'."_ Gli stop misurati in casa a **M5 (20,0 pt)** e
> **M15 (17,4 pt)** stanno **sotto anche al pavimento DURO**. Il primo TF la cui
> volatilita' naturale entra nella banda di lavoro e' **M30**.

### ✅ Cosa ha prodotto, in concreto

- **Una colonna nuova sui quattro 🟢** (§2): per ciascuno ho messo accanto lo
  **stop/take misurato in punti indice** e il rapporto contro lo spread
  **misurato dell'ora in cui lavora**. Due dei quattro hanno il numero, uno lo
  ha a meta', uno **non ce l'ha** — e lo dico.
- **Una riga nuova in SERVE UN ROUND**: `SupRev DOW H1` (§3.1), che e' un
  motore **H1 a tick reali, mai in campo**, fermo dal 26/07 e che il criterio
  "H1 e' ammesso" rimette esattamente sul tavolo.

### ❌ Cosa NON ha prodotto — verificato uno per uno, non a memoria

| candidato riletto a M30/H1 | cosa dice la misura | esito della rilettura |
|---|---|---|
| **Breakout / ORB M5 in apertura** (27/27 combo negative) | non e' morto di costo: R42 **0/48 IS e OOS** su campioni 195-333, R45 **0/48**, R97 **0/4** | 🔴 **resta rosso** (C4 seconda caccia: cambiare TF a un motore falsificato **e'** un parametro diverso) |
| **Micro-pivot sweep M5/M15** | frequenza **PASSAVA** (4,2-4,6/gg): a ucciderlo e' il **delta contro ingressi CASUALI della stessa geometria = −0,2 punti su 22.616 segnali** | 🔴 **resta rosso** — falsificazione indipendente dal costo |
| **Compressione ATR → espansione** | delta contro il caso **−1,2 punti su 9.723 segnali**, 7/8 sotto il cancello RR | 🔴 **resta rosso** (vedi §4: la meta' "frequenza" del suo certificato di morte **e' decaduta**, l'altra meta' no) |
| **BreakingBand a M30** | 🔬 **gia' misurato a M30**, R111: gradiente **H1 > M30 > M15** monotono su 3 simboli, ma **0/3 al cancello di merito**; su GBPUSD M30 il campione e' **PIENO** (IS 181 / OOS 174) e **l'IS e' negativo** | 🔴 **resta rosso** — e il referto lo dice: _"niente M45, niente M30 ritoccato"_ |
| **EMA200 H1 su altri indici** (l'idea piu' veloce del lotto: la sedia gemella `771531` fa **1,55 op/g**, la piu' veloce della flotta) | 🔬 **capitolo gia' CHIUSO da R32**: 4 simboli misurati a walk-forward tick (U30USD 30/30 PASS · EURUSD 7/30 · XAUUSD **0/30 con IS rosso** · 225JPY **30/30 IS → 0/30 OOS**, ribaltamento di regione intera). Testuale: _"scendere oltre nella classifica sarebbe pesca a strascico… si riapre solo con una TESI nuova"_ | 🔴 **resta chiuso** — un'altra lista di simboli **non e' una tesi nuova** |
| **GoldenCross a H1 sui top OHLC** (Oro 2,01 · USDJPY 1,97 · GBPUSD 1,78) | 🔬 **gia' misurato e chiuso**: **R20, 0/6 celle a tick reali H1**; USDJPY IS rosso 3/3 con OOS verde 3/3 = _"regime, non edge"_. ⚠️ La riga _"tick reali H1 ancora da fare"_ in `risultati_archivio/CLASSIFICHE.md` e' **VECCHIA (01/08) e superata da R20 (10/08)** | 🔴 **resta chiuso** — e questa e' una **correzione**: la classifica in archivio prometteva un round che era gia' stato fatto e perso |
| **Lead-lag S&P→DAX M5** | frequenza ottima (2-7/gg), ma sulla finestra **giusta** (08:00-16:00 server) fa **−0,0613R netti**; era +0,0332R solo con **l'orologio sbagliato** | 🔴 **resta rosso** — e il meccanismo e' un lead-lag a 5 minuti: a M30 non esiste per costruzione |

## 1.2 📊 CRITERIO 2 — il pavimento di frequenza e' per FAMIGLIA (firmato 07/09)

**Fonte:** `report/FIRME_2026-09-07.md` — _"firmo il punto 1, lancia l'orologio"_.
Il pavimento resta **1,00 op/giorno**; cambia **l'unita'**: FAMIGLIA (motore ×
simboli schierabili), non sedia. Misura che lo motiva: conto vero con statistiche
**calcolate da MQL5** (`caccia_strategie/CONFIG_PROP_FREQUENZA_2026-09-06.md`,
portafoglio Profalgo `signals/2204998`): **3-5 EA · 26 simboli → 0,29-0,47
op/giorno PER SIMBOLO**.

### 🔎 Il fatto che rende questo criterio grosso, e che va detto

**Nel censimento dei contratti (`report/CENSIMENTO_CONTRATTI.md`) le sedie VIVE
girano a 0,028 - 0,50 op/giorno.** Una sola supera il pavimento da sola:
`ABTG_EMA200` U30USD H1 **771531 = ~1,55 op/g**. 👉 **Se il pavimento fosse
ancora per sedia, quasi tutta la flotta viva sarebbe fuori regola.** La firma
del 07/09 non allarga un cancello: **allinea il cancello a come la flotta e'
gia' fatta.**

### ✅ Cosa ha prodotto

- **Una riga nuova in SERVE UN ROUND**: la **famiglia del gap di sessione cash**
  su **D30EUR / U30USD / SPXUSD** (§3.3). Nel cimitero delle cacce il gap
  intraday era chiuso **per pura aritmetica di frequenza** — _"un gap di
  apertura e' UNO al giorno per costruzione: nessuna implementazione puo'
  superare il pavimento"_ (`CACCIA_TFBASSO_FREQUENZA_2026-09-06.md` §1). **Quel
  veto e' decaduto**: 1 gap/giorno × 13 strumenti = famiglia sopra il pavimento.
  🔴 **Ma con un avviso pesante**: sull'unico simbolo misurato sui tick BCM
  (NASUSD) **il segno si e' rovesciato** il 07/09.

### ❌ Cosa NON ha prodotto — le esclusioni frequenza-only, cercate e contate

| oggetto | la frequenza era **una** delle ragioni? | l'altra ragione regge? | esito |
|---|---|---|---|
| **G4 SuperWave DAX H4** | ✅ era **l'unica** (0,12 op/g contro 1,00) | — | 🟢 **gia' promosso nel v1** |
| **M0PB** (Momentum Pull Back) | ✅ **F1 0/12**, lato migliore 0,52 segnali/gg | ✅ **H8 (RR≥0,70): 7/12 sotto**, i 5 sopra stanno a 0,70-0,74 = **win rate richiesto 62-70%** | 🔴 **resta rosso** |
| **Compressione ATR → espansione** | ✅ 0/8 sopra il pavimento (0,55-1,87/gg) | ✅ **7/8 sotto H8** + delta contro il caso **−1,2 pt** su 9.723 segnali | 🔴 **resta rosso** |
| **RTH Confluence / London Signal B** | ✅ 0,72 e 0,31 trade/giorno | ✅ **irriproducibili**: il cuore e' un classificatore GMM mai pubblicato | 🔴 **resta rosso** |
| **Fix valutari** (Krohn-Mueller-Whelan JF 2024) | ✅ 0,2 eventi/giorno | ✅ **quota di rientro 0,038-0,082** → il fade non esiste | 🔴 **resta rosso** |
| **Gap intraday / gap-fill** | ✅ **era l'UNICA ragione** (chiusura per aritmetica) | ❌ nessun'altra sul DAX/Dow/S&P | 🔓 **→ SERVE UN ROUND** (§3.3) |

> 🧊 **La regola di casa che non si tocca, ripetuta qui perche' e' esattamente
> il punto:** _"il campione sottile sospende il giudizio sul MERITO, mai sul
> RISCHIO"_. Un DD accaduto vale a qualunque n, e a qualunque unita' di misura
> del pavimento di frequenza.

---

# 2. 🟢 PRONTO SUBITO — **4**, ordinati per FREQUENZA ATTESA (decrescente)

_Perimetro invariato dal v1: rischio superato con una misura a tick, fermati
solo da merito sospeso (n<150), pavimento di frequenza per sedia, o un cancello
che chiedeva una misura che non avevamo._
**Cosa manca e' identico per tutti e quattro: un PRESET (nessuno esiste in
`mql5/Presets/`), un MAGIC nuovo, una COMPILAZIONE. ZERO EA da scrivere.**

| # | candidato | TF | **op/giorno** | **DD MISURATO** | pegg. giornata | n | 🆕 **frontiera del costo (criterio 1)** | cosa manca |
|---:|---|---|---:|---|---|---:|---|---|
| 🥇 | **RELATIVO NASUSD** (z-score NASUSD/U30USD) | **M5** (metro U30USD) | **0,525** [MISURATO] | **8,40%** OOS a 0,65% | **−2,12%** | IS 87 / OOS 154 | 🔴 **stop in punti NON MISURATO** — `InpAtrSL=2,75×ATR(M5)` e l'ATR(M5) di NASUSD non e' in archivio. **E' la domanda aperta sul piu' veloce dei quattro** | preset · magic nuovo · compilazione · ⚙️ **pacchetto in preparazione da un altro agente** |
| 🥈 | **NY SESSION RETEST** slope 75 (VWAP di seduta, Dow) | **M15** + trend **H1** | **~0,25** (~5,4 op/mese) | **3,7 - 4,7%** | **−0,69%** | 114-115 | 🟡 **perdita mediana −58,0 pt indice** contro spread U30USD **1,95** = **29,7×**. ✅ sopra il pavimento **DURO** (13,3×) · ❌ sotto quello **DI LAVORO** (40×). Pedaggio **0,0336R = 45% del cancello H8** | preset · magic nuovo (769503 e' del round) · compilazione |
| 🥉 | **DAX REENTRY, lato LONG** (break 40 / break 20) | **M5** | **~0,17** (3-4 op/mese per lato) | **2,5 - 4,6%** | **−0,67 / −0,68%** | 57 / 92 | 🟢 **take mediano LONG +76,8 pt indice** (n=71) contro spread D30EUR **1,65** = **46,5×** → **sopra il pavimento DI LAVORO**. ⚠️ la frontiera e' definita sullo **STOP**: il take e' un **proxy**, lo stop in punti resta **NON MISURATO** | preset **LONG-ONLY** · magic nuovo · compilazione |
| 4️⃣ | **SUPERWAVE DAX H4** (EMA14×200 + Supertrend) | **H4** | **~0,12** (~2,7 op/mese) | **3,3%** a 1% | **NON MISURATA** ⚠️ | 56 | 🟢 **passa per costruzione**: SL = Supertrend a `StMult 3,0` su ATR(H4), ordini di grandezza sopra i 64-68 pt | preset · compilazione · magic (770512 riutilizzabile o nuovo) |

### 🆕 Le tre cose che la rilettura AGGIUNGE ai quattro verdi

1. 🟡 **NY RETEST sta in mezzo alla frontiera, e va scritto.** Il suo stop
   (perdita mediana 58 punti indice) supera il pavimento duro ma **non** quello
   di lavoro: il pedaggio si mangia **il 45% del cancello H8**. Non e' una
   bocciatura — e' un **numero che prima non era accanto al candidato**, e che
   dice quanto margine ha davvero.
2. 🔴 **RELATIVO NASUSD e' l'unico dei quattro senza il numero del costo.**
   Il piu' veloce del lotto e' anche quello di cui **non sappiamo quanti punti
   indice rischia**. E' una misura da chiedere, non un difetto scoperto.
3. ⚠️ **La peggior giornata di SUPERWAVE DAX H4 non e' mai stata misurata.**
   La leggo come **implicata** — un DD totale del **3,3%** e' un tetto per la
   peggior giornata sull'equity **realizzata**, quindi il muro giornaliero del
   5% e' fuori portata. 🔴 **Ma resta un PAVIMENTO, non una prova**: R112 lo
   scrive nero su bianco — _"PeggGio = peggior giornata dei CHIUSI, un
   PAVIMENTO — il muro prop guarda il FLOTTANTE"_.

🔴 **Le riserve del v1 restano tutte, e vanno ripetute ogni volta:** la gamba
**D30EUR** del RELATIVO e' **BOCCIATA PER RISCHIO** (DD OOS 25,01%, peggior
giornata −5,20%) → in demo va **solo NASUSD**; il lato **SHORT** del DAX
REENTRY e' **misurato e morto** (PF 0,38-0,54, DD 8,8-23%) → **long-only, e
scritto nel preset**; la famiglia **SuperWave** ha **due morti misurati**
(GBPUSD R103 e lato short del Dow R110).

---

# 3. 🟠 SERVE UN ROUND — **14** (11 dal v1 + **3 nuovi**), per frequenza attesa

> ⚠️ **Nessuno di questi e' un 🟢.** Hanno bisogno di **una corsa che non e'
> mai stata fatta** prima che si possa dire se il rischio sta dentro i muri.
> Metterli in demo adesso significherebbe scoprire in sei mesi una cosa che il
> banco dice in venti minuti.

## 3.1 🆕 **SupRev DOW H1** (`ABTG_SupRev_DOW_H1_Ottimizzato`, magic 970916) — **il piu' veloce della coda**

| voce | valore |
|---|---|
| **Come e' entrato** | 🆕 **CRITERIO 1**: e' un motore **H1**, e H1 adesso e' ammesso |
| **EA** | `ABTG_SupRev_DOW_H1_Ottimizzato` — **ESISTE ED E' COMPILATO** (creato il 26/07 dalla validazione a tick) |
| **Simbolo / TF** | **U30USD** · **H1** · `StMult 3,5 / AtrP 9 / TP_RR 3,0` |
| **Il numero che gli da' un "perche'"** | **VALIDATO A TICK REALI il 26/07: PF 1,20 · profit +560 · n 273** — fonte `backtest_pipeline/REGISTRO_TEST.md` §"VALIDAZIONE REAL-TICK SupRev nuovi indici" |
| **n** | **273** → 🟢 **il MERITO e' MISURABILE a pieno titolo** (≥150). E' **l'unico** di tutta la corsia demo che non ha il merito sospeso |
| **DD MISURATO** | **9,8%** a rischio **1,0%** — 🔴 **margine dal muro del 10%: 0,2 punti.** Etichetta in archivio: `risultati_archivio/CLASSIFICHE.md` r.14, _"❌ DD troppo alto"_ · `FLOTTA_ATTIVA.md` §SCARTATI, _"DD 10%"_ |
| **Peggior giornata** | 🔴 **NON MISURATA** — e con un DD del 9,8% **non e' implicata**: il muro giornaliero del 5% resta dentro il cono del possibile |
| **Frequenza attesa** | **~0,60 op/giorno** `[DERIVATA]` — dal gemello **misurato** sulla stessa finestra e stesso TF: `SuperWave_DOW_H1` 770511 fa **n 227 ⇒ ~0,50 op/g** (`report/CENSIMENTO_CONTRATTI.md` §4b); 273/227 × 0,50 = **0,60** |
| 🔴 **Perche' NON e' un 🟢** | Il cancello che non si tocca dice **"DD fuori dai muri → resta rosso"**. 9,8% **non e' fuori**, ma **0,2 punti di margine non sono un margine**, e la **peggior giornata non e' mai stata misurata**. Il numero viene inoltre da una validazione **full-period del 26/07**, **senza split IS/OOS** e su una finestra dichiarata "2024.01→2026.06 nominale" quando i **tick indici BCM partono dal 2024.09.26** |
| **IL ROUND CHE SERVE** | Rimisurare la stessa cella **alla taglia deployabile (0,65%)**, con **split IS/OOS 40/60**, sulla finestra tick **2024.09.26 → 2026.06.30**, e **misurando la peggior giornata**. ⏱️ costo: pochi minuti di banco (l'EA c'e' gia', compilato) |
| 🎯 **Perche' vale la pena** | Se a 0,65% il DD scende dove l'aritmetica suggerisce (~6,4%) e la peggior giornata sta larga, **diventa il miglior candidato di tutta la corsia**: **merito PIENO (n 273)**, **PF 1,20**, e **la frequenza piu' alta del lotto** |
| ⚠️ **La contro-evidenza, dichiarata prima che la trovi qualcun altro** | La **gamba H4 dello stesso motore sullo stesso simbolo (970914) ha avuto la promozione REVOCATA**: PFmed a tick reali **0,79** contro OHLC 2,58 = illusione OHLC. E il **CAC H4 (970915)** e' crollato da **7,37 a 0,96**. 🟢 Ma il numero dell'H1 **e' gia' a tick**, non OHLC: non e' della stessa natura |

## 3.2 🆕 **SuperWave NASUSD H1** — la cella mai validata di una famiglia che a tick ha retto 2 volte su 2

| voce | valore |
|---|---|
| **Come e' entrato** | ⚠️ **dichiarato: NON e' mosso da nessuno dei due criteri nuovi in senso stretto** — non fu scartato per il TF ne' per la frequenza, ma per essere "marginale". Lo metto in coda **per completezza**, con l'etichetta in chiaro, perche' e' la cella **H1 non misurata** piu' vicina a un 🟢 |
| **EA** | `ABTG_SuperWave_EA` — **ESISTE** (la famiglia ha gia' due `_Ottimizzato` compilati) |
| **Simbolo / TF** | **NASUSD** · **H1** · `StMult 3,0 / TP_RR 2,0` |
| **Il numero** | **PF 1,26 · DD 2,0% · n 95** — 🔴 **OHLC, screening del 26/07**, mai a tick (`REGISTRO_TEST.md` §"EA SuperWave", riga NASUSD H1, verdetto in archivio: _"🟡 marginale"_) |
| **DD MISURATO** | **2,0%** ma **[OHLC, NON TICK]**. A tick: **NON MISURATO** |
| **Frequenza attesa** | 🔴 **NON MISURATA** (la finestra dello screening OHLC non e' dichiarata nel registro: non la deduco) |
| **Il "perche'" metodologico** | La famiglia SuperWave ha **due trasferimenti OHLC→tick MISURATI e FEDELI**: Dow H1 **1,42 → 1,52** (a tick fa meglio) e DAX H4 **1,30 → 1,28**. E' l'opposto del SupRev, dove il collasso e' documentato due volte |
| **IL ROUND CHE SERVE** | Validazione a **tick reali** sulla finestra 2024.09.26 → 2026.06.30, split 40/60, **due lati** (regola 25/08), con peggior giornata |
| **La contro-evidenza** | La stessa famiglia ha **GBPUSD spenta** (R103: PF 0,79, DD 13,4%, 5/7 anni negativi) e il **lato short del Dow morto** (R110: PF OOS 0,429) |

## 3.3 🆕 **GAP DELLA SESSIONE CASH — famiglia su D30EUR / U30USD / SPXUSD**

| voce | valore |
|---|---|
| **Come e' entrato** | 🆕 **CRITERIO 2**: era chiuso **per pura aritmetica di frequenza** (_"un gap e' UNO al giorno per costruzione"_). Col pavimento per **famiglia** quel veto **decade** — ed e' **la stessa conseguenza che la firma del 07/09 dichiara da sola** (`report/FIRME_2026-09-07.md`: _"diventa il primo di una famiglia da misurare anche su DAX, Dow e S&P"_) |
| **Strumento** | `mql5/Experts/ABTG_SondaGapCash.mq5` — **ESISTE e ha gia' girato** (prima compilazione: 0 errori, 0 avvisi) |
| **DD MISURATO** | 🔴 **NON MISURATO** su DAX/Dow/S&P (la sonda conta occasioni, non apre ordini) |
| **Frequenza attesa** | **~0,14 op/giorno per simbolo** `[MISURATA su NASUSD]`; su 3 simboli ≈ **0,42 op/g di famiglia** |
| 🔴 **L'AVVISO CHE VIENE PRIMA DEL ROUND** | Sull'unico simbolo portato ai **tick BCM** il meccanismo e' **MORTO PER SEGNO** il 07/09: dato esterno **+0,0988%** evento contro **+0,0112%** controllo → tick BCM **−0,0487%** contro **−0,0134%**, **monotonia rotta 4 volte su 7** (`risultati_archivio/REFERTO_GAPCASH_PASSO0_2026-09-07.md`). **Il segno si e' rovesciato passando dal dato esterno al nostro banco.** Un round su DAX/Dow/S&P parte con quella premessa addosso, e i criteri vanno congelati **prima**, con la clausola degenere gia' scritta (media evento **> 0** PRIMA del rapporto 3×) |
| **IL ROUND CHE SERVE** | Passo 0 conta-occasioni sui tick BCM, sul modello di `backtest_pipeline/prove/GAPCASH_NAS_PASSO0.txt`, **un simbolo per volta** |

## 3.4 Gli 11 che erano gia' in coda nel v1 — **invariati**, con la priorita' aggiornata dai due criteri

| # | oggetto | TF | DD misurato | freq. attesa | cosa serve | 🔓 tocco dai criteri nuovi |
|---:|---|---|---|---|---|---|
| 1 | **`ABTG_OutOfNoise`** (momentum intraday Zarattini-Aziz-Barbon) | M15 (NASUSD) | 🔴 NON MISURATO | 🔴 NON MISURATA | **UNA corsa** — riga `RIGA_PASSO0_OUTOFNOISE.ps1` gia' scritta; baco di warmup gia' corretto in v1.01/v1.02 e **mai rigirato** | 📐 **criterio 1**: la corsa vada fatta **anche a M30**, non solo M15 |
| 2 | **Sonda dell'Orologio INDICI, celle 13-14** (U30USD long/short) | H1 | 🔴 n/a (sonda) | n/a | **~12 minuti di macchina** | ⏫ **priorita' ALTA**: la meta' DAX e' gia' girata ed e' rossa (0/72 asimmetriche in OOS); su U30USD **non si conclude niente** finche' non gira, e il cancello I1 e' **di insieme sui due simboli** |
| 3 | **Round PREOPEN DAX / NAS** | M5/M15 | 🔴 NON MISURATO | 🔴 NON MISURATA | **13 file prova con criteri gia' CONGELATI, mai lanciati** | 📐 **criterio 1**: dichiarare lo stop in punti **prima**, contro il pavimento 64-68 (DAX) / 64-72 (NAS) |
| 4 | **`ABTG_FvgRetest`** (rientro nel Fair Value Gap, magic 775501) | H4 | 🔴 NON MISURATO | 🔴 NON MISURATA | UNA corsa (passo 0) | 📐 **criterio 1**: e' gia' su TF alto, la frontiera non lo tocca |
| 5 | **`ABTG_OpeningReversalB`** (fade del drive fallito, 3 stadi) | M5 (U30USD) | 🔴 NON MISURATO | 🔴 NON MISURATA | riga + una corsa; cancello duro gia' scritto (se i giorni-segnale coincidono col 770202 → scarto) | 📐 **criterio 1**: su U30USD a M5 lo stop deve stare **≥ 25-27 pt** (duro) — meglio 76-80. **Da dichiarare prima della corsa** |
| 6 | **Nightly FADE sugli indici** (U30USD, D30EUR, XAUUSD) | M15 | 🔴 **ZERO trade** (baco di filtro) | 🔴 NON MISURATA | **fix di UN filtro** + una corsa (`InpMaxNightVolPips=45` confrontato con `ATR(H1)/PipSize()`; su indici/oro `PipSize()=_Point` → sempre ≥45) | ⚠️ e' l'unico caso in cui _"non e' stato bocciato: non e' stato MISURATO"_ |
| 7 | **Sonda dell'Orologio, celle 03-06** (GBPUSD, XAUUSD) | H1 | 🔴 n/a (sonda) | n/a | una corsa (sospese per lentezza dei tick generati) | 📐 **criterio 1**: sono celle **H1**, adesso pienamente in perimetro. 🔴 ma lo **spread forex/oro e' NON MISURATO**: la frontiera **non e' compilabile** su questi due |
| 8 | **SupRev su E50EUR (Stoxx50) H1/H4 e F40EUR (CAC) H1** | H1/H4 | 🔴 **solo OHLC** (E50EUR H4 DD 0,6% n 49 · H1 DD 1,2% n 60 · F40EUR H1 n 131) | 🔴 NON MISURATA | una validazione a tick | 📐 **criterio 1** li rimette in perimetro, ma 🔴 **la famiglia ha DUE collassi OHLC→tick documentati** (CAC H4 **7,37→0,96**, Dow H4 **2,58→0,79**) — e F40EUR **e' proprio il CAC**. Priorita' BASSA |
| 9 | **FiboH4** (rami A filtro news e B geometria del corso) | H4 | 🔴 NON MISURATO | 🔴 NON MISURATA | **R93**, due gambe (il "0/8" in archivio e' **una configurazione bocciata contata otto volte**: `InpSymbols` pinnato vuoto) | nessuno dei due |
| 10 | **Deriva oraria EURUSD SHORT 08:00-16:00** (Breedon-Ranaldo) | — | 🔴 **non esiste un EA, non esiste uno SL, non esiste un DD** | n 1.607 IS / 2.411 OOS | EA da scrivere | 🔴 il killer dichiarato e' **l'ESECUZIONE** (~1 bp la uccide) — e lo spread forex BCM e' **NON MISURATO** |
| 11 | **`ABTG_HARSI`** EURUSD M5 | M5 | 🔴 NON MISURATO | 🔴 NON MISURATA | uno scan | 📐 **criterio 1**: M5 su forex, con lo spread **non misurato** = doppio buco |

---

# 4. 🔴 MORTO, E RESTA MORTO — **35**, invariato

_Le 35 righe del v1 (`report/CORSIA_DEMO_CANDIDATI.md` §3) **restano tutte**.
Non le riscrivo: **comanda il v1**, e i due criteri nuovi non ne muovono
nessuna._

## 4.1 Le SEI righe su cui la rilettura ha cambiato qualcosa — **senza cambiarne il colore**

Su queste, **META' del certificato di morte e' decaduta**. Va scritto, perche'
la prossima volta che qualcuno le cita non deve ripetere una ragione che non
vale piu':

| oggetto | ragione **DECADUTA** il 07/09 | ragione **CHE REGGE** | colore |
|---|---|---|---|
| **M0PB** | F1: 0/12 sopra **1,00 segnali/gg per sedia** | **H8**: 7/12 sotto RR 0,70; i 5 sopra stanno a 0,70-0,74 → win rate richiesto **62-70%** | 🔴 |
| **Compressione ATR → espansione** | 0/8 sopra il pavimento (misurato 0,55-**1,87**/gg per lato) | **delta contro ingressi casuali −1,2 punti su 9.723 segnali** + 7/8 sotto H8 | 🔴 |
| **RTH Confluence / London Signal B** | 0,72 e 0,31 trade/giorno | **irriproducibili**: il cuore e' un classificatore GMM mai pubblicato | 🔴 |
| **Fix valutari** (JF 2024) | 0,2 eventi/giorno | **quota di rientro 0,038-0,082** → il fade non esiste | 🔴 |
| **Micro-pivot sweep M5/M15** | _(la frequenza PASSAVA gia': 4,2-4,6/gg)_ | **delta contro il caso −0,2 pt su 22.616 segnali**, 8/8 sotto il TP-prima-di-SL richiesto | 🔴 |
| **Gap intraday / gap-fill** | _"uno al giorno per costruzione"_ = **l'UNICA ragione** | ❌ **nessuna** su DAX/Dow/S&P | 🔓 **spostato in SERVE UN ROUND** (§3.3) — l'unica riga che cambia colore in tutto il documento |

## 4.2 I due cancelli che non ho toccato nemmeno per fare numero

1. ❌ **DD misurato fuori dai muri prop** (10% totale / 5% giornaliero) → resta
   🔴. Il backtest il verdetto lo sa gia' dare, e un DD accaduto vale a
   qualunque n. Le righe interessate: `RELATIVO D30EUR` 25,01% · `LondonFx`
   37-55% · `AtrExhaustVol` 44,3-67,8% con peggior giornata **−9,72%** ·
   `AllineaLondra` fino a 46,62% · `FASE 2 Nasdaq` 11,73% · `CrossEmaApertura`
   29-35% · `PTE USDJPY` 11,5% · `EasyTrend AUDJPY` 15,9% · `CostToCost XAGUSD`
   16,4% · `SuperWave GBPUSD` 13,4% · `Nasdaq Apertura breakout` 17%.
2. ❌ **Falsificato da una misura** (zero segnali al conteggio, ablazione che
   smonta l'ingrediente, irriproducibile, duplicato) → resta 🔴.

---

# 5. ⚪ FUORI PERIMETRO — **7**, invariato

Le stesse sette del v1 §5 (sedie vive, lati e dial di sedie vive). **Non
entrano nel conto** e non le rimetto in lista.

⚠️ **Una precisazione che mi sono posto e che chiudo qui, per iscritto, cosi'
nessuno la riapre domani:** il **lato SHORT dell'EMADOW** (`ABTG_EMA200`
U30USD **H1**, sedia viva 771531) ha numeri da fare gola — **PF OOS 1,891 ·
n 302 (merito PIENO) · DD 2,66% · peggior giornata −1,17%** (R112 tabella
madre). 🔴 **Non lo promuovo, e non perche' me lo dimentico:** e' il **lato di
una sedia VIVA**, non uno scarto; R112 ha gia' misurato i tre dial contro un
cancello di portafoglio **congelato prima dei numeri** e **nessuno passa**;
e portarlo in demo come sedia separata sarebbe **una decisione nuova**, non
la rilettura che Claudio ha chiesto. **Se lo vuole, e' una firma sua, non una
conseguenza dei due criteri.**

---

# 6. 🎯 IL RIASSUNTO IN CINQUE RIGHE

1. 🟢 **I PRONTI SUBITO sono sempre QUATTRO**, ordinati per velocita':
   **RELATIVO NASUSD 0,525 op/g** · **NY RETEST 0,25** · **DAX REENTRY LONG
   0,17** · **SUPERWAVE DAX H4 0,12**. Tutti e quattro hanno **l'EA gia'
   scritto e compilato**; manca a tutti la stessa terna: **preset, magic,
   compilazione**.
2. 🟠 **La coda "SERVE UN ROUND" passa da 11 a 14**, e il nuovo capofila e'
   **il piu' veloce di tutto il documento**: `SupRev DOW H1` a **~0,60
   op/giorno**, con **n 273 = merito MISURABILE**, unico caso in tutta la
   corsia. Il round che serve dura **minuti**, non settimane.
3. 📐 **Il criterio 1 ha prodotto piu' misure che candidati** — ed e' un buon
   risultato: adesso **due dei quattro verdi hanno il conto del costo accanto**
   (NY RETEST 29,7× lo spread, DAX REENTRY 46,5×), e **si sa quale numero
   manca** sul terzo (lo stop in punti del RELATIVO).
4. 📊 **Il criterio 2 ha aperto una porta sola** (la famiglia dei gap di
   sessione cash) e **ne ha confermate cinque chiuse** — ma ha anche fatto
   emergere il fatto grosso: **le sedie VIVE girano a 0,028-0,50 op/giorno**,
   una sola sopra il pavimento. La firma del 07/09 non allarga: **allinea**.
5. 🔴 **E i 35 morti sono ancora 35.** Ho riletto a M30/H1 sette famiglie e ho
   trovato che **due round che sembravano da fare erano gia' fatti e persi**
   (EMA200 H1 = R32, capitolo chiuso · GoldenCross H1 = R20, 0/6): **due round
   risparmiati e una riga stantia corretta in `CLASSIFICHE.md`**.

---

# 7. ⚠️ COSA QUESTO DOCUMENTO NON COPRE — dichiarato

- **Non copre l'esecuzione vera**: slippage, requote, rifiuti.
  `ABTG_SlippageLogger` sul conto reale ha ancora **0 deal**: ogni gradino di
  slippaggio e' **uno scenario assunto**, non una misura.
- **Non copre la frontiera del costo su forex e oro.** Lo spread BCM su
  EURUSD/GBPUSD/USDJPY/XAUUSD e' **NON MISURATO** (riga H12, aperta da sette
  cacce). Tutti i giudizi di costo qui dentro valgono **solo sui tre indici**.
- **Non copre la correlazione fra i candidati e la flotta viva.** Il **tetto
  per cluster al 3,0%** e' **firmato il 07/09, implementato in giornata
  (Guardian v1.13) ma SPENTO DI DEFAULT, NON COMPILATO e NON COLLAUDATO** =
  **non e' una protezione**. E la firma gemella (famiglia = piu' simboli) rende
  quel buco **piu' probabile**: **quella che allarga e' attiva, quella che
  protegge no.**
- **Non copre il regime.** Tutti i numeri a tick sugli indici vengono da **21
  mesi di UN SOLO REGIME (toro)**: il pavimento tick BCM e' il **2024.09.26**
  e non si abbassa.
- **Non e' un contratto.** Se uno di questi va in demo, il suo **DD promesso** e
  la sua **frequenza promessa** vanno scritti in `report/CENSIMENTO_CONTRATTI.md`
  **prima** che apra la prima posizione, con le **quattro righe** di
  `report/CORSIA_DEMO_REGOLE.md` (la domanda · il traguardo n=150 con la data ·
  il DD promesso · il tagliando a 6 mesi). Altrimenti il criterio di uscita del
  18/08 non e' applicabile.
- **Non sostituisce il v1.** Se il v1 e questo divergono, si guardano tutti e
  due e **comanda il referto originale**.

---

_Compilato in sola lettura d'archivio. **Nessun EA, preset, sedia, magic o
parametro di forward e' stato toccato. Nessun backtest lanciato. Nessuna
promozione. Nessun file del pacchetto di deploy di RELATIVO NASUSD e'
stato aperto in scrittura** (lavoro di un altro agente, qui solo citato)._
