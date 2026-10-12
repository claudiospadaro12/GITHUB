# GBA R2S stadio A — il RILANCIO DELL'ARGENTO (scheda, 12/10/2026)

**Stato: BOZZA, NON consegnata.** Mancano i due strati del cancello (`controlla_prova`/`controlla_riga` + `controllo-preventivo`) e il pin del commit (segnaposto nella riga).
Richiesta di Claudio del 12/10: **"SI"** al rilancio di XAGUSD M1 e M15 dello stadio A.

| oggetto | file | SHA256 |
|---|---|---|
| file prova (lotto `R2SXAG2`) | `backtest_pipeline/prove/GBA_R2S_XAGUSD2_2026-10-12.txt` | `dbe11bc3b219fdc13464e1a8531552658f2b62b42e7e871e3a377b7b6e6c57b3` (prima del 1o giro del controllo-preventivo: `c2969c3a…`) |
| riga di lancio (BOZZA, `$PIN='SEGNAPOSTO_PIN_40_ESADECIMALI'`) | `backtest_pipeline/righe/RIGA_LANCIA_GBA_R2S_XAG2.txt` | (cambia col pin) |
| file madre | `backtest_pipeline/prove/GBA_R2S_XAGUSD_2026-10-12.txt` | `019c99bb…` (PASS, girato al pin `cc9bcda0`) |
| EA / include / driver | invariati: `1381E3DC…` / `3EC97115…` / `GBA_R0_PASSATE.ps1` v5 `C239F628…` | verificati a HEAD `b05f0e43` |

## 1. 🔎 La causa del timeout del 12/10 (misurata sullo zip, prima del disegno)
Fonte: `risultati_archivio/GBA_R2S_A_20261012/GBA_R2S_A.zip` → `GBA_R0_R2SXAG.zip` (giornale, MANIFEST, RIEPILOGO, ini) confrontato con le altre 7 passate dello stesso giro (8 lanciate, la REPL argento compresa) e con le 79 passate GBA lanciate e archiviate prima; e, dopo il 1o giro del controllo-preventivo, con le 246 passate NatCla F0 dello stesso PC (F5).

- **F1** — passata avviata alle **16:31:36**; il tester scrive `total time from login to stop testing 0:00:00.589 (including 0:00:00.058 for history data synchronization)` e `Test passed in 0:00:00.531` alle **16:31:49**: il **test è finito 13 secondi dopo l'avvio**. `final balance 1000000.00 EUR` (zero operazioni), riga `[GBA-CONTA] FINE` presente (6.611 segnali, tutti scartati per spread).
- **F2** — **manca** la riga del terminale `last test passed with result "successfully finished"`. Il driver la raccoglie (r.735: `Test passed`, senza distinguere maiuscole e minuscole), e nelle **7 passate OK** dello stesso giro (R2SANC; NAS, D30, U30 a M5 e M15) arriva **3-4 s** (2,96-3,98 s) dopo la fine del test (es. R2SANC 16:30:53 → 16:30:56). Il terminale non ha chiuso il test per 20 minuti.
- **F3** — durata **1215 s** = 1200 di timeout + ~7 di `CloseMainWindow` + 8 di attesa dei log: il terminale si è chiuso al primo tentativo (la M15 dice "tetto", non "lotto fermato").
- **F4** — **87 passate GBA** lanciate e archiviate (S0, R1A, R1B, R2 senza codice, uscite, notte, M5 24 ore, R2S A): le altre **86** durano fra **28 e 73 s**. La REPL dell'argento è la **sola con zero operazioni** ed è la **sola bloccata**. L'argento **non era nuovo** sul terminale: `NATCLA_F0_D` del 07/10 ha girato XAGUSD H1-D1 a Modello 1 sullo stesso PC in 28-33 s a passata, con la stessa riga `XAGUSD: history data begins from 2016.12.28`.
- **F5** (trovato dal controllo-preventivo, 1o giro) — **lo stallo NON è nuovo su questo PC**: `NATCLA_F0_C` del 08/10, passata [58/66] **E35EUR AUDIO_D1**: avvio 15:25:53, `Test passed` alle 15:26:06,994 (**+14 s**), poi KO `timeout di 20 minuti`, **1215 s**. La **stessa firma**. Quella passata **non aveva `Report=`** e **non mandava ordini** (`InpSoloConta=true`, come tutte le NatCla F0); le altre **245** passate NatCla F0 archiviate (A 66, B 66, C 65, C0 4, D 18, D ripetizione 18, PILOTA 8), tutte senza ordini e senza `Report=`, si sono chiuse in **23-68 s**. Stalli con questa firma sulle **333** passate archiviate del PC (87 GBA + 246 NatCla): **2** [MISURATO sul conteggio dei MANIFEST; causa NON MISURATA, `report/NATCLA_F0_C_LETTURA_2026-10-08.md` r.7].

| ipotesi | verdetto | perché |
|---|---|---|
| (a) report scritto in ritardo, il driver non l'ha preso | ❌ **non sostenuta** | il driver cerca il report **dopo** l'uscita del terminale (r.789-794), e il terminale non ha mai stampato la riga di fine test (F2) |
| (b) sincronizzazione o download della storia M1 all'avvio | ❌ **smentita** | 0,058 s di sincronizzazione, test finito a +13 s (F1) |
| (c) il terminale si blocca **dopo** la fine del test, prima del report | 🟢 **sostenuta come descrizione** | F1 + F2 + F3 |
| (d) causa del blocco: **zero operazioni** da sole | ❌ **smentita dall'archivio** | F5: 245 passate NatCla senza ordini, chiuse in 23-68 s |
| (d') **zero operazioni CON `Report=`** (H-ZERO-R) | 🟠 **[INFERITO, n = 1]** | fra le 87 passate GBA (tutte con `Report=`) è l'**unica** differenza trovata (F4). Nessuna fonte del repo misura un report MT5 con zero operazioni; una ricerca sul web (forum MQL5) non ha trovato niente di diretto |
| (e) **stallo occasionale** non legato alla passata | 🟠 **precedente MISURATO** (F5) | 2 su 333 passate del PC, circa 0,6% [stima dal conteggio, non una probabilità misurata]; causa non misurata |

🔴 **Conseguenza, scritta prima dei numeri**: se H-ZERO-R è vera, la REPL (n = 0 atteso) **si blocca di nuovo** e il timeout più lungo **non basta**: esce KO per "timeout di 45 minuti" e la cella resta **(C) NON SI LEGGE**. Se lo stallo è occasionale, ripetersi per caso sulla stessa passata ha una frequenza dell'ordine dello 0,6% (F5). Quindi questo rilancio è **anche la prova di H-ZERO-R** (CE8). L'eccezione n = 0 degli ESITI presuppone un report con zero operazioni: se il terminale non lo scrive mai, **con il driver v5 l'eccezione non si può raggiungere** (decisione aperta 1).

## 2. 🛠️ Il disegno (differenze dal file del 12/10, clausola per clausola nel file prova, X1-X5)
- **X1** lotto `R2SXAG` → **`R2SXAG2`** (passate `R2SXAG2_01_M15_T1_m775800`, `R2SXAG2_02_REPL_T1_m775800`).
- **X2** ordine **M15 prima**, poi REPL: se la REPL si blocca di nuovo, la M15 (n atteso 0-15) è già misurata. L'ordine non entra nel tester.
- **X3** tetto del lotto **15 → 50 minuti** (ferma solo l'**avvio** di una passata, r.670-677; la seconda deve partire anche dopo un timeout pieno, al massimo 46,6 minuti).
- **X4** `-TimeoutRunMin` **20 → 45** (nella riga; il driver ammette 1-90). Calibrato sul dato: blocco ≥ 1215 s, 45 minuti = 2,2 volte. **Non è una garanzia**: quanto dura il blocco è **[NON MISURATO]**.
- **X6** (1o giro del controllo-preventivo) **ancora**: il CE1 copiato dal file madre chiede R2SANC **"stesso giro"**, e questo giro **non** la rigira. Per `R2SXAG2` CE1 è verde **solo se** l'ancora del 12/10 è verde **e** CE7 è verde (CE7 è il controllo del giro nuovo: stesso PC, stessa storia XAGUSD M1, stesso tester; la build del terminale **non** è scritta nel RIEPILOGO). CE7 rossa o non valutabile → CE1 non verde → **tutte e due** le celle (anche la M15) **(C)**.
- **X5** magic **invariato 775800**: il driver ammette solo 775800/775850 (r.459) e D2 pretende 775800 (r.79, r.420). Il nome nuovo della misura è il **lotto**.
- **Tutto il resto è identico byte per byte** (salvo la parola "stesso giro" del CE1, sostituita da X6) (30 pin, tranche, asse, celle, Modello 1, attese, smentite, CE1-CE6, ESITI ed eccezione n = 0): `diff` del testo dalla sezione "DIFF CONTRO IL FILE MADRE" in giù = **solo** la riga `@GBA-LOTTO`. Le regole di lettura restano **E1-E4 + ordine di E3** e **R3**. **Nessun criterio nuovo.**
- **In più, solo controlli di strumento** (possono togliere la lettura, mai dare un esito):
  - **CE7 determinismo della REPL**, tolleranza **zero** (il giornale del 12/10 è un run solo; Modello 1 deterministico misurato: R2SANC = S0_01 al centesimo, gemelle S0 identiche): 6.611 righe; tentati 0, scartati per spread 6.611, posizione aperta 0; C3G cella **2,40**, BUY 2,50 (3.364), SELL 2,30 (3.247); fasce come in `LETTURA_D2_R2S_A.txt` r.35-45. Anche **un** numero diverso → REPL di **questo** lotto **(C), senza appello**: la spiegazione scritta serve a disegnare la misura dopo, **mai** a riaprire questa lettura; e **non** si usa il giornale vecchio al suo posto. **CE7 non valutabile** (REPL non lanciata, giornale senza `[GBA-CONTA] FINE`, o D2 col lotto `R2SXAG2` non passato dal cancello **prima** di aprire lo zip) = non verde (direzione dell'errore verso la non-lettura, classi 1376/1382).
  - **CE8 causa del blocco** (descrizione): ora di `Test passed` rispetto a `t_avvio`, presenza di `last test passed`, durata, n. **Smentisce H-ZERO-R**: REPL o M15 con n = 0 **e** report scritto; oppure M15 con n ≥ 1 **e** bloccata. **Coerente, non prova**: M15 con n ≥ 1 e report, REPL bloccata; M15 con n = 0 e bloccata. **Riproduce** il blocco: REPL di nuovo senza report, con il test finito entro ~1 minuto → 2 su 2 sulla stessa passata (per caso ~0,6%): causa legata alla passata, **non ancora quale** → **non si rilancia una terza volta** con un timeout più lungo, si porta a Claudio. Contro-esempio: (b) sposterebbe l'ora di `Test passed`, H-ZERO-R no; lo stallo occasionale non si separa da H-ZERO-R con una passata sola.

## 3. ⏱️ Bersaglio e tempo
- 🖥️ **Solo una finestra PowerShell sul PC di backtest `DESKTOP-H4D7CAJ`**, terminale `C:\Program Files\BCM Markets MT5 Terminal` (demo **50503392**), solo Strategy Tester. Guardie, elenco NON TOCCATI, mutex, controlli MT5 aperti: **identici** alla riga dello stadio A (che ha girato il 12/10).
- **Tempo atteso**: se il blocco **non** si ripete, **2-4 minuti**; se si ripete sulla M1 **~50 minuti** (~100 se si blocca anche la M15). **Non fermarla prima di 115 minuti** = compilazione 3 + tetto 50 + ultima passata 45 + chiusura 2 + log e zip 10 + download e raccolta 5.
- Raccolta: `Desktop\GBA_R2S_XAG2.zip` con `GBA_R0_R2SXAG2.zip` + `ESITI_R2S_XAG2.txt`.

## 4. 📖 D2 (`leggi_gba_r2s_c3g.py`, SHA256 `14384d87…`) **oggi rifiuta** questo zip — modifica minima (NON fatta)
D2 rifiuta: lotto `R2SXAG2` fuori da `LOTTI` (r.382-383) e pin diverso da `cc9bcda0` (`PIN_AMMESSI`, r.80 e r.400). L'**ancora** non va rigirata: CE1 (r.795-814) chiede lo zip `GBA_R0_R2SANC.zip` **caricato insieme**, controlla il pin solo contro `PIN_AMMESSI`, mentre il pin non viene confrontato fra un lotto e l'altro. Basta quindi lo zip **del 12/10** (stesso EA, stesso include, stesso driver).
Modifica minima, **3 righe di dati, nessuna logica**:
1. `PIN_AMMESSI = ("cc9bcda0…", "<pin nuovo>")`;
2. `LOTTI["R2SXAG2"] = {"prova": "GBA_R2S_XAGUSD2_2026-10-12.txt", "sha": "dbe11bc3…57b3", "simbolo": "XAGUSD", "celle": [("M15","M15"), ("REPL","M1")], "S": 6.65}`;
3. `ORDINE` con `"R2SXAG2"` dopo `"R2SXAG"`.
⚠️ La modifica di D2 deve passare dal cancello **prima** di aprire lo zip: senza, CE7 non è valutabile (le sue cifre sono quelle stampate da D2) e per X6 **tutte e due** le celle sono (C).
Lettura: `python3 -I backtest_pipeline/leggi_gba_r2s_c3g.py GBA_R0_R2SANC.zip GBA_R2S_XAG2.zip` (lo zip dell'ancora è dentro `risultati_archivio/GBA_R2S_A_20261012/GBA_R2S_A.zip`). `ESITI_R2S_XAG2.txt` non è controllato da D2 (cerca solo `ESITI_R2S_A.txt`, r.504): il pin di ogni lotto lo controlla il RIEPILOGO.
⚠️ **Effetto collaterale**: D2 cambia SHA256. Per E3 (1) una conferma a tick reali letta con uno strumento D2 di **SHA diverso** da quello che ha letto la passata a Modello 1 = **conferma non data**. Per non avere letture a Modello 1 con due SHA diversi, gli zip dello stadio A (NAS, D30, U30) andrebbero **riletti** con il D2 nuovo (decisione aperta 2).

## 5. ✅ Controlli eseguiti (worktree, nessuna macchina MT5)
- `controlla_prova.py` sul file nuovo: **OK** (31 pin, 2 celle, 0 problemi); rifatto dopo le correzioni del 1o giro del controllo-preventivo (F2 7 e non 8, F5, H-ZERO-R, X6, CE7 senza appello e "non valutabile", CE8): **OK**, e il parsing vero del driver v5 (r.91-247 + r.341-472, pwsh) legge lotto `R2SXAG2`, 2 passate, tetto 50, M15 → REPL, XAGUSD M15/M1. Il testo dalla sezione "DIFF CONTRO IL FILE MADRE" in giù è **identico** a quello del pin `4d61090c`.
- `controlla_riga.py --riga` sulla bozza: **unico bloccante il segnaposto del PIN** (atteso). Con un commit vero al posto del segnaposto: **nessun difetto meccanico** (4 rilievi, gli stessi della riga dello stadio A: nomi dei conti nell'elenco NON TOCCATI).
- **Parsing vero del driver v5** (r.91-247, 341-472, 593-651) eseguito con `pwsh`: prima **validato** rigenerando l'ini archiviato del 12/10 (`gba_R2SXAG_01_REPL_T1_m775800.ini`: **identico**); poi sul file nuovo: lotto `R2SXAG2`, 2 passate, Modello 1, tetto 50, ordine M15 → REPL; gli ini nuovi differiscono da quelli del 12/10 **solo** in `Report=`.
- 🔴 **Il contro-esempio ha trovato un difetto, corretto prima della consegna**: nella prima stesura una riga di commento cominciava con `#     @GBA-ASSE (...)` e il driver (regex r.348 `^#\s*@GBA-(TRANCHE|CELLA|LOTTO|ASSE)\s+`) la leggeva come **blocco** → `throw 'blocco @GBA malformato'`. Riscritta. **Classe nuova proposta** per la checklist: *"in un file prova GBA una riga di commento che comincia (dopo `#` e spazi) con `@GBA-` è un blocco per il driver"*.
- `$LOTTI` con **un solo** lotto scritto `@(,@(...))`: provato in pwsh (Count 1, `L[0]=R2SXAG2`); contro-esempio `@(@(...))` = **4 elementi**, cioè il ciclo avrebbe girato su quattro stringhe. Riga ASCII, 0 errori di parsing.
- SHA256 di EA, include, driver e file madre ricalcolati a HEAD: **uguali** a quelli della riga dello stadio A.

## 6. ⚪ Cosa NON è stato verificato
- La **storia M1 e i tick dell'argento sul PC di backtest** (barre BCM H1 dal 2008.11.07; M1 su T1 c'è: 88.416 barre generate il 12/10; tick reali **[NON MISURATO]**, qui non servono: Modello 1).
- **Perché** il terminale si è bloccato (H-ZERO-R, zero operazioni CON report, è un'inferenza su n = 1); la riga intera non è stata girata (gira solo su Windows, sul PC di backtest).
- D2 sul lotto nuovo (non modificato, vedi §4).

## 7. 🙋 Decisioni aperte
1. **Se il blocco si ripete** (2 su 2 sulla stessa passata = causa legata alla passata, H-ZERO-R o altro: CE8): l'eccezione n = 0 non si raggiunge con il driver v5. Due strade, tutte e due **firme**: un driver v6 che, quando il giornale ha `final balance` uguale al deposito e la riga `[GBA-CONTA] FINE`, accetti n = 0 senza report; oppure dichiarare la cella con il solo giornale (oggi E3 la chiama (C)). Non si allarga il timeout una terza volta.
2. **D2**: la modifica minima di §4 (3 righe) e la rilettura degli zip dello stadio A con lo SHA nuovo.
3. **CE7 e CE8** sono controlli nuovi di strumento (per X6 una CE7 rossa o non valutabile porta a (C) TUTTE E DUE le celle, REPL e M15; CE8 è descrizione): il cancello li accetta così o li declassa a sola descrizione.

## PASS del cancello (12/10/2026, 4 giri)
Riga `backtest_pipeline/righe/RIGA_LANCIA_GBA_R2S_XAG2.txt` @ 1e544488, SHA256 7D1F4F269EC5FC3B63CD5B1004A332909A99B1E7F20973B120C928513B4A02BF, PIN d53493a92901b82c6b4c12c1d79ec3cb4ebfa5bb: giudizio (controllo-preventivo) e meccanica (verificatore-stringhe) PASS al 4o giro. Si lancia SOLO dopo che lo stadio B (RIGA_LANCIA_GBA_R2S_B) ha stampato la riga finale con rc (un solo giro GBA alla volta). Rilievi non bloccanti accettati: raccolta in modalita' Stop (R2), driver r.702 'a occhio' neutralizzato dalla riga (R3), titolo 'Strategy Tester' solo per NON chiudere (R4); da dire in chat a Claudio. Per leggere lo zip serve D2 esteso (PIN_AMMESSI, LOTTI R2SXAG2, ORDINE) passato dal cancello PRIMA di aprirlo.
