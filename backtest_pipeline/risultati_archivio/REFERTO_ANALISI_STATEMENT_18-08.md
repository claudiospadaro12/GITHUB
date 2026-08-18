# 🔬 ANALISI STATEMENT — 18/08/2026 (100k di oggi + conto piccolo del 17/08)

_File agli atti in `statement/`. Analisi su richiesta di Claudio ("analizziamo
qualche trade?")._

## 1. 🏆 IL TRADE DEL GIORNO SUL 100k, SEZIONATO — e riscrive la risposta di stamattina

`MAXMIN DAX SHORT` (12,8 lotti), anatomia completa dagli ordini:

| ora (server) | evento | prezzo | esito |
|---|---|---|---:|
| 07:59:00 | sell stop piazzato | 26.216,7 · SL 26.266,7 (50 pt = 1R) · TP 26.016,7 (4R) | |
| 08:14:43 | eseguito | 26.216,7 | |
| 09:04:34 | **PARZIALE 50%** (6,4 lotti) | 26.166,0 = **il target 1R** | **+324,48** |
| — | stop del runner portato a BREAKEVEN | 26.216,7 | |
| 09:18:58 | runner stoppato in pari | 26.216,7 | 0,00 |

> **La risposta precisa alla domanda di Claudio ("senza trailing avremmo
> guadagnato di piu'?"): TUTTO il profitto e' venuto dalla PARZIALE a 1R.**
> Il runner e' andato a zero sul breakeven. E la variante "lasciar correre"
> (niente parziale, niente BE) a quest'ora sarebbe ANCORA APERTA in perdita
> flottante (prezzo tornato sopra l'ingresso, TP 4R mai avvicinato, SL pieno
> mai toccato). R81 misurera' se e' la regola o l'eccezione.

📌 Risolto anche il giallo delle notifiche delle 13:59-14:05: il pendente da
9,7 lotti piazzato alle 13:05:19 e cancellato UN SECONDO dopo e' l'EA che si
re-inizializza (grafici/profilo toccati mentre Claudio generava i report) e
si auto-corregge col controllo one-trade-per-day. Idem le coppie ORO
aggiunte/cancellate sul piccolo. Benigno: il sistema si e' difeso da solo.

## 2. 📉 IL CONTO PICCOLO, GIORNATA DEL 17/08 — la prima giornata del "mondo nuovo"

Numeri del report MT5: **14 operazioni chiuse, −35,48 netto (−0,69%)**,
PF di giornata 0,435, win rate 64,3%, DD di bilancio max **1,03%**.

**✅ La prova che la correzione del rischio FUNZIONA**: la peggior perdita e'
`LARRY EURAUD` a **−52,66 con commissioni = −1,02% del conto** — esattamente
il rischio dichiarato. Il 16/08 le peggiori facevano −2,19%. Mai piu' una
perdita oltre l'1% e spiccioli in tutto il report.

**⚠️ Il pattern da tenere d'occhio (M2 dal vivo)**: 11 operazioni su 14 sono
su U30USD — EMA200 (L1, L2, S1, S2) + SuperWave (1/3, 2/3) tutte sul Dow
nella stessa giornata, con ingressi alle 11:00:03 in tre nello stesso
secondo. E' esattamente il cluster che il cap C1 (3,25% sugli SL vivi)
esiste per governare: ieri e' andata bene (chiusure piccole, molte in BE),
ma la concentrazione e' quella misurata da M2.

**Il profilo della giornata**: tante vincite piccole (max +9,64), una perdita
piena (−1%). Su UNA giornata e' normale amministrazione; e' il profilo da
sorvegliare col criterio C3 alla scala delle 20 operazioni per famiglia.

## 3. Note di servizio
- Il report del piccolo e' del 17/08 sera: la giornata di OGGI del piccolo
  non e' inclusa (le posizioni aperte nel report — GBPCAD, EURJPY, GBPUSD,
  AUDJPY — sono quelle viste negli screenshot di stamattina).
- Nessuna violazione dei contratti C3 valutabile su un giorno solo; le
  frequenze si giudicano alla scala giusta.
