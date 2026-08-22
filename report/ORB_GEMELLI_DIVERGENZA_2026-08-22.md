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

## ✅ SOLUZIONE (decisa, non ancora eseguita) — resta valida, per un motivo diverso
**Ricompilare `ABTG_ORB_Ottimizzato.mq5` da `lavoro` (v1.02) su ENTRAMBI i
terminali**, cosi' girano lo stesso identico codice. `InpSLBufferPts` a
default 0 e' un no-op esatto (dichiarato nel suo stesso changelog): il
comportamento firmato non cambia. Il motivo per farlo ORA non e' piu'
"risolve il trailing" (non e' provato che lo faccia): e' **dare al conto
piccolo la protezione Guardian che oggi non ha**, ed eliminare la deriva
di versione in generale.
**Quando**: MT5 chiuso o comunque senza una posizione ORB aperta (dopo le
22:59 server o prima delle 14:25 server del giorno dopo).

## 🔍 Il mistero del trailing resta APERTO
Non isolato a livello di codice (le uniche due versioni vere confrontate
finora hanno `ManageRunner()` identica). Prossimi passi possibili:
1. Diff riga per riga delle altre funzioni (`TryPlace`, `SLforLong`/
   `SLforShort`, `ComputeRange`, `LotByRisk`, rilevazione `newBar`) fra
   v1.00 e v1.01 — non ancora fatto.
2. Ipotesi ambientale/terminale (es. l'handle dell'indicatore EMA non si
   carica per qualche motivo su quel terminale, `CopyBuffer` fallisce in
   silenzio e la funzione ritorna prima del `PositionModify` senza che
   nessuno se ne accorga: vedi anche la correzione di igiene sotto).
3. Dopo la ricompilazione a v1.02 su entrambi: se il trailing NON riparte
   sul piccolo, e' la prova che la causa e' ambientale, non di codice.

## Correzione di igiene proposta, indipendente dalla causa
`ManageRunner()` oggi non stampa NULLA quando muove lo stop (ne' quando NON
lo muove). Quindi anche quando il trailing FUNZIONA, il log resta muto: la
sola prova indiretta e' il prezzo di chiusura, come si sta facendo ora.
Aggiungere un `Log()` alla modifica riuscita/fallita di `PositionModify` in
`ManageRunner()` renderebbe la PROSSIMA occorrenza diagnosticabile in un
minuto invece che con un confronto a mano fra due conti.
