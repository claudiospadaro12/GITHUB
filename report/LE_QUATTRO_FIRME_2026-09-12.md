# 🖊️ LE QUATTRO FIRME — le manopole di `770101` trasformate in numeri

**12/09/2026, sabato sera.** Referto di **sola lettura d'archivio + post-processing**.
🛑 **Nessun backtest eseguito.** **Nessun EA, preset, magic, sedia, parametro di
forward toccato.** `backtest_pipeline/coda/CODA.txt` **non l'ho aperta in
scrittura** (le 40 righe delle 03:30 sono del coordinatore).
Taglie, rischio e protezioni sono **firma di Claudio**, anche stasera.

> 🚦 **CANCELLO.** I due cancelli deterministici sono **VERDI** sui due file prova
> che ho scritto (esito riprodotto in §7). Il **secondo strato — l'agente
> `controllo-preventivo` — non posso invocarlo io: lo lancia il coordinatore.
> Lo dichiaro e non lo do per fatto.** Fino a quel PASS, niente verso il VPS.

🔴 **Criteri congelati PRIMA dei numeri**, in un file committato prima di
qualunque misura: `backtest_pipeline/prove/LE_QUATTRO_FIRME_CRITERI.md`
(commit **`be0e019`**). Le soglie di questo referto si leggono **come sono
scritte là**, non come conviene qui.

---

# 🥇 LA TABELLA CHE CLAUDIO CERCA

| # | manopola | oggi | **proposto** | **il numero che lo giustifica** | **cosa si perde** | esito |
|---|---|---:|---:|---|---|---|
| **M1** | `InpMaxSpread` | **0** = nessun limite | 🟡 **272** (2,72 idx) *condizionato a una corsa da 1,5 min* | all'ora 08, su **1.847.049 tick** del feed su cui la cella ha girato, il **MAX misurato e' 12,00 punti indice**: a quello spread il **95,9%** delle geometrie della sedia sta **sotto il pavimento duro 13,3x** e la mediana crolla a **6,5x** | 🔴 **[NON MISURATO]**: le due fonti di spread danno una banda **0,0%–50,0%** di operazioni perse. Inutilizzabile | 🔴 **[NON MISURATO]** — beneficio misurato, costo no |
| **M2** | `InpMaxPosSimbolo` (A1) | **0** = spento | 🟢 **resta 0** | col tetto a **1** il campo perde **15 giornate su 28 = 53,6%** (demo `50503392`, 20/07→11/09). Tetto 2 → 42,9% · 3 → 17,9% · 4 → 10,7% | col tetto a 1 la frequenza scende da **0,710 a 0,329 op/giorno**: costa **una sedia** | 🔴 **BOCCIATO a 1/2/3/4** |
| **M3a** | `InpSlippagePts` | **0.0** | 🟢 **resta 0** | usato **solo** a r.1059 e r.1083, che sono il ramo **BREAKOUT**. La cella viva e' `InpEntryMode=2` (**RETEST**): l'entry e' `gRangeHigh - InpRetestOffsetPts*_Point`, **senza termine di slippage** | niente: **non e' una manopola a zero, e' una manopola che su questa cella non esiste** | ⚪ **INERTE PER COSTRUZIONE** |
| **M3b** | `InpMinStopPts` (floor) | **0.0** | 🟢 **resta 0** | il sottoinsieme che il floor taglierebbe ha **PF > 1,00 a OGNI livello**: a F=30 idx sono 6 posizioni con **PF 4,888** e **R medio +0,730**; a F=44,87 (quello che coprirebbe il famoso 19,7%) sono 38 posizioni con **PF 1,549** | un floor a 44,87 idx butta **19,7% delle operazioni** e con loro **+4.819 EUR** di profitto lordo | 🔴 **BOCCIATO a ogni livello** |
| **M4** | `InpTP1_ClosePct` | **50** | 🟢 **0** (il regalo) | allo spread **vero** (base pesata sulle ore reali di uscita = **1,7054 idx**): profitto **+23.607 vs +18.030**, PF **1,49140 vs 1,39728**, DD equity **6,272% vs 7,233%**. E l'esposizione si allunga di **ZERO minuti** (`close_time` identico in **191/193** posizioni) | la taglia raddoppia per **8,6 min mediani** su **39,9%** delle posizioni; costo misurato: **51/77 giornate peggiori** e un caso a **−1,482 R** (25/02/2026). Muro giornaliero: **invariato** | 🟠 **RACCOMANDATO CON RISERVA** (il criterio, letto alla lettera, **cade** su 1 indicatore su 4 — §5.2) |

## ✍️ LE RIGHE PRONTE DA FIRMARE, una frase ciascuna

- **M1** — *«Metto `InpMaxSpread` a 272 punti MT5 su `770101`, **dopo** che la corsa da 1,5 minuti di `LE_QUATTRO_FIRME_01` mi ha detto quante operazioni costa; se ne costa piu' del 10%, resta 0.»*
- **M2** — *«`InpMaxPosSimbolo` resta 0: sul campo il tetto a 1 mi toglie il 53,6% delle giornate per difendermi da un difetto che non si vede piu' da 37 giorni.»*
- **M3a** — *«`InpSlippagePts` resta 0: sulla cella RETEST quel numero non entra in nessuna formula.»*
- **M3b** — *«`InpMinStopPts` resta 0: le posizioni a stop stretto sono le mie migliori, non le mie peggiori.»*
- **M4** — *«Porto `InpTP1_ClosePct` da 50 a 0 su `770101`, e faccio girare `LE_QUATTRO_FIRME_02` (1,2 minuti) per sapere se `InpBEatR=1,0` mi tappa il buco del breakeven che a 0 non scatta.»*

---

# 0. 🧊 I CRITERI, E IL RANGO DI OGNI NUMERO

Il file criteri (`be0e019`) definisce **quattro ranghi**, e ogni numero qui sotto
ne porta uno. E' la difesa contro l'errore della giornata:

| rango | che cos'e' | cosa puo' fare |
|---|---|---|
| **M** MISURATO | letto da CSV di risultati, per-trade, istogramma di tick/campioni | promuove **e** boccia |
| **D** DERIVATO | ricostruito da una formula del sorgente su grandezze misurate | boccia, **non** promuove da solo |
| **C** VERO PER COSTRUZIONE | non poteva che uscire cosi', dato com'e' fatto il dato | 🔴 **non vale niente** |
| **N** NON MISURATO | i dati in casa non lo contengono | `[NON MISURATO]` + la via piu' corta al numero |

## 0.1 ✅ Nove numeri scritti da altri, riprodotti da me sui file grezzi

Prima di misurare cose nuove ho riprodotto quello che c'era gia'. Il separatore
dei per-trade e' **PUNTO E VIRGOLA** e l'intestazione l'ho guardata prima di
contare (`close_time;symbol;magic;position_id;deal_type;volume;price;net_profit`).

| numero | chi l'ha scritto | il mio |
|---|---|---|
| `770101` profitto OOS **+18.029,58** | `..._OOS_r47a.csv` | **+18.029,58** ✅ |
| posizioni **193 / 193** (viva / regalo) | indurimento §2 | **193 / 193** ✅ |
| volume chiuso **3.245,30** e **3.338,60** lotti | indurimento §5.1 | **3.245,30** e **3.338,60** ✅ |
| deposito del banco | *(nessuno)* | **100.000** — trovato invertendo il DD |
| DD sui chiusi **6,2516%** e **5,3969%** | indurimento §4.1-4.2 | **6,2516%** e **5,3969%** ✅ |
| stop DERIVATO: p10 **37,9** · mediana **77,8** · p90 **130,5** idx | indurimento §4.4 | **37,86 · 77,81 · 130,16** ✅ |
| posizioni oltre **1 R**: **15/193** | indurimento §3.1 | **15/193** (R ≤ −1,00) ✅ |
| quota sotto il duro 13,3x: **0,5% / 7,3% / 19,7%** | indurimento §4.4 | **0,5% / 7,3% / 19,7%** ✅ |
| gradino +100% base 1,70: PF **1,26606** / **1,36016**, DDeq **8,111%** / **7,034%** | indurimento §4.1-4.2 | **identici a cinque cifre** ✅ |

🟢 **La pipeline e' calibrata su nove numeri scritti da qualcun altro.** Da qui
in avanti i numeri nuovi girano sulla stessa macchina.

---

# 1. 🔴 M1 — `InpMaxSpread = 0`: il BENEFICIO e' misurato, il COSTO no

## 1.1 Che cosa fa **davvero** la manopola, e non e' quello che sembra

Letto riga per riga in `mql5/Experts/ABTG_DAX_Apertura_EU.mq5`:

```
r.359     input int InpMaxSpread = 0;                 // 0 = nessun limite
r.2133-39 bool SpreadOK() { if(InpMaxSpread<=0) return(true);
                            long spread = SymbolInfoInteger(_Symbol, SYMBOL_SPREAD);
                            return(spread <= InpMaxSpread); }
r.1441    if(!SpreadOK()) { ...; return(true); }      <-- DENTRO ArmRetest()
```

🔴 **In modalita' RETEST — che e' la cella viva (`InpEntryMode=2`) — la chiamata
e' UNA SOLA, dentro `ArmRetest()`, cioe' a FINE RANGE: 08:00 + 35 minuti =
08:35 ORA SERVER, una volta al giorno.** Quindi il tetto gatta **la decisione di
armare la giornata**, e **non**:
- il **riempimento** del `BUY LIMIT` (che avviene minuti dopo, r.1504);
- l'**uscita** (stop e trailing sono ordini a mercato).

👉 **`InpMaxSpread` e' una protezione PARZIALE PER COSTRUZIONE**, e va detto ogni
volta che si cita. 🟢 Con un rovescio buono che vale la pena dire: un `BUY LIMIT`
si riempie **al prezzo o meglio**; con l'ask piu' alto **si riempie meno spesso**,
non peggio. L'ingresso a LIMIT e' gia' una difesa strutturale dal costo.

## 1.2 🔴 IL CONTRO-ESEMPIO, costruito da me — e **la tesi comoda cade**

L'ipotesi che la missione mi ha messo in mano (e che sta nel pannello del 12/09) e':
> *«su `D30EUR` nelle ore cash lo spread non ha coda (max = P95 = 1,700), quindi
> un tetto e' quasi inerte»*.

Invece di verificare che tornasse, ho cercato l'**ipotesi alternativa**: *«quel
"niente coda" e' un artefatto del campionamento»*. Ecco le due fonti, **all'ora
08, che e' l'ora in cui questa sedia decide**:

| fonte | come misura | n | mediana | P95 | **MAX** |
|---|---|---:|---:|---:|---:|
| **VIVO** `ABTG_SpreadLogger` (04-11/09, GG=5) | un campione ogni **5 secondi** | **3.596** | 1,600 | 1,700 | 🟢 **1,700** |
| **TICK STORICO** `spread_orario_D30EUR.csv` (2024.09.26→2026.06.30) | **ogni tick** del feed su cui R47 ha girato | **1.847.049** | 1,700 | **2,700** | 🔴 **12,000** |

Istogramma vivo dell'ora 08, per non lasciarlo alla fiducia:
`BIN,D30EUR,8,150,919` · `BIN,D30EUR,8,160,1752` · `BIN,D30EUR,8,170,925`.
**Massimo 170 punti MT5. Sopra 1,70 idx: ZERO campioni su 3.596.**

> ## 🔴 **L'IPOTESI «NON C'E' CODA» E' FALSIFICATA, E DAL FEED CHE CONTA.**
> Il tick storico all'ora 08 ha **P95 2,700** e un **massimo di 12,000 punti
> indice** — **7,1 volte** la mediana. Quella coda **c'e'**, e sta esattamente
> sul feed su cui le 193 posizioni hanno girato.

🔬 **E la ragione del disaccordo non e' che una fonte sbaglia: misurano due cose
diverse, e lo dico col nome giusto.** Il logger vivo campiona a intervallo
costante, quindi pesa il **TEMPO**. Il tick storico pesa i **TICK** — e i tick
si infittiscono proprio quando lo spread si allarga. Conseguenza operativa, che
vale per tutti i referti di casa:
- per **quanto costa un riempimento** (il pedaggio), il peso giusto e' il
  **tick**: la base del collaudo prop e' corretta;
- per **quanto spesso un cancello istantaneo scatta** (che e' M1), il peso
  giusto e' il **tempo**: e li' abbiamo **5 giornate**.

## 1.3 Il costo del tetto: una **banda inutilizzabile**, e lo scrivo

Dal tick storico conosco solo mediana/P95/max, non l'istogramma. Quindi ottengo
**limiti**, non numeri:

| tetto | punti MT5 | **VIVO** (0/3.596 sopra 1,70) | **TICK STORICO** (limite dedotto) |
|---|---:|---:|---|
| **1,70 idx** | 170 | 0,0% | fra ~5% e **50,0%** (la mediana e' 1,700) |
| **2,04 idx** | 204 | 0,0% | fra ~5% e 50,0% |
| **2,72 idx** | 272 | 0,0% | **≤ 5,0%** (P95 = 2,700) |
| **3,40 idx** | 340 | 0,0% | **≤ 5,0%** |

🔴 **Il criterio congelato e' esplicito**: *«se le due fonti differiscono di un
fattore ≥ 3, la conclusione "inerte" e' NULLA»*. Qui il fattore e' **infinito**
(0,0% contro ≥5%). 👉 **M1 = `[NON MISURATO]` sul costo.**

## 1.4 🟢 Ma il BENEFICIO e' misurato, e non e' piccolo

Rapporto **stop / spread** nel momento in cui la sedia decide, con gli stop
DERIVATI dai per-trade (min 21,92 · p10 37,86 · mediana 77,81 idx):

| spread alla decisione | su stop **MIN** | su stop **p10** | su stop **MEDIANO** | **quota delle 193 sotto il duro 13,3x** |
|---|---:|---:|---:|---:|
| mediana vivo **1,60** | 13,7x | 23,7x | 48,6x | **0,0%** |
| mediana tick **1,70** | 12,9x | 22,3x | 45,8x | 0,5% |
| **tetto proposto 2,72** | 8,1x | 13,9x | 28,6x | 8,3% |
| tetto 3,40 | 6,4x | 11,1x | 22,9x | 19,7% |
| 🔴 **MAX MISURATO ora 08 = 12,00** | **1,8x** | **3,2x** | **6,5x** | 🔴 **95,9%** |

> ## 🔴 **QUESTA E' LA RIGA CHE GIUSTIFICA IL TETTO**
> **Esiste un istante MISURATO, all'ora in cui questa sedia arma, in cui lo
> spread di `D30EUR` vale 12,00 punti indice. A quello spread il 95,9% delle
> geometrie della sedia sta sotto il pavimento duro 13,3x, e la MEDIANA sta a
> 6,5x — meta' del duro.** Con `InpMaxSpread = 0` la sedia **entra li'**.
> 🟢 Un tetto a **272** riporta il caso peggiore accettabile da **95,9%** a
> **8,3%**; un tetto a **204** lo porta a **2,1%**.

⚠️ **E il presupposto, dichiarato**: 5 sedute di misura viva **non contengono un
crollo**, e 21 mesi di tick contengono **un solo regime (toro)**. La difesa serve
per il giorno **fuori campione**, e quel giorno **non e' nei dati**. Questo non e'
un argomento per firmare: e' un argomento per **dichiarare l'incertezza**.

## 1.5 🎯 La via piu' corta al numero — **1,524 minuti**

`backtest_pipeline/prove/LE_QUATTRO_FIRME_01_maxspread_ini.txt` (scritto, gatato,
**non lanciato**): **6 celle** `InpMaxSpread` = 0 / 68 / 136 / 204 / 272 / 340
punti MT5, 12 passate, **1 round**, `T = 0,6 + 0,077 × 12 =` **1,524 min**.

🚦 **Due canarini DENTRO l'asse, a costo zero di round** — perche' non e'
misurato che `SymbolInfoInteger(SYMBOL_SPREAD)` torni lo spread vero nel tester:
- **cella 68** (0,68 idx, **sotto il minimo mai misurato** di 1,50 idx) → **DEVE
  dare ZERO posizioni**. Se ne da' 193, la prova e' **MORTA** e si scrive
  `NON MISURABILE`, mai *«tetto inerte»*;
- **cella 136** (1,36 idx, sotto la mediana) → **DEVE** dare `0 < n << 193`;
- e insieme provano la **monotonia** `0 ≤ n(68) ≤ n(136) ≤ n(204) ≤ n(272) ≤ n(340) ≤ n(base)`.
  Una violazione e' un difetto del banco, non un risultato.

---

# 2. 🔴 M2 — A1 `InpMaxPosSimbolo`: **non e' una cintura gratis, e' un cappotto che uccide la sedia**

## 2.1 Che cosa fa, da sorgente

```
r.258     input int InpMaxPosSimbolo = 0;   // tetto posizioni+pendenti sul simbolo, TUTTI gli EA
r.694-701 case PH_BUILDING:
            if(InpMaxPosSimbolo > 0 && EsposizioneSimbolo() >= InpMaxPosSimbolo)
              { ABTGLog(...); gPhase = PH_DONE; break; }
r.923-937 int EsposizioneSimbolo()  // posizioni + pendenti sul simbolo, IGNORANDO il magic
```

Due fatti che cambiano la risposta:
1. 🟢 **Il tetto a 1 NON puo' auto-bloccare la sedia.** Il cancello gira in
   `PH_BUILDING`, cioe' **prima** che la sedia piazzi il suo `BUY LIMIT`: il
   proprio pendente **non esiste ancora**. Il rischio che la missione chiedeva di
   misurare (*«un tetto a 1 potrebbe bloccare la sedia!»*) **non si realizza per
   il pendente PROPRIO**.
2. 🔴 **Ma quando scatta non salta l'ordine: salta LA GIORNATA** (`gPhase = PH_DONE`).

## 2.2 🔴 IL CONTRO-ESEMPIO #1: «zero volte su 193» e' **VERO PER COSTRUZIONE**

La missione chiedeva: *«quante volte in 193 posizioni il tetto sarebbe scattato?
Se la risposta e' zero, e' una cintura gratis»*. La risposta **e'** zero — e
**non vale niente** (rango **C**): nel tester gira **UN SOLO EA**, quindi
`EsposizioneSimbolo()` dal punto di vista degli *altri* vale **sempre 0** per
costruzione. **Non l'ho citato come prova.** La misura buona sta nel **campo**.

## 2.3 🔴 LA MISURA VERA — sul campo, e boccia il tetto

Fonte: `data/statements/trades_auto.csv`, demo **`50503392`**, simbolo `D30EUR`.
**163 posizioni, QUATTORDICI magic diversi** (`0` manuale, `770101`, `770102`,
`770103`, `770111`, `770121`, `770311`, `770401`, `770411`, `770501`, `770502`,
`771501`, `970911`, `990001`). `770101` ha **35 posizioni in 28 giornate
operative**, dal 20/07 all'11/09/2026.

Regola applicata: A1 uccide la giornata se **qualunque** altra posizione e' viva
in **almeno un istante** della finestra `08:00 → 08:35 SERVER` (la finestra di
`PH_BUILDING`).

| tetto | **giornate uccise** | **%** | frequenza residua | P/L delle giornate perse | esito contro il criterio congelato |
|---:|---:|---:|---:|---:|---|
| **1** | **15 / 28** | 🔴 **53,6%** | 0,329 op/g | −467,18 | 🔴 **BOCCIATO** (>10%) |
| **2** | 12 / 28 | 🔴 42,9% | — | −494,69 | 🔴 **BOCCIATO** |
| **3** | 5 / 28 | 🔴 17,9% | — | −350,57 | 🔴 **BOCCIATO** |
| **4** | 3 / 28 | 🔴 10,7% | — | −237,98 | 🔴 **BOCCIATO** (di 0,7 punti) |
| **5** | 1 / 28 | 🟠 3,6% | — | +30,28 | 🟠 **FRAGILE** |

⚠️ **E sono un PAVIMENTO, non una stima:** lo statement contiene solo le
**POSIZIONI**. `EsposizioneSimbolo()` conta anche i **PENDENTI**, che non sono nel
file. 👉 **il costo vero e' ≥ di questi numeri.**

🔬 **Perche' cosi' tanto: il motivo e' nei dati, non nell'opinione.** Su `D30EUR`,
ogni mattina, **quattro EA sparano fra le 08:00:00 e le 08:00:45 SERVER**
(`770103`, `770121`, `770401`, `770411`) — cioe' **dentro il primo secondo della
finestra di `PH_BUILDING` di `770101`**. Esempi letti dal file:
- 28/07 `770103` 08:00:04 e `770121` 08:00:04 · 29/07 entrambi **08:00:00**
- 04/08 `770121` 08:00:01 e `770103` 08:00:01 · 07/08 entrambi 08:00:01
- e `770411` (MaxMinNotte) apre alle 08:01:08 / 08:02:11 / 08:03:15 / 08:14:43 / 08:27:25:
  🔴 **cinque giornate su cinque, tutte dentro la finestra.**

## 2.4 🔴 IL CONTRO-ESEMPIO #2: la frase del verbale del 02/09 e' **vera per la ragione sbagliata**

Il verbale dice: *«e' la protezione che avrebbe impedito le due SELL gemelle dello
stesso secondo del 29/07»*. **Non l'ho ripetuta: l'ho provata.**

Il fatto del 29/07, letto dallo statement — e sono **TRE** posizioni, non due:
```
2026.07.29 08:53:56   770311  1,60 sell  -120,80
2026.07.29 08:53:56   770101  1,60 sell  -120,80
2026.07.29 08:53:56   770101  1,60 sell  -115,04     <- tre volte 1,60 lotti nello stesso secondo
```
- 🟢 **A1 a 1 AVREBBE ucciso quella giornata** — ma **non** perche' ha visto la
  gemella: perche' `770121` e `770103` erano aperti dalle **08:00:00**. E' un
  effetto collaterale del cancello che chiude la giornata, non la protezione
  descritta.
- 🔴 **Contro la gemella vera, A1 non protegge**, e lo dice **il commento
  dell'EA** (r.918-921): *«E' una MITIGAZIONE, non una garanzia: due EA possono
  piazzare nello stesso tick e non vedersi a vicenda»*.

## 2.5 🟢 E il difetto che A1 doveva tappare **e' gia' chiuso** — 37 giorni di prova

`770311` e' una **gemella sistematica** di `770101`: **6 secondi** in cui i due
aprono insieme con **lotto identico**, fra il 28/07 e il 06/08 (28/07 08:17:25 ·
29/07 08:53:56 · 03/08 08:15:29 · 04/08 08:15:24 · 05/08 08:34:46 · 06/08 08:18:08).

| finestra | giornate di `770101` | posizioni | **max nello stesso giorno** |
|---|---:|---:|---:|
| fino al **06/08** | 12 | 19 | 🔴 **5** (il 30/07) |
| dal **07/08** all'11/09 | **16** | **16** | 🟢 **1** |

🟢 **Dal 07/08 in poi: 16 giornate, 16 posizioni, una al giorno. Zero gemelle.**
Coerente al giorno col verbale del 02/09 (*«configurazione di PRIMA del 17/08»*).
E la protezione che lavora e' quella **per magic**, che esiste gia' e non costa
frequenza: r.595-602 (guardia anti-duplicato reload-safe) + `SelectMyPosition()`
r.2115-2126, che filtra **simbolo E magic**.

> ## 🔴 **VERDETTO M2: A1 RESTA A ZERO.**
> Il tetto costerebbe il **53,6% delle giornate** (misurato, ed e' un pavimento)
> per difendere da un difetto che **non si manifesta da 37 giorni** e che e' gia'
> coperto da una guardia per-magic **che nei dati funziona 16 volte su 16**.
> 🟢 **Una protezione non si giudica da quello che promette: si giudica da quello
> che costa meno lo stesso beneficio.**

## 2.6 🧾 E cio' che resta `[NON MISURATO]`, per nome
Tutto questo e' misurato sul **demo `50503392`**, dove `D30EUR` e' affollato da
14 magic. Sul **100k `50504263`** — il conto della challenge — il profilo
`SQUADRA 100K` ha **otto** grafici, di cui **due** su `D30EUR` (`M5` e `M15`), e
**che cosa gira su `D30EUR,M15` non e' noto** (lo dichiarava gia' il pannello).
🔴 **Se su `D30EUR,M15` girasse `ABTG_MaxMinNotte` (770411), il tetto a 1
ucciderebbe ogni giornata in cui quello opera: nel demo sono state 5 su 5.**
👉 **Si chiude con una foto**, non con una corsa.

---

# 3. ⚪ M3a — `InpSlippagePts = 0`: non e' spenta, **non esiste su questa cella**

Occorrenze **complete** di `InpSlippagePts` nel sorgente: **r.344** (dichiarazione),
**r.1059**, **r.1083**. E le due righe che la usano stanno **entrambe** nel ramo
BREAKOUT (`PlaceBreakoutOrders`):

```
r.1059  double entry = NormalizePrice(buyPx  + InpSlippagePts*_Point);   // BREAKOUT
r.1083  double entry = NormalizePrice(sellPx - InpSlippagePts*_Point);   // BREAKOUT
```

La cella viva e' `InpEntryMode = 2` (**RETEST**), e l'entry del retest e'
**r.1488**:
```
double entry = NormalizePrice(gRangeHigh - InpRetestOffsetPts*_Point);  // niente buffer/slippage
```

> ## ⚪ **`InpSlippagePts` e' INERTE PER COSTRUZIONE su `770101`, a QUALUNQUE valore.**
> Non e' una manopola dimenticata a zero: e' una manopola che sul ramo vivo **non
> entra in nessuna formula**. Metterci un numero non cambierebbe un centesimo, e
> darebbe la falsa impressione di una protezione attiva. 🟢 **RESTA A ZERO, e va
> scritto nel contratto della sedia perche' nessuno la riapra fra un mese.**
> *(Ed e' coerente col collaudo prop, che per questo ha spostato la scala di
> latenza sull'USCITA: un LIMIT non si riempie peggio per latenza.)*

---

# 4. 🔴 M3b — `InpMinStopPts = 0`: il floor **butterebbe via i trade migliori**

## 4.1 Come ho ricavato gli stop, e come ho provato a rompere la derivazione

Rango **D** (DERIVATO). `CalcLotByRisk` (r.1791-1826) usa il **BALANCE**, non
l'equity, e arrotonda **per difetto** (`MathFloor`, r.1824). Invertendo:
`stop ∈ ( risk/(PV·(lotti+0,01)) , risk/(PV·lotti) ]`, con `PV = 1,0 EUR/idx/lotto`.

Tre prove che la derivazione non e' una comodita':
1. 🟢 il deposito esce **esattamente 100.000** imponendo il DD sui chiusi
   pubblicato (6,2516% e 5,3969%) — due vincoli indipendenti, un solo valore;
2. 🟢 la distribuzione di **R** si addensa su **−1,00** (p5 = **−1,004**,
   p10 = **−0,998**): se `PV` fosse sbagliato quel muro non ci sarebbe;
3. 🟢 la mediana esce **77,81 idx**, contro i **71,9 idx MISURATI** su 7 gambe
   vere (`CANCELLO_COSTO_FLOTTA_2026-09-10.md`) — **+8,2%**, ed e' il verso
   giusto: `MathFloor` sottodimensiona il lotto, quindi lo stop implicito esce **alto**.

Distribuzione: min **21,92** · p10 **37,86** · p25 **52,69** · **mediana 77,81** ·
p75 **106,34** · p90 **130,16** · max **226,45** punti indice.

## 4.2 🔴 Il test S/P — e il floor lo fallisce a **ogni** livello

PF globale delle 193 posizioni: **1,39728**.

| floor F | punti MT5 | tagliate | % | **PF del TAGLIATO** | PF del tenuto | profitto tagliato | **R medio del tagliato** | S/P |
|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 21,3 | 2130 | 0 | 0,0% | — | 1,39728 | 0 | — | inerte |
| 25,0 | 2500 | 1 | 0,5% | **∞** (nessuna perdita) | 1,39087 | +290,87 | +0,269 | 🔴 taglia-buoni |
| **30,0** | 3000 | 6 | 3,1% | 🔴 **4,88820** | 1,30435 | **+4.575,24** | 🔴 **+0,730** | 🔴 taglia-buoni |
| 35,9 | 3590 | 15 | 7,8% | **2,58324** | 1,26444 | +7.237,36 | +0,454 | 🔴 taglia-buoni |
| 37,9 | 3790 | 20 | 10,4% | **1,33891** | 1,41158 | +3.028,02 | +0,151 | selezione |
| 40,0 | 4000 | 26 | 13,5% | **1,44923** | 1,38255 | +4.501,73 | +0,165 | selezione |
| 42,60 | 4260 | 31 | 16,1% | **1,54883** | 1,34760 | +6.148,73 | +0,185 | 🔴 taglia-buoni |
| **44,87** | 4487 | **38** | **19,7%** | 🔴 **1,35828** | 1,41370 | **+4.818,79** | +0,120 | selezione |
| 50,0 | 5000 | 44 | 22,8% | 1,58827 | 1,30716 | +8.558,26 | +0,179 | 🔴 taglia-buoni |
| 64,0 | 6400 | 69 | 35,8% | 1,33494 | 1,45717 | +7.448,67 | +0,098 | selezione |

Il criterio congelato dice: **BOCCIATO se il tagliato ha PF ≥ 1,00**.
👉 **Il tagliato ha PF > 1,00 a TUTTI i livelli. M3b e' BOCCIATO a ogni valore.**

## 4.3 🔴 E IL CONTRO-ESEMPIO PIU' IMPORTANTE: il famoso **19,7%** non va difeso

La missione dice: *«a spread +100% il 19,7% delle 193 posizioni sta sotto il
pavimento duro 13,3x. Un floor tarato e' esattamente la difesa per quel 19,7%»*.
Ho provato a romperla, e **cade**. Conditionando allo **stress**, cioe' guardando
il sottoinsieme a stop stretto **gradino per gradino** (base pesata 1,7054 idx):

| gradino | TUTTE 193 | **sottoinsieme stop < 40 idx (n=26)** | sottoinsieme stop ≥ 40 (n=167) |
|---|---:|---:|---:|
| **base** | PF 1,3973 | 🟢 **PF 1,4492** | PF 1,3826 |
| **+25%** | 1,3637 | 🟢 **1,4066** | 1,3515 |
| **+50%** | 1,3306 | 🟢 **1,3651** | 1,3207 |
| **+100%** | 1,2657 | 🟢 **1,2849** | 1,2601 |

E il punto di rottura di quel sottoinsieme: va sotto **PF 1,00** solo a un costo
extra di **5,11 punti indice per posizione**, cioe' **3,0 volte** lo spread base.

> ## 🔴 **LE POSIZIONI A STOP STRETTO SONO LE MIGLIORI DELLA SEDIA, NON LE PEGGIORI — a ogni gradino di stress.**
> Il sottoinsieme "sotto il duro a +100%" (38 posizioni, 19,7%) ha **PF 1,3583**
> e **R medio +0,120**. 🟢 **Non e' il 19,7% da difendere: e' il 19,7% che porta il
> motore.** E un floor a 44,87 idx lo butterebbe via **insieme a +4.819 EUR** di profitto lordo.

🔬 **E il meccanismo c'e', non e' un caso.** Il preset porta
`InpUseTrailing=true`, `InpTrailStartR=0`, `InpTrailMode=1` (**PREVBAR** sul
minimo della candela **M5** precedente, r.2003-2004, `InpTrailTF=5`): il trailing
**arma subito**. Risultato misurato: **solo il 19,2% delle 193 posizioni esce
allo stop iniziale** (37 su 193 con R ≤ −0,95).
👉 **Lo stop iniziale di questo motore serve a dimensionare il lotto, non a
essere raggiunto.** E infatti uno stop stretto vuol dire **range d'apertura
strettо**, cioe' **lotto grande** su una rottura pulita.

⚠️ **Sfumatura che va detta perche' non e' tutta rosa:** il sottoinsieme a stop
stretto **colpisce lo stop pieno piu' spesso** (30,8% contro 17,4%). Perde piu'
volte, ma vince piu' grosso: **R medio +0,165 contro +0,076**.

## 4.4 🧾 Due limiti dichiarati
1. **Post-processing di PRIMO ORDINE**: saltare una posizione cambia il
   **BALANCE**, quindi il **lotto** di tutte le successive. La **quota tagliata**
   e il **PF del tagliato** sono robusti; il *«profitto che si perde»* e' una
   **stima**, mai un risultato.
2. **L'altro regime del floor non e' misurabile**: con `InpSkipIfTight=false`
   (oggi e' `true`) lo stop si **allarga** a `InpMinStopPts` e il lotto **scende**
   (r.1497). Se quello stop piu' largo avrebbe **salvato** il trade,
   i per-trade non possono dirlo: `[NON MISURATO]`, e non lo stimo.

---

# 5. 🎁 M4 — `InpTP1_ClosePct` 50 → 0, rifatto con lo spread VERO

## 5.1 La base di spread, **pesata sulle ore vere** invece che assunta

Ho misurato l'**ora SERVER di uscita** di tutte e 193 le posizioni (dal
`close_time` dell'ultimo deal):

| ora server | 08 | 09 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| posizioni | 12 | **101** | 31 | 9 | 10 | 5 | 5 | 11 | 4 | 5 |

Ingresso: l'ora 08 (il range chiude alle 08:35). Round trip = `(entry+exit)/2`:

| fonte | mediana pesata all'uscita | **base round trip** |
|---|---:|---:|
| **TICK STORICO** (21 mesi, il feed di R47) | 1,7109 | **1,7054 idx** |
| **VIVO** (5 s, 5 giornate) | 1,6000 | **1,6000 idx** |

🟢 **La base 1,70 usata dal collaudo prop e' CONFERMATA al terzo decimale** dal
calcolo pesato sulle ore reali (1,7054). Con lo spread **vivo** 1,6000 lo stress
e' **5,9% piu' blando**. Ecco le due scale complete:

### Base **1,6000** (spread VIVO misurato all'ora 08)

| gradino | Δ idx | **VIVA (50)** | **REGALO (0)** |
|---|---:|---|---|
| **base** | 0,0000 | +18.030 · PF **1,39728** · DDeq **7,233%** · gg −1,0780 | +23.607 · PF **1,49140** · DDeq **6,272%** · gg −1,0793 |
| **+25%** | 0,4000 | +16.731 · PF 1,36576 · DDeq 7,434% · gg −1,0904 | +22.272 · PF 1,45992 · DDeq 6,446% · gg −1,0916 |
| **+50%** | 0,8000 | +15.433 · PF **1,33467** · DDeq **7,638%** · gg −1,1028 | +20.936 · PF **1,42884** · DDeq **6,624%** · gg −1,1041 |
| **+100%** | 1,6000 | +12.837 · PF **1,27357** · DDeq **8,058%** · gg −1,1439 | +18.266 · PF **1,36768** · DDeq **6,988%** · gg −1,1424 |

### Base **1,7054** (tick storico pesato sulle ore vere)

| gradino | Δ idx | **VIVA (50)** | **REGALO (0)** |
|---|---:|---|---|
| **base** | 0,0000 | +18.030 · PF 1,39728 · DDeq 7,233% | +23.607 · PF 1,49140 · DDeq 6,272% |
| **+25%** | 0,4264 | +16.646 · PF 1,36370 · DDeq 7,447% | +22.184 · PF 1,45786 · DDeq 6,458% |
| **+50%** | 0,8527 | +15.262 · PF 1,33059 · DDeq 7,665% | +20.760 · PF 1,42476 · DDeq 6,647% |
| **+100%** | 1,7054 | +12.495 · PF 1,26566 · DDeq 8,114% | +17.914 · PF 1,35975 · DDeq 7,037% |

> ## 🟢 **IL VANTAGGIO DEL REGALO REGGE ALLO SPREAD VERO, A TUTTI E QUATTRO I GRADINI, CON TUTTE E DUE LE BASI.**
> E l'argomento che **non e' un'identita' algebrica** resta in piedi al centesimo:
> il regalo muove **3.338,60 lotti** contro 3.245,30, cioe' **+2,87%**, quindi
> paga **+2,87% di pedaggio IN PIU'** — e vince lo stesso. **Se il vantaggio
> venisse da un costo piu' basso, il segno sarebbe rovesciato.**

## 5.2 🔴 MA IL CRITERIO CONGELATO, LETTO ALLA LETTERA, **CADE** — e lo scrivo

Il criterio (`be0e019`, M4) chiede che il regalo batta la viva su **quattro**
indicatori. Tre su quattro ✅ — e il quarto no:

| indicatore | viva (50) | regalo (0) | chi vince |
|---|---:|---:|---|
| profitto | +18.029,58 | **+23.607,28** | 🟢 regalo |
| PF | 1,39728 | **1,49140** | 🟢 regalo |
| DD di equity | 7,2328% | **6,2719%** | 🟢 regalo |
| **peggior giornata di equity** | 🟢 **−1,0780%** | −1,0793% | 🔴 **la VIVA**, a base/+25%/+50% |

🔴 **Il criterio dice CADE, e lo scrivo cosi' — le soglie si leggono come sono
scritte, non come conviene.**

### 🔬 E ORA LA CAUSA, misurata: **non e' rischio, e' l'arrotondamento del lotto**

Il giorno peggiore e' lo **stesso** per le due celle — **10/10/2025** — e
**TP1 non e' stato toccato in nessuna delle due** (`nd = 1`, un solo deal):

| | saldo d'apertura | **lotto teorico** | lotto dopo `MathFloor` | P/L | **% del saldo** |
|---|---:|---:|---:|---:|---:|
| **VIVA** | 107.810,77 | **26,0050** | 26,00 | −1.162,20 | **−1,07800%** |
| **REGALO** | 108.925,62 | **26,3050** | 26,30 | −1.175,61 | **−1,07928%** |

Il regalo ha guadagnato di piu', quindi ha un saldo **+1,0341%** piu' alto e un
lotto **+1,1538%** piu' grande. `MathFloor` (r.1824) toglie **0,0050 lotti** a
entrambe: in relativo e' **0,0192%** alla viva e **0,0190%** al regalo. La viva
resta **un pelo piu' sottodimensionata**, e quel pelo vale
**Δ = 0,00128 punti percentuali**.

> ## 🔬 **0,00128 punti su un muro giornaliero di 4,900 = lo 0,026% del margine.**
> 🔴 **Il criterio congelato cade: lo dichiaro e non lo riscrivo** (i criteri si
> cambiano prima dei numeri). 👉 **Proposta per il PROSSIMO giro, non per questo:
> il criterio sulla peggior giornata va scritto con una banda d'indifferenza di
> ±0,05 punti**, perche' com'e' scritto oggi **e' sensibile all'arrotondamento
> del lotto, cioe' a una cosa che non e' rischio.**

## 5.3 🔴 ERRATA a un referto di oggi — e non e' mia

`report/INDURIMENTO_PROP_DUE_SEDIE_2026-09-12.md` §11 scrive:
> *«S6 il regalo — ✅ batte la viva a TUTTI E QUATTRO i gradini su PF, **DD e
> peggior giornata**»*

🔴 **Sulla peggior giornata e' FALSO a tre gradini su quattro.** I numeri stanno
nei CSV del suo stesso banco (`..._OOS_r47a.csv`: `Peggior Giornata % = -1.0780`;
`..._r47b.csv`: `-1.0793`), e il regalo vince quella colonna **solo a +100%**
(−1,1424 contro −1,1439). 🟢 **Il resto di quella riga (PF, DD, profitto) regge
intatto**, e il verdetto finale del referto non cambia. Ma la colonna sbagliata
va corretta, perche' e' esattamente la colonna che guarda il muro della prop.

## 5.4 🎯 L'ESPOSIZIONE — la domanda che la missione chiama «quella che conta»

> *«a 0 la posizione resta intera piu' a lungo — di quanto si allunga
> l'esposizione, e cosa fa al muro giornaliero della prop?»*

**In TEMPO: di ZERO. E questo non me l'aspettavo.**
Confrontando il `close_time` dell'**ultimo deal**, posizione per posizione:

| | valore |
|---|---:|
| posizioni con **uscita finale IDENTICA al secondo** | 🟢 **191 / 193 (98,96%)** |
| posizioni in cui il regalo esce **dopo** | **2** — 05/01/2026 (**+14m32s**) e 25/02/2026 (**+6m47s**) |
| giornate operative identiche | **193 / 193** |

🔬 **E la ragione e' strutturale**: la tranche che resta dopo TP1 **eredita lo
stesso target finale** (`TpTotalR() = InpTP1_R × 3 = 3,0 R`, r.1621-1625) **e lo
stesso trailing**. Il regalo non prolunga la posizione: **la tiene piu' GRANDE
nella stessa finestra.**

**In TAGLIA: il doppio, in una finestra misurata.**

| | valore |
|---|---:|
| posizioni che hanno toccato TP1 (`nd=2` nella viva) | **77 / 193 = 39,9%** |
| durata della finestra a taglia doppia — mediana | **8,6 minuti** |
| p25 · p75 · p90 · max | 6,0 · 14,0 · **20,2** · **27,7** min |
| totale su 21 mesi | **821 minuti** = 13,7 ore |
| 🟢 finestre che sforano la seduta | **ZERO** (`InpCloseHour` 17:30) |

**Il costo di quella finestra, misurato in R sulle stesse 77 giornate:**

| | valore |
|---|---:|
| giornate in cui il regalo fa **PEGGIO** della viva | 🔴 **51 / 77 = 66,2%** |
| caso peggiore: **25/02/2026** | viva **+0,493 R** → regalo **−0,989 R** · **Δ −1,482 R** |
| R minimo fra le 77 giornate con TP1 | viva **+0,134** · regalo 🔴 **−0,989** |
| somma su tutte e 77 | viva +50,87 R · 🟢 **regalo +55,70 R** (**Δ +4,83 R**) |

🔴 **E la causa del 25/02 e' un FATTO DI CODICE, che nessun referto aveva scritto.**
Il blocco del **breakeven al 1° obiettivo** e' **annidato dentro il ramo della
parziale**:
```
r.1899  if(!partialDone && InpTP1_ClosePct > 0 && InpTP1_ClosePct < 100)
          { ...chiusura parziale...
r.1931    if(InpBreakevenAtTP1 && !TkDone(ticket, gBETk)) { ...stop a pari... } }
r.1947  if(InpBEatR > 0 && ...)   // breakeven INDIPENDENTE -- ma InpBEatR = 0
```
👉 **Con `InpTP1_ClosePct = 0` quel ramo non viene MAI eseguito: il regalo non
sposta MAI lo stop a pari al 1° obiettivo.** `InpBreakevenAtTP1=true` nel preset
e' **inerte per annidamento**, e `InpBEatR=0` spegne l'alternativa. L'unica
protezione sopra l'entrata resta il trailing sul minimo della candela M5
precedente — e il 25/02 non e' arrivato in tempo.

**E l'effetto sul MURO GIORNALIERO, che e' la seconda meta' della domanda:**

| | @ rischio 1,00% | **@ rischio 0,65% (la taglia del contratto)** | muro |
|---|---:|---:|---:|
| peggior giornata, cella **VIVA** | −1,0780% | **−0,7007%** | −4,9% |
| peggior giornata, cella **REGALO** | −1,0793% | **−0,7015%** | −4,9% |
| peggior giornata del regalo fra le 77 con TP1 | −0,989% | −0,643% | −4,9% |

> ## 🟢 **IL MURO GIORNALIERO NON SI MUOVE, E IL NUMERO LO DIMOSTRA.**
> **Nessuna delle 77 giornate con la taglia raddoppiata ha prodotto un giorno
> peggiore del semplice giorno di stop pieno** (−0,989 R contro −1,078 R). Alla
> taglia firmata dello **0,65%** la peggior giornata del regalo vale **−0,7015%**
> contro un muro del **4,9%**: margine **4,2 punti**. 👉 **L'esposizione doppia e'
> reale, misurata, e non arriva nemmeno a un sesto del muro.**

## 5.5 🔁 «SE POTREBBE PASSARE, SI INSISTE» — la riparazione candidata

Il buco del breakeven **si tappa senza toccare una riga di codice**: `InpBEatR`
esiste, e' **fuori** dal ramo della parziale (r.1947) ed e' a **0**.
`backtest_pipeline/prove/LE_QUATTRO_FIRME_02_be_regalo_ini.txt` (scritto, gatato,
**non lanciato**) misura `InpBEatR` = 0,0 / 0,5 / **1,0** / 1,5 sulla cella
regalo: **4 celle, 8 passate, 1 round, `T` = 1,216 min.**

🔴 **Con l'attesa e il contro-esempio scritti DENTRO il file, prima dei numeri**:
il breakeven ha un costo noto (trasforma vincenti in pareggi), quindi **il
profitto DEVE scendere e la peggior giornata DEVE migliorare**, tutte e due. Se
una cella facesse **sia** piu' profitto **sia** una peggior giornata migliore,
sta cambiando anche il **conteggio** delle posizioni → sentinella `Trades ±5%`.
Soglia congelata: si raccomanda solo se la peggior giornata migliora di **≥ 0,05
punti** **E** il PF resta **≥ 1,40**.

---

# 6. 🚨 UN RILIEVO TROVATO PER STRADA, e non lo cercavo

Leggendo lo statement per M2 mi e' passata sotto gli occhi una cosa che va detta
anche se non e' la mia missione — perche' tocca una **corsia di RISCHIO firmata**.

Sul demo **`50503392`**, nella finestra 20/07 → 11/09/2026, `770101` su `D30EUR`
fa **35 posizioni** per un totale di **−572,86** unita'. Contro il criterio di
uscita firmato il 18/08 (corsia **MERITO**: *famiglia a 20+ operazioni in perdita
→ revisione di tutte le sedie*), **n=35 > 20 e il segno e' negativo: la corsia e'
formalmente aperta.**

⚠️ **E qui va la valvola, non l'allarme.** Tre cose vanno dette **prima** di
qualunque conclusione, e nessuna delle tre e' chiusa:
1. **le taglie in campo non tornano** — l'indurimento di oggi (§8) misura una
   discrepanza **4,0x** fra `770101` e la gemella. Un P/L in euro su taglie
   sbagliate non e' un giudizio di merito;
2. **19 delle 35 posizioni** stanno nella finestra **pre-07/08**, quella con le
   **gemelle a lotto doppio** (§2.5): quel pezzo di campione e' di una
   configurazione **ritirata**;
3. dal **07/08** in poi sono **16 posizioni pulite**, una al giorno — e su 16
   operazioni la corsia MERITO **non si pronuncia**.

👉 **Verdetto onesto: `[NON ANCORA MISURATO]` sul merito in campo, e la corsia
va guardata al 20° trade della configurazione NUOVA, non del campione misto.**
🔴 **E' una segnalazione per Claudio, non una raccomandazione di spegnimento.**

---

# 7. 🧰 I DUE FILE PROVA — scritti, gatati, **NON lanciati**

| file | cosa misura | celle | passate | round | **T (min)** |
|---|---|---:|---:|---:|---:|
| `prove/LE_QUATTRO_FIRME_CRITERI.md` | 🧊 i criteri congelati | — | 0 | 0 | **0** |
| `prove/LE_QUATTRO_FIRME_01_maxspread_ini.txt` | 🔴 **M1**: il costo del tetto di spread, + due canarini dentro l'asse | 6 | 12 | 1 | **1,524** |
| `prove/LE_QUATTRO_FIRME_02_be_regalo_ini.txt` | 🎁 **M4b**: il breakeven che il regalo perde per annidamento | 4 | 8 | 1 | **1,216** |
| | **TOTALE** | **10** | **20** | **2** | **2,740** |

Metro di casa: **`T = 0,6 + 0,077 × passate`, per ROUND.**
🔴 **Non ho toccato `backtest_pipeline/coda/CODA.txt`.** Se il coordinatore vuole
metterli, sono due righe da **2,74 minuti in tutto** — il resto delle 40 righe
delle 03:30 non si muove.

## 7.1 🚦 I cancelli, riprodotti qui

**Byte non-ASCII, contati con `python3`** (non con `grep '[^\x00-\x7F]'`, che e' rotta):
```
LE_QUATTRO_FIRME_01_maxspread_ini.txt   -> 0
LE_QUATTRO_FIRME_02_be_regalo_ini.txt   -> 0
```

**`controlla_prova.py`** (cancello semantico dei file prova):
```
LE_QUATTRO_FIRME_01_maxspread_ini.txt  ABTG_DAX_Apertura_EU.mq5  pin=81  celle=6  OK
  -> file: 1 | celle: 6 | passate: 12 | problemi: 0 | ESITO: OK | uscita 0
LE_QUATTRO_FIRME_02_be_regalo_ini.txt  ABTG_DAX_Apertura_EU.mq5  pin=81  celle=4  OK
  -> file: 1 | celle: 4 | passate:  8 | problemi: 0 | ESITO: OK | uscita 0
```

**`controlla_riga.py --oggetto prova`**: *«OK file prova ASCII puro»* ·
*«ESITO: nessun difetto meccanico»* · uscita **0**, su entrambi.

**Controlli a mano, perche' i cancelli non li vedono:**
- 🚨 **classe 273**: il **modello non e' pinnato** nei file (arriva dalla riga di
  lancio, dove il default del driver e' **4 = tick reali**,
  `walkforward_generico.ps1` r.180) e **nessun commento e' invertito**:
  `-Modello 4` = tick reali, `-Modello 1` = OHLC M1;
- 📌 `InpSessionHour=8` = **ORA SERVER BCM** (09:00 italiane). Un CSV con **9** si cestina;
- 📌 **magic vergini**: `788101` e `788201` — `grep -rE "\b788[12][0-9][0-9]\b" --exclude-dir=.git .` → **0**;
- 📌 **nessuna chiave duplicata**: 84 chiavi per file, zero doppioni (il primo giro
  ne aveva uno, `InpBEatR` sia nel corpo sia sull'asse: trovato e rimosso **prima** del commit);
- 📌 `InpNewsCurrencies` **non pinnato** di proposito (un pin di stringa vuota MT5 lo ignora).

🔴 **Il secondo strato del cancello — l'agente `controllo-preventivo` — NON POSSO
INVOCARLO IO: lo lancia il coordinatore.** Lo dichiaro e non lo do per fatto.
Fino al suo PASS, questi due file **non escono verso il VPS**.

---

# 8. 🕳️ COSA QUESTO REFERTO **NON** COPRE — elencato per nome

| # | cosa | perche' | conseguenza |
|---:|---|---|---|
| 1 | **quante posizioni costa un tetto di spread** | i per-trade di R47 non contengono lo spread, e le due fonti danno una banda 0-50% | 🔴 **M1 resta `[NON MISURATO]`**. Via al numero: 1,524 min |
| 2 | **che cosa gira su `D30EUR,M15` del 100k `50504263`** | serve il nome in alto a destra di quel grafico | 🔴 **M2 e' misurato sul DEMO**: sul 100k il costo di A1 potrebbe essere diverso. Si chiude con **una foto** |
| 3 | **i PENDENTI nel conteggio di A1** | lo statement contiene solo posizioni chiuse | 🔴 i costi di §2.3 sono un **PAVIMENTO**, non una stima |
| 4 | **il floor con `InpSkipIfTight=false`** | allarga lo stop e riduce il lotto: l'esito del trade cambierebbe | `[NON MISURATO]`, e non lo stimo |
| 5 | **lo spread al MINUTO dentro l'ora 08** | l'istogramma e' orario, e l'ora 08 contiene l'apertura europea | il tetto viene valutato alle **08:35**, non alle 08:00: i costi di M1 sono **PESSIMISTI per costruzione** |
| 6 | **la PROVA DI REGIME** | 21 mesi di D30EUR, stato COMPLETO: **un solo toro** | 🔴 nessuna delle quattro firme e' stata provata contro un crollo, e **non lo sara' entro il 30/09** |
| 7 | **requote e rifiuti d'ordine** | nessuna fonte in casa li contiene | nessun numero qui li modella |
| 8 | **l'esecuzione della PROP VERA** | si misura contro il feed e i costi **BCM** | il profilo della prop e' `[NON MISURATO]` e lo resta |
| 9 | **la taglia vera in campo** | discrepanza 4,0x dell'indurimento §8, non chiusa | tutti i conti a 0,65% assumono le taglie **di contratto** |
| 10 | **il merito in campo di `770101`** | campione misto fra due configurazioni | §6: `[NON ANCORA MISURATO]`, non «morto» |

---

# 9. 🏁 IL CONTO FINALE — tre firme vere, una sospesa

> ## 🟢 **TRE MANOPOLE SU QUATTRO SI CHIUDONO STASERA, CON UN NUMERO CIASCUNA.**
> **M2** (A1 resta 0: costa il 53,6% delle giornate) · **M3a** (`InpSlippagePts`
> resta 0: non entra in nessuna formula del ramo vivo) · **M3b**
> (`InpMinStopPts` resta 0: taglierebbe i trade migliori a ogni livello).
> **Tre no motivati valgono quanto un si'**, e costano **zero minuti di macchina**.
>
> ## 🎁 **LA QUARTA — il regalo — si raccomanda, con la riserva scritta.**
> Allo spread **vero misurato** vince su profitto, PF e DD a **tutti e quattro i
> gradini** e con **tutte e due le basi**; paga **+2,87% di pedaggio in piu'** e
> vince lo stesso; non allunga l'esposizione di **un secondo** in 191 posizioni
> su 193. 🔴 **E porta un buco che oggi ha un nome: a `ClosePct=0` il breakeven
> al 1° obiettivo non scatta mai (r.1899), e il 25/02/2026 e' costato −1,482 R.**
> Si tappa in **1,216 minuti**, senza scrivere codice.
>
> ## 🔴 **E LA QUINTA RIGA, quella che nessuno aveva chiesto: `M1` NON si firma stasera.**
> Il beneficio e' **misurato** (un istante da **12,00 punti indice** all'ora 08,
> dove il **95,9%** della sedia sfonda il pavimento duro), il costo e' **una banda
> da 0% a 50%**. 🟢 **Firmare su una banda cosi' sarebbe stato il modo elegante di
> sbagliare: servono 1,5 minuti di macchina, e li ho preparati.**

## 🧭 E dove siamo, che e' la cosa che conta davvero

Alla challenge restano **~19 giorni**. Stasera `770101` ha **quattro manopole che
non sono piu' un punto di domanda**: tre chiuse con un numero, una con un
preventivo da **novanta secondi**. E il regalo — quel `+0,094` di PF che sta in
archivio da giorni — ha ora **cinque letture indipendenti a favore** e **un
difetto identificato con la riga di codice accanto**.
🟢 Non abbiamo abbassato niente: abbiamo misurato **cinque cose** dove ce n'erano
**quattro**, e una delle cinque ha **smentito un numero scritto oggi**. Questo e'
esattamente il lavoro. 😄

---

# 10. 📚 FONTI — tutte sul branch `lavoro`, tutte aperte e ricontate

**Criteri (committati PRIMA dei numeri):**
`backtest_pipeline/prove/LE_QUATTRO_FIRME_CRITERI.md` (commit `be0e019`)

**Per-trade e riepiloghi (rango M):**
`backtest_pipeline/risultati_prove/aperture_r47/abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_772501.csv` (270 deal / 193 pos, cella VIVA) ·
`..._772503.csv` (193/193, cella REGALO) ·
`..._ABTG_DAX_Apertura_EU_D30EUR_OOS_r47a.csv` e `..._r47b.csv` (91 colonne, lette per nome) ·
`data/statements/trades_auto.csv` (1.303 righe, separatore `;`, 163 su `D30EUR`, 14 magic)

**Spread (rango M, due fonti dichiarate e confrontate):**
`data/spread_vivo/SPREAD_VIVO_2026-09-12_referto.txt` (650.484 campioni, 5 s, 04-11/09) ·
`data/spread_vivo/SPREAD_VIVO_2026-09-12_istogramma.csv` (bin per ora, letti per D30EUR ore 07/08/09) ·
`backtest_pipeline/risultati_archivio/spread_flotta/spread_orario_D30EUR.csv` e `REFERTO_SPREAD_FLOTTA.txt` (30.974.789 tick, finestra 2024.09.26→2026.06.30, `% SOLO-BID 0,000%`)

**Sorgente letto riga per riga** — `mql5/Experts/ABTG_DAX_Apertura_EU.mq5`:
r.240-244 (enum trailing) · r.258 (A1) · r.317-326 (TP1/BE/trailing) · r.344-346 (slippage/floor/skip) · r.359 (MaxSpread) · r.587-602 (guardia anti-duplicato) · r.628-701 (guardia A4 + cancello A1 in PH_BUILDING) · r.910-937 (`EsposizioneSimbolo`, commento compreso) · r.1041-1094 (ramo BREAKOUT, le due sole righe che usano `InpSlippagePts`) · r.1431-1545 (`ArmRetest` + `MonitorRetest`, con `SpreadOK()` a r.1441) · r.1621-1625 (`TpTotalR`) · r.1791-1826 (`CalcLotByRisk`, `MathFloor` a r.1824) · r.1890-1998 (parziale, breakeven annidato a r.1931, BE indipendente a r.1947, trailing a r.1980) · r.2003-2020 (modi di trailing) · r.2113-2139 (`SelectMyPosition`, `SpreadOK`)

**Referti incrociati:**
`report/PANNELLO_770101_IN_CAMPO_2026-09-12.md` (+ ERRATA) ·
`report/VERBALE_CHIUSURA_770101_2026-09-02.md` (C1-C4) ·
`report/INDURIMENTO_PROP_DUE_SEDIE_2026-09-12.md` (**ERRATA sollevata in §5.3**) ·
`report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` (stop misurato 71,9 idx, n=7) ·
`report/FIRME_2026-08-18.md` e `report/FIRME_2026-09-07.md` (i muri e i cap)

**Strumenti di casa usati, non scritti da me:**
`backtest_pipeline/controlla_prova.py` · `backtest_pipeline/controlla_riga.py`
*(`walkforward_generico.ps1` e `RIGA_SOTTILE_ROUND.ps1`: **letti, mai toccati** —
lo sha del primo e' inchiodato.)*

---

🔴 **E la riga che chiude, perche' e' la piu' importante di tutte:**
**nessuna di queste quattro manopole l'ho cambiata, e nessuna la cambierei senza
la firma di Claudio.** Taglie, rischio e protezioni sono sue — anche quando dorme,
anche quando il numero e' bello. Qui si misura e si propone. 🖊️
