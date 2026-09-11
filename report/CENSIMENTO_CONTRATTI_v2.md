# 📜 CENSIMENTO DEI CONTRATTI — **v2**, rifatto coi numeri dell'11/09/2026

> ## 📌 QUALE DOCUMENTO COMANDA — dichiarato prima di ogni numero
> **QUESTO `_v2` È IL CENSIMENTO VIVO.** `report/CENSIMENTO_CONTRATTI.md` (v1,
> 07/09) resta in archivio **come verbale di quello che credevamo il 07/09** e
> **non va usato per far scattare niente**: sei sue premesse sono state
> **misurate false o incomplete** fra il 10 e l'11/09. Non l'ho sovrascritto
> apposta — cancellarlo cancellerebbe la prova che il metodo le ha trovate.

> 🛑 **QUESTO FILE NON CAMBIA NIENTE.** Nessun `.mq5`, nessun `.set`, nessun
> parametro in forward, nessun terminale, nessuna riga verso il VPS. **Le
> taglie, il rischio, il conto reale 10105439 e i soldi restano firma di
> Claudio.** Qui ci sono **contratti proposti con la loro provenienza**, non
> decisioni.

_Scritto dall'**architetto-prop**, **venerdì 11/09/2026**._

---

# 0. 🎯 PERCHÉ ESISTE E PERCHÉ ORA

Questo file è **l'unico ingresso della corsia RISCHIO** del criterio di uscita
firmato il 18/08 (`report/FIRME_2026-08-18.md`): *"DD forward > DD promesso dal
backtest della cella promossa → revisione IMMEDIATA"*. Ed è **l'unico ingresso
della corsia TAGLIANDO** per la frequenza: *"frequenza molto sotto il promesso
→ revisione"*.

> 🔴 **Un contratto sbagliato trasforma un forward sano in una violazione, e
> viceversa.** Il caso che ha aperto questo giro: `771531` EMA200 Dow. Il v1
> prometteva **7,21% · n 444**. La misura giusta è **7,8323% · 517 uscite =
> 257 posizioni · deposito 100.000 · tick**. 👉 **Col contratto vecchio un
> forward al 7,5% era una violazione. Col contratto giusto non lo è.**

---

# 0-bis. 🧪 IL CONTRO-ESEMPIO, COSTRUITO PRIMA DI SCRIVERE LA TABELLA

Il pericolo di questo lavoro ha un nome: **allargare un contratto rende più
difficile far scattare la revisione.** Quindi mi sono dato tre regole prima di
toccare un numero, e le dichiaro perché siano verificabili contro di me:

| regola | come l'ho applicata | dove si vede |
|---|---|---|
| 🧮 **Non "aggiustare" un `n` che non ho misurato** | dove il per-trade non è in archivio ho scritto **`[NON MISURATO]` + la forbice**, **mai** una divisione per 2. Il fattore uscite/posizioni **non è costante**: l'ho misurato su **31 file** e va da **1,00 a 2,31** | §1.3 |
| 📏 **"Più vero" ≠ "più nuovo"** | ogni DD porta **deposito + rischio + modello di barre**. Un numero misurato a un deposito che non è quello del conto **non è migliore: è diverso** | colonna *"a quale taglia"* |
| ⬆️ **Ogni contratto ALLARGATO va giustificato con la misura** | i contratti che salgono sono **2** e tutti e due hanno una misura sotto: `771531` (7,21 → **7,83%**, riprodotta 3 volte al centesimo) e `770101` (nessun cambio di DD, cambia il `n`). 🔴 **I contratti che peggiorano peggiorano e basta** | §5 |

## 🔴 E il contro-esempio che MI HA SMENTITO — due volte, e va detto per primo

**(1) La classe 226 dichiarava "salve" le due Aperture. È FALSO, e l'ho
misurato.** La classe cercava `InpTP1Pct` con `grep`. `ABTG_DAX_Apertura_EU`
**non ha quel parametro**: ha **`InpTP1_ClosePct = 50`** (`.mq5` r.319) — stesso
meccanismo, **altro nome**. E `ABTG_GapContinuation` ne ha un **terzo**:
`InpPartialClosePercent = 40` (r.159).

> 📐 **La prova non è il grep, è il conteggio**: sul per-trade della cella di
> contratto di `770101` (`r83_csv/pertrade_r83d1_777120.csv`) le righe sono
> **311** e i `position_id` distinti **245** → **fattore 1,27**, e la
> distribuzione è **179 posizioni con 1 uscita + 66 con 2**. Se il parziale non
> ci fosse, il fattore sarebbe **1,00 esatto**. 👉 **Il `n = 311` del contratto
> v1 non erano operazioni: erano 245.**

**(2) Il `n` IS di `771531` NON è verificato in posizioni, e qualcuno l'ha dato
per buono.** `PIANO_CHALLENGE_OTTOBRE_v2.md` §0 scrive che `771531` ha *"tutte e
due le finestre sopra la soglia contata in POSIZIONI"*. 🔴 **In archivio il
per-trade IS NON ESISTE**, e lo dice il referto R112 stesso (*"il driver corre
gamba IS poi gamba OOS nella stessa chiamata e l'export sovrascrive il file del
magic a ogni gamba — sopravvive l'ultima"*). Il `237` è in **uscite**; con il
fattore misurato sulla **stessa cella** (2,01) fa **~118 posizioni**, cioè
**sotto 150**. 👉 **L'OOS di `771531` regge (257 ≥ 150, misurato). L'IS no, ed è
`[NON MISURATO]`.**

---

# 1. ⚖️ LE UNITÀ DI MISURA — senza queste, i DD e gli `n` non si confrontano

## 1.1 Il DD
1. **Sempre con DEPOSITO + RISCHIO % + MODELLO DI BARRE** del backtest che l'ha
   prodotto. Un DD 10% a rischio 1% e uno a 0,25% **non sono lo stesso rischio**.
2. **Scala col rischio ~linearmente** — 🔴 **[APPROSSIMATO], convenzione di
   casa, NON una misura.** E oggi sappiamo **di quanto sbaglia**: sulla
   riconciliazione R29↔R112 di `771531` il metro lineare sbaglia del **6%**
   (`PIANO_PROP.md` J2). Dove la sedia gira a taglia diversa dal banco, il DD
   alla taglia viva è marcato `≈` **e non vale come numero di contratto**.
3. **Il DD% è ~indipendente dal deposito** a rischio percentuale — 🔴 **ma solo
   finché il PAVIMENTO DEL LOTTO non morde** (classe 228/229). A deposito
   piccolo `MathFloor` sullo step taglia il lotto e la sedia rischia **meno**
   del dichiarato: su `771531` a 10.000 € il rischio effettivo è **~0,87%**
   invece di 1,00%. **Gli euro non scalano mai.**
4. `tick` = tick reali (Modello 4) · `OHLC` = M1 OHLC (Modello 1) = **limite
   INFERIORE del DD, mai un permesso**.

## 1.2 La finestra — 🆕 **CLASSE 224**
Un `n` non è un numero: è **un numero più la finestra da cui viene**. Una corsa
a **finestra piena non ha nessun fuori campione**: è tutta dentro campione.
👉 Colonna **`OOS vero?`**: ✅ = partizione IS/OOS dichiarata · 🔴 = finestra
piena (il `n` non giudica il merito) · ⚪ = screening `_ohlc`.

## 1.3 Il `n` — 🆕 **CLASSE 226**, e il fattore **NON è costante**
La colonna `Trades` dell'OPTFRAME (`STAT_TRADES`) conta i **deal di uscita**.
Col parziale al 50% una posizione chiude in due deal; con la tranche pendente
`1/3 + 2/3` un segnale apre due posizioni.

### 📐 I FATTORI MISURATI OGGI, contando i `position_id` distinti su **31 file per-trade**

| file / cella | uscite | **posizioni** | fattore |
|---|---:|---:|---:|
| `R112` EMA200 U30USD OOS `00_metro` (= `771531`) | 517 | **257** | **2,01** |
| `R112` `01_short_r1` | 302 | 140 | 2,16 |
| `R112` `02_short_r2` | 315 | 140 | 2,25 |
| `R112` `03_short_r3` | 324 | 140 | **2,31** ⬅️ massimo |
| 🆕 `R23` PTE GBPUSD `771313` | 49 | **27** | 1,81 |
| 🆕 `R23` PTE U30USD `771311` | 40 | **23** | 1,74 |
| 🆕 `R23` PTE USDJPY `771315` | 35 | 20 | 1,75 |
| 🆕 `R23` SuperWave U30USD `770521` | 88 | **50** | 1,76 |
| 🆕 `R23` SuperWave GBPUSD `770523` | 63 | 39 | 1,62 |
| 🆕 `R81` MaxMin DAX Short (6 celle) | 14-22 | 14 | **1,00 – 1,57** |
| 🆕 `R83` Apertura D30EUR (3 celle + validazione) | 311-325 | 245-265 | **1,22 – 1,28** |
| 🆕 `R84` Nasdaq Apertura (9 celle) | 69-291 | 60-241 | **1,15 – 1,23** |

> # 🔴 **FORBICE MISURATA: da 1,00 a 2,31.** Dividere per due è **inventare**.
> Dove il per-trade non è in archivio la cella dice **`[NON MISURATO]`** e
> riporta la forbice `n/2,31 … n/1,00`.

### 🧬 CHI HA IL PARZIALE — rifatto sui sorgenti, **non sul grep di un nome solo**

| EA | parametro | valore | conseguenza |
|---|---|---:|---|
| `ABTG_DAX_Apertura_EU` | 🆕 **`InpTP1_ClosePct`** | **50** | 🔴 **COLPITA** — la v1 e la classe 226 la davano salva |
| `ABTG_Nasdaq_Apertura_US` | 🆕 **`InpTP1_ClosePct`** | **50** (e **50,0 nel preset LIVE** di `770250`) | 🔴 **COLPITA** |
| `ABTG_Apertura_3Ingressi` (EA di banco di R83) | `InpTP1_ClosePct` | 50 | 🔴 colpita |
| `ABTG_GapContinuation` | 🆕 **`InpPartialClosePercent`** | **40** (e 40,0 nel preset FORWARD) | 🔴 **COLPITA** — terzo nome ancora |
| `ABTG_ORB_Ottimizzato` · `PTE` · `BreakingBand` · `SupRev_NAS_H1_Ott` · `SuperWave_DOW_H1_Ott` · `MaxMinNotte` · `EMA200_Ottimizzato` · `SupertrendReversal_Ottimizzato` · `SupRev_DAX_H4_Ott` · `EMA200` · `SuperWave` · `SupertrendReversal` · `MaxMinNotte_DAX_Short_Ott` | `InpTP1Pct` | 50 | 🔴 colpite |
| `ABTG_Dow_Apertura_US` | `InpTP1_ClosePct` | **0** nel **default compilato** … | 🟡 **ma 50,0 nel `.set` VIVO del 100k (r.217) e 50 nel banco R16c (r.30)** → 🔴 **colpita lo stesso** |
| `ABTG_ORB_Ottimizzato` **cella `770611`** | `InpTP1Pct` | **0** nel preset REALE e nel CSV R119 | 🟢 **SALVA — `n` 119/71 sono POSIZIONI** |
| `ABTG_PostNews` · `GapFill` · `PunteLarry` · `CostToCost` · `EasyTrend` | — | **nessun parziale nel sorgente** | 🟢 **SALVE** |

## 1.4 La frequenza — 🆕 **DUE colonne, non una**
- **PROMESSA** = op/mese del backtest ÷ **21,7 giorni di borsa**. ⚠️ È in
  **uscite** dove il `n` era in uscite: **anche la frequenza promessa è
  gonfiata** dove c'è il parziale.
- 🆕 **DI CAMPO** = `position_id` distinti in `data/statements/trades_auto.csv`,
  finestra **25/08 → 10/09**, **13 giornate con operazioni** — stesso metodo e
  stessa finestra di `report/FREQUENZA_CAMPO_2026-09-11.md`.
  🔴 **LIMITE DICHIARATO, e vale per tutta la colonna**: quel file è
  **l'export del SOLO conto piccolo 50503392**. Per il **100k 50504263** e per
  il **REALE 10105439** la frequenza di campo è **`[NON MISURATO]`**: non
  esiste nessun export. 👉 **M-C7.**

## 1.5 Il codice — 🆕 la colonna che il v1 non aveva
`report/IL_CAMPO_E_FERMO_A_AGOSTO_2026-09-11.md`: **42 sorgenti su 42 del
piccolo sono diversi dal repo**, compilati fra il **5 e il 18 agosto**.
Confronto fatto riga per riga da `CODA_06_quale_codice_gira_20260911_033002.log`
contro `wc -l` del repo di oggi.
📐 **Taratura dello strumento**: il runner conta **una riga in più** del repo
(verificato su 5 casi noti allineati: DAX reale 2368/2367 · ORB 1464/1463 · Dow
100k 2148/2147 · MaxMin 100k 620/619 · PostNews 667/666). Quindi
**allineato = `campo == repo + 1`**.
🔴 **Limite dichiarato**: MT5 esegue l'`.ex5`, e il `.mq5` accanto potrebbe
essere stato aggiornato senza ricompilare. La **data di compilazione** è la
prova più forte che abbiamo, **non è una prova del contenuto del binario**.

> 📌 **IL PIN DELLA COLONNA, perché i numeri restino verificabili.** Tutti i
> conteggi `wc -l` del **repo** di questa colonna sono presi sullo stato
> **`da6d08b`** (branch `lavoro`, 11/09). 🔴 **Mentre scrivevo, un altro agente
> stava modificando 11 sorgenti** (`ABTG_EMA200` 552→690, `ABTG_PTE` 649→776,
> `ABTG_SuperWave` 637→766, `ABTG_CostToCost` 1093→1207,
> `ABTG_GapContinuation` 1568→1654, e altri): **quelle righe non sono ancora
> committate e NON sono in campo.** Chi rifà il conto contro il repo di domani
> troverà **numeri più grandi e una distanza dal campo ancora maggiore** — il
> verso non cambia, la cifra sì. **Si riconta contro il pin, non contro
> "adesso".**

## 1.6 Il pedaggio — 🆕 stop/spread **ALL-IN**
Pavimenti (`R125` §2 · `CLAUDE.md`): **DI LAVORO `stop ≥ 40 × spread`** ·
**DURO `stop ≥ 13,3 × spread`**.
🔴 **Con la COMMISSIONE dentro**, misurata **4,0000 EUR/lotto esatti** sul forex
base EUR (**varianza zero su 84 posizioni**), legge `0,004% del nozionale in
valuta base`. **Sugli indici la commissione è 0,0000 su 302 posizioni.**

## 1.7 🆕 La colonna che oggi serve e non c'era
> ## ❓ **«Questo numero descrive la sedia che GIRA?»** → **SÌ / NO / NON MISURATO**
> **SÌ** solo se valgono **tutte e tre**: (a) il codice in campo è quello con
> cui il numero è stato misurato, (b) il **rischio** in campo è quello del
> banco, (c) il **deposito** del banco non è tanto diverso da far mordere il
> pavimento del lotto. Se una sola non è verificata → **NON MISURATO**. Se una è
> verificata **falsa** → **NO**.

## 1.8 MERITO
Regola di casa (valvola R59 + Emendamento B): **sotto 150 operazioni il giudizio
sul MERITO si sospende, quello sul RISCHIO no** — un DD accaduto vale a
qualunque `n`. 🔴 **E adesso la soglia si legge in POSIZIONI, dentro la finestra
OOS, non sulla somma** (classi 224+226 insieme).

---

# 2. 💶 CONTO REALE — 10105439 (`C:\BCM_Reale`) — 2 SEDIE

| EA · Magic · Sym | **DD PROMESSO** | a quale **deposito/rischio/modello** | `n` **uscite → POSIZIONI** | finestra · **OOS vero?** | **freq. PROMESSA** | **freq. DI CAMPO** | **codice misurato → in campo** | **stop/spread ALL-IN** | ❓ **descrive la sedia che gira?** |
|---|---|---|---|---|---|---|---|---|---|
| `ABTG_DAX_Apertura_EU` **770101** D30EUR M5 · vivo **0,65%** | **10,5984%** @1% → ≈6,89% @0,65% 🔴[APPROSSIMATO] | **10.000 €** · **1,0%** · **tick** | 🆕 **311 → 245 [MISURATO]** (era «311») · fattore **1,27** | OOS 2025.06.12→2026.06.30, 12,6 mesi · ✅ **OOS vero** | ~0,97 op/g *(in uscite; in posizioni ~**0,76**)* | 🔴 `[NON MISURATO]` sul reale | misurato: repo R83 (19/08) · campo: **v1.01, 2368 righe, 06/09** = **repo+1** → ✅ **ALLINEATO** | **42,3x** 🟢 *(geometria piena)* · **33,0x** 🔴 *(sottocampione della geometria VIVA)* · **26,6x** 🔴 @P95 | 🟠 **NON MISURATO** — codice ✅ e cella ✅, ma il **rischio** vivo è 0,65% e il banco 1,0%, e l'**equità vera è ~7.500 €** contro 10.000 del banco: il pavimento del lotto **a quella taglia non è stato verificato** |
| `ABTG_ORB_Ottimizzato` **770611** U30USD M5 · vivo **0,65%** | **6,5389%** OOS · **5,6530%** IS — **già alla taglia viva** | **10.000 €** · **0,65%** · **tick** | **119 OOS · 71 IS = POSIZIONI** 🟢 (`InpTP1Pct=0` verificato nel CSV R119 **e** nel preset reale) | IS 2024.09.26→2025.06.09 / OOS 2025.06.10→2026.06.30 · ✅ **OOS vero** | ~0,43 op/g | 🔴 `[NON MISURATO]` sul reale *(sul **piccolo** la gemella fa **0,23**)* | misurato: repo R119 (07/09) · campo: **v1.04, 1464 righe, 06/09** = repo+1 → ✅ **ALLINEATO** | 🔴 **29,5x** (74% del pavimento di lavoro) · **19,7x** @P95 · 🟢 sopra il duro 13,3x | 🟢 **SÌ** — codice ✅, rischio ✅ (0,65% = 0,65%), cella ✅. ⚠️ **unico caveat**: banco a 10.000 €, equità vera ~7.500 € |

> 🔴 **La nota di rischio che va detta ogni volta che si cita l'ORB sul reale**:
> il contratto **storico** è **9,92% a rischio 1%** (R15) col **doppio
> asterisco** — passava il muro del 10% per 8 centesimi — e R118 misura che la
> configurazione VIVA **sfonda il muro sotto slippage** (9,76 → **10,34%** a
> 1%). **Il 6,54% viene dalla TAGLIA, non dal motore.** Alzarla a 1% la porta
> al muro o oltre. *(Chiusura della contraddizione C3: `report/CONTRADDIZIONI_CHIUSE_2026-09-09.md` §C3 — invariata, riportata qui per intero in §8.)*

---

# 3. 🛡️ CONTO 100K DEMO — 50504263 (istanza `-V3`) — 5 SEDIE

_Il 100k è ancora il quintetto del 09/08: nessun magic `88xxxx` del
`PIANO_MIGRAZIONE_100K_2026-08-31.md` compare in nessuna pagella né censimento._

| EA · Magic · Sym | **DD PROMESSO** | deposito/rischio/modello | `n` **uscite → POSIZIONI** | finestra · **OOS vero?** | **freq. PROMESSA** | **freq. DI CAMPO** | **codice misurato → in campo** | **stop/spr ALL-IN** | ❓ **descrive la sedia che gira?** |
|---|---|---|---|---|---|---|---|---|---|
| `DAX_Apertura_EU` **770101** D30EUR M5 · **0,65%** | **10,5984%** @1% → ≈6,89% | 10.000 € · 1,0% · tick | 🆕 **311 → 245 [MIS]** | OOS 12,6 mesi · ✅ | ~0,97 (uscite) / ~0,76 (pos.) | 🔴 `[NON MISURATO]` | campo **2361** righe, **19/08** contro repo+1 = 2368 → 🔴 **−7, DIVERSO** | 42,3x / 33,0x / 26,6x@P95 | 🔴 **NO** — il binario in campo **non è** quello misurato |
| `Dow_Apertura_US` **770202** U30USD M5 · **0,65%** | **4,22%** @1% → ≈2,74% | **100.000 €** · **1,0%** · **tick** | 🔴 **130 → `[NON MISURATO]`** — il banco R16c ha **`InpTP1_ClosePct=50`** (r.30) e **il per-trade di R16 non è in archivio**. Forbice: **56-130** | OOS 2025.06.10→2026.06.30 · ✅ | ~0,46 op/g (uscite) | **0,08 op/g** *(1 posizione in 13 giornate, `p = 0,018`)* 🔴 **17% del promesso** | campo **2148**, **19/08** = repo+1 → ✅ **ALLINEATO**; e **8 dei 9 campi non-default del `.chr` vivo coincidono con R16c** (`PIANO_PROP` v21) | **51,0x** 🟢 (+28%) | 🟠 **NON MISURATO** — codice ✅ e cella ✅ (8/9), **ma il nono campo è la taglia**: banco 1,0%, campo 0,65% |
| `ORB_Ottimizzato` **770611** U30USD M5 · **0,30%** | **9,92%** @1% (R15, ⚠️ doppio asterisco) / **9,72%** a 100k (R16) → ≈2,98% @0,30% | R15: 10.000 € · 1,0% · tick — R16: 100.000 € · 1,0% · tick | **119 = POSIZIONI** 🟢 | OOS 12,6 mesi · ✅ | ~0,43 op/g | 🔴 `[NON MISURATO]` | campo **823** righe **v1.02, 22/08** contro repo+1 = 1464 → 🔴 **−641, DIVERSO** *(e nemmeno la stessa versione dell'EA del reale)* | 🔴 29,5x | 🔴 **NO** — **binario diverso di 641 righe** dal reale e dal repo |
| `MaxMinNotte_DAX_Short_Ott` **770411** D30EUR M15 · **0,65%** | **1,27%** @1% → ≈0,83% | **100.000 €** · **1,0%** · **tick** | 🔴 **21 → `[NON MISURATO]`** (`InpTP1Pct=50`; per-trade R16 assente). Forbice **9-21**. 📐 su R81, stesso EA, il fattore misurato va da **1,00 a 1,57** | OOS 12,6 mesi · ✅ | ~0,078 op/g | **0,15 op/g** sul **piccolo** (197% del promesso) 🟢 | campo **620**, **19/08** = repo+1 → ✅ **ALLINEATO** | `[NON MISURATO]` — nessuna gamba in stop | 🟠 **NON MISURATO** — codice ✅, taglia 1,0% vs 0,65% |
| `SupertrendReversal` (Nikkei) **770901** 225JPY H2 · **0,65%** | **0,88%** (R5) / **0,65%** (R16) @1% → ≈0,57% | 100.000 € · 1,0% · tick | 🔴 **50 → `[NON MISURATO]`** (`InpTP1Pct=50`). Forbice **22-50** | OOS 12,6 mesi · ✅ | ~0,18 op/g | 🔴 `[NON MISURATO]` sul 100k · ⚠️ **vedi la nota sul magic** | campo **657**, **19/08** contro repo+1 = 666 → 🔴 **−9, DIVERSO** | **13,6x** 🔴 — **lo stop più stretto della flotta**, **0,3 decimi** sopra il pavimento DURO | 🔴 **NO** |

> ## ⚠️ 🆕 **COLLISIONE DI MAGIC `770901` — trovata oggi, va risolta prima della challenge**
> Il magic `770901` è il Nikkei sul 100k **in questo censimento**, ma
> `trades_auto.csv` (= conto **piccolo**) contiene **3 posizioni `770901` su
> XAUUSD** (30/07 → 05/08), e il cancello del costo lo cita come *"gemello
> `770901` XAUUSD"*. 👉 **Lo stesso numero identifica due sedie diverse su due
> conti diversi.** Finché non è disambiguato, **ogni riga di P/L attribuita a
> `770901` va letta insieme al conto e al simbolo**, mai dal solo magic.
> 🔴 Per la corsia RISCHIO questo è grave: un DD attribuito alla sedia sbagliata
> fa scattare la revisione sulla gemella innocente (è **la classe 231**,
> *"il ritrovamento spostato di sedia"*, in un'altra forma). **M-C8.**

---

# 4. 🧪 CONTO PICCOLO DEMO — 50503392 (`BCM Markets MT5 Terminal`, senza `-V3`)

**È il conto-strumento di misura**: decisione di Claudio del 06/09 — **NIENTE
Guardian sul piccolo**, perché il DD della flotta si deve vedere **NON FRENATO**.

> 🔴 **AVVISO CHE VALE PER TUTTO IL §4, E VA LETTO PRIMA DI OGNI RIGA.**
> **Tutti e 42 i sorgenti del piccolo sono diversi dal repo**, compilati fra il
> **5 e il 18 agosto**. Dove sotto non è scritto diversamente, la risposta alla
> colonna *«descrive la sedia che gira?»* è **NO per il codice**, e le altre
> colonne sono vere **del banco**, non del campo.
> 🚨 **E il `Guardian` del piccolo ha 414 righe contro 899 del repo** — ma sul
> piccolo il Guardian **non c'è per decisione**, quindi qui non protegge niente
> per disegno. Sul **100k** ne ha **468** e sul **REALE 513**: 🔴 **le
> protezioni firmate NON sono verificate attive su nessuno dei tre.**

## 4a. 🏛️ Le storiche R16 e il vivaio R23

| EA · Magic · Sym | **DD PROMESSO** | deposito/rischio/modello | `n` **uscite → POSIZIONI** | finestra · **OOS vero?** | **freq. PROM.** | **freq. CAMPO** | **codice** | **stop/spr ALL-IN** | ❓ **gira?** |
|---|---|---|---|---|---|---|---|---|---|
| `DAX_Apertura_EU` **770101** D30EUR M5 · **1,0%** | **10,5984%** | 10.000 € · 1,0% · tick | 🆕 **311 → 245 [MIS]** | OOS 12,6 m · ✅ | 0,97 / **0,76** pos. | **0,54** (56%, `p=0,066`) 🟠 | **2133** vs repo+1 2368 → 🔴 **−235** | 42,3x / 33,0x / 26,6x@P95 | 🔴 **NO** (codice) |
| `Dow_Apertura_US` **770202** U30USD M5 · **1,0%** | **4,22%** | 100.000 € · 1,0% · tick | 🔴 **130 → `[NON MIS.]`**, forbice **56-130** | OOS · ✅ | ~0,46 | **0,08** (17%, `p=0,018`) 🔴 | **2065** vs 2148 → 🔴 **−83** | 51,0x 🟢 | 🔴 **NO** (codice) |
| `ORB_Ottimizzato` **770611** U30USD M5 · **1,0%** | **9,92%** ⚠️ doppio asterisco | 10.000 € · 1,0% · tick | **119 = POSIZIONI** 🟢 | OOS · ✅ | ~0,43 | **0,23** (54%, `p=0,192`) 🟠 | **1464 v1.04, 03/09** = repo+1 → ✅ **ALLINEATO** | 🔴 29,5x | 🟠 **NON MISURATO** — codice ✅, ma il banco è a 0,65% e qui gira a **1,0%** |
| `MaxMinNotte_DAX_Short_Ott` **770411** D30EUR M15 · **1,0%** | **1,27%** | 100.000 € · 1,0% · tick | 🔴 **21 → `[NON MIS.]`**, forbice **9-21** | OOS · ✅ | ~0,078 | **0,15** (197%) 🟢 | **605** vs 620 → 🔴 −15 | `[NON MIS.]` | 🔴 **NO** (codice) |
| `SupertrendReversal` (Nikkei H4 FW) **770924** 225JPY H2 · **1,0%** | **0,14%** | 🔴 **deposito NON DICHIARATO** · 1,0% · tick 30/07 · 2024.01→2026.06 **nominale** | 🔴 **21 → `[NON MIS.]`**, forbice **9-21** | 🔴 **finestra piena, NESSUN OOS** (classe 224) | ~0,046 | **0,15** 🟢 | **605** vs 666 → 🔴 −61 | **13,6x** 🔴 (il peggiore misurabile), 🟡 duro per un soffio | 🔴 **NO** — 🆕 **ma la presenza in campo NON è più contesa**: ha **2 posizioni vere** il **27-28/08** (`trades_auto.csv`), quindi era attaccata. **Il v1 la dava «presenza contesa»: chiuso.** |
| `MaxMinNotte` (oro notte) **770402** XAUUSD H2 · **0,5%** | **19,72%** @1% → **10,0%** @0,5% (firma 23/08) ⚠️ il solo TORO 2021 fa 9,4% @1% | 🔴 deposito NON DICHIARATO · 1,0% · **OHLC** (limite inferiore) · **2004.06.11→2026.06.30, 22 anni** | 🔴 **693 → `[NON MIS.]`** (`InpTP1Pct=50`), forbice **300-693** | 🔴 **22 anni in un pezzo, NESSUN OOS** (classe 224) | ~0,17 | **0,46** (270%) 🟢 | **540** vs 919 → 🔴 **−379** | **126,5x** 🟢 | 🔴 **NO** (codice) |
| `PTE` **771321** U30USD H1 · **1,0%** | **2,18%** | **100.000 €** · **1,0%** · **tick** | 🆕 **40 → 23 [MISURATO]** (fattore 1,74) | OOS ~12,5 m · ✅ | ~0,15 (uscite) / **~0,09** pos. | **0,08** 🟠 | **526** vs 650 → 🔴 **−124** | 🔴 **32,5x** [INF] | 🔴 **NO** (codice) |
| `PTE` (storica, duello) **771322** GBPUSD H1 · **0,5%** | 🔴 **CONTESO: 2,64% (R23) vs 13,1% (R103) vs 17,68% (R78)** @1% | R23: 100.000 € · 1,0% · **tick** — R78/R103: **OHLC**, 13 / 6,5 anni | 🆕 **49 → 27 [MISURATO]** (fattore 1,81) per la cella R23 | R23 OOS ✅ · R78/R103 **finestra piena** 🔴 | ~0,18 (uscite) / **~0,10** pos. | **0** (nessuna op. nella finestra; l'ultima è del **14/08**) 🔴 | **526** vs 650 → 🔴 −124 | `[NON MIS.]` (spread GBPUSD) | 🔴 **NO** — e il contratto **resta CONTESO**: la corsia RISCHIO può scattare a 2,6% o a 17,7% ⇒ **non scatta in modo prevedibile**. **M-C4** |
| `PTE` (candidata B25) **771332** GBPUSD H1 · **0,5%** | **9,87%** @1% → ≈4,94% | 🔴 deposito NON DICHIARATO · 1,0% · **OHLC** · 13 anni | 🔴 **477 → `[NON MIS.]`**, forbice **206-477** | 🔴 **finestra piena** | ~0,14 | **0** — 🔴 **ZERO operazioni in TUTTO il file** (30/03→10/09) | **526** vs 650 → 🔴 −124 | `[NON MIS.]` | 🔴 **NO** — 🆕 **e prima del codice c'è una domanda peggiore: questa sedia è attaccata?** **M-C9** |
| `SuperWave` (H2) **770531** U30USD H2 · **1,0%** | **2,96%** | 100.000 € · 1,0% · tick | 🆕 **88 → 50 [MISURATO]** (fattore 1,76) — *coincide col numero scritto a mano in R23* | OOS ~12,5 m · ✅ | ~0,18 (già in posizioni) | **0,62** (344%) 🟢 | **564** vs 638 → 🔴 **−74** | **147,8x** 🟢 (+269%) | 🔴 **NO** (codice) |

## 4b. 📈 EMA200 e i vecchi «Ottimizzati» del 26/07

| EA · Magic · Sym | **DD PROMESSO** | deposito/rischio/modello | `n` **uscite → POSIZIONI** | finestra · **OOS vero?** | **freq. PROM.** | **freq. CAMPO** | **codice** | **stop/spr ALL-IN** | ❓ **gira?** |
|---|---|---|---|---|---|---|---|---|---|
| 🔴 `EMA200` **771531** U30USD H1 · **1,0%** | 🆕 **7,8323%** @1% *(era **7,21%**)* · ≈5,09% @0,65% 🔴[APPROSSIMATO, sbaglia del 6%] | 🆕 **100.000 €** · **1,0%** · **tick** *(era «deposito NON DICHIARATO → 10.000»)* | 🆕 **OOS 517 → 257 [MISURATO]** · **IS 237 → `[NON MISURATO]`**, forbice **103-237**, stima col fattore della stessa cella **~118** 🔴 **sotto 150** | IS 2024.09.26→2025.06.09 / OOS 2025.06.10→2026.06.30 · ✅ **OOS vero, a tick** — 🥇 **l'unica partizione IS/OOS vera, a tick, con l'OOS sopra soglia in POSIZIONI di tutto il progetto** | ~1,55 op/g (uscite) → 🆕 **~0,77 op/g in POSIZIONI** | **0,85** — 🔴 **55% del promesso in uscite** (`p=0,020`); **110%** del promesso ricontato in posizioni | **487 v1.00, 06/08** vs repo+1 **553** → 🔴 **−66**, e **manca il commit `3af47ed` dell'08/08** *(«fix sizing su 41 EA: `OrderCalcProfit` al posto del tick value nudo»)* | **54,9x** 🟢 (+37%) | 🔴 **NO, e su due assi**: (1) **il codice che DIMENSIONA IL LOTTO in campo non è quello con cui è stato misurato il 7,8323%**; (2) il banco è a **100.000 €** e la sedia gira su **~5.000 €** — **a quella taglia non esiste nessuna misura** (**M40**) |
| `EMA200_Ottimizzato` **971501** XAUUSD H4 · **0,25%** | **45,91%** @1% → **11,5%** @0,25% (firma 23/08) | 🔴 dep. NON DICHIARATO · 1,0% · **OHLC** · 22 anni | 🔴 **610 → `[NON MIS.]`**, forbice **264-610** | 🔴 **finestra piena** | ~0,30 | **0,38** (127%) 🟢 | **487** vs 607 → 🔴 **−120** | **162,4x** 🟢 | 🔴 **NO** — 🔴 **prop: NO a nessuna taglia** (firma 23/08). ⚠️ È la sedia della **classe 228**: pavimento del lotto che alza **1,62% contro 1,00%** |
| `SupertrendReversal_Ott` **970901** XAUUSD H4 · **1,0%** | **9,02%** | 🔴 dep. NON DICHIARATO · 1,0% · **OHLC** · 22 anni | 🔴 **657 → `[NON MIS.]`**, forbice **284-657** | 🔴 **finestra piena** | ~0,115 | **0,08** (70%) 🟠 | **577** vs 615 → 🔴 −38 | ~135,7x 🟢 [INF] | 🔴 **NO** ⚠️ margine sul muro 10% = **0,98 punti**; a rischio 2% i numeri raddoppiano |
| `SupRev_DAX_H4_Ott` **970912** D30EUR H4 · **1,0%** | **5,7385%** | 🔴 dep. NON DICHIARATO · **1,0%** (letto nel CSV) · **tick 26/07** · 2024.01→2026.06 nominale | 🔴 **86 → `[NON MIS.]`** (`InpTP1Pct=50` **e** `InpUsePending=1`, letti nel CSV), forbice **37-86** | 🆕 🔴 **FINESTRA PIENA**: la cella viene da `valid_SupRevRT_D30EUR_H4.csv`, **una griglia di 8 passate su UNA finestra, nessuno split** (classe 224) | ~0,18 | **0** — 🔴 **nessuna operazione nella finestra** | **578** vs 616 → 🔴 −38 | ~100x 🟢 [INF] | 🔴 **NO** — e la revalidation pulita dà **PFmed reale 1,05, marginale**. **DA RIPRODURRE** |
| ⭐ `SupRev_NAS_H1_Ott` **970913** NASUSD H1 · **1,0%** | **1,1706%** | 🔴 dep. NON DICHIARATO · **1,0%** (letto nel CSV) · **tick 26/07** · 2024.01→2026.06 nominale | 🔴 **155 → `[NON MIS.]`** (`InpTP1Pct=50` **e** `InpUsePending=1`), forbice **67-155** | 🆕 🔴 **RISOLTO OGGI, E IN PEGGIO: la cella è `valid_SupRevRT_NASUSD_H1.csv` Pass 6 — una GRIGLIA DI 8 PASSATE SU UNA SOLA FINESTRA, senza nessuno split** (PF 1,57491 · DD 1,1706 · Trades 155 · StMult 3,0 / AtrP 10 / TP_RR 3,0, tutti combacianti con `REGISTRO_TEST` §S5v). **Classe 224 confermata per misura, non per sospetto** | ~0,34 | **0,15** (45%, `p=0,183`) 🟠 | **578** vs 653 → 🔴 **−75** | 🔴 **28,7x** (72% del pavimento) | 🔴 **NO** — 🔴 **e l'etichetta «MERITO PIENO ⭐ il prop-friendly» CADE**: nessun fuori campione **e** `n` in uscite. **Il merito è SOSPESO** |
| `SuperWave_DOW_H1_Ott` **770511** U30USD H1 · **1,0%** | **4,0151%** | 🔴 dep. NON DICHIARATO · **1,0%** (letto nel CSV) · **tick** · 2024.01→2026.06 nominale | 🔴 **227 → `[NON MIS.]`** (`InpTP1Pct=50` **e** `InpUsePending=1`), forbice **98-227** | 🆕 🔴 **FINESTRA PIENA** — `valid_SuperWaveRT_U30USD_H1_realtick.csv` Pass 6 (PF 1,52140 · DD 4,0151 · 227), **9 passate, una finestra, nessuno split**. Spezzata IS/OOS fa **84 e 143**, **tutte e due sotto 150** | ~0,50 | **0,62** (124%) 🟢 | **564** vs 646 → 🔴 **−82** | 🔴 **38,5x** (96%) — e il **minimo** delle gambe misurate è **12,7 idx = 6,3x**, **sotto il pavimento DURO** | 🔴 **NO** — **merito SOSPESO** |

## 4c. 🧬 Le famiglie di agosto (walk-forward IS 40 / OOS 60, storico dal 2024.09.26)

_Salvo dove indicato: **deposito 10.000 €** (default di `walkforward_generico.ps1`
r.101) · **rischio 1,0%** · OOS ~13 mesi · ✅ **OOS vero**._
🟢 **`GapFill`, `PunteLarry`, `CostToCost`, `EasyTrend` non hanno parziale nel
sorgente: i loro `n` SONO posizioni.** 🔴 `BreakingBand` sì (`InpTP1Pct=50.0`).

| EA · Magic · Sym | **DD PROMESSO** | deposito/rischio/modello | `n` **uscite → POSIZIONI** | **OOS vero?** | **freq. PROM.** | **freq. CAMPO** | **codice** | **stop/spr ALL-IN** | ❓ **gira?** |
|---|---|---|---|---|---|---|---|---|---|
| `BreakingBand` **772161** GBPUSD H1 | **3,4%** (WF) / 1,9% (100k R34) | 10.000 / 100.000 € · 1,0% | 🔴 **26 → `[NON MIS.]`**, forbice **11-26** | ✅ | ~0,092 | **0,08** (84%) 🟢 | **1578** vs 1858 → 🔴 **−280** | `[NON MIS.]` | 🔴 NO |
| `BreakingBand` **772162** EURUSD H1 | **1,2%** | 10.000 € · 1,0% | 🔴 **13 → `[NON MIS.]`** ⚠️ IS con **4** | ✅ | ~0,046 | **0,08** (167%) 🟢 | 🔴 −280 | 🆕 🔴 **RIBALTA: 55,2x → 25,6x** con la commissione (64% del pavimento) | 🔴 NO |
| `BreakingBand` **772163** AUDUSD H1 | **1,2%** | 10.000 € · 1,0% | 🔴 **11 → `[NON MIS.]`** | ✅ | ~0,037 | **0,08** (208%) 🟢 | 🔴 −280 | `[NON MIS.]` | 🔴 NO |
| `GapFill` **772231** GBPUSD | **2,4%** / 1,0% | 10.000 / 100.000 € · 1,0% | **8 = POSIZIONI** 🟢 | ✅ | ~0,028 | **0** | **791** vs 806 → 🔴 −15 | `[NON MIS.]` | 🔴 NO |
| `GapFill` **772232** EURUSD | **1,5%** / 1,0% | idem | **9 = POSIZIONI** 🟢 | ✅ | ~0,032 | **0** | 🔴 −15 | `[NON MIS.]` | 🔴 NO |
| `GapFill` **772233** AUDUSD | **1,9%** / 1,0% | idem | **12 = POSIZIONI** 🟢 | ✅ | ~0,041 | **0** | 🔴 −15 | `[NON MIS.]` | 🔴 NO |
| `GapFill` **772234** U30USD | **2,3%** | 10.000 € · 1,0% | **20 = POSIZIONI** 🟢 | ✅ | ~0,069 | **0,08** (111%) 🟢 | 🔴 −15 | 🔴 **35,0x** (88%) | 🔴 NO — esclusa dal portafoglio R37 (cumulo del lunedì) |
| `GapFill` **772235** 225JPY | **4,3%** | 10.000 € · 1,0% | **15 = POSIZIONI** 🟢 | ✅ | ~0,055 | **0,08** (140%) 🟢 | 🔴 −15 | `[NON MIS.]` (spread 225JPY) | 🔴 NO — il più tirato (PF 1,14) |
| `PunteLarry` **772341** U30USD H1 | **3,9%** | 10.000 € · 1,0% | **38 = POSIZIONI** 🟢 | ✅ | ~0,134 | **0,31** (230%) 🟢 | **1200** vs 1215 → 🔴 −15 | **105,4x** 🟢 (43,5x al minimo) | 🔴 NO |
| `PunteLarry` **772342** EURAUD H1 · **0,5%** | **17,1%** @1% → 8,6% | **100.000 €** · normalizzato a 1,0% · **OHLC** · 6,5 anni | **216 = POSIZIONI** 🟢 | 🔴 **finestra piena** | ~0,115 | **0,23** (200%) 🟢 | 🔴 −15 | **≤54,6x** 🟡 [CONDIZIONATO: spread illeggibile] | 🔴 NO — 3/7 anni negativi |
| `PunteLarry` **772343** XAUUSD H1 · **0,3%** | **29,74%** @1% → 9,0% | 🔴 dep. NON DICHIARATO · 1,0% · **OHLC** · 22 anni | **~10/anno (R100); 60 in R103 = POSIZIONI** 🟢 | 🔴 **finestra piena** | ~0,037 | **0,08** (208%) 🟢 | 🔴 −15 | **236,2x** 🟢 | 🔴 NO — 🔴 tagliando 6 mesi: se il merito non arriva, spegnere |
| `PunteLarry` **772344** GBPJPY H1 | **2,7%** | 10.000 € · 1,0% | **20 = POSIZIONI** 🟢 | ✅ | ~0,069 | **0,08** (111%) 🟢 | 🔴 −15 | **≤68,8x** 🟡 [CONDIZIONATO] | 🔴 NO |
| `PunteLarry` **772345** GBPUSD H1 | **5,1%** | 10.000 € · 1,0% | **25 = POSIZIONI** 🟢 | ✅ | ~0,088 | **0,08** (87%) 🟢 | 🔴 −15 | `[NON MIS.]` | 🔴 NO |
| `PunteLarry` **772346** EURCAD H1 | **4,8%** | 10.000 € · 1,0% | **19 = POSIZIONI** 🟢 | ✅ | ~0,069 | **0** | 🔴 −15 | `[NON MIS.]` | 🔴 NO |
| `CostToCost` **772361** EURJPY H4 · **0,65%** | **12,3%** @1% → 8,0% | **100.000 €** · normalizzato a 1,0% · **OHLC** · 6,5 anni | **394 = POSIZIONI** 🟢 | 🔴 **finestra piena** | ~0,217 | **0,15** (69%) 🟠 | **1079** vs 1094 → 🔴 −15 | 🆕 🔴 **RIBALTA: 73,0x → 25,6x** | 🔴 NO |
| `CostToCost` **772362** GBPCAD H4 · **0,25%** | 🔴 **41,5%** @1% → 10,4% | 100.000 € · normalizzato · **OHLC** · 6,5 anni | **382 = POSIZIONI** 🟢 | 🔴 **finestra piena** | ~0,212 | **0,15** (73%) 🟠 | 🔴 −15 | 🔴 **32,4x → 20,0x ALL-IN** (50%) — **peggiora** | 🔴 NO — 🔴 **il DD promesso più alto della flotta, e PF 0,92 su 6,5 anni** |
| `EasyTrend` **772422** GBPUSD H1 · **0,5%** | **15,8%** @1% → 7,9% | 100.000 € · normalizzato · **OHLC** · 6,5 anni | **254 = POSIZIONI** 🟢 | 🔴 **finestra piena** | ~0,134 | **0,15** (115%) 🟢 | **1606** vs 1621 → 🔴 −15 | 🟡 **175,0x → 47,3x ALL-IN**: regge, **margine da +338% a +18%** | 🔴 NO — famiglia **BOCCIATA in portafoglio** (R49) |
| `EasyTrend` **772421** CHFJPY H1 · **0,3%** | **21,8%** @1% → 6,5% | 100.000 € · normalizzato · **OHLC** · 6,5 anni | **265 = POSIZIONI** 🟢 | 🔴 **finestra piena** | ~0,175 | **0,08** (44%) 🟠 | 🔴 −15 | **≤58,4x** 🟡 [CONDIZIONATO] | 🔴 NO — PF 1,07, **4/7 anni negativi** |
| `GapContinuation` **774101** 225JPY M1 · ⚠️ rischio **n/d nel `.chr`** | **11,59%** | **100.000 €** · **1,0%** · **tick** | 🆕 🔴 **70 → `[NON MIS.]`** — **`InpPartialClosePercent = 40`** (r.159, e 40,0 nel preset FORWARD): **la v1 scriveva «70 chiusure (~47 giornate)» e il ~47 non è un conteggio di posizioni**. Forbice **30-70** | OOS 2025.06.10→2026.06.30 · ✅ | ~0,17 | **0,08** (47%) 🟠 | **1552 v1.50** vs 1569 → 🔴 −17 | **13,7x** 🔴 — **secondo peggiore**, 🟡 duro per un soffio | 🔴 **NO** ⚠️ **tre avvertenze nel contratto**: lo short perde (−2.182), le perdite arrivano in GRUPPO (Z −4,03, **6 di fila**), la cella è un **PICCO non un altopiano**. E **il rischio vivo non è leggibile dal `.chr`** |

## 4d. 🌩️ Le sedie nate DOPO l'ultima foto `.chr` del 25/08

| EA · Magic · Sym | **DD PROMESSO** | deposito/rischio/modello | `n` **uscite → POSIZIONI** | **OOS vero?** | **freq. PROM.** | **freq. CAMPO** | **codice** | **stop/spr ALL-IN** | ❓ **gira?** |
|---|---|---|---|---|---|---|---|---|---|
| `Nasdaq_Apertura_US` (**GATED SHORT**) **770250** NASUSD M15 · **0,35%** | **4,54%** @0,65% → ~2,4% @0,35% · pegg. giornata −0,72% → ~−0,4% | 🔴 dep. NON DICHIARATO · **0,65%** · **tick BCM** · 21 mesi (**solo TORO**) | 🆕 🔴 **104 → `[NON MIS.]`** — il preset LIVE ha **`InpTP1_ClosePct=50.0`** (r.49): **il 104 conta uscite**. Forbice **45-104** | 🆕 🔴 **NO**: il referto dice testualmente *"finestra intera 2024-2026 (toro)... una tranche"*. **Nessuno split** (classe 224) | ~0,23 | 🔴 **0 — ZERO operazioni in tutto il file** (dal deploy del 30/08) | **2033** vs repo+1 **2567** → 🔴 **−534** | **~37,2x** 🟡 (93%) [INF] | 🔴 **NO** — 🔴 riserva già nel contratto: **il verdetto ORSO è OHLC, non tick**. ⚠️ **e su quale terminale giri non è deducibile dai documenti** (§6) |
| `PostNews` (ECB) **771201** EURJPY M5 · **1,30%/evento** (Claudio, 11/09 mattina) | 🔴 **NESSUNO** | — | — | — | — | **0,08** (1 posizione) | **667 v1.10, 04/09** = repo+1 → ✅ **ALLINEATO** | 🆕 🚨 **62,5x → 21,9x ALL-IN**, e **dopo il trailing a 15 pip: 13,2x contro il pavimento DURO di 13,3x** — **la PRIMA sedia della flotta che sfonda il pavimento duro** | 🔴 **NON MISURATO** — nessun round ha mai prodotto un DD per questa cella. 🔵 **Ma opera**, e ha un contratto parziale nuovo: `report/CONTRATTO_POSTNEWS_ECB_771201_2026-09-10.md` |
| `PostNews` (FOMC) **771202** EURUSD M5 · **1,30%/evento** | 🔴 **NESSUNO** | — | — | — | — | **0** nella finestra (1 posizione il 30/07) | ✅ ALLINEATO | **62,5x → 28,9x ALL-IN** · **17,4x** dopo il trail | 🔴 **NON MISURATO** |
| `PostNews` (NFP) **771203** USDJPY M5 · **1,30%/evento** | 🔴 **NESSUNO** | — | — | — | — | **0,08** (1 posizione) | ✅ ALLINEATO | **83,3x → 26,8x ALL-IN** · **16,1x** dopo il trail | 🔴 **NON MISURATO** — il **PASSO 0** non ha mai prodotto un CSV. Il track record 2009-2017 della slide è **[DICHIARATO]**, pips grezzi senza costi: **non è una fonte** |
| `BREAKOUT_EA_JPY_v3` · magic **n/d** · USDJPY | 🔴 **NESSUNO** | — | — | — | — | **0** (nessun magic identificabile) | 🔴 **sorgente `.mq5` NON nel terminale** — l'unico `.ex5` orfano è `NasdaqOpeningBreakout_EA_v21_OPTIMIZED (1).ex5`, **12/08** | `[NON MIS.]` | 🔴 **NON MISURATO** — famiglia **SCARTATA pre-progetto**: 7 cross JPY 2022-24 = **−20.853 €, PF 0,67-0,95 su TUTTE, DD 30-48%**. **Per la corsia RISCHIO è fuori metro: qualunque DD faccia, non viola niente** |

## 4e. 🪦 FUORI CAMPO — righe che l'inventario si portava dietro per inerzia

| EA · Magic · Sym | perché NON è una sedia | 🆕 **l'ha confermato il campo?** |
|---|---|---|
| `Gold_Ichimoku_TK_ATR_EA` **250604** XAUUSD | 🪦 **SEDIA FANTASMA**: rimossa a giugno, contata viva per un `.chr` residuo. L'EA firma `TK long/short`: **ZERO volte in 1.281 righe di statement** | ✅ ultime 2 posizioni **09-19/06**, nessuna dopo |
| `Nasdaq_Apertura_US` (breakout) **770201** NASUSD | ⛔ **SPENTA dal 18/08 09:41** (FIRMA 5). Non aveva mai avuto contratto | ✅ ultime operazioni **20/07 → 11/08**, nessuna dopo |
| `PTE` **771323** USDJPY | 🔴 SPENTA 24/08 | ✅ ultima posizione aperta **19/08 18:00** |
| `SuperWave` **770532** GBPUSD | 🔴 SPENTA 24/08 | ✅ **ZERO operazioni in tutto il file** |
| `CostToCost` **772363** XAGUSD | 🔴 SPENTA 24/08 | ✅ **coerente**: l'unica posizione dopo il 24/08 è **APERTA il 24/08 alle 16:00** e chiusa il 25/08 alle 03:05. Non è una riapertura |
| `EasyTrend` **772423** AUDJPY | 🔴 SPENTA 24/08 | ✅ ultima apertura **18/08 17:00** |
| `SupRev_DOW_H4_Ott` **970914** U30USD | Contratto scritto (4,0%) ma **promozione REVOCATA** (PFmed reale **0,79**, illusione OHLC) | ✅ nessuna operazione |
| `SupRev_DAX_H1_Ott` — D30EUR | 🔴 spenta l'11/08 con delibera di Claudio | ✅ nessuna operazione |
| `Guardian` 779001/779002 · `TradeExporter` ×2 · `SpreadLogger` · `SlippageLogger` | ⚙️ **utility: non tradano, non hanno contratto** | — |

---

# 5. 📊 COSA È CAMBIATO DAL v1 — ogni riga con la misura sotto

| # | contratto | **v1 (07/09)** | **v2 (11/09)** | verso | perché, e con quale misura |
|---:|---|---|---|:---:|---|
| 1 | `771531` **DD** | **7,21%** | 🆕 **7,8323%** @ **dep. 100.000** · tick · OOS | ⬆️ **ALLARGATO** | 🥇 R31 = R110 = R112, **riprodotto tre volte al centesimo** (primo `G0-B` applicabile della storia della macchina). Il 7,21% di R29 è **la stessa cella a deposito 10.000**, dove `MathFloor` taglia il lotto e la sedia rischia **~0,87%** invece di 1,00%. 🔴 **Allargato, e giustificato dalla misura — non dalla comodità.** Il verso fisico regge: `OHLC 6,48% < tick@10k 7,21% < tick@100k 7,83%` |
| 2 | `771531` **`n`** | **444** | 🆕 **517 uscite = 257 POSIZIONI** (OOS) · **IS 237 uscite = `[NON MISURATO]`** | ↔️ | il 444 è di R29 (10k); la cella a 100k ne fa **517**, e i `position_id` sono **257**. 🔴 **E l'IS NON è verificato in posizioni: ~118 stimate, sotto 150** |
| 3 | `770101` **`n`** | **311** | 🆕 **311 uscite = 245 POSIZIONI [MISURATO]** | ⬇️ | `pertrade_r83d1_777120.csv`: 311 righe, 245 `position_id`, **179 con 1 uscita + 66 con 2**. Il Pass del CSV di contratto (`DD 10.5984 · Trades 311 · entry=1`) combacia col magic del per-trade. 🟢 **Resta sopra 150: merito PIENO** |
| 4 | `770101` **DD** | 10,60% | **10,5984%** (stesso numero, scritto per intero) | ↔️ | nessun cambio |
| 5 | `770202` **`n`** | 130 | 🆕 **130 uscite → `[NON MISURATO]`**, forbice **56-130** | ⬇️ | il banco R16c ha `InpTP1_ClosePct=50`; **il per-trade non è in archivio** |
| 6 | `770411` · `770901` · `770924` · `770402` · `971501` · `970901` · `970912` · `970913` · `770511` · `771332` · `772161-63` · `774101` · `770250` **`n`** | numeri secchi | 🆕 **`[NON MISURATO]` + forbice** | ⬇️ | `InpTP1Pct`/`InpTP1_ClosePct`/`InpPartialClosePercent` ≠ 0 e per-trade assente. 🔴 **Non ho diviso per due nemmeno una volta** |
| 7 | `771321` · `771322` · `770531` **`n`** | 40 · 49 · 88 «chiusure» | 🆕 **23 · 27 · 50 POSIZIONI [MISURATO]** | ⬇️ | contati i `position_id` in `risultati_prove/trades_candidati_r23/`. Fattori **1,74 · 1,81 · 1,76** |
| 8 | `970913` **finestra** | «tick · 2024.01→2026.06 nominale» + ⭐ *«n 155 = MERITO PIENO, il prop-friendly»* | 🆕 🔴 **FINESTRA PIENA, nessuno split** — `valid_SupRevRT_NASUSD_H1.csv` Pass 6 | ⬇️ | **classe 224 confermata per MISURA, non per sospetto**. Il v1 e la classe stessa la lasciavano «DA RIVERIFICARE»: adesso è **verificata, e in peggio**. **MERITO SOSPESO** |
| 9 | `970912` **finestra** | idem | 🆕 🔴 **FINESTRA PIENA** — `valid_SupRevRT_D30EUR_H4.csv` Pass 4 | ⬇️ | stessa griglia, stesso giorno (26/07) |
| 10 | `770511` **finestra** | «n 227 · MERITO PIENO» | 🆕 🔴 **FINESTRA PIENA** — `valid_SuperWaveRT_U30USD_H1_realtick.csv` Pass 6; spezzata fa **84 e 143** | ⬇️ | classe 224 |
| 11 | `770250` **finestra** | «21 mesi (solo TORO)» | 🆕 🔴 **+ nessuno split**: *"finestra intera... una tranche"* | ⬇️ | classe 224 |
| 12 | `770402` · `971501` · `970901` · `771332` · `772342` · `772343` · `772361` · `772362` · `772421` · `772422` **finestra** | «22 anni» / «6,5 anni» | 🆕 🔴 **marcate FINESTRA PIENA (nessun OOS)** | ⬇️ | R99/R100/R103 girano **senza split** (dichiarato in `PIANO_PROP` J2-bis) |
| 13 | `770924` **presenza in campo** | 🟠 «**contesa** — il 02/09 non era in lista Expert» | 🆕 🟢 **ERA ATTACCATA**: 2 posizioni vere il **27-28/08** | ⬆️ **chiuso** | `trades_auto.csv` |
| 14 | **colonna frequenza** | solo «promessa» | 🆕 **promessa + DI CAMPO** (31 magic misurati) | ➕ | senza le due colonne il **tagliando firmato non è applicabile** |
| 15 | **colonna codice** | non esisteva | 🆕 **misurato → in campo**, riga per riga | ➕ | `CODA_06` dell'11/09 |
| 16 | **colonna pedaggio** | non esisteva | 🆕 **stop/spread ALL-IN** | ➕ | e **5 sedie ribaltano il verdetto** con la commissione dentro |
| 17 | **colonna «gira?»** | non esisteva | 🆕 **SÌ / NO / NON MISURATO** | ➕ | richiesta esplicita di questo giro |

## 🔢 IL CONTEGGIO, ed è la riga che va letta

_Conteggio fatto contando **due unità diverse**, e le dichiaro perché non si
confondano: una **CELLA di contratto** è un motore+cella+finestra (27 in tutto
sono state toccate); una **RIGA-SEDIA** è la stessa cella su un conto (`770101` e
`770611` girano su tre conti, `770202` e `770411` su due)._

| | quante |
|---|---:|
| **righe-sedia censite** | **47** (= 41 sedie uniche) |
| ✏️ **CELLE di contratto corrette in questo giro** | **27** (= **31 righe-sedia**) |
| 🔴 di cui `n` che diventa **`[NON MISURATO]` + forbice** | **17** — `770202` · `770411` · `770901` · `770924` · `770402` · `771332` · `971501` · `970901` · `970912` · `970913` · `770511` · `772161` · `772162` · `772163` · `774101` · `770250` · `771531` **(solo l'IS)** |
| 🆕 di cui `n` **ricontato in POSIZIONI, MISURATO** | **5** — `771531` OOS (517→**257**) · `770101` (311→**245**) · `771321` (40→**23**) · `771322` (49→**27**) · `770531` (88→**50**) |
| 🔴 finestre che perdono l'etichetta di **fuori campione** | **15** — `770924` · `770402` · `971501` · `970901` · `970912` · `970913` · `770511` · `770250` · `771332` · `772342` · `772343` · `772361` · `772362` · `772421` · `772422` |
| 🔴 **contratti che descrivono un codice NON in campo** | **39 righe-sedia su 47** *(38 con un binario diverso + `BREAKOUT_EA_JPY_v3`, il cui `.mq5` non è in nessun terminale)* |
| ✅ **«descrive la sedia che gira?» = SÌ** | **1** — `770611` sul **REALE** |
| 🟠 **= NON MISURATO** | **8** — `770101`@reale · `770202`@100k · `770411`@100k · `770611`@piccolo · `771201` · `771202` · `771203` · `BREAKOUT_EA_JPY_v3` |
| 🔴 **= NO** | **38** |
| 🔴 **contratti INESISTENTI** (nessun DD mai misurato) | **4** — `771201` · `771202` · `771203` · `BREAKOUT_EA_JPY_v3` |

> # 🔴 **UNA SOLA RIGA SU 47 HA UN CONTRATTO CHE DESCRIVE LA SEDIA CHE GIRA.**
> Ed è `770611` sul **conto REALE**, cioè quello che paga davvero.
> **Non è un paradosso: è il motivo per cui questo file esisteva già, e il
> motivo per cui il v1 non bastava.**

---

# 6. 🔴 I BUCHI DEL PERIMETRO — dichiarati, non tappati a mente

1. **Non esiste una foto `.chr` più recente del 25/08 con i RISCHI**. `CODA_08`
   dell'11/09 legge i `.chr` vivi, 🔴 **ma accorpa al blocco `<expert>` gli
   input degli INDICATORI appesi al grafico** (113 parametri stampati, 81 sono
   dell'EA — **M41** del `PIANO_PROP`). Chi copia un blocco in un `.set` ci mette
   **32 righe false**.
2. **Cinque sedie ☠️ «morte in osservazione»** (`DAX_Live5m`, `DAX_Live5m_v2`,
   `Nasdaq_Live5m`, `ORB` nativo, `ORB_Fibo`) sono date per **accese** in
   `AUDIT_POSITIONSELECT_HEDGING_2026-09-03.md` ma **non** nel censimento `.chr`.
   🆕 **Il campo le smentisce tutte e cinque**: nessun magic riconducibile a loro
   in `trades_auto.csv`. **Se sono accese, sono 5 righe SENZA CONTRATTO e MUTE.**
3. **`Nasdaq_Apertura_US_Ottimizzato`** è elencato come sedia viva nell'audit del
   03/09 **senza magic**. Non ho inventato un magic: la riga non esiste qui.
4. **Su quale conto gira la `770250`**: il contratto dice «conto PICCOLO ~5k
   SEPARATO dal 50503392». 🆕 **E il campo aggiunge un fatto**: in
   `trades_auto.csv` (= piccolo) **non ha MAI operato**. O è su un altro
   terminale, o è attaccata e muta.
5. 🆕 **La frequenza di campo esiste solo per il piccolo.** Per il 100k e per il
   reale **non c'è nessun export**: la colonna è `[NON MISURATO]` e il tagliando
   **non è applicabile** su quei due conti. **M-C7.**
6. 🆕 **Il `Guardian` è diverso su tutti e tre i terminali** (414 / 468 / 513
   righe contro 899 del repo). 🔴 **Finché non sappiamo cosa contiene, non
   possiamo dire che le protezioni firmate siano attive** — e va detto **ogni
   volta** che si cita un muro o un cap. ⚠️ Ricordo che il **tetto per
   cluster/valuta al 3,0%** firmato il 07/09 **nel Guardian non esiste ancora
   nemmeno nel repo**: è un'intenzione, non una protezione.
7. 🆕 **Collisione di magic `770901`** (Nikkei sul 100k / XAUUSD sul piccolo).
   **M-C8.**
8. 🆕 **`771332` PTE GBPUSD B25: zero operazioni in tutto il file** (30/03 →
   10/09), pur avendo un contratto e un DD promesso del 9,87%. **M-C9.**

---

# 7. 📋 MISURE DA CHIEDERE — ordinate per gravità del buco

> Nessuna è eseguibile da qui: MT5 sta sul PC di backtest e sul VPS.
> **Sono richieste, non azioni. Niente in forward viene toccato.**

### 🥇 M-C10 🆕 — **I PER-TRADE DELLE 17 CELLE CON `n` `[NON MISURATO]`** (costo: rilancio delle celle già note, zero scelte nuove)
È il buco che oggi **sospende il merito su mezza flotta**. Ogni cella già ha il
suo file prova; serve la **stessa cella con l'export per-trade acceso**, e si
contano i `position_id`. **Non serve nessuna griglia nuova.**
🔴 **Priorità dentro la priorità**: `770511` e `970913`, perché sono le due che
il piano di ottobre teneva in squadra come «merito pieno» — e oggi sappiamo che
**non lo sono per due motivi contemporanei** (finestra piena **e** `n` in uscite).

### 🥈 M40 — **IL DD DI `771531` ALLA TAGLIA DELLA SEDIA CHE GIRA** _(già aperto nel `PIANO_PROP`)_
Due sole passate, stessa cella, stesso file prova: **`-Deposito 5000`** (il saldo
vero del piccolo) e **`-Deposito 100000 -Rischio 0,65`** (la sedia pianificata
per la challenge, per sostituire il **5,09% approssimato lineare** con una
misura). ➕ 🆕 **Nella stessa corsa si chiude anche l'`n` IS in posizioni.**

### 🥉 M-C1 — **Una foto `.chr` NUOVA di tutti e TRE i terminali, coi RISCHI**
Riconoscimento della finestra **dal fatto stampato, non a occhio**:
`Get-Process terminal64 | select Id, MainWindowTitle, Path`.
- **piccolo 50503392** — `C:\Program Files\BCM Markets MT5 Terminal` (**senza** `-V3`)
- **100k 50504263** — installazione **`-V3`**
- **reale 10105439** — `C:\BCM_Reale`
**Chiude**: i buchi 1, 2, 3, 4 di §6 + il rischio vivo di `774101` (non leggibile).

### 4️⃣ M-C7 🆕 — **L'EXPORT DEI TRADE DAL 100K E DAL REALE**
Sul piccolo `ABTG_TradeExporter` scrive `trades_auto.csv` ogni sera. Sugli altri
due conti **non esiste**. 🔴 **Senza, la corsia TAGLIANDO non è applicabile sulle
sedie della challenge e su quelle del conto che paga.** È l'export di un file di
sola lettura: **rischio zero, e sblocca una colonna intera.**

### 5️⃣ M-C11 🆕 — **IL `GUARDIAN`: quale versione gira, e cosa contiene**
414 / 468 / 513 righe in campo contro 899 nel repo. 🔴 **Prima di ogni altra
ricompilazione**, perché è la protezione. **NON propongo "ricompila tutto":
sarebbe il gesto più pericoloso possibile** — porterebbe in campo in un colpo
solo un mese di modifiche mai girate su quel conto, **comprese quelle che
cambiano le taglie**. Una sedia per volta, col rapporto dei lotti prima/dopo
come prova.

### 6️⃣ M-C4 — **Riprodurre `771322` PTE GBPUSD per sciogliere il contratto conteso**
R23 (tick, 12,5 mesi) **2,64%** · R78 (OHLC, 13 anni) **17,68% PF 0,972** · R103
(OHLC, 6,5 anni) **13,1% PF 0,96**. ⚠️ Il round lungo **a tick non si può fare**
(i tick BCM partono dal 2024.07.05): **la scelta è di FIRMA, non di misura.**

### 7️⃣ M-C8 🆕 — **Disambiguare il magic `770901`**
Due sedie, due conti, un numero. Per la corsia RISCHIO un DD attribuito alla
sedia sbagliata **fa scattare la revisione sulla gemella innocente**.

### 8️⃣ M-C9 🆕 — **`771332` e `770250`: sono attaccate?**
Zero operazioni in tutto lo storico (`771332`) e zero dal deploy (`770250`).
O sono staccate, o sono **mute**: sono due diagnosi diverse con due rimedi
diversi, e oggi **non sappiamo quale**.

### 9️⃣ M-C2 / M-C3 — **Il DD delle tre PostNews** _(invariati dal v1)_
Girano, rischiano **1,30% per evento**, e **non hanno nessun numero sotto**.
🔴 **E adesso c'è anche il pedaggio**: `771201` dopo il trailing fa **13,2x
contro un pavimento DURO di 13,3x**. **È la prima sedia della flotta che lo
sfonda, ed è una che opera.**

### 🔟 M-C5 — **Il deposito dei round R99 / R100 / R29-R31 / R36-R48 / 26-07**
🆕 **Salgono a 11** le righe con `[deposito NON DICHIARATO]` (erano 8): si
aggiungono `970912`, `970913`, `770511`, tutte e tre dalla griglia del 26/07.
Il DD% non cambia, ma **il peggior-giornata in euro e il confronto col forward
sì**. Si legge dagli `.ini` o dai driver, non dal referto.

### 1️⃣1️⃣ M-C6 — **Scrivere un contratto o dichiarare lo stato di `BREAKOUT_EA_JPY_v3`**
È l'unica sedia di cui **non si legge nemmeno il magic**, e il suo `.mq5` **non
è in nessun terminale**. Per la corsia RISCHIO è **fuori metro**.

---

# 8. 📎 APPENDICE — le note del v1 che restano valide alla lettera

## 8.1 🛑 Chiusura della contraddizione C3 (09/09) — **9,92% e 10,00% NON sono in conflitto**

| | **9,92%** | **10,00%** |
|---|---|---|
| fonte | `REFERTO_ROUND15_ORB_GESTIONE.md` r.14-17 | `R103_REFERTO_BLOCCO1_INDICI.md` r.12 |
| data | **09/08** (R15) | **24/08** (R103) |
| finestra | **solo OOS** (~12,6 mesi) | **21 mesi INTERI**, senza split |
| modello | **tick reali** | **OHLC M1** |
| deposito | **10.000 €** | **100.000 €** |
| rischio | **1,0%** misurato | **0,3%** → DD 3,00%, poi **NORMALIZZATO ×3,33** |
| `n` | **119** | **190** |

🔎 **La prova che è la STESSA cella: `71 + 119 = 190`.** IS 71 + OOS 119 = i 190
che R103 conta sulla finestra intera.

**Quale è il numero del contratto, in ordine:**
1. 🥇 **operativo, sulla `770611` del REALE: `6,5389%` OOS / `5,6530%` IS** —
   R119, **l'unico misurato ALLA TAGLIA VIVA (0,65%)**, a tick, col preset reale.
2. 🥈 **storico: `9,92%` @1%** (R15), tick, misura diretta, **doppio asterisco**.
3. 🥉 **il `10,00%` di R103 è DERIVATO**, non una misura a 1%: 3,00% × 3,33 su
   barre OHLC. **Va citato come stima di confronto fra motori, mai come il DD
   promesso della sedia.**

👉 **La sedia è DENTRO il muro, e ci sta per la TAGLIA, non per il motore.**
A 1,0% sta al muro da tutte e tre le parti (9,92 · 10,00 · **10,34 sotto
slippage**). A 0,65% sta a **6,54%**, 3,46 punti sotto. ⚠️ Resta che il **merito
è SOSPESO** (119 e 71 < 150) e che **21 mesi sono UN SOLO REGIME (toro)**.
E lo slippaggio vero sul conto che paga è **`[NON MISURATO]`** (`SlippageLogger`:
**0 deal**). 📄 `report/CONTRADDIZIONI_CHIUSE_2026-09-09.md` §C3.

## 8.2 🚨 I tre numeri che un occhio prop deve vedere subito — **aggiornati**

| sedia | DD promesso alla **taglia viva** | conto | perché brucia |
|---|---:|---|---|
| `772362` CostToCost GBPCAD | **~10,4%** | piccolo | da solo **è tutto il muro FTMO del 10%**, PF 0,92 su 6,5 anni, e col pedaggio all-in sta a **20,0x** |
| `971501` EMA200_Ott XAUUSD | **~11,5%** | piccolo | **oltre il muro**; DD @1% **45,91%**. **Prop: NO a nessuna taglia** (firma 23/08) |
| `770101` DAX Apertura EU | **~6,89%** @0,65% (10,5984% @1%) | **REALE** + 100k + piccolo | è la più veloce sul conto reale e il suo DD **mangia i due terzi del muro**. 🆕 **E il suo `n` vero è 245, non 311** |

---

# 9. 🗓️ CHANGELOG

| data | versione | cosa è cambiato |
|---|---|---|
| 07/09/2026 | **v1** | prima stesura: 47 righe-sedia, DD promesso + fonte + `n`, 4 buchi di perimetro, 6 misure richieste |
| 09/09/2026 | v1.1 | chiusura della contraddizione C3 sull'ORB `770611` |
| **11/09/2026** | 🆕 **v2 — QUESTO FILE, IL VIVO** | **27 celle di contratto corrette (= 31 righe-sedia).** (1) `771531` **7,21% → 7,8323%** @dep. 100.000, `n` **444 → 517 uscite = 257 posizioni**; (2) **classe 226 applicata e ALLARGATA**: trovati **due nomi di parametro che il grep originale non cercava** (`InpTP1_ClosePct` sulle due Aperture e sulla Nasdaq, `InpPartialClosePercent` su GapContinuation) → **17 `n` diventano `[NON MISURATO]` con forbice**, **5 ricontati e MISURATI**; (3) **classe 224 applicata**: **15 finestre** perdono l'etichetta di fuori campione, fra cui `970913` e `970912` **verificate per misura** sulla griglia del 26/07; (4) **colonna stop/spread ALL-IN** con la commissione misurata; (5) 🆕 **colonna frequenza DI CAMPO** su 31 magic; (6) 🆕 **colonna versione del codice** misurata contro quella in campo → **39 righe su 47 descrivono un codice non in campo**; (7) 🆕 **colonna «descrive la sedia che gira?»** → **SÌ su 1 riga sola**. Aperti **M-C7 · M-C8 · M-C9 · M-C10 · M-C11**; chiuso il dubbio sulla presenza in campo di `770924` |

---

_Fonti primarie di questo file, tutte nel branch `lavoro`:_
`report/CENSIMENTO_CONTRATTI.md` (v1) · `report/FIRME_2026-08-18.md` ·
`report/FIRME_2026-09-07.md` · `report/FREQUENZA_CAMPO_2026-09-11.md` ·
`report/IL_CAMPO_E_FERMO_A_AGOSTO_2026-09-11.md` ·
`report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` ·
`backtest_pipeline/prove/COLLAUDO_SPREAD_FLOTTA_CRITERI.md` ·
`backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md` (classi **224**, **226**, **228**, **229**, **231**) ·
`report/PIANO_PROP.md` (area **J**, buchi **M40**/**M41**) ·
`report/PIANO_CHALLENGE_OTTOBRE_v2.md` ·
`backtest_pipeline/coda/referti/CODA_06_quale_codice_gira_20260911_033002.log` ·
`data/statements/trades_auto.csv` (conto **50503392**, 30/03→10/09/2026) ·
`backtest_pipeline/risultati_archivio/R112_CORSA_20260826/` ·
`backtest_pipeline/risultati_prove/trades_candidati_r23/` ·
`backtest_pipeline/risultati_archivio/r83_csv/` · `r81_csv/` · `r84_csv/` ·
`backtest_pipeline/risultati_archivio/supertrend_indici_validazione/` ·
`backtest_pipeline/risultati_archivio/SuperWave/valid_SuperWaveRT_U30USD_H1_realtick.csv` ·
`backtest_pipeline/risultati_archivio/REFERTO_SHORTGATE_2026-08-30.md` ·
`backtest_pipeline/REGISTRO_TEST.md` · `mql5/Experts/*.mq5` · `mql5/Presets/*.set`.

> **Se un referto e questa tabella divergono, comanda il referto.**
> **Se il v1 e questa tabella divergono, comanda questa.**
