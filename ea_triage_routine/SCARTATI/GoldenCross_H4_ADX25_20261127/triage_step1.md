# Triage STEP 1 - gc_h4_trades.csv

| cella | n | PF | win | R medio |
|---|---|---|---|---|
| baseline tutti | 953 | 1.14 | 46% | +0.063 |
| baseline IS | 572 | 1.31 | 48% | +0.133 |
| baseline OOS | 381 | 0.91 | 41% | -0.042 |
| lordo PF 1.21, costo medio 0.030R, lordo medio +0.093R | | | | |
| long tutti / IS / OOS | 416 | 1.06 | 44% | +0.029 / 246 | 1.38 | 49% | +0.159 / 170 | 0.71 | 35% | -0.159 |
| short tutti / IS / OOS | 537 | 1.20 | 47% | +0.089 / 326 | 1.26 | 48% | +0.114 / 211 | 1.12 | 46% | +0.052 |
| tag A tutti / IS / OOS | 953 | 1.14 | 46% | +0.063 / 572 | 1.31 | 48% | +0.133 / 381 | 0.91 | 41% | -0.042 |

Ore tossiche (PF < soglia, n sufficiente): nessuna

Costi: {"lordo_medio_R": 0.0929231127876638, "costo_medio_R": 0.0300407659691058, "incidenza": 0.32328626396482407, "pf_lordo": 1.212303591580706, "pf_netto": 1.1385296541965262, "pf_invertito_netto": 0.774280335616438, "test_inversione_indicato": false, "inversione_sospetta": false}

MAE/MFE: {"mfe_vincenti": {"p25": 1.1772726661092858, "p50": 1.6444560034607938, "p75": 1.934674529263047, "p90": 2.2670054852282275}, "mfe_perdenti": {"p25": 0.13530150967104432, "p50": 0.32558139534885205, "p75": 0.6394976078306535, "p90": 0.9940390630069392}, "mae_vincenti": {"p25": 0.16897660475278034, "p50": 0.33165838992387514, "p75": 0.5808921096566659, "p90": 0.8030890891934065}, "mae_perdenti": {"p25": 0.9795432709263368, "p50": 1.1571843751539654, "p75": 1.3844090969154732, "p90": 1.711730414557335}, "perdenti_con_mfe_ge_1R": 0.09826589595375723, "vincenti_con_mae_ge_0.7R": 0.16129032258064516}

Volatilita (terzili ATR): bassa: 320 | 1.08 | 44% | +0.040; media: 313 | 1.04 | 43% | +0.021; alta: 320 | 1.33 | 50% | +0.127
