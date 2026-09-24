# 🚨 LA CHALLENGE FTMO STA FERMA DA DUE GIORNI — e il Guardian invece è VIVO

**Tutto quello che segue viene dai log del runner notturno sul VPS**, letti stamattina dal repo.
🟢 **Nessuna riga nuova è stata lanciata**: sono referti di **sola lettura** che il VPS scrive da
solo alle 03:30 e che erano già in `backtest_pipeline/coda/referti/`. Zero rischio, zero CPU.

---

# 1️⃣ 🟢 LA NOTIZIA BELLA: **IL GUARDIAN SU FTMO È VIVO**, e vale +13,7 punti

`report/IL_PIANO_DEGLI_OTTO_GIORNI_2026-09-23.md` §3.2 lo dava **`[NON VERIFICATO]`** — *"non
sappiamo se sta girando"* — accanto al numero che lo rende la cosa più importante in campo:

> **il Guardian vale +13,7 punti percentuali** di probabilità di passare (70,3% → 84,0%), e li vale
> **annullando la modalità di morte principale**: senza di lui il **18,2%** delle challenge muore
> per il muro *giornaliero* del 5%.

## ✅ Adesso è VERIFICATO. Ecco la riga, dal giornale della notte scorsa:

```
24/09 03:30:04  CLAU12_Guardian (NZDJPY,H1)
[GUARDIAN] eq=78242.32  dayLoss=0.00%  totDD=2.20%  rischioAperto=0.00%  stato=OK  pausa=off  cap=off
```

🟢 **Logga ogni minuto, con equity, perdita di giornata, drawdown totale e rischio aperto.** Non è
attaccato e muto: sta misurando.

🟢 **E `pausa=off / cap=off` vuol dire "non scattati", non "spenti"** — e lo so perché ho il
contro-esempio: il **22/09 alle 23:55**, con `dayLoss=2.20%`, diceva **anche lì** `pausa=off`.
✏️ **CORRETTO il 24/09**: la prima stesura scriveva che la soglia di pausa è **4,0%**. 🔴 **Falso,
e il numero l'avevo messo a memoria.** Letta nel `.chr` in campo (`CODA_08` r.3437-3451):
`InpDailyPausePct=**3,5**` · `InpDailyLossPct=**4,5**` · `InpTotalDDPct=**9,3**` ·
`InpMaxOpenRiskPct=**4,00**` · `InpStartBalance=80000` · `InpAction=0`.
🟢 La conclusione **non cambia** (2,20% sta sotto 3,5% come stava sotto 4,0%: il meccanismo è
armato e non scattato), ma il numero sì — e un numero a memoria dentro un referto è un numero
che qualcuno userà.
🎯 **E una cosa torna al centesimo**: il *"la perdita di una giornata viene tagliata a 4,5%"* del
Monte Carlo è **esattamente** `InpDailyLossPct=4.5` con `InpAction=0`. Corrispondenza 1:1 fra il
modello e il campo.
🔴 **Resta aperto e non è mio**: `InpMaxOpenRiskPct=**4,00**` in campo contro il **3,25% firmato il
18/08**. Già chiesto a Claudio il 23/09, **ancora senza risposta**.

---

# 2️⃣ 🔴 LA NOTIZIA BRUTTA: **in due giorni interi non è stata aperta UNA posizione**

| giorno | righe di ordine sul conto `541452707` | equity a fine giornata |
|---|---|---|
| **lun 21/09** | 🔴 **NON MISURATO** — vedi §3 | — |
| **mar 22/09** | ✅ **4 righe**, di cui **3 ordini veri** e 1 salto | 78.242,32 · `dayLoss=2,20%` |
| **mer 23/09** | 🔴 **1 riga, ed è un SALTO** (nessun ordine) | 78.242,32 · `dayLoss=0,00%` |
| **gio 24/09** (alle 03:30) | 🔴 **0** | 78.242,32 · `dayLoss=0,00%` |

Le tre righe vere del **22/09** — l'unico giorno in cui qualcosa è successo:
```
08:00  CLAU12_EMA200 (US30.cash,H1)  SELL LIMIT 1 @ 52157.36  SL 52257.99  lot 9.11
08:00  CLAU12_EMA200 (US30.cash,H1)  SELL LIMIT 2 @ 52190.90  SL 52257.99  lot 13.67
11:43  CLAU12_DAX_Apertura_EU (GER40.cash,M5)  BUY LIMIT (retest) @ 25630.54  SL 25462.54  lot 9.52
```
E l'unica riga del **23/09** **non è un ordine**:
```
16:06  CLAU12_Nasdaq_Apertura_US (US100.cash,M5)
       RETEST SELL: rottura con volumi insufficienti, salto (regola Emiliano).
```

🔴 **L'equity è CONGELATA a 78.242,32 da martedì sera.** `rischioAperto=0,00%` in tutte le letture:
non c'è niente di aperto, e non è stato aperto niente.

## 📐 E questo tocca DIRETTAMENTE la domanda di stamattina sui 4 giorni di trading
FTMO conta un Trading Day quando **almeno una posizione viene APERTA**. Contando solo ciò che è
**misurato**:

| | |
|---|---|
| giorni di trading **confermati** | **1** (il 22/09) |
| giorni **non misurati** | 1 (il 21/09) |
| giorni **confermati a zero** | 2 (23 e 24/09) |
| giorni richiesti | **4** |

🟢 **Non è un'emergenza**, e il motivo è esattamente quello che ho scritto stamattina: **la
challenge non ha limite di tempo** e i 4 giorni non devono essere consecutivi. Nessuno ci sta
mettendo fretta.
🔴 **Ma è il sintomo di un problema vero, e il problema non sono i 4 giorni: è che le sedie non
sparano.** Due giornate di borsa piene a zero non erano nel piano.

### 🟢 Una cosa che invece torna, ed è una verifica gratis
`SL − ingresso ≈ 100 punti` × `lot 9,11 + 13,67` su `US30.cash` ≈ **2,2% di 80.000 €** — e il
Guardian ha chiuso il 22/09 con **`dayLoss=2,20%`**. 🟢 **L'aritmetica della taglia e il numero del
Guardian coincidono al centesimo.** Due strumenti indipendenti, stessa risposta: le taglie in campo
sono quelle che crediamo. *(Le taglie restano di Claudio: qui è solo una verifica, non una proposta.)*

---

# 3️⃣ 🔴 PERCHÉ IL 21/09 È UN BUCO: **il runner non ha girato per due notti**

I referti del runner ci sono per il 10→20 settembre e poi per il 23 e 24. 🔴 **Mancano il 21 e il
22** — cioè **le due notti intorno al blocco del VPS del 21/09 mattina**.
👉 L'incidente non ci ha solo rubato mezz'ora: ci ha portato via **la diagnostica notturna del
primo giorno di challenge**, che è il giorno che adesso non so misurare.

---

# 4️⃣ ✏️ E UNA NOTA DI `CLAUDE.md` VA CORRETTA — **il runner non è il pericolo che pensavamo**

`CLAUDE.md` dice, del runner delle 03:30:
> *"Finché non viene sospesa o spostata, ogni notte alle 03:30 il VPS rifà da solo quello che il
> 21/09 è stato fatto a mano"*.

🔴 **Misurato: è falso.** Il referto di stanotte
(`backtest_pipeline/coda/referti/REFERTO_RUNNER_20260924_033003.txt`) dice:

```
perimetro : SOLA LETTURA + corsia ROUND sul solo C:\MT5_Backtest
righe di coda: 12
eseguiti  : 12   (di cui in corsia ROUND: 0)
rifiutati : 0    falliti : 0    ESITO: COMPLETO
```

**Dodici righe, tutte in corsia LETTURA, zero in corsia ROUND**, per **~2,5 minuti** di lavoro
leggero in tutto. Nessuno Strategy Tester è partito.

🟢 **E il banco `50504400` è davvero spento**: il suo ultimo giornale è del **21/09 alle 14:51**,
cioè il giorno dell'incidente. La firma del 21/09 è rispettata.

## 👉 Quindi l'azione giusta NON è "sospendere il runner"
Sospenderlo spegnerebbe **12 sonde di sola lettura** che ogni notte ci consegnano i dati di questo
referto — compresa quella che ha appena verificato il Guardian. Sarebbe buttare il termometro
perché si teme la febbre.

🔴 **Il pericolo vero è un altro, ed è preciso: la corsia ROUND esiste**, punta a `C:\MT5_Backtest`
(il terminale che il 21/09 ha inchiodato la macchina) e **parte da sola se qualcuno mette una riga
di round in `CODA.txt`**. Oggi quella coda ne ha **zero**, e `CODA.txt` non è toccato dal 21/09 21:14.
👉 **Il rischio è ARMATO MA SCARICO.** La riparazione giusta è **un cancello che rifiuti la corsia
ROUND finché una challenge è viva**, non spegnere tutto. 🔴 È una modifica al runner, quindi **è una
firma di Claudio**, e la riga passerà dai cancelli come tutto il resto.

---

# 🔜 CHE COSA SERVE, in ordine di valore

1. 🔴 **Capire perché le sedie non sparano** — è la cosa che vale di più, perché una challenge che
   non opera non può vincere. Le ipotesi da separare con una misura, non con un'opinione:
   (a) i motori sono a bassa frequenza per costruzione e due giorni a zero sono nella norma;
   (b) qualche sedia è staccata o ha `Algo Trading` spento;
   (c) un filtro (news, spread, volumi) le sta bloccando tutte.
   👉 La (b) e la (c) si leggono **nei log che abbiamo già**: `CODA_01_sedie_attaccate` dice quali
   sedie sono attaccate, e il giornale dice quante volte un filtro ha detto "salto".
2. 🟠 **Il conteggio ufficiale dei Trading Days** sta nella dashboard FTMO di Claudio: lì il numero
   è quello che conta, e il mio è una ricostruzione dai log.
3. 🟠 **Riparare il contatore per-trade**: `ABTG_Trades_FTMO.csv` esiste, è fresco (24/09 03:27) ma
   pesa **0,4 KB**, e `CODA_12` **non lo conta** perché cerca la colonna `position_id` mentre
   l'esportatore scrive `pid` — difetto noto dal 23/09 e **ancora aperto**. Finché non si ripara,
   il per-trade della challenge **non entra in nessuna misura di casa**.
