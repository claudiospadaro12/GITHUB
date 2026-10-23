# R285 -- Dow, scomposizione del Piano A di ORB_Emiliano v1.01 (23/10/2026)
Fonte: `ROUND_R285_2026-10-23.zip` (pin 325f30ff, motore = pin SHA256, 5 round rc 0, compila 0 errori/0 avvisi). Lettore congelato `r285_giudizio.py`: **G0a OK (R285a = R283d al centesimo), G0b OK (R285e = R284d al centesimo)**. Per-trade: 5 su 10 (mancano le gemelle g2; non servono alla lettura).

| Braccio | IS: profit, PF, DD, op. | OOS: profit, PF, DD, op. | dPF IS / OOS vs R285a | Verdetto |
|---|---|---|---|---|
| a riferimento (=R283d) | -14277, 0,777, 23,9%, 249 | 11944, 1,110, 16,0%, 406 | - | - |
| b senza sospensione trailing | -8158, 0,854, 19,6%, 241 | 6054, 1,058, 16,3%, 394 | +0,077 / -0,052 | MISTO |
| c senza parziale | -11317, 0,827, 21,8%, 169 | 21868, 1,194, 16,3%, 264 | +0,050 / +0,084 | NON DISTINGUIBILE (sotto 0,10) |
| d senza pareggio | -14587, 0,777, 24,0%, 249 | 17783, 1,146, 17,2%, 406 | +0,000 / +0,037 | NON DISTINGUIBILE |
| e Piano A spento (=R284d) | -4751, 0,921, 20,4%, 169 | 26546, 1,198, 18,6%, 264 | +0,144 / +0,088 | (R284d) |

Lettura: nessun pezzo del Piano A e' distinguibile con la soglia congelata 0,10. Il pezzo piu' vicino a pesare e' il parziale (c: +0,05 / +0,08), ma resta sotto soglia; il pareggio da solo non muove il PF in IS (0,000). Nel Dow il segno IS negativo / OOS positivo c'e' in tutti i bracci (P8 70%: confermata). Attese: P1 si', P2 si', P3 si', P4 NO (b e' misto), P5 NO (c sotto soglia), P6 NO, P7 NO (nessuno distinguibile), P8 si'. Non promuove niente; un solo regime; soglia non calibrata sul rumore.
