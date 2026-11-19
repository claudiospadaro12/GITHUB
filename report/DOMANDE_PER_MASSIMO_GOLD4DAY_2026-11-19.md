# Domande per Massimo: Gold 4-Day Breakout (19/11/2026)
Ciao Massimo, ho letto il PDF e rifatto la regola sull'oro FTMO 2014-2020 (anni che voi non avete usato): 2014-2018 PF 1,00 (516 operazioni), 2019-2020 PF 1,05, plateau 1 cella su 16. Quindi il vostro PF 1,31 sembra legato al 2023-26 (oro volatile). Per capire bene mi servono questi dettagli, cosi riesco a replicare il vostro test con le stesse regole e non con le mie ipotesi.

**A. Regole esatte (le ho dovute indovinare)**
1. Periodo dell'ATR giornaliero (14?) e media semplice o di Wilder?
2. "Ultimi 4 giorni": giorni del server o sessioni di 24 ore? Includono il giorno corrente?
3. Orario esatto di ingresso (09:00-21:00 italiane = 10:00-22:00 server FTMO?) e orario esatto della chiusura forzata. Oppure chiusura a fine giornata del server?
4. L'ingresso e' un ordine stop al livello o una market order alla rottura? Come gestite il gap oltre il livello?
5. Lo stop viene piazzato anche nella stessa barra d'ingresso? E se la barra tocca livello e stop insieme, come lo contate?
6. Il rischio dello 0,5% e' sullo stop (0,5 ATR)? Il R del PDF e' questo?

**B. I numeri del PDF**
7. Quante operazioni in totale e per anno (2019, 2020, 2021, 2022, 2023, 2024, 2025, 2026)? PF e R per ogni anno.
8. PF 1,31: su quanti trade, con quale t o intervallo? Il drawdown 6,5R e' su quante operazioni?
9. La "robustezza" (3-6 giorni, stop diversi, PF 1,21-1,36) e' calcolata sul 2023-26 o sul 2019-23? Se e' sul 2023-26, i parametri sono stati scelti su quel periodo?
10. Il 2023-26 l'avete guardato prima di fissare i parametri o il filtro di volatilita'? Nel 2019-23 (PF 0,97-1,08) avevate trovato qualcosa che funzionasse?
11. I costi: spread, commissione, slippage usati nel test, e su quali dati (broker, tick reali o barre da 1 minuto)?
12. Dati e piattaforma: terminale, broker e orario del server usati nei test (MT4 o MT5)?

**C. Forward e correlazione**
13. In demo da settembre su 100k: quanti trade, PF, drawdown, risultato in R o in euro? Potete esportare i trade (CSV)?
14. Dal 2023 ad oggi, il rendimento giornaliero (equity o trade) si puo' esportare per misurare la correlazione con Reaper, Phantom e Goldbot?
15. Come si e' comportato nei giorni di notizie forti e il venerdi'?

**D. Il filtro di volatilita' (proposta 1 del PDF)**
16. Avete gia' provato un filtro ATR? Con quale soglia e su quale periodo? Vorrei scriverlo noi prima e giudicarlo su anni mai visti.

Grazie! Se manda i file sotto, rifaccio il test fino a oggi.
