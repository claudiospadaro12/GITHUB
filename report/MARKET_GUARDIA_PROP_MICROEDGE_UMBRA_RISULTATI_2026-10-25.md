# Microedge e Umbra Vault con la guardia da prop accesa: risultati (25/10/2026)
**Natura: MISURA + LETTURA.** Criteri e previsioni scritti prima: `MARKET_GUARDIA_PROP_MICROEDGE_UMBRA_CRITERI_2026-10-25.md` (commit 4c30045b). Lettore congelato `leggi_deep80k_nuovi.py`. Archivio: `backtest_pipeline/risultati_archivio/DEEP80K_GUARDIA_20261025` (report compressi, log non archiviati). Corsa continua 01/01/2025-01/10/2026, XAUUSD H1, tick reali 100%, 80.000 EUR, leva 1:100, guardia accesa ai valori del venditore (5% giornaliero, 10% totale); input imposti confermati dal report (nel confronto col setaccio risulta diversa solo la voce di accensione: 5.0 e 10.0 coincidono coi default).

## Esito
| | Microedge | Umbra Vault |
|---|---|---|
| Operazioni | 277 | 347 |
| Netto (senza guardia) | +66.709 (+112.199) | +60.785 (+195.101) |
| PF (senza guardia) | 1,94 (2,81) | 1,90 (6,20) |
| Mesi positivi | 18/21 | 15/21 |
| Meta' 1 / meta' 2 | +72.475 / **-5.766** | +47.102 / +13.683 |
| DD equity dal picco | 15.183 EUR (9,5% del picco) | 15.052 EUR (11,9%) |
| Lotto max/min | 1,99 | 1,83 |
| S-COSTO | 3,8x | 3,1x |
| Ultimo affare | 30/09/2026, 21 mesi su 21 con affari | 30/09/2026, 21/21 |
| **Soglie fallite** | **S-H, S-DD** | **solo S-DD** |

Nessuno dei due passa tutto. **Umbra Vault con la guardia fallisce una soglia sola: S-DD (15.052 EUR contro 8.000).** Con la guardia passa S-NOSCALA (lotto max/min da 3,49 a 1,83).

## Cosa ha fatto la guardia (misurato, con una lettura dichiarata)
- **Non ferma l'EA:** opera fino al 30/09/2026 in tutti i 21 mesi, nessun messaggio di guardia nei giornali.
- **Frena la crescita:** saldo finale 1,8x invece di 2,4x (Microedge) e 3,4x (Umbra); lotto medio degli ultimi tre mesi 4,6 e 4,1 invece di 5,7 e 7,8. Il netto scende dell'41% e del 69%.
- **Non ha portato il DD sotto il tetto in EUR:** 15.183 e 15.052 contro 8.000. **INFERITO:** il 10% totale sembra misurato sul picco di equity che cresce (il DD relativo risulta 9,5% e 11,9%, vicino al 10%), non sul deposito di 80.000; con il picco a circa 147.000 il 10% vale circa 14.700 EUR, che e' l'ordine di grandezza visto. Non verificato sul sorgente (non ce l'abbiamo).
- Il DD relativo non e' migliorato in modo netto: Microedge equity 13,7% -> 9,5%, Umbra 11,2% -> 11,9%; sul solo realizzato 8,1% -> 9,1% e 8,7% -> 10,5%.
- Primi 6 mesi (post-hoc, realizzato): Microedge +23.441 con DD 5.321 EUR (6,7% di 80.000); Umbra +4.625 con DD 8.339 (10,4%).

## Previsioni scritte prima
Corse valide 85%: SI (entrambe). Netto inferiore 85%: SI (entrambe). Guardia che ferma l'EA prima di settembre 2026, 40%: NO (entrambe). S-DD passa, 25%: NO (entrambe). "Candidato" 15%: NO (entrambe). 4 su 5 per EA.

## Cosa significa e cosa no
- S-DD e' scritta come DD equity assoluto <= 8.000 EUR, cioe' 10% del deposito iniziale. Per un EA che compone, il picco sale e la perdita in EUR di un DD "del 10%" sale con lui: la soglia cosi' scritta e' strutturalmente severa. **Non la cambio dopo aver visto i numeri**: sono risultati da leggere con questa soglia. Una soglia diversa (per esempio il DD relativo, o un limite di perdita dal deposito su un conto che non compone) sarebbe un nuovo criterio da scrivere PRIMA di un nuovo test, e sta a Claudio deciderlo.
- Il tester non misura slippage, liquidita' e regole di una prop da 80K. Nessuna decisione su acquisti, lotti o taglie e' mia.
- S-CORR e S-PORT non applicabili: nessun candidato.
