# A1 e A4 — le due voci che non sono test, sono soldi

06/08/2026. Correzioni a `ABTG_DAX_Apertura_EU`, `ABTG_Nasdaq_Apertura_US`,
`ABTG_Dow_Apertura_US`, `ABTG_Apertura_Marco`.

---

# A4 — la guardia "un trade al giorno" non esisteva

## Cosa ho trovato

`InpOneTradePerDay` era dichiarato alla riga 185 e **non era usato in nessun punto del codice**.
L'unica cosa che limitava l'EA a un ciclo al giorno era la macchina a stati: una volta piazzato,
`gPhase` va a `PH_PLACED` e non torna indietro fino al giorno dopo.

Ma `gPhase` e' una variabile globale, e **al riavvio dell'EA riparte da `PH_WAIT_OPEN`**.
La guardia anti-duplicato che c'era (riga 479) controllava solo se in quel momento esisteva un
ordine o una posizione del proprio magic. **A trade gia' chiuso non vedeva niente.**

Ed e' esattamente quello che e' successo il **05/08 alle 09:46**: il riattacco degli EA ha
ripiazzato i pendenti su una giornata gia' operata — buy stop 26.440,50, ticket #3078825 e
#3078827 — su un DAX che aveva gia' fatto il suo trade alle 08:34.

## La correzione

Nuova funzione `HaGiaOperatoOggi()`: legge lo **storico dei deal del giorno** filtrando per
simbolo e magic, e cerca un `DEAL_ENTRY_IN`. Se oggi una posizione l'ha gia' aperta, la giornata
e' finita — anche se quella posizione e' gia' chiusa, anche se l'EA e' stato ricompilato nel
frattempo.

Chiamata una volta al giorno e a **ogni riavvio** (le globali ripartono da −1, quindi il
controllo si rifa'), non a ogni tick: `HistorySelect` non e' gratis.

```
if(InpOneTradePerDay && gGuardiaGiorno != now.day_of_year &&
   (gPhase == PH_WAIT_OPEN || gPhase == PH_BUILDING))
  {
   gGuardiaGiorno = now.day_of_year;
   if(HaGiaOperatoOggi())
     { ABTGLog("oggi ho GIA' operato (storico deal del giorno): non riarmo."); gPhase = PH_DONE; }
  }
```

**Effetto sul forward:** questo *cambia* il comportamento, ed e' voluto. Da adesso riattaccare un
EA a mercato aperto su una giornata gia' operata **non riarma piu' niente**. Prima lo faceva, e
quel secondo trade non previsto era pura perdita attesa.

Nel log si vedra' la riga *"oggi ho GIA' operato (storico deal del giorno): non riarmo"*.
Se compare, la guardia sta lavorando.

---

# A1 — due EA identici, 4% su un segnale solo

## Il fatto

`Apertura Marco` (magic 770311) e `DAX Apertura EU` (magic 770101) sono **identici su 64
parametri**. Il 05/08 hanno fatto lo stesso trade, allo stesso secondo, allo stesso prezzo:

```
08:34:46  DAX Apertura EU SELL   26.339,50 -> 26.332,30   +7,20
08:34:46  Apertura Marco SELL    26.339,50 -> 26.332,30   +7,20
```

Rischiano il 2% ciascuno: **4% su un segnale solo.** Con una regola prop da −5% giornaliero, un
trade solo arriva a un passo dal limite.

## La cosa nuova, che il 05/08 non sapevo

La configurazione che girano **e' misurata, ed e' nella zona che perde.**
Tutti e due usano `BREAKOUT` con `RangeMinutes=15` e `Buffer=200`.

| misura | range 15 |
|---|---|
| FASE A — geometria del breakout, fuori campione | **0 celle positive su 4** (−609 · −1464 · −1015 · −878) |
| FASE D — geometria del retest, fuori campione | **0 su 4** (−1537 · −1408 · −534 · −750) |
| FASE C — breakout, buffer 200, periodo intero | −78.78 · −818.84 · +449.19 · −408.83 → **1 su 4**, media −214.31 |

Il buffer 200 che usano sta esattamente fra le due celle peggiori della riga.
Per confronto, il candidato validato (retest 35/500/offset 200) fa **+1198,79 con PF 1,237** fuori
campione, con la stessa gestione.

**Quindi la domanda non e' piu' "quale dei due spengo".** Tutti e due stanno girando una geometria
che su 22 mesi di dati, con due motori indipendenti, non guadagna. Raddoppiarla non la migliora.

## La correzione nel codice — ed e' una mitigazione, non una soluzione

Nuovo input, **default 0 = spento**, cosi' nessun EA acceso cambia comportamento finche' Claudio
non decide:

```
input int InpMaxPosSimbolo = 0;   // tetto di posizioni+pendenti sul simbolo, contando TUTTI gli EA
```

`EsposizioneSimbolo()` conta posizioni e ordini pendenti sul simbolo **ignorando il magic**, e il
ramo che piazza si ferma se il tetto e' gia' raggiunto.

⚠️ **Perche' non basta.** Due EA possono piazzare nello stesso tick e non vedersi a vicenda: la
guardia riduce il rischio, non lo elimina. **La soluzione pulita e' spegnerne uno.** Lo scrivo
chiaro perche' un tetto che funziona il 90% delle volte, su una regola prop, e' un tetto che non
funziona.

---

# Cosa deve fare Claudio

## 1. Deploy (questo va fatto comunque, A4 e' un bug)

Ricompilare e riattaccare i quattro EA d'apertura. Il riattacco va fatto **fuori dalla finestra
operativa** — cioe' non fra le 08:00 e le 08:35 per il DAX, non fra le 14:30 e le 15:05 per gli
americani — finche' non si e' visto che la guardia nuova funziona.

## 2. La decisione su A1 — tre strade, in ordine di quanto sono difendibili

| | cosa si fa | effetto |
|---|---|---|
| **a. Spegnere `Apertura Marco`** | staccarlo dal grafico | il rischio sul segnale d'apertura DAX torna al 2%. È la strada pulita, e Marco non ha niente che l'altro non abbia — anzi ha **meno**: nel suo codice esistono solo BREAKOUT e GAPFILL, non puo' nemmeno fare il retest che abbiamo validato |
| **b. Tetto di esposizione** | `InpMaxPosSimbolo = 1` su tutti e due | mitiga, non risolve: resta la corsa nello stesso tick |
| **c. Differenziarli davvero** | ora/lato/geometria diverse | ha senso solo se la seconda configurazione e' validata quanto la prima. Oggi non lo e' |

**La mia raccomandazione e' (a)**, e non per il rischio doppio: perche' Marco gira una geometria
che abbiamo misurato negativa e non puo' nemmeno eseguire quella positiva.

## 3. Il seguito, che e' la cosa che vale di piu'

Portare `ABTG_DAX_Apertura_EU` alla configurazione validata — `InpEntryMode=2`,
`InpRangeMinutes=35`, `InpBufferPoints=500`, `InpRetestOffsetPts=200` — lasciando la gestione
com'e'. Quattro parametri. Ma e' una decisione separata da A1 e A4, e va presa con calma.
