# 📬 R125 — LA RIGA DA MANDARE (bozza, IN ATTESA DEL CANCELLO)

> ⏳ **STATO: BOZZA.** Scritta il 10/09 sera dopo la firma di Claudio sui
> criteri. **NON e' ancora passata da `controlla_riga.py` ne' dall'agente
> `controllo-preventivo`.** Finche' non c'e' il PASS, questa riga **non si
> incolla**. Regola del 09/09.

**Criteri**: `backtest_pipeline/prove/R125_ORB_COSTO_CRITERI.md` — ✅ **FIRMATI**
da Claudio il **10/09/2026 sera**, a numeri non visti. Verbale:
`report/FIRMA_R125_2026-09-10.md`.
**Driver**: `righe/RIGA_ROUND_VPS.ps1` (marcatore `MARCATORE_RIGA_ROUND_VPS_v1`)
che a sua volta scarica `walkforward_generico.ps1`
(`MARCATORE_WALKFORWARD_GENERICO_v5_INCLUDE`).
**Costo**: 6 file · 33 celle · **66 passate** · **~7 minuti** (0,101 min/passata
misurato su R88) + compilazione e avvio → **sotto i 20 minuti** [STIMATO].

## 📌 IL PIN
`65ef4e096935fa4fc8694d1877e45113cce8fc1d` — e' il commit della **firma**.
✅ Verificato (classe 187, incrocio pin↔marcatore): a questo pin ci sono
**tutti e due** i marcatori e **tutti e sei** i file prova R125.

## 🖥️ IL TERMINALE — dichiarato, non riconosciuto a occhio
| | |
|---|---|
| **conto** | **50504400** |
| **cartella programma** | `C:\MT5_Backtest` |
| **cosa e'** | il demo **solo tester**, mai un EA attaccato |
| **come lo so** | misurato dal **giornale del terminale**, non da una tabella: `CODA_03_conti_dei_terminali_20260910_033002.log` — cartella dati `04C7A32B…`, `programma: C:\MT5_Backtest`, `CONTO 50504400`, HEDGING |

🛑 **Il driver ha le guardie dentro**: muore da solo se punta al **100k 50504263**
(`... -V3`) o al **REALE 10105439** (`C:\BCM_Reale`). Ma il parametro glielo
diciamo lo stesso, esplicito: **classe 204**, un `-TerminaleBacktest` vuoto fa
scegliere il terminale al **ripiego**, e sulla macchina ce ne sono tre.

⚠️ **`-Deposito 100000` va passato SEMPRE**: il default del driver e' **10.000**,
i file prova chiedono **100.000**. Senza, il round gira alla taglia sbagliata e
i numeri non sono confrontabili con R88.

---

## ▶️ PASSO 1 — LA PROVA A VUOTO (non lancia MT5, stampa e basta)

**Si incolla il blocco INTERO, e' UN comando solo.**

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='65ef4e096935fa4fc8694d1877e45113cce8fc1d';
    $p="$env:USERPROFILE\RIGA_ROUND_VPS.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_ROUND_VPS.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_ROUND_VPS_v1' -Quiet)){ throw 'SCRIPT VECCHIO: il pin non contiene RIGA_ROUND_VPS v1.' };
    $celle=@{r125a=7;r125b=5;r125c=7;r125d=2;r125e=5;r125f=7};
    $prove=@{r125a='R125a_costo_buffer_U30USD.txt';r125b='R125b_parziale_U30USD.txt';r125c='R125c_costo_buffer_D30EUR.txt';r125d='R125d_lato_short_D30EUR.txt';r125e='R125e_ampiezzaminima_D30EUR.txt';r125f='R125f_finestra15_NASUSD.txt'};
    foreach($e in 'r125a','r125b','r125c','r125d','r125e','r125f'){
      Write-Host ('--- ' + $e + '  (attese ' + $celle[$e] + ' celle per finestra)') -ForegroundColor Cyan;
      $global:LASTEXITCODE=0;
      & $p -Expert ABTG_ORB_Ottimizzato -Prova ('prove\' + $prove[$e]) -Etichetta $e -Pin $pin -Deposito 100000 -Modello 4 -TerminaleBacktest 'C:\MT5_Backtest' -SoloControllo;
      if($LASTEXITCODE -ne 0){ Write-Host ('FERMATI: ' + $e + ' esce ' + $LASTEXITCODE) -ForegroundColor Red; break } } }
```

🔍 **Cosa deve stampare, e cosa fa fermare:**
- `r125a` **7** · `r125b` **5** · `r125c` **7** · `r125d` **2** · `r125e` **5** ·
  `r125f` **7** celle per finestra. **Totale 33.**
- Se **un solo numero** e' diverso, **ci si ferma e si manda la stampa**: vuol
  dire che il file prova sul pin non e' quello che credo.
- Ogni blocco deve dire **`C:\MT5_Backtest`**. Se nomina un'altra cartella,
  **ci si ferma**.

---

## ▶️ PASSO 2 — LA CORSA VERA (solo se il passo 1 ha stampato 33 celle)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='65ef4e096935fa4fc8694d1877e45113cce8fc1d';
    $p="$env:USERPROFILE\RIGA_ROUND_VPS.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_ROUND_VPS.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_ROUND_VPS_v1' -Quiet)){ throw 'SCRIPT VECCHIO: il pin non contiene RIGA_ROUND_VPS v1.' };
    $prove=@{r125a='R125a_costo_buffer_U30USD.txt';r125b='R125b_parziale_U30USD.txt';r125c='R125c_costo_buffer_D30EUR.txt';r125d='R125d_lato_short_D30EUR.txt';r125e='R125e_ampiezzaminima_D30EUR.txt';r125f='R125f_finestra15_NASUSD.txt'};
    foreach($e in 'r125a','r125b','r125c','r125d','r125e','r125f'){
      Write-Host ('=== ' + $e) -ForegroundColor Cyan;
      $global:LASTEXITCODE=0;
      & $p -Expert ABTG_ORB_Ottimizzato -Prova ('prove\' + $prove[$e]) -Etichetta $e -Pin $pin -Deposito 100000 -Modello 4 -TerminaleBacktest 'C:\MT5_Backtest' -ChiudiBacktest;
      if($LASTEXITCODE -ne 0){ Write-Host ('PARZIALE su ' + $e + ': i CSV gia' + [char]39 + ' fatti restano, mandali lo stesso.') -ForegroundColor Yellow } } }
```

---

## ▶️ PASSO 3 — LA RACCOLTA (regola delle righe di lancio, punto 2)

```powershell
& { $ErrorActionPreference='Stop';
    $d = Join-Path ([Environment]::GetFolderPath('Desktop')) ('R125_' + (Get-Date -Format 'yyyyMMdd_HHmm'));
    New-Item -ItemType Directory -Path $d -Force | Out-Null;
    Get-ChildItem "$env:USERPROFILE\abtg_round" -Recurse -Include '*r125*.csv','*REFERTO*.txt','*.log' -EA SilentlyContinue | Copy-Item -Destination $d -EA SilentlyContinue;
    $n = (Get-ChildItem $d -File -EA SilentlyContinue | Measure-Object).Count;
    Write-Host ('file raccolti: ' + $n + '  (attesi 12 CSV: 6 etichette x IS/OOS)') -ForegroundColor Cyan;
    Get-ChildItem $d -File | Select-Object Name, Length | Format-List;
    Compress-Archive -Path (Join-Path $d '*') -DestinationPath ($d + '.zip') -Force;
    Write-Host ('ZIP PRONTO: ' + $d + '.zip') -ForegroundColor Green }
```

📨 **Poi manda**: `Desktop\R125_<data>_<ora>.zip`.
📖 **Cosa guardare per primo nella stampa**: **12 CSV** (6 etichette × IS/OOS).
Se ne mancano, dillo — **non si legge un round monco come se fosse intero**.

---

## 🚫 COSA QUESTA RIGA NON FA
- ❌ **Non tocca nessun EA, preset, parametro o sedia in forward.**
- ❌ **Non tocca il conto reale 10105439** — il driver muore da solo se ci punta.
- ❌ **Non promuove niente**: produce CSV. Il verdetto si scrive dopo, coi
  criteri firmati **prima**.
