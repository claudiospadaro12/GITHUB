# LETTURA DEI CSV TRASPORTATI - GRUPPO C (CACCE BREAKOUT, 9 FAMIGLIE) - 05/10/2026

> **DOCUMENTO INTERNO. NON ESCE. BOZZA, NON PASSATA DAL CANCELLO.** Sola lettura d'archivio: nessun round lanciato, VPS non toccato, nessun file di altri agenti toccato, nessuna decisione di rischio o di taglia, nessuna soglia modificata.
> **Compito**: leggere i CSV che Claudio ha trasportato il 05/10/2026 (`backtest_pipeline/risultati_prove/dal_vps/<EA>/`, transcript in `backtest_pipeline/risultati_archivio/TRASPORTO_CSV_20261005/`) per le nove famiglie del gruppo C e produrre i numeri veri, **senza nuove interpretazioni di criteri**. Regola di classificazione: `report/RESOCONTO_EA_PIANO_2026-10-05.md` sez. 5. Resoconto del gruppo confrontato: `report/RESOCONTO_EA_G6A_CACCE_BREAKOUT_2026-10-05.md` (qui "G6a").
> **Famiglie**: `ABTG_IntradayMomentum`, `ABTG_VolExpBreak`, `ABTG_Cycle`, `ABTG_DaxValueArea`, `ABTG_OpeningReversalB`, `ABTG_LVNArbitro`, `ABTG_IBRetest`, `ABTG_HVAncora`, `ABTG_AtrExhaustVol`.
> **Precedenza delle fonti** (la stessa di G6a): il CSV batte il referto, il referto batte la prosa. Dove un numero non c'e' nel CSV: **NON LEGGIBILE**.

---

## 0. COME LEGGERE (convenzioni di questo file)

- **Cosa e' un CSV qui**: un OPTFRAME del Strategy Tester, **una riga per passata** (una cella dell'asse). Ogni round ha una coppia di file `IS` / `OOS`. Le colonne sono quelle dell'EA (Profit, Expected Payoff, Profit Factor, Recovery Factor, Sharpe, Equity DD %, Trades, piu' i contatori propri dell'EA e tutti gli `Inp*`).
- 🔴 **I CSV NON portano nessuna data, nessun modello di tick, nessun deposito, nessun TF** (colonne elencate per tutte e 38 le intestazioni: nessuna e' una data o un orario). Quindi: **modello 4 (tick reali) e deposito** sono dichiarati dalle **righe del runner** (`-Modello 4 -Deposito 100000`, `backtest_pipeline/coda/referti/REFERTO_RUNNER_*.txt`, contate: r141a/b/c/d 8 notti, r141e 5, r145a/b 7, r148a/bl/bs 6) e, per i P0 di settembre (IBRetest, LVNArbitro, OpeningReversalB), da G6a/referti `REFERTO_ROUND_*.txt`. Il **TF** e' quello del file prova (`@PERIODO`, letto) o del referto. Le **finestre** sono **DESUNTE**: `@DAQUANDO 2024.09.26`, `@FINOA 2026.06.30`, `@FRAZIONEIS 0,40` (driver) -> **IS 2024.09.26-2025.06.09 (183 feriali), OOS 2025.06.10-2026.06.30 (276 feriali)** `[DESUNTA, non letta nel CSV]`. Dove sotto scrivo "IS/OOS" vale questa convenzione.
- **Rischio per operazione**: `InpRiskPercent` = **0,65** in tutte e 98 le righe (letto nel CSV).
- **n = colonna `Trades`**. Nessun parziale e' attivo: dove esiste l'input vale 0 (`InpTP1Pct` in VolExpBreak, Cycle, AtrExhaustVol; `InpTP1_ClosePct` in DaxValueArea) e negli altri EA non esiste un input di parziale. **Controllo diretto dei conteggi**: Cycle `Trades = Ingressi` in 12 righe su 12; DaxValueArea `Trades = Apri Chiamate` in 8 su 8; HVAncora, IBRetest, LVNArbitro `Trades = Long + Short` in 28 su 28. Conclusione: **deal = posizioni**, e la regola "B richiede celle >= 346 deal" (fattore 2,31 dei motori con parziale) **non si applica**: vale **n >= 150**.
- **Affidabilita'** (piano 5.4): **A impossibile** (21 mesi di tick BCM = un solo regime); **B** n OOS >= 150; **C** 30-149; **D** < 30. La scrivo per la finestra OOS.
- **Classe per cella** (piano 5.1-5.3): riferimento = **PF OOS a tick**. `SOPRA` = PF OOS >= 1,00; **`SOPRA formale`** = 1,00 <= PF < 1,10 (etichetta di G6a, **non e' una soglia**: il piano D2 dice che la soglia di zona grigia non esiste); `SOTTO` = PF < 1,00; `NM` = nessuna operazione in OOS. **`INV`** = SEGNO INVERTITO IS->OOS (le due finestre da parti opposte di 1,00). `n.d.*` = PF stampato 0,000 con profitto positivo (nessuna perdita: il tester stampa 0, il rapporto e' indefinito).
- **Ricalcolo**: tutti i numeri delle tabelle sono estratti dai CSV con codice mio (lettura diretta delle colonne, nessun numero copiato dai referti). Gli script **non sono in repo** (richiesto un solo file): le formule usate sono scritte nei punti dove servono. Controlli di integrita' fatti su tutte le 98 righe: `Expected Payoff x Trades = Profit` entro 0,02 su 98 su 98; nessun `Pass` duplicato; **per ogni coppia IS/OOS gli `Inp*` sono identici** (19 coppie su 19: stessa build e stessa configurazione nelle due finestre).

---

## 1. SINTESI

**Letti: 38 CSV (9 cartelle), 98 righe-passata, 19 etichette di round. Nessun CSV vuoto** (22 righe di `OpeningReversalB` hanno `Trades = 0` in OOS: sono CSV pieni di passate a zero operazioni, dichiarate in sez. 4.5).

Trasporto (dal transcript): **12 NUOVI** (VolExpBreak 4, Cycle 6, DaxValueArea 2), **2 AGGIORNATI** (`IntradayMomentum_NASUSD_OOS_r141a`, `HVAncora_U30USD_IS_r141d`: `git diff` contro la versione del 13/09 = **stesse cifre, cambia solo l'ordine delle righe**; il runner ha rigirato lo stesso round nelle notti successive e ha dato lo stesso risultato), **24 IDENTICI** gia' in repo.

**I sei round che G6a dichiarava "girati ma senza CSV" ora sono letti**: `R141e` (8 righe), `R145a` (8), `R145b` (8), `R148a` (4), `R148bL` (4), `R148bS` (4) = **36 righe**.

### Le tre cose piu' importanti

1. **`DaxValueArea` (R141e): 8 celle su 8 con PF < 1** (IS 0,773-0,823; OOS 0,755-0,974) su **n 211-407** (>= 150, affidabilita' B) e **DD 10,8-38,8% (8 su 8 oltre il 10%)**. Il "morto" del 09/09 era un argomento senza numero (G6a 3.1): **ora ha un numero a favore**. La "legge dell'ancora unica" scritta nel file prova **non e' falsificata** (esito (a) escluso: l'eccesso sul PF nullo e' <= 0 in 4 celle IS su 4). **Ma il certificato di morte resta incompleto** (2/5: mancano gemelli e TF, uscita parziale): verdetto proposto **SOTTO 1, NON ANCORA MISURATO come morto**.
2. **`Cycle` (R148a/bL/bS): tutte le celle SOTTO 1, in IS e in OOS, su n 630-2072** (PF 0,761-0,981, DD 17,1-55,1%, **E per operazione negativa in 8 celle-finestra su 8**). Le sentinelle del file prova S1, S3, S4, S5 **passano**; S2 passa a meta' (somma esatta, ma `|L-S| = 6` in IS contro il limite 1). Nessuna delle uscite (A)-(E) scritte nel file scatta alla lettera in entrambe le finestre: R148a e' a **0,0023 R fuori dalla banda** di (b) in OOS.
3. **`VolExpBreak` (R145a/b): il cancello (pre) "Segnali Grezzi differisce > 10% fra kStop 1,0 e 2,5" scatta in 4 finestre su 4** (11,3-27,6%): per la regola congelata nel file prova **il confronto lungo l'asse NON SI LEGGE -> NON ANCORA MISURATO**. Il dato per cella dice altro e va scritto: **NASUSD 4 celle su 4 con segno INVERTITO IS->OOS (IS 1,22-1,32 -> OOS 0,76-0,96)**, **nel verso opposto a `IntradayMomentum`**; **U30USD kStop 2,5 e' l'unica cella SOPRA 1 su 8 in OOS** (1,042, n 111, **DD 12,2%**), affidabilita' C.

E poi: **0 differenze referto/CSV** sui 31 confronti di cella con i numeri di G6a (R141a/b/c/d, P0 IBRetest/LVN/OpeningReversalB); **l'ipotesi dell'orologio invernale e' NON VERIFICABILE** (nessun CSV ha una data per operazione); il conteggio di G6a cambia (sez. 5.d).

---

## 2. TABELLA PER ROUND (19 etichette)

`Trasp.` = esito del trasporto del 05/10. `G6a dichiarava` = cosa scriveva G6a (sez. 1.2 / 3-bis). `Dicono i CSV` = cosa leggo adesso.

| # | round | EA - simbolo TF | asse (valori) | file / righe | trasp. | G6a dichiarava | dicono i CSV |
|--:|---|---|---|---|---|---|---|
| 1 | r141a | IntradayMomentum - NASUSD M30 | `InpUseSecondSignal` 0/1 | 2 / 4 | IS id., OOS agg. | IS 0,609 n146 / OOS 1,243 n261; 2o segnale 0,463 n71 / 1,486 n133 | **identico** (4 confronti, 0 diff); INV 2 celle su 2 |
| 2 | r141b | IntradayMomentum - U30USD M30 | `InpUseSecondSignal` 0/1 | 2 / 4 | id. | 0,599 n146 / 1,035 n261; 0,461 n76 / 1,250 n130 | **identico** (4 confronti); INV 2 su 2 |
| 3 | r141c | AtrExhaustVol - NASUSD M30 | `InpProxMode` 0/1 | 2 / 4 | id. | PERC 0,711 n153 / 0,952 n224; ATR 0,972 n70 / 1,229 n96 | **identico** (4 confronti); INV sulla cella ATR |
| 4 | r141d | HVAncora - U30USD M30 | `InpStopAtr` 1,0/1,5/2,0/2,5 | 2 / 8 | IS agg., OOS id. | k1,0 1,385 n22 / 1,921 n31 ... k2,5 1,361 / 0,930 | **identico** (8 confronti); INV solo k2,5 |
| 5 | **r141e** | **DaxValueArea - D30EUR M15** | `InpSlBufferPts` 800/2800/4800/6800 | 2 / 8 | **NUOVO** | "GIRATO 16-20/09, CSV non in repo: NON MISURATO" | **8/8 celle SOTTO**, PF 0,755-0,974, n 211-407, DD 10,8-38,8% (sez. 4.4) |
| 6 | **r145a** | **VolExpBreak - NASUSD M30** | `InpKStop` 1,0/1,5/2,0/2,5 | 2 / 8 | **NUOVO** | "GIRATO, CSV non in repo" | IS PF 1,22-1,32 -> OOS 0,76-0,96 (**4/4 INV**); n 71-124; gate (pre) scattato |
| 7 | **r145b** | **VolExpBreak - U30USD M30** | `InpKStop` 1,0/1,5/2,0/2,5 | 2 / 8 | **NUOVO** | "GIRATO, CSV non in repo" | IS 0,956-1,123 -> OOS 0,776-1,042; **k2,5 unica cella SOPRA in OOS**; gate (pre) scattato |
| 8 | **r148a** | **Cycle - NASUSD M30** | `InpVerso` 0/1 | 2 / 4 | **NUOVO** | "GIRATO 15-20/09, CSV non in repo" | 4/4 celle-finestra SOTTO, n 1263-2072 |
| 9 | **r148bl** | **Cycle - NASUSD M30** | `InpAllowShort` 0/1 (cella di merito: LONG-only) | 2 / 4 | **NUOVO** | idem | LONG-only IS 0,981 n630 / OOS 0,953 n1036; la cella (1,1) coincide con r148a verso 0 (S5) |
| 10 | **r148bs** | **Cycle - NASUSD M30** | `InpAllowLong` 0/1 (cella di merito: SHORT-only) | 2 / 4 | **NUOVO** | idem | SHORT-only IS 0,957 n636 / OOS **0,761** n1036 DD **48,6%** |
| 11 | P0_IBRETEST | IBRetest - U30USD M30 | `InpMagic` (gemelle, non asse) | 2 / 4 | id. | 0,382 n42 / 0,697 n53 | **identico** (2 confronti) |
| 12 | P0IBRTNAS | IBRetest - NASUSD M30 | idem | 2 / 4 | id. | 0,563 n35 / 0,593 n49 | **identico** (2) |
| 13 | P0IBRTDAX | IBRetest - D30EUR M30 | idem | 2 / 4 | id. | 1,211 n58 / 0,965 n107 | **identico** (2); INV |
| 14 | P0CONTA | LVNArbitro - U30USD M30 (10k) | `InpMagic` | 2 / 4 | id. | 0,979 n392 / 1,051 n618 | **identico** (2); INV |
| 15 | P0_100K | LVNArbitro - U30USD M30 (100k) | `InpMagic` | 2 / 4 | id. | 0,975 / 1,052 | **identico** (2); INV |
| 16 | P0CONTA | OpeningReversalB - U30USD M5 | `InpMagic` | 2 / 4 | id. | IS PF 1,826 n2 / OOS n0 | **identico** (1 confronto cella) |
| 17 | P0A_FAIL | OpeningReversalB - U30USD M5 | `InpFailScoreMin` 1/2/3 | 2 / 6 | id. | idem, OOS n0 | IS 3 celle PF 1,826 n2; OOS 3 celle n0 |
| 18 | P0B_SIGNAL | OpeningReversalB - U30USD M5 | `InpSignalScoreMin` 2/3/4 | 2 / 6 | id. | idem | IS n1 (PF n.d.*) / n2 / n2; OOS n0 |
| 19 | P0C_FT | OpeningReversalB - U30USD M5 | `InpFollowThroughPct` 40/50/60 | 2 / 6 | id. | idem | IS n2 (1,753) / **n3 (3,562)** / n2 (1,826); OOS n0 |

Totale righe: 4+4+4+8+8+8+8+4+4+4+4+4+4+4+4+4+6+6+6 = **98**.

---

## 3. TABELLA PER CELLA (43 righe: IS e OOS a fianco)

Le coppie di celle gemelle per `InpMagic` (IBRetest, LVNArbitro, OpeningReversalB `P0CONTA`) sono **identiche al centesimo** (verificato con codice: Profit, Trades, PF, DD) e le scrivo una volta. Le due celle `(1,1)` di R148bL e R148bS sono righe duplicate di R148a verso 0 (le tengo, marcate, per la sentinella S5). Profitti nella valuta del conto di prova (deposito 100.000, tranne P0 IBRetest / OpeningReversalB / LVN P0CONTA a 10.000).

| round | EA | simbolo TF | cella | IS PF | IS n | IS DD% | IS profitto | OOS PF | OOS n | OOS DD% | OOS profitto | classe OOS | aff. | INV |
|---|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---|---|---|
| R141A | IntradayMomentum | NASUSD M30 | L+S, 2o segnale spento | 0,609 | 146 | 7,76 | -6.446,05 | 1,243 | 261 | 3,03 | 4.264,01 | SOPRA | B | INV |
| R141A | IntradayMomentum | NASUSD M30 | L+S, 2o segnale acceso | 0,463 | 71 | 5,65 | -5.064,65 | 1,486 | 133 | 1,37 | 3.562,10 | SOPRA | C | INV |
| R141B | IntradayMomentum | U30USD M30 | L+S, 2o segnale spento | 0,599 | 146 | 6,42 | -5.942,61 | 1,035 | 261 | 4,41 | 660,66 | SOPRA formale | B | INV |
| R141B | IntradayMomentum | U30USD M30 | L+S, 2o segnale acceso | 0,461 | 76 | 5,36 | -4.558,11 | 1,250 | 130 | 1,79 | 2.283,16 | SOPRA | C | INV |
| R145A | VolExpBreak | NASUSD M30 | InpKStop 1,0 | 1,244 | 98 | 6,87 | 10.227,08 | 0,852 | 124 | 18,37 | -7.721,43 | SOTTO | C | INV |
| R145A | VolExpBreak | NASUSD M30 | InpKStop 1,5 | 1,223 | 91 | 5,86 | 8.675,72 | 0,965 | 121 | 8,60 | -1.838,98 | SOTTO | C | INV |
| R145A | VolExpBreak | NASUSD M30 | InpKStop 2,0 | 1,288 | 85 | 5,59 | 10.528,80 | 0,925 | 117 | 10,72 | -3.828,45 | SOTTO | C | INV |
| R145A | VolExpBreak | NASUSD M30 | InpKStop 2,5 | 1,324 | 71 | 5,59 | 9.828,35 | 0,761 | 110 | 14,33 | -11.413,44 | SOTTO | C | INV |
| R145B | VolExpBreak | U30USD M30 | InpKStop 1,0 | 0,956 | 97 | 7,62 | -1.881,69 | 0,776 | 124 | 16,99 | -12.316,94 | SOTTO | C |  |
| R145B | VolExpBreak | U30USD M30 | InpKStop 1,5 | 0,998 | 92 | 8,50 | -88,29 | 0,870 | 124 | 11,91 | -7.163,59 | SOTTO | C |  |
| R145B | VolExpBreak | U30USD M30 | InpKStop 2,0 | 1,047 | 84 | 7,94 | 1.735,65 | 0,934 | 118 | 10,49 | -3.437,18 | SOTTO | C | INV |
| R145B | VolExpBreak | U30USD M30 | InpKStop 2,5 | 1,123 | 78 | 5,24 | 4.176,94 | 1,042 | 111 | 12,22 | 2.029,56 | SOPRA formale | C |  |
| R148A | Cycle | NASUSD M30 | InpVerso 0 (CON, lato L+S) | 0,969 | 1266 | 21,60 | -8.518,27 | 0,849 | 2072 | 55,06 | -50.530,24 | SOTTO | B |  |
| R148A | Cycle | NASUSD M30 | InpVerso 1 (CONTRO, lato L+S) | 0,897 | 1263 | 30,43 | -23.946,08 | 0,903 | 2072 | 38,81 | -33.139,66 | SOTTO | B |  |
| R148BL | Cycle | NASUSD M30 | LONG-only (AllowShort 0) | 0,981 | 630 | 17,64 | -2.524,39 | 0,953 | 1036 | 19,85 | -9.578,69 | SOTTO | B |  |
| R148BL | Cycle | NASUSD M30 | (1,1) = R148A verso 0 (sentinella S5) | 0,969 | 1266 | 21,60 | -8.518,27 | 0,849 | 2072 | 55,06 | -50.530,24 | SOTTO | B |  |
| R148BS | Cycle | NASUSD M30 | SHORT-only (AllowLong 0) | 0,957 | 636 | 17,15 | -6.193,28 | 0,761 | 1036 | 48,59 | -45.391,12 | SOTTO | B |  |
| R148BS | Cycle | NASUSD M30 | (1,1) = R148A verso 0 (sentinella S5) | 0,969 | 1266 | 21,60 | -8.518,27 | 0,849 | 2072 | 55,06 | -50.530,24 | SOTTO | B |  |
| R141E | DaxValueArea | D30EUR M15 | InpSlBufferPts 800 | 0,773 | 251 | 23,09 | -20.594,69 | 0,755 | 407 | 38,78 | -31.988,10 | SOTTO | B |  |
| R141E | DaxValueArea | D30EUR M15 | InpSlBufferPts 2800 | 0,778 | 232 | 17,22 | -14.982,01 | 0,974 | 379 | 12,40 | -2.854,25 | SOTTO | B |  |
| R141E | DaxValueArea | D30EUR M15 | InpSlBufferPts 4800 | 0,823 | 219 | 12,31 | -9.699,14 | 0,924 | 361 | 13,02 | -6.312,22 | SOTTO | B |  |
| R141E | DaxValueArea | D30EUR M15 | InpSlBufferPts 6800 | 0,803 | 211 | 10,82 | -9.063,18 | 0,913 | 350 | 11,82 | -6.199,46 | SOTTO | B |  |
| P0CONTA | OpeningReversalB | U30USD M5 | cella nuda (2 gemelle per magic, identiche) | 1,826 | 2 | 0,96 | 57,28 | n.d. | 0 | 0,00 | 0,00 | NM | - |  |
| P0A_FAIL | OpeningReversalB | U30USD M5 | FailScoreMin 1 | 1,826 | 2 | 0,96 | 57,28 | n.d. | 0 | 0,00 | 0,00 | NM | - |  |
| P0A_FAIL | OpeningReversalB | U30USD M5 | FailScoreMin 2 | 1,826 | 2 | 0,96 | 57,28 | n.d. | 0 | 0,00 | 0,00 | NM | - |  |
| P0A_FAIL | OpeningReversalB | U30USD M5 | FailScoreMin 3 | 1,826 | 2 | 0,96 | 57,28 | n.d. | 0 | 0,00 | 0,00 | NM | - |  |
| P0B_SIGNAL | OpeningReversalB | U30USD M5 | SignalScoreMin 2 | n.d.* | 1 | 0,04 | 126,61 | n.d. | 0 | 0,00 | 0,00 | NM | - |  |
| P0B_SIGNAL | OpeningReversalB | U30USD M5 | SignalScoreMin 3 | 1,826 | 2 | 0,96 | 57,28 | n.d. | 0 | 0,00 | 0,00 | NM | - |  |
| P0B_SIGNAL | OpeningReversalB | U30USD M5 | SignalScoreMin 4 | 1,826 | 2 | 0,96 | 57,28 | n.d. | 0 | 0,00 | 0,00 | NM | - |  |
| P0C_FT | OpeningReversalB | U30USD M5 | FollowThroughPct 40 | 1,753 | 2 | 0,93 | 53,68 | n.d. | 0 | 0,00 | 0,00 | NM | - |  |
| P0C_FT | OpeningReversalB | U30USD M5 | FollowThroughPct 50 | 3,562 | 3 | 0,96 | 180,98 | n.d. | 0 | 0,00 | 0,00 | NM | - |  |
| P0C_FT | OpeningReversalB | U30USD M5 | FollowThroughPct 60 | 1,826 | 2 | 0,96 | 57,28 | n.d. | 0 | 0,00 | 0,00 | NM | - |  |
| P0CONTA | LVNArbitro | U30USD M30 | deposito 10k (2 gemelle per magic, identiche) | 0,979 | 392 | 18,01 | -264,58 | 1,051 | 618 | 11,33 | 1.022,05 | SOPRA formale | B | INV |
| P0_100K | LVNArbitro | U30USD M30 | deposito 100k (2 gemelle per magic, identiche) | 0,975 | 392 | 19,35 | -3.374,90 | 1,052 | 618 | 11,76 | 11.310,73 | SOPRA formale | B | INV |
| P0_IBRETEST | IBRetest | U30USD M30 | cella nuda (2 gemelle per magic, identiche) | 0,382 | 42 | 7,38 | -723,09 | 0,697 | 53 | 7,61 | -364,88 | SOTTO | C |  |
| P0IBRTNAS | IBRetest | NASUSD M30 | cella nuda (2 gemelle per magic, identiche) | 0,563 | 35 | 5,80 | -441,72 | 0,593 | 49 | 5,31 | -419,15 | SOTTO | C |  |
| P0IBRTDAX | IBRetest | D30EUR M30 | cella nuda (2 gemelle per magic, identiche) | 1,211 | 58 | 2,80 | 260,68 | 0,965 | 107 | 5,25 | -83,97 | SOTTO | C | INV |
| R141D | HVAncora | U30USD M30 | InpStopAtr 1,0 | 1,385 | 22 | 3,42 | 2.902,72 | 1,921 | 31 | 2,06 | 6.309,34 | SOPRA | C |  |
| R141D | HVAncora | U30USD M30 | InpStopAtr 1,5 | 1,783 | 25 | 2,45 | 4.801,66 | 1,038 | 35 | 3,84 | 318,49 | SOPRA formale | C |  |
| R141D | HVAncora | U30USD M30 | InpStopAtr 2,0 | 1,619 | 26 | 2,15 | 3.495,03 | 1,333 | 36 | 2,79 | 2.177,66 | SOPRA | C |  |
| R141D | HVAncora | U30USD M30 | InpStopAtr 2,5 | 1,361 | 26 | 2,24 | 2.097,73 | 0,930 | 37 | 3,12 | -454,05 | SOTTO | C | INV |
| R141C | AtrExhaustVol | NASUSD M30 | InpProxMode 0 (PERC, autore) | 0,711 | 153 | 19,25 | -18.421,10 | 0,952 | 224 | 13,45 | -4.277,39 | SOTTO | B |  |
| R141C | AtrExhaustVol | NASUSD M30 | InpProxMode 1 (ATR) | 0,972 | 70 | 5,69 | -793,59 | 1,229 | 96 | 4,14 | 8.460,56 | SOPRA | C | INV |

Lettura veloce (classe 1127, **entrambi i versi**): su 43 righe (2 sono duplicati di R148a verso 0, 2 sono la stessa cella LVN a due depositi), **OOS SOPRA 11 (5 delle quali "formale", PF < 1,10), OOS SOTTO 22, OOS NM 10**; **righe INV: 14 = 13 celle** (LVN conta due volte per i due depositi): **6 celle con IS < 1 -> OOS >= 1** (IntradayMomentum 4, LVNArbitro 1, AtrExhaustVol-ATR 1) e **7 con IS >= 1 -> OOS < 1** (VolExpBreak 5, IBRetest-D30EUR 1, HVAncora k2,5 1). Le due direzioni **coesistono**: l'inversione IS/OOS non e' un fenomeno a senso unico (vedi sez. 6).


---

## 4. SCHEDE BREVI PER EA (9)

Per ogni EA: round letti, numeri chiave, classe, affidabilita', cosa dicono i CSV rispetto a G6a. **Rischio**: dove cito il DD uso le **soglie congelate scritte nei file prova** (R145a, R141e, R148a: "DD > 10% in una finestra a rischio 0,65%" = cella di RISCHIO; "Peggior Giornata % < -4,0%" = cella di RISCHIO), **applicate come scritte, non decise da me**. Il DD del tester e' a tick reali ma **senza Guardian** (fail-open nel tester) e a **un solo regime**.

### 4.1 `ABTG_IntradayMomentum` - R141a, R141b (4 file, 8 righe) - NASUSD e U30USD M30

- **Numeri** (CSV, 100k, 0,65%, IS/OOS desunte): NASUSD L+S **IS 0,609 n146 DD 7,76 (-6.446,05) -> OOS 1,243 n261 DD 3,03 (+4.264,01)**; 2o segnale **0,463 n71 DD 5,65 -> 1,486 n133 DD 1,37**. U30USD L+S **0,599 n146 DD 6,42 -> 1,035 n261 DD 4,41 (+660,66)**; 2o segnale **0,461 n76 DD 5,36 -> 1,250 n130 DD 1,79**.
- **Classe**: OOS **SOPRA 4/4** (U30USD L+S "formale" 1,035); IS **SOTTO 4/4** (0,461-0,609). **INV 4 celle su 4, tutte IS<1 -> OOS>=1.** Affidabilita' OOS **B** (n 261) per L+S, **C** (130-133) per il 2o segnale; n IS 146 = **quattro sotto 150**.
- **Dicono i CSV vs G6a**: **identico** (8 confronti di cella, 0 diff). Il CSV conferma anche che n OOS e' **261 identico** su NASUSD e U30USD L+S.
- **Verdetto proposto**: invariato (**NON ANCORA MISURATO**, G6a 4.11). Le celle **SOTTO** che G6a cita per questo EA (R98 `a`, solo SHORT, R235 short) **non sono in questi CSV**: restano `[DICHIARATO]` dai referti.
- Colonna `Peggior Giornata %`: **assente** in questi CSV (NON LEGGIBILE).

### 4.2 `ABTG_VolExpBreak` - R145a (NASUSD), R145b (U30USD) - M30 (4 file, 16 righe) - **LETTO PER LA PRIMA VOLTA**

Asse unico `InpKStop` 1,0/1,5/2,0/2,5; pin letti nel CSV e **coerenti col file prova**: `InpMinSLPts 0`, `InpTP_RR 2`, `InpTP1Pct 0`, `InpBreakeven 0`, `InpMaxSpreadPctOfStop 20`, `InpMaxTradesPerDay 3`, `InpUseHourFilter 0`, `InpUsaGuardian 0`, `InpKBreak 1,5`, `InpLookback 20`, filtri EMA/RSI spenti. **Tutte e 16 le righe hanno n > 0** (71-124): "uscita 0" del runner = round girato con operazioni, confermato.

| simbolo | finestra | kStop 1,0 | 1,5 | 2,0 | 2,5 |
|---|---|---|---|---|---|
| NASUSD | IS PF / n / DD% | 1,244 / 98 / 6,87 | 1,223 / 91 / 5,86 | 1,288 / 85 / 5,59 | 1,324 / 71 / 5,59 |
| NASUSD | OOS PF / n / DD% | 0,852 / 124 / 18,37 | 0,965 / 121 / 8,60 | 0,925 / 117 / 10,72 | 0,761 / 110 / 14,33 |
| U30USD | IS PF / n / DD% | 0,956 / 97 / 7,62 | 0,998 / 92 / 8,50 | 1,047 / 84 / 7,94 | 1,123 / 78 / 5,24 |
| U30USD | OOS PF / n / DD% | 0,776 / 124 / 16,99 | 0,870 / 124 / 11,91 | 0,934 / 118 / 10,49 | 1,042 / 111 / 12,22 |

- **Lettura col protocollo scritto nel file prova** (`R145a`, blocco "ATTESA DICHIARATA PRIMA DEI NUMERI" e "IL CANCELLO CHE VIENE PRIMA"; `R145b` idem): (1) **E in R = Expected Payoff / 650** (n piccolo: la formula ln di Cycle da' lo stesso segno in 16 su 16 righe); (2) **cancello (pre) PRIMA di tutto**: se `Segnali Grezzi` differisce > 10% fra la cella 1,0 e la cella 2,5, "il confronto fra quelle due celle NON si legge: NON ANCORA MISURATO".

| | Segnali Grezzi 1,0 / 1,5 / 2,0 / 2,5 | scarto (1,0 vs 2,5, base cella 1,0) | gate (pre) | E in R (EP/650) 1,0 / 1,5 / 2,0 / 2,5 | E(2,5) - E(1,0) |
|---|---|---:|---|---|---:|
| NASUSD IS | 98 / 92 / 85 / 71 | **27,6%** | **scatta** | +0,161 / +0,147 / +0,191 / +0,213 | +0,052 |
| NASUSD OOS | 124 / 121 / 117 / 110 | **11,3%** | **scatta** | -0,096 / -0,023 / -0,050 / -0,160 | -0,064 |
| U30USD IS | 98 / 93 / 85 / 79 | **19,4%** | **scatta** | -0,030 / -0,001 / +0,032 / +0,082 | +0,112 |
| U30USD OOS | 126 / 124 / 118 / 111 | **11,9%** | **scatta** | -0,153 / -0,089 / -0,045 / +0,028 | +0,181 |

  Con la base cella 2,5 gli scarti sono 38,0 / 12,7 / 24,1 / 13,5%: **scatta in 4 finestre su 4 con qualunque base**. Verdetto del protocollo: **NON ANCORA MISURATO** per la domanda dell'asse. Per completezza **riporto anche** cosa direbbe l'asse se il cancello non esistesse (non e' una lettura valida): l'attesa dichiarata per il solo spread e' **0,024 R**, la soglia di "diluito" **oltre 0,08 R**; U30USD sale **+0,112 (IS) e +0,181 (OOS)** monotona in entrambe le finestre; NASUSD **+0,052 (IS) e -0,064 (OOS)**, non monotona e con segno opposto. **L'occupazione del posto, che il gate misura, e' esattamente il confondente dichiarato nel file prova (punto 8).**
- **Sentinelle del file prova** (le colonne ci sono): `Pavimento SL Morso` **0 in 16/16**; `Lotto Alzato 228` **0 in 16/16**; `Lotto Tagliato 5pct` 0-2; `Spread Gate Rifiuti` **0 in 15/16** (2 in U30USD OOS kStop 1,0); `Guardian Rifiuti` 0.
- **Classe**: ENTRAMBE (classe 1127: 7 SOTTO e 1 SOPRA in OOS). **SOPRA formale: una sola cella, U30USD kStop 2,5, OOS 1,042 n111 DD 12,22%, IS 1,123 n78**: la sola cella sopra 1 in entrambe le finestre (nessuna INV); affidabilita' C; **MERITO SOSPESO** (n < 150 in ogni cella). NASUSD: **4/4 INV** (IS 1,22-1,32, OOS 0,76-0,96); U30USD kStop 2,0 INV (1,047 -> 0,934).
- **Rischio (soglie del file)**: DD IS 5,2-8,5% (nessuna oltre il 10%); **DD OOS oltre il 10% in 7 celle su 8** (solo NASUSD kStop 1,5: 8,60); Peggior Giornata -1,28/-1,88% (mai sotto -4,0).
- **Frequenza** [DERIVATO su 183/276 feriali]: IS 0,39-0,54 op/giorno, OOS 0,40-0,45, per simbolo.
- **Aggregato NASUSD+U30USD** (informativo, **non e' una cella**, classe G6a-6): n IS 149-195, OOS 221-248; PF aggregato (ricavato da PF e profitto) IS 1,099 / 1,109 / 1,167 / 1,218 -> OOS 0,813 / 0,916 / 0,930 / 0,902: **l'inversione IS->OOS resta sull'aggregato in 4 kStop su 4**.
- **Certificato**: sez. 5.c.

### 4.3 `ABTG_Cycle` - R148a, R148bL, R148bS - NASUSD M30 (6 file, 12 righe) - **LETTO PER LA PRIMA VOLTA**

Pin letti nel CSV: stop 2,0 x ATR(14), `InpTP_RR 0` (nessun TP), `InpEsciSuCrossOpposto 1`, `InpEsciDopoNBarre 0`, parziale e BE spenti, `InpMaxTradesPerDay 0` (nessun tetto), filtro orario spento, `InpUsaGuardian 1` (nel tester fail-open: `Guardian Rifiuti` 0 in 12/12), `InpMaxSpreadPctOfStop 20`. **Un solo valore per tutto cio' che non e' l'asse**: l'unica cosa che varia sono `InpVerso`, `InpAllowLong`, `InpAllowShort`. Deposito 100k, 0,65%.

| cella | IS PF / n / DD% / profitto | OOS PF / n / DD% / profitto | E in R IS / OOS (formula ln) | Peggior Giornata % IS / OOS |
|---|---|---|---|---|
| verso 0, L+S (= (1,1)) | 0,969 / 1266 / 21,60 / -8.518,27 | 0,849 / 2072 / 55,06 / -50.530,24 | -0,0108 / -0,0523 | -3,83 / **-4,11** |
| verso 1, L+S | 0,897 / 1263 / 30,43 / -23.946,08 | 0,903 / 2072 / 38,81 / -33.139,66 | -0,0333 / -0,0299 | -3,60 / -2,79 |
| LONG-only | 0,981 / 630 / 17,64 / -2.524,39 | 0,953 / 1036 / 19,85 / -9.578,69 | -0,0062 / -0,0150 | -2,57 / -2,47 |
| SHORT-only | 0,957 / 636 / 17,15 / -6.193,28 | **0,761** / 1036 / **48,59** / -45.391,12 | -0,0155 / -0,0898 | -2,79 / -2,73 |

Formula di lettura **quella scritta nel file prova**: `E in R = ln(1 + Profit/Deposito) / (0,0065 x Trades)`, **verificata da me contro il caso costruito a mano del file** (Profit +6.715,90 -> 10,0000 R; -27.747,26 -> -50,0000 R) prima di usarla. Controllo `Expected Payoff / 650`: **stesso segno in 28 righe su 28** (VolExpBreak e Cycle).

- **Sentinelle** (scritte nel file prova R148a / R148bL):
  - **S1** `Incroci Visti` identico: **1300 in tutte le 6 righe IS, 2072 in tutte le 6 OOS** -> **passa**.
  - **S2** additivita' ingressi: IS `630 + 636 = 1266` = (1,1) **esatto**, OOS `1036 + 1036 = 2072` = (1,1) **esatto**; la seconda condizione `|L - S| <= 1 + rifiuti` e' **0 in OOS (passa)** e **6 in IS (NON passa, rifiuti 0)**. In piu' in IS gli ingressi sono **1266 contro 1300 incroci** (34 non entrati, 2,6%), in OOS 2072 = 2072. Causa **NON LEGGIBILE** (il file stesso dice che i salti per ATR o lotto nullo non hanno colonna e "si cercano nel Giornale", non in repo). La premessa "il posto e' libero a ogni incrocio" (308-3) **regge** (la somma e' esatta; un 88-contro-64 non c'e').
  - **S3** barre tenute: IS `3535 + 3493 = 7028`, OOS `5853 + 5474 = 11327` = (1,1) **esatto** -> **passa**.
  - **S4** `|R(1,1) - R(L) - R(S)| / Trades(1,1)`: **0,00006 R (IS), 0,00014 R (OOS)** contro il limite 0,01 -> **passa**.
  - **S5** la cella (1,1) di bL e bS **riproduce R148a verso 0 su 7 colonne** (Profit, Trades, PF, DD, Incroci Visti, Ingressi, Barre Tenute) in entrambe le finestre. Come dice il file, vale **come allarme, non come prova di determinismo** (possibile cache dell'ottimizzazione).
  - `Pavimento SL Morso` 0 e `Spread Gate Rifiuti` 0 in 12/12; `Lotto Alzato 228` 0 in 12/12; `Lotto Tagliato 5pct` 1-18. Il file (nota 308-1) prevede che `Lotto Alzato 228` e `Lotto Tagliato 5pct` siano "~uguali nelle due celle" dell'asse `InpVerso` e dice che se una cella ne ha "molte piu' dell'altra, questa nota e' sbagliata": **verso 0 contro verso 1 = 7 contro 9 in IS, 18 contro 9 in OOS** (0,87% contro 0,43% delle operazioni). `Lotto Alzato 228` e' 0 ovunque. **Lo segnalo come possibile errore della nota 308-1 in OOS** (ampiezza piccola; non cambia il segno di nessuna cella).
- **Uscite scritte nel file prova, lette sui numeri**:
  - **R148a** (a) C'E' SEGNALE (una cella >= +0,03 R in entrambe le finestre): **no**. (c) entrambe positive: **no**. (d) segni discordi IS/OOS: **no** (4 celle-finestra su 4 negative). (b) NIENTE SEGNALE ("tutte e due le celle nella banda [-0,05 ; 0,00]"): **3 celle-finestra su 4 dentro; verso 0 in OOS = -0,0523, fuori di 0,0023**. Quindi **nessuna uscita scatta alla lettera**; la piu' vicina e' (b).
  - **R148bL/bS** (coppia, IS e OOS): `E_nondir = (R_L + R_S)/(n_L + n_S)` = **-0,0109 (IS) / -0,0524 (OOS)**; `E_beta = (R_L - R_S)/(n_L + n_S)` = **+0,0047 (IS) / +0,0374 (OOS)**; lato LONG -0,0062 / -0,0150, lato SHORT -0,0155 / -0,0898. (A) abilita' (>= +0,03 in entrambe): **no**. (B) solo beta (lati di segno OPPOSTO): **no, i due lati sono negativi in entrambe le finestre**. (C) asimmetria inversa (short sopra long): **no** (long > short in 2 finestre su 2). (D) tutti e due sotto il pedaggio (`E_nondir <= -0,02`): **OOS si', IS no** (-0,0109). (E) segni discordi IS/OOS: **no**. **Nessuna uscita scatta alla lettera in tutte e due le finestre**; l'OOS e' compatibile con (D), l'IS cade fra (B) e (D). Il file dice che (B) e (D) hanno **lo stesso verdetto sul certificato** (non ancora misurato + cosa manca).
- **Attese del file prova confrontate col CSV**: incroci attesi IS ~960-1.500 / OOS ~1.440-2.265 -> **osservati 1300 / 2072 (dentro)**; ingressi/giorno attesi 5,2-8,2 -> **6,9 (IS) / 7,5 (OOS)** su 183/276 feriali (dentro); durata attesa 5,6-8,8 barre -> **osservata (Barre Tenute / Ingressi) 5,55 IS / 5,47 OOS per verso 0 (appena sotto la banda), 4,33 / 4,28 per verso 1 (sotto)**.
- **Classe**: **SOTTO in 8 celle-finestra su 8** (IS e OOS, 4 celle distinte), **nessuna cella SOPRA**, nessuna INV. Affidabilita' **B** (n 630-2072, un regime). **Rischio**: DD **17,1-55,1% (8 su 8 oltre il 10%)**; Peggior Giornata OOS verso 0 **-4,11%** (sotto il -4,0 del file) con **tetto giornaliero spento per scelta di misura** (Max Ingressi Giorno 13-14).
- **Certificato**: sez. 5.c.

### 4.4 `ABTG_DaxValueArea` - R141e - D30EUR M15 (2 file, 8 righe) - **LETTO PER LA PRIMA VOLTA**

Asse `InpSlBufferPts` 800/2800/4800/6800 (punti MT5, 100 punti = 1 punto indice); pin letti: `InpVaPercent 70`, `InpVaBinPts 5`, `InpUseBalance 1`, `InpUseDirezion 1`, `InpAcceptBars 2`, `InpSessionHour 8`, `InpCloseHour 16`, `InpCloseMin 30` (ore server), `InpMinStopPts 500`, `InpTP1_ClosePct 0`, `InpBreakevenAfterTP1 1`, `InpMaxTradesPerDay 2`, `InpSide 2`, `InpUsaGuardian 0`; 100k, 0,65%; `Autotest Falliti` 0; `Ret Spread` 0.

| buffer | IS PF / n / DD% / PeggG% | OOS PF / n / DD% / PeggG% | PF nullo (file) | eccesso IS / OOS | n vs cella 800 (IS / OOS) | Balance / Direz Cand (IS; OOS) |
|---:|---|---|---:|---|---|---|
| 800 | 0,773 / 251 / 23,09 / -4,37 | 0,755 / 407 / 38,78 / **-4,86** | 0,79 | -0,017 / -0,035 | - | 86 / 165; 136 / 271 |
| 2800 | 0,778 / 232 / 17,22 / -2,88 | 0,974 / 379 / 12,40 / -1,43 | 0,90 | -0,122 / +0,074 | -7,6% / -6,9% | 72 / 160; 122 / 257 |
| 4800 | 0,823 / 219 / 12,31 / -2,24 | 0,924 / 361 / 13,02 / -1,36 | 0,92 | -0,097 / +0,004 | -12,7% / -11,3% | 69 / 150; 113 / 248 |
| 6800 | 0,803 / 211 / 10,82 / -1,87 | 0,913 / 350 / 11,82 / -1,36 | 0,93 | -0,127 / -0,017 | -15,9% / -14,0% | 65 / 146; 107 / 243 |

- **Classe**: **SOTTO 8/8** (IS 0,773-0,823; OOS 0,755-0,974), nessuna INV, **affidabilita' B** (n 211-407, un regime). **Rischio (soglie del file R141e)**: **DD > 10% in 8 celle su 8** (10,82-38,78); Peggior Giornata sotto -4,0% nella cella 800 in tutte e due le finestre. Profitto negativo in 8 su 8 (-2.854,25 ... -31.988,10 in OOS).
- **Cella 6800** (la sola che il file prova dichiara sopra il pavimento di lavoro 40x): IS 0,803 / OOS 0,913. Le celle 800 e 2800 il file le dichiarava "informative, non promuovibili per costo".
- **Test della "legge dell'ancora unica" come scritto nel file prova** (esito (a) falsificata / (b) confermata o non falsificata, "PF nullo" = tabella 0,79 / 0,90 / 0,92 / 0,93): **esito (a) ESCLUSO**: richiede il limite inferiore dell'IC 95% dell'eccesso **sopra zero in entrambe le finestre**, e **in IS l'eccesso (punto) e' <= 0 in 4 celle su 4** (-0,017 / -0,122 / -0,097 / -0,127), quindi nessun IC puo' stare sopra zero. In OOS il punto e' positivo su 2 celle (2800: +0,074; 4800: +0,004) ma **nessuna cella ha PF >= 1,10** (max 0,974). **Il bootstrap sui trade veri e' NON LEGGIBILE** (per-trade non in repo): serve solo per distinguere (b)-i da (b)-ii in OOS, non per (a). Robustezza: il PF nullo e' arrotondato a 2 decimali; uno spostamento di 0,005 non cambia nessun segno IS.
- **Previsione del file** ("PF decrescente salendo la scala"): **non si realizza**: IS 0,773 -> 0,778 -> 0,823 -> 0,803 (+3,8% da 800 a 6800, contro il +18% del gradiente nullo); OOS 0,755 -> 0,974 -> 0,924 -> 0,913 (non monotona, +20,9% da 800 a 6800). Nessuna cella >= 1,10.
- **Previsione "Trades quasi costante: se varia > 15%, il buffer sta facendo saltare trade"**: IS **-15,9%** (251 -> 211, sopra il 15% di 0,9 punti), OOS **-14,0%**. Causa NON LEGGIBILE (log non in repo).
- **Attesa di frequenza del file** (n totale 180-530; IS 72-212, OOS 108-318): **osservato IS 211-251 (sopra il tetto 212 in 3 celle su 4), OOS 350-407 (sopra 318 in 4 su 4), totale 561-658 (sopra 530 in 4 su 4)**: **1,15-1,37 op/giorno in IS e 1,27-1,47 in OOS** [DERIVATO su 183/276 feriali]. Il motore e' piu' frequente di quanto il file prevedesse.
- **Scomposizione per motore** (contatori del CSV, non PF): cella 800: BALANCE 86 + DIREZIONALE 165 = 251 (IS), 136 + 271 = 407 (OOS); il PF resta una media dei due motori (limite 3 del file prova). **Separarli e' NON LEGGIBILE da questo CSV.**
- 🔴 **Anomalia dichiarata** (punto dubbio C-5): `Flat Giorni` = **182 in IS** (coerente con 183 feriali) ma **305 in OOS contro 276 feriali** dichiarati; uguale in tutte le 4 celle. Dal CSV **non posso confermare che la finestra OOS di R141e sia 2025.06.10-2026.06.30**.
- **Certificato**: sez. 5.c.

### 4.5 `ABTG_OpeningReversalB` - P0 (8 file, 22 righe) - U30USD M5

- **IS**: n **1-3** per passata; PF **1,826 (n2) in 8 passate su 11**, 1,753 (n2), **3,562 (n3)**, 1 passata con **n1 (+126,61, PF stampato 0,000 = nessuna perdita)**; DD <= 0,96%. **OOS: `Trades = 0` in 11 righe su 11.** Contatori (il motore e' vivo): State1 IS 23-49 / OOS 15-38; State2 IS 16-29 / OOS 10-21; Entry Trigger IS 1-3 / OOS 0; FT Timeout 4-20; PB Timeout 10-28.
- **Classe**: **NON MISURATO** (n OOS = 0), affidabilita' D. Il PF IS (1,83 su n2) e' rumore: 2 operazioni non distinguono niente.
- **Dicono i CSV vs G6a**: **identico** (contatori e numeri, 0 diff).

### 4.6 `ABTG_LVNArbitro` - P0CONTA (10k), P0_100K (100k) - U30USD M30 (4 file, 8 righe)

- **10k**: IS **0,979 n392 DD 18,01 (-264,58)** -> OOS **1,051 n618 DD 11,33 (+1.022,05)**. **100k**: IS **0,975 n392 DD 19,35 (-3.374,90)** -> OOS **1,052 n618 DD 11,76 (+11.310,73)**. Le due celle gemelle per magic (769900/769950) sono identiche.
- **Classe**: OOS **SOPRA formale** (1,051-1,052), IS SOTTO -> **INV**; affidabilita' **B** (n 618). **Il DD non scende con la taglia** (18,01 -> 19,35 in IS, 11,33 -> 11,76 in OOS): dato dei CSV.
- **Dicono i CSV vs G6a**: **identico** (4 confronti). Rischio (soglia 10% congelata nei file R145a/R148a, applicata come scritta): DD IS e OOS **entrambi > 10%**.

### 4.7 `ABTG_IBRetest` - P0 su tre simboli (6 file, 12 righe) - M30

- **U30USD** IS **0,382 n42 DD 7,38** -> OOS **0,697 n53 DD 7,61**. **NASUSD** IS **0,563 n35 DD 5,80** -> OOS **0,593 n49 DD 5,31**. **D30EUR** IS **1,211 n58 DD 2,80 (+260,68)** -> OOS **0,965 n107 DD 5,25 (-83,97)** = **INV (IS>=1 -> OOS<1)**. Affidabilita' **C** per cella (n 35-107).
- **Classe**: OOS **SOTTO 3/3**; **IS SOPRA su 1 cella su 3** (D30EUR).
- **Famiglia (aggregato di 3 simboli, NON e' una cella)**: da PF e profitto dei CSV: IS **0,7356 n135** (GP 2.515,13 / GL 3.419,26), OOS **0,8124 n209** (GP 3.758,76 / GL 4.626,76), tutto **0,7798 n344**; **GP totale 6.273,89 e GL totale 8.046,02 = i numeri di `P0_IBRETEST_NASUSD_2026-09-09.md`**. Coincide con G6a.
- **Dicono i CSV vs G6a**: **identico** (6 confronti).

### 4.8 `ABTG_HVAncora` - R141d - U30USD M30 (2 file, 8 righe)

| `InpStopAtr` | IS PF / n / DD% | OOS PF / n / DD% | ancore scadute IS / OOS | Reject IS / OOS |
|---:|---|---|---|---|
| 1,0 | 1,385 / 22 / 3,42 | 1,921 / 31 / 2,06 | 91 / 165 | 5 / 16 |
| 1,5 | 1,783 / 25 / 2,45 | 1,038 / 35 / 3,84 | 88 / 161 | 2 / 10 |
| 2,0 | 1,619 / 26 / 2,15 | 1,333 / 36 / 2,79 | 87 / 160 | 1 / 2 |
| 2,5 | 1,361 / 26 / 2,24 | **0,930** / 37 / 3,12 | 87 / 159 | 1 / 1 |

- **Classe**: OOS **SOPRA su 3 celle su 4** (1,921, 1,038 formale, 1,333), **SOTTO su 1** (k 2,5, **INV IS 1,361 -> OOS 0,930**); IS SOPRA 4/4. Affidabilita' **C** in OOS (n 31-37), D in IS (22-26). Rischio: DD <= 3,84%, peggior giornata <= -1,66%.
- **Ancore**: 114 (IS) e 196 (OOS) in tutte le celle; **scadute 76-80% (IS) e 81-84% (OOS)**. **Dicono i CSV vs G6a**: **identico** (8 confronti; l'"AGGIORNATO" del file IS e' solo ordine righe).

### 4.9 `ABTG_AtrExhaustVol` - R141c - NASUSD M30 (2 file, 4 righe)

- **PERC (autore, `InpProxMode 0`)**: IS **0,711 n153 DD 19,25 (-18.421,10)** -> OOS **0,952 n224 DD 13,45 (-4.277,39)** (SOTTO, aff. **B**). **ATR (`InpProxMode 1`)**: IS **0,972 n70 DD 5,69 (-793,59)** -> OOS **1,229 n96 DD 4,14 (+8.460,56)** (SOPRA, aff. **C**, **INV IS<1 -> OOS>=1**).
- **Dicono i CSV vs G6a**: **identico** (4 confronti). Colonna `Peggior Giornata %`: **assente** (NON LEGGIBILE).

---

## 5. CONFRONTO CON G6a

### 5.a Celle SOPRA e SOTTO in entrambi i versi (classe 1127)

Scorse **tutte le 98 righe** nei due versi (non la sola riga di default). Per EA (celle distinte; LVN = 1 cella a due depositi):

| EA | celle | OOS SOPRA | OOS SOTTO | OOS NM | IS SOPRA | IS SOTTO | celle INV |
|---|---:|---:|---:|---:|---:|---:|---:|
| IntradayMomentum | 4 | 4 (1 formale) | 0 | 0 | 0 | 4 | 4 |
| VolExpBreak | 8 | 1 (formale) | 7 | 0 | 6 | 2 | 5 |
| Cycle | 4 | 0 | 4 | 0 | 0 | 4 | 0 |
| DaxValueArea | 4 | 0 | 4 | 0 | 0 | 4 | 0 |
| OpeningReversalB | 10 | 0 | 0 | 10 | 9 (n 2-3) | 0 (1 n.d.*) | - |
| LVNArbitro | 1 | 1 (formale) | 0 | 0 | 0 | 1 | 1 |
| IBRetest | 3 | 0 | 3 | 0 | 1 | 2 | 1 |
| HVAncora | 4 | 3 (1 formale) | 1 | 0 | 4 | 0 | 1 |
| AtrExhaustVol | 2 | 1 | 1 | 0 | 0 | 2 | 1 |

- **Celle SOPRA nascoste dentro EA che G6a vedeva "SOTTO/NM"**: **VolExpBreak U30USD kStop 2,5 (OOS 1,042)** e, in IS, **IBRetest D30EUR (1,211)**; `Cycle` e `DaxValueArea` **non ne hanno nessuna** (Cycle: 0 righe su 6 sopra 1 in OOS e 0 su 6 in IS; DaxValueArea: 0 su 4 in OOS e 0 su 4 in IS).
- **Celle SOTTO nascoste dentro EA che G6a vedeva "SOPRA"**: **LVNArbitro IS 0,979 / 0,975** (n 392); **IntradayMomentum IS 0,461-0,609 su 4/4** (G6a lo diceva, confermato).
- **Mai SOPRA in nessuna delle due finestre**: Cycle (IS e OOS), DaxValueArea (IS e OOS), IBRetest in OOS 3/3.
- **Una sola cella SOPRA in tutte e due le finestre fra VolExpBreak, Cycle, DaxValueArea**: VolExpBreak U30USD kStop 2,5 (IS 1,123 n78 / OOS 1,042 n111).

### 5.b Segno invertito IS -> OOS

**13 celle** (14 righe, LVN due depositi):

| verso | celle |
|---|---|
| **IS < 1 -> OOS >= 1** (6) | IntradayMomentum NASUSD L+S 0,609 -> 1,243 · NASUSD 2o segnale 0,463 -> 1,486 · U30USD L+S 0,599 -> 1,035 · U30USD 2o segnale 0,461 -> 1,250 · LVNArbitro 0,979 -> 1,051 (10k; 100k 0,975 -> 1,052) · AtrExhaustVol-ATR 0,972 -> 1,229 |
| **IS >= 1 -> OOS < 1** (7) | **VolExpBreak NASUSD kStop 1,0 / 1,5 / 2,0 / 2,5: 1,244 -> 0,852 · 1,223 -> 0,965 · 1,288 -> 0,925 · 1,324 -> 0,761** · VolExpBreak U30USD kStop 2,0: 1,047 -> 0,934 · IBRetest D30EUR 1,211 -> 0,965 · HVAncora k 2,5: 1,361 -> 0,930 |

Nessuna inversione in `Cycle` e `DaxValueArea` (tutte le celle sotto 1 in entrambe le finestre). `OpeningReversalB`: non valutabile (OOS n 0).

### 5.c Le caselle del certificato di morte per VolExpBreak, Cycle, DaxValueArea (erano NM per mancanza di CSV)

Regola del piano 5.6: se manca anche una sola casella il verdetto e' **NON ANCORA MISURATO** e si scrive **cosa manca**.

| casella | VolExpBreak | Cycle | DaxValueArea |
|---|---|---|---|
| (1) PF misurato | **SI** [T] 16 righe, PF 0,761-1,324 (std. IS/OOS desunte) | **SI** [T] 12 righe, PF 0,761-0,981 | **SI** [T] 8 righe, PF 0,755-0,974 |
| (2) n e DD | **SI** n 71-124, DD 5,2-18,4% (100k, 0,65%) | **SI** n 630-2072, DD 17,1-55,1% | **SI** n 211-407, DD 10,8-38,8% |
| (3) gestione dell'uscita ad asse | **PARZIALE, NON CHIUSA**: l'asse e' `InpKStop` (lo stop; il TP e' ancorato allo stop), ma letto col gate (pre) scattato 4/4. `InpTP_RR 2`, `InpTP1Pct 0`, `InpBreakeven 0` **mai variati** | **NO**: `InpKStop 2`, `InpTP_RR 0`, `InpEsciSuCrossOpposto 1`, `InpEsciDopoNBarre 0`, parziale e BE **costanti in 12/12 righe**; gli assi girati sono verso e lato (non uscita) | **PARZIALE**: l'asse e' `InpSlBufferPts` (buffer dello stop); `InpTP1_ClosePct 0`, `InpBreakevenAfterTP1 1`, `InpExtVaMult 1`, `InpMinStopPts 500` **mai variati** |
| (4) simboli gemelli | **SI per 2 indici su 3**: NASUSD, U30USD (D30EUR non provato; forex escluso nel file R145a: ATR forex NON MISURATO) | **NO**: solo NASUSD (U30USD, D30EUR mai) | **NO**: solo D30EUR (NASUSD, U30USD mai) |
| (5) TF cambiato | **NO**: solo M30 (M15 non girato) | **NO**: solo M30 | **NO per dato**: solo M15; M5 escluso dal file per tetto barre (126.700 > 100.000) e M30 "degenera in ORB" = **argomenti del file prova, non misure** |
| **esito** | **NON ANCORA MISURATO**: caselle chiuse 3 (1, 2, 4) + (3) parziale; **manca: uscita (TP/parziale/BE), TF; D30EUR** | **NON ANCORA MISURATO**: **2/5**; **manca: uscita, gemelli (U30USD, D30EUR), TF (M15/H1)** | **NON ANCORA MISURATO**: **2/5** + (3) parziale; **manca: gemelli (NASUSD, U30USD), TF (M30/H1 misurati), target/parziale/BE** |

Nessun round di queste tre famiglie puo' dichiarare **MORTO**. Un fatto di rischio e' indipendente dal certificato (Emendamento B): **DD oltre il 10% a n >= 150 e' misurato per Cycle (8/8) e DaxValueArea (8/8)**.

### 5.d Quali verdetti cambierebbero (PROPOSTE, non riscrivo G6a)

| EA | G6a (sez. 1.1) | CSV | proposta |
|---|---|---|---|
| DaxValueArea | NM, "R141e girato, CSV non in repo; il morto del 09/09 e' un argomento" | **SOTTO 8/8, aff. B, DD > 10% in 8/8** | **NM -> SOTTO [T], aff. B**; "NO PER RISCHIO" per il DD misurato nelle 8 celle (soglia 10% del file); **resta NON ANCORA MISURATO come morto** (2/5, sez. 5.c); la "legge dell'ancora unica" **non falsificata** |
| Cycle | NM, "girato, CSV non in repo" | **SOTTO 12/12, aff. B, DD 17-55%** | **NM -> SOTTO [T], aff. B**; "NO PER RISCHIO"; **NON ANCORA MISURATO come morto** (2/5); le uscite (A)-(E) di R148 **non scattano alla lettera** (sez. 4.3) |
| VolExpBreak | NM, "girato, CSV non in repo" | **ENTRAMBE (1 SOPRA formale, 7 SOTTO), aff. C, n 71-124** | **NM -> ENTRAMBE [T], aff. C, MERITO SOSPESO**; **NON ANCORA MISURATO** sull'asse (gate (pre) scattato 4/4); rischio: DD OOS > 10% in 7/8; certificato 3/5 + (3) parziale |
| IntradayMomentum, HVAncora, AtrExhaustVol, IBRetest, LVNArbitro, OpeningReversalB | (come sez. 1.1) | **identici** | **nessun cambio** (0 differenze) |

**Conteggi di G6a (sez. 2) se le proposte fossero accettate** (ricalcolati a mano e controllati per somma):

| lista | G6a classe A (con screening) | **A dopo** | G6a classe T (solo tick) | **T dopo** |
|---|---:|---:|---:|---:|
| SOPRA (almeno una cella) | 9 | **10** | 7 | **8** |
| SOTTO (almeno una cella) | 9 | **12** | 8 | **11** |
| entrambe | 8 | **9** | 6 | **7** |
| solo SOPRA | 1 | 1 | 1 | 1 |
| solo SOTTO | 1 | **3** (IBRetest, Cycle, DaxValueArea) | 2 | **4** (IBRetest, CRT, Cycle, DaxValueArea) |
| solo NM | 7 | **4** (OpeningReversalB, OutOfNoise, FvgRetest, ImpulsoApertura) | 8 | **5** (le quattro + CanaleLento) |
| controllo | 1+1+8+7 = 17 | 1+3+9+4 = 17 | 1+2+6+8 = 17 | 1+4+7+5 = 17 |

### 5.e Cio' che i CSV smentiscono (o correggono)

1. **"Per `DaxValueArea`, `VolExpBreak`, `Cycle` il numero esiste ed e' irraggiungibile" (G6a 1.1, 3-bis, 5 misura 1)**: ora e' raggiunto. **36 righe, tutte con n > 0**: "uscita 0" del runner = "round girato con operazioni", confermato su 36 su 36.
2. **G6a 4.11 punto 10: "`IntradayMomentum` e' l'unico dei 17 con n >= 150 in OOS per costruzione"**: **non regge** con i CSV: `Cycle` (n OOS 1036-2072, 3,7-7,5 op/giorno) e `DaxValueArea` (n OOS 350-407, 1,27-1,47 op/giorno) hanno n OOS >= 150 in **tutte** le celle; `LVNArbitro` (618) e `AtrExhaustVol` PERC (224) lo avevano gia' nella stessa G6a (sez. 2 punto 1).
3. **Attesa di frequenza del file prova R141e** (n 180-530): **smentita al rialzo** (561-658). **Previsione "PF decrescente col buffer"**: non si realizza (sez. 4.4).
4. **L'attesa di durata di Cycle (5,6-8,8 barre)**: l'osservato 5,47-5,55 (verso 0) e 4,28-4,33 (verso 1) sta **sotto** la banda; frequenza e ingressi/giorno invece **dentro**.
5. **"L'inversione IS/OOS e' tipica degli EA a ora fissa"** (implicita nell'ipotesi dell'orologio, G6a G6a-4): i CSV mostrano inversioni **in entrambe le direzioni**, e **5 celle su 8 di `VolExpBreak`, che ha il filtro orario SPENTO e opera 24 ore, sono invertite nel verso opposto a `IntradayMomentum`**. Questo **non smentisce** l'ipotesi per `IntradayMomentum` (che e' NON VERIFICABILE, sez. 6) ma **smentisce che l'inversione sia un fenomeno proprio degli EA a ora fissa**.
6. **G6a 5 misura 1 ("controllare che IS e OOS abbiano 8 righe")**: **righe: confermate** (R141e 8, R145a 8, R145b 8, R148a 4, R148bl 4, R148bs 4); **date: NON LEGGIBILI** (nessuna colonna di data); **IS e OOS di ogni coppia hanno `Inp*` identici** (19 coppie su 19): nessuna coppia "mezza riscritta" visibile da questo lato, ma i CSV non dicono in quale notte sono stati scritti (G6a-1 resta aperto).
7. **Nessuna smentita** per le sei famiglie gia' in repo: 31 confronti di cella, **0 differenze**.

---

## 6. L'IPOTESI DELL'OROLOGIO INVERNALE DI G6a (49% inverno in IS contro 33% in OOS)

**Verdetto: NON VERIFICABILE.** I 38 CSV **non contengono nessuna data o ora per operazione** (le colonne sono: statistiche di passata, contatori, input). Senza il per-trade non si puo' spezzare nessuna cella per allineamento d'orologio (EDT/EST), ne' per lato, ne' per regime. I per-trade (`abtg_trades_*.csv`, `Common\Files` sul VPS) **non sono in repo** (verificato: nessun file con magic 784101/784102/775301/775701/784105/784103/784104 fuori dagli OPTFRAME).

- **Cio' che ho rifatto** (e che NON e' una verifica dell'ipotesi): il **conto del calendario**. Con regole DST esplicite (USA: 2a domenica di marzo - 1a di novembre, cioe' EST 03/11/2024-08/03/2025 e 02/11/2025-07/03/2026; UE: ultima domenica di marzo - ultima di ottobre) e BCM = UTC+1 fisso (`OROLOGIO_BCM_2026-09-24`): **IS 183 feriali: inverno USA 90 = 49,2%, inverno UE 110 = 60,1% · OOS 276 feriali: USA 90 = 32,6%, UE 110 = 39,9% · tutta la finestra 459: 39,2% / 47,9%.** **Coincide con G6a** (49,2 / 60,1 / 32,6 / 39,9 / 39,2 / 47,9).
- **Cosa i CSV dicono, senza dire nulla sull'ipotesi**: `InpSessionHour`/`InpEntryHour` sono ore server fisse nei CSV (DaxValueArea 8:00-16:30; IntradayMomentum 14:30 / 20:30 / 21:00; VolExpBreak e Cycle hanno `InpUseHourFilter 0`, cioe' nessun orario nei parametri di ingresso). Le inversioni IS/OOS compaiono sia dove l'ora conta (IntradayMomentum 4/4 IS<1 -> OOS>=1, LVNArbitro, AtrExhaustVol-ATR) sia dove **non** c'e' filtro orario (VolExpBreak, 5 celle in verso opposto): sez. 5.e punto 5.
- `DaxValueArea` ha `InpSessionHour 8` in ora server e l'inverno UE pesa **60,1% in IS contro 39,9% in OOS**: **nessuna inversione IS/OOS** in R141e (tutte le celle SOTTO in entrambe le finestre). Osservazione, non misura.

---

## 7. RICALCOLI E DIFFERENZE REFERTO/CSV

| controllo | esito |
|---|---|
| confronto cella per cella con i numeri di G6a (PF a 3 decimali, n, DD a 2 decimali): R141a/b (8), R141c (4), R141d (8), P0 IBRetest (6), P0 LVN (4), P0 OpeningReversalB (1 cella + contatori) | **31 su 31 uguali, 0 differenze** |
| contatori `OpeningReversalB` (State1/State2/FT/PB Timeout/Entry Trigger) e `HVAncora` (ancore scadute, Reject, Flat) | **uguali a G6a** |
| IBRetest famiglia da PF e profitto di 6 righe | IS 0,7356 / OOS 0,8124 / tutto 0,7798; **GP 6.273,89 / GL 8.046,02 = `P0_IBRETEST_NASUSD_2026-09-09.md`** |
| 2 CSV "AGGIORNATI" (`IntradayMomentum_NASUSD_OOS_r141a`, `HVAncora_U30USD_IS_r141d`) | `git diff` fra versione 13/09 e 05/10: **solo ordine delle righe**, cifre identiche = **determinismo fra le notti 13 e 20/09** (non e' la prova di G6a-1, che riguarda il 21/09) |
| `Expected Payoff x Trades = Profit` | entro 0,02 su 98/98 righe |
| coppie IS/OOS con `Inp*` identici | 19/19 |
| gemelle per magic identiche | IBRetest 6/6, LVNArbitro 4/4, OpeningReversalB P0CONTA 2/2 |
| `Trades` = conteggio indipendente (Ingressi / Apri Chiamate / Long+Short) | Cycle 12/12, DaxValueArea 8/8, HVAncora+IBRetest+LVNArbitro 28/28 |
| calendario inverno/estate | uguale a G6a (sez. 6) |
| **referto vs CSV per i 6 round nuovi** | **nessun referto con numeri esiste** (solo `REFERTO_RUNNER` con "ESEGUITO in N s, uscita 0"): niente da confrontare, i numeri di questo file sono i primi |
| dimensione dei per-trade dichiarata da G6a (VPS, 21/09) contro n OOS dei CSV | `IntradayMomentum` 15,8 KB / 261 = ~60 B/riga; `Cycle` 128,3 KB / 2072 = ~62; `VolExpBreak` 6,8 KB / 110-111 = ~61: **coerente con "il per-trade e' l'ultima passata, di norma l'OOS"** `[STIMA dalle dimensioni, non una misura]`; `DaxValueArea` (30,9 KB) non confrontabile (riga piu' larga) |

---

## 8. [NON COPERTO]

- **Per-trade assenti dal repo**: quindi **niente** bootstrap/IC 95% (il test completo di R141e), **niente** spezzatura per orologio/lato/regime, **niente** distribuzione degli stop, **niente** `E in R` vero (uso `Expected Payoff / 650` e la formula ln scritte nei file prova).
- **Modello di tick, deposito, TF, date IS/OOS: non nei CSV.** Dichiarati dal runner/dai file prova/da G6a (sez. 0). Per i P0 di settembre (IBRetest, LVNArbitro, OpeningReversalB) il deposito (10k, 100k per `P0_100K`) viene da G6a e dai referti `REFERTO_ROUND_*.txt`, non dal CSV.
- **Colonna `Peggior Giornata %` assente** in IntradayMomentum e AtrExhaustVol: la peggior giornata di quelle celle e' NON LEGGIBILE da questi CSV.
- **Giornale del tester assente**: le cause di S2 (|L-S| = 6 e 34 incroci non entrati in IS), del -15,9% di Trades IS di DaxValueArea e dei `Lotto Tagliato` 9 contro 18 di Cycle sono NON LEGGIBILI.
- **Fuori perimetro**: R98, R235, R109, R95, R89, i P0 di CRT/NySession/DaxReEntry (numeri solo nei referti, non in questi CSV); `CanaleLento` (CSV in `risultati_archivio/Notte_16-08`, non in `dal_vps`); famiglie di altri gruppi nelle altre 25 cartelle di `dal_vps`.
- **Non ho validato i criteri scritti nei file prova** (gate 10%, banda [-0,05;0,00], soglia DD 10%, PF nullo di R141e): li applico come scritti. Non ho confrontato i `.mq5`.
- **Gate del cancello**: questa bozza **non e' passata da `controlla_riga.py` ne' da `controllo-preventivo`**.

---

## 9. PUNTI DUBBI

| id | punto | perche' conta |
|---|---|---|
| C-1 | **La regola 5.6 non dice se un asse di STOP conta come "gestione dell'uscita messa ad asse".** G6a l'ha trattato in tre modi: HVAncora `InpStopAtr` = PARZIALE, VolExpBreak `InpKStop` = "asse di stop (non l'uscita)", DaxValueArea `InpSlBufferPts` = "asse di costo, non di gestione". Qui ho scritto PARZIALE per VolExpBreak e DaxValueArea (stop ad asse, target/parziale/BE no) **senza decidere** | cambia 3/5 contro 2/5 |
| C-2 | **Gate (pre) di VolExpBreak: la base dello scarto del 10% non e' scritta** (cella 1,0 o 2,5). Con tutte e due scatta in 4 finestre su 4; NASUSD OOS e' il piu' vicino (11,3% / 12,7%) | non cambia il verdetto qui; cambierebbe su una finestra al limite |
| C-3 | **Cycle R148a OOS verso 0: -0,0523 R, a 0,0023 dalla banda di (b).** Lettura alla lettera: (b) non scatta in OOS; nello spirito e' (b) | l'esito scritto nel registro dipende da come si legge la banda; **non decido** |
| C-4 | **Cycle S2: `|L-S| = 6` in IS (limite 1) e 34 incroci non entrati (1300 vs 1266)**; in OOS 0 e 0. Il file dice che S2 e' "il controllo di una frase gia' scritta": la frase (308-3) regge (somma esatta) ma la seconda condizione non passa | un motivo (warm-up dell'indicatore a inizio finestra IS?) **non provato**: NON LEGGIBILE |
| C-5 | **DaxValueArea: `Flat Giorni` OOS = 305 contro 276 feriali** (IS 182 contro 183). Il contatore usa `day_of_year` (sorgente r.971-973) | se la finestra OOS di R141e fosse piu' lunga di quella dichiarata, i numeri OOS non sarebbero confrontabili con gli altri round: **da verificare sul log del tester** |
| C-6 | **Due direzioni opposte di inversione IS/OOS coesistono** (6 contro 7 celle) | la lettura "regime, non edge" di G6a per IntradayMomentum non e' contraddetta, ma **non e' l'unica forza in gioco** (sez. 5.e punto 5) |
| C-7 | **Cycle ha `InpUsaGuardian 1` e tetto giornaliero spento**: il DD/peggior giornata e' pessimista per scelta del file prova; con Guardian vivo (pausa 4,0) i numeri sarebbero diversi. Non e' stato misurato | il -4,11% OOS e' sopra la pausa B1 firmata: dato, non decisione |
| C-8 | **PF aggregato su due simboli (VolExpBreak) e su tre (IBRetest)**: riportato come informativo, **non come cella** (G6a-6) | evitare che un aggregato n 169-248 passi per un campione >= 150 di cella |
| C-9 | **Per-trade sul VPS gia' prodotti** (G6a-2): servirebbero a chiudere C-4, C-5, l'orologio e il test bootstrap di R141e | **una copia dal VPS richiede una firma** (perimetro del runner: sola lettura) |

---

## 10. CONTROLLI FATTI PRIMA DI CONSEGNARE (contro-esempi costruiti)

1. *"Lo scarto del gate (pre) dipende dalla base"* -> provato con **entrambe le basi**: scatta in 4/4 con tutte e due.
2. *"Un file AGGIORNATO ha cifre cambiate?"* -> `git diff` fra le due versioni: solo ordine righe.
3. *"La formula ln di Cycle e' giusta?"* -> **riverificata contro il caso costruito a mano nel file prova** (6.715,90 -> 10,0000; -27.747,26 -> -50,0000) e col controllo EP/650 (stesso segno 28/28). Il file stesso avverte che EP/650 e' **distorta sul compounding**: per Cycle non l'ho usata per le uscite.
4. *"L'eccesso sul PF nullo di R141e e' robusto?"* -> il PF nullo e' arrotondato a 2 decimali: ±0,005 non cambia nessun segno in IS; nessun IC puo' stare sopra zero se il punto e' <= 0.
5. *"Pooling che salva?"* -> l'aggregato di VolExpBreak a 2 simboli **resta invertito** in 4 kStop su 4; non salva niente.
6. *"Ho letto solo la riga di default?"* -> no: 98 righe su 98, nei due versi (sez. 5.a).
7. *"Le gemelle per magic sono identiche?"* -> asserzione nel codice su Profit, Trades, PF, DD (12 coppie): vero.
8. *"S5 e' una prova?"* -> no, e' un **allarme** (cache), lo dice il file e lo ripeto.
9. *Conteggi ricontati alla fine*: 43 righe di sez. 3 -> OOS SOPRA 11 / SOTTO 22 / NM 10 (codice); somma per EA di sez. 5.a coerente (con LVN a una cella e senza i 2 duplicati Cycle); tabella 5.d: ogni colonna somma a 17 EA (A dopo: 1+3+9+4; T dopo: 1+4+7+5) ed e' la tabella di G6a piu' le tre variazioni (DaxValueArea, Cycle, VolExpBreak) spostate da NM.
10. *"Il calendario dell'orologio e' lo stesso di G6a?"* -> ricalcolato con funzioni indipendenti (n-esima domenica): **uguale** (sez. 6).

---

## CHANGELOG
| data | cosa | perche' |
|---|---|---|
| 05/10/2026 | creato: 38 CSV, 98 righe, 19 round, 9 schede, confronto con G6a - **bozza, NON passata dal cancello** | richiesta di lettura dei CSV trasportati da Claudio il 05/10/2026 |
