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
4. **Finestra 60' / Initial Balance**: mai provata (abbiamo 5' pre, 15', 30',
   35'). Da considerare solo se fade/OR-ATR mostrano qualcosa.
5. **ORB con gap** (solo nei giorni di gap): filtro di contesto, il lab non
   ce l'ha (il GAPFILL dell'Apertura e' un'altra cosa: entra NEL gap).
6. Filtro VWAP + contesto pre-mercato (articolo Fazen): dichiarati assenti in
   R12; da valutare solo se una geometria base torna viva.

## Gia' misurato e chiuso (non riaprire senza fatti nuovi)

- Breakout puro al tocco: perde/pareggia su NASUSD (100+ celle), D30EUR (R11).
- TP 1:1 e stop a meta' range (utenti): bocciati (R9).
- Uscita a tempo secca senza gestione (Fazen): disastro (R12, 48/48 rosse).
- Filtro EMA200: senza direzione (R9); EMA50+0,2% (scheda DAX): pareggio (R11).
- Filtro volume: FUNZIONA ma solo in modalita' chiusura confermata (perimetro
  documentato in R12) e porta al pareggio, non all'edge (R8).
