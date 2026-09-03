# 💸 SPREAD ORARIO FLOTTA — NASUSD · U30USD · D30EUR — DA MANDARE

**Che cos'è.** Una **MISURA**, non un test. Mette finalmente in campo il logger
dello spread di casa (promosso il **23/08, mai lanciato**) col motore **v2**:
legge i **tick reali già sul disco** dei **tre indici della flotta** e produce,
per ognuno, la **tabella dello spread ORA PER ORA** (ora SERVER BCM):

1. 🚦 **LA RIGA CHE DECIDE — BID/ASK** (per simbolo). Se ci sono **molti tick
   solo-bid** (soglia ≥5%), ogni corsa a `Spread=0` su quel simbolo è
   **OTTIMISTA** e va rifatta imponendo `Spread = P95` misurato.
2. 📊 **SPREAD PER FASCIA ORARIA**: per ogni ora 0–23 (ora SERVER) →
   **media, MEDIANA, P95, max** in **PUNTI INDICE** (1 pto indice = 100 pti
   MT5, conversione **misurata su tutti e tre** i simboli).

**Perché adesso.** Direzione di Claudio (31/08 sera): _"dobbiamo usare simboli
col minimo attrito"_. Oggi **tutti** i prova usano `spread 2.0 [NON MISURATO]`.
Dopo questa corsa il 2.0 diventa un numero vero, per simbolo e per ora.

**Periodo di raccolta (dichiarato):** la finestra dei tick storici
`2024.09.26 → 2026.06.30` (~21 mesi, centinaia di giorni di mercato). **NON è**
una raccolta live di 3–5 giorni: è più larga, e **non tocca né VPS né mercato
aperto** — per questo la misura finisce in una corsa sola invece di durare
giorni.

**Non tocca il forward. Non promuove niente. Non ottimizza niente. Non committa.**

---

## 🛑🛑🛑 SI LANCIA **SOLO SUL PC DI BACKTEST — MAI SUL VPS** 🛑🛑🛑

> Questa riga **APRE e CHIUDE MT5 da sola** (StartUp Script via `.ini`,
> `AllowLiveTrading=false`). Sul **VPS** chiuderebbe il terminale che tiene su
> la **FLOTTA IN FORWARD**: **spegneresti gli EA veri.** Se trova MT5 **già
> APERTO**, **ESCE 1 e lo dice** (non lo ammazza) — a meno di `-ChiudiMT5`
> esplicito. **Sul PC di backtest, con MT5 e MetaEditor CHIUSI** (il blocco lo
> controlla da solo prima di scaricare qualsiasi cosa).

---

## ⚠️ AVVERTENZA OPERATIVA DI OGGI (03/09, ~09:50) — LA DUKA VIENE PRIMA

> 🥇 **Sullo stesso PC sta girando la MISSIONE DUKASCOPY.** È **puro HTTP**
> (scarica e scrive file): **non tocca MT5, non tocca il tester, e questa riga
> non tocca lei.** Le due cose possono convivere — la corsa SPREAD usa la rete
> solo per **due file piccoli** presi dal pin, all'inizio.
>
> 🧠 **Dove si toccano davvero: la RAM.** Questa riga legge **21 mesi di tick**
> a blocchi di **7 giorni** per simbolo: MT5 tiene in memoria la base tick e il
> blocco appena letto, e su tre indici il picco può farsi sentire. **Se il
> commit di memoria va al limite e la DUKA rallenta o va in errore, si ferma la
> corsa SPREAD, MAI la DUKA.**
>
> 🛑 **Come si ferma (e non si perde niente):** **CHIUDI MT5** — basta quello.
> La riga se ne accorge **entro 20 secondi**, raccoglie il parziale, fa lo zip e
> stampa i simboli da riprendere. **NON serve Ctrl+C** sulla finestra di
> PowerShell (anzi: Ctrl+C lascerebbe MT5 acceso a mangiare RAM). In caso
> estremo, la riga di emergenza è una sola:
>
> ```powershell
> Get-Process terminal64 -EA SilentlyContinue | Stop-Process -Force
> ```
>
> 🔁 **Poi si riprende** col **BLOCCO 2️⃣** e i soli simboli mancanti: la corsa
> è **self-contained** e il lavoro già fatto resta sul Desktop.
> 🪶 **Se si vuole partire leggeri fin da subito:** un simbolo alla volta
> (`-Simboli NASUSD`) oppure blocchi più corti (`-GiorniBlocco 3`) — sono
> parametri che il driver ha davvero, e abbassano il picco di RAM. **La misura
> non cambia**, cambia solo quanta memoria serve in un istante.

---

## 📌 IL PIN — **`<PIN>`**  ✅ INSERITO (verificato con `git rev-parse`: contiene il driver **v3** + il motore `ABTG_SpreadOrario.mq5` v2). _Il pin `c5dbd68` del 31/08 e il marcatore `MARCATORE_RIGA_SPREAD_FLOTTA_v2` sono **BRUCIATI**: non incollarli più. Lancia SOLO i blocchi di questa pagina._

## ▶️ 1️⃣ LA CORSA (blocco intero, un comando solo)

Il blocco: controlla che **MT5 e MetaEditor siano chiusi**, cancella ogni copia
vecchia, riscarica la riga **dal pin**, verifica il **marcatore**
`MARCATORE_RIGA_SPREAD_FLOTTA_v3`; poi la riga scarica **anche il motore**
`ABTG_SpreadOrario.mq5` dal pin (marcatore `SPREAD ORARIO MULTI-SIMBOLO v2`),
lo **compila**, e cicla i tre simboli **in un solo MT5, su un solo grafico**
(il motore usa `SymbolSelect` + `CopyTicksRange`: niente grafici multipli).

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia (questa riga apre MT5 da sola).' };
    $pin='<PIN>'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SPREAD_FLOTTA.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SPREAD_FLOTTA.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SPREAD_FLOTTA_v3' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin; $rc=$LASTEXITCODE;
    $r=@(Get-ChildItem (Join-Path $env:USERPROFILE 'Desktop\SPREAD_FLOTTA_*\RIGA_REFERTO_SPREAD_FLOTTA.txt') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($r.Count -eq 0){ throw 'NESSUN REFERTO DI RIGA DI ADESSO sul Desktop: la corsa non e'' arrivata alla raccolta -- copiami il rosso qui sopra.' };
    $z=@(Get-ChildItem (Join-Path $env:USERPROFILE 'Desktop\SPREAD_FLOTTA_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    $ko=(($rc -is [int]) -and ($rc -ne 0));
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO, non il numero.' -ForegroundColor Yellow };
    if($ko){ Write-Host 'MISURA NON COMPLETA (2 = PARZIALE e RIPRENDIBILE, 1 = fermata prima): mandala lo stesso, il parziale non si butta.' -ForegroundColor Yellow };
    if($z.Count -gt 0){ Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan } else { Write-Host ('ZIP NON FATTO: mandami questa cartella -> ' + $r[0].DirectoryName) -ForegroundColor Yellow };
    $iv=[Globalization.CultureInfo]::InvariantCulture;
    Write-Host ('POI in RIGA_REFERTO_SPREAD_FLOTTA.txt: riga esito: deve dire COMPLETA (se dice PARZIALE, sotto ci sono i simboli da riprendere col blocco 2), e riga data: = ORA DI AVVIO di questa corsa (circa ' + $t0.ToString('yyyy-MM-dd HH:mm',$iv) + '), NON l''ora attuale (' + (Get-Date).ToString('HH:mm',$iv) + '): il referto si timbra all''INIZIO e la corsa dura ORE -- la riga fine: dice quando ha finito. La freschezza e'' gia'' stata controllata a macchina qui sopra.') -ForegroundColor Gray }
```

> ⏱️ Tre simboli per decine/centinaia di milioni di tick l'uno possono
> richiedere **ORE**: è NORMALE, il timeout è **420 min**. La corsa è
> **RIPRENDIBILE**: se muore a metà (o la fermi tu per la RAM) non si butta
> niente. **Non chiudere la finestra di PowerShell**: è lei che a fine corsa
> chiude MT5, raccoglie e fa lo zip.

## 🔁 2️⃣ RIPRESA (solo se il referto dichiara simboli MANCANTI)

Blocco **self-contained** (non usa niente del blocco 1: quelle variabili sono
morte con lui). **Cambia solo la lista dopo `-Simboli`**, copiandola dalla riga
`csv MANCANTI:` del referto.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SPREAD_FLOTTA.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SPREAD_FLOTTA.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SPREAD_FLOTTA_v3' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Simboli "U30USD,D30EUR"; $rc=$LASTEXITCODE;
    $r=@(Get-ChildItem (Join-Path $env:USERPROFILE 'Desktop\SPREAD_FLOTTA_*\RIGA_REFERTO_SPREAD_FLOTTA.txt') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($r.Count -eq 0){ throw 'NESSUN REFERTO DI RIGA DI ADESSO sul Desktop: la ripresa non e'' arrivata alla raccolta -- copiami il rosso qui sopra.' };
    $z=@(Get-ChildItem (Join-Path $env:USERPROFILE 'Desktop\SPREAD_FLOTTA_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    $ko=(($rc -is [int]) -and ($rc -ne 0));
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO, non il numero.' -ForegroundColor Yellow };
    if($ko){ Write-Host 'RIPRESA NON COMPLETA: mandala lo stesso.' -ForegroundColor Yellow };
    if($z.Count -gt 0){ Write-Host ('MANDA IN CHAT ANCHE QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan } else { Write-Host ('ZIP NON FATTO: mandami questa cartella -> ' + $r[0].DirectoryName) -ForegroundColor Yellow };
    Write-Host 'ATTENZIONE: il REFERTO_SPREAD_FLOTTA.txt di una RIPRESA contiene SOLO i simboli ripresi (il motore lo riscrive da zero). I simboli di prima stanno nella cartella della corsa di prima: servono TUTTI E DUE gli zip.' -ForegroundColor Yellow }
```

- Il referto `REFERTO_SPREAD_FLOTTA.txt` viene **scritto e flushato SIMBOLO PER
  SIMBOLO**: è leggibile **in ogni momento**, anche a metà corsa (sta in
  `MQL5\Files` finché la riga non lo raccoglie).
- Ogni simbolo scrive **il suo CSV appena finisce**.
- 🗄️ **Il referto NON è cumulativo** (checklist 106): il motore lo **riscrive da
  zero** a ogni corsa. Su una ripresa contiene **solo i simboli ripresi** — il
  quadro completo è l'**unione** delle cartelle `SPREAD_FLOTTA_*`. I **CSV per
  simbolo**, invece, non si sovrappongono mai (uno per simbolo, e ogni corsa ha
  la sua cartella). Dal driver **v3** i reperti della corsa precedente che
  stanno ancora in `MQL5\Files` vengono **messi in salvo** nella cartella nuova
  col suffisso **`_PRIMA`** invece di essere cancellati.

---

## 📤 Cosa arriva sul Desktop

- Cartella `SPREAD_FLOTTA_<data>` con:
  - **`spread_orario_NASUSD.csv`**, **`spread_orario_U30USD.csv`**,
    **`spread_orario_D30EUR.csv`** — 24 righe orarie + riga `TUTTO`; colonne:
    `ora_server, tick_totali, tick_ask_usabili, tick_solo_bid, media_idx,
    mediana_idx, p95_idx, max_idx, overflow_tick`.
  - **`REFERTO_SPREAD_FLOTTA.txt`** — per ogni simbolo: la riga BID/ASK
    (quella che decide) + la tabella oraria impaginata.
  - **`RIGA_REFERTO_SPREAD_FLOTTA.txt`** — `data:` / `fine:` / `modo:` / i
    quattro **PASSI** (motore, compilazione, guardia MT5, corsa) / `esito:` /
    simboli fatti e mancanti.
  - eventuali file `*_PRIMA*` (reperti della corsa precedente messi in salvo) e
    gli ultimi log di MT5 (solo in cartella, non nello zip).
- Zip **leggero** `SPREAD_FLOTTA_<data>.zip` (solo csv + txt, senza log).

## 🔎 COME SI LEGGE

🕐 **PRIMA DI TUTTO** apri `RIGA_REFERTO_SPREAD_FLOTTA.txt`:
- riga **`esito:`** = **COMPLETA**. Se dice **PARZIALE**, sotto c'è
  `csv MANCANTI:` e la riga di ripresa già pronta (blocco 2️⃣);
- riga **`data:`** = **l'ora in cui hai lanciato il blocco**, non l'ora attuale:
  il referto si timbra all'**AVVIO** e la corsa dura **ore**. Il valore atteso te
  lo stampa già la riga in console. Quando ha finito lo dice la riga **`fine:`**.
  _(Classe 110: la freschezza vera l'ha già controllata a macchina il filtro
  `LastWriteTime -ge $t0` — la frase italiana la cita, non la rifà.)_
- i quattro **PASSI**: `motore:` OK dal pin · `compilazione:` **OK** (gli stati
  sono tre e sono tutti veri: `NON TENTATA` / `FALLITA` / `OK`; se è **FALLITA**
  gli errori sono in `COMPILAZIONE_FALLITA.txt` dentro lo zip) · `guardia MT5:`
  OK (MT5 chiuso all'avvio) · `corsa:` OK.

📊 **Poi `REFERTO_SPREAD_FLOTTA.txt`, per ogni simbolo, in quest'ordine:**
0. **`tick letti`** (decine/centinaia di milioni), **`blocchi persi: 0`** — se è
   > 0 la tabella è **PARZIALE** e non si legge — e **`point=0.01000`**.
1. 🚦 **La riga BID/ASK.** `% SOLO-BID ≥ 5%` → su quel simbolo **ogni corsa a
   `Spread=0` è OTTIMISTA**: si rifà imponendo `Spread = P95` misurato. (Su
   NASUSD la v1 ha già misurato **0.000% solo-bid**: atteso lo stesso sugli altri
   due, ma si misura, non si assume.)
2. 🕐 **La tabella oraria, alle ORE DEL MOTORE** — non la media di giornata:
   - **NASUSD / U30USD** → ore **14–20** server (cash USA: apertura **15:30 IT
     = 14:30 server**);
   - **D30EUR** → ore **8–16** server (cash DAX: apertura **09:00 IT = 08:00
     server**).
   Ore **SERVER BCM = ora italiana − 1**. Lo spread fuori seduta è più largo ed è
   **un altro mercato**: un motore notturno si giudica sulle ore notturne, uno di
   apertura sull'ora di apertura.
3. 💰 **Il confronto col metro C2 (cancello del costo):** il **TAKE LORDO
   MEDIANO** del motore deve essere **≥ 3× lo spread MEDIANO dell'ora in cui
   il motore lavora**. E la regola di lettura resta quella di casa: **fra
   2,5× e 3,5× il verdetto NON si dà** — zona grigia, si dichiara.
4. ⚖️ **"Minimo attrito" fra simboli:** a parità di motore, si confronta
   `mediana_idx` dell'ora di lavoro **divisa per l'ATR** (o per il take tipico)
   del simbolo — lo spread assoluto da solo non basta: 2 punti su un indice che
   si muove 40 non è come 2 punti su uno che si muove 15.
5. ⚠️ **Caveat dichiarati:** broker singolo (BCM); spread dai **tick del
   broker**, non spread di esecuzione live; **niente slippage** qui dentro;
   una sola finestra storica (21 mesi).

## 🔢 Codici d'uscita — e **cosa resta sul Desktop** per ognuno

| codice | cosa vuol dire | artefatto da mandare |
|---|---|---|
| **0** | **misura COMPLETA**: riga di chiusura vista, TUTTI i CSV freschi e con tick > 0, referto fresco | zip `SPREAD_FLOTTA_<data>.zip` |
| **2** | **PARZIALE / RIPRENDIBILE**: timeout, MT5 chiuso a metà, o un CSV a 0 tick | zip **c'è lo stesso**: mandalo, poi blocco 2️⃣ |
| **1** | fermata prima della corsa: terminale non trovato, **motore non scaricato dal pin**, **COMPILAZIONE FALLITA**, **MT5 già APERTO** | zip **c'è** (driver v3): referto coi PASSI + `COMPILAZIONE_FALLITA.txt` |
| **1** _(prima ancora)_ | `-Pin` assente/malformato, `-Simboli` vuoto | **nessun artefatto**: la cartella non esiste ancora — copiami il **rosso in console** |
| _(nessuno)_ | il blocco **non arriva** a lanciare la riga: MT5/MetaEditor aperti, o `irm` fallito, o marcatore assente | **nessun artefatto**: copiami il **rosso in console** |

## ⚠️ CORREZIONI DEL 31/08 (dal primo FAIL del verificatore — motore v2)
- Lo script RITENTA i blocchi di tick (i simboli appena selezionati rispondono
  -1 al primo accesso) e dichiara `blocchi persi:` nel referto — DEVE essere 0.
- Il cancello di compilazione cancella l'`.ex5` prima e aspetta l'artefatto
  (MetaEditor DEVE essere CHIUSO prima di lanciare, oltre a MT5).
- Un CSV "fresco" ma vuoto NON esce più 0: si pretende `tick_totali > 0`.
- A FINE CORSA MT5 viene CHIUSO e resta chiuso: il PC torna pronto per i tester.
  **NON lanciare questa riga mentre gira un backtest.**
- Conversione 100 MISURATA su tutti e tre: NASUSD (R97 + v1 30/08),
  U30USD (R55/R97), D30EUR (Breakin 31/08).

## ⚠️ CORREZIONI DEL 03/09 (secondo FAIL del verificatore — **driver v2 → v3**, pagina ri-pinnata)
Questa pagina era del **31/08**: **precede** le classi 106/107/108/110/111/112
della checklist (nate l'1–3/09). Il censimento della **classe 111** l'ha pescata
fra i "fratelli dormienti", ed era armata su cinque cose:
1. **Classe 108** — il blocco faceva `$global:LASTEXITCODE=0` + `if($LASTEXITCODE -ne 0)`:
   su PS 5.1 un codice **non letto** (`$null`) è `-ne 0` = **VERO**, cioè
   **allarme rosso su una corsa sana**. Ora: `$rc -is [int]` e tre stati
   (`0` / `≠0` / **NON LETTO**), e il verdetto si appoggia all'**artefatto datato**.
2. **Classe 94-bis** — il blocco diceva _"leggi RIGA_REFERTO... sul Desktop"_ anche
   sui rami che **muoiono prima della raccolta** (MT5 aperto, compilazione): sul
   Desktop non c'era niente. Ora il driver **v3 scrive referto + zip su OGNI ramo**
   che arriva dopo la creazione della cartella, e la tabella dei codici qui sopra
   dice **quali due rami non lasciano niente** e cosa mandare al posto loro.
3. **Classe 94-ter** — il referto della riga non aveva nessun campo
   `compilazione:`. Ora i **quattro PASSI** hanno tre stati ciascuno, timbrati
   sul ramo che li **decide** (`FALLITA` è un token che il codice scrive davvero).
4. **Classe 110** — nessun gate di freschezza con `$t0`, e il referto si timbra
   all'**avvio** di una corsa che dura **ore**. Ora il blocco filtra
   `LastWriteTime -ge $t0` sull'artefatto, e il referto porta **anche `fine:`**.
5. **Classe 88 + 106** — la pulizia pre-corsa **cancellava** il referto e i CSV
   della corsa precedente rimasti in `MQL5\Files` (l'unica copia, se quella corsa
   era stata interrotta). Ora vengono **salvati col suffisso `_PRIMA`**, e la
   pagina dichiara che il referto **non è cumulativo**.

**In più (difetti trovati leggendo il driver, non in checklist):**
- il **blocco di RIPRESA** della pagina vecchia usava `$p` e `$pin` di un blocco
  già morto e rimandava a una _"STRINGA 3 consegnata in chat"_ che qui non
  esisteva: adesso è **self-contained** e sta nel blocco 2️⃣;
- se **MT5 spariva** (chiuso a mano o crollato) la riga restava a girare a vuoto
  **fino a 7 ore**: ora se ne accorge in **20 s**, raccoglie e stampa la ripresa
  — ed è proprio la **procedura di STOP** dell'avvertenza RAM di oggi;
- `Compress-Archive` falliva **in silenzio** (`catch{ }` vuoto): ora lo stato
  dello zip finisce in console e in coda al referto, e il blocco sa dire
  «manda la cartella» quando lo zip non c'è.
