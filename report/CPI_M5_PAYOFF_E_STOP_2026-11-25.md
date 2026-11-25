# CPI M5 oro: ampiezza, profitto medio, perdita media e PF; la perdita e' il punto debole (25/11/2026)

Richiesta di Claudio: stabilizzata l'ampiezza media, stimare la lunghezza media dei profitti e calcolare il PF. Dati: M1 oro FTMO (153 CPI) e curva del tester BCM a tick reali (27 eventi, 2024-07..2026-11). Script: `backtest_runner/simulatore/cpi_gold_payoff.py`, `cpi_gold_target.py`, `cpi_gold_momentum.py`.

## Ampiezza (range della candela CPI M5)
USD/oz: 2018-22 media 7,1; 2023-26 media 19,3 (mediana 15,9). Per anno (media): 3-5 fino al 2020, 10,3 (2021), 14,0, 14,1, 16,2, 15,7 e **31,7 (2026)**. In % del prezzo: 0,2-0,4% fino al 2020 e 0,46-0,79% dal 2021. Correlazione ampiezza-prezzo 0,73. **Non e' stazionaria**: va normalizzata sul prezzo e la media a 5 anni resta in ritardo.

## Profitto medio, perdita media, PF (EA attuale: stop sul livello opposto, uscita a T+299 s)
| Campione | n | vincenti | profitto medio | perdita media | rapporto | PF | pareggio a |
|---|---|---|---|---|---|---|---|
| **Tester reale, tick reali, 2024-26** | 27 | 48% | +11,0 USD/oz (0,57x ampiezza) | **10,5** (0,54x) | 1,05 | **0,97** | 49% |
| M1 fedele all'EA, 2023-26, senza penalita' | 45 | 42% | +10,7 | **5,3** | 2,01 | 1,47 | 33% |
| M1, 2018-22, senza penalita' | 49 | 57% | +4,7 | 2,4 | 1,93 | 2,57 | 34% |
| M1 con penalita' uniforme 2,63 USD/oz (calibrata) | 45 | 27% | +13,4 | 6,5 | 2,06 | 0,75 | 33% |
**Lettura:** il profitto medio reale (+11,0) coincide con quello simulato (+10,7). **Quello che cambia e' la perdita: 10,5 reale contro 5,3 simulata (il doppio).** Lo stop sul livello opposto viene eseguito dentro lo spike, con scivolamento. Il PF = (% vincenti x profitto medio) / (% perdenti x perdita media): con il 48% di vincenti serve un rapporto >= 1,4 per PF 1,3; il reale e' 1,05. La differenza tra simulazione e tester e' concentrata in 5 eventi su 27; negli altri 22 coincidono (correlazione 0,89, scarto mediano 0,14).

## Cio' che non funziona (misurato)
- **Bersaglio = ampiezza media a 5 anni** (anche normalizzata % del prezzo, anche meta'): con la penalita' calibrata PF 0,02-0,75 in 2018-22 e 2023-26; taglia le vincite grandi (+65 USD/oz del 14/07/2026) che fanno il profitto. Chiuso.
- **Momentum dopo il primo minuto** (ingresso a mercato a T+1 min se il primo minuto sparava forte, f = 0,25 e 0,5): media -0,7/-3,7 USD/oz, PF 0,18-0,58 in entrambi i periodi. Chiuso: dopo il primo minuto il movimento tende a ritracciare.

## Esplorativo (POST HOC, dopo aver visto la perdita doppia): togliere lo stop stretto
M1, penalita' 1 USD/oz per ingresso: 2023-26 **stop sul livello opposto** PF 1,12; **stop a meta' range** PF 1,54; **nessuno stop (solo uscita a T+299 s)** PF 1,43, vincenti 53%, perdita media 8,7 (0,45x ampiezza). 2018-22: 1,41 / 1,58 / 1,05. **Ipotesi:** gli stop eseguiti nel caos della notizia costano caro; l'uscita a tempo a T+5 minuti avviene a mercato piu' calmo. Non e' una prova: M1, post hoc, un solo campione per periodo, e l'ingresso resta uno stop eseguito nello spike.

## Test successivo (criteri scritti ora, prima del tester)
**T1-bis:** stesso T1 (XAUUSD, tick reali, 2024-07-01 -> 2026-11-20, 0,10 lotti, buffer 100), con `InpSlMode = 1` e `InpSlPoints = 3000` (stop di sicurezza a 30 USD, che equivale a "nessuno stop" nelle 5 minuti). **Promettente** se profitto > 0 e PF >= 1,3 su >= 25 eventi; **non candidato** se PF < 1,0. Previsione: PF 1,0-1,5 (la simulazione dice 1,4-1,8 senza lo scivolamento degli stop), probabilita' PF >= 1,3: 35%. Rischio dichiarato: nessuno stop stretto = perdita per evento fino a diversi USD/oz in un solo minuto; il massimo perso per evento va letto nel report.
