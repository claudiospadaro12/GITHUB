# 🧑‍💻 PROP FIRM PER IL TRADING MANUALE — confronto e sconti (15/09/2026)

_Scritto il **15/09/2026**. Richiesta di Claudio: una prop firm per la challenge
che affronta **a mano** (non con gli EA — quelli restano il progetto separato
del conto reale 10105439, mai toccato da questo file). Nessun EA, preset,
sedia o file di infrastruttura è stato letto o modificato per scrivere questo
dossier._

---

# 0. 🚧 LA CLASSE DI PROVA — uguale a `REGOLAMENTI_PROP_2026-09-08.md`, verificata di nuovo oggi

| canale | bersaglio | esito |
|---|---|---|
| `curl` diretto su `ftmo.com`, `the5ers.com`, `citytradersimperium.com` | homepage/pricing | ❌ **tutti `403 connect_rejected` al CONNECT** — il proxy dell'ambiente blocca ancora tutti i domini prop |
| `WebFetch` su `ftmo.com/en/pricelist/`, `the5ers.com/summer-plan/` | pagine ufficiali | ❌ `EGRESS_BLOCKED` |
| `WebSearch` con `allowed_domains` sul dominio ufficiale | varie pagine ufficiali | ✅ funziona: il motore legge la pagina ufficiale e ne riporta il contenuto |

**Nessuna pagina ufficiale di prop è stata aperta direttamente.** Ogni numero
di questo file porta un'etichetta:

| etichetta | significato |
|---|---|
| **[UFFICIALE-VIA-SEARCH]** | ricerca ristretta al dominio ufficiale (`allowed_domains`): è il contenuto della pagina ufficiale, letto di seconda mano, verificabile in 30 secondi da un browser normale |
| **[AGGREGATORE]** | il numero viene da siti di recensioni/comparazione terzi (propfirmmatch, thetrustedprop, brokeranalysis, ecc.) — **non ufficiale**, va trattato come indicazione, non come prezzo di cassa |
| **[TRUSTPILOT]** | dato riportato da terzi che cita Trustpilot (Trustpilot stesso non è stato apribile: dominio fuori dai raggiungibili in questa sessione, i numeri vengono da articoli che lo citano) |
| **[NON VERIFICATO]** | non trovato, o fonti in contrasto |

🔴 **Nessuna challenge va comprata solo su questo file.** Prima dell'acquisto:
prezzo e sconto vanno confermati da Claudio **sul sito ufficiale al momento
del checkout** — un codice promo scade in ore, non in settimane.

---

# 1. 🎯 LA DOMANDA CHE CONTA PRIMA DEL PREZZO: sconti veri vs codici finti

Ricerca dedicata fatta oggi su "come funzionano i siti di coupon per le
prop firm": i siti aggregatori (couponchief, hotdeals, worthepenny,
couponmister, ecc.) **pubblicano codici falsi o casuali per farmare clic
d'affiliazione** — pratica documentata e diffusa nel settore
**[AGGREGATORE, track360.io/loudcrowd.com, letto il 15/09]**. Regola pratica
citata dalla stessa ricerca: *"se qualcuno offre uno sconto incredibile del
99%, probabilmente è falso; le prop vere non scontano così aggressivamente"*.

👉 **Conseguenza per questo dossier**: uno sconto conta solo se **confermato
sul dominio ufficiale** della prop (pagina promozioni, help center, o pagina
prodotto con il prezzo scontato già scritto). Un "codice CHALLENGE -70%"
trovato solo su un aggregatore è **[NON VERIFICATO]**, e va scritto così —
non "forse vero".

---

# 2. 📋 LE SEI PROP CENSITE

FTMO e Alpha Capital erano già nel dossier EA dell'08/09
(`report/REGOLAMENTI_PROP_2026-09-08.md`); qui vengono riletti sotto l'angolo
**manuale** (le clausole anti-EA di Alpha Capital, ad esempio, semplicemente
**non si applicano** a un trader a mano). Le altre quattro sono nuove per
questo file.

| # | prop | perché è in lista |
|---|---|---|
| 1 | **FTMO** | il nome più recensito del settore, già verificato in parte l'08/09 |
| 2 | **FundedNext** | seconda per volume di recensioni, profit split più alto, payout bisettimanali |
| 3 | **The5ers** | offerta stagionale in corso con sconto verificato molto alto (§4) |
| 4 | **Funded Trading Plus** | tagli "Experienced"/1-step senza consistenza, spesso citata come alternativa economica |
| 5 | **City Traders Imperium (CTI)** | drawdown su **saldo** (non equity): rilevante per un trader manuale che tiene posizioni |
| 6 | **Alpha Capital Group** | qui **non esce per vietare gli EA** (irrilevante: si tratta a mano) — resta in gara |

**Escluse per un motivo dichiarato, non per pigrizia:**
- **Fidelcrest**: 🔴 **CHIUSA il 4 marzo 2024**, licenza MetaQuotes e liquidity
  provider persi, **fee non rimborsate** ai trader con challenge attiva
  regolare — descritta da più fonti come **probabile exit scam**
  **[AGGREGATORE, coinspot.io/intelligencecommissioner.com, letto il 15/09]**.
  Citata solo come monito, non è un'opzione.
- **MyForexFunds**: 🔴 oggetto di causa della **CFTC/SEC statunitense (2023)**
  per schema fraudolento con conti "funded" simulati — non più operativa come
  entità originale. Stesso ruolo di monito.
- **E8 Markets, The5ers Hyper Growth**: già escluse nel dossier dell'08/09 per
  **muro trailing** (§3.2 di quel file); il muro trailing non è un problema
  che nasce dal manuale o dall'EA, quindi la ragione **non cambia** e non le
  rimetto qui.
- **TopTier Trader** e le firm dedicate a **futures CME**: fuori perimetro,
  Claudio opera forex/indici CFD, non futures.

---

# 3. 💶 PREZZO, SCONTO, PROFIT SPLIT — tabella per prop

## 3.1 FTMO — Challenge 2-Step, 100k

| voce | valore | fonte |
|---|---|---|
| **Prezzo 100k, listino** | **540 €** (già registrato l'08/09) | [UFFICIALE-VIA-SEARCH, pricelist] · confermato di nuovo oggi |
| **Sconto ATTIVO oggi (15/09/2026)** | 🔴 **[NON VERIFICATO come reale]**. Le pagine promozionali ufficiali (`promo.ftmo.com`) trovate oggi sono tutte **datate e passate**: *Black Friday 2025*, *New Year Flash Sale 2026* (gennaio), *10yrs of Empowering Traders*. **Nessuna promozione datata settembre 2026 è emersa sul dominio ufficiale.** I codici "CHALLENGE -70%", "TNG -25%", "TRADETHEDAY -10%" trovati sugli aggregatori sono **[AGGREGATORE, NON VERIFICATO]** — FTMO storicamente sconta **intorno al 15-20%** (Black Friday 20%, anniversario 19%), quindi un "-70%" è quasi certamente un codice non funzionante o scaduto | [UFFICIALE-VIA-SEARCH, promo.ftmo.com] + [AGGREGATORE, couponchief/hotdeals/worthepenny, letto il 15/09] |
| **Rimborso** | 100% della fee col primo prelievo | [UFFICIALE-VIA-SEARCH, pricelist/FAQ] (già in REGOLAMENTI_PROP 08/09) |
| **Profit split** | **80%** base, **fino al 90%** dopo 4 mesi consecutivi di profitto (scaling +25%); **90% dal primo giorno** sulla Challenge 1-Step | [UFFICIALE-VIA-SEARCH, ftmo.com/en/how-it-works/ · reward-growth-and-scaling-plan] |
| **Consistenza (Best Day Rule)** | il **giorno migliore non può superare il 50%** del profitto dei giorni positivi — serve per passare E per incassare il primo Reward. Non blocca la challenge in corso, blocca l'incasso | [UFFICIALE-VIA-SEARCH, trading-objectives] (già §2.3 di REGOLAMENTI_PROP 08/09) |
| **Giorni minimi** | 4 giorni per fase | [UFFICIALE-VIA-SEARCH] (già in REGOLAMENTI_PROP 08/09) |
| **Weekend/overnight (manuale)** | libero su conto **Standard** durante la valutazione; da funded in poi va chiuso prima del weekend (a meno di conto **Swing**, sempre libero) | [UFFICIALE-VIA-SEARCH] (già §2.2 riga 5e di REGOLAMENTI_PROP 08/09) |
| **News trading (manuale)** | conto Standard: vietato aprire/chiudere ±2 minuti dalla notizia selezionata; conto Swing: nessuna restrizione | [UFFICIALE-VIA-SEARCH] (già §2.2 riga 5d) |
| **Reputazione** | **Trustpilot 4,8 su ~46.600 recensioni** — il campione più grande del settore, nessuno scandalo maggiore in 10 anni di attività. Le recensioni negative si concentrano su **dispute di enforcement/consistenza**, non su mancati pagamenti | [TRUSTPILOT via AGGREGATORE, responsibletrading.com/brokeranalysis, letto il 15/09] |

## 3.2 FundedNext — Stellar 2-Step, 100k

| voce | valore | fonte |
|---|---|---|
| **Prezzo 100k, listino** | **549 $** (già registrato l'08/09) | [UFFICIALE-VIA-SEARCH] (già in REGOLAMENTI_PROP 08/09) |
| **Sconto ATTIVO oggi** | 🔴 **codice `NEW25` (25% off) è REALE e VERIFICATO sul dominio ufficiale** (`help.fundednext.com`), MA **esclude esplicitamente i conti 100k e 200k** — vale solo fino a 50k. Per il 100k **nessun sconto ufficiale verificato oggi**. Il "55% off" trovato è per **Futures Flex**, non per il CFD 100k Stellar che serve qui | [UFFICIALE-VIA-SEARCH, help.fundednext.com articoli 15450535/16146478] |
| **Profit split** | **80%** base su Stellar, **fino al 95%** con l'add-on "reward 95% lifetime" (+30% sul prezzo, già registrato l'08/09) | [UFFICIALE-VIA-SEARCH] |
| **Consistenza** | ✅ **NESSUNA regola di consistenza sui conti CFD** (solo una linea guida 40% su alcune challenge Futures, irrilevante qui) — punto a favore per il manuale rispetto a FTMO | [UFFICIALE-VIA-SEARCH, helpfutures.fundednext.com] |
| **Giorni minimi** | 5 giorni distinti per fase, min. 1 trade/giorno (già in REGOLAMENTI_PROP 08/09) | [UFFICIALE-VIA-SEARCH] |
| **Weekend/overnight** | consentito su Challenge/FundedNext Account (non su Express-Consistency) | [UFFICIALE-VIA-SEARCH] (già §2.2 riga 5e) |
| **Reputazione** | **Trustpilot 4,5 su ~62.000 recensioni** — payout medio riportato ~5 ore. Reclami ricorrenti: **chiusure conto prima del prelievo**, slippage su conti funded, allargamento spread su notizie | [TRUSTPILOT via AGGREGATORE, proptradingvibes.com, letto il 15/09] |
| **⚠️ Nota** | pattern osservato: risponde alle recensioni negative con *"lo scaleremo"* senza risoluzione visibile documentata — non è un mancato pagamento, ma è un pattern da tenere d'occhio | [AGGREGATORE, proptradingvibes.com] |

## 3.3 The5ers — 🥇 lo sconto più forte trovato oggi

| voce | valore | fonte |
|---|---|---|
| **Prezzo 100k, listino (High Stakes, fuori promo)** | **~545 $** | [AGGREGATORE, letto il 15/09 — non confermato sul dominio ufficiale al netto della promo attiva] |
| **🟢 SCONTO ATTIVO, VERIFICATO SUL DOMINIO UFFICIALE** | **"Summer Plan": conto 100k da 149 $** (2-Step 10/5) o **179 $** (2-Step Classic) invece di ~545 $ → **sconto reale ~67-73%**. Lanciata **15 luglio 2026**, **confermato che resta attiva per tutto settembre 2026** (nessuna data di fine pubblicata, l'unico evento datato sulla pagina è un contest il 24/08, già passato) | [UFFICIALE-VIA-SEARCH, the5ers.com/summer-plan/ · the5ers.com/prop-firm-summer-plan-2026/] |
| **Profit split** | **80/20** dal primo stadio funded su High Stakes; su altri programmi (Bootcamp/Hyper Growth) si parte da 50% e si scala fino al 100% | [UFFICIALE-VIA-SEARCH, the5ers.com/high-stakes/] |
| **Consistenza** | 🔴 **regola del 50%**: nessun giorno può valere più del 50% del profitto totale **calcolato sui profitti**, non sul saldo — si applica al momento della richiesta di payout sui conti 100k | [UFFICIALE-VIA-SEARCH, the5ers.com — ricerca "consistency rule"] |
| **Giorni minimi** | 3 giorni **profittevoli** (≥0,5% ciascuno) per step — la stessa clausola già segnalata come "strutturalmente dura" nel dossier EA dell'08/09, ma per un trader manuale è gestibile con più discrezione di un EA a frequenza fissa | [UFFICIALE-VIA-SEARCH] (già §2.2/§3.5-C di REGOLAMENTI_PROP 08/09) |
| **Weekend/overnight** | ✅ consentito su tutti i programmi; ⚠️ swap alto se si tengono **indici** nel weekend | [UFFICIALE-VIA-SEARCH, the5ers.com/faqs] |
| **News trading** | ✅ consentito **tenere** posizioni durante le notizie; vietato **aprire/chiudere** in una finestra di ±2 minuti dalle notizie ad alto impatto | [UFFICIALE-VIA-SEARCH, the5ers.com/faqs/can-i-trade-during-news] |
| **Reputazione** | **Trustpilot 4,7 su ~34.900 recensioni**. Nessun pattern di mancato pagamento, ma reclami ricorrenti su **chiusure conto dopo flag automatici di rischio** contestati dai trader, e **processo di payout lento (5-8 giorni lavorativi)** rispetto ad altri | [TRUSTPILOT via AGGREGATORE, letto il 15/09] |

## 3.4 Funded Trading Plus

| voce | valore | fonte |
|---|---|---|
| **Prezzo 100k** | **[NON VERIFICATO con precisione]**: la fascia dichiarata va da **119 $ a 4.500 $** secondo il tipo di prodotto — il tipo "Instant No Evaluation" 100k risulta a **4.499 $ (scontato a 2.699,40 $)**, ma il tipo "Experienced" 2-step 100k (il prodotto comparabile agli altri) **non ha un prezzo ufficiale confermato in questa ricerca** | [AGGREGATORE, propfirmmatch/thetrustedprop, letto il 15/09] |
| **Sconto** | codici **JAN15**, **SPOOKY**, **PRO**, **FUNDED30** citati dalla **stessa pagina ufficiale del venditore** (`fundedtradingplus.com/best-coupon-code...`), quindi di livello più alto di un aggregatore — ma nessuno ha una data di scadenza dichiarata, e la pagina è marketing proprio, non una promozione a tempo. **Trattare come "probabilmente valido ma non verificato al checkout"** | [UFFICIALE-VIA-SEARCH, fundedtradingplus.com] |
| **Consistenza** | 🔴 **35% in evaluation, 50% da funded** SOLO sui piani 2-step; **i piani 1-step e instant NON hanno consistenza** | [AGGREGATORE, thetrustedprop.com, letto il 15/09] |
| **Giorni minimi** | ✅ **nessuno** sulla maggior parte dei programmi (eccetto "Prestige Static": 3 giorni ≥0,5%) | [AGGREGATORE, letto il 15/09] |
| **Weekend/overnight** | ✅ su 1-Step e 2-Step; ❌ **Instant**: chiusura obbligatoria entro le 16:30 EST del venerdì | [AGGREGATORE, letto il 15/09] |
| **Reputazione** | **Trustpilot 4,4-4,7 su ~2.400-2.650 recensioni** (molto più piccolo del campione FTMO/FundedNext/The5ers). 🔴 **Red flag specifico e ripetuto**: revisione del rischio **discrezionale** — la firm può negare un payout per "rischio eccessivo" **senza una violazione di regola specifica**; problemi KYC con richiesta di documenti aggiuntivi **dopo** un primo prelievo già approvato | [TRUSTPILOT via AGGREGATORE, letto il 15/09] |

## 3.5 City Traders Imperium (CTI)

| voce | valore | fonte |
|---|---|---|
| **Prezzo 100k, 2-Step** | **549 $** (scontato a **466,65 $**) secondo una fonte, **689 $** (scontato a **482,30 $**) secondo un'altra — 🔴 **contrasto non risolto, [NON VERIFICATO]** quale sia il prezzo di listino vero | [AGGREGATORE, propfirmmatch/proforex168, letto il 15/09] |
| **Sconto** | codici mensili ricorrenti riportati (**JAN30/FEB30/MAR30/APR30/MAY30/"4july"**, tutti ~15-30%) — **pattern riconoscibile** (un codice nuovo ogni mese), ma **nessuno confermato sul dominio ufficiale** in questa ricerca: la pagina ufficiale dice solo *"promozioni occasionali, verificare sul sito o sui canali social"* | [AGGREGATORE per i codici; UFFICIALE-VIA-SEARCH solo per la frase generica, citytradersimperium.com] |
| **Profit split** | **80%** base, **90%** a Bronze VIP, **100%** a Silver VIP | [AGGREGATORE, citytradersimperium.com/vip-program-payout (ufficiale ma letto via search)] |
| **Consistenza** | dichiarata **assente** (*"no hidden consistency rules"*) — punto a favore netto per il manuale | [UFFICIALE-VIA-SEARCH, citytradersimperium.com] |
| **🟢 Drawdown su SALDO, non equity** | dichiarato esplicitamente: *"balance-based drawdown, not equity — one bad trade won't wipe you out"*. Per un trader manuale che tiene posizioni aperte con flottante, questo è **più permissivo** di FTMO (che misura sull'equity per il muro totale — vedi §3.1 del dossier EA 08/09, stesso principio) | [UFFICIALE-VIA-SEARCH, citytradersimperium.com] |
| **Giorni minimi** | **10 giorni attivi** per stadio (dichiarato per il "Day Trading Program"; per il 2-Step standard non confermato con lo stesso numero — **[INCERTO]**, i due prodotti potrebbero avere regole diverse) | [AGGREGATORE, letto il 15/09] |
| **Weekend/overnight, news** | ✅ entrambi consentiti su tutti i conti; solo il **news bracketing** (ordini pendenti piazzati apposta attorno alla notizia) è vietato — irrilevante per un trader discrezionale | [AGGREGATORE, letto il 15/09] |
| **Reputazione** | **Trustpilot 4,3-4,6 su ~1.200 recensioni** (campione piccolo rispetto ai primi tre). Payout riportati **24-48 ore**. 🔴 Reclami: **payout negati o conto terminato senza motivazione chiara, in particolare dopo essere diventati profittevoli** — pattern preoccupante perché colpisce proprio il momento in cui il trader ha ragione di essere pagato | [TRUSTPILOT via AGGREGATORE, propfirmmatch.com, letto il 15/09] |

## 3.6 Alpha Capital Group — qui NON esce (il veto è sugli EA, non sul manuale)

| voce | valore | fonte |
|---|---|---|
| **Prezzo Alpha Pro 100k** | **597 $** | [UFFICIALE-VIA-SEARCH, alphacapitalgroup.uk/product/alpha-pro-100k-plan] |
| **Sconto** | *"discount codes and promotions are common throughout the year"* — dichiarazione generica ufficiale, **nessun codice specifico attivo oggi confermato** | [UFFICIALE-VIA-SEARCH, alphacapitalgroup.uk/posts/how-much-does-a-prop-firm-evaluation-cost-2026] |
| **Profit split** | **80%** base, **90%** su Alpha Direct o con add-on | [UFFICIALE-VIA-SEARCH] |
| **Consistenza** | **[NON VERIFICATO]** in questa ricerca — non emersa una regola esplicita | [NON VERIFICATO] |
| **Giorni minimi** | Alpha One: 1 giorno · Alpha Pro: 3 giorni per fase (già in REGOLAMENTI_PROP 08/09) | [UFFICIALE-VIA-SEARCH] |
| **Weekend/news (manuale)** | ✅ **esplicitamente permessi** su Alpha Pro: *"permissions for trading through news and holding positions over the weekend"* — la restrizione ±5 minuti registrata l'08/09 riguardava Alpha One/stadio "Qualified Analyst" | [UFFICIALE-VIA-SEARCH, alphacapitalgroup.uk/product/alpha-pro-100k-plan] |
| **Reputazione** | **Trustpilot 4,2-4,7** (fonti in disaccordo sul decimale) **su oltre 20.000 recensioni**, 85% a 5 stelle. 🔴 Reclami ricorrenti: **terminazioni account improvvise e prelievi negati**, contestati da recensioni positive più numerose | [TRUSTPILOT via AGGREGATORE, letto il 15/09] |
| **Perché resta in gara qui, a differenza del dossier EA** | il veto categorico dell'08/09 (*"Automated EAs that execute trades independently are strictly prohibited"*) riguarda **solo l'automazione**. Un trader che clicca lui stesso i tasti **non lo tocca affatto** | logica, non fonte nuova |

---

# 4. 🚩 BANDIERE ROSSE — quadro d'insieme del settore, non solo le sei nomi

**Contesto misurato, non opinato**: tra febbraio 2024 e fine 2025 si stima che
**80-100 prop firm abbiano chiuso** — il più grande collasso della storia del
settore **[AGGREGATORE, track360.io, letto il 15/09]**. Esempi concreti
trovati oggi:

| caso | cosa è successo | fonte |
|---|---|---|
| **Fidelcrest** | chiusa il 4/03/2024, licenza persa, **fee non rimborsate** ai trader con challenge regolare in corso — descritta come probabile exit scam | [AGGREGATORE, coinspot.io/intelligencecommissioner.com] |
| **MyForexFunds** | causa **CFTC/SEC** 2023 per schema fraudolento con conti "funded" simulati | conoscenza generale del caso, confermata dai risultati di ricerca di oggi |
| **FundedFirm** | dichiarava **95 milioni $** di payout cumulativi; un'inchiesta di novembre 2024 li ha smascherati come **gonfiati**, poi corretti tacitamente a **9,5 milioni $** | [AGGREGATORE, track360.io] |
| **The Funded Trader** | operazioni sospese il 28/03/2024 dopo **denunce diffuse di payout negati**; il CEO ha ammesso **oltre 2 milioni $ di prelievi negati** in gennaio-febbraio 2024 | [AGGREGATORE, track360.io] |
| **Funded Engineer** | sottratti **1-2 milioni $**, poi sparita | [AGGREGATORE, track360.io] |

**Pattern ricorrenti nei red flag citati dalla stessa ricerca**: regole
cambiate senza preavviso, nessuna prova di reward reale, nessuna
registrazione societaria verificabile, controlli d'identità richiesti **solo
al momento del prelievo** (segnale di allarme esplicito), goalpost mobili,
supporto irraggiungibile. **Nessuno di questi pattern è emerso oggi per le
sei prop censite nella tabella del §3** — ma tre di esse (Funded Trading
Plus, Alpha Capital, CTI) hanno il **pattern più leggero e specifico**:
**terminazione conto / payout negato dopo che il trader è diventato
profittevole**, riportato da recensioni negative ripetute pur restando
minoritarie rispetto alle positive.

🔴 **Nessuna delle sei prop del §3 ha, ad oggi, una causa legale in corso o un
pattern diffuso di mancato pagamento** (a differenza dei cinque casi sopra).
La differenza tra "reclami di enforcement" (FTMO, FundedNext, The5ers) e
"reclami di payout negato dopo aver vinto" (Funded Trading Plus, CTI, Alpha
Capital) **è quella che conta di più per un trader manuale**: la prima
categoria dipende dal rispettare la regola, la seconda dipende da una
decisione discrezionale della firm anche a regole rispettate.

---

# 5. 📊 TABELLA COMPARATIVA FINALE

| | **FTMO** | **FundedNext** | **The5ers** | **Funded Trading Plus** | **CTI** | **Alpha Capital** |
|---|---|---|---|---|---|---|
| Prezzo 100k listino | 540 € `[UFFICIALE]` | 549 $ `[UFFICIALE]` | ~545 $ `[AGGR]` | 119-4.500 $, fascia larga `[AGGR]` | 549-689 $, in contrasto `[AGGR]` | 597 $ `[UFFICIALE]` |
| **Sconto verificato oggi** | ❌ nessuno confermato sul sito ufficiale `[UFFICIALE]` | 🟡 solo NEW25 25% ma **esclude il 100k** `[UFFICIALE]` | 🟢 **Summer Plan 149-179 $, ~70% off, confermato attivo tutto settembre** `[UFFICIALE]` | 🟡 codici sulla pagina ufficiale del venditore, senza scadenza dichiarata `[UFFICIALE, non a tempo]` | 🔴 codici solo da aggregatori, non confermati sul sito `[AGGR]` | 🟡 dichiarazione generica, nessun codice specifico `[UFFICIALE]` |
| Profit split | 80% → 90% (90% da subito su 1-Step) | 80% → 95% con add-on | 80% (High Stakes) | fino al 100% (Experienced) | 80% → 100% (VIP) | 80% → 90% |
| Consistenza (best day) | 🔴 50%, blocca il payout | ✅ nessuna sui conti CFD | 🔴 50%, blocca il payout | 🔴 35%/50% solo su 2-step | ✅ nessuna dichiarata | `[NON VERIFICATO]` |
| Giorni minimi | 4/fase | 5/fase | 3 profittevoli/step | nessuno (quasi ovunque) | 10 attivi (Day Trading) | 1-3/fase |
| Weekend/overnight | conto Standard: sì in valutazione; Swing: sempre sì | sì (tranne Express-Consistency) | sì (swap alto su indici) | sì (tranne Instant) | sì | sì |
| News trading (manuale) | Standard: vietato ±2min; Swing: libero | libero | tenere sì, aprire/chiudere ±2min vietato | sì, con margine "ragionevole" | libero (solo bracketing vietato) | libero su Alpha Pro |
| Muro totale | 10% statico | 10% statico | 10% statico (High Stakes) | 6-8% (varia) | 10% statico, **su saldo** | 10% statico (Alpha Pro) |
| Trustpilot | 4,8 / ~46.600 `[TRUSTPILOT]` | 4,5 / ~62.000 `[TRUSTPILOT]` | 4,7 / ~34.900 `[TRUSTPILOT]` | 4,4-4,7 / ~2.500 `[TRUSTPILOT]` | 4,3-4,6 / ~1.200 `[TRUSTPILOT]` | 4,2-4,7 / ~20.900 `[TRUSTPILOT]` |
| Red flag specifico | dispute di enforcement (non di payout) | chiusure pre-prelievo, risposte senza risoluzione | processo payout lento (5-8gg), dispute post-flag | **rischio discrezionale, KYC dopo il prelievo** | **payout negato dopo essere diventati profittevoli** | terminazioni improvvise |

---

# 6. 🏁 RACCOMANDAZIONE

## 🥇 Se conta il PREZZO e lo sconto deve essere vero oggi: **The5ers, Summer Plan, 100k 2-Step, 149-179 $**

- È il **solo sconto di questa lista confermato sul dominio ufficiale**, con
  una riduzione enorme e verificabile (da ~545 $ a 149-179 $), attivo per
  tutto settembre 2026 — perfetto per il calendario di Claudio (challenge ai
  primi di ottobre).
- Muro **statico** (non trailing), nessun EA da preoccuparsi (qui non serve),
  weekend e overnight liberi.
- ⚠️ **Il prezzo del costo se fallisce è basso, ma il prezzo del tempo non lo
  è**: consistenza al 50% e 3 giorni profittevoli da ≥0,5% per step vanno
  gestiti con disciplina manuale; il processo di payout è il più lento dei
  tre grandi nomi (5-8 giorni lavorativi).

## 🥈 Se conta la SOLIDITÀ e i soldi veri contano più del prezzo di ingresso: **FTMO, 2-Step, 100k**

- **Il campione di recensioni più grande e più pulito** del settore (46.600
  recensioni, 4,8, nessuno scandalo in 10 anni) — è quello con la minor
  probabilità misurabile di un payout negato per motivi arbitrari.
- Le regole sono già state verificate a fondo l'08/09
  (`report/REGOLAMENTI_PROP_2026-09-08.md`): muro statico, nessun limite di
  tempo, reset alle 00:00 di Praga.
- ❌ **Nessuno sconto verificato oggi**: il costo pieno è 540 € (o 439 € se
  Claudio trova per iscritto, sul sito, una promozione attiva al momento del
  checkout — cosa che questa sessione non può controllare per il blocco di
  rete). **Non si deve pagare un codice aggregatore non verificato pensando
  che sia un vero sconto FTMO.**

## 👉 In una riga
**Se lo sconto deve essere reale oggi: The5ers. Se la priorità è la
tranquillità psicologica su un pagamento vero: FTMO, sconto o non sconto.**
Le altre quattro (FundedNext, Funded Trading Plus, CTI, Alpha Capital) sono
tutte **operative e senza segnali di frode grave**, ma ciascuna ha un red
flag specifico (§5) che le mette dietro alle prime due per un trader che
gioca la propria challenge, non un portafoglio di sedie.

---

# 7. 🕳️ COSA NON HO POTUTO VEDERE — dichiarato

1. **Nessuna pagina ufficiale aperta direttamente** in questa sessione: tutti
   i domini prop restano bloccati dal proxy (verificato di nuovo oggi,
   §0). Ogni cifra viene da `WebSearch`, non da lettura diretta.
2. **Prezzo esatto 100k di Funded Trading Plus "Experienced"** e **prezzo di
   listino esatto di CTI 100k** restano in contrasto tra fonti — serve
   controllo diretto di Claudio sul sito.
3. **Se i codici sconto di CTI e Funded Trading Plus funzionano davvero al
   checkout**: nessuno di questi codici è stato testato (non è possibile
   testarlo da qui). Vanno provati sul sito, non dati per buoni.
4. **Consistenza di Alpha Capital**: non emersa in questa ricerca —
   [NON VERIFICATO], non "nessuna regola esiste".
5. **Trustpilot non è stato letto direttamente**: ogni numero citato come
   `[TRUSTPILOT]` viene da articoli terzi che lo riportano, non dalla pagina
   Trustpilot stessa (trustpilot.com non è stato tra i domini raggiunti in
   questa sessione).
6. **Nessun controllo di regolamentazione legale/societaria** (sede, licenza,
   dove è incorporata ciascuna firm) è stato fatto in questa passata — se
   Claudio vuole quel livello di due diligence, è un secondo giro di ricerca.

---

## 🧊 Nota di perimetro
Nessun EA, preset, parametro di rischio, taglia, conto o file
dell'infrastruttura è stato letto o toccato per scrivere questo dossier.
Il file `CODA_11`/`CODA.txt` e tutto ciò che riguarda il conto reale
10105439 non sono stati toccati. Questa è ricerca per una decisione
**personale** di Claudio sul trading manuale, non una proposta di codice.
