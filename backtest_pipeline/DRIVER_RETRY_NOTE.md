# Driver con la riprova (`walkforward_generico_RETRY.ps1`) — nota d'uso

**Data:** 01/10/2026. **Mandato:** Claudio, *"SI COSTRUISCI IL RETRY NEL DRIVER"*.
**Contesto misurato:** `report/R92BAB_LETTURA_2026-10-01.md`. Sul PC di backtest DESKTOP-H4D7CAJ il tester ogni tanto
muore in `OnTesterInit`: 5 righe `OnTesterInit works too long...` a circa 15,5 s l'una dall'altra, poi
`OnTesterInit works too long. Tester cannot be initialized.`. In R92BAB sono morte 2 gambe su 12, anche con un EA a un
solo simbolo. Il driver di oggi non riprova mai.

## I file

| file | cos'e' |
|---|---|
| `backtest_pipeline/walkforward_generico_RETRY.ps1` | **copia** del driver con la riprova (marcatore `MARCATORE_WALKFORWARD_GENERICO_v7_RETRY`) |
| `backtest_pipeline/righe/RIGA_ROUND_VPS_RETRY.ps1` | **copia** della riga dei round che scarica e lancia la copia qui sopra (marcatore `MARCATORE_RIGA_ROUND_VPS_RETRY_v1`) |
| `backtest_pipeline/collaudo_driver_RETRY/` | il collaudo: `run.sh`, `battery.py`, `giornali_veri.py`, `harness.py`, stub del terminale e del compilatore, shim di `powershell.exe` |

🔴 **Dove sta la riga:** il mandato diceva `backtest_pipeline/RIGA_ROUND_VPS_RETRY.ps1`, ma l'originale sta in
`backtest_pipeline/righe/`. La copia sta **accanto all'originale**, in `righe/`, cosi' l'URL di download ha la stessa forma.

🔴 **Gli originali NON cambiano di un byte.** `walkforward_generico.ps1` resta con SHA256 `6EFF8E40...0E027A1` e
`righe/RIGA_ROUND_VPS.ps1` con SHA256 `3341756F...B4DD3425` (lo controlla la batteria, scenario `originali`). Le righe
gia' consegnate (R92BAB, DAXAP02 in costruzione) controllano dopo ogni job lo SHA del driver nella cartella di lavoro
(classi 166/892): **continuano a funzionare come prima e NON usano la riprova.**

## Cosa cambia (driver)

1. **Tre parametri nuovi.**
   - `-MaxRiprove` (default `1`): `0` = nessuna riprova, come l'originale; un valore maggiore di `1` viene **rifiutato** (al massimo una riprova per gamba).
   - `-RiprovaEntro "aaaa-MM-gg HH:mm:ss"` (ora del PC): dopo questa scadenza la riprova non parte e la gamba resta morta, ed e' scritto.
   - `-AttesaRiprovaSec` (default `20`, valori ammessi da 5 a 300): quanto si aspetta fra i due tentativi.
2. **Dopo ogni lancio del terminale il driver legge il giornale del tester**, cioe' `<cartella dati>\Tester\logs\AAAAMMGG.log`
   (UTF-16, letto in condivisione senza bloccare il file). Del giornale tiene **solo** le righe con l'ora compresa fra
   l'avvio di quel tentativo e la sua fine (al millisecondo, con la data presa dal nome del file e la mezzanotte gestita:
   classe 940). Le righe di corse precedenti si contano e si ignorano. Gli esiti possibili sono cinque:
   - `PARTITA`: c'e' la riga `Experts\<EA>.ex5 on SIM,TF from .. to ..`. La finestra girata si confronta con quella
     dichiarata (classe 992).
   - `MORTA_INIT`: c'e' la riga fatale **con la causa sulla stessa riga** e non c'e' nessuna riga `from .. to ..`.
   - `MORTA_ALTRO`: c'e' `Tester cannot be initialized` ma **senza** `OnTesterInit works too long` sulla stessa riga.
   - `NON_VERIFICABILE`: il giornale manca, non ha righe nella finestra, oppure c'e' l'intestazione ma la fine non si legge.
   - `ANOMALA`: due intestazioni nello stesso tentativo, un EA diverso nell'intestazione, oppure la gamba risulta partita e morta insieme.
3. **La gamba si riprova una volta sola, e solo se valgono tutte queste condizioni:** esito `MORTA_INIT`, nessun CSV
   prodotto da quel tentativo, `-MaxRiprove 1`, scadenza non superata, e nessun `terminal64` di questa installazione
   ancora vivo. Il driver **controlla soltanto**: non chiude nessun processo. La riprova rilancia **lo stesso `.ini`**,
   quindi con gli stessi input e la stessa finestra.
4. **Alla fine il driver scrive `risultati_prove\<EA>\RIPROVE_<EA>_<SIM><suffisso>.txt`** (ASCII). Per ogni gamba
   contiene `tentativo 1 -> esito`, `tentativo 2 -> esito`, la parola `RIPROVATA` e `ESITO GAMBA: CSV PRODOTTO [AL TENTATIVO 2]`
   oppure `CSV NON PRODOTTO`. L'ultima riga e' `RIPROVATE : n (IS,OOS)`. Il file si scrive sempre, anche con `-MaxRiprove 0`.

**Gli errori che NON si riprovano mai:** EA, compilazione, `.ini`, dati mancanti. Compilazione e controlli dell'`.ini`
fermano il driver (`Muori`) prima che parta il terminale (scenario D3f). Un errore di storico lascia nel giornale
un'intestazione senza fine leggibile, quindi l'esito e' `NON_VERIFICABILE` (D3b). `OnTesterInit` che restituisce un
errore e' un difetto dell'EA, quindi `MORTA_ALTRO` (D3a).

## Cosa NON cambia

- **`Tester\cache` non si svuota e non si tocca, mai.** Il driver originale non lo faceva e la copia non comincia
  adesso. Nel giornale di R92BAB, le 10 gambe partite hanno sempre la riga `N new records saved to cache file
  'tester\cache\...opt'`, mentre le **2 gambe morte non ce l'hanno**. La morte in `OnTesterInit` arriva prima
  dell'ottimizzazione, quindi non c'e' niente da salvare in cache. Il driver riscrive per ogni tentativo se il giornale
  ha quella riga (`cache: ...`).
  🔴 Questo dato viene dal giornale. La cartella `Tester\cache` non e' stata elencata: `[NON MISURATO]` sul disco.
- La guardia per macchina, il blocco `GUARDIA_BANCO_POSITIVA_v2` (identico nelle cinque copie: `banco_guardia_macchina.ps1`
  con `-Files` sui cinque file da' 195/195), il terminale, i download (gli stessi dell'originale: nessuna rete nuova),
  gli `.ini`, i nomi dei CSV, i codici d'uscita.
- La riga conserva `-ChiudiBacktest`, **lo stesso identico** dell'originale. Nessuna chiusura di processi e' stata aggiunta.

## Cosa cambia (riga)

`RIGA_ROUND_VPS_RETRY.ps1` scarica `walkforward_generico_RETRY.ps1` (il nome e' scritto in un solo punto, `$NOME_DRV`)
e controlla due marcatori: **`v7_RETRY`** e `v5_INCLUDE`. Il controllo sul solo `v5` non basterebbe: il driver
originale salvato con il nome RETRY passerebbe lo stesso (scenario R6, vedi la classe 1028).

La riga passa al driver `-MaxRiprove`, `-AttesaRiprovaSec` e `-RiprovaEntro`. Quest'ultimo contiene uno spazio, quindi
passa per `CitaArg` (classe 540). Prima di lanciare cancella il file `RIPROVE_...` vecchio, poi lo legge solo se e' fresco:
- ogni gamba `RIPROVATA` diventa un **RILIEVO**, quindi il round esce `ROUND GIRATO CON RILIEVI` (codice 3): la gamba
  conta come partita, ma resta visibile;
- se il file manca, anche questo e' un RILIEVO.

Il file finisce nel referto (sezione `RIPROVE DEL DRIVER`) e nello zip.

## Come si usa da una riga NUOVA (le righe consegnate prima NON la usano)

1. Scaricare `backtest_pipeline/righe/RIGA_ROUND_VPS_RETRY.ps1` dal pin. Controllare il marcatore
   `MARCATORE_RIGA_ROUND_VPS_RETRY_v1` e lo **SHA256 al pin** di questo file (non quello di `RIGA_ROUND_VPS.ps1`).
   **E le passa `-Pin <commit>`** (classe 164), come R92BAB fa con l'originale (`-Pin $PIN`): il default dello script
   e' il branch `lavoro`, e senza `-Pin` il driver si scaricherebbe dalla testa del branch (lo fermerebbe solo il
   controllo SHA del punto 2). Aggiunto dal cancello indipendente del 01/10.
2. **Classi 166/892:** dopo ogni job, nella cartella di lavoro si controlla lo SHA256 di
   **`walkforward_generico_RETRY.ps1`** contro il pin. Il file `walkforward_generico.ps1` che sta nella stessa cartella
   e' quello delle righe vecchie: non va confuso con questo.
3. **Tetto di tempo:** il tetto resta quello della riga e si controlla fra un job e l'altro, come oggi. Pero' una
   riprova allunga il job dall'interno (R92BAB: un job con una gamba morta e' durato 163-196 s, contro 68-95 s; a questo si
   aggiungono l'attesa e un altro giro). La riga deve passare `-RiprovaEntro` uguale a `T0 + TETTO`, in ora del PC e nel
   formato `aaaa-MM-gg HH:mm:ss`. Oltre il tetto la riprova non parte; i job non ancora iniziati restano `NON LANCIATO`, come oggi.
   🔴 **Ma la scadenza si controlla all'AVVIO della riprova, non alla sua fine** (classe 1038, trovato dal cancello
   indipendente del 01/10): il controllo cade subito dopo il tentativo morto, poi ci sono l'attesa (20 s) e un giro
   intero della gamba. Una riprova decisa a `T0 + TETTO - 1 s` finisce dopo il tetto, di **al massimo attesa + una gamba
   intera** (R92BAB: una gamba morta ~95-125 s, una viva 30-60 s su OHLC; a tick reali con molte celle una gamba puo'
   durare decine di minuti). Se il tetto deve essere RIGIDO, la riga passa `T0 + TETTO - (attesa + durata massima
   attesa di una gamba)` e lo dichiara.
4. **Classificazione OK/KO/MISTO:** un job con una gamba riprovata ha nel giornale del tester **3 gambe, non 2**. Un
   classificatore come quello di R92BAB (`$nLg -ne 2` porta a NV) lo leggerebbe come NV. La riga nuova deve leggere il
   file `RIPROVE_...` del job, oppure contare i tentativi per gamba (classe 1030).
5. Per una replica pulita serve sempre lo stesso ragionamento: magic nuovi, oppure la cache svuotata (**scelta di Claudio**).

## Collaudo (`bash backtest_pipeline/collaudo_driver_RETRY/run.sh`)

- `controlla_riga.py --ps1` sui due file: ASCII puro, **0 errori dal parser PowerShell vero** (pwsh 7.4), nessun
  costrutto solo-pwsh-7, cultura invariante. I rilievi `[457]` sono le stesse stringhe dei conti dell'originale (liste
  dei terminali vietati). C'e' anche la riga `Stop-Process` di `-ChiudiBacktest`, che era gia' nell'originale.
- `banco_guardia_macchina.ps1` su 5 copie: impronte identiche, 195/195.
- `giornali_veri.py`, **26/26**: le funzioni della riprova estratte dal driver ed eseguite sui giornali veri
  (R92BAB 01/10: P IS morta, P OOS partita, C OOS morta, la gamba dopo C partita con 166 righe di prima ignorate,
  il round intero in una sola finestra = ANOMALA; R92B 30/09: due morte; RFWD 30/09: la sera partita con 4 gambe morte
  la mattina ignorate). Coperti anche mezzanotte (due file), riga quasi uguale (`MORTA_ALTRO`) e tutta la tabella di
  `DecidiRiprova`.
- `battery.py`: driver vero con terminale finto, e riga vera con driver vero e terminale finto. Scenari: morta e poi
  viva; morta due volte; causa diversa, errore di storico, terminale muto, morta con CSV, EA diverso, compilazione
  fallita; due gambe morte nello stesso job; giornale sporco di una corsa precedente (con la gamba di adesso viva e con
  la gamba di adesso muta); `-MaxRiprove 0`; `-MaxRiprove 2` rifiutato; scadenza passata, malformata e futura;
  attesa fuori campo; finestra diversa (classe 992). Per la riga: R1-R7, cioe' codice 3 con RILIEVO, codice 0,
  codice 2, rifiuto al pre-volo, scadenza con lo spazio che arriva intera, driver senza il marcatore v7, file RIPROVE
  assente.

**Esiti del 01/10/2026 (`run.sh`, pwsh 7.4.6 su Linux):** `controlla_riga` rc 0 su tutti e due i file (0 bloccanti,
parser vero 0 errori); guardia 195/195 su 5 copie; giornali **26/26**; batteria **147 controlli passati, 0 falliti**.
**Rifatto dal cancello indipendente (01/10 sera), dopo le sue correzioni:** controlla_riga rc 0 x2, guardia 195/195,
giornali **27/27** (caso `MISTA` aggiunto), batteria **147/147**.
**Contro-esempio sui test stessi:** tre mutazioni del codice nuovo, fatte apposta, sono state prese tutte e tre da
`giornali_veri.py`:
- fatale senza causa letta come `MORTA_INIT`: il test va a 25/26;
- limite basso della finestra tolto: 4 casi R92BAB diventano `ANOMALA`;
- tetto di una riprova tolto: `DecidiRiprova` al tentativo 2 risponde "si'".

## Cosa NON e' coperto (dichiarato, per il cancello indipendente)

1. **Windows PowerShell 5.1 non e' stato eseguito.** Tutto gira su pwsh 7.4 su Linux. La compatibilita' con la 5.1
   l'ha controllata solo `controlla_riga.py` (costrutti, parser). `FileStream` con `FileShare.ReadWrite`, `StreamReader`
   con `Encoding.Unicode`, `TryParseExact` e `[pscustomobject]` esistono in .NET 4 / PS 5.1, ma **non e' misurato**.
2. **MT5 vero: mai.** Il terminale e' uno stub che scrive righe nel formato di quelle vere, copiato dai giornali
   archiviati. Il percorso del giornale `<cartella dati>\Tester\logs\` e' dedotto dal nome dei file raccolti da R92BAB
   (`0002_Tester_logs_20261001.log`, raccolti sotto `%APPDATA%\MetaQuotes`) e dalla riga di cache relativa
   `tester\cache\...`. Se fosse sbagliato, **la riprova non partirebbe mai** (giornale `NON_VERIFICABILE`, scritto nel
   file RIPROVE con il percorso cercato): si fallisce al comportamento di oggi, non oltre. Alla prima corsa vera va
   letto il file RIPROVE.
3. **Il determinismo del secondo tentativo** si assume (stessi input, stessa finestra, stesso `.ini`) ma non e'
   misurato qui. Il confronto fra la gamba riprovata e una gemella partita al primo colpo resta da fare su un round vero.
4. **Ora legale:** nella notte del cambio d'ora (25/10) l'ora locale 02:00-03:00 si ripete. Un tentativo a cavallo di
   quell'ora potrebbe prendere righe dell'ora "gemella". Non e' coperto.
5. **Un CSV di sola intestazione lasciato da una gamba morta** porterebbe a "contraddizione, non si riprova". In R92BAB
   le gambe morte non hanno lasciato nessun CSV (misurato: C ha solo il CSV IS). Se MT5 un giorno lo lasciasse, la
   riprova non partirebbe, che e' il comportamento sicuro.
6. **Il banco su Linux usa due cartelle dati** (`DRV000` e `RIGA000`), perche' `Join-Path` scrive `/` e il driver
   confronta `origin.txt` con il percorso del terminale. Sul PC vero e' una cartella sola. `-ChiudiBacktest` e
   `Get-Process` non sono collaudati: su Linux non ci sono processi `terminal64`.
7. **Le righe di lancio che useranno questa copia non esistono ancora** (il mandato dice di non scriverne). Sono da
   collaudare quando nasceranno: punti 1-4 della sezione "Come si usa".

## Cancello indipendente del 01/10/2026 (sera) -- cosa ha aggiunto

- **Percorso del giornale: confermato, non piu' solo dedotto.** `risultati_archivio/REFERTO_DRIVER_R109_20260825.txt`
  riporta il percorso assoluto sul PC di backtest:
  `C:\Users\Master\AppData\Roaming\MetaQuotes\Terminal\215D85D767A1C39E22D242C8114BF9F5\Tester\logs\20260825.log`;
  e il raccoglitore di R92BAB nomina i file `<nonno>_<padre>_<file>`, quindi `0002_Tester_logs_20261001.log` = `...\Tester\logs\20261001.log`.
- **Nome del file = data LOCALE del PC.** `ROUND_R92B_2026-09-30/LOG_TESTER/0000_..._logs_20260930.log` comincia alle
  `00:20:29` e `0001_MQL5_logs_20260930.log` alle `00:03:58`: con un nome in ora UTC quelle righe starebbero nel file del 29/09.
- **Ora legale (punto 4 qui sopra), il conto dei due versi.** Il caso pericoloso e' uno solo: dopo il ritorno all'ora
  solare, un tentativo MUTO (nessuna riga sua) nell'ora ripetuta, con nel giornale le righe di una gamba dello STESSO EA
  morta nella prima 02:xx. Il cancello lo ha costruito (`CE8`): esce `MORTA_INIT` e la gamba si riprova **una volta in
  piu' del dovuto**, con lo stesso `.ini` (costo: un giro; nessun dato sbagliato, il CSV resta l'unica prova della gamba).
  Un tentativo a cavallo del cambio ha la finestra rovesciata (fine prima dell'avvio): zero righe, `NON_VERIFICABILE`,
  nessuna riprova. Anche `-RiprovaEntro` e' in ora locale "nuda": nell'ora ripetuta la scadenza si allunga di un'ora.
  Che il PC di backtest applichi l'ora legale **non e' misurato** (MT5 scrive `GMT+1` all'avvio, il 01/10).
- **Un EA con un `OnTesterInit` davvero lento** scrive la STESSA firma della morte misurata: il giornale non li
  distingue, quindi quella gamba verrebbe riprovata una volta (e morirebbe di nuovo). Costo limitato a un giro; in
  R92BAB/R92B/RFWD l'EA morto (`ABTG_Bulge`, r.2162: `int OnTesterInit() { return(INIT_SUCCEEDED); }`) torna subito,
  quindi la morte misurata e' dell'ambiente, non dell'EA.
- **Cache, contato sui giornali veri:** R92BAB 12 intestazioni, 10 partite tutte con `saved to cache file`, 2 morte
  senza; R92B 2 morte senza; RFWD 18 intestazioni, 14 partite tutte con la riga, 4 morte senza.
- **`-MaxRiprove 0` contro l'ORIGINALE, stesso terminale finto:** tre scenari (morta+viva, tutto vivo, causa diversa +
  morta): codice d'uscita, numero di lanci e SHA dei CSV **identici**; l'unica differenza e' il file `RIPROVE_` in piu'.
- **Mutazione non presa dal collaudo, ora presa:** invertire la precedenza fra `MORTA_ALTRO` e `MORTA_INIT` (una fatale
  con la causa E una senza nello stesso tentativo) restava verde su 26/26 e su D3. Aggiunto il caso `MISTA` a
  `giornali_veri.py` (classe 1033: ogni controllo ha uno scenario in cui e' il solo a scattare).
