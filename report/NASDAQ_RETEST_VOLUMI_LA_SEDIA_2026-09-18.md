# 🇺🇸 NASDAQ **RETEST + VOLUMI** — la sedia, come sta scritta nel CSV

**18/09/2026** · richiesta di Claudio: *«No Nasdaq dentro con retest più volumi»*

---

## ① I NUMERI DELLA CELLA, dichiarati per primi
Riga `InpEntryMode=2` **+** `InpUseVolumeFilter=1` di
`risultati_archivio/Walkforward_Aperture/NASDAQ_B_motore_{IS,OOS}.csv` — **EA core, magic `770201`**,
cioè la sedia vera, non un gemello.

| finestra | PF | n | DD | profitto |
|---|---:|---:|---:|---:|
| **IS** 26/09/2024→30/06/2025 | **1,14498** | 91 | 5,95% | +332,40 |
| **OOS** 01/07/2025→30/06/2026 | **1,10936** | 94 | **3,68%** | +274,35 |

🟢 **È l'unica configurazione sul Nasdaq positiva in TUTTE E DUE le finestre, e il suo DD OOS del
3,68% è il più basso di qualunque cosa abbiamo.**

---

## ② 🔴 LA COSA CHE SERVE SAPERE PRIMA DI TOCCARE IL GRAFICO

**Questa cella NON è il preset che gira oggi.** Quattro parametri **strutturali** sono diversi:

| parametro | **cella positiva** | preset vivo | cosa cambia |
|---|---|---|---|
| `InpRangeMode` | **0** | 2 | **da dove vengono i livelli**: range dei primi minuti ↔ candela H1 prec. |
| `InpRangeMinutes` | **35** | 15 | durata della finestra di formazione |
| `InpTP1_R` | **0,5** | 1,0 | il target, **la metà** |
| `InpUseGapFill` | **true** | false | il gap fill è **acceso** |

> ## 🔴 **Quindi accendere solo «volumi ON» sopra il preset di oggi NON dà questa sedia: dà una configurazione MAI MISURATA.** Il filtro volumi è il quinto cambio, non il primo.

---

## ③ 🆕 MAGIC NUOVO `770260`, e il motivo è misurato
`770201` ha già **10 posizioni in campo con un'ALTRA configurazione** (breakout, RangeMode=2,
15 minuti, TP1_R=1,0), dal 20/07 all'11/08. Riusare quel magic mescolerebbe **due configurazioni
sotto lo stesso nome** — che è **esattamente il difetto trovato stamattina sulla `770101`**
(`report/LE_SEDIE_PER_LA_PROP_2026-09-18.md` §①: *«non sono due varianti in gara: è la stessa
sedia prima e dopo un cambio di configurazione»*).

✅ **Verginità verificata**: `grep -rIl -w "770260" . --exclude-dir=.git --exclude-dir=.claude`
→ **0 file**.

📌 Il `.set` è stato **generato meccanicamente dalla riga del CSV** (78 righe `Inp`), non
ribattuto a mano: l'unico campo cambiato è `InpMagic`.

---

## ④ ⚠️ LE TRE RISERVE — dette adesso, non dopo

1. 🔴 **n = 91/94 contro il pavimento di casa di 150.** Sotto soglia in tutte e due le finestre.
2. 🔴 **Il filtro volumi DIMEZZA il campione** (240 → 94). Un PF che sale mentre la `n` crolla è
   il sintomo classico del **sovra-filtro**, non di una scoperta.
3. 🔴 **I due «vicini di casella» con lo stesso filtro CROLLANO fuori campione**:
   OPENCONFIRM+volumi **IS 1,816 → OOS 0,956** · DELAYED+volumi **IS 1,710 → OOS 0,696**.
   Due su tre hanno già fatto quel percorso.

---

## ⑤ 🎯 LA MIA POSIZIONE, e sono due risposte diverse

### 🟢 **SUL DEMO PICCOLO `50503392`: sì, e sono d'accordo.**
Per **firma di Claudio del 06/09** quel conto è *«lo strumento di misura, non il conto da
proteggere»*. E il problema di questa sedia è **esattamente uno: le manca campione**.
👉 **L'unico modo di portare n da 94 a 150 è farla operare.** Metterla lì non è un rischio
preso: è la via più corta al numero che manca — che è la regola di casa applicata alla lettera
(*«se è ferma per un numero MANCANTE e non per un numero BRUTTO, si trova la via più corta al numero»*).

### 🔴 **SULLA PROP: no, non ancora.**
n=94 sotto il pavimento, e la sedia madre `770201` è **[SENZA CONTRATTO]** (PF 0,82 · DD 17% ·
19/20 celle OOS negative). Ci va **dopo** che il forward le ha dato le operazioni che mancano,
non prima.

---

## ⑥ COSA MANCA PRIMA DI DETTARE LA SEQUENZA
- 🚦 **Il cancello sul `.set`** (strato 1 + strato 2). Non è ancora passato.
- 🖥️ **Il bersaglio in chiaro**: terminale **50503392** (`C:\Program Files\BCM Markets MT5 Terminal`),
  grafico **NASUSD**. ⚠️ **NON** `C:\BCM_Reale` (10105439) e **NON** `-V3` (50504263).
- ⚠️ **Il binario di quel terminale è di agosto** (`ABTG_Nasdaq_Apertura_US.mq5`, 2033 righe,
  08/08). 🔴 **Va verificato che quel binario ABBIA `InpRangeMode`, `InpUseVolumeFilter` e
  `InpVolMult`**: se la versione di agosto non li ha, il preset non si carica e la sedia gira
  un'altra cosa. **Questo controllo viene prima di tutto il resto.**

---
*Fonti: `Walkforward_Aperture/NASDAQ_B_motore_{IS,OOS}.csv` (righe `InpEntryMode=2` +
`InpUseVolumeFilter=1`) · `mql5/Presets/ABTG_Nasdaq_Apertura_US.set` e
`backtest_pipeline/allinea_nasdaq_volumi.ps1` per il preset vivo · `HANDOFF.md` r.129 per la firma
sul piccolo · `report/CONTRATTI_SEDIE.md` r.54 per lo stato di `770201` ·
`backtest_pipeline/coda/referti/CODA_06_quale_codice_gira_20260918_033004.log` per il binario.*
