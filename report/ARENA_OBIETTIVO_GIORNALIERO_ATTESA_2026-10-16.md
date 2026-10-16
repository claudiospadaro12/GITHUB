# Arena: obiettivo di profitto giornaliero +500 EUR (chiude tutto e blocca la giornata) e, insieme, stop a -500 -- ATTESA SCRITTA PRIMA DEI NUMERI (16/10/2026)

Richiesta di Claudio: (1) quando la giornata arriva a +500 EUR si chiude tutto; (2) a -500 EUR si chiude la giornata; in entrambi i casi l'EA riapre alle 00:01 del giorno dopo.
Il caso (2) da solo e' gia' stato provato (Guardian a -500: luglio -4.191, settembre +5.439: SMENTITO fuori campione). Si prova ora il (1) da solo e il (1)+(2) insieme.

## Regola (stessa meccanica del Guardian, con segno opposto)
Equita' del giorno = equita' alle 00:00 server (baseline come il Guardian); a fine di ogni minuto, se equita' - equita' di inizio giorno >= +P: chiusura forzata di tutte le posizioni a prezzo di chiusura del minuto, meno 0,3 USD/oncia di scivolamento; la giornata resta bloccata fino alle 00:00 del giorno dopo. Con -L: identico con segno meno. Gli eventi del baseline del giorno dopo riprendono; le posizioni chiuse a forza e i livelli successivi dello stesso ciclo [CID] non esistono piu' (ipotesi dichiarata come per il Guardian).

## Celle (fissate ora, nessuna aggiunta dopo)
- Solo obiettivo P in {300, 500, 750}
- Obiettivo + stop: (P, L) in {(300,500), (500,500), (750,500)}
Campioni: luglio (dal 07/07), settembre interi, agosto 3 giorni (informativo). Strumento: `backtest_pipeline/replay_guardian_arena.py` esteso con `--profitto`, baseline validato.

## Criterio di accettazione (identico alle altre prove)
ACCETTATA come candidata solo se: (a) il saldo finale migliora rispetto al baseline SIA a luglio SIA a settembre; (b) il DD massimo di equita' non peggiora in nessuno dei due mesi; (c) almeno una cella vicina soddisfa a sua volta (a)+(b). Segni opposti fra i due mesi = SMENTITA. Un esito positivo resta "candidata", mai "validata" (due mesi soli).

## Previsione scritta prima [IPOTESI]
Un obiettivo a +500 taglia i giorni buoni (i profitti dei giorni di luglio sono 300-1.000) senza proteggere dalle code: attesa **smentita a luglio**; in combinazione con -500 si ripete il difetto del Guardian (settembre migliora, luglio peggiora). Se invece i numeri la contraddicono, vale il numero.
