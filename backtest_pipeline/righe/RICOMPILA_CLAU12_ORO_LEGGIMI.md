# RICOMPILA_CLAU12_ORO: il binario della sedia ORO solo LONG sul terminale FTMO

**Stato: BOZZA, IN CODA, NON inviata.** Esce verso Claudio solo con i prerequisiti qui sotto e dopo il
cancello (strato 1 + `controllo-preventivo`) sulla riga col pin vero. E' la catena **(b)** della bozza
`report/SEDIA_ORO_LONG_FTMO_BOZZA_2026-09-27.md` §④: oggi su `C:\FTMO` **non c'e' nessun binario** di
`ABTG_MaxMinNotte` (CODA_06 27/09), e la sedia senza binario non esiste.

- Script: `backtest_pipeline/righe/RICOMPILA_CLAU12_ORO.ps1` (`MARCATORE_RICOMPILA_CLAU12_ORO_v1`)
- Riga: `backtest_pipeline/righe/RIGA_RICOMPILA_CLAU12_ORO_FTMO.txt` (pin = il commit dello script qui sopra,
  `1277a1aaf1044e88bbd06a64795e8c5352828a54`; SHA256 dello script
  `AF7F878B0855A545E60F48FE505EED39D38B2B2DB4C43E7BC412E5847899565E`)
- Sorgente: `mql5/Experts/ABTG_MaxMinNotte.mq5` al pin `7d0da9f94ae7ae5834a1664d46738ebb87ada2e1` (v1.11, 03/09; HEAD
  `d27b81b4` e' identico: diff vuoto). SHA256 dei byte `9346F16A4CAAD4CF18EE9B772CAF06A497B3C6727E0D0B65250E377E75BFAE80`,
  scheletro **918 / `32C692ADD267DD4FA9C500281C2427F5306B1F961AFD1315E867D4B6D717146D`** (funzione di `RINOMINA_CLAU12.ps1`
  r.202-212, rifatta in Python e controllata sui due file gia' in tavola: tornano al byte).
- Modello riprodotto lettera per lettera: `RICOMPILA_CLAU12_TRAILFIX.ps1` v1 (SHA `E7C11601...`, PASS alla seconda passata,
  classe 832 chiusa) + la sua riga + il suo LEGGIMI.

## Prerequisiti (tutti, nessuno "per analogia")

1. **R268 (tick reali) e R268d (22 anni) LETTI con esito** sul PC di backtest `DESKTOP-H4D7CAJ` (bozza §③). Oggi: **in coda,
   non girati**. Senza questi il binario sarebbe pronto per una sedia che non ha ancora il suo numero di rischio.
2. **Firma di Claudio**: e' un binario **nuovo** su un conto vivo della challenge (`541452707`). Magic e taglia **non** stanno in
   questa riga (preset in bozza `mql5/Presets/FTMO/BOZZA_CLAU12_MaxMinNotte_ORO_LONG_FTMO.set`, passo (c), riga sua).
3. **Sabato o domenica** (ora Windows del VPS). In feriale lo script si ferma; `-ForzaGiorno` esiste ma la riga NON lo passa.
4. **Nessuna posizione XAUUSD sul conto `541452707`** (scheda Commercio guardata a occhio) e **nessun EA oro attaccato** su
   `C:\FTMO` (CODA_01 27/09: 9 sedie, nessuna su XAUUSD).
5. **Sedie oro del piccolo `50503392` (`770402` a due lati, `772343`, `971501`, `970901`) e del manuale `50503635` in PAUSA**:
   blocco FTMO **cross-account** (bozza §②(f) e §⑧.4, risposta FTMO ancora aperta). Lo script **non apre** le altre cartelle
   dati: questo punto lo dichiara chi lancia.
6. 🔴 **Questa riga NON attacca la sedia: compila e basta.** L'attacco a un grafico XAUUSD nuovo e' il passo (d) della bozza,
   a mano, e viene DOPO le risposte FTMO e la firma della taglia.

I punti 1, 2, 4 (scheda Commercio) e 5 li dichiara chi lancia scrivendo `PIATTO` alla domanda della riga (lo script lo
riceve come `-Conferma PIATTO` e **dice** che non li puo' verificare). Il punto 4 lo **misura** per quello che il disco permette
(vedi f2/f3 sotto).

## Bersaglio

🪟 Terminale FTMO `541452707`, cartella programma `C:\FTMO`, cartella dati `46C9F8E9FF0C747B2B5E09BCC13D5237`. La riga si
incolla nella 🖥️ **finestra PowerShell sul VPS `VMI3047753`**. Scrive SOLO in `MQL5\Experts` di quella cartella dati (**un**
`.mq5` nuovo + il suo `.ex5` via MetaEditor) e sul Desktop del VPS.

**Non toccati, per nome**: REALE `10105439` (`C:\BCM_Reale`), 100k `50504263` (`-V3`), piccolo `50503392` (`BCM Markets MT5
Terminal`), manuale `50503635` (`C:\MT5_MANUALE`), banco `50504400` (`C:\MT5_Backtest`), Pepperstone, Tickmill — nessuna di
queste cartelle dati viene nemmeno aperta. Dentro `C:\FTMO`: preset, taglie, input, magic, profili, `CLAU12_Guardian`
(`779001`), le sette `CLAU12_*` in campo e i loro `.ex5`, l'include `ABTG_PausaGuardian.mqh`.

## Cosa fa

Guardia macchina; cartella FTMO certificata (hash + `origin.txt` = `C:\FTMO` + conto nel giornale); controllo del giorno;
elenco `terminal64` con PID/titolo/percorso; stop se MetaEditor e' aperto; **pin obbligato** (`7d0da9f9`: un altro pin e' un
altro lavoro); scarico del sorgente al pin con SHA256 dei byte e scheletro; deve avere `#include <ABTG_PausaGuardian.mqh>` e
la chiamata a 2 argomenti `ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_MaxMinNotte")` (r.346), e **nessuna chiamata `ABTG_*(`
fuori dalle 12 funzioni della v1.20** (commenti tolti prima: r.40 e r.610 citano `ABTG_ORB_Ottimizzato (ramo` e sarebbero
falsi positivi) — se ne chiama una, vuole l'include a HEAD e si ferma **prima di scrivere**; **f)** i quattro nomi
`ABTG_MaxMinNotte.mq5/.ex5` e `CLAU12_MaxMinNotte.mq5/.ex5` devono essere **assenti**; **f2)** `.chr` del profilo attivo
(`config\*.ini -> ProfileLast`, come CODA_01): un `<expert>` su un grafico XAUUSD = STOP; **f3)** giornali `logs\` degli
ultimi 7 giorni: righe XAUUSD di deal/ordine/posizione = STOP (`-IgnoraGiornaleOro` esiste, la riga NON lo passa); **g)**
include misurato = v1.20 pin `26a18566` (398 righe, scheletro `D179846B`, byte `83F19640`); **h)** copie: niente da copiare,
dichiarato; **i)** scrittura di `CLAU12_MaxMinNotte.mq5` con i byte del pin, SHA256 riletto dal disco; **j)** compilazione
con `C:\FTMO\metaeditor64.exe /compile /inc /log` (log UTF-16, `0 errors`, `.ex5` datato dopo l'avvio, classe 270); **k)**
scheletro del file in campo stampato; **l)** Desktop `RICOMPILA_CLAU12_ORO_<ora>` (log, `ESITO.txt`, sorgente scaricato) e zip.
Uscite: `0` fatto, `1` rifiuto (niente toccato nel terminale), `2` gia' fatto, `3` fermato dopo aver scritto. La prova a
secco non scrive nulla, nemmeno sul Desktop.

## Cosa NON fa

Non attacca e non stacca EA, non tocca grafici, profili, preset, taglie, magic, Guardian, le altre sette `CLAU12_`, gli
`ABTG_*` rimasti, l'include. Non apre e non chiude terminali, non tocca Algo Trading, non lancia nessun tester. Non
aggiorna l'include: **se il compilatore la vuole diversa** (errori che nominano `ABTG_`/`PausaGuardian`), lo script
ripristina, esce con `3` e lo dice — e' un'altra firma.

## Scostamenti dal modello TRAILFIX, con la ragione

1. **File NUOVO, non ricompilazione.** Il modello pretende in campo l'impronta del pin `9fca63d9` e fa copie di sicurezza;
   qui i quattro nomi devono essere **assenti** (bozza §④.3 f) e non c'e' niente da copiare. Unica eccezione:
   `CLAU12_MaxMinNotte.mq5` gia' col nostro scheletro e `.ex5` piu' recente = **GIA FATTO** (uscita 2), perche' la riga fa
   prova a secco + esecuzione e la seconda corsa non deve spaventare.
2. **Il ripristino e' TOGLIERE.** Non c'era niente prima: in caso di fallimento il `.mq5` (e il `.ex5` se nato) vengono messi
   da parte come `.ORO_FALLITO_<ora>` (invisibili al Navigatore, stesso schema del ramo "prima non c'era" del modello
   r.572-575), e il disco torna senza `CLAU12_MaxMinNotte`. Il `catch` esterno lo fa anche lui (classe 832).
3. **Il nome cambia, il contenuto no.** `RINOMINA_CLAU12.ps1` fa solo `Rename-Item` (misurato: nessuna `Set-Content` /
   `WriteAllText` sui `.mq5`): `#property`, `Print` e la stringa `"ABTG_MaxMinNotte"` passata al Guardian restano quelli del
   pin, e lo SHA256 di `CLAU12_MaxMinNotte.mq5` scritto e' **lo stesso** del sorgente al pin. Effetto cosmetico gia' misurato
   da RINOMINA: i CSV di diario si chiameranno `abtg_trades_CLAU12_MaxMinNotte_XAUUSD_<magic>.csv` (`MQL_PROGRAM_NAME`,
   r.835 e r.846).
4. **Due controlli in piu' sull'oro (f2, f3)** perche' la richiesta dice "nessuna posizione XAUUSD e nessun EA oro attaccato"
   e il disco puo' misurare i `.chr` e il giornale, non le posizioni aperte. Il resto lo dichiara `PIATTO`.
5. **`-Conferma PIATTO` invece di `NEUTRA`**: la dichiarazione copre R268/R268d letti, firma, scheda Commercio, sedie oro di
   casa in pausa.

## Uscita 3 e la via d'uscita se MetaEditor non esce

- **Codice 3** (fermato DOPO aver scritto): il file scritto e' stato messo da parte, il Navigatore NON mostra
  `CLAU12_MaxMinNotte`, nessuna sedia toccata. Se compare `RIPRISTINO NON RIUSCITO`: non toccare niente e mandare lo zip.
- **MetaEditor che non termina**: lo script lo aspetta. Se la finestra resta ferma sulla compilazione per piu' di 5 minuti:
  NON chiudere la finestra PowerShell; `Ctrl+Alt+FINE` dentro RDP -> Gestione attivita' -> chiudere SOLO `metaeditor64.exe`,
  MAI `terminal64.exe`. Lo script riprende da solo: nessun log in 20 s = MUTO = ripristino, uscita 3.

## Come si torna indietro (NON e' una riga di lancio)

Si cancellano `CLAU12_MaxMinNotte.mq5` e `CLAU12_MaxMinNotte.ex5` da `MQL5\Experts` di `46C9F8E9...` (nessun grafico li usa
finche' il passo (d) non e' fatto). Se serve, la riga vera si scrive allora e passa dal cancello come tutte le altre.

## Cosa verificare dopo (azione a mano nel terminale FTMO `541452707`, `C:\FTMO`)

1. Navigatore -> Expert Advisors: compare `CLAU12_MaxMinNotte` (se no: tasto destro -> Aggiorna). **Non attaccarlo.**
2. Sonda `CODA_06` delle 03:30: una riga `CLAU12_MaxMinNotte.mq5` con **919** righe (CODA_06 conta UNA riga in piu' dello
   scheletro 918, classe 456) e `.ex5` con la data della corsa.
3. Lo zip sul Desktop: `compila_CLAU12_MaxMinNotte.log` con `Result: 0 errors` (i warning si leggono).

"Finito senza errori di script" non vuol dire "in campo verificato": lo diventa ai punti 1 e 2.

## Collaudo fatto (albero finto, Linux pwsh 7.x, MetaEditor finto, sorgente e include VERI presi da git)

Cartella `scratchpad/ricompila_oro/` (`prova.sh`): copia dello script con SOLO `$PROG` e `$RAWROOT` sostituiti (raw servito
via `file://`). 15 corse: prova a secco `0` (Desktop vuoto) -> esecuzione `0` (`.mq5` scritto con SHA `9346F16A...`, `.ex5`
nato, zip) -> ricorsa `2`; `1 errors` -> `3` e disco senza `.mq5` (solo `.ORO_FALLITO_`); errore che nomina
`ABTG_GuardiaIngresso` -> `3` con la frase sull'include (2 righe); MetaEditor muto -> `3` dopo 20 s; `ABTG_MaxMinNotte.mq5`
presente -> `1`; `.ex5` orfano -> `1`; macchina `DESKTOP-H4D7CAJ` -> `1`; giornale con `deal #... buy 0.10 XAUUSD` -> `1`
(con `-IgnoraGiornaleOro` -> `0`); `<expert>` su grafico XAUUSD nel profilo attivo -> `1` (grafico oro senza EA e residuo in
altro profilo: dichiarati, non bloccano); `-Esegui` senza `-Conferma` -> `1`; pin diverso -> `1`; include v1.6x al posto
della v1.20 -> `1` senza scrivere (usato l'include a HEAD del repo, che E' la v1.6x: 2461 righe, scheletro `E9F503F5...`,
byte SHA `3EC97115...` — quindi "l'include a HEAD" e' proprio quella che g) rifiuta). Riga: parser 0 errori, ASCII, nessun
`&&`/`||`/`??`.

## [NON VERIFICATO]

- **La compilazione vera**: `ABTG_MaxMinNotte.mq5` @`7d0da9f9` (03/09) contro l'include v1.20 (19/08) non e' mai stata
  fatta. La forma c'e' (chiamata a 2 argomenti, firma v1.20 r.282 `(const bool attiva,const string chi="EA",const bool
  pretendi_guardian=false)`, e il sorgente non chiama nient'altro dell'include), il `0 errors` lo dice solo MetaEditor.
- **La posizione XAUUSD aperta** non e' leggibile dal disco (l'`ABTG_TradeExporter` scrive solo deal di storico): f2/f3
  misurano `.chr` e giornale, il resto lo dichiara Claudio dalla scheda Commercio.
- Lo script e' collaudato su Linux (pwsh 7) con un MetaEditor finto, non su Windows PowerShell 5.1 e non con il MetaEditor
  vero. La riga usa `powershell` (5.1) come il modello.
- Il formato delle righe XAUUSD del giornale del terminale (f3) e' preso dai giornali di casa (`CODA_09`), non da un giornale
  FTMO con un deal oro vero: il contro-esempio del collaudo usa la forma `deal #N buy 0.10 XAUUSD at P done`.
- Che il Navigatore mostri il binario nuovo senza riavvio: comportamento noto di MT5, non misurato in casa (se no: Aggiorna).

---
_Cancello: strato 1 (`controlla_riga.py --oggetto ps1` e `--oggetto riga`) rc 0 su script `1277a1aa` e riga; rilievi 457/671
letti a mano = liste di esclusione, non bersagli. Strato 2 (`controllo-preventivo`): **DA FARE** prima di qualunque invio.
IN CODA, NON INVIATA: prerequisito 1 (R268/R268d letti) oggi falso, prerequisito 5 (risposta FTMO cross-account) aperto._
