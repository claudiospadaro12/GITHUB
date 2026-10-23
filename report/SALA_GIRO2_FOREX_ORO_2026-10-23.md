# Sala del consiglio, giro 2: forex e oro in campo sul piccolo 50503392 (23/10/2026)
**Natura: LETTURA.** Quattro revisori in sola lettura (BreakingBand/EasyTrend/PTE; GapFill/PunteLarry; CostToCost/EMA200_Ott/SupertrendReversal_Ott; MaxMinNotte oro), poi i punti pesanti **ricontrollati da me**. Nessun EA, set, sedia, conto o taglia toccato; nessun round lanciato; nessuna taglia consigliata. Etichette: **VERIFICATO** = ricontrollato da me su codice o CSV; **DICHIARATO** = detto da un revisore, non ricontrollato; **INFERITO** = deduzione. Forward dal 29/07 al 22/10 (`data/statements/trades_auto.csv`, per magic): campioni minuscoli, solo per trovare anomalie.

## 1. In breve
1. **Qui il difetto hedging del giro 1 NON c'e', salvo uno.** Otto famiglie (BreakingBand, EasyTrend, PTE, GapFill, PunteLarry, CostToCost, EMA200_Ott, SupertrendReversal_Ott): zero `PositionClose(_Symbol)`/`PositionSelect(_Symbol)` nei sorgenti a HEAD (VERIFICATO con grep) e, per i revisori, anche nei commit dei binari di agosto (DICHIARATO). **L'eccezione e' MaxMinNotte oro 770402**: `SelPos()` e' ancora `PositionSelect(_Symbol)` e `PositionClose(_Symbol)` compare alle righe 251, 454, 455, 490 (VERIFICATO). Risultato: **3 posizioni su 16 uscite fuori disegno** (08/09 chiusa 19:48; 12/10 tenuta fino al 15/10 17:30; 16/10 tenuta nel weekend e chiusa a stop il 19/10 -38 EUR; VERIFICATO sul CSV). Nessuna toppa esiste, nemmeno a HEAD.
2. **Il magic 971501 ha cambiato simbolo: XAUUSD fino al 22/09 (13 posizioni, tutte 0,01 lotti), AUDCHF dal 30/09 (13 posizioni)** (VERIFICATO). Lo stesso grafico (chart34) e' passato da oro ad AUDCHF fra il 30/09 e il 01/10 con set e rischio 0,25 invariati (DICHIARATO da CODA_01). **La cella certificata e' XAUUSD H4; su AUDCHF non esiste nessuna misura.** Chi abbia cambiato il simbolo: NON TROVATO.
3. **Lotto minimo sull'oro: il rischio vero e' molto sopra quello dichiarato.** PunteLarry XAU 772343 (rischio 0,3%): tutti i lotti sono 0,01 (VERIFICATO); con SL da circa 70-115 USD per 0,01 lotti il revisore calcola circa 2% reale (DICHIARATO; saldo del piccolo NON VERIFICATO). Stesso meccanismo su MaxMin oro (tutte e 16 a 0,01) ed EMA200_Ott su oro (stop -22/-62 EUR contro un budget di circa 13,5 EUR).
4. **CostToCost EURJPY 772361:** 14 posizioni, -282 EUR: 7 stop e 7 uscite "flip" piccole (VERIFICATO sul CSV). Gli stop valgono da -30 a -52 EUR con lotti molto diversi (0,06-0,35), cioe' circa 0,65% o circa 1%. Il codice di trading e' lo stesso fra binario e HEAD (DICHIARATO): non e' un difetto di versione. Spiegazione dichiarata dal revisore: regime e modalita' di uscita (flip: i vincenti restano piccoli, i perdenti arrivano allo stop).
5. **GBPUSD H1: fino a 6 sedie** (BB 772161, EZ 772422, PTE 771332 e 771322, GapFill 772231, PunteLarry 772345 short): rischi dichiarati sommati fino a 4,5% (DICHIARATO), **senza Guardian**. Il 22/09 alle 20:00 le due PTE sono entrate insieme (0,07 e 0,14 lotti) e sono uscite insieme alle 20:37:45 (VERIFICATO); e' un "duello" voluto di progetto, ma il rischio e' la somma.
6. **Nessuna famiglia raggiunge n >= 150 a tick** e in varie il segno cambia fra IS e OOS in OHLC: il giro serve a togliere difetti, non a trovare merito.

## 2. Stato per famiglia (campione forward dal 29/07)
| Famiglia (magic) | Forward | Difetti | Prove |
|---|---|---|---|
| **BreakingBand** 772161/62/63 | 3 / 2 / 1 pos | nessun filtro spread, deviazione fissa 30 punti con target di pochi pip, reload "a meta'" (DICHIARATO) | tick OOS: GBPUSD 1,748 (26), EURUSD CONT 3,870 (13), AUDUSD INV 2,756 (11); OHLC 1999-2026 GBPUSD: IS 0,714 (261) / OOS 1,123 (260); **pattern scelto per simbolo sui dati con l'OOS visibile** (DICHIARATO) |
| **EasyTrend** 772421/22 | 10 pos -52 / 9 pos +219 | lotti minimi su CHFJPY (rischio 0,3%); forward mescola due taglie; fascia 08-18 server = 07-17 Londra dal 25/10 (R53: simile) (DICHIARATO) | tick GBPUSD IS 1,258 (26) / OOS 1,492 (41); CHFJPY 1,157 (31) / 1,248 (53); OHLC CHFJPY IS 0,824 / OOS 1,066; **nessun _EXT regge l'orso** (0,93-0,99) |
| **PTE** 771332/771322 | 1 pos / 2 pos | `PositionModify` non controllato; intestazione promette un blocco news spento; nessun filtro spread (DICHIARATO) | 771322 tick OOS 1,378 (27); OHLC 2000-2026 IS 0,79-0,87 / OOS 0,97-1,09; **771332 mai misurata a tick**; il segno cambia col feed (R80) |
| **GapFill** 772231/32/33 | 0 / 1 / 3 pos | `InpMaxSpreadPts=300` inerte sul forex; **R:R reale < 1** (0,40 e 0,66 su 2 eventi); un riavvio nel weekend salta la settimana (DICHIARATO) | tick OOS AUDUSD 2,89 (12), GBPUSD 5,03 (8), EURUSD 2,74 (9), IS con 3-5 pos; **R103: 0 operazioni 2020-23, NON SPIEGATO** |
| **PunteLarry** 772342-346 | 5 / 3 / 3 / 4 / 1 pos | lotto minimo sull'oro (sopra); **lo spezzone D1 della domenica trattato come un giorno** e time-stop che conta le domeniche (INFERITO); lati scelti sull'IS con n 11-20 (EURCAD: il lato scelto e' il peggiore in OOS) | OHLC: nessuna cella > 1,10 in entrambe le gambe; XAU long PF 0,872 su 22 anni; il WF tick n=11 dava 4,23 |
| **CostToCost** 772361/62 | 14 pos -282 / 11 pos +91 | sizing incoerente (0,65% o circa 1%); `MaxSpread 300` inerte (30 pip) | tick OOS EURJPY 1,74 (64 pos), **le 3 migliori fanno il 76% del netto, senza 1,18**; R214e/f mai lanciati |
| **EMA200_Ott** 971501 | 13 oro + 13 AUDCHF | **simbolo cambiato**; lotto minimo; parziale mai a 0,01 | cella certificata XAUUSD H4 IS 0,658 / OOS 1,495 (39/67 deal), DD 45,91% su 22 anni, "prop NO"; **AUDCHF: nessuna misura** |
| **SupertrendReversal_Ott** 970901 | 3 pos | promesso 1/3 mercato + 2/3 su pendente: **nessuna posizione "2/3" in 6 segnali**; BuyStop a $0,20 sull'oro con probabile rifiuto silenzioso (INFERITO); default rischio 2,0 contro 1,0 in campo | tick H4 IS 4,752 (22) / OOS 2,253 (30), picco su TF vicini |
| **MaxMinNotte oro** 770402 | 16 pos, +87 | **SelPos cieco (VERIFICATO)**; set del repo (rischio 1,0, spread 150, Guardian) diverso dal campo (0,5, nessun Guardian); box con la barra prima della pausa notturna (14% dei giorni, lunedi' 3 su 13) | OHLC 2020-26 PF 1,314 (511 pos), senza le 10 migliori 1,176; tick solo long PF 1,45 (93); senza le 2 vincite maggiori il forward e' circa -2 |

## 3. Accoppiamenti
- **Oro:** 3 nostre sedie (770402, 772343, 970901) + EMA200_Ott fino al 22/09 e circa 23 EA di terzi (griglie, martingale) sullo stesso simbolo, conto hedging. **Chi ha il ticket piu' basso accieca il MaxMin oro** (caso 08/09 documentato: MaxMin e PunteLarry chiudono nello stesso secondo; caso 16/10 DICHIARATO). Margine condiviso con le griglie: NON MISURATO.
- **JPY:** CostToCost EURJPY long, PunteLarry GBPJPY long, EasyTrend CHFJPY, PostNews ECB, Bulge e Azzurra short sui cross JPY.
- **Magic vicini o doppi:** 971501/771501 (il 05/08 quattro short sullo stesso segnale, tutti in perdita), 970901/770901, e 971501 su due simboli. Nel repo non esiste un preset per 771332, 772161 e 772421.

## 4. Orologio
Il forex non dipende dall'ora legale tranne: MaxMin oro (box e piazzamento in ore server fisse; dal 25/10 la finestra 06:00-07:30 UTC cade prima di Londra, e la pausa notturna del feed puo' slittare, INFERITO) ed EasyTrend (fascia 08-18 server). GapFill e PunteLarry no.

## 5. Quesiti candidati (criteri scritti PRIMA; nessuna taratura; varianti = EA nuovi con magic diverso)
**A. Senza macchina di backtest:**
1. CostToCost EURJPY: leggere il Giornale Esperti del 21/10 (riga `Rischio %` di OnInit) e verificare lo stop del 21/10 (-52 EUR, 0,21 lotti) contro il rischio dichiarato.
2. 971501: stabilire chi ha cambiato il simbolo (storico ordini e cronologia dei profili).
3. GapFill: sonda di sola misura sugli ingressi 2024-26: spread/gap, R:R effettivo, esito (descrittiva).
4. PunteLarry: contare quanti setup nascono dallo spezzone domenicale (sonda stile S2/S3b, sola lettura sulle barre D1).
**B. Round a tick sul PC di backtest, uno alla volta:**
5. **MaxMinNotte oro: variante con chiusura per ticket** (flag spento = HEAD al centesimo), da provare con un vicino sintetico a ticket basso: il successo e' "0 chiusure oltre le 17:30:30".
6. **AUDCHF H4 per 971501** a tick 2024-26 (IS/OOS, soglia 0,10), con controllo G0 sull'oro (0,658 / 1,495).
7. **Deposito reale (circa 5.400 contro 100.000)** su EasyTrend, PTE, BreakingBand: misura l'esecuzione (arrotondamento dei lotti, rischio realizzato), non il merito.
8. CostToCost EURJPY: replay del sorgente del binario sulla cella del `.chr` dal 29/07 al 22/10: "riprodotta" se almeno 12 posizioni su 14 hanno la stessa barra, direzione e classe di uscita.
9. PunteLarry: variante con due flag spenti (salta lo spezzone domenicale; time-stop in giorni di borsa).
Non conviene: cambiare lati, soglie o orari su un solo regime; promuovere BreakingBand (pattern scelto sull'OOS visibile).

## 6. Decisioni di Claudio
1. **971501:** AUDCHF va trattata come sedia nuova (non misurata) o torna sull'oro o si spegne?
2. **MaxMin oro:** F7 non ripara il difetto (non c'e' toppa nemmeno a HEAD): si apre la variante a ticket (quesito 5)? Nel frattempo ogni sedia sull'oro con ticket piu' basso puo' accecarla.
3. **Rischio vero sull'oro con 0,01 lotti:** PunteLarry XAU, MaxMin oro, EMA200 su oro. Non consiglio nessuna taglia: la decisione e' tua.
4. **Rischio aggregato su GBPUSD H1** (fino a 6 sedie, nessun Guardian).
5. **Guardian sul piccolo** (assente).
6. **Quali quesiti dei gruppi A e B lanciare.**

## 7. Limiti
Quattro revisori e 8 punti ricontrollati da me; il resto e' DICHIARATO; le corrispondenze binario-commit sono ricostruite da versione, righe e data (non si e' letto l'.ex5); forward minuscolo; un solo regime; il saldo del piccolo non e' verificato; l'attribuzione per magic mescola simboli (971501).
