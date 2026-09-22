# 🗄️ I FILE FERMI — il censimento delle occasioni non misurate

**22/09/2026** · branch `lavoro` · 🛑 **SOLA LETTURA E SOLA MISURA**: nessun round lanciato,
nessun EA toccato, nessun preset toccato, nessuna taglia e nessun parametro di rischio proposto.
Nessuna riga consegnata a Claudio.

> ## 🎯 IN CINQUE RIGHE
> 1. 🟢 **Il conteggio di partenza regge quasi tutto**: 599 file prova etichettati (dichiarati
>    601) e 277 senza risultato (dichiarati 283) — **2% di scarto**, dovuto a come si riconosce
>    l'etichetta.
> 2. 🔴 **Ma il verdetto "fermo" era largo del 20%**: **41 etichette su 242 (55 file) SONO
>    GIRATE** — i loro risultati stanno sotto l'`-Etichetta` che il file prova **dichiara al
>    suo interno**, che non è la sua sigla `R…`. `R35a` scrive `-Etichetta r35` e i suoi CSV
>    sono in `risultati_prove/aperture_r35/`. 📌 **Classe nuova 576.**
> 3. 🟢 **I veri fermi sono 201 etichette / 222 file prova**, di cui **90 etichette (102 file)
>    nominano una delle sei sedie in challenge FTMO** e **70 sono parcheggiate in `CODA.txt`**,
>    che il 21/09 è stata sospesa per intero.
> 4. 🔴 **La ragione dominante NON è un numero brutto: è una coda spenta.** Solo **2** round su
>    201 si dichiarano superati in testa (`R200b`, `R204a`). Gli altri non hanno mai avuto il
>    loro numero.
> 5. 🏆 **Il ritrovamento che vale**: **tre round pronti, gatati, con la riga di lancio già
>    scritta, su sedie che stanno operando adesso** — `R205a`, `R203a`, `R172e` — più `R147a`,
>    che è **l'ultima casella aperta del certificato di morte della `771531`** e costa
>    **2 celle**.

---

# 🔟 LE DIECI COSE FERME CHE VALE LA PENA RIPRENDERE

Ordine: **(1)** tocca una delle sei sedie FTMO · **(2)** è una manopola d'uscita o un cancello di
rischio · **(3)** costa poco · **(4)** 🔴 **è ferma per un numero MANCANTE, non per un numero
BRUTTO**.

🔴 **Nessuna di queste dieci è ferma per un numero brutto.** Verificato una per una: nessuna ha
un PF, un DD o un n che la boccia. Sono ferme perché **la misura non è mai stata fatta**.

| # | round | sedia | che cosa misura | costo (celle × 2 gambe) | perché si è fermata | che cosa ci darebbe |
|---|---|---|---|---|---|---|
| **1** | **`R205a`** | 🪑 **`770101`** DAX Apertura, D30EUR | `InpAllowShort` 0→1: **il lato corto del DAX col retest** | 🟢 **2 × 2 = 4 passate** — il round più economico della lista | Scritto **oggi 22/09**, passato dal cancello due volte, **riga di lancio pronta** (`RIGA_R205A_DA_MANDARE.md`). **Mai eseguito**: la giornata è finita prima | 🔴 Chiude un **`NON ANCORA MISURATO` travestito da `già bocciato`**: in repo lo short d'apertura risulta morto, ma R42/R43 misuravano il **FADE** e il **RIMBALZO**, non il **RETEST**. Sono tre mestieri diversi. Il lato corto del DAX è **il raddoppio di frequenza** della sedia 770101, a costo zero di codice (`MonitorRetest()` r.1966 ha già il ramo SELL) |
| **2** | **`R203a`** | 🪑 **`770101`** DAX Apertura, D30EUR | `InpMinStopPts` 0→8625 (passo 2875): **il pavimento dello stop** | 🟢 **4 × 2 = 8 passate** | **Quattro stesure**, tutte bocciate dal cancello, la quinta è **PASS con riga pronta** (`RIGA_R203A_DA_MANDARE.md`). Mai eseguita | 🎯 È **l'asse che R202B indica**: il DD del DAX **non** si abbassa sul bersaglio d'uscita restando dentro la frontiera del costo, e **Claudio ha chiesto lo STOP**. È una richiesta esplicita rimasta senza numero |
| **3** | **`R147a`** | 🪑 **`771531`** EMA200 Dow, U30USD H1 | `InpBreakeven` on/off — **l'ultima manopola d'uscita mai mossa della sedia migliore** | 🟢 **2 × 2 = 4 passate** | Scritto il **14/09**, sesto file della famiglia `r136`, finito in `CODA.txt` e **mai arrivato in cima** prima che la coda fosse sospesa il 21/09 | 🔴 Il file lo dichiara da sé: *«è l'ULTIMA CASELLA APERTA DEL CERTIFICATO DI MORTE SULLA 771531»*. Con questa, la sedia che CLAUDE.md chiama *«l'unica delle 41 vive che passa i cancelli di oggi alla lettera»* ha il certificato **completo** |
| **4** | **`R172e`** | 🪑 **`770202`** Dow Apertura, U30USD M5 | `InpTP1_R` 0,50→2,00 (passo 0,25): **il bersaglio del parziale** | 🟠 **7 × 2 = 14 passate** | In repo **dal 16/09**, mai girato. La notte del 22/09 è stato **scelto al posto di `R204a`** (*«78 pin su 80 identici, asse che CONTIENE il mio, 7 celle invece di 4, 3 ancore invece di 1»*) e la riga è stata scritta — **poi non è partito** | 🎯 Chiude la domanda su `InpTP1_R` per la 770202 **senza un terzo round**. La decisione di stanotte (*«resta `InpTP1_R=1.0`»*) è presa su **3 candidate**; questo asse ne guarda **7** con 3 ancore di riproduzione |
| **5** | **`R206a`** | 🪑 **`770411`** MaxMin DAX Short, D30EUR | `InpAtrSLmult` 1,5→4,0 (passo 0,5): **il moltiplicatore dello STOP** | 🟠 **6 × 2 = 12 passate** | Scritto **oggi 22/09**. 🔴 **Non ha ancora la riga di lancio** — è l'unico dei cinque round freschi senza `RIGA_*_DA_MANDARE` | 🟢 La `770411` è **l'unica sedia dimostrata sicura contro il muro FTMO** (6,27% contro 10%, `IL_MURO_MISURATO_2026-09-22.md`) — ma su **14 posizioni**. Questo round mette ad asse lo stop, cioè **la leva che decide quel 6,27%**, con l'ancora 2,5 che deve riprodurre `r81a` |
| **6** | **`R152a`** | 🪑 **`770202`** Dow Apertura, U30USD M5 | **export per-trade della cella viva**, per `mc_dd_cella.py` | 🟢 **1 corsa** (asse = solo il magic) | Scritto il **15/09**, in `CODA.txt`, mai girato | 🔴 `STOP_VS_SPREAD_FTMO_2026-09-20.md` lo dice esplicito: *«il floor si alza **dopo** la corsa `R152a` già scritta in repo»*. È **un blocco in mezzo alla strada**: senza il CSV per-trade, il Monte Carlo sul DD della cella non parte — e il DD è esattamente il numero che `IL_MURO_MISURATO` dichiara `[NON MISURATO]` per cinque sedie su sei |
| **7** | **`R161a`** (+`R161b/c`) | 🪑 **`770411`** citata; `ABTG_BreakingBand` GBPUSD H1, magic 772161 | `InpSL_ATRmult`: **lo stop «3 × ATR» che nessuno ha mai messo in discussione in 22 file prova** | 🟠 **7 × 2 = 14 passate** × 3 gemelli | Scritto il **15/09**, PASS del cancello con 5 rilievi applicati, in coda, mai partito | 🎯 È una **regola fissa ereditata da una guida**, mai misurata su nessun simbolo. Walk-forward vero con IS e OOS attesi sopra il pavimento 150. Se lo stop è tarato male, lo è su **tutta la famiglia** |
| **8** | **`R160a–e`** | 🪑 **`770411`** citata; `ABTG_PunteLarry`, 5 gemelli | `InpMaxDaysHold`: **il time-stop in giorni sui cinque gemelli mai toccati** | 🟠 **7 × 2 = 14 passate** × 5 simboli | Scritti il **15/09**, secondo cancello superato (FAIL corretto: buco di storico + artefatto di costo aggregato), in coda, mai partiti | 📏 Finestra **27 anni** con taglio IS/OOS vero — è uno dei pochi round in repo che soddisfa l'**Emendamento della Finestra** per costruzione. E `R156a` (stessa manopola su U30USD) è **già gatato** |
| **9** | **`R120c` / `R120d`** | `ABTG_SupertrendReversal_Multi_Ott.` XAUUSD H4 · `ABTG_SupRev_DAX_H4_Ott.` D30EUR | `InpTrailOnST` / `InpExitOnFlip` / `InpFirstFraction` | 🟠 4 celle × 2 gambe, × 2 simboli | Scritti il **09/09** dall'`AUDIT_USCITE_2026-09-09.md`, mai girati | 🔴 L'audit li segnala come **la voce numero 1 per rapporto valore/lavoro**: `InpTrailOnST` è in **15 EA** con default `true` e **ZERO volte ad asse**; `InpExitOnFlip` in **14 EA**, idem. Sono **tre manopole d'uscita accese per default su mezza flotta e mai misurate** |
| **10** | **`RIGA_IMBUTO_DAX_FTMO`** | 🪑 **`770101`** | riga di imbuto sul DAX in campo | 🟢 riga di sola lettura | Scritta **oggi 22/09**, 🔴 **nessuna traccia di output in repo**, mentre la gemella `RIGA_IMBUTO_EMA200_FTMO` ha prodotto `report/PRIMO_STOP_FTMO_2026-09-22.md` | 🪑 Il gemello ha già dato un referto sul primo stop FTMO. Questa è la stessa domanda sulla sedia DAX, **a costo quasi nullo** |

### 🚧 E le due che NON sono entrate, e va detto perché
- **`PREOPEN_*` (15 file prova, zero risultati, `RIGA_PREOPEN_DAX` mai eseguita dal 28/08).**
  🔴 **Esclusa perché è ferma per un numero BRUTTO, non mancante**:
  `report/PREOPEN_NASDAQ_VALE_UN_POSTO_2026-09-12.md` misura **PF OOS 0,963 · DD 19,40% · n 175**
  a tick reali, e l'asse dell'uscita è **quasi inerte** (span PF OOS 0,052 → 1,015 < 1,10).
  Il gemello DAX resta una casella vuota del certificato di morte, **ma non è un'occasione**.
- **`R204a`** — 🛑 **superato per iscritto** da `R172e` la notte del 22/09. Non è fermo: è chiuso.

---

# 1️⃣ CENSIMENTO — I FILE PROVA FERMI

## 1.1 🧮 Quanto era largo l'errore del conteggio di partenza

| misura | conteggio dichiarato | mio conteggio | scarto |
|---|---|---|---|
| file prova con etichetta `R<numero><lettera>` nel **nome** | 601 | **599** | −2 (0,3%) |
| …senza risultato che ne porti l'etichetta | 283 | **277** | −6 (2,1%) |
| …che nominano una delle sei sedie FTMO | 162 | **110** (su 94 etichette) | −52 |

🟢 **Il metodo di partenza è riproducibile**: lo scarto sui primi due numeri è **sotto il 2,5%** e
si spiega con il riconoscimento dell'etichetta (prefisso del nome file contro token libero) e con
l'aver incluso, dal lato risultati, anche i **nomi di cartella** e le **sigle minuscole**
(`r81_csv`, `r116_londonfx`, `aperture_r35`), che una regex sensibile alle maiuscole sui soli
nomi di file non vede.

## 1.2 🔴 Ma il VERDETTO era largo del 20% — e la causa è una sola

**«Nessun risultato in repo» ≠ «mai girato».** Misurato, non supposto:

| | etichette | file prova |
|---|---|---|
| dichiarate ferme dal confronto sui nomi | 242 | 277 |
| 🔴 **in realtà GIRATE**, risultati sotto l'`-Etichetta` dichiarata nel file | **41** | **55** |
| 🟢 **veramente ferme** | **201** | **222** |

**La causa, per nome:** un file prova dichiara al suo interno la stringa con cui i risultati
verranno archiviati, e **quella stringa non è la sua sigla**. `R35a_range_DAX.txt` r.3 scrive
`-Etichetta r35`, e i suoi CSV stanno in `risultati_prove/aperture_r35/`. Stessa cosa per
`R34*`→`r34`, `R37*`→`r37`, `R39*`→`r39`, `R40*`, `R41*`, `R42*`, `R16a-d`→`PTA/PTB/PTC/PTD`,
`R86*`→`R86ADAX`/`R86AORO`, `R87*`, `R89*`, `R120b/e`.
📌 **Classe nuova 576**, registrata in `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md`.

⚠️ **E resta un errore che NON ho potuto chiudere**, dichiarato: un round può essere girato sul
PC di backtest e **i CSV non committati**. Il repo non lo sa. Per questo i 201 sono un
**limite superiore** dei fermi veri, non un numero esatto.

## 1.3 📋 I 201 veri fermi, per stato **dichiarato nel file stesso**

| stato dichiarato **in testa** (prime 25 righe) | etichette |
|---|---|
| 🛑 **SUPERATO / RITIRATO** | **2** — `R200b` (ritirato: la risposta era già in archivio) · `R204a` (sostituito da `R172e`) |
| 🔴 **dichiara MAI GIRATO** | **11** |
| ⬜ **nessuna dichiarazione** (scritto, gatato, mai eseguito) | **188** |

🔴 **Attenzione a come è stato ottenuto questo numero, perché la prima versione era sbagliata.**
Cercando le parole *superato / sostituito / ritirato* **in tutto il file** uscivano **49**
etichette "superate". **Sono quasi tutti falsi positivi**: in `R172e` r.19-47 «SUPERATO» qualifica
**singole righe di un addendum** (*«-Deposito 100000 → SUPERATO: il banco è…»*), in `R153a` r.61
una **versione di script**, in `R170a` r.623 una **manopola**. Restringendo all'intestazione
restano **2**, ed entrambe sono **confermate da un documento indipendente**
(`REGISTRO_TEST.md` per `R200b`, `report/NOTTE_2026-09-22.md` per `R204a`).
👉 **La regola larga sovrastimava i «superati» di 47 etichette su 49.**

## 1.4 🅰️ «MAI GIRATO e ancora valido» — dove sono

**70 delle 201** etichette ferme sono **parcheggiate in `backtest_pipeline/coda/CODA.txt`**, che
il **21/09 è stata sospesa per intero** (righe ROUND attive: **0**, erano **115**, di cui **82** a
tick reali) insieme all'attività `ABTG_Runner` delle 03:30 sul VPS.

🟢 **La sospensione era giusta** — il 21/09 il VPS si è inchiodato mentre le sei sedie FTMO
operavano. 🔴 **Ma la conseguenza non è stata contata: 70 round gatati sono andati a dormire
con lei**, e nessun documento li elenca come fermi.

Dominano le **manopole d'uscita e di stop**, che è esattamente la leva più grossa mai mossa:
`slatrmult` · `maxdayshold` · `trailstartr` · `breakeven` · `closeatend` · `slbufferatr` ·
`atrexit` · `tprr` · `maxhours` · `slgapmult` · `partialtargetr` · `slbufferpips`.

## 1.5 🅱️ Ferme e che nominano una sedia in challenge

| sedia | etichette ferme che la nominano |
|---|---|
| `770101` DAX Apertura | **50** |
| `770202` Dow Apertura | **45** |
| `770411` MaxMin DAX Short | **20** |
| `770511` | **15** |
| `771531` EMA200 Dow | **12** |
| `770260` Nasdaq Apertura | **6** |

*(Una etichetta può nominarne più d'una: le etichette distinte con almeno una sedia FTMO sono
**90**, per **102 file prova**.)*

---

# 2️⃣ CENSIMENTO — LE RIGHE MAI MANDATE

`backtest_pipeline/righe/` contiene **241 file**, di cui **103** `*_DA_MANDARE*` e **129** `.ps1`.

| | numero |
|---|---|
| righe `DA_MANDARE` totali | **103** |
| 🔴 **senza NESSUNA traccia** (né referto in `report/`, né artefatto di risultato) | **11** |
| senza un risultato archiviato col proprio nome (molte hanno però prodotto un referto) | 52 |

## 🔴 Le 11 senza nessuna traccia

| riga | data | che cos'è |
|---|---|---|
| `RIGA_CHIUDISEDIE` | 25/08 | spegnere le sedie revocate (`ABTG_ChiudiSedie`) |
| `RIGA_PREOPEN_DAX` | 28/08 | il livello pre-apertura sul DAX — 🟠 famiglia con **numero brutto** (vedi sopra) |
| `RIGA_CRT_GATE` · `RIGA_CRT_TICK_DIAG` · `RIGA_CRT_TICK_G` · `RIGA_CRT_EXT_S2G` | 30/08 | i quattro stadi del verdetto CRT TurtleSoup a tick BCM |
| `RIGA_INVES_DRIVE` | 30/08 | inversione da esaurimento |
| `RIGA_SHORTGATE_CASSA` | 30/08 | conferma a tick del breakdown short gated |
| `RIGA_POSTNEWS_1330` | 05/09 | PostNews USD 13:30 / USDJPY, passo 0 conta-occasioni |
| `RIGA_DIAGNOSI_DAX_P1` | 09/09 | diagnosi DAX passo 1 |
| `RIGA_SPREAD_FLOTTA_TRANCHE` | 14/09 | le 5 tranche di spread orario che mancano (225JPY, oro, 10 forex) |

## 🔴 Le righe FRESCHE, gatate, e mai eseguite — sono queste che bruciano

| riga | data | bersaglio | stato |
|---|---|---|---|
| `RIGA_R205A_DA_MANDARE.md` | **22/09** | 🪑 `770101` DAX | PASS, **mai eseguita** |
| `RIGA_R204A_DA_MANDARE.md` | **22/09** | `770202` Dow | 🛑 **superata** da `R172e` — non va eseguita |
| `RIGA_R172E_DA_MANDARE.md` | **22/09** | 🪑 `770202` Dow | PASS, **mai eseguita** |
| `RIGA_R203A_DA_MANDARE.md` | **21/09** | 🪑 `770101` DAX | PASS alla 5ª stesura, **mai eseguita** |
| `RIGA_IMBUTO_DAX_FTMO_DA_MANDARE.md` | **22/09** | 🪑 `770101` DAX | **nessun output**, mentre la gemella EMA200 ha prodotto un referto |
| `RIGA_BINARI_FTMO_DA_MANDARE.txt` | **21/09** | 🪑 i binari delle **sei** sedie in campo | referto `BINARI_IN_CAMPO_FTMO_2026-09-21.md` scritto, **riga mai eseguita** |

🟢 **E una che invece è stata eseguita, e conta**: `RIGA_SOSPENDI_RUNNER_DA_MANDARE.md` (21/09).
`report/NOTTE_2026-09-22.md` conferma **`Ready → Disabled`, riletta per conferma**. Il runner
delle 03:30 **non ha girato, ed è voluto**.

---

# 3️⃣ CENSIMENTO — I REFERTI CHE DICHIARANO UN LAVORO NON FINITO

Su **476** referti in `report/`, **161** contengono almeno un marcatore di buco dichiarato
(`[NON MISURATO]`, `[NON VERIFICATO]`, `[NON MISURABILE…]`, `NON ANCORA MISURATO`), per
**1.725 occorrenze** complessive.

🟢 **Questo è un segno di salute, non di malattia**: sono buchi **dichiarati**, che è esattamente
ciò che il *certificato di morte* chiede. Il problema non è che esistano: è **quali sono ancora
aperti oggi**.

## 🔴 I buchi ancora aperti oggi, per nome

| referto | la cosa specifica che dichiara mancante | ancora aperto? |
|---|---|---|
| `IL_MURO_MISURATO_2026-09-22.md` | 🪑 **Cinque sedie su sei `[NON MISURATE]` contro il muro FTMO del 10%** — e per `770202` e `770260` la misura esistente le mette **sopra** il 10% sul limite superiore | 🔴 **SÌ** — è il buco più grande in repo oggi |
| `CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` | la colonna rossa poggia su `Equity DD % × 2`, che è un **limite superiore**, non la perdita statica | 🟠 **parzialmente chiuso** il 22/09: il campo giusto (`Equity Drawdown Absolute`) è stato **trovato e riconciliato**, ma applicato a **una sedia sola** |
| `SEDIA_770402_COSA_MANCA_2026-09-20.md` | che cosa manca alla sedia `770402` | 🔴 SÌ |
| `SEDIA_770411_IL_RIENTRO_2026-09-20.md` | il rientro della `770411` | 🟠 parziale — `IL_MURO_MISURATO` la promuove a «sicura», ma su **14 posizioni** |
| `STOP_VS_SPREAD_FTMO_2026-09-20.md` | *«il floor si alza **dopo** la corsa `R152a` già scritta in repo»* | 🔴 **SÌ** — ed è la **voce 6** della triage |
| `ALZARE_IL_PF_2026-09-22.md` · `ANATOMIA_ESPLOSIONI_ORO_2026-09-22.md` · `ORO_M1_2021_2026_PIANO_2026-09-22.md` · `LA_CELLA_SENZA_BREAKEVEN_2026-09-22.md` | buchi dichiarati **oggi stesso** | 🔴 SÌ, per costruzione |
| `LETTURA_BACKLOG_COMPLETA_2026-09-21.md` | **7 motori su 18** restano *«NON ANCORA MISURATI»* col certificato di morte incompleto | 🔴 SÌ |

⚠️ **Nota di onestà sul conteggio**: le **1.725** occorrenze **non sono 1.725 buchi distinti**.
Molte sono la stessa lacuna ripetuta in tabelle diverse, e molte sono **dichiarazioni di
non-misurabilità volute** (*«questo round non può misurare il costo»*), che sono corrette e non
vanno chiuse. **Non le ho separate una per una**: sarebbe servito leggere 161 referti interi.
👉 **Dichiarato come NON COPERTO** (§5).

---

# 4️⃣ CENSIMENTO — EA E SCRIPT MAI MESSI ALLA PROVA

Su **155** file `.mq5` in `mql5/Experts/` e `mql5/Scripts/`, **33 non compaiono in nessun file
prova e in nessun risultato**. Ma vanno separati, perché **non sono tutti motori**:

## 🔴 4.1 MOTORI scritti e mai misurati — sono questi che contano

| EA | righe | ultimo tocco | citato in |
|---|---|---|---|
| `ABTG_PointBreak.mq5` | 394 | 31/07 | `GIACIMENTO_DI_CASA_2026-09-03.md`, `CORSIA_DEMO_CANDIDATI.md` |
| `ABTG_SuperFilter.mq5` | 373 | 31/07 | idem |
| `ABTG_HARSI.mq5` | 496 | 19/08 | `CORSIA_DEMO_CANDIDATI_v2.md` |
| `ABTG_DAX_M3.mq5` | 568 | 08/08 | `PREOPEN_NASDAQ_VALE_UN_POSTO_2026-09-12.md` |
| `ABTG_Londra_ORB.mq5` | 399 | 04/08 | idem |
| `ABTG_Nightly_Ottimizzato.mq5` | 439 | 19/08 | `RISCHIO_DICHIARATO_VS_VERO_2026-09-08.md` |
| `ABTG_SuperWave_EA.mq5` · `ABTG_SondaMargine.mq5` · `ABTG_Apertura_Study_EA.mq5` | — | — | — |

🔴 **`ABTG_PointBreak` e `ABTG_SuperFilter` sono in repo dal 31/07 — quasi due mesi — con
~390 righe ciascuno e ZERO misure.** Sono nominati in `CORSIA_DEMO_CANDIDATI.md`, cioè qualcuno
li ha messi in una corsia e poi la corsia non è avanzata.

## ⚪ 4.2 Strumenti diagnostici — normale che non abbiano un backtest
`ABTG_ChiudiSedie` · `ABTG_CanarinoGuardian` · `ABTG_SpreadTick` · `ABTG_SondaSessione` ·
`ABTG_ImportaStoricoEsterno(_v2)` · `ABTG_ImportaTickEsterno` · `ABTG_PrevoloFTMO_Specifiche` ·
`ABTG_NFP_Study` · `ABTG_Apertura_Study`.
🔴 **Tranne uno: `ABTG_SondaADR.mq5`** (464 righe, 21/08) — **non è citato in NESSUN referto**.
È l'unico file veramente **orfano** del repo.

## ⚪ 4.3 EA di provenienza esterna — mai adottati
`ORB_DAX_BASE_EA` · `ORB_DAX_PM_EA` · `ORB_GOLD_FIBONACCI_EA` (+`v3.21`) · `DAX_MASTER_PROP` ·
`DAX_M3_Supertrend` · `GoldBreakout_Levels` · `Gold_Scalper_TK_BB_BE_EA` · `HARSI_Assistant` ·
`IchiCross_Gold_722` · `IchiTrend_Gold_Base`.
📌 Sono materiale di terze parti importato per studio. **Non li conto come occasioni perse**:
non sono mai stati promessi a nessuno.

---

# 5️⃣ 🧪 IL CONTRO-ESEMPIO — quello che mi avrebbe fatto sbagliare

**L'errore più probabile era dichiarare «mai girato» qualcosa di girato e archiviato altrove.**
Ho preso tre casi e li ho verificati fino in fondo, e **due su tre mi hanno dato torto**.

### ❌ Caso 1 — `R35a`: **dichiarato fermo, è GIRATO**
Cercando `R35a` nei nomi dei risultati: **niente**. Ma il file prova r.3 dice
`-Prova prove\R35a_range_DAX.txt -Etichetta r35`, e in
`backtest_pipeline/risultati_prove/aperture_r35/` ci sono **4 CSV** (IS e OOS, DAX e Dow).
👉 **Falso positivo.** Da qui è nata la ricerca sistematica che ha recuperato **41 etichette**.

### ❌ Caso 2 — `R172D`: **un DOCUMENTO di casa lo dichiara fermo, ed è GIRATO**
`REGISTRO_TEST.md` (21/09) lo mette fra i *«gatati e non ancora girati»* e aggiunge
*«scritto il 16/09 e mai girato»*. **Falso**: `risultati_prove/R172D/` contiene IS, OOS e referto
datati **2026-09-21 21:01:33**, con 7 celle per finestra.
🔴 Lo stesso vale per **tutti e sette** i round di quella lista (`R200c`, `R201a`, `R199b`,
`R200a`, `R200d/e`): sono girati fra le **21:05 e le 23:27** del 21/09.
👉 **`REGISTRO_TEST.md` è stato scritto a metà giornata e non più aggiornato.** Se avessi usato
quel documento come fonte, avrei dichiarato ferme **sette misure esistenti**.

### ✅ Caso 3 — `R205a` e `R203a`: **verificati fermi davvero**
`find` su tutto il repo (esclusi `.git` e `.claude`) per `*R205*` e `*R203*` restituisce
**esattamente due file ciascuno**: il file prova e la riga di lancio. Nessun CSV, nessun referto,
nessuna cartella, **sotto nessuna grafia** — e i file **non dichiarano nessuna `-Etichetta`
alternativa**. Idem per `R206`, che non ha nemmeno la riga.
👉 **Questi sono fermi, e la voce 1 e 2 della triage reggono.**

### 🔬 E un quarto, sul classificatore
Il marcatore *«SUPERATO»* cercato in tutto il file dava **49** round superati. Verificando il
**contesto** riga per riga: in `R172e` qualifica **righe di un addendum**, in `R153a` una
**versione di script**, in `R170a` una **manopola**. I superati veri sono **2**.
👉 **Un classificatore per parola chiave, senza contesto, sbagliava 47 volte su 49.**

---

# 6️⃣ 🕳️ COSA RESTA NON COPERTO — per nome

1. 🔴 **I round girati sul PC di backtest e MAI COMMITTATI.** Il repo non può vederli. I **201**
   fermi sono un **limite superiore**. Chiuderlo richiede una riga di sola lettura sul **PC di
   backtest** (`DESKTOP-H4D7CAJ`) che elenchi le cartelle dei risultati locali — **non l'ho
   scritta**, perché il mandato è di sola misura in repo.
2. 🔴 **I 1.725 `[NON MISURATO]` non sono stati separati uno per uno** in *buco vero* contro
   *non-misurabilità dichiarata e corretta*. Ho verificato **solo** i referti degli ultimi
   **tre giorni** (20-22/09). I 161 file interi non sono stati letti.
3. 🟠 **I 125 file prova SENZA etichetta `R`** (`PREOPEN_*` 15 file, `A1_*`, `ABTEST_*`,
   `ABTG_*.txt`) **non sono entrati nel confronto**, perché il conteggio di partenza era
   definito sulle etichette `R…`. **Sono un insieme non censito**, e i 15 `PREOPEN_*` mostrano
   che dentro c'è roba ferma.
4. 🟠 **Le 129 `.ps1` in `righe/`** sono state contate ma **non verificate una per una** contro
   il loro output.
5. 🟠 **Non ho misurato se un round fermo sia stato reso INUTILE** da un cambio di geometria o da
   una manopola risultata inerte (il terzo stato che il mandato chiede). Farlo richiede leggere
   ogni file prova contro lo stato attuale del suo EA: **188 letture**. Ho classificato per
   **stato dichiarato**, che è un fatto, invece di inferirlo.
6. ⚪ **`.claude/worktrees/`** contiene **copie complete del repo**: sono state **escluse** da
   tutti i conteggi. Dichiarato perché altrimenti ogni numero sarebbe stato triplicato.

---

## 📚 Fonti di questo referto
`backtest_pipeline/prove/` (889 file) · `backtest_pipeline/risultati_prove/` e
`risultati_archivio/` (2.936 file, 3.179 percorsi con le cartelle) ·
`backtest_pipeline/righe/` (241 file) · `backtest_pipeline/coda/CODA.txt` (3.208 righe) ·
`report/` (476 referti) · `mql5/Experts/` + `mql5/Scripts/` (155 `.mq5`) ·
`REGISTRO_TEST.md` · `report/NOTTE_2026-09-22.md` · `report/IL_MURO_MISURATO_2026-09-22.md` ·
`report/LETTURA_BACKLOG_COMPLETA_2026-09-21.md` · `report/PREOPEN_NASDAQ_VALE_UN_POSTO_2026-09-12.md` ·
`report/STOP_VS_SPREAD_FTMO_2026-09-20.md` · `report/AUDIT_USCITE_2026-09-09.md`.
