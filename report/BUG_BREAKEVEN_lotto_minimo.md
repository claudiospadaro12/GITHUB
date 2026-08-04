# 🐞 Il breakeven non scatta mai al lotto minimo — trovato il 04/08/2026

_Difetto reale, misurato su due posizioni aperte. Non è una teoria._

## Il caso che l'ha rivelato

Due short oro `SupRev`, aperti il 31/07, lasciati aperti apposta come **gruppo di controllo** per vedere se un profitto si sarebbe girato in perdita.

| # | EA | ingresso | 03/08 ore 16:11 | 04/08 ore 19:35 |
|---|---|---|---|---|
| 2957063 | STREV MULTI (0,01) | 4 075,45 | **+39,75** | **−16,64** |
| 2958388 | STREV (0,01) | 4 075,88 | **+40,13** | **−16,26** |
| | | | **+79,88** | **−32,90** |

**Oscillazione: −112,78 €.** Su un conto da 100k con lotti proporzionati (×32) sarebbero **≈ −3 600 €, il 3,6%** — contro un limite giornaliero FTMO del 5%.

## Il difetto, in una riga

```mql5
double cv = NormVol(vol*InpTP1Pct/100.0);
if(cv>0 && cv<vol && gTrade.PositionClosePartial(tk,cv))
  { if(InpBreakeven) gTrade.PositionModify(tk, NormalizePrice(openP), tp); }   // <-- ANNIDATO
```

**Il breakeven è dentro il blocco del parziale.** Se il parziale non parte, non parte nemmeno lo stop in pari.

E al **lotto minimo il parziale non può partire mai**:

```mql5
double NormVol(double v){ ... v = MathFloor(v/st)*st; return(v<mn ? 0 : v); }
```

Con `vol = 0.01`, `InpTP1Pct = 50`, `step = min = 0.01`:
`NormVol(0.005)` → `MathFloor(0.5)*0.01 = 0` → `cv = 0` → la condizione `cv>0` è **falsa** → niente parziale → **niente breakeven**.

## La prova che il livello era stato raggiunto

- R = 4 111,19 − 4 075,45 = **35,74 $**
- Massimo a favore osservato = 4 075,45 − 4 029,66 = **45,79 $ = 1,28 R**

Il target a 1R (4 039,71) era stato **superato**: la condizione `hit` era vera. Si è fermato tutto su `cv = 0`.

**[VERIFICATO]** — dai prezzi reali delle due posizioni e dal sorgente.

## Perché è la stessa famiglia di un difetto già trovato

Il 03/08, sempre sull'oro, avevo trovato che `LotByRisk()` arrotonda per difetto e fa rischiare **0,52% invece dell'1%**. Stessa causa: **il lotto minimo rompe la logica sui conti piccoli.** Là toglieva rischio (innocuo), qui toglie protezione (costoso).

> Regola da tenere: ogni volta che il codice moltiplica o divide un volume, chiedersi cosa succede a **0,01 lotti**.

## La correzione (04/08)

Lo stop in pari è stato **staccato** dal parziale: ora scatta al raggiungimento di 1R **comunque**, e il parziale resta un di più.

```mql5
bool parz = (cv>0 && cv<vol && gTrade.PositionClosePartial(tk,cv));
if(InpBreakeven) gTrade.PositionModify(tk, NormalizePrice(openP), tp);   // <-- indipendente
```

Applicata a **17 EA** (tutta la famiglia SupRev + EMA200, SuperWave, PTE, WOL e i rispettivi `_Ottimizzato`).

⚠️ **Restano 10 EA con lo stesso difetto ma scritto in forma diversa** (usano `ticket`/`_Symbol` invece di `tk`, o flag `gPart1`/`gPartialDone`): `DAX_M3`, `FiboH4_Multi`, `GoldenCross`, `GoldenCross_Ottimizzato`, `Londra_ORB`, `MaxMinNotte`, `MaxMinNotte_DAX_Short_Ottimizzato`, `ORB`, `ORB_Fibo`, `SupertrendInvert`. Vanno corretti uno per uno, non con una sostituzione automatica.

🔴 **Serve ricompilare sul VPS**, altrimenti in forward non cambia nulla:
```powershell
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/scarica_ottimizzati.ps1" | iex
```

## Nota sulle due posizioni oro

**Per loro è tardi per il breakeven.** Sono short con ingresso a 4 075,45 / 4 075,88 e il prezzo è a **4 094,62**: uno stop in pari starebbe *sotto* il prezzo corrente, e non è piazzabile. Le opzioni residue sono due sole — chiudere ora a −32,90, oppure tenerle con lo stop a 4 111,19 (altri ~−29 € se colpito) puntando al TP a 4 014,61 / 3 986,78.
