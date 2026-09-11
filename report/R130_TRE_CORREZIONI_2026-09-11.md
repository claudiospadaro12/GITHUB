# 🔧 R130 — il round è pronto, e **corregge tre cose che avevo detto io a Claudio**

Tutte e tre **verificate da me nel sorgente e nei file**, non prese dal riassunto.

---

## ❌ 1. *"Sostituisce il TP a multipli di rischio"* — **tocca il PARZIALE, non il TP totale**

`NextRoundLevel` compare **UNA sola volta** in tutte le 2.367 righe dell'EA
(r.1906), e sta **dentro** questo blocco:

```
//--- 1) PARZIALE al primo obiettivo
if(!partialDone && InpTP1_ClosePct > 0 && InpTP1_ClosePct < 100)
   ...
   if(InpUseRoundLevels && InpRoundStep > 0)
      target = NextRoundLevel(openP, dirSign, InpRoundStep, InpRoundMinDistPts*_Point);
   else
      target = openP + dirSign*riskDist*InpTP1_R;
```

| cosa | i tondi lo toccano? |
|---|---|
| **TP TOTALE** (`3 × InpTP1_R`) | 🔴 **NO** |
| **STOP** | 🔴 **NO** |
| **bersaglio del PARZIALE** | ✅ sì |
| **momento del breakeven** (vive nello stesso blocco) | ✅ di rimbalzo |

🔴 **E con `InpTP1_ClosePct = 0` oppure `100` la manopola è un NO-OP TOTALE.**
👉 La domanda diventa: *"un **parziale** (e il BE dietro) sul livello batte un
parziale a 1R?"*. Il TP finale resta a 3R in tutte e 29 le celle.

🔴 **E la metà "STOP sul livello" del metodo di Claudio, NEL CODICE NON ESISTE.**
Gliel'avevo lasciata credere possibile. **Non lo è, oggi.**

---

## ❌ 2. *"Mai accesa in 5.068 corse"* — **l'enunciato giusto è "mai MISURATA"**

`[MISURATO da me]`:
```
mql5/Presets/ABTG_Nasdaq_Live5m.set:50     InpUseRoundLevels=true
mql5/Presets/ABTG_Nasdaq_Apertura_US.set:49 InpUseRoundLevels=true
```
👉 **In due preset del repo è ACCESA.** Il secondo è un preset di sedia: magic
**770201**, con `InpRoundStep=100.0`, `InpRoundMinDistPts=300`, parziale 50.

### 🔴 E qui c'è la cosa seria, che ho misurato dopo
| | |
|---|---|
| righe di CSV con **magic 770201** | **2.039** |
| valori di `InpUseRoundLevels` in quelle righe | 🔴 **`{'0': 2039}`** — tutte spente |

> ## 🔴 **Il preset di quella sedia aveva i tondi ACCESI, e tutte e 2.039 le misure d'archivio su quella sedia sono state fatte con i tondi SPENTI.**
> **L'archivio non descrive la sedia.** È la stessa classe del conflitto di DD
> della `770101` chiuso stamattina — e la terza volta oggi.

🟢 **Non è un rischio vivo**: la `770201` è **spenta dal 18/08** (FIRMA 5) e non
aveva mai avuto un contratto. **Ma va a verbale**, perché i numeri con cui è
stata giudicata descrivevano un'altra configurazione.

---

## ❌ 3. LA TRAPPOLA DELLE UNITÀ — due input adiacenti, **due unità diverse**

`[MISURATO nel codice]`:

| input | come viene usato | unità |
|---|---|---|
| `InpRoundStep` | **nudo sul prezzo** (`MathCeil(price/stepPrice)*stepPrice`) | **PUNTI INDICE** |
| `InpRoundMinDistPts` | `* _Point` alla riga 1906 | **PUNTI MT5** |

🔴 **Il default compilato `InpRoundMinDistPts = 50` vale MEZZO PUNTO INDICE** su
D30EUR — cioè **0,29× lo spread**: la distanza minima è **di fatto spenta**.

⚠️ **E la trappola vera**: chi scrivesse `68` credendo di mettere il pavimento di
costo (68,0 punti indice) metterebbe **0,68 punti indice** → no-op, celle
identiche, e **un referto che conclude il falso con numeri veri.**

---

# 🎯 LA GRIGLIA — 5 file, **29 celle**, 58 passate, ~6,8 minuti

| file | asse | celle |
|---|---|---:|
| **R130a** 🥇 *primo* | `InpUseRoundLevels` 0/1, **ai default compilati** | 2 |
| R130b | idem, alla cella **pulita di costo** (Step 25, MinDist 6800) | 2 |
| **R130c** | `InpRoundStep` 10→100, MinDist 6800 | 10 |
| R130d | `InpRoundMinDistPts` 0→10000 | 6 |
| 🎯 **R130e** | `InpRoundStep` **96→104** — **IL PLACEBO** | 9 |

🔑 **R130a per primo perché è il cancello dell'ancora**: se non riproduce
(445 / +2.207,74 / PF 1,29574 / DD 6,8866%), il round si ferma dopo **20
secondi**, non dopo sette minuti.

## 🧪 IL CONTRO-ESEMPIO — ed è il pezzo migliore della consegna

**R130e**: nove passi da 96 a 104. **Solo il 100 mette la griglia sui tondi.**
Contaminazione contata nella banda DAX 18.800-25.900: passo 96 → **4%**,
passo 104 → **3%**, passi coprimi → **1 solo punto**. **Contrasto 100% contro 1-4%.**

### 🔴 E il numero che ci avrebbe fatto certificare il falso
La risposta ingenua sarebbe: *"sotto l'ipotesi nulla vedrei lo stesso 36,9% di
tocchi"*. 🔴 **NO.** Il tasso di tocco è **convesso** nella distanza: per Jensen,
una cella con la stessa distanza **media** ma **variabile** tocca **di più anche
se i tondi non contano niente.**

| | tasso di tocco |
|---|---|
| controllo (distanza fissa 49,10) | **36,9% [MISURATO]** |
| cella accesa, **sotto IPOTESI NULLA** | 🔴 **36,3-50,7%, centrale 42,4%** |

**+15% relativo di pura matematica.** 👉 **La soglia non è 36,9%: è 42,4%.**

✅ **E la soluzione è elegante**: le nove celle del placebo hanno **la stessa
distribuzione** e quindi **la stessa correzione di Jensen** → **i loro tassi di
tocco SONO l'ipotesi nulla, misurata invece che modellata.**
**Test congelato: il 100 si confronta con la retta dei suoi otto vicini**, non
col 36,9% e non col 42,4%.

---

## 🔴 E L'AVVERTENZA CHE VALE PIÙ DELLA GRIGLIA
**Anche il CONTROLLO è sotto il pavimento di costo**: il parziale a 1R vale
**49,10 idx = 28,9× = 72% del pavimento**. **Non è colpa dei tondi: è lo stato
della sedia viva.**

## 📢 L'ATTESA, scritta prima dei numeri
> **Mi aspetto che il default VINCA.** Il parziale a 1R si adatta al range del
> giorno (stop = range + 3 idx); **il livello tondo non sa niente della
> volatilità di quella mattina.** Se i numeri mi danno torto, tanto meglio — ma
> l'attesa è questa, ed è scritta prima.

## ✅ CANCELLI
`controlla_prova.py` → **5 file, 29 celle, 58 passate, 0 problemi**
`controlla_riga.py --oggetto prova` → **5/5 ASCII puro, nessun difetto**
Magic **779830/779880/779890/779900/779980** verificati **vergini**.
🔴 Manca il controllo di giudizio · 🔴 e il round **non può ancora girare**.

## 🟠 SEGNALATO PER CLAUDIO
Il **Dow `770202`** ha la stessa manopola e il buco si chiude con **4 passate**.
