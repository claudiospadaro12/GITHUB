# REFERTO R23 — per-trade dei 5 candidati fascia B e prova di portafoglio (11/08/2026)

**I 5 candidati della notte passano anche la prova di portafoglio: aggiunti
alle 6 serie storiche portano il netto OOS da +89.690 a +102.933 (+15%)
SENZA muovere la coda di rischio (Monte Carlo p99: 14,79% contro 14,83%).**
Correlazioni tutte fra -0,16 e +0,13. La taratura 0,65% continua a reggere
il p99 sotto il 10% FTMO.

## Controlli d'igiene (tutti superati)
- **Gemelli del magic-sweep**: le 2 celle di ogni round identiche al
  centesimo nei riepiloghi; i file per-trade identici salvo la colonna
  magic (come deve essere).
- **Conteggi vs griglia della notte**: PTE Dow 40 OOS = coda; GBPUSD 20/49
  = coda; USDJPY 33/35 = coda. SuperWave piu' chiusure (88 vs 61 Dow):
  spiegato — a 100k le posizioni si chiudono in TRE TRANCHE parziali
  (88 chiusure da 50 posizioni) che a 10k il lotto minimo impediva.
  PF confermati (Dow 1,76 vs 1,73; GBPUSD 1,84 vs 2,09, differenza da
  granularita' dei parziali).
- **Nota contabile**: sui 3 forex il netto per-trade supera il riepilogo
  del tester di 56-294 EUR (swap/commissioni: gli indici combaciano al
  centesimo). Il per-trade e' il numero veritiero.

## Le 5 serie nuove (OOS ~12,5 mesi, 100k, rischio 1%)

| Serie | Chiusure | Netto | DD singolo |
|---|---|---|---|
| PTE @ Dow H1/BE0,5 (771311) | 40 | +1.092,69 | 2,18% |
| PTE @ GBPUSD H1/BE0,5 (771313) | 49 | +2.385,05 | 2,64% |
| PTE @ USDJPY H1/BE0,5 (771315) | 35 | +1.777,95 | 3,97% |
| SuperWave @ Dow H2 (770521) | 88 | +4.371,06 | 2,96% |
| SuperWave @ GBPUSD H2 (770523) | 63 | +3.615,90 | 1,04% |

## Portafoglio: 6 serie storiche vs 11 (stesse date, 100k, 1%)

| Metrica | 6 serie | 11 serie |
|---|---|---|
| Netto OOS | +89.690 | **+102.933** |
| MAX DD storico | 8,79% | 10,08% |
| Somma DD singoli | 25,09% | 37,89% (beneficio diversif. +27,8 punti) |
| Peggior giornata | -3.843 (-3,84%) | **identica** (i nuovi non la peggiorano) |
| MC p50 / p95 / p99 | 6,82 / 11,60 / 14,83% | 6,66 / **11,68 / 14,79%** |

Lettura: +13.243 di netto in piu' con la distribuzione dei DD
sostanzialmente INVARIATA — e' esattamente cio' che deve fare la
diversificazione. Il DD storico sale (10,08 vs 8,79) ma resta sotto il
p50+ della sua stessa distribuzione MC: una realizzazione, non la coda.
Correlazioni nuove tutte deboli; le piu' utili: PTE Dow vs SuperWave Dow
-0,12 (stesso mercato, motori scorrelati), PTE GBPUSD vs SuperWave GBPUSD
-0,16, SuperWave Dow vs ORB Dow -0,12.

## Avvertenze oneste
1. Le 5 serie sono la SOLA finestra OOS (~12,5 mesi): un campione ciascuna,
   come per le 6 storiche.
2. PTE e SuperWave BASE sono appena stati SPENTI dal VPS (pulizia 10/08)
   perche' bocciati sul simbolo di casa: i candidati sono CELLE NUOVE su
   mercati nuovi con magic vergini — non una riabilitazione dei vecchi
   grafici.
3. La trafila non cambia: prossima tappa VIVAIO (demo piccolo, 30 trade
   forward a rischio ridotto), NON il 100k. Decisione di Claudio quali e
   quanti dei 5 deployare.

_File: riepiloghi in `risultati_prove/ABTG_PTE/` e `ABTG_SuperWave/`
(suffissi _r23a..e); per-trade in `risultati_prove/trades_candidati_r23/`._
