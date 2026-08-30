# 🧪 FASE 2 CASSA — VALIDAZIONE A TICK del motore aperture Nasdaq — DA MANDARE

**Che cos'è.** La **cassaforte**: si conferma a **TICK REALI su BCM** che
l'edge del drive-following delle aperture Nasdaq **sopravvive a spread e
slippage**. La FASE 1 (screening OHLC 2017-2020 su NASUSD_EXT, referto
`REFERTO_FASE2_DRIVE_2026-08-30.md`) ha già stabilito che il motore **nudo** ha
edge ed è **robusto per regime** (verde in toro/orso/laterale/crollo, PF 1.32 su
832 trade). Questa è una **MISURA**: non promuove niente, **non tocca il forward
(G5)**. È l'**OOS del disegno a due fasi** — si apre **una volta** e **non si
ottimizza**.

## ⚠️ Le inversioni rispetto alla FASE 1 (i gate le pretendono)
- **Simbolo `NASUSD`** (BCM live), **NON** `NASUSD_EXT`. **Model 4 (tick)**, non 1.
- **Fuso NORMALE BCM**: `InpSessionHour=14`, `InpSessionMin=30` (15:30 IT − 1 =
  14:30 server). Il gate **pretende 14/30 e rifiuta 9** — è l'**opposto** della
  FASE 1 (là 9:30 = apertura NY sul feed `_EXT`; qui il feed è BCM).
- **Rischio `0.65%`** (taglia di casa, DD comparabile) — il gate **rifiuta 1.0**.
- **Parziale RIMESSA** (gestione prop): `InpTP1_ClosePct=50` (metà chiude a 1R,
  il gate **rifiuta 0**), `InpTP1_R=1.0`, `InpBreakevenAtTP1=true`,
  `InpRunnerTP_R=-1` (l'altra metà corre, no cap). Doma il DD 15.6% della
  diagnostica all-runner.
- **SL floor `InpMinStopPts=500`** (R109, il gate **rifiuta 0**),
  `InpSkipIfTight=false` (il pavimento si **applica**, non fa saltare il trade).
- **F1/F3 SPENTI** (bocciati in FASE 1): `InpMinBreakoutRangeATR=0`,
  `InpUseEmaFilter=false`. **Drive-following**: `InpEntryMode=0` (BREAKOUT), il
  gate **rifiuta 2** (retest R115).

## 📦 Cosa gira
**2 celle**, 1 EA, M15 tick reali, finestra **2024.09.26 → 2026.06.30** (**un solo
regime rialzista**, dichiarato). Il 40/60 IS/OOS è **contesto di lettura, NON
selezione**. Ogni cella = coppia gemella su `InpMagic` (igiene del banco).
Magic **vergini 7681xx** (NON 7672xx FASE 1, NON 766xxx R115, NON 767xxx
PASSO0/short — verificati liberi il 30/08).

| cella | lati | magic | ruolo |
|---|---|---|---|
| **00_simm** | L+S | 768100/768101 | il **candidato** (simmetrico) |
| **01_long** | L only | 768110/768111 | il metro: costo dello short senza crolli |

Le corse sono delegate a `walkforward_generico.ps1` (pinnato). **Profondità
tick di NASUSD**: rilievo, non gate — se manca `misura_tick_NASUSD.csv` la
riserva è **dichiarata**.

---

## 1️⃣ PRIMA: il GIRO A VUOTO (sempre)

Non apre MT5, non misura numeri: scarica al pin, **verifica tutti i gate**
(fuso 14/30, rischio 0.65, parziale 50, SL floor 500, F1/F3 off, drive-following,
stella, magic) e stampa gli `.ini` che lancerebbe. `<PIN>` = l'hash del commit
che contiene QUESTO pacchetto.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_FASE2_CASSA.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_FASE2_CASSA.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_FASE2_CASSA_v1' -Quiet)){ throw 'SCRIPT VECCHIO: il file scaricato non ha il marcatore FASE2_CASSA.' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - leggi il REFERTO sul Desktop' } }
```

---

## 2️⃣ POI: la CORSA VERA

Identica alla precedente, **senza `-SoloControllo`**. Apre MT5, gira le 2 celle a
tick reali (IS+OOS), scrive il referto e lo zip sul Desktop.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_FASE2_CASSA.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_FASE2_CASSA.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_FASE2_CASSA_v1' -Quiet)){ throw 'SCRIPT VECCHIO: il file scaricato non ha il marcatore FASE2_CASSA.' };
    $global:LASTEXITCODE=0; & $p -Pin $pin; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - leggi il REFERTO sul Desktop' } }
```

> Una cella sola: aggiungi `-SoloCella '00_simm'` (o `'01_long'`). I gate girano
> comunque su entrambi i file (il 00_simm serve al confronto della stella).

---

## 📤 Cosa arriva sul Desktop
- Cartella `FASE2_CASSA_CORSA_<data>` (o `FASE2_CASSA_CONTROLLO_<data>`).
- `REFERTO_FASE2_CASSA.txt` — la tabella OOS + IS, i criteri di lettura congelati
  e il confronto **simmetrico-vs-longonly** già impostato.
- I 2 file prova girati + i CSV IS/OOS delle celle misurate.
- Zip `FASE2_CASSA_CORSA_<data>.zip` pronto da mandare.
- Il **per-trade CSV** (`abtg_trades_..._NASUSD_<magic>.csv`) resta in
  `Common\Files`, **non nello zip**: serve per la lettura fine long/short e mese
  per mese.

## 🔢 Codici d'uscita
`0` tutto ok · `1` fermato da un gate/errore · `3` misurato ma con problemi (es.
gemelli non identici, celle mute) — **leggere il referto prima di leggere
qualunque numero**.

## ❓ Punto aperto da confermare con Claudio (dichiarato, non inventato)
`InpCloseHour=20`, `InpCloseMin=45` (chiusura intraday) è l'**ora server della
sedia Nasdaq apertura viva su BCM** (preset live, come R115). La FASE 1 chiudeva
15:55 in **ora NY del feed `_EXT`**: le due non si mappano 1:1 perché i feed sono
diversi. Ho scelto il valore della **sedia live** (server) perché è il
riferimento reale su BCM. Se preferisci un altro orario di chiusura, si cambia in
una riga nei due file prova.
