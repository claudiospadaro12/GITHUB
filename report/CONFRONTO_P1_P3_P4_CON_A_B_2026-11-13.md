# Confronto in giorni: P1, P3, P4 (settaggi Prop) contro le due combinazioni A e B del Gold Bundle (13/11/2026)

**Natura: SIMULAZIONE sul tester** (BCM, Modello 1, 80.000 EUR, partenze gennaio-marzo, equity con flottante ricostruito dalle barre M1, costi FTMO centrali 36 EUR/lotto oro e 4 forex = mia ipotesi; giorni di calendario, mediane; fallisce a -5% giorno o -10% totale). A = Goldbot L1 + Phantom L0; B = Goldbot L1 + Phantom L1 (`GOLD_BUNDLE_COMBINAZIONI_2026-11-13.md`). P1 = Phantom Gradino 1 + Goldbot Prop + Daytrade Pro; P3 = Goldbot Combo + Gold Trade Pro Combo + Daytrade Pro; P4 = Reaper Combo + Goldbot Prop + Daytrade Pro. Il Daytrade Pro non ha dati per il 2018 e il suo flottante non si ricostruisce: i confronti sono fatti in due modi.

## 1. Stessi anni (2013, 2020, 2025), P con Daytrade Pro
| Combinazione | Fase 1 (+10%) | Fase 2 (+5%) | **Totale** | Fallimenti | Netto/anno |
|---|---|---|---|---|---|
| P1 settaggi Prop | 76 | 36 | **112** | 0% | 30.582 |
| P1 con rialzo a L1 dopo 2 giorni | 54 | 33 | **87** | 0% | - |
| P3 settaggi Prop | 105 | 45 | **150** | 0% | 25.685 |
| P3 con rialzo a L1 | 86 | 34 | **120** | 0% | - |
| P4 settaggi Prop | 103 | 42 | **145** | 0% | 24.788 |
| **A** (Goldbot L1 + Phantom L0) | 95 | 47 | **142** | 0% | 29.030 |
| **B** (Goldbot L1 + Phantom L1) | 83 | 36 | **119** | 0% | 35.234 |
Con costi doppi: A 166 giorni, B 128.

## 2. Solo oro, 4 anni (2013, 2018, 2020, 2025), senza Daytrade Pro
| Combinazione (parte oro) | Fase 1 | Fase 2 | **Totale** | Fallimenti | Partenze che arrivano al target |
|---|---|---|---|---|---|
| P1 oro (Phantom L1 + Goldbot Prop) | 112 | 86 | **198** | 0% | 85% |
| P3 oro (Goldbot Combo + GTP Combo) | 181 | 98 | **279** | 0% | 90% |
| P4 oro (Goldbot Prop + Reaper Combo) | 162 | 109 | **271** | 0% | 74% |
| **A** | 117 | 70 | **187** | 0% | 97% |
| **B** | 104 | 43 | **147** | 2,7% | 97% |

## Differenze in giorni (centrali)
| | A | B |
|---|---|---|
| contro P1, stessi anni, con Daytrade Pro | +30 | +7 |
| contro P3 | -8 | -31 |
| contro P4 | -3 | -26 |
| contro P1 solo oro, 4 anni | -11 | -51 |
| contro P3 solo oro | -92 | -132 |
| contro P4 solo oro | -84 | -124 |

## Letture
1. Il 2018 e un anno lento: con i 3 anni di P gli stessi A e B fanno 142 e 119 giorni, con i 4 anni 187 e 147 (il 2,7% di fallimenti di B sta nel 2018).
2. Il Daytrade Pro accorcia i tempi di P1, P3, P4. Solo sull'oro A e B battono tutti e tre i P; con il Daytrade Pro, P1 resta la piu veloce dei settaggi Prop (112) e B la pareggia (119).
3. P3 e P4 sono i piu lenti sia con sia senza Daytrade Pro. P1 con rialzo a L1 (87) e la piu veloce in assoluto in questa tabella, ma il Daytrade Pro non ha flottante: i fallimenti sono sottostimati.

## Limiti
Costi ipotizzati; un percorso per anno; il Daytrade Pro realizzato e solo su 3 anni; spread e slippage FTMO non simulati; nessun giudizio su taglie o acquisti.
