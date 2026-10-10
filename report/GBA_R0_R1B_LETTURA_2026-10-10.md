# GBA R0 lotto R1B -- lettura del 10/10/2026 (zip `GBA_R0_R1B.zip`, pin 2f4a2a5b)

Lettore: `leggi_gba_r0.py` nella versione che ha passato il cancello (commit a18412fc); output integrale in `LETTURA_leggi_gba_r0_R1B.txt`.
9 passate, 9 OK, 0 KO, Modello 4 (100% tick reali), 19 minuti in tutto (56 s a passata; stima era 27-180). Compilazione 0/0. Una variabile: `InpSpreadMaxATR`.

| cella | n (3 tranche) | PF_V | PF_V per tranche T1/T2/T3 | costo mediano stop/spread (+0,04) | BUY / SELL PF_V |
|---|---|---|---|---|---|
| 0,10 | 3918 | 0,830 | 0,80 / 0,78 / 0,87 | 28,2x | 0,91 / 0,76 |
| 0,20 | 6949 | 0,819 | 0,76 / 0,79 / 0,87 | 20,6x | 0,89 / 0,76 |
| 0,35 | 7420 | 0,817 | 0,77 / 0,78 / 0,87 | 19,9x | 0,89 / 0,76 |
(REPL 0,05 di R1A: PF_V 0,855 su 933.)

## Cosa dicono i numeri (un regime: gen-set 2026)
- **Allargare il filtro di spread NON cambia il PF**: 0,83 / 0,82 / 0,82 su 3,9k / 6,9k / 7,4k operazioni. Altopiano piatto SOTTO 1. Il filtro di spread non e' la causa.
- **Costo**: nessuna cella arriva alla frontiera 40x (mediane 28 / 21 / 20); con 0,20 e 0,35 il 12-18% degli ingressi sta sotto il duro 13,3x. Cella stretta = meno ingressi, stesso PF.
- **Lato**: lo SHORT e' sistematicamente peggiore (0,76 contro 0,89-0,91), coerente in tutte e 3 le celle.
- **Ora (S6)**: europa PF_V 0,55-0,61 e rollover 0,50-0,53 sopra la soglia corretta con segno concorde 3/3. **La notte asiatica (00-07) NON e' positiva**: PF_V 0,87-0,92 con n 922-2441 (n>=150), segno negativo in 3/3 tranche; p=0,028-0,456, sopra la soglia 0,0083 => "non distinguibile da zero", ma il punto stimato e' sotto 1. La pausa 12-14 (PF_V 1,05-1,15, n 451-750) ha lo stesso segno in 1 tranche su 3: non stabile.
- **Concentrazione**: migliore operazione = 1% del profitto positivo; netto senza le 5 migliori negativo. Non e' un risultato "di pochi colpi".
- **DA GUARDARE**: gli errori del giornale (chiusura a tempo, spostamento SL, ordine) sono TUTTI `retcode 10018 (market closed)` attorno alle 22:00-22:35 server (pausa giornaliera), concentrati in T3 (fino a 174 chiusure a tempo, 150 spostamenti SL, 91 ordini non eseguiti su ~2400): stesso fenomeno gia' visto in R1A, non cambia il segno.

## Esito (S4/S7, criteri scritti prima)
PF_V < 1,0 in tutte e tre le celle: la dichiarazione di Emiliano NON regge sul nostro feed, in un regime (2026) e a M1. **Non e' "morto"**: mancano le caselle 3 (uscita ad asse), 4 (simboli gemelli), 5 (TF); la prova di regime R2REG e il giro R2 restano da fare.
