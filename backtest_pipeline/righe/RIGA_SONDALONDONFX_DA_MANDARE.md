# 📬 SONDA LONDONFX — **PASSO 0: LA RIGA DA MANDARE** (si conta PRIMA, si giudica DOPO)

**Che cos'è:** il primo giro della **sonda di frequenza `ABTG_SondaLondonFx`**
(EA **NUOVO, MAI COMPILATO** — la compilazione avviene qui e **se fallisce,
QUELLO è il risultato del passo**). È un **CONTATORE PURO**: zero ordini, zero
lotti, zero magic — la riga lo **prova a macchina** (grep delle chiamate di
trading fuori dai commenti, attese **0**) prima di aprire MT5. Motore contato:
**LondonFx** (canale SMA5(high)/SMA5(low) + sessione di Londra + RSI opzionale
— il promosso **P1** della CACCIA FREQUENZA, seconda battuta del 31/08, da
SoftKill21/TradingView, MPL 2.0, attribuzione in testa al `.mq5`).

**DUE CORSE in sequenza** — **SOLO EURUSD** (il lead, il simbolo dell'autore) ×
2 TF, finestra 2024.09.26 → 2026.06.30, **MODELLO 2 "Solo prezzi di apertura"**
(il segnale nasce su barra chiusa e non si apre niente: il tick non aggiunge
informazione e costa ore):

| Corsa | Simbolo | TF | File prova |
|---|---|---|---|
| `EUR_M5` | EURUSD | M5 | `prove/LONDONFX_FREQUENZA_M5.txt` |
| `EUR_M15` | EURUSD | M15 | `prove/LONDONFX_FREQUENZA_M15.txt` |

> 🧭 **Perché solo EURUSD, dichiarato:** è la scelta semplice e senza trappole.
> **GBPUSD** girerà DOPO come corsa aggiuntiva dichiarata (override `-Simbolo`
> del generico, stesso prova). **USDJPY MAI su questo prova**: la sonda
> **RIFIUTA DI PARTIRE** se `InpPipSize` non combacia col pip del simbolo
> (0,01 per JPY, qui è pinnato 0,0001) — ed è **VOLUTO**: meglio un init
> fallito che una taglia sbagliata di 100 volte letta come buona. La gamba JPY
> sarà un **giro separato con un prova suo**.

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
| **Driver** | `righe/RIGA_SONDALONDONFX.ps1` (marcatore `MARCATORE_RIGA_SONDALONDONFX_v2`) |
| **File prova** | `prove/LONDONFX_FREQUENZA_M5.txt` + `prove/LONDONFX_FREQUENZA_M15.txt` |

**MT5 e MetaEditor CHIUSI. PC di backtest, non VPS.**
⏱️ **12 passate open-prices** su ~21 mesi + 2 avvii del terminale + 1
compilazione = **stima onesta 10–25 minuti** per tutto il giro [STIMA, non una
previsione]. Il giro a vuoto è questione di minuti (ma COMPILA: è lì che un EA
mai compilato può cadere, ed è un risultato).

## 📌 IL PIN — **`<PIN>`**  ⛔ DA INSERIRE DOPO IL PUSH (commit di 40 caratteri esadecimali del branch `lavoro`)

## 1️⃣ Giro a vuoto

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SONDALONDONFX.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SONDALONDONFX.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SONDALONDONFX_v2' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo; $rc=$LASTEXITCODE;
    $z=@(Get-ChildItem (Join-Path $env:USERPROFILE 'Desktop\SONDALONDONFX_CONTROLLO_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP SONDALONDONFX_CONTROLLO_ DI ADESSO: il controllo non e'' arrivato alla raccolta' };
    if($rc -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Mandami questo zip:' -ForegroundColor Red; Write-Host $z[0].FullName -ForegroundColor Yellow } else { Write-Host 'CONTROLLO OK: lancia il blocco 2.' -ForegroundColor Green } }
```

## 2️⃣ Corsa vera

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SONDALONDONFX.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SONDALONDONFX.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SONDALONDONFX_v2' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=0; & $p -Pin $pin; $rc=$LASTEXITCODE;
    $z=@(Get-ChildItem (Join-Path $env:USERPROFILE 'Desktop\SONDALONDONFX_CORSA_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP SONDALONDONFX_CORSA_ DI ADESSO: la corsa non e'' arrivata alla raccolta' };
    if($rc -ne 0){ Write-Host 'CORSA CON PROBLEMI: lo zip esiste lo stesso, mandalo.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    Write-Host 'POI nel REFERTO: riga data: = adesso, riga modo: = CORSA.' -ForegroundColor Gray }
```

## 📦 COSA TORNA
Zip sul Desktop **`SONDALONDONFX_CORSA_...zip`** → `REFERTO_SONDALONDONFX.txt`
+ i 2 prova + **2 CSV OPTFRAME** (`ABTG_SondaLondonFx_EURUSD_IS_ohlc_<ETICHETTA>.csv`,
**6 righe l'uno** = le 6 passate, con le 58 colonne: Segnali Nudo / Segnali Con
Rsi per lato **in ogni passata**, Segnali Long/Short Al Giorno, Mfe/Mae Mediano
per lato in PIP, RR Da Mediane, Win Rate Necessario, Max Segnali Giorno,
orizzonte lungo, Rsi Divergenza Max, Autotest Falliti…). **Mandami lo zip
`SONDALONDONFX_CORSA_...` — quello `SONDALONDONFX_CONTROLLO_...` del giro a
vuoto NON è il risultato** (serve solo se il controllo si è fermato).
⚠️ Il suffisso **`_ohlc`** nei nomi CSV è la marca del generico per ogni
modello non-tick: qui vuol dire **Modello 2, open prices** — non OHLC M1.
Niente per-trade (zero ordini) e niente CSV riga-per-segnale (in ottimizzazione
la sonda lo spegne apposta: le passate si sovrascriverebbero).

## 🔎 COME SI LEGGE
🕐 **PRIMA DI TUTTO** apri `REFERTO_SONDALONDONFX.txt` e controlla:
- riga **`data:`** = l'ora di adesso (referto stantio = giro vecchio);
- riga **`modo:`** = **CORSA**;
- riga **`compilazione:`** = OK — EA nuovo: se è FALLITA, quello È il risultato
  (errori in `COMPILAZIONE_FALLITA.log` nello zip);
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
  ~0 (L1), `PipEco` **0,00010** e `PipPti` **10,00** (L5 — l'equivalente forex
  del PuntoIdx della SondaM0PB), `CanInv` **0**, `BarreSalt` ~0 — e per corsa:
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
le tre ore; F6 confronta `EUR_M5` contro `EUR_M15` **sapendo che 12 barre non
sono lo stesso tempo** (1 ora contro 3 ore: è proprio il gradiente cercato).

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
