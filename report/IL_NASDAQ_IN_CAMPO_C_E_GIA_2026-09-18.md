# 🇺🇸 IL NASDAQ IN CAMPO **C'È GIÀ** — si chiama `770250`, ed è viva stasera

**18/09/2026, turno notturno** · trovato leggendo la pagella automatica delle 23:00, che riporta
*«Nasdaq Apertura US SELL | 1 | +3.07»* **oggi** — mentre io avevo detto a Claudio che il Nasdaq
era spento dal 18/08.

> # 🔴 **AVEVO RAGIONE SULLA SEDIA SBAGLIATA.** `770201` è spenta davvero (ultima operazione **11/08**). Ma sul Nasdaq **ce n'è un'altra**, e opera adesso.

---

## ① LA SEDIA VIVA: `770250` — «GatedShort»

`data/statements/trades_auto.csv`, magic `770250`:

| apertura | lato | vol | P/L |
|---|---|---:|---:|
| 2026.09.15 14:31:07 | sell | 0,20 | **+4,49** |
| 2026.09.18 15:01:26 | sell | 0,20 | **+3,07** |

**2 posizioni, 2 vinte, netto +7,56.** 🟢 E **passa il cancello di costo**: `46,2×` contro la
frontiera di 40× (`report/ANCORA_ADR_FLOTTA_INDICI_2026-09-18.md` r.425, con il numero rivisto
in su dallo stesso referto).

**La sua configurazione** (`mql5/presets/ABTG_GatedShort_NASUSD_770250_LIVE.set`):
`InpEntryMode=0` **BREAKOUT** · `InpRangeMode=2` (candela H1 prec.) · `InpRangeMinutes=15` ·
🔴 **`InpAllowLong=false`, `InpAllowShort=true` — SOLO SHORT** · `InpRiskPercent=0.35` ·
`InpTP1_ClosePct=50` **+** `InpBreakevenAtTP1=true` · `InpUseVolumeFilter=false` · M15.

---

## ② 🔴 PERCHÉ NON L'AVEVO VISTA: **il commento è IDENTICO**

`770250` scrive `"Nasdaq Apertura US SELL"`. `770201` scrive `"Nasdaq Apertura US SELL"`.
**La stessa stringa.** La pagella ragiona per commento, quindi le fonde; e io leggendo
*«Nasdaq Apertura US»* ho pensato alla sedia spenta.

👉 È la **classe 426** in un'altra forma (stamattina erano `STRev`/`STREV` su due simboli):
**due sedie diverse dietro la stessa etichetta.** Qui non servono nemmeno le maiuscole — è
proprio la stessa stringa, e solo il **magic** le separa.

---

## ③ 🎯 E ADESSO IL CONFRONTO CHE CAMBIA LA DECISIONE

Claudio vuole accendere `Pass 8` (RETEST + volumi). Ma sul Nasdaq gira già `770250`. Affiancate:

| | **`770250` VIVA** | **`Pass 8`** (proposta) | **`Pass 6`** (l'altra positiva) |
|---|---|---|---|
| ingresso | **BREAKOUT** | RETEST | **BREAKOUT** |
| livelli | candela H1 prec. | **range 35 min** | candela H1 prec.¹ |
| filtro volumi | **off** | **ON** | **ON** |
| lati | **solo short** | due lati | due lati |
| parziale + BE | 🟢 **sì (50% + BE)** | 🔴 **no, nessuno dei due** | 🔴 no |
| rischio | **0,35%** | **1,0%** | 1,0% |
| n OOS | 2 *(campo)* | 94 | **108** |
| PF OOS | — | 1,109 | 1,063 |

¹ *da verificare sulla riga del CSV: il banco della FASE B fissava `InpRangeMode=0` per tutte le
celle, quindi anche `Pass 6`. Il confronto per ingresso resta valido, quello per livelli no.*

> ## 🟢 **`Pass 6` è a UN PASSO da quello che gira già: stesso ingresso, cambia il filtro volumi.** `Pass 8` invece è quasi l'opposto della sedia viva — ingresso diverso, livelli diversi, senza parziale, senza breakeven, e a **tre volte** il rischio.

---

## ④ COSA NE ESCE, senza decidere al posto di Claudio

1. 🔴 **La frase «portiamo il Nasdaq in demo» va riscritta**: in demo c'è già. La domanda vera è
   *«quale SECONDA sedia Nasdaq accendiamo accanto a `770250`?»*
2. 🟢 **E c'è un'occasione che nessuno aveva vista**: `770250` è **solo short** e **senza filtro
   volumi**. `Pass 6` dice che il filtro volumi su BREAKOUT, a due lati, fa **PF 1,063 su 108
   operazioni OOS**. **È la variante più vicina a ciò che già funziona**, e costa un preset.
3. ⚠️ **Il rischio resta firma di Claudio**: `770250` gira a **0,35%**, le celle del banco a
   **1,0%**. Non propongo numeri.
4. 🔴 **E il difetto di lettura va riparato**: finché due sedie scrivono lo stesso commento, la
   pagella e la classifica del campo le contano insieme. Il ponte per magic esiste
   (`trades_auto.csv` ha la colonna): va usato **anche** nella pagella.

---
*Fonti: `report/giornata_2026-09-18.md` (pagella delle 23:00) · `data/statements/trades_auto.csv`
(righe `magic=770250`) · `mql5/presets/ABTG_GatedShort_NASUSD_770250_LIVE.set` ·
`report/ANCORA_ADR_FLOTTA_INDICI_2026-09-18.md` rr.410 e 425 per il cancello di costo ·
`Walkforward_Aperture/NASDAQ_B_motore_{IS,OOS}.csv` per `Pass 6` e `Pass 8`.*
