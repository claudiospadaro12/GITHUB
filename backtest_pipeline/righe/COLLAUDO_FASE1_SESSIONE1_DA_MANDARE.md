# 🛡️🧪 COLLAUDO ENFORCEMENT — **SESSIONE 1: CAP C1 + FAIL-OPEN** — DA MANDARE

**Che cos'è.** L'azione **G2** del pacchetto
`report/COLLAUDO_ENFORCEMENT_FASE1_2026-09-02.md`: la sessione da **~45 minuti**
che collauda in campo i **criteri 7 (il cap che rifiuta l'ingresso)** e
**8 (fail-open: Guardian rimosso → la flotta riparte)** sul **100k (50504263)**.
Le attese sono quelle **congelate il 02/09** in
`backtest_pipeline/attese_enforcement_fase1.txt`: le stringhe qui sotto le
scaricano **dal pin** e le cercano nel log — il cancello non dipende dall'occhio.

> 🚦 **La sessione 2 (pausa B1 + gestione, criteri 5 e 6) NON si fa oggi.**
> Il piano lo vieta esplicitamente: **mai le due sessioni lo stesso giorno**.

---

## 🛑 DOVE GIRA, E CHI FA COSA — leggilo prima di tutto

> 🖥️ **Tutto questo si fa sul VPS**, sull'istanza **`-V3`** (il terminale del
> conto **50504263**), che è **IL FORWARD VERO**.
>
> 🤖 **Le tre righe PowerShell di questa pagina sono di SOLA LETTURA.**
> Non aprono MT5, non lo chiudono, non scrivono niente dentro
> `%APPDATA%\MetaQuotes\Terminal`, non toccano `.chr`, `.set`, grafici, EA o
> ordini. Leggono i log (**MT5 resta APERTO**: la lettura è condivisa) e i
> referti del canarino, e scrivono **solo sul Desktop**.
>
> 👤 **Ogni gesto che CAMBIA STATO lo fai TU a mano**, con la legge dello
> screenshot: abbassare il cap, togliere il Guardian, rimetterlo. Nessuna riga
> di questa pagina può farlo — non è una promessa, è che quel codice **non
> esiste**.
>
> 🖥️ **Il PC di backtest non c'entra**: la **DUKA** che sta girando lì è puro
> HTTP e **non viene toccata da niente di questa pagina**.
>
> 🚫 **NON si compila e NON si ricompila NIENTE** (decisione **D1** del 02/09 e
> divieto **NO.5** dell'artefatto): si collauda **esattamente il software che sta
> in campo**. Il **canarino** è già installato e compilato sul 100k
> (pin `640fd93`, v1.01, prima corsa **verde** il 02/09).

---

## ⏰ L'ORA GIUSTA PER FARLA (e perché non è un dettaglio)

- Le finestre operative si contano in **ORA SERVER = ora italiana − 1**; le
  schede **Esperti/Giornale** sono in **ora LOCALE del VPS = ora italiana**.
- Il criterio 7 **pretende almeno UNA POSIZIONE APERTA CON SL** (P-5): con
  `rischio aperto = 0,00%` il cap **non è innescabile a nessuna soglia**
  (rilievo R1: con `riskPct=0` l'unico valore che morderebbe è `0`, che
  significa "spento"). **Questa è la ragione numero uno per cui la sessione si
  rimanda**, e la riga 1️⃣ te lo dice prima che tu tocchi qualsiasi cosa.
- 🥇 **Finestra consigliata: 14:30–15:30 SERVER = 15:30–16:30 italiane.** È
  l'intersezione fra le finestre d'ingresso `WIN.3` (Dow retest) e `WIN.4` (ORB)
  dell'artefatto **e** l'orario in cui una posizione DAX/Dow della giornata è
  tipicamente ancora aperta (flat 17:30 server).
- Vanno bene anche le altre finestre dell'artefatto, purché ci sia una
  posizione aperta con SL: DAX 08:35–17:30, Dow 15:05–17:30, MaxMin al mattino,
  STREV 225JPY su H2 (tutte **ora server**).

---

## ⚖️ IL COSTO, DETTO PRIMA (X11 / R9)

Con il cap abbassato, per **tutta la durata della sessione** i 5 mirror **non
aprono**. Un blocco forzato **PERDE quel trade, non lo rimanda**. E fra il
passo 🔟 (Guardian rimosso) e il 1️⃣2️⃣ (Guardian rimesso) — circa **4 minuti** — il 100k è **senza rete**.
👉 **Alla fine, annota nella pagella del giorno i trade persi** (azione G7):
altrimenti M27 e H5 misurano un buco che è **nostro**.

---

## 📌 IL PIN — **`2e37a67db8c1345acfa2a3870d50e115f0695034`**  ✅ **INSERITO** — driver **v2**, marcatore `MARCATORE_RIGA_COLLAUDO_FASE1_S1_v2` (verificato con `git rev-parse` e `git ls-tree`: a questo commit ci sono il driver v2 e l'artefatto `backtest_pipeline/attese_enforcement_fase1.txt` che le tre righe scaricano). ⛔ Il pin `223e1f7` e il marcatore `..._v1` sono **BRUCIATI** (la v1 e' quella che si e' fermata sul VPS alle 10:45): non incollarli piu'.

---

## 🧭 SE LA RIGA 1 SI FERMA SULLA CARTELLA DATI (successo il 03/09 alle 10:45)

Il **primo tentativo in campo si è fermato** con _«terminale -V3 non trovato»_:
il driver **v1** cercava la scrittura `-V3` dentro `origin.txt` sotto
`%APPDATA%\MetaQuotes\Terminal`, e sull'installazione vera non combacia (**il
nome non è un fatto**: un MT5 **portable** tiene i dati dentro la cartella
d'installazione e non ha nessun `origin.txt`).

Il driver **v2** cerca per **FATTI**: il conto **50504263** nei log, la riga
`[GUARDIAN] filo verificato ... (conto 50504263)`, i referti del canarino
intestati a quel login. E scandisce **largo**: processi `terminal64` vivi,
cartelle dati di **tutti** i profili utente, installazioni sotto
`C:\Program Files`, `C:\Program Files (x86)`, `C:\`, `D:\`.

**Se anche così si ferma, non indovina**: stampa `=== CARTELLE GUARDATE ===`
con **tutte** le cartelle esaminate e, per ognuna, i login visti, se c'è il
conto del collaudo, quanti referti del canarino, l'`origin.txt`. Due casi:

| cosa dice | cosa fare |
|---|---|
| **NESSUNA cartella con evidenza** | guarda l'elenco: se riconosci la cartella dell'istanza del 100k, rilancia **la stessa riga** con in coda `-CartellaDati '<percorso>'` |
| **AMBIGUO: 2+ cartelle con evidenza** | idem, `-CartellaDati '<percorso giusto>'` — e **dimmelo**, perché due cartelle vive sullo stesso conto possono anche voler dire **due terminali** (violazione B9) |

📍 **Il percorso vero lo dà MT5 in due secondi**: sull'istanza del 100k →
menu **File > Apri la cartella dei dati** → è **quella** cartella (quella che
contiene `logs\`, `MQL5\`, `config\`). Copiami il percorso dalla barra degli
indirizzi e mettilo dopo `-CartellaDati`.

⚠️ **`-CartellaDati` non salta nessun controllo**: se la cartella imposta non ha
traccia del conto 50504263, la riga **va avanti ma lo scrive nel referto**, e il
controllo P-1 sul conto resta al suo posto (se il login è un altro → **ROSSO**).

---

# ▶️ LA SEQUENZA — 15 passi, in quest'ordine

## 1️⃣ RIGA 1 — **LETTURA PRIMA** (PowerShell sul VPS, ~30 secondi)

Legge il terminale `-V3`, il conto, l'artefatto dal pin, il log di oggi, e
scrive il **segnaposto d'inizio sessione** (serve alla riga 3️⃣ per non
confondere le righe di stamattina con quelle della prova).

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='2e37a67db8c1345acfa2a3870d50e115f0695034'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_COLLAUDO_FASE1_S1.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_COLLAUDO_FASE1_S1.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_COLLAUDO_FASE1_S1_v2' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin; $rc=$LASTEXITCODE;
    $r=@(Get-ChildItem -Path (Join-Path $env:USERPROFILE 'Desktop\COLLAUDO_FASE1_S1_*\RIGA_REFERTO_COLLAUDO_FASE1_S1.txt'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop\COLLAUDO_FASE1_S1_*\RIGA_REFERTO_COLLAUDO_FASE1_S1.txt') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($r.Count -eq 0){ throw 'NESSUN REFERTO DI ADESSO sul Desktop: copiami il rosso qui sopra.' };
    $z=@(Get-ChildItem -Path (Join-Path $env:USERPROFILE 'Desktop\COLLAUDO_FASE1_S1_*.zip'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop\COLLAUDO_FASE1_S1_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    $ko=(($rc -is [int]) -and ($rc -ne 0));
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO, non il numero.' -ForegroundColor Yellow };
    if($ko){ Write-Host 'LETTURA NON COMPLETA (1 = fermata/rosso, 2 = parziale): mandamela lo stesso.' -ForegroundColor Yellow };
    if($z.Count -gt 0){ Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan } else { Write-Host ('ZIP NON FATTO: mandami questa cartella -> ' + $r[0].DirectoryName) -ForegroundColor Yellow };
    $iv=[Globalization.CultureInfo]::InvariantCulture;
    Write-Host ('POI nel referto: riga data: = ORA DI AVVIO (circa ' + $t0.ToString('yyyy-MM-dd HH:mm',$iv) + '), riga fine: = quando ha finito. La freschezza l''ha gia'' controllata a macchina il filtro qui sopra.') -ForegroundColor Gray }
```

**✅ Esito atteso (dal file delle attese):**

| cosa | atteso |
|---|---|
| `P-1 CONTO ATTIVO` | **50504263** (verde). Se esce un altro numero → **esito ROSSO, uscita 1: ci si ferma qui** |
| `ARTEFATTO dal pin` | 12 ATTESA, 4 VIETATA, 2 CAMPO |
| `PRE.FILO` + `PRE.CONTO` | ≥ 1 riga `[GUARDIAN] filo verificato: 5 GlobalVariable su 5 ... (conto 50504263)` |
| `PRE.SOGLIE` | riga `pausa morbida=4.00%  cap rischio aperto=3.25%` |
| righe **VIETATE** | **0** (`STOP.FILO`, `STOP.DAILY`, `STOP.TOTALE`, `STOP.AUTOTEST`) |
| `ULTIMO cap dichiarato nel log` | **3.25% = configurazione firmata** |
| `MASSIMO rischioAperto` | **> 0,00%** |

🧭 **Se invece si ferma su `cartella dati del 100k non identificata`**: non è la
sessione a saltare, è la scoperta — vedi la sezione qui sopra e rilancia con
`-CartellaDati`.

🔴 **GATE — se `rischio aperto` è 0,00%: LA SESSIONE SI RIMANDA.** Non è un
fallimento del cap: è il criterio 7 che **non è innescabile** senza una
posizione aperta con SL (R1 / X6). Si riprova in una finestra con posizione
viva. **Non si abbassa niente "per vedere".**

---

## 2️⃣ P-2 — **un solo Guardian** (menu **Finestra** dell'istanza `-V3`)

📸 **Screenshot.** Due Guardian sullo stesso conto si timbrano addosso a vicenda
(regola B9, rischio X4). La riga 1️⃣ ti dà solo una **spia** (i contesti che
scrivono `[GUARDIAN]`): **la prova è il menu Finestra**.

## 3️⃣ P-3 / P-4 / P-5 — **il pannello PRIMA**

📸 **Screenshot del pannello del Guardian** e **annota su un foglio**:

- soglie **4,9 / 9,9 / pausa 4,0 / cap 3,25** e `Azione: CHIUDI+BLOCCA`;
- **saldo, equity, `Perdita oggi`**;
- **`Rischio aperto: X.XX%`** ← **è il numero che ti serve al passo 5️⃣**;
- **quante posizioni aperte** ci sono e se hanno lo **SL**.

## 4️⃣ Parametri dell'EA che presidierai — 📸 screenshot

Apri la scheda **Parametri** dell'EA della finestra che presidi (Dow o ORB se
segui il consiglio dell'orario) e verifica **due campi**:

- **`InpUsaGuardian` = true** — se fosse `false`, quell'EA non chiede niente a
  nessuno e il suo silenzio non vuol dire niente (spia X1);
- **`InpMaxPosSimbolo` = 0** — è il tetto "A1" per simbolo, e in campo è la
  forma che esiste del tetto **P0**. La nota `ROUND.PRECEDENZA` dell'artefatto
  dice che durante il collaudo del cap **il tetto della sedia di prova deve
  restare 0**: se fosse > 0, l'EA potrebbe **non tentare** l'ingresso per un
  motivo che **non è il cap**, e il silenzio verrebbe letto male.
  _(Il P0 vero e proprio non esiste nei binari in campo: sono compilati con
  l'include **v1.20**, che il P0 non ce l'ha. È 0 **per costruzione** — e resta
  vero finché non si ricompila, cioè per tutta la fase 1.)_

## 5️⃣ CANARINO — **corsa 1: la fotografia PRIMA**

Trascina lo Script **`ABTG_CanarinoGuardian`** su **un grafico qualsiasi**
dell'istanza `-V3` e premi OK (`InpGiornoOffset` resta **0**). Gira una volta,
stampa e finisce: **non manda ordini, non scrive GlobalVariable**.

**✅ Atteso nel Giornale/Esperti (tutte le righe iniziano con `[CANARINO]`):**
`login=50504263` · `ABTG_CanaleEsiste() = SI` · `CAP C1 grezzo=NO ricalcolato=NO`
· `GUARDIAN VIVO grezzo=SI ricalcolato=SI` · `MOTIVO ... 0 = nessuno` ·
`ESITO PER UN EA ADESSO: un ingresso sarebbe PERMESSO` ·
`AUTOTEST: 8 blocchi su 8 passati` · `nessun rilievo` ·
`rischio aperto ... > 0`.

---

## 6️⃣ 🔧 **IL GESTO** — abbassare **`InpMaxOpenRiskPct`** (solo quello)

Sul grafico del **Guardian**: tasto destro → **Consulenti → Proprietà** →
scheda **Parametri** → **`InpMaxOpenRiskPct`** = un valore **appena sotto** il
`Rischio aperto` letto al passo 3️⃣ (es. rischio **0,63%** → metti **0,50**).
Poi OK.

> 🛑🛑 **`InpDailyLossPct` NON SI TOCCA MAI** (rilievo R3): con `InpAction=0`
> quel campo esegue **`FlattenAll()`** — chiude **tutte** le posizioni e
> cancella **tutti** i pendenti del conto, di qualsiasi magic. Sta nella stessa
> finestra, due righe più su. **Guarda il nome del campo due volte.**
>
> ⚠️ **Nota tecnica (X12/R8):** premere OK **riavvia** il Guardian
> (`OnDeinit`+`OnInit`): per ~1 secondo il canale è "libero" e nel log può
> comparire un `via libera` **all'ora esatta del click**. È **per disegno**: si
> annota, non si indaga.

## 7️⃣ Verifica del gesto — 📸 screenshot del pannello

Dopo **un giro di timer (1 secondo)** il pannello deve dire:
**`Rischio aperto: 0.63% / cap 0.50% -> CAP ATTIVO`** (coi tuoi numeri).
Nel log dev'essere comparsa la riga
**`[GUARDIAN] * CAP RISCHIO APERTO attivo: 0.63% >= 0.50% (nuovi ingressi sospesi)`**
(attesa **C7.GUARDIAN**).

## 8️⃣ CANARINO — **corsa 2: col cap ATTIVO** (è la prova deterministica del criterio 7)

**✅ Atteso:** `CAP C1 grezzo=SI ricalcolato=SI -> coerenti` ·
`MOTIVO ... 2 = CAP RISCHIO APERTO raggiunto (firma C1)` ·
**`ESITO PER UN EA ADESSO: un ingresso sarebbe FERMATO`**.

> Questo dimostra che **il canale e l'include** fermano l'ingresso. Che lo
> facciano anche i **binari dei 5 mirror** lo dimostra solo la riga `[GUARDIA]`
> di un EA vero — ed è il passo 9️⃣.

## 9️⃣ RIGA 2 — **PRESIDIO 20 minuti** (console, dal vivo)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='2e37a67db8c1345acfa2a3870d50e115f0695034'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_COLLAUDO_FASE1_S1.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_COLLAUDO_FASE1_S1.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_COLLAUDO_FASE1_S1_v2' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Presidio -Minuti 20; $rc=$LASTEXITCODE;
    $r=@(Get-ChildItem -Path (Join-Path $env:USERPROFILE 'Desktop\COLLAUDO_FASE1_S1_*\RIGA_REFERTO_COLLAUDO_FASE1_S1.txt'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop\COLLAUDO_FASE1_S1_*\RIGA_REFERTO_COLLAUDO_FASE1_S1.txt') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($r.Count -eq 0){ throw 'NESSUN REFERTO DI ADESSO sul Desktop: copiami il rosso qui sopra.' };
    $ko=(($rc -is [int]) -and ($rc -ne 0));
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO, non il numero.' -ForegroundColor Yellow };
    if($ko){ Write-Host 'PRESIDIO CHIUSO CON RILIEVI: guarda il referto.' -ForegroundColor Yellow };
    Write-Host ('referto di questo presidio: ' + $r[0].FullName) -ForegroundColor Cyan }
```

**✅ Atteso (se un EA prova davvero a entrare):**
`[GUARDIA] <nome>: INGRESSO BLOCCATO -- CAP RISCHIO APERTO raggiunto (firma C1). Rischio aperto X.XX%.` (attesa **C7.EA**)
📸 **e nella scheda Trade/Storico NON deve comparire nessun ordine nuovo** in
quella finestra: **quella parte la vede solo il tuo occhio** — fai lo
screenshot.

- 🟡 **Zero righe non è un PASS: è NON MISURATO.** Vuol dire che nessun EA
  voleva entrare. Si ripete in un'altra finestra, non si promuove.
- ⚠️ **Non è un FAIL** se scatta un **pendente piazzato prima**: la guardia è un
  cap sull'**AGGIUNTA** di rischio, non un cap istantaneo (limite noto n.1).
  Si annota.

---

## 🔟 🚪 **IL GESTO** — togliere il Guardian dal grafico (criterio 8)

Sul grafico del Guardian: tasto destro → **Consulenti → Rimuovi**.
⏱️ **Annota l'orario al secondo** (📸 screenshot con l'orologio di Windows).

> 🔴 **Da qui il 100k è SENZA RETE.** Il passo 1️⃣2️⃣ non è opzionale, ed è a 4
> minuti di distanza. Non ti allontanare dal PC.
> 🛑 **La prova del fail-open si fa col CAP, MAI con la PAUSA** (divieto `NO.2`
> dell'artefatto): sono due fail-open diversi **per disegno** — la pausa ha una
> scadenza dichiarata e **deve** sopravvivere alla morte del guardiano.

## 1️⃣1️⃣ Aspetta **180 secondi**, poi CANARINO — **corsa 3: il fail-open**

(La tolleranza del battito è **120 s**: 180 sono margine.)

**✅ Atteso — ed è la misura, non un'impressione:**

| riga del canarino | valore atteso | cosa dimostra |
|---|---|---|
| `CAP C1  grezzo=SI  ricalcolato=NO -> DIVERGONO` | sì | il timbro c'è ma è **scaduto per anzianità** |
| `*** RILIEVO *** CAP: IL GREZZO E IL RICALCOLATO DIVERGONO` | sì | **qui il rilievo è il PASS**, lo dice il canarino stesso |
| `dettaglio: ultimo timbro ... cioe' N secondi fa` | **N > 120** | quanto è durato davvero il fail-open |
| `GUARDIAN VIVO grezzo=NO ricalcolato=NO` | sì | `OnDeinit` ha azzerato il battito |
| `MOTIVO ... 0 = nessuno` · `ESITO ... PERMESSO` | sì | **un EA adesso potrebbe entrare: la flotta è ripartita** |

**In più, se un EA vero richiama la guardia in quei minuti** (attesa **C8.RIENTRO**):
`[GUARDIA] <nome>: via libera, il blocco e' rientrato (CAP RISCHIO APERTO raggiunto (firma C1)). Rischio aperto X.XX%`
→ **PASS pieno.** Se non compare: 🟡 **NON MISURATO sul lato EA**, con la parte
deterministica (canale + include) comunque **verde**.

## 1️⃣2️⃣ 🔧 **IL GESTO** — rimettere il Guardian e **riportare tutto a casa**

Trascina **`ABTG_Guardian`** sullo **stesso grafico**. ⚠️ **La finestra dei
parametri arriva con il cap ANCORA ABBASSATO** (MT5 ricorda gli ultimi valori
usati): **prima di premere OK**, campo per campo:

| campo | valore |
|---|---|
| `InpDailyLossPct` | **4.9** |
| `InpTotalDDPct` | **9.9** |
| `InpDailyPausePct` | **4.0** |
| `InpMaxOpenRiskPct` | **3.25** ← è quello che avevi abbassato |
| `InpAction` | **CHIUDI+BLOCCA** |

📸 **Screenshot della finestra parametri PRIMA di OK** e 📸 **del pannello dopo**.
Nel log deve ricomparire `pausa morbida=4.00%  cap rischio aperto=3.25%`
(attesa **PRE.SOGLIE**): è la prova a macchina che il 100k è tornato alla
configurazione firmata (condizione **C-5** del cancello).

## 1️⃣3️⃣ CANARINO — **corsa 4: dopo il ripristino**

**✅ Atteso:** `CAP C1 grezzo=NO ricalcolato=NO` · `GUARDIAN VIVO grezzo=SI ricalcolato=SI`
· `MOTIVO ... 0` · `ESITO ... PERMESSO` · **`nessun rilievo`**.

## 1️⃣4️⃣ RIGA 3 — **RACCOLTA FINALE** (referto + zip da mandarmi)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='2e37a67db8c1345acfa2a3870d50e115f0695034'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_COLLAUDO_FASE1_S1.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_COLLAUDO_FASE1_S1.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_COLLAUDO_FASE1_S1_v2' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Chiusura; $rc=$LASTEXITCODE;
    $r=@(Get-ChildItem -Path (Join-Path $env:USERPROFILE 'Desktop\COLLAUDO_FASE1_S1_*\RIGA_REFERTO_COLLAUDO_FASE1_S1.txt'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop\COLLAUDO_FASE1_S1_*\RIGA_REFERTO_COLLAUDO_FASE1_S1.txt') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($r.Count -eq 0){ throw 'NESSUN REFERTO DI ADESSO sul Desktop: copiami il rosso qui sopra.' };
    $z=@(Get-ChildItem -Path (Join-Path $env:USERPROFILE 'Desktop\COLLAUDO_FASE1_S1_*.zip'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop\COLLAUDO_FASE1_S1_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    $ko=(($rc -is [int]) -and ($rc -ne 0));
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO, non il numero.' -ForegroundColor Yellow };
    if($ko){ Write-Host 'ESITO NON VERDE (1 = rosso/fermata, 2 = parziale): mandamelo LO STESSO, e'' quello che serve.' -ForegroundColor Yellow };
    if($z.Count -gt 0){ Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan } else { Write-Host ('ZIP NON FATTO: mandami questa cartella -> ' + $r[0].DirectoryName) -ForegroundColor Yellow };
    $iv=[Globalization.CultureInfo]::InvariantCulture;
    Write-Host ('POI nel referto: riga data: = ORA DI AVVIO (circa ' + $t0.ToString('yyyy-MM-dd HH:mm',$iv) + '), riga fine: = quando ha finito, riga esito:. La freschezza l''ha gia'' controllata a macchina il filtro qui sopra.') -ForegroundColor Gray }
```

💡 Se vuoi che il referto ripeta anche **l'ora di rimozione** che hai annotato
al passo 🔟, aggiungi `-OraRimozione '15:45:30'` (con **la tua** ora) dopo
`-Chiusura`. **Non è necessario**: l'attesa vera la misura il canarino
(`N secondi fa`), che è più precisa di un appunto a mano.

## 1️⃣5️⃣ E per ultimo: **G7** — annota nella pagella di oggi i **trade persi** per i blocchi forzati.

---

## 📤 Cosa arriva sul Desktop (ogni riga, anche quelle che falliscono)

- Cartella `COLLAUDO_FASE1_S1_<data_ora>` con
  **`RIGA_REFERTO_COLLAUDO_FASE1_S1.txt`** (i PASSI + tutto il censimento),
  la copia del **log Esperti** e del **giornale** della giornata, i **referti
  del canarino** di oggi e la copia dell'**artefatto** scaricato dal pin.
- Zip omonimo `COLLAUDO_FASE1_S1_<data_ora>.zip` → **è quello che mi mandi**.
- `COLLAUDO_FASE1_S1_SEGNAPOSTO.txt` — lo scrive la riga 1️⃣: dice alla riga 3️⃣
  da che ora in poi contano le righe.

## 🔎 COME SI LEGGE IL REFERTO

1. **In testa, i PASSI** (`terminale:` `conto:` `artefatto:` `log:`
   `censimento:` `canarino:` `zip:`): hanno **tre stati veri**
   (`NON TENTATO` / `FALLITO` / `OK`), e sono timbrati dal ramo che li decide.
   Poi la riga **`esito:`**.
2. **`data:` è l'ora di AVVIO della lettura**, `fine:` è quando ha finito. La
   freschezza l'ha già controllata **a macchina** il filtro `LastWriteTime` del
   blocco che hai lanciato: la frase in italiano lo **cita**, non lo rifà.
3. **Il censimento**: per ogni chiave dell'artefatto, quante righe e quali,
   con il conto separato di **quante sono dopo il segnaposto** (cioè dentro la
   sessione).
4. **La traccia delle soglie**: ogni riavvio del Guardian con il valore del cap
   dichiarato in quel momento — è il **diario a macchina dei tuoi gesti**:
   `3.25 → 0.50 → 3.25`. L'ultima riga deve dire **3.25 = configurazione
   firmata**.
5. **I referti del canarino**, classificati da soli: *cap attivo* / *fail-open*
   / *cap spento*.
6. **Il verdetto a macchina**, con tre stati e senza barare: dice **PASS**,
   **NON MISURATO** o **ROSSO**, e dichiara in fondo **quello che nessuna
   macchina può dire** e che resta ai tuoi screenshot.

## ⚠️ DUE COSE DA SAPERE PRIMA DI LEGGERE (le trova il referto, ma meglio prima)

1. **`C7.RIENTRO` (`[GUARDIAN] cap rischio aperto rientrato:`) NON comparirà — e
   NON è un fallimento.** Il Guardian stampa quella riga solo se la bandiera
   `GV_CAP` è ancora accesa quando il rischio rientra; ma **ogni cambio di
   parametri e ogni riattacco passano da `OnInit`, che azzera `GV_CAP` in
   silenzio**. Quando rimetti il cap a 3,25 la bandiera è già a zero: la riga
   non esce. Comparirebbe solo se una posizione si chiudesse **mentre** il
   Guardian gira con la soglia ancora bassa. Il referto lo scrive nero su
   bianco: **la sua assenza non si conta come FAIL del criterio 7.**
2. **I "blocchi orfani" si contano in DUE modi** e il referto stampa entrambi:
   la regola **letterale** dell'artefatto («causa nello **stesso minuto**») è
   più severa del codice — il Guardian scrive la causa **una volta sola**, al
   cambio di stato, e un EA può bloccare **dieci minuti dopo**. Il numero che
   conta è quello della **causa vigente**. È materiale del **criterio 9**: va
   deciso **prima** di quella sessione, non dopo.

## 🔢 Codici d'uscita

| codice | cosa vuol dire | cosa mandare |
|---|---|---|
| **0** | lettura completa | lo zip |
| **2** | parziale: artefatto non scaricato o log del giorno mancante | lo zip **lo stesso** (dice cosa manca) |
| **1** | **ROSSO**: conto sbagliato, riga VIETATA nel log, pin assente/malformato | lo zip **lo stesso** + fermarsi |
| **1** | **cartella dati del 100k non identificata** (zero candidate, oppure 2+) | lo zip **lo stesso**: dentro c'è l'elenco completo → rilancia con `-CartellaDati` |
| _(nessuno)_ | il blocco non arriva a lanciare: `irm` fallito o marcatore assente | copiami il **rosso in console** |
