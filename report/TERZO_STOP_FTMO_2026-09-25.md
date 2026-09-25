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
| margine dall'emergenza Guardian **9,3%** (72.560) | **2.530,72** |
| perdita di oggi | 1,94% del 80.000 · al muro FTMO del 5% (4.000) mancano **2.447,20**; alla pausa Guardian 3,5% (2.800) **1.247,20**; all'emergenza giornaliera Guardian 4,5% (3.600) **2.047,20** |
| per il target di fase (+10% = 88.000) mancano | **12.909,28** = ~8,6 R da ~1.500 |

✏️ **ERRATA 25/09 sera (verificata alla fonte).** La prima stesura usava il Guardian **4,9 / 9,9 / 4,0** di `DD_PORTAFOGLIO_FTMO_2026-09-20.md` §5, scritto **prima** delle firme del 20/09. Il Guardian **in campo** su `C:\FTMO` (`CODA_08_preset_dai_chr_20260925_033004.log`, `chart06.chr`, modificato il 24/09 08:06; uguale a `mql5/Presets/ABTG_Guardian_FTMO_2Step.set`) ha: `InpStartBalance=80000` · `InpDailyLossPct=4.5` · **`InpTotalDDPct=9.3`** · `InpDailyPausePct=3.5` · `InpMaxOpenRiskPct=4.00`. E il cap C1 scatta solo sul rischio **gia' aperto** (`ABTG_Guardian.mq5` r.789: `riskPct>=InpMaxOpenRiskPct`), non in modo prospettico. Trovato dal MC dallo stato di oggi (`report/MC_DALLO_STATO_DI_OGGI_2026-09-25.md`).

## 3. 🔴 La riga che conta: quanti stop pieni restano a rischio 2,00% (corretta)
- **Uno**: saldo ~73.589, DD 8,01%: **1.029 EUR sopra** l'emergenza del Guardian (72.560). Si regge.
- **Due di fila**: arriverebbero a ~72.117, **443 EUR SOTTO** l'emergenza: il Guardian chiude tutto a **72.560** (DD 9,30%) e blocca per 30 giorni (`SetPausa(... 30*86400 ...)`, r.781). 👉 **Il secondo stop pieno di fila ferma la challenge.** Il muro FTMO del 10% resta intatto (cuscino di 560 EUR; lo slittamento della chiusura d'emergenza e' [NON MISURATO]).
- **Due insieme**: possibili **sia con il cap in campo (4,00%) sia con quello firmato (3,25%)**: con una posizione aperta al 2% il rischio aperto (2,00) e' sotto tutti e due i tetti, quindi la seconda entra. Se vanno a stop tutte e due, stesso esito: fermata del Guardian.
- **Cap 3,25 contro 4,00**: con sedie al 2% la differenza e' solo sulla **terza** posizione (due lotti arrotondati possono sommare 3,99% < 4,00 e lasciarla passare; con 3,25 no). ⚠️ Il commento del preset che dice *"3.25 lasciava passare UNA SOLA posizione"* e' **sbagliato** per lo stesso motivo.
- 🔴 **Taglie e cap sono firme di Claudio: qui ci sono solo i numeri.**

## 4. Il quadro dei tre stop
22/09 `PRIMO_STOP_FTMO` · 24/09 `SECONDO_STOP_FTMO` (`770411`, −1.621,03) · 25/09 questo (`770101`, −1.552,80).
Tre stop pieni in cinque giornate di challenge, tutti eseguiti come da contratto.
