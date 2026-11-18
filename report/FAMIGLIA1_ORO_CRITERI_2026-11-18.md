# Famiglia 1 sull'oro: 7 EA ABTG fuori campione — criteri e previsioni scritti PRIMA dei numeri (18/11/2026)
Natura: solo tester (BCM portabile `C:\MT5_BCM_Opt`, Modello 1 = barre da 1 minuto, XAUUSD dati nativi 2004-2026), nessun ordine, nessun giudizio su lotti/taglie. Richiesta di Claudio ("parti con la prima famiglia sull'oro"). **Parametri = DEFAULT dei sorgenti, nessuna ottimizzazione.** Stesso schema e stesse porte del test dei 14 EA (`CLAU12_14_EA_OTTIMIZZATI_FUORI_CAMPIONE_CRITERI_2026-11-18.md`).
## EA (copie `*_F1` dei sorgenti dal PC di Claudio; unica differenza: include del Guardian locale; Guardian, verbosita e autotest spenti nel tester)
**CRT_TurtleSoup** (D1), **PunteLarry** (grafico H1, pattern su D1), **WOL** (D1), **TurnaroundTuesday** (H1), **GoldBreakoutATR** (M1; l'unico pensato per l'oro), **LiquiditySweep** (H4), **PTE** (H4). Escluso `FiboH4_Multi`: e per forex (GBPUSD/USDJPY/EURUSD), va nella famiglia forex. **Limite dichiarato:** a parte GoldBreakoutATR non sono dichiarati per l'oro: il test e un'estensione esplorativa del loro motore.
## Misura
Una passata per EA e finestra: **2015-2023 (primaria)** e **2005-2014 (controllo)**, deposito 100.000 EUR, rischio % di default degli EA (composto): statistiche sul rendimento per operazione in % del saldo. Il 2024-2026 non si apre. Timeout 60 minuti per passata.
## Porte (P1-P5, identiche a quelle dei 14 EA, nessuna ritoccata)
- **P1 validita:** report letto, >= 3 anni interi, nessun errore.
- **P2:** PF sui rendimenti per operazione >= 1,20 **e** rendimento totale > 0 (2015-2023).
- **P3:** >= 100 operazioni. **P4:** t >= 2,7. **P5:** >= 60% degli anni in profitto, nessun anno oltre il 50% del totale, DD equity <= 20%.
- **REGGE** = P1-P5; **INTERMEDIO** = P2 passa ma una tra P3/P4/P5 no; **NON REGGE** = P2 fallisce; **NON VALUTABILE** = P1 fallisce.
- La finestra 2005-2014 e di controllo: un EA che REGGE nel 2015-2023 ma ha PF < 1,0 nel 2005-2014 viene segnato "instabile".
## Previsioni (scritte ora)
- Almeno 1 EA su 7 REGGE: **10%**. Almeno 1 INTERMEDIO: **30%**. Almeno 4 su 7 NON REGGONO: **75%**.
- GoldBreakoutATR (l'unico per l'oro) e il migliore dei sette per PF 2015-2023: **40%**.
- Qualche EA da NON VALUTABILE per poche operazioni (< 100 in 9 anni) o per errori: **60%** (i D1/WOL/Turnaround fanno pochi trade).
## Cosa NON misura
Slippage e tick reali (Modello 1), costi del feed FTMO, correlazione con gli altri EA. Per i pochi trade D1 il giudizio e debole.
