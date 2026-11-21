# Supertrend long sull'oro con uscite Heikin-Ashi, inclinazione delle bande e volume (criteri PRIMA dei numeri, 21/11/2026)

**Richiesta di Claudio:** provare altre uscite, **non al cambio di Supertrend**: (1) uscire al cambio di colore della candela Heikin-Ashi; (2) quando le bande sono molto inclinate **lasciar correre** anche se escono alcune candele di colore opposto, e uscire magari al calo del volume ("sta cambiando direzione ma non ha ancora cambiato trend"). Script `backtest_runner/simulatore/supertrend_uscite_ha.py`. **Solo oro** (FTMO M1 2004-2026, righe 00:00 aggregate scartate; il volume e' il tick-volume di FTMO, per Nasdaq e S&P e' 0: non testabili), **H1, H4, D1**, **solo long**. Costi: 0,35 $ a giro, swap long 5,6%/anno per notte di calendario. **Contatore looks cumulativo: 159 + 9 + 12 nuove celle.**
## Definizioni (fissate ora; ambiguita' della richiesta risolte QUI, una sola scelta ciascuna)
- **Ingresso (uguale per tutte):** segnale Supertrend 10 / 3,0 / hl2 che passa a +1 alla chiusura della barra i; ingresso all'apertura della barra i+1. Stessa R di prima: rendimento netto / ((entry - banda su(i)) / entry). Nessun filtro SMA200.
- **Heikin-Ashi (standard):** ha_close = (O+H+L+C)/4; ha_open = (ha_open_prec + ha_close_prec)/2 (primo = (O+C)/2); candela **rossa** se ha_close < ha_open. Calcolata sulle barre chiuse dello stesso TF.
- **Uscita = alla chiusura della barra k >= i+1 se vale la regola, esecuzione all'apertura di k+1.** **In ogni variante resta anche l'uscita di sicurezza al cambio di Supertrend (trend = -1), se scatta prima** (chiarisco: l'uscita HA sostituisce il cambio di Supertrend come uscita normale, ma una posizione non resta mai aperta oltre il cambio di trend).
- **Inclinazione delle bande:** pendenza della banda su: `slope = (up[k] - up[k-6]) / ATR[k]` (6 barre, ATR di Wilder a 10): **regime ripido se slope >= 0,5** (un solo valore).
- **Volume in calo:** tick-volume della barra k < media semplice a 20 barre del tick-volume (stesso TF).
## Varianti (4 nuove + riferimento)
- **X0 (riferimento):** uscita al cambio di Supertrend (gia' misurata).
- **X1:** uscita alla prima candela HA rossa.
- **X2:** regime ripido: ignora le candele rosse, **esce solo dopo 3 candele HA rosse consecutive** (contate dall'ingresso); regime non ripido: come X1.
- **X3:** regime ripido: **esce alla candela HA rossa solo se il volume e' in calo**; regime non ripido: come X1.
- **X4:** regime ripido: esce alla prima fra le regole di X2 e di X3; regime non ripido: come X1.
**12 celle nuove (4 varianti x H1, H4, D1).**
## Misure
Per ogni cella: IS (primo 70% prima del 01/06/2025), OOS, hold-out (dal 01/06/2025): n, PF, t, durata media (barre), rendimento medio per operazione; **confronto a coppie con X0 sullo stesso ingresso:** differenza media di rendimento (variante - X0), t della differenza in IS e in OOS; **controllo deriva**: ingressi casuali di pari durata (2.000 simulazioni, seme 12345), p sul periodo intero.
## Previsioni (prima dei numeri)
- X1 (HA rossa) e' **peggiore di X0** nel confronto a coppie in IS e OOS (rendimento medio per operazione piu' basso): **70%** (taglia i profitti dei trend, piu' operazioni, piu' costi). X1 ha PF IS < 1,3 su H1 e H4: **65%**.
- X2/X3/X4 **migliorano rispetto a X1** ma non rispetto a X0: **60%**. Almeno una variante batte X0 (t della differenza >= 2 in IS **e** differenza > 0 in OOS): **20%**.
- Almeno una cella supera le porte (IS n >= 30, PF >= 1,3, t >= 2; OOS n >= 15, PF > 1,2): **20%**. Il volume (X3) da' meno effetto dell'inclinazione (X2): **60%**.
## Regola di esito (invariata dopo)
**USCITA MIGLIORE** solo se: confronto a coppie con X0 con t >= 2 in IS e differenza > 0 in OOS, **e** la cella supera le porte, **e** p <= 0,05 contro gli ingressi casuali. Altrimenti si resta al cambio di Supertrend. Un'uscita migliore resta un'ipotesi da riprovare a tick; nessuna scansione di parametri (soglia 0,5, 6 barre, 3 candele, 20 barre di volume sono fissati). Nessun consiglio di taglie.
