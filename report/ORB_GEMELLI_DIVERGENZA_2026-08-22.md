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
