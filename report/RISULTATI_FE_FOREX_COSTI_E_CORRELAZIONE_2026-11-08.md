# F-E forex: costi FTMO e correlazione (08/11/2026)

Criteri e previsioni scritti PRIMA: `CANCELLO_MINIMO_PRIMA_DI_UBS_2026-11-08.md`, sezione F-E. Nessuna passata nuova: si usano i report gia raccolti (12 anni: 5 del giro 4k + 7 del giro A) dei 7 set che hanno superato il fuori campione o servono da confronto. Script e dati: `FOREX_OOS_dati/fe_costi_correlazione.py`, `fe_res_raw.json`, `fe_e1.json`.

## E1: costi FTMO e slippage
**Metodo.** Netto del tester ai lotti dei report, meno `lotti x costo extra per lotto` (round trip) in 3 scenari: ottimistico 2,5, **centrale 4**, prudente 8 EUR per lotto. I tre numeri sono **ipotesi mie**, NON VERIFICATE sul broker: coprono la differenza fra la commissione FTMO forex (2,50 USD a lato, circa 4,6 EUR a giro) e quella gia contenuta nel tester BCM (misurata nei report: 2,3-3,8 EUR per lotto a giro) piu lo slippage. I lotti sono la somma dei lotti delle aperture.
**Regola scritta prima.** REGGE se nello scenario centrale il netto totale resta >= 75% di quello del tester **e** nessun anno cambia segno; FRAGILE se < 60% oppure 3 o piu anni cambiano segno; altrimenti ZONA GRIGIA.

| Set | Netto tester (12 anni) | Dopo costi: ott / **centrale** / prud | Anni che cambiano segno (ott/centr/prud) | Esito (scenario centrale) |
|---|---|---|---|---|
| Daytrade Pro Max9 | 7.449 | 98% / **96%** / 92% | 0/0/0 | **REGGE** |
| Daytrade Pro Max20 | 13.771 | 98% / **96%** / 92% | 0/0/0 | **REGGE** |
| Daytrade Pro Max50 | 40.774 | 97% / **96%** / 92% | 0/0/1 | REGGE (ma e in zona grigia per il DD) |
| Stability Pro low | 10.706 | 95% / **91%** / 83% | 0/0/0 | **REGGE** |
| Apex Conservative | 8.573 | 89% / **82%** / 64% | 0/**1**/2 | **ZONA GRIGIA** (82% ma un anno cambia segno; prudente 64%) |
| Apex Ultra | 7.364 | 80% / **69%** / 37% | 1/1/1 | **ZONA GRIGIA** (FRAGILE nello scenario prudente) |
| **Luna 4DD** | 5.667 | 80% / **68%** / **35%** | 0/**1**/1 | **ZONA GRIGIA** (FRAGILE nello scenario prudente: dimezza) |

**Perche.** Luna e Apex aprono tanti lotti per euro di guadagno: Luna 458 lotti per 5.667 EUR (12 EUR per lotto), Apex Conservative 389 per 8.573 (22 EUR), Apex Ultra 577 per 7.364 (13 EUR), contro 70 lotti per 7.449 del Daytrade Pro Max9 (106 EUR per lotto). Con 4 EUR per lotto di costo extra il Daytrade Pro non se ne accorge, Luna ci perde un terzo.
**Il rapporto vale a qualunque taglia**, perche profitto e costi scalano entrambi con i lotti; ma a 4k il lotto minimo non scala (vedi il 61-75% di aperture a 0,01 del Max9).

## E2: correlazione dei profitti giornalieri realizzati
Correlazione di Pearson sui giorni lavorativi di ogni anno, media sugli anni in comune.
| | DTP Max20 | DTP Max50 | Stab low | Luna 4DD | Apex Cons | Apex Ultra |
|---|---|---|---|---|---|---|
| DTP Max9 | **0,96** | **0,96** | -0,01 | 0,01 | 0,02 | 0,01 |
| DTP Max20 | | **0,99** | 0,00 | 0,01 | 0,02 | 0,01 |
| DTP Max50 | | | -0,01 | 0,02 | 0,01 | 0,01 |
| Stab low | | | | 0,01 | **0,25** | 0,24 |
| Luna 4DD | | | | | 0,03 | 0,02 |
| Apex Cons | | | | | | **0,97** |

**Con il trio oro** (Reaper + Phantom + Goldbot, livello Prop, 80k) negli anni in comune 2013, 2020, 2025: DTP Max9 **0,18**, Max20 0,13, Max50 0,15, Stability -0,03, Luna -0,03, Apex Cons 0,02, Apex Ultra 0,03.

**Letture.**
- Set dello stesso EA sono **la stessa strategia a lotti diversi** (0,96-0,99): non diversificano fra loro, e due conti con DTP Max9 e Max20 sarebbero quasi lo stesso rischio.
- Tutti i forex sono **quasi scorrelati dall'oro** (<= 0,2) e fra loro (<= 0,25): come diversificatori del trio funzionano tutti, il Daytrade Pro il piu legato (0,18).
- Il numero e sui profitti **realizzati** giorno per giorno: non misura le perdite flottanti insieme.

## Previsioni F-E contro i risultati
| # | Previsione | Esito |
|---|---|---|
| E1a | DTP Max9 REGGE (>= 75%): 65% | **Vero** (96%) |
| E1b | Luna 4DD FRAGILE (< 60%) nello scenario centrale: 35% | **Falso** (68%): ma nello scenario prudente scende a 35% |
| E1c | Stability low REGGE: 55% | **Vero** (91%) |
| E1d | Apex Cons REGGE: 70% | **Falso**: 82% del netto ma un anno cambia segno, quindi ZONA GRIGIA per la regola scritta |
| E2a | DTP Max9 contro il trio oro |corr| < 0,3: 70% | **Vero** (0,18) |
| E2b | Apex Cons contro Apex Ultra corr > 0,8: 90% | **Vero** (0,97) |
| E2c | Luna 4DD contro DTP Max9 |corr| < 0,3: 70% | **Vero** (0,01) |

## Effetto sul cancello (voce F-E: fatta)
- **Daytrade Pro Max9/Max20 e Stability Pro low**: costi e correlazione OK. Con il fuori campione e la tenuta ai tick (Stability ROBUSTO, DTP sensibile ma piccolo), Stability low e il candidato forex piu pulito; il Daytrade Pro Max9 resta "con limiti" (2025 debole, sensibile ai tick).
- **Apex Conservative e Ultra e Luna 4DD**: costi in zona grigia, fragili se lo slippage e prudente; Luna anche SENSIBILE ai tick. Restano "TESTATO CON LIMITI".
- Limiti: costi extra per lotto = ipotesi; le perdite flottanti non sono nella correlazione; i valori vengono da 12 anni a barre (il tick vale solo 2025).
