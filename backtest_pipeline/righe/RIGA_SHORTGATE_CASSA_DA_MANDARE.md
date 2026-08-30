# 🧪 SHORTGATE CASSA — CONFERMA A TICK del breakdown short gated — DA MANDARE

**Che cos'è.** La **conferma a tick**: si prende lo **stesso motore** dello
screening short (breakdown gated H4) che a **OHLC su EXT** ha dato **forma verde**
(referto `REFERTO_SHORTGATE_2026-08-30.md`: **PF 1.84**, DD 2.07%, edge nell'**orso
confermato per regime** — orso 2022 il bulk, +4020 su 49 trade, win 89.8%) e si
misura a **TICK REALI su BCM** se gli **ingressi che scattano sopravvivono ai
costi** (spread + slippage). È una **MISURA**: **non promuove niente**, **non
tocca il forward**.

## ⚠️ Cosa cambia rispetto allo screening EXT (i gate lo pretendono)
- **Simbolo `NASUSD`** (BCM live), **NON** `NASUSD_EXT`. **Model 4 (tick)**, non 1.
- **Fuso NORMALE BCM**: `InpSessionHour=14`, `InpSessionMin=30` (15:30 IT − 1 =
  14:30 server). Il gate **pretende 14/30 e rifiuta 9** — è l'**opposto** dello
  screening (là 9:30 = apertura NY sul feed `_EXT` a ora di New York; qui il feed
  è BCM). **Dichiarato opposto**: là 9 = stop qui, qui 14 = stop là.
- **Finestra `2024.09.26 → 2026.06.30`** (pavimento tick BCM, 166M tick reali già
  misurati). **Un solo regime rialzista**, dichiarato.
- **Magic vergini `768300/768301`** (NON `767120` dello screening EXT, NON 7681xx
  FASE 2 CASSA, NON 7690xx INVES, NON 7672xx FASE 1, NON 766xxx R115 —
  verificati liberi in tutto il repo il 30/08).

## 🔒 Il motore short è IDENTICO allo screening (si misura il costo, non un altro motore)
`InpEntryMode=0` (BREAKOUT drive-down, il gate **rifiuta 2** = retest R115),
`InpAllowLong=false`/`InpAllowShort=true`; **gate di regime** = il motore:
`InpUseEmaFilter=true`, `InpEmaFast=50`, `InpEmaSlow=200`, `InpFilterTF=16388`
(H4); pavimento SL `InpMinStopPts=500` (R109), `InpSkipIfTight=false`; rischio
`0.65%`.

## 🧭 La cornice, dichiarata prima dei numeri
- **Un solo regime rialzista**: i tick BCM sugli indici **non raggiungono nessun
  orso**. Il gate H4 **sparerà poco** (come nel toro 2021 dello screening:
  ~17 trade/anno) → **campione sottile atteso** → **merito sospeso** (valvola
  R59). Questa corsa misura la **sopravvivenza ai costi**, **NON l'edge dell'orso**
  (a tick su BCM è irraggiungibile: nessun orso nei dati; il verdetto sull'edge
  resta OHLC / Dukascopy).
- **Rischio mai sospeso** (regola B): DD e peggior giornata **sempre**.
- **1 cella + gemello**, **tranche unica** (`FrazioneIS=1.0`): su un campione
  sottile spezzare in 40/60 lascerebbe due metà illeggibili. La lettura
  long/short e mese-per-mese si fa **a mano** dal per-trade CSV.

| cella | lati | magic | ruolo |
|---|---|---|---|
| **shortgate** | S only | 768300/768301 | il candidato (breakdown short gated H4), a tick |

Le corse sono delegate a `walkforward_generico.ps1` (pinnato). **Profondità tick
di NASUSD**: rilievo, non gate — se manca `misura_tick_NASUSD.csv` la riserva è
**dichiarata**.

---

## 1️⃣ PRIMA: il GIRO A VUOTO (sempre)

Non apre MT5, non misura numeri: scarica al pin, **verifica tutti i gate**
(fuso 14/30 rifiuta 9, Model 4, direzione BREAKOUT solo-short, gate regime EMA
50x200 H4, SL floor 500, rischio 0.65, magic vergini) e stampa l'`.ini` che
lancerebbe. `<PIN>` = l'hash del commit che contiene QUESTO pacchetto.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_SHORTGATE_CASSA.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SHORTGATE_CASSA.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SHORTGATE_CASSA_v1' -Quiet)){ throw 'SCRIPT VECCHIO: il file scaricato non ha il marcatore SHORTGATE_CASSA.' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - leggi il REFERTO sul Desktop' } }
```

---

## 2️⃣ POI: la CORSA VERA

Identica alla precedente, **senza `-SoloControllo`**. Apre MT5, gira la cella
(+ gemello) a tick reali sulla finestra intera, scrive il referto e lo zip sul
Desktop.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_SHORTGATE_CASSA.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SHORTGATE_CASSA.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SHORTGATE_CASSA_v1' -Quiet)){ throw 'SCRIPT VECCHIO: il file scaricato non ha il marcatore SHORTGATE_CASSA.' };
    $global:LASTEXITCODE=0; & $p -Pin $pin; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - leggi il REFERTO sul Desktop' } }
```

---

## 📤 Cosa arriva sul Desktop
- Cartella `SHORTGATE_CASSA_CORSA_<data>` (o `SHORTGATE_CASSA_CONTROLLO_<data>`).
- `REFERTO_SHORTGATE_CASSA.txt` — la tabella (n, PF, DD%, profit, asp/trade,
  peggior giornata, gemelli) + i criteri di lettura congelati.
- Il file prova girato + il CSV della finestra intera.
- Zip `SHORTGATE_CASSA_CORSA_<data>.zip` pronto da mandare.
- Il **per-trade CSV** (`abtg_trades_..._NASUSD_<magic>.csv`) resta in
  `Common\Files`, **non nello zip**: serve per la lettura fine mese per mese
  (quando spara il gate).

## 🔢 Codici d'uscita
`0` tutto ok · `1` fermato da un gate/errore · `3` misurato ma con problemi (es.
gemelli non identici, cella muta) — **leggere il referto prima di leggere
qualunque numero**.

## ❓ Punti aperti da confermare con Claudio (dichiarati, non inventati)
1. `InpCloseHour=20`, `InpCloseMin=45` (chiusura intraday) è l'**ora server della
   sedia Nasdaq apertura viva su BCM** (preset live, R115). Se preferisci un altro
   orario di chiusura, si cambia in una riga nel file prova.
2. **Tranche unica** scelta apposta (campione sottile). Se vuoi comunque le due
   metà come contesto, si lancia con `FrazioneIS 0.40` — ma su ~17 trade/anno le
   metà sono troppo magre per dire qualcosa.
