# Trial 160K - 1 ottobre, ore 10: lettura dallo storico del telefono (screenshot di Claudio)

Fonte: due screenshot dell'app mobile MT5 (Storico > Affari, alle 09:45 e 09:46 ora italiana). Il conto non e' scritto nelle immagini:
si deduce dall'orologio (ultimo deal 10:43:33 contro telefono 09:45 = server IT+1, cioe' il terminale FTMO) e dai lotti (47,78 lotti = rischio da 160K).
Conto `[NON LETTO DALL'IMMAGINE]`: da confermare col report xlsx della sera (`lettura_trial.py`).

## Cosa e' successo (ora SERVER FTMO)
- 09:59:01 `MAXMIN DAX SHORT SELL` (GER40.cash, magic 770411 sul preset FTMO, `InpRiskPercent=2.00`) entra short 47,78 lotti a 24.998,25.
- 10:06:32 stop a 25.067,16 (SL scritto 25.066,00): **-3.292,52**.
- 10:43:33 NZDCHF (Bulge, 7,23 lotti, long da 0,47041) stop a 0,46865: **-1.357,14**.
- Aperte alle 10:00: GBPNZD short 2,83 lotti (06:00 a 2,35658) e 4,49 lotti (10:00 a 2,35994). Profitto aperto mostrato dal telefono: +334,59 alle 09:45, +207,41 alle 09:46 (se il numero in barra e' il flottante: `[NON VERIFICATO]`).

## Conti (calibrati sui P/L veri)
- DAX: 68,91 punti x 47,78 lotti = 3.292,52 -> **1 EUR a punto per lotto** (conto quadra). Stop teorico 67,75 punti = 3.237 EUR; **slippage di fill 1,16 punti = ~55 EUR (0,03% di 160K)**: primo dato di slippage reale del trial.
- Rischio DAX: 3.292,52 / 160.000 = 2,06% (design 2,00% + slippage). **Non e' un'anomalia di lotto: e' il rischio scelto nel preset.**
- Perdita chiusa del giorno: 4.649,66 = **2,91%** dell'iniziale.
  - al pausa Guardian 3,5% (5.600): restano ~950
  - all'emergenza Guardian 4,5% (7.200): restano ~2.550
  - al 5% presunto FTMO (8.000, regola trial NON misurata): restano ~3.350
- Se le due GBPNZD aperte prendessero lo stop pieno (~1% ciascuna dal preset, 3.200 stimati, NON misurati sui lotti): -7.850 = oltre l'emergenza 4,5% e a ~150 EUR dal 5% presunto. **E' lo scenario che fa lavorare il Guardian**; se interviene si legge nel Giornale/Esperti (righe pausa/emergenza).

## Allarmi dei criteri (`TRIAL_14_GIORNI_CRITERI_2026-10-01.md` par. 4)
- stop pieni oggi: 2 (DAX, NZDCHF). **Al terzo scatta la soglia "3 stop nello stesso giorno".**
- equity <= 148.000: non raggiunta (perdita chiusa 4.650 + flottante).
- Lotto/stop anomali: nessuno visto (47,78 lotti coerente col 2,00%).

## Lettura (e cosa NON dice)
- Un unico stop non giudica il motore: i criteri dei 14 giorni valutano meccanica e frequenza, non il merito. Il fatto che il prezzo sia poi sceso a 24.853 e' un controfattuale: il motore ha stop stretto contro target largo, e questi episodi stanno nella sua forma (vincite rare grosse / stop frequenti).
- Resta da misurare a fine giornata: i due stop di oggi rientrano nel rischio promesso (DD forward contro DD del backtest)? Serve il report xlsx completo.
