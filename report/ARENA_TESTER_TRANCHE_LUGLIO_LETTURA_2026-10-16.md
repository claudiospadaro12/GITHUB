# Arena nel tester -- LUGLIO (TRANCHE1) e prova FUORI CAMPIONE del Guardian a -500 EUR (16/10/2026)

Zip `ARENA_TESTER_TRANCHE.zip` del giro v4 (pin `24aa4bd3`, `-Tranche 1`), PC di backtest, partito 15/10 22:15, REFERTO 16/10 02:26. Archivio: `backtest_pipeline/risultati_archivio/ARENA_TESTER_TRANCHE_20261016_LUGLIO/`. Barre M1: `data/prezzi/XAUUSD_M1_BCM_2026-07-06_07-31.csv` (dal 06/07 14:08).

## 1. Giro conforme [MISURATO]
Marcatore v4 + pin v4, `.ex5` UGUALE (SHA `B261E252...`, stessa di agosto e settembre), input confermati, deposito 5.000, leva 1:100, ticks reali 100%, durata 14.961 s = **249 minuti**.

## 2. Numeri di luglio (lotto base 0,01)
- 13.498 operazioni, **netto +4.800,36 EUR, PF 1,21**, **nessuno stop out**.
- DD equita' massimo **5.284,37 (45,93%)**, DD saldo 3.296,24 (27,98%).
- Cesti [R]: 2.380, netto [R] +4.575,60; profondita' massima **39**; **>=10 livelli: 43 cesti, -3.768,80**; peggior cesto -3.129,85.
- Giorni di coda: 17/07 -1.351 (22 ingressi), **24/07 -3.162 (2 ingressi)**, 31/07 -767; equita' minima del giorno 22/07 -3.001 (60%), 24/07 -3.875.

## 3. Ipotesi H1-H4 (regole scritte prima) con TRE tranche conformi o parziali
- **H1 (stop out in almeno una tranche): REGGE** (agosto 05/08, settembre 28/09; luglio no).
- **H2 (cesti >=10 livelli in perdita in ogni tranche conforme): REGGE su tutte** (luglio -3.769, agosto -3.963, settembre -11.992).
- **H3 (cesti >=10 in almeno due tranche su tre): REGGE** (presenti in tutte e tre).
- **H4: NON SI DECIDE** (nessuna tranche senza cesti profondi).

## 4. PROVA FUORI CAMPIONE del Guardian -500 (attesa scritta il 15/10 PRIMA dei numeri)
Attesa: *regge* se il saldo finale con Guardian e' piu' alto di quello del tester e il DD massimo scende; *smentita* se e' piu' basso o il DD non scende.
Replay (`backtest_pipeline/replay_guardian_arena.py`, 07-31/07, baseline validato: saldo finale 9.800,36 = report):
- **Guardian -500: saldo 5.610 contro 9.800 del tester = -4.191 EUR**; 9 giorni fermati su 22; DD massimo di equita' 3.283 contro 5.182. Con slip 0,3: 5.458; con 1,0: 5.104; valutazione peggiore (low/high): 6.780.
- Altri limiti: -300: 5.755; **-750: 3.292; -1.000: 2.076; -1.500: -1.341** (nessun limite batte il tester).
- **Esito: SMENTITA** (saldo piu' basso), anche se il DD scende. Settembre dava +5.439, luglio -4.191: stesso strumento, segno opposto.
- Perche' [INFERITO dai numeri]: in luglio i cesti profondi (fino a 39 livelli) tornano in profitto dopo aver toccato perdite flottanti di 1.000-3.400 EUR; lo stop a -500 li chiude in perdita. In settembre gli stessi cesti non tornano. Profitti e coda sono lo STESSO meccanismo: uno stop giornaliero non li separa.
- Somma delle due tranche piene: tester +2.295 (luglio +4.800, settembre -2.505); con Guardian -500 circa +3.544 (luglio +610 dal 01/07, settembre +2.934): +1.249 in due mesi con segni opposti: **non e' un risultato robusto**.
- Verdetto di casa: **il Guardian a -500 NON e' la soluzione** per l'Arena; la candidatura scritta il 15/10 sera («candidata seria») e' ritirata dalla sua stessa smentita.
