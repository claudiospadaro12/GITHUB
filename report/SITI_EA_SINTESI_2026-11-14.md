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
