# R283 -- ORB_Emiliano v1.00: prima compilazione e prima misura (23/10/2026)
Fonte: `ROUND_R283_2026-10-23.zip` (PC DESKTOP-H4D7CAJ, pin 5074f235, motore = pin SHA256, 4 round rc 0, catena completa, per-trade 8/8). Lettore congelato `r283_giudizio.py`: **G1 OK, G0 OK, IMPIANTO c e d OK.**

| Round | Leg | Profit | PF | DD% | Trades (deal) |
|---|---|---|---|---|---|
| a Ottimizzato v1.04, U30USD | IS / OOS | 7630,13 / 33442,57 | 1,247 / 1,678 | 8,25 / 9,99 | 71 / 119 |
| b Emiliano, novita' spente | IS / OOS | 7630,13 / 33442,57 | 1,247 / 1,678 | 8,25 / 9,99 | 71 / 119 |
| c Emiliano regola Nasdaq, NASUSD | IS / OOS | 8930,99 / 12253,46 | 1,186 / 1,147 | 11,19 / 17,20 | 145 / 236 |
| d Emiliano regola Dow, U30USD | IS / OOS | -14277,30 / 11943,95 | 0,777 / 1,110 | 23,87 / 16,03 | 249 / 406 |

- **Compila**: 0 errori, 0 avvisi (Emiliano e Ottimizzato). **G0: b = a al centesimo** in IS e OOS => i default non cambiano il comportamento.
- Piano A scatta: OOS c 74 posizioni su 162 con piu' di un deal (parziale), d 142 su 264 (dal per-trade).
- Attese dichiarate prima: P1 80% si', P2 85% si', P3 Trades>0 si' / PF OOS c <1,00 (55%) NO (1,147), P4 PF OOS d <1,00 (65%) NO (1,110), P5 d piu' operazioni di c si'.
- Il Dow cambia segno fra IS (-14277) e OOS (+11944): firma di regime gia' vista (R54a, 1,51/0,84), non un'edge. Un solo regime (2024-26, toro).
- **Non si puo' attribuire** il risultato a nessuna novita' (Piano A, filtro, range escluso 14:30): manca il braccio di controllo con ciascuna novita' spenta. Stop/target assunti (non detti da Emiliano). Non promuove niente. Sharpe -5,00000 di R283d IS e' un artefatto del tester.
