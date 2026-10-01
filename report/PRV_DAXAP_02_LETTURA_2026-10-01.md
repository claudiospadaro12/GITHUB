# PRV_DAXAP_02 (InpCloseHour 11/13/15/17 sulla 770101 LONG, D30EUR M5, tick reali): lettura del 01/10/2026 sera
Fonte: `backtest_pipeline/risultati_archivio/ROUND_DAXAP02_20261001_2244/` (PC di backtest DESKTOP-H4D7CAJ, 151 s, 2 gambe su 2 partite, STATO=OK: motore e prova = pin, referto = riga, asse e pin arrivati, finestre dichiarate). Criteri letti dal file prova al pin `cc49a21e`, scritti PRIMA dei numeri.

| cella | IS Trades / Profit / PF / DD% | OOS Trades / Profit / PF / DD% |
|---|---|---|
| 11 | 150 / 2.678,69 / 1,09975 / 4,0755 | 220 / 13.107,51 / 1,35406 / 4,5115 |
| 13 | 163 / 3.416,06 / 1,11849 / 4,3854 | 236 / 11.830,38 / 1,29262 / 4,4788 |
| 15 | 171 / 3.196,27 / 1,10555 / 5,9173 | 257 / 15.907,16 / 1,36956 / 5,7417 |
| **17 (controllo)** | 175 / 3.789,36 / 1,12634 / 5,4362 | 270 / 18.029,58 / 1,39709 / 7,2328 |

## Applicazione delle regole (nessuna soglia cambiata)
- **G0 (la cella 17 deve ridare R47a/R246e/R270c)**: IS 175 / 3.789,36 / 1,12634 / 5,4362 e OOS 270 / 18.029,58 / 1,39709 / 7,2328: **identica al centesimo. PASSA.** Il banco e' valido.
- **S1 (la manopola morde)**: Trades OOS cella 11 = 220 < 270 e Profit(11) != Profit(17) al centesimo in tutte e due le gambe: **PASSA** (pin arrivato). **S1m** (Trades OOS non decresce al crescere dell'ora): 220 <= 236 <= 257 <= 270 **PASSA**.
- **M1 (PF OOS >= 1,497)**: nessuna cella (max 1,397, il controllo): **nessuna candidata**. Concordanza IS/OOS: nessuna cella batte il controllo ne' in IS ne' in OOS: concordi nel nulla.
- **R1 (DD > 9%)**: massimo 7,2328: **non violato**.
- **A5 (tutte le celle entro il 10,5% relativo del PF OOS di controllo, 1,250-1,544)**: OOS 1,354 / 1,293 / 1,370 / 1,397: **tutte dentro** -> **"manopola inerte, il default va bene"**, che e' un RISULTATO (A5), non una bocciatura.
- **Le due ipotesi scritte prima**: H-RUNNER prevedeva cella 11 PF OOS <= 1,257 (osservato 1,354) e cella 13 <= 1,32 (osservato 1,293): **meta' non tiene**. H-LATEFADE prevedeva cella 13 o 15 con PF >= 1,397 in tutte e due le gambe (osservato 13: IS 1,118 / OOS 1,293; 15: IS 1,106 / OOS 1,370): **non tiene**. Vince la previsione complessiva dichiarata, "il default va bene".

## Cosa NON dice (dichiarato nel file prova e qui)
- Nessuna promozione, nessuna taglia, nessuna modifica a preset o sedie (A10). Il flat piu' presto riduce il DD (OOS 4,51 contro 7,23; IS 4,08 contro 5,44) e riduce anche il profitto (13.108 contro 18.030, -27%): e' un'**osservazione**, non un criterio; M1 non e' soddisfatta, quindi nessuna cella si candida.
- IS sottile (132 posizioni dichiarate nel file, sotto le 150), **un solo regime** (rialzo; il crollo dei dazi di aprile 2025 sta nella gamba IS), finestra che mescola le due tempistiche (estate/inverno) come l'ancora.
- La cella che ha scritto il per-trade non e' identificabile (classe 455): informativo.
- Windows PowerShell 5.1 e MT5 sono quelli di quel PC; il guasto del tester non ha colpito questo job (0 avvisi `OnTesterInit works too long`).
