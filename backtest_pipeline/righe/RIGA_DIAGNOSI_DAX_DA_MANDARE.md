# 🩺 DIAGNOSI DEL DAX HISTDATA — foglio di lancio (26/08/2026)

**Macchina: PC DI BACKTEST. Non sul VPS** (sul VPS non c'è la cache degli zip,
e non c'è niente da diagnosticare).
**Durata attesa: BLOCCO 1 ~1 minuto · BLOCCO 2 ~3-6 minuti · BLOCCO 3 (solo se
te lo chiediamo) ~8-12 minuti**, di cui ~2 di rete.
**MT5 può restare aperto**: questa riga **non apre MetaTrader, non importa
niente, non crea nessun simbolo `_EXT`** e non scrive un byte dentro
`MetaQuotes\Terminal`. Legge zip e scrive sul Desktop.

---

## 📌 IL PIN DI QUESTA RIGA

```
@@PIN@@
```

---

## 🎯 PERCHÉ ADESSO, E CHI L'HA AUTORIZZATA

`STORICO_INDICI_CRITERI.md` porta la decisione **D-F, già firmata** da te il
25/08 ("FIRMO CON PROPOSTE"):

```
@DECISIONE D-F CHIAVE=STRADA_DAX VALORE=diagnosi_prima STATO=FIRMATO
```

cioè: **prima di qualunque import del DAX si fa la diagnosi dei dati.**
🔓 **Questa riga È quella diagnosi.** Non aggiunge nessuna decisione nuova e
**non ti chiede nessuna firma nuova**: cita quella che c'è già e la **rilegge al
pin** — se D-F non risultasse più firmata, la diagnosi non parte e il referto lo
scrive.

Il fatto da cui si parte (`REFERTO_HISTDATA_FATTIBILITA.md` §13): il 18/08 il
DAX di HistData (`grxeur`) è stato **bocciato dai cancelli dello strumento** per
due motivi — **prezzo minimo 2.906** (un DAX sotto 8.000 non esiste) e
**sessione ballerina** (apertura 00:00 fino a 2020-05, **02:00 da 2020-06 a
2023-11**, poi di nuovo 00:00).

> 🕐 **E queste ore sono ORA DI NEW YORK**, perché è l'orologio con cui HistData
> scrive i suoi file — **non** l'ora server BCM e **non** l'ora italiana. Ora
> server BCM = NY+5 (NY+4 nelle finestre in cui il DST americano e quello
> europeo sono sfasati); ora italiana = server+1. Quindi quel `02:00` è
> **07:00 server = 08:00 italiane**. Vale per *ogni* orario di questa pagina e
> del referto: lo dice anche il referto, in fondo alla tabella.

Da allora **nessuno ha guardato dove stanno
quelle righe**: il modo `--diagnosi` di `histdata_m1.py` esiste dal 19/08 e
**non è mai stato eseguito sui dati veri**.

---

## ❓ LE TRE DOMANDE, SCRITTE PRIMA DI GUARDARE I NUMERI

| # | domanda | come si risponde CON NUMERI |
|---|---|---|
| **Q1** | i prezzi impossibili: **in quali anni**? e sono **scala/valuta** o **spazzatura**? | barre fuori banda per anno e per giorno (dallo strumento) + **in quali ORE** stanno (mappa). Giornate **intere** fuori banda = scala/strumento diverso; **pochi tick** = spazzatura |
| **Q2** | la sessione 2020-2023: **quali ore coprono i giorni**? **convenzione** o **buchi di feed**? | per ogni mese: **prima e ultima ora toccata**, quante ore **piene**, e la **densità** (barre medie per ora). Finestra spostata + densità ~60 = **convenzione**; stessa finestra + densità bassa = **buchi** |
| **Q3** | esiste un **sottoinsieme sano** dichiarabile (anni + ore)? | ogni anno esce classificato **SANO / RIPARABILE / MARCIO**, con la regola scritta prima |

**Il verdetto ha tre esiti, decisi prima della misura:**
**SANO PARZIALE** (elenco anni) · **RIPARABILE** (la convenzione X) · **MARCIO**.

> ⚠️ **Questa corsa NON autorizza niente.** Il **cancello ZERO** sugli indici
> `_EXT` resta chiuso e la D-C dice `SOLO_PROVA_REGIME`: usare un eventuale
> sottoinsieme sano richiederà **un'altra firma**, che qui non c'è.

---

## ▶️ BLOCCO 1 — GIRO A VUOTO (~1 minuto): **cosa c'è davvero sul disco?**

Non diagnostica niente: scarica lo strumento al pin, fa l'autotest, legge la
decisione D-F e **apre uno per uno gli zip** per dire, anno per anno, se il DAX
è diagnosticabile. Incolla il **blocco INTERO** (è un comando solo).

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $pin='@@PIN@@'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_DIAGNOSI_DAX.ps1"; Remove-Item $p -Force -EA SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_DIAGNOSI_DAX.ps1" -OutFile $p -EA Stop; if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_DIAGNOSI_DAX_v1' -Quiet)){ throw 'SCRIPT VECCHIO O SBAGLIATO: non lancio niente' }; $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo; $rc=$LASTEXITCODE; if($rc -eq 2){ throw 'NON PARTITA (uscita 2): leggi il rosso qui sopra, rimedia e rilancia questo stesso blocco' }; $dsk=[Environment]::GetFolderPath('Desktop'); $c=@(Get-ChildItem (Join-Path $dsk 'DIAGNOSI_DAX_*\CENSIMENTO_ZIP_DAX.txt') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 }); if($c.Count -eq 0){ throw 'NESSUN CENSIMENTO DI ADESSO: la corsa non ha scritto niente' }; Write-Host ('CENSIMENTO: ' + $c[0].FullName) -ForegroundColor Cyan; if($rc -ne 0){ Write-Host 'QUALCOSA NON TORNA: mandami il CENSIMENTO_ZIP_DAX.txt qui sopra PRIMA del blocco 2.' -ForegroundColor Yellow } else { Write-Host 'TUTTO A POSTO: lancia il BLOCCO 2.' -ForegroundColor Green } }
```

**Le righe da guardare** (l'elenco degli anni dipende da cosa c'è in cache: è
esattamente quello che questo blocco va a misurare):

```
[hh:mm:ss] D-F firmata (diagnosi_prima): la diagnosi e' autorizzata.
[hh:mm:ss] banda di prezzo attesa per il DAX: 4000.0 - 45000.0  (letta dal sorgente)
[hh:mm:ss] anni grxeur PRONTI  : 2019, 2020, 2021, 2022, 2023, 2024, 2025, 2026
[hh:mm:ss] anni grxeur MANCANTI: nessuno
```

- Se **PRONTI** è `NESSUNO`: gli zip del DAX non ci sono più (cache ripulita?) →
  mandami il censimento, si rimedia col **blocco 3**, che li riscarica.
- Se **MANCANTI** elenca degli anni: sono anni della finestra che **non** sono in
  cache. Il blocco 2 **non li inventa e non li scarica**: li dichiara e basta.
- Se esce `D-F ... la diagnosi non parte`: qualcuno ha cambiato il file dei
  criteri. **Non si scavalca dalla console** (apposta): si rifirma nel file.

---

## ▶️ BLOCCO 2 — LA DIAGNOSI VERA (~3-6 minuti, **offline**)

Non scarica **un solo byte di dati**: lavora sugli zip già sul disco. Anno per
anno lancia `histdata_m1.py --diagnosi` su una **copia usa-e-getta** dello zip
(la cache non viene mai data in pasto allo strumento, che gli zip illeggibili li
cancella) e ci aggiunge la **mappa delle sessioni**, più il **controllo
positivo** sul Nasdaq.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $pin='@@PIN@@'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_DIAGNOSI_DAX.ps1"; Remove-Item $p -Force -EA SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_DIAGNOSI_DAX.ps1" -OutFile $p -EA Stop; if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_DIAGNOSI_DAX_v1' -Quiet)){ throw 'SCRIPT VECCHIO O SBAGLIATO: non lancio niente' }; $global:LASTEXITCODE=0; & $p -Pin $pin; $rc=$LASTEXITCODE; if($rc -eq 2){ throw 'NON PARTITA (uscita 2): leggi il rosso qui sopra, rimedia e rilancia questo stesso blocco' }; $dsk=[Environment]::GetFolderPath('Desktop'); $z=@(Get-ChildItem (Join-Path $dsk 'DIAGNOSI_DAX_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 }); if($z.Count -eq 0){ throw 'NESSUNO ZIP DI ADESSO: la corsa non e'' arrivata alla raccolta' }; if($rc -ne 0){ Write-Host 'ESITO PARZIALE: qualcosa non e'' stato misurato -- E'' GIA'' UNA RISPOSTA, lo zip va mandato LO STESSO.' -ForegroundColor Yellow }; Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan }
```

---

## ▶️ BLOCCO 3 — **SOLO SE TE LO CHIEDIAMO IN CHAT**: estendere al 2010 (~8-12 min)

Uguale al blocco 2, **più** lo scarico degli anni della finestra che mancano in
cache (2010-2018), che vengono **diagnosticati nella stessa corsa**. Ha il suo
**canarino di ritmo** con la soglia **letta da D-E** (oggi vale 20 ore): se il
ritmo di HistData proiettasse più di quella, **non scarica niente e lo scrive**.

⚠️ Si lancia **dopo** aver letto il verdetto del blocco 2: se il DAX 2019-2026 è
**marcio**, scaricare altri nove anni marci non serve a niente (D-F: *"più anni
di dati marci non sono più informazione, sono più modi di sbagliarsi"*).

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $pin='@@PIN@@'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_DIAGNOSI_DAX.ps1"; Remove-Item $p -Force -EA SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_DIAGNOSI_DAX.ps1" -OutFile $p -EA Stop; if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_DIAGNOSI_DAX_v1' -Quiet)){ throw 'SCRIPT VECCHIO O SBAGLIATO: non lancio niente' }; $global:LASTEXITCODE=0; & $p -Pin $pin -EstendiIndietro; $rc=$LASTEXITCODE; if($rc -eq 2){ throw 'NON PARTITA (uscita 2): leggi il rosso qui sopra, rimedia e rilancia questo stesso blocco' }; $dsk=[Environment]::GetFolderPath('Desktop'); $z=@(Get-ChildItem (Join-Path $dsk 'DIAGNOSI_DAX_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 }); if($z.Count -eq 0){ throw 'NESSUNO ZIP DI ADESSO: la corsa non e'' arrivata alla raccolta' }; if($rc -ne 0){ Write-Host 'ESITO PARZIALE: lo zip va mandato LO STESSO.' -ForegroundColor Yellow }; Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan }
```

---

### 📨 Cosa mandare, e quale data guardare

Manda **il file che ti stampa l'ultima riga in ciano**:
`Desktop\DIAGNOSI_DAX_<data>_<ora>.zip`.

> 🗓️ **PRIMA DI MANDARLO, APRI `REFERTO_DIAGNOSI_DAX.txt` E GUARDA LA QUARTA
> RIGA:** dice `data: AAAA-MM-GG HH:MM:SS   <-- QUESTA DATA DEVE ESSERE DI
> ADESSO`. **Se quella data non è di adesso, stai mandando un referto vecchio**
> (è già successo due volte, il 17/08).

> ⚠️ Sul Desktop può comparire anche un `histdata_m1.zip`: **non è quello.** Lo
> fa lo strumento a ogni chiamata, il driver lo cancella da solo, e se non ci
> riesce te lo scrive in giallo.

**Dentro lo zip devono esserci** (l'elenco lo stampa anche il driver, e lo
confronta lui con quello che ha davvero raccolto — se manca qualcosa lo dice in
rosso):

| file | cosa c'è dentro |
|---|---|
| `REFERTO_DIAGNOSI_DAX.txt` | le tre risposte, la tabella anno per anno, il verdetto a tre esiti, NOTE e PROBLEMI |
| `CENSIMENTO_ZIP_DAX.txt` | ogni zip aperto, con anno, peso e data di scrittura |
| `MAPPA_SESSIONI.txt` | per anno **e per mese**: finestra oraria, ore piene, barre, densità — più il controllo positivo Nasdaq |
| `anni\diagnosi_grxeur_<anno>.txt` | il referto **integrale** dello strumento per quell'anno (giorni marci uno per uno, apertura modale mese per mese) |
| `STORICO_INDICI_CRITERI.md` | il file delle decisioni **al pin**, così si vede cosa era firmato quando la corsa è girata |
| `log\*.log` | l'uscita cruda di ogni chiamata a python (autotest compreso) |

### 🔢 Le tre uscite possibili

| uscita | significa | cosa fare |
|---|---|---|
| **0** | diagnosi completa | manda lo zip |
| **1** | parziale, **oppure un pezzo di verdetto SOSPESO** (un anno non misurabile, uno zip rotto, D-F non firmata, la soglia di densità senza metro, l'elenco dei giorni sporchi troncato dallo strumento) | **manda lo zip lo stesso**: "non misurabile" è già una risposta, e i PROBLEMI del referto dicono quale pezzo è sospeso |
| **2** | non è partita (pin, python, strumento, autotest, RAM) | leggi il rosso, rimedia, rilancia lo stesso blocco |

**Rilanciare è sicuro**: la corsa non modifica nessun dato (li legge soltanto) e
le cartelle di lavoro se le rifà da sola. L'unica cosa che il blocco 3 aggiunge
al disco sono gli zip nuovi nella cache `~\histdata_m1`.

---

## 📖 COME SI LEGGERÀ IL RISULTATO (scritto PRIMA di vederlo)

Il driver stampa la tabella già fatta, una riga per anno:

```
anno      barre   fuoriB  giorni   fuori%  finestra    piene      dens  classe       perche'
2021     219240     1680       2    0.766  02:00-15:00    14      60.0  RIPARABILE   sporco ISOLATO ...; finestra diversa ma DENSA
```

- **`finestra`** = prima e ultima ora toccata dal feed, **in ora di New York**
  (server BCM = NY+5, italiana = server+1). Il referto lo ripete sotto la tabella.
- **`piene`** = quante ore hanno almeno 30 barre in metà dei giorni;
  **`dens`** = barre medie per ora toccata. **60 = giornata piena.**
- **`n/d` vuol dire NON MISURATO.** Mai uno zero al posto di un buco.
- **Il controllo positivo (Nasdaq) serve proprio a questo:** se il DAX ha densità
  40 e il Nasdaq pure, allora 40 è *"come scrive HistData"*, non *"malato"*. Se
  il Nasdaq sta a 59 e il DAX a 40, la differenza **è del DAX**.

Le tre classi, con la regola dichiarata (sono **parametri della riga**, non
criteri firmati: si possono discutere, e i numeri grezzi restano validi comunque):

1. **SANO** — 0 barre fuori banda, finestra uguale a quella **modale** della
   serie, densità ≥ 55.
2. **RIPARABILE** — i difetti sono **dichiarabili**: sporco isolato (pochi
   giorni → si escludono le date; oppure pochissime barre → si scartano le
   barre fuori banda) e/o finestra diversa **ma densa** (= cambio di
   **convenzione**, non buchi).
3. **MARCIO** — sporco diffuso, oppure densità sotto soglia (**buchi di feed**:
   un buco non si "dichiara", si esclude il periodo).

**E il passo dopo non è importare.** Se esce SANO PARZIALE o RIPARABILE, il
passo successivo è scrivere nei criteri una decisione nuova che dica
**esattamente** quale sottoinsieme si usa (anni + ore + giorni esclusi) e con
quale limite d'uso — e firmarla. Se esce MARCIO, diventa buona la **strada 2**
della D-F: Dukascopy `DEUIDXEUR` **solo sulle finestre di regime** (~25 ore di
crawl, due notti).

### ⚖️ Cosa questa corsa NON può dire (dichiarato nel referto)

1. Vede **un solo feed**. Quanto valesse davvero il DAX in quei giorni lo dicono
   Dukascopy o il grafico BCM nativo (che però parte dal 26/09/2024).
2. Non dice se il DAX HistData è **lo stesso strumento** del CFD BCM (indice vs
   future: c'è il *basis*, e nessun orario lo cura).
3. Non misura il **cancello ZERO**: quello si misura solo importando, e
   importare è ciò che D-F vieta finché questa diagnosi non è letta.

---

## 🔧 PER LA SESSIONE (non per Claudio) — assegnare il pin

La pagina esce con un **segnaposto** al posto del commit. Va sostituito nei
**punti d'uso**, mai su tutta la pagina (una `sed` larga riscriverebbe anche
questa spiegazione, e la ricetta morirebbe al secondo giro).

```bash
cd ~/GITHUB && git pull --rebase --autostash
SHA=$(git rev-parse HEAD)
F=backtest_pipeline/righe/RIGA_DIAGNOSI_DAX_DA_MANDARE.md
TOK='@@PIN'"@@"
sed -i "s|\$pin='$TOK'|\$pin='$SHA'|g; s|^$TOK\$|$SHA|" "$F"
grep -c "\$pin='$SHA'" "$F"    # DEVE dare 3 (tre blocchi)
grep -c "$TOK" "$F"            # DEVE dare 0
```

**Ri-pinnatura** (quando il pin va rifatto: succede più spesso di quanto si
creda). Il pin vecchio si legge **dai punti d'uso** e si sostituisce **solo lì**:
le menzioni in prosa di un pin bruciato sono **storia** e non si toccano.

```bash
NUOVO=<lo sha nuovo, 40 caratteri>
F=backtest_pipeline/righe/RIGA_DIAGNOSI_DAX_DA_MANDARE.md
VECCHIO=$(grep -oE "\\\$pin='[0-9a-f]{40}'" "$F" | head -1 | grep -oE '[0-9a-f]{40}')
sed -i "s|\$pin='$VECCHIO'|\$pin='$NUOVO'|g; s|^$VECCHIO\$|$NUOVO|" "$F"
grep -c "\$pin='$NUOVO'" "$F"     # DEVE dare 3
grep -c "\$pin='$VECCHIO'" "$F"   # DEVE dare 0
```

⚠️ I due conteggi vanno **tutti e due**: un `sed` che non ha sostituito niente
supera a mani basse il solo "zero segnaposto rimasti".
