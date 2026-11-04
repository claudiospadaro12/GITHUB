# Scheda EA "Indicement V8.0" (pacchetto Wim) — 04/11/2026
Fonte: manuale v7.6 (maggio 2026) incollato da Claudio + 6 set file. `.ex5` non aperto e non nel repository; set originali fuori dal repo.

## Cosa dichiara
- Breakout intraday sugli indici USA: **US500 (fino a 6 strategie), US30 (4), NAS100/USTEC (4)** = fino a 14 strategie interne, tutte da un grafico H1 (EURUSD). SL/TP fissi + trailing SL/TP, nessuna griglia, martingala o averaging.
- Alcune strategie sono **ORB**: nel manuale compare «starttime/stoptime ORB strats» (default 15:30–17:00), mentre le altre sono breakout di supporti/resistenze su orari liberi (filtro orario di default 00:00–24:00).
- Lotto da «Max Risk per Strategy» (% per strategia, in base al drawdown storico di ciascuna), `AdjustLotsizeToVariableValues`. Prop firm: drawdown giornaliero, randomizzazione, aggiustamenti. Filtri NFP / tassi / CPI, filtro fake breakout (spento), chiusura del venerdì (spenta, 25).

## I 6 set
| Set | `MaxRisk_Strategy` (%) | `PropFirmMaxDailyDD` | Strategie attive |
|---|---|---|---|
| extreme_low risk | 1,5 | — | **solo alcune** (STRAT2-3-4 di US500 e le altre indicate a 0) |
| low risk | 1,5 | — | tutte |
| medium risk | 3 | — | tutte |
| high risk | 5 | — | tutte |
| extreme | 10 | — | tutte |
| Prop firm set | 1 | 4 | tutte |
Comuni: US500 / US30 / USTEC attivi, magic 4000, `OnlyUp=0`, NFP attivo con **140 min prima / 110 dopo** (nel manuale il default è 50/30: i set sono più prudenti), filtro orario spento, randomizzazione 0.

## Letture di C0 (non misurate)
1. **Sovrapposizione con ORB Master**: stessa famiglia (indici USA, strategie ORB e di breakout, stessa logica di rischio per strategia) con orari e filtri diversi; attesa correlazione molto alta tra i due. Averli entrambi probabilmente non raddoppia la diversificazione.
2. Tre indici USA correlati tra loro: le 14 "strategie" non sono 14 fonti indipendenti.
3. L'unico set che riduce davvero il numero di strategie è **extreme_low risk**: i rischi dei set normali variano con il solo `MaxRisk_Strategy`, da 1,5 a 10 → il drawdown scala in modo non lineare: va misurato.
4. Il parametro che determina il lotto è il **drawdown storico** di ogni strategia (dentro l'`.ex5`): se è sottostimato, il lotto è sovrastimato. Con le aperture USA sul broker occorre verificare l'orario (BCM GMT+1 fisso; storico `_EXT` con apertura 14:30 anche in inverno, vedi CLAUDE.md).
5. Il set prop firm ha 4% di DD giornaliero (come ORB Master e vicino al nostro Guardian 4,3%): attenzione a doppi blocchi.
6. Randomizzazione: come per gli altri, non da usare per aggirare controlli.

## Da misurare (criteri da congelare prima di guardare i risultati)
Per set e per indice/strategia: PF, DD massimo in % e in giorni, peggior giorno/sequenza, n. trade/anno, per anno (2018–oggi), sensibilità a spread/slippage, effetto del filtro NFP/tassi; correlazione con Reaper/Goldbot/Phantom/GTP, con ORB Master e tra gli indici; peggior giorno combinato col Guardian; confronto di risultato (non di logica) con i nostri ORB.
Stato: **nessun test eseguito**.
