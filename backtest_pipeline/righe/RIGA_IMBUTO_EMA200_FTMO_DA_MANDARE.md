# 🔍 IMBUTO EMA200 DOW — **quanto spesso il prezzo ci schiva**, sedia `771531`

**22/09/2026** · branch `lavoro` · pin della riga: **`a043415df3ee75ec65cf1315684e1115f4000872`**
Script: `backtest_pipeline/righe/IMBUTO_EMA200_FTMO.ps1` (360 righe, `RUNNER_SOLA_LETTURA`)

> Nasce dalla foto di Claudio del **22/09 ore 11:05**: *«Mi ha schivato l'ordine pendente.
> Come mai?»* — e dal fatto che **l'EA sta già scrivendo la risposta da solo**
> (`InpLogImbuto=true` nel preset in campo). Questa riga va a prenderla. **Non la stima.**

---

## 🟢 COSA MISURA, IN UNA RIGA

> **Quante volte la sedia ha PIAZZATO i suoi due limiti, e quante volte quei limiti sono
> stati RIEMPITI invece che scaduti inevasi.**

### 🧩 Perché la domanda ha senso: la ricostruzione dallo screenshot

Dai soli numeri sul telefono di Claudio, e dal sorgente, i conti si chiudono **due volte per
ogni grandezza** — è così che la sedia è stata identificata:

| grandezza | prima strada | seconda strada |
|---|---|---|
| **ATR(14) H1** | `SL − ordine2` = **67,09** (è `1,0 × ATR`, r.358) | `ordine2 − ordine1` = **67,08** (è `0,5 × ATR`, r.356-357) |
| **EMA200 H1** | `ordine1 + 0,2 × ATR` = **52170,78** | `ordine2 − 0,3 × ATR` = **52170,77** |
| **TP a 2,00R** | `InpTP_RR=2.0` → **51956,10** | 🎯 **è il numero stampato sul grafico** |
| **rischio per ordine** | `13,67 × 67,09 × 0,871` = **798,8 €** | `9,11 × 100,63 × 0,871` = **798,5 €** |

Il rischio per ordine è **0,998%** di 80.000 — e `ABTG_EMA200.mq5` **r.361** dice
`riskPct = InpRiskPercent / nOrders` = `2,00 / 2` = **1,00%**. *(Il valore per punto
`0,871` è misurato in casa: `report/STOP_VS_SPREAD_FTMO_2026-09-20.md` r.108.)*

🟢 **E la risposta al «come mai» di quel singolo giorno è già data**: un **SELL LIMIT si
riempie sul BID**, e il grafico MT5 **è disegnato sul BID** → nessuno spread nascosto,
il ritorno si è semplicemente fermato prima. *(L'illusione «me l'ha schivato di un pelo»
vive sui **BUY**, che si riempiono sull'**ASK**, invisibile sul grafico bid.)*
🔴 **Quello che NON si sa è la FREQUENZA**, ed è l'unica cosa che decide se c'è un problema.

---

## ① 🖥️ DOVE MANDARE QUESTA STRINGA

> ## 🖥️ **finestra PowerShell sul VPS.**
> **Bersaglio: i LOG del terminale FTMO `541452707` (`C:\FTMO`), in SOLA LETTURA.**
>
> 🔴 **COSA NON VIENE TOCCATO — e qui non è una promessa, è una sequenza.** Le cartelle dati
> del **REALE `10105439`** (`C:\BCM_Reale`), del **piccolo `50503392`**, del **100k
> `50504263`**, del **banco `50504400`** (`C:\MT5_Backtest`), del **manuale `50503635`**,
> di **Pepperstone** e di **Tickmill** vengono **ESCLUSE PER HASH prima che venga aperto un
> solo file** (`$HASH_NOTI`, r.79-88). Sul REALE **non viene letto nemmeno `origin.txt`**.
>
> ✋ **E QUI VALE IL CONTRARIO DI UN ROUND: LASCIA MT5 APERTO.** I log si leggono **in
> condivisione** (`FileShare::ReadWrite`, classe 163) **mentre il terminale opera**. Chiudere
> i terminali qui non serve e farebbe solo perdere i tick della giornata.
>
> 🟠 **Il COMPUTERNAME del VPS non lo conosco e non me lo invento.** Quindi la guardia è
> fatta al contrario, e la vera identificazione è **positiva e sui dati**:
> **(a)** la riga **si rifiuta di partire sul PC di backtest `DESKTOP-H4D7CAJ`** (l'unico
> nome che il repo conosce per certo — 89 occorrenze) perché lì i log FTMO non esistono e
> risponderebbe «zero», che **non è un numero**;
> **(b)** lo script **certifica** la cartella cercando il conto **`541452707`** *e* la parola
> **FTMO** dentro il giornale. **Se nessuna cartella certifica, MUORE** (uscita 2) invece di
> leggere a caso. Una certificazione sul dato vale più di un nome di macchina.

```powershell
& { $ErrorActionPreference='Stop'; $pin='a043415df3ee75ec65cf1315684e1115f4000872'; if($env:COMPUTERNAME -eq 'DESKTOP-H4D7CAJ'){ throw 'VIETATO: questa riga NON va sul PC di backtest. I log FTMO stanno sul VPS. Qui non troverebbe niente e ti direbbe zero, che non e un numero.' }; $w="$env:USERPROFILE\abtg_sonda"; $p="$w\IMBUTO_EMA200_FTMO.ps1"; $dsk=[Environment]::GetFolderPath('Desktop'); New-Item -ItemType Directory -Force -Path $w | Out-Null; Remove-Item $p -Force -ErrorAction SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/IMBUTO_EMA200_FTMO.ps1?cb=$([guid]::NewGuid().ToString('N'))" -OutFile $p -ErrorAction Stop; if(-not (Test-Path $p)){ throw 'DOWNLOAD FALLITO' }; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_IMBUTO_EMA200_FTMO_v1' -Quiet)){ throw 'SCRIPT VECCHIO: manca MARCATORE_IMBUTO_EMA200_FTMO_v1' }; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'RUNNER_SOLA_LETTURA' -Quiet)){ throw 'SCRIPT SENZA IL BOLLO DI SOLA LETTURA: non lo eseguo' }; if(Select-String -Path $p -SimpleMatch -Pattern 'Stop-Process' -Quiet){ throw 'LO SCRIPT CHIUDEREBBE PROCESSI: una sonda di sola lettura non lo fa. Non lo eseguo.' }; $ErrorActionPreference='Continue'; Write-Host 'BERSAGLIO: i LOG del terminale FTMO 541452707 (C:\FTMO), in SOLA LETTURA. Nessun terminale viene toccato, chiuso o modificato: ne il REALE 10105439, ne il piccolo 50503392, ne il 100k 50504263, ne il banco 50504400, ne Pepperstone, ne Tickmill. Le loro cartelle dati vengono ESCLUSE PER HASH prima di aprire un file.' -ForegroundColor Cyan; Write-Host 'LASCIA MT5 APERTO: qui serve il contrario di un round -- i log si leggono in condivisione mentre il terminale opera.' -ForegroundColor Yellow; & powershell -NoProfile -ExecutionPolicy Bypass -File "$p" -ContoAtteso 541452707 -Giorni 10; $rc=$LASTEXITCODE; Write-Host ('   esito sonda: codice ' + $rc + '   (0=LETTO  2=FERMO, e nel referto c e scritto perche)') -ForegroundColor Yellow; Write-Host 'SUL DESKTOP TROVI: la cartella IMBUTO_EMA200_FTMO_<data> e lo zip omonimo, pronto da mandare.' -ForegroundColor Green; Get-ChildItem $dsk -Filter 'IMBUTO_EMA200_FTMO_*' -ErrorAction SilentlyContinue | Select-Object Name,Length,LastWriteTime | Format-Table -AutoSize }
```

📅 **Cosa deve leggere Claudio**: la riga `lanciata il :` in testa al referto — **dev'essere
di oggi**. Il 17/08 un referto stantio è stato rimandato **due volte** in buona fede.

---

## ② 🚦 I TRE BOLLI CHE LA RIGA CONTROLLA PRIMA DI ESEGUIRE

Oltre al marcatore di versione, questa riga verifica **che lo script sia davvero innocuo**,
e si rifiuta di eseguirlo altrimenti:

| bollo | cosa impedisce |
|---|---|
| `MARCATORE_IMBUTO_EMA200_FTMO_v1` | eseguire una copia vecchia (regola del 10/08) |
| `RUNNER_SOLA_LETTURA` | eseguire uno script che ha perso il suo mandato di sola lettura |
| 🔴 **assenza di `Stop-Process`** | eseguire qualcosa che possa **chiudere un terminale**. Le righe dei round ce l'hanno per forza; **una sonda no**, e la riga lo verifica invece di fidarsi |

---

## ③ 📐 LE TRE FONTI, E COSA CIASCUNA **NON** PUÒ DIRE

🔴 **Dichiarate nello script PRIMA dei numeri (r.35-70), non dopo.**

| passo | fonte | portata | 🔴 limite |
|---|---|---|---|
| **3** | imbuto, scheda Esperti | **PER-EA** — l'unico numero separabile per sedia | **L1**: la riga di un giorno la scrive il **primo tick del giorno dopo** (`ImbutoGiro()` r.239-248) → **il giorno completo più recente è IERI** |
| **4** | giornale | **PER-SIMBOLO** | **L3**: il giornale **non porta il magic**, e su `US30.cash` operano **tre** sedie (`770202`, `770511`, `771531`) che usano **tutte** pendenti → le righe `expired` **non sono separabili** |
| **5** | CSV TradeExporter | **PER-MAGIC** | **L4**: contiene **solo le posizioni CHIUSE** (r.182) e si riesporta ogni 30' → una posizione viva non c'è, e *«piazzati meno aperti»* **sovrastima** gli schivati |

⚠️ **L2 — due orologi nella stessa riga.** Il **prefisso** del log è in **ora locale del PC**
(sul VPS: italiana); il campo `giorno AAAA.MM.GG` **dentro** la riga viene da `TimeCurrent()`,
cioè **ora server** (FTMO = italiana **+1**). Lo script stampa **tutti e due, etichettati**.

🔴 **E la cosa che non va fraintesa: «zero righe imbuto» NON vuol dire «non ci schiva mai».**
Lo script elenca le quattro cause vere (preset con `InpLogImbuto=false`, sedia staccata o muta,
giorno non ancora cambiato, binario in campo più vecchio del sorgente) e lo scrive **in rosso**.

---

## ④ 🧪 IL COLLAUDO — fatto su un albero dati **simulato**, coi contro-esempi

Non «ho riletto il codice»: **l'ho fatto girare** contro una finta cartella `MetaQuotes\Terminal`
costruita apposta, con dentro una trappola per ogni cosa che poteva andare storto.

| contro-esempio | esito |
|---|---|
| cartella del **REALE `10105439`** presente | ✅ **ESCLUSA per hash**, nessun file aperto |
| cartella con `origin.txt` = *BCM Markets MT5 Terminal* | ✅ **ESCLUSA per nome** |
| `-ContoAtteso 999999999` (nessuna cartella certifica) | ✅ **FERMO, uscita 2** — non legge a caso |
| `-ContoAtteso 10105439` (qualcuno passa il REALE) | ✅ **FERMO subito**, prima di qualsiasi lettura |
| riga imbuto di **un altro EA** nello stesso log | ✅ **non entra** nel conteggio |
| il regex `ARMATE` contro *«CANDIDATE valutate 24»* | ✅ **non aggancia** |
| CSV con `magic` **771531** e **770202** mescolati | ✅ tiene 771531, **scarta** 770202 |
| righe imbuto **costruite dal sorgente MQL5** (r.212-235) | ✅ ARMATE, tentati, PIAZZATI letti giusti |

🟠 **E il collaudo ha trovato DUE difetti veri, corretti prima di consegnare:**
1. se `[Environment]::GetFolderPath('Desktop')` torna **vuoto**, il referto si perdeva con un
   errore di binding criptico → ora **ripiega** e **dice dove è finito**;
2. 🔴 `$env:TEMP` nullo faceva **esplodere lo script DOPO** aver prodotto i numeri buoni,
   portandosi via il referto → **il file temporaneo è stato tolto del tutto**: il CSV si
   converte **in memoria**, che per una sonda di sola lettura è anche più corretto.

**Strato 1 (deterministico)** — e **ha morso, alla prima passata**:

🔴 **BLOCCANTE, classe 165.** Dentro `& { }` lo `Stop` era **ancora attivo** quando parte
`& powershell`: su PS 5.1 lo **stderr di un comando nativo diventa errore TERMINANTE** e
ammazza il resto della riga. Conseguenza concreta: la sonda girava, ma **l'elenco finale sul
Desktop non veniva mai stampato** — e a schermo sarebbe sembrata una raccolta riuscita.
✅ Corretto: `$ErrorActionPreference='Continue'` **dopo** i tre bolli, prima dell'esecuzione.

🟠 **E un rilievo che è ironico, ma va letto e non liquidato**: il cancello segnala *«questa
riga può TERMINARE un processo»*. **Ha ragione a segnalarlo**, perché nella riga compare la
stringa letterale `Stop-Process`. 👉 A leggerla, però, sta **dentro il `throw` del terzo
bollo**: serve a **rifiutare** uno script che chiudesse processi. **Nessuna `Stop-Process`
viene eseguita**, né dalla riga né dallo script (che ne ha **zero**). Tengo la stringa
letterale invece di mascherarla: un controllo leggibile vale il falso positivo.

Dopo la correzione: `controlla_riga.py --oggetto md` → **nessun difetto meccanico** · parser
PowerShell sullo script **0 errori** · sulla riga **0 errori** · **una sola riga fisica**
(2286 byte) · **zero caratteri non-ASCII** in tutto il `.ps1` (regola del 17/08) · URL raw al
pin **200**.

**🕳️ Cosa resta NON coperto**
- **Il COMPUTERNAME del VPS**: non è in repo, non l'ho inventato (vedi la guardia al contrario).
- **Che il binario `.ex5` in campo abbia davvero l'imbuto**: il `.set` di repo porta
  `InpLogImbuto=true`, ma **il binario non l'ho misurato** — e questa flotta ha già avuto uno
  scarto sorgente/binario (`ABTG_EMA200` stessa, 690 righe contro 486 in campo). **Se l'imbuto
  fosse muto, il passo 3 esce vuoto e lo dice.**
- **Il numero finale**: questa riga **lo va a prendere**, non lo anticipa. Qualunque cifra io
  scrivessi adesso sarebbe inventata.

🔴 **E questa riga non propone NIENTE.** Se il rapporto fosse brutto, la manopola che lo governa
è `InpOrder1Atr` (oggi **0.20**, default dell'EA **0.10**) — ma spostarla è **un ROUND**, non
una modifica in campo, **e la decide Claudio**.
