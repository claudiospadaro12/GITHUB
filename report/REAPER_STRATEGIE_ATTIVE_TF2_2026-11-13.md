# Reaper: quali strategie girano con TradeFrequency 2 (13/11/2026)

**Domanda**: i set Reaper Prop (L0) e Combo (L3) hanno TradeFrequency=2. Il manuale V5.1 elenca 6 opzioni (extreme conservative, conservative, moderate, intense, extreme, auto). Wim ha scritto il 06/11 (canale automated-support, intestazione verificata) che il suo conto usa "default settings, but trade frequency set to moderate". Quali strategie (1-9) aprono ordini con TradeFrequency=2?

**Criterio fissato prima**: se con TF=2 compaiono ordini delle strategie 8 o 9 nei report del tester, la mia lettura "TF 2 = moderate = strategie 1-7" e sbagliata. Se compaiono solo 1-7, e confermata per questi set e per i periodi testati.

**Metodo**: nessuna nuova run. Ho contato nei report gia esistenti il suffisso del commento ordine (`The Gold Reaper_XAUUSD_N`, N = strategia) sugli ordini eseguiti. Script: `/tmp/claude-0/cnt2.py` (non nel repo, 40 righe: conta le righe con commento Gold Reaper e legge lo stato dalla riga precedente).

| Report (tester BCM, real ticks o M1) | Set | Ordini eseguiti per strategia |
|---|---|---|
| 2013, L3 `Gold_reaper_propfirm_combo_3GOLD.set` (D160_R1_L3_GR_2013) | TF 2, MaxAllowedDD 3 | 1: 53, 2: 24, 3: 34, 4: 56, 5: 156, 6: 189, 7: 139 |
| 2025, L3 (stessa famiglia, report 2025) | TF 2 | 1: 46, 2: 21, 3: 34, 4: 55, 5: 149, 6: 186, 7: 116 |
| 2025-01 / 2026-10, real ticks 100%, `GRSET80K_TRANCHE1` | TF 2, MaxAllowedDD 9 (L0) | 1: 48, 2: 32, 3: 50, 4: 101, 5: 186, 6: 200, 7: 174 |
| 2013, M1, `GR_DD9` (MaxAllowedDD 9) | TF 2 | 1: 35, 2: 25, 3: 33, 4: 54, 5: 116, 6: 123, 7: 123 |

**Risultato**: in tutti i report compaiono SOLO le strategie 1-7; mai 8 o 9. La lettura "TradeFrequency 2 = moderate = strategie 1-7" e confermata per questi set (il numero delle opzioni e 0-based: il bot dice default TF 5 = Auto, con 6 opzioni).

**Conseguenze**
- La segnalazione Discord del 13/11 (5 posizioni con la strategia 8 del Reaper) non riguarda i nostri set Reaper L0/L3. Non e comunque dimostrato che l'utente usasse il Reaper: i file Discord lo attribuiscono a UBS in un punto e al Reaper in un altro.
- Il nostro Reaper gira allo stesso livello di strategie del conto di Wim (moderate), con MaxAllowedDD 9 (L0) o 3 (L3) invece del default 30.
- Il manuale classifica 1-3 basso rischio, 4-7 medio, 8-9 alto: i nostri set escludono quelle ad alto rischio.
- Le strategie 5, 6, 7 sono quelle con piu ordini eseguiti (circa 65-75% del totale).

**Limiti**: report di tester, non conto reale. Il 2020 non aveva il report nell'archivio D160 (cartella senza file). Il conteggio e di ordini, non di profitti per strategia. La mappatura numero-opzione si basa sul bot (non Wim) e sul manuale; il test sui report conferma solo che 8 e 9 non compaiono.
