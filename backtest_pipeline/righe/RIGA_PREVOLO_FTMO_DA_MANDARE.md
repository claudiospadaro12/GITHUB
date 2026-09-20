# 🛫 RIGA — PREVOLO FTMO (sonda di **sola lettura**, prima di toccare qualsiasi cosa)

> data: 2026-09-20 · pin `e09296b9` · marcatore `MARCATORE_PREVOLO_FTMO_v1`
> Referto di riferimento: `report/PREVOLO_FTMO_2026-09-20.md`

---

## 🖥️ **BERSAGLIO: una finestra PowerShell sul VPS.**

🔴 **Che cosa NON viene toccato** (sul VPS convivono **sette** cartelle dati, sei di casa
più quella nuova): la riga **non scrive niente** dentro nessun terminale, e in particolare
non tocca **`50503392`** (`C:\Program Files\BCM Markets MT5 Terminal`), **`50504263`**
(`... -V3`), **`10105439`** (`C:\BCM_Reale`, **conto REALE**), **`50504400`**
(`C:\MT5_Backtest`), `C:\MT5_MANUALE`, Pepperstone, Tickmill. Li **elenca per escluderli**.

🪟 **MT5 FTMO va lasciato APERTO e connesso**: la sonda legge il suo giornale, e senza
login quel giornale è vuoto. Nessun MT5 va chiuso, nessun processo viene toccato.

🔑 **`-ContoAtteso` è il numero del conto FTMO arrivato per mail: sostituiscilo.**
Se lo lasci com'è, la riga si ferma da sola e te lo dice (provato).

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

---

## 📦 LA RACCOLTA (già dentro lo script)

Sul **Desktop del VPS**:
- cartella `PREVOLO_FTMO_<data>_<ora>\` + **zip** `PREVOLO_FTMO_<data>_<ora>.zip`;
- dentro, **un** file: `PREVOLO_FTMO_<data>_<ora>_referto.txt`.

🕐 **QUALE DATA DEVI LEGGERE**: la **prima riga** del referto dice
`data: AAAA-MM-GG HH:MM:SS`. La console stampa la **stessa** data alla fine.
🔴 **Se le due non coincidono, stai guardando un referto vecchio** — è già successo il 17/08,
due volte, in buona fede.

## 🚦 LE TRE USCITE, e vogliono dire cose diverse

| uscita | significato | che si fa |
|---|---|---|
| **0** | tutte le caselle **automatiche** sono chiuse | si legge il referto e si va avanti |
| **2** | bersaglio **certificato**, ma restano caselle da leggere **a mano** (elencate una per una) | si leggono quelle, poi si va avanti |
| **1** | **RIFIUTO**: non ha misurato niente (zero candidate, due candidate, conto non trovato nel giornale…) | 🚫 non si aprono grafici: si manda l'output |

## ⏰ UNA COSA SOLA DA SAPERE PRIMA DI LANCIARLA

L'ora del server si legge in Market Watch, **ma a mercato chiuso quella colonna mostra l'ora
dell'ULTIMO TICK — di venerdì**. La sonda lo scrive in rosso e stampa la tabella con
**tutte** le ore possibili e il verdetto di ognuna: quando gli indici riaprono (domenica sera),
la lettura richiede 10 secondi e la casella si chiude.
