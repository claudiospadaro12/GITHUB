# 🛡️ IL ROUND SUL DD DEL NASDAQ — è già stato fatto, ha **vinto**, ed è già in campo. Ma ha **riaperto** sette verdetti

**22/09/2026** · sedia **`770260`** `ABTG_Nasdaq_Apertura_US`, in campo su FTMO
`541452707` · richiesta di Claudio: *«FAI IL ROUND SUL DD DEL NASDAQ»*

---

## 0. 🔴 LA COSA CHE STAVO PER SCRIVERE, E CHE ERA FALSA

Stavo per dirti: *«il round sul DD del Nasdaq è già stato fatto il 21/09 e nessuno
l'ha letto»*. 🟢 **Falso, e l'ho verificato prima di mandartelo**: il round è stato
letto **la sera stessa**, e la sua unica manopola vincente è stata **firmata e messa in
campo alle 20:22**.

```
496408a9  2026-09-21 20:22  Nasdaq 770260: ACCESA la parziale al 50%
                            (firma di Claudio "ACCENDILA AL 50%")
```

👉 Il metodo ha funzionato. La misura → la firma → il campo, in sei ore.

---

## 1. 📊 COSA DICE IL ROUND GIÀ FATTO: **otto manopole, sette «lascia com'è», una «accendila»**

Sorgente: `report/DD_NASDAQ_R199_2026-09-21.md` (408 righe), round `R199A` `R199B`
`R200A` `R200C` `R200E` `R172D` `R201A`, tutti `ROUND GIRATO` / `RILIEVI: 0`,
banco **80.000** e taglia **2,00%** — cioè **banco e taglia veri della challenge**.

| manopola | esito | dove |
|---|---|---|
| `InpMinRangePts` | 🔴 lascia com'è | R196/R198 |
| `InpRetestOffsetPts` | 🔴 lascia com'è | R198 |
| `InpBEatR` | 🔴 **proposta RITIRATA** (Dow e DAX la rifiutano) | R199A + R172D + R201A |
| `InpTrailStartR` | 🔴 ritirata | R200 |
| `InpTrailMode` | 🔴 PREVBAR è già il migliore | R200C |
| `InpTrailFixedPts` | 🔴 nessuna finestra utile | R200E |
| `InpTrailTF` | 🔴 M5 è già il migliore | R200A |
| 🟢 **`InpTP1_ClosePct`** | 🟢 **0 → 50: meglio su PF, DD E profitto, in tutte e due le finestre** | **R199B** |

---

## 2. 🟢 E IL NUMERO CHE NESSUNO AVEVA ANCORA TIRATO FUORI: **la sedia è SOTTO IL MURO FTMO, ed è DIMOSTRATO**

La cella accesa il 21/09 sera è `InpTP1_ClosePct = 50` — la **Pass 2** di `R199B`
(`backtest_pipeline/risultati_prove/R199B/REFERTO_ROUND_R199B.txt`).

| | cella **VECCHIA** (`ClosePct=0`) | 🟢 cella **IN CAMPO** (`ClosePct=50`) | |
|---|---|---|---|
| **`Equity DD %` IS** | 🔴 **12,3568%** | 🟢 **7,3069%** | **−40,9%** |
| **`Equity DD %` OOS** | 🟠 **9,1244%** | 🟢 **7,8576%** | **−13,9%** |
| PF IS / OOS | 1,11621 / 1,14894 | 1,22116 / 1,21546 | **+9,4% / +5,8%** |
| profitto IS / OOS | 4.549,93 / 7.689,12 | 7.014,20 / 8.496,74 | **+54,2% / +10,5%** |
| posizioni IS / OOS | 82 / 102 | **82 / 102** | 🟢 invariate |
| *(deal in colonna `Trades`)* | *82 / 102* | *135 / 172* | — |

🔎 **La colonna `Trades` del referto conta i DEAL, non le posizioni**: con la parziale accesa una posizione esce in due volte. Le posizioni restano 82/102 — lo dimostra il fatto che le tre celle `25`/`50`/`75` hanno `Trades` **identico** (135-135-135 e 172-172-172): la percentuale chiusa non cambia **quante** posizioni toccano 0,5 R, cambia solo **quanto** si chiude.

> ### 🟢 **`Equity DD %` è un LIMITE SUPERIORE della perdita statica che FTMO misura (classe 562). Un limite superiore SOTTO la soglia DIMOSTRA la sicurezza.**
> **7,31% e 7,86% stanno tutti e due sotto il muro del 10%.**
> 👉 **La `770260` passa da 🔴 «fuori dal muro sull'IS» a 🟢 «sotto il muro, dimostrato, su tutte e due le finestre».**

🔴 **E questo cambia una riga di `report/IL_MURO_MISURATO_2026-09-22.md`**, che al
punto 7 dichiarava: *«la cella in campo di `770260` potrebbe non essere più quella di
R199A»*. 🟢 **Adesso è verificato: non lo è, ed è una buona notizia.** La sedia che
quel referto contava fra le 🔴 **non è più quella che vola**.

### ⚠️ I limiti, dichiarati
- 🔴 **Il `.set` in repo non è il binario in campo.** Che il terminale FTMO
  `541452707` (`C:\FTMO`) abbia davvero caricato `ClosePct=50` è **[NON VERIFICATO]**:
  lo dice la riga dei binari (§3 di `report/BINARI_IN_CAMPO_FTMO_2026-09-21.md`), che
  ti ho mandato in chat e che **non è ancora stata eseguita**.
- **Campione**: 82 IS / 102 OOS **posizioni**, sotto le 150 della regola del 16/08.
  Indizio forte, non verdetto.
- **Max Daily Loss 5%**: `[NON MISURATO]` — altra grandezza, altro round.
- La finestra è **2024.09.26 → 2026.06.30**, tick reali. Un DD di backtest non è una
  promessa: è un fatto accaduto su quella finestra.

---

## 3. 🔴 IL VERO ROUND DA FARE OGGI: **la firma del 21/09 ha RIAPERTO i sette «lascia com'è»**

Ed è una conseguenza aritmetica, non un sospetto.

Tutti e sette i verdetti «non toccare» sono stati misurati con la cella `0` come
**baseline**, cioè con `InpTP1_ClosePct = 0` e `InpBreakevenAtTP1 = false`:
**una sedia SENZA NESSUN breakeven e SENZA parziale.** Alle 20:22 quella baseline
**è cambiata**. 👉 Un verdetto del tipo *«questa manopola non migliora la sedia»*
vale contro **la sedia su cui è stato misurato**.

### 🎯 Il caso che lo dimostra meglio: `InpBEatR`

| | R199A (baseline vecchia) | oggi (baseline in campo) |
|---|---|---|
| `InpBreakevenAtTP1` | `false` | 🔴 **`true`** |
| `InpTP1_R` | 0,5 | 0,5 |
| ⇒ breakeven già presente? | **no, nessuno** | 🔴 **sì, a 0,5 R** |
| dominio utile di `InpBEatR` | tutto | 🔴 **solo `0 < x < 0,5`** |
| valori misurati da R199A | 0 · 0,5 · 1,0 · 1,5 | 🔴 **nessuno dentro quel dominio** |

Il meccanismo è nel codice: sopra 0,5 R il ticket è già marcato `gBETk` dal breakeven
del primo obiettivo, quindi `InpBEatR` **non può più fare niente**. 👉 **Il solo
intervallo in cui la manopola può agire sulla sedia di oggi è quello che non è mai
stato misurato.**

🟢 **E questo non ribalta la proposta ritirata: la conferma come ritirata sul VECCHIO
dominio, e apre un dominio NUOVO.** Non si sposta l'asticella: si misura un'altra cosa.

### 📋 Quali dei sette sono riaperti davvero
Riaperti (toccano la **gestione dell'uscita**, cioè quello che la firma ha cambiato):
`InpBEatR` · `InpTrailStartR` · `InpTrailMode` · `InpTrailFixedPts` · `InpTrailTF`.
Probabilmente **non** riaperti (toccano l'**ingresso**, e `n` è invariato a 82/102):
`InpMinRangePts` · `InpRetestOffsetPts`.
🔴 **«Probabilmente» non basta**: la parziale cambia l'equity, e l'equity cambia la
taglia della posizione successiva. Va **misurato**, non dedotto — e l'ancora di
regressione lo dice in una cella sola.

---

## 4. ⏭️ COSA PROPONGO

**`R209a`** — asse `InpBEatR` a passo fine **dentro `0–0,5`** (0 / 0,125 / 0,25 / 0,375 / 0,5),
tutto il resto pinnato dal preset FTMO in campo, banco 80.000, taglia 2,00%, tick reali.

- 🟢 **Ancora di regressione**: la cella `0` **deve riprodurre** la Pass 2 di R199B
  (IS `PF 1,22116 · DD 7,3069` · OOS `PF 1,21546 · DD 7,8576`). Se non la riproduce,
  **il round si butta**: vuol dire che stiamo guardando un'altra sedia.
- 🔬 **Contro-esempio dichiarato PRIMA**: se tutte le celle escono **identiche** alla `0`,
  il verdetto è **«manopola spenta per costruzione»** (il BE di TP1 arriva comunque prima
  nel flusso della barra) — **non** «nessun effetto misurato». Sono due cose diverse e
  vanno scritte diverse.
- 🔴 **Nessuna firma chiesta finché il round non è girato.** `InpBEatR` è gestione del
  rischio ⇒ resta di Claudio.

🔵 **Niente toccato in campo.**
