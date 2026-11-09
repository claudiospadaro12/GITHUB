# Chiusura del cancello minimo prima di UBS: una riga per EA (09/11/2026)

Cancello congelato l'08/11 (`CANCELLO_MINIMO_PRIMA_DI_UBS_2026-11-08.md`): oro + forex, 8 EA. Regola scritta prima: **TESTATO BENE** solo se tutte le voci dell'EA sono fatte senza sorprese; altrimenti **TESTATO CON QUESTI LIMITI**, con i limiti elencati. **Questa pagina non promuove nessun EA a "adatto al reale" o "adatto alla prop"**: lo decide Claudio col forward. Nessuna taglia, nessun lotto.

## Voci del cancello: stato finale
| Voce | Stato | Dove |
|---|---|---|
| F-A fuori campione forex, 7 anni nuovi (70 passate) | FATTO | `RISULTATI_FOREX_OOS_2026-11-08.md` |
| F-B tick reali contro barre, 2025 (4 passate) | FATTO | `RISULTATI_FOREX_TICK_2026-11-08.md` |
| F-E costi FTMO e correlazione forex | FATTO | `RISULTATI_FE_FOREX_COSTI_E_CORRELAZIONE_2026-11-08.md` |
| O-1 `AdjustLotsizeToVariableValues`, `FridayStopHour` | FATTO | cancello, sezione O-1 |
| O-2 chiusura del venerdi (41 passate valide su 42) | FATTO | `RISULTATI_O2_WEEKEND_2026-11-09.md` |
| O-3 e O-3b Randomization (12 + 6 passate) | FATTO | `RISULTATI_O3_RANDOMIZATION_2026-11-09.md`, `RISULTATI_O3B_RIPETIBILITA_REAPER_2026-11-09.md` |
| D160 scalatura a 160k (oro, GTP, DTP: 30 passate) | FATTO (non era nel cancello) | `RISULTATI_D160_ORO_2026-11-09.md` |
| Giro C (orari GMT), giro D (80k forex), AdjustEntry negativo, strategia 9 del Reaper | **limiti dichiarati, non test** | cancello |

## Una riga per EA
| EA (set) | Verdetto | Cosa e stato misurato | Limiti dichiarati di questo EA |
|---|---|---|---|
| **Goldbot One** (L0 Prop, L3 Combo 3GOLD) | **TESTATO BENE** (a L0 e L3) | 4 anni 2013/2018/2020/2025 a 80k; fuori campione 2005-2012 (8/8 anni positivi); tick reali 2025 (-6%); chiusura del venerdi -9/-10% (deterministico, Randomization 0); scala x2,03-2,04 a 160k (D160); nessuno stop out | Non e un livello per ogni rischio: L1 e L2 non passano i criteri prop. Solo oro, 4 anni piu 2005-2012, un percorso per anno; P&L realizzato; margine e leva dell'oro su FTMO NON VERIFICATI |
| **Gold Trade Pro** (Combo: Risk=3, MaxRisk 0,5, DD giorno 4,0) | **TESTATO CON QUESTI LIMITI** | 5 livelli (Low, Medium, High, Prop, Combo) su 4 anni a 80k (il Prop arriva a DD 11,7% nel 2020: non regge; il Combo resta sotto il 6%); fuori campione 2005-2012 (8/8); tick reali 2025 (-2%); venerdi 19:00 misurato su 4 anni; scala x2,04 a 160k; deterministico | Chiusura del venerdi misurata (`RISULTATI_O2_GTP_2026-11-09.md`): chiude (attraversamenti 3,4% -> 0,1%), costo 7,4% sulla somma dei 4 anni ma **-31% nel 2020** (ALTO per la regola per anno; il GTP e deterministico, non e rumore); il GTP nelle combo peggiora il peggior giorno di 0,6-1,7 punti (2013: fino a -7,4% con Reaper + Goldbot) e ha correlazione 0,6-0,8 col Reaper |
| **Gold Reaper** (L0 Prop, L3 Combo) | **TESTATO CON QUESTI LIMITI** | 4 anni a 80k; fuori campione 2005-2012; tick reali (-8%); venerdi -7/-12%; Randomization 0/50/60; ripetibilita (3 corse per anno); scala x2,07 a 160k; fake-out Fase 1 e 2 (nessuna configurazione dimostrata migliore del Medium) | **Rumore**: Randomization 50 = percorso casuale (netto annuo 6-46% di scarto; 2013 il peggiore). L0 da solo: -6,0% nel 2013, 2 giorni oltre -5%, DD realizzato 9,1%: non regge. L3 troppo piccolo da solo. Chiusura del venerdi: costo ALTO in un anno distinguibile dal rumore (2020: rapporto 0,74-0,79). Strategia 9 e `AdjustEntry` non testate |
| **Gold Phantom** (L0, L1, L3) | **TESTATO CON QUESTI LIMITI** | 4 anni a 80k; fuori campione 2005-2012; tick reali (-3%); venerdi -8%; Randomization 0/50/60; scala x2,11-2,17 a 160k | **Rumore** (Randomization 50): ripetibilita misurata solo nelle 2 ripetizioni a 160k del giro D160 (scarto fra le due 0,5-22% su L0 e 3-7% su L1), non a 80k; con Randomization 0 perde 9-30%; 2013 e anno critico per L1 e L0. Chiusura del venerdi: non classificabile (tutte le celle nel rumore) |
| **Stability Pro low risk** | **TESTATO BENE** (forex, per la definizione scritta) | Fuori campione 12 anni: DD massimo 18,6%, 12/12 positivi, saldo minimo 4.281 (a 4k); tick reali: ROBUSTO (-14%); costi FTMO: REGGE (91% nello scenario centrale); correlazione con DTP e oro ~0, con Apex 0,25 | Giro D (80k) non fatto: lotti a 4k, il tester a 80k li gonfia; flottante e Guardian non simulati; "max DD a 0,01 lotti" del venditore non ricalibrato (non misurabile da fuori l'`.ex5`); griglia: le 2.000 richieste/giorno FTMO non misurate; griglie non nominate come vietate ma neanche permesse (da chiedere) |
| **Daytrade Pro Max9** | **TESTATO CON QUESTI LIMITI** | Fuori campione 12 anni: DD max 9,1%, 12/12 positivi; costi: REGGE (96%); scala x2,00 a 160k (D160) | **Sensibile ai tick** (netto 2025 da +131 a +70 EUR, ma su base minuscola; il 2025 e il suo anno peggiore); netto 2025 a 80k quasi zero (702 EUR); lotti a 4k vs 80k; flottante, Guardian e "max DD a 0,01 lotti" come Stability. Max20 stessa classe (12/12, 20,4% DD); Max50 zona grigia |
| **Luna AI** (4DD) | **TESTATO CON QUESTI LIMITI** | Fuori campione: DD 22,7%, 10/12 positivi (2013 e 2014 in perdita), saldo minimo 3.174; costi: ZONA GRIGIA (68% centrale, 35% prudente) | **Sensibile ai tick** (-83% di netto, operazioni -45%): una Luna a barre e ottimista; orari `GMT_Offset` non verificati (giro C non fatto); il lowrisk e zona grigia (DD 48%); perdite reali recenti degli utenti su cross AUD |
| **Apex Trader** (Conservative; Ultra) | **TESTATO CON QUESTI LIMITI** | Fuori campione: Conservative DD 27,1%, 11/12 positivi, giorni a -23% del conto; Ultra 10/12, DD 32,9%; tick reali ROBUSTO (-8%, solo Conservative) | Costi: ZONA GRIGIA (Cons 82% con un anno che cambia segno, Ultra 69%); griglie con giorni da -23%; orari `GMT_Offset` non verificati (giro C non fatto); Elevated in zona grigia (DD 45,7%); correlazione Cons-Ultra 0,97 (stessa strategia) |

## Limiti comuni a tutti gli EA
- **Solo tester**, barre da 1 minuto (tick reali solo 2025, perche i tick BCM partono dal 10/07/2024), un percorso per anno, nessun forward, nessuno slippage reale.
- **Randomization 50** su Reaper e Phantom: i risultati sono percorsi casuali; per decisioni che dipendono da 10-15% servono 3 o piu passate.
- **Flottante** non ricostruito (DD equity e un limite superiore o il massimo del report); Guardian simulato solo sul realizzato.
- **Regole FTMO NON VERIFICATE**: leva dell'oro (Standard/Swing), limiti di lotto per ordine, conteggio delle 2.000 richieste, ordini pendenti nel weekend, tetto e copy-trading (mail pronta, non inviata). **Margine**: calcolato dai report (`RISULTATI_MARGINE_ORO_2026-11-09.md`): a 1:30 l'oro usa il 14-47% dell'equity (non serve tagliare i lotti), a 1:9 (ipotesi non confermata) supererebbe il 100% per i conti piu grandi.
- **Versioni degli EA**: Wim ha ricaricato gli EA sul dashboard con lo stesso numero di versione (07/11): quale file gira su PC, VPS e trial non e verificato.
- **Guardian v1.17** compilato (0 errori) ma non provato su MT5.

## Cosa significa e cosa viene dopo
- **8 EA**: 2 "TESTATO BENE" (Goldbot One, Stability Pro low), 6 "TESTATO CON QUESTI LIMITI". Il cancello non vieta UBS: la regola era "ogni EA ha una riga con i suoi limiti".
- **Prossimo passo**: UBS, prima tappa = ricalibrare il "max historical DD a 0,01 lotti" sul BCM e sul FTMO (Wim), poi i set. Resta separato dal forward in corso e dalla scelta delle prop.
- **Resta fuori da questa pagina e dalle sue promozioni**: acquisto di challenge, lotti, taglie, scelta fra P1/P5, Standard o Swing.
