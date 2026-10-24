# Scansione dei nuovi EA del Market e quali richiedono il set: criteri scritti PRIMA di ogni numero (24/10/2026)

> **AGGIORNAMENTO del 24/10/2026 (stesso giorno, prima di qualunque numero dei nuovi EA): il deposito del setaccio e' 80.000 EUR, non 5.000.** Richiesta di Claudio: capitale di riferimento sempre 80K, FTMO Pro. La riga a 5.000 (`RIGA_LANCIA_SETACCIO_MARKET_NUOVI.txt`) e' SUPERATA e rimossa; vale `RIGA_LANCIA_SETACCIO80K_MARKET_NUOVI.txt` (script `SCREEN80K_TESTER_TRANCHE.ps1`, cartelle `SCREEN80K_*`). Tutto il resto resta uguale (XAUUSD, 01/01-01/03/2026, H1 e M15, input di default, tick reali, leva 1:100 come DEEP80K). Dove sotto compare "5.000" leggi 80.000; **R2 (lotto troppo grande) vale al deposito del test**: a 80.000 e' molto piu' difficile da raggiungere, quindi un "no money" a 80K e' un segnale serio. Le attese dichiarate restano, ma la quota di nuovi che operano con i default sale (80%).
**Natura: LETTURA + screening nel tester.** Richiesta di Claudio (24/10): "ho scaricato altri EA: fai la scansione e dimmi di quali necessiti eventualmente i set." Nessuna decisione di acquisto, nessuna taglia.

## Cosa fa la riga (RIGA_LANCIA_SETACCIO_MARKET_NUOVI.txt, solo sul PC di backtest)
1. Legge `MQL5\Experts\Market` del terminale BCM del PC di backtest e scrive l'**elenco**: per ogni `.ex5` nome, stato (NUOVO o GIA' CONOSCIUTO), con motivo. Sono "gia' conosciuti" i **31 `.ex5` censiti il 19/10** (25 setacciati con `SETACCIO_MARKET_20261019` + i 6 con giro dedicato: Arena, Gold Trade Pro, Goldbot One, The Gold Phantom, The Gold Reaper, The Impossible Gold). Un `.ex5` conosciuto ma con **impronta diversa** da quella del 19/10 non e' riconosciuto qui: l'elenco riporta nome, byte, data e SHA256 di **tutti**, cosi' un aggiornamento del Market si vede.
2. Per ogni EA **NUOVO** fa lo stesso **setaccio** del 19/10 ma **a 80.000 EUR**: XAUUSD, 01/01-01/03/2026, H1 e M15, input di default, tick reali, leva 1:100. Regole del setaccio invariate (S1-S6, `SETACCIO_MARKET_ATTESE_2026-10-18.md`): **non** serve a giudicare il profitto, ne' a scegliere il periodo, ne' a decidere un acquisto.
3. Se non ci sono EA nuovi la riga si ferma dopo aver scritto l'elenco (nessun tester parte).

## Regole del "SET" (decise ORA; lettore `backtest_pipeline/leggi_setaccio_nuovi.py`)
Per ogni EA nuovo, dai due report (H1, M15), dal manifest e dai giornali:
- **R1 SET NECESSARIO (non opera):** 0 operazioni in entrambe le passate e nessuna riga "no money" (cause da cercare: simbolo, periodo, input da impostare, licenza/demo limitata, dipendenza da URL/calendario).
- **R2 SET NECESSARIO (lotto troppo grande per il deposito del test, 80.000 EUR):** meno di 10 operazioni in entrambe le passate **e** almeno 100 righe "no money" nei giornali (come Night Scalper il 19/10): serve un set con lotto o rischio piu' piccoli, oppure un deposito maggiore (decisione di Claudio).
- **R3 SET NECESSARIO (strumento):** l'EA ha operato anche su un simbolo diverso da XAUUSD, oppure un suo input con `symbol` nel nome ha un valore che sembra un simbolo diverso da XAUUSD (non `true`/`false`/numeri): non e' un EA da oro e serve il set del suo strumento (come Waka Waka e Range Breakout).
- **R4 SET NECESSARIO (credenziali o servizi esterni):** un input il cui nome richiama licenza, password, token, API, URL, e-mail, seriale, segreto, slug o login (`licen[sc]e|passw|token|api|url|e-mail|serial|activation key/code|secret|slug|username|login`) e' **vuoto o segnaposto** (vuoto, `xxx`, `your`, `enter`, `none`, `0000`); oppure un nome di input richiama `polymarket|http` (servizio esterno non simulabile). I filtri news e calendario sono onnipresenti negli EA e **non** sono R4: si riportano solo come nota (nel tester il calendario MT5 non c'e', il filtro non agisce).
- **R5 SET CONSIGLIATO:** 1-9 operazioni in entrambe le passate e nessuna R1-R4 (S1 "opera poco").
- **NON NECESSARIO (per lo screening):** almeno 10 operazioni in una passata e nessuna R1-R4.
- **Esito generale:** NECESSARIO se vale una qualunque tra R1-R4; CONSIGLIATO se vale R5; altrimenti NON NECESSARIO. Si riportano **tutte** le regole che valgono, non solo la prima.
- **Cosa NON dice:** "default sufficienti per lo screening" **non** vuol dire che i default siano quelli raccomandati dal venditore: prima di un test a fondo la pagina del Market del venditore (o i suoi screenshot degli input) puo' comunque chiedere un set. Questo il tester non lo vede.
- **S5 (descrittivo):** si elencano anche gli input che richiamano recupero/griglia/martingala/piramidazione (come nel setaccio del 19/10).

## Attese dichiarate ORA
P1 la riga parte e l'elenco e' scritto: 90%. Almeno un EA nuovo trovato: 80% (l'utente ha scaricato "altri EA"). Fra gli EA nuovi: almeno uno con R3 (non solo oro) 40%; almeno uno con R1, R2 o R4: 45%. Quota di nuovi che operano con i default (>= 10 operazioni): 65%.

## Limiti
Le demo del Market possono avere funzioni limitate (NON VERIFICATO per ciascuna). Due mesi e due periodi sono una sonda. Se lo stesso EA e' stato provato prima nel tester su questo PC, gli input salvati possono non essere i suoi default (NON VERIFICATO, come il 19/10). I nomi file `.ex5` identici a quelli del 19/10 ma aggiornati dal Market non si distinguono per nome: usare l'impronta nell'elenco.

## Taratura delle regole (dichiarata)
Le regole R3 e R4 sono state AFFINATE il 24/10 dopo averle provate sui 25 report VECCHI del 19/10 (non sui nuovi): la prima stesura contava come R4 ogni filtro news e come R3 i valori `true`/`false`. Sui vecchi report le regole affinate devono ritrovare: Night Scalper (R2), Waka Waka e Range Breakout (R3), PolyGold (R4, Polymarket) e Quantum Commander (R3, input US30). Seconda passata di affinamento (sempre sui vecchi): `polymarket|http` si cerca solo nei nomi di input che sono identificatori (non nelle etichette con spazi o link), e un simbolo ha almeno 4 caratteri (non `EUR`, `USD`). Nessun numero dei nuovi EA era noto quando sono state affinate.
