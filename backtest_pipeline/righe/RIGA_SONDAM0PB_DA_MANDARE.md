# 📬 SONDA M0PB — **PASSO 0: LA RIGA DA MANDARE** (si conta PRIMA, si giudica DOPO)

**Che cos'è:** il primo giro della **sonda di frequenza `ABTG_SondaM0PB`** (EA
**NUOVO, MAI COMPILATO** — la compilazione avviene qui e **se fallisce, QUELLO è
il risultato del passo**). È un **CONTATORE PURO**: zero ordini, zero lotti,
zero magic — la riga lo **prova a macchina** (grep delle chiamate di trading
fuori dai commenti, attese **0**) prima di aprire MT5. Motore contato: **M0PB**
(impulso RSI(6) estremo + rientro sulla EMA(5), il promosso 9/10 della
CACCIA FREQUENZA del 31/08).

**SEI CORSE in sequenza** — 3 simboli × 2 TF, finestra 2024.09.26 → 2026.06.30,
**MODELLO 2 "Solo prezzi di apertura"** (il segnale nasce su barra chiusa e non
si apre niente: il tick non aggiunge informazione e costa ore):

| Corsa | Simbolo | TF | File prova |
|---|---|---|---|
| `U30_M5` / `U30_M15` | U30USD | M5 / M15 | `prove/M0PB_FREQUENZA_M5.txt` / `_M15.txt` |
| `NAS_M5` / `NAS_M15` | NASUSD | M5 / M15 | stessi prova, **`-Simbolo` override dichiarato** |
| `DAX_M5` / `DAX_M15` | D30EUR | M5 / M15 | stessi prova, **`-Simbolo` override dichiarato** |

> ⚙️ **Le scelte, dichiarate:** DUE prova gemelli (M5/M15) **identici salvo
> `@PERIODO`** — il gate lo verifica meccanicamente; `@SIMBOLO` è il **lead
> U30USD** e gli altri due girano con l'override `-Simbolo` del generico (il
> parametro vince sulla direttiva — misurato nel codice del driver). **Unico
> asse Y** = `InpModoPrezzoIngresso` `1||0||1||1||Y` → **2 passate INFORMATIVE**
> a corsa (1 = apertura barra dopo, fedele al Pine, **riga del verdetto**;
> 0 = chiusura barra segnale, **sensibilità al prezzo d'ingresso GRATIS**).
> `InpStopAtrMult` resta **PINNATO a 2,75**: lo sweep dello stop è
> **ARITMETICO** (T10: `RR(mult) = RR(2,75)·2,75/mult`, l'ATR mediano esce in
> colonna) — sweeparlo servirebbe solo a pescare il mult che fa passare il
> cancello, vietato per costruzione. **Celle contate: 2 × 6 corse = 12 passate.**

> 🎯 **I TRE CANCELLI (congelati PRIMA, verdetto AUTOMATICO nel referto, per
> LATO):** **F1** segnali/giorno ≥ **1,00** → sotto: MORTO · **F2** take
> mediano ≥ **6,0 punti indice** → < 5,0 MORTO; 5,0–7,0 **SOSPESO** [SPREAD NON
> MISURATO — Code Base 74148 mai usato] · **H8** RR da mediane ≥ **0,70**
> (FIRMA 2 del 31/08) → sotto: **MORTO PER ARITMETICA**, niente corsa a tick.

| | |
|---|---|
| **Driver** | `righe/RIGA_SONDAM0PB.ps1` (marcatore `MARCATORE_RIGA_SONDAM0PB_v1`) |
| **File prova** | `prove/M0PB_FREQUENZA_M5.txt` + `prove/M0PB_FREQUENZA_M15.txt` |

**MT5 e MetaEditor CHIUSI. PC di backtest, non VPS.**
⏱️ **12 passate open-prices** su ~21 mesi + 6 avvii del terminale + 1
compilazione = **stima onesta 10–30 minuti** per tutto il giro [STIMA, non una
previsione]. Il giro a vuoto è questione di minuti (ma COMPILA: è lì che un EA
mai compilato può cadere, ed è un risultato).

## 📌 IL PIN — **`<PIN>`**  ⛔ DA INSERIRE DOPO IL PUSH (commit di 40 caratteri esadecimali del branch `lavoro`)

## 1️⃣ Giro a vuoto

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_SONDAM0PB.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SONDAM0PB.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SONDAM0PB_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera.' -ForegroundColor Red } }
```

## 2️⃣ Corsa vera

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_SONDAM0PB.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SONDAM0PB.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SONDAM0PB_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo' -ForegroundColor Yellow } }
```

## 📦 COSA TORNA
Zip sul Desktop **`SONDAM0PB_CORSA_...zip`** → `REFERTO_SONDAM0PB.txt` + i 2
prova + **6 CSV OPTFRAME** (`ABTG_SondaM0PB_<SIMBOLO>_IS_ohlc_<ETICHETTA>.csv`,
**2 righe l'uno** = le due passate, con le 48 colonne: Segnali Long/Short Al
Giorno, Take/Stop Mediano per lato, RR Da Mediane, Win Rate Necessario, Max
Segnali Giorno, Rsi Divergenza Max, Autotest Falliti…). **Mandami lo zip
`SONDAM0PB_CORSA_...` — quello `SONDAM0PB_CONTROLLO_...` del giro a vuoto NON è
il risultato** (serve solo se il controllo si è fermato).
⚠️ Il suffisso **`_ohlc`** nei nomi CSV è la marca del generico per ogni
modello non-tick: qui vuol dire **Modello 2, open prices** — non OHLC M1.
Niente per-trade (zero ordini) e niente CSV riga-per-segnale (in ottimizzazione
la sonda lo spegne apposta: le passate si sovrascriverebbero).

## 🔎 COME SI LEGGE
🕐 **PRIMA DI TUTTO** apri `REFERTO_SONDAM0PB.txt` e controlla:
- riga **`data:`** = l'ora di adesso (referto stantio = giro vecchio);
- riga **`modo:`** = **CORSA**;
- riga **`compilazione:`** = OK — EA nuovo: se è FALLITA, quello È il risultato
  (errori in `COMPILAZIONE_FALLITA.log` nello zip);
- riga **`grep contatore puro:`** = **0 chiamate** (il contatore non può aprire
  ordini, provato a macchina);
- riga **`gemellaggio prova M5/M15:`** = VALIDO (differiscono SOLO per
  `@PERIODO`);
- **collaudi per corsa**: righe **2**, autotest **0/12 PASSATI**, `RsiDivMax`
  ~0 (T1), `AtrDiv %` **NON zero** (T3, ATR alla Pine), `PuntoIdx` **1,000**
  (T8), eco mult **2,75**, conteggi fra le 2 passate **IDENTICI**.

📊 Poi la **TABELLA DEI CANCELLI per corsa e per LATO** (mai aggregati): sig/gg
(F1), take mediano (F2), stop mediano, **RR** (H8), win rate necessario,
massimo segnali in un giorno (il numero che taglia `InpMaxTradesPerDay` sui
dati) e il **VERDETTO AUTOMATICO VIVO/SOSPESO/MORTO**. Il verdetto è sulla
passata **fedele al Pine** (modo 1); la riga `sensibilità ingresso` dice quanto
cambia col prezzo di chiusura. Con l'**ATR mediano** in tabella l'RR di
**qualunque** moltiplicatore si ricalcola a mano (T10) — **nessuno sweep dello
stop va lanciato**. F6: confronta M5 contro M15 sullo stesso simbolo (il
gradiente si dichiara, non si sceglie a occhio).

🛑 **Promemoria:** il take misurato al segnale è un **limite superiore** (T2):
F2 boccia nel verso giusto. Un solo regime (toro): questo passo conta
**occasioni e geometrie**, non merito — il merito si misura **a tick, dopo, e
SOLO se i tre cancelli reggono** (R57). Nessuna promozione esce da qui.

## 🔴 AVVISI ROSSI ATTESI
1. Il generico stamperà rosso sui CSV **`*_OOS`** (sei volte, una per corsa):
   con FrazioneIS 1.0 la gamba OOS è **degenere (0 giorni)** per costruzione.
   **Atteso: NON rilanciare.** Fa fede l'`ESITO:` finale della riga.
2. **Tetto ~100k barre** (regola 25/08): 21 mesi di **M5** possono eccedere
   ~1,3 anni di tetto. La riga cerca da sola la **firma del tetto** (Barre
   Valutate IDENTICHE su simboli diversi, checklist punto 36) e confronta i
   giorni contati M5 vs M15: se compare nei RILIEVI, la finestra effettiva M5
   è più corta — **F1 resta leggibile** (è per-giorno sul denominatore
   CONTATO), campione e regime si dichiarano nella lettura.
