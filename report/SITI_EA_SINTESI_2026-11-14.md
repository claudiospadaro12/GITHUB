# Analisi dei siti degli EA (Claude Desktop, 14/11/2026): cosa serve a noi

**Fonte**: due zip, archiviati in `SITI_EA_ARCHIVIO_2026-11-14/` (Parte 1: sito e MQL5 del venditore; Parte 2: forum, prop firm, concorrenti). Sono letture parziali, dichiarate tali dai file. Numeri e frasi sono dichiarazioni del venditore o di terzi, non verificate. Forex Factory, Reddit, BabyPips, TradingView, Trustpilot FTMO e dashboard NON sono stati aperti (restrizioni o proxy).

## Cosa dicono i dati pubblici sui nostri EA (confronto tra sito e segnali MQL5)
| EA | Sito (dichiarato) | Segnale MQL5 aperto (dichiarato dalla pagina) |
|---|---|---|
| Gold Reaper | +312%, DD 15,2% | segnale 2265877 "Gold Reaper New V2 2": +335,5%, DD 16,9% sul saldo, PF 2,02, 930 operazioni, 107 settimane dal 22/10/2024, deposito iniziale 1.602,85 USD, broker CapitalPointTrading; **avvisi "No trading activity detected" tra giugno e ottobre 2026** |
| Gold Trade Pro | +198%, DD 12,1% | segnale 2084890: +759,9% su 1.000 EUR, **DD 31,9% sul saldo**, PF 1,65, 803 operazioni, 162 settimane, perdita consecutiva massima -1.124 EUR |
| Goldbot One | +178%, DD 10,5% | nessun segnale dedicato trovato; una fonte collegata cita DD 26% |
| Gold Phantom | +142%, DD 9,8% | segnali con crescita 14-19% e DD 11-13% (dichiarati) |
| UBS (Scalp C) | nessun dato | segnale 2385027: +204,6% in 15 settimane, deposito 200 USD, DD 8,3%, **avviso piattaforma "Alto rischio di slittamento negativo"**, tempo medio di tenuta 54 s |

**Lettura**: sul Gold Trade Pro il drawdown reale del segnale e circa 2,6 volte quello del sito. Per il Reaper sito e segnale coincidono (15-17%) ma altre fonti citate ne danno 46% (da verificare). Per i prop questo conferma la scelta di misurare noi i DD in tester e di usare il Guardian, e di non fidarci dei numeri del sito. Il segnale e un mix di EA e di conti piccoli: non e un test dei nostri set.

## Cose di marketing e affidabilita del venditore (non cambiano i nostri test)
- **Prezzo del Gold Reaper in cinque versioni** (615 / 949 / 990 "final price" / 599 blog / 99 al mese di membership) e "final price 990 $" ripetuto da oltre un anno.
- **I due link Myfxbook "verificati" pubblicati dal venditore danno 404**: "Myfxbook verifica ciascun conto" non e verificabile qui.
- Il sito dichiara "976 recensioni verificate"; Trustpilot mostra 16 (in una versione).
- Garanzia: "rimborso completo" nel pacchetto oro contro "30 giorni limitata con esclusioni" nella FAQ; responsabilita limitata al minore tra 12 mesi di pagamenti e 100 EUR.
- "100% automatico" e "NON usare set and forget" nella stessa FAQ; supporto solo lun-ven 9-17 CET.
- Stability Pro descritto come "sistema a griglia" su MQL5 e "nessuna griglia" sul sito; ORB Master con la dicitura "NOT RECOMMENDED TO BUY" ancora in vendita.
- Punteggi (Prova / Rischio / Coerenza, 0-3): Reaper 2/1/0, Gold Trade Pro 1/1/0, Goldbot 1/1/0, Phantom 1/1/1. Sono giudizi sui testi, non sulla strategia.
- Recensioni del Reaper su MQL5: vedi `NOVITA_EXPERT_DISCORD_2026-11-14.md`.

## FTMO: attenzione alla fonte
La Parte 2 cita come "pagine ufficiali FTMO" un mirror **`ftmo.oanda.com`** e uno snippet di `ftmo.com/au`. **`ftmo.oanda.com` non e il dominio FTMO (che e ftmo.com)**: potrebbe essere una pagina di un'altra azienda o un mirror; NON la considero fonte affidabile per le regole FTMO. Le nostre fonti FTMO restano le risposte scritte di FTMO (13/11). Cio che hanno riportato: massimo di azioni su ordini al giorno "tipicamente circa 2.000"; "200 ordini alla volta e 2.000 posizioni massime al giorno"; posizioni opposte tra conti vietate; EA di terzi usabili ma altri possono usare lo stesso EA. Su ordini/giorno le risposte scritte FTMO dicevano: tutte le richieste contano, limite non dichiarato.

**Controllo fatto da me sui nostri report di tester (ordini piazzati o cancellati, esclude le modifiche del trailing)**: Reaper L3 media 12-13 ordini al giorno, massimo circa 43-58; Goldbot L0 media circa 10, massimo circa 30; Phantom L1 media circa 34, massimo circa 91. La somma dei massimi di P1 sta ben sotto 2.000 al giorno. **NON MISURATO**: le modifiche di SL/TP del trailing (non sono nella tabella ordini del report) e il Daytrade Pro. Va controllato sul trial con il registro del conto.

## Cosa NON e uscito
Nessuna esperienza di terzi con i nostri EA su FTMO; nessuna nuova regola FTMO verificata; nessun nuovo settaggio. I thread EarnForex elencati non parlano del venditore.

## Da fare a mano (dal file 99 di entrambe le parti, in ordine di utilita per noi)
1. Aprire Myfxbook a mano e cercare i conti Reaper del venditore.
2. Sulla pagina del segnale 2265877 controllare il perche dei periodi senza operazioni (giugno-ottobre 2026) e il DD (16,9% o 46%).
3. Leggere le regole FTMO solo da ftmo.com (pagina "forbidden trading practices" e FAQ) e annotare la data.
4. Forex Factory, Reddit e Trustpilot FTMO con la ricerca "Gold Reaper", "UBS", "Profalgo", "FTMO EA".

---
# Aggiunta: terza lettura (zip `ANALISI_SITI_EA_2026-11-14`) e CONTRADDIZIONI tra le tre letture

La terza lettura (archiviata in `SITI_EA_ARCHIVIO_2026-11-14/terza_lettura/`) copre sito del venditore, MQL5 Phantom (161561) e Reaper (111357), i segnali 2204998 e 2355966 e un thread Forex Factory del 2018. Nessuna informazione su FTMO. Estrazioni automatiche troncate a 100.000 caratteri, dichiarate.

**Le tre letture non coincidono sugli stessi dati, quindi i numeri vanno trattati come NON AFFIDABILI finche non li vediamo noi:**
- Gli EA oro del sito coincidono (Reaper +312%/15,2%, GTP +198%/12,1%, Goldbot +178%/10,5%, Phantom +142%/9,8%). Gli altri prodotti NO: Parte 1 dava Daytrade Pro +73,8%/15,6%, Luna +207%/40,2%, Bitcoin Reaper -11,7%/34%, ORB Master +27,2%/50,1%; la terza lettura dice Daytrade Pro +156%/11,3%, Luna +94%/7,2%, Bitcoin Reaper +64%/18,6%, ORB +87%/8,4%. Almeno una delle due e sbagliata (o la pagina cambia): **non uso la tabella dei prodotti non oro della Parte 1**.
- Segnale 2204998 (Reaper + GTP + Daytrade Pro): DD 32,6% (relativo sul saldo, 1.821,98 USD), 26,12% (2.361,66 USD) e 50,68% (1.822,33 USD) nelle tre letture. Mia interpretazione, da verificare: MQL5 riporta piu misure di drawdown (saldo/equity, relativo/assoluto) e i lettori ne hanno usate di diverse; i 1.822 USD tornano in due letture. **Non e una contraddizione dimostrata ne una conferma.**
- Segnale Phantom Darwinex 2355966 (avviato il 27/01/2026): crescita mensile +6,62% / +2,18% (versione tedesca) / **-1,78% con previsione annua -21,59%** nella lettura di oggi; DD 23,43% o 19,65%; 13 perdite consecutive per -445,56 USD; avvisi "nessuna attivita" ricorrenti dal 07/07 al 15/10/2026. **Se la lettura negativa e quella vera, e un'informazione rilevante sul Phantom (cuore di P1), ma non so con quali impostazioni giri quel conto.** Da aprire e leggere a mano (sezione crescita mensile e storico).
- Altre conferme: Reaper 5.6 e Phantom 2.5 aggiornati il 28/10/2026; recensioni negative del Reaper del 10/11, 28/10, 22/10 (gia note); prezzi incoerenti; "Final price 990$" ripetuto.

**Decisione**: fermiamo l'analisi dei siti con Claude Desktop (tre passate parziali, numeri incoerenti). Se serve un dato (in particolare il segnale Phantom 2355966 e il Reaper 2204998), si fa con una schermata da te sulla pagina MQL5: la leggo io direttamente.

---
# Aggiunta: terza lettura AGGIORNATA (zip `ANALISI_SITI_EA_2026-11-14_1`, archiviata in `terza_lettura_v2/`)

E la stessa analisi della terza lettura con una "seconda lettura" aggiunta in coda a ogni file (stesso nome cartella, impronta diversa). Dichiara ancora cifre MQL5 che cambiano tra letture: "non usare nessuna cifra senza aprirla a mano". Riporto solo cio che serve a noi.

## FTMO: testo ufficiale letto (ftmo.com/en/forbidden-trading-practices, ultima modifica dichiarata 02/11/2026)
- **Iperattivita**: vietato l'EA che causa attivita eccessiva, con "more than 2,000 server requests per day on individual simulated trades or pending orders". **"Server requests" includono con ogni probabilita anche le modifiche di SL/TP** (NON verificato nel testo): il mio controllo del 14/11 sui report del tester contava solo ordini piazzati o cancellati (Phantom L1 max circa 91/giorno, Reaper L3 max circa 58, Goldbot L0 max circa 30), quindi **non copre le modifiche del trailing: NON MISURATO**. Da misurare sul trial: contare nel Journal di MT5 le righe "modify" per giorno.
- **Posizioni opposte**: vietate "for manipulative purposes, for example by simultaneously entering into opposite positions", con eccezione per un singolo conto. Questa formulazione (scopo manipolativo) e MENO netta della risposta scritta che FTMO ci ha dato il 13/11 ("cross-account hedging vietato in modo rigoroso"): resta valida la piu severa. Le posizioni opposte tra P1 e P4 nascono da strategie indipendenti, ma il rischio non e eliminato.
- **Tetto 400.000 $ per strategia e "stessa strategia su piu conti"**: NON compaiono in questa pagina; il tetto resta quello della risposta scritta di FTMO (la pagina letta e un'altra). I blog di terzi (pickmytrade, propvator) non fanno fede.
- Gap trading vietato "intorno a eventi macro" (coerente con la risposta di FTMO: solo se intenzionale).
- Esperienze di terzi con gli EA di Wim su FTMO: NON TROVATE (Reddit e Forex Factory: ricerche senza risultati pertinenti, non e una prova di assenza).

## Reaper: altri segnali pubblici (dichiarati dalla pagina, non verificati, DD non letto)
| Segnale | Dati |
|---|---|
| 2265877 "Gold Reaper New V2 2" | 81 settimane, +214% dal 2024, 737 operazioni, 71,91% operazioni in profitto, DD 16,05% (lettura precedente) |
| 2195619 "Gold Reaper Live default settings" (copia su Pepperstone UK) | 63 settimane, **+29% dal 2024**, 726 operazioni |
| 2287007 "Reaper high risk" | 47 settimane, +2.080% su 1.888 operazioni, avviso piattaforma 17/12/2025 "Too much growth in the last month indicates a high risk" |
Lettura mia: lo stesso EA mostra rendimenti molto diversi secondo il rischio scelto; il conto con le impostazioni di default ha fatto solo +29% in 63 settimane contro il +312% del sito. Sono conti di tipo diverso e non so le date di partenza, quindi e un'indicazione, non un confronto.

## Altro
- /risk-warning di Profalgo (aggiornato 23/03/2026): rischio e stop loss a carico dell'utente (Sez. 5.1) ma "assumes full responsibility for the Product and Services" (Sez. 7.5(a)); martingala, grid e prop firm non nominati.
- Il nome "Gold Reaper" e usato anche da altri venditori (MQL5 161775, gumroad a 10,25 $, blog 775895): non sono del nostro venditore.
- La pagina MQL5 del Reaper MT4 contiene un paragrafo di un altro EA ("GoldStrike Predator"): errore di pagina o duplicato, non verificato.
- Portafoglio A del sito (Reaper moderate + Luna AI Pro + Gold Trade Pro): +228%, DD 12,4%, periodo e broker non indicati; il link Myfxbook non si apre.

---
# Aggiunta: terza lettura, versione 3 (zip `ANALISI_SITI_EA_2026-11-14_2`, archiviata in `terza_lettura_v3/`)
Stessa analisi con in coda una "terza lettura": aggiunge Trustpilot, Myfxbook, blog di terzi e altri prodotti. Dichiarazioni, non verificate; cifre MQL5 che cambiano tra lingue/letture.

- **Myfxbook "gold-reaper-moderate" (conto 10686236, link pubblicato dal venditore, ora si apre ma in parte privato)**: drawdown massimo **41,66%**, guadagno **+14,97% su 5.000 USD**, 634 operazioni, 22,67 lotti totali, "anno in corso -1,21%"; la pagina e incompleta e la data di avvio non e stata letta ("ultimi 200 trade" contro 634 nelle statistiche). Il sito dichiara 15,2% per il Reaper. Il Reaper "moderate" e l'impostazione che Wim dice di usare (TradeFrequency moderate). **Da verificare con una schermata tua prima di dedurre qualcosa**: se confermato, il drawdown reale sarebbe circa 1,4 volte il bersaglio di MaxAllowedDD 30 (tutto da accertare: set, broker, date e deposito 5.000 USD con lotti minimi). Non cambia i nostri test; e un'altra ragione per tenere il Guardian.
- **Test storico di terzi** (blog MQL5 776719, 14/10/2026, DoItTrading): Reaper v4.6, XAUUSD su Axi, 02/2020-09/2026, candele da 1 minuto, lotto fisso 0,01: "peggior DD storico 8,46%" sulle chiusure giornaliere e **17,89% nello stress al 99 percentile**; segnale pubblico dello stesso autore +309% dal 2024 con DD sul saldo 16,89%; scrive: "on a small account, I wouldn't run it". Ha un link affiliato Axi dichiarato. Usa lo stesso modello dei nostri test (1 minuto OHLC): coerente col nostro metodo, non una verifica indipendente.
- **Segnale 2265877 in portoghese**: DD 16,05% (319,61 USD), relativo sul saldo 16,89%, crescita mensile 4,79%, previsione annua 58,12%: coerente con le altre letture del DD; la crescita dipende dalla lingua/finestra della pagina.
- **Frase del venditore** in un post promozionale: "Running 'elevated grid' set" senza dire per quale EA; il catalogo include anche "Grid King" (MQL5 33065). Il sito dichiara "no grid, no martingale". Da accertare per quale prodotto.
- **FTMO**: Trustpilot FTMO circa 42.000 recensioni e 4,8; casi singoli negativi (conto chiuso dopo un prelievo; "4% drawdown and was closed"): esperienze personali, non statistiche. Reddit bloccato dall'ambiente; Forex Factory e FX Blue senza risultati su Profalgo/Gold Reaper.
- Esperienze di terzi con gli EA di Wim su FTMO: NON TROVATE.

**Coerenza con i nostri backtest**: il 31/10 avevamo gia confrontato i rendimenti mensili del segnale 2265877 con i nostri test (`CONFRONTO_SEGNALE_WIM_REAPER_2026-10-31.md`): i segni dei mesi coincidono (es. febbraio 2025 -6,7% contro -3,6%; ottobre 2025 -4,2% contro -3,0%), con ampiezze minori nei test. Il blog di terzi usa lo stesso modello a 1 minuto. I dati dei siti non contraddicono la nostra base: li usiamo per ipotesi e controlli, non per cambiare i numeri.

---
# Aggiunta: quarta lettura (zip `ANALISI_SITI_EA_2026-11-14_3`, archiviata in `quarta_lettura/`)
Aggiunge le pagine del sito del venditore che mancavano (/reviews, /faq, /affiliates, /about, /brokers, /membership, /easyalgos, /free-ebook) e un tentativo su Forex Factory. Dichiarazioni del venditore, non verificate.

**Cose utili a noi**
- **Licenze**: FAQ: "Each purchase comes with 10 licenses per Expert Advisor", non trasferibili dopo l'attivazione. Coincide con le 10 licenze per EA di Claudio (e Massimo ha le sue, separate). **Non e dichiarato cosa conta come "licenza" (conto? terminale? IP?)**: se e per conto, Goldbot e Daytrade Pro (presenti su trial FTMO, P1, P4, demo, reale e VPS) potrebbero avvicinarsi a 10. Da fare: elencare i conti su cui ogni EA e stato attivato e contarli. Non verificato come Wim conta.
- **Membership $99/mese**: solo Gold Reaper, un solo conto MT5, con dashboard/SET/manuale/aggiornamenti finche si e membri. Non ci riguarda.
- **Supporto**: solo lun-ven 9-17 CET, risposta in 1-2 giorni lavorativi, nessun supporto nel weekend. Utile: non contare su aiuto nel fine settimana (l'upgrade Contabo del venerdi sera).
- **Rischio/responsabilita**: rinnovo il punto noto: tutto il rischio e a carico dell'utente (risk-warning sez. 5.1).

**Cose di affidabilita (non cambiano i test)**: /easyalgos dice che "il broker paga EasyAlgos per i clienti che porta" mentre /brokers raccomanda gli stessi broker (IC Markets, IC Trading) come "we use and trust" senza dichiarare compensi; leva UE "1:30" nella FAQ contro "fino a 1:500" in /brokers; "over 950 verified reviews" ma /reviews ne mostra 81 senza recensioni negative; storia dichiarata incoerente (2000/2005/2008/2013/2014; Profalgo "fondata nel 2019" senza numero di registro in /about, C-93668 nel risk-warning); "piu di 10.000 prodotti venduti" non verificabile.

**Forex Factory**: indice letto (Prop Firm Discussion: 41 thread e 59.077 risposte; Trading Systems 3.412), ma le liste di discussioni e la ricerca interna non si aprono dal sistema di lettura: NON LETTE. Nessuna informazione utile da li. Reddit bloccato. FX Blue: nessun conto Profalgo.

---
# Aggiunta: lettura del 13/11 sera (zip `ANALISI_SITI_EA_2026-11-13_1`, archiviata in `lettura_13_11/`): chiarisce i drawdown e mette a fuoco il Phantom
E la prima sessione di Claude Desktop (13/11, 23:51), parziale: sito del venditore (solo home), MQL5 (3 prodotti, 2 segnali), ForexPeaceArmy (solo titoli del tag EA). Nessun dato FTMO.

## I drawdown "contraddittori" sono misure diverse della stessa pagina MQL5 (segnali)
- **Segnale 2204998** (Reaper + GTP + Daytrade Pro, avviato il 26/02/2024, 217 settimane, 8.285 operazioni, PF 1,15): massimo per saldo **2.361,66 USD = 26,12%**; **relativo sul saldo 32,59%**; **relativo sull'equity 9,00%**. Quindi le cifre 26,12% / 32,6% / 9,00% sono tre misure DIVERSE, non una contraddizione. (Il 50,68% di un'altra lettura resta non spiegato.)
- **Segnale 2355966** (Gold Phantom, Darwinex, avviato il 27/01/2026, 48 settimane): massimo per saldo **624,38 USD = 23,43%**; relativo sul saldo 11,02%; relativo sull'equity 5,95%; **692 operazioni, profit factor 1,07-1,08**; saldo 5.336,90 USD con deposito iniziale 2.000 e depositi 3.000 USD, prelievi 0 ("Growth 17,21%": il rendimento sul capitale versato e circa 6,7%). Avvisi di inattivita da febbraio a ottobre 2026.

## Il punto che conta: il Phantom live e molto sotto al nostro tester
| Fonte | Periodo | Operazioni | Profit factor |
|---|---|---|---|
| Nostro tester, Phantom L1 (D160 R1/R2, 160k) | 2025 | 1.105 | **2,87 / 2,90** |
| Segnale Darwinex di Wim (impostazioni NON note) | 27/01-13/11/2026 | 692 | **1,07-1,08** |
| Nostro trial FTMO | ottobre-novembre 2026 | 25 (36% in profitto) | **0,26** (campione piccolo) |
| Nostro reale | idem | 12 (17%) | **0,40** (campione piccolo) |
Fonti dei due ultimi: `STORICO_REALE_E_TRIAL_2026-11-12.md`. **Non e una prova che il tester sia sbagliato**: periodi diversi (2025 contro 2026), campioni piccoli, impostazioni e capitale diversi (a 2.000-5.000 USD il lotto minimo 0,01 e la selezione automatica delle strategie cambiano il comportamento), spread e slippage di Darwinex e dei broker live non nel tester. Ma e il divario piu grande che abbiamo tra tester e live, ed e sul Phantom, componente di P1.

**Prova che propongo (nessuna lanciata)**: far girare il Phantom Gradino 1 (`GoldPhantom_Propfirm.set`) a tick reali sul periodo 01/01/2026 -> oggi (stesso periodo del live) e confrontare profit factor, numero di operazioni e mesi con (a) il segnale Darwinex e (b) il nostro trial. Criteri e previsioni da fissare prima.

---
# Aggiunta: lettura del 13/11 aggiornata (zip `ANALISI_SITI_EA_2026-11-13_2`): cambia solo il file FTMO
Gli altri file sono identici allo zip precedente. Il file `03_PROP_FIRM_E_FTMO.md` (archiviato in `lettura_13_11_v2/`) riporta le regole dalla pagina ufficiale ftmo.com/trading-objectives (modificata il 02/11/2026): 2-Step 10% Challenge e 5% Verification; perdita giornaliera 5% **ricalcolata alle 00:00 CE(S)T**; perdita massima 2-Step statica (10%); almeno 4 giorni di trading. **Sono regole che avevamo gia letto il 07/11** (`FTMO_REGOLE_LETTE_ANALISI_2026-11-07.md`): nessuna novita. FAQ FTMO: solo titoli, risposte non lette. Su EA, hedging tra conti, richieste, stop out: NON TROVATO nelle pagine ufficiali lette (le fonti di terzi dicono 2.000 richieste/giorno e tetto 400.000 $, non verificate qui).
Esperienze di utenti (opinioni, non fatti): ForexPeaceArmy post 494463: "FTMO reviewed the same master account, same bridge, same strategy, same trades, and issued me a formal written compliance confirmation. Cleared." (nessuna lettera vista); energyexch: tre conti (FTMO, 5%ers, Darwinex) con lo stesso EA e stessa configurazione, esperienza personale; Trustpilot FTMO 4,8 su 55.579 recensioni (3% a 1 stella).
**Correzione alla mia checklist**: avevo scritto che il reset del limite giornaliero FTMO "non ha risposto": e invece pubblico, 00:00 CE(S)T. Conseguenza pratica per il Guardian: sui conti FTMO `InpDailyResetHour=1` (server = ora italiana + 1), mentre il preset BCM demo ha 0. Checklist aggiornata.

---
# Aggiunta: lettura del 13/11, versione 4 (zip `ANALISI_SITI_EA_2026-11-13_4`, archiviata in `lettura_13_11_v3/`)
Cambiano il file FTMO, un nuovo file `08_ALTRI_SITI_E_FONTI.md` e i file di coda; il resto e identico.
- **Termini e condizioni FTMO**: la pagina HTML (ftmo.com/en/terms-and-conditions/, modificata il 26/08/2026) rimanda a un PDF "General Terms and Conditions - Global" che il sito blocca al lettore automatico (robots.txt, non aggirato). **Le clausole su EA, hedging tra conti, richieste al server, copy trading, tetto di capitale e stop out sono li e NON sono state lette.** FAQ FTMO: solo titoli ("How many accounts can I have?", "Can I trade news?"), senza risposte.
- **Altro (tutte esperienze o opinioni non verificate)**: utenti ForexPeaceArmy/BabyPips con chiusure di account su altre prop firm (BlueberryFunded: violazione per "grid-like behavior", poi "EA permessi"; The5ers; un conto FTMO con perdita giornaliera 2.617,65 contro limite 2.500); blog commerciali (pickmytrade, jptradingcapital); cluster di EA oro su MQL5 con promesse "prop firm" e link di affiliazione FTMO.
- **Myfxbook del venditore (strueli)**: lettura incerta; elenca conti reali e demo con rendimenti enormi (es. "+199.171%" su un conto demo), nessuna verifica: non e un track record.
- Reddit, Forex Factory e FX Blue: ancora non letti.
**Azione per Claudio**: scaricare dal proprio browser il PDF dei Termini FTMO e mandarmelo (checklist, sezione 5, punto 0). E il solo documento che puo darci le regole vere su EA e conti multipli.
