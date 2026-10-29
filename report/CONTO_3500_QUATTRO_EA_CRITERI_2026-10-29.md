# Gold Snap, SomaGold, Umbra Vault e Microedge a 3.500 EUR nel tester: criteri e previsioni scritti PRIMA dei numeri (29/10/2026)
Non controllata da agenti. Richiesta di Claudio (29/10): "preparami la riga a 3.500, ma dobbiamo anche calcolare lo spread". Confronto con la stima del 29/10 (`CONTO_REALE_3500_NOVE_EA_RISULTATI_2026-10-29.md`, caso A: corse a 5.000 x 0,7).

## Passate (riga `RIGA_LANCIA_CONTO3500.txt`, script `ANNO3500_TESTER.ps1` = ANNO80K con deposito 3.500, pin 893ab69d)
Quattro corse continue 01/01/2025-01/10/2026, XAUUSD H1, **tick reali (Modello 4)**, deposito **3.500 EUR**, leva 1:100 del tester (la leva del conto reale NON e verificata), nessun guardiano. Stessi input della corsa a 5.000 (cosi cambia SOLO il deposito): Umbra `EquityGuardEnabled=false`, Microedge `propGuard=false`, SomaGold `AutoGMT=false` con offset GMT 1 e 1 e `MarginCallProtection=false`, Gold Snap default.

## Spread (calcolo, senza nuova corsa)
Il tester a Modello 4 usa lo spread VERO dei tick storici BCM (misura del 03/09 sugli indici: nessun tick solo-bid). Per ogni posizione delle corse (a 5.000 ora, a 3.500 dopo) lo spread della barra M1 all'ingresso e all'uscita (colonna `spread` dell'export M1 BCM) si converte in costo: lotti x 100 oz x media(ingresso, uscita) x 0,01 USD/punto x fx. Misurato oggi sulle corse a 5.000: `backtest_pipeline/risultati_archivio/SPREAD_PAGATO_5K_20261029.txt`. Lo spread del conto REALE puo essere diverso da quello del feed storico: NON misurato (serve il registratore sul reale: `RIGA_INSTALLA_SPREADLOGGER_REALE`, a decisione di Claudio).

## Previsioni (probabilita)
- **T1** 4/4 corse valide (`input_ok = si`, deposito 3.500 nel report): 90%.
- **T2** Nessuno stop out nelle quattro: 75%.
- **T3** Il netto a 3.500 e entro +-15% di 0,7 x il netto a 5.000 per Gold Snap: 65%; per Umbra: 65%; per Microedge: 65%; **per SomaGold NO** (lotto minimo 0,01 nel 73% degli ingressi a 5.000): 70%.
- **T4** SomaGold a 3.500 ha righe "no money" (ordini rifiutati per margine): 80%; Gold Snap: 25%.
- **T5** Gold Snap porta l equity a 7.000 entro 150-230 giorni: 60%. SomaGold entro 230 giorni: 55%.
- **T6** Il DD equity in percentuale a 3.500 e entro 3 punti da quello a 5.000 per Gold Snap, Umbra e Microedge: 60%.
- **T7** Spread medio pagato (punti) fra 20 e 28 per tutte e quattro: 85%.
- **T8** Il costo di spread stimato supera il 15% del netto per Umbra e Microedge e sta sotto il 15% per Gold Snap e SomaGold: 70% (dalle corse a 5.000: 19,8% e 22,2% contro 8,8% e 4,0%).

## Cosa NON dice
21 mesi di oro in forte rialzo, un percorso; tester senza slippage, gap, latenza; margine e stop out del broker reale NON verificati; lotto minimo e arrotondamenti del tester BCM; nessun giudizio su acquisti, lotti o taglie.
