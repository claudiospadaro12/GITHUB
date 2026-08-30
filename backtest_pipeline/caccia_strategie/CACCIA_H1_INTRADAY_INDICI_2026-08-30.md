# CACCIA H1-INTRADAY INDICI (DAX/Dow/Nasdaq) — 30/08/2026

## RISULTATO IN UNA RIGA
~230 titoli TradingView, 8 pagine Code Base, 2 arXiv; 6 motori letti nel sorgente.
Dopo la correzione di rotta (SOLO H1, SOLO intraday flat-EOD, no swing): **PROMUOVO
UNO.** La scoperta che vale piu' del candidato: **la flotta non ha NESSUN motore
H1-intraday** — tutti i nostri H1/H4 (SupRev, SuperWave, BreakingBand, EMA200) sono
SWING (tengono overnight); tutto l'intraday nostro e' M5/M15. L'intersezione
"H1 + flat a fine seduta + indici" e' un BUCO reale.

## IL PROMOSSO — `NY Session Trend Retest` (itzkarmakyo, MPL 2.0) — IN CODA ALTA 6-7/10
- **Fonte**: TradingView `dad2e548...`, sorgente Pine letto (705 righe). Licenza
  **MPL 2.0** (usabile, attribuzione). Copia in `biblioteca/sorgenti/`.
- **Tesi**: nel verso del trend ORARIO (EMA200 su H1), dopo che il prezzo si
  allontana e poi RITORNA sulla VWAP di sessione, entra sul RETEST — ma solo quando
  la VWAP ha pendenza e il mercato si espande (non compresso); parziale + breakeven,
  FLAT a fine seduta.
- **Meccanica**: gate direzione EMA200 H1; ingresso VWAP-retest (low tocca VWAP
  ancorata, close richiude dal lato giusto, trend concorde); FILTRO REGIME
  COSTITUTIVO (slope VWAP + espansione range: niente trade in VWAP piatta/compressa)
  = il filtro-che-e'-il-motore; SL VERO strutturale (lowest/highest(5)+buffer);
  parziale su PM/day levels + breakeven; **flat di seduta (close_all Session End)**;
  DUE LATI.
- **Bandiere rosse nel motore: NESSUNA.** No martingala/griglia/hedge, SL reale, no
  look-ahead. Difetto solo nella gestione: sizing 10% fisso -> da convertire a %.
- **Perche' non e' un caduto**: e' RETEST-IN-TREND (la geometria che nei referti ha
  sempre pagato, R42), NON breakout/fade/momentum. E il livello e' la VWAP di
  sessione, che non automatizziamo (esiste solo come filtro dormiente
  InpUseVwapFilter=false).
- **Buco che riempie**: primo motore H1-intraday della flotta + primo motore VWAP.
  -1 onesto: lavora nella finestra apertura USA dove gia' stanno Dow Apertura e
  PREOPEN_RETEST -> correlazione da MISURARE.
- **Costo**: porting Pine->MQL5 ~1 giornata, MA meta' (sessione+flat+parziale+BE+SL
  strutturale) e' gia' scritta nei nostri aperture EA e si riusa. Il nuovo vero e'
  la VWAP di sessione come livello + il gate slope/espansione.
- **Prop**: intraday per costruzione (flat EOD, zero overnight, leva 1:100). Da
  misurare: correlazione con Dow Apertura (stessi giorni?), frequenza (H1 puro =
  pochi retest/settimana -> campione sottile -> valvola R59: rischio si giudica,
  merito sospeso).

## CRITERI CONGELATI (per quando si costruisce l'EA)
U30USD lead, poi D30EUR/NASUSD. H1. @DAQUANDO 2024.09.26 (tick BCM, 21 mesi un solo
regime); screening regime (2020/2022) solo su NASUSD_EXT OHLC. Vincolo duro
InpCloseAtEnd=1 (flat fine seduta USA, ora server). Rischio % (mai 10% fisso). SL
strutturale + pavimento InpMinStopPts (R109). Sweep minimo (VWAP-retest vs
EMA-retest, soglia regime a 2 tarature vs OFF, buffer SL); resto pinnato; centro
altopiano. DUE LATI. Passa i caduti (breakout/fade/momentum): non e' nessuno.
Verdetto solo a tick; OHLC 1-min solo per contare.

## SCARTATI (swing eliminati dal vincolo intraday)
ABTG_BreakingBand su indici (swing, era il #1 pre-correzione), ExpWPRBB (swing +
licenza MetaQuotes), Triple EMA Turtle (swing + doppione SuperWave), Keltner bounce
(swing), Donchian (breakout+swing), nube VWAP/RSI crypto-forex (no flat EOD), Power
Hour/HMA/IB (gia' scartati 28/08), ORB pile (chiuso).

## NON VISTO
~90+ Pine access 2/3 protetti; SSRN/ForexFactory 403; spread reale H1 [NON MISURATO,
logger 74148 mai usato]; frequenza retest-VWAP H1 [INFERITA bassa, PASSO 0].

## LA DOMANDA CHE LASCIA
Il retest (la geometria che ha sempre pagato) regge quando il livello e' la VWAP di
sessione, su H1 puro, con flat obbligatorio EOD? E' scorrelato da Dow Apertura o
entra negli stessi giorni? Se si': primo motore H1-intraday + primo motore VWAP,
rischio notturno zero.
