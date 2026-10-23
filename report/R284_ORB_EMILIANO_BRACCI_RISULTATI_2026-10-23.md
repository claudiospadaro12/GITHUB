# R284 -- ORB_Emiliano: bracci di controllo (23/10/2026)
Fonte: `ROUND_R284_2026-10-23.zip` (pin f02100d0, motore = pin SHA256, 5 round rc 0, catena completa, per-trade 10/10). Lettore congelato `r284_giudizio.py`, riferimento = R283c/d.

| Braccio | IS: profit, PF, DD, op. | OOS: profit, PF, DD, op. | dPF IS / OOS | Verdetto congelato |
|---|---|---|---|---|
| rif. Nasdaq (R283c) | 8931, 1,186, 11,2%, 145 | 12253, 1,147, 17,2%, 236 | - | - |
| a Nasdaq senza Piano A | -3221, 0,923, 14,4%, 100 | 18748, 1,235, 15,0%, 162 | -0,263 / +0,088 | MISTO (segni opposti) |
| b Nasdaq senza filtro | 19702, 1,231, 11,3%, 236 | 10396, 1,072, 23,2%, 370 | +0,044 / -0,075 | **G1 formalmente FALLITO** (vedi sotto); in ogni caso MISTO |
| c Nasdaq range con barra 14:30 | 9648, 1,196, 12,1%, 148 | 10987, 1,133, 17,2%, 234 | +0,010 / -0,015 | NON DISTINGUIBILE |
| rif. Dow (R283d) | -14277, 0,777, 23,9%, 249 | 11944, 1,110, 16,0%, 406 | - | - |
| d Dow senza Piano A | -4751, 0,921, 20,4%, 169 | 26546, 1,198, 18,6%, 264 | +0,144 / +0,088 | NON DISTINGUIBILE (OOS sotto la soglia 0,10 di 0,012) |
| e Dow range con barra 14:30 | -15157, 0,765, 24,9%, 248 | 11136, 1,103, 16,9%, 406 | -0,012 / -0,007 | NON DISTINGUIBILE |

## G1 su R284b
Le gemelle OOS di R284b differiscono di 0,02 sul profit (10395,69 contro 10395,71) e di 0,0001 sul DD% (23,1612 contro 23,1611). Il criterio congelato chiedeva il DD% esatto, quindi **formalmente G1 fallisce**: lo dichiaro e non cambio la regola a posteriori. La differenza e' di arrotondamento (stessa tolleranza che R283 usava per G0: profit 1,01, DD 0,0001) e **non cambia il verdetto**: i due dPF hanno segno opposto e restano sotto 0,10, quindi MISTO con qualunque tolleranza. Per i round futuri la tolleranza di G1 sul DD% va scritta 0,0001 PRIMA di guardare.

## Lettura
- **Range con la barra delle 14:30: irrilevante su questi dati** (|dPF| <= 0,015 in entrambi i simboli, stesso numero di operazioni +-3).
- **Piano A**: Nasdaq con segni opposti nelle due gambe (IS -0,26, OOS +0,09); Dow positivo in entrambe (+0,14, +0,09) ma l'OOS e' 0,012 sotto la soglia congelata. Non e' una conclusione: e' un'ipotesi che togliere il Piano A (parziale a 50 punti + pareggio + sospensione del trailing) non aiuti sul Dow. Per dirla servirebbe un round con criteri scritti prima.
- **Filtro 17-38**: sposta i volumi (IS +91 operazioni, OOS +134) ma il PF non si muove in modo coerente.
- Il Dow resta negativo in IS in entrambi i bracci (P5 dichiarata al 75%: confermata) e positivo in OOS: firma di regime, non di regola.
- Attese: P1 si' (rc 0 per tutti), P2 NO (senza Piano A il PF OOS Nasdaq SALE), P3 si', P4 si', P5 si'.
- Non promuove niente. Un solo regime (2024-26, toro). Soglia 0,10 non calibrata sul rumore.
