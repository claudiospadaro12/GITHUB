# ABTG_OutOfNoise v1.02 (A2) - sorgente: ABTG_OutOfNoise.mq5, 1336 righe
Tag: FV = FATTO_VERIFICATO (file:riga), INF = INFERENZA, DV = DA_VERIFICARE. Nessuna istruzione per l'agente nel sorgente. Il paper citato non e' stato letto dall'autore (r.20-23): non e' evidenza di vantaggio. Il file dichiara di non essere stato compilato ne' testato (r.96-98).

## Regole (FV)
- Cono di rumore: per ogni barra della seduta, media su 14 sedute di |close alla stessa posizione oraria / open della seduta - 1| (r.271-287, 663-746). Bande: upper = max(open, close pre-seduta) * (1 + media), lower = min(...) * (1 - media) (r.294-297, 699-700, 743-744).
- Ingresso: a barra chiusa [1], close fuori banda (strettamente) -> mercato alla barra successiva; mai sulla prima barra della seduta (r.531-562, 304-309). Solo dentro la seduta (r.552).
- Uscita: close < max(VWAP, upper) per il long, close > min(VWAP, lower) per lo short, oppure grilletto opposto (r.317-322, 585-599); VWAP su close pesato col tick volume (r.329-343, 779-780). SL vero al broker: ATR(14) x 1,5, con pavimento 0,5 ATR e stops level (r.165-168, 813-834). Nessun TP.
- Flat a fine seduta (default 16:30 server) con stop di OnTick fino a mezzanotte (r.158-159, 873-899). Rischio 0,65%, tetto 2 ingressi al giorno, una posizione per magic, magic 773500, commento "NOISE" (r.172-173, 183-184, 540-545, 551).

## Controlli R2
Barra in formazione: NO (shift 1 in r.524-531, ATR r.805). Orari/ora legale: SI, difetto (vedi 1). Distanze: SL scalato su ATR; unico input in punti fissi e' il pavimento in punti indice, default 0 (r.169). Nuova barra: SI (r.506-511). Stop minimo broker: SI (r.828-833). Spread: filtro opzionale, spento (r.185, 553, 977-981); ingresso a mercato proprio all'apertura barra, quando lo spread e' piu' largo. Ordine rifiutato: solo log (r.859). Magic/commento: SI. Dati futuri: NO (il cono usa solo sedute passate e l'open di oggi).

## Difetti
1. FALSA I TEST, alta: sessione in ora server fissa estiva. DAX 08:00-16:30 e US 14:30-21:00 (r.76-77, 156-159) valgono solo con ora legale; il commento "server un'ora indietro" (r.74) e' sbagliato in inverno (CLAUDE.md: DAX 9, Nasdaq 15:30 server). In inverno la "seduta" parte un'ora prima dell'apertura cash: `open_giorno` e `close_pre` (r.696-697) vengono da barre pre-apertura, le bande sono sbagliate e il flat chiude un'ora prima della fine cash. Per gli USA le tre settimane di sfasamento si sommano. Si risolve con input per periodo senza toccare la logica.
2. FALSA I TEST, media: sui file `_EXT` tickvol=1 e spread=0 (CLAUDE.md): VWAP non pesata e costi nulli; inoltre l'orologio `_EXT` non e' GMT+1 fisso (apertura USA 14:30 anche in inverno, 13:30 in alcune settimane). Vanno usati dati nativi.
3. media: spread non filtrato e ingresso al primo tick della barra (r.553, 848): costo di ingresso nella parte peggiore della barra, con chiusura spesso rapida dalla regola VWAP/upper (INF: la banda si allarga con la posizione oraria, quindi un close che rientra la attiva presto). Con 2 operazioni al giorno il costo e' decisivo.
4. minore: commento r.172 dice "% dell'equity", il codice usa ACCOUNT_BALANCE (r.953). Lotto minimo forzato (r.974). Include `ABTG_PausaGuardian.mqh` (r.126) assente dai materiali (DV). `InpMT5PerPuntoIndice`=100 (r.180) da verificare sul D30EUR; incide solo su pavimento in punti indice ed export.
5. INF: su M1 `need` e' limitato a 20.000 barre (r.676): meno di 14 giorni di 1440 barre, quindi il riscaldamento non si chiude (stesso baco che la v1.01 ha risolto su M15). M5 e M15 non toccati. La v1.02 e' solo diagnostica (r.100-120).
6. minore: reset e tetto giornalieri su `day_of_year` del tempo server (r.500, 926).

## Mediazione / griglia
NO: una posizione (r.540-545), SL al broker, tetto 2 al giorno, flat serale; nessuna aggiunta. Dopo uno stop si puo' rientrare nello stesso verso una volta (r.551): rischio contenuto.

## Misurabilita'
Indici nativi BCM D30EUR/NASUSD/U30USD 2024-26 (M15, circa 2,3 anni), FTMO CSV M1 Nasdaq/S&P dal 12/2017 e Dow dal 2019 (orari FTMO = IT + 1, tickvol DV). Il cancello S0 dell'EA (mediana del take in punti indice prima del PF, r.31-35) e' gia' previsto dall'export (r.1165-1247). Storici piu' lunghi non esistono nativi.

## Ipotesi (criteri scritti prima; cancelli di campagna come in MeanRevert)
- H1 baseline per stagione: DAX 08:00-16:30 server in estate e 09:00-17:30 in inverno, US 14:30-21:00 e 15:30-22:00, settimane di sfasamento escluse e riportate a parte. Accetta se mediana del take (punti indice) > spread medio + 20%, IS PF >= 1,30, V1/OOS >= 1,20, HO > 1,0, plateau del cono {10, 14, 20}. Probabilita': 6%.
- H2 solo flat di fine seduta, senza uscita VWAP/upper: accetta che il trail danneggi se PF senza trail >= PF con trail + 0,10 su >= 2 indici su 3. Probabilita': 30%.
- H3 lati separati (input r.174-175): accetta solo se long e short hanno PF > 1,0 insieme su >= 2 indici in IS e OOS. Probabilita': 12%.

## Classe: A con protocollo (misurare subito, separando estate e inverno e solo con dati nativi)
I difetti che falsano il test (1, 2) si risolvono con input e scelta dei dati, senza cambiare la logica di ingresso (R5). Va elencato nel referto che l'EA vivo richiede il cambio di orari due volte l'anno piu' le settimane USA.
