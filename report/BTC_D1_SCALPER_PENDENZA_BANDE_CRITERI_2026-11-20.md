# Universal Scalper su BTC D1 + pendenza delle bande di Bollinger + uscita Heikin-Ashi: criteri PRIMA dei numeri (20/11/2026)

**Idea di Claudio (screen 20/11, BTC D1 Bitstamp):** i segnali dell'indicatore funzionano quando le bande di Bollinger sono inclinate (trend), non vanno presi quando sono piatte/laterali ("NO" nella zona piatta di agosto 2026, "SI" nelle fasi inclinate); lo stop/uscita al cambio colore della candela Heikin-Ashi; una candela HA di colore contrario con bande molto inclinate sarebbe un ritracciamento e il prezzo continuerebbe. Screen scelti a occhio a posteriori: da soli non provano niente, per questo si misura su tutta la storia.
**Dati:** BTC-USD giornaliero Yahoo 2014-09-17 -> 2026-11-19 (4.447 barre, stessa fonte dei test D1 del 19/11). IS = primo 70% delle barre, OOS = ultimo 30%. Costo all-in 0,10% per operazione. Nessun parametro ottimizzato.
**Ingresso (invariato, dal codice dell'indicatore):** incrocio EMA9/EMA21 con ADX(14) > 12 a barra chiusa, ingresso all'apertura successiva, una posizione alla volta. **Tre uscite:** A = autore (SL 1,5 ATR, TP 2,0 ATR dal close del segnale, tempo max 60 barre); B = cambio di segnale; C = cambio colore HA (il long esce alla prima candela HA rossa a chiusura barra, all'apertura dopo; il short al contrario), nessuno stop. R = 1,5 ATR(14) del segnale.
**Pendenza:** `(SMA20[t] - SMA20[t-5]) / (5 x ATR14[t])`, con segno. I tre gruppi (bassa/media/alta) sono i terzili di |pendenza| calcolati SOLO nei giorni IS (q33, q67) e applicati uguali all'OOS. Non si sceglie nessuna soglia dopo i numeri.
## Test 1 (il filtro)
R medio, PF, operazioni e win rate per gruppo di pendenza (alta contro bassa), per uscita A/B/C, IS e OOS, lato long e short separati.
## Test 2 (la tua regola del ritracciamento)
Giorni con |pendenza| alta (> q67) e candela HA di colore contrario alla pendenza: rendimento del prezzo a 5 e 10 giorni **nella direzione della pendenza** (positivo = il prezzo continua). Confronto con (a) tutti i giorni a pendenza alta senza HA contraria, (b) giorni a pendenza bassa con HA contraria. Finestre sovrapposte: i numeri di operazioni sono sovrastimati, lo si scrive.
## Porte (di Claudio, immutate) e regole
VALIDATO solo se, per un'uscita, il gruppo "pendenza alta" ha IS PF >= 1,5 con >= 100 operazioni (su BTC D1 se ne attendono ~100-130 senza filtro: **le porte non sono raggiungibili con il filtro, lo dichiaro**) e OOS PF > 1,2, R > 0, >= 30 operazioni. In mancanza, il giudizio e' una DIREZIONE: "pendenza alta" meglio di "bassa" in IS **e** OOS, per R medio, con entrambi i lati. Test 2: la continuazione conta se, in IS **e** OOS, il rendimento direzionale medio a 10 giorni dopo HA contraria con pendenza alta e' > 0 e > quello della base (b).
## Previsioni
- Senza filtro, uscita C: PF IS tra 0,9 e 1,4: **60%** (BTC ha trend lunghi: la HA in daily li segue; costi bassi in R).
- Pendenza alta meglio di bassa in R medio in IS e OOS per almeno 2 uscite su 3: **45%**.
- Test 2 (continuazione dopo HA contraria con pendenza alta, 10 giorni, IS e OOS): **40%**; piu' probabile e' che la pendenza alta sia gia' un indicatore di trend e la HA contraria non aggiunga niente.
- Un'uscita VALIDATA secondo le porte complete: **8%**.
- Limiti: un solo mercato, un solo ciclo del BTC (2014-2026, pochi trend giganteschi); dati Yahoo non Bitstamp/FTMO; risultato fragile con ~100 operazioni.

## RISULTATI (`backtest_runner/simulatore/btc_d1_scalper_pendenza.py`, BTC-USD D1 Yahoo 2014-09 -> 2026-11, IS fino al 25/03/2023)
**Test 1, il filtro pendenza: NON TESTABILE come ingresso.** L'incrocio EMA9/21 avviene quando le bande sono ancora piatte o stanno girando: 87 segnali su 106 (IS) cadono nel terzile di pendenza BASSA, 18 nel medio, **1 nell'alto (0 in OOS)**. Il filtro "prendi solo con bande molto inclinate" avrebbe tolto quasi tutti i segnali. (I segnali nella zona piatta di agosto 2026 negli screen sono la regola, non l'eccezione.)
**Uscite, tutte le operazioni:**
| uscita | IS | OOS |
|---|---|---|
| A (SL 1,5 / TP 2 ATR) | n 85, R +0,11, PF 1,21 | n 42, R +0,53, PF 2,57 |
| B (cambio segnale) | n 103, R +1,96, PF 3,98 | n 53, R +0,91, PF 2,68 |
| **C (cambio colore HA)** | n 106, R +0,22, PF 1,59 | n 53, R +0,00, **PF 1,01** |
**Il cambio colore HA, la tua idea, e' peggiore del cambio di segnale in IS e OOS, e il lato short con la HA e' negativo (IS PF 0,56, OOS 0,36).** Il long con HA regge (IS 2,77, OOS 1,74).
**Uscita B: passa le porte formali** (IS PF >= 1,5 con >= 100 operazioni; OOS PF > 1,2, R > 0, >= 30 operazioni), **ma e' fragile:** il 66% dell'R totale viene da 5 operazioni su 156 (migliore +52 R, peggiore -3,2 R); senza le prime 5 R medio +0,56, senza le prime 10 +0,17. Anni positivi: 11 su 13 (negativi 2022 -2,1 R e 2025 -2,8 R). **Quasi tutto e' long (+232 R su +250); lo short, senza le prime 3 operazioni, e' -5 R**: e' deriva del BTC (+18.985% buy & hold) catturata da un inseguitore di trend. Nessuno stop: il rischio non e' limitato dal codice.
**Test 2 (HA contraria con pendenza alta):** rendimento a 10 giorni nella direzione della pendenza +2,78% in IS e +3,29% in OOS, contro +1,16% e -0,10% con pendenza bassa e HA contraria: la regola scritta e' soddisfatta. Ma contro i giorni a pendenza alta SENZA HA contraria (+3,04% IS, +1,64% OOS) l'effetto non c'e' in IS e c'e' in OOS: **e' la pendenza alta da sola che porta continuazione, la HA contraria non aggiunge niente di stabile.** Finestre sovrapposte, quindi n sovrastimato; bias rialzista del BTC.
**Controllo su altri mercati D1 (esplorativo, non scritto prima, solo OOS = ultimo 30%, stessa logica e stesso costo 0,10%):** uscita B: Ethereum PF 1,67 (37 op.), oro 1,01, Nasdaq 1,08, DAX 1,05, S&P 0,79. Uscita C (HA): ETH 0,44, oro 0,51, Nasdaq 0,69, S&P 0,71, DAX 1,25. **L'unico mercato con vantaggio e' il cripto (trend lunghi e deriva); sugli altri, nessuno.**
**Previsioni:** PF IS uscita C 0,9-1,4 (60%) -> NO (1,59). Pendenza alta meglio di bassa (45%) -> non valutabile (n=1). Test 2 (40%) -> si' per la regola scritta, no per il confronto piu' severo. Uscita validata alle porte complete (8%) -> **la B passa le porte meccaniche; resta non confermata** (un solo ciclo, concentrazione, deriva).
