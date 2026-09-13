# 🫀 IL RUNNER SENZA BATTITO — la toppa proposta, **non applicata**

_13/09/2026, notte. Claudio dorme. **Questo file e' una PROPOSTA, non una
modifica.** `backtest_pipeline/runner_abtg.ps1` e' lo script che esegue la coda
sul VPS: e' il pezzo da cui passa tutto il lavoro notturno, e **non si tocca da
soli di notte**. Qui c'e' il diff riga per riga, cosa puo' rompere, e la firma
che serve._

> 🔴 **NESSUN COMMIT SU `runner_abtg.ps1`.** A HEAD `7248c3c` il file e'
> **invariato**, 836 righe. L'unico file committato stanotte e' questo referto.

---

## 0. 🎯 A CHE COSA SERVE, in una riga
Stanotte la coda da 48 righe **non ha pubblicato niente**, e ci sono voluti **~25
minuti** per scoprire **che non si poteva capire perche'**. Le due toppe qui
sotto non fanno girare un round in piu': fanno in modo che **la prossima volta
la risposta si legga dal repo in dieci secondi**. E' **ponteggio, non sedia** —
va detto: la giornata che produce solo ponteggio si dichiara.
🟢 Ma il ponteggio qui **paga**: la coda porta **36 round** che valgono R126,
R127, R133, R136, R142, cioe' i candidati per il 1° ottobre. Una notte persa in
silenzio costa un giorno su tre settimane.

---

## 1. 📏 I FATTI, verificati col comando (non a memoria)

Tutti i numeri di riga di questo referto sono contro **`runner_abtg.ps1` a HEAD
`7248c3cd3b1a43ecd4c511906af3b797fcfc3ea1`**, letto cosi':

```
git show HEAD:backtest_pipeline/runner_abtg.ps1 | nl -ba | sed -n '700,836p'
```

| fatto | dove | verificato |
|---|---|---|
| il file ha **836 righe** | `wc -l` | ✅ |
| `$avvio = Get-Date` | **r.703** | ✅ |
| `$Lavoro` creata | **r.704-705** | ✅ |
| scarico della coda | **r.722-725** | ✅ |
| contatori + `$righe` | **r.727-732** | ✅ |
| inizio del `foreach` | **r.734** | ✅ |
| `$nome` dal **percorso** | **r.767** | ✅ |
| nome del log | **r.770** | ✅ |
| `if($NonPubblicare){ ... exit 0 }` | **r.801** | ✅ |
| ricerca del token, **`exit 4`** se manca | **r.803-806** | ✅ |
| `$headers` / `$apiBase` | **r.808-809** | ✅ |
| `function PubblicaFile` | **r.811-826** | ✅ |
| raccolta dei log `*.log` con `LastWriteTime -ge $avvio` | **r.831** | ✅ |
| `exit 0` finale | **r.836** | ✅ |

E i due difetti, misurati sulla coda di stanotte:

```
grep -v '^\s*#' backtest_pipeline/coda/CODA.txt | grep -v '^\s*$' | wc -l     -> 48
... | awk -F'|' '{print $2}' | sort | uniq -c
     36  backtest_pipeline/righe/RIGA_SOTTILE_ROUND.ps1      <-- STESSO PERCORSO
      1  backtest_pipeline/righe/CODA_01_sedie_attaccate.ps1
      ... (12 righe di sola lettura, una per percorso)
```

🔴 **36 righe su 48 hanno lo stesso percorso.** `$nome` a r.767 viene dal
percorso, quindi il log a r.770 e' **lo stesso nome per tutte e 36**: si
sovrascrivono, e in una corsa **riuscita** ne resta **UNO**, quello dell'ultimo.

---

## 2. 🩺 TOPPA 1 — IL MARCATORE D'AVVIO

### 2.1 🔴 Prima di tutto: **il limite che non si supera**, dichiarato

La domanda giusta e' quella posta: *cosa distingue «non ha pubblicato il
marcatore perche' non e' partito» da «non l'ha pubblicato perche' non ha il
token»?*

> # 🔴 **DAL REPO, DA SOLO: NIENTE. E non e' riparabile con questa toppa.**

La ragione e' strutturale e vale la pena scriverla come **classe**: il marcatore
d'avvio viaggia sulla **stessa credenziale** del canale che sta diagnosticando.
**Un canale di diagnosi che passa dalla stessa credenziale del canale guasto non
e' un canale indipendente**: quando serve davvero, e' guasto anche lui. Qualunque
scrittura sul repo richiede il token; non ci sono altre vie **dentro il
perimetro** (una seconda credenziale e' roba di Claudio, non mia — e non la
propongo di notte).

### 2.2 🧪 IL CONTRO-ESEMPIO CHE HO COSTRUITO CONTRO LA MIA IDEA — e l'ha uccisa

Avevo un'idea che sembrava elegante: **usare un canale gemello gia' esistente**.
`pubblica_trades.ps1` gira alle **22:45** e usa **lo stesso file token** (r.115-117
di quello script: stessa terna `-TokenFile` / `C:\Users\Administrator\
.gh_report_token.txt` / `%USERPROFILE%\...`). Ragionamento: *se alle 22:45 il
commit dei trades c'e' e alle 03:31 il marcatore no, il token era vivo 4h45m
prima → la causa e' «non partito/morto», non «token».*

**L'ho provato contro i dati, e non regge:**

```
git log origin/lavoro --since="2026-08-28" --date=format:'%Y-%m-%d(%a) %H:%M' \
  --pretty="%ad %s" | grep "Aggiornamento automatico trades"
  2026-09-11(Fri) 22:45      2026-09-08(Tue) 22:45
  2026-09-10(Thu) 22:45      2026-09-07(Mon) 22:45
  2026-09-09(Wed) 22:45      2026-09-05(Sat) 17:32   <-- manuale, NON le 22:45
  ...                        2026-08-28(Fri) 22:45 -> poi 2026-08-31(Mon)
```

🔴 **Nei fine settimana quel canale TACE per conto suo** (weekend 29-30/08,
05-06/09, e **12/09**). Cioe': la notte in cui la coda si e' fermata era un
**sabato**, **esattamente la notte in cui il mio discriminante e' cieco**. Se
avessi consegnato quella tabella, avrei fatto dire ai dati *«il token era vivo»*
partendo da un'assenza che **e' normale**.
👉 **L'idea si tiene solo da lunedi' a venerdi', e va scritta con quel limite
attaccato.** Da sola non basta.

### 2.3 ✅ ALLORA LA SECONDA LINEA E' QUESTA (e si dice cosa NON fa)

**Tre pezzi, in ordine di forza:**

1. 🟢 **Il file LOCALE, scritto SEMPRE, prima di qualunque rete.**
   `%USERPROFILE%\abtg_runner\AVVIO_RUNNER_<aaaammgg_hhmmss>.txt`, piu'
   `TOKEN_ASSENTE_<...>.txt` quando il token non c'e'. Costo: zero rete, zero
   token. **Separa i due casi in modo definitivo** — ma **solo se qualcuno
   guarda il VPS**, cioe' con la riga di sola lettura gia' scritta in
   `report/LA_CODA_NON_HA_PUBBLICATO_2026-09-13.md` §3, che elenca i file di
   oggi. ⚠️ **Non e' autonomo: costa un'azione a Claudio.**
2. 🟡 **Il referto della notte PRIMA**, che e' gia' sul repo: se
   `REFERTO_RUNNER_<ieri>.txt` c'e', il token era buono 24 ore fa. **Indizio,
   non prova** (un token puo' scadere in mezzo: le PAT scadono a una **data**,
   e la mezzanotte e' proprio dove cade il confine).
3. 🟠 **Il canale dei trades delle 22:45** — **solo nei giorni feriali**, per
   quanto misurato sopra.

### 2.4 🧩 IL CONTENUTO DEL MARCATORE, e una scelta misurata

Chiesto: ora d'avvio, righe lette, quante round e quante di sola lettura, il
commit della coda. Tre cose su quattro sono fatti immediati. Le altre due
meritano una nota.

**(a) «quante round e quante di sola lettura»: al momento del marcatore NON si
sa, ed e' giusto dirlo.** La corsia si decide in `VagliaScript` (**r.755**),
cioe' **dopo** aver scaricato ciascuno script. Dedurla dal **nome del file**
sarebbe esattamente l'errore di casa (*fidarsi del nome*). 👉 Quindi il marcatore
scrive il **conteggio per PERCORSO**, che e' un fatto (`36 x RIGA_SOTTILE_ROUND
+ 12 x CODA_xx`), e dichiara che la corsia si misura dopo.
_Variante B, piu' cara: un pre-vaglio che scarica e vaglia tutte le righe prima
di eseguirne una. Darebbe il conteggio VERO delle corsie e anticiperebbe tutti i
RIFIUTATO. Costo: 48 scarichi in piu' e una ristrutturazione del ciclo → **piu'
rischio della toppa che deve riparare**. Non la propongo adesso._

**(b) «il commit della coda»: il runner NON lo conosce.** Scarica la coda **per
ramo** (r.722: `.../$Branch/$CodaPath`), non per commit. Ho valutato tre vie e
**misurato** quale regge:

| via | misura | verdetto |
|---|---|---|
| l'`ETag` di raw.githubusercontent | `etag: "84610d39...3c6fe527"` (64 hex). **Non** e' lo sha256 del contenuto (`9019250a...`) **ne'** il blob sha | ❌ **opaco: dal repo non si puo' ricalcolare** → inutile come impronta verificabile |
| una chiamata API `/commits?path=...` | serve **token + rete**, cioe' le due cose che stiamo diagnosticando | ❌ |
| 🟢 **il blob sha-1 di git, calcolato in locale** | `git hash-object backtest_pipeline/coda/CODA.txt` → `6eca3067924ee0be189c1feb882cd5db069c75f3`, e `sha1("blob " + 51119 + NUL + bytes)` da' **lo stesso valore** (verificato) | ✅ **si ricalcola dal repo con un comando** |

👉 Il marcatore pubblica **il blob sha della coda + la lunghezza in byte**.
🧪 **E il contro-esempio e' incorporato**: il blob si calcola sui byte
**ri-codificati** in UTF-8 dalla stringa che `Invoke-WebRequest` ha decodificato.
Se GitHub servisse senza `charset` (oggi manda `text/plain; charset=utf-8`,
verificato) la decodifica sbaglierebbe e l'impronta sarebbe **falsa e
silenziosa**. Per questo si stampa **anche la lunghezza**: alla prima corsa
toppata i due numeri attesi sono **`6eca3067...` e `51119`** (la coda di HEAD
contiene 9 righe con emoji: se il giro-macchina non fosse pulito, si vedrebbe
proprio li'). Se il blob non torna ma la lunghezza si', il difetto e' la
codifica, **non una coda diversa**.

### 2.5 🔧 IL DIFF — TOPPA 1

**Vincolo che comanda la forma del diff:** token, `$headers` e `PubblicaFile`
nascono a **r.803-826**, cioe' **dopo** il ciclo. Per pubblicare all'avvio vanno
**spostati prima** — e **senza portarsi dietro l'`exit 4`**, altrimenti si passa
da *"non pubblica"* a *"non esegue niente"*, che e' **molto peggio**.

#### A) **SPOSTARE** il blocco token/API prima del ciclo

**A1. TOGLIERE r.803-805 e r.808-826** (il token, `$headers`, `$apiBase`, la
funzione `PubblicaFile`). ⚠️ **r.806 resta dov'e'**, invariata:

```
if(-not $tok){ Write-Host "TOKEN NON TROVATO: il referto resta solo sul VPS." -ForegroundColor Yellow; exit 4 }
```

**A2. INSERIRE fra r.719 e r.721** (dopo l'ultima `W ("")` di intestazione,
prima del commento `# --- la coda`):

```
# ---------------------------------------------------------------------
#  TOPPA 1 (13/09/2026) -- IL TOKEN SI CERCA ADESSO, NON ALLA FINE.
#  Serve per poter pubblicare il MARCATORE D'AVVIO. Qui NON si esce:
#  senza token la corsa deve girare lo stesso e lasciare il referto sul
#  VPS, esattamente come prima. L'exit 4 resta dov'era, in fondo.
# ---------------------------------------------------------------------
$cand = @($TokenFile, "C:\Users\Administrator\.gh_report_token.txt", (Join-Path $env:USERPROFILE ".gh_report_token.txt"))
$tok = $null
foreach($c in $cand){ if($c -and (Test-Path -LiteralPath $c)){ $tok = (Get-Content -LiteralPath $c -Raw).Trim(); break } }
$headers = @{ Authorization = "token $tok"; "User-Agent" = "ABTG-Runner"; Accept = "application/vnd.github+json" }
$apiBase = "https://api.github.com/repos/$Owner/$Repo"

function PubblicaFile([string]$locale,[string]$repoPath){
  $b64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($locale))
  $sha = $null
  try { $sha = (Invoke-RestMethod -Method Get -Uri "$apiBase/contents/$repoPath`?ref=$Branch" -Headers $headers).sha } catch {}
  $body = @{ message = ("Runner ABTG: referto automatico (" + (Get-Date -Format 'yyyy-MM-dd HH:mm') + ")")
             content = $b64; branch = $Branch }
  if($sha){ $body.sha = $sha }
  try {
    Invoke-RestMethod -Method Put -Uri "$apiBase/contents/$repoPath" -Headers $headers -Body ($body | ConvertTo-Json) -ContentType "application/json" | Out-Null
    Write-Host ("  OK pubblicato: " + $repoPath) -ForegroundColor Green
    return $true
  } catch {
    Write-Host ("  PUBBLICAZIONE FALLITA (" + $repoPath + "): " + $_.Exception.Message) -ForegroundColor Red
    return $false
  }
}

# L'impronta della coda: il BLOB SHA-1 DI GIT, cioe' lo stesso numero che
# da' `git hash-object <file>`. Si ricalcola dal repo con un comando, a
# differenza dell'ETag di raw.githubusercontent, che e' opaco (misurato
# il 13/09: etag 84610d39... non e' ne' lo sha256 del contenuto ne' il
# blob). Si stampa ANCHE la lunghezza in byte: se il blob non torna ma la
# lunghezza si', il guasto e' la CODIFICA, non una coda diversa.
function BlobSha([string]$testo){
  $b = [Text.Encoding]::UTF8.GetBytes($testo)
  $h = [Text.Encoding]::ASCII.GetBytes("blob " + $b.Length + [char]0)
  $tot = New-Object byte[] ($h.Length + $b.Length)
  [Array]::Copy($h, 0, $tot, 0, $h.Length)
  [Array]::Copy($b, 0, $tot, $h.Length, $b.Length)
  $sha1 = [Security.Cryptography.SHA1]::Create()
  return ((($sha1.ComputeHash($tot)) | ForEach-Object { $_.ToString("x2") }) -join "")
}
```

#### B) **INSERIRE dopo r.732** (chiusura di `if($coda){...}`) e **prima di r.734** (`foreach`)

```
# ---------------------------------------------------------------------
#  TOPPA 1 -- IL MARCATORE D'AVVIO.
#  Il runner pubblicava SOLO alla fine (r.801-832 della versione vecchia):
#  dal repo, una corsa MORTA A META' e una MAI PARTITA erano
#  INDISTINGUIBILI. Costato ~25 minuti la notte del 13/09/2026, per
#  scoprire che non si poteva capire.
#  >>> LIMITE DICHIARATO: questo marcatore viaggia sullo STESSO token
#      della pubblicazione finale. Se il token manca, NON esce -- e dal
#      repo "non partito" e "senza token" restano indistinguibili. Per
#      questo si scrive SEMPRE anche il file LOCALE, che non ha bisogno
#      ne' di rete ne' di token: e' la seconda linea, e la riga di
#      diagnosi di sola lettura lo va a cercare per nome.
#  >>> E TUTTO STA DENTRO UN try/catch: $ErrorActionPreference vale
#      "Stop" (r.103), quindi un errore qui FERMEREBBE LA NOTTE INTERA.
#      Una toppa di diagnosi non puo' diventare la causa del guasto.
# ---------------------------------------------------------------------
$marcaNome = "AVVIO_RUNNER_" + $avvio.ToString("yyyyMMdd_HHmmss") + ".txt"
try {
  $M = New-Object System.Collections.ArrayList
  [void]$M.Add("MARCATORE D'AVVIO -- RUNNER ABTG")
  [void]$M.Add("marcatore  : " + $MARC)
  [void]$M.Add("avvio      : " + $avvio.ToString("yyyy-MM-dd HH:mm:ss") + "   (ora locale VPS = ora italiana; ora server BCM = questa MENO 1)")
  [void]$M.Add("branch     : " + $Branch)
  [void]$M.Add("coda       : " + $CodaPath)
  if($coda){
    [void]$M.Add("coda blob  : " + (BlobSha $coda) + "   (" + ([Text.Encoding]::UTF8.GetBytes($coda)).Length + " byte)")
    [void]$M.Add("             ricalcolabile dal repo:  git hash-object " + $CodaPath)
  } else {
    [void]$M.Add("coda blob  : -- CODA NON SCARICATA --")
  }
  [void]$M.Add("righe lette: " + $righe.Count)
  [void]$M.Add("conteggio per PERCORSO (e' un fatto; la CORSIA non lo e' ancora):")
  foreach($g in @($righe | ForEach-Object { $p = @($_ -split '\|'); if($p.Count -ge 2){ $p[1].Trim() } else { "(riga malformata)" } } | Group-Object | Sort-Object Count -Descending)){
    [void]$M.Add(("   {0,3}  " -f $g.Count) + $g.Name)
  }
  [void]$M.Add("corsie     : NON ANCORA MISURATE. La corsia LETTURA/ROUND si decide in")
  [void]$M.Add("             VagliaScript, DOPO lo scarico di ogni script. Dedurla dal nome")
  [void]$M.Add("             del file sarebbe fidarsi del nome: qui sopra c'e' il percorso.")
  [void]$M.Add("token      : " + $(if($tok){"TROVATO"}else{"ASSENTE -- la corsa gira lo stesso, il referto restera' solo sul VPS (exit 4)"}))
  [void]$M.Add("")
  [void]$M.Add("QUESTO FILE DICE SOLO: il runner e' PARTITO, ha letto la coda, e aveva il token.")
  [void]$M.Add("NON dice che i round gireranno, e NON dice niente sull'esito.")
  [void]$M.Add("L'esito sta in REFERTO_RUNNER_<stessa ora>.txt, che si scrive ALLA FINE.")

  $marcaLoc = Join-Path $Lavoro $marcaNome
  $M -join "`r`n" | Set-Content -LiteralPath $marcaLoc -Encoding UTF8
  W ("marcatore d'avvio scritto sul VPS: " + $marcaNome)
  if(-not $tok){
    $avvisoLoc = Join-Path $Lavoro ("TOKEN_ASSENTE_" + $avvio.ToString("yyyyMMdd_HHmmss") + ".txt")
    "TOKEN NON TROVATO all'avvio. La corsa gira lo stesso; niente verra' pubblicato sul repo." | Set-Content -LiteralPath $avvisoLoc -Encoding UTF8
    W ("TOKEN ASSENTE all'avvio: niente marcatore sul repo. Il file locale c'e': " + (Split-Path $avvisoLoc -Leaf))
  } elseif($NonPubblicare){
    W ("(-NonPubblicare: marcatore d'avvio solo locale)")
  } else {
    Titolo "MARCATORE D'AVVIO"
    [void](PubblicaFile $marcaLoc ("backtest_pipeline/coda/referti/" + $marcaNome))
  }
} catch {
  W ("ATTENZIONE: marcatore d'avvio NON scritto -- " + $_.Exception.Message)
  W ("   (la corsa prosegue: il marcatore e' diagnostica, non un cancello)")
}
```

🔑 **Nota sul `catch`**: se il marcatore fallisce, la corsa **continua**. E'
deliberato e va dichiarato: il marcatore serve a **raccontare** la notte, non a
**decidere** se la notte si fa.

### 2.6 🧾 COME SI LEGGE, la mattina dopo

| cosa vedo su `backtest_pipeline/coda/referti/` | conclusione |
|---|---|
| `AVVIO_RUNNER_<oggi>.txt` **c'e'**, `REFERTO_RUNNER_<oggi>.txt` **no** | 🔴 **partita e MORTA A META'** — e i log per round (toppa 2) dicono **a quale round** |
| tutti e due ci sono | 🟢 arrivata in fondo |
| **nessuno dei due** | 🟠 *non partita* **oppure** *senza token*. **Non si indovina**: si gira la riga di sola lettura e si guardano `AVVIO_RUNNER_*` / `TOKEN_ASSENTE_*` sul VPS |
| `AVVIO_RUNNER_` c'e' e l'ora d'avvio **non e' 03:30** | 🟠 l'attivita' e' partita in ritardo o a mano: il marcatore porta l'ora vera |

---

## 3. 🪵 TOPPA 2 — UN LOG PER ROUND

### 3.1 Il difetto, in tre righe di sorgente (r.767-770)

```
$nome = [IO.Path]::GetFileNameWithoutExtension($perc)      # <-- dal PERCORSO
...
$log  = Join-Path $Lavoro ($nome + "_" + $avvio.ToString("yyyyMMdd_HHmmss") + ".log")
```

`$avvio` e' **uno per corsa** e `$nome` e' **uno per percorso**: due righe con lo
stesso percorso producono **lo stesso nome di file**. Con 36 righe su
`RIGA_SOTTILE_ROUND.ps1`, **35 log su 36 vengono distrutti**. 🔴 E non e' solo il
log: le stesse 36 righe portano **quattro pin diversi** (`1445abf8` x19,
`0c38419f` x7, `ab1a206f` x5, `dbe86ac3` x3) e scrivono tutte lo **stesso**
`RIGA_SOTTILE_ROUND.ps1` su disco (r.768).

### 3.2 Il materiale disponibile a r.755-775, e perche' l'etichetta **da sola non basta**

A quel punto il runner ha: `$perc` (percorso), `$nome`, `$argomenti` (stringa
grezza, gia' passata da G4), `$v.corsia`. **L'etichetta sta negli ARGOMENTI**
(`-Etichetta r142a`), non nel nome dello script.
🔴 **Ma l'etichetta da sola non garantisce l'unicita'**: le 12 righe di sola
lettura **non hanno argomenti**, e niente vieta domani due righe con la stessa
etichetta (un round ripetuto). 👉 Quindi l'unicita' la deve dare **il progressivo
della riga di coda**, che e' unico **per costruzione**; l'etichetta si aggiunge
perche' rende il nome **leggibile** senza aprirlo.

### 3.3 🔧 IL DIFF — TOPPA 2

**C) SOSTITUIRE r.727:**

```
$eseguiti = 0; $rifiutati = 0; $falliti = 0; $nRound = 0
```
**con:**
```
$eseguiti = 0; $rifiutati = 0; $falliti = 0; $nRound = 0
$iRiga = 0   # progressivo della riga di coda: unico per corsa PER COSTRUZIONE
```

**D) INSERIRE subito dopo r.734** (`foreach($riga in $righe){`), come prima
istruzione del ciclo:

```
  $iRiga++
```

_(Si incrementa in TESTA, quindi conta anche le righe rifiutate: il numero nel
nome del log e' **la posizione nella coda**, che e' proprio quello che si vuole
sapere — "a che punto e' arrivata".)_

**E) SOSTITUIRE r.770:**

```
  $log  = Join-Path $Lavoro ($nome + "_" + $avvio.ToString("yyyyMMdd_HHmmss") + ".log")
```
**con:**
```
  # --- TOPPA 2 (13/09/2026): il nome del log DISTINGUE i round.
  #     $nome viene dal PERCORSO (r.767) e la coda del 13/09 aveva 36
  #     righe su 48 con lo STESSO percorso: i 36 log si sovrascrivevano e
  #     ne restava UNO, quello dell'ultimo. Il progressivo $iRiga rende il
  #     nome unico per costruzione; l'etichetta lo rende LEGGIBILE.
  #     L'etichetta passa da una LISTA BIANCA (non una lista nera: quella
  #     dimentica sempre qualcosa) e rifiuta '..'. Senza separatori e
  #     senza due punti, non puo' diventare un percorso.
  $et = ""
  $mEt = [regex]::Match($argomenti, '(?i)-Etichetta\s+([A-Za-z0-9_.-]{1,24})')
  if($mEt.Success -and -not $mEt.Groups[1].Value.Contains("..")){ $et = "_" + $mEt.Groups[1].Value }
  $log  = Join-Path $Lavoro ($nome + "_" + $avvio.ToString("yyyyMMdd_HHmmss") + "_" + ("{0:D3}" -f $iRiga) + $et + ".log")
```

Nomi che ne escono, per la coda di stanotte:

```
CODA_01_sedie_attaccate_20260913_033002_001.log
RIGA_SOTTILE_ROUND_20260913_033002_013_r133c.log
RIGA_SOTTILE_ROUND_20260913_033002_048_r142c.log
```

📏 **Lunghezza del percorso**: `C:\Users\Administrator\abtg_runner\` (35) +
`RIGA_SOTTILE_ROUND` (18) + `_` + 15 + `_` + 3 + `_` + max 24 + `.log` = **~102
caratteri**, e `.err` ne aggiunge 4. Ampiamente sotto il tetto dei 260 di PS 5.1.

### 3.4 ✅ E LA PUBBLICAZIONE NON SI ROMPE — verificato a r.831

```
foreach($l in @(Get-ChildItem $Lavoro -Filter "*.log" ... | Where-Object { $_.LastWriteTime -ge $avvio })){
```

Il filtro e' **`*.log` + scritto dopo `$avvio`**: nessuna delle due condizioni
guarda la **forma** del nome. I nomi nuovi finiscono in `.log` e sono scritti
durante la corsa → **vengono raccolti tutti**. E **nessun altro strumento nel
repo legge quei nomi** (verificato: `grep -rn "coda/referti"` trova **una sola**
occorrenza, r.829 del runner stesso).

🔴 **Ma cambia la QUANTITA', e questo Claudio lo deve sapere prima**: da ~13 file
pubblicati a **fino a 49**. Cioe' **fino a ~49 commit a notte** sul ramo `lavoro`
(il 12/09 ne ha fatti 12) e **~98 chiamate API** (`PubblicaFile` fa una GET + una
PUT per file). Il tetto orario di GitHub e' 5.000 chiamate autenticate: non si
sfiora. Il vero costo e' **il peso del repo**: oggi `coda/referti/` pesa **1,8
MB** con 41 log, e il singolo `CODA_07_desktop_*.log` pesa **400 KB**. Quanto
pesi un log di round **non e' misurato** — lo si legge alla prima corsa toppata.

---

## 4. 💥 CHE COSA PUO' ROMPERE — e come me ne accorgo

Il runner e' il pezzo che fa girare tutto: **una toppa che lo spacca costa piu'
del difetto che ripara.** In ordine di gravita'.

| # | cosa puo' rompere | perche' | come me ne accorgo | difesa gia' nel diff |
|---|---|---|---|---|
| 1 | 🔴 **la notte intera non parte** | `$ErrorActionPreference = "Stop"` (r.103): **qualunque** errore nel blocco nuovo — rete, disco pieno, cartella non scrivibile — diventa **terminante** e uccide la corsa **prima del primo round**. Sarebbe la beffa perfetta: la toppa della diagnosi che causa il guasto | zero round girati e **zero referto**: identico al sintomo di stanotte | ✅ **tutto il blocco B e' dentro `try/catch`**, e il `catch` scrive nel referto e **prosegue** |
| 2 | 🔴 **il token viene letto all'avvio invece che alla fine** | se il file token viene **sostituito durante** la corsa (Claudio lo rigenera alle 04:00), oggi la pubblicazione userebbe quello nuovo; con la toppa userebbe **quello vecchio** | `exit 4` o "PUBBLICAZIONE FALLITA" con referto integro sul VPS | ⚠️ **non ancora nel diff**: serve questa aggiunta a r.806, e la propongo esplicitamente → vedi §4-bis |
| 3 | 🟠 **l'`exit 4` anticipato** | se qualcuno "semplificasse" spostando anche r.806 in testa, un token mancante **cancellerebbe la notte** invece di lasciarla girare. Oggi senza token i 48 round **girano lo stesso** | il referto non esiste **e** non esiste nessun log: si distingue solo guardando il VPS | ✅ **A1 dice esplicitamente: r.806 NON si sposta** |
| 4 | 🟠 **~49 commit e ~0,2-1,8 MB a notte** sul ramo | la toppa 2 moltiplica i file pubblicati per ~4 | `git log --oneline --since=... | wc -l` e `du -sh backtest_pipeline/coda/referti/` | ⚠️ **dichiarato, non risolto**: e' una scelta di Claudio (pubblicare tutto vs potare) |
| 5 | 🟠 **un log di round oltre 1 MB** | l'API Contents e' pensata per file piccoli; il round **ristampa tutto l'output del figlio** (r.816-824 di `RIGA_SOTTILE_ROUND.ps1`) | riga rossa `PUBBLICAZIONE FALLITA` e **`exit 0` lo stesso** (difetto 4-bis/c) | ⚠️ dichiarato |
| 6 | 🟡 **il marcatore non esce e il referto si'** | rete a singhiozzo alle 03:30 | i due file non sono in coppia | 🟢 innocuo: si legge il referto |
| 7 | 🟡 **`$iRiga` fuori posto** | se l'incremento finisse **dopo** i `continue` di r.739-761, le righe rifiutate non conterebbero e il numero **non sarebbe piu' la posizione in coda** — un numero che sembra giusto e non lo e' | i numeri nei nomi **saltano** rispetto alle righe rifiutate nel referto | ✅ l'incremento e' la **prima** istruzione del ciclo |
| 8 | 🟡 **l'impronta della coda falsa** | ri-codifica UTF-8 di una stringa decodificata (§2.4b) | il blob **non** corrisponde a `git hash-object`, ma la **lunghezza** si' | ✅ si stampano **tutti e due** |
| 9 | 🟢 **caratteri non-ASCII nel .ps1** | PS 5.1 legge i `.ps1` come ANSI | `Token imprevisto` alla prima corsa | ✅ i blocchi qui sopra sono **ASCII puro** — da riverificare col cancello sul file finito |

### 4-bis. 🔧 L'aggiunta che chiude il rischio #2 (3 righe, **SOSTITUISCE r.806**)

```
if(-not $tok){
  # seconda occhiata: il token e' stato cercato all'avvio (toppa 1), e in
  # mezzo la corsa e' durata ore. Se nel frattempo e' comparso, si usa.
  foreach($c in $cand){ if($c -and (Test-Path -LiteralPath $c)){ $tok = (Get-Content -LiteralPath $c -Raw).Trim(); break } }
  if($tok){ $headers = @{ Authorization = "token $tok"; "User-Agent" = "ABTG-Runner"; Accept = "application/vnd.github+json" } }
}
if(-not $tok){ Write-Host "TOKEN NON TROVATO: il referto resta solo sul VPS." -ForegroundColor Yellow; exit 4 }
```

### 4-ter. 🧪 COME SI COLLAUDA **PRIMA** DI METTERLO IN PRODUZIONE
1. 🤖 `python3 backtest_pipeline/controlla_riga.py` sul file modificato (ASCII,
   costrutti pwsh-7, formati .NET).
2. 🧯 `runner_abtg.ps1 -CollaudoCancelli`: **nessuno dei due diff tocca G0-G4**,
   quindi la batteria dei casi finti deve dare **esattamente lo stesso esito**.
   Se cambia anche un solo caso, la toppa ha toccato un cancello → si ferma.
3. 🧪 `runner_abtg.ps1 -SoloControllo -NonPubblicare` su una **coda finta di 3
   righe con lo stesso percorso**: attesa → **tre** file `..._001/_002/_003.log`,
   e `AVVIO_RUNNER_*.txt` **locale**. ⚠️ Attenzione: con `-SoloControllo` il
   `continue` di r.764 scatta **prima** del log, quindi i log non nascono —
   la prova dei nomi va fatta **senza** `-SoloControllo`, su righe di sola
   lettura innocue.
4. 🔑 **La prova del nove sull'impronta**: la prima corsa toppata deve stampare
   `6eca3067924ee0be189c1feb882cd5db069c75f3` e `51119` se la coda e' ancora
   quella di HEAD. Se la coda cambia, si riconfronta con `git hash-object`.

---

## 5. 🐛 ALTRI DIFETTI DEL RUNNER TROVATI PER STRADA — **elencati, non riparati**

Come da mandato: qui si segnalano e basta. Nessuno di questi e' toccato dai due
diff sopra.

1. 🔴 **Lo standard error non viene MAI pubblicato.** r.775 scrive
   `$log + ".err"`, cioe' un file che finisce in **`.log.err`**; r.831 raccoglie
   `-Filter "*.log"`. Quindi **il flusso d'errore di ogni riga resta sul VPS** —
   ed e' proprio quello che serve quando una riga muore. (Per i round e' in parte
   mitigato: `RIGA_SOTTILE_ROUND.ps1` r.825-831 ristampa gli errori del figlio
   sul proprio stdout. Per le 12 righe di sola lettura, no.)
2. 🔴 **Lo script eseguito viene sovrascritto** (r.768): `$nome + ".ps1"`, stesso
   nome per righe con **pin diversi**. Stanotte erano **4 pin** sullo stesso
   percorso: a fine corsa sul disco resta **un solo file**, e non si sa piu'
   quali byte abbia eseguito il round numero 13. Il pin **non compare nemmeno nel
   nome del log** proposto nella toppa 2 (scelta deliberata: lunghezza; ma va
   detto).
3. 🔴 **`exit 0` anche se la pubblicazione fallisce tutta.** r.830-832 ignorano il
   valore di ritorno di `PubblicaFile` (`[void](...)`), e r.836 esce **0** in ogni
   caso. `ESITO: COMPLETO` puo' convivere con **zero file caricati** — e
   `LastTaskResult` dira' **0**. E' la **classe 154** al contrario: il codice
   d'uscita **mente**.
4. 🟠 **Nessun tentativo ripetuto sulla pubblicazione.** Un singolo 409/5xx
   transitorio perde quel log per sempre (resta sul VPS, dove nessuno guarda).
5. 🔴 **Nessun tetto di tempo per riga.** r.774 `Start-Process ... -Wait` senza
   limite: **un tester impiantato blocca la coda per sempre**, e non c'e' niente
   che se ne accorga. E' una delle tre ipotesi ancora aperte su stanotte.
6. 🟠 **Si pubblica solo alla fine, tutto insieme.** Se la corsa muore al round 30,
   i **29 log gia' scritti** restano sul VPS. Una pubblicazione **incrementale**
   (o almeno un referto parziale ogni N righe) trasformerebbe il marcatore
   d'avvio in un vero battito. **Fuori dal perimetro di stanotte**: cambia il
   ritmo dei commit e va deciso da Claudio.
7. 🟡 **`$argomenti -split '\s+'`** (r.772): un argomento con spazi (un nome di
   prova con spazio, un percorso) **si spezza in due**. Oggi non morde perche' la
   lista bianca di `RIGA_SOTTILE_ROUND.ps1` vieta gli spazi, ma e' una mina.
8. 🟡 **Il referto non porta il pin di ogni riga in forma leggibile** ne'
   l'impronta dello script eseguito: il `W ("--- " + $riga)` di r.738 stampa la
   riga intera, quindi il pin c'e' — ma **non c'e' la prova** che i byte scaricati
   siano quelli di quel commit (nessun checksum del testo scaricato).

---

## 6. 📋 LA CLASSE NUOVA DA AGGIUNGERE ALLA CHECKLIST

⚠️ **Non l'ho aggiunta**: stanotte la consegna e' *"committa solo il tuo
referto"*. La lascio scritta qui, pronta da incollare in fondo a
`backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md` (l'ultima numerata e' la **305**,
quindi va **306**), quando Claudio decide sulla toppa.

> ## 306. 🫀🔑 IL CANALE DI DIAGNOSI CHE PASSA DALLA **STESSA CREDENZIALE** DEL CANALE GUASTO — e il "canale gemello" che tace nel fine settimana (13/09/2026)
> **Il difetto.** Per distinguere *"non e' partito"* da *"e' morto a meta'"* si
> aggiunge un **marcatore d'avvio** pubblicato sul repo. Ma il marcatore usa **lo
> stesso token** della pubblicazione finale: quando il token manca, **non esce**,
> e i due casi restano indistinguibili **esattamente quando serve distinguerli**.
> Un canale di diagnosi non e' indipendente se condivide la credenziale, la
> macchina o la rete con il canale che deve diagnosticare.
> **Il contro-esempio (classe 178), e in questo caso ha ucciso l'idea.** La
> seconda idea era leggere un **canale gemello** gia' esistente
> (`pubblica_trades.ps1`, 22:45, stesso file token): *"se i trades sono usciti
> ieri sera, il token era vivo"*. Misurato sul `git log`: quel canale **non
> pubblica nei fine settimana** (29-30/08, 05-06/09, 12/09) — e il guasto e'
> capitato **di sabato**, cioe' nell'unica finestra in cui il discriminante e'
> cieco.
> **Che cosa si fa.** (a) Il marcatore si scrive **SEMPRE in locale prima** di
> toccare la rete, con un nome che la riga di diagnosi **cerca per nome**.
> (b) Il limite si **dichiara nel marcatore stesso**. (c) Un "canale gemello" si
> usa solo dopo aver misurato **quando tace per conto suo**. (d) Il blocco di
> diagnosi sta dentro `try/catch`: con `$ErrorActionPreference = "Stop"` una
> toppa di diagnostica puo' **diventare** il guasto.
> **La regola in una riga.** 🔑 *Un battito cardiaco che passa dalla stessa vena
> del malato non e' un monitor: e' un'altra vena.*

---

## 7. 🚦 CHE COSA SERVE DA CLAUDIO — e cosa NON ho fatto

**Tre decisioni, tutte sue:**
1. ✅/❌ **Applico le toppe 1 e 2 a `runner_abtg.ps1`?** (sono ~70 righe nuove,
   zero righe dei cancelli G0-G4 toccate).
2. ✅/❌ **Va bene passare da ~13 a ~49 file pubblicati a notte** (§3.4)?
3. ✅/❌ **Il tetto di tempo per riga** (difetto 5) lo mettiamo? E' la cosa che
   piu' probabilmente spiega stanotte, e **non e' in questa toppa**.

**E quello che NON ho fatto, dichiarato:**
- ❌ **`runner_abtg.ps1` non e' stato toccato.** Il diff sta **solo** qui dentro.
- ❌ **Non ho eseguito niente sul VPS** e non ho mandato nessuna riga a Claudio.
- ❌ **Non ho detto perche' la coda si e' fermata**: le tre ipotesi di
  `report/LA_CODA_NON_HA_PUBBLICATO_2026-09-13.md` restano tutte aperte. Questa
  toppa non risponde alla domanda di stanotte: **fa in modo che la prossima volta
  la risposta ci sia gia'.**
- ❌ **Non ho misurato il peso di un log di round**: sul repo non ce n'e'
  nemmeno uno (per il difetto stesso che si ripara). Numero **non misurato**,
  e si legge alla prima corsa.
- ❌ **La classe 306 non e' in checklist**, per la consegna di stanotte (§6).

---

## 8. 🟢 E LA META' BUONA, che va detta lo stesso
Il runner ha **portato a casa sei notti di seguito** (07→12/09) e i suoi cancelli
G0-G4 non hanno mai fatto passare niente di sbagliato: stanotte il problema e'
che **non sa raccontare**, non che sbaglia. E la coda di 48 righe che aspetta e'
la piu' carica mai armata — **36 round** su EMA200, SuperWave, MaxMinNotte,
CostToCost e i tre preopen R142. Appena il battito c'e', si vede anche **dove**
si ferma. 💪 **Non si molla nulla: si misura.**
