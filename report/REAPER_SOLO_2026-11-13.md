# Solo Gold Reaper: tempi della sfida per livello (13/11/2026)

> **CORREZIONE del 13/11 sera**: i fallimenti del Reaper L0 da solo erano sottostimati (partenze solo gennaio-marzo). Con partenze in tutto l'anno (4 anni, costi centrali / doppi): **Reaper L0 17,3% / 23,3% (74% delle partenze del 2013: giornate di -6% il 15/08, 22/10 e 18/12/2013)**; L1 28% / 43%; Medium 64% / 72%; L3 0% / 0%. Il tester NON simula il Guardian: con il Guardian a 4,3% i tagli intraday potrebbero evitare parte di questi fallimenti.


**Natura: SIMULAZIONE sul tester** (BCM, Modello 1, 80.000 EUR, anni 2013/2018/2020/2025, un percorso per anno; il Reaper ha Randomization 50 = rumore). Stesso metodo di `TEMPI_SFIDA_CON_COSTI_2026-11-13.md` ma SOLO il Reaper (senza Daytrade Pro): equity con flottante ricostruito dalle barre M1, partenze gennaio-marzo, fallisce a -5% giorno o -10% totale, passa a +10% (fase 1) o +5% (fase 2). Costi centrali = 36 EUR/lotto, mia ipotesi. Script `ORO_GRADINI_dati/reaper_solo.py`.
| Livello (set) | Netto/anno (senza / con costi) | Fase 1 +10%: giorni di calendario mediana, passa, fallisce | Fase 2 +5% mediana |
|---|---|---|---|
| **L0 Prop** (`Gold_reaper_propfirm.set`) | 24.579 / 17.489 | 107 (25-75%: 60-160), 100% / 0% senza costi; con costi 86, 74% passa e 26% ancora aperto a fine finestra, 0% | 55 / 65 |
| L1 15% maxrisk (`gold_reaper_15%maxrisk.set`) | 37.154 / 25.490 | 90 / 63; passa 72% / 47%, **fallisce 28% / 47%** | 40 / 33 |
| L2 Medium (`gold_reaper_default.set`) | 93.025 / 64.805 | 18 / 18; passa 37% / 30%, **fallisce 63% / 70%** | 17 / 14 |
| L3 Combo 3GOLD (`Gold_reaper_propfirm_combo_3GOLD.set`) | 6.188 / 4.138 | 300 / 327; passa 22% / 11% (il resto non finisce in 9-12 mesi) | 177 / 226 |
**Giorni >= 4,5% (equity, 4 anni)**: L0 4 (tutti nel 2013, peggior giorno -6,0%), L1 10 (peggior -10,9%), L2 70 (-37,1%), L3 0 (-2,1%) — da `SOGLIE_4_5_E_9_5_ALTRI_SETTAGGI_2026-11-12.md`.
**Lettura**: il solo Reaper a settaggi Prop (L0) fa fase 1 + fase 2 in circa 5-6 mesi senza costi FTMO, 6-7 mesi con i costi (i tempi con costi sono sottostimati perche il 26% delle partenze non finisce entro la finestra); il Combo 3GOLD solo non basta (e pensato per stare in un portafoglio). L1 e Medium sono veloci ma falliscono 28-70% delle volte.
**Limiti**: un percorso per anno con rumore del Reaper, nessun flottante oltre le barre M1, costi FTMO ipotizzati, nessun giudizio su acquisti o taglie.
