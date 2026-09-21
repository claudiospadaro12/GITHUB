# 📏 IL FILTRO DELLO SPAZIO — 21/09/2026

**Che cosa è**: una **sonda dentro l'EA** che misura, prima di ogni ingresso,
**quanto spazio c'è fino al primo ostacolo sul timeframe superiore** — e che
**di default non fa assolutamente nulla**.

| campo | valore |
|---|---|
| File toccato | `/home/user/GITHUB/mql5/Experts/ABTG_DAX_Apertura_EU.mq5` (magic **770101**) |
| Diff | **429 righe aggiunte, 0 righe cancellate** (misurato: `git diff --numstat cd5bf255`) |
| Default | `InpSpaceMode = 0` (**OFF**) + `InpSpaceMinR = 0` + `InpSpaceMaxR = 0` |
| Compilato? | ❌ **No.** Nessun MetaEditor qui. Non è mai girato, da nessuna parte |
| Schierato? | ❌ **No.** Nessun preset toccato, nessun `.set`, nessun terminale |
| Gemelli Dow/Nasdaq | ❌ **Non toccati**, per mandato |

---

# 🔴 PRIMA DI TUTTO: I CONTRO-ESEMPI

Questa sezione sta **in testa e non in fondo** perché è la parte che conta di
più. Se leggete solo un pezzo di questo referto, leggete questo.

## 1. 🪦 IL CONTRO-ESEMPIO MISURATO, E VALE PIÙ DI TUTTI GLI ALTRI: **R30**

Non è un'ipotesi: **questo filtro ha già un parente stretto in casa, ed è stato
bocciato con i numeri in mano.**

`SRBlocked()` / `InpUseSRFilter` (`ABTG_Nasdaq_Apertura_US.mq5` r.361-365 e
r.1982 · `ABTG_Apertura_3Ingressi.mq5` r.2097-2136) fa **esattamente la stessa
cosa**: veta l'ingresso se c'è un ostacolo davanti entro N punti. Misurato il
12/08 sul Nasdaq — fonte letta di prima mano, non citata a memoria:
`backtest_pipeline/risultati_archivio/REFERTO_ROUND30_REGALI_AMICO.md`:

| cella | IS profit | IS PF | OOS profit | OOS PF | OOS DD% |
|---|---|---|---|---|---|
| baseline | +69,62 | 1,07 | **+476,33** | 1,27 | 5,77 |
| **SRFilter acceso** | **+221,31** | **1,27** | 🔴 **−56,86** | 🔴 **0,97** | 6,80 |

> 🔴 **La cella PIÙ BELLA in campione era l'UNICA ROSSA fuori campione.**
> Tagliava **13 trade su 99 (13%)** — e **tagliava quelli buoni**. Da allora è
> `InpUseSRFilter=false` in **TUTTI** i preset.

**La differenza fra il nostro filtro e R30 esiste** (ostacoli *dinamici* —
medie e Supertrend — invece di PDH/PDL e numeri tondi; **TF superiore** invece
dello stesso TF; **banda** invece di solo pavimento) **ma è una differenza di
ingredienti, non di famiglia.** Il meccanismo è lo stesso: *"non entrare con un
ostacolo addosso"*.

### 👉 La conseguenza, ed è la ragione per cui il codice è fatto così
1. **Le due soglie nascono a ZERO.** Non esiste ancora un numero: esiste solo
   una distribuzione da misurare. Un default "ragionevole" sarebbe **un numero
   inventato**, ed è precisamente il modo in cui si rifà R30 con un altro nome.
2. **Il MODO 1 (sola misura) è la consegna vera.** Il modo 2 esiste solo perché
   un giorno, *se* i numeri diranno qualcosa, non si debba riscrivere il codice.
3. **Anche il modo 2, con le soglie a 0, non blocca niente.** È verificabile nel
   codice (r.1817-1836) ed è dichiarato nel log di avvio.

## 2. 🐂 IN QUALE REGIME QUESTO FILTRO FA PEGGIO — e non è dove ci si aspetta

Il mandato diceva: *«in un trend forte le medie vengono attraversate di
continuo, quindi è un ammazza-trend»*. **Ho provato a verificarlo sulla
geometria vera, e la conclusione è più precisa — e più scomoda.**

In un **trend forte al rialzo**, le EMA 14/50/100/200 H4 stanno **SOTTO** il
prezzo. Per un **long**, quindi, stanno **dietro le spalle**: il codice le
scarta (r.1677-1690, `if(d <= 0) return;`), lo spazio davanti risulta infinito e
**il filtro non morde**. 🟢 Nel trend conclamato, sul lato del trend, il filtro è
**permissivo**, non ammazza-trend.

🔴 **Morde altrove, e il posto dove morde è peggio:**

- **Morde all'INIZIO dei movimenti.** Il prezzo è "dentro" il ventaglio delle
  medie **esattamente quando un regime sta cambiando**: è lì che una EMA sta
  poco sopra un long. Il filtro tiene le **continuazioni tardive** e taglia le
  **partenze**. La fonte stessa lo ammette in diretta (r.95, **verbatim**): *«la
  forza da sotto è uscita dal credimento, sta rompendo»* — detto **dopo** aver
  deciso di non entrare per mancanza di spazio. **Avevano rinunciato a un
  movimento che poi è arrivato.**
- **Morde in CONTROTENDENZA.** Su un long controtrend tutte e quattro le medie
  sono davanti: bloccato quasi sempre. Può essere un bene — ma è una **scelta
  direzionale mascherata da filtro di spazio**, e va misurata per lato.
- **Morde nei giorni COMPRESSI**, quando le medie sono ammassate sul prezzo:
  cioè nei giorni in cui i segnali sono già pochi. Il taglio **non è uniforme**,
  si concentra.

## 3. 🔗 IL DIFETTO CHE NON ERA NEL MANDATO: la soglia in R è **correlata alla larghezza del range**

La soglia è `spazio >= k × dist`, e su questa sedia `dist` **non è un numero
qualsiasi**: con `InpSLMode = SL_RANGE` lo stop è il **bordo opposto del range di
apertura**. Quindi:

> **range di apertura largo → `dist` grande → il filtro morde di più.**

E la configurazione validata di questa sedia è **proprio quella a range largo**
(`ABTG_DEF_RANGE_MIN 35`: *"fuori campione 8 celle su 8 in utile con 35-45, 0 su
12 sotto"*). 🔴 **Il filtro è quindi sistematicamente più severo nelle mattine
volatili, che sono le mattine su cui l'edge di questa sedia è stato misurato.**

Non è un motivo per non misurarlo. È un motivo per **incrociare i blocchi con la
larghezza del range** quando si leggeranno i numeri: se i blocchi si concentrano
sulle mattine larghe, il filtro non sta selezionando lo spazio, sta selezionando
la volatilità — e allora è un altro esperimento, con un altro nome.

## 4. ⏱️ Gli altri tre modi in cui sbaglia

- **Un ostacolo non è un muro.** Una EMA H4 non è una barriera: il prezzo le
  attraversa continuamente. L'intera premessa (*"la media ferma il prezzo"*) è
  **un'assunzione non misurata**. Il modo 1 serve proprio a metterla alla prova.
- **Il livello è vecchio di una barra.** Si legge lo **shift 1** del TF superiore
  (niente sguardo nel futuro, scelta obbligata). Alla decisione delle ~08:35
  server la barra H4 chiusa è quella delle 08:00 → **~35 minuti di ritardo**:
  trascurabile per EMA100/200, **non** trascurabile per EMA14 H4.
- **Il fail-open asimmetrico.** Se un handle non nasce o `CopyBuffer` torna a
  vuoto, quell'ostacolo **non si conta** e il filtro lascia passare. È il verso
  giusto in cui sbagliare per un cancello — ma vuol dire che **i numeri del modo
  1 sono un limite INFERIORE**: se nel giornale compaiono righe *"handle EMAxx
  non creato"*, la misura di quel periodo è da buttare, non da interpretare.

## 5. 🚦 E il contro-esempio operativo: **oggi non c'è un modo indolore di metterlo in campo**

Il modo 1 è prezioso perché misura **sulle operazioni vere**. Ma:

- la **challenge FTMO è viva da stamattina** (21/09) e le sedie stanno operando;
- mettere il modo 1 in campo significa **ricompilare e riattaccare** la sedia
  `770101`, che nel censimento del 07-08/09 risulta attaccata sul terminale del
  **conto REALE** (`C:\BCM_Reale`, `report/giornata_2026-09-07.md` r.63)
  — perimetro **esplicitamente fuori mandato**;
- e la procedura di aggiornamento di questo EA richiede **RIPRISTINA**, che
  rimette i default compilati (è la causa misurata del sizing sbagliato del
  23/07-14/08, fix C4 del 02/09).

🔴 **Quindi: il modo 1 in campo NON è gratis e NON è una decisione nostra.** La
misura che si può fare **subito e a costo zero di rischio** è quella **nel
tester**. È quella che propongo qui sotto.

---

# 🎬 IL MECCANISMO E DA DOVE NASCE

Fonte: `trascrizioni/LIVE_EMILIANO_2026-04-10.txt`. Righe **testuali**:

**Il pavimento — troppo poco spazio (r.71-73):**
> *«Vai a fare l'analisi multi-frame. Siamo in H1, vai in H4. In H4 c'è spazio
> per portare del profitto? C'abbiamo subito la media.»*
> *«Cosa può succedere? C'è poco spazio. Allora, non si può fare. Ovviamente, in
> maniera cautelativa, è giusto tirare il suo piede dall'acceleratore.»*

**Quanto è "poco" (r.83-84):**
> *«Perché c'è traffico sotto i minimi della notte c'è traffico, 30 punti,
> giusto? Secondo me sono pochini.» · «Sono pochini.»*

**Il tetto — troppo lontano (r.39):**
> *«Sono 170 punti. Se dovessimo andare a questo livello qua, nel prezzo attuale
> sono 500 rubi, è troppo distante.»*
>
> *(«rubi» è un errore di trascrizione per «punti»: la riga successiva riprende
> con «500 punti? Ma di cosa stai parlando?». Cito com'è scritto, non come mi fa
> comodo.)*

**E la riga che vale più di tutte — r.93**, dove il meccanismo è per intero in
tre righe, compresi i numeri e la scala dei timeframe:
> *«quando piazzo l'ordine non mi basta vedere che ce l'ho in H1 vado in H4, in
> H4 c'è spazio per scendere, sì c'è un po' di spazio ma questa zona in realtà la
> vedo pericolosa, quindi i minimi da notte oggi non li farei **perché c'è poco
> spazio ma poco spazio sono circa 30 punti 26 punti in realtà** la media
> dovrebbe sostenere la media in H4 **anche se la media è a 14** [...] poi vado a
> vedere in D1 abbiamo dello spazio»*

👉 Tre cose **confermate dalla fonte**, non dedotte da noi: l'ostacolo è una
**media sul TF superiore** (e nomina proprio la **14**, che è `InpSpaceEma1`);
*"poco"* vale **26-30 punti**; e la scala è **H1 → H4 → D1**, che è esattamente
il ruolo di `InpSpaceTF`.

👉 **È una BANDA, non un pavimento.** Si sta fermi sia quando davanti c'è
traffico subito, sia quando il livello di riferimento è a casa di Dio.

---

# 🧱 LE DECISIONI DI PROGETTO, E PERCHÉ

| # | Decisione | Perché |
|---|---|---|
| **1** | **Soglie in multipli di R**, non in punti | *«30 punti»* sul DAX e sul Nasdaq sono due cose diverse. `spazio >= k × dist` si normalizza da sola su qualunque simbolo. E dice una cosa vera: **se lo spazio è minore del bersaglio, l'operazione non ci può arrivare** — aritmetica, non opinione |
| **2** | **Tre modi**, con lo 0 = no-op assoluto | Il modo 1 misura senza cambiare un trade. È la differenza fra proporre un'idea e proporre un numero |
| **3** | 🔴 **Soglie a ZERO di default**, e il modo 2 con soglie a 0 **non blocca** | R30. Nessun numero è stato misurato: inventarne uno "ragionevole" è il modo in cui si sbaglia |
| **4** | **Si misura SEMPRE, si filtra solo dopo** | `SpazioFuoriBanda()` conta, riempie l'istogramma e scrive la riga **prima** di guardare le soglie. Con le soglie spente il modo 1 è una **sonda a pieno regime**, non un filtro inerte |
| **5** | **Istogramma in R + segnali persi PER LATO** | Il pavimento di frequenza è **1,00 op/giorno per FAMIGLIA** (firma 07/09) e la famiglia Aperture sta a **1,407**. Un filtro che taglia il 13-30% può portarla sotto: sarebbe un PF più bello su una sedia **non schierabile**. Il costo in frequenza è **parte della misura**, non un dettaglio |
| **6** | **Solo barre chiuse (shift 1)** | La barra 0 del TF superiore si muove ancora: usarla sarebbe leggere un livello che nel backtest non esisteva |
| **7** | **Ostacoli dietro le spalle scartati** | Un long non è ostacolato da una media che gli sta sotto |
| **8** | **Agganciato solo a `MonitorRetest()`** | È il motore che gira davvero su questa sedia. 🟠 Su altri motori il filtro **non verrebbe mai interrogato**: il codice lo **dice a voce alta** all'avvio, perché *"un flag acceso che non fa niente e non lo dice"* è il bug del 05/08 daccapo |

### ⚠️ La metà ambigua, dichiarata e non nascosta
Con `InpSpaceMaxR > 0`, il caso **"nessun ostacolo davanti"** viene trattato come
**"troppo lontano"** → morde. È la lettura fedele di r.37-39 (*il livello non è
governabile*), ma è **una scelta, non un fatto**. Il modo 1 misura quante volte
capita (colonna `nessun ostacolo` dell'istogramma): **quel numero dirà se la
scelta è sostenibile.** Finché `InpSpaceMaxR = 0`, non ha nessun effetto.

### 🚫 Quello che il filtro NON fa
❌ non tocca parziale, breakeven, trailing, chiusura di fine sessione · ❌ non
tocca il sizing · ❌ non tocca gli altri motori d'ingresso · ❌ **blocca solo
l'APERTURA**, mai la gestione di una posizione già viva.

---

# ✅ LA PROVA CHE IL DEFAULT È UN NO-OP — si vede, non si dice

**Misura oggettiva, prima di tutto:**

```
git diff --numstat cd5bf255 -- mql5/Experts/ABTG_DAX_Apertura_EU.mq5
429     0     <- 429 aggiunte, ZERO cancellazioni
```
E l'elenco delle righe **originali** cancellate è **vuoto**: nessuna riga
preesistente è stata modificata o rimossa. Il codice vecchio è tutto lì, intatto.

### Il percorso del codice con `InpSpaceMode = 0`, punto per punto

**① Il cancello d'ingresso — r.1909-1913 (ramo LONG) e r.1950-1954 (ramo SHORT)**
```
if(InpSpaceMode != ABTG_SPACE_OFF && !skip && dist > 0 &&
   SpazioFuoriBanda(true, entry, dist))
  {
   if(InpSpaceMode == ABTG_SPACE_ATTIVO) skip = true;
  }
double lot = skip ? 0.0 : CalcLotByRisk(dist);     <- riga ORIGINALE, intatta
```
`InpSpaceMode != ABTG_SPACE_OFF` è **falsa alla prima clausola**. MQL5 valuta
`&&` in **corto circuito**: `SpazioFuoriBanda()` **non viene chiamata**. Quindi
a default: nessun calcolo, nessun handle creato, nessuna riga di log, `skip`
**mai toccata**. Le due righe successive (`lot`, `tp`) e la `if(!skip && lot > 0
&& dist > 0)` sono **le righe originali, byte per byte**.

**② Le funzioni nuove sono IRRAGGIUNGIBILI a default.** Catena completa:
`SpazioFuoriBanda` (r.1817) ← chiamata **solo** dalle due righe ① ·
`SpazioFinoAOstacolo` (r.1741) ← solo da `SpazioFuoriBanda` ·
`SpazioAssicuraHandles` (r.1649), `SpazioConsidera` (r.1677),
`SpazioSupertrendLivello` (r.1694), `SpazioBucket` (r.1777) ← solo da quelle due.
Verificato con `grep`: **esistono esattamente 2 punti di chiamata**, entrambi
dietro la stessa guardia.

**③ Gli handle indicatore non nascono nemmeno.** Sono creati **pigramente**,
dentro `SpazioAssicuraHandles()`, **non** in `OnInit`. A modo spento quella
funzione non viene mai raggiunta → `gSpaceEmaH[]` resta `INVALID_HANDLE` → l'EA
**non crea un solo handle in più** di prima. *(Ecco perché non sono in `OnInit`:
è una scelta, non una dimenticanza.)*

**④ `OnInit` e `OnDeinit`: log identici.** Entrambe le aggiunte sono dentro
`if(InpSpaceMode != ABTG_SPACE_OFF)`. Il ciclo di rilascio in `OnDeinit` scorre
4 handle tutti `INVALID_HANDLE` e non fa nulla. 👉 **Un giornale prodotto prima e
uno prodotto dopo si confrontano riga per riga.**

**⑤ Il `.set` esistente resta valido.** I `.set`/`.ini` MT5 sono `nome=valore`,
**indipendenti dall'ordine**: i preset attuali non nominano gli input nuovi,
che quindi atterrano sul default compilato (**0 = spento**). Nessun preset è
stato aperto né modificato.

### 🧪 E il controllo che romperebbe tutto questo, se fosse falso
> **Il modo 1 deve riprodurre il P/L del modo 0 AL CENTESIMO.**

Non è una formalità: è **il** test di regressione. Il modo 1 tocca handle,
contatori e log ma **non deve spostare un solo trade**. Se il tester dà anche un
centesimo di differenza fra `InpSpaceMode=0` e `InpSpaceMode=1` a parità di
tutto il resto, **c'è un bug e la misura non si legge**. Questa cella va girata
**per prima**.

---

# 📐 COME SI MISURA

## Fase 0 — il controllo di sanità (obbligatorio, prima di tutto)
Due corse identiche salvo `InpSpaceMode` **0** e **1**. Attese:
**profitto, PF, DD, numero trade identici**; il giornale del modo 1 in più
contiene la distribuzione. Se non torna: **stop**, si corregge il codice.

## Fase 1 — LA MISURA VERA (modo 1, soglie spente) 🥇
**Questa è la consegna.** Nessuna soglia, nessuna griglia, nessuna scelta: si
raccoglie **la distribuzione dello spazio** su tutti i segnali storici.

- **2 corse** (una per lato), `InpSpaceMode=1`, `InpSpaceMinR=0`, `InpSpaceMaxR=0`.
- Output da leggere nel **giornale Esperti**:
  - una riga per segnale: `SPAZIO long: entry ... ostacolo EMA100 H4 a ... = 0.66R ...`
  - in coda, `FILTRO SPAZIO - distribuzione LONG/SHORT: <0,5R=.. | 0,5-1R=.. | ...`
- **L'analisi che conta** si fa **incrociando le righe di log con i trade del
  report** (entrambi hanno prezzo d'ingresso e orario): *lo spazio davanti
  separa i vinti dai persi, sì o no?* 🔴 **Se la risposta è NO, il lavoro finisce
  qui e il modo 2 non si accende mai.** Costo totale: quasi zero.

## Fase 2 — solo SE la fase 1 dice di sì: la curva della soglia
Griglia `InpSpaceMode=2`, `InpSpaceMinR` = **0 / 0,5 / 1,0 / 1,5 / 2,0** ×
`InpSpaceTF` = **H1 / H2 / H3 / H4** → **20 celle per finestra, 40 pass**.
- 🔑 **`InpSpaceMinR=0` È IL CONTROLLO dentro la griglia**: deve riprodurre la
  baseline esatta. Senza, la tabella non ha metro (stessa disciplina del
  `InpTrailStartR=0` nella prova gemella).
- ⚠️ `InpSpaceTF` è `ENUM_TIMEFRAMES`: **MT5 ignora lo step** e spazzola i membri
  fra start e stop (misurato il 07/08) → H1→H4 dà H1, H2, H3, H4.
- Il tetto `InpSpaceMaxR` **non entra in questa griglia**: due assi nuovi insieme
  è il modo di non capire quale ha spostato i numeri. Viene dopo, da solo.

### Il file prova, pronto (da salvare in `backtest_pipeline/prove/ABTG_DAX_Apertura_EU_SPAZIO.txt`)
🔴 **Non l'ho creato io**: un file prova va congelato **coi criteri scritti prima
dei numeri** e passato dal cancello, e non era nei deliverable. Ecco il corpo,
già allineato alla prova gemella già girata su questa sedia:

```
@SIMBOLO  D30EUR
@PERIODO  M5
@DAQUANDO 2024.09.26

InpAllowShort=0||0||0||0||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpSpaceMode=2||2||0||2||N
InpSpaceMinR=0||0||0.5||2.0||Y
InpSpaceTF=16388||16385||1||16388||Y
```

⚠️ **I due pin non sono facoltativi** (stessa lezione della prova gemella):
`InpAllowShort=0` perché il SOLO LONG del 07/08 è stato fatto **sul grafico, non
nel codice** (nel sorgente è ancora `true`); `InpRiskPercent=1.0` perché il
`#define` dice 1,0 ma tutte le fasi precedenti girano all'1% e al 2% i numeri
non si confrontano più con niente.

⚠️ **Regola dei due lati (25/08)**: la prova sopra misura **solo il long**. Il
lato short va misurato in una **seconda corsa**, non dato per buono.

## 🕐 Tempo macchina
🔴 **Non ho un numero misurato e non lo invento.** Quello che posso dire di
fatto: è la **stessa geometria, stesso simbolo, stessa finestra** della prova
`backtest_pipeline/prove/ABTG_DAX_Apertura_EU.txt`, che è da **50 pass** contro i
nostri **40** → costo dello **stesso ordine di grandezza**, ricavabile dal
registro di quella corsa. La fase 1 è **2 pass**: trascurabile.

🖥️ **E gira sul PC DI BACKTEST, non sul VPS** (firma del 21/09, dopo che stamattina
il tester ha inchiodato la macchina delle sei sedie).

---

# ✍️ COSA SERVE PER FIRMARLO

| # | Cancello | Stato |
|---|---|---|
| 1 | Modo 1 riproduce il modo 0 **al centesimo** | ⏳ da girare |
| 2 | Il giornale **non contiene** righe *"handle EMAxx non creato"* | ⏳ da girare |
| 3 | La fase 1 mostra che lo spazio **separa vinti e persi** | ⏳ **è il cancello vero**: se no, si chiude qui |
| 4 | La soglia scelta regge **fuori campione**, non solo IS | ⏳ — è esattamente dove R30 è morto |
| 5 | **Centro dell'altopiano, MAI il picco**; i vicini (soglia **e** TF) anch'essi migliori | ⏳ |
| 6 | Costo in **frequenza** per lato: la famiglia resta **≥ 1,00 op/giorno** | ⏳ |
| 7 | **Due lati** misurati separatamente (25/08) | ⏳ |
| 8 | Passaggio dal **cancello** (`controlla_riga.py` + `controllo-preventivo`) | ⏳ in corso |
| 9 | Firma di Claudio prima di qualunque cosa vada in campo | ⏳ |

🔴 **In assenza di tutto questo: NON SI TOCCA NIENTE.** I default restano 0/0/0,
che è esattamente il comportamento di oggi.

---

# 🧭 IN SINTESI, da socio

🟢 Quello che è andato **bene**: il meccanismo della live è stato tradotto in una
forma **misurabile** (in R, non in punti; banda, non pavimento) e — soprattutto —
in una forma che **misura prima di filtrare**. Il modo 1 ci fa sapere quanto
costerebbe l'idea **senza rischiare un euro e senza spostare un trade**.

🟠 Quello che va detto **chiaro**: questa è **ponteggio**, non una sedia. Non
avvicina di un centimetro il 1° ottobre finché la fase 1 non produce un numero.
E c'è un precedente misurato (**R30**) che dice che questa famiglia di filtri
**ha già mentito una volta**, ed era molto convincente mentre lo faceva.

🔴 E la cosa più onesta di tutte: **il risultato più probabile di questa misura è
che il filtro non serva.** Il codice è scritto apposta perché, in quel caso, non
ci sia niente da smontare — basta lasciare i default dove sono.
