# Simulazione 3 conti BCM da 2.000 EUR con 3 combinazioni (18/11/2026)
**Natura:** scenari ricavati da risultati GIA misurati nel tester (nessun test nuovo; script `backtest_runner/simulatore/combo_conti_2k.py`). **Non e un consiglio su lotti, taglie o quali EA usare**: sono numeri di scenario; decide Claudio. Fonti: `RISULTATI_FOREX_4K_2026-11-05.md` (forex a 4.000 EUR, 5 anni: 2013/17/20/22/25) e `ORO_REALE21_RISULTATI_2026-11-07.md` (trio oro a 3.745 EUR, 21 mesi 2025-26). Combinazioni solo con set "CANDIDATO" o "ZONA GRIGIA" (nessuno SCARTATO).

## Come leggere i due scenari (il conto e da 2.000, non da 4.000)
- **Scenario A (lotti proporzionali):** ogni EA riceve 2.000/N del suo conto-prova da 4.000; guadagno = media dei % degli EA. **Irrealizzabile in pratica:** il lotto minimo e 0,01 e a quel capitale i lotti non scendono cosi.
- **Scenario B (lotto minimo fisso):** l'euro guadagnato e uguale alla somma dei test da 4k. E il **tetto**: vale solo se gli EA stanno gia al lotto minimo (non per i set ad alto rischio) e se il conto sopravvive: ogni anno con "DD somma" sopra 2.000 EUR il conto sarebbe stato fermato (stop out) prima. **Il vero risultato sta tra A e B, piu vicino a B per i set prudenti (a 4k gia al lotto minimo), piu vicino ad A per i set ad alto rischio.**
- **DD somma** = somma dei drawdown in euro dei singoli EA (prudente: non tutti insieme nello stesso giorno).

### Combinazione A prudente: STAB_low + DTP_9 + LUNA_4DD
| Anno | Netto somma (EUR, 4k a EA) | Scenario A: lotti proporzionali (EUR su 2k) | Scenario B: lotto minimo fisso (EUR su 2k) | DD somma (EUR) | DD somma vs 2.000 |
|---|---|---|---|---|---|
| 2013 | +1671 | +278 (+14%) | +1671 (+84%) | 1929 | 96% |
| 2017 | +1350 | +225 (+11%) | +1350 (+67%) | 1159 | 58% |
| 2020 | +2916 | +486 (+24%) | +2916 (+146%) | 677 | 34% |
| 2022 | +2995 | +499 (+25%) | +2995 (+150%) | 663 | 33% |
| 2025 | +1822 | +304 (+15%) | +1822 (+91%) | 1105 | 55% |
| **Media/anno** | | **+358** | **+2151** | | |

### Combinazione B medio: STAB_low + DTP_20 + LUNA_4DD + APEX_cons
| Anno | Netto somma (EUR, 4k a EA) | Scenario A: lotti proporzionali (EUR su 2k) | Scenario B: lotto minimo fisso (EUR su 2k) | DD somma (EUR) | DD somma vs 2.000 |
|---|---|---|---|---|---|
| 2013 | +2382 | +298 (+15%) | +2382 (+119%) | 3356 | 168% |
| 2017 | +2778 | +347 (+17%) | +2778 (+139%) | 2392 | 120% |
| 2020 | +5922 | +740 (+37%) | +5922 (+296%) | 1489 | 74% |
| 2022 | +5328 | +666 (+33%) | +5328 (+266%) | 1239 | 62% |
| 2025 | +2737 | +342 (+17%) | +2737 (+137%) | 2191 | 110% |
| **Media/anno** | | **+479** | **+3829** | | |

### Combinazione C alto: STAB_mlow + DTP_50 + LUNA_low + APEX_elev
| Anno | Netto somma (EUR, 4k a EA) | Scenario A: lotti proporzionali (EUR su 2k) | Scenario B: lotto minimo fisso (EUR su 2k) | DD somma (EUR) | DD somma vs 2.000 |
|---|---|---|---|---|---|
| 2013 | +7190 | +899 (+45%) | +7190 (+359%) | 7642 | 382% |
| 2017 | +7496 | +937 (+47%) | +7496 (+375%) | 5693 | 285% |
| 2020 | +15555 | +1944 (+97%) | +15555 (+778%) | 4051 | 203% |
| 2022 | +14136 | +1767 (+88%) | +14136 (+707%) | 3372 | 169% |
| 2025 | +6553 | +819 (+41%) | +6553 (+328%) | 4546 | 227% |
| **Media/anno** | | **+1273** | **+10186** | | |

### Gamba oro (trio Reaper+Phantom+Goldbot di Wim, conto da 3.745, 01/2025-10/2026 = 21 mesi)
| Livello | Modello | Netto 21 mesi (EUR) | Netto/12 mesi semplice (EUR) | DD limite superiore (EUR, somma dei 3 EA) | DD vs 2.000 |
|---|---|---|---|---|---|
| L3 | barre 1 min | +6825 | +3900 | 1160 | 58% |
| L3 | tick reali | +6078 | +3473 | 1202 | 60% |
| L0 | barre 1 min | +8552 | +4887 | 1058 | 53% |
| L1 | barre 1 min | +13659 | +7805 | 1576 | 79% |
| L1 | tick reali | +12085 | +6906 | 1589 | 79% |
| L2 | barre 1 min | +30163 | +17236 | 3293 | 165% |
| L2 | tick reali | +23889 | +13651 | 3203 | 160% |

## Risultato in due righe
- **A prudente:** circa **+360 (A) fino a +2.150 (B) EUR l'anno**; il DD somma sta sotto i 2.000 in tutti e 5 gli anni (picco 96% nel 2013): **sopravvive in tutti gli anni nello scenario B**.
- **B medio:** +480 (A) fino a +3.830 (B); DD somma sopra 2.000 in 2013, 2017 e 2025: **tre anni su cinque il conto da 2.000 sarebbe fermato** prima di incassare lo scenario B.
- **C alto:** +1.270 (A) fino a +10.190 (B); DD somma sempre sopra 2.000 (170%-380%): **in ogni anno testato il conto sarebbe saltato** prima: i numeri B non sono raggiungibili con 2.000.
- **Tre conti insieme:** scenario A circa +2.100 EUR l'anno (somma 360+480+1.270); scenario B 16.000 non realistico (C e B saltano).

## Limiti (da non dimenticare)
Un percorso storico per anno; test a barre da 1 minuto (tick reali: Luna -83% nel 2025); slippage, flottante di gruppo, margine condiviso e Guardian non simulati; forex 2013-2025 e oro 2025-26 **non sono lo stesso periodo** (non c'e un anno comune a 2k per l'oro, quindi la gamba oro e a parte, non sommata); oro in forte rialzo nel periodo (i set di Wim possono essere ottimizzati li); i netti del trio sono composti (lotti che salgono col saldo), l'annualizzazione semplice e solo indicativa; nel 2025 Daytrade Pro rende quasi zero; peggior giorno singolo Apex -25% del conto da 4k (= -1.000 EUR in un giorno); tutti EA di Wim (rischio fornitore); passato non garantisce futuro.
