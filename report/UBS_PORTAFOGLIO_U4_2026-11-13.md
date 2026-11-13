# UBS U4: portafoglio di set UBS dimensionati al 2% di DD, da soli e insieme al Gold Bundle (13/11/2026)

**Natura: SIMULAZIONE sui report di U2 (braccio B)**, nessuna passata nuova. Ogni set e dimensionato con `Risk=123`, `MaxRiskPerStrategy=2`, `HistoricalMaxDD` = DD BCM misurato (2013-2025, quindi IN-SAMPLE: vedi U3). Ogni set e stato provato su 100.000 EUR; per un conto da 80.000 EUR i risultati sono scalati x0,8. Set usati (8 strategie distinte): Phantom strat8, Phantom strat3 (= Gold_c, stessa strategia, contata una volta), Goldbot dailyC, Gold Trade Pro E, Goldbot dailyI, Gold Trade Pro a, Reaper s5 H1, Reaper s1 D1. Solo realizzato (deal chiusi), senza flottante. Nessun giudizio su lotti, taglie o acquisti.
## Portafoglio UBS da solo (2013-2025, partenza da ogni terzo giorno, fino a 3 anni)
| Portafoglio | Netto/anno (80k) | DD realizzato | Peggior giorno | Giorni >= 4,5% | +10%: passa / mediana | Fallimenti |
|---|---|---|---|---|---|---|
| 8 set | 11.254 (14,1%) | 7,6% | -3,5% | 0 | 98% / **251 giorni** (+5%: 115) | 0% |
| 8 set senza Reaper s1 D1 | 11.012 (13,8%) | 6,2% | -3,5% | 0 | 98% / 260 | 0% |
| 5 set (Phantom 3, dailyC, GTP E, dailyI, GTP a) | 8.723 (10,9%) | 4,8% | -1,4% | 0 | 97% / 328 | 0% |
| singoli (PH strat8, GTP E, dailyC) | 1.082-2.357 (1,4-2,9%) | 0,7-2,1% | <= -1,9% | 0 | 0-29% in 3 anni | 0% |
Correlazione giornaliera media fra i set: 0,18.
## Insieme al Gold Bundle (anni 2013/2018/2020/2025, costi centrali; gold con equity + UBS realizzato)
| Combinazione | Giorni (fase 1 + fase 2) | Fallimenti |
|---|---|---|
| A da solo | 117 + 70 = 187 | 0% |
| A + portafoglio UBS (8 set) | 90 + 49 = **139** | **6,8%** |
| A + 5 set UBS | 90 + 46 = 136 | 2,7% |
| B da solo | 104 + 43 = 147 | 2,7% |
| B + portafoglio UBS (8 set) | 77 + 31 = 108 | 9,6% |
| Reaper L3 (Goldbot L0 + Phantom L0 + Reaper L3) | 110 + 95 = 205 | 0% |
| Reaper L3 + portafoglio UBS (8 set) | 95 + 46 = 141 | 6,8% |
**Lettura**: il portafoglio UBS da solo e lento (circa 12 mesi per le due fasi) ma senza fallimenti e con giorni peggiori di -3,5%. Aggiunto al Gold Bundle accorcia i tempi di circa 40-50 giorni, ma i fallimenti salgono a 3-10%: le giornate storte dell'oro e dell'UBS coincidono piu spesso di quanto dica la correlazione media. Il DD del portafoglio UBS e solo realizzato: l'equity vera e piu alta e non e stata ricostruita.
**Limiti**: DD misurato sullo stesso periodo del test (U3: fuori periodo regge solo in parte); realizzato senza flottante; un percorso per set; anni diversi per le due meta della simulazione combinata; Daytrade Pro non incluso.

## Aggiunta del 13/11: equity del portafoglio UBS (flottante ricostruito dalle barre M1)
**Natura: MISURA/ricostruzione** (script `ORO_GRADINI_dati/ubs_equity.py`): le posizioni dei report U2 braccio B (8 set; 0 deal non abbinati su 8.469 posizioni) con il flottante all'estremo delle barre M1 dell'oro, per gli anni con barre (2013, 2018, 2020, 2025); cambio EUR/USD medio dell'anno (2018 = ipotesi mia); ogni set scalato x0,8 per 80.000 EUR. DD = picco-valle dentro l'anno.
| Portafoglio | 2013: peggior giorno / DD equity / DD chiuso | 2018 | 2020 | 2025 | Giorni >= 4,5% |
|---|---|---|---|---|---|
| 8 set | 2,84% / **8,1%** / 7,7% | 1,57% / 3,2% / 2,7% | 1,24% / 2,6% / 2,2% | 1,63% / 2,5% / 1,3% | **0** |
| 7 set (senza Reaper s1 D1) | 2,72% / 6,7% / 6,2% | 1,57% / 3,1% | 1,20% / 2,5% | 1,53% / 2,4% | 0 |
| 6 set (5 + Reaper s5) | 2,07% / 4,7% / 4,3% | 0,98% / 3,1% | 1,20% / 2,2% | 1,30% / 1,7% | 0 |
| 5 set | 2,07% / 4,1% / 3,6% | 0,98% / 3,1% | 1,20% / 2,2% | 1,30% / 1,7% | 0 |
Il flottante aggiunge poco al DD del portafoglio (8,1% in equity contro 7,7% chiuso nel 2013). Il DD cumulato non e la somma dei DD dei singoli set (8 x 2,4% = 19%): 8,1% nel 2013 e meno di meta.
**Sfida simulata con l'equity** (partenza gennaio-marzo di 2013/2018/2020/2025, finestre dentro l'anno, +10% / +5%): 8 set: fase 1 passa 70% (mediana 182 giorni, p75 253), fallisce 0%, il 30% non arriva al +10% entro la finestra; fase 2 passa 85% (mediana 89). 6 set: fase 1 mediana 180 (passa 50%); 5 set: 193 (passa 49%). Totale tipico per le due fasi: circa 270 giorni (8 set).
**Limiti**: DD in-sample (stesso periodo della misura del DD: U3 mostra che fuori periodo regge solo in parte); 4 anni di barre; flottante all'estremo della barra, non al tick; 2018 con cambio ipotizzato.

## Aggiunta del 13/11 (sera): con il cuscinetto 1,5 e i costi FTMO (script `ORO_GRADINI_dati/ubs_costi.py`)
**Natura: SIMULAZIONE** sugli stessi report U2 braccio B (8 set; 80.000 EUR = x0,8). Cuscinetto 1,5 = tutto il P&L e il flottante divisi per 1,5 (approssimazione: lotti ~ 1/1,5; misurato in U3b: netto al 65%, quindi un po prudente a favore). Costi FTMO extra = 36 EUR per lotto round turn oro ("centrali", mia ipotesi), 9 e 18 EUR (spread FTMO come BCM o quasi) e 72 (doppi). Tempi in giorni di calendario da ogni terzo giorno 2013-2025 (realizzato, fino a 3 anni); DD in equity per anno dalle barre M1.
| 8 set | Netto/anno | Fase 1 (+10%): passa, mediana | Fase 2 (+5%) mediana | Fallimenti | DD equity 2013 / 18 / 20 / 25 |
|---|---|---|---|---|---|
| senza cuscinetto, senza costi (U4) | 11.254 (14,1%) | 98%, 251 | 115 | 0% | 8,1 / 3,2 / 2,6 / 2,5 |
| senza cuscinetto, costi centrali | 6.621 (8,3%) | 89%, 332 | 171 | 0% | 8,7 / 5,4 / 2,9 / 2,6 |
| cuscinetto 1,5, senza costi FTMO | 7.503 (9,4%) | 96%, 373 | 182 | 0% | 5,4 / 2,2 / 1,7 / 1,7 |
| cuscinetto 1,5 + costi 9 EUR/lotto | 6.731 (8,4%) | 96%, 404 | 203 | 0% | 5,5 / 2,3 / 1,7 / 1,7 |
| cuscinetto 1,5 + costi 18 EUR/lotto | 5.959 (7,4%) | 93%, 428 | 226 | 0% | 5,6 / 2,5 / 1,8 / 1,7 |
| **cuscinetto 1,5 + costi centrali (36)** | **4.414 (5,5%)** | 79%, **493** | **271** | 0% | 5,8 / 3,6 / 2,0 / 1,7 |
| cuscinetto 1,5 + costi doppi (72) | 1.326 (1,7%) | 46%, 639 | 300 | **18,3%** | 6,1 / 7,9 / 2,5 / 1,8 |
Con 6 set (senza Reaper s1 D1 e senza Gold_c/Phantom strat8): cuscinetto + costi centrali 4.238 (5,3%), fase 1 mediana 523 giorni (passa 78%); cuscinetto senza costi 6.620, 421 giorni.
**Lettura**: i costi pesano molto sull'UBS perche i set fanno molti piccoli trade (circa 128 lotti round turn l'anno su 80k): a 36 EUR/lotto portano via 4.600 EUR l'anno (41% del netto). Con il cuscinetto e i costi centrali il portafoglio impiega circa 760 giorni (due anni) per le due fasi; anche senza costi FTMO circa 555 giorni (18 mesi). Il DD resta basso (equity 5,8% nel 2013, giorno peggiore 2%), ma il tempo e fuori portata per una sfida. **L'UBS come conto prop a se: non competitivo**; come aggiunta al Gold Bundle porta rischio (fallimenti 3-10%) e il guadagno si dimezza con i costi.
**Limiti**: costi ipotizzati (la differenza vera con BCM e lo spread FTMO, non misurato); cuscinetto applicato per scala; DD misurato in-sample; realizzato per i tempi.
