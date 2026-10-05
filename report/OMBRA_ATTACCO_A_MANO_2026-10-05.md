# L'ombra EMA200: come si attacca a mano, passo per passo (05/10/2026)

> **Stato: BOZZA PER CLAUDIO, non ancora mandata.** Esce solo dopo il PASS dei cancelli (`verificatore-stringhe` + `controllo-preventivo`).
> Il file dell'EA (`ABTG_EMA200_Ombra.mq5`, v1.03, commit `81b4329f`, SHA256 `FD7AACD694E3...`) **non e' mai stato compilato**:
> la prima compilazione la fai tu, al passo 2, e puo' dare errori. Etichette: [MISURATO] letto da un file/referto · [DERIVATO] conto mio su numeri misurati ·
> [STIMA] ordine di grandezza senza misura · [NON VERIFICATO] vero solo quando gira sul VPS.

## Cosa e' questa cosa, in quattro righe
- L'**ombra** guarda 30 simboli su M15, H1, H4, D1 e **simula** (sulla carta) gli ordini che farebbe `EMA200`. **Non manda nessun ordine, non legge ne' tocca le sedie, non parla col Guardian.**
  Unico effetto: scrive file in `MQL5\Files\ABTG_Ombra\` e righe nella scheda Esperti.
- Perche' serve: misura **dove funziona** il motore (rischio e frequenza prima, merito dopo; vedi `report/EA_EMA200_OMBRA_2026-10-05.md`).
- Dove: **solo il terminale demo piccolo 50503392**. Scelta tua. Il tuo EA non compra niente: l'unica convivenza e' di CPU e RAM con le sedie.
- Regola di casa: **si ferma chiudendo il SUO grafico, mai col bottone Algo Trading** (passo 6).

## 🎯 Bersaglio: dove si fa ogni cosa (leggilo prima di toccare)
| Passo | Dove | Cosa NON si tocca |
|---|---|---|
| **1. Installare il file** (la riga ti arriva in chat dopo i cancelli) | 🖥️ **finestra PowerShell sul VPS `VMI3047753`** (NON sul PC di backtest `DESKTOP-H4D7CAJ`: li esiste un terminale con lo STESSO conto 50503392 e la riga si ferma da sola). La riga **copia un solo file** e non apre ne' chiude nulla. | REALE `10105439` (`C:\BCM_Reale`), FTMO `1514806751` (`C:\FTMO`), 100k `50504263` (`... MT5 Terminal -V3`), manuale `50503635` (`C:\MT5_MANUALE`), banco `50504400` (`C:\MT5_Backtest`), Pepperstone, Tickmill |
| **2-6. Compilare, attaccare, guardare, fermare** | 🪟 **terminale MT5 `50503392`**, cartella programma `C:\Program Files\BCM Markets MT5 Terminal` | stessa lista; e dentro il 50503392 **nessuna sedia**: solo un grafico NUOVO |
| **Riconoscere il terminale** | ✋ lo fai con un **fatto stampato**, non a occhio: il PID e la cartella che stampa la riga d'installazione (passo 0) | non riconoscere mai la finestra dal titolo |

Se un giorno devi rileggere i PID senza rilanciare la riga d'installazione, questa e' di **sola lettura** (🖥️ finestra PowerShell sul VPS `VMI3047753`, non tocca nessun terminale):

```powershell
Get-Process terminal64 | select Id, MainWindowTitle, Path
```

## Passo 0 -- riconoscere il terminale giusto (2 minuti, tutto dal referto)
Dopo la riga d'installazione trovi sul **Desktop del VPS** `ABTG_OMBRA_INSTALL_<ora>.txt` e lo `.zip` (mandami lo zip). Nel referto cerca:
1. `ESITO OMBRA INSTALL: INSTALLATO` (oppure `GIA PRESENTE UGUALE`). Se dice `FERMATO` **non si va avanti**: mi mandi lo zip e basta, non e' stato scritto niente.
2. `CARTELLA DATI SCELTA: ...` e il **nome della cartella** (l'ultima misura, 29/09 e 05/10, e' `215D85D767A1C39E22D242C8114BF9F5` per il 50503392 [MISURATO]; se il referto dice un'altra, ti fermi).
3. `PID del terminal64 del piccolo da guardare nella Gestione attivita ...: <numero>`. **Scrivilo**: serve al passo 5.
4. I numeri di **partenza** (la foto "prima", servono per le soglie del passo 5): RAM libera del VPS, working set e CPU del terminal64 del piccolo, numero di sedie.

Prova incrociata (fatto, non occhio): **nel terminale 50503392** menu **File > Apri cartella dati**. Il nome della cartella che si apre deve essere **uguale** a quello del referto, e in `MQL5\Experts\` deve esserci `ABTG_EMA200_Ombra.mq5`. Se il nome e' diverso: stop, screenshot, non attaccare niente.
Seconda prova: Gestione attivita' > scheda **Dettagli** > riga con quel PID > tasto destro > **Apri percorso file**: deve aprirsi `C:\Program Files\BCM Markets MT5 Terminal`.

## Passo 1 -- quando farlo
In un momento **tranquillo**: evita i dieci minuti attorno alle aperture (09:00 e 15:30 ora italiana) e quando sai che una sedia sta per aprire. Il peso e' alto solo all'avvio (calcolo iniziale degli indicatori: secondi di un core, una volta [STIMA]).
Nota onesta: nel 50503392 ci sono 26 sedie con orari diversi [MISURATO, CODA_01 del 05/10], quindi un'ora "senza nessuna apertura" non e' garantita: l'ho scelta tranquilla, non sicura.

## Passo 2 -- compilare (🪟 terminale 50503392)
1. Nel terminale **50503392** premi **F4**: si apre MetaEditor *di quel terminale*.
2. Pannello **Navigatore** (Ctrl+D) > **Experts**: se non vedi `ABTG_EMA200_Ombra.mq5`, tasto destro su `Experts` > **Aggiorna**. (MetaEditor gia' aperto prima della copia non vede il file nuovo: e' normale.)
3. Doppio clic sul file, poi **F7**.
4. In basso, scheda **Errori**: l'ultima riga dice `Risultato: N errori, M avvisi` (in inglese `Result: ...`). **Riportami quella riga e le righe di ogni avviso**.
   - **0 errori** -> avanti.
   - **1 o piu' errori** -> **fermo qui**: NON modificare il file a mano, NON attaccarlo. Screenshot della scheda Errori e mi fermi. (E' la prima compilazione in assoluto: un errore e' possibile e non e' un dramma, e' proprio il motivo del passo.)
5. F7 crea `ABTG_EMA200_Ombra.ex5` accanto al `.mq5`: e' l'unico file nuovo, ed e' normale.

## Passo 3 -- attaccarla (🪟 terminale 50503392)
1. **File > Nuovo grafico > EURUSD** (qualunque simbolo, l'ombra non guarda quello del grafico: lavora a timer su tutti e 30). Metti **H1**.
2. Controlla che sia **davvero nuovo**: nessun nome di EA in alto a destra, nessuna faccina. 🔴 **MAI su un grafico che ha gia' un EA**: in MT5 un grafico ospita **un solo** EA, e trascinarne un secondo **sostituisce la sedia**.
3. **Navigatore (Ctrl+N) > Expert Advisors > `ABTG_EMA200_Ombra`** (se non c'e': tasto destro > Aggiorna) e **trascinalo su quel grafico nuovo**.
4. Nella finestra che si apre lascia **tutto di default** e premi OK. (Tab "Input": non cambiare niente. In particolare `InpAggiungiMW` resta **false**: e' l'unica manopola che toccherebbe il terminale, aggiungendo simboli al Market Watch.)
5. **Algo Trading e' gia' verde per le sedie: lascialo com'e'.** All'ombra non serve, e spegnerlo fermerebbe le sedie, non lei.
6. Nota: il grafico entra nel **profilo ORO** del 50503392. Dal primo salvataggio del profilo CODA_01 contera' **27** "sedie" invece di 26: **la 27a e' l'ombra, non una sedia**. Lo segno io nei report.

## Passo 4 -- cosa devi vedere (nei primi 2 minuti)
**Scheda Esperti** (Ctrl+T > Esperti; l'ora qui e' **ora locale del PC**, non ora grafico):
- `[OMBRA] AVVIO v1.03: N simboli x 4 TF = M slot; handle ...` -- N e' al massimo 30 e M = N x 4.
- `[OMBRA] simboli SALTATI: ...` -- se compare, **riportami l'elenco**: e' un'informazione (simboli non nel Market Watch di questo terminale), non un errore. **Non accendere `InpAggiungiMW` per rimediare.**
- `[OMBRA] modalita' OMBRA: nessun ordine, sola simulazione; ...`
- 🔴 Se leggi `nessun simbolo utilizzabile` o `nessun TF d'ingresso acceso`, o se **non compare nessuna riga [OMBRA]**: l'ombra non sta lavorando. Screenshot e chiudi il suo grafico (passo 6).

**File** (File > Apri cartella dati > `MQL5\Files\ABTG_Ombra\`):
- `ombra_battito.txt` si aggiorna **ogni 60 secondi**. Riaprilo dopo un minuto: `ora_server` e `ora_locale` devono essere cambiate e `giri` salito (circa 60 al minuto [DERIVATO: timer a 1 s]). Apri i file **in sola lettura** (Blocco note) e **non salvarli**; per i CSV non usare Excel dal vivo: copiali prima.
- Campi che guarderemo: `setup_attivi`, `giro_ultimo_ms` e `giro_massimo_ms` (sul VPS devono essere piccoli, pochi ms [STIMA]; il tetto per fase e' 150 ms), `giri_oltre_tetto`, `righe_in_coda` (deve restare ~0).
- `ombra_log.txt`: le stesse righe di Esperti, ma restano.

## Passo 5 -- la prima ora (🖥️ Gestione attivita' sul VPS, guardando il PID del referto)
Gestione attivita' > scheda **Dettagli**, riga con **il PID del passo 0** (non un altro `terminal64.exe`: ce ne sono sei e non si distinguono a occhio). Colonne: **CPU** e **Working set (memoria)**. Se manca, tasto destro sull'intestazione > Seleziona colonne.
🔴 **Non usare la colonna "Memoria (working set privato)"**: e' un'altra misura, piu' bassa, e confonderebbe il confronto col referto (che misura il working set totale).
Controlli a **minuto 2, 10, 30 e 60** (poi un colpo d'occhio la sera e uno la mattina dopo). Per la RAM libera del VPS: **Monitoraggio risorse > Memoria**, voce **Libera** (non "Disponibile": e' un altro numero, piu' grande). [NON VERIFICATO: il nome esatto della voce su questo Windows.] Se non la trovi, la leggo io dal referto delle 03:30 (`CODA_04`).

### Le soglie, scritte PRIMA di attaccare (proposta: le puoi cambiare tu, prima di partire, non dopo aver visto i numeri)
Tutte rispetto al valore **"prima"** del referto della riga d'installazione. Sono le stesse che la riga stampa nella sezione 5 del referto.

| Cosa | Dove si legge | GIALLO (guarda ogni 10 minuti e dimmelo) | ROSSO (chiudi il grafico dell'ombra + screenshot) |
|---|---|---|---|
| **RAM** del `terminal64` del 50503392 (working set) | Dettagli, PID del passo 0 | **prima + 500 MB** (e' gia' oltre la stima peggiore del documento: 200-500 MB [STIMA]) | **prima + 800 MB** |
| **RAM libera del VPS** | Monitoraggio risorse, "Libera" | -- | sotto **max(1024 MB; prima - 800 MB)** |
| **CPU** del `terminal64` | Dettagli, PID del passo 0 | -- | **prima + 5,0 punti percentuali** (= 30% di UN core su 6: e' il tetto dichiarato dall'EA) **per 5 minuti di fila, contando dal minuto 10** (i primi 10 minuti sono il calcolo iniziale: un picco una tantum e' atteso) |
| **Giro dell'EA** | `ombra_battito.txt`, `giro_ultimo_ms` | -- | **oltre 1000 ms in due battiti di fila**, dal minuto 10 |

- **Durata**: il picco e' ammesso **solo nei primi 10 minuti**. Dal minuto 10 valgono i tetti sopra. Se a minuto 60 il working set e' ancora sopra "prima + 500 MB", il giallo resta giallo: me lo scrivi, non lo lasci stare.
- **Contesto, per non spaventarsi e per non illudersi**: il 05/10 alle 03:30 la RAM libera del VPS era **1,81 GB su 12 GB** [MISURATO, CODA_04]. Con 200-500 MB in piu' restano 1,3-1,6 GB: sopra il pavimento di 1024 MB, ma **con poco margine**. Se la riga d'installazione scrive `la RAM libera e GIA sotto il pavimento`, **non si attacca**.
- Il carico dell'ombra e' una **STIMA** (nessuno l'ha mai misurato girare): i numeri veri li da' la prima ora.

## Passo 6 -- come si ferma (🪟 terminale 50503392)
- **Chiudi SOLO il grafico dell'ombra** (la X sulla sua linguetta), oppure tasto destro sul grafico > Expert Advisors > Rimuovi.
- 🔴 **MAI il bottone Algo Trading**: spegnerebbe le **sedie** di quel terminale e **non fermerebbe l'ombra** (un EA senza ordini gira a timer anche con Algo Trading spento).
- Lo stato si salva da solo alla chiusura; un riavvio la riprende senza doppioni. I file in `MQL5\Files\ABTG_Ombra\` restano: non vanno cancellati.
- Chiudere il grafico toglie l'ombra anche dal profilo ORO al prossimo salvataggio: dopo un riavvio di MT5 non torna.
- In ogni dubbio: **chiudi il grafico e mandami lo screenshot**. Nessuna sedia ne soffre.

## La regola e la riserva (una riga neutra ciascuna)
- **Regola**: il terminale lo sceglie Claudio. Ha scelto il **50503392**.
- **Riserva dell'agente, scritta una volta**: l'alternativa che l'agente aveva consigliato era il 100k `50504263` (2 sedie): sul 50503392 (26 sedie) la RAM dell'ombra sta **nello stesso processo `terminal64`** delle sedie. Per questo le soglie del passo 5 sono scritte prima, e il ROSSO e' una chiusura di un grafico, non una discussione.

## Cosa NON e' coperto da nessun collaudo (dichiarato)
- **La compilazione**: mai fatta. La prima e' la tua, al passo 2.
- **Il carico vero** (CPU, RAM, attese di `CopyTicksRange` dopo un riavvio): [STIMA], mai misurato su MT5 vivo.
- **La riga d'installazione**: provata su un VPS **finto** (53 scenari, 56 mutazioni prese) in PowerShell 7 su Linux; **non provata** su Windows PowerShell 5.1 e su un Windows vero (permessi, `Get-Process` che nega il percorso, `Compress-Archive`).
- **Il nome esatto delle voci** di Windows italiano (Gestione attivita', Monitoraggio risorse) e di MetaEditor.
