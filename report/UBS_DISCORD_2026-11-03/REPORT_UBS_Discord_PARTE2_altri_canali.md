# Report UBS – PARTE 2: tutti gli altri canali del server ForexEASolutions
Letto il 03/11/2026, in sola lettura: nessun messaggio, nessuna reazione, nessun download. Gli orari sono in UTC.
I numeri e le opinioni sono quelli scritti dagli utenti, non li ho verificati. "Non trovato" vuol dire che il dato non c'è nei messaggi letti.
La Parte 1 (top 16 di TurboCramper, share-your-performance, i 2 canali UBS, VPS, backtesting, manuali, plug-and-play) è nel file REPORT_UBS_Discord_ottobre2026.md.

## Copertura
| Canale | Periodo | Note |
|---|---|---|
| luna-ai | 02/10 → 03/11 | completo (~190 messaggi) |
| important-announcements | 01/10 → 03/11 | completo (7) |
| ea-update-notifications | 01/10 → 03/11 | completo (~20) |
| my-manual-ea-interventions | 01/10 → 03/11 | completo (1 messaggio) |
| links-to-ea-product-page | – | nessun messaggio da gennaio |
| daytrade-pro | 01/10 → 03/11 | completo (~45) |
| bitcoin-eas | 01/10 → 02/11 | completo (~100) |
| indicement-and-orb-master | 01/10 → 30/10 | completo (~35) |
| **all-gold-eas** | **solo 22/10 → 03/11** | **PARZIALE**: circa 1.700 messaggi in 12 giorni; letti i messaggi di Wim e quelli lunghi; **dal 1/10 al 21/10 non letto** |
| general-trade-talk | 01/10 → 02/11 | letti i messaggi di Wim e quelli lunghi (~200 su ~725) |
| newbies-corner | 01/10 → 02/11 | letti i messaggi di Wim e quelli lunghi (~70 su ~140) |
| usefull-tools | 01/10 → 02/11 | ~100 messaggi, quasi solo annunci di tool |
| broker-discussion | 01/10 → 03/11 | ~240 su ~370 |
| propfirm-discussion | 01/10 → 03/11 | ~120 su ~165 |
| manual-trade-discussion | 01/10 → 02/11 | ~30 lunghi su ~90; niente su UBS |
| **automated-support** | **solo 23/10 → 03/11** | **PARZIALE** (risposte del bot Digital_Wim) |
| karnek_questions | 01/10 → 31/10 | completo (6) |
| memes, chat non legata al trading | – | **non letti**, perché non pertinenti |

Non letti in nessun canale: immagini (tranne il top 16 della Parte 1), allegati e PDF.

## Cosa aggiunge al riepilogo della Parte 1
- **Licenze/conti:** un utente (SaidHamid, 12/10) scrive "10 licenses for each Expert Advisor" con il bundle. Un altro (KoSSaKi) dice che anche un conto demo conta come 1 licenza. **Conferma di Wim: non trovata.** Il limite esatto per i singoli EA comprati su MQL5: non trovato.
- **Versione UBS più recente citata:** 9.5 (29/10). Dal 17/10 OnlyUp si adegua da solo ai prelievi, ma **vanno aggiornati tutti gli EA che girano insieme**.
- **Come dividere il capitale secondo Wim (14/10):** circa 5K per conto con 4–5 EA, non tutti gli EA su un unico conto. Esempio: $1.500 con Reaper alto rischio + Scalp C; 5K con Reaper + DTP + Luna; 7K con 3 EA oro; 5K con il portafoglio UBS (44 o Xmas).
- **Backtest secondo Wim (19/10):** vanno scelte strategie che rendono in modo simile su 1M OHLC e su real tick. Se sui real tick vanno molto peggio, "bound to run bad on live".
- **Luna:** usare solo le 4 coppie raccomandate.
- **Oro:** con più EA oro insieme va ridotto il rischio di ciascuno (Wim). Per Gold Reaper con i settaggi di default 5k è meglio di 2k (Wim). Ottobre è stato il mese più laterale del 2026.
- **Avvisi nuovi:**
  - canali Telegram falsi t.me/forexeasolutions e t.me/forexeasolutions_fx (Wim, 23/10);
  - copie di Gold Reaper vendute su YouTube, Telegram e MQL5;
  - Vantage/VT: conti chiusi e profitti tolti a più utenti, e prelievi lenti a metà ottobre;
  - IC: problemi di server e di specifiche (TSLA, leva sull'oro);
  - TMGM riduce la leva il venerdì sera;
  - EA sulle prop firm: rischio ban;
  - set YOLO: conti piccoli bruciati in pochi giorni.

---

## #luna-ai
**Copertura:** dal 02/10 al 03/11/2026, circa 190 messaggi (dal 1/10 non c'è niente). Immagini non lette.

**Wim:**
- 12/10: il filtro news blocca solo le notizie che cadono entro le ore impostate. Una notizia 12 ore dopo "is not really that impactful". Chi vuole bloccarla deve aumentare HoursBeforeSessionStart (per esempio 15.5 ore per la notizia CAD del 9/10).
- 21/10: utenti diversi hanno un numero diverso di trade aperti per via del "different pricefeed" del broker. Max posizioni / max correlate: lui usa il default ("off").
- 29/10: **"only run the recommended pairs: euraud, audusd, gbpaud and audcad"**. Il grafico EURUSD M5 serve solo per lanciare l'EA in OneChartSetup.

**Cosa va bene e cosa va male (opinioni degli utenti):**
- Molti lo descrivono come stabile, con tante piccole vincite: Benny D (6 conti, rende meglio su Fusion che su IC, Black Bull, VT, Vantage e PU Prime), un utente 31 vittorie su 31 in 30 giorni sul live, RSFX (Vantage UK, lotsize step 200, conto £100k).
- Però ogni tanto fa una perdita grossa che si mangia settimane di profitti: Adebayo Ojo ("make… then give all back"), l'SL su AUDCAD del 9/10 (notizia CAD) e GBPAUD aperto dal 30/10, chiuso il 3/11 "not so different from full SL" (Rainy-, lotsize step 1500).
- idsme (30/10): lo SL è più di 5 volte il TP. È la "geometria" tipica di uno scalper notturno.
- Tony (5/10): con tutti gli EA di Wim su un conto, a settembre Daytrade Pro ha battuto ogni singolo EA oro. Però DTP da inizio anno è negativo (Adebayo).
- Coppie extra provate dagli utenti: EURGBP, USDCAD (RSFX), EURCHF e USDCHF in demo (spread alti). Sono fuori dalle 4 raccomandate.

**Problemi tecnici:**
- Saldo diverso da quello reale → è OnlyUp. Va disattivato oppure si usa "reset balance". Il valore si trova in Strumenti > Variabili globali (Indra P).
- Trade che non chiudono o non si aprono per lo spread notturno: è successo l'8/10 su Pepperstone, Vantage, BlackBull e Darwinex.
- Luna che tradava solo EURUSD: OneChartSetup non era su true (WDW808).
- Il filtro news per AUD è stato aggiornato da Wim (a.l.r., 9/10).
- Ora legale/invernale: secondo Josh Baker non serve nessuna modifica.
- Richiesta del 3/11 di una modalità con rischio in % del capitale e TP/SL variabili: risposta di Wim non trovata.

**Avvisi:** è uno scalper notturno e quindi molto sensibile allo spread e al broker. Lo SL è molto più grande del TP: più SL di fila possono cancellare mesi di profitti.

## #important-announcements (01/10 → 03/11, 7 messaggi di Wim)
- Ottobre è soprattutto marketing: testimonianze di clienti (Rosa +16% in un mese con Gold Reaper, Clen) e il **Big Beautiful Bundle** a −72% per 72 ore dal 12/10 al 15/10.
- **23/10 – AVVISO TRUFFA:** i canali Telegram t.me/forexeasolutions e t.me/forexeasolutions_fx **NON sono di Wim**. Usano il suo nome per truffe sugli investimenti. Wim chiede di segnalarli.

## #ea-update-notifications (01/10 → 03/11)
- 02/10: tutti gli EA Gold → correzione per i broker con orari di sessione strani, aggiunti i filtri news CPI e tassi d'interesse, migliorato il trailing SL/TP virtuale. UBS 7.9 → corretto un bug del filtro news con alcuni broker.
- 04/10: UBS 8.0 → nel journal compaiono le azioni del filtro news. UBS 8.1 → eliminato il falso avviso NFP.
- 10/10: **UBS 8.2** → ReverseTrades (solo per l'entrata su supporto/resistenza, spento di default), colonna Trades nel pannello dell'autoloader, distanze della griglia in pips.
- 14/10: Gold Reaper, Goldtrade Pro e Goldbot One → il filtro CPI e tassi usava date fisse invece del calendario MQL5, corretto. **UBS 8.3** → anche "Risk Per Trade" usa ora il saldo manuale o il saldo massimo (con OnlyUp).
- 15/10: UBS 8.4 → parametro "portfolio name" nell'autoloader, visibile nel pannello.
- 16/10: Goldtrade Pro 7.0 → corretto il filtro NFP.
- **17/10, aggiornamento importante per tutti gli EA principali:** dopo un prelievo OnlyUp aggiorna da solo il saldo massimo, quindi non serve più "Reset Highest Balance". **Vanno aggiornati TUTTI gli EA che girano insieme**, altrimenti una versione vecchia rimette il valore precedente.
- 19/10: Daytrade Pro 4.5 → migliorati EURJPY e GBPJPY.
- 25/10: UBS 8.6 → il "break and retest" ora funziona anche nell'autoloader. **UBS 8.61, solo MQL5** → corretto il problema di licenza.
- 27/10: UBS 9.0 → rilevamento GMT migliorato, calcolo dei lotti corretto quando la valuta del conto non è USD o i simboli hanno suffissi diversi, nuovo parametro Range Breakout "Only use Range Based SL/TP". **UBS 9.1** → corregge un bug della 9.0.
- 28/10: tutti gli EA che usano worldtimeserver → corretto il rilevamento GMT automatico. UBS 9.3 → corretto per i conti cent in USC.
- 29/10: **UBS 9.5** → corretto un possibile problema con l'ATR quando si usano i Variable Values. È l'ultima versione citata.

## #my-manual-ea-interventions
- 30/10, Wim: ha chiuso a mano alcuni trade oro in forte profitto sui conti "portfolio" perché il prezzo era su un supporto importante. I conti "monitor" restano intatti.

## #links-to-ea-product-page
- Nessun messaggio dal 1/10. Contiene solo un messaggio del 21/01/2026.

## #daytrade-pro (01/10 → 03/11, circa 45 messaggi)
- La 4.5 mostrava "4.4" nel pannello. Wim: "it's just an infopanel thing". Corretto nei file scaricabili il 21–22/10.
- Se il broker chiama l'oro XAUUSD ma le valute hanno il suffisso ".i" → togliere XAUUSD dalla lista e farlo girare a parte (Wim, 21/10).
- Wim (26/10): migliorati solo EURJPY e GBPJPY. **Sta lavorando a un aggiornamento di ORB.** ORB è fallito per "too much difference between live and backtests… slippage and spread… period for data is quite small".
- Utenti: DTP non ha guadagnato a ottobre (Tony, 30/10). Diversi lo hanno sostituito con altro (a.l.r., BiMo).

## #bitcoin-eas (01/10 → 03/11, circa 100 messaggi)
- tuviah (07/10): i set BTC fanno circa il 20% dei suoi profitti UBS da settembre. Usa Reaper 2 e 10, volatility H1_H e 2 set vecchi con SL aggressivo. Avverte che i backtest cambiano molto da broker a broker.
- BK (07/10): tutti i set BTC Reaper, +760 USD da aprile, broker TMGM. Giu: andava male su Fusion ed è passato a PU Prime.
- Wim (12/10): Bitcoin Reaper va bene su Vantage Raw (è un conto portfolio, non un segnale a parte). **Wim (02/11): "Bitcoin Scalp Pro is up +100% this year"**, con un grafico "roller coaster" (Crilosan).
- I set BTC di BK sono entrati nello zip UBS dal 14/10. La provenienza di UBSBTC_REV_H4 e SR_H4 è stata chiesta ma non trovata.

## #indicement-and-orb-master (01/10 → 03/11, circa 35 messaggi)
- Molti hanno abbandonato ORB e Indicement. Indicement è considerato "più stabile" di ORB (Jonathan). Su ORB akiva parla di un DD del 50%, oltre il massimo storico.
- Il segnale "ORB" di Wim ora usa "a new set of strategies I'm testing" (volatilità e range, Wim 21/10).
- Indicement va messo su EURUSD H1 con OneChartSetup: EURUSD è il simbolo con più tick (BK). idsme: il 2026 in forward è piatto rispetto al backtest.

## #all-gold-eas (tutte le terre auree)
**Copertura PARZIALE:** il canale è molto lungo (solo il 30/10 ha circa 800 messaggi). Mi sono fermato al limite di circa 1.700 messaggi, che coprono **dal 22/10 al 03/11/2026**. **Dal 1/10 al 21/10 non l'ho letto.** Di questi ho letto per intero tutti i messaggi di Wim e quelli lunghi (oltre 140 caratteri), circa 245 in tutto. I messaggi brevi li ho saltati.

**Wim:**
- 23/10: se usi più EA oro insieme devi ridurre il rischio di ciascuno. Con 1/4 del rischio a testa, la perdita complessiva è un "dip" simile a quello di lungo periodo.
- 25/10: la strategia 9 di Gold Reaper è disattivata di default. La "manual strategy selection" funziona solo se Trade Frequency = "use manual strategy selection". In Goldtrade Pro invece si usa.
- 26/10: per Gold Reaper con i settaggi di default **5k è meglio di 2k** (risposta "yes" a LFX). Goldtrade Pro "again doing very well this year". **La strategia 2 di Gold Reaper (daily) è quella che ha pesato di più sulle perdite recenti**, ma dal 2020 è "extremely solid".
- 27/10: "it's how you behave during drawdowns that will make the difference". "not yet time to YoLo".
- 30/10: "really bad fill on Goldbot One on ICMarkets". Livelli diversi tra utenti per via del "difference in pricefeed". Gli EA breakout dell'oro "can have super fast recovery with a good breakout or 2".
- 01/11: limitare il numero di strategie dentro l'EA lo considera una cattiva idea: "if you think the risk is too big, simply lower risk, not strategies". In alternativa si fanno girare meno strategie fisse. Andrew Soma (Somagold) non è d'accordo e usa un tetto alle strategie quando sono concentrate su uno stesso livello.
- 03/11: un'altra copia di Gold Reaper in vendita su MQL5 ("AiX EA").

**Risultati e perdite (utenti):**
- 22/10: giornata pesante su TGR (Gold Reaper). Mehdi −€2.374 su 2 conti, poi recuperati a mano (DanM lo avverte che è revenge trading). Rainy- a ottobre: EA Wim −16.23%, Somagold −5.49%, il suo EA −7.43%. Il 31/10 dice "for Wim I'm down 45K", circa 13–14%.
- 30/10: forte recupero. Russell +23% in un giorno (dopo una margin call), Robert più di 7k (circa 15%). Joel L è in profitto su tutti i broker.
- Ottobre secondo l'analisi postata da Лох (29–30/10): il range medio giornaliero dell'oro è sceso a $67.5 (contro $89–183 dei mesi prima). Nel 39% dei giorni il prezzo ha rotto un lato del range asiatico e poi è tornato indietro (11% normalmente). È stato il mese più laterale del 2026.
- Scalp C: secondo BK la minaccia più grande è "too many people running it". Mistermember lo ha visto partire con 100% di vincite e poi "decaying".

**Rischio (Josh Baker, 22–23/10):** metodo spiegato bene.
- Si fa un backtest a 0.01 lotti e si prende il drawdown di equity massimo.
- Lo si divide per il DD % che si vuole: il risultato è il conto minimo.
- Esempio: Gold Reaper conservative, DD $341 → con DD al 10% servono $3.410.
- Sui conti piccoli il lotto minimo fa salire il rischio reale oltre quello impostato.
- Consiglio: impostare la metà del DD che si vuole davvero.
- Con conti piccoli è meglio la modalità "extreme conservative".

**Broker:**
- IC Trading: secondo Jonathan ha troppo slippage per gli scalp ma è affidabile (prelievi, supporto). Per Лох ha problemi di liquidità e di server.
- Darwinex: "terrible gold slippage" (Лох).
- BlackBull: trailing peggiorato (un utente). Vantage è meglio, ma lo stesso utente dice di essere stato messo in blacklist.

**Avvisi:**
- Tutti gli EA oro (TGR, TGP, GTP, GBO) entrano su livelli simili. Usarli insieme a rischio pieno **moltiplica il drawdown**.
- Chiudere a mano altera le statistiche dell'EA. La community è divisa su questo.

## #general-trade-talk (discorso commerciale generale)
**Copertura:** dal 01/10 al 02/11/2026, circa 725 messaggi raccolti. Ho letto per intero i messaggi di Wim e quelli lunghi (oltre 150 caratteri), circa 200. Gli altri, brevi e spesso fuori tema, li ho saltati.

**Wim:**
- 01/10: il trailing "virtuale" va usato solo se il broker ti avvisa per iperattività. Altrimenti il trailing normale è meglio. Con il virtuale serve bassa latenza.
- 03/10: con il **tool Karnek** ricevi una notifica se MT5 si ferma. È importante sui conti grandi.
- 06/10: il filtro fake breakout chiude gli ordini solo se la candela chiude "bullish" per i sell, e sopra l'entrata (al contrario per i buy). Non prende tutti i falsi breakout.
- **14/10, come dividere il capitale:** non mettere tutti gli EA su un solo conto. Meglio diversi setup da 4–5 EA, circa 5K per conto, per un totale di circa 15–20K su 3–5 conti. Il suo esempio:
  - A) $1.500: Gold Reaper alto rischio + Gold Scalp C
  - B) 5K: Gold Reaper + Daytrade Pro + Luna
  - C) 7K: 3 EA Gold
  - D) 5K: portafoglio UBS (44-strat o Xmas)
- 15/10: sta costruendo una "UBS Optimizer app" per fare i backtest e creare portafogli. Il 22/10 dice che mostrerà anche la correlazione.
- **19/10, backtest:** "you don't want strategies that only run well on your own data… find strategies that don't depend on the best tick". Le curve su 1M OHLC e su real tick devono assomigliarsi: "anything that looks way worse on real ticks, is bound to run bad on live accounts".
- 19/10: i set file di Daytrade Pro non sono cambiati con la 4.5.
- 20/10: da qualche settimana scrive il codice "mostly" con l'AI.
- 22/10: le copie di Gold Reaper vendute su YouTube e Telegram sono "scammy copy", probabilmente decompilate.
- 24/10: conferma che il suo Myfxbook ufficiale è myfxbook.com/members/strueli. Ha aperto Discord solo per i clienti verificati perché MQL5 non si può moderare.
- 25/10: "UBS… it's my best EA".
- 31/10: il problema chiesto da JOHN si presenta solo nel backtest, quando non sono ancora caricate tutte le candele.

**Utenti:**
- Gabriel007 (02/10): su ForexVPS MT5 si è chiuso durante l'NFP. I pending non sono stati cancellati e ha perso **circa il 12% del portafoglio**. Consiglio: controllare che il terminale sia attivo e avere notifiche.
- Tony (01/10): **se ricarichi il conto** non serve toccare nulla. **Se prelevi**, cancella i pending e lascia che l'EA li rigeneri, altrimenti rischi una margin call.
- **Set YOLO (Gold Reaper ad altissimo rischio):** markushka99 da $1.400 è sceso a $691 in una settimana. Rudolf I. da 1.000 a 380 sul live, e sul demo da 1.000 a 1.900 e poi a 550. Gli YOLO da 1k di Rudolf sono "gone" in 2 settimane.
- Jeremy (12/10): ha condiviso il portafoglio UBS "5 GOLD SET" che dice di aver preso da Tran (PF circa 2.5 per lui). Secondo maindfriik i set "don't look too original".
- Rainy- (15/10): **"don't trade prop account with EA"** (rischio di ban). Esempio di portafoglio: Gold Reaper 20% max DD, Goldbot One e Goldtrade Pro all'1% per strategia, Gold Phantom 20%, Luna con lotsizestep 1000. Dati per i backtest: Pepperstone (oro con real tick dal 2018) e MetaQuotes fino al 2014.
- Set "3gold/4gold": si usa 3gold se fai girare 3 EA oro sullo stesso conto, 4gold se ne usi 4 (Adebayo Ojo, è la sua interpretazione).
- pipraider (12/10): Gold Reaper fa profitto su IC Markets (latenza 2 ms) e va in leggera perdita su Darwinex (70 ms). Goldtrade Pro invece rende in modo simile su entrambi.
- Mistermember: tool per simulare le condizioni del broker sui backtest (Strategy Ledger Pro, a pagamento).
- Gaetan: backtest di Gold Reaper 2020–2026 da 5k a più di 555k. **È un backtest, non un risultato live.** Mistermember avverte che lo slippage reale può ridurre enormemente risultati simili.

**Avvisi:**
- Copie di EA e set rivenduti (Tran, copie di Reaper su YouTube e Telegram).
- Canali Telegram falsi (vedi #important-announcements).
- I set YOLO bruciano i conti piccoli in pochi giorni.
- Gli EA sui conti prop firm sono considerati rischiosi per il ban.

## #newbies-corner (angolo dei principianti)
**Copertura:** dal 01/10 al 02/11/2026, circa 140 messaggi. Ho letto per intero quelli di Wim e quelli lunghi (circa 70, con molte risposte del bot Digital_Wim).

**Wim:**
- 01/10: con UBS e un conto da 1.000, un rischio del 5% per strategia "seems no issue" con 5 set. Con 40 set "will be a bit tough".
- 07/10: con lo slippage lo **SL si sposta solo se la nuova distanza è più grande** di quella prevista. Il TP invece no.
- 19/10: i set Bitcoin Scalp nel Portfolio C "I was running those in the past. removed now". Ha aggiornato lo zip AllSetsAndManuals.
- 28/10: l'errore "GMT offset" dipende dal sito worldtimeserver, e lo sta correggendo in tutti gli EA. Agli EA oro non serve l'ora GMT.
- 31/10: **i parametri di distanza di UBS (Exit_stop, trailing ecc.) sono tutti in PIPS.**

**Licenze (LIMITE CONTI):**
- SaidHamid (12/10) scrive che il Big/Gold Bundle dà **"10 licenses for each Expert Advisor"**. Un altro utente (KoSSaKi) risponde che **anche un conto demo conta come 1 licenza**.
- **Conferma ufficiale di Wim: non trovata.** Sono affermazioni di utenti.

**Digital_Wim (bot AI, non è Wim; risposte prese dai documenti):**
- Gold Reaper: il saldo minimo indicato è $600, "on the low side". Il DD storico in extreme conservative è circa $350 a 0.01 lotti. **Sotto circa $5.000 i documenti consigliano un conto cent.** Set conservativi: gold_reaper_propfirm.set (Moderate, MaxAllowedDD 9, PropFirmMaxDailyDD 4) e gold_reaper_10%maxrisk.set.
- **AdjustLotsizeToVariableValues e Weighted Lotsize vanno lasciati attivi**, altrimenti il rischio reale sale molto (soprattutto con l'oro ai prezzi attuali).
- Luna: le uniche coppie ufficiali sono 4. Le altre 16 interne "underperformed in live". Valori conservativi: LotsizeStep 400, OnlyUp true, filtro news e FilterHighRisk attivi.
- I file "optimization.set" sono modelli per creare strategie nel tester, **non set da usare nel live**.
- Il bot a volte sbaglia. Per esempio Logan.Dale lo corregge sui profili MT5 e spiega come aggiornare gli EA senza perdere i grafici: si crea un profilo vuoto "UPDATE", si aggiorna lì e poi si ricarica il profilo con i grafici.

**Problemi:**
- Un portafoglio UBS di 25 set (XAG e XTI) impiega circa 10 minuti a caricarsi (Claus, 02/11). Risposta di Wim non trovata.
- Kumar (25/10): chiede un file README per ogni set (DD, saldo minimo, backtest). Non esiste.
- Broker UE con lotto minimo 1.0 e leva 1:20: il dimensionamento automatico non funziona bene (Jebediah).

## #broker-discussion
**Copertura:** dal 01/10 al 03/11/2026, circa 370 messaggi. Ho letto quelli di Wim e quelli oltre 90 caratteri, circa 240. In questo periodo Wim non ha scritto nel canale.

**Vantage / VT Markets (stesso gruppo, secondo Eugen):**
- Esecuzione considerata tra le migliori (Eugen la mette al n.1 per esecuzione; 3372 e Jorge la usano come primo broker; Jorge dice che ha lo slippage più basso dei suoi 3 broker).
- **MA:** Micha9886 (18/10) racconta che gli hanno chiuso il conto e tolto tutti i profitti con l'accusa di aver sfruttato i gap usando uno scalper notturno. Wim li ha contattati senza avere spiegazioni. Dieter dice che gli è successo lo stesso. Joel L dice che VT Markets gli ha "rubato" i soldi e Vantage gli ha bloccato i conti.
- Andrew Soma: Vantage lavora in "b-book", per questo l'esecuzione è migliore.
- Da metà ottobre i prelievi sono più lenti: da 15 minuti a 24–48 ore. Comunicato di Vantage del 23/10 sui ritardi. Il 30/10 risultano sistemati (Eugen).
- olegfusion (23/10): Vantage gli ha cambiato la password dicendo che inviava troppi ordini.
- maindfriik (26–27/10): dopo un reclamo formale è stato rimborsato per lo slippage del 24–25 agosto.

**IC Markets / IC Trading:**
- Slippage molto diverso a seconda del server. Il server 4 di IC Trading è considerato pessimo e il server non si può cambiare (Charlie B, Maurice).
- 22/10: TSLA.NAS su ICMarketsSC-MT5-3 aveva specifiche sbagliate, le chiusure fallivano e lo SL spariva. Andrew Soma: IC ha tolto la leva sull'oro su un server e lui si è ritrovato un debito di 4k, poi annullato come "glitch" il 23/10.
- Andrew Soma: IC lavora in "A book" sui conti raw, quindi esecuzione peggiore ma mercato reale. PandaSMTH lo usa da più di 7 anni senza problemi seri. Per altri ha ordini di chiusura rifiutati e problemi di server.

**BlackBull:**
- Su Scalp C rende peggio di VT, Vantage e PU Prime pur avendo il ping più basso (0.94 ms; Benny D, 06/10).
- Un trade di Luna chiuso senza motivo apparente (Benny D, 08/10).
- Rudolf I. lo ha fermato.

**Altri:**
- TMGM: buono per l'oro (langesi, Russell). **Dal 31/10 un'ora prima della chiusura del venerdì riduce la leva (oro 1:50)**: un motivo in più per chiudere i pending il venerdì (malek).
- Tickmill: "trust #1" (Eugen). Per Scalp C funzionano solo Vantage e TMGM (Eugen).
- RoboForex: "complete shambles" (Rudolf I.), Scalp C non funziona.
- Pepperstone: prelievi ok (Bruce8).
- StarTrader: conti bloccati e guadagni confiscati (Jonathan, che ha fatto reclamo alla Financial Commission).
- ECMarkets: recensioni pessime.
- Ultima: "quite allright".
- FxPro: conto chiuso senza spiegazione (JR).
- Clienti USA: MT5 non disponibile (JOHN).

**Bonus del broker** (per esempio il 150% di Vantage): è credito, non saldo prelevabile. Aiuta a reggere il drawdown (con UseEquity=true), ma molti consigliano di rifiutarlo.

**Rebate:** paybackfx.com funziona secondo Mistermember, PandaSMTH e malek.

## #usefull-tools
**Copertura:** dal 01/10 al 02/11/2026, circa 100 messaggi. Sono quasi tutti annunci di tool di terze parti fatti da utenti, non da Wim.
- **Karnek** (link di referral di Wim, 07/10): ti avvisa se la VPS o MT5 si fermano.
- FX Live (Jonathan): Setfile Editor (avvisa sui magic number duplicati, cambia i simboli per broker), Portfolio Lab (confronto live/backtest/segnali), **manuale UBS online fxlive.trading/ubs-manual.php "shared with Wim's approval"** (aggiornato alla 8.2), calendario economico.
- Strategy Ledger Pro (Mistermember, a pagamento su MQL5): confronto backtest/live e simulazioni. Lo strumento gratuito si chiama ora "EA Scorecard".
- BK: "Friday Pending Order Cleaner", gratuito, cancella i pending il venerdì.
- tuviah: MagicNotifier (notifiche solo per apertura e chiusura).
- Tom: contatore dei pending (per i limiti del broker). Multydrew: KONTROL_01 (a pagamento).
- JOHN: Autologon di Microsoft, per far ripartire la VPS con il login automatico.
- Josh Baker: plugin AI per UBS v9.
- setregistry.caplysis.com: archivio di set della community.
- **Avviso:** sono tutti strumenti non ufficiali, alcuni a pagamento. I file .ex5 vanno usati con cautela.

## #propfirm-discussion
**Copertura:** dal 01/10 al 03/11/2026, circa 165 messaggi. Ho letto quelli di Wim e quelli lunghi, circa 120.

**Wim:**
- 04/10: con le prop firm attivare i filtri news CPI e tassi "might be the safer option".
- 10/10: i set "combo3 gold prop firm" di Gold Reaper e Gold Phantom sono fatti apposta per quell'uso ("that's what they are there for").
- 11/10: la randomizzazione serve solo a "make trades look different". Se la prop firm non vieta le strategie copiate, si può spegnere.

**Utenti:**
- Molti sconsigliano gli EA sulle prop firm: rischio ban per "toxic trading" o iperattività (FTMO, The5ers, FundedNext con la regola dei 30 secondi). Eugen: "No EA! Trade yourself or forget about prop firms".
- Josh Baker: sulle prop usa conservative / very conservative con max DD 2.5–5%. Consiglia meno strategie, randomizzazione, niente news e strategie a rotazione.
- iFunds: CHANDAN SAWLANI lo usa con i set prop di Wim (randomizzazione spenta), split 50%, DD statico 10%. Payout regolari fino a ottobre, poi in drawdown. Altri lo considerano poco conveniente (prelievi limitati al 50%).
- Segnalate come problematiche o truffe: The Trading Pit (payout bloccato, betty7138), Cashed, FundedNext (Eugen).
- Slippage più basso per BK: TMGM, Eightcap, BlackBull e Fusion. maindfriik ha escluso PU Prime e Fusion su Scalp C ("blew 40%").

## #manual-trade-discussion
**Copertura:** dal 01/10 al 02/11, circa 90 messaggi. Parla di trading manuale e di algoritmi personali degli utenti (per esempio la griglia mean-reversion sull'oro di Лох). **Niente su UBS.**

## #automated-support (bot Digital_Wim)
**Copertura PARZIALE:** solo dal 23/10 al 03/11 (circa 270 messaggi, quasi tutti risposte lunghe del bot). **Dal 1/10 al 22/10 non l'ho letto.** Ho letto le domande degli utenti e le risposte di Wim, non tutte le risposte del bot.

**Wim:**
- 24/10: cambiare OnlyUp **non modifica i pending già piazzati**. Bisogna riavviare l'EA, che rimuove i vecchi pending se serve.
- 25/10: licenza non valida con UBS 8.6 comprato su MQL5 → "fixing it now", risolto nella 8.61.
- 28/10: usare più grafici con configurazioni e rischi diversi è "a good idea… if you did your homework on each one".
- 29/10: "Risk per trade $" funziona solo se "Lotsize Calculation method" è impostato su "use Risk Per Trade in $/€".
- 30/10: se l'EA non mostra i lotti, le cause sono simbolo sbagliato, accesso con password investor o algotrading disattivato.
- 31/10: le distanze sono in pips, e i valori frazionari sono ammessi.

**Bot e utenti:**
- Warning UBS del tipo "wants 0.0259 lots… broker minimum 0.1 → will risk about 3.9x its share": il lotto minimo del broker aumenta il rischio reale di quel mercato.
- Se cambia la contract size tra broker (per esempio NAS100 su Pepperstone vs TMGM), il "historical max DD" va rifatto con un backtest su quel broker.
- I codici Risk (123 = MaxRiskPerStrategy, 9999 = LotPerBalance) li riporta un utente (Mr.B). Un elenco completo non l'ho trovato.

## #karnek_questions
- 22/10: Karnek (monitoraggio di MT5 e VPS, a pagamento, di jamie s) è ora sull'App Store e su Google Play. Wim ringrazia. Su iOS a volte compare una schermata bianca, problema noto.
- Ha aggiunto un'analisi dello slippage (Robert, 23/10).


_Non è consulenza finanziaria: è un riassunto della chat._
