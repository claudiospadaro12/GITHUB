# Fibo H4 e Media 200 sui cross forex: criteri scritti PRIMA dei numeri (25/11/2026)

**Fonte:** lezioni TurboScribe 18-20 (Fibo H4) e 21-25 (Media 200), copiate in `report/POSTNEWS_dati/lezioni_fibo_ema/`. Entrambe sono **semi-discrezionali** ("fine trend", livelli tecnici, "come arriva la candela", stop su supporti): qui si fissa UNA traduzione meccanica. Cio' che resta discrezionale (livelli tecnici, spike nella prima mezz'ora, news) NON e' simulato e va dichiarato: un risultato negativo vale per la traduzione meccanica, non prova che l'occhio di Claudio non aggiunga valore.

**Dati:** H1 BCM di 10 coppie (EURUSD, GBPUSD, USDJPY, AUDUSD, USDCAD, USDCHF, NZDUSD, EURJPY, GBPJPY, EURGBP), `EXPORT_H1_BCM_20261124`, dal 2005. H4 costruito dall'H1 ancorato alla mezzanotte server (GMT+1 fisso). Spread fisso per coppia (EURUSD 0,8 pip, USDJPY 1,0, GBPUSD 1,2, AUDUSD 1,2, EURGBP 1,5, USDCAD 1,5, USDCHF 1,5, NZDUSD 1,8, EURJPY 1,8, GBPJPY 2,8). Slippage 0,5 pip su SL/BE; nessuna sul limite e sul TP.

## Regole comuni
- Scansione alle **08:00 server** (barra H4 chiusa 04:00-08:00), **solo lunedi-giovedi**. Ordini pendenti cancellati alle **18:00 server** se non eseguiti. Nessuna posizione nel weekend: chiusura al close della barra H1 delle **20:00 server di venerdi**.
- Ordini limite eseguiti sull'H1 (buy se minimo + spread <= livello; sell se massimo >= livello). Nella barra di scatto conta solo lo SL (se raggiunto); il TP non viene accreditato nella barra di scatto. SL prima di TP nella stessa barra.
- Due ordini per setup: **A (1/3 della size) sul lato vicino al prezzo, B (2/3) piu' lontano**, entrambi con lo stesso SL. TP1: chiusura di meta' posizione e SL a pareggio; TP2 sulla meta' restante.
- Esito in **R** = pip / distanza dello SL di ogni ordine, pesato 1/3 e 2/3. Unita' di conteggio: il setup con almeno un ordine eseguito.

## Media 200 (H4) - traduzione
- EMA200 e EMA14 (esponenziali sul close) e ATR14 su H4. **Modo long** se prezzo (close H4 chiusa) >= EMA200 + **50 pip** e pendenza EMA200 positiva (EMA200 ora > EMA200 20 barre H4 prima); **modo short** speculare.
- Long: A = buy limit a EMA200 + 10 pip, B = buy limit a EMA200 - 10 pip (distanza 20 pip come in lezione 22). SL = B - **2 ATR** (lezione 23: "34 pip a 2 ATR"). TP1 = EMA14 al momento della scansione (deve stare sopra A + 5 pip, altrimenti nessun setup). TP2 = TP1 + 1 ATR. Short speculare.
- **Varianti di sensibilita' (non selettive):** SL 1 ATR; distanza minima 70 pip; senza filtro di pendenza.

## Fibo H4 - traduzione
- Candela X entro le ultime 12 barre H4 chiuse, **completamente coperta (massimo e minimo compresi) dalla barra successiva o dall'unione delle due successive**. "Fine trend": nelle 6 barre prima di X il movimento netto (close[X-1] - close[X-7]) e' >= **1,5 ATR14** e X segna il nuovo minimo (trend short) o massimo (trend long) delle 6 barre; la barra di copertura chiude in senso opposto al trend; range di X <= 2 ATR (niente candele ampie). Il pattern e' valido solo se l'ultima barra di copertura e' tra le ultime 6 H4 chiuse (pattern fresco) e si opera **una volta sola per pattern**.
- Livelli: R = massimo - minimo del pattern (X piu' barre di copertura). Zone di ingresso: **1,78-1,88** e **2,78-2,88** dall'estremo opposto (sotto: massimo - z*R, buy limit; sopra: minimo + z*R, sell limit). Per ogni zona: A al bordo vicino (1,78 / 2,78), B al bordo lontano (1,88 / 2,88). Una zona e' usata solo se il bordo vicino dista dal prezzo **>= 50 pip** (lezione 19: "50-60 pip").
- TP2 = livello 1,00 di Fibonacci (l'estremo del pattern). TP1: per la zona 2 il bordo lontano della zona 1; per la zona 1 il punto medio fra il bordo vicino e TP2. **SL primario = rapporto 1:1 verso TP1** (lezione 20: "posso inserire un rapporto 1 a 1 di rischio rendimento"), cioe' B - (TP1 - B).
- **Varianti di sensibilita':** SL al livello 4,236 (lezione 20: "sotto il 423"); distanza minima 35 pip.

## Celle, periodi e soglie
- Cella primaria = **sistema aggregato sulle 10 coppie** (le coppie sono correlate: il campione effettivo e' minore del conteggio). Per ogni strategia 1 cella primaria + 3 varianti di sensibilita'; le tabelle per coppia sono descrittive.
- **IS 2005-2015:** PF(R) >= 1,3 con >= 150 setup. **OOS 2016-2021:** PF > 1,2 con >= 80. **Hold-out 2022-2026:** PF > 1,0 con >= 50. Candidata = tutti e tre sulla cella primaria. Soglie non abbassate. Una variante che passa mentre la primaria no non e' una candidata (si segnala e si fa un nuovo test con criteri propri).

## Previsione (scritta ora)
Nessuna candidata. Media 200: PF 0,90-1,10 (le EMA200 su oro e indici sono gia' PF 0,68-0,97; il vantaggio dichiarato dal corso e' "statisticamente provata" senza numeri). Fibo H4 meccanizzato: PF 0,85-1,10; il rapporto 1:1 con ingressi limite contro-tendenza ha un'aspettativa vicina a zero meno i costi. Probabilita' di una candidata: circa 10% per ciascuna.
