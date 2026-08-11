# ALTA VELOCITA' (Manuela Negro) — tesi distillata per l'automazione
_Fonte: manuale 38 pp. + 84 slide caricati da Claudio l'11/08/2026 (materiale
di studio personale del percorso di 12 lezioni — resta nel repo privato)._

## La strategia in una frase
Trend following su analisi ciclica: si individua un ciclo che sta per
invertire, si entra 2 time frame SOTTO per avere uno stop minuscolo, si
punta al target del ciclo grande (2 x ATR del ciclo direzionale, misurati
dal massimo/minimo di ciclo). Obiettivo dichiarato: 210 operazioni chiuse
con rapporto medio 1:3.

## La scala e la regola madre
Scala TF: 100tick, M1, M5, M15, H1, H4, D, W, M, Q (niente M30/M2: i
parametri sono tarati su questa scala). Scelto il CICLO DIREZIONALE:
- grafico d'ingresso  = 2 gradini sotto (il suo Williams descrive il ciclo)
- Williams di contesto = 1 gradino sopra l'ingresso (zona estrema richiesta)
- RSI di contesto      = 2 gradini sopra l'ingresso (gia' nella direzione)
- ATR del target       = sul ciclo direzionale (3 gradini sopra l'ingresso)
Combo operative: D->M15 · H4->M5 · H1->M1 · M15->100tick. Durate cicliche:
M15=1,5h · H1=6h · H4=24h · D=6gg · W=6sett.

## I 4 indicatori (compiti separati)
| Indicatore | Setup | Compito |
|---|---|---|
| Supertrend | "standard" (⚠️ parametri esatti non dichiarati nel manuale) | livelli veri, colore del trend, stop sulla CUSPIDE; conta la CHIUSURA oltre il gradino, non l'ombra |
| Oscillatore ciclico | ✅ FORMULA ORIGINALE OTTENUTA (11/08, `alta_velocita_ciclo.pine`): composito di 4 stocastici lisciati I=(4,1·K1+2,5·K2+K3+4·K4)/11,6 con K1=SMA(St(5),3), K2=SMA(St(14),3), K3=SMA(St(45),14), K4=SMA(St(75),20); CICLO = I − SMA(I,9) | tempi: cambio di segno = fine ciclo; max/min di ciclo = estremo di PREZZO nel ciclo (non la punta dell'indicatore); arriva tardi ~1 ATR: NON si usa per entrare |
| Williams %R | 140 periodi | la benzina: zona estrema = accumulazione/distribuzione. Limite: segnale valido solo con W fra estremo e -50. "Doppia uscita" dalla zona = tipica della laterale pre-inversione |
| RSI | 4 periodi | direzione della forza, anticipo 2-3 barre: trendline sulle PUNTE (una per ciclo, mai saltarne uno). Divergenza = caso migliore; doppio massimo = aspetta |

## Il segnale: ROTTURA -> RITEST -> RIPARTENZA (esempio SELL)
1. **ROTTURA**: Supertrend del grafico operativo diventa rosso + RSI dello
   stesso grafico ribassista (2 massimi di ciclo che scendono). Si traccia
   la LINEA VIOLA sul supporto rotto.
2. **RITEST**: prezzo risale con RSI rialzista (2 minimi di ciclo che
   salgono). Puo' rompere o no il Supertrend: indifferente. SEMPRE dopo la
   rottura, mai prima.
3. **CONTROLLO (il filtro chiave)**: il nuovo supporto formato nel ritest
   deve essere <= linea viola. Se e' salito, rottura annullata: si azzera.
4. **RIPARTENZA**: RSI torna ribassista + Supertrend torna rosso (+ ciclo
   negativo) = SEGNALE. Williams ancora nella prima meta' (sopra -50).
Ogni fase ~2 cicli del grafico operativo (su M15: ~9 ore totali).
Scorciatoia: la rottura del Supertrend di un TF = allineamento completato
sul TF inferiore.
Filtro direzionale: se il Supertrend del grafico SUPERIORE ha gia'
attraversato la linea viola -> solo segnali col trend; l'80% dei cicli M15
e' controtendenza e NON si prende.

## Stop, target, gestione (il cuore — ed e' quasi tutto meccanico)
- **Stop iniziale**: 1 pip oltre l'estremo della fase di inversione; se
  R/R < 3 si stringe alla cuspide del Supertrend piu' vicina; se ancora
  < 3 il segnale NON si prende. Sanity check: stop ~ ATR M5 (ne' 1,5 pip
  ne' 20).
- **Target**: 2 x ATR del ciclo direzionale DAL massimo/minimo di ciclo
  (non dall'ingresso). Se il ciclo non e' chiuso, si usa l'estremo
  raggiunto finora.
- **Stop a zero** quando: Williams del grafico d'ingresso raggiunge la
  zona opposta senza rottura del Supertrend, oppure il Supertrend
  attraversa il prezzo d'ingresso.
- **Scala di gestione**: quando il Supertrend attraversa l'ingresso si
  SALE di un grafico; lo stop segue il Supertrend del grafico nuovo e
  NON si allarga mai. Esci per: (1) target 2ATR, (2) uscita anticipata su
  divergenza RSI del grafico di gestione / allineamento contrario del TF
  inferiore (prezzo sotto MA9 + divergenza = il segnale piu' usato),
  (3) stop tecnico (rottura Supertrend) = la peggiore.
- Uscite a zero/piccola perdita ripetute prima del movimento buono = costo
  fisiologico; il vincente non fa 3, fa 10-20.

## Rischio e "patente" (report)
Rischio 2% (intraday con target 3%) o 1% (trend following). DD reale <=3%,
deviazione std <=2%, DD prospettico <=7% (complessivo <=20%). Prima che i
numeri escano dal report, NON si va in reale. Sessione unica al giorno;
calendario la sera prima; mai tradare l'istante della notizia.

## Allegato citato dal manuale (NON ancora nelle nostre mani)
`AltaVelocita.mq5` / `.mq4`: indicatore che disegna i 4 strumenti,
riconosce la sequenza, calcola stop/target/R:R e ha dashboard multi-TF.
⚠️ Chiedere a Claudio se ha i file: risparmierebbero meta' del lavoro di
traduzione (e conterrebbero i parametri esatti del Supertrend).

## Automatizzabilita' — giudizio onesto (11/08)
**MECCANICO (si codifica fedele):** scala TF, state machine
rottura/ritest/ripartenza con linea viola, filtro Williams (zona estrema,
limite -50), stop su cuspide, target 2xATR dal max/min di ciclo, R/R>=3
come filtro, stop a zero, scala di gestione col Supertrend del TF
superiore, uscita su MA9+condizione, filtro direzionale della linea viola.
**APPROSSIMATO (si codifica con perdita dichiarata):**
1. ~~l'oscillatore ciclico e' un PROXY~~ → RISOLTO l'11/08: Claudio ha
   fornito la formula originale (`alta_velocita_ciclo.pine`), si traduce
   1:1 in MQL5;
2. le trendline sulle punte dell'RSI ("una punta per ciclo, mai saltarne
   uno") vanno ridotte a regole su massimi/minimi di ciclo — la lettura
   fine (ventagli, canali, "pallina") resta fuori;
3. il 100-tick NON esiste nel tester MT5 in ottimizzazione: si parte
   dalle combo M1/M5 (ciclo H1/H4/D), il gradino 100tick resta manuale.
**Supertrend:** parametri esatti non reperibili (Claudio, 11/08: "non ho
trovato altro, dovrebbe essere standard"). DICHIARATO COME IPOTESI:
ATR 10 x mult 3.0, reso SWEEPABILE nell'EA cosi' la FASE 0 misura la
sensibilita' attorno all'ipotesi invece di fidarsi.
**Conferme incrociate (11/08):** la formula del ciclo arriva identica da
3 fonti indipendenti (odt, .pine TradingView, manifest del .algo cTrader
con gli stessi default 5/3, 14/3, 45/14, 75/20, MM 9).
**FUORI dalla v1:** hedging multiday, doppia uscita del Williams come
pattern esplicito, scelta discrezionale del cross.
**Percorso deciso:** EA `ABTG_AltaVelocita` (combo di partenza: ciclo H4,
ingresso M5 — l'Esempio 1 del manuale) con parametri sweepabili -> entra
nell'IMBUTO NORMALE: criteri congelati PRIMA, FASE 0 OHLC solo screening,
verdetti a tick reali, walk-forward. Nessuna corsia preferenziale.
⚠️ Strategia management-heavy: l'OHLC sottostima/sballa la gestione a
scala -> lo screening dira' poco, il giudizio vero e' tutto nei tick.

## COLLAUDO 11/08 (GBPUSD, ciclo H4, OHLC)
- **Tecnico: SUPERATO.** Compilato al PRIMO colpo (1.045 righe, 32 input).
  La macchina a stati produce trade in abbondanza: 93-259 per cella.
- **Numeri: ROSSO PIENO in screening.** 8 celle su 8 negative in ENTRAMBE
  le finestre (PF 0,59-0,85; peggior giornata gia' oltre -2% all'1%).
  Col cancello meccanico GBPUSD non verrebbe promosso.
- **MA vale l'avvertenza scritta sopra PRIMA dei numeri**: le uscite di
  questa strategia (stop-a-zero, trailing multi-TF, uscita MA9) vivono
  DENTRO la barra: l'OHLC M1 le calpesta. Percio' PRIMA di condannare o
  di lanciare la coda a 8 simboli: UNA verifica a tick reali su GBPUSD,
  stessa griglia. Tick rossi -> v1 senza edge li' (e la coda si valuta
  con quel dato in mano); tick diversi -> l'OHLC era il bugiardo atteso.
