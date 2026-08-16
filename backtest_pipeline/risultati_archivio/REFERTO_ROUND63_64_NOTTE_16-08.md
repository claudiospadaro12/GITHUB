# 🌙 R63 / R64 — LA NOTTE DEL 16/08: due screening, due verdetti

_I primi numeri dei tre EA adottati oggi dal Code Base. Screening in **OHLC**
(Modello 1), deposito 100.000, rischio 1%, walk-forward 40/60._

> ## 🚦 IN UNA RIGA
> **`TurnaroundTuesday` e' MORTO** (0 celle su 24 fuori campione, su 11.928
> trade). **`CanaleLento` non e' morto ma non e' SCEGLIBILE**: le celle verdi
> fuori campione sono le piu' rosse dentro. **`GapContinuation` non ha
> prodotto CSV** e va rilanciato.

---

# R63 — `ABTG_TurnaroundTuesday` · GBPUSD H1 · ⚰️ FAMIGLIA CHIUSA

**IS 2010.07.06 → 2016.11.26 · OOS 2016.11.27 → 2026.06.30.** Quasi **dieci
anni fuori campione**, **497 trade per cella**, **11.928 trade OOS in tutto**.

| SL×ATR | TP_R | ora | IS profit | PF | **OOS profit** | **PF** | DD% |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 0,50 | 1,0 | 8 | **+675,16** | 1,005 | **−17.918,44** | 0,914 | 27,22 |
| 0,50 | 2,5 | 8 | −139,38 | 0,999 | −36.019,80 | 0,835 | 43,71 |
| 1,00 | 1,5 | 8 | −5.443,17 | 0,940 | −28.995,73 | 0,783 | 34,06 |
| … | | | … | | … | | |
| 0,50 | 1,5 | 0 | −19.913,77 | 0,881 | −39.106,75 | 0,814 | 45,73 |

## 🔴 ZERO CELLE POSITIVE SU 24. E anche in campione ne regge una sola.

Il PF OOS sta fra **0,730 e 0,914** — *tutte* sotto 1. Il drawdown fra
**27% e 57%**. E il campione non lascia scampatoie: **497 trade per cella**,
cioe' un trade ogni martedi' per dieci anni, esattamente come previsto dalla
meccanica.

**Questo non e' rumore: e' un verdetto.**

### ✅ Il criterio era congelato PRIMA, e si applica

Dal file prova, scritto prima di qualunque numero:
> _"Se e' rosso la famiglia si chiude come `ABTG_MeanRevert`, perche' cercare
> il simbolo giusto dopo un rosso e' pesca."_

**Applicato. Famiglia chiusa.** Non si prova su D30EUR, non si prova
sull'azionario, non si riaccende il filtro ATR dell'autore.

### 📌 Cosa questo dice, e cosa NON dice

- **DICE**: l'effetto "lunedi' rosso → martedi' verde" **non esiste su GBPUSD
  H1** con questa meccanica, su 16 anni e 11.928 trade.
- **NON DICE** che l'effetto non esista sull'azionario, dove sta la
  letteratura. Ma il vincolo era scritto prima apposta: **quella frase non
  diventa una scusa per andare a pescare il mercato giusto.**

### 🎓 E dice una cosa sul METODO che vale piu' del candidato

`001 - Turnaround Tuesday` era stato promosso **due volte, da due cacce
indipendenti**: **9/10** sul buco laterale e **10/10** sullo short simmetrico.
Aveva tutto quello che il setaccio cerca: 10 input veri, zero bandiere rosse
su 16 grep, SL vero in ATR, rischio in %, e **la direzione costitutiva**
(`tradeUp = !isBullish`, nessun `AllowLong/Short` nel file).

> **Il setaccio ha fatto il suo lavoro: ha promosso una STRUTTURA sana e
> testabile in fretta. L'imbuto ha fatto il suo: l'ha uccisa in una notte.**
> E' esattamente la divisione dei compiti scritta nel §0 del cacciatore —
> _"la macchina si traduce, l'edge no"_. Un voto alto del setaccio non e'
> mai stato una previsione di profitto, e questo round lo dimostra col
> campione piu' grande che abbiamo mai avuto.

📊 **Nota tecnica confermata**: l'ingresso alle **08:00 server e' sempre
meglio che a mezzanotte** (a parita' di cella, ~10.000-20.000 di differenza).
La trappola del rollover che avevamo previsto era reale nella direzione —
ma entrambi perdono, quindi non salva niente.

---

# R64 — `ABTG_CanaleLento` · XAUUSD D1 · 🟡 NON SCEGLIBILE

**IS 2009.07.16 → 2016.04.27 · OOS 2016.04.28 → 2026.06.30.** 17 anni,
1.768 trade OOS.

**13 celle su 20 positive fuori campione**, e alcune enormi: +34.371 (PF
1,806), +33.372, +30.619 (PF 2,017), +28.281, +27.427.

## 🔴 Ma guarda quali:

| EntryP | ExitP | ExitMid | IS profit | **OOS profit** |
|---:|---:|---:|---:|---:|
| **20** | **20** | **0** | **+2.280,73** ← *la migliore IS* | **−812,26** |
| 30 | 10 | 1 | −4.931,78 ← *la penultima IS* | **+34.371,39** |
| 60 | 10 | 1 | −1.878,35 | +30.619,42 |
| 40 | 10 | 1 | −5.938,75 ← *l'ultima IS* | +28.280,67 |

> ### 🎯 La relazione IS→OOS e' ROVESCIATA: le celle piu' rosse dentro sono le piu' verdi fuori.
> **E' la quattordicesima misura di Spearman negativa su quindici.**

**La cella che il metodo sceglie** — l'unica decente in campione, `20/20/0` —
**fuori campione perde (−812,26, PF 0,976).** Le celle verdi **non erano
scegliibili**: si vedono solo guardando l'OOS, cioe' facendo esattamente la
cosa che i nostri trent'anni di ribaltamenti vietano.

📌 **Il discriminante e' `InpExitMiddle`**: tutti i grandi vincitori OOS hanno
`=1`, tutte le "migliori" IS hanno `=0`. **Un parametro che cambia segno fra
le due finestre non e' una manopola: e' un avvertimento.**

### 🏛️ E il cancello prop lo boccia comunque

| | valore |
|---|---|
| DD OOS sulla cella scelta dal metodo | **14,41%** (muro: 10%) |
| **peggior giornata** su quella cella | **−5,89%** (muro: **−5%**) |
| peggior giornata sulle celle verdi | da −2,94% a −4,96% |

**La cella che il metodo sceglie sfonda ENTRAMBI i muri prop.** Anche se
fosse stata verde, non sarebbe entrata.

### 🚦 Verdetto

**Non promosso, e non chiuso.** La famiglia mostra qualcosa (13 su 20 verdi
non e' rumore), ma **questa griglia non sa scegliere una cella — e una cella
che non si sa scegliere non e' un edge che si puo' tradare.**

Se un giorno si riapre, si riapre con una **tesi nuova scritta prima** sul
perche' `ExitMiddle=1` dovrebbe essere giusto, non ripescando la cella verde
di questa tabella. **Quella e' la definizione di overfitting.**

---

# ⚠️ R65 — `ABTG_GapContinuation` · NON PRODOTTO

Lo zip contiene i due CSV di `CanaleLento`, i due di `TurnaroundTuesday`, e
**al loro posto i due vecchi di `gapnas2`** (R62, gia' archiviati). Del
`GapContinuation` **non c'e' traccia**.

Il giro a vuoto era passato (**54 celle, controlli passati**), quindi il file
prova e la griglia sono a posto. **Da rilanciare**, e se si ferma va guardato
l'errore: 54 celle × 2 finestre su M1 e' la corsa piu' pesante delle tre.

---

## 🧭 COSA RESTA, in ordine

1. **Rilanciare `GapContinuation`** (etichetta `gc1`), l'unico dei tre ancora
   senza numeri.
2. **`TurnaroundTuesday`: chiuso.** Va tolto dalla coda e il magic 774201
   torna libero.
3. **`CanaleLento`: in vivaio, non in forward.** Nessun grafico, nessun VPS.
4. Restano i candidati non ancora scritti: **Pivot Supertrend (9/10)**, flip
   sul wick, trailing Chandelier.
5. E le modifiche ai nostri EA, che dopo stanotte pesano di piu' dei
   candidati esterni: **il disaccoppiamento TP/SL della PTE** (32 celle, zero
   codice) e **il controllo ATR sul Supertrend** (mezz'ora).

> **Il conto onesto della giornata: 2 candidati esterni misurati, 2 non
> promossi. E' il tasso normale — il setaccio promuove strutture, l'imbuto
> promuove edge, e sono due cose diverse.**
