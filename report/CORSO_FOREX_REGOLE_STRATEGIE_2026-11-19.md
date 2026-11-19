# Corso forex ABTG: regole estratte dalle lezioni e piano di verifica (19/11/2026)

Fonte: 106 trascrizioni TurboScribe (circa 125.000 parole). Lette per intero le lezioni di regole e riepilogo (Mediazione 28/33, Breakout 40, Media 200 21/23/24, Fibo H4 19/20, Easy Trend 13/14/17, Post News 10, backtest 32/39). Il resto (basi, psicologia, pattern grafici, opzioni, crypto) non e stato letto: non contiene regole operative. **ORB: nel corso non c'e nessuna lezione ORB** (nessuna occorrenza di "opening range"/ORB).

## Cosa dichiara il corso (da verificare, non e una misura nostra)
| Strategia | Regole | Mercati/TF | Dichiarato nel corso |
|---|---|---|---|
| Post News | 2 ordini pendenti sulla candela della conferenza stampa BCE e FOMC | forex, 16 op/anno | +20%/anno a rischio 3%, 2009-2024, un solo anno negativo (-2%) |
| Easy Trend | divergenza CCI di inversione; prima candela che taglia il plot tra le 8 e le 18, stesso colore della divergenza; 3 candele precedenti sotto la media; ingresso alla chiusura della candela segnale | EURUSD (EURGBP, EURCAD) H1 | win 70%, DD 8%, +198% in 2,5 anni a rischio 2% (gen 2022 - 2024, circa 140 op) |
| Fibo H4 | fine trend + candela completamente inghiottita da 1-2 candele successive; Fibonacci max-min; entry zone 1,88 e 2,88; distanza minima 50-60 pip; non in laterale | cross, H4 | nessun numero |
| Media 200 | ordini limite vicino alla EMA200 (50-70 pip), conferma H1 (spike nella prima mezz'ora = rimbalzo), TP EMA14/2 ATR, meta' posizione e BE | cross, H4/D1 | "statisticamente provata", nessun numero |
| Mediazione | Williams %R 140 in ipercomprato (-20/-50) + Supertrend rosso (sell) / ipervenduto (-50/-80) + Supertrend verde (buy); 6 livelli di ingresso da foglio Excel proprietario (non nelle trascrizioni), SL e TP dal foglio | EURUSD, GBPUSD, EURGBP, H1 | +27-30% in 2 anni a rischio 1%, DD 4% |
| Breakout | rettangolo di 20 candele M15 in area Williams %R 140; rottura con chiusura oltre il massimo/minimo; Supertrend nel verso; Williams uscito dall'area ma entro -50; SL 1 pip oltre il rettangolo; TP = 3 volte lo stop; stop a pari al primo 1R | coppie con lo yen (7 cross) e XAUUSD | +133% in 2 anni a rischio 1%, DD 4% effettivo |

Tutti i backtest dichiarati sono del corso, su 2 anni (2022-2024): non fuori campione, nessun costo/spread indicato. Stesso limite dei numeri di Leonardo sulle bande (win 90% dichiarato, 73% misurato).

## Confronto con quello che abbiamo
- **EMA200 / FiboH4_Multi / PostNews**: gli EA ABTG esistono gia' (ricostruiti dalle live di Paolo/Emiliano, stessi concetti). Nostre misure: EMA200 oro 2015-2023 PF 0,80 NON REGGE; forward EMA200 PF 0,97 (30 op), Dow PF 0,68. **Differenza chiave: il corso li applica ai cross forex H4/H1, i nostri test sono su oro/indici.** FiboH4: mai misurato fuori campione. PostNews: mai misurato sul lungo periodo (il corso dichiara 15 anni).
- **EasyTrend**: nel catalogo (forward -297 su 28 op, sotto il gruppo "mean reversion"); regole del corso piu' precise delle nostre (finestra 8-18, 3 candele precedenti sotto il plot, divergenza CCI).
- **Mediazione e Breakout (Williams %R 140 + Supertrend)**: **nessun EA in repo con queste regole**. Mediazione dipende da un foglio Excel di livelli che NON e nelle trascrizioni: senza il foglio non si puo' riprodurre. Breakout e' definito per intero dalle lezioni (sopra) e si puo' testare.

## Test proposti (da fare solo se Claudio dice si')
Peso: 1 EA nuovo (Breakout, circa 150 righe) + 1 riga PowerShell, 28 min di tester per passata su BCM M1.
1. **Breakout corso (priorita' 1)**: 7 cross JPY + XAUUSD, M15, 2013-2024 (Model 1, dati BCM M1), spread BCM reale. Criteri scritti prima: IS 2013-2020 PF >= 1,3 con >= 200 op, OOS 2021-2024 PF > 1,2, 2025-26 intoccato come hold-out; prova di deriva con direzione invertita. **Previsione: PF < 1,15** (3R con win rate atteso ~28%: pareggio al 25% prima dei costi, con uno spread di M15 JPY su stop da 20 pip il margine sparisce). Orario server: usare le ore GMT+1 fisso senza finestre orarie (il corso non ne ha).
2. **Post News 2010-2024 sul tester** con le date BCE/FOMC dalle nostre news (abtg_news_hist_G8.csv.gz, 2013+): EURUSD/GBPUSD/USDJPY, controllo della dichiarata +20%/anno. Previsione: PF 1,0-1,2, non il +20% a rischio 3%.
3. **EMA200 sui cross H4/H1** (EURUSD, GBPUSD, EURGBP, AUDCAD ...): solo se 1 non basta; il test su oro e' gia' negativo.
4. **Easy Trend H1 EURUSD** (EA nuovo con divergenza CCI): bassa priorita'; il forward e' negativo.
Mediazione: non testabile senza il foglio Excel dei 6 livelli (chiedere ad Alfio/Manuela Negro, indirizzo citato nel PDF) o un'esportazione del foglio.

Nessuna taglia/rischio/acquisto consigliato. Vincoli: solo tester/demo.
