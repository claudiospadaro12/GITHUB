# Geometria dell'ingresso — DAX e Nasdaq, tick reali (05/08)

20 combinazioni per mercato: `InpRangeMinutes` 5/15/25/35/45 × `InpBufferPoints` 100/300/500/700.
Gestione fissa e identica a `aperture_trailing`: TP 1,5R, trailing base candela M5, niente
parziale né BE, rischio 1%. **L'unica cosa che cambia è dove e quando si entra.**

## Il risultato: 35 MINUTI, su tutti e due i mercati

### Nasdaq — gradiente monotòno, il più pulito che abbiamo mai visto

| RangeMinutes | PF mediano | profit mediano | trade | in utile |
|---|---:|---:|---:|---|
| 5 | 0,879 | −1.280 | 329 | **0/4** |
| 15 ← *il valore in uso* | 0,895 | −733 | 263 | **0/4** |
| 25 | 0,943 | −300 | 235 | **0/4** |
| **35** | **1,051** | **+194** | 224 | **4/4** |
| 45 | 1,034 | +66 | 109 | 3/4 |

Monotòno da 5 a 35, poi cala. **Il 15 dei documenti sta dalla parte sbagliata del gradiente.**
A 35 minuti **tutte e quattro** le combinazioni di buffer sono in utile: il risultato non
dipende dal secondo parametro, ed è questo che lo rende credibile.

E il drawdown crolla: **5,4-6,0% a 35 minuti contro 18-26% a 5 minuti.**

A 45 minuti i trade si dimezzano (109): campione troppo piccolo per fidarsi.

### DAX — stesso picco, superficie più rumorosa

| RangeMinutes | PF mediano | profit mediano | in utile |
|---|---:|---:|---|
| 5 | 1,030 | +445 | 3/4 |
| 15 ← *in uso* | **0,991** | −110 | 2/4 |
| 25 | 1,014 | +168 | 3/4 |
| **35** | **1,076** | **+861** | **4/4** |
| 45 | 1,036 | +379 | 3/4 |

Anche qui il picco è a 35 e anche qui 4/4 in utile. **Ma la superficie è rumorosa**: a
range 15 il buffer 100 dà +1.258 (PF 1,091) e il buffer 300 dà −892 (PF 0,931). Celle
adiacenti con segno opposto = rumore. Del DAX ci si fida meno che del Nasdaq.

**Migliore assoluto DAX:** range 35 · buffer 100 → **+2.481,69 · PF 1,190 · DD 15,56% ·
Sharpe 6,72 · 421 trade · +0,0589 R/trade.**

## Perché conta

Stamattina, **stessa gestione**, range 15 e buffer 200:

| | prima (range 15) | ora (range 35) |
|---|---:|---:|
| DAX | −78,78 · PF 0,994 | **+2.481,69 · PF 1,190** |
| Nasdaq | −769,01 · PF 0,894 | **+365,01 · PF 1,089** |

Cambiando **solo la durata del range** — non una riga di gestione — il DAX passa da piatto
a positivo e il Nasdaq da perdente a positivo. **Era l'ingresso, non la gestione.** Claudio
lo aveva detto il 04/08.

## ⚠️ Cosa NON dice

1. **Non descrive gli EA accesi.** Questo test usa TP 1,5R senza parziale né BE, risk 1%; il
   DAX e il Nasdaq in forward hanno TP 3R + parziale 50% + stop in pari, risk 2%. Vedi
   `AUDIT_live_vs_backtest.md`.
2. **Il Nasdaq qui gira in `RangeMode=0`**, mentre in forward usa `RangeMode=2` (candela H1
   precedente). Sono due ingressi diversi.
3. **Il 35 non è validato in walk-forward.** Un picco su una griglia non è un edge finché
   non regge fuori campione. Prima di toccare il forward serve quel passaggio.
4. **In-sample.** 2024.01–2026.06, senza divisione IS/OOS.

## 🔧 Difetto trovato NEI MIEI SCRIPT (05/08)

Il CSV ha **160 righe invece di 20**. Causa: i parametri non elencati in `[TesterInputs]`
MT5 **se li tiene dallo stato precedente del terminale**, comprese le impostazioni di
ottimizzazione. Il terminale stava spazzolando da solo `InpTrailFixedPts` su 8 valori.

- **I risultati non sono corrotti**: con `TrailMode=1` quel parametro è inerte, e infatti
  le 8 righe di ogni combinazione hanno metriche identiche.
- **Ma il tempo macchina era 8× il necessario.** Il test del trailing di stamattina non era
  24 pass: erano **192**. Quello dell'ingresso non 40 ma **320**.

**Corretto il 05/08**: aggiunto un blocco `$Blindatura` a `aperture_ingresso`,
`aperture_trailing`, `aperture_openconfirm`, `aperture_retest_fade` che pinna **tutti e 74**
i parametri. Verificato: nessun doppione, nessuno sweep sovrascritto.
