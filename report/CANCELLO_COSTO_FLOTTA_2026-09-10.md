# 🚧 IL CANCELLO DEL COSTO, APPLICATO A TUTTA LA FLOTTA VIVA — 10/09/2026

> 🛑 **Questo referto non tocca niente.** Nessun `.mq5`, nessun `.set`, nessun
> parametro in forward, nessun terminale, nessuna riga verso il VPS. È **sola
> lettura** più questo file. Decide Claudio.

> ✅ **STATO: PASSATO DAL CANCELLO il 10/09/2026 — verdetto PASS CON CORREZIONI
> APPLICATE.** `controllo-preventivo` ha rifatto da zero, sui dati grezzi, tutte
> e 21 le misure di stop, tutte le ore modali, tutti gli spread orari, i due
> ancoraggi (114,40 e 47,70), il fattore di conversione e la correlazione di
> rango. **Il motore di misura riproduce al centesimo.** Sono stati corretti
> **sette difetti** (elencati in §0-bis) e aperte **sei classi nuove**
> (197-202) in `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md`.
> 🟢 Nota di perimetro: questo referto **non archivia nessun
> candidato come morto** — dove manca un dato scrive *NON ANCORA MISURATO* —
> quindi non attiva il cancello del 09/09 sui verdetti di archiviazione (le 5
> voci del certificato di morte **non sono richieste** qui, e il cancello lo
> conferma riga per riga: nessuna sedia esce dalla flotta per effetto di questo
> file).

---

# 🔴 LA RIGA CHE VA LETTA PER PRIMA — spostata in cima dal cancello

> **Questa tabella NON è una classifica di rischio, e usarla così è un errore di
> misura.** Fra motori diversi il rapporto `stop/spread` **non predice il
> drawdown**: ρ di Spearman **+0,32** con l'oro dentro, **−0,02** senza (§6.3) —
> e il segno è pure quello *sbagliato* rispetto all'attesa. Due sedie a **13,6x
> e 13,7x** (rapporto praticamente identico) hanno DD promessi di **0,14%** e
> **11,59%**: ottantatré volte di differenza.
> ✅ **Verificato in modo indipendente dal cancello** su una ricostruzione a 21
> sedie coi DD @1% presi da `CONTRATTI_SEDIE.md`: ρ = **+0,38** con l'oro,
> **+0,07** senza, e un jackknife (togli-una) che senza oro oscilla fra
> **−0,12 e +0,23**. **Stessa conclusione: nessuna relazione.**
> 👉 **Il cancello del costo misura il PEDAGGIO. Il drawdown è un altro asse, e
> si legge in `CONTRATTI_SEDIE.md`.** Chi promuove o spegne una sedia guardando
> la colonna `stop/spr` sta leggendo lo strumento sbagliato.

---

**Perché esiste.** `report/DIARIO.md` r.134, voce **2026-08-15 (R55)**, testuale:
> _"La scoperta che vale più del verdetto: stesso slippage in punti, sensibilità
> che differisce di 11 volte — il tipo di ordine non la spiega, la spiega la
> **LARGHEZZA DELLO STOP**... una cella con lo stop stretto è **fragile due
> volte**. **Criterio nuovo e gratis: si applica a tutte e 32 le celle vive
> leggendo `InpSLMode`.**"_

**Quel "si applica a tutte e 32" non risulta mai eseguito.** Questo file lo
esegue, su **52 sedie censite** (che è la flotta di oggi, non quella di agosto).

---

# 0. 🥇 LE SEI RIGHE CHE RESTANO

1. 🔬 **Lo stop di 21 sedie NON È PIÙ UNA STIMA: è misurato dai loro
   trade veri.** `data/statements/trades_auto.csv` ha `close_reason` e i prezzi:
   per ogni operazione chiusa **in stop e in perdita**, `|close − open|` **è** la
   distanza di stop pagata. Nessuno l'aveva mai letta così. **Questo è il dato
   nuovo del referto.**
2. ✅ **Il metodo si auto-verifica**: sulle 7 gambe in stop di `770101` la mia
   estrazione tira fuori **114,40 punti indice** per il 06/08 — che è **lo stesso
   numero, alla seconda cifra**, scritto a mano in `report/giornata_2026-08-06.md`
   r.97 da un'altra sessione (*"lo stop era di **114,40 punti indice**"*). E su
   `770601` NASUSD tira fuori **47,70** (n=9), che è **lo stesso numero** di
   `ROUND_ORB_ATR_PS5` §2.3. **Due ancore indipendenti, due volte esatto.**
3. 🔴 **Il fattore di conversione del brief è SBAGLIATO su questi simboli, e
   sbagliarlo ribalta ogni verdetto.** Su D30EUR / U30USD / NASUSD / XAUUSD
   `Point = 0,01` → **1 punto indice = 100 punti MT5, non 10**. Su 225JPY
   `Point = 1,00` → **fattore 1**. Il "fattore 10" vale **solo sul forex a 5
   cifre**. Fonte: `sonda_storico_17-08/215D85D7_ABTG_InfoBroker.csv` §SIMBOLI,
   confermato dai commenti negli EA (*"500 = 5 punti indice"*).
4. 🔴 **SEI sedie vive NON passano il pavimento di lavoro `40x` con numeri
   MISURATI da tutte e due le parti** (stop e spread): `770611` U30USD (29,5x),
   `770511` U30USD (38,5x), `970913` NASUSD (28,7x), `772234` U30USD (35,0x),
   `772362` GBPCAD (32,4x), e — allo spread P95 — `770101` D30EUR (26,6x).
   **Nessuna sfonda il pavimento DURO 13,3x.**
   *(la v1 scriveva "sette" ed elencava sei sedie: conteggio corretto dal
   cancello, §7.1 diceva già "(6)".)*
5. 🥇 **La più cara della flotta resta quella sul CONTO REALE**: `770611`
   `ABTG_ORB_Ottimizzato` U30USD, **29,5x** (74% del pavimento) con lo stop
   misurato, **23,5x** con quello di R125. È la stessa sedia che R55 misura
   sfondare il 10% di DD con **1,5 punti indice** di slippage e che R88 misura
   fare **DD 9,76% dove il ramo OPPRANGE ne fa 3,84%**.
   🔴 **CORRETTO DAL CANCELLO**: la v1 scriveva *"quattro misure indipendenti"*,
   ed è una **recidiva della classe 196** aperta ieri. Le misure sono **DUE, e
   condividono un dato**: la cella HALFRANGE di R55 (41.057,00 · 1,6742 ·
   9,7623 · n=119) è **la stessa riga di CSV** di R88a. Quindi: **(1)** la
   sensibilità allo slippage (R55) e **(2)** il confronto OOS fra i due rami
   (R88), sulla **stessa** configurazione di base; questo referto aggiunge
   **(3)** il pedaggio, che è l'unico asse davvero nuovo. **R125 non è una
   misura: è una griglia proposta e mai girata.**
6. 🧪 **E il contro-esempio mi smentisce dove conta**: sulla flotta, il rapporto
   `stop/spread` **NON predice il drawdown** (Spearman ρ = **+0,32** con l'oro
   dentro, **−0,02** senza). Il cancello del costo dice *"quanto ti mangia il
   pedaggio"*, **non** *"quanto drawdown farai"*. Due sedie a **13,6x e 13,7x**
   hanno DD promessi di **0,14% e 11,59%**. **Chi usasse questa tabella come
   classifica di rischio userebbe lo strumento sbagliato.**

---

# 0-bis. 🔧 COSA HA CORRETTO IL CANCELLO (10/09) — e cosa ha confermato

**Corretto (7):**
1. 🔴 **Sedie gemelle scambiate**: la geometria `14:25-14:30` attribuita a
   `770611` è di **`770601` NASUSD**. `770611` gira su **14:30-14:45 (15')**.
   Corretto in §5.1 e §6.1. **Classe 197.**
2. 🔢 **Conseguenza mai propagata**: dal 59,0 misurato esce un **range implicito
   ~118 idx**, che sta **SOPRA la banda inferita 85-103** di R125. Ricalcolati e
   pubblicati **OPPRANGE ~64,0x** (era 52,0x) e **~42,7x al P95** (dove R125
   chiedeva buffer ≥15). §5.1 riquadro + §7.1. **Classe 198.**
3. 📅 **Sotto-campione di `770101` sporco**: includeva la gamba del **06/08**,
   che `giornata_2026-08-06.md` r.93-95 dichiara **della geometria VECCHIA**
   (*"la configurazione validata RETEST 35/500 è entrata in produzione solo alle
   19:25 di stasera"*, e il trade è delle **08:18**). Sottocampione vero: n=2,
   mediana **56,10 → 33,0x** (era 59,9 → 35,2x). **Classe 199.**
4. 📏 **Range usato come stop** su `770202`: il 97,9 della strada 3 è il
   **range**; lo stop di `SL_RANGE` è `range + 2×buffer` ≈ **102 → 51,0x**
   (era 49,0x). Verdicto invariato (PASSA). **Classe 200.**
5. 🧮 **Conteggio**: "sette sedie" in §0.4 che ne elencava **sei**.
6. 💱 **Colonna "prudente" non prudente** dove il dato manca: 1,0 pip su
   **cross** con `SpreadPt=0`. I 🟢 di `772421` e `772344` diventano
   **[CONDIZIONATI]**, col numero che li ribalta. **Classe 201.**
7. 🔁 **"Quattro misure indipendenti"** su `770611` (§0.5): **recidiva della
   classe 196**, aperta il giorno prima. Sono **due**, e condividono la riga di
   CSV (R55 = R88a); R125 non ha mai girato. Riscritto.

**E un difetto dello STRUMENTO, non del referto (classe 202):**
`controlla_riga.py` su un `.md` esce **FAIL con 8 bloccanti** — emoji, `[PIN]`,
`[MARCATORE]`, numeri di conto — che su un referto sono **tutti falsi positivi
per costruzione** (le emoji nei `.md` sono regola di casa; i numeri di conto in
chiaro pure). Esito riportato come **NON APPLICABILE**, con l'elenco. 🔧 Riparazione
proposta e **non fatta** (andrebbe a sua volta verificata): un flag
`--oggetto {riga,ps1,md}`.

**Confermato, rifacendo il conto dai dati grezzi (non rileggendo):**
- ✅ **tutte e 21 le mediane di stop**, i due ancoraggi (114,40 e 47,70), tutte
  le **ore modali**, tutti gli **spread orari** citati (§2.2 riquadro);
- ✅ **il fattore di conversione ×100** su D30EUR/U30USD/NASUSD/XAUUSD e **×1**
  su 225JPY, verificato in **tre** modi indipendenti: `Digits/Point` della sonda
  `InfoBroker`, l'intestazione dei CSV di spread (*"1 pto indice = 100 pti
  MT5"*), e la compatibilità di `SpreadPt 280` con la distribuzione dell'ora 17
  (mediana 2,60, **massimo 10,70**: 28,0 sarebbe fuori dal massimo assoluto).
  🔴 **Il "fattore 10" del brief era sbagliato: il referto aveva ragione.**
  ✅ E il fattore è applicato **in modo coerente in tutte le righe**: gli stop
  non ci passano mai (vengono da differenze di prezzo), e i pip del forex
  tornano uno per uno (`0,00389 → 38,9` · `0,470 → 47,0` · `0,586 → 58,6`);
- ✅ **la geometria di ogni riferimento `.mq5` citato** (r.145 ORB, r.84/89 e
  r.345-346 DAX, r.69/234/282/313 Dow, r.78-80 SuperWave, r.68/74 EMA200,
  r.152-153 Larry, r.139-141 GapFill, r.156 CostToCost, r.205 EasyTrend,
  r.98/103/105 PostNews, r.328 BreakingBand, r.145 GapContinuation,
  r.145/148 MaxMinNotte, r.75/78 MaxMin DAX Short);
- ✅ **le 19 NON ANCORA MISURATE**: sono 19, e **ognuna dice cosa le manca**.
  Nessun candidato è archiviato come morto in questo file;
- ✅ **il contro-esempio della ρ** (§6.3), rifatto per via indipendente.

---

# 1. 📐 I CRITERI — letti prima, non reinventati

Fonte: `backtest_pipeline/prove/R125_ORB_COSTO_CRITERI.md` §2 e
`report/ORO_1530_CANCELLO_COSTO_2026-09-10.md` §3.

| pavimento | soglia | cosa vuol dire |
|---|---:|---|
| **DI LAVORO** | `stop >= 40 × spread` | il pedaggio vale ≤ 2,5% del movimento tipico (budget R55) |
| **DURO** | `stop >= 13,3 × spread` | sotto questo si scarta **per aritmetica**, prima di guardare qualunque altra colonna (R125 §5) |

Lo spread si legge **all'ORA in cui la sedia opera davvero**, non sulla mediana
di giornata (R125 §2). Sull'oro entra anche la **commissione misurata 3,48
EUR/lotto** (`ORO_1530_CANCELLO_COSTO` §2.4).

> # 🛑 CORREZIONE DELL'11/09/2026 — QUESTA RIGA ERA FALSA, E TUTTE LE RIGHE FOREX DI QUESTO REFERTO NE DIPENDONO
>
> La v1 diceva: *"sugli indici e sul nostro forex la commissione e' **0,00** —
> verificata su 7 simboli"*. 🔴 **Sugli indici e' vero. Sul forex e' FALSO**, e
> i "7 simboli" erano **tutti indici**: l'insieme era stato scelto male, non
> misurato male.
>
> **Rimisurato su `data/statements/trades_auto.csv`, colonna `commission`:**
>
> | classe | commissione | n | valori distinti |
> |---|---:|---:|---|
> | indici (7 simboli) | **0,0000** | 302 | **uno solo** |
> | forex base **EUR** | 🔴 **−4,0000 esatti** | 84 | **UNO SOLO, varianza ZERO** |
> | base GBP / USD / AUD / NZD | −4,65 / −3,42 / −2,44 / −2,00 | ~250 | seguono il cambio |
>
> 📐 **La legge**: `0,004% del nozionale in valuta base, giro completo`. I
> cambi impliciti tornano su **otto basi valutarie**: GBP/EUR **1,1613**,
> USD/EUR **0,8552**, AUD/EUR **0,6090**, NZD/EUR **0,5000**. E ancorata
> all'oro da' **0,0404 $** contro lo **0,0403 $** gia' scritto in un altro
> referto: verificata contro un numero di qualcun altro, non contro se stessa.
>
> ### 🎯 E COSI' SI SCIOGLIE LA CONTRADDIZIONE, senza mediare niente
> La sonda diceva **0,2-0,4 pip**, le schede del broker **0,8-1,0**. 👉
> **Erano vere tutte e due, e mancava un TERMINE, non una misura**: il conto e'
> **a commissione** (profilo raw), le schede citano lo **STANDARD**. Spread
> **0,3** + commissione **~0,5** = **0,86 pip all-in su EURUSD** — dentro la
> forbice delle schede. **Errore di CATEGORIA, non di misura.**
>
> ### 🔴 CONSEGUENZA: **CINQUE SEDIE RIBALTANO IL VERDETTO**
> `772361` CostToCost EURJPY (73,0x → **25,6x**) · `772162` BreakingBand EURUSD
> (55,2x → **25,6x**) · `771201`/`771202`/`771203` PostNews (62,5-83,3x →
> **21,9 / 28,9 / 26,8x**). Una sopravvive col fiato corto: `772422` EasyTrend
> GBPUSD, margine da **+338% a +18%**.
>
> ### 🚨 E LA PRIMA SEDIA DELLA FLOTTA CHE SFONDA IL PAVIMENTO **DURO**
> **`771201` PostNews EURJPY, dopo il trailing a 15 pip** (`ABTG_PostNews.mq5`
> r.105): `15,0 / 1,139 =` **13,2x**, contro un pavimento duro di **13,3x**.
> Questo referto la dava a **37,5x**. Gemelle trailate: `771202` 17,4x,
> `771203` 16,1x. 🛑 **Ed e' la sedia che ha operato ieri.**
>
> 📄 Dimostrazione completa e contro-esempi:
> `backtest_pipeline/prove/COLLAUDO_SPREAD_FLOTTA_CRITERI.md`.
> 📌 **Correggo anche il conteggio di questo stesso referto** (§4.3): diceva
> *"otto sedie che passano non passano piu'"* a 1,0 pip. A 1,0 pip ne ribaltano
> **sei**; col pedaggio all-in misurato ne ribaltano **cinque**. Le altre due
> dell'"otto" a 1,0 pip **passano**: erano i due condizionati, non ribaltamenti.

---

# 2. 🔬 COME HO MISURATO LO STOP — e in che verso sbaglia

## 2.1 Il metodo, in una riga
`data/statements/trades_auto.csv` (conto **DEMO 50503392**, 1.296 righe,
30/03→09/09/2026) ha le colonne `open_price`, `close_price`, `close_reason`,
`profit`, `magic`. Filtro:
`close_reason = 'sl'` **AND** `profit < 0` **AND** direzione coerente (buy →
`close < open`; sell → `close > open`). Su quelle righe, **`|close − open|` è la
distanza di stop realmente pagata**. Mediana per magic, con l'`n` a fianco.

## 2.2 ✅ La verifica contro numeri scritti da altri (non contro me stesso)
Regola del 10/09: *"prima si cerca il file che ha già la risposta"*.

| ancora | scritto altrove | ricavato da me | esito |
|---|---|---|---|
| `770101` D30EUR, gamba del **06/08** | **114,40 punti indice** — `report/giornata_2026-08-06.md` r.97 | 26.203,10 → 26.088,70 = **114,40** | ✅ identico |
| `770601` NASUSD, geometria 14:25-14:30 | **47,70 MISURATO IN CAMPO** — `report/ROUND_ORB_ATR_PS5_2026-09-10.md` §2.3 | mediana di **9** gambe in stop = **47,70** | ✅ identico |
| unità del DAX | InfoBroker: `D30EUR SpreadPt = 280` (17/08 17:34 srv) | `spread_orario_D30EUR.csv` ora 17: mediana **2,60**, P95 **2,90** | ✅ 2,80 cade dentro la distribuzione dell'ora → **la conversione ×100 è giusta** |
| idem U30USD / NASUSD | `SpreadPt` 200 / 180 | ora 17: mediana **1,90** / **1,70**, P95 **2,00** / **1,80** | ✅ centrate |

> ### ✅ TIMBRO DEL CANCELLO (10/09) — rifatto dai dati grezzi, non riletto
> `controllo-preventivo` ha ricalcolato **tutte e 21 le mediane** con un filtro
> scritto da zero su `trades_auto.csv`. **Riproducono tutte**, cifra per cifra:
> `770101` 71,90 (n=7, la gamba del 06/08 è **26.203,10 → 26.088,70 = 114,40**) ·
> `770601` 47,70 (n=9) · `770611` 59,00 (n=7: 33,3 · 49,1 · 57,7 · 59,0 · 60,0 ·
> 73,5 · 94,0) · `770511` 77,10 · `770531` 295,50 · `771531` 104,30 · `772341`
> 274,15 · `970913` 51,65 · `770402` 32,935 · `971501` 42,28 · `770901` 35,31 ·
> `250604` 7,215 · `772362` 0,00389 = 38,9 pip · e le altre.
> Riproducono anche **tutte le ore modali** (`770101` 19/34 all'ora 08 · `770611`
> **5/8 all'ora 14** · `770402` **9/9 all'ora 07** · `770511` nessuna moda) e
> **tutti gli spread orari** citati (D30EUR h8 1,70/2,70 · U30USD h14 2,00/3,00 ·
> h15 2,00/2,60 · h17 1,90/2,00 · h7 2,60/3,00 · h1 2,80/3,00 · NASUSD h15
> 1,80/2,60 · U30USD "TUTTO" 2,00/2,80).
> 🔎 **E una conferma indipendente della geometria, che il cancello ha cercato
> apposta per rompere la correzione**: i riempimenti di `770611` cadono a
> **14:45:13 e 14:45:31** (subito dopo la FINE del range 14:30-14:45), quelli di
> `770601` a **14:30:00-14:30:51** (subito dopo la fine del range 14:25-14:30).
> **Gli orologi delle due sedie sono diversi, e ognuno combacia col SUO preset.**

## 2.3 🔴 E IN CHE VERSO SBAGLIA — dichiarato prima dei numeri
La distanza letta alla chiusura è lo stop **al momento in cui è stato colpito**,
non necessariamente quello **iniziale**. Con `InpBreakevenAtTP1` o col trailing
attivo lo stop si **stringe**, mai si allarga.
👉 **Quindi la mia misura è un LIMITE INFERIORE dello stop iniziale.**

**Conseguenza, e va letta bene perché non è simmetrica:**
- una sedia che **PASSA** con questo numero **passa a maggior ragione**: ✅ verdetto solido;
- una sedia che **NON passa** con questo numero **potrebbe passare** con lo stop iniziale: 🟡 verdetto **da confermare**, non definitivo.

**La prova che l'effetto esiste**, e la scrivo perché mi indebolisce: su
`770511` U30USD la mediana è **77,10** ma il **minimo è 12,70** (= 6,3x, sotto il
pavimento DURO); su `970913` NASUSD mediana 51,65 e **minimo 9,70** (5,4x).
Quelle gambe corte **sono quasi certamente stop già portati a pari o trascinati**,
non stop iniziali.

## 2.4 ⚠️ E un secondo limite, dichiarato
Il campione è il **conto piccolo 50503392**. Le sedie sul **100k 50504263** e sul
**reale 10105439** hanno gli **stessi magic e la stessa geometria** (solo la
taglia cambia): trasportare il numero è **[INFERITO]**, ma è un'inferenza sulla
*geometria*, non sul risultato — e la geometria è la stessa riga di codice.

---

# 3. 🧮 LE UNITÀ, SIMBOLO PER SIMBOLO — la trappola che ribalta i verdetti

Fonte: `backtest_pipeline/risultati_archivio/sonda_storico_17-08/215D85D7_ABTG_InfoBroker.csv`, blocco `[SIMBOLI]`.

| simbolo | `Digits` | `Point` | 1 punto indice / 1 pip vale | `PipSize()` dell'EA * |
|---|---:|---:|---|---|
| D30EUR · U30USD · NASUSD | 2 | 0,01 | **1 punto indice = 100 punti MT5** | `_Point` = **0,01 idx** (3 "pip" = 0,03 idx ≈ nulla) |
| XAUUSD | 2 | 0,01 | **1,00 $ = 100 punti MT5** | `_Point` = **0,01 $** |
| 225JPY | 0 | 1,00 | **1 punto indice = 1 punto MT5** | `_Point` = **1,00 idx** (3 "pip" = **3 punti Nikkei**) |
| forex 5 cifre | 5 | 0,00001 | **1 pip = 10 punti MT5** | `_Point×10` = **1 pip vero** |
| forex JPY 3 cifre | 3 | 0,001 | **1 pip = 10 punti MT5** | `_Point×10` = **1 pip vero** |

\* `PipSize()` in `mql5/Experts/ABTG_SupertrendReversal.mq5` r.123-127:
`return (d==3 || d==5) ? _Point*10.0 : _Point;`

> 🔴 **Conseguenza operativa, e non è teorica**: `InpSLBufferPips = 3` vale
> **0,03 punti indice sul DAX** (irrilevante) e **3 punti indice sul Nikkei**
> (reale). Lo stesso input, lo stesso numero, due grandezze diverse per un
> fattore **100**. Chi lo legge come "3 pip" su tutti i simboli sbaglia.

**In tutta la tabella madre: gli indici sono in PUNTI INDICE, l'oro in DOLLARI,
il forex in PIP.** Nessuna riga mescola le unità, e ogni conversione è quella qui
sopra.

---

# 4. 💸 LO SPREAD — dove è misurato e dove no

## 4.1 🟢 I tre indici: MISURATO ora per ora, 252 milioni di tick
`backtest_pipeline/risultati_archivio/spread_flotta/spread_orario_{D30EUR,U30USD,NASUSD}.csv`
(finestra 2024.09.26→2026.06.30, `% solo-bid = 0,000%` su tutti e tre).

L'ora operativa di ogni sedia l'ho **misurata dai suoi trade veri** (istogramma
di `open_time` in `trades_auto.csv`, ora **server**), non assunta dal `SessionHour`:

| sedia | ora modale misurata | n | spread mediano di quell'ora | P95 |
|---|---|---:|---:|---:|
| 770101 D30EUR | **08** (19 su 34) | 34 | **1,70** | 2,70 |
| 770411 D30EUR | **08** (5 su 5) | 5 | **1,70** | 2,70 |
| 770202 U30USD | **15** (4 su 4) | 4 | **2,00** | 2,60 |
| 770611 U30USD | **14** (5 su 8) | 8 | **2,00** | 3,00 |
| 771531 U30USD | **17** (4 su 21, sparsa 01-21) | 21 | **1,90** | 2,00 |
| 770511 U30USD | sparsa 03-20, **nessuna moda** | 16 | **2,00** (riga TUTTO) | 2,80 |
| 770531 U30USD | **14** (4 su 14) | 14 | **2,00** | 3,00 |
| 772341 U30USD | **07** (2 su 4) | 4 | **2,60** | 3,00 |
| 772234 U30USD | **01** (1 su 1) | 1 | **2,80** | 3,00 |
| 970913 NASUSD | **15** (2 su 6) | 6 | **1,80** | 2,60 |
| 770250 NASUSD | 🔴 **nessun trade** | 0 | 1,80 (ora 15 attesa) | 2,60 |

## 4.2 🟡 L'oro: due letture sole, nessuna nell'ora giusta
`ORO_1530_CANCELLO_COSTO_2026-09-10.md` §2.1: **0,16 $** (17/08 17:34 srv) e
**0,22 $** (27/08 ~08:5x srv). Costo pieno con commissione: **0,2003 $** / **0,2603 $**.
🔴 Le sedie oro vive operano alle **07** (`770402`, 9 trade su 9) e sparse
(`971501`, `772343`, `970901`): **lo spread a quelle ore è [NON MISURATO]**.
Uso **0,2603 $** (il più prudente che possediamo).

## 4.3 🔴 IL BUCO GRANDE: forex, argento e Nikkei — nessun file orario esiste
**`spread_flotta/` contiene TRE file: D30EUR, NASUSD, U30USD. Punto.**
Per gli altri **17 simboli vivi** l'unica lettura BCM in archivio è la sonda
**istantanea** del 17/08 17:34 server (`InfoBroker.csv`, colonna `SpreadPt`) —
**una lettura, un istante, un'ora sola**, e per parecchi simboli quell'ora **non
è l'ora in cui la sedia lavora**.

| simbolo | `SpreadPt` 17/08 17:34 srv | in pip / punti indice | usabile? |
|---|---:|---|---|
| GBPUSD | 2 | 0,2 pip | 🟡 lettura unica |
| USDJPY | 3 | 0,3 pip | 🟡 lettura unica |
| EURUSD | 4 | 0,4 pip | 🟡 lettura unica |
| EURJPY | 4 | 0,4 pip | 🟡 lettura unica |
| EURCAD | 10 | 1,0 pip | 🟡 lettura unica |
| GBPCAD | 12 | 1,2 pip | 🟡 lettura unica |
| **225JPY** | **35** | **35 punti Nikkei** | 🟡 lettura unica, **fuori sessione Tokyo** |
| AUDUSD · EURAUD · GBPJPY · CHFJPY | **0** | — | 🔴 **INUTILIZZABILE** (0 = nessun tick sul simbolo al momento della sonda, non spread nullo) |

> ### 🔴 E LA CONTRADDIZIONE CHE DEVO DICHIARARE, perché cambia metà tabella
> La sonda legge **0,2-0,4 pip** sui major. Ma
> `caccia_strategie/CONFIG_PROP_SPREAD_SLIPPAGE_2026-09-05.md` §1.2 riporta per
> il conto **STANDARD** di BCM *"spread da **0,8 pip** sui major"* (una seconda
> fonte dice 1,0) — e quel dato è **[LETTO-VIA-SEARCH]**, mai verificato sulla
> pagina ufficiale (§0 dello stesso dossier: il dominio è **EGRESS_BLOCKED**).
> **Le due cose non tornano, e la differenza è un fattore 3-5.**
>
> 👉 **Quindi ogni riga forex la scrivo DUE VOLTE**: con la lettura della sonda e
> con **1,0 pip prudente**. Se il vero spread è 1,0 pip, **otto sedie forex che
> "passano" NON passano più**. Non è un dettaglio di contorno: è metà del
> verdetto sul forex, ed è **[NON MISURATO]**.

---

# 5. 📊 LA TABELLA MADRE — una riga per sedia viva

**Lista sedie:** `backtest_pipeline/coda/referti/CODA_01_sedie_attaccate_20260910_033002.log`
(10/09 03:30, **52 sedie nel profilo attivo**, 6 cartelle dati). Escluse le 4
**utility che non tradano**: `ABTG_TradeExporter` ×2, `ABTG_Guardian` 779001,
`ABTG_SlippageLogger`. Restano **48 righe di trading**, che deduplicate per
(EA × simbolo × geometria) fanno **42 sedie distinte**.

**Legenda conto:** 🔵 piccolo **50503392** · 🟣 100k **50504263** · 🔴 reale
**10105439** · ⚪ Tickmill (conto n/d).
**Legenda stop:** **[MIS]** = mediana delle gambe chiuse in stop e in perdita sul
demo (n a fianco) · **[INF]** = inferito, con la strada dichiarata ·
**[NM]** = non misurato.

## 5.1 🇩🇪🇺🇸 INDICI — spread MISURATO ora per ora (verdetti pieni)

| sedia (magic) | EA | simb | TF | conto | geometria dello stop | stop | fonte del numero | spread | **stop/spr** | **40x?** | **13,3x?** |
|---|---|---|---|---|---|---:|---|---:|---:|:---:|:---:|
| **770101** | DAX_Apertura_EU | D30EUR | M5 | 🔵🟣🔴 | `SLMode = ABTG_SL_RANGE` (estremo opposto del range 35', buffer 500 pt = **5 idx**) — `.mq5` r.314 + `#define` r.84/89; **entrata `RETEST`** (`InpEntryMode=2`, offset 200 pt = 2 idx) nel preset REALE, non BREAKOUT | **71,9 idx** [MIS] n=7 | `trades_auto.csv`, 7 gambe 23/07→14/08 | **1,70** (ora 8) | **42,3x** | 🟢 SI (+6%) | 🟢 SI |
| ↳ *stesso, allo spread P95* | | | | | | 71,9 | idem | 2,70 (P95) | **26,6x** | 🔴 **NO** (67%) | 🟢 SI |
| ↳ *stesso, sotto-campione della geometria VIVA* | | | | | *(dopo il cambio range 15→35, buffer 200→500, entrata RETEST offset 200)* | **56,1** [MIS] n=2 | idem, gambe **10/08 (59,90) e 14/08 (52,30)** | 1,70 | **33,0x** | 🔴 **NO** (82%) | 🟢 SI |
| ↳ *idem, allo spread P95* | | | | | | 56,1 | idem | 2,70 (P95) | **20,8x** | 🔴 **NO** (52%) | 🟢 SI |
| **770202** | Dow_Apertura_US | U30USD | M5 | 🔵🟣 | `SL_RANGE` (range 15' 14:30-14:45, buffer 200 pt = 2 idx, **floor `InpMinStopPts = 500` = 5 idx**) — r.282/234/313 | **~102 idx** [INF] | `ROUND_ORB_ATR_PS5` §2.2 strada 3: **97,9 è il RANGE** (314,5 × √(15/1440) × 3,05); lo stop di `SL_RANGE` = `range + 2×buffer` = 97,9 + 4 (r.897/921: entry `high+buffer`, SL `low−buffer`). 🔴 **CORRETTO DAL CANCELLO**: la v1 usava il range come stop | **2,00** (ora 15) | **51,0x** *(banda 44,5-53,5x sul range 85-103)* | 🟢 SI (+28%) | 🟢 SI |
| **770611** | ORB_Ottimizzato | U30USD | M5 | 🔵🟣🔴 | `SLMode = HALFRANGE(3)` = 50% del range **14:30-14:45 (15 minuti)** + buffer 0 — fonte: `mql5/Presets/conto_reale/ABTG_ORB_Ottimizzato_770611_REALE.set` e `mql5/Presets/sedie_piccolo/recupero2/sedia_ABTG_ORB_Ottimizzato_770611.set` (`InpRangeStart 14:30` / `InpRangeEnd 14:45` / `InpSLMode=3` / `InpSLBufferPts=0`); ⚠️ il **default compilato è OPPRANGE** (r.145). 🔴 **CORRETTO DAL CANCELLO**: la v1 scriveva *"range 14:25-14:30"*, che è la geometria di **`770601` NASUSD** (`mql5/Presets/ABTG_ORB_US.set`, `SLMode=0`), **un'altra sedia** | **59,0 idx** [MIS] n=7 | `trades_auto.csv`, 7 gambe 11/08→03/09 | **2,00** (ora 14) | **29,5x** | 🔴 **NO** (74%) | 🟢 SI |
| ↳ *riga di R125, copiata* | | | | | | ~47 idx [INF] | `ROUND_ORB_ATR_PS5` §2.3 | 2,00 | **23,5x** | 🔴 **NO** (59%) | 🟢 SI |
| ↳ *misurato, allo spread P95* | | | | | | 59,0 | idem | 3,00 (P95) | **19,7x** | 🔴 **NO** (49%) | 🟢 SI |
| **770511** | SuperWave_DOW_H1_Ott | U30USD | H1 | 🔵 | swing 5 barre H1 + `InpSLBufferPips 3` (= **0,03 idx**, inerte) — r.78-79 | **77,1 idx** [MIS] n=4 | `trades_auto.csv` (min 12,7 · max 98,7) | **2,00** (TUTTO, ora sparsa) | **38,5x** | 🔴 **NO** (96%) | 🟢 SI |
| **770531** | SuperWave | U30USD | H4 | 🔵 | swing 5 barre **H4** + 3 "pip" (0,03 idx) | **295,5 idx** [MIS] n=8 | `trades_auto.csv` (min 262,5) | **2,00** (ora 14) | **147,8x** | 🟢 **SI (+269%)** | 🟢 SI |
| **771531** | EMA200 | U30USD | H1 | 🔵 | `InpSLatr 1.0` × ATR(14) **oltre il 2° ordine** (`InpOrder2Atr 0.35`) — r.68/74 | **104,3 idx** [MIS] n=8 | `trades_auto.csv` (65,5-147,0) | **1,90** (ora 17) | **54,9x** | 🟢 **SI (+37%)** | 🟢 SI |
| **772341** | PunteLarry | U30USD | H1 | 🔵 | `SLMode 0` = oltre l'estremo della candela segnale + `0,1 × ATR(D1)` — r.152-153 | **274,2 idx** [MIS] n=2 | `trades_auto.csv` (113,1 / 435,2) | **2,60** (ora 7) | **105,4x** | 🟢 **SI** | 🟢 SI |
| ↳ *al minimo delle due gambe* | | | | | | 113,1 | idem | 2,60 | **43,5x** | 🟢 SI (+9%) | 🟢 SI |
| **772234** | GapFill | U30USD | H1 | 🔵 | `SLMode 0` = `weekOpen + gap × 1,0` — r.139-140 | **98,0 idx** [MIS] n=1 | `trades_auto.csv`, 1 gamba | **2,80** (ora 1) | **35,0x** | 🔴 **NO** (88%) | 🟢 SI |
| **771321** | PTE | U30USD | H1 | 🔵 | ATR(14) H1 + `InpSLbufferPips 5` (= 0,05 idx) — r.81-82 | **~65 idx** [INF] | scala: 314,5 × √(60/1440); **0 gambe in stop sul demo** | **2,00** | **32,5x** | 🔴 **NO** (81%) | 🟢 SI |
| **970912** | SupRev_DAX_H4_Ott | D30EUR | H4 | 🔵 | swing 5 barre H4 + 3 "pip" (0,03 idx) | **~170 idx** [INF] | scala: 186,5 × √(1200/1440); **0 gambe in stop** | **1,70** | **~100x** | 🟢 SI | 🟢 SI |
| **970913** | SupRev_NAS_H1_Ott | NASUSD | H1 | 🔵 | swing 5 barre H1 + 3 "pip" (0,03 idx) | **51,65 idx** [MIS] n=4 | `trades_auto.csv` (min 9,7 · max 151,9) | **1,80** (ora 15) | **28,7x** | 🔴 **NO** (72%) | 🟢 SI |
| **770411** | MaxMinNotte_DAX_Short_Ott | D30EUR | M15 | 🔵🟣 | `SLMode = MM_SL_ATR`, `InpAtrSLmult 2.5` × ATR(14) M15 — r.75/78 | 🔴 **[NM]** | **0 gambe in stop** (5 trade, nessuno chiuso in SL); **ATR M15 del DAX mai misurato** | 1,70 (ora 8) | **[NM]** | ⚪ **NON ANCORA MISURATO** | ⚪ |
| **770250** | Nasdaq_Apertura_US *(GatedShort)* | NASUSD | M15 | 🔵 | `InpSLMode = 0` (SL_RANGE) su **candela H1 precedente** (`RangeMode 2`, `LevelTF 16385`), buffer 300 pt = **3 idx** — preset `ABTG_GatedShort_NASUSD_770250_LIVE.set` | **~67 idx** [INF] | scala: 313,8 × √(60/1440) + 3; **0 trade da quando è viva** | **1,80** (ora 15) | **~37,2x** | 🟡 **NO (93%)** — [INF] | 🟢 SI |

> ### 🔢 IL NUMERO NUOVO CHE ESCE DALLA CORREZIONE — e rafforza il ramo OPPRANGE
> Con la geometria giusta il **59,0 misurato smette di essere solo un rapporto e
> diventa un RIGHELLO**: in `HALFRANGE` lo stop **è** `0,5 × range + buffer`, e
> il buffer è **0** in tutti e due i preset. Quindi
> **`range 14:30-14:45 implicito ≈ 118 punti indice`**.
> - 🧪 **Contro-esempio, costruito prima di scriverlo**: il riempimento può
>   slittare oltre il prezzo del pendente (R55 misura ~1,5 idx), e allora il
>   range vero sarebbe **~115**; il trailing EMA e il pari possono solo
>   **stringere** lo stop realizzato, e allora il range vero sarebbe **≥118**.
>   **Tutte e due le direzioni lasciano il numero fra 115 e 118+.**
> - 🔴 **E sta SOPRA la banda inferita da R125** (`~94`, banda **85-103**,
>   `ROUND_ORB_ATR_PS5` §2.2): la misura **supera il bordo alto**. La banda
>   inferita va dichiarata **superata da una misura**, non mediata con essa.
>
> **Conseguenza aritmetica, ricalcolata e propagata (spread 2,00 · P95 3,00):**
>
> | geometria | stop | **/2,00** | 40x? | **/3,00 (P95)** | 40x al P95? |
> |---|---:|---:|:---:|---:|:---:|
> | **HALFRANGE + 0 — LA CELLA VIVA** | **59,0** [MIS] | **29,5x** | 🔴 NO (74%) | 19,7x | 🔴 NO |
> | **OPPRANGE + 0** = `range + 10 (ingresso)` | **~128** [DERIVATO dal MIS] | **~64,0x** | 🟢 **SI (+60%)** | **~42,7x** | 🟢 **SI (+7%)** |
> | OPPRANGE + 20 | ~148 | ~74,0x | 🟢 SI | ~49,3x | 🟢 SI |
>
> *(l'ingresso è `InpEntryPoints 10,0 × InpK 1,0` = **10 punti indice**, r.614
> `d = InpEntryPoints*InpK; // distanza in PREZZO`; con range 115 invece di 118
> escono 62,5x e 41,7x — **il verdetto non cambia in nessun punto della
> forbice**.)*
>
> 🔓 **Cosa cambia rispetto a R125**: R125 dava OPPRANGE+0 a **52,0x** e
> avvertiva che al bordo basso della banda e allo spread P95 fa **31,7x**,
> quindi serve **buffer ≥ ~25 al bordo basso** (≥ ~16 al centro della banda).
> *(la v1 di R125 scriveva "≥ ~15": ritirato la sera del 10/09 — **classe 195**,
> rispondeva al caso peggiore col numero del caso centrale. Qui ne era rimasto
> in piedi un figlio, chiuso dal terzo giro di cancello — **classe 203**.)*
> Con il range MISURATO, **OPPRANGE+0 passa il 40x anche
> al P95 senza buffer**. 🔴 **Questo NON promuove niente e NON ribalta nessun
> verdetto** (la cella viva resta a 29,5x e resta sotto il pavimento): sposta
> solo il ramo OPPRANGE da *"passa se gli metti il buffer"* a *"passa già
> nudo"*, e **abbassa il costo della griglia R125**. La firma resta a Claudio.

## 5.2 🥇 ORO — spread NON misurato all'ora della sedia, conto fatto col numero prudente

Costo usato: **0,2603 $** = spread 0,22 (S2) + commissione MISURATA 0,0403
(`ORO_1530_CANCELLO_COSTO` §2.4). **È il più sfavorevole che possediamo.**

| sedia | EA | simb | TF | conto | geometria dello stop | stop | fonte | spread+comm | **stop/spr** | **40x?** | **13,3x?** |
|---|---|---|---|---|---|---:|---|---:|---:|:---:|:---:|
| **770402** | MaxMinNotte | XAUUSD | M15 | 🔵 | `MM_SL_ATR`, `1,5 × ATR(14)` M15 — r.145/148 | **32,94 $** [MIS] n=2 | `trades_auto.csv` (25,23 / 40,64); opera tutte e 9 le volte all'**ora 07** | **0,2603** | **126,5x** | 🟢 **SI** | 🟢 SI |
| **971501** | EMA200_Ottimizzato | XAUUSD | H4 | 🔵 | `1,0 × ATR(14)` oltre il 2° ordine (`Order2Atr 0.60`) — r.69/74 | **42,28 $** [MIS] n=4 | `trades_auto.csv` (25,21-70,90) | 0,2603 | **162,4x** | 🟢 **SI** | 🟢 SI |
| **970901** | SupertrendReversal_Ott | XAUUSD | H4 | 🔵 | swing 5 barre H4 + 3 "pip" (0,03 $), `StAtrPeriod 7` | **~35,31 $** [INF] | **gemello `770901` XAUUSD**, n=3, stesso motore con `StAtrPeriod 10`; **0 gambe in stop per 970901** | 0,2603 | **~135,7x** | 🟢 SI | 🟢 SI |
| **772343** | PunteLarry | XAUUSD | H1 | 🔵 | oltre l'estremo + `0,1 × ATR(D1)` | **61,48 $** [MIS] n=1 | `trades_auto.csv`, 1 gamba | 0,2603 | **236,2x** | 🟢 SI | 🟢 SI |
| **250604** | Gold_Ichimoku_TK_ATR_EA | XAUUSD | M5 | ⚪ | 🔴 **sorgente NON nel repo** — geometria dichiarata "TK + ATR", parametri illeggibili | **7,22 $** [MIS] n=2 | `trades_auto.csv` (6,35 / 8,08) | 0,2603 (**BCM**) | **27,7x** | 🔴 NO (69%) | 🟢 SI |
| ↳ *allo spread più favorevole 0,16* | | | | | | 7,22 | idem | 0,16 | **45,1x** | 🟢 SI (+13%) | 🟢 SI |

⚠️ **`250604` gira su TICKMILL, non su BCM**: lo spread di Tickmill è
**[NON MISURATO]** in casa. I due numeri sopra dicono solo *"su BCM sarebbe al
confine"*. Verdetto: **NON ANCORA MISURATO**.

## 5.3 🇯🇵 NIKKEI — le due sedie che il cancello mette peggio, e il perché è lo SPREAD

| sedia | EA | simb | TF | conto | geometria dello stop | stop | fonte | spread | **stop/spr** | **40x?** | **13,3x?** |
|---|---|---|---|---|---|---:|---|---:|---:|:---:|:---:|
| **770924** | SupertrendReversal | 225JPY | H2 | 🔵 | swing 5 barre H2 + `SLBufferPips 3` = **3 punti Nikkei** (qui il buffer è vero!) | **477 idx** [MIS] n=1 | `trades_auto.csv`, 1 gamba | **35** 🟡 | **13,6x** | 🔴 **NO (34%)** | 🟡 SI, per un soffio |
| **770901** | SupertrendReversal | 225JPY | H2 | 🟣 | idem (gemella sul 100k) | 477 [INF] | stessa geometria | 35 🟡 | 13,6x | 🔴 NO | 🟡 |
| **774101** | GapContinuation | 225JPY | M1 | 🔵 | `InpStopBufferPoints 0` — stop sull'estremo del gap — r.145 | **479 idx** [MIS] n=1 | `trades_auto.csv`, 1 gamba | **35** 🟡 | **13,7x** | 🔴 **NO (34%)** | 🟡 SI, per un soffio |
| **772235** | GapFill | 225JPY | H1 | 🔵 | `weekOpen + gap × 1,0` | 🔴 **[NM]** | 0 gambe in stop | 35 🟡 | [NM] | ⚪ NON ANCORA MISURATO | ⚪ |

> 🔴 **Perché queste tre sono "NON ANCORA MISURATO" e non "bocciate":** lo
> spread di **35 punti Nikkei** è **una lettura sola**, presa alle **17:34
> server** = **01:34 a Tokyo, cash chiuso**. `774101` opera fra **01:00 e 07:30
> server** (cash di Tokyo aperto): è **esattamente l'ora in cui lo spread è più
> stretto**, e non l'abbiamo. Sul DAX la stessa differenza vale **2,80 → 1,70**
> (−39%): se sul Nikkei valesse altrettanto, **35 → ~21** e i due rapporti
> diventerebbero **~22,7x**. Ancora sotto 40x, ma un altro pianeta.
> 👉 **Serve `ABTG_SpreadLogger` con `,225JPY` nella lista.** È il buco più
> economico e più redditizio del referto.

## 5.4 💱 FOREX — nessun file di spread orario esiste. Ogni riga è scritta DUE VOLTE

Colonna A = spread della sonda istantanea 17/08 17:34 srv. Colonna B = **1,0 pip
prudente** (la cifra che il broker dichiara nelle schede raccolte via search).

> 🔴 **AVVERTENZA AGGIUNTA DAL CANCELLO — la colonna "prudente" non è prudente
> proprio dove il dato manca.** La colonna B usa **2,0 pip su GBPCAD** (perché
> la sonda lì legge 1,2) ma **1,0 pip su CHFJPY, GBPJPY, EURAUD e AUDUSD**, che
> sono **cross**, e che alla sonda escono **`SpreadPt = 0` = illeggibili**. Su un
> cross 1,0 pip **non è un'ipotesi prudente, è un'ipotesi ottimista**.
> **Conseguenza sui verdetti, scritta col numero che li ribalta:**
> `772421` CHFJPY "passa" (47,0x) **solo se lo spread vero è ≤ 1,17 pip**;
> `772344` GBPJPY "passa" (58,6x) **solo se è ≤ 1,47 pip**; `772342` EURAUD non
> passa comunque. 👉 Quei due 🟢 vanno letti **[CONDIZIONATI]**, non acquisiti —
> e si chiudono con lo `SpreadLogger` (§8), non con un'assunzione.

| sedia | EA | simb | TF | conto | geometria dello stop | stop (pip) | fonte | spr A | **x (A)** | **40x?(A)** | spr B | **x (B)** | **40x?(B)** | 13,3x? |
|---|---|---|---|---|---|---:|---|---:|---:|:---:|---:|---:|:---:|:---:|
| **772422** | EasyTrend | GBPUSD | H1 | 🔵 | `InpSLBufferPts 30` (= **3 pip**) oltre l'estremo della figura — r.205 | **35,0** [MIS] n=1 | `trades_auto.csv` | 0,2 | **175,0x** | 🟢 SI | 1,0 | **35,0x** | 🔴 NO (88%) | 🟢 SI |
| **772421** | EasyTrend | CHFJPY | H1 | 🔵 | idem | **47,0** [MIS] n=2 | `trades_auto.csv` (46,6/47,4) | 🔴 **0 = illeggibile** | — | ⚪ | 1,0 | **47,0x** | 🟢 SI (+18%) | 🟢 SI |
| **772361** | CostToCost | EURJPY | H4 | 🔵 | oltre la punta + `0,2 × ATR(14)` del TF — r.156 | **29,2** [MIS] n=3 | `trades_auto.csv` (26,4-30,5) | 0,4 | **73,0x** | 🟢 SI | 1,0 | **29,2x** | 🔴 NO (73%) | 🟢 SI |
| **772362** | CostToCost | GBPCAD | H4 | 🔵 | idem | **38,9** [MIS] n=2 | `trades_auto.csv` (27,4/50,5) | **1,2** | **32,4x** | 🔴 **NO (81%)** | 2,0 | **19,4x** | 🔴 NO (49%) | 🟢 SI |
| **772162** | BreakingBand | EURUSD | H1 | 🔵 | `InpSL_ATRmult 3.0` × ATR(14) — r.328, **stop largo per disegno** (nota Leonardo, `CONTRATTI_SEDIE.md`) | **22,1** [MIS] n=1 | `trades_auto.csv` | 0,4 | **55,2x** | 🟢 SI | 1,0 | **22,1x** | 🔴 NO (55%) | 🟢 SI |
| **772161** | BreakingBand | GBPUSD | H1 | 🔵 | `3,0 × ATR(14)` | 🔴 **[NM]** | 0 gambe in stop (2 trade) | 0,2 | [NM] | ⚪ | 1,0 | [NM] | ⚪ | ⚪ |
| **772163** | BreakingBand | AUDUSD | H1 | 🔵 | `3,0 × ATR(14)` | 🔴 **[NM]** | 0 gambe in stop | 🔴 **0 = illeggibile** | [NM] | ⚪ | 1,0 | [NM] | ⚪ | ⚪ |
| **772231** | GapFill | GBPUSD | H1 | 🔵 | `weekOpen + gap × 1,0` | 🔴 **[NM]** | 0 trade sul demo | 0,2 | [NM] | ⚪ | 1,0 | [NM] | ⚪ | ⚪ |
| **772232** | GapFill | EURUSD | H1 | 🔵 | idem | 🔴 **[NM]** | 0 trade | 0,4 | [NM] | ⚪ | 1,0 | [NM] | ⚪ | ⚪ |
| **772233** | GapFill | AUDUSD | H1 | 🔵 | idem | 🔴 **[NM]** | 0 trade | 🔴 0 | [NM] | ⚪ | 1,0 | [NM] | ⚪ | ⚪ |
| **772342** | PunteLarry | EURAUD | H1 | 🔵 | oltre l'estremo + `0,1 × ATR(D1)` | **35,6** [MIS] n=2 | `trades_auto.csv` (19,8/51,5) | 🔴 **0 = illeggibile** | — | ⚪ | 1,0 | **35,6x** | 🔴 NO (89%) | 🟢 SI |
| **772344** | PunteLarry | GBPJPY | H1 | 🔵 | idem | **58,6** [MIS] n=1 | `trades_auto.csv` | 🔴 **0** | — | ⚪ | 1,0 | **58,6x** | 🟢 SI (+47%) | 🟢 SI |
| **772345** | PunteLarry | GBPUSD | H1 | 🔵 | idem | 🔴 **[NM]** | 0 gambe in stop (2 trade) | 0,2 | [NM] | ⚪ | 1,0 | [NM] | ⚪ | ⚪ |
| **772346** | PunteLarry | EURCAD | H1 | 🔵 | idem | 🔴 **[NM]** | 0 gambe in stop | 1,0 | [NM] | ⚪ | 1,0 | [NM] | ⚪ | ⚪ |
| **771322** | PTE *(storica)* | GBPUSD | H1 | 🔵 | ATR(14) H1 + `SLbufferPips` **5** | 🔴 **[NM]** | 0 gambe in stop (1 trade) | 0,2 | [NM] | ⚪ | 1,0 | [NM] | ⚪ | ⚪ |
| **771332** | PTE *(cand. R78)* | GBPUSD | H1 | 🔵 | ATR(14) H1 + `SLbufferPips` **25** ⬅️ *la sedia con lo stop più largo del duello* | 🔴 **[NM]** | 0 trade | 0,2 | [NM] | ⚪ | 1,0 | [NM] | ⚪ | ⚪ |
| **771201** | PostNews *(ECB)* | EURJPY | M5 | 🔵 | 🎯 **`InpSLpips = 25.0` — PUNTI FISSI**, r.98; `InpUseTrail25` porta lo SL a **15 pip** dopo +25 — r.103/105 | **25,0** *(dichiarato)* | `mql5/Experts/ABTG_PostNews.mq5` r.98 | 0,4 | **62,5x** | 🟢 SI | 1,0 | **25,0x** | 🔴 NO (62%) | 🟢 SI |
| ↳ *dopo il trail a 15 pip* | | | | | | 15,0 | r.105 | 0,4 | **37,5x** | 🔴 NO (94%) | 1,0 | 15,0x | 🔴 NO | 🟢 SI |
| **771202** | PostNews *(FOMC)* | EURUSD | M5 | 🔵 | idem, 25 pip fissi | **25,0** | idem | 0,4 | **62,5x** | 🟢 SI | 1,0 | 25,0x | 🔴 NO | 🟢 SI |
| **771203** | PostNews | USDJPY | M5 | 🔵 | idem, 25 pip fissi | **25,0** | idem | 0,3 | **83,3x** | 🟢 SI | 1,0 | 25,0x | 🔴 NO | 🟢 SI |
| **—** | BREAKOUT_EA_JPY_v3 | USDJPY | M15 | ⚪ | 🔴 **sorgente NON nel repo, magic illeggibile dal `.chr`** | 🔴 **[NM]** | — | 0,3 | [NM] | ⚪ **NON ANCORA MISURATO** | 1,0 | [NM] | ⚪ | ⚪ |

---

# 6. 🧪 I CONTRO-ESEMPI — costruiti PRIMA di consegnare

## 6.1 🧪 «È un falso scarto: hai misurato il TF, non lo stop»
*(la trappola indicata nel brief, `ROUND_ORB_ATR_PS5` §2.4: "il TF non decide il
costo: lo decide lo stop")*

**Verifica**: ho preso **tutte** le sedie che dichiaro sotto il pavimento e ho
controllato che il numero al numeratore fosse **una distanza di stop**, non un TF.

| sedia bocciata | TF | lo stop viene da… | è geometrico o scalato sulla barra? |
|---|---|---|---|
| 770611 U30USD | **M5** | 50% del range **14:30-14:45 (15 minuti)** = **59,0 idx misurati** | 🟢 **geometrico** (range di 15 minuti), **non** la barra M5 |
| 770101 D30EUR | **M5** | estremo opposto del range **35 minuti** = **71,9 idx misurati** (56,1 sulla geometria viva) | 🟢 **geometrico** (range di 35 minuti), **non** la barra M5 |
| 970913 NASUSD | H1 | swing 5 barre = **51,65 idx misurati** | 🟢 geometrico |
| 770511 U30USD | H1 | swing 5 barre = **77,1 idx misurati** | 🟢 geometrico |
| 772234 U30USD | H1 | `gap × 1,0` = **98,0 idx misurati** | 🟢 geometrico |
| 772362 GBPCAD | H4 | punta + 0,2 ATR = **38,9 pip misurati** | 🟢 geometrico |
| 771201-03 PostNews | **M5** | **25 pip FISSI** dichiarati nel codice | 🟢 **fisso**, non c'entra la barra |

✅ **Il contro-esempio NON rompe la tabella**: nessuna sedia è bocciata "perché è
su M5". Anzi — **le due sedie su M5 con lo stop più largo della flotta relativa
(770202 a 49,0x e PostNews a 62,5x) PASSANO**, mentre una su **H1** (970913) non
passa. **Il TF e il verdetto non sono correlati**, ed è la prova che sto
misurando la cosa giusta.

## 6.2 🧪 «Hai sbagliato il fattore di conversione»
Il brief avvisa: *"uno stop dichiarato in punti MT5 non è un punto indice
(fattore 10 su questi simboli)"*.

🔴 **Ho provato a rompere la mia tabella su questo, e ho trovato che il fattore
del brief è sbagliato: su D30EUR/U30USD/NASUSD/XAUUSD è 100, non 10**
(`Point = 0,01`). Su 225JPY è **1** (`Point = 1,00`). §3 di questo referto.

**Come l'ho verificato senza fidarmi di me stesso** (§2.2): la sonda istantanea
legge `D30EUR SpreadPt = 280` alle 17:34 srv; se il fattore fosse 10 sarebbero
**28,0 punti indice**, ma il file dei tick dice che alle ore 17 la mediana è
**2,60** e il **massimo 10,70** — **28,0 sarebbe FUORI dal massimo assoluto**
dell'ora. Con il fattore 100 escono **2,80**, dentro la distribuzione. ✅ **Solo
il fattore 100 è compatibile con una misura indipendente da 30,9 milioni di
tick.** Stesso test superato su U30USD e NASUSD.

📌 **E i miei numeri di stop non passano mai da quel fattore**: vengono da
`|close − open|` sui prezzi dello statement, che sono **già** in punti indice
(25.018,00). Il fattore avrebbe potuto sporcare solo lo spread — e lo spread
degli indici lo prendo dai CSV che sono **già in punti indice** (intestazione:
*"conversione: 1 pto indice = 100 pti MT5"*).

## 6.3 🧪 LA SEDIA CHE MI SMENTISCE — e ce ne sono quattro
*Il brief chiede: cerca una sedia il cui esito contraddice "stop stretto = fragile".*

🔴 **Esistono, e sono l'informazione più preziosa del referto.**

| sedia | **stop/spread** | **DD promesso @1%** | fonte del DD | cosa dimostra |
|---|---:|---:|---|---|
| **770924** SupertrendReversal 225JPY | **13,6x** (il peggiore misurabile) | **0,14%** | `CONTRATTI_SEDIE.md` §Ottimizzati | 🔴 stop strettissimo sul metro del costo, **il DD più basso di tutta la flotta** |
| **970913** SupRev_NAS_H1 | **28,7x** (sotto il pavimento) | **1,17%** | idem, *"il prop-friendly ⭐"* | 🔴 non passa il cancello ed è fra le più tranquille che abbiamo |
| **971501** EMA200_Ott XAUUSD | **162,4x** (fra i più larghi) | **45,91%** | `R100_REFERTO.md` via `CONTRATTI_SEDIE.md` | 🔴 **stop larghissimo e il DD PEGGIORE della flotta** |
| **774101** vs **770924** | **13,7x vs 13,6x** — *identici* | **11,59% vs 0,14%** | R65/R66 vs R5 | 🔴 **stesso rapporto di costo, DD che differiscono di 83 volte** |

**E il conto d'insieme, fatto invece che raccontato**: correlazione di rango fra
`stop/spread` e `DD promesso @1%` su **20 sedie** con tutti e due i numeri:
**ρ = +0,32** (segno **sbagliato** rispetto all'attesa) e **ρ = −0,02** togliendo
le tre sedie oro. **Cioè: nessuna relazione.**

> ✅ **RIFATTO DAL CANCELLO, per una via indipendente.** Difetto di forma
> rilevato: **le 20 coppie non sono pubblicate qui**, quindi il numero non è
> riproducibile leggendo il referto. Il cancello ha ricostruito le coppie da
> zero — `stop/spr` da questa tabella, `DD @1%` da `CONTRATTI_SEDIE.md`
> (`770101` ~~10,60~~ 🔴🆕 **6,7111 @1%** *(ERRATA 11/09: il 10,60 e' R83 con `InpAllowShort=1`; ⚠️ dep. 10.000 EUR — 📄 `report/CONFLITTO_DD_770101_2026-09-11.md`)* · `770202` 4,22 · `770611` 9,92 · `770511` 4,0 · `770531` 2,96
> · `771531` 7,21 · `772341` 3,9 · `772234` 2,3 · `771321` 2,18 · `970912` 5,7 ·
> `970913` 1,17 · `770402` 19,72 · `971501` 45,91 · `970901` 9,0 · `772343`
> 29,74 · `770924` 0,14 · `774101` 11,59 · `772422` 4,58 · `772361` 9,33 ·
> `772362` 6,18 · `772162` 1,2) — e ottiene **ρ = +0,38 con l'oro, +0,07 senza**,
> su n=21. **Jackknife togli-una: senza oro ρ oscilla fra −0,12 e +0,23.**
> 👉 Numeri diversi al secondo decimale (insieme leggermente diverso), **stessa
> conclusione, e nessuna delle due versioni è distinguibile da zero** (a n≈20
> servirebbe |ρ| ≳ 0,44 per parlare). **La riga regge, ed è per questo che il
> cancello l'ha spostata in cima al referto.**
>
> ### 🔴🆕 ERRATA 11/09 — **e dichiaro anche cosa NON ho rifatto**
> Il `DD @1%` della **`770101`** usato in queste correlazioni era **10,60**, che
> è di R83 (**`InpAllowShort=1`**): il valore giusto è **6,7111 @1%**
> (📄 `report/CONFLITTO_DD_770101_2026-09-11.md`). È un **cambio di RANGO** — la
> `770101` scende da 3ª a 6ª più alta dell'insieme — quindi **ρ cambia**.
> 🔴 **I due ρ (+0,32 / +0,38 con l'oro · −0,02 / +0,07 senza) NON sono stati
> ricalcolati qui: sono `[DA RIFARE]`**, e li lascio scritti come sono invece di
> stimarli a occhio. ✅ **Ciò che NON cambia è l'argomento**: la soglia di
> leggibilità dichiarata è **|ρ| ≳ 0,44 a n≈20**, e **un solo punto su 21 che
> cambia rango non porta un ρ da ~0,35 sopra 0,44**. La conclusione *"nessuna
> relazione"* regge; il numero da ripubblicare, no.

> ### 🔑 LA LETTURA ONESTA, che salva il criterio invece di buttarlo
> R55 confronta **la stessa sedia con se stessa** (stesso motore, stessi trade,
> cambia solo `InpSLMode`): lì lo stop largo **riduce davvero** il DD, ed è
> misurato tre volte (R55, R88 3,84% vs 9,76%, R118 piano inclinato monotono su
> 5 gradini). **Quella lettura regge.**
> Io qui confronto **motori diversi fra loro**, e lì la relazione **sparisce**.
> 👉 **Il cancello del costo misura il PEDAGGIO, non il DRAWDOWN.** Sono due
> assi diversi. 🔴 **Usare questa tabella come classifica di rischio sarebbe un
> errore di misura**, e lo scrivo qui perché è esattamente il modo in cui un
> criterio giusto viene applicato male.

## 6.4 🧪 «Il tuo stop misurato è quello iniziale?»
**No, ed è dichiarato in §2.3: è un limite inferiore.** Il contro-esempio che lo
prova sta nei miei stessi dati (770511 min 12,7 su mediana 77,1). **Direzione
dell'errore: i "PASSA" sono solidi, i "NON PASSA" sono da confermare.**

---

# 7. 🔓 LA LISTA CORTA — chi non passa il cancello, e se è riparabile

## 7.1 🔴 NON PASSANO `40x` con numeri MISURATI da tutte e due le parti (6)

| sedia | x | riparabile con una manopola **che esiste già**? | quale, e dove sta scritta |
|---|---:|---|---|
| **770611** ORB U30USD M5 🔴🟣🔵 | **29,5x** | 🟢 **SÌ, ed è già misurata** | `InpSLMode: HALFRANGE(3) → OPPRANGE(0)` (`ABTG_ORB_Ottimizzato.mq5` r.145) porta lo stop da **59,0 MISURATO** a **~128 idx** (`range implicito 118 + 10 d'ingresso`) = **~64,0x**, e **~42,7x anche allo spread P95** (§5.1, riquadro). 🔴 **CORRETTO DAL CANCELLO**: la v1 scriveva "52-62x", numeri costruiti sul range **inferito** ~94 di R125, che la misura **supera**. R88 misura che **dimezza anche il DD** (9,76 → 3,84%). ➡️ **è già in griglia: R125, in attesa di firma** |
| **970913** SupRev_NAS NASUSD H1 | **28,7x** | 🟡 **SÌ, mai provata** | `InpSLLookback: 5 → 8/10` (r.77) allarga lo swing; `InpSLBufferPips` **è inerte sugli indici** (0,03 idx: §3) → il buffer va messo in ATR, e **la manopola non esiste in questo EA**. Alternativa a costo zero: **TF H2/H4** (la gemella `770531` su H4 fa 147,8x) |
| **770511** SuperWave_DOW U30USD H1 | **38,5x** (96%!) | 🟢 **SÌ** | idem sopra: `InpSLBufferAtr` **esiste** in `ABTG_SuperWave_DOW_H1_Ottimizzato.mq5` r.80 (*">0: buffer SL in ATR, IGNORA InpSLBufferPips"*) ed è a **0**. 🔓 **Manopola mai messa ad asse**: bastano ~0,05 ATR per superare il pavimento |
| **772234** GapFill U30USD H1 | **35,0x** (88%) | 🟢 **SÌ** | `InpSLMode: 0 → 1` (ATR(D1) × `InpAtrSlMult 1.5`, r.139-141): sul Dow 1,5 × ATR(D1) ≈ **470 idx** ≫ pavimento. Oppure `InpSLGapMult: 1,0 → 1,5`. ⚠️ n=1: **misurare prima** |
| **772362** CostToCost GBPCAD H4 | **32,4x** (81%) | 🟢 **SÌ** | `InpSLBufferATR: 0,2 → 0,45` (r.156). GBPCAD è il simbolo **col spread più largo del nostro forex** (1,2 pip): è l'unico dove il buffer morde davvero |
| **770101** DAX_Apertura D30EUR M5 🔴🟣🔵 | 42,3x mediana ma **26,6x al P95** e **33,0x sulla geometria VIVA** (n=2, §5.1 — 🔴 corretto dal cancello: era 35,2x con dentro una gamba della geometria vecchia) | 🟡 **SÌ, ma va misurato prima** | `InpMinStopPts` **esiste ed è a 0** (r.345) con `InpSkipIfTight = true` (r.346) — cioè oggi il DAX **salta** i trade a stop stretto invece di allargarli. Un floor a **6.800 pt = 68 idx** metterebbe il 40x per costruzione. 🔴 **Ma `InpSkipIfTight=true` significa che alzarlo TAGLIA operazioni**, e la frequenza è il requisito n.1 di ottobre: **prima si misura quante ne perde** |

## 7.2 🟡 NON PASSANO ma il numero è INFERITO da un lato (2)

| sedia | x | cosa manca | riparabile? |
|---|---:|---|---|
| **770250** GatedShort NASUSD M15 | ~37,2x [INF] | **0 trade da quando è viva** → stop mai misurato | 🟢 `InpBufferPoints: 300 → 900` (+6 idx) porta a ~40,5x; oppure `InpSLMode: 0 → 1` con `AtrSlMult 1.5` |
| **771321** PTE U30USD H1 | ~32,5x [INF] | 0 gambe in stop sul demo | 🟢 `InpSLbufferPips 5 → 25` — **la manopola esiste, è la stessa del duello GBPUSD** (`771332`), e su U30USD **non è mai stata provata**. ⚠️ Su U30USD 25 "pip" = **0,25 punti indice** (§3): 🔴 **sul Dow quella manopola è INERTE**. Serve un buffer in ATR, che in `ABTG_PTE.mq5` **non c'è** |

## 7.3 ⚪ NON ANCORA MISURATO — cosa manca, sedia per sedia (19)

| sedia | cosa manca esattamente |
|---|---|
| **770411** MaxMinNotte_DAX_Short D30EUR M15 | stop: 0 gambe in stop su 5 trade · **ATR(14) M15 del DAX mai misurato** |
| **770924 / 770901 / 774101 / 772235** (225JPY) | **spread di 225JPY all'ora della sedia**: una lettura sola, presa a cash Tokyo chiuso |
| **772161 / 772163** BreakingBand GBPUSD/AUDUSD | 0 gambe in stop; per AUDUSD anche lo spread è illeggibile |
| **772231 / 772232 / 772233** GapFill forex | 0 trade sul demo |
| **772345 / 772346** PunteLarry GBPUSD/EURCAD | 0 gambe in stop |
| **771322 / 771332** PTE GBPUSD | 0 gambe in stop (il duello ha 1 trade in tutto) |
| **772342 / 772344 / 772421** (EURAUD, GBPJPY, CHFJPY) | **spread illeggibile** (`SpreadPt = 0` = nessun tick alla sonda) — lo stop invece è misurato |
| **250604** Gold_Ichimoku (Tickmill) | spread di **Tickmill**: mai misurato in casa. Sorgente dell'EA non nel repo |
| **BREAKOUT_EA_JPY_v3** USDJPY M15 | tutto: sorgente assente, magic illeggibile, 0 trade attribuibili |

## 7.4 🟢 E LE 15 CHE PASSANO — perché contano quanto le altre
`770202` (49,0x [INF]) · `770531` (**147,8x**) · `771531` (54,9x) · `772341`
(105,4x) · `970912` (~100x [INF]) · `770402` (**126,5x**) · `971501` (162,4x) ·
`970901` (~135,7x) · `772343` (**236,2x**) · e — **solo se lo spread forex vero è
0,2-0,4 pip** — `772422`, `772361`, `772162`, `771201`, `771202`, `771203`.

🥇 **Il gruppo dell'oro passa con margini fra +216% e +490% anche col pedaggio
pieno commissione compresa.** Sull'oro il problema **non è mai stato il costo**:
è il DD (45,91% su `971501` a rischio 1%). **Due assi diversi**, §6.3.

---

# 8. 🚩 I BUCHI, DICHIARATI

| buco | stato | come si chiude | costo |
|---|---|---|---|
| **spread orario di 225JPY, XAUUSD e dei 10 simboli forex vivi** | 🔴 **[NON MISURATO]** — `spread_flotta/` ha **3 file su 13 simboli** | `ABTG_SpreadLogger` sul demo **50503392** raccoglie già dal 06/09 su 8 simboli oro compreso: manca solo la **raccolta** (`RIGA_SPREADLOGGER_RACCOLTA.ps1`) e l'aggiunta di `,225JPY` | **una riga**, MT5 resta aperto |
| **stop iniziale contro stop realizzato** | 🟡 la mia misura è un **limite inferiore** (§2.3) | log dello SL all'apertura, oppure lettura del `.chr` | — |
| **i parametri che GIRANO davvero** | 🔴 `CODA_08_preset_dai_chr_20260910_033002.log` dice **"TOTALE SEDIE STAMPATE: 0"** — lo strumento che doveva dumpare gli `Inp*` **non ha stampato niente**. Tutte le geometrie qui sono lette dal **sorgente**, non dal grafico vivo | riparare `CODA_08` | una riga |
| **spread al MINUTO** dentro l'ora | 🔴 [NON MISURATO] su tutti i simboli. Direzione dell'errore **nota e sfavorevole** (U30USD ora 14 ha `max = 47,0`) | SpreadLogger | — |
| **slippage** | 🔴 quasi tutto [NON MISURATO]: `n=1` sul reale, 0 righe oro | — | — |
| **spread di Tickmill** (sedia `250604`) | 🔴 [NON MISURATO] | — | — |
| **il range 14:30-14:45 di U30USD, misurato direttamente** | 🟡 oggi è **DERIVATO** dallo stop (≈118 idx): non è mai stato letto dalle barre | una corsa diagnostica sulla distribuzione del range d'apertura (la stessa che `ROUND_ORB_ATR_PS5` §2.3 chiede per NASUSD) | una corsa |
| **il confine del 06/08 su `770101`** | 🟡 il cambio 15→35 è andato in produzione alle **19:25**: il sotto-campione della geometria viva ha **n=2** | tempo, o la lettura dei log di attacco | — |
| **11 sedie senza una sola gamba chiusa in stop** | 🔴 il campione non c'è: è **assenza di dato**, non un dato buono | tempo, o un backtest che riporti la distanza di stop | — |

---

# 9. ✍️ LA RIGA PER `REGISTRO_TEST.md`

> **CANCELLO DEL COSTO SU TUTTA LA FLOTTA (10/09/2026)** — criterio R55 del
> 15/08 (*"si applica a tutte e 32 le celle vive"*) **eseguito per la prima
> volta**, su 42 sedie distinte delle 52 censite il 10/09 03:30.
> **Stop MISURATO** dai trade veri (`trades_auto.csv`, `close_reason='sl'` +
> `profit<0`) per **21 sedie** (+3 a stop FISSO dichiarato nel codice); metodo verificato contro due numeri scritti
> indipendentemente (114,40 su `770101`, 47,70 su `770601`). **Non passano il
> pavimento di lavoro 40x con numeri misurati da tutte e due le parti: 770611
> (29,5x), 770511 (38,5x), 970913 (28,7x), 772234 (35,0x), 772362 (32,4x),
> 770101 al P95 (26,6x). Nessuna sfonda il pavimento DURO 13,3x.**
> 🔓 **Cinque su sei sono riparabili con una manopola che esiste già** — e per
> `770611` la manopola è `InpSLMode → OPPRANGE`, che R88 misura dimezzare anche
> il DD (9,76 → 3,84%). **19 sedie restano NON ANCORA MISURATE** (spread orario
> mancante su 10 simboli, o zero gambe in stop). 🔴 **Contro-esempio a verbale:
> sulla flotta `stop/spread` NON predice il DD (ρ = −0,02 senza l'oro; ρ = +0,07
> nella ricostruzione indipendente del cancello)**: il cancello misura il
> pedaggio, non il rischio.
> 🔧 **Passato dal cancello il 10/09 con 6 correzioni** (classi 197-201): la più
> pesante è che `770611` gira su **14:30-14:45**, non su 14:25-14:30 (quella è
> `770601`), e che dal 59,0 misurato esce un **range implicito ~118** — sopra la
> banda inferita 85-103 di R125 — che porta **OPPRANGE a ~64,0x e a ~42,7x anche
> al P95**, cioè **sopra il pavimento di lavoro senza bisogno di buffer**.
> Corretto anche il sotto-campione della geometria viva di `770101`, sedia del
> **conto reale 10105439**: **n=2, 56,10 idx, 33,0x** (non 59,9/35,2x).

---

_Fonti primarie, tutte sul branch `lavoro`:_
`backtest_pipeline/coda/referti/CODA_01_sedie_attaccate_20260910_033002.log` ·
`backtest_pipeline/coda/referti/CODA_08_preset_dai_chr_20260910_033002.log` (vuoto, §8) ·
`data/statements/trades_auto.csv` ·
`backtest_pipeline/risultati_archivio/spread_flotta/spread_orario_{D30EUR,NASUSD,U30USD}.csv` + `REFERTO_SPREAD_FLOTTA.txt` ·
`backtest_pipeline/risultati_archivio/sonda_storico_17-08/215D85D7_ABTG_InfoBroker.csv` ·
`backtest_pipeline/prove/R125_ORB_COSTO_CRITERI.md` ·
`report/ORO_1530_CANCELLO_COSTO_2026-09-10.md` ·
`report/ROUND_ORB_ATR_PS5_2026-09-10.md` §2.2-2.4 ·
`report/ORB_OPPRANGE_RIAPERTURA_2026-09-10.md` ·
`report/CONTRATTI_SEDIE.md` ·
`report/giornata_2026-08-06.md` r.97 ·
`report/DIARIO.md` r.134 (R55) ·
`backtest_pipeline/caccia_strategie/CONFIG_PROP_SPREAD_SLIPPAGE_2026-09-05.md` §0 e §1.2 ·
`mql5/Experts/ABTG_{ORB_Ottimizzato,DAX_Apertura_EU,Dow_Apertura_US,Nasdaq_Apertura_US,PostNews,PTE,BreakingBand,GapFill,PunteLarry,CostToCost,EasyTrend,GapContinuation,MaxMinNotte,MaxMinNotte_DAX_Short_Ottimizzato,EMA200,EMA200_Ottimizzato,SupertrendReversal,SupertrendReversal_Ottimizzato,SuperWave,SuperWave_DOW_H1_Ottimizzato,SupRev_DAX_H4_Ottimizzato,SupRev_NAS_H1_Ottimizzato}.mq5` ·
`mql5/Presets/ABTG_GatedShort_NASUSD_770250_LIVE.set` · `mql5/Presets/conto_reale/{ABTG_ORB_Ottimizzato_770611_REALE,ABTG_DAX_Apertura_EU_770101_REALE}.set` · `mql5/Presets/ABTG_ORB_US.set` (770601) · `mql5/Presets/sedie_piccolo/recupero2/sedia_ABTG_ORB_Ottimizzato_770611.set`
