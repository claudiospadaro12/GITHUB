# 📬 SONDA RSI+EMA V8 — **PASSO 0: LA RIGA DA MANDARE** (la porta di rientro si esercita coi NUMERI)

**Che cos'è:** il primo giro della **sonda di conteggio `ABTG_SondaRsiEmaV8`**
(EA **NUOVO, MAI COMPILATO** — la compilazione avviene qui e **se fallisce,
QUELLO è il risultato del passo**). È un **CONTATORE PURO**: zero ordini, zero
lotti, zero magic — la riga lo **prova a macchina** (grep delle chiamate di
trading fuori dai commenti, attese **0**) prima di aprire MT5. Motore contato:
**RSI + EMA Crossover Signals V8** (pending su incrocio RSI(14)/SMA(RSI,14) +
innesco su incrocio EMA(5)/EMA(20), su barra chiusa — Pine v6 di 52 righe,
**autore IGNOTO, licenza IGNOTA**, incollato in chat da Claudio 01–02/09: uso
**interno di misura** e basta, attribuzione completa in testa al `.mq5`).
È l'**esercizio della porta di rientro** scritta nella scheda del verdetto di
carta del 31/08 (`SCHEDA_RSIEMA_V8_2026-08-31.md`, NON PROMOSSO): qui il
candidato ha il diritto di essere ucciso **dai numeri**, non dall'analogia coi
suoi parenti morti — chiesto da Claudio **esplicitamente e due volte**.

**SETTE CORSE in sequenza** — lo **stampo M0PB** (3 indici × M5/M15, banco
IDENTICO alla corsa del 31/08, morta 12/12) **+ una corsa ORO dichiarata**,
finestra 2024.09.26 → 2026.06.30, **MODELLO 2 "Solo prezzi di apertura"**
(il segnale nasce su barra chiusa e non si apre niente):

| Corsa | Simbolo | TF | File prova |
|---|---|---|---|
| `U30_M5` | U30USD | M5 | `prove/RSIEMAV8_FREQUENZA_M5.txt` |
| `U30_M15` | U30USD | M15 | `prove/RSIEMAV8_FREQUENZA_M15.txt` |
| `NAS_M5` | NASUSD | M5 | (stesso prova M5, `-Simbolo` override) |
| `NAS_M15` | NASUSD | M15 | (stesso prova M15, `-Simbolo` override) |
| `DAX_M5` | D30EUR | M5 | (stesso prova M5, `-Simbolo` override) |
| `DAX_M15` | D30EUR | M15 | (stesso prova M15, `-Simbolo` override) |
| `ORO_M15` | **XAUUSD** | M15 | (stesso prova M15, `-Simbolo` override, **FUORI STAMPO**) |

> 🥇 **ORO_M15, dichiarato per intero (richiesta esplicita di Claudio, 02/09 —
> è il simbolo dove opera a mano):** è un **override FUORI dallo stampo M0PB**.
> Il confronto diretto col banco del 31/08 resta **sui tre indici**; l'oro **si
> legge da solo**. E l'unità va letta dalle **colonne di eco della sonda**:
> verificato nel sorgente, la sonda **non rifiuta** un simbolo non-indice
> (OnInit fa solo un avviso a log) e l'eco `Punto Indice Prezzo` =
> `InpPuntiPerIndice × _Point` esce in colonna. Sul feed BCM l'oro quota a **2
> decimali** (Point 0,01 — misurato dagli statements del conto demo), quindi
> 100 × 0,01 = **1,00: l'eco atteso è 1,000 ANCHE su XAUUSD**, e il gate della
> riga lo pretende **per corsa, col suo messaggio** — ma il significato cambia:
> sugli indici "1 punto indice" è un punto di indice, **sull'oro è 1,00 USD di
> prezzo**. Le soglie F2 (5,0/7,0) sono congelate per gli **INDICI**: sull'oro
> si leggono come **5–7 USD**, il verdetto esce **marcato `[ORO]`** ed è una
> **lettura a parte** (l'ATR mediano in colonna dice se 5–7 USD sono sopra o
> sotto il rumore dell'oro). Se l'eco NON viene 1,000, la scala dei decimali
> del feed è un'altra: la corsa oro **non si legge** finché l'unità non è
> rideclarata (PROBLEMA dedicato nel referto).

> ⚙️ **Le scelte, dichiarate:** DUE prova gemelli (M5/M15) che differiscono per
> **ESATTAMENTE DUE righe vive**, tutte e due dichiarate e **gattate
> meccanicamente**: `@PERIODO` (M5/M15) e `InpBarreOrizzonteLungo` (**96/32** —
> è definito in ORE, 8: il significato è costante, il numero no). Una TERZA
> differenza **ferma tutto**. **UN SOLO asse Y** = `InpModoPrezzoIngresso`
> `1||0||1||1||Y` (1 = apertura barra dopo, **RIGA DEL VERDETTO**; 0 =
> chiusura barra segnale, sensibilità GRATIS — e in più è il **gate di
> determinismo V13**: i conteggi non devono muoversi fra le due passate).
> **I numeri del MOTORE (14/14/5/20) sono `#define` nel sorgente, NON
> sweepabili**: in un PASSO 0 sweepare le lunghezze sarebbe pescare la cella
> che fa passare il pavimento (V14, regola della seconda caccia letta
> dall'altro lato). **Celle contate come le conta il generico: 2 passate a
> corsa, 7 corse = 14 passate** — la riga le **riconta dai pin `||Y` scaricati
> al pin**. **NESSUNA CELLA VIENE PROMOSSA**: si leggono le colonne.

> 🎯 **I TRE CANCELLI (congelati PRIMA nei prova, disuguaglianze CABLATE in
> `VerdettoF1/F2/H8_Calc` e autotestate sui bordi esatti — blocco 16; verdetto
> AUTOMATICO nel referto, PER CORSA E PER LATO):** **F1 in AND**: totale L+S ≥
> **2,00** segnali/giorno (pavimento firmato da Claudio l'01/09) **E** ogni
> lato ≥ **1,00** (scheda 31/08) → se cade una qualunque: MORTO · **F2** MFE
> mediana a 12 barre, punti indice: **VIVA solo SOPRA 7,0**; < 5,0 MORTO;
> 5,0–7,0 INCLUSI **SOSPESO** [SPREAD NON MISURATO — Code Base 74148 mai
> usato; fascia sciolta verso la clausola **più severa**, classe 31/08] ·
> **H8** RR da mediane ≥ **0,70** (FIRMA 2 del 31/08, E ≥ 0,075R) → sotto:
> **MORTO PER ARITMETICA**, niente corsa a tick. E i cancelli sono **più
> severi** della scheda, non più morbidi: una porta di rientro che si
> ammorbidisce quando si esercita non è un criterio, è un favore.

> 🔒 **L'INVARIANTE NUOVA, da guardare PRIMA dei numeri:** le colonne **`Stato
> Ambiguo Long/Short` DEVONO essere 0/0** in ogni passata. Il pending del V8 è
> un **LATCH** e non dimentica per decadimento come una media (V5): la sonda
> ricostruisce lo stato girando la macchina DUE volte con semi opposti, e una
> barra ambigua **non viene contata** (si sbaglia CONTRO il candidato). Se non
> sono zero, `InpWarmupBarre` (400) è troppo corto e **i numeri di quella
> corsa NON valgono** — la riga lo mette nei PROBLEMI da sola.

| | |
|---|---|
| **Driver** | `righe/RIGA_SONDARSIEMAV8.ps1` (marcatore `MARCATORE_RIGA_SONDARSIEMAV8_v2`) |
| **File prova** | `prove/RSIEMAV8_FREQUENZA_M5.txt` + `prove/RSIEMAV8_FREQUENZA_M15.txt` |

**MT5 e MetaEditor CHIUSI. PC di backtest, non VPS.**
⏱️ **14 passate open-prices** su ~21 mesi + 7 avvii del terminale + 1
compilazione = **stima onesta 15–35 minuti** per tutto il giro [STIMA, non una
previsione]. Il giro a vuoto è questione di minuti (ma COMPILA: è lì che un EA
mai compilato può cadere, ed è un risultato).

## 📌 IL PIN — **`0f01962014dc13ae6e578adbf1319b35e865cea1`**  ✅ INSERITO (commit di `lavoro`, verificato con `git rev-parse`; contiene driver + 2 prova + la sonda `.mq5`)

## 1️⃣ Giro a vuoto

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='0f01962014dc13ae6e578adbf1319b35e865cea1'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SONDARSIEMAV8.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SONDARSIEMAV8.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SONDARSIEMAV8_v2' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -SoloControllo; $rc=$LASTEXITCODE;
    $z=@(Get-ChildItem (Join-Path $env:USERPROFILE 'Desktop\SONDARSIEMAV8_CONTROLLO_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP SONDARSIEMAV8_CONTROLLO_ DI ADESSO: il controllo non e'' arrivato alla raccolta' };
    $ko=(($rc -is [int]) -and ($rc -ne 0));
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO nello zip qui sotto.' -ForegroundColor Yellow };
    if($ko){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Mandami questo zip:' -ForegroundColor Red; Write-Host $z[0].FullName -ForegroundColor Yellow } else { Write-Host 'CONTROLLO OK (fa comunque fede il referto nello zip): lancia il blocco 2.' -ForegroundColor Green } }
```

## 2️⃣ Corsa vera

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='0f01962014dc13ae6e578adbf1319b35e865cea1'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SONDARSIEMAV8.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SONDARSIEMAV8.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SONDARSIEMAV8_v2' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin; $rc=$LASTEXITCODE;
    $z=@(Get-ChildItem (Join-Path $env:USERPROFILE 'Desktop\SONDARSIEMAV8_CORSA_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP SONDARSIEMAV8_CORSA_ DI ADESSO: la corsa non e'' arrivata alla raccolta' };
    $ko=(($rc -is [int]) -and ($rc -ne 0));
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if($ko){ Write-Host 'CORSA CON PROBLEMI: lo zip esiste lo stesso, mandalo.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    Write-Host 'POI nel REFERTO: riga data: = adesso, riga modo: = CORSA.' -ForegroundColor Gray }
```

## 📦 COSA TORNA
Zip sul Desktop **`SONDARSIEMAV8_CORSA_...zip`** → `REFERTO_SONDARSIEMAV8.txt`
+ i 2 prova + **7 CSV OPTFRAME** (`ABTG_SondaRsiEmaV8_<SIMBOLO>_IS_ohlc_<ETICHETTA>.csv`,
**2 righe l'uno** = le 2 passate, con le **59 colonne**: Segnali / Nudo /
Pending Attivo / Armamenti Rsi per lato **in ogni passata** (l'ablazione),
Segnali Long/Short/Totali Al Giorno, Mfe/Mae Mediano per lato in punti indice,
RR Da Mediane, Win Rate Necessario, Max Segnali Giorno, orizzonte lungo,
Rsi/Ema Divergenza Max, **Stato Ambiguo L/S**, Punto Indice Prezzo, Autotest
Falliti/Blocchi…). **Mandami lo zip `SONDARSIEMAV8_CORSA_...` — quello
`SONDARSIEMAV8_CONTROLLO_...` del giro a vuoto NON è il risultato** (serve solo
se il controllo si è fermato).
⚠️ Il suffisso **`_ohlc`** nei nomi CSV è la marca del generico per ogni
modello non-tick: qui vuol dire **Modello 2, open prices** — non OHLC M1.
Niente per-trade (zero ordini) e niente CSV riga-per-segnale (in ottimizzazione
la sonda lo spegne apposta: le passate si sovrascriverebbero).

## 🔎 COME SI LEGGE
🕐 **PRIMA DI TUTTO** apri `REFERTO_SONDARSIEMAV8.txt` e controlla:
- riga **`data:`** = l'ora di adesso (referto stantio = giro vecchio);
- riga **`modo:`** = **CORSA**;
- riga **`compilazione:`** = OK — EA nuovo: se è FALLITA, quello È il risultato
  (errori in `COMPILAZIONE_FALLITA.log` nello zip);
- riga **`grep contatore puro:`** = **0 chiamate** (il contatore non può aprire
  ordini, provato a macchina);
- riga **`celle per corsa:`** = **2**, ricontate dai pin `||Y` al pin;
- riga **`gemellaggio prova M5/M15:`** = VALIDO (SOLO le 2 differenze
  dichiarate: `@PERIODO` e `InpBarreOrizzonteLungo` 96/32);
- riga **`csv *_OOS trovati:`** = **0** (sta NEL referto, non solo a schermo);
- riga **`CSV letto: scritto alle ...`** sotto OGNI corsa: la riga esiste solo
  se quell'ora è **più recente dell'avvio della corsa**. Se una corsa dice
  invece `CSV STANTIO, NON LETTO` fra i PROBLEMI, quel CSV è il reperto di un
  giro precedente (il generico è morto prima di rifarlo): **quella corsa non
  ha numeri, si rilancia**;
- **collaudi per corsa**: righe **2**, autotest **0/16 PASSATI**, `RsiDivMax`
  ~0 (V1), `EmaDivMax` < 0,00001 in prezzo (V3), **`AmbL`/`AmbS` = 0**
  (l'INVARIANTE V5: se non è zero, quella corsa NON vale — warmup corto),
  `PuntoIdx` **1,000** (V9 — e sull'oro vale 1,000 = **1,00 USD**, vedi il
  blocco ORO qui sopra), **determinismo IDENTICI** fra le 2 passate (conteggi,
  invarianti e ATR non si muovono: l'asse tocca solo il prezzo d'ingresso),
  **sottoinsieme OK** (Segnali ≤ Nudo, sempre).

📊 Poi la **TABELLA DEI CANCELLI per corsa e LATO** (mai aggregati): sig/gg per
lato E totali (F1 in AND), MFE mediana (F2), MAE mediana (F3), **RR** (H8),
win rate necessario, massimo segnali in un giorno (F4 — il referto stampa già
il prodotto × 0,65% contro il cap C1 di 3,25% del 18/08) e il **VERDETTO
AUTOMATICO VIVO/SOSPESO/MORTO per corsa e lato**. Sotto ogni corsa,
l'**ABLAZIONE in numeri** (la domanda della scheda del 31/08: "filtro
appiccicato sopra trigger generico"?): se **SEGNALI ~ NUDO** e il pending è
quasi sempre armato, il filtro non filtra e il motore È un incrocio di EMA —
famiglia SuperWave/ChaosLyapunov, già morta due volte, e il verdetto di carta
risulterebbe **confermato da una misura**. Se **SEGNALI ≪ NUDO**, il pending
morde davvero e la domanda torna a F1. **`ORO_M15` si legge DA SOLA**, marcata
`[ORO]`: mai nel confronto coi tre indici.

🛑 **Promemoria:** le escursioni sono **limiti superiori** (la fonte non ha
uscite: è un indicatore) — su F2 la distorsione è conservativa nel verso
giusto, su H8 **no** (l'RR è un'INDICAZIONE, dichiarato). La sonda **non
simula esiti**: l'ordine MFE/MAE dentro le 12 barre lo vede solo il tick. F6:
12 barre su M15 = il triplo del tempo di M5 — "vivo solo su M15" si dice "vivo
su un orizzonte 3 volte più lungo". Un solo regime (toro): questo passo conta
**occasioni e geometrie**, non merito. Nessuna promozione esce da qui.

## 🔴 AVVISI ATTESI (rossi e gialli — nessuno di questi è un guasto)
1. Il generico stamperà rosso sui CSV **`*_OOS`** (**7 volte**, una per
   corsa): con FrazioneIS 1.0 la gamba OOS è **degenere (0 giorni)** per
   costruzione. **Atteso: NON rilanciare.** Fa fede l'`ESITO:` finale della
   riga — e il conteggio dei `*_OOS` trovati (attesi 0) sta **nel referto**.
1-bis. **7 avvisi GIALLI** _"il timeframe operativo E' il Period del tester"_:
   la sonda usa `PERIOD_CURRENT` apposta (il TF glielo dà il prova). **Corretto
   e voluto.**
2-bis. ⚠️ **NON aprire i file `anteprima_*.ini`** del giro a vuoto: per un
   difetto noto del generico (punto 96) l'anteprima scrive `Model=4`
   **hardcoded** — la corsa vera usa **Model=2** come dichiarato. L'anteprima
   mente proprio sul campo che questo round misura: fa fede il referto.
2. **Tetto ~100k barre** (regola 25/08): 21 mesi di **M5** possono eccedere il
   tetto (~1,3 anni a M5). La riga cerca da sola la **firma del tetto** (Barre
   Valutate IDENTICHE su simboli diversi dello stesso TF, punto 36) e
   confronta i **giorni contati M5 contro M15** per simbolo: se compare nei
   RILIEVI, la finestra effettiva M5 è più corta — **F1 resta leggibile** (è
   per-giorno sul denominatore CONTATO), campione e regime si dichiarano nella
   lettura, e il confronto F6 va letto sapendo che confronta anche due
   finestre diverse.
3. Se il codice di uscita di un blocco esce **"NON LETTO"** (PS 5.1, classe
   108): **non è un fallimento** — fa fede il referto dentro lo zip, con la
   sua `data:` e i CSV **datati e contati**.
