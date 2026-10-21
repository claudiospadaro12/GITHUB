# Prova a tre regimi dell'oro con tre EA: previsioni scritte PRIMA dei numeri (21/10/2026)

**Non controllata da agenti.** Criteri e finestre: `CRITERI_TRE_REGIMI_RIALZO_RIBASSO_LATERALE_2026-10-21.md` par. 7-8 (soglie ancora di Claudio da firmare; usate come proposta). Dati prezzi: `data/prezzi/XAUUSD_D1_BCM_2004-06-11_2026-10-21.csv`.
## Cosa gira (XAUUSD, modello 1 OHLC 1 minuto, 80.000 EUR, leva 1:100, deposito azzerato a ogni passata)
Finestre: RIALZO 01/01/2024-01/01/2025 (R +27,2%), LATERALE 01/06/2022-01/06/2023 (R +7,0%, C 24,6%), RIBASSO 01/04/2013-01/04/2014 (R -19,6%).
- **Goldbot One** (D1): Risk 9999 (use LotsizeStep, mappa PROBABILE), MaxRisk 6.0, StartLots 0.01, step 3000 e 6000. 6 passate (TRANCHE1-6).
- **The Gold Reaper** (H1): TradeFrequency 2, MaxAllowedDD 9.0, PropFirmMaxDailyDD 4.0, OnlyUp false. 3 passate (TRANCHE7-9). Nel 2025-26 con tick reali: vedi `GOLD_REAPER_80K_LETTURA_2026-10-20.md`.
- **Prop Firm Gold EA** (H1): default con gli input di rischio esplicitati (InpBaseMoneyMode 0, InpRiskType 0, InpRiskLevel 0, InpCloseTradesOnEquityDrawdown false, InpMaxEquityDrawdown 4.0). 3 passate (TRANCHE10-12). Nel 2025-26 con tick reali: +34.130, PF 1,25, DD equity 11.023 (13,8% di 80K).
## Previsioni
- **R1** tutti gli input imposti applicati e confermati dal report in tutte le 12 passate: 85%.
- **R2** ogni EA apre almeno 60 operazioni in ognuna delle tre finestre: Goldbot One 75%; Gold Reaper 55%; Prop Firm 65% (rischio: calendario/dati non disponibili negli anni vecchi nel tester [NON VERIFICATO]).
- **R3** Goldbot One: netto positivo e PF >= 1,2 nel RIALZO 2024 per entrambi gli step: 80%; PF >= 1,0 nel LATERALE: 55%; PF < 1,0 nel RIBASSO: 55%.
- **R4** nel RIBASSO la quota del profitto dai long scende rispetto al 2025-26 (82% per Goldbot One): 70%.
- **R5** almeno un EA con PF < 1,0 nel RIBASSO: 75%.
- **R6** nessun EA con PF >= 1,0 e n >= 60 in TUTTE E TRE le finestre: 55%.
- **R7** correlazione giornaliera Goldbot One-Gold Reaper dentro ogni finestra: <= 0,5 nel RIBASSO e nel LATERALE: 55%; nel RIALZO resta vicina a 0,5 (0,4-0,65): 65%.
- **R8** ogni passata dura meno di 15 minuti: 75%.
## Come si leggono
PF, DD in % degli 80.000 e dal picco, n, long/short separati, mesi positivi, rapporto lotti, confronto col buy&hold della finestra. Soglie: "regge" = PF >= 1,0, DD <= 10% degli 80.000, n >= 60; "segue il mercato" = utile solo nel rialzo o oltre l'80% dai long. Il PF non e' un merito con n < 150. Poi correlazione e DD combinato dentro ogni finestra (S-CORR <= 0,5; S-PORT <= 10% di 80.000) per le tre coppie.
## Limiti dichiarati
Il RIBASSO e' di 12 anni fa (prezzo 1.300-1.600, spread e volatilita' in punti diverse); modello OHLC ovunque; costi e slippage approssimati; un solo anno per regime; i tre EA sono prodotti Market (scatole nere, periodo di ottimizzazione ignoto); Goldbot One nel tester usa offset GMT 2/3 per il filtro notizie.
