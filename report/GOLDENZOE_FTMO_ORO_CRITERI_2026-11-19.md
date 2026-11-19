# GoldenZoe H4 su XAUUSD con dati e swap FTMO - criteri scritti PRIMA dei numeri (19/11/2026)

**Domanda:** GoldenZoe (oro H4, long-only, Donchian 55, stop 3 ATR, trailing 3 ATR, rischio 1%) sul **terminale FTMO di prova** (`C:\MT5_Backtest\Mt5_Ftmo_Prova`, FTMO-Demo; login Free Trial scaduto, uso dello storico gia scaricato): numero di operazioni, PF, DD e rendimento annuo su **160.000 EUR**, con candele H4 FTMO (server = ora italiana +1) e swap FTMO (long -56,28 punti, short -4,20).
**Passate:** 3 (solo LONG, Modello 1, 160.000 EUR, leva 100): 2005-2014, 2015-2023, 2024-2026.10 (come la corsa BCM). Solo tester, AllowLiveTrading=false. Il tester usa lo swap odierno costante anche sul passato: i due periodi vecchi sono distorti (lo sappiamo dal 19/11): il giudizio e SOLO sul 2024-2026.
Tick reali FTMO non disponibili: Modello 1 (a tick reali BCM il PF differiva di 0,04 dal Modello 1).

## Previsioni (dal simulatore Python con swap FTMO -56,28 punti e dalla corsa BCM)
- 2024-2026: PF tester >= 1,4: **70%**; DD equity <= 10%: **80%**; operazioni 53-71 (BCM 62, +-15%): **75%**; rendimento 2024-26 positivo: **90%**.
- 2015-2023: PF circa 1,26 (simulatore); 2005-2014: PF <1 (swap costante distorce): **75%**.
- Candele FTMO diverse da BCM = differenze di qualche operazione: non e un difetto.

## Regole di esito
1. **Il test e valido** solo se il terminale parte con lo storico FTMO e produce 3 report. Se manca lo storico (login scaduto) lo script lo dice e non si interpreta nulla.
2. **GoldenZoe regge su FTMO** se nel 2024-2026: PF >= 1,3, DD equity <= 15%, >= 25 operazioni. Altrimenti "non confermato su FTMO".
3. Si riportano: rendimento per anno in % e in EUR su 160.000, DD equity, operazioni, swap totale (tabella da `RISULTATI_GOLDENZOE_FTMO.csv`). Nessuna taglia consigliata: il rischio e quello testato (1%).
4. Regole di rischio FTMO (perdita giornaliera/massima, giorni minimi, tenuta weekend/news) NON sono controllate da questo test: restano da leggere (mail pronta, decide Claudio).

---
## RISULTATO (19/11/2026, zip GOLDENZOE_FTMO; dati in `GOLDENZOE_FTMO_dati/`) - 160.000 EUR, solo LONG, Modello 1, terminale FTMO di prova
| Finestra | Operazioni | PF tester | Rend. totale | DD equity | Rendimento per anno |
|---|---|---|---|---|---|
| 2005-2014 | **0** | - | - | - | **nessuno storico FTMO nel terminale** |
| 2015-2023 | 90 | 1,05 | +1,63% | 13,28% | 2015 -0,55; 2016 -1,35; 2017 -2,41; 2018 +1,71; 2019 -0,59; 2020 +6,65; 2021 -7,72; 2022 -0,62; 2023 +7,08 |
| 2024-2026.10 | 60 | **1,79** | **+13,93% (+22.284 EUR)** | **4,81%** | 2024 +5,15%; 2025 +5,43%; 2026 +2,83% (parziale) |

1. **Regola 1:** test valido solo in parte: lo storico FTMO nel terminale non copre il 2005-2014 (0 operazioni). 2 finestre su 3 interpretabili.
2. **Regola 2 (2024-2026): PASSA** - PF 1,79 (>=1,3), DD 4,81% (<=15%), 60 operazioni (>=25). Previsioni: PF>=1,4 si; DD<=10% si; operazioni 53-71 si (60); rendimento positivo si. **Tutte confermate.**
3. **2015-2023: PF 1,05, DD 13,3%** (previsto ~1,26): peggio del simulatore. Lo swap FTMO in punti costante pesa di piu quando l'oro costava 1.100-2.000 (stop in dollari piu piccolo). Nove anni: +1,6% in totale; anni negativi 6 su 9.
4. **Confronto tester contro simulatore 2024-26:** 2024 +5,15 contro +8,8; 2025 +5,43 contro +7,2; 2026 +2,83 contro +2,4. Il tester FTMO rende circa il 60-75% del simulatore: la stima realistica oggi e circa +5% l'anno (circa 8.000 EUR su 160.000 al rischio 1%), non il +8%.
5. Limite: 3 anni di oro in trend; il periodo 2015-2023 mostra che puo restare piatto o negativo per anni. Regole di rischio FTMO non verificate.
