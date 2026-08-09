# PROCEDURA pt6 -- serie per-trade pulite di Dow e DAX (magic nuovi anti-cache)

Aggiornato: 09/08/2026 sera. Sostituisce integralmente la versione pt5.

## IL COLPEVOLE VERO (scoperto col lancio pt5c del 09/08 sera)

Il lancio pt5c del Dow era GIUSTO (spazzolati: 1, 2 celle) eppure il CSV
dei risultati conteneva 12 righe, identiche pass-per-pass alla vecchia
griglia ptc. Spiegazione: il tester di MT5 ha una CACHE delle
ottimizzazioni. Le 2 celle chieste (35/0, magic 770202/770203) erano
gia' state calcolate dentro la griglia -> MT5 le ha servite dalla cache
SENZA rieseguirle, e un pass non eseguito NON scrive i file per-trade.
Per questo Nikkei e MaxMinNotte (celle mai calcolate prima) sono usciti
puliti al primo colpo e Dow/DAX no, qualunque cosa venisse lanciato.

Rimedio: MAGIC MAI USATI PRIMA. La cache non li conosce, quindi i 2
pass girano per forza e scrivono i file. I file prova sono gia' stati
aggiornati sul repo:

- Dow:  InpMagic 770204 e 770205  (prima 770202/770203)
- DAX:  InpMagic 770113 e 770114  (prima 770111/770112)

NOTA: il CSV dei risultati potra' contenere ANCHE le righe vecchie della
griglia ripescate dalla cache (es. 14 righe invece di 2). NON e' un
problema: il verdetto si fa sui file abtg_trades_*, che vengono solo
dai 2 pass nuovi. Il driver ora stampa un avviso che spiega proprio questo.

## La procedura (PowerShell in C:\Users\Master)

### Passo 0 -- pulizia

```powershell
del "$env:APPDATA\MetaQuotes\Terminal\Common\Files\abtg_trades_*.csv"
```

### Passo 1 -- controllo lampo del Dow (30 secondi, non lancia nulla)

```powershell
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/prove/R16c_pertrade_Dow.txt" -OutFile prove\R16c_pertrade_Dow.txt; powershell -ExecutionPolicy Bypass -File .\walkforward_generico.ps1 ABTG_Dow_Apertura_US -Prova prove\R16c_pertrade_Dow.txt -Deposito 100000 -Etichetta pt6c -SoloControllo
```

La console DEVE dire: `spazzolati : 1`, `InpMagic  2 celle`.

### Passo 2 -- lancio vero del Dow

```powershell
powershell -ExecutionPolicy Bypass -File .\walkforward_generico.ps1 ABTG_Dow_Apertura_US -Prova prove\R16c_pertrade_Dow.txt -Deposito 100000 -Etichetta pt6c
```

### Passo 3 -- controllo lampo del DAX

```powershell
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/prove/R16d_pertrade_DAX.txt" -OutFile prove\R16d_pertrade_DAX.txt; powershell -ExecutionPolicy Bypass -File .\walkforward_generico.ps1 ABTG_DAX_Apertura_EU -Prova prove\R16d_pertrade_DAX.txt -Deposito 100000 -Etichetta pt6d -SoloControllo
```

Stesso controllo: `spazzolati : 1`, `InpMagic  2 celle`.

### Passo 4 -- lancio vero del DAX

```powershell
powershell -ExecutionPolicy Bypass -File .\walkforward_generico.ps1 ABTG_DAX_Apertura_EU -Prova prove\R16d_pertrade_DAX.txt -Deposito 100000 -Etichetta pt6d
```

### Passo 5 -- invio

Da `%APPDATA%\MetaQuotes\Terminal\Common\Files` mandami SOLO questi 4
(nota i magic NUOVI nei nomi):

- abtg_trades_ABTG_Dow_Apertura_US_U30USD_770204.csv
- abtg_trades_ABTG_Dow_Apertura_US_U30USD_770205.csv
- abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_770113.csv
- abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_770114.csv

Se nella cartella compaiono file coi magic VECCHI (770202/770203,
770111/770112) dopo il Passo 0, qualcosa non va: fermati e screenshot.

## Controlli d'arrivo (li faccio io)

- Dow: 770204 e 770205 gemelli al centesimo, 130 trade, +6721,93, zero short.
- DAX: 770113 e 770114 gemelli al centesimo, 270 trade, +18029,58, zero short.

(I file per-trade contengono la sola finestra OOS: la passata IS viene
sovrascritta da quella OOS, ed e' quello che vogliamo per il portafoglio.)

## Regole d'oro

1. NON lanciare nessun'altra prova tra il Passo 0 e il Passo 5.
2. NON allargare le griglie: 2 celle e basta.
3. Copiare le righe da QUESTO file, non dalla cronologia di PowerShell.
4. Se il driver mostra l'avviso "righe nel CSV ma N celle chieste":
   leggere l'avviso, NON fermarsi -- conta solo che i 4 file freschi
   coi magic nuovi siano comparsi in Common\Files.

## Dopo (lo faccio io)

Con i 4 file validi: `python3 backtest_pipeline/dd_portafoglio.py
--deposito 100000` sulle 4 serie -> primo referto di PORTAFOGLIO
(DD combinato, correlazioni, peggior giornata, Monte Carlo p95/p99).
E' il numero che serve per decidere il demo 100k col Guardiano.
