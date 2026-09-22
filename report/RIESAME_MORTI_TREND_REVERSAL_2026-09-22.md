# 🪦➡️🔎 RIESAME DEI MORTI — famiglia **TREND / REVERSAL / CROSS**

**22/09/2026** · richiesta di Claudio: _«VOGLIO RIGUARDARE ED RIANALIZZARE CON TUTTI GLI
AGENTI TUTTI GLI EA CHE ABBIAMO CONSIDERATI MORTI. CE NE SONO UNA VALANGA»_
🖊️ **Direttiva integrata in corsa (22/09)**: _«INTANTO: DA PROVARE IN + TF MI RACCOMANDO,
OGNI STRATEGIA»_ — il punto **5** del certificato di morte è trattato qui come **il più
pesante dei cinque**, e la colonna TF è compilata **con i TF ELENCATI PER NOME**, mai si/no.

🛑 **SOLA LETTURA.** Zero round lanciati, zero righe consegnate, niente VPS, niente forward,
nessun preset toccato, nessuna sedia promossa o spenta. Costo di macchina speso: **0 passate**.

---

## 0. 🥁 LA NOTIZIA IN QUATTRO RIGHE

1. 🟢 **Il punto 5 del certificato NON era vuoto su questa famiglia: era il più pieno di tutti.**
   `ABTG_SupRev_*_Ottimizzato` ha uno sweep di **11 TIMEFRAME PER NOME** (M15 · M20 · M30 · H1 ·
   H2 · H3 · H4 · H6 · H8 · H12 · D1), **a TICK REALI**, su **due finestre**, per **quattro**
   dei cinque EA. Nessuno l'aveva mai letto per intero.
2. 🔴 **E quello sweep è il certificato di morte della famiglia**, perché mostra una cosa che
   nessun PF singolo poteva mostrare: sul Dow a tick reali l'IS fa **H2 = 3,50 · H3 = 0,49 ·
   H4 = 4,76**. Timeframe adiacenti, segnali quasi identici, PF che oscilla di **dieci volte**.
   **Quello non è un altopiano: è un pettine**, e vive dove `n` vale 26-54.
3. 🟢 **Il `0/8` di FiboH4 è UNA configurazione contata otto volte — verificato sui 96 CSV,
   non sulla prosa.** 96 righe, **6 combinazioni `Inp*` distinte**, di cui 2 sono **gemelli sul
   magic** ⇒ **3 celle vere**. Ma il seguito (`r139c`) lo uccide lo stesso, **per RISCHIO**.
4. 🟢 **La «riproduzione fallita» di `r132c` NON è un difetto del motore, e nemmeno del banco:
   è un criterio impossibile da rispettare.** Lo scarto vale **0,51-0,53 EUR su 10.000** =
   **0,005% del conto**, con `n` **identico 10 volte su 10** e **2 celle su 5 identiche al
   quinto decimale**. E il file prova stesso prescriveva la diagnosi giusta — che nessuno ha
   applicato.

---

## 1. 🎯 DOMANDA SPECIALE (a) — LA RIPRODUZIONE FALLITA DI `r132c`

### 1.1 Che cos'è, esattamente
`backtest_pipeline/prove/R132c_nearatr_U30USD.txt` congela un **cancello di determinismo**:
cinque celle dell'asse `InpNearAtr` erano già girate il 09/09 (etichetta `R123DNEARATR`) e
_«DEVONO TORNARE IDENTICHE, CIFRA PER CIFRA. Non "simili", non "entro il 1%"»_.
La notte del 12/09 `r132c` gira: **3 celle su 5 divergono**, il round è dichiarato **NULLO** e
`R132a`/`R132b` non partono. Da allora la famiglia `ABTG_SupRev_*` è bloccata **non dal PF**,
ma da quel cancello.

### 1.2 Che cosa è successo DAVVERO — letto sui CSV, al quinto decimale
Fonte: `backtest_pipeline/risultati_prove/dal_vps/ABTG_SupRev_DOW_H1_Ottimizzato/`
(`..._IS_r132c.csv` · `..._OOS_r132c.csv` · `..._IS_R123DNEARATR.csv` · `..._OOS_R123DNEARATR.csv`).
**Modello 4 = TICK REALI** · U30USD H1 · finestra 2024.09.26→2026.06.30 · `InpRiskPercent = 1,0`.

| `InpNearAtr` | IS archivio (profit / PF / DD% / n) | IS `r132c` | Δprofit | OOS archivio | OOS `r132c` | Δprofit |
|---|---|---|---:|---|---|---:|
| 0,50 | −315,18 / 0,63495 / 4,5938 / **64** | −314,65 / 0,63534 / 4,5935 / **64** | **+0,53** | −12,28 / 0,99155 / 6,2075 / **122** | −12,79 / 0,99120 / 6,2126 / **122** | **−0,51** |
| 0,75 | −284,14 / 0,76952 / 6,2458 / **99** | −283,61 / 0,76985 / 6,2455 / **99** | **+0,53** | 423,33 / 1,28433 / 6,2075 / **133** | 422,82 / 1,28389 / 6,2126 / **133** | **−0,51** |
| 1,00 | −15,58 / 0,98837 / 6,1656 / **117** | −15,45 / 0,98846 / 6,1656 / **117** | **+0,13** | 622,79 / 1,38944 / 5,9091 / **152** | 622,28 / 1,38900 / 5,9142 / **152** | **−0,51** |
| 1,25 | 6,74 / 1,00474 / 5,9539 / **122** | **identica al quinto decimale** ✅ | 0,00 | 643,57 / 1,32197 / 6,4033 / **172** | **identica** ✅ | 0,00 |
| 1,50 | −220,72 / 0,86503 / 7,1676 / **128** | **identica al quinto decimale** ✅ | 0,00 | 643,57 / 1,32197 / 6,4033 / **172** | **identica** ✅ | 0,00 |

### 1.3 I cinque fatti che nessuno aveva messo in fila
1. 🟢 **`n` è IDENTICO in 10 confronti su 10.** Il file prova stesso scrive (r.64-66):
   _«se non tornano, la prima cosa da guardare NON è il PF: è `n`. Un `n` diverso = dati o
   binario diversi. **Un PF diverso a `n` uguale = sizing diverso, ed è un'altra diagnosi**»_.
   👉 **La diagnosi prescritta non è mai stata applicata. `n` uguale ⇒ stesse barre, stessa
   finestra, stesso modello, stessi segnali. Il motore ha riprodotto la propria logica
   perfettamente.**
2. 🟢 **2 celle su 5 tornano identiche in ENTRAMBE le finestre.** Un banco non deterministico
   non produce 4 coincidenze esatte su 4.
3. 📏 **La grandezza**: scarto massimo **0,53 EUR su un deposito di 10.000** = **0,0053%**.
   Sul PF: **0,009%** (0,98846 contro 0,98837). Sul DD: **0,082%** (6,2126 contro 6,2075).
4. 🔬 **L'unico input che differisce l'ho isolato riga per riga: `InpVerbose` (r132c `0`,
   R123D `1`)** — più `InpMagic` (779460 / 784130) e `InpComment`. **Tutti gli altri 46
   campi `Inp*` coincidono.** E `InpVerbose` è **provatamente inerte**: in
   `mql5/Experts/ABTG_SupRev_DOW_H1_Ottimizzato.mq5` compare **solo due volte**, alla
   dichiarazione (r.108) e dentro `void Log(string m){ if(InpVerbose) Print(...); }` (r.119).
   Nessuna `Log()` ha effetti collaterali nell'argomento. **Il magic è già misurato inerte:
   G1 passato 949/949** (`report/MANOPOLE_INERTI_2026-09-09.md` r.40).
5. 🔬 **Anche il Guardian è inerte nel tester, e l'ho verificato nel sorgente**, non assunto:
   `ABTG_GuardiaIngresso` (`mql5/Include/ABTG_PausaGuardian.mqh` r.1719) esce con
   `if(!ABTG_CanaleEsiste()) return(true);` — **fail-open**, e nel tester le GlobalVariable del
   Guardian non esistono. Nessuna dipendenza da stato condiviso.

### 1.4 🧪 IL CONTRO-ESEMPIO — l'argomento che UCCIDEREBBE questa conclusione
> _«E se `InpVerbose` o il magic non fossero inerti? E se il motore avesse una sorgente di
> non-determinismo interna?»_

Risposta costruita e chiusa: (a) `grep` su `MathRand`, `GetTickCount`, `GetMicrosecondCount`,
`TimeLocal`, `rand()` nel sorgente → **zero occorrenze**; (b) `InpVerbose` ha **due** sole
occorrenze, entrambe innocue; (c) il magic entra solo in `SetExpertMagicNumber` e nei filtri
`POSITION_MAGIC` — nel tester gira **un solo EA**, quindi il filtro è tautologico; (d) se il
motore fosse non-deterministico, **le celle 1,25 e 1,50 non potrebbero tornare esatte**.
🟢 **Il contro-esempio non regge: il motore è deterministico.**

E l'argomento contrario — *«allora è il banco»* — regge solo a metà: un feed di tick diverso
avrebbe spostato **tutte** le celle, non tre su cinque. Le celle **non sono annidate** (l'EA
tiene **una posizione alla volta**: un segnale in più anticipato da un filtro più largo **ne
esclude** uno dopo), quindi una micro-divergenza su UNA operazione può stare nelle sequenze
0,50/0,75/1,00 e **non** in quelle 1,25/1,50. È coerente, ma resta **[INFERITO]**.

### 1.5 🏁 VERDETTO SU `r132c` — e cambia cosa si deve fare
> 🟢 **NON è un difetto del motore.** `n` identico 10/10, 2 celle bit-identiche, zero
> non-determinismo nel sorgente.
> 🟠 **NON è dimostrato che sia il banco**: il residuo dichiarato dall'audit del 12/09
> (`report/AUDIT_AL_CENTESIMO_2026-09-12.md` §4.2 — *«non posso verificare su quale terminale
> fisico girò R123D»*) resta aperto, e a questo si aggiunge il ricompilato (`.ex5` costruito da
> build MT5 diverse = aritmetica in virgola mobile diversa) — **[NON MISURATO]**.
> 🔴 **È un CRITERIO NON RISPETTABILE.** «Identiche cifra per cifra» è verificabile fra due
> passate **della stessa ottimizzazione, sullo stesso binario, nella stessa ora**. Fra due
> corse a **tre giorni e due driver di distanza** non lo è, e nessuna misura futura lo renderà
> tale. Il cancello non ha trovato un difetto: **ha trovato il proprio limite.**

**🔴 E c'è un fatto che rende la disputa quasi irrilevante — ed è la parte che vale davvero:**
**la cella che `r132c` doveva difendere è un PICCO, e lo dicono le ANCORE `R123B`/`R123C`, che
il registro dichiara *«mai giudicate per sé»*.** Le ho lette (stessi CSV, tick reali, rischio 1%):

| asse | cella | OOS PF sul vicino SINISTRO | **cella viva 3,5 / 9** | OOS PF sul vicino DESTRO |
|---|---|---:|---:|---:|
| `InpStMult` (AtrP 9 pin) | 3,0 → **3,5** → 4,0 | **0,95320** | **1,38944** | **1,09271** |
| `InpStAtrPeriod` (StMult 3,5 pin) | 8 → **9** → 10 | **1,16409** | **1,38944** | 🔴 **0,61023** |

> 🔴 **Su due assi su tre la cella viva ha almeno un vicino SOTTO 1,10, e su `InpStAtrPeriod`
> il vicino destro CROLLA a 0,61.** Regola di casa dichiarata col numero: **centro
> dell'altopiano, MAI il picco.** 👉 **Anche se `r132c` avesse riprodotto alla perfezione, la
> cella sarebbe stata scartata per REGOLA DI SELEZIONE.** L'unico asse piatto è `InpNearAtr`
> — ed è piatto perché **è inerte sopra 1,25** (OOS 1,25 e 1,50 danno **643,57 / 172 identici**).

### 1.6 🖊️ E IL TF C'ENTRA? (richiesta del 22/09) — **SÌ, ed è dirimente**
`InpNearAtr` è un **filtro d'ingresso** (r.206/213: `|close − Supertrend| <= N × ATR`), non un
pavimento dello stop. Quindi la sua sensibilità **scala con l'ATR**, cioè **col TF**: a H1 la
banda satura a 1,25; a H2/H4 saturerebbe altrove. 🔴 **Ma l'asse `InpNearAtr` non va rigirato**,
perché lo sweep sul TF (§2.1) dice già che sotto H1 il motore è **escluso per costo e per
rischio**, e sopra H1 non ha campione. L'asse non ha dove andare.

---

## 2. 🕰️ IL TIMEFRAME — LA COLONNA PIÙ PESANTE, COMPILATA PER NOME

### 2.1 🔥 LO SWEEP CHE NESSUNO AVEVA LETTO — 11 TF, **TICK REALI**, due finestre
Fonte: `backtest_pipeline/risultati_prove/ABTG_SupRev_*_Ottimizzato/*_IS.csv` e `*_OOS.csv`
(i file **senza** suffisso `_ohlc` sono a **tick reali**; quelli con `_ohlc` sono screening).
Rischio **1,0%** in tutte le righe. `Trades` = **deal**, non posizioni (classe 550: la parziale
è accesa, `InpTP1Pct=50`).

**`ABTG_SupRev_DOW_H1_Ottimizzato` · U30USD · TICK REALI**

| TF | IS PF | IS DD% | IS n | OOS PF | OOS DD% | OOS n | lettura |
|---|---:|---:|---:|---:|---:|---:|---|
| **M15** | 0,768 | 10,73 | 292 | 0,732 | **22,33** | 656 | 🔴 morto: merito + **rischio** |
| **M20** | 0,910 | 7,86 | 309 | 0,623 | **19,42** | 408 | 🔴 morto: merito + **rischio** |
| **M30** | 0,507 | 12,96 | 207 | 0,995 | 10,37 | 369 | 🔴 morto: merito + **rischio** |
| **H1** *(la cella viva)* | 0,923 | 6,30 | 118 | **1,436** | 4,82 | **155** | 🟠 unica con n≥150 in una gamba |
| **H2** | **3,502** | 1,84 | **54** | 1,147 | 4,86 | 109 | ⏸️ merito **sospeso** (n≪150) |
| **H3** | **0,490** | 3,96 | 26 | **0,226** | 8,65 | 65 | 🕳️ **il buco fra due "vette"** |
| **H4** | **4,758** | 2,21 | **35** | 1,941 | 3,25 | 46 | ⏸️ merito **sospeso** |
| H6 | 1,228 | 1,41 | 11 | 0,229 | 4,46 | 28 | ⏸️ |
| H8 | 0,000 | 0,58 | 2 | 0,969 | 5,73 | 41 | ⏸️ |
| H12 | 0,000 | 0,75 | 2 | 0,000 | 3,99 | 10 | ⏸️ |
| D1 | 0,000 | 0,41 | 2 | 0,000 | 0,00 | 0 | ⏸️ |

> # 🔴 **IL PETTINE — e vale come certificato di morte più di qualunque PF singolo**
> **IS a tick reali: H2 = 3,50 · H3 = 0,49 · H4 = 4,76.** Tre timeframe adiacenti, gli stessi
> identici prezzi, un PF che salta di **dieci volte** e torna giù.
> **Un edge non si comporta così. Un campione da 26-54 operazioni sì.**
> 👉 Ogni numero spettacolare di questa famiglia (i PF 2-5) vive **esattamente** dove `n` sta
> fra 11 e 55. Dove `n` supera 150 (M15/M20/M30) il PF sta fra **0,51 e 1,00** e il DD arriva
> a **22,3% a rischio 1%** ⇒ **~44% a rischio 2,0%** (fattore 1,956-1,990, classe 547).

**E lo stesso pettine, sugli altri tre EA della famiglia (tick reali, rischio 1%):**

| EA / simbolo | M15 | M20 | M30 | **H1** | H2 | H3 | H4 | H6 | H8 | H12 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| `SupRev_DAX_H1_Ott` D30EUR **IS** | 0,446 | 0,518 | 0,607 | 0,730 | **0,232** | **4,833** | **4,472** | 0,500 | 0,800 | **3,727** |
| `SupRev_DAX_H1_Ott` D30EUR **OOS** | 0,853 | 0,486 | 0,987 | **1,866** | 0,428 | 0,366 | 1,026 | **2,181** | 0,703 | 0,546 |
| `SupRev_DOW_H4_Ott` U30USD **OOS** | 0,671 | 0,838 | **1,370** | 1,149 | 0,846 | 0,930 | **2,324** | 0,921 | **1,599** | 0,030 |
| `SupRev_DAX_H4_Ott` D30EUR **OOS** | 0,689 | 0,661 | 0,625 | 0,996 | **2,084** | 0,572 | 1,525 | 0,263 | 0,943 | **15,147** |
| `SupRev_NAS_H1_Ott` NASUSD **OOS** | 0,894 | 0,680 | 0,868 | **1,688** | 1,356 | 0,334 | 0,892 | 0,792 | **3,572** | 1,165 |
| `SuperWave_DOW_H1_Ott` U30USD **OOS** | 0,826 | 0,753 | 0,868 | **1,328** | 0,983 | 0,995 | **0,077** | 0,915 | 0,000 | 0,000 |

> 🔴 **Sei serie, sei pettini.** `SupRev_DAX_H4` fa **15,15 a H12 su n=15**; `SupRev_NAS_H1` fa
> **3,57 a H8 su n=4**. 🟢 **E la colonna sotto H1 è monotona e concorde su tutte e sei: PF fra
> 0,45 e 1,37, DD fino al 30%.** Quella parte della tabella **non è rumore**, perché lì `n` è
> 180-666: **è la misura.** E dice che la famiglia sotto H1 **non ha edge**.

### 2.2 💰 LA FRONTIERA DEL COSTO, col numero (`stop ≥ 40 × spread`)
Misurata su U30USD su **64.711.285 tick** (`REGISTRO_TEST.md` r.2265-2288, spread di sessione
1,8-2,0 punti indice, commissione **0,0000 MISURATA** su n=302 deal):

| TF | gamba 2 / spread | esito |
|---|---|---|
| M5 | **11,5-13,1x** | 🔴 **sfonda il pavimento DURO 13,3x** |
| M15 | 20,0-22,6x | 🔴 escluso per costo (50-57% della frontiera) |
| M20 | 23,1-26,1x | 🔴 escluso per costo |
| M30 | 28,3-32,0x | 🔴 escluso per costo sulla gamba debole |
| **H1** | 33,6-45,2x | 🟠 la soglia 40x cade **dentro** la banda ⇒ **C3 FRAGILE** |
| H2 / H3 / H4 | 56,6-64,0x / 69,3-78,3x / 80,0-90,5x | 🟢 passano il costo |

E a M30, col `k = 0,968` **misurato** (non la radice del tempo): `SupRev_NAS_H1` **14,7x** ·
`SupRev_DAX_H4` **13,4x** · `SupertrendRev_Ott` XAUUSD **18,1x** · `SuperWave` U30USD **19,7x**
· `SupertrendReversal` 225JPY **3,6x**. 🔴 **Zero dei 14 motori di classe S passa il 40x a M30.**

> ### 🏁 CONCLUSIONE SUL TF PER TUTTA LA FAMIGLIA
> **Scendere di TF su questa famiglia NON È UNA MISURA MANCANTE: è una misura FATTA, due
> volte e in modo indipendente.**
> **(1)** i **numeri** a tick reali su 11 TF: sotto H1, PF 0,45-1,37 e DD fino al 30% a
> rischio 1%, su `n` 180-666 (campione **abbondante**, merito **leggibile**);
> **(2)** il **costo**: M5/M15/M20/M30 esclusi con lo spread misurato su 64,7 milioni di tick.
> 👉 Il punto 5 del certificato **è pieno, con i TF elencati per nome**, e il verdetto è:
> **la banda H1-H4 è l'unica viva per costo, e dentro quella banda solo H1 ha campione.**

### 2.3 📉 LA FREQUENZA, TF PER TF (pavimento 1,00 op/giorno **per FAMIGLIA**, 07/09)
Finestra U30USD 2024.09.26→2026.06.30 ≈ **445 giorni di borsa** (IS 40% ≈ 178 g, OOS 60% ≈ 267 g).
🔴 I numeri sono in **DEAL**, non in posizioni (classe 550). Il fattore deal→posizione per questa
famiglia è **[NON MISURATO]** (quello misurato, 2,0117, è di `EMA200` U30USD).

| TF | n OOS (deal) | **deal/giorno** | posizioni/giorno se il fattore fosse ~2 *(DERIVATO)* |
|---|---:|---:|---:|
| M30 | 369 | 1,38 | ~0,69 |
| **H1** | 155 | **0,58** | ~0,29 |
| H2 | 109 | 0,41 | ~0,20 |
| H4 | 46 | 0,17 | ~0,09 |

> 👉 **Anche nella sua casella migliore la sedia SupRev DOW è da ~0,3 posizioni/giorno.** Con la
> regola del 07/09 questo **non la scarta da sola** (il pavimento è di famiglia), ma a **nove
> giorni** dal 1° ottobre una sedia a 0,17-0,58 deal/g **non fa in tempo a dire niente**: per
> arrivare a 150 operazioni a H1 servono **~10 mesi**. È un fatto di **calendario**, e va detto.

---

## 3. 🎯 DOMANDA SPECIALE (b) — IL «0/8» DI `FiboH4_Multi`: **una sola, contata otto volte**

### 3.1 Il conto fatto sui CSV (non sulla prosa)
16 CSV in `backtest_pipeline/risultati_prove/ABTG_FiboH4_Multi/`, **96 righe**, modello **OHLC**
(suffisso `_ohlc`), rischio **1,0%**:

| cosa | misurato |
|---|---|
| righe totali | **96** |
| combinazioni `Inp*` **distinte** | **6** |
| `InpSymbols` | `GBPUSD;USDJPY;EURUSD` in **96 righe su 96** |
| `InpTF` | `16388` (**H4**) in **96 righe su 96** |
| assi realmente girati | **`InpEngulfLookback` (8/12/16)** × **`InpMagic` (772002/772003)** |

> 🔴 **`InpMagic` non è una strategia: è l'asse tecnico dei gemelli.** Le due coppie danno
> risultati **identici cifra per cifra in 48 confronti su 48** ⇒ cancello **G1 PASSATO**, e le
> combinazioni vere scendono da 6 a **3**.
> 🔴 **E gli «8 simboli» sono 8 GRAFICI, non 8 mercati**: il basket è sempre lo stesso; il
> simbolo del grafico cambia solo la **cadenza con cui `OnTick` guarda il basket**. Prova sui
> numeri: i 7 grafici forex danno **lo stesso identico `Trades`** (79 / 83 / 72 a seconda del
> lookback) e P/L che differisce di **meno di 10 EUR su ~420** (conversione di valuta).
> L'ottavo (XAUUSD) ha `n` 74 / 77 / 67 perché l'oro ha una cadenza di barre diversa.

### 3.2 🏁 RISPOSTA, coi CSV in mano
> # ✅ **È UNA SOLA CONFIGURAZIONE CONTATA OTTO VOLTE.** Più precisamente:
> **TRE celle vere** (l'asse `InpEngulfLookback`), ognuna **duplicata 2 volte sul magic** e
> **campionata a 8 cadenze di grafico** = 48 passate per finestra. **Zero simboli singoli.
> Zero TF alternativi. Zero manopole d'uscita mosse.**

### 3.3 🔴 MA IL SEGUITO LO UCCIDE LO STESSO — e per il RISCHIO, non per il merito
`r139c` (12/09) ha fatto la misura mancante: **GBPUSD da solo**, finestra lunga (pavimento dati
forex gen-1999, R102), **OHLC**, rischio **1,0%**. Fonte:
`risultati_prove/dal_vps/ABTG_FiboH4_Multi/*_r139c.csv`.

| `InpEngulfLookback` | IS PF | IS DD% | IS n (deal) | OOS PF | OOS DD% | OOS n (deal) |
|---:|---:|---:|---:|---:|---:|---:|
| 8 | 0,798 | **23,33** | 572 | 0,972 | **17,29** | 725 |
| 12 | 0,794 | **22,60** | 548 | 0,942 | **17,70** | 729 |
| 16 | 0,831 | **20,70** | 557 | 0,950 | **17,21** | 737 |

> 🔴 **DD 17,2-23,3% a rischio 1,0%** ⇒ **~34-46% a rischio 2,0%** (classe 547).
> **Emendamento B (16/08): il rischio si legge a QUALUNQUE `n`** — e qui `n` non è nemmeno il
> problema (1.120-1.309 deal per cella fra le due gambe).
> 🟢 **E la direzione dell'errore aiuta: l'OHLC SOTTOSTIMA il DD** (già scritto in casa per
> `r139a`), quindi il vero DD è **peggiore**. Il rifiuto per rischio è **robusto**.
> 🔴 **PF sotto 1,00 in ENTRAMBE le gambe, in tutte e tre le celle.**
> ### 🪦 **`FiboH4_Multi` è MORTO, col numero. Ma la targa va corretta: non «0/8 promossi» —
> ### «PF 0,79-0,97 e DD 17-23% @1% su GBPUSD, 3 celle su 3, IS e OOS».**

### 3.4 🖊️ E IL TF C'ENTRA? — **sì, ed è il buco che resta aperto**
`InpTF = 16388` (**H4**) in **96 righe su 96** *e* in tutte e 3 le righe di `r139c`.
🔴 **Questo motore non è MAI stato girato su nessun altro timeframe.** Il punto 5 del
certificato è **VUOTO**.
🟠 **Ma non giustifica un round, e il motivo è un numero**: a H4 il motore già fa **725-737
deal** in OOS, cioè **campione abbondante**, e con quel campione il PF è 0,94-0,97 e il DD 17%.
Scendere di TF su un motore che perde **con campione pieno** non cerca un edge: cerca un picco
di rumore (regola del 19/08). 👉 **Il TF mancante si DICHIARA, non si compra.**
**Costo se Claudio lo volesse comunque**: 3 celle × 3 TF (H1/M30/D1) × 2 finestre = **18 passate**,
`T = 0,6 + 0,077 × 18` = **1,99 min** (OHLC; a tick il forex non ha dati prima del 2024.07.05,
classe 273).

### 3.5 🧪 CONTRO-ESEMPIO (l'argomento che SALVEREBBE FiboH4)
> _«La cella `lookback = 8` in OOS sul basket è POSITIVA: PF 1,092-1,094 su n=82, DD 3,74%, e
> **1,281** sul grafico oro. E l'asse è MONOTONO (8 → 1,094 · 12 → 0,819 · 16 → 0,699): la
> pendenza dice di andare **sotto 8**, dove nessuno ha mai guardato.»_

🔴 **Non regge, e lo dicono tre cose**: (1) quel +1,09 è su **n = 82 deal ≈ 41 posizioni**,
merito **sospeso**; (2) la **stessa cella `lookback = 8`** misurata su un campione 9 volte più
grande (`r139c`, 725 deal) fa **0,972** con **DD 17,3%**; (3) il basket a tre valute su un
grafico solo è una **configurazione che non schiereremmo mai**. 🟢 Il contro-esempio si è
chiuso da solo: **la pendenza esisteva, il campione l'ha cancellata.**

---

## 4. 📊 LA TABELLA MADRE — ogni voce del perimetro, coi cinque punti

Legenda dei cinque punti: **①** PF · **②** n e DD · **③** uscita ad asse · **④** simboli gemelli
· **⑤** TF (⟵ **il più pesante, elencato per nome**).
🔴 **Modello** accanto al PF sempre. 🔴 **`InpRiskPercent`** sempre. 🔴 **IS/OOS o finestra unica** sempre.

| # | candidato | sym | TF vivo | modello | finestra / split | rischio | PF IS / OOS | n (deal) | DD% IS/OOS | ① | ② | ③ | ④ | ⑤ TF provati **per nome** | VERDETTO | cosa manca | via più corta | costo |
|---|---|---|---|---|---|---|---|---|---|:-:|:-:|:-:|:-:|---|---|---|---|---|
| 1 | `SupRev_DOW_H1_Ott` (970916) | U30USD | H1 | **tick** | 2024.09.26→2026.06.30, split 40/60 | 1,0% | 0,923 / **1,436** | 118 / 155 | 6,30 / 4,82 | ✅ | ✅ | 🟠 | ✅ | **M15·M20·M30·H1·H2·H3·H4·H6·H8·H12·D1** | 🪦 **MORTO — PICCO su 2 assi su 3** (vicino `AtrP 10` = **0,610**) + **pettine sul TF** | nulla di decisivo | *(vedi §5, cella `StMult 4,5`)* | 8 passate · 1,2 min |
| 2 | `SupRev_DAX_H1_Ott` (970911) | D30EUR | H1 | **tick** | idem | 1,0% | 0,730 / **1,866** | 67 / 156 | 5,53 / 4,47 | ✅ | ✅ | ❌ | ✅ | **11 TF, per nome come sopra** | 🪦 **MORTO** — spenta l'11/08 su IS rosso; pettine IS H2 0,23 / H3 4,83 | ③ | — | — |
| 3 | `SupRev_DAX_H4_Ott` (970912) | D30EUR | H4 | **tick** | idem | 1,0% | — / 1,525 | — / 60 | — / 4,24 | ✅ | ✅ | ❌ | ✅ | **11 TF** | 🪦 **MORTO** — `n`=60 ⇒ merito **sospeso**; **H12 = 15,147 su n=15** è la firma del rumore | ③ + campione | il campione a H4 **non esiste** prima del 2027 | ∞ |
| 4 | `SupRev_NAS_H1_Ott` (970913) | NASUSD | H1 | **tick** | idem | 1,0% | — / **1,688** | — / 86 | — / 0,86 | ✅ | ✅ | ❌ | ✅ | **11 TF** | ⏸️ **NON ANCORA MISURATO per il MERITO** (n=86≪150) · 🟢 **assolto sul rischio** (DD 0,86%) | ③ + campione | vedi §5 riga 3 | — |
| 5 | `SupRev_DOW_H4_Ott` (970914) | U30USD | H4 | **tick** | idem | 1,0% | — / **2,324** | — / 49 | — / 2,73 | ✅ | ✅ | ❌ | ✅ | **11 TF** | 🪦 **promozione REVOCATA 30/07** («illusione OHLC», PFmed IS 0,741 / OOS 0,921) · n=49 | ③ | — | — |
| 6 | `SupRev_CAC_H4_Ott` (970915) | F40EUR | H4 | 🔴 **solo OHLC** | idem | 1,0% | 0,632 / 0,760 *(PFmed)* | 71 / — | 5,23 / — | ✅ | ✅ | ❌ | ✅ | **11 TF ma SOLO OHLC** | 🪦 **promozione REVOCATA 30/07** (RT 0,96) | ③ + **lo sweep TF a TICK** | — | — |
| 7 | `SupRev` **100GBP H1** (FTSE) | 100GBP | H1 | **OHLC** | unica 2024.01→2026.06 | 1,0% | **0,882** *(best)* / — | 160 | 4,55 | ✅ | ✅ | ❌ | ✅ | **H1 · H4** | 🪦 **MORTO col numero — 0/27 celle positive**, `n`=160 ≥150 ⇒ merito **leggibile** | ③; TF solo 2 | — | — |
| 8 | `SupRev` **100GBP H4** | 100GBP | H4 | **OHLC** | unica | 1,0% | 1,289 *(best)* / — | 48 | 2,04 | ✅ | ✅ | ❌ | ✅ | **H1 · H4** | ⏸️ **NON MISURATO** (n=48) — ma **fuori calendario**: ~19 op/anno ⇒ 150 op nel **2034** | ③ ⑤ + campione | non esiste | ∞ |
| 9 | `SupRev` **E50EUR H1/H4** (Stoxx) | E50EUR | H1/H4 | **OHLC** | unica | 1,0% | 1,474 / 2,800 *(best)* | 60 / 49 | 1,21 / 0,60 | ✅ | ✅ | ❌ | ✅ | **H1 · H4** | ⏸️ **NON MISURATO** — 6/27 e 10/27 positive, campione ridicolo | ③ ⑤ + campione | non esiste | ∞ |
| 10 | `SupRev` **F40EUR H1** (CAC) | F40EUR | H1 | **OHLC** | unica | 1,0% | 1,285 *(best)* | 131 | 6,37 | ✅ | ✅ | ❌ | ✅ | **H1 · H4** | ⏸️ **NON MISURATO** (n=131 < 150, manca poco) | ③ ⑤ | vedi §5 riga 4 | 8 passate · 1,2 min |
| 11 | `SupRev` **225JPY H1/H4** (Nikkei) | 225JPY | H1/H4 | **OHLC** | unica | 1,0% | 2,157 / 2,163 *(best)* | 75 / 27 | 0,22 / 0,12 | ✅ | ✅ | ❌ | ✅ | **11 TF** *(via `SupertrendReversal` base)* | 🪦 **scartato per TAGLIA DEL CONTRATTO**, non per edge (profitto ~50 EUR) · e `stop/spread` **3,6x** a M30 | nulla | — | — |
| 12 | `SuperWave` **D30EUR H1** (cross) | D30EUR | H1 | **OHLC** | unica | 1,0% | **0,842** *(best)* | 228 | **12,58** | ✅ | ✅ | ❌ | ✅ | **D1·H1·H2·H3·H4·H6·H8·H12·M15·M20·M30** | 🪦 **MORTO VERO** — 0/9 positive, `n`=228 ⇒ merito leggibile, **DD 12,58% @1% ⇒ ~25% @2%** | nulla | — | — |
| 13 | `SuperWave` **NASUSD H4** | NASUSD | H4 | **OHLC** | unica | 1,0% | **0,778** *(best)* | 18 | 1,63 | ✅ | ✅ | ❌ | ✅ | **11 TF** | ⏸️ **NON MISURATO** (n=18) · 🟢 assolto sul rischio | ③ + campione | il gemello H1 (n=95, PF 1,265) è già sotto soglia | — |
| 14 | `SuperWave` **XAUUSD H1/H4** | XAUUSD | H1/H4 | **OHLC** | unica | 1,0% | 1,061 / 0,908 *(best)* | 122 / 28 | 3,27 / 3,80 | ✅ | ✅ | ❌ | ✅ | **11 TF** | ⏸️→🪦 **NON MISURATO per campione**, ma **il cross non batte il SupRev sull'oro** e la famiglia Supertrend è chiusa (§6) | ③ | — | — |
| 15 | `SuperWave_DOW_H1_Ott` (770511) | U30USD | H1 | **tick** | split 40/60 | 1,0% | — / **1,328** | — / 143 | — / 3,91 | ✅ | ✅ | ❌ | ✅ | **11 TF** | ⏸️ n=143 (7 sotto il muro) 🔴 **e il banco ha un difetto NON ISOLATO**: `n` dipende dal **deposito** (131→184, **+40%**, da 10k a 100k) | ③ + **buco M45** | isolare M45 | 4 passate · 0,91 min |
| 16 | `SupertrendReversal_Multi_Ott` | XAUUSD | M30 | **tick** | split | **2,0%** | 1,256 / 1,087 | 257 / 427 | 10,66 / **22,06** | ✅ | ✅ | ❌ | ✅ | **11 TF** | 🪦 **scartata per REGOLA DI SELEZIONE** (PICCO: vicini M20 IS 0,709 · H1 IS 0,984) · 🟢 **non** per rischio (22,06%@2,0 ⇒ ~7,17%@0,65) | — | — | — |
| 17 | `SupertrendReversal_Multi_Ott` | XAUUSD | **M15** | **tick** | split | **2,0%** | **0,753** / 1,143 | 511 / 882 | **42,58** / 18,48 | ✅ | ✅ | ❌ | ✅ | **11 TF** | 🪦 **MORTO PER RISCHIO** (DD IS 42,58% @2,0 ⇒ 13,84% @0,65) | — | — | — |
| 18 | `FiboH4_Multi` | basket + GBPUSD | H4 | **OHLC** | 96 righe unica + `r139c` split | 1,0% | 0,79-0,83 / 0,94-0,97 | 548-572 / 725-737 | **20,7-23,3** / **17,2-17,7** | ✅ | ✅ | ❌ | 🟠 | 🔴 **H4 e BASTA** (96/96 righe + 3/3 di `r139c`) | 🪦 **MORTO PER RISCHIO** (§3.3) | ③ ⑤ | dichiarati, non comprati | 18 passate · 1,99 min |
| 19 | `LiquiditySweep` (R89) | GBPUSD | H1 | **tick** | split | 1,0% | **0,232** / 1,057 | **14** / 24 | 7,74 / 5,87 | ✅ | ✅ | 🟠 | ❌ | 🔴 **UN SOLO TF** | ⏸️ **NON ANCORA MISURATO** · 🔴 **ma il MECCANISMO è ucciso altrove** (§7) | ④ ⑤ | sonda, non round | **0 passate** |
| 20 | `EMA200` **H4 forex due lati** | GBPUSD·AUDJPY·GBPJPY·XAUUSD | H4 | **tick** | 🔴 **FINESTRA UNICA + genetica** | 1,0% | **[IN CAMPIONE]** 1,148-1,348 · 1,076-1,845 · 1,019-1,369 · 1,092-1,882 | 274-380 · 255-347 · 204-287 · 130-250 | 5,78-9,22 · 2,89-9,46 · 3,79-7,03 · 5,08-8,32 | ✅ | ✅ | 🟠 | ✅ | **M30 · H1 · H4** | 🟠 **NON È VALIDATO: È SELEZIONE** (§8) | **lo SPLIT IS/OOS** | §5 riga 1 | 48 passate · 4,3 min |

🔴 **NOTA DI RICONCILIAZIONE, perché due numeri veri della stessa cella non coincidono e non
devo nasconderlo.** La riga 1 della tabella madre (`0,923 / 1,436`, `n` 118/155) viene dallo
**sweep del TF** (`risultati_prove/ABTG_SupRev_DOW_H1_Ottimizzato/*_IS.csv`), la riga
`NearAtr = 1,00` di §1.2 (`0,98837 / 1,38944`, `n` 117/152) viene da **`R123D`/`r132c`**. Stesso
EA, stesso simbolo, stesso TF, stesse date dichiarate, **tick reali entrambi** — e `n` differisce
di **1 e di 3**. 👉 **Non l'ho spiegato, e lo dichiaro come buco**: è la stessa classe del
difetto **M45** (su `SuperWave_DOW_H1_Ott` il numero di operazioni **dipende dal deposito**,
131→184 a parità di tutto il resto). Finché M45 non è isolato, **i confronti d'archivio su
questa famiglia a depositi diversi non sono confrontabili**, e la differenza 118/117 e 155/152
va attribuita alla **taglia** prima che all'edge.

---

## 5. 🏆 LA CLASSIFICA DEI RESUSCITABILI — ordinata per vicinanza a una sedia del 1° ottobre

> 🛑 **Premessa onesta, e va letta prima della classifica: in questa famiglia NON c'è un
> resuscitabile che arrivi in campo il 1° ottobre.** I quattro qui sotto sono ordinati per
> **valore della misura**, non per probabilità di schieramento. Chi promette una sedia in nove
> giorni da qui sta vendendo un picco.

| # | candidato | **L'UNICA misura che sblocca** | attesa dichiarata PRIMA | cosa la uccide (scritto prima) | costo |
|---|---|---|---|---|---|
| 🥇 **1** | **`EMA200` H4 forex due lati** — GBPUSD + AUDJPY | 🔬 **Rigirare le 24 celle già note con uno SPLIT IS/OOS dichiarato e l'ottimizzatore NON genetico.** Oggi sono **finestra unica** + `Optimization=2` ⇒ le celle sono **scelte**, non trovate | PF OOS **≥ 1,10 su almeno 18 celle su 24**, DD OOS **≤ 9,2%** @1% | se le celle ≥1,10 in OOS scendono **sotto 12/24**, il «24/24» era **selezione**: si chiude | **48 passate** · `T=0,6+0,077×48` = **4,3 min** |
| 🥈 **2** | **`SupRev_DOW_H1` — l'asse `InpStMult` OLTRE 4,5** | 🔬 `StMult` **5,0 / 5,5 / 6,0**, `AtrP 9` e `NearAtr 1,0` pinnati, **tick reali**, stesse due finestre. Motivo: **4,5 è l'UNICA cella dell'intero blocco R123 positiva in ENTRAMBE le gambe** (IS PF **2,017** n=97 DD 3,75% · OOS PF **1,418** n=117 DD 5,70%) **ed è al BORDO dell'asse** | `n` in discesa (60-100 IS); PF OOS **≥1,10 su ALMENO 2 delle 3** nuove celle | 🔴 **se 5,0 e 5,5 non sono entrambe ≥1,10 in OOS, la 4,5 era un PICCO al bordo e l'asse si chiude per sempre.** *(E il salto 4,0 → 4,5 è da 0,721 a 2,017 in IS: già oggi somiglia a rumore)* | **8 passate** (3 nuove + la 4,5 come ancora) × 2 finestre = **1,2 min** |
| 🥉 **3** | **`SupRev_NAS_H1_Ott` — il campione** | 🔬 **Allungare la finestra su NASUSD**, non cambiare parametri: OOS PF **1,688** con DD **0,86%** @1% è il profilo di rischio migliore della famiglia, ma `n`=86 | `n` ≥ 150 per gamba se la finestra raddoppia; PF che **regge sopra 1,30** | se, raddoppiando il campione, il PF scende sotto 1,10 ⇒ era regime. **E il dato storico BCM su NASUSD va SONDATO**, non assunto | sonda dati: **0 passate**; poi 2 celle × 2 = **4 passate · 0,91 min** |
| 4️⃣ | **`SupRev` F40EUR H1 (CAC)** | 🔬 **Riportare a TICK REALI le 27 celle OHLC**: best PF 1,285 su `n`=131, a **19 dal muro** | PF a tick **entro −15%** dell'OHLC (l'OHLC è ottimista) ⇒ atteso 1,09-1,29 | se a tick il best scende **sotto 1,10** si chiude. 🔴 **E il gemello H4 è già REVOCATO** (RT 0,96) | 27 celle × 2 = **54 passate · 4,8 min** |

### 🧪 IL CONTRO-ESEMPIO PER OGNI RESUSCITABILE (regola del 10/09 — l'ho costruito io)
- **#1 `EMA200` H4 forex** — *l'argomento che lo uccide*: l'ottimizzatore genetico ha valutato
  **24 celle a due lati su GBPUSD** su una griglia che ne contiene **6 × 5 × 4 = 120**.
  🔴 **96 celle a due lati non sono MAI state calcolate**, e quelle 24 sono proprio quelle verso
  cui il genetico è **convergito**. Prova che la popolazione è drogata: **sul file intero la
  PF mediana è 0,9813** (GBPUSD), **0,6063** (GBPJPY) — cioè il genetico ha valutato anche i
  disastri. *(⚠️ precisazione onesta: quella mediana include anche le celle a **un lato solo** e
  quelle con `Trades = 0` e `PF = 0,00000` — non è la mediana delle sole celle a due lati, che
  vale 1,2330. Serve a dire **che il genetico ha valutato anche il brutto**, non a giudicare
  le celle a due lati.)* E il gradiente visibile (PF cresce con
  `InpOrder2Atr` da 0,2 a 0,6) finisce **al bordo dell'asse**, mai esteso a 0,7-0,8.
  ➕ Nota di rischio: **DD 5,78-9,22% @1% ⇒ 11,3-18,3% @2,0%** — **sopra il muro FTMO del 10%**.
  A 0,65% fa 3,76-5,99%. **La taglia non è un dettaglio: è il verdetto.**
- **#2 `StMult` oltre 4,5** — *l'argomento che lo uccide*: `n` = 97 (IS) e 117 (OOS), **merito
  SOSPESO in entrambe** per l'Emendamento A. Una cella con merito sospeso su due gambe non può
  promuovere niente: **può solo aprire o chiudere un asse.** E il pettine del TF (§2.1) dice che
  in questa famiglia i PF 2-5 abitano dove `n` < 60.
- **#3 `NAS_H1`** — *l'argomento che lo uccide*: **DD 0,86% su n=86 è troppo bello.** Un DD così
  basso su un campione così magro è il sintomo classico di poche operazioni fortunate. E per
  classe 562 un limite superiore **sotto** la soglia **dimostra** la sicurezza — ma **solo per
  quelle 86 operazioni**, non per le prossime 150.
- **#4 `F40EUR H1`** — *l'argomento che lo uccide*: 8/27 celle positive = **70% di celle in
  perdita**. Il «best 1,285» è il massimo di una distribuzione centrata **sotto 1,00**, e il
  suo gemello H4 ha già fallito il passaggio OHLC→tick (1,79 → 0,96). **La stessa transizione,
  sullo stesso simbolo, è già stata misurata e ha perso.**

---

## 6. 💀 I MORTI VERI — col numero brutto scritto

| candidato | numero che lo uccide | modello | rischio | perché è COMPLETO |
|---|---|---|---|---|
| `SuperWave` **D30EUR H1** | best PF **0,84186**, DD **12,58%**, `n`=228, **0/9 celle positive** | OHLC (**ottimista**) | 1,0% ⇒ DD ~**25%** @2,0% | merito leggibile (n≥150) **e** rischio sfondato. Doppio cancello |
| `SupRev` **100GBP H1** (FTSE) | best PF **0,88223**, **0/27 celle positive**, `n`=160 | OHLC (**ottimista**) | 1,0% | 0 celle positive su 27 con modello ottimista e campione sopra il muro |
| `FiboH4_Multi` (GBPUSD, `r139c`) | PF **0,794-0,831 IS / 0,942-0,972 OOS**, DD **17,2-23,3%**, `n` 548-737 deal per gamba | OHLC (**sottostima il DD**) | 1,0% ⇒ **34-46%** @2,0% | rischio a qualunque `n` (Emend. B) + merito su campione abbondante |
| `SupertrendReversal_Multi_Ott` XAUUSD **M15** | PF IS **0,75293**, DD IS **42,58%** | tick | **2,0%** (⇒ 13,84% @0,65%) | IS in perdita su `n`=511 deal + rischio |
| `SupRev_DAX_H1_Ott` **a M30** | PF **0,607 / 0,988**, DD IS **12,00%**, `n` 181/328 | tick | 1,0% | entrambe sotto 1,10 + DD>10% + **escluso per costo** (28-32x < 40x) |
| `SupRev_NAS_H1_Ott` **a M30** | PF **0,782 / 0,868**, `n` 84/185 | tick | 1,0% | entrambe sotto 1,10 + **`stop/spread` 14,7x** a M30 |
| **tutta la famiglia sotto H1** | PF 0,45-1,37 su `n` 180-666, DD fino a **30%** @1%, su **6 serie indipendenti** | tick | 1,0% | campione abbondante + costo misurato su 64,7 M di tick |
| `SupRev` **225JPY** H1/H4 | best PF 2,16 ma **profitto ~50 EUR** · `stop/spread` **3,6x** a M30 | OHLC | 1,0% | 🔴 **scartato per TAGLIA DEL CONTRATTO, non per edge** — la distinzione resta agli atti |

### 🧪 CONTRO-ESEMPIO SUI MORTI (l'argomento che li SALVEREBBE — costruito e chiuso)
> _«Sono quasi tutti **OHLC**, cioè screening. E il punto ③ (uscita ad asse) è vuoto quasi
> ovunque: per il certificato del 09/09 il verdetto dovrebbe essere NON ANCORA MISURATO.»_

🟢 **Vero in generale, e per questo le righe ⏸️ della tabella madre restano ⏸️.** Ma sui morti
qui sopra l'argomento si chiude per **tre** motivi separati:
1. **la direzione dell'errore**: l'OHLC è **ottimista sul PF** e **sottostima il DD**. Un
   modello ottimista che dà **0 celle positive su 27** (FTSE) o **0 su 9** (DAX cross) non sta
   nascondendo un edge — è l'eccezione che il repo aveva già concesso a `EMA200 E50EUR`;
2. **il rischio non ha bisogno del certificato**: Emendamento B, *il rischio si legge a
   qualunque `n`*. DD 12,6% / 17-23% / 42,6% a rischio **1-2%** sono **fatti accaduti**;
3. **il punto ③ non può salvarli, e c'è una misura in casa che lo dice**: su `EMA200` U30USD
   mettere ad asse le quattro manopole d'uscita ha spostato il PF OOS di **0,24 punti**
   (1,28144 → 1,52365) e il DD di 6,1 punti. 👉 **0,24 punti non portano 0,84 a 1,10** (ne
   servirebbero 0,26 **più** un DD dimezzato), e non portano **0,97** sopra 1,10 con un DD del
   17%. **Una gestione rimodella un edge, non lo crea.**

---

## 7. 🌊 `ABTG_LiquiditySweep` — lo stato vero, coi numeri

| cosa | numero | fonte |
|---|---|---|
| `r89agbp` GBPUSD H1, **tick**, rischio 1% | IS **PF 0,23179 · DD 7,74% · n=14** · OOS **PF 1,05655 · DD 5,87% · n=24** | `risultati_archivio/r86_r87_r89_csv/` |
| gemelli sul magic (772603/772604) | **identici cifra per cifra** ⇒ G1 **PASSATO** | idem |
| `r89bgbp` — asse ore di sessione | 🔴 **MANOPOLA INERTE**: 9 passate, **3 esiti distinti**. `InpSessStartHour` 6/7/8 danno numeri **identici** a parità di ora di fine | idem |
| `n` sull'asse sessione | **1-9 trade** per cella | idem |

> 🔴 **R89 non ha chiuso un motore: ha chiuso un campione da 14 operazioni, con un asse che non
> mordeva.** Certificato: ③ 🟠 (l'unico asse girato è la sessione, ed è inerte) · ④ ❌ (solo
> GBPUSD) · ⑤ ❌ (**solo H1**). **Verdetto: NON ANCORA MISURATO.**

🔴 **MA il MECCANISMO è stato ucciso altrove, e con un campione enorme.** La sonda del 09/2026
(`REGISTRO_TEST.md` r.988-1000) ha chiuso il buco della densità — pivot(3,3) dà **4,22-4,57
segnali/giorno per lato su DAX M5** — e poi ha misurato l'edge:
**su 22.616 segnali, TP-prima-di-SL 43,5-48,2% contro il 49,6% richiesto (8/8 sotto)**, e il
**delta contro un ingresso CASUALE della stessa geometria è −0,2 punti**.
> 🪦 **Lo sweep di micro-pivot sugli indici M5/M15 è MORTO, e la prova è il controllo a ingressi
> casuali.** 🟢 **Resta viva UNA variante mai misurata**: il **BREAKIN del box notturno** (falsa
> rottura → reversal), che **non ha nessun file prova**. 👉 **Via più corta: una SONDA come
> quella del 22/09 sul Supertrend — ZERO passate di tester**, prima di scrivere qualunque
> file prova. È la cosa più economica di tutto questo dossier.
> 🖊️ **E il TF c'entra**: R89 ha girato **solo H1**, mentre il meccanismo sweep è nato **M5/M15**
> — la sonda ha misurato M5, il file prova H1, e **le due cose non si sono mai incontrate**.

---

## 8. 📌 `EMA200` H4 FOREX A DUE LATI — trattato come chiede il mandato

Misurato da me sui CSV `risultati_archivio/EMA200/realtick_H4/`, filtrando
`InpAllowLong=1 AND InpAllowShort=1 AND Trades>0`. **Modello: TICK REALI.** Rischio **1,0%**.
🔴 **Finestra UNICA 2024.01.01→2026.06.30** (`backtest_pipeline/valida_realtick.ps1` r.176-186:
`ForwardMode=0`) e 🔴 **`Optimization=2` = GENETICA** (r.181).

| simbolo | celle a due lati **valutate** | ≥1,10 | PF min-max | PF **mediana** | n (deal) | DD% @1% | **DD% @2,0%** *(×1,956-1,990)* |
|---|---:|---:|---|---:|---|---|---|
| GBPUSD | **24** su 120 possibili | **24/24** | 1,1475-1,3478 | 1,2330 | 274-380 | 5,78-9,22 | 🔴 **11,3-18,3** |
| AUDJPY | **28** su 120 | 27/28 | 1,0758-1,8447 | 1,5164 | 255-347 | 2,89-9,46 | 🔴 5,7-18,8 |
| GBPJPY | **19** su 120 | 15/19 | 1,0185-1,3689 | 1,2404 | 204-287 | 3,79-7,03 | 7,4-14,0 |
| XAUUSD | **29** su 120 | 28/29 | 1,0921-1,8820 | 1,3807 | 130-250 | 5,08-8,32 | 10,0-16,6 |

> 🔴 **Tre cose, e cambiano la lettura:**
> **(1) «24/24» sono 24 celle su 120.** Il genetico **non ha calcolato** le altre 96 a due lati:
> non è un altopiano, è **la traccia del percorso di convergenza**.
> **(2) Non c'è OOS.** Finestra unica ⇒ **in campione per costruzione**.
> **(3) Il DD a 2,0% sfonda il muro FTMO del 10%** su GBPUSD, AUDJPY e XAUUSD. A **0,65%** sta a
> 3,76-5,99% e passa. 👉 **La cella non si giudica senza la taglia accanto.**
> 🖊️ **TF**: provati **M30 · H1 · H4** per nome (scan `H1_OHLC/`, `H4_OHLC/`, sweep M30). **Non**
> è un candidato «a TF unico». 🟢 E scendere non conviene: il DD OOS mediano della famiglia
> **sale monotono scendendo** — H4 **2,74%** → H1 **4,82%** → M30 **6,61%** → M15 **8,63%**.
> ⚠️ **Rilievo tecnico agli atti**: il preset in campo `ABTG_EMA200_FW_AUDJPY_H4.set` gira
> `InpOrder2Atr = 0,35`, **un valore che non esiste sull'asse** (0,2/0,3/0,4/0,5/0,6): è
> un'**interpolazione**, non una cella con un numero.

---

## 9. 🧬 LA FAMIGLIA SUPERTREND — **DUE CERTIFICATI DIVERSI, DA NON CONFONDERE**

| | **il certificato del 22/09** | **questo dossier** |
|---|---|---|
| che cosa misura | i **segnali Pine** (SuperTrend classico + `[LUX] SuperTrend Oscillator`), 5 definizioni | i **nostri EA** `ABTG_SupRev_*` / `SupertrendReversal*` / `SuperWave*` |
| dati | Oanda `XAU_USD` · HistData `GRXEUR`/`SPXUSD`/`JPXJPY` | **BCM**, il nostro broker |
| anni | **2013-2018** | **2024-2026** |
| modello | OHLC M1 aggregato, **nessuno stop, nessun target, sempre a mercato** | tick reali + OHLC, con stop/parziale/trailing |
| celle | **40** (4 simboli × 2 TF × 5 famiglie) + l'estensione M5/M15/M30 | 11 TF × 6 serie + gli sweep d'archivio |
| esito | **PF netto 0,78-1,09, zero celle sopra 1,10** · e il contro-esempio a **rumore** batte la cella migliore (1,296 contro 1,281) | **PF OOS mediano 0,66-1,41**, pettine sul TF |

> 🔴 **NON sono lo stesso oggetto e NON vanno citati come una misura sola.**
> 🟢 **Ma convergono, ed è questo che vale**: due strade indipendenti — broker diversi, anni
> diversi, strumenti diversi, con e senza gestione — atterrano sullo **stesso PF ≈ 1,00**.
> 📌 *(La richiesta parlava di «60 celle»: il referto del 22/09 ne dichiara **40** nel corpo
> principale, più l'estensione a TF bassi. Uso il numero del referto.)*

---

## 10. ✏️ ERRATA — tre numeri della richiesta appartengono a un altro motore

| nella richiesta | dove sta davvero il numero | il numero vero di `SupRev` |
|---|---|---|
| «FTSE (100GBP) H1 max **0,67**» | 🔴 è **`MaxMinNotte` 100GBP**: best **0,6717**, DD 16,03%, n=82 (`REGISTRO_TEST.md` r.2526) | `SupRev` 100GBP H1 = **0,88223**, DD 4,55%, n=160 |
| «CAC (F40EUR) max **~1,0**» | 🔴 è **`MaxMinNotte` F40EUR**: **0,9985**, DD 10,12%, n=112 (r.2528) | `SupRev` F40EUR H4 a **tick** = **1,79352**, DD 3,48%, n=65 (poi **revocato** il 30/07 su PFmed 0,96) |
| «Stoxx50 (E50EUR) max **0,59**» | 🔴 è la riga **`MaxMinNotte`** `REGISTRO_TEST.md` **r.461** — e quella riga è **essa stessa da correggere**: il ricalcolo sui CSV dà **0,8398**, non 0,59 | `SupRev` E50EUR H1 = **1,47429** (n=60) · H4 = **2,79968** (n=49) |

🟢 **Nessuno di questi cambia un verdetto** (le celle `SupRev` su FTSE/CAC/Stoxx restano morte o
non misurabili per campione), **ma tutti e tre cambiano il MOTIVO** — ed è la lezione già
scritta in casa: *un PF va sempre con l'aggettivo davanti e col motore accanto.*
⚠️ `MaxMinNotte` è **fuori dal mio perimetro**: segnalo, non giudico.

---

## 11. 🔴 NON COPERTO — quello che non ho potuto verificare, e perché

1. 🔴 **Su quale terminale fisico e con quale build MT5 girò `R123D` il 09/09**: è il residuo
   già dichiarato dall'audit del 12/09 e **non è nel repo**. Lo chiude il log della corsa con la
   riga *«terminale scelto»*. Finché manca, la causa dei 0,51 EUR resta **[NON MISURATA]** —
   posso dire che **non è il motore**, non posso dire che **cosa** sia.
2. 🔴 **Il fattore deal→posizione per la famiglia SupRev** è **[NON MISURATO]**. Il 2,0117 è di
   `EMA200` U30USD. Tutti i «posizioni/giorno» di §2.3 sono quindi **DERIVATI**, non misurati.
3. 🔴 **La profondità storica reale di BCM su 100GBP / E50EUR / F40EUR / 225JPY**: mai sondata.
   Senza quel numero non posso dire se il campione H4 su FTSE/Stoxx sia recuperabile **mai**
   (sul forex il pavimento gen-1999 è misurato, R102; sugli indici no).
4. 🔴 **`SupRev_CAC_H4_Ott` non ha lo sweep TF a TICK REALI**: nella cartella ci sono **solo** i
   due file `_ohlc`. È l'unico dei cinque `_Ottimizzato` col punto ⑤ pieno a metà.
5. 🔴 **Il punto ③ (uscita ad asse) è VUOTO su 14 voci su 20** della tabella madre. Su
   `InpTrailOnST`, `InpExitOnFlip`, `InpFirstFraction` la famiglia Supertrend ha **ZERO** assi
   in tutto l'archivio (`report/AUDIT_USCITE_2026-09-09.md`, Tabella B). Non l'ho colmato: ho
   argomentato in §6 perché **non può capovolgere questi numeri**, e quella resta
   un'argomentazione, non una misura.
6. 🔴 **La `SupertrendInvert`**: la trovo nel censimento su 6 simboli a **M15/M20/M30/H1** con
   righe malformate (`is_pf_med` = 108,6 e 1357,0, cioè PF impossibili su `n`=2). **Non l'ho
   giudicata**: i CSV sorgente non li ho isolati, e un PF su 2 operazioni non è un numero.
7. 🔴 **Non ho scritto nessun file prova.** Il mandato è sola lettura e, per la regola del
   19/08, nessuno dei quattro «resuscitabili» merita una griglia prima che Claudio decida se
   vale spendere 1,2-4,8 minuti di macchina su una famiglia che due misure indipendenti
   mettono a PF ≈ 1,00.

---

## 12. 🎁 COSA PORTO A CASA, in tre righe

1. 🟢 **`r132c` si scioglie senza spendere una passata**: non è il motore, e il criterio
   «identiche cifra per cifra» fra corse di giorni diversi va **sostituito con una tolleranza
   dichiarata**. Ma la cella che difendeva è un **picco su due assi su tre**, quindi lo sblocco
   **non riapre niente**.
2. 🟢 **Il `0/8` di FiboH4 era una bugia contabile — e il motore è morto lo stesso**, per un
   motivo migliore: **DD 17-23% a rischio 1% su 1.300 deal**.
3. 🔥 **Il regalo vero è lo sweep dei TF che era già in casa**: 11 timeframe, tick reali, due
   finestre, sei serie. Riempie il punto ⑤ del certificato **per nome** su tutta la famiglia, e
   dà il verdetto più netto del dossier — **il pettine H2 3,50 / H3 0,49 / H4 4,76**.
   👉 **Non abbiamo perso un'occasione: l'avevamo già misurata e non l'avevamo letta.**

**🔵 Niente toccato in campo. Zero passate spese. Zero righe consegnate.**
