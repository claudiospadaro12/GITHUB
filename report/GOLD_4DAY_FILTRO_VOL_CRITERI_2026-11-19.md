# Gold 4-Day Breakout + filtro di volatilita' (PDF v2 di Massimo): criteri scritti PRIMA dei numeri (19/11/2026)
**Cosa si testa:** le tre varianti del PDF, sulla regola gia' replicata (`GOLD_4DAY_BREAKOUT_CRITERI_2026-11-19.md`: 4 giorni, stop 0,5 ATR, finestra 10-22 server, chiusura 22:00). Dati: oro FTMO M1 2014-11 -> 2020-12 (nessun dato 2021-26 in questa sessione, quindi **non si puo' rifare il loro 2019-23 / 2023-26**).
**Varianti (dal PDF):** A = opera solo se ATR(14) del giorno prima > soglia x ATR(100) (media del vero range degli ultimi 100 giorni), soglie {0,9; 1,0; 1,1; 1,2}. B = opera solo se (massimo 4 giorni - minimo 4 giorni) > soglia x ATR(14), soglie {2; 2,5; 3}. C = A e B insieme, tutte le 12 combinazioni. **19 celle in tutto**, nessuna aggiunta dopo. Tutti i valori usano solo dati fino al giorno prima.
**Periodi:** A = 2014-11 -> 2018-12 (mai visto dal PDF), B = 2019-2020. Base = stessa regola senza filtro, sugli stessi giorni (partenza dopo 100 giorni di dati).
**Porte:** il filtro "protegge dai regimi calmi" (ipotesi del PDF) se almeno una variante, con la sua soglia **scelta su B (2019-2020, il periodo del loro in-sample) e giudicata su A (2014-2018, mai visto)**, ottiene in A: PF > 1,2, >= 100 operazioni e R > 0, e le soglie vicine (un passo) hanno PF > 1,1. Controllo del caso: per ogni cella si confronta con 300 estrazioni a caso di giorni con lo stesso numero di giorni operativi; il filtro conta solo se il PF reale supera il 95% delle estrazioni (p < 0,05); con 19 celle, ne ci si aspettano 1 per puro caso, quindi serve p < 0,01 per dirlo reale.
## Previsioni
- Esiste una cella con PF > 1,2 in A, >= 100 operazioni, scelta in B: **12%**.
- Il miglior PF in A tra le 19 celle e' < 1,15: **65%**.
- Nessuna cella con p < 0,01 contro i giorni a caso: **85%**.
- Il filtro alza il PF nel periodo B (2019-20) rispetto al base (1,05) in almeno meta' delle celle: **45%** (la volatilita' dopo un periodo calmo e' spesso un breve rimbalzo).
## Limiti
Solo 6 anni, nessun 2021-26; l'oro 2014-2018 era un periodo di tendenza ribassista/laterale con poche fasi di volatilita' alta; con filtri selettivi restano poche operazioni (soglia di affidabilita' del PDF: >= 30-40; qui chiedo >= 100).

## RISULTATI (`backtest_runner/simulatore/gold_4day_filtro_vol.py`; oro FTMO M1 2014-11 -> 2020-12; base sugli stessi giorni: A 2014-18 n=479 PF 0,98; B 2019-20 n=245 PF 1,05)
| Variante | Periodo A 2014-18 (PF / n) | Periodo B 2019-20 (PF / n) |
|---|---|---|
| A, ATR14 > 0,9 x ATR100 | 0,88 / 290 | 1,14 / 149 |
| A, soglia 1,0 | 0,72 / 148 | 1,10 / 108 |
| A, soglia 1,1 | 0,52 / 75 | 1,12 / 83 |
| A, soglia 1,2 | 0,63 / 33 | 1,14 / 58 |
| B, canale > 2 ATR | 1,02 / 194 | 0,89 / 99 |
| B, canale > 2,5 ATR | 1,08 / 82 | 0,88 / 63 |
| B, canale > 3 ATR | 1,84 / 33 | 1,12 / 31 |
| C (A+B), 12 combinazioni | 0,46-1,46 con n 11-104; le piu' selettive PF 2-99 con n 2-16 | 0,95-4,9 con n 9-54 |
- **Cella scelta su B (2019-20) con >= 50 operazioni:** A (0,9 x ATR100), PF in B 1,14 (149 op.). **Giudicata su A (mai visto): PF 0,88**, p vs giorni a caso 0,585. **Nessuna cella con PF > 1,2 in A e >= 100 operazioni; il miglior PF in A con >= 100 operazioni e' 1,02.**
- **Il filtro A (ATR alto rispetto alla norma) peggiora il 2014-18** (PF 0,52-0,88 contro 0,98) e migliora leggermente il 2019-20 (1,10-1,14 contro 1,05): segno opposto nei due periodi, nessun effetto robusto. Il filtro sul canale ampio da' PF in A fino a 1,08 con >= 80 operazioni, ma in B scende sotto 1.
- **Le celle con PF altissimo (1,84; 4,05; 35,5; 99) hanno 2-33 operazioni: rumore.** L'unica cella con p < 0,01 contro i giorni a caso e' C (1,1; 3,0) con **4 operazioni**: non vale nulla. Con 19 celle un p basso su un campione minuscolo e' atteso.
- Previsioni: cella con PF A > 1,2 e >= 100 op. (12%) -> no; miglior PF A < 1,15 (65%) -> si' (1,02); nessuna cella con p < 0,01 (85%) -> **no, ma e' la cella con 4 operazioni**; filtro alza il PF in B in almeno meta' delle celle (45%) -> si' (15 su 19).
**Verdetto: il filtro di volatilita' NON si conferma come protezione dai regimi calmi sui dati 2014-2020.** Non si puo' escludere che funzioni nel 2023-26 (dati non disponibili qui); per il 2019-23/2023-26 va fatto da Massimo o con l'export dell'oro FTMO 2021-2026.
