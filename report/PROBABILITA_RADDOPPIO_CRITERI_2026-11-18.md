# Probabilita storica di raddoppiare prima di perdere il 50% (finestre mobili) — criteri e previsioni scritti PRIMA dei numeri (18/11/2026)
Dati: profitto REALIZZATO per giorno dei report archiviati dei test a 4.000 EUR (Stability low/mediumlow, Daytrade Pro Max9/20/50, Luna 4DD/lowrisk, Apex Conservative/Elevated; anni 2013, 2017, 2020, 2022, 2025) e del trio oro a 3.745 EUR (21 mesi), esportati da `ESPORTA_SERIE_GIORNALIERE.ps1`. Solo analisi di risultati gia misurati; nessun consiglio su lotti/taglie.
## Metodo (nessuna soglia ritoccabile)
- Per ogni serie e ogni giorno di partenza s: cumulata del profitto realizzato da s in avanti, in % del deposito iniziale (4.000 / 3.745), senza ricomposizione. Eventi: **RADDOPPIO** = +100%, **STOP** = -50%. Finestra massima: fino a fine serie (un anno; 21 mesi per l'oro).
- Esiti per partenza: raddoppio prima dello stop / stop prima del raddoppio / nessuno dei due entro la fine. **P(raddoppio)** = quota di partenze con raddoppio prima dello stop sul totale (le partenze troppo vicine alla fine della serie contano come "nessuno dei due", cioe sfavoriscono il raddoppio: si riporta anche la quota calcolata solo sulle partenze con almeno 180 giorni davanti). Mediana dei giorni al raddoppio.
- Limiti dichiarati: solo profitti realizzati (il flottante puo toccare -50% prima: **la P(stop) e una stima per difetto**); un percorso per anno, anni non contigui (finestre dentro l'anno); depositi 4.000/3.745 non 2.000.
## Previsioni
- Set prudenti (Stability low, Daytrade Max9, Luna 4DD): P(raddoppio) < 5% in ogni anno: **80%**.
- Almeno un set ad alto rischio (Daytrade Max50, Apex Elevated, Luna lowrisk, Stability mediumlow) con P(raddoppio) >= 30% in almeno un anno: **75%**; ma stesso set con P(stop) >= 10% in almeno un altro anno: **55%**.
- Trio oro L2 (21 mesi): P(raddoppio) >= 60%: **80%**.

## Risultato (18/11/2026; serie giornaliere realizzate da 70 runs forex a 4.000 EUR e 21 runs oro R21; `PROBABILITA_RADDOPPIO_dati/`; script `backtest_runner/simulatore/prob_raddoppio.py`)
Eventi: +100% del deposito prima di -50% (profitto realizzato cumulato, senza ricomposizione), partenza ogni giorno di calendario dell'anno (forex) o del periodo 01/2025-10/2026 (oro, trio = somma dei tre EA).

| Set | Partenze | Raddoppio prima dello stop | Stop prima | Nessuno dei due | Raddoppio (solo partenze con >=180 gg davanti) | Giorni mediani al raddoppio |
|---|---|---|---|---|---|---|
| APEX_ApexConservativeGrid | 1826 | 0% | 0% | 100% | 0% | - |
| APEX_ApexElevatedGrid | 1826 | 0% | 0% | 100% | 0% | - |
| APEX_ApexUltraConservativeGrid | 1826 | 0% | 0% | 100% | 0% | - |
| APEX_Apexextremerisk | 1826 | 42% | 19% | 38% | 55% | 67.0 |
| APEX_Apexhighriskliveaccount | 1826 | 8% | 11% | 81% | 15% | 41 |
| DTP_DaytradeProMax20DDmediumrisk | 1826 | 0% | 0% | 100% | 0% | - |
| DTP_DaytradeProMax50DDhighrisk | 1826 | 17% | 0% | 83% | 31% | 201 |
| DTP_DaytradeProMax9DDlowrisk | 1826 | 0% | 0% | 100% | 0% | - |
| LUNA_Luna4DD | 1826 | 0% | 0% | 100% | 0% | - |
| LUNA_LunaAIrecommended | 1826 | 52% | 4% | 44% | 60% | 85.0 |
| LUNA_LunaAIrecommendedlowrisk | 1826 | 0% | 0% | 100% | 0% | - |
| STAB_stabilityprohighriskset | 1826 | 39% | 8% | 53% | 54% | 113.0 |
| STAB_stabilityprolowriskset | 1826 | 0% | 0% | 100% | 0% | - |
| STAB_stabilitypromediumlowriskset | 1826 | 11% | 0% | 89% | 20% | 199.0 |
| TRIO_ORO_M1_L0 | 639 | 59% | 0% | 41% | 82% | 270 |
| TRIO_ORO_M1_L1 | 639 | 84% | 0% | 16% | 100% | 162.5 |
| TRIO_ORO_M1_L2 | 639 | 100% | 0% | 0% | 100% | 84.0 |
| TRIO_ORO_M1_L3 | 639 | 54% | 0% | 46% | 75% | 353.0 |
| TRIO_ORO_M4_L1 | 639 | 76% | 0% | 24% | 100% | 191.0 |
| TRIO_ORO_M4_L2 | 639 | 97% | 0% | 3% | 100% | 103.0 |
| TRIO_ORO_M4_L3 | 639 | 42% | 0% | 58% | 58% | 396.5 |

Per anno (raddoppio / stop, tutte le partenze):
APEX_ApexConservativeGrid 2013:0%/0% 2017:0%/0% 2020:0%/0% 2022:0%/0% 2025:0%/0%
APEX_ApexElevatedGrid 2013:0%/0% 2017:0%/0% 2020:0%/0% 2022:0%/0% 2025:0%/0%
APEX_ApexUltraConservativeGrid 2013:0%/0% 2017:0%/0% 2020:0%/0% 2022:0%/0% 2025:0%/0%
APEX_Apexextremerisk 2013:15%/30% 2017:23%/30% 2020:88%/7% 2022:86%/5% 2025:0%/26%
APEX_Apexhighriskliveaccount 2013:10%/10% 2017:0%/8% 2020:23%/1% 2022:0%/18% 2025:7%/19%
DTP_DaytradeProMax20DDmediumrisk 2013:0%/0% 2017:0%/0% 2020:0%/0% 2022:0%/0% 2025:0%/0%
DTP_DaytradeProMax50DDhighrisk 2013:0%/0% 2017:17%/0% 2020:40%/0% 2022:28%/0% 2025:0%/0%
DTP_DaytradeProMax9DDlowrisk 2013:0%/0% 2017:0%/0% 2020:0%/0% 2022:0%/0% 2025:0%/0%
LUNA_Luna4DD 2013:0%/0% 2017:0%/0% 2020:0%/0% 2022:0%/0% 2025:0%/0%
LUNA_LunaAIrecommended 2013:0%/12% 2017:0%/2% 2020:82%/5% 2022:91%/0% 2025:86%/0%
LUNA_LunaAIrecommendedlowrisk 2013:0%/0% 2017:0%/0% 2020:0%/0% 2022:0%/0% 2025:0%/0%
STAB_stabilityprohighriskset 2013:92%/0% 2017:0%/14% 2020:37%/0% 2022:67%/0% 2025:0%/26%
STAB_stabilityprolowriskset 2013:0%/0% 2017:0%/0% 2020:0%/0% 2022:0%/0% 2025:0%/0%
STAB_stabilitypromediumlowriskset 2013:53%/0% 2017:0%/0% 2020:0%/0% 2022:0%/0% 2025:0%/0%

**Previsioni:** set prudenti (Stability low, Daytrade Max9, Luna 4DD) con < 5% in ogni anno (80%) -> **vero (0% in tutti)**. Almeno un set ad alto rischio >= 30% in un anno (75%) -> **vero** (Apex extreme 88% nel 2020, Luna recommended 91% nel 2022, Stability highrisk 92% nel 2013, Daytrade Max50 40% nel 2020); lo stesso set con P(stop) >= 10% in un altro anno (55%) -> **vero** (Apex extreme 30% nel 2013, Stability highrisk 14% nel 2017, Luna recommended 12% nel 2013). Trio oro L2 >= 60% (80%) -> **vero** (100% a barre, 97% a tick).
**Lettura onesta:**
- **I set prudenti non raddoppiano mai in un anno** (Stability low, Daytrade Max9/Max20, Luna 4DD, Apex Conservative/Ultra, Luna lowrisk: 0%). Raddoppiano solo i set ad alto rischio, quelli con DD equity 40-90% nei test a 4k (scartati o in zona grigia).
- **Lo stop a -50% e una stima per difetto** (solo profitti realizzati): Stability highrisk ha DD equity 63-82% in tre anni ma mostra "stop prima" solo 8%.
- **Un anno e favorevole o no, non l'EA:** gli stessi set raddoppiano nel 80-92% delle partenze in un anno e in 0% in un altro (Luna recommended: 0% nel 2013/2017, 82-91% nel 2020/2022/2025).
- **Trio oro:** raddoppia nel 54-59% delle partenze ai livelli prudenti (L3, L0; mediana 270-350 giorni), nel 76-84% a L1 e quasi sempre a L2 (mediana 84-103 giorni), in un periodo di oro in forte rialzo, con DD limite oltre il 160% di 2.000 EUR al livello L2 (vedi `SIMULAZIONE_3_CONTI_2K_2026-11-18.md`). **Un periodo solo, non ripetibile.**
- **Limiti:** serie a 4.000/3.745 EUR (non 2.000); i lotti dipendono dal saldo (le partenze a meta anno partono da un saldo diverso da quello di test); un percorso per anno; anni non contigui.
