# BREAKING BAND / BOLLINGER SQUEEZE — tesi distillata dalle live (12/08)

Distillazione dell'agente lettore da docs/live_emiliano/ e docs/live_paolo/
(55 passaggi letti). Richiesta di Claudio: meccanizzare la "Breaking Band".

## LA SCOPERTA PRELIMINARE
Il nome "Breaking Band" compare UNA volta sola in tutto il corpus
(LIVE PAOLO 07.05, r.659-661): e' una delle 4 strategie di LEONARDO,
uno STUDENTE del gruppo ("la fai lunga pero', quella di Leonardo").
Con quel nome NON viene mai spiegata. MA aprile = "mese delle bande di
Bollinger" del corso, e il motore squeeze->rottura->cavalcata e'
spiegato in dettaglio (soprattutto Paolo 30.04 e 05.05).

## I PARAMETRI (citazioni verificate)
- Indici IN SESSIONE: BB(37, dev 3, shift 0). DAX: sempre 37/3.
- Valute e mercati chiusi/laterali: BB(20, dev 2).
- TF: dimostrata su tutti; operativita' M5/M15.
- Indicatori di contorno: StdDev custom di Paolo (sotto la propria SMA
  = compressione; parametri NON noti), ADX custom (<20 congestione,
  >25 forza, ~50 fine corsa), Supertrend 3.5 per il trailing.

## I 3 PATTERN DEL CORSO (Emiliano 20.04 r.103-105)
1. LATERALE (cost-to-cost): bande parallele + StdDev sotto la media ->
   short parte alta / long parte bassa, parziale su mediana.
   DAX: SOLO pomeriggio dopo le 17 IT, MAI in apertura.
2. SQUEEZE -> ESPLOSIONE (il "breaking"): compressione ("bande
   sfacciatamente parallele, StdDev sfacciatamente sotto", "strettoia
   tipo tubo Venturi") -> candele che CHIUDONO fuori banda:
   1a = aggressivo (Paolo si e' fatto stoppare), 2a = corretto,
   3a = Bollinger da manuale -> band riding con trailing Supertrend.
   Uscita: banda che si piega/richiude + StdDev che scende.
   SL: banda opposta (o mediana), stretto. BE a +15-20 pip. Parziali.
   Conferme opzionali: 3 Heikin Ashi senza ombra contraria ("non
   l'ho testata, testatela" - Paolo), volumi, cuspide S&P per il DAX
   ("il DAX non parte se non parte l'S&P" - Emiliano).
3. REVERSA su S/R dopo l'esplosione (discrezionale, poco definita).
+ Variante STRADDLE (Emiliano 13.04): pendenti sopra+sotto la
  compressione, stop a meta' canale — cugina del nostro MaxMin.

## REGOLE CODIFICABILI (bozza per l'EA di laboratorio)
1. BB(37,3) indici / BB(20,2) forex; TF parametrico.
2. COMPRESSIONE: StdDev < propria SMA (parametri da fissare) + bande
   parallele/strette per N barre (soglia da fissare).
3. TRIGGER: 2a candela consecutiva che chiude fuori banda (sweep 1/2/3)
   con StdDev in crescita.
4. Conferme opzionali (A/B/C, tutte spegnibili): Heikin Ashi x3,
   volumi >150% media, squeeze anche su SPXUSD (solo DAX).
5. Ingresso a mercato su chiusura trigger (o candela successiva).
6. SL banda opposta (variante: mediana). BE +15-20 pip. Parziale 50%.
7. Trailing Supertrend(3.5); uscita forzata su banda che si richiude
   + StdDev in calo 2 barre.
8. Modulo separato COST-TO-COST pomeridiano (solo laterale).
9. Filtro news opzionale.

## BUCHI (servono da Claudio)
- SLIDE del corso "Piano Corso -> Bollinger -> Strategia Bande"
  (citate in live, NON nel repo: i 5 PDF non contengono Bollinger).
- INDICATORE StdDev custom di Paolo (file + settaggi).
- Le regole esatte della "Breaking Band di Leonardo" (solo lui le sa:
  Claudio puo' chiederle nel gruppo).
- Soglie di squeeze/parallelismo, "quanto fuori" deve chiudere la
  candela, TF del setup, target (solo trailing, nessun R:R dichiarato).

## PARTI DICHIARATAMENTE DISCREZIONALI (il rischio Alta Velocita')
- La DIREZIONE dell'esplosione: "non diciamo da che parte va" (Paolo);
  Emiliano la legge dalla cuspide S&P "a occhio".
- Qualita' della compressione: classificazione visiva.
- Gestione "a sentimento" ammessa da Paolo ("non c'e' una regola...
  non sono riuscito a farmi un piano di trading su questo").
- "Questa e' arte, e' l'arte del ragionamento" (Emiliano 17.04).

## GIUDIZIO DI MECCANIZZABILITA': MEDIO (meglio di Alta Velocita')
Il segnale-cuore e' quantificabile (squeeze + N chiusure fuori banda
+ trailing + uscita su richiusura): Paolo lo enuncia quasi in checklist.
Residuo discrezionale: direzione ignota per costruzione (l'EA dovra'
scegliere: entrambe le direzioni al trigger, o straddle, o filtro
trend — SCELTE NOSTRE dichiarate), soglie mancanti (rischio
curve-fitting), falsi breakout ammessi dagli stessi docenti.

## PROSSIMI PASSI
1. Claudio: slide Bollinger + indicatore StdDev + (se possibile)
   regole di Leonardo dal gruppo.
2. Congelamento tesi v1 con le scelte dichiarate per i buchi.
3. EA laboratorio (agente MQL5) con export standard e A/B per ogni
   conferma opzionale.
4. Imbuto: OHLC screening multi-simbolo -> tick -> walk-forward,
   i 4 cancelli congelati di sempre.
