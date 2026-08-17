# 🔴 R77 — **SU TREDICI ANNI, `PTE USDJPY` PERDE IN TUTTE E 28 LE CELLE.**

_Seconda gamba di R76. Criteri congelati in `prove/R77_PTE_FINESTRA_LUNGA_FAMIGLIA.md`
prima di aprire lo zip._

**Banco:** `ABTG_PTE` · USDJPY H1 · **OHLC** · 28 celle · rischio 1% ·
**IS `2000.01.01 → 2013.03.31`** · **OOS `2013.04.01 → 2026.06.30`**.
Igiene: 2 CSV su 2, 28 celle su 28, `FromDate` onorata.
**n IS 390-600 · n OOS 410-681** — campione pieno, selezione autorizzata.

---

## 0. ✍️ PRIMA LA CORREZIONE, E RIGUARDA ANCHE R76

**`R76` e `R77` hanno girato con `InpTP1_ATRmult = 0`**, non con lo `0.5` delle
sedie del vivaio. È lo **stesso difetto che avevo trovato fra R72 e R73** — il
file `PTE_FINESTRA_VECCHIA_O_RECENTE.txt` non pinna quel parametro, quindi
passa il default del sorgente.

**Cosa cambia:**
- ✅ **I confronti DENTRO ogni round restano validi**: tutte e 28 le celle
  hanno lo stesso `TP1`, quindi *"buffer 25 contro buffer 5"* è un confronto
  onesto.
- 🔴 **Ma la riga che in R76 ho chiamato "VIVA" NON è la sedia viva.** Va letta
  come **`buffer 5 senza TP1 parziale`**. In particolare **la frase di R76 «su
  tredici anni la configurazione viva avrebbe sfondato il muro della prop» è
  RITIRATA**: quel 13,7% è di una configurazione che in forward non gira.
- 📌 E non è un dettaglio: fra R72 e R73 quel solo pin aveva **ribaltato il
  segno** su USDJPY (−837 → +979).

**Etichetta corretta usata da qui in poi: `buf 5 (TP1=0)`.**

## 1. 🔴 IL NUMERO DEL ROUND

| | celle positive |
|---|---|
| **IS 2000-2013** | 10 / 28 |
| **OOS 2013-2026** | **0 / 28** 🔴 |

**Profitto OOS, tutte e 28 le celle: da −1.473 a −23.499.**
Su **410-681 operazioni per cella** e **tredici anni**.

| buffer | TP 1,5 | TP 2,0 | TP 2,5 | TP 3,0 |
|---:|---:|---:|---:|---:|
| **0** | −23.499 | −21.197 | −19.085 | −16.774 |
| 5 | −15.744 | −13.466 | −11.813 | −9.777 |
| 10 | −9.464 | −7.058 | −5.710 | −3.841 |
| 15 | −9.105 | −6.754 | −5.385 | −3.626 |
| **20** | −6.633 | −4.534 | −3.155 | **−1.473** |
| 25 | −7.105 | −5.257 | −4.023 | −2.495 |
| 30 | −5.890 | −4.195 | −3.071 | −1.664 |

> ### 🎯 **Non c'è una taratura da trovare: su questa finestra il motore su USDJPY perde comunque. Il buffer decide solo QUANTO.**

## 2. 🧩 E COMBACIA CON R69 — il colpevole è il **2013-2016**

| finestra | fonte | esito |
|---|---|---|
| USDJPY OOS **2016-2026** | R69 | **25/28 positive** 🟢 |
| USDJPY OOS **2013-2026** | **R77** | **0/28** 🔴 |
| USDJPY IS **2010-2016** | R69 | **0/28** 🔴 |

Le tre righe si spiegano con una cosa sola: **il triennio 2013-2016 è
catastrofico per questo motore su questo simbolo** — è il cuore
dell'Abenomics, lo yen da 100 a 125 in linea retta, e un motore di
mean-reversion ci sbatte contro per costruzione.

**Aggiungerlo all'OOS ribalta il segno di tredici anni.** È la conferma più
forte della **regola C** che abbiamo: *il regime conta più della lunghezza.*

## 3. ⚖️ LA DOMANDA 1 — risposta formale SÌ, sostanziale NO

Selezione col metodo (tre righe di buffer migliori in IS = `20/25/30`, centro
= **`25`**; miglior TP su quella riga = **`3,0`**):

| | IS | **OOS** | PF | **DD** | pegg. GG | n |
|---|---:|---:|---:|---:|---:|---:|
| `buf 5 (TP1=0) / TP 2,0` | −12.906 | **−13.466** | 0,858 | **21,09%** | −2,06% | 458 |
| 🎯 **scelta col metodo** `buf 25 / TP 3,0` | +2.648 | **−2.495** | 0,958 | **15,26%** | −1,73% | 642 |

**La cella scelta perde 10.971 euro in meno e ha 6 punti di drawdown in meno.**
Formalmente il criterio 2 è soddisfatto — *abbassa il DD senza perdere
profitto* — **ma perdono tutte e due.**

> 🔴 **E qui il criterio, applicato alla lettera, direbbe una sciocchezza:
> "promuovi la cella che perde meno". Non si promuove niente che perde.**
> Lo scrivo come buco del criterio invece di aggirarlo: **il criterio 2 non ha
> una clausola di segno, e andrebbe aggiunta — PRIMA del prossimo round, non
> dopo.**

📌 **E una metrica che ho usato in R76 va sospesa qui**: il *"% dell'ottimo
catturato"* con numeri tutti negativi dà **169,4%**, che non vuol dire niente.
**Non si usa quando il migliore è negativo.**

## 4. 📉 IL BUFFER E IL DRAWDOWN — la tendenza regge, la monotonia no

| buffer | 0 | 5 | 10 | 15 | 20 | 25 | 30 |
|---:|---:|---:|---:|---:|---:|---:|---:|
| **DD IS** | 13,28 | **14,60** | 11,85 | **14,00** | 8,11 | 7,42 | **6,67** |
| **DD OOS** | **32,10** | 21,09 | 19,31 | 18,73 | 14,97 | **15,99** | **13,83** |

**Da 32% a 14% fuori campione: la tendenza è violenta e chiara.** Ma
**la monotonia stretta si rompe** (buffer 5 in IS, buffer 25 in OOS).
**Quindicesima e sedicesima conferma della TENDENZA; la monotonia perfetta
vista finora era una proprietà delle finestre corte, non una legge.**

🧱 **Muri prop a 0,65%**: `buffer 0` fa **20,9%** — il doppio del muro del
10%. `buffer 30` fa **9,0%**, appena dentro. **Ma su un motore che perde, il
muro è la seconda preoccupazione.**

📊 **Spearman IS→OOS = +0,889**, la più alta mai misurata qui. Non è
predittività del metodo: è **un asse fisico che ordina allo stesso modo in
entrambe le finestre**.

---

## 5. 🚦 VERDETTO

> **1. 🔴 Su tredici anni fuori campione, con 410-681 trade per cella,
> `PTE USDJPY` perde in TUTTE e 28 le configurazioni. Non è un problema di
> taratura.**
>
> **2. 🧩 Il colpevole ha un nome: il 2013-2016. Aggiungerlo all'OOS ribalta
> il segno di tredici anni.** Regola C confermata nel modo più forte.
>
> **3. ⚖️ La selezione col metodo funziona (perde 11.000 in meno, 6 punti di
> DD in meno) ma su celle tutte negative: il criterio 2 non ha una clausola di
> segno, ed è un buco da chiudere prima del prossimo round.**
>
> **4. ✍️ R76 e R77 hanno `TP1 = 0`, non lo `0.5` della sedia viva. Ritirata
> la frase di R76 sul muro della prop.**

## 6. ⛔ E QUESTO **NON** È UN VERDETTO SULLA SEDIA IN FORWARD

**`PTE USDJPY` (magic 771323) gira con `TP1 = 0,5`, che qui non c'è.** Fra R72
e R73 quel solo pin ha ribaltato il segno su questo stesso simbolo. **Quindi:
non si conclude niente sulla sedia viva da questo round.**

Ma è abbastanza per **alzare il livello di sospetto** e per rendere prioritaria
la corsa che segue.

## 7. ➡️ R78 — LA CORSA CHE CHIUDE IL CERCHIO

**Stessa finestra lunga (2000-2026), stessa griglia, `InpTP1_ATRmult` PINNATO
A 0,5**, su **entrambi i cambi**. Il file prova con quel pin **esiste già**:
`prove/PTE_TICK_REALI_SEDIA_VIVA.txt` (nato per R73).

**Le due domande, scritte adesso:**
1. Con il TP1 parziale acceso, l'OOS di USDJPY **resta 0/28** o si ribalta come
   fece fra R72 e R73?
2. Su GBPUSD la conclusione di R76 (la selezione batte la viva su entrambi i
   fronti) **regge con la sedia vera dentro?**

**E prima dei numeri, il criterio che mancava, da congelare adesso:**
> _Il criterio 2 vale **solo fra celle con profitto OOS positivo**. Se la
> candidata o il termine di paragone perdono, non c'è promozione: c'è un
> motore da guardare, non un parametro da tarare._
