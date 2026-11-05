# Trio oro di Wim a quattro livelli di rischio, su 80.000 e 3.745 EUR — CRITERI e PREVISIONI (05/11/2026, scritti PRIMA dei numeri)

**Natura: CRITERI, test lanciato la notte del 05/11.** Nasce dall'esperimento della prova FTMO e del reale: i set Medium sono già attivi sul trial (80.700) e sul reale (3.911) e nessuno li ha mai provati nel tester come trio su più anni. Nel tester non si tocca il reale, il trial o il VPS: è solo storico.

## Cosa si testa
- **3 EA**: The Gold Reaper (H1), The Gold Phantom (H1), Goldbot One (D1). XAUUSD, Modello 1 (barre di 1 minuto), terminale BCM. Un solo percorso storico per anno.
- **4 anni**: 2013 (calo), 2018 (laterale), 2020 (rialzo), 2025.
- **2 depositi**: 80.000 EUR (taglia della prova FTMO) e 3.745 EUR (taglia del reale, bonus non simulato).
- **4 livelli di rischio**, tutti set ufficiali di Wim da `combodeal.zip`, nessun valore modificato:
| Livello | Reaper | Phantom | Goldbot One |
|---|---|---|---|
| L0 Prop | `Gold_reaper_propfirm` (MaxAllowedDD 9, OnlyUp false, limite giornaliero 4) | `GoldPhantom_Propfirm_combo` (4) | `Goldbot_PropFirm_5_2.5` (MaxRisk 1,0) |
| L1 Gradino 1 | `gold_reaper_15%maxrisk` (15, OnlyUp true) | `GoldPhantom_Propfirm` (9) | `Goldbot_PropFirm_10_5` (2,0) |
| L2 Medium | `gold_reaper_default` (30, OnlyUp true) | `GoldPhantom_MediumRisk` (30, OnlyUp true) | `Goldbot_MediumRisk_Max30DD` (6,0) |
| L3 Combo 3GOLD | a 80k: `Gold_reaper_propfirm_combo_3GOLD` (3) / a 3.745: `gold_reaper_3GOLD` (7) | a 80k: `GoldPhantom_Propfirm_combo_3GOLD` (4) / a 3.745: `GoldPhantom_3GOLD` (7) | a 80k: `Goldbot_PropFirm_combo_3GOLD` (0,8) / a 3.745: `Goldbot_3GOLD` (1,3) |
- **96 passate** (3 EA x 4 anni x 2 depositi x 4 livelli), in quest'ordine di priorità, per poter leggere anche un giro interrotto: L2 (Medium), L0, L1, L3; dentro ogni livello prima 80.000 poi 3.745. Le passate sono indipendenti; i numeri del trio sono la somma di tre corse separate.

## Cosa si misura
Per passata: operazioni, netto, PF, DD equity relativo e assoluto (EUR), peggior giorno realizzato, stop out e righe "no money", quota di posizioni al lotto minimo 0,01. Per il trio: somma dei netti, **limite superiore del DD** = somma dei tre DD equity assoluti (la curva combinata dell'equity non si ricostruisce; è pessimistico), peggior giorno realizzato della serie sommata.

## Criteri di lettura (fissati ora)
- **80.000 (regole FTMO: 4.000 al giorno, 8.000 in totale)**, per ogni livello e anno:
  - **NON REGGE**: stop out in una passata, oppure peggior giorno realizzato del trio <= -4.000.
  - **REGGE**: limite superiore del DD <= 8.000 e peggior giorno > -4.000, in tutti e 4 gli anni.
  - **INCERTO**: tutto il resto (limite superiore del DD oltre 8.000 ma nessun giorno a -4.000). Il flottante giornaliero non è misurato: INCERTO non vuol dire sicuro.
- **3.745 (tolleranza del 50% dichiarata da Claudio)**: **SCARTATO** se in un anno il limite superiore del DD supera 1.872 (50%) o c'è uno stop out; **ZONA GRIGIA** tra 35% (1.311) e 50%; **ACCETTABILE** sotto 35% in tutti gli anni. Non vuol dire adatto al reale.
- Confronto tra livelli: netto, e netto diviso limite superiore del DD, per anno. Mai giudicare su un solo anno.

## Previsioni dichiarate ORA (non misurate)
- **P1** Tutte e 96 le passate valide (deposito, set applicato, nessun KO): 60%.
- **P2** A 80.000, L2 Medium ha almeno un anno con peggior giorno realizzato del trio <= -4.000: 45%.
- **P3** A 80.000, L2 ha limite superiore del DD > 8.000 in almeno 3 anni su 4: 75%.
- **P4** A 80.000, L0 Prop REGGE in tutti e 4 gli anni: 55%.
- **P5** Netto L2 > netto L0 in almeno 3 anni su 4: a 80.000 80%; a 3.745 55% (il lotto minimo schiaccia le differenze).
- **P6** A 3.745, in L2 almeno il 70% delle posizioni di Phantom e di Goldbot è a 0,01: 75%.
- **P7** A 3.745, L2 ha limite superiore del DD > 50% in almeno un anno: 25%.
- **P8** Nessuno stop out nelle 96 passate: 80%.
- **P9** A 80.000, L3 ha netto/limite superiore del DD più alto di L2 in almeno 3 anni su 4: 60%.
- **P10** Il DD del Reaper a 80.000 più che raddoppia passando da L1 (15) a L2 (30) in almeno 3 anni su 4: 70%.

## Limiti dichiarati
- Un percorso per anno; OHLC a 1 minuto (non tick reali, che per l'oro esistono dal 10/07/2024); nessuno slippage; costi del tester non confrontati col reale; leva 1:100 nel tester.
- I set del Reaper contengono solo 18-20 valori: gli altri input restano al default dell'EA o all'ultimo valore salvato nel tester, e **non è verificato quale**. Fanno fede gli input stampati nel report di ogni passata: li confronto col set prima di leggere i numeri.
- Phantom e Goldbot hanno `AutoGMT` attivo con offset 2/3: nel tester vale l'impostazione `AutoGMT_Backtest` dell'EA; l'allineamento con il GMT+1 fisso del BCM non è verificato (voce aperta in coda).
- Nessun Guardian, nessun filtro news, nessun flottante giornaliero; il peggior giorno è realizzato.
- Sul trial FTMO le soglie dell'esperimento (equity < 78.000 o perdita di giornata > 2.500 = ritorno ai set prop) restano quelle già scritte.
- Nessuna modifica al live, al VPS o al reale dal contenuto di questo test.
