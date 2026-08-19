# 🧪 R84-BIS — PREPARAZIONE: **la cella D va al collaudo.** Criteri congelati PRIMA, 18 celle disegnate, e **due cose gia' misurate a costo zero** — una delle quali cambia il disegno del round prima ancora di lanciarlo.

_19/08/2026. Referto di **PREPARAZIONE**: qui non c'e' nessun verdetto sulla
cella D. Ci sono i criteri congelati, le prove disegnate, le righe di lancio in
**BOZZA-DA-VERIFICARE** e i risultati del solo post-processing (costo macchina
zero, fatto **dopo** il commit dei criteri). **Niente e' stato mandato a
Claudio. Nessun EA e' stato toccato. Il forward non e' stato sfiorato.**_

**Criteri congelati:** `prove/R84BIS_VALIDAZIONE_D_CRITERI.md`
(commit `9f94e74`, **prima** di qualunque numero nuovo).
**Round di origine:** `REFERTO_ROUND84_ABLAZIONE.md` · CSV in `r84_csv/`.

> 🎯 **LA DOMANDA:** la cella D di R84 (volumi **OPPURE** ATR) contiene
> **informazione vera**, o e' **fortuna della finestra**?

---

## 1. 🚨 LA SCOPERTA CHE HA RISCRITTO IL ROUND — nel sorgente, prima di lanciare

Cercando **dove** i filtri mordono, nei tre EA d'apertura risulta questo
[VERIFICATO, call site per call site]:

| ramo d'ingresso | funzione chiamata | volumi | ATR | ConfirmMode (OR/AND) |
|---|---|:--:|:--:|:--:|
| **BREAKOUT** (`TryPlaceBreakout`) | `ConfirmOK()` | ✅ | ✅ | ✅ |
| fade / delayed / gapfill | `ConfirmOK()` | ✅ | ✅ | ✅ |
| **RETEST** (`MonitorRetest`, righe 1477 e 1510) | **`VolumeOK()` NUDA** | ✅ | ❌ | ❌ |

> 🔴 **Sulla sedia viva del DAX (770101, `InpEntryMode=RETEST`) la cella D NON
> ESISTE.** Accendendo i tre input, `InpUseAtrFilter` e `InpConfirmMode` sono
> **inerti**: morde solo la gamba volumi. Chi scrivesse *"cella D sul DAX"*
> starebbe misurando la **cella B** e chiamandola D — lo stesso tipo di numero
> falso che R84 aveva evitato escludendo il filtro news.

E invece le funzioni `VolumeOK` / `AtrOK` / `ConfirmOK` sono **identiche token
per token** fra `ABTG_Nasdaq_Apertura_US` e `ABTG_DAX_Apertura_EU` [VERIFICATO
con confronto automatico]: quando il ramo le chiama, l'oggetto misurato e' lo
stesso. **La differenza non e' nel filtro: e' in dove viene chiamato.**

**Conseguenza sul disegno**, congelata nei criteri §2 e §7:
- la prova di trasferibilita' ha **due gambe separate e dichiarate**, non una;
- **la cella D piena sul retest e' DICHIARATA E SCARTATA**: servirebbe
  aggiungere `ConfirmOK()` a un EA vivo = **codice nuovo**, vietato dal vincolo
  del round.

---

## 2. 🧬 LE PROVE DISEGNATE — quali, e perche' proprio queste

### 2A. 🔀 TRASFERIBILITA' — **la prova piu' informativa, e va per prima**

**Il ragionamento, in una riga:** su una base **perdente** un filtro che toglie
trade riduce la perdita quasi per costruzione (meno biglietti, meno perdita).
Su una base **POSITIVA** quell'alibi non c'e': un filtro che togliesse trade a
caso taglierebbe profitto e drawdown **nella stessa proporzione**; un riduttore
**con informazione** taglia molto drawdown e poco profitto. **E' l'unica prova
che puo' distinguere le due cose su questo campione.**

Il DAX e' la base positiva disponibile, **misurata a tick reali sulla stessa
identica finestra** (R83): retest PF tot **1,143**, breakout PF tot **1,043**.

### 2B. 🎛️ ROBUSTEZZA — se il vantaggio vive solo sul valore esatto, e' rumore

Vicini stretti dei **due moltiplicatori**, uno alla volta
(`InpVolMult` 1,25 e 1,75 · `InpAtrFilterMult` 0,9 e 1,1). Le **finestre**
(`InpVolAvgBars` / `InpAtrFilterBars` = 20) restano **pinnate**: muoverle
farebbe una griglia, e le griglie qui sono vietate.
🧊 **Il centro non si sposta**, qualunque cosa facciano i vicini: se un vicino
va meglio si scrive *"superficie inclinata"* e **niente altro**.

### 2C. 💸 SCALA DI SPREAD — e il difetto che ha scoperto

**Il difetto, agli atti:** gli `.ini` di R84 e R83 **non contengono nessuna riga
`Spread=`**. Il valore usato e' quello che MT5 aveva in memoria: **stato
nascosto, mai messo agli atti.** Da oggi ogni referto di questa casa riporta la
riga spread effettiva, cella per cella (igiene nuova, criteri §9.5).

⚠️ **Lo spread mediano della base e' [NON MISURABILE con gli attrezzi
esistenti]**, e si dichiara invece di inventarlo: la serie per-trade dell'EA non
ha colonna spread e l'unica tabella in archivio e' quella **Pepperstone di
sabato**. Quindi la scala si esprime in **punti MT5 assoluti**
(`0 / 100 / 200 / 400`; su NASUSD a BCM **100 punti = 1,0 punto indice**,
[VERIFICATO sui prezzi a 2 decimali delle serie per-trade]) e **il criterio e'
COMPARATIVO** (degrado di D contro degrado di A **sullo stesso gradino**): un
confronto comparativo **non ha bisogno** dello spread mediano.

🐤 **E prima di tutto c'e' il canarino C4**, che e' la cosa piu' importante di
questa gamba: **non e' misurato se MT5 onori la riga `Spread=` a tick reali.**
Se la ignorasse, l'intera scala uscirebbe **identica alla base** e la si
leggerebbe come *"il filtro e' robusto allo spread"* — che sarebbe un **numero
falso**, non un risultato. Quindi: `A` con `Spread=400` **DEVE** dare numeri
**DIVERSI**. Se sono identici, la scala a tick reali e' **NON ESEGUIBILE**, si
dichiara, e il cancello **pesa zero**.

### 2D. 🪟 SPLIT ALTERNATIVO — con il suo limite scritto sopra

`-FrazioneIS 0.55` costa zero codice. **Ma NON e' un walk-forward:** il
campione totale non cambia, quindi PF/profitto/n totali sono **identici per
costruzione**. Serve a **una cosa sola**: capire se la *coerenza fra le meta'*
(cancello 2 di R84) regge spostando il confine, o esisteva solo al 40/60.
E' la prova **piu' debole del round**, ed e' l'ultima.

### 2E. ❌ Cosa e' stato SCARTATO, con nome e cognome

| scartata | perche' |
|---|---|
| cella D piena sul **retest** del DAX | richiede `ConfirmOK()` nel ramo retest = **codice nuovo in un EA vivo** |
| **spread mediano misurato** della base | richiede una sonda sui tick o una colonna nuova = **codice nuovo** |
| profilo **commissioni** di una prop vera | **[NON MISURABILE]**: nessuna scheda in archivio ha numeri usabili. Non si inventa |
| **walk-forward a finestre rotolanti** | il driver non lo fa; scriverlo e' un round suo |
| filtro **news** | resta il debito aperto di R84 §6 (copertura CSV non misurata). Qui si valida D, non si aprono fronti |

✅ **Swap / rollover: NON APPLICABILE, e per misura.** Tutte le celle hanno
`InpCloseAtEnd=1` e chiudono a fine sessione (Nasdaq 21:45, DAX 17:30 ora
server): **nessuna posizione passa la notte.**

---

## 3. 📋 LE 18 CELLE

| # | cella | passo | EA | simbolo | file prova | magic | `Spread` | fraz. IS |
|---|---|:--:|---|---|---|---|---:|---:|
| 1 | **S3A** 🐤 C4 | 1 | Nasdaq | NASUSD | `R84a_base_NASUSD.txt` ♻️ | 776010/011 | **400** | 0,40 |
| 2 | **S0A** 🐤 C3 | 2 | Nasdaq | NASUSD | `R84a_base_NASUSD.txt` ♻️ | 776010/011 | **0** | 0,40 |
| 3 | **S0D** 🐤 C3 | 2 | Nasdaq | NASUSD | `R84d_volatr_NASUSD.txt` ♻️ | 776040/041 | **0** | 0,40 |
| 4 | **T0** 🐤 C1 | 3 | 3Ingressi | D30EUR | `R83d0_stop_D30EUR.txt` ♻️ | 777110/111 | assente | 0,40 |
| 5 | **T1** ⭐ | 3 | 3Ingressi | D30EUR | `R84BIS_T1_volatr_D30EUR.txt` 🆕 | 776120/121 | assente | 0,40 |
| 6 | **T2** 🐤 C2 | 3 | DAX_EU | D30EUR | `R83v_vivo_D30EUR.txt` ♻️ | 777190/191 | assente | 0,40 |
| 7 | **T3** ⭐ | 3 | DAX_EU | D30EUR | `R84BIS_T3_volumi_D30EUR.txt` 🆕 | 776140/141 | assente | 0,40 |
| 8 | **B1** | 4 | Nasdaq | NASUSD | `R84BIS_B1_volmult125_NASUSD.txt` 🆕 | 776150/151 | assente | 0,40 |
| 9 | **B2** | 4 | Nasdaq | NASUSD | `R84BIS_B2_volmult175_NASUSD.txt` 🆕 | 776160/161 | assente | 0,40 |
| 10 | **B3** | 4 | Nasdaq | NASUSD | `R84BIS_B3_atrmult090_NASUSD.txt` 🆕 | 776170/171 | assente | 0,40 |
| 11 | **B4** | 4 | Nasdaq | NASUSD | `R84BIS_B4_atrmult110_NASUSD.txt` 🆕 | 776180/181 | assente | 0,40 |
| 12 | **S1A** | 5 | Nasdaq | NASUSD | `R84a_base_NASUSD.txt` ♻️ | 776010/011 | **100** | 0,40 |
| 13 | **S2A** | 5 | Nasdaq | NASUSD | `R84a_base_NASUSD.txt` ♻️ | 776010/011 | **200** | 0,40 |
| 14 | **S1D** | 5 | Nasdaq | NASUSD | `R84d_volatr_NASUSD.txt` ♻️ | 776040/041 | **100** | 0,40 |
| 15 | **S2D** | 5 | Nasdaq | NASUSD | `R84d_volatr_NASUSD.txt` ♻️ | 776040/041 | **200** | 0,40 |
| 16 | **S3D** | 5 | Nasdaq | NASUSD | `R84d_volatr_NASUSD.txt` ♻️ | 776040/041 | **400** | 0,40 |
| 17 | **W1** | 6 | Nasdaq | NASUSD | `R84a_base_NASUSD.txt` ♻️ | 776010/011 | assente | **0,55** |
| 18 | **W2** | 6 | Nasdaq | NASUSD | `R84d_volatr_NASUSD.txt` ♻️ | 776040/041 | assente | **0,55** |

🆕 = file prova nuovo · ♻️ = **file prova riusato INVARIATO** · 🐤 = canarino ·
⭐ = la prova che risponde alla domanda del round.

**I sei file nuovi sono COPIE della loro baseline con una riga cambiata**, e
non e' una frase: il corpo dal `@SIMBOLO` in giu' e' identico riga per riga,
verificato con diff [VERIFICATO]:

| file nuovo | baseline | righe diverse (magic compreso) |
|---|---|---|
| `R84BIS_T1_volatr_D30EUR.txt` | `R83d0_stop_D30EUR.txt` | **3** su 107: `InpUseVolumeFilter` 0→1 · `InpUseAtrFilter` 0→1 · magic |
| `R84BIS_T3_volumi_D30EUR.txt` | `R83v_vivo_D30EUR.txt` | **2** su 108: `InpUseVolumeFilter` 0→1 · magic |
| `R84BIS_B1_volmult125_NASUSD.txt` | `R84d_volatr_NASUSD.txt` | **2** su 105: `InpVolMult` 1.5→1.25 · magic |
| `R84BIS_B2_volmult175_NASUSD.txt` | `R84d_volatr_NASUSD.txt` | **2** su 105: `InpVolMult` 1.5→1.75 · magic |
| `R84BIS_B3_atrmult090_NASUSD.txt` | `R84d_volatr_NASUSD.txt` | **2** su 105: `InpAtrFilterMult` 1.0→0.9 · magic |
| `R84BIS_B4_atrmult110_NASUSD.txt` | `R84d_volatr_NASUSD.txt` | **2** su 105: `InpAtrFilterMult` 1.0→1.1 · magic |

_(In T1 `InpConfirmMode` era **gia'** 0 = OR nella baseline: nessuna riga
cambiata, ed e' scritto nell'intestazione del file invece di lasciarlo
implicito. E' la stessa disciplina che ha fatto pagare due volte
`InpTP1_ATRmult=0` contro 0,5.)_

**Magic:** blocco **7761xx-7764xx**, verificato libero contro **tutti** i magic
che compaiono nel repo. I canarini riusano di proposito i magic originali
(777110/111, 777190/191, 776010/011, 776040/041): e' cosi' che sono
riproducibili **per costruzione**.

---

## 4. 🧮 QUELLO CHE E' GIA' MISURATO — post-processing, costo macchina ZERO

Fatto **dopo** il commit dei criteri (`9f94e74`), sui CSV **gia' in repo**.
Nessun MT5, nessun minuto di Claudio, nessuna riga di lancio.
Serie per-trade **OOS** delle celle A e D di R84 — e la somma dei `net_profit`
**ritrova al centesimo** gli aggregati (−795,03 e −287,19) [VERIFICATO].

### 4.1 📉 P1 — PERSISTENZA: **il vantaggio di D sta tutto nella SECONDA META'**

Quattro quarti di calendario della finestra OOS (2025.06.10 → 2026.06.30):

| quarto | A | D | **D − A** | deal A | deal D |
|---|---:|---:|---:|---:|---:|
| 2025.06.10 → 2025.09.14 | **+148,18** | −135,62 | **−283,80** | 78 | 67 |
| 2025.09.14 → 2025.12.19 | **+137,20** | −27,97 | **−165,17** | 76 | 49 |
| 2025.12.19 → 2026.03.26 | +266,38 | **+477,60** | **+211,22** | 72 | 36 |
| 2026.03.26 → 2026.06.30 | −1.346,79 | **−601,20** | **+745,59** | 65 | 49 |

> 🔴 **D batte A in 2 quarti su 4** — e nei due quarti in cui **A guadagna**,
> **D perde**. Tutto il vantaggio (+507,84 sull'OOS intero) e' fatto negli
> ultimi due quarti, e **+745,59 di quel vantaggio sta nell'ultimo**, cioe'
> esattamente dove A crolla.
>
> Letto in una riga: **D si comporta da ammortizzatore del brutto, non da
> selettore del buono.**

⚖️ **E qui i criteri congelati vanno applicati alla lettera, difetto compreso.**
Il cancello **P** prevedeva `PASS` a ≥3 quarti su 4 e `FAIL` a 1 solo quarto:
**il 2 su 4 cade in un buco che non avevo previsto.** Non lo riscrivo dopo i
numeri. Quindi, per la contabilita' dei cancelli:
**P NON E' PASSATO** (e non conta come cancello di supporto in §6 dei criteri);
non lo si chiama nemmeno FAIL. **Il buco resta agli atti come difetto dei
criteri**, non come sfumatura a favore.

### 4.2 ⚡ P2 — SLIPPAGE SUGLI INGRESSI [APPROSSIMAZIONE PESSIMISTICA DICHIARATA]

`costo = punti_MT5 × 0,01 × volume totale della posizione × EUR/punto/lotto`,
pagato **una volta per posizione** (l'ingresso). Scala **adattata al tick
size**: su NASUSD (2 decimali) la scala di casa 0/1/2/5 punti varrebbe 0,05
punti indice = niente, quindi **0 / 25 / 50 / 100 punti MT5** = 0 / 0,25 / 0,50
/ 1,00 punti indice. Gli EA d'apertura prendono la scala piu' severa: **la
latenza morde dove la volatilita' e' massima**, ed e' l'apertura.

Esposizione OOS: **A = 241 posizioni / 489,20 lotti · D = 169 posizioni / 307,70 lotti.**

| slippage sugli ingressi | A (EUR) | D (EUR) | D − A | D meglio? |
|---|---:|---:|---:|:--:|
| 0 (base) | −795,03 | −287,19 | +507,84 | ✅ |
| 25 pt = 0,25 idx | −900,45 | −353,50 | +546,95 | ✅ |
| 50 pt = 0,50 idx | −1.005,88 | −419,81 | +586,07 | ✅ |
| 100 pt = 1,00 idx | −1.216,72 | −552,43 | +664,29 | ✅ |

**La meta' P2 del cancello passa**: il vantaggio di D **non si ribalta**, anzi
cresce (D ha meno posizioni da tassare). Ma **entrambe restano negative a ogni
gradino**: lo slippage non trasforma un riduttore di perdita in un edge.

- ⚠️ **Non modella**: requote, ordini rifiutati, slippage favorevole, e il fatto
  che gli **STOP** pagano lo slippage mentre i **LIMIT** del retest no. Stima
  pessimistica controllata, **non** una simulazione.
- ⚠️ Conversione **0,862 EUR/punto/lotto** = **[INFERITO]** dal valore misurato
  dal vivo su `U30USD` (DIARIO 17/08), applicato a NASUSD perche' e' anch'esso
  un indice in USD con contract size 1. **La lettura che fa fede e' il
  RAPPORTO D/A**, che non dipende dalla conversione.
- ⚠️ **Solo OOS**: le serie per-trade IS non esistono in archivio (il driver le
  sovrascrive). Dichiarato, non aggirabile senza rilanci.

### 4.3 🎲 MISURA AGGIUNTIVA — D contro il nullo *"stesso motore, meno biglietti"*

**Non e' un cancello** (nessun cancello e' stato aggiunto dopo i numeri): e' la
misura che dice se D e' qualcosa **di piu'** di un A rimpicciolito. Il rischio
e' pinnato all'1%/operazione, quindi ogni posizione rischia uguale e **il nullo
giusto scala per NUMERO DI POSIZIONI** (169/241 = 0,7012), non per volume.

| quarto | pos. A | pos. D | A | **nullo (A × 0,70)** | D | |
|---|---:|---:|---:|---:|---:|:--:|
| Q1 | 62 | 54 | +148,18 | +129,06 | −135,62 | ❌ |
| Q2 | 60 | 40 | +137,20 | +91,47 | −27,97 | ❌ |
| Q3 | 61 | 32 | +266,38 | +139,74 | +477,60 | ✅ |
| Q4 | 58 | 43 | −1.346,79 | −998,48 | −601,20 | ✅ |
| **OOS intero** | 241 | 169 | −795,03 | **−557,51** | **−287,19** | ✅ **+270,32** |

**Lettura onesta, tutte e due le facce:** sull'OOS intero D batte il nullo di
**+270** — non e' *solo* "meno biglietti". Ma **quarto per quarto e' di nuovo
2 su 4**, e le due vittorie sono **le stesse due** di P1. Il di-piu' rispetto
al nullo e' **concentrato nella stessa meta' di finestra**, non distribuito.

---

## 5. 🚦 LE RIGHE DI LANCIO — **BOZZA-DA-VERIFICARE, NON MANDATE**

> 🔴 **AVVISO DEL 19/08 — LA COLLISIONE CON LA MIGRAZIONE GUARDIAN, e va letta
> PRIMA di qualunque passo.** Una sessione parallela ha migrato su `lavoro`
> **due dei tre EA di questo round** [VERIFICATO sul log: commit `d83c196`,
> "famiglia Apertura"]:
>
> | EA | usato da | cambiato dopo il pin di R84 (`2458b33`)? |
> |---|---|---|
> | `ABTG_Nasdaq_Apertura_US` | S3A S0A S0D B1-B4 S1A-S3D W1 W2 | 🔴 **SI** (`d83c196`) |
> | `ABTG_DAX_Apertura_EU` | T2 T3 | 🔴 **SI** (`d83c196`) |
> | `ABTG_Apertura_3Ingressi` | T0 T1 | ✅ no (fermo a `fe1cdb5`, 18/08) |
>
> ⚠️ **E il pin NON protegge da questo:** `walkforward_generico.ps1` scarica
> l'EA da `$EABranch="lavoro"` **scritto fisso nel sorgente** (riga 78), non
> dal `-Rif`. Qualunque cosa si pinni, **l'EA che gira e' quello di `lavoro`
> adesso.**
>
> **Conseguenza sui canarini, dichiarata prima e non dopo:** se **C3**
> (Nasdaq A e D) o **C2** (DAX retest) falliscono, la prima ipotesi **non e'**
> un errore di R84-bis: e' che la migrazione abbia **cambiato il
> comportamento**. Sono le stesse due gambe su cui la migrazione ha aperto il
> suo **criterio 4** (*backtest identico al centesimo prima/dopo*,
> `REFERTO_MIGRAZIONE_GUARDIAN_PREPARAZIONE.md`).
>
> 🤝 **Da qui nasce una proposta di coordinamento, che NON decido io:** i
> canarini C2 e C3 di R84-bis **sono gia'** una prova di criterio 4 per quei
> due EA (stessa configurazione, stessa finestra, numeri attesi scritti nel
> driver). O si aspetta che la migrazione chiuda il criterio 4 e **poi** si
> ri-pinna R84-bis, **oppure** si girano prima C2/C3 e il loro esito vale per
> tutti e due i lavori. **Sceglie l'architetto, non il collaudatore** — ma
> **non si lancia il passo 3 senza aver deciso quale delle due.**

> 🛑 **Queste righe NON sono state mandate a Claudio.** Sono bozze da
> ricontrollare con `CHECKLIST_RIGA_DI_LANCIO.md` alla mano prima di uscire.
> Punti gia' eseguiti: **1** (script letto, e' scritto da qui), **3** (il file
> prova VERIFICA, non CERCA: nessuna griglia, un asse solo = i magic gemelli),
> **4** (pin `2ecd2ef`: i commit dei file pinnati sono **`8695289`**,
> **`20dc731`**, **`2ecd2ef`** - tutti **dentro** il pin), **5** (giro a vuoto
> obbligatorio, e' il PASSO 2). Punto **2** (difetti gemelli) e punto **18/19**
> (profondita' e timeout) **da rieseguire alla consegna.**

⚠️ **UNA MACCHINA, UN LAVORO.** Il PC di backtest ha **un solo MT5**: prima di
mandare queste righe va dichiarato cosa deve essere finito. **MT5 va CHIUSO.**

### PASSO 0 — profondita' dei tick, i DUE simboli (20-90 min [STIMA])
```powershell
& {
  [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
  if(Get-Process -Name terminal64 -EA SilentlyContinue){ throw "MT5 E' APERTO: chiudilo" }
  $h="2ecd2ef9c048e04d697c36cd2f81abc49665d406"
  $p="$env:USERPROFILE\scarica_storico.ps1"
  $dsk=[Environment]::GetFolderPath('Desktop')
  $csv=Join-Path $dsk 'storico_bcm\ABTG_StoricoScaricato.csv'
  Remove-Item $p,$csv -Force -EA SilentlyContinue
  irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$h/backtest_pipeline/scarica_storico.ps1" -OutFile $p -EA Stop
  $global:LASTEXITCODE=0
  & powershell -ExecutionPolicy Bypass -File $p -Simboli "NASUSD,D30EUR" -Da 2024.01.01 -TimeoutMin 180 -Auto
  if($LASTEXITCODE -ne 0){ throw "PASSO 0 FALLITO (codice $LASTEXITCODE): non si va oltre" }
  if(-not (Test-Path -LiteralPath $csv)){ throw "PASSO 0 MONCO: il referto non e' sul Desktop. RILANCIA." }
  $t=@(@(Import-Csv -LiteralPath $csv) | Where-Object { $_.Timeframe -eq 'TICK' })
  $t | Format-Table Simbolo,Timeframe,Barre,PrimaDataLocale,Verdetto -AutoSize
  foreach($s in @('NASUSD','D30EUR')){
    $x=@($t | Where-Object { $_.Simbolo -eq $s })
    if($x.Count -eq 0){ throw "PASSO 0 MONCO: manca la riga $s,TICK - MT5 ammazzato a meta'. RILANCIA." }
    $d=($x[0].PrimaDataLocale + '').Trim()
    if($d -eq '' -or $d -eq '-'){ throw "PASSO 0: $s NON HA TICK REALI: si gira a -Modello 1 -SaltaPassoZero e OGNI numero porta scritto 'OHLC, non tick'." }
  }
  Write-Host "PASSO 0 OK. Da mandare in chat: la tabella qui sopra." -ForegroundColor Cyan
}
```

### PASSO 1 — giro a vuoto (NON apre MT5, 2-4 min) 🛑 **stop obbligatorio**
```powershell
& {
  [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
  if(Get-Process -Name terminal64 -EA SilentlyContinue){ throw "MT5 E' APERTO: chiudilo" }
  $h="2ecd2ef9c048e04d697c36cd2f81abc49665d406"
  $b="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$h/backtest_pipeline"
  $dsk=[Environment]::GetFolderPath('Desktop')
  $p="$env:USERPROFILE\lancia_r84bis.ps1"
  Remove-Item $p -Force -EA SilentlyContinue
  irm "$b/lancia_r84bis.ps1" -OutFile $p -EA Stop
  if(-not (Select-String -Path $p -SimpleMatch -Pattern 'R84-BIS - VALIDAZIONE DELLA CELLA D' -Quiet)){ throw "lancia_r84bis.ps1 VECCHIO O TRONCO" }
  $global:LASTEXITCODE=0
  & powershell -ExecutionPolicy Bypass -File $p -Rif $h -SoloControllo
  if($LASTEXITCODE -ne 0){ throw "GIRO A VUOTO FALLITO: guarda le righe rosse sopra" }
  $rac=Join-Path $dsk 'R84BIS_GIRO_A_VUOTO'
  Remove-Item $rac -Recurse -Force -EA SilentlyContinue
  New-Item -ItemType Directory -Force -Path $rac | Out-Null
  Get-ChildItem "$env:USERPROFILE\r84bis" -Filter "anteprima_*.ini" -EA SilentlyContinue | ForEach-Object { Copy-Item $_.FullName $rac -Force }
  ("data: " + (Get-Date -Format 'yyyy-MM-dd HH:mm')) | Set-Content (Join-Path $rac 'REFERTO_GIRO_A_VUOTO.txt') -Encoding ASCII
  Compress-Archive -Path (Join-Path $rac '*') -DestinationPath (Join-Path $dsk 'R84BIS_GIRO_A_VUOTO.zip') -Force
  Write-Host "GIRO A VUOTO OK. Da mandare in chat: Desktop\R84BIS_GIRO_A_VUOTO.zip" -ForegroundColor Cyan
}
```
🛑 **Cosa si legge PRIMA di andare avanti** (costa un minuto, non due ore):
`InpSessionHour=8` sul DAX e `=14` sul Nasdaq (**ora server**: 9 o 15 =
corsa da cestinare) · `celle per finestra : 2` (le due passate gemelle) ·
la riga `Spread=` presente dove deve esserci e **assente** dove deve mancare.

### PASSO 2 — **il canarino C4** (1 cella, ~7 min) — apre o chiude la gamba spread
```powershell
& {
  [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
  if(Get-Process -Name terminal64 -EA SilentlyContinue){ throw "MT5 E' APERTO: chiudilo, altrimenti escono 0 CSV" }
  $h="2ecd2ef9c048e04d697c36cd2f81abc49665d406"
  $p="$env:USERPROFILE\lancia_r84bis.ps1"
  Remove-Item $p -Force -EA SilentlyContinue
  irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$h/backtest_pipeline/lancia_r84bis.ps1" -OutFile $p -EA Stop
  & powershell -ExecutionPolicy Bypass -File $p -Rif $h -Passo 1
  Write-Host "Da mandare in chat: Desktop\R84BIS_VALIDAZIONE_D.zip" -ForegroundColor Cyan
}
```
🔎 **Come si legge:** i numeri di `S3A` **devono essere DIVERSI** da IS +686,35
/ OOS −795,03. **Se sono uguali**, MT5 ignora la riga `Spread` a tick reali:
la scala §2C **non e' eseguibile cosi'**, si dichiara, e i passi 5 si saltano.

### PASSO 3 — **il cuore del round**: canarini C3/C1/C2 + trasferibilita' (6 celle, ~42 min)
```powershell
& {
  [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
  if(Get-Process -Name terminal64 -EA SilentlyContinue){ throw "MT5 E' APERTO: chiudilo, altrimenti escono 0 CSV" }
  $h="2ecd2ef9c048e04d697c36cd2f81abc49665d406"
  $p="$env:USERPROFILE\lancia_r84bis.ps1"
  Remove-Item $p -Force -EA SilentlyContinue
  irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$h/backtest_pipeline/lancia_r84bis.ps1" -OutFile $p -EA Stop
  & powershell -ExecutionPolicy Bypass -File $p -Rif $h -Passo 2,3
  Write-Host "Da mandare in chat: Desktop\R84BIS_VALIDAZIONE_D.zip" -ForegroundColor Cyan
}
```
🛑 **Se un canarino stampa `CANARINO FALLITO`, quella gamba NON SI LEGGE** e lo
script esce **1**. Non si spiega a posteriori: si cerca la divergenza.

### PASSO 4 — il resto, in una notte (11 celle, ~77 min)
```powershell
& {
  [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
  if(Get-Process -Name terminal64 -EA SilentlyContinue){ throw "MT5 E' APERTO: chiudilo, altrimenti escono 0 CSV" }
  $h="2ecd2ef9c048e04d697c36cd2f81abc49665d406"
  $p="$env:USERPROFILE\lancia_r84bis.ps1"
  Remove-Item $p -Force -EA SilentlyContinue
  irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$h/backtest_pipeline/lancia_r84bis.ps1" -OutFile $p -EA Stop
  & powershell -ExecutionPolicy Bypass -File $p -Rif $h -Passo 4,5,6
  Write-Host "Da mandare in chat: Desktop\R84BIS_VALIDAZIONE_D.zip" -ForegroundColor Cyan
}
```
📦 **La raccolta e' dentro il driver** (regola delle righe di lancio, punto 2):
cartella `Desktop\R84BIS_VALIDAZIONE_D` + zip `R84BIS_VALIDAZIONE_D.zip`,
con l'**elenco dei file attesi controllato uno per uno** e il
`REFERTO_RACCOLTA_R84BIS.txt` che riporta **la riga `Spread` effettiva cella
per cella**.

**Ordine di rinuncia se il tempo manca: prima il passo 6, poi il 5, poi il 4.
Il passo 3 non si salta mai.**

---

## 6. ⚖️ I CANCELLI, in numeri gia' calcolati (per non doverli fare di notte)

| cancello | soglia esatta |
|---|---|
| **T** su T1 (base DAX breakout: +454,88 · DD OOS 13,2624%) | DD OOS ≤ **9,947%** **E** profitto tot ≥ **+386,65** **E** n tot ≥ 150 |
| **T** su T3 (base DAX retest viva: +1.281,54 · DD OOS 10,5984%) | DD OOS ≤ **7,949%** **E** profitto tot ≥ **+1.089,31** **E** n tot ≥ 150 |
| **R** | ≥ **2 vicini su 4** con PF tot > **1,088** e profitto tot positivo |
| **S** | `PF(D,g) − PF(D,0)` ≥ `PF(A,g) − PF(A,0)` su ≥ **2 gradini su 3** |
| **P** | ❌ **gia' NON passato** (§4.1): 2 quarti su 4 |
| **W** | D migliora rispetto ad A in **entrambe** le meta' anche al 55/45 |

**Verdetto 🟢 "D ha informazione"** = `PASS-T` su almeno una gamba **E** ≥2
cancelli fra `{R, S, P}`. Poiche' **P e' gia' fuori**, servono **R e S tutti e
due** — e se il canarino C4 fallisce, **S non e' nemmeno disponibile**: in quel
caso il verdetto verde diventa **irraggiungibile**, e va detto adesso, non dopo.

---

## 7. 🚫 COSA QUESTO ROUND NON PUO' PRODURRE (congelato, e vale anche se tutto passa)

> ❌ **Nessuna sedia nuova.** La base Nasdaq resta negativa in OOS anche con D:
> un riduttore di perdita su una base che perde **non fa un edge**. La **770201
> resta SPENTA** (FIRMA 5; porta di rientro C3: serve una **tesi nuova**, non
> una taratura).
> ❌ Nessuna accensione automatica di filtri su nessun EA.
> ❌ Nessuna modifica in forward: un BOCCIATO produce una **raccomandazione**,
> non uno spegnimento; un PASS produce una **proposta**, non un'accensione.
>
> ✅ **Al massimo UNA RIGA DI PIANO**: *"sulle sedie di apertura vive la
> conferma volumi-OR-ATR e' consigliata come riduttore di drawdown, con questo
> margine misurato: ..."* — e passa **dall'architetto e da Claudio**.

**E cosa il collaudo NON copre, sempre**: requote · ordini rifiutati ·
l'esecuzione vera di una prop · le sue commissioni (**[NON MISURABILE]**) ·
i regimi 2020 e 2022 (**la finestra contiene un regime e mezzo**: nessun numero
di qui e' "robusto").

⚠️ **E la valvola di casa resta sopra tutto:** _il campione sottile sospende il
giudizio sul **MERITO**, mai sul **RISCHIO**._ Un DD accaduto vale a qualunque n.

---

## 8. 📎 TRACCIABILITA'

- Criteri congelati: `prove/R84BIS_VALIDAZIONE_D_CRITERI.md` — commit **`9f94e74`**
- File prova nuovi: commit **`20dc731`** · driver: commit **`2ecd2ef` (correzione della cultura compresa)**
- `walkforward_generico.ps1` con `-Spread` (additivo, default = comportamento di
  sempre): commit **`8695289`**
- Pin consigliato per le righe di lancio: **`2ecd2ef9c048e04d697c36cd2f81abc49665d406`**
- Referto finale, a numeri tornati: `REFERTO_COLLAUDO_R84BIS_D.md`
