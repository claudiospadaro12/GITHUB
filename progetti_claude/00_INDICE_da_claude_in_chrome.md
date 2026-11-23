# Indice analisi progetti claude.ai (sola lettura)

Data analisi: 2026-11-23. Analisi PARZIALE: vedi sezione "Cosa NON è stato letto".

| Progetto | N. file (conoscenza) | N. chat | EA/indicatori trovati | Stato | Dove si trova l'EA semiautomatico |
|---|---|---|---|---|---|
| REGISTRAZIONI | 3 | circa 20 in elenco (solo lista letta) | non letto | non letto | non letto |
| EXPERT | non letto | non letto | non letto | non letto | non letto |
| CREAZIONE INDICATORE PER ORO | non letto | non letto | non letto | non letto | non letto |
| ORO | non letto | non letto | non letto | non letto | non letto |
| ICHIMOKU CLAUDIO | non letto | non letto | non letto | non letto | non letto |
| INSIEME DI EA, CURVA EQUITY | non letto | non letto | non letto | non letto | non letto |
| BANDE DI BOLLINGER EMILIANO | non letto | non letto | non letto | non letto | non letto |
| BREAKINGBAND AGGIORNATO LEONARDO | non letto | non letto | non letto | non letto | non letto |
| IN BULGE-POST BULGE CLAUDIO | non letto | non letto | non letto | non letto | vedi nota sotto |

## Ricerca prioritaria: EA semiautomatico MT4

Candidato più probabile: chat "Spiegazione funzionalità file" (aggiornata 2026-03-18), file caricato `EA_BOLL_BULGE_Manager_PRO_H1_FIXED.mq4`, poi confrontato con `EA_BOLL_BULGE_Manager_PRO_MULTI_TF_FINAL.mq4` (versione più recente, consigliata dalla chat stessa).

Dettagli riportati nella chat (riassunto, NON codice):
- Non apre ordini: gestisce solo posizioni già aperte a mano (magic filter di default -1, cioè gestisce solo ordini con magic 0).
- Stop loss: ATR(14) x 3, impostato se mancante.
- Take profit: mediana Bollinger (periodo 20, deviazione 2.0), aggiornata a ogni nuova barra. Nella versione MULTI_TF usa la barra chiusa (indice 1) e ha una distanza minima dal prezzo di 10 punti.
- Break even a 1R (offset 2 punti), trailing basato su R: parte a 1.5R, step 0.25R.
- Riconoscimento della posizione: filtro magic (default -1 = ordini manuali), simbolo del grafico.
- Versione MULTI_TF: ATR e TP sul timeframe del grafico (parametri = 0).

Limiti:
- Il codice .mq4 completo NON è presente nella chat letta: c'è solo il riassunto. Il file originale va recuperato dai file caricati nella conversazione o dal computer.
- Nessun bug esplicitamente discusso oltre al sospetto, nella versione H1_FIXED, che con UpdateTP_OnNewBar = false il TP non venga mai aggiornato.

Nota: la chat "Conversione EA da MT4 a MT5" (aggiornata 2026-03-18) contiene la versione MT5 dello stesso EA (parametri identici: magic filter, ATR x3, mediana BB, BE 1R, trailing 1.5R/0.25R). Non è la versione MT4 richiesta.

## Cosa NON è stato letto

- Nessun progetto è stato aperto in dettaglio: sono stati letti solo l'elenco dei progetti e l'elenco delle chat di REGISTRAZIONI.
- Per il lavoro completo (istruzioni, file, tutte le chat, codici completi) servono decine di aperture di pagina aggiuntive: va confermato se procedere.
- Il codice completo dell'EA MT4 non è disponibile dalle chat lette.
