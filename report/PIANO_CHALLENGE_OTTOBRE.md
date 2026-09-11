> # 🔴 SUPERATO — NON USARE QUESTO FILE PER DECIDERE
> **Il piano vivo e' `report/PIANO_CHALLENGE_OTTOBRE_v2.md` (11/09/2026).**
> Questo v1 resta in archivio come **verbale di quello che credevamo l'08/09**,
> e non e' stato sovrascritto apposta: **quattro sue affermazioni sono state
> MISURATE FALSE** fra il 10 e l'11/09, e cancellarle cancellerebbe la prova che
> il metodo le ha trovate.
>
> | cosa dice il v1 | cosa e' misurato ora |
> |---|---|
> | *"`770511` n=227 = MERITO PIENO"* | 🔴 **falso**: finestra piena, spezzata fa **84 e 143** (classe **224**) |
> | *"`970913` n=155 = MERITO PIENO"* | 🔴 **da riverificare**: l'unico OOS in archivio e' `_ohlc` (screening) |
> | *"la compilazione porta le schierabili da 1-2 a 5"* | 🔴 **falso**: **2 → 2** stretta, **2 → 4** larga |
> | *"il 1° ottobre e' realistico per COMPRARE"* | 🔴 **caduta**: col **cancello del costo** acceso, le candidate che passano tutto oggi sono **ZERO** |
> | 🆕 *"`770101`: **CONFLITTO APERTO**, 6,89% contro 4,3501%"* (r.91, r.191) | ✅ **CHIUSO l'11/09**: il DD promesso e' **4,3501% @0,65%** — il 6,89% descriveva la cella con **`InpAllowShort=1`**, a taglia **1,0%**, magic **777120/777121**. 📄 `report/CONFLITTO_DD_770101_2026-09-11.md` |
> | 🆕 *"somma aritmetica dei DD promessi = **14,01%**"* (r.258, r.345) | 🔴 **il numero e' sbagliato: e' 11,47%.** Resta **sopra il muro di 10**, ma sfora di **1,47 punti**, non di 4,01 — vedi ERRATA in coda |
>
> ➕ E il v1 **non contava** due cose che adesso pesano: il **cancello del costo
> all-in** (commissione forex **4,0000 EUR/lotto** misurata) e il fatto che il
> `n` dell'OPTFRAME conta i **deal di uscita**, non le posizioni (classe **226**).

---

# 📅 PIANO CHALLENGE OTTOBRE — costruito ALL'INDIETRO dal 1 ottobre 2026

_Scritto dall'**architetto-prop** l'**08/09/2026**. Prodotto su un fatto nuovo:
**c'e' una data.**_

> 🗣️ **Claudio, 08/09/2026, testuale:**
> _"spero che entro fine settembre abbiamo un mese di tempo per creare expert
> nuovi, perche' dai primi d'ottobre vorrei iniziare la challenge"_

**Oggi e' martedi' 08/09/2026. Al 1 ottobre mancano 23 giorni, di cui 16
giornate di borsa.** Questo documento risponde a **una domanda sola**:

> ## ❓ Che cosa deve essere VERO il 30 settembre perche' il 1 ottobre si possa premere "inizia la challenge" senza bluffare?

---

## 🧊 REGOLE DI LETTURA — congelate prima dei numeri

1. **Questo file NON congela niente e non applica niente.** Propone. Le
   decisioni di rischio, il conto reale e i soldi restano di Claudio: accanto a
   ogni proposta c'e' scritto **quale firma serve**.
2. **Nessun EA, preset, parametro o sedia viva e' stato toccato** per scrivere
   questo documento. L'unico file prodotto e' questo.
3. **Ogni numero ha il suo file.** Dove il numero non esiste in archivio la riga
   dice **NON MISURATO** — e la misura che servirebbe finisce **nel calendario**,
   non in una stima travestita.
4. **Gli orari sono SEMPRE anche in ora server BCM** (= ora italiana − 1 in
   questo periodo dell'anno, `CLAUDE.md` §FUSO ORARIO BCM).
5. Vale la **F4 congelata il 13/08** (`PIANO_PROP.md` tabella madre): _la
   challenge si compra **solo dopo forward maturo + risposte scritte del
   supporto**_. Questo piano **non la riapre**: la misura contro la data.

---

# 0. 🎯 LA RISPOSTA IN UNA RIGA, PRIMA DEL DETTAGLIO

> ## Il 1 ottobre e' realistico per **COMPRARE**. Non e' realistico per **"avere una flotta provata"** — e le due cose non sono la stessa.
>
> Al 30/09 avremo: **celle misurate a tick reali**, **un banco che passa la
> challenge nel 99,6% delle partenze simulate**, **7,4 settimane di dry-run sul
> 100k a +2,85%** e **un Guardian vivo coi muri firmati**.
> **NON** avremo: **una sola famiglia a 150 operazioni forward** (la prima ci
> arriva fra gennaio e aprile 2027), **il DD forward per famiglia** (`n/d` su
> 16 famiglie su 17), **una singola misura di slippaggio su conto vero**
> (0 deal), **la prova di regime ORSO** e **la prop scelta**.
>
> 🔴 **E c'e' un numero che il piano non puo' nascondere: dei 8 candidati della
> squadra, oggi ne passa i quattro requisiti UNO** — e il conto lo trovi in §1.

---

# 1. 🪑 LA SQUADRA CANDIDATA — chi ha i requisiti OGGI

## 1.1 I quattro requisiti, dichiarati prima della tabella

| # | requisito | dove si legge | perche' e' un requisito |
|---|---|---|---|
| **R1** | **cella promossa**: esiste un round che ha promosso ESATTAMENTE la configurazione che gira | `CENSIMENTO_CONTRATTI.md` colonna "Fonte" | senza, il DD promesso descrive una cella diversa da quella in campo (successo davvero: M31, il 6,25% di R16 descriveva una cella che non gira piu') |
| **R2** | **DD di backtest dichiarato**, con deposito + rischio + modello del banco | `CENSIMENTO_CONTRATTI.md` colonne "DD PROMESSO" e "Deposito/rischio" | e' l'unico ingresso della corsia RISCHIO della **C3** firmata il 18/08 |
| **R3** | **frequenza misurata** (op/giorno) | `CENSIMENTO_CONTRATTI.md` colonna "Freq. promessa" | pavimento **1,00 op/g per FAMIGLIA** firmato il 07/09 (`FIRME_2026-09-07.md`) |
| **R4** | **rischio VERO == rischio DICHIARATO** | 🆕 `RISCHIO_DICHIARATO_VS_VERO_2026-09-08.md` §3 | e' il requisito nuovo di oggi, e **il piu' selettivo di tutti**: un cap C1 alimentato da input bugiardi non e' una protezione |

## 1.2 🚨 LA TABELLA — 8 candidate, e cosa manca a ciascuna

Taglia di riferimento: **0,65%** (A1 firmata). I DD sono riportati **alla taglia
viva**, con fra parentesi il DD del banco e il suo rischio.

| # | sedia · magic | sym · TF | R1 cella | R2 DD promesso @0,65% | R3 op/g | R4 rischio VERO | 🔴 **COSA MANCA** |
|---:|---|---|---|---|---:|---|---|
| 1 | `ABTG_ORB_Ottimizzato` **770611** | U30USD M5 | ✅ **R119**, cella = cella viva | ✅ **6,5389% OOS / 5,6530% IS — gia' a 0,65%** (dep. 10.000 · tick) | **0,43** | ✅ **0,65% vere** — `InpAllowShort=false` nel preset reale, una sola gamba | 🟠 **merito SOSPESO** (n 119 OOS / 71 IS < 150). ⚠️ R118: la config VIVA e' l'unica che **sfonda il muro sotto slippage a 1%** (9,76 → **10,34%**) — a 0,65% il margine viene **dalla taglia, non dal motore** |
| 2 | `ABTG_DAX_Apertura_EU` **770101** | D30EUR M5 | ✅ **R83 RETEST**, cella = cella viva | 🔴 **CONFLITTO APERTO**: **6,89%** (10,60% @1%, n 311) contro **4,3501% OOS / 3,1749% IS** di R119 **alla stessa taglia 0,65%** (n 270/175) | **0,97** | ✅ **0,65% vere** — `InpAllowShort=false` nel preset reale | 🔴 **attribuire la differenza R83 vs R119** prima di scegliere quale numero usa la C3. 🟠 famiglia **Aperture DAX** gia' oltre la soglia MERITO: 38 ingressi forward, **−698,46 €** |
| 3 | `ABTG_Dow_Apertura_US` **770202** | U30USD M5 | ✅ R16 · riconferma R54 | ✅ **2,74%** (4,22% @1% · dep. 100.000 · tick · n 130) | **0,46** | 🔴 **NON VERIFICABILE**: sorgente `ABTG_DEF_RISK 2.0`, **4,00% a due lati** — e **nel repo NON esiste nessun preset del 100k** | 🔴 un **preset scritto su file** con `InpRiskPercent=0.65` e `InpAllowShort=false`. Oggi lo 0,65 che gira **vive solo dentro un `.chr`** |
| 4 | `ABTG_MaxMinNotte_DAX_Short_Ott` **770411** | D30EUR M15 | ✅ R16 | ✅ **0,83%** (1,27% @1% · 100.000 · tick) | **0,078** | 🟠 **2,00×** (due pendenti opposti, `:253`/`:265`) | 🟠 n=**21**, campione minuscolo · frequenza sotto il pavimento anche da famiglia · verificare che giri a **un lato solo** |
| 5 | `ABTG_SupertrendReversal` **770901** | 225JPY H2 | ✅ R5 · R16 | ✅ **0,57%** (0,88%/0,65% @1%) | **0,18** | 🔴 **2,00% vere contro 0,65% dichiarate** — 🐞 bug tranche `:274-276` | 🔴 sul 100k questa sedia rischia **1,30%**, non 0,65%: il cap C1 la conta meta' di quello che e'. ⚠️ preset in repo e' **H4**, la sedia gira **H2** |
| 6 | `ABTG_SupRev_NAS_H1_Ott` **970913** ⭐ | NASUSD H1 | 🟠 `REGISTRO_TEST` §S5v (PF 1,57 · 8/8 combo) | ✅ **0,76%** (1,17% @1%) · 🟠 **n 155 = MERITO PIENO — DA RIVERIFICARE**, stesso sospetto del n.7 (11/09): controllare che il 155 venga da una partizione IS/OOS vera e **a tick**, non dalla finestra piena ne' da una corsa `_ohlc` (che e' screening, mai verdetto). Nell'archivio il file OOS trovato per questa sedia e' **`..._OOS_ohlc.csv`**: 🔴 finche' non e' chiarito, l'etichetta **MERITO PIENO non regge** | **0,34** | 🔴 **2,00×** — bug tranche `:261-263` | 🔴 il fix di **due righe** (scritto, non applicato) + ricompilazione + firma sulla taglia. E' **il piu' prop-friendly del parco** ed e' fermo su un bug |
| 7 | `ABTG_SuperWave_DOW_H1_Ott` **770511** | U30USD H1 | 🟠 `REGISTRO_TEST` (PF 1,52 · 9/9 combo) | ✅ **2,60%** (4,0% @1% · tick) · 🔴 **n 227 NON E' MERITO PIENO** — corretto l'11/09: il 227 e' della corsa a **finestra piena, che non ha nessun fuori campione**. Spezzata IS/OOS la stessa corsa fa **84 e 143** (verificato nei CSV: 84+143=227), **tutti e due sotto 150** → il merito e' **SOSPESO**, come per l'ORB | **0,50** | 🔴 **2,00×** — bug `:253-255` | 🔴 stesso fix del n.6 · deposito del round **NON DICHIARATO** (M-C5) |
| 8 | `ABTG_EMA200` **771531** 🚄 | U30USD H1 | ✅ **R29** walk-forward, cella CENTRO (30/30 PASS) | ✅ **4,69%** (7,21% @1% · **n 444 = MERITO PIENO**) | **1,55** 🥇 | 🟠 divisione del rischio **corretta**, ma **pavimento del lotto per GAMBA** (`:357`) → su conto piccolo **2 × volMin** | 🟠 la **sola sedia della flotta che supera il pavimento di 1,00 op/g DA SOLA**. Serve `S*` misurato (volMin, step, valore punto) per sapere se a 100k il pavimento morde: oggi **NON MISURATO** |

### 🔢 IL CONTO, che e' la riga che conta

| | numero |
|---|---:|
| candidate esaminate | **8** |
| con **R1** (cella promossa) | **6** piene · 2 con etichetta `REGISTRO_TEST` |
| con **R2** (DD promesso misurato) | **8** ✅ — *questo e' il frutto del censimento del 07/09* |
| con **R3** (frequenza misurata) | **8** ✅ |
| con **R4** (rischio vero = dichiarato) | 🔴 **2** — e solo perche' **un `.set` spegne il secondo lato**, non perche' il codice sia sano |
| **che passano TUTTI E QUATTRO** | 🔴 **1** (`770611`) — e `770101` seconda con **un conflitto di DD aperto** |

> ### 🔴 La frase da tenere
> **Il collo di bottiglia della squadra non e' il rendimento: e' che sei sedie
> su otto rischiano fino al DOPPIO di quello che dichiarano.** Il cap C1 firmato
> a 3,25% non e' sbagliato — **e' sbagliato l'ingresso che gli diamo**
> (`RISCHIO_DICHIARATO_VS_VERO_2026-09-08.md` §5). Ed e' un difetto **di due
> righe di codice**, gia' individuato e **non applicato** perche' ricompilare
> cambia il volume delle sedie vive: **e' una firma di Claudio**.

## 1.3 🪑 LA PANCHINA — i 4 candidati "PRONTO SUBITO" (zero EA da scrivere)

Fonte: `report/CORSIA_DEMO_CANDIDATI_v2.md` §2 (07/09 notte).
**Cosa manca e' identico per tutti e quattro: un PRESET, un MAGIC nuovo, una
COMPILAZIONE. ZERO EA da scrivere.** Ed e' la risposta operativa al _"un mese
per creare expert nuovi"_: **non servono expert nuovi per riempire la panchina,
servono tre file.**

| candidato | TF | op/g | DD misurato | pegg. giornata | n | R4 rischio vero |
|---|---|---:|---|---|---:|---|
| 🥇 **RELATIVO NASUSD** (z-score NASUSD/U30USD) | M5 | **0,525** | **8,40%** OOS @0,65% | **−2,12%** | IS 87 / OOS 154 | ✅ **0,65% vere** (`ABTG_Relativo`, una posizione per volta `:1540`) — ⚠️ tick value **nudo** |
| 🥈 **NY SESSION RETEST** slope 75 | M15 + trend H1 | 0,25 | 3,7 - 4,7% | −0,69% | 114-115 | ✅ **0,65% vere** (`ABTG_NySessionRetest:587`) |
| 🥉 **DAX REENTRY LONG** (break 40/20) | M5 | 0,17 | 2,5 - 4,6% | −0,67 / −0,68% | 57 / 92 | ✅ **0,65% vere** (`ABTG_DaxReEntry:444`) |
| 4️⃣ **SUPERWAVE DAX H4** | H4 | 0,12 | 3,3% @1% | 🔴 **NON MISURATA** | 56 | 🔴 **2,00×** (bug `:253-255`) |

🟢 **Il fatto buono di questo giro, e va detto: TRE dei quattro candidati di
panchina hanno gia' il rischio vero = dichiarato**, cioe' sono **piu' puliti
sulla R4 di sei sedie su otto della squadra titolare.**

🔴 **Le riserve del v2, ripetute perche' vanno ripetute ogni volta:** la gamba
**D30EUR** del RELATIVO e' **BOCCIATA PER RISCHIO** (DD OOS 25,01%, peggior
giornata −5,20%) → in demo va **solo NASUSD**; il lato **SHORT** del DAX REENTRY
e' **misurato e morto** (PF 0,38-0,54) → **long-only, scritto nel preset**.

## 1.4 🕐 GLI ORARI DELLA SQUADRA — in ora server BCM, come vuole la regola di casa

| sedia | evento | ora **SERVER BCM** | ora **ITALIANA** | fonte |
|---|---|---|---|---|
| `770101` DAX | apertura + range 35 min | **08:00** | 09:00 | preset `conto_reale/...770101_REALE.set` |
| `770101` DAX | flat di fine seduta | **17:30** | 18:30 | idem |
| `770611` ORB Dow | range 15 min | **14:30 - 14:45** | 15:30 - 15:45 | preset `conto_reale/...770611_REALE.set` |
| `770611` ORB Dow | flat | **21:00** | 22:00 | idem |
| `770202` Dow Apertura | apertura US | **NON MISURATO** — nessun preset in repo | — | 🔴 buco, →§2 |
| Guardian | `InpDailyResetHour` | **23** (= 00:00 CE(S)T) | 00:00 | B3, `FIRME_2026-08-18.md` |

🔴 **UN VINCOLO DI CALENDARIO CHE NESSUNO HA ANCORA SCRITTO, E CADE DENTRO IL
PRIMO MESE DI CHALLENGE:** l'ora legale europea finisce **domenica 25/10/2026**,
quella USA **domenica 01/11/2026**. La riga **B3** e' congelata con l'avvertenza
_"resta [INCERTO] il comportamento invernale/DST"_ (`PIANO_PROP.md` tabella
madre): fra il 25/10 e l'01/11 l'offset del server puo' cambiare **e con lui
l'ora del reset giornaliero del Guardian** — cioe' **il confine della giornata
che la prop misura**. Un reset sbagliato di un'ora e' un muro giornaliero
calcolato sulla finestra sbagliata. → **misura in calendario, §2, riga 29/09.**

---

# 2. 🗓️ IL CALENDARIO ALL'INDIETRO — con date vere e con CHI la fa

**Vincolo di macchina, dichiarato una volta e valido per tutto il calendario:**
🔴 **i round a tick reali girano SOLO sul PC di backtest**, non sul VPS, finche'
il **passo 7 del `QUARTO_MT5_PIANO.md`** non e' verde (l'ancora R119 deve
riprodurre `770611` OOS **2484,17 / PF 1,67490 / DD 6,5389% / 119 trade** e
`770101` OOS **1103,31 / PF 1,41105 / DD 4,3501% / 270 trade** — *identico*).
Passi 1-3 ✅ **fatti** (conto **50504400**, `C:\MT5_Backtest`, HEDGING, 0 EA
attaccati). Restano **5, 6, 7**.

## 🟥 ENTRO MARTEDI' 15/09 — le cose che hanno lead time ESTERNO o che bloccano tutto il resto

| # | cosa | chi | perche' e' la prima settimana |
|---|---|---|---|
| **A1** | 📨 **INVIARE LE DOMANDE AI SUPPORTI PROP** (`report/DOMANDE_SUPPORTO_PROP.md`, pronte dal 13/08, **mai inviate**: decisione di rinvio dello stesso giorno) | 👤 **Claudio** (dalla sua email, risposta SCRITTA, si salva il PDF) | 🔴 **E' L'UNICA VOCE CON UN TEMPO DI RISPOSTA CHE NON CONTROLLIAMO NOI.** La **F4** dice che senza risposte scritte non si compra: se parte il 15, arriva in tempo; se parte il 29, no |
| **A2** | 🔧 **FIRMA sul fix delle due righe** (pavimento del lotto prima del calcolo di `lotPend`) — 15 file, **7 con sedie vive** | 👤 **Claudio** (firma) → 🤖 agenti (patch + test di non-regressione: nel tester il risultato dev'essere **identico al centesimo**) | e' cio' che sblocca la **R4** su `970913`, `770511`, `770901`: **tre sedie su otto** della squadra |
| **A3** | 📁 **SCRIVERE I PRESET DEL CONTO CHALLENGE** — oggi **non esiste nessuna cartella di preset per il 100k**: le taglie 0,65/0,30 che girano **vivono solo nei `.chr`**. Se quel profilo si perde, la configurazione **non e' ricostruibile dal repo** | 🤖 agenti (scrivono i `.set`) → 👤 Claudio (li carica) | senza, il 1 ottobre si parte con una configurazione che **nessun file descrive** |
| **A4** | ✅ **APPLICARE la firma PostNews dell'08/09** (EURJPY 771201 e EURUSD 771202 da **3,0%** a **1,30%**) — firmata oggi, **non ancora applicata sul VPS** | 👤 **Claudio** (terminale **piccolo 50503392**, `C:\Program Files\BCM Markets MT5 Terminal`) | due sedie **senza nessun DD misurato** girano al 3,0% = insieme **6,0 punti = 1,85× il cap C1** |
| **A5** | 🖥️ **Passi 5 e 6 del quarto MT5**: spazio disco + storico su `C:\MT5_Backtest`, e il driver impara **`-TerminaleBacktest`** con la guardia che **muore** se punta altrove | 🤖 agenti (riga) + 👤 Claudio (la lancia) | e' il prerequisito del passo 7, che e' il prerequisito di **ogni round da qui al 30/09** |
| **A6** | 🔎 **Leggere `InpRiskMode` del Guardian** (`ABTG_Guardian.mq5:108`): il cap conta le **GAMBE VERE** (volume × distanza dallo SL) o gli **input degli EA**? | 🤖 agenti (sola lettura) | **cambia la conclusione di meta' §3**: se conta le gambe vere, il moltiplicatore 2× decade sul cap. Costo: zero |

## 🟧 ENTRO MARTEDI' 22/09 — le misure che rendono il 1 ottobre una decisione invece che una scommessa

| # | cosa | chi | cosa produce |
|---|---|---|---|
| **B1** | ⚓ **PASSO 7 — l'ANCORA R119 sul terminale 50504400** | 🤖 agenti preparano · 👤 Claudio lancia (`C:\MT5_Backtest`) | 🟢 verde → i round si spostano sul VPS e il PC puo' stare spento · 🔴 rosso → **la macchina nuova non e' la stessa macchina**, e i round restano dov'erano |
| **B2** | 📊 **M20 — DD FORWARD PER FAMIGLIA** (serie cumulata del netto + massimo picco-valle, per famiglia, dallo statement) | 🤖 agenti (scrivania, zero MT5) + 👤 Claudio (`scarica_pagella.ps1 -Installa`, attivita' **23:15**, scrive `Desktop\pagella_AAAA-MM-GG.txt`) | 🔴 **e' la colonna che oggi e' `n/d` su 16 famiglie su 17** e che rende **non eseguibile** la corsia RISCHIO della C3. Senza, il **cancello 1 non puo' diventare verde in nessun caso** |
| **B3** | 🎯 **RISOLVERE IL CONFLITTO DD della 770101** (R83 6,89% vs R119 4,35% alla stessa taglia) | 🤖 agenti (lettura dei due CSV: finestre, split, trailing 410 del preset reale) | senza, la corsia RISCHIO sulla sedia **piu' veloce del conto reale** puo' scattare a 4,35 o a 6,89: **cioe' non scatta mai in modo prevedibile** |
| **B4** | 🧱 **DEFINIRE I CLUSTER e collaudare il tetto C10 3,0%** (firmato 07/09, implementato v1.13 **spento di default**, **non compilato e non collaudato**) | 👤 Claudio (firma sull'insieme dei cluster, `CLUSTER_PROPOSTA.md` e' PROPOSTO non firmato) → 🤖 agenti (collaudo) | oggi **4 simboli su 15 sfondano da soli il tetto** sul piccolo (U30USD 8,00% · EURUSD 5,00% · GBPUSD 4,50% · EURJPY 3,65%). Finche' non e' attivo **e' un'intenzione, non una protezione** |
| **B5** | 🪑 **PANCHINA IN DEMO**: preset + magic + compilazione per **RELATIVO NASUSD**, **NY RETEST**, **DAX REENTRY LONG** (i tre con R4 gia' pulita) | 🤖 agenti (preset e magic) · 👤 Claudio (compilazione + attach sul **piccolo 50503392**) | +**0,95 op/g** di panchina misurata, e **regime** diverso dalla flotta mono-toro. 🔴 **In demo, MAI sul conto challenge il 1 ottobre**: non hanno un giorno di forward |
| **B6** | 📏 **`S*` DEL PAVIMENTO DEL LOTTO** per le sedie candidate: `SYMBOL_VOLUME_MIN`, `SYMBOL_VOLUME_STEP`, valore per punto via `OrderCalcProfit` | 👤 Claudio (una corsa di `ABTG_SondaMargine`, che **non tocca niente**) sul terminale della challenge | su conto piccolo **6 sedie girano gia' al lotto minimo** e _"le riduzioni sotto ~0,5% sono FINZIONE: rischio reale ~0,7% dove l'input dice 0,25-0,5%"_. A 100k probabilmente non morde — **ma "probabilmente" non e' una misura** |

## 🟨 ENTRO MARTEDI' 29/09 — l'ultima settimana: si chiude, non si apre

| # | cosa | chi | nota |
|---|---|---|---|
| **C1** | 🔢 **RINUMERARE I MAGIC** del conto challenge (decisione firmata n.2 del 02/09: _si rinumerano **solo all'apertura della challenge vera**_) | 🤖 agenti (blocco nuovo) · 👤 Claudio (applica) | oggi il 100k usa **gli stessi magic del piccolo**: sullo statement della prop due conti diversi sarebbero indistinguibili |
| **C2** | 🕐 **MISURA DST**: cosa fa `InpDailyResetHour=23` quando il 25/10 cambia l'ora europea e l'01/11 quella USA | 🤖 agenti (lettura del sorgente Guardian) + 👤 Claudio (screenshot Market Watch + orologio Windows nello stesso scatto, come il 18/08) | 🔴 **cade DENTRO il primo mese di challenge** ed e' il confine della giornata che la prop misura |
| **C3** | ✍️ **LE FIRME**: quale prop (F1) · quale dial (cancello 5: challenge 1,00 / funded 0,74) · quale taglia · **quante sedie e quali** | 👤 **Claudio, e solo lui** | e' la riga di §3 |
| **C4** | 🧾 **CONGELARE LA CONFIGURAZIONE DEL GIORNO 1**: preset, magic, orari server, soglie Guardian, elenco sedie — in **un solo file**, prima di premere | 🤖 agenti scrivono · 👤 Claudio firma | se il 1 ottobre parte una configurazione che nessun file descrive, **il primo drawdown non e' diagnosticabile** |
| **C5** | 📸 **FOTO `.chr` NUOVA DI TUTTI E QUATTRO I TERMINALI** (M-C1: l'ultima automatica e' del **25/08**) — e la controprova **`CODA_05`** (la foto `.chr` e' FRESCA o VECCHIA?) | 🤖 runner notturno (gia' in coda) + 👤 Claudio dove serve | 🔴 il 08/09 due censimenti si contraddicono sul conto reale: `.chr` dice **nessun Guardian**, i log dicono **464 righe scritte alle 23:56**. **Se i `.chr` sono una foto vecchia, sette censimenti descrivono i terminali all'ultimo salvataggio** |

## 🟩 MERCOLEDI' 30/09 — la lista di spunta del giorno prima

Il 1 ottobre si preme **solo se tutte queste righe sono vere**. Se una e' falsa,
**si scrive quale** e si decide con quella scritta davanti.

- [ ] risposte **SCRITTE** dei supporti prop, salvate (A1)
- [ ] prop **scelta e firmata** (F1) e **preset Guardian tarato sui SUOI muri** (cancello 4)
- [ ] elenco sedie del giorno 1, ognuna con **R4 verificata** (rischio vero = dichiarato)
- [ ] **preset su file** per ogni sedia del conto challenge (A3), con `InpAllowShort` esplicito
- [ ] magic rinumerati (C1)
- [ ] Guardian vivo sul conto challenge con soglie **4,0 / 4,9 / 9,9 / reset 23** e cap **3,25%**
- [ ] **M20 consegnato**: DD forward per famiglia contro DD promesso (B2)
- [ ] configurazione del giorno 1 **congelata su file** (C4)
- [ ] foto `.chr` **fresca** e verdetto di freschezza (C5)

---

# 3. 🧮 I NUMERI DELLA CHALLENGE — il conto, non la lista

**Metro:** FTMO 2-Step 100k (**F1, ipotesi di lavoro — non ancora firmata**),
muri **5% giornaliero / 10% totale STATICI**, obiettivo **+10%** fase 1 e
**+5%** fase 2, **4 giorni minimi** per fase, **nessun limite di tempo**
(`docs/REGOLAMENTO_FTMO_2026-08.md` · `PIANO_PROP.md` §2).

## 3.1 🩸 IL MURO GIORNALIERO −5% — **e' questo che morde per primo**

| via di calcolo | numero | margine sul muro 5% |
|---|---:|---|
| **cap C1 firmato**: 5 gambe da 0,65% che stoppano tutte lo stesso giorno | **−3,25%** | **1,75 punti = 35% del muro** ✅ |
| 🔴 **le stesse 5 gambe se il moltiplicatore 2× e' vero** (6 candidate su 8) | **−6,50%** | 🔴 **MURO SFONDATO dai soli stop**, senza un solo errore |
| 🥇 **banco a d=1,00**, 481 partenze rolling: peggior giornata mai vista | **−4,74%** | 🔴 **0,26 punti = 5,2% di margine** — **il numero piu' stretto di tutto il piano** |
| 🥇 **forward 100k realizzato** (10/08→04/09, 16 giornate) | **−0,648%** (= 1R esatto) | 7,7× ✅ — 🔴 **ma sul solo REALIZZATO: il flottante non e' nel CSV, la peggior giornata VERA e' NON MISURATA** |
| 🥇 **sovrapposizione misurata in forward** (03/08 08:15): 9 posizioni di 8 sedie aperte insieme | **5,85% di rischio aperto** | 🔴 **gia' oltre il muro**, ed e' un fatto accaduto, non una simulazione |

> ### 👉 La risposta alla domanda "quante sedie e a quale taglia"
>
> **A 0,65% per sedia, con UNA gamba a rischio vero verificato: 5 sedie.**
> (5 × 0,65 = 3,25% = esattamente il cap C1 firmato il 18/08.)
>
> 🔴 **Con il moltiplicatore 2× non verificato: 2 sedie.**
> (2 × 1,30 = 2,60% ✅ · la terza porterebbe a 3,90% > cap.)
>
> **E oggi le sedie con R4 verificata sono DUE: `770611` e `770101`.**
> Cioe': **il numero di sedie che il 1 ottobre puo' partire senza bluffare non
> e' 5, e' 2 — a meno che A2 e A6 (§2) non chiudano prima.**

## 3.2 🩸 IL MURO TOTALE −10% STATICO

| via di calcolo | numero | margine |
|---|---:|---|
| 🥇 **p99 Monte Carlo** a 0,65%, muro **statico** (`REFERTO_M1_MC_TRAILING.md`) | **8,51%** | **1,49 punti** ✅ stretto |
| 🥇 **banco a d=1,00**, DD totale peggiore su 481 partenze | **−6,37%** | **36% di margine** ✅ |
| 🧮 **somma aritmetica** dei DD promessi delle 5 del 100k a taglia viva (6,89 + 2,98 + 2,74 + 0,83 + 0,57) | **14,01%** | 🔴 **oltre il muro** — ⚠️ e' un **limite superiore mai raggiunto in banco** (i DD non arrivano tutti lo stesso giorno), **ma e' il numero che si otterrebbe se le sedie fossero correlate**, ed e' esattamente cio' che il tetto per cluster C10 dovrebbe impedire — **e C10 non e' attivo** |
| 🔴 **p99 Monte Carlo col muro TRAILING** | **12,05%** | 🔴 **a 0,65% NON regge** — vale se la prop scelta ha muro trailing. **FTMO 2-Step no; la prop pero' NON e' scelta** |

## 3.3 🎯 L'OBIETTIVO +10% — quanti trade, e quanto tempo

| aspettativa usata | profitto/trade a 0,65% | trade per **+10%** | trade per le **due fasi** (10%+5%) |
|---|---:|---:|---:|
| **E alta = 0,075R** (`METRO_PROP.md` §9, DAX Apertura) | 0,0488% | **205** | ~308 |
| **E bassa = 0,046R** (`REFERTO_INVES_2026-08-30` E3) | 0,0299% | **334** | ~501 |

| portata | op/mese | fase 1 | due fasi |
|---|---:|---|---|
| 🔴 **squadra prop di oggi** (5 sedie sul 100k, MISURATA) | **34,7** | **5,9 - 9,6 mesi** | **8,9 - 14,4 mesi** |
| 🟡 **flotta intera migrata**, portata MISURATA | **111,9** | **1,8 - 3,0 mesi** | **2,8 - 4,5 mesi** |
| 📐 controprova indipendente: **banco R105** a taglie firmate | — | mediana **12 giorni** a +8% | — |
| 🥇 **dry-run 100k, ritmo reale** (+2.854,99 € in 16 giornate) | — | **≈1,8 mesi** (grezzo) · **≈3,1 mesi** (normalizzato) | — |

🔴 **E il fattore che puo' azzerare tutta la tabella:** il **segno di E**.
Banco **+0,091R**, forward del conto piccolo **−0,091R** — due misure NOSTRE,
stesso rango 🥇, **segno opposto**, conflitto **aperto** (`PIANO_PROP.md` H1).
E BCM ha confermato per iscritto che **il demo non simula lo slippage**: il vero
E, sul conto che conta, e' **probabilmente peggiore di entrambe** le righe
forward. **N × E con E < 0 non produce profitto: produce perdita piu' in fretta.**

## 3.4 📏 LA TAGLIA DEL CONTO — e l'orientamento dichiarato di Claudio

Claudio, 26/08, testuale: _"con molta probabilita' voglio partire con una
challenge tra le PIU' ALTE che ci sono"_. **Registrato, non e' una firma.**

🔴 **Il cancello 6 e' ROSSO e non e' un formalismo**: tutto il banco di casa e'
su **base 100k** e su una **scala lineare dei lotti**, e **R109 ha misurato che
la linearita' si rompe** — il lotto sbatte sul tetto `SYMBOL_VOLUME_MAX`=100 su
**66 trade su 743 = 8,9%**, e lo slippage misurato e' **21,5 punti su uno stop
reale** (perdita **doppia** dell'attesa), e cresce con la taglia.

👉 **Proposta dell'architetto-prop (decide Claudio):** il 1 ottobre si parte a
**100k**, la taglia su cui **tutto** il nostro banco e' costruito. La taglia
grande si compra **dopo** il round di prova della taglia (M21), che e' un round
di banco e **non blocca niente** — si puo' fare mentre la challenge gira.

---

# 4. 🔴 LA RISPOSTA ONESTA SULLA FATTIBILITA'

## 4.1 L'aritmetica del forward, senza addolcirla

Il criterio di casa dice **150 operazioni** per un giudizio di MERITO
(Emendamento della finestra, 16/08). Con le frequenze **misurate** di §1.2:

| sedia | op/giorno | giornate per 150 op | **quando arriva** (da oggi, 21,7 giornate/mese) |
|---|---:|---:|---|
| `771531` EMA200 U30USD (la piu' veloce) | 1,55 | 97 | **fine gennaio 2027** |
| `770101` DAX Apertura | 0,97 | 155 | **inizio aprile 2027** |
| `770611` ORB Dow | 0,43 | 349 | **agosto 2027** |
| **squadra prop intera** (34,7 op/mese, di squadra) | — | — | **meta' gennaio 2027** |

> ### 🎯 In nessuno scenario e' ottobre. **Il 1 ottobre 2026 NON avremo una flotta provata in forward, e non c'e' modo di averla.**
> Una sedia accesa **oggi** a ~1 operazione al giorno arriva a 150 operazioni
> **fra gennaio e aprile 2027**. La soglia piu' bassa — le **20 operazioni per
> famiglia** della corsia MERITO firmata il 18/08 — oggi la superano **2 famiglie
> su 17** (Aperture DAX 38 · ORB 25), e la piu' numerosa **e' in perdita**
> (−698,46 €). Tre settimane non cambiano questo numero: **lo spostano di
> ~15 operazioni per famiglia veloce, zero per le altre.**

## 4.2 ✅ COSA **SARA'** PROVATO il 30 settembre

| cosa | numero | fonte |
|---|---|---|
| **celle misurate a TICK REALI** | R83 (n 311) · R119 (**16 CSV, gemelli identici 8/8, 0 rilievi**) · R15/R16 · R29 (30/30 PASS) | `CENSIMENTO_CONTRATTI.md` |
| **il ritardo di esecuzione del banco** | ✅ **misurato 07/09, ipotesi congelata FALSIFICATA**: lo STOP e' **immune**, il LIMIT si muove **≤2% e in MEGLIO** | R119 §4 |
| **determinismo del banco** | ✅ verificato su U30USD/M5 (gemelli identici alla cifra) — 🔴 **non** sul ramo indici | R119 §G1 |
| **pass-rate simulato** alla taglia firmata | **99,6%** su 481 partenze rolling, mediana **12 giorni**, **zero violazioni dei muri** | `ANALISI_DIAL_TAGLIE_2026-08-26.md` T2 |
| **sopravvivenza funded 12 mesi** | **100%** (230/230), statico e trailing | `ANALISI_SOPRAVVIVENZA_FUNDED_2026-08-26.md` T1 |
| **dry-run sul 100k** | al 1/10 saranno **~7,4 settimane**; oggi **+2,85%**, **27 chiusure in 16 giornate**, peggior giornata realizzata **−0,648%** | `PIANO_PROP.md` §1.4 |
| **Guardian in campo** | vivo sul 100k coi muri firmati; enforcement fase 1 **criteri 1-4 verdi**, canarino P-C1 **8/8 in campo** | `COLLAUDO_ENFORCEMENT_FASE1_2026-09-02.md` |
| **il rischio vero del parco** | 🆕 **91 EA letti riga per riga** l'08/09: sappiamo **dove** il dichiarato mente e **di quanto** | `RISCHIO_DICHIARATO_VS_VERO_2026-09-08.md` |

## 4.3 ❌ COSA **NON** SARA' PROVATO — e cosa comporta partire lo stesso

| cosa manca | stato al 30/09 (previsto) | 🔴 rischio residuo, in numeri |
|---|---|---|
| **forward maturo** (150 op per famiglia) | **impossibile** — vedi §4.1 | il giudizio di MERITO resta **formalmente sospeso su quasi tutta la squadra**: si parte con motori validati **in banco**, non **in campo** |
| **DD forward per famiglia** (M20) | ottenibile entro il 22/09 (B2) **se qualcuno lo calcola** | senza, la corsia RISCHIO della C3 **non e' eseguibile**: nessuno sa se una sedia sta gia' facendo peggio del promesso. **L'unica calcolata dice 7,36% contro 6,25% promesso = 1,18×** (M31) |
| **slippaggio su conto vero** | 🔴 **0 deal** dal `SlippageLogger`. Le due sedie del reale **non hanno mai eseguito** | **ogni** gradino di slippage di **ogni** round e' uno **SCENARIO ASSUNTO** (R118 lo dichiara tre volte), e ogni riga di forward demo e' **ottimista per costruzione**. R109 misura **21,5 punti su uno stop** = perdita **doppia** |
| **peggior giornata VERA** (flottante incluso) | 🔴 **NON MISURATA** | il muro giornaliero guarda l'**equity**, i nostri CSV vedono i **chiusi**: il **−0,648%** e' un **pavimento**, non la peggior giornata |
| **prova di regime ORSO** | 🔴 481 giornate di banco = **un solo regime, toro** | il 99,6% di pass-rate descrive un mercato **che sale**. Non sappiamo cosa fa la squadra in un crollo |
| **prova della taglia** (>100k) | 🔴 **mai fatta** | percentuali **non trasferibili** sopra i 100k (§3.4). Mitigato scegliendo 100k |
| **tetto per cluster C10** | firmato · implementato · **non compilato, non collaudato** | 4 simboli sfondano da soli il 3,0%; e la **somma dei DD promessi e' 14,01%** contro un muro di 10 |
| **la prop scelta** (cancello 3) | 🔴 rosso: Upcomers bocciata, dossier Orbit su prodotto instant, **E8 e Alpha mai istruite** | il preset Guardian e' tarato **solo su FTMO**: su muri diversi **ogni soglia sta oltre il muro che dovrebbe proteggere** (dimostrato per assurdo sul dossier Upcomers) |
| **difetto hedging C9** | **34 EA su 126** non eseguono la gestione che dichiarano; **danno gia' misurato**: `ABTG_ORB` nativo ha aperto il secondo lato vietato in **4 giornate su 16** | un enforcement che funziona non serve a niente se l'EA sotto **non fa quello che dice** |
| **quale albero viene compilato sul VPS** | ✅ risolto **per il PostNews** (albero principale, 4 prove dalla F7 dell'08/09) · 🟠 per gli altri: `CODA_06` in coda | su **14 EA** i due alberi dichiarano entrambi 1.00: la versione non discrimina |

## 4.4 ⚖️ IL VERDETTO, senza addolcire e senza spaventare

**Partire il 1 ottobre significa comprare una challenge con una squadra che ha
un ottimo banco e un forward giovane.** Il rischio residuo, in tre numeri:

1. **Il muro che si rompe per primo e' il giornaliero, e il margine di banco e'
   0,26 punti** (−4,74% misurato contro −5,00%). Non e' un margine comodo.
2. **Il p99 sul totale e' 8,51% contro 10%: 1,49 punti.** Regge — **ma quel p99
   e' calcolato su input di rischio che in 6 sedie su 8 valgono la meta' del
   vero.** Se il 2× e' reale su meta' squadra, quel p99 **non vale piu'**, e
   nessuno sa di quanto.
3. **Il segno di E non e' accertato in forward.** Se e' negativo, la challenge
   **non si perde per un muro: non si passa mai** — e su FTMO, dove **non c'e'
   limite di tempo**, questo si paga in **tempo e fee**, non in bocciatura.

🟢 **La cosa che rende il 1 ottobre difendibile lo stesso**, e va detta accanto:
FTMO 2-Step **non ha limite di tempo** e **non ha consistency rule dure**. La
lentezza costa **tempo e opportunita', non l'esito**. Il costo vero di partire
presto e' **la fee**, non il conto — a patto che i muri reggano, ed e' esattamente
cio' che §3.1 e §3.2 misurano.

👉 **Proposta dell'architetto-prop, dichiarata come tale:** si parte il 1 ottobre
**a 100k, con 2-3 sedie a R4 verificata**, non con cinque. Le altre entrano **a
scaglioni**, una alla volta, ognuna quando la sua R4 e' chiusa. E' la sola
configurazione in cui il **cap C1 firmato descrive il rischio vero** invece di
descrivere un input. **Decide Claudio.**

---

# 5. 🚨 LE TRE COSE CHE POSSONO FAR FALLIRE IL PIANO

## 🥇 1. IL MOLTIPLICATORE IGNOTO SOTTO IL CAP C1

**Il fatto:** 6 candidate su 8 hanno **rischio vero fino a 2× il dichiarato**
(bug tranche su 15 file · due pendenti opposti con **OCO software, non di
broker** · `ABTG_DEF_RISK 2.0` nei sorgenti delle Aperture). Il cap C1 conta
*"quante sedie × quanto dice l'input"*, non *"quante GAMBE × quanto perde
davvero uno stop"*. **Con 5 sedie il muro giornaliero passa da −3,25% a −6,50%:
sfondato dai soli stop.**

**Contromisura (in tre mosse, tutte in calendario):**
- **A6 (entro il 15/09, costo zero):** leggere `InpRiskMode`
  (`ABTG_Guardian.mq5:108`). **Se il Guardian legge le posizioni VERE, gran
  parte del problema decade** — e va saputo prima di scegliere quante sedie.
- **A2 (entro il 15/09, firma di Claudio):** il fix di due righe su 15 file, col
  test di non-regressione dichiarato prima (**identico al centesimo** nel tester).
- **Regola del giorno 1 (proposta):** **entra solo chi ha R4 verificata**, con
  `InpAllowShort=false` **scritto nel preset**, non dedotto.

## 🥈 2. LA PROP NON E' SCELTA, E IL REGOLAMENTO NON E' VERIFICATO PER ISCRITTO

**Il fatto:** il **cancello 3 e' rosso**. Le domande ai supporti sono pronte dal
**13/08** e **non sono mai state inviate** (rinvio deciso lo stesso giorno). La
**F4 congelata** dice che senza risposte scritte **non si compra**. E il preset
Guardian e' tarato **solo su FTMO**: su una prop con muri diversi ogni soglia
starebbe **oltre** il muro che dovrebbe proteggere.
🔴 **E c'e' una data dentro la data:** se la prop scelta avesse un muro
**TRAILING**, il p99 a 0,65% e' **12,05% > 10%** — **la taglia di casa non
reggerebbe**, e sarebbe una scoperta fatta dopo aver pagato.

**Contromisura:**
- **A1 e' la PRIMA riga del calendario proprio per questo**: e' l'unica voce con
  un tempo di risposta **che non controlliamo noi**. Inviata il 15, arriva in
  tempo; inviata il 29, no.
- **Vincolo proposto:** si compra **solo** una prop a muri **5/10 STATICI** con
  **EA ammessi per iscritto**. Se al 30/09 non c'e' la risposta scritta, **la
  data slitta di una settimana** — non si sceglie a occhio.

## 🥉 3. LA DATA CHE PRENDE IL POSTO DEI CANCELLI

**Il fatto:** questo progetto ha **sei cancelli** e una regola di casa che dice
_"la data e' una conseguenza, non un obiettivo"_. Oggi, per la prima volta, c'e'
**una data prima dei cancelli**. Il rischio non e' teorico: e' che nelle ultime
72 ore prima del 1 ottobre un cancello venga dichiarato verde **perche' e'
tardi**, non perche' e' verde. E' successo altre volte nel piccolo (una chiave
`.ini` inventata che avrebbe prodotto _"un referto verde con una bugia sotto"_,
fermata dal canarino di R119).

**Contromisura:**
- **La lista di spunta del 30/09 (§2) e' BINARIA**: ogni riga e' vera o falsa,
  **nessuna riga "quasi"**. Se una e' falsa, si scrive **quale** e si decide con
  quella scritta davanti.
- **Lo slittamento e' preventivato, non e' una sconfitta:** su FTMO **non c'e'
  limite di tempo**, quindi partire il 1 o il 15 ottobre **non cambia l'esito**,
  cambia solo la data. Il costo di aspettare due settimane e' **zero**; il costo
  di partire con un cancello finto e' **la fee piu' il tempo**.
- 🔴 **E la riga di onesta' che vale per tutto il documento:** i round a tick
  reali oggi girano **solo sul PC di backtest**. Se il PC e' spento e il passo 7
  del quarto MT5 non e' verde, **meta' di questo calendario non si esegue** —
  ed e' il motivo per cui A5 e B1 stanno nelle prime due settimane.

---

# 6. ✍️ COSA SERVE CHE FIRMI CLAUDIO — in ordine di urgenza

| # | firma | perche' e' sua e non mia | entro |
|---:|---|---|---|
| 1 | **Invio delle domande ai supporti prop** (riapre la decisione di rinvio del 13/08) | e' la sua email e la sua identita' verso la prop | **15/09** |
| 2 | **Il fix delle due righe** (15 file, 7 con sedie vive) | ricompilare **cambia il volume delle sedie vive**: e' un intervento sulla **taglia** | **15/09** |
| 3 | **Quante sedie e quali il giorno 1** (proposta: 2-3 a R4 verificata, non 5) | e' rischio, ed e' il suo conto | **29/09** |
| 4 | **Quale prop e quale taglia** (proposta: 100k, muri statici) | sono soldi | **29/09** |
| 5 | **L'insieme dei CLUSTER** per il tetto C10 (`CLUSTER_PROPOSTA.md` e' PROPOSTO, non firmato) | e' una scelta, non una misura | **22/09** |
| 6 | **Quale dial** in quale fase (cancello 5: challenge 1,00 / funded 0,74, **con conflitto dichiarato** con R106) | e' rischio | **29/09** |

---

## 📚 FONTI DI QUESTO DOCUMENTO — tutte nel branch `lavoro`

**🥇 Misurato da noi:** `report/CENSIMENTO_CONTRATTI.md` (07/09) ·
`report/RISCHIO_DICHIARATO_VS_VERO_2026-09-08.md` ·
`report/CENSIMENTO_RISCHIO_DICHIARATO_2026-09-08.md` · `report/PIANO_PROP.md` v20 ·
`report/METRO_PROP.md` · `report/M31_RISCHIO_REALIZZATO_2026-09-02.md` ·
`backtest_pipeline/risultati_archivio/REFERTO_M1_MC_TRAILING.md` ·
`.../REFERTO_M2_SOVRAPPOSIZIONE.md` · `.../ANALISI_DD_TOTALE_2026-08-26.md` ·
`.../ANALISI_DIAL_TAGLIE_2026-08-26.md` · `.../ANALISI_SOPRAVVIVENZA_FUNDED_2026-08-26.md` ·
`.../REFERTO_RITARDO_R119_PRIMO_GIRO.md` · `.../REFERTO_R118_PAVIMENTO_STOP.md` ·
`.../R109_REFERTO.md` · `.../SPREAD_FLOTTA_MISURA_2026-09-03.md` ·
`backtest_pipeline/coda/referti/CODA_0*_2026090*.log`

**✍️ Firme:** `report/FIRME_2026-08-18.md` (C1 3,25% · C3 tre corsie · pacchetto
Guardian) · `report/FIRME_2026-09-02.md` · `report/FIRME_2026-09-03.md` ·
`report/FIRME_2026-09-07.md` (pavimento per famiglia · tetto cluster 3,0%) ·
`report/FIRMA_POSTNEWS_130_2026-09-08.md`

**🥈 Regole prop:** `docs/REGOLAMENTO_FTMO_2026-08.md` ·
`docs/REGOLAMENTO_FUNDINGPIPS_2026-08.md` · `report/DOMANDE_SUPPORTO_PROP.md`
(⏸️ **mai inviate**)

**Piani e candidati:** `report/QUARTO_MT5_PIANO.md` ·
`report/CORSIA_DEMO_CANDIDATI_v2.md` · `report/CE_LA_FAREMO_2026-09-07.md` ·
`report/NOVITA_2026-09-08.md` · `report/QUALE_CODICE_GIRA_2026-09-08.md`

> **Se un referto e questo piano divergono, comanda il referto.**

---

## 📜 CHANGELOG

| data | versione | cosa cambia | perche' |
|---|---|---|---|
| **08/09/2026** | **v1** | prima stesura. Nasce dalla frase di Claudio dell'08/09 (_"dai primi d'ottobre vorrei iniziare la challenge"_): il piano viene costruito **all'indietro dal 1 ottobre** invece che in avanti dai cancelli. Novita' incorporate lo stesso giorno: il **requisito R4** (rischio vero = dichiarato) dal censimento del codice di sizing su 91 EA, la **firma PostNews 1,30** e il **rilievo DST del 25/10-01/11** che nessun documento aveva ancora scritto | c'e' una data, e una data cambia l'ordine delle cose — **non i criteri** |

---

# 🔄 AGGIORNAMENTO DI CLAUDE — 08/09/2026, poche ore dopo la stesura

## ✅ IL FIX DI DUE RIGHE **E' STATO APPLICATO** (commit `872dba8`)
Il piano dice *"difetto di due righe, individuato e **non applicato**"*. Vero
quando è stato scritto, **superato adesso**: la correzione è nei sorgenti, in
**tutti e 15** i file (13 in `mql5/Experts/`, 2 in `standalone/`), con le
versioni alzate **1.00 → 1.01** e le tre verifiche testuali passate
(`report/FIX_LOTTO_PENDENTE_2026-09-08.md`).

### 🔴 Ma il requisito R4 **NON è ancora soddisfatto**, e la differenza è tutta qui
Sui terminali **gira l'`.ex5`, non il sorgente**. Finché quelle 7 sedie vive
non vengono **ricompilate (F7) e ricaricate**, il codice che rischia è ancora
quello vecchio.

| stato | R4 |
|---|---|
| sorgenti nel repo | ✅ corretti |
| `.ex5` sui terminali | 🔴 **ancora il vecchio** |
| **firma che serve** | ricompilare **cambia il volume** delle sedie vive → **è una decisione di Claudio** |

👉 Quindi il conto del piano — *"5 sedie se R4 è verificata, 2 altrimenti"* —
**resta valido**: oggi siamo ancora a 2. Ma la distanza da 5 non è più "un
lavoro da fare": è **una compilazione e un ricarico**.

## 🔍 E il numero che regge la raccomandazione è andato in verifica
La proposta del piano (*"slittare di due settimane costa zero perché su FTMO
non c'è limite di tempo"*) poggia su una regola **assunta, non letta alla
fonte**. È partito un agente a verificarla per iscritto, insieme a tutto il
resto del regolamento delle prop candidate → `report/REGOLAMENTI_PROP_2026-09-08.md`.

🔴 **La domanda più pericolosa di quel giro non è il limite di tempo: è se il
muro totale sia STATICO o TRAILING.** Tutte le misure di DD del progetto
assumono **statico**. Se la prop scelta usa il trailing, **vanno rilette
tutte**, e va detto prima di comprare — non dopo.


---

# 🪦 ERRATA 11/09/2026 (sera) — IL DD DELLA `770101`, E LA SOMMA ARITMETICA RIFATTA

🚫 **Questo file NON e' stato riscritto**: e' il verbale dell'08/09 e resta com'era.
Qui sotto c'e' **solo** la correzione, perche' chi ci ripassa non riusi un numero morto.

## 1. Il conflitto di r.91 e di **B3** (r.191) e' **CHIUSO**, non aperto

| | |
|---|---|
| **DD promesso della `770101`, oggi** | 🆕 **4,3501%** @ taglia viva **0,65%** — **[MISURATO a deposito 10.000 EUR]** |
| fonte | `risultati_archivio/ritardo_r119b_csv/ABTG_DAX_Apertura_EU_D30EUR_OOS_R119_DAX_D0000.csv` r.2 (`InpAllowShort=0` · `InpRiskPercent=0.65` · `InpMagic=770101` · PF 1,41105 · n 270), riprodotto in `ancora_passo7/..._OOS_ANCORA.csv` |
| da dove veniva il **6,89%** | scalatura di **10,5984%**, misurato su `r83_csv/..._r83d1.csv`, che ha **`InpAllowShort=1`**, **`InpRiskPercent=1`** e **`InpMagic=777120/777121`**: **un'altra configurazione**, mai girata sul conto reale |
| la causa, misurata | **il LATO CORTO**: +3,8873 punti di DD (10,5984 con · **6,7111** senza, stessa finestra, stesso deposito, stessa taglia 1,0%) |
| ⚠️ **l'asterisco che non va perso** | il 4,3501% e' misurato su banco **10.000 EUR**. Su un banco da **100.000 EUR** il DD promesso e' **`[NON MISURATO]`**: la stessa cella long-only a 1,0% fa **7,2328%** a 100k contro **6,7111%** a 10k, **+7,8% a parita' esatta di 270 operazioni**. Per proporzione starebbe a ~4,69%, **ma una proporzione non fa scattare un allarme** |

📄 Dossier completo (6 ipotesi alternative rotte una per una): `report/CONFLITTO_DD_770101_2026-09-11.md`.

## 2. 🧮 LA SOMMA ARITMETICA DI **§3.2 (r.258)** e di r.345 — RIFATTA

```
VECCHIA (verbale 08/09):  6,89 + 2,98 + 2,74 + 0,83 + 0,57 = 14,01 %
NUOVA   (11/09):        4,3501 + 2,98 + 2,74 + 0,83 + 0,57 = 11,47 %
-----------------------------------------------------------------------
           differenza  -2,54 punti, ed e' TUTTA della 770101
```

Gli altri quattro addendi **non cambiano**: `770611` ORB **2,98%** a 0,30% ·
`770202` Dow Apertura **2,74%** · `770411` MaxMin DAX Short **0,83%** ·
`770901` STREV Nikkei **0,57%**.

### ⚖️ E IL VERDETTO, riscritto con precisione

| | vecchio | 🆕 nuovo |
|---|---|---|
| somma aritmetica | **14,01%** | **11,47%** |
| contro il muro **statico** di **10%** | 🔴 sfora di **+4,01 punti** | 🔴 **sfora ancora, ma di +1,47 punti** |
| di quanto e' sopra, in relativo | **+40,1%** | **+14,7%** |

- 🔴 **IL VERDETTO NON SI RIBALTA: la somma resta SOPRA IL MURO.** La riga
  *"oltre il muro"* di r.258 e di r.345 **rimane vera**, e con essa l'argomento
  che la sostiene: e' un **limite superiore mai raggiunto in banco** (i DD non
  arrivano tutti lo stesso giorno), **ma e' cio' che si otterrebbe se le sedie
  fossero correlate** — ed e' esattamente cio' che il tetto per cluster **C10**
  dovrebbe impedire. 🔴 **E C10 continua a NON essere attivo**: firmato 07/09,
  implementato v1.13 spento di default, **non compilato e non collaudato**.
- 🟡 **CIO' CHE CAMBIA E' LA DISTANZA, e cambia parecchio: lo sforamento si
  riduce del 63%.** Con 11,47% il caso-peggiore-correlato passa da *"muro sfondato
  di quattro punti"* a *"muro sfondato di uno e mezzo"*: **lo stesso segnale
  rosso, ma la distanza dalla salvezza e' ora dell'ordine di UNA sedia piccola**
  (togliere la `770901`, 0,57%, e la `770411`, 0,83%, porterebbe la somma a
  **10,07%**, cioe' **sul muro**). Prima non bastava nemmeno togliere due sedie.
- 📐 **E il confronto interno a §3.2 diventa leggibile**: lo sforamento della
  somma (**1,47 punti**) e il margine del **p99 Monte Carlo** a muro statico
  (**1,49 punti**) sono ora **praticamente lo stesso numero, di segno opposto**.
  🔴 **Non e' una conferma incrociata** — sono due modelli diversi (uno assume
  correlazione 1, l'altro la simula) e la coincidenza e' **numerica, non causale**.
  Detto qui perche' nessuno la usi come prova di niente.
- ⚪ **Non tocca il resto del file.** Il muro **TRAILING** (p99 12,05%), il cap
  C1 3,25%, il conto delle 2 sedie con R4 verificata (r.88-94) e il segno di **E**
  restano **esattamente come sono scritti**: nessuno dei quattro dipende dal DD
  promesso della `770101`.

> 🧊 **Perche' la riga vecchia resta scritta**: cancellarla cancellerebbe la prova
> che il metodo ha trovato l'errore. Il numero da usare per decidere e'
> **11,47%**, e il documento da cui si decide e'
> `report/PIANO_CHALLENGE_OTTOBRE_v2.md`.
