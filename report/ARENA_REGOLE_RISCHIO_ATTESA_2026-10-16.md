# Arena: ricerca di una regola di rischio DIVERSA dal Guardian giornaliero -- ATTESA SCRITTA PRIMA DEI NUMERI (16/10/2026)

Contesto: il Guardian a -500 EUR/giorno e' stato SMENTITO fuori campione (luglio -4.191 contro +5.439 di settembre). Lezione: profitti e coda dei cesti sono lo stesso meccanismo, uno stop sul GIORNO taglia anche i cesti profondi che poi rientrano. Quindi le regole da provare agiscono sul singolo CESTO [R] (CID), non sul giorno.

## Regole candidate (una sola famiglia di parametri ciascuna, griglia fissata ORA)
1. **Tetto di profondita'** N in {8, 10, 12, 15}: quando il cesto apre il suo N-esimo livello [R], si chiude tutto il cesto.
2. **Stop sul cesto** X EUR in {300, 500, 1000}: si chiude il cesto quando la sua perdita flottante (valutata alla chiusura del minuto) raggiunge -X.
3. **Stop a tempo** T ore in {6, 12, 24}: si chiude il cesto T ore dopo il suo primo ingresso.
Strumento: `backtest_pipeline/replay_guardian_arena.py` esteso con `--regola`, stessi deal del tester, barre M1 BCM, scivolamento 0,3 USD/oncia alla chiusura forzata, baseline validato al centesimo contro i report.
Campioni: luglio (dal 07/07), settembre interi; agosto solo 3 giorni (informativo). Nessun altro mese e' disponibile: **un esito positivo restera' "candidata", mai "validata"**.

## Criterio di accettazione (fissato prima di guardare i numeri)
Una regola con un parametro e' **ACCETTATA come candidata** solo se TUTTE e tre:
(a) il saldo finale migliora rispetto al baseline sia a LUGLIO sia a SETTEMBRE;
(b) il DD massimo di equita' non peggiora in nessuno dei due mesi;
(c) NON e' un picco isolato: almeno uno dei parametri vicini nella griglia soddisfa a sua volta (a)+(b).
Altrimenti **SMENTITA**. Con segni opposti fra i due mesi la regola e' smentita (lezione del Guardian giornaliero).
Selezione del parametro: il CENTRO della zona che soddisfa il criterio, mai il picco.
Si calcolano tutte e dieci le celle (4+3+3) e si riportano TUTTE, anche quelle sfavorevoli: 10 celle su 2 mesi = rischio di cella verde per caso (regola del 19/08): si dichiara.
Non si allarga la griglia dopo aver visto i risultati.

## Cosa NON potra' dire
Nessun mese fuori da luglio-settembre; tester con margine 4,8 volte quello reale; niente slippage vero; lotto 0,01 di base; un'unica fonte (Arena di terzi, scatola nera).
