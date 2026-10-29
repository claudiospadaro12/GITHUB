# Portafoglio oro in una prop da 80.000 CON il Guardian FTMO (29/10/2026)
**Natura: STIMA da somma di corse indipendenti. Non controllata da agenti.** Richiesta di Claudio (29/10): "abbiamo il guardiano impostato, calcola anche questo". Script `backtest_pipeline/simula_guardian_portafoglio_oro.py` (numpy; barre M1 dell'export; stessi dati di `PORTAFOGLIO_PROP_ORO_TRE_ANNI_2026-10-28.md`). Guardian simulato come da `mql5/Presets/ABTG_Guardian_FTMO_2Step.set` e `mql5/Experts/ABTG_Guardian.mq5` (letti): `InpDailyLossPct=4,5` dell'iniziale (3.600 EUR su 80.000), azione = chiude tutto (`FlattenAll`) e blocca la giornata (gli ingressi dopo lo scatto sono cancellati, le posizioni vive chiuse al prezzo della barra di scatto); reset a mezzanotte CE(S)T. **Baseline:** il preset FTMO NON imposta `InpDailyBaseline`, quindi vale il default 0 = EQUITA a inizio giornata; FTMO misura la perdita dal SALDO di mezzanotte (`docs/REGOLAMENTO_FTMO_2026-08.md`): la modalita 1 = SALDO esiste nel codice. Due versioni calcolate.

## Peggior giorno (percentuale sul saldo di inizio giornata) e scatti, Guardian acceso
| Anno | Combinazione | Scatti (baseline saldo) | Peggior giorno, baseline equita | Peggior giorno, **baseline saldo** | Netto con Guardian (senza) |
|---|---|---|---|---|---|
| 2013 | Reaper + Goldbot | 4 | -4,72% | **-4,66%** | +35.201 (+35.304) |
| 2013 | + Phantom | 6 | **-5,87%** | **-5,17%** | +37.227 (+45.627) |
| 2013 | tutti e 4 | 8 | -5,23% | -5,23% | +61.588 (+81.943) |
| 2018 | Reaper + Goldbot | 0 | -3,79% | -3,79% | +15.880 |
| 2018 | + Phantom | 1 (10/01) | -4,48% | -4,48% | +19.796 (+20.739) |
| 2018 | tutti e 4 | 5 | -4,63% | -4,63% | +22.784 (+39.405) |
| 2020 | fino a 3 EA | 0 | invariato | invariato | invariato |
| 2020 | tutti e 4 | 2 | -4,09% | -3,80% | +53.191 (+56.407) |
| 2025 | fino a 3 EA | 0 | invariato | invariato | invariato |
| 2025 | tutti e 4 | 2 | -4,26% | -4,26% | +57.110 (+67.762) |
Nei tre anni con fino a tre EA lo scatto avviene solo nel 2013 e nel 2018 (10/01/2018). Reaper da solo: 2 scatti nel 2013 (23/01 e 18/12), netto +23.645.

## Lettura
- **Reaper + Goldbot One:** il Guardian non cambia il risultato (netto 2013 +35.201 contro +35.304; peggior giorno -4,66%); resta sotto il 5% anche senza.
- **Con il Phantom:** il Guardian scatta il 23/01/2013 ma sulle barre da 1 minuto la perdita arriva comunque a **-5,17%** (circa 4.130 EUR contro 4.000 di FTMO, DERIVATO): nel tester la discesa e dentro una sola barra, il Guardian reale (a ogni tick) potrebbe chiudere piu vicino a -4,5%. **Con baseline equita (default) il giorno peggiore e -5,87%**: qui la baseline conta. Costo: netto 2013 -18% (+37.227 contro +45.627), 6 scatti.
- **Con tutti e 4:** 8 scatti nel 2013, 5 nel 2018, 2 nel 2020 e 2 nel 2025; netto 2013 +61.588 contro +81.943, 2018 +22.784 contro +39.405; giorno peggiore -5,23% nel 2013. **Limite totale (InpTotalDDPct 9,3% = 7.440 EUR) NON simulato:** con i 4 nel 2013 l'equity minima e -11,2% dal deposito, quindi il Guardian fermerebbe la challenge (DD totale) prima.
- **Cosa fa il Guardian e cosa no:** chiude a una soglia assoluta di 3.600 EUR (non una percentuale del saldo corrente) e butta via i recuperi del giorno; la pausa morbida (3,5%) vale per gli EA che leggono la sua variabile globale: gli EA di Wim non la leggono, quindi per loro conta solo la chiusura a 4,5% (che li richiude se riaprono).

## Cosa NON dice
Barre M1: la chiusura alla barra di scatto non e il tick reale (slippage, gap e latenza non simulati); somma di corse indipendenti, ogni EA dimensiona sul proprio saldo e, dopo uno scatto, la storia dell'EA non riparte da stato diverso (grid, `MaxAllowedDD`, `OnlyUp` non ricalcolati); costi di apertura delle posizioni cancellate non rimossi; 2013, 2018, 2020 a Modello 1; un percorso per anno. **Non ho modificato il preset del Guardian:** impostare `InpDailyBaseline=1` e una decisione di Claudio.
