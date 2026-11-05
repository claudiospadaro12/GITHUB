# Analisi dei 5 report storico (05/11/2026, generati 22:43)

Fonte: 5 xlsx caricati da Claudio (trial FTMO, reale 10105439, demo 50503392 / 50504894 / 50504263).
Cambio EUR/USD usato per i rischi: 1,16 (stima).

## Risultati del giorno 05/11 (tutti PRIMA del cambio preset delle 22:44)
| Conto | Bilancio | Utile 05/11 | Operazioni | Lotti | DD max del giorno |
|---|---|---|---|---|---|
| FTMO trial 1515150476 (80k) | 80.701,73 | +723,91 (+0,9%) | 15 (14 vinte) | 0,80 | 4,49 |
| REALE 10105439 | 3.911,11 (+2.500 credito, equity 6.411,11) | +165,73 (+4,4%) | 10 (9 vinte) | 0,10 | 0,29 |
| Demo 50504894 | 105.840,41 | +1.610,80 | 18 (17 vinte) | 1,22 | 2,18 |
| Demo 50504263 | 109.781,00 | +15.129,53 | 22 (17 vinte) | 13,52 | 559 (0,52%) |
| Demo 50503392 (EA ABTG) | 429,64 (equity 224,86) | +76,70 | 16 | vari | 13,66 (3,09%) |

## Cosa è successo
- Su tutti i conti oro il 100% dell'utile viene da UNA raffica: 15 buy stop agganciati in 20 secondi (01:30 ora BCM = 02:30 FTMO, conferma FTMO = BCM + 1h), chiusi a TP/SL entro 06:30-07:30. Solo buy, nessuno sell.
- Strategie: Reaper (4-7), Phantom (1,3-7,9), GoldBot_One (5-8). Sul demo 50504894/50504263 anche Gold Trade Pro (1,2,4).
- Il cambio preset (Medium) è avvenuto alle 22:44-22:45: i pendenti sono stati cancellati e rimessi alle 22:50 e 23:00 con lotti più grandi. Quindi il Medium non è ancora stato provato su nessun trade.

## Trial FTMO: lotti prima/dopo (stessa strategia)
- Reaper 3x (0,12 -> 0,37), GoldBot_One 6-8x (0,18 -> 1,10), Phantom 6-13x (0,01 -> 0,12).
- Giornata di ieri rifatta con i lotti nuovi: circa +4.580 EUR (+5,7%), cioè oltre il target di 4.000 in un giorno. Stima grossolana, ma indica l'ordine di grandezza.
- Lato opposto, pendenti a SL (se tutti toccati e stoppati):
  - buy intorno a 4.200 (8 ordini, 2,79 lotti): ~7.460 EUR = 9,2% -> supera il limite giornaliero FTMO 5% (4.000).
  - sell intorno a 3.870 (25 ordini, 8,71 lotti): ~33.500 EUR = 42% (scenario estremo: -5% del prezzo e inversione).
  - buy intorno a 4.700: irraggiungibile in pratica.
- I set Medium ufficiali hanno `PropFirmMaxDailyDD=0` (disattivato). Sul trial resta solo il Guardian come protezione giornaliera: va verificato che sia attivo con soglia <= 3% e azione CHIUDI+BLOCCA.

## Reale 10105439
- 19 pendenti su 23 sono a 0,01: col conto da ~3.900 il lotto minimo domina, quindi il Medium cambia poco (rapporto 1,0 sulle strategie confrontabili). Il rischio vero è fissato dal lotto minimo, non dal preset.
- Rischio a SL: sell ~3.870 (16 ordini, 0,18 lotti) ~1.097 EUR (28% del bilancio) solo se il prezzo scende del 5% e inverte; buy ~4.200 ~233 EUR (6%).
- Le 10 operazioni di ieri sono tutte a 0,01: +165,73 = +4,4% in un giorno con lotto minimo.

## Demo
- 50504263: 13,5 lotti, +15.129 in un giorno, ma pendenti attuali 23,5 lotti buy / 29,3 sell con rischio a SL > 70% del bilancio. È un banco di prova ad alto rischio, non traslabile sul reale.
- 50504894: profilo intermedio (1,22 lotti), DD quasi nullo ieri.
- 50503392: conto piccolo con EA ABTG. Una posizione LARRY DOW L 0,1 lotti (U30USD) ha -199 flottanti, circa il 46% del bilancio, a ~30 punti dallo SL. Dimensione eccessiva per 430 EUR.

## Limiti
- Un solo giorno di dati; tutto dipende da un singolo evento. Nessuna conclusione sul Medium finché non ci sono trade con i lotti nuovi.
- Cambio EUR/USD stimato; valore punto oro 100 USD per lotto per punto.
