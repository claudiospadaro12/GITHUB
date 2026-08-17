# 📼 ANALISI TRASCRIZIONI — 11 video su EA e prop firm (18/08/2026)

_Analista-trascrizioni. Fonte: gli 11 file TurboScribe caricati da Claudio in
`trascrizioni_2026-08-18/`, letti INTERI, riga per riga. Le trascrizioni sono
l'UNICA fonte di questo referto: niente web, niente memoria di addestramento.
Completa la caccia del 18/08 (`CONFIG_PROP_2026-08-18.md` + `PROPOSTE_PROP_2026-08-18.md`)._

**Etichette:** [TRASCRITTO] = c'è scritto, cito · [TRASCRITTO dubbio] = numero
probabilmente storpiato dallo speech-to-text · [INFERITO] = dedotto da più
passaggi, dico quali · [INCERTO] = non lo so · [dichiarato, NON verificato] =
numero di performance del relatore, si registra e NON pesa.

⚠️ **Avvertenza sulla qualità della fonte**: queste trascrizioni sono
tradotte/trascritte male ("vantaggiatura" = win rate o stop loss a seconda del
punto, "giardino" = grafico/chart, "vendita" = trade, "firma" = firm). Ogni
numero critico è stato riletto nel suo contesto prima di etichettarlo.

---

# 🧮 PARTE 0 — SINTESI INCROCIATA (la pagina da leggere per prima)

## 0.1 📊 Il conto delle fonti INDIPENDENTI — prima di tutto

**11 trascrizioni ≠ 11 fonti.** Dal testo stesso emergono due cluster:

| cluster | file | indizi nel testo | conta come |
|---|---|---|---|
| **A — ecosistema "PropFirm Robots app"** | `#1 Prop Firm HACK...` + `I found the Best Prop Firm...` | entrambi promuovono l'app "PropFirm Robots" con coupon in descrizione, stesso congedo "ti amo ragazzi... ci vediamo nel prossimo video" | **UNA fonte** |
| **B — canale mentorship con "Alex"** | `EA Passing Prop Firm With 10% Max Drawdown` + `Profitable EA Trading - Stop Loss Strategy` | stessa filosofia dettata con le stesse parole (win rate alto, varianza bassa, "un unico assetto, tratterete altri asset per riempire i buchi", 30-40 asset), il secondo nomina "me e Alex" e l'insegnamento a pagamento | **UNA fonte** |
| C — sospetto stesso ecosistema di A | `Prop EA Review...` | promuove "EA Studio", "l'Academy", broker 8Cap, forum, VIP club — stesso giro commerciale dell'app PropFirm Robots ([INCERTO]: congedo diverso, "trade safe e ciao per ora") | **[INCERTO]** — prudenzialmente possibile terza gamba del cluster A |
| — | gli altri 6 file | BM Trading · recensore sviluppatore del "Gold Longbow" · vendor dell'EA "86% winrate" · Blue Edge Financial (Titan X) · listicle a voce sintetica · canale "occhio nero" | 6 fonti distinte |

**Totale: 8 fonti indipendenti al massimo, 7 se il file `Prop EA Review` è
dello stesso ecosistema del cluster A.** Ogni convergenza qui sotto è contata
su questo numero, non su 11.

## 0.2 🎯 LE RISPOSTE ALLE QUATTRO DOMANDE DELLA MISSIONE

**1. Il pattern del buffer 4%/9% converge anche nel parlato? → NO.**
Nessuna delle 11 trascrizioni detta un buffer sotto il muro, né 4/9 né altro.
L'unico "4%" nel parlato è il rischio "allo stadio aggressivo di circa 4%" del
cluster B ([TRASCRITTO dubbio], ed è rischio per trade, non cap giornaliero).
**Il 4/9 resta un dato dei file `.set` (§1A-ZERO del dossier), non del
parlato.** Onestamente: i video parlano di muri (5/10, 3/6), mai di dove
mettere il guardiano rispetto al muro. Le proposte P1/P2 non ricevono né
conferma né smentita da queste trascrizioni.

**2. Qualcuno detta l'ora di reset del muro giornaliero e il fuso? → NO
(l'ora di reset nessuno; UN fuso sì, ma per la strategia).**
Nessun video pronuncia l'ora di reset del daily. L'unica dichiarazione di fuso
in tutto il materiale è nella recensione del Prop Firm Gold EA: broker
**"New York +7"**, con chiusura della seconda operazione alle **18:20 ora
broker = 11:20 New York** [TRASCRITTO] — è l'orario di USCITA della strategia,
non un reset di muro. Conversione BCM: [INCERTO] senza sapere il DST del
broker citato; NY+7 in agosto ≈ UTC+3 ≈ **20:20 ora server BCM** [INFERITO
dalla regola di casa BCM=UTC+1 in agosto — da NON usare operativamente].

**3. Qualcuno detta valori di filtro news (finestre in minuti)? → NO.**
Un solo video (Titan X / Blue Edge) dichiara un news filter ("ti farà uscire
dalle notizie di alto impatto") ma **senza un solo minuto**. Le finestre in
minuti restano un dato esclusivo dei `.set` (NFP 100/60, NYAO 15-45) e delle
regole prop (±2/±5/±10). **Il buco P5 del dossier resta con le fonti che ha.**

**4. Qualcuno dichiara recovery/griglia per FX JetBot, famiglia Dark,
Infinity Trader, UnitedEuro? → NO — nessuno dei quattro è nominato in nessuna
trascrizione.** Però il materiale dice tre cose vicine:
- il canale "occhio nero": _"Le EA più popolari che vedo sono EA che sono tipo
  Martingale o grid style... continueranno a mettere negozi contro il
  movimento"_ [TRASCRITTO] — conferma di contesto, non sui 4 nomi;
- il cluster B **ammette DCA nel proprio EA**: _"siamo in grado di DCA un paio
  di giorni più tardi per evitare questo sguardo quotidiano"_ [TRASCRITTO] —
  un video intitolato "10% Max Drawdown" che media al ribasso;
- FundedNext (citata nel cluster A): **"il grid trading è proibito"**
  [TRASCRITTO] — quindi un EA a griglia su FundedNext non è solo fragile:
  è una violazione.

## 0.3 📋 TABELLA DEI VALORI CONVERGENTI (contati per fonte, non per video)

| tema | valore | dove | fonti indipendenti |
|---|---|---|---|
| **Randomizzare gli input/ingressi perché la prop non riconosca lo stesso EA su più utenti** | randomizza SL, TP, parametri indicatori, magic unico per download | cluster A (2 video) · vendor "86%" ("soluzione tecnica per mascheggiarlo") · Blue Edge ("funzione di randomizzazione... PropFirms non è in grado di detectare") | **3** — ed è lo STESSO pattern dei `.set` del dossier (Gold Phantom `Randomization=50` acceso solo nel preset prop; Prop Firm Pass `InpBuy/SellEntryRandomPoints`). **Il dato più solido di tutto il giro.** In più FundedNext lo chiede DALL'ALTRA PARTE: _"assicurarsi che i loro parametri di trattamento sono unici"_ (FAQ citata nel cluster A) |
| **Hedge cross-account per recuperare il costo della challenge** | EA sulla challenge + posizione opposta su conto reale piccolo; funziona SOLO con DD statico | `Prop EA Review` (PropEA: hedge 231€ per challenge 10k) · Blue Edge ("hedge on real account", 1.000-1.500$) | **2** (o 1 se C=A) — 🚩 bandiera rossa, vedi §0.5 |
| **Le percentuali di passaggio vere sono basse anche per chi vende i bot** | <10% media industria · 25-33% il bot "migliore" · 2 su 8 (BM Trading, onesto) · "4-6 mesi a rischio basso" (PropEA reviewer) | Blue Edge · BM Trading · `Prop EA Review` | **3** — convergenza sull'ordine di grandezza: **anche venduta bene, una challenge si passa ~1 volta su 3-4** |
| **Il funded account prima o poi si perde, il gioco è il churn** | _"più tardi o più tardi, bloccherai l'account della vita... ancora fai molto più dinero di quello che hai investito"_ | vendor "86%" (esplicito) · Blue Edge (implicito: economics su hedge + volume di challenge) | 1 esplicita + 1 implicita — **l'ammissione più rivelatrice del pacchetto** |
| Muri FTMO 10k: daily 500$ (5%), target 1.000$ (10%), fase 2 5%, **4 giorni minimi** | | `Prop EA Review` | 1 — coerente col §2A del dossier |
| Muri FundedNext: 2-Step **5%/10%**, 1-Step Stellar **3%/6%** | | cluster A | 1 — il **3%/6% dell'1-Step è un numero NUOVO** rispetto al dossier (§2B ha solo il 2-Step) [dichiarato dal relatore, NON verificato] |
| Rischio per trade dettato | 1% (cluster A) · ~2% (cluster B) · lotti fissi 0,2 su 10k (BM Trading) | 3 fonti, **3 valori diversi** | **NESSUNA convergenza** — e tutti sopra il nostro 0,65% |

## 0.4 ⚔️ CONTRADDIZIONI fra i video

1. **Win rate alto + SL largo vs risk:reward positivo.** Il cluster B predica
   TP vicino + SL lontanissimo + DCA ("tenere la vantaggiatura alta sarà
   assolutamente chiave"). Il recensore del Gold EA dice l'esatto contrario:
   _"se vuoi passare le firme di prop, hai bisogno di un risultato di rischio
   positivo"_ (R:R ≥ 1). Inconciliabili sul piano del profilo di rischio prop:
   il profilo del cluster B ha perdite rare ma enormi, che è ciò che un muro
   giornaliero del 5% punisce.
2. **FundedNext "una posizione alla volta"** (listicle Top 3, [TRASCRITTO
   dubbio]) **vs il cluster A che trada 5 EA contemporanei su FundedNext**
   con più posizioni aperte mostrate. Il listicle è la fonte meno affidabile
   del pacchetto (voce sintetica, zero date, nomi storpiati): quella riga
   va considerata spazzatura.
3. **"Passa ogni prop" vs "sopravvive a lungo termine".** Il vendor "86%"
   ammette che il funded si perde sempre; il canale "occhio nero" costruisce
   il video sulla promessa opposta (e la trascrizione si tronca prima di
   dimostrare alcunché).

## 0.5 🚩 IL CASO SPECIALE — trucchi anti-prop (VIETATO PER NOI)

> 🔴 **Regola di casa: quanto segue è INTELLIGENCE. Non si propone, non si
> imita, non si configura. Violare i termini di una prop = perdere conto e
> soldi della challenge.**

Tre famiglie di trucchi documentate nel materiale:

**(a) Mascherare l'EA da trading manuale** (`#1 Prop Firm HACK`, VIETATO):
- magic number → **0**: _"se cambiate soltanto il numero magico a zero,
  simulerete il tradimento manuale"_ [TRASCRITTO];
- randomizzare SL/TP/parametri indicatori per non produrre trade identici ad
  altri utenti dello stesso robot;
- l'app promossa genera **un magic nuovo e input variati a ogni download**.

**(b) Vendita a copie limitate + mascheramento tecnico** (vendor "86%"):
_"vendiamo solo 5 del stesso, poi lo cambiamo un po' e vendiamo altri 5.
Inoltre abbiamo un'altra soluzione tecnica per mascheggiarlo"_ [TRASCRITTO].

**(c) Hedge cross-account per azzerare il costo challenge** (PropEA · Blue
Edge): posizioni opposte su un conto reale esterno mentre l'EA "spara" sulla
challenge (PropEA in default mode: **buy/sell RANDOM ogni 24h** — il relatore
stesso: _"non ha davvero un bordo nel mercato"_). Il reviewer padda perfino i
**4 giorni minimi FTMO con micro-trade** dopo il passaggio. Blue Edge mostra
tre challenge PERSE chiuse in guadagno netto via hedge (348$→701$, 397$→733$,
398$→977$ [dichiarato, NON verificato]).

**Cosa ci insegnano (il valore di conformità, unico uso lecito per noi):**
1. **Le prop profilano magic number e comment di ogni ordine** e cercano
   trade identici fra utenti → i nostri EA (magic propri, strategia nostra,
   un solo conto) sono naturalmente dal lato giusto; la domanda vera resta
   quella già in `DOMANDE_SUPPORTO_PROP.md`: la stessa flotta su DUE conti
   nostri è "copy trading"?
2. **Il rilevamento è un fatto, non una paranoia**: due f