# ABTG_GoldBreakoutATR (A1) - scheda
Sorgente: `materiali_ea/ABTG_GoldBreakoutATR.mq5` (1105 righe, v1.10). Citazioni file:riga. Etichette: FV = FATTO_VERIFICATO, INF = INFERENZA, DV = DA_VERIFICARE.

## Scoperta preliminare (FV)
Il file differisce dalla copia `mql5/Experts/ABTG_GoldBreakoutATR_F1.mq5` solo per 2 righe di include (diff di testo). Quindi NON e' "mai misurato": `report/FAMIGLIA1_ORO_CRITERI_2026-11-18.md` r.25 e `report/FAMIGLIA1_ORO_dati/RISULTATI_CONTROLLO_FAMIGLIA1_ORO.csv`: oro, Modello 1 (M1 OHLC), default, 2015-23 10.531 op, PF 0,94, t -1,50, DD 57%; 2005-14 29.995 op, PF 1,11, t +4,74, DD 8,7%; verdetto "NON REGGE; instabile". La matrice del 26/11 lo dava per non misurato.

## Regole (FV)
- Segnale su barra M1 chiusa (default `InpSignalTF`=M1, r.120); il nuovo-bar scatta al primo tick (r.889-901). BUY se close[1] > massimo delle 48 barre precedenti (barra di segnale esclusa) e > EMA100; SELL speculare (r.214-235, r.145, r.128-129).
- Ingresso a mercato al primo tick della barra nuova (r.634, 653/658). SL = 2,5 x ATR(14) (r.145, 631-636); nessun TP.
- Trailing = estremo dall'ingresso -/+ 2,5 ATR, solo a favore (r.329-348, 357-367); breakeven a +1 ATR con offset 0 (r.149-151, 319-324); uscita a tempo dopo 48 barre (r.148, 380-383); una posizione per magic+simbolo (r.509-519). Lotto fisso 1,00 (r.169).
- Filtro spread: salta se (ask-bid) > 0,05 x ATR (r.137, 238-243, 697); celle di asse 0,10/0,20/0,35 dichiarate (r.46-51).

## Controlli R2
| Controllo | Esito |
|---|---|
| Barra in formazione per DECIDERE | NO: segnale, EMA, ATR su shift 1 (r.460-466, 434-439). La barra 0 si usa solo per l'estremo del trailing (r.483-485): causale, non e' look-ahead |
| Orari in input vs ora legale | Input presenti (r.161-162, 245-253) ma default 0-24 = nessun filtro. Se usati: ora server senza gestione DST (BCM GMT+1 fisso): SI, difetto latente. Mezzanotte server per tetto/perdita giornaliera (r.264-267): coerente |
| Distanze in punti fissi | Quasi tutto in ATR; unico punto fisso: slippage 30 punti (r.157, 867, 794) = 0,30 USD su oro a 2 decimali (INF) |
| Nuova barra | SI (r.897-900); dopo un ordine rifiutato il segnale e' perso (barra gia' consumata, r.660-666, 899) |
| Stop minimo/freeze | SI all'ingresso (r.630, 637-642) e nel trailing (r.763-764, 371-376) |
| Spread nel filtro | SI, ma misurato al primo tick della barra (r.697), non all'esecuzione; spread/ATR |
| Ordine rifiutato | log, nessun retry (r.660-666) |
| Magic/commento | 775800, "GBA_L/_S" (r.182-183, 647) |
| Dati futuri | NO |

## Difetti
1. Falsa i test (media, DV): nel CSV Famiglia 1 mancano 3 anni su 9 (2015, 2017, 2018) e 3 su 10 (2011, 2012, 2014) nella colonna rendimento per anno, pur con migliaia di operazioni. Causa non determinabile dai file: filtro spread/ATR 0,05 su spread storico di barra (r.137, 697) o buchi di storico M1. Il contatore `[GBA-CONTA]` (r.731-739) la direbbe.
2. Falsa i test (alta): scalper M1 con BE a +1 ATR e trailing, valutato su barre da 1 minuto: percorso intrabarra ignoto. Il rapporto tick/M1 va misurato qui (a PunteLarry vale 0,96, ma e' un D1).
3. Minore: uscita a tempo conta barre, non minuti (r.380-383); lotto fisso 1,00 non scala col conto (r.169); `InpLotMode=1` usa tick value (r.597-602), da non fidarsi su CFD non convertiti (CLAUDE.md: bug 225JPY); slippage in punti fissi.
4. Minore: BE a pareggio esatto (r.151) parte con perdita pari allo spread (INF).

## Misurabilita'
XAUUSD M1 BCM 2004-2026 (gia' usato); tick reali BCM oro solo dal 10/07/2024 (`PUNTELARRY_ORO_TICK_CRITERI`). Dati FTMO oro: scartare la riga 00:00 con tickvol > 2000; il feed FTMO nel tester e' rotto (25/11). 2024-07 -> 2026-11 mai aperto per questo EA = unico hold-out pulito.

## Ipotesi (scritte prima dei numeri; nessuna promessa di PF; 3 sguardi in piu' da contare)
- H1: a tick reali 2024-07/2026-11, replica (spread 0,05), PF >= 1,20, rendimento > 0, >= 100 operazioni. Probabilita' 15%.
- H2: stessa finestra, BE spento (altri input uguali): PF(senza BE) - PF(con BE) >= 0,10 e DD non peggiore del 20% relativo. 30%.
- H3: spread 0,20 al posto di 0,05 (cella dichiarata r.46-51): PF >= 1,10 e >= 3x le operazioni. 35%. Prima, leggere `[GBA-CONTA]` per capire se il filtro azzera anni interi.

## Classe: B
Correggere/diagnosticare prima (contatore spread e anni vuoti, esecuzione a tick), poi un solo test sull'hold-out. Priorita' bassa: 2005-14 e 2015-23 hanno segno opposto, quindi nessun vantaggio stabile; diventa C se H1 fallisce.
