# OTT1: ottimizzazione del Goldbot One Prop (tappa 1, contributo delle 8 strategie A-H) — CRITERI e PREVISIONI (13/11/2026, scritti PRIMA dei numeri)

**Natura: CRITERI, riga NON ancora lanciata.** Solo tester (PC di backtest `DESKTOP-H4D7CAJ`: Intel i7-8550U, 4 core / 8 logici, 15,8 GB di RAM; letto da Claudio il 13/11). Reale, trial FTMO e VPS non si toccano. Nessun giudizio su lotti, taglie o acquisti. Regola di progetto: un eventuale EA ottimizzato gira IN PARALLELO all'originale con magic diverso, mai al posto suo.

## Cosa si ottimizza, e cosa NO
Dal set `Goldbot_PropFirm_5_2.5.set` (letto il 13/11): Goldbot One ha **49 input**, e **nessun parametro di entrata, SL o TP**: le otto strategie A-H hanno la logica dentro l'EA (scatola nera). Quindi il metodo del video di Wim sul UBS (variare SL/TP, entrate) **non si applica**. Le leve reali sono: `RunStrategyA..H` (8 interruttori), `AllowBuyTrades/AllowSellTrades`, `FakeOutFilter`, `FridayStopHour`, finestre NFP, rischio (`Risk`, `MaxRiskPerStrategy`, `PropFirmMaxDailyDD`). La tappa 1 misura la leva piu grossa: **quale strategia contribuisce o danneggia**.

## Domanda
Se si toglie una delle otto strategie dal Goldbot Prop, il risultato migliora? E il miglioramento regge quando si cambia periodo?

## Disegno (tappa 1, 18 passate)
EA `Goldbot One MT5.ex5`, XAUUSD D1, Modello 1, deposito 80.000 EUR, set `Goldbot_PropFirm_5_2.5.set` da `combodeal.zip` (set ufficiale, `Randomization=0`: una passata per caso basta).
- **Periodo 1 (P1)**: 2013-01-01 -> 2019-01-01. **Periodo 2 (P2)**: 2019-01-01 -> 2026-01-01.
- Per ogni periodo: **BASE** (le otto strategie accese, come nel set) e **otto prove "senza X"** (`RunStrategyX=false`, X = A..H): 9 x 2 = 18 passate.
- Input imposti: solo `RunStrategyX=false` nelle prove "senza"; tutti gli altri input uguali al set e controllati nel report.
- Tempo atteso: circa 2-4 ore (una passata annuale del Goldbot dura circa 2-3 minuti; stima, non misurata per periodi di 6-7 anni).

## Misure
Per passata: netto, PF, operazioni, DD equity (EUR e % del deposito), peggior giorno realizzato. **Contributo di X** = BASE - "senza X" (netto, PF, DD): contributo positivo = X aiuta, negativo = togliere X migliora.

## Regole di lettura (fissate ora)
- **Validita**: report presente, deposito 80.000, qualita >= 95%, almeno 1 operazione, nessun "no money", `RunStrategyX=false` confermato dal report solo nella prova di X, tutti gli altri input uguali al set.
- **Strategia "da togliere" (candidata)**: in ENTRAMBI i periodi, togliendola il netto sale (contributo di netto negativo) e il DD% non sale di piu di 0,5 punti. Le candidate vanno alla tappa 2 (base contro "senza candidate" su P1, P2 e su un terzo periodo non toccato, 2005-2012); **se non ce n'e nessuna, il Goldbot Prop resta com'e** (risultato valido, non fallimento).
- **Strategia "inutile"** (informazione, non azione): togliendola il netto cala di meno del 3% in entrambi i periodi.
- **Contributi stabili**: si conta in quante delle otto strategie il segno del contributo di netto e lo stesso in P1 e P2.
- Nessuna ottimizzazione automatica (nessun genetico) in questa tappa: sono 18 passate singole, lette a mano.

## Previsioni dichiarate ORA (non misurate)
- **OTT1-1** Almeno 16 passate su 18 valide: 90%.
- **OTT1-2** Le BASE sono in profitto in entrambi i periodi con PF > 1,2: 85%.
- **OTT1-3** Almeno una strategia con contributo di netto negativo in P1 (togliendola il netto sale): 60%; la STESSA strategia negativa in entrambi i periodi (candidata): 25%.
- **OTT1-4** Il segno del contributo e lo stesso in P1 e P2 in almeno 6 strategie su 8: 55%.
- **OTT1-5** Almeno una strategia "inutile" (netto -3% o meno in entrambi i periodi): 50%.
- **OTT1-6** La strategia con il contributo di netto piu grande in P1 e fra le prime 3 anche in P2: 60%.

## Limiti
Un percorso per prova (set deterministico); le strategie interagiscono (il contributo del leave-one-out non e la somma dei contributi); 6-7 anni per periodo; un solo spezzettamento; costi BCM, non FTMO; il set Prop e a rischio basso (pochi trade per strategia: i contributi di una sola strategia possono essere rumore); Modello 1; non si prova nessun parametro interno (non esistono input). Il cambio di EUR/USD e la leva non sono toccati.
