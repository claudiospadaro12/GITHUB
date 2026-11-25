# Fibo H4 e Media 200 sui cross forex: risultati (25/11/2026)

Criteri: `FIBO_H4_MEDIA200_CRITERI_2026-11-25.md`. Simulatore: `backtest_runner/simulatore/fibo_ema200_fx.py` (H1 BCM, 10 coppie, 2005-2026). R = pip / distanza SL, pesi 1/3 e 2/3.

| strategia / variante | periodo | setup | PF (R) | % vincenti | R medio | R/anno |
|---|---|---|---|---|---|---|
| Media 200 PRIMARIA (50 pip, 2 ATR, filtro pendenza) | IS 2005-2015 | 976 | 0.87 | 56 | -0.04 | -3.7 |
| Media 200 PRIMARIA (50 pip, 2 ATR, filtro pendenza) | OOS 2016-2021 | 406 | 0.64 | 50 | -0.12 | -7.8 |
| Media 200 PRIMARIA (50 pip, 2 ATR, filtro pendenza) | HO 2022-2026 | 323 | 1.18 | 62 | 0.05 | 3.2 |
| SL 1 ATR | IS 2005-2015 | 976 | 0.89 | 46 | -0.05 | -4.1 |
| SL 1 ATR | OOS 2016-2021 | 406 | 0.63 | 43 | -0.16 | -10.9 |
| SL 1 ATR | HO 2022-2026 | 323 | 1.36 | 53 | 0.14 | 8.8 |
| distanza 70 pip | IS 2005-2015 | 580 | 0.91 | 54 | -0.03 | -1.5 |
| distanza 70 pip | OOS 2016-2021 | 198 | 0.58 | 49 | -0.14 | -4.6 |
| distanza 70 pip | HO 2022-2026 | 182 | 1.35 | 63 | 0.10 | 3.6 |
| senza filtro pendenza | IS 2005-2015 | 1006 | 0.87 | 57 | -0.04 | -3.7 |
| senza filtro pendenza | OOS 2016-2021 | 422 | 0.63 | 51 | -0.12 | -8.2 |
| senza filtro pendenza | HO 2022-2026 | 340 | 1.15 | 63 | 0.04 | 2.8 |
| Fibo H4 PRIMARIA (50 pip, SL 1:1) | IS 2005-2015 | 514 | 0.74 | 50 | -0.12 | -5.8 |
| Fibo H4 PRIMARIA (50 pip, SL 1:1) | OOS 2016-2021 | 211 | 0.60 | 45 | -0.21 | -7.2 |
| Fibo H4 PRIMARIA (50 pip, SL 1:1) | HO 2022-2026 | 173 | 1.03 | 55 | 0.01 | 0.4 |
| SL al livello 4,236 | IS 2005-2015 | 514 | 0.70 | 68 | -0.08 | -3.8 |
| SL al livello 4,236 | OOS 2016-2021 | 211 | 0.58 | 61 | -0.12 | -4.3 |
| SL al livello 4,236 | HO 2022-2026 | 173 | 1.33 | 77 | 0.06 | 2.0 |
| distanza 35 pip | IS 2005-2015 | 742 | 0.75 | 50 | -0.12 | -8.2 |
| distanza 35 pip | OOS 2016-2021 | 358 | 0.65 | 49 | -0.17 | -10.1 |
| distanza 35 pip | HO 2022-2026 | 276 | 0.88 | 53 | -0.05 | -2.9 |

PF(R) per coppia, sistema primario, tutto il periodo (descrittivo):
  EMA: EURUSD 1.23 (n=192), USDJPY 0.75 (n=121), GBPUSD 0.80 (n=291), AUDUSD 0.71 (n=90), EURGBP 0.75 (n=93), USDCAD 0.82 (n=183), USDCHF 0.77 (n=165), NZDUSD 0.97 (n=95), EURJPY 0.86 (n=199), GBPJPY 0.91 (n=276)
  FIBO: EURUSD 0.81 (n=101), USDJPY 1.18 (n=82), GBPUSD 0.49 (n=133), AUDUSD 0.89 (n=64), EURGBP 0.39 (n=58), USDCAD 0.75 (n=91), USDCHF 0.89 (n=51), NZDUSD 0.92 (n=36), EURJPY 0.99 (n=121), GBPJPY 0.69 (n=161)

VERDETTO (soglie dei criteri):
- Media 200 PRIMARIA (50 pip, 2 ATR, filtro pendenza): IS 0.87 (n=976), OOS 0.64 (n=406), HO 1.18 (n=323) -> non passa
- SL 1 ATR: IS 0.89 (n=976), OOS 0.63 (n=406), HO 1.36 (n=323) -> non passa
- distanza 70 pip: IS 0.91 (n=580), OOS 0.58 (n=198), HO 1.35 (n=182) -> non passa
- senza filtro pendenza: IS 0.87 (n=1006), OOS 0.63 (n=422), HO 1.15 (n=340) -> non passa
- Fibo H4 PRIMARIA (50 pip, SL 1:1): IS 0.74 (n=514), OOS 0.60 (n=211), HO 1.03 (n=173) -> non passa
- SL al livello 4,236: IS 0.70 (n=514), OOS 0.58 (n=211), HO 1.33 (n=173) -> non passa
- distanza 35 pip: IS 0.75 (n=742), OOS 0.65 (n=358), HO 0.88 (n=276) -> non passa

## Lettura
**0 candidate su 2 strategie (7 celle).** Entrambe in perdita in campione e fuori campione: Media 200 PF 0,87 / 0,64, Fibo H4 PF 0,74 / 0,60. Previsione (nessuna candidata, PF 0,85-1,10) confermata sul verdetto; le cifre fuori campione sono peggiori del previsto.
- Il 2022-2026 e' sopra 1 in 6 celle su 7 (PF 1,03-1,36, 173-323 setup), ma i 17 anni precedenti sono negativi in tutte le varianti: e' un regime recente (mercati laterali/ritracciamenti) e non una conferma. Un solo periodo favorevole non basta.
- Per coppia (primario) solo EURUSD per la Media 200 (PF 1,23, n=192) e USDJPY per Fibo (1,18, n=82) sono sopra 1: con 10 coppie e 2 strategie sono prevedibili per caso.
- **Limiti:** H1 (non tick) per i fill; traduzione meccanica di regole semi-discrezionali (nessun livello tecnico a occhio, nessun "spike nella prima mezz'ora", nessun filtro news); spread fisso; SL/TP nella stessa barra: SL prima. Il risultato vale per la traduzione meccanica, non dice che l'occhio di Claudio non aggiunga valore: per misurarlo servono i casi presi a mano nel diario.
- **Conclusione:** Fibo H4 e Media 200 forex CHIUSI come EA meccanici. Restano strumenti per il lavoro discrezionale con il diario (30-50 casi, PF > 1,3 su 100 operazioni come obiettivo del suo piano).
