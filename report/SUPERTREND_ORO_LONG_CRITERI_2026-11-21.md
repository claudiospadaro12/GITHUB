# Supertrend sull'oro, solo long: controllo della deriva e due varianti (criteri PRIMA dei numeri, 21/11/2026)

**Origine:** correzione del 21/11 (`SUPERTREND_CRITERI_2026-11-21.md`): oro long H4 PF IS 1,38 / OOS 1,50 / hold-out 2,58 (t IS 1,7), H1 long 1,16 / 1,42 / 1,32. **Domanda: il vantaggio e' del Supertrend o e' la deriva dell'oro (x14 in 22 anni)?** Script `backtest_runner/simulatore/supertrend_oro_long.py`. Dati: oro FTMO M1 2004-2026 (righe 00:00 aggregate scartate), costo 0,35 $ a giro, swap long 5,6%/anno/365 per notte di calendario. Supertrend 10 / 3,0 / hl2 invariato. **Contatore looks cumulativo: 150 (test precedente) + 9 celle nuove.**
## Prove (3 TF: H1, H4, D1 x 3 varianti = 9 celle)
- **BASE:** ingresso all'apertura della barra dopo il segnale long, uscita all'apertura dopo il segnale short (come prima).
- **CHIUSURA:** ingresso e uscita alla chiusura della barra di segnale (come una strategia TradingView con ordini a chiusura barra).
- **FILTRO SMA200:** BASE ma si entra solo se la chiusura del giorno precedente e' sopra la media semplice a 200 giorni dei close giornalieri (un solo valore, 200, nessuna scansione); l'uscita resta al segnale short.
## Controllo della deriva (per ogni cella e per ogni periodo)
**Ingressi casuali con le stesse durate:** per ogni operazione reale (durata in barre) si estrae un ingresso casuale uniforme nello stesso periodo con la stessa durata, stesso costo e stesso swap; si somma il rendimento netto in % di tutte le operazioni; **2.000 simulazioni, seme 12345**. **p = quota di simulazioni con somma >= quella reale.** Se la deriva spiega tutto, p e' alto.
## Periodi
Hold-out dal 01/06/2025; prima: IS = primo 70% delle barre, OOS = ultimo 30%.
## Previsioni (prima dei numeri)
- **Base: il Supertrend batte gli ingressi casuali (p <= 0,05) su tutto il periodo: H4 45%, H1 45%, D1 20%; su almeno uno fra H1 e H4: 55%.** In IS, OOS e hold-out presi da soli (meno operazioni) p <= 0,05 al massimo in 1 caso su 9: 70%.
- CHIUSURA migliora il PF dell'H4 rispetto alla BASE: 40%. SMA200 migliora PF IS e t nell'H4: 45%.
- Almeno una cella supera tutte le porte (sotto): **35%**. Spunto confermato (p <= 0,05 sul periodo intero E porte superate, stessa cella): **25%**.
## Regole di esito (invariate dopo)
**Porte della cella:** IS n >= 30, PF >= 1,3, t >= 2; OOS n >= 15, PF > 1,2; hold-out PF > 1,0 se n >= 8 (altrimenti non valutabile). **SPUNTO CONFERMATO** = una cella passa le porte **e** ha p <= 0,05 contro gli ingressi casuali sul periodo intero. Altrimenti: "non confermato" (deriva non esclusa). Anche se confermato: **spunto da confrontare con GoldenZoe (stesso motore long-only sull'oro), non un EA nuovo**; serve un test a tick sul vero EA. Nessun consiglio di taglie.
