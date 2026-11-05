# Risultati dei test sul conto prop 80.000 EUR — pacchetto Wim (6 EA, 28 set, 88 passate) — 05/11/2026
Fonte: 25 zip `WIM_01..25` caricati da Claudio (cartella `ANNO80K_WIM_PACCHETTO_20261104_2139`), 88 manifest e 88 report del tester letti con `analisi/parse_wim.py`. Criteri e previsioni scritti prima: `CRITERI_TEST_80K_2026-11-04.md`. Nessun risultato è stato modificato; i numeri sono del tester (Modello 1, barre da 1 minuto, deposito 80.000 EUR, leva 1:100, solo tester).
**Cosa non è stato misurato** (vedi sezione limiti): perdita giornaliera con le posizioni aperte (flottante), simulazione del Guardian, etichette long/short/laterale degli anni, ORB Master/Indicement su più di un periodo.

## 1. Esito generale
- **88 passate su 88 OK**: nessun KO, nessuna passata a zero operazioni, nessun EA saltato. **Gli `.ex5` di Wim girano nel tester**: la licenza non blocca. I set sono stati applicati (set diversi → risultati diversi; Daytrade Pro `lowrisk` e `Prop` danno gli stessi numeri perché hanno gli stessi valori, l'unica differenza è un tetto giornaliero al 4% mai raggiunto).
- Anni forex: 2025, 2022, 2020, 2017, 2013. Indici (Indicement, ORB Master): 2025-01 → 2026-09, un solo periodo.
- **Avvertenza sui lotti**: i set usano un lotto per saldo (`LotsizeStep`, `LotPerBalance_step`, rischio per strategia) pensato per conti piccoli. Su 80.000 EUR danno **lotti grandi** (es. Luna `recommended`, 1 lotto 0,01 ogni 100 USD = circa 8 lotti): i profitti enormi (fino a +1.072.063 EUR in un anno) sono un effetto di lotti che crescono con il saldo (`OnlyUp`), non un risultato da prendere come atteso. Il DD in euro scala con i lotti: i numeri qui sotto vanno letti come «a quel lotto», non come rischio consigliato. Taglie e rischio le decide Claudio.

## 2. Tabella per set (tutti gli anni testati)
| EA | set | anni | netto min / mediano / max (EUR) | PF mediano | DD equity relativa max | DD equity assoluta max (EUR) | peggior giorno realizzato | giorni ≤ −4,3% |
|---|---|---|---|---|---|---|---|---|
| Apex | ApexConservativeGrid | 5 | 4 019 / 27 611 / 59 652 | 1.96 | 37.1% | 24 703 | -29.9% | 5 |
| Apex | ApexElevatedGrid | 5 | -764 / 30 131 / 80 236 | 2.44 | 48.5% | 30 828 | -33.6% | 5 |
| Apex | ApexUltraConservativeGrid | 5 | 492 / 23 146 / 41 606 | 1.61 | 32.6% | 22 695 | -24.7% | 4 |
| Apex | Apexextremerisk | 5 | -59 709 / -27 324 / 1 072 063 | 0.89 | 88.7% | 62 887 | -88.5% | 9 |
| Apex | Apexhighriskliveaccount | 5 | -47 448 / -29 585 / 38 677 | 0.85 | 89.5% | 70 877 | -81.9% | 12 |
| Daytrade Pro | DaytradeProMax20DDmediumrisk | 5 | 1 227 / 27 278 / 41 479 | 1.80 | 12.7% | 7 168 | -9.8% | 15 |
| Daytrade Pro | DaytradeProMax50DDhighrisk | 5 | 589 / 81 046 / 137 655 | 1.78 | 29.5% | 18 104 | -20.4% | 48 |
| Daytrade Pro | DaytradeProMax9DDlowrisk | 5 | 702 / 11 575 / 16 865 | 1.82 | 5.8% | 3 088 | -4.8% | 1 |
| Daytrade Pro | daytradeProProp | 5 | 672 / 11 575 / 16 865 | 1.82 | 5.8% | 3 088 | -4.8% | 1 |
| Indicement | IndicementPropfirmset | 1 | -313 / -313 / -313 | 0.97 | 1.4% | 342 | -0.4% | 0 |
| Indicement | Indicementextreme | 1 | 1 081 / 1 081 / 1 081 | 1.02 | 7.5% | 168 | -2.4% | 0 |
| Indicement | Indicementextremelowrisk | 1 | 216 / 216 / 216 | 1.04 | 0.8% | 31 | -0.3% | 0 |
| Indicement | Indicementhighrisk | 1 | 280 / 280 / 280 | 1.01 | 3.8% | 85 | -1.2% | 0 |
| Indicement | Indicementlowrisk | 1 | -491 / -491 / -491 | 0.95 | 1.8% | 514 | -0.4% | 0 |
| Indicement | Indicementmediumrisk | 1 | -348 / -348 / -348 | 0.98 | 2.7% | 380 | -0.7% | 0 |
| Luna | Luna4DD | 5 | -18 313 / 16 695 / 25 309 | 1.64 | 25.3% | 19 708 | -3.0% | 0 |
| Luna | LunaAIrecommended | 5 | -70 815 / 183 379 / 457 371 | 1.62 | 90.8% | 72 177 | -21.5% | 80 |
| Luna | LunaAIrecommendedlowrisk | 5 | -37 392 / 43 629 / 71 946 | 1.65 | 50.5% | 39 614 | -7.1% | 17 |
| ORB Master | OrbMastercombosetup | 1 | -281 / -281 / -281 | 0.96 | 2.0% | 512 | -0.2% | 0 |
| ORB Master | OrbMasterhighrisk | 1 | -1 578 / -1 578 / -1 578 | 0.97 | 11.2% | 3 346 | -1.0% | 0 |
| ORB Master | OrbMasterlowrisk | 1 | -392 / -392 / -392 | 0.97 | 3.5% | 916 | -0.3% | 0 |
| ORB Master | OrbMastermediumrisk | 1 | -824 / -824 / -824 | 0.97 | 7.3% | 1 931 | -0.6% | 0 |
| ORB Master | OrbMasterpropfirmComboset | 1 | -313 / -313 / -313 | 0.93 | 1.3% | 501 | -0.1% | 0 |
| ORB Master | OrbMasterpropfirmset | 1 | -416 / -416 / -416 | 0.93 | 1.6% | 614 | -0.1% | 0 |
| ORB Master | OrbMasterveryhighrisk | 1 | -2 356 / -2 356 / -2 356 | 0.96 | 15.3% | 4 811 | -1.3% | 0 |
| Stability Pro | stabilityprohighriskset | 5 | -65 744 / 163 235 / 285 356 | 1.51 | 96.1% | 76 520 | -73.3% | 5 |
| Stability Pro | stabilityprolowriskset | 5 | -6 356 / 23 041 / 52 392 | 1.92 | 35.0% | 25 741 | -24.8% | 1 |
| Stability Pro | stabilitypromediumlowriskset | 5 | -10 585 / 54 476 / 152 973 | 1.98 | 67.0% | 44 292 | -49.6% | 2 |

DD equity relativa = dal massimo al minimo dell'equity nell'anno (come il report); **DD equity assoluta = deposito 80.000 − equity minima**: è quella che conta per un limite di perdita massima del 10% dal capitale iniziale (8.000 EUR). Peggior giorno = variazione del saldo realizzato in un giorno (non include il flottante).

## 3. Lettura con le soglie scritte prima
Soglie (CRITERI): **da scartare** se in un anno la DD equity relativa supera il 20% o c'è stop out; **filtro prop** = DD assoluta ≤ 7.440 EUR (9,3%) e peggior giorno ≥ −4,3% (e −5% come limite FTMO); **sotto osservazione** se passa il filtro in 4 anni su 5.

| EA / set | Esito | Motivo (numeri) |
|---|---|---|
| **Daytrade Pro `lowrisk` e `Prop`** | **sotto osservazione, il migliore** | DD relativa max 5,8%, DD assoluta max 3.088; 5 anni su 5 positivi (+702 nel 2025, +9.197…+16.865 negli altri); peggior giorno −4,8% nel 2013 (sotto il −5% FTMO, oltre il −4,3% del Guardian: 1 giorno) |
| Daytrade Pro `mediumrisk` | scartato per prop | DD relativa max 12,7% (ok), ma peggior giorno −9,8% e 15 giorni ≤ −4,3%: sfonda il limite giornaliero |
| Daytrade Pro `highrisk` | scartato | DD relativa max 29,5%, peggior giorno −20,4%, 48 giorni ≤ −4,3% |
| Luna `4%DD` | scartato dal criterio, ma da guardare | DD relativa 25,3% nel 2013 (−18.313 EUR, PF 0,61); 2017–2025 positivi con DD max 8%, peggior giorno −3%. Passa il filtro prop in 4 anni su 5 |
| Luna `recommended`, `lowrisk` | scartati | `recommended`: DD 90,8% nel 2013, 80 giorni ≤ −4,3%; `lowrisk`: DD 50,5% nel 2013 |
| Stability Pro (3 set) | scartati | nel 2017 e nel 2025 perdite da griglia: DD assoluta 25.741–76.520 EUR, peggior giorno −25%…−73%; `lowrisk` 3 anni su 5 passano il filtro |
| Apex `Ultra`, `Conservative`, `Elevated` | scartati per prop | positivi in 5 anni su 5 (tranne `Elevated` 2013, −764), ma nel 2013 e nel 2017 un solo giorno realizza −21…−34% del conto (chiusura della griglia in perdita) |
| Apex `extreme risk`, `highrisk live account` | scartati | stop out in 3/5 e 5/5 anni, DD fino a 89%, PF 0,30–0,89 |
| Indicement (6 set) | **assenza di prova** | 21 mesi: da −491 a +1.081 EUR, PF 0,95–1,04; nessun vantaggio, DD ≤ 7,5% |
| ORB Master (7 set) | **assenza di prova, sfavorevole** | 21 mesi: **7 set su 7 in perdita** (da −2.356 a −281 EUR), PF 0,93–0,97, DD ≤ 15% |

## 4. Previsioni di C0 contro i risultati
1. «Almeno un set Apex/Stability supera il 20% di DD in un anno», prob. 70% → **vero** (quasi tutti).
2. «Luna: pochi o zero trade», prob. 30% → **falso**: 672–931 operazioni l'anno. Resta **NON VERIFICATO** se l'orario del set (offset GMT 1/1 imposto) coincide con la finestra prevista dal venditore.
3. «Daytrade Pro `highrisk` > 20% DD in almeno un anno», prob. 60% → **vero** (29,5%).
4. «Indicement e ORB Master correlati > 0,6», prob. 75% → **NON MISURATO** (un solo periodo, non confrontati).
5. «Almeno un EA saltato dalla regola delle prime due passate», prob. 40% → **falso**: nessuno saltato.
6. «Correlazione col trio oro sotto 0,15 in valore assoluto» → **quasi**: tutti sotto 0,09 tranne Daytrade Pro (0,09–0,16).

## 5. Correlazione col trio sull'oro (Reaper + Goldbot + Phantom, P&L giornaliero realizzato)
Anni in comune con i test sull'oro già fatti: 2013, 2020, 2025 (indici: solo 2025). Giorni senza operazioni contati come zero.
| Candidato | corr. media | intervallo |
|---|---|---|
| Daytrade Pro (3 set) | +0,12 / +0,12 / +0,13 | 0,09 – 0,16 |
| Apex Ultra / Conservative | +0,05 | 0,00 – 0,09 |
| Stability Pro low / medium-low | +0,01 / 0,00 | −0,06 – +0,07 |
| Luna 4%DD / lowrisk | −0,01 / −0,02 | −0,04 – 0,00 |
| Indicement, ORB Master (2025) | −0,02 … +0,03 | — |
**Le correlazioni con l'oro sono vicine a zero: la diversificazione c'è.** Ma il peggior giorno del trio sommato al candidato non è sempre migliore: con Apex nel 2013 il giorno peggiore passa da −4.805 a −24.676/−33.517 EUR (griglia). Con Daytrade Pro `lowrisk` il giorno peggiore sale poco (−4.805 → −5.099 nel 2013; −1.866 → −2.469 nel 2020; −1.663 → −1.687 nel 2025).

## 6. Limiti (dichiarati)
- **Flottante non misurato**: la perdita giornaliera è calcolata sul saldo realizzato. Quella con le posizioni aperte (come la contano le prop) può essere peggiore, soprattutto per le griglie.
- **Guardian non simulato**: nessun modello A/B come per il GTP. Da fare sui set sotto osservazione.
- **Anni non etichettati** long/short/laterale: nei report non ci sono i prezzi dei cross. Servirebbe un'estrazione dei rendimenti annuali (D1) dei simboli.
- **Indici**: un solo periodo (2025-01 → 2026-09, storia nativa BCM corta); gli orari dipendono da `AutoGMT` dei due EA nel tester, **NON VERIFICATO**. ORB Master e Indicement perdono o pareggiano: l'assenza di vantaggio potrebbe dipendere anche da questo.
- **Luna**: l'offset GMT 1/1 è una mia ipotesi (server BCM GMT+1 fisso).
- **Dati forex** dal 2013: qualità del tester 99–100% con barre da 1 minuto, ma spread e slippage reali non modellati oltre le commissioni del tester.
- Il test dell'ultimo giorno dell'anno include la chiusura forzata delle posizioni aperte (visibile come giorno di forte perdita il 31/12).
- 25 zip su 25 arrivati; il file `00_INDICE.txt` non è stato caricato (non serve per i numeri).

## 7. Cosa propongo di fare adesso (decide Claudio)
1. Simulare il Guardian (4,3% giornaliero, 9,3% totale) su Daytrade Pro `lowrisk`, `Prop` e sulle griglie, con perdita flottante dove possibile.
2. Misurare il Daytrade Pro `lowrisk` insieme al trio sull'oro: peggior giorno e tempo per arrivare al +8% / +10% (target prop).
3. Estrarre i rendimenti annuali dei simboli per etichettare gli anni.
4. Decidere se riprovare ORB Master / Indicement con orari verificati (un'estrazione dei prezzi M1 per controllare l'apertura) e se aprire un terminale FTMO per i due Bitcoin.
