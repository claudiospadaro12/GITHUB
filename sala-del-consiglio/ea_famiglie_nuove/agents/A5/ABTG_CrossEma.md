# ABTG_CrossEma (A5) - scheda
Sorgente: `ABTG_CrossEma.mq5` (840 righe). Nessuna istruzione per l'agente trovata. Etichette: F / I / D.

## Regole (F)
- Motore: EMA 9/21 sulla barra chiusa [1] vs [2] (:60-61, :302-306), ingresso a mercato alla barra 0 (:416-417), una posizione per magic (:326), TF = grafico (:136). SL 1,5 ATR(14) (:98-99, :389), TP = 2 R = 3 ATR (:100, :398-400): cella "nuda" con tutti i filtri OFF (:71, :80, :87, :104, :108, :111, :118).
- Filtri opt-in: volume tick >= 1,5x media 20 (:71-73, :347-357), EMA200 di trend (:80-81, :360-365), uscita su incrocio opposto + inversione (:87, :95, :437-457), orario sulla barra di segnale in ORA SERVER (:108-110, :369-374), chiusura venerdi' 20 server (:111-112, :530-542), news da CSV (:117-124), parziale/BE (:101-103, default 0 = inerte :492), trailing EMA lenta (:104, :516-522), max trade/giorno (:107). Guardian opt (:52, :414). Magic 772500, commento CROSSEMA (:127-128).

## R2 (SI/NO)
Barra in formazione: **NO** (CopyBuffer da 1, CopyTickVolume da 1 :353, iClose(1) :364; ATR shift 1 :382). Orari: SI ma opt-in e in ora server **senza ora legale** (:109-112); il commento "20 server = 21 IT" (:112) vale solo in estate. Punti fissi: solo `InpMaxSpread` in punti (:129, default 0 = nessun limite); SL/TP su ATR e R. Nuova barra: SI. Stop minimo: SI su SL e TP (:392-402), NO sul trailing e sul BE (:507, :520-521, nessun controllo e ritorno ignorato). Spread: opt, default OFF. Ordine rifiutato: loggato (:426), nessun retry. Dati futuri: NO. Swap: non gestito.

## Difetti
1. (blocca la compilazione dallo zip) `#include <ABTG_PausaGuardian.mqh>` (:39) e `ABTG_AutotestGuardia` (:689): l'include NON e' nei materiali (D se esiste sul PC); nel tester la guardia e' fail-open (:47-49): i test non vedono il Guardian, il live si'.
2. (falsa i test, media) **Filtro volume e dati `_EXT`**: tickvol=1 in quei CSV (CLAUDE.md) => volume 1 contro 1,5x media 1 = 1,5: il filtro blocca TUTTO (:192-193) (I). Usarlo solo su dati con tickvol vero (BCM/FTMO M1).
3. (falsa i test, lieve, I) Filtro news: `FileOpen` senza FILE_COMMON (:701) nel tester legge la sandbox dell'agente: file non trovato e filtro "di fatto spento" in silenzio (:702). Fusi orari del CSV non dichiarati (D).
4. (lieve) Lotto forzato al minimo (:603); rischio sul balance (:582); SL calcolato da ask/bid senza spread (:387-390).
5. (lieve) BE/trailing: `PositionModify` senza controllo stops level ne' esito (:507, :520-521): a ogni tick se fallisce (log spam, nessuna stima del costo).
6. (strutturale, I) Cella nuda SL 1,5 / TP 3 ATR: con ingresso senza persistenza la probabilita' di toccare il TP e' 1/3 e l'attesa lorda ~0: **PF atteso <= 1 meno costi**, l'edge deve venire dalla persistenza del cross.
Nessun difetto cambia la logica di ingresso (R5 ok per A con include recuperato).

## Misurabilita'
Cella nuda su forex H1/H4 (10 coppie BCM 2005-26 come `fibo_ema200_fx.py`), oro (FTMO 2021-26, riga 00:00 da scartare; BCM D1/H1 lungo da verificare, D), Nasdaq/S&P `_EXT` 2010-26 (solo nuda e filtro EMA200; **non** volume). Indici nativi BCM solo 2024-26: nessun fuori campione. Barra di scatto di SL/TP nella stessa barra: usare M1 (lezione EMA200 rimbalzo). Tenute: ore-giorni; swap long BCM oro -9,7%/anno e indici 10-14%.

## Ipotesi (criteri prima dei numeri)
- **H1** Cella nuda su 6 mercati x H1/H4 (12 celle): almeno una passa IS (n>=30, PF>=1,3, t>=2) e OOS (n>=15, PF>1,2) dopo costi: **7%**; >=2 mercati stessa classe: **2%**.
- **H2** Uscita su incrocio opposto senza TP (sempre a mercato, SL duro 1,5 ATR, tenuta lunga): stessi cancelli: **6%**; atteso win rate <40% e payoff >1 (da dichiarare); sull'oro correlazione col trend long.
- **H3** Filtro volume su BCM/FTMO (tickvol vero): PF filtrato - PF nudo >=0,15 in IS e OOS con >=50 trade trattenuti: **5%**.

## Correlazione con GoldenZoe
Oro H4: lato long **media (I, 0,3-0,5)**, il resto (short, forex, indici) vicina a 0-0,2 (I). Con 2 incroci chiusi (Golden Cross HA PF 0,6-0,99; Media 200 cross forex 0,87/0,64) il prior e' basso.

## Classe: **A** (misurare la cella nuda in Python dopo aver recuperato l'include; difetto 2 solo se si usa il volume; priorita' bassa).
