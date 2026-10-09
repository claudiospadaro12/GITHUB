# EA NOTTURNO SULL'ORO ("GBA" = GoldBreakoutATR) -- specifica da live + foto (09/10/2026)

Fonte: live di Emiliano del 09/10 (`docs/live_emiliano/LIVE_EMILIANO_2026-10-09.txt`, parte finale: "il sistema funziona cosi'... la strategia che utilizzo di notte in automatico") + foto del pannello Input di `GoldBreakoutATR_v120 1.20` su XAUUSD M15 (scattata a schermo, sfocata in basso). **Tutto e' sentito dire / letto da una foto: nessun numero e' misurato da noi.** Il codice dell'EA di Emiliano non ce l'abbiamo e non lo copiamo: lo ricreiamo dalla descrizione.

## 1. Che cosa e' (parole di Emiliano, con la nostra lettura)
"EA trend following a rottura di un canale: quando la **chiusura di una barra supera il massimo, o scende sotto il minimo, delle ultime N barre**, e si trova dal lato giusto di una **EMA** (50 o 100), **entro a mercato** nella direzione della rottura. **Stop loss = multiplo dell'ATR**, poi **trascino lo stop con il trailing** e **chiudo comunque a tempo (48 barre)**." Entra su **M1** (a volte M1 e M3), "ma anche l'orario funziona molto bene", **lo fa girare solo di notte**, "un'operazione al giorno, due operazioni", con una **perdita massima giornaliera** (ha citato 5.000 euro come esempio). Dice: in reale da una settimana, "non ha chiuso una notte negativa" [DICHIARATO, ~7 notti: nessun campione, nessun costo noto, nessuna prova].

## 2. Parametri letti dalla foto (nomi tradotti dall'italiano del pannello)
| Parametro (pannello) | Valore | Lettura / dubbio |
|---|---|---|
| InpMagic / InpTag | 20261105 / GBA | solo identita' |
| timeframe del segnale | 1 Minuto | M1 (a voce anche M3) |
| barre del segnale (esclusa la barra di segnale...) | 48 | lunghezza del canale N: massimo/minimo delle 48 barre PRECEDENTI alla barra di segnale (riga evidenziata nella foto, testo sfocato) |
| EMA del filtro di trend | 100 | su quale TF non si legge [APERTO] |
| periodo ATR | 14 | su quale TF non si legge [APERTO] |
| spread massimo come frazione dell'ATR | 0,05 | non si entra se spread > 5% dell'ATR |
| SL iniziale = kSL x ATR | 2,5 | |
| trailing = massimo dall'ingresso - kTrail x ATR | 2,5 | stop che segue il massimo (minimo per gli short) dall'ingresso a distanza kTrail x ATR |
| uscita a tempo (barre del timeframe) | 48 | chiusura forzata dopo 48 barre del TF del segnale |
| breakeven attivo all'avvio | true | opzionale, "spento di default" ma acceso nella foto |
| si arma quando il profitto raggiunge X ATR | 1,0 | |
| SL = ingresso +/- X ATR (0 = esatto breakeven) | 0,0 | |
| InpLots | **10,0** (riga sfocata: potrebbe essere 0,10) | fisso; da noi il rischio e' una **firma di Claudio** |
| slippage massimo (punti) | 30 | |
| perdita giornaliera massima in valuta | 0,0 (spenta) | in live ha detto di usarla |
| filtro orario (ora server) per i NUOVI ingressi | false, 0-24 | quindi nella foto NON filtra: la "notte" e' scelta da lui accendendo l'EA, o con questo filtro |
| verifica il margine libero prima dell'ordine | true | |
| log, pannello, pulsanti | true | non rilevanti |

## 3. Geometria che ne esce [DERIVATO, da misurare]
Con lo spread filtrato a <= 0,05 ATR e lo stop a 2,5 ATR, **stop / spread >= 50** per costruzione: sopra la nostra frontiera `stop >= 40 x spread` (e molto sopra il duro 13,3x). Ma l'ATR di M1 sull'oro e' piccolo (ordine del dollaro o meno) e di notte lo spread si allarga: l'EA salta molti segnali (filtro) e **la frequenza reale dipende da quanto spesso il filtro e' passato di notte**. Frequenza dichiarata: 1-2 operazioni a notte, non misurata.
Trailing a 2,5 ATR e tempo a 48 barre su M1 = posizioni di ~48 minuti al massimo: **scalping sulla rottura**, non trend lungo.

## 4. Cosa NON sappiamo (aperto, da chiedere a Claudio / a Emiliano se si puo')
1. Timeframe di EMA100 e ATR (segnale M1? oppure M15 come il grafico?).
2. Lotti veri (10 o 0,10) e se la "perdita giornaliera" in live e' accesa.
3. Le **ore** in cui lo accende di notte (ora server del suo broker) e il giorno/finestra; quanti segnali al giorno.
4. Il canale N = 48 e la EMA 100 sono "i suoi"; M3 e EMA 50 sono alternative dette a voce.
5. Se il breakeven e' davvero acceso in live (nel pannello "spento di default" ma `true`).

## 5. Come lo costruiamo noi (non una copia: un EA nostro `ABTG_GoldBreakoutATR`)
- Stessa logica sopra, parametri come input con i valori della foto per RIPRODURRE (replica) e assi di misura a parte; **nessuna cella scelta guardando il numero**.
- Rischio: input `InpRiskPct` come segnaposto da firmare (modalita lotto fisso solo per replica nel tester); Guardian prima di ogni ordine (`ABTG_GuardiaIngresso`); un solo ordine aperto per magic; ora SERVER BCM (UTC+1 fisso: d'estate IT-1, d'inverno = IT).
- Finestra notturna come INPUT (ore server) con default 0-24 = nessun filtro: l'asse notte/giorno si MISURA, non si assume.
- Misure da fare prima di qualunque campo (certificato dei 5): PF/n/DD; uscita ad asse (trailing, tempo, BE on/off); simboli gemelli (XAGUSD? indici? da dichiarare); TF (M1 contro M3 contro M5); ora (notte vs giorno); costo reale (spread di notte) con tick reali.
- Nulla sul conto reale, nulla sui conti di campo finche' non c'e' il PASS dei cancelli e le firme di Claudio.

## 6. Decisione di Claudio (09/10, dopo la prima stesura): "LOTTI 1, INIZIAMO COSI'"
Lotto **fisso 1,00** per le prime prove (`InpLotMode=0`, `InpLots=1.00`). 1,00 lotto sull'oro = 100 oz: 1 USD di movimento = 100 USD. Perdita a SL per trade = 2,5 x ATR(M1) x 100 oz: dipende dall'ATR del momento ([NON MISURATO], da leggere nel tester). Il rischio in % del conto dipende dal conto, **che non e' ancora deciso**: sul demo piccolo (saldo ~5.400) un solo SL da 2-3 USD di ATR varrebbe circa 250-300 USD (~5%), su un conto da 100.000 circa 0,3%. [INFERITO: ATR M1 dell'oro dell'ordine di 1 USD, da misurare]. Il conto va scelto da Claudio prima di qualunque campo.

## 7. Ricerca nella live dei punti aperti 2 e 3 (richiesta di Claudio, 09/10) -- ESITO: NON LO DICE
Letto per intero il passaggio sull'oro (dal "sistema sull'oro, il GBA" a inizio live, al "sistema fighissimo" e alla spiegazione finale). Frasi esatte e cosa dicono:
- **TF di EMA e ATR: NON detto.** Dice: "entro a un minuto, quindi candele a un minuto, 48 candele sono uscite, la EMA ho messo come filtro EMA 100, il periodo dell'ATR l'ho messo a 14". Il TF del segnale e' M1 (a inizio live: "breakout in M1 e M3", a fine: "1-3 minuti"). Che EMA100 e ATR14 siano sullo stesso TF del segnale e' [INFERITO], non detto. Il titolo della finestra nella foto dice "XAUUSD,M15" ma e' il grafico su cui e' attaccato l'EA, non il TF del segnale (campo "timeframe del segnale: 1 Minuto").
- **Ore notturne: NON dette.** Dice solo: "lo sto provando solo di notte", "non ha chiuso una notte negativa", "stanotte che mi ha fatto un bel po' di operazioni". Nessuna ora di inizio o fine. Nella foto il filtro orario e' spento (0-24).
- **Frequenza**: "ma anche l'orario funziona molto bene, pero' ti fa un'operazione al giorno, due operazioni": riferito a una variante con filtro ORARIO (quindi con la finestra il numero di operazioni cala a 1-2 al giorno). Non e' la frequenza della versione senza filtro. [LETTURA NOSTRA, ambigua]
- **Altro detto**: la perdita giornaliera massima e' usata ("se perdo piu' di 5.000 euro ti fermi" come esempio); "adesso l'ho disabilitato"; stanotte "da 49 a 68" e "da 88 a 202" (prezzi dell'oro in punti, senza lotti ne' valuta: non interpretabile); "non vi posso dare l'EA".
**Conseguenza:** EMA/ATR sullo stesso TF del segnale come default dichiarato (assi da misurare: M1/M3, EMA 50/100); le ore notturne diventano un asse da misurare con le fasce a priori (come per il Bulge), non un valore da assumere. Se Claudio vuole la risposta vera, va chiesta a Emiliano (e' disponibile "anche di notte").

## 8. SECONDA FOTO (nitida) -- pannello Input + pannello statistiche dell'EA di Emiliano (09/10, ~08:59 sul suo orologio)
File: `docs/live_emiliano/GBA_pannello_input_2026-10-09.jpg`, `GBA_pannello_statistiche_2026-10-09.jpg`. Tutto sotto e' **letto da foto** (alcune righe del pannello statistiche si sovrappongono) e **DICHIARATO**: nessun numero e' verificabile da noi.

### 8.1 Input: la foto nitida CONFERMA tutti i valori del §2 e scioglie un dubbio
- **InpLots = 10,0 (non 0,10)**: confermato anche dal pannello statistiche ("Lotto 10.00"). Altri input: passo lotto dei pulsanti 0,0; tetto lotti 0,0; **passo limite perdita giornaliera 500,0**; finestra per la seconda pressione di conferma 4000 (ms); ripristino all'avvio dei valori modificati dal pannello false; InpLogName `GBA_events.csv`; InpStartHour 0 / InpEndHour 24, filtro orario false.
- **Timeframe di ATR: [INFERITO, ora con riscontro numerico]** M1. **CORREZIONE alla mia prima derivazione** (che dava ATR 1,198 e ignorava la valuta): il conto e' in **EUR** (nozionale 3.734.184,54 / 10 lotti x 100 oz x 4.193,9 USD = 0,8905 EUR per USD, cioe' EURUSD ~1,123 [DERIVATO]). La perdita a SL "2995,54" e' in EUR: 2995,54 x 1,1242 = 3.367,5 USD = 10 lotti x 100 oz x 3,3675 USD = **2,5 x ATR(14) = 2,5 x 1,35**: torna esattamente con l'ATR(14) = 1,35 mostrato nel pannello. Quindi lo stop del pannello e' calcolato sull'ATR del momento (1,35 USD, scala M1; l'ATR(14) di M15 sull'oro sarebbe di alcuni USD). Nello stesso pannello: "ATR(14) / EMA(100) = 1,35 / 4192,93" e "Spread / % ATR (max 5%) = 0,07 / 5,2%" (0,07/1,35 = 5,2%: coerente) -> **lo spread di 0,07 USD era sopra il limite del 5%**: segnale bloccato. EMA100 sullo stesso TF del segnale: ancora [INFERITO] (non letto).
- Altre righe del pannello: "Canale (48 barre) alto/basso 4196,77 / 4189,85"; "Ultima chiusura 4193,84 (sopra EMA: si')"; "Serve chiusura > / < 4196,77 / 4189,85"; "Distanza dal prezzo (ATR) 2,13 / 3,01"; filtri "spread/sess./perdita/margine ok/ok/ok/ok" (esiste un filtro di SESSIONE oltre a quello di spread); "Direzioni consentite LONG SHORT"; "**Ultimo segnale bloccato 05:22 SPREAD**"; in testa "TRADING NON CONSENTITO / OFF" (EA disabilitato, come detto nella live). Pulsanti sul grafico: TRAILING ON, USCITA TEMPO ON, **BREAKEVEN ON**, FILTRO SPREAD ON, VISTA COMPATTA, AZZERA CONTATORI, CHIUDI POSIZIONE; spinner per lotto, kSL, kTrail, barre max uscita, N canale, spread max, perdita giornaliera max.

### 8.2 Conto di Emiliano (dichiarato, foto)
Simbolo "XAUUSD, 100 oz, Forward contract" (CFD/futures-like). Balance **183.229,54** (prima lettura da foto sbagliata: 192.299,54; corretta dal testo che Claudio ha incollato), equity 193.191,25, margine libero 192.991,25, **valuta del conto EUR** [DERIVATO dal nozionale], leva 1:500, **hedging**. **Perdita a SL / equity = 1,55%** per operazione a 10 lotti (2.995,54 EUR su 193.191 EUR; ATR 1,35 USD). Per un lotto fisso di 1,00: **~337 USD (~300 EUR) a SL con ATR 1,35**. Commissione "fissa 3,9" detta a voce [DICHIARATO]; le uscite a -35,62 / -35,64 sono compatibili con 10 lotti x ~3,5 di commissione [INFERITO].

### 8.3 Statistiche del suo EA (tutte le chiusure dell'EA) [DICHIARATE da foto]
| Voce | Valore | Nota nostra |
|---|---:|---|
| Operazioni / vinte / perse | 62 / 29 / 31 | 2 operazioni a zero? [NON LETTO]; **serie perdente massima 7**, attuale 0 (testo incollato da Claudio) |
| Win rate / profit factor | 46,8% / 2,03 | |
| Netto (comm. e swap inclusi) | 61.517,73 | su equity ~193k |
| di cui uscite EA | 32.628,34 | **di cui chiusure manuali/esterne 28.889,39 (47%)** [CONFERMATO dal testo incollato da Claudio: coincide con la mia sottrazione] |
| Expectancy per operazione | 992,22 | |
| Media vinta / persa | 4.188,42 / -1.816,56 | payoff 2,31 -> win rate di pareggio 30,2% [DERIVATO] |
| Migliore / peggiore | 21.491,28 / -3.685,89 | **la migliore = 35% del netto** [DERIVATO] |
| Drawdown realizzato ora / max | 0,00 / 16.168,05 | 8,4% di 193k [DERIVATO] |
| Oggi: operazioni / netto | 12 / 24.961,69 | 1 manuale/esterna oggi: +285,03 |
| Ultime operazioni (09/10) | 06:39 BUY +11.991,37 SL/trailing; 06:04 BUY -35,62; 05:35 BUY -35,62; 05:34 BUY +285,03 MANUALE/ESTERNA; 05:30 BUY -35,64 [valori corretti dal testo incollato] | tutte **BUY**, fra le 05:30 e le 06:39 **dell'orologio del suo pannello** (ora server o locale: NON dichiarata) |
Coerenza interna [DERIVATO]: 29 x 4.188,42 = 121.464; 31 x 1.816,56 = 56.313; PF lordo 2,16, netto 65.151 contro 61.518 mostrati (differenza ~3.600 = commissioni+swap su 62 operazioni): torna entro cio' che il pannello chiama "comm. e swap inclusi". Sulle 5 ultime, **3 su 5 sono perdite da -35** (= stop a pareggio per breakeven: costano solo la commissione).

### 8.4 Che cosa ne facciamo (ipotesi da misurare, mai criteri)
1. **Il campione e' sottile e non e' tutto EA**: 62 operazioni in ~una settimana, **47% del netto da uscite manuali/esterne**, **il 35% del netto in un solo trade** (+21.491). PF 2,03 e "nessuna notte negativa" sono letture dichiarate su campione sottile, concentrate su pochi trade grossi (trailing su un impulso). Un EA con payoff 2,3 e win rate 47% e' plausibile come trend following da breakout, **ma 62 operazioni non lo provano**.
2. **Breakeven a +1 ATR trasforma molte perdite in -35**: la media persa di -1.816 e' fatta da pochi stop pieni (peggiore -3.686 = ~1,2x lo stop iniziale per slippage/gap) e molti pareggi: da misurare l'effetto del BE (acceso/spento) come asse.
3. **Il filtro di spread a 5% dell'ATR e' l'ingresso vero dell'EA**: il pannello mostra "ultimo segnale bloccato 05:22 SPREAD" e lo spread del momento (0,07) e' gia' 5,2%. La frequenza nostra dipende da quanto spesso lo spread BCM sull'oro passa quel cancello (**NON MISURATO**: il tester a M1 con spread vero e' la prima misura).
4. **Ore**: le operazioni visibili sono fra le 05:30 e le 06:39 (suo orologio). Le ore vere restano da chiedergli.
5. **Lotto**: 10 lotti (1,55% del suo conto da 193k) contro **1 lotto deciso da Claudio per noi**. Su un conto piu' piccolo del suo, 1 lotto e' piu' rischioso in %: da ricalcolare sul conto scelto.

### 8.5 Testo incollato da Claudio (09/10): conferme e correzioni
Il testo ricopia parametri e pannelli. Conferma: tutti i valori del §2 e §8.1; InpLots 10,0; "Perdita giornaliera: oggi / limiti: 24961,69 / off"; stato funzioni SESS. TRADING / TRAILING / USCITA TEMPO / BREAKEVEN tutti ON; pulsanti VISTA COMPATTA, AZZERA CONTATORI, CHIUDI POSIZIONE (doppio clic), RESET A INPUT; "Stato licenza: TRADING NON CONSENTITO" (trading disabilitato al momento della foto). **Correzioni mie**: balance 183.229,54 (non 192.299,54), ATR da conto in EUR (vedi 8.1), ultime operazioni -35,62 (non -35,02). Nuovo: serie perdente massima 7. Resta aperto: orari, TF di EMA, frequenza.
