# Piano: motore GoldenZoe (trend following long) su piu' mercati per la flotta (20/11/2026)

**Obiettivo:** EA scorrelati per prop (FTMO) e reale, con lo stesso motore gia' verificato sull'oro (Donchian 55, stop iniziale 3 ATR, Chandelier 3 ATR, long-only, `GoldenZoe_H4`). **Non si promette un EA per mercato:** il vantaggio va misurato mercato per mercato, con soglie scritte prima. Vincoli: solo tester e demo, nessun consiglio di taglie, VPS e reale non toccati.

## 1. Cosa abbiamo gia' misurato (da non rifare)
- **Screen D1 su 33 mercati (19/11, 116 prove valide):** IS (fino al 2014) PF >= 1,3 in 13 (11%); IS+OOS in 6 (5%). **Classe che segue il trend: indici, solo LONG: Hang Seng e Nikkei 225.** Energia, metalli (a parte l'oro), agricoli: nessuno. Short: perde (deriva). Hold-out 2025+: **Nikkei regge (N20 PF 2,99 su 9 operazioni; N55 PF 1,87), Hang Seng no.** Nasdaq 100, S&P 500, Dow, DAX, Russell: vicini alla soglia (non passano IS o OOS). Bitcoin ed Ethereum esclusi per storico corto.
- **Oggi (20/11):** Donchian D1 su 8 mercati (BTC, ETH, oro, argento, WTI, DAX, Nasdaq100, S&P500): base IS R +0,57 (PF 1,62), OOS R +0,11 (PF 1,12); tutto sul lato long (+1,15 / +0,31 R); l'efficienza di Kaufman come filtro non aiuta. BTC e ETH D1 trend con uscita sul cambio segnale: IS e OOS positivi (BTC PF 3,98 / 2,68, concentrato in 5 operazioni su 156; Ethereum OOS PF 1,67).
- **Correlazione GoldenZoe oro contro Nikkei D1 long-only:** circa 0 (262 mesi).
- **Costi:** BCM: swap long indici 10-14% annuo, oro -9,7% annuo (Nikkei su BCM: eroso, non conveniente). **FTMO:** swap piu' basso (oro -5,6%, JP225.cash circa 5,5%). Il prop favorisce FTMO per gli indici.
- **GoldenZoe oro:** FTMO 2024-26 PF 1,79, DD 4,8%; BCM 2015-2023 PF 1,02 (piatto): il vantaggio poggia sul 2024-26.

## 2. Mercati e priorita' (ipotesi di lavoro, da verificare)
| Priorita' | Mercato | Perche' | Rischio principale |
|---|---|---|---|
| A1 | **Nikkei 225 (JP225.cash su FTMO)** | unico candidato dello screen, hold-out ok, correlazione ~0 con l'oro | deriva rialzista (long-only = esposizione azionaria con stop); 52 operazioni in 10 anni |
| A2 | **Bitcoin (BTCUSD FTMO)** e Ethereum | trend lunghi, D1 positivo in IS e OOS | pochi trade che guidano tutto (5 su 156 fanno il 66%); drawdown e gap del weekend; storico corto |
| B | **Nasdaq 100, S&P 500, Dow, DAX** | vicini alla soglia; OOS spesso forte | correlati tra loro e con gli indici gia' lunghi; un solo "bet" azionario |
| C | **Hang Seng** (non regge in hold-out), argento, WTI | solo per confermare l'assenza | nessuna evidenza |
| - | Forex, agricoli, rame, gas | screen: nessun trend | escluso |

**Aspettativa onesta sulla flotta:** dal solo motore GoldenZoe sperare in **2-3 EA** (oro, Nikkei, forse una gamba cripto o un indice USA), non in 6-7. Gli altri vanno cercati in famiglie diverse (MaxMinNotte oro, ORB di Emiliano se ha regole, altre idee misurate).

## 3. Passi
0. **Copertura e specifiche FTMO (riga di sola lettura, minuti):** per i simboli dell'elenco (indici cash, BTCUSD, ETHUSD, XAGUSD, XTIUSD): anni di storico D1/H4 nel tester, swap long, contratto, spread medio, commissioni, orario del server. Decide quali mercati sono testabili davvero.
1. **Criteri scritti prima (il resto della famiglia D1):** parametri **fissati ora**: N di Donchian 20 e 55 (due, non una griglia), stop iniziale 3 ATR, Chandelier 3 ATR, long-only; per ogni mercato timeframe D1 e H4 (come l'oro). IS/OOS/hold-out per mercato in base alla copertura (hold-out = ultimi 12-18 mesi, intoccato). Soglie come nello screen (IS PF >= 1,3, n >= 30, t >= 2; OOS PF > 1,2, >= 15 operazioni; hold-out PF > 1,0 con >= 8 operazioni). Coerenza di classe: un mercato isolato = "da guardare".
2. **Tester FTMO (terminale non portabile, tick reali dove ci sono; altrimenti Modello 1 con limiti dichiarati):** una passata per mercato e variante, con `InpLotMode=1` per i CFD in valuta diversa dall'euro (bug del valore del tick su 225JPY), rischio 1% (solo per leggere i risultati). Costo stimato: 1-3 ore di tester per il lotto.
3. **Portafoglio:** correlazione delle serie mensili in R tra i candidati e con GoldenZoe oro; simulazione del conto prop (limite di perdita giornaliera e totale della challenge) con le regole FTMO, per vedere quanti EA servono per non superare i limiti. Nessuna indicazione di taglie.
4. **Demo forward:** per ogni candidato, set e magic separati (come gli `_Ottimizzato`: mai sostituire gli originali), VPS non toccato finche' Claudio decide.

## 4. Previsioni (prima dei numeri)
- Su 8-10 mercati testati con regola fissata: **candidati al cancello completo (IS+OOS+hold-out): 1-2 (60%), 0 (25%), 3 o piu' (15%).** Nikkei confermato sul tester FTMO (hold-out ok, swap incluso): **55%**. Un mercato cripto candidato: **35%**. Un indice USA/DAX candidato: **25%**.
- Correlazione mensile (R) tra due candidati qualsiasi (esclusi indici tra loro) in valore assoluto < 0,3: **75%**.
- Il tester FTMO riduce il PF dello screen D1 di Yahoo (costi, swap, orari): **80%**.

## 5. Cosa mi serve da Claudio (nessuna decisione subito)
- Conferma del terminale FTMO da usare per il tester (`C:\MT5_Backtest\Mt5_Ftmo_Prova`, non portabile) e del conto/demo FTMO a cui il tester si collega.
- **Se l'orario "oggi" va bene per il lotto notturno:** la riga di copertura (passo 0) la preparo subito, e dura minuti.
