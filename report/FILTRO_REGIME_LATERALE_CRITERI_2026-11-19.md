# Togliere i trade laterali (filtro di regime) sull'incrocio EMA 9/21: criteri scritti PRIMA dei numeri (19/11/2026)
**Domanda di Claudio:** si possono togliere i trade in mercato laterale tenendo quelli che "corrono"? Da cosa dipendono i piccoli profitti/le perdite? Si puo' far segnalare solo dove l'oro (o altri simboli) corre?
**Metodo (due parti):**
1. **Diagnosi:** per ogni segnale di incrocio EMA 9/21 con ADX > 12 (Universal Scalper) si misura, **a barra chiusa del segnale**, quattro indicatori di "quanto il mercato corre": **ER20** (efficienza di Kaufman su 20 barre: |variazione| / somma dei movimenti; vicino a 0 = laterale, vicino a 1 = trend pulito), **ADX**, **pendenza della EMA21 su 10 barre in ATR**, **ATR / media ATR a 100 barre** (volatilita' relativa). Poi si guarda la mediana di ciascuno per i trade perdenti, piccoli (|R| <= 0,3) e vincenti (R > 0,3), e il rendimento medio per metà alta/bassa dell'indicatore.
2. **Filtro:** si opera solo se l'indicatore e' **sopra la mediana calcolata sui segnali del periodo In-Sample** (primo 70% delle barre); una sola regola per indicatore, **nessuna soglia ottimizzata**; si valuta sull'Out-of-Sample (ultimo 30%) con la stessa soglia. Controllo del caso: 300 estrazioni casuali di meta' dei segnali In-Sample/OOS (stessa dimensione) per vedere se il filtro batte il caso.
**Dati/mercati/TF:** XAUUSD e EURUSD (FTMO 2014-2020), NASUSD e SPXUSD (2015-2024) a **M15 e H1**; uscita **B2** (stop 1,5 ATR + uscita sul segnale opposto, la migliore del test precedente) e **A** (SL 1,5 / TP 2 ATR). Costi come prima. 4 mercati x 2 TF x 2 uscite x 4 indicatori = **64 test**: per solo caso qualcuno sembrera' migliore.
**Porte:** il filtro "aiuta" se, **nell'Out-of-Sample**, il PF filtrato supera quello non filtrato di almeno 0,10, con >= 100 operazioni, il PF filtrato > 1,0 e batte il 95% delle estrazioni casuali; e lo stesso segno in almeno 3 mercati su 4 per lo stesso indicatore. Un EA valido richiede poi le porte di Claudio (IS PF >= 1,5, DD <= 15%, >= 100 op.; OOS PF > 1,2).
## Previsioni
- I trade perdenti/piccoli hanno ER20 e pendenza mediani piu' bassi dei vincenti: **70%** (e' la lettura intuitiva del laterale).
- Il filtro porta il PF OOS filtrato sopra 1,2 in almeno un mercato/TF/uscita con >= 100 operazioni: **15%**.
- Il filtro aiuta secondo la porta (stesso indicatore, >= 3 mercati su 4): **10%**.
- Esempi gia' visti in questa sessione: il filtro di volatilita' del 4-Day Breakout e il filtro ATR del Donchian non hanno retto fuori campione.
## Limiti
Un solo sistema (incrocio EMA), 4 mercati; indicatori calcolati sulla stessa barra del segnale (nessun futuro); il regime "corre/laterale" si riconosce bene dopo, meno in tempo reale.
