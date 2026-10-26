# Quanti giorni ogni EA tocca il drawdown giornaliero di una prop FTMO: criteri scritti PRIMA dei numeri (26/10/2026)
**Natura: CRITERI. Non controllata da agenti.** Richiesta di Claudio (26/10): due tipi di EA: (A) quelli che vanno sul **conto personale reale** (con o senza Guardian: dove c'e flottante, il Guardian che chiude ha causato perdite) e (B) quelli a **DD basso** per le prop, dove un giorno ogni tanto che sfora il limite giornaliero lo gestisce il Guardian/agente. Domanda: **per ogni EA gia analizzato, quanti giorni toccherebbe il DD giornaliero FTMO?** Anche se sono anni di oro al rialzo. Nessuna scelta di EA o di lotto e mia.

## Limite dichiarato: con i file che abbiamo si misura il REALIZZATO, non il flottante
I report del tester contengono le operazioni **chiuse** (con data/ora di chiusura), non l'equita intraday. FTMO misura il limite giornaliero sull'**equita** (flottante compreso): quindi il numero di giorni che ottengo e un **MINIMO (limite inferiore)**: il vero e uguale o piu alto. Per gli EA con flottante (Arena, SomaGold, Vortex, SixtyNine) la distanza puo essere grande. L'equita intraday richiede o un nuovo giro del tester con registrazione dell'equita o le barre M1 + l'accoppiamento delle posizioni (fattibile in modo esatto solo per gli EA con una posizione alla volta): lo propongo dopo, non lo faccio ora.

## Definizioni (scritte ora)
- **Giorno FTMO:** da mezzanotte CE(S)T. Il server BCM e UTC+1 fisso: d'inverno (CET) il giorno FTMO = giorno del server; d'estate (CEST, ultima domenica di marzo - ultima domenica di ottobre, UTC+2) mezzanotte FTMO = 23:00 del server. Le chiusure si attribuiscono al giorno FTMO (ora del server + 1 ora in estate).
- **Perdita giornaliera realizzata** = somma di profitto + commissioni + swap delle operazioni chiuse (e delle commissioni di apertura) in quel giorno FTMO, se negativa.
- **Tre soglie, come % del saldo a inizio giorno:** 3%, 4%, **5%** (il limite FTMO del nostro piano, `METRO_PROP.md`; come FTMO misuri esattamente la base - saldo o equity di mezzanotte, deposito iniziale fisso - NON VERIFICATO dal regolamento qui). In piu, solo per le corse a 80.000 EUR: **giorni con perdita >= 4.000 EUR** (5% FISSO del capitale iniziale, la lettura piu letterale di una prop da 80K). Con l'auto-lotto il saldo cresce e la soglia fissa pesa di piu nel tempo: lo scrivo.
- Dati: le corse a 80.000 EUR (8 EA del 25/10, SomaGold, Microedge e Umbra con la guardia del venditore, Prop Firm Gold EA e Smart Gold Hunter del 19/10) e tre mesi di Arena a 5.000 (lug-set 2026). Le corse a 5.000 danno gli stessi rapporti % (lotti proporzionali): non le ripeto.

## Cosa si riporta per EA
Giorni con almeno un'operazione chiusa, giorni sopra 3/4/5% (e, a 80K, sopra 4.000 EUR), **peggior giorno** (% e EUR), peggior giorno **solo nei primi 6 mesi** (quando il lotto e ancora quello iniziale), e le date dei giorni oltre il 5%. Lettore `backtest_pipeline/leggi_giorni_dd_prop.py`, congelato prima dei numeri, con `--autotest`.

## Previsioni dichiarate ORA
- G1: nessun EA ha giorni realizzati oltre il 5% a parte Arena e Vortex Turbo: 55%.
- G2: Arena ha almeno un giorno realizzato oltre il 5% in ognuno dei mesi agosto e settembre 2026: 70% (28/09 -5.809 su un saldo di circa 5.000 e 05/08 -4.038 su circa 5.000: gia noti).
- G3: tra gli EA a 80.000 almeno 5 hanno il peggior giorno realizzato sotto il 3%: 60%.
- G4: i giorni oltre il 4.000 EUR fisso a 80K sono piu numerosi di quelli oltre il 5% relativo per almeno 2 EA: 60%.
Nessuna promozione o scarto: una lettura di quanto spesso l'EA toccherebbe il muro.
