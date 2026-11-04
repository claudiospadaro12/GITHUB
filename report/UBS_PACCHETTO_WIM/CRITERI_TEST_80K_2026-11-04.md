# Criteri e previsioni — test dei 6 EA Wim su conto prop 80.000 EUR (scritti PRIMA dei risultati) — 04/11/2026
Riga: `backtest_pipeline/righe/RIGA_LANCIA_WIM_PACCHETTO_80K.txt` (+ bootstrap corto). Scripts: `ANNO80K_WIM_TESTER.ps1`, generatori in `backtest_pipeline/`. Nessun risultato visto.

## Perimetro
- EA: Daytrade Pro, Luna AI Pro, Stability Pro, Apex Trader (forex, grafico EURUSD con OneChartSetup), Indicement e ORB Master (indici, nomi BCM SPXUSD / U30USD / NASUSD). **28 set del venditore, tutti**, nessuno scelto a mano. 88 passate a Modello 1 (barre da 1 minuto), deposito 80.000 EUR, leva 1:100, solo tester.
- **Esclusi dalla riga e perché**: i due Bitcoin (nessun simbolo cripto nel BCM: elenco simboli del 02/11/2026), UBS (a fine giro, come deciso da Claudio), Tesla/DE40/petrolio di UBS (idem).
- Anni forex, scelti prima dei numeri: **2025, 2022, 2020, 2017, 2013** (ordine di esecuzione: dal più recente, perché se i dati o la licenza mancano si vede subito). Indici: 2025-01 → 2026-09 (21 mesi; la storia nativa degli indici BCM è corta, vedi CLAUDE.md per lo storico `_EXT`, che qui non è usato).
- Long/short/laterale: non assegno le etichette a priori. Dopo i test classifico ogni anno dai prezzi del simbolo (rendimento annuo e rapporto direzione/escursione) e riporto i risultati per classe.
- Impostazioni forzate (non del venditore): Luna e Apex con `AutoGMT=false` e offset 1/1 (server BCM GMT+1 fisso; l'auto-rilevamento non funziona nel tester); indici con i nomi dei simboli BCM. Il resto dei valori è del set.
- NON VERIFICATO prima di partire: che gli `.ex5` partano nel tester (licenza), che `ExpertParameters` applichi il set come atteso (il referto confronta gli input del report con quelli del set), la storia dei cross AUD prima del 2017 sul BCM, il comportamento di `AutoGMT` di Indicement/ORB Master nel tester.

## Cosa misuro per ogni passata (e per set, aggregando gli anni)
Operazioni, netto, PF, **DD di equity e di saldo (in % di 80.000)**, peggior giorno e peggior sequenza (dal report/trade), tempo di recupero, stop out, qualità dei dati, input applicati. Poi: sensibilità allo spread dove possibile, correlazione dei P&L giornalieri con Reaper/Goldbot/Phantom/GTP e tra gli EA nuovi, e **simulazione prop** con il Guardian (4,3% giornaliero, 9,3% totale, come per il GTP: modelli A e B, solo perdite realizzate).

## Soglie di lettura (decise ora)
- **Prop 80k FTMO**: perdita giornaliera massima 5% e totale 10%. Un set "passa" il filtro prop in un anno solo se DD di equity ≤ 9,3% **e** peggior giorno ≤ 4,3% senza Guardian; con il Guardian si conta quante volte scatterebbe.
- Un set è **da scartare** se in uno qualsiasi degli anni la DD di equity supera il 20% o se c'è uno stop out. È **da tenere sotto osservazione** se passa il filtro in 4 anni su 5. Nessun set viene promosso da una sola passata.
- Differenza tra set dello stesso EA: si legge come **scala del rischio** (stessa logica, lotti diversi); si verifica se DD e netto scalano in modo lineare (nelle griglie ci si aspetta di no).
- Le frasi di marketing da poter smentire: «profittevole ogni mese dal 2007» (Stability Pro), DD 9/20/50% (Daytrade Pro). Si riportano i mesi in perdita e la DD osservata.
- 88 passate = molte ipotesi: nessun "migliore" è una scoperta; si riporta l'intero quadro per EA, per anno e per set, e il numero totale di confronti.

## Previsioni di C0 (non misurate)
1. Griglie (Apex, Stability Pro): PF alto e DD bassa in 3–4 anni su 5, **un anno con DD profonda** (2020 o 2022), soprattutto nei set "extreme/high". Probabilità che almeno un set Apex/Stability superi il 20% di DD in un anno: **70%**.
2. Luna: DD contenuta, ma molto sensibile al fuso: con offset 1/1 le operazioni cadono nell'orario previsto solo se la mia lettura del GMT è giusta; rischio di pochi o zero trade: **30%**.
3. Daytrade Pro: pochi trade/anno per coppia, DD vicina a quella dichiarata nei nomi dei set ma **non** nel set "highrisk" (50% dichiarato): probabilità che il set highrisk superi il 20% in almeno un anno: **60%**.
4. Indici: Indicement e ORB Master molto correlati tra loro (> 0,6 sui P&L giornalieri): **75%**. Zero o pochi trade per problemi di orario o licenza: **25%**.
5. Probabilità che almeno un EA venga saltato dalla regola "prime due passate senza OK" (licenza/dati): **40%**.
6. Correlazione media dei P&L giornalieri con il trio sull'oro (Reaper, Goldbot, Phantom): in valore assoluto sotto 0,15 per i forex; non faccio previsione per gli indici.
Le previsioni sbagliate le riporto nel referto.

## Controlli
Nessun controllo di questo documento è già stato eseguito. Un controllo non eseguito non è superato.
