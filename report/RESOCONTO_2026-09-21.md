# 📋 RESOCONTO DELLA GIORNATA — lunedì 21/09/2026

**Il primo giorno della challenge FTMO `541452707`.** Punto sul progetto, non sui
trade: lo scorecard degli EA lo fa la pagella delle 23:00 in un'altra chat
(`report/giornata_2026-09-21.md`), e questo file **non ci scrive sopra**.

---

## 🤖 COSA HA FATTO LA MACCHINA DA SOLA

🔴 **Poco, e per una ragione seria: alle 09:29 il VPS si è inchiodato.**

- **Il runner notturno NON ha prodotto referto.** L'ultimo in
  `backtest_pipeline/coda/referti/` è `REFERTO_RUNNER_20260920_033003.txt` —
  di **ieri**. La corsa delle 03:30 di oggi è partita ma non ha mai chiuso:
  alle 14:43 l'Utilità di pianificazione la dava ancora `esito=267009` =
  `SCHED_S_TASK_RUNNING`. 👉 **Stava girando da sei ore quando ha inchiodato la
  macchina, con le sei sedie della challenge che operavano sopra.**
- **Caccia automatica: nessun dossier nuovo** (`caccia_strategie/`, zero file
  dal 20/09). La Routine gira ogni 2 giorni.
- **Commit della giornata: 48.**

### Cosa è stato fatto per evitare il bis
- 🟢 **Runner delle 03:30 SOSPESO** (`Disable-ScheduledTask`, reversibile,
  verificato rileggendo l'attività: `Ready` → `Disabled`).
- 🟢 **Terminale banco `50504400` spento**, verificato: restano i quattro giusti
  (`C:\FTMO`, `C:\BCM_Reale`, `-V3`, il piccolo).
- 🟠 **Seconda cintura NON messa**: le **115 righe ROUND** (di cui **82 a tick
  reali**) sono ancora in `CODA.txt`. Se l'attività tornasse `Ready`, il
  caricatore è pieno.

---

## 💶 IL CONTO

| | |
|---|---|
| Challenge FTMO `541452707` | saldo **80.000,00 €**, equity **80.000,00 €**, profitto **0,00** *(fonte: schermata di Claudio, 16:45 ora server)* |
| Operazioni chiuse oggi | `[NON MISURATO]` — `data/statements/trades_auto.csv` è fermo al **18/09**; `ABTG_PubblicaTrades` gira alle **22:45** |
| Ordini vivi a fine giornata | 2 SELL LIMIT su `US30.cash` di `771531`, **non riempiti**, scadenza 21:00 server |
| `SlippageLogger` sul reale | `[NON MISURATO]` — nessun file nuovo dal 15/09 |

🔴 **Nota di onestà sul «dry-run 100k»** che questo resoconto cita per abitudine:
**non è più il metro**. Da oggi il metro è la challenge FTMO da 80.000 con muro
al **10% statico**. Il 100k resta un conto demo, non l'obiettivo.

---

## 🔬 COSA HO DECISO IO — e il numero che lo giustifica

1. **Tolto `InpMinRangePts=7200` dal preset Nasdaq** dopo averlo messo io stesso
   poche ore prima. Il contro-numero era **nostro**, del 20/09
   (`STOP_VS_SPREAD_FTMO` §6.2): il floor a 40× costa il **21%** delle giornate e
   **non alza il PF** sul Nasdaq. Il preset è tornato **identico** a quello
   schierato: 98 input, zero differenze.
2. **Bocciata la banda 4500/10800** che avevo proposto io: su 3.899 aperture vere
   avrebbe scartato l'**87,6%** dei giorni del 2026. La banda letterale della live
   (1700/4100) ne scarta il **100,0%**.
3. **Ritirato il round su `InpTrailStartR`**: la risposta era in archivio (il DD
   **sale in 5 righe su 5**) e r.2224 dice `<= 0` ⇒ **0 è il pavimento dell'asse**.
4. **Riparati tre difetti del nostro stesso cancello**, tutti misurati:
   **519/538/540** e la collisione sulla **542**.
5. **NON ho toccato il codice di r.2143** (il no-op del breakeven): `InpBEatR` fa
   già la stessa cosa senza patch, e quelle sedie stanno operando.

### 🔴 Dove ho sbagliato, oggi
- Ho proposto una banda **derivata con la radice del tempo**; il fattore vero
  misurato sui nostri dati è **1,2441 per raddoppio**, non 1,4142.
- Ho stimato il costo del pavimento all'**11%**; misurato: **26-33%**. Sbagliato
  di tre volte, e l'avevo già consegnato.
- Ho scritto una riga di lancio su **22 righe fisiche**: incollata in console, il
  `throw` della guardia **non ha fermato niente** (classe 538). A salvarla è stata
  la seconda rete.
- La mia specifica per la riga sui binari avrebbe cercato le righe `GUARDIAN`
  **nella cartella sbagliata e solo in coda** — cioè avrebbe fabbricato l'allarme
  che cercava (classi 545/546).
🟢 **Tutti e quattro trovati prima che costassero**, tre dal cancello e uno da un
agente. È il metodo che funziona, non la fortuna.

---

## ⚠️ COSA ASPETTA CLAUDIO

Solo cose che toccano **rischio, taglie o soldi** — quindi sue:

1. 🟠 **`InpBEatR = 0,5` sul Nasdaq `770260`.** Misurato in R199A: PF **+14,3%/+7,3%**,
   DD **−29,4%/−5,2%**, profitto **+94%/+22%**, **operazioni invariate**. È gestione
   del rischio ⇒ **firma sua**. Non promossa dai criteri che avevo dichiarato prima
   (il DD OOS scende del 5,2%, non del 20%).
2. 🟠 **`InpMinRangePts` sul Nasdaq**: misurato e **non proposto**. Compra DD e paga
   in frequenza su una sedia a 0,46 op/giorno.
3. 🟢 **Niente sul conto reale `10105439`.** Non è stato toccato e non c'è niente da
   decidere.

---

## 🎯 DOMANI

**Sul PC di backtest** (tre righe già gatate e mandate):
`R200C` (modo di trailing — la leva più grande mai misurata sul DD: **17,65% → 7,17%**
a PF e operazioni pari) → `R172D` (Dow, scritto il **16/09** e **mai girato**) →
`R201A` (DAX).

**Sul VPS**, quando c'è: la riga di **sola lettura** sui binari di `C:\FTMO`.
🔴 È la domanda più grossa ancora aperta: **i sei preset dicono
`InpUsaGuardian=true`, ma nessuno ha mai guardato i `.ex5`.** Il 12/09 il binario
in campo di `EMA200` era del **04/08**, 486 righe, **zero `InpUsaGuardian`**.

**Da fare da me**: la seconda cintura sulla coda (commentare le 115 righe ROUND),
e il round sulla parziale (`R199B`), che ha dentro il suo contro-esempio.

---

## 🧭 BUSSOLA

**Sedie nuove: zero.** Ma non è stata una giornata di solo ponteggio: **cinque round
veri** su sedie che operano, **tre manopole confermate coi numeri** invece che con
l'abitudine, **una fermata** prima che facesse danno, e **due buchi chiusi** nelle
reti — uno dei quali lasciava passare un round puntato sul **conto REALE**.

🔴 **E il problema aperto resta uno**: il DD della `770260` è dello stesso ordine di
grandezza del muro FTMO. Cinque round l'hanno circondato senza risolverlo.
**`R200C` è l'ultima porta.**
