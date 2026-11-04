# UBS / ForexEASolutions – Analisi completa del Discord (01/10 → 03/11/2026)
Lettura fatta il 03/11/2026, in SOLA LETTURA: nessun messaggio, nessuna reazione, nessun download.
Gli orari sono in UTC, salvo dove indicato. I numeri sono quelli pubblicati dagli utenti o da Wim: non li ho verificati.
Non è consulenza finanziaria.

## File dello ZIP
| File | Contenuto |
|---|---|
| REPORT_UBS_Discord_ottobre2026.md | Parte 1: top 16 di TurboCramper, share-your-performance, chat e file set UBS, VPS, backtesting, manuali, plug-and-play |
| top16_ubs_sets_TurboCramper.csv | Tabella dei 16 set (foglio di calcolo) |
| REPORT_UBS_Discord_PARTE2_altri_canali.md | Parte 2: riassunto di tutti gli altri canali (primo giro) |
| dettaglio/all-gold-eas.md | Testo completo di #all-gold-eas (5.930 messaggi) + 20 immagini |
| dettaglio/gold_images_01-17ott.md | Immagini di all-gold-eas, 01–17/10 (circa 150) |
| dettaglio/gold_images_18ott-03nov.md | Immagini di all-gold-eas, 18/10–03/11 (circa 138) |
| dettaglio/immagini_performance_ubs.md | Immagini e allegati di share-your-performance, chat UBS, luna-ai, bitcoin, daytrade-pro, indicement/ORB |
| dettaglio/immagini_round2.md | Immagini rimaste: chat UBS, luna, backtesting, usefull-tools, ea-update-notifications, annunci |
| dettaglio/support_general_newbies.md | Testo completo di automated-support, general-trade-talk e newbies-corner |
| dettaglio/support_round2.md | Le 578 risposte del bot lette per intero + immagini di support e general |
| dettaglio/broker_prop_tools_files.md | Broker, prop firm, tool, trading manuale, immagini VPS/backtesting, CATALOGO FILE UFFICIALI |
| dettaglio/_notes_*.md | Note grezze per canale |

## Copertura finale
- **Testo:** 100% di tutti i canali dal 01/10 al 03/11/2026. Esclusi solo i canali memes e chat non legata al trading.
- **Immagini:** analizzate tutte le immagini di trading.
  - Saltate: GIF, meme, anteprime di link esterni (che non si possono aprire), duplicati e foto personali.
  - Poche immagini illeggibili o che non si caricavano: sono indicate nei singoli file.
- **Allegati:** elencati tutti, nessuno scaricato. Il catalogo dei file ufficiali di Wim è in dettaglio/broker_prop_tools_files.md.
- **Video:** non guardati (4).

## Riepilogo finale

### 1. Cosa sono i set e come si sceglie
- UBS è un EA "scatola nera" per i breakout. Ogni file .set è una strategia; nello zip ufficiale ce ne sono circa 300.
- L'ultimo pacchetto è **UPDATED SETS UBS_V9.0.zip** (27/10, 5,58 MB). Contiene, tra l'altro:
  - il portafoglio live "44 strategie" (il 26/10 Wim ha tolto BTC H1_F);
  - il portafoglio Christmas (Xmas), fatto di set della community, con la v3 ribilanciata di Till;
  - i set delle strategie dei singoli EA (Gold Reaper, Phantom, GTP, GBO, DTP);
  - i set Scalp A/B/C;
  - i set dei clienti (BK, Basa, Till…).
- Wim: **non esiste un "set migliore"**. Il metodo che indica:
  1. scegliere strategie non correlate (mercati e timeframe diversi);
  2. caricarle con l'AutoLoader;
  3. usare Max Risk per Strategy fisso, così l'EA le bilancia.
- Wim (19/10): tenere le strategie che danno curve simili su 1M OHLC e su real tick. Se sui real tick vanno molto peggio, andranno male anche dal vivo.
- I file "optimization.set" servono a creare strategie nel tester. **Non vanno usati dal vivo.**

### 2. Rischio e correlazione secondo Wim e la KB
- **Lotto fisso:** tutti i set arrivano a lotto fisso (oro 0,1). Il rischio lo decide il cliente.
- **Max Risk per Strategy:** si basa sul "max historical DD a 0,01 lotti", da rifare con un backtest se cambi broker o contract size.
  - Formula: lotti = 0,01 × Balance / LotsizeStep, con LotsizeStep = DD a 0,01 ÷ DD% desiderato.
  - Valori indicativi: 3 basso, 6 medio, 10 alto. Sul portafoglio da 44 non oltre 6. Wim (21/10): "per ora 3% per strategia".
- **Più EA oro insieme:** ridurre il rischio di ciascuno (con 4 EA, 1/4 ciascuno). Non far girare insieme i gold EA e i set UBS che li ricreano.
- **Struttura dei conti (Wim 14/10):** 3–5 conti da circa 5K con 4–5 EA ciascuno, non tutti gli EA su un unico conto.
- **Gold Reaper:**
  - DD per strategia a 0,01: S1 60, S2 30, S3 35, S4 52, S5 110, S6 140, S7 90, S8 130, S9 700 $. La S9 è disattivata di default e sconsigliata.
  - Il segnale di Wim usa Moderate con Max DD 30%. Saldo: 600 $ minimo, 2k ok, 5k meglio (Wim 26/10). Sotto 5k i documenti consigliano un conto cent.
- **AdjustLotsizeToVariableValues e Weighted Lots:** lasciarli attivi.
- **OnlyUp:**
  - attivo sui conti personali, spento sulle prop;
  - dal 17/10 si adegua da solo ai prelievi, ma vanno aggiornati tutti gli EA che girano insieme;
  - non passare da demo a live con OnlyUp attivo.
- **Scalp C:** LotsizeStep 80 è alto rischio, 120 è quello attuale di Wim, 300 basso, 1000 per le prop.
- **Distanze UBS:** tutte in pips, anche con decimali.

### 3. Licenze e conti
- **10 slot conto per EA** se acquistato dal sito, modificabili dalla dashboard (tradewithwim.com/manageaccounts). **Anche un conto demo occupa uno slot.** Lo dicono la FAQ citata dal bot e alcuni utenti; una conferma scritta di Wim non c'è.
- Il portale a volte mostra 20 slot: il motivo non è chiaro.
- Acquisto su MQL5: il campo licenza va lasciato vuoto. Il limite di attivazioni MQL5 non viene mai citato nel periodo (non trovato).
- Sulla VPS MQL5 l'AutoLoader non funziona; dopo ogni update bisogna rifare la migrazione.
- **Errori di licenza:**
  - v8.1 dal sito: risolto riscaricando il file;
  - v8.6 da MQL5: corretto nella 8.61;
  - altrimenti mancano gli URL WebRequest (forexeasolutions.com/.org/.services).

### 4. Problemi con AutoLoader e VPS
- Mettere i set in Common\Files. Il ForceSymbol deve essere identico al simbolo del broker in ogni set.
- Ogni cartella corrisponde a un OneChartSetup. Massimo consigliato circa 50 set per grafico.
- Con "Override Autoload Lotsize" = true il metodo di rischio è unico per tutto il portafoglio; con false ogni set usa il proprio.
- Le pending già piazzate non cambiano quando modifichi le impostazioni: vanno cancellate e l'EA ricaricato.
- Bug segnalati: EntryModel 2 (break & retest) nell'autoloader, corretto nella 8.6; "lotsperbalance=inf"; lotto bloccato a 0,01 nella 9.1/9.2; 25 set che impiegano 10 minuti a caricarsi.
- **VPS:**
  - meglio CPU dedicata vicino al broker;
  - ForexVPS: chiusure di MT5 (anche durante l'NFP, perdita del 12%);
  - Contabo: fermo il 19/10;
  - Hyonix e ChartVPS sono i più lodati;
  - Wim non usa la VPS MQL5;
  - Karnek (consigliato da Wim) avvisa se MT5 si ferma.

### 5. Risultati forward principali
Il dettaglio con data e autore è nei file.
- Ottobre 2026 è stato il mese più laterale dell'anno: range medio dell'oro 67,5 $; nel 39% dei giorni la rottura del range asiatico è fallita.
- Quattro grandi falsi breakout: 02/10, 06/10, 22/10, 30/10.
- **Perdite di ottobre:**
  - Rainy- da 357K a 253K;
  - langesi fino a −170k nel mese;
  - JOHN −20%;
  - malek −26%;
  - Tom −39,8%;
  - Eugen −39%;
  - il conto yolo del cliente "400 $ → 130k" è sceso del 76%.
- **Wim:** portafoglio da 740K a 695K. Il segnale Gold Reaper a ottobre è circa −0,5% (+90% nel 2026). Goldtrade Pro +76,7% nel 2026.
- **Scalp C:** forte ad agosto, poi l'edge cala.
  - Vantage rende solo il 49% del backtest per via dello slippage, TMGM l'89%.
  - Lo stesso trade su broker diversi ha esiti opposti.
- **UBS Christmas** (Mistermember, Vantage): +7.174 $ dal 05/08. **I 44 set di default** rendono poco o sono in leggera perdita.
- **Recupero del 30–31/10:** Isak +6.455, Russell +23% in un giorno, Mr.B +78% a ottobre.

### 6. Avvisi
- **Canali Telegram FALSI:** t.me/forexeasolutions e t.me/forexeasolutions_fx (Wim 23/10). Gli unici veri sono il gruppo UBS (link solo da Wim) e t.me/ProForexAlgos.
- Il caso "Huy Tran/HBT": EA e set copiati da UBS, DTP e Pulse; risultati falsi. Altre copie di Gold Reaper circolano su YouTube, Telegram e MQL5 (AiX).
- **Broker:**
  - Vantage/VT: conti chiusi e profitti tolti ad alcuni utenti; prelievi lenti a metà ottobre (poi risolti). Esecuzione comunque tra le migliori.
  - IC: server 4 pessimo, errori di specifica su TSLA e sulla leva dell'oro.
  - TMGM: riduce la leva il venerdì sera.
  - Bybit: profitti negati.
- **Prop firm:** con gli EA c'è rischio ban; molte prop sono segnalate come inaffidabili.
- **Rischi alti:** set YOLO (204% DD), lotti alti sui conti piccoli, lotto minimo 1.0 su alcuni broker UE: bruciano i conti.
- **Credenziali:** l'08/10 e il 06/10 alcuni utenti hanno pubblicato credenziali di conti. Non sono riportate.

## File ufficiali di Wim più recenti (NON scaricati: vedi il catalogo completo)
- UPDATED SETS UBS_V9.0.zip – 27/10/2026 – 5,58 MB – canale "sistema di breakout definitivo" (file set)
- AllSetsAndManuals.zip / "Tutti i set e i manuali.zip" – 19/10/2026 – 2,92 MB – "facile da usare"
- UBS_Manual_V8_3.pdf – 25/10/2026 – 1,55 MB – chat UBS
- Gold Reaper.zip (backtest fatti con UBS) – 27/10/2026 – 4,83 MB – backtesting-discussion
- Profalgo-Client-FAQ_2026-10-10.pdf – 344 KB – manuali del prodotto
