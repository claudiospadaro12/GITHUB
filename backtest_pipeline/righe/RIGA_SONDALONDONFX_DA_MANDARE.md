# 📬 SONDA LONDONFX — **PASSO 0: LA RIGA DA MANDARE** (si conta PRIMA, si giudica DOPO)

**Che cos'è:** il primo giro della **sonda di frequenza `ABTG_SondaLondonFx`**
(EA **NUOVO, MAI COMPILATO** — la compilazione avviene qui e **se fallisce,
QUELLO è il risultato del passo**). È un **CONTATORE PURO**: zero ordini, zero
lotti, zero magic — la riga lo **prova a macchina** (grep delle chiamate di
trading fuori dai commenti, attese **0**) prima di aprire MT5. Motore contato:
**LondonFx** (canale SMA5(high)/SMA5(low) + sessione di Londra + RSI opzionale
— il promosso **P1** della CACCIA FREQUENZA, seconda battuta del 31/08, da
SoftKill21/TradingView, MPL 2.0, attribuzione in testa al `.mq5`).

## 🚦 STATO DELLE DUE GAMBE (03/09)

| Gamba | Simbolo | Stato | Cosa fare |
|---|---|---|---|
| **LEAD** | **EURUSD** | ✅ **GIÀ FATTA** — corsa pulita del 03/09, zip delle **08:56**, referto in `risultati_archivio/REFERTO_SONDALONDONFX_2026-09-03.md` (**PRIMO SUPERSTITE**: M15+RSI, 12/12 righe vive) | **NON si rifà.** Le stringhe stanno qui sotto solo per riproducibilità, ri-pinnate |
| **GEMELLA** | **GBPUSD** | 🟡 **DA FARE ORA** | Le due stringhe della sezione **3️⃣ / 4️⃣** |

**DUE CORSE in sequenza per ogni gamba** — **un simbolo per giro** × 2 TF,
finestra 2024.09.26 → 2026.06.30, **MODELLO 2 "Solo prezzi di apertura"**
(il segnale nasce su barra chiusa e non si apre niente: il tick non aggiunge
informazione e costa ore):

| Corsa (etichetta) | Simbolo | TF | File prova |
|---|---|---|---|
| `EUR_M5` / `GBP_M5` | EURUSD / GBPUSD | M5 | `prove/LONDONFX_FREQUENZA_M5.txt` |
| `EUR_M15` / `GBP_M15` | EURUSD / GBPUSD | M15 | `prove/LONDONFX_FREQUENZA_M15.txt` |

> 🧭 **L'OVERRIDE DI SIMBOLO, DICHIARATO (driver v4, 03/09).** Il driver ha ora
> un parametro **`-Simbolo`** (default **EURUSD**, il lead = il simbolo
> dell'autore). GBPUSD gira passando **`-Simbolo GBPUSD`**, ed è l'override
> **previsto dal prova** (par. _DOVE GIRA_: «GBPUSD e USDJPY girano con
> `-Simbolo` del generico … il parametro `-Simbolo` **vince** sulla direttiva»)
> e **supportato dal generico** alle righe **303-305** (la direttiva `@SIMBOLO`
> si legge **solo se** il parametro è vuoto).
> **I due file prova restano dichiarati sul LEAD** (`@SIMBOLO EURUSD`) **anche
> nella corsa GBPUSD**, e il gate del driver **lo pretende**: la dichiarazione
> sta nel prova, l'override sta nella riga, e **il referto stampa tutti e due in
> chiaro** (riga `simbolo di questa corsa:`). Pattern già di casa, dichiarato nel
> referto della sonda **V8**.
> 🏷️ **Le ETICHETTE si derivano dal simbolo** (`EUR_*` / `GBP_*`) ed entrano nel
> **nome dei CSV**: la corsa GBPUSD **non può** sovrascrivere i CSV della corsa
> EURUSD già fatta (e il nome del CSV del generico porta **anche** il simbolo:
> due cinture, non una). Lo stesso vale per **cartella, zip e referto**, che ora
> portano il simbolo nel nome.

> ⛔ **USDJPY È VIETATO SU QUESTO PROVA, e la riga lo ferma PRIMA di aprire MT5.**
> La sonda **RIFIUTA DI PARTIRE** se `InpPipSize` non combacia col pip del
> simbolo (0,01 per JPY, qui è pinnato 0,0001) — ed è **VOLUTO**: meglio un init
> fallito che una taglia sbagliata di 100 volte letta come buona. Il driver v4 ha
> in più una **whitelist** (`EURUSD`, `GBPUSD`) che si ferma **prima** dello
> scarico e prima della compilazione, dicendo perché: il muro della sonda si
> scoprirebbe altrimenti solo dopo due avvii del terminale, con un referto pieno
> di righe vuote. La gamba JPY sarà un **giro separato con un prova suo**.

> ⚙️ **Le scelte, dichiarate:** DUE prova gemelli (M5/M15) che differiscono per
> **ESATTAMENTE DUE righe vive**, tutte e due dichiarate nel prova e **gattate
> meccanicamente** dalla riga: `@PERIODO` (M5/M15) e `InpBarreOrizzonteLungo`
> (**96/32** — è definito in ORE, 8: il significato è costante, il numero no).
> Una TERZA differenza, o una delle due mancante, **ferma tutto**. **DUE assi
> Y**, nessuno decorativo: `InpUsaRsi` `true||false||1||true||Y` (ablazione
> F1-bis: l'autore dichiara l'RSI **OPZIONALE** — e in più è un **gate di
> determinismo**) e `InpOraInizioServer` `6||4||2||8||Y` (F7: il fuso del Pine
> è **INCERTO**, UTC o New York — non si converte a tavolino, si sweepa; attesa
> dichiarata: la cella **8** = lettura New York = sessione di Londra esatta).
> **Celle contate come le conta il generico: 2 × 3 = 6 passate a corsa, 12 in
> tutto** — e la riga le **riconta dai pin `||Y` scaricati al pin**.
> **NESSUNA CELLA VIENE PROMOSSA**: il criterio di ottimizzazione della sonda
> vincerebbe sempre col ramo di CONTROLLO (RSI spento) — si **leggono le
> colonne**, riga per riga.

> 🎯 **I TRE CANCELLI (congelati PRIMA, verdetto AUTOMATICO nel referto, PER
> RIGA E PER LATO):** **F1** segnali/giorno ≥ **1,00** → sotto: MORTO · **F2**
> MFE mediana a 12 barre, in PIP: **VIVA solo SOPRA 6,0 pip**; < 3,0 MORTO;
> 3,0–6,0 **SOSPESO** [SPREAD NON MISURATO — Code Base 74148 mai usato; la
> fascia coperta da due bullet della bozza è sciolta verso la clausola **più
> severa**, dichiarato nel prova e CABLATO in `VerdettoF2_Calc`] · **H8** RR da
> mediane ≥ **0,70** (FIRMA 2 del 31/08, E ≥ 0,075R) → sotto: **MORTO PER
> ARITMETICA**, niente corsa a tick.

| | |
|---|---|
| **Driver** | `righe/RIGA_SONDALONDONFX.ps1` (marcatore `MARCATORE_RIGA_SONDALONDONFX_v4`) |
| **File prova** | `prove/LONDONFX_FREQUENZA_M5.txt` + `prove/LONDONFX_FREQUENZA_M15.txt` |

**MT5 e MetaEditor CHIUSI. PC di backtest, non VPS.**
⏱️ **12 passate open-prices** su ~21 mesi + 2 avvii del terminale + 1
compilazione = **stima onesta 10–25 minuti** per la gamba GBPUSD [STIMA, non una
previsione]. Il giro a vuoto è questione di minuti (ma COMPILA: è lì che un EA
mai compilato può cadere, ed è un risultato).

## 📌 IL PIN — **`@@PIN@@`**  ✅ INSERITO (verificato con `git rev-parse`: contiene il driver **v4** con `-Simbolo` + i 2 prova + la sonda `.mq5` + il generico). _Ri-pinnata il 03/09 per il driver **v4**: **tutti i pin precedenti e i marcatori `_v2` / `_v3` sono BRUCIATI — non incollarli più.** Lancia SOLO i quattro blocchi di questa pagina._

---

# 🟢 GAMBA LEAD — EURUSD (**GIÀ FATTA IL 03/09 ALLE 08:56: NON RIFARLA**)

> ⚠️ **Queste due stringhe NON vanno lanciate oggi.** La corsa EURUSD è girata
> pulita, il referto è archiviato (`risultati_archivio/REFERTO_SONDALONDONFX_2026-09-03.md`)
> ed è il **PRIMO SUPERSTITE** del passo 0. Stanno qui **ri-pinnate al pin e al
> marcatore nuovi** solo perché la pagina non deve mai contenere una stringa
> stantia: se un giorno servisse **riprodurre** la gamba lead, si usano queste.

## 1️⃣ EURUSD — giro a vuoto _(riproduzione, non serve oggi)_

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='@@PIN@@'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SONDALONDONFX.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SONDALONDONFX.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SONDALONDONFX_v4' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Simbolo EURUSD -SoloControllo; $rc=$LASTEXITCODE;
    $z=@(Get-ChildItem (Join-Path $env:USERPROFILE 'Desktop\SONDALONDONFX_CONTROLLO_EURUSD_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP SONDALONDONFX_CONTROLLO_EURUSD_ DI ADESSO: il controllo non e'' arrivato alla raccolta' };
    $ko=(($rc -is [int]) -and ($rc -ne 0));
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO nello zip qui sotto.' -ForegroundColor Yellow };
    if($ko){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Mandami questo zip:' -ForegroundColor Red; Write-Host $z[0].FullName -ForegroundColor Yellow } else { Write-Host 'CONTROLLO OK (fa comunque fede il referto nello zip): lancia il blocco 2.' -ForegroundColor Green } }
```

## 2️⃣ EURUSD — corsa vera _(riproduzione, non serve oggi)_

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='@@PIN@@'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SONDALONDONFX.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SONDALONDONFX.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SONDALONDONFX_v4' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Simbolo EURUSD; $rc=$LASTEXITCODE;
    $z=@(Get-ChildItem (Join-Path $env:USERPROFILE 'Desktop\SONDALONDONFX_CORSA_EURUSD_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP SONDALONDONFX_CORSA_EURUSD_ DI ADESSO: la corsa non e'' arrivata alla raccolta' };
    $ko=(($rc -is [int]) -and ($rc -ne 0));
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if($ko){ Write-Host 'CORSA CON PROBLEMI: lo zip esiste lo stesso, mandalo.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    $iv=[Globalization.CultureInfo]::InvariantCulture;
    Write-Host ('POI nel REFERTO_SONDALONDONFX_EURUSD.txt: riga modo: = CORSA, riga simbolo di questa corsa: = EURUSD, e riga data: = ORA DI AVVIO di questa corsa (circa ' + $t0.ToString('yyyy-MM-dd HH:mm',$iv) + '), NON l''ora attuale (' + (Get-Date).ToString('HH:mm',$iv) + '): il referto si timbra all''INIZIO e la corsa dura 10-25 minuti. La freschezza e'' gia'' stata controllata a macchina sullo zip qui sopra.') -ForegroundColor Gray }
```

---

# 🟡 CORSA GEMELLA — GBPUSD (**È QUESTA CHE SI LANCIA OGGI**)

**Perché:** GBPUSD è il secondo major «a minimo attrito» del mandato del 31/08,
è a **5 decimali come EURUSD** (quindi `InpPipSize=0,0001` è quello giusto e la
sonda **parte**), e R102 ha misurato la prima operazione al **1999.01.04** anche
su di lui. Stesso prova, stessa finestra, stessi tre cancelli: **è il confronto
per simbolo del passo 0**, non un giro nuovo. Le due corse (M5 e M15) girano in
sequenza con le etichette **`GBP_M5`** / **`GBP_M15`**.

## 3️⃣ GBPUSD — giro a vuoto

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='@@PIN@@'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SONDALONDONFX.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SONDALONDONFX.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SONDALONDONFX_v4' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Simbolo GBPUSD -SoloControllo; $rc=$LASTEXITCODE;
    $z=@(Get-ChildItem (Join-Path $env:USERPROFILE 'Desktop\SONDALONDONFX_CONTROLLO_GBPUSD_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP SONDALONDONFX_CONTROLLO_GBPUSD_ DI ADESSO: il controllo non e'' arrivato alla raccolta' };
    $ko=(($rc -is [int]) -and ($rc -ne 0));
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO nello zip qui sotto.' -ForegroundColor Yellow };
    if($ko){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Mandami questo zip:' -ForegroundColor Red; Write-Host $z[0].FullName -ForegroundColor Yellow } else { Write-Host 'CONTROLLO OK (fa comunque fede il referto nello zip): lancia il blocco 4.' -ForegroundColor Green } }
```

## 4️⃣ GBPUSD — corsa vera

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='@@PIN@@'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SONDALONDONFX.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SONDALONDONFX.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SONDALONDONFX_v4' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Simbolo GBPUSD; $rc=$LASTEXITCODE;
    $z=@(Get-ChildItem (Join-Path $env:USERPROFILE 'Desktop\SONDALONDONFX_CORSA_GBPUSD_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP SONDALONDONFX_CORSA_GBPUSD_ DI ADESSO: la corsa non e'' arrivata alla raccolta' };
    $ko=(($rc -is [int]) -and ($rc -ne 0));
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if($ko){ Write-Host 'CORSA CON PROBLEMI: lo zip esiste lo stesso, mandalo.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    $iv=[Globalization.CultureInfo]::InvariantCulture;
    Write-Host ('POI nel REFERTO_SONDALONDONFX_GBPUSD.txt: riga modo: = CORSA, riga simbolo di questa corsa: = GBPUSD OVERRIDE DICHIARATO, e riga data: = ORA DI AVVIO di questa corsa (circa ' + $t0.ToString('yyyy-MM-dd HH:mm',$iv) + '), NON l''ora attuale (' + (Get-Date).ToString('HH:mm',$iv) + '): il referto si timbra all''INIZIO e la corsa dura 10-25 minuti. La freschezza e'' gia'' stata controllata a macchina sullo zip qui sopra.') -ForegroundColor Gray }
```

## 📦 COSA TORNA
Zip sul Desktop **`SONDALONDONFX_CORSA_GBPUSD_...zip`** →
`REFERTO_SONDALONDONFX_GBPUSD.txt` + i 2 prova + **2 CSV OPTFRAME**
(`ABTG_SondaLondonFx_GBPUSD_IS_ohlc_GBP_M5.csv` e
`ABTG_SondaLondonFx_GBPUSD_IS_ohlc_GBP_M15.csv`, **6 righe l'uno** = le 6
passate, con le **58 colonne nostre + le 15 di input** accodate dal tester
(`FrameInputs`; il driver legge per NOME, quindi non morde): Segnali Nudo /
Segnali Con Rsi per lato **in ogni passata**, Segnali Long/Short Al Giorno,
Mfe/Mae Mediano per lato in PIP, RR Da Mediane, Win Rate Necessario, Max Segnali
Giorno, orizzonte lungo, Rsi Divergenza Max, Autotest Falliti…). **Mandami lo
zip `SONDALONDONFX_CORSA_GBPUSD_...` — quello `SONDALONDONFX_CONTROLLO_GBPUSD_...`
del giro a vuoto NON è il risultato** (serve solo se il controllo si è fermato).
🏷️ **Simbolo nel nome di cartella, zip, referto e CSV** (driver v4): lo zip di
GBPUSD e quello di EURUSD delle 08:56 **non possono confondersi**, nemmeno se
finiscono nella stessa cartella.
⚠️ Il suffisso **`_ohlc`** nei nomi CSV è la marca del generico per ogni
modello non-tick: qui vuol dire **Modello 2, open prices** — non OHLC M1.
Niente per-trade (zero ordini) e niente CSV riga-per-segnale (in ottimizzazione
la sonda lo spegne apposta: le passate si sovrascriverebbero).

## 🔎 COME SI LEGGE
🕐 **PRIMA DI TUTTO** apri `REFERTO_SONDALONDONFX_GBPUSD.txt` e controlla:
- riga **`data:`** = **l'ora in cui hai lanciato il blocco 4** (il referto si timbra
  all'**AVVIO**, la corsa dura 10-25 min: **l'ora attuale NON è il metro**). La riga
  te la stampa già in console, col valore atteso. _(Difetto D2 del verificatore,
  03/09, classe 110: la frase vecchia diceva "= adesso" e avrebbe fatto rilanciare
  in buona fede una corsa sana. La freschezza vera l'ha già controllata a macchina
  il filtro `LastWriteTime -ge $t0` sullo zip.)_
- riga **`modo:`** = **CORSA**;
- riga **`simbolo di questa corsa:`** = **GBPUSD, OVERRIDE DICHIARATO** — e sotto,
  la riga che dice che **i prova restano dichiarati sul lead EURUSD** e che il
  parametro `-Simbolo` del generico vince sulla direttiva. Se lì c'è scritto
  **EURUSD**, l'override non è passato: **quella non è la gamba gemella**, si
  rilancia col blocco 4;
- riga **`compilazione:`** = OK — EA nuovo: se è **FALLITA**, quello È il risultato
  (errori in `COMPILAZIONE_FALLITA.log` nello zip). _(Difetto D1 del verificatore,
  03/09, classe 94-ter: prima del driver v3 il campo veniva timbrato **solo sul
  ramo di successo**, e un giro con la compilazione fallita usciva con
  `compilazione: NON TENTATA` — cioè negava agli atti proprio il fatto che questo
  passo misura. Dal driver **v3** gli stati sono tre e sono tutti veri:
  `NON TENTATA` / `FALLITA` / `OK`.)_
- riga **`grep contatore puro:`** = **0 chiamate** (il contatore non può aprire
  ordini, provato a macchina);
- riga **`celle per corsa:`** = **6**, ricontate dai pin `||Y` al pin;
- riga **`gemellaggio prova M5/M15:`** = VALIDO (SOLO le 2 differenze
  dichiarate: `@PERIODO` e `InpBarreOrizzonteLungo` 96/32);
- riga **`csv *_OOS trovati:`** = **0** (sta NEL referto, non solo a schermo);
- riga **`CSV letto: scritto alle ...`** sotto OGNI corsa: è l'ora in cui il CSV
  è stato scritto, e la riga esiste solo se quell'ora è **più recente
  dell'avvio della corsa**. Se una corsa dice invece `CSV STANTIO, NON LETTO`
  fra i PROBLEMI, quel CSV è il reperto di un giro precedente (il generico è
  morto prima di rifarlo): **quella corsa non ha numeri, si rilancia**;
- **collaudi per corsa**: righe **6**, autotest **0/16 PASSATI**, `RsiDivMax`
  ~0 (L1), `PipEco` **0,00010** e `PipPti` **10,00** (L5 — GBPUSD è a 5 decimali
  come EURUSD: se qui esce altro, la sonda avrebbe rifiutato di partire e le
  righe sarebbero vuote), `CanInv` **0**, `BarreSalt` ~0 — e per corsa:
  **determinismo IDENTICI** (3 coppie di passate a parità d'ora),
  **cablaggio OK** (Segnali = Nudo col RSI spento, = Con Rsi acceso),
  **sottoinsieme OK** (Con Rsi ≤ Nudo, sempre).

📊 Poi la **TABELLA DEI CANCELLI per corsa / passata (rsi × ora) / LATO** (mai
aggregati): sig/gg (F1), MFE mediana (F2), MAE mediana (F3), **RR** (H8), win
rate necessario, massimo segnali in un giorno (F4, il numero che taglia
`InpMaxTradesPerDay` sui dati — il referto stampa già il prodotto × 0,65%
contro il cap C1 di 3,25%) e il **VERDETTO AUTOMATICO VIVO/SOSPESO/MORTO** per
riga. **Nessuna riga "vincente"**: F1-bis (l'ablazione RSI) si legge dalle
colonne Nudo/Con Rsi **dentro una riga sola**; F7 (l'ora) si legge confrontando
le tre ore; F6 confronta `GBP_M5` contro `GBP_M15` **sapendo che 12 barre non
sono lo stesso tempo** (1 ora contro 3 ore: è proprio il gradiente cercato).

🔗 **E POI il confronto per SIMBOLO**, che è il motivo di questa gamba: le righe
`GBP_M15` si mettono accanto alle `EUR_M15` del referto delle 08:56 — **stessa
finestra, stesso prova, stessi cancelli**, cambia solo il simbolo. Il criterio di
casa resta quello: **si legge la riga, non si promuove la cella**.

🛑 **Promemoria:** le escursioni sono **limiti superiori** — su F2 la
distorsione è conservativa nel verso giusto, su H8 **no** (l'RR è
un'INDICAZIONE, dichiarato). Il lato SHORT conta **più** segnali del sorgente
(soglia RSI simmetrica 20 contro 10 dell'autore, F5): se lo short passa F1 solo
per questo, va detto. Un solo regime: questo passo conta **occasioni e
geometrie**, non merito — il merito si misura **a tick, dopo, e SOLO se i tre
cancelli reggono** (R57), e la profondità TICK del forex BCM **non è mai stata
sondata** (buco dichiarato nel prova). Nessuna promozione esce da qui.

## 🔴 AVVISI ATTESI (rossi e gialli — nessuno di questi è un guasto)
1. Il generico stamperà rosso sui CSV **`*_OOS`** (due volte, una per corsa):
   con FrazioneIS 1.0 la gamba OOS è **degenere (0 giorni)** per costruzione.
   **Atteso: NON rilanciare.** Fa fede l'`ESITO:` finale della riga — e il
   conteggio dei `*_OOS` trovati (attesi 0) sta **nel referto**.
1-bis. **2 avvisi GIALLI** _"il timeframe operativo E' il Period del tester"_:
   la sonda usa `PERIOD_CURRENT` apposta (il TF glielo dà il prova). **Corretto
   e voluto.**
1-ter. 🟡 **La riga `simbolo .....` in console esce GIALLA** quando l'override è
   attivo (GBPUSD): è **voluto**, serve a farlo vedere. Non è un guasto.
2-bis. ⚠️ **NON aprire i file `anteprima_*.ini`** del giro a vuoto: per un
   difetto noto del generico (punto 96) l'anteprima scrive `Model=4`
   **hardcoded** — la corsa vera usa **Model=2** come dichiarato. L'anteprima
   mente proprio sul campo che questo round misura: fa fede il referto.
2. **Tetto ~100k barre** (regola 25/08): 21 mesi di **M5** forex (~130k barre
   di calendario) possono eccedere il tetto. La riga confronta da sola i
   **giorni contati M5 contro M15** sullo stesso simbolo: se compare nei
   RILIEVI, la finestra effettiva M5 è più corta — **F1 resta leggibile** (è
   per-giorno sul denominatore CONTATO), campione e regime si dichiarano nella
   lettura, e il confronto F6 va letto sapendo che confronta anche due
   finestre diverse.
3. 🟥 **Se la sonda non partisse su GBPUSD** (feed a decimali diversi da 5), le
   righe uscirebbero **vuote** e il referto lo direbbe nei PROBLEMI (`PipEco`
   diverso da 0,00010, righe ≠ 6). È il muro `InpPipSize` **voluto**: in quel
   caso **non si aggiusta niente a mano**, si torna in chat col referto.
