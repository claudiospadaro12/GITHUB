# Breaking Band sull'oro — relazione finale (01/11/2026)
**Stato: VALIDAZIONE_NECESSARIA** per il livello "verificato localmente": il test e verificato localmente (codice, dati e documenti con hash, ricalcolo indipendente di tutti i 92 trade, due esecuzioni identiche byte per byte), ma il campione e troppo piccolo per concludere e il punteggio (86/100) e sotto la soglia di 90. Non e un risultato approvato per alcun uso operativo.

## Verdetto sull'ipotesi primaria (H1, continuazione + inversione, 4 periodi dell'oro)
**INCONCLUSIVO**: solo **25 operazioni** (19 continuazione, 6 inversione) contro il minimo di 30. Non si puo dire ne che la traduzione funzioni ne che non funzioni.
| | n | win rate | PF netto | media R netta |
|---|---|---|---|---|
| H1 pooled (primaria) | 25 | 64% | 0,51 | -0,16 |
| H1 continuazione | 19 | 58% | 0,42 | -0,22 |
| H1 inversione | 6 | 83% | 1,13 | +0,02 |
| M30 (esplorativa) | 67 | 70% | 0,67 | -0,09 |
IC90 della media H1: da -0,36 a +0,03 R (descrittivo). Rispetto agli ingressi casuali con la stessa geometria (media -0,01 R): p = 0,93, cioe il pattern ha fatto peggio del caso. Senza il 2013 la media diventa +0,05 su 16 trade: il segno dipende da un anno solo. Nessuna sensibilita (8) e nessuna variante supera PF 1,15.

## Perche i numeri sono cosi (fatti verificati)
- **Geometria sfavorevole:** i segnali cadono in bande strette; target a circa 1 ATR (0,23-1,74) contro stop a 3 ATR: serve vincere circa il 77-78% per pareggiare; il win rate osservato e 64-70%. (Previsione scritta prima: 58-70% — sbagliata.)
- **Rarita:** il 61% degli episodi di bulge muore perche l'impulso supera 20 barre (regola "band riding" della Guida); la SEQ e il cancello sulla deviazione standard sono quasi inerti.
- **Nessun filtro azzera i segnali**; spread coerente (circa 0,02-0,03 R per trade).

## Verifiche
Documenti, codice e 4 CSV congelati con sha256 prima del run (events.jsonl, congelati/). Test sintetici: motore 30, segnali 31, runner 11. A7: reimplementazione indipendente con zero divergenze di segnali su H1 e M30; 92 trade ricalcolati dalle M1, identici; B1/B0 ricostruite da zero; stesso hash del risultato in una seconda esecuzione. Riserve dichiarate: placebo INV_H1 NON_CONCLUSIVO al tetto di 300 anni (a 700 anni sintetici passa); un mutante sul picco (S03) non lo vedono i test di A4 ma e coperto dal confronto con A7; ER=0,50 e un confronto in virgola mobile fragile (non cambia nessun numero); T3, T6, B2 non ricalcolati da A7.

## Limiti e perimetro (da riportare sempre)
1. **XAUUSD e fuori dallo scopo dichiarato dalla Guida** (major/minor, D1/H4/H1/M30). M15 non e stato testato. Un esito negativo qui non confuta la strategia sui cross forex; uno positivo non la confermerebbe.
2. Fonte: la Guida usata e quella ufficiale (confermato da Claudio, D006); mancano la Dichiarazione di Test (solo etichette) e lo screenshot standard.
3. Le soglie "molto/ordinato" sono mie interpretazioni; i pattern testati sono un soprainsieme dei validi per l'autore; stop 3 ATR, target SMA20 e ricalcolo 3 ore vengono da Guida/Protocolli.
4. 4 periodi = 4 regimi; dati a 1 minuto (non tick); non misurati slippage, commissioni, swap, regole prop. Giudizio visivo e news non misurabili.
5. Configurazioni esaminate: 1 primaria + 3 sottoviste M30 + 8 sensibilita; le esplorative non selezionano nulla.
6. Previsioni scritte prima: 12 giuste, 6 sbagliate (Q1, Q5, Q14a, Q17, Q19, Q23), 7 non valutabili; Brier 0,218 (A6).

## Punteggio (griglia D001; C0, sulle evidenze di A6/A7)
Aderenza 85, Correttezza 90, Completezza 80, Fattibilita 85, Utilizzabilita 85, Verificabilita 90, Espositiva 85 -> **86/100** (soglia 90 non raggiunta; nessuna dimensione sotto 80).

## Prossimi passi proporzionati
1. **Estensione pre-registrata sui cross forex e indici (ambito della Guida)**, con lo STESSO codice congelato e criteri scritti prima: appena arrivano i CSV dal PC di backtest (export multi-simbolo in corso). Non allentare le soglie sull'oro.
2. Se anche l'estensione e inconcludente o negativa: la Breaking Band resta una strategia discrezionale; nessun EA su conti reali.
3. Non usare questo risultato per decidere lotti o conti: non misura la versione discrezionale ne i cross forex.
