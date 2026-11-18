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

## Risultato (18/11/2026; 14 passate su 14 OK; dati in `FAMIGLIA1_ORO_dati/RISULTATI_CONTROLLO_FAMIGLIA1_ORO.csv`; porte P1-P5 applicate su 2015-2023)
| EA | 2015-2023: operazioni / rend. / PF / t / DD | Anni positivi, quota max anno | 2005-2014: PF / rend. | Verdetto |
|---|---|---|---|---|
| **PunteLarry** | 56 / +26,6% / 1,66 / 1,21 / 11,9% | 5 su 9 (56%), 54% | 1,43 / +20,9% (7 su 10 positivi) | **INTERMEDIO** (P2 si; P3, P4, P5 no) |
| TurnaroundTuesday | 464 / -37,9% / 0,84 / -1,80 / 38,4% | 2 su 9 | 0,74 / -58,9% | **NON REGGE** |
| GoldBreakoutATR | 10.531 / -39,6% / 0,94 / -1,50 / 57,0% | 2 su 6 | **1,11 / +83,3% (t +4,74, 29.995 op, DD 8,7%)** | **NON REGGE; instabile** (positivo 2005-14, negativo 2015-23) |
| LiquiditySweep | 154 / -18,2% / 0,79 / -1,23 / 22,0% | 3 su 9 | 0,71 / -19,8% | **NON REGGE** |
| PTE | 92 / -15,5% / 0,48 / -2,50 / 19,3% | 3 su 9 | 1,02 / +0,4% | **NON REGGE** |
| CRT_TurtleSoup | 2 operazioni | 1 anno | 7 operazioni, PF 0,21 | **NON VALUTABILE** (pensato per indici USA: stop minimo 500 punti MT5; sull'oro quasi non opera) |
| WOL | **0 operazioni** in entrambe le finestre | — | 0 | **NON VALUTABILE** (pattern Heikin Ashi/doji sulla linea di apertura settimanale: non scatta mai sull'oro D1 coi default; non e un risultato negativo ne positivo) |
**REGGE: 0 su 7.** Previsioni: >= 1 REGGE (10%) -> NO; >= 1 INTERMEDIO (30%) -> SI (PunteLarry); >= 4 NON REGGONO (75%) -> SI (4); GoldBreakoutATR migliore per PF 2015-23 (40%) -> NO (0,94); qualche NON VALUTABILE (60%) -> SI (2).
**Letture (descrittive, nessuna soglia ritoccata):** (1) **PunteLarry e l'unico con PF > 1,2 in entrambe le finestre (1,66 e 1,43)**, ma con 56-71 operazioni in 9-10 anni (t 0,9-1,2): indizio, non prova; 2017 pesa il 54% del totale 2015-23. (2) **GoldBreakoutATR e il tipico caso da Modello 1:** 10-30.000 operazioni M1, risultato opposto nelle due decadi (t +4,7 e -1,5); le barre da 1 minuto sono ottimistiche per gli scalper (gia visto con i tick reali): non e un candidato. (3) Gli altri quattro che operano perdono con DD 19-38%.
**Non si apre 2024-2026**; resta disponibile come controllo pulito per PunteLarry (mai visto).
