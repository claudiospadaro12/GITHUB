# The Gold Reaper col set di Claudio a 80.000 EUR: lettura (20/10/2026)

**Non controllata da agenti.** Previsioni scritte prima: `GOLD_REAPER_80K_ATTESE_2026-10-20.md` (255cc3a6). Dati: `backtest_pipeline/risultati_archivio/GR80K_20261020/`; letture: `backtest_pipeline/gr80k_leggi.py`, `gr80k_port.py` (miei, non lo strumento congelato).

## Conformita'
Corsa continua 01/01/2025-01/10/2026, XAUUSD H1, ticks reali 100% (146.152.231 tick), deposito 80.000, leva 100, ExecutionMode 0. I 4 input imposti (`TradeFrequency=2, MaxAllowedDD=9.0, PropFirmMaxDailyDD=4.0, OnlyUp=false`) confermati dal report. .ex5 SHA AB636AF9... uguale prima e dopo. Nessuno stop-out, nessun "no money". Durata 10.835 s (3 h). Errori nel giornale: GMT URL (4014) e modifica stop (4753), come a 5.000: filtro news/orario non verificabile nel tester.

## Numeri (80.000) contro la corsa a 5.000
| | 5.000 | 80.000 |
|---|---|---|
| netto | +3.969,57 (+79,4%) | **+59.796,28 (+74,7%)** |
| PF | 2,88 | **2,89** |
| operazioni | 791 | **791** (identiche) |
| DD equity dal picco | 4,77% | 2,97% (3.854 EUR) |
| **DD equity in % degli 80.000 iniziali** | 2,67% del deposito | **4,8%** |
| lotti aperti | 0,01-0,02 | **0,07-0,42** (mediana 0,14) |
| posizioni contemporanee | 11 | 11 |
| mesi positivi | 18/21 | **18/21 (85,7%)** |
| peggior giorno | - | -1.513,84 (1,9% di 80K) |
| costo (K=1: 0,18 EUR per 0,01 lotto) | - | 2.193 EUR; netto/costo **27x**; a K=3 netto +55.410 |
H1 gen25-mag26 +44.625,75; H2 giu26-set26 +15.170,53 (S-H ok). Mesi negativi: feb25 -1.899, ott25 -782, lug26 -1.141.

## Previsioni
- **G1** (lotto scala, >0,02): **CONFERMATA** (0,07-0,42). Il lotto medio per trimestre resta 0,13-0,17 mentre il saldo sale da 80K a 140K: non e' proporzionale al saldo; due gruppi di taglie (0,08-0,21 e 0,27-0,42) probabilmente per strategia, logica interna non leggibile.
- **G2** (+40..+120%): **CONFERMATA** (+74,7%).
- **G3** (DD <= 8% dal picco; <= 10% degli 80K): **CONFERMATA** (2,97% / 4,8%; stima 3-8% giusta).
- **G4** (operazioni 633-949, posizioni <= 11): **CONFERMATA** (791 = 791 identiche; 11).
- **G5** (rapporto lotto max/min fra 1,5 e 4): **SBAGLIATA**: 6,0 (0,42/0,07). Anche escludendo l'unico lotto da 0,07 il rapporto e' 5,25.
- **G6** (regola giornaliera interviene piu' spesso): **NON VERIFICABILE** dal report; si vede solo che il peggior giorno e' -1,9% di 80K, sotto il 4%.

## Cancelli (senza ammorbidire)
S-N 791 ok; S-M 85,7% ok; S-H ok; S-DD ok (perdita dal deposito: nessuna oltre 4,8%; DD 2,97%); S-COSTO 27x ok; **S-NOSCALA: NON PASSA alla lettera** (rapporto lotti 6,0 > 3; 11 posizioni > 10). Il dato e' quello gia' noto a 5.000 per le posizioni; il rapporto lotti sale a 6 perche' qui il lotto non e' piu' schiacciato dal pavimento 0,01. Resta una violazione formale: la decisione se accettarla e' di Claudio, io non la riscrivo.

## Portafoglio Prop Firm + Gold Reaper a 80K (serie giornaliere dei realizzi, mio calcolo)
- correlazione giornaliera 0,122 (IC95 bootstrap seed 12345: 0,022-0,221) <= 0,5 ok; **mensile 0,450** (< 0,5 ma vicina).
- netto +93.926 (+117%); mesi positivi 16/21; peggior giorno -3.102 (3,9% di 80K).
- DD dei realizzi concatenati 8.102 EUR = **10,13% di 80K** (il solo Prop Firm 12,6%, il solo GR 3,3%).
- Tetto (somma DD equity dei due, 11.023 + 3.854) = 14.877 = **18,6% di 80K**.
- **S-PORT (tetto <= 10%)**: pavimento 10,13% gia' sopra 10% di poco, tetto 18,6%: **NON PASSA** nella base 80K-iniziali. Con 80K a deposito fisso e senza ridurre lotti il pacchetto non rispetta il tetto; il Gold Reaper da solo (4,8%) si'.

## Cosa NON dice
Slippage con lotti 0,3-0,4 (il tester non ne ha), margine reale oro (8.580 EUR/lotto nel tester, 1.784 sul reale), filtro news (calendario assente), offset GMT 2/3 fissati da set contro BCM UTC+1 (stessa questione dell'ORB Master), e se i lotti restano gli stessi su un conto prop reale. Il vantaggio rispetto al Prop Firm (DD 4,8% contro 13,8% degli 80K a parita' di rendimento maggiore) e' misurato in un solo percorso storico.
