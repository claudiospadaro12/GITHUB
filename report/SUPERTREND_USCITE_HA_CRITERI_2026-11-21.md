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

## RISULTATI (script `supertrend_uscite_ha.py`; output `SUPERTREND_USCITE_HA_RISULTATI_2026-11-21.txt`; oro long, stessi ingressi di X0)
| TF | Uscita | IS PF / t | OOS PF / t | Hold-out PF | Durata media (barre) | Rend. per operazione | Coppie vs X0: IS dif (t) / OOS dif (t) |
|---|---|---|---|---|---|---|---|
| H1 | X0 cambio Supertrend | 1,16 / +1,7 | 1,42 / +2,2 | 1,32 | 42,8 | +0,09% | riferimento |
| H1 | X1 HA rossa | 0,94 / -0,7 | 0,97 / -0,2 | 1,12 | 5,4 | -0,00% | -0,07% (-1,8) / -0,14% (-2,3) |
| H1 | X2 ripido, 3 rosse | 0,99 / -0,1 | 0,99 / -0,1 | 1,03 | 9,5 | -0,00% | -0,07% (-1,8) / -0,14% (-2,4) |
| H1 | X3 ripido, rossa con volume basso | 0,97 / -0,4 | 0,99 / -0,1 | 1,04 | 6,7 | +0,00% | -0,06% (-1,7) / -0,13% (-2,2) |
| H1 | X4 X2 o X3 | 0,92 / -0,9 | 0,97 / -0,2 | 1,06 | 6,4 | -0,01% | -0,07% (-1,9) / -0,14% (-2,3) |
| H4 | X0 | 1,38 / +1,7 | 1,50 / +1,5 | 2,58 | 41,4 | +0,36% | riferimento |
| H4 | X1 | 1,02 / +0,2 | 1,13 / +0,5 | 6,07 | 5,8 | +0,05% | -0,29% (-1,8) / -0,29% (-1,5) |
| H4 | X2 | 1,21 / +1,2 | 1,03 / +0,1 | 2,77 | 10,4 | +0,06% | -0,24% (-1,5) / -0,30% (-1,6) |
| H4 | X3 | 1,14 / +0,8 | 1,26 / +0,9 | 4,44 | 7,9 | +0,09% | -0,24% (-1,5) / -0,25% (-1,3) |
| H4 | X4 | 1,16 / +0,9 | 1,22 / +0,7 | 4,51 | 7,7 | +0,09% | -0,23% (-1,4) / -0,26% (-1,3) |
| D1 | X0 | 1,62 / +1,2 | 1,24 / +0,4 | n 3 | 38,1 | +1,14% | riferimento |
| D1 | X1-X4 | 1,20-1,51 / +0,5-0,9 | 1,15-1,51 / +0,3-0,7 | n 3 NV | 5,8-11,2 | +0,34-0,63% | tutte negative, |t| <= 0,9 |
- **Nessuna cella supera le porte; nessuna uscita migliore di X0.** In **tutte e 12** le coppie la differenza rispetto al cambio di Supertrend e' **negativa** sia in IS sia in OOS (H1 con t fino a -2,4 in OOS: peggiorano significativamente).
- **Effetto delle uscite HA:** la durata crolla da ~42 a 5-11 barre e il rendimento per operazione quasi si azzera; far correre in regime ripido (X2/X3/X4) recupera un po' (H4 PF IS 1,14-1,21 contro 1,02) **ma resta sotto X0**. Il volume (X3) fa lo stesso di X2 (H4 OOS 1,26 contro 1,03): **su H1 e H4 nessuna differenza rilevante fra le due regole**.
- **Hold-out** apparentemente migliore nelle varianti HA (H4 4,4-6,1) con soli 26 trade e senza supporto IS/OOS: non fa fede.
- **Previsioni:** X1 peggiore di X0 in IS e OOS (70%): **si'**; X1 PF IS < 1,3 su H1 e H4 (65%): **si'**; X2/X3/X4 meglio di X1 ma non di X0 (60%): **si'** su H4, su H1 no (identici); almeno una uscita batte X0 (20%): **no**; una cella supera le porte (20%): **no**; volume meno effetto dell'inclinazione (60%): **no, uguale**.
- **Lettura onesta:** il cambio di Supertrend resta l'uscita migliore fra quelle provate. La candela HA esce troppo presto (5-11 barre di durata media contro ~42): taglia i guadagni dei trend e paga piu' costi. **Limiti:** soglie fissate (0,5 ATR su 6 barre, 3 rosse, 20 barre di volume) non scansionate: altre soglie potrebbero cambiare il quadro, ma sarebbe esplorativo; il tick-volume di FTMO non e' il volume reale.
