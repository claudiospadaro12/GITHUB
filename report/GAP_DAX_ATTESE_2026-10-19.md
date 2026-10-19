# Test del gap del DAX (apertura cash) -- ipotesi scritte PRIMA di ogni numero (19/10/2026)

Origine: la live di Emiliano del 19/10 (lunedi): "se l'apertura e' in gap, i prezzi devono andare a chiudere il gap"; lui si mette sulla chiusura del gap invece che sul numero tondo, ordini divisi sopra/sotto, stop sotto la media. **La trascrizione non da' nessun numero** (ne' soglia di gap, ne' tasso di chiusura, ne' stop): qui si fissano numeri nostri prima di vedere i dati. Non e' stato rivisto da agenti.
**Cosa c'e' gia'**: `APERTURE_DAX_MAPPA_2026-10-03.md` r.86: il GAPFILL del motore ha avuto 7 su 9 deal perche' sul CFD "il gap" era lo stacco di mezzanotte del D1, **non** il gap della cash: *campione inesistente, non un gap-fill*. `ABTG_GapContinuation` (gap-down SHORT): PF 0,898 su 29 posizioni, merito sospeso. Questo test e' diverso: il gap e' definito da barre M1 fra due orari fissi, non dal D1.
**Dati**: NON ci sono prezzi DAX nel repo (solo XAUUSD) e da questa sessione non si scaricano (rete limitata). Servono le barre M1 del D30EUR dal terminale del PC di backtest: `mql5/Scripts/ABTG_GapDAX_Export.mq5` (sola lettura, NON compilato qui). **Nessun numero e' stato visto.**

## Definizioni (ORA SERVER BCM = ora italiana meno 1)
- **Chiusura cash precedente (PC)**: chiusura dell'ultima barra M1 con orario <= 16:30 server del giorno di borsa precedente con dati (il lunedi' e' il venerdi').
- **Apertura (A)**: open della barra M1 delle 08:00 server (09:00 IT).
- **Gap** = A - PC; in percentuale di PC. **Evento** se |gap| >= **0,15%** di PC (soglia fissata ORA, non cambiata dopo).
- **Chiuso** = nella finestra 08:00-16:30 server il prezzo torna a PC (gap-up: low <= PC; gap-down: high >= PC).
- Controllo di allineamento **prima** di leggere qualunque risultato: nel file `ABTG_GapDAX_orevol.csv` il volume medio per ora deve avere il picco tra le 08:00 e le 09:00 server. Se il picco e' altrove, l'ora e' sbagliata e il test si rifa' con l'ora corretta, dichiarandolo.

## Ipotesi
- **G1 (tasso di chiusura)**: su tutti gli eventi, **>= 70%** chiudono il gap entro le 16:30. *Smentita*: < 70%. Non si decide con meno di 100 eventi ("NON MISURATA").
- **G2 (lunedi)**: stesso >= 70% sugli eventi del solo lunedi'. *Smentita*: < 70%. Non si decide con meno di 30 eventi.
- **G3 (regola operativa, costi inclusi)**: entrata a mercato sulla barra delle 08:00 verso la chiusura del gap; **TP = PC**; **stop = 1,0 x |gap|** oltre l'entrata dalla parte opposta; uscita forzata alle 16:30 al close della barra. Costi: spread della barra + 1 punto di slippage per lato. Nello stesso minuto TP e stop: si assume lo stop (ipotesi pessimista). Periodo diviso in meta' per data (**IS** = prima meta', **OOS** = seconda): **profit factor OOS >= 1,2 con almeno 100 operazioni OOS, e PF IS >= 1,0**. *Smentita*: PF OOS < 1,2, o PF IS < 1,0, o la smentita di G1. Nessun parametro (0,15%, stop 1,0x, TP=PC) si cambia guardando l'OOS.
- **Descrittivo, non giudica**: MAE (quanto va contro prima di chiudere) in multipli del gap, tempo medio di chiusura, distribuzione per giorno della settimana.

## Cosa NON e' misurato
- Tester CFD BCM, non cash XETRA: il CFD tratta anche prima delle 09:00 IT, quindi il "gap" qui include il movimento pre-apertura; la live parla del gap che vede a grafico (stessa definizione, ma non e' verificabile dalla trascrizione).
- Slippage reale dell'ordine a mercato alle 08:00 (l'apertura e' il momento di spread piu' largo).
- Quante barre M1 ha lo storico del terminale: se la finestra e' corta, G1/G2/G3 possono restare "NON MISURATA".
