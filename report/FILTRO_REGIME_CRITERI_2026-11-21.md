# Filtro di regime sul trend D1: momentum 250 giorni a isteresi e filtro di volatilita' (criteri PRIMA dei numeri, 21/11/2026)

**Fonte delle idee (`RICERCA_WEB_SISTEMI_2026-11-21.md`):** filtro mom250 con isteresi (blog MQL5 780470, soglie 0,20 / 0,15, scelte in-sample su oro 2024-26, costi non dichiarati) e filtro "no-trade" di volatilita' (Dunis e Miao via Quantpedia, soglia non dichiarata: ne fisso una io, una sola, qui). **Obiettivo: ridurre il drawdown del nostro motore trend D1 senza perdere il vantaggio; NON cercare un nuovo vantaggio.**
## Motore di base (gia' misurato il 20/11, nessun parametro nuovo)
Breakout dei livelli S/R a pivot 15/15 (`sr_breakout.py`), TF D1, ordini pendenti sui due livelli, stop iniziale 1,5 ATR, uscita E2 (Chandelier 3 ATR, nessun target), ambo i lati; costo 0,05% del prezzo medio per operazione (stessa convenzione del 20/11). Mercati D1 Yahoo: **trend: Oro, Argento, Bitcoin, Ethereum, Nikkei225; controllo: Nasdaq100, DAX, WTI.** IS = primo 70% delle barre, OOS = ultimo 30%; tutte le varianti partono dalla barra 260 (riscaldamento) per confrontare mele con mele.
## Varianti (un solo valore per parametro, nessuna scansione)
- **F1:** mom250 = close / close[250 barre] - 1 calcolato sulla chiusura; stato ON se |mom250| >= 0,20, OFF se < 0,15, invariato in mezzo (isteresi). Un nuovo ingresso al giorno t e' ammesso solo se lo stato alla chiusura t-1 e' ON; le posizioni aperte seguono la loro uscita.
- **F2:** vol20 = deviazione standard dei rendimenti logaritmici giornalieri a 20 giorni; **nessun nuovo ingresso se vol20(t-1) > 1,5 x mediana di vol20 sulle 250 barre precedenti** (soglia mia, non della fonte).
- **F3:** F1 e F2 insieme. **24 celle (3 varianti x 8 mercati)**, contatore looks 24.
## Previsioni (prima dei numeri)
- Il filtro riduce il numero di operazioni del 30-60%: 75%. Migliora il PF in IS e OOS in almeno 3 dei 5 mercati trend con F1: **30%**, con F2: **25%**, con F3: **20%**. Almeno una variante soddisfa la regola di esito: **25%**.
- Sui mercati di controllo (indici/WTI, dove il motore non funziona) i filtri non cambiano il giudizio (PF resta < 1,2): 85%.
## Regola di esito (invariata dopo i numeri)
**Variante UTILE per un mercato** se in IS **e** OOS: n >= 20, PF filtrato >= PF di base, drawdown massimo in R (somma cumulata delle R per ordine di uscita) <= 80% di quello di base, R totale >= 70% di quello di base. **Variante UTILE in generale** solo se utile in **almeno 3 dei 5 mercati trend** con la stessa variante. Altrimenti il filtro non si adotta. **Un filtro utile e' un'ipotesi da testare a tick sul vero EA, non una modifica automatica ne' un consiglio di taglie.** Limite dichiarato: motore S/R D1, non il codice di GoldenZoe (H4).
