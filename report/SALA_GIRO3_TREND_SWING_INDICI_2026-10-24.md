# Sala del consiglio, giro 3: trend e swing su indici e Nikkei, piccolo 50503392 (24/10/2026)
**Natura: LETTURA.** Tre revisori in sola lettura (SuperWave 770511/770531; SupertrendReversal 970912/970913/770924; EMA200 771531 e PTE 771321 sul Dow), poi i punti pesanti **ricontrollati da me**. Nessun EA, set, sedia, conto o taglia toccato; nessun round lanciato; nessuna taglia consigliata. Etichette: **VERIFICATO** = ricontrollato da me su codice, CSV o log; **DICHIARATO** = detto da un revisore o da un documento, non ricontrollato; **INFERITO** = deduzione; **NON TROVATO**. Forward dal 29/07 (`data/statements/trades_auto.csv`, per magic): campioni minuscoli, servono solo a trovare anomalie. I binari .ex5 non sono stati letti: la corrispondenza binario-sorgente e' ricostruita da data e commit (DICHIARATO).

## 1. In breve
1. **Nessuno dei difetti hedging del giro 1/2 nelle sette sedie del giro.** Zero `PositionSelect/Close/Modify(_Symbol)` in SuperWave, SupRev DAX/NAS, SupertrendReversal, EMA200 e PTE (grep VERIFICATO; per i revisori anche nei commit dei binari, DICHIARATO). Gestione per ticket+magic+simbolo. **Il rischio viene dal vicino:** il binario di Dow Apertura 770202 (08/08) ha `PositionClose(_Symbol)` (sorgente 6074126d righe 585 e 1890, VERIFICATO); a HEAD resta solo nei commenti (VERIFICATO), ma il .ex5 in campo e' ancora quello vecchio (F7 da premere, DICHIARATO). Sul piccolo c'e' 770202 con altre sei sedie sullo stesso simbolo.
2. **Dow U30USD sul piccolo: 7 sedie nostre** (770202, 770511, 770531, 770611, 771321, 772234, 772341, tutte rischio 1,0; CODA_01 24/10, VERIFICATO). **Rischio dichiarato sommato: 7,0%**, senza Guardian. 771531 (0,65) risulta NON attaccata (CODA_01 24/10, VERIFICATO): con lei farebbe 7,65%. Le sedie 770202 a 0,65 e 770611 a 0,3 sono sul conto SQUADRA 100K, non sul piccolo (VERIFICATO). Non so quante apriranno insieme.
3. **770531 "SuperWave H4" gira su H2.** `InpTF=16386` in CODA_08 (VERIFICATO); H4 e' solo il TF del grafico. Il nome porta fuori strada.
4. **Il pendente "±20 pip" e' inerte sugli indici.** `PipSize()` moltiplica per 10 solo a 3 o 5 cifre (SupRev DAX r.122-126, VERIFICATO); D30EUR, NASUSD, U30USD hanno 2 cifre, 225JPY 0: i "20 pip" valgono 0,20 punti (Nikkei 20 punti). Dove la gamba 2/3 compare (gemello DAX 970911, forward) riempie a +0,2 dall'altra nello stesso minuto (VERIFICATO sul CSV: 25387,1 e 25387,3, 0,10 e 0,40 lotti). **Su 970913 (9 ingressi) e 770924 (5) la gamba 2/3 non compare mai** (VERIFICATO sul CSV): rifiuto muto probabile, **causa NON TROVATA** (il codice non legge il retcode dell'ordine pendente: DICHIARATO, righe 291/338/348/349/477/500 del DAX). Effetto misurabile: la perdita peggiore osservata e' -13,07 (NAS) e -15,41 (Nikkei), circa un quarto del rischio dichiarato 1% (saldo del piccolo 5.344 da PACCHETTO_R4, DICHIARATO).
5. **Lotto minimo su U30USD: 0,10 e passo 0,10** (tutti i 78 volumi in trades_auto sono multipli di 0,10, VERIFICATO). SuperWave 770531 il 19/08: stop 422 punti, 0,10+0,10 lotti, -72,32 (circa 1,45%) = effetto del pavimento del lotto (DICHIARATO da MISURA_LOTTI_U30USD; la peggior gamba nel CSV e' -36,17, due gambe coerenti, VERIFICATO). **EMA200 771531 ha un pavimento silenzioso** (`MathMax(mn, ...)`, ABTG_EMA200.mq5 r.495, VERIFICATO): sotto ATR H1 circa 125 il rischio vero e' piu' basso del dichiarato, sopra circa 150 piu' alto, senza tetto (tabella al par. 4; INFERITO con 0,8666 EUR/punto/lotto dal CSV).
6. **970912 DAX H4: zero posizioni** da quando il binario e' attivo (VERIFICATO sul CSV). Causa NON TROVATA. Sei condizioni in AND (DICHIARATO), nessun filtro attivo che la blocchi (time window, news, spread, Guardian spenti o assenti), tocco di uno spillo a 3 ATR raro in rialzo. Con il ritmo OOS (60 deal in circa 12,6 mesi) lo zero in sette settimane avrebbe probabilita' circa 1% (INFERITO, un solo regime). Un errore silenzioso nel Giornale completo: NON VERIFICATO. `RIESAME_MORTI` la dichiara "morta, merito sospeso" (DICHIARATO).
7. **770924 Nikkei:** il contratto dice H4 FW long-only (CONTRATTI_SEDIE r.118), in campo e' H2 con AllowShort=true: 3 trade su 5 sono short e lo short da solo non e' mai stato misurato (DICHIARATO).
8. **Nessuna prova di regime** per nessuna delle sette: tutte nel rialzo 2024-26. EMA200 Dow IS 1,2011 / OOS 1,52365 a 100k (R112, DICHIARATO), settembre 2025 vale il 40% del profitto, PF 1,93 aprile-ottobre contro 1,08 novembre-marzo (DERIVATO, RESOCONTO_G2 r.124).

## 2. Stato per sedia (forward dal 29/07; ultimo trade 23/09, sedie sospese fino al ripristino del 23/10; CSV al 23/10)
| Sedia (magic) | Forward | Difetti | Prove |
|---|---|---|---|
| **SuperWave Dow H1 Ott.** 770511 | 14 gambe (7 episodi), +334, PF 16 (gambe); 3 episodi fanno il 98% del netto | banner copiato da SupertrendReversal, input morti (InpNearAtr, InpUseConfluence...), pendente +0,20 inerte, PositionModify del trailing non controllato (r.470-471), nessun filtro spread/news, nessun FridayClose | tick 10k 2024.09-2026.06: IS 1,48 (72) / OOS 1,24 (131); 100k 1,40/1,22; OHLC R103 1,28 (290); **lo stesso set non si e' riprodotto** (PF IS 1,48 contro 1,85; due corse identiche n 143 e 131); lato short OOS PF 0,429 (84); per-trade mai misurato |
| **SuperWave** 770531 (H2) | 14 gambe, -41,68, PF 0,81; peggiore episodio -72,32; 3 su 7 a perdita piena | come sopra; gli episodi di 770511 e 770531 si sovrappongono nella stessa direzione in 4 su 7 | OHLC R103 PF 2,78 (120); cella H2 770521 a tick 10k: IS +765 (22) / OOS +514 (61, PF 1,73); inverno 2025/26 PF 1,25 contro 6,29 estate (DICHIARATO) |
| **SupRev DAX H4 Ott.** 970912 | **0** | vedi punto 6; BE fallito: `!beDone` resta vero e il parziale si ripete (r.337-338, INFERITO); CancelPendings solo sul flip; riavvio a meta' barra senza dedupe | tick 26/07 (griglia scelta per miglior profitto, deposito non dichiarato) PF 1,96 (86); OHLC 100k 2,05 (99); IS 4,302 (26) / OOS 1,525 (60); costo 27,8-184x lo spread |
| **SupRev NAS H1 Ott.** 970913 | 9 pos, +53,48, PF 2,66; **senza la prima (+65,58) -12,10, PF 0,63**; 5 ingressi su 9 nelle barre 14-16 server, 6 su 9 chiuse in meno di 2,1 h | gamba 2/3 mai vista (punto 4) | tick PF 1,57 (155); IS 1,342 (69) / OOS 1,688 (86); costo 28,7x contro frontiera 40x ("escluso per costo", DICHIARATO) |
| **SupertrendReversal 225JPY** 770924 | 5 pos, +2,79, PF 1,08; senza il TP (+33,04) -30,25 | H2 e short contro contratto (punto 7) | OHLC 100k PF 1,72 (81); Nikkei H4 long-only IS 1,356 / OOS 1,621; costo 13,6x |
| **EMA200** 771531 (non attaccata) | 23 pos, -54,71, PF 0,684 (10 vinte +118,41, 13 perse -173,12); **era a rischio 1,0, non 0,65** (INFERITO dai lotti); tre uscite a pari in meno di 2 minuti (INFERITO: target EMA14 gia' raggiunto alla fill) | pavimento silenzioso; a 0,1/0,2 lotti il parziale 50% non parte (`NormVol` floor, r.421): in campo la gestione dell'uscita differisce dal backtest a 100k (INFERITO); notizie caricate una sola volta; riavvio a meta' barra | R112 tick 100k 1%: IS 1,2011 (237 deal) / OOS 1,52365 (517); mai misurata a ~5.000 con lotto 0,10 |
| **PTE** 771321 | 1 pos (0,40 lotti, +3,78) | PositionModify non controllato (r.548, 560-561); BE e parziale come sopra; header promette un blocco news spento | r23a tick 100k: IS 1,178 (28) / OOS 1,171 (40; 23 posizioni misurate); costo 39-44x FRAGILE |
Premesse corrette: il fix "pavimento del lotto" 6ee2ec08 (11/09) tocca solo `ABTG_EMA200_Ottimizzato`, non `ABTG_EMA200`; la toppa hedging del 19/09 (9fca63d9) riguarda solo i tre Apertura.

## 3. Accoppiamenti
- **Dow:** vedi punto 2. Le sette sedie sono di famiglie diverse (aperture, trend, gap, punte): non e' detto che entrino insieme, ma sul piccolo nessun Guardian mette un tetto. Market EA su U30USD: NON TROVATO in CODA_01.
- **SuperWave 770511/770531:** stesso motore, segnali sovrapposti (4 episodi su 7): contano come una scommessa sola (DICHIARATO).
- **DAX e Nasdaq:** 970912 e 970913 condividono il simbolo con le sedie di apertura (770101, 770411; 770250, 770260): nessuna si accieca (gestione per ticket) ma il magic 970911 e' un gemello su D30EUR con la stessa logica.

## 4. Rischio vero sul Dow (EMA200 771531 a 0,65%, saldo 5.000 cifra tua, NON VERIFICATA; lotto min/passo 0,10 INFERITO dai CSV; 0,8666 EUR/punto/lotto VERIFICATO sul CSV)
| ATR H1 | lotti gamba 1 / gamba 2 | rischio vero |
|---|---|---|
| 46 | 0,2 / 0,4 | 0,56% |
| 65 | 0,1 / 0,2 | 0,39% |
| 95 | 0,1 / 0,1 | 0,41% |
| 156 | 0,1 / 0,1 | 0,68% |
| 200 | 0,1 / 0,1 | 0,87% |
(INFERITO, calcolato dal revisore; non e' una taglia ne' un consiglio.)

## 5. Orologio
Nessuna delle sette ha input orari attivi (VERIFICATO) e il server e' UTC+1 fisso. Cambiano le sessioni, non il codice: la cash USA dal 02/11 apre alle 15:30 server (cade sempre a meta' barra H1 e dentro la stessa barra H2), il DAX dal 26/10 apre alle 09:00 server e la barra H4 delle 08:00 contiene un'ora di pre-market (INFERITO). Weekend: nessun FridayClose (zero occorrenze, VERIFICATO); posizioni tenute nel weekend nel forward: EMA200 14/08 fino alla domenica 23:21 (+7,36) e 28/08 fino al lunedi' 03:34 (-12,33); NAS ven 31/07 18:00 fino al lunedi' 14:30 (swap -2,85); Nikkei ven 11/09 20:00 chiuso a TP domenica 23:05 sul gap di riapertura (DICHIARATO, dal CSV). Festivi: NON TROVATO. Swap 0,00 su tutte le tenute notturne di SuperWave: sospetto, NON VERIFICATO.

## 6. Quesiti candidati (criteri scritti PRIMA; nessuna taratura; varianti = EA nuovi con magic diverso)
**A. Senza macchina di backtest:**
1. Sonda di sola lettura (stile S1-S4): StopsLevel, FreezeLevel, VolMin, VolStep, filling di U30USD, NASUSD, D30EUR, 225JPY, XAUUSD sul terminale del piccolo, piu' lettura dei Giornali Esperti delle gambe 2/3 di chart77/79/80. Criterio: "rifiuto muto confermato" se la riga "pendente 2/3" manca per ogni ingresso e StopsLevel > 20 punti; altrimenti non confermato.
2. Tabella del rischio vero per tutte le sedie del giro dai VOLUME_MIN/STEP letti (nessuna soglia: confronto con i lotti del CSV).
3. Replay del pattern di 970912 su H4 D30EUR (export VPS e storico lungo): con almeno 2 segnali nella finestra 06/08-24/09 l'EA e' guasto, con 0-1 il silenzio e' spiegato.
4. Far passare il cancello meccanico (`controlla_riga`) al sorgente HEAD di SuperWave e SupertrendReversal prima di qualsiasi F7: l'ultimo commit di SupertrendReversal e SuperWave_DOW_H1 e' b45dd009 "NON COMPILARE, non passato dal cancello" (DICHIARATO; un PASS successivo NON TROVATO).
**B. Round a tick sul PC di backtest, uno alla volta:**
5. **EMA200 Dow R112 a deposito 5.000 con minimo e passo 0,10**, finestre invariate; sentinella a 100k: IS 1,2011 / OOS 1,52365 / 237 e 517 deal al centesimo (G0). Criterio: dPF 0,10 in entrambe le gambe e rapporto trade 0,95-1,05, come R295.
6. **Pendente acceso e spento** su SupRev NAS H1 e SuperWave Dow H1, stessa cella: l'asse e' "inerte" se n e PF coincidono entro l'arrotondamento dei lotti (atteso inerte: +0,20 punti e' sotto lo spread).
7. **Per-trade di 770511 e 770531 con magic vergine**, correlazione e DD combinato (dd_portafoglio.py): solo "si comporta come una sedia sola o no", nessun verdetto di merito.
Non conviene: cambiare moltiplicatore Supertrend, lati o soglie su un solo regime; promuovere qualunque sedia del giro (nessuna ha prove fuori dal rialzo); ricompilare a mano `ABTG_SupertrendReversal` HEAD (NON COMPILARE).

## 7. Decisioni di Claudio
1. **F7 sul Dow Apertura 770202** (il binario del 08/08 ha `PositionClose(_Symbol)` e ha sei vicine sul piccolo).
2. **Rischio aggregato sul Dow** (7,0% dichiarato sul piccolo, 7,65% con 771531) e **Guardian sul piccolo** (assente).
3. **EMA200 771531:** attaccarla o no (non risulta attaccata; e' a 0,65 dopo la tua scelta del 23/10; il forward era a 1,0).
4. **970912 muta** da due mesi e **gamba 2/3 mai vista** su 970913 e 770924: accettare che giri senza la gamba, aspettare la sonda A1, o spegnere.
5. **770924:** short in campo contro il contratto "long-only".
6. **Orologio** (DAX/MaxMin dal 26/10, Dow/ORB/Nasdaq dal 02/11): la scelta `cash` contro `prima` resta tua.
7. Quali quesiti dei gruppi A e B lanciare.

## 8. Limiti
Tre revisori e i punti sopra ricontrollati da me; il resto e' DICHIARATO. Binari non letti. Forward minuscolo (n tra 0 e 23). Un solo regime. Il saldo del piccolo (5.344 da PACCHETTO_R4, circa 5.000 da te) non e' verificato alla data dei trade. L'attribuzione per magic non separa i simboli dove lo stesso magic gira su piu' conti. Nessun numero nuovo misurato in questo giro.
