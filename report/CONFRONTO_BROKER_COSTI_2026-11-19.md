# Confronto broker: commissioni, spread, swap (19/11/2026) - SOLO MISURE e dati da pagine ufficiali; nessun consiglio di scelta (decide Claudio)

Metodo: ricerca sulle pagine ufficiali dei broker (domini dei broker) + nostre misure su BCM e FTMO (`SWAPINFO_20261119`). **Il swap del singolo simbolo di norma NON e pubblicato** (si legge nella specifica del contratto dentro MT5): solo FP Markets lo pubblica. "NON TROVATO" = non presente nelle pagine lette, da misurare. Unita: **punti MT5 = USD per lotto (100 oz) per notte sull'oro**.

| Broker | Conto/commissione (oro) | Spread oro (dichiarato) | Swap XAUUSD long / short | Note |
|---|---|---|---|---|
| **BCM** (nostra misura) | non letta | variabile | **-98,78 / +19,28** (circa -9,7% annuo); indici long circa -10/-14% annuo (demo D30EUR; tester 225JPY) | triplo mercoledi; ufficiale: grafico swap sul sito, non trovato |
| **FTMO** (nostra misura) | n/a (prop) | n/a | **-56,28 / -4,20** (circa -5,5% annuo); JP225 -901 punti (circa 5,5%) | triplo mercoledi |
| **FP Markets** | Raw: **3 USD per lato** (6 USD a giro) per lotto | Raw: minimo 0,05, medio 0,1 (tabella datata) | **-62,89 / +37,52** (pubblicati; pagina "dal 16/11/2026"); circa -6,2% annuo | conto Islamico: niente swap ma commissione amministrativa 50 USD a lotto a notte dopo 5-10 notti di tolleranza (condizioni e idoneita da verificare) |
| **IC Markets** | Raw: **3,5 USD per lato** (7 a giro) su MT4/MT5 | tabella 0,05-0,1 (colonne non chiare); scheda commodity: media 0,63 | NON TROVATO (variabile, triplo mercoledi) | |
| **Pepperstone** | Razor: **3,5 USD per lato**; EU arrotonda a 0,04 USD per 0,01 lotto | da 0,08 (alcune pagine 0,1) | formula pubblicata: prezzo x lotti x (2,5% + tasso di riferimento) / 360, long paga: valore numerico NON TROVATO | |
| **Admirals** | Zero.MT5 oro: **3,0 USD per lato**, a scaglioni di volume mensile | NON TROVATO | NON TROVATO (pagina "Contract Specification") | |
| **Eightcap** | Raw: 3,5 USD per lato (pagine contraddittorie: la pagina XAUUSD dice nessuna commissione; una vecchia 2 USD) | da 0,0 pip | NON TROVATO (dinamico; vecchia pagina -6,82/+1,82, non attendibile) | |
| **XM** | Ultra Low: nessuna commissione (costo nello spread) | variabile | NON TROVATO (long paga, short riceve) | |
| **Interactive Brokers** | oro spot: **1,5 punti base del controvalore** (circa 0,015%, scaglioni 1,0 e 0,7), minimo 2 USD | spread di mercato | finanziamento del margine; CFD oro/indici NON TROVATO | commissione molto piu alta delle altre su un lotto da 100 oz |

**Lettura per GoldenZoe (oro long, tenuta di giorni):** commissione e spread valgono pochi centesimi di dollaro per oncia (modello del test: 0,35 USD a giro), **il swap pesa 10-20 volte di piu**. PF simulato 2024-26: senza swap 1,82; swap FTMO (5,5%) 1,67; swap BCM (9,7%) 1,56. A parita di spread e commissione, a FP Markets (circa 6,2% annuo) ci si aspetta un PF vicino al caso FTMO, **ma non e misurato** e il swap puo cambiare ogni giorno con i tassi.
**Prossimo passo (misura, non scelta):** leggere il swap vero di oro, indici e principali forex dentro MT5 con lo script `ABTG_SwapInfo` su un conto demo gratuito di ogni broker candidato (IC Markets, Pepperstone, FP Markets, Admirals...), cosi i numeri sono confrontabili con quelli di BCM e FTMO.
Fonti: pagine ufficiali icmarkets.com (spreads, account overview, specifiche commodity), pepperstone.com (costi e account), fpmarkets.com (fees, swap rates), admiralmarkets.com (account types), eightcap.com, xm.com (account types, costi e oneri), interactivebrokers.com (commissioni metalli); BCM: bcmmarkets.com (solo termini).

---
## MISURA: swap di TUTTI i simboli FTMO-Demo (zip SWAPINFO_TUTTI_20261119_2150, 166 simboli con quotazione; `SWAPINFO_TUTTI_20261119/FTMO-Demo_ABTG_SWAPINFO_tutti.csv`)
Letti solo i terminali gia collegati: **FTMO** (nessun altro broker era installato; il resto richiede i demo). % annua = `swap x point x 365 / bid` (modo punti; valida anche per i CFD in valuta diversa dal conto). Controllo: XAUUSD long -5,6% (coincide con -5,5% gia calcolato), BCM -9,7%.
| Mercato FTMO | Swap long / short (% annua del nozionale) |
|---|---|
| **XAUUSD** | **-5,6% / -0,4%** |
| XAGUSD / XPDUSD / XPTUSD / XCUUSD | -10,3 / -16,9 / -12,7 / -12,1 (long); -1,0 / -7,5 / -9,9 / +1,6 (short) |
| US500 / US100 / US30 | -7,0 / -5,4 / +2,0 (long); -1,9 / -3,5 / -10,8 (short) |
| GER40 / UK100 / JP225 / EU50 / FRA40 / HK50 / AUS200 | long da -5,7% a -10,5%; short da -2,3% a +0,6% |
| **USOIL / UKOIL** | **+5,4% / +19,8% (long, si incassa)**; -28,6% / -90,9% (short) |
| NATGAS, HEATOIL | valori estremi (-193% long NATGAS, -37% short HEATOIL): da non usare senza verifica |
| Agricoli (mais, soia, grano, cacao, zucchero, cotone) | long -10,6% a -31,7%; short +1,2% a +6,1% (caffe long +2,6%) |
| BTCUSD / ETHUSD | modo "interesse": -30 (long e short), valore dichiarato dalla specifica |
| Forex: EURUSD, GBPUSD, USDJPY, AUDUSD, USDCAD, USDCHF, EURJPY, GBPJPY, EURGBP | long: -3,1 / -1,3 / +0,6 / -1,2 / +0,2 / +0,8 / +0,3 / +0,6 / -3,2; short: +0,1 / -1,5 / -4,0 / -3,9 / -2,8 / -5,8 / -2,1 / -4,4 / +0,1 |
**Letture:** (1) i long sull'oro e sugli indici FTMO costano **5-10% annuo**, circa la meta di BCM ma non trascurabile; (2) **il petrolio long incassa swap** (+5% WTI, +20% Brent) mentre lo short paga molto; (3) il forex ha swap piccoli (< 6% annuo in modulo); (4) i metalli diversi dall'oro e gli agricoli sul long costano 10-30%: non adatti a tenute lunghe; (5) per BTC/ETH la specifica dichiara -30 (interesse annuo %), ma l'esperienza BCM (spec -1,4 contro costo reale 10-14%) obbliga a verificare su un'operazione demo.
**Mancano** IC Markets, Pepperstone, FP Markets, Admirals, MetaQuotes-Demo: servono i demo installati (nessuno era collegato su questo PC).
