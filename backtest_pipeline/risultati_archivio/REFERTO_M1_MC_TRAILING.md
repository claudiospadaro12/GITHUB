# 🧗 REFERTO M1 — LA MONTE CARLO COL DRAWDOWN TRAILING (18/08/2026)

**La misura che non era mai stata fatta** (`METRO_PROP` §1: _"non l'abbiamo
mai calcolato"_). Chiude la riga **C5** del `PIANO_PROP`, giudica il divieto
**F3** (prop 1-Step) e ricalibra la lettura di **A1** (rischio 0,65%).

> ## 🎯 LA RIGA CHE CONTA
> **A 0,65% il trailing p99 e' 12,05% contro il muro del 10% → le 1-Step
> a muro 10% NON sono comprabili a questa taglia** (lo sfonda nel 4,6% dei
> percorsi, non "meno dell'1%"). **Rientrano a 0,50%** (p99 9,27%, sfondamenti
> 0,2%). Il muro **8%** richiede **0,40%** (p99 7,41%). Il muro **6% non e'
> comprabile a NESSUNA taglia misurata** (perfino a 0,40% il p99 e' 7,41%).

---

## 1. Metodologia (congelata PRIMA dei numeri)

Criteri in `backtest_pipeline/prove/M1_MC_TRAILING_CRITERI.md`, commit
`2ae7077`, scritti e pushati **prima** di calcolare qualunque numero
trailing. In sintesi:

- **Stesse 27 serie** della MC statica (R16→R41, composizione ricostruita
  round per round e certificata riproducendo la baseline: +223.230,01 /
  DD storico 5,50% / MC 5,74–9,89–12,47, identica a R41/R49).
- **Stesso ricampionamento**: rimescolo dei GIORNI INTERI (correlazione
  same-day conservata), **2000 iterazioni, seed 42**, deposito 100.000 —
  sequenza di rimescoli identica a `dd_portafoglio.py`. ✅ Controllo di
  sanita' interno: la statica a fattore 1,0 riproduce **5,74/9,89/12,47**
  al centesimo.
- **Tre taglie**: 0,65% / 0,50% / 0,40% (scala lineare dei P&L a 1%, come
  la scala di R16 — niente compounding, dichiarato).
- **Variante A (principale)** — trailing **END-OF-DAY sul saldo massimo di
  fine giornata**, muro in **EUR fissi = % del capitale INIZIALE**, senza
  blocco al breakeven: e' la regola FTMO 1-Step del dossier CONFIG_PROP §2A
  ([LETTO-VIA-SEARCH]: _"il limite puo' solo salire, mai scendere; saldo
  104.000 → muro 94.000"_).
- **Variante B** — trailing equity proxy per-trade (HWM dopo ogni chiusura;
  **minorante onesto** dell'equity flottante vera, che non abbiamo).
- **Variante C** — come A ma col pavimento **bloccato al breakeven** (la
  clausola buona di `METRO_PROP` §9): solo probabilita' di sfondamento.
- **Corsa al target**: target +10% EOD (challenge 1-Step) contro muro
  trailing — cosa arriva prima. Lettura d'appoggio, non criterio.
- **Verdetto (congelato)**: taglia OK su un muro X se **p99 del max DD
  trailing (variante A) < X** — lo stesso metro "sfonda in meno dell'1%
  dei casi" usato per la statica.
- Violazione = **tocco** del muro (≥), scelta severa congelata.

Script: `backtest_pipeline/mc_trailing.py` (3 secondi di calcolo, output
integrale riprodotto sotto). Dati: 27 serie, 282 giorni con trade
(2025.06.10 → 2026.06.29, ~12,6 mesi OOS), 1.866 trade.

## 2. 📊 La tabella completa

Max DD trailing in **% del capitale iniziale** (EUR fissi sotto l'HWM);
statica in % del picco corrente (geometria di casa, RICALCOLATA per taglia,
non scalata linearmente).

### Taglia 0,65% (la taglia di casa) — netto finestra +145.100

| misura | p50 | p95 | p99 |
|---|---:|---:|---:|
| statica (% dal picco) | 4,24 | 6,95 | 8,51 |
| **TRAILING A (EOD)** | **6,39** | **9,85** | **12,05** 🔴 |
| trailing B (per-trade) | 7,31 | 11,00 | 13,02 |

| muro | sfonda A | sfonda B | sfonda C (lock BE) | corsa: PASSA / SFONDA |
|---|---:|---:|---:|---|
| 10% | **4,6%** 🔴 | 9,3% | **0,2%** | 99,8% / 0,2% |
| 8% | 18,6% | 33,9% | 1,1% | 98,8% / 1,2% |
| 6% | 61,2% | 86,4% | 3,9% | 94,5% / 5,5% |

### Taglia 0,50% — netto finestra +111.615

| misura | p50 | p95 | p99 |
|---|---:|---:|---:|
| statica (% dal picco) | 3,46 | 5,59 | 6,74 |
| **TRAILING A (EOD)** | **4,92** | **7,58** | **9,27** 🟢 (<10) |
| trailing B (per-trade) | 5,62 | 8,47 | 10,01 |

| muro | sfonda A | sfonda B | sfonda C (lock BE) | corsa: PASSA / SFONDA |
|---|---:|---:|---:|---|
| 10% | **0,2%** 🟢 | 1,1% | 0,1% | 100,0% / 0,1% |
| 8% | 3,9% 🔴 | 7,0% | 0,1% | 99,9% / 0,1% |
| 6% | 21,2% | 38,4% | 1,1% | 98,3% / 1,7% |

### Taglia 0,40% — netto finestra +89.292

| misura | p50 | p95 | p99 |
|---|---:|---:|---:|
| statica (% dal picco) | 2,90 | 4,59 | 5,63 |
| **TRAILING A (EOD)** | **3,93** | **6,06** | **7,41** 🟢 (<8) |
| trailing B (per-trade) | 4,50 | 6,77 | 8,01 |

| muro | sfonda A | sfonda B | sfonda C (lock BE) | corsa: PASSA / SFONDA |
|---|---:|---:|---:|---|
| 10% | 0,0% 🟢 | 0,0% | 0,0% | 100,0% / 0,0% |
| 8% | **0,2%** 🟢 | 1,1% | 0,1% | 100,0% / 0,1% |
| 6% | 5,8% 🔴 | 11,2% | 0,4% | 99,7% / 0,4% |

_(A rischio 1%, per completezza: trailing A p99 18,53%, sfonda il 10% nel
47% dei percorsi. A 1% col trailing non si parte nemmeno.)_

## 3. ⚔️ Il confronto secco con la MC statica

| | statica (metro vecchio) | TRAILING A (metro nuovo) |
|---|---|---|
| a 0,65%, p99 | ~8,1% dichiarato (ricalcolato: 8,51%) | **12,05%** |
| contro il muro 10% | 🟢 "sfonda in meno dell'1%" | 🔴 **sfonda nel 4,6%** |

**Il trailing costa ~3,5 punti di p99 alla taglia di casa** — e il METRO_PROP
aveva ragione: _"per una curva che sale a scalini come la nostra il secondo
e' sempre peggiore"_. Tre motivi misurabili: (1) il muro trailing e' in EUR
fissi sul capitale iniziale, mentre la % dal picco si diluisce col crescere
del conto; (2) il pavimento insegue ogni nuovo massimo EOD e non riscende
mai; (3) la nostra equity fa nuovi massimi spesso (282 giorni, 27 serie),
quindi l'HWM e' quasi sempre "fresco". Nota d'igiene: anche sulla statica,
la scala lineare "~8,1%" era leggermente ottimista — ricalcolata per bene fa
**8,51%** (resta 🟢 sotto il 10%).

## 4. 🔑 Le altre due cose che la misura dice

1. **Il blocco al breakeven vale ORO.** A 0,65% sul muro 10%, lo sfondamento
   passa da **4,6% a 0,2%** se il pavimento si ferma al capitale iniziale.
   La domanda di `METRO_PROP` §9 ("il trailing si blocca al breakeven?") non
   e' un dettaglio: **e' la differenza fra comprabile e non comprabile alla
   taglia di casa.** Da chiedere per iscritto, sempre.
2. **La corsa al target e' piu' gentile del p99 sull'orizzonte intero**
   (a 0,65%, muro 10: PASSA 99,8%). Perche'? Il grosso degli sfondamenti
   nell'orizzonte a 12,6 mesi avviene DOPO che il +10% e' gia' in tasca —
   ma su un conto FUNDED col trailing quegli sfondamenti sono soldi veri
   persi col conto. Il criterio congelato resta il p99: la challenge non e'
   l'obiettivo, e' il biglietto d'ingresso di un conto che deve VIVERE.
3. _(bonus)_ **La variante B (per-trade) e' sempre ~1 punto peggio della A**
   — e la vera equity flottante sarebbe peggio ancora. Se una prop dichiara
   trailing sull'EQUITY invece che sul saldo EOD, i margini sopra vanno
   ristretti di almeno un punto.

## 5. 📌 Conseguenze per il PIANO_PROP (da recepire al prossimo giro dell'architetto — questo referto NON tocca il piano)

- **C5 si chiude**: il numero esiste. A 0,65% trailing p99 **12,05%**.
- **F3 (divieto 1-Step)**: il divieto "finche' la misura non c'e'" decade;
  al suo posto entra il numero — **1-Step muro 10% solo a taglia ≤0,50%**,
  muro 8% solo a ≤0,40%, muro 6% mai (con questo portafoglio).
- **A1 (0,65%)**: resta valido per prop a DD STATICO (p99 8,51% < 10%).
  Col trailing NON regge: la taglia va scelta in base al muro (sopra).
- La clausola breakeven-lock entra di diritto nelle domande D3 al supporto.

## 6. ⚠️ Limiti dichiarati (dai criteri congelati)

Finestra UNA (~12,6 mesi OOS): il rimescolo allarga le sequenze, non i
regimi. Niente equity flottante intrabar (B e' un minorante). Scala lineare
senza compounding. Il muro GIORNALIERO (5%/3%) non e' oggetto di M1. E la
regola FTMO 1-Step e' [LETTO-VIA-SEARCH]: prima di comprare, risposta
scritta (regola D3).

---

_Riproducibilita': `python3 backtest_pipeline/mc_trailing.py --deposito
100000 <le 27 serie elencate nei criteri>` — deterministico (seed 42),
3 secondi. Criteri: `prove/M1_MC_TRAILING_CRITERI.md` (commit `2ae7077`,
antecedente al calcolo). Baseline statica riprodotta al centesimo prima
del congelamento._
