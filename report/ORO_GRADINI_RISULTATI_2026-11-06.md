# Trio oro di Wim a quattro livelli di rischio: risultati (06/11/2026)

Criteri e previsioni scritti prima: `CRITERI_ORO_GRADINI_RISCHIO_2026-11-05.md`. Dati e script: `ORO_GRADINI_dati/`. 96 passate su 96 valide: stato OK, deposito confermato dal report, qualità storico 99-100%, **nessuno stop out**, e in tutte gli input stampati dal report coincidono con i valori del set (confronto automatico, 0 differenze su 49/18-20/71 input per Goldbot/Reaper/Phantom). Modello 1 (barre da 1 minuto), XAUUSD, un percorso per anno.

Cella = **netto EUR (% del deposito) / limite superiore del DD equity (somma dei 3 EA, % del deposito) / peggior giorno realizzato del trio (% del deposito)**. Il limite superiore del DD è pessimistico (la curva combinata non si ricostruisce).

## 80.000 EUR (taglia della prova FTMO; limiti FTMO 4.000 al giorno, 8.000 in totale)

| Livello | 2013 | 2018 | 2020 | 2025 |
|---|---|---|---|---|
| L2 Medium | 297,413 (372%) / 81,813 (102%) / -37,956 (-47.4%) | 61,946 (77%) / 51,965 (65%) / -9,962 (-12.5%) | 222,801 (279%) / 46,661 (58%) / -14,175 (-17.7%) | 274,392 (343%) / 44,686 (56%) / -11,320 (-14.1%) |
| L0 Prop | 47,803 (60%) / 12,186 (15%) / -7,053 (-8.8%) | 22,071 (28%) / 11,948 (15%) / -2,186 (-2.7%) | 40,515 (51%) / 7,291 (9%) / -2,171 (-2.7%) | 52,117 (65%) / 6,464 (8%) / -1,541 (-1.9%) |
| L1 Gradino 1 | 93,574 (117%) / 23,647 (30%) / -10,836 (-13.5%) | 32,912 (41%) / 19,709 (25%) / -4,621 (-5.8%) | 71,778 (90%) / 14,365 (18%) / -4,116 (-5.1%) | 93,750 (117%) / 12,497 (16%) / -3,425 (-4.3%) |
| L3 Combo 3GOLD | 24,227 (30%) / 7,156 (9%) / -2,939 (-3.7%) | 10,946 (14%) / 5,775 (7%) / -1,430 (-1.8%) | 21,731 (27%) / 3,550 (4%) / -1,237 (-1.5%) | 23,557 (29%) / 3,718 (5%) / -1,076 (-1.3%) |

| Livello | Esito (regole fissate prima) |
|---|---|
| L2 Medium | **NON REGGE** in tutti e 4 gli anni: peggior giorno −12% … −47%. Giorni oltre −5%: 18 (2013), 12 (2018), 14 (2020), **8 (2025)**; oltre −3%: 32, 20, 25, 22 |
| L1 Gradino 1 | **NON REGGE** nel 2013 (−13,5%), 2018 (−5,8%) e 2020 (−5,1%); 2025 INCERTO (−4,3%, limite superiore DD 15,6%) |
| L0 Prop | **NON REGGE** per il solo 2013 (peggior giorno −8,8%, Reaper −4.713 in un giorno); 2018 INCERTO (limite DD 14,9%); 2020 e 2025 REGGONO |
| L3 Combo 3GOLD | **REGGE** in tutti e 4 gli anni (limite DD massimo 8,9%, peggior giorno −3,7%) |

## 3.745 EUR (taglia del reale, bonus non simulato)

| Livello | 2013 | 2018 | 2020 | 2025 |
|---|---|---|---|---|
| L2 Medium | 13,318 (356%) / 3,508 (94%) / -1,646 (-43.9%) | 2,801 (75%) / 2,221 (59%) / -453 (-12.1%) | 9,165 (245%) / 1,946 (52%) / -612 (-16.3%) | 10,935 (292%) / 1,660 (44%) / -398 (-10.6%) |
| L0 Prop | 1,945 (52%) / 485 (13%) / -250 (-6.7%) | 791 (21%) / 537 (14%) / -115 (-3.1%) | 1,984 (53%) / 343 (9%) / -128 (-3.4%) | 4,750 (127%) / 553 (15%) / -149 (-4.0%) |
| L1 Gradino 1 | 3,843 (103%) / 1,088 (29%) / -456 (-12.2%) | 1,739 (46%) / 749 (20%) / -195 (-5.2%) | 3,261 (87%) / 541 (14%) / -198 (-5.3%) | 5,975 (160%) / 854 (23%) / -289 (-7.7%) |
| L3 Combo 3GOLD | 2,203 (59%) / 528 (14%) / -235 (-6.3%) | 897 (24%) / 429 (11%) / -126 (-3.4%) | 1,904 (51%) / 321 (9%) / -118 (-3.2%) | 3,558 (95%) / 548 (15%) / -190 (-5.1%) |

| Livello | Esito (limite superiore DD: scartato > 50%, grigia 35-50%, accettabile < 35%) |
|---|---|
| L2 Medium | **SCARTATO** nel 2013 (94%), 2018 (59%), 2020 (52%); 2025 ZONA GRIGIA (44%). Peggior giorno −11% … −44% |
| L1 Gradino 1 | ACCETTABILE (14-29%) |
| L0 Prop | ACCETTABILE (9-15%) |
| L3 Combo 3GOLD | ACCETTABILE (9-15%) |

## Previsioni contro risultati
| # | Previsione | Esito |
|---|---|---|
| P1 | 96 passate valide: 60% | **Vero** |
| P2 | L2 a 80k ha un giorno <= −4.000 in almeno un anno: 45% | **Vero**, in tutti e 4 gli anni |
| P3 | L2 a 80k, limite DD > 8.000 in almeno 3 anni: 75% | **Vero** (44.700-81.800, cioè 56-102%) |
| P4 | L0 REGGE in tutti e 4 gli anni: 55% | **Falso** (2013 NON REGGE, 2018 INCERTO) |
| P5 | Netto L2 > L0 in 3 anni su 4: 80% a 80k, 55% a 3.745 | **Vero in 4 su 4 a entrambi i depositi** |
| P6 | A 3.745, in L2 almeno il 70% delle posizioni di Phantom e Goldbot a 0,01: 75% | **Falso**: Phantom 24%, 42%, 48%, 97%; Goldbot 0%, 0%, 0%, 36% (2013, 2018, 2020, 2025) |
| P7 | A 3.745, L2 ha limite DD > 50% in almeno un anno: 25% | **Vero**, in 3 anni su 4 |
| P8 | Nessuno stop out: 80% | **Vero**; ma 'no money' (ordini rifiutati per margine) fino a 246 righe nel solo L2 (80k, 2018) |
| P9 | A 80k, L3 ha netto/limite DD più alto di L2 in 3 anni su 4: 60% | **Vero** (2018, 2020, 2025; non 2013) |
| P10 | Il DD del Reaper a 80k più che raddoppia da L1 a L2 in 3 anni su 4: 70% | **Vero in 4 su 4** (×3,3, ×2,1, ×2,7, ×3,0) |

## Letture
- **Medium non è più efficiente, è più grande**: netto/limite DD a 80k è 3,6 / 1,2 / 4,8 / 6,1 per L2 contro 3,9 / 1,9 / 5,6 / 8,1 per L0 e 3,4 / 1,9 / 6,1 / 6,3 per L3 (2013 / 2018 / 2020 / 2025). Più rendimento perché più rischio, non meglio per unità di rischio. Il Combo 3GOLD ha il rapporto migliore o pari in 3 anni su 4 con un DD di 4-9%.
- **Trial FTMO, set Medium**: in tutta la storia testata il peggior giorno realizzato supera il limite FTMO del 5% (8 giorni su ~250 nel 2025, l'anno col prezzo più vicino a oggi). I set Medium hanno `PropFirmMaxDailyDD` = 0: l'unica protezione sul trial è il Guardian. Per un laboratorio gratuito va bene; per una challenge a pagamento, no. I lotti attuali sul trial (massimi Reaper 0,82, Phantom 0,50, Goldbot 1,10) sono circa il 25-90% dei massimi del test 2025 a 80k (2,13 / 0,56 / 1,93) [DERIVATO, i lotti dipendono dal prezzo]: il rischio di oggi è più basso di quello del test 2025, non nullo.
- **Reale 3.745, set Medium**: nel tester gli anni passati danno lotti ben sopra 0,01 (Goldbot fino a 0,58). Sul reale i pendenti del 05/11 sono 19 su 23 a 0,01. La differenza è il **prezzo**: i set calibrano il lotto sul DD massimo a 0,01 lotti, che a 4.000 dollari è molto più basso che a 1.200-2.000. Quindi il tester 2013-2020 sopravvaluta il lotto di oggi, il 2025 è l'anno più vicino (Goldbot 36% a 0,01, Reaper 29%, Phantom 97%). Con `OnlyUp` il lotto sale e non scende: se il saldo cresce o l'oro scende, i lotti del reale salgono fino alla fascia 'scartata' del test.
- **Combo 3GOLD**: regge FTMO su tutti e 4 gli anni a 80k (DD limite 4-9%) e a 3.745 resta accettabile; netto +27-30% a 80k, +24-95% a 3.745. È il livello che il test indica più vicino a una configurazione prop; **non** a un obiettivo di crescita rapida.
- Le righe 'no money' (L1 Reaper 80k 2013/2018; L2 in 2013-2020) dicono che il Medium arriva al limite di margine nel tester: ordini rifiutati, quindi risultati in parte troncati.

## Limiti
- Un percorso per anno, OHLC a 1 minuto, nessuno slippage, nessun Guardian, nessun flottante (il peggior giorno è realizzato). Il tester usa `AutoGMT_Backtest` con offset 2/3 dei set, non verificato contro il GMT+1 fisso del BCM. Gli input del Reaper non presenti nel set (18-20 su decine) sono quelli del report; non confrontati con la configurazione del reale/trial.
- Somma di tre corse indipendenti: nessuna interazione di margine tra i 3 EA sullo stesso conto (reale: ordini rifiutati più spesso di quanto qui contato).
- Lotti dipendenti dal prezzo: il confronto con i lotti attuali è una stima. Nessun giudizio su taglie, lotti o acquisti.
