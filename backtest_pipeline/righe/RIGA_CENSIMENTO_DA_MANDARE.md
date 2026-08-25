# 📏 RIGA DI LANCIO — censimento_rischio **v2** (il VIVO separato dal RESIDUO)

**Pin: `94946f46dcb99d185a98f7f780a4a2537e810796`** (branch `lavoro`).
Script: `backtest_pipeline/censimento_rischio.ps1` — marcatore `MARCATORE_CENSIMENTO_V2`.

> 🔒 **IL PIN E' SCRITTO** nelle **tre** occorrenze (l'intestazione qui sopra,
> il PASSO 1, il PASSO 2). Tutti e due i blocchi si rifiutano di partire se
> `$h` non e' un SHA da 40 caratteri esadecimali, cosi' un segnaposto non puo'
> finire in console per distrazione (checklist punto 4 + punto 63).
> **Se lo script viene ritoccato, il pin va rifatto in tutte e tre.**

---

## Perche' esiste la v2 (e cosa cambia nel numero)

La v1 contava **i `.chr` su disco**, e un `.chr` resta li' anche quando il
grafico non c'e' piu'. Due incidenti veri, a 24 ore di distanza:

- **23/08** — `ORB_Ottimizzato U30USD 770611` compare **due volte a 1.0**.
  Verifica a vista di Claudio sui due terminali: **un solo grafico ORB**.
- **24/08** — `Gold_Ichimoku_TK_ATR_EA` (XAUUSD, magic 250604) entra in
  classifica R103 come sedia viva. **Non gira da giugno.** Ha spostato la
  somma della flotta, la classifica e la stima al 31/12, corretta poi a mano.

**La v2 separa:** tabella principale e **somma** = solo il **profilo attivo**;
tutto il resto va in una sezione **`RESIDUI SU DISCO`** che **non entra mai nel
totale**. E stampa **l'aritmetica per esteso**, cosi' il numero vecchio e quello
nuovo si vedono affiancati.

> ✋ **PRIMA DI LANCIARE: in MT5 fai `File → Profili → Salva`.**
> I `.chr` si aggiornano solo al salvataggio: senza, stai fotografando lo stato
> di ieri e la v2 marchera' come `[FUORI SALVATAGGIO]` righe che sono vive.
>
> ⚠️ **NIENTE guardia MT5-chiuso, ed e' voluto.** Sul VPS il terminale **e' il
> forward**: non si chiude. Questo script **legge e basta** — non scrive un solo
> byte dentro `MetaQuotes\Terminal`, quindi il divieto del punto 7 della
> checklist (gli script che SCRIVONO nei file di MT5) qui non si applica.
> La v2 legge anche i `.chr` in modalita' **condivisa**: con la v1, un file
> tenuto aperto da MT5 faceva morire tutto il censimento (nota del verificatore
> del 19/08, in coda da allora — chiusa qui).

---

## PASSO 1 — LA CORSA (MT5 resta APERTO)

**Incolla il blocco INTERO, graffe comprese** (punto 21).

```powershell
& {
  [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
  $h="94946f46dcb99d185a98f7f780a4a2537e810796"
  if($h -notmatch '^[0-9a-f]{40}$'){ throw "PIN NON SCRITTO: sostituisci il segnaposto con lo SHA del commit" }
  $p="$env:USERPROFILE\censimento_rischio.ps1"
  Remove-Item $p -Force -ErrorAction SilentlyContinue
  irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$h/backtest_pipeline/censimento_rischio.ps1" -OutFile $p -ErrorAction Stop
  if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_CENSIMENTO_V2' -Quiet)){ throw "SCRIPT VECCHIO (cache di raw, ~5 minuti): riprova fra poco" }
  $ref=Join-Path ([Environment]::GetFolderPath("Desktop")) "censimento_rischio.txt"
  Remove-Item $ref -Force -ErrorAction SilentlyContinue
  $global:LASTEXITCODE=0
  & powershell -ExecutionPolicy Bypass -File $p
  if($LASTEXITCODE -ne 0){ throw ("censimento_rischio uscito con codice " + $LASTEXITCODE + " -- leggi il motivo qui sopra") }
  if(-not (Test-Path -LiteralPath $ref)){ throw "REFERTO NON SCRITTO: non c'e' niente da mandare" }
  Write-Host ("referto: " + $ref + "   scritto alle " + (Get-Item -LiteralPath $ref).LastWriteTime)
}
```

Il referto vecchio viene **cancellato prima** (punto 23: un artefatto di ieri
rimasto sul Desktop verrebbe raccolto come se fosse di adesso).

### Cosa si legge, in quest'ordine

| # | riga attesa | come si giudica |
|---|---|---|
| 1 | `versione: MARCATORE_CENSIMENTO_V2` | se manca, sta girando la v1: **fermati** |
| 2 | `--- PROFILO ATTIVO, terminale per terminale ---` con `[OK]` o `[DA VERIFICARE]` | vedi il riquadro qui sotto |
| 3 | `fonte: [CONFIG] ...` / `[UNICO] ...` / `[ASSUNTO] ...` | **e' la provenienza del numero**: va citata nel verbale |
| 4 | la tabella `EA / simbolo / magic / rischio / commento` | **stesse colonne della v1**, cambia solo *chi* ci sta dentro |
| 5 | `somma dei rischi delle sedie del PROFILO ATTIVO: N,NN%` | **e' IL numero** |
| 6 | `l'aritmetica, per esteso:` (3 righe) | la terza (`somma se si sommasse tutto`) e' **il numero che stampava la v1**: lo scarto fra le due e' la spazzatura |
| 7 | `=== RESIDUI SU DISCO ===` | **non si sommano**: si guardano e, se confermati morti, si puliscono |
| 8 | eventuale `!! N righe ... FUORI dall'ultimo salvataggio` | sono nel totale (un rischio vivo non si nasconde), ma vanno verificate a vista |

> 🧭 **Se il profilo attivo esce `[ASSUNTO]`**, vuol dire che nei file di
> `config\` non c'e' (o non e' valida) una chiave che nomina il profilo, e lo
> script ha **ripiegato** sul profilo col `.chr` piu' recente — **dichiarandolo**.
> Controllo che costa 5 secondi: in MT5, **File → Profili**, il profilo con la
> spunta e' quello attivo. Se non e' quello scritto nel referto, **il referto
> ha le righe nella sezione sbagliata** e il numero non si usa.
>
> 🔎 **`[FUORI SALVATAGGIO]` non e' una condanna.** Vuol dire: dentro il profilo
> attivo, quel `.chr` non e' stato riscritto insieme agli altri all'ultimo
> salvataggio. E' il meccanismo che ha prodotto la doppia riga ORB. La prova
> che chiude la domanda resta quella del 23/08: **in MT5, menu Finestra —
> quel grafico c'e' o no?** Tolleranza regolabile: `-ToleranzaMin 30`.

---

## PASSO 2 — RACCOLTA (subito dopo)

```powershell
& {
  $h="94946f46dcb99d185a98f7f780a4a2537e810796"
  if($h -notmatch '^[0-9a-f]{40}$'){ throw "PIN NON SCRITTO" }
  $ref=Join-Path ([Environment]::GetFolderPath("Desktop")) "censimento_rischio.txt"
  if(-not (Test-Path -LiteralPath $ref)){ throw "NESSUN REFERTO: il PASSO 1 non e' andato" }
  $eta=((Get-Date)-(Get-Item -LiteralPath $ref).LastWriteTime).TotalMinutes
  if($eta -gt 30){ throw ("REFERTO STANTIO (" + [int]$eta + " min): e' di un'altra corsa, rifai il PASSO 1") }
  if(-not (Select-String -Path $ref -SimpleMatch -Pattern 'MARCATORE_CENSIMENTO_V2' -Quiet)){ throw "il referto NON viene dalla v2" }
  $stamp=Get-Date -Format "yyyy-MM-dd_HHmm"
  $dest=Join-Path ([Environment]::GetFolderPath("Desktop")) ("censimento_rischio_" + $stamp)
  Remove-Item $dest -Recurse -Force -ErrorAction SilentlyContinue
  New-Item -ItemType Directory -Force -Path $dest | Out-Null
  Copy-Item -LiteralPath $ref -Destination (Join-Path $dest ("censimento_rischio_" + $stamp + ".txt")) -Force
  $zip=$dest + ".zip"
  Remove-Item $zip -Force -ErrorAction SilentlyContinue
  Compress-Archive -Path (Join-Path $dest "*") -DestinationPath $zip -Force
  Get-ChildItem $dest | Select-Object Name,Length,LastWriteTime | Format-Table -AutoSize
  Write-Host "--- le righe che contano, gia' estratte ---"
  Select-String -Path $ref -SimpleMatch -Pattern @("profilo attivo:","fonte:","somma dei rischi","righe del PROFILO ATTIVO","righe RESIDUE su disco","somma se si sommasse tutto","FUORI dall'ultimo salvataggio") | ForEach-Object { Write-Host ("   " + $_.Line.Trim()) }
  Write-Host ("ZIP PRONTO DA MANDARE -> " + $zip)
}
```

**File attesi nella cartella (1):**
`censimento_rischio_AAAA-MM-GG_hhmm.txt`.

> 🕰️ **La riga `data:` dentro il referto e' in ora della MACCHINA** (sul VPS =
> ora italiana), **non in ora server**. Deve essere di **adesso**.
> 🗄️ **Archiviazione**, come le volte precedenti: il file va in
> `backtest_pipeline/risultati_archivio/censimento_rischio_AAAA-MM-GG_hhmm.txt`
> — e' li' che lo cercano `CONTRATTI_SEDIE.md`, `PIANO_PROP.md` e i criteri dei
> round.

---

## ✅ Cosa e' stato verificato prima di scrivere questa riga

- **Parse pulito** dello script con un interprete vero
  (`Parser::ParseFile`, **0 errori**) — checklist punto 63.
- **Eseguite** le funzioni vere estratte dal file (via AST, non copiate a mano):
  `ParseNumInv` (8 casi, **sotto cultura it-IT**), `SommaRischi`,
  `Trova-ProfiloAttivo` (6 casi: `[CONFIG]` UTF-16, `[CONFIG]` ANSI, chiave che
  nomina un profilo inesistente, `[ASSUNTO]`, `[UNICO]`, nessun profilo),
  `Leggi-TestoCondiviso` su un config UTF-16.
- **La trappola della cultura riprodotta**: sotto `it-IT`,
  `[double]::TryParse("2.0")` **senza** cultura restituisce **20**; con
  `InvariantCulture` restituisce **2**. Il rischio dell'1% diventava il 10%.
- **Classificazione dei percorsi** provata con stringhe **Windows**
  (profilo attivo / altro profilo / annidato / `_STACCATI_`).
- **ASCII puro**, nessuna emoji nel `.ps1`, nessun costrutto PS7
  (niente ternari, niente `&&`), fine riga LF come prima.
- **Blocchi PowerShell di questo documento**: parse pulito tutti e due.
