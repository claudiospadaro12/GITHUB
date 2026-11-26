# UBS R1b: risultati (26/11/2026), 66 set oro + forex rimasti dell'Excel (62 risultati distinti)

Condizioni: D1 a 1 minuto 2020-01-01..2026-10-31 (confrontabili con l'Excel); H1/H4 a TICK REALI 2025-01-01..2026-10-31 (periodo piu' corto: le operazioni attese sono circa il 27% di quelle dichiarate; classificazione sul PF, non sulle operazioni oltre il minimo di 30). Deposito 100.000 EUR, Risk=0, StartLots=0,1. Dati: `UBS_NOTTE/RISULTATI_R1b_2026-11-26.csv`. Criterio come R1 (PF >= 1,20 e (PF-1) >= 0,5 x (PF Excel-1)); l'adattamento per H1/H4 e' scritto qui prima di guardare i numeri.

| Gruppo | Set | CONF | PARZ | NO | Mediana PF nostro/Excel |
|---|---|---|---|---|---|
| Oro D1 (1 min) | 13 | 13 | 0 | 0 | 1,01 |
| Forex D1 (1 min) | 12 | 7 | 3 | 2 (EURAUD, EURNZD) | 0,80 |
| Oro H1/H4 (tick 2025-26) | 37 | 29 | 4 | 4 | 1,21 |
| **Totale** | **62** | **49** | **7** | **6** | **1,11** |
Correlazione di rango PF nostro / PF Excel: D1 0,28; H1/H4 0,37.

## Lettura (limiti dichiarati)
1. **Oro D1:** i PF dell'Excel si riproducono (rapporto 1,01, calibrazione tick/1 minuto sui D1: 0,92). Coerente con GTP oro D1 (2004-2012: 7/10; 2023-26: 10/10). Ma il periodo 2020-26 e' quello in cui l'autore ha scelto i set e contiene il forte rialzo dell'oro 2024-26: **in campione per l'autore e favorevole al trend**. Il vero esame e' R2 (2004-2019, dati oro BCM completi).
2. **Oro H1/H4 a tick 2025-26:** PF 1,5-3 sulla finestra piu' favorevole del trend oro. Non e' una replica del 2020-26 (periodo e operazioni diversi): dice solo che i set funzionano in un oro rialzista. R2 su H1/H4 possibile solo a 1 minuto (gonfiato sui set veloci: calibrazione sul forex). Da calibrare sull'oro con gli stessi set a 1 minuto 2025-26.
3. **Forex D1:** rapporto 0,80, EURAUD e EURNZD non si riproducono (PF 1,00 e 0,99 contro 1,37 e 1,66).
4. **Correlazione:** 53 set oro = una sola famiglia (stesso motore, stesso mercato, copie e vicini). Per la flotta valgono UN posto e quasi certamente correlano con GoldenZoe (trend oro). I set di Wim sono fuori dalla flotta prop "al momento" (decisione 21/11).
5. Sei dei 66 sono duplicati di risultato (62 distinti); K005-K013 sono gli stessi set forex gia' in R1.
