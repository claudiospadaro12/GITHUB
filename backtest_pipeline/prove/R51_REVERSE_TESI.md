# R51 — "il long e' saltato, si shorta?" — tesi prima dei numeri (14/08/2026)

_Domanda di Claudio dopo il DAX di stamattina: "il prezzo ha fatto il retest,
e' partito ma poi e' tornato indietro... si potrebbe fare un ordine short per
recuperare la perdita, tipo come fa Emiliano? Tipo un edge? O e' complicato?"_

Dentro quella frase ci sono **due cose diverse**. Una e' gia' bocciata con
verdetto scolpito, l'altra e' la migliore idea di fascia C arrivata finora.
Vanno separate prima di scrivere una riga di codice.

---

## 1. Quello che NON si fa: "recuperare la perdita"

Se il **motivo** del trade e' il rosso di prima, e la **size** la decide la
perdita da rimarginare, quello e' esattamente cio' che il progetto ha gia'
giudicato il 12/08 (`report/DIARIO.md`, censimento live del corso):

> "Mediazione": mai insegnata col suo nome ma **praticata da Emiliano come
> coperture/martingala** (conto 10k bruciato a luglio, sessione 03/08 da
> +1.200 a −800): **verdetto scolpito, NON si meccanizza, MAI in prop.**

Non e' una questione di gusto: e' che il rischio smette di essere una costante
(1R) e diventa una funzione di quanto si sta perdendo. In prop, dove il
pavimento e' un numero fisso, e' il modo piu' diretto per sbattere sul limite
giornaliero in una mattina storta.

**La domanda che separa le due cose, e va fatta ogni volta:**
_"prenderei questo short anche se il long di prima non fosse mai esistito?"_
Se la risposta e' si', e' un ingresso. Se e' no, e' una mediazione.

## 2. Quello che invece SI puo' fare — ed e' meglio di come sembra

Il "livello dove tornare" a cui pensa Claudio esiste gia' nel codice, con la
sua geometria misurata. Il retest e' **simmetrico**: `MonitorRetest()` ha
**due rami**, uno per lato (`ABTG_DAX_Apertura_EU.mq5`, righe ~1290 e ~1318).
Il ramo short e' scritto, compilato, mai eseguito dopo un fill:

- rottura sotto: `bid <= gRangeLow - buffer`
- ingresso: **SELL LIMIT** sul ritorno al livello, `gRangeLow + offset`
- stop: bordo opposto, `gRangeHigh + buffer`

Sul DAX di stamattina quel livello era **26.428,90** (L 26.426,90 + 2,00), e
la rottura sotto e' avvenuta **nello stesso istante in cui il long e' andato
in stop** — perche' lo stop del long **e'** la rottura al ribasso: sono lo
stesso prezzo (`L - buffer` = 26.421,90). Non e' una coincidenza, e' la
geometria.

**Questo e' il punto che cambia tutto:** lo short "di ritorno" NON e' il fade
degli estremi (bocciato 48/48 in R42) e NON e' il breakout puro (bocciato
R7/02.08/R25). E' **il RETEST dall'altro lato**, cioe' l'unico motore che
nella famiglia Apertura ha sempre pagato (+1198,79 · PF 1,237 · DD 10,49%
all'1%, referto B1). Non stiamo proponendo un motore nuovo: stiamo dicendo che
**il motore promosso oggi lavora solo mezza giornata**.

## 3. Perche' non parte mai (due righe di codice, non un problema di strategia)

1. **Riga 1311**: appena il BUY LIMIT viene piazzato, `gPhase = PH_PLACED`.
   In `PH_PLACED` la macchina a stati non chiama piu' `MonitorRetest()` →
   **il lato short viene abbandonato per la giornata**.
2. **`InpOneTradePerDay = true`** (riga 230, guardia A4): anche se il primo
   trade chiude in stop, il ciclo non si riapre.

Effetto collaterale che vale la pena scrivere: succede **anche quando il BUY
LIMIT non si riempie**. Se il limit scade inevaso e poi il prezzo rompe al
ribasso, l'EA sta comunque fermo. Quindi i casi persi sono due, non uno.

## 4. Quanto e' complicato: poco

Un input opt-in, `InpAllowReverse` (default **false** → **forward dei conti
vivi invariato**, stesso schema con cui il 01/08 e' entrato il RETEST). Quando
e' true:
- dopo il primo fill si resta in `PH_ARMED` per il lato **non ancora rotto**;
- si consente **un secondo e ultimo** ciclo nella giornata (tetto rigido: 2
  trade, mai 3 — altrimenti e' una griglia);
- la guardia A4 diventa "max 2 cicli", reload-safe come adesso.

Stima: ~50 righe, piu' il giro di lint. Il costo vero non e' il codice, e' il
banco.

## 5. IPOTESI (scritte prima di qualunque numero)

1. Lo short di ritorno dopo un long stoppato ha lo **stesso** edge del retest
   long, perche' e' lo stesso motore: PF nella banda 1,10-1,25.
2. Il campione e' **piccolo**: serve che (a) il long si riempia, (b) vada in
   stop, (c) il prezzo **torni** sul livello. La terza condizione e' quella
   che uccide la frequenza. **Stima onesta a priori: meno di 1 giorno su 5.**
3. **Rischio dichiarato che conta piu' del PF:** nelle giornate a due trade il
   rischio di giornata diventa **2R**. Anche con PF > 1, la coda del drawdown
   si allunga. E' per questo che il verdetto NON puo' venire dal PF.

## 6. CRITERI (congelati ora, 14/08/2026, a numeri non visti)

1. **Frequenza minima**: se il secondo ciclo si attiva in meno di **20 giorni**
   nella finestra OOS, il round si chiude come "misurato, non conclusivo".
   Nessuna promozione su un pugno di trade.
2. **Merito fuori campione**, sui soli trade del secondo ciclo: Profit > 0,
   **PF >= 1,10**, n >= 20.
3. **Cancello del drawdown (quello che decide davvero)**: la serie completa
   (primo + secondo ciclo) deve avere **DD <= DD della cella attuale**, non
   "poco piu' alto". Se aggiunge profitto ma alza il DD, **e' bocciato**: e'
   lo standard di portafoglio del progetto ("aggiunge profitto E abbassa le
   code"), qui applicato dentro la singola serie.
4. **Regola dei due banchi**: il verdetto vale solo se IS e OOS vanno nella
   stessa direzione. Un solo lato verde = riserva, non promozione.
5. **Simmetria obbligatoria**: si misura anche il caso speculare (short
   stoppato → long di ritorno). Se paga solo un lato, e' rumore direzionale
   della finestra, non un motore: **si boccia**.
6. Se passa tutto: giro per-trade a 100k con magic vergine, poi
   `dd_portafoglio.py` contro le 27 serie. Nessuna scorciatoia.

## 7. Ordine dei lavori

Prima si chiude il pasticcio trovato stamattina (**due istanze del DAX
Apertura con lo stesso magic 770101**, `report/DAX_14-08_DUE_MOTORI.md`):
mettere mano all'EA mentre non sappiamo con certezza quante copie girano e con
che parametri e' il modo di non capire piu' niente. Cinque minuti di
`config_in_uso.ps1`, poi R51.
