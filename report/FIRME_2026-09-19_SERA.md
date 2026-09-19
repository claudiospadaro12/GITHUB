# 🖊️ FIRME DI CLAUDIO — 19/09/2026, sera

Verbale delle decisioni prese in chat stasera. Ogni riga porta **cosa ha firmato**,
**il numero che gli ho messo davanti prima che firmasse**, e **cosa resta aperto**.

---

## ① 🏦 LA PROP: **FTMO**, leva dichiarata **1:15**
Scelta fra FTMO 1:15 e FundedNext 1:25.
- 🟢 **Verificato dopo la firma, e la conferma la regge**: FTMO **non applica nessuna
  restrizione news durante l'Evaluation Process**, e vale per tutti e due i tipi di conto
  — `docs/REGOLAMENTO_FTMO_2026-08.md` r.45 · `report/QUALE_PROP_PER_I_NOSTRI_EA_2026-09-18.md` r.229.
- 🔴 **Resta aperto**: **non sappiamo se ha comprato Standard o Swing.** In repo non c'è
  nessuna prova d'acquisto. Decide le news da funded, il weekend **e il margine**.
  Si chiude con uno screenshot della dashboard.

## ② 🪑 LA ROSA: **SETTE sedie**
`770101` DAX Apertura · `770411` MaxMin DAX Short · `770202` Dow Apertura ·
`771531` EMA200 Dow · `770511` SuperWave Dow · `770402` MaxMin ORO · **`770260` Nasdaq RETEST**.

### ②b 🇺🇸 IL NASDAQ — firmato in chiaro: **«Sì, dentro il 770260 RETEST»**
| | `770260` **RETEST** | `770261` BREAKOUT |
|---|---|---|
| PF OOS | **1,109** ✅ (soglia 1,10) | **1,063** ❌ |
| n OOS | 94 | 108 |
| DD OOS | 3,68% | 4,13% |

- ✅ **DENTRO il RETEST**, ❌ **FUORI il BREAKOUT**: 1,063 non supera un cancello che
  abbiamo firmato noi. Fonte: `report/DUE_SEDIE_NASDAQ_IL_BLOCCO_2026-09-19.md`.
- 🔴 **`770260` entra col MERITO SOSPESO per campione**: n=94, sotto il pavimento dei 150.
  La corsia **RISCHIO** del criterio di uscita (18/08) vale su di lei **dal primo giorno**.
- 🟢 **Perché si è sbloccata stasera**: il blocco era `770261` che poteva chiudere la
  posizione di `770250`. La toppa per ticket è entrata a HEAD stasera
  (`report/TOPPA_TICKET_A_HEAD_2026-09-19.md`), e togliendo il BREAKOUT la collisione
  Nasdaq sparisce del tutto.

## ③ 🔧 COMPILAZIONE di `771531` e `770511` — firmata: **«SI FIRMO ENTRAMBE, COMPILA PURE»**
- 🛑 **MA il pacchetto è in HOLD, e l'ho fermato io**: la compilazione **cambia le taglie**,
  e la firma copriva *«compila»*, non *«cambia le taglie»*.
  `report/COMPILAZIONE_771531_770511_2026-09-19.md`.
- 🔴 Scoperta collaterale che pesa: **`770511` in campo piazza PIÙ lotti del suo contratto.**
  Quando `NormVol(totLot*0.3333)` arrotonda a zero, il binario vecchio fa `totLot + volMin`
  invece di `volMin`. Ricompilare **abbassa** la taglia verso il contratto dichiarato (1,0%),
  e rende **il forward storico non confrontabile**.

## ④ 📏 LA MISURA DEL DELTA LOTTI — firmata: **«Misura prima, lancia la corsa nel tester»**
Corsa sul banco **50504400** (`C:\MT5_Backtest`), a **due depositi** (100.000 e 10.000),
perché il difetto si vede **solo dove il lotto è piccolo**. In preparazione.

---

## 🔴 COSA **NON** È FIRMATO, e resta di Claudio

| # | cosa | stato |
|---|---|---|
| 1 | **LE TAGLIE** | 🔴 **[NON DECISA]** — ha chiesto di alzarle, gli ho dato il numero, non ha ancora risposto |
| 2 | Standard o Swing | 🔴 sconosciuto |
| 3 | Sostituire l'`.ex5` sul **REALE 10105439** | 🔴 mai chiesto, mai fatto |
| 4 | Le domande al supporto FTMO | 🟠 pronte dal 13/08, **mai inviate** |

### 📐 Il numero che gli ho messo davanti sulle taglie, e che resta agli atti
Il drawdown scala **linearmente** col rischio, contro un muro FTMO **statico del 10%**:

| sedia | 0,65% *(oggi)* | 1,00% | 1,30% | 2,00% |
|---|---:|---:|---:|---:|
| `770101` DAX Apertura | 4,70% | 7,23% | **9,40%** | 🔴 14,46% |
| `770202` Dow Apertura | 2,85% | 4,39% | 5,71% | 8,78% |
| `770260` Nasdaq RETEST | 2,39% | 3,68% | 4,78% | 7,36% |

🔴 **A 1,30% la sola `770101` arriva a 9,40% contro un muro di 10.** Tetto proposto:
**1,00% fisso per tutte** — e *fisso* non è un dettaglio: fra le Forbidden Practices FTMO
c'è *«substantially larger or smaller position sizes compared to other trades»*, quindi
alzare e poi abbassare è una **pratica proibita**, non una furbizia.

🟢 **E il fatto che toglie l'urgenza da tutto questo**: FTMO **non ha limite di tempo** —
*«There is no time limit… the Trading Period is indefinite»* (`docs/REGOLAMENTO_FTMO_2026-08.md` r.17).
Alzare i lotti compra **velocità**, cioè l'unica cosa che FTMO non chiede. Il muro del 10%
invece è definitivo: lo tocchi una volta e hai finito.
