# Vortex Turbo e Umbra Vault in prova FTMO da 80.000 EUR su un anno + natura dei motori (26/10/2026)
**Natura: LETTURA di corse gia fatte, SOLO REALIZZATO (limite inferiore: FTMO misura sull'equita).** Fonte: corse continue 01/01/2025-01/10/2026, XAUUSD H1, tick reali, 80.000 EUR, leva 1:100, default del venditore, nessun guardiano (archivio `DEEP80K_MARKET_NUOVI_20261025`, `DEEP80K_GUARDIA_20261025`). Lettori: `backtest_pipeline/leggi_prop80k_anno.py` (usa `leggi_giorni_dd_prop.py`), `natura_motore_ea.py`. Regole prop usate (come da documenti di casa, da riverificare sul contratto): perdita giornaliera 5% del saldo a inizio giorno, perdita totale 10% dal capitale iniziale, obiettivo fase 1 +10%. Giorno FTMO = mezzanotte CE(S)T. Nessuna slippage nel tester. I default di Umbra sono ri-ottimizzati dal venditore su periodo non dichiarato (possibile in-sample).

## Primi 12 mesi da 80K (gennaio-dicembre 2025)
| | Umbra senza guardia | Umbra con guardia venditore | Vortex Turbo |
|---|---|---|---|
| Operazioni / PF | 250 / 5,75 | 209 / 2,14 | 511 / 2,64 |
| Netto | +74.711 (+93,4%) | +35.664 (+44,6%) | +49.287 (+61,6%) |
| DD realizzato dal picco | 7.535 (9,4%) | 8.339 (10,4%) | 896 (1,1%) |
| Giorni con perdita realizzata >=5% | **2** (12/02: -8,4%, -7.208) | 7 (peggiore 02/04: -5,2%) | 0 |
| +10% toccato | 07/04 | 26/05 | 18/03 |
| Prima violazione | **12/02/2025** (giorno >= 5%) | 03/02/2025 (giorno >= 5%) | nessuna |

## Finestre di 12 mesi con partenza ogni mese (letta in % del saldo di partenza; NON ricalcolo a 80K esatti)
Sfida superata = +10% toccato prima di qualunque violazione.
- **Umbra senza guardia:** superata 6 su 10 (partenze mag-ott 2025), fallita 4 (gen, feb, apr, ... con giorno >= 5% prima dell'obiettivo). Tutte le finestre contengono almeno un giorno >= 5%; il 19/03/2026 (-8,1%, -15.324) rompe qualunque conto ancora aperto.
- **Umbra con guardia:** superata 5 su 10, fallita 5; ogni finestra ha 5-8 giorni a -5%: la guardia chiude al limite e trasforma il flottante in perdita.
- **Vortex:** 6 finestre su 6 con partenza gen-giu 2025 senza nessuna violazione, +61-65%, DD realizzato 1,1%. Le finestre con partenza lug-ott 2025 includono giugno 2026 (-11.244) e luglio 2026 (-26.780; giorno 01/07/2026 -11,8%, -17.481): DD realizzato 19-45% del conto di partenza, 1-3 giorni >= 5%.
- **Vortex: il realizzato non vede il flottante.** E una griglia con raddoppio: l'equita in questi 12 mesi e' NON MISURATA (serve l'export M1). DD equity sull'intera corsa: 48.522 EUR (29,7% del picco).

## Natura dei motori (dagli input del report e dal comportamento delle operazioni nelle corse da 80K; il segnale d'ingresso NON e leggibile: .ex5 compilati)
| EA | Struttura misurata | Esito della misura |
|---|---|---|
| Umbra Vault | 1 posizione alla volta; TP 750 / SL 3.000 punti con trailing (attivazione 120, passo 70); auto-lotto; filtro orario e news spenti; guardia prop spenta | 79% vincenti, payoff 1,87, nessun ingresso di mediazione (0 su 434), durata mediana 7 min, perdita max -15.314: profilo "molte piccole vincite, rara perdita grossa" |
| Microedge | 1 posizione; TP 700 / SL 3.000, trailing 150/30; auto-lotto; guardia prop spenta | 87% vincenti, payoff 0,42, 0 su 304 mediazioni, mediana 10 min, perdita max -15.781: stessa famiglia di Umbra (struttura quasi gemella: INFERITO) |
| Gold Snap | 1 posizione; ordini pendenti su livelli di pivot (`InpPivotTolerance`, `InpPendOffsetPts`), trailing a gradini, lotto = 2% di rischio (`InpLotMethod=7`), `InpMaxDD=0` | 86% vincenti, payoff 0,51, 0 su 209 mediazioni, mediana 3 min, max 150 min; lotto 5->51 col saldo; perdita max -34.745 |
| Vortex Turbo | **Griglia con raddoppio**: `STEP=30`, `GKOLL=4` livelli, `koeff=2.0` (moltiplicatore), `TKProfit=40`, `RST=250`, filtro news acceso | 47% degli ingressi aggiunge nella stessa direzione a prezzo peggiore; rapporto lotto/lotto precedente mediano **2,00**; livelli: 448 al 2o, 234 al 3o, 105 al 4o... (fino a 4 posizioni); 53% vincenti; perdita max -9.085. Coerente con il venditore: "controlled martingale and averaging grid" |
| SomaGold | **Portafoglio di 32 sub-strategie** (`StrategiesToRun=1..32`, magic 711xxx e 712xxx), filtri NFP/IR/CPI che chiudono, fasce orarie, lotto a rischio con `OnlyUp=true` (il lotto non scende mai), protezioni prop e MCP spente | fino a 31 posizioni contemporanee (media 0,38), 42% degli ingressi con una posizione opposta gia aperta (le sub-strategie non si coordinano: copertura involontaria), 1% di mediazioni, 68% vincenti, durata mediana 30 min ma p90 14 ore e max quasi 7 giorni |

Nomi commerciali ("Neural", "AI") NON verificabili: negli input non c'e nulla che indichi apprendimento; le uscite sono distanze fisse in punti con trailing.

## Cosa NON dice
Una sola traiettoria storica, oro quasi sempre al rialzo, nessuna slippage, default forse ottimizzati sul periodo; il realizzato sottostima il rischio; nessuna decisione su acquisti, lotti o taglie.
