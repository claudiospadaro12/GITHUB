# TESI — EASY TREND (Leonardo Fasciano, capitolo del Master ABTG)

_Distillata il 14/08/2026 dalle 7 trascrizioni TurboScribe dei video 11-17
portate da Claudio. Metodo di etichettatura (da "PROMPT DI INTELLIGENZA
PRECISA" di Claudio, 14/08): **[FONTE]** = detto esplicitamente nei video;
**[SCELTA]** = scelta nostra dove la fonte non quantifica; **[INCERTO]** =
dato non verificabile dalle trascrizioni._

## Il motore in una frase

Strategia di INVERSIONE su divergenza: una divergenza CCI segnala
l'esaurimento del movimento; la conferma tecnica e' la prima candela
"Linear Regression" che taglia la media dell'indicatore (il "plot");
ingresso al prezzo di chiusura della candela del segnale, SL oltre
l'estremo della figura +3 pips, TP a rischio-rendimento 1:1.

## Gli strumenti [FONTE]

1. **Linear Regression Candles** (indicatore TradingView di "UGUR-VU"):
   candele ricalcolate con regressione lineare che colorano la TENDENZA
   (verde/rossa), piu' un **plot** = "media mobile calibrata e tarata
   sull'algoritmo delle candele".
   - [INCERTO] i parametri esatti dell'indicatore (lunghezza della
     regressione, tipo/periodo della media del plot): mai citati nei
     video. [SCELTA] si adottano i default pubblici del Pine di Ugur
     (linreg 11 + segnale SMA 11 sul close linreg) ESPOSTI COME INPUT,
     cosi' una futura calibrazione col Pine vero (se Claudio lo trova
     su TradingView) e' un cambio di numeri, non di codice.
2. **CCI Divergences** (indicatore TradingView di "TISTA"): segnala
   divergenze regolari bull (riga verde) e bear (riga rossa).
   - [INCERTO] periodo CCI e meccanica esatta dei pivot. [SCELTA]
     CCI 20 standard + pivot frattali configurabili (default 5/5),
     divergenza regolare: prezzo LL + CCI HL = bull; prezzo HH +
     CCI LH = bear.

## Le regole della checklist [FONTE, video 13-14]

1. Presenza di una **divergenza di inversione** (bull o bear).
2. La **prima candela linreg** (dopo la divergenza) **che taglia il
   plot** nel verso del segnale — o che **apre direttamente oltre**.
3. La candela del segnale deve stare nella **fascia oraria 8:00-18:00**.
   - [INCERTO] il fuso: nei video l'orario e' letto sul grafico
     TradingView (feed Pepperstone), mai dichiarato il riferimento.
     [SCELTA] input in ORA SERVER con default 8-18 letterale, DA
     RIMAPPARE in calibrazione (su BCM: se la fonte intendeva ora
     italiana -> 7-17 server).
4. La candela del segnale deve essere **in tinta con la divergenza**
   (verde per bull, rossa per bear) — sono i colori LINREG, non delle
   candele giapponesi [FONTE, video 16 lo dice esplicitamente].
5. Le **3 candele precedenti** al segnale devono stare dal lato opposto
   del plot (sotto per un long, sopra per uno short): anti-lateralita'.
6. **Invalidazione** [FONTE, video 16]: se la prima candela che taglia
   il plot e' FUORI orario, la divergenza e' NULLA — non si aspetta la
   successiva candela in orario: si aspetta una divergenza nuova.

## Ingresso, stop, target [FONTE, video 14-16]

- **Ingresso**: al PREZZO DI CHIUSURA della candela del segnale.
  Se il prezzo attuale e' oltre (verso il TP): ordine LIMIT su quel
  livello; se e' gia' piu' conveniente (verso lo SL): a mercato.
  [SCELTA] finestra di validita' del limit: input (default 3 barre
  H1, convenzione di famiglia EntryWindowBars).
- **Stop loss**: l'estremo (minimo per long / massimo per short)
  compreso tra **l'inizio della divergenza** e la candela del segnale,
  **+3 pips** oltre. [SCELTA] i "3 pips" diventano input in points
  (default 30 su 5-digit).
- **Take profit**: rischio-rendimento **1:1** [FONTE]. [SCELTA] esposto
  come InpTP_R default 1.0 (la leva piu' onesta da spazzolare poi).
- Money management [FONTE]: rischio fisso % sul conto (il corso dice
  2%; [SCELTA] noi 1.0% standard di famiglia).

## Mercati e timeframe [FONTE, video 13 e 17]

- **EURUSD H1** e' il banco della strategia ("una delle regole e'
  operare sul time frame orario del cross euro-dollaro").
- Il backtest della fonte dichiara anche **EURGBP** (118%, DD 10%) e
  **EURCAD** (68%, "meno profittevole") — sempre H1.
- Numeri dichiarati dalla fonte su EURUSD: 198% da gen 2022, ~140
  operazioni, DD max 8%, win rate 70%, max 3 stop consecutivi, con
  rischio 2%. **[INCERTO — e la storia del progetto impone scetticismo:
  edgeful dichiarava 82,6% di vincite e sul nostro banco era rosso.
  Questi numeri NON sono un'aspettativa: sono un claim da falsificare.]**

## Giudizio di meccanizzabilita': ALTO (il migliore del corso)

A differenza di Alta Velocita' (discrezionale) e della Breaking Band
(squeeze da ricostruire), qui TUTTO e' regola scritta: indicatori
nominati, checklist numerata, ingresso/SL/TP quantificati, perfino la
regola d'invalidazione oraria. I punti deboli sono i parametri interni
dei due indicatori [INCERTO], gestiti esponendoli come input.

## Trappole attese (scritte prima dei numeri)

1. **La divergenza e' anticipo di inversione** = famiglia mean-reversion
   contro-trend: parentela potenziale con BB-INV e con niente altro in
   portafoglio (da misurare in per-trade, se ci si arriva).
2. **RR 1:1 con win rate dichiarato 70%**: se il win rate reale e'
   ~50%, il motore muore di costi. E' IL numero da guardare.
3. **I pivot delle divergenze ridipingono**: un pivot frattale 5/5 e'
   confermato 5 barre DOPO. L'EA deve usare SOLO pivot confermati
   (nessun repaint), accettando il ritardo — la trappola del ritardo
   del cost-to-cost H1 insegna che questo puo' uccidere il motore.
   Se muore per il ritardo, va detto nel referto.
4. **Fascia oraria col fuso sbagliato** = regola n.3 che filtra le
   candele sbagliate: da verificare in calibrazione col funnel.

## La trafila (invariata, per tutti)

Tesi -> EA v1.00 (agente, convenzioni di famiglia, magic base 772401)
-> compilazione -> CAL (funnel su EURUSD H1: quante divergenze, quanti
segnali, quanti invalidati per orario) -> scan 48 OHLC -> tick reali
-> walk-forward criteri congelati -> per-trade -> portafoglio ->
eventuale vivaio. Nessuno sconto: "expert vincente" lo decide l'imbuto,
non l'entusiasmo.

---

## ESITO CAL (14/08/2026) — detector scelto SOLO sulla frequenza

9 celle (PivotSource 0/1/2 x PivotR 3/5/7) su EURUSD, EURGBP, EURCAD,
Modello 1. **Compilazione al primo colpo** (quinto EA su cinque).
Frequenze OOS (13 mesi): src0/R3 = 57 / 45 / 64 trade sui tre simboli
(4-5/mese: la banda dichiarata dalla fonte, ~140 trade in 2,5 anni);
src2 (ENTRAMBI, il piu' severo) crolla a 10-25 trade = motore strozzato,
com'era il sospetto dell'agente; src1 (solo prezzo) sta in mezzo.
**Scelto src0 + PivotR 3** (il modo del Pine di TISTA citato in tesi):
frequenza sana e coerente sui tre simboli e sulle due finestre.
Il P/L NON e' stato guardato in questa fase (criterio congelato).

## ESITO SCAN 48 (14/08/2026) — campo debole, testa della classifica viva

288 celle (8 per simbolo: TP 1,0/1,5 x 4 combinazioni di lati),
Modello 1 OHLC 2024.01-2026.06.

- **Il campo e' ROSSO come il cost-to-cost H4**: solo 57 celle positive
  su 288 (20%); **24 simboli su 48 hanno la miglior cella in perdita**.
  Aggregato per combinazione: TUTTE negative in somma; la meno peggio
  e' SOLO LONG (19/48 celle positive a TP 1,5 contro 6/48 dello short).
  L'asimmetria dei lati colpisce per la QUARTA famiglia di fila.
- **Il TP 1,5 batte il RR 1:1 della fonte** quasi ovunque: la regola
  [FONTE] "rapporto 1 a 1" NON e' confermata dal nostro banco.
- **EURUSD, il banco dichiarato dalla fonte, e' nono** (+1.012, PF 1,34)
  e per giunta SOLO SHORT: il claim "198%, win rate 70%, DD 8%" non
  trova riscontro nella nostra misura. Terza fonte su tre con numeri
  fuori scala rispetto al banco (edgeful, ThinkMarkets, ora questa).
- Testa della classifica (miglior cella con n>=20): EURGBP +2.461
  (PF 1,98, DD 3,5, 54 trade, solo short) · CHFJPY +1.968 (PF 1,29,
  122 trade) · GBPUSD +1.769 (PF 1,61, solo long) · AUDJPY +1.632
  (PF 1,94) · CADJPY +1.534 · USDCHF +1.301 · XAUUSD +1.152 (PF 1,72)
  · USDJPY +1.040 · EURUSD +1.012.
- E35EUR (+906, PF 1,85) e' FUORI a priori: niente storico tick su BCM
  (gia' escluso in gap e cost, terza volta).

**Prossimo cancello**: tick reali con spread ACCESO (30 pt) sui 9 di
testa. La domanda vera e' quella scritta nelle trappole: il RR 1:1
(o 1,5) regge quando il win rate scende sotto il 70% dichiarato?
