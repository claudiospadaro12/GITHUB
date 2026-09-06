# 📬 **LA SONDA DELL'OROLOGIO — RAMO INDICI** (DAX + DOW) — LE RIGHE DA MANDARE

**Che cos'è:** il **PASSO 0 — di MISURA —** del ramo **INDICI** dell'orologio,
nato dalla caccia meccanismi DAX/Dow del **06/09/2026**
(`caccia_strategie/CACCIA_INDICI_DAX_DOW_MECCANISMI_2026-09-06.md`).
È il meccanismo che **NON guarda il prezzo**: guarda solo **l'orologio del server**.

> 🔴 **NON È UN ROUND E NON DÀ NESSUN VERDETTO — è una MISURA.**
> Criterio **I8**, congelato prima dei numeri: *nessuna promozione da questa
> corsa, nessuna sedia toccata, nessun parametro di forward spostato.*
> **Produce una TABELLA.**

**La domanda, in una riga:** *"esiste una fascia oraria in cui il **LORDO** medio
per giornata vale almeno **TRE VOLTE** lo spread mediano misurato **IN QUELLA
STESSA ORA**?"*

| | |
|---|---|
| **EA (mai compilato, mai girato)** | `mql5/Experts/ABTG_SondaOrologio.mq5` — **è lo stesso del ramo FX, NON modificato** |
| **Driver** | `righe/RIGA_SONDA_OROLOGIO.ps1` (marcatore `MARCATORE_RIGA_SONDA_OROLOGIO_v4`) |
| **Specifica CONGELATA** | `prove/SONDA_OROLOGIO_INDICI.txt` — ipotesi, criteri **I1-I8**, date. **Si legge PRIMA della tabella** (il driver la mette dentro lo zip) |
| **File prova (4)** | `prove/SONDA_OROLOGIO_11_D30EUR_LONG.txt` `_12_D30EUR_SHORT` `_13_U30USD_LONG` `_14_U30USD_SHORT` |

> ⚠️ **QUESTA PAGINA È SOLO IL RAMO INDICI.** Il ramo FOREX/ORO ha la sua
> pagina (`RIGA_SONDA_OROLOGIO_DA_MANDARE.md`), il suo pin e i suoi criteri
> C1-C7: **le due pagine non si mescolano**, e nemmeno i due pin.

---

## 🕰️ LE QUATTRO CELLE — due simboli × due lati

| cella | simbolo | lato | magic | celle/finestra |
|---|---|---|---|---|
| **11_d30eur_long** | D30EUR (DAX) | LONG | 777211 | 72 |
| **12_d30eur_short** | D30EUR (DAX) | SHORT | 777212 | 72 |
| **13_u30usd_long** | U30USD (DOW) | LONG | 777213 | 72 |
| **14_u30usd_short** | U30USD (DOW) | SHORT | 777214 | 72 |

I **quattro magic sono VERGINI** (cercati uno per uno nel repo il 06/09 → zero
occorrenze). E **da oggi il driver vieta anche i magic dell'ALTRO giro**
(`777201-777206`, `777290/777291` sono del ramo forex): un file prova copiato
dal ramo sbagliato **si ferma sul gate**, non a corsa finita.

**Regola dei due lati (25/08):** i due lati non sono un lusso, sono **il
controllo**. Vedi il criterio **I7** qui sotto.

---

## 🔴 **LA COSA PIÙ IMPORTANTE DI QUESTO ROUND: `-Giro INDICI` è OBBLIGATORIO**

Il driver adesso lancia **due giri** — `FX` (7 celle forex, dal 2011) e `INDICI`
(4 celle, dal 2024.09.26) — e **quale non ha default**, esattamente come `-Pin`:

- **senza `-Giro` la riga si ferma subito** (`exit 2`, nessuno zip, nessun
  referto) e stampa i due giri con le loro celle;
- un default silenzioso avrebbe fatto girare **la lista sbagliata per ore**, e
  te ne saresti accorto solo a corsa finita.

Nelle righe qui sotto `-Giro INDICI` **è già scritto dentro**: non c'è niente da
correggere a mano.

---

## 📌 IL PIN — **`73069faaa50b225561aa655338e3095dc4c61c46`**

```
73069faaa50b225561aa655338e3095dc4c61c46
```

**Verificato dopo il push** (HTTP 200 + sha256 identico al repo) per **tutti e
otto** gli artefatti che la corsa scarica: `RIGA_SONDA_OROLOGIO.ps1`,
`walkforward_generico.ps1`, i **quattro** file prova, `SONDA_OROLOGIO_INDICI.txt`
e **`mql5/Experts/ABTG_SondaOrologio.mq5`** (che il driver generico riscarica
**al pin**, perché la riga gli riscrive dentro `$EABranch`).

### ♻️ LA RICETTA DI **RI-PINNATURA** — se un artefatto viene corretto

```bash
F=backtest_pipeline/righe/RIGA_SONDA_OROLOGIO_INDICI_DA_MANDARE.md
NUOVO=<il commit nuovo, 40 caratteri>
VECCHIO=$(grep -oE "\\\$pin='[0-9a-f]{40}'" "$F" | head -1 | grep -oE '[0-9a-f]{40}')
echo "vecchio: $VECCHIO"
sed -i "s|\$pin='$VECCHIO'|\$pin='$NUOVO'|g; s|^$VECCHIO\$|$NUOVO|; s|\*\*\`$VECCHIO\`\*\*|\*\*\`$NUOVO\`\*\*|g" "$F"
grep -c "\$pin='$NUOVO'" "$F"    # DEVE dare 6 (controllo + 4 celle + ricomposizione)
grep -c "$NUOVO" "$F"            # DEVE dare 8 (i 6 blocchi + il titolo + il blocco nudo)
grep -c "\$pin='$VECCHIO'" "$F"  # DEVE dare 0
```

⚠️ **Servono TUTTI E TRE i conteggi**: il solo *"0 pin vecchi rimasti"* lo supera
a mani basse anche un `sed` che **non ha matchato niente**.
🔴 **Il perimetro della ricetta è UN FILE SOLO — questo.** La pagina del ramo FX
ha **il suo** pin (`f81eb70`, driver v3) e **non si tocca**: un pin vecchio
scarica il driver vecchio, ed è giusto così.

---

## ⏱️ **QUANTO COSTA — e perché il primo blocco NON gira il tester**

Una cella = **72 celle × 2 finestre = 144 passate a TICK REALI** su 21 mesi di
H1. Quattro celle = **576 passate**. 🔴 **Quanto costi una passata su un INDICE
a tick reali NON è mai stato misurato in casa: è un'IGNOTA, non una stima.**

E qui **non c'è la cella `00_gemelli`** del ramo forex (i file prova congelati
sono quattro, e il driver non se ne inventa un quinto). Conseguenze **dichiarate
nel referto**, non nascoste:

- il **DETERMINISMO del banco su questo giro NON è misurato** → esce come
  **RILIEVO** automatico in ogni referto;
- **non esiste un modo di default**: se non dici cosa deve girare, la riga **si
  ferma** e ti stampa il menu;
- il **cronometro** si legge sulla **prima cella che gira davvero** (blocco 2️⃣).

| modo | come si chiede | cosa gira |
|---|---|---|
| **CONTROLLO** | `-Giro INDICI -SoloControllo` | gate su tutti e 4 i prova + **COMPILA** l'EA. **Nessuna passata** |
| **CORSA** | `-Giro INDICI -SoloCella '<id>'` | quella cella: **144 passate** |
| **CORSA LUNGA** | `-Giro INDICI -TutteLeCelle` | tutte e quattro: **576 passate** (solo dopo il cronometro) |
| **RICOMPOSIZIONE** | `-Giro INDICI -Ricomponi` | **NIENTE**: rilegge i CSV già fatti e dà **I1 + I7 sui due simboli insieme** |

> ✅ **L'ORDINE GIUSTO È: 1️⃣ controllo → 2️⃣ prima cella (leggi il cronometro) →
> 3️⃣ le altre tre → 4️⃣ ricomposizione.**

---

## ⚠️ COSA SAPERE PRIMA DI LANCIARE

- 🖥️ **Si lancia sul PC DI BACKTEST**, non sul VPS (là ci sono i terminali del
  forward e non c'entrano niente con questa corsa).
- **MT5 e MetaEditor DEVONO essere chiusi.** Col terminale aperto il tester non
  gira (zero CSV); con MetaEditor aperto la compilazione torna subito **senza
  compilare**. La riga si rifiuta di partire in tutti e due i casi.
- 🔴 **L'EA NON È MAI STATO COMPILATO NÉ MAI GIRATO DA NESSUNO** (verificato il
  06/09: zero referti in `risultati_archivio/` che lo nominino). **Il blocco 1️⃣
  è anche la sua prima compilazione.** Lo script cancella l'`.ex5` prima di
  compilare (un binario vecchio farebbe passare per riuscita una compilazione
  fallita) e, se fallisce, **stampa in rosso le ultime 40 righe del log di
  MetaEditor**, salva `COMPILAZIONE_FALLITA.log` **dentro lo zip** e si ferma.
  🟢 **Se la compilazione fallisce, il risultato del PASSO 0 è quello**: mandami
  lo zip, non è un guasto della riga.
- 📐 **Finestra `2024.09.26 → 2026.06.30`, H1, `Model=4` (tick reali), split
  40/60, deposito `100.000`, `InpRiskPercent = 1.0`** — e quel numero è **letto
  dal file prova**, dove morde davvero.
- 🟢 **La data di partenza NON è una scelta, è un PAVIMENTO MISURATO**: il tick
  BCM su D30EUR e U30USD parte dal **2024.09.26** con stato **COMPLETO**
  (`risultati_archivio/REFERTO_SONDA_STORICO_17-08.md`, riga 46). Quindi qui —
  a differenza del ramo forex — **i tick sono NATIVI su tutta la finestra**, e
  il referto lo scrive nella riga `tick:`.
- 🕐 **Le ore sono in ORA SERVER BCM = ora italiana − 1.** Ancore: **DAX apre
  08:00 server**, **indici USA 14:30 server**. Nel referto `8` vuol dire le 9
  italiane. **Il referto lo dichiara in testa**, perché senza quella riga una
  fascia verde viene attribuita all'ora sbagliata.
- **NESSUNA SEDIA VIVA VIENE TOCCATA.** Magic vergini `77721x`,
  `AllowLiveTrading=false` negli `.ini` (lo scrive il driver generico).
- ♻️ **Se il pin cambia, `%USERPROFILE%\abtg_sonda_orologio_indici` viene
  SVUOTATA** (file prova e CSV del pin vecchio). 🟢 La cartella del ramo FX
  (`abtg_sonda_orologio`) è **un'altra**: i due giri non si cancellano a vicenda.
- 🧹 La riga **svuota `Tester\cache`** prima di ogni corsa e scrive i **due
  conteggi** nel referto. Non è precauzione generica: i CSV nascono dai **FRAME**,
  e un pass ripescato dalla cache **non chiama `OnTester()`**, quindi la sua riga
  **sparisce dal CSV** con la corsa verde. Lo storico non viene toccato.
- 🔧 Se non è già stato fatto: MT5 → Strumenti → Opzioni → Grafici →
  **"Max barre nel grafico" = Illimitato**.

---

## 1️⃣ PRIMA il giro di controllo (**COMPILA, non apre il tester**)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='73069faaa50b225561aa655338e3095dc4c61c46'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SONDA_OROLOGIO.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SONDA_OROLOGIO.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SONDA_OROLOGIO_v4' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=0; & $p -Giro INDICI -Pin $pin -SoloControllo; $rc=$LASTEXITCODE;
    $z=@(Get-ChildItem (Join-Path $env:USERPROFILE 'Desktop\SONDA_OROLOGIO_INDICI_CONTROLLO_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP SONDA_OROLOGIO_INDICI_CONTROLLO_ DI ADESSO: la riga non e'' arrivata alla raccolta' };
    if($rc -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Mandami questo zip:' -ForegroundColor Red; Write-Host $z[0].FullName -ForegroundColor Yellow }
    else { Write-Host 'CONTROLLO OK: si passa al blocco 2.' -ForegroundColor Green };
    Write-Host ('ZIP: ' + $z[0].FullName) -ForegroundColor Cyan; }
```

**Cosa deve dire**, in ordine:

- `giro ........ INDICI   [criteri I1-I8, specifica prove/SONDA_OROLOGIO_INDICI.txt]`;
- `celle ....... 4 su 4   [11_d30eur_long, 12_d30eur_short, 13_u30usd_long, 14_u30usd_short]`;
- `finestra .... 2024.09.26 -> 2026.06.30`;
- `file prova scaricati: 4 su 4` e `specifica scaricata: prove/SONDA_OROLOGIO_INDICI.txt`;
- 🔴 **`geometria, assi, griglia letterale, lati, baseline assoluta, elenco chiuso e magic: TUTTI PASSATI su 4 file su 4`**;
- `terminale scelto: ...` ← **è il nome da confrontare** con quello che stampa poi il driver generico;
- 🔴 **`compilato ABTG_SondaOrologio: OK (...)`** ← **è questa la riga che conta.**
  Se invece esce `COMPILAZIONE FALLITA`, sopra ci sono in **rosso** le ultime 40
  righe del log di MetaEditor: **mandami lo zip, quello è il risultato**;
- in fondo `ESITO: CONTROLLO COMPLETATO`.

---

## 2️⃣ POI la **PRIMA CELLA** — 144 passate, ed è il cronometro

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='73069faaa50b225561aa655338e3095dc4c61c46'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SONDA_OROLOGIO.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SONDA_OROLOGIO.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SONDA_OROLOGIO_v4' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=0; & $p -Giro INDICI -Pin $pin -SoloCella '11_d30eur_long'; $rc=$LASTEXITCODE;
    $z=@(Get-ChildItem (Join-Path $env:USERPROFILE 'Desktop\SONDA_OROLOGIO_INDICI_CORSA_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP SONDA_OROLOGIO_INDICI_CORSA_ DI ADESSO: la riga non e'' arrivata alla raccolta' };
    if($rc -ne 0){ Write-Host 'PARZIALE O CON PROBLEMI: lo zip esiste lo stesso, mandalo e leggi i PROBLEMI nel REFERTO.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    Write-Host 'POI nel REFERTO: riga data: = adesso, riga giro: = INDICI, riga modo: = CORSA.' -ForegroundColor Gray; }
```

**La riga da guardare nel referto:**
**`cronometro: ... s per passata -> le 4 celle di questo giro (576 passate)
costerebbero circa X ore`** ← **è il numero su cui si decide** se lanciare le
altre tre di fila o una per volta.

---

## 3️⃣ POI le ALTRE TRE CELLE — un blocco già pronto per ciascuna

> Sono **identici al blocco 2️⃣ tranne il nome della cella**, e sono scritti per
> intero apposta: **niente da correggere a mano**.

### 3a — `12_d30eur_short` (DAX lato SHORT)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='73069faaa50b225561aa655338e3095dc4c61c46'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SONDA_OROLOGIO.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SONDA_OROLOGIO.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SONDA_OROLOGIO_v4' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=0; & $p -Giro INDICI -Pin $pin -SoloCella '12_d30eur_short'; $rc=$LASTEXITCODE;
    $z=@(Get-ChildItem (Join-Path $env:USERPROFILE 'Desktop\SONDA_OROLOGIO_INDICI_CORSA_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP SONDA_OROLOGIO_INDICI_CORSA_ DI ADESSO: la riga non e'' arrivata alla raccolta' };
    if($rc -ne 0){ Write-Host 'PARZIALE O CON PROBLEMI: lo zip esiste lo stesso, mandalo e leggi i PROBLEMI nel REFERTO.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan; }
```

### 3b — `13_u30usd_long` (DOW lato LONG)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='73069faaa50b225561aa655338e3095dc4c61c46'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SONDA_OROLOGIO.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SONDA_OROLOGIO.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SONDA_OROLOGIO_v4' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=0; & $p -Giro INDICI -Pin $pin -SoloCella '13_u30usd_long'; $rc=$LASTEXITCODE;
    $z=@(Get-ChildItem (Join-Path $env:USERPROFILE 'Desktop\SONDA_OROLOGIO_INDICI_CORSA_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP SONDA_OROLOGIO_INDICI_CORSA_ DI ADESSO: la riga non e'' arrivata alla raccolta' };
    if($rc -ne 0){ Write-Host 'PARZIALE O CON PROBLEMI: lo zip esiste lo stesso, mandalo e leggi i PROBLEMI nel REFERTO.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan; }
```

### 3c — `14_u30usd_short` (DOW lato SHORT)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='73069faaa50b225561aa655338e3095dc4c61c46'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SONDA_OROLOGIO.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SONDA_OROLOGIO.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SONDA_OROLOGIO_v4' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=0; & $p -Giro INDICI -Pin $pin -SoloCella '14_u30usd_short'; $rc=$LASTEXITCODE;
    $z=@(Get-ChildItem (Join-Path $env:USERPROFILE 'Desktop\SONDA_OROLOGIO_INDICI_CORSA_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP SONDA_OROLOGIO_INDICI_CORSA_ DI ADESSO: la riga non e'' arrivata alla raccolta' };
    if($rc -ne 0){ Write-Host 'PARZIALE O CON PROBLEMI: lo zip esiste lo stesso, mandalo e leggi i PROBLEMI nel REFERTO.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan; }
```

> ⚠️ **Ogni ripresa è un BLOCCO INTERO, col suo `irm`.** `$p` e `$pin` nascono
> **dentro** il `& { ... }`, che è uno scope figlio: quando quel blocco finisce
> **non esistono più**. E si incolla **il blocco INTERO**: è **un comando solo**.

🟡 **`-TutteLeCelle` esiste** (le quattro di fila, un solo zip) **ma si usa solo
DOPO aver letto il cronometro**: al buio sono **576 passate**, e le **rifà tutte
davvero** (`-Rifai` è sempre nell'argv). **Per rileggere c'è il blocco 4️⃣.**

---

## 4️⃣ **RICOMPOSIZIONE** — dopo che le QUATTRO celle sono girate

> 🔴 **I1 chiede ENTRAMBI i simboli e I7 chiede ENTRAMBI i lati: sono criteri
> D'INSIEME.** Quattro lanci separati producono **quattro referti parziali**,
> nessuno dei quali può leggerli. Serve un quinto lancio che li rilegge TUTTI.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='73069faaa50b225561aa655338e3095dc4c61c46'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SONDA_OROLOGIO.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SONDA_OROLOGIO.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SONDA_OROLOGIO_v4' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=0; & $p -Giro INDICI -Pin $pin -Ricomponi; $rc=$LASTEXITCODE;
    $z=@(Get-ChildItem (Join-Path $env:USERPROFILE 'Desktop\SONDA_OROLOGIO_INDICI_RICOMPOSIZIONE_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP SONDA_OROLOGIO_INDICI_RICOMPOSIZIONE_ DI ADESSO: la riga non e'' arrivata alla raccolta' };
    if($rc -ne 0){ Write-Host 'PARZIALE O CON PROBLEMI: lo zip esiste lo stesso, mandalo e leggi i PROBLEMI nel REFERTO.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan; }
```

- ✅ **QUASI ISTANTANEO, E PER COSTRUZIONE**: `-Ricomponi` **non chiama nemmeno**
  il driver generico, **non apre MT5**, **non compila**. Rilegge i CSV e
  ricalcola **I1** e **I7**. Nel referto lo dichiara: `modo: RICOMPOSIZIONE`,
  `cronometro: non pertinente`, e per **ogni cella** la riga *"il tester ha
  girato in questo giro: **NO, ED È IL MESTIERE DI QUESTO MODO**: CSV riletti,
  scritti il `<data e ora>`"*. **Quelle date sono il controllo di freschezza.**
- 🔴 **Se una cella non è ancora girata**, finisce nei **PROBLEMI** ed esce **1**:
  I1 e I7 **non si leggono** finché ne manca una.
- 🔴 **IL PIN DEVE ESSERE LO STESSO** delle quattro celle. Con un pin diverso la
  riga **cancella `risultati_prove\`** e le celle già girate **sono perse**.

---

## 📦 COSA TORNA INDIETRO

Cartella e zip sul **Desktop**: `SONDA_OROLOGIO_INDICI_<MODO>_<data>_<ora>` —
dentro:

- **`REFERTO_SONDA_OROLOGIO_INDICI.txt`** ← **è questo che conta**;
- **`SONDA_OROLOGIO_INDICI.txt`** (la specifica coi criteri I1-I8: viaggia con
  lo zip apposta, così i criteri si leggono **prima** della tabella);
- i **file prova** delle celle che hanno girato;
- i **CSV** `ABTG_SondaOrologio_<SIMBOLO>_IS_<cella>.csv` e `_OOS_<cella>.csv`;
- `COMPILAZIONE_FALLITA.log`, **se** la compilazione è fallita.

### 📅 Le righe da guardare per prime nel referto

1. **`giro: INDICI`** — se dice `FX` hai lanciato l'altra pagina;
2. **`modo:`** — `CORSA` (il risultato) / `CONTROLLO` (giro a vuoto: **non è un
   risultato**) / `RICOMPOSIZIONE` (rilettura dichiarata: **nessun numero nuovo**);
3. **`data:`** — **deve essere di ADESSO**;
4. **`cache tester:`** — `prima N file, dopo 0`;
5. **`il tester ha girato in questo giro:`** (una per cella) — in `CORSA` deve
   dire **SI**. Un **NO** lì è un **PROBLEMA**: quei numeri vengono da un altro giro.

---

## 🔬 IL COLLAUDO STA NEL REFERTO, **IN COLONNE** — non nella scheda Esperti

⚠️ In **ottimizzazione** le `Print` girano **sugli agent** e non le legge
nessuno. Per questo l'EA porta il collaudo **dentro il CSV** e il driver ne fa
dei **gate**:

| colonna | come si legge |
|---|---|
| **`Autotest Falliti` = 0** | gli **8 blocchi** dell'autotest sono passati: i numeri **si leggono** |
| **`Autotest Falliti` > 0** | **i numeri NON si leggono** → **PROBLEMI** |
| 🔴 **`Notti Attraversate` = 0** | la chiusura forzata di fine giornata è stata **ermetica**. > 0 = **posizione viva a cavallo della notte** → **PROBLEMI** |
| **`Giorni Saltati Spread` = 0** | canarino: il filtro di spread è pinnato a 0. Se > 0, **il file prova che ha girato non è quello che credevamo** |
| **`Uscite Stop O Orfane`** | lo stop di 10 ATR doveva essere un **paracadute mai aperto**. Sopra l'1% → **RILIEVO** |
| **`Giornate Operate` ≥ 150** | criterio **I5**, per fascia **e per metà IS/OOS**. Sotto → **RILIEVO**: il **MERITO** resta sospeso, il **RISCHIO** no |

---

## 🚩 COME SI LEGGE LA TABELLA

1. 🕐 **ORA SERVER FISSA (criterio I6), errore dichiarato e NON corretto.**
   Server BCM = **ora italiana − 1**; le ore d'ufficio di Londra e New York si
   spostano rispetto all'ora server per **~4 settimane l'anno**. ⚠️ **Sul Dow
   morde di più che sul DAX.**
2. 📏 **Il "lordo" è la deriva sul BID**, non il risultato eseguito. Lo spread
   resta **fuori** dalla misura **apposta**, perché I1 lo confronta a parte.
3. ⚖️ **La `Peggior Giornata %` è CONDIZIONATA ALLA TAGLIA** (rischio 1% su stop
   10 ATR = lotto piccolo): **non è il rischio di una versione operabile**. Si
   riporta **sempre** (criterio **I4**: il rischio non si sospende mai), con
   l'etichetta attaccata.
4. ⏳ **Sulle durate 8 e 12 ore** la posizione resta aperta oltre la chiusura del
   cash (DAX 17:30 server): **la colonna dello spread è misurata NELL'ORA
   D'INGRESSO e non descrive il costo dell'USCITA.**
5. 🎯 **I1 è il CANCELLO ZERO, non il verdetto**, ed è contato nella **LETTURA
   SEVERA**: *la STESSA fascia* (stessa ora **e** stessa durata) sopra soglia su
   **ENTRAMBI** i simboli. La lettura larga è stampata accanto, **etichettata
   `NON è il verdetto`**. **I2** (mai il picco: 288 celle, a caso qualcuna è
   verde) e **I3** (altopiano, non picco) il driver **non li adjudica**.
6. 🔴 **E LA COSA CHE PUÒ RIBALTARE TUTTO: I7, LA LETTURA APPAIATA DEI DUE LATI.**
   La finestra è **UN REGIME SOLO (toro pieno)**: una fascia LONG può uscire
   verde **solo perché l'indice è salito**. Il referto stampa una sezione con
   LONG e SHORT **sulla stessa riga** e due numeri:
   - **`deriva = (lordo LONG − lordo SHORT) / 2`** → è **il toro**;
   - **`asimm  = (lordo LONG + lordo SHORT) / 2`** → è **quello che resta** quando
     i due lati si annullano.
   Se **|asimm| ≤ |deriva|** la riga esce **`DERIVA`**: quella cella **non è un
   orologio**. Solo le righe **`ASIMM`** meritano di essere guardate — e poi
   vanno passate lo stesso da **I2** e **I3**.

> 🟢 **E se tutte le righe escono `DERIVA`, o la tabella è PIATTA, l'esito è
> VALIDO e va scritto così:** il caduto **D7** (l'ora del fix, chiuso il 22/08)
> esce **CONFERMATO ED ESTESO AGLI INDICI** e la pista dell'orologio **si chiude
> con un numero NOSTRO**. È un risultato, non un fallimento.

---

## ✅ COSA È GIÀ STATO VERIFICATO — **eseguendo**, prima dell'invio

Driver portato alla **v4** ed **ESEGUITO** su banco stubbato (`Scarica` → copia
locale, CSV OPTFRAME sintetici con l'**intestazione vera** dell'EA):

- ✅ **`Parser::ParseFile` → 0 errori**; **ASCII puro** (0 byte > 127, regola del
  17/08); **0 collisioni case-insensitive**; non usa `$args`;
- ✅ 🔴 **IL RAMO FX NON SI È MOSSO, ed è misurato**: driver v3 e driver v4 girati
  sullo **stesso banco** danno lo **stesso referto riga per riga** (546 righe di
  tabelle e di conti) tranne **due righe nuove** (`giro:`, `tick:`) e quattro
  blocchi di prosa resi generici. **Nessun numero cambia**;
- ✅ **selezione delle celle provata a secco**: `-Giro INDICI` → **esattamente**
  `11_d30eur_long, 12_d30eur_short, 13_u30usd_long, 14_u30usd_short` coi magic
  `777211-777214` e i 4 file prova giusti; `-Giro FX` → le 7 di prima;
- ✅ **8 guardie**: senza `-Giro` (**exit 2, nessun referto**), `-Giro` sbagliato,
  INDICI senza scelta (si ferma col menu), cella inesistente, `-Ricomponi`
  mescolato, pin corto, FX 7 celle, INDICI 4 celle;
- ✅ **15 mutazioni dei quattro file prova → 15 fermate**, col **controllo
  positivo** prima: pin dell'ora cambiato, griglia stretta, magic del ramo
  forex, magic di una sedia viva, magic duplicato, lati scambiati, `@SIMBOLO`
  scambiato, `@DAQUANDO` sotto il pavimento, `@FINOA` tolta, `@PERIODO` M15,
  baseline dello stop, parametro di prezzo intruso, riga a 4 campi, asse Y in
  più, asse Y mancante;
- ✅ **I7 provato sui numeri**: righe simmetriche-opposte → `DERIVA`; riga
  asimmetrica seminata (L +10 / S +6) → `ASIMM` con `deriva=2` e `asimm=8`;
  lato mancante → `NON LEGGIBILE` ed exit 1;
- ✅ i **13 nomi degli input** dei file prova esistono nel `.mq5`, **uno per uno**
  (se un nome non esistesse, MT5 lo ignorerebbe **in silenzio** e la corsa
  risponderebbe a un'altra domanda);
- ✅ **raw di GitHub al pin**: HTTP **200** e **sha256 identico al repo** per
  tutti e **otto** gli artefatti scaricati;
- 🔴 **difetto trovato ESEGUENDO e corretto**: in PowerShell `-f` lega più
  stretto di `+`, e una riga di classifica stampava i segnaposti `{0,2}` così
  com'erano. **Leggendo non si vedeva.**

🟡 **Non verificato, e va detto**: tutto ciò che richiede **MT5** — la
**compilazione** dell'EA (qui non c'è MetaEditor), l'esito dell'**autotest**, il
comportamento del **flat sui tick veri**, la **durata** e **ogni singolo numero**.
Il blocco 1️⃣ copre gli artefatti **e la compilazione**; **i numeri li può dare
solo la corsa**.
