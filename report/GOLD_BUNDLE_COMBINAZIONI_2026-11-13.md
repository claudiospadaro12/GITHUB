# Gold Bundle: le migliori combinazioni con i costi FTMO (13/11/2026)

**Natura: SIMULAZIONE sul tester** (BCM, Modello 1, 80.000 EUR, anni 2013/2018/2020/2025, un percorso per anno). Le 249 combinazioni possibili di Goldbot One, Gold Phantom, Gold Reaper (ognuno spento o a L0 Prop / L1 / L2 Medium / L3 Combo) piu Gold Trade Pro Combo (acceso o spento). SENZA Daytrade Pro. Metodo come `TEMPI_SFIDA_CON_COSTI_2026-11-13.md`: equity con flottante ricostruito dalle barre M1, partenze gennaio-marzo, fallisce a -5% giorno o -10% totale, passa a +10% (fase 1) o +5% (fase 2); costi FTMO centrali 36 EUR/lotto (mia ipotesi) e prudenti il doppio; tempi in giorni di calendario. Script `ORO_GRADINI_dati/bundle_search.py`. Nessun giudizio su taglie o acquisti.
**Criteri di scelta (fissati nel momento della richiesta)**: fallimenti 0-3% in entrambe le fasi con costi centrali e prudenti, passaggio >= 90%, poi il tempo totale (mediana fase 1 + mediana fase 2) piu corto.

## Le due scelte
| | Combinazione | Set | Tempo tipico (fase 1 + fase 2) | Fallimenti | Netto/anno (80k, costi centrali) |
|---|---|---|---|---|---|
| **A, la piu sicura** | Goldbot L1 + Phantom L0 | `Goldbot_PropFirm_10_5.set` + `GoldPhantom_Propfirm_combo.set` | **~187 giorni** (117 + 70; lento 25%: 172 + ...) | **0%** (anche costi doppi), passa 96,9% | 22.737 |
| **B, la piu veloce con rischio basso** | Goldbot L1 + Phantom L1 | `Goldbot_PropFirm_10_5.set` + `GoldPhantom_Propfirm.set` | **~147 giorni** (104 + 43) | **2,7%** (3,1% con costi doppi), passa 97,3% | 27.624 |

## Altre combinazioni con fallimento 0% e passaggio >= 95%
GB L0 + PH L3 + GTP Combo (201 giorni, 100% passa); GB L0 + PH L0 + GTP Combo (206); GB L3 + PH L3 + GTP Combo (212); GB L3 + PH L0 + GTP Combo (219). Il Reaper non compare in nessuna combinazione con fallimento 0%; le migliori con il Reaper hanno fallimenti 3-10% (es. Goldbot L0 + Phantom L1 + Reaper L3: 163 giorni, 4,8-9,9%).

## Limiti
Un percorso per anno (Phantom e Reaper con rumore); fallimenti sottostimati senza spread e slippage FTMO; costi ipotizzati; senza Daytrade Pro; giorni di equity >= 4,5% presenti in A (4) e B (5) nei 4 anni (nel 2013 soprattutto); il Guardian a 4,3% serve.
