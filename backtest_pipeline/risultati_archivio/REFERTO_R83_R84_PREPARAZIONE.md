# 🧰 R83 + R84 — LA PREPARAZIONE (18/08/2026 sera)

_Due round sulle APERTURE, preparati insieme perche' si incastrano: R84
chiude un debito vecchio (i filtri), R83 apre la domanda nuova di Claudio
(gli ingressi). **Nessuno dei due ha ancora prodotto un numero**: qui c'e'
solo la macchina, con i criteri congelati PRIMA._

> 🎯 **IN TRE RIGHE:** **R84** misura, un filtro alla volta, se le condizioni
> del corso aggiungono o tolgono sul Nasdaq (**9 celle**, EA vivo, zero righe
> di codice toccate). **R83** e' il duello degli ingressi firmato da Claudio
> (**7 celle**, EA NUOVO a tre modalita', Nasdaq + DAX). Tutto e' committato
> e pinnabile; **le righe di lancio qui dentro sono BOZZE** e passano dal
> verificatore prima di arrivare a Claudio.

---

## 1. 📦 COSA E' PRONTO (percorsi esatti)

| pezzo | file |
|---|---|
| criteri R84 (congelati) | `backtest_pipeline/prove/R84_ABLAZIONE_CRITERI.md` |
| criteri R83 (congelati) | `backtest_pipeline/prove/R83_INGRESSI_CRITERI.md` |
| file prova R84 (9) | `backtest_pipeline/prove/R84a_base_NASUSD.txt` ... `R84i_completo_NASUSD.txt` |
| file prova R83 (7) | `backtest_pipeline/prove/R83n0_stop_NASUSD.txt` ... `R83v_vivo_D30EUR.txt` |
| EA nuovo del duello | `mql5/Experts/ABTG_Apertura_3Ingressi.mq5` |
| driver R84 | `backtest_pipeline/lancia_r84.ps1` |
| driver R83 | `backtest_pipeline/lancia_r83.ps1` |

**SHA da pinnare: `2458b33415f6120c3bee0cd7f0ba9b9ab26d4d1b`** — contiene
tutti e sette i pezzi (verificato file per file con `git log -1 -- <file>`,
punto 4 della checklist). `walkforward_generico.ps1` e' fermo a `51922fa`
(14/08), quindi piu' vecchio: il pin va bene.

## 2. 🔬 R84 — L'ABLAZIONE DEI FILTRI (Nasdaq, 9 celle)

**La domanda:** *"i filtri che il corso prescrive come CONDIZIONI aggiungono
o tolgono, misurato, un filtro alla volta, a parita' di tutto il resto?"*

**Perche' esiste:** l'audit del 02/08 spense i filtri promettendo di
misurarli; la misura non e' mai finita. Oggi i filtri sono spenti **non
perche' misurati inutili, ma perche' la misura non c'e'**. Quello che e'
morto nei walk-forward e' lo **scheletro nudo**; il metodo del corso, coi
suoi filtri, **non e' mai stato messo alla prova fino in fondo**.

| cella | filtro acceso | magic |
|---|---|---|
| A | nessuno (il metro) | 776010/11 |
| B | volumi >= 1,5 x media 20 barre | 776020/21 |
| C | ATR >= media 20 barre | 776030/31 |
| D | volumi **O** ATR (la conferma come la scrive il PDF) | 776040/41 |
| E | trend EMA 14/200 H1 | 776050/51 |
| F | Supertrend 10/2.5 H1 | 776060/61 |
| G | tre Supertrend concordi 2.5/3.0/3.5 | 776070/71 |
| H | indice guida SPXUSD | 776080/81 |
| I | **metodo completo** (D+E+G+H) | 776090/91 |

Ogni file prova e' la cella A con **UNA riga cambiata**: `diff R84a... R84g...`
mostra esattamente quella riga. I nomi dei 71-77 parametri pinnati sono stati
**verificati uno per uno contro i 95 `input` del sorgente vivo** (un nome
sbagliato MT5 lo ignora in silenzio e il round risponde a un'altra domanda).

**Esclusi apposta e dichiarati:** filtro **news** (si alimenta da un CSV la
cui copertura sulla finestra non e' misurata: una cella che non filtra niente
sembrerebbe "filtro neutro" — falso), `InpUseRoundLevels` (e' una regola di
**uscita**, non un filtro), leve R30 (non vengono dal corso).

## 3. 🥊 R83 — IL DUELLO DEGLI INGRESSI (Nasdaq + DAX, 7 celle)

**Firma 6, parole di Claudio:** *"SI, FIRMO R83BIS"*. Un solo EA con
`InpEntryMode` **0 = stop / 1 = limit sul retest / 2 = market alla conferma
di chiusura**, un magic per modalita', mai segnali miscelati.

| cella | mercato | modalita' | magic | ruolo |
|---|---|---|---|---|
| N0 | NASUSD | 0 stop | 777010/11 | baseline Nasdaq **+ canarino (a)** |
| N1 | NASUSD | 1 limit retest | 777020/21 | sfidante |
| N2 | NASUSD | 2 market conferma | 777030/31 | sfidante (**codice nuovo**) |
| D0 | D30EUR | 0 stop | 777110/11 | sfidante |
| D1 | D30EUR | 1 limit retest | 777120/21 | **baseline DAX** |
| D2 | D30EUR | 2 market conferma | 777130/31 | sfidante (**codice nuovo**) |
| V | D30EUR | EA **vivo** | 777190/91 | **canarino (b)**: equivalenza |

### 3.1 🐤 I due canarini, e perche' senza di loro il duello non conta
- **(a)** N0 e' configurata **riga per riga** come la cella A di R84, che gira
  sull'**EA vivo del Nasdaq**: i numeri **devono coincidere**. Verificato qui
  a tavolino che gli unici scarti fra i due file prova sono il magic e
  `InpAutoTest` (che nell'EA vecchio non esiste); i tre parametri che N0 pinna
  in piu' (`InpOCTimeframe`, `InpDelayMinutes`, `InpDelayDirMode`) valgono
  **esattamente i default** su cui il driver blinda la cella A. **Costo
  macchina in piu': zero.**
- **(b)** D1 (EA nuovo) e V (EA vivo) devono coincidere.
- **Se un canarino fallisce, il round si FERMA** e si cerca la divergenza nel
  codice. Non si spiega a posteriori.

### 3.2 ⚠️ Tre cose trovate leggendo i sorgenti, che cambiano le premesse

1. **Sul DAX la baseline NON e' il breakout stop.** La sedia viva 770101 gira
   **gia' in retest** dal 06/08 — riga del sorgente:
   `input ENUM_ABTG_ENTRY InpEntryMode = ABTG_RETEST;` con
   `InpRetestOffsetPts=200`. Quindi sul DAX le sfidanti sono la 0 e la 2.
   Sul Nasdaq invece la baseline e' davvero la 0.
2. **I due motori vivi sono GIA' divergenti fra loro.** Il core del **DAX** ha
   `InpAllowReverse` (R51) e **non** ha le leve R30; il core del **Nasdaq** ha
   le leve R30 e **non** ha `InpAllowReverse`. L'EA nuovo e' un fork del core
   **Nasdaq**: percio' esiste il canarino (b).
3. **La modalita' 2 e' codice nuovo, non un alias.** Il motore vivo ha
   `OPENCONFIRM` (la candela **APRE** oltre il livello); la firma chiede la
   **CHIUSURA** oltre il livello. Sulle aperture di sessione, dove il salto fra
   chiusura e apertura e' la norma, **le due regole non coincidono**.

### 3.3 🧯 L'asimmetria dichiarata: lo slippage
`InpSlippagePts` nel motore peggiora l'entry **dei soli ordini STOP** (righe
930 e 955 del sorgente vivo). In R83 e' **0 su tutte le celle**: quindi **la
modalita' 0 e' avvantaggiata**. Se vince lei, serve un **giro 2** con un
valore **misurato** (non inventato), altrimenti la vittoria resta con
l'asterisco. Se vincono la 1 o la 2, hanno vinto **nonostante** il vantaggio
dell'avversaria e il giro 2 e' inutile.

## 4. 🧪 L'EA NUOVO — cosa e' stato scritto, e cosa NON e' verificato

`mql5/Experts/ABTG_Apertura_3Ingressi.mq5` (fork del tutto-in-uno del Nasdaq):
- nuovo enum a **tre** membri (`InpEntryMode` 0/1/2) tradotto in `OnInit`
  nella modalita' interna del motore (`gEntryMode`), come **prima** istruzione;
- **modalita' 2 nuova**: `ArmCloseConfirm` + `MonitorCloseConfirm`, con la
  decisione isolata in una funzione **pura** (`DirezioneDaChiusura`) proprio
  per poterla provare con numeri finti;
- **autotest `[3ING][AUTOTEST]`** in `OnInit`: sei controlli sulla modalita' 2
  (chiusura sopra / dentro / sotto / **esattamente sul livello** / bias
  contrario / lato vietato) piu' la riga che dice quale modalita' e' attiva;
- **guardia sui magic**: l'EA **si rifiuta di partire** su un magic di una
  sedia di apertura (770101/103/121/201/202/203/204). Senza, un magic
  sbagliato lo farebbe gestire (parziale, breakeven, trailing, flat) le
  posizioni di quella sedia;
- **avviso filtri**: se in R83 qualcuno accende un filtro, l'EA lo scrive nel
  log e la cella si butta;
- **ASCII puro**, zero emoji (regola di casa, imparata sui `.ps1`).

> 🔴 **NON VERIFICATO, e va detto per primo: l'EA NON E' STATO COMPILATO.**
> Qui non c'e' MetaEditor. Sono stati fatti solo controlli meccanici (parentesi
> e graffe bilanciate a parita' col sorgente d'origine, zero byte non-ASCII,
> nessun nome di parametro inventato). **Il primo gesto sul PC e' compilare**:
> se non compila, tutto il resto di R83 non esiste.

## 5. 📋 LE RIGHE DI LANCIO — **BOZZE**, da far passare dal verificatore

Tutte con i tre pezzi obbligatori (`Remove-Item` / `irm -ErrorAction Stop` /
marcatore) e la guardia `$LASTEXITCODE -ne 0` (punti 8 e 13 della checklist).

### 5.0 PASSO 0 — la profondita' dei TICK (viene PRIMA di tutto)
```powershell
$h="2458b33415f6120c3bee0cd7f0ba9b9ab26d4d1b"
$p="$env:USERPROFILE\scarica_storico.ps1"
Remove-Item $p -ErrorAction SilentlyContinue
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$h/backtest_pipeline/scarica_storico.ps1" -OutFile $p -ErrorAction Stop
if(-not (Select-String -Path $p -SimpleMatch -Pattern 'scarica lo STORICO dal broker e dice' -Quiet)){ throw 'SCRIPT VECCHIO' }
$global:LASTEXITCODE=0
& $p -Simboli "NASUSD,D30EUR" -Da 2024.01.01 -TimeoutMin 180 -Auto
```
**Cosa leggere nel referto** (`Desktop\storico_bcm\ABTG_StoricoScaricato.csv`):
le righe **`NASUSD,TICK`** e **`D30EUR,TICK`**, colonna **`PrimaDataLocale`**.
**Non** le righe `M1`. Se quella data e' **dopo** il 2024.09.26, la finestra
dei file prova va riscritta prima di girare qualunque cosa.
`-TimeoutMin 180` non e' decorativo: il default e' 90 minuti e allo scadere lo
script **ammazza MT5 e esce 0** (difetto n.19).

### 5.1 R84 — giro a vuoto (non apre MT5)
```powershell
$h="2458b33415f6120c3bee0cd7f0ba9b9ab26d4d1b"
$p="$env:USERPROFILE\lancia_r84.ps1"
Remove-Item $p -ErrorAction SilentlyContinue
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$h/backtest_pipeline/lancia_r84.ps1" -OutFile $p -ErrorAction Stop
if(-not (Select-String -Path $p -SimpleMatch -Pattern 'ROUND 84 - ABLAZIONE DEI FILTRI' -Quiet)){ throw 'SCRIPT VECCHIO' }
$global:LASTEXITCODE=0
& $p -Rif $h -SoloControllo
if($LASTEXITCODE -ne 0){ throw 'R84 GIRO A VUOTO FALLITO: guarda le righe rosse sopra' }
```

### 5.2 R84 — canarino (la sola cella A) e poi tutte e nove
```powershell
& $p -Rif $h -Solo A          # canarino: una cella sola
& $p -Rif $h                  # le nove celle
```
(stesso `$p` e `$h` della 5.1, nella stessa finestra di PowerShell)

### 5.3 R83 — giro a vuoto, canarini, duello
```powershell
$h="2458b33415f6120c3bee0cd7f0ba9b9ab26d4d1b"
$q="$env:USERPROFILE\lancia_r83.ps1"
Remove-Item $q -ErrorAction SilentlyContinue
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$h/backtest_pipeline/lancia_r83.ps1" -OutFile $q -ErrorAction Stop
if(-not (Select-String -Path $q -SimpleMatch -Pattern 'ROUND 83 - DUELLO DEGLI INGRESSI' -Quiet)){ throw 'SCRIPT VECCHIO' }
$global:LASTEXITCODE=0
& $q -Rif $h -SoloControllo
if($LASTEXITCODE -ne 0){ throw 'R83 GIRO A VUOTO FALLITO' }
& $q -Rif $h -Solo "N0"        # canarino (a): deve coincidere con R84 cella A
& $q -Rif $h -Solo "D1,V"      # canarino (b): D1 e V devono coincidere
& $q -Rif $h                   # le sette celle
```

### 5.4 L'autotest dell'EA nuovo — NON e' una riga di PowerShell
Le righe `[3ING][AUTOTEST]` le stampa `OnInit`: **F7 compila e basta, non
esegue niente** (difetto n.20). Si leggono cosi':
1. il **driver** copia l'EA in `MQL5\Experts` e lo compila (succede da solo al
   primo `-Solo N0`);
2. poi, **nel tester**, un **test singolo** (non un'ottimizzazione) su NASUSD
   M15, qualche giorno, e nella scheda Journal ci sono le sei righe.
   **Mai attaccare l'EA a un grafico**: sul PC di backtest il terminale e'
   collegato al conto vivo.

## 6. ⏱️ LE STIME — dichiarate come STIME, e non sono misurate

> ⚠️ **In casa non esiste una misura di quanto costa un backtest a tick reali
> su un indice**: i round tick-reali documentati sono su forex. Quindi i numeri
> qui sotto sono **[STIMA NON MISURATA]** e il **canarino serve proprio a
> sostituirli con un numero vero**.

| passo | stima |
|---|---|
| PASSO 0 (storico + tick, 2 simboli) | **30-180 min** [STIMA] |
| giro a vuoto (per round) | 1-2 min |
| canarino R84 (cella A) | **20-60 min** [STIMA] |
| R84 completo (9 celle) | **3-9 ore** [STIMA] = 9 x il canarino |
| canarino R83 (N0, poi D1+V) | **40-150 min** [STIMA] |
| R83 completo (7 celle) | **2-7 ore** [STIMA] |

**Come si trasformano in numeri veri:** dopo il canarino si guarda l'orologio
e si moltiplica. **Non serve nessun `-TimeoutMin`** per i round:
`walkforward_generico.ps1` lancia MT5 con `WaitForExit()` **senza limite**
(riga 633) — e non gliene aggiungiamo uno, perche' un timeout che ammazza MT5
a meta' e' il difetto n.19 fatto in casa. Il `-TimeoutMin` serve **solo** al
PASSO 0, ed e' nella riga.

## 7. 🗺️ ORDINE CONSIGLIATO SUL PC (domani c'e' anche HistData)

**UNA MACCHINA, UN LAVORO: c'e' un solo MT5.** HistData/Dukascopy e i round
**non possono** girare insieme.

1. **PASSO 0** (MT5 chiuso, 30-180 min). Apre e chiude MT5 da solo.
2. **Compilazione + autotest dell'EA nuovo** (5-10 min): e' il gesto piu'
   economico che puo' fermare tutto il resto. **Se non compila, si riscrive
   qui e si ricomincia da 1** senza aver bruciato ore.
3. **Giri a vuoto** di R84 e R83 (2-4 min in tutto).
4. **Canarino R84 cella A** → da qui esce la stima vera.
5. **Canarino R83 N0** → e **subito il confronto con la cella A**. Se i numeri
   non coincidono, **si ferma tutto**: e' il momento piu' informativo di
   entrambi i round e costa un'ora.
6. **HistData** (se e' la finestra buona: e' lungo e non usa il tester in
   modo esclusivo solo se non tocca MT5 — se lo tocca, va **prima** o
   **dopo**, mai in mezzo a un round).
7. **R84 completo** (3-9 ore, di notte).
8. **R83 completo** (2-7 ore, la notte dopo).

**Perche' R84 prima di R83:** R84 chiude un **debito gia' aperto** e la sua
cella A e' il **metro** del canarino di R83. Girare R83 per primo vuol dire
avere il duello senza il suo controllo.

## 8. ✅ AUTOVERIFICA SUI 20 PUNTI DELLA CHECKLIST

| # | punto | come e' stato rispettato |
|---|---|---|
| 1 | apro lo script | letti `lancia_r81/r82`, `walkforward_generico`, i due EA vivi, `scarica_storico` |
| 2 | difetti gemelli | il difetto n.14 di `lancia_r81` (giro a vuoto che esce 0) e' corretto in **tutti e due** i driver nuovi |
| 3 | il file dei parametri e' quello giusto | i 16 file prova **VERIFICANO** una cella congelata, non cercano: unico asse `Y` = i magic gemelli |
| 4 | il SHA contiene la correzione | verificato con `git log -1 -- <file>` su tutti e sette i pezzi |
| 5 | giro a vuoto se c'e' `-Prova` | previsto e obbligatorio in entrambe le righe |
| 5b | cultura invariante | nessun numero dei CSV convertito; le uniche date parsate usano `ParseExact` + `InvariantCulture` |
| 6 | cache di raw ~5 min | pin all'**hash**, non al branch, + marcatore `Select-String` |
| 7 | MT5 chiuso | guardia `Get-Process terminal64` in entrambi i driver + detto nella riga |
| 8 | l'`irm` che fallisce | i tre pezzi (Remove-Item / `-ErrorAction Stop` / marcatore) in ogni riga |
| 9 | sicurezza del gemello | i driver nuovi hanno **tutto** quello che ha `lancia_r82` (guardia MT5, pin, marcatori, pulizia anteprime, raccolta, zip, referto con `data:`) **piu'** il PASSO 0 |
| 10 | `Stop` + cicli di file | le copie sono in `try/catch`, il referto si scrive comunque |
| 11 | whitelist vs blacklist | non si sposta nessun file di Claudio |
| 12 | backup senza guardia | nessuno script qui sovrascrive backup |
| 13 | `exit 1` e coda che tira dritto | `$global:LASTEXITCODE=0` **prima**, controllo `-ne 0` **dopo** |
| 14 | giro a vuoto che esce 0 lo stesso | l'uscita dipende da `$falliti` **e** dalle anteprime prodotte |
| 15 | rilancio mirato che non rilancia | `-Rifai` **inoltrato** al driver e spiegato nel messaggio finale |
| 16 | cache di ripresa avvelenata | nessuna cache di ripresa in questi script |
| 17 | interprete dato per presente | nessuna dipendenza esterna oltre PowerShell e MT5 (quest'ultimo verificato) |
| 18 | profondita' misurata sul TF sbagliato | **e' il PASSO 0**: si legge la riga `TICK`, e il driver **si ferma** se i tick partono dopo la finestra |
| 19 | timeout piu' corto della stima | `-TimeoutMin 180` sul PASSO 0; per i round non esiste timeout e il perche' e' scritto |
| 20 | collaudo che con quel tasto non esce | l'autotest si legge **eseguendo** un test singolo, e c'e' scritto chi installa l'EA e quando |

## 9. 🧾 COSA RESTA APERTO (dichiarato, non nascosto)

1. **L'EA nuovo non e' compilato.** Primo gesto sul PC.
2. **La profondita' dei tick degli indici e' ignota.** Se non ci sono, i due
   round si girano a `-Modello 1` **e ogni numero porta scritto "OHLC, non
   tick"** (l'illusione OHLC ha gia' revocato una promozione in questa casa).
3. **Il campione sara' sottile.** 21 mesi, un ciclo al giorno: i 150 trade
   dell'Emendamento non sono raggiungibili, e infatti **nessuno dei due round
   SELEZIONA** una cella — confrontano. Sotto 30 operazioni il merito e'
   sospeso (valvola R59), il rischio no.
4. **Un difetto trovato nei motori VIVI, non corretto** (la missione vietava
   di toccarli): in `ArmRetest` e `ArmOpenConfirm` il caso *"range fuori dai
   limiti: niente trade"* torna `true`, la fase diventa `PH_ARMED` e il
   monitor gira lo stesso. Con `InpMinRangePts`/`InpMaxRangePts` a **0** —
   cioe' come girano tutte le nostre celle e le sedie vive — **e' inerte**;
   diventerebbe vivo il giorno in cui qualcuno accendesse quei due filtri di
   ampiezza. Nel codice **nuovo** (modalita' 2) e' scritto giusto, con il
   commento che lo dice. **Va messo in coda come riga a se'.**
5. **Il preset `mql5/Presets/ABTG_Nasdaq_Apertura_US.set` e' piu' vecchio del
   sorgente** (gli mancano meta' degli input di oggi) e dice
   `InpUseNewsFilter=true` mentre in campo era spento. Per questo la cella A
   di R84 e' dichiarata come *"configurazione di riferimento del round"* e
   **non** come *"la sedia viva"*.
6. **Nessuno dei due round promuove niente.** Il forward passa dal processo
   completo: prova di regime, walk-forward, contratto (DD e frequenza),
   firma di Claudio. E per R83, **al massimo una modalita' per mercato**.

---

_Preparato il 18/08/2026 sera. Commit a pezzi per l'onda di 529: se manca un
pezzo, il git dice esattamente dove ci si era fermati._
