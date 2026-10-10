# CACCIA: "TITANY X" / "Algoritmo K7" (Digital Infobiz LLC), analisi di AFFIDABILITA', 10/10/2026

Richiesta di Claudio: _"Mi trovi info se e' affidabile?"_ (4 screenshot da Facebook, dominio titany.co). Letto OGGI, 10/10/2026. **Non comprato, non iscritto, nessun modulo, nessun link di affiliazione cliccato, nulla scaricato o eseguito.** Nessun EA/preset/conto toccato. Le decisioni restano di Claudio.

Etichette: **[SNIPPET]** = riportato da un risultato di WebSearch di oggi; **la pagina NON e' stata aperta da me** (vedi §0) · **[DICHIARATO]** = scritto dal venditore, non verificato · **[INFERITO]** = deduzione mia, con la ragione · **[DERIVATO]** = aritmetica mia · **[NON CONFERMATO]** = una fonte lo dice, altre no · **[INCERTO]** = non lo so.

---

## 0. ACCESSO E CONTROLLO POSITIVO (in testa, e questa volta e' una cattiva notizia)

| fonte | esito oggi (10/10/2026) | conseguenza |
|---|---|---|
| `https://titany.co` (+ `www.`, e i domini `titany.com`, `titanysoftware.com`) via `curl` con user-agent normale | **403 su CONNECT** dal gateway del sandbox (il log del proxy scrive `connect_rejected ... policy denial or upstream failure`, host `titany.co:443`) | **fonte NULLA in lettura diretta**: non ho potuto aprire nemmeno la pagina K7 |
| `WebFetch` su `titany.co` e su `thetradelovers.gumroad.com` | `getaddrinfo ENOTFOUND` | idem |
| **CONTROLLO POSITIVO** su un bersaglio che conosciamo: `ftmo.com/en/faq/` via `curl` e via `WebFetch` | **403 su CONNECT / ENOTFOUND** | **FALLITO**: tutto l'esterno e' chiuso al fetch diretto, non e' un problema di titany.co. Trustpilot, Altroconsumo, Myfxbook, AmicoBot, Wayback: stesso 403 |
| `WebSearch` (standard ed extended) | **risponde** con titoli, URL e sintesi | **unico canale vivo**: tutto quello che segue e' a livello **[SNIPPET]**, non pagina letta |
| WHOIS di `titany.co` | non raggiungibile; una ricerca non ne restituisce nessuno | **[INCERTO]** registrar e data di creazione |

> **Regola applicata:** il controllo positivo e' fallito sulla lettura diretta, quindi la lettura diretta e' dichiarata NULLA. Ho continuato solo sul canale che il controllo ha mostrato vivo (WebSearch), e ogni riga e' etichettata di conseguenza. **Nessuna riga di questo dossier e' "[VERIFICATO] letto sulla pagina".** Le cifre sono quelle che il motore di ricerca riporta dalla pagina; il `controllo-caccia` deve riaprirle da un ambiente che raggiunga il web. Dove due ricerche si contraddicono lo scrivo (§3.5, §5).
> **Nota di metodo:** le sintesi di WebSearch sono scritte da un modello, non sono citazioni. Per questo ogni cifra qui sotto e' un'ipotesi di lettura finche' non e' riaperta.

**Identita' del prodotto [SNIPPET]:** la pagina `titany.co/funnel-algoritmok7/` (titolo del risultato: _"Algoritmo K7», il sistema di trading automatico che esegue ..."_ / _"Titany X - Expert Advisor 100% automatico (anche Prop Firm)"_) elenca i pilastri che Claudio ha fotografato (filtri di volatilita', distanza dinamica delle mediazioni, Equity Stop Loss, ecc.). Quindi **"TITANY SOFTWARE X" = "Titany X" di Digital Infobiz LLC**, e K7 e' il nome dell'algoritmo dentro Titany X. Questo combacia con gli screenshot **[INFERITO, ragionevolmente solido: 3 pilastri su 7 coincidono parola per parola]**.

---

## 1. CHI C'E' DIETRO

| voce | cosa risulta | etichetta | URL |
|---|---|---|---|
| Marchio / societa' | _"Titany e' un marchio di Digital Infobiz LLC"_; **tutto** (prodotti, supporto, pagamenti, reclami, rimborsi) gestito **esclusivamente** da Digital Infobiz LLC | [SNIPPET] | https://titany.co/ |
| Sede | due indirizzi: **30 N Gould St Ste R, Sheridan, WY 82801, USA** (pagine recenti) e **1209 Mountain Road PL NE Ste H, Albuquerque, NM 87110** (informativa piu' vecchia) | [SNIPPET] | https://titany.co/en/privacy-policy/ |
| Che cos'e' quell'indirizzo | `30 N Gould St` a Sheridan e' un **palazzo di agenti registrati commerciali**: la stampa locale parla di 26 agenti registrati per quasi 300.000 delle 830.000 LLC del Wyoming. **Non e' di per se' una colpa** (e' la norma per le LLC del Wyoming), ma vuol dire **nessuna sede operativa visibile** | [SNIPPET] | https://www.thesheridanpress.com/news/local/amid-legislation-stalls-registered-agent-sites-generate-millions-in-state-revenue-fraud-continues/article_0b4b4bfd-6523-4a88-a1ed-de716c6a3e82.html |
| Registro imprese / P.IVA / numero LLC | **non trovati**: una ricerca su "Digital Infobiz LLC" + Wyoming/New Mexico non restituisce nessun registro | [INCERTO] (non e' provato che non esista: non ho potuto interrogare `wyobiz.wyo.gov`) | - |
| Regolamentazione dichiarata | _"Digital Infobiz LLC **non e' una impresa di investimento autorizzata**, non e' iscritta a Consob, Banca d'Italia o OCF; non presta consulenza, gestione di portafogli, ricezione e trasmissione di ordini"_ | [SNIPPET] (autodichiarazione) | https://titany.co/ |
| Consob | una ricerca "Consob Titany / Digital Infobiz" **non restituisce nessun avviso/oscuramento** su questi nomi | [SNIPPET, esito negativo, ricerca generica: NON equivale a verifica sul sito Consob] | https://www.consob.it/web/consob/w/occhio-alle-truffe-abusivismo-finanziario-consob-oscura-21-siti-internet |
| Fondatore | **Tommaso Nardini**, "trader ed EA developer", "oltre 15 anni", "podio della Traders Cup 2016", "ha formato con Larry Williams e Oliver Velez", "oltre 500 EA sviluppati", "alcuni venduti a istituzioni finanziarie"; ha progettato, programmato e backtestato Titany X | [DICHIARATO] da pagine del venditore, nessuna fonte indipendente trovata | https://titany.co/who-we-are/ · https://titany.co/chi-siamo/ |
| L'uomo del video ("NON TOCCO NIENTE") | molto probabilmente **Nardini** (il canale YouTube che compare e' il suo: _"Come opera il mio software di trading automatico su un conto Prop Firm azzerando il rischio"_). **Non ho potuto vedere il video** | [INFERITO dal titolo e dalla descrizione, non dal video] | https://www.youtube.com/watch?v=kJHllMTDUgw |
| Canali | Facebook `titanyofficial`; YouTube (video + shorts "Risultati settimanali del software TITANY X"); **Skool** "Titany Official / Titany Trading Mastery" con bootcamp a pagamento (_"da 0 a 1.000 euro in sei settimane"_, [DICHIARATO]); sito con Masterclass e Bootcamp | [SNIPPET] | https://www.facebook.com/titanyofficial/ · https://www.skool.com/@titany?t=posts · https://titany.co/bootcamp/ |
| Anno di fondazione, altri fondatori, Telegram | **non trovati** | [INCERTO] | - |
| **Il modello di business** | non e' solo "un EA": e' **EA + formazione (Bootcamp/Skool/Masterclass) + intermediazione verso broker/prop** (versione "X AXI PRO" per Axi Select). Quindi l'incentivo a vendere la speranza e' strutturale | [INFERITO dalle pagine] | https://titany.co/ |

**Da non confondere (trappola grossa per chi cerca):**
- `Titan X Pro EA` (MQL5, prodotto 186247) e `Titan X` (MQL5, 130288) sono **altri EA di altri autori**, nome simile: **non c'entrano**. https://www.mql5.com/en/market/product/186247 · https://www.mql5.com/en/market/product/130288
- **Rivenditori di copie** (_"TITANY X PRO(P) EA v3.0 MT4 + SetFiles (Original version)"_ a **$15-19**; Gumroad `thetradelovers` a **$14,99**) su `forextoolstore.com`, `shopforexea.com`, `eaforexstore.com`, `forex4s.net`, `outletforexshop.com`, `shopea.ir`: contro un listino ufficiale di **1.397-3.997 euro**. Rapporto di prezzo ~100 a 1 **[DERIVATO]**: sono con ogni probabilita' **copie non autorizzate/crackate** **[INFERITO]**. Regola di casa (CANCELLO_ACQUISTI_EA): _"La pirateria resta fuori discussione"_. Se qualcuno ti manda a quei siti, e' una seconda bandiera, non un'alternativa piu' economica. Es.: https://forextoolstore.com/product/titany-x-prop-ea/ · https://thetradelovers.gumroad.com/l/TITANYXPROEAv2MT4

---

## 2. COSA VENDONO

| voce | cosa risulta | etichetta | URL |
|---|---|---|---|
| Prodotto | **Titany X**, Expert Advisor **"non direzionale"**, 4 profili operativi configurabili; su **5 coppie** (home) o **"fino a 28 cross"** (pagina K7) | [DICHIARATO]; **i due numeri non coincidono** | https://titany.co/ · https://titany.co/funnel-algoritmok7/ |
| Pacchetti e prezzi | **Essential** (solo conti personali, 3 coppie, "licenza a vita per 2 account MT4") **EUR 1.397** (da 1.697) · **High** EUR 1.997 · **X (Prop)** **EUR 2.997** (da 3.797) · **X AXI PRO** EUR 3.997. Snapshot "di circa 15 mesi fa", l'associazione prezzo-pacchetto viene da un'estrazione di testo disordinata | [SNIPPET] **prezzi da riaprire** | https://titany.co/titany-x/ |
| Piattaforma | le pagine ufficiali parlano di **licenze per account MT4**; **MT5 non confermato dal venditore** (solo i rivenditori di copie dicono MT4+MT5) | [SNIPPET]; MT5 [INCERTO] | https://titany.co/titanyx-simulator-v3/ |
| Prop compatibili | dal simulatore ufficiale: l'opzione "Prop Firm" **non e' disponibile** per le licenze Essential/Elevate, richiede **PRO(P)** o **Axi Select**. Il sito dichiara che permette di operare su conti capitalizzati _"senza incorrere in ban, avvisi o revoche per copytrading"_. **Nessuna prop elencata per nome** nei risultati, salvo **Axi Select** | [DICHIARATO] | https://titany.co/titanyx-simulator-v3/ |
| Garanzia | _"**Capitalizzato o Rimborsato**"_: se il software non funziona, **rimborso dell'intero investimento piu' 1.000 euro**. **La pagina non dice** quando il software "fallisce", entro quanto, con che procedura | [SNIPPET]; criteri [INCERTO] | https://titany.co/help-center/ |
| Termini | aggiornamenti/modifiche/**cessazione** non danno diritto a rimborso; nessun rimborso se l'accesso e' disattivato per violazione dei limiti d'uso; prodotto **"as is"**, nessuna garanzia di risultati | [SNIPPET] | https://titany.co/termini-di-utilizzo/ |
| Rimborso nei fatti | recensioni Trustpilot: rimborso **negato** (circa 1.500 euro, versione base); un contratto con "retrocessione di una parte se la challenge non e' superata" non rispettato dopo 12 mesi; **Titany risponde** che _"la prop firm ha cambiato politica e non accetta piu' EA"_ e che il supporto non era dovuto | [SNIPPET di recensioni e di repliche, non verificato] | https://it.trustpilot.com/review/titany.co?page=4 |
| Rischi dichiarati | il sito avverte dei rischi del trading e che i risultati non sono garantiti | [SNIPPET] | https://titany.co/ |

> 🧮 **Ordine di grandezza della spesa [DERIVATO]:** EUR 2.997 (pacchetto Prop) = **~ 30% di un conto prop da 10.000** o **il prezzo di piu' challenge FTMO**. E' una spesa che il progetto non ha mai autorizzato (CLAUDE.md: _spendere soldi = firma di Claudio_). Qui **non** la propongo.

---

## 3. LE PROVE MOSTRATE

### 3.1 Track record verificato

| prova | cosa risulta | etichetta | URL |
|---|---|---|---|
| Myfxbook "TITANY X (Standard)", utente `steelz75` | conto **reale** EUR su **Axi**, MT4, leva 1:1000; **88 operazioni**, profitto **~EUR 77,85**, versamenti **1.427,43**, prelievi **1.505,28**, PF **1,83**, "ultime 200 transazioni". Badge di verifica: **non visibili nello snippet** | [SNIPPET]. **E' l'unico conto reale trovato, ed e' di un utente, non del venditore** | https://www.myfxbook.com/members/steelz75/titany-x-standard/11405628 |
| Myfxbook "TITANY X Prop EA", utente `FestaOba` | conto **demo** GBP, ~**GBP 1.993** di profitto su **GBP 100.000**; un altro riassunto parla di PF **1,03** | [SNIPPET] **numero in contraddizione fra due riassunti, riaprire** | https://www.myfxbook.com/members/FestaOba/titany-x-prop-ea/11139120 |
| Sito del venditore: _"8% di profitto in 70 giorni, drawdown massimo 0,85%"_ (altra fonte: 0,89%); _"97% delle operazioni chiuse in profitto"_ | **nessun link a un conto verificato trovato** | [DICHIARATO] | https://titany.co/titany-x/ · https://titany.co/chi-siamo/ |
| Certificati di payout prop / challenge passate | **non trovati** nei risultati; solo recensioni Trustpilot di singoli che dicono di aver passato la fase 1 | [INCERTO] | - |
| Backtest (dati, modello) | **non trovato** | [INCERTO] | - |
| **Test indipendente, demo, AmicoBot** | broker **Fusion Markets**, **49 giorni, 25 operazioni chiuse**, win rate **92%**, PF **8,92**, rendimento **+1,84% in circa 7 settimane**, **posizioni aperte in perdita per circa -265 USD non incluse** nei numeri delle chiuse, **nessuno stop loss** sulle operazioni analizzate, meccanismo che apre una seconda operazione a prezzo migliore | [SNIPPET]; **ATTENZIONE: AmicoBot ha link di affiliazione** (lo dichiara) | https://amicobot.it/blog/titany-x-recensione-risultati-reali-test-prop-firm/ |

**Lettura [INFERITO, la ragione e' aritmetica]:** un **win rate del 92-97% con PF 8,92 su 25 operazioni e senza stop** e' la firma tipica di un payoff asimmetrico: tante piccole vincite chiuse e **poche, grandi perdite ancora aperte o rare**. Le "operazioni chiuse in profitto" sono un conteggio che **non include la coda**. Con 25 operazioni l'intervallo e' enorme: un 23/25 e' compatibile con una vera probabilita' di vincita molto piu' bassa di quella stampata. **Il -265 USD flottante e' l'informazione che conta, e il 92% non la contiene.**

### 3.2 Recensioni e segnalazioni indipendenti

| fonte | cosa risulta | etichetta | URL |
|---|---|---|---|
| Trustpilot | **331 recensioni** (snapshot inglese): **74% a 5 stelle (246), 18% a 1 stella (58)**, il resto ~8%. Distribuzione **a due code**. Punteggio: 4,2 (Italia, snapshot) o ~4,0/3,8 (snapshot inglese): **cifre diverse, snapshot di date diverse** | [SNIPPET] | https://www.trustpilot.com/review/titany.co · https://it.trustpilot.com/review/titany.co?page=4 |
| Tono positivo | stabilita', facilita' d'uso, supporto reattivo, "ho superato la fase 1 della challenge", guadagni mensili modesti | [SNIPPET] | idem pagine `?page=2..10` |
| Tono negativo | perdite e drawdown su challenge; installazione; **un utente: "ad alcuni clienti il conto Axi e' stato bloccato per copy trading"**; un altro: Axi ha restituito il deposito perche' col nuovo portale il robot non e' collegabile; 2.500 euro "buttati"; rimborso negato. **Titany replica punto per punto** (non trova il cliente, "nessuno ha mai bruciato un conto a causa del software", problema dipendente dal broker) | [SNIPPET: singoli utenti, repliche del venditore, nessuna prova] | idem |
| Il sito del venditore | `titany.co/recensioni/` raccoglie video e testimonianze **curate**; `titany.co/titany-x-recensione-opinioni/` risponde "e' una truffa?" con "No" | [DICHIARATO], **marketing** | https://titany.co/recensioni/ · https://titany.co/titany-x-recensione-opinioni/ |
| AmicoBot (blog di recensioni) | ha chiesto una licenza per testare e **non ha ricevuto risposta** (per la recensione principale); segnala _"accounts online di presunte truffe legate al nome Titany, con richiesta di 'commissioni' per sbloccare fondi"_ (**da leggere come impersonificazione del nome**, non provato) | [SNIPPET], conflitto di interesse (affiliato) | https://amicobot.it/blog/titany-x-recensione-e-opinioni-funziona-davvero-per-il-trading-e-le-prop-firm/ |
| Blog legale (Avvocato Penalista h24) | articolo del **12/2025** sul claim "8% in 70 giorni"; lo studio dichiara di aver **ricevuto una diffida a rimuoverlo** | [SNIPPET], non letto | https://avvocatopenalistah24.it/legislazione/titany-truffa-online/ |
| **Altroconsumo (bacheca reclami)** | **una** ricerca ha riportato _"reclamo di giugno 2026: bot acquistato da Titany, profitti minimi, conti bloccati, recensioni negative Trustpilot 'modificate'; reclamo chiuso"_ con URL `https://www.altroconsumo.it/reclamare/bacheca-dei-reclami/pratiche-commerciali-scorrette/b58fcefc0ced8ae831`. **Tre ricerche successive** (incluso un filtro per dominio e la ricerca dell'ID) **non l'hanno ritrovato** | **[NON CONFERMATO]**: **non lo uso come bandiera**; il `controllo-caccia` deve aprire quell'URL: se esiste, sale a ARANCIO | l'URL qui sopra |
| Reddit, Forex Peace Army, Forex Factory | **nessun thread trovato** | [SNIPPET, esito negativo; NON equivale a "non esiste"] | - |

**Segnali di recensioni comprate:** la distribuzione a due code e le repliche aziendali puntuali sono compatibili con un flusso di recensioni sollecitate **[INFERITO, debole]**; non ho potuto vedere date, profili e numero di recensioni per autore, che sono i dati che decidono. **[INCERTO]**.

---

## 4. LA MECCANICA (il cuore: i sette pilastri messi alla prova)

### 4.1 "Niente martingala" e "distanza dinamica delle mediazioni": si contraddicono?

Il testo di Claudio: _"se un'operazione va contro, il sistema ne apre una seconda a un prezzo migliore; la distanza si allarga quando il mercato e' agitato e si stringe quando e' tranquillo"_. In italiano da trading questo e' **mediazione = averaging down**, cioe' **media a peggiorare**. Dunque:

1. **"Il lotto non aumenta mai" e "niente martingala" possono essere veri alla lettera** (martingala in senso stretto = si **raddoppia il lotto** dopo la perdita) **e al tempo stesso il sistema e' un averaging**: stesso lotto, ma **un secondo ticket nella stessa direzione contro-trend**. L'esposizione, in numero di ticket, e' **doppia** proprio nel momento peggiore **[DERIVATO: 2 ticket x lotto uguale = 2x]**. "Il lotto non aumenta" e' una frase **vera sul singolo ticket e fuorviante sull'esposizione**.
2. **AmicoBot, sul conto demo, riscontra [SNIPPET] l'assenza di stop loss sulle operazioni e un "recupero" con seconda operazione**, e **chiama il tutto "martingala"**. Il venditore (e alcune recensioni Trustpilot) lo chiama **"anti-martingala"**. Le due descrizioni **non sono entrambe vere**: o i ticket hanno uno SL al broker (e AmicoBot ha sbagliato a leggere) o non lo hanno. **Questo e' il punto che si decide con un file di storico del terminale (campo `sl` di ogni ordine), non con le parole** - ed e' esattamente il test T1 del nostro metro (§7). **[INCERTO finche' non si vede un ordine]**.
3. **Equity Stop Loss** (pilastro 04): _"cifra massima di perdita: se il conto la tocca chiude tutto e si ferma"_. E' una protezione **fatta dal software**, non un SL depositato al broker **[INFERITO dalla descrizione]**. Cosa NON protegge: gap di weekend/news (il prezzo salta oltre la cifra prima che l'EA agisca), EA o VPS spenti, disconnessione del terminale, spread allargato in rollover. **"E' la funzione piu' importante sui conti Prop"** e' vero come ordine di importanza, ma e' anche **l'ammissione che il rischio per operazione non e' limitato in altro modo**: se ogni ticket avesse uno SL, l'Equity Stop non sarebbe "la piu' importante".
4. **Il rischio di coda e' strutturale**: un averaging su 5-28 coppie ha un payoff "tante vincite piccole, una perdita enorme". **Su una prop il muro e' un evento unico e irreversibile** (5% giornaliero / 10% totale per la maggior parte): la perdita rara e' esattamente quella che finisce l'esperimento. Il 92-97% e' coerente con questa forma **[INFERITO]**.

### 4.2 Le regole delle prop (siti ufficiali: pagine citate dal motore di ricerca oggi, 10/10/2026)

> **Tutte [SNIPPET]**: le pagine ufficiali non sono apribili da qui (controllo positivo FTMO fallito, §0). Le regole delle prop cambiano senza avvisare: **vanno rilette sulla pagina prima di qualsiasi decisione**.

| prop | EA | copy trading / stesso EA piu' conti | grid / martingala | URL |
|---|---|---|---|---|
| **FTMO** | _"non limitiamo le strategie finche' sono legittime, in linea con una corretta gestione del rischio, conformi al mercato reale e non somiglianti alle pratiche vietate"_. **Avverte** che un EA di terzi puo' essere gia' usato da altri trader, cioe' **la stessa strategia**, e che si rischia il **diniego del conto** per superamento del **limite di capitale massimo: 400.000 USD per cliente o PER STRATEGIA**. Se FTMO individua attivita' intenzionali o un **Modus Operandi ripetuto su piu' conti**, puo' rimuovere posizioni, ridurre la leva o chiudere i conti. **Iperattivita'**: oltre 2.000 richieste al server al giorno | FTMO vieta il copy di decisioni altrui (segnali/copiatori) sui futures; per i conti CFD il tetto per strategia e' la regola chiave | il blog FTMO sugli EA indica come cautele: **martingala**, scalping, durate lunghe, **strategie senza o con poco stop loss**, **drawdown tipico superiore al 10%**. **Non e' un divieto esplicito**, ma e' una descrizione **che somiglia al profilo K7** | https://ftmo.com/en/faq/which-instruments-can-i-trade-and-what-strategies-am-i-allowed-to-use/ · https://ftmo.com/en/faq/how-many-accounts-can-i-have/ · https://ftmo.com/en/blog/what-to-look-out-for-when-choosing-an-expert-advisor/ · https://ftmo.com/en/forbidden-trading-practices/ · https://ftmo.com/en/how-to-pass-ftmo-challenge/ |
| **FundedNext** (CFD) | gli EA richiedono un **add-on a pagamento**; su Stellar Instant **ogni EA/bot deve avere una strategia distinta**; vietati gli EA con integrazioni Telegram/WhatsApp e alcuni EA nominati | **copy trading ammesso solo fra conti dello stesso individuo**; vietato con conti Funded su un lato, con terzi, o da conti non propri; **monitorano operazioni identiche, ingressi sincronizzati, strategie condivise** (avvertimento o chiusura) | **grid trading vietato** ("puo' portare a cessazione immediata"); la lista delle pratiche proibite e' dichiarata **non esaustiva** | https://help.fundednext.com/en/articles/8020351-what-are-the-restricted-prohibited-trading-strategies · https://fundednext.com/general-rules/cfds/what-is-forbidden · https://help.fundednext.com/en/articles/11641338-can-i-use-ea-in-stellar-instant |
| **The5ers** | _"puoi usare un EA purche' **non copi i segnali di un'altra persona**, e il trader **deve possedere il codice sorgente** dell'EA"_ (letto da snippet: **da riaprire, e' la riga piu' pesante**); vietati tick scalping, latency arbitrage, HFT | _trade coordination o copy trading con altri trader o conti_ = violazione | martingala citata esplicitamente solo nei termini di un vecchio programma Bootcamp (possibile pagina datata); grid "ristretto" secondo un blog di un concorrente | https://the5ers.com/faqs/can-i-use-an-ea-expert-advisor-can-i-set-a-stealth-mode-stop-loss/ · https://the5ers.com/faqs/prohibited-trading-practices/ |
| **Funding Pips** | **EA di terzi ammessi solo come gestore di trade/rischio**: _"qualsiasi altro uso di un EA di terzi comporta diniego e chiusura del conto"_; un EA proprio puo' essere totalmente automatico **solo con prova di proprieta' (sorgente o cronologia versioni; un file compilato non basta)** | copiare operazioni fra conti di utenti diversi vietato; copiare da fonte esterna vietato | martingala sconsigliata nel blog; la lista delle pratiche vietate include "recuperare le perdite aumentando l'esposizione" | https://help.fundingpips.com/hc/en-us/articles/34505029138449-Trading-Conduct-and-Security-Standards |
| **Axi Select** (per cui esiste la versione "X AXI PRO") | _"sono ammessi **solo EA di tua creazione**; gli EA di terzi si possono usare per segnali ma **tutte le operazioni vanno piazzate a mano**"_ | _"l'uso del copy trading nel programma e' **severamente vietato**"_; un rappresentante Axi su Forex Factory: nessuna forma di copia, ne' da un altro trader ne' da un altro conto proprio | non cercato | https://support.axi.com/hc/en-us/articles/38954749331737-Can-I-use-an-Expert-Advisor-EA-with-my-Axi-Select-Account · https://support.axi.com/hc/en-us/articles/32883582202649-Can-I-use-Copy-Trading-in-Axi-Select |

**Il nodo, in una riga [INFERITO dalle quattro tabelle qui sopra]:** FTMO accetta EA di terzi ma **mette un tetto per strategia**; The5ers e Funding Pips li accettano **solo se sei tu il proprietario del codice o se l'EA fa il gestore**; Axi Select accetta **solo EA propri**. Un EA commerciale venduto "a licenza" a centinaia di clienti **sta fuori da almeno tre di queste cinque regole alla lettera**, indipendentemente da come il lotto, gli orari e i prezzi vengano variati.

### 4.3 "Esecuzione diversificata" (pilastro 05): e' una funzione pensata per eludere i controlli anti-copy-trading?

Cosa dice il venditore **[SNIPPET su titany.co/funnel-algoritmok7 e su altre pagine]**: _"per le Prop Firm che ammettono gli EA, varia orari, prezzi e parametri di ingresso su ciascun conto, fornendo un'impronta di esecuzione autonoma che **evita sovrapposizioni riconducibili a pratiche di copy trading**"_. Altrove lo chiama **"Signature Mode"** e scrive che _"le prop firm chiudono i conti che aprono le stesse operazioni nello stesso momento"_ e che il Signature Mode cambia _"orari, prezzi e **dimensioni** degli ingressi su ogni conto"_. Il sito afferma anche che il software permette di operare _"senza incorrere in ban, avvisi o revoche per copytrading"_.

Due letture, entrambe da scrivere:

- **Lettura benigna:** il cliente ha piu' conti propri (ammesso da FundedNext, FTMO nei limiti del tetto) e non vuole che due istanze dello stesso EA producano operazioni identiche al secondo. **Vale solo se** la prop consente quell'uso.
- **Lettura che pesa:** la funzione e' descritta **come difesa da un controllo delle prop**, non come una proprieta' della strategia. Il bersaglio dichiarato e' la **rilevazione** (la stessa che FundedNext scrive di fare: "operazioni identiche, ingressi sincronizzati, strategie condivise"), non la regola. **Rendere due conti non identici non rende conforme una regola che dice "stessa strategia/stesso EA di terzi" (FTMO tetto per strategia; Funding Pips/The5ers/Axi: solo EA propri)**. E il rischio non e' solo "essere scoperti": e' **payout negato / conto chiuso retroattivamente** su regole che il cliente ha accettato firmando.
- Un fatto che sposta il giudizio: il venditore **ammette per iscritto** che i blocchi per copy trading sono un rischio concreto (e' la ragione per cui la funzione esiste) **[SNIPPET]**, mentre il claim di marketing e' "senza ban". Le due cose insieme sono **una bandiera ARANCIO-ROSSA**, non una dimostrazione di dolo: **non dimostro intenzione, dimostro che la funzione tratta la rilevazione come il problema da risolvere.**
- Piccola incoerenza interna [INFERITO]: _"il lotto non aumenta mai"_ (sui ticket) ma il Signature Mode _"cambia le dimensioni degli ingressi"_ **[SNIPPET: "dimensioni" compare in una pagina, "orari, prezzi e parametri" nello screenshot di Claudio]**: da verificare con la pagina intera.

### 4.4 Urgenza e iperboli

- **Timer a scalare (13 min 05 s)**: urgenza artificiale. **Non ho potuto vedere se si azzera al ricaricamento** (la pagina non e' aperta); il test e' banale per chiunque: aprire la pagina in finestra privata e ricontrollare **[NON VERIFICATO]**. Con prezzi da 1.397 a 3.997 euro, un timer su una pagina-funnel e' tipico dei funnel "fai una decisione adesso".
- _"Nessun trader al mondo puo' reggere questo ritmo operando in manuale"_, _"il piu' alto win rate in Europa"_, _"unico software in Italia per conti capitalizzati"_ (quest'ultimo da riascoltare: [SNIPPET]), _"azzerando il rischio"_ (titolo del video YouTube): **tutte [DICHIARATO] e non falsificabili**. **"Azzerando il rischio" e' falso per definizione** in un sistema con averaging: il rischio non si azzera, si sposta sulla coda.
- _"Sette controlli su ogni cross valutario, a ogni movimento di prezzo, 24 ore su 24"_: contraddice **il numero di coppie** (5 sulla home, "fino a 28" nel K7) e contraddice il pilastro 01 (_"giornate confuse: non apre nulla"_), cioe' **non e' vero che opera 24 ore su 24 su ogni cross se per scelta si ferma alcuni giorni**. Marketing, non bugia.

---

## 5. VERDETTO DI AFFIDABILITA' (punteggio di fiducia 0-100 per voce)

> **Come leggere il punteggio:** "quanto crederei a questa voce se dovessi metterci i miei soldi". Fiducia bassa non vuol dire "truffa": vuol dire "non posso farci affidamento". Le fonti sono [SNIPPET] (§0): **tutto il dossier ha il tetto della non-lettura diretta.**

| voce | fiducia | semaforo | perche' |
|---|---|---|---|
| Esistenza del prodotto e dell'azienda | **70** | verde-giallo | pagine ufficiali, YouTube, Skool, Trustpilot a 331 recensioni, un test di terzi fatto con una copia vera. Non e' un sito fantasma |
| Trasparenza societaria | **35** | arancio | LLC USA con indirizzo da agente registrato; nessun registro/P.IVA trovato; si dichiara non autorizzata Consob/OCF; nessun dato italiano. Reclami solo "tramite il canale" della stessa societa' |
| Claim di performance (97%, 8% in 70 gg, DD 0,85%) | **10** | rosso | nessun conto verificato del venditore trovato; un test indipendente su 25 operazioni; il 92% esclude -265 USD flottanti |
| Track record pubblico | **15** | rosso-arancio | un conto reale di un utente con profitto ~78 euro su 1.427 di versamenti; un conto demo con PF 1,03-ish; nessun certificato di payout |
| Recensioni indipendenti | **45** | giallo | volume reale e distribuzione a due code; repliche aziendali; la fonte "indipendente" piu' dettagliata (AmicoBot) e' affiliata. Reclamo Altroconsumo [NON CONFERMATO] |
| Meccanica / rischio di coda | **20** | rosso | averaging (mediazione) in un contesto dove il muro e' irreversibile; stop per operazione da verificare; protezione a livello di software |
| Conformita' alle regole delle prop | **10** | rosso | contro "solo EA propri" (Axi, Funding Pips, The5ers), contro il tetto per strategia (FTMO) e la sincronia (FundedNext); funzione di variazione d'impronta descritta come difesa dalla rilevazione |
| Garanzia/rimborso | **25** | arancio | "Capitalizzato o Rimborsato" senza criteri pubblici; i termini escludono il rimborso per cessazione; rimborsi negati in recensioni (non verificate); la clausola "risarcimento 1.000 euro" e' quella da fotografare |
| Onesta' del marketing | **15** | rosso-arancio | timer, "azzerando il rischio", "niente martingala" accanto a mediazioni, "nessun trader al mondo", pacchetto da 2.997-3.997 euro |

**VERDETTO COMPLESSIVO: fiducia 15/100 per l'uso su prop firm; 35/100 come "azienda esistente che consegna qualcosa".**
- **Non e' dimostrata come truffa** (un'azienda che consegna un EA funzionante esiste, e ci sono clienti che dichiarano risultati modesti positivi).
- **E' un prodotto ad alto rischio e a meccanica occultata**, con una funzione di marketing (impronta diversificata) che **contraddice o aggira lo spirito delle regole delle prop** e con una garanzia **non verificabile**.
- **Per Claudio, in pratica:** non comprare sulla base di questa pagina; **se comunque interessa**, la sequenza e' quella del `CANCELLO_ACQUISTI_EA` (§7), e Titany **non supera il gradino 1** (nessuna demo testabile nel tester, nessun sorgente, MT4).

### Bandiere (con fonte)

| colore | bandiera | fonte (URL, letto 10/10/2026 come [SNIPPET]) |
|---|---|---|
| ROSSA | "Esecuzione diversificata / Signature Mode" descritta come difesa dalla rilevazione di copy trading, con claim di "nessun ban"; Axi Select ammette solo EA propri; Funding Pips/The5ers: solo EA propri o gestore; FTMO: tetto per strategia | https://titany.co/funnel-algoritmok7/ · https://support.axi.com/hc/en-us/articles/38954749331737-Can-I-use-an-Expert-Advisor-EA-with-my-Axi-Select-Account · https://help.fundingpips.com/hc/en-us/articles/34505029138449-Trading-Conduct-and-Security-Standards · https://ftmo.com/en/faq/how-many-accounts-can-i-have/ |
| ROSSA | mediazione contro-trend + (da verificare) nessuno SL al broker sui ticket; "Equity Stop Loss" e' la protezione principale | https://titany.co/funnel-algoritmok7/ · https://amicobot.it/blog/titany-x-recensione-risultati-reali-test-prop-firm/ |
| ROSSA | claim di performance senza conto verificato del venditore (97%, 8% in 70 gg, DD 0,85%); "azzerando il rischio" | https://titany.co/chi-siamo/ · https://www.youtube.com/watch?v=kJHllMTDUgw |
| ARANCIO | prezzo 1.397-3.997 euro; garanzia "Capitalizzato o Rimborsato" senza criteri; termini senza rimborso per cessazione | https://titany.co/help-center/ · https://titany.co/termini-di-utilizzo/ · https://titany.co/titany-x/ |
| ARANCIO | societa' US con indirizzo da agente registrato, dichiaratamente fuori Consob/OCF, reclami solo via la stessa societa' | https://titany.co/ · https://titany.co/en/privacy-policy/ |
| ARANCIO | un solo conto reale pubblico: ~78 euro di profitto su ~1.427 di versamenti, 88 operazioni | https://www.myfxbook.com/members/steelz75/titany-x-standard/11405628 |
| ARANCIO | recensioni Trustpilot: blocchi di conti Axi "per copy trading", rimborso negato, replica aziendale "la prop non accetta piu' EA" | https://it.trustpilot.com/review/titany.co?page=4 |
| ARANCIO | upsell di formazione (Bootcamp/Skool "da 0 a 1.000 euro in 6 settimane") sullo stesso prodotto | https://www.skool.com/@titany?t=posts |
| GIALLA | timer a scalare, iperboli ("nessun trader al mondo"), 5 coppie o "fino a 28" | screenshot di Claudio + https://titany.co/ |
| GIALLA | copie a $15-19 su siti di rivenditori (probabile pirateria); nomi quasi uguali su MQL5 (Titan X Pro) | https://forextoolstore.com/product/titany-x-prop-ea/ · https://www.mql5.com/en/market/product/186247 |
| GIALLA | diffida a un articolo critico (lo dice lo studio legale) | https://avvocatopenalistah24.it/legislazione/titany-truffa-online/ |
| GIALLA | "account di presunte truffe" che usano il nome Titany (impersonificazione): **mai pagare "commissioni di sblocco" a nessuno** | https://amicobot.it/blog/titany-x-recensione-e-opinioni-funziona-davvero-per-il-trading-e-le-prop-firm/ |
| [NON CONFERMATO] | reclamo Altroconsumo di giugno 2026 | https://www.altroconsumo.it/reclamare/bacheca-dei-reclami/pratiche-commerciali-scorrette/b58fcefc0ced8ae831 |

### Cosa NON ho potuto verificare (lista onesta)

1. **Tutte le pagine di titany.co e dei siti terzi non sono state aperte** (gateway 403 su tutto l'esterno, controllo positivo FTMO fallito). Tutto e' [SNIPPET].
2. Il **video** (l'uomo che dice "non tocco niente"), il **timer**, il **testo tagliato** ("i risultati di chi ci si affida...").
3. **Prezzi attuali** (lo snapshot e' di ~15 mesi fa) e se esiste **MT5**.
4. Se i **ticket hanno SL al broker** (decide la lettura "martingala" vs "anti-martingala").
5. Se esiste un **link a un conto verificato del venditore**.
6. Il **reclamo Altroconsumo** (§3.2), **Consob/OCF** sul sito ufficiale, **registro delle imprese** (WyoBiz/NM), **WHOIS** di titany.co.
7. **Data, profili e numero di recensioni per autore** su Trustpilot (decide se sono sollecitate).
8. Le **pagine delle prop** vanno riaperte per la data di lettura: le regole cambiano.

---

## 6. SE E' UTILE ALLE NOSTRE SEDIE: la tabella dei buchi (mini)

| meccanismo dichiarato da Titany | cosa abbiamo noi (repo, letto oggi) | buco? |
|---|---|---|
| 01 Filtri di volatilita' ("giornate confuse: non apre nulla") | **14 EA** in `mql5/Experts/` con filtri `InpUseAtrFilter` / `InpAtrFilterBars` / `InpAtrFilterMult` (`grep` 10/10) | **nessun buco** come meccanismo; resta da misurare per sedia |
| 02 Distanza dinamica delle mediazioni | niente: **per regola di casa non esiste** (`report/METRO_PROP.md` §13: martingala/recovery = scarto a vista; averaging a cap fisso con stop unico = misurabile solo a G1-G6) | **buco voluto**, non da colmare |
| 03 Take profit dinamici | uscite per sedia (ATR/trailing/BE); il nostro asse "gestione dell'uscita" e' gia' obbligatorio nel certificato di morte | nessun buco |
| 04 **Equity Stop Loss** (chiude tutto e si ferma) | **ABTG_Guardian**: `InpDailyPausePct=4.0` (pausa morbida), emergenze al **4,9% giornaliero / 9,9% totale**, `InpMaxOpenRiskPct=3.25` (C1 vivo), `InpDailyResetHour`, `InpDailyBaseline`, `InpDDMode` (statico/trailing) | **nessun buco**: il nostro Guardian e' un superinsieme (muri statici/trailing, baseline FTMO, reset in ora server, cap di rischio aperto). **Differenza che conta:** le nostre sedie hanno SL **al broker** per ogni ordine; l'Equity Stop di Titany e' di software |
| 05 Esecuzione diversificata | niente, **e per regola non va cercato**: la regola di casa e' _"mai due EA stesso segnale/simbolo/lato a rischio pieno"_ (i nostri EA sono nostri, con magic diversi; non c'e' nulla da mimetizzare) | **buco voluto** |
| 06 Quattro profili (prudente-aggressivo) | rischio a taglia fissa **0,65%** firmata da Claudio; "aggressivo" **non** e' un'opzione | **buco voluto** (la taglia e' di Claudio) |
| 07 Dimensionamento per coppia | rischio per sedia/simbolo da contratto e cluster (C2 spento e non serve, vedi CLAUDE.md 12/09) | nessun buco |

**Ipotesi da MISURARE (non da copiare), scritte prima dei numeri:**
- **H1.** _"Una sedia a media a peggiorare con cap fisso, SL al broker per ticket e perdita massima nota (T1-T3 passati) puo' avere un payoff accettabile sull'asse 'giornata laterale'?"_ Si risponde **solo con** `report/METRO_PROP.md` §13 (G1-G6, pacchetto = unita', T5 da dichiarare). **Non e' un'indicazione di fare**: oggi non c'e' un candidato in imbuto, la challenge FTMO e' viva e ogni ora va dove c'e' una sedia schierabile (CLAUDE.md, obiettivo con una data). Resta qui come ipotesi, **priorita' bassa**.
- **H2.** Nessuna proposta sul Guardian: **il confronto con K7 non fa emergere un buco** (§6, riga 04). Questo e' un risultato valido: _"il nostro Guardian copre gia' tutto cio' che ho trovato"_.

---

## 7. CONFRONTO CON LE NOSTRE REGOLE

- **Niente martingala/griglia/recovery** (CLAUDE.md, `METRO_PROP.md` §13). Test T1-T5 applicati alla *descrizione* del venditore (che vale zero secondo §13.1): **T1** (SL al broker per ticket) **non provato, riportato assente da AmicoBot** → se confermato, **scarto a vista**; **T2** (cap costante di ingressi) **[INCERTO]**; **T3** (perdita massima nota prima del primo ingresso) **non calcolabile** senza SL; **T4** (riarmo sulle perdite precedenti) **[INCERTO]** ("recupero" e' la parola usata da AmicoBot); **T5** (la size cresce verso lo stop) **numero di ticket doppio** anche a lotto invariato.
- **`CANCELLO_ACQUISTI_EA.md`**: gradino **1** (scheda): fatto qui. **1-bis** (due diligence venditore): fatto qui, vendor **opaco, non "marcio" in senso FPA** (nessun dossier FPA trovato). **2** (setaccio): **bandiere rosse presenti** (averaging dichiarato, no-SL riportato). **3** (demo nel tester): **impossibile**, perche' Titany **non ha una demo nello Strategy Tester** (vendita su sito proprio, licenza a account MT4, nessuna scheda MQL5 Market), **non ha sorgente**, e AmicoBot riferisce che la richiesta di licenza di prova **non ha avuto risposta**. Regola "chi non ha demo testabile, non si compra". **Non propongo l'acquisto.**
- **Certificato di morte** (CLAUDE.md 09/09): non si applica, e va detto: Titany **non e' un candidato che archiviamo come morto**, e' un candidato **NON MISURABILE** (nessun PF/n/DD nostro, nessun asse da mettere), e "non misurabile" non e' "morto". La via piu' corta a un numero sarebbe una **licenza di prova + export dello storico ordini** (si legge il campo `sl` e si conta il pacchetto): costo = **una richiesta scritta a Titany** (se non risponde, e' gia' una risposta) + un terminale demo. Non lo propongo per priorita', ma resta la mossa.
- **Motto "non accontentarsi ma non illudersi"**: non accontentarsi vuol dire aver cercato il meccanismo dietro il marketing (fatto) e aver controllato il nostro Guardian contro i sette pilastri (fatto: nessun buco). **Non illudersi** vuol dire che un 92% su 25 operazioni con -265 USD flottanti non e' un numero, e che "azzerando il rischio" e' una frase, non una misura.
- **Regola della seconda caccia**: non scatta (non c'e' un motore nostro dichiarato senza edge). Nessun meccanismo alternativo da cercare.
- **Regola D3 di casa** (confermare per iscritto prima di comprare una challenge con EA): Titany e' l'esempio perfetto del perche' esiste. **Per qualsiasi uso di un EA su una prop, la risposta della prop va chiesta e archiviata in forma scritta**, e un venditore che dice "ammesso" non conta.
- **Bussola**: questo dossier e' **ponteggio** (protegge Claudio da una spesa di 1.400-4.000 euro e da un uso che puo' costare una challenge), **non una sedia**. Dichiarato come tale.

---

## 8. REPORT PER CLAUDIO (in chat)

**Titany X non e' una truffa dimostrata, ma non e' affidabile per le prop. Fiducia 15/100.** Non l'ho potuto aprire (il sandbox blocca tutto l'esterno, anche FTMO), ho lavorato su risultati di ricerca: i dati sono da riaprire.
1. Dietro c'e' **Digital Infobiz LLC (USA, Wyoming, indirizzo da agente registrato)**, fondatore dichiarato Tommaso Nardini; **non e' autorizzata Consob/OCF** (lo scrive lei stessa). Prodotto da 1.397 a 3.997 euro, **MT4**, formazione a parte.
2. **"Distanza dinamica delle mediazioni" = media a peggiorare.** Il lotto non cresce ma i ticket raddoppiano contro-trend. Un test di terzi (demo, 25 operazioni) riporta **nessuno stop loss** e **-265 USD aperti non contati** nel "92%".
3. **"Esecuzione diversificata" e' una difesa dalla rilevazione di copy trading**, e le regole di Axi Select, Funding Pips, The5ers e FTMO (tetto per strategia) **non si risolvono variando orari e prezzi**.
4. **Nessun track record verificato del venditore**: un solo conto reale pubblico, ~78 euro di profitto su 1.427 di versamenti.
5. **Per noi**: il Guardian copre gia' l'Equity Stop (e fa di piu'); gli altri pilastri sono o gia' presenti o voluti-assenti. **Nessuna proposta di modifica.** Nessun acquisto: non passa il gradino 1 del cancello (nessuna demo nel tester).

Se vuoi, scrivi a Titany una riga e chiedi una licenza di prova con export dello storico: se non risponde, e' la risposta.

Fonti principali e URL sono nelle tabelle sopra; il `controllo-caccia` deve riaprire in particolare: `titany.co/funnel-algoritmok7/`, `titany.co/help-center/`, `titany.co/termini-di-utilizzo/`, le pagine FTMO/Axi/The5ers/Funding Pips, `amicobot.it/blog/titany-x-recensione-risultati-reali-test-prop-firm/`, Trustpilot, e l'URL Altroconsumo `b58fcefc0ced8ae831`.
