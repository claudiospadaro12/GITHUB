# Piano di test PRE-REGISTRATO v1 — ORB "Metodo Paolo" (R005, rivisto dopo R006)

Stato: **v1 CONGELATA** il 04/11/2026 (hash in `HASH_piano_v1.txt`). Redatta da C0 dopo la critica indipendente di A6 (`agents/A6/critica_piano_test.md`, 10 modifiche bloccanti tutte recepite; le non bloccanti sono nella sez. 11).
**Nessun test eseguito, nessun risultato visto. Nessun lotto/taglia/rischio %: si misura in R e in bps di prezzo.** L'esecuzione richiede l'OK esplicito di Claudio e una reimplementazione indipendente.

## 1. Domande e perimetro
- **Q1 (unica confermativa).** Il nucleo oggettivo del metodo, operazionalizzato come V1 (sez. 3), ha un'aspettativa netta positiva sul Nasdaq?
- Q2, Q3 (descrittive, con contrasti puliti): quanto pesa "apre fuori" (V2 vs V1), quanto pesa l'ingresso a pendente (V3 vs V2), quanto cambia con le uscite del nostro live (V4 vs V1).
- **Fuori portata (NON TESTATI, non "falliti")**: contesto (medie, SuperTrend, VWAP, volumi, trend), resistenze H1/H4, retest, "troppo lontana", TP tecnico, parziale 30–40 pt, gestione manuale: nel PDF mancano definizioni e soglie. DAX: **tolto da questo piano** (orario e durata del box non sono nel PDF, campione corto); eventuale piano separato.
- Ogni esito vale per **la nostra operazionalizzazione V1**, mai per "il metodo di Paolo" (non falsificabile, A6). S&P non entra nei criteri; se eseguito è solo descrittivo e non indipendente (stesso mercato).

## 2. Dati, orari, controlli di conformità
- Dati: Nasdaq `_EXT` M1 2010–2026 (nome simbolo e sha256 dei file da registrare al freeze di esecuzione, sez. 8). Quote Bid.
- **Mappatura orario** (apertura cash 09:30 New York → ora server BCM GMT+1 fisso): **14:30 server se gli USA sono in ora legale, 15:30 se in ora solare**, calendario USA (2ª domenica di marzo – 1ª domenica di novembre), indipendente dall'Italia. Tabella di collaudo obbligatoria con i 4 casi: (a) USA e Europa entrambi in ora solare → 15:30; (b) USA legale, Europa solare (es. 8–28/03/2026) → 14:30; (c) entrambi legali → 14:30; (d) Europa tornata solare, USA ancora legale (es. 26/10/2026) → 14:30. Fine sessione forzata = 15:55 New York.
- Calendario NYSE congelato al freeze: festivi e mezze giornate (chiusura 13:00 ET) **esclusi** con elenco allegato.
- **C1 (gate, senza P&L).** Per ogni anno × regime (a–d) si calcola il volume tick medio per minuto-server nella finestra 13:30–16:30 server; il picco deve cadere entro ±1 minuto dall'apertura prevista. Periodo non conforme → escluso e riportato; se i giorni esclusi superano il 25% del totale → esito INCONCLUSIVO.
- **C2 (gate).** Buchi nei dati (giorni con meno del 95% dei minuti attesi tra apertura e 15:55 NY → esclusi, elenco riportato); allineamento M5 ai confini dall'apertura.
- **C3.** Spread presente nei file? Se no, solo scenari di costo (sez. 4).

## 3. Specifica delle varianti (congelata)
Comuni: un solo trade al giorno, il primo segnale valido; entrambe le direzioni; box = max/min delle M1 nella finestra [09:30, 09:45) NY, ombre incluse, scartato se ampiezza = 0; M5 costruite da M1 con confini a 5 minuti dall'apertura; stop senza buffer; segnali ammessi con ingresso non oltre le 11:30 NY; chiusura forzata alle 15:55 NY a mercato; gap su stop/target: si esegue al peggiore tra prezzo dello stop e apertura della M1 successiva (target: al prezzo del target, senza miglioramento).
- **V1 (primaria)**: M5 con **apertura e chiusura oltre lo stesso bordo con disuguaglianza stretta**. Poiché la M5 delle 09:45 apre per costruzione dentro il box, V1 richiede in pratica **una chiusura M5 fuori e poi una M5 che apre e chiude fuori**: **primo ingresso possibile 09:55 NY**. Ingresso a mercato all'apertura della M1 successiva alla chiusura della M5; stop = bordo opposto; TP = 1R.
- **V2**: basta che la **chiusura** della M5 sia oltre il bordo (anche la prima delle 09:50). Ingresso dalle 09:50 NY.
- **V3**: ordine pendente al bordo (tocco, nessun requisito di candela, spike inclusi); fill al bordo (se la M1 di tocco apre oltre il bordo, all'apertura); stesso stop e TP 1R. Nessun limite di ingresso prima delle 09:45.
- **V4**: segnali di V1, ma **stop a `entry − 0,5×box` (long; speculare short) e TP a `entry + 1,5×box`** = 3R esatti, come nel live. **V4 è in-sample per costruzione se questi parametri derivano da un'ottimizzazione già fatta sugli stessi file `_EXT` (domanda aperta per Claudio)**: va letta solo come descrizione.
- **V5**: V1 con TP 2R (sensibilità sul target).
Nessuna variante aggiunta dopo aver visto i numeri; ogni nuova variante = nuovo piano e nuova registrazione. Nessuna soglia di distanza, box massimo o filtro di contesto.

## 4. Costi e intra-barra
- Costo round turn in frazione del prezzo: **riferimento 2 bps**; sensibilità 0, 1 e 3 bps. Si riporta sempre il **costo di pareggio** (bps a cui l'aspettativa si annulla) e la quota di trade con barra ambigua (stop e target nella stessa M1).
- Caso intra-barra di riferimento: **stop prima**; si riporta anche **target prima**.
- Gli spread reali, se assenti nei file, non sono noti: i bps sono uno scenario, non una misura (con indici cresciuti ~10× dal 2010, 2 bps sono prudenti per gli anni recenti e generosi per i primi).

## 5. Statistica e verdetto — UNA sola cella confermativa
**Cella**: V1, Nasdaq, costo 2 bps, caso stop-prima, periodo intero 2010–2026 (giorni conformi).
- Metrica: aspettativa netta E in R per trade; IC 95% bootstrap a blocchi per giorno (10.000 ricampionamenti, seme fisso). Nessun Holm: il verdetto riguarda una cella; tutto il resto (V2–V5, costi 0/1/3, target-prima, metà A/B, contrasti) è **descrittivo** con IC, senza verdetto e senza correzione.
- Metà A (2010–2017) e metà B (2018–2026) sono **sottoperiodi di stabilità, non fuori campione** (nulla è tarato sui dati): servono a vedere se il segno regge, non a validare.
- Statistiche secondarie: win rate, profit factor, MAE/MFE, concentrazione del **profitto netto** nei 10 giorni migliori scalata per n (quota osservata vs quota attesa con n giorni di trading, riportata, senza soglia pass/fail rigida: giudizio nel referto), numero trade.
- **Albero dei verdetti (ordinato, il primo ramo vero vince):**
  1. Gate non superato (freeze, C1, C2, C6) → **INCONCLUSIVO (tecnico)**.
  2. Semi-ampiezza dell'IC 95% di E > 0,10 R (potenza insufficiente) → **INCONCLUSIVO (potenza)**. [Con sd(R)≈1 serve n ≳ 400 per ±0,10 R; ±0,07 R richiede n ≈ 800.]
  3. Estremo superiore dell'IC 95% < 0 → **SVANTAGGIO RILEVATO**.
  4. Estremo inferiore dell'IC 95% > 0 **e** E > 0 in entrambe le metà **e** E > 0 anche nel caso target-prima **e** C4 e C5 superati → **VANTAGGIO RILEVATO (per V1, a 2 bps)**.
  5. Estremo inferiore dell'IC 95% > 0 ma almeno una delle condizioni del ramo 4 non soddisfatta → **INDIZIO**.
  6. IC 90% di E interamente dentro [−0,05 R; +0,05 R] → **EQUIVALENTE A ZERO** (test di equivalenza, non semplice assenza di prova).
  7. Altrimenti → **ASSENZA DI PROVA** (né vantaggio né equivalenza dimostrati).
  Il collaudo dell'albero con 8–10 esiti fittizi è parte del freeze di esecuzione (sez. 8), **NON_ESEGUITA** ora.
- Un controllo non eseguito non è superato.
- **Controlli di confronto**
  - **C4 (permutazione).** Sugli stessi giorni/segnali di V1 si permutano le direzioni mantenendo la quota di long e si risimula con la geometria speculare (stop/TP sul lato scelto); 2.000 permutazioni, seme fisso. **Superato** se E osservata supera il 95° percentile della distribuzione permutata. Nessuna "stessa durata" ex post.
  - **C5 (placebo temporali).** V1 con box spostato di +60, +120 e −60 minuti rispetto all'apertura (solo finestre con dati). **Superato** se E osservata > max dei tre placebo e nessun placebo ha IC 95% inferiore > 0.
  - **C6 (reimplementazione).** Agente indipendente da chi scrive il codice principale, solo dalla specifica congelata; accordo ≥ 99% sui trade (data, direzione, ingresso, uscita) prima di leggere l'esito; differenze spiegate o la cella non conta.

## 6. Previsioni di C0 (scritte prima; non misurate)
1. V1 ha segnali nel 15–40% delle sedute conformi (incertezza alta; il primo ingresso possibile è 09:55).
2. E lorda di V1 entro ±0,05 R da zero; E netta a 2 bps ≤ 0.
3. **V2 entra prima di V1 (dalle 09:50) e ha più trade**; E netta di V2 non migliore di V1.
4. V3 ha più trade e più stop da spike; E netta ≤ V2.
5. V4 ha win rate molto più basso di V1; nessuna previsione sul segno di E.
6. Il benchmark direzionale "solo long" (descrittivo) è positivo per la deriva del Nasdaq 2010–2026.
7. P(VANTAGGIO RILEVATO per V1) ≤ 5% (con un edge netto vero di +0,05 R la potenza della cella è comunque bassa, ~3%); P(ASSENZA DI PROVA o EQUIVALENTE A ZERO) ≥ 80%.
Le previsioni sbagliate vengono dichiarate nel referto.

## 7. Cosa NON si può concludere comunque
Un esito su V1 non dice nulla su contesto, livelli, gestione manuale e quindi sul metodo completo di Paolo; non si estende a DAX/S&P/argento; non misura la performance del live (V4 è solo un'approssimazione delle sue uscite).

## 8. Sequenza di freeze ed esecuzione
1. (fatto) Piano v1 congelato con hash.
2. Prima di toccare i dati per C1–C3: congelare **hash dei dati** (file `_EXT`) e **hash del codice** principale e del reimplementatore; fase **diagnostica senza P&L** (C1, C2, C3, collaudo mappatura orari, collaudo albero su esiti fittizi).
3. Gate: se la fase diagnostica fallisce → INCONCLUSIVO (tecnico), nessuna lettura di P&L.
4. Esecuzione **unica**. Un bug corretto dopo aver visto il risultato è ammesso solo se provato da una discrepanza C6, e si riportano **entrambi** i risultati (prima e dopo); nessun re-run motivato dall'esito.
5. Registro cumulativo di tutte le varianti e celle eseguite.
6. Perimetro: sola lettura sui dati; mai il conto reale 10105439; nessuna modifica agli EA live; eventuali righe VPS con le regole della casa (script pin + sha256 + marker, gate).

## 9. Stato dei controlli
C1 NON_ESEGUITO · C2 NON_ESEGUITO · C3 NON_ESEGUITO · C4 NON_ESEGUITO · C5 NON_ESEGUITO · C6 NON_ESEGUITO · collaudo albero NON_ESEGUITO · R006 critica ESEGUITA (A6) · R008 citazioni ESEGUITO (A7).

## 10. Domande aperte per Claudio (non bloccano il piano)
- I file `_EXT` Nasdaq/S&P sono già stati usati per ottimizzare ABTG_ORB_Ottimizzato (R55)? Se sì V4 resta in-sample.
- Si vuole un piano separato per il DAX (serve orario/durata scelti prima)?
- Si vogliono mandare le 10 domande a Paolo prima di eseguire (consigliato: chiudono i punti ALTA del PDF)?

## 11. Modifiche non bloccanti di A6 non recepite o rinviate
Fill di V3 e gap (recepiti in forma semplice), bid/ask (quote Bid: asimmetria non modellata), minimo di ampiezza del box (non fissato), V5 facoltativo (mantenuta), arrotondamenti, trattamento S&P (descrittivo). Previsioni numeriche per V2–V5 oltre quelle in sez. 6: non scritte.
