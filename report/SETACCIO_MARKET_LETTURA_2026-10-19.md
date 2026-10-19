# Setaccio degli EA del Market -- lettura (19/10/2026)

**Non controllata da agenti.** Letti secondo `SETACCIO_MARKET_ATTESE_2026-10-18.md` e `MARKET_SELEZIONE_PER_ACQUISTO_ATTESE_2026-10-19.md` (scritti prima dei numeri). Materiale: `SETACCIO_MARKET.zip` + 25 zip singoli (stesso contenuto), archiviati manifest e referti in `backtest_pipeline/risultati_archivio/SETACCIO_MARKET_20261019/` (strumenti `an_set.py`, `an_set2.py`). Finestra di tutti: **XAUUSD, 01/01-01/03/2026, H1 e M15, 5.000 EUR, ticks reali al 100%**, input di default (nessuno imposto).

## Conformita' [LETTO]
- 31 `.ex5` nella cartella Market: **6 saltati** per nome (Arena, Gold Trade Pro, Goldbot One, The Gold Phantom, The Gold Reaper, The Impossible Gold), **25 setacciati**, rc 0 per 24, rc 3 per Night Scalper (zero operazioni).
- Per tutti: ticks reali 100%, stessa finestra (931 barre H1 / 3.719 M15), `.ex5` con impronta uguale prima e dopo, nessuno stop-out.
- **Input**: scritti nei report, non confrontati con i default dei venditori (NON VERIFICATO: se un EA era stato provato prima nel tester su questo PC, gli input salvati potrebbero non essere i suoi default). Per il test a fondo si imporranno gli stessi valori e si verifichera' nel report.
- **Simbolo**: Waka Waka (AUDCAD, AUDNZD, NZDCAD) e Range Breakout (USDJPY + XAUUSD) hanno operato su **altri simboli** dal grafico dell'oro: non sono misure sull'oro. Pac Man BTC (EA per BTC), Quantum Emperor (descrizione del file: "for GBPUSD") e Quantum Commander (input US30) hanno operato su XAUUSD anche se non nati per l'oro.

## Regole del setaccio (S1, S2, S5)
- **S1 (opera, >= 10 operazioni in almeno una passata)**: tutti, **tranne Night Scalper (0)** e **Quantum Commander (9: "opera poco")**. Night Scalper: **1.133.764 righe "no money"** nel giornale: l'EA ha provato ad aprire e il tester ha rifiutato per fondi/margine; misura mancante, non bocciatura (il lotto richiesto non sta in 5.000 EUR, cio' che e' vero nel tester, il cui margine dell'oro e' ~8.580 EUR/lotto [R114 del 27/08], non sul reale).
- **S2 (dipende dal periodo, fattore > 3 fra H1 e M15)**: **Institutional SMC Robot** (35/107), **Pac Man BTC** (185/919), **Ultimate Breakout System** (143/535). Per questi tre il periodo del test a fondo e' quello dichiarato dal venditore (da leggere sulla pagina): non si sceglie dai risultati. **Per tutti gli altri H1 e M15 danno numeri uguali o quasi** (16 hanno risultati identici): l'EA lavora su timeframe suoi e ignora quello del grafico.
- **S5 (nomi di input che richiamano recupero/griglia/piramidazione)**: Quantum Emperor (`SmartRecovery=true`, moltiplicatore 1,6 per 3 volte), Dynamic Liquidity (`InpEnableRecoveryMode=true`), My AI Gold (`Recovery=true`), Wave Rider (griglia, 10 ordini massimi), Golden Mirage (griglia, `Risk=8.0`), Waka Waka (griglia, multi-simbolo), Institutional SMC (`InpEnablePyramiding=true`). Quantum Titan, Quantum iGold, Scalping Robot Pro hanno `Recovery=false` di default.

## Dati per EA (H1; la passata M15 uguale se non indicato)
| EA | op. | netto 2 mesi | DD equita' | vincenti | lotto min-max | pos. contemporanee max | note |
|---|---|---|---|---|---|---|---|
| AI Golden Life | 130 | +31 | 1,6% | 53% | 0,01 | 1 | profitto/op. circa 1,3x il costo dello spread |
| Drifter EA | 243 | +564 | 13,8% | 78% | 0,01 | **19** | molte posizioni insieme a lotto minimo |
| Dynamic Liquidity Intelligence | 54 | +140 | 1,5% | 85% | 0,01 | 1 | recupero attivo ma non scattato; vincita media 8, perdita media -29 |
| EA Super Trend XAUUSD | 318 (M15: 422) | **+15.247** (M15 +15.679) | 5,8% (M15 16,1%) | 85% | 0,05-0,20 (x4) | 3 | lotto automatico: rischio molto piu' alto degli altri; dichiara XAUUSD H1 |
| Ghost Scalper | 237 | +158 | 1,3% | 52% | 0,01 | 5 | |
| Gold Beaver | 46 | +3.788 | **28,7%** | 80% | 0,01-0,18 (x18) | 5 | quasi solo long (44 su 46); lotto 11,6% di rischio |
| Golden Mirage | 120 | +1.222 | **26,5%** | 79% | 0,04-0,05 | **10** | griglia, `Risk=8.0` |
| Institutional SMC Robot | 35 (M15: 107) | +5.243 (M15 +1.877) | 29,6% (M15 **54,8%**) | 77% | 0,12-0,67 (x5,6) | 2 | piramidazione; dipende dal periodo |
| My AI Gold | 43 | +3.732 | **45,9%** | 77% | 0,16-0,32 | 2 | recupero attivo; vincita media 355, perdita media -797 |
| Nebula Cartographer AI | 43 | +2.650 | 14,6% | 81% | 0,30-0,46 | 1 | PF 35,6, perdita media -6 contro vincita media 78 |
| Night Scalper (NoCap FX) | **0** | 0 | - | - | - | - | 1,13 milioni di rifiuti "no money" |
| Pac Man BTC | 185 (M15: 919) | -699 (M15 -319) | 22,2% | 38% | 0,01 | 2 | EA per BTC; dipende dal periodo |
| PolyGold Scalper | 39 | -816 | 18,1% | 38% | 0,20-0,25 | 1 | usa un'API esterna (Polymarket) [non simulabile nel tester] |
| Prop Firm Gold EA | 55 | +550 (M15 +524) | 3,3% | 58% | 0,01 | 2 | `InpDDProtection`/regole prop non lette |
| Quantum Commander | 9 | -267 | 6,7% | 44% | 0,01 | 1 | input US30, opera poco sull'oro |
| Quantum Emperor | 139 | +189 | 14,6% | **95%** | 0,04-0,06 | 7 | recupero x1,6; vincita media 7, **perdita media -105** |
| Quantum iGold | 201 | **-2.450** | **70,1%** | 53% | 0,10 | 2 | |
| Quantum Titan | 36 | +995 | 10,0% | 72% | 0,08-0,19 (x2,4) | 2 | |
| Range Breakout (Range Filters) | 61 | -351 | 11,3% | 46% | 0,01-0,33 (x33) | 2 | opera USDJPY e XAUUSD |
| Scalping Robot Pro | **9.136** (M15 8.535) | **-4.816** | **96,3%** | 59% | 0,01 | 10 | conto quasi azzerato in 2 mesi; ~1M rifiuti "no money" |
| Smart Gold Hunter | 20 | +29 | 0,2% | 55% | 0,01 | 1 | |
| TitanForge EA | 32 | +2.075 | 5,7% | 88% | 0,30-0,42 | 1 | PF 85,5; perdita media -1,4 contro vincita media 75 |
| Ultimate Breakout System | 143 (M15: 535) | +199 (M15 -86) | 1,2% (M15 4,0%) | 45% | 0,01 | 1 | dipende dal periodo |
| Waka Waka EA | 97 | +53 | 12,3% | 75% | 0,01-0,40 (x40) | 10 | multi-simbolo, griglia |
| Wave Rider EA | 167 | +400 | 7,8% | **95%** | 0,01-0,02 | 4 | griglia; vincita media 3,9, perdita media -26 |

## Cosa dicono questi numeri e cosa NO
- **Due mesi (gen-feb 2026) non giudicano nessun EA**: la soglia di casa per giudicare e' 150 operazioni e un periodo senza una sola fase di mercato; il Gold Reaper ebbe gennaio 2026 come mese di drawdown peggiore (9,4%).
- **I profitti NON sono confrontabili**: gli EA con lotti piu' grandi (EA Super Trend 0,05-0,20; Institutional SMC fino a 0,67; Nebula/TitanForge 0,3-0,46; My AI Gold 0,16-0,32) guadagnano e perdono di piu' sullo stesso conto da 5.000. Il rapporto profitto/drawdown di EA Super Trend, TitanForge, Prop Firm Gold EA e Nebula e' alto, ma e' un dato di due mesi.
- **Segnali di cautela (non prove)**: profit factor 35-85 con perdita media quasi nulla (TitanForge, Nebula) indica che chiudono le perdite quasi in pareggio (trailing o break-even) o che nella finestra non ci sono state perdite vere; vincenti al 95% con perdita media 15-30 volte la vincita (Quantum Emperor, Wave Rider) e' il profilo da "molti piccoli guadagni, rare grosse perdite": due mesi non possono vedere la coda.
- **Selezione del vincitore**: con 25 EA provati, i migliori in due mesi sono in parte i piu' fortunati su quel periodo; per questo il setaccio non fa classifica per profitto.

## Gruppi (descrittivi, secondo le regole scritte prima)
- **A -- struttura semplice, opera** (lotto fisso o quasi, 1-5 posizioni, nessun recupero/griglia attivo): AI Golden Life, Ghost Scalper, Prop Firm Gold EA, Smart Gold Hunter, Quantum Titan, TitanForge, Nebula Cartographer, EA Super Trend XAUUSD (lotto x4: al limite di S-NOSCALA), Ultimate Breakout (periodo da dichiarare), Quantum iGold, PolyGold, Pac Man BTC (questi ultimi tre in perdita nei due mesi).
- **B -- recupero, griglia, piramidazione o molte posizioni** (classe di rischio diversa, da valutare con tetti di esposizione): Drifter (19 posizioni), Golden Mirage, Waka Waka, Wave Rider, Quantum Emperor, Dynamic Liquidity, My AI Gold, Institutional SMC, Scalping Robot Pro, Gold Beaver (lotto x18).
- **C -- misura mancante**: Night Scalper (0 operazioni, "no money"), Quantum Commander (9 operazioni), Range Breakout (opera anche su USDJPY).

## Prossimo passo (da confermare con Claudio)
Test a fondo (21 mesi, mensili + corsa continua) per gli EA di gruppo A e, a parte, per quelli del gruppo B come classe di rischio diversa. Costo in tempo misurato qui: circa 1-2 minuti per due mesi per gli EA veloci (circa 13-20 minuti per 21 mesi), Scalping Robot Pro circa 15 minuti per due mesi. Gli input del giro lungo devono risultare **uguali a quelli del setaccio** (si controlla nel report). Periodo: H1 per gli EA che ignorano il periodo del grafico; per Institutional SMC, Pac Man BTC e Ultimate Breakout serve il periodo dichiarato dal venditore (da leggere sulla pagina).
