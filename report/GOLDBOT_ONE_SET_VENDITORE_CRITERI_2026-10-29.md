# Goldbot One con i set del venditore (Risk=3): criteri e previsioni scritti PRIMA dei numeri (29/10/2026)
Non controllata da agenti. Richiesta di Claudio (29/10): "preparami il test di Goldbot One". Origine: i set scaricati da Wim usano `Risk=3` (use Max Risk Per Strategy, mappa [PROBABILE] dalla sonda 3 del 21/10) con `LotPerBalance_step=1000`; il nostro PROP-ANNI SI del 26/10 era con `Risk=9999` (use LotsizeStep), step 6000, MaxRisk 6: un'altra modalita di lotto. Fonti: `set_venditore/goldbot_one/*.set`, `GOLDBOT_D1_SONDA3_LETTURA_2026-10-21.md`, `TRE_ANNI_PROP_80K_3EA_RISULTATI_PARZIALI_2026-10-26.md`.

## Passate (riga `RIGA_LANCIA_GOLDBOT_SETVEND_80K.txt`, script ANNO80K v5, pin 3e43646d; 80.000 EUR, XAUUSD D1, build di Market gia con Virtual SL/TP e filtri IR/CPI)
Tre configurazioni, tutte `Risk=3`, TUTTI gli input imposti (lezione dello Stability; valori dei set di Wim; Randomization 0, OnlyUp false, FakeOutFilter 1, FridayStopHour 25):
- **PF105** = `Goldbot_PropFirm_10_5`: MaxRiskPerStrategy 2, PropFirmMaxDailyDD 4.
- **PF525** = `Goldbot_PropFirm_5_2.5`: MaxRiskPerStrategy 1, PropFirmMaxDailyDD 2.
- **LOW3** = `Goldbot_LowRisk_Max15DD`: MaxRiskPerStrategy 3, PropFirmMaxDailyDD 0.
Per ognuna: 2013, 2018, 2020, 2025 a Modello 1 (12 passate); 21 mesi (01/01/2025-01/10/2026) a Modello 1 (3 passate: LOW3 e il CONTROLLO della sonda 3 T1: +51.745, DD 10.829); 21 mesi a tick reali per PF105 (1 passata, calibrazione). Totale 16 passate.

## Criteri
- **Validita:** 16/16 OK, `input_ok = si` (tutti gli input imposti letti dal report).
- **PROP-ANNI (per configurazione):** netto > 0 in 2013/2018/2020; DD equity <= 8.000 EUR in ognuno; nessuno stop out; nessun giorno realizzato >= 5%; calibrazione 2025 (M1/M4 sui 21 mesi, rapporto 0,5-2,0, correlazione mensile >= 0,5) misurabile SOLO per PF105 (le altre: "non valutabile").
- **Dopo i numeri:** portafoglio Reaper 9 + Goldbot (config del venditore) con `leggi_portafoglio_prop_oro_combo.py`, criterio PORT-OK dei combo (perdita <= 8% dal deposito, giorno < 5% in OGNI anno).

## Previsioni (probabilita)
- **K0 (controllo):** LOW3 21 mesi M1 riproduce la sonda 3 T1 entro +-3% sul netto (+51.745) e sul DD (10.829): 90%.
- **Q1** PF525 PROP-ANNI (calibrazione non valutabile, quindi sui tre anni): 85%. **Q2** PF105 PROP-ANNI: 45%. **Q3** LOW3 PROP-ANNI: 20%.
- **Q4** Per netto e per DD equity l'ordine LOW3 > PF105 > PF525 vale in ogni anno: 90%.
- **Q5** PF105 21 mesi M1: netto fra +20.000 e +40.000 e DD equity fra 4.500 e 9.000: 55%.
- **Q6** PF105 e piu del doppio del vecchio set (step 6000: 21 mesi +11.173, DD 3.213) per netto: 75%.
- **Q7** PF105: 2018 e l'anno con DD equity piu alto: 65%; DD 2018 > 8.000: 30%.
- **Q8** Nessun giorno realizzato >= 3% in PF105 e PF525: 80%.
- **Q9** Calibrazione PF105 OK: 85%.
- **Q10** Nessuna riga "no money" (ordini rifiutati per margine) in PF105 e PF525: 90%.
- **Q11** Portafoglio Reaper 9 + Goldbot PF105 PORT-OK: 35%; con PF525: 85%.

## Cosa NON dice
Un percorso per anno; Modello 1 sui tre anni vecchi; 2013/2018/2020 probabilmente dentro l ottimizzazione del venditore; nessuna slippage; filtro news non simulato (il tester non ha il calendario MQL5: usa le date interne); margine con leva 1:10 non simulato; `Risk=3` = Max Risk Per Strategy e dedotto dai lotti, non dichiarato dal set. Nessun giudizio su acquisto, lotto o taglia.
