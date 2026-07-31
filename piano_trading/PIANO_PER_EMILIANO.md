# Il mio progetto di trading — per Emiliano

*Bozza da Claudio. Obiettivo: spiegarti a che punto sono, il metodo che sto seguendo e dove vorrei il tuo occhio critico.*

---

## Chi sono e perché faccio così
Sono un trader retail, ma **lavoro a tempo pieno e ho poco tempo per stare davanti ai grafici.** Per questo non punto sul trading manuale discrezionale: sto costruendo, con metodo, una **"squadra" di Expert Advisor (EA)** che — dopo test rigorosi — **girano da soli** su un conto demo, e poi (se reggono) su una **prop firm**.

Non è improvvisazione: ogni decisione la prendo **sui numeri**, non a sensazione.

## L'obiettivo, in due fasi
1. **Squadra di EA autonomi e validati** — pochi EA solidi, diversificati, che lavorano mentre io sono al lavoro.
2. **Progetto prop** — portare i migliori su una prop firm (riferimento FTMO), dopo averli messi alla prova con le stesse regole.

## Il metodo — un "imbuto" a 4 passi
Ogni strategia passa da questo filtro, e sopravvive solo se merita:

1. **SCOPERTA** — backtest OHLC di ogni motore su **48 simboli** e **più timeframe** (H4/H1/M30/M15/M5): dove ha davvero un vantaggio?
2. **VALIDAZIONE** — solo i vincitori passano al backtest a **TICK REALI** (spread e fill veri). Qui cadono i falsi positivi.
3. **FORWARD** — i validati girano su **demo reale**: raccolgo la pagella vera (Profit Factor e Drawdown reali).
4. **PROP-HARDENING** — correggo il rapporto rischio/rendimento, aggiungo un **"guardiano" del rischio**, e faccio un **dry-run su un demo da 109k** con le regole esatte della prop, prima di pagare una challenge vera.

Guardo soprattutto il **Profit Factor mediano** (robustezza su tanti parametri) e il **Drawdown**, non il singolo risultato fortunato.

## I sistemi automatici che ho già costruito
- **Report di mercato giornaliero** (via email ogni mattina): bias di trend, livelli, calendario banche centrali, posizionamento COT.
- **Report settimanale**: confronta il bias previsto con quello che il mercato ha fatto davvero.
- **Pipeline di backtest**: scansiona i motori su tutti i simboli e timeframe, e valida i vincitori a tick reali.
- **Guardiano di portafoglio**: un EA che fa rispettare i limiti prop (perdita giornaliera, drawdown totale) — chiude tutto e blocca se si sfora.

## Su cosa mi sto focalizzando ADESSO
- **Validare a tick reali TUTTE le strategie** che ho, su più timeframe, per costruire una **matrice "motore × simbolo × timeframe"** e trovare le combinazioni vincenti.
- **Primi candidati in forward** su demo.
- **Un "motore di apertura" unico** applicato a più indici (studio su ampiezza del range, ritracciamenti, dove mettere stop / break-even / trailing / chiusura parziale).
- **Qualità del codice**: ho appena trovato e corretto un bug importante nella gestione dei trade (su conto Hedge, con più EA sullo stesso strumento, la gestione del profitto poteva "saltare").

## Primi risultati concreti
- **SupertrendReversal sull'Oro (H4)**: validato a tick reali, **Profit Factor ~1,46** con **Drawdown ~1,2%** → è il mio **candidato numero uno per la prop** (drawdown bassissimo = tanto margine sotto i limiti).
- Il metodo funziona anche a **scartare**: Dow e ASX sembravano buoni in OHLC ma **sono crollati a tick reali** → esclusi. Meglio scoprirlo nel test che coi soldi.

## Il progetto prop (dove voglio arrivare)
- **2-4 EA diversificati** (strumenti/strategie non correlati) che rispettano le regole di una prop.
- Riferimento **FTMO** (regole pulite, EA ammessi, drawdown statico, nessun limite di tempo).
- **Dry-run su demo 109k** col guardiano, prima di pagare: "avrei passato la challenge?".

## Dove mi piacerebbe il tuo aiuto, Emiliano
1. Un **occhio critico** sul metodo e sulla scelta delle strategie.
2. Le tue **strategie / live**: vorrei capire quali sono **meccanizzabili** in un EA (regole chiare di ingresso, stop, target) e quali invece restano discrezionali.
3. Consigli su **gestione del rischio** e sulla **scelta della prop**.

---

*In sintesi: sto trasformando il "poco tempo disponibile" in un vantaggio — un sistema che lavora per me, testato con metodo, con l'obiettivo prop come traguardo. Ogni passo è documentato e verificabile.*
