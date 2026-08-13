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
