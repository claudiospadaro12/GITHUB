# ⚖️ R132 — IL PAVIMENTO DELLO STOP SULLA SUPREV: **SALVA O UCCIDE?**

**Criteri congelati PRIMA dei numeri. Scritti l'11/09/2026.**
Nasce da `report/NOVE_SECONDI_2026-09-11.md`: `STREV NAS H1 S 1/3` aperta alle
09:00:00 e chiusa alle 09:00:09 per `sl`, **−12,80 punti indice**.

> 🚫 **PERIMETRO.** Qui si PREPARA e si MISURA. Nessun EA toccato, nessun preset,
> nessuna sedia sfiorata, nessun backtest eseguito. `970913` (NASUSD H1) e
> `970911` (D30EUR H1) sono **VIVE** sul conto piccolo **50503392**: questo round
> **non le tocca**. Ogni cambio è una firma di Claudio.

---

# 0. 🥇 IL VERDETTO IN QUATTRO RIGHE

1. 🔴 **L'archivio forward NON PUÒ rispondere alla domanda, e il motivo è
   aritmetico, non di campione**: la *classe di misura* dello stop coincide con
   l'*esito*. Ogni stop che so leggere **esatto** viene da un trade chiuso in
   `tp` (quindi **vincente per costruzione**); ogni stop che so leggere come
   **minimo** viene da un trade chiuso in `sl` in perdita (**perdente per
   costruzione**). Dire "le operazioni a stop stretto hanno perso tutte" su
   questi dati **è un artefatto**, non una misura.
2. 🔧 **La diagnosi del meccanismo va CORRETTA, e in meglio**: lo stop **iniziale
   NON è sulla linea**, è sull'**estremo a 5 barre** (il `MathMin` di r.248 è
   *degenere*). È il **TRAILING** che, **al primo tick dopo l'ingresso**, lo
   **stringe** dall'estremo alla linea. 👉 **I nove secondi sono colpa di
   `InpTrailOnST`, non di r.248** — e questo sposta quali manopole contano.
3. ⚠️ **Conseguenza che vale un round**: le manopole che allargano lo stop
   *iniziale* (`InpSLBufferPips` di **R127a**, `InpSLLookback` di **R127b**)
   sono **candidate a essere INERTI** su questa geometria, perché il trailing le
   sovrascrive. Predizione falsificabile, scritta prima.
4. ✅ **E il pavimento vero è GIÀ STATO MISURATO in casa, su un'altra famiglia**:
   **R118** (07/09) — *"allargare lo stop compra rischio in modo riproducibile e
   paga in edge in modo non riproducibile"*, **zero celle promosse**.

---

# 1. 🧪 IL CONTRO-ESEMPIO, COSTRUITO **PRIMA** DEI NUMERI

Come chiede la regola del 10/09: prima si scrive cosa vedrei nei due mondi, poi
si guardano i dati. Se le due tabelle predicono **la stessa cosa**, la misura non
misura niente.

### 🟢 TABELLA A — *"se il pavimento fosse SEMPRE un bene"*

| dove | cosa dovrei vedere |
|---|---|
| forward, gambe sotto il pavimento | **perdenti in netta maggioranza**, e **non solo** fra quelle chiuse in `sl` |
| forward, gambe vincenti a stop noto | **nessuna** sotto il pavimento duro |
| R123D (`InpNearAtr` basso = solo la banda stretta) | **PF < 1,00 in entrambe le finestre** |
| R118 (pavimento vero, altra famiglia) | PF **sale** quando il pavimento morde |
| `InpTrailOnST=false` (stop lasciato sull'estremo) | PF ≥ della cella viva **e** DD ≤ |

### 🔴 TABELLA B — *"se il pavimento fosse SEMPRE un male"*

| dove | cosa dovrei vedere |
|---|---|
| forward, gambe sotto il pavimento | **vincenti in maggioranza** (la tesi dell'EA: vicino alla linea = setup migliore) |
| forward, gambe vincenti a stop noto | **concentrate** sotto il pavimento |
| R123D (`InpNearAtr` basso) | **PF più alto** della cella viva |
| R118 | PF **scende** quando il pavimento morde |
| `InpTrailOnST=false` | PF **crolla** (lo stop largo mangia il payoff) |

### 🔴 E IL DIFETTO CHE ROMPE LA MISURA, dichiarato prima di usarla

`InpNearAtr` **cambia due cose insieme**: alzarlo allarga lo stop **e** rende il
setup meno selettivo. **Se una cella migliora, da quale dei due viene NON è
distinguibile.** Questa frase resta nel referto finale, qualunque numero esca.
👉 L'unico esperimento che separerebbe i due effetti è **allargare lo stop a
ingressi identici** (`n` costante) = **R127a** — che però è proprio quello che il
punto 3 del verdetto sospetta essere **inerte**. **Il cerchio non si chiude senza
toccare il codice**, e va detto.

---

# 2. 🔬 IL MECCANISMO, LETTO NEL SORGENTE — con la correzione

`mql5/Experts/ABTG_SupRev_NAS_H1_Ottimizzato.mq5`

### 2.1 Lo stop **iniziale** non è sulla linea: il `MathMin` è degenere

```
r.248  double sl = isLong ? MathMin(stLine,ext)-buf : MathMax(stLine,ext)+buf;
```
`ext` = estremo delle ultime `InpSLLookback`(=5) barre; `stLine` = `line[1]`.
Dimostrazione **dalle sole condizioni d'ingresso dello stesso file** (long):

| passo | riga | conseguenza |
|---|---|---|
| `touch = (lo2 <= stTouch)` | r.205 | il minimo della barra **2** sta **sotto** `line[2]` |
| `ext` = minimo delle barre **1..5** (contiene la 2) | r.245-246 | `ext <= lo2 <= line[2]` |
| entrata solo se `dir[1]==dir[2]` | r.191 | in trend su la banda inferiore non scende: `line[1] >= line[2]` |

👉 **`MathMin(line[1], ext) = ext` SEMPRE.** `[MISURATO]` (deduzione chiusa sul
codice). Simmetrico per lo short.

### 2.2 …ma il **TRAILING** lo riporta sulla linea **al primo tick**

```
r.348-349 (dentro ManageAll(), chiamata a OGNI tick da OnTick, r.155)
  long : if(isLong && stLine>slNow && stLine<bid)  PositionModify(tk,stLine,...)
  short: if(!isLong && (stLine<slNow||slNow==0) && stLine>ask) PositionModify(...)
```
Con `slNow = ext ∓ buf` e `ext` **oltre** la linea, la prima condizione è **già
vera al primo tick**. 👉 **Il trailing non "segue" il prezzo: la prima cosa che fa
è STRINGERE lo stop dall'estremo alla linea.**

### 2.3 🧪 IL CONTRO-ESEMPIO — e **passa**

**Ipotesi alternativa**: *"lo stop resta sull'estremo a 5 barre"*.
**Sua predizione**: due posizioni aperte a 5 ore di distanza guardano finestre di
5 barre **disgiunte**, quindi devono morire a **prezzi diversi**.

| pid | magic | ingresso (server) | prezzo di chiusura |
|---|---|---|---|
| 3113664 | 970916 U30USD | 2026.08.10 **16:00** | **53867.60** |
| 3115526 | 970916 U30USD | 2026.08.10 **21:00** | **53867.60** |

`[MISURATO]` `data/statements/trades_auto.csv`. **Stesso prezzo al centesimo, da
finestre di 5 barre disgiunte.** L'alternativa lo spiega solo con una coincidenza
al centesimo; il trailing lo spiega **necessariamente**, perché `ManageAll()`
porta **tutte** le posizioni del magic allo **stesso** `stLine`.
**Stessa firma su XAUUSD**: cinque gambe aperte fra il 30 e il 31/07 chiudono
**tutte a 4111.19** (pid 2946915 · 2946917 · 2957060 · 2957063 · 2958388).

### 2.4 ✅ E l'unità di misura del buffer è confermata dai dati, non assunta

`InpPendingPips=20` e `InpSLBufferPips=3` sono in "pip" = `_Point` sugli indici a
2 cifre → **0,20** e **0,03 punti indice**. Controprova sul forward: la gamba
`1/3` e la gamba `2/3` dello stesso segnale distano **esattamente 0,20** su
**tre simboli diversi** `[MISURATO]`:

| simbolo | 1/3 | 2/3 | Δ |
|---|---|---|---|
| U30USD | 52351.50 | 52351.70 | **0,20** |
| D30EUR | 25387.10 | 25387.30 | **0,20** |
| F40EUR | 8478.00 | 8478.20 | **0,20** |

👉 Il buffer dello stop vale **0,03 punti indice**: **non esiste nessun pavimento
in questo EA**, e adesso è un conto, non un'impressione.

---

# 3. 🔢 PASSO 1 — IL DANNO STORICO, CONTATO

**Perimetro elencato per nome** (mai "tutto ciò che non è X"): tutte le righe di
`data/statements/trades_auto.csv` e `data/statements/trades_100k.csv` la cui
colonna `strategy` contiene `STREV`/`SupRev`.
**Fonti dei pavimenti**: `backtest_pipeline/risultati_archivio/spread_flotta/
spread_orario_{NASUSD,U30USD,D30EUR}.csv`, **spread mediano dell'ORA SERVER di
ingresso**. Duro = **13,3×**, di lavoro = **40×**.

| | |
|---|---:|
| righe grezze | **32** |
| **segnali distinti** (deduplicati: lo stesso segnale gira su più magic/conti) | **26** |
| duplicati rimossi | 6 |

### 3.1 Le tre classi di misura — **ed è qui che casca il round**

| classe | come si ricava | n | 🔴 esito **forzato** |
|---|---|---:|---|
| **ESATTO** | chiusura `tp` → stop = \|close−open\| / `InpTP_RR` | **6** | **tutti VINCENTI** |
| **MINIMO** | chiusura `sl` in perdita → stop **≥** \|close−open\| | **15** | **tutti PERDENTI** |
| **NON MISURABILE** | `sl` a pari o in utile (breakeven / trailing) | **5** | misto |

> ## 🔴 **LA CLASSE PREDICE L'ESITO AL 100%. Qualunque incrocio "stop stretto vs P/L" su questi dati misura la classe, non lo stop.**
> È esattamente il difetto del 10/09: controllare che la risposta sia *coerente*
> con l'attesa invece di provare a **romperla**. Qui ho provato a romperla, e
> **si rompe**.

### 3.2 I conteggi, dati lo stesso — **con l'etichetta dell'artefatto addosso**

Pavimento calcolabile solo dove lo spread è misurato (**NASUSD · U30USD ·
D30EUR**): **13 gambe su 26**.

| fascia | n | somma P/L netto | vinte | perse |
|---|---:|---:|---:|---:|
| **sotto il pavimento DURO (13,3×)** | **3** | **−11,43 €** | **0** | **3** |
| sotto il pavimento DI LAVORO (40×) *(include le 3 sopra)* | 6 | **+80,47 €** | 2 | 4 |
| sopra il 40× | 7 | +27,77 € | 2 | 5 |
| stop leggibile ma **spread NON MISURATO** (XAUUSD · F40EUR · 225JPY) | 8 | −308,40 € | 2 | 6 |
| **stop NON MISURABILE** (BE / trailing) | 5 | +117,79 € | 3 | 1 (+1 a pari) |

**Le tre gambe sotto il pavimento duro, per nome:**

| pid | simbolo | ora server | stop | ×spread | netto |
|---|---|---:|---:|---:|---:|
| 2910100 | U30USD | 08 | 12,70 | **4,9×** | −1,12 € |
| **3361860** | **NASUSD** | **09** | **12,80** | **4,9×** | **−6,62 €** ← i nove secondi |
| 2967537 | NASUSD | 18 | 9,70 | **5,7×** | −3,69 € |

### 3.3 🎯 L'UNICO FATTO **NON CIRCOLARE** che esce dall'archivio

Fra i **4 vincitori con stop ESATTO e spread misurato**, il più stretto è
**24,6× lo spread** (64,00 punti, U30USD h11). Gli altri: 42,4× e 100,8×.
👉 **Nessun vincitore a stop noto sta sotto il pavimento duro.**

🔴 **MA NON È DIMOSTRATO CHE NON NE ESISTANO**: le **5 gambe NON MISURABILI** (di
cui **3 in utile**, +11,57 · +22,24 · +84,96 €) hanno lo stop iniziale
**illeggibile**, e un vincitore a stop strettissimo può nascondersi **lì dentro**.
**Il conteggio vale sulle perdenti: è un LIMITE DICHIARATO, non un risultato.**

### 3.4 📉 UN NUMERO NUOVO che nasce dai nove secondi

`report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` (riga 407) dà a `970913`
**51,65 punti** di stop mediano su **n=4** gambe. Con la gamba di oggi:

| | gambe in stop (perdenti) | mediana | ×spread ora 15 (1,80) | pavimento duro |
|---|---|---:|---:|---|
| 10/09 (n=4) | 9,70 · 27,10 · 76,20 · 151,90 | **51,65** | **28,7×** | 🟢 sopra 13,3× |
| **oggi (n=5)** | + **12,80** | **27,10** | **15,1×** | 🟡 **sopra per 1,8×** |

👉 **Una sola gamba ha quasi dimezzato la mediana della sedia.** `[MISURATO]`
Il rapporto resta sopra il pavimento **duro**, ma il margine è passato da
**+116%** a **+13%**. ⚠️ E la mediana **realizzata** non è lo stop **iniziale**:
il §2.2 spiega perché queste gambe corte sono stop **trascinati sulla linea** —
la stessa riserva che il referto del 10/09 dichiarava già al §2.3.

---

# 4. 🏺 PASSO 2 — È GIÀ STATO MISURATO? **Lo scavo in casa**

Censimento **11/09/2026** su **tutti** i CSV del repo con colonne `Inp*`.

| manopola | file con **>1 valore** | valore unico | file prova che la mette ad asse |
|---|---:|---|---|
| **`InpNearAtr`** | **2** | 1,0 ovunque **tranne** R123D | `R123d_U30USD_03_nearatr.txt` ✅ **girato** |
| `InpSLBufferPips` | **0** | **3** in 280 CSV | `R127a_slbuffer_NASUSD.txt` 🔴 **mai girato** |
| `InpSLLookback` | **0** | **5** in 290 CSV | `R127b_sllookback_XAUUSD.txt` 🔴 **mai girato** |
| `InpTrailOnST` | **0** | true | `R120a/b/c/d_*` 🔴 **mai girati** |
| `InpExitOnFlip` | **0** | true | `R120a/b/c/d_*` 🔴 **mai girati** |
| `InpFirstFraction` | **0** | 0,3333 | `R124a_U30USD_04_firstfraction.txt` 🔴 mai girato |
| `InpPendingPips` · `InpConflAtr` · `InpUseConfluence` | **0** | — | **nessuno** |
| `InpUseTimeWindow` / `InpStartHour` / `InpEndHour` | **0** | false / 0 / 24 | **nessuno** |

### 4.1 🟢 L'UNICA CORSA ESISTENTE — R123D, U30USD H1, tick reali, 09/09/2026

`backtest_pipeline/risultati_prove/r123_dal_vps/ABTG_SupRev_DOW_H1_Ottimizzato_U30USD_{IS,OOS}_R123DNEARATR.csv`

| `InpNearAtr` | IS: n / PF | OOS: n / PF |
|---:|---|---|
| **0,50** | 64 / **0,63495** | 122 / **0,99155** |
| 0,75 | 99 / 0,76952 | 133 / 1,28433 |
| **1,00** *(cella viva)* | 117 / 0,98837 | 152 / **1,38944** |
| 1,25 | 122 / 1,00474 | 172 / 1,32197 |
| 1,50 | 128 / 0,86503 | 172 / **1,32197** ← **clone di 1,25** |

> ## 🎯 **Sul Dow la banda STRETTA, presa da sola, PERDE in tutte e due le finestre.**
> `InpNearAtr=0,50` tiene **solo** i setup più vicini alla linea — cioè **solo**
> quelli a stop stretto — e fa **PF 0,635 (IS)** e **0,992 (OOS)**.
> 👉 **La tesi dell'EA (*"vicino alla linea = setup migliore"*) è FALSIFICATA sul
> Dow**: la cella più selettiva è la **peggiore**, non la migliore.
> Questo è il segnale della **TABELLA A** (il pavimento salva). `[MISURATO]`

⚠️ **Ma il merito è SOSPESO**: n = 64 e n = 122, sotto il pavimento dei 150
(Emendamento A). Vale come **pendenza della superficie**, non come certificato.
⚠️ E **l'asse SATURA**: in OOS 1,25 e 1,50 sono **identici cifra per cifra** →
**manopola INERTE sopra 1,25, MISURATA**. `[MISURATO]`
⚠️ E **su NASUSD non è mai stata provata**: zero volte, su ogni TF.

### 4.2 🔴 IL PUNTO STRUTTURALE — **`InpNearAtr` è un MASSIMO, non un minimo**

```
r.206  up  : closeNear = (cl2 > stTouch) && ((cl2 - stTouch) <= InpNearAtr*atr)
r.213  down: closeNear = (cl2 < stTouch) && ((stTouch - cl2) <= InpNearAtr*atr)
```
Abbassarlo **tiene solo** le operazioni a stop stretto. Alzarlo **aggiunge**
quelle larghe. Un **pavimento** fa il contrario: **toglie** le strette e **tiene**
le larghe.

> ## 🔴 **L'insieme complementare NON È RAGGIUNGIBILE con NESSUN input esistente di questo EA.** Verificato input per input sul sorgente.
> 👉 `InpNearAtr` **misura il valore della banda che il pavimento cancellerebbe**
> (leggendola **isolata**, senza nessuna ipotesi di annidamento) — ma **non può
> simulare il pavimento**. Per quello serve `InpMinStopPts`/`InpSkipIfTight`:
> **è una MODIFICA DI CODICE, non un round.** Vedi §6.

### 4.3 🏆 E IL PAVIMENTO VERO **È GIÀ STATO MISURATO** — R118, 07/09/2026

`backtest_pipeline/risultati_archivio/REFERTO_R118_PAVIMENTO_STOP.md` — famiglia
**Aperture** (D30EUR/U30USD), che `InpMinStopPts` + `InpSkipIfTight` **ce li ha**.

| risultato R118 | numero |
|---|---|
| celle **promosse** | 🔴 **ZERO su 170 passate** |
| **DD** scende allargando lo stop | **46/58 IS · 51/56 OOS** — le due finestre **concordano** |
| **PF** scende allargando lo stop | 53/58 IS · **29/56 OOS** — 🔴 **una monetina** |
| pavimento a **20 punti indice** | **no-op esatto**: 20 celle su 20 identiche cifra per cifra |
| Δn a pavimento 4000/6000/8000 | −4,9% / −23,1% / −43,1% |

> ## 💡 **"Allargare lo stop compra RISCHIO in modo riproducibile e paga in EDGE in modo NON riproducibile."**
> È la tesi di R55, misurata su **tre geometrie**. 👉 **L'attesa onesta per R132
> è questa**: *né salva né uccide il merito — compra rischio.*

---

# 5. 📐 PASSO 3 — IL ROUND **R132**, COME È FATTO

> **La domanda:** *"Le operazioni con lo stop più stretto — quelle che un
> pavimento toglierebbe — guadagnavano o perdevano?"*
> **Non** *"quale valore di `InpNearAtr` fa il PF più alto"*: quella è la domanda
> che produce picchi di rumore (regola del 19/08).

### 5.1 L'asse scelto, e perché

**`InpNearAtr`**, e **solo** quello. Motivi, in ordine:
1. è **l'unica manopola che già esiste** e che sposta la distanza fra ingresso e
   **linea** — cioè la larghezza dello stop **effettivo** dopo il trailing (§2.2);
2. è **vergine su NASUSD** e ha **una sola corsa in tutto il repo** (R123D);
3. legge **isolata** la banda che il pavimento cancellerebbe (§4.2);
4. le alternative (`InpSLBufferPips`, `InpSLLookback`) **hanno già il loro file**
   (R127a/b) **e sono sospettate di inerzia** per il §2.2: metterle qui
   duplicherebbe un round e misurerebbe forse niente.

🔴 **`InpMinStopPts` NON è proponibile come round**: **non esiste in questo EA**.
Proporlo significa **scrivere codice** su un EA con **due sedie vive**. È un
lavoro **successivo**, e le sue condizioni stanno al §6.

### 5.2 I tre file — **già passati dai cancelli**

| file | EA | simbolo | ancora (cella viva, tick reali) | ruolo |
|---|---|---|---|---|
| `R132c_nearatr_U30USD.txt` | `SupRev_DOW_H1_Ott` | **U30USD** H1 | **riproduzione R123D cifra per cifra** | 🚦 **BANCO — si lancia per PRIMO** |
| `R132a_nearatr_NASUSD.txt` | `SupRev_NAS_H1_Ott` | **NASUSD** H1 | IS 1,34237 / n 69 · OOS 1,68815 / n 86 | la sedia dei nove secondi |
| `R132b_nearatr_D30EUR.txt` | `SupRev_DAX_H1_Ott` | **D30EUR** H1 | IS 0,72984 / n 67 · OOS **1,86556 / n 156** | **l'unica che può dare MERITO** |

**Asse identico sui tre**: `InpNearAtr = 0,25 … 2,00` passo **0,25** = **8 celle**.
La cella viva **1,00** cade all'**indice 3**: non è un bordo, ha vicini da tutte e
due le parti. `0,25` e `2,00` sono esatti in binario e `(2,00−0,25)/0,25 = 7`
senza residuo → **8 celle, nessun arrotondamento possibile**.
Magic **vergini**: `779440` · `779450` · `779460` (zero occorrenze nel repo).

### 5.3 🚦 IL CANCELLO CHE COSTA MENO DI TUTTI — e va per primo

R123D è girata il **09/09/2026 20:19**; l'ultimo commit sull'EA è **872dba8,
08/09/2026 07:13**. 👉 **Fra la corsa e oggi non c'è nessun cambio di codice**:
le **5 celle in comune devono tornare IDENTICHE, cifra per cifra**.
Che il **magic** diverso non sposti i numeri è **MISURATO** (G1 passato **949/949**
su celle gemelle, `report/MANOPOLE_INERTI_2026-09-09.md` r.40) — per questo **non
serve** un asse tecnico gemello.

> 🔴 **Se le 5 celle non riproducono, R132 è NULLO e gli altri due file NON si
> lanciano.** Costo del cancello: **16 passate**. E se non tornano, la prima cosa
> da guardare è **`n`**, non il PF: `n` diverso = dati o binario diversi; PF
> diverso a `n` uguale = sizing diverso, ed è un'altra diagnosi.

### 5.4 📋 L'ATTESA, DICHIARATA PRIMA DEI NUMERI

| grandezza | attesa | cosa la smentirebbe |
|---|---|---|
| **`n`** | **in salita monotona** con `InpNearAtr` | se **non sale**, il pin non è arrivato all'EA → **round NULLO** |
| **saturazione** | `1,75` e `2,00` **cloni** di `1,50` | se mordono, l'asse è più vivo del previsto (risultato, non fallimento) |
| **PF banda stretta** (0,25 · 0,50) | **sotto la cella viva**, replica di U30USD | se `PF(0,25) > PF(viva)+0,15` → **il pavimento UCCIDE**, e il tema esce dal tavolo |
| **DD** | NASUSD 0,5-3% · D30EUR 3-9% · U30USD 4,5-7,5% | sopra soglia = **fatto di RISCHIO a qualunque n** (Emendamento B) |
| **asimmetria attesa** | **DD giù riproducibile, PF come una monetina** (R118) | se il PF si muove **in modo concorde** su tre simboli, R118 non generalizza |

🔴 **E IL LIMITE PIÙ DURO, SCRITTO ORA**: su **NASUSD** e in **IS su tutti e tre**,
il **pavimento dei 150 NON si raggiunge** (la cella viva NASUSD fa n OOS = **86**).
👉 **Da R132a e dagli IS non esce nessun certificato di MERITO.** Esce una
**pendenza** (una pendenza non ha bisogno di 150 operazioni per essere una
pendenza) e un **fatto di rischio**. **Solo `R132b` in OOS (n 156) può parlare di
merito.** Chi leggesse R132 come una promozione lo starebbe leggendo male.

### 5.5 🚧 LE SOGLIE CONGELATE (scritte per esteso in ogni file prova)

| | |
|---|---|
| **B1** | **ANCORA** — su `R132c` è **BLOCCANTE** (riproduzione cifra per cifra); su `a`/`b` no, ma se salta va dichiarato **per primo** |
| **B2** | **MONOTONIA DI `n`** — se `n` non sale, **round NULLO** |
| **B3** | **ANTI-CLONE** — due celle contigue con `n` e PF identici alla 4ª cifra sono **una** cella misurata due volte |
| **B4** | **LA RISPOSTA**: `PF(0,25)` e `PF(0,50)` **entrambi < 1,00** → *"la banda stretta perde, un pavimento SALVA"* · una delle due **> PF(viva)+0,15** → *"un pavimento UCCIDE"* · **tutto il resto** → *"non c'è una risposta robusta"*, e si scrive così |
| **B5** | **RISCHIO** a qualunque `n` |
| **B6** | **SELEZIONE**: centro dell'altopiano, **mai il picco** |
| **B7** | **NESSUNA PROMOZIONE**: `970913` e `970911` sono vive, il round non le tocca |
| **B8** *(solo `R132b`)* | **MERITO**: PF IS > 1,00 **e** PF OOS ≥ 1,20 **e** `n` ≥ 150 in **entrambe** le finestre |

### 5.6 💰 IL COSTO IN TEMPO MACCHINA

| | |
|---|---:|
| celle | 24 (3 file × 8) |
| **passate** | **48** (24 × 2 finestre) |
| calibrazione `[MISURATA]` | `r88_csv/REFERTO_R88.txt`: 136 passate in **13,7 min** = **0,101 min/passata** → **4,8 min** |
| avvio MT5 per file | ~0,5 min × 3 = **1,5 min** |
| **stima congelata** | **🟢 6-20 minuti** |

⚠️ `[STIMA per analogia — NON misurata su questa famiglia]`: R88 era **M5 su
D30EUR**, qui è **H1 su indici** a tick reali su 21 mesi. La banda è larga apposta.
👉 **Il primo file costa 16 passate (~2 min): se il banco è sporco, si spendono due
minuti invece di venti.**

---

# 6. 🔧 E SE SERVISSE IL PAVIMENTO VERO — **cosa sarebbe, e cosa costa**

`InpMinStopPts` + `InpSkipIfTight` **non esistono** nella SupRev (grep degli input
su tutti e 6 gli EA della famiglia: zero occorrenze). Portarceli è **codice su un
EA con due sedie vive**. 🔴 **Non è un round e non si propone qui.** Se mai si
farà, le condizioni misurate oggi dicono che:

1. andrebbe messo **dopo il trailing**, non prima: il §2.2 mostra che il trailing
   **stringe** lo stop — un pavimento applicato solo all'ingresso sarebbe
   **inerte per costruzione**, esattamente come si sospetta di `InpSLBufferPips`;
2. il valore da provare **non è 20 punti**: R118 ha misurato che a 20 il pavimento
   è un **no-op esatto** (20/20 celle identiche). Sulla NASUSD il pavimento duro è
   **34,6** e quello di lavoro **104,0** punti (ora 9);
3. 🟢 **esiste già un'approssimazione GRATIS del pavimento**, e nessuno l'ha mai
   girata: **`InpTrailOnST=false`** lascia lo stop sull'**estremo a 5 barre**, che
   è **sempre più largo della linea** (§2.1). È **R120a**, preparato il 09/09 e
   **mai lanciato**. ⚠️ Ma spegne anche la protezione sui vincitori: R120 ha
   misurato su un'altra famiglia che togliere il trailing porta il **DD da 6,03%
   a 22,21%**. **Due effetti insieme, di nuovo** — va dichiarato.

---

# 7. 🕳️ I BUCHI, DICHIARATI

1. 🔴 **L'archivio forward non risponde alla domanda** (§3.1). n=26 segnali, e la
   classe di misura predice l'esito.
2. 🔴 **Lo stop iniziale dei trade VINCENTI chiusi in BE/trailing è illeggibile**:
   5 segnali, 3 in utile. Un vincitore a stop strettissimo può stare lì.
3. 🔴 **Spread NON MISURATO** su **XAUUSD · F40EUR · 225JPY**: 8 gambe su 26 non
   hanno un pavimento calcolabile. `spread_flotta` copre solo 3 simboli.
4. 🔴 **I due effetti di `InpNearAtr` non sono separabili** (§1). Resta nel referto
   finale qualunque numero esca.
5. 🔴 **Un solo REGIME**: 21 mesi di tick BCM sugli indici = toro. Emendamento
   della Finestra regola **C: NON soddisfatta**, e non lo sarà a fine round.
6. 🔴 **Storico lungo NON UTILIZZABILE**: NASUSD ha 5.261.984 barre M1 dal 2010,
   ma il **cancello ZERO è chiuso** (diff media H1 0,061-0,101% contro ≤0,05%).
   Sul DAX è addirittura **inapplicabile** (zero giorni di sovrapposizione).
7. 🟡 **Lato short da solo**: `[NON MISURATO]`. Qui girano L+S come le sedie vive;
   la regola dei due lati del 25/08 chiede il lato separato → è un round suo
   (**R110**, preparato).
8. 🟡 **Peggior giornata**: `[NON MISURATO]` e **non producibile** — il CSV di
   ottimizzazione MT5 non ha la colonna, e la SupRev non esporta il per-trade nei
   round (verificato: nessun `abtg_trades_*SupRev*` nel repo).
9. 🟡 **Il costo in tempo macchina è una stima per analogia**, non un cronometro
   su questa famiglia.

---

# 8. ✅ ESITO DEI CANCELLI (11/09/2026)

| cancello | esito |
|---|---|
| `controlla_prova.py` sui 3 file | 🟢 **OK** — 3 file, 24 celle, **48 passate**, **0 problemi** |
| `controlla_riga.py --oggetto prova` | 🟢 **nessun difetto meccanico** — 3 file **ASCII puro** |
| agente `controllo-preventivo` (giudizio) | ⏳ **DA FARE prima di mandare qualunque riga al VPS** |

🔴 **Nessuna riga di lancio è stata scritta e nulla è stato eseguito.** Il runner
è in sola lettura e il round **non parte** finché il secondo strato non dà PASS.

---

## 📁 ARTEFATTI

- `backtest_pipeline/prove/R132a_nearatr_NASUSD.txt`
- `backtest_pipeline/prove/R132b_nearatr_D30EUR.txt`
- `backtest_pipeline/prove/R132c_nearatr_U30USD.txt`
- questo referto: `report/R132_PAVIMENTO_SUPREV_2026-09-11.md`
