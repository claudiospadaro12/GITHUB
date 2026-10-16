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

## ESITO (16/10/2026, griglia completa di 10 celle, slip 0,3; tabella in `ARENA_REGOLE_RISCHIO_GRIGLIA_2026-10-16.txt`)
Variazione del saldo finale rispetto al tester (replay validato al centesimo) -- LUGLIO | SETTEMBRE | agosto 3 giorni:
- profondita' 8: -4.815 | +275 | +2.949; 10: -4.071 | +92 | +3.130; 12: -4.612 | +3.742 | +3.645; 15: -1.742 | -828 | +3.906
- stop cesto 300: -4.620 | +59 | +3.031; 500: -5.645 | +1.684 | +2.934; 1000: -4.825 | +1.847 | +3.045
- stop a tempo 6 h: -4.189 | +732 | +1.775; 12 h: -4.749 | -1.376 | +1.024; 24 h: -1.897 | -725 | 0
**Esito secondo il criterio scritto prima: 10 celle su 10 SMENTITE** (nessuna migliora il saldo di luglio; la meno cattiva, profondita' 15, perde -1.742 a luglio e -828 a settembre). Il DD di equita' scende quasi sempre, ma costa il profitto di luglio.
Lettura [INFERITA]: ogni regola che CHIUDE i cesti taglia anche quelli che in luglio rientrano dopo 1.000-3.400 EUR di perdita flottante; i cesti buoni e i cattivi hanno lo stesso aspetto finche' non rientrano. Nessuna regola di chiusura trovata. Non si allarga la griglia dopo aver visto i risultati.
Resta una famiglia NON simulabile con questi dati: regole sul DIMENSIONAMENTO (il lotto minimo e' 0,01) e su un limite al numero di livelli che l'EA APRE (richiede l'EA, che e' di terzi).
