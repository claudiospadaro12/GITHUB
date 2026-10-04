# EMAGEM2 -- PRE-LETTURA (04/10/2026, 22:17-22:27 sul PC di backtest)

> PRE-LETTURA con lo strumento `backtest_pipeline/leggi_emagem2.py` e i criteri dei file prova EMAGEM2 (scritti PRIMA dei numeri). **Non e' un verdetto** su nessuna cella:
> nessuna cella si promuove, nessuna taglia si propone. Cancello del giudizio (controllo-preventivo) sulla lettura: da fare. Archivio grezzo: `backtest_pipeline/risultati_archivio/ROUND_EMAGEM2_20261004_2217/`.

## 1. Il cancello incrociato: PASS
La sedia 771531 (Dow, U30USD H1) riprodotta sul PC di backtest dentro la tolleranza di banco dichiarata: IS 4585,40 / PF 1,20110 / DD 5,7325 / 237 e OOS 23321,47 / PF 1,52365 / DD 7,8323 / 517 su tutte e due le gemelle.
Residui (dentro la tolleranza): 0,01 EUR di Profit, 2e-5 di Expected Payoff, 1e-5 di Sharpe: **gli stessi del round del 03/10 con magic diversi** [MISURATO]: il residuo non e' casuale, e' riproducibile.
Durata 10 minuti, nessuna gamba morta, nessuna riprova.

## 2. La cella della 771531 sui gemelli: tabelle (rischio 1,0; DD x 0,65 = confronto col campo)
**D30EUR (DAX)**

| TF | IS n | IS PF | IS DD | OOS n | OOS PF | OOS DD | T3 DD<=10 | T4 n>=300 |
|---|---:|---:|---:|---:|---:|---:|---|---|
| M30 | 507 | 0,657 | 19,76 | 1210 | 0,954 | 14,77 | no | si |
| H1 | 295 | 0,928 | 11,50 | 568 | 0,783 | 15,18 | no | si |
| H2 | 149 | 1,407 | 6,40 | 361 | 0,798 | 12,62 | no | si |
| H3 | 83 | 0,941 | 4,12 | 209 | 0,753 | 7,00 | si | no |
| H4 | 40 | 1,133 | 2,34 | 156 | 1,052 | 5,54 | si | no |

**NASUSD (Nasdaq)**

| TF | IS n | IS PF | IS DD | OOS n | OOS PF | OOS DD | T3 | T4 |
|---|---:|---:|---:|---:|---:|---:|---|---|
| M30 | 518 | 0,728 | 17,45 | 1043 | 1,092 | 5,99 | si | si |
| H1 | 244 | 0,755 | 15,35 | 508 | 0,693 | 20,97 | no | si |
| H2 | 143 | 0,735 | 5,64 | 285 | 0,771 | 11,76 | no | no |
| H3 | 57 | 0,742 | 3,80 | 133 | 0,488 | 10,61 | no | no |
| H4 | 41 | 0,321 | 5,94 | 113 | 0,734 | 8,50 | si | no |

(n = deal, non posizioni: circa 2 deal per posizione sul Dow, rapporto non misurato su DAX e Nasdaq.)

## 3. Come si legge
- **T6 non scatta su nessuno dei due simboli**: nessuna cella H1/H2 ha OOS PF >= 1,10 con n >= 300, IS PF >= 1,00 e DD <= 10%. Le attese scritte prima (OOS PF 0,70-0,95 a H1) **reggono sul DAX** (0,783) e **sul Nasdaq H1 il PF e' ancora piu' basso** (0,693, sotto la banda; DD 21%).
- **La cella del Dow NON si trasporta ai gemelli a H1.** Questo e' il risultato misurato.
- Segni da non sopravvalutare: DAX H2 IS 1,41 e OOS 0,80 (si ribalta); Nasdaq M30 IS 0,73 e OOS 1,09 con DD 6% (si ribalta); DAX H4 1,13 / 1,05 con n sotto 300.
  **Un solo regime** (mercato toro dal 26/09/2024): un segno che si ribalta fra IS e OOS dice instabilita', non un edge.

## 4. Cosa NON si dice (certificato di morte)
Non e' una morte per nessuno dei due: manca la **gestione dell'uscita messa ad asse** su un gemello (parziale, breakeven, trailing, `InpSLatr`), e il **regime** e' uno solo.
Verdetto corretto: **i gemelli e il TF sono misurati (box chiuso), l'uscita no: NON ANCORA MISURATO nel certificato**. Non e' un risultato negativo definitivo, ma non c'e' nessuna sedia da schierare qui.

## 5. NON FATTO
T2 (costo), posizioni per il rapporto deal/posizione su DAX e Nasdaq (per-trade sovrascritti fra TF), lettura per stagione (orologio).
