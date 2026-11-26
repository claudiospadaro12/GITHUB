# ABTG_CanaleLento (A5) - scheda
Sorgente: `ABTG_CanaleLento.mq5` (838 righe). Nessuna istruzione per l'agente trovata nel sorgente. Etichette: F = FATTO_VERIFICATO (file:riga), I = INFERENZA, D = DA_VERIFICARE.

## Regole (F)
- Donchian simmetrico long+short su **D1** (:194), canale ingresso 55 (:197), uscita 20 (:201), stop/trailing sulla MEDIANA del canale 20 (:203, :361-368). Nessun TP (:593, :621), nessun filtro lato.
- Ingresso: BuyStop/SellStop un tick oltre HH/LL delle ultime 55 barre CHIUSE (shift 1: :340-341, :568-569), cancellati e ripiazzati a ogni nuova barra (:666, :701). SL = livello d'uscita (:593).
- Trailing: SL segue il canale a favore solo se > 0,1 ATR (:525, :539); chiusura a mercato se il prezzo lo attraversa (:516, :534). Rischio 1% equity via OrderCalcProfit (:412-421), mai al lotto minimo (:431).
- Magic 774301, commento "CanaleLento" (:210-211). Conto hedging: lati contati separati (:673-674; residuo dichiarato :155-165).

## R2 (SI/NO)
Barra in formazione per decidere: **NO** (shift 1; decisione al primo tick della nuova barra :639-645). Orari in input: **NO** (nessuno; D1 = barra server). Punti fissi: **NO** (livelli di prezzo; solo `dist_min` dello stops level :326-331). Nuova barra: SI. Stop minimo broker: SI (:580-581). Spread nel filtro: SI, % dello stop (:585). Ordine rifiutato: SI, contato (:596-603), nessun nuovo tentativo fino alla barra dopo. Dati futuri: NO. Swap: **non gestito** (nessun riferimento nel codice).

## Difetti
1. (falsa i test, lieve) Lo spread e' valutato UNA volta, al primo tick del D1 (:585, :701), cioe' al rollover (spread massimo): giornate saltate senza motivo (I). Rimedio: ripetere il controllo per tick entro la barra o spostarlo sul solo invio.
2. (falsa i test, lieve) Gap oltre il trigger: lo stop order riempie peggio e il rischio supera 1% (distanza SL calcolata dal trigger :575, :588) (I). Il test Python con ingresso all'apertura lo modella gia'.
3. (minore) `trigger - ask < dist_min` scarta la rottura gia' avvenuta (:580): coerente col tester, ma nel Python "ingresso all'apertura successiva" e' un'altra regola.
4. (minore) Long e short possono coesistere (:155-165, :608): non modellato dal simulatore a posizione singola.
5. (minore) D1 BCM = giorno server GMT+1 fisso: il confine D1 si sposta di 1 h rispetto alla chiusura NY fra estate e inverno; non e' il D1 di Yahoo (D).
Nessun difetto che blocca. R5: nessun difetto "falsa i test" cambia la logica di ingresso.

## Misurabilita'
D1 lungo (Yahoo, 17 mercati, 2008-2026, stessi costi/soglie di `report/DONCHIAN_D1_FASE1_CRITERI_2026-11-21.md`) con lo script `donchian_d1_fase1.py` esteso a long+short e uscita 20 (mediana e bordo). Nativo BCM: indici solo 2024-26 (CLAUDE.md) = <=10 trade a mercato: inutile. `_EXT` Nasdaq/S&P 2010-26: orologio non GMT+1 (non rilevante su D1) ma qualita' da verificare. Oro FTMO 2021-26: **scartare la riga 00:00 con tickvol>2000 PRIMA di costruire HH/LL** (CLAUDE.md), altrimenti il canale 55 e' contaminato dagli spike falsi (F-regola, I-effetto). Swap: long BCM oro -98,78 USD/lotto/notte (~-9,7%/anno), indici 10-14%; short oro +19,28 (CLAUDE.md): tenute di giorni/settimane, quindi asimmetria long/short rilevante; triplo swap mercoledi'.

## Ipotesi (criteri prima dei numeri)
- **H1** Turtle S2 long+short 55/20 (2 uscite x 17 mercati = 34 look nuovi) passa il cancello 21/11 (IS n>=30 PF>=1,3 t>=2; OOS n>=15 PF>1,2; poi hold-out 01/06/2025, swap x2). Prob >=1 cella passa: **8%**; candidato di classe (>=2 mercati): **3%**.
- **H2** Il lato short dell'oro da solo (2008-26, costi FTMO) ha PF>1,0 in IS e OOS con n>=25 e la sua serie giornaliera ha |rho| <=0,3 con il Donchian long D1: **15%** (oro in rialzo secolare).
- **H3** (misura) Lo swap BCM invece di FTMO abbassa il PF long dei passanti di >=0,15: **70%**.

## Correlazione con GoldenZoe
Stesso motore (canale 55, oro H4 long, Chandelier 3 ATR) su un TF piu' lento: sull'oro attesa **alta, rho 0,5-0,8 sul lato long** (I; proxy: Donchian D1 long vs Supertrend H4 0,44 giornaliera, `CORRELAZIONE_EA_ORO_CRITERI_2026-11-21.md`). Su indici/cripto bassa (I, 0,1-0,3), ma la famiglia ha dato 0/34. Non e' un terzo EA scorrelato sull'oro.

## Classe: **A** (misura Python economica, nessuna correzione necessaria; priorita' bassa: la famiglia long-only e' chiusa 0/34, residuo = short + uscita a canale).
