# Oro su dati FTMO: risultati della griglia da 625 passaggi (17/11/2026)

**Natura:** misura su storico FTMO (Modello 1, XAUUSD D1, 2015-01-01 -> 2022-12-31, 100.000 EUR, lotto 0,1). Solo tester. Criteri e previsioni: `UBS_PILOTA_ORO_OTTIMIZZAZIONE_CRITERI_2026-11-15.md`, sezione 18 (scritti prima dei numeri). Dati: `UBS_PILOTA_ORO_dati/G_ORO_FTMO_625_ReportOptimizer_2026-11-17.xml`, output completo in `analisi_oro_ftmo_output_2026-11-17.txt`.

## 1. Controllo bloccante: SUPERATO
Passaggio centrale (550/480/600/1700) = **+3.573,72 con 139 operazioni** (DD 386 EUR), identico alla passata singola (V6). La griglia e valida. (Il primo file mandato il 17/11 mattina era la vecchia griglia BCM, riconosciuta e scartata: stesso file della griglia 2 BCM; conto 50503392.)

## 2. Numeri
- **625 passaggi su 625 in profitto**; PF da 1,87 a 3,47 (mediana 2,58); operazioni 118-142; DD da 281 a 2.058 EUR (mediana 1.039).
- Pool (PF >= 1,30, operazioni >= 100, recovery >= 1,5, profitto > 0, DD <= 585): **233 su 625**.
- **Nessun passaggio con PF > 3 e DD <= 585** (60 hanno PF > 3, tutti con DD > 585).
- Rendimento/DD del centro 9,25 (decimo su 625). Migliore del pool: **C1 = 9,76 (x1,06 il centro)**; i primi 10 sono tutti tra 9,18 e 9,76 (-1% / +6%).
- Top 10 (combinazioni distinte): C1 650/480/1050/1700 (+3.906, PF 2,64, DD 400); C2 550/480/1050/1700; C3 450/480/1050/1700; C4 650/480/450/1300; C5 650/480/600/1700; C6 650/480/750/1700; C7 550/480/600/1700 (= centro); C8 450/480/600/1700; C9 650/480/450/1700; C10 350/480/1050/1700.

## 3. Cosa dicono i dati (e cosa no)
- **Il centro di Wim e gia su un altopiano:** il miglior candidato filtrato guadagna solo +6% di rendimento/DD, dentro il rumore. Non c'e nessun "set molto migliore" in questo spazio.
- **Scadenza (Expiration):** il rendimento sale in modo monotono 96 -> 480 ore (rend/DD medio 4,15 -> 5,52) e **tutti e 10 i candidati stanno sul bordo 480**: l'ottimo e al limite della griglia, non lo abbiamo mai bracketed. Sul centro: 2.867 (96 h) -> 3.574 (480 h), con operazioni 120 -> 139.
- **Limit (target):** a 1700 il DD e ~386-441; da 2100 in su il DD sale a ~1.040-1.215 (x2,7) mentre il profitto cresce solo fino a +4.648 (limit 2900, PF 3,20, DD 1.040). **Il filtro DD <= 585 esclude proprio la zona "target lontano"** che sul BCM sembrava la migliore: su FTMO quel guadagno si paga con un DD fino a 2,7 volte.
- **MinDist:** 450 e 550 danno risultati identici in 100 coppie su 125: **il parametro e quasi inerte** nel range provato (C2/C3 e C7/C8/C0 sono duplicati di fatto, a meno che finestre diverse non li separino).
- **625/625 in profitto non e una prova di vantaggio futuro:** dice che in questa regione e su questi anni la strategia non perde, non che continuera.

## 4. Previsioni (sezione 18) contro l'esito
| Previsione | Esito |
|---|---|
| Il controllo riproduce V6 (95%) | **Giusta** |
| Il migliore con filtro DD supera il centro di >= 20% (70%) | **SBAGLIATA**: +6% |
| L'altopiano resta piatto, nessuna zona PF > 3 e DD <= 585 (60%) | **Giusta** |
| La zona migliore e di nuovo "target piu lontano" (60%) | **SBAGLIATA**: il migliore e target 1700 (il centro); i target lontani costano DD x2,7 |
| Un candidato passa V1 e V2 (40%) / V1+V2+2025-26 (30%) | **da misurare** |

## 5. Prossimo passo (criteri gia scritti, sezione 18)
Convalide su FTMO, Modello 1: V1 2023-2024 (PF >= 1,20, profitto > 0, recovery >= 1, rend/DD >= 1,10 x C0 FTMO); V2 2015-2018 e 2019-2022 (PF >= 1,15 e profitto > 0 in entrambe, rapporto DD <= 2,5); 2025 e 2026 solo informativi (gia visti). V3 a tick non valutabile (tick FTMO non scaricati). Script: `backtest_pipeline/righe/VALIDA_FTMO_ORO.ps1` (11 candidati x 5 finestre = 55 passate, stima 1-2 ore).
**Aspettativa scritta ora:** dato l'altopiano, non mi aspetto che un candidato superi C0 di >= 10% su V1; il valore atteso della convalida e soprattutto confermare che il set di Wim regge su dati FTMO. (Probabilita che almeno un candidato con scadenza al bordo superi la soglia 1,10 x C0 in V1: circa 30%.)
**Contatore di campagna:** 1.347 passate precedenti + 625 di questa griglia = **1.972**, piu le 55 delle convalide = 2.027.
