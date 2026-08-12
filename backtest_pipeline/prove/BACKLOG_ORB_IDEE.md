# 📋 BACKLOG ORB - idee raccolte dalle fonti, in attesa del loro round

_Aggiornato 08/08/2026 notte. Regola: prima si chiude la batteria in corso
(R10 oro, R13 edgeful), poi si pesca da qui UN'idea alla volta, con file prova,
ipotesi scritta prima e traguardo PF OOS >= 1,10 / n >= 30. Regola del banco
vergine sempre attiva._

## La scoperta trasversale delle fonti (Build Alpha, 08/08)

Build Alpha chiama il **"Retest + ordine limite" la configurazione a piu' alta
probabilita'** - cioe' ESATTAMENTE il motore RETEST della famiglia Apertura,
l'unica cosa verde sul Nasdaq in FASE M e la ricetta validata su DAX/Dow.
Conferma esterna indipendente della nostra scoperta principale: il breakout
puro non paga, il retest si'. Coerente anche su stop (estremo opposto) e
limite giornaliero di trade.

## Idee NON ancora misurate (in ordine di interesse)

1. **FADE del falso breakout** (Build Alpha setup 2): vendere il rientro nel
   range dopo la falsa rottura. L'EA Apertura ha gia' il ramo `RANGE_FADE`
   (offset del LIMIT oltre l'estremo) quasi inesplorato - si puo' misurare
   SENZA scrivere codice, su NASUSD dove i falsi breakout abbondano (100+
   celle lo dimostrano). Candidato naturale al prossimo round dopo la batteria.
2. **Filtro OR/ATR** (Build Alpha): ampiezza del range normalizzata sull'ATR
   invece che su % fissa del prezzo. Piu' adattivo del min/max % attuale del
   laboratorio. Richiede un piccolo input nuovo nel lab.
3. **Rimbalzo su ORL** (Build Alpha setup 4): comprare il supporto del range
   nei giorni senza breakout. Motore nuovo (mean-reversion dentro il range).
3b. **Target 2x/3x l'ampiezza del range** (ORB Setups): R13 arriva a 1,5x -
   se la direzione OOS di R13 punta verso l'alto, 2x/3x e' il vicinato del
   giro successivo (coerente con R9: piu' il target e' ambizioso, meglio OOS).
4. **Finestra 60' / Initial Balance**: mai provata (abbiamo 5' pre, 15', 30',
   35'). Da considerare solo se fade/OR-ATR mostrano qualcosa.
5. **ORB con gap** (solo nei giorni di gap): filtro di contesto, il lab non
   ce l'ha (il GAPFILL dell'Apertura e' un'altra cosa: entra NEL gap).
5b. **ORB sull'apertura di LONDRA** (LiteFinance): forex/oro sull'apertura
   della sessione europea (08:00 IT = 07:00 server) invece che su New York.
   Sessione nuova, non solo mercato nuovo. Il lab lo fa gia' via input orari.
   Caveat: il forex in FASE 0 non ha mai mostrato edge con nessun motore.
5c. **Secondo tentativo dopo il primo stop** (LiteFinance): rientro con
   tetto a 2 stop/giorno. Variante del OneTradePerDay, servirebbe un input
   nuovo (max stop al giorno). Solo se un motore base torna vivo.
6. Filtro VWAP + contesto pre-mercato (articolo Fazen): dichiarati assenti in
   R12; da valutare solo se una geometria base torna viva.

## Potenziamenti del METODO (da Build Alpha "errori comuni", 08/08)

La pagina sulla validazione descrive il nostro metodo punto per punto (OOS,
walk-forward, limite trade/giorno, trappola delle 2000 combinazioni = la nostra
regola del banco vergine e i 12 ribaltamenti). Tre strumenti che NON abbiamo:

- **Monte Carlo sulla sequenza dei trade**: stima la gamma dei drawdown
  possibili rimescolando l'ordine dei trade. Fattibile in Python, MA serve
  l'elenco dei singoli trade: oggi l'export OnTester scrive solo il riepilogo.
  Prerequisito: estendere l'export con le righe per-trade (binario D allargato).
- **Benchmark contro ingressi casuali**: stessa gestione, ingressi random -
  se l'EA non batte il caso, l'edge e' della gestione o non esiste. Fattibile
  come EA-ombra con ingresso a orario fisso/random. Idea potente e onesta.
- **Consapevolezza del regime** (trend vs mean-reversion): i nostri verdetti
  valgono sul regime 2024-2026; un filtro ATR/ADX di regime e' nel lab gia'
  possibile (ATR filter esiste nell'Apertura). Da considerare DOPO che
  qualcosa mostra un edge - un filtro non salva un motore morto.

## Gia' misurato e chiuso (non riaprire senza fatti nuovi)

- Breakout puro al tocco: perde/pareggia su NASUSD (100+ celle), D30EUR (R11).
- TP 1:1 e stop a meta' range (utenti): bocciati (R9).
- Uscita a tempo secca senza gestione (Fazen): disastro (R12, 48/48 rosse).
- Filtro EMA200: senza direzione (R9); EMA50+0,2% (scheda DAX): pareggio (R11).
- Filtro volume: FUNZIONA ma solo in modalita' chiusura confermata (perimetro
  documentato in R12) e porta al pareggio, non all'edge (R8).


## Idee ORO da fonte esterna (articolo ThinkMarkets, portato da Claudio il 10/08)
Setacciate col solito criterio: solo cio' che e' falsificabile al banco.
1. **London breakout sull'oro** -- range asiatico fino alle 08:00 GMT,
   rottura con conferma di candela 30m/1h. Cugino diurno del box
   notturno promosso (R17); la voce "sessione Londra" del backlog ORB
   ora ha una seconda fonte. Da imbuto completo, prova dedicata.
2. **Filtro rapporto oro/argento** (XAGUSD disponibile su BCM):
   >80 = oro caro/trend stanco, <60 = trend-friendly. Gemello
   concettuale del filtro S&P del MaxMin DAX. Ipotesi misurabile:
   il box notturno oro filtrato col ratio batte il box nudo?
   ATTENZIONE: non si tocca la cella promossa 250/H2 -- eventuale
   filtro solo come NUOVA variante da walk-forward.
NOTA: il resto dell'articolo (ATR sizing, stop dinamici, vola 150-200$)
CONFERMA le scoperte gia' misurate in NOTTE_ORO; le 4 strategie
generiche EMA20/50+RSI sono il GoldenCross sotto altro nome (capitolo
chiuso con 9 lanci, R2/R4/R20).

## Idee dall'EA dell'amico di Claudio (NasdaqOpeningBreakout v21, 12/08)
_Solo parametri visti (2 screenshot), niente codice/risultati. La base
(breakout d'apertura con pendenti sul Nasdaq) e' gia' bocciata 3 volte
dal nostro imbuto (R7, 02/08, R25) e NON ha il filtro volumi (l'unico
edge misurato). Ma DUE idee mai testate da noi meritano il laboratorio:_
1. **REGIME DI VOLATILITA' ADATTIVO** (percentili ATR 20/80 -> offset
   x0,7/x1,5, SL x0,75/x1,5, size dimezzata in alta vol). Seconda
   conferma indipendente dell'idea "OR/ATR adattivo" gia' in backlog
   (Build Alpha #2) -> SALE DI PRIORITA'. Testabile sui nostri Apertura
   con pochi input nuovi.
2. **FILTRO PROSSIMITA' S/R** (no ingressi vicino a livelli del giorno
   prima / numeri tondi / swing; proximity 15pt, merge 10pt). Mai
   misurato nel lab. Tesi: i breakout nati sotto resistenza muoiono li'.
Campanelli annotati: lotto fisso (MM spento), "v21 OPTIMIZED" (curve
fitting probabile), TradeStartTime 16:25 incoerente con BCM (Nasdaq
apre 14:30 server — chiedere all'amico broker/fuso). Se arrivano .set
completo / .ex5 / risultati, si riapre la valutazione.
