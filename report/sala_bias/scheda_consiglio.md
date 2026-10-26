# Scheda del consiglio - SALA-BIAS-001 (26/10/2026)
**Modalita: MISTA.** Agenti REALI (sotto-agenti dell'ambiente, ognuno con contesto proprio): A2, A3, A4, A6, A7. Agenti SINTETICI (prospettive di C0 nello stesso processo): C0, A1, A5. X = 8 ruoli, 5 reali. Poiche A6 e A7 sono reali, l'indipendenza della revisione e empirica per il verificatore e il critico; il coordinatore e l'integratore (C0/A1) non lo sono e lo dichiaro.
## Capacita verificate (prove reali, non dedotte dai nomi)
| Voce | Stato | Come accertato / limite |
|---|---|---|
| Creazione agenti distinti, concorrenza | DISPONIBILE | 4 agenti avviati in parallelo in una chiamata; limite massimo non noto |
| Messaggi fra agenti | NON_DISPONIBILE (diretti) | i sotto-agenti rispondono solo a chi li ha avviati: scambi MEDIATI da C0 e registrati come tali |
| Lettura allegati e dati | DISPONIBILE | PDF letto con pdftotext, CSV D1 letti |
| Ricerca esterna | NON_VERIFICATO | non necessaria per il mandato |
| Scrittura file, esecuzione codice | DISPONIBILE | file scritti e Python 3.11 eseguito (senza numpy) |
| Compilazione MQL5 | NON_DISPONIBILE | nessun MetaEditor in questo ambiente: l'MQL5 e `bozza` finche non compilato sul PC |
| Superficie grafica | NON_VERIFICATO | vista statica (tabelle e dashboard.html) a ogni checkpoint |
| Persistenza | DISPONIBILE | `state.json` + `events.jsonl` nel repo, commit a ogni checkpoint |
## Aree di lavoro
Ognuno scrive solo in `report/sala_bias/agents/<ID>/` (A6 in `reviews/`); C0 scrive stato e criteri; nessun agente committa.
