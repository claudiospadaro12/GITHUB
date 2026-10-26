# Arena 5K a Modello 1: calibrazione contro i tick reali — RISULTATO (26/10/2026)
Criterio (scritto prima dei dati, `ARENA_5K_MESI_CRITERI_2026-10-26.md`, Aggiunta Modello 1): calibrazione OK se almeno 4 mesi in comune, almeno 80% stesso segno del netto E almeno 80% stessa presenza di stop out. Lettore congelato `backtest_pipeline/leggi_arena5k_mesi.py --calibra`. Fonte M1: zip `ARENA_CALIBRAZIONE` di Claudio (mesi 2026-04..09, 6 corse stato OK); archivio `risultati_archivio/ARENA5K_M1_CALIBRAZIONE_20261026`.

| Mese | Netto M4 (tick reali) | Stop out M4 | Netto M1 | Stop out M1 | Segno | Stop out |
|---|---|---|---|---|---|---|
| 2026-04 | non disponibile (corsa M4 incompleta) | - | +4.721 | SI | - | - |
| 2026-05 | -3.050 | SI | +12.823 | no | DIVERSO | DIVERSO |
| 2026-06 | non valido (tester chiuso al 6%) | - | -2.570 | SI | - | - |
| 2026-07 | +4.800 | no | +25.179 | no | uguale | uguale |
| 2026-08 | -3.063 | SI | -2.783 | SI | uguale | uguale |
| 2026-09 | -2.505 | SI | +21.330 | no | DIVERSO | DIVERSO |

Mesi in comune 4: stesso segno 2/4, stessa presenza di stop out 2/4 → **NON ATTENDIBILE** (soglia 80%). Fonti M4: `ARENA_TESTER_TRANCHE_*_LETTURA_2026-10-1*.md` (lug, ago, set) e archivio `ARENA5K_MESI_20261026_PARZIALE` (mag).

**Lettura:** con 4 punti per barra Arena (griglia con trigger a prezzo 0,2) NON si comporta come sui tick reali: in due mesi su quattro il Modello 1 evita lo stop out e guadagna molto dove i tick reali lo davano (maggio, settembre), e produce utili di 4-5 volte il deposito (luglio +25.179, settembre +21.330) che non sono un'informazione credibile su un conto da 5.000 EUR. Il Modello 1 sembra SOTTOSTIMARE il danno della griglia (INFERITO dal confronto, non dimostrato). Conseguenza: **i 15 mesi del 2025 e gennaio-marzo 2026 a Modello 1 non si leggono come misura di Arena**; le uniche cifre valide restano quelle a tick reali (luglio, agosto, settembre; maggio). Il lotto massimo a M1 (fino a 0,38 contro base 0,01) indica anche una crescita di esposizione che va confrontata con M4 prima di dire altro.

Limite del confronto: 4 mesi sono pochi e uno dei due accordi (agosto) e il caso in cui il conto muore comunque; il criterio e comunque quello scritto prima.

**Scorecard previsioni:** "calibrazione OK 55%": MANCATA (esito opposto, previsione 45% a sfavore). Previsione durata M1 < 20 minuti a mese 65%: non verificata qui (maggio 524 s, vedi MANIFEST; gli altri mesi non letti).

**Cosa NON dice:** niente sull'Arena reale ne sul suo guardiano; non giudica acquisti, lotti o taglie.
**Prossimo passo possibile (decisione di Claudio):** fermare la parte M1 dei 15 mesi; i mesi del 2025 a tick reali non esistono per l'oro (tick reali solo da 10/07/2024: possibili ma lenti, 3-4 ore a mese).
