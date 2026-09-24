# 🎯 PERCHÉ LE SEDIE NON SPARANO — la prima misura, e un indiziato con nome e cognome

Seguito di `report/LA_CHALLENGE_NON_STA_OPERANDO_2026-09-24.md`. Stessa fonte: i referti di
**sola lettura** che il runner notturno scrive già sul VPS. **Nessuna riga nuova lanciata.**

---

## 1️⃣ 🟢 PRIMA IPOTESI ELIMINATA: **le sedie sono tutte attaccate**

`CODA_01_sedie_attaccate_20260924_033003.log`, profilo `Default` di `C:\FTMO` — **8 grafici**:

| # | sedia | simbolo | TF | magic | rischio |
|---|---|---|---|---|---|
| 1 | `CLAU12_DAX_Apertura_EU` | GER40.cash | M5 | `770101` | 2.0 |
| 2 | `CLAU12_Dow_Apertura_US` | US30.cash | M5 | `770202` | 2.0 |
| 3 | `CLAU12_Nasdaq_Apertura_US` | US100.cash | M5 | `770260` | 2.0 |
| 4 | `CLAU12_EMA200` | US30.cash | H1 | `771531` | 2.0 |
| 5 | `CLAU12_SuperWave_DOW_H1_Ottimizzato` | US30.cash | H1 | `770511` | 2.0 |
| 6 | `CLAU12_MaxMinNotte_DAX_Short_Ottimizzato` | GER40.cash | M15 | `770411` | 2.00 |
| + | `CLAU12_Guardian` | NZDJPY | H1 | `779001` | — |
| + | `ABTG_TradeExporter` | NZDUSD | H1 | — | — |

🟢 **Sei sedie, il Guardian e l'esportatore: tutto al suo posto.** L'ipotesi *"qualcuna si è
staccata"* è **morta con una misura**, non con un'opinione.

---

## 2️⃣ 📐 QUANTO DOVREBBERO SPARARE — il contratto, sommato

Dalle frequenze promesse in `report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` §6:

| sedia | promesso op/giorno |
|---|---:|
| `771531` EMA200 | 0,931 |
| `770101` DAX Apertura | 0,699 |
| `770260` Nasdaq Apertura | 0,360 |
| `770202` Dow Apertura | 0,348 |
| `770511` SuperWave DOW | ~0,294 |
| `770411` MaxMinNotte DAX Short | 0,051 |
| **ROSA INTERA** | **2,683 / giorno** |

| giornate di borsa | posizioni attese |
|---:|---:|
| 2 | **5,4** |
| 3 | **8,0** |
| 5 | **13,4** |

## 🔴 E quante ne abbiamo viste
| giorno | ordini piazzati | posizioni aperte |
|---|---|---|
| **22/09** | 3 (EMA200 ×2, DAX Apertura ×1) | ≥1 — il `dayLoss=2,20%` lo prova |
| **23/09** | **0** | **0** |
| **24/09** (alle 03:30) | **0** | **0** |

👉 **Attese ~5,4 in due giornate. Viste 3 piazzate, 1-2 aperte.** Siamo fra **un quarto e un
terzo** del contratto.

🔴 **MA IL CAMPIONE NON DECIDE, e lo dico prima che lo dica il numero**: **due giornate** non
condannano una rosa — è l'Emendamento B alla lettera (*il campione sottile sospende il MERITO, mai
il RISCHIO*). Questa non è una condanna: è **un'attesa dichiarata e un innesco**.

### 🚦 L'INNESCO, scritto ORA e non dopo aver visto i numeri
- entro **5 giornate di borsa** (cioè lunedì 28/09): attese **13,4** posizioni.
- 🟠 se saremo **sotto 7** (la metà), è una **revisione di frequenza** ai sensi del criterio del
  18/08 (*"frequenza molto sotto il promesso → revisione"*);
- 🔴 se saremo **sotto 4**, il problema non è la frequenza dei motori: è **un guasto**, e si va a
  cercarlo nei filtri.

---

## 3️⃣ 🕵️ L'INDIZIATO CON NOME E COGNOME: **`770260`, il Nasdaq**

**È l'UNICA sedia che ha logato qualcosa in tutti e due i giorni. E tutte e due le volte era un
RIFIUTO, per lo stesso motivo:**
```
22/09 16:11  CLAU12_Nasdaq_Apertura_US (US100.cash,M5)
             RETEST BUY: rottura con volumi insufficienti, salto (regola Emiliano).
23/09 16:06  CLAU12_Nasdaq_Apertura_US (US100.cash,M5)
             RETEST SELL: rottura con volumi insufficienti, salto (regola Emiliano).
```
🟢 **Buona notizia dentro la cattiva: quella sedia FUNZIONA.** Si sveglia all'ora giusta, vede la
rottura, arriva fino al retest e **decide**. Non è muta, non è staccata, non è rotta.
🔴 **La cattiva**: **2 occasioni su 2 fermate dallo stesso filtro**, il controllo dei volumi.

### 🔴 E c'è un precedente che trasforma il sospetto in un'ipotesi seria
`CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` §6 dice di `770260`, misurato **prima** della challenge:
> **campo piccolo `50503392`: 0 · campo 100k `50504263`: 0** — 🔴 *"**mai operata**: nessun
> forward, il contratto è **solo di banco**"*

👉 **Una sedia che in forward non ha MAI aperto una posizione, su due conti diversi, e che in
challenge rifiuta due volte su due per lo stesso motivo.** Il promesso di banco è 0,360 op/giorno;
il misurato in campo è **0,000** su tutti e tre i conti.
🔴 **Questa non è più bassa frequenza: è un'ipotesi di FILTRO CHE NON PASSA MAI**, e ha un modo
pulito per essere falsificata.

### 🧪 IL CONTRO-ESEMPIO, scritto prima di misurare
Se il filtro volumi fosse tarato bene, dovrebbe **lasciar passare** una frazione ragionevole dei
retest — diciamo almeno 1 su 3. L'ipotesi rivale è che la soglia dei volumi sia tarata su un
**feed diverso** (il banco quota `NASUSD` su BCM, la challenge quota `US100.cash` su FTMO: **due
broker, due scale di volume**) e che su FTMO non passi **mai**.
👉 **Le due ipotesi divergono su un numero solo**: la quota di retest accettati.
🔴 **0 su N con N ≥ 6** separa le due spiegazioni. Oggi N = 2: **non basta**, e non lo spaccio per
una conclusione.

---

## 4️⃣ ⚪ CHE COSA QUESTA MISURA **NON** DICE, e va detto

🔴 **Non so distinguere "la sedia ha valutato e ha detto no" da "la sedia non si è svegliata".**
Gli EA logano quando **agiscono**; il silenzio di cinque sedie su sei il 23/09 è compatibile con
tutte e due. 👉 È un **fail-open diagnostico**: la stessa famiglia di difetto che ci è costata il
binario `EMA200` senza Guardian.
**Serve una misura che distingua**, e le strade sono due:
1. 🟢 **gratis**: `InpVerbose` sulle sedie — ma accenderlo **tocca il forward**, quindi è una
   **firma di Claudio**, non una mia decisione;
2. 🟢 **gratis davvero e senza toccare niente**: contare, nei giornali delle prossime notti,
   **quante righe di rifiuto** produce ciascuna sedia. Il runner lo fa già da solo: basta
   leggerlo. **Costo zero, nessuna riga nuova.**

## 5️⃣ 🔜 L'ORDINE DELLE COSE
1. 🟢 **Aspettare due-tre notti e rileggere i giornali** — arriva da solo, costa zero, e porta N da 2 a 5-6.
2. 🟠 **La dashboard FTMO di Claudio** ha il conteggio ufficiale dei Trading Days: il mio è una
   ricostruzione dai log, il suo è il numero che conta.
3. 🔴 **`770260` è il candidato numero uno a una revisione**, ed è l'unica sedia della rosa con
   **zero posizioni su tre conti diversi**. Ma la revisione si fa con `N ≥ 6`, non con 2.
