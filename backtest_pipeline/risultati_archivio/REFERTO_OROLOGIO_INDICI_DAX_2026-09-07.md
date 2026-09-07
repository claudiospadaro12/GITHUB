# 🕐 SONDA DELL'OROLOGIO — RAMO INDICI, META' DAX — 07/09/2026

> ## 🔴 VERDETTO: **SUL DAX L'OROLOGIO NON ESISTE.**
> Ogni ora "verde" e' **deriva del mercato**, non un bordo. Misurato sui due lati:
> **0 fasce asimmetriche su 72 in OOS**, 1 su 72 in IS (e quella perde da tutte
> e due le parti). La pista si chiude **con un numero nostro**.

**Stato:** meta' round. Girate le celle **11 (DAX long)** e **12 (DAX short)**.
Le due del **Dow (13, 14) NON sono girate**: il cancello I1 e' un criterio DI
INSIEME sui due simboli, quindi **su U30USD non si conclude niente**.

- Pin: `fa7f33da9db7713b99dfce26b37dcaed8871fdc1` (driver v5)
- Contratto congelato: `backtest_pipeline/prove/SONDA_OROLOGIO_INDICI.txt` (criteri I1-I8)
- CSV grezzi: `risultati_archivio/orologio_indici_csv/`
- Finestra `2024.09.26 -> 2026.06.30`, split 40/60, H1, Modello 4, 144 passate per cella

---

## 1. 🎯 LA LETTURA CHE DECIDE — i due lati INSIEME (criterio I7)

Il criterio, congelato **prima** di vedere qualunque numero, dice che i due lati
non si leggono separati: `deriva=(L-S)/2`, `asimm=(L+S)/2`, e se
`|asimm| <= |deriva|` quella fascia e' **DERIVA**, non un orologio.

| finestra | fasce ASIMMETRICHE (candidate a "orologio") |
|---|---|
| IS | **1 su 72** — ora 7 durata 8h, `asimm = -487`: **negativa**, cioe' perde da tutte e due le parti. E' costo, non bordo |
| **OOS** | **0 su 72** |

Nella stragrande maggioranza delle celle **LONG = -SHORT esatto**, cioe'
`asimm = 0` alla cifra. Non "quasi": esattamente.

## 2. 🧨 LE DUE ORE CHE SEMBRAVANO BUONE, SMONTATE

**Ora 17** — la migliore in assoluto dell'IS, poi negativa in OOS:

| | LONG | SHORT | asimm |
|---|---:|---:|---:|
| IS  4h | +9316 | -9316 | **0** |
| OOS 4h | -1481 | +1481 | **0** |

Non si e' "rotta" passando all'OOS: **non e' mai stata un bordo.** Era la
direzione che l'indice ha preso in quella finestra.

**Ora 15** — l'unica che teneva il segno su tutte e due le finestre, e che in
prima lettura (solo lato long) sembrava la sopravvissuta:

| | LONG | SHORT | asimm |
|---|---:|---:|---:|
| IS  8h | +2196 | -2196 | **0** |
| OOS 8h | +5071 | -5071 | **0** |

**Deriva pura in entrambe.** 👉 Questa e' la voce piu' istruttiva del round: con
il **solo lato long** era il candidato migliore; con i **due lati insieme** non
esiste. La regola dei due lati (25/08) e il criterio I7 hanno fatto esattamente
il lavoro per cui erano stati scritti.

## 3. ✅ PERCHE' UNA TABELLA PIATTA E' UN ESITO VALIDO

Lo dichiarava il referto **prima** della corsa:
> _"E se la tabella e' PIATTA, l'esito e' VALIDO e va scritto cosi': il caduto
> **D7** (l'ora del fix, chiuso il 22/08) esce **CONFERMATO ED ESTESO** e la
> pista dell'orologio si chiude con un numero NOSTRO."_

Prima c'era un sospetto. Adesso ci sono **144 misure su due lati** che dicono di
no, su un simbolo dove la flotta lavora davvero.

## 4. ⚠️ I LIMITI, DICHIARATI

1. **UN SOLO REGIME, toro pieno.** La finestra e' un mercato solo. Cio' che il
   round esclude e' *"un'ora con un bordo in QUESTO regime"*; non esclude che
   un'ora possa contare in un orso. Il criterio I7 e' proprio la difesa contro
   questo, ed e' il motivo per cui il risultato regge: la deriva viene tolta.
2. **MERITO SOSPESO su tutte e 72 le fasce** (criterio I5): meno di 150 giornate
   operate, in entrambe le finestre. **Il rischio si legge, il merito no.**
   Qui non morde, perche' il verdetto e' negativo: non stiamo promuovendo niente.
3. 🔴 **26 fasce su 72 hanno ATTRAVERSATO LA NOTTE** (PROBLEMI del referto): la
   chiusura forzata non e' ermetica quando si entra tardi con durate lunghe.
   Su quelle fasce c'e' dentro anche il rischio overnight, che il mandato
   escludeva. **Non cambia il verdetto** (l'asimmetria e' zero comunque), ma se
   un domani si riaprisse la pista, il difetto va corretto prima.
4. **Determinismo del banco NON misurato in questo giro**: il ramo INDICI non ha
   una cella gemelli. Che due passate identiche diano due righe identiche su
   questa macchina, qui, non e' verificato.
5. **Il Dow non e' misurato.** Meta' del round manca, e I1 e' di insieme.

## 5. 🟢 UN RILIEVO DEL REFERTO CHE NEL FRATTEMPO E' STATO CHIUSO

Il referto segnala _"PROFONDITA' A TICK MAI MISURATA su D30EUR"_ — vero quando
il driver e' stato pinnato, **non piu' vero adesso**: la misura e' stata fatta
lo stesso giorno (`risultati_archivio/misura_tick/misura_tick_D30EUR.csv`:
**35.408.137 tick dal 2024.09.26**, col muro delle barre M1 alla stessa data).
👉 **La finestra e' coperta da tick VERI**, quindi le colonne dello spread di
questo round reggono e il rilievo e' da considerarsi chiuso.

---

## 6. 📌 COSA RESTA APERTO

- **Le due celle del Dow** (13, 14): ~12 minuti di macchina. Finche' mancano,
  su U30USD **non si conclude niente** — ne' in un verso ne' nell'altro.
- Se e quando si riaprisse la pista dell'orologio: **prima** va corretta la
  chiusura forzata (punto 3), altrimenti 26 fasce su 72 misurano un'altra cosa.

_Corsa eseguita da Claudio sul PC di backtest il 07/09/2026 (celle 11 alle 14:40,
12 alle 15:01). Lettura appaiata calcolata sui CSV grezzi archiviati._
