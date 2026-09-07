# 🪑 CORSIA DEMO — SEDIA `NY SESSION RETEST` slope 75 (magic **769510**)

_Scritta il **07/09/2026**, **PRIMA** che la sedia apra una sola posizione._
_Regole della corsia: `report/CORSIA_DEMO_REGOLE.md`. Candidato 🥈 **G2** di
`report/CORSIA_DEMO_CANDIDATI.md`._

> 🔴 **PRIMA RIGA, PRIMA DI OGNI NUMERO BELLO — la cella slope 75 è il PICCO
> del PF, NON il centro di un altopiano.**
> Sull'asse slope i PF misurati sono: **45 → 1,17 · 60 → 1,14/1,20 · 75 →
> 1,374/1,427 · 90 → 1,25/1,28**. **Una sola cella su quattro supera la barra
> PF ≥ 1,3**, e le due vicine stanno sotto.
> Il criterio congelato nel suo stesso file prova dice, testuale: _"una cella
> outlier isolata NON è un altopiano"_
> (`backtest_pipeline/prove/ABTG_NySessionRetest_Tar2.txt`, criterio (a)).
> 👉 `report/CORSIA_DEMO_CANDIDATI.md` §2 G2 attribuisce la sospensione **solo**
> a n<150 e **non nomina questo punto**. Va nominato. **È la ragione per cui
> questa sedia va in demo e non in campo**, ed è LA DOMANDA di §1.

> 🟢 **E la contro-parte, altrettanto misurata:** l'asse del **RISCHIO non è un
> picco, è un gradiente monotono** — n 625→449→295→211→160→115→75 e
> DD **12,9 → 9,8 → 5,9 → 5,8 → 5,6 → 3,7 → 2,2%**. Il DD promesso di §3
> poggia sulla parte robusta della mappa; il PF 1,37 poggia su una cella sola.

---

## 🪪 IDENTITÀ

| campo | valore | fonte |
|---|---|---|
| EA | `mql5/Experts/ABTG_NySessionRetest.mq5` — v5, già scritto, già compilato (68 KB), già girato a tick | `REFERTO_NYRETEST_2026-08-31.md` |
| Simbolo / TF | **U30USD M15** (trend letto su H1 con handle dedicato) | `backtest_pipeline/prove/ABTG_NySessionRetest_Tar2.txt` |
| Sessione | **14:30 → 20:55 ORA SERVER BCM** (= 15:30 → 21:55 italiane), flat di recupero | idem |
| Cella | `InpVwapSlopeMin=75` · `InpSlLookback=5` · `InpExpansionMin=0` (asse spento **per misura**) | referto §"ESTENSIONE FINALE" |
| Rischio | **0,65%** — **nessuna riscalatura** (vedi sotto) | `backtest_pipeline/righe/RIGA_NYRETEST_TAR2.ps1` |
| **Magic** | **769510** — verificato **VERGINE** repo-wide il 07/09/2026 | `grep -rn "769510" . --exclude-dir=.git` → **0 occorrenze** |
| Preset | `mql5/Presets/ABTG_NySessionRetest_U30USD_DEMO.set` | — |
| **Conto** | **DEMO PICCOLO 50503392**, cartella `C:\Program Files\BCM Markets MT5 Terminal` (**senza** `-V3`) | `report/CORSIA_DEMO_REGOLE.md` |
| Guardian | **ASSENTE** — l'EA non ha l'input, e il piccolo è senza Guardian per decisione di Claudio del 06/09 | `HANDOFF.md` §3 del 06/09 |

### 💶 Il rischio 0,65% NON è stato riscalato, ed è un fatto
La corsa Tar2 ha girato **direttamente a `InpRiskPercent=0.65`**
(`RIGA_NYRETEST_TAR2.ps1`, `-Deposito 100000`, **modello 4 tick reali**).
👉 Quindi **DD 4,7%** e **peggior giornata −0,69%** valgono **tali e quali**.
Non c'è nessun numero scalato in questa scheda: se ci fosse, sarebbe scritto.

### 🔓 Rischio aperto massimo: **1,30%**, letto nel codice
`InpMaxTradesPerDay=2` limita gli **ingressi eseguiti al giorno**, e l'EA non ha
un tetto di posizioni contemporanee separato → nel caso peggiore **2 posizioni
vive da 0,65% = 1,30%**, contro il cap C1 di **3,25%**. Nessuno sfondamento.
_(Il parziale al 50% + breakeven riduce l'esposizione della prima, ma **solo
dopo** che il livello è stato toccato: il caso peggiore resta 1,30%.)_

### 🔴 UNA PRE-CONDIZIONE DA VERIFICARE PRIMA DI ACCENDERE — il lotto minimo
Riga 945 di `ABTG_NySessionRetest.mq5`:
```
return(MathMax(mn,MathMin(mx,lot)));
```
Il lotto calcolato dal rischio viene **portato SU al minimo del broker** se è più
piccolo. Su un conto demo piccolo, con una perdita mediana misurata di
**−58,0 punti indice**, se lo 0,65% dell'equity non compra il lotto minimo di
U30USD **l'EA apre lo stesso, al minimo, e il rischio VERO per trade è più alto
dello 0,65%.** In quel caso il DD forward supererebbe il promesso **per un motivo
che non è la strategia**, e il cancello di §3 scatterebbe a vuoto.
👉 **Misura da fare (passo 6 delle istruzioni), non da assumere.**

---

## 1️⃣ LA DOMANDA

> **Il PF 1,374 della cella slope 75 è un edge reale, o è la cella fortunata di
> una mappa in cui le due vicine (slope 60 e 90) stanno sotto la barra?**

È la domanda giusta perché **il gate slope è già dimostrato REALE sul rischio**
(monotono, dimezza il DD, primo gate costitutivo della flotta validato a tick),
mentre **sul PF ha un solo punto sopra barra**. Il backtest questa domanda non la
può chiudere: servono operazioni che oggi non esistono. Il forward le fabbrica.

Sotto-domanda che arriva gratis, e che nessun backtest dà: **i due lati**. Nel
motore nudo LONG +4.789 / SHORT −4.575. Alla cella slope 75 i lati **non sono
mai stati smontati**. Il forward li separa da solo, per magic e per direzione.

---

## 2️⃣ IL TRAGUARDO — n = 150 operazioni

**La frequenza misurata**, ricalcolata dai numeri primari (n=115 su 459 giorni
feriali, finestra 2024.09.26→2026.06.30):

| | |
|---|---:|
| operazioni / giorno feriale | **0,2505** (115 / 459) |
| operazioni / mese (× 21,75 feriali) | **5,45** — coerente col _"~5,4 trade/mese"_ del referto ✅ |

### 🔴 LE DUE LETTURE DEL TRAGUARDO, TUTTE E DUE DICHIARATE

**Non le mescolo. Dico quale uso e perché.**

| lettura | cosa conta | feriali | durata | data |
|---|---|---:|---:|---|
| **A — forward DA SOLO** arriva a 150 | solo le operazioni della demo | 599 | **27,5 mesi** | **~fine dicembre 2028** |
| **B — il `n` della CELLA** arriva a 150 | backtest 115 **+** forward 35 | 140 | **6,4 mesi** | **~20 marzo 2027** |

❌ **Con la lettura A la sedia NON si accende**: 27,5 mesi sono ben oltre il
tetto dei ~18 mesi, e la regola dice di dirlo.

✅ **Uso la lettura B, e non è una scappatoia inventata per salvarla — è la
porta di rientro che il referto aveva GIÀ scritto, un mese fa, prima di questa
corsia.** Testuale da `REFERTO_NYRETEST_2026-08-31.md`:

> _"PORTA DI RIENTRO (dichiarata, meccanica, non discrezionale): la finestra
> tick BCM CRESCE ogni mese. La cella slope 75 produce ~5,4 trade/mese: quando
> la finestra darà n≥150 sulla STESSA cella (**stima: primavera-estate 2027**),
> si rimisura con criteri identici — è un TAGLIANDO calendarizzato."_

👉 **Il mio conto e quello del referto cadono nello stesso punto del calendario**
(marzo 2027 / "primavera 2027") **perché contano gli stessi mesi.** Il muro R59
giudica il campione **della cella**, e le operazioni forward stanno sugli stessi
mesi che il backtest coprirà quando i tick BCM arriveranno. La demo non accorcia
l'attesa: **la riempie di dati veri** (fill, spread, slippage) che il tester non
avrà mai.
_Stesso ragionamento già agli atti per RELATIVO NASUSD: `CORSIA_DEMO_CANDIDATI.md`
§2 G1 — "A6 si soddisfa da sola aspettando, intorno al 27/11/2026"._

### 📐 Cosa la stima contiene e cosa NON contiene
I "feriali" sono giorni lun-ven **di calendario**, festivi USA compresi: è
coerente con la misura d'origine, che contava allo stesso modo (i 459 giorni
della finestra). **Non è modellato** un cambio di regime che alzi o abbassi la
frequenza — ed è il rischio più concreto: il gate slope 75 chiede **trend VWAP
forte**, quindi in un mercato piatto la frequenza **crolla**, non cala. Trigger 6.

### ⚠️ E UN'AMBIGUITÀ DI UNITÀ, DICHIARATA
Il `n` dell'archivio è in **deal**, non in posizioni: al passo 0 lo stesso file
dice _"625 deal / 462 posizioni"_ (il parziale al 50% produce due uscite). Quindi
**n=115 deal ≈ 85 posizioni**. Tutti i conti qui sopra sono in **deal**, la
stessa unità in cui è scritto il muro R59 dell'archivio. **Se il criterio dovesse
essere letto in posizioni, il traguardo si allunga di ~35%** (lettura B: ~8,7
mesi anziché 6,4 — comunque sotto i 18). **NON MISURATO**: nessuno in casa ha
ancora firmato in quale delle due unità si conta il 150.

### 📍 Le due tappe intermedie (per non guardare nel vuoto)
| data | feriali | n forward atteso | n cella (115 + fwd) |
|---|---:|---:|---:|
| **02/11/2026** | 39 | ~10 | ~125 |
| **08/03/2027** (tagliando) | 129 | ~32 | **~147** |

🎯 **Il tagliando dei 6 mesi e il traguardo cadono praticamente nello stesso
giorno.** Non è una coincidenza costruita: è 5,45 op/mese × 6 mesi ≈ i 35 che
mancavano. **Questa sedia ha una data sola da segnare in agenda.**

---

## 3️⃣ IL DD PROMESSO — **4,7%** · è il cancello di rischio vivo

**Fonte:** `backtest_pipeline/risultati_archivio/REFERTO_NYRETEST_2026-08-31.md`,
§"🏁 ESTENSIONE FINALE (corsa VERA 11:42, pin 77435cb, 8/8)".

| metrica (U30USD M15, **tick reali BCM**, rischio 0,65%, 2024.09.26→2026.06.30) | valore | muro di casa | esito |
|---|---:|---|---|
| profit factor (sl 5) | **1,374** | barra R59 ≥ 1,30 | ✅ raggiunta… su **una cella sola** |
| **drawdown equity** | **4,7%** | prop 10% · soglia R59 8% | ✅ **larghissimo**, margine 5,3 punti |
| peggior giornata | **−0,69%** | prop −5% | ✅ larghissimo |
| overnight veri (motore, passo 0) | **2,88%** | soglia firmata 5% | ✅ rilievo dichiarato |
| autotest | **0 falliti** su 8/8 celle | — | ✅ |
| n | **115** | R59 ≥ 150 | ❌ è **il** motivo della corsia |

### 🟠 IL 4,7% È DEDOTTO, NON LETTO — e va detto
La tabella del referto stampa la colonna **`DD (sl7)` = 3,7%**. Il **4,7%** è il
DD di **sl 5**, e si ricostruisce incrociando il referto con
`report/CORSIA_DEMO_CANDIDATI.md` §2 G2 (_"DD 3,7–4,7%"_): il range copre le due
celle, il 3,7 è etichettato sl7, quindi il 4,7 è sl5.
🔴 **I CSV grezzi della corsa Tar2 NON sono in `backtest_pipeline/risultati_archivio/`**
(verificato il 07/09: ci sono solo i referti `.md`). Due citazioni indipendenti,
**nessun file di misura primario**. Non è un motivo per non accendere una sedia
**demo**; **lo sarebbe per una sedia reale.** → §"cose da chiarire".

👉 **Cancello di rischio vivo (corsia RISCHIO firmata il 18/08):**
**se il DD forward supera 4,7% → REVISIONE IMMEDIATA.** Non "quando arriva al
10%": **al numero promesso**. Un DD è un fatto accaduto e vale a qualunque n.
🔎 **Spia anticipata a 3,7%** (il DD misurato della cella gemella sl 7): se il
forward lo passa, si guarda **prima** di aspettare il 4,7%.

---

## 4️⃣ IL TAGLIANDO — **08/03/2027** (6 mesi, data fissa)

Si guarda **comunque**, anche se n non è arrivato (atteso ~32 operazioni
forward, ~147 sulla cella). Si legge in quest'ordine:

1. **DD reale** contro **4,7%** promesso (e la spia a 3,7%);
2. **frequenza reale** contro **5,45 op/mese** promesse;
3. **il PF**, che a quella data è la risposta alla DOMANDA di §1:
   - PF forward **≥ 1,3** → la cella non era un picco: si rilancia la misura a
     tick con la finestra cresciuta, e si porta all'imbuto **col merito pieno**;
   - PF forward **fra 1,10 e 1,28** → era il **picco**, e la mappa vera è quella
     delle vicine (1,14–1,28). **Non è un fallimento: è la misura che mancava.**
   - PF forward **< 1,0** → il gate non tiene fuori dal suo backtest: si spegne.
4. **i due lati separati** (long vs short), che qui hanno il loro primo numero
   proprio alla cella slope 75.

---

## 🔌 COSA LA FA SPEGNERE PRIMA DEL TEMPO

| # | trigger | verifica | azione |
|---:|---|---|---|
| 1 | **DD > 4,7%** | equity 50503392, magic **769510** | 🔴 **revisione immediata** (RISCHIO, 18/08) |
| 2 | **una giornata peggiore di −2,0%** | ≈ 3× la peggior giornata misurata (−0,69%) | 🟠 revisione: il profilo non è quello promesso |
| 3 | **una giornata peggiore di −5,0%** | muro prop giornaliero | ⛔ **spegnimento**, non revisione |
| 4 | **più di 2 ingressi in un giorno** | è un BACO: il tetto è aritmetica di rischio | ⛔ spegnimento e indagine sul codice |
| 5 | **una posizione sopravvive alla notte** su un giorno con tick regolari | il flat di recupero v4/v5 deve chiudere al primo tick | ⛔ spegnimento: il vincolo duro del mandato è violato |
| 6 | **frequenza reale < 2,7 op/mese** (metà del promesso) dopo 60 feriali (≈ 02/12/2026) | il traguardo B slitterebbe oltre 13 mesi | 🟠 revisione del traguardo |
| 7 | **opera su un simbolo ≠ U30USD**, o con magic ≠ 769510, o su un TF ≠ M15 | preset caricato male / grafico sbagliato | ⛔ spegnimento immediato |
| 8 | **il rischio VERO per trade risulta > 0,65%** perché il lotto è floorato al minimo | vedi pre-condizione in §Identità | ⛔ **non accendere / spegnere**: il cancello §3 misurerebbe un'altra cosa |

### ❄️ Cosa **NON** la spegne, e va detto per non ucciderla per sbaglio
Il criterio **MERITO a 20 operazioni** firmato il 18/08 **NON si applica a questa
sedia** — ed è la definizione stessa della corsia demo. Una sedia accesa per
accumulare operazioni, spenta a 20 perché è in perdita, non risponderebbe mai
alla domanda per cui è stata accesa; e a n=20 il merito è rumore, non misura
(regola del 16/08: _il campione sottile sospende il giudizio sul MERITO, mai sul
RISCHIO_).
🔴 **Il RISCHIO invece morde per intero, a qualunque n**: trigger 1-5, 7, 8.
**Questa è l'unica riga della scheda che allenta qualcosa, ed è in chiaro.**

---

## 🛑 LA CORSIA DEMO **NON È UNA PORTA VERSO IL CONTO REALE**

Testuale da `report/CORSIA_DEMO_REGOLE.md`:
> _Una sedia che va bene in demo **non passa in campo in automatico**: torna in
> coda all'imbuto con il suo n finalmente pieno, e da lì si giudica col merito,
> come tutti. Il passaggio ai soldi veri resta una **firma specifica su un numero
> misurato**._

Questa sedia gira su **DEMO 50503392**, costa **zero euro**, e all'08/03/2027
produce **un numero**, non una promozione. Il conto **reale 10105439** e il
**100k 50504263** non c'entrano e non vanno toccati.

---

## ⚠️ COSA QUESTA SCHEDA NON COPRE (dichiarato prima, non dopo)

1. 🔴 **Tracciabilità incompleta.** Nessun CSV grezzo di NYRETEST in
   `risultati_archivio/`: i numeri vivono solo nei referti `.md`. **Il 4,7% è
   dedotto** (§3).
2. 🔴 **UN SOLO REGIME.** Tutto il tick BCM sugli indici sta in **21 mesi di
   toro** (pavimento 2024.09.26). Emendamento della Finestra: regola **A**
   soddisfatta (con la lettura B), regola **C — prova di regime — NON
   soddisfatta**. E il forward parte dentro lo stesso toro: **non aggiunge un
   regime, aggiunge campione**.
3. 🔴 **La cella è il PICCO del PF** sull'asse slope (prima riga di questa
   scheda). Il criterio (a) del suo prova la escluderebbe come "outlier
   isolata". La demo esiste per misurarlo, non per aggirarlo.
4. **L'esecuzione vera** — slippage, requote, rifiuti — **non è misurata**: lo
   `ABTG_SlippageLogger` sul reale ha ancora **0 deal** (`HANDOFF.md` 07/09).
5. **`InpMaxSpread=0` = filtro spread SPENTO**, come nella cella misurata.
   Spread U30USD in sessione: **NON MISURATO in questa scheda** — la misura del
   03/09 (`SPREAD_FLOTTA_MISURA_2026-09-03.md`) è citata in archivio per D30EUR
   (1,6–1,7 pti). Il take mediano WIN è **+87,6 punti indice**: il margine è
   larghissimo per qualunque spread plausibile del Dow, ma il numero **va letto,
   non assunto**.
6. **Il tetto per cluster/valuta al 3,0%** è firmato il 07/09 ma **NON
   collaudato** (Guardian v1.13 spento di default, mappa cluster non firmata):
   **non è una protezione**, e accendere questa sedia non lo attiva.
7. **Nessuna correlazione misurata** con la flotta viva del piccolo (che ha già
   `Dow_Apertura_US` 770202 su **U30USD M5**). Due sedie sullo **stesso
   sottostante**: il cumulo di rischio sul Dow **non è misurato**. Il tetto per
   cluster servirebbe esattamente a questo, e non c'è.

---

## ✅ VERDETTO — **SI ACCENDE**

- 🟢 **Il RISCHIO ha un numero e sta larghissimo dentro i muri**: DD **4,7%**
  contro 10%, peggior giornata **−0,69%** contro −5%, rischio aperto max
  **1,30%** contro cap 3,25%. Ed è il numero più pulito dei tre candidati.
- 🟢 **Il traguardo è raggiungibile**: **~20 marzo 2027**, lettura B dichiarata,
  che cade sullo stesso giorno del tagliando dei 6 mesi. _(Con la lettura A —
  forward da solo — sarebbe dicembre 2028 e la risposta sarebbe NO: la scelta
  è dichiarata, non nascosta.)_
- 🟢 **È il primo gate costitutivo della flotta validato a tick**, e il gate
  è reale e monotono **sul rischio**.
- 🟠 **Con una riserva scritta grande: il PF sta su UNA cella.** Ed è
  precisamente ciò che il forward va a misurare.

### 📌 DA FARE PRIMA DELLA PRIMA POSIZIONE (prerequisito del 18/08)
Scrivere DD promesso (**4,7%**) e frequenza promessa (**5,45 op/mese ≈ 0,25
op/gg**) in `report/CENSIMENTO_CONTRATTI.md` §4d — **altrimenti il criterio di
uscita del 18/08 non è applicabile** (`CORSIA_DEMO_CANDIDATI.md` §7).
