# 🔧 LE «46 RIGHE FALLITE» DEL RUNNER — **la metà non è fallita, e il referto lo dice al contrario**

**19/09/2026, turno notturno** · promesso nel resoconto di ieri: *«diagnosticare le 46 righe con
uscita ≠ 0 — oggi non l'ho fatto»*. Fatto adesso.

> # 🟢 **PRIMA LA NOTIZIA BUONA: la macchina lavora molto meglio di quanto il suo stesso referto dichiari.**

---

## ① I CODICI D'USCITA SONO DOCUMENTATI — nel driver, rr.1642-1645

`backtest_pipeline/righe/RIGA_SOTTILE_ROUND.ps1`, testuale:

| codice | significato, **parole del driver** |
|---|---|
| **0** | *«ROUND GIRATO: i CSV ci sono, freschi, con operazioni»* |
| **3** | 🟡 *«GIRATO CON RILIEVI: i numeri ci sono, ma c'è qualcosa da leggere nel referto. **NON è un fallimento**»* |
| **2** | 🔴 *«NON MISURATO: CSV assenti, vuoti, oppure zero operazioni. Zero operazioni non vuol dire nessun edge: vuol dire che **NON È GIRATA**»* |
| altro | *«non è nemmeno partito: il pre-volo ha fermato la corsa»* |

## ② 🔴 MA IL RUNNER CONTA TUTTO CIÒ CHE NON È ZERO COME «FALLITO»

`backtest_pipeline/runner_abtg.ps1` **rr.777-778**:
```powershell
if($p.ExitCode -eq 0){ $eseguiti++; W ("    ESEGUITO in " + $sec + "s, uscita 0") }
else { $falliti++; W ("    ESEGUITO in " + $sec + "s, uscita " + $p.ExitCode + " -- guarda il log") }
```

👉 **`$falliti` include i `3`** — cioè i round che **hanno prodotto i numeri**.

### Il conto vero della notte del 18/09
| | righe | tempo macchina |
|---|---:|---:|
| **uscita 0** — girati, CSV pieni | **81** | 637,4 min |
| **uscita 3** — girati **con rilievi**, i numeri ci sono | **23** | 79,5 min |
| 🔴 **uscita 2** — **non misurati** | **23** | **140,3 min** |

> ## 🟢 **Quindi non sono «46 falliti su 127»: sono 104 righe che hanno prodotto numeri e 23 che no.** Il referto ci racconta la macchina **due volte peggiore** di com'è.

---

## ③ 🔴 IL BUCO VERO: **23 round, 140 minuti di macchina, ZERO misure**

E non sono briciole. I più cari:

| minuti | round |
|---:|---|
| **30,1** | `R154a_sllookback_SuperWave_U30USD` |
| **23,1** | `R155a_tprr_SuperWaveDowH1_U30USD` |
| **16,3** | `R166a_slbufferpips_supertrendrev_225JPY` |
| 5,5 | `R158a_atrexit_PTE_U30USD` |
| 5,4 | `R169a_slbufferatr_puntelarry_U30USD` |
| 4,9 | `R156a_maxdayshold_puntelarry_U30USD` |

**Due ore e venti di tester bruciate**, e mezz'ora su una sola riga — che è più del costo
stimato dell'intero duello sul Dow (~15 min).

⚠️ **Il `2` ha due cause diverse dietro** (*«CSV assenti, vuoti, **oppure zero operazioni**»*), e
**quale delle due sia non lo so ancora**: 🔴 **[NON MISURATO]**. La differenza conta parecchio —
*CSV assente* è un guasto della catena, *zero operazioni* è un file prova che non produce trade
(filtri troppo stretti, finestra sbagliata, simbolo senza dati). **Si separano leggendo il log
riga per riga**, ed è il prossimo passo.

---

## ④ LA TOPPA, **proposta e non applicata**

Due righe, e non cambia **nulla** di ciò che viene eseguito — solo come viene contato:

```powershell
if($p.ExitCode -eq 0)     { $eseguiti++;  W ("    ESEGUITO in " + $sec + "s, uscita 0") }
elseif($p.ExitCode -eq 3) { $conRilievi++; W ("    GIRATO CON RILIEVI in " + $sec + "s, uscita 3 -- i numeri ci sono") }
elseif($p.ExitCode -eq 2) { $nonMisurati++; W ("    NON MISURATO in " + $sec + "s, uscita 2 -- nessun CSV utile") }
else                      { $falliti++;   W ("    NON PARTITO in " + $sec + "s, uscita " + $p.ExitCode) }
```
e nel riepilogo quattro righe invece di tre.

🚦 **NON applicata**: `runner_abtg.ps1` è ciò che gira sul VPS, quindi passa dal cancello e, per
il perimetro, dalla firma di Claudio. **Qui c'è solo la diagnosi e la toppa pronta.**

---

## 📌 In una riga
**La macchina ha prodotto numeri su 104 righe su 127, non su 81.** 🔴 Il buco reale sono **23
round che non misurano e costano 140 minuti a notte** — e il primo passo per chiuderlo è
separare *«CSV assente»* da *«zero operazioni»*, che oggi il referto non distingue.

---
*Fonti: `backtest_pipeline/coda/referti/REFERTO_RUNNER_20260918_033004.txt` (conteggi ricavati
dalle righe `ESEGUITO in Ns, uscita R`) · `backtest_pipeline/righe/RIGA_SOTTILE_ROUND.ps1`
rr.1642-1645 per i codici · `backtest_pipeline/runner_abtg.ps1` rr.727 e 777-786 per il conteggio.*
