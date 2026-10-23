# R291 -- varianti di visibilita' (MaxMin_Vis, Nasdaq_Vis, ORB_Vis): risultati (23/10/2026)
Fonte: `ROUND_R291_2026-10-23.zip` (pin 1ceaaf3b, motore = pin SHA256, 4 round rc 0, catena completa, per-trade 8 su 8). Archivio `backtest_pipeline/risultati_archivio/R291_20261023/`. Lettore congelato `r291_giudizio.py`.

## Esito
- **Compilazione: 0 errori, 0 avvisi per tutte e tre le EA** (log di MetaEditor nello zip).
- **G0: le quattro varianti sono IDENTICHE agli originali al centesimo.**
  | Round | Variante | = originale | IS | OOS |
  |---|---|---|---|---|
  | R291a | MaxMin_Vis | R246i | 4766,96 / 1,87803 / 20 deal | 6143,38 / 2,15985 / 21 deal |
  | R291b | Nasdaq_Vis (770250) | R286a | 1052,03 / 1,25328 / 57 | -192,82 / 0,95527 / 47 |
  | R291c | ORB_Vis, anti-duplicato spento | R283a | 7630,13 / 1,24678 / 71 | 33442,57 / 1,67803 / 119 |
  | R291d | ORB_Vis, anti-duplicato ACCESO | R283a | 7630,13 / 1,24678 / 71 | 33442,57 / 1,67803 / 119 |
  Quindi **le decisioni di trading non cambiano** (log e anti-duplicato non alterano nessun ordine nel tester); e se l'anti-duplicato fosse scattato in un giorno qualsiasi, R291d sarebbe diverso da R291c: non lo e'.
- **Controllo di visibilita' dai log del tester: NON MISURABILE, errore del mio criterio.** Il lettore dice "NO (0 righe [VIS])" per MaxMin e Nasdaq, ma nei log degli agenti l'EA scrive solo la riga di avvio: in ottimizzazione il tester non conserva le righe `Print` delle passate (stessa limitazione gia' vista in R274). Sapevo di questo limite e non l'ho applicato al criterio. **Non significa che le righe [VIS] non vengano scritte; significa che questo round non puo' dirlo.** Per la stessa ragione il "0 righe di anti-duplicato" non prova niente: la prova vera e' G0 su R291d.
- Attese dichiarate: P1 si', P2 si', P3 NO (non misurabile), P4 si' (ma per la ragione giusta e' G0, non il log).

## Come si verifica la visibilita' (non fatto)
Un singolo backtest NON in ottimizzazione (Tester di MT5, un solo passaggio) scrive le righe nel Giornale. Procedura manuale, a terminale chiuso per i round e senza EA attaccati: MetaTrader > Tester, EA `ABTG_Nasdaq_Apertura_US_Vis`, NASUSD M15, tick reali, 2025.01.01-2025.03.01, caricare `mql5/presets/ABTG_GatedShort_NASUSD_770250_LIVE.set`, una sola esecuzione, poi cercare `[VIS] gate EMA` nel Giornale. Stessa cosa per `ABTG_MaxMinNotte_DAX_Short_Ottimizzato_Vis` (D30EUR M15, preset RIPRISTINO) con `[VIS] CorrBias`. Se vuoi lo preparo come istruzione passo-passo.

## Stato
Le tre EA `_Vis` sono compilabili e **non cambiano le decisioni**. Non sono attaccate a nessun grafico e non sostituiscono nessun originale. Prima di metterle in campo (decisione di Claudio) resta da vedere una volta le righe [VIS] nel Giornale.
