# Sonda delle specifiche dei simboli: criteri (24/10/2026, scritti PRIMA dei numeri)
**Natura: LETTURA.** Script `mql5/Scripts/ABTG_SondeSpecifiche.mq5` (nessuna funzione di trading, mai compilato prima di questo round), lanciato dalla riga `RIGA_LANCIA_SONDE_SPECIFICHE_PC.txt` sul PC di backtest, terminale `C:\Program Files\BCM Markets MT5 Terminal` (demo 50503392) con lo `[StartUp]`, come le sonde S1-S4. Lettore congelato: `backtest_pipeline/sonda_spec_giudizio.py` (autotest). Risponde ai quesiti **A1** e **A2** del giro 3. Simboli: U30USD, NASUSD, D30EUR, 225JPY, XAUUSD, AUDCHF, CHFJPY, GBPUSD, EURJPY.

## A1: il pendente "20 pip" viene rifiutato dal server?
- Distanza del pendente in punti: `d = 20 * pip / point`, con `pip = point` a 0, 1, 2 o 4 cifre e `pip = 10*point` a 3 o 5 cifre (come `PipSize()` dell'EA, VERIFICATO sul sorgente DAX r.122-126).
- Per ogni simbolo: **RIFIUTATO DAL SERVER** se `StopsLevel > d`; **AMMESSO** se `StopsLevel <= d`. Si riporta anche `FreezeLevel`.
- Lettura combinata con i fatti del forward (CSV): NASUSD 0 gambe 2/3 su 9 ingressi, 225JPY 0 su 5, il gemello DAX 970911 le ha. **COERENTE** se NASUSD e 225JPY sono RIFIUTATI e D30EUR AMMESSO; **NON SPIEGA** se NASUSD e 225JPY sono AMMESSI (la causa resta NON TROVATA); **CONTRADDITTORIO** se D30EUR e RIFIUTATO (il giro del 29/07 mostra la gamba riempita: la specifica di oggi puo' essere diversa da quella di agosto).
- Limite: le specifiche sono quelle di OGGI, non di agosto-settembre. Il Giornale Esperti del VPS (le righe "pendente 2/3") NON e raggiungibile da questa sonda: meta' di A1 resta NON FATTA.

## A2: soglia del pavimento del lotto
Per ogni simbolo `vpp = tick_value / tick_size * point` (EUR per punto per lotto, valuta del conto), e per saldo S in {5.344 (PACCHETTO_R4, DICHIARATO), 5.000 (cifra di Claudio, NON VERIFICATA)} e rischio R in {1,0; 0,65; 0,5; 0,3; 0,25}:
`stop_soglia = S * R/100 / (vol_min * vpp)` punti. Con uno stop **sotto** `stop_soglia` il lotto calcolato e' sotto il minimo e il **pavimento** lo alza al minimo (rischio vero > dichiarato); sopra, il pavimento non morde. Nessuna taglia: e' solo la soglia. Si stampa anche `vol_min`, `vol_step`, `vpp`.

## Attese dichiarate ORA
P1 la sonda compila e parte 85%. NASUSD StopsLevel > 20: 45%. 225JPY StopsLevel > 20: 45%. D30EUR StopsLevel <= 20: 70%. U30USD vol_min = 0,10: 85%. Swap non zero sugli indici: 80%.

## Limiti
Un solo terminale e un solo momento (sabato, mercato chiuso: bid/ask possono essere a zero, non serve qui). Non misura gli ordini veri: dice cosa il server dichiara, non cosa accade. Non promuove niente, non tocca sedie, preset, conti, taglie.

## ERRATA del 24/10/2026, scritta DOPO aver visto i numeri (il criterio A1 non cambia)
Il criterio A2 qui sopra ha due errori, scoperti leggendo il CSV: (1) la frase sul pavimento e' al contrario: `lotto_calcolato = rischio / (stop * vpp)`, quindi il pavimento MORDE con uno stop **sopra** `stop_soglia`, non sotto; (2) per gli indici il server riporta `tick_value` nella valuta del simbolo (USD, EUR, JPY), non in EUR. La tabella A2 del lettore congelato (`sonda_spec_giudizio.py`) e' quindi valida solo per XAUUSD e le coppie forex (valore gia' in EUR, unita' = point di MT5) e NON per gli indici. Il ricalcolo corretto e' a posteriori: `backtest_pipeline/sonda_spec_a2_post.py`.
