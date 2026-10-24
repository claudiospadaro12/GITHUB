# Sala del consiglio, giro 4: gap e punte sul piccolo 50503392 (24/10/2026)
**Natura: LETTURA.** Due revisori in sola lettura (GapFill Dow 772234 e Nikkei 772235; PunteLarry Dow 772341 e GapContinuation Nikkei 774101), poi i punti pesanti **ricontrollati da me**. Nessun EA, set, sedia, conto o taglia toccato; nessun round lanciato; nessuna taglia consigliata. Etichette: **VERIFICATO** = ricontrollato da me su codice o CSV; **DICHIARATO** = detto da un revisore o da un documento; **INFERITO**; **NON TROVATO**. I binari .ex5 non sono stati letti: la corrispondenza binario-sorgente e' ricostruita da data e commit (DICHIARATA). Forward dal 29/07 da `data/statements/trades_auto.csv` (sedie sospese dal 25/09): campioni minuscoli.

## 1. In breve
1. **Nessun difetto hedging nelle quattro sedie.** Zero `PositionSelect/Close/Modify(_Symbol)` in GapFill, PunteLarry e GapContinuation (grep a HEAD, VERIFICATO; per i revisori anche al commit del binario, DICHIARATO). Tutto per ticket+simbolo+magic. Le sette sedie del Dow e le sedie del Nikkei non si accecano fra loro. **GapContinuation ha avuto il difetto e l'ha corretto in giornata:** il commit 899e7c12 (16/08 13:33) bloccava su qualunque magic, la correzione 72465586 (16/08 18:36) e' nel binario; lo mostra il CSV: il 14/09 GapCont entra mentre 772235 ha un buy aperto (DICHIARATO).
2. **Nessun problema di pendenti: tutte e tre le EA entrano a mercato.** GapFill e GapContinuation non usano pendenti; PunteLarry controlla StopsLevel prima di ingresso, SL e TP e logga il retcode (DICHIARATO). Quindi il rifiuto muto scoperto in R296 (Nasdaq, Nikkei, oro) **non** si applica a queste sedie.
3. **`InpMaxSpreadPts=300` NON e' inerte sul Dow.** Con point 0,01, 300 point sono **3 punti indice**; sul Nikkei (point 1) sono 300 punti, inerte. Se all'apertura del lunedi' lo spread del Dow supera 3 punti, il filtro blocca l'ingresso e **la settimana e' persa** (nessun nuovo tentativo, righe 435 e 496 del sorgente, DICHIARATO). Lo spread vero all'apertura del weekend e' NON VERIFICATO (la sonda di sabato ha letto 600 point = 6 punti, ma a mercato chiuso, quindi non vale). Corregge il giro 2, che lo dava "inerte sul forex": vale per il forex, non per il Dow.
4. **GapFill: R:R lordo del Nikkei 0,75:1** (TP = gap x fill 75%, SL = gap x 1,0; break-even circa 57% di vincite, spread escluso); sul Dow 1:1 (DICHIARATO dal revisore e dai CSV tester). Il fill 75% e' l'unico verde sul Nikkei in OOS (fill 100 e 50 in OOS -178 e -136), scelto fra 3 valori sullo stesso regime (DICHIARATO, R36).
5. **PunteLarry: il pavimento del lotto lavora in senso inverso al solito.** Il lotto e' arrotondato per difetto a 0,10: con stop fra 300 e 600 punti il rischio vero e' sotto il dichiarato (0,70% con stop 435), sopra circa 600 e' sopra (stop 1.000 punti = 1,7%). Dal volume del tester a 100k gli stop implicati vanno da 156 a 1.600 punti, mediana 560, e 16 setup su 38 stanno oltre la soglia (INFERITO). La soglia coincide con la sonda del 24/10 (Dow, rischio 1%, saldo 5.344: circa 599 punti).
6. **Lo "spezzone D1 della domenica" del giro 2 esiste anche sul Dow (INFERITO)** e il time-stop conta barre D1: un time-stop del 25/08 e' stato chiuso il 31/08 00:00 (5 barre D1 con la domenica), e il long del 31/08 ha SL a soli 113 punti con lotto 0,50. Dal 01/11 la pausa del feed puo' slittare e lo spezzone accorciarsi o sparire (INFERITO, NON MISURATO). Il header di PunteLarry (riga 108) dice "una settimana di borsa", ma il codice conta barre D1 (righe 884-885).
7. **GapContinuation: -137,91 con 4 stop pieni** (-51,9 / -51,5 / -53,7 e un pareggio con parziale +19,21; circa 1% ciascuno, VERIFICATO dai lotti 2,0-3,3). Con n=4 non dice nulla. In tick R65 le giornate negative erano 23 su 47, con 6 perdite di fila (DICHIARATO). Una delle quattro e' del **22/09, festivo giapponese** (INFERITO dal calendario), persa -53,70.
8. **Nessuna delle quattro ha prove fuori dal rialzo 2024-26** (finestra unica 26/09/2024-30/06/2026: sul Dow e sul Nikkei il broker non ha storia piu' lunga, DICHIARATO R103; il "0 operazioni 2020-23" del GapFill sugli indici non e' un mistero, manca l'indice; il caso forex resta aperto). Il lotto reale a 5.000 non e' mai stato misurato in tester per nessuna delle quattro.

## 2. Stato per sedia (forward dal 29/07)
| Sedia (magic) | Forward (VERIFICATO sul CSV) | Prove (DICHIARATE) |
|---|---|---|
| **GapFill Dow** 772234 | n=1, -50,70 (BUY 0,60 del 31/08 stoppato alle 14:30:30, 30 secondi dopo la campana USA) | R36 OOS fill 100: +205 PF 1,30 n=20, DD 2,3%; tick periodo intero +425 PF 1,39 n=30; R103 OHLC +5.466 PF 1,45 n=30 |
| **GapFill 225JPY** 772235 | n=2, +37,82 (TP short 1,60 +36,35; time-stop 48 ore esatte +1,47), nessuna perdita | R36 OOS fill 75: +76 PF 1,14 n=15, DD 4,3%; tick +534 PF 1,69 n=26; 3 trimestri su 7 negativi |
| **PunteLarry Dow** 772341 | n=5, -1,56, PF 0,982, peggiore -48,77; 1 uscita manuale (29/09, EA assente dal 25/09, INFERITO); in posizione da 5 h a 6 giorni | R38 WF tick OOS +884 PF 1,78 n=38 (IS +152); R39 100k IS 1,72 n=16 / OOS 1,81 n=38; R103 OHLC PF 1,91 n=55; time-stop 1/3/5/7/9/11/13 giorni PF 1,76/1,49/1,78/1,63/1,20/1,32/1,19 (senza OOS) |
| **GapContinuation** 774101 | n=4, -137,91, PF 0,122, peggiore -53,70, 4 stop (uno con parziale), 21 min - 2 h 35 | R65 OHLC IS n=39 PF 1,306 / OOS n=69 PF 1,363; tick OOS n=70 PF 1,398 DD 11,59% (short -2.182); R162a tick n=109 PF 1,385 |

## 3. Set e codice
Campo = set di ripristino = valori letti dai `.chr` (VERIFICATO dal revisore, `CODA_08`). Differenze dai **default del sorgente** (non dal campo): PunteLarry PatternMode 0>1, ExitMode 0>1, MaxSpread 0>300; GapContinuation rischio 0,5>1,0, TP 2>3, ReduceSellRisk true>false, OR 10>15, orari 9-15 > 1:00-7:30 server; GapFill spread 0>300. Ricompilare HEAD aggiunge solo il Guardian (fail-open senza Guardian): per GapFill il gate scatta **dopo** aver consumato la settimana, quindi se blocca la settimana e' persa.

## 4. Orologio
GapFill non ha orari nel codice: il gap e' open della prima barra H1 della settimana meno close dell'ultima, con confine al sabato mezzogiorno (VERIFICATO sul codice, DICHIARATO dal revisore); non usa l'apertura della sessione cash e non e' influenzato dall'ora legale. Un riavvio **prima** della riapertura non salta la settimana; dopo (Dow lunedi' 01:00, Nikkei domenica 23:05) si'. Il revisore non e' d'accordo col giro 2 ("riavvio nel weekend salta"). GapContinuation lavora 01:00-07:30 server: giusto con server UTC+1 fisso e Tokyo senza ora legale, nessun cambio il 26/10 e il 02/11 (DICHIARATO). PunteLarry vive su barre D1 del server (vedi punto 6).

## 5. Quesiti candidati (criteri da scrivere prima, nessuna taratura, varianti = EA nuovi con magic diverso)
**A. Senza macchina di backtest:**
1. Sonda D1 di sola lettura sul Dow: quante domeniche e quanto lunghe, quanti setup di PunteLarry nascono dallo spezzone o da un festivo; rifatta dopo il 02/11.
2. M1 del Nikkei del 21-22/09 esistono? Il gap di GapContinuation del 22/09 e' misurato su un festivo?
3. Sui trade tester disponibili (R37, a 100k): in quanti eventi il lotto a 5.000 cadrebbe sotto 0,10 e con che rischio effettivo; e quante uscite stanno entro 60 minuti dalla campana (Dow 14:30, 15:30 dal 02/11; Nikkei 01:00).
**B. Round a tick sul PC di backtest, uno alla volta:**
4. GapFill Dow e Nikkei a deposito 5.000 contro 100k con la stessa cella (come R295): PF e deal, tolleranza fissata prima.
5. Sensibilita' di `InpMaxSpreadPts` sul Dow (30, 100, 300 point) con il conteggio delle settimane perse.
6. PunteLarry con flag "salta lo spezzone / giorni di borsa" (EA nuovo): rischio realizzato in % a saldo 5.344, non merito.
7. Replica dei 9 trade del forward (01/07-23/10) con EA nuovi a magic diverso come cancello: stessa barra e direzione, poi PF e n senza ritarare nulla.

## 6. Decisioni di Claudio
1. **Spread massimo sul Dow:** 300 point (3 punti) puo' far saltare la settimana di GapFill; lasciare, allargare o misurare prima (quesito B5).
2. **Nikkei:** GapFill con fill 75% (R:R 0,75:1) e GapContinuation (4 stop su 4): restano in campo o no, dopo che i campioni sono minuscoli.
3. **PunteLarry sul Dow:** il rischio vero va da circa 0,55% a oltre 1,7% secondo lo stop; il time-stop conta le domeniche.
4. **Dal 02/11 (cash USA) e dal 01/11:** la pausa del feed e lo spezzone D1 possono cambiare; quesiti A1 e A3.
5. Quali quesiti dei gruppi A e B lanciare.

## 7. Limiti
Due revisori e i punti sopra ricontrollati da me su codice e CSV; il resto e' DICHIARATO. Binari non letti. Forward minuscolo (n tra 1 e 5). Un solo regime (rialzo 2024-26). Le specifiche del server sono quelle di oggi e lette a mercato chiuso. Nessun numero nuovo misurato in questo giro.
