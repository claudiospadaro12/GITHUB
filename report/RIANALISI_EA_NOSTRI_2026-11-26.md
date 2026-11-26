# Rianalisi degli EA nostri, passo A (26/11/2026): scheda, classe e coda per l'ottimizzazione

**Natura:** lettura di cio' che e' gia' misurato (`CATALOGO_ABTG_FAMIGLIE_E_PARERE`, `COSA_ABBIAMO_DAVVERO`, `PIANO_6_7_EA`, `REGISTRO_UNICO`, `CLASSIFICA_PF`, `PIANO_OTTIMIZZATORE_ABTG`, `STADIO1_ATR`, report di chiusura 19-25/11). **Il codice di ogni EA NON e' stato riletto riga per riga.** 65 `.mq5` nel repo = circa 25 famiglie di logica. Nessun consiglio su lotti/taglie. Nessun numero nuovo: sotto, solo cio' che c'e' gia'.

**Il "sistema nostro"** = `PIANO_OTTIMIZZATORE_ABTG` (stadi 0 screening, 1 robustezza ATR/orari, 2 ottimizzazione con IS/OOS/hold-out e plateau, 3 portafoglio) + contatore di campagna (soglie t >= 3,5, OOS e hold-out obbligatori). Hold-out 2025-26 intatto per mercato.

## Regola di lettura
Ottimizzare aumenta SEMPRE il PF in campione. Un EA il cui PF LORDO fuori campione e' < 1 su tutti i parametri provati non ha niente da ottimizzare: si trova solo rumore, e piu' EA si provano piu' sale il rischio di falsi positivi (per questo il contatore). I "14 Ottimizzati" hanno PF 1,2-3,2 ma sullo STESSO periodo 2024-26 della scelta dei parametri: sono in campione.

## Classe A: storico lungo, ottimizzabili ora (coda del passo B)
| # | EA / famiglia | Mercato, TF | Misure gia' fatte | Stato | Nota per la coda |
|---|---|---|---|---|---|
| A1 | **GoldenZoe_H4** | oro H4 solo long | simulato 12 anni, profili PROP/MEDIO/ALTO; forward demo pronto; vantaggio lordo ma swap long BCM -9,7% annuo | **candidato flotta** | gia' nostro; resta test swap/feed; non ottimizzare oltre i profili senza criteri |
| A2 | **PunteLarry_F1** | oro H1 | PF 1,43/1,66/1,28 su 3 finestre, tick PF 1,44, ~15 op/anno, t<1,3 (p~0,06); EURUSD 0/3 | **indizio nostro** | pochi trade: serve altra storia, non ottimizzazione |
| A3 | **SupertrendReversal_Multi (+_Ottimizzato, SuperWave, SupertrendReversal, Invert)** | oro H4 (poi indici) | oro 2015-23: Multi PF 1,10 (7 anni su 9, DD 22%), gli altri 0,80-0,93; 2005-14 PF 0,68-0,85; **nessun plateau** (ATR 7->12 e RR 2,5->3: PF 1,00->1,10 e 1,02->0,72) | non regge | un solo motore, molti file; candidato a stadio 1 (ATR) solo come prova del metodo |
| A4 | **EMA200 (+_Ottimizzato)** | oro H4 | oro 2015-23 PF 0,80; forward PF 0,97 (30 op), Dow 0,68; cross forex chiusi (PF 0,87/0,64/1,18) | chiuso | non ottimizzare |
| A5 | **GoldenCross (+_Ottimizzato), GoldenCross HA (PDF)** | oro H1, forex | oro PF 0,80-0,93 OOS; forex PF 0,6-0,99; 576 combinazioni: 11 idonei IS, OOS 0,85-0,94 | chiuso | non ottimizzare |
| A6 | **GoldBreakoutATR_F1** | oro | migliore dei 7 breakout oro per PF 2015-23: 40% | da misurare con criteri propri | candidato stadio 0-1 |
| A7 | **IchiTrend_Gold_Base** | oro | nessun numero nei referti (2 citazioni) | **NON MISURATO** | stadio 0 |
| A8 | **MaxMinNotte oro / Nightly** | oro, box notturno | forward MaxMin oro +147 (18 op, PF 1,83), Nightly +296 (6 op); box DAX: realistico 0/16 | forward piccolo | tenere in osservazione |
| A9 | **Famiglia mean reversion**: HARSI, AltaVelocita, TurnaroundTuesday_F1, LiquiditySweep_F1, CRT_TurtleSoup_F1, FvgRetest, ScalperClaudio | forex/oro, M5-H4 | TurtleSoup: 7 op PF 0,21 (non valutabile); gli altri **nessuna misura OOS nei referti** | **NON MISURATI** | stadio 0 su forex 2013-2025 e oro 2005-2023 (dati BCM nativi) |
| A10 | **Breaking Band v4/v4.2, Bulge (S, F5, TS, MASTER), HAM, PTE(_F1), WOL(_F1), FiboH4_Multi, PostNews, BreakoutCorso, ORB(Fibo/Semi), CpiM5** | forex, oro, indici | PF 0,5-0,95 lordo, chiusi 18-25/11 con criteri scritti | **CHIUSI** | non ottimizzare; ORB_Semi e gli scanner restano strumenti manuali |
| A11 | **Nasdaq_Apertura_US(+_Ott), Nasdaq_Live5m, SupRev_NAS_H1** | Nasdaq, `_EXT` dal 2010 | forward Nasdaq Apertura +250 (21 op, PF 3,7); ORB Nasdaq 0/20 set; storico `_EXT` con convenzione oraria da verificare e densita' 4-14% (2010-19) | **da verificare i dati prima** | riga densita' indici gia' pronta (`RIGA_COPERTURA_INDICI_DENSITA`) |

## Classe B: dati nativi solo 2024-2026 (impossibile il fuori campione)
`DAX_Apertura_EU(+_Ott), DAX_Live5m(_v2), DAX_M3, Apertura_Marco, SupRev_DAX_H1/H4, SupRev_DOW_H1/H4, SupRev_CAC_H4, SuperWave_DAX_H4, SuperWave_DOW_H1, MaxMinNotte_DAX_Short, Londra_ORB, DowRaptor`. Forward: SuperWave Dow H1 +541 (23 op, PF 9,7), DAX Live +411 (19 op), DAX Apertura EU RETEST -83 (29 op). **Non si possono promuovere:** parametri scelti e valutati sullo stesso periodo. Si sbloccano solo con storico prima del 2024 (FTMO: Dow dal 2019, indici dal 12/2017; feed rotto).

## Classe C: strumenti, non strategie
AvvisoBulge, TradeExporter, ManagerMediana, Apertura_Study_EA, CLAU12_TESTORARI, Guardian.

## Coda proposta per il passo B (nel sistema nostro, un EA alla volta)
1. **Stadio 0 su A6, A7, A9** (mai misurati fuori campione): una passata di base su 2-3 finestre + costi, soglia PF >= 1,20 con >= 100 operazioni. Solo chi la passa va allo stadio 2.
2. **Stadio 1 (ATR e orari) su A3** come prova del metodo: l'ipotesi del piano e' che le distanze fisse in punti rovinino i PF su 10 anni (O-2: 30%).
3. **A11** dopo la diagnostica dei dati `_EXT`.
4. **A2/A8** non si ottimizzano: servono piu' campione e piu' mercati (forward).
5. **Classe B** sospesa fino a storico lungo.
6. Per ogni sopravvissuto: correlazione con GoldenZoe (soglia 0,5; gli EA oro probabilmente la superano) e scheda prop.

## Aspettativa onesta (dal piano, gia' scritta il 16/11)
"Pochi candidati reali, ma diversi da Wim": 55%; "nessuno": 30%; "molti": 15%. Gran parte della famiglia nostra e' gia' chiusa o ha dati insufficienti; la coda utile e' corta (circa 8-10 EA).
