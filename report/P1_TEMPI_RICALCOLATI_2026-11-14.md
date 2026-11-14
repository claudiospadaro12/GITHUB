# P1: tempi ricalcolati con il Phantom del 2026 e con la correzione tick (14/11/2026)

**Natura: STIMA DI PRIMO ORDINE, NON una nuova simulazione.** Il motore di simulazione (equity ricostruita, partenze da ogni giorno) usa dati che in questa sessione non ci sono piu (zip della griglia oro, D160, barre M1). Ho quindi scalato i tempi di `TEMPI_SFIDA_CON_COSTI_2026-11-13.md` e `PROBABILITA_PASSARE_LE_TRE_2026-11-13.md` con il rapporto tra netto annuo vecchio e nuovo (ipotesi: il tempo per arrivare a +10% e +5% e inversamente proporzionale alla deriva dei profitti, a parita di volatilita). Un ricalcolo esatto richiede di ricaricare quei dati.

**Ingressi**
- P1 base (tester Modello 1, costi centrali, media 2013/2020/2025): netto 30.582 EUR/anno; due fasi 112 giorni (somma delle mediane), 137 in sequenza; entro 6/7/9 mesi 76% / 89% / 100%.
- Phantom Gradino 1 a 80k, Modello 1: 2013 10.873, 2020 10.919, 2025 20.183 (media 13.992 EUR/anno).
- Phantom 2026 a tick reali, 10,5 mesi: +8.011 EUR (`CONFRONTO_M1_TICK_REALI_CRITERI_2026-11-14.md`, Tappa 3), annualizzato 9.176; in equivalente Modello 1 circa 10.400 (dividendo per 0,88).
- Correzione tick sull'intero P1 (da `CONFRONTO_M1_TICK_REALI...`): netto -8% / -17%, fattori 0,92-0,83.

## Scenari
| Scenario | Netto P1 (EUR/anno) | Fattore sul tempo | Due fasi (somma mediane, centrali) | Prudenti | In sequenza | Entro 6 mesi | Entro 7 mesi | Entro 9 mesi |
|---|---|---|---|---|---|---|---|---|
| **Base (tester)** | 30.582 | 1,00 | **112** | 129 | **137** | 76% | 89% | 100% |
| Solo il Phantom come nel 2026 | 27.017 - 25.766 | 1,13 - 1,19 | 127 - 133 | 146 - 153 | 155 - 163 | 59 - 64% | 73 - 78% | 92 - 94% |
| **Phantom 2026 + correzione tick su tutto P1** | circa 21.500 - 23.800 | 1,23 - 1,43 | **138 - 160** | 159 - 184 | **169 - 196** | 46 - 56% | 56 - 69% | 79 - 91% |
Le probabilita entro 6/7/9 mesi sono ricavate interpolando la distribuzione di base (in sequenza: mediana 137, 76% a 182 giorni, 89% a 210, 100% a 270).

## P1 e P4 insieme
- Base: entrambe entro 7 mesi 75%, entro 9 mesi 95% (P4 e il collo di bottiglia, 77% e 95%).
- Nuovo (stima mia, con P1 piu lento e P4 invariato): entrambe entro 7 mesi circa **50-65%**, entro 9 mesi circa **77-90%**. P4 diventa chiaramente piu veloce di P1 solo nello scenario con correzione tick: sotto la stima base P1 restava piu veloce.

## Limiti
Primo ordine (non simulazione); il tempo non scala esattamente con la deriva; i fallimenti NON sono ricalcolati (piu tempo = piu esposizione alle giornate di coda, effetto piccolo ma non nullo); nessun margine di errore calcolato; il Phantom 2026 e un percorso con Randomization 50 su 10,5 mesi; nessun costo FTMO reale (spread, slippage); la correzione tick e misurata solo sul 2025.
