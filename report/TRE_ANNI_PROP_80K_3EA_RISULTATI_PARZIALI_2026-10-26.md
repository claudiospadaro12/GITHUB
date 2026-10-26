# Gold Reaper e Prop Firm Gold a 80.000 EUR su 2013/2018/2020: RISULTATI (26/10/2026). Goldbot One: NON MISURATO
Criteri e previsioni: `TRE_ANNI_PROP_80K_3EA_CRITERI_2026-10-26.md`; lettore congelato `backtest_pipeline/leggi_tre_anni_80k.py`; zip `ANNO80K_TRE_EA_20261026_1444` (8 corse valide, stato OK, qualita 99-100%, nessuno stop out, nessun no money); archivio `risultati_archivio/ANNO80K_TRE_EA_ZIP_1444` (il lettore ricava l'anno dal percorso: la cartella contenitore non deve contenere 20xx fuori dalle sottocartelle). Modello 1, 80.000 EUR, XAUUSD H1, leva 1:100, nessun guardiano esterno. Input: Gold Reaper imposti e confermati dal report (`TradeFrequency=2, MaxAllowedDD=9.0, PropFirmMaxDailyDD=4.0, OnlyUp=false`); Prop Firm Gold: nessun input imposto.
**Goldbot One: le sue 5 passate NON sono partite** per un errore MIO nello script (`-Periodo D1` non era ammesso; il report del tester scrive Daily). Corretto in ANNO80K_TESTER v2 (pin e741084d), riga a parte.

| | 2013 SHORT | 2018 LATERALE | 2020 LONG | Calibr. 2025 (M1 vs M4) | PROP-ANNI |
|---|---|---|---|---|---|
| **Gold Reaper** netto / PF / DD equity (EUR) | +21.757 (+27,2%) / 1,63 / 5.621 | +13.535 (+16,9%) / 1,51 / 5.504 | +20.388 (+25,5%) / 1,87 / 3.839 | OK (rapporto 1,08, corr. 0,99; M1 +30.457, PF 2,77, DD 3.077) | **SI** |
| giorni con perdita realizzata >=3% / >=4% / >=5% | 3 / 1 / 0 | 0 / 0 / 0 | 0 / 0 / 0 | 0 | |
| peggior giorno / mese realizzato | -4,6% (-3.697) / -3,3% | -2,2% / -2,0% | -1,6% / -2,3% | | |
| **Prop Firm Gold** netto / PF / DD equity | +4.694 (+5,9%) / 1,12 / 6.355 | **-3.198 (-4,0%)** / 0,90 / 8.684 | +10.321 (+12,9%) / 1,28 / 5.093 | OK (rapporto 0,58, corr. 0,99) | **NO** (2018 netto <= 0; DD 8.684 > 8.000) |

## Lettura
- **Gold Reaper regge i tre regimi diversi**: positivo e con DD equity sotto 5.700 EUR (7,0% di 80K) in tutti e tre, +17% nel laterale 2018, nessun giorno >= 5%. **Il punto da guardare**: il 2013 (ribasso) ha un giorno a -4,6% (-3.697) e 3 giorni >= 3%, sopra il 4% della sua protezione interna `PropFirmMaxDailyDD`: il realizzato non dice se la protezione sia intervenuta (flottante chiuso) o meno; resta a 0,4 punti dal 5% di FTMO. Con il 2025 a Modello 1 il Reaper fa +38,1% contro +74,7% di 21 mesi a tick reali (nessun contraddittorio: sono finestre diverse); calibrazione OK.
- **Prop Firm Gold non regge**: perde nel laterale 2018 (PF 0,90) con DD 8.684; guadagni piccoli negli altri anni (+6%, +13%). Bassa volatilita giornaliera (peggior giorno -1,4%) ma poco rendimento.
- Prezzi 2013-2020 molto piu bassi di oggi, Modello 1, nessuna slippage: vale la riserva scritta nei criteri.

## Previsioni (scritte prima)
T1 (calibrazione OK per >= 2 EA su 3, 60%): per ora **2 su 2 misurati OK** (Goldbot non misurato). T2 (nessuno stop out, 85%): centrata sulle 8 corse. T3 (Gold Reaper PROP-ANNI, 45%): **centrata (SI)**. T4 (Goldbot One PROP-ANNI 40%; Prop Firm Gold PROP-ANNI 40%): Prop Firm Gold **NO**; Goldbot non misurato. T5 (2018 anno peggiore per >= 2 EA su 3, 55%): vero per i 2 misurati (2018 e il peggiore per entrambi).

## Cosa NON dice
Tre anni sono tre campioni; Modello 1; realizzato = limite inferiore (FTMO misura sull'equita); nessun merito di acquisto, lotto o taglia.
