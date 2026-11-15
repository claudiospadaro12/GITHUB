# EA nostro "oro: rimbalzo al livello" (ordini limit): CRITERI e PREVISIONI scritti PRIMA del codice (15/11/2026)

**Natura: CRITERI, nessun codice, nessun test.** Idea di Claudio: "quando non rompe il livello e rimbalza", ordini limit sull'oro, per avere un EA poco correlato ai breakout di Wim (P1/P3/P4). Solo demo e tester; mai su FTMO ne sul reale 10105439. Nessun giudizio su lotti o taglie. **Le regole sotto sono MIE PROPOSTE di partenza: Claudio le corregge prima del codice.**

## Regole proposte (parametri fissati prima, non ottimizzati)
1. **Livelli** (calcolati a ogni nuovo giorno, ora server BCM): massimo e minimo del giorno precedente (PDH, PDL) e massimo e minimo della sessione asiatica (00:00-07:00 server; in estate l'ora legale sposta di un'ora: si dichiara il limite).
2. **Ordini**: un SELL LIMIT sul massimo e un BUY LIMIT sul minimo, solo durante Londra e New York (08:00-20:00 server), cancellati a fine finestra; massimo 1 ingresso per livello al giorno.
3. **Stop**: oltre il livello di `InpStopATR` x ATR(14) su H1 (default 1,0): se il livello si rompe davvero si esce. **Take profit**: `InpTP_R` volte il rischio (default 1,5) o la meta del range del giorno precedente (si prova solo il primo).
4. **Filtri**: niente ingressi nei 30 minuti attorno a NFP, tassi Fed, CPI e simili (il calendario dei nostri EA); spread massimo; nessun ingresso se il livello e stato toccato piu di 2 volte nella stessa sessione (livello "consumato").
5. **Rischio**: lotto fisso 0,01 in test (poi dimensionamento a rischio % dallo stop, come UBS); perdita giornaliera massima nel codice.
6. **Tempo**: solo tempo dei tick o delle barre del tester (niente `GetTickCount`).

## Test
Tester BCM: M1 (Modello 1) per P1 2013-2018 e P2 2019-2025 (EA su H1, non a tick), poi tick reali sul 2025 e sul 2026 per i candidati; XAUUSD; deposito 100.000 EUR; tre varianti sui parametri (stop 0,75/1,0/1,5 ATR) scritte ora, nessuna ottimizzazione libera. Misure: netto, PF, DD, operazioni, correlazione giornaliera del realizzato con i portafogli oro P1/P3/P4.

## Previsioni dichiarate ORA (non misurate)
- **A-1** PF >= 1,20 in entrambi i periodi con >= 150 operazioni per periodo (almeno una delle tre varianti): 30%.
- **A-2** Correlazione giornaliera con P1/P3/P4 <= 0,30 per la variante migliore: 65%.
- **A-3** Nei giorni di trend forte (movimento > 2 ATR) l'EA perde piu del suo guadagno medio nei giorni laterali (profilo "tante vincite piccole, poche perdite grandi"): 80%.
- **A-4** Il netto dopo i costi FTMO misurati (commissione 5,1 EUR/lotto, slippage medio in entrata circa 0,4 USD/oncia) e positivo per la variante migliore: 40%.
- **A-5** Differenza tra tick e M1 nel 2025 entro le soglie di Wim (PF >= 0,7, DD <= 1,5x): 60%.
- **Regola di arresto:** se nessuna delle tre varianti passa A-1, stop; niente ottimizzazione per forzare.

## Domande per Claudio (rispondere prima del codice)
1. Quali livelli vuoi? (massimo/minimo del giorno prima, sessione asiatica, numeri tondi, apertura di Londra/New York, o altri)
2. Dove vuoi lo stop: oltre il livello di quanto? E il target?
3. In quali ore operare? Una sola volta per livello al giorno, o ogni volta che torna?
