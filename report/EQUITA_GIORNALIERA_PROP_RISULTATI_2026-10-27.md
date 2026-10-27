# Equita giornaliera ricostruita da barre M1: RISULTATI (27/10/2026)
**Natura: LETTURA. Non controllata da agenti.** Barre M1 XAUUSD BCM esportate il 27/10 dal PC di backtest (`EXPORT_M1_ORO_V2`, 0 errori, 0 settimane vuote): 21 mesi 01/01/2025-30/09/2026 = 611.062 barre; anno 2013 = 348.647 barre (primo 01/01/2013 23:05, ultimo 31/12/2013 16:59). Criteri: `EQUITA_GIORNALIERA_PROP_CRITERI_2026-10-26.md`. Lettore congelato `leggi_equita_prop.py` per le corse del suo elenco; per Reaper e Goldbot, che non erano nell'elenco, `leggi_equita_reaper_goldbot.py` (stesse funzioni, nessun criterio toccato). Base: saldo a inizio giorno, giorno FTMO = mezzanotte CE(S)T. Equita = flottante dalle barre M1 + operazioni chiuse del tester; "pessimistica" = estremo della barra (limite alto).

## Risultati: giorni con perdita sull'equita >= 5% / 4% / 3% (centrale), 450 giorni, 80.000 EUR
| EA | centrale >=5 / >=4 / >=3 | pessimistica >=5 / >=4 / >=3 | solo realizzato >=5 | peggior giorno (centrale) |
|---|---|---|---|---|
| **Gold Reaper (set di Claudio)** | **0 / 0 / 0** | **0 / 0 / 0** | 0 | **2,32%** (27/03/2025; pessimistica 2,45%) |
| Prop Firm Gold EA | 0 / 0 / 0 | 0 / 0 / 0 | 0 | 2,34% (stima) |
| Smart Gold Hunter | 0 / 0 / 0 | 0 / 0 / 0 | 0 | 0,01% |
| ORB Revolution | 0 / 0 / 0 | 0 / 0 / 0 | 0 | 2,50% |
| Entry Points Pro | 0 / 0 / 0 | 0 / 0 / 0 | 0 | 2,22% |
| Rocket Breakout | 0 / 0 / 2 | 0 / 0 / 2 | 0 | 3,65% |
| SixtyNine | 0 / 1 / 11 | 4 / 11 / 31 | 0 | 4,62% (stima) |
| Gold Snap | 1 / 2 / 16 | 6 / 12 / 28 | 1 | 6,10% |
| Vortex Turbo | 4 / 6 / 11 | 5 / 9 / 16 | 3 | **11,92%** (stima) |
| SomaGold (protezione spenta) | 6 / 9 / 16 | 13 / 19 / 30 | 2 | **16,73%** (stima) |
| Umbra Vault | 10 / 17 / 35 | 12 / 23 / 39 | 3 | 8,77% |
| Microedge | 11 / 17 / 27 | 12 / 18 / 27 | 5 | 8,01% |
| Umbra con guardia venditore | 12 / 18 / 32 | 12 / 22 / 36 | 12 | 5,15% |
| Microedge con guardia venditore | 11 / 16 / 25 | 12 / 17 / 25 | 11 | 5,03% |
Goldbot One (anno 2025 a tick reali, 257 giorni): 0 giorni >= 3% (centrale e pessimistica), peggior giorno 1,06%.
**2013 (Modello 1, 278 giorni)**: Gold Reaper 0 giorni >= 5%, **1 giorno >= 4% (-4,57% il 23/01/2013, pessimistica uguale)**, 3 >= 3% (4 in pessimistica); uguale al realizzato: l'equita non aggiunge un giorno peggiore. Goldbot One 2013: 0 giorni >= 3%, peggior giorno 1,12% (pessimistica 1,17%). **Riserva dichiarata**: il cambio USD->EUR mediano del 2013 e 0,753 (corrisponde a EUR/USD circa 1,33 dell'epoca), fuori dalla fascia 0,78-1,00 scritta nel criterio (pensata per il 2025-26): per la regola scritta il 2013 sarebbe "NON ATTENDIBILE"; lo riporto come indicativo, anche perche e Modello 1.

## Scorecard delle previsioni scritte il 26/10
E1 (equita >= realizzato per ogni EA, 99%): **SI**. E2 (almeno 3 EA con giorni >= 5% in equita dove il realizzato ne aveva zero, 65%): **NO** (nessuno in centrale). E3 (Gold Snap, SixtyNine e SomaGold con almeno 3 giorni >= 5%, 55%): **NO** (1, 0, 6). E4 (Smart Gold Hunter, Prop Firm Gold e Entry Points a zero, 75%): **SI**. E5 (cambio mediano fra 0,78 e 1,00 per tutte, 90%): **SI per i 21 mesi (0,86), NO per il 2013 (0,75)**.

## Lettura
- **Il Gold Reaper regge la prova dell'equita**: nei 21 mesi nessun giorno oltre il 2,5% nemmeno con la stima pessimistica; nel 2013 un solo giorno a -4,57%, sotto il 5% di FTMO ma sopra il 4% della sua protezione interna. Sotto la soglia di Massimo (nessun giorno oltre -4% in pessimistica) nei 21 mesi; **non** nel 2013 (un giorno a -4,57%).
- **Il flottante cambia il quadro per gli EA con piu posizioni o griglia**: Vortex e SomaGold hanno giorni oltre il 5% (peggio: -11,9% e -16,7%), sopra il 5% di FTMO.
- **Limiti**: accoppiamento ingressi/uscite stimato per Reaper (fino a 14 posizioni), Vortex, SixtyNine, SomaGold; tester, un solo percorso; il Reaper nel 2013 e a Modello 1.

## Portafoglio sul 2025 (Reaper + Goldbot One + Prop Firm Gold, tutti da 80.000 il 01/01/2025, equita ricostruita sommata)
Calcolo: `leggi_equita_portafoglio_2025.py`. Pesi = frazione del lotto testato (somma = 1 per i misti); l'anno 2025 e l'unico periodo comune ai tre.
| composizione | netto 2025 | DD equity max | peggior giorno | netto / DD |
|---|---|---|---|---|
| Reaper (peso 1) | +27.460 | 3,63% | 2,32% | 9,5 |
| Goldbot (1) | +7.844 | 1,59% | 1,06% | 6,2 |
| Prop Firm Gold (1) | +17.495 | 9,71% | 1,91% | 2,3 |
| Reaper + Goldbot (0,5 ciascuno) | +17.652 | 2,53% | 1,30% | 8,7 |
| Reaper + Prop Firm Gold (0,5 ciascuno) | +22.477 | 4,42% | 1,41% | 6,4 |
| Goldbot + Prop Firm Gold (0,5) | +12.669 | 5,88% | 1,04% | 2,7 |
| i tre (1/3 ciascuno) | +17.599 | 3,49% | 0,97% | 6,3 |
| i tre, pieni (peso 1 ciascuno) | +52.798 | 8,11% | 2,81% | 8,1 |
Correlazione giornaliera 2025: Reaper/Goldbot 0,43; Reaper/Prop Firm Gold 0,06; Goldbot/Prop Firm Gold 0,06 (n = 257).
**Lettura**: nessuna combinazione ha un rapporto netto/DD migliore del solo Reaper (9,5): Reaper + Goldbot a meta lotto da' 8,7 (DD 2,53%, ma l'equivalente di Reaper a peso 0,65 darebbe circa lo stesso netto con circa lo stesso DD); l'aggiunta di Prop Firm Gold peggiora il rapporto perche il suo DD proprio e il 9,7%. Il vantaggio e solo di peggior giorno e DD leggermente piu bassi a pari netto con Goldbot. Un anno solo (2025, rialzo), nessun giudizio su taglie o acquisti.
