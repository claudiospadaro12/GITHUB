# 🧬 RELATIVO — DALLA SONDA ALL'EA VERO: **PROPOSTA DEL PRIMO GIRO A TICK REALI**

> ## ⚠️ QUESTO FILE È UNA **PROPOSTA**, NON UNA DECISIONE.
> **Nessun codice è stato scritto. Nessuna riga di lancio è stata preparata.
> Niente è stato compilato, niente è stato girato.**
> I criteri di merito qui sotto sono **proposti**: si congelano quando li firma
> Claudio, e si congelano **PRIMA** dei numeri. Questo è il punto in cui la casa
> si ferma e decide, non il punto in cui si programma.

_04/09/2026 · repo `/home/user/GITHUB`, branch `lavoro`._

> ## 🔄 REVISIONE DEL 04/09 (SERA) — **LA CELLA È CAMBIATA, E IL PERCHÉ È MISURATO**
> La prima stesura di questo documento proponeva **N=35 / σ=1,50** e portava un
> **RILIEVO scritto in chiaro** (§3.4 di allora): *l'altopiano vivo si appoggiava
> al BORDO della griglia su entrambi gli assi, quindi il centro non era
> determinabile*. Claudio ha deciso (**D4**) di **estendere la griglia PRIMA** di
> scrivere l'EA. L'estensione è girata (**90 celle, N 10→55 × σ 0,75→1,95**,
> `RIGA_SONDARELATIVO_ESTESA`) e ha risposto:
>
> | | esito |
> |---|---|
> | **collaudo di riproduzione** (cella N=20/σ=1,05 contro i referti del mattino) | ✅ **PASSATO su entrambe le gambe, 12 grandezze su 12** → le celle nuove si leggono sulla stessa scala delle vecchie |
> | **D30EUR** | **VIVO/VIVO**, 19 blocchi 2×2. L'angolo estremo N=55/σ=1,95 **muore per PORTATA**, come previsto prima della misura |
> | **NASUSD** | **VIVO/VIVO**, 23 blocchi 2×2. L'angolo estremo **non muore**: su questa gamba l'altopiano **tocca ancora il bordo** |
>
> **Claudio ha deciso di FERMARSI QUI** e di scegliere un blocco 2×2 vivo su
> **entrambe** le gambe che **non tocchi nessun bordo**: **N=40-45 × σ=1,35-1,50**.
> Dentro quel blocco, **N=40 / σ=1,35 domina su entrambi i criteri di pareggio
> (più occasioni, C6 più basso) su ENTRAMBE le gambe**. Tutto ciò che qui sotto
> dipende dalla cella è stato **ricalcolato** su di lei (§1.1, §2.4, §3).

**Numero di round proposto: `R117`** — **verificato libero oggi**
(`grep -rno "\bR117\b"` su tutto il repo → **0 occorrenze**; `R116` è l'ultimo
assegnato, LondonFx). ⚠️ **Da ri-verificare il giorno del lancio.**

| voce | valore proposto |
|---|---|
| **EA** | `mql5/Experts/ABTG_Relativo.mq5` — **SCRITTO** il 04/09 (Parte 2). Non compilato in questo ambiente: si compila in MetaEditor |
| **cosa NON si tocca** | `mql5/Experts/ABTG_SondaRelativo.mq5` resta il **contatore puro, invariato, v1.03** |
| **gambe / TF** | **D30EUR · M5** e **NASUSD · M5** — le due che hanno dato **VIVO su entrambi i lati** |
| **metro** | **U30USD** — si legge, non si scambia (T4 della sonda) |
| **cella (entrambe le gambe)** | **`InpFinestraN = 40`, `InpSogliaIngressoSigma = 1.35`**, `InpSogliaUscitaSigma = 0.05` (§3) |
| **modello** | **4 = Ogni tick basato su TICK REALI** — è il punto del round |
| **finestra** | **2024.09.26 → 2026.06.30** = **il pavimento tick reali degli indici BCM**, e **la stessa identica finestra della sonda** (§5.1) |
| **sessione** | **14:30 → 22:00 ORA SERVER, CONGELATA**, fine esclusa (T7 della sonda) |
| **rischio** | **0,65% — la taglia di campo** (stessa ragione di R116 §5.3: il DD si legge contro il muro prop senza scalature) |
| **magic** | blocco **`7746xx`** — **verificato VERGINE oggi** (§4) |
| **dimensione** | **2 celle (una per gamba) + 2 gemelli di determinismo = 4 passate a tick** + **1 passata di collaudo del porto** (§6.2) |

---

## 1. 🎯 LA DOMANDA DEL ROUND, IN UNA RIGA

> **"Lo scarto fra una gamba (D30EUR o NASUSD) e il metro U30USD, quando supera
> 1,50 sigma dentro la sessione americana, rientra abbastanza spesso — e
> abbastanza in fretta — da produrre `E ≥ 0,075R` per operazione a TICK REALI,
> pagando lo spread vero del broker?"**

La sonda ha risposto a **un'altra** domanda, e va detto in cima: ha misurato
**portata, taglia, geometria, convergenza e tenuta**. **Non ha mai emesso un
euro di P/L** — è scritto nel suo stesso sorgente (*"NON esce nessuna colonna di
P/L, Profit Factor o drawdown: senza operazioni sarebbero tutti ZERO, e uno zero
in colonna prima o poi qualcuno lo legge come un risultato"*).

> 🔴 **Quindi questo round è la PRIMA misura di merito del candidato RELATIVO.
> Non è una conferma di niente: è la prima volta che si guarda il conto.**

### 1.1 🔢 IL NUMERO CHE DEVE STARE IN CIMA, PRIMA DI TUTTI GLI ALTRI

Con la geometria proposta al §2.4 (**SL = 2,75 × ATR**, cioè **1R ≈ 47,1 punti
indice su D30EUR** e **≈ 74,2 su NASUSD**), e con i numeri **MISURATI della
cella N=40 / σ=1,35** (letti riga per riga dai referti della griglia estesa):

| voce | **D30EUR** | **NASUSD** | fonte |
|---|---:|---:|---|
| MFE mediana (lato L / S) | **23,50 / 25,50 pti** | **37,20 / 36,85 pti** | [MISURATO] |
| RR da mediane (L / S) | 1,04 / 1,12 | 0,93 / 0,88 | [MISURATO] |
| MAE mediana (= MFE/RR) | **22,60 / 22,77 pti** | **40,00 / 41,88 pti** | [DERIVATO dai referti] |
| ATR mediano di sessione | **17,13 pti** | **26,98 pti** | [MISURATO] |
| **1R proposto** (2,75 × ATR) | **47,1 pti** | **74,2 pti** | [CALCOLO §2.4] |
| **MFE mediana in R** (= TETTO del guadagno) | **0,499 / 0,541 R** | **0,501 / 0,497 R** | [CALCOLO] |
| spread misurato, ora peggiore della finestra | **2,80 pti** | **1,80 pti** | [MISURATO 03/09] |
| **costo dello spread in R** | **0,059 R** | **0,024 R** | [CALCOLO] |
| **costo / cancello H8 (0,075R)** | 🔴 **79%** | 🟢 **32%** | [CALCOLO] |
| slippage 5 punti MT5 = 0,05 pti indice | 0,11% di 1R | 0,07% di 1R | [CALCOLO] — **irrilevante** (§2.9) |
| C6 non convergute (totale) | **19,68 %** | **17,96 %** | [MISURATO] |
| tenuta mediana | **13 barre** | **12 barre** | [MISURATO] |
| max occasioni in un giorno | **10** | **8** | [MISURATO] → §2.6 |

> ### 🔴 **IL WIN RATE CHE SERVE, CALCOLATO PRIMA DI GUARDARE**
> Se il guadagno per vincente fosse **pari alla MFE mediana** (che è un **tetto**:
> l'uscita alla convergenza sta **sotto** il massimo dell'escursione) e la
> perdente pagasse **1R pieno**, il pareggio **al netto dello spread** cade a:
> - **D30EUR: win rate ≥ 68,7% (short) — 70,7% (long)**
> - **NASUSD: win rate ≥ 68,2% (long) — 68,4% (short)**
>
> **[INFERITO, non misurato]** Il tasso di convergenza misurato su questa cella è
> **80,3%** (D30) e **82,0%** (NAS): il margine c'è, **ma solo se quasi ogni
> convergenza è un profitto e se il realizzato è vicino alla MFE mediana**. Sono
> **due cose che il passo 0 non ha mai misurato**, ed è esattamente ciò che
> questo round va a vedere.
>
> ⚠️ Il limite di questo calcolo, dichiarato: le **non convergute** (18-20%)
> **non perdono automaticamente 1R** — escono al flat di sessione e possono
> chiudere in guadagno. È una **forchetta severa**, non una previsione di
> perdita.
>
> 📌 **Rispetto alla cella vecchia (N=35/σ=1,50) quasi niente si muove**, ed è
> di per sé un piccolo segno di robustezza dell'altopiano: occasioni **3,376 vs
> 3,433** su D30 e **3,564 vs 3,631** su NAS (praticamente pari), C6 **un po'
> peggiore** (19,68 vs 17,83 su D30; 17,96 vs 16,28 su NAS), MFE **un po' più
> grande** (23,50 vs 22,40 su D30), tenuta identica.
> **Nessun numero si è mosso abbastanza da cambiare una conclusione.**

### 1.2 🔮 LA PREVISIONE DICHIARATA **PRIMA** (falsificabile)

1. **NASUSD ha molte più probabilità di sopravvivere di D30EUR.** Non è
   un'impressione: lo spread di NASUSD mangia **un terzo** del cancello, quello
   di D30EUR ne mangia **quattro quinti**. E il DAX, dalle 17 server in poi, è
   **fuori dal suo cash** — cioè per **due terzi della nostra sessione**.
2. **Il numero che decide il round è "guadagno realizzato per vincente / MFE
   mediana".** Se scende sotto ~0,7, la geometria non regge il costo su nessuna
   delle due gambe. **È una colonna obbligatoria** (§6.3).
3. **Se il round muore, muore sul COSTO, non sul segnale** — e sarà un verdetto
   pieno e utile, non un fallimento del banco.

---

## 2. 🏗️ L'EA PROPOSTO — `ABTG_Relativo.mq5`

### 2.1 🧊 IL NUCLEO NON SI RISCRIVE: SI **COPIA**

Il motore statistico della sonda è già stato scritto, collaudato con **25
blocchi di autotest a tavolino** e girato su **4 finestre × 49 celle**. Le
funzioni del **nucleo puro** (`SmaFin_Calc`, `StdevFin_Calc`, `MedianaFin_Calc`,
`MadFin_Calc`, `ZDueBarre_Calc`, **`Attraversamento_Calc`**,
**`Convergenza_Calc`**, `InFinestra_Calc`, `AllineaSerie_Calc`) si **trasportano
riga per riga**, insieme all'**autotest**.

> 🔒 **Regola congelata: il nucleo dell'EA deve essere IDENTICO a quello della
> sonda.** Se cambia una riga del calcolo di z, i numeri del passo 0 non
> descrivono più il motore che gira, e la scelta della cella (§3) perde la sua
> giustificazione. **Il collaudo del §6.2 è ciò che lo dimostra a macchina,
> invece di dichiararlo.**

**Il verso dell'ingresso, letto nel sorgente (non assunto)** —
`Attraversamento_Calc`, righe 895-901 di `ABTG_SondaRelativo.mq5`:

```
lato +1 (LONG)  : zPrec >= -soglia  AND  z <  -soglia
lato -1 (SHORT) : zPrec <= +soglia  AND  z >  +soglia
```

→ **z molto NEGATIVO = gamba a sconto sul metro = LONG gamba.**
→ **z molto POSITIVO = gamba cara sul metro = SHORT gamba.**
E l'uscita, `Convergenza_Calc` (righe 911-916): **long chiude a `z ≥ -0,05`,
short a `z ≤ +0,05`**. ✅ Confermato: è il verso descritto nel mandato.

### 2.2 🚪 INGRESSO: **A MERCATO, SULL'APERTURA DELLA BARRA SUCCESSIVA**

**Raccomandato: a mercato. Non pendente.** Tre ragioni, in ordine di peso:

1. 🥇 **È l'unica costruzione che riproduce ciò che è stato misurato.** La sonda
   (T10, T7-v1.03) apre alla **apertura della barra 0 REALE** successiva alla
   barra di segnale. Un ordine a mercato all'evento "nuova barra" è la
   traduzione fedele. Qualunque altra cosa misura **un altro motore**.
2. 🥈 **Un pendente introduce una SELEZIONE.** Un limit sotto/sopra il prezzo si
   riempie **solo** quando il prezzo torna indietro: cambierebbe la popolazione
   dei trade in modo correlato all'esito (i trade che partono subito a favore —
   proprio quelli buoni per un motore di convergenza — non verrebbero mai
   presi). È un motore diverso, e andrebbe misurato come tale in un round suo.
3. 🥉 **Lo z si calcola su barra CHIUSA**: l'istante di decisione è la chiusura
   della barra, cioè l'apertura della successiva. Non c'è nessun prezzo
   "migliore" da aspettare che non sia un'ipotesi nostra.

> ### ⚠️ IL RILIEVO CHE VA SCRITTO, NON NASCOSTO
> **La sonda entra al prezzo di APERTURA esatto. L'EA entrerà al PRIMO TICK
> dopo l'apertura.** Non sono la stessa cosa, e la differenza non è stimabile a
> tavolino. Diventa una **colonna obbligatoria**: `Scarto Ingresso vs Apertura
> (punti, mediana e P95)`. Se la mediana supera **~0,3 punti indice** (≈ 10%
> dello spread D30), il confronto sonda↔EA va riletto con quel numero in mano.

### 2.3 🎯 USCITA PRIMARIA: **LA CONVERGENZA, COME MISURATA**

`|z| ≤ InpSogliaUscitaSigma = 0.05`, valutata **a barra chiusa**, chiusura
**a mercato sull'apertura della barra successiva** (identico alla sonda).
`InpSogliaUscitaSigma` **non è una manopola**: è la definizione operativa di C6,
il cancello che ha tenuto in vita la tesi. **Congelata a 0,05, fuori da ogni
asse.**

**Precedenza delle uscite, identica alla sonda** (righe 2090-2097):
`convergenza` → `flat di fine sessione` → `tetto di tenuta`. In più, **prima di
tutte**, lo stop reale del §2.4, che nella sonda non esisteva.

### 2.4 🛡️ LO **STOP DI SICUREZZA REALE** — obbligatorio, e da dove esce il numero

**Perché è obbligatorio e non opzionale:** la sonda non ne aveva bisogno perché
non apriva niente. Un EA vero senza SL **broker-side** è una posizione nuda
davanti a una disconnessione, a un gap e a un evento macro. **Non si discute.**

**La derivazione, da C4 (MAE mediana = il "pavimento SL" stampato nei referti),
sulla cella N=40 / σ=1,35:**

| passo | D30EUR (L / S) | NASUSD (L / S) |
|---|---:|---:|
| MAE mediana alla cella scelta | 22,60 / 22,77 pti | 40,00 / 41,88 pti |
| ATR mediano di sessione | 17,13 pti | 26,98 pti |
| **MAE mediana in ATR** | **1,32 / 1,33** | **1,48 / 1,55** |
| **× 2 (il margine, sotto)** | **2,64 / 2,66 ATR** | **2,97 / 3,10 ATR** |
| **valore proposto, UNICO per le due gambe** | **2,75 × ATR** | **2,75 × ATR** |
| in punti indice (all'ATR mediano) | **47,1 pti** | **74,2 pti** |

**Perché il fattore 2:** la MAE **mediana** è, per definizione, il livello che
**metà** dei trade supera. Uno stop lì ucciderebbe metà delle convergenze prima
che convergano — cioè misurerebbe **lo stop**, non il motore. Il **doppio della
mediana** lascia passare la larghissima maggioranza delle escursioni avverse
tipiche e taglia solo la coda.

> ### 🔒 **PERCHÉ 2,75 E NON IL CENTRO DEL NUOVO INTERVALLO (2,87)**
> Perché **2,75 era già scritto nella prima stesura di questo documento, PRIMA
> che arrivassero i numeri della cella nuova.** Spostarlo adesso — dopo aver
> visto i numeri — sarebbe **esattamente il riflesso che questa casa vieta**. Lo
> stop non è un criterio di giudizio, ma la disciplina è la stessa: un parametro
> che si sposta dopo aver guardato i dati è un parametro tarato sui dati.
> **2,75 resta dentro l'intervallo misurato su tutte e quattro le combinazioni
> gamba × lato**, e ha una corroborazione indipendente che si dichiara come tale
> e non come prova: è il valore già validato in casa su un altro motore
> (`IchiCross_Gold`, config v1.4).

> ### ⚠️ **L'ASIMMETRIA CHE NE RESTA — RILIEVO, non nota a piè di pagina**
> A 2,75 ATR lo stop vale:
>
> | | D30EUR L | D30EUR S | NASUSD L | NASUSD S |
> |---|---:|---:|---:|---:|
> | **SL / MAE mediana** | **2,08×** | **2,07×** | **1,86×** | **1,77×** |
>
> Su **NASUSD, e soprattutto sul lato SHORT**, lo stop è quindi **più stretto di
> quanto il progetto ("×2") chiedesse**. Conseguenza attesa e falsificabile:
> **più uscite per stop su NASUSD che su D30EUR**. Lo dice la colonna
> `Uscite Stop`. Se non succede, questa lettura è sbagliata e va riscritta.

**Un solo valore per tutte e due le gambe, ed è voluto:** adattare la geometria
simbolo per simbolo prima di avere una misura è **pescare la geometria che fa
passare il cancello** (lezione R116 §3.4). Se D30EUR muore con lo stop di
NASUSD, **quello è il risultato**, e dice che il motore è NAS-nativo.

> ### 🔴 E LA CONSEGUENZA STRUTTURALE, che è la cosa più importante di questa sezione
> **Aggiungere uno stop CAMBIA la popolazione dei trade misurata dalla sonda.**
> Tronca esattamente i trade che sarebbero convergiuti dopo un'escursione
> profonda. **Quindi questo round NON valida i numeri della sonda: è una misura
> nuova.** Il tasso di convergenza misurato (80,3% / 82,0%) **scenderà**, e va
> letto in colonna (`Uscite Convergenza / Stop / Flat Sessione / Tetto Barre`),
> non confrontato ingenuamente col referto del passo 0.

**La forcella per Claudio (§7):** uno stop più stretto (**1,5 × MAE mediana ≈
2,0 ATR**) migliora la geometria in R ma tronca di più.
**Raccomandazione: 2,75 ATR al primo giro** (sta più vicino al contenitore
misurato), **2,0 ATR come ablazione a UN SOLO ASSE in fase 2**, solo sulle celle
che passano.

### 2.5 ⏱️ IL TIME-STOP E IL FLAT DI SESSIONE — e il rilievo su `InpBarreMaxTenuta`

> ### ⚠️ **RILIEVO MISURATO: `InpBarreMaxTenuta = 120` NON HA MAI MORSO.**
> La sessione è **14:30 → 22:00 = 450 minuti = 90 barre M5**. Un tetto a **120
> barre** è **strutturalmente irraggiungibile** dentro una sessione. Il
> contenitore vero della sonda **non era il tetto: era il flat di fine
> sessione** (`motivo = 2`). Quindi **`InpBarreMaxTenuta` non porta nessuna
> informazione misurata**, e chi lo cita come "la tenuta massima misurata" cita
> un numero inerte.

**Conseguenza sulla proposta:**

| voce | valore proposto | perché |
|---|---|---|
| **flat di fine sessione (22:00 server)** | **SÌ, non disattivabile** | è il contenitore **realmente misurato** dalla sonda |
| `InpBarreMaxTenuta` | **120** = **inerte, fedele alla sonda** | riprodurre il contenitore misurato, non inventarne uno |
| time-stop stretto | **NON nel primo giro** | è una variabile in più, e la regola è **una alla volta** |
| candidato per la fase 2 | **48 barre = 4 h ≈ 4 × la tenuta mediana** | la tenuta mediana **MISURATA** alla cella N=40/σ=1,35 è **13 barre (D30)** e **12 barre (NAS)** = 65 e 60 minuti |

E il vincolo prop **P5** (`CONFIG_PROP_2026-08-31`: *"meno del 25% dei trade
sotto i 60 secondi"*) è **soddisfatto per costruzione**: la tenuta minima a M5 è
una barra = **300 secondi**. La sonda lo ha collaudato a **0,00%** su tutte e 49
le celle. **Va comunque letto in colonna, non assunto** (è la lezione T12 della
v1.03: quel collaudo era rotto e nessuno se n'era accorto per due versioni).

### 2.6 🚦 IL TETTO GIORNALIERO — **obbligatorio dal primo round, e lo dice la sonda stessa**

Il `#define REL_C7` del sorgente è esplicito: *"Se il massimo giornaliero
misurato supera 5, `InpMaxTradesPerDay` entra nell'EA DAL PRIMO ROUND"*.

**Misurato alla cella N=40 / σ=1,35:** massimo eseguibili in un giorno =
**10 (D30EUR)** e **8 (NASUSD)**. → **La condizione è scattata**, e sulla cella
nuova morde **più** di prima (era 9 sulla cella vecchia).

**L'aritmetica, che non è un'opinione:**

| | calcolo | contro il muro |
|---|---|---|
| 10 operazioni × 0,65% tutte perdenti | **−6,50%** | 🔴 **sfonda il muro prop giornaliero del 5%** (`METRO_PROP`) |
| **tetto proposto: 5 × 0,65%** | **−3,25%** | 🟢 sotto il muro 5% **e** sotto la pausa Guardian a **4,0%** |

**`InpMaxTradesPerDay = 5`** — e il 5 non è pescato: è **esattamente
l'aritmetica del cap C1 firmato il 18/08** (3,25% = 5 SL vivi da 0,65%).

⚠️ **Il costo, dichiarato:** il tetto **tronca le giornate affollate** e mescola
contenitore e motore. Diventano **colonne obbligatorie**: `Segnali Soppressi dal
Tetto Giorno` e `Giorni col Tetto Colpito`. Se quest'ultima supera **20%**, il
round sta misurando **il tetto** e va scritto in quei termini (regola R116 §4.3).

📌 Nota: con **una posizione per volta** (T6 della sonda, congelato) il **rischio
aperto è ≤ 0,65%**: il **cap C1 non morde mai** in questo round. Il tetto serve
al **muro giornaliero**, non al cap aperto. Vanno tenuti distinti.

### 2.7 🩺 HEDGE-SAFE — e non è una formalità

Il conto è **HEDGING** (`CLAUDE.md`), e l'audit del 03/09
(`report/AUDIT_POSITIONSELECT_HEDGING_2026-09-03.md`) ha inchiodato il difetto
su **126 file esaminati**. Regole non negoziabili per `ABTG_Relativo`:

1. **LETTURA**: mai `PositionSelect(_Symbol)`. Ciclo su `PositionsTotal()` →
   `PositionGetTicket(i)` → filtro **magic + simbolo**.
2. **SCRITTURA**: **tutto per TICKET**. Mai `PositionClose(_Symbol)`, mai
   `PositionModify(_Symbol, ...)`. L'audit lo dice testualmente: il mezzo fix
   (lettura corretta + scrittura per simbolo) è **più pericoloso del bug
   originale**, perché **chiude la posizione del vicino**.
3. **SL broker-side**, mandato con l'ordine e **rispettoso di
   `SYMBOL_TRADE_STOPS_LEVEL`**; normalizzazione ai decimali del simbolo;
   vincoli di volume (min/max/step); **retcode controllato dopo ogni invio**.
4. `ORDER_FILLING` scelto sulle capacità dichiarate dal simbolo, non assunto.

### 2.8 🚫 COSA **NON** ENTRA NEL PRIMO GIRO

1. ❌ **Nessuna gestione**: parziale, breakeven, trailing — **tutti spenti**.
   È la lezione dell'EA oro, testuale: *"parziale precoce + breakeven immediato
   tappavano i vincenti mentre lo SL prendeva perdite piene"*. La gestione è un
   **round successivo**.
2. ❌ **Nessun filtro nuovo** (news, volatilità, trend, orario più stretto):
   filtro appiccicato a motore già tarato = **0 successi su 5** in casa.
3. ❌ **Nessuna griglia di parametri.** N e σ sono **congelati** alla cella del
   §3. Questo round **non ha un picco da scegliere**.
4. ❌ **Nessuna forma a due gambe** (T4): resta **unilaterale**. A due gambe si
   pagherebbero **due spread per una convergenza**, e non è mai stata misurata.
5. ❌ **Nessun `InpModoSpread = 1` (beta OLS) e nessun `InpModoZScore = 1`**:
   restano **ablazioni di un round successivo**, con l'interruttore già scritto
   ma **pinnato a 0**.
6. ❌ **Nessun M15**: entrambe le gambe sono uscite **SOSPESE** a M15.

### 2.9 🪓 SLIPPAGE: e qui, per una volta, la notizia è buona

R55 ha misurato che la fragilità allo slippage **la fa la LARGHEZZA DELLO
STOP**. Qui lo stop è **47-74 punti indice**, cioè **4.700-7.400 punti MT5**
(conversione **misurata**: 100 punti MT5 = 1 punto indice, T14). Uno slippage di
**5 punti MT5 vale lo 0,1% di 1R**.

> 🟢 **Questo motore è nella classe OPPOSTA all'ORB.** L'asse slippage della
> fase 2 va comunque girato (0 / 2 / 5 punti) **per misurarlo**, ma la
> previsione dichiarata è che **non morda**. Se mordesse, la sorpresa sarebbe il
> risultato.

---

## 3. 🎯 LA CELLA — **N = 40, σ = 1,35**, per **tutte e due** le gambe

### 3.1 La regola di scelta, dichiarata PRIMA del numero

> 1. **MAI il picco. SEMPRE un punto INTERNO all'altopiano** (blocchi 2×2 in
>    piedi, non la cella migliore di una classifica).
> 2. **Il blocco dev'essere vivo su ENTRAMBE le gambe e non toccare NESSUN
>    bordo della griglia misurata**, su nessuno dei due assi.
> 3. **Il pareggio fra i vertici del blocco si rompe con due criteri
>    dichiarati**: (a) più occasioni al giorno, (b) C6 più basso. Se i due
>    criteri puntassero in direzioni diverse, la scelta tornerebbe a Claudio.

### 3.2 La griglia estesa, e dove sta l'altopiano

Griglia misurata: **N ∈ [10, 55] passo 5** × **σ ∈ [0,75, 1,95] passo 0,15** =
**90 celle**, entrambe le gambe, entrambi i lati (mappe 10×9 nei referti).

| gamba | verdetto | forma della regione VIVA |
|---|---|---|
| **D30EUR M5** | **VIVO / VIVO**, 19 blocchi 2×2 | banda diagonale: cresce con N e con σ, poi **muore nell'angolo estremo** (N=55 × σ≥1,20 e N=50 × σ≥1,65) |
| **NASUSD M5** | **VIVO / VIVO**, 23 blocchi 2×2 | banda diagonale che **arriva fino al bordo** N=55 / σ=1,95 senza morire |

**Il blocco 2×2 scelto — `N ∈ {40, 45} × σ ∈ {1,35, 1,50}` — è VIVO su tutte e
quattro le mappe** (D30 long, D30 short, NAS long, NAS short) **ed è interno su
entrambi gli assi** (i bordi sono N=10 / N=55 e σ=0,75 / σ=1,95).

### 3.3 I quattro vertici, e il pareggio rotto

| cella | D30 tot/gg | D30 C6 % | NAS tot/gg | NAS C6 % |
|---|---:|---:|---:|---:|
| **N=40 σ=1,35** | **3,376** | **19,68** | **3,564** | **17,96** |
| N=40 σ=1,50 | 3,122 | 19,97 | 3,336 | 18,32 |
| N=45 σ=1,35 | 3,088 | 20,85 | 3,291 | 19,51 |
| N=45 σ=1,50 | 2,880 | 21,50 | 3,102 | 19,91 |

> ✅ **`N=40 / σ=1,35` domina su ENTRAMBI i criteri di pareggio e su ENTRAMBE le
> gambe**: più occasioni e C6 più basso, quattro volte su quattro. I due criteri
> **non si contraddicono**, quindi la scelta non torna a Claudio.

🎁 **E la stessa cella serve tutti e due i mercati.** Nessuna geometria per
simbolo, nessuna manopola pescata: **una sola configurazione, due mercati.**

### 3.4 ✅ IL RILIEVO DEL BORDO È CHIUSO — ed ecco la prova, misurata

La prima stesura portava un rilievo grosso: *l'altopiano tocca il bordo su
entrambi gli assi, quindi il centro non è determinabile*. **L'estensione l'ha
risolto**, e la prova non è che la cella "sembra centrale": è che **è
circondata da celle vive**.

| vicino ortogonale di N=40 / σ=1,35 | D30 L | D30 S | NAS L | NAS S |
|---|---|---|---|---|
| N=35 σ=1,35 | V | V | V | V |
| N=45 σ=1,35 | V | V | V | V |
| N=40 σ=1,20 | V | V | V | V |
| N=40 σ=1,50 | V | V | V | V |

**Sedici vicini su sedici sono VIVI.** Una cella con l'anello completo di vicini
vivi su due mercati e due lati non è un picco di rumore: è un punto interno di
una regione.

### 3.5 ⚠️ MA DUE RILIEVI RESIDUI RESTANO, E VANNO SCRITTI

> **RILIEVO 1 — su NASUSD l'altopiano tocca ANCORA il bordo.** Su D30EUR
> l'angolo estremo **muore per portata** (previsto prima della misura: N e σ più
> grandi riducono le occasioni fino al pavimento C1 di 2,00/giorno) e questo
> **chiude** la domanda su quella gamba. Su **NASUSD no**: a N=55 e σ=1,95 le
> celle sono ancora vive, quindi **non sappiamo dove finisce** la regione viva di
> NASUSD. Claudio ha deciso di **fermarsi qui** — decisione legittima e
> dichiarata — ma la conseguenza va scritta: **la cella scelta è interna, non è
> dimostrato che sia centrale sulla gamba NASUSD.**
>
> **RILIEVO 2 — i due criteri di pareggio spingono SISTEMATICAMENTE verso il
> bordo BASSO della regione viva.** "Più occasioni" e "C6 più basso" crescono
> entrambi al calare di N e di σ, cioè verso il confine inferiore dell'altopiano.
> Quindi la regola di pareggio **non è** una regola di centratura: è una regola
> di frequenza. Il fatto che il risultato abbia comunque l'anello completo di
> vicini vivi (§3.4) è ciò che lo rende accettabile — **non il criterio in sé**.

### 3.6 ⚠️ IL DEBITO C2 SU D30EUR — e perché **NON** blocca questo round

Il referto D30 porta **`Giorni Spaiati Pct = 12,93%`** su tutte le celle (sopra
la soglia di casa del 10%), e **1.057** buchi del metro sulla barra di segnale
**contro 1** di NASUSD. La qualità dell'allineamento fra i due feed **non è la
stessa sulle due gambe**, ed è un fatto misurato.

> ### 💡 IL CAPOVOLGIMENTO, ed è la decisione **D3** di Claudio
> **C2 è un cancello di IGIENE DI MISURA per un CONTATORE.** Su un contatore un
> giorno spaiato produce un **segnale finto** e sporca le statistiche: giusto
> filtrarlo. In un **EA vero** quello stesso giorno produce **un'operazione vera
> con una perdita vera**: non è un artefatto da togliere, **è un rischio da
> misurare**.
>
> **Si gira su entrambe le gambe**, e il round **MISURA** il costo dei giorni
> spaiati invece di nasconderlo, con **tre colonne dedicate**:
> `Operazioni In Giorni Spaiati`, `Profitto In Giorni Spaiati`, `Profitto Fuori
> Giorni Spaiati`. Il filtro esiste nel codice (`InpSaltaGiorniSpaiati`) ma
> **nasce SPENTO**: è un'ablazione di fase 2.
>
> ⚠️ **E si dichiara in ogni tabella:** *"la cella di D30EUR è stata scelta su una
> misura con C2 = 12,93%, sopra la soglia di casa del 10%"*. Il VIVO è genuino;
> è stato misurato con questo difetto.

## 4. 🔢 MAGIC NUMBER — blocco **`7746xx`**, verificato **VERGINE**

**La verifica fatta oggi, riproducibile** (stesso metodo di R116 e del contratto
`770250`):

| controllo | comando | esito |
|---|---|---|
| magic in uso nel repo | `grep -rhoE "(magic\|Magic\|MAGIC)[A-Za-z_]*[ ]*=[ ]*[0-9]{4,}"` su `mql5/` | **148 magic distinti censiti**; il più alto della famiglia 77xxxx è **`779600`** |
| occorrenze a 6 cifre `7746xx` | `grep -rnoE "7746[0-9]{2}"` su **tutto** il repo | **4 occorrenze, TUTTE dentro SHA di commit git** (`.git/logs/`) + 1 decimale di CSV |
| occorrenze come magic | `grep -rnoE "(magic\|Magic\|MAGIC)[A-Za-z_ ]*=[ ]*7746[0-9]{2}"` | **0** |

✅ **`7746xx` è VERGINE.** (Sono liberi anche `7747xx`, `7748xx`, `7749xx`:
verificati con lo stesso metodo, **0 occorrenze come magic**.)

**Assegnazione proposta:**

| magic | uso |
|---|---|
| **774601** | `ABTG_Relativo` — gamba **D30EUR** |
| **774602** | `ABTG_Relativo` — gamba **NASUSD** |
| **774611 / 774612** | i **gemelli di determinismo** (§6.1), stessi input, magic diverso |
| 774603-774609 | riservati alle ablazioni di fase 2 (stop stretto, filtro spaiati, slippage) |

✅ **RI-VERIFICATO il 04/09 (sera), a distanza di ore dalla prima verifica:**
`grep -rnoE "(magic|Magic|MAGIC)[A-Za-z_ ]*=[ ]*7746[0-9]{2}"` su tutto il repo
→ **0**. Le uniche occorrenze a 6 cifre di `7746xx` fuori da `.git` sono **in
questo stesso documento** (dove il blocco viene assegnato) e **un decimale**
dentro `data/snapshots/2026-09-03.json` (`0.3826774611687554`). **Il blocco è
ancora VERGINE.** Ri-verificato anche **`R117`**: `grep -rno "\bR117\b"` →
**0 occorrenze** fuori da questo documento.

⚠️ **Da ri-verificare comunque il giorno del lancio**: fra oggi e allora
qualcuno può prendere il blocco.

---

## 5. 📏 I CRITERI DI MERITO — **PROPOSTA. Li congela Claudio, PRIMA dei numeri.**

### 5.1 La finestra, lo split, e una proprietà rara di questo round

| voce | valore | fonte |
|---|---|---|
| `@DAQUANDO` | **2024.09.26** | **pavimento tick reali INDICI BCM, MISURATO** (`PIANO_PROP` v17: *"indici: 2024.09.26"*) |
| `@FINOA` | **2026.06.30** | fine standard di casa |
| totale | **642 giorni = 1,76 anni** | [CALCOLO] |
| giorni di borsa | **441 (D30) / 450 (NAS)** | [MISURATO dalla sonda: `Giorni Contati`] |
| **split** | **40 / 60** (default del driver) | regola di casa |
| **IS** | **2024.09.26 → ~2025.06.10** (257 gg cal., **~177 di borsa**) | [CALCOLO — **vale il driver**, da verificare sull'anteprima `.ini`] |
| **OOS** | **~2025.06.11 → 2026.06.30** (385 gg cal., **~264 di borsa**) | [CALCOLO] |

> 🎁 **La proprietà rara: la finestra del round è ESATTAMENTE quella della
> sonda.** A differenza di R116 (che dovette spostarsi di 83 giorni), qui il
> pavimento tick degli indici **coincide** con l'inizio del passo 0. **I
> conteggi sono confrontabili riga per riga**, e questo rende possibile il
> collaudo del porto (§6.2).

### 5.2 🐤 Il canarino della frequenza — si legge **PRIMA** del conto economico

**Ancoraggio [MISURATO]:** **3,376** (D30EUR) e **3,564** (NASUSD) eseguibili al
giorno, **due lati sommati**, alla cella **N=40 / σ=1,35**.

**Modello [INFERITO]:** lo stop reale **libera lo slot prima** della sonda
(→ più operazioni), il tetto 5/giorno **ne toglie** sui giorni affollati (→
meno). I due effetti spingono in direzioni opposte e **non si compensano per
costruzione**. Stima prudente: **2,8 - 3,6 operazioni/giorno**.

| | IS (~177 gg) | OOS (~264 gg) | per LATO in IS |
|---|---:|---:|---:|
| **stima** | **490 - 630** | **730 - 940** | **~245 - 315** |

> ### ✅ **Il campione NON è il problema di questo round, e passa anche PER LATO.**
> L'Emendamento della Finestra (**regola A**) chiede **≥ 150 operazioni IS**:
> qui il margine è **3× sulla gamba** e **~2× sul singolo lato**. È il motivo per
> cui il **MERITO** si può giudicare, e si può giudicare **su entrambi i lati**
> (regola dei due lati, 25/08).

**Conseguenze congelate, per gamba / per lato / per finestra:**

| esito | conseguenza |
|---|---|
| **n ≥ 150** | 🟢 si legge sul **MERITO** |
| **30 ≤ n < 150** | 🟠 **MERITO SOSPESO** (valvola R59), si legge **solo il RISCHIO**, e **si scrive** |
| **n < 30** | 🔴 **NON MISURABILE** — la conclusione **non è sull'edge** |
| **n ≥ 150 per gamba ma < 150 per un LATO** | 🟠 il verdetto di gamba si legge; **quel lato è sospeso sul merito** |

### 5.3 🚪 CANCELLO A — quando una gamba **PASSA**. Servono **tutte e sette**

Passare **non è una promozione**: è il permesso di chiedere la prova di rischio
(§5.7) e poi il forward demo.

| # | soglia | da dove esce il numero |
|---|---|---|
| **A1** | **`E` OOS ≥ 0,075 R**, misurata **a tick** e **al NETTO** dei costi | **FIRMA 2 del 31/08** (cancello H8). Non è negoziabile e non è mia |
| **A2** | **PF OOS ≥ 1,15** | cancello storico di casa 1,10 (R15) + margine di rumore |
| **A3** | **segno del profitto COERENTE fra IS e OOS**, e **PF IS > 1,00** | lezione USDJPY di R20: *"IS rosso + OOS verde è la configurazione PIÙ pericolosa"* |
| **A4** | **DD OOS ≤ 8,0%** a rischio 0,65% | muro prop **10%** (`METRO_PROP`) meno il 20% di margine. **Letto senza scalature**: è la ragione del 0,65% |
| **A5** | **Peggior Giornata non peggiore di −4,0%** | a 4,0% il **Guardian mette in pausa la giornata** (firma 18/08). Una giornata peggiore **sul campo non sarebbe esistita**: il suo backtest non è riproducibile |
| **A6** | **n ≥ 150 in IS E in OOS**, per gamba | Emendamento della Finestra, **regola A** |
| **A7** 🆕 | **`% trade sotto 60 s` < 25%** | vincolo prop **P5**. Atteso **0,00% per costruzione** (§2.5): **si legge, non si assume** |

### 5.4 ⚫ CANCELLO B — bocciatura secca. Basta **una**

- **`E` OOS < 0,050 R** (sotto due terzi del cancello firmato);
- **PF OOS < 1,10**;
- **IS negativo** (A3 fallito);
- **DD OOS > 10,0%** → 🔴 sfonda il muro prop **alla taglia di campo**;
- **Peggior Giornata peggiore di −5,0%** → 🔴 sfonda il muro giornaliero;
- ➡️ **le ultime due bocciano per RISCHIO, qualunque sia il PF e qualunque sia
  `n`. Il giudizio di rischio non si sospende mai** (Emendamento, regola B).
- **n IS < 30** → **non è una bocciatura**: è **"non misurabile"**.

### 5.5 🔒 LE FASCE, VERIFICATE DISGIUNTE

Fra "passa" e "bocciata secca" esiste **sempre** una terza fascia esplicita
(= **NON PASSA**: nessuna proposta, nessuna bocciatura del meccanismo).

| grandezza | 🟢 PASSA | 🟠 ZONA MORTA | ⚫ BOCCIATA SECCA |
|---|---|---|---|
| `E` OOS | ≥ 0,075 R | 0,050 ≤ E < 0,075 | < 0,050 R |
| PF OOS | ≥ 1,15 | 1,10 ≤ PF < 1,15 | < 1,10 |
| DD OOS | ≤ 8,0% | 8,0% < DD ≤ 10,0% | > 10,0% |
| Peggior Giornata | ≥ −4,0% | −5,0% ≤ PG < −4,0% | < −5,0% |
| `n` (gamba) | ≥ 150 | 30 ≤ n < 150 (merito sospeso) | — (n < 30 = non misurabile) |
| % sotto 60 s | < 25% | — | ≥ 25% |

**Regola generale, congelata:** qualunque valore ambiguo, illeggibile o coperto
da due letture **si scioglie verso la clausola PIÙ SEVERA**, e **la scelta si
dichiara nel referto**. **Non si aggiusta la fascia dopo aver visto il numero.**

### 5.6 🚨 LA CONTAMINAZIONE DELL'OOS, dichiarata prima e senza sconti

> ### 🔴 **L'OOS DI QUESTO ROUND NON È UN VERO OUT-OF-SAMPLE.**
> La cella **N=40 / σ=1,35** è stata scelta guardando una misura che copre
> **l'INTERA finestra 2024.09.26 → 2026.06.30**, cioè **anche l'OOS**. E la
> griglia estesa del 04/09 sera **copre esattamente la stessa finestra**: la
> seconda corsa non ha aggiunto out-of-sample, ha aggiunto **celle**.
> Nascondere questo fatto renderebbe il round una bugia.

**Le tre attenuanti, che sono reali ma non annullano il problema:**

1. La scelta è stata fatta sul **CENTRO dell'altopiano**, non sul picco: non è
   stata selezionata la cella "migliore" di nessuna classifica.
2. I criteri usati (**C1 portata, C3 taglia, C5 geometria, C6 convergenza, C8
   tenuta**) **non contengono nessun P/L**: nessuno ha mai visto un euro di
   questo motore. **Non si può aver fittato un profitto che non esiste.**
3. La stessa cella serve **due mercati diversi**: un fit su un singolo storico
   non sopravvive di solito al trasporto.

**Conseguenza congelata:** l'IS e l'OOS di questo round vanno letti come **due
campioni indipendenti della STESSA configurazione congelata** (esattamente come
R116 §5.2), **non** come una selezione + una validazione. **L'unico vero
out-of-sample di RELATIVO sarà il forward demo**, e va scritto in ogni tabella.

### 5.7 ⚖️ RISCHIO E REGIMI — quello che questa finestra **non può** dare

> ### 🔴 **UN SOLO REGIME (TORO), e lo dichiarano i referti stessi.**
> 21 mesi di indici 2024-2026 sono **un campione di OPERAZIONI ampio** e **un
> campione di REGIMI da UNO**.

| Emendamento | esito |
|---|---|
| **A** — l'unità di misura è l'operazione (≥150) | ✅ **soddisfatta con margine 3×** |
| **B** — il vecchio giudica il rischio | ❌ **non misurabile qui**: i tick reali degli indici **non esistono prima del 2024.09.26** |
| **C** — la prova di regime batte la storia contigua | ❌ **NON soddisfatta**: nessuna finestra orso, laterale o crollo |

> 🔒 **Regola vincolante proposta: da questo round NON esce una sedia.** Esce, al
> massimo, una **candidata**, e solo dopo (a) la prova di rischio su un regime
> ostile e (b) il forward demo. **Questo round può, al massimo, guadagnarsi il
> diritto di chiedere la prova di rischio.**
>
> E la clausola di lettura, per qualunque strada si scelga poi: **su dati
> pre-2024.09.26 si legge SOLO il RISCHIO (DD, peggior giornata, perdite
> consecutive). Mai il merito. Mai il PF. Mai `E`.**

### 5.8 🏁 VERDETTO DI ROUND — congelato prima

| esito | condizione | cosa si scrive, e cosa si fa |
|---|---|---|
| 🟢 **il meccanismo ha un segno** | una gamba passa **tutti** i cancelli A e supera la fase 2 slippage | *"la convergenza del rapporto ha aspettativa positiva a tick reali su \<gamba\>, **su un solo regime**"* → si chiede la **prova di rischio**. **Nessuna sedia, nessun forward, ancora** |
| 🟠 **passa una gamba sola** | l'altra fallisce A | **non è "il motore funziona"**: si scrive *quale* gamba, e la gamba morta **resta morta** (lezione PTE: GBPUSD sì, USDJPY no) |
| 🟠 **passa il lordo, muore il netto** | passa a slippage 0 e cade a 5 punti | etichetta R55 *"vive solo a taglia piccola"*. **Non si propone** |
| 🔴 **nessuna gamba passa A** | — | **il meccanismo non ha edge a tick reali su questa finestra.** Verdetto **pieno e valido** |
| 🔴 **bocciata per rischio** | A4 o A5 falliti | **vale anche col PF bello** |
| ⛔ **non misurabile** | un gate di sanità §6.1 rosso, **oppure** n < 30 | *"il banco non ha prodotto la misura"*. **Vietato scriverlo come se fosse un verdetto sull'edge** |

### 5.9 🚫 COSA **NON** SI POTRÀ DIRE, coi dati che avremo

1. ❌ **"Regge nel tempo"** — un solo regime, 21 mesi.
2. ❌ **"Il DD sarà quello"** — un broker, un feed, un regime, e il Guardian nel
   backtest **non** interviene come sul campo.
3. ❌ **"La cella è quella giusta"** — l'altopiano **tocca il bordo della griglia
   su entrambi gli assi** (§3.4).
4. ❌ **"I numeri della sonda sono confermati"** — lo stop reale **cambia la
   popolazione** dei trade (§2.4).
5. ❌ **"Basta allargare/stringere lo stop"** e rilanciare: sarebbe **pescare la
   geometria**. Sarebbe una tesi nuova, in un round nuovo, con criteri firmati
   prima.
6. ❌ **"D30EUR è pulito"** — la sua misura porta **C2 = 12,93%** e **1.057 buchi
   del metro** contro **1** di NASUSD (§3.5).
7. ❌ **Passare al forward** senza la prova di rischio e senza il **contratto
   della sedia** scritto (DD e frequenza promessi, censimento dei contratti).

---

## 6. 🧪 I COLLAUDI — o il referto non è chiuso

### 6.1 Sanità: se cade una, il round non si legge

1. **Gemelli identici**: `774601` vs `774611`, stessi input → **identici al
   centesimo**. Divergono → **banco sporco, round fermo**.
2. **Autotest del nucleo** (`InpAutoTest`): **0 falliti**, letto **in colonna**,
   **non** nei log (in ottimizzazione MT5 non esegue le `Print` degli agent —
   lezione R95 §3.1).
3. **`Model = 4` verificato sul REPORT DEL TESTER**, non sull'anteprima `.ini`
   (che scrive `Model=4` hardcoded e quindi non fa da prova).
4. **Riga del Diario `ticks data begins from`** letta e **ricopiata nel referto**
   per **D30EUR, NASUSD e U30USD**. *"Non l'ho letta"* ≠ *"i tick c'erano"*.
5. **Prima data del per-trade ≤ 2024.10.31.** Se è molto più tardi, il **tetto
   delle ~100.000 barre** ha morso (M5 × ~445 giorni ≈ **128.000 barre**) → il
   round si rifà **in due tranche**, dichiarando la sovrapposizione. ⚠️ Nella
   corsa OHLC della sonda il tetto **non** ha troncato (prima barra misurata =
   2024-09-26), ma **a tick reali il vincolo vero è la RAM**: **massimo 4
   agenti** (lezione 01/09, *"no memory for ticks generating"*).
6. **Storia del METRO presente**: `U30USD` in Market Watch e sincronizzato. Il
   tester modella i tick **solo del simbolo del grafico**: del metro scarica le
   **barre**, e noi lo leggiamo a **shift ≥ 1** (T1) → **nessun look-ahead**, ma
   se le barre mancano l'EA **non deve inventarle** (T2: la barra si salta).
7. **`Valutazioni Metro Mancante Segnale`** dello stesso ordine di grandezza
   della sonda (**~1.057 su D30, ~1 su NAS**). Un salto grosso = storia del metro
   incompleta → **round fermo**.

### 6.2 🥇 IL COLLAUDO DEL PORTO — il più importante, e costa una passata

> **Domanda:** l'EA calcola lo **stesso z** della sonda, o abbiamo portato un
> motore diverso senza accorgercene?

`InpModoSonda = true` → l'EA **conta e non ordina**, con la cella scelta, sulla
**stessa finestra**. **L'interruttore esiste nel codice** (`ABTG_Relativo.mq5`,
scelta di traduzione **R1**) e i grezzi si contano **prima di ogni filtro**,
apposta perché restino confrontabili.

| grandezza | atteso | perché |
|---|---|---|
| **`Attraversamenti Grezzi` L/S** | **IDENTICI, alla cifra**, ai numeri del referto della cella | lo z si calcola su **barre chiuse**: il modello di tick **non lo tocca** |
| `Attraversamenti Eseguibili` | **DIVERSI, ed è giusto** | lo stop libera lo slot prima, il tetto 5/gg ne toglie |

🔴 **Se i GREZZI non combaciano, il porto è sbagliato e il round non parte.**
È un collaudo **falsificabile**, gratis, e chiude in anticipo la classe di
errori più pericolosa (un motore che sembra quello promosso e non lo è).

### 6.3 🔧 LE COLONNE OBBLIGATORIE — escono **dai DATI**, non dai `Print`

| # | colonna | a cosa risponde |
|---|---|---|
| 1 | `Segnali Generati` | portata reale |
| 2 | `Segnali Soppressi Posizione Aperta` | costo dello slot unico (T6) |
| 3 | `Segnali Soppressi dal Tetto Giorno` + `Giorni col Tetto Colpito` | **> 20% = il round misura il tetto** (§2.6) |
| 4 | `Uscite: Convergenza / Stop / Flat / Tetto` (conteggio e %) | quanto lo stop ha **cambiato** il motore (§2.4) |
| 5 | **`Guadagno Realizzato per Vincente / MFE mediana`** | 🎯 **il numero della previsione 1.2 n.2** |
| 6 | `Spread all'Ingresso: mediana e P95 (punti indice)` | **lo spread si MISURA, non si filtra** (lezione R55) |
| 7 | `Scarto Ingresso vs Apertura di barra (mediana, P95)` | il rilievo del §2.2 |
| 8 | `Operazioni in Giorni Spaiati` + **il loro P/L separato** | il debito C2 di D30EUR, **misurato** invece che filtrato (§3.5) |
| 9 | `% trade sotto 60 s` e `tenuta mediana (barre e minuti)` | cancello A7 / vincolo P5 |
| 10 | `Peggior Giornata (%)` e `DD giornaliero massimo` | cancelli A4 / A5 |

---

## 7. ✍️ LE DECISIONI — quelle PRESE e quelle che RESTANO

### 7.1 ✅ Già decise da Claudio il 04/09

| # | decisione | esito |
|---|---|---|
| **D3** | includere **D30EUR** col suo debito C2 = 12,93% | ✅ **SÌ**, misurando il costo con le tre colonne dedicate (§3.6) |
| **D4** | estendere la griglia **prima** di scrivere l'EA | ✅ **SÌ, ESEGUITO.** 90 celle, riproduzione passata, rilievo del bordo chiuso su D30EUR (§3.4-3.5) |
| **D5** | `InpMaxTradesPerDay = 5` | ✅ **SÌ.** 10 × 0,65% = −6,50% sfonda il muro giornaliero (§2.6) |
| **D6** | criteri di merito del §5 | ✅ **CONGELATI come proposti** |
| **D7** | cella definitiva | ✅ **N=40 / σ=1,35**, con i due rilievi residui del §3.5 dichiarati |

### 7.2 ⬜ Quelle che restano aperte

| # | decisione | la mia raccomandazione |
|---|---|---|
| **D2** | **SL a 2,75 × ATR o a 2,0 × ATR?** | 🟢 **2,75 al primo giro** (più vicino al contenitore misurato, e già scritto prima di vedere i numeri nuovi), **2,0 come ablazione di fase 2** |
| **D8** | **il RILIEVO 1 del §3.5** (su NASUSD l'altopiano tocca ancora il bordo) si accetta come limite dichiarato, o si estende ancora la griglia su quella sola gamba? | 🟠 **si accetta e si dichiara.** Estendere ancora costerebbe una corsa OHLC, ma la cella scelta ha **l'anello completo di vicini vivi** e il round a tick misura il merito, non la centratura. Se il round dovesse passare, la centratura di NASUSD diventa una domanda da rifare **prima** del forward |
| **D9** | ri-verifica di `R117` e del blocco `7746xx` **il giorno del lancio** | 🟢 routine, la fa la riga di lancio |

## 8. 🛑 IL PERIMETRO DI QUESTO LAVORO

**Fatto (04/09):**
1. ✅ Scritto `mql5/Experts/ABTG_Relativo.mq5` — l'EA operativo, **con ordini
   veri**, nucleo statistico **trasportato riga per riga** dalla sonda v1.03 e
   **20 blocchi di autotest** che lo interrogano a tavolino.
2. ✅ Scritto il file prova e la riga di lancio del round a tick reali.
3. ✅ Estesa la griglia della sonda e letta la mappa 10×9 (decisione D4).

**NON fatto, e va detto:**
1. ❌ **`ABTG_SondaRelativo.mq5` NON è stato toccato**: resta il contatore puro,
   v1.03, invariato.
2. ❌ **Niente è stato compilato e niente è stato girato**: in questo ambiente
   non esistono MetaEditor né Strategy Tester. **Se la compilazione fallisce,
   QUELLO è il risultato del passo.**
3. ❌ **Non è stato toccato niente del forward né del VPS**, nessuna sedia,
   nessun preset.
4. ❌ **Nessun criterio è stato spostato** dopo aver visto i numeri
   dell'estensione: la cella è cambiata perché la **griglia** è cambiata, i
   **cancelli** sono gli stessi (stanno nei `#define` del sorgente della sonda).
