# GBA R2S stadio A — il RILANCIO DELL'ARGENTO (scheda, 12/10/2026)

**Stato: BOZZA, NON consegnata.** Mancano i due strati del cancello (`controlla_prova`/`controlla_riga` + `controllo-preventivo`) e il pin del commit (segnaposto nella riga).
Richiesta di Claudio del 12/10: **"SI"** al rilancio di XAGUSD M1 e M15 dello stadio A.

| oggetto | file | SHA256 |
|---|---|---|
| file prova (lotto `R2SXAG2`) | `backtest_pipeline/prove/GBA_R2S_XAGUSD2_2026-10-12.txt` | `c2969c3a457fa8ae67126d098b848071705c8851d91d25caa38a6de15936a52c` |
| riga di lancio (BOZZA, `$PIN='SEGNAPOSTO_PIN_40_ESADECIMALI'`) | `backtest_pipeline/righe/RIGA_LANCIA_GBA_R2S_XAG2.txt` | (cambia col pin) |
| file madre | `backtest_pipeline/prove/GBA_R2S_XAGUSD_2026-10-12.txt` | `019c99bb…` (PASS, girato al pin `cc9bcda0`) |
| EA / include / driver | invariati: `1381E3DC…` / `3EC97115…` / `GBA_R0_PASSATE.ps1` v5 `C239F628…` | verificati a HEAD `b05f0e43` |

## 1. 🔎 La causa del timeout del 12/10 (misurata sullo zip, prima del disegno)
Fonte: `risultati_archivio/GBA_R2S_A_20261012/GBA_R2S_A.zip` → `GBA_R0_R2SXAG.zip` (giornale, MANIFEST, RIEPILOGO, ini) confrontato con le altre 8 passate dello stesso giro e con le 78 passate GBA lanciate e archiviate prima.

- **F1** — passata avviata alle **16:31:36**; il tester scrive `total time from login to stop testing 0:00:00.589 (including 0:00:00.058 for history data synchronization)` e `Test passed in 0:00:00.531` alle **16:31:49**: il **test è finito 13 secondi dopo l'avvio**. `final balance 1000000.00 EUR` (zero operazioni), riga `[GBA-CONTA] FINE` presente (6.611 segnali, tutti scartati per spread).
- **F2** — **manca** la riga del terminale `last test passed with result "successfully finished"`. Il driver la raccoglie (r.735: `Test passed`, senza distinguere maiuscole e minuscole), e nelle **8 passate OK** dello stesso giro arriva **3-4 s** dopo la fine del test (es. R2SANC 16:30:53 → 16:30:56). Il terminale non ha chiuso il test per 20 minuti.
- **F3** — durata **1215 s** = 1200 di timeout + ~7 di `CloseMainWindow` + 8 di attesa dei log: il terminale si è chiuso al primo tentativo (la M15 dice "tetto", non "lotto fermato").
- **F4** — **87 passate GBA** lanciate e archiviate (S0, R1A, R1B, R2 senza codice, uscite, notte, M5 24 ore, R2S A): le altre **86** durano fra **28 e 73 s**. La REPL dell'argento è la **sola con zero operazioni** ed è la **sola bloccata**. L'argento **non era nuovo** sul terminale: `NATCLA_F0_D` del 07/10 ha girato XAGUSD H1-D1 a Modello 1 sullo stesso PC in 28-33 s a passata, con la stessa riga `XAGUSD: history data begins from 2016.12.28`.

| ipotesi | verdetto | perché |
|---|---|---|
| (a) report scritto in ritardo, il driver non l'ha preso | ❌ **non sostenuta** | il driver cerca il report **dopo** l'uscita del terminale (r.789-794), e il terminale non ha mai stampato la riga di fine test (F2) |
| (b) sincronizzazione o download della storia M1 all'avvio | ❌ **smentita** | 0,058 s di sincronizzazione, test finito a +13 s (F1) |
| (c) il terminale si blocca **dopo** la fine del test, prima del report | 🟢 **sostenuta come descrizione** | F1 + F2 + F3 |
| (d) causa del blocco: **zero operazioni nel test** (H-ZERO) | 🟠 **[INFERITO, n = 1]** | è l'**unica** differenza trovata fra la passata bloccata e le altre 86 (F4); un blocco occasionale non legato alla passata **non è escluso**. Nessuna fonte del repo misura un report MT5 con zero operazioni (NATCLA non chiedeva `Report=`); una ricerca sul web (forum MQL5) non ha trovato niente di diretto |

🔴 **Conseguenza, scritta prima dei numeri**: se H-ZERO è vera, la REPL (n = 0 atteso) **si blocca di nuovo** e il timeout più lungo **non basta**: esce KO per "timeout di 45 minuti" e la cella resta **(C) conferma non data**. Quindi questo rilancio è **anche la prova di H-ZERO** (CE8). L'eccezione n = 0 degli ESITI presuppone un report con zero operazioni: se il terminale non lo scrive mai, **con il driver v5 l'eccezione non si può raggiungere** (decisione aperta 1).

## 2. 🛠️ Il disegno (differenze dal file del 12/10, clausola per clausola nel file prova, X1-X5)
- **X1** lotto `R2SXAG` → **`R2SXAG2`** (passate `R2SXAG2_01_M15_T1_m775800`, `R2SXAG2_02_REPL_T1_m775800`).
- **X2** ordine **M15 prima**, poi REPL: se la REPL si blocca di nuovo, la M15 (n atteso 0-15) è già misurata. L'ordine non entra nel tester.
- **X3** tetto del lotto **15 → 50 minuti** (ferma solo l'**avvio** di una passata, r.670-677; la seconda deve partire anche dopo un timeout pieno, al massimo 46,6 minuti).
- **X4** `-TimeoutRunMin` **20 → 45** (nella riga; il driver ammette 1-90). Calibrato sul dato: blocco ≥ 1215 s, 45 minuti = 2,2 volte. **Non è una garanzia**: quanto dura il blocco è **[NON MISURATO]**.
- **X5** magic **invariato 775800**: il driver ammette solo 775800/775850 (r.459) e D2 pretende 775800 (r.79, r.420). Il nome nuovo della misura è il **lotto**.
- **Tutto il resto è identico byte per byte** (30 pin, tranche, asse, celle, Modello 1, attese, smentite, CE1-CE6, ESITI ed eccezione n = 0): `diff` del testo dalla sezione "DIFF CONTRO IL FILE MADRE" in giù = **solo** la riga `@GBA-LOTTO`. Le regole di lettura restano **E1-E4 + ordine di E3** e **R3**. **Nessun criterio nuovo.**
- **In più, solo controlli di strumento** (possono togliere la lettura, mai dare un esito):
  - **CE7 determinismo della REPL**, tolleranza **zero** (il giornale del 12/10 è un run solo; Modello 1 deterministico misurato: R2SANC = S0_01 al centesimo, gemelle S0 identiche): 6.611 righe; tentati 0, scartati per spread 6.611, posizione aperta 0; C3G cella **2,40**, BUY 2,50 (3.364), SELL 2,30 (3.247); fasce come in `LETTURA_D2_R2S_A.txt` r.35-45. Anche **un** numero diverso → REPL **(C)** finché la differenza non è spiegata, e **non** si usa il giornale vecchio al suo posto (direzione dell'errore verso la non-lettura, classi 1376/1382).
  - **CE8 causa del blocco** (descrizione): ora di `Test passed` rispetto a `t_avvio`, presenza di `last test passed`, durata, n. **Smentisce H-ZERO**: REPL o M15 con n = 0 **e** report scritto; oppure M15 con n ≥ 1 **e** bloccata. **Riproduce** il blocco: REPL di nuovo senza report, con il test finito entro ~1 minuto → **non si rilancia una terza volta** con un timeout più lungo, si porta a Claudio. Contro-esempio: (b) sposterebbe l'ora di `Test passed`, H-ZERO no.

## 3. ⏱️ Bersaglio e tempo
- 🖥️ **Solo una finestra PowerShell sul PC di backtest `DESKTOP-H4D7CAJ`**, terminale `C:\Program Files\BCM Markets MT5 Terminal` (demo **50503392**), solo Strategy Tester. Guardie, elenco NON TOCCATI, mutex, controlli MT5 aperti: **identici** alla riga dello stadio A (che ha girato il 12/10).
- **Tempo atteso**: se il blocco **non** si ripete, **2-4 minuti**; se si ripete sulla M1 **~50 minuti** (~100 se si blocca anche la M15). **Non fermarla prima di 115 minuti** = compilazione 3 + tetto 50 + ultima passata 45 + chiusura 2 + log e zip 10 + download e raccolta 5.
- Raccolta: `Desktop\GBA_R2S_XAG2.zip` con `GBA_R0_R2SXAG2.zip` + `ESITI_R2S_XAG2.txt`.

## 4. 📖 D2 (`leggi_gba_r2s_c3g.py`, SHA256 `14384d87…`) **oggi rifiuta** questo zip — modifica minima (NON fatta)
D2 rifiuta: lotto `R2SXAG2` fuori da `LOTTI` (r.382-383) e pin diverso da `cc9bcda0` (`PIN_AMMESSI`, r.80 e r.400). L'**ancora** non va rigirata: CE1 (r.795-814) chiede lo zip `GBA_R0_R2SANC.zip` **caricato insieme**, controlla il pin solo contro `PIN_AMMESSI`, mentre il pin non viene confrontato fra un lotto e l'altro. Basta quindi lo zip **del 12/10** (stesso EA, stesso include, stesso driver).
Modifica minima, **3 righe di dati, nessuna logica**:
1. `PIN_AMMESSI = ("cc9bcda0…", "<pin nuovo>")`;
2. `LOTTI["R2SXAG2"] = {"prova": "GBA_R2S_XAGUSD2_2026-10-12.txt", "sha": "c2969c3a…a52c", "simbolo": "XAGUSD", "celle": [("M15","M15"), ("REPL","M1")], "S": 6.65}`;
3. `ORDINE` con `"R2SXAG2"` dopo `"R2SXAG"`.
Lettura: `python3 -I backtest_pipeline/leggi_gba_r2s_c3g.py GBA_R0_R2SANC.zip GBA_R2S_XAG2.zip` (lo zip dell'ancora è dentro `risultati_archivio/GBA_R2S_A_20261012/GBA_R2S_A.zip`). `ESITI_R2S_XAG2.txt` non è controllato da D2 (cerca solo `ESITI_R2S_A.txt`, r.504): il pin di ogni lotto lo controlla il RIEPILOGO.
⚠️ **Effetto collaterale**: D2 cambia SHA256. Per E3 (1) una conferma a tick reali letta con uno strumento D2 di **SHA diverso** da quello che ha letto la passata a Modello 1 = **conferma non data**. Per non avere letture a Modello 1 con due SHA diversi, gli zip dello stadio A (NAS, D30, U30) andrebbero **riletti** con il D2 nuovo (decisione aperta 2).

## 5. ✅ Controlli eseguiti (worktree, nessuna macchina MT5)
- `controlla_prova.py` sul file nuovo: **OK** (31 pin, 2 celle, 0 problemi).
- `controlla_riga.py --riga` sulla bozza: **unico bloccante il segnaposto del PIN** (atteso). Con un commit vero al posto del segnaposto: **nessun difetto meccanico** (4 rilievi, gli stessi della riga dello stadio A: nomi dei conti nell'elenco NON TOCCATI).
- **Parsing vero del driver v5** (r.91-247, 341-472, 593-651) eseguito con `pwsh`: prima **validato** rigenerando l'ini archiviato del 12/10 (`gba_R2SXAG_01_REPL_T1_m775800.ini`: **identico**); poi sul file nuovo: lotto `R2SXAG2`, 2 passate, Modello 1, tetto 50, ordine M15 → REPL; gli ini nuovi differiscono da quelli del 12/10 **solo** in `Report=`.
- 🔴 **Il contro-esempio ha trovato un difetto, corretto prima della consegna**: nella prima stesura una riga di commento cominciava con `#     @GBA-ASSE (...)` e il driver (regex r.348 `^#\s*@GBA-(TRANCHE|CELLA|LOTTO|ASSE)\s+`) la leggeva come **blocco** → `throw 'blocco @GBA malformato'`. Riscritta. **Classe nuova proposta** per la checklist: *"in un file prova GBA una riga di commento che comincia (dopo `#` e spazi) con `@GBA-` è un blocco per il driver"*.
- `$LOTTI` con **un solo** lotto scritto `@(,@(...))`: provato in pwsh (Count 1, `L[0]=R2SXAG2`); contro-esempio `@(@(...))` = **4 elementi**, cioè il ciclo avrebbe girato su quattro stringhe. Riga ASCII, 0 errori di parsing.
- SHA256 di EA, include, driver e file madre ricalcolati a HEAD: **uguali** a quelli della riga dello stadio A.

## 6. ⚪ Cosa NON è stato verificato
- La **storia M1 e i tick dell'argento sul PC di backtest** (barre BCM H1 dal 2008.11.07; M1 su T1 c'è: 88.416 barre generate il 12/10; tick reali **[NON MISURATO]**, qui non servono: Modello 1).
- **Perché** il terminale si è bloccato (H-ZERO è un'inferenza su n = 1); la riga intera non è stata girata (gira solo su Windows, sul PC di backtest).
- D2 sul lotto nuovo (non modificato, vedi §4).

## 7. 🙋 Decisioni aperte
1. **Se il blocco si ripete** (H-ZERO sostenuta 2 su 2): l'eccezione n = 0 non si raggiunge con il driver v5. Due strade, tutte e due **firme**: un driver v6 che, quando il giornale ha `final balance` uguale al deposito e la riga `[GBA-CONTA] FINE`, accetti n = 0 senza report; oppure dichiarare la cella con il solo giornale (oggi E3 la chiama (C)). Non si allarga il timeout una terza volta.
2. **D2**: la modifica minima di §4 (3 righe) e la rilettura degli zip dello stadio A con lo SHA nuovo.
3. **CE7 e CE8** sono controlli nuovi di strumento (CE7 può solo portare la REPL a (C), CE8 è descrizione): il cancello li accetta così o li declassa a sola descrizione.
