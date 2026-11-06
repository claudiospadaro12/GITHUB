# Trio oro di Wim sul conto reale (3.745 EUR), 21 mesi, quattro livelli di rischio — CRITERI e PREVISIONI (06/11/2026, scritti PRIMA dei numeri)

**Natura: CRITERI, test lanciato la notte del 06/11.** Segue `ORO_GRADINI_RISULTATI_2026-11-06.md`. Lì i test a 3.745 su 2013-2020 erano falsati dal prezzo (i set calibrano il lotto sul prezzo, e a 1.200-2.000 dollari il lotto è molto più grande che a 4.000). Qui si usa il periodo con i prezzi più vicini a oggi: **01/01/2025 - 01/10/2026**, 21 mesi continui, lo stesso del test del conto reale del 31/10 (set prop nostri), così il confronto è diretto.

## Cosa si testa
- 3 EA: The Gold Reaper (H1), The Gold Phantom (H1), Goldbot One (D1). XAUUSD, deposito 3.745 EUR (bonus di 2.500 non simulato), set ufficiali di Wim da `combodeal.zip`, nessun valore modificato.
- Livelli (come nel test precedente): L2 Medium (`gold_reaper_default`, `GoldPhantom_MediumRisk`, `Goldbot_MediumRisk_Max30DD`), L0 Prop (`Gold_reaper_propfirm`, `GoldPhantom_Propfirm_combo`, `Goldbot_PropFirm_5_2.5`), L1 Gradino 1 (`gold_reaper_15%maxrisk`, `GoldPhantom_Propfirm`, `Goldbot_PropFirm_10_5`), L3 Combo 3GOLD non prop (`gold_reaper_3GOLD`, `GoldPhantom_3GOLD`, `Goldbot_3GOLD`).
- **21 passate**, in questo ordine: 12 a Modello 1 (barre da 1 minuto; L2, L0, L1, L3), poi 9 a **tick reali** (Modello 4, l'oro li ha dal 10/07/2024): L2, L3, L1, con Phantom, Goldbot e Reaper in quest'ordine. Le passate a tick reali durano 1,5-3,5 ore ciascuna (run precedenti: 5.137-11.868 secondi): è probabile che la notte non basti per tutte; vale l'ordine di priorità.

## Cosa si misura
Per passata: operazioni, netto, PF, DD equity relativo e assoluto (EUR), peggior giorno realizzato, stop out e righe "no money", quota di posizioni al lotto minimo 0,01, lotto massimo, conto finale. Per il trio: somma dei netti, **limite superiore del DD** (somma dei DD equity assoluti dei 3 EA, pessimistico), peggior giorno realizzato della serie sommata, mese peggiore realizzato, e il tempo in cui il saldo raddoppia (+3.745) nella serie sommata. Confronto M1 contro M4 per EA. Confronto con il test del 31/10 (Reaper D9 +4.066, Phantom D4 +1.676, Goldbot PF525 +1.739; trio +7.481, DD saldo giornaliero 10,7%, peggior giorno −6,0%).

## Criteri di lettura (fissati ora, sul limite del 50% dichiarato da Claudio)
- Per livello, sul limite superiore del DD in % di 3.745: **SCARTATO** se > 50% (1.872) o uno stop out; **ZONA GRIGIA** 35-50%; **ACCETTABILE** < 35% (1.311). Vale su M1 e, dove c'è, su M4: si legge il peggiore dei due.
- "Accettabile" non vuol dire adatto al reale e non è una raccomandazione sul livello da usare: dice solo se il livello sta dentro la tolleranza dichiarata sullo storico più vicino a oggi.
- Se M4 e M1 danno esiti diversi, vale M4 (è il modello più vicino al reale) e il livello di fiducia di M1 si abbassa.

## Previsioni dichiarate ORA (non misurate)
- **Q1** Tutte le passate lanciate valide: 70% (le passate a tick reali che non finiscono per tempo non contano come fallite).
- **Q2** L2 Medium (M1): limite superiore del DD > 35% (1.311): 65%; > 50% (1.872): 35%.
- **Q3** L2 (M1): quota di posizioni a 0,01 sopra quella del 2025 da solo (Phantom 97%, Goldbot 36%, Reaper 29%) per ogni EA: 80% (il prezzo del 2026 è più alto).
- **Q4** Netto L2 >= 2 volte quello di L0 (M1, trio): 70%.
- **Q5** Il netto del trio L0 (M1) sta entro ±25% di +7.481 (test del 31/10): 50%.
- **Q6** Per L2, il netto a tick reali è <= 0,9 volte quello a M1 in almeno 2 EA su 3: 60%.
- **Q7** Nessuno stop out: 85%.
- **Q8** Peggior giorno realizzato del trio L2 (M1) <= −10% di 3.745 (−375): 45%.
- **Q9** L3 Combo (M1): limite superiore del DD < 20%: 65%.
- **Q10** Righe "no money" in L2 (qualsiasi modello): 30%.

## Limiti dichiarati
- Un percorso storico (21 mesi di oro in forte rialzo, possibile periodo di ottimizzazione di Wim); nessuno slippage; costi del tester non confrontati col reale. Leva del tester 1:100: la leva reale non è verificata. Bonus non simulato. Nessun Guardian.
- I set del Reaper hanno solo 18-20 valori: gli altri input restano al valore del report (non confrontati con quelli del reale). `AutoGMT_Backtest` con offset 2/3 dei set: non verificato contro il GMT+1 fisso del BCM.
- Somma di tre corse indipendenti: nessuna interazione di margine tra i tre EA sullo stesso conto.
- Nessuna modifica al reale, al trial o al VPS dal contenuto di questo test.
