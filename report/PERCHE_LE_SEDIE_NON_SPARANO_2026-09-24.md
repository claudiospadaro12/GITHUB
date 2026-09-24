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

## 3️⃣ ✏️ **L'INDIZIATO È STATO ASSOLTO** — correzione del 24/09, ore 06:30

🔴 **La prima stesura di questa sezione incriminava `770260` (Nasdaq Apertura)** come *"candidato
numero uno a una revisione"*, perché era l'unica sedia che avesse logato in tutti e due i giorni e
lo aveva fatto due volte su due per **rifiutare** (*"rottura con volumi insufficienti, salto"*).
**Ho costruito tre contro-esempi e sono andato a guardare. Tutti e tre hanno ucciso l'accusa.**

### ❌ Ipotesi 1 — *"la soglia dei volumi è tarata su un feed diverso"*. **FALSIFICATA dal sorgente.**
`ABTG_Nasdaq_Apertura_US.mq5` r.2513-2527, funzione `VolumeOKtf`:
```cpp
double avg = sum / n;                              // media delle n barre PRIMA della rottura
return((double)v[0] >= InpVolMult * avg);          // volume della barra di rottura
```
👉 La soglia è un **RAPPORTO** (barra ÷ media delle sue 20 precedenti, **sullo stesso simbolo**),
non un numero assoluto. 🟢 **Un rapporto è indipendente dalla scala del feed**: che il broker
dichiari volumi da 500 o da 50.000, il rapporto è lo stesso. L'argomento della "scala diversa"
**è morto**. *(Sopravvive un argomento di secondo ordine sulla granularità dei tick: più debole, e
non l'ho misurato.)*

### ❌ Ipotesi 2 — *"il filtro è acceso per sbaglio su quella sedia"*. **FALSIFICATA dall'archivio.**
Vero che è l'**unica** delle tre Aperture su FTMO ad avere `InpUseVolumeFilter=true` (DAX e Dow ce
l'hanno `false`). 🔴 Ma non è uno sbaglio: **è la cella migliore di un A/B che abbiamo già fatto.**
`risultati_archivio/Walkforward_Aperture/NASDAQ_B_motore_OOS.csv`, `InpEntryMode=2` — e la sedia in
campo gira **esattamente** `InpEntryMode=2`:

| filtro volumi | PF | n | **DD%** |
|---|---:|---:|---:|
| **acceso** (in campo) | **1,1094** | 94 | 🟢 **3,675** |
| spento | 1,0408 | 240 | 🔴 8,790 |

🟢 **Il filtro compra un DD 2,4 volte più basso e alza pure il PF.** Su una challenge dove il muro
giornaliero uccide il 18,2% delle corse, è un ottimo affare. **La sedia è configurata bene, e
contro una misura.**

### ❌ Ipotesi 3 — *"l'ora di sessione è sbagliata"*. **FALSIFICATA dal contro-controllo.**
`InpSessionHour=16:30` sul Nasdaq fa scattare l'allarme di casa (*"Nasdaq = 14 in ora server BCM;
se è 15 → cestinare"*). 🔴 Ma FTMO **non è BCM**. Il contro-controllo sono le altre due sedie:

| sedia | `InpSessionHour:Min` su FTMO | apertura vera (IT) | offset implicito |
|---|---|---|---|
| DAX | **10:00** | 09:00 | IT **+1** |
| Dow | **16:30** | 15:30 | IT **+1** |
| Nasdaq | **16:30** | 15:30 | IT **+1** |

🟢 **Tutte e tre concordi: il server FTMO è ora italiana +1** (GMT+3, la convenzione FTMO d'estate).
Quindi 16:30 server = **15:30 italiane = l'apertura vera**. ✅ **Giusto.** E torna anche con i log:
i due rifiuti alle 16:06 e 16:11 italiane cadono ~36 minuti dopo l'inizio sessione, cioè in pieno
retest.

### 🧮 E il conto che avrei dovuto fare PRIMA di incriminarla
A **0,360 op/giorno** promessi, in **3 giornate** le attese sono **1,08** posizioni.
👉 **P(zero) = 34,0%.** 🔴 **Zero posizioni in tre giorni su quella sedia è NORMALISSIMO**, non un
indizio. Avevo scambiato **una coincidenza visibile** (era l'unica a logare, perché è l'unica che
loga i rifiuti) **per un'anomalia**. Le altre cinque tacevano perché logano solo quando agiscono.

🔴 **La classe del difetto**: *ho preso per indiziato l'unico testimone che parlava.* La sedia col
filtro è anche l'unica che **dichiara** di aver deciso; le altre, mute, sembravano innocenti solo
perché non dicono niente. **La visibilità non è colpevolezza.**

---

## 3️⃣-bis 🔴 MA LO SCARTO DELLA **ROSA** RESTA, ED È SIGNIFICATIVO

Assolta la singola sedia, il numero d'insieme non se ne va. Test di Poisson su `λ = 2,683/giorno`:

| finestra | attese | osservate | P(≤ osservate) | lettura |
|---|---:|---:|---:|---|
| 2 giornate | 5,4 | 2 | 9,7% | 🟠 dentro la variazione |
| 2 giornate | 5,4 | **1** | **3,0%** | 🔴 **significativo** |
| 3 giornate | 8,0 | 2 | **1,3%** | 🔴 **significativo** |

👉 **Se il conto vero è 1-2 posizioni aperte, la rosa sta sparando meno del contratto in modo che
il caso non spiega.** Ma il numero esatto di posizioni **aperte** (non piazzate) non ce l'ho: gli
ordini che vedo sono **pendenti**, e un pendente non è una posizione.
🔴 **Ed è qui che morde un difetto già noto e ancora aperto**: `ABTG_Trades_FTMO.csv` esiste, è
fresco e pesa **0,4 KB**, ma `CODA_12` **non lo conta** perché cerca `position_id` mentre
l'esportatore scrive `pid`. **Il per-trade della challenge non entra in nessuna misura di casa.**
👉 **Riparare quel contatore è la cosa che trasforma questo sospetto in un numero**, e non tocca il
forward: è un confronto di nomi di colonna in uno script di lettura.

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
