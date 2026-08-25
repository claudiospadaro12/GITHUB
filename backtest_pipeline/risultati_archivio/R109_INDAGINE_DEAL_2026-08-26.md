# R109 — INDAGINE SUI "DEAL ANOMALI"

**Data:** 2026-08-26  
**Oggetto:** i 34 "deal ANOMALI" dichiarati dal driver R109 su 5 celle su 6, e il
disaccordo sul conteggio `n` fra report `.htm` e CSV OPTFRAME.  
**Materiale:** `backtest_pipeline/risultati_archivio/R109_deal_anomali/` (6 CSV
per-trade + report `.htm` D30EUR long), zip completo della corsa (tutti gli
`.htm`), `REFERTO_DRIVER_R109_20260825.txt`, `backtest_pipeline/righe/RIGA_R109_ATREXH.ps1`,
`mql5/Experts/ABTG_AtrExhaustVol.mq5`.  
**Metodo:** riparsing indipendente dei sei `.htm` in Python + **riproduzione
riga-per-riga** del ciclo `Passo0` del driver (righe 718-748 del `.ps1`).

---

## 1. VERDETTO IN UNA RIGA

> **I deal anomali NON ESISTONO.** I sei report `.htm` contengono sequenze
> `in`/`out` **perfettamente alternate, con volumi identici a ogni coppia,
> senza una singola eccezione**. Il difetto e' **del PARSER del driver**, ed e'
> `Sort-Object Ora` alla riga 710: **`Sort-Object` di PowerShell NON E'
> STABILE**, e sui deal che condividono lo **stesso secondo** ne inverte
> l'ordine. Ogni inversione fa sembrare la sequenza spaiata.

L'EA e' pulito. Il tester e' pulito. I numeri della tabella madre sono buoni.

---

## 2. LA PROVA

### 2.1 Il riparsing indipendente: zero anomalie in tutti e sei

Estratti i deal dalla tabella **`Affari`** di ogni `.htm` (il report e' in
italiano: la sezione si chiama `Affari`, non `Deals`), **nell'ordine nativo del
file** — che e' l'ordine di ticket, cioe' gia' cronologico:

| cella | deal `in` | deal `out` | coppie pulite | volumi discordi | n OPTFRAME |
|---|---|---|---|---|---|
| D30EUR long  | 818 | 818 | **818** | 0 | 818 |
| D30EUR short | 927 | 927 | **927** | 0 | 927 |
| U30USD long  | 886 | 886 | **886** | 0 | 886 |
| U30USD short | 923 | 923 | **923** | 0 | 923 |
| NASUSD long  | 655 | 655 | **655** | 0 | 655 |
| NASUSD short | 743 | 743 | **743** | 0 | 743 |

Nessun `in` doppio, nessun `out` orfano, nessun `in/out` (reversal), nessuna
chiusura parziale. **E il conteggio coincide con l'OPTFRAME in tutte e sei le
celle.**

### 2.2 La riproduzione esatta del difetto

Tradotto in Python il ciclo `Passo0` del driver e applicato ai deal veri:

- **ordine nativo dell'htm** (= quello che darebbe un sort *stabile*):
  `n` corretto e **anomalie = 0** su tutte e sei le celle;
- **scambiando i deal che condividono lo stesso secondo** si riproducono
  **esattamente** i numeri del referto:

| cella | gruppi a pari secondo | gruppi scambiati | n prodotto | anom prodotte | referto |
|---|---|---|---|---|---|
| D30EUR long  | 3 | 3 di 3 | 815 | 6  | n=815, anom=6  **coincide** |
| D30EUR short | 6 | 6 di 6 | 921 | 13 | n=921, anom=13 **coincide** |
| U30USD long  | 1 | 1 di 1 | 885 | 2  | n=885, anom=2  **coincide** |
| U30USD short | 4 | 3 di 4 | 920 | 7  | n=920, anom=7  **coincide** |
| NASUSD long  | **0** | — | 655 | **0** | n=655, anom=0 **coincide** |
| NASUSD short | 3 | 3 di 3 | 740 | 6  | n=740, anom=6  **coincide** |

**Sei celle su sei riprodotte al numero esatto**, comprese le due con anomalie
*dispari* (13 e 7) che erano il dettaglio piu' difficile da spiegare.

### 2.3 Perche' i conti tornano — l'aritmetica

Due forme di collisione, e ognuna ha la sua firma:

- **tipo A — `in` e `out` nello stesso secondo** (posizione aperta e stoppata
  entro il secondo). Scambiata diventa `out, in`: l'`out` arriva a posizione
  chiusa (`anom++`, e **`n` NON viene incrementato**), poi l'`in` resta appeso e
  fa scattare il "due `in` di fila" sul trade successivo (`anom++`).
  **Costo: 2 anomalie, 1 operazione persa.**
- **tipo B — `out` di un trade e `in` del successivo nello stesso secondo**.
  Scambiata: `anom++` per il doppio `in`, poi `anom++` perche' il volume
  dell'`out` non e' quello dell'`in` appena registrato (ed e' **il ramo "volume
  diverso"**, riga 732 — che invece incrementa `n`), poi `anom++` per l'`out`
  finale orfano. **Costo: 3 anomalie, 1 operazione persa.**

Quindi `anomalie = 2·A + 3·B` e `n_htm = n_vero − (A+B)`. Le due celle con
anomalie dispari (D30EUR short 13, U30USD short 7) sono **esattamente** le due
che hanno un gruppo di tipo B. La nota aritmetica del mandante
(`n_csv − n_htm ≈ anomalie/2`) era **giusta**, e questo e' il termine esatto che
le mancava.

Su U30USD short 3 gruppi su 4 risultano scambiati e uno no: e' precisamente il
comportamento **arbitrario** di un sort non stabile — non c'e' altro da
spiegare, e anzi e' la firma che conferma la diagnosi.

**Il bilancio complessivo**: nei sei report esistono **17 gruppi a pari
secondo** (15 di tipo A, 2 di tipo B). Di questi il sort ne ha invertiti **16**
(14 A + 2 B), producendo `2·14 + 3·2 =` **34 false anomalie** e **16 operazioni
perse** — esattamente i totali del referto del 25/08.

### 2.4 NASUSD long, il caso pulito

Non ha nulla di diverso nella logica: **ha zero deal che condividono un
secondo**. E' l'unica cella in cui il sort non aveva pari da rimescolare. Il
controllo positivo perfetto.

---

## 3. LE RIGHE VERE (dai report `.htm`, sezione `Affari`)

Tutti e 12 i gruppi a pari secondo. **Si noti che in ogni coppia i volumi
coincidono** (tipo A): non c'e' nessuna chiusura parziale.

**D30EUR long** (3 gruppi, tutti tipo A)
```
2024.12.23 09:00:00 | aff  220 | D30EUR | buy  | in  | vol 86.6 | px 19869.20 | prof     0.00 | R109 ATREXH D30EUR L L
2024.12.23 09:00:00 | aff  221 | D30EUR | sell | out | vol 86.6 | px 19858.60 | prof  -917.96 | sl 19858.60
2025.02.25 08:45:00 | aff  358 | D30EUR | buy  | in  | vol  100 | px 22317.90 | prof     0.00 | R109 ATREXH D30EUR L L
2025.02.25 08:45:00 | aff  359 | D30EUR | sell | out | vol  100 | px 22314.70 | prof  -320.00 | sl 22315.20
2026.01.14 16:00:00 | aff 1136 | D30EUR | buy  | in  | vol  100 | px 25289.10 | prof     0.00 | R109 ATREXH D30EUR L L
2026.01.14 16:00:00 | aff 1137 | D30EUR | sell | out | vol  100 | px 25285.50 | prof  -360.00 | sl 25286.00
```

**D30EUR short** (6 gruppi: 5 tipo A + 1 tipo B)
```
2025.01.02 09:00:00 | aff  222 | D30EUR | sell | in  | vol 44.6 | px 19936.50 | prof     0.00 | R109 ATREXH D30EUR S S
2025.01.02 09:00:00 | aff  223 | D30EUR | buy  | out | vol 44.6 | px 19955.50 | prof  -847.40 | sl 19955.20
2025.02.13 09:00:00 | aff  370 | D30EUR | sell | in  | vol 71.7 | px 22439.70 | prof     0.00 | R109 ATREXH D30EUR S S
2025.02.13 09:00:00 | aff  371 | D30EUR | buy  | out | vol 71.7 | px 22449.00 | prof  -666.81 | sl 22447.70
2025.04.29 08:00:00 | aff  562 | D30EUR | sell | in  | vol 29.6 | px 22347.60 | prof     0.00 | R109 ATREXH D30EUR S S
2025.04.29 08:00:00 | aff  563 | D30EUR | buy  | out | vol 29.6 | px 22367.50 | prof  -589.04 | sl 22366.00
2025.07.31 08:00:00 | aff  858 | D30EUR | sell | in  | vol 32.3 | px 24363.70 | prof     0.00 | R109 ATREXH D30EUR S S
2025.07.31 08:00:00 | aff  859 | D30EUR | buy  | out | vol 32.3 | px 24378.70 | prof  -484.50 | sl 24378.60
2026.04.22 09:00:00 | aff 1593 | D30EUR | buy  | out | vol 15.7 | px 24304.70 | prof   700.22 | tp 24305.10     <-- TIPO B
2026.04.22 09:00:00 | aff 1594 | D30EUR | sell | in  | vol  9.3 | px 24303.30 | prof     0.00 | R109 ATREXH D30EUR S S
2026.05.13 08:00:00 | aff 1632 | D30EUR | sell | in  | vol 61.6 | px 24171.80 | prof     0.00 | R109 ATREXH D30EUR S S
2026.05.13 08:00:00 | aff 1633 | D30EUR | buy  | out | vol 61.6 | px 24186.80 | prof  -924.00 | sl 24178.20
```

**U30USD long** (1 gruppo, tipo A)
```
2025.04.01 15:00:01 | aff  504 | U30USD | buy  | in  | vol   44 | px 41708.00 | prof     0.00 | R109 ATREXH U30USD L L
2025.04.01 15:00:01 | aff  505 | U30USD | sell | out | vol   44 | px 41688.50 | prof  -795.49 | sl 41690.00
```

**U30USD short** (4 gruppi: 3 tipo A + 1 tipo B)
```
2024.10.29 09:30:00 | aff   84 | U30USD | sell | in  | vol  100 | px 42382.50 | prof     0.00 | R109 ATREXH U30USD S S
2024.10.29 09:30:00 | aff   85 | U30USD | buy  | out | vol  100 | px 42388.20 | prof  -526.85 | sl 42386.50
2025.08.14 13:30:01 | aff  921 | U30USD | buy  | out | vol 34.3 | px 44879.10 | prof  1866.79 | tp 44883.30     <-- TIPO B
2025.08.14 13:30:01 | aff  922 | U30USD | sell | in  | vol 10.5 | px 44873.50 | prof     0.00 | R109 ATREXH U30USD S S
2025.09.26 07:45:00 | aff 1028 | U30USD | sell | in  | vol  100 | px 46045.80 | prof     0.00 | R109 ATREXH U30USD S S
2025.09.26 07:45:00 | aff 1029 | U30USD | buy  | out | vol  100 | px 46049.00 | prof  -274.09 | sl 46048.20
2025.09.26 14:00:00 | aff 1030 | U30USD | sell | in  | vol  100 | px 46185.60 | prof     0.00 | R109 ATREXH U30USD S S
2025.09.26 14:00:00 | aff 1031 | U30USD | buy  | out | vol  100 | px 46190.70 | prof  -436.51 | sl 46190.60
```

**NASUSD short** (3 gruppi, tutti tipo A)
```
2025.01.24 15:45:00 | aff  304 | NASUSD | sell | in  | vol  100 | px 21912.50 | prof     0.00 | R109 ATREXH NASUSD S S
2025.01.24 15:45:00 | aff  305 | NASUSD | buy  | out | vol  100 | px 21915.40 | prof  -276.39 | sl 21915.30
2025.02.05 16:00:00 | aff  340 | NASUSD | sell | in  | vol 72.9 | px 21466.30 | prof     0.00 | R109 ATREXH NASUSD S S
2025.02.05 16:00:00 | aff  341 | NASUSD | buy  | out | vol 72.9 | px 21483.60 | prof -1208.89 | sl 21483.30
2025.06.06 13:30:00 | aff  600 | NASUSD | sell | in  | vol 65.7 | px 21644.10 | prof     0.00 | R109 ATREXH NASUSD S S
2025.06.06 13:30:00 | aff  601 | NASUSD | buy  | out | vol 65.7 | px 21681.60 | prof -2159.93 | sl 21660.10
```

**NASUSD long**: nessun gruppo. Nessuna anomalia. (Controllo positivo.)

---

## 4. LE IPOTESI DEL MANDATO, VAGLIATE UNA A UNA

| # | ipotesi | esito | prova |
|---|---|---|---|
| (a) | chiusura parziale del tester / lotto ridotto | **ESCLUSA** | in ogni coppia `in`/`out` il volume e' **identico**; i `position_id` del CSV per-trade sono **tutti unici** (818/818, 927/927, ...): un solo `out` per posizione |
| (b) | posizione aperta a fine test chiusa d'ufficio | **VERA ma INNOCENTE** | esiste, ma solo su **2 celle** e non genera anomalie (vedi 4.1) |
| (c) | stop-out per margine | **NESSUNA TRACCIA** | nessun deal di tipo diverso da `buy`/`sell`, nessun commento di stop-out, nessuna sequenza di chiusure in blocco |
| (d) | buco nella logica "una alla volta" dell'EA | **ESCLUSA** | non c'e' un solo `in` doppio nei 9904 deal (4952 andata-e-ritorno). Il codice regge: `OnNewBar()` fa `if(CountPositions()>0) return;` (riga 469) e le decisioni girano **solo a barra chiusa** (`if(!IsNewBar()) return;`, riga 443) |
| (e) | formato dell'htm che il parser non conosce | **ESCLUSA** | il parser legge bene: colonne riconosciute, numeri convertiti, `Illeggibile` = 0 (altrimenti sarebbe uscito l'altro messaggio, righe 756-758). Legge **tutti** i deal e li legge **giusti** — poi li **rimescola** |
| **(f)** | **`Sort-Object` non stabile sui pari-secondo** | **PROVATA** | riprodotta al numero esatto su 6 celle su 6 (par. 2.2) |

### 4.1 La chiusura d'ufficio a fine test (ipotesi b) — esiste, ed e' un fatto a parte

Nei CSV per-trade compaiono **due** deal con `magic = 0`:

```
D30EUR short : 2026.08.20 23:59:55 ; D30EUR ; magic 0 ; position_id 1854 ; vol 2.80 ; px 25984.40 ; net +53.76
U30USD short : 2026.08.20 23:59:46 ; U30USD ; magic 0 ; position_id 1846 ; vol 2.30 ; px 52805.50 ; net +667.35
```

Sono l'**ultimo** deal della rispettiva cella, all'ultimo istante della
finestra: la posizione ancora viva chiusa dal tester (magic 0 = non l'ha chiusa
l'EA). E' normale e va saputo, ma **non c'entra con le anomalie**: nell'`.htm`
sono coppie `in`/`out` regolari, e il parser le ha contate correttamente.
Da dichiarare come tale: **2 celle su 6 contengono 1 operazione chiusa
d'ufficio**, quindi con un'uscita che non e' quella della strategia.

---

## 5. IL DIFETTO, IN CODICE

`backtest_pipeline/righe/RIGA_R109_ATREXH.ps1`, riga **710**:

```powershell
$ordinati = @($deal | Sort-Object Ora)
```

`Sort-Object` di PowerShell **non e' stabile** (in PowerShell 7 e' stato
aggiunto `-Stable` proprio per questo; in Windows PowerShell 5.1 il parametro
non esiste). Su chiavi uguali l'ordine di uscita e' **arbitrario**.

E l'ordinamento **non serviva**: i deal arrivano dall'`.htm` gia' in ordine di
ticket, che e' cronologico e — a differenza dell'orario — **non ha pari**.
Il sort e' un gesto difensivo che ha introdotto il difetto che voleva evitare.

**Correzione (una riga, da fare quando il driver R109 si tocca):**

```powershell
#  NIENTE Sort-Object: i deal dell'htm sono gia' in ordine di TICKET, che e'
#  cronologico e SENZA PARI. Sort-Object NON E' STABILE e sui deal che
#  condividono il SECONDO (apertura e stop nello stesso secondo, oppure
#  chiusura e riapertura nello stesso secondo) ne inverte l'ordine: la
#  sequenza in/out sembra spaiata e il Passo 0 si autodichiara NON
#  AFFIDABILE. MISURATO su R109: 34 false anomalie e 16 operazioni perse su
#  5 celle (indagine del 26/08).
$ordinati = @($deal)
```

Se un ordinamento lo si vuole comunque, deve avere una **chiave di spareggio**
che non abbia pari — il numero dell'`Affare`:
`Sort-Object Ora, @{Expression={[long]$_.Affare}}` (e allora la colonna
`Affare` va letta e conservata da `LeggiDeal`, che oggi la scarta).

### 5.1 Classe di difetto per la checklist

E' **parente del punto 70** ("ordine promesso = ordine reale di
`Sort-Object`") ma **non e' lo stesso**: il 70 dice che `Sort-Object`
**ordina** dove credevi solo deduplicasse. Questo dice che `Sort-Object`
**riordina anche cio' che era gia' in ordine**, quando la chiave ha dei pari.
Il 70 si scopre confrontando una stringa a schermo; questo **non si vede
affatto**, perche' produce un messaggio d'errore *plausibile* ("deal anomali,
non dovrebbe succedere") che punta sull'EA invece che sul parser.

> **REGOLA proposta:** in PowerShell, `Sort-Object` su una chiave che **puo'
> avere pari** e' un riordino arbitrario. O si aggiunge una chiave di
> spareggio univoca, o non si ordina affatto se il dato arriva gia' ordinato.
> E vale doppio per i **timestamp al secondo**: su dati di mercato i pari
> **ci sono sempre**.

### 5.2 La guardia ha funzionato, e va detto

Il driver **non ha inventato numeri**: si e' accorto che qualcosa non tornava,
ha rifiutato di dare le misure del Passo 0, ha scritto `n/d` invece di zeri, e
ha messo dieci righe nei PROBLEMI. **Ha sbagliato la diagnosi, non il
comportamento** — e ha fatto puntare il dito sull'EA, che era innocente.
La classificazione "anomalo" non e' *troppo stretta*: e' **giusta**, ed e'
l'**input** a essere stato corrotto prima di arrivarci.

---

## 6. I NUMERI DELLA TABELLA MADRE SONO AFFIDABILI?

**SI**, per quanto riguarda questa indagine. `n` ha ora **tre testimoni
indipendenti che concordano**:

1. il **CSV OPTFRAME** del tester (818, 927, 886, 923, 655, 743);
2. il **conteggio dei deal `out` nell'`.htm`**, riparsato qui da zero;
3. il **CSV per-trade scritto dall'EA stesso** in `OnDeinit` via
   `HistoryDealGetTicket` / `DEAL_ENTRY_OUT` (`ExportTrades()`, righe 1062-1087
   del `.mq5`): 818, 927, 886, 923, 655, 743 righe — **stessi numeri**.

Il parser dell'`.htm` e' l'**unico** dei quattro a dissentire, ed e' quello di
cui e' provato il difetto. **Il conteggio giusto e' quello dell'OPTFRAME.**

### 6.1 Il verdetto di RISCHIO del round NON e' toccato

Da dichiarare esplicitamente, perche' e' la domanda che conta:

> **DD 44-68% e peggior giornata -9,72% (U30USD short) vengono dai CSV
> OPTFRAME**, cioe' dalla curva di equity del tester, che **non passa dal
> parser dei deal**. Questa indagine **non li tocca, non li attenua e non li
> peggiora.** Restano in piedi tali e quali.

Anzi: ora che l'allarme "deal anomali" e' spiegato, **non c'e' piu' nessuna
scusa tecnica** con cui rimandare la lettura di quei drawdown. Il round R109
resta quello che era — un motore controtendenza che in un solo regime
rialzista, senza out-of-sample, ha perso su tutte e sei le celle con drawdown
da 44% a 68%. **Il merito resta sospeso per costruzione** (Emendamento B,
criteri par. 7); **il rischio si legge tutto, ed e' pessimo.**

### 6.2 Cosa si RIGUADAGNA

Le misure del **Passo 0** (take mediano, perdita mediana, durata, frequenza,
cap giornaliero, peggior giornata dall'`.htm`) erano state dichiarate
`n/d` su 5 celle **solo** per questo difetto. Con la correzione **tornano
disponibili senza rigirare i backtest**: bastano gli `.htm` gia' in archivio.
Con essi torna anche il **secondo testimone** su G4 — e vale la pena guardarlo,
perche' sulla sola cella dove esisteva le due viste **gia' divergevano**
(NASUSD long: htm **-4,30%** contro csv **-4,57%**), e il referto stesso dice
che se divergono e' un'informazione.

---

## 7. CONSEGUENZE

### Per il driver R109 (`RIGA_R109_ATREXH.ps1`)
1. **Correggere la riga 710** come al par. 5. E' l'unica modifica necessaria.
2. **Rigirare il solo Passo 0** sugli `.htm` gia' archiviati per recuperare le
   misure delle 5 celle. **Non serve rifare i backtest.**
3. Aggiungere la classe di difetto del par. 5.1 alla checklist.
4. Cercare `Sort-Object` con chiave a pari **negli altri driver** (R108, R110,
   R111, `walkforward_*.ps1`): stesso gesto, stesso rischio latente.
   *Non l'ho fatto in questo giro — agenti in volo su quei file.*

### Per l'EA (`ABTG_AtrExhaustVol.mq5`)
5. **Nessuna modifica.** Non e' stato toccato, e non c'e' ragione di toccarlo
   **per questo motivo**. La logica "una posizione alla volta" **regge sui
   4952 deal misurati**, e l'autotest A0 7/7 e' coerente con quanto osservato.
   L'accusa implicita del referto del 25/08 ("non dovrebbe succedere") va
   **ritirata**.

### Osservazioni collaterali emerse (fatti, non verdetti)
6. **Il lotto sbatte contro il tetto del simbolo** (`SYMBOL_VOLUME_MAX` = 100).
   `LotByRisk` chiude con `MathMax(mn,MathMin(mx,lot))` (riga 839): quando il
   rischio chiede piu' di 100 lotti, il lotto viene **tagliato verso il
   basso**, e quel trade rischia **meno** dell'1% dichiarato.
   Frequenza al tetto: D30EUR long 12/818 (1,5%), D30EUR short 9/927 (1,0%),
   U30USD long 9/886 (1,0%), U30USD short 20/923 (2,2%), NASUSD long 17/655
   (2,6%), **NASUSD short 66/743 (8,9%)**. Non e' un errore — e' conservativo —
   ma **rompe la normalizzazione del rischio**: su NASUSD short quasi un trade
   su undici non gira all'1%, e i DD di quella cella **non si riscalano
   linearmente** moltiplicando per 0,65. Da dichiarare ogni volta che si
   converte un numero di R109 al rischio di campo.
7. **Lotti medi enormi in assoluto** (mediana 13-32 lotti su indice): e' la
   conseguenza aritmetica di **stop molto stretti** con `InpMinSLPts` spento.
   Il referto del 25/08 lo segnalava gia' (R55, slippage) e i dati lo
   confermano: **15 posizioni su 4952** sono state **aperte e stoppate entro lo
   stesso secondo** — sono i gruppi di tipo A del par. 3.
8. **Slippage sugli stop, misurabile e non trascurabile.** Nelle righe del
   par. 3 alcuni stop sono stati riempiti **oltre** il livello: NASUSD short
   2025.06.06 SL a 21660,10 **eseguito a 21681,60** (21,5 punti indice oltre,
   -2159,93 su una perdita attesa attorno a -1000); D30EUR short 2026.05.13
   SL a 24178,20 **eseguito a 24186,80** (8,6 punti). Con lotti da 60-100 una
   scivolata cosi' **raddoppia la perdita nominale**. Il tester lo sta gia'
   mostrando **senza** modellare slippage aggiuntivo (e' puro gap sui tick).

---

## 8. COSA RESTA APERTO

- La prova finale del meccanismo sarebbe **eseguire** `Sort-Object Ora` su
  quei deal in Windows PowerShell 5.1 e vedere l'inversione con gli occhi.
  Qui non c'e' PowerShell: la prova e' **per riproduzione esatta** (6 celle su
  6, anomalie *e* conteggi, incluse le due dispari e il controllo positivo a
  zero). E' fortissima, ma resta **inferenza sul meccanismo**, non osservazione
  diretta. Chi ha una PowerShell puo' chiuderla in due minuti.
- **Non ho verificato gli altri driver** (agenti in volo su R110/R111).
- Restano in piedi tutte le riserve del referto del 25/08 che questa indagine
  **non tocca**: profondita' tick non misurata su D30EUR e NASUSD, spread
  dichiarato e non misurato, un solo regime, nessun out-of-sample.

---

*Indagine condotta sui file in archivio. Nessun file di R110/R111/RIGA_STORICO/
ABTG_VwapRevert e' stato letto o modificato. `ABTG_AtrExhaustVol.mq5` e' stato
**letto e non modificato**, come da mandato.*
