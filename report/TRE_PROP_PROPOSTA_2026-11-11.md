# Tre conti prop (1 x 160k + 2 x 80k): proposta con DD, PF e guadagno medio annuo (11/11/2026)

**Natura: STIMA da backtest** (tester BCM, Modello 1, 80.000 EUR, anni 2013 / 2020 / 2025, un percorso per anno; Reaper e Phantom hanno Randomization 50 = rumore). Il 160k vale il doppio dell'80k (D160: R 2,02-2,11 sulle combo, `RISULTATI_D160_ORO_2026-11-09.md`). Nessun consiglio di lotto o taglia: lotti dei set. Script in `ORO_GRADINI_dati/tre_*.py`, `equity_tre.py`, `equity_tre.json`.

## Criteri fissati PRIMA di guardare i numeri
1. Nessun giorno con perdita realizzata <= -4,3% (soglia del Guardian) e peggior giorno realizzato >= -3,6% nei 3 anni.
2. DD realizzato massimo <= 6,0% per conto (limite FTMO 10%).
3. PF >= 1,5 per conto.
4. Un EA (e livello) su un solo conto (niente strategia identica su due conti).
5. Meno ore possibili con posizioni oro OPPOSTE fra conti (FTMO: vietato fra piu conti, vedi `FTMO_RISPOSTE_TRACCIA_2026-11-09.md`, domanda 8).
6. Fra le valide: massimo netto annuo.
Costi: scenario "centrale" (36 EUR/lotto oro, 4 EUR/lotto forex, meta all'apertura e meta alla chiusura).

## Perche non il Medium
Reaper + Phantom + Goldbot a livello Medium (L2) a 80k nel tester: netto 209.017 / 173.856 / 249.326 EUR, ma peggior giorno realizzato **-50,3%**, 59 giorni oltre -4,3%, DD realizzato 76%: conferma ex ante il comportamento visto sul trial e sul reale. Livelli Prop/Gradino 1/Combo scelti sotto.

## Proposta (3 conti)
| Conto | Composizione (set di Wim) | Netto/anno dopo costi, a 80k (2013 / 2020 / 2025) | Media annua 80k | **Media annua sul conto** | PF (per anno 2013 / 2020 / 2025) | DD realizzato | DD equity ricostruita (2013 / 2020 / 2025) | Peggior giorno realizzato |
|---|---|---|---|---|---|---|---|---|
| **160k** | Goldbot One Prop (L0) + Gold Reaper Combo 3GOLD (L3) | 16.795 / 16.217 / 15.751 | 16.254 | **32.508** (20,3% del conto) | **1,79** (1,59 / 1,88 / 2,09) | 5,8% | 5,7% / 3,2% / 3,0% | -3,6% |
| **80k** | Gold Phantom Gradino 1 (L1) | 5.764 / 7.926 / 18.756 | 10.815 | **10.815** (13,5%) | **1,59** (1,22 / 1,44 / 2,64) | 5,5% | 5,0% / 2,8% / 3,0% | -2,5% |
| **80k** | Daytrade Pro Max9 (EURUSD ecc., D1) | 8.799 / 16.431 / 372 | 8.534 | **8.534** (10,7%) | **1,51** (1,50 / 2,04 / 1,02) | 4,7% | limite sup. 5,8% / 3,6% / 4,7% | -2,6% |
| **Totale** | 320k di capitale equivalente | 48.152 / 56.790 / 50.629 | | **51.857** (16,2%) | | congiunto 4,1% (2013), 1,3%, 1,5% | | congiunto -2,2% di 320k (2013) |
Media annua lorda, prima del profit split. Senza costi (tester puro) il totale medio e circa 62.800 (Goldbot+Reaper 19.953 x2, Phantom 13.992, DTP 8.921).
**DD equity**: per i due conti oro ricostruita con il flottante dalle barre M1 (`equity_tre.json`; il peggior giorno equity del 160k e 3,7% il 31/12/2013, ultimo giorno del test, forse chiusura forzata); per DTP non ci sono le barre forex, quindi e il valore del report (DD equity del tester).

## Posizioni opposte fra conti (misura, 3 anni)
Oro: conto 160k contro conto Phantom **2.286 ore con una posizione long su un conto e short sull'altro, 98 episodi** (circa 33 l'anno). Con DTP (forex) 0. Gli altri assetti provati: tre conti con oro 2.286-7.630 ore a coppia; Goldbot Prop + Phantom Combo contro Gold Trade Pro 9.302 ore. **Il divieto FTMO e rigoroso e la domanda alla seconda mail (n. 1) non ha ancora risposta**: questa proposta e quella con meno ore fra le valide che hanno il netto piu alto, non una garanzia. Con un solo conto oro il rischio e 0, ma serve il 160k su tutto l'oro.

## Alternative scartate
- **Massimo rendimento con oro su tre conti**: 160k Goldbot Prop + Reaper Combo / 80k DTP + Gold Trade Pro Combo / 80k Phantom Gradino 1: 60.262 EUR/anno, ma sovrapposizioni opposte 2.286 / 3.676 / 7.630 ore e il conto DTP + GTP ha il limite superiore del DD equity al 10,2% nel 2013.
- **PF piu alto**: 160k Goldbot Prop + Phantom Combo (PF 1,93, DD 3,6%) / GTP Combo / DTP + Reaper Combo: 54.148 EUR/anno, sovrapposizioni 7.178-11.015 ore.
- **Forex diversi da DTP**: Stability Pro low ha DD equity 15,7% (2013) e 21,3% (2025) a 80k, Luna 4DD 28,6% di DD realizzato: fuori dal 10%. Il solo EA forex dentro i limiti e DTP.

## Limiti
3 anni, tester, un percorso per anno; Phantom e Reaper con rumore (netto annuo 6-46% di scarto); DTP 2025 praticamente a zero (372 EUR, PF 1,02) e sensibile ai tick; scarti misurati con tick reali: Goldbot -6%, Reaper -8%, Phantom -3% (non applicati qui); chiusura del venerdi non applicata (costo 7-12%); flottante dell'oro ricostruito solo da barre M1; margine/leva oro FTMO (1:50) e limiti di lotto per ordine non verificati; tetto 400k per strategia condiviso con altri utenti non misurabile; nessun forward; il PF e ricostruito dagli affari (coincide con il report del tester a +/-0,03). Niente di tutto questo e un consiglio di taglia o di acquisto.
