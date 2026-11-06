# Cinque combinazioni per i conti prop e due ipotesi per il reale (06/11/2026)

Base dati: tester, 80.000 EUR, anni **2013, 2020, 2025** (gli unici in comune tra oro e forex), solo profitti realizzati, un percorso per anno. Criteri per le prop: nessun giorno con perdita realizzata oltre −4,3% (soglia del Guardian) in nessun anno, DD sul saldo realizzato <= 8%. Script: `ORO_GRADINI_dati/combo6.py`.

## Cinque combinazioni per le prop
| # | Reaper | Phantom | Goldbot | GTP | Daytrade Pro | Netto 2013 / 2020 / 2025 | Somma 3 anni | Peggior giorno | DD saldo |
|---|---|---|---|---|---|---|---|---|---|
| P1 | — | Gradino 1 | Prop | — | Max9 | 38.238 / 40.275 / 29.562 | 108.075 | −4,2% | 6,1% |
| P2 | Combo | Combo | Prop | — | Max9 | 37.504 / 41.220 / 26.256 | 104.980 | −4,1% | 7,6% |
| P3 | — | — | Combo | Combo | Max9 | 37.978 / 33.261 / 16.226 | 87.465 | −3,9% | 6,3% |
| P4 | Combo | — | Prop | — | Max9 | 31.899 / 36.550 / 18.173 | 86.622 | −3,5% | 6,1% |
| P5 (la più prudente) | — | Prop | Prop | — | Max9 | 32.852 / 33.723 / 17.184 | 83.759 | −3,2% | 4,5% |

Livelli: "Prop", "Gradino 1" e "Combo" sono i set ufficiali di Wim usati nel test del 06/11 (`ORO_GRADINI_RISULTATI_2026-11-06.md`); Daytrade Pro Max9 = `Daytrade_Pro_Max9%DD_lowrisk`; GTP Combo = `Goldtrade_V4.0_prop firm_combo`.

## Ipotesi per il reale (rischio più alto, tolleranza 50% dichiarata)
| # | Composizione | Cosa dicono i dati | Cosa manca |
|---|---|---|---|
| R1 | Oro Medium (già attivo) + Daytrade Pro Max50 | Max50 a 4.000: netto +2.706 / +4.053 / +6.872 / +6.319 / +120 (2013, 2017, 2020, 2022, 2025), DD 16-29%, un giorno a −29% nel 2022; raddoppia in 153-363 giorni in 3 anni su 5 | DD combinato col Medium non misurato; test a 21 mesi del Medium in corso |
| R2 | R1 + Stability medium-low | Stability medium-low a 4.000: +6.179 / +1.520 / +3.004 / +2.305 / +1.305, DD 13-36%; indipendente dall'oro | DD combinato non misurato; nel 2025 DD 36% |

## Note
- Gli EA sono gli stessi in più conti: nei giorni neri i conti perdono insieme. In P1-P5 Daytrade Pro Max9 è in tutti.
- Regole FTMO su più conti con le stesse strategie, e costo/accessibilità dei conti: **non verificati**.
- Licenze: 10 per EA dichiarate da Claudio, non verificate sull'uso su conti prop.
- Prima di aprirne 5, forward demo sulle combinazioni (piano `PIANO_FORWARD_DEMO_SERIE4_2026-11-06.md`).
- Limiti: 3 anni, barre da 1 minuto, spread degli anni recenti forse sottostimato, flottante non misurato.
