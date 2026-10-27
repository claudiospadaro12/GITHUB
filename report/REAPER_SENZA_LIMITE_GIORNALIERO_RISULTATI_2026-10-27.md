# Gold Reaper senza il limite giornaliero interno: RISULTATI (27/10/2026)
**Natura: LETTURA. Non controllata da agenti.** Zip `ANNO80K_REAPER_SENZALIMITE_20261027_1734` (4 passate della riga `RIGA_LANCIA_REAPER_SENZA_LIMITE_80K.txt`). Criteri e previsioni scritti prima: `REAPER_SENZA_LIMITE_GIORNALIERO_CRITERI_2026-10-27.md`. Strumenti: `confronta_reaper_limite.py` (deal per deal) e `leggi_equita_reaper_goldbot.py` (equita dalle barre M1 esportate il 27/10). Unico input cambiato: `PropFirmMaxDailyDD` da 4 a 0 (MaxAllowedDD=9, TradeFrequency=2, OnlyUp spento invariati).

## Esito
| corsa | operazioni diverse dal riferimento (col limite a 4) | netto senza / con | DD equity | peggior giorno realizzato |
|---|---|---|---|---|
| 21 mesi a tick reali | **0** (1.582 deal identici) | +59.796 / +59.796 | 3.854 / 3.854 | -1,2% / -1,2% |
| 2020 (M1) | **0** | +20.388 / +20.388 | 3.839 / 3.839 | -1,6% / -1,6% |
| 2018 (M1) | **0** | +13.535 / +13.535 | 5.504 / 5.504 | -2,2% / -2,2% |
| **2013 (M1)** | **905 deal diversi a partire dal 23/01/2013** | **+18.592 / +21.757** (-3.164) | **8.039 / 5.621** | **-5,4% (-4.334) / -4,6% (-3.697)** |

- **Il limite giornaliero e intervenuto UNA volta sola, nel 2013 (23/01/2013).** Col limite il Reaper ha chiuso 25 posizioni alle 15:02 e il giorno e finito a -4,6% (-3.697); senza, le posizioni sono rimaste e il giorno e finito a -5,4% realizzato (-4.334) con l'ultima chiusura alle 23:06; **sull'equita ricostruita da barre M1 il peggior giorno e -7,25% (centrale) / -7,44% (pessimistica)**, contro -4,57% col limite. Il 24/01 e l'unico altro giorno diverso (-3,0% in equita).
- **Nei 21 mesi del 2025-2026, nel 2018 e nel 2020 non e mai intervenuto**: nessuna operazione diversa. Sull'equita dei 21 mesi, senza limite: 0 giorni >= 3% (peggior giorno -2,32% centrale, -2,45% pessimistica).
- **Quindi il limite fa quello che dice, ma solo nei giorni cattivi e non e gratuito**: nel 2013 ha tolto 3.164 EUR di netto e ha tenuto il giorno sotto il 5% di FTMO. Senza il limite quel giorno avrebbe violato la regola FTMO (-5,4% realizzato, -7,25% equita).

## Previsioni scritte il 27/10 contro esito
J1 (21 mesi identici, 75%): **SI**. J2 (netto entro +-1%, 75%): **SI**. J3 (il 2013 differisce, 40%): **SI**. J4 (2018 e 2020 identici, 85%): **SI**. J5 (nessun giorno >= 5% realizzato nelle 4 corse, 80%): **NO** (2013: -5,4%). J6 (DD equity 21 mesi <= 8.000, 90%): **SI** (3.854).
Criteri di passaggio (netto > 0, DD equity <= 8.000, nessun giorno >= 5% realizzato): **i 21 mesi, il 2018 e il 2020 passano; il 2013 senza limite NON passa (DD 8.039, giorno -5,4%).**

## Cosa significa e cosa NO
- **Per FTMO il limite a 4% va tenuto**: e l'unico dei tre anni vecchi in cui un giorno si avvicina al limite e li ha salvato il conto.
- Il limite ha chiuso le posizioni in perdita il 23/01/2013 e ha un costo (-3.164 EUR in quell'anno): e un'assicurazione, non una strategia. Il 2013 e Modello 1 (OHLC), il cambio USD/EUR del 2013 (0,75) e fuori dalla fascia 0,78-1,00 scritta nel criterio (indicativo).
- Un solo evento (23/01/2013) fa il caso "il limite agisce"; non dice quante volte agirebbe nei prossimi anni.
- L'orologio del limite (AutoGMT con offset 2/3 contro BCM UTC+1) resta non verificato dal vivo.
