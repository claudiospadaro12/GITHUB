# R292: MaxMin oro, variante a ticket (23/10/2026)
**Natura: MISURA.** Pin `ea21c019`, PC di backtest DESKTOP-H4D7CAJ, XAUUSD M15 tick reali, deposito 5400, finestra B. Criteri e lettore (`backtest_pipeline/r292_giudizio.py`) scritti prima dei numeri. Archivio: `backtest_pipeline/risultati_archivio/R292_20261023`.

## Esito del lettore congelato
- Compilazione: `ABTG_MaxMinNotte` e `ABTG_MaxMinNotte_Ticket` 0 errori, 0 avvisi (log del MetaEditor). **P1 vera.**
- Gemelle G1: OK su tutti e cinque.
- **Motore: R292a (originale) ha SHA256 DIVERSO dal pin. Causa NON VERIFICATA.** Per il criterio scritto prima, i numeri di R292a non sono formalmente leggibili. b, c, d, e hanno motore = pin.
- G0 (b e c = a al centesimo): IS 223,45 / PF 1,53877 / DD 2,1272 / 74 e OOS 622,22 / PF 1,94266 / DD 3,8721 / 79 in a, b e c. Identici, **ma** a ha motore diverso dal pin: G0 formalmente NON chiuso. Si rifa in R293a.
- Vicino presente: 272 chiusure del magic 999777 in d ed e, zero in a/b/c.
- **Difetto riprodotto (d, motore = pin):** 64 posizioni proprie su 78 chiuse fuori finestra (58 chiusure alle 20:00, l'ora in cui l'hook chiude il vicino). In c: 0 su 79.
- **Rimedio (e):** 0 tardive; 79 chiusure proprie, 100% allo stesso secondo di c. Netto proprio e = c = 623,80.
- Campione: 79 chiusure proprie OOS (< 100) => **DESCRITTIVO**, come scritto prima.

## Numeri descrittivi (non criteri)
Netto proprio OOS: c 623,80; d 575,79; e 623,80. Il vicino perde 715,05 (la sua posizione, non l'EA). In d le 64 tardive sommano +695,56 e il netto proprio cala di 48,01 rispetto a c: in questo scenario sintetico il difetto costa circa 8% del netto OOS. Un solo regime, un vicino che non esiste in campo con quel profilo.

## Cosa NON dice
Non dice quanti vicini reali accecano la sedia ne' quanto spesso. Non e' un G0 chiuso. Non e' una promozione: la variante resta un EA nuovo (magic 750402), non attaccata a nessun grafico. Se metterla in campo e' decisione di Claudio.
