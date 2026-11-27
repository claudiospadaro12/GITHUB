# Triage STEP 1 - gz_trades.csv

| cella | n | PF | win | R medio |
|---|---|---|---|---|
| baseline tutti | 381 | 1.52 | 45% | +0.160 |
| baseline IS | 229 | 1.35 | 48% | +0.100 |
| baseline OOS | 152 | 1.74 | 40% | +0.249 |
| lordo PF 1.80, costo medio 0.066R, lordo medio +0.226R | | | | |
| long tutti / IS / OOS | 381 | 1.52 | 45% | +0.160 / 229 | 1.35 | 48% | +0.100 / 152 | 1.74 | 40% | +0.249 |
| short tutti / IS / OOS | 0 | - | - | - / 0 | - | - | - / 0 | - | - | - |
| tag GZ tutti / IS / OOS | 381 | 1.52 | 45% | +0.160 / 229 | 1.35 | 48% | +0.100 / 152 | 1.74 | 40% | +0.249 |

Ore tossiche (PF < soglia, n sufficiente): nessuna

Costi: {"lordo_medio_R": 0.22591280035475275, "costo_medio_R": 0.06621237458651291, "incidenza": 0.2930881936859667, "pf_lordo": 1.7982901877858883, "pf_netto": 1.519636704019368, "pf_invertito_netto": 0.4716051925334451, "test_inversione_indicato": false, "inversione_sospetta": false}

MAE/MFE: {"mfe_vincenti": {"p25": 1.3072155937812653, "p50": 1.7469426367024776, "p75": 2.400988302503144, "p90": 3.595980822615022}, "mfe_perdenti": {"p25": 0.1704329451673477, "p50": 0.3601918055138588, "p75": 0.6364284396231007, "p90": 0.8802831273408925}, "mae_vincenti": {"p25": 0.08531742899314004, "p50": 0.18254675930533043, "p75": 0.3511024303141303, "p90": 0.6037405412200127}, "mae_perdenti": {"p25": 0.5067040716391102, "p50": 0.7542053817317083, "p75": 0.9842040788304868, "p90": 1.1871221882103578}, "perdenti_con_mfe_ge_1R": 0.03317535545023697, "vincenti_con_mae_ge_0.7R": 0.07058823529411765}

Volatilita (terzili ATR): bassa: 127 | 1.83 | 40% | +0.271; media: 127 | 1.54 | 53% | +0.140; alta: 127 | 1.20 | 41% | +0.068
