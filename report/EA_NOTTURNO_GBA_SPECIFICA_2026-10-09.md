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
