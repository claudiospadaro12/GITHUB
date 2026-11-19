# GoldenZoe: filtro news (v1.10) - criteri scritti PRIMA dei numeri (19/11/2026)

**Cosa e:** opzione `InpNewsFilter` (default SPENTA = comportamento v1.00 identico). Se accesa: nessun NUOVO ingresso da 120 minuti prima a 120 minuti dopo una notizia ad alto impatto (USD per l'oro), come nei filtri di Wim. Opzione separata `InpNewsBlockTrail` (default spenta) per saltare anche lo spostamento dello stop vicino alle notizie. Il segnale perso non si recupera: se la candela H4 di ingresso cade nella finestra si salta quell'ingresso.
**Fonti notizie:** CSV `abtg_news_hist.csv` (cartella Common\Files, orari del server del terminale) esportato dal calendario MT5 dallo script `ABTG_NewsExport.mq5` (USD ed EUR, impatto >= medio, dal 2013); in demo/live opzione `InpNewsSource=1` (calendario MT5 in tempo reale; non funziona nel tester).
**Limiti noti:** (1) l'esportazione parte dal 2013: il test 2005-2014 non e coperto prima del 2013; (2) l'orario del calendario e quello del server del terminale che lo esporta (BCM GMT+1 fisso; FTMO server = ora italiana +1): su FTMO nelle settimane di scarto dell'ora legale l'errore e al massimo 1 ora, dentro una finestra di 2 ore; (3) non e verificato che il calendario del terminale BCM portabile abbia lo storico: il riepilogo dell'esportazione lo dice.

## Come si testa (passo 2, dopo l'esportazione)
Tester BCM, XAUUSD H4, LONG, Modello 1, 100.000 EUR: stesse finestre della corsa BCM (2015-2023 e 2024-2026; il 2005-2014 solo dal 2013 in poi se il calendario parte lì). Passate: filtro SPENTO e filtro ACCESO (120+120 minuti, USD, impatto alto). Si confrontano operazioni, PF, DD e quante operazioni sono state saltate.

## Previsioni (prima dei numeri)
- Operazioni saltate: **3-12% del totale** (le candele H4 che aprono entro 2 ore da una notizia USD ad alto impatto): 70%.
- PF 2024-26 con filtro entro +-0,15 dal PF senza filtro: **75%** (effetto piccolo, nessun miglioramento sistematico).
- DD con filtro non peggiore di piu di 1 punto percentuale: **80%**.
- Il filtro NON rende l'EA piu redditizio in modo misurabile: **80%**.

## Regole di esito
1. **Il filtro si puo tenere** (come protezione, non come miglioramento) se: operazioni saltate <= 15%, PF 2024-26 con filtro >= PF senza filtro - 0,2, DD non peggiore di 2 punti.
2. **Il filtro migliora** solo se il PF con filtro supera quello senza di >= 0,2 in entrambe le finestre (2015-23 e 2024-26): improbabile, non si cercano finestre o parametri diversi per ottenerlo.
3. Nessun cambio della finestra (120/120) dopo aver visto i numeri.
4. Il filtro non risolve la regola FTMO dei 2 minuti sui conti funded (modifiche e chiusure incluse): GoldenZoe lavora solo all'apertura della candela H4, quindi la tocca di rado, ma lo stop automatico durante una notizia non e controllabile.
