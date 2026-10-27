# Luna LS400 sui tre anni e Reaper con MaxAllowedDD=0 / PropFirmMaxDailyDD=0: RISULTATI (27/10/2026)
**Natura: LETTURA. Non controllata da agenti.** Zip `ANNO80K_ORDINE_20261027_0037` (5 passate della riga `RIGA_LANCIA_ORDINE_LUNA_E_REAPER_80K.txt`, pin 6b849dec). Criteri e previsioni scritti prima: `ORDINE_LUNA_TRE_ANNI_E_REAPER_PROTEZIONI_OFF_CRITERI_2026-10-26.md`. Lettore `leggi_tre_anni_80k.py` (Luna; riferimento tick reali = `2025_M4_LUNA_LS400` dell'archivio forex) e lettura diretta dei deal del report (Reaper).

## Luna AI Pro LS400, 80.000 EUR, EURUSD M5 (EURAUD+GBPAUD+GBPCHF), Modello 1
| anno | regime | ops | netto | PF | DD equity | peggior giorno | giorni >=5% |
|---|---|---|---|---|---|---|---|
| 2013 | ribasso | 656 | -22.604 (-28,3%) | 0,65 | 25.120 | -4,6% | 0 |
| 2018 | laterale | 694 | +16.163 (+20,2%) | 1,41 | 13.312 | -5,7% | 2 |
| 2020 | rialzo | 787 | +24.962 (+31,2%) | 1,54 | 8.836 | -5,3% | 1 |
| 2025 M1 | calibrazione | 804 | +78.702 (+98,4%) | 3,82 | 5.156 | -2,0% | 0 |
| 2025 M4 (tick reali, 26/10) | riferimento | 340 | +7.740 (+9,7%) | 1,45 | 6.586 | -3,0% | 0 |
- **NON PROP-ANNI**: 2013 negativo, DD equity sopra 8.000 in tutti e tre gli anni vecchi, giorni con perdita >=5% nel 2018 e nel 2020, nessuno stop out.
- **Calibrazione NON ATTENDIBILE**: il Modello 1 dice +98% dove i tick reali dicono +9,7% (rapporto mensile 7,61, correlazione 0,01). Quindi anche i numeri del 2013/2018/2020 a Modello 1 non valgono come grandezza (il DD a Modello 1 e 5.156 contro 6.586 a tick reali: lo sottostima). Il verdetto "no" resta, perche sbaglia nel verso peggiore anche con il Modello 1 che e piu generoso.
- Lo storico M1 delle tre coppie 2013 c'era (nessuna passata KO).

## Gold Reaper, MaxAllowedDD=0 e PropFirmMaxDailyDD=0 (21 mesi, tick reali, 80.000 EUR)
| | netto | PF | DD equity | operazioni | lotto |
|---|---|---|---|---|---|
| protezioni 9% / 4% (GR80K 20/10) | +59.796 | 2,89 | 3.854 | 791 | 0,07-0,42, medio 0,154 |
| MaxAllowedDD=0 / PropFirmMaxDailyDD=0 (questa) | +3.620 (+4,5%) | 2,79 | 238 (0,30%) | 791 | **0,01 fisso su tutte** |
- **Le due corse hanno gli STESSI 1.582 deal, con gli stessi istanti e le stesse direzioni** (verificato deal per deal). Le protezioni a 9% e 4% non hanno cambiato nemmeno un'operazione in 21 mesi.
- **La corsa NON misura "protezioni spente a dimensione normale"**: con MaxAllowedDD=0 l'EA scende al lotto minimo 0,01 (misurato: 791 entrate su 791 a 0,01). Il lotto del Reaper dipende da MaxAllowedDD (che quindi non e solo un freno). Quale dei due input fa scendere il lotto: **NON MISURATO** (si e cambiato insieme); che il lotto sia proporzionale a MaxAllowedDD: ipotesi, non verificata.
- I criteri O4-O6 scritti prima non si applicano: il confronto e fra lotti diversi. Non si trae nessun giudizio sul rischio del Reaper da questa corsa.

## Previsioni contro esito
O1 (Luna PROP-ANNI) 40%: NO. O2 (calibrazione OK) 55%: NO. O3 (storico 2013 presente) 70%: SI. O4-O6: invalidate dal lotto fisso (O4 netto -94%, O5 DD 238 <= 8.000, O6 nessun giorno >=3%: letti, ma non confrontabili).

## Cosa NON dice
Luna: un solo percorso per anno, Modello 1 inattendibile, nessun filtro news, nessuna slippage. Reaper: serve una corsa nuova che spenga SOLO PropFirmMaxDailyDD (MaxAllowedDD=9 invariato) per sapere se la protezione giornaliera e mai intervenuta con lotti veri; resta l'orologio AutoGMT 2/3 contro BCM UTC+1 e l'equity giorno per giorno (serve export M1). Nessun merito d'acquisto, lotto o taglia.
