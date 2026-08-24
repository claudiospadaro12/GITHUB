# R102 — BLOCCO 1 (Breaking Band): LA CLASSIFICA LUNGA, PRIMI NUMERI

_Corsa del 24/08/2026 00:05→00:24 (**19 minuti**, non le 6-16 ore stimate per
tutte e venti: la stima era sul round intero), pin
`393c68f2d1ac5805b8c7cfc4c638fba8135d6247`, modo CORSA, `-SoloSedia
'C01,C02,C03'`, modello **OHLC M1**, deposito 100.000, taglia viva 1,0%.
Zip agli atti: `R102_CLASSIFICA_LUNGA_CORSA_20260824_0005.zip` (21 CSV,
3 report `.htm`, referto driver archiviato accanto a questo file)._

> ⚠️ **QUESTO È UN BLOCCO, NON IL ROUND.** 3 sedie su 20. Nessuna classifica
> definitiva finché non girano gli altri 5 blocchi.

## 0. Prima di tutto: LA MACCHINA FUNZIONA

Il fix del guardiano (`Battito-Basi`, checklist della serata) ha retto: lo
**scarico M1 dei tre simboli è COMPLETO** — AUDUSD 9.614.917 barre dal
1993.04.26, EURUSD 10.014.728 dal 1971.01.03, GBPUSD 9.863.886 dal
1993.05.11, tutti dichiarati `COMPLETO` dal confronto disco/broker. Le tre
sedie hanno esito **OK**, i gemelli sono **IDENTICI al centesimo** su tutte,
i magic sono del blocco vergine `79xxxx`.

**L'`ESITO: PARZIALE` in coda al referto driver è una frase mal costruita,
non un guasto**: dice letteralmente *"0 sedie su 3 non sono OK"* — cioè
**tutte e tre sono OK**. L'uscita 1 nasce dai 3 rilievi «finestra
accorciata», che sono **risultati del round**, non errori. Difetto di
leggibilità corretto subito dopo (vedi §5).

## 1. LA RISPOSTA ALLA DOMANDA DI CLAUDIO (23/08)

> *"Le percentuali di guadagno su 100k sono confermate anche con tantissimi
> anni di storico o sono calate? Per esempio Breaking Band mi hai detto 133k
> ma con 10 anni di storico avrebbe fatto lo stesso?"*

**NO. E la differenza non è piccola: è di segno.**

| sedia | finestra COMUNE 2009→2026 | finestra LUNGA (anni OPERATI) | DD lungo |
|---|---:|---:|---:|
| **C03 AUDUSD** | **+13.025 €** · PF 1,491 · n 154 | **+8.901 €** · PF 1,207 · n 239 (27,5 anni) | 8,97% |
| **C01 GBPUSD** | +5.838 € · PF 1,078 · n 323 | **−11.574 €** · PF 0,897 · n 522 (27,5 anni) | **23,43%** |
| **C02 EURUSD** | +2.347 € · PF 1,069 · n 159 | +4.129 € · PF 1,075 · n 276 (27,4 anni) | 8,24% |

Tutti i numeri sono alla taglia viva 1,0% su 100k, **stima del LORDO**
(spread corrente applicato a vent'anni, zero slippage) e il DD è un
**limite inferiore** (OHLC non vede dentro la barra).

**La spina dorsale di GBPUSD è la lezione del round** — anno per anno,
cumulato:

| periodo | cosa è successo |
|---|---|
| 1999→2007 | **nove anni consecutivi di erosione**: cumulato da −54 a **−17.623 €** |
| 2008→2010 | primo respiro (+1.170, +1.018, +2.649) |
| 2011→2021 | altalena che non recupera: nel 2021 il cumulato toccava **−20.744 €** |
| 2022→2025 | la risalita vera (+2.281, +1.000, **+2.764**, **+3.912**) |
| totale | **−11.574 €** |

Tradotto: **l'edge di Breaking Band su GBPUSD, come è configurato oggi, vive
nel presente.** I numeri belli che avevamo visto vengono dalla finestra
recente; portati su ventisette anni non si ripetono — su GBPUSD si
capovolgono. AUDUSD è la sedia che regge meglio la storia: cumulato in salita
quasi monotona dal 2010 (+56 → +8.901).

**E questo NON è una bocciatura** (Emendamento regola B, firmato il 16/08:
*il VECCHIO giudica il RISCHIO, il RECENTE giudica il MERITO*). Il 2003-2006
di GBPUSD non boccia la sedia: dice che il suo merito va giudicato sul
recente, e che **il rischio è più grande di quanto il contratto promette**.

## 2. CORSIA RISCHIO — tutte e tre sforano il 2x, e va detto

| sedia | DD promesso (contratto) | soglia 2x | DD lungo misurato | verdetto |
|---|---:|---:|---:|---|
| C01 GBPUSD | 1,90% | 3,80% | **23,43%** (12,3x) | 🔴 REVISIONE |
| C02 EURUSD | 1,20% | 2,40% | 8,24% (6,9x) | 🟠 REVISIONE |
| C03 AUDUSD | 1,20% | 2,40% | 8,97% (7,5x) | 🟠 REVISIONE |

È **la stessa dinamica dell'oro** (R99/R100): il DD promesso viene da una
finestra recente e corta, il DD lungo è 7-12 volte più grande. La corsia
rischio non chiede di spegnere: chiede di **riscalare la taglia o riscrivere
il contratto col numero vero**. La proposta sedia-per-sedia si fa a blocchi
finiti, non su tre sedie di venti.

**Nota che assolve il forward di oggi**: la peggior giornata misurata è
−1,02% / −1,04% / −1,05% (su 548 giornate operative per GBPUSD), ben dentro
il muro giornaliero del 5%, e le due misure indipendenti (report `.htm` e
OPTFRAME dell'EA) **coincidono al centesimo**. Il problema è il DD di
percorso, non il singolo giorno.

## 3. LE FINESTRE DI REGIME — nessuna delle tre è "robusta" nel senso forte

Tutte e tre fanno **3 finestre positive su 5**. Ma i dettagli contano:

- **CROLLO (covid, feb-apr 2020)**: negativa su GBPUSD (−1.237) e AUDUSD
  (−637); EURUSD +531 con **n=1** (un'operazione: non è una misura).
- **TORO 2021**: GBPUSD **−3.909** (PF 0,482) — l'anno peggiore della sedia.
- **LATERALE 2019**: AUDUSD **−2.482** con PF 0,192 e n=5.
- I PF stratosferici (EURUSD CROLLO 163,96 / CRISI2008 174,50) sono
  **artefatti di campione minuscolo** (1 e 6 operazioni): non si citano come
  qualità.

Su campioni da 1-10 operazioni queste finestre **sospendono il giudizio di
merito** (regola R59) e restano dichiarative.

## 4. IL RILIEVO NUOVO, ED È GROSSO: **tutte e tre iniziano a operare nella STESSA settimana del gennaio 1999**

- GBPUSD: prima operazione **1999.01.14** (storico dichiarato dal 1993.05.11)
- EURUSD: prima operazione **1999.01.18** (storico dichiarato dal 1971.01.03)
- AUDUSD: prima operazione **1999.01.07** (storico dichiarato dal 1993.04.26)

Le barre M1 ci sono (9,6-10 milioni per simbolo, `COMPLETO` per tutti i TF),
ma **prima del gennaio 1999 non producono nessuna operazione su nessuno dei
tre simboli**. Tre motori indipendenti che tacciono per sei anni (e per
ventotto su EURUSD) e poi partono tutti nella stessa settimana **non è una
coincidenza del motore: è una proprietà del feed**. Il GATE 4 (densità),
firmato proprio per questo, lo cattura: **finestra nominale 34/56 anni →
finestra effettivamente operata 28**.

👉 **Conseguenza operativa, da qui in avanti**: quando si dice "storico
lungo" su BCM, il numero onesto è **~27 anni dal 1999**, non 33 né 55. Le
date della sonda del 17/08 sono le date che il broker *dichiara*, non quelle
in cui c'è mercato utilizzabile. Da verificare nei blocchi successivi: se
anche gli altri nove simboli iniziano nel 1999, il pavimento della
decisione 2 (firmata: *prima si misura, poi si taglia*) si sposta da
`1999.01.04` a **misura confermata**, e diventa il pavimento di casa.

## 5. Il difetto di leggibilità corretto subito

`ESITO: PARZIALE -- 0 sedie su 3 non sono OK` → frase che spaventa e non
informa (classe 47: la spia rossa decorativa). Corretto nel driver: quando
**nessuna** sedia è fuori posto e i rilievi sono soltanto dichiarativi,
l'esito dice **`COMPLETO CON RILIEVI`** ed esce **0**; `PARZIALE` resta per
le sedie davvero non-OK. Pin nuovo + verificatore prima del Blocco 2.

## 6. Cosa NON dice questo blocco

Tre sedie su venti; una sola cella per sedia (quella VIVA — questo round non
ottimizza e non cerca celle migliori: sarebbe pescare); niente tick reali,
niente spread storico, niente slippage; il DD è un limite inferiore; il
profitto è una stima generosa del lordo e **non è un guadagno**; il DD di
PORTAFOGLIO delle sette sedie BB su GBPUSD resta non misurato (round
diverso, macchina R16/R34).

## 7. Coda

Blocco 2 (`'C14,C15,C16'`, GapFill forex) col pin corretto dopo il
verificatore. Le barre M1 dei tre simboli fatti **restano su disco**: i
blocchi che li riusano partono avvantaggiati.
