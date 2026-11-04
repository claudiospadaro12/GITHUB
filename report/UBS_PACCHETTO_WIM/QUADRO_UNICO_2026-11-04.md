# Quadro unico — pacchetto Wim (9 EA, 85 set) — 04/11/2026
Basato solo su manuali e set (schede in questa cartella). **Nessun test eseguito**: tutto ciò che segue sul comportamento è lettura, non misura.

## Inventario
| EA | Tipo | Strumenti | TF | Set | Scheda |
|---|---|---|---|---|---|
| Apex Trader | griglia | AUDCAD, AUDNZD, NZDCAD | M15 | 5 | APEX |
| Stability Pro | griglia (SVG) | AUDCAD, AUDNZD, NZDCAD | M5 | 3 | STABILITY_PRO |
| Luna AI Pro | scalper notturno mean reversion | EURAUD, GBPAUD, AUDCAD, AUDUSD | M5 | 3 | LUNA |
| Daytrade Pro | price action su S/R giornalieri | 12 forex + XAUUSD | D1 | 4 | DAYTRADE_PRO |
| Bitcoin Scalp Pro | breakout | BTC | H1 | 3 | BITCOIN_SCALP_PRO |
| Bitcoin Reaper | breakout (10 strategie) | BTC | H1 | 4 | BITCOIN_REAPER |
| ORB Master | opening range breakout (12 var.) | US500, US30, Nasdaq (DAX non nei set) | M15 | 7 | ORB_MASTER |
| Indicement | breakout/ORB (14 strategie) | US500, US30, Nasdaq | H1 | 6 | INDICEMENT |
| Ultimate Breakout System | costruttore di strategie (3 modelli) | 50 set: oro 14, Tesla 14, US30 7, USDJPY 7, argento 3, DE40 2, petrolio 2 | vari | 50 | UBS |

## Cluster di correlazione attesa (ipotesi, da misurare)
1. **Cross AUD/NZD/CAD**: Apex, Stability Pro, Luna (+ le coppie AUD di Daytrade Pro). Stesse coppie, meccaniche diverse.
2. **Bitcoin**: Bitcoin Scalp Pro, Bitcoin Reaper.
3. **Indici USA**: ORB Master, Indicement (+ US30/DE40/Tesla di UBS).
4. **Forex giornaliero**: Daytrade Pro (+ USDJPY di UBS), con blocco yen e blocco AUD interni.
5. **Metalli**: 17 set UBS su oro/argento (+ XAUUSD in Daytrade Pro) = la stessa famiglia del nostro trio.
Diversificano davvero rispetto all'oro (attese): Daytrade Pro (senza oro), Bitcoin, gli indici USA, Luna/AUD, UBS su Tesla/US30/petrolio/USDJPY/DE40.

## Rischi trasversali
- **Griglie** (Apex, Stability Pro): la coda, non il profit factor; set "extreme" quasi martingala; killswitch tarato sul passato.
- **Orari**: BCM è GMT+1 fisso. Luna (23:00–01:00 GMT+2 DST), ORB Master/Indicement (apertura USA) e UBS sui set con orari richiedono la conversione; `AutoGMT` non funziona nel tester (Luna). Storico `_EXT` indici: eccezione in CLAUDE.md.
- **Dimensionamento**: molti EA calcolano il lotto dal drawdown storico dentro l'`.ex5`; se sottostimato, lotti sovrastimati. Taglie e rischio le decidi tu: io riporto drawdown in % e in $ a lotto fisso.
- **Licenza**: tutti richiedono URL consentiti in MT5; non so se girano nel tester/demo/FTMO/VPS finché non si prova.
- **Prop firm**: più EA hanno un DD giornaliero del 4% come il Guardian (4,3%): possibili doppi blocchi. La "randomizzazione" anti-copy-trading non va usata per aggirare controlli: prima leggere le regole di FTMO.
- **Frasi di marketing da poter smentire**: «profittevole in ogni mese dal 2007» (Stability Pro), «nessuna martingala», «non sensibile a spread», DD 9/20/50% (Daytrade Pro), «verificato live» (Luna).

## Cosa misurare in ogni test (stessi criteri per tutti, congelati prima)
PF; DD massimo in % e in giorni; peggior giorno e peggiore sequenza; tempo di recupero; n. trade/anno; risultati per anno e per regime; sensibilità a spread/slippage (×1,5, ×2); lotto fisso minimo per confrontare; periodo di scelta e periodo separato; correlazione dei P&L giornalieri con Reaper/Goldbot/Phantom/GTP e tra gli EA del pacchetto; peggior giorno combinato col Guardian (come per il GTP).

## Ordine di test proposto (decidi tu)
1. **Daytrade Pro** (diversificatore più pulito, D1, test veloci).
2. **Bitcoin Reaper e Bitcoin Scalp Pro** (dopo aver verificato BTC su BCM/FTMO: dati, spread, orari).
3. **UBS non-metallo** (Tesla, US30, DE40, petrolio, USDJPY): prima verificare che i simboli esistano sul broker; poi AutoLoad per set.
4. **ORB Master o Indicement** (uno dei due; sono molto vicini) e solo dopo l'altro.
5. **Luna, Apex, Stability Pro** (cluster AUD): per ultimi e con correlazione tra loro; le griglie solo con tetto di perdita deciso prima.
Prima di ogni lancio: verifica dati disponibili sul PC di backtest (tick reali per quel simbolo), nomi simboli BCM, e che l'`.ex5` parta nel tester (licenza).

## Cosa serve da te prima di lanciare qualsiasi riga
- Quali EA/simboli esistono sul tuo BCM (elenco Market Watch dei simboli: BTC, indici US500/US30/USTEC, TSLA, DE40, XTIUSD, AUD cross).
- Dove sono le cartelle degli `.ex5` sul PC di backtest.
- La priorità (ordine sopra o un altro) e il tetto di perdita giornaliero/totale per il portafoglio che hai in mente.
