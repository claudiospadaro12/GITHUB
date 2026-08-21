# RIGA DI LANCIO — CANARINO BARRA 1 (BULGE v5.20)

**Pin: `c4426c5`** (branch `lavoro`, 21/08/2026) — la correzione decisa da
Claudio (*"VAI CON BARRA 1"*), via 1 del referto `risultati_archivio/R92_REFERTO.md`.

## Cosa e' — e cosa NON e'

E' un **canarino di BANCO**, non una misura di merito. Risponde a **una sola
domanda**:

> ### **"Adesso il BLU e il VIOLA-PINE scattano, si' o no?"**

**NON si legge**: profitto, PF, drawdown, win rate. Quelli sarebbero **numeri
prima dei criteri**, e i criteri del round nuovo non sono ancora scritti ne'
firmati. Se guardando il Diario si vede un profitto, **si ignora**.

Perche' un canarino separato invece di rilanciare subito le 88 passate: le 88
costano ore, questo costa **due minuti**. Se BLU e PINE fossero ancora muti,
le ore sarebbero buttate.

---

## PASSO A — INSTALLARE LA v5.20 (MT5 CHIUSO, secondi)

```powershell
& {
  [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
  if(Get-Process -Name terminal64 -EA SilentlyContinue){ throw "MT5 E' APERTO: chiudilo prima di sovrascrivere l'EA" }
  if(Get-Process -Name metaeditor64 -EA SilentlyContinue){ throw "MetaEditor E' APERTO: chiudilo, altrimenti tieni in mano la versione vecchia" }
  $h="c4426c5"
  $b="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$h"
  $d="$env:USERPROFILE\r92bis"
  New-Item -ItemType Directory -Force -Path $d | Out-Null
  $ea=Join-Path $d "ABTG_Bulge.mq5"
  $inc=Join-Path $d "ABTG_PausaGuardian.mqh"
  Remove-Item $ea,$inc -Force -EA SilentlyContinue
  irm "$b/mql5/Experts/ABTG_Bulge.mq5" -OutFile $ea -EA Stop
  irm "$b/mql5/Include/ABTG_PausaGuardian.mqh" -OutFile $inc -EA Stop
  if(-not (Select-String -LiteralPath $ea -SimpleMatch -Pattern "Signal_Bar_Offset" -Quiet)){ throw "l'EA scaricato NON ha Signal_Bar_Offset: e' la versione VECCHIA" }
  if(-not (Select-String -LiteralPath $ea -SimpleMatch -Pattern '#property version   "5.20"' -Quiet)){ throw "l'EA scaricato NON e' la v5.20" }
  if(-not (Select-String -LiteralPath $inc -SimpleMatch -Pattern "ABTG_AutotestGuardia" -Quiet)){ throw "l'include NON ha ABTG_AutotestGuardia: download andato male" }
  $lea=(Get-Item -LiteralPath $ea).Length; $linc=(Get-Item -LiteralPath $inc).Length
  $n=0
  foreach($t in @(Get-ChildItem (Join-Path $env:APPDATA "MetaQuotes\Terminal") -Directory -EA SilentlyContinue | Where-Object { Test-Path (Join-Path $_.FullName "MQL5\Experts") })){
    $de=Join-Path $t.FullName "MQL5\Experts"; $di=Join-Path $t.FullName "MQL5\Include"
    New-Item -ItemType Directory -Force -Path $di | Out-Null
    Copy-Item -LiteralPath $ea  -Destination (Join-Path $de "ABTG_Bulge.mq5") -Force
    Copy-Item -LiteralPath $inc -Destination (Join-Path $di "ABTG_PausaGuardian.mqh") -Force
    $v1=Get-Item -LiteralPath (Join-Path $de "ABTG_Bulge.mq5") -EA Stop
    $v2=Get-Item -LiteralPath (Join-Path $di "ABTG_PausaGuardian.mqh") -EA Stop
    if($v1.Length -ne $lea -or $v2.Length -ne $linc){ throw ("copia NON verificata in " + $t.FullName) }
    Remove-Item (Join-Path $de "ABTG_Bulge.ex5") -Force -EA SilentlyContinue
    Write-Host ("   installata v5.20 in " + $de) -ForegroundColor Green
    $n++
  }
  if($n -eq 0){ throw "nessuna cartella dati MT5 trovata sotto APPDATA" }
  Write-Host ""
  Write-Host "=====================================================================" -ForegroundColor White
  Write-Host ("   v5.20 installata in " + $n + " cartella/e. Il vecchio .ex5 e' stato CANCELLATO:") -ForegroundColor White
  Write-Host "   se il tester parte senza ricompilare, si accorge che manca." -ForegroundColor White
  Write-Host "   ORA: apri MetaEditor, apri ABTG_Bulge.mq5, F7. Pretendi 0 errori 0 warning." -ForegroundColor White
  Write-Host "=====================================================================" -ForegroundColor White
}
```

---

## PASSO B — COMPILARE (a mano, MetaEditor)

MetaEditor -> apri `ABTG_Bulge.mq5` -> **F7**. Pretendi **0 errori, 0 warning**.
Il vecchio `.ex5` e' stato cancellato dal PASSO A apposta: se il tester parte
senza ricompilare, se ne accorge invece di girare la versione di ieri.

---

## PASSO C — LA PASSATA SINGOLA (a mano, Strategy Tester)

**Identico al PASSO 2B di R92, che ha funzionato.** In ottimizzazione MT5 non
esegue le `Print` degli agent: il canarino **deve** essere una passata singola.

| campo | valore |
|---|---|
| Expert | `ABTG_Bulge` |
| Simbolo / Symbol | **GBPUSD** |
| Periodo / Period | **H1** |
| Date | 2022.01.01 – 2026.06.30 |
| Modello / Model | OHLC M1 (o Ogni tick: qui non conta) |
| Ottimizzazione | **DISATTIVATA** |

Nei **Dati in ingresso / Inputs**, quattro campi:

| input | valore |
|---|---|
| `Symbols_List` (etichetta "Basket (22 cross)") | **GBPUSD** ← restringere davvero, non lasciare i 22 |
| `InpAutoTest` | **true** |
| `InpVerbose` | **true** |
| `Signal_Bar_Offset` | **1** (e' gia' il default: verificare che ci sia) |

---

## COSA SI LEGGE NEL DIARIO — e sono DUE cose, in due punti diversi

### 1. IN CIMA (subito dopo `[BULGE] Init OK`) — le asserzioni

Devono uscire, **tutte con PASS**:

```
[BULGE][AUTOTEST] mappa barre: Signal_Bar_Offset=1 -> conferma su barra 1,
                  segnale base su barra 2, impulso da k=2, banda piatta su barra 8
[BULGE][AUTOTEST] (A) PINE su barra chiusa distingue verde/rossa ... PASS
[BULGE][AUTOTEST] (B) EA su barra chiusa SCARTA davvero ... PASS
[BULGE][AUTOTEST] (C) il difetto di R92, riprodotto apposta ... PASS (riprodotto)
```

Se **una** dice FAIL -> ci si ferma qui. La correzione non e' fatta.

### 2. IN FONDO (fine test) — **IL CANARINO VERO**

```
[BULGE-CONTA] GBPUSD | aperture=N -> BLU=x VIOLA=y ARANCIO=z
```

| esito | lettura |
|---|---|
| **BLU > 0** | ✅ il difetto e' morto. Il BLU esiste per la prima volta nella storia di questo EA sul banco a un simbolo |
| **BLU = 0** | ❌ **fermarsi**. Non e' il mercato: e' ancora il banco. Si torna sul codice, non si spendono le ore delle 88 passate |

**Termine di paragone, da R92 (v5.10, stesso simbolo, stessa finestra):**
`GBPUSD -> 11 operazioni, TUTTE VIOLA, BLU=0, PINE=0`.

⚠️ Il numero di operazioni **puo' salire o scendere**, ed **entrambe le
direzioni sono normali**: il BLU torna vivo (aggiunge), il filtro del VIOLA-EA
torna a filtrare (toglie). Il saldo non e' prevedibile — **non e' quello che si
sta misurando qui**.

---

## E DOPO

Se il canarino passa: si scrivono i criteri del **round nuovo** (le soglie
S1/S2/S3 di R92 sono riusabili: **non sono state toccate dai numeri**, quindi
non c'e' nessun criterio cambiato dopo), Claudio li firma, **poi** si lanciano
le passate. Mai l'ordine inverso.
