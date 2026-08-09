# PROCEDURA BLINDATA pt5 -- serie per-trade pulite di Dow e DAX

Aggiornato: 09/08/2026, dopo il QUARTO invio di file ancora di griglia.

## Perche' i file inviati finora NON vanno bene

I trades-file si SOVRASCRIVONO: ogni pass con lo stesso magic riscrive
il file, quindi dopo una griglia resta la cella dell'ultimo pass, a caso.
Servono i file scritti da un lancio con UNA SOLA cella per magic
(il magic-sweep di coerenza: 2 pass identici, 770202/770203 gemelli).

Prova che i file del 09/08 pomeriggio sono di griglia:

- Dow_770203: 218 trade di cui 80 SHORT. Il file R16c ha
  `InpAllowShort=0`: da quel lancio gli short NON POSSONO uscire.
  Quindi il lancio fatto NON era R16c.
- Dow_770202 (115 trade, +11793,89) e Dow_770203 non sono gemelli.
- DAX_770111 (199, +9022,27) e DAX_770112 (258, +3523,61) non sono gemelli.

Attesi dai lanci giusti (verificati sui riepiloghi ptc/ptd):

- Dow:  gemelli al centesimo, 130 trade, netto +6721,93, ZERO short.
- DAX:  gemelli al centesimo, 270 trade, netto +18029,58, ZERO short.

## La procedura (dal PC di backtest, cartella backtest_pipeline)

### Passo 0 -- pulizia (OBBLIGATORIA, se salti questo e' tutto inutile)

```powershell
del "$env:APPDATA\MetaQuotes\Terminal\Common\Files\abtg_trades_*.csv"
```

### Passo 1 -- controllo lampo del Dow (30 secondi, non lancia nulla)

```powershell
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/prove/R16c_pertrade_Dow.txt" -OutFile prove\R16c_pertrade_Dow.txt; powershell -ExecutionPolicy Bypass -File .\walkforward_generico.ps1 -Prova prove\R16c_pertrade_Dow.txt -Deposito 100000 -Etichetta pt5c -SoloControllo
```

La console DEVE dire: `spazzolati : 1`, `InpMagic  2 celle`.
Se dice un numero diverso, FERMATI e mandami lo screenshot.

### Passo 2 -- lancio vero del Dow

```powershell
powershell -ExecutionPolicy Bypass -File .\walkforward_generico.ps1 -Prova prove\R16c_pertrade_Dow.txt -Deposito 100000 -Etichetta pt5c
```

### Passo 3 -- controllo lampo del DAX

```powershell
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/prove/R16d_pertrade_DAX.txt" -OutFile prove\R16d_pertrade_DAX.txt; powershell -ExecutionPolicy Bypass -File .\walkforward_generico.ps1 -Prova prove\R16d_pertrade_DAX.txt -Deposito 100000 -Etichetta pt5d -SoloControllo
```

Stesso controllo: `spazzolati : 1`, `InpMagic  2 celle`.

### Passo 4 -- lancio vero del DAX

```powershell
powershell -ExecutionPolicy Bypass -File .\walkforward_generico.ps1 -Prova prove\R16d_pertrade_DAX.txt -Deposito 100000 -Etichetta pt5d
```

### Passo 5 -- invio

Da `%APPDATA%\MetaQuotes\Terminal\Common\Files` mandami SOLO questi 4:

- abtg_trades_ABTG_Dow_Apertura_US_U30USD_770202.csv
- abtg_trades_ABTG_Dow_Apertura_US_U30USD_770203.csv
- abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_770111.csv
- abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_770112.csv

Nikkei e MaxMinNotte sono gia' archiviati e validi: non servono di nuovo.

## Regole d'oro

1. NON lanciare nessun'altra prova tra il Passo 0 e il Passo 5.
2. NON allargare le griglie: i file per-trade funzionano SOLO con
   2 celle (il magic-sweep). Piu' celle = file sovrascritti a caso.
3. Copiare le righe da QUESTO file, non dalla cronologia di PowerShell.

## Dopo (lo faccio io)

Con i 4 file validi: `python3 backtest_pipeline/dd_portafoglio.py
--deposito 100000` sulle 4 serie -> primo referto di PORTAFOGLIO
(DD combinato, correlazioni, peggior giornata, Monte Carlo p95/p99).
E' il numero che serve per decidere il demo 100k col Guardiano.
