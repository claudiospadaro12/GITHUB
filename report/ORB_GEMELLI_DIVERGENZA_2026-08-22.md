# 🔬 ORB OTT (770611) — I GEMELLI CHE DIVERGONO: indagine in corso

_Apre un file dedicato perche' l'indagine e' arrivata al terzo giorno (19/08,
21/08, 22/08) e finora viveva sparsa dentro le pagelle giornaliere. Da qui in
poi si aggiorna QUESTO file a ogni nuovo elemento._

## Il fatto, misurato due volte
Stesso ordine pendente (stesso ingresso, stesso SL/TP iniziali), stesso
secondo di attivazione, su entrambi i conti. Il **100k** trailla lo stop
sull'EMA9 e chiude con una perdita ridotta; il **piccolo** non muove mai lo
stop e prende l'intero R.

| data | 100k | piccolo |
|---|---:|---:|
| 19/08 | −0,39R (traila) | −1,00R (pieno) |
| 21/08 | −0,795R (traila) | −1,00R (pieno) |

Controllo negativo (21/08): la coppia **DAX Apertura EU** chiude allo stesso
secondo, stesso prezzo, su entrambi i conti → **non e' un problema di conto,
di broker o di taglia: e' l'istanza ORB sul conto piccolo.**

## 22/08 — Claudio manda lo screenshot degli input LIVE (conto piccolo)

Pannello "Dati in Ingresso" di `ABTG_ORB_Ottimizzato 1.00 (U30USD,M5)`,
magic **770611**, letto riga per riga:

- `InpAllowShort = false` (solo long attivo su questa istanza — coerente con
  gli ordini visti finora, tutti BUY)
- `InpSLMode = ORB_SL_HALFRANGE`, `InpAtrSLmult=1.5`
- `InpTPMode = ORB_TP_RANGE`, moltiplicatore range `1.5` (il campo
  "Take profit in R" = 1.0 e' **inerte**: quel modo si usa solo con
  `InpTPMode=ORB_TP_R`, qui il modo e' RANGE)
- **`InpTP1Pct = 0.0`** ("% chiusa al target") ⚠️ **nuovo, da verificare
  anche sul 100k**: nel codice, `ManageTP1()` esce SUBITO se
  `InpTP1Pct<=0` — e la modifica del breakeven (`InpBreakeven=true`, "Stop
  in pari dopo la parziale") **vive dentro quella stessa funzione**. Quindi
  su questa istanza **il breakeven non puo' MAI scattare**, a prescindere
  dal fatto che sia acceso: e' spento di fatto dal TP1Pct a zero. Non e'
  la causa del trailing mancato (il trailing e' in `ManageRunner()`,
  funzione SEPARATA, chiamata comunque a ogni nuova barra M5), ma e' un
  secondo difetto reale, indipendente, trovato per strada.
- **`InpUseTrailEMA = true`** (evidenziato da Claudio) — **CONFERMATO ACCESO**.
  Coincide col preset salvato in
  `mql5/Presets/sedie_piccolo/recupero2/sedia_ABTG_ORB_Ottimizzato_770611.set`
  (stessa riga, stesso valore).

### 🎯 Cosa vuol dire: il sospetto si sposta, non si chiude
**L'input NON e' la causa.** Con `InpUseTrailEMA=true`, `ManageRunner()`
dovrebbe muovere lo stop a ogni nuova barra M5, indipendentemente da
`InpTP1Pct`. Sulla carta questa istanza DOVREBBE trailare. Non lo fa.
Quindi resta in piedi, ed e' ora l'ipotesi principale, quella aperta il
19/08: **le due istanze girano `.ex5` diversi** (build diversa, magari
precedente all'introduzione del trailing o con un difetto nella rilevazione
di `newBar`), oppure un fattore ambientale specifico di quel terminale.

## 22/08 (poco dopo) — tre versioni diverse dello stesso EA (ma NON e' la causa del trailing)

Claudio manda il sorgente vero da entrambi i conti (prima quello sbagliato,
`ABTG_ORB.mq5` il "corso" — scartato, e' un altro file, vedi sopra; poi
quello giusto dal **100k**, poi quello giusto dal **piccolo**).

| dove | `#property version` |
|---|---|
| **conto piccolo** (sorgente `.mq5` ricevuto, confermato = screenshot) | **1.00** |
| **conto 100k** (sorgente `.mq5` ricevuto) | **1.01** |
| **repo `lavoro` (HEAD)** | **1.02** |

**Tre versioni diverse, in tre posti diversi, stesso magic 770611.** Questo
e' un fatto misurato e resta un problema da sanare. **MA: confrontando
riga per riga i due sorgenti veri (v1.00 piccolo vs v1.01 100k), la
funzione `ManageRunner()` — quella che fa il trailing sull'EMA9, l'esatto
comportamento che diverge fra i due conti — e' IDENTICA carattere per
carattere nelle due versioni.** Stesse guardie, stessa chiamata a
`PositionModify`, stessa logica di uscita su chiusura sotto/sopra l'EMA9.

**Quindi la deriva di versione NON spiega il trailing mancato.** Il primo
messaggio mandato a Claudio ("la causa e' proprio questa, la deriva di
versione") era prematuro — corretto qui: la funzione che conta per
QUESTO bug non e' cambiata fra le due versioni. Il sospetto sul trailing
resta aperto e ambientale/da isolare altrove (non ancora confrontate:
`TryPlace`, `SLforLong`/`SLforShort`, `ComputeRange`, `LotByRisk`,
`NormalizePrice`, gestione di `newBar`).

Quello che invece E' vero, confermato dal confronto diretto dei due
sorgenti, e **significativo di per se'** (indipendente dal mistero del
trailing):

- **Il conto piccolo (v1.00) non ha NESSUNA integrazione col Guardian**:
  niente `#include <ABTG_PausaGuardian.mqh>`, niente `InpUsaGuardian`,
  nessuna chiamata a `ABTG_GuardiaIngresso()` in `TryPlace()` ne' in
  `TryCloseConfirmEntry()`. Il conto 100k (v1.01) ce l'ha, prima di ogni
  piazzamento ordine. **Vuol dire che l'ORB OTT sul conto piccolo oggi
  apre posizioni senza NESSUNA delle protezioni B1 (pausa)/C1 (cap
  rischio) che il resto della flotta ha.** Rischio reale, non teorico.
- Il piccolo (v1.00) non ha nemmeno il gruppo `InpSlippagePts` e le
  correzioni di modellazione slippage R55 presenti in `TryPlace()`/
  `TryCloseConfirmEntry()` del v1.01.
- Il fix dichiarato nel changelog per `InpOneTradePerDay` (pendente
  fantasma che riapre in giornata) **risulta presente anche nel v1.00**
  a un primo confronto — quindi quella riga di changelog letta in
  precedenza andava probabilmente attribuita a un altro EA (verificare
  ancora, non e' la priorita' ora). Non dare per buono senza un secondo
  controllo puntuale.

### 3. `InpTP1Pct` sul 100k
Il sorgente v1.01 dichiara il DEFAULT `InpTP1Pct = 50` — ma questo e' il
valore di default nel codice, non necessariamente il valore CONFIGURATO
sul grafico live (serve lo screenshot del pannello input del 100k per
saperlo con certezza, come fatto per il piccolo). Resta aperto.

## ✅ SOLUZIONE — ESEGUITA il 22/08 sera
**Ricompilato `ABTG_ORB_Ottimizzato.mq5` da `lavoro` (v1.02) su ENTRAMBI i
terminali**, con script dedicato `backtest_pipeline/aggiorna_verifica_orb.ps1`
(installa anche `ABTG_PausaGuardian.mqh`, che il piccolo non aveva mai avuto).
Due bug dello script scoperti e corretti IN CORSA prima del successo finale:
1. il piccolo falliva a compilare perche' lo script v1 non installava
   l'include Guardian (solo l'EA) — corretto scaricando anche il `.mqh`;
2. dopo quel fix, ENTRAMBE le istanze fallivano compilazione con
   `metaeditor64.exe` che tornava `rc=0` senza fare nulla: causa
   `Start-Process -ArgumentList` con virgolette pre-assemblate a mano,
   che si rompe sui path con spazi ("Program Files..."). Corretto tornando
   all'invocazione diretta (`& $MetaEditor ...`), gia' provata funzionante.

**Verificato dal log reale di compilazione (22/08, 15:10 ora VPS)**:
entrambe le istanze — `0 errors, 0 warnings`, versione confermata 1.02 su
entrambe, `ABTG_PausaGuardian.mqh` incluso su entrambe.

**Verificato da Claudio dopo il riavvio dei terminali**: pannello input
ricontrollato su ENTRAMBI i conti (confermato "sono diversi, ho controllato
io") — su entrambi compare `Guardian: rispetta pausa giornaliera (B1) e cap
rischio aperto = true`, titolo `1.02`. **Il conto piccolo ha ora la
protezione Guardian che non aveva mai avuto.** Deriva di versione eliminata
su entrambi i terminali.

## 🔍 Il mistero del trailing resta APERTO — ora si osserva sul v1.02 identico
Non isolato a livello di codice (le uniche due versioni vere confrontate
avevano `ManageRunner()` identica). Con entrambi i conti ora sullo stesso
v1.02, il test e' pulito: se il piccolo continua a non trailare, si esclude
del tutto la deriva di versione e resta o codice non ancora confrontato
o causa ambientale/di terminale. Prossimi passi:
1. Diff riga per riga delle altre funzioni (`TryPlace`, `SLforLong`/
   `SLforShort`, `ComputeRange`, `LotByRisk`, rilevazione `newBar`) —
   non piu' rilevante fra versioni diverse (ora sono lo stesso file), ma
   utile se emerge un comportamento diverso a codice identico.
2. Ipotesi ambientale/terminale (es. l'handle dell'indicatore EMA non si
   carica per qualche motivo su quel terminale, `CopyBuffer` fallisce in
   silenzio e la funzione ritorna prima del `PositionModify` senza che
   nessuno se ne accorga: vedi anche la correzione di igiene sotto).
3. **Prossimo trade ORB OTT sul piccolo dopo il 22/08 sera: osservare se
   trailla.** Stesso codice su entrambi ora — qualunque differenza residua
   e' la prova che serviva.

## Correzione di igiene proposta, indipendente dalla causa
`ManageRunner()` oggi non stampa NULLA quando muove lo stop (ne' quando NON
lo muove). Quindi anche quando il trailing FUNZIONA, il log resta muto: la
sola prova indiretta e' il prezzo di chiusura, come si sta facendo ora.
Aggiungere un `Log()` alla modifica riuscita/fallita di `PositionModify` in
`ManageRunner()` renderebbe la PROSSIMA occorrenza diagnosticabile in un
minuto invece che con un confronto a mano fra due conti.

## ✅ CHIUSURA GIORNATA 22/08 — checklist finale, tutta verde
- v1.02 compilata `0 errors, 0 warnings` su ENTRAMBE le istanze (log reale).
- Pannello input riletto da Claudio su ENTRAMBI i conti: titolo 1.02,
  `InpUsaGuardian=true` presente e acceso.
- **Algo Trading VERDE su entrambi i terminali** (verificato da Claudio dopo
  il riavvio — controllo necessario perche' i test da riga di comando
  passano `AllowLiveTrading=false` e MT5 a volte se lo ricorda).
- Bonus della giornata: autotest del Guardian P1 (freno perdite consecutive,
  `ABTG_PausaGuardian.mqh` v1.30) ESEGUITO e verificato — 45 casi su 45
  PASS (19 vecchi + 26 nuovi), referto in zip `verifica_autotest_20260822`.
- Da osservare lunedi': primo trade ORB OTT sul piccolo -> trailla o no
  (punto 3 sopra). Tutto pronto per l'apertura.

---

## 🔴 02/09 — L'OSSERVAZIONE ATTESA E' ARRIVATA: **IL PICCOLO NON TRAILLA NEMMENO A CODICE IDENTICO**

Primo trade ORB OTT su ENTRAMBI i conti dopo la ricompilazione v1.02 del
22/08 (stessa build, verificata su entrambi). Dai ReportHistory delle 21:07:

| gamba | lotti | fill | SL iniziale | SL finale | uscita | esito | per lotto |
|---|---:|---|---:|---:|---|---:|---:|
| 100k #3298031 | 19,7 | 15:00:23 @ 53.065,5 | 53.006,5 | **53.164,4 (trascinato +98,9 pt)** | 16:02:56 | +1.680,35 | **+85,30** |
| piccolo #3298032 | 1,0 | 15:00:23 @ 53.065,5 | 53.006,5 | **53.006,5 (MAI mosso)** | 16:45:11 | −50,91 | **−50,91** |

**Verdetto del test pulito (punto 3 del 22/08): la DERIVA DI VERSIONE E'
ESCLUSA.** Stesso `.ex5` v1.02 su entrambi, stesso segnale, stesso secondo,
stesso SL iniziale — e il piccolo continua a non muovere lo stop. La causa
e' o in codice identico che si comporta diversamente per ambiente (ipotesi
2 del 22/08: handle EMA / `CopyBuffer` che fallisce in silenzio su quel
terminale) o negli INPUT del pannello (da rifotografare dopo la
ricompilazione: `InpUseTrailEMA`, `InpTP1Pct`).

Nota di contorno (stessa giornata, altro EA, direzione OPPOSTA): la pendente
MAXMIN DAX SHORT del piccolo e' stata annullata dall'EA alle 08:30, quella
del 100k e' SCADUTA da sola alle 09:29 (`expired`) — sul 100k qualcosa non
l'ha governata. Da guardare insieme, ma senza fondere le due indagini.

### I tre passi di domani (03/09), in ordine
1. **Screenshot pannello input ORB OTT su ENTRAMBI i terminali** (Claudio,
   dichiarato in chat 02/09 sera): `InpUseTrailEMA`, `InpTP1Pct`, titolo
   versione. Gli input NON si toccano — solo fotografia.
2. **Log del terminale piccolo** nella finestra 16:00→17:45 ORA ITALIANA
   (= 15:00→16:45 server, il trade): schede Esperti e Giornale, cercare
   errori su indicatori/`CopyBuffer`/`PositionModify` o il silenzio totale.
3. **La correzione d'igiene diventa URGENTE**: `ManageRunner()` muto rende
   ogni occorrenza un'indagine di giorni. Preparato in repo il logging
   (v1.03, solo repo — inerte finche' non si ricompila col solito script
   `aggiorna_verifica_orb.ps1` e la legge dello screenshot).

---

## 🛠️ v1.03 PREPARATA (SOLO REPO — inerte finche' Claudio non ricompila)

`mql5/Experts/ABTG_ORB_Ottimizzato.mq5` portato a `#property version "1.03"`.
**Solo strumentazione: nessun input nuovo, nessuna riga di decisione toccata,
nessun cambio di logica di trading.** Il file compilato oggi si comporterebbe
in modo identico al v1.02 — parla e basta. I log usano `Print()` e non `Log()`
di proposito: `Log()` dipende da `InpVerbose`, e una diagnostica che si puo'
spegnere da pannello per sbaglio non serve a niente in un'indagine come questa.

### Log aggiunti, uno per uno

**In `OnInit()` — prefisso `ORB INIT:`**
1. `handle EMA veloce OK = <handle>` con simbolo, TF, periodo, e lo stato di
   `InpUseTrailEMA` / `InpExitOnEmaClose` — cosi' la PRIMA riga del Giornale
   dice gia' se l'ipotesi n.2 (handle non caricato) e' viva o morta, e
   fotografa gli input del trailing senza aspettare lo screenshot.
2. `handle EMA veloce INVALID_HANDLE` con i parametri usati e `GetLastError()`.
3. In caso di `INIT_FAILED`: adesso dice **QUALE** handle e' saltato
   (ATR / EMA veloce / EMA lenta / EMA lunga) + errore, non piu' il generico
   "ERRORE: handle indicatori."

**In `ManageRunner()` — prefisso `ORB RUNNER:`** (prima usciva in silenzio su
cinque rami diversi e taceva anche quando il trailing funzionava)
4. **Ramo `SelPos()` falso ma posizioni nostre esistenti**: nuova funzione di
   sola diagnostica `ContaPosizioniMagic()` che conta le posizioni con magic
   770611 scorrendo `PositionsTotal()`. Se ce n'e' almeno una e `SelPos()`
   dice comunque di no, stampa che `PositionSelect` ha agganciato la posizione
   di un'altra sedia. **E' il test decisivo dell'ipotesi nuova, vedi sotto.**
   Se non c'e' nessuna posizione nostra, tace (altrimenti una riga per barra
   tutto il giorno).
5. **Ramo configurazione**: `InpUseTrailEMA=false E InpExitOnEmaClose=false`
   -> nessuna gestione, lo stop resta dov'e'.
6. **Ramo handle invalido**: `hEmaF==INVALID_HANDLE` -> impossibile trailare.
7. **Ramo `CopyBuffer` fallito** (era IL silenzio perfetto): stampa quanti
   valori ha copiato invece di 1, l'handle, e `GetLastError()` (preceduto da
   `ResetLastError()`, cosi' il numero e' quello vero).
8. **Dato di prezzo assente**: `iClose(shift 1) <= 0`, che renderebbe fasullo
   il confronto con l'EMA.
9. **Modifica RIUSCITA**: `stop LONG/SHORT trascinato su EMA9: <vecchio SL> ->
   <nuovo SL>`, con prezzo di apertura e BID/ASK. Da oggi il trailing che
   funziona si vede nel log, non si deduce dal prezzo di chiusura.
10. **Modifica FALLITA**: `PositionModify FALLITA (<vecchio> -> <nuovo>)` con
    `retcode`, descrizione del retcode e `GetLastError()`.
11. **Condizione EMA non soddisfatta** (il caso "normale", con **throttle una
    volta per barra**): stampa i tre numeri che decidono — `EMA9`, `SL
    attuale`, `BID`/`ASK` — cosi' si distingue a colpo d'occhio "l'EMA e'
    ancora sotto lo stop, niente da trascinare" da "e' il vincolo sul BID a
    mordere".
12. **Uscita su chiusura oltre l'EMA fallita**: retcode + errore (prima la
    `PositionClose` veniva data per riuscita a scatola chiusa).

**In `ManageTP1()` — prefisso `ORB TP1:`**
13. **Una tantum, con flag statico**: `TP1/breakeven disattivati da
    InpTP1Pct=0` — il **difetto n.2** del 22/08, quello per cui il breakeven
    vive dentro la funzione del parziale e con `InpTP1Pct=0` non puo' scattare
    mai, anche con `InpBreakeven=true` a pannello. Ora l'EA lo dichiara da
    solo al primo tick utile invece di farcelo scoprire da uno screenshot.

### ⚠️ Esito della verifica del punto 3: SI', esiste un percorso per cui il runner non gestisce nulla — e ne esistono TRE

Richiesto: cercare un percorso per cui `ManageRunner()` non venga chiamata, o
non faccia nulla, su un terminale e non sull'altro. **Trovato, e uno dei tre e'
un candidato molto forte come causa vera della divergenza.**

**A) 🔴 IL SOSPETTATO N.1 — `SelPos()` su conto HEDGING (nuovo, non era nel
dossier).** Prima riga di `ManageRunner()`:

```
bool SelPos(){ if(!PositionSelect(_Symbol)) return(false); return(PositionGetInteger(POSITION_MAGIC)==InpMagic); }
```

`PositionSelect(_Symbol)` **non conosce il magic**: su conto hedging, se sul
simbolo ci sono piu' posizioni, seleziona la PRIMA. Se quella prima e' di
un'altra sedia, il confronto sul magic fallisce, `SelPos()` torna `false` e il
runner **esce alla prima riga, in silenzio totale**: niente trailing, niente
uscita su EMA, niente breakeven, niente chiusura di fine giornata.

E il conto e' **HEDGING** (`CLAUDE.md`), e su **U30USD** girano da contratto
almeno: `770202` Dow_Apertura_US, `771531` EMA200 (**33-35 operazioni al mese
da sola**), `770511` SuperWave H1, `770531` SuperWave H2, `771321` PTE,
`772234` GapFill, `772341` PunteLarry — oltre al nostro `770611`. Il
`PIANO_MIGRAZIONE_100K_2026-08-31.md` (riga sulla finestra 14:30-14:46) dice
espressamente che ORB, Dow_Apertura ed EMA200 Dow **operano sullo stesso
simbolo negli stessi minuti**.

Perche' spiegherebbe TUTTO il quadro osservato:
- stessa `.ex5`, stesso secondo, comportamento diverso -> **dipende da cosa ha
  aperto il RESTO della flotta su quel terminale**, che sui due conti e'
  diverso (il 100k e' in migrazione, magic `88xxxx`);
- silenzio assoluto nel log -> il `return` e' alla prima riga;
- lo stop iniziale c'e' (viene messo all'apertura dell'ordine, che non passa
  da `SelPos()`), ma non si muove mai;
- e spiegherebbe anche il breakeven mancato **indipendentemente** da
  `InpTP1Pct`, perche' `ManageTP1()` comincia con lo stesso `SelPos()`.

**NON corretto**, come da mandato: la correzione (scorrere `PositionsTotal()`
per simbolo+magic invece di `PositionSelect`) tocca `ManageTP1`, `HandleOCO`,
`gHadPos`/`InpOneTradePerDay` ed `EndOfDay` — cioe' cambia il comportamento di
trading su conto hedging e va misurata, non infilata dentro una patch di
logging. **Il log n.4 serve proprio a provare o scagionare questa ipotesi al
prossimo trade**, prima di scrivere una riga di fix.

**B) 🟠 `newBar` che non scatta mai se `iTime(InpExecTF,0)` torna 0.** In
`OnTick`: `datetime t=iTime(_Symbol,InpExecTF,0); bool newBar=(t!=gLastExec);`
con `gLastExec` inizializzata a `0`. Se lo storico del TF di esecuzione non e'
disponibile su quel terminale, `iTime` torna `0`, `newBar` resta **falso per
sempre** e `ManageRunner()` **non viene mai chiamata**. E' una condizione
appiccicosa e muta. Nota pratica: `InpExecTF` e' un **input** — se sui due
conti fosse impostato diverso (o su un TF il cui storico non e' caricato),
cambierebbero insieme la EMA del trailing e la rilevazione della nuova barra.
**Da aggiungere alla lista degli input da fotografare domani.**

**C) 🟡 Dopo `InpEndHour:InpEndMin` il runner non gira piu'.** In `OnTick` il
blocco `if(nowMin>=InpEndHour*60+InpEndMin){ EndOfDay(); return; }` sta
**prima** della chiamata a `ManageRunner()`. Corretto di suo (a fine giornata
si chiude), ma se `InpCloseAtEnd=false` la posizione resta senza gestione.
Non c'entra col trade del 02/09 (15:00-16:45 server), lo si annota per
completezza.

**Verificato e SCAGIONATO** (nessuna dipendenza trovata): `ManageRunner()`
**non** dipende da `gPhase`, **non** dipende da `gPart1`/dal parziale, **non**
dipende da `gRangeHigh`/`gRangeLow`, **non** e' sotto il filtro notizie
(`InpUseNewsFilter` e' `false` di default e comunque il blocco news non fa
`return`). Quindi l'ipotesi "il runner non parte perche' il TP1 non e' mai
scattato" e' **falsa**: le due funzioni sono indipendenti, come gia' scritto
il 22/08 — con l'unica, importante eccezione che **condividono `SelPos()`**
(punto A).

### Cosa serve adesso, in ordine
1. Restano i tre passi del 02/09 (screenshot input, log del piccolo,
   ricompilazione) — **con l'aggiunta di `InpExecTF` fra gli input da
   fotografare** (punto B).
2. Ricompilare la v1.03 su ENTRAMBI i terminali con
   `backtest_pipeline/aggiorna_verifica_orb.ps1` (stessa procedura del 22/08,
   con la legge dello screenshot). Finche' non lo si fa, **questa versione e'
   inerte**: vive solo nel repo.
3. Al prossimo trade ORB, leggere il Giornale del piccolo cercando
   `ORB RUNNER:` / `ORB INIT:` / `ORB TP1:`. La riga che compare (o la sua
   assenza totale, che indicherebbe il punto B) **dice quale delle ipotesi e'
   quella giusta in un minuto**, invece che in tre giorni di confronti a mano.

---

## 📐 02/09 sera — CONTROPROVA STORICA DELL'IPOTESI A (SelPos/hedging), misurata sul CSV

Fatto il controllo incrociato su `trades_auto.csv` (conto piccolo): per OGNI
trade ORB storico, quali ALTRE posizioni U30USD erano aperte durante la sua
vita?

| data ORB | trailing? | posizioni U30 sovrapposte (magic, aperte PRIMA?) |
|---|---|---|
| 11/08 | n/d | nessuna |
| 13/08 | n/d | Dow Apertura US 770202 (aperta DOPO l'ORB) |
| **19/08** | **NO (misurato)** | **SW DOW H2 L 1/3 + 2/3 (770531), aperte alle 14:00 — PRIMA dell'ORB — e vive per TUTTA la sua durata** |
| **21/08** | **NO (misurato)** | **SW DOW H2 S 1/3 + 2/3 (770531), aperte il 20/08 — PRIMA — e vive per tutta la durata** |
| 24/08 | n/d | EMA200 DOW S1 (aperta 14:32, PRIMA dell'ORB delle 14:46) |

**Nei DUE giorni in cui il mancato trailing e' misurato (19 e 21/08), sul
piccolo c'era SEMPRE una posizione U30USD piu' VECCHIA di un altro magic,
aperta per tutta la vita del trade ORB.** `PositionSelect(_Symbol)` seleziona
la piu' vecchia -> magic diverso -> `SelPos()` falso -> `ManageRunner()` esce
alla prima riga, muto. **L'ipotesi A spiega esattamente i giorni misurati.**
E spiega anche perche' il 100k trailla: li' girano solo i 5 specchi, l'ORB
sul Dow e' (quasi sempre) solo.

**Il caso di oggi (02/09) NON falsifica A ma non la conferma**: le due
posizioni U30 gemelle (sell 0,1+0,1 dal 31/08) sono morte alle 15:00:23,
lo STESSO secondo del fill ORB — dopo, dall'export delle 21:07, l'ORB
sembrerebbe solo. MA una posizione U30 aperta PRIMA della finestra del
report e ANCORA aperta alle 21:07 sarebbe INVISIBILE in quell'export
(non e' ne' chiusa ne' fra gli ordini di oggi). Percio' domani si aggiunge
al controllo: **foto delle POSIZIONI APERTE sul piccolo (tab Trade), con
simbolo e ora di apertura** — se c'e' una U30 vecchia di un altro magic,
A spiega anche oggi; se non c'e', il caso di oggi punta su B (newBar
appiccicoso) e lo decidono i log v1.03.

### Checklist 03/09 aggiornata (ordine)
1. Foto pannello input ORB su ENTRAMBI i terminali (`InpUseTrailEMA`,
   `InpTP1Pct`, `InpExecTF`, titolo versione).
2. Foto POSIZIONI APERTE del piccolo (tab Trade): tutte, con ora apertura.
3. Log del piccolo 16:00->17:45 ora italiana (Esperti + Giornale).
4. Quando Claudio vuole: ricompilazione v1.03 (solo log) su entrambi con
   `aggiorna_verifica_orb.ps1` — stringa che passa PRIMA dal verificatore.

---

## 📸 03/09 mattina — FOTO 1/3: pannello input ORB del CONTO PICCOLO, letto riga per riga

`ABTG_ORB_Ottimizzato 1.02 (U30USD,M5)`, magic 770611, Guardian=true:

- **`Trailing dello stop sull'EMA veloce = true`** (EmaFast 9, EmaSlow 21) -> il trailing E' ACCESO
- **`TF di esecuzione = 5 Minutes`** -> InpExecTF valido, la EMA e la barra di
  esecuzione puntano a M5 (l'ipotesi "ExecTF strano" si sgonfia; resta B solo
  nella variante "storico M5 non disponibile in quel momento", meno probabile)
- **`% chiusa al target = 0.0`** -> il difetto n.2 CONFERMATO ancora presente:
  TP1 e breakeven morti su questa istanza ("Stop in pari dopo la parziale =
  true" e' inerte)
- Range 14:30->14:45 server, fine giornata 21:00, CloseAtEnd true,
  OneTradePerDay true, PendingExpiry 600 min, solo LONG, SL HALFRANGE,
  TP RANGE x1,5, rischio 1,0%, Verbose true

**VERDETTO della foto: gli INPUT del piccolo NON sono la causa** (come il
22/08). Il discriminante resta fra A (SelPos/posizione U30 piu' vecchia di
altro magic) e B (newBar appiccicoso) — e lo decidono la FOTO 2 (posizioni
APERTE del piccolo con ora di apertura) e la FOTO 3 (log 16:00->17:45 IT di
ieri), piu' il confronto col pannello del 100k.

### 🔗 03/09 — incrocio con la pagella AUTOMATICA del 02/09 (giornata_2026-09-02.md)

La pagella ufficiale ha aggiunto tre fatti che entrano in questa indagine:

1. **La foto 1 di stamattina ELIMINA la sua candidata (a)** ("trailing spento
   sul grafico piccolo"): `Trailing dello stop sull'EMA veloce = true`,
   fotografato. Restano: (b) `PositionModify` rifiutato (lo dice il Giornale
   del piccolo nella finestra del trade), (c) terminale fermo/disconnesso
   (stesso Giornale), piu' le nostre A (SelPos/hedging) e B (newBar) del
   dossier — che la v1.03 rendera' distinguibili in un log.
2. **Pista con una data**: le uscite gemelle erano IDENTICHE l'11 e il 13/08;
   le divergenze cominciano il 19/08 — il giorno dell'incidente del template,
   quando la sedia ORB del piccolo fu l'unica ricostruita senza fotografia.
   (NB: non contraddice A — anche l'11 e il 13/08 il piccolo aveva vicini di
   simbolo, ma l'11 non ne aveva e il 13 il vicino e' entrato DOPO: il
   pattern resta compatibile. Da tenere entrambe.)
3. **SCOPERTA INDIPENDENTE E PIU' URGENTE DEL TRAILING — la TAGLIA**: il
   rapporto lotti 100k/piccolo e' passato da ~6 (contratto: 0,3% sul 100k
   contro 1,0% sul piccolo) a ~20 fra il 21 e il 24/08 = **il 100k gira a
   1,0%, 3,3 VOLTE il contratto**. Il +1.680 del 02/09 e' fuori contratto;
   riportata a 0,3% la sedia sul 100k vale circa −383, non +496.
   ==> LA FOTO DEL PANNELLO 100k ha ora DUE bersagli: gli input del
   trailing E la riga "Rischio per trade in %" (contratto: 0,3 — se dice
   1,0 e' il difetto). L'eventuale correzione la esegue Claudio con la
   legge dello screenshot, come sempre.

### 📸 03/09, 07:34 — FOTO 2: pannello ORB del CONTO 100k. DUE VERDETTI IN UNA FOTO

`ABTG_ORB_Ottimizzato 1.02 (U30USD,M5)`, magic 770611, letto riga per riga e
confrontato campo per campo con la foto del piccolo delle 07:29:

1. **I DUE PANNELLI SONO IDENTICI IN OGNI RIGA** (trailing EMA true 9/21,
   ExecTF 5 Minutes, TP1Pct 0.0, SL HALFRANGE, TP RANGE x1,5, OneTradePerDay
   true, solo long, Guardian true, Verbose true, MaxSpread 0, versione 1.02).
   ==> input identici + binario identico + comportamento DIVERSO = la causa
   del trailing NON sta negli input ne' nella build: e' posizionale o
   ambientale. Le candidate vive restano A (SelPos/hedging: il piccolo ha
   VICINI di simbolo su U30USD, il 100k praticamente mai), B (newBar), e
   (b)/(c) della pagella (PositionModify rifiutato / terminale fermo — le
   decide il Giornale). La v1.03 in repo le rendera' distinguibili in un log.
   NB: TP1Pct=0.0 ANCHE sul 100k -> il difetto n.2 (breakeven morto) e' su
   ENTRAMBE le istanze, uguale. Coerente: il 100k non ha mai mostrato BE,
   solo trailing.
2. **"Rischio per trade in % = 1.0" SUL 100k — CONFERMATA la sovrataglia
   3,3x della pagella.** Il contratto (DEPLOY_GUARDIANO_100K.md,
   CONTRATTI_SEDIE.md) dice 0,3% per ORB 770611 sul 100k. La correzione
   proposta a Claudio (da eseguire lui, legge dello screenshot): campo
   "Rischio per trade in %" 1.0 -> 0.3 sull'istanza del 100k, screenshot
   prima e dopo, OK. Nessun altro campo si tocca.

### ✅ 03/09, 08:10 — CORREZIONE TAGLIA ESEGUITA DA CLAUDIO (legge dello screenshot rispettata)

Screenshot DOPO letto riga per riga: pannello `ABTG_ORB_Ottimizzato 1.02
(U30USD,M5)` sul conto 100k, **"Rischio per trade in % = 0.3"** — riportato
al contratto. NESSUN altro campo cambiato (verificato contro la foto delle
07:34: trailing true 9/21, TP1Pct 0.0, ExecTF 5 Minutes, magic 770611,
tutto identico). Sequenza completa: foto prima (07:34, 1.0) -> modifica ->
foto dopo (08:10, 0.3). **IL CASO SOVRATAGLIA 3,3x E' CHIUSO**: dal
prossimo trade il rapporto lotti gemelli deve tornare ~6 (0,3%/1,0% x 20)
— la PRIMA COPPIA GEMELLA FUTURA e' la verifica sul campo.

Restano aperti, sul mistero del trailing: foto posizioni APERTE del
piccolo + Giornale del piccolo (02/09, 16:00->17:50 IT), e i log della
v1.03 alla prossima ricompilazione.

_(03/09 08:17 — controllo finale: Claudio ha riaperto il pannello del
PICCOLO, verificato "Rischio per trade in % = 1.0" (contratto rispettato,
nessuna modifica necessaria) e chiuso con Annulla. Quadro taglie definitivo:
piccolo 1,0% / 100k 0,3%, entrambi fotografati.)_

---

## 🔫 03/09, 08:19 — FOTO A (posizioni aperte del piccolo): LA PISTOLA FUMANTE

Screenshot della scheda Trade del piccolo, letto riga per riga:

| ticket | simbolo | apertura | tipo | magic | commento |
|---|---|---|---|---|---|
| 3299061 | GBPUSD | 02/09 16:00:39 | buy 0,08 | 772422 | EASYTREND GBPUSD L |
| 3302773 | XAUUSD | 03/09 07:06:49 | buy 0,01 | 770402 | MAXMIN ORO BUY |
| **3280485** | **U30USD** | **01/09 08:45:01** | **sell 0,10** | **772341** | **LARRY DOW S** |

**`LARRY DOW S` (magic 772341) e' APERTA SUL DOW DAL 01/09 alle 08:45 — cioe'
era viva PRIMA e DURANTE tutta la vita del trade ORB di ieri (fill 15:00:23,
morte 16:45:11).** Era invisibile nel ReportHistory di ieri sera (ne' chiusa
ne' fra gli ordini del giorno) — esattamente il buco di osservazione
dichiarato ieri notte nella controprova storica.

### ⚖️ L'IPOTESI A E' ORA CONFERMATA SU TUTTI E TRE I GIORNI MISURATI

| giorno senza trailing | posizione U30 piu' VECCHIA di altro magic, viva per tutta la vita dell'ORB |
|---|---|
| 19/08 | SW DOW H2 L 1/3+2/3 (770531, aperte 14:00) |
| 21/08 | SW DOW H2 S 1/3+2/3 (770531, aperte il 20/08) |
| **02/09** | **LARRY DOW S (772341, aperta il 01/09 08:45)** |

E sul 100k girano solo i 5 specchi: l'ORB sul Dow e' solo -> trailla sempre.
Meccanismo: `PositionSelect(_Symbol)` su conto HEDGING seleziona la posizione
PIU' VECCHIA del simbolo; se non e' dell'ORB, `SelPos()` fallisce sul magic e
`ManageRunner()` (e `ManageTP1()`, che condivide la stessa prima riga) esce
in silenzio. **Il colpevole e' il codice, identico sui due conti: cambia solo
il VICINATO.**

Formalita' residue (dichiarate): la conferma STRUMENTALE arrivera' dal log
n.4 della v1.03 al prossimo trade ORB con vicini ("SelPos falso ma posizioni
nostre esistenti"). La FOTO B (Giornale) resta utile ma non piu' decisiva.

### 🛠️ Prossimi passi proposti (niente si tocca in forward senza firma)
1. ✅ **AUDIT DI FLOTTA — FATTO il 03/09**: referto in
   **`report/AUDIT_POSITIONSELECT_HEDGING_2026-09-03.md`**.
   126 file esaminati: **26 🔴 vulnerabili · 8 🟠 "mezzo fix" (leggono per
   ticket ma CHIUDONO per simbolo — su hedging chiudono la posizione del
   VICINO) · 85 🟢 sani · 7 ⚪ non tradano**. In cima alla classifica di
   gravita': ORB_Ottimizzato 770611 (U30USD, 9 vicini, gia' misurato),
   MaxMinNotte 770402 (XAUUSD, 13 vicini) e Gold_Ichimoku 250604.
   🔥 **Scoperta che allarga il caso**: la stessa `SelPos()` governa anche
   `HandleOCO()` e `gHadPos`/`InpOneTradePerDay` — da cieco **il pendente
   opposto non si disarma e il "un trade al giorno" non si arma mai**: e' un
   difetto di **RISCHIO** (esposizione doppia), non solo di gestione.
2. **FIX v1.04 dell'ORB** (dopo l'audit, che dice se conviene un fix nel
   singolo EA o in un helper condiviso): selezione della posizione PER
   MAGIC iterando le posizioni, non col PositionSelect nudo. Da scrivere,
   autotestare, verificare — poi ricompilazione firmata da Claudio.

---

## 🛠️ 03/09 — v1.04 IL FIX (SOLO REPO, da firmare e ricompilare)

`mql5/Experts/ABTG_ORB_Ottimizzato.mq5` portato a `#property version "1.04"`.
**Non è compilato, non è in forward, non tocca nessun terminale**: vive nel
repo finché Claudio non firma e non si esegue
`backtest_pipeline/aggiorna_verifica_orb.ps1` con la legge dello screenshot.

### 📐 La forma del fix (lettura E scrittura, insieme)
L'audit del 03/09 lo impone: correggere solo la **lettura** crea la categoria
🟠 — _"trovo la mia posizione, decido di chiuderla, e chiudo quella del
vicino"_ — che su un simbolo affollato è **peggio del bug originale**. Qui le
due mosse sono nello stesso commit.

- **Nucleo PURO, autotestabile a tavolino** (non tocca il terminale):
  `PosMia_Calc()` (predicato simbolo+magic), `ElencaTicketMiei_Calc()` (i
  nostri ticket, **ordinati per ticket crescente**), `ScegliTicketMio_Calc()`
  (restituisce il NOSTRO ticket e, come informazione di servizio, **quale
  ticket avrebbe agganciato `PositionSelect(_Symbol)` e di che magic è**).
- **Guscio sottile**: `LeggiPosizioni()` fotografa `PositionsTotal()` in tre
  array; `SelPos()` chiama il nucleo, scrive `gTicketMio` e riaggancia con
  **`PositionSelectByTicket`** (così tutte le `PositionGet*` che seguono
  leggono la NOSTRA posizione, come prima).
- **Nel file non resta nessun `PositionSelect(_Symbol)`, nessun
  `PositionClose(_Symbol)`, nessun `PositionModify(_Symbol,...)`** — solo
  citazioni nei commenti che spiegano cosa c'era prima.
- 📌 Nei commenti la premessa è scritta **giusta**: _"il ticket più basso"_,
  non _"la più vecchia"_ (correzione misurata in
  `VERIFICA_CHIUSURE_INCROCIATE_2026-09-03.md`: 16,5% delle coppie ha
  l'ordine per ticket invertito rispetto all'orologio, perché una posizione
  nata da un **pendente** eredita il ticket di quando il pendente è stato
  **piazzato** — ed è esattamente come entra questo EA).

### ✅ I punti corretti, uno per uno

| punto (file:funzione) | prima (v1.03) | dopo (v1.04) |
|---|---|---|
| `SelPos()` | `PositionSelect(_Symbol)` + check magic | scorre le posizioni, filtra **simbolo+magic**, sceglie il **nostro ticket più basso**, riaggancia con `PositionSelectByTicket` |
| `OnTick()` ramo `gHadPos`/`InpOneTradePerDay` | cieco con i vicini → **"un trade al giorno" non si armava MAI** | si arma sempre |
| `HandleOCO()` | cieco con i vicini → **il pendente opposto restava armato** | disarma sempre |
| `ManageTP1()` breakeven | `PositionModify(_Symbol, …)` | `PositionModify(gTicketMio, …)` + **riaggancio per ticket dopo il parziale** (prima si leggevano SL e tipo da dati vecchi) + log del fallimento |
| `ManageRunner()` uscita su EMA (long e short) | `PositionClose(_Symbol)` ×2 | `PositionClose(gTicketMio)` ×2, ticket nel log |
| `ManageRunner()` trailing (long e short) | `PositionModify(_Symbol, …)` ×2 | `PositionModify(gTicketMio, …)` ×2, ticket nel log |
| `OnTick()` flatten notizie | `if(SelPos()) PositionClose(_Symbol)` | `ChiudiPosizioniMie("blackout notizie")` |
| `EndOfDay()` | `if(InpCloseAtEnd && SelPos()) PositionClose(_Symbol)` | `if(InpCloseAtEnd) ChiudiPosizioniMie("fine giornata")` |
| `ContaPosizioniMagic()` | loop a sé stante (solo diagnostica) | riscritta **sopra al nucleo puro**: una sola implementazione del filtro |

### 🔍 I log della v1.03: TUTTI conservati, uno riscritto
`ORB INIT:` (handle EMA), `ORB TP1:` (il difetto n.2, `InpTP1Pct=0` che uccide
il breakeven) e i rami `ORB RUNNER:` 2-12 sono **invariati**, con l'aggiunta del
**ticket** nelle righe di trailing/uscita.

Il **log n.4** (_"SelPos falso ma posizioni nostre esistenti"_) era il **test**
dell'ipotesi: adesso quella condizione è **impossibile per costruzione**.
Al suo posto due cose:
1. 🎯 **`ORB SELEZIONE:`** dentro `SelPos()` — stampa **una volta per ticket**,
   e **solo quando il ticket più basso del simbolo NON è il nostro**: dice
   quale posizione nostra è stata presa, quante ne abbiamo, e **quale ticket
   di quale magic avrebbe agganciato la v1.03**, dichiarando che lì sarebbe
   uscita cieca. **È così che il fix si verifica in campo**, al primo trade
   con vicini: se quella riga compare e nella stessa barra compare anche
   `ORB RUNNER: stop … trascinato`, il caso è chiuso sul campo.
2. 🚨 Nel ramo 1 di `ManageRunner()` resta un controllo, ma cambia significato:
   diventa un **allarme di invariante violata** (posizioni nostre presenti e
   selezione per ticket fallita = anomalia del terminale, non più il difetto
   hedging).

### 🧪 AUTOTEST — 10 blocchi, 33 casi, contati due volte
Pattern di casa (`ABTG_LondonFx`): `#define ORBOTT_AUTOTEST_BLOCCHI_ATTESI 10`
e `#define ORBOTT_AUTOTEST_CASI_ATTESI 33`. **Due contatori e non uno**: un
blocco cancellato non deve poter passare per verde, e nemmeno un blocco
svuotato delle sue asserzioni. Gira in `OnInit` dietro `InpAutoTest` (default
true), stampa `ORB AUTOTEST:` e **non tocca il mercato**.

| # | blocco | casi | perché c'è |
|---:|---|---:|---|
| 1 | `PosMia_Calc` simbolo+magic | 4 | il magic da solo non basta, il simbolo da solo nemmeno |
| 2 | lista vuota (0 posizioni) | 3 | non deve inventarsi ticket |
| 3 | **1 sola posizione, nostra** | 3 | il caso del 100k, dove il difetto non mordeva |
| 4 | **solo un vicino** (0 nostre) | 4 | non selezionare niente, ma saper dire di chi è il ticket più basso |
| 5 | 🎯 **vicino con ticket PIÙ BASSO + la nostra** | 4 | **IL caso del 19/08, 21/08, 02/09** |
| 6 | vicino con ticket più alto | 3 | non-regressione del caso che già funzionava |
| 7 | **N=2 posizioni nostre** + vicino | 3 | il doppio ingresso che l'OCO cieco rendeva possibile |
| 8 | **ordine di lista invertito** | 2 | l'indice non è il ticket (la correzione di premessa del 03/09) |
| 9 | filtro **simbolo** | 3 | una nostra su un altro simbolo non si tocca |
| 10 | `ElencaTicketMiei_Calc` (le **chiusure**) | 4 | garanzia che il flatten non possa toccare un vicino |

**Cosa l'autotest NON prova** (dichiarato): che `PositionSelect(_Symbol)` scelga
davvero il ticket più basso su hedging. Resta la **premessa** del limite n.4
della VERIFICA — coerente con 16 giornate su 16, mai testata in laboratorio.
Il fix però **non ne dipende**: qualunque cosa scelga il terminale, noi
scegliamo la nostra.

### ⚠️ I CAMBI DI COMPORTAMENTO REALI — da mettere davanti a Claudio PRIMA della firma
Non è "solo un fix di igiene". Sui giorni **con vicini** l'EA farà cose che
prima non faceva:

1. 🔴 **`InpOneTradePerDay` ora si arma anche coi vicini.** Prima `gHadPos`
   restava falso per sempre e i pendenti superstiti potevano riaprire in
   giornata. **Atteso: MENO trade su U30USD, non di più.**
2. 🔴 **L'OCO ora disarma il pendente opposto anche coi vicini.** Sul gemello
   nativo questo difetto ha prodotto **4 secondi lati su 16 giornate** (e per
   fortuna +201 EUR: fortuna su n=4, non un argomento).
3. 🔴 **Trailing, uscita su EMA e breakeven ora ESEGUONO coi vicini.** È la
   cura del caso 02/09 (−50,91 contro +1.680 del gemello). **Cambia la vita
   dei trade**: uscite diverse, P/L diverso in entrambe le direzioni. **Non si
   promette più profitto**: si promette che l'EA fa quello che dice il
   pannello.
4. 🔴 **La chiusura di fine giornata ora avviene davvero** nei giorni con
   vicini (prima non chiudeva niente) — e chiude **il nostro ticket**, mai
   quello del vicino.
5. 🟡 **Se ci fossero DUE posizioni nostre**, `EndOfDay`/flatten le chiudono
   **entrambe**; runner e TP1 gestiscono **solo quella col ticket più basso**.
   Limite dichiarato, non nascosto.
6. 🟡 **Riaggancio per ticket dopo il parziale** in `ManageTP1()`: il breakeven
   ora lavora su dati freschi. Con `InpTP1Pct=0` (configurazione attuale su
   ENTRAMBI i conti) **questo ramo non viene mai eseguito**: il difetto n.2
   resta lì, aperto e dichiarato, e **non è stato toccato in questo giro** —
   una modifica alla volta.
7. 🟢 **Nuovo input `InpAutoTest`** (default true) in fondo al gruppo
   "Generali": stampa e basta, nessuna decisione di trading. I `.set` esistenti
   non lo contengono e MT5 userà il default: nessun altro campo cambia.

### 📏 Come si verifica (e come NON si verifica)
- **Backtest, test di NON-REGRESSIONE**: stessa cella prima/dopo, a parità di
  tutto. Nel tester l'EA è **solo** sul simbolo, quindi il ticket più basso è
  sempre il nostro: **il risultato atteso è IDENTICO al centesimo**. Se
  cambia, il fix ha rotto qualcos'altro. Non è un test di merito.
- **Forward, test di MERITO**: al primo trade con vicini sul conto piccolo,
  nel Giornale devono comparire **`ORB SELEZIONE:`** e, sulla stessa
  posizione, le righe **`ORB RUNNER: stop … trascinato`**. Metrica attesa:
  **nessun aumento di frequenza** (semmai calo), peggior giornata e DD in
  calo sui giorni con vicini.
- 🚫 **Non si dichiara risolto niente finché non compila e non gira.** Qui non
  c'è MetaEditor né Strategy Tester: **la compilazione non è stata verificata**,
  l'autotest **non è stato eseguito** (si legge ESEGUENDO, non scrivendo).

### 🚧 Cosa NON è stato toccato in questo giro (una variabile alla volta)
- `ABTG_ORB.mq5` **nativo** (l'unico col difetto misurato in forward) e il suo
  `InpOneTradePerDay` dichiarato e mai letto: coda dei fix, giro successivo.
- `ABTG_MaxMinNotte`, `Gold_Ichimoku_TK_ATR_EA`, i due Aperture 🟠, l'helper
  condiviso `ABTG_PosHedge.mqh` e gli 11 file in `standalone/`.
- Il **difetto n.2** (`InpTP1Pct=0` che uccide il breakeven): dichiarato dal
  log, non corretto. È una scelta di configurazione, la firma Claudio.

### ✍️ 03/09, ~11:05 — PERIMETRO DEL DEPLOY v1.04 FIRMATO
Claudio, testuale: "FIRMO IL PERIMETRO PICCOLO". La v1.04 si ricompila SOLO
sul piccolo; il 100k resta com'e' fino a fine Fase 1 (D1 dei mirror).
Sequenza: compilazione di prova sul PC di backtest -> se 0 errori, deploy
sul piccolo via aggiorna_verifica_orb.ps1 (22/08) con screenshot.
Verbale firma: report/FIRME_2026-09-03.md.


## ✅ 03/09 14:18 — PASSO 1 ESEGUITO: la v1.04 COMPILA
Referto: `backtest_pipeline/risultati_archivio/REFERTO_COMPILA_ORB104_2026-09-03.txt`
(trascritto dalla chat, upload zip non riuscito). Risultato: **0 errori, 0 warning**,
`.ex5` 93.174 byte, versione letta 1.04, autotest 10/33 dichiarati, 0 `PositionSelect(_Symbol)`,
NESSUN DEPLOY (tre righe INVARIATO misurate). Rilievo della sessione: il giro e' partito
dal VPS (cartella dati Master 215D85..., -V3 scartate), non dal PC di backtest — nessun
danno, ma la prossima prova si lancia dal PC. **PASSO 2 bloccato** finche'
`aggiorna_verifica_orb.ps1` non e' ristretto al SOLO piccolo + `-VersioneAttesa 1.04`.


## 🟢 03/09 16:36 — PASSO 2 CONFERMATO: v1.04 VIVA SUL PICCOLO, 0 FALLITI
Screenshot scheda Esperti del conto 50503392 (piccolo): `ORB AUTOTEST: 10 blocchi su 10
passati, 33 casi dichiarati, 0 falliti. Nucleo di selezione hedge-safe VERIFICATO a tavolino
(NON sostituisce la prova in campo).` La v1.02 non stampa questa riga: e' la prova d'identita'
che il piccolo gira con la v1.04. Deploy eseguito dalla sessione Administrator (fatto nuovo
del 03/09: tutta la flotta gira sotto Administrator, non Master). Il 100k resta sulla v1.02,
come da perimetro firmato. Il mistero dei gemelli ORB (SelPos su hedging) e' chiuso: fix in
forward sul piccolo da questo momento.
