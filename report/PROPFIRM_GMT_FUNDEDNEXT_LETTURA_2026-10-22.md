# Prop Firm Gold EA su server FundedNext (GMT+2/+3): lettura (22/10/2026)

Fonte: `PF4.zip` (6 passate, XAUUSD M30, OHLC 1 minuto, 80.000 **USD**, protezione 4% accesa, input confermati dal report in tutte, nessun stop out). Archivio `risultati_archivio/PF4_20261022`; lettore `backtest_pipeline/pf4_leggi.py`. Attese: `PROPFIRM_GMT_FUNDEDNEXT_ATTESE_2026-10-22.md`. Non controllata da agenti. DD % = DD equity / 80.000.

## Avvisi di validita (leggere prima dei numeri)
1. **W2 e TRONCATA**: il primo affare e del **02/01/2020**, non del 2018 (storico FundedNext: qualita 90%, 77.039 barre contro 103.009 di BCM). La finestra "dal 2018" NON esiste su FundedNext: si confronta solo **2020-2026 (81 mesi)**.
2. **Il .ex5 e DIVERSO da quello del PF3**: SHA256 `BD812680...` 103.638 byte, data file 22/10/2026 22:03 (scaricato oggi), contro `108DCCB0...` 103.426 byte del 18/10 usato su BCM. Un'altra build (aggiornamento del venditore?) **[NON VERIFICATO: versione]**.
3. Feed diverso (spread, prezzi, qualita 98% in W1 e 90% in W2) e valuta USD.
Quindi **la differenza col PF3 NON si attribuisce al fuso**: fuso, feed, storico e build sono confusi insieme.

## Risultati
| cella | finestra | affari | netto | PF | DD equity (% di 80K) | mesi + |
|---|---|---|---|---|---|---|
| 0,25% | W1 2025-26 | 631 | +5.671 | 1,31 | 2,13% | 62% |
| 0,5% | W1 | 631 | +12.377 | 1,31 | 4,74% | 67% |
| 0,75% | W1 | 631 | +18.848 | 1,30 | 7,57% | 67% |
| 0,25% | 2020-26 | 2.643 | +13.203 | 1,21 | 2,96% | 59% |
| 0,5% | 2020-26 | 2.643 | +29.341 | 1,22 | 5,34% | 58% |
| 0,75% | 2020-26 | 2.642 | +47.736 | 1,23 | 8,87% | 62% |
Rapporto lotti W2: 4,0 / 4,2 / 3,7 (oltre il 3). Perdita peggiore per affare = rischio% (199 / 397 / 598).

## Confronto per anno, 0,5% con protezione (FundedNext in USD, BCM in EUR dal PF3)
| anno | FundedNext | BCM |
|---|---|---|
| 2020 | +6.471 | +7.247 |
| 2021 | **+4.109** | **-2.939** |
| 2022 | -331 | -33 |
| 2023 | +522 | +32 |
| 2024 | +6.606 | +6.879 |
| 2025 | +5.711 | +6.080 |
| 2026 | +6.253 | +5.781 |
Le **annate 2022-2026 sono quasi identiche**; la differenza sta nel **2021** (e in parte nel 2020). Gli ultimi 21 mesi: PF 1,30-1,31 contro 1,26-1,27, DD 2,13/4,74/7,57% contro 2,06/4,52/6,17%, netto in % del deposito +4% / +10% / +3% rispetto a BCM.

## Orari degli ingressi (misurato)
Gli ingressi cadono **alla stessa ora del server su entrambi** (picco alle 01:xx nei giorni da martedi a venerdi e alle 07:xx): non sono spostati di +1/+2 ore. L'EA lavora quindi sull'orologio del server, e in tempo reale su BCM entra 1-2 ore DOPO rispetto a FundedNext. Il lunedi differisce: 50 ingressi contro 89 di BCM in W1 (tutta la differenza di 42 affari fra 673 e 631). Nessun ingresso di domenica **su nessuno dei due**.

## Contro le previsioni (scritte prima)
- **G1** esecuzione e W1 intera: **CENTRATA**.
- **G1b** W2 intera: **FALLITA** (primo affare 02/01/2020).
- **G2** fuso: **NON DIMOSTRATO**. La domenica non discrimina (anche BCM non ha ingressi di domenica nel 2025-26) e gli orari non sono spostati come previsto: previsione "spostati di +1/+2 ore" **FALLITA**. Il fuso non e misurato direttamente.
- **G3** affari: W1 -6% (centrata); W2 contro 3.828 non applicabile (finestra troncata); contro BCM nello stesso periodo (2.883) -8%.
- **G4** DD W2 0,5% fuori da 8,5-10,4%: 5,34% contro circa 8,1% di BCM nello stesso periodo: **CENTRATA** nella forma, ma finestra diversa.
- **G5** PF W2 sotto 1,20: **FALLITA** (1,21-1,23); mesi positivi sotto 60% in tutte: **FALLITA** (62% a 0,75%); anni 2018/2019/2021 negativi: **non misurabile**.
- **G6** W1 entro +/-30%: **CENTRATA**.
- **G7** durata: T1 103 s (oltre i 10 minuti era la previsione: **NON centrata**); nessun TIMEOUT: centrata; W2 9-17 minuti.

## Lettura
- Negli **ultimi 21 mesi** FundedNext e BCM danno **praticamente lo stesso risultato**: il fuso non cambia molto la storia recente.
- Dal **2020** su FundedNext il Prop Firm e piu pulito (PF 1,21-1,23, DD 3-9%) di BCM (PF 1,13-1,15), ma la differenza e tutta nel 2020-21; **non si separa fuso, feed (qualita 90%) e nuova build**.
- Sul 2020-26 con FundedNext la cella 0,75% passa S-N, S-M (62%), S-H e S-DD; **S-NOSCALA no** (rapporto lotti 3,7 > 3). 0,25% e 0,5%: S-M no (59% e 58%). Finestra post-hoc e piu corta: **non e una conferma**.
- Nessuna taglia e nessun consiglio di acquisto.
