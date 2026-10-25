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
