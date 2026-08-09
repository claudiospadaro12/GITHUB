# PROCEDURA pt7 -- serie per-trade pulite di Dow e DAX

Aggiornato: 09/08/2026 sera (terza revisione). Sostituisce pt5 e pt6.

## STORIA DEI DUE DIFETTI TROVATI OGGI (per non ripeterli)

1. CACHE del tester: una cella gia' calcolata NON viene rieseguita ->
   ExportTrades non scrive i file per-trade. Rimedio: magic mai usati.
2. PIN SECCHI nel driver (trovato col lancio pt6c, che ha rispazzolato
   la griglia coi magic nuovi): un pin scritto 'Nome=35' nell'ini imposta
   il VALORE ma NON spegne il flag di ottimizzazione che MT5 ricorda
   dall'ultima griglia di quell'EA -> il tester rispazzola la griglia
   vecchia nonostante il pin. Corretto nel driver il 09/08 sera: ora i
   pin vengono scritti in forma completa v||v||0||v||N.

Conseguenza: i magic 770202-770205 (Dow) e 770111-770114 (DAX) sono
BRUCIATI (in cache). Terza serie, vergine: Dow 770206/770207,
DAX 770115/770116.

## La procedura (PowerShell in C:\Users\Master -- se il prompt dice
## solo C:\> dare prima:  cd $env:USERPROFILE )

### Passo 0 -- aggiornare il DRIVER (OBBLIGATORIO: il fix dei pin e' qui)

```powershell
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/walkforward_generico.ps1" -OutFile walkforward_generico.ps1
```

### Passo 1 -- pulizia dei file per-trade

```powershell
del "$env:APPDATA\MetaQuotes\Terminal\Common\Files\abtg_trades_*.csv"
```

### Passo 2 -- Dow (etichetta pt7c, magic 770206/770207)

```powershell
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/prove/R16c_pertrade_Dow.txt" -OutFile prove\R16c_pertrade_Dow.txt; powershell -ExecutionPolicy Bypass -File .\walkforward_generico.ps1 ABTG_Dow_Apertura_US -Prova prove\R16c_pertrade_Dow.txt -Deposito 100000 -Etichetta pt7c
```

### Passo 3 -- DAX (etichetta pt7d, magic 770115/770116)

```powershell
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/prove/R16d_pertrade_DAX.txt" -OutFile prove\R16d_pertrade_DAX.txt; powershell -ExecutionPolicy Bypass -File .\walkforward_generico.ps1 ABTG_DAX_Apertura_EU -Prova prove\R16d_pertrade_DAX.txt -Deposito 100000 -Etichetta pt7d
```

### Passo 4 -- invio

Da `%APPDATA%\MetaQuotes\Terminal\Common\Files` mandami SOLO questi 4:

- abtg_trades_ABTG_Dow_Apertura_US_U30USD_770206.csv
- abtg_trades_ABTG_Dow_Apertura_US_U30USD_770207.csv
- abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_770115.csv
- abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_770116.csv

## Controlli in corsa e all'arrivo

- In console: `spazzolati : 1`, `InpMagic  2 celle`, `4 pass in tutto`.
- Ogni finestra deve produrre un CSV da 2 RIGHE (non 12, non 360): col
  driver nuovo, righe diverse dalle celle chieste fanno scattare un
  avviso rosso. Se scatta: screenshot e fermati.
- All'arrivo (li faccio io): Dow 770206/770207 gemelli al centesimo,
  130 trade, +6721,93, zero short; DAX 770115/770116 gemelli, 270 trade,
  +18029,58, zero short.
- I file per-trade contengono la sola finestra OOS (la passata IS viene
  sovrascritta): e' quello che serve per il portafoglio.

## Regole d'oro

1. Prima il Passo 0: senza driver nuovo i pin non pinnano.
2. NON lanciare altre prove tra il Passo 1 e il Passo 4.
3. Copiare le righe da QUESTO file, non dalla cronologia di PowerShell.

## Dopo (lo faccio io)

Con i 4 file validi: `python3 backtest_pipeline/dd_portafoglio.py
--deposito 100000` sulle 4 serie -> primo referto di PORTAFOGLIO
(DD combinato, correlazioni, peggior giornata, Monte Carlo p95/p99).
E' il numero che serve per decidere il demo 100k col Guardiano.
