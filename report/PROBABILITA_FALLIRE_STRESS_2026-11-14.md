# Probabilita di fallire le challenge con i set Prop: tester base e prova di stress (14/11/2026)

**Natura**: SIMULAZIONE sui dati del tester (stesso motore di `bundle_search2.py`: equity con flottante dalle barre M1, anni 2013/2018/2020/2025, partenza da OGNI giorno dell'anno, fase 1 con target +10%, fallimento a -5% in un giorno o -10% totale, costi FTMO centrali 36 EUR/lotto oro e prudenti il doppio = MIA ipotesi). Solo la **parte oro** (Daytrade Pro escluso: senza flottante). **Guardian NON simulato.** Spread e slippage FTMO non misurati. Script e dati: `ORO_GRADINI_dati/stress_fail.py` e `stress_fail.json`.

**Prova di stress (nuova)**: il confronto M1 contro tick reali (`CONFRONTO_M1_TICK_REALI_CRITERI_2026-11-14.md`) ha mostrato che a tick reali il drawdown e piu alto (da +2% a +35%) e il netto piu basso (-8% / -17%). Ho riesaminato i fallimenti scalando le perdite per 1,15 o 1,35 e i profitti per 0,92 o 0,85. NON e una misura dei tick: e un'approssimazione per capire quanto margine c'e.

| Portafoglio oro | Costi | Base (M1) | DD x1,15, profitti x0,92 | DD x1,35, profitti x0,85 |
|---|---|---|---|---|
| **P1** (Goldbot L0 + Phantom L1) | centrali | 0% | **10,8%** | **27,8%** |
| P1 | prudenti | 0% | 23,0% | 41,9% |
| **P4** (Goldbot L0 + Reaper L3) | centrali | 0% | **0%** | **22,9%** |
| P4 | prudenti | 0% | 2,3% | 40,0% |
| P3 (Goldbot L3 + GTP Combo) | centrali | 0% | 0% | 11,7% |
Peggior giorno equity (in % del deposito): P1 -4,69% base / -5,39% (x1,15) / -6,33% (x1,35); P4 -3,92% / -4,51% / -5,30%.

**Lettura**: i fallimenti degli scenari di stress sono quasi tutti partenze del **2013** (e un po' del 2018): poche giornate di coda (17/07/2013, 31/12/2013, 09/11/2020) concentrano il rischio. Il 2020 e il 2025 restano a 0% anche sotto stress, salvo i casi estremi. P4 ha piu margine di P1 (peggior giorno -3,92% contro -4,69%). Il Guardian a 4,3-4,5% taglierebbe giornate come queste (non simulato; vale solo se chiude in tempo e senza grande scivolamento).

## Probabilita complessiva: cosa so e cosa e giudizio
- **Misurato**: base 0% per P1, P3 e P4 a Prop con costi centrali e prudenti, tutte le partenze; il campione e di 4 anni (circa 8 finestre semestrali indipendenti): con zero fallimenti su 8 finestre il limite superiore al 95% e circa 35%. **Lo 0% non e una probabilita vera.**
- **Prova di stress**: se il tick reale si comporta come il caso medio osservato (DD circa +7%) il fallimento di P1 e P4 resta basso; se come il caso peggiore (+35%), diventa 23-28% per P1/P4 (senza Guardian).
- **Non misurato**: spread e slippage FTMO, stop out, Guardian, Daytrade Pro (aggiunge costi e flottante), Phantom dal vivo (PF 1,07 nel segnale di Wim contro 2,9 nel tester), regole 7.5 FTMO, interruzioni di VPS/licenza con posizioni aperte, gap del weekend.
- **Giudizio mio, NON calcolato**: per una singola challenge, la probabilita di perderla per i limiti di perdita nei prossimi mesi: P1 circa 5-15%, P4 circa 2-10%; l'insieme delle due sullo stesso oro e fortemente correlato, quindi la probabilita che almeno una fallisca e poco piu alta di quella della piu rischiosa (circa 8-20%), e quella che falliscano entrambe circa 3-8%. Non e una garanzia.
- **Tempo**: dal tester P1 circa 137 giorni, P4 circa 173 (mediane per le due fasi); entro 7 mesi P1 89%, P4 77%, entrambe 75% (entro 9 mesi 95%). Con netto -8/-17% a tick i tempi si allungano del 10-20% circa (non misurato).
