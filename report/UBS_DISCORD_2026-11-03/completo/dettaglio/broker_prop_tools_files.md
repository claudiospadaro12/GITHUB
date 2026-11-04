# Broker / Prop / Tools / File ufficiali — ForexEASolutions (lettura 03/11/2026)

Periodo compito A: 01/10/2026 – 03/11/2026. Sola lettura, nessun download.

---

## 1. #broker-discussion (1478437785911169227)

**Copertura:** completa 01/10/2026 02:13 → 03/11/2026 20:20 (~330 messaggi nel periodo, letti tutti). Immagini reali (allegati, escluse reazioni emoji): 18 messaggi / ~23 immagini; analizzate le rilevanti (tutte quelle con dati); nessun allegato file (.set/.zip/.ex5/.pdf).
Wim non ha scritto direttamente nel canale nel periodo (solo una sua citazione riportata da Eugen il 02/10).

### Riassunto per broker

**IC Markets / IC Trading (ICM, ICT)**
- 02/10 Charlie B: due conti ICM sullo stesso EA, server diversi → slippage enorme su **ICMarketsSC-MT5-4** vs MT5-3. Tabella sua (immagine): slippage medio avverso sui fill oro: 2025 $0,35/oz (459 fill, mediana 0,11) → gen–mag 2026 $1,21/oz → giu–ago 2026 $2,74/oz → **settembre 2026 $10,42/oz (mediana $11,74)**. Periodo 23/09–02/10: stop entry MT5-3 $2,13/oz avverso (49 fill) vs MT5-4 **$11,14/oz** (39 fill); SL exit 0,04 vs 0,56; TP exit +0,30 favorevole vs 0,52 avverso. 28/09: 19 coppie identiche, $1,05/oz vs $11,84/oz; esempio sell trigger 4237,06: fill 4219,98 (MT5-4) vs 4237,93 (MT5-3) = $17,95/oz. Contributo al rendimento sull'oro: 8,35% (conto piccolo MT5-3, 31 trade) vs 1,37% (conto grande MT5-4, 32 trade). Ha spostato il conto su server 3.
- MaximusDemicusMaridius: "server 4" di IC Trading famoso per essere pessimo; il server non si cambia, solo aprendo nuovi conti (olegfusion: ICM ti dà sempre lo stesso server e il supporto rifiuta di cambiarlo). Maurice (03/10) anche lui su server 4 IC Trading con gap.
- JOHN: lunga esperienza negativa con ICM, consiglia di cambiare broker e definire una procedura di selezione broker.
- 15/10 Filipe_Bastos chiede dei conti "Precision" ICM; 18/10 Jorge: con i conti **precision** l'esecuzione sull'oro è circa come Vantage (trada raw ICM Global dal 2018 senza problemi salvo slippage oro recente); vale anche per ICT secondo lui. 28/10 Jorge: slippage normale con "precision environment" su MT5-2.
- 22/10 Charlie B: TSLA.NAS su **ICMarketsSC-MT5-3** spec simbolo errata (step lotto) → chiusure fallite e SL cancellati su 16 posizioni UBS; ICM stava correggendo.
- 22/10 Andrew Soma: ICTrading server 3 ha tolto la leva sull'oro → liabilities −4.072,55 su balance 4.496,98, equity 401,31 (screenshot con posizioni XAUUSD sell). 23/10 ICM risponde "glitch temporaneo della piattaforma", sparito da solo.
- 27/10 sera: outage su alcuni server ICM (MT5-2 offline ~10–20 min; MT5-3 ok); Maurice: IC Trading giù 20 min, perso un trade TBR.
- 27/10 Eugen: "ICT ha uno degli slippage peggiori"; 31/10 Maximus: rifiuto ordini di chiusura, slippage folle, sito lento. 01/11 PandaSMTH: con IC da 7+ anni senza problemi, servono conti grandi per ECN buono; Classicaltrading: esperienze variano per regione.
- 02/11 Russell: email ICM su "indici sintetici" — scetticismo (JOHN: "battere il banco è un'illusione").
- 18/10 Andrew Soma: IC = A-book sui raw (esecuzione peggiore ma mercato reale); il 07/10 l'esecuzione lenta ICM gli ha evitato trade sul falso breakout.

**Vantage / VT Markets (stesso gruppo)**
- Bonus deposito 150% (credit, non prelevabile; aiuta su equity DD). Maximus: usarlo con useequity=true; Eugen: "rifiutalo sempre"; Лох: ai prelievi si scala il bonus.
- 12–14/10 Robinson Bouricand: prelievi crypto bloccati ("manutenzione"). 21/10 Ukrit: prelievi crypto ora 2–6 ore invece di 5–15 min; Eugen: prelievo 48h+, Vantage comunica "congestione per aumento significativo delle richieste di prelievo"; arrivato (10k) dopo ~2 giorni. 23/10 olegfusion: avviso ufficiale Vantage di ritardi nei prelievi. 24/10 Лох: prelievo 24h (prima 15 min) → teme problemi di liquidità. **30/10 Eugen: "Vantage ha sistemato i pagamenti, ricevuto in 5 minuti".**
- 18/10 **Micha9886: Vantage ha chiuso il conto e rimosso tutti i profitti** per presunto "sfruttamento gap" con night scalper; Wim li ha contattati senza risposta. Dieter: "esattamente lo stesso a me". Joel L: VT Markets "ha rubato" i suoi soldi e Vantage gli ha bloccato i conti (screenshot: prelievo bloccato "contattare support"; calendario profitti mese +$3.157); Jonathan: Startrader gli ha confiscato i guadagni, reclamo alla Financial Commission.
- 23/10 olegfusion: Vantage ha cambiato la password del conto di notte perché "troppi ordini" caricano i server (circa 50 strategie su un conto) → consiglio di dividere su più conti / usare SL virtuali.
- 26–27/10 maindfriik: reclamo formale di agosto → Vantage lo ha **risarcito per lo slippage** del 24–25/08/2026.
- 29/10 Jorge: nella sua analisi mensile di slippage Vantage è il migliore dei suoi 3 broker; 3372: Vantage prima scelta, ICM seconda. Eugen: esecuzione Vantage #1, fiducia Tickmill #1.
- Andrew Soma: Vantage probabilmente B-book (esecuzione migliore ma ti cacciano se vinci).

**BlackBull**
- 06/10 Benny D: Scalp C su VT, Vantage, PU Prime, BlackBull, stesso VPS Hyonix Londra: BlackBull sempre peggiore (ping: Vantage 1,17 ms, VT 1,11, PU 1,61, BlackBull 0,94). DKPoulsen resta su Vantage. AurumStrategic: BlackBull dà VPS gratis (DKPoulsen: serve volume 20 lotti/mese).
- 08/10 Benny D: BlackBull ha chiuso un trade Luna AI senza che il prezzo toccasse lo SL (screenshot grafico ~1,61); ipotesi spread/intervento broker.
- 09/10 Adam82: slippage BlackBull molto peggiorato nel 2026 su XAU e BTC nonostante 0,9 ms. Joel L: ottimo maggio–luglio, pessimo nelle ultime 12 settimane. Rudolf I.: BlackBull fermato (non va per Scalp C, peggio su oro). 01/11 Eugen: "funziona, né migliore né peggiore".
- 08/10 Frank: banca tedesca segnala bonifico SEPA verso IBAN Malta di BlackBull; sucuki: depositato con carta Revolut senza problemi.

**TMGM** — consigliato più volte (Jeet, BK, Russell "top 2 dei miei 5 broker"); langesi (2 anni): slippage oro non alto, buon price feed; Eugen: Scalp C funziona solo su Vantage e TMGM. 31/10 malek: TMGM riduce la leva un'ora prima della chiusura del venerdì (oro 1:50, oil 1:10, indici 1:100, ETF 1:5) → chiudere tutto e cancellare pending il venerdì. Non disponibile per la Russia.

**Tickmill** — Eugen: molto regolamentato, price feed non adatto a Scalp C, ok in generale; Reaper/Phantom funzionano ma peggio che su TMGM/Vantage. Tickmill Seychelles (1:500/1:1000) non accetta residenti UE; Tommy She1by lo usa come principale, prelievo USDT ~1 giorno. clickrukii: "se una strategia non funziona su Tickmill non fa per me".

**Altri**: PU Prime ok (Benny D); RoboForex "so-so", Scalp C non funziona (Eugen, Rudolf I. lo ha fermato); Fusion buono per depositi/prelievi ma condizioni peggiori di Vantage; Pepperstone: prelievi ok (Bruce8, Kumar USDT), rifiuta molti clienti, 1:30 UK; Dukascopy/Swissquote come "più sicuri" (BK); Ultima Markets ok (maindfriik) ma contratto discutibile (Eugen, max 1000); ECMarkets: Trustpilot 53% 1 stella, "scammer, full slippage" (Jeet); Dupoin 100%/50% bonus credit (Russell, in test); FxPro ha chiuso conto di JR (Belgio) senza spiegazioni; Global Prime in test (Joel L); utenti USA non possono usare MT5 (JOHN).
- Cashback: **PaybackFX** confermato reale da malek, Mistermember (~300 USD su conto 3k), PandaSMTH (2 anni su IC, pagamenti 2 volte/mese; screenshot rebate approvati $10–$3.380 per conto).
- Rainy- (15/10): crowding della strategia → spread/slippage futuri.
- 03/11 idsme chiede tool online per monitorare lo spread nel tempo (nessuna risposta).
- Citazione Wim (riportata da Eugen 02/10): contro l'"iperattività" con SL virtuale impostare "seconds before pulling real SL" = 0 invece di 99, così non modifica lo SL.

### Immagini (#broker-discussion)
| Data | Autore | Contenuto | Note |
|---|---|---|---|
| 02/10 10:11 | Eugen | citazione messaggio Wim | param "seconds before pulling real SL" 0 invece di 99 |
| 02/10 12:00 | Charlie B | 2 grafici oro ICMarketsSC-MT5-4 vs MT5-3, 2 ott | fill molto diversi |
| 02/10 13:16 | Charlie B | tabella slippage oro per periodo | 2025 $0,35/oz → set 2026 $10,42/oz |
| 02/10 14:07 | Charlie B (3) | confronto MT5-3 vs MT5-4; grafici; tabella rendimento | 8,35% vs 1,37% sull'oro (numeri conto omessi) |
| 06/10 05:08 | PandaSMTH | rebate PaybackFX approvati su conti IC | $10–$3.380 |
| 06/10 11:53 | Benny D | foto lista server BlackBull | BBG-LD4 ~0,9 ms |
| 08/10 20:32 | Benny D (2) | grafici Luna AI BlackBull (~1,61) | chiusura anomala |
| 08/10 21:15 | Toystory | dettaglio trade | SL a 1,62299 |
| 18/10 18:40 | Joel L | prelievo Vantage bloccato | "contattare support" |
| 21/10 12:49 | Eugen | comunicazione Vantage | congestione prelievi |
| 22/10 07:24 | Eugen | citazione propria | 10k arrivati dopo ~2 giorni |
| 22/10 16:17 | Andrew Soma (2) | ICT leva oro tolta | liabilities −4.072,55, equity 401,31 |
| 23/10 13:09 | Joel L (2) | chat WhatsApp con IB su rebate; calendario P/L | +$3.157,14 nel mese |
| 24/10 12:44 | Лох К. | notifica prelievo Vantage EUR 100 riuscito | 24h |
| 24/10 13:11 | Tommy She1by | apertura conto Tickmill Seychelles raw 1:1000 | |
| 24/10 13:13 | Eugen | menu paese | Tickmill SC non accetta UE |
| 24/10 13:16 | BK | licenze ECMarkets (ASIC, FCA, FMA, FSCA, FSA offshore) | |
| 24/10 14:10 | Eugen | Trustpilot ECMarkets | 45% 5★, 53% 1★ |

Allegati file: nessuno.

---

## 2. #propfirm-discussion (1478437879284764703)

**Copertura:** completa 01/10/2026 00:45 → 03/11/2026 09:45 (~150 messaggi nel periodo, tutti letti). Immagini reali: 4 (analizzate 4) + 2 video (meme/clip, non analizzati). Nessun allegato file.

### Wim (ufficiale)
- 03/10: a chi vuole cancellare l'abbonamento mensile → "mandami un'email con i dettagli dell'acquisto".
- 04/10: alla domanda sui nuovi filtri news CPI/tassi (update Gold Reaper di ~02/10) per prop firm → "per una prop firm potrebbe essere l'opzione più sicura" (cioè attivarli).
- 10/10: i set **combo3 gold prop firm** (Reaper + Phantom) vanno bene anche per compounding a lungo termine su iFunds (DD statico 10%, nessun limite di tempo) → "è a questo che servono".
- 11/10: la **randomizzazione** serve solo a far sembrare diversi i trade → se la prop non vieta strategie copiate si può spegnere.

### Utenti
- Prop e EA: consenso dei veterani (Eugen) = **non usare EA sulle prop** (ban per hyperactivity/strategie copiate). Alternative note (propr, breakout, kraken prop, carrot, CFT, FTM, 5%ers) solo per trading manuale. Maximus: The5ers lo ha "colpito" dopo fase 2; FTMO lo segnala per hyperactivity senza posizioni aperte (JOHN: il flag viene da MetaQuotes).
- Josh Baker (01/10): sulle prop rischio 2,5–5% max DD con Reaper/Phantom "conservative/very conservative"; ridurre correlazione: 4 strategie, variare SL/TP iniziale 50–200 (con backtest), randomizzazione, saltare giorni news, ruotare 2 strategie al mese. Ash: parametro randomizzazione 75–150 e trade copier.
- **iFunds**: CHANDAN SAWLANI (dal 16/07/2026, conto 50k, 50% profit split, 10% max DD statico) usa Reaper + Phantom con i set prop di Wim (randomizzazione spenta); payout sempre sotto 12 h; screenshot: deposito 50.000, prelievi −1.973,65, profitto +3.569,84, balance 51.567,80 (09/10). Il 29–31/10: **ottobre mese negativo per Reaper/Phantom, in drawdown, nessun payout**. Critiche: akiva "spread pessimi, scammer, meglio un conto live"; BK "più guadagni su broker". !R7: risultati migliori su iFunds che sul broker con lo stesso setup (sospetto simulato). KATLA chiede se 50/50 è equo (Nawril: non sotto 80%).
- Nessun trade su combo set Reaper/Phantom dal 09/10 al 14/10 (oro in range; filtro news CPI) → normale.
- Xrading ha bannato Reaper ("toxic trading"). FundedNext: Eugen "ora scam"; regola strike (TP/SL entro 30 s) colpita due volte da champ. 28/10 Eugen: **Cashed (prop crypto che aveva consigliato l'11/10) e FundingPips "rekt"** (rifiutano/ritardano payout). The Trading Pit: payout bloccato a betty7138 in loop di verifiche; Eugen "Pitt è una truffa", payout sempre in crypto su cold wallet.
- Broker (scalp C): BK usa 13 broker (Fusion, TMGM, VT, Ultima, EC Markets, ICTrading, Vantage, Darwinex, BlackBull, Mex Atlantic, Moneta, PU Prime…), slippage più basso su TMGM, Eightcap, BlackBull, Fusion. maindfriik: escluso PU Prime e Fusion per Scalp C (hanno bruciato il 40% dei conti mentre gli altri vincevano).

### Immagini (#propfirm-discussion)
| Data | Autore | Contenuto | Numeri |
|---|---|---|---|
| 09/10 08:50 | CHANDAN SAWLANI | storico MT5 iFunds, posizioni XAUUSD 0,01–0,06 | deposito 50.000; prelievo 1.973,65; profitto 3.569,84; balance 51.567,80 |
| 09/10 23:00 | Mistermember | Strategy Ledger "Gold Scalp C", VT Markets live, 04/08–09/10/2026 | +€616,37; 66 trade; WR 84,8%; PF 10,25; expectancy €9,34; max DD €19; durata media 36 s |
| 10/10 00:37 | Mistermember | Strategy Ledger dettagliato | slippage ~40% del turnover (dal testo; immagine troppo piccola) |
| 10/10 10:14 | maindfriik | confronto Scalp C per broker (05/08–09/10/2026) | Vantage 64 trade WR75% €2.592,93 PF 2,73 maxDD −361; VT 57/81%/€1.939,50/PF 2,87/DD −525; Ultima 54/85%/€1.669,05/PF 3,73/DD −283; TradeMax 63/79%/€1.582,38/PF 2,56/DD −351; Ultima (2° conto, dal 21/08) 30/77%/€597,47/PF 2,25/DD −206 |

Allegati file: nessuno.

---

## 3. #usefull-tools (1482989069029085246)

**Copertura:** completa 01/10/2026 18:01 → 02/11/2026 20:49 (~95 messaggi nel periodo, tutti letti). Immagini reali ~30 (quasi tutte screenshot promozionali dei tool; analizzata in dettaglio quella con statistiche di slippage; le altre descritte dal testo). 4 allegati file (non scaricati).

### Wim
- 07/10: tool consigliato da Wim per avvisi di downtime VPS = **Karnek** (link referral app.karnek.com, ref=WIM).
- 31/10: "thx for sharing!" (al .reg di NiumXp per bloccare i riavvii automatici di Windows 11 Home).
- Approvazione (riferita da Jonathan 13/10): manuale UBS pubblicato online su fxlive.trading/ubs-manual.php "con l'approvazione di Wim", con riepilogo modifiche fino a **UBS 8.2**.

### Tool presentati
- **FX Live (Jonathan, fxlive.trading)** — gratis: Setfile Editor v7.3 (01/10, avviso magic number duplicati; anche versione .html offline), v7.4 (13/10, formato set UBS 8.2 verificato al 100%, clic su parametro → manuale), **v7.5 (15/10, formato UBS 8.4 + "Broker Symbols": converte i suffissi simboli per broker/server**, richiede account FX Live e Stats Export v7.67). Portfolio Lab v1.4 (06/10: barre P/L, calendario, what-if lotto fisso), v1.5 (09/10: scomposizione per simbolo di EA multi-simbolo con stesso magic — DTP, Luna AI, Range Breakout), v1.6 (11/10: import CSV segnali MQL5/Myfxbook, import storico MT5/MT4/.eml), 24/10: **Live vs Backtest vs Segnali** (confronto trade per trade, anche stesso EA su broker diversi). Slippage per posizione dalla v7.66 dello Stats Export EA. Avvisi email/Telegram su VPS/MT5. 28/10: calendario economico settimanale con fuso orario e notifica Telegram mattutina. Tony (10/10): FX Live raggruppa più magic in un EA (meglio di Myfxbook).
- **Strategy Ledger Pro (Mistermember, MQL5 product 192540, a pagamento)** — 4.40 (03/10), 4.41 (08/10: COMPARE backtest vs live con gap scomposto in prezzi/slippage/costi/timing; What-if con stress 2x slippage), 4.42 (09/10), 4.43 (13/10: What-if su live, Sizing Optimizer, guida blog), 4.44 (29/10: Portfolio di tutti i conti). Backtest Analyzer su simboli custom (02/10). Il tool gratuito "Strategy Ledger" rinominato **EA Scorecard** (02/11).
- **KONTROL_01 (Multydrew, MQL5 200734, $59 lancio)**: gestione multi-EA su un conto, protezione DD, filtri news, orari, monitoraggio cloud + Telegram (VPS/terminale/broker); 27/10 supporto MQL5 VPS; 02/11 avvisi DD Telegram. Anche "PerformanceDashboard" (MQL5 171337).
- **Tom (06/10)**: contatore ordini pendenti (aggiornamento ogni 5 s) per non superare il limite di pending del broker (MQL5 199889).
- **BK – Friday Pending Order Cleaner** (gratis, citato 16–17/10): cancella i pending il venerdì secondo orari del broker; parametro dry run = false per renderlo attivo; su 2 conti su 5 di Mr.B non ha cancellato tutto.
- **JOHN (03/10)**: Sysinternals **Autologon** (Microsoft) per far ripartire MT5 dopo riavvio VPS; script con watchdog Telegram (MT5 connesso, AutoTrading attivo).
- Libreria set: **setregistry.caplysis.com** (community .set con statistiche) e libreria di strathcole/till (citata 22/10).
- Altro: discussione abbonamenti AI (X/Cursor), Mistermember articoli MQL5 su reinforcement learning, giochi "strategyledger-games".

### Immagini (#usefull-tools)
| Data | Autore | Contenuto |
|---|---|---|
| 04/10 18:04 | Jonathan | FX Live vista slippage settimanale: 1.212 posizioni chiuse, P/L netto +€6.777,96, 162,25 lotti, commissioni −€106,56, swap −€2,49, **slippage totale −€337,80** (429 posizioni con slippage su 656; 380 sfavorevoli −€350,71, 49 favorevoli +€12,91; XAUUSD la voce principale). Conti IC Trading, PU Prime, Vantage Gold, Vantage Star; EA UBS_XAUUSD_SC_C, Gold Phantom, Gold Reaper (28/09) |
| altre ~29 | Jonathan, Mistermember, Tom, Multydrew, Tony, MaximusDemicusMaridius, Лох К. | screenshot promozionali delle interfacce dei tool (Setfile Editor, Portfolio Lab, Strategy Ledger Pro, KONTROL_01, contatore pending, abbonamento X) — non di performance |

### Allegati (NON scaricati)
| Data | Autore | File | Dimensione | Descrizione | Ufficiale? |
|---|---|---|---|---|---|
| 01/10 18:03 | Jonathan | metatrader-setfile-editor_v7.3.html | non leggibile | Setfile Editor offline v7.3 (solo funzione magic duplicati) | utente |
| 02/10 16:47 | tuviah | MagicNotifier.ex5 | 19,73 KB | notifiche push solo per apertura/chiusura dei magic scelti | utente |
| 25/10 21:15 | Eugen | PanicButtons.mq5 | 7,48 KB | 2 pulsanti: chiudi tutto / chiudi solo pending | utente |
| 27/10 22:10 | Josh Baker | UBS-Strategy-Lab-Share.zip | 251,97 KB | plugin AI per usare/ottimizzare UBS aggiornato al manuale UBS v9 | utente |

---

## 4. #manual-trade-discussion (1519590844842377398)

**Copertura:** completa 01/10/2026 06:11 → 02/11/2026 15:05 (~85 messaggi, tutti letti). Immagini reali ~13 (+1 video); analizzata quella con statistiche (backtest di Лох); le altre descritte dal testo. Nessun allegato file. Wim assente.

- 01/10 SPAZZ: 3° payout APEX (futures prop, manuale) ottenuto; regola di consistenza 50% difficile (3 screenshot di payout).
- 06/10 e 21/10 Лох Кандибобирович1: suo algoritmo Python "gold fade / mean reversal grid" su XAUUSD passato da demo a reale. Logica: multi-timeframe (30m trend, 15m struttura, 5m estensione, 1m trigger), indicatori ClusterDelta a pagamento, basket contro il movimento fino a 16 ordini da 0,01 verso uno stop duro a 7,9 ATR, chiusura a pareggio/piccola perdita dopo ~3 h se la reversione fallisce. **Backtest (immagine)**: 44 settimane di tick reali Vantage (15/12/2025–16/10/2026), conto 1k lotto minimo: profitto netto **+€5.024**, 30 settimane vincenti su 44, 89,5% basket vinti (683/763), peggior settimana −€517, drawdown massimo del totale −€929, 7 stop pieni (≈ −€1.625 in totale); uscite a target +€5.044 (329 basket), trailing stop +€2.045. Vision chiede se testato prima del 2025 (idee simili funzionano solo 2025–26).
- 15–16/10 Rainy-: spread trading manuale WTI vs Brent su Pepperstone (spread a 3 deviazioni standard → rientro a 1), ~2K guadagnati. 27/10: 10 perdite di fila, **−10R** nel sistema manuale, e contemporaneamente in perdita anche l'EA oro (bassa correlazione ma drawdown simultaneo).
- PandaSMTH (07/10): 15 anni di esperienza, usa TGR per diversificare; consigli per principianti (anche globexgreek 13/10).
- akiva 14/10: trade lungo 2 ore su conto misto manuale+EA (PE).
- 31/10: dati futures senza ritardo → Tradovate (akiva) / Lucid (Jeet).
- 01–02/11 arielguti2547: migrazione fallita; JOHN: dal journal il VPS di Londra non si connette.

### Immagini (#manual-trade-discussion)
| Data | Autore | Contenuto |
|---|---|---|
| 01/10 | SPAZZ (3) | payout APEX (futures) |
| 06/10 | Лох К. (2) | algoritmo grid oro: trade e profitto giornaliero su demo |
| 06/10 | Jsfxx | grafico vendite manuali |
| 14/10 | akiva | trade manuale di 2 ore |
| 15/10 | Rainy- | spread WTI/Brent |
| 21/10 | Лох К. (2) | backtest "Gold fade strategy, old trailing-stop rule": +€5.024 in 44 settimane, 89,5% basket vinti, max DD −€929 |
| 27/10 | Rainy- | serie di −10R |
| 27/10 | jovi, Jonasz | reazioni/meme, non pertinenti |
| 01/11 | arielguti2547 | errore migrazione (journal) |

---

## 5. #vps_discussion (1492493208855515166) — solo immagini e allegati (testo già letto altrove)

**Copertura:** periodo 01/10 → 03/11/2026 scansionato per intero (~190 messaggi caricati). 12 messaggi con immagini reali (1 è un'anteprima link); analizzate le 7 rilevanti. **Nessun allegato file.**

| Data | Autore | Contenuto | Numeri / interpretazione |
|---|---|---|---|
| 01/10 01:56 | kevincobos1997 | screenshot piano MetaTrader VPS | domanda se basta per 1 chart TGR |
| 03/10 20:31 | maindfriik | anteprima link NYCServers | sconsiglia NYCServers, meglio ForexVPS/dedicato |
| 07/10 16:06 | Ircle | log eventi Windows: riavvio del server ForexVPS (piano "Prime", 3 terminali TGP+TGR) | crash/riavvio non richiesto → non consiglia più ForexVPS |
| 08/10 05:35 | JOHN | finestra "Azure Arc" sul server | chiede se influisce su MT5 |
| 19/10 23:10 | Jonathan | ping server Vantage | AS07 1,52 ms … AS16 4,03 ms |
| 19/10 23:12 | Jonathan | ping TMGM / IC Trading da VPS New York | Access Server NY2 0,45 ms (<1 ms) |
| 19/10 23:28 | Benny D | ping Vantage da Hyonix Londra | (Benny: Hyonix NY per IC Markets e Fusion; Londra per PU Prime, VT, Vantage, BlackBull, Startrader) |
| 20/10 12:53 | Mistermember | **Strategy Ledger Pro "How your broker filled your orders" – Vantage Markets live** | **broker score 31/100 POOR**; slippage totale −€3.084,11 su 2.513 trade chiusi (2,86× spread+commissioni, 9,9% del risultato lordo; entrate −€2.769, uscite −€315); 93% dello slippage da XAUUSD+ (entry −€2.633, exit −€264); €5,81 contro per ogni €1 a favore; fill mediano 133 ms; realizzato +€4.832,39; max DD €3.315,83 |
| 20/10 13:03 | Mistermember | stesso report – **IC Trading (Capital Point Trading)** live | **score 39/100 POOR**; slippage −€259,83 (1,32× spread+comm., solo uscite, ordini a mercato); fill mediano 21 ms; €16,64 contro per €1 a favore sulle uscite; conto in perdita −18% |
| 28/10 11:53 | Mr.B | specifiche del VPS attuale | chiede equivalente ChartVPS |
| 31/10 12:29 | JOHN | risposta di Contabo sulla vulnerabilità recente | Contabo ha agito rapidamente |
| 01/11 20:00 | arielguti2547 | errore migrazione MT5 | VPS Londra non connesso (risposta JOHN) |

Nota: Mistermember dice "Vantage ha il punteggio broker più basso che abbia mai visto, che slippage!"; lui usa ICT e VT Markets.

---

## 6. #backtesting-discussion (1497100231974584473) — solo immagini e allegati

**Copertura:** periodo 01/10 → 02/11/2026 scansionato per intero (~290 messaggi caricati). 30 messaggi con immagini reali (~45 immagini); analizzate in dettaglio quelle con statistiche (malek ×2 serie, Лох, Mal parzialmente); le ~16 di Anan22 (13/10) sono screenshot di troubleshooting del tester (lotti 0,01, DD 0,08%, "non cambia nulla") e sono descritte solo dal testo. 4 allegati file (non scaricati).

### Immagini
| Data | Autore | Contenuto | Numeri / interpretazione |
|---|---|---|---|
| 01/10 07:59–08:14 | Mal (2+2+1+3+3) | backtest UBS file "YOLO" Extreme vs Moderate, YTD 2026 (fino al venerdì 25/09) + ottimizzazione attivazione strategie | meno trade con risultati simili in Moderate; caso evidenziato: max risk 85 per strat, solo strategie 1,3,4,5,6 (e variante 65 risk, strat 3–6). Numeri dei report non leggibili in miniatura |
| 08/10 03:22 | malek (6) | **Scalper A/B/C + Zairex C, lotti fissi, stesso periodo (apr–ott 2026), delay 100 ms, deposito 2.000** su 3 fonti dati | **TMGM** (real tick da gen 2026): +1.072,66, PF 2,26, DD 3,29%, 1.033 trade; **IC Markets**: +748,69, PF 1,69, DD 3,45–4,01%, 1.029 trade; **server demo MetaQuotes**: −2.002,96, PF 0,49, DD 100% (conto bruciato anche con 0,01). Conclusione: i backtest degli scalper dipendono fortemente dal feed del broker (JOHN: "backtest degli scalp set poco utili") |
| 12/10 02:26 | malek | ottimizzazione 3 anni: reverse trading | Wim: reverse trading è un parametro del singolo set, non globale |
| 12/10 | Katd-Sama (2) | real tick MetaQuotes solo dal 27/05/2025; warning log con tick ICM | |
| 13/10 | Anan22 (~16) | tester UBS che non scala il rischio | troubleshooting |
| 13/10 16:55–56 | Dey [WSB] (3+1) | stesso set funzionante: 10K, 2% per strategia, 01/01–12/10/2026 | dimostra che il set funziona |
| 26/10 22:43 | malek (2) | **UBS Christmas v3 set così com'è, default UBS (autoloader on), TMGM real tick 02/01–25/10/2026, deposito 5.500, leva 1:1000** | profitto netto **+122.733,43**, PF **1,13**, **DD max 71,98% (113.972,56)** equity DD 71,66%, 6.127 trade, win 43,6%, recovery factor 0,99; perdite per simbolo: US30 −32.393 e −10.748, TSLA.NAS −1.276, XAUUSD −515, EURUSD vari. Grafico: picco ~156k, crollo a ~61k, risalita a ~125k → rischio altissimo |
| 01/11 13:47 | Лох К. | backtest settimanale di tutto il suo setup EA 2026 | ottobre: 2 settimane di fila in perdita, "peggior mese di sempre" (Rainy- −11R anche nel manuale) |
| 29/10 | Лох К. | video | non analizzato |

### Allegati (NON scaricati)
| Data | Autore | File | Dimensione | Descrizione | Ufficiale? |
|---|---|---|---|---|---|
| 13/10 10:20 | Anan22 | message.txt | non indicata | testo di un set UBS ("saved on 2025.05.30 … input parameters for testing/optimizing Ultimate…") incollato come file | utente |
| 26/10 22:43 | malek | UBS_ChristmasV3_ReportTester-50340491.zip | 1.017,46 KB | report tester Christmas v3 su TMGM | utente |
| 26/10 22:43 | malek | autopsy_UBS_ChristmasV3_ReportTester-50340491_20261026_1742.html | 426 KB | "autopsia" del report (analisi per simbolo/strategia) | utente |
| 27/10 06:10 | **Wim The Algo Trader** | **Gold Reaper.zip** | **4,83 MB** | risposta a PerezTeka che chiedeva risultati di backtest: backtest di Gold Reaper "(done with UBS)" | **ufficiale** |

Contesto Wim nel canale: 12/10 reverse trading è parametro per singolo set; 24/10 Wim usa Gold Reaper in modalità **moderate** sul suo myfxbook; 11/10 Digital_Wim (bot): OnlyUp influisce solo sul lotto dopo le perdite.

---

# COMPITO B — Catalogo file ufficiali (tutta la storia dei canali, nessun download)

## 7. #ultimate-breakout-system FILE SET (1463078253807013950)

**Copertura:** intero canale, dal primo messaggio (20/01/2026) al 27/10/2026 — 72 messaggi, tutti di **Wim The Algo Trader**. Date in UTC.

| Data (UTC) | File | Dimensione | Descrizione (dal messaggio) |
|---|---|---|---|
| 20/01/2026 | UBS_SETS_ORDERED.zip | 1,50 MB | primo pacchetto set |
| 29/03/2026 | UBS_SETS_ORDERED.zip | 1,63 MB | aggiunti alcuni set Volatility Breakout (non completi) |
| 15/04/2026 | Ultimate_Breakout_System_Manual_V4.0.pdf | 1,04 MB | manuale v4.0 (+ 5 link video YouTube) |
| 28/04/2026 | Ultimate_Breakout_EA_WSC_V5.0.ex5 | 334,57 KB | "ultima versione per chi l'ha ricevuta direttamente da me" |
| 28/04/2026 | Ultimate_Breakout_System_Manual_V5.0.pdf | 1,37 MB | manuale v5.0 |
| 30/04/2026 | UPDATED_SETS_UBS_V5.0.zip | 608,21 KB | impostazioni fake breakout per GoldTrade Pro e GoldBot One |
| 01/05/2026 | Ultimate_Breakout_EA_WSC_V5.1.ex5 | 319,25 KB | opzione per disattivare ForceSymbol senza OneChartSetup |
| 03/05/2026 | Ultimate_Breakout_EA_WSC_V5.2.ex5 | 319,13 KB | backtest ~2x più veloce |
| 07/05/2026 | Ultimate_Breakout_EA_WSC_V5.3.ex5 | 332,37 KB | OneChartSetup rifatto, più veloce |
| 07/05/2026 | Ultimate_Breakout_EA_WSC_V5.4.ex5 | 333,22 KB | fix bug volatility breakout con OneChartSetup |
| 07/05/2026 | Ultimate_Breakout_EA_WSC_V5.5.ex5 | 332,64 KB | AllowBuyTrades/AllowSellTrades anche per volatility breakout |
| 10/05/2026 | Ultimate_Breakout_EA_WSC_V5.6.ex5 | 334,04 KB | fix bug che impedivano il backtest |
| 12/05/2026 | UPDATED_SETS_UBS_V5.6.zip | 561,92 KB | migliori set volatility dalle ottimizzazioni |
| 14/05/2026 | UPDATED_SETS_UBS_V5.6.zip | 574,51 KB | aggiunti set US30 daily da Indicement |
| 16/05/2026 | portfolio_live_sets.zip | 88,98 KB | set del portafoglio live (segnale MQL5 2373798) |
| 16/05/2026 | image.png | — | backtest portafoglio live 2020–2026 (1M OHLC), balance fisso |
| 16/05/2026 | ubs_onechart_live.set | 12,45 KB | impostazioni del singolo chart EURUSD che gestisce il portafoglio da 30 strategie |
| 16/05/2026 | live_portfolios.zip | 2,61 MB | backtest |
| 17/05/2026 | Ultimate_Breakout_EA_WSC_V5.7.ex5 | 334,68 KB | fix autoloader/virtual expiration |
| 19/05/2026 | Ultimate_Breakout_EA_WSC_V5.8.ex5 | 336,06 KB | backtest real tick molto più veloce (fast 5x, ultra 20x) |
| 22/05/2026 | Ultimate_Breakout_EA_WSC_V5.9.ex5 | 337,37 KB | fix infopanel; modalità normal/efficient/fast/ultra fast |
| 25/05/2026 | **Ultimate_Breakout_EA_WSC_V6.0.ex5** | 338,79 KB | colonna "strategy"; fix lotto nell'infopanel — **ultima .ex5 UBS pubblicata in questo canale** |
| 01/06/2026 | UPDATED_SETS_UBS_V6.0.zip | 666,27 KB | timeframe mancante in set Advanced Scalper |
| 01/07/2026 | UPDATED_SETS_UBS_V6.2.zip | 1,94 MB | strategia 1 Gold Reaper: aggiunti high/low trailing SL |
| 01/07/2026 | 30StrategiesPortfolio_Sets.zip | 88,98 KB | filtro NFP attivo su Gold e Indices breakout (non su Volatility) |
| 03/07/2026 | UPDATED_SETS_UBS_V6.2.zip | 1,94 MB | timeframe USDJPY advanced scalper |
| 08/07/2026 | UPDATED_SETS_UBS_V6.3.zip | 1,96 MB | cartella "sets" corretta; set oro gratuiti di BaSa; poi magic unici |
| 15/07/2026 | Ultimate_Breakout_EA_TestVersion.ex5 (+ image.png) | 347,96 KB | versione TEST della nuova entrata "break and retest" (stop-limit + limit) |
| 16/07–30/07/2026 | UPDATED_SETS_UBS_V6.3.zip (8 aggiornamenti) | 1,98 → 2,08 MB | 3 set Bitcoin Reaper nel portafoglio live; ottimizzazione Daytrade Pro forex; set-file editor migliorato; Gold Reaper strat. 7 e trailingTP strat. 1; volatility breakout US500/US30/USTEC; gold scalp (real tick); live portfolio da 30 → **44 strategie** |
| 31/07/2026 | Ultimate_Breakout_System_Manual_V6.4_revised.pdf | 1,40 MB | descrizione parametri Break-Retest |
| 04/08–07/08/2026 | UPDATED_SETS_UBS_V6.3.zip | 2,13 MB | nuovo set **Gold Scalp C**; poi filtro NFP su Scalp C |
| 08/08/2026 | UPDATED_SETS_UBS_V6.4.zip | 2,39 MB | set condivisi da clienti |
| 12/08–01/09/2026 | UPDATED_SETS_UBS_V7.0.zip (10 aggiornamenti) | 2,10 → 2,17 MB | Opening Range Breakout nel manuale + 2 set; set clienti (BK TSLA, Till); fix TP USDJPY Range Breakout; **tutti i set Gold Phantom** (26–28/08); set live Gold Scalp C (lotsizeStep=80, 31/08) |
| 22/09–24/09/2026 | UPDATED_SETS_UBS_V7.6.zip | 2,29 → 2,32 MB | max DD storico set BaSa; nuovo set editor html; fix bug editor |
| 28/09–08/10/2026 | UPDATED_SETS_UBS_V7.7.zip (5 aggiornamenti) | 2,54 → 2,53 MB | manuale con autoloader **Group Close**; editor migliorato (02/10); set BaSa corretto (06/10); **Gold Scalp C live con lotsizeStep 120** (07/10); Max DD storico Phantom strat. 4–5 (08/10) |
| 14/10/2026 | UPDATED_SETS_UBS_V8.3.zip | 2,56 MB | manuale aggiornato all'ultima versione; set Bitcoin clienti (BK) |
| 19/10/2026 | UPDATED_SETS_UBS_V8.3.zip | 5,67 MB | set migliorati Daytrade Pro EURJPY e GBPJPY |
| 26/10/2026 | UPDATED_SETS_UBS_V8.3.zip | 5,58 MB | rimosso set Bitcoin H1_F (volatility) dal live a 44 strategie: trade non coerenti col backtest |
| **27/10/2026** | **UPDATED_SETS_UBS_V9.0.zip** | **5,58 MB** | "updated manual" → **PACCHETTO PIÙ RECENTE** |

**Versioni più recenti in questo canale:** set + manuale = **UPDATED_SETS_UBS_V9.0.zip (27/10/2026, 5,58 MB)**; manuale PDF separato = V6.4_revised (31/07/2026), poi incluso negli zip; EA .ex5 = **WSC V6.0 (25/05/2026)** + TestVersion break&retest (15/07/2026). Le versioni EA più recenti (UBS 8.x/9.x) non sono pubblicate qui (verosimilmente via MQL5/sito; da verificare in #ea-update-notifications).

## 8. #plug-and-play-eas (1463078207799558164)

**Copertura:** intero canale, 20/01/2026 → 19/10/2026 — 23 messaggi, tutti di **Wim The Algo Trader**.

| Data (UTC) | File | Dimensione | Descrizione |
|---|---|---|---|
| 20/01/2026 | combodeal.zip | 139,41 KB | set file del combo |
| 22/01/2026 | combodeal.zip | 151,36 KB | aggiunti set Gold Phantom |
| 29/03/2026 | Set_Files_All_EAs.zip | 161,11 KB | rimossi set non più significativi |
| 10/04/2026 | AllSetFiles_AllEAs.zip | 163,02 KB | aggiunto set ORB Master |
| 22/04/2026 | — (solo testo) | — | schede descrittive di tutti gli EA con link MQL5: UBS, Gold Reaper, Gold Trade Pro, Goldbot One, Gold Phantom, Daytrade Pro, Luna AI Pro, Indicement, Bitcoin Reaper, ORB Master, Bitcoin Scalp Pro, Stability Pro (grid), Apex Trader (grid AUDCAD/AUDNZD/NZDCAD) |
| 30/05/2026 | AllSetsManuals.zip | 4,80 MB | cartella Luna sistemata + tutti i manuali |
| 31/07/2026 | Manuals_PFDs.zip | 4,66 MB | manuali EA oro aggiornati: **"minimum balance" più alto** |
| 28/08/2026 | AllSetsAndManuals.zip | 3,63 MB | set Luna per la nuova versione (cambiata l'ora di stop del filtro news) |
| 05/10/2026 | AllSetsAndManuals.zip | 2,92 MB | manuali EA oro aggiornati |
| **19/10/2026** | **AllSetsAndManuals.zip** | **2,92 MB** | rimossi alcuni set Bitcoin Scalp dal "Mex Live Portfolio" → **PACCHETTO PIÙ RECENTE** |

**Più recente:** AllSetsAndManuals.zip del 19/10/2026 (2,92 MB). Manuali separati più recenti: Manuals_PFDs.zip 31/07/2026 (4,66 MB), poi inclusi in AllSetsAndManuals.

## 9. #product-manuals (1487857749944697093)

**Copertura:** intero canale, 29/03/2026 → 10/10/2026 — 4 messaggi, tutti di **Wim The Algo Trader**.

| Data (UTC) | File | Dimensione | Descrizione |
|---|---|---|---|
| 29/03/2026 | Apex.pdf | 308,75 KB | manuale Apex Trader |
| 29/03/2026 | Bitcoin_Reaper.pdf | 313,38 KB | manuale |
| 29/03/2026 | Bitcoin_Scalp_Pro.pdf | 316,60 KB | manuale |
| 29/03/2026 | Daytrade_Pro.pdf | 316,06 KB | manuale |
| 29/03/2026 | Gold_Phantom.pdf | 324,42 KB | manuale |
| 29/03/2026 | Gold_Reaper.pdf | 318,85 KB | manuale |
| 29/03/2026 | Goldbot_One.pdf | 343,33 KB | manuale |
| 29/03/2026 | Goldtrade_Pro.pdf | 309,49 KB | manuale |
| 29/03/2026 | Indicement.pdf | 323,60 KB | manuale |
| 29/03/2026 | Luna_AI.pdf | 337,17 KB | manuale |
| 29/03/2026 | ORB_Master.pdf | 314,58 KB | manuale |
| 29/03/2026 | Stability_Pro.pdf | 312,89 KB | manuale |
| 29/03/2026 | Ultimate_Breakout_System_Manual_V4.0.pdf | 1,04 MB | manuale UBS v4.0 (superato) |
| 04/09/2026 | Profalgo-Client-FAQ.html | 78 KB | FAQ clienti Profalgo (html) |
| **10/10/2026** | **Profalgo-Client-FAQ_2026-10-10.pdf** | **344,54 KB** | FAQ clienti aggiornata, link tradewithwim.com/faq → **più recente** |

Nota: i PDF dei singoli EA qui risalgono al 29/03/2026 e sono **superati**: le versioni aggiornate dei manuali sono dentro AllSetsAndManuals.zip (#plug-and-play-eas, 19/10/2026) e UPDATED_SETS_UBS_V9.0.zip (#ultimate-breakout-system, 27/10/2026). Manuale UBS online anche su fxlive.trading/ubs-manual.php (fino a UBS 8.2, con approvazione di Wim).

---

## Riepilogo — file ufficiali più recenti
| Pacchetto | File | Data | Dimensione |
|---|---|---|---|
| Set + manuale UBS | UPDATED_SETS_UBS_V9.0.zip | 27/10/2026 | 5,58 MB |
| EA UBS (.ex5 nel canale) | Ultimate_Breakout_EA_WSC_V6.0.ex5 | 25/05/2026 | 338,79 KB |
| EA UBS test break&retest | Ultimate_Breakout_EA_TestVersion.ex5 | 15/07/2026 | 347,96 KB |
| Manuale UBS PDF separato | Ultimate_Breakout_System_Manual_V6.4_revised.pdf | 31/07/2026 | 1,40 MB |
| Set + manuali tutti gli EA plug&play | AllSetsAndManuals.zip | 19/10/2026 | 2,92 MB |
| Manuali EA oro (separati) | Manuals_PFDs.zip | 31/07/2026 | 4,66 MB |
| FAQ clienti | Profalgo-Client-FAQ_2026-10-10.pdf | 10/10/2026 | 344,54 KB |
| Backtest Gold Reaper (in #backtesting-discussion) | Gold Reaper.zip | 27/10/2026 | 4,83 MB |
| Portafoglio live UBS | ubs_onechart_live.set / portfolio_live_sets.zip / 30StrategiesPortfolio_Sets.zip | 16/05 – 01/07/2026 | 12,45 KB / 88,98 KB / 88,98 KB (superati dal live a 44 strategie dentro gli zip UBS) |
