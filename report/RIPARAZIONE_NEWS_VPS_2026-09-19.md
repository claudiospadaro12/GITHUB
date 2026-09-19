# 🗓️🔧 IL CANALE NEWS DEL VPS — diagnosi, riparazione, e la cosa che non ci aspettavamo

**19/09/2026** · verificatore delle stringhe · pin **`70c240ad`** · cancello **PASS** su tutto

---

## 🖥️ IL BERSAGLIO — da dire a Claudio PRIMA del blocco di codice

> 🖥️ **Finestra PowerShell sul VPS, aperta come AMMINISTRATORE** (serve per toccare
> un'attività pianificata). **Nessun MT5 va aperto, chiuso o toccato**: né il piccolo
> **50503392** (`BCM Markets MT5 Terminal`), né il 100k **50504263** (`...-V3`), né il
> **REALE 10105439** (`C:\BCM_Reale`), né il banco **50504400** (`C:\MT5_Backtest`), né
> Pepperstone, né Tickmill. Le righe lavorano su **due sole cose**: l'attività pianificata
> `ABTG_AggiornaNews` e la cartella `C:\ABTG`.

---

## ① 📉 IL FATTO, ricontrollato

| corsa delle 07:20 | esito | |
|---|---:|---|
| 15/09 · 16/09 | **0** | prima del riordino |
| **17/09** | **4294770688** | 🔴 la prima dopo |
| 18/09 | **4294770688** | 🔴 e da lì mai più |

`4294770688` non è un numero misterioso: è **`0xFFFD0000` = −196608**, il codice che
`powershell.exe` restituisce quando **il file passato a `-File` non esiste**. Combacia al
minuto col riordino del **16/09 alle 19:42**, che ha portato
`Desktop\GITHUB-claude-creating-agents-SgGpD (1)\` dentro `Archivio_2026-09-16_1942`.
**La diagnosi della sessione principale è confermata.**

---

## ② 🔴 LA SCOPERTA CHE CAMBIA IL PIANO — «esito 0» non voleva dire «news aggiornate»

Ho provato a **rompere** la premessa invece di confermarla (regola del 10/09), e si è rotta.
Tre misure, tutte fatte adesso:

**(a) La sorgente è VUOTA, e non da ieri.**
```
git cat-file -s HEAD:data/abtg_news.csv            -> 0
git log --oneline -- data/abtg_news.csv            -> a86089c8 (26/07/2026), e basta
curl https://raw.githubusercontent.com/.../lavoro/data/abtg_news.csv   -> HTTP 200, CORPO VUOTO
curl  ...  /claude/creating-agents-SgGpD/data/...  -> HTTP 200, CORPO VUOTO
```
👉 L'URL **esatto** che lo script scarica risponde **200 con zero byte**. Su tutti e due i rami.

**(b) La copia che girava sul Desktop scriveva quei zero byte DIRITTO sul bersaglio.**
La versione del vecchio ramo (`git show claude/creating-agents-SgGpD:backtest_pipeline/aggiorna_news.ps1`) fa
`Invoke-WebRequest -Uri $RawUrl -OutFile $Dest` — **download scritto sul file in campo, nessuna
verifica** — e poi esce **0**. 🔴 Quindi gli `0` del 15 e 16/09 **non sono la prova che il
canale funzionasse**: sono la prova che nessuno stava controllando. La versione riparata il
12/09 (quella su `lavoro`) allo stesso file risponde **`file VUOTO (0 byte)` + exit 1**.

**(c) E un file vuoto, per l'EA, è un filtro SPENTO.**
`mql5/Experts/ABTG_PTE.mq5` r.637-638:
```
int h=FileOpen(InpNewsFile,FILE_READ|FILE_CSV|FILE_ANSI,';');
if(h==INVALID_HANDLE){ Log("file news non trovato: filtro di fatto spento."); return; }
```
Due cose in una riga: **niente `FILE_COMMON`** (risposta al punto (e): si legge da
`<cartella dati del PROPRIO terminale>\MQL5\Files`, **non** da `Common\Files`) e **fail-OPEN**
(nessuna notizia letta = nessun blocco = si opera anche sopra la notizia).

### 👉 Conseguenza sull'ordine dei lavori
Ripuntare il percorso **è giusto e va fatto** — ma **da solo non riaccende il canale**: la
riga riparata, oggi, finirà **onestamente** con `exit 1 / file VUOTO`, lasciando in pace il
file in campo. Per questo la riga di riparazione **classifica l'esito in A/B/C** invece di
promettere uno `0` che oggi non può arrivare. Vedi ⑥.

---

## ③ 🔎 LA RIGA DI **DIAGNOSI** (sola lettura) — incolla il blocco intero

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $pin='70c240ad8b90a4e2e423c4d7047eab0ddac73268'; $w="$env:USERPROFILE\abtg_news_riga"; $p="$w\RIGA_DIAGNOSI_NEWS.ps1"; New-Item -ItemType Directory -Force -Path $w | Out-Null; Remove-Item $p -Force -ErrorAction SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_DIAGNOSI_NEWS.ps1?cb=$([guid]::NewGuid().ToString('N'))" -OutFile $p -ErrorAction Stop; if(-not (Test-Path $p)){ throw 'DOWNLOAD FALLITO' }; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_DIAGNOSI_NEWS_v1' -Quiet)){ throw 'SCRIPT VECCHIO: manca MARCATORE_RIGA_DIAGNOSI_NEWS_v1' }; Write-Host 'SOLA LETTURA: guardo e basta. Non riparo niente, non sposto niente, e nessuna finestra MT5 viene aperta, chiusa o toccata.' -ForegroundColor Cyan; $ErrorActionPreference='Continue'; $global:LASTEXITCODE=0; & powershell -NoProfile -ExecutionPolicy Bypass -File $p; Write-Host ('CODICE DI USCITA: ' + $LASTEXITCODE) -ForegroundColor Cyan }
```

Stampa, nell'ordine chiesto: **(a)** il percorso pieno che l'attività esegue oggi · **(b)** se
esiste (e, se no, il pezzo di percorso più lungo che è sopravvissuto) · **(c)** ogni copia di
`aggiorna_news.ps1` in `C:\ABTG` e sul Desktop **fino a 6 livelli** (quindi anche dentro
`Archivio_2026-09-16_1942`, e anche se nel frattempo è finita un livello più sotto), con
**data, impronta, il BRANCH scritto dentro** e se ha i controlli del 12/09 · **(d)** il
calendario in campo **per ogni cartella dati** (con `origin.txt` a dire di chi è) più
`Common\Files`, con byte, righe e data · **(e)** la `FileOpen` vera trovata sui sorgenti della
macchina, che dice se si legge da `Common\Files` o no.
Raccolta: `Desktop\DIAGNOSI_NEWS_<data>\diagnosi_news.txt` + zip.
📌 **Da dire a Claudio**: la **seconda riga del referto è `data:` e dev'essere di ADESSO**.

---

## ④ 🔧 LA RIGA DI **RIPARAZIONE** — incolla il blocco intero

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $pin='70c240ad8b90a4e2e423c4d7047eab0ddac73268'; $imp='3349FAB7B7904E0667CD7F9BA30180656526E7EECCF2D1081525915A8764769D'; $w="$env:USERPROFILE\abtg_news_riga"; $p="$w\RIGA_RIPARA_NEWS.ps1"; New-Item -ItemType Directory -Force -Path $w | Out-Null; Remove-Item $p -Force -ErrorAction SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_RIPARA_NEWS.ps1?cb=$([guid]::NewGuid().ToString('N'))" -OutFile $p -ErrorAction Stop; if(-not (Test-Path $p)){ throw 'DOWNLOAD FALLITO' }; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_RIPARA_NEWS_v1' -Quiet)){ throw 'SCRIPT VECCHIO: manca MARCATORE_RIGA_RIPARA_NEWS_v1' }; Write-Host 'BERSAGLIO: l attivita pianificata ABTG_AggiornaNews e la cartella C:\ABTG. Nessuna finestra MT5 viene aperta, chiusa o toccata, e non viene cancellato niente.' -ForegroundColor Cyan; $ErrorActionPreference='Continue'; $global:LASTEXITCODE=0; & powershell -NoProfile -ExecutionPolicy Bypass -File $p -Pin $pin -Impronta $imp; $rc=$LASTEXITCODE; Write-Host ('CODICE DI USCITA: ' + $rc) -ForegroundColor Cyan; if($rc -eq 0){ Write-Host 'A = canale news VIVO: esito 0 e calendario di OGGI.' -ForegroundColor Green } elseif($rc -eq 2){ Write-Host 'B = percorso RIPARATO ma SORGENTE VUOTA: data/abtg_news.csv su lavoro non ha eventi. Il file in campo non e stato toccato. Va rigenerata la sorgente, poi si rilancia questa stessa riga.' -ForegroundColor Yellow } else { Write-Host 'C = NON DIMOSTRATO: mandami lo zip sul Desktop.' -ForegroundColor Red } }
```

**Cosa fa, in ordine:** foto del PRIMA (azione dell'attività, se il file esiste, stato e ultimo
esito) → **salva l'XML dell'attività sul Desktop e stampa la riga per tornare indietro** →
scarica `aggiorna_news.ps1` **dal pin** e lo passa a **cinque controlli** (impronta SHA256,
marcatore, ASCII puro, **parser di PowerShell**, e il **branch scritto dentro**: deve essere
`/lavoro/`) → installa in `C:\ABTG` tenendo da parte la copia di prima → **ripunta** l'attività
(prima `Set-ScheduledTask`, che conserva trigger e utente; poi `schtasks /Change`) e **rilegge
l'attività per verificare**, perché la prova è l'artefatto, non il codice di ritorno →
**lancia l'ATTIVITÀ** (non lo script: così si prova la catena intera, utente e privilegi
compresi) aspettando che lo **stato** torni diverso da `Running`, con tetto dichiarato di 180 s
→ legge il **log della corsa** → misura il calendario in campo → **verdetto A/B/C** → referto +
zip sul Desktop.

**È ri-eseguibile**: alla seconda corsa dice *"era già identico"* e *"già a posto"* e non
tocca niente. 🔴 **Non crea l'attività se non esiste**: stampa la riga `schtasks /Create` e si
ferma, perché utente, privilegi e orario sono una decisione, non un dettaglio.

---

## ⑤ ✅ IL CANCELLO — output vero

`python3 backtest_pipeline/controlla_riga.py` su **cinque oggetti**:

| oggetto | esito |
|---|---|
| `--riga` diagnosi | **6 PASSATI, 0 rilievi, 0 bloccanti** |
| `--riga` riparazione | **6 PASSATI, 0 rilievi, 0 bloccanti** |
| `--ps1 RIGA_DIAGNOSI_NEWS.ps1` | 6 PASSATI (ASCII, **parser vero**, param block, pwsh-7, formati, cultura) |
| `--ps1 RIGA_RIPARA_NEWS.ps1` | 6 PASSATI |
| `--ps1 aggiorna_news.ps1` | 6 PASSATI + **1 rilievo `[457]`** |

```text
OK   pin 70c240ad e' un commit vero (git cat-file)
OK   il marcatore MARCATORE_RIGA_RIPARA_NEWS_v1 c'e' davvero in
     backtest_pipeline/righe/RIGA_RIPARA_NEWS.ps1 al pin 70c240ad
OK   classe 165 disinnescata (Continue prima delle chiamate native)
```

🟠 **Il rilievo `[457]` e perché è innocuo**: `aggiorna_news.ps1` r.88 nomina `BCM_Reale`
dentro una stringa. È la riga
`if($instDir -like "*BCM_Reale*" -or $instDir -like "*-V3*"){ ... exit 1 }`, cioè **la guardia
che RIFIUTA il reale e il 100k**: il percorso lì è un'**etichetta di rifiuto**, non un
bersaglio. È esattamente il caso che la classe 457 descrive («un cancello testuale non sa
distinguere un bersaglio da un'etichetta») e per cui il controllo è un **rilievo**. Audit
manuale fatto: l'unica scrittura dentro `MetaQuotes\Terminal` è `Move-Item $Tmp -> $Dest`, e
`$Dest` nasce da `origin.txt` del terminale scelto dal **selettore stretto** (r.55), che
esclude il 100k. E **nessuno dei tre `.ps1` spegne, chiude o avvia un processo**: grep
esplicito sui nomi dello spegnimento (processi, finestre, eseguibili avviati) = **zero
occorrenze** in tutti e tre.

---

## ⑥ 🧪 I CONTRO-ESEMPI — **51, ESEGUITI**, non raccontati

`pwsh -NoProfile -File backtest_pipeline/controlli/controesempi_news_vps.ps1` →
**`CONTRO-ESEMPI PROVATI: 51   FALLITI: 0`**. Le funzioni provate sono **estratte dal file
vero** (se il codice cambia, cambia il test: il file si rifiuta di girare se non ne trova 7).

| contro-esempio | cosa deve succedere | esito |
|---|---|---|
| **`C:\ABTG` non esiste** | viene creata, file installato, impronta verificata, nessun backup inutile | ✅ |
| **la cartella vecchia esiste ancora** | il percorso con spazi e parentesi viene estratto **intero** e riconosciuto come «da ripuntare». La cartella non viene letta, spostata né cancellata | ✅ |
| **l'attività non c'è** | `CREA_A_MANO`: non se la inventa, stampa la riga e si ferma | ✅ |
| **lanciata due volte di fila** | `GIA_A_POSTO` + «era già identico»: nessun backup sparso, nessun ripuntamento | ✅ |
| **il clone fallisce a metà** | impronta diversa → **rifiuto**, e il file in campo **non viene toccato** (verificato confrontando l'impronta prima/dopo) | ✅ |
| versione **vecchia** con impronta giusta | manca il marcatore → rifiuto | ✅ |
| script del **branch sbagliato** | «sta puntando a un altro branch» → rifiuto | ✅ |
| **emoji** iniettata nel file | 4 byte non-ASCII → rifiuto (PS 5.1 legge ANSI) | ✅ |
| file che **non compila** | il parser trova 2 errori → rifiuto | ✅ |
| esito `4294770688` | classificato **C**, non «va bene» | ✅ |
| esito `0` ma calendario **di ieri** | classificato **C** — non ci si accontenta | ✅ |

🐛 **E un difetto vero trovato dai contro-esempi, corretto prima della consegna**: l'esito
`4294770688` **non ci sta in un `Int32`** — `[int]4294770688` non dà un numero sbagliato, dà
*«Value was either too large or too small for an Int32»*, cioè un'eccezione **proprio sul
numero che stiamo andando a leggere**. Tre `[int]` e un `[int]::Parse` sono diventati `[long]`.

🌐 **Contro-esempio sulla rete, fatto davvero**: i tre URL al pin sono stati scaricati e
l'impronta di `aggiorna_news.ps1` **coincide** con quella che la riga pretende
(`3349FAB7…4769D`, HTTP 200, 10 635 byte). Il pin non è una promessa: è stato tirato giù.

---

## ⑦ 🚧 COSA **NON** È COPERTO, dichiarato

1. **Lo strato che parla con Task Scheduler non è stato eseguito** (qui non esiste): i
   contro-esempi coprono le **decisioni**, non `Set-ScheduledTask`/`schtasks`. Per questo la
   riga **rilegge sempre l'attività** dopo averla toccata e salva l'XML prima.
2. **Perché la sorgente sia vuota non lo so.** `agent/news_export.py` qui produce 0 righe, **ma
   il feed è bloccato dal proxy di questo ambiente** (`CONNECT tunnel failed, 403`): non posso
   concludere che Forex Factory sia morto. Il fatto certo è l'altro: **l'URL che il VPS scarica
   oggi risponde 200 con zero byte**.
3. `news-export.yml` è **solo `workflow_dispatch`** (nessuno `schedule`): non si rigenera da
   sola. `daily-report.yml` committa `data/abtg_news.csv` **solo se cambia** — e un file vuoto
   rigenerato vuoto non cambia mai. 👉 **Prossimo passo suggerito alla sessione principale**:
   lanciare `news-export.yml` su `lavoro` (gira sulla rete di GitHub, non sulla mia), guardare
   se il file diventa non vuoto, **e poi rilanciare la riga ④**, che a quel punto può uscire **A**.
4. **Quali sedie vive hanno davvero `InpUseNewsFilter=true`** non è stato misurato (in `PTE` il
   default è `false`): finché non si sa, l'impatto del filtro spento è **non quantificato**.

---

## ⑧ 📦 I FILE

| file | cosa |
|---|---|
| `backtest_pipeline/righe/RIGA_DIAGNOSI_NEWS.ps1` | la diagnosi (sola lettura) |
| `backtest_pipeline/righe/RIGA_RIPARA_NEWS.ps1` | la riparazione |
| `backtest_pipeline/aggiorna_news.ps1` | + `MARCATORE_AGGIORNA_NEWS_v2` e la riga di versione nel log |
| `backtest_pipeline/controlli/controesempi_news_vps.ps1` | i 51 contro-esempi, ri-eseguibili |
