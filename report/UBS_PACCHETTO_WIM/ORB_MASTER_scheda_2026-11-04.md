# Scheda EA "The ORB Master V3.5" (pacchetto Wim) — 04/11/2026
Fonte: manuale v3.1 (maggio 2026) incollato da Claudio + 7 set file. `.ex5` non aperto e non nel repository; set originali fuori dal repo.

## Cosa dichiara
- **Opening Range Breakout sugli indici**: US500, US30, NAS100 e DAX; **12 varianti interne (3 per indice)** attivabili singolarmente (`[Indice]_STRAT1/2/3`), tutte da un solo grafico EURUSD M15. Trailing SL/TP dinamico, nessuna griglia né martingala.
- Orari per indice (`starttime`/`stoptime`, formato HH:MM; l'esempio del manuale è «15:30 – 17:00 per gli indici USA»), filtro orario con sorgente "Optimized" o GMT-0, chiusura del venerdì opzionale, AutoGMT, filtri NFP (50 min prima / 30 dopo), tassi e CPI opzionali.
- Lotto: «Max Risk per Strategy» in % (consiglia 5–15 per le varianti normali), `OnlyUp`, `AdjustLotsizeToVariableValues`. Prop firm: `PropFirmMaxDailyDD`, randomizzazione in punti (consigliata 100), aggiustamenti di entrata/SL/TP.
- Simboli da adattare ai nomi del broker (US500, US30, USTEC/NAS100, DAX/DE40).

## I 7 set (differenze: 2 valori)
| Set | `MaxRisk_Strategy` (%) | `PropFirmMaxDailyDD` |
|---|---|---|
| low risk | 5 | — |
| medium risk | 10 | — |
| high risk | 15 | — |
| very high risk | 20 | — |
| combo_setup | 3 | — |
| prop firm set | 2 | 4 |
| prop firm_Combo set | 1 | 4 |
Comuni: US500 / US30 / USTEC con tutte e 3 le strategie attive; **nei set non compare il DAX** (nonostante il manuale parli di 4 indici: da verificare nel tester o chiedere), `OnlyUp` acceso, NFP attivo, randomizzazione 0, `AutoGMT` acceso con offset di riserva 2/3 (**non vale per BCM**: server GMT+1 fisso, vedi CLAUDE.md).
I set "combo" (rischio 3 e 1) sembrano pensati per affiancare ORB Master ad altri EA di Wim: è la stessa idea dei nostri COMBO (GTP).

## Letture di C0 (non misurate)
1. **È l'EA più vicino al nostro lavoro sull'ORB** (ABTG_ORB, ORB_Ottimizzato, ORB_Emiliano, e il confronto con il metodo di Paolo). Orari, struttura delle 3 varianti, tipo di ingresso (pendente o a mercato) e uscite **non si leggono dai set**: stanno dentro l'`.ex5`. Il test e il manuale diranno solo quanto basta per un confronto di risultati, non di logica.
2. Indici USA: **correlati tra loro** (US500/US30/NAS100 si muovono insieme): i 9 "strategy" USA non sono 9 fonti indipendenti. Rispetto all'oro: probabile bassa correlazione, ma nelle crisi gli indici scendono insieme.
3. **Fuso orario**: il filtro orario "Optimized" e `AutoGMT` si appoggiano all'orario broker; per BCM (GMT+1 fisso, 14:30 estate / 15:30 inverno per l'apertura USA) vanno verificati su live; per i backtest sullo storico `_EXT` vale l'eccezione in CLAUDE.md (apertura a 14:30 anche in inverno).
4. I set prop firm hanno `PropFirmMaxDailyDD=4`, come il nostro Guardian (4,3%): da confrontare quale scatta per primo, ed evitare doppi blocchi.
5. Simboli: `USTEC` per il Nasdaq (nel set); su BCM i nomi sono `NASUSD`/`US30`… da mappare.
6. Randomizzazione: come per UBS e Bitcoin Reaper, non da usare per aggirare i controlli di una prop firm.

## Da misurare (criteri da congelare prima di guardare i risultati)
Per ogni set e per ogni indice/variante: PF, DD massimo in % e in giorni, peggior giorno e sequenza, n. trade/anno, risultati per anno (2018–oggi), sensibilità a spread/slippage, comportamento nei giorni di notizie; correlazione con Reaper/Goldbot/Phantom/GTP e tra le varianti USA; peggior giorno combinato col Guardian; confronto di risultato con i nostri ORB (non di logica). Storia indici su BCM da verificare (tick reali) e dati `_EXT` solo con le correzioni orarie.
Stato: **nessun test eseguito**.
