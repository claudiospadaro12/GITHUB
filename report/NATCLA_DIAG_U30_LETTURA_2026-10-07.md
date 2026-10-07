# NATCLA DIAG U30 - lettura del 07/10/2026 (23:07-23:10, PC di backtest, demo 50503392, pin f6551cdd)

Fonte: `backtest_pipeline/risultati_archivio/NATCLA_DIAG_U30_20261007/`. EA diagnostico di sola lettura, 6 passate H1 Modello 1, compilazione 0 errori/0 avvisi, 28-30 s a passata.

## Il verdetto del driver e' un artefatto di lettura, i dati sono tutti completi
Il MANIFEST dice KO 6/6 con "PIU righe RIASSUNTO distinte (2)". In ogni log la riga RIASSUNTO compare DUE volte: una **troncata a 489 caratteri** e una **completa** (765-852 caratteri, `fine=1`). Il driver le conta come due righe diverse e butta la passata. I numeri sotto sono letti dalla riga completa (stessa lettura per tutte e 6). Difetto del driver, classe 1173 in CHECKLIST.

## Risultati (dalla riga completa)
| passata | sep | cd_ok / nuove | primo_ok | BarsCalculated EMA200 (min/max) | cosa cade |
|---|---|---|---|---|---|
| (d) EURUSD 2024.09.26 CONTROLLO | si | 10861/10861 | prima barra | 10803/21663 | niente |
| (a) U30USD 2024.09.26 | si | 9761/9946 | 2024.10.16 12:00 (302 barre) | -1 / 10061 | solo le prime 185 barre (n<300) |
| (e) U30USD 2024.09.26 SOLO CATENA | no | **0**/9946 | MAI | **-1 / -1** | **cd_bc = 9761** (BarsCalculated EMA200 = -1 a ogni barra dopo la 302a) |
| (c) D30EUR 2024.09.26 | si | 9453/9639 | 2024.10.16 14:00 | -1 / 9753 | solo le prime 186 barre |
| (f) D30EUR 2024.09.26 SOLO CATENA | no | **0**/9639 | MAI | **-1 / -1** | **cd_bc = 9453** |
| (b) U30USD 2025.01.02 (storia davanti) | si | 8600/8600 | **prima barra** | 1462/10061 | niente |

## Lettura (attese scritte PRIMA, ramo "tester pigro")
- Il controllo positivo (d) passa: la diagnosi non e' rotta.
- **(e) e (f) riproducono il KO del pilota** con la catena dell'EA alla lettera: cd_ok=0, e l'unica condizione che cade e' `BarsCalculated(hEma200) < n+1`: l'EMA200 resta a **-1** per tutta la finestra. cd_cr = cd_cb = 0: CopyRates e CopyBuffer non vengono mai raggiunti.
- **(a) e (c), identiche a (e) e (f) salvo le verifiche separate (che chiedono un buffer), guariscono da sole** alla barra 302: nel primo evento il CopyBuffer dell'EMA200 risponde errore 4806 (dati non ancora pronti), poi l'indicatore si calcola e BarsCalculated sale a 301. Quindi nel tester gli indicatori si calcolano SOLO quando si chiede un buffer (classe 1171): `CaricaDati()` chiede `BarsCalculated` PRIMA di qualunque `CopyBuffer`, e quando l'indicatore non si e' calcolato alla creazione (qui: 117 barre di storia < 200 periodi, il tester ha anche spostato l'inizio al 2024.10.04 "to provide data at beginning") non lo chiede mai. **Stallo.**
- **(b) conferma la via senza toccare l'EA**: con ~1460 barre di storia davanti l'EMA200 e' calcolata alla creazione (BarsCalculated 1462 gia' alla prima barra) e l'EA lavora dalla prima barra, come per EURUSD e XAUUSD nel pilota.
- **Classe:** U30USD e D30EUR si comportano allo stesso modo => vale per gli indici BCM (storia dal 26/09/2024), non per il solo U30USD. Gli altri 8 indici del lotto C sono NON MISURATI ma attesi uguali.
- Forex e oro: storia davanti => nessun KO (lotti PILOTA/B/D). Lotto A: non ancora ricevuto.

## Cosa serve ora (il lotto C resta fermo finche' il rimedio non e' riprovato su U30USD)
1. **Rimedio nell'EA (v1.05):** "toccare" ogni handle con `CopyBuffer` prima del controllo `BarsCalculated` (o al posto di esso), cosi' il tester calcola l'indicatore. E' una modifica a un file pinnato: nuovo EA, nuovo pin, collaudo, cancello. Dal vivo non cambia nulla (gli indicatori si calcolano comunque). **Da riprovare su U30USD e D30EUR con riga VERIFICA ADX stampata e righe CONTA nel CSV** prima del lotto C.
2. Alternativa senza toccare l'EA: FromDate con ~300 barre davanti all'inizio dello storico BCM (circa 2024.11.15 per gli indici), ma costa ~7 settimane di finestra e peggiora H12/D1: non e' la via preferita.
3. Il driver F0 non e' toccato da questa lettura; la sua regola "riga uguale ma troncata" va resa tollerante (classe 1173) quando si rigenera.
