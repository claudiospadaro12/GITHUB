# Analisi dei set del bundle oro di Wim e combinazioni (29/10/2026)
Non controllata da agenti. Fonti: set in `backtest_pipeline/set_venditore/` (confronto automatico degli input, `scratchpad/setdiff.py`), risultati gia' archiviati (`SUPERRIGA_QUATTRO_EA_RISULTATI_2026-10-28.md`, `REAPER_MAXALLOWEDDD_RISULTATI_2026-10-29.md`, `REAPER_SET_LIVE_E_RANDOMIZATION_RISULTATI_2026-10-29.md`, `GOLDBOT_D1_SONDA3_LETTURA_2026-10-21.md`) e il nuovo calcolo `PORTAFOGLIO_ORO_COMBINAZIONI_SET_CRITERI_2026-10-29.md` (uscita completa in `risultati_archivio/PORTAFOGLIO_COMBINAZIONI_SET_20261029.txt`, script `leggi_portafoglio_prop_oro_combo.py`).

## 1. Cosa cambia davvero fra i set (tutti i set di ogni EA sono UNA manopola di rischio)
- **Gold Trade Pro** (5 set): cambiano solo `MaxRiskPerStrategy` (6 / 3 / 1,5 / 1 / 0,5 = high / medium / low / prop / prop combo) e `PropFirmMaxDailyDD` (0 tranne prop e prop combo = 4).
- **Goldbot One** (5 set): `Risk=3`, step 1000; cambiano solo `MaxRiskPerStrategy` (10 / 6 / 3 / 2 / 1 = high / medium / low / prop 10-5 / prop 5-2,5) e `PropFirmMaxDailyDD` (0 / 0 / 0 / 4 / 2).
- **Gold Phantom** (7 set): cambiano `MaxAllowedDD` (60 / 30 / 10 / 9 prop / 4 prop combo / 7 combo / 30 live), `PropFirmMaxDailyDD` 4 solo nei due prop, `Randomization` 50 solo nei due prop, `OnlyUp` false solo nei due prop; `TradeFrequency` 5 ovunque, 3 nel live.
- **Gold Reaper** (8 set): cambia `MaxAllowedDD` (60 / 30 default e medium / 30 live / 15 / 15 low / 10 / 9 prop), `PropFirmMaxDailyDD` 4 e `Randomization` 50 e `OnlyUp` false solo nel prop; **`TradeFrequency` = 2 nel set prop e nel live, 5 in tutti gli altri**. Il test del `MaxAllowedDD` 6/9/12/15 era col set prop (TF 2): il set 10% e il 15% di Wim hanno TF 5, quindi NON sono l'interpolazione dei nostri test [NON MISURATO].
- I nomi "low / medium / high" non danno altro che la taglia. I set "combo" (GTP 0,5; Phantom 4 e 7) sono le versioni con rischio ridotto per girare insieme ad altri EA sullo stesso conto.

## 2. Copertura dei test, set per set (80.000, un anno ciascuno 2013 / 2018 / 2020 / 2025)
| EA / set | Stato |
|---|---|
| Reaper prop (MaxAllowedDD 9, TF 2, Random 0) | MISURATO: passa PROP-ANNI (DD 5.621 / 5.504 / 3.839) |
| Reaper prop con Randomization 50 (come nel file di Wim) | MISURATO: DD 2013 7.790 (bordo), giorno -4,9/-5,0%, non ripetibile |
| Reaper 6 | MISURATO: passa, netto circa 60% del 9 |
| Reaper 10% / 15% / default / medium / high / live (TF 5) | NON MISURATI con TF 5. Il valore 12 con TF 2 sfora (DD 8.728/8.438), 15 sfora, live 30 sfora (DD 20-33 mila) |
| Goldbot One con i set di Wim (Risk=3) | NON MISURATI. Solo la sonda del 21/10 (21 mesi, MaxRisk 3: DD 10.829 = 13,5%; 6: 31.372; 10: 80.555). La config che passa PROP-ANNI e' Risk 9999 / step 6000 |
| GTP prop (MaxRisk 1) | MISURATO: fallisce il solo DD 2020 (10.278 contro 8.000) |
| GTP prop combo (0,5), low 1,5, medium 3, high 6 | combo NON MISURATO; low/medium/high misurati e NON passano |
| Phantom prop D9 | MISURATO: passa PROP-ANNI, lento (+6/+12% l'anno) |
| Phantom prop combo D4, low D10 | misurati (DD bassi), calibrazione non valutabile; D4 circa 40% del netto del D9 |
| Phantom medium 30 / high 60 | MISURATI, non passano (DD 2013 14.774 / 48.024) |
| Phantom combo 7, live 30 (TF 3) | combo 7 NON MISURATO |

## 3. Combinazioni (somma di corse indipendenti, equity da barre M1 in ogni anno; criterio PORT-OK scritto prima: nessun anno sopra 8% dal deposito e nessun giorno >= 5%)
| Combinazione | 2013 perdita / giorno peggiore | 2018 | 2020 | 2025 | netto medio/anno | PORT-OK |
|---|---|---|---|---|---|---|
| Reaper 9 solo | 4,4% / -4,57% | 2,5% / -2,97% | 0 / -2,05% | 2,6% / -2,40% | +22.144 | SI |
| Reaper 6 + Goldbot | 5,6% / -4,60% | 2,6% / -2,98% | 0 / -1,52% | 2,0% / -1,84% | +21.585 | SI |
| **Reaper 9 + Goldbot** | 5,7% / -4,72% | 3,3% / -3,91% | 0 / -1,95% | 2,9% / -2,59% | **+29.935** | **SI** |
| + Phantom D4 (combo) | 6,8% / **-5,20%** | 3,9% / -4,38% | 0 / -1,97% | 2,9% / -2,70% | +33.917 | NO (solo il giorno 2013) |
| + Phantom D9 | **8,4%** / -5,87% | 4,6% / -4,99% | 0 / -2,40% | 2,9% / -2,86% | +39.627 | NO |
| + Phantom D10 | **8,9%** / -6,08% | 4,8% / -5,09% | 0 / -2,43% | 2,9% / -3,01% | +40.802 | NO |
| Reaper 9 + Phantom D9 (senza Goldbot) | 7,1% / -5,72% | 3,8% / -3,76% | 0 / -2,05% | 2,4% / -2,61% | +31.837 | NO |
| + Gold Trade Pro prop | 11,0% / **-9,51%** | 5,5% / -7,26% | 0,6% / -3,68% | 5,3% / -6,17% | +52.482 | NO |
| Reaper 9 + GTP prop | 10,0% / -9,33% | 4,7% / -6,04% | 0,6% / -3,18% | 5,2% / -5,88% | +44.691 | NO |
| Tutti e 4, qualunque combinazione di set provata (D4 o D9, Reaper 6 o 9) | 12-14% / -9,9 / -10,6% | 5-6% / -6,7 / -7,6% | 0,5% / -3,7% | 4-5% / -5,4 / -6,2% | +48-56 mila | NO |
(netto da conti da 80.000, 2025 a Modello 1 per tutti tranne Goldbot a tick reali. Perdita = equity minima dal deposito, pessimistica; giorno = peggiore sulla misura pessimistica. Il Guardian NON e' incluso.)

## 4. Previsioni contro esito
P1 (Reaper 9 + Goldbot passa): SI. P2 (+Phantom D4 passa, 60%): NO, di 0,16 punti (giorno 2013 -5,16/-5,20%). P3 (+D10): NO. P4 (+GTP, 30%): NO. P5-P7 (con GTP, 20-35%): NO. P8 (Reaper+Phantom, 45%): NO. P9 (Reaper+GTP, 40%): NO. P10 (la migliore combinazione che passa ha almeno 3 EA, 60%): NO (e' Reaper 9 + Goldbot, 2 EA). P11 (nessuna combinazione con 4 EA passa, 85%): SI.

## 5. Lettura
- **L'unica combinazione con piu' di un EA che passa in tutti e 4 gli anni e' Reaper 9 + Goldbot One (config testata).** Aggiungere il Phantom, anche col set combo D4, porta il 2013 a -5,2% in un giorno (23/01/2013); il Guardian con baseline saldo lo contiene intorno a -5,2% sulle barre M1 col D9 (report Guardian), per D4 NON calcolato.
- **Il Gold Trade Pro e' il peggiore da aggiungere:** il suo set prop porta il giorno 2013 a -9,5% con il Reaper. E' lo stesso oro nella stessa direzione: correlazione giornaliera 0,63 col Reaper. Il set combo (0,5) non e' mai stato misurato.
- Il Phantom D9/D10 non passa: DD 2013 8,4-8,9% e giorno oltre il 5,8%; il D4 e' il solo che sta quasi dentro.
- **Il netto non cresce in proporzione al rischio** (Reaper 12 e 15; Phantom).
- Limiti: somme di corse indipendenti (ogni EA dimensiona sul proprio saldo da 80.000; limiti giornalieri interni non si vedono fra EA; margine a 1:10 non simulato), Modello 1, un percorso per anno, probabile ottimizzazione del venditore su quegli anni. Nessun giudizio su acquisto, lotto o taglia.

## 6. Cose NON misurate che decidono i set caricati sul demo
1. Goldbot One con `PropFirm_10_5` (Risk=3, MaxRisk 2): mai misurato su 2013/2018/2020. 2. Reaper col set prop e Randomization 50 (come nel file). 3. GTP combo 0,5. 4. Phantom con D4 nel portafoglio col Guardian. 5. Reaper con TF 5.
