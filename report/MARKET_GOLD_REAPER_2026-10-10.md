# MARKET: "The Gold Reaper MT5" v5.1 (Profalgo Limited / Wim Schrynemakers), 10/10/2026

**BOZZA, NON passata dal cancello** (`controllo-preventivo` e `controlla_riga.py` non ancora invocati). Non e' una consegna operativa: e' un dossier di lettura + un piano da NON eseguire senza firma e senza cancello.

Letto OGGI, 10/10/2026, da sandbox: **solo web pubblico + i due screenshot di Claudio, sola lettura**. Scaricati dalla pagina pubblica del prodotto (cartella temporanea di sessione, **non nel repo**): il **manuale PDF v5.1** (zip linkato dal venditore) e il **set file prop** (`propfirm__1.set`, testo). **Nessun `.ex5` scaricato, nessuna registrazione, nessun login, nessuna decompilazione, nulla eseguito, nessun terminale/conto/EA/preset toccato.**

Etichette: **[VERIFICATO]** letto da me oggi su pagina/manuale/set/screenshot · **[DICHIARATO DA TERZI]** detto dal venditore o da un utente: mai un criterio, mai nel punteggio · **[MQL5, dato di piattaforma]** statistica calcolata da MQL5 · **[DERIVATO]** aritmetica mia su numeri letti · **[INFERITO]** deduzione, con la ragione · **[INCERTO]** non lo so.

---

## 0. LA RIGA CHE CONTA

> **Il prodotto e' una scatola nera a pagamento (949 USD, noleggio da 399 USD/3 mesi), senza sorgente, con 69 input visibili di cui NESSUNO descrive la logica d'ingresso. Come EA da schierare e' incompatibile con il nostro involucro (rischio % di casa, Guardian, cap C1) e porta tre bandiere rosse di casa: WebRequest/licenza verso host del venditore, funzioni dichiaratamente pensate per rendere diverse le operazioni fra conti prop ("Randomization", "Propfirm unique trades"), e una parola ambigua del venditore ("breakouts, protection, RECOVER") che il setaccio non puo' sciogliere senza il codice.**
> **Come STRUMENTO DI RICERCA e' interessante a costo basso:** la meccanica e' leggibile dall'esterno (ordini pendenti, SL/TP/trailing, 9 strategie annidate) e un piano di scatola nera nel tester a tick reali la puo' misurare in 13 passate, **solo osservando l'output** (nessuna decompilazione).
> **Punteggio provvisorio scheda: 2/10 come candidato da schierare (SCARTO < 5). Come oggetto di misura a costo quasi zero: IN CODA, dopo GBA R2 e le sedie.**

---

## 1. ACCESSO E CONTROLLO POSITIVO (fatto prima di leggere)

| fonte | bersaglio noto | esito |
|---|---|---|
| `mql5.com/en/market/product/111357` (WebFetch) | titolo/versione/data = screenshot di Claudio ("The Gold Reaper MT5 5.1 (XAUUSD,H1)") | **PASS**: titolo "The Gold Reaper MT5", **v5.1, aggiornato 2 ottobre 2026**, Profalgo Limited. Coincide con la barra del titolo dello screenshot |
| controllo incrociato manuale <-> screenshot | i default dello screenshot devono coincidere col manuale v5.1 | **PASS**: spot-check su una quindicina di default (Max Allowed Spread 500, Friday stop 25, Seconds 99, Base Magic 8000, NFP 100/60, Max DD 30, Weighted true, OnlyUp true, Backtest Speed normal ...). Tutti uguali. Il manuale e' dunque della stessa versione degli screenshot |
| controllo incrociato set file <-> commento del venditore | il set prop ha `TradeFrequency=2`; il commento #1 (29/01/2024) dice "moderate" | **PASS**: nell'ordine del manuale (extreme conservative, conservative, moderate, Intense, Extreme, Auto, Manual) l'indice 2 e' **moderate** [INFERITO l'enum 0-based, confermato da questo incrocio] |
| `.../111357/updates` | storico versioni | **200**, 36 voci (sintesi al par. 4.3) |
| `.../111357/comments` + `page1`, `page2`, `page13`, `page14`, `page15`, `page16` | commenti | letti; **329 commenti totali, ne ho letti solo quelli di 6 pagine su 17** |
| `.../signals/2265877` | segnale linkato | **200**, statistiche lette (par. 3.4) |
| `c.mql5.com/31/2447/Gold_Reaper_V5_1.zip` | manuale | **200**, 110.884 byte, contiene `Gold_Reaper_V5.1.pdf` 12 pagine, testo estratto per intero |
| `c.mql5.com/31/1047/propfirm__1.set` | set prop | **200**, 2.009 byte, ASCII |
| **NON RAGGIUNTE** | `forexeasolutions.com`, `newyorkcityservers.com`, `fxroboteasy.com`, `globegain.com` | **DNS `ENOTFOUND` dal proxy** (non e' un 404: non so cosa contengano). **Il sito del venditore e le "recensioni" affiliate non sono state lette**; quel che ne dico viene solo dagli **estratti dei risultati di ricerca**, marcati [SNIPPET, pagina non aperta] |

**Attenzione omonimi (verificato aprendole):** `market/product/178260` "Gold Reaper" e' un **INDICATORE** di un altro autore (Wycliffe Wanjala Wanyonyi, 79 USD, v3.0 del 23/05/2026, dichiara "74% fino a 89%"): **non e' questo prodotto** e i suoi numeri NON vanno attribuiti all'EA. Esistono anche "Gold Reaper X" (161778) e "Gold Reaper X Pro" (179477): non letti, sono altri prodotti.

**Limite dello strumento:** `WebFetch` **riassume** con un modello piccolo e a volte tronca (la pagina e' 109.125 caratteri; ho riletto l'ultimo pezzo con offset). I numeri che contano (prezzo, versione, input, default) li ho incrociati con manuale, set file e screenshot; quelli che non ho potuto incrociare sono marcati.

---

## 2. TRASCRIZIONE DEGLI INPUT (screenshot 145 e 146, 10/10/2026 19:54) [VERIFICATO sugli screenshot]

Finestra: **"The Gold Reaper MT5 5.1 (XAUUSD,H1)"**, schede "Comune" / "Dati in Ingresso", pulsanti Carica / Salva / Annulla / Resetta. Tipo letto dall'icona (bool, int, double, string, enum). Tutti i valori sono **i default** (confermato col manuale).

> Nota [INFERITO]: la finestra con le schede "Comune"/"Dati in Ingresso" e i pulsanti Carica/Salva e' quella delle **proprieta' di un EA su grafico**, non il pannello dello Strategy Tester. Dimostra che il demo e' installato e che gli input sono quelli; **non dimostra che giri nel tester**.

### 2.1 Generali e infopanel

| input (etichetta esatta) | tipo | valore |
|---|---|---|
| UseVariableValues | bool | true |
| AdjustLotsizeToVariableValues | bool | true |
| ShowInfoPanel | bool | true |
| update infopanel during testing | bool | false |
| Adjustment for Infopanel size | double | 1.0 |
| Force Font Size (0=disabled) | int | 0 |
| Backtest Speed (sezione "Backtest Speed settings") | enum | normal |

### 2.2 Sezione "settings"

| input | tipo | valore |
|---|---|---|
| Allow Buy Trades | bool | true |
| Allow Sell Trades | bool | true |
| TradeFrequency | enum | Auto (based on balance and risk) |
| Max Allowed Spread | double | 500.0 |
| UseHL_TrailingSL | bool | true |
| Friday stop hour (brokertime; close all trades+pending) | int | **25** (= disattivato, il manuale: "any value above 23 disables") |
| delete pending orders | bool | true |
| close open trades | bool | true |
| setSL_TP_After_Entry | bool | false |
| Use Virtual Expiration | bool | true |
| Randomization (entries and exit) in pips | double | 0.0 |
| Fake Breakout Filter | enum | Medium (opzioni da manuale: OFF, Low, Medium, High) |
| Enable Virtual SL/TP (trailing by market close) | bool | false |
| Seconds before the real SL is pulled up to the virtual SL (0 = ... testo troncato) | int | 99 |
| Base Magicnumber | int | **8000** |
| Comment for trades | string | The Gold Reaper |
| RemoveCommentSuffix | bool | false |

"delete pending orders" e "close open trades" sono nello screenshot, **non nel manuale**: [INFERITO] sono le azioni dello stop del venerdi' (che e' spento di default).

### 2.3 Filtri notizie

| input | tipo | NFP | Interest Rate | CPI |
|---|---|---|---|---|
| Enable...Filter | bool | **true** | **false** | **false** |
| UseMQL5Calendar | bool | true | n/a | n/a |
| AutoGMT | bool | true | n/a | n/a |
| GMT_OFFSET_Winter (AutoGMT=false or backtesting) | int | **2** | n/a | n/a |
| MT_OFFSET_Summer (etichetta cosi' nello screenshot; manuale: GMT_OFFSET_Summer) | int | **3** | n/a | n/a |
| ..._CloseOpenTrades | bool | true | true | true |
| ..._ClosePendingOrders | bool | true | true | true |
| ..._MinutesBefore | int | **100** | 100 | 100 |
| ..._MinutesAfter | int | **60** | 60 | 60 |

### 2.4 "Propfirm unique trades settings"

| input | tipo | valore |
|---|---|---|
| AdjustEntry · AdjustSL · AdjustTP · AdjustTrailSL · AdjustTrailTP · AdjustBreakEven | double (x6) | 0.0 tutti |

### 2.5 "LotSize Settings"

| input | tipo | valore |
|---|---|---|
| manually set balance to use (if > 0) | double | 0.0 |
| Lotsize calculation method | enum | **Max Allowed Total Drawdown** (opzioni da manuale: use StartLots / Max Allowed Total Drawdown / Max Risk Per Strategy) |
| StartLots | double | 0.01 |
| Max Allowed TOTAL Drawdown | double | **30.0** |
| Weighted Lotsize | bool | true |
| Max Risk Per Strat | double | 1.0 |
| Set Max DAILY Drawdown (Prop Firms) | double | **0.0** (= disattivato) |
| OnlyUp | bool | **true** |
| Reset Highest Balance for OnlyUp | bool | false |
| CheckMargin | bool | true |
| Use Equity Instead of Balance | bool | false |

### 2.6 "Manual Strategy Selection"

Riga di avviso nello schermo (string): **"!! DO NOT RUN MANUAL STRATEGIES WHILE USING 'MAX ALLOWED TOTAL DD' OPTION !!"**

| input | tipo | valore |
|---|---|---|
| Run Strategy 1 (low risk) · 2 (low risk) · 3 (low risk) | bool | true |
| Run Strategy 4 (med risk) · 5 · 6 · 7 (med risk) | bool | true |
| Run Strategy 8 (high risk) · 9 (high risk) | bool | true |

**Conteggio [DERIVATO]: 69 input visibili** (6 generali + 1 speed + 17 settings + 9 NFP + 5 IR + 5 CPI + 6 prop + 11 lotto + 9 strategie). Di questi **nessuno e' un parametro della logica d'ingresso**: il motore e' interamente interno; fuori ci sono solo spostamenti (`Adjust*`), filtri e gestione. Regola di casa (>15 input = un punto in meno): qui il numero e' alto ma e' composto soprattutto da cosmetica/notizie/compatibilita'; **il vero problema e' opposto: i parametri che contano non si vedono**.
Il manuale elenca in piu' un input **"License Key"** (solo per chi non compra su MQL5): nello screenshot non c'e' [VERIFICATO, coerente: versione MQL5].

---

## 3. LA PAGINA PUBBLICA (letta 10/10/2026)

### 3.1 Scheda [VERIFICATO sulla pagina; tutto il resto e' DICHIARATO DA TERZI]
| campo | valore |
|---|---|
| Venditore | **Profalgo Limited**, sviluppatore **Wim Schrynemakers**, Malta. Voto venditore **4,1 su 1.009 voti**, 27 prodotti, 29 segnali [MQL5, dato di piattaforma] |
| Pubblicato / aggiornato | 01/02/2024 / **02/10/2026**, **v5.1** |
| Prezzo | **949 USD** in testata; il testo dice **"Final price: 990$"** (incoerenza non spiegata). **Noleggio: 399 USD / 3 mesi, 499 / 6 mesi, 699 / 1 anno** |
| Attivazioni / demo / acquisti | **10 attivazioni** · **33.175 demo scaricate** · "143 acquisti al mese" (cifra di vetrina) |
| Voto prodotto | **4,49**, **116 recensioni**, **329 commenti**. Gli estratti di ricerca di altri giorni davano 4,43/83, 4,47/103, 4,46/92-108: sono **istantanee piu' vecchie** [SNIPPET]. La distribuzione per stelle non e' leggibile dal mio strumento |
| Deposito minimo dichiarato | **600 USD** (la scheda di un rivenditore in [SNIPPET] dice 300: non aperta) |
| Sorgente | **NESSUNO** (prodotto Market, solo `.ex5`). Demo: sezione "Free Demo" |
| Link sulla pagina | segnale live `signals/2265877` · set prop `.../1047/propfirm__1.set` · manuale zip · "Client Signal" (in realta' un commento, vedi 3.5) · "Ultimate Combo Deal" (blog post 751134) · gruppo pubblico di messaggi · URL da autorizzare: `worldtimeserver.com` |

### 3.2 Cosa DICE la descrizione [DICHIARATO DA TERZI]
- Evoluzione del loro "Goldtrade Pro"; **breakout di supporti e resistenze** su XAUUSD, **"piu' timeframe contemporaneamente"**, "diversi algoritmi di conferma", **"piu' strategie interne per spargere il rischio"**; "ogni trade ha SL e TP, piu' trailing SL e trailing TP".
- Frequenza e lotto **si adattano a "saldo e max drawdown consentito"**. Timeframe: **H1 raccomandato, "il grafico non conta", "non cambiarlo mentre gira"** (commento 01/02/2024).
- **"No grid / No Martingale / No risky risk management"**; "stress-tested sulla storia piu' lunga dell'oro con piu' feed".
- **"PROP FIRM READY"**, "facile da usare per le prop".
- **Il testo NON parla di**: "fake breakout" (appare solo nelle note di versione), 9 strategie (solo nel manuale), win rate, "Weighted" (solo manuale). **Non ci sono numeri di backtest sulla pagina** [VERIFICATO: nessun "win rate 9x%"].

### 3.3 Il manuale v5.1 (5/10/2026) [VERIFICATO, contenuto DICHIARATO DA TERZI]
- "fino a **9 strategie interne** che girano **simultaneamente** per spargere il rischio"; livelli: **1-3 low, 4-7 medium, 8-9 high risk**.
- **UseVariableValues**: "l'oro e' circa raddoppiato... un SL o una distanza d'ingresso fissa non vale piu' lo stesso: l'EA **scala ogni distanza di ingresso, SL, TP e trailing in proporzione al prezzo corrente dell'oro**". Il manuale lo raccomanda anche nei backtest.
- **Fake Breakout Filter**: "dopo l'apertura, controlla se la **candela su cui e' entrato ha chiuso a favore**; se ha chiuso contro, **chiude subito** il trade invece di lasciarlo arrivare allo SL"; livelli piu' forti = lo stesso controllo su piu' timeframe.
- **HL trailing**: trailing "dietro swing high/low recenti", solo per le strategie configurate per usarlo.
- **Max Allowed TOTAL Drawdown**: "dici all'EA il drawdown totale massimo che accetti, e lui **dimensiona ogni strategia in modo che il PEGGIOR CASO STORICO resti dentro quella cifra**". Consiglia "10-30%".
- **Weighted Lotsize**: "spalma il rischio in modo uniforme fra le strategie... perche' le strategie hanno drawdown storici diversi".
- **OnlyUp**: "ricorda il saldo massimo e dimensiona da quello: un drawdown non riduce anche le taglie... **piu' aggressivo**".
- **Randomization** (valore consigliato **~50** per le prop) e **Propfirm unique trade settings** (`Adjust*`): "se fai girare lo stesso EA su piu' conti, trade identici possono essere **segnalati come copy trading**". `RemoveCommentSuffix`: "qualche prop firm o servizio di copia lo preferisce".
- **Test**: "modalita' 1 Minute OHLC o tick reali"; nel tester il **calendario MQL5 non c'e'**, l'EA ripiega su **date di notizie interne cablate** (note v4.0: "aggiornate fino a fine 2026").
- **URL da autorizzare nel terminale (Strumenti > Opzioni > Expert Advisors)**: `forexeasolutions.org`, `forexeasolutions.services`, `tradewithwim.com`, `worldtimeserver.com`, `nfs.faireconomy.media` — "per **licenza, backup**, AutoGMT e filtro NFP".
- Gestione: "ogni strategia ha il suo magic **contando in su dalla base**"; "ogni trade porta nel commento l'ID della strategia" (si toglie con `RemoveCommentSuffix`).
- Prop: "usa il set prop dedicato, abilita Max DAILY Drawdown, alza Randomization".
- Lotto: "StartLots = lotto **per strategia**, non per conto".

### 3.4 Il segnale linkato [MQL5, dato di piattaforma, letto 10/10/2026]: "Gold Reaper New V2 2" (`signals/2265877`)
| voce | valore |
|---|---|
| Crescita / settimane | **353,71%** in **102 settimane**; deposito iniziale **1.602,85 USD**, saldo 6.853,03 USD; prelievi 100 USD |
| Operazioni | **895** (646 vinte, 249 perse) · **win rate 72,17%** · **PF 2,33** · atteso/operazione 5,98 USD · **13 op/settimana** · tenuta media **4 ore** |
| Drawdown | **massimo per saldo 461,01 USD = 6,58%** · per equity relativo **7,18%** · relativo di saldo 16,89% (319,49 USD) · fattore di recupero 11,61 · Sharpe 0,22 |
| Broker / leva | CapitalPointTrading-MT5-4 · **1:500** · solo XAUUSD |
| Prezzo / iscritti | 35 USD/mese · 67 iscritti · 16 recensioni, voto 4,1 (utenti: ordini non copiati, slippage, deposito troppo piccolo per il lotto minimo) |
| **Avvisi di MQL5 sulla pagina** | **"Share of days for 80% of growth is too low"** (10/06 e 07/04) = il profitto e' concentrato in pochi giorni; "nessuna attivita' negli ultimi 6 giorni" (23/09) |

- **[DERIVATO] payoff**: con PF 2,33 e win rate 72,17% il rapporto vincita media/perdita media e' **2,33 x 249 / 646 = 0,90**. Cioe' **vincite quasi uguali alle perdite, 72% di successi**: non e' un profilo da "trend con code lunghe", e' un profilo da **uscita rapida e stop vicino a pareggio**. [INFERITO] compatibile con Fake Breakout + trailing stretto.
- **[DICHIARATO DA TERZI] la descrizione del segnale dice "30% max DD"**: il segnale misura 6,58%. **Non so con quali impostazioni giri il segnale ne' se giri la v5.1** [INCERTO]: il nome "New V2 2" e' di un'altra era del prodotto.
- Il venditore cita altri segnali: un "+309,35%" (22/09) e un account cliente "da ~400 a oltre 91.000 USD in 20 mesi" (commenti 22/09 e 01/10; l'immagine e' dietro uno `shorturl` che **non ho aperto**). **Non verificabili.**

### 3.5 Recensioni e commenti (tutti quelli letti, anche i negativi)
**Negativi o critici** [DICHIARATO DA TERZI, utenti]:
- **Paul Thomas, 26/09/2026, 1 stella**: "mi svuota il conto ogni giorno", piu' perdite che vincite in un mese. Risposta del venditore: la perdita e' "~5% contro fino a 30% nei backtest", "recensione prematura", "fai backtest visivi".
- **bc01, 14/06/2026, 1 stella poi 2**: due operazioni a perdita dopo il **gap del weekend**; chiede protezione chiusura/apertura. Risposta: "due trade sono pochi per giudicare", usa **Friday Stop Hour** (che di default e' spento).
- **Matthews994, 06/10/2026 (pagina 16)**: **"un conto prop e' saltato nonostante le impostazioni prop"** e il suo conto live e' peggio. Dichiara **9% DD totale + 4% giornaliero**, ma **la prop ha bocciato a una perdita giornaliera del 3%**. Il venditore: "problema di setup", chiede screenshot e **quale regola e' stata violata**. **Nessuna risoluzione postata.** [DICHIARATO DA TERZI, non verificabile; e' l'unico caso di prop fallita che ho letto]
- **BoysTRX / nokia076, febbraio 2024**: "trash", "mostrami un segnale di 5 anni", "un grid con drawdown gigante" (su uno screenshot). Il venditore e altri utenti sospettano un concorrente (la recensione e' del primo giorno). **Non e' una prova ne' in un senso ne' nell'altro.**
- **Venditore stesso (06/08/2026)**: "ho ricevuto messaggi da piu' clienti nuovi per controllare se le perdite erano normali... **le perdite sono normali, i periodi di drawdown sono normali**". Altri (Thai Son Nguyen): "sistema di breakout con fakeout, **giralo almeno 6 mesi**".
- **Il venditore ammette (05/02/2024) che i suoi vecchi EA decadono**: del "Reaper EA (the night scalper, NOT Gold Reaper)" scrive "ha fatto benissimo al lancio... **alla fine ha svuotato il conto**" e "il night scalping e' diventato molto difficile negli ultimi 2 anni". **Non riguarda questo prodotto**: lo riporto come dato sul tipo di vita media dei suoi motori, non come accusa.

**Positivi** (stesse etichette): passate prop segnalate (Semih Seyir: "50k finanziato, ~3k di payout in 6 mesi, DD < 2%", **"4-5 mesi per superare"**; Bangkok_Baz il 21/09 a "2,6% su target 5%" su una FTMO; RussellKing +~8.000 GBP su 20.000), "backtest e live corrispondono" (ReptonPark777), curva a gradini con periodi fermi (Pablo Sanz Moniche: 15.668 -> 18.069 USD in 11 settimane). **Nessuna di queste e' verificabile da me.**

**Frasi del venditore sulla meccanica [DICHIARATO DA TERZI]**:
- **22/09/2026 (pagina 15): "breakouts, protection, RECOVER. No grid. No martingale."** e "quasi due anni delle stesse strategie di base".
- 03/09/2026 e 09/07/2026: il suo account live gira su **"extreme trade frequency"** con **"204% max allowed total DD :-p"** ("molto alto rischio"); "puro breakout trading... senza ANY grid o martingale".
- 03/02/2024: **"Extreme" = trade frequency, non rischio**: "fa tutti i trade dei setup a frequenza piu' bassa piu' altri"; "aggiunge piu' strategie salendo di frequenza" -> **le 9 strategie sono ANNIDATE per livello di frequenza** [INFERITO].
- 03/02/2024: un utente conta **~450 trade a 0,03 lotti in Auto contro ~2.400 trade a 0,01 in Extreme** [DICHIARATO DA TERZI, un solo utente, periodo ignoto].
- 07/05/2026: "il max drawdown storico del setting 'very conservative' e' circa 300 USD" (su quale deposito/lotto non e' detto).
- 06/02/2024: "gli ordini pendenti non c'erano ancora" (avviato nel weekend) -> **ci sono ordini pendenti** (par. 5).

---

## 4. LE TRE FOTOGRAFIE CHE TORNANO UTILI

### 4.1 Il set prop del venditore [VERIFICATO, file letto]
`TradeFrequency=2` (moderate) · `MaxAllowedDD=9` · `PropFirmMaxDailyDD=4` · `OnlyUp=0` · `Randomization=0` · `StartLots=0,01` · `Risk=1234` (**[INCERTO]** cosa sia; probabilmente il codice interno del metodo di lotto) · `FridayStopHour=25` · `MaxSpread=500` · `UseEquity=0` · magic `ST1_MagicNumber=8000`.
Quindi: **il default venduto (30%, OnlyUp true, giornaliero 0) NON e' la configurazione prop**: la configurazione prop e' un set separato a **9% / 4%**, con **OnlyUp spento e Friday stop ANCORA spento (25)**. Il set e' pubblicato dal 29/01/2024 (commento #1: "sulla base di DD storico massimo del 9% e giornaliero del 4%").

### 4.2 Cosa significa "Max Allowed Total Drawdown = 30" [INFERITO dal manuale, par. 3.3]
- **NON e' un limite**: il manuale dice che dimensiona le strategie "in modo che il peggior caso STORICO resti dentro la cifra". Cioe' **lotto = f(saldo, 30% / DD storico del cesto a lotto unitario)**, con "storico" = **il backtest del venditore, sul suo feed**. Nessuno stop di equity al 30%; l'unico freno vero e' il giornaliero, **spento di default**.
- Conseguenza: un DD storico del cesto diverso sul NOSTRO feed (spread, orari, tick) **non cambia il lotto**; il DD reale sul nostro feed puo' essere maggiore o minore del 30%. **E' esattamente il tipo di numero che per noi vale zero finche' non lo misuriamo.**
- **[DERIVATO] 30% contro 9%**: a parita' di tutto i lotti sono circa **30/9 = 3,3 volte** quelli del set prop. Contro i nostri muri (10% totale, 5% giornaliero, p99 di casa ~8,1% a 0,65%/trade su 27 serie) il default **sfonda il 10% per costruzione dichiarata** (il venditore stesso dice "fino a 30% nei backtest").
- Il caso Matthews994 (9%/4% e prop fallita a -3% giornaliero) e' coerente con questo schema: **9% di DD storico del cesto non protegge un giornaliero del 3-5%** [INFERITO, non provato: dichiarazione di un utente].
- **"Max Risk Per Strat 1,0"** e' un metodo di lotto alternativo: rischio % PER STRATEGIA, e il manuale dice "esposizione totale ~ questa cifra x numero di strategie attive". [INCERTO] se e' rischio per trade (entro-SL) o altra cosa: **si misura nel tester** (perdita a SL / saldo).

### 4.3 OnlyUp, Weighted, versioni
- **OnlyUp** [INFERITO dal manuale]: la taglia segue il picco di saldo, non il saldo. Non e' una martingala (non sale dopo una perdita), **ma il rischio relativo al saldo cresce quando si e' in drawdown: 1/(1-d) = 1,11x a -10%, 1,25x a -20%, 1,43x a -30%** [DERIVATO]. E' la forma opposta a quella di casa (la sedia non si ingrandisce quando perde) ed e' **acceso nel default**. Il picco e' salvato in una variabile globale (v4.4).
- **Weighted** [DICHIARATO DA TERZI]: pesi dei lotti legati ai DD storici per strategia (numeri che non vediamo).
- **Storico versioni** (letto, riassunto dallo strumento, 36 voci): **v1.10 05/02/2024 -> v5.1 02/10/2026**. Le voci che toccano la meccanica: **v2.0 (19/09/2024)** selezione manuale delle strategie + metodo "Max Risk Per Strategy" + lotto "weighted" · **v2.2 (22/10/2024) Fake Breakout Filter** ("controlla se la chiusura della candela dopo l'ingresso e' negativa; il timeframe dipende da Low/Medium/High") · v2.3 (23/10/2024) il filtro "high" **non faceva nulla** fino ad allora · **v3.0 (02/12/2024)** distanze che si adattano al prezzo dell'oro (VariableValues) · v3.5 (17/07/2025) "corretto il calcolo del lotto durante i drawdown" · v4.4 (02/05/2026) OnlyUp migliorato · **v4.7-v5.1: sei rilasci in cinque giorni (28/09-02/10/2026)**: virtual SL/TP, filtri CPI e tassi, "corretto un problema con i broker con sessioni particolari" (il manuale: *"su quei broker, trailing e altra gestione potevano prima fermarsi per la maggior parte del giorno"*).
  **[DERIVATO] conseguenza:** il codice che il demo esegue oggi **non e' quello che ha generato recensioni, segnale e "20 mesi" del venditore**; e il 5.1 e' vecchio di **otto giorni**. Qualunque misura nostra e' **sulla v5.1 del 02/10/2026** e va datata cosi'.

---

## 5. COSA SI PUO' DEDURRE PER STRUTTURA, E COSA NO

**Onesta' prima di tutto: dal solo pannello Input NON si ricava il codice.** Gli input descrivono **gestione, filtri e compatibilita'**, non la regola d'ingresso: non c'e' un periodo, una soglia, un livello, un'ora. **Non sappiamo come siano definiti "supporto/resistenza", ne' su quali timeframe, ne' a che ora si armano gli ordini, ne' cosa sia "recover".** Tutto cio' che segue e' ricostruzione dall'esterno, con la riga che la sostiene.

| punto | deduzione | etichetta e ragione |
|---|---|---|
| **tipo d'ingresso** | **ordini pendenti** (verosimilmente buy stop sopra / sell stop sotto i livelli) con scadenza | [INFERITO, forte]. Input: "delete pending orders", "Use Virtual Expiration" ("deve cancellare da se' gli ordini quando sono vecchi"), "setSL_TP_After_Entry" ("brokers che rifiutano pendenti con SL/TP"), NFP/IR/CPI "ClosePendingOrders", "Max Allowed Spread: massimo spread per gli ordini pendenti" (descrizione), commento del venditore "gli ordini pendenti non c'erano ancora". **[INCERTO]** se tutte e 9 le strategie usano stop e non anche limit (le 8-9 "high risk" e il "recover" potrebbero essere altro) |
| **SL / TP** | distanza fissa dichiarata, **scalata in proporzione al PREZZO**, non all'ATR | [INFERITO dal manuale UseVariableValues]. **E' falsificabile**: par. 6, atteso E7 |
| **uscita** | SL fisso + TP fisso + **trailing SL + trailing TP + trailing HL (swing)** + break-even + **uscita a mercato se la candela d'ingresso chiude contro (Fake Breakout)** + chiusura per notizie/venerdi' | [VERIFICATO nel manuale e nelle note di versione; i parametri sono ignoti] |
| **la tesi** | **breakout di S/R sull'oro su piu' timeframe con stop vicini e uscita rapida** (payoff 0,90, durata media 4 ore sul segnale) | [INFERITO]. **Si scrive in una riga ma non e' una tesi di mercato:** e' la descrizione di una forma, non il "perche' guadagna". E' la famiglia di **GBA** (breakout canale + EMA sull'oro, PF_V 0,855 a tick reali in `GBA_R2_PIANO`, citato dal report gemello e non ricontrollato qui) e di `MaxMinNotte` 770402 (box notturno oro) |
| **9 strategie** | **annidate per frequenza**: Extreme = tutte; piu' conservative = sottoinsiemi; rischio crescente 1->9 | [DICHIARATO DA TERZI, venditore]; il numero di magic per strategia e' [INFERITO] |
| **sizing** | lotto proporzionale al saldo (o al picco, con OnlyUp), tarato su un DD storico altrui | par. 4.2 |
| **simmetria** | long e short abilitati entrambi (default true) | [VERIFICATO] gli input. [INCERTO] se la quota short sia reale: un recensore parla di "solo buy" per un altro prodotto, non per questo |

### 5.1 Bandiere rosse di casa (§4 delle regole di caccia)

| bandiera | esito | prova / limite |
|---|---|---|
| **martingala / raddoppio** | **[INCERTO], non escludibile senza tester** | dichiarato "no martingale"; **il venditore scrive "breakouts, protection, RECOVER"** (22/09/2026). "Recover" non e' una parola che si usi per un breakout puro |
| **griglia / averaging** | **[INCERTO]** | dichiarato "no grid"; pendenti multipli a livelli diversi potrebbero sommarsi (una recensione 2024 dice "un grid... drawdown gigante" su uno screenshot, **non verificabile**) |
| **recovery / hedge di copertura** | **[INCERTO], sospetto per la parola "recover"** | stesso punto; **e' la prima cosa che il piano di scatola nera deve provare o escludere** |
| **nessuno stop** | **NO** [DICHIARATO]: "ogni trade ha SL"; con virtual SL spento (default) lo SL e' sul server. **Con `Enable Virtual SL/TP` ON il trailing e' interno e la chiusura e' a mercato**: protezione dipende dall'EA acceso | manuale par. "Virtual Stop-Loss" |
| **lotto fisso senza rischio %** | **NO** (lotto da DD-target o da rischio per strategia) | ma **il rischio non e' in % del conto come lo intendiamo noi**: e' scalato su un DD storico. Non e' il nostro `InpRiskPercent` |
| **repaint / look-ahead** | **NON VERIFICABILE** senza sorgente | l'EA decide su candele (il Fake Breakout aspetta la chiusura), cio' e' compatibile con il non-repaint; **non lo dimostra** |
| **indicatori esterni** | **NON VERIFICABILE** | un `.ex5` del Market e' autosufficiente per costruzione |
| **DLL / WebRequest / licenza / controllo conto** | **SI'** | **[VERIFICATO manuale par. 4]**: 5 host da autorizzare (licenza, **"backup"**, GMT, notizie). **[INCERTO] cosa significhi "backup" e cosa venga inviato.** In tester le chiamate web non ci sono; sul conto live ci sarebbero |
| **trucchi per aggirare le prop** | **SI', dichiarato dal venditore** | `Randomization` ("shifts entries, stops and targets by a small random amount... if you run the same EA on several accounts, identical trades across them can be flagged as copy trading"; consigliato ~50), sei `Adjust*`, `RemoveCommentSuffix` ("some prop firms and copy services prefer"). **Lo segnalo senza giudizio morale; per regola di casa i trucchi per aggirare le prop sono bandiera rossa**: una prop che vieta il copy-trading puo' trattare queste funzioni come tentativo di evasione, e rende i nostri conti non confrontabili col backtest (le distanze cambiano a ogni trade) |
| **niente sorgente** | **SI'** | solo `.ex5` |
| **win rate 9x%** | **NO** sulla pagina; **72,17%** sul segnale [MQL5] | con payoff 0,90 (par. 3.4). Non e' la firma "9x%" del martingala, ma **il martingala non si riconosce dal win rate: si riconosce dai lotti** |
| **DD 30% di default** | **SI'** | par. 4.2: 3x il nostro muro totale, e il giornaliero e' spento |

### 5.2 Incompatibilita' strutturale con le nostre sedie [INFERITO]
Le nostre protezioni (`ABTG_GuardiaIngresso`, cap rischio aperto C1 3,25%, tetto cluster) vivono **dentro il codice di ciascun EA nostro**. Un `.ex5` del Market **non puo' chiamarle**: l'unico freno sarebbe il giornaliero interno dell'EA (spento di default) e la taglia da "DD storico". **Come sedia da schierare, quindi, non entra: non si rifinisce (niente sorgente) e non si governa.**

---

## 6. IL PIANO DI SCATOLA NERA NEL TESTER (NON ESEGUITO, NON ESEGUIBILE SENZA FIRMA E SENZA CANCELLO)

**Scopo, scritto prima:** NON "capire se guadagna per comprarlo". Scopo: (a) vedere **se su NOSTRO feed, a tick reali, il motore fa qualcosa** (G1); (b) **leggere la forma** della sua meccanica come ipotesi per **un nostro EA** (breakout oro con uscita rapida); (c) **provare o escludere le bandiere rosse inferite** (recover/averaging/lotti). Gradino 3 di `CANCELLO_ACQUISTI_EA.md` ("demo nel tester").

### 6.1 Cosa e' lecito e cosa no
| azione | lecita? |
|---|---|
| lanciare il **demo scaricato col proprio account MQL5** nello Strategy Tester del **PC di backtest** e leggere report, lista ordini/operazioni, giornale, grafico visivo | **SI'**: e' l'uso per cui il Market offre il demo (le regole del Market, riportate in forum MQL5, dicono che il demo "si prova solo nello Strategy Tester" [SNIPPET di ricerca; non ho letto il regolamento ufficiale]) |
| misurare dall'output: n, PF, DD, orari, tipo d'ordine, distanze SL/TP, giorni, durata, sequenza dei lotti, posizioni concorrenti | **SI'** |
| confrontare piu' passate che cambiano UN input | **SI'**: sono ordinari input |
| **decompilare, disassemblare, estrarre stringhe o costanti dal `.ex5`, patchare, aggirare licenza/URL, intercettare il traffico verso gli host del venditore** | **NO, mai** |
| usare i **parametri** letti (distanze, orari, soglie) come parametri nostri | **NO**: sono i suoi (overfitting del venditore, sul suo feed). Servono come **ipotesi di FORMA**, e ogni parametro nostro va ricavato dall'altopiano dei nostri dati |
| mettere il demo su un conto o sul VPS | **NO**: il demo non gira fuori dal tester e **i round non girano sul VPS** (regola 21/09) |

### 6.2 Fase A: due cancelli (3 passate)
Finestra comune: **2025.03.01 -> data odierna**. Il **2025.03.01 e' il pavimento di tick reali dell'oro DIMOSTRATO** (R19 ci ha girato a Modello 4 con 151 operazioni, `prove/R134b_scatolaoro_XAUUSD.txt` r.284-288); **piu' indietro e' [NON MISURATO]**. Un solo regime (toro dell'oro): per il merito e' un limite, per il rischio un limite inferiore (Emendamento B).

Comune a tutte: `XAUUSD`, **H1**, **Modello 4 (tick reali)**, **Deposito 100000** (come R19), **Backtest Speed = normal** (le modalita' veloci processano meno aggiornamenti), `UseVariableValues` e `AdjustLotsizeToVariableValues` = true (default consigliato).
**Orologio:** nel tester le notizie usano le date cablate e **gli offset manuali 2 (inverno) / 3 (estate)** di default. **BCM da 02/2025 e' UTC+1 fisso** (`report/OROLOGIO_BCM_2026-09-24.md`, letto via CLAUDE.md, non ricontrollato qui): con 2/3 le finestre NFP **slittano di 1-2 ore**. Quindi `GMT_OFFSET_Winter = GMT_OFFSET_Summer = 1` **[DA VERIFICARE contro quel referto prima di scrivere la riga]**; in alternativa **filtri OFF** nelle 9 passate isolate (par. 6.3) per non confondere meccanica e calendario.

| passata | input cambiati | cosa misura |
|---|---|---|
| **G0** | default venditore **(Auto, Max DD 30, Weighted, OnlyUp)**, **la STESSA passata lanciata due volte** | **determinismo** (stesse cifre?) e che il demo **apra operazioni** nel tester. Se 0 operazioni: **il canale e' NULLO** (il demo e' limitato nel tester) e il piano si ferma |
| **G1-prop** | set prop del venditore: Auto-> **moderate (2)**, Max DD **9**, Daily DD **4**, OnlyUp **false** | **come si comporta il suo set prop sul nostro feed**: DD, **peggior giornata**, giorni a -3/-4/-5% |
| **G1-default** | = G0 (gia' fatta) | DD del default venduto sul nostro feed, da confrontare con "30%" |

**Criterio di stop scritto PRIMA dei numeri:** se G0 da' **0 operazioni** -> stop (canale nullo). Se G0 e G1 danno operazioni ma **PF < 1,0 su entrambe** -> il motore non riproduce sul nostro feed in questa finestra: **si chiude con "non riprodotto, NON ANCORA MISURATO in altri regimi"**, non con "morto" (certificato del 09/09: mancano gestione ad asse, TF, regimi). Se PF >= 1,0 -> Fase B.

### 6.3 Fase B: una strategia alla volta (10 passate)
Condizioni: **TradeFrequency = "Manual strategy selection"**, **Lotsize method = "use StartLots"** (il manuale vieta la selezione manuale col metodo Max Total DD), **StartLots = 0,10** (scelto perche' a 0,01 la perdita per trade sarebbe di pochi dollari e la lettura in R poco precisa; e' un lotto di misura, non di rischio), **OnlyUp = false**, **Daily DD = 0**, **NFP: filtri OFF** nelle 9 isolate (se l'orologio non e' verificato) e **ON con offset corretto** in una passata finale.

| passata | input | cosa misura |
|---|---|---|
| **B1...B9** | `Run Strategy k = true`, **tutte le altre false** (k = 1..9) | per strategia: n, PF, DD, orari d'ingresso, tipo d'ordine, SL/TP (USD, % del prezzo, ATR H1), giorni, durata, quota di uscite per SL/TP/trailing/market |
| **B10** | **tutte e 9 true**, stesso lotto | **additivita'**: la somma delle B1-B9 deve eguagliare B10 entro il rumore. Se no: **le strategie sono accoppiate** (stato condiviso, "recover" fra strategie) |

**Magic** (base 8000): [INCERTO] se la strategia k ha 8000+k o 8000+k-1; **si legge dal primo deal di ogni passata**, non si ipotizza. Il commento di ogni operazione porta l'ID della strategia (default `RemoveCommentSuffix=false`): in B10 la separazione per strategia e' possibile **comunque**.

**Totale: 3 (A: G0 due volte + G1-prop) + 10 (B) = 13 passate.**

### 6.4 Che cosa si estrae, e con quale attesa scritta PRIMA

| # | misura | **attesa** (e **come si falsifica**, scritto adesso) |
|---|---|---|
| E1 | tipo d'ordine | >= 90% degli ingressi nasce da **ordine pendente** (buy stop/sell stop). *Se prevalgono gli ordini a mercato la mia deduzione sul par. 5 e' sbagliata* |
| E2 | SL a 0 | **zero** operazioni senza SL all'apertura. *Un solo SL=0 e' bandiera rossa "nessuno stop"* |
| E3 | lotto con StartLots | **costante** in ogni passata. *Se cambia dopo una perdita, c'e' una logica di lotto fuori dal metodo = bandiera "martingala"* |
| E4 | posizioni concorrenti | nessuna posizione **opposta** aperta insieme alla prima della **stessa** strategia; nessuna **aggiunta nella stessa direzione contro il prezzo**. *Se esistono = hedge/averaging, scarto del setaccio (par. 4)* |
| E5 | "recover" | **ricerca esplicita** di: ingresso opposto entro N barre da uno SL, e/o lotto/distanza diversi dopo una serie di perdite. *Se c'e', la parola del venditore aveva senso e il prodotto esce dal perimetro* |
| E6 | additivita' | somma B1-B9 = B10 entro ±5% sul numero di operazioni. *Se no: accoppiamento fra strategie* |
| E7 | **scala delle distanze** | **IPOTESI A (la mia)**: SL/prezzo costante. **IPOTESI B (alternativa)**: SL/ATR(H1,14) costante. Si calcola il **coefficiente di variazione di SL/prezzo e di SL/ATR** su tutta la finestra (l'oro passa da ~2.900 a ~4.000-4.500 USD): **vince quello con CV piu' piccolo**; **se i due CV sono entro il 20% l'uno dall'altro, nessuna conclusione**. *Senza l'ipotesi alternativa scritta, "scalato col prezzo" sarebbe solo conferma* |
| E8 | orari e giorni | distribuzione per **ora server** (BCM: ora italiana -1 d'estate, = italiana d'inverno dal 2025, `OROLOGIO_BCM_2026-09-24.md`); giorni della settimana; **weekend** (posizioni aperte venerdi'/lunedi', Friday stop spento) |
| E9 | prop | **peggior giornata** in % del deposito 100k (muro 5%), **peggior DD** (muro 10%), **forma a scalini/ritorni dal picco** (il DD trailing la punisce), **n di giorni con >=3 ingressi** (rischio giornaliero concentrato) |
| E10 | rischio per trade | perdita a SL come % del saldo: **a quanto equivale "Max Risk Per Strat 1,0"** (passata extra opzionale, par. 6.6) |

**Cosa NON si fa:** nessuna griglia sui parametri. Gli unici assi sono **quale strategia gira** e **gli input di gestione** (Fake Breakout OFF/Low/Medium/High, trailing, Friday stop): cioe' **meccanismi**, non rifinitura di un motore morto (regola del 19/08).

### 6.5 Come si usano i risultati (e come NO)
- Ogni **forma** estratta diventa **un'ipotesi nostra, una riga**: "guadagna perche' [meccanismo]". Esempi plausibili che nascerebbero: *uscita rapida se la candela d'ingresso chiude contro (Fake Breakout) come filtro COSTITUTIVO dell'uscita*; *ordine pendente con scadenza breve*; *strategie annidate per rischio come portafoglio interno*. **Sono idee di struttura, mai numeri.**
- Ogni idea passa il nostro imbuto: **file prova con criteri congelati prima**, IS/OOS con >=150 operazioni, finestre di regime, **centro dell'altopiano mai il picco**, tick reali, regola dei due lati, e gestione nostra (parziale 1R + BE + runner, rischio %, spread come % dello stop, frontiera `stop >= 40 x spread`).
- **Attribuzione:** nessun codice del venditore entra in repo. Se una forma si ispira alla sua, il file prova lo dice con nome e versione.
- **Non** si usa il fatto che "il venditore e' popolare" come criterio: 33.175 demo e 143 acquisti/mese [DICHIARATO] misurano marketing, non edge.

### 6.6 Costo
- **Passate: 13** (3 + 10), + opzionali 4 (Fake Breakout OFF/Low/Medium/High su una strategia, dopo la lettura) e 1-2 per E10.
- **Minuti per passata: [NON MISURATO su questo EA].** Riferimento di casa: R134b, 6 passate di un EA a box su M5, 16 mesi di tick d'oro = atteso ~1 minuto l'una, **ma "il costo per passata su QUEL EA e' [NON MISURATO]"**. Questo EA e' multi-timeframe e il venditore ha aggiunto una modalita' "Backtest Speed" proprio perche' era lento (v4.5/v4.6): **ipotesi di lavoro 3-15 minuti a passata -> 40 minuti - 3,3 ore di macchina** per le 13. **La prima passata G0 misura il costo vero e decide il resto.**
- **Tempo di Claudio:** circa 15-20 minuti (scaricare/installare il demo **sul PC di backtest**, non VPS; lanciare). **Spesa: zero.** Se il demo e' gia' installato su un altro terminale, **[NON SO quale]**: va portato nel terminale banco del PC di backtest e **dichiarato il numero di conto del terminale** (regola dei terminali multipli) prima di qualunque riga.
- **Lavoro nostro:** un parser dell'export del tester (ordini, operazioni, SL/TP, commenti) ~1-2 ore; i numeri vengono da **dati nostri** (ATR H1 e prezzo su nostre barre).
- **Prima di qualunque riga di lancio**: `python3 backtest_pipeline/controlla_riga.py` + agente `controllo-preventivo` + `CHECKLIST_RIGA_DI_LANCIO.md`. **Niente parte senza PASS.** Qui non e' scritta nessuna riga di lancio apposta.

---

## 7. SCHEDA (griglia del par. 7 delle regole di caccia), PROVVISORIA

```
NOME            The Gold Reaper MT5   (v5.1, 02/10/2026)
FONTE / URL     https://www.mql5.com/en/market/product/111357   [letta 10/10/2026]
AUTORE / DATA   Profalgo Limited (Wim Schrynemakers, Malta), pubblicato 01/02/2024
POPOLARITA'     voto 4,49 su 116 recensioni; 329 commenti; 33.175 demo; 10 attivazioni
LICENZA         prodotto commerciale del Market (949 USD; noleggio 399/3 mesi); solo .ex5
RIGHE / INPUT   NON CONTABILI (niente sorgente); 69 input visibili, 0 della logica d'ingresso

TESI IN UNA RIGA
  "guadagna perche' [?]" -- NON SCRIVIBILE come perche'. Forma: breakout di S/R sull'oro con
  stop vicini e uscita rapida, 9 strategie annidate.   [INFERITO]

MECCANICA        ingresso: ordini pendenti ([INFERITO]); uscita: SL/TP + trailing + HL + BE +
                 Fake Breakout (chiusura a mercato); stop: SL sul server, distanze scalate col prezzo
GESTIONE RISCHIO lotto da DD-target storico del venditore (30%) o rischio per strategia;
                 OnlyUp true; max daily DD spento; SL vero (virtual OFF); weekend aperto
BANDIERE ROSSE   WebRequest/licenza (5 host, verificato manuale) · Randomization + Adjust* per
                 evitare "copy trading" (verificato manuale) · "recover" del venditore (22/09/2026,
                 non sciolto) · niente sorgente · DD 30% di default · OnlyUp attivo
COSTO DI PORTING non portabile: nessun sorgente. Riscrittura nostra DA ZERO a partire da ipotesi
                 di forma = ore, ma su una tesi che non conosciamo

PUNTEGGIO (0-2)
  [0] semplicita'               (69 input, logica nascosta)
  [0] il filtro E' il motore    (Fake Breakout sembra costitutivo, ma non si puo' dire: 0 per prudenza)
  [1] tesi scrivibile           (la forma si', il perche' no)
  [1] riempie un BUCO           (oro breakout: copre GBA e MaxMinNotte; resta aperto solo se ci sono
                                 short/laterale reali, [INCERTO])
  [0] testabile senza riscritture (il tester c'e'; il nostro involucro rischio %/Guardian no)
  TOTALE 2/10

VERDETTO   SCARTO come EA da schierare (< 5). IN CODA come OGGETTO DI MISURA (scatola nera, 13 passate)
PERCHE'    non si puo' rifinire ne' governare con le nostre protezioni; il valore e' solo come
           sorgente di ipotesi di forma, e solo se G1 mostra che sul nostro feed fa qualcosa

IN OTTICA PROP  il default (30% DD storico, OnlyUp, giornaliero spento) e' fuori dai muri 10%/5%;
           il set prop del venditore (9%/4%) ha un fallimento dichiarato da un utente a -3% giornaliero
           (non verificabile); il venditore stesso scrive "losses and drawdowns are normal, look LONGTERM";
           il segnale ha l'avviso MQL5 "share of days for 80% of growth is too low" (profitto in pochi giorni);
           Randomization/Adjust* sono funzioni dichiaratamente anti-rilevazione di copy trading;
           il trailing DD punisce la curva a gradini (non misurata).
```

**Prima di spendere (gradino 5 del cancello d'acquisto)**: nessuna decisione di spesa qui. Se mai: **noleggio prima dell'acquisto** (399 USD/3 mesi), **demo nel tester prima del noleggio**, e **cosa NON avremo mai: il sorgente** (non si rifinisce, non si corregge, non si governa col Guardian). Nei risultati di ricerca compaiono anche **vetrine Gumroad di terzi** che vendono "The Gold Reaper EA v1.9" [SNIPPET, non aperte]: per regola di casa **pirateria fuori discussione**.

---

## 8. COSA NON HO POTUTO VERIFICARE

1. **Il codice, la regola d'ingresso, i livelli S/R, gli orari, cosa sia "recover", cosa sia "backup" verso gli host del venditore.** Nessuna delle tre bandiere ambigue (martingala/averaging/recover) e' escludibile: **solo il tester le puo' provare o scartare.**
2. **Che il demo giri nel nostro tester a tick reali sul feed BCM**, che apra operazioni, che consenta la selezione manuale delle strategie, e quanto tempo costi una passata. Lo screenshot e' la finestra proprieta' di un EA su grafico, non il pannello del tester.
3. **Le statistiche del venditore e dei clienti**: tutte [DICHIARATO DA TERZI]. Il segnale e' la sola serie con statistiche calcolate da MQL5, ma **non so quali impostazioni usi, ne' se giri la v5.1**, ne' se il broker del segnale e' comparabile col nostro. L'account "da 400 a 91.000 USD in 20 mesi" e' dietro uno shorturl **non aperto**.
4. **329 commenti: ne ho letti quelli di 6 pagine su 17** (1, 2, 13, 14, 15, 16). Mancano le pagine 3-12 e 17: possono contenere altri fallimenti o altre frasi sulla meccanica. **La distribuzione per stelle delle 116 recensioni non e' leggibile.**
5. **Sito del venditore, recensioni affiliate, YouTube, Discord, Myfxbook, forum esterni, FTMO e prop**: **non raggiunti** (DNS dal proxy / fuori perimetro) o non cercati a fondo. Nessuna verifica indipendente di "prop passate". La verifica su forum terzi (Forex Factory, Forex Peace Army) **non e' fatta**: il gradino 1-bis del cancello (due diligence sul venditore) e' **fatto solo a meta'** (pagina del Market e commenti; manca la parte esterna).
6. **Il regolamento ufficiale del Market sul demo e sui limiti di analisi**: ho solo estratti di forum/blog, non il testo. Le mie regole di liceita' (par. 6.1) sono prudenza di casa, non un parere legale sul contratto di licenza.
7. **Il significato di `Risk=1234` nel set**, e **se il numero di magic per strategia sia 8000+k o 8000+k-1** (si legge nel tester).
8. **I riassunti di `WebFetch`** (storico versioni, recensioni) sono prodotti da un modello piccolo: l'ho incrociato dove ho potuto (manuale, set, screenshot), non su tutto.
9. **Quale terminale/PC ospita il demo di Claudio.** Non e' scritto negli screenshot (barra applicazioni di Windows, nessuna cartella dati).
10. **L'orologio del feed BCM nella finestra** (offset NFP 1 o 2/3): preso dal referto `OROLOGIO_BCM_2026-09-24.md` come riportato in CLAUDE.md, **non ricontrollato qui**.
11. **Nessuna passata fatta, nessun numero nostro: non esiste nessun PF/DD/n di casa su questo EA.** Niente certificato di morte e niente "morto": **NON ANCORA MISURATO**.

---

## 9. LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> *"Il demo v5.1 di The Gold Reaper, lanciato nel nostro Strategy Tester a tick reali su XAUUSD H1 dal 2025.03.01 con i default venduti (G0, due volte) e col set prop 9%/4% (G1-prop), apre operazioni, riproduce le stesse cifre a ogni lancio e ha PF >= 1,0 con un DD e una peggior giornata che si leggono rispetto ai nostri muri 10%/5%? E, nelle passate isolate, ogni strategia usa ordini pendenti con SL a distanza proporzionale al prezzo e un lotto costante, oppure compare un ingresso opposto o un'aggiunta contro il prezzo dopo uno SL (il 'recover')?"*

Se **G0 non apre operazioni o non e' deterministico**: caso chiuso in tre passate, **spesa zero**. Se **PF < 1,0** sul nostro feed: "non riprodotto, NON ANCORA MISURATO in altri regimi". Se compare **recover/hedge/averaging**: **fuori perimetro per setaccio**, e il lavoro estratto resta solo come lista di cio' che NON copiare.

---

## 10. FONTI (tutte aperte il 10/10/2026)

- Scheda prodotto: https://www.mql5.com/en/market/product/111357 · commenti: https://www.mql5.com/en/market/product/111357/comments (e /comments/page1, /page2, /page13, /page14, /page15, /page16) · novita': https://www.mql5.com/en/market/product/111357/updates
- Segnale: https://www.mql5.com/en/signals/2265877
- Manuale v5.1 (zip, 05/10/2026): https://c.mql5.com/31/2447/Gold_Reaper_V5_1.zip · set prop: https://c.mql5.com/31/1047/propfirm__1.set
- Omonimo (indicatore, NON questo prodotto): https://www.mql5.com/en/market/product/178260
- Demo del Market solo nel tester (estratti di forum/blog, non il regolamento): https://www.mql5.com/en/forum/513229 · https://www.mql5.com/en/blogs/post/773334
- Screenshot di Claudio: `/tmp/claude-0/-home-user-GITHUB/c2d73886-9ef2-5105-8937-d770bc36d6df/images/145.png` e `146.png` (10/10/2026 19:54)
- Solo estratti di ricerca, pagine NON aperte (DNS non raggiunto): newyorkcityservers.com/blog/the-gold-reaper-review · globegain.com/community/the-gold-reaper-mt5-review · fxroboteasy.com/experts/the-gold-reaper-mt5 · forexeasolutions.com/expert-advisors/gold-reaper · vetrine Gumroad di terzi
- Interni al repo: `backtest_pipeline/caccia_strategie/CANCELLO_ACQUISTI_EA.md` (gradini 1-5) · `report/MARKET_GOLD_SCALPER_PRO_2026-10-10.md` (stesso giorno, stesso metodo, stessa frontiera del costo) · `backtest_pipeline/prove/R134b_scatolaoro_XAUUSD.txt` (pavimento tick d'oro 2025.03.01, riferimento di tempo-macchina) · `report/OROLOGIO_BCM_2026-09-24.md` (via CLAUDE.md, non riletto)
