# 01 - Costi per simbolo (tabella A)

Fonte principale: https://ftmo.com/en/symbols/ (pagina in italiano, schede "Forex" e "CFD sui metalli"), letta il 11/11/2026 nel browser.
Unità di swap: "points" (punti) per la pagina. Non è indicato il valore in USD per lotto.
Commissione: la pagina dice "5 USD/LOT*" con nota "*or equivalent in your trading currency". Non dice se la cifra è per lato o andata+ritorno.

Legenda stato:
- CHIARO = tutti i campi richiesti dichiarati senza ambiguità
- AMBIGUO = dati presenti ma unità, lato o valore incerti, oppure campi mancanti
- NON TROVATO = campo non presente nelle pagine lette

Campi comuni a tutte le coppie Forex (dichiarati nella scheda):
- Contract size: 100.000
- Margine: 1 (%)
- Leva Standard: 1:100 (la FAQ dice "fino a 1:100, non aumentabile")
- Leva Swing: 1:30 (la FAQ dice "fino a 1:30")
- Commissione: 5 USD/LOT (vedi nota sopra)
- Lotto min / max / passo: NON TROVATO nelle pagine lette (campo non presente nella scheda Simboli)
- Spread dichiarato: NON TROVATO (la pagina dice "Compare live spreads" ma il valore live non è leggibile dal browser)
- Orario Forex: lunedì-venerdì 00:05-23:55 (GMT+2), sabato e domenica chiuso

| simbolo | contract size | commissione | leva Std/Swing | margine | lotto min-max-passo | spread dichiarato | swap long / short (points) | URL | stato |
|---|---|---|---|---|---|---|---|---|---|
| XAUUSD (XAU/USD, CFD metalli) | 100 | 0,0014 PERCENT/VOLUME (unità non chiara) | 1:50 / 1:15 | 2 | NON TROVATO | NON TROVATO | -92,26 / -4,2 | https://ftmo.com/en/symbols/ | AMBIGUO: leva diversa dalla FAQ (1:100 / 1:30); unità commissione non chiara |
| EURUSD | 100.000 | 5 USD/LOT | 1:100 / 1:30 | 1 | NON TROVATO | NON TROVATO | -10,27 / 0,13 | https://ftmo.com/en/symbols/ | AMBIGUO (commissione per lato o no; lotto e spread NON TROVATI) |
| GBPUSD | 100.000 | 5 USD/LOT | 1:100 / 1:30 | 1 | NON TROVATO | NON TROVATO | -4,85 / -6,64 | https://ftmo.com/en/symbols/ | AMBIGUO (come sopra) |
| USDJPY | 100.000 | 5 USD/LOT | 1:100 / 1:30 | 1 | NON TROVATO | NON TROVATO | 0,78 / -19,29 | https://ftmo.com/en/symbols/ | AMBIGUO (come sopra) |
| USDCHF | 100.000 | 5 USD/LOT | 1:100 / 1:30 | 1 | NON TROVATO | NON TROVATO | 0,57 / -14,59 | https://ftmo.com/en/symbols/ | AMBIGUO (come sopra) |
| AUDUSD | 100.000 | 5 USD/LOT | 1:100 / 1:30 | 1 | NON TROVATO | NON TROVATO | -3,08 / -8,27 | https://ftmo.com/en/symbols/ | AMBIGUO (come sopra) |
| NZDUSD | 100.000 | 5 USD/LOT | 1:100 / 1:30 | 1 | NON TROVATO | NON TROVATO | -4,85 / 0 | https://ftmo.com/en/symbols/ | AMBIGUO: swap long identico a GBPUSD e swap short = 0, da verificare sul terminale |
| USDCAD | 100.000 | 5 USD/LOT | 1:100 / 1:30 | 1 | NON TROVATO | NON TROVATO | 0,56 / -10,28 | https://ftmo.com/en/symbols/ | AMBIGUO (come sopra) |
| EURGBP | 100.000 | 5 USD/LOT | 1:100 / 1:30 | 1 | NON TROVATO | NON TROVATO | -9,81 / 0,07 | https://ftmo.com/en/symbols/ | AMBIGUO (come sopra) |
| EURJPY | 100.000 | 5 USD/LOT | 1:100 / 1:30 | 1 | NON TROVATO | NON TROVATO | 0,38 / -13,25 | https://ftmo.com/en/symbols/ | AMBIGUO (come sopra) |
| GBPJPY | 100.000 | 5 USD/LOT | 1:100 / 1:30 | 1 | NON TROVATO | NON TROVATO | 1,08 / -33,15 | https://ftmo.com/en/symbols/ | AMBIGUO (come sopra) |
| AUDJPY | 100.000 | 5 USD/LOT | 1:100 / 1:30 | 1 | NON TROVATO | NON TROVATO | 0,84 / -15,19 | https://ftmo.com/en/symbols/ | AMBIGUO (come sopra) |
| EURCHF | 100.000 | 5 USD/LOT | 1:100 / 1:30 | 1 | NON TROVATO | NON TROVATO | 0,4 / -14,08 | https://ftmo.com/en/symbols/ | AMBIGUO (come sopra) |

## Altre coppie Forex presenti nella scheda (non richieste, stessi campi comuni)

| simbolo | swap long / short (points) |
|---|---|
| AUDCAD | 0,68 / -9,8 |
| AUDCHF | 0,7 / -11,3 |
| AUDNZD | 0,78 / -11,51 |
| GBPAUD | -12,12 / -2,2 |
| GBPCAD | 0,51 / -20,84 |
| GBPCHF | 0,77 / -28,57 |
| GBPNZD | 0,37 / -23,73 |
| CADJPY | 0,22 / -7,72 |
| CADCHF | 0,28 / -7,9 |
| EURAUD | -17,59 / 0,84 |
| EURCAD | -3,61 / -4,59 |
| EURNZD | -6,22 / -3,99 |
| NZDCAD | -1,86 / -3,18 |
| NZDCHF | 0,23 / -7,36 |
| NZDJPY | 0,2 / -7,55 |
| CHFJPY | -15,82 / 0,47 |

Tutte queste righe: commissione 5 USD/LOT, leva 1:100 / 1:30, margine 1, stato AMBIGUO per gli stessi motivi, URL https://ftmo.com/en/symbols/.

## Note

- La scheda Forex della pagina Simboli riporta, per ogni coppia, la voce "Swap Type: points". Il valore in USD non è dato.
- Triplo swap (giorno): NON TROVATO nelle pagine ufficiali lette. Le fonti di terze parti trovate nella ricerca web indicano mercoledì, ma non sono FTMO: non usate.
- Ora del rollover: NON TROVATO nelle pagine ufficiali lette.
- Spread medio: NON TROVATO.
- Commissione: la nota sul cambio del 29/09/2025 (versione /au/) parla di "$2.50 per lot per side" per il Forex, contro i "5 USD/LOT" della scheda attuale. Se 2,50 è per lato, 5 è il totale andata+ritorno. Non confermato. Vedi 03 e 99.
