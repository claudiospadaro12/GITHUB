# 🏺 R129 — E L'ARCHIVIO AVEVA METÀ TABELLA NON PUBBLICATA

**Verificato da me alla fonte**, riga per riga. Tre cose che avevo detto oggi
cambiano — **due in meglio**.

---

# 🟢 1. LA COLONNA CHE NESSUNO AVEVA GUARDATO — e ce l'avevo sotto gli occhi

`r118_csv/..._OOS_r118c.csv` ha **10 righe**, non 5: R118c aveva girato **tutti e
due i rami** di `InpMinStopPts`, e ogni referto ne ha mostrato **uno solo**.

Il ramo **ALZA** (`InpSkipIfTight=0`), mai citato da nessuna parte `[MISURATO]`:

| floor | idx | IS PF | **OOS PF** | **OOS n** | **OOS DD%** |
|---:|---:|---:|---:|---:|---:|
| 0 | 0 | 1,0781 | 1,18776 | **311** | 10,5984 |
| 4000 | 40 | 1,1105 | 1,21009 | **312** | 10,8753 |
| **6000** | **60** | 1,0625 | **1,19693** | 🟢 **311** | 🟢 **7,9334** |
| 8000 | 80 | 0,9466 | 1,14515 | **310** | 8,0580 |

> ## 🎯 Alzare lo stop a 60 punti indice **non costa NEANCHE UN TRADE** (311 → 311), lascia il PF fermo e **taglia il drawdown del 25%**.
> 🔴 E il confronto che chiude il discorso: **il picco 1,4382 di stamattina
> costava 85 operazioni. Questa colonna ne costa ZERO.**

📌 **E l'errore è mio**: quelle 10 righe le ho stampate io stamattina per
smontare il picco, e **ho letto solo la metà con `SkipIfTight=1`**. Avevo il
numero buono sullo schermo e guardavo l'altra colonna.

---

# 🔧 2. LA MANOPOLA FA **DUE COSE**, e a decidere è l'interruttore

`ABTG_DAX_Apertura_EU.mq5` r.1493-1496 `[MISURATO nel sorgente]`:
```
if(InpMinStopPts > 0 && dist < InpMinStopPts*_Point)
  {
   if(InpSkipIfTight) { skip=true; ... }                          <-- SALTA
   else { sl = NormalizePrice(entry - InpMinStopPts*_Point); ... } <-- ALZA
  }
```

| `InpSkipIfTight` | cosa fa | frequenza |
|---|---|---|
| `false` | **ALZA** lo stop | 🟢 **INTATTA** |
| `true` ← **default e preset vivo** | **SCARTA** il trade | 🔴 **TAGLIATA** |

⚠️ **Precisazione mia, perché il verbale sia esatto**: nel preset vivo
`InpMinStopPts=0.0` (riga 89) — quindi **oggi il ramo non scatta mai**.
L'interruttore è armato sulla via che taglia, **ma il pavimento è spento**. È una
trappola che aspetta, non un danno in corso.

🔴 E nel ramo ALZA la manopola ha **TRE** effetti, non uno: cambia lo **stop**,
e con lui il **lotto** (`CalcLotByRisk(dist)`) e il **TP** (`dist*TpTotalR()`).

---

# 🔴 3. CORREGGO IL MIO "72% DEL PAVIMENTO" — veniva da **n=2**

Stamattina ti ho scritto: *"lo stop della sedia viva è **49,10 idx = 28,9×**,
siamo al **72%** del pavimento"*. Quel numero era `[DERIVATO da n=2]`.

**L'archivio ne aveva 508.** Nel ramo SALTA il rapporto `n(cella)/n(0)` **È** la
curva di sopravvivenza dello stop `[MISURATO]`:

| floor | idx | righe | sopravvivenza | ×spread 1,7000 |
|---:|---:|---:|---:|---:|
| 0 | 0 | 508 | 1,0000 | — |
| 2000 | 20 | 504 | 0,9921 | 11,8× |
| 4000 | 40 | 431 | 0,8484 | 23,5× |
| 6000 | 60 | 335 | 0,6594 | 35,3× |
| **6800** | **68,0** | — | **0,5713** `[INTERP.]` | **40,0×** |
| 8000 | 80 | 223 | 0,4390 | 47,1× |

🟢 **Mediana dello stop RETEST ≈ 74,5 idx = 43,8× — SOPRA i 40×, non al 72%.**

> ### 🎯 Non è vero che *"la sedia non passa la frontiera del costo"*.
> È vero che **il 42,9% dei suoi trade non la passa**, e il **57,1%** sì.
> **Sono due affermazioni diverse, e quella che ti ho dato era la sbagliata.**

## 🧪 E il contro-esempio contro il mio stesso numero nuovo
Quelle 508 righe hanno `InpTP1_ClosePct=50`: sono **uscite**, non ingressi. Se i
trade con stop largo vincono di più, fanno più parziali e la curva **sovrastima
la coda larga** → **la mediana vera sarebbe più bassa.** 👉 Non separabile coi
dati d'archivio: resta **`[STIMATO, verso del bias noto]`**, e R129 gira a
`ClosePct=0` per chiuderlo.

## 🔎 E una terza differenza che nessun referto diceva
**`r118c` girava su M15, non M5.** Il trasferimento è lecito e verificato
(`ComputeRangeWindow()` r.1008-1015 calcola il range su `PERIOD_M1` esplicito,
quindi lo stop RETEST è identico), **ma andava scritta**: R128 citava `r118c`
come *"stessa finestra, ma con lo short acceso"* = **una differenza su due**.

---

# 📤 LA CONSEGNA: 3 file prova, 50 celle, 100 passate, **8,3 minuti**

| file | asse | celle |
|---|---|---:|
| **R129c** 🥇 *primo* | `InpSkipIfTight` 0/1 a `MinStopPts=6800` | 2 |
| **R129a** | `InpMinStopPts` 0→9200, **passo 400** | 24 |
| **R129b** | idem, ramo SALTA | 24 |

## 📏 Il ramo SALTA è **strutturalmente fuori gioco**
- **ALZA**: `n` **non cala su nessuna delle 24 celle** → merito leggibile ovunque.
- **SALTA**: l'IS scende sotto 150 già a **~30 idx**; alla soglia 6800 restano
  **~93 ingressi in IS**, e la frequenza cade a **0,40-0,44 op/giorno** contro il
  pavimento di famiglia **1,00** — e **questa famiglia ha un simbolo solo**.

## 🧪 IL CONTRO-ESEMPIO, rotto **per costruzione**
| ipotesi | forma in **R129b** (SALTA) | forma in **R129a** (ALZA) |
|---|---|---|
| taglio **casuale** | PF piatto, dispersione che cresce | 🔵 **riga piatta** |
| taglio dei **peggiori** | PF in salita **monotona** | 🔵 **riga piatta** |
| **soglia di costo vera** | **gradino** a 6800, poi piatto | 🟢 **si muove, col gradino** |

🔑 **In R129a nessun trade viene tolto**: le prime due ipotesi **impongono** la
riga piatta, la terza la **impone mossa**. Nessuna combinazione le fa coincidere.
➕ E il **passo 400** (5× più fitto di 2000) è lì apposta: **con passo 2000 le
ipotesi (b) e (c) danno la stessa tabella** — sarebbe una *verifica che non
discrimina*, la classe aperta stamattina.

📌 **E la monotonia è già rotta dai dati**: ramo SALTA OOS fa
`1,188 / 1,188 / 1,286 / **1,438** / 1,153` — **sale e crolla**. Quindi
l'ipotesi "taglio dei peggiori" **è già falsificata**, e resta il rumore su un
`n` che si assottiglia. **Ecco perché il 1,4382 non si compra.**

## 🚦 CANCELLI
✅ `controlla_prova.py` **3/3 OK** · ✅ `controlla_riga.py --oggetto prova` **3/3**
· ✅ ASCII puro · ✅ magic vergini (779560/779570/779580)
🔴 **Manca il controllo di giudizio** · 🔴 **e il round non può girare finché il
runner v3 non è collaudato.**

## 🕳️ I TRE BUCHI CHE PESANO
1. **Nessuna prova di regime** — tick solo dal 2024.09.26, un regime solo.
2. **Conflitto del parziale ancora aperto**: preset `50`, pagella 03/09 misura
   `1/3`, R129 gira a `0`. 🔴 **Nessuno dei tre è la sedia in campo.**
3. **Slippage non simulabile su un LIMIT** → il round **sottostima** il valore
   del pavimento. Verso del bias noto e tenuto.

> ## 🔥 Il pezzo di ricerca più prezioso di oggi era già in casa, in una colonna che nessuno aveva letto — e a non leggerla ero stato io, stamattina, con il file aperto.
