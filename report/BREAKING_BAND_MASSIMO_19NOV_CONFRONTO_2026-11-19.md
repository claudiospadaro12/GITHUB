# Breaking Band / Bulge: PDF di Massimo (19/11) confrontato con i nostri test BCM

Fonte: `Breaking_Band_per_Claudio_19nov.pdf` (MetaQuotes-Demo, H1, ogni tick, 100.000 EUR, rischio 0,5%, IS 2013-20, OOS 2020-26). Nostri dati: `BREAKINGBAND_V4_MARKETWATCH_CRITERI_2026-11-19.md` (BCM, barre 1 minuto, 10.000 EUR, IS 2013-20, OOS 2021-24, 2025-26 tenuto fuori).

| Simbolo | Massimo IS PF | Massimo OOS PF | Nostro IS (n, PF) | Nostro OOS (n, PF) |
|---|---|---|---|---|
| EURUSD | 1,99 | 1,59 | 17, 2,56 | 3, 0,70 |
| EURCHF | 3,33 | 1,41 | 14, 3,05 | 7, 0,64 |
| EURCAD | +3.042 EUR (PF 0,00 "display") | 2,34 | 15, 80,7 | 3, 0,75 |

Letture (misure, non giudizi su Massimo):
1. L'IS coincide: stessi 3 simboli forti, stesso ordine di grandezza di operazioni (2-3 l'anno). L'IS del PDF e quello nostro dicono la stessa cosa.
2. L'OOS NO: noi 13 operazioni totali sui 3 simboli (PF 0,64-0,75); lui PF 1,41-2,34 su 2020-26. Differenze possibili: finestra (la sua include 2025-26, la nostra no, e 2020 e dentro anche il suo IS: sovrapposizione), dati (MetaQuotes vs BCM), modello (ogni tick vs 1 minuto), spread. Non spiegabile senza le liste operazioni.
3. Campione piccolo: ~15-20 operazioni per finestra per simbolo. Un PF su 15 operazioni ha un intervallo enorme; EURCAD "PF 0,00 a schermo" e un PF con quasi nessuna perdita (da noi 80,7): non un artefatto di display ma pochissime perdite.
4. Selezione: 3 "robusti" scelti dopo aver visto entrambi i periodi su 8 simboli mostrati: la doppia verifica toglie la fortuna di un periodo ma non quella della scelta fatta guardando entrambi. Lo stesso argomento usato per GBPJPY/AUDUSD vale per i 3 scelti.
5. Rendimento: 0,69% annuo a rischio 0,5%; le stime 2% e 3% sono lineari (lui stesso lo dice): con 7-9 operazioni l'anno il DD non scala in modo lineare.
6. Tabella Market Watch dello scan nostro: nessun simbolo validato (OOS PF 59-200 su 1-2 operazioni = rumore).

Richiesta a Massimo per allineare: lista operazioni (data, simbolo, direzione, prezzo, SL, TP, esito) EURUSD/EURCHF/EURCAD 2020-2026 + set file esatto + broker/server dei dati. Poi confronto operazione per operazione con la nostra passata BCM sulla stessa finestra: se le date dei segnali coincidono, la differenza e esecuzione/dati; se no, e la regola.
