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
