# 🌅 PIANO DI DOMANI MATTINA — CHIUDERE IL CRT NEL MIGLIORE DEI MODI

> ✅ **ESEGUITO E CHIUSO IL 31/08 MATTINA.** DIAG vera 08:23 (gate riceve dati
> via D1, 2039 trade), TICK_G vera 08:28: **PF 0.459 = ROSSO, il gate non
> salva a tick nel toro**. CRT parcheggiato con verdetto tick VERO. Verbale
> completo in `risultati_archivio/REFERTO_CRT_2026-08-30.md`. Pivot al Chaos.

_Scritto la notte del 30/08 su richiesta di Claudio: "NON MI ARRENDO CON CRT.
Domani prima chiudo questo EA nel migliore dei modi, poi il resto."_

## DOVE SIAMO (stato al 30/08, 23:45 — tutto misurato)
- Il **gate ADX<=30 e' VALIDATO su OHLC** (+10135, ogni regime positivo, DD 2.6%).
- Il **verdetto TICK manca** per un baco AMBIENTE: il tester tick su NASUSD nativo
  non consegna le barre D1 (ne' via handle iADX/iATR, ne' via CopyRates — provato
  con soglie sempre-vere: 0 trade, gateBlk=2573, due volte, EA fresco).
- Il codice del gate e' CORRETTO (riletto riga per riga). Il muro e' l'ambiente.

## LA MOSSA NOTTURNA (in costruzione mentre Claudio dorme)
**EA v3 del gate: AUTOSUFFICIENTE.** Se il D1 non risponde, l'EA COSTRUISCE le
candele giornaliere aggregando le barre M15 del grafico (che nel tester esistono
SEMPRE, garantito: e' il TF di test). Giorno in corso escluso (no look-ahead).
Stessa scala ADX/ATR, stessa soglia 30. Piu' STRUMENTAZIONE: prime 5 failure
stampate nel Giornale ([CRTTS][GATE-DIAG]: got, GetLastError, via usata) +
contatore OPTFRAME "quale via" (D1 diretto vs fallback M15).
-> Il baco non ha piu' terreno: o passa via D1, o passa via M15. E se fallisse
ancora, il Giornale dice PERCHE' in un test manuale di 5 minuti.

## LA SEQUENZA DI DOMANI (in ordine, PC di backtest)
1. **Io (Claude)**: revisiono la build notturna, committo, gate verificatore,
   pin nuovo, consegno le stringhe. (Se la build e' gia' revisionata e pushata,
   si parte direttamente dal punto 2 con le stringhe che daro'.)
2. **DIAG (ADX<=100, riga RIGA_CRT_TICK_DIAG gia' pronta, solo pin nuovo)**:
   - Se appaiono ~2573 trade -> il fallback FUNZIONA -> punto 3.
   - Se ancora 0 -> test singolo MANUALE in MT5 (tester GUI, NASUSD M15,
     2024.09.26->2026.06.30, Modello tick, EA con gate ON): leggere nel Giornale
     le righe [CRTTS][GATE-DIAG] -> la causa e' scritta li'. Si corregge quella.
3. **GATED TICK vero (ADX<=30, riga RIGA_CRT_TICK_G, solo pin nuovo)**:
   - PF>=1, DD sotto muro, pegg.giornata <5% -> **verdetto tick VERDE** ->
     preparo il preset di deploy sul conto piccolo (come il gated short 770250:
     Guardian ON, taglia ridotta, magic 769100, contratto sedia).
   - PF<1 -> verdetto onesto: il gated nel toro non basta a tick -> il CRT resta
     candidato-chop parcheggiato (Dukascopy quando si vorra'), MA CHIUSO BENE:
     con un verdetto tick vero, non con un baco.
4. **In entrambi i casi il CRT e' CHIUSO nel migliore dei modi** -> pivot ai 5
   motori mai testati. Il primo e' **Chaos Lyapunov: riga GIA' PRONTA e
   gate-passata** (righe/RIGA_CHAOS_DA_MANDARE.md), si lancia subito dopo.

## PROMEMORIA
- Fuso: NASUSD BCM = ora SERVER (flat 21). Le prove TICK_G/TICK_DIAG sono gia'
  giuste e gia' passate dal gate: cambia SOLO il pin (post-build).
- Magic CRT: 769100 (deploy), gemelli test 7691xx. Riservati.
- Il gated short 770250 continua a girare sul conto piccolo: non si tocca.

---

> ⛔ **SUPERATO IL 31/08 MATTINA — NON USARE LE STRINGHE QUI SOTTO.**
> La DIAG delle 06:32 al pin 8d71a3b NON e' mai partita: i wrapper riusavano la
> workdir senza `-Rifai` e il generico saltava le passate servendo CSV stantii
> (generico:615 — classe nuova in CHECKLIST_RIGA_DI_LANCIO.md, correzione
> completa in REFERTO_CRT_2026-08-30.md, sezione "CORREZIONE DEL 31/08").
> I wrapper sono stati corretti (`-Rifai` sempre) → **serve il PIN NUOVO
> post-fix: le stringhe valide sono quelle consegnate in chat il 31/08.**

## AGGIORNAMENTO NOTTURNO (00:05) — BUILD v3 PRONTA, REVISIONATA, PUSHATA

EA v3 committato al pin **8d71a3b16dab3303761811434892b6540c8ebced** (revisione:
ASCII 0, graffe 125=125, CSV 26=26=26, fallback+diag+autotest 12 verificati).
Le righe DIAG e TICK_G sono INVARIATE e gia' gate-approvate: cambia solo il pin.

### STRINGA 1 DI DOMATTINA — DIAG (ADX<=100, risponde "il gate riceve dati?")

PRIMA il giro a vuoto:
```
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='8d71a3b16dab3303761811434892b6540c8ebced'; $p="$env:USERPROFILE\RIGA_CRT_TICK_DIAG.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_CRT_TICK_DIAG.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_CRT_TICK_DIAG_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera.' -ForegroundColor Red } }
```
POI la corsa vera (stesso blocco senza `-SoloControllo`):
```
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='8d71a3b16dab3303761811434892b6540c8ebced'; $p="$env:USERPROFILE\RIGA_CRT_TICK_DIAG.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_CRT_TICK_DIAG.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_CRT_TICK_DIAG_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo' -ForegroundColor Yellow } }
```
LETTURA: nella griglia guardare n (trade) e le colonne "Gate Via D1"/"Gate Via M15".
- n>0 e ViaM15>0 -> il fallback lavora -> STRINGA 2.
- n=0 ancora -> test singolo MANUALE in MT5 e leggere nel Giornale le righe
  [CRTTS][GATE-DIAG] (max 5): dicono got/err/via/minimi = la causa scritta.

### STRINGA 2 DI DOMATTINA — GATED TICK (ADX<=30, il VERDETTO)
Identica alla 1 ma con `RIGA_CRT_TICK_G.ps1` e marcatore `MARCATORE_RIGA_CRT_TICK_G_v1`
(stesso pin 8d71a3b...). Lettura: PF>=1 + DD sotto muro + pegg.gio <5% -> VERDE ->
preset deploy conto piccolo. PF<1 -> chiusura onesta, CRT parcheggiato con verdetto
tick vero, pivot al Chaos (riga gia' pronta).
