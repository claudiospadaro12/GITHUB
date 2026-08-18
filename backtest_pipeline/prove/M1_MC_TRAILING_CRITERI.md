# M1 — CRITERI CONGELATI: Monte Carlo col DRAWDOWN TRAILING (18/08/2026)

**Congelato PRIMA di calcolare qualunque numero trailing.** Al momento della
scrittura di questo file e' stato eseguito UN SOLO calcolo: la riproduzione
della MC STATICA di baseline (27 serie -> +223.230,01 / DD storico 5,50% /
MC 5,74 / 9,89 / 12,47 — identica ai referti R41/R49), che serve a
certificare la composizione delle serie. **Nessun numero trailing e' stato
guardato prima del congelamento.**

Missione: M1 del `report/PIANO_PROP.md` (chiude C5, sblocca/conferma F3,
ricalibra A1). Fonte del vuoto: `report/METRO_PROP.md` §1 ("non l'abbiamo
mai calcolato").

---

## 1. Le serie: le STESSE 27 della MC statica

Ricostruite dai round che le hanno accumulate (R16 5 -> R19b 6 -> R23 11 ->
R31 12 -> R34 15 -> R37 18 -> R39 24 -> R41 27; R49 ha RIFIUTATO le 3 di
EasyTrend, che infatti restano fuori). Coppie gemelle: si usa il magic PIU'
BASSO della coppia (verificate identiche al centesimo nei round d'origine).
Tutte OOS, tick reali, rischio 1%, deposito 100k.

| # | file (sotto `backtest_pipeline/risultati_prove/`) | round |
|---|---|---|
| 1 | `trades_portafoglio/abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_770115.csv` | R16 |
| 2 | `trades_portafoglio/abtg_trades_ABTG_Dow_Apertura_US_U30USD_770206.csv` | R16 |
| 3 | `trades_portafoglio/abtg_trades_ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_770413.csv` | R16 |
| 4 | `trades_portafoglio/abtg_trades_ABTG_MaxMinNotte_XAUUSD_770405.csv` | R19b |
| 5 | `trades_portafoglio/abtg_trades_ABTG_ORB_Ottimizzato_U30USD_770612.csv` | R16 |
| 6 | `trades_portafoglio/abtg_trades_ABTG_SupertrendReversal_225JPY_770903.csv` | R16 |
| 7 | `trades_candidati_r23/abtg_trades_ABTG_PTE_U30USD_771311.csv` | R23 |
| 8 | `trades_candidati_r23/abtg_trades_ABTG_PTE_GBPUSD_771313.csv` | R23 |
| 9 | `trades_candidati_r23/abtg_trades_ABTG_PTE_USDJPY_771315.csv` | R23 |
| 10 | `trades_candidati_r23/abtg_trades_ABTG_SuperWave_U30USD_770521.csv` | R23 |
| 11 | `trades_candidati_r23/abtg_trades_ABTG_SuperWave_GBPUSD_770523.csv` | R23 |
| 12 | `trades_candidati_r23/abtg_trades_ABTG_EMA200_U30USD_771521.csv` | R31 |
| 13 | `trades_bb/abtg_trades_ABTG_BreakingBand_GBPUSD_772111.csv` | R34 |
| 14 | `trades_bb/abtg_trades_ABTG_BreakingBand_EURUSD_772113.csv` | R34 |
| 15 | `trades_bb/abtg_trades_ABTG_BreakingBand_AUDUSD_772115.csv` | R34 |
| 16 | `trades_gap/abtg_trades_ABTG_GapFill_AUDUSD_772213.csv` | R37 |
| 17 | `trades_gap/abtg_trades_ABTG_GapFill_EURUSD_772215.csv` | R37 |
| 18 | `trades_gap/abtg_trades_ABTG_GapFill_GBPUSD_772217.csv` | R37 |
| 19 | `trades_larry/abtg_trades_ABTG_PunteLarry_U30USD_772321.csv` | R39 |
| 20 | `trades_larry/abtg_trades_ABTG_PunteLarry_EURAUD_772323.csv` | R39 |
| 21 | `trades_larry/abtg_trades_ABTG_PunteLarry_XAUUSD_772325.csv` | R39 |
| 22 | `trades_larry/abtg_trades_ABTG_PunteLarry_GBPJPY_772327.csv` | R39 |
| 23 | `trades_larry/abtg_trades_ABTG_PunteLarry_GBPUSD_772329.csv` | R39 |
| 24 | `trades_larry/abtg_trades_ABTG_PunteLarry_EURCAD_772331.csv` | R39 |
| 25 | `trades_cost/abtg_trades_ABTG_CostToCost_EURJPY_772351.csv` | R41 |
| 26 | `trades_cost/abtg_trades_ABTG_CostToCost_GBPCAD_772353.csv` | R41 |
| 27 | `trades_cost/abtg_trades_ABTG_CostToCost_XAGUSD_772355.csv` | R41 |

## 2. Ricampionamento: IDENTICO alla MC statica

Come `dd_portafoglio.py` (R16): rimescolo dei **GIORNI INTERI** (il vettore
dei 27 P&L dello stesso giorno resta insieme — la correlazione same-day si
conserva, le strisce si distruggono), **2000 iterazioni, seed 42**, deposito
**100.000**. Dentro ogni giorno l'ordine cronologico dei trade resta quello
originale (serve solo alla variante B).

## 3. Le tre taglie di rischio

I P&L sono a rischio 1%. Scala **LINEARE** (stessa ipotesi della scala di
R16, niente compounding — coerente col sizing a rischio fisso):
fattori **0,65 / 0,50 / 0,40**.

## 4. Il modello di trailing (congelato)

### Variante A — PRINCIPALE: trailing END-OF-DAY sul saldo massimo di fine giornata, in % del capitale INIZIALE (stile FTMO 1-Step)

E' l'unica regola trailing con una fonte esplicita nel dossier
(`CONFIG_PROP_2026-08-18.md` §2A, [LETTO-VIA-SEARCH]): _"trailing END-OF-DAY
sul saldo di fine giornata piu' alto — il limite puo' solo salire, mai
scendere. Esempio: saldo a mezzanotte 104.000 -> muro a 94.000"_. L'esempio
dice che il muro sta **10% del capitale INIZIALE (10.000 EUR fissi)** sotto
il saldo EOD massimo — non 10% del picco.

Formalmente, con `eq_0 = 100.000` e `eq_t = eq_{t-1} + PL_t` (saldo EOD del
giorno t; coi dati giornalieri saldo EOD = equity EOD):

- `HWM_0 = deposito`
- `DDtrail_t = (HWM_{t-1} - eq_t) / deposito * 100` (misurato PRIMA di aggiornare l'HWM)
- `HWM_t = max(HWM_{t-1}, eq_t)`
- **max DD trailing dell'iterazione = max su t di DDtrail_t**

**Senza blocco al breakeven**: il dossier non lo cita ("puo' solo salire"),
quindi l'ipotesi congelata e' quella severa. Il blocco al breakeven —
la clausola buona di `METRO_PROP` §9 — si misura a parte (variante C).

### Variante B — trailing EQUITY (proxy per-trade), perche' costa poco

Stessa formula, ma l'HWM e il DD si aggiornano dopo **OGNI CHIUSURA di
trade** (sequenza per-trade dentro il giorno, ordine cronologico originale;
nei rimescoli i giorni restano blocchi interi). **Limite dichiarato**: non
e' la vera equity flottante intrabar — il picco vero e' >= di questo proxy,
quindi la variante B e' un **minorante onesto** del trailing-equity vero.
Fonte del modello: KT Equity Protector, modello 3 (dossier §elenco 3 modelli).

### Variante C — come la A, ma con BLOCCO AL BREAKEVEN

Il pavimento non sale mai sopra il capitale iniziale:
`floor_t = min(deposito, HWM_t - muro)`. Qui il "max DD trailing" perde
senso come metrica unica: si misura SOLO la probabilita' di sfondamento per
muro. Serve a quantificare quanto vale la clausola "si blocca al breakeven"
quando la si chiedera' per iscritto a una prop.

## 5. Output congelati (per ciascuna taglia x variante)

1. **p50 / p95 / p99 del max DD trailing** (varianti A e B), in % del
   capitale iniziale.
2. **Probabilita' di sfondamento** dei muri **10% / 8% / 6%** (tutte e tre
   le varianti): frazione delle 2000 iterazioni con violazione. Violazione =
   `max DD trailing >= muro` (il tocco del pavimento conta come uscita —
   scelta severa, congelata).
3. **Metrica di corsa (la challenge vera)**: per ogni iterazione si percorre
   la sequenza EOD (variante A) e si registra COSA ARRIVA PRIMA — il
   **target +10%** sul saldo EOD (target FTMO 1-Step, dossier §2A) o il muro
   trailing. Tre esiti: `PASSA` / `SFONDA prima del target` / `NE' l'uno ne'
   l'altro` nella finestra (~12,6 mesi). Si riporta la tripletta per i muri
   6/8/10 alle tre taglie. Motivo: il max DD sull'orizzonte INTERO punisce
   anche i cedimenti che avverrebbero DOPO aver passato la challenge; la
   corsa al target e' la domanda per cui si paga il biglietto.
4. **Confronto con la statica, ricalcolato e non scalato**: la MC statica
   alle tre taglie viene RIFATTA con lo stesso `max_dd()` dal picco (in %
   del picco corrente, come nei referti), invece di scalare linearmente il
   12,47 — la % dal picco NON scala linearmente col fattore di rischio.
   Nel confronto va dichiarata la differenza di geometria: statica di casa =
   % dal picco corrente; trailing A = EUR fissi sotto il saldo EOD massimo,
   in % del capitale iniziale.

## 6. Il criterio di verdetto (congelato, simmetrico alla regola di casa)

La regola di casa sulla statica era: taglia ok se **p99 < muro** ("lo
sfonda in meno dell'1% dei casi", `METRO_PROP` §1-bis). Congelo la stessa:

> **Una taglia "passa" un muro trailing X se il p99 del max DD trailing
> (variante A, orizzonte intero) e' < X.** La metrica di corsa (output 3) si
> riporta accanto come lettura d'appoggio, non come criterio.

## 7. Cosa questa misura NON e' (limiti dichiarati)

- Finestra UNA (~12,6 mesi OOS): il rimescolo allarga le sequenze, non i
  regimi (stesso caveat di R16).
- Niente equity flottante intrabar: la variante B e' un proxy per difetto.
- Il muro GIORNALIERO (5% / 3%) non e' oggetto di M1: e' una regola
  per-giorno che il trailing non cambia (peggior giornata gia' misurata).
- Scala lineare = niente compounding del sizing: coerente con R16, dichiarato.

**Implementazione**: `backtest_pipeline/mc_trailing.py` (nel repo, per
riproducibilita'). Referto:
`backtest_pipeline/risultati_archivio/REFERTO_M1_MC_TRAILING.md`.
