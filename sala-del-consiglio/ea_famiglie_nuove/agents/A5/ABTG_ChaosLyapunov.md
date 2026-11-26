# ABTG_ChaosLyapunov (A5) - scheda
Sorgente: `ABTG_ChaosLyapunov.mq5` (872 righe). Nessuna istruzione per l'agente trovata. Etichette: F / I / D come COMMON.

## Regole (F)
- EMA cross 9/21 (:75-76) sulla barra chiusa [1] vs [2] (:421-422, :434-435), **gated** da un "esponente di Lyapunov": opera solo se LLE <= 0,00 (:69, :415). TF = grafico (:105, :326-328). Una posizione per magic (:400), ingresso a mercato (:487-488).
- SL 1,5 ATR(14) con **pavimento 500 punti** (:79-82, :464-470), TP 2,5 ATR (:81, :476-481). Rischio 1% del BALANCE (:585). Flat di fine seduta opzionale, default OFF, 15:55 (:84-87, :506-534). Magic 769200 (:97). Tiene overnight (:41-44).
- LLE: finestra 100, embedding 3, k=5 su `CopyClose(...,0,...)` (:385), vicino piu' prossimo sulle distanze in PREZZO (:172-184), LLE = log(dist_k/min_dist)/k (:197).

## R2 (SI/NO)
Barra in formazione per decidere: **SI, nel gate** - `CopyClose` parte da 0 (:385), quindi prices[0] e' la barra appena nata (al primo tick ~ apertura); il cross usa invece le barre chiuse (:421). Non e' look-ahead sul futuro ma e' non riproducibile fra live/tester OHLC/ogni tick. Orari: SI solo nel flat (:86-87, ora FEED senza ora legale, OFF di default). Punti fissi: **SI** (`InpMinStopPts`=500 :82; `InpMaxSpread` in punti :98). Nuova barra: SI (:369-374). Stop minimo broker: SI (:465-466) ma solo sullo SL, il TP viene spinto (:478). Spread nel filtro: opzionale, default OFF (:98, :611). Ordine rifiutato: loggato, nessun nuovo tentativo (:499). Dati futuri: NO. Swap: non gestito.

## Difetti
1. (falsa i test, media) Gate su barra 0 (:385): usare lo shift 1 (CopyClose da 1, richiesta+1 barra). Risolvibile senza toccare ingresso/uscita (R5).
2. (falsa i test, media, I) **Il gate non e' "caos": manca la finestra di Theiler.** Il ciclo parte da i=k+1 (:172) e include segmenti sovrapposti al corrente; il vicino piu' prossimo di un random walk e' quasi sempre il segmento adiacente. In quel caso LLE = ln(movimento delle ultime 3 barre / movimento delle 3 barre a lag 5-7)/5: **un filtro di contrazione di volatilita' realizzata**, non un indicatore di dinamica. Con soglia 0 passa solo quando la volatilita' recente e' <= quella precedente. Da verificare con replica Python (quota nearest_idx in {k+1,k+2}).
3. (falsa i test, media) Pavimento 500 punti fisso (:82): su indici (1 pt=100 pti MT5) = 5 punti, ok su H1+; su oro (0,01) = 5 USD, su EURUSD 5 cifre = 50 pip: il pavimento comanda e lo SL cessa di essere "1,5 ATR". Il TP non segue il pavimento (:476-481): R:R scende sotto 1.
4. (minore) Lotto forzato al minimo se il rischio non ci sta (:606); rischio sul balance non sull'equity.
5. (minore) Flat 15:55 in ora feed senza ora legale, fisso (:86-87); NASUSD_EXT ha orologio diverso (CLAUDE.md): da non usare senza nuova diagnostica.
Nessun difetto blocca; 1-3 si risolvono senza cambiare l'ingresso.

## Misurabilita'
Il gate ha pochi passaggi (I): `gCntGatePass`/`gCntOnNewBar` (:817, :813) lo dicono; atteso <15%, quindi trade gated < 100 in IS (rischio "non giudicabile"). Dati: `NASUSD_EXT`/`SPXUSD_EXT` 2010-26 (Close/ATR soltanto: tickvol=1 e spread 0 non contano qui, ma costi da imporre a mano; orologio non fisso, irrilevante se flat OFF) e oro FTMO (riga 00:00 da scartare, altrimenti ATR/LLE falsati). Nativo BCM indici solo 2024-26. Overnight: swap long BCM indici 10-14%/anno, oro -9,7% (long), tenute di ore-giorni.

## Ipotesi
- **H1** (diagnostica, prima di tutto) Replica Python di `Lyapunov_Calc` su H1 Nasdaq/S&P: nearest_idx in {k+1,k+2} in >=60% delle barre, e passaggio gate <15%: **65%** (conferma che e' un filtro di volatilita').
- **H2** Ablazione a parita' di SL/TP (cella nuda vs gated, gate su shift 1, pavimento = 0,5 ATR scalato): gated PF IS>=1,3, t>=2, n>=100 IS; OOS n>=50 PF>1,2; e PF gated - PF nudo >=0,20 in IS e OOS. Prob: **4%**.
- **H3** Sostituire il gate con un filtro esplicito ATR(5)/ATR(20)<1 (nuova famiglia, criteri propri, nessun uso di "caos"): stesso cancello di H2: **5%** (la famiglia cross EMA e' risultata negativa in Media 200, Golden Cross).

## Correlazione con GoldenZoe
Su indici: bassa (I, 0-0.2). Su oro: media/alta lato long (I, 0,3-0,5). Alta frequenza ma pochi segnali gated.

## Classe: **B** (correggere barra 0 e pavimento, poi un'ablazione in Python; priorita' molto bassa, prob di candidato ~4-5%).
