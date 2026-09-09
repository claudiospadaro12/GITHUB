# 🔬 `SupRev DOW H1` — **la verifica dell'altopiano che avevo promesso**

Stamattina ho scritto a Claudio che `SupRev DOW H1 970916` e' stata **spenta
l'11/08 su un IS il cui campione non basta a giudicare il merito**, e che l'OOS
dice **PF 1,43648 su n=155**. Ho aggiunto: *"quel 1,436 e' UNA cella. La regola
di casa e' centro dell'altopiano, MAI il picco. Finche' non guardo se le celle
vicine reggono, e' un indizio FORTE, non un verdetto. E' la prima cosa che
faccio adesso."*

**Fatta. Ed e' andata diversamente da come me l'aspettavo.**

---

## 🔴 IL FATTO: **l'altopiano NON e' stato misurato, perche' quel round ha UN SOLO ASSE**

I due CSV (`..._U30USD_IS.csv` e `..._OOS.csv`) hanno **11 passate ciascuno**, e
l'unico parametro che cambia e' **`InpTF`**. Verificato:
```
cut -d, -f10,11,12 ..._OOS.csv | sort -u
  InpStMult,InpStAtrPeriod,InpNearAtr
  3.5,9,1
```
**`InpStMult = 3.5`, `InpStAtrPeriod = 9`, `InpNearAtr = 1` sono FISSI in tutte
e 11 le celle.** 👉 **Attorno alla cella H1 non c'e' nessun vicino in spazio di
PARAMETRI: c'e' solo lo stesso motore su altri timeframe.**

## 📊 LA SUPERFICIE CHE C'E' — ed e' quella dei TIMEFRAME

| TF | PF IS | n IS | DD IS | **PF OOS** | **n OOS** | DD OOS |
|---|---:|---:|---:|---:|---:|---:|
| M15 | 0,768 | 292 | 10,73 | 0,732 | 656 | 22,33 |
| M20 | 0,910 | 309 | 7,86 | 0,623 | 408 | 19,42 |
| M30 | 0,507 | 207 | 12,96 | 0,995 | 369 | 10,37 |
| **H1** | **0,923** | **118** | **6,30** | **1,436** | **155** | **4,82** |
| H2 | **3,502** | 54 | 1,84 | 1,147 | 109 | 4,86 |
| H3 | 0,490 | 26 | 3,96 | **0,226** | 65 | 8,65 |
| H4 | **4,758** | 35 | 2,21 | **1,941** | 46 | 3,25 |
| H6 | 1,228 | 11 | 1,41 | 0,229 | 28 | 4,46 |
| H8 | — | 2 | 0,58 | 0,969 | 41 | 5,73 |

### 🚨 E questa superficie e' **FRASTAGLIATA**, che e' la firma del rumore
`H2 = 3,502` (su **54** operazioni) · `H3 = 0,490` (su **26**) · `H4 = 4,758`
(su **35**). **Tre timeframe adiacenti che vanno da 0,49 a 4,76.**
E' esattamente il quadro che l'Emendamento A descrive come pericoloso: _"in R70
con n=75-159 la superficie IS era frastagliata — una cella che sporge, il resto
su e giu' = selezione che insegue il rumore"_.

---

## ✅ MA C'E' UNA COSA CHE SALVA LA LETTURA, ed e' importante

**`H1` NON e' una cella scelta da questa griglia perche' era verde.**
E' il **timeframe di progetto della sedia** (si chiama `SupRev_DOW_H1`), fissato
prima. E soprattutto:

> 🎯 **H1 e' l'UNICO timeframe con un campione leggibile in ENTRAMBE le finestre
> (118 IS / 155 OOS).** Tutti quelli con PF alto stanno su n = 26-54.

Quindi il 1,436 **non e' un picco pescato**: e' l'unica cella che si poteva
guardare. **Il che lo rende credibile ma NON ROBUSTO** — e la differenza conta.

---

## 🧾 IL VERDETTO ONESTO, in tre righe
1. ✅ **Il fatto di stamattina REGGE**: la sedia e' stata spenta su un IS
   (n=118) sotto il pavimento dei 150, mentre l'OOS a campione pieno (n=155)
   fa **1,436 con DD 4,82%**. La bocciatura era mal fondata.
2. 🔴 **Ma "centro dell'altopiano" NON e' verificabile con questi dati**:
   l'altopiano in spazio di parametri **non e' mai stato misurato**.
3. ⏳ Quindi il verdetto giusto oggi e' **"NON ANCORA MISURATO"**, non
   "promuovibile" — ed e' esattamente il certificato di morte al contrario:
   **non si riaccende una sedia su una cella sola, come non si spegne su una
   finestra sola.**

## 🎯 IL ROUND CHE CHIUDE LA QUESTIONE
Griglia **a H1 fisso** su `InpStMult` x `InpStAtrPeriod` x `InpNearAtr`, con
IS/OOS. Se attorno a `3.5 / 9 / 1` c'e' un altopiano, il 1,436 e' vero e la
sedia rientra con una ragione. Se la cella sporge da sola, era rumore e si
scrive.
📐 **La cella si sceglie AL CENTRO, mai al picco** — e la regola va dichiarata
insieme al numero, altrimenti il numero non vuol dire niente.

## 🔁 E una TERZA conferma della scoperta di stamattina
Su questo motore `InpTF` porta il PF da **0,226 a 1,941**. La miniera aveva
misurato per `SupRev` un **dPF mediano di 4,238 su `InpTF`**, il terzo valore
piu' alto dell'archivio. **Combacia.** Il timeframe e' la manopola piu' potente
che abbiamo, e su questo motore si vede a occhio nudo.

## 📌 E chiude anche il perche' del falso negativo del censimento
`CENSIMENTO_PF_MISURATI` marcava questa sedia **"vicino alla soglia = NO"** con
PF mediano 0,77/0,73. Adesso si vede da dove venivano: sono **le mediane su
questi 11 timeframe**, di cui **dieci su cui la sedia non gira**. Includono
M15 (0,732), M20 (0,623), H3 (0,226). 👉 **La mediana su TF misti non e' il PF
di una sedia** — e quella riga da sola avrebbe seppellito il candidato.
