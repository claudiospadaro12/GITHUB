# ASPETTATIVE REALISTICHE — il metro da usare SEMPRE (14/08/2026)

_Nato da una domanda di Claudio ("223.230 sarebbe il guadagno annuale?
Non e' che ti sbagli?"). La risposta e' NO, e questo file esiste perche'
l'equivoco non si ripeta in nessuna chat futura._

## Il numero del portafoglio NON e' uno stipendio

**+223.230 (27 serie, DD 5,50%, p99 12,47)** e' la somma dei P&L di 27
configurazioni, ognuna simulata SEPARATAMENTE su 100.000 EUR a rischio
1%/trade, nella finestra OOS 10/06/2025-30/06/2026 (~13 mesi), NEL
TESTER. Vale come **metro comparativo** — risponde solo alla domanda
"questa famiglia aggiunge profitto e abbassa le code?" — e NON come
previsione di guadagno. Da usare sempre con l'etichetta:
**metro di laboratorio, non busta paga.**

Perche' il reale sara' una frazione:
1. il rischio e' sommato in modo irrealistico (27 EA all'1% sullo stesso
   conto); a taglia prop 0,65% il profitto scala con lui;
2. 22 serie su 27 non hanno MAI operato in reale (il vivaio serve a
   questo);
3. divario tester->reale: spread, slippage, riquotazioni, news;
4. selezione: 27 celle scelte fra migliaia esaminate (26 ribaltamenti
   contati dicono quanto e' facile ingannarsi);
5. in prop la coda cattiva chiude il conto, quella buona non ripaga:
   a -10% la challenge e' persa, e comunque lo split e' 80-90%.

Prova del buon senso: +223% annuo metterebbe il progetto sopra qualunque
fondo al mondo (i migliori: 20-40% annuo). Se un numero suona cosi', non
e' una previsione.

## Il dato REALE al 14/08/2026

Conto 100k dry-run FTMO (50504263): **3 trade, netto -39,06** (Dow
+110,47 · DAX +24,90 · ORB -174,43), forward partito il 10/08. Quattro
giorni di vita: nessuna conclusione possibile, in nessuna direzione.

## Gli scenari dichiarati (giudizi, non misure) su UNA prop 100k funded

| Scenario | Lordo/mese | Netto a Claudio (split ~85%) |
|---|---|---|
| Va male: conto perso | — | 0 (e -439 di challenge) |
| Prudente | 1,5-2,5% | 1.200-2.100 EUR |
| **Centrale (obiettivo onesto)** | **3-4%** | **2.500-3.500 EUR** |
| Buono | 5-6% | 4.200-5.100 EUR |

Metodo: il tester dice ~11%/mese a taglia 0,65%; si **divide per tre**
per slippage + serie mai provate + selezione + regole prop. Il "diviso
tre" e' un giudizio d'esperienza, non una misura; se sbaglia, e' piu'
probabile che sbagli per ECCESSO.

Seconda prop (D3): raddoppia i numeri, ma solo autofinanziata (la
challenge 2 la paga il payout della 1). Non prima del 2027.

## Tempi realistici al primo euro vero

ago-ott: vivaio matura (verdetti a 15 trade/famiglia) -> 0 EUR ·
ott: challenge (-439) se il forward regge · 1-2 mesi di challenge ·
**primo payout realistico: nov-dic 2026.**

## IL LIMITE DELLA FINESTRA (domanda di Claudio, 14/08 notte)

**"Non e' che abbiamo backtestato su un periodo troppo breve?"** — Domanda
giusta. I numeri esatti: i walk-forward partono da **2024.09.26** e finiscono
al **2026.06.30** = **21 mesi**, divisi 40/60: **IS ~8,5 mesi** (26/09/24 ->
09/06/25), **OOS ~12,7 mesi** (10/06/25 -> 30/06/26). Non un anno, ma nemmeno
un ciclo di mercato.

**Perche' cosi' corta**: lo storico degli INDICI CFD su BCM comincia il
26/09/2024 — non e' una scelta, i dati prima non esistono (lezione gia'
pagata: un driver chiedeva 2024.01.01 e meta' della finestra IS era vuota).

**I quattro rischi concreti, dichiarati:**
1. **UN SOLO REGIME.** 2024-2026 = indici in salita. **Nessun mercato orso
   prolungato nel campione** (niente 2022, niente 2020, niente 2008). E la
   maggior parte delle celle promosse e' **SOLO LONG** (Larry, Cost, ORB-EMA200,
   gap forex): in un anno di orso quei motori non sono mai stati misurati.
   E' il rischio numero uno del progetto, piu' grande del rumore statistico.
2. **Pochi shock**: in 21 mesi ci stanno 2-3 eventi estremi. Il DD massimo
   misurato e' quindi ottimistico **per costruzione**.
3. **Campioni per cella**: 40-120 trade OOS su molte famiglie -> l'errore
   statistico sul PF resta grande anche quando il walk-forward passa.
4. **Stagionalita'**: agosto e dicembre compaiono due volte, non dieci.

**Cosa NON cambia**: dentro la finestra il metodo IS/OOS resta valido (i 26
ribaltamenti parati sono reali). Il limite riguarda la GENERALIZZAZIONE fuori
dalla finestra, non la correttezza della misura dentro.

**Cosa si puo' fare (in ordine di fattibilita'):**
- **Forex, oro, argento: si PUO' allungare.** Lo storico BCM su questi
  strumenti va piu' indietro degli indici -> rifare il walk-forward delle
  famiglie forex (BB, GAP, LARRY, COST, EasyTrend) su una finestra che
  includa il **2022** (bear + inflazione) e' il test di robustezza piu'
  prezioso disponibile. Primo passo: referto dello storico per simbolo
  (`scarica_storico.ps1 -Simboli "..." -Da 2020.01.01 -SoloReferto`).
- **Indici: NON si puo' allungare su BCM.** Restano due strade: dati
  esterni (complesso, feed diverso = confronto sporco) oppure dichiarare il
  limite e affidarsi al forward. Oggi si sceglie la seconda, per iscritto.
- **Monte Carlo (gia' in uso)**: rimescola i trade esistenti, NON crea
  regimi nuovi. Non risolve questo problema, e non va spacciato per farlo.

### Dati esterni per allungare la storia (idea di Claudio, 14/08)

Fattibile, con una gerarchia di pulizia (dalla piu' pulita alla piu' sporca):
1. **Storico BCM che gia' abbiamo** — da referto, forse basta sul forex. Primo
   passo obbligatorio: costa 2 minuti e potrebbe chiudere la questione.
2. **Conto DEMO su un altro broker MT5** con storico lungo (IC Markets,
   Pepperstone — quest'ultimo e' anche il feed usato nei video del corso):
   dati NATIVI MT5, tick reali del broker, zero import. **La strada
   consigliata**: si installa un secondo terminale, si scarica lo storico e
   si lancia il tester li'.
3. **Import di tick esterni (Dukascopy, Darwinex) come CUSTOM SYMBOL** in
   MT5 (`CustomTicksReplace`): tecnicamente possibile e gratuito, storia dal
   2003 sul forex. Ma e' la strada piu' sporca — vedi trappole sotto.

**LE TRE TRAPPOLE, dichiarate prima di partire:**
- **FUSO E DST**: Dukascopy e' UTC senza ora legale, i broker MT5 sono
  GMT+2/+3 CON ora legale. Tutti i nostri EA hanno orari in ORA SERVER (DAX 8,
  Nasdaq 14:30, fasce EasyTrend, box notturno oro): senza rimappatura
  dinamica ogni verdetto orario e' spazzatura.
- **UNITA' E VALORE PUNTO**: gia' pagata col v21 dell'amico (il suo stop di
  "50 punti" su BCM valeva mezzo punto indice). Contract size, tick value e
  digits di un simbolo importato vanno impostati a mano: se sbagliati, i P&L
  non significano nulla.
- **SPREAD E COMMISSIONI**: sono del broker dei dati, non di BCM. Su
  strategie con stop stretti (EasyTrend: 20-25 pips) questo sposta il verdetto.

**REGOLA D'USO (congelata ora):** i dati esterni servono SOLO come **prova di
regime** — celle e parametri CONGELATI, nessuna ri-ottimizzazione, domanda
unica: "questa strategia sopravvive a un mercato orso / a un altro
contesto?". Non si tara MAI un parametro operativo su dati di un altro
broker; la taratura resta su BCM, dove si opera.

## Il numero che decide davvero

Non e' il portafoglio simulato: e' **quanto i 15 trade di ogni famiglia
assomiglieranno al tester**. Se il vivaio esegue come previsto, gli
scenari reggono; se esegue peggio del 30%, si taglia tutto in
proporzione e si dice lo stesso giorno.

_Regola di comunicazione (14/08): i numeri del tester si citano SEMPRE
con la loro etichetta. L'hype va sui progressi del metodo, mai sulle
cifre di laboratorio._
