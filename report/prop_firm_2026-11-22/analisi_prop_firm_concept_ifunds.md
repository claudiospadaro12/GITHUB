# Analisi prop firm: Concept Trading e iFunds

Data: 22 novembre 2026
Tipo: analisi in sola lettura. Nessuna registrazione, acquisto, invio di dati personali, click su "start challenge", messaggio o ticket.

Nota generale: questa analisi non è una raccomandazione su quale firm scegliere. Riporta quello che ho letto sui siti e segnala le contraddizioni e i punti non trovati.

---

## 0. Come è stata fatta l'analisi

- Pagine lette con il browser (testo originale della pagina): vedi sezione 9.
- Pagine lette con WebFetch (riassunto generato da un modello, NON testo originale): indicate nella sezione 9. Le frasi tra virgolette in questi casi sono parafrasi o traduzioni, non citazioni esatte.
- Snippet di ricerca (recensioni Trustpilot e siti terzi): non verificati, usati solo come indicazione.
- "NON TROVATO" significa che l'informazione non è comparsa nelle pagine lette. Non significa necessariamente che non esista: potrebbe essere in pagine che non ho letto.

---

## 1. Concept Trading

Siti:
- Sito di trading proprietario: https://prop.theconcepttrader.com/
- Dominio alternativo che compare in ricerche: theconcepttrading.com (da verificare quale sia ufficiale)

### 1.1 Programmi

Dalla pagina "Trading proprietario" (https://prop.theconcepttrader.com/prop-trading/):

| Programma | Partenza da | Drawdown statico | Obiettivo | Leva | Max nozionale | Costo |
|---|---|---|---|---|---|---|
| Premier | $3.000 (a $297) | 5% | 7% | 1:200 | $10M | Tariffa x 9 |
| Empire | $10.000 (a $997) | 10% | 10% | 1:200 | $15M | Tariffa x 10 |
| Traditional | $97 | 4% | 6% | 1:200 | $2M | Tariffa x 9 |
| Xtreme | $300 | 3% | 6% | 1:30 | $50M | Tariffa x 33 |
| Foundation | $65 | 6% | 10% intern, 5% verification, 10% funded | 1:200 | n.d. | vedi sotto |
| Instant Funding | nessuna valutazione | n.d. | n.d. | n.d. | n.d. | programmi L1 |

Dettagli per programma:
- Premier: scaling fino al 70%, "Programs start at $297".
- Piani Premier (pagamento unico, dalla pagina): $3.000 a $297; $5.000 a $373 (prezzo scontato da $497); $10.000 a $997; $25.000 a $2.497.
- Foundation (home, scheda "Foundation 10K"): $110 una tantum; target intern 10%, verification 5%, funded 10%; drawdown statico 6%; leva 200; split 65% / 70% / 85% / 90%; "No limit" sul tempo.
- Foundation (FAQ): "You have 2 demo trading stages of evaluation, Intern and Verification." Intern: 10% di target e 3 giorni di profittabilità. Verification: 5% e 3 giorni. Poi livello funded 65%, 70%, 85%, 90%.
- Tempo massimo: nessun limite (FAQ e T&C 12.20).
- Costo del reset / Free Retry: il reset esiste solo come "Free Retry" su coupon promozionali selezionati (FAQ). Costo di reset standard: NON TROVATO.
- Limiti di account contemporanei (FAQ): 3 Empire, 3 Xtreme, 5 Premier, 10 Traditional, 10 Foundation. Se si raggiunge il limite su un modello, non si possono avere altri conti in altri modelli.
- Età minima: 18 anni (FAQ).

### 1.2 Drawdown

- Tutti i drawdown sono statici, calcolati sul saldo iniziale (FAQ e All Rules).
- Drawdown giornaliero: nessuno ("There is no daily drawdown, just an absolute drawdown based on the initial account opening balance", All Rules).
- Violazione: se il conto raggiunge il drawdown massimo, viene chiuso (FAQ).
- T&C 12.11: il conto termina automaticamente se l'equity totale scende sotto il saldo iniziale di una percentuale pari al drawdown.
- Calcolo su equity o saldo, e inclusione delle perdite flottanti: NON TROVATO in modo esplicito. Il T&C parla di "Total Equity", quindi probabilmente include le flottanti (da confermare).

### 1.3 Expert Advisor, copy trading, strategie

- All Rules: "On all models, we allow EAs, HFT and copiers."
- FAQ: "We accept EA's, algorithms, scalpers, anyone and everyone – without restriction."
- T&C 12.24 vieta: posizioni contrapposte coordinate tra conti per ridurre artificialmente il rischio o raggiungere target; arbitraggio tra conti o sacrificio intenzionale di un conto; comportamenti "exploitative, manipulative, or not commercially replicable in real market environments". Il testo aggiunge che il hedging normale non dovrebbe essere colpito, ma la formulazione è ampia. Se violata, il conto è "breached".
- Martingala, grid, stop loss obbligatorio, rischio massimo per operazione: NON TROVATI.
- Limite di dimensione: "No. But you do need to consider the impact your size will have on the market." Il broker può avere un limite per singola operazione, "generally this is 100 Standard lots" (FAQ).
- Limiti di ordini al giorno: NON TROVATI.

### 1.4 Notizie e tenuta delle posizioni

- News trading: consentito sui programmi idonei (home).
- Overnight e weekend: consentiti, anche crypto nel weekend (All Rules).
- Swap e commissioni overnight: NON TROVATI.
- Gap e slippage: NON TROVATI.

### 1.5 Strumenti

- FX Majors, FX Minors, FX Crosses, FX Exotics, Metalli, Energia, Crypto, Indici, FX Index, Commodities (FAQ e home).
- Leva: 1:200 per la maggior parte dei programmi; 1:30 per Xtreme.
- Spread: "Normal Spreads" e "Pro Spreads" (checkout). Commissioni: "The broker has commission for execution on Pro Spreads only" (FAQ).
- Nomi dei simboli (Dow, oro, Bitcoin): NON TROVATI.

### 1.6 Piattaforma e dati

- Checkout: "Platform 5" e "TradeLocker".
- T&C 12.4: si scarica la piattaforma dai broker preferiti.
- T&C 12.3: il conto può girare su un server live, demo o di altro tipo.
- FAQ: conti Intern su server demo; conti Level 1 e superiori su server live.
- Fuso orario del server: NON TROVATO.
- VPS: NON TROVATO.

### 1.7 Pagamenti

- Profit share base: 50% su tutti i modelli; 90% al livello più alto (FAQ).
- Frequenza: ogni 7 giorni (home: "Not only do we offer 7-day payouts").
- CONTRADDIZIONE: T&C 12.17 dice "Only 1 payout per calendar month is allowed."
- Metodi (FAQ, prima risposta): bonifico, crypto, Revolut, PayPal.
- Metodi (FAQ, seconda risposta): PayPal, carta di credito, crypto.
- Fattura: va inviata entro 30 giorni dal raggiungimento del target di scaling, altrimenti si perde la quota di profitto (FAQ).
- Pagamento a Level 1 o superiore, ogni volta che si raggiunge un target di scaling (FAQ).
- Payout prima del target: possibile dal Level 1 (T&C 12.15).
- Minimo di prelievo: NON TROVATO.
- Regola di consistenza / best day: NON TROVATA.
- Verifica KYC richiesta prima del pagamento dei profitti (T&C 12.1).

### 1.8 Lock Rule (90%)

- Si può "bloccare" il conto a un livello dopo aver raggiunto il target di quel livello e aver ricevuto la quota prevista. Da lì si riceve il 90% dei profitti, senza ulteriore scaling (All Rules).
- Non disponibile su Intern e su Foundation (All Rules).

### 1.9 Fase funded: regole e violazioni

- Il conto è di proprietà della società: "any funds in the Prop account are owned by the Company" (T&C 12.8).
- Il trader non può prelevare fondi dal conto, né chiuderlo (T&C 12.9).
- La società può terminare il conto in qualsiasi momento, senza preavviso (T&C 12.10).
- Chiusura per inattività: 42 giorni (6 settimane) senza attività (T&C 12.21, All Rules).
- CONTRADDIZIONE: nel riassunto WebFetch del primo turno compariva "30 giorni" (presumibilmente da una pagina della home). Non riconfermato in questo turno.
- Violazioni: superamento del drawdown; comportamenti di cui alla clausola 12.24; chi non supera il KYC.
- Un conto raggiunto il target viene chiuso e se ne apre uno nuovo al livello successivo (T&C 12.18).
- Un conto terminato porta a nuove richieste dal livello Intern (T&C 12.22).
- Contestazione di una decisione: NON TROVATA nel dettaglio. Il sito indica un reclamo ad AFCA tramite Vested Equities (FSG).

### 1.10 Società

- Nome legale: The Concept AU/NZ Pty Ltd, ACN 652 938 399 (FSG, home).
- Sede: Torre 2, Suite 101/55 Plaza Parade, Maroochydore QLD 4558, Australia (home); la FSG riporta "Suite 01" (differenza minore).
- Licenza: AFSL 478987, tramite Vested Equities come Corporate Authorised Representative (n. 131 76 33) (FSG).
- La FSG dice che TCT fornisce solo consulenza generale e cita i prodotti: derivati, forex, CFD, titoli, ecc.
- Il sito dice che il programma di trading finanziato NON è coperto dalla licenza (nota dal riassunto precedente).
- Broker: The Concept Limited. Paese e licenza del broker: NON TROVATI.
- Email: admin@theconcepttrading.com. Telefono: +61 7 4599 3855. Orari: lun-ven 9-17 AEST.
- Contatti UK e Indonesia nel footer.
- FSG datata 20 febbraio 2024.

### 1.11 Reputazione (solo snippet, NON verificata)

- Trustpilot (dominio theconcepttrading.com): circa 429 recensioni; in gran parte positive; risposte dell'azienda presenti.
- Una recensione dice "Got my first pay-out 2 weeks back" (non verificata).
- Ci sono recensioni duplicate o di terze parti su siti come tradersunion.com (score 3.86/10, minimo deposito $77) e fundedtrading.com (score 8.3).
- Prove di pagamento pubbliche sul sito: NON TROVATE.
- Lamentele tipiche (ban, pagamenti negati): NON CERCATE in profondità.

### 1.12 Costi nascosti

- Pagamento della tariffa una tantum (home). La tariffa è un multiplo del capitale iniziale (x9, x10, x33).
- Commissioni: solo su Pro Spreads (FAQ).
- Coaching individuale: fino a $97 per 30 minuti (T&C 3.4).
- Reset: solo Free Retry su coupon promozionali (FAQ).
- Costo di prelievo: NON TROVATO.
- Abbonamenti: NON TROVATI.
- Coupon con scadenza: il sito mostra un timer promozionale di 7 giorni (non verificato).

### 1.13 Contraddizioni interne (da chiarire)

| Tema | Versione A | Versione B |
|---|---|---|
| Frequenza pagamenti | 7 giorni (home, FAQ) | 1 al mese (T&C 12.17) |
| Inattività | 42 giorni (T&C 12.21, All Rules) | 30 giorni (riassunto precedente) |
| Profit share | 50% base, 90% al top (FAQ) | "40% profit share" (FSG 2024) |
| Metodi di pagamento | bonifico, crypto, Revolut, PayPal | PayPal, carta, crypto (FAQ) |
| Foundation split | 65%/70%/85%/90% (home) | "fino al 90%" (pagina programmi) |

### 1.14 Note sul rischio per un EA (tuo caso)

- Positivo: EA, HFT e copier ammessi; overnight e weekend consentiti.
- Rischio 1: inattività di 42 giorni con chiusura del conto. Con H4 su oro, 20 operazioni l'anno possono generare pause più lunghe. Va chiarito come si conta l'attività.
- Rischio 2: clausola 12.24 su posizioni contrapposte e comportamenti "non replicabili". Se l'EA usa hedging o più conti, va verificato.
- Rischio 3: drawdown statico 5% (Premier), 3-4% (Xtreme/Traditional). Il backtest deve verificare che il drawdown del tuo EA rientri nella soglia.
- Rischio 4: la società può chiudere il conto in qualsiasi momento senza preavviso.
- Rischio 5: piattaforma e fuso orario del server non confermati.

---

## 2. iFunds

Sito dichiarato: https://ifunds.io/
Help center: https://help.ifunds.io/

ATTENZIONE: il sito ufficiale NON è confermato. Il dominio è coerente con sé stesso (home, About, help center), ma ci sono incongruenze: il CEO citato da siti terzi (Layth Sanjaq) non compare sulla home; l'email visibile è ops@iFunds.io ma il link mailto punta a ops@axux.com; il copyright compare come 2024 e 2025; i testimonial Trustpilot sono duplicati. Nessuna fonte indipendente conferma l'identità della società.

Attenzione anche al nome: "iFunds" non è "Instant Funding" (altra società, citata da siti terzi).

### 2.1 Programmi

Dalla home (https://ifunds.io/) e da https://ifunds.io/instant-funding:
- "Instant Funding up to $500k". Nessuna challenge. "No challenge, no complex rules, instant Payouts."
- Piani:

| Piano | Capitale | Quota di partecipazione | Profit split | Max overall loss | Daily loss | Tempo | Min giorni |
|---|---|---|---|---|---|---|---|
| Intern | $2.500 | $250 | 50% (fino all'80%) | 10% | No | nessun limite | No |
| Starter | $5.000 | $400 | 50% (fino all'80%) | 10% | No | nessun limite | No |
| Ambitious | $10.000 | $700 | 50% (fino all'80%) | 10% | No | nessun limite | No |
| Guru | n.d. | n.d. | n.d. | n.d. | n.d. | n.d. | n.d. |

- Il sito dice che la quota è "a program participation fee, not a deposit".
- Piano Guru: visibile solo nelle tab, senza dettagli.
- Quota unica o ricorrente: NON TROVATO.
- Costo di reset: NON TROVATO.
- Il drawdown si sceglie tra 6% e 10% in registrazione (FAQ). Più è basso, più alto è lo split.

### 2.2 Drawdown

- Statico, calcolato sul saldo iniziale (FAQ e home).
- Esempio dalla FAQ: conto da $10.000 con drawdown 10%: perdita massima $1.000, livello di disqualifica $9.000.
- Daily loss: "not subject to a daily loss/drawdown limit" (FAQ).
- Disqualifica: se l'equity raggiunge il livello di disqualifica in qualsiasi momento, indipendentemente dal profitto chiuso (FAQ).
- Perdite flottanti incluse: NON TROVATO in modo esplicito.
- Altre violazioni che portano alla disqualifica: NON TROVATE.

### 2.3 Expert Advisor, copy trading, strategie

- FAQ: EA consentiti, propri o di terzi, purché non usino manipolazioni come latency arbitrage o HFT. Il testo cita anche "other methods that are deemed to be abusive by our Liquidity Providers".
- Home e About: EA e robot di terzi "without any restriction" (formulazione di marketing, più ampia della FAQ).
- Copy trading: consentito con qualsiasi copiatore, senza restrizioni, purché non ci siano tecniche manipolative (FAQ).
- Hedging: NON TROVATO nel testo.
- Martingala, grid: NON TROVATI.
- Limite di ordini al giorno o lotti: NON TROVATO.
- Rischio massimo per operazione: "There is no maximum risk per trade rules" (FAQ), ma si incoraggia una gestione del rischio adeguata.
- Stop loss: NON TROVATO.

### 2.4 Classifica pubblica e copy trading a pagamento

- Pagina https://ifunds.io/top-traders: classifica "All Time Top Traders by ROI", con colonne su payout, ROI, max drawdown, data e analisi. Nel contenuto letto la tabella risulta vuota.
- Criteri di ammissione, frequenza di aggiornamento e calcolo del ROI: NON TROVATI.
- Copy trading a pagamento (chi paga, quanto, a chi va la quota): NON TROVATO. La pagina non descrive il copy trading a pagamento.

### 2.5 Notizie, weekend e overnight

- News trading: consentito (home e FAQ).
- Weekend holding: consentito "as long as you have sufficient margin" (home).
- Margine richiesto nel weekend e cosa succede se scende: NON TROVATO.
- Overnight come voce separata e swap: NON TROVATI.

### 2.6 Strumenti e leva

- "stocks, currencies, metals, energies, and cryptocurrencies" (home).
- Leva di riferimento (FAQ): FX Major e Cross 1:100; FX Exotics 1:25; Oro 1:200; Argento 1:100; Indici spot e futures 1:100; Energie 1:100; Criptovalute 1:10.
- Home: "Leverage 1:100, will change dynamically based on your Risk Level" (dal riassunto precedente).
- Spread e commissioni ufficiali: NON TROVATI sul sito. Un sito terzo parla di "no commission on forex" (non ufficiale).
- Simbolo del Dow e nome degli indici: NON TROVATI sul sito.

### 2.7 Piattaforma e dati

- FAQ: tutti i conti funded sono creati e operati su MetaTrader 5.
- Fuso orario del server: NON TROVATO.
- VPS: NON TROVATO.
- Più IP consentiti (home).

### 2.8 Pagamenti

- Prelievo on demand da $50, senza limiti di frequenza o di tempo (home e /payouts).
- Elaborazione entro 24 ore; altrimenti 10% extra fino a $1000 (home).
- Pagina /payouts: "guarantee payouts processed on demand within 24 hours, with no limits on timing or frequency" (dichiarazione del sito).
- Feed pubblico: una lista di pagamenti "randomly selected" pubblicata dall'azienda. Esempi nel feed: $1.000, $100, $70, $141, $7.185, $33,5, $90, $37,5, $72,8, $288,5. Non è una verifica indipendente.
- Consistenza: nessuna regola (home).
- Metodi di pagamento: il sito indica "multiple withdrawal methods" (senza elenco). Nel feed compaiono USDT (ERC20 e TRC20), USDC ERC20 e Skrill.
- Help center: la categoria "Pagamenti" dice "Nessun ciclo di pagamento o limite di tempo" (ultimo aggiornamento 2 anni fa).

### 2.9 Società

- Dalla lettura precedente (WebFetch, non riconfermata in questo turno): iFunds Ltd, Saint Lucia, reg. 2024-00154; Synerjic Ltd, Cipro, reg. 474148, ruolo non specificato.
- La pagina "Chi siamo" (About) dice che iFunds "was founded by seasoned traders, risk managers, and financial experts", ma non nomina una società né una licenza.
- Numero di licenza regolamentare: NON TROVATO.
- Disclaimer: "The services provided on this website are professional skill-assessment services" (dal riassunto precedente).
- Propfirmmatch: iFunds "not listed", cioè non verificata da quel sito.

### 2.10 Reputazione (solo snippet, NON verificata)

- Trustpilot (ca.trustpilot.com/review/ifunds.io): circa 206 recensioni, in gran parte positive, con risposte dell'azienda.
- Testimonial sulla home: molti, in più lingue; non verificabili, alcuni duplicati.
- Non ho letto le lamentele.

### 2.11 Help center (aggiornamento)

- Categorie: Per iniziare (un anno fa), Regole di finanziamento istantaneo (un anno fa), Pagamenti (2 anni fa), Ridimensionamento (2 anni fa), Promozioni (2 anni fa).
- Articolo "Domande frequenti sulle regole di trading": letto con WebFetch (riassunto). La data di aggiornamento non è determinabile.

### 2.12 Note sul rischio per un EA (tuo caso)

- Positivo: EA di terzi o propri consentiti; copy trading consentito; news trading consentito; weekend consentito con margine; nessun drawdown giornaliero; MT5 per tutti i conti funded.
- Rischio 1: divieto di HFT e latency arbitrage, con definizione NON chiara. Un EA intraday sul Dow in sessione USA può essere letto come HFT.
- Rischio 2: drawdown statico al 6%-10% scelto. Con l'oro su H4 e posizioni tenute, il backtest deve usare il drawdown scelto.
- Rischio 3: margine nel weekend non chiarito. Se scende, la chiusura forzata è possibile ma non documentata.
- Rischio 4: leva 1:200 sull'oro, dichiarata. Va verificato l'effetto sul margine.
- Rischio 5: fuso orario del server non noto: incide su candele H4 e sessioni.

---

## 3. Confronto tra le due (senza consigliare)

- Concept Trading: percorso a fasi (Premier, Empire, Traditional, Xtreme, Foundation) con drawdown statico tra il 3% e il 10%, leva fino a 1:200, split base 50% fino al 90%, Lock Rule, fondi di proprietà della società, licenza AFSL tramite un'altra società (Vested Equities). Presenta incongruenze interne su pagamenti, inattività e split.
- iFunds: accesso immediato senza challenge, quota una tantum, drawdown statico 6%-10% scelto dal trader con split collegato (50%-80%), prelievi on demand da $50, leva dichiarata per asset class, MT5. Meno informazioni verificabili su società e licenza; sito ufficiale non confermato.

---

## 4. Domande per il supporto

### Concept Trading

1. Clause 12.17 says one payout per calendar month, but the home page and FAQ say payouts every 7 days. Which applies to each programme?
2. Clause 12.21 says 42 days of inactivity leads to termination, but another page mentioned 30 days. Which is correct, and does any open trade count as activity?
3. The FAQ gives two different lists of payment methods. Which is current?
4. Does clause 12.24 (coordinated opposing positions across accounts) apply to a single EA that hedges within one account?
5. Is the drawdown measured on total equity including floating losses? At what time is it checked?
6. The Financial Services Guide mentions a 40% profit share. Does this apply to funded accounts, or is the site's 50–90% correct?
7. Which entity holds client trades, and what is The Concept Limited's licence number?
8. What are the reset fees and the conditions for a Free Retry?
9. What is the minimum payout amount, and is there a consistency or "best day" rule?
10. What are the exact symbol names for the Dow, gold and Bitcoin, and what is the server time zone?

### iFunds

1. What margin is required to hold positions over the weekend, and what happens if margin falls below it?
2. Are overnight holds allowed, and is any swap charged?
3. Are floating losses included in the disqualification equity level?
4. How are HFT and latency arbitrage defined, with objective criteria (orders per day, minimum holding time)?
5. What is the server time zone for MT5, and is a VPS allowed?
6. Are there limits on the number of orders per day or the lot size per trade?
7. What other violations lead to disqualification? Is there a complete list?
8. What is the full legal name, registration number and jurisdiction of the company that operates iFunds? What regulatory licence does it hold, and what role does Synerjic Ltd play?
9. Is copy trading in the public leaderboard charged to traders, and to whom does the fee go?
10. Can you confirm that ifunds.io is the official website, and which support email domain is correct (ops@iFunds.io or ops@axux.com)?

---

## 5. Cose che non ho potuto fare

- Non ho letto il blog e la privacy policy di Concept Trading.
- Non ho letto le T&C, la privacy policy e le pagine di supporto di iFunds nel testo originale.
- Non ho letto le risposte complete della FAQ di Concept Trading (sono troncate nell'albero della pagina).
- Non ho letto il testo originale della FAQ di iFunds (ho usato un riassunto WebFetch).
- Non ho potuto verificare la licenza o la società di iFunds.
- Non ho verificato le recensioni o le prove di pagamento in modo indipendente.

---

## 6. Pagine lette

### Concept Trading (browser, testo originale)
- https://prop.theconcepttrader.com/
- https://prop.theconcepttrader.com/prop-trading/
- https://prop.theconcepttrader.com/faq/ (solo domande e risposte visibili nell'albero)
- https://prop.theconcepttrader.com/all-rules/
- https://prop.theconcepttrader.com/terms-and-conditions/
- https://prop.theconcepttrader.com/financial-services-guide/

### Concept Trading (WebFetch, riassunto)
- https://prop.theconcepttrader.com/ (home, primo turno)

### iFunds (browser, testo originale)
- https://ifunds.io/
- https://ifunds.io/about-us
- https://ifunds.io/payouts
- https://ifunds.io/instant-funding
- https://help.ifunds.io/
- https://help.ifunds.io/category/instant-funding-rules (solo introduzione)
- https://help.ifunds.io/category/payouts (solo introduzione)

### iFunds (WebFetch, riassunto)
- https://ifunds.io/ (home, primo turno)
- https://help.ifunds.io/article/instant-funding-faqs
- https://ifunds.io/top-traders

### Ricerche (solo snippet, non aperte)
- ca.trustpilot.com/review/ifunds.io
- ca.trustpilot.com/review/theconcepttrading.com
- ch.trustpilot.com/review/prop.theconcepttrader.com
- thetrustedprop.com (varie pagine su iFunds e The Concept Trading)
- propvator.com (varie pagine su iFunds)
- propfirmmatch.com/crypto/unlisted-prop-firms/ifunds
- tradersunion.com/brokers/prop/view/the-concept-trading/
- fundedtrading.com (pagine su The Concept Trading)
- propfirmmap.com/firms/theconcepttrading
- propfirmmap.com/firms/ifundsio
- forexpeacearmy.com/forex-reviews/23103/the-concept-review
- tradingfinder.com/props/the-concept-trading
