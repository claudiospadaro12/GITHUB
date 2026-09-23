# 🚀 I ROUND PRONTI IN MACCHINA — R235 + R234 + R236 (23/09/2026)

## 🖥️ DOVE VA MANDATA QUESTA STRINGA

**Finestra PowerShell sul PC DI BACKTEST — la macchina si chiama `DESKTOP-H4D7CAJ`.**
Non serve aprire nessun MT5 a mano: la stringa pilota da sola il terminale che le
serve. Serve pero' che **MT5 sia CHIUSO** su quel PC prima di lanciare (vedi sotto).

### 🔴 E QUESTO E' CIO' CHE **NON** VIENE TOCCATO, per nome

La stringa **si rifiuta di partire** se non si trova su `DESKTOP-H4D7CAJ`: il primo
controllo legge `$env:COMPUTERNAME` e muore con un messaggio in chiaro.

- 🚫 **Il VPS `VMI3047753` non viene sfiorato.** Nemmeno letto.
- 🚫 In particolare **NON** si tocca il terminale della challenge
  **FTMO `541452707` (`C:\FTMO`)**, dove in questo momento stanno operando sei sedie.
- 🚫 **NON** si tocca `50503392` (`BCM Markets MT5 Terminal` **sul VPS**).
- 🚫 **NON** si tocca `50504263` (`... MT5 Terminal -V3`, il 100k).
- 🚫 **NON** si tocca `10105439` (`C:\BCM_Reale`, il conto REALE).
- 🚫 **NON** si tocca `50503635` (`C:\MT5_MANUALE`, il trading a mano).
- 🚫 **NON** si tocca `50504400` (`C:\MT5_Backtest`, il banco del VPS: resta SPENTO).
- 🚫 **NON** si toccano **Pepperstone** ne' **Tickmill**.

✍️ **Firma di Claudio del 21/09**: i round girano sul PC di backtest, **mai sul VPS**,
finche' una challenge e' viva. Questa stringa e' quella firma resa eseguibile.

### ⚠️ DUE COSE DA GUARDARE PRIMA DI PREMERE INVIO (30 secondi)

1. 🪟 **Chiudi MT5 sul PC di backtest.** Il tester non parte col terminale aperto e
   uscirebbero ZERO CSV. La stringa **rifiuta di partire** se trova `terminal64`
   vivo: te lo dice e si ferma, non ammazza niente.
2. 👀 **Guarda che su quel terminale non ci siano SEDIE attaccate ai grafici.**
   Il terminale del PC di backtest e' loggato sul **demo piccolo 50503392**, e il
   14/08/2026 da quella macchina sono partiti ordini veri (#3160534 / #3160535,
   -104,60). Non e' un banco solo-tester come quello del VPS.
3. 🔥 **Il tester a tick reali si mangia tutte le CPU di quel PC.** Per la durata
   della corsa quella macchina e' occupata. Il VPS, e quindi la challenge, no.

---

## 📋 LA STRINGA

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $PIN='c3ac4ada7688bb6cb7229e5acb6c44d1b724fbe0'; $T0=Get-Date; if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ throw ('QUESTA RIGA GIRA SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ. Qui la macchina si chiama: ' + $env:COMPUTERNAME + '. Sul VPS VMI3047753 non si lancia: la challenge FTMO 541452707 sta operando.') }; if((@(Get-Process -Name terminal64 -ErrorAction SilentlyContinue)).Count -gt 0){ throw 'MT5 risulta APERTO su questo PC. Chiudilo A MANO (terminale del PC di backtest, conto 50503392) e rilancia: col terminale aperto il tester non parte e escono ZERO CSV.' }; $W=Join-Path $env:USERPROFILE 'abtg_round'; New-Item -ItemType Directory -Force -Path $W | Out-Null; $S=Join-Path $W 'RIGA_ROUND_VPS.ps1'; Remove-Item -LiteralPath $S -Force -ErrorAction SilentlyContinue; irm ('https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $PIN + '/backtest_pipeline/righe/RIGA_ROUND_VPS.ps1?cb=' + [Guid]::NewGuid().ToString('N')) -OutFile $S; if(-not (Select-String -LiteralPath $S -SimpleMatch -Pattern 'MARCATORE_RIGA_ROUND_VPS_v2' -Quiet)){ throw 'RIGA_ROUND_VPS.ps1 scaricata SENZA il marcatore v2: copia vecchia o cache di GitHub. Non si parte.' }; Write-Host ('pc  : ' + $env:COMPUTERNAME) -ForegroundColor Green; Write-Host ('pin : ' + $PIN) -ForegroundColor Green; Write-Host ('data: ' + $T0.ToString('yyyy-MM-dd HH:mm:ss')) -ForegroundColor Green; $ErrorActionPreference='Continue'; $J=@(@{e='ABTG_IntradayMomentum';p='R235a_lato_MIM_NASUSD_short.txt';t='R235a';m=4},@{e='ABTG_IntradayMomentum';p='R235b_lato_MIM_NASUSD_long.txt';t='R235b';m=4},@{e='ABTG_IntradayMomentum';p='R235c_lato_MIM_U30USD_short.txt';t='R235c';m=4},@{e='ABTG_IntradayMomentum';p='R235d_lato_MIM_U30USD_long.txt';t='R235d';m=4},@{e='ABTG_EMA200';p='R234a_tf_EMA200SHORT_U30USD.txt';t='R234a';m=4},@{e='ABTG_EMA200';p='R234b_tf_EMA200SHORT_D30EUR.txt';t='R234b';m=4},@{e='ABTG_EMA200';p='R234c_tf_EMA200SHORT_NASUSD.txt';t='R234c';m=4},@{e='ABTG_SupertrendReversal';p='R236a_slbuffer_SUPREV_NASUSD_short.txt';t='R236a';m=4},@{e='ABTG_SupertrendReversal';p='R236b_slbuffer_SUPREV_NASUSD_long.txt';t='R236b';m=4},@{e='ABTG_SupertrendReversal';p='R236c_sllookback_SUPREV_NASUSD_short_OHLC.txt';t='R236c';m=1},@{e='ABTG_SupertrendReversal';p='R236d_sllookback_SUPREV_NASUSD_long_OHLC.txt';t='R236d';m=1},@{e='ABTG_SupertrendReversal';p='R236e_finestraoraria_SUPREV_NASUSD_short_OHLC.txt';t='R236e';m=1},@{e='ABTG_SupertrendReversal';p='R236f_finestraoraria_SUPREV_NASUSD_long_OHLC.txt';t='R236f';m=1}); $esiti=New-Object System.Collections.ArrayList; foreach($x in $J){ $E=$x.e; $P=$x.p; $L=$x.t; $M=$x.m; $att=0; while((@(Get-Process -Name terminal64 -ErrorAction SilentlyContinue)).Count -gt 0 -and $att -lt 36){ Start-Sleep -Seconds 5; $att=$att+1 }; Write-Host ''; Write-Host ('=== ' + $L + '   ' + $E + '   ' + $P + '   modello ' + $M + '   deposito 100000 ===') -ForegroundColor Cyan; & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $S -Expert $E -Prova $P -Etichetta $L -Pin $PIN -Modello $M -Deposito 100000; [void]$esiti.Add(($L.PadRight(7) + ' modello ' + $M + '   rc ' + $LASTEXITCODE)) }; $dsk=[Environment]::GetFolderPath('Desktop'); $out=Join-Path $dsk 'ROUND_PRONTI_2026-09-23'; if(Test-Path -LiteralPath $out){ Remove-Item -LiteralPath $out -Recurse -Force -ErrorAction SilentlyContinue }; New-Item -ItemType Directory -Force -Path $out | Out-Null; foreach($x in $J){ $src=Join-Path $dsk ('ROUND_' + $x.t); if(Test-Path -LiteralPath $src){ Copy-Item -LiteralPath $src -Destination $out -Recurse -Force -ErrorAction SilentlyContinue } }; $lg=Join-Path $out 'LOG_TESTER'; New-Item -ItemType Directory -Force -Path $lg | Out-Null; $nl=0; foreach($f in @(Get-ChildItem -Path (Join-Path $env:APPDATA 'MetaQuotes') -Recurse -Filter '*.log' -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $T0 } | Select-Object -First 400)){ Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $lg (([string]$nl).PadLeft(4,'0') + '_' + $f.Directory.Name + '_' + $f.Name)) -Force -ErrorAction SilentlyContinue; $nl=$nl+1 }; $ri=New-Object System.Collections.ArrayList; [void]$ri.Add('RIEPILOGO ROUND PRONTI -- R235 (4 file) + R234 (3 file) + R236 (6 file)'); [void]$ri.Add('data: ' + $T0.ToString('yyyy-MM-dd HH:mm:ss') + '   <-- SE QUESTA DATA NON E DI OGGI, IL FILE E VECCHIO'); [void]$ri.Add('fine: ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + '   durata minuti: ' + [int](((Get-Date)-$T0).TotalMinutes)); [void]$ri.Add('pc  : ' + $env:COMPUTERNAME + '   (PC di backtest; VPS VMI3047753 NON toccato)'); [void]$ri.Add('pin : ' + $PIN); [void]$ri.Add(''); foreach($z in $esiti){ [void]$ri.Add($z) }; [void]$ri.Add(''); [void]$ri.Add('rc 0 = ROUND GIRATO | 2 = NON MISURATO | 3 = GIRATO CON RILIEVI | 1 = non e partito'); [void]$ri.Add('FASE 1 (test singolo Optimization=0) di R236a/b: NON lanciata da questa riga.'); [void]$ri.Add('walkforward_generico.ps1 scrive sempre Optimization=1 (r.1015 e r.2013) e in'); [void]$ri.Add('ottimizzazione Print() non viene eseguito: il Giornale non contiene le righe'); [void]$ri.Add('mercato ... @ entry SL tp. Quindi nessun verdetto sul 40x da questa corsa.'); ($ri -join "`r`n") | Set-Content -LiteralPath (Join-Path $out 'RIEPILOGO_ROUND_PRONTI.txt') -Encoding ASCII; $zip=Join-Path $dsk 'ROUND_PRONTI_2026-09-23.zip'; if(Test-Path -LiteralPath $zip){ Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue }; Compress-Archive -Path (Join-Path $out '*') -DestinationPath $zip -Force; Write-Host ''; Write-Host ('RACCOLTA: ' + $out); Write-Host ('ZIP PRONTO DA MANDARE: ' + $zip) -ForegroundColor Green; Write-Host 'FILE ATTESI NELLO ZIP:' -ForegroundColor Gray; foreach($x in $J){ Write-Host ('   ROUND_' + $x.t + '\ = REFERTO_ROUND_' + $x.t + '.txt + CSV IS + CSV OOS + ' + $x.p) -ForegroundColor Gray }; Write-Host '   RIEPILOGO_ROUND_PRONTI.txt' -ForegroundColor Gray; Write-Host ('   LOG_TESTER\ = ' + $nl + ' file .log del tester (servono se un round esce NON MISURATO)') -ForegroundColor Gray; Get-ChildItem -LiteralPath $out | Select-Object Name,LastWriteTime | Format-Table -AutoSize | Out-Host; Write-Host 'ESITI:' -ForegroundColor Cyan; foreach($z in $esiti){ Write-Host ('   ' + $z) }; Write-Host ('durata totale minuti: ' + [int](((Get-Date)-$T0).TotalMinutes)) -ForegroundColor Cyan }
```

---

## 🎯 COSA LANCIA, IN QUEST'ORDINE

| # | etichetta | file prova | EA | modello | celle | passate |
|---|-----------|-----------|----|---------|-------|---------|
| 1 | `R235a` | `R235a_lato_MIM_NASUSD_short.txt` | `ABTG_IntradayMomentum` | **4 tick reali** | 2 | 4 |
| 2 | `R235b` | `R235b_lato_MIM_NASUSD_long.txt` | `ABTG_IntradayMomentum` | **4 tick reali** | 2 | 4 |
| 3 | `R235c` | `R235c_lato_MIM_U30USD_short.txt` | `ABTG_IntradayMomentum` | **4 tick reali** | 2 | 4 |
| 4 | `R235d` | `R235d_lato_MIM_U30USD_long.txt` | `ABTG_IntradayMomentum` | **4 tick reali** | 2 | 4 |
| 5 | `R234a` | `R234a_tf_EMA200SHORT_U30USD.txt` | `ABTG_EMA200` | **4 tick reali** | 5 | 10 |
| 6 | `R234b` | `R234b_tf_EMA200SHORT_D30EUR.txt` | `ABTG_EMA200` | **4 tick reali** | 5 | 10 |
| 7 | `R234c` | `R234c_tf_EMA200SHORT_NASUSD.txt` | `ABTG_EMA200` | **4 tick reali** | 5 | 10 |
| 8 | `R236a` | `R236a_slbuffer_SUPREV_NASUSD_short.txt` | `ABTG_SupertrendReversal` | **4 tick reali** | 5 | 10 |
| 9 | `R236b` | `R236b_slbuffer_SUPREV_NASUSD_long.txt` | `ABTG_SupertrendReversal` | **4 tick reali** | 5 | 10 |
| 10 | `R236c` | `R236c_sllookback_SUPREV_NASUSD_short_OHLC.txt` | `ABTG_SupertrendReversal` | **1 OHLC** | 5 | 10 |
| 11 | `R236d` | `R236d_sllookback_SUPREV_NASUSD_long_OHLC.txt` | `ABTG_SupertrendReversal` | **1 OHLC** | 5 | 10 |
| 12 | `R236e` | `R236e_finestraoraria_SUPREV_NASUSD_short_OHLC.txt` | `ABTG_SupertrendReversal` | **1 OHLC** | 2 | 4 |
| 13 | `R236f` | `R236f_finestraoraria_SUPREV_NASUSD_long_OHLC.txt` | `ABTG_SupertrendReversal` | **1 OHLC** | 2 | 4 |
| | | | | | **47** | **94** |

✅ **I due modelli diversi di R236 NON hanno richiesto di spezzare la corsa.**
`-Modello` e' un parametro **per invocazione**, non per sessione: la stringa lo passa
riga per riga (4 per R236a/b, 1 per R236c/d/e/f). Nessuna invocazione separata serve.

🟢 **Tutti e 13 i file partono con `-Deposito 100000`.** E' obbligatorio e nessun file
puo' imporlo da solo: `walkforward_generico.ps1` non ha nessuna direttiva `@DEPOSITO`
e il suo default e' **10000** (r.200), come quello di `RIGA_ROUND_VPS.ps1` (r.152).
Con 10000 `MathFloor` taglia il lotto e i DD non si confrontano piu' con niente.

🟢 **Nessuna `-FrazioneIS` viene passata.** Tutti e 13 i file dichiarano
`@FRAZIONEIS 0.40` dentro: passarla dalla riga la sovrascriverebbe e spezzerebbe le
finestre IS/OOS in un punto diverso da quello congelato.

🟢 **Le ore sono in ORA SERVER**, controllate: Nasdaq `InpSignalStartHour=14` +
`InpSignalStartMin=30` (= 15:30 italiane), finestra R236e/f `InpStartHour=14`.

---

## 🔴 LA FASE 1 DI R236a/R236b: LA RISPOSTA SECCA E' **NO**

I file `R236a` e `R236b` prescrivono in fondo una **FASE 1 — TEST SINGOLO**
obbligatoria (`Optimization=0`, `ShutdownTerminal=1`, asse fissato alla cella 1) da
cui leggere nel **Giornale** le righe `mercato ... @ <entry> SL <sl> TP <tp>`
(r.422-423 dell'EA) e ricavare la **base dello stop** per il cancello T7 (il 40x).

**Questa riga NON la lancia, e nessuno strumento del repo oggi sa lanciarla.**
Tre fatti misurati, non impressioni:

1. 🔒 `walkforward_generico.ps1` scrive **`Optimization=1` cablato** in tutte e due
   le schede `.ini` che genera — **r.1015** (gamba IS) e **r.2013** (gamba OOS). Non
   esiste nessun parametro che lo cambi.
2. 🔒 `RIGA_ROUND_VPS.ps1` non ha nessuna opzione di test singolo. I suoi soli
   parametri, r.148-158, sono dieci e li elenco senza trattino apposta:
   Expert, Prova, Etichetta, Pin, TerminaleBacktest, Modello, Deposito, Work,
   ChiudiBacktest, SoloControllo. Nessuno di loro spegne l'ottimizzazione.
3. 🔒 **E anche volendo non servirebbe a niente**: la diagnostica di quell'EA esce da
   `Print()`, e **`Print()` non viene eseguito in ottimizzazione**. Un file prova
   *e'* un'ottimizzazione. Lo dice il file stesso, che si e' gia' corretto su questo.

### 📦 E i Giornali? Il driver **non ne salvava nessuno**

`RIGA_ROUND_VPS.ps1` r.1231-1239: la raccolta copia **solo** i due CSV, il file prova
e il referto. **Zero `.log`.** Eppure lo stesso script, quando l'esito e' NON
MISURATO, stampa *"guardare il log"* (r.1273-1275) — e nello zip che arriva a Claudio
il log non c'e'. Chiedere una diagnosi e non spedire l'unico artefatto che la
permette e' un giro a vuoto garantito.

🛠️ **Riparato NELLA RIGA, non nello script** (cosi' non tocco un file gia' pinnato da
altre catene): l'ultimo blocco copia in `LOG_TESTER\` tutti i `.log` scritti **dopo**
l'avvio della corsa sotto `%APPDATA%\MetaQuotes` e li mette nello zip.
⚠️ **Servono a capire un `Trades=0`, NON a fare la FASE 1**: per il punto 3 qui sopra,
in ottimizzazione quelle righe non esistono proprio.

### 👉 Quindi cosa facciamo con R236a/b

**Li lanciamo lo stesso, e dichiariamo cosa non diranno.** Le celle sono gia' pinnate
a valori assoluti (3 / 653 / 1303 / 1953 / 2603 pip): la corsa e' eseguibile e
risponde alla domanda di **SOPRAVVIVENZA** (il motore regge lo stop allargato?), che
e' la domanda principale del file. **Non** risponde al cancello **T7 sul 40x**, che
resta **sospeso** finche' qualcuno non scrive lo strumento per la FASE 1.
La riga lo scrive da sola dentro `RIEPILOGO_ROUND_PRONTI.txt`, cosi' non si perde.

---

## ⏱️ QUANTO TEMPO MACCHINA

| pezzo | passate | stima | fonte |
|---|---|---|---|
| R235 (4 file, tick reali) | 16 | **4-9 minuti** | ✅ **MISURATO** — R98 0,56 min/passata + formula R141b |
| R234 (3 file, tick reali) | 30 | 2,3-17 minuti | ⚠️ estrapolato dalle stesse due fonti, **altro motore** |
| R236a/b (2 file, tick reali) | 20 | 1,5-11 minuti | ⚠️ estrapolato — il file dichiara **`[NON MISURATO]`** |
| R236c/d/e/f (4 file, OHLC) | 28 | 1,2-16 minuti | ⚠️ estrapolato **al rialzo**: l'OHLC e' molto piu' veloce del tick, di quanto **`[NON MISURATO]`** |
| sovraccarico: 13 scarichi + **13 compilazioni** + 26 avvii di MT5 | — | **`[NON MISURATO]`** | nessun numero in casa |

### 🎯 La banda che dichiaro: **25-80 MINUTI**
- Il limite basso e' la formula `T = 0,6 + 0,077 x passate` applicata file per file
  (~15 minuti) **piu'** un sovraccarico minimo di compilazione.
- Il limite alto e' il tasso misurato 0,56 min/passata applicato a tutte le 94
  passate (~53 minuti) **piu'** il sovraccarico.
- 🔴 **L'unico pezzo MISURATO sono i 4-9 minuti di R235.** Il minutaggio per passata
  di `ABTG_EMA200` e di `ABTG_SupertrendReversal` a tick reali su questa finestra e'
  **`[NON MISURATO]`**, e non lo invento.
- ✅ Buona notizia: **R235, il round pronto e col PASS gia' in tasca, e' anche il piu'
  economico** — i primi 4-9 minuti ti danno gia' un risultato leggibile.

---

## 📦 COSA TORNA INDIETRO, E QUALE DATA GUARDARE

Sul **Desktop del PC di backtest**:
- 📁 `ROUND_PRONTI_2026-09-23\` — dentro, le 13 cartelle `ROUND_R235a\` ...
  `ROUND_R236f\` (ognuna con `REFERTO_ROUND_<et>.txt`, il CSV **IS**, il CSV **OOS**
  e il file prova usato), piu' `RIEPILOGO_ROUND_PRONTI.txt` e `LOG_TESTER\`;
- 🗜️ **`ROUND_PRONTI_2026-09-23.zip` — e' questo che mi mandi.**
- 📁 restano anche i 13 zip singoli `ROUND_R235a.zip` ... che scrive il driver: se lo
  zip grande non si aprisse, mandane anche uno solo, basta quello.

### 🗓️ LA DATA DA LEGGERE PER SAPERE SE IL FILE E' NUOVO
Apri `RIEPILOGO_ROUND_PRONTI.txt` e guarda la **prima riga `data:`**:
deve dire **`2026-09-23`** con l'ora di quando hai lanciato.
**Se quella data non e' di oggi, stai guardando un file vecchio** — e' successo il
17/08, due volte, in perfetta buona fede. Stessa regola dentro ogni
`REFERTO_ROUND_<et>.txt`, che ha la sua riga `data:`.

### 🧾 Come si legge l'esito, senza aprire i CSV
In fondo alla console (e dentro il riepilogo) c'e' una riga per round:

```
R235a   modello 4   rc 0
```

- **rc 0** = 🟢 ROUND GIRATO (i due CSV ci sono, freschi, con Trades > 0)
- **rc 3** = 🟠 GIRATO CON RILIEVI (i numeri ci sono, qualcosa va guardato)
- **rc 2** = 🔴 NON MISURATO (CSV assente/vuoto, oppure Trades = 0)
- **rc 1** = 🔴 non e' nemmeno partito (un pre-volo l'ha fermato)

🔴 **`Trades = 0` NON vuol dire "nessun edge": vuol dire NON E' GIRATA.** In quel caso
la risposta sta nei `.log` dentro `LOG_TESTER\` — che adesso nello zip ci sono.
🟢 **E lo zip si manda LO STESSO anche a rc 2**: "non e' girata" e' gia' una risposta.

---

## 🛡️ COSA HO CONTROLLATO PRIMA DI SCRIVERLA

| controllo | esito |
|---|---|
| `python3 backtest_pipeline/controlla_riga.py --riga` | 🟢 **6 passati, 0 bloccanti, 0 rilievi** |
| parse reale della riga con `pwsh` (`Parser::ParseInput`) | 🟢 **0 errori**, 1095 token |
| `controlla_prova.py` sui 13 file | 🟢 **13 OK, 0 problemi**, 47 celle / 94 passate |
| i 13 file esistono a `origin/lavoro` con quei nomi esatti | 🟢 `git ls-tree` |
| la riga e' **UNA SOLA riga fisica** in `& { ... }` | 🟢 1 riga, 6380 byte |
| **ASCII puro** (riga e i due `.ps1` che tocca) | 🟢 0 byte oltre 127 |
| formati `.NET` con sintassi Python (`{0,<6}`) | 🟢 nessuno — uso `PadRight`, non `-f` |
| cultura invariante | 🟢 nessun parse/format di decimali nella riga; il driver usa gia' `InvariantCulture` |
| **cache di GitHub raw** (il commit ha 3 minuti) | 🟢 pin all'**hash** `c3ac4ada...` + `?cb=<guid>` + controllo del marcatore `MARCATORE_RIGA_ROUND_VPS_v2` |
| tutto pushato su `origin/lavoro` | 🟢 `HEAD == origin/lavoro == c3ac4ada` |
| **guardia MT5 aperto** | 🟢 la riga rifiuta di partire, e il documento te lo dice in testa |
| parametri che non sopravvivono a `-File` | 🟢 nessuna stringa vuota passata |
| euristiche del silenzio ("60s senza output = finito") | 🟢 nessuna: si aspetta il **processo**, non il silenzio |
| ora server (BCM = italiana - 1) | 🟢 `14`/`14:30` per il Nasdaq nei file, corretto |
| `InpTP1_ATRmult` (trappola PTE) | 🟢 non pertinente: nessuno di questi tre EA e' della famiglia PTE — `0.0` e' il default sorgente di `ABTG_EMA200` in **tutte** le sue prove d'archivio |

---

## 🧭 E IL PROSSIMO PASSO, DETTO ADESSO

Quando lo zip torna: si leggono i referti, si scrivono i verdetti **coi criteri
congelati prima del round** (nessuno di questi referti giudica: dicono cosa e'
uscito), e si apre il buco che resta aperto — **lo strumento per la FASE 1**, senza
il quale il cancello T7 di R236a/b non si pronuncia. E' un lavoro breve e va in coda
subito dopo, perche' un prerequisito che nessuno sa eseguire e' un prerequisito che
non verra' mai fatto.

🔥 **Intanto le 94 passate sono in macchina. Non ci accontentiamo.**
