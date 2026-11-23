# Telegram UBS, topic "UBS Optimizer App" (07-18/11/2026): sintesi (23/11/2026)
Fonte: `UBS_OPTMISER_APP.zip` (messages.html con 285 messaggi, 1 zip di 2 log di un utente, immagini). **Nessun eseguibile aperto o lanciato** (gli `.exe` citati nel topic non sono nello zip). Il log di un utente contiene nome, nome del PC e codice di licenza: non riportati qui. Tutto e non verificato.
## Cos'e (secondo Wim)
- App Windows gratuita in beta per gestire i set UBS: importa collezioni e portafogli, esegue **prove di stress A, B (C e D non ancora curate)**, mette un voto alla "forma" delle strategie, calcola il bilanciamento del portafoglio, ha una scheda **Live** per collegare un conto e confrontare con i backtest (11/11) e dal 12/11 un **MCP** (per collegarla a un assistente AI). Gira in locale (pagina web su `127.0.0.1:8765`), costruita "con Claude".
- **Licenza:** si invia a Wim l'impronta del PC e lui genera una chiave; **un solo dispositivo per chiave**; nei log una licenza di 90 giorni (fino al 09/02/2027); Wim: "3 mesi per ora, e una prima prova".
- Funzione dichiarata utile: salvare un portafoglio per un altro broker (adegua ForceSymbol e il "max drawdown storico a 0,01 lotti" se pip/tick value cambiano, tipico degli indici).
## Spunti per il nostro metodo
- Feedback di Zairex_ (09/11): **"contare le prove"** (se 100 persone lanciano una moneta 10 volte, qualcuna fa 10 teste): e lo stesso principio del nostro contatore di celle e dei falsi positivi attesi.
- Wim: "puoi fare centinaia di test, **solo il test live conta**".
- Un'app per set di EA di terzi non serve ai nostri EA propri: le nostre regole (criteri scritti prima, cancelli, hold-out) sono gia piu stringenti.
## Cautele
- Eseguibile di terze parti con scheda "Live" che collega un conto e un MCP: **non collegare conti reali o prop, non installarlo sul PC di backtest o sul computer del reale** senza averne valutato i permessi. Se mai lo si prova, solo con password investitore (sola lettura) su un conto demo.
- La licenza e legata a un PC e la fornisce Wim: dipendenza da un fornitore per gli EA che restano fuori dal progetto prop.
