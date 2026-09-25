# 🛑 TERZO STOP DELLA CHALLENGE FTMO `541452707` — `770101` DAX, 25/09/2026

**Fonte:** due screenshot dell'app MT5 di Claudio (Storico -> Affari, grafico GER40.cash M5), 16:04 IT.
Sola lettura: nessun EA, preset o conto toccato.

## 1. I fatti (dalla scheda Affari)
| | ora server FTMO | ora IT | lotti | prezzo | commento |
|---|---|---|---:|---:|---|
| ingresso | 12:27:10 | 11:27:10 | 19,90 buy | 25.468,62 | `DAX Apertura EU RETEST BUY` |
| uscita | 17:02:18 | 16:02:18 | 19,90 sell | 25.390,59 | `[sl 25391.24]` |

- Perdita **−1.552,80 EUR**. Quella prevista allo SL: 77,38 punti x 19,90 = **−1.539,86**; lo slittamento
  e' di **0,65 punti = 12,94 EUR**. Swap e commissioni 0,00.
- 👉 **L'EA ha fatto quello che il contratto dice**: ingresso a retest, stop sul server, rischio ~2,0%
  (la taglia firmata), uscita allo stop con slittamento minimo. **Nessun difetto di esecuzione.**
- ⏰ La discesa che prende lo stop e' **una sola candela M5, quella delle 17:00 server FTMO = 16:00 IT =
  10:00 di New York**. Che dietro ci sia un dato USA delle 10:00 e' [INFERITO]: il calendario del repo
  **non copre** la data (`R245_IL_DD_DELLA_FINESTRA_VERGINE` §3: i dati delle 10:00 ET *dentro la
  posizione* sono gia' un buco [NON MISURATO]; la `770101` tiene fino alle 19:30 server, quindi quell'ora
  le cade dentro ogni giorno).

## 2. Dove sta la challenge [DERIVATO: saldo d'inizio giornata 76.643,52 dal Guardian del 24-25/09, nessun'altra operazione chiusa oggi nella scheda Affari; l'app mostra 75,0K]
| | valore |
|---|---:|
| saldo dopo lo stop | **75.090,72** |
| DD totale sul 80.000 | **6,14%** |
| margine dal muro FTMO del 10% (72.000) | **3.090,72** |
| margine dall'emergenza Guardian 9,9% (72.080) | **3.010,72** |
| perdita di oggi | 1,94% del 80.000 · margine giornaliero residuo (muro 5% = 4.000) **2.447,20** |
| per il target di fase (+10% = 88.000) mancano | **12.909,28** = ~8,6 R da ~1.500 |

## 3. 🔴 La riga che conta: quanti stop pieni restano a rischio 2,00%
- **Uno**: saldo ~73.589, DD 8,01%. Si regge.
- **Due di fila**: saldo **~72.117**, DD **9,85%**: **37 EUR sopra** l'emergenza del Guardian (9,9%).
  Con lo slittamento di oggi (13 EUR su uno stop) il margine e' **quasi zero**.
- **Due insieme** (il cap del rischio aperto in campo e' **4,00%**, quindi due sedie a 2% possono stare
  aperte insieme, `DD_PORTAFOGLIO_FTMO_2026-09-20.md` §5.1): saldo **~72.087**, DD **9,89%**, in un
  pomeriggio solo.
- Il cap **firmato** il 18/08 e' **3,25%** (C1); in campo c'e' **4,00%**: la divergenza e' agli atti
  come decisione aperta di Claudio. 🔴 **Taglie e cap sono firme di Claudio: qui ci sono solo i numeri.**

## 4. Il quadro dei tre stop
22/09 `PRIMO_STOP_FTMO` · 24/09 `SECONDO_STOP_FTMO` (`770411`, −1.621,03) · 25/09 questo (`770101`, −1.552,80).
Tre stop pieni in cinque giornate di challenge, tutti eseguiti come da contratto.
