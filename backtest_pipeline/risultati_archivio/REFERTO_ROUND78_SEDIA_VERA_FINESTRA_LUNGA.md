# 🏁 R78 — **CON LA SEDIA VERA, SU TREDICI ANNI: LE DUE SEDIE PTE SONO ENTRAMBE NEGATIVE FUORI CAMPIONE.**

_Chiude la serie R67→R78. `InpTP1_ATRmult` **pinnato a 0,5** — la
configurazione che gira davvero — sulla finestra più lunga disponibile._

**Banco:** `ABTG_PTE` · H1 · **OHLC** · 14 celle (buffer 0-30 × TP2 {2,0; 3,0}) ·
rischio 1% · `SLfromDoji=0` · **IS `2000.01.01 → 2013.03.31`** ·
**OOS `2013.04.01 → 2026.06.30`**.

**Igiene:** 4 CSV su 4, 14 celle su 14, e **il pin che conta verificato per
primo: `InpTP1_ATRmult=0.5` in tutti e quattro gli `.ini`** ✅.
**n IS 392-443 · n OOS 438-487** — campione pieno su entrambi, **selezione
autorizzata**.

---

## 1. 🪑 LE DUE SEDIE VIVE, MISURATE PER QUELLO CHE SONO

| sedia | magic | **OOS 13 anni** | PF | **DD** | n |
|---|---|---:|---:|---:|---:|
| **PTE GBPUSD** `buf 5 / TP 2,0` | 771322 | **−2.125** | **0,972** | **17,68%** | 447 |
| **PTE USDJPY** `buf 5 / TP 2,0` | 771323 | **−5.012** | **0,935** | **20,04%** | 456 |

> ### 🔴 **Su tredici anni fuori campione, con oltre 450 operazioni per cella, ENTRAMBE le sedie PTE in forward perdono soldi.**

E su GBPUSD non è nemmeno un caso isolato: **l'OOS è 12/14 positive, e le due
celle negative sono ESATTAMENTE le due della sedia viva** (`buffer 5`, entrambi
i target). **È la quarta volta che `buffer 5` finisce fra le pochissime celle
negative di una griglia** (R69, R72, R77, ora R78).

## 2. 🟢 SU GBPUSD LA CURA C'È — e stavolta il criterio la promuove davvero

Selezione col metodo (tre righe migliori in IS = `10/25/30` → centro **`25`**;
miglior TP su quella riga = **`3,0`**):

| | IS | **OOS** | PF | **DD** | pegg. GG | n |
|---|---:|---:|---:|---:|---:|---:|
| 🪑 **VIVA** `buf 5 / TP 2,0` | −14.808 | **−2.125** | 0,972 | **17,68%** | −1,71% | 447 |
| 🎯 **SCELTA** `buf 25 / TP 3,0` | −6.273 | **+4.323** | **1,095** | **9,87%** | **−1,35%** | 477 |

**+6.448 di profitto, otto punti di drawdown in meno, peggior giornata più
bassa.** E **la clausola di segno congelata ieri sera** — _"il criterio 2 vale
solo fra celle con profitto OOS positivo"_ — **è soddisfatta: la candidata
guadagna.**

> ## 🟢 **PRIMA PROPOSTA DELLA SERIE CHE PASSA TUTTI I CANCELLI, CLAUSOLA DI SEGNO COMPRESA.**

## 3. 🔴 SU USDJPY NON C'È NESSUNA CURA

| | IS | **OOS** | PF | DD |
|---|---:|---:|---:|---:|
| 🪑 VIVA `buf 5 / TP 2,0` | −4.480 | **−5.012** | 0,935 | 20,04% |
| 🎯 scelta `buf 25 / TP 3,0` | +6.626 | **−2.317** | 0,955 | 16,06% |
| miglior cella in assoluto `buf 20 / TP 3,0` | +6.207 | **+590** | 1,011 | 15,51% |

**OOS: 1 cella positiva su 14, e quell'una fa +590 euro in tredici anni con
PF 1,011** — cioè zero.

> ### 🎯 **Non è un parametro da tarare: su USDJPY, su tredici anni, questo motore non ha edge.** Conferma R77 (che senza il TP1 parziale diceva 0/28) con la configurazione vera.

## 4. 🧩 E LA COSA PIÙ INTERESSANTE: **i due simboli si ribaltano in DIREZIONI OPPOSTE**

Stessa identica finestra, stesso identico taglio:

| | IS 2000-2013 | OOS 2013-2026 |
|---|---|---|
| **GBPUSD** | **0/14** 🔴 | **12/14** 🟢 |
| **USDJPY** | **8/14** 🟢 | **1/14** 🔴 |

> **Il calendario è lo stesso. I ribaltamenti vanno al contrario.**
>
> 🎯 **È la dimostrazione più pulita che il regime è UNA PROPRIETÀ DEL
> SIMBOLO, non una data sul calendario.** La regola C dell'emendamento non
> potrebbe avere una prova migliore — e la frase «è il 2021», già ritirata in
> R76, qui muore definitivamente.

## 5. 📉 DICIASSETTESIMA E DICIOTTESIMA CONFERMA — e `buffer 5` è il PEGGIORE

**DD OOS (colonna TP 2,0):**

| buffer | 0 | **5** | 10 | 15 | 20 | 25 | 30 |
|---:|---:|---:|---:|---:|---:|---:|---:|
| **GBPUSD** | 15,90 | **17,68** 🔴 | 13,82 | 13,04 | 12,28 | 10,51 | **9,19** |
| **USDJPY** | 26,97 | 20,04 | 19,50 | 19,20 | 15,07 | 15,66 | **14,44** |

**Su GBPUSD `buffer 5` non è "quasi il peggiore": è IL PEGGIORE dei sette, peggio
perfino dello stop nudo.** La tendenza generale regge (da 27% a 14% su USDJPY),
la monotonia stretta no — come già visto in R77.

### 🧱 E i muri della prop, con la sedia VERA (rischio 0,65%)

| | DD OOS scalato | muro del 10% |
|---|---:|---|
| **PTE GBPUSD viva** | **11,5%** | 🔴 **SFONDATO** |
| **PTE USDJPY viva** | **13,0%** | 🔴 **SFONDATO** |
| GBPUSD `buf 25 / TP 3,0` | **6,4%** | ✅ |
| USDJPY `buf 30 / TP 3,0` | 9,7% | ✅ per un soffio |

📌 **La frase che avevo dovuto ritirare in R76 adesso torna valida, e con il
numero giusto: su tredici anni entrambe le sedie PTE avrebbero rotto il muro
della prop.**

---

## 6. 🚦 VERDETTO

> **1. 🔴 Entrambe le sedie PTE in forward sono NEGATIVE su tredici anni fuori
> campione, con campione pieno e la configurazione vera.**
>
> **2. 🟢 Su GBPUSD esiste una cella che le passa tutte** (`buf 25 / TP 3,0`:
> **+4.323, PF 1,095, DD 9,87%**) — scelta col metodo, criterio 2 e clausola di
> segno soddisfatti. **È la prima proposta legittima della serie.**
>
> **3. 🔴 Su USDJPY nessuna cella salva il motore: 1/14 positive, e quell'una
> fa +590 in tredici anni. Non è un parametro: è il motore su quel simbolo.**
>
> **4. 🧩 I due simboli si ribaltano in direzioni opposte sulla stessa
> finestra: il regime è del simbolo, non del calendario.**
>
> **5. 🧱 A 0,65%, entrambe le sedie vive sfondano il muro del 10%.**

## 7. ⚖️ IL CONFLITTO CHE RESTA APERTO — e va detto, non nascosto

| banco | cosa dice su GBPUSD |
|---|---|
| **R73** — tick reali, **2 anni** (2024-2026) | la **viva vince**: +2.091 contro +1.172 della candidata |
| **R78** — OHLC, **13 anni** (2013-2026) | la **viva perde**: −2.125 contro +4.323 della candidata |

**Non è un errore di nessuno dei due: sono due domande diverse.** Il biennio
2024-2026 è dentro un'epoca buona per la config viva; i tredici anni no. **Ed è
esattamente il fenomeno che questa serie ha misurato tre volte: le epoche si
alternano.**

🔴 **E non è risolvibile con i dati che abbiamo**: i tick reali di BCM partono
dal 2024.07.05. **O la finestra lunga o il riempimento vero.**

## 8. 🎯 LA DECISIONE, E NON È MIA

**Quello che è misurato:** su tredici anni la sedia GBPUSD perde e la candidata
guadagna; su due anni a tick reali è il contrario; entrambe le sedie sfondano
il muro prop a 0,65%; su USDJPY non c'è niente da tarare.

**Le tre strade, con quello che costano:**

| | strada | pro | contro |
|---|---|---|---|
| **A** | 🟢 **Affiancare** `buf 25 / TP 3,0` su GBPUSD con magic nuovo (`771332`), rischio 0,5% su entrambe | non tocca niente, misura in forward chi ha ragione | ci vogliono ~7 mesi per 30 trade |
| **B** | 🔧 **Cambiare** la sedia GBPUSD a `buf 25 / TP 3,0` | agisce sull'evidenza più lunga che abbiamo | contraddice il banco a tick reali |
| **C** | ⏸️ **Non fare niente** | coerente con dieci round di criterio 3 | si tiene una sedia che su 13 anni perde e sfonda il muro |

🪑 **Su `PTE USDJPY` (771323) la domanda è diversa e più seria: non "quale
taratura" ma "questa sedia ci sta a fare qualcosa?".** Una cella su quattordici
positiva in tredici anni non è una taratura da aggiustare.

**Io propongo A per GBPUSD** — è l'unica che aggiunge informazione invece di
scommettere su quale dei due banchi ha ragione — **e per USDJPY di aprire la
discussione sulla sedia, non sul parametro.**

🔴 **Ma non ho toccato niente, e non lo farò senza la tua parola.**
