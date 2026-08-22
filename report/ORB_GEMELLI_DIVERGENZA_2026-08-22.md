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

## Prossimo passo, l'unico rimasto per chiudere il caso
1. **Confrontare data/ora di compilazione e dimensione in byte** del file
   `ABTG_ORB_Ottimizzato.ex5` nella cartella `MQL5\Experts` dei DUE terminali
   (piccolo vs 100k). Se sono diversi, e' la causa.
2. Se sono IDENTICI, il sospetto si sposta sul terminale/VPS: verificare se
   quell'istanza gira su una macchina diversa (VPS vs PC), e se il broker su
   quel conto accetta le modifiche di SL nello stesso modo (permessi,
   `TradeAllowed`, ecc — da leggere nel Giornale/Esperti attorno all'ora
   della nuova barra M5, cercando eventuali errori di `PositionModify`
   silenziati).
3. **Verificare `InpTP1Pct` anche sul conto 100k**, per sapere se il
   difetto del breakeven-morto e' condiviso o e' un'altra differenza fra
   le due istanze.

## Correzione di igiene proposta, indipendente dalla causa
`ManageRunner()` oggi non stampa NULLA quando muove lo stop (ne' quando NON
lo muove). Quindi anche quando il trailing FUNZIONA, il log resta muto: la
sola prova indiretta e' il prezzo di chiusura, come si sta facendo ora.
Aggiungere un `Log()` alla modifica riuscita/fallita di `PositionModify` in
`ManageRunner()` renderebbe la PROSSIMA occorrenza diagnosticabile in un
minuto invece che con un confronto a mano fra due conti.
