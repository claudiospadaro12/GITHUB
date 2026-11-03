# Gold Trade Pro COMBO a tick reali nel 2025: criteri e previsioni scritti PRIMA dei numeri (03/11/2026)
Richiesta di Claudio: "preparami la riga per il GTP COMBO a tick reali nel 2025". Origine: il fuori campione 2005-2012 (report GTP_OOS_2005_2012_RISULTATI_2026-11-03.md) ha dato al COMBO netto/DD 19,9 e DD 3,39%; manca la misura a tick reali sul 2025, come per Reaper, Goldbot e Phantom (report TICK_2025_TRE_EA_RISULTATI_2026-11-01.md). Non controllata da agenti.

## Passata (script ANNO80K v5, pin 3e43646d)
UNA corsa 2025 (01/01/2025-01/01/2026), XAUUSD **D1**, **Modello 4 (tick reali)**, 80.000 EUR, `Gold Trade Pro MT5.ex5`, input del set COMBO: `Risk=3`, `MaxRiskPerStrategy=0,5`, `PropFirmMaxDailyDD=4,0` (stessi input del test 2005-2012 e del conto da 3.745; gli altri input restano quelli salvati dal tester: il report li stampa e `input_ok` li controlla). Tempo stimato 1-1,5 ore (21 mesi del PROP a tick reali ne richiesero circa 2-3).

## Riferimenti 2025 a tick reali, 80.000 EUR (TICK_2025_TRE_EA_RISULTATI)
Reaper D9 +27.985, DD 3.104, netto/DD 9,02, peggior giorno -882. Goldbot PF525 +8.444, DD 1.611, 5,24, -891. Phantom D4 +5.409, DD 794, 6,81, -193. PROP a 80.000 nel 2025 (dal report del 31/10, non riletto): circa +47,5%, DD relativo 7,0%.

## Criteri
Validita: stato OK, `input_ok = si`, qualita 100% (tick reali), finestra 2025.01.01-2026.01.01, nessuno stop out. Misure: netto, DD equity massimo, operazioni, peggior giorno realizzato, netto/DD, quota long/short, ordini rifiutati ("no money").

## Previsioni (probabilita)
- **C1** Corsa valida: 85%.
- **C2** Netto positivo: 95%.
- **C3** Netto tra 12.000 e 30.000: 55% (sotto 12.000: 20%; sopra 30.000: 25%).
- **C4** DD equity <= 4.000 (5% di 80.000): 60%; <= 8.000: 90%.
- **C5** Peggior giorno realizzato <= 2.000 (2,5%): 70%; <= 4.000 (5%): 95%.
- **C6** Netto/DD >= 5: 65%; superiore a quello del Goldbot (5,24): 55%; superiore a quello del Phantom (6,81): 45%.
- **C7** Netto da long almeno l'80%: 70% (il 2025 e un anno di rialzo forte dell'oro).
- **C8** Operazioni tra 200 e 450: 55%.
- **C9** "No money" <= 10: 75%.

## Cosa NON dice
Solo il 2025 (anno di rialzo), un percorso, lotti a inizio anno, tester senza slippage e gap, margine del tester fisso, nessuna misura della correlazione con gli altri EA ne del peggior giorno del portafoglio insieme (serve la serie giornaliera). Nessun giudizio su acquisti, lotti o taglie; la scelta dei tre EA per la Free Trial non cambia da sola.
