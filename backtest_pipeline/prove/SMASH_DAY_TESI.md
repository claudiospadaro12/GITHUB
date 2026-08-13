# TESI — LE PUNTE DI LARRY: SMASH DAY + OOPS (scritta PRIMA di ogni numero, 13/08/2026)

## Le fonti (tre, arrivate il 13/08 — e quanto valgono)
1. **Larry Williams, "Long-Term Secrets to Short-Term Trading"**
   (fonte primaria, pattern pubblicati): Smash Day, Oops, first
   profitable open, regole di money management.
2. **Trascrizione Andrea Unger sull'OOPS** (fornita da Claudio):
   definizione operativa completa: gap up oltre il massimo di ieri ->
   se il prezzo torna al massimo di ieri, SHORT su quel livello
   (specchio sul gap down) -> stop parametrico -> uscita first
   profitable open (o chiusura in serata se positivo). Dove vive oggi:
   mercati che CHIUDONO (DAX: chiude 22:00 apre 8:00 = gap quasi ogni
   giorno) e aperture del lunedi'. Filtro che lo migliora: gap MINIMO
   quantificato. "Le aperture sono dei polli, le chiusure dei
   professionisti."
3. **Riassunto del libro** (fornito da Claudio): regole quadro (tagliare
   le perdite, stop sempre, i due grandi errori) + il concetto di
   CONTRAZIONE DI VOLATILITA' come premessa dei movimenti direzionali
   (= il nostro squeeze/Bulge della BB e i box del MaxMin: gia'
   coperto, resta come eventuale filtro futuro, NON in questo EA).
4. Articolo WeBank "Smash Day Pro" (divulgativo): variante intraday-
   fail dello Smash e contesto (volatilita', livelli; COT/cicli =
   filtri del corso Pro, NON alla prima passata).
5. **Money.it "Oops Bearish/Bullish" + traders-mag.it** (forniti da
   Claudio): definizione fine dell'Oops — pattern D1 intorno a
   massimi/minimi rilevanti DOPO un movimento direzionale; ingresso
   al raggiungimento dell'estremo di ieri; **SL oltre l'estremo del
   GIORNO DEL GAP** (la candela che apre il pattern); chiusura alla
   prima open in guadagno, altrimenti stop o gain. Esempio sul DAX.
6. **Video team Unger — BACKTEST dell'Oops su DAX future 2010-oggi**
   (fornito da Claudio, il pezzo che vale di piu'): setup base e con
   filtro 15 punti, stop 2000 EUR, uscita first profitable open.
   VERDETTO LORO: funzionava fino a OTTOBRE 2022 (netto storico 163k,
   long meglio), poi declino inesorabile — 2023/2024/2025 in FORTE
   perdita, oggi sul max drawdown. Causa indiziata: sessione estesa
   ~23h (dal 2019) digerita dagli operatori -> niente gap giornalieri
   -> pattern morente. "Nulla e' per sempre."
7. **Pietro Froio (ago 2026) — test Oops su E-mini S&P 500, dati 1'**
   (fornito da Claudio, parziale: articolo a pagamento): definizione
   coerente con le fonti 2/5 (gap down + rientro = LONG; gap up +
   rientro = SHORT). Numeri: su 796 aperture fuori range in sessione
   RTH, il 66,1% produce il rientro/trigger (195 long / 325 short
   completi). NON e' una strategia (niente stop/target/costi). Il
   titolo dichiara che **il risultato cambia parecchio fra lato long
   e lato short** (conclusione dietro paywall).
8. Scheda divulgativa OOPS (fornita da Claudio, probabile sintesi
   AI/sito): NESSUNA regola nuova — conferma integrale di 2/5/7
   (definizione, gap minimo, stop oltre l'estremo del gap, first
   profitable open, contesto di trend come filtro opzionale). Vale
   come quorum sulle definizioni, non come fonte autonoma.
9. **INDICATORE UFFICIALE DEL CORSO: "ABTG - A Cena Con Larry" (MT5)**
   (trovato da Claudio sulla sua piattaforma, 13/08): disegna i
   LIVELLI delle "punte" multi-timeframe (Monthly->M1, tolleranza in
   points, 270 barre, selezione "con piu' opposing"). Molto probabile
   implementazione dei "ringed highs/lows" di Williams. SCOPERTA
   CHIAVE: le "punte di Larry" del CORSO sono (anche) LIVELLI di
   struttura per il cost-to-cost (tradare DENTRO il range, da punta a
   punta), NON solo i pattern Smash/Oops. Il capitolo ha DUE RAMI:
   (A) Smash/Oops = questa tesi; (B) punte-livelli + cost-to-cost =
   ramo NUOVO, da istruire con: file dell'indicatore (mq5 o ex5) +
   regole d'uso dalle live. Trappola gia' nota: il cost-to-cost e'
   mean reversion dentro il range — parente del rimbalzo su ORL
   (backlog ORB n.3), da non confondere con questo EA.
10. **File "EM__Indicator__Punte_Di_Larry__MT5.ex5"** (caricato da
   Claudio, 13/08 — archiviato in `mql5/Indicators/esterni/`):
   SECONDO indicatore del corso su Larry (oltre ad "A Cena Con
   Larry"). Ex5 CIFRATO (17.948 byte, build moderna: leggibile solo
   il copyright): logica NON estraibile dal binario. Per ricostruirla
   servono: screenshot della finestra INPUT + screenshot di un
   GRAFICO con l'indicatore attivo (dal comportamento visivo si
   ricava la geometria, come per il Pine di Claudio). Ramo B resta
   in istruttoria.

## ⚠️ ATTESE RIVISTE dopo la fonte 6 (scritte PRIMA dei nostri numeri)
- La nostra finestra (2024-2026) cade INTERAMENTE nel periodo morto
  dell'Oops secondo il test Unger: ATTESA = Oops DAX ROSSO. Se il
  nostro scan lo boccia, e' una CONFERMA incrociata; se lo promuove,
  massimo sospetto (regime? differenze CFD/future?).
- Sul CFD BCM il D30EUR quota anche di notte (il MaxMin notturno ci
  lavora): NIENTE gap giornaliero -> sul nostro broker l'Oops esiste
  quasi solo il LUNEDI' = quasi-doppione del GapFill. Frequenza attesa
  bassissima; il funnel lo dira'.
- Il baricentro del capitolo si sposta sullo SMASH DAY (modi 0/1), che
  NON dipende dai gap di sessione e resta testabile sui mercati 24h.

## Il meccanismo comune (ipotesi)
Tutte le "punte" sono TRAPPOLE del breakout giornaliero: un'estensione
oltre l'estremo di ieri (in apertura per l'Oops, in giornata per lo
Smash) che NON tiene. Chi ha inseguito e' intrappolato; la sua uscita
alimenta il movimento contrario. Fratello daily del fade intraday
(RANGE_FADE M5 bocciato: prova DIVERSA, dichiarato) e cugino del
nostro gap-fill weekend (l'Oops del lunedi' e' quasi lo stesso trade:
SOVRAPPOSIZIONE DA MISURARE, vedi trappole).

## UN EA, TRE PATTERN (InpPatternMode, decide il tritacarne)
- **MODO 0 — SMASH "libro"**: ieri chiusura OLTRE l'estremo dell'altro
  ieri (naked close: chiude sotto il minimo precedente = setup LONG;
  sopra il massimo = setup SHORT). Oggi: stop order sull'estremo
  OPPOSTO della candela smash (buy stop sul suo massimo / sell stop
  sul suo minimo). La trappola scatta al riassorbimento.
- **MODO 1 — SMASH "punta" (corso/articolo)**: ieri rottura INTRADAY
  dell'estremo dell'altro ieri MA chiusura rientrata nel terzo opposto
  del proprio range. Oggi: stop order di conferma nella direzione
  della chiusura.
- **MODO 2 — OOPS (Unger/Williams)**: OGGI il mercato apre in gap
  oltre l'estremo di ieri (open > massimo di ieri = setup SHORT;
  open < minimo di ieri = setup LONG). Ingresso: LIMIT esattamente
  sull'estremo di ieri violato (il rientro nel range = l'"oops").
  Filtro: gap minimo in frazioni di ATR(D1) (Unger: quantificare
  il gap lo migliora). Il pendente scade a fine giornata se non
  riempito.

## Uscite (InpExitMode, comune ai tre)
- **MODO 0 — first profitable open (Williams)**: alla prima APERTURA
  di candela D1 con posizione in profitto -> chiusura a mercato.
  (Robustezza CFD: "apertura" = open della candela D1 del broker.)
- **MODO 1 — R-based**: TP a N x rischio.
- Sempre: SL iniziale parametrico. Default per l'OOPS (Money.it):
  oltre l'estremo del GIORNO DEL GAP; per gli SMASH: oltre l'estremo
  della candela smash. Alternativa ATR-based. MAI in euro fissi (i
  1.500€ di Unger non scalano fra strumenti). Time-stop massimo N
  giorni D1.

## SCELTE NOSTRE dichiarate
- Pattern su barre D1, esecuzione da grafico H1 con pending; un setup
  alla volta per simbolo; rischio % sul conto; magic/commento standard;
  export OnTester + funnel `[LARRY-FUNNEL]` (giorni -> setup rilevati
  per modo -> ordini piazzati -> riempiti -> esiti fill/stop/fpo/time).
- Filtro dimensione della punta/gap in ATR(D1) con minimo E massimo
  (0=off), come nel GapFill: sotto il minimo e' rumore/spread, sopra
  il massimo e' rottura vera (news).
- Allo screening: filtri MINIMI (lezione BB: prima la frequenza).
- **LATI SEPARATI OBBLIGATORI** (fonte 7 + le nostre cicatrici: 10°
  ribaltamento sui lati del Dow, FASE M sul DAX): l'EA ha
  InpAllowLong/InpAllowShort e lo scan LI SPAZZOLA. L'asimmetria
  long/short e' un'attesa dichiarata, non una sorpresa.
- Nota sessioni: il test Froio usa la sessione RTH ricostruita; sui
  nostri CFD la "giornata" e' la candela D1 del broker. Su mercati
  quasi-24h il gap d'apertura D1 e' raro (attesa gia' dichiarata):
  il 66% di trigger di Froio vale per mercati CON sessione.

## Le trappole dichiarate subito
1. **Sovrapposizione con ABTG_GapFill il lunedi'**: l'Oops sul gap
   settimanale e il gap-fill sono quasi lo stesso trade con ingressi
   diversi (limit sull'estremo vs market alla riapertura). Se entrambi
   passassero l'imbuto sugli stessi simboli, la correlazione va
   misurata PRIMA di qualsiasi vivaio (niente doppioni mascherati).
2. Il limit dell'Oops si riempie mentre il prezzo scende: puo' essere
   l'inizio dell'inversione o un treno in corsa — lo stop e'
   obbligatorio e vicino.
3. First profitable open dipende dall'orario di apertura D1 del
   broker: sui CFD 23h il gap e' raro e il pattern muore (Unger lo
   dice: indici USA quasi mai, DAX si') — ATTESA: frequenza alta su
   DAX/indici EU, bassa su USA, media su forex (solo lunedi').
4. Campioni piccoli per costruzione: verdetto di FAMIGLIA.
5. Il cugino intraday e' gia' stato bocciato (RANGE_FADE): se anche
   il daily muore, il capitolo fade-del-breakout si chiude e si scrive.

## La trafila (imbuto standard, nessuno sconto)
tesi -> EA -> scan multi-simbolo OHLC (griglia Pattern x Exit) ->
tick reali sui vivi -> walk-forward con criteri congelati -> eventuale
vivaio IN CODA (siamo in modalita' osservazione: il deploy non e'
urgente, la conoscenza si'). Qualunque esito: referto.
