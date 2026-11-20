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
