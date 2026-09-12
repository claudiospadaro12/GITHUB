# 🔬 R123 BLOCCO B — **COSA AGGIUNGE LA RICOSTRUZIONE DA ZERO** (e cosa NO)

**12/09/2026.** Il cancello, chiudendo il blocco D, ha consigliato di rifare su
B e C la stessa ricostruzione dai CSV grezzi — *"visto com'e' andata qui"*.
Fatto su **B**. Questo **non e' un nuovo referto del blocco B**: quello esiste
(`report/R123_RISULTATI_2026-09-09.md`) ed e' gia' stato **corretto** dall'errata
del 12/09 su A4 e A7. Qui sta **solo cio' che la ricostruzione AGGIUNGE**.

🪞 **Le due lezioni di stamattina, applicate PRIMA di toccare un numero:**
- **classe 258** — file prova aperto per primo: `R123b_U30USD_01_stmult.txt`,
  criteri A1-A8 e **attesa cella per cella** alle righe 140-190;
- **classe 269** — cercato **chi aveva gia' letto questi CSV**: tre file
  (`R123_RISULTATI_2026-09-09.md`, `ROUND_ALTOPIANO_SUPREV_2026-09-09.md`,
  `IL_WIP_E_DIAGNOSTICA_2026-09-12.md`). Quello che dicono gia', **qui non lo
  rivendico**.
- E il **magic riletto dal CSV**: **784110** _(il blocco C e' 784120, il D
  784130: tre magic diversi per tre blocchi — copiarlo dal referto accanto e'
  proprio l'errore pagato stamattina)_.

> 🚫 **PERIMETRO**: si legge e basta. Nessun EA, preset, sedia o backtest.

---

## ✅ Cosa CONFERMA (e che era gia' scritto — nessun merito mio)

I 40 numeri rifatti da zero **tornano tutti**. `A1` fallita (una sola cella
ammessa, `3,5`). `A3` **zero cloni**. `A8` centrata **2 volte su 3** da
`StMult 4,5` — ma **questo il referto del 09/09 lo dice gia'** (riga 74 in
tabella e riga 80: *"la regola asimmetrica congelata prima fa il suo
mestiere"*). E `A4`/`A7` sono gia' nell'errata del 12/09.

---

## 🆕 QUELLO CHE LA RICOSTRUZIONE AGGIUNGE

### 1. 📉 **LA CATENA DI STIMA SI E' ROTTA — esattamente dove il file prova diceva che era debole**

Il file prova (r.140-160) non si era limitato a sperare: aveva costruito una
**stima derivata** del PF OOS cella per cella, passando da OHLC a tick (banda
misurata su 8 coppie: da +0,054 a +0,157) e da periodo intero a OOS (rapporto
**1,202**). E aveva dichiarato il proprio punto debole:

> *"Questo rapporto e' misurato su **UNA cella sola**. E' **l'anello debole
> della catena** e va detto: se le altre celle hanno un'asimmetria IS/OOS
> diversa, la stima sbaglia."*

**L'anello debole si e' rotto:**

| StMult | PF OOS **atteso** | PF OOS **misurato** | scarto | com'era ottenuto |
|---|---|---|---|---|
| 2,5 | ~**1,18** [1,11-1,24] | **0,91405** | **−0,266** | 🔴 **STIMATO** |
| 3,0 | ~**1,25** | **0,95320** | **−0,297** | 🔴 **STIMATO** |
| 3,5 | **1,43648** | **1,38944** | −0,047 | ✅ **MISURATO** (ancora) |

➡️ **Le due celle STIMATE sbagliano di ~0,28 di PF; quella MISURATA riproduce
entro 0,05.** La catena di stima ha aggiunto **circa un quarto di punto di
Profit Factor di errore**, e sempre **nella direzione ottimista**.

⚠️ **Perche' conta oltre R123**: quella catena — *OHLC → tick* piu' *periodo
intero → OOS*, **calibrata su una cella sola** — non e' roba di questo round.
E' un metodo. **Da qui in avanti va usata per stimare l'ORDINE DI GRANDEZZA,
mai per decidere**, e chi la usa deve scrivere la banda ±0,3, non ±0,1.

### 2. ✅ **E il contrappeso, che va detto: sul CAMPIONE la stima e' stata OTTIMA**

| StMult | n OOS atteso | misurato |
|---|---|---|
| 2,5 | ~252 | **261** |
| 3,0 | ~198 | **200** |
| 3,5 | 155 | **152** |
| 4,0 | ~121 | **112** |
| 4,5 | ~94 | **117** |

**Cinque previsioni su cinque vicine**, tre entro il 5%. 👉 Quindi la conclusione
precisa non e' *"la catena di stima non vale niente"*, e': **prevede bene il
CAMPIONE e male il PROFIT FACTOR.** Ha senso — `n` dipende dalla geometria del
segnale, il PF dipende da come vanno i singoli trade.

### 3. 🛑 **IL RAMO "ERA RUMORE" E' SCATTATO — ma la "scoperta" che gli era attribuita NON C'E'**

Il file prova aveva dichiarato **prima dei numeri** il proprio test di
falsificazione:

> *"SE ERA RUMORE mi aspetto **3.0 sotto 1.05** — il che **contraddirebbe** il
> suo numero a tick di periodo intero (**1.040 con l'IS rosso dentro**) e
> **sarebbe gia' di per se' una scoperta**."*

**Misurato: `StMult 3,0` fa PF OOS 0,95320 → sotto 1,05. Il ramo e' scattato.**

🔴 **Ma prima di annunciare la scoperta ho controllato la PREMESSA** — ed e'
sbagliata:

```
StMult 3,0   IS : Profit +108,26   PF 1,08369   n 144   <- l'IS e' VERDE
             OOS: Profit -123,22   PF 0,95320   n 200
             periodo intero (archivio, a tick): 1,040
```

Il file prova dava quella cella con **"l'IS rosso dentro"**. **Non e' rosso: fa
+108,26 e PF 1,084.** E allora un periodo intero a **1,040**, **fra** un IS a
1,084 e un OOS a 0,953, e' **perfettamente coerente**: nessuna contraddizione,
e quindi **nessuna scoperta**.

➡️ **Il ramo di falsificazione ha funzionato come test** (ha separato "vero" da
"rumore", e ha detto rumore), **ma il bonus che si era promesso era appoggiato a
una premessa sbagliata sulla cella.** Va tolto dal tabellino, non incassato.

_(E' la regola del 10/09 applicata a me stesso: stavo per scrivere "il ramo
dichiarato e' scattato, e il file prova diceva che sarebbe stata una scoperta" —
che e' vero a meta' e suona benissimo. Controllare la premessa l'ha ucciso.)_

---

## 🚦 Cosa cambia nel verdetto di R123

**Niente.** `A6` — *"non c'e' una configurazione robusta"* — regge, e reggeva
gia'. Questa ricostruzione **non riapre il blocco B**: aggiunge un fatto di
**metodo** (la catena di stima) e **toglie** un bonus mai guadagnato.

⚠️ **E una cosa NON l'ho fatta**: la stessa ricostruzione da zero sul **blocco C**.
Li' i 56 numeri sono gia' stati rifatti **tre volte** (due da me, una dal
cancello) e l'attesa e' gia' confrontata nel suo referto — ma **l'attesa di C
non e' stata esaminata con questa lente**, cioe' chiedendosi *quali celle erano
STIMATE e quali MISURATE*. Resta aperto, dichiarato, e costa poco.

## 📎 Fonti

- CSV: `backtest_pipeline/risultati_prove/r123_dal_vps/..._{IS,OOS}_R123BSTMULT.csv`
- File prova: `backtest_pipeline/prove/R123b_U30USD_01_stmult.txt` (attesa r.140-190, criteri r.193-237)
- Referto del blocco B: `report/R123_RISULTATI_2026-09-09.md` + **errata del 12/09** su A4 e A7
- Blocchi C e D: `R123_BLOCCO_C_2026-09-12.md` · `R123_BLOCCO_D_2026-09-12.md`
