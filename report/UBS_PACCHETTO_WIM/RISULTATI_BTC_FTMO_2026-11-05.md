# Risultati test Bitcoin su terminale FTMO (Bitcoin Reaper e Bitcoin Scalp Pro) — 05/11/2026

Fonte: 19 zip WIM_01..19 della cartella `ANNO80K_BTC_FTMO_20261105_0901` (56 passate, 56 report). Terminale `C:\MT5_Backtest\Mt5_Ftmo_Prova` (demo FTMO, investor), BTCUSD H1, Modello 1 (barre, non tick reali), deposito 80.000 EUR, leva 1:100 nel tester, un anno per passata (2018-2025), input solo dai set del venditore. Criteri e previsioni: `CRITERI_BTC_FTMO_2026-11-05.md` (scritti prima dei numeri). Dati: `analisi/btc_ftmo/*.json`.

## Esito in una riga
**Nessuno dei 7 set passa i criteri.** Bitcoin Reaper perde in 2018-2021 e 2023-2025 quasi ovunque (solo il 2022, anno di ribasso, e' positivo per tutti), Bitcoin Scalp Pro e' positivo solo 2022-2024 e con numeri piccoli. **Le commissioni FTMO (0,0325% per lato, applicate dal tester) mangiano quasi tutto il margine lordo.**

## Tabella: netto / DD equity relativa / lordo prima delle commissioni / commissioni (EUR, per anno)
| Set | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 |
|---|---|---|---|---|---|---|---|---|
| Bitcoin Reaper HighRisk | -58.6k / DD 76% / lordo -44.8k / comm -13.9k | -61.3k / DD 78% / lordo -27.6k / comm -33.7k | -69.2k / DD 88% / lordo -46.4k / comm -22.8k | -74.7k / DD 94% / lordo -55.9k / comm -18.8k | +28.1k / DD 29% / lordo +182.2k / comm -154.1k | -52.9k / DD 71% / lordo +16.8k / comm -69.7k | -38.2k / DD 55% / lordo +49.2k / comm -87.4k | -20.6k / DD 41% / lordo +73.4k / comm -94.0k |
| Bitcoin Reaper MediumRisk | -68.1k / DD 86% / lordo -52.4k / comm -15.7k | -64.5k / DD 81% / lordo -33.0k / comm -31.6k | -73.0k / DD 92% / lordo -47.7k / comm -25.3k | -77.3k / DD 97% / lordo -59.8k / comm -17.5k | +47.1k / DD 14% / lordo +138.5k / comm -91.4k | -22.7k / DD 40% / lordo +37.3k / comm -60.0k | +4.7k / DD 15% / lordo +77.8k / comm -73.0k | -10.4k / DD 28% / lordo +53.5k / comm -63.9k |
| Bitcoin Reaper LowRisk | -70.0k / DD 88% / lordo -50.7k / comm -19.3k | -43.7k / DD 56% / lordo -19.9k / comm -23.8k | -58.3k / DD 74% / lordo -33.6k / comm -24.7k | -78.7k / DD 98% / lordo -62.6k / comm -16.1k | +25.3k / DD 10% / lordo +69.3k / comm -44.0k | -7.4k / DD 18% / lordo +29.3k / comm -36.7k | +11.2k / DD 10% / lordo +49.9k / comm -38.7k | -3.3k / DD 16% / lordo +31.5k / comm -34.9k |
| Bitcoin Reaper PropFirm | -67.1k / DD 87% / lordo -48.9k / comm -18.2k | -36.9k / DD 47% / lordo -15.3k / comm -21.6k | -51.5k / DD 65% / lordo -28.9k / comm -22.6k | -78.0k / DD 98% / lordo -60.9k / comm -17.1k | +22.8k / DD 9% / lordo +61.5k / comm -38.7k | -6.9k / DD 16% / lordo +26.0k / comm -32.9k | +10.3k / DD 9% / lordo +44.8k / comm -34.5k | -3.5k / DD 15% / lordo +28.0k / comm -31.5k |
| Scalp Pro 1% risk/trade (low) | -25.5k / DD 33% / lordo -19.8k / comm -5.7k | -20.3k / DD 26% / lordo -14.9k / comm -5.4k | -25.6k / DD 33% / lordo -17.6k / comm -8.0k | -41.1k / DD 60% / lordo -25.4k / comm -15.8k | +42.8k / DD 5% / lordo +68.1k / comm -25.3k | +14.8k / DD 15% / lordo +42.2k / comm -27.4k | +13.9k / DD 9% / lordo +43.4k / comm -29.6k | -6.4k / DD 13% / lordo +16.5k / comm -22.9k |
| Scalp Pro 2% risk/trade (medium) | -25.5k / DD 33% / lordo -19.8k / comm -5.7k | -20.3k / DD 26% / lordo -14.9k / comm -5.4k | -26.3k / DD 33% / lordo -18.3k / comm -8.0k | -60.2k / DD 83% / lordo -41.6k / comm -18.6k | +41.4k / DD 5% / lordo +69.1k / comm -27.6k | +13.1k / DD 16% / lordo +41.1k / comm -27.9k | +23.9k / DD 17% / lordo +77.0k / comm -53.2k | -12.2k / DD 25% / lordo +28.0k / comm -40.2k |
| Scalp Pro PropFirm | -25.5k / DD 34% / lordo -19.8k / comm -5.7k | -17.2k / DD 47% / lordo -11.8k / comm -5.4k | -25.2k / DD 32% / lordo -18.3k / comm -6.9k | -39.8k / DD 54% / lordo -31.1k / comm -8.7k | +17.2k / DD 13% / lordo +32.4k / comm -15.2k | +8.3k / DD 14% / lordo +22.8k / comm -14.5k | +4.4k / DD 6% / lordo +18.5k / comm -14.1k | -3.8k / DD 8% / lordo +8.0k / comm -11.8k |

## Cosa dicono i numeri (letti dai report)
1. **Commissioni**: il tester le ha applicate (es. -1,51 EUR su 0,05 lotti a 96.183 USD = ~0,031% in EUR, coerente con 0,0325% per lato). Sommando i 8 anni: Reaper PropFirm lordo +6,2k contro commissioni -217,1k; Reaper LowRisk lordo +13,2k contro -238,1k; Scalp Pro PropFirm lordo +0,7k contro -82,3k. Nel 2025 Reaper PropFirm ha 4.665 operazioni, lordo +28,0k, commissioni -31,5k, netto -3,5k. **Con queste commissioni il netto resta intorno a zero o negativo anche quando il lordo e' positivo.**
2. **Lotto e prezzo del Bitcoin**: nel 2018-2020 i lotti toccano il massimo di 5,00 (HighRisk/Reaper PropFirm; Scalp Pro quasi sempre 5 lotti), poi scendono con il prezzo: lotto medio Reaper PropFirm 1,34 (2018), 0,25 (2021), 0,12 (2025). I set del venditore dimensionano il lotto con il "max drawdown a 0.01 lotti in $", tarato sul prezzo e sul broker del venditore (Wim 04/09: "responsibility of the client... I can't adjust it to the broker"). **I risultati 2018-2021 sono quindi dominati da un lotto non adatto al prezzo di allora: non provano che la strategia non funzioni, provano che quel set a quel prezzo e' fuori taratura.** Il tetto di 5 lotti (EA o simbolo) e' NON VERIFICATO.
3. **Set identici**: Scalp Pro 1%/trade e 2%/trade danno lo stesso identico risultato nel 2018-2019 (e quasi nel 2020): in quegli anni il lotto e' fermo al tetto di 5, quindi il parametro Risk non cambia niente.
4. **Margine**: righe "no money" fino a 125.964 (Reaper Medium 2021), 83.210 (Low 2021), 76.520 (High 2021): il tester a 1:100 si e' trovato senza margine. A 1:3,3 (FTMO reale) sarebbe molto peggio: la gran parte dei lotti 2018-2022 sarebbe impossibile.
5. **Reaper 2022**: tutti e 4 i set positivi (+22,8k PropFirm, +47,1k Medium, +25,3k Low, +28,1k High) in un anno di ribasso. Lordo High +182k, commissioni -154k.
6. **Operazioni**: Reaper 715-4.865 per anno; Scalp Pro 235-348 per anno. Qualita' storico: 87% (2018), 99% (2019), 94% (2020), 100% (2021, 2023, 2024), 99% (2022), 98% (2025).

## Verdetto sui criteri (fissati prima)
- Da scartare se DD relativa > 20% in un anno o stop out: **tutti i 7 set sono scartati** (Reaper: 47-98% nel 2018-2021; Scalp Pro: 26-83% nel 2018-2021).
- Filtro prop (DD assoluta <= 7.440 e peggior giorno >= -4,3%): sui soli anni 2023-2025 passa solo **Scalp Pro PropFirm** (DD ass. 2.469 / 74 / 5.181, peggior giorno -1,9% / -2,0% / -2,2%), con netto +8,3k / +4,4k / -3,8k (circa +10% / +5% / -5% su 80k). Reaper PropFirm e LowRisk nel 2025 hanno DD ass. ~6,8-7,0k ma il netto e' negativo.
- **Nessuno e' promosso a "sotto osservazione"**: serve passare in 5 anni su 8 senza nessun anno scartato.

## Previsioni di C0: giuste o sbagliate
1. Storia FTMO >= 6 anni: SI, tutti gli 8 anni (stimato 25% per tutti e 8). Qualita' 87%/94% nel 2018/2020.
2. Il tester NON applica la commissione (60%): **SBAGLIATA**, la applica.
3. Almeno un set con righe "no money": **GIUSTA** (molti).
4. Un HighRisk sopra 20% DD in un anno (80%): **GIUSTA** (tutti gli 8 anni).
5. I set Prop <= 9,3% DD in tutti gli anni (40%): **SBAGLIATA** (97,8% Reaper 2021, 54% Scalp Pro 2021).
6. Reaper positivo nei rialzi 2020/2021/2024 con >= 5 set su 7 (60%): **SBAGLIATA** (2020 e 2021 negativi in tutti; 2024 positivo in 3 set su 4). In ribasso almeno un anno negativo: GIUSTA (2018 tutti negativi).
7. Correlazione con il trio oro < 0,15: **NON MISURATA** (non ho ancora calcolato le serie giornaliere).
8. Scalp Pro piu' operazioni di Reaper (65%): **SBAGLIATA** (Scalp ~300/anno, Reaper 715-4.865).

## Limiti (da non dimenticare)
- Modello 1 (barre) su BTCUSD: Wim dice che per Bitcoin e per gli scalp servono i real ticks. Un risultato buono o cattivo qui non e' definitivo.
- Leva tester 1:100, non 1:3,3. Nessuno slippage.
- `AutoGMT=true` ma il giornale mostra "Error when reading GMT URL, code 4014": l'orario/i filtri news dell'EA nel tester sono NON VERIFICATI.
- Il lotto dipende dal "max drawdown a 0.01 lotti" del venditore: nessun input e' stato ricalibrato sul prezzo/broker (scelta dei criteri: valori del venditore). Il test dice come si comporta il set "cosi' com'e'", non quanto vale la strategia con il lotto giusto.
- Una sola passata per anno e per set: nessun intervallo di confidenza. Nessun "migliore" e' una scoperta.
- Guardian sim, correlazione col trio e floating equity: NON misurati in questo giro.

## Cosa consiglio (decide Claudio)
1. Non usare nessuno di questi set cosi' com'e' sul FTMO.
2. Se interessa continuare: ricalibrare il "max DD a 0.01 lotti" sul nostro broker (Wim: backtest 1% su balance fisso, poi scalare) e rifare solo 2023-2025, con real ticks se disponibili. Il candidato piu' sensato e' Scalp Pro PropFirm, ma il margine netto e' piccolo.
3. Le commissioni vanno tenute in conto in ogni decisione: il lordo da solo inganna.
