# 📊 MEDIA 200 — SPECIFICA IMPLEMENTABILE RICOSTRUITA DAL CORSO

**Data:** 18/08/2026 · **Fonte:** 5 trascrizioni, lezioni 21-25, in
`backtest_pipeline/caccia_strategie/trascrizioni_corso_2026-08-18/modulo_media200/`
(45.944 caratteri, **lette per intero, riga per riga**).

**Consegna gemella:** referto, schede e contraddizioni in
`caccia_strategie/ANALISI_CORSO_FIBOH4_MEDIA200_2026-08-18.md`.

> 🚨 **NOTA DI CASA, PRIMA DI TUTTO — questa strategia CE L'ABBIAMO GIA'.**
> `mql5/Experts/ABTG_EMA200.mq5` e' **il porting di questa identica materia**
> (i commenti nel sorgente citano _"guida ~5 pip"_, _"guida ~15 pip"_,
> _"guida ~50/70 pip"_, _"guida: H4/D1"_ — sono **i numeri di queste lezioni**).
> Ed e' **il miglior risultato del progetto**: R29, **30 celle su 30 a PASS
> pieno** su U30USD, PF OOS 1,52, DD 7,21%, 444 trade OOS.
> ➡️ **Il confronto esplicito sta nel §11, ed e' il pezzo che vale di piu' di
> tutto il documento: il corso NON ci ha dato l'edge — ce l'hanno dato le
> scelte che abbiamo fatto NOI dove il corso taceva.**

> ⚠️ Fonte **solo audio**, nessuna slide. Etichette: **[TRASCRITTO]** ·
> **[INFERITO]** · **[INCERTO]**.

---

## 0. 🎯 IL VERDETTO DI MECCANIZZABILITA'

⚠️ **Il modulo contiene DUE strategie diverse**, e vanno contate separate.

### 0.1 MEDIA 200 "RIMBALZO" (lezioni 21-24) — il corpo del modulo

| | conteggio | quota |
|---|---|---|
| Decisioni operative censite | **33** | 100% |
| ✅ **Regole CERTE** | **16** | **48%** |
| 🟠 Ambiguita' risolvibili con un'assunzione dichiarata | **10** | 30% |
| 🔴 Buchi / non meccanizzabili come dette | **7** | 21% |
| **Meccanizzabilita' con le assunzioni dichiarate** | **26/33** | **79%** |

### 0.2 BREAK-IN / BREAK-OUT MEDIA 200 (lezione 25) — strategia a se'

| | conteggio | quota |
|---|---|---|
| Decisioni operative censite | **11** | 100% |
| ✅ Regole CERTE | **5** | **45%** |
| 🟠 Ambiguita' | **3** | 27% |
| 🔴 Buchi | **3** | 27% |
| **Meccanizzabilita' con le assunzioni** | **8/11** | **73%** |

🚨 **I tre buchi che decidono il P&L, e che il corso NON puo' colmare:**
1. **La percentuale di rischio: mai pronunciata in 5 lezioni.**
2. **Il filtro dell'arrivo sulla media (spike vs candela piena)** — che il
   relatore chiama _"**l'unica cosa sulla quale stare attenti**"_ — e' descritto
   **solo a parole**, senza una soglia.
3. **Il piazzamento del 2° ordine "sul livello tecnico"** — lettura visiva.

---

## 1. LA TESI, COME LA DICHIARA IL CORSO

> _"una strategia utilizzata dagli **istituzionali** per investire soldi quando i
> prezzi arrivano sulla media oppure per disinvestirli"_ (lez. 21)
> `[TRASCRITTO]`
> _"quando siamo sulla media a 200 c'e' sicuramente un momento in cui si genera
> un movimento importante"_ `[TRASCRITTO]`

Motore: **rimbalzo sulla EMA200 nella direzione del trend**. Il prezzo ritraccia
verso la media, si piazzano ordini limite nell'intorno, si prende il rimbalzo.

⚠️ **La giustificazione e' un racconto, non un dato.** Il "gli istituzionali
mettono i soldi sulla media a 200" e' affermato **cinque volte** e **mai
misurato**. Va registrato come motivazione narrativa, non come evidenza.
Il timeframe alto e' motivato meglio: _"piu' riduci il time frame e piu' c'e'
rumore"_ — argomento standard e ragionevole, comunque non misurato qui.

---

## 2. IMPIANTO — indicatori e timeframe

| voce | valore | citazione | etichetta |
|---|---|---|---|
| Piattaforma | **MT4** | _"siamo sulla piattaforma MT4, **conto reale**"_ | 🟢 chiaro |
| Grafico | candele giapponesi, senza griglia | lez. 21 | 🟢 (cosmetico) |
| **Media principale** | **EMA 200, ESPONENZIALE, su CLOSE** | _"inseriamo **200**, mettiamo **esponenziale**, se non viene di default perche' di default dovrebbe venire semplice ... l'applichiamo **sul close**"_ | 🟢 **il parametro meglio dettato dell'intero corso: periodo, metodo E prezzo applicato** |
| **Media target** | **EMA 14, esponenziale, su close** | _"la media 14 la inseriamo **esponenziale sul close**"_ | 🟢 chiaro |
| **ATR** | **periodo 14**, su H4 | _"average through range [ATR] ... lo metti con **periodo 14**"_ | 🟢 chiaro (_"through"_ = _true range_, storpiatura ovvia) |
| **TF operativo** | **H4 o D1** | _"**H4 daily sono i due timeframe** [is]**tituzionali**"_ | 🟢 chiaro |
| TF di rifinitura | **H1**, solo per migliorare il punto d'ordine | _"l'H1 ... **gli istituzionali non utilizzano** e io lo utilizzo semplicemente per andare a **migliorare la qualita' dell'ordine**"_ | 🟢 chiaro |
| TF piu' bassi | ammessi solo _"quando prenderai mano"_ | lez. 21 | 🟠 gate sull'esperienza |
| Universo | **tutte le valute** (giro completo del Market Watch) | _"io vado a fare un giro su **tutte le valute**"_ | 🟢 chiaro — 🔴 **e nessun tetto sul numero di posizioni** (§9) |

> 🔴 **NOTA PESANTE PER IL CONFRONTO COL REPO (§11):** il corso dice
> esplicitamente che **H1 non e' un timeframe da strategia** e parla **solo di
> valute**. Il nostro miglior risultato di sempre e' **EMA200 su H1** e su un
> **indice** (Dow). **Il corso avrebbe sconsigliato entrambe le scelte.**

---

## 3. LA ROUTINE E IL FILTRO DI DISTANZA

| voce | valore | citazione | etichetta |
|---|---|---|---|
| Ora del giro | **08:00** (_"mi alzo alle 7"_) | _"La prima cosa che io devo valutare **alla mattina alle 8**"_ | 🟢 chiaro |
| Ora del giro (varianti) | _"lo puoi fare anche alle 8, alle 7"_; _"questo giro lo sto facendo adesso **alle 10**"_ | lez. 21 | 🟠 finestra, non ora |
| **FUSO ORARIO** | **MAI DICHIARATO** | — | 🔴 **BUCO** |
| **Distanza prezzo → EMA200** | **50 / 60 / 70 pip, 70 al massimo** | _"prendo tutte quelle valute che hanno una distanza dalla media di **circa 50 pip, 60 pip, anche 70 pip al massimo**"_ | 🟢 **chiaro, ripetuto 4 volte in 3 lezioni** |
| Troppo vicino → scarta | esempio: **12 pip** su AUDCHF → _"passo avanti"_ | _"siamo all'interno di quei 60-70 pip? **No, allora passo avanti**"_ | 🟢 chiaro, con esempio numerico |
| Troppo lontano → scarta | **120 pip** | _"se fosse distante **120** molto probabilmente non verrai eseguito durante quella giornata"_ | 🟢 chiaro |
| Motivazione | dare spazio al prezzo di arrivare in giornata | lez. 21/22 | 🟢 coerente |

> 🕐 **[INFERITO, come nel modulo Fibo H4]:** gli orari descrivono la **routine
> personale** del relatore → verosimilmente **ora italiana**. In ora server BCM
> (IT − 1): **08:00 IT → 07:00 BCM**. **Resta un'inferenza.**
>
> ⚠️ **E qui c'e' un problema in piu' del Fibo H4:** la strategia scandisce la
> giornata sulle **candele H4**, che dipendono dal fuso del BROKER (un H4 apre
> alle 00/04/08/12/16/20 ora server). **Fuso non dichiarato = allineamento delle
> candele non ricostruibile.** Su H4 e' una differenza reale, non cosmetica.

---

## 4. DIREZIONE — e la contraddizione interna del modulo

### 4.1 La regola che la strategia usa davvero (lez. 21-24)
> _"la media sostiene il trend e ti da' la direzione del trend in atto"_
> _"nel momento in cui i prezzi vanno vicino alla media, toccano la media e **in
> quel momento entrano i capitali**"_ `[TRASCRITTO]`

→ **Prezzo SOPRA la EMA200 = si compra il ritorno sulla media.
Prezzo SOTTO = si vende il ritorno sulla media.** Conferma di trend citata:
_"minimi crescenti"_ (🟠 mai definiti in numero).

### 4.2 🔴 LA CONTRADDIZIONE — la lezione 21 definisce l'esatto contrario
> _"un **segnale di acquisto** puo' verificarsi quando il prezzo **attraversa la
> media mobile dal basso verso l'alto** indicando un potenziale cambiamento di
> trend, viceversa un **segnale di vendita** ... quando il prezzo attraversa la
> media a 200 periodi **dall'alto verso il basso**"_ (lez. 21) `[TRASCRITTO]`

**Questo e' un attraversamento, non un rimbalzo, ed e' il segnale OPPOSTO** a
quello che le lezioni 22-24 insegnano (prezzo sopra la media che ci ritorna
sopra = si compra; per la lez. 21 quel movimento verso il basso sarebbe un
**segnale di vendita**).

⚖️ **Risoluzione:** la definizione della lez. 21 **non appartiene alla strategia
del rimbalzo: appartiene alla lezione 25** (break-in/break-out, §10), che e'
esattamente la versione ad attraversamento. E' una **definizione da manuale
messa in apertura** e non raccordata. **Le lezioni 22-24 sono inequivocabili: la
strategia principale e' il RIMBALZO.**
🔴 **Ma per uno studente che si ferma alla lez. 21, il segno del trade e'
invertito.** E' l'errore piu' probabile per chi replica questo modulo.

---

## 5. PIAZZAMENTO DEGLI ORDINI

| voce | valore | citazione | etichetta |
|---|---|---|---|
| Tipo | **ordini pendenti (limite)**, mai a mercato | _"piazzo semplicemente degli ordini pendenti"_ | 🟢 chiaro |
| Numero | **2** (un 3° e' facoltativo) | _"potreste addirittura dividere in tre ordini, ma per ragioni di semplicita' vado a inserire **due ordini**"_ | 🟢 chiaro |
| **Posizione** | **1° sul lato del prezzo rispetto alla media; 2° OLTRE la media** | _"il primo lo metto sopra, ... il secondo ... lo vado a inserire **sotto la media in H4**"_ | 🟢 chiaro |
| **Distanza fra i due ordini** | **~20 pip su H4** | _"la distanza sono circa **20 pip**, perche' **212 sono punti**"_ ✅ (212 punti = 21,2 pip, aritmetica coerente) | 🟢 chiaro |
| Distanza (scala per TF) | _"possono essere **10, 15, 20** a seconda del time frame, in H4 20 pip sono corretti"_ | lez. 22 | 🟢 chiaro |
| **Size 1° ordine** | **piccola** | _"una prima quantita' bassa sopra la media"_ | 🟢 principio chiaro |
| **Size 2° ordine** | **piu' consistente** | _"andro' a inserire la **quantita' piu' importante**"_ | 🟢 principio chiaro |
| Valori d'esempio | **0,50 lotti** e **1,5 lotti** su conto **~30.000 EUR** | lez. 21/22 | 🟠 **esempio, non regola** (§9) |
| 2° ordine: dove esattamente | **su un livello tecnico letto in H1** (piu' minimi/massimi contrapposti) | _"il secondo ordine in H1 corrispondeva anche a questi due minimi e poi ... a un massimo"_ | 🔴 **NON MECCANIZZABILE come detta** |
| Motivazione dello split | **psicologica, dichiarata** | _"per cercare di superare dei **condizionamenti psicologici**"_, _"per il tuo **mindset**, per la tua serenita'"_ | ⚠️ vedi riquadro |

> ⚖️ **Lo split NON e' martingala — e va detto con precisione.** La size totale
> e' **decisa prima**, i due ordini sono **pendenti pre-impegnati**, e lo **stop
> unico e' oltre entrambi** (_"lo stop loss lo metto **sempre sull'ordine piu'
> grande, sotto**"_, lez. 24). Perdita massima **limitata e nota in partenza**.
> 🟢 Nessuna griglia, nessun raddoppio dopo la perdita, nessun mediare.
> 🟠 L'unico appunto: la motivazione data e' **il mindset**, mai il rischio.

### 5.1 🟠 Lo spostamento degli ordini (lez. 24) — l'unica cosa che somiglia a un allargamento
> _"ipotizziamo che i prezzi arrivano **con forza**, allora posso spostare il
> primo ordine al posto del secondo e il secondo ordine lo posso spostare dove
> avevo lo stop e **lo stop si spostera' leggermente piu' sotto**, inverto
> semplicemente gli ordini"_ `[TRASCRITTO]`

🟠 **Precisazione dovuta: sono PENDENTI, non posizioni aperte.** Non e' un
allargamento di stop su una posizione in perdita — e' un **ri-piazzamento del
setup piu' in basso**. Non e' una bandiera rossa del setaccio.
🔴 **Ma il grilletto e' _"arrivano con forza"_, che non ha soglia**, e l'effetto
netto e' che **il livello di invalidazione insegue il prezzo**. Per un EA: o si
quantifica "forza", o **non si implementa**.

---

## 6. 🔑 IL FILTRO DELL'ARRIVO SULLA MEDIA — il cuore, e il buco

E' **l'unica condizione di ingresso vera** della strategia, e il relatore lo
dice: _"di questa strategia **l'unica cosa sulla quale stare attenti e' questo**"_
(lez. 24).

| condizione | esito | citazione |
|---|---|---|
| ✅ Il prezzo tocca la media **con uno SPIKE**, **nella prima mezz'ora** della candela H1 | **rimbalzo probabile → si resta** | _"Se avviene con uno spike nella prima mezz'ora, c'e' la probabilita' maggiore che **tocchi il livello e ritorni**"_ |
| ❌ Il prezzo arriva con **candela piena senza spike**, **a 2 minuti dall'apertura** | **si SPOSTANO o si CANCELLANO gli ordini** | _"la candela e' **bella piena senza spike** e a **2 minuti dall'apertura** sei in prossimita' della media, allora li' devi fare soltanto un'azione, **puoi spostare gli ordini oppure li puoi cancellare**"_ |

**Come si sorveglia:** _"ogni fine della candela oraria andare a vedere dove sono
i prezzi rispetto alla media"_ · _"presta attenzione soltanto verso la **seconda o
la terza ora** delle candele"_ · _"la piattaforma MT4 ha un'applicazione sul
cellulare dove **ogni ora** ... vado a vedere l'operazione"_.

> 🔴 **PERCHE' E' UN BUCO:** "spike", "bella piena", "con forza" **non hanno una
> sola soglia numerica in 5 lezioni**. Sono descritti a gesti sul grafico.
>
> 🟢 **Ma e' l'UNICO buco del corpus che sia PIENAMENTE quantificabile da noi**
> senza inventare la strategia — la sostanza c'e' tutta:
> ```
> spike  := (ombra dal lato della media) / (range della barra H1) >= X    [X ~ 0,4-0,5]
> pieno  := |close - open| / (high - low) >= Y                            [Y ~ 0,7-0,8]
> timing := tocco della media entro i primi 30 min della barra H1 = OK
>           tocco entro i primi ~2 min con barra "piena"    = CANCELLA
> ```
> **X e Y sono NOSTRI e vanno messi a sweep e dichiarati.** Ma la forma della
> regola e' del corso, non nostra. **E' la proposta di lavoro numero 1 di questo
> documento** (§12).

---

## 7. TARGET

| target | valore | citazione | etichetta |
|---|---|---|---|
| **1° target (il naturale)** | **la EMA 14** | _"il **primo livello di target e' la media 14**, il piu' semplice"_ | 🟢 chiaro, ribadito 3 volte |
| Alternativa A | **1 ATR** dal **primo** ordine | _"il portare profitto lo scelgo dal **primo ordine** 17"_ | 🟢 chiaro |
| Alternativa B | **2 ATR** = target finale | _"cerco di farla correre la posizione al **secondo ATR**"_ | 🟢 chiaro |
| Alternativa C | supporto/resistenza tracciati a mano | lez. 23 | 🔴 visivo |
| Scelta fra A/B/C | **nessun criterio** | — | 🟠 |
| Piazzamento | **leggermente PRIMA del livello** | _"non lo metto esattamente sul livello, lo metto **leggermente sotto** perche' preferisco essere eseguito"_ | 🟢 principio chiaro, 🟠 nessun quanto (nell'esempio: **1,6 pip**) |
| Numeri tondi | **si evitano** | _"il numero tondo e' una **soglia psicologica**"_ | 🟢 chiaro |

---

## 8. STOP LOSS E GESTIONE

| voce | valore | citazione | etichetta |
|---|---|---|---|
| **Ancoraggio dello stop** | **sempre sotto/sopra l'ORDINE PIU' GRANDE (il 2°)** | _"lo stop loss lo metto **sempre sull'ordine piu' grande, sotto**, quindi la [A]TR lo calcolo dall'ordine piu' grande"_ | 🟢 **chiaro e ripetuto — la regola di rischio meglio definita del modulo** |
| Metodo 1 | **1 ATR** oltre l'ultimo ordine | _"se prendi un ATR scegli **17 pip sotto l'ultimo ordine**"_ | 🟢 chiaro |
| Metodo 2 | **2 ATR** | _"posso pensare di inserire uno stop loss ... a **34 pip**, quindi a **2 ATR** sul timeframe in H4"_ | 🟢 chiaro |
| Consiglio | _"all'inizio **1 ATR** e poi inserire **2 ATR**"_ | lez. 23 | 🟠 **ambiguo**: progressione nel tempo o due varianti? |
| Metodo 3 | livello tecnico (sotto piu' minimi/massimi) | lez. 23 | 🔴 visivo |
| ⚠️ Nota del corso su 1 ATR | _"**17 e' poco per un timeframe H4**"_ | lez. 23 | 🟢 il corso stesso preferisce 2 ATR su H4 |
| **Al 1° target** | **chiudi 50% + stop in pari** | _"chiudo meta' posizione, ho realizzato un profitto e a quel punto **porto lo stop in pari**"_ | 🟢 chiaro, ripetuto 5 volte |
| **Trailing** | **manuale**, sotto la parte bassa di ogni candela | _"con un **training** [trailing] **stop manuale** posso spostare l'ordine nella parte inferiore della candela"_ | 🟠 meccanizzabile, ma **non e' detto su quale TF** |
| Stop profit | quando lo stop supera l'ingresso | _"lo stop quando supera il livello d'ingresso diventa uno **stop profit**"_ | 🟢 (e' il trailing, ridetto) |

---

## 9. 🚨 RISCHIO — il buco piu' grave del modulo

> _"la prima cosa che devi fare e' **stabilire la size rispetto al tuo conto,
> rispetto allo stop** che vuoi avere complessivo"_ (lez. 22) `[TRASCRITTO]`

🔴 **La percentuale non viene MAI pronunciata. In nessuna delle 5 lezioni.**
L'unico ancoraggio quantitativo e' un esempio di **leva**, e per giunta storpiato:

> _"ho un conto da circa **30 mila Euro** ... posso inserire **1,05**, quindi vuol
> dire che io sto entrando con **50 mila Euro** perche' per convenzione **un
> lotto corrisponde a 100 mila Euro**, ... una **leva 1 a 2**, una leva molto
> bassa"_ (lez. 21)

🟠 **[TRASCRITTO dubbio]:** "1,05" e "50 mila euro" **non tornano** — 50.000 su
lotti da 100.000 fa **0,50**, non 1,05. E la lez. 22 dice infatti
_"abbiamo deciso una size **0,50**"_. ✅ **Il valore coerente e' 0,50.**

### 🧮 Ricostruzione del rischio per operazione — **[INFERITO, mai dichiarato]**
Dall'esempio AUDCAD completo (lez. 21-24): conto **30.000 EUR**, ordini
**0,50 + 1,50 = 2,00 lotti**, distanza fra ordini **20 pip**, stop **34 pip**
(2 ATR) sotto il **secondo** ordine → stop del primo ordine a **54 pip**.

```
rischio  = 0,50 lotti x 54 pip  +  1,50 lotti x 34 pip  =  78 lotti-pip
AUDCAD:   1 lotto x 1 pip ~ 10 CAD ~ 6,3 EUR   [tasso NON dichiarato: INFERITO]
rischio ~ 78 x 6,3 ~ 490 EUR   su 30.000 EUR  =  ~1,6%
```

> ⚖️ **~1,5-2% per operazione.** Sopra il nostro **0,65%** di casa, ma nello
> stesso ordine di grandezza: **non e' un impianto sconsiderato**.
>
> 🔴 **IL PROBLEMA NON E' IL PER-OPERAZIONE, E' L'AGGREGATO.** La routine dice
> _"vado a fare un giro su **tutte le valute**"_ e piazza ordini su **ognuna**
> che stia nei 50-70 pip dalla media. **In 5 lezioni non esiste UN SOLO tetto:**
> non un numero massimo di posizioni, non un limite per valuta, non una parola
> su **correlazione**. In una mattina in cui il dollaro e' a 60 pip dalla media
> su sei cross, si aprono **sei posizioni nella stessa direzione**: `6 x 1,6% ≈
> **10% a rischio su un'unica scommessa**`. **E' il killer prop di questa
> strategia** (§13).

### 🔴 Numeri di performance
| dichiarazione | citazione |
|---|---|
| _"una strategia molto solida, **statisticamente provata**, che utilizziamo tutti i giorni in live"_ (lez. 25) | 🔴 `[dichiarato, NON verificato]` — **zero numeri a supporto** |
| _"nel momento in cui tu sei eseguito su questo tipo di strategia, **sei ragionevolmente sicuro** ... che tu ti troverai un bel profitto"_ (lez. 22) | 🔴 `[dichiarato, NON verificato]` — e per giunta con la clausola onesta _"la certezza non c'e' nessuno"_ |
| **N operazioni · win rate · drawdown · periodo · broker · backtest** | 🔴 **MAI, nemmeno una volta, in 45.944 caratteri** |

🚨 **Nessun esempio di operazione PERDENTE viene mai mostrato in 5 lezioni.**
Il modulo Media 200 e' **il piu' povero di numeri di tutto il corso analizzato
finora**: il Breakout almeno aveva una lezione (la 39) con un foglio di calcolo.

---

## 10. 🆕 LEZIONE 25 — BREAK-IN / BREAK-OUT: e' un'ALTRA strategia

> _"La modalita' operativa e' **l'apertura della candela sopra la media 200 per
> una direzione buy** o l'apertura della candela **sotto la media 200 per una
> direzione sell**. Quindi si parla di **violazione della media**."_
> `[TRASCRITTO]`

**Segno opposto al rimbalzo: e' momentum sulla rottura, non fade sul tocco.**
Ed e' **la strategia che non abbiamo**: non esiste un nostro EA che la faccia.

| regola | valore | citazione | etichetta |
|---|---|---|---|
| **Trigger** | la candela **successiva** alla violazione **APRE** oltre la media | _"avviene quando c'e' la candela successiva alla violazione che **apre sopra la media**"_ | 🟢 **chiaro e pienamente meccanizzabile** |
| Qualita' della violazione | candela **ampia, piena, senza spike**, che **chiude sui massimi** | _"la forza viene espressa dalla **volatilita'**, quindi dall'**ampiezza della candela** ... **molto piena senza spike** ... **chiude sui massimi**"_ | 🟠 **quantificabile da noi** (ampiezza vs ATR, corpo/range, chiusura nell'ultimo X% del range) |
| Contesto | **tre minimi** sullo stesso livello = condizione di inversione | _"**tre minimi sono una condizione di inversione**"_ | 🟠 detto **una volta sola**, nessuna tolleranza sul "stesso livello" |
| **Size** | **piccola** all'apertura della candela | _"inserendo una size all'ingresso dell'apertura della candela"_ | 🟢 chiaro |
| **Size** | **grande** con pendente **sul retest della media** | _"poi inseriro' la **parte piu' importante** sopra la media **nel retest della media**"_ | 🟢 **chiaro — ed e' elegante: il grosso entra al prezzo migliore** |
| Scala della size | piu' l'apertura e' lontana dalla media, **meno** si entra | _"piu' e' distante e piu' entrerai con poco"_ | 🔴 **nessuna scala data** |
| **Stop** | ATR (esempio **25 pip**) **sotto l'ultimo ordine**, oppure sotto il livello dei minimi multipli | _"se l'ATR e' di **25 pip**, inseriro' **sotto l'ultimo ordine** 25 pip"_ | 🟢 chiaro |
| Gestione | 1 ATR → chiudi meta' + stop in pari | _"ho un'ATR, prendo, chiudo meta' posizione e porto lo stop in pari"_ | 🟢 chiaro (identica al rimbalzo) |
| 🔴 **Target** | _"il primo naturale obiettivo del prezzo e' **sempre la media**"_ | lez. 25 | 🔴 **INCOERENTE**: si e' appena entrati **rompendo** la media, che quindi sta **dietro** al prezzo. Frase copiata dal modulo del rimbalzo. **Da scartare**: restano media 14, ATR, S/R |

> 🎯 **Questa e' la materia genuinamente NUOVA del corpus di oggi.** Il trigger
> ("la candela successiva **apre** oltre la EMA200") e' **binario, oggettivo e
> testabile senza alcuna assunzione**. E' l'ingresso piu' pulito di tutte e 8 le
> lezioni analizzate.

---

## 11. 🔬 CONFRONTO ESPLICITO COL NOSTRO `ABTG_EMA200` (537 righe)

**Richiesto da Claudio.** `ABTG_EMA200` e' **sedia 12** in
`report/CONTRATTI_SEDIE.md` (U30USD, magic 771531, DD promesso **7,21%**,
~33-35 trade/mese) e viene da **R29, il primo 30/30 della storia del progetto**.

### 11.1 ✅ COSA CONDIVIDONO (e la sovrapposizione e' quasi totale)

| elemento | corso | `ABTG_EMA200` |
|---|---|---|
| Livello | EMA 200 | `InpEmaPeriod = 200` ✅ |
| Logica | rimbalzo sulla media nel verso del trend | "EMA 200 REVERSAL (bounce)" ✅ |
| Bias di trend | prezzo dal lato della media | `InpUseEma14Bias = true` ✅ (**anche piu' stretto**) |
| 1° target | **EMA 14** | `InpEma14Period = 14`, `InpTP1_ATRmult=0` → TP1 su EMA14 ✅ |
| Misura dello stop | **ATR 14** | `InpAtrPeriod = 14`, `InpSLatr = 1.0` ✅ (**metodo 1 del corso**) |
| Ordini | **2 pendenti limite** attorno alla media | `o1`, `o2` + `InpUseOrder2` ✅ |
| Ancoraggio dello stop | **oltre il 2° ordine** | `SL = 1*ATR oltre il 2o ordine` ✅ **fedele alla lettera** |
| Distanza operativa | **50-70 pip** | `InpMaxDistAtr=1.5` — e il commento dice `guida ~50/70 pip` ✅ |
| Gestione | parziale 50% + stop in pari | `InpTP1Pct=50`, `InpBreakeven=true` ✅ |
| Trailing | su EMA14 | `InpUseTrailing = true` ✅ |
| Pendenti non eseguiti | si cancellano | `InpPendingExpiryBars`, `InpUseCutoff` ✅ |
| TF dichiarato | H4 / D1 | `InpTF = PERIOD_H4` di default ✅ |

> 🎯 **Verdetto: non "somiglia". E' LO STESSO MOTORE.** I commenti del sorgente
> citano _"guida ~5 pip"_, _"guida ~15 pip"_, _"guida ~50/70 pip"_,
> _"guida: H4/D1, anche H1"_ — **sono i numeri di queste cinque lezioni**.
> `docs/live_emiliano/CATALOGO_STRATEGIE_CORSO.md` lo dava gia' per assodato
> (_"Media 200: TROVATA (Paolo) = il nostro ABTG_EMA200"_): **queste
> trascrizioni lo confermano riga per riga.**

### 11.2 🔴 COSA DIFFERISCE — e sono le differenze che hanno prodotto il risultato

| # | punto | corso | noi | peso |
|---|---|---|---|---|
| **1** | **TIMEFRAME** | **H4/D1**; H1 _"gli istituzionali non lo utilizzano"_ | **R29 gira su H1** | 🔴 **il corso sconsiglia il TF del nostro unico 30/30** |
| **2** | **MERCATO** | **solo valute** (giro del Market Watch) | **U30USD (Dow), un INDICE** — mai nominato nel modulo. E su **EURUSD**, cioe' il terreno del corso, **R29 ha BOCCIATO** (7/30 PASS sparsi) | 🔴 **il corso e' forex, il nostro edge e' su un indice** |
| **3** | **SPLIT DELLA SIZE** | **0,50 + 1,50 = 25% / 75%** in lotti, col grosso **oltre** la media | `riskPct = InpRiskPercent/nOrders` → **50% / 50% di RISCHIO** | 🟠 divergenza reale. 🧮 Ma attenzione: in **rischio** lo split del corso e' `27 : 51` lotti-pip = **~35%/65%**, non 25/75 (lo stop e' piu' vicino al 2° ordine). **Meno lontano di quanto sembri** |
| **4** | **DISTANZE DEGLI ORDINI** | **assolute**: ~5 pip e ~20 pip su H4 | **relative**: `0,10 ATR` e `0,35 ATR` | 🟢 **la nostra e' migliore** (si adatta a volatilita' e strumento) — ma **e' una scelta nostra**, e il commento del codice dice "guida ~15 pip" dove il parlato dice 20 |
| **5** | 🔑 **FILTRO DELL'ARRIVO** (spike vs candela piena) | **il cuore della strategia** (§6) | **NON IMPLEMENTATO.** L'intestazione lo ammette: _"NON automatizzato ... timing intra-candela. Restano all'occhio umano"_ | 🔴 **la divergenza piu' importante: manca l'unico filtro di ingresso del corso** |
| **6** | **STOP: 1 o 2 ATR** | il corso preferisce **2 ATR** su H4 (_"17 e' poco per un timeframe H4"_) | `InpSLatr = 1.0` | 🟠 **il valore preferito dal corso non e' il nostro default** |
| **7** | **TARGET FINALE** | **2 ATR** | `InpTP_RR = 2.0` (in R) | 🟢 equivalente **solo se** SL = 1 ATR. Con SL 2 ATR il corso vuole ~1:1, noi ~2:1 |
| **8** | **BREAK-IN/BREAK-OUT** (lez. 25) | strategia a se' | **NON ESISTE nel repo** | 🔴 **materia nuova** |
| **9** | **FILTRO NOTIZIE** | **mai nominato** in 5 lezioni | esiste (`InpUseNewsFilter`) ma **spento** | 🟠 pari e patta, entrambi scoperti |
| **10** | **RISCHIO %** | **mai dichiarato** (~1,6% ricostruito) | `InpRiskPercent = 1.0` | 🟠 **l'1% e' NOSTRO** |
| **11** | **TETTO POSIZIONI** | **nessuno**, su tutte le valute | un EA per grafico, `InpMaxTradesPerDay` | 🟢 **il nostro impianto e' piu' sicuro del corso** |
| **12** | Filtro ADR | assente | `InpUseAdrFilter` (opt-in, _"live Paolo"_) | 🟢 raffinamento nostro |

### 11.3 🏆 LA LEZIONE, IN UNA RIGA
> **Il corso ci ha dato la MACCHINA (EMA200 + EMA14 + ATR14 + due limite +
> parziale + BE), e la macchina e' identica. L'EDGE — H1 sul Dow — ce lo siamo
> dati NOI, contro due indicazioni esplicite del corso (H4/D1, solo forex).**
> E' la conferma pratica della regola scritta in `caccia_strategie/LEGGIMI.md`:
> _"si raccoglie la MECCANICA e la TESI, mai il risultato"_.

---

## 12. 🧪 TEST-CASE NUMERICI (questi si', il modulo li da')

### T1 — L'esempio AUDCAD completo (lez. 21-24), **aritmetica verificata**
| voce | valore dal corso |
|---|---|
| distanza prezzo → EMA200 al giro delle 08:00 | **51 pip** → ✅ accettato (dentro 50-70) |
| AUDCHF stesso giro | **12 pip** → ✅ scartato |
| distanza fra i due ordini | **212 punti = ~20 pip** ✅ (212 punti / 10 = 21,2 pip su 5 decimali) |
| ATR(14) H4 | **17 pip** (letto _"0.17"_ 🟠 — su 5 decimali l'indicatore mostra 0,00170) |
| SL a 2 ATR | **34 pip** |
| livello di stop individuato | **0,89906** |
| **SL effettivamente piazzato** | **0,89890** → **1,6 pip sotto** il livello (regola del numero tondo) |
| **TP piazzato** | **0,90556** |

🧮 **Verifica di coerenza (fatta da noi, torna):**
`entry ≈ SL + 2 ATR = 0,89890 + 0,00340 = 0,90230`
`TP − entry = 0,90556 − 0,90230 = 0,00326 = 32,6 pip ≈ 2 ATR (34)` ✅
_"lo metto **leggermente sotto** il livello obiettivo"_ → **coerente entro 1,4 pip.**
➡️ **E' il test di regressione migliore che l'intero corso abbia prodotto
finora**: rischio e rendimento **simmetrici a 2 ATR (R:R ~1:1)**.

### T2 — Altri valori d'esempio
| voce | valore | note |
|---|---|---|
| ATR su **D1** | **78 pip** | _"siamo in un timeframe daily"_ — 🟢 conferma che l'ATR scala col TF |
| ATR (altro esempio) | **33 pip** → _"se leggo 33 metto 33"_, 2 ATR = **66** | 🟠 accenna a togliere ~3 pip per lo spread, poi si corregge |
| ATR (break-in, lez. 25) | **25 pip** | stop sotto l'ultimo ordine |
| Conto d'esempio | **~30.000 EUR**, size totale **2,00 lotti** | → **~1,6% di rischio** (§9) |

---

## 13. 🏛️ ATTRITI CON LE REGOLE PROP (il modulo non nomina mai le prop)

| # | attrito | gravita' |
|---|---|---|
| 1 | 🔴 **Nessun tetto sulle posizioni simultanee**, su tutte le valute, senza una parola sulla **correlazione**. Sei cross col dollaro alla stessa distanza = **~10% a rischio in un verso** (§9). Contro un daily loss del 5% (`METRO_PROP.md` §2, peggior giornata nostra misurata **−2,06%**) e' una violazione a portata di **una mattina** | 🔴🔴 **il killer** |
| 2 | 🔴 **Nessun filtro notizie, mai nominato in 5 lezioni.** Il modulo **gemello** Fibo H4 lo rende obbligatorio: **lo stesso corso e' incoerente con se stesso** (`METRO_PROP.md` §7) | 🔴 |
| 3 | 🟠 **Overnight e weekend mai affrontati.** Su H4/D1 con target su EMA14 le posizioni durano **giorni** per costruzione. Il Fibo H4 vieta il weekend a voce alta; qui **silenzio** (`METRO_PROP.md` §3) | 🟠 |
| 4 | 🟠 **Umano nel ciclo per progetto**: trailing manuale, controllo _"ogni ora"_ dal cellulare, spostamento ordini _"se arriva con forza"_. Su un conto prop gestito da EA **queste regole vanno tolte o quantificate** | 🟠 |
| 5 | 🟢 **Niente martingala, niente griglia, niente hedge, niente mediare in perdita. Stop loss SEMPRE presente e ancorato all'ordine piu' grande.** | 🟢 **impianto pulito** |

---

## 14. ✅ LE ASSUNZIONI DA DICHIARARE (se si apre un round)

**Nostre, non del corso, da scrivere nel file prova PRIMA dei numeri:**

1. **Filtro dell'arrivo (§6)** — soglie `X` (ombra/range) e `Y` (corpo/range) +
   finestra temporale dentro la barra H1. **A/B on/off: e' l'esperimento n.1.**
2. **Rischio**: **0,65%** di casa (il corso non dichiara nulla; il ~1,6%
   ricostruito e' un esempio su conto reale altrui, non una regola).
3. **Tetto posizioni simultanee e per valuta** — **il corso non ne ha, noi si'.**
4. **SL 1 ATR vs 2 ATR** a sweep (il corso preferisce 2 su H4; il nostro default
   e' 1).
5. **Split della size**: 50/50 di rischio (attuale) vs ~35/65 (corso) a sweep.
6. **Distanze degli ordini**: ATR-relative (nostre) vs pip assoluti (corso).
7. **Fuso**: 08:00 IT = 07:00 BCM `[INFERITO]`; **e l'allineamento delle candele
   H4 dipende dal broker** → da dichiarare.
8. **Break-in/break-out (lez. 25)**: EA nuovo, non una variante di
   `ABTG_EMA200` — il segno del trade e' opposto.

🚫 **NON si implementano:** _"lo faccio dal cellulare ogni ora"_, il trailing
manuale a occhio, lo spostamento ordini _"se arriva con forza"_ senza soglia, il
target _"sempre la media"_ della lez. 25 (§10, incoerente), la definizione di
segnale della lez. 21 (§4.2, contraddice le lez. 22-24).

---

## 15. 🖼️ COSA ERA A SCHERMO E NON NEL PARLATO (domande per Claudio)

| # | cosa manca | perche' conta |
|---|---|---|
| 1 | 🔴 **Le SLIDE** (_"ritorniamo alle slide"_ ×6, mai lette) | Nel Breakout hanno chiuso 6 ambiguita' su 10 |
| 2 | 🔴 **Un esempio grafico di "spike" e di "candela piena"** (minuti in cui li indica in lez. 23/24) | E' **l'unico filtro d'ingresso** del corso e serve per calibrare X e Y (§6) |
| 3 | 🔴 **La % di rischio** insegnata da questo relatore | Mai detta in 5 lezioni (§9) |
| 4 | 🟠 **Il fuso della piattaforma** (orologio MT4) | Su H4 sposta l'allineamento delle candele (§3) |
| 5 | 🟠 Il pannello Moving Average (conferma EMA/close) e quello ATR | Il parlato e' gia' chiaro: serve solo come conferma |
| 6 | 🟠 Prezzi/date degli esempi AUDCHF ed EURJPY | Per estendere il test-case oltre AUDCAD |
| 7 | 🟠 **Esiste un backtest di questa strategia nel corso?** | In 5 lezioni **zero numeri**: se un documento esiste, e' altrove |
