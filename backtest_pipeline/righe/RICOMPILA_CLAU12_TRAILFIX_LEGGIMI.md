# RICOMPILA_CLAU12_TRAILFIX: la TrailFix in campo sul terminale FTMO

**Stato: IN CODA, NON inviata.** Esce verso Claudio solo con i tre prerequisiti qui sotto e dopo il
cancello (strato 1 + `controllo-preventivo`) sulla riga col pin vero.

- Script: `backtest_pipeline/righe/RICOMPILA_CLAU12_TRAILFIX.ps1` (`MARCATORE_RICOMPILA_CLAU12_TRAILFIX_v1`)
- Riga: `backtest_pipeline/righe/RIGA_RICOMPILA_CLAU12_TRAILFIX_FTMO.txt` (pin = il commit dello script
  qui sopra, SHA256 dello script `E7C11601611A5B0B4B945175D830032A6A5D144B08C06BCB56802AEA3F086723`)
- Sorgenti: `mql5/Experts/trailfix_9fca63d9/CLAU12_*.mq5` al pin `1d68dadd`

## Prerequisiti (tutti e tre, nessuno "per analogia")

1. **R254 NEUTRA su 4/4**: `770101`, `770105`, `770202`, `770260` (`PASSATA_TRAILFIX.ps1`). Il DAX e'
   un solo binario per due sedie: serve NEUTRA su tutte e due.
2. **Firma di Claudio**: si tocca il binario di quattro sedie vive sul conto della challenge.
3. **Sabato o domenica** (ora Windows del VPS). In feriale lo script si ferma; `-ForzaGiorno` esiste
   ma la riga NON lo passa.

## Bersaglio

Finestra PowerShell sul VPS `VMI3047753`. Scrive SOLO nella cartella dati del terminale FTMO
`541452707` (cartella programma `C:\FTMO`, hash `46C9F8E9FF0C747B2B5E09BCC13D5237`), in
`MQL5\Experts`, e sul Desktop del VPS. **Non toccati**: REALE `10105439` (`C:\BCM_Reale`), 100k
`50504263` (`-V3`), piccolo `50503392`, manuale `50503635` (`C:\MT5_MANUALE`), banco `50504400`
(`C:\MT5_Backtest`), Pepperstone, Tickmill.

## Cosa fa

Guardia macchina, cartella FTMO certificata (hash + `origin.txt` = `C:\FTMO` + conto nel giornale),
controllo del giorno, elenco `terminal64` con PID/titolo/percorso, stop se MetaEditor e' aperto,
scarico dei 3 sorgenti al pin con SHA256, impronta "scheletro" dei `CLAU12_*.mq5` in campo (devono
essere il pin `9fca63d9`), include misurato, copie di sicurezza, sorgente nuovo, compilazione con
`C:\FTMO\metaeditor64.exe` (log UTF-16, `0 errors`, `.ex5` datato dopo l'avvio). Se un file fallisce
viene ripristinato dalla sua copia e lo script si ferma. Alla fine lascia sul Desktop la cartella
`RICOMPILA_CLAU12_TRAILFIX_<ora>` (3 log, `ESITO.txt`, 3 sorgenti scaricati) e lo zip.
Uscite: `0` fatto, `1` rifiuto (niente toccato nel terminale), `2` gia' fatto, `3` fermato dopo aver
scritto. La prova a secco non scrive nulla, nemmeno sul Desktop.

## Cosa NON fa

Non tocca preset, taglie, input, magic, profili, Guardian, `CLAU12_EMA200`, `CLAU12_SuperWave`,
`CLAU12_MaxMinNotte`, gli `ABTG_*` rimasti, l'include. Non apre e non chiude terminali, non attacca e
non stacca EA, non tocca Algo Trading, non lancia nessun tester.

## Tre scostamenti dal pacchetto richiesto, con la ragione

1. **Include: si pretende la v1.20, non `3ec97115`.** In campo c'e' `ABTG_PausaGuardian.mqh` al pin
   `26a18566` (v1.20, 398 righe, scheletro `D179846B`), installato da `SCHIERA_FTMO.ps1` il 20/09
   (`report/SCHIERAMENTO_FTMO_2026-09-20.md` par. 5.1). `3ec97115` e' la v1.6x (2461 righe) del pin dei
   sorgenti: e' quella con cui R254 ha compilato. Pretendere `3ec97115` avrebbe fermato la riga sempre;
   trovarla in campo vorrebbe dire due variabili cambiate insieme, quindi STOP.
2. **Copie di sicurezza per COPIA, non per rinomina.** Rinominare il `.ex5` lo toglierebbe da sotto un
   EA attaccato per tutta la compilazione, e cosa faccia MT5 in quel caso non e' misurato in casa.
   Con la copia il binario vecchio resta al suo posto finche' MetaEditor non lo sovrascrive. I nomi
   sono quelli chiesti (`.PRIMA_TRAILFIX_<ora>`), invisibili al Navigatore.
3. **MetaEditor aperto = STOP** (lezione del 22/08: con l'editor aperto `/compile` puo' tornare muto).

## Uscita 3 = STATO MISTO possibile, e la via d'uscita se MetaEditor non esce
- **Codice 3** (fermato DOPO aver scritto): i file compilati PRIMA restano TrailFix, quello che ha fallito e'
  stato RIMESSO dalla sua copia (SHA verificato), quelli DOPO non sono stati toccati. Lo script stampa la
  tavola file per file (`Stato-Finale`) anche in questo ramo e l'ESITO dice `STATO MISTO`. Se compare
  `RIPRISTINO NON RIUSCITO`: non toccare niente e mandare lo zip. Lo stato misto e' accettabile SOLO perche'
  R254 e' NEUTRA su 4/4 (ogni file e' provato da solo); la verifica in Esperti (sotto) va fatta anche con 3,
  per i grafici toccati.
- **MetaEditor che non termina**: lo script lo aspetta (stesso schema di `RIGA_DEPLOY_CONTOREALE.ps1`,
  provato sul VPS il 03/09). Se la finestra resta ferma sulla compilazione per piu' di 5 minuti: NON
  chiudere la finestra PowerShell; Gestione attivita' -> chiudere SOLO `metaeditor64.exe`, MAI
  `terminal64.exe`. Lo script riprende da solo: `.ex5` non fresco = RIPRISTINO di quel file.

## Come si torna indietro (NON e' una riga di lancio)

Per ciascun EA si ricopiano sopra agli originali le due copie della corsa: `<EA>.mq5.PRIMA_TRAILFIX_<ora>`
su `<EA>.mq5` e `<EA>.ex5.PRIMA_TRAILFIX_<ora>` su `<EA>.ex5`, nella stessa `MQL5\Experts`. La copia
del `.ex5` fa ricaricare il binario vecchio, come la compilazione ha fatto ricaricare quello nuovo
[NON VERIFICATO]. Se serve, la riga vera si scrive allora e passa dal cancello come tutte le altre.

## Cosa verificare dopo (azione a mano nel terminale FTMO `541452707`, `C:\FTMO`)

1. Scheda **Esperti**: quattro righe `avviato su` e quattro `CONFIG IN USO` **nuove**, con ora dopo
   quella della compilazione (le due ore sono in ora Windows): due da `CLAU12_DAX_Apertura_EU`
   (`770101`, `770105`), una da `CLAU12_Dow_Apertura_US`, una da `CLAU12_Nasdaq_Apertura_US`.
2. Faccina sui quattro grafici, **Algo Trading verde**.
3. Se una riga manca: tasto destro sul grafico, Expert Advisors, Proprieta', OK. **Mai** "Ripristina",
   mai rimuovere e riattaccare.
4. Sonda `CODA_06` delle 03:30: righe **2475 / 2255 / 2674** (CODA_06 conta UNA riga in piu' dello scheletro 2474 / 2254 / 2673: split senza TrimEnd, classe 456; il DAX in campo, scheletro 2425, esce 2426 nel log del 26/09) e `.ex5` con la data della corsa.
5. Primo giorno di mercato con un trailing: nel giornale le righe `trailing rinviato: stop` al posto
   della raffica `invalid stops`.

"Finito senza errori di script" non vuol dire "in campo verificato": lo diventa ai punti 1 e 4.

## [NON VERIFICATO]

- Che MT5 ricarichi gli EA attaccati quando il `.ex5` cambia: in casa e' scritto come comportamento
  noto (`report/RUNBOOK_RICOMPILAZIONE_PICCOLO_2026-09-14.md` r.268,
  `report/RIMETTERE_IL_CAMPO_IN_PARI_2026-09-12.md` r.271) ma **mai misurato**
  (`report/EXPORTER_SUL_REALE_2026-09-11.md` r.208). Un precedente dice che il terminale "tiene il
  file aperto" e la scrittura "puo' fallire a meta'" (`report/PACCHETTO_SCHIERAMENTO_EMA200_2026-09-13.md`
  r.333): in quel caso il `.ex5` non e' fresco e lo script ripristina. Il punto 1 della verifica serve
  proprio a misurarlo.
- La combinazione `CLAU12@1d68dadd` + include v1.20 non e' mai stata compilata. La Parte A usa solo
  funzioni dell'EA (`ABTGLog`, `NormalizePrice`, `SymbolInfoInteger`, `iTime`), quindi deve compilare
  come il pin il 20/09 [INFERITO].
- R254 misura la neutralita' con l'include v1.6x in entrambi i rami; in campo il binario avra' la v1.20.
  La differenza e' la stessa Parte A, che non chiama l'include: il trasferimento e' [INFERITO].
- Lo script e' collaudato su Linux (pwsh 7) con un MetaEditor finto e un albero simulato, non su
  Windows PowerShell 5.1 e non con il MetaEditor vero.

---
_Cancello: strato 1 OK; strato 2 FAIL (D1 conteggio CODA_06 classe 456; D2 catch esterno senza ripristino, classe 832; D3 via d'uscita MetaEditor; D4 stato MISTO; D5 segnaposto) -> **PASS alla seconda passata** su script `992a1af3` + riga `c03e5dfe`. Rilievi per il messaggio in chat: Ctrl+Alt+FINE dentro RDP; qualunque riga rossa con RIPRISTINO o SHA256 DIVERSO = non toccare niente; "sabato, o domenica entro sera" (i CFD indici riaprono domenica ~23 IT); su C:\FTMO risulta `ABTG_ScalperDirezionale (3).ex5` compilato il 25/09 22:16 (CODA_06): da chiarire con Claudio. IN CODA, NON INVIATA: prerequisito 1 (R254 NEUTRA 4/4) oggi ancora falso._
