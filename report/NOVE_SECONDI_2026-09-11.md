# ⏱️ NOVE SECONDI — un difetto **STRUTTURALE**, non sfortuna

**Trovato leggendo la pagella automatica delle 23:00 dell'11/09.**
`STREV NAS H1 S 1/3`, NASUSD: **ingresso 09:00:00 → uscita 09:00:09**, `sl`,
**−12,80 punti indice, −6,62 €.**

---

## 📊 1. È UN CASO ISOLATO? — no, è un **ESTREMO**

Tutte e 30 le operazioni della sedia in archivio `[MISURATO]`:

| | |
|---|---|
| durata **minima** | **9 secondi** ← questa |
| durata **mediana** | **29.040 secondi** (8 ore) |
| operazioni sotto il minuto | **1 su 30** |

E gli stop realizzati delle altre: `27,1 · 76,2 · 93,9 · 126,9 · 151,9 · 477,0`.
👉 **Quello di oggi è 12,80: meno della metà del più stretto mai visto.**

## 💸 2. E CONTRO LA FRONTIERA DEL COSTO **NON C'ERA PARTITA**

Spread NASUSD, ora server 9, **5.696.275 tick** `[MISURATO]`: **mediana 2,60**.

| | richiesto | stop vero | |
|---|---:|---:|---|
| pavimento **DI LAVORO** (40×) | **104,0 punti** | **12,80** | 🔴 **NO** |
| pavimento **DURO** (13,3×) | **34,6 punti** | **12,80** | 🔴 **NO** |

> ## 🔴 **Lo stop valeva 4,9 volte lo spread.** Il pavimento minimo di casa ne chiede 13,3. **Quel trade non poteva sopravvivere al rumore, e infatti è durato nove secondi.**

---

# 🔑 3. LA DIAGNOSI — e non è "sfortuna", è **COME È FATTO L'EA**

`ABTG_SupRev_NAS_H1_Ottimizzato.mq5` **r.248**:
```
double sl = isLong ? MathMin(stLine,ext)-buf : MathMax(stLine,ext)+buf;
```
👉 **Lo stop si mette SULLA LINEA del Supertrend.**

E la condizione d'ingresso, **r.57**:
```
input double InpNearAtr = 1.0;   // "chiude vicino": |chiusura - Supertrend| <= N*ATR
```
👉 **Si entra quando il prezzo chiude VICINO alla stessa linea.**

> ## 🎯 **Quindi: più il setup è "bello", più lo stop è stretto.**
> Entri perché il prezzo è **vicino** alla linea; lo stop sta **sulla** linea;
> quindi **la distanza è piccola per costruzione**. **Gli ingressi che sembrano
> migliori sono quelli con lo stop più fragile.** È una trappola avvitata dentro
> il meccanismo, non un caso.

## 🔴 E NON C'È NESSUN PAVIMENTO
`grep` degli input della SupRev NAS H1: **nessun `InpMinStopPts`, nessun
`InpSkipIfTight`, nessun minimo di nessun tipo.** Se la linea è a 3 punti, la
sedia entra con lo stop a 3 punti **e nessuno la ferma.**

---

# 🟢 4. MA LA RIPARAZIONE ESISTE GIÀ IN CASA

La famiglia **Aperture** ha esattamente quelle due manopole:
- `InpMinStopPts` — **alza** lo stop al pavimento;
- `InpSkipIfTight` — oppure **salta** il trade.

📌 **Ed è la stessa manopola che stamattina ha aperto R129**, dove abbiamo
misurato che a floor 6000 sulla Apertura **non si perde nemmeno un trade** e il
DD cala del 25%.

## 🎯 LA PROPOSTA — ed è piccola
**Portare `InpMinStopPts` + `InpSkipIfTight` nella famiglia SupRev**, tarati sul
pavimento del simbolo (**NASUSD: 34,6 punti il duro, 104,0 quello di lavoro**).

🔴 **Ma è una MODIFICA A UN EA CON SEDIE VIVE**, quindi **prima si misura**:
1. contare **quante** delle 30 operazioni avrebbero uno stop sotto il pavimento;
2. girare il round col pavimento **acceso e spento**, come R129;
3. **solo dopo** si parla di toccare il codice.

⚠️ **E il contro-esempio va costruito prima**: se il pavimento **salta** i trade
a stop stretto, e quelli erano **i migliori** (setup vicino alla linea = tesi
dell'EA), **il pavimento potrebbe togliere proprio i vincenti.**
👉 **Non lo so, e non lo invento. È esattamente ciò che il round deve misurare.**

---

## 📉 5. IL DANNO DI OGGI, in proporzione
**−6,62 €** su una giornata che ha chiuso a **+0,30 €**.
👉 Piccolo in assoluto — **ma senza quei nove secondi la flotta chiudeva a
+6,92 invece che in pareggio.** Il difetto non è il danno: **è che si ripeterà**.

> ## 🔥 Questa non l'ha trovata un round: l'ha trovata **la pagella automatica**, leggendo una colonna "durata" che di solito nessuno guarda. **Nove secondi erano l'unica cosa strana della giornata, ed erano un difetto di progetto.**
