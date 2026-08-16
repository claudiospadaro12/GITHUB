# 🎯 CACCIA 2026-08-16 — C · `Nikkei225_Gap_Continuation_EA`, da 🟡 IN CODA a **lanciabile**

> **Non e' una caccia nuova.** E' il **punto 3 della coda**: finire un candidato
> gia' promosso in coda dalla seconda battuta, risolvendo le tre cose che gli
> impedivano di partire. I punti 1 e 2 sono chiusi (`ABTG_MeanRevert` bocciato
> in R60 — 12 celle su 12 in perdita, PF max 0,986, DD fino al 37%, famiglia
> chiusa; domini sbloccati e verificati).

**La riga che conta:**

> Il sorgente **non era nel repo**: la scheda del setaccio nasceva da un file
> passato a mano. L'ho **ripescato sul Code Base e riletto per intero** —
> 43.393 byte, 1.160 righe. Tutto quello che segue e' [VERIFICATO] sul
> sorgente scaricato, non copiato dalla scheda. **Due cose della scheda erano
> imprecise, una e' una buona notizia grossa, e ho trovato un blocco duro che
> nessuno aveva visto.**

---

## 0. 🎣 COSA HO RIAPERTO, E CON CHE ESITO

### Controllo positivo (§2) — fatto prima di cercare

| fonte | esito | prova |
|---|---|---|
| `mql5.com/en/code/mt5/experts` | 🟢 **PASSA** | HTTP 200, elenco reale. Fra i titoli in prima pagina ci sono **`Session Opening Range Breakout EA`** e **`Daily Zone Recovery EA mt5 for GOLD`**, cioe' due file **gia' setacciati** da noi: e' il bersaglio di cui conoscevo la risposta. ⚠️ La lista non espone autore/data lato server: quelli si leggono sulla scheda del singolo EA. |
| `WebSearch` con `site:mql5.com/en/code` | 🟢 **PASSA** | ha trovato la scheda giusta al primo colpo |
| pagina `/en/code/75301` | 🟢 **PASSA** | titolo, autore, data, descrizione |
| download `/en/code/download/75301/...mq5` | 🟢 **PASSA** | **HTTP 200, 43.393 byte** |

Non ho avuto bisogno di SSRN ne' di Forex Factory (i due bloccati da Cloudflare):
il bersaglio era uno solo e noto. **Nessuna fonte dichiarata non raggiunta**,
perche' nessuna serviva.

### ⚠️ Una discrepanza che dichiaro invece di nasconderla

Il titolo restituito dal motore di ricerca attribuiva l'EA a **`MauriyKiku`**.
**La pagina e il sorgente dicono un'altra cosa**, e valgono loro:

```
#property copyright "Francesc Jordi Mallol Nolden"     <- riga 6 del .mq5
```
Pagina `/en/code/75301`: autore **Francesc Jordi Mallol Nolden**, **24/07/2026
10:56**, 1.667 visualizzazioni, versione **1.50**. La scheda del setaccio aveva
**ragione** sull'autore. Lo snippet del motore di ricerca **no** — ed e'
esattamente il motivo per cui il §1 pretende la pagina aperta.

---

## 1. 🧮 LA SCHEDA §7, RIFATTA SUL SORGENTE

```
NOME            Nikkei 225 Gap Continuation EA
FONTE / URL     MQL5 Code Base — https://www.mql5.com/en/code/75301
                sorgente: /en/code/download/75301/Nikkei225_Gap_Continuation_EA.mq5
AUTORE / DATA   Francesc Jordi Mallol Nolden — 24/07/2026 10:56 — v1.50
POPOLARITA'     1.667 visualizzazioni [VERIFICATO]. Download NON esposti dalla pagina.
LICENZA         🔴 NON DICHIARATA, ne' sulla pagina ne' nel sorgente.
                L'header generato porta ancora "Copyright 2020, CompanyName".
                Valgono i termini generali del Code Base, che NON ho verificato.
                -> uso interno di ricerca; da chiarire prima di distribuire.
RIGHE / INPUT   1.160 righe [VERIFICATO: wc -l]
                **31 input veri** + 8 `input group`  [VERIFICATO]

TESI IN UNA RIGA
  "Guadagna perche' dopo un gap abbastanza grande chi e' rimasto fuori dal
   movimento notturno insegue nella prima ora di seduta, e la rottura del
   range di apertura NELLA DIREZIONE DEL GAP e' il momento in cui quel-
   l'inseguimento diventa visibile."

MECCANICA
  ingresso  gap oltre soglia -> costruisce il range dei primi N minuti M1 ->
            entra alla rottura NEL VERSO DEL GAP, con prezzo dalla parte
            giusta del VWAP di seduta, entro 90' dall'apertura
  uscita    parziale 40% a 1R + breakeven, runner a 2R, uscita forzata 5'
            prima della chiusura di seduta
  stop      bordo OPPOSTO del range di apertura — VERO, mandato al broker

GESTIONE RISCHIO  % dell'equity · SL vero · UNA posizione · UN trade al giorno
BANDIERE ROSSE    **nessuna** (cercate tutte quelle del §4: martingala,
                  griglia, averaging, #import, DLL, WebRequest, iCustom,
                  ExpertRemove, SL virtuale, lotto fisso obbligato)
COSTO DI PORTING  ~0 ore di traduzione (e' gia' MQL5 nativo, CTrade).
                  ~1 ora di ADOZIONE: OnTester + intestazione + fuso.

PUNTEGGIO (0-2)
  [2] semplicita'            31 input, ma solo ~7 sono manopole di strategia
                             e qui ne restano 4 libere. Meccanica in 5 righe.
  [2] il filtro E' il motore  la direzione la decide IL SEGNO DEL GAP, non un
                             indicatore appiccicato sopra
  [2] tesi di mercato        scrivibile in una riga, e ne abbiamo il GEMELLO
                             OPPOSTO gia' misurato
  [2] riempie un BUCO        direzione mai misurata + motore simmetrico vero
                             (buco SHORT) + motore di apertura (CODA §5)
  [1] testabile senza riscritture  🔴 -1 perche' MANCA `OnTester`: senza,
                             il nostro driver rifiuta di partire

VERDETTO   9/10 -> **PROVA SUBITO**, appena chiuse le due misure aperte
PERCHE'    E' l'unico candidato arrivato finora che misura una direzione su
           cui non abbiamo NEMMENO UNA misura, sullo stesso simbolo e sullo
           stesso evento dove il gemello opposto e' promosso.
```

🔴 **L'autore non dichiara numeri di performance.** Non c'e' niente da
etichettare "dichiarato dall'autore, NON verificato" — e nemmeno la tentazione.

---

## 1-bis. 🔧 COSA TENGO (il motore) · COSA RIFACCIO (la gestione e la taratura)

_Sezione richiesta dal mandato §5.F del 16/08: **"il criterio non e' 'e' gia'
buono', e' 'il motore e' sano E noi sappiamo rifinirlo'"**._

Questo candidato e' **esattamente il caso d'uso di §5.F**, con una particolarita'
che va detta subito perche' e' inusuale: **il motore e' quello che ci serve, e la
gestione — di solito la parte scadente — qui e' gia' scritta nella nostra
grammatica.** Quello che va rifatto non e' la gestione: e' la **taratura** e la
**superficie di configurazione**.

### 🟢 COSA TENGO — il motore, ed e' tutta la ragione per cui il candidato esiste

| tengo | perche' |
|---|---|
| **la TESI**: dopo un gap grande, il movimento CONTINUA | ⭐ **e' la parte piu' rara e la parte che non copriamo.** Abbiamo il gemello opposto (`ABTG_GapFill`) promosso sullo stesso simbolo: questa direzione non ha **nemmeno una misura** |
| **la direzione decisa dal SEGNO DEL GAP** | il filtro **E' il motore**, non un cerotto (§5.B: 0 successi su 5 coi filtri appiccicati, 30 celle su 30 col filtro costitutivo) |
| **la conferma a due gambe**: rottura del range di apertura **+** lato giusto del VWAP di seduta | e' la struttura, non un indicatore aggiunto sopra |
| **l'annullamento al 50% del gap richiuso** | ⭐ e' il confine NETTO con `ABTG_GapFill`: se il gap si sta chiudendo, l'evento e' l'altro e la giornata muore. Impedisce che i due motori litighino sullo stesso segnale |
| **UN trade al giorno, nessuna riapertura dopo lo stop** | e' la forma delle nostre sedie vive (il DAX Apertura fa un trade al giorno, WR 81,0%) |
| **stop STRUTTURALE al bordo opposto del range** | non e' un numero, e' un punto del grafico |

### 🟡 COSA RIFACCIO — e sono tutte cose che sappiamo fare

| rifaccio | da | a | perche' |
|---|---|---|---|
| 🔴 **`OnTester`** | assente | da scrivere | senza, il driver non parte (§2). **E' l'unico vero blocco** |
| ⏰ **il fuso** | `SESSION_JST_DARWINEX_AUTO` (UTC+2/+3, DST americana) | **modo manuale, 01:00-07:30 ora server BCM** | §4 |
| ⚖️ **l'asimmetria long/short** | rischio dimezzato sotto gap 1,25% | **spenta, 1% su entrambi i lati** | §5 |
| 🔪 **la superficie di config** | 31 input | **4 manopole libere, 27 congelati** | §3 |
| 🎯 **il modo di SCEGLIERE la cella** | l'autore non lo dice | **centro dell'altopiano, mai la cella migliore** | 12 Spearman IS→OOS negative su 13 |
| 🏛️ **il rischio operativo** | 0,50% dell'autore | **1% per misurare, 0,65% per la prop** | §7-bis |
| 🔢 **il magic** | 2250101 | magic **vergine** nostro prima di ogni forward | regola di casa |

### ✅ E COSA NON DEVO RIFARE — perche' l'autore ci e' gia' arrivato

Tre cose che di solito mettiamo noi, e che qui ci sono gia':

- **parziale 40% a 1R + breakeven + runner a 2R** — e' *letteralmente* la
  gestione delle nostre sedie DAX/Dow, in multipli di R;
- **spread come PERCENTUALE dello stop** (`InpMaxSpreadToStopPercent`) — e' il
  modo giusto di misurarlo (R55), e non e' nemmeno un'idea nostra: e' sua;
- **sizing corretto sui CFD in yen** via `OrderCalcProfit` — cioe' il bug che
  **ci ha ucciso il round 2 proprio su questo simbolo** (§6).

### 🚦 E allora, per la regola del §5.F: **non e' scarto, e non per gentilezza**

Il mandato dice di scartare per **"rotto"**, **"doppione"** o **"costo di
validazione > valore atteso"** — e di scrivere quale delle tre. Nessuna delle
tre si applica:

| | esito |
|---|---|
| **rotto?** | 🟢 no. Zero bandiere rosse del §4, cercate tutte nel sorgente |
| **doppione?** | 🟢 no, ed e' il punto: e' la **direzione opposta** di `ABTG_GapFill`, mai misurata |
| **costo > valore?** | 🟢 no. ~1 ora di adozione (MQL5 nativo), contro una domanda che oggi non sappiamo rispondere |

---

## 2. 🔴 LA COSA CHE NESSUNO AVEVA VISTO: **MANCA `OnTester`**

E' il ritrovamento piu' importante di questa sessione, e non stava nella scheda.

```
$ grep -n 'OnTester\|OnInit\|OnTick\|OnDeinit' Nikkei225_Gap_Continuation_EA.mq5
1018:int OnInit()
1084:void OnDeinit(const int reason)
1093:void OnTick()
```

**Non c'e'.** E il nostro driver lo pretende, per progetto:

```powershell
# walkforward_generico.ps1, righe 144-147   [VERIFICATO, aperto e letto]
if($src -notmatch 'double\s+OnTester\s*\('){
  Muori ("$Expert NON esporta i risultati (manca OnTester).`n" + ...
         "    Va aggiunto il blocco OnTester all'EA prima di poterlo misurare.")
}
```

`LEGGIMI.md` lo dice gia': **22 EA su 61 sono stati bocciati esattamente qui.**

> 🎯 **Conseguenza pratica:** l'EA **non e' lanciabile cosi' com'e'**, e non per
> un difetto della strategia. Serve un passaggio da `mql5-ea-developer` — che
> **non e' il mio mestiere** e non l'ho fatto. Ma e' un passaggio corto: vedi §6.

---

## 3. 🔪 PROBLEMA 1 RISOLTO — **I "39 INPUT" SONO 31, E LE MANOPOLE LIBERE SONO 4**

### Prima correzione: 39 e' il conto delle righe, non dei parametri

`grep -c '^input'` da' 39, ma **8 sono `input group`**, cioe' titoli di sezione.
Non sono parametri, e **il driver stesso non li conta**: la sua regex (riga 238)
pretende un `=`.

> **I parametri veri sono 31.** Restano sopra il tetto di casa (~15) come
> numero — ma il tetto esiste per contare **le manopole che il backtest puo'
> girare verso il passato**, e quelle qui le decidiamo noi.

### La lista esplicita: cosa si spazzola, cosa si congela e a che valore

**🔓 SPAZZOLATI — 4 assi, 54 celle**

| input | griglia | perche' proprio questo |
|---|---|---|
| `InpMinimumBuyGapPercent` | 0,50 · 0,75 · 1,00 | **e' l'EVENTO.** Ed e' l'unica leva sul campione: si spazzola VERSO IL BASSO, perche' il vincolo che ci puo' uccidere il round e' `n`, non il rendimento |
| `InpMinimumSellGapPercent` | 0,50 · 0,75 · 1,00 | idem, **e come asse separato apposta**: e' cosi' che l'asimmetria si MISURA (§5) |
| `InpOpeningRangeMinutes` | 5 · 10 · 15 | non e' taratura fine: sono **i tre soli valori che l'EA accetta** (OnInit riga 1032 rifiuta fuori da 5..15) |
| `InpFinalTargetR` | 2,0 · 3,0 | il runner. Il parziale resta fermo a 1R |

**🔒 CONGELATI — 27, e il valore di ognuno**

| gruppo | input = valore | perche' congelato |
|---|---|---|
| **fuso** | `InpSessionTimeMode=1` (MANUAL_SERVER) · `InpSessionOpenHour=1` · `InpSessionOpenMinute=0` · `InpSessionCloseHour=7` · `InpSessionCloseMinute=30` | 🔴 **e' il problema 2**, calcolo in §4. Non e' una manopola: e' la definizione del mercato |
| **asimmetria** | `InpReduceRiskOnSmallSellGap=0` · `InpBuyRiskPercent=1.0` · `InpSellRiskPercent=1.0` · `InpSellFullRiskFromGapPct=1.25` (inerte) · `InpSmallSellRiskPercent=0.25` (inerte) | 🔴 **e' il problema 3**, §5. Rischio 1% = lo standard con cui e' misurata **ogni** cella del progetto |
| **simmetria** | `InpEnableBuyGaps=1` · `InpEnableSellGaps=1` | entrambi i lati accesi: la simmetria e' meta' del motivo per cui l'EA ci interessa |
| **gestione** | `InpPartialClosePercent=40` · `InpPartialTargetR=1.0` · `InpMoveStopToBreakEven=1` | e' **la gestione delle nostre sedie DAX/Dow**, gia' nostra. Spazzolarla vorrebbe dire rimisurare cio' che sappiamo |
| **finestre** | `InpMaxEntryMinutesFromOpen=90` · `InpExitMinutesBeforeClose=5` | default dell'autore. In questo round sono **scelte di disegno**, non manopole: 90' finiscono alle 02:30 server, prima della pausa pranzo di Tokyo |
| **spread** | `InpMaxSpreadToStopPercent=10.0` · `InpMaxSpreadPoints=0` · `InpStopBufferPoints=0` | lo spread come **% dello stop** e' il modo giusto di misurarlo (R55). Quello a punti fissi resta spento |
| **sizing** | `InpFixedLots=0` · `InpMaxLots=0` · `InpUseRealVolumeIfAvailable=1` | **mai lotto fisso**: bandiera rossa §4 |
| **esecuzione** | `InpMagicNumber=2250101` · `InpMaxSlippagePoints=30` | il magic nel tester non conta; ⚠️ **prima di qualunque forward va cambiato in un magic VERGINE nostro** |
| **rumore** | `InpShowStatusOnChart=0` · `InpPrintDailyDiagnostics=0` | 54 celle x un print al giorno = log inutilizzabili. Si riaccende la diagnostica **solo** nella passata singola di diagnosi (§7) |

✅ **Controllo meccanico fatto, non a occhio:** i 31 nomi del file prova sono
stati confrontati uno per uno con i 31 estratti dal sorgente con la **stessa
regex del driver**. Risultato: **31 su 31, zero nomi inventati, zero
dimenticanze, 4 assi con flag `Y`.** Serve a non cadere nella trappola del
`LEGGIMI.md`: _"un parametro che l'EA non ha, MT5 lo ignora IN SILENZIO e la
fase risponde a un'altra domanda"_.

✅ **E tutte e 54 le celle sono LEGALI.** `OnInit` (righe 1032-1051) rifiuta di
partire se `InpOpeningRangeMinutes` esce da 5..15 o se
`InpFinalTargetR <= InpPartialTargetR`. Con 5/10/15 e 2,0/3,0 contro un
parziale a 1,0, **nessuna cella nasce morta**.

---

## 4. ⏰ PROBLEMA 2 RISOLTO — **IL FUSO, COL CALCOLO IN CHIARO**

### Cosa fa l'EA da solo, e perche' da noi sarebbe sbagliato di DUE ORE

```cpp
// riga 163  [VERIFICATO]
int DarwinexServerUtcOffset(const datetime server_date)
  { return(IsDarwinexUsSummerTime(server_date) ? 3 : 2); }

// riga 177-178
int server_offset=DarwinexServerUtcOffset(base);
int total_minutes=session_hour*60+session_minute-9*60+server_offset*60;
```

In modo automatico l'EA assume un server a **UTC+3 d'estate / UTC+2 d'inverno**
(Darwinex) e converte da JST. **Su BCM il server d'estate sta a UTC+1**: la
conversione automatica sbaglierebbe di **due ore**, e l'EA leggerebbe il "range
di apertura" alle 03:00 server — cioe' **a meta' mattinata di Tokyo**. Non
misurerebbe un gap: misurerebbe un altro mercato.

> 📌 Dettaglio in piu', che rincara: la regola DST usata e' quella
> **americana** (2a domenica di marzo / 1a domenica di novembre, righe 138-157),
> non quella europea. Sbagliata anche nelle settimane di cambio.

### La soluzione: NON si tocca il codice — l'EA ha gia' il modo manuale

```cpp
enum ENUM_SESSION_TIME_MODE { SESSION_JST_DARWINEX_AUTO=0, SESSION_MANUAL_SERVER=1 };
// riga 172-174: in modo manuale gli orari sono presi COSI' COME SONO, ora server
```
👉 `InpSessionTimeMode = 1`.

### IL CALCOLO, per esteso

```
  seduta cash di Tokyo (TSE)        09:00  ->  15:30   JST
  JST = UTC+9 tutto l'anno (il Giappone NON fa l'ora legale)
     09:00 JST − 9h = 00:00 UTC        15:30 JST − 9h = 06:30 UTC
  ora italiana (agosto, CEST = UTC+2)
     00:00 UTC + 2h = 02:00 IT         06:30 UTC + 2h = 08:30 IT
  ora server BCM = ora italiana − 1   (regola fissa di progetto)
     02:00 IT − 1h = 01:00 server      08:30 IT − 1h = 07:30 server
```

**✅ CONTROPROVA con la regola nota di casa:** il DAX apre 09:00 IT = **08:00
server**, quindi d'estate il server BCM sta a **UTC+1**. Allora
`JST − server = 9 − 1 = 8 ore`, e `09:00 JST − 8h = 01:00 server`. **Torna.**

### 👉 GLI ORARI DICHIARATI, IN ORA SERVER BCM

| | ora Tokyo | ora italiana | **ora server BCM** |
|---|---|---|---|
| apertura seduta | 09:00 JST | 02:00 | **01:00** |
| chiusura seduta | 15:30 JST | 08:30 | **07:30** |
| fine finestra d'ingresso (+90') | 10:30 JST | 03:30 | **02:30** |
| (pausa pranzo Tokyo) | 11:30-12:30 JST | 04:30-05:30 | **03:30-04:30** |

Nessun attraversamento della mezzanotte: il controllo dell'EA
`close_minutes <= open_minutes` (riga 1026) passa senza forzature.

### 🔴 E IL BUCO CHE DICHIARO INVECE DI TAPPARLO: L'ORA LEGALE

01:00/07:30 e' esatto **quando il server BCM sta a UTC+1**, cioe' nel periodo in
cui la regola e' stata misurata (agosto). **Se d'inverno il server scala a
UTC+0, l'apertura vera diventa 00:00** e il file prova misurerebbe la seduta
sbagliata per mezzo storico. Il DST di BCM e' una **misura aperta del progetto**
(CODA §6, scadenza 25/10/2026) e **non la invento**.

👉 **Si chiude in un minuto, e va fatto PRIMA di leggere i numeri:** aprire un
grafico M1 di `225JPY` su una data di **gennaio** e guardare a che ora server
comincia la seduta di Tokyo — si vede a occhio dal salto di volume. Se e'
**00:00**, questo screening vale solo sui mesi estivi e va rifatto.
Se il server BCM fa davvero l'ora legale, il modo manuale a ora fissa non basta
e serve la patch vera: in `DarwinexServerUtcOffset` (riga 163) gli offset di BCM
(**1 d'estate / 0 d'inverno**) e la regola DST giusta. **Sono due costanti, non
una riscrittura.**

---

## 5. ⚖️ PROBLEMA 3 RISOLTO — **ASIMMETRIA SPENTA, E LA SOGLIA MESSA IN MISURA**

### Cosa fa nel sorgente

```cpp
// righe 49-51
input bool     InpReduceRiskOnSmallSellGap = true;
input double   InpSellFullRiskFromGapPct   = 1.25;   // rischio pieno solo sopra 1,25%
input double   InpSmallSellRiskPercent     = 0.25;   // meta' rischio sotto

// righe 613-622  [VERIFICATO]
double CurrentSellRiskPercent()
  {
   if(!InpReduceRiskOnSmallSellGap) return(InpSellRiskPercent);
   if(MathAbs(g_gap_percent)<InpSellFullRiskFromGapPct) return(InpSmallSellRiskPercent);
   return(InpSellRiskPercent);
  }
```

Rischio **diverso fra long e short**, con una soglia a **1,25%** che non ha
nessuna giustificazione di mercato scritta da nessuna parte. E' la firma di un
numero nato **guardando i risultati**.

### 👉 SPENTA, e i due lati messi allo stesso rischio

```
InpReduceRiskOnSmallSellGap = 0     -> la funzione restituisce sempre InpSellRiskPercent
InpBuyRiskPercent  = 1.0
InpSellRiskPercent = 1.0
```
**Se entra, entra simmetrico.** Un motore che ha bisogno di rischiare meno da un
lato sta dicendo che **da quel lato non ha edge**: e allora la risposta e'
spegnere quel lato, non dimezzare il lotto.

📌 Nota tecnica: con il flag a 0, il vincolo di `OnInit`
(`InpSellFullRiskFromGapPct < InpMinimumSellGapPercent` -> rifiuto, riga 1045)
**non si applica piu'** — che e' anche il motivo per cui spegnerlo libera la
griglia di poter scendere a 0,50% sulla soglia di gap senza celle morte.

### 👉 E la soglia SI MISURA, non si eredita — ed e' gia' apparecchiato

La griglia spazzola `InpMinimumBuyGapPercent` e `InpMinimumSellGapPercent`
**come due assi separati** (3x3):

| | sell 0,50 | sell 0,75 | sell 1,00 |
|---|---|---|---|
| **buy 0,50** | ⭐ diagonale | misura | misura |
| **buy 0,75** | misura | ⭐ diagonale | misura |
| **buy 1,00** | misura | misura | ⭐ diagonale |

- Le **3 celle diagonali** (buy == sell) sono **le uniche da cui si SCEGLIE**.
- Le **6 fuori diagonale** sono **la misura** della domanda che l'asimmetria
  dell'autore pone: _"i due lati vogliono davvero soglie diverse?"_.
  Si leggono, si annotano nel referto, **e in questo round non si adottano**.

Se un giorno la risposta fosse si', sara' un numero **misurato su una finestra
dichiarata**, non il lascito di qualcun altro. E' esattamente la differenza fra
un parametro e una cicatrice.

---

## 6. ✅ LA NOTIZIA BUONA CHE NON ERA NELLA SCHEDA

Cercando il bug del sizing — quello che ci ha **ucciso il round 2 proprio sul
Nikkei** — ho trovato che **l'autore lo aveva gia' risolto**:

```cpp
// righe 581-585  [VERIFICATO]
// Returns the loss already converted to the account currency.
// Avoids incorrect tick-value scaling on JPY-denominated CFDs.
ResetLastError();
if(OrderCalcProfit(order_type,_Symbol,1.0,entry,stop,calculated_profit))
   loss_per_lot=MathAbs(calculated_profit);
```

Il nostro `LotByRisk` usava `SYMBOL_TRADE_TICK_VALUE` **nudo**: su `225JPY`
arriva in yen (~160x troppo grande) -> lotto calcolato ~0 -> appoggiato al
minimo, e il round 2 **non ha risposto**. Questo EA usa `OrderCalcProfit`, che
torna gia' convertito in valuta di conto — **e il commento dell'autore nomina
esattamente il nostro caso.** C'e' pure un fallback a
`SYMBOL_TRADE_TICK_VALUE_LOSS` se il server non risponde.

> 🎯 Vuol dire che **su questo simbolo il sizing funziona al primo colpo**, e
> non dobbiamo rifare il giro del "lotto minimo inchiodato". E' il tipo di
> dettaglio che si vede **solo** leggendo il sorgente.

### Le tre modifiche per `mql5-ea-developer` (non le ho fatte: non e' il mio mestiere)

L'EA nostro si chiamera' `ABTG_GapContinuation.mq5` (e' il nome a cui punta il
file prova). **Non e' una riscrittura: e' una adozione minima.**

1. 🔴 **Aggiungere `double OnTester()`** — l'unico vero blocco (§2).
2. **Intestazione di attribuzione**: autore, URL, data, licenza non dichiarata
   (regola §9).
3. **Fuso**: nessuna modifica se si usa il modo manuale come fa il file prova.
   La patch a `DarwinexServerUtcOffset` serve **solo se** la misura del DST
   (§4) dice che il server BCM cambia ora.
4. 🔴 **I NOMI DEGLI INPUT NON SI TOCCANO.** Se cambiano, ogni riga del file
   prova punta nel vuoto e **MT5 la ignora in silenzio**.

---

## 7. 🕳️ COSA NON HO POTUTO VEDERE — e cosa va misurato prima

| cosa | stato | come si chiude |
|---|---|---|
| **storico M1 di `225JPY` su BCM** | 🔴 **NON MISURATO**, e `@DAQUANDO` e' lasciato VUOTO apposta | `scarica_storico.ps1 -Simboli "225JPY" -Timeframes "M1" -Da 2015.01.01 -SoloReferto` |
| **DST del server BCM** | 🔴 **[INCERTO]**, misura aperta (CODA §6) | grafico M1 su una data di gennaio, §4 |
| **`225JPY` quota di notte?** | 🔴 **[INCERTO]** — e cambia il SENSO della tesi | prima riga del referto: ci sono barre M1 fra le 08:00 e le 24:00 server? |
| licenza dell'originale | 🔴 non dichiarata | termini del Code Base, da verificare prima di distribuire |
| download dell'EA | ⚠️ la pagina espone le **visualizzazioni** (1.667), non i download | — |

### ⚠️ La trappola di `@DAQUANDO`, che qui ha un dettaglio in piu'

Nei file `R36`/`R37a` su `225JPY` compare `@DAQUANDO 2024.09.26`. **Quella data
non si puo' riusare.** R36/R37 giravano su **H1**; questo EA legge **PERIOD_M1
e nient'altro** — chiusura precedente, range di apertura e VWAP passano tutti
da `CopyRates(_Symbol,PERIOD_M1,...)` (righe 358, 375, 397). La profondita'
dello storico **M1** e' quasi sempre piu' corta di quella oraria, e nel repo
**non e' misurata da nessuna parte**.

> Se lo storico M1 comincia dopo, **meta' finestra IS non esiste** — che e'
> esattamente l'errore gia' pagato sugli indici (il driver diceva 2024.01.01,
> i dati partivano dal 26/09/2024). **Non ipotizzo la data.**

### E i tre limiti dello screening, dichiarati adesso e non dopo

- **a) "gap" su un CFD che non dorme.** L'EA misura apertura 01:00 contro
  chiusura 07:29 del giorno prima. Se `225JPY` quota quasi 24h (come i CFD sul
  Nikkei, che seguono il future), **in mezzo non c'e' un salto: c'e' la
  sessione americana intera, contrattata.** Allora quello che l'EA chiama "gap"
  e' il **movimento notturno**. La tesi resta sensata — _"la deriva notturna
  continua dopo l'apertura di Tokyo"_ — ma **non e' la tesi dell'autore**, e va
  letta cosi'.
- **b) il filtro spread puo' mangiarsi i trade.** Con
  `InpMaxSpreadToStopPercent = 10`, si entra solo se lo stop e' almeno **10
  volte lo spread**. Su `225JPY` BCM lo spread misurato a mercato chiuso e'
  **80 punti** (`docs/BROKER_ESTERNO_MAPPA.md`, 15/08/2026): servirebbe uno
  stop da 800 punti = 80 punti indice. **Se le celle tornano vuote, il primo
  sospetto e' questo, non la tesi** — si diagnostica con UNA passata a
  `InpPrintDailyDiagnostics=1`, che stampa `"Waiting: spread X% of stop"`.
- **c) OHLC M1 approssima l'istante** della rottura (4 prezzi per barra). Un
  motivo in piu' perche' **il verdetto stia solo ai tick reali** (R57).

---

## 7-bis. 🏛️ IL CANCELLO PROP — *"in ottica prop, questo motore..."*

_Sezione richiesta dal mandato §7-bis. Numeri da `report/METRO_PROP.md` e
`report/ROTTA_PROP.md`. **Questa riga non entra nel punteggio 0-10**: serve a
decidere l'ordine della coda, e va scritta anche quando e' sfavorevole._

> **In ottica prop, questo motore e' strutturalmente il piu' gentile col muro
> GIORNALIERO che abbiamo mai guardato — e il piu' sospetto sul muro TRAILING.
> E ha una sovrapposizione da dichiarare: il simbolo e' gia' occupato.**

### 1. 🟢 Il muro giornaliero: qui e' quasi inattaccabile, e per costruzione

Il muro che butta fuori anche col totale intatto e' **−5% in una sola seduta**
(−5.000 su 100k; 94.900 e' fuori pur essendo sopra 90.000).

Questo EA, **per come e' scritto e non per fortuna**:
- fa **UN trade al giorno** (`g_traded_today`, riga 1123 — verificato);
- **non riapre dopo lo stop**;
- ha uno **stop vero mandato al broker**, non virtuale;
- **chiude tutto 5' prima della fine seduta**: zero esposizione notturna.

👉 La perdita massima di una giornata e' **1R**. A 0,65% di rischio fa
**−0,65% nel giorno peggiore possibile**, contro un cap del 5%.
📌 Per confronto: la **peggior giornata misurata del progetto** (R51) e'
**−2,06% ≈ 3,2R**. Questo motore **non e' in grado** di produrre una giornata
cosi': gli servirebbero 3 trade, e ne fa uno.

### 2. 🟢 Concentrazione e frequenza

Nessuna raffica: un solo ingresso, nessuna piramide, nessun averaging. Il
rischio giornaliero non e' un problema **di questo EA** — diventa un problema
solo **in somma con gli altri**, ed e' il punto 4.

### 3. 🟢 Scalabilita' a 100k

Rischio in **percentuale dell'equity**, mai lotto fisso, e con il calcolo del
lotto **corretto sui CFD in yen** (§6). E' scalabile e confrontabile: il round 2
sul Nikkei fallì esattamente qui, e qui non fallisce.

📌 **Perche' il file prova pinna 1% e non 0,65%**: l'1% e' lo standard con cui
e' misurata **ogni** cella del progetto (i criteri di DD sono scritti "al
rischio 1%"). La traduzione prop e' lineare: **DD prop ≈ DD misurato × 0,65**.
Si misura a 1%, si gira a 0,65%.

### 4. 🔴 SCORRELAZIONE — la nota sfavorevole, e va detta per prima

**Il simbolo e' gia' occupato**, ed e' il candidato n.1 dell'arsenale:

| # | EA | dove | quando lavora | DD OOS | PF OOS |
|---|---|---|---|---:|---:|
| 1 | **SupertrendReversal** | **225JPY H2** | **Asia (swing)** | **0,88%** | 1,653 |

La regola di rotta e' netta: **"mai due EA sullo stesso segnale/simbolo/lato
allo stesso rischio pieno"**, perche' _"il DD della prop e' UNO: quello del
conto"_.

**Si sovrappongono o no? La risposta onesta e': in parte, e in un modo
misurabile.**

| | SupertrendReversal 225JPY H2 | ABTG_GapContinuation 225JPY |
|---|---|---|
| simbolo | 225JPY | **225JPY** ⚠️ **stesso** |
| tipo | **swing multi-giorno** (H2) | **evento intraday**, un trade/giorno |
| segnale | inversione di Supertrend | **gap di apertura + rottura del range** |
| durata | giorni | **ore** — piatto prima della chiusura di Tokyo |
| quando decide | in qualunque barra H2 | **solo alle 01:00-02:30 server**, e solo nei giorni con gap |

👉 **I segnali sono scorrelati** (uno e' un'inversione di trend su piu' giorni,
l'altro un evento di apertura); **l'esposizione no**: lo swing puo' essere
aperto **mentre** il gap-continuation entra, sullo **stesso simbolo**, e nulla
garantisce che siano sullo stesso lato — ne' che non lo siano.

> 🎯 **Quindi la scorrelazione qui NON si dichiara: si misura**, ed e' gia'
> previsto come farlo — `ROTTA_PROP.md` punto 2: **export per-trade** e DD
> **combinato** storico + Monte Carlo. Finche' quel numero non c'e', la regola
> prudente e' quella di rotta: **non a rischio pieno tutti e due**.

**In compenso, cio' che porta di nuovo e' vero:**
- ⭐ un **motore di EVENTO**, e nell'arsenale non ne abbiamo nemmeno uno: sono
  tutti swing o motori di sessione;
- ⭐ una **fascia oraria quasi scoperta** — 01:00-07:30 server. L'arsenale
  copre notte EU, mattina EU, pomeriggio USA e swing; l'unica voce "Asia" e'
  proprio il SupertrendReversal, che pero' e' swing e non ha un orario;
- ⭐ un motore **simmetrico vero** (long e short dalla stessa regola), contro
  14 celle vive quasi tutte long-only;
- ⭐ **zero esposizione notturna e nel weekend**: chiude ogni giorno.

### 5. ⚠️ DD TRAILING — la bandiera gialla, e va segnalata

Alcune prop (Upcomers) usano un DD che **insegue l'equity**; le nostre Monte
Carlo sono su **DD statico dal deposito** e col trailing **non valgono**.

Il mandato chiede di segnalare i motori con **"curva a scalini con lunghi
ritorni dal picco"**. 👉 **Questo e' uno di quelli, e per costruzione**: e' un
motore di **evento raro** (gap ≥ 0,5-1,0% su un indice che muove ~1% al
giorno). Fara' **lunghe pianure piatte** fra un trade e l'altro, e dopo una
perdita il ritorno al picco puo' richiedere **settimane di calendario** — non
perche' il motore sia lento a recuperare in trade, ma perche' **i trade non
arrivano**. E' proprio la forma che un DD trailing punisce.

> ⚠️ **Da segnalare, non da scartare** — ma se la prop scelta usa il trailing,
> questo motore va valutato sul **tempo di recupero in calendario**, non solo
> sul DD in percentuale. E il numero non ce l'abbiamo.

### 📋 La riga, in una riga

> **In ottica prop, questo motore mette a rischio al massimo 1R al giorno
> (−0,65% nel giorno peggiore, contro un cap del 5%), chiude ogni sera, e'
> scalabile a 100k col sizing gia' corretto sugli yen, e porta due cose che
> l'arsenale non ha (un motore di evento e la fascia asiatica oraria) — ma sta
> sullo STESSO SIMBOLO del candidato n.1 e va misurato in DD combinato prima
> di accenderlo a rischio pieno, e la sua curva a pianure e' la forma che un DD
> trailing punisce.**

---

## 8. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> ## **Sullo stesso simbolo e sullo stesso evento dove scommettere che il gap SI CHIUDE e' promosso (+76 OOS, PF 1,14), scommettere che il gap CONTINUI produce un edge — o produce lo specchio in perdita?**

E c'e' una **domanda zero** che va guardata prima ancora dei profitti, perche'
decide se la prima domanda ha senso:

> ### **Quanti trade esistono davvero?**
> L'evento e' raro per costruzione e lo storico M1 di BCM e' corto. Sotto i
> **15 trade di famiglia**, il round non da' un verdetto sulla TESI: da' un
> verdetto sul SIMBOLO. E allora la risposta giusta **non e' abbassare la
> soglia per fare numero**, e' portare la stessa tesi su **DAX e Nasdaq**
> (CODA §5) — dove peraltro il filone dei motori di apertura ci sta gia'
> aspettando.

Le tre risposte possibili, e cosa facciamo di ognuna:

| esito | lettura | mossa |
|---|---|---|
| 🟢 verde sulla diagonale, `n` sufficiente | esiste un edge di continuazione | tick reali, poi DAX/Nasdaq |
| 🔴 rosso | il gap del Nikkei si chiude, e basta | **rafforza `ABTG_GapFill`**: il round e' comunque servito |
| ⚪ `n` troppo piccolo | evento troppo raro su questo simbolo | stessa tesi su DAX e Nasdaq, senza toccare le soglie |

⚠️ E un avvertimento che metto qui perche' e' facile dimenticarlo davanti a una
tabella verde: **se sono verdi TUTTI E DUE** — il fill e la continuazione,
stesso simbolo, stesso evento — non e' una doppia vittoria. E' il sospetto che
uno dei due stia leggendo rumore, e va scritto nel referto.

---

## 9. 📦 CONSEGNE

| cosa | dove |
|---|---|
| file prova | `backtest_pipeline/prove/ABTG_GapContinuation.txt` |
| dossier | questo file |
| sorgente originale | **non committato**: scaricato in area temporanea, licenza non dichiarata. Va ripreso da `mql5.com/en/code/download/75301/...` da chi scrive l'EA |

🛑 Nessun comando git eseguito. 🛑 Nessun EA nostro modificato.
