# Preset / set per prop firm degli 8 EA del test a fondo 80K (25/10/2026)
**Natura: LETTURA di fonti pubbliche. Tutto e DICHIARATO dal venditore**, non misurato da noi; le pagine sono state lette con uno strumento che le riassume (puo omettere parti), quindi "non menzionato" vale "non risulta nel riassunto", non "non esiste". Pagine non trovate dalla ricerca: **NON TROVATO**.

## Dagli input letti nei nostri report (VERIFICATO, sono gli input reali dell'EA)
| EA | Protezione di tipo prop DENTRO l'EA | Valore di default |
|---|---|---|
| Microedge Neural Matrix | `propGuard`, `maxDD_daily`, `maxDD_total` | **spenta** (false); 5,0% giornaliero e 10,0% totale se accesa |
| Umbra Vault AI | `EquityGuardEnabled`, `MaxDailyDrawdown`, `MaxTotalDrawdown` | **spenta**; 5,0% e 10,0% se accesa |
| Gold Snap | `InpMaxDD` | 0,0 (disattivo); `InpRiskPct=2,0` con `InpLotMethod=7` |
| SixtyNine | `MaxDrawdown` | 0,0 (disattivo); `LotsMode=0`, `Lots=0,01`, `Risk=1,0` (le tre modalita di lotto sono nella pagina) |
| ORB Revolution | `InpDD_Enabled` | false |
| Rocket Breakout, Vortex Turbo, Entry Points Pro | nessun input di protezione trovato | - |

## Dalle pagine del Market (DICHIARATO)
- **Microedge** (prodotto 187618, Peter Robert Grange): XAUUSD H1; nessun set ne preset ne prop firm nel riassunto; "risk profile adjustable through the available system settings".
- **SixtyNine** (180784, Farzad Saadatinia): "file set personalizzati disponibili" per dimensione conto e livello di rischio; "profili di rischio per challenge disponibili"; nessuna parola su prop firm o FTMO; deposito consigliato 1.000+; live a lotto fisso 0,02 su 500 USD; nessun input di DD massimo descritto. I set non sono pubblici: vanno chiesti al venditore.
- **Entry Points Pro Robot** (185186, Yury Orlov): nessun set o preset prop. Il suo risultato di punta usa **`PortfolioMode=true` e `RiskPercent=5`** (piu prudente 1-3%, la scala e nella guida dopo l'acquisto), 5 simboli (XAUUSD, XAGUSD, USDJPY, BTCUSD, DE40), DD equity massimo dichiarato 26,8%. **Noi l'abbiamo provato con `PortfolioMode=false` (default) solo sull'oro: non e la configurazione del venditore.**
- **Vortex Turbo** (155496, Stanislav Tomilov): profili di rischio predefiniti (conservative, balanced, aggressive), nessun set file ne prop firm; **il venditore scrive "controlled martingale and averaging grid"** e ne parla come "limited and fully protected". La nostra regola S-NOSCALA esclude martingala/griglia: coerente con il profilo da coda visto (19 mesi piccoli, poi -11.244 e -26.780).
- **Gold Snap, Umbra Vault, Rocket Breakout, ORB Revolution**: pagina **NON TROVATA** dalla ricerca (nomi non riconosciuti). Per Gold Snap il triage del 20/10 scriveva "preset non pubblici" (DICHIARATO da un agente, non riverificato).

## Cosa serve da Claudio
Le pagine (o i set) di Gold Snap, Umbra Vault, Rocket Breakout e ORB Revolution, e per SixtyNine e Entry Points la richiesta dei set/guida al venditore. Taglie e lotti restano decisioni sue.

## Aggiunta del 25/10 sera: Umbra Vault AI EA (prodotto 189730), da screenshot "Cosa c'e di nuovo" di Claudio + pagina
DICHIARATO dal venditore (Valentina Zhuchkova). Prezzo 299 USD o 199 USD al mese; pubblicato 18/08/2026; versione attuale 1.2; demo scaricata 190 volte; recensioni 2, commenti 4.
- **v1.2 (13/10/2026):** "il problema della licenza e' stato risolto". **v1.1 (10/10/2026):** nuovo filtro orario (`trading_hours=false`, `trade_hours=21`, `trade_hour=23`, ora del SERVER; con `true` blocca le nuove posizioni dalle 21 alle 23): **gli stessi tre input e gli stessi valori li abbiamo letti nei nostri referti (VERIFICATO)**, quindi la demo testata e' almeno la 1.1. Il file `.ex5` testato e' datato 22/10 (dopo la 1.2): probabilmente la 1.2, ma la versione non sta nel file (INFERITO).
- **v1.1: "Ri-ottimizzazione dell'EA"** - il venditore ha ri-ottimizzato i parametri: i default che abbiamo provato sono quindi ottimizzati dal venditore, su un periodo che non dichiara (la pagina "non fa nessuna affermazione sull'ottimizzazione"). I nostri 21 mesi possono essere in parte in-sample: motivo in piu per leggere con cautela il +195.101 senza guardia.
- Pagina: XAUUSD, "da conservative ad aggressive", "nessuna martingala, griglia o mediazione", backtest 2020-oggi con tick reali (dichiarato), segnale live collegato; **nessun set file, nessun preset, nessuna parola su prop firm o FTMO**. Il titolo del prodotto e' "Umbra Vault AI EA" ma il testo parla di "KineticEdge Vault EA" (l'immagine dice KineticEdge Vault EA): il venditore non spiega.
