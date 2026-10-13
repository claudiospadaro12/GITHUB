# GBA R2S — la CONFERMA A TICK REALI DELL'ARGENTO (E3), scheda del 13/10/2026

**Stato: BOZZA, NON consegnata.** Mancano i due strati del cancello (`controlla_prova`/`controlla_riga` + `controllo-preventivo`) e il pin del commit (segnaposto nella riga).
Richiesta di Claudio del 13/10: **"SI PREPARA LA RIGA DELL'ARGENTO A TICK REALI"**.
Perché: il 13/10 la cella **XAGUSD M1** (REPL, T1) è uscita **"ESCLUSA (Modello 1)"** (C3G 2,40x contro S 6,65x, n 0, 6.611 segnali tutti scartati per spread, `report/GBA_R2S_XAG2_LETTURA_2026-10-13.md`). Per **E3** la casella 4 si chiude solo dopo **una** passata a tick reali della **stessa cella e stessa tranche**, letta dallo **stesso D2**.

| oggetto | file | SHA256 |
|---|---|---|
| file prova argento (lotto `R2SXAGT`) | `backtest_pipeline/prove/GBA_R2S_XAGUSDT_2026-10-13.txt` | `6f2ea09249cf19588b4c52c724c27794c28966da16d82f4e6e3989cff0d59ad4` |
| file prova ancora (lotto `R2SXTANC`) | `backtest_pipeline/prove/GBA_R2S_XAGT_ANCORA_2026-10-13.txt` | `23295bf35b6104b1d04002ccbbb6da6b8002823f5467606e3aa96414ea87c18c` |
| riga (BOZZA, `$PIN='SEGNAPOSTO_PIN_40_ESADECIMALI'`) | `backtest_pipeline/righe/RIGA_LANCIA_GBA_R2S_XAGT.txt` | cambia col pin |
| file madri | `GBA_R2S_XAGUSD2_2026-10-12.txt` (`dbe11bc3…`) · `GBA_R2SB_ANCORA_2026-10-12.txt` (`822e3a26…`) | PASS |
| EA / include / driver | invariati: `1381E3DC…` / `3EC97115…` / `GBA_R0_PASSATE.ps1` v5 `C239F628…` | ricalcolati nel worktree |

## 1. 🛠️ Il disegno (clausole T1-T8 nel file prova)
- **Due lotti, una passata ciascuno, Modello 4, T1 2026.07.01-2026.09.30**: prima `R2SXAGT` (XAGUSD M1, REPL; tag `R2SXAGT_01_REPL_T1_m775800`), poi `R2SXTANC` (XAUUSD M1, REPL; tag `R2SXTANC_01_REPL_T1_m775800`). L'argento va **prima** perché la sua passata misura da sola la storia a tick (esito (1) non ha bisogno dell'ancora); l'ancora serve a leggere tutti gli altri esiti.
- **Solo la M1**: la M15 a Modello 1 è "n insufficiente", non ESCLUSA → E3 non la riguarda.
- **Ini**: rispetto all'ini archiviato della REPL argento del 13/10 cambiano **solo `Model=1→4` e `Report=`**; l'ini dell'ancora è **identico a quello di R1A_01** salvo `Report=` (sez. 4).
- **Timeout per lotto** (quinto elemento di `$LOTTI`): argento **60** minuti (la storia a tick e il suo eventuale download sono **[NON MISURATI]**), ancora **30** (come `R2SBANC`). Tetto dei lotti 10 minuti (ferma solo l'avvio).
- **🔑 Ancora: lotto NUOVO `R2SXTANC`, non il file `GBA_R2SB_ANCORA`** (decisione mia, dichiarata): il driver pretende che `-Lotto` sia un `@GBA-LOTTO` del file (r.445-446), quindi riusare quel file vuol dire lotto `R2SBANC` e zip `GBA_R0_R2SBANC.zip`, **lo stesso nome** dello zip della riga dello stadio B (consegnata, zip non arrivato): due misure di due giri con lo stesso nome. Costo: un file prova in più, che è il madre con il **solo nome del lotto** cambiato (pin identici, provato con `diff`).

## 2. 📏 Attese e smentite (scritte prima, etichette della classe 1383)
- n = 0, tutti i segnali scartati per spread → KO "ZERO operazioni" = **eccezione n = 0**, rc 3 **atteso**.
- Righe segnale 6.480-6.740 **[INFERITO dall'oro]**: S0 e R1A hanno 6.973 righe l'uno, 6.916 in comune.
- **C3G della cella a tick 1,8-3,0x, centro ~2,3x [INFERITO]**: il verso e l'ordine dello scarto sono presi dall'oro (−5,3%, misurato) e dagli indici (−10/−20%, ricavati da tick di un altro periodo); per l'argento il verso è **[NON MISURATO]**. Righe ≥ 40x: 0-5; spread della cella 0,04-0,07 USD.
- **Smentite simmetriche** (smentiscono la STIMA, mai l'esito): > 3,0x (verso opposto) / < 1,8x (spread molto più largo). Se il C3G arriva a ≥ 6,65x (spread tick mediano ≤ ~0,018 USD, R3) la (iii) cade e l'esito è (5) **per la regola**, non per la smentita.
- **Esito atteso**: (6) "ESCLUSA PER COSTO (Modello 1 e tick reali)" **se** la storia a tick c'è; altrimenti (1). Quale dei due: **[NON MISURATO]**.

## 3. 🧪 Controlli di strumento (tolgono soltanto; NON VALUTABILE = rosso)
- **CE1** = ancora dello stesso giro: A1 manifest **128 / −6577.48 / 0.83 / 100%ticksreali / 88416 barre / 25648545 tick / `XAUUSD 2024.07.10`** (= R1A_01); A2 D2 sul giornale **21,60x, ≥40x 651, ≥50x 280, −1.0x 0, 128 ingressi**; A3 `leggi_gba_r0.py` si ferma per doppione con `GBA_R0_R1A.zip`.
- **CE-D2** (stesso strumento): D2 v3 (`77F1F72E…`) non accetta lotti nuovi, quindi la lettura la fa per forza un D2 con SHA nuovo. **Scritto ora**: lo stesso D2 v4 rilegge **nella stessa lettura** anche `GBA_R2S_XAG2.zip` e deve rifare **a tolleranza zero** le cifre di v3 sulla REPL (6611; 6611/0/6611/0/0; C3G 2.40 / 2.50 / 2.30; le sei fasce; ≥40x 0; "ESCLUSA (Modello 1)"). Così le due passate di E3 sono lette dallo stesso SHA.
- **CE-T** (tick veri): (a) è il KO del driver sui tick (→ esito (1)); (b) **tick del report > 353.614**, cioè più dei tick che Modello 1 genera dalle sole barre M1 della stessa cella (4 per barra, MANIFEST del 13/10). Contro-esempio: un terminale che segnasse 100% generando i tick dalle barre darebbe ~353.614 → rossa.
- CE2 (firma dell'oro), CE4, CE6: come nel file madre.

## 4. ✅ Controlli eseguiti (worktree, nessuna macchina MT5)
- `controlla_prova.py`: **OK** su tutti e due i file (31 pin, 0 problemi). Pin **identici** ai madri (`diff` delle righe non commento: vuoto). Blocchi `@GBA-` solo nelle righe dei blocchi; file ASCII.
- **Parsing vero del driver v5** (r.102-247, 341-470, 593-651) eseguito con `pwsh` su un'imbracatura: prima **validato** rigenerando due ini archiviati (REPL argento del 13/10 e R1A_01 del 10/10): **identici byte per byte**. Poi: `R2SXAGT` = 1 passata, Modello 4, tetto 10, XAGUSD M1, `AllowLiveTrading=false`, `InpMagic=775800`, `FromDate=2026.07.01`/`ToDate=2026.09.30`; diff contro la REPL del 13/10 = **solo `Model` e `Report`**. `R2SXTANC` = diff contro R1A_01 = **solo `Report`**. Contro-esempio: `-Lotto R2SBANC` sul file ancora nuovo e `-Lotto R2SXTANC` sul file argento → il driver **si ferma** ("lotto non trovato").
- `controlla_riga.py`: col segnaposto **unico bloccante il PIN** (atteso); con un pin vero al posto del segnaposto **nessun difetto meccanico**, 4 rilievi (gli stessi della riga XAG2: nomi dei conti nell'elenco NON TOCCATI).
- **Binder** (`controlla_binding.ps1`, `StaticParameterBinder::BindCommand` su 85 comandi): 0 errori di sintassi, solo i 2 falsi positivi noti di `Set-Content -Encoding/-NoNewline` (identici alla riga XAG2 che ha girato). Nessun `-ForegroundColor` doppio.
- **Riga eseguita in `pwsh`** (macchina finta `DESKTOP-H4D7CAJ`, profilo e Desktop nello scratchpad, driver scaricato davvero al pin `d53493a9` e verificato `C239F628` + marcatore, `powershell.exe` sostituito da uno stub): (a) giro pulito → due chiamate con `-TimeoutRunMin 60` e `30` e gli SHA giusti, raccolta `GBA_R2S_XAGT.zip` con i 3 file attesi; (b) terminale rimasto aperto dopo `R2SXAGT` → `R2SXTANC` NON LANCIATO, testo "NON rilanciare la riga intera", in fondo PID + cartella e istruzione "SOLO cartella …, dal PID, MAI dal titolo" (classe 1394); (c) MT5 aperto prima del primo lotto (copia di prova col controllo iniziale neutralizzato) → nessun lotto, testo "rilancia la riga intera", in fondo il rimando alla riga rossa (testo condizionato a `$fermo` **e** a `$lanciati`).

## 5. ⚪ Cosa NON è stato verificato
- **La storia a tick reali di XAGUSD sul PC di backtest**: nessuna riga `XAGUSD: ticks data begins from` in tutto il repo; la densità dei tick dell'argento BCM non è misurata (`misura_tick` ha solo NASUSD, D30EUR, U30USD). Lo misura il driver alla prima passata.
- Quanto dura il download dei tick dal server BCM, se servisse; la riga intera su Windows PowerShell 5.1 (provata solo in `pwsh`, come le precedenti).
- D2 v4 (lo estende un altro agente): CE-D2, CE1-A2 e CE-T (b) dipendono da lui.

## 6. 🙋 Decisioni aperte
1. **CE-D2** è la mia lettura della frase di E3 "stesso strumento D2" (rilettura del Modello 1 con lo stesso SHA, a tolleranza zero): il cancello la accetta così o pretende altro.
2. **Se esce (1)** (tick dell'argento mancanti): la via più corta al numero è una **decisione** (scaricare i tick dell'argento sul PC, oppure la misura R3 (ii): lo spread orario dai tick storici).
3. **Ordine dei lotti**: argento prima, ancora dopo (motivo in sez. 1).
