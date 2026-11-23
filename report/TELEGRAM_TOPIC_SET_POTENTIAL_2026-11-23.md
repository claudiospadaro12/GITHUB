# Telegram UBS, topic "My new set files that have potential": sintesi mirata (23/11/2026)
Fonte: 5 file `messages*.html` (3.963 messaggi, 16/05/2025 - 04/2026 e 2026), convertiti in testo `telegram_ubs_topic_sets_2026-11-23/topic_my_new_set_files_testo.txt`. **Non letti per intero: cercate parole chiave** (ftmo, prop, ban, copy, randomi, us30, dow, nas100, file allegati). Tutto cio che dicono gli utenti e **testimonianza non verificata**.
## Origine del set `g` del Dow (nostro riferimento di misura)
- 17/07/2026 Wim posta a-f.set "optimizations for US30_H1 Volatility Breakout, In-Sample 2022-2026", **non ancora controllati a tick reali**; basati su un set USTEC (ForceSymbol=USTEC, M15): "ForceSymbol non serve nei backtest individuali, non per l'autoloader".
- 19/07/2026 Wim: "my backtests, I think it has potential for US30" (real ticks.zip). 20/07 un utente: "high PF, minimo 1,7".
- 23/07/2026 Oleg chiede "G set, looks promising"; Wim ripubblica a-e.set. **Il nostro `g` e questo filone: IS 2022-2026 su feed IC Markets/Dukascopy-like, non su BCM/FTMO.**
## Prop firm e FTMO (utenti)
- 10/07/2025: "se usi lo stesso set sulla stessa prop vieni segnalato per copy trading"; Mistermember: per questo esiste la **randomizzazione** nel UBS; "non mi fido delle prop, trovano il modo di far fuori la gente".
- Randomizzazione ORB (10/10/2025): con la randomizzazione il PF oscilla sopra e sotto lo standard; con tutte le strategie insieme il drawdown **quasi raddoppia** senza miglioramento significativo.
- 24/07/2025: FTMO ha cambiato gli spread sulle crypto: spread piu stretti ma **commissione 0,0325% per operazione**; un set BTC H1 "sopravvive" nel 2022-2025 (FTMO permette solo quel periodo), altri "mangiati dalle commissioni".
- 29/07/2025 (Furuku): per i set oro su FTMO conviene **dimezzare il rischio**; "sull'oro i prop danno il meglio". Un utente dice di aver passato 200K su FTMO "ma soprattutto manuale".
- Nel topic niente "Invalid stops" e niente V9.8 (da chiedere a Wim altrove).
## Portafoglio e rischio (Wim)
- Non usare lo stesso lotto per ogni set: pesa troppo le strategie che operano di piu. Il **DD totale del portafoglio** di 9 set va tenuto sotto il 10%, non quello dei singoli. Lo "stato di salute" di una strategia si valuta confrontando il DD corrente col suo DD storico.
## Altri spunti
- Till automatizza i backtest con **Claude Code + script Python** e MT5 (come noi); un altro utente costruisce un MCP per il portfolio manager.
- Dati tick: Dukascopy tramite Tick Data Suite (499 EUR a vita) vs demo MetaQuotes (un utente dice che il pricefeed e piu vicino a un broker normale).
- File condivisi nel topic: circa 483, soprattutto XAUUSD (42 citazioni), US30 (22), BTC (21), NAS100/USTEC (28), US500 (12), EURUSD, USDJPY, XAGUSD, DAX.
