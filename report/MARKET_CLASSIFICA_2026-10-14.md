# CLASSIFICA DEGLI EA DEL DEMO PICCOLO 50503392: giornata del 14/10/2026 (report delle 16:52, ora server)

Fonte: `data/statements/ReportHistory_50503392_2026-10-14.xlsx` (SHA256 `aedb1d06…`; mandato da Claudio). **Il report copre SOLO il 14/10** (aperture dal 13/10 20:00 al 14/10 15:50, chiusure dal 14/10 00:07 al 15:51): 954 posizioni chiuse + 30 aperte. Letto con `natura_motore_da_storico.py` (`302b5b74…`) su una copia con i `CID` normalizzati (il tool non li comprime: difetto noto) e con `backtest_pipeline/analisi_cesti_commento_cid.py`. **Un solo giorno, tutti con n < 150: nessun merito misurato.** Attribuzione dal commento d'apertura (ipotesi).
Conto: **netto chiuse +793,15** (+871,27 dai deal), PF 1,284, **drawdown di SALDO massimo 8,33% (410,66 EUR) nello stesso giorno**; l'equity non e' nel file.

## 1. Classifica dei PROFITTI di oggi (descrittiva: NON e la classifica di qualita')
| # | EA (commento) | chiuse | netto EUR | nota |
|---|---|---:|---:|---|
| 1 | **Arena Nexus Grid** (FinlabX + CF + DZR) | 730 | **+817,57** | `[R]` BUY +516,65, SELL +429,39; `[F]` e CF nel complesso -135 |
| 2 | SNIPING EA | 83 | +34,0 | un trade a -180,6 e uno a +125,6 |
| 3 | Sample Comment (commento di default di un EA gratuito) | 7 (+4 aperte) | +30,9 | **flottante -149,2** |
| 4 | HedgingMartingale EA | 6 | +28,5 | -- |
| 5 | marcalbrechttrading.com (4 varianti di commento) | 30 | +19,3 | tutte senza SL e TP |
| 6 | Dark Venus (EURUSD) | 7 (+6 aperte) | +4,6 | flottante -36,6 |
| 7 | SSP scalp / SSPv4 | 5 | +2,4 | -- |
| 8 | Nang_Kwak_Gold_Trader | 4 | -9,8 | -- |
| 9 | GZ (TP1/TP2/TP3) | 51 | **-63,6** | buy -96,2 (36), sell +32,3 (15) |
| 10 | TIG Breakout LOW | 2 | -138,4 | lotto 0,30, -70,3 e -68,1 |
| 11 | MP by SPLpulse | 3 | **-220,6** | lotti 0,05-0,20, peggiore -179,2 |
| -- | nostre (BULGE, MAXMIN ORO, LARRY, ...) | 9 | ~+40 | n minimo |

## 2. Classifica di QUALITA' (i criteri scritti il 14/10 mattina PRIMA dei numeri: SL iniziale, niente griglia/scala di lotti/recovery, rischio calcolabile, costo, giornate osservate; il netto NON ordina)
| posto | EA | natura [LETTO nel conto] | giudizio |
|---|---|---|---|
| **1** | **GZ** | **SL iniziale su tutte le 51 posizioni**, 3 target (TP1 2,5 / TP2 5 / TP3 7,5 USD), SL 9,8 (buy) e 5,6 (sell), lotto fisso 0,01, nessuna griglia, nessuna scala di lotti, nessun hedging | **l'unica con natura PULITA**; oggi perde sul lato buy (PF 0,21-0,55) e guadagna sul sell (PF 1,28-3,8): 1 giorno, 36 + 15 operazioni. Stop/spread ~49x (sopra la frontiera sullo stop). **Da osservare piu' giorni.** |
| 2 | TIG Breakout LOW | SL 2,5, TP 30, SELL, **lotto 0,30 (~1,4% del saldo a trade)** | natura pulita, ma **2 trade a SL = -138 EUR**: la taglia fa la differenza. n=2 |
| 3 | Nang_Kwak_Gold_Trader | SL 6, **TP 100** (target quasi irraggiungibile), orario fisso ~02:16 | SL presente; 4 trade, 3 in perdita; n=4 |
| 4 | DResEA (53) | 3 posizioni, SL messo con modifica, nessun TP iniziale | n=3 |
| 5 | HedgingMartingale EA | SL 13,5 e TP 5,4, orario fisso 02:36; **il nome dichiara hedging e martingala** | 6 chiuse positive: la coda di un martingala non si vede in 6 trade |
| 6 | SSP scalp / SSPv4 | SL e TP, scalping, ingressi a barra M5 | n minimo (5) |
| 7 | SNIPING EA | **senza SL iniziale (72/84), senza TP, hedging 48 ingressi col lato opposto vivo, lotti a scala 0,01-0,09**, scalping | rischio non cappato; **peggior trade -180,6** |
| 8 | marcalbrechttrading.com | **senza SL e senza TP, catene di 7 ingressi a prezzo peggiore (griglia)**, scalping ~1 min | red flag |
| 9 | Sample Comment | **senza SL/TP, catena di 4 ingressi a prezzo peggiore, flottante -149** | red flag |
| 10 | Dark Venus (EURUSD) | **senza SL/TP, griglia (catena 6), scala di lotti, hedging**, flottante -36,6 | red flag |
| 11 | MP by SPLpulse | **recupero (lotto salito dopo una perdita 2/2)**, SL messo dopo, lotti 0,05-0,20 | -220,6 su 3 trade |
| **12** | **Arena Nexus Grid** | **senza SL iniziale (134/146 e simili), senza TP, griglia (catena 13), scala di lotti, recovery a cesto** | il PIU' redditizio e il PIU' a rischio: **non entra nell'imbuto prop**; vedi §3 |

## 3. L'Arena, secondo giorno (14/10 fino alle 15:51)
- **+817,57 EUR** (13/10: +487,31): due giorni in positivo, **nessuna giornata contraria**. 730 posizioni chiuse, 11,74 lotti scambiati, **picco 1,28 lotti vivi insieme** (alle 14:08; ieri 1,01), 87 `CID`; il cesto peggiore e' -13,5 EUR.
- **La coda pesa di piu'**: i cesti con **>= 10 livelli** di recupero sono **5** (somma d'ingresso fino a 2,1 lotti, fino a 5,8 ore) e fanno **+480,2 dei +946,0 del `[R]`: il 50,8%** (ieri 24,5%). Profondita': 1 livello 31 cesti (+34,5), 2: 18 (+85,2), 3-4: 15 (+168,3), 5-9: 8 (+177,9), >= 10: 5 (+480,2); cesti in perdita 8 su 77.
- **Il saldo ha avuto -8,33% di drawdown massimo** nella giornata (410,66 EUR su circa 4.900): su una prop con limite giornaliero del 5% avrebbe sforato prima ancora di contare il flottante, che il report non mostra.
- Per i nostri EA l'ipotesi resta quella di ieri: la **versione capata** (SL di cesto, profondita' massima) e' prevista **NULLO** dal proxy; la domanda aperta e' se la coda alta e' un segnale d'avvio che non vediamo.

## 4. Cosa NON si puo' dire
- Nessun merito (n < 150, un giorno, un regime). La classifica dei profitti e' un'istantanea, quella di qualita' e' sulla NATURA.
- Il flottante a fine giornata e il MAE non sono nel file; la taglia reale (rischio per trade) si legge solo con SL e lotti.
- Le attribuzioni (marcalbrecht a 4 commenti = lo stesso EA?) sono ipotesi.
