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
