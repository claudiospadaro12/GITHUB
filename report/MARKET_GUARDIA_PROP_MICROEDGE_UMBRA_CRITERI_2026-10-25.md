# Microedge e Umbra Vault con la guardia da prop accesa: criteri e previsioni scritti PRIMA dei numeri (25/10/2026)
**Natura: CRITERI.** Richiesta di Claudio (25/10): "si, fai la riga". Nel test a fondo del 25/10 Microedge Neural Matrix EA e Umbra Vault AI EA hanno una guardia da prop **dentro l'EA, spenta** (VERIFICATO dagli input dei referti): Microedge `propGuard=false`, `maxDD_daily=5.0`, `maxDD_total=10.0`; Umbra `EquityGuardEnabled=false`, `MaxDailyDrawdown=5.0`, `MaxTotalDrawdown=10.0`. Erano i due piu vicini a passare: Microedge falliva solo S-DD (27.755 EUR di DD contro 8.000), Umbra S-DD e S-NOSCALA (lotto max/min 3,49). **Nessun valore e scelto da me: la guardia si accende e i suoi numeri (5% e 10%) sono quelli di default del venditore.**

## Cosa si fa
Per ciascuno UNA corsa continua 01/01/2025-01/10/2026, XAUUSD H1, tick reali, 80.000 EUR, leva 1:100, tutto il resto invariato. **Input imposti esplicitamente** (perche gli input non imposti sono "gli ultimi usati"): Microedge `propGuard=true`, `maxDD_daily=5.0`, `maxDD_total=10.0`; Umbra `EquityGuardEnabled=true`, `MaxDailyDrawdown=5.0`, `MaxTotalDrawdown=10.0`. Script `DEEP80K_TESTER_TRANCHE.ps1` con `-Imposti`, `-Tranche 22`, cartella unica in `ABTG_RISULTATI`.

## Soglie e lettore
Invariate (`MARKET_TEST_80K_NUOVI_ATTESE_2026-10-25.md`): S-N >= 150, S-M >= 60% e somma > 0, S-H entrambe le meta' positive, S-DD <= 8.000 EUR di DD equity, S-NOSCALA (lotto max/min <= 3, <= 10 posizioni insieme, niente martingala), S-COSTO >= 3x lo spread. Lettore `leggi_deep80k_nuovi.py`; ho aggiunto una riga **informativa, fuori da ogni soglia**: data dell'ultimo affare e mesi con almeno un affare (autotest rifatto, OK). Il giornale lo guardo a mano per messaggi di guardia.

## Cosa NON so (NON VERIFICATO)
Rispetto a che cosa e misurato il 5% e il 10% (deposito iniziale, saldo, picco di equity), se il blocco e permanente o si azzera ogni giorno, se la guardia agisce sull'equity o sul saldo. **Se la guardia ferma l'EA per sempre prima di fine periodo, le soglie S-M e S-H falliscono per mesi senza operazioni e lo dico: il risultato descrive la guardia, non il potenziale.**

## Previsioni dichiarate ORA
- Corse valide: 85% ciascuna.
- Il netto con la guardia e' **inferiore** a quello senza (Microedge +112.199, Umbra +195.101): 85% ciascuna.
- La guardia ferma l'EA prima del 01/10/2026 (ultimo affare prima di settembre 2026): 40% ciascuna.
- S-DD passa (DD equity <= 8.000 EUR): Microedge 25%, Umbra 25%.
- Esito complessivo "candidato" (tutte le soglie): 15% ciascuna.

## Cosa NON decide
Non decide acquisti, taglie o lotti. Non cambia soglie dopo i numeri. Una guardia che "fa passare" S-DD fermando l'EA non e un EA che passa: lo scrivo cosi.
