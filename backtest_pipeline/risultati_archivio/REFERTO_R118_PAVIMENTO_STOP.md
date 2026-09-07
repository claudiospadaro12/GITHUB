# ⚖️ REFERTO R118 — IL PAVIMENTO DELLO STOP SOTTO SLIPPAGE

**Data referto:** 07/09/2026 · **Criteri congelati:** `backtest_pipeline/prove/R118_PAVIMENTO_STOP_CRITERI.md` (commit `f81ad55`, scritti **prima** di questi numeri) · **Dati grezzi:** `backtest_pipeline/risultati_archivio/r118_csv/` (commit `1e59119`, 6 CSV, 170 passate)

> 🚫 **Da questo referto non esce nessuna promozione, nessun cambio di preset, nessun EA toccato, nessuna sedia sfiorata.** Le due sedie sono VIVE sul conto **REALE 10105439**. Qui c'e' una misura e una raccomandazione; la firma e' di Claudio.

---

## 0. 🥇 IL VERDETTO IN TRE RIGHE

1. 🔴 **Nessuna cella e' PROMOSSA. Nessuna, in nessuna delle tre corse.** Applicando G1+G2+G3 come sono scritti — insieme, allo stesso gradino, contro la baseline a slippage pari — e poi la regola della curva (§8.4: due gradini consecutivi ≥100 punti MT5 **e** vicini sopravvissuti), **zero celle arrivano in fondo**. Le migliori si fermano a 🟡 **FRAGILE**.
2. 🎯 **Il conflitto col collega non si chiude, e ora si sa perche': a 20 punti indice, sulla nostra geometria dello STOP, il pavimento e' un no-op esatto** — 20 celle su 20 identiche cifra per cifra nella corsa b. La sua misura non e' sbagliata: **e' su una geometria che non e' la nostra**. Dove il nostro analogo piu' vicino morde (buffer ORB, 20 pt indice), **la sua direzione si riproduce nell'IS (PF −22,95%) e sparisce nell'OOS (−2,86%)**.
3. 🥇 **Il risultato solido di questo round non e' il pavimento: e' l'asimmetria RISCHIO/MERITO.** Su 114 confronti cella-contro-baseline non degeneri: il **DD scende in 46/58 celle IS e 51/56 celle OOS** (le due finestre **concordano**), mentre il **PF scende in 53/58 IS e in 29/56 OOS** (le due finestre **non concordano**). 👉 **Allargare lo stop compra rischio in modo riproducibile e paga in edge in modo non riproducibile.** E' la tesi di R55, misurata su tre geometrie invece che una.

---

## 1. ⚓ CANCELLI D'INGRESSO — verificati sui CSV, uno per uno

### 1.1 Il cancello delle ancore era una promessa non eseguibile — **e va detto qui**
Il verificatore ha falsificato §11.2 dei criteri (*«il round si ferma prima di spendere macchina»*): in `lancia_r118.ps1` **non c'era nessun `Import-Csv`, nessun confronto, nessun `exit`** — solo una `Write-Host` **dopo** le 170 passate. Il cancello **non esisteva come codice**. 🔴 **E' un difetto del driver, ed e' agli atti.** Non invalida questa corsa perche' le ancore sono state riverificate **a mano sui CSV**, ma un cancello che stampa verde senza confrontare niente e' esattamente il modo in cui si perde un round.

### 1.2 Le ancore, riverificate a mano

| ancora | atteso (fonte) | letto nel CSV R118 | esito |
|---|---|---|---|
| **A1** corsa a, buf 0, IS | 9.509,39 / 1,24979 / 7,8885 / 71 (R88) | 9509.39 / 1.24979 / 7.8885 / 71 | ✅ identica |
| **A1** corsa a, buf 0, OOS | 41.057,00 / 1,67419 / 9,7623 / 119 (R88) | 41057.00 / 1.67419 / 9.7623 / 119 | ✅ identica |
| **A1** corsa a, buf 500, IS/OOS | 3.193,77 / 1,09174 · 29.295,20 / 1,51284 | idem | ✅ identica |
| **A1** corsa a, buf 1000, IS/OOS | 1.095,82 / 1,03507 · 28.466,13 / 1,55394 | idem | ✅ identica |
| **A2** corsa c, pavim. 0, IS | 282,12 / 1,07810 / 7,0257 / 197 (R83 V) | 282.12 / 1.07810 / 7.0257 / 197 | ✅ identica |
| **A2** corsa c, pavim. 0, OOS | 999,42 / 1,18776 / **10,5984** / 311 (R83 V) | 999.42 / 1.18776 / 10.5984 / 311 | ✅ identica |
| **A3** corsa b, pavim. 0 slip 0 | 203,66 / 1,04668 / 7,9333 / 220 · 251,22 / 1,04089 / **13,2624** / 325 (R83 **D0**, fork) | identici cifra per cifra | 🟢 **BONUS** |

🟢 **A3 e' il risultato gratuito piu' utile del round.** Era dichiarato *«atteso, NON garantito»* perche' D0 era girata sul fork `ABTG_Apertura_3Ingressi.mq5` e l'equivalenza fork↔vivo era verificata solo su D1/V e N0/A. **Adesso e' verificata anche su D0 del DAX**: `ABTG_DAX_Apertura_EU.mq5` a `InpEntryMode=0` riproduce il fork **al centesimo**. Una fonte di dubbio in meno per tutti i round che citano D0.

### 1.3 I canarini gemelli (§5.1) — tutti e tre passati

| canarino | atteso | letto | esito |
|---|---|---|---|
| corsa b, pavim. 0: `SkipIfTight` inerte | 5 coppie identiche (×2 finestre) | 10/10 coppie identiche su tutti i campi | ✅ |
| corsa c, pavim. 0: `SkipIfTight` inerte | 1 coppia identica (×2 finestre) | 2/2 identiche | ✅ |
| corsa a: n invariato in tutte le 25 celle | 71 (IS) / 119 (OOS) | **71 e 119 in tutte e 25**, sempre | ✅ |

### 1.4 Il canarino del pavimento (§7) — 🟢 **SCATTA**, ma non dove serviva al conflitto
Il cancello chiedeva: *almeno un valore di pavimento deve cambiare n di ≥5%.*

| pavimento | ramo C, corsa b OOS, slip 0 | Δn | ramo C, corsa c OOS | Δn |
|---|---|---:|---|---:|
| 0 → **2000 (20 idx)** | 325 → **325** | **0,0%** | 311 → **311** | **0,0%** |
| 0 → 4000 (40 idx) | 325 → 309 | −4,9% | 311 → 273 | −12,2% |
| 0 → 6000 (60 idx) | 325 → 250 | **−23,1%** | 311 → 226 | **−27,3%** |
| 0 → 8000 (80 idx) | 325 → 185 | **−43,1%** | 311 → 153 | **−50,8%** |

👉 Il canarino **scatta** a 6000 e 8000 → **non siamo nell'esito 3 globale**. Ma **a 2000 — il numero del collega — Δn e' esattamente zero.** L'esito 3 vale, ristretto, **su quel valore**.

### 1.5 📌 La previsione scritta prima ha tenuto
§4.4 diceva: *«stimo che 2000 non morda quasi mai, 4000 a volte, 6000 spesso, 8000 quasi sempre»*. Misurato (ramo C, corsa b OOS): **0% / 4,9% / 23,1% / 43,1%**. ✅ Monotona e nell'ordine previsto. La previsione era falsificabile e non e' stata falsificata.

---

## 2. 🔧 CORREZIONE A UNA LETTURA PRELIMINARE — il no-op a 20 punti **non e' totale**

Mi era stato riassunto che `InpMinStopPts=2000` desse numeri *«identici in tutte le celle, tutti e due i rami, tutte e due le finestre, tutti i gradini di slippage»*. **Verificato campo per campo su tutte e 22 le coppie (pavimento 2000 contro pavimento 0): e' vero in 20, falso in 2.**

| corsa | finestra | ramo | pavim. 0 | pavim. 2000 (20 idx) | esito |
|---|---|---|---|---|---|
| **b** (STOP) | IS e OOS | B e C | — | — | ✅ **identiche in tutte e 20 le coppie**, su Profit, PF, DD, n, Payoff, Recovery, Sharpe |
| **c** (RETEST) | OOS | B e C | 999,42 / 1,18776 / 10,5984 / 311 | idem | ✅ identiche |
| **c** (RETEST) | **IS** | **B** | 282,12 / 1,07810 / 7,0257 / **197** | **279,56 / 1,07740 / 7,0233 / 197** | 🔴 **DIVERSA** |
| **c** (RETEST) | **IS** | **C** | 282,12 / 1,07810 / 7,0257 / **197** | **384,89 / 1,11281 / 5,5817 / 193** | 🔴 **DIVERSA — 4 trade saltati** |

**Cosa vuol dire.** Il pavimento a 20 punti indice morde **0 volte su 220** ingressi a pendente STOP, **0 volte su 311** retest OOS, e **4 volte su 197** retest IS (**2,03%**). E' coerente con la geometria: con `InpSLMode=0` (RANGE) lo stop e' il bordo opposto del range d'apertura, quindi la distanza scende sotto 20 punti indice **solo nelle giornate a range strettissimo**, che nell'IS (set-24 → giu-25) esistono e nell'OOS (giu-25 → giu-26) no.

🎯 **La formulazione corretta e': «20 punti indice, sulla nostra geometria, tocca fra lo 0% e il 2% dei trade». Non "identico ovunque".** E la differenza conta, perche' su quei 4 trade il ramo C IS guadagna il **+36% di profitto** e taglia il DD di **−20,6%**: un campione di 4 su cui **non si decide niente**, ma che va scritto invece di essere arrotondato a zero.

---

## 3. 🇺🇸 CORSA **a** — ORB `ABTG_ORB_Ottimizzato` U30USD M5, dep. 100k, rischio 1,0%

**Assi:** `InpSLBufferPts` (0/500/1000/1500/2000 = 0/5/10/15/20 pt indice) × `InpSlippagePts` (0/50/100/150/200 = 0/0,5/1,0/1,5/2,0 pt indice). 25 celle/finestra.
**Baseline B(X)** = buffer 0 allo **stesso** gradino di slippage. **Ancora assoluta G1 = 9,7623%** (DD promesso della sedia 770611).
⚠️ **`InpSLBufferPts` non e' un pavimento: allarga SEMPRE** (LIMITE 2). E' un **parente** del ramo B, non un gemello — e il suo effetto e' per costruzione **piu' grande** di quello di un vero pavimento.
⚠️ **Ogni gradino di slippage e' uno SCENARIO ASSUNTO, non una misura.** `ABTG_SlippageLogger` sul reale ha **0 deal**.
⚠️ Il CSV della corsa a **non ha la colonna `Peggior Giornata %`** → il **muro giornaliero del 5% e' [NON MISURABILE] su questa corsa**.

### 3.1 La tabella completa — tutti i 25 gradini, PF + DD + n sulla stessa riga
| slippage (MT5 / idx) | buffer (MT5 / idx) | IS PF | IS DD% | IS n | **OOS PF** | **OOS DD%** | **OOS n** | G1 | G2 | G3 |
|---|---|---:|---:|---:|---:|---:|---:|:-:|:-:|:-:|
| 0 / 0 | **0 / 0** | 1.24979 | 7.8885 | 71 | 1.67419 | 9.7623 | 119 | PASS | PASS | SOSP |
| 0 / 0 | 500 / 5 | 1.09174 | 7.8098 | 71 | 1.51284 | 9.5573 | 119 | PASS | PASS | SOSP |
| 0 / 0 | 1000 / 10 | 1.03507 | 7.0616 | 71 | 1.55394 | 8.0454 | 119 | PASS | PASS | SOSP |
| 0 / 0 | 1500 / 15 | 0.98355 | 7.7338 | 71 | 1.57429 | 7.5519 | 119 | PASS | PASS | SOSP |
| 0 / 0 | 2000 / 20 | 0.96300 | 7.7173 | 71 | 1.62633 | 6.8914 | 119 | PASS | PASS | SOSP |
| 50 / 0.5 | **0 / 0** | 1.21696 | 8.1688 | 71 | 1.63826 | 9.8820 | 119 | FAIL | PASS | SOSP |
| 50 / 0.5 | 500 / 5 | 1.07485 | 7.8903 | 71 | 1.57610 | 8.7262 | 119 | PASS | PASS | SOSP |
| 50 / 0.5 | 1000 / 10 | 1.02297 | 7.2904 | 71 | 1.54565 | 8.0765 | 119 | PASS | PASS | SOSP |
| 50 / 0.5 | 1500 / 15 | 0.97386 | 7.9523 | 71 | 1.56591 | 7.5728 | 119 | PASS | PASS | SOSP |
| 50 / 0.5 | 2000 / 20 | 0.95277 | 7.9202 | 71 | 1.61524 | 6.9175 | 119 | PASS | PASS | SOSP |
| 100 / 1 | **0 / 0** | 1.19222 | 8.2940 | 71 | 1.61729 | 9.9499 | 119 | FAIL | PASS | SOSP |
| 100 / 1 | 500 / 5 | 1.06250 | 7.9365 | 71 | 1.55641 | 8.7432 | 119 | PASS | PASS | SOSP |
| 100 / 1 | 1000 / 10 | 1.00811 | 7.5279 | 71 | 1.53251 | 8.1324 | 119 | PASS | PASS | SOSP |
| 100 / 1 | 1500 / 15 | 0.96323 | 8.2066 | 71 | 1.55536 | 7.6099 | 119 | PASS | PASS | SOSP |
| 100 / 1 | 2000 / 20 | 0.94523 | 8.0882 | 71 | 1.60897 | 6.9207 | 119 | PASS | PASS | SOSP |
| 150 / 1.5 | **0 / 0** | 1.18524 | 8.5746 | 71 | 1.59191 | 10.2086 | 119 | FAIL | PASS | SOSP |
| 150 / 1.5 | 500 / 5 | 1.05608 | 7.9417 | 71 | 1.53872 | 8.8315 | 119 | PASS | PASS | SOSP |
| 150 / 1.5 | 1000 / 10 | 0.99896 | 7.7827 | 71 | 1.51111 | 8.1606 | 119 | PASS | PASS | SOSP |
| 150 / 1.5 | 1500 / 15 | 0.95784 | 8.3245 | 71 | 1.54477 | 7.6415 | 119 | PASS | PASS | SOSP |
| 150 / 1.5 | 2000 / 20 | 0.93967 | 8.2193 | 71 | 1.59868 | 6.9528 | 119 | PASS | PASS | SOSP |
| 200 / 2 | **0 / 0** | 1.16621 | 8.6109 | 71 | 1.56971 | 10.3352 | 119 | FAIL | PASS | SOSP |
| 200 / 2 | 500 / 5 | 1.04653 | 7.9933 | 71 | 1.53241 | 8.9171 | 119 | PASS | PASS | SOSP |
| 200 / 2 | 1000 / 10 | 0.99081 | 7.9814 | 71 | 1.49421 | 8.2039 | 119 | PASS | PASS | SOSP |
| 200 / 2 | 1500 / 15 | 0.95098 | 8.5099 | 71 | 1.53661 | 7.6369 | 119 | PASS | PASS | SOSP |
| 200 / 2 | 2000 / 20 | 0.93314 | 8.3861 | 71 | 1.66639 | 6.9528 | 119 | PASS | PASS | SOSP |

*(G3 = **SOSP** su tutte e 25: n=119 < 150. Vedi §3.2.)*

### 3.2 🔴 La collisione dentro i miei stessi cancelli, dichiarata invece che aggirata
**G3 chiede `n_OOS >= 150`. Sull'ORB n_OOS = 119, e non lo sara' mai** (il muro dei tick BCM non si sposta indietro). Quindi **letteralmente G3 fallisce su tutte e 25 le celle, baseline compresa.** Ma §8.6 dei criteri, scritto lo stesso giorno e con gli n attesi (**71/119**) gia' in tabella, dichiara per la corsa a: **MERITO 🔴 SOSPESO · RISCHIO ✅ si legge**.

👉 **I due paragrafi si contraddicono, e la contraddizione e' mia.** La risolvo come impone la gerarchia dei criteri stessi: §8.6 e' etichettato *«la regola che non cambia»* e nomina la corsa a per nome. Quindi **sulla corsa a leggo G1; G2 e la soglia dei 150 dentro G3 sono SOSPESI, non superati.** 🚫 **E la conseguenza e' che dalla corsa a non puo' uscire una promozione: una cella promossa deve passare TUTTI E TRE i cancelli, e qui due sono sospesi.** Correzione proposta per il round dopo in §9.1 — **non applicata qui**.

### 3.3 ✅ Cosa dice il RISCHIO (G1), che si legge

🔴 **La baseline — cioe' la configurazione VIVA — e' l'unica che sfonda.**

| slippage | DD baseline (buffer 0) | vs ancora 9,7623% | vs muro 10,00% |
|---|---:|---|---|
| 0 | 9,7623% | = (e' l'ancora) | ok |
| 0,5 pt idx | **9,8820%** | 🔴 **sfonda** (+0,12 pp) | ok |
| 1,0 pt idx | **9,9499%** | 🔴 sfonda (+0,19) | ok |
| 1,5 pt idx | **10,2086%** | 🔴 sfonda (+0,45) | 🔴 **SFONDA** |
| 2,0 pt idx | **10,3352%** | 🔴 sfonda (+0,57) | 🔴 **SFONDA** |

**Tutte e 20 le celle con buffer ≥ 500 (5 pt indice) passano G1 a TUTTI E CINQUE i gradini** — DD sotto la baseline **e** sotto l'ancora, sempre. Il DD OOS scende in modo **monotono** col buffer a ogni gradino: a slippage 1,5 pt idx fa **10,2086 → 8,8315 → 8,1606 → 7,6415 → 6,9528**. Non e' un picco: e' un **piano inclinato**, quindi non e' rumore di una cella sola.

🥇 **Questa e' la riproduzione esatta di R55**, con lo stesso modello di slippage e quindi confrontabile: *«l'ORB non muore di PF, muore di DD»*. R55 dava 9,76 → 10,21 a 1,5 pt indice. R118 da' **9,7623 → 10,2086**. **Cifra per cifra.**

### 3.4 ⚠️ Cosa dice il MERITO — **sospeso, e lo scrivo lo stesso perche' e' il cuore del conflitto**
Non e' un giudizio: e' una descrizione, e non fonda nessuna decisione (n=71/119).
- **IS**: il buffer costa edge **sempre**. PF 1,24979 → 1,09174 → 1,03507 → 0,98355 → **0,96300** a slippage 0. **A 15 e 20 pt indice di buffer il PF IS va SOTTO 1,00 in tutti e cinque i gradini di slippage.** Il costo a 20 pt indice e' **−22,95%**.
- **OOS**: il buffer **non costa quasi niente**. Stesse celle: 1,67419 → 1,51284 → 1,55394 → 1,57429 → **1,62633**. Costo a 20 pt indice: **−2,86%**. E a slippage 1,5 e 2,0 pt indice il buffer 2000 **guadagna** (+0,43% e **+6,16%**).
- 🔴 **Le due finestre dicono cose opposte sulla stessa cella.** Vedi §6.

### 3.5 Verdetto corsa **a**
🟡 **FRAGILE — e per RISCHIO, non per merito.**
- ✅ G1 **passato da tutte e 20 le celle a buffer, a tutti e 5 i gradini**. Curva pulita, altopiano, nessun picco isolato: il **centro** (non il picco) e' **buffer 1000-1500 = 10-15 pt indice**, con DD OOS **8,16% / 7,64%** a 1,5 pt indice di slippage contro **10,21%** della baseline.
- 🔴 G2 e la soglia dei 150 di G3: **SOSPESI** (§3.2) → **niente promozione**.
- 📏 **Margine reale, in punti indice** (§8.4 lo chiede scritto): la baseline regge fino a **0,4 pt indice** di slippage prima di sfondare l'ancora e fino a **~1,2 pt indice** prima del muro del 10%. Con buffer 1000 il muro del 10% **non viene mai raggiunto** entro la scala testata (max 8,20% a 2,0 pt indice): **margine > 2,0 pt indice**, cioe' oltre il tetto della scala. **Quanto sia il margine vero non lo sappiamo, perche' non sappiamo quanto slippage ci sia.**
- ⚠️ **A4**: questi numeri sono a rischio **1,00%** e deposito **100k**; la sedia viva gira a **0,65%** su ~7.500 €. Descrivono la **cella del contratto**, non il preset di campo.

---

## 4. 🇩🇪 CORSA **b** — DAX `ABTG_DAX_Apertura_EU` D30EUR M15, `InpEntryMode=0` (pendente STOP), dep. 10k, rischio 1,0%

**L'unico posto dove i TRE rami e lo slippage sono vivi insieme.** Assi: `InpMinStopPts` (0/2000/4000/6000/8000 = 0/20/40/60/80 pt indice) × `InpSkipIfTight` (B allarga / C SALTA) × `InpSlippagePts` (0/100/200/300/400 = 0/1/2/3/4 pt indice). 50 celle/finestra.

> 🚫 **DA QUESTA CORSA NON PUO' USCIRE NESSUNA PROMOZIONE**, ed era scritto prima (§8.6 e §10.6): la sua baseline parte gia' a **DD OOS 13,2624%**, oltre il muro del 10%. **E' una misura di MECCANISMO.**
> 🔴 **E il suo asse dello slippage e' CONTAMINATO** (§5): sul DAX `InpSlippagePts` sposta il livello del pendente, quindi cambia la popolazione dei trade. Non e' confrontabile con R55.

### 4.1 La tabella completa — tutte le 50 celle
| slip (MT5/idx) | ramo | pavim. (MT5/idx) | IS PF | IS DD% | IS n | **OOS PF** | **OOS DD%** | **OOS n** | OOS gg.peggiore% | G1 | G2 | G3 | muro 10% |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|:-:|:-:|:-:|:-:|
| 0 / 0 | B (allarga) | 0 / 0 | 1.04668 | 7.9333 | 220 | 1.04089 | 13.2624 | 325 | -1.0614 | PASS | PASS | PASS | SFONDA |
| 0 / 0 | B (allarga) | 2000 / 20 | 1.04668 | 7.9333 | 220 | 1.04089 | 13.2624 | 325 | -1.0614 | PASS | PASS | PASS | SFONDA |
| 0 / 0 | B (allarga) | 4000 / 40 | 1.03275 | 7.9073 | 219 | 1.04008 | 13.2250 | 325 | -1.0614 | PASS | PASS | PASS | SFONDA |
| 0 / 0 | B (allarga) | 6000 / 60 | 1.00951 | 8.8117 | 219 | 1.07278 | 10.6438 | 326 | -1.0384 | PASS | PASS | PASS | SFONDA |
| 0 / 0 | B (allarga) | 8000 / 80 | 0.90356 | 8.5418 | 219 | 1.04898 | 12.2812 | 327 | -1.0418 | PASS | PASS | PASS | SFONDA |
| 0 / 0 | C (SALTA) | 0 / 0 | 1.04668 | 7.9333 | 220 | 1.04089 | 13.2624 | 325 | -1.0614 | PASS | PASS | PASS | SFONDA |
| 0 / 0 | C (SALTA) | 2000 / 20 | 1.04668 | 7.9333 | 220 | 1.04089 | 13.2624 | 325 | -1.0614 | PASS | PASS | PASS | SFONDA |
| 0 / 0 | C (SALTA) | 4000 / 40 | 0.97942 | 7.5432 | 188 | 1.14515 | 8.3847 | 309 | -1.0614 | PASS | PASS | PASS | ok |
| 0 / 0 | C (SALTA) | 6000 / 60 | 0.97001 | 7.3891 | 134 | 1.05971 | 8.9869 | 250 | -1.0355 | PASS | PASS | FAIL | ok |
| 0 / 0 | C (SALTA) | 8000 / 80 | 0.77046 | 7.0279 | 86 | 0.90375 | 9.4870 | 185 | -1.0424 | PASS | FAIL | FAIL | ok |
| 100 / 1 | B (allarga) | 0 / 0 | 0.99250 | 9.3170 | 220 | 1.00260 | 15.0037 | 324 | -1.0631 | PASS | PASS | PASS | SFONDA |
| 100 / 1 | B (allarga) | 2000 / 20 | 0.99250 | 9.3170 | 220 | 1.00260 | 15.0037 | 324 | -1.0631 | PASS | PASS | PASS | SFONDA |
| 100 / 1 | B (allarga) | 4000 / 40 | 0.98735 | 9.0589 | 219 | 1.00240 | 14.9481 | 324 | -1.0631 | PASS | PASS | PASS | SFONDA |
| 100 / 1 | B (allarga) | 6000 / 60 | 0.96619 | 9.7944 | 219 | 1.00536 | 14.5034 | 324 | -1.0783 | PASS | PASS | PASS | SFONDA |
| 100 / 1 | B (allarga) | 8000 / 80 | 0.87742 | 9.1931 | 219 | 1.01178 | 15.0136 | 326 | -1.0318 | FAIL | PASS | PASS | SFONDA |
| 100 / 1 | C (SALTA) | 0 / 0 | 0.99250 | 9.3170 | 220 | 1.00260 | 15.0037 | 324 | -1.0631 | PASS | PASS | PASS | SFONDA |
| 100 / 1 | C (SALTA) | 2000 / 20 | 0.99250 | 9.3170 | 220 | 1.00260 | 15.0037 | 324 | -1.0631 | PASS | PASS | PASS | SFONDA |
| 100 / 1 | C (SALTA) | 4000 / 40 | 0.97261 | 8.6278 | 192 | 1.13588 | 9.6639 | 312 | -1.0631 | PASS | PASS | PASS | ok |
| 100 / 1 | C (SALTA) | 6000 / 60 | 0.87858 | 8.0992 | 140 | 1.08106 | 9.9397 | 254 | -1.0360 | PASS | PASS | FAIL | ok |
| 100 / 1 | C (SALTA) | 8000 / 80 | 0.69378 | 8.6111 | 86 | 0.91555 | 8.4454 | 186 | -1.0603 | PASS | FAIL | FAIL | ok |
| 200 / 2 | B (allarga) | 0 / 0 | 1.05193 | 6.6993 | 215 | 0.99063 | 15.8550 | 319 | -1.0694 | PASS | FAIL | PASS | SFONDA |
| 200 / 2 | B (allarga) | 2000 / 20 | 1.05193 | 6.6993 | 215 | 0.99063 | 15.8550 | 319 | -1.0694 | PASS | FAIL | PASS | SFONDA |
| 200 / 2 | B (allarga) | 4000 / 40 | 1.05713 | 6.7646 | 215 | 0.99184 | 15.8637 | 319 | -1.0694 | FAIL | FAIL | PASS | SFONDA |
| 200 / 2 | B (allarga) | 6000 / 60 | 1.00497 | 6.9130 | 215 | 0.99957 | 15.2717 | 320 | -1.0325 | PASS | FAIL | PASS | SFONDA |
| 200 / 2 | B (allarga) | 8000 / 80 | 0.91868 | 6.2135 | 215 | 0.95404 | 16.2856 | 320 | -1.0518 | FAIL | FAIL | PASS | SFONDA |
| 200 / 2 | C (SALTA) | 0 / 0 | 1.05193 | 6.6993 | 215 | 0.99063 | 15.8550 | 319 | -1.0694 | PASS | FAIL | PASS | SFONDA |
| 200 / 2 | C (SALTA) | 2000 / 20 | 1.05193 | 6.6993 | 215 | 0.99063 | 15.8550 | 319 | -1.0694 | PASS | FAIL | PASS | SFONDA |
| 200 / 2 | C (SALTA) | 4000 / 40 | 1.01782 | 7.0279 | 188 | 1.09268 | 10.5705 | 308 | -1.0694 | PASS | PASS | PASS | SFONDA |
| 200 / 2 | C (SALTA) | 6000 / 60 | 0.95231 | 6.9520 | 143 | 1.05296 | 9.8944 | 252 | -1.0401 | PASS | PASS | FAIL | ok |
| 200 / 2 | C (SALTA) | 8000 / 80 | 0.85526 | 6.6749 | 87 | 0.85330 | 9.5077 | 184 | -1.0630 | PASS | FAIL | FAIL | ok |
| 300 / 3 | B (allarga) | 0 / 0 | 1.10005 | 6.0393 | 215 | 0.93751 | 18.0727 | 315 | -1.0536 | PASS | FAIL | PASS | SFONDA |
| 300 / 3 | B (allarga) | 2000 / 20 | 1.10005 | 6.0393 | 215 | 0.93751 | 18.0727 | 315 | -1.0536 | PASS | FAIL | PASS | SFONDA |
| 300 / 3 | B (allarga) | 4000 / 40 | 1.10476 | 5.9582 | 215 | 0.93771 | 18.0019 | 315 | -1.0534 | PASS | FAIL | PASS | SFONDA |
| 300 / 3 | B (allarga) | 6000 / 60 | 1.04721 | 6.7390 | 215 | 0.95802 | 17.4507 | 316 | -1.0534 | PASS | FAIL | PASS | SFONDA |
| 300 / 3 | B (allarga) | 8000 / 80 | 0.96758 | 5.7917 | 215 | 0.92179 | 18.2023 | 316 | -1.0581 | FAIL | FAIL | PASS | SFONDA |
| 300 / 3 | C (SALTA) | 0 / 0 | 1.10005 | 6.0393 | 215 | 0.93751 | 18.0727 | 315 | -1.0536 | PASS | FAIL | PASS | SFONDA |
| 300 / 3 | C (SALTA) | 2000 / 20 | 1.10005 | 6.0393 | 215 | 0.93751 | 18.0727 | 315 | -1.0536 | PASS | FAIL | PASS | SFONDA |
| 300 / 3 | C (SALTA) | 4000 / 40 | 1.02229 | 6.2257 | 189 | 0.99475 | 14.9689 | 307 | -1.0534 | PASS | FAIL | PASS | SFONDA |
| 300 / 3 | C (SALTA) | 6000 / 60 | 0.98788 | 6.2157 | 147 | 1.03693 | 10.3622 | 252 | -1.0534 | PASS | PASS | PASS | SFONDA |
| 300 / 3 | C (SALTA) | 8000 / 80 | 0.88978 | 6.2997 | 90 | 0.90526 | 7.9042 | 186 | -1.0163 | PASS | FAIL | FAIL | ok |
| 400 / 4 | B (allarga) | 0 / 0 | 1.01657 | 6.7134 | 214 | 0.93672 | 18.2538 | 314 | -1.0646 | PASS | FAIL | PASS | SFONDA |
| 400 / 4 | B (allarga) | 2000 / 20 | 1.01657 | 6.7134 | 214 | 0.93672 | 18.2538 | 314 | -1.0646 | PASS | FAIL | PASS | SFONDA |
| 400 / 4 | B (allarga) | 4000 / 40 | 1.02039 | 6.3854 | 214 | 0.93726 | 18.1907 | 314 | -1.0646 | PASS | FAIL | PASS | SFONDA |
| 400 / 4 | B (allarga) | 6000 / 60 | 0.98355 | 6.3843 | 214 | 0.95670 | 17.5612 | 315 | -1.0589 | PASS | FAIL | PASS | SFONDA |
| 400 / 4 | B (allarga) | 8000 / 80 | 0.88258 | 6.6386 | 214 | 0.92837 | 18.0473 | 315 | -1.0623 | PASS | FAIL | PASS | SFONDA |
| 400 / 4 | C (SALTA) | 0 / 0 | 1.01657 | 6.7134 | 214 | 0.93672 | 18.2538 | 314 | -1.0646 | PASS | FAIL | PASS | SFONDA |
| 400 / 4 | C (SALTA) | 2000 / 20 | 1.01657 | 6.7134 | 214 | 0.93672 | 18.2538 | 314 | -1.0646 | PASS | FAIL | PASS | SFONDA |
| 400 / 4 | C (SALTA) | 4000 / 40 | 0.97677 | 5.8859 | 192 | 0.99339 | 15.0918 | 306 | -1.0646 | PASS | FAIL | PASS | SFONDA |
| 400 / 4 | C (SALTA) | 6000 / 60 | 0.88542 | 6.5127 | 147 | 1.05160 | 10.4660 | 253 | -1.0589 | PASS | PASS | PASS | SFONDA |
| 400 / 4 | C (SALTA) | 8000 / 80 | 0.77005 | 7.8040 | 91 | 0.96317 | 6.6569 | 190 | -1.0168 | PASS | FAIL | FAIL | ok |

*(G1 qui e' solo `DD ≤ DD baseline(X)`: per la corsa b **non esiste** un'ancora assoluta, perche' non e' una sedia viva. La colonna «muro 10%» applica §8.4.)*

### 4.2 🥇 IL RISULTATO DI MECCANISMO — il ramo **C (SALTA)** e' un assorbitore di slippage

Confronto a **popolazione quasi costante** lungo l'asse (n del ramo C a 60 pt indice: 250 / 254 / 252 / 252 / 253 — **piatto**), quindi l'effetto **non** e' «meno trade»:

| slippage | baseline PF / DD% / n | **ramo C, pavimento 60 pt idx** PF / DD% / n |
|---|---|---|
| 0 | 1,04089 / **13,2624** / 325 | 1,05971 / **8,9869** / 250 |
| 1 pt idx | 1,00260 / **15,0037** / 324 | 1,08106 / **9,9397** / 254 |
| 2 pt idx | 0,99063 / **15,8550** / 319 | 1,05296 / **9,8944** / 252 |
| 3 pt idx | 0,93751 / **18,0727** / 315 | 1,03693 / **10,3622** / 252 |
| 4 pt idx | 0,93672 / **18,2538** / 314 | 1,05160 / **10,4660** / 253 |

👉 La baseline **degrada di 5,0 punti percentuali di DD** e perde il segno del PF (1,041 → 0,937). Il ramo C **resta piatto**: PF fra **1,037 e 1,081** su tutto l'asse, DD fra **8,99% e 10,47%**. **Prezzo: −23% di trade** (325 → ~252), pagato **una volta sola** e non crescente.

📌 Il ramo C, cioe' **la terza via che nessuno dei due sosteneva**, e' l'unica configurazione della corsa b che tiene il segno del PF a 4 punti indice di slippage assunto.

### 4.3 Ma i cancelli, applicati insieme, **non lasciano passare niente**

| cella | G1 | G2 | G3 | muro 10% | esito |
|---|:-:|:-:|:-:|:-:|---|
| ramo C, 40 pt idx, slip 0/1/2 pt idx | PASS | PASS | PASS | ok/ok/**SFONDA** (10,57%) | 🔴 **BOCCIATA** — sfonda il muro a 2 pt idx, e a 3-4 collassa (14,97 / 15,09%) |
| ramo C, 60 pt idx, slip 0→4 | PASS | PASS a 0,1,2,3,4 | **FAIL a 0,1,2** (n 250/254/252 < 0,80×325=260) | **SFONDA a 3 e 4** (10,36 / 10,47%) | 🔴 **BOCCIATA** — G3 dove il muro regge, muro dove G3 regge |
| ramo C, 80 pt idx | PASS | FAIL (PF 0,90/0,92/0,85/0,91/0,96 < 1,00) | FAIL (n ~186) | ok | 🔴 **BOCCIATA** |
| ramo B, qualunque pavimento | PASS/FAIL | **FAIL da 2 pt idx in su** (PF < 1) | PASS | 🔴 **SFONDA sempre** (13,2%-18,3%) | 🔴 **BOCCIATA** |

🎯 **Il ramo C a 60 punti indice fallisce per un soffio e per due cancelli diversi in due punti diversi dell'asse**: dove il DD sta sotto il muro (slippage 0-2) gli manca la **portata** (n 250-254 contro una soglia di 260 — **mancano 6-10 trade su 325**); dove la portata basterebbe non c'e' — il DD e' gia' oltre 10%. **E' esattamente il caso previsto dall'esito 4️⃣ («il ramo C vince ma costa»), tranne che qui non "vince": arriva secondo per 6 trade.**

### 4.4 Verdetto corsa **b**
🔴 **BOCCIATA per tutte le 50 celle** (G1+G2+G3 insieme, piu' il muro §8.4) — **come era prevedibile e come era scritto prima**.
🟢 **Ma come misura di MECCANISMO la corsa b e' il pezzo piu' informativo del round**: e' l'unica prova esistente in casa che il ramo **C — mai misurato da nessuno, ne' da noi ne' dal collega — appiattisce la risposta allo slippage**, e il prezzo e' misurato: **−23% di portata**.
📌 **Il muro giornaliero del 5% non e' mai in discussione**: la peggior giornata su tutte e 100 le passate della corsa b sta fra **−0,99% e −1,09%**. Margine enorme, in ogni cella.

---

## 5. 🇩🇪 CORSA **c** — DAX `ABTG_DAX_Apertura_EU` D30EUR M15, `InpEntryMode=2` (**RETEST**) = la cella VIVA 770101

**Assi:** `InpMinStopPts` (0/20/40/60/80 pt idx) × `InpSkipIfTight`. **Slippage FISSO a 0** — e non e' una scelta, e' il **LIMITE 3**: il codice **non applica lo slippage a un ingresso LIMIT** (riga 1487: *«limit sul livello (niente buffer/slippage)»*).

> ⚠️ **BIAS DI VERSO NOTO, dichiarato PRIMA:** questa corsa misura del pavimento **solo il canale lotto→DD**, mai il canale protezione-dallo-slippage. 👉 **SOTTOSTIMA il valore del pavimento.** Qualunque cosa passi qui, passerebbe *a maggior ragione* con lo slippage acceso; qualunque cosa fallisca qui **non e' assolta**.
> ⚠️ **Ancora assoluta G1 = 10,5984%**, il DD scritto nel contratto della sedia 770101.

### 5.1 La tabella completa — tutte e 10 le celle
| ramo | pavim. (MT5/idx) | IS PF | IS DD% | IS n | **OOS PF** | **OOS DD%** | **OOS n** | OOS gg.peggiore% | G1 | G2 | G3 | muro 10% |
|---|---|---:|---:|---:|---:|---:|---:|---:|:-:|:-:|:-:|:-:|
| B (allarga) | 0 / 0 | 1.07810 | 7.0257 | 197 | 1.18776 | 10.5984 | 311 | -1.0671 | PASS | PASS | PASS | SFONDA |
| B (allarga) | 2000 / 20 | 1.07740 | 7.0233 | 197 | 1.18776 | 10.5984 | 311 | -1.0671 | PASS | PASS | PASS | SFONDA |
| B (allarga) | 4000 / 40 | 1.11054 | 5.7849 | 198 | 1.21009 | 10.8753 | 312 | -1.0671 | FAIL | PASS | PASS | SFONDA |
| B (allarga) | 6000 / 60 | 1.06253 | 6.2410 | 199 | 1.19693 | 7.9334 | 311 | -1.0789 | PASS | PASS | PASS | ok |
| B (allarga) | 8000 / 80 | 0.94663 | 6.5042 | 199 | 1.14515 | 8.0580 | 310 | -1.0220 | PASS | PASS | PASS | ok |
| C (SALTA) | 0 / 0 | 1.07810 | 7.0257 | 197 | 1.18776 | 10.5984 | 311 | -1.0671 | PASS | PASS | PASS | SFONDA |
| C (SALTA) | 2000 / 20 | 1.11281 | 5.5817 | 193 | 1.18776 | 10.5984 | 311 | -1.0671 | PASS | PASS | PASS | SFONDA |
| C (SALTA) | 4000 / 40 | 1.05646 | 6.8402 | 158 | 1.28607 | 6.7947 | 273 | -1.0671 | PASS | PASS | PASS | ok |
| C (SALTA) | 6000 / 60 | 1.00767 | 4.9548 | 109 | 1.43822 | 6.6448 | 226 | -1.0257 | PASS | PASS | FAIL | ok |
| C (SALTA) | 8000 / 80 | 1.06558 | 4.6085 | 70 | 1.15293 | 6.6042 | 153 | -1.0330 | PASS | PASS | FAIL | ok |

### 5.2 Le celle che passano tutti e tre i cancelli

| cella | OOS PF / DD% / n | G1 | G2 | G3 | muro 10% | commento |
|---|---|:-:|:-:|:-:|:-:|---|
| ramo **B**, 60 pt idx | 1,19693 / **7,9334** / 311 | ✅ | ✅ | ✅ | ✅ | **DD −2,66 pp, PF +0,8%, n INVARIATO** |
| ramo **B**, 80 pt idx | 1,14515 / **8,0580** / 310 | ✅ | ✅ | ✅ | ✅ | DD −2,54 pp, PF −3,6%, n −1 |
| ramo **C**, 40 pt idx | 1,28607 / **6,7947** / 273 | ✅ | ✅ | ✅ | ✅ | DD −3,80 pp, PF **+8,3%**, **n −12,2%** |
| ramo B, 20 pt idx | 1,18776 / 10,5984 / 311 | ✅ | ✅ | ✅ | 🔴 | **no-op**: e' la baseline |
| ramo B, **40** pt idx | 1,21009 / **10,8753** / 312 | 🔴 **FAIL** (+0,28 pp sopra l'ancora) | ✅ | ✅ | 🔴 | **il buco nell'altopiano** |
| ramo C, 60 pt idx | 1,43822 / 6,6448 / **226** | ✅ | ✅ | 🔴 FAIL (0,727×) | ✅ | il PF piu' alto del round, e **non passa** |
| ramo C, 80 pt idx | 1,15293 / 6,6042 / **153** | ✅ | ✅ | 🔴 FAIL (0,492×) | ✅ | −50,8% di portata |

### 5.3 🚫 Perche' nessuna di queste tre e' PROMOSSA — la regola §8.4, applicata a me stesso

**§8.4: «PROMOSSA = cella sopravvissuta ad almeno DUE gradini consecutivi di slippage ≥ 100 punti MT5».**
🔴 **La corsa c ha UN SOLO gradino di slippage, e vale zero.** Per costruzione (LIMITE 3) **nessuna cella della corsa c puo' essere promossa.** Il massimo grado raggiungibile e' 🟡 **FRAGILE** — e questo era gia' vero il giorno in cui ho scritto i criteri.

E c'e' un secondo motivo, indipendente: **§8.4 chiede il centro dell'altopiano, coi vicini sopravvissuti.**
- ramo B 60 ha come vicini **40 (FAIL su G1)** e 80 (pass) → **e' un bordo, non un centro**;
- ramo B 80 e' **l'ultima colonna della griglia** → non ha vicino a destra;
- ramo C 40 ha come vicini **20 (no-op, degenere)** e **60 (FAIL su G3)** → **circondato da due fallimenti**.

👉 **Non esiste un centro di altopiano nella corsa c.** Ci sono tre celle isolate che passano i cancelli, e §8.4 chiama questo **rumore fino a prova contraria**, con la lezione R70 citata per nome.

### 5.4 🔴 Un dettaglio che pesa: **la baseline della cella VIVA sfonda il muro di casa**
`DD OOS = 10,5984% > 10,00%`. Non e' una novita' di R118 — e' **il numero del contratto**, incoronato da R83 e riprodotto qui identico. Ma applicando §8.4 alla lettera, **la configurazione viva sarebbe BOCCIATA dal muro**, mentre tre configurazioni non vive stanno sotto (7,93% / 8,06% / 6,79%).
⚠️ **A4**: la 770101 in campo gira a **0,65%** di rischio, **solo long**, chart **M5**; qui e' misurata a **1,0%**, long+short, M15. **Non e' un allarme sul conto reale: e' un'osservazione sul CONTRATTO**, e la riporto perche' il criterio d'uscita delle sedie (C3, 18/08) usa proprio quel numero come metro.

### 5.5 Verdetto corsa **c**
🟡 **FRAGILE** su tre celle — **ramo B a 60 e 80 punti indice, ramo C a 40** — con **margine dichiarato: nessuno sull'asse dello slippage, perche' l'asse non c'e'.**
🔴 **Nessuna promozione**, per due motivi indipendenti (nessun asse slippage; nessun centro di altopiano).
🟢 La cella **piu' interessante da segnalare a Claudio** e' **ramo B a 60 pt indice**: **stessa popolazione di trade (311 = 311), PF praticamente uguale (+0,8%), DD giu' di 2,66 punti percentuali** — e ricordando che questa corsa **sottostima** il pavimento. E' l'unica cella del round che non paga niente di visibile. **Non e' una raccomandazione a cambiare: e' l'indirizzo dove guardare se un giorno si vorra' chiudere davvero.**

---

## 6. 🔴 L'INCOERENZA IS/OOS — ha una struttura, e la struttura e' RISCHIO contro MERITO

E' la domanda che decide se qui c'e' qualcosa o solo rumore. **Misurata su tutte le celle delle tre corse** (68 per finestra = 136 confronti; **non degeneri**: 58 in IS e 56 in OOS — le altre sono le celle a pavimento 2000, identiche alla baseline). Cella contro la sua baseline, **a slippage pari**, segno del Δ:

| grandezza | finestra | **peggiora** | **migliora** |
|---|---|---:|---:|
| **PF** | IS | **53** | 5 |
| **PF** | **OOS** | **29** | **27** |
| **DD** | IS | 12 | **46** |
| **DD** | **OOS** | 5 | **51** |

### 6.1 🥇 Cosa dice questa tabella, e non e' «le finestre si contraddicono»
- 📉 **Sul MERITO (PF) l'IS e' quasi unanime — 53 su 58 celle peggiorano — e l'OOS e' una monetina: 29 contro 27.** Non e' che l'OOS dica il contrario dell'IS: **l'OOS non dice niente.** L'effetto del pavimento/buffer sul PF nell'OOS e' **centrato sullo zero**. 🔴 **Quindi qualunque cella scelta dalla meta' positiva dell'OOS e' selezione sull'OOS.** Il PF 1,43822 del ramo C a 60 pt idx (corsa c) — il numero piu' bello del round — sta in quella meta', e **non lo uso, e non deve essere usato.**
- 🛡️ **Sul RISCHIO (DD) le due finestre CONCORDANO: 46/58 IS e 51/56 OOS vanno nella stessa direzione — il DD scende.** **97 celle su 114**, **85%**. **Questo e' il segnale.**
- 🎯 Concordanza di segno **fra le due finestre, cella per cella**: **DD 41 concordi / 15 discordi (73%)**, **PF 33 / 23 (59%, cioe' una monetina)**.

### 6.2 E la struttura non e' «regimi diversi»
IS = 26/09/2024 → 09/06/2025, OOS = 10/06/2025 → 30/06/2026: **stesso regime, indici prevalentemente rialzisti, finestre contigue.** Non posso invocare l'Emendamento C per spiegare la discordanza: **non c'e' una prova di regime qui, c'e' una sola epoca spezzata in due.**
Il campione IS **non e' cosi' sottile da spiegarla** sul DAX (220 e 197 trade, sopra i 150 della regola A). **Lo e' sull'ORB (71).**

### 6.3 👉 La conclusione, nel linguaggio di casa
**«Il vecchio giudica il RISCHIO, il recente giudica il MERITO»** qui non basta, perche' le due finestre sono la stessa epoca. La formulazione che i numeri reggono e' un'altra:

> 🥇 **Allargare lo stop produce un effetto RIPRODUCIBILE sul drawdown (84% delle celle, entrambe le finestre, tre geometrie) e un effetto NON RIPRODUCIBILE sul profit factor (una monetina nell'OOS, sistematicamente negativo nell'IS).**

E la lettura piu' prudente del PF e' **quella dell'IS**, non perche' l'IS sia piu' vero, ma perche' e' **l'unico dei due a dire qualcosa di coerente** — e quello che dice e' **«costa»**. 🔴 **Se dovessi scommettere su un solo numero di questo round come piu' probabilmente vero in avanti, sceglierei «il pavimento costa edge» (IS) e «il pavimento riduce il DD» (entrambe). Cioe' esattamente il compromesso di R55, con il prezzo del collega.**

---

## 7. 🧪 ARTEFATTO O RISULTATO? — il punto che avevo dichiarato ambiguo, **misurato**

§4.2 avvertiva: sul DAX lo «slippage» **sposta il grilletto del pendente**, quindi n cambia lungo l'asse e il lotto puo' ridursi. **Le colonne n ci sono. E' successo. Ecco quanto.**

### 7.1 Il grilletto si e' spostato — **misurato, piccolo, reale**
Baseline corsa b (pavimento 0, ramo B), n lungo l'asse dello slippage:
- **IS**: 220 → 220 → 215 → 215 → 214 (**−2,7%**)
- **OOS**: 325 → 324 → 319 → 315 → 314 (**−3,4%**)

Lo slippage vero **non toglie trade**. Qui ne toglie ~3%. 👉 **L'asse dello slippage del DAX e' contaminato, in misura misurata e piccola.**

### 7.2 🔴 E nell'IS l'artefatto **domina il segno**
Corsa b, baseline, **IS**:

| slippage assunto | Profit | DD% |
|---|---:|---:|
| 0 | 203,66 | 7,9333 |
| 1 pt idx | **−33,36** | 9,3170 |
| 2 pt idx | 219,99 | 6,6993 |
| **3 pt idx** | **407,10** | **6,0393** |
| 4 pt idx | 68,80 | 6,7134 |

👉 **A 3 punti indice di slippage il backtest guadagna il DOPPIO che a slippage zero, con un drawdown piu' BASSO di 1,9 punti percentuali.** 🔴 **Questo e' fisicamente impossibile per uno slippage vero.** E' il canale 3 previsto in §4.2: stop = bordo opposto del range, entrata peggiore ⇒ **distanza maggiore ⇒ lotto minore ⇒ DD minore**, piu' la selezione dei trade sopravvissuti al grilletto spostato. **E' un artefatto del modello, non robustezza.**

### 7.3 Dove l'artefatto **non** domina
**OOS corsa b**: profit 251,22 → 16,09 → −57,63 → −379,21 → −378,20 e DD 13,26 → 15,00 → 15,86 → 18,07 → 18,25. **Monotoni, e nel verso giusto.** L'artefatto c'e' ma non ribalta il segno.
**Corsa a (ORB)**: `InpSlippagePts` sposta **SL e TP dopo** il calcolo del lotto → **n resta 71/119 in tutte e 25 le celle**, verificato. **Nessun artefatto di popolazione. L'asse dello slippage dell'ORB e' pulito** — ed e' per questo che e' l'unico confrontabile con R55.

### 7.4 👉 Conseguenza operativa sulla lettura
🔴 **Le colonne IS della corsa b lungo l'asse dello slippage NON si usano per giudicare niente.** Le ho stampate integralmente perche' un referto non nasconde i gradini scomodi, ma **il loro segno e' guidato dal modello**. Le colonne OOS della corsa b **si usano con la riserva del −3% di popolazione**.
🟢 **E la lettura del §4.2 regge lo stesso**, perche' e' fatta su celle a popolazione **costante** (ramo C 60 pt idx: 250/254/252/252/253): li' l'appiattimento **non** puo' venire dal canale «meno trade».

---

## 8. 🎯 IL CONFLITTO COL COLLEGA — cosa e' stato MISURATO, cosa resta NON MISURATO

**Non «chi ha ragione».** Ecco la separazione, riga per riga.

### 8.1 ✅ MISURATO
1. 🥇 **Sulla geometria dello STOP del DAX, il pavimento a 20 punti indice non tocca nemmeno un trade.** 20 celle su 20 **identiche su ogni campo**, in tutte e due le finestre, in tutti e cinque i gradini di slippage, in tutti e due i rami. 👉 **La sua misura (PF 2,40 → 1,26) su questa geometria non e' nemmeno CONFUTABILE: e' un no-op.** Esito **3️⃣**, ristretto a quel valore.
2. **Sulla geometria del RETEST, a 20 punti indice il pavimento tocca il 2,03% dei trade IS e lo 0% dei trade OOS.** Praticamente un no-op anche li'.
3. **Il suo effetto, sul nostro analogo piu' vicino (buffer ORB, 20 pt indice), esiste e va nel suo verso — nell'IS: PF 1,24979 → 0,96300, cioe' −22,95%.** Lui dichiara −47%. Noi misuriamo **circa la meta', e su un parametro che allarga SEMPRE** (LIMITE 2), quindi che e' un **limite SUPERIORE** del costo di un vero pavimento. 👉 **Il verso della sua osservazione si riproduce; la sua magnitudine no.**
4. **Nello stesso identico esperimento, nell'OOS, quel costo scompare: −2,86%.** 👉 **Il suo numero non e' stabile fra due finestre contigue dello stesso regime.**
5. 🥇 **R55 si riproduce cifra per cifra**: la baseline ORB sfonda il DD promesso (9,7623%) gia' a **0,5 punti indice** di slippage assunto e il muro del 10% a **1,5** (10,2086%).
6. **Il ramo C — la terza via che NESSUNO DEI DUE sosteneva — e' l'unico a tenere il segno del PF a 4 punti indice** sul DAX a STOP, al prezzo del **−23% di portata**.

### 8.2 🔴 NON MISURATO — e non lo sara' da un backtest
1. **Quanto slippage c'e' davvero.** `ABTG_SlippageLogger` sul reale: **0 deal**. **Tutti i gradini di questo round sono SCENARI ASSUNTI.**
2. **I numeri del collega.** Nessun `.htm`, nessun CSV, nessun `.set`, **nessun codice**. Restano **[DICHIARATI]**. Se da lui il TP **non** si ricalcola sullo stop, la sua obiezione *«allargare scardina le proporzioni»* puo' essere **vera a casa sua e falsa a casa nostra** (da noi righe 1070 e 1497 ricalcolano il TP su `dist`: **l'R resta l'R**). **R118 non chiude quel punto.**
3. **Requote, rifiuti, riempimento parziale, profondita' del book, no-fill del LIMIT.** MT5 non li modella. **Nessun backtest rispondera' mai**: solo il forward a taglia crescente.
4. **Il ramo C sull'ORB**: `ABTG_ORB_Ottimizzato.mq5` non ha `InpMinStopPts` ne' `InpSkipIfTight`. Servirebbe codice nuovo, e **il codice non si tocca in un round di collaudo**.
5. **Lo slippage sulla cella VIVA del DAX** (RETEST = LIMIT).
6. **Lo SPREAD come asse.** Non e' stato toccato: i tick reali restano quelli. La riga `Spread` dell'`.ini` a Modello 4 e' **[NON MISURATO]** (serve prima il canarino).
7. **Swap / rollover / commissioni della prop.** **[NON MISURABILE]** da questi CSV.
8. **Il muro giornaliero del 5% sulla corsa a**: la colonna `Peggior Giornata %` **non esiste** nel CSV dell'ORB. Sul DAX invece e' misurato e non e' mai vicino: **fra −0,99% e −1,09%** su tutte e 120 le passate.

### 8.3 👉 LA RISPOSTA ALLA DOMANDA CHE HA APERTO IL ROUND
> 🎯 **La domanda era mal posta, e adesso si sa esattamente perche': «pavimento a 20 punti» non e' la stessa operazione sulle due geometrie.** Da lui, evidentemente, morde abbastanza da dimezzare un PF. Da noi, dove lo stop e' **l'intero range d'apertura** (`InpSLMode=0`), **non morde mai**. **Non stavamo dissentendo: stavamo misurando due cose diverse chiamandole con lo stesso nome.**
>
> E la parte del conflitto che **e' davvero misurabile** — «allargare lo stop costa edge» — **non si e' chiusa a favore di nessuno dei due: si e' rivelata instabile fra due finestre contigue** (§6). L'unica cosa che le due finestre firmano insieme e' **la riduzione del drawdown**, che era la tesi di R55 — ma R55 diceva anche «e conviene», e **questo round quel "conviene" non lo puo' confermare.**

---

## 9. 🧊 PROPOSTE DI MODIFICA AI CANCELLI — **proposte, non applicate.** Firma di Claudio.

I criteri si cambiano **prima** dei numeri. Qui i numeri ci sono gia', quindi **queste tre modifiche NON toccano il verdetto sopra** e varrebbero, se firmate, dal round successivo.

### 9.1 🔴 Sanare la collisione G3 ↔ §8.6 (difetto mio, trovato applicando i criteri)
G3 contiene `n_OOS >= 150`, che e' una condizione di **leggibilita' del MERITO**, ma sta in un cancello che partecipa anche al giudizio di **RISCHIO**. Su una cella con n<150 il cancello diventa **impassabile per costruzione**, contraddicendo §8.6 che sospende il merito e **non** il rischio.
**Proposta:** spezzare G3 in **G3a (portata relativa: `n >= 0,80 × n(B)`)**, che vale sempre, e **G3b (leggibilita': `n >= 150`)**, che e' un **prerequisito del MERITO** e sospende G2+G3b invece di farli fallire. **Effetto su R118 se fosse gia' in vigore: nessuno sul verdetto** (la corsa a resterebbe non promuovibile perche' §8.4 chiede comunque tutti i cancelli).

### 9.2 🔴 Il cancello delle ancore dev'essere CODICE, non una `Write-Host`
`lancia_r118.ps1` non aveva `Import-Csv`, ne' confronto, ne' `exit`. **Proposta:** nessun round parte finche' il driver non contiene un confronto eseguibile che **termina** se l'ancora non riproduce, e la prova che funziona e' un **canarino negativo** (ancora falsa apposta ⇒ il driver DEVE fermarsi). ASCII puro, come da regola di casa.

### 9.3 ⚠️ §8.4 va reso applicabile alle corse SENZA asse di slippage
«Due gradini consecutivi ≥100 punti MT5» rende **strutturalmente impromuovibile** ogni corsa su una geometria LIMIT. **Proposta:** per queste, o si dichiara in partenza che **il massimo grado e' FRAGILE** (com'e' successo qui, ma per caso), oppure si sostituisce l'asse dello slippage con un asse surrogato **dichiarato prima**.

---

## 10. 🕳️ COSA QUESTO REFERTO **NON** CONCLUDE

1. 🚫 **Non conclude che il pavimento serva.** Il segnale sul PF e' una monetina nell'OOS e negativo nell'IS.
2. 🚫 **Non conclude che il pavimento non serva.** A 20 punti indice sulla nostra geometria **non e' nemmeno confutabile**, e le celle che riducono il DD sono l'85%.
3. 🚫 **Non conclude niente sul valore 20 punti indice del collega**, se non che **da noi non fa niente**.
4. 🚫 **Non e' una prova di regime** (Emendamento C): una sola epoca, spezzata in due.
5. 🚫 **Non giudica il MERITO sull'ORB** (n = 71/119).
6. 🚫 **Non e' comparabile con R55 sul DAX** (modello di slippage diverso, artefatto §7). **Lo e', ed e' riprodotto, sull'ORB.**
7. 🚫 **Non dice niente su parziale, filtri, taglia, spread, commissioni, swap.**
8. 🚫 **Non promuove, non spegne, non cambia niente in forward.**

---

## 11. 🚀 IL PROSSIMO PASSO, SE UN GIORNO SI VOLESSE CHIUDERE DAVVERO — con il costo dichiarato

In ordine di **rapporto informazione/costo**. Nessuno di questi e' proposto per oggi.

| # | passo | cosa chiuderebbe | costo dichiarato |
|---|---|---|---|
| **1** | 🥇 **Aspettare i deal del `SlippageLogger`.** Oggi: **0**. Serve che il conto reale accumuli esecuzioni. | Trasforma l'asse **da SCENARIO ASSUNTO a MISURA**, e con esso **tutto** questo round | **0 macchina, 0 righe di codice.** Costo: **tempo**, e il tempo passa da solo. 👉 **Senza questo, ogni round successivo sul pavimento ripete lo stesso limite.** |
| **2** | Ripetere la corsa **a** (ORB, asse pulito) su una **finestra IS con n ≥ 150**, spezzando la corsa in tranche o salendo di TF | Sbloccherebbe il **MERITO** sull'ORB, oggi sospeso, e direbbe se la monetina dell'OOS e' rumore o campione corto | ~50-100 passate a tick reali, **1 corsa di macchina**. Rischio: il muro dei tick BCM (26/09/2024) potrebbe non lasciarne abbastanza — **da sondare prima** |
| **3** | Portare l'asse dello slippage sul **RETEST** del DAX (LIMITE 3) | Toglierebbe il bias di sottostima della corsa c, l'unica che ha prodotto celle FRAGILI pulite | 🔴 **Richiede di TOCCARE `ABTG_DAX_Apertura_EU.mq5`** (riga 1487) — su un EA **vivo sul conto reale**. **Costo alto, e non lo raccomando** finche' il punto 1 non ha dato numeri veri |
| **4** | Chiudere il ramo C sulla corsa b portando la portata sopra la soglia (gli mancano **6-10 trade su 325**) | Direbbe se la «terza via» e' reale o e' arrivata seconda per caso | 1 corsa con una griglia fine del pavimento **fra 40 e 60 punti indice** (es. 4500/5000/5500), ~60 passate. 🟡 **Ma attenzione: e' una griglia piu' fine su un OOS gia' visto = curve fitting.** Andrebbe fatta con criteri nuovi e finestra nuova |
| **5** | Chiedere al collega i suoi `.set` / `.htm` | L'unica via per sapere **se misuravamo la stessa cosa** | **0 macchina.** Costo: una domanda |

📌 **Il passo giusto e' l'1, ed e' gratis.** Tutto il resto costa macchina per raffinare misure che poggiano su uno slippage che **non abbiamo mai osservato**.

---

## 12. 📋 TABELLA RIASSUNTIVA DEI VERDETTI

| corsa | geometria | celle | verdetto | motivo dominante |
|---|---|---:|---|---|
| **a** | ORB U30USD, buffer, asse slippage **pulito** | 25 | 🟡 **FRAGILE (solo RISCHIO)** | G1 passato da 20/20 celle a tutti i gradini; **G2 e i 150 di G3 SOSPESI** (n=119) → nessuna promozione possibile |
| **b** | DAX a STOP, tre rami, asse slippage **contaminato** | 50 | 🔴 **BOCCIATA 50/50** (era prevedibile e scritto prima) | baseline gia' a DD 13,26%; il ramo C a 60 pt idx manca G3 **per 6-10 trade** dove il muro regge, e sfonda il muro dove G3 regge |
| **c** | DAX a RETEST (cella VIVA), **nessun** asse slippage | 10 | 🟡 **FRAGILE su 3 celle** (B 60, B 80, C 40) | passano G1+G2+G3, ma §8.4 **non e' soddisfabile** senza asse slippage, e nessuna e' centro di altopiano |

🚫 **PROMOSSE: ZERO.** 🚫 **Nessun preset, nessun EA, nessun parametro di forward toccato.**

---

*Referto scritto il 07/09/2026 applicando `R118_PAVIMENTO_STOP_CRITERI.md` (commit `f81ad55`) senza modificarne una riga. Le tre proposte del §9 sono proposte: la firma e' di Claudio, e varrebbero dal round successivo. I dati grezzi sono in `r118_csv/`: ogni numero di questo referto e' ricalcolabile da li'.*
