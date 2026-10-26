# Gli EA a 5.000 EUR nei regimi LONG, SHORT e LATERALE: risultati (26/10/2026)
**Natura: LETTURA di dati gia misurati (nessun nuovo giro del tester).** Criteri e previsioni scritti prima: `REGIMI_LONG_SHORT_LATERALE_5K_CRITERI_2026-10-26.md` (commit cad22957). Lettore congelato `leggi_regimi_5k.py` (commit seguente, autotest OK). Dati: i 9 EA a 5.000 EUR, gen 2025-set 2026 (`DEEP5K_PERSONALE_20261026`), uscita completa in `LETTURA_regimi_5k.txt`. Regime dei mesi dalle barre D1 BCM dell'oro: **10 LONG, 8 LATERALE, 3 SHORT** (soglie +-3% scritte prima). Il regime e ex post.
**Limite dichiarato:** non sono 3 anni: i tick reali BCM dell'oro iniziano il 10/07/2024 (VERIFICATO) e i mesi misurati sono 21. **Il campione SHORT e di 3 mesi** (2026.03 -11,1%, 2026.06 -11,5%, 2026.09 -6,6%): tutte le frasi sullo SHORT sono deboli.

## Rendimento mensile medio (realizzato, % del saldo a inizio mese) e etichetta
| EA | LONG (10) | SHORT (3) | LATERALE (8) | Peggior mese | Etichetta |
|---|---|---|---|---|---|
| Gold Snap | +12,9% | +15,0% | +13,7% | +1,0% | SOLIDO |
| SomaGold | +13,0% | +18,4% | +7,1% | -5,5% | SOLIDO (protezione contro il margin call spenta, 84 rifiuti per margine: non entra in "solido") |
| SixtyNine | +4,7% (50% mesi +) | +12,3% | +10,6% | -3,6% | SOLIDO |
| Umbra Vault | +5,1% | +7,4% | +7,0% | -2,6% | SOLIDO |
| Rocket Breakout | +1,8% | +5,0% | +2,6% | -5,7% | SOLIDO |
| Microedge | +5,3% | **-2,3%** (33% mesi +) | +5,6% | -4,3% | NON SOLIDO: debole in SHORT |
| Vortex Turbo | +4,0% | +1,8% | +1,6% | **-18,1% (in un mese LATERALE)** | NON SOLIDO: peggior mese sotto -10% |
| Entry Points Pro | +0,6% | +2,2% | **-1,0%** (38% mesi +) | -2,5% | NON SOLIDO: debole in LATERALE |
| ORB Revolution | **-1,3%** (30% +) | **-1,9%** (0% +) | +1,2% | -5,7% | NON SOLIDO: debole in LONG e SHORT |
"SOLIDO" = rendimento medio > 0 in tutti e tre i regimi, almeno 50% di mesi positivi in ciascuno, nessun mese peggiore di -10% (definizione scritta prima). **Non vuol dire sicuro.**

## Cosa si vede (lettura, con i limiti)
- **Nessun EA perde in modo sistematico nei mesi SHORT** salvo Microedge (3 mesi: -2,3% medio) e ORB Revolution (che perde anche in LONG): in SHORT sei EA fanno di piu che in LONG. **Prudenza:** i tre mesi SHORT sono anche mesi di volatilita altissima (range 12-20%, calo del 6-11%) e a fine 2026, con lotti gia grandi: il vantaggio puo venire dalla volatilita e dal saldo, non dalla direzione. Non l'ho isolato.
- **Direzione delle posizioni:** nei mesi LONG le posizioni long guadagnano piu delle short per tutti e nove; in SHORT le posizioni short guadagnano di piu della long in sei EA (Entry Points, Gold Snap, Microedge, Sixtynine, SomaGold, Umbra) e il resto e misto. Gli EA seguono il mercato, non sono long-only.
- **Vortex Turbo:** il suo mese peggiore (-18,1%) cade in un mese LATERALE (luglio 2026, mese +1,0% dell'oro): conferma che la coda da martingala non dipende dalla direzione.
- **Entry Points** guadagna poco in LONG e perde nel laterale; **ORB Revolution** perde con il trend e va in positivo solo nel laterale (+1,2%): non e solido da nessuna parte.
- **Previsioni scritte prima:** Q1 almeno un EA SOLIDO 35%: **SI, sono cinque** (sbagliata la stima bassa). Q2 SHORT inferiore a LONG per >= 7 EA: **NO** (3 su 9). Q3 SHORT medio negativo per >= 4 EA: **NO** (2). Q4 LATERALE positivo per >= 5 EA: **SI** (8). Q5 nei mesi LONG le posizioni long battono le short per >= 7 EA: **SI** (9). Q6 almeno 2 EA con un mese SHORT sotto -10%: **NO** (nessuno). Totale: 2 su 6.

## Cosa NON dice
Un solo mercato (oro) e un solo periodo in forte salita per due anni: 10 mesi LONG su 21. Tester senza slippage, gap, liquidita; margine del tester e leva 1:100 (la leva del broker personale NON verificata); alcuni EA ottimizzati dal venditore su periodi non dichiarati (Umbra v1.1). I rendimenti compongono (lotti crescono col saldo): un mese a fine periodo pesa in EUR molto piu di uno a inizio. Non e una previsione: il regime e noto solo a mese finito. Nessun acquisto o taglia: decisioni di Claudio.

## Per ampliare (decide Claudio)
- **+6 mesi (10/07/2024-31/12/2024):** si possono misurare con tick reali (H1, 5.000 EUR, circa 2-4 ore in tutto per otto EA, 80 minuti per SixtyNine): portano 3 LONG, 2 LATERALE, **1 SHORT (novembre 2024, -3,5%, al limite della soglia)**. Poco per lo SHORT.
- **Piu SHORT di cosi non ci sono con tick reali:** prima del 07/2024 servirebbe il Modello 1 (barre M1), qualita diversa e storia BCM NON VERIFICATA.
