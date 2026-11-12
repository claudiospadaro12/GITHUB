# Simulazione: 2 giorni a livello Prop, poi alzare il rischio fino al +10% della challenge (12/11/2026)

**Natura: SIMULAZIONE sui dati del tester** (equity con flottante ricostruito dalle barre M1; solo la parte ORO dei portafogli P1/P3/P4, Daytrade Pro ESCLUSO perche non ricostruibile). Anni 2013/2018/2020/2025, partenza da OGNI giorno di trading (1.221 partenze per portafoglio; partenze dello stesso anno NON sono indipendenti). Regole FTMO usate: fallisce se in un giorno l'equity scende >=5% dall'equity di inizio giorno o se scende >=10% dal saldo iniziale; passa se il saldo chiuso arriva a +10% (e almeno 2 giorni). Nessun limite di tempo. Non risolto = l'anno finisce prima (censurato).
Script: sessione, non salvato come file (usa `equity_livelli.py` + simulazione per giorni); i numeri qui sono quelli della sessione.

| Portafoglio oro | Strategia | Passa | Fallisce | Non risolto | Giorni mediani per passare |
|---|---|---|---|---|---|
| P1 (Phantom G1 + Goldbot Prop) | solo Prop | 69% | 0% | 31% | 77 |
| | 2 gg Prop poi Medium (L2) | 49% | 48% | 3% | 14 |
| | Medium dal giorno 1 | 48% | 49% | 3% | 12 |
| | 2 gg Prop poi L1 (Goldbot L1) | 72% | 8% | 20% | 55 |
| P3 (Goldbot Combo + GTP Combo) | solo Prop | 65% | 0% | 35% | 113 |
| | 2 gg Prop poi Medium | 48% | 49% | 3% | 18 |
| | 2 gg Prop poi L1 | 71% | 8% | 21% | 64 |
| P4 (Reaper Combo + Goldbot Prop) | solo Prop | 60% | 0% | 40% | 117 |
| | 2 gg Prop poi Medium | 32% | 66% | 2% | 8 |
| | 2 gg Prop poi L1 (Reaper L1, Goldbot L1) | 66% | 26% | 8% | 31 |

Lettura: passare al Medium dopo 2 giorni e una moneta (circa 48% passa, 48% fallisce; P4 con Reaper 66% fallisce), non "sfortuna": il DD subito arriva in circa meta delle partenze. Con il livello intermedio L1 il rischio di fallire scende all'8% (P1/P3) e il tempo mediano a 55-64 giorni.
Limiti: Daytrade Pro escluso (nei conti reali c'e); un percorso per anno; lo switch di livello con ordini aperti non e simulato; costi/spread FTMO non simulati; il Medium usa i set L2 del tester, non necessariamente identici ai tuoi del trial.
