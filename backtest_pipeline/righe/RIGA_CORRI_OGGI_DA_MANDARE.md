# 📬 CORRI OGGI — **LE RIGHE DA MANDARE** (21 round, mai girati, ~25 min)

> 🛑 **NON ANCORA CONSEGNATE.** Manca il PASS dell'agente `controllo-preventivo`
> (lo strato di GIUDIZIO). I due cancelli **meccanici** sono passati — i codici
> di uscita stanno in fondo — ma il cancello deterministico lo stampa da sé che
> **non è un PASS completo**. Finché non arriva, queste righe non escono.

---

## 🖥️ IL BERSAGLIO — si legge PRIMA del codice

> ### **finestra PowerShell sul VPS (VMI3047753)**
>
> La riga pilota **SOLO il terminale di BACKTEST `50504400` (`C:\MT5_Backtest`)**,
> e nemmeno direttamente: lo fa per procura attraverso `RIGA_SOTTILE_ROUND.ps1`,
> che porta quel percorso **scritto in codice** e non accetta nessun argomento
> per spostarlo.
>
> 🔴 **NON vengono toccati, e non c'è modo di toccarli:**
> | conto | cartella programma | cos'è |
> |---|---|---|
> | `50503392` | `BCM Markets MT5 Terminal` | il piccolo, **sedie vive** |
> | `50504263` | `... MT5 Terminal -V3` | il 100k, **sedie vive** |
> | `10105439` | `C:\BCM_Reale` | il **REALE** |
> | — | cartella dati **Pepperstone** | |
> | — | cartella dati **Tickmill** | |
>
> Sul VPS convivono **SEI** cartelle dati: *"gira sul VPS"* da solo **non è un
> bersaglio, è un indirizzo**. Il bersaglio è il quarto terminale.
>
> ✋ **Nessuna azione a mano dentro MT5.** Non si apre nessun grafico, non si
> trascina nessun EA, non si guarda nessuna finestra "a occhio".
> 🟢 **La prova che i tre terminali in forward non sono stati toccati la stampa
> il driver da sé**: `PID vivi PRIMA` e `PID vivi DOPO` devono essere **gli
> stessi**. Va guardata, è il controllo numero 1.

🚫 **Questa NON è una riga da coda.** Non va in `backtest_pipeline/coda/CODA.txt`:
la coda di stanotte ha i suoi tre round (`r132c`, `r133a`, `r133b`, `r133c`) e
**resta com'è**. Questa si incolla **a mano, di giorno, guardandola**.

---

## 📌 IL PIN — **`913fcf30e6d804e4e4753ccfeec8f1c44739cd04`**

| | |
|---|---|
| **Script** | `backtest_pipeline/righe/RIGA_CORRI_OGGI.ps1` |
| **Marcatore** | `MARCATORE_RIGA_CORRI_OGGI_v1` |
| **Impronta SHA-256 a quel pin** | `F47F7AB2149BF8D7588078A9127C052F0C0AEFE2582BFB92C86C002665ACEFD1` |
| **Pin interno che usa lui** | `0c7d98af…` → scarica `RIGA_SOTTILE_ROUND.ps1`, che a sua volta porta dentro `$PIN = fb9b4731…`, da cui il driver prende **i 21 file prova** (verificati uno per uno: ci sono tutti) |

🔗 **La catena dei pin è a tre anelli e ognuno verifica il successivo**: la riga
incollata inchioda il mio script (impronta + marcatore), il mio script inchioda
la riga sottile (impronta + marcatore), la riga sottile inchioda driver e
`RIGA_ROUND_VPS` (due impronte + due marcatori). **Se un anello non torna, non
si esegue niente.**

---

## 1️⃣ PRIMA IL GIRO A VUOTO — **obbligatorio, e non è una formalità**

Non avvia nessun tester. Serve a leggere il numero di **CELLE PER FINESTRA** che
stampa **il DRIVER**.

🔴 **`r128a` DEVE stampare 7.** Se stampa **26**, **si ferma tutto**: vuol dire
che il driver non ha riconosciuto l'enum `ENUM_TIMEFRAMES` e girerebbe valori
che **non sono timeframe**. (26 è il conteggio *aritmetico*, ed è quello che
stampa anche `controlla_prova.py`, che l'enum non lo conosce.)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='913fcf30e6d804e4e4753ccfeec8f1c44739cd04';
    $sha='F47F7AB2149BF8D7588078A9127C052F0C0AEFE2582BFB92C86C002665ACEFD1';
    $p="$env:USERPROFILE\RIGA_CORRI_OGGI.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_CORRI_OGGI.ps1" -OutFile $p;
    $h=(Get-FileHash $p -Algorithm SHA256).Hash;
    if($h -ne $sha){ throw ("IMPRONTA DIVERSA: attesa $sha trovata $h -- NON eseguo") };
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_CORRI_OGGI_v1' -Quiet)){ throw 'SCRIPT SBAGLIATO: manca il marcatore' };
    $global:LASTEXITCODE=0; & $p -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! GIRO A VUOTO NON PASSATO: NON lanciare la corsa vera.' -ForegroundColor Red } }
```

---

## 2️⃣ POI LA CORSA VERA — 21 round in sequenza, **una sola incollata**

⏱️ **Stima ~25 minuti**, banda dichiarata **13–50 min**.
Metro: la retta `T(min) = 0,6 + 0,077 × passate` **per round**, tarata sui tempi
round-per-round misurati in `risultati_archivio/r88_csv/REFERTO_R88.txt` r.10-14
(stesso EA, stesso simbolo, stesso TF, tick reali).
🔴 **Fuori dalla stima: lo SCARICO DEI TICK, che è `[NON MISURATO]`.**

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='913fcf30e6d804e4e4753ccfeec8f1c44739cd04';
    $sha='F47F7AB2149BF8D7588078A9127C052F0C0AEFE2582BFB92C86C002665ACEFD1';
    $p="$env:USERPROFILE\RIGA_CORRI_OGGI.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_CORRI_OGGI.ps1" -OutFile $p;
    $h=(Get-FileHash $p -Algorithm SHA256).Hash;
    if($h -ne $sha){ throw ("IMPRONTA DIVERSA: attesa $sha trovata $h -- NON eseguo") };
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_CORRI_OGGI_v1' -Quiet)){ throw 'SCRIPT SBAGLIATO: manca il marcatore' };
    $global:LASTEXITCODE=0; & $p;
    Write-Host ("CORRI OGGI -- uscita finale: " + $LASTEXITCODE) }
```

### 🔁 Se si ferma a metà

Lo script **si ferma sul primo round che non produce niente** — di proposito: se
il banco è sporco o un EA non compila, i venti round dopo sarebbero venti
fallimenti identici e mezz'ora buttata. Stampa lui l'etichetta da cui ripartire.

> 🔴 **La riga di ripartenza è LUNGA come le altre due, e non è pedanteria: è un
> FAIL che il cancello mi ha trovato addosso.** La prima stesura riusava la copia
> già scaricata (`& $p -Da r125a`) — cioè **senza pin e senza marcatore**. Una
> copia vecchia sul disco sarebbe girata **senza dirlo**, e la ripartenza è
> proprio il momento in cui qualcosa è già andato storto: è l'ultimo posto dove
> ci si può permettere di fidarsi del disco.

**Riparti da un'etichetta** (sostituisci `r125a` con quella che ha stampato lui):

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='913fcf30e6d804e4e4753ccfeec8f1c44739cd04';
    $sha='F47F7AB2149BF8D7588078A9127C052F0C0AEFE2582BFB92C86C002665ACEFD1';
    $daQui='r125a';
    $p="$env:USERPROFILE\RIGA_CORRI_OGGI.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_CORRI_OGGI.ps1" -OutFile $p;
    $h=(Get-FileHash $p -Algorithm SHA256).Hash;
    if($h -ne $sha){ throw ("IMPRONTA DIVERSA: attesa $sha trovata $h -- NON eseguo") };
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_CORRI_OGGI_v1' -Quiet)){ throw 'SCRIPT SBAGLIATO: manca il marcatore' };
    $global:LASTEXITCODE=0; & $p -Da $daQui;
    Write-Host ("CORRI OGGI (ripartenza da " + $daQui + ") -- uscita finale: " + $LASTEXITCODE) }
```

**Oppure tira avanti comunque**, quando si vuole sapere *quanti* ne cadono
(aggiungi `-NonFermarti` invece di `-Da`):

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='913fcf30e6d804e4e4753ccfeec8f1c44739cd04';
    $sha='F47F7AB2149BF8D7588078A9127C052F0C0AEFE2582BFB92C86C002665ACEFD1';
    $p="$env:USERPROFILE\RIGA_CORRI_OGGI.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_CORRI_OGGI.ps1" -OutFile $p;
    $h=(Get-FileHash $p -Algorithm SHA256).Hash;
    if($h -ne $sha){ throw ("IMPRONTA DIVERSA: attesa $sha trovata $h -- NON eseguo") };
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_CORRI_OGGI_v1' -Quiet)){ throw 'SCRIPT SBAGLIATO: manca il marcatore' };
    $global:LASTEXITCODE=0; & $p -NonFermarti;
    Write-Host ("CORRI OGGI (senza fermarsi) -- uscita finale: " + $LASTEXITCODE) }
```

---

## 3️⃣ LA RACCOLTA — **la fa lo script da sé**, e stampa cosa MANCA

Alla fine, senza nessuna riga in più:

| cosa | dove |
|---|---|
| cartella sul Desktop | `Desktop\CORRI_OGGI_<AAAAMMGG_HHMMSS>\` (una sottocartella `ROUND_<etichetta>` per round) |
| **zip pronto da mandare** | `Desktop\CORRI_OGGI_<AAAAMMGG_HHMMSS>.zip` |
| elenco dei file attesi | stampato in console, **`PRESENTE` / `ASSENTE` riga per riga** |

**I file attesi sono 63** = 21 round × 3:
`*_IS_<etichetta>.csv` · `*_OOS_<etichetta>.csv` · `REFERTO_ROUND_<etichetta>.txt`

Le 21 etichette, in ordine di corsa:
```
r127a
r120a11  r120a01  r120a10  r120a00
r128a
r125a  r125b  r125c  r125d  r125e  r125f
r124a
r120d11  r120d01  r120d10  r120d00
r120c11  r120c01  r120c10  r120c00
```

🔴 **Un `ASSENTE` nell'elenco vale più di un PF**: vuol dire che quel round non
ha misurato niente, e va capito **prima** di leggere gli altri.

---

## 4️⃣ COSA GUARDARE, in quest'ordine

1. 🖥️ **`PID vivi PRIMA` = `PID vivi DOPO`** su ogni round. Se manca un numero,
   si controlla subito il terminale in forward corrispondente.
2. 🕳️ **gli `ASSENTE`** nell'elenco della raccolta.
3. ⚓ **LE ANCORE, prima di qualunque altro numero.** Ogni blocco contiene la sua
   cella viva, e deve ridarla identica:

   | round | cella | deve ridare |
   |---|---|---|
   | **`r127a`** | `InpSLBufferPips=3` | **OOS** PF `1,68815` · DD `0,8567%` · Trades `86` · profit `+300,61` — **IS** PF `1,34237` · DD `0,9670%` · Trades `69` · profit `+118,82`. Fonte aperta e verificata riga per riga: `risultati_prove/ABTG_SupRev_NAS_H1_Ottimizzato/..._NASUSD_{IS,OOS}.csv`, riga `InpTF=16385` |
   | `r120a11` `r120d11` `r120c11` | trailing + flip **accesi** | le celle vive dei loro blocchi — valori d'ancora **`[NON MISURATO]` da me**: stanno dentro i rispettivi file prova, si leggono lì |

   🔴 **Se un'ancora non torna, il guasto è nel BANCO o nel BINARIO, non nei
   parametri — e i parametri NON si leggono.**
4. 🔢 **il numero di CELLE per finestra**: `r128a` deve dire **7**, non 26.

### ⚠️ E ciò che questi CSV NON possono dire, dichiarato prima di leggerli
Il campione si conta in **POSIZIONI, non in deal** (classe 226, fattore misurato
**1,000–2,314**). La colonna `Trades` conta i **deal di uscita**. Su `r127a`,
`r120a`, `r120c`, `r120d` c'è il parziale al 50% **e** la tranche pendente: fino
a **4 deal per segnale**. Un `Trades = 86` può essere **22 posizioni**.
👉 **Sotto 150 posizioni il MERITO è sospeso. Il RISCHIO si legge a qualunque n**
(Emendamento B del 16/08).

---

## 🚦 I CANCELLI — codici di uscita, lanciati **da soli, senza pipe** (classe 254)

| cancello | comando | uscita |
|---|---|---|
| `controlla_prova.py` sui 21 file | `python3 backtest_pipeline/controlla_prova.py <i 21 file>` | **0** — `21 file · 96 celle · 192 passate · 0 problemi` *(96 = conteggio aritmetico; con l'enum di `r128a` corretto sono **77 celle / 154 passate**)* |
| `controlla_riga.py --ps1` | `python3 backtest_pipeline/controlla_riga.py --ps1 backtest_pipeline/righe/RIGA_CORRI_OGGI.ps1` | **0** — 6 controlli passati (ASCII puro · parser PowerShell vero 0 errori · param block · niente pwsh-7-only · formati .NET · niente Parse decimale senza cultura) |
| `controlla_riga.py --oggetto prova` | sui 21 file prova | **0** — nessun difetto meccanico |
| 🤖 **agente `controllo-preventivo`** | — | 🔴 **NON ANCORA PRESO. Bloccante.** |

---

## 🚫 COSA QUESTA RIGA NON FA

- non tocca **nessun EA, preset, parametro o sedia in forward**;
- non scrive in `backtest_pipeline/coda/`;
- non chiude nessun processo (`-ChiudiBacktest` **non è raggiungibile** da qui);
- non promuove niente e non giudica niente: **produce CSV**;
- 🔒 **rischio e taglie: `[FIRMA DI CLAUDIO]`**. Nessun round cambia un rischio:
  i depositi (10.000 / 100.000) sono quelli **letti nei file prova**, che sono
  quelli delle corse d'ancora.
