# BULGE_MULTI_SIGNAL (Excel di Claudio, aprile 2026): analisi dei due report del tester (19/11/2026)

Fonte: `BULGE MULTI SIGNAL CLAUDIO 1%.xlsx` e `... 3%.xlsx` (Strategy Tester, BCM, chart GBPUSD H1, cestino GBPJPY/NZDJPY/AUDUSD/CADJPY/NZDCAD, 2022-01-01 -> 2026-03-30, 10.000 USD, qualita storico **40% tick reali**, Risk_Percent 1 e 3, Max_Trades 10, segnali BLU+VIOLA, ARANCIO spento, TP = mediana, SL 3 ATR). Curva: `BULGE_MULTI_CURVA_2026-11-19.png`.

| | Rischio 1% | Rischio 3% |
|---|---|---|
| Netto | +2.806,78 (+28%) | +10.604 (+106%) |
| PF | 1,60 | 1,60 |
| Operazioni | 268 | 268 |
| DD equity / saldo | 4,76% / 4,34% | 14,24% / 13,08% |
| Peggior giorno (saldo di partenza) | -302 (-3,0%) | -984 (-9,8%) |
| Vincenti | 79,7%; media vinta 34,9 / media persa -80,8; pareggio 69,8% | idem |

**Per anno (1%, netto per anno di chiusura; operazioni):** 2022 +23 (5); 2023 +274 (13); 2024 -194 (66); 2025 +1.928 (153); 2026 (fino a marzo) +775 (31). **Il 2025 vale il 69% del profitto (65% a 3%); 2022-2024 sono piatti (+103 in tre anni).**
**Operazioni per trimestre:** 1-3 nel 2022, 5 nel 2023, poi 7, 10, 17, 32 (2024) e 34-41 a trimestre dal 2025. AUDUSD ha 2 operazioni nel 2024 e nessuna prima; GBPJPY 9 nel 2024 e nessuna prima; CADJPY 4 e nessuna prima.
**Per simbolo (1%):** NZDJPY +936 (80), GBPJPY +515 (52), CADJPY +516 (28), AUDUSD +447 (43), NZDCAD +393 (65). **Per segnale:** BLU_L +1.696 (PF 1,73), BLU_S +825 (PF 1,48), VIOLA_L +630 (16), VIOLA_S -108 (6). **Direzione:** long PF 2,01 (86% vinte), short PF 1,35 (70%).
**Uscite:** 227 take profit (+7.365), 39 stop (-4.322; media -110,8). La forma e quella dichiarata nel sorgente: alto win rate, target corto, stop 3 ATR.

## Letture e cautele
1. **La curva e concentrata:** piatta fino a fine 2024, poi sale quasi tutta in 15 mesi (dic 2024 - mar 2026), con caduta finale a marzo 2026. Non e una crescita regolare su 4 anni.
2. **Il margine sul pareggio e di 10 punti** (79,7% vinte contro 69,8% di pareggio). Sul demo reale (699 operazioni 30/03-18/11/2026, `BULGE_ANALISI_FORWARD`): vincenti 69%, PF 0,76 in EUR, R medio -0,033. **Il backtest (PF 1,60) e il demo (PF 0,76) non coincidono.**
3. **Il cestino GBPJPY/NZDJPY/AUDUSD/CADJPY/NZDCAD non e quello che regge dal vivo:** nell'analisi del demo GBPJPY e NZDJPY sono tra i cross peggiori; la persistenza per cross tra periodi e quasi rumore (rho 0,28). Con ogni probabilita il cestino e stato scelto guardando lo stesso periodo.
4. **Difetto noto del motore (sorgente `ABTG_Bulge_S.mq5`, punto 13, R92):** fino alla v5.10 il segnale si leggeva sulla barra in formazione (close==open al primo tick); sui simboli non del grafico (qui tutti e 5: il grafico e GBPUSD) il segnale vedeva gia un corpo "in ritardo": rumore d'implementazione, non una regola. **Ipotesi (non verificata): questi due Excel vengono dalla versione precedente alla correzione** (magic 20250001, aprile). Per verificarla: rifare la stessa prova con il motore corretto.
5. **A 3% il DD equity e 14,2% e il peggior giorno -9,8%:** oltre i muri FTMO (10% totale, 5% giornaliero) anche solo sul periodo del test. Il 1% ha peggior giorno -3,0% (60% del muro giornaliero).
6. **Qualita 40% tick reali:** la parte restante e sintetica; con target di pochi pip lo spread e la sequenza dei tick pesano molto.
