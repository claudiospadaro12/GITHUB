# 🌙 STASERA — il foglio operativo della serata FTMO (domenica 20/09/2026)

> **Questa è l'unica pagina da tenere aperta.** Tutto quello che c'è qui dentro è **copiato**
> da sette documenti della notte: nessun numero è stato rimisurato o riderivato qui.
> Il *perché* di ogni riga sta nel documento citato accanto.
> 🚫 **Niente conto reale `10105439`. Nessuna taglia scelta da questo foglio. Nessun forward.**

---

# 🚦 IL SEMAFORO — cinque cose VERE prima di AutoTrading ON

> **Se anche una sola è FALSA, il pulsante non si preme.**

| # | deve essere VERO | oggi | chi lo rende vero |
|---:|---|---|---|
| **S1** | 🔴 **La TAGLIA è firmata.** I preset che si installano portano **tre valori diversi**: `0,65%` su `770101`/`770411`/`770202`/`771531` · **`1,00%`** su `770511` e `770260` · `1,30%` sui tre PostNews (`SCHIERAMENTO_FTMO` §⑨, verificato sul disco). Flotta mista = **140.576 $ = 140,6%** di margine a 1:15; tutte a 0,65% = **116.210 $ = 116,2%** (`NOTTE_2026-09-20` §7) | ❌ **[NON DECISA]** | ✍️ **solo Claudio** |
| **S2** | 🔴 **L'orologio è MISURATO, non inferito.** Tutti e 10 i preset sono rimappati su **FTMO = BCM + 2** (`PRESET_FTMO_OROLOGIO` §①-②). Quel `+2` è **[LETTO-VIA-SEARCH, 13/08]** (`docs/REGOLAMENTO_FTMO_2026-08.md` r.130), **mai misurato da noi** | ❌ `[INFERITO]` | passo **5** (10 secondi) |
| **S3** | 🔴 **I nomi dei simboli FTMO sono confermati a video.** Su FTMO possono chiamarsi `US30`, `GER40`/`DE40`, `NAS100`/`US100`, non `U30USD`/`D30EUR`/`NASUSD` (`SCHIERAMENTO_FTMO` §④ passo 6, §⑦.5) | ❌ `[NON NOTO]` | passo **4/5** |
| **S4** | 🔴 **Il margine regge le sedie che si accendono.** A **1:15** le sette chiedono **121,9%** del conto a 0,65% e **187,5%** a 1,00% (`PACCHETTO_SCHIERAMENTO_PROP` §⓪.②). Il danno non è lo stop-out: è l'**ordine RIFIUTATO in silenzio**, e colpisce sempre le americane (§⓪.③) | ❌ `[INFERITO]` — **nessuna specifica di contratto FTMO è mai stata letta** | passo **5** |
| **S5** | 🔴 **L'F7 di `771531` e `770511` è FIRMATO.** Il pacchetto li tiene in **HOLD (buco B9)**: l'F7 **cambia il sizing** e la firma di Claudio copriva *«compila»*, non *«e la taglia cambia»* (`PACCHETTO…` §1.2 e B9 · `FIRME_2026-09-19_SERA.md` §③). 🔴 **La lista dello schieramento NON riporta questo hold** (`SCHIERAMENTO_FTMO` §④ passo 5 dice «F7 sugli altri 7») → **contraddizione aperta, vedi §CONTRADDIZIONI** | ❌ **[NON FIRMATO]** | ✍️ **Claudio: una riga di sì** |

---

# 🪑 LE SEDIE DI STASERA — SEI + il Guardian

*(orari FTMO = già dentro i `.set` di `mql5/Presets/FTMO/`; ora IT = orario di mercato reale)*

| magic | simbolo BCM | TF | preset da caricare | ora **FTMO** | contratto misurato (PF · n · DD · frequenza) |
|---|---|---|---|---|---|
| **`770101`** DAX Apertura | `D30EUR` | **M5** | `ABTG_DAX_Apertura_EU_770101_FTMO.set` | Session **10** · Close **19** | PF **1,41105** OOS · n **270 deal (193 pos)** · DD **4,35%** @0,65% · **0,699-0,705 op/gg** |
| **`770411`** MaxMin DAX Short | `D30EUR` | **M15** | `ABTG_MaxMinNotte_DAX_Short_770411_FTMO.set` | Box **1→6** · Place **9** · Cutoff **10** · Close **19** | PF **2,05** (n 41) · DD **1,27%** @1,0% · **~1,7 op/mese** |
| **`770202`** Dow Apertura | `U30USD` | **M5** | `ABTG_Dow_Apertura_US_770202_FTMO.set` | Session **16** · Close **19** | PF **1,270** OOS · n **130 deal (96 pos)** · DD **4,22%** · 0,348 op/gg backtest / **0,129 in campo** |
| **`771531`** EMA200 Dow 🛑 **S5** | `U30USD` | **H1** | `ABTG_EMA200_771531_FTMO.set` | Cutoff **21** · FriClose **22** *(tutti e due INERTI)* | PF **1,52** OOS · n **517** · **30/30 PASS** walk-forward tick · DD **7,21%** · ~33 op/mese |
| **`770511`** SuperWave Dow 🛑 **S5** | `U30USD` | **H1** | `ABTG_SuperWave_DOW_H1_770511_FTMO.set` | **0-24, invariato** | PF **1,52** (9/9 combo) · OOS H1 **1,328** n **143** · DD **4,0%** · ~10,8 op/mese |
| **`770260`** Nasdaq RETEST | `NASUSD` | **M5** | `ABTG_Nasdaq_Apertura_US_RETEST_770260_FTMO.set` | Session **16** · Close **19** | PF **1,10936** OOS · n **94** · DD **3,6753%** 🔴 **merito SOSPESO per campione (n<150 in IS e OOS)** |
| **`779001`** Guardian | un grafico qualsiasi | — | `ABTG_Guardian_FTMO_2Step.set` | 🔴 **`InpDailyResetHour` 23 → `1` A MANO** | utility, non trada. `InpStartBalance=100000` · daily **4,9%** · totale **9,9%** · pausa **4,0%** · cap C1 **3,25%** · `InpAction=0` = **CHIUDI+BLOCCA** |

### ❌ PERCHÉ NON C'È — le escluse, per nome

| esclusa | perché NON c'è stasera | fonte |
|---|---|---|
| **`770402`** MaxMin ORO | 🔴 **bersaglio non deciso**: il binario in campo (`08239510`, 28/07) ha il **breakeven annegato nel parziale a 0,01 lotti** = rischio attivo; HEAD (`7d0da9f9`) rende effettivo `InpOneTradePerDay` e **cambia la frequenza con cui il contratto è stato misurato**. Serve una corsa di controllo + firma. ⚠️ **Il suo preset FTMO ESISTE in repo e NON viene installato apposta**: un preset senza il suo EA è una trappola | `SCHIERAMENTO_FTMO` §6.2 · `PACCHETTO…` B8 |
| **`770261`** Nasdaq BREAKOUT | 🔴 **fuori per MERITO**: PF OOS **1,06338** su n 108, sotto la soglia **1,10** firmata in casa | `PACCHETTO…` §1.2 |
| **`770611`** ORB Dow | fuori rosa: **1 vinta su 8** in campo, **−209,18**, DD promesso **9,92%** di confine | `PACCHETTO…` §③ |
| **`770250`** Nasdaq | resta dov'è (piccolo `50503392`). 🟢 Su FTMO `NASUSD` ha **una sola** sedia → la collisione `PositionClose(_Symbol)` non può esistere | `PACCHETTO…` §3.0 |
| 📰 **`771202`/`771203`/`771204`** PostNews | 👉 **decisione di Claudio, §PostNews in fondo.** I preset e l'EA **vengono installati lo stesso** dalla riga del passo 6, a meno di `-SenzaPostNews` | `SCHIERAMENTO_FTMO` §5.2 |

---

# 📋 I PASSI, in ordine di esecuzione — **62-105 minuti** (`SCHIERAMENTO_FTMO` §①)

> 🟢 **E se la serata salta non si perde niente**: su **96 posizioni vere** nessuna sedia della rosa
> ha **mai** aperto di domenica (zero volte). Il primo appuntamento è **lunedì 07:00-08:00**.
> **La notte è un cuscinetto, non una scadenza** (`PACCHETTO…` §A.1).

### 1️⃣ Comprare la challenge e ricevere le credenziali · ✍️ Claudio · browser · **5-20 min**
✅ **Riuscito se**: arrivano numero di conto, password *trader* e server per mail.
🔴 **Se fallisce**: si ferma tutto qui. Non c'è nessun passo che si possa anticipare senza il conto.

### 2️⃣ Installare MT5 FTMO in `C:\MT5_FTMO` · ✍️ Claudio · 🖥️ **VPS** · **10-20 min**
🖥️ **BERSAGLIO: il VPS, installazione nuova.** 🚫 **Non** dentro `C:\Program Files\BCM Markets MT5 Terminal` (`50503392`), **non** `...-V3` (`50504263`), 🔴 **non** `C:\BCM_Reale` (`10105439`), **non** `C:\MT5_Backtest` (`50504400`), **non** `C:\MT5_MANUALE` (`50503635`), **non** Pepperstone, **non** Tickmill.
✅ **Riuscito se**: esiste `C:\MT5_FTMO\terminal64.exe` e le **sette** cartelle dati di casa sono intatte.
🔴 **Se fallisce**: riprovare con l'installer della dashboard FTMO. Non installare "sopra" un MT5 esistente.

### 3️⃣ Login col conto FTMO · ✍️ Claudio · 🪟 **terminale FTMO** · **2-5 min**
✅ **Riuscito se**: i prezzi di Market Watch **si muovono** (domenica sera, dopo la riapertura) e il numero in alto a sinistra è quello FTMO — **non** 50503392, **non** 50504263, **non** 10105439.
🔴 **Se fallisce**: 🚫 **non si va al passo 4**. Senza login il giornale è vuoto e la sonda **rifiuta**.

### 4️⃣ Foto di riconoscimento dei terminali · ✍️ Claudio · 🖥️ **finestra PowerShell sul VPS** · **1 min**
🖥️ **BERSAGLIO: PowerShell sul VPS. Sola lettura, non tocca nessun terminale.**
```powershell
Get-Process terminal64 | Select-Object Id, MainWindowTitle, Path
```
*(copiata da `SPECIFICHE_E_GRIGLIA_H4_2026-09-20.md` §Istruzioni per Claudio)*
✅ **Riuscito se**: compare **una riga con `C:\MT5_FTMO`** accanto alle altre. 🔴 Da qui in poi ogni gesto si fa sulla finestra con **quel** `Path`.

### 5️⃣ ▶️ **LA SONDA DI PRE-VOLO** · 🤖 una riga · 🖥️ **PowerShell sul VPS** · **~secondi**
🖥️ **BERSAGLIO: finestra PowerShell sul VPS. SOLA LETTURA: non scrive dentro nessun terminale.** 🪟 MT5 FTMO va lasciato **aperto e connesso**. 🚫 Non tocca `50503392`, `50504263`, **`10105439`**, `50504400`, `C:\MT5_MANUALE`, Pepperstone, Tickmill: **li elenca per escluderli**.
🔑 **`IL_TUO_CONTO_FTMO` va sostituito col numero arrivato per mail.**
```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='e09296b9ad11794e39047c7ecccdf5216179c0aa'; $conto='IL_TUO_CONTO_FTMO'; $p="$env:USERPROFILE\PREVOLO_FTMO.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/PREVOLO_FTMO.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_PREVOLO_FTMO_v1' -Quiet)){ throw 'SCRIPT VECCHIO: manca il marcatore MARCATORE_PREVOLO_FTMO_v1.' };
    $global:LASTEXITCODE = 0; & $p -ContoAtteso $conto;
    if($LASTEXITCODE -eq 0){ Write-Host 'FATTO (uscita 0): tutte le caselle automatiche sono chiuse. Manda lo zip che trovi sul Desktop.' -ForegroundColor Green }
    elseif($LASTEXITCODE -eq 2){ Write-Host 'GIRATA (uscita 2): bersaglio CERTIFICATO, e alcune caselle restano da leggere A MANO -- sono elencate qui sopra, una per una. Manda lo zip che trovi sul Desktop.' -ForegroundColor Yellow }
    else { Write-Host ('RIFIUTATA (uscita ' + $LASTEXITCODE + '): non ho misurato niente, e ti ho scritto sopra il perche. NON aprire grafici. Manda tutto l output qui sopra.') -ForegroundColor Red } }
```
*(copiata alla lettera da `backtest_pipeline/righe/RIGA_PREVOLO_FTMO_DA_MANDARE.md`, pin `e09296b9`)*
✅ **Riuscito se**: uscita **0** o **2**. Sul Desktop c'è `PREVOLO_FTMO_<data>_<ora>.zip`. 🔴 **La `data:` in cima al referto dev'essere di ADESSO**: se è vecchia, stai guardando uno scroll di prima.
🔴 **Se esce 1 (RIFIUTO)**: 🚫 **non si aprono grafici e non si va al passo 7.** Mandare tutto l'output.

### 6️⃣ 👀 **LE DUE LETTURE A MANO CHE VALGONO LA NOTTE** · ✍️ Claudio · 🪟 **FTMO** · **5 min**
1. **Orologio**: Market Watch (`Ctrl+M`) → tasto destro → Colonne → **Ora**, contro l'orologio di Windows.
   🔴 **TRAPPOLA DI OGGI (classe 479)**: **a mercato chiuso quella colonna non è un orologio, è il timestamp dell'ULTIMO TICK — di venerdì sera**, e le 23:00 *sembrano* un'ora plausibile. 👉 **Guarda la DATA accanto all'ora: se non è quella di oggi, la lettura NON vale.** Gli indici riaprono la domenica sera: si legge **dopo** la riapertura (`PREVOLO_FTMO` §⑥).
   ✅ **Market Watch avanti di 2 su Windows** → i dieci preset vanno bene. **Avanti di 3** → vanno rigenerati (`rimappa_preset_ftmo.py`, −1 ora). **0 / +1** → 🔴 **si butta tutta la colonna FTMO e mi si chiama**.
2. **Specifiche**: tasto destro sul simbolo → **Specification**, su `US30` · `GER40`/`DE40` · `NAS100`/`US100` · `XAUUSD`. Servono **Contract size · Digits · Point · Initial margin · Tick value**. 📸 **quattro screenshot.**
   🟢 **Controprova che vale più di uno screenshot** (`PREVOLO_FTMO` §② casella 6): *Initial margin* del Dow per **1 lotto** → con Dow a 46.000, **1:100 ≈ 460 $**, **1:15 ≈ 3.067 $**. Due numeri che non si somigliano.
🔴 **Se `Digits` è diverso da 2 su `US30`**: `InpBufferPoints=1000` passa da **10,00** a **100,0** punti indice — il livello di rottura si sposta di **dieci volte**. 🚫 **Non si aggiusta a occhio: è una firma di Claudio.** Fermarsi e chiamare.

### 7️⃣ ▶️ **LA RIGA CHE INSTALLA TUTTO** · 🤖 · 🖥️ **PowerShell sul VPS** · **~3 s**
🖥️ **BERSAGLIO: finestra PowerShell sul VPS.** ✋ **Nessun MT5 da aprire o chiudere** — il terminale FTMO può restare aperto. La riga **scrive in UNA SOLA cartella**, quella FTMO che identifica da sola, e **solo** in `MQL5\Experts`, `MQL5\Include`, `MQL5\Presets`.
🚫 **Non tocca**: `50503392` (`C:\Program Files\BCM Markets MT5 Terminal`) · `50504263` (`… -V3`) · 🔴 **`10105439` (`C:\BCM_Reale`)** · `50504400` (`C:\MT5_Backtest`) · `50503635` (`C:\MT5_MANUALE`) · Pepperstone · Tickmill.
🔑 **Sostituire `IL_TUO_CONTO_FTMO`.** ➕ Per escludere i tre PostNews: aggiungere **`-SenzaPostNews`** dopo `-Pin $pin` (vedi §PostNews).
```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='489f98c02268a9dc976fc23ccbb8f48959fd4642'; $conto='IL_TUO_CONTO_FTMO'; $p="$env:USERPROFILE\SCHIERA_FTMO.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/SCHIERA_FTMO.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_SCHIERA_FTMO_v2' -Quiet)){ throw 'SCRIPT VECCHIO: manca il marcatore MARCATORE_SCHIERA_FTMO_v2.' };
    $global:LASTEXITCODE = 0; & $p -ContoAtteso $conto -Pin $pin;
    if($LASTEXITCODE -ne 0){ Write-Host ('FERMATO (uscita ' + $LASTEXITCODE + '): NON premere F7. Manda tutto l output qui sopra.') -ForegroundColor Red }
    else { Write-Host 'FATTO (uscita 0). Sul Desktop trovi la cartella SCHIERA_FTMO_<data> e lo zip: dentro ci sono il referto e i file scaricati.' -ForegroundColor Green } }
```
*(copiata alla lettera da `SCHIERAMENTO_FTMO_2026-09-20.md` §②, pin `489f98c0`)*
✅ **Riuscito se**: uscita **0** e la tabella stampa `C E, ED E QUELLO GIUSTO` su **tutte** le righe (9 sorgenti + 10 preset). 🕐 Oltre **120 s** è la rete, non lo script.
🔴 **Se esce ≠ 0**: **NON premere F7**, mandare l'output. In **tutti** i rifiuti **zero file finiscono nel terminale** — è una proprietà del disegno, provata su 13 contro-esempi.
👀 **Da leggere nell'output**: la riga gialla `InpDailyResetHour BCM 23 -> FTMO 1 <<< DA CAMBIARE A MANO` e la riga **SEDIA SOSPESA `770402`**.

### 8️⃣ 🔨 **F7 sul Guardian, PER PRIMO** · ✍️ Claudio · 🪟 **MetaEditor del terminale FTMO** · **3 min**
🪟 **BERSAGLIO: MetaEditor di `C:\MT5_FTMO`.** 🚫 **NON** quello di `50503392`, 🚫 **NON** quello del reale `10105439`.
File: **`ABTG_Guardian.mq5`** (v1.12, pin `d884f7e1`, **498 righe**).
✅ **Riuscito se**: `0 errors, 0 warnings`.
🔴 **Se muore su `cannot open include file`**: **si ferma tutto** e mi si manda l'errore. È l'unico modo in cui l'include può essere sbagliato, e si scopre al **primo** colpo invece che al nono.

### 9️⃣ 🔨 **F7 sugli altri EA** · ✍️ Claudio · 🪟 **MetaEditor FTMO** · **10-20 min**
`ABTG_DAX_Apertura_EU` (2425) · `ABTG_Dow_Apertura_US` (2205) · `ABTG_Nasdaq_Apertura_US` (2624) · `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` (619) · `ABTG_PostNews` (666, solo se i PostNews entrano)
🛑 **`ABTG_EMA200` (552) e `ABTG_SuperWave_DOW_H1_Ottimizzato` (645): SOLO SE S5 È FIRMATO.**
✅ **Riuscito se**: `0 errors` su ciascuno. ⚠️ `ABTG_EMA200` **non cambia numero di versione** (resta 1.00): si riconosce solo dal conteggio righe. `SuperWave` passa **1.00 → 1.01**.
🔴 **Se uno fallisce**: mandare **il testo dell'errore**. 🟢 Attenuante misurata: le API usate erano già tutte presenti, e la stessa forma gira già in campo in `ABTG_ORB_Ottimizzato` v1.04. **È il passo che può far saltare la sera** — e va bene, perché la prima operazione vera è lunedì.

### 🔟 📊 Aprire i grafici · ✍️ Claudio · 🪟 **FTMO** · **10 min**
Uno per sedia, col **nome FTMO** letto al passo 6: DAX **M5** · DAX **M15** · Dow **M5** · Dow **H1** ×2 · Nasdaq **M5** (+ EURUSD M5 ×2 e USDJPY M5 se entrano i PostNews).
✅ **Riuscito se**: TF giusto nella barra del titolo di ogni grafico.

### 1️⃣1️⃣ ⚙️ Caricare i preset + **la taglia** + `InpDailyResetHour=1` · ✍️ Claudio · 🪟 **FTMO** · **10-15 min**
🟢 **Gli orari sono GIÀ rimappati dentro i `.set`**: non si tocca nessun `InpSessionHour`. La riga del passo 7 li stampa con `(gia rimappato: NON TOCCARE)`.
🔴 **Restano DUE valori a mano**: **(a)** `InpDailyResetHour` **23 → 1** sul preset del Guardian — è l'unico senza marcatore, la riga lo grida in giallo; **(b)** 🔴 **`InpRiskPercent`, che è la firma S1 di Claudio.**
⚠️ **Guardare anche**: `InpUsaGuardian` (default **`true`** ovunque, verificato ai pin) · su `770411` **`InpMaxSpread=0` = filtro di spread SPENTO** su un broker di cui non conosciamo gli spread (`SCHIERAMENTO_FTMO` §5.3 e §⑦.8): **firmare o misurare**.
🔴 **Se un preset carica meno input del previsto**: è malformato → fermarsi (`PRESET_FTMO_OROLOGIO` N10).

### 1️⃣2️⃣ 🛡️ Attaccare `ABTG_Guardian` · ✍️ Claudio · 🪟 **FTMO** · **5 min**
✅ **Riuscito se**: il pannello compare sul grafico e scrive `InpStartBalance=100000`, limite **4,9%** / **9,9%**, e `CHIUDI+BLOCCA`.

### 1️⃣3️⃣ ▶️ **AutoTrading ON** · ✍️ Claudio · 🪟 **FTMO** · **5 min**
🚦 **Solo se il SEMAFORO è tutto verde.**
✅ **Riuscito se**: il pulsante è **verde** e su ogni grafico la faccina in alto a destra è 🙂, non 🚫.

### 1️⃣4️⃣ ✅ La verifica di **lunedì mattina** · 🪟 **FTMO**, scheda Esperti/Giornale
Devono comparire, **all'ora di server FTMO**: `RETEST armato` per le Aperture, il piazzamento pendenti per i MaxMin. Primo appuntamento: **07:00-08:00 server FTMO**.
🔴 **ATTENZIONE**: i log MT5 sono in **ora LOCALE del PC** (italiana), il grafico è in **ora server**. Una riga datata `10:00` nel log è stata scritta alle **09:00 server FTMO**.

### ➕ In parallelo, se c'è tempo (NON bloccano lo schieramento)
- 📤 **Export H1 del Dow** — 🪟 **BERSAGLIO: il banco `50504400` (`C:\MT5_Backtest`)**, 🚫 non il piccolo, 🚫 non il reale, 🚫 non FTMO. Grafico `U30USD` **H1** → `Home` fino al **2024.09.26** → `Ctrl+S` → CSV `U30USD_H1.csv` sul Desktop. **3 minuti**, e chiude il rischio H4 di `770202` (§SE VA STORTO).
- 📐 **Misura del delta lotti** (`MISURA_LOTTI_U30USD_2026-09-19.md` §▶️, stringa **A** poi **B**, pin `fbd31099`) — 🪟 **BERSAGLIO: il banco `50504400`**. **20-60 min**. È ciò che scioglie **S5**.

---

# 🔴 SE VA STORTO

### 🎯 I due numeri da guardare, e sono solo due
| numero | valore | dove si legge |
|---|---|---|
| **Muro STATICO totale** | l'equity **non deve mai scendere sotto 90.000 $** (= −10% del **balance iniziale**, non trailing) | il pannello del Guardian · `docs/REGOLAMENTO_FTMO_2026-08.md` §2 |
| **Perdita giornaliera** | **−5%** sull'equity, contro la baseline del giorno | pannello Guardian (`InpDailyLossPct=4,9`, che scatta **prima**) |

🟢 **Il Guardian è tarato per fermarsi PRIMA del muro**: pausa a **4,0%**, emergenza a **4,9%** giornaliero e **9,9%** totale, `InpAction=0` = **chiude tutto e blocca**. E il v1.12 porta il fix del 06/09: **baseline giornaliera dall'EQUITÀ, non dal bilancio** — su FTMO è *quel* numero che boccia.
📌 **Taglia e muro, i numeri già misurati** (`METRO_PROP.md` rr.24-25, 65-71): **0,65% → p99 ≈ 8,1%** 🟢 · **1,00% → p99 12,47%** 🔴 *(sfonda il muro del 10% più di una volta su cento)* · **1,30% → `770101` da sola promette 9,40%** 🔴.

### 🧯 Cosa si spegne per primo, in ordine
1. **`770511` SuperWave** — è la più cara in margine (**29.901 $** a 0,65%/1:15, **46.001 $** a 1,00% = **46% del conto**) ed è l'**unica senza nessuna guardia oraria attiva** (`InpUseTimeWindow=false`, finestra `0-24` inerte). Ha già aperto all'alba: 31/08 **06:00** ×2, 07/09 **05:00** ×2. 👉 **Raccomandazione dei documenti (non divieto, la firma è di Claudio): accenderla PER ULTIMA, lunedì mattina**, per la zona grigia del **gap trading** (l'unica clausola FTMO che vale **anche in Challenge**). 💸 Costo onesto: **~10,8 op/mese, metà di lunedì** → spegnerla una notte **può costare un'operazione**. 🚫 **E non si tocca `InpUseTimeWindow`**: è un cambio di comportamento su una sedia viva.
2. **`770260` Nasdaq** — entra col **merito sospeso** (n 94 < 150 in tutte e due le finestre) e il suo DD viene da un binario pre-fix di sizing.
3. **`770202` Dow** — vedi il rischio H4 qui sotto.
🟡 **`771531` EMA200 NON si spegne**: è l'unica sedia che passa **tutti** i cancelli alla lettera (PF 1,52 · n 517 · 30/30 PASS). La sua ambiguità gap-trading si chiude con la **domanda al supporto** (già scritta dal 13/08, **mai inviata**, buco B4).

### ⚠️ Il rischio dichiarato su una sedia che si accende stasera — `770202`
`InpUseEmaFilter=true`, `InpFilterTF=H4`. Le barre H4 dei due broker **non cadono negli stessi istanti**: all'ingresso **BCM guarda la chiusura delle 11:00 UTC, FTMO quella delle 13:00 UTC**. 🔴 Su una sedia **solo-long** un bias opposto non peggiora l'ingresso: **lo CANCELLA** — il Dow potrebbe **non sparare mai** su FTMO. **[NON MISURATO]**: soglie già scritte — **<3%** il problema non esiste · **3-25%** si schiera dichiarando lo scarto · **>25%** su FTMO **non è la stessa sedia**. 🚫 **Non si spegne `InpUseEmaFilter`**: quel filtro è il motivo per cui la sedia ha PF 1,24 invece di 1,03 e DD 6,9% invece di 14,9%. Si chiude con l'export H1 di 3 minuti.

### ↩️ Come si torna indietro
- **Una sedia**: staccare l'EA dal suo grafico. Le posizioni aperte restano — si chiudono a mano se serve.
- **Tutte**: **AutoTrading OFF** (pulsante in alto). Nessun EA piazza più niente.
- **Un preset ritoccato a mano non va perso**: se si rilancia la riga del passo 7, la modifica manuale **sopravvive** e la versione del repo finisce accanto come `…_DAL_REPO.set` (contro-esempio **H**, eseguito).
- 🚫 **Non si reinstalla niente sopra i terminali BCM. Il piccolo `50503392` resta lo strumento di misura, il reale `10105439` non si tocca.**

---

# 📰 LA CASELLA DI CLAUDIO — i tre PostNews entrano stasera? ☐ SÌ ☐ NO

**I numeri, copiati:**

| | `771202` FOMC EURUSD | `771203` NFP USDJPY | `771201` ECB EURJPY *(gemella di `771204`)* |
|---|---:|---:|---:|
| **costo pieno vs pavimento 40×** | 🔴 **28,9×** | 🔴 **26,8×** | 🔴 **22,0×** *(→ **13,2×** dopo il trailing: **sfonda il pavimento duro 13,3×**)* |
| **PF · n · DD** | 🔴 **nessuno** — i CSV dicono `Trades = 0` | idem | idem |
| **frequenza di famiglia** | 🔴 **0,14 op/giorno** contro il pavimento di **1,00** | | |

➕ **Tre aggravanti scritte nei documenti**: **(a)** quei 28,9× sono calcolati su spread di **calma** (0,400 pip), mentre le sedie operano **10-45 minuti dopo un annuncio ad alto impatto**; **(b)** `InpMaxSpread=0` in tutti e tre = **filtro spread DISATTIVATO**; **(c)** 🔴 **`771203` NFP è CIECA per costruzione**: legge `abtg_news_postnews_2010_2025_UTC.csv`, ultimo evento **2025.07.03**, **zero eventi 2026**, e nessuno lo aggiorna → **zero ordini, per sempre** — e il canarino **non scatta** (conta 186 eventi *utili*, tutti passati).
➕ Il magic della ECB è stato corretto **`771202` → `771204`** (senza quella correzione la FOMC non avrebbe operato **mai**), e 🔴 **quella modifica è ancora IN ATTESA DI FIRMA** (`DA_FIRMARE.md` r.152-153).
🟢 **Quello che NON è un problema**: in **Challenge FTMO non c'è nessuna restrizione news**, per nessun tipo di conto. E nessuna delle tre apre dentro la finestra vietata ±2 min.

> ## 👉 **LA RACCOMANDAZIONE (non è una decisione): stasera NON entrano.**
> **Tre sedie senza PF, senza n e senza DD, che falliscono il cancello di costo di casa su numeri
> già ottimistici, una delle quali è muta per costruzione, su un conto vero il primo giorno.**
> La richiesta di Claudio (*«caricare i 3 grafici con i 3 preset»*) si onora **dopo**: riparato il
> calendario NFP e **misurato lo spread vero su FTMO** al passo 6.
> ✍️ **Come si esegue il NO**: aggiungere **`-SenzaPostNews`** alla riga del passo 7.
> ✍️ **Come si esegue il SÌ**: la riga com'è — e allora al passo 11 `InpRiskPercent` deve leggere
> **`1.3`** su tutti e tre (se legge `3` il preset non è stato caricato: è il default compilato, ed
> è il numero che il 10/09 è costato **1,4905%** invece dello 0,65%).

---

# 🔴 CONTRADDIZIONI FRA I DOCUMENTI — **non risolte qui, per firma**

| # | dove | A dice | B dice |
|---:|---|---|---|
| **C1** | **F7 di `771531` e `770511`** | `PACCHETTO…` §1.2 e **B9**: 🛑 **HOLD**, l'F7 **cambia il sizing**, serve una riga di sì di Claudio | `SCHIERAMENTO_FTMO` §④ passo 5: *«F7 sugli altri 7»*, **nessun hold**. 👉 **È S5 del semaforo. Va sciolto prima del passo 9.** |
| **C2** | **leva indici su conto Standard** | `PACCHETTO…` §⓪.②: **1:50** (tutta la tabella del margine è costruita su quello) | `NOTTE_2026-09-20` §Cosa aspetta Claudio: **1:100** · `PREVOLO_FTMO` §② casella 6: **1:100** ⇒ **il conteggio «quante sedie entrano» cambia**. Si chiude con l'*Initial margin* del passo 6 |
| **C3** | **quante sedie stasera** | `PACCHETTO…` §⑦: rosa di **SETTE** | `SCHIERAMENTO_FTMO` §6.2 + `NOTTE` : **SEI**, `770402` dichiarata sospesa. 🟢 Risolta a favore del più recente, con il motivo scritto in tabella |
| **C4** | **durata della catena** | `PACCHETTO…` §A.2: **75-125 min** | `SCHIERAMENTO_FTMO` §①: **62-105 min** (i preset arrivano già rimappati). 🟢 Usato il più recente |
| **C5** | **pin del Guardian** | `PACCHETTO…` §④ passo 8: Guardian **a HEAD** + include v1.20 | `SCHIERAMENTO_FTMO` §6.1: 🔴 **quella combinazione fa MORIRE l'F7** (tre funzioni cluster assenti in v1.20) → Guardian a **`d884f7e1` v1.12**. 🟢 Risolta: correzione esplicita del più recente |
| **C6** | **`.set` di `770260`** | `PACCHETTO…` **B6** e `SCHIERAMENTO_FTMO` §⑦.2: **non esiste in repo, bloccante** | `PRESET_FTMO_OROLOGIO` §⑤: **ricostruito e committato**. 🟢 **Verificato sul disco: c'è**, ed è nel manifesto al pin `489f98c0` |
| **C7** | **lettore delle specifiche FTMO** | `SPECIFICHE_E_GRIGLIA_H4` §①: `mql5/Scripts/ABTG_PrevoloFTMO_Specifiche.mq5` chiude **4 caselle e mezza** con un F7 | 🔴 **NON è nel manifesto di `SCHIERA_FTMO.ps1` al pin `489f98c0`** (nato dopo, commit `db71b3c9`): **la riga del passo 7 non lo copia**. Stasera le caselle 3-4-5 restano **a mano** |

---

*Fonti, per nome: `report/PACCHETTO_SCHIERAMENTO_PROP_2026-09-21.md` · `report/SCHIERAMENTO_FTMO_2026-09-20.md` · `report/PREVOLO_FTMO_2026-09-20.md` · `report/SPECIFICHE_E_GRIGLIA_H4_2026-09-20.md` · `report/PRESET_FTMO_OROLOGIO_2026-09-20.md` · `report/MISURA_LOTTI_U30USD_2026-09-19.md` · `report/PACCHETTO_POSTNEWS_TRE_GRAFICI_2026-09-19.md` · `report/NOTTE_2026-09-20.md` · righe: `backtest_pipeline/righe/RIGA_PREVOLO_FTMO_DA_MANDARE.md`, `backtest_pipeline/righe/SCHIERA_FTMO.ps1`, `backtest_pipeline/righe/MISURA_LOTTI_U30USD.ps1`. Preset verificati sul disco: `mql5/Presets/FTMO/*.set`, `mql5/Presets/ABTG_Guardian_FTMO_2Step.set`.*
