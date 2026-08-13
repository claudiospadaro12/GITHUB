# TESI — COST-TO-COST SULLE PUNTE DI LARRY (ramo B, scritta PRIMA di ogni numero, 13/08/2026)

## Le fonti
1. **Struttura decodificata dai due Pine open source** (fonti 11-12 del
   dossier SMASH_DAY_TESI.md): punta CONFERMATA con la regola della
   violazione (il massimo diventa punta quando il prezzo scende sotto
   il LOW della barra del massimo; specchio per i minimi); TREND
   INTERMEDIO = punte-massimo decrescenti (giu') / punte-minimo
   crescenti (su'). Auto-adattiva: NESSUN parametro N-barre.
2. **Il concetto del corso** (Emiliano 13.04/04.05, catalogo): "tradare
   DENTRO il range, da costa a costa" — comprare su una punta-supporto
   e vendere sulla punta-resistenza opposta. Gli indicatori del corso
   ("A Cena Con Larry" = livelli multi-TF; "Punte Di Larry" = frecce,
   licenza scaduta) confermano che il corso lavora sulle punte come
   LIVELLI. Regole d'uso del corso MAI scritte: tutte le regole di
   trading qui sotto sono SCELTA NOSTRA dichiarata.
3. Larry Williams (libro): ringed highs/lows e struttura del mercato.

## Il meccanismo (ipotesi)
Le punte confermate sono i livelli dove il mercato ha GIA' respinto il
prezzo: fra due punte opposte c'e' un range vivo. L'ipotesi cost-to-
cost: entrare alla CONFERMA di una punta (il momento in cui la
struttura dice "il minimo/massimo e' fatto") nella direzione del trend
intermedio, con target la punta opposta. E' mean reversion DI
STRUTTURA (non di oscillatore): compra la costa bassa, vendi la costa
alta, ma SOLO dal lato del trend intermedio.

## Meccanica dell'EA (ABTG_CostToCost) — SCELTE NOSTRE
- **Struttura sul TF del grafico** (InpTF, default H1; H4/D1 da
  spazzolare): regola della violazione, zig-zag di punte confermate,
  trend intermedio da massimi/minimi delle punte.
- **Ingresso LONG**: trend intermedio SU + conferma di una nuova
  punta-minimo (prezzo supera il massimo della barra del minimo) ->
  market buy. Specchio per lo SHORT in trend giu'. Lati separati
  (InpAllowLong/Short), asimmetria attesa.
- **Stop**: sotto/sopra la punta appena confermata + buffer ATR
  parametrico.
- **Target (InpExitMode)**: 0 = COST-TO-COST puro (la punta opposta
  piu' recente); 1 = R-based (TP a N x rischio); 2 = flip di
  struttura (esci quando il trend intermedio gira) = trailing
  strutturale.
- **Filtro larghezza del range**: distanza punta->target >= N x ATR
  (0=off allo screening): un cost-to-cost piu' stretto dello spread
  e' un regalo al broker.
- Un trade per conferma di punta; niente rientri sulla stessa punta;
  rischio % sul conto; magic 772311; commento "COST"; export OnTester
  standard + funnel `[COST-FUNNEL]` (barre -> punte confermate ->
  trend su/giu' -> segnali -> filtrati -> entrati -> esiti).

## Le trappole dichiarate subito
1. **SOVRAPPOSIZIONE CON PTE**: comprare il pullback confermato in
   trend su' e' parente stretto della Pullback-Trend-Entry (3 sedie
   in vivaio!). Se il cost-to-cost passasse l'imbuto sugli stessi
   mercati della PTE, le correlazioni si misurano PRIMA di ogni
   vivaio. Niente doppioni mascherati.
2. **Sovrapposizione con BB inversione** (retest della banda impulso)
   sui cambi: stessa vigilanza.
3. In trend forte il "range" si sposta di continuo: il target
   cost-to-cost puo' restare sempre piu' lontano dal prezzo (punte
   nuove sempre piu' alte). Il time-stop (InpMaxBarsHold, parametrico)
   e' il guinzaglio.
4. La conferma della punta arriva PER DEFINIZIONE in ritardo (serve la
   violazione): su TF bassi il ritardo mangia il range. Attesa: H1
   forse stretto, H4/D1 piu' respiro — lo dira' lo scan multi-TF.

## La trafila (imbuto standard, in CODA alla Notte di Larry)
tesi -> EA -> scan multi-simbolo OHLC (H1 e H4) -> tick sui vivi ->
walk-forward con criteri congelati al round -> eventuali correlazioni
con PTE/BB -> vivaio solo dopo. Il tester e' occupato stanotte con lo
Smash/Oops (ramo A): il ramo B entra in coda DOPO, un capitolo alla
volta. Qualunque esito: referto.
