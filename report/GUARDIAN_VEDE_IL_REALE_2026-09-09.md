# ✅ IL GUARDIAN VEDE ECCOME — e con lui è arrivato **il primo slippage misurato sul conto reale**

Misurato il **09/09/2026 alle 07:50**, leggendo il giornale del terminale
`C:\BCM_Reale` (conto **10105439**) — non un referto di stanotte, **il file vivo**.

---

## 🟢 LA RISPOSTA: il Guardian legge il conto benissimo

**Giorno 08/09 — 288 righe, e l'equity si muove:**
```
valori distinti di eq: 11
  7500.00 | 7499.46 | 7500.69 | 7500.81 | 7499.28 | 7494.57
  7500.66 | 7503.57 | 7509.23 | 7508.83 | 7507.65
```
**Ultima riga del giorno (23:55:02):**
```
eq=7507.65   dayLoss=-0.10%   totDD=-0.10%   rischioAperto=0.00%   stato=OK
```

> ### 🎯 `dayLoss` **NEGATIVO** = la giornata è chiusa **in guadagno**.
> È esattamente ciò che prevedevano le formule (righe 742-746: sono
> **differenze con segno**, non valori limitati a zero). Il Guardian non solo
> vede: **misura, e il segno funziona.**

**Giorno 09/09 (fino alle 07:45): un solo valore, 7507.65** — corretto, i mercati
non hanno ancora aperto. `totDD=-0.10%`: siamo **sopra** il saldo iniziale.

## 🙋 E l'allarme di ieri sera era mio, non del Guardian
La riga `eq=7500.00 dayLoss=0.00% totDD=0.00%` che avevo citato è **l'inizio
giornata**, non la fine. Il referto `CODA_02` la etichetta *"ultima riga"*, e io
l'ho presa per buona.

> ### 🔧 DIFETTO DA CORREGGERE IN `CODA_02`
> Legge **tre file** (oggi, ieri, l'altro ieri) e stampa *"ultima riga"* per EA,
> ma **non garantisce che sia la più recente in ordine di tempo**: dipende
> dall'ordine in cui scorre i file. Su un Guardian che scrive ogni 5 minuti,
> pescare la riga sbagliata **cambia il verdetto**. Va ordinata per data **prima**
> di prendere l'ultima.

---

# 🎯 E LA NOTIZIA GRANDE: **IL PRIMO SLIPPAGE, MISURATO SUL CONTO VERO**

Dal giornale dell'08/09, `ABTG_SlippageLogger`:

| ora | deal | simbolo | tipo | vol | eseguito | richiesto | **scarto** |
|---|---|---|---|---|---|---|---|
| 13:50:50 | 2899263 | D30EUR | **IN** (EA) | 0.30 | 25983,80 | 25983,10 | 🔴 **70,0 punti MT5 — AVVERSO** |
| 14:30:00 | 2899773 | D30EUR | OUT (EA) | 0.10 | 26014,50 | n/d | n/d (nessuna richiesta) |
| 14:35:10 | 2899892 | D30EUR | **OUT (SL)** | 0.20 | 26006,70 | 26006,70 | 🟢 **0,0 punti** |

## 📏 Cosa vuol dire, in soldi
**70,0 punti MT5 = 0,70 punti indice** (la conversione si legge dai prezzi
stessi: 25983,80 − 25983,10 = 0,70). Su D30EUR `CONTRACT_SIZE = 10`, quindi
**1 lotto = 10 € per punto indice**:

| taglia | costo di QUELL'ingresso |
|---|---:|
| 0,30 lotti (quello vero) | **2,10 €** |
| ~1,0 lotto (taglia 100k) | **~7,00 €** |

## 🧐 E le tre righe insieme dicono una cosa precisa
- **l'INGRESSO paga** (70 punti avversi);
- **lo STOP no** (0,0 punti): è uscito **al prezzo esatto**;
- una terza uscita non ha un prezzo richiesto da confrontare, e il logger lo
  **dichiara** (`NESSUNA`) invece di inventare uno zero.

> ### 🔴 Ed è **coerente con la misura di R119** del 07/09: lì avevamo scoperto
> che `ExecutionMode` del tester modella **l'incertezza temporale, non il costo**.
> Questo è il costo vero, e **si paga all'ingresso.**
> ⚠️ **UN SOLO ingresso misurato**: non è una statistica, è il primo punto.
> Serve una serie prima di metterlo in un modello.

---

## 📊 IL CONTO REALE, in chiaro
| | |
|---|---|
| equity 08/09 apertura → chiusura | **7.500,00 → 7.507,65** = **+7,65 €** (+0,10%) |
| stato Guardian | `OK - operativo`, pausa off, cap off |
| rischio aperto | 0,00% (nessuna posizione overnight) |
| operazioni | 3 deal su **D30EUR** (1 ingresso, 2 uscite) |
