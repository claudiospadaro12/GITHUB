# 🔓 SBLOCCARE I VENTI — e sì, basta una direttiva di testo

**12/09/2026** · agente `NOME` · branch `lavoro`
**Missione**: venti file prova passano il cancello e non sono lanciabili dalla
corsia firmata. La domanda era: *il driver può leggere la frazione IS/OOS da una
direttiva nel file prova, come fa per la finestra?*

## 📄 DUE AVVERTENZE SU QUESTO DOCUMENTO, PRIMA DI TUTTO
1. 🚫 **Qui dentro NON c'e' NESSUNA riga di lancio.** Niente da mandare a Claudio,
   niente da incollare sul VPS, nessun terminale MT5 da aprire. Tutti i blocchi
   recintati sono **`console`** (trascrizioni di comandi che ho lanciato IO su
   questa macchina Linux, con la loro uscita) o **`text`** (citazioni di sorgente
   che sta GIA' nel repo). Sono etichettati cosi' di proposito: il cancello
   `controlla_riga.py` valuta i blocchi `powershell` come righe di lancio, e
   applicargli la classe 173 a una **citazione** di codice esistente misurerebbe
   la cosa sbagliata. 🔴 **Lo dichiaro invece di farlo in silenzio**: se un
   giorno da questo documento nascera' una riga di lancio, quella va in un
   blocco `powershell` e passa dal cancello come tutte.
2. 🔴 **Il driver NON e' stato toccato.** La toppa del paragrafo 6 vive in una
   COPIA nello scratchpad. `walkforward_generico.ps1` in repo e' intatto.

## 🟢 LA RISPOSTA IN UNA RIGA
**SÌ, si può, costa 78 righe di driver + 20 righe di testo, e NON allarga la
corsia firmata.** Ma lo schema da copiare è quello di **`@FINOA`**, non quello di
`@SIMBOLO` — e questa non è una preferenza di stile: **lo schema di `@SIMBOLO`,
su questo parametro, NON FUNZIONA, e fallisce IN SILENZIO.** L'ho misurato con
PowerShell vero, sta nel contro-esempio più sotto.

---

# 1️⃣ IL RICONTEGGIO — sono venti, e la ragione c'è in tutti e venti

🔴 **Non ho ereditato il numero: l'ho ricontato.** `grep -l "FrazioneIS 0.50"` su
`backtest_pipeline/prove/*.txt` → **20 file**, elencati qui sotto. Confermato.

## ✏️ MA UNA COSA DEL MANDATO ERA SBAGLIATA, E VA DETTA
La missione diceva: *"Tutti scrivono in testa `-FrazioneIS 0.50 NON E'
OPZIONALE`"*. **Falso: quella stringa letterale è in 6 file su 20.** Misurato:

```console
grep -l "FrazioneIS 0.50 NON E' OPZIONALE"  ->  6
```

I 14 senza la formula sono `R128c/d/e`, `R129a/b/c`, `R131a..h`.
🟢 **Ma la SOSTANZA c'è in tutti e venti**: ognuno porta la ragione scritta, solo
in forma diversa. Il difetto era nella mia descrizione della popolazione, non
nella popolazione. (È la settima volta oggi che questo tipo di errore paga: la
definizione dell'insieme si elenca per nome — classe 180.)

## 📋 I VENTI, CON LA RAGIONE SCRITTA DI CIASCUNO

| # | file prova | dove sta la ragione del 50/50 | forma |
|---|---|---|---|
| 1 | `R128b_bersaglio_D30EUR.txt` | r.20-21 + sezione **IL CAMPIONE** r.89-108 | 🟢 **RADICE: il conto per esteso** |
| 2 | `R128c_trailingfisso_D30EUR.txt` | r.22 *"come R128b/d/e (vedi IL CAMPIONE in R128b)"* | 🟢 rinvio esplicito |
| 3 | `R128d_controllo_trailing_D30EUR.txt` | r.21 *"come R128b/c/e"* | 🟢 rinvio esplicito |
| 4 | `R128e_orologio_D30EUR.txt` | r.21 *"come R128b/c/d"* | 🟢 rinvio esplicito |
| 5 | `R129a_costo_alza_D30EUR.txt` | r.21 *"come R128b/c/d/e: 325 ingressi sull'intera"* | 🟢 rinvio **col numero** |
| 6 | `R129b_costo_salta_D30EUR.txt` | r.20 + r.49 *"con 325 ingressi e FrazioneIS 0.50 l'IS parte da ~163"* | 🟢 rinvio **col numero** |
| 7 | `R129c_costo_interruttore_D30EUR.txt` | r.21 *"identica a R129a e R129b"* | 🟢 rinvio esplicito |
| 8 | `R130a_interruttore_default_D30EUR.txt` | r.20-21 + **IL CAMPIONE** r.109-117 | 🟢 conto ripetuto in loco |
| 9 | `R130b_interruttore_pulito_D30EUR.txt` | r.20-21 + r.109-117 | 🟢 conto ripetuto in loco |
| 10 | `R130c_passo_D30EUR.txt` | r.20-21 + r.109-117 | 🟢 conto ripetuto in loco |
| 11 | `R130d_distanzaminima_D30EUR.txt` | r.20-21 + r.109-117 | 🟢 conto ripetuto in loco |
| 12 | `R130e_placebo_passo_D30EUR.txt` | r.20-21 + r.109-117 | 🟢 conto ripetuto in loco |
| 13-20 | `R131a..h` (supertrend/ema × H1/H4/D1/W1) | r.132-135 *"PERCHE' QUESTA SEDIA… -FrazioneIS 0.50 → IS ~163 / OOS ~162. SOPRA 150 TUTTE E DUE."* | 🟢 conto in loco |

### 🎯 VERDETTO: **20 su 20 hanno una ragione scritta. NESSUNO va corretto.**
Nessuno dei venti chiede 0.50 "per copia da un antenato": tutti e venti
convergono su **UNA misura sola**.

## 🧮 E LA RADICE L'HO VERIFICATA, NON CREDUTA
La ragione di tutti e venti sta in `backtest_pipeline/prove/R128_USCITA_CRITERI.md`
r.236-271, che è un file di **criteri congelati PRIMA dei numeri** e che chiude
con *"Regola del round, congelata qui"*: **R128a a 0.40, R128b/c/d/e a 0.50.**

La catena è: R120 (09/09, tick reali) misura **325 `Trades` in tutte e quattro le
strutture d'uscita col parziale spento** → 325 sono gli INGRESSI (invariante per
costruzione: `InpOneTradePerDay` + `InpCloseAtEnd` fissano gli ingressi, l'uscita
non li tocca; col parziale al 50% le stesse quattro danno 476/524/445/330, e
445−325 = **120 parziali**).

**Il conto rifatto da me, da zero, in Python:**

| | giorni | feriali | ingressi attesi |
|---|---:|---:|---:|
| finestra piena `2024.09.26 → 2026.06.30` | 642 | **459** | 325 → **0,7081 / feriale** |
| **a 0.40** — IS `…→2025.06.09` | 256 | **183** | **~130** 🔴 *sotto il pavimento 150* |
| **a 0.40** — OOS `2025.06.10→…` | | 276 | ~195 |
| **a 0.50** — IS `…→2025.08.13` | 321 | **230** | **~163** 🟢 |
| **a 0.50** — OOS `2025.08.14→…` | | 229 | **~162** 🟢 |

✅ **Combacia al giorno e all'unità con quanto R128b dichiarava** (*"230 feriali
~163 ingressi / 229 feriali ~162"*). La radice regge: **l'Emendamento A (≥150
operazioni in IS) è rispettato a 0.50 e VIOLATO a 0.40.**

⚠️ **E dico anche il punto debole, perché è uno:** venti round poggiano su **una
sola** misura (i 325 di R120). Il margine è **+8%** sul pavimento, dichiarato
sottile già in R128b. Se quei 325 fossero sbagliati, cadono tutti e venti
insieme. Non è un motivo per non lanciare — è un motivo per non arrotondare mai
quel numero.

## 🚦 IL CANCELLO MECCANICO SUI VENTI — DA SOLO, SENZA PIPE (classe 254)

```console
python3 backtest_pipeline/controlla_prova.py <primi 10>   ->  EXIT = 0
   file: 10 | celle totali: 87 | passate: 174 | problemi: 0   ESITO: OK
python3 backtest_pipeline/controlla_prova.py <secondi 10>  ->  EXIT = 0
   file: 10 | celle totali: 31 | passate:  62 | problemi: 0   ESITO: OK
```
**Totale: 118 celle, 236 passate.** Tutti e venti su `ABTG_DAX_Apertura_EU`,
`D30EUR`, `M5`, `@DAQUANDO 2024.09.26`, **nessuno ha `@FINOA`** (quindi il
default `-Fino 2026.06.30` del driver è quello che i venti dichiarano in testa:
nessuna collisione di data). EA a un commit **non-WIP**: `9638318`.

---

# 2️⃣ COME IL DRIVER CONSUMA LE DIRETTIVE — le righe in mano

File: **`backtest_pipeline/walkforward_generico.ps1`** (1578 righe).

### Il blocco che legge il file prova — r.479-491
```text
$Direttive=@{}
$RigheProvaUtili=New-Object System.Collections.ArrayList
foreach($r in $righeProva){
  $t=$r.Trim()
  if($t -eq "" ){ continue }
  if($t.StartsWith("#")){ continue }
  if($t.StartsWith("@")){
    if($t -match '^@(\w+)\s+(.+)$'){ $Direttive[$Matches[1].ToUpper()]=$Matches[2].Trim() }
    continue
  }
  if($t -match "="){ [void]$RigheProvaUtili.Add($t) }
}
```
👉 **Il parser è GENERICO**: qualunque `@NOME valore` finisce in `$Direttive`.
Aggiungere una direttiva **non richiede di toccare il parser**.

### I tre consumi "semplici" — r.493-495
```text
if(-not $Simbolo  -and $Direttive.ContainsKey("SIMBOLO")){  $Simbolo =$Direttive["SIMBOLO"] }
if(-not $Periodo  -and $Direttive.ContainsKey("PERIODO")){  $Periodo =$Direttive["PERIODO"] }
if(-not $DaQuando -and $Direttive.ContainsKey("DAQUANDO")){ $DaQuando=$Direttive["DAQUANDO"] }
```
Schema: *"se la riga non l'ha passato, prendilo dal file"*. Funziona perché i tre
sono **`[string]` con default `""`**.

### Il consumo "con guardia" — `@FINOA`, r.498-573
```text
if($Direttive.ContainsKey("FINOA")){
  $finoDaFile = $Direttive["FINOA"]
  if($finoDaFile -notmatch '^[0-9]{4}\.[0-9]{2}\.[0-9]{2}$'){ Muori (...) }
  if($PSBoundParameters.ContainsKey("Fino")){          # <<< LA CHIAVE
    if($Fino -ne $finoDaFile){
      if($FinoDallaRiga){ ...riquadro magenta... } else { Muori ("DUE DATE DI FINE, DIVERSE, E NON SCELGO IO...") }
    }
  } else { $Fino = $finoDaFile; Write-Host ("    finestra di fine presa da '@FINOA'...") }
}
```
E dove si usa la frazione — **r.758, una riga sola**:
```text
$Meta=$Inizio.AddDays([math]::Floor(($FineDt-$Inizio).TotalDays*$FrazioneIS))
```

## 2️⃣.b ESISTE GIÀ UN `@FRAZIONEIS`? **NO.**
```console
grep -rni "frazione" (tutto il repo, escluso report/)  ->  nessun '@FRAZIONEIS'
```
`FrazioneIS` esiste **solo** come parametro da riga di comando: r.171 del driver
(`[double]$FrazioneIS = 0.40`) e in **35 script dedicati** che lo passano
esplicitamente. **Nessuna direttiva, nessun nome simile, niente di inutilizzato.**

---

# 3️⃣ 🔴 IL CONTRO-ESEMPIO — e ha trovato una trappola che NON avevo previsto

La missione chiedeva il caso in cui la collisione produce una misura sbagliata in
silenzio. **Ne ho trovati DUE, e il primo è il più cattivo, perché è la trappola
in cui cade chi copia lo schema "ovvio".**

## 💀 TRAPPOLA 1 — lo schema di `@SIMBOLO` copiato per analogia IGNORA la direttiva, in silenzio
Copiare la riga r.493 sostituendo il nome sembra la cosa naturale:
```text
if(-not $FrazioneIS -and $Direttive.ContainsKey("FRAZIONEIS")){ $FrazioneIS = [double]$Direttive["FRAZIONEIS"] }
```
🔴 **In PowerShell `(-not 0.40)` vale `False`.** Un `[double]` con default 0.40 è
sempre "vero", quindi la condizione è **sempre falsa** e la direttiva **non viene
MAI letta**. Risultato: i venti file girerebbero a **0.40**, cioè **esattamente il
guasto che la direttiva doveva riparare**, travestito da riparazione — e senza
**una riga** di avviso a schermo.
🔴 **E peggio: `(-not 0.0)` vale `True`.** Con `-FrazioneIS 0` la logica si
**inverte** e la direttiva scatta proprio dove non deve.

**MISURATO con PowerShell vero, non ragionato:**
```console
schema @SIMBOLO   -> FrazioneIS usata = 0.4     <-- DIRETTIVA IGNORATA
  (-not 0.40) vale : False
  (-not 0.0)  vale : True
schema @FINOA     -> FrazioneIS usata = 0.5     <-- CORRETTO
```
👉 **Per questo la guardia guarda `$PSBoundParameters`, che risponde a
"l'argomento è stato PASSATO?", non a "il suo valore è VERO?".**

## 💀 TRAPPOLA 2 — "vince il file" farebbe mentire il referto di 35 script
**35 script dedicati passano `-FrazioneIS` SEMPRE ed esplicitamente.** Due lo
passano a **1.0** (una sola tranche, gamba OOS degenere):
`RIGA_NYRETEST_TAR.ps1` r.307 e `RIGA_SONDALONDONFX.ps1` r.604.

Quei due **scrivono nel proprio referto**:
> `"finestra: … (tick BCM, UNA TRANCHE, FrazioneIS 1.0)"`
> `"NOTA: il CSV *_OOS NON esiste MAI qui (FrazioneIS 1.0 = gamba OOS degenere)."`

**Lo scenario silenzioso**: se un giorno un loro file prova prendesse
`@FRAZIONEIS 0.50` e la regola fosse "vince il file", il driver girerebbe un
walk-forward **50/50** mentre il referto continua a dichiarare **1.0** e a dire
che l'OOS non esiste. Uscirebbero dei CSV `*_OOS` che lo script qualifica come
*"reperti da non leggere"* — **e invece sarebbero l'unico numero vero.**
**Referto e numeri direbbero due cose diverse, e nessuno lo vedrebbe.**

### 🛡️ LA GUARDIA LO IMPEDISCE — le tre prove, eseguite
| caso | chi | esito | exit |
|---|---|---|---|
| **1** nessun `-FrazioneIS`, file dice `0.50` | 🪑 **la corsia sottile** | `taglio IS/OOS preso da '@FRAZIONEIS': 0.5` → **IS 2024.09.26-2025.08.13 · OOS 2025.08.14-2026.06.30** | **0** |
| **2** `-FrazioneIS 0.40`, file dice `0.50` | i 35 script | 🔴 **`MORTO: DUE TAGLI IS/OOS, DIVERSI, E NON SCELGO IO.`** | **9** |
| **3** `-FrazioneIS 0.40 -FrazioneDallaRiga`, file `0.50` | divergenza dichiarata | riquadro magenta + gira a 0.40 → **IS …-2025.06.09** (finestra DIVERSA, e lo dice) | 0 |
| **4** `-FrazioneIS 0.50`, file `0.50` | accordo | passa muto, come deve | 0 |

🟢 **E la prova che chiude il cerchio: nel caso 1 le due finestre che escono sono
`2024.09.26-2025.08.13` e `2025.08.14-2026.06.30` — IDENTICHE AL GIORNO a quelle
che R128b dichiarava mesi prima nella sezione IL CAMPIONE.** Non ho verificato
la mia formula contro sé stessa: l'ho verificata contro **numeri già scritti da
qualcun altro** (regola del 10/09).

### 🐛 E UN DIFETTO L'HO TROVATO NELLA MIA PROPRIA TOPPA
Prima versione: `@FRAZIONEIS 1.5` moriva con *"non è un numero decimale"* — **e
1.5 È un numero decimale**, è solo fuori campo. Messaggio falso = manda a cercare
il guasto dalla parte sbagliata. **Corretto**: ora il **formato** e il **campo**
danno messaggi diversi.
```console
@FRAZIONEIS 0,50  -> MORTO: non e' un numero decimale con il PUNTO   [exit 9]
@FRAZIONEIS 50%   -> MORTO: non e' un numero decimale con il PUNTO   [exit 9]
@FRAZIONEIS 1/2   -> MORTO: non e' un numero decimale con il PUNTO   [exit 9]
@FRAZIONEIS 1.5   -> MORTO: e' fuori campo: ammesso 0 < f <= 1       [exit 9]
@FRAZIONEIS 0     -> MORTO: e' fuori campo: ammesso 0 < f <= 1       [exit 9]
@FRAZIONEIS 1.0   -> OK (una sola tranche, e lo dichiara)            [exit 0]
```

---

# 4️⃣ 🔴 IL PERIMETRO — la domanda più importante

## 🟢 LA MIA LETTURA: **NON è un allargamento della corsia firmata.** Concordo con te, e aggiungo una prova che rende l'argomento più forte del "sono dati, non argomenti".

### Argomento 1 — la firma dell'11/09 elenca cosa il runner PUÒ FARE, e questo non è nell'elenco
`report/FIRME_2026-09-11.md` r.15-33. Autorizza: **eseguire il tester MT5 sul
solo terminale 50504400 (`C:\MT5_Backtest`), di notte, e raccoglierne i CSV.**
Vieta: gli altri tre conti, **"nessun EA, preset o parametro toccato"**, ordini e
posizioni, `Invoke-Expression`/`DownloadString`/`schtasks`.
Una direttiva che sposta un taglio IS/OOS **non tocca nessuna** di queste voci:
non cambia bersaglio, non tocca EA/preset/parametri **di una sedia**, non apre
verbi vietati, non scrive fuori dai CSV e dai referti.

### Argomento 2 — 🔑 **LA FIRMA STESSA DICE CHE I ROUND SI COMANDANO DAL FILE PROVA**
Testuale, nella colonna dei divieti (r.31):
> *"nessun EA, preset o parametro toccato. **I round leggono i file prova dal pin**
> e scrivono solo CSV e referti"*

👉 La firma **descrive già** il file prova come il canale attraverso cui il round
è comandato, e **come parte della cosa firmata**. Il file prova non è un
grimaldello aggiunto dopo: è il meccanismo che Claudio ha firmato.

### Argomento 3 — 🔑 **E QUESTA È LA PROVA CHE MANCAVA: la corsia ROUND non ha NESSUN altro canale**
`backtest_pipeline/righe/RIGA_ROUND_VPS.ps1` r.646-650, la chiamata vera al driver:
```text
$arg = @("-NoProfile","-ExecutionPolicy","Bypass","-File",$drv,
         "-Expert",$Expert,"-Prova",$provaLoc,
         "-Etichetta",$Etichetta,"-Modello",("" + $Modello),"-Deposito",("" + $Deposito),
         "-Rifai","-Force","-TerminaleBacktest",$cartellaBT)
```
🔴 **Non passa `-Simbolo`, non passa `-Periodo`, non passa `-DaQuando`, non passa
`-Fino`, non passa `-FrazioneIS`.**
Cioè: **su questa corsia le direttive del file prova sono l'UNICO canale
esistente per l'identità della finestra.** `@SIMBOLO`, `@PERIODO`, `@DAQUANDO`,
`@FINOA` non sono una comodità: sono **l'architettura della corsia**. E il taglio
IS/OOS è **l'ultimo pezzo di quell'identità che non ha una direttiva** — l'unico
buco in un meccanismo già firmato e già in uso.

👉 **Quindi `@FRAZIONEIS` non ALLARGA la corsia: COMPLETA un meccanismo che la
corsia ha già.** La lista bianca sugli argomenti di `RIGA_SOTTILE_ROUND.ps1`
(r.99-106 `param()`, r.150-155 `function Pulito`) **non viene toccata di una
virgola**: nessun argomento nuovo, nessun carattere nuovo ammesso, nessun
parametro che possa nominare un percorso.

### Argomento 4 — il rischio MARGINALE è negativo, non positivo
La direttiva **aggiunge una morte** dove prima c'era un silenzio. Oggi, se una
riga passasse `-FrazioneIS 0.40` su un file che dichiara 0.50 nei criteri, la
corsa gira e **nessuno lo sa**. Con la guardia, **muore**. Un cancello in più, non
uno in meno.

## ⚠️ MA IL PERIMETRO HA UN COSTO CHE IL MANDATO NON AVEVA VISTO, E VA DETTO
🔴 **`RIGA_SOTTILE_ROUND.ps1` INCHIODA IL DRIVER AL BYTE.** r.244:
```text
$SHA_WALK  = '02E2FE8F90CCBD079E92A7A6C74B54D96C536982927BEC06AE68ECFB9ECF3FEA'
```
e r.362/383 fanno `Get-FileHash` sul file scaricato: **impronta diversa →
`Muori`, senza eseguire niente.**

**Verificato:**
```console
SHA del driver AL PIN fb9b4731 : 02E2FE8F...ECF3FEA   ==  $SHA_WALK    ✅ combacia
SHA del driver a HEAD (e86deb5): 62A53763...CBB7BC    !=  $SHA_WALK
git diff fb9b4731 HEAD -- walkforward_generico.ps1  ->  +16 righe
```
👉 **Toccare il driver OBBLIGA a ricalcolare `$SHA_WALK` e a spostare `$PIN`**, che
sono due righe **dentro `RIGA_SOTTILE_ROUND.ps1`** → **e quindi un giro di
cancello sulla corsia sottile.** Non è un allargamento di perimetro: **è un giro
di pin, la procedura di casa, già fatta NOVE volte oggi** (i commenti r.128-232
raccontano i nove giri).
🟢 **E il marcatore NON va cambiato**: la dottrina di casa (driver r.153-164) è
che i marcatori sono **additivi** — v3/v4/v5 restano perché le loro promesse
restano vere. `RIGA_SOTTILE_ROUND` cerca `MARCATORE_WALKFORWARD_GENERICO_v5_INCLUDE`,
che **resta nel file**: aggiungo solo un `v6_FRAZIONEIS` accanto.

📌 **NOTA DI SEQUENZA, importante**: il pin `fb9b4731` è **dietro** HEAD di 16
righe — cioè **la toppa classe 270 di oggi (l'`.ex5` stantio) NON è ancora nella
corsia.** Chi sposta il pin per `@FRAZIONEIS` **porta dentro anche quella**. È un
bene (è una riparazione), ma va **dichiarato** e non scoperto dopo.

## 🔄 AGGIORNAMENTO IN CORSA (mentre scrivevo, 12/09) — UN ALTRO AGENTE STA GIA' SPOSTANDO IL PIN
Nell'albero di lavoro ho trovato `RIGA_SOTTILE_ROUND.ps1` **modificato da un
altro agente adesso** (+63/-2): e' il **DECIMO GIRO**, che sposta `$PIN` da
`fb9b4731` a **`e6c0d70e`** e `$SHA_WALK` da `02E2FE8F...9ECF3FEA` a
**`62A53763...F7CBB7BC`** — cioe' **esattamente l'impronta di HEAD che avevo
misurato io**, per portare dentro la toppa classe 270.

🟢 **Conferma indipendente**: due agenti, separatamente, hanno trovato lo stesso
scarto fra pin e HEAD. Il difetto era reale.
🔴 **E CAMBIA LA SEQUENZA del paragrafo 7**: il mio passo 4 **non parte da
`fb9b4731`**, parte da quello che lascia il decimo giro. `$SHA_WALK` va
ricalcolato **sul driver con la toppa 270 GIA' dentro PIU' `@FRAZIONEIS`** — un
solo ricalcolo, non due — e il pin va spostato **dopo** che il decimo giro e'
committato, altrimenti i due giri si sovrascrivono a vicenda. **Non ho toccato
quel file**: e' di un altro agente e sta a meta' di un lavoro.

---

# 5️⃣ LE ALTERNATIVE, ORDINATE PER COSTO

| | strada | costo | verdetto |
|---|---|---|---|
| 🥇 | **la direttiva `@FRAZIONEIS`** | 78 righe driver (di cui ~45 di commento) + 20 righe di testo + 2 costanti nella corsia sottile + 1 cancello | ✅ **RACCOMANDATA** |
| 🥈 | **(a) script dedicato `RIGA_SOTTILE_ROUND_50.ps1`** | ~700 righe duplicate + pin e impronte proprie + cancello G1-G4 | ⚠️ praticabile, **ma peggiore** |
| 🚫 | **(d) firma di Claudio per allargare la lista bianca** | costa **una firma** — la risorsa più scarsa a 3 settimane da ottobre | ❌ non serve |
| 🚫 | **(b) default del driver a 0.50** | zero righe | ❌ **NO, e il perché è misurato** |
| 🚫 | **(c) riscrivere i venti a 0.40** | 20 edit | ❌ **NO, vietato dalla regola di casa** |

### 🥈 (a) lo script dedicato — PASSEREBBE i cancelli, ma è la strada peggiore, e ho un numero
Sui cancelli G1-G4: sì, un clone che cambia **solo** la riga degli argomenti
passerebbe (marcatore unico, bersaglio letterale in codice, nessun argomento che
nomini percorsi, nessun verbo vietato). **Non è lì che si rompe.** Si rompe qui:
🔴 **nella stessa cartella `prove/` convivono file che vogliono tagli DIVERSI.**
`R128a_trailingTF_D30EUR.txt` r.21 dice, testuale:
> *"`-FrazioneIS 0.40` **NON E' OPZIONALE QUI**: è il taglio con cui è stata fatta
> la corsa d'ancora dell'08/08. Con un altro taglio l'ancora non torna."*

Con due corsie, il taglio sta **nella scelta della corsia** e non nel file: il
giorno che qualcuno mette `R128a` in coda sulla corsia `_50`, gira a 0.50,
**l'ancora dell'08/08 non torna, e nessuno lo scopre.** Con la direttiva il taglio
sta **dentro il file che lo dichiara** e la corsia non può sbagliarlo.
👉 **Duplicare la corsia sposta il rischio dove nessuno lo guarda. La direttiva lo
elimina.** E ogni valore nuovo (0.60? 0.70?) chiederebbe **un'altra** corsia.

### 🚫 (b) cambiare il default a 0.50 — perché NO, col numero
Il default `0.40` è letto da **ogni corsa che non passa il parametro**. Cambiarlo
sposta **in silenzio** la finestra IS/OOS di tutti quei round: i CSV escono con lo
stesso nome, le colonne sono identiche, **e i numeri si riferiscono a un'altra
finestra.** Il caso 3 della tabella lo quantifica: a 0.40 l'IS finisce
**2025.06.09**, a 0.50 **2025.08.13** — **65 giorni di calendario, 47 feriali,
~33 operazioni** di differenza. E colpirebbe **stanotte**: la coda gira già.
🔴 **Un default che cambia in silenzio è la classe 270 di stamattina in un'altra
veste**: un artefatto vecchio che passa per nuovo.
🟢 **La direttiva non ha questo difetto per costruzione**: chi non scrive
`@FRAZIONEIS` non cambia comportamento **di una virgola**. Zero regressione sui
153 file prova esistenti — verificato: `@FRAZIONEIS` non compare in nessuno.

### 🚫 (c) riscrivere i venti a 0.40 — perché NO
I criteri sono congelati in `R128_USCITA_CRITERI.md` **prima** dei numeri, e
dicono 0.50 con un conto (~163 vs ~130 contro il pavimento 150). Riscriverli a
0.40 significa **cambiare i criteri dopo aver visto che sono scomodi** — cioè
esattamente *"i criteri si cambiano PRIMA dei numeri, non dopo"*. E in più
metterebbe l'IS **sotto il pavimento dell'Emendamento A**: il MERITO dei venti
round sarebbe **sospeso** e resterebbe solo il RISCHIO. **Venti round girati per
buttarne via metà della lettura.**

---

# 6️⃣ 🔧 LA MODIFICA PRONTA — scritta, provata, NON applicata

🔴 **Il driver in repo NON è stato toccato.** La toppa vive in
`walkforward_generico_PATCHED.ps1` nello scratchpad. **Prima la proposta, poi il
cancello, poi l'applicazione** (vincolo del mandato).

**Misura della modifica: +78 / −1 righe** (1 riga cambiata è la `Write-Host` delle
due finestre, per stampare anche la frazione).

## 🚦 CANCELLO MECCANICO SULLA TOPPA — DA SOLO, SENZA PIPE
```console
python3 backtest_pipeline/controlla_riga.py --oggetto ps1 <driver PATCHATO>  ->  EXIT = 0
  OK   ASCII puro
  OK   compila: 0 errori dal parser PowerShell vero
  OK   param block RICONOSCIUTO (...,FrazioneIS,Modello,FinoDallaRiga,FrazioneDallaRiga,...)
  OK   nessun costrutto pwsh-7-only
  OK   formati .NET
  OK   nessun Parse decimale senza cultura invariante
  ESITO: nessun difetto meccanico.

python3 backtest_pipeline/controlla_riga.py --oggetto ps1 <driver ORIGINALE> ->  EXIT = 0   (base di confronto)
python3 backtest_pipeline/controlla_prova.py <copia di R128b CON @FRAZIONEIS> ->  EXIT = 0
  celle= 7  OK | problemi: 0     <-- la direttiva nuova NON disturba il cancello del file prova
```
✅ **La regola ASCII puro (17/08) è rispettata: niente emoji, niente accenti.**
✅ `[double]::Parse(..., InvariantCulture)`: su un VPS con locale italiana
`[double]"0.50"` potrebbe leggere 50. Il cancello ha una regola apposta, e passa.

## I QUATTRO PEZZI

**PEZZO 1** — in `param()`, subito dopo il blocco di `-FinoDallaRiga` (dopo r.177):
```text
  [switch]$FrazioneDallaRiga,        # 12/09/2026: dichiara che -FrazioneIS VINCE su '@FRAZIONEIS'.
                                     #   Senza, i due tagli che si contraddicono fanno MORIRE la corsa.
                                     #   Stessa ragione di -FinoDallaRiga: il taglio IS/OOS fa parte
                                     #   dell'IDENTITA' della cella, non e' un default comodo.
```

**PEZZO 2** — il blocco, **subito dopo la chiusura di `@FINOA` (r.573) e prima di
`if(-not $Simbolo)` (r.574)**. Il corpo eseguibile:
```text
if($Direttive.ContainsKey("FRAZIONEIS")){
  $frzTesto = $Direttive["FRAZIONEIS"]
  if($frzTesto -notmatch '^[0-9]*\.?[0-9]+$'){
    Muori ("la direttiva '@FRAZIONEIS " + $frzTesto + "' non e' un numero decimale con il PUNTO.`n" +
           "    Si scrive come lo vuole il driver: '@FRAZIONEIS 0.50'. Niente virgola,`n" +
           "    niente percentuale, niente frazione con la barra.")
  }
  $frzNum = [double]::Parse($frzTesto, [Globalization.CultureInfo]::InvariantCulture)
  if($frzNum -le 0.0 -or $frzNum -gt 1.0){
    Muori ("la direttiva '@FRAZIONEIS " + $frzTesto + "' e' fuori campo: ammesso 0 < f <= 1.`n" +
           "    1.0 = UNA SOLA TRANCHE (gamba OOS degenere, si dichiara).")
  }
  if($PSBoundParameters.ContainsKey("FrazioneIS")){
    if([math]::Abs($FrazioneIS - $frzNum) -gt 0.000001){
      if($FrazioneDallaRiga){
        Write-Host ""
        Write-Host "*********************************************************************" -ForegroundColor Magenta
        Write-Host "  ATTENZIONE: IL TAGLIO IS/OOS NON E' QUELLO DEL FILE PROVA." -ForegroundColor Magenta
        Write-Host ("    '@FRAZIONEIS' nel file   : " + $frzNum) -ForegroundColor Magenta
        Write-Host ("    -FrazioneIS usato DAVVERO: " + $FrazioneIS) -ForegroundColor Magenta
        Write-Host "  Vince la riga di lancio perche' e' stato passato -FrazioneDallaRiga." -ForegroundColor Magenta
        Write-Host "  I numeri che escono NON descrivono la cella del file prova." -ForegroundColor Magenta
        Write-Host "*********************************************************************" -ForegroundColor Magenta
        Write-Host ""
      } else {
        Muori ("DUE TAGLI IS/OOS, DIVERSI, E NON SCELGO IO.`n" +
               "    -FrazioneIS passato a mano : " + $FrazioneIS + "`n" +
               "    '@FRAZIONEIS' nel file     : " + $frzNum + "`n" +
               "    Il file prova dice che il campione si taglia in un punto, la riga`n" +
               "    di lancio ne dice un altro. Le due finestre IS/OOS che ne escono`n" +
               "    sono DIVERSE, e le soglie sono firmate su UNA delle due: una delle`n" +
               "    due e' sbagliata, si guarda QUALE.`n" +
               "    Se la differenza e' VOLUTA, si dichiara: aggiungi -FrazioneDallaRiga.")
      }
    }
  } else {
    $FrazioneIS = $frzNum
    Write-Host ("    taglio IS/OOS preso da '@FRAZIONEIS' nel file prova: " + $FrazioneIS) -ForegroundColor Yellow
  }
}
```
*(sopra, nel file, ~30 righe di commento che spiegano la trappola di `(-not 0.40)`
e la collisione dei 35 script — senza quelle il prossimo che legge rifà l'errore.)*

**PEZZO 3** — attribuibilità: la frazione finisce nel log **accanto alle due
finestre** (r.764, prima della `Write-Host` dell'IS). Oggi il driver stampa le due
finestre ma **non la frazione**: il log pubblicato dal runner non basta a
ricostruire il taglio.
```text
Write-Host ("    taglio IS/OOS: FrazioneIS " + $FrazioneIS) -ForegroundColor Gray
```

**PEZZO 4** — il marcatore **additivo** (dopo r.247, v3/v4/v5 **restano**):
```text
Write-Host "    MARCATORE_WALKFORWARD_GENERICO_v6_FRAZIONEIS" -ForegroundColor DarkGray
```

## 📝 LE VENTI EDIT AI FILE PROVA — una riga ciascuna
Inserire **`@FRAZIONEIS 0.50`** subito dopo `@DAQUANDO 2024.09.26`.
**Verificato**: in tutti e venti l'ancora `^@DAQUANDO 2024.09.26$` è **unica** e
`@FRAZIONEIS` **non è già presente**.

| file | riga di `@DAQUANDO` | | file | riga |
|---|---:|---|---|---:|
| `R128b_bersaglio_D30EUR.txt` | 177 | | `R130d_distanzaminima_D30EUR.txt` | 243 |
| `R128c_trailingfisso_D30EUR.txt` | 152 | | `R130e_placebo_passo_D30EUR.txt` | 262 |
| `R128d_controllo_trailing_D30EUR.txt` | 114 | | `R131a_supertrend_H1_D30EUR.txt` | 275 |
| `R128e_orologio_D30EUR.txt` | 145 | | `R131b_supertrend_H4_D30EUR.txt` | 275 |
| `R129a_costo_alza_D30EUR.txt` | 222 | | `R131c_supertrend_D1_D30EUR.txt` | 274 |
| `R129b_costo_salta_D30EUR.txt` | 191 | | `R131d_supertrend_W1_D30EUR.txt` | 290 |
| `R129c_costo_interruttore_D30EUR.txt` | 165 | | `R131e_ema_H1_D30EUR.txt` | 275 |
| `R130a_interruttore_default_D30EUR.txt` | 223 | | `R131f_ema_H4_D30EUR.txt` | 274 |
| `R130b_interruttore_pulito_D30EUR.txt` | 232 | | `R131g_ema_D1_D30EUR.txt` | 275 |
| `R130c_passo_D30EUR.txt` | 259 | | `R131h_ema_W1_D30EUR.txt` | 286 |

🔴 **E `R128a_trailingTF_D30EUR.txt` NON va toccato** — o, se si vuole essere
espliciti come casa comanda, va toccato **con `@FRAZIONEIS 0.40`**, che è il
taglio che il suo stesso file dichiara non opzionale. Mia raccomandazione:
**metterglielo**, così l'ancora dell'08/08 è protetta dalla guardia invece che
dalla memoria di chi lancia.

---

# 7️⃣ 📋 L'ORDINE DELLE COSE DA FARE (non le ho fatte: le propongo)
1. ✅ **fatto** — ricontare i venti, verificare la radice, provare la toppa, cancelli meccanici a 0
2. ⏳ **agente `controllo-preventivo`** sulla toppa: è il secondo strato, e senza di lui non è un PASS
3. ⏳ applicare i 4 pezzi a `walkforward_generico.ps1` + le 20 (21) edit ai file prova
4. ⏳ commit → `git rev-parse HEAD` → ricalcolare `$SHA_WALK` sul blob nuovo → aggiornare `$PIN` e `$SHA_WALK` in `RIGA_SOTTILE_ROUND.ps1` → **secondo commit** → cancello sulla corsia sottile
5. ⏳ **un `-SoloControllo` su UN round** prima di metterne venti in coda: deve stampare
   `taglio IS/OOS preso da '@FRAZIONEIS': 0.5` e **IS 2024.09.26-2025.08.13**. Se stampa
   `2025.06.09`, la direttiva non è stata letta e **si ferma tutto.**
6. ⏳ solo allora la coda

⚠️ **Il passo 5 non è burocrazia**: è l'unico modo di distinguere "la direttiva
funziona" da "la direttiva è ignorata in silenzio" — che è **esattamente** la
trappola 1. Una riga di log, e il dubbio non esiste più.

---

## 🎯 DOVE SIAMO, detto con onestà
🟢 Venti round fermi da settimane si sbloccano con **78 righe di driver e 20 di
testo**, **senza una firma nuova**, e il meccanismo esce **più sicuro** di come è
entrato (una morte in più dove prima c'era un silenzio).
🔴 E dichiaro cos'è questa giornata: **è PONTEGGIO.** Non ha prodotto nemmeno una
misura di mercato. Vale perché **sblocca 118 celle × 2 finestre = 236 passate**
su una sedia che sta a un commit non-WIP — e quelle sì, sono lavoro sulla sedia.
**A tre settimane da ottobre, venti round fermi per un argomento mancante erano
il collo di bottiglia. Non lo sono più.** 💪
