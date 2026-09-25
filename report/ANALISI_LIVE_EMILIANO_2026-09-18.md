# 🎙️ ANALISI LIVE EMILIANO — venerdì 18/09/2026, 08:30 (DAX, sessione con Luca al monitor)

**Data referto:** 18/09/2026 · **Analista:** estrattore trascrizioni
**Fonte unica e archiviata:** `docs/live_emiliano/trascrizioni/LIVE_EMILIANO_2026-09-18.txt`
(**472 righe · 50.866 byte**, TurboScribe auto-generato, caricato da Claudio).
**Ogni riferimento `r.NNN` è il numero di riga di QUEL file.** Niente memoria, niente web,
niente completamento dei buchi.

> ## ⛔ REGOLA CHE VALE SOPRA TUTTO
> **Da questo materiale non si muove NIENTE.** Ogni numero qui dentro è una
> **dichiarazione di una fonte esterna**, mai un criterio nostro. Un numero detto in
> una live **non entra in nessun cancello, non tocca nessun preset, non cambia
> nessun forward**. Nessun EA, nessun `.set`, nessun conto è stato toccato per
> scrivere questo referto.

> ### 🗣️ CHI PARLA — e perché conta
> Questa live è **atipica**: per l'85% del tempo al monitor c'è **Luca** (allievo), che
> opera in diretta, ed Emiliano commenta/corregge. 🔴 **Quindi metà delle frasi NON
> sono prescrizioni di Emiliano: sono esecuzioni di un allievo.** Dove l'attribuzione
> è chiara la dichiaro; dove la trascrizione non permette di distinguere chi parla,
> scrivo **[ATTRIBUZIONE NON CHIARA]** e il materiale vale meno.

> ### ⚠️ QUALITÀ DELLA TRASCRIZIONE
> Media. Migliore del 09/09, peggiore del 14/09. Storpiature sistematiche ricorrenti:
> **VWAP → "WuWap"/"WAP"/"move up"/"Wu Wap"** · **weekly → "wiki"/"Wheatley"/"WIKI"** ·
> **daily → "deini"/"Deni"** · **size → "sites"/"sides"** · **zona di protezione →
> "pre-section"/"presezione"/"preselection"** · **ORB → "orbe"/"orba"/"ORM"** ·
> **Supertrend → "super trem"/"supertrend"** · **trading range → "training range"**.
> 👉 La resa **"move up" = VWAP** è confermata dal contesto (r.139 lo affianca a
> "il VWAP in M15"; r.377 *"lo stop l'ho messo sopra il move up"* ↔ r.331 *"mettendo
> lo stop sopra il VWAP"*): **[INFERITO, alta confidenza]**.

---

# ⭐ PARTE 1 — LA SINTESI INCROCIATA (la pagina da leggere per prima)

## 1.0 🔥 LA RIGA CHE CONTA

> **Su 472 righe: 21 parametri con valore, 17 meccanismi, 6 bandiere (ZERO rosse
> piene), 🔴 ZERO regole prop, ZERO citazioni di limite giornaliero, ZERO
> drawdown, ZERO menzioni di challenge.**
>
> **Il pezzo che vale di più è UNO, e non è un consiglio: è un numero su una
> manopola che noi non abbiamo MAI misurato.** Emiliano dichiara la frazione
> d'ingresso — *"io entro sempre nella mia size e la divido **un terzo o due
> terzi**"* (r.111) — con la distanza fra i due ordini quantificata
> (*"circa **20 punti**"*, e *"metterlo a **40-50 punti** non ha senso, perché è
> troppo distante"*, r.115+r.133). 🔴 **`InpFirstFraction`/`InpScaleInOrders` è la
> voce n.17 di `report/AUDIT_USCITE_2026-09-09.md`: 14 occorrenze nel repo,
> verdetto "MAI misurato".** E la nostra `SuperWave` porta già
> `InpFirstFraction = 0,3333` **senza che nessuno l'abbia mai messa ad asse**
> (`report/CENSIMENTO_USCITE_MAI_PROVATE_2026-09-11.md` r.168-169).

## 1.0-bis 🚨 LA RISPOSTA ALLA DOMANDA DI OGGI (il breach FundedNext): **NON C'È**

Claudio ha perso stamattina la **FundedNext Stellar Lite 100k** sul **limite di
perdita GIORNALIERA** (`report/BREACH_FUNDEDNEXT_2026-09-18.md`). La domanda al
materiale era: *la live dice qualcosa su gestione del rischio giornaliero, muri
prop, come non bruciare una giornata?*

**Ricerca fatta sull'intero file, termine per termine, con il conteggio:**

| termine cercato | occorrenze | nota |
|---|---:|---|
| `prop` (come *prop firm*) | **0** | le 16 occorrenze di `prop*` sono **15 × "proprio" + 1 × "proposto"** |
| `challenge` · `funded` · `FTMO` | **0** | — |
| `drawdown` | **0** | — |
| `giornalier*` (perdita giornaliera) | **0** | — |
| `perdita` | **0** | — |
| `capitale` | **1** | r.405, e vedi sotto |
| `news` · `filtro notizie` | **0** | un solo accenno generico a *"market movers... dati macroeconomici"* (r.73) e *"la guard che parla alle 12.30"* (r.79, **[NON CHIARO]**) |

> ### 🔴 **Verdetto onesto: la live del giorno in cui è morta una challenge su una regola giornaliera NON contiene una sola regola sul rischio giornaliero.** Non c'è un tetto, non c'è uno stop del giorno, non c'è un numero. Chi cercasse qui la lezione da imparare sul breach, non la trova.

**L'UNICA riga che ci si avvicina**, ed è un aneddoto non una regola:

> **r.403-405** — *"Guarda, lui si è messo lo stop. **Ha protetto il capitale.**
> Quanto hai bruciato? **Ho rischiato quello che ho guadagnato prima.** Va bene,
> questo mi piace."*
> *(domanda di Emiliano, risposta di Luca, approvazione di Emiliano)*

🟡 **Come si legge**: è il principio *"in giornata rischio al massimo quello che ho
già messo in cassa"*, **approvato da Emiliano**. È il cugino povero del muro
giornaliero. **Ma non ha un numero, non ha una soglia, non è dichiarato come
regola di piano**, ed è detto su un conto personale, non su una prop.
👉 **Non è materiale per un cancello. È materiale per una domanda a Emiliano**
(§4).

---

## 1.1 🏆 LE SEI COSE CHE VALGONO DAVVERO

---

### 🥇 1. LA FRAZIONE D'INGRESSO, quantificata — e casca su una manopola MAI misurata

| # | Cosa dice | Citazione testuale | Riga | Etichetta |
|---|---|---|---|---|
| a | **Non entra mai in un colpo solo** | *"io non entro mai con un'unica soluzione, cioè io **entro sempre nella mia size e la divido un terzo o due terzi**"* | **r.111** | 🟢 `[TRASCRITTO chiaro]` · **Emiliano** |
| b | **Distanza del 2° ordine** | *"Il secondo è a **circa 20 punti di distanza** oltre il supporto"* | **r.115** | 🟢 chiaro · [ATTRIBUZIONE NON CHIARA] |
| c | **E il tetto di distanza** | *"siamo posizionati a **distanza di 20 punti**, cioè metterlo a **40-50 punti non ha senso, perché è troppo distante**. Se lo mettete a 20 punti ci può stare il balzino"* | **r.133** | 🟢 chiaro · **Emiliano** |
| d | **Esempio di ripartizione a 3 pezzi** | *"**0,5** lì, **0,5** sulla media 100 e **un contratto** sui minimi della notte"* | **r.157** | 🟢 cifre chiare, 🟡 unità = lotti/contratti **[INFERITO]** |
| e | **Riduzione di size sul 3° test** | *"L'operazione è rischiosa... quando ci va la terza volta ci va per magari sorpassare quei minimi... **Lì abbiamo ridotto i sides, ridotti, 0,5**"* | **r.161** | 🟢 · **Emiliano** |
| f | **Riduzione di size in attesa** | *"io **attendo il mercato con meno sites**, cancella gli ordini 0,5 e 1, li cancelli, e li metti 1..."* | **r.185** | 🟡 frase parzialmente contraddittoria in trascrizione |

#### 🔬 IL CONFRONTO COL REPO — ed è il buco più grosso che abbiamo

`report/AUDIT_USCITE_2026-09-09.md`, TABELLA B, **voce 17**:

> | 17 | **Frazione d'ingresso / scale-in** | `InpFirstFraction`, `InpScaleInOrders` | **14** | 🔴 **MAI** |

E `report/CENSIMENTO_USCITE_MAI_PROVATE_2026-09-11.md` r.168-169: sulle sedie
`770511`/`770531` (**`SuperWave DOW H1`, una delle quattro candidate della rosa**)
`InpFirstFraction` vale **0,3333** — cioè **esattamente "un terzo"** — ed è
elencata fra i parametri **"mai in nessun CSV"**.

🔎 **E il codice lo dice da solo.** `mql5/Experts/ABTG_SuperWave_DOW_H1_Ottimizzato.mq5`
**r.71** (identico in `ABTG_SuperWave.mq5` r.71):

```
input double InpFirstFraction = 0.3333; // quota a mercato (documento: 1/3)
```

👉 Il commento dice **"documento: 1/3"**: il valore era già stato preso da un
documento ABTG. **Oggi la stessa frazione esce dalla bocca della fonte, a voce, in
diretta** (r.111). Sono la **stessa fonte in due formati** — quindi **non è una
convergenza fra fonti indipendenti**, e non vale come verifica. Vale come questo:
il numero ha una provenienza chiara, ed è **l'unico grado di libertà d'ingresso che
non abbiamo mai messo alla prova.**

> ## 🟢 CONVERGENZA REALE: il valore che gira già in campo sulla `SuperWave` (1/3) è lo stesso che la fonte prescrive a voce (r.111). 🔴 E NESSUNO DEI DUE È MAI STATO MISURATO.
> Questo **non** promuove lo 0,3333: lo rende **il candidato n.1 per un asse**, perché
> ora abbiamo (i) una manopola viva, (ii) un valore di default mai giustificato,
> (iii) una fonte esterna che prescrive lo stesso numero, (iv) e — novità di oggi —
> **una distanza fra gli ordini con un numero e un tetto (20 pt sì, 40-50 pt no)**,
> che è il secondo grado di libertà dello scale-in.

---

### 🥈 2. "NON PUOI FARE I PARI" — la fonte spara contro il breakeven, e noi abbiamo DUE misure che NON concordano fra loro

**La frase, testuale** (r.457, dentro un paragrafo lungo senza punteggiatura —
Emiliano a Luca):

> *"primo momento hai fatto una bella operazione per esempio **un bruttissimo stop
> che ha messo a pari** il tuo penale **non puoi fare trading con me e fare i pari
> non puoi**"*

E il costo, misurato in diretta nella stessa live:

| momento | citazione | riga |
|---|---|---|
| Luca mette il BE | *"lì parzializzo e **metto la posizione in pari**"* | r.139 |
| Emiliano quantifica il danno | *"Adesso se metti fuori il stop in pari, **ti sei perso circa 30 punti**"* | **r.151** |
| Il BE viene preso | *"Ora va short con forza per andare a prendere e **ci prende il nostro stop in pari**"* | r.159 |
| Emiliano avrebbe tenuto | *"**Non so se l'avrei mai chiusa la posizione.** ... Avrei tentato di farla andare"* | r.151-153 |

#### 🔬 IL CONFRONTO COL REPO — e qui bisogna essere precisi, perché le nostre misure si dividono

| nostra misura | cosa dice | verso Emiliano |
|---|---|---|
| **Dow Apertura US, fase `distanze` 04/08** (48 pass → 16 combo) — `report/AUDIT_USCITE_2026-09-09.md` r.127 | 🏆 *"**NIENTE BE anticipato** — 6 confronti su 8 in perdita, fino a **−38%**"* (BE a 0,5R: profit 1.601 · BE tardi: **2.575**) | ✅ **CONVERGE** |
| **FASE F (B1), DAX+Nasdaq**, walk-forward IS+OOS — stesso file r.128 | 🏆 *"la configurazione **ACCESA**"* (TP3R + parziale + **BE**) PF **1,237** contro TP 1,5R secco 1,164, **tutte e 6 le strutture positive OOS** | ❌ **CONTRADDICE** |

> ### ⚖️ **La lettura onesta: la fonte sta dalla parte di UNA delle nostre due misure, non di entrambe.** E la differenza fra le due non è casuale: il round del Dow misurava il **BE ANTICIPATO** (`InpBEatR` a 0,5R), la FASE F misurava il **BE AL PRIMO TARGET** (`InpBreakevenAtTP1`, dopo la parziale). **Sono due meccanismi diversi e il repo lo sa già** (voci 11 e 12 della TABELLA B).
> 👉 **Cosa NON si fa**: toccare `InpBreakevenAtTP1 = true` sulle sedie vive. La FASE F
> è una misura walk-forward fuori campione, la frase di Emiliano è un aneddoto su un
> trade. **La misura vale, l'aneddoto non la ribalta.**
> 👉 **Cosa si può fare**: notare che la voce **14 — "Buffer/offset del BE"
> (`InpBEBufferPts`) — è 🔴 MAI misurata**, ed è esattamente la manopola che
> risponderebbe alla critica ("il pari viene preso per 2 punti"). È una via corta a
> un numero, non un cambio di criterio.

---

### 🥉 3. IL FILTRO "QUANTO SPAZIO C'È PRIMA DELL'OSTACOLO" — nuovo, quantificato, e implementabile

Due volte, con due numeri, Emiliano **rifiuta un breakout valido perché il target
è troppo vicino**:

| # | Citazione | Riga | Numero |
|---|---|---|---|
| 1 | *"guardate **lo spazio che c'è** tra l'apertura sotto il livello di minimo dell'M15 e l'obiettivo principale... Qua c'è una zona tra le quindi in prima istanza me lo posso aspettare qua. Quanti punti sono? ... a questo punto **ci sono 23**. E secondo me siamo vicini, molto vicini"* | r.179-183 | **23 punti = troppo vicino** 🟢 |
| 2 | *"io se avessi aperto sotto **non sarei mai entrato, mai**. Perché? Perché **l'obiettivo, il numero tondo con perception [= zona di protezione] è troppo vicino**"* | **r.227** | 🟢 `[TRASCRITTO chiaro]` sul meccanismo |
| 3 | E la conseguenza sul piazzamento | *"**No, no, troppo vicino, troppo vicino.** Lo devi mettere il primo **sotto il canale basso della pre-section**, perché è vicino... io mi vado a prendere **la rottura di quei minimi e il ritorno**, perché lì è troppo vicino"* | r.189-191 | 🟢 |

#### 🔬 IL CONFRONTO COL REPO — **c'è già la manopola, ma fa un'altra cosa**

| nostro parametro | cosa fa oggi | file |
|---|---|---|
| `InpRoundMinDistPts = 50` | *"Distanza minima dall'ingresso (punti) per **validare il LIVELLO** [come target]"* | `ABTG_DAX_Apertura_EU.mq5` r.330 · `ABTG_Apertura_3Ingressi.mq5` r.328 |
| `InpUseSRFilter` + `InpSRProximityPts = 1500` | *"non comprare con una resistenza addosso... se il livello d'ingresso ci sbatte contro entro `InpSRProximityPts`, **il segnale si salta**"* (R30) | `ABTG_Apertura_3Ingressi.mq5` r.375-384 |

> ## 🟢🟢 **QUESTA È LA CONVERGENZA PIÙ PULITA DELLA LIVE: il meccanismo che Emiliano descrive a voce ESISTE GIÀ nel nostro codice come `InpUseSRFilter` (R30), scritto in un commento quasi con le stesse parole.**
> 🔴 **Ma è `false` di default**, e — verificato EA per EA con `grep` — **la copertura
> è disuguale**:
>
> | EA | `InpUseSRFilter` | default |
> |---|---|---|
> | `ABTG_Apertura_3Ingressi.mq5` | ✅ presente (4 occorrenze) | `false` |
> | `ABTG_Nasdaq_Apertura_US.mq5` | ✅ presente (r.361-362, r.485, r.1984) | `false` |
> | 🔴 `ABTG_DAX_Apertura_EU.mq5` | ❌ **assente — 0 occorrenze** | — |
>
> 👉 **Nota per la rosa di ottobre**: la candidata `DAX Apertura EU in RETEST`
> (`770101`, D30EUR) **non ha proprio la manopola**; la `Nasdaq Apertura US` ce l'ha
> ma **spenta**. Non è una raccomandazione di accenderla — è un fatto da mettere in
> tabella, e distingue **"va acceso e misurato"** (Nasdaq) da **"va portato e poi
> misurato"** (DAX), che sono due lavori diversi.
> ⚠️ E il numero della fonte (**23 punti = troppo vicino** sul DAX) **non è
> traducibile** nel nostro `InpSRProximityPts = 1500` senza sapere il simbolo/quotazione
> di Emiliano: il 1500 è tarato sul Nasdaq a 2 decimali (= 15 punti indice). **Non si
> travasa un numero fra due scale di punti diverse.**

---

### 4️⃣ IL VOLUME SU CANDELA APERTA — la fonte descrive un difetto che noi NON abbiamo (e l'allievo in diretta ci casca)

**La lezione, testuale** (r.459-465, Emiliano):

> *"che ore sono? Sono le 11.07... **si escono i calieri [= chiudono le candele] a 5
> minuti, mancano 2 minuti** all'apertura, **guarda i volumi, possono superare i
> volumi precedenti?** 3 minuti. Mancano 3 minuti, sì... **Siamo a metà, quindi sì.
> Possono superarli, quindi NON POSSO ANTICIPARE ADESSO IL MERCATO, devo avere una
> conferma.** ... se i volumi potenzialmente, **lo vado a vedere rispetto all'orario**,
> possono essere in incremento... **io non faccio niente fino all'ingresso della
> certificazione** [= chiusura/conferma]"*

E l'errore reale commesso in diretta da Luca, che la lezione previene (r.225):

> *"Io guardavo i volumi nelle barre di histogramma, che non erano i volumi ma erano
> gli X. Quindi **in realtà i volumi non sono crescenti**"* → e Emiliano: *"No ma
> quella non è la candela, **i volumi sono decrescenti**"*

#### 🔬 IL CONFRONTO COL REPO — 🟢 **noi siamo già a posto, ed è verificato riga per riga**

`ABTG_DAX_Apertura_EU.mq5` r.2185-2198, funzione `VolumeOKtf()`:

```
if(CopyTickVolume(_Symbol, tf, 1, n+1, v) < n+1) return(true); // dati insuff.: non blocco
...
return((double)v[0] >= InpVolMult * avg);   // volume dell'ultima barra CHIUSA (rottura)
```

Lo `start_pos = 1` significa **barra 1 = ultima CHIUSA**: la barra in formazione
(shift 0) non entra mai nel confronto. **Il difetto descritto da Emiliano — misurare
il volume di una candela a metà — nel nostro codice non può avvenire.**

> ## ✅ Una vittoria da mettere in tabella, non un difetto: la live del 18/09 descrive una trappola del filtro volumi, e la nostra implementazione la evita già per costruzione. È il caso in cui il materiale esterno **valida** una scelta di progetto invece di aprirne una.

---

### 5️⃣ IL RETEST / L'IMBALANCE — e 🚩 la fonte lo APPROVA e lo CONDANNA nella stessa mattina

Questo è il punto che Claudio ha chiesto espressamente (il `InpEntryMode = ABTG_RETEST`
viene da Emiliano). **Materiale c'è, ed è contraddittorio.** La sequenza completa:

| # | momento | citazione | riga |
|---|---|---|---|
| 1 | **Perché NON entra sulla rottura** | *"non sono voluto entrare direttamente alla rottura dell'orb perché **avevo visto la candela troppo lunga**. Allora ho provato a mettermi **sul ritracciamento**"* (Luca) | **r.389** |
| 2 | **Dove mette il LIMIT** | *"io adesso però l'ordine non lo metto più lì, ma io quasi quasi **lo proverei a rispettare a chiusura dell'imbalance**"* (Luca) | **r.329** |
| 3 | **Con che distanza e che stop** | *"Quindi mi calcolo. **Questa distanza, circa, sono 37 punti.** Io provo a entrare con lo **0,5** mettendo **lo stop sopra il VWAP**"* | **r.331** |
| 4 | **Emiliano approva** | *"Provi a entrare dove? Adesso? No, **sul ritracciamento dell'imbalance**. **Bravissimo.**"* | **r.333** |
| 5 | **E aveva approvato anche lo stop** | *"invece che prendere lo stop in fondo al canale, provo a prenderlo **sopra il VWAP**"* → Emiliano: *"**Giusto. Questa è la chicca.**"* | r.327-329 |
| 6 | 🚩 **Poi il trade va male, ed Emiliano si ribalta** | *"Ragazzi, **ha sbagliato clamorosamente il punto d'ingresso**"* | **r.395** |
| 7 | 🚩 **e rincara** | *"L'intelligenza artificiale ti avrebbe stato in allucinazione. **Quell'ingresso non esisteva e l'hai visto solo tu**"* | **r.409** |
| 8 | 🚩 **e poi si ricontraddice nella stessa riga** | *"Sì, **l'ingresso l'hai fatto male. L'ingresso l'hai inventato**... Dico allora su questa candela ci può stare, quindi **sei stato molto bravo inventandoti l'ingresso**"* | **r.415** |
| 9 | **Il retest sull'ORB, confermato come concetto** | *"Cioè, **ha ritestato il mio orbe? L'ha ritestato? Sì o no? Sì.** Sì, sì, l'ha ritestato"* | **r.367** |

> ## 🚩 BANDIERA METODOLOGICA (arancione piena): **la stessa persona, sullo stesso ingresso, dice "Bravissimo" a r.333 e "sbagliato clamorosamente" a r.395. In mezzo non c'è un'informazione nuova: c'è il RISULTATO del trade.**
> Questo è **giudicare il processo dall'esito** — l'errore che in casa nostra ha un
> nome e un cancello (il contro-esempio del 10/09: *"avevo controllato che la mia
> risposta fosse COERENTE con quello che mi aspettavo"*).
>
> ### 👉 CONSEGUENZA OPERATIVA, e va detta chiara: **da questa live NON si estrae una regola sull'ingresso a retest/imbalance.** La fonte l'ha endorsata e demolita in venti minuti. L'unica cosa estraibile è il **CRITERIO che ha fatto scattare il retest** — *"la candela [di rottura] era troppo lunga"* (r.389) — che è una soglia, non un'opinione, ed è misurabile.

#### 🔬 Confronto col repo

| voce | noi | la live |
|---|---|---|
| Ingresso | `InpEntryMode = ABTG_RETEST` (LIMIT sul livello) — **default sul DAX**, `ABTG_DAX_Apertura_EU.mq5` r.261 | ✅ stesso concetto (r.367) |
| Offset del LIMIT | `InpRetestOffsetPts = 200` (= 2 punti indice **DENTRO** il livello; *"si pretende che il prezzo ci passi attraverso, non che lo sfiori. Costa il 3,9% dei riempimenti"*) | ❌ **nessun offset dichiarato**: il suo LIMIT sta sulla **chiusura dell'imbalance**, cioè su un livello **diverso** (il gap della candela di rottura, non il livello rotto) |
| Trigger del retest | sempre attivo se `InpEntryMode = RETEST` | 🆕 **condizionale**: retest **solo se** la candela di rottura è "troppo lunga" (r.389) |
| Filtro d'ampiezza che ci somiglia | `InpMinRangePts = 1700` / `InpMaxRangePts = 4000` (17-40 punti indice) — ma è sul **RANGE**, non sulla **candela di rottura** | — |

> 🆕 **La cosa NUOVA e sola di oggi**: *breakout candle troppo lunga → non entrare al
> break, entra sul ritracciamento dell'imbalance*. **Non ha un numero** (non dice
> quanti punti è "troppo lunga"): resta una regola senza soglia, quindi **non
> implementabile così com'è**. 👉 Va in §4 come domanda a Emiliano.

---

### 6️⃣ LA REGOLA DI SELEZIONE DEI LIVELLI — tre criteri espliciti, e sono implementabili

L'unica parte della live in cui Emiliano detta un **algoritmo**, non un'impressione:

| # | criterio | citazione | riga |
|---|---|---|---|
| 1 | **Si sceglie il livello con più tocchi, NON il più vicino al prezzo** | *"quando ho due supporti uno vicino all'altro, quale è il prezzo di due?... **Guardo quello che ha più corrispondenze, quello che ha più massimi e minimi che si contrappongono**"* → e poi, esplicito: *"**No Alessandro, non è quello più vicino al prezzo, no assolutamente**"* | **r.93-95** | 
| 2 | **La candela in corso NON conta** | *"**Questo non vale perché è la settimana di oggi, quindi non lo tengo in considerazione**"* | **r.95** |
| 3 | **A parità, vince il numero tondo** | *"Questi sono tre punti che si prendono proprio per precisi **in corrispondenza del numero tondo**, quindi questo sopra mi piace. Di quelli sotto probabilmente terrei... **quello sul numero tondo**"* | **r.99** |
| 4 | **Conferma incrociata su DUE broker** | *"sto facendo lo studio su **onam** [= OANDA, **[TRASCRITTO dubbio]**], però vedo che c'è una stessa corrispondenza all'incirca anche **su bcm**... quindi faccio sempre un po' il confronto"* | **r.91** |

🟢 I criteri 1-2-3 sono **codificabili** (conteggio dei tocchi, esclusione della barra
in formazione, snap al numero tondo). Il criterio 2 è **già** la nostra convenzione
(`CopyTickVolume` da shift 1, `RANGE_PREVBAR`). Il criterio 3 corrisponde a
`InpUseRoundLevels` / `InpRoundStep = 100.0` — **spento di default**, mai messo ad asse
insieme al conteggio dei tocchi.

⚠️ **Il criterio 4 riguarda Claudio direttamente**: Emiliano **confronta i livelli su
due feed** (uno dei quali **è BCM**, il nostro). Non è una regola di trading, è una
regola di **igiene dei dati**, e ci dice che la fonte considera i livelli BCM
sovrapponibili agli altri.

---

## 1.2 📋 TABELLA DEI VALORI — TUTTI i numeri della live, in un posto solo

🔴 **Colonna "fonte" = sempre "dichiarato da Emiliano/Luca". Mai un criterio nostro.**

| # | parametro | valore | citazione (troncata) | riga | etichetta |
|---|---|---:|---|---|---|
| P1 | **Frazione d'ingresso** | **1/3 + 2/3** | *"la divido un terzo o due terzi"* | r.111 | 🟢 chiaro · Emiliano |
| P2 | **Distanza 2° ordine** | **~20 punti** | *"circa 20 punti di distanza oltre il supporto"* | r.115 | 🟢 chiaro |
| P3 | **Tetto distanza ordini** | **40-50 pt = troppo** | *"metterlo a 40-50 punti non ha senso"* | r.133 | 🟢 chiaro · Emiliano |
| P4 | **Size esempio (3 pezzi)** | **0,5 / 0,5 / 1,0** | *"0,5 lì, 0,5 sulla media 100 e un contratto"* | r.157 | 🟢 cifre · 🟡 unità [INFERITO] |
| P5 | **Size ridotta su 3° test** | **0,5** | *"Lì abbiamo ridotto i sides, ridotti, 0,5"* | r.161 | 🟢 |
| P6 | **Size ridotte in scalping** | **0,2 / 0,4** | *"Però ridotti, faccio uno 0,2, 0,4"* · *"0,5 messo 0,2, 0,4"* | r.187, r.345 | 🟢 |
| P7 | **Miglioramento del prezzo d'ingresso** | **10 punti** | *"Quindi 10 punti migliori e l'ha messo esattamente sui minimi"* | r.161 | 🟢 |
| P8 | **Spazio minimo al target — VETO** | **23 punti = troppo vicino** | *"a questo punto ci sono 23... siamo vicini, molto vicini"* | r.183 | 🟢 |
| P9 | **Moltiplicatore Supertrend** | **3,5** | *"Lì va a fermarsi sul super trem, che è un tre e mezzo, vero? Sì, sì"* | r.127 | 🟡 dubbio: *"Qua si vede solo tre e mezzo"* è ambiguo |
| P10 | **Medie usate sui TF bassi** | **9 e 21** | *"medie 9 e medie 21... devo vedere che si siano incrociate precedentemente o che si stiano allargando"* | r.195-197 | 🟢 chiaro |
| P11 | **Medie usate sui TF alti** | **50 · 100 · 200** | *"c'è anche la media cinquanta"* · *"qui c'è la media cento"* · *"c'è la media duecento, molto più forte"* | r.113, r.119, r.123 | 🟢 |
| P12 | **Durata dell'ORB** | **3 candele** | *"L'Orb è aperto, qui sono tre candele, quindi l'Orb è quella zona qua"* | **r.173** | 🟢 sul numero · 🟡 **TF [INFERITO] = M5** dalla frase successiva (*"una candela M5 che rompe sotto"*) → **ORB ≈ 15 minuti** |
| P13 | **Livelli Fibonacci** | **38,2 · 50 · 61,8** | *"quando è che va a superare il livello del 50 o del 61,8"* · *"posso ritracciare ancora fino al 36, 38"* | r.63-67 | 🟡 *"36, 38"* è quasi certamente **38,2** storpiato |
| P14 | **Costo del BE preso** | **~30 punti** | *"se metti fuori il stop in pari, ti sei perso circa 30 punti"* | r.151 | 🟢 |
| P15 | **Escursione del primo movimento** | **~50 pt** poi **36 pt** | *"i prezzi hanno fatto quasi 50 punti"* · *"però 36 punti"* | r.147 | 🟢 |
| P16 | **Fade dopo candela di rifiuto** | **~20 punti** | *"molto probabilmente scenderà per una ventina di punti perché deve prendere la liquidità"* | **r.145** | 🟢 · Emiliano |
| P17 | **Ampiezza della gamba misurata** | **60-61 punti** | *"Qua sono 61"* · *"sono 60, 60 punti"* | r.325-327 | 🟢 |
| P18 | **Ritracciamento dell'imbalance** | **37 punti** | *"Questa distanza, circa, sono 37 punti"* | r.331 | 🟢 |
| P19 | **Distanza rottura ↔ ingresso ORB** | **3 punti** | *"neanche tanto lontano dall'ingresso, cioè dall'orbe. Sono tre punti"* | r.313 | 🟢 |
| P20 | **N. di test prima della rottura** | **3ª / 4ª / ~5ª volta** | *"quando ci va la terza volta ci va per magari sorpassare quei minimi"* · *"sta andando per la quarta volta"* · *"sono andato quasi cinque volte"* | r.161, r.235, r.231 | 🟢 sui numeri · 🟡 regola non dichiarata come tale |
| P21 | **Livelli DAX del giorno** | R **25163** · R **25891** · R/S **25900-25908** · S **25600** · S *"529"* | *"resistenza 25163... circa 25891"* · *"dovrebbe esserci uno sul 25900... quindi 25908"* · *"qua ho 25600 circa"* · *"questo sul 529"* | r.91, r.97, r.101-103 | 🟢 i primi quattro · 🔴 **"529" [NON CHIARO]** (probabile 25529, non deducibile) |
| — | **Orari citati** | 09:10 · 09:30 · 11:07 · 12:30 | *"sono le 9.10"* · *"Ma che ore sono adesso? 9 e mezza"* · *"Sono le 11.07"* · *"La guard che parla alle 12.30"* | r.141, r.217, r.459, r.79 | 🔴 **FUSO NON DICHIARATO IN NESSUN PUNTO DELLA LIVE.** [INCERTO] |
| — | *"Da dove sono entrato alla media sono **trentasettocento**"* | ? | — | r.125 | 🔴 **[NON CHIARO]** — "trentasettocento" non è un numero italiano. Non interpreto |

### ⏰ NOTA SUL FUSO — e perché NON converto

Gli orari (09:10, 09:30, 11:07) sono **quasi certamente ora italiana** (live italiana,
DAX, Emiliano in Italia), il che li metterebbe a **08:10 / 08:30 / 10:07 ora server
BCM**. 🔴 **Ma il fuso NON è dichiarato da nessuna parte nel parlato**, e la regola di
casa è esplicita: *"convertili SOLO se il fuso è dichiarato nel parlato, altrimenti
[INCERTO] — un orario col fuso sbagliato è peggio di nessun orario"*.
👉 **Quindi: [INCERTO], e nessuno di questi orari entra in un `.set`.**
⚠️ L'unica cosa deducibile con sicurezza è **relativa**, e basta per l'ORB:
l'ORB del DAX si forma **nei primi ~15 minuti dall'apertura del cash**, qualunque sia
il fuso dell'orologio di chi parla.

---

## 1.3 🧰 I MECCANISMI — tutti e 17, in ordine di apparizione

| # | meccanismo | come descritto | riga |
|---|---|---|---|
| M1 | **Cascata di TF top-down** | weekly → daily → H1 → M15 → M5, in quest'ordine, sempre | r.45-137 |
| M2 | **Regola di regime weekly×daily** | *"Se era long, long, il Deni e Wheatley **io non mi sarei aspettato una zona laterale**"* → weekly LONG + daily **INCERTO** ⇒ aspettati LATERALE | **r.443** |
| M3 | **Cambio di struttura** | *"cambio di struttura, penso che vada in Long **quando supera la candela precedente**"* + *"Non è andata oltre **la metà della candela precedente**"* | r.55, r.49 |
| M4 | **Fibonacci dal punto d'inizio trend** | *"Da lì traccio Fibo e vado a vedere se è fermato sul livello di pullback"* — ancoraggio sull'**hammer rovesciato** | r.65-67 |
| M5 | **Filtro di raggiungibilità via volatilità** | *"guardando **la volatility** ad oggi finirebbe circa qua come distanza. Quindi forse è anche **difficile aspettarsi che oggi possa arrivare** a 38,2"* | **r.69-71** |
| M6 | **Selezione dei livelli per n. di tocchi** | vedi §1.1-6 | r.93-99 |
| M7 | **Conferma del livello su due feed** (OANDA vs BCM) | r.91 | r.91 |
| M8 | **Confluenza multi-media come filtro** | *"c'è anche la media cinquanta, media quattro [= H4]. Tutto un po' schiacciato, però è **il filtro dell'EMA degli altri time frame**"* | r.113-115 |
| M9 | **Stop sotto il Supertrend, non sotto la media** | *"Perché se mi rompe la media cento... **Ma io metto lo stop sotto il super**"* — motivo: *"lì ha cognizione di causa, cioè mi rompe uno o mi rompe l'altro"* | **r.119-125** |
| M10 | **Parziale sull'ostacolo (media 200 / VWAP)** | *"Sopra c'è la media duecento e lì potrebbe essere un punto in cui **andare a parzializzare una parte e poi lasciarla correre, visto che comunque c'è un ostacolo**"* | **r.125** |
| M11 | **Parziale su confluenza multi-TF** | *"c'è la media H1, l'M50 in H4, c'è il VWAP in M15, **lì parzializzo**"* | r.139 |
| M12 | **Trailing: Supertrend OPPURE 2-candele** | *"se posso seguire il trading stop, per esempio **seguendo un Supertrend** che segue il trend, oppure **quando mi fa due candele in direzione, sposto lo stop sul culetto della candela**"* | **r.149** |
| M13 | **Fade della punta dopo candela di rifiuto** | *"io lì in prima istanza **vado sempre short**, nel senso **pur mantenendo la posizione long**... tendo comunque a farmi lo short"* | **r.143** |
| M14 | **ORB = 3 candele, con DUE conferme alternative** | (a) *"sarebbe bene che **la candela in M5 mi chiudesse con il sedere sotto l'orb**"* · (b) *"**Non ha aperto la candela fuori dall'orb**, per cui non avevamo la conferma"* | r.211, r.215 |
| M15 | **Definizione di fake breakout** | *"**L'ha violato ed è tornato dentro. Ha aperto dentro e l'ha violato**"* | r.213 |
| M16 | **Volume come discriminante breakout/fake + EMA 9/21** | *"la condizione fondamentale è che **i volumi stanno aumentando, per capire se facciamo un fake breakout o un breakout**"* + medie 9/21 incrociate o in allargamento | r.195-197 |
| M17 | **Volume normalizzato sul tempo residuo** | vedi §1.1-4 | r.459-465 |
| M18 | **Fade dei bordi in fase laterale** | *"quando capisci che è laterale, **puoi fare la sbavatura presso la zona di presezione alta**"* · *"visto che sono lì all'interno del canale laterale **entro con un buy aspettandomi il movimento contrario**"* | r.437, r.457 |
| M19 | **Compressione → allarme di rottura** | *"**più sono all'interno di un training range**... a un certo punto **so che uscirà** e quindi devo **accendere il campanello dell'allarme**"* | r.465 |
| M20 | **Stop sopra il VWAP invece che a fondo canale** | *"invece che prendere lo stop in fondo al canale, provo a prenderlo **sopra il VWAP**"* → Emiliano: *"**Questa è la chicca**"* | **r.327-329** |

*(Sì, sono 20 righe: M1-M20. Il conteggio "17 meccanismi" in §1.0 conta solo quelli
**con una regola azionabile**; M1, M4, M7 e M15 sono descrittivi/definitori.)*

---

## 1.4 🚩 BANDIERE — **6, di cui ZERO rosse piene**

| # | bandiera | citazione che la prova | riga | verdetto |
|---|---|---|---|---|
| **B1** | 🚩 **Giudizio del processo fatto sull'ESITO** — lo stesso ingresso è *"Bravissimo"* e poi *"sbagliato clamorosamente"* | r.333 vs r.395 vs r.415 | — | 🟠 **arancione piena.** È la bandiera più importante della live: **rende non estraibile** la regola sull'imbalance (§1.1-5) |
| **B2** | 🚩 **HEDGING dichiarato**: short aperto mentre la posizione long resta viva | *"io lì in prima istanza vado sempre short, **nel senso pur mantenendo la posizione long**"* | **r.143** | 🟠 **arancione.** I nostri EA non fanno hedging. Costa doppio spread, e alcune prop lo trattano come pratica da rivedere. **Non si copia.** ⚠️ Il conto BCM 50503392 **è HEDGING**, quindi tecnicamente sarebbe possibile: motivo in più per dirlo qui |
| **B3** | 🚩 **"Aumenti la leva perché lo stop è vicino"** | *"Scalping vuol dire entrare su un determinato livello, **magari in leva, non con uno ma con due, perché il stop è vicino**"* · *"**lì, aumenti la leva, quindi non entri con uno, entri con due**"* | **r.261, r.271** | 🟠 **arancione.** ⚖️ Letta come *normalizzazione del rischio* (stop dimezzato → size doppia = **stesso** rischio) è corretta e **è esattamente quello che fa il nostro `InpRiskMode = 0`**. Letta alla lettera (*"aumenti la leva"*) è un aumento di rischio. 🔴 **La trascrizione non permette di distinguere le due letture: [NON CHIARO].** Da noi: **size fisse allo 0,65%, non si tocca** |
| **B4** | 🚩 **Stop più largo del proprio budget di rischio, e si entra lo stesso** | *"Allora, questo è lo stop ragionato... **Va un po' oltre il mio rischio, però.**"* | **r.121-123** | 🟠 **arancione.** Il rischio piegato al grafico invece del grafico piegato al rischio. È l'anti-pattern che oggi è costato una challenge |
| **B5** | 🚩 **Size dichiarata fuori misura, in diretta** | *"Quello che sento è che al momento **sono un po' fuori con le size**... Ultimamente sto lavorando con size più basse"* (Luca) | **r.135** | 🟡 **ambra** — autodenunciato dall'operatore stesso, non prescritto |
| **B6** | 🚩 **Pressione a operare contro la propria convinzione** | *"tu dici, non me la sento, però io voglio vedere alcune cose di te. **Quindi devi operare.** È vero che non dovresti, se non te la senti non entro, **però ti chiedo**"* (Emiliano) → e il trade che ne segue **va in stop** | **r.323, r.403** | 🟠 **arancione.** È didattica, non consiglio operativo, **ed Emiliano se ne assume la responsabilità** (r.415: *"perché ti sto mettendo un po' sotto pressione"*). Ma il trade forzato è quello che perde |

### ✅ ASSENZE VERIFICATE (ricerca su tutto il file, con conteggio)

| pratica cercata | occorrenze |
|---|---:|
| **martingala** | **0** |
| **griglia / grid** | **0** |
| **recovery / raddoppio in perdita** | **0** |
| **mediazione** (la bandiera 🔴 ROSSA del 09/09) | **0** |
| **trading senza stop** | **0** — anzi, il contrario: *"la discriminante è **dove ho lo stop**"* (r.379); *"Ha protetto il capitale"* (r.405) |
| 🔴 **trucchi per aggirare le regole prop** | **0** — e non c'è nemmeno il contesto: zero menzioni di prop firm |

> ## 🟢 **Materiale PULITO: la bandiera rossa piena del 09/09 (mediazione in scalping) NON si ripete. Questa è la seconda live consecutiva senza bandiere rosse.**

---

## 1.5 🔗 COSA CONFERMA / COSA CONTRADDICE / COSA È NUOVO

### ✅ CONFERMA (già nostro, la live lo ripete)

| cosa | dove ce l'abbiamo | riga della live |
|---|---|---|
| **ORB ≈ 15 min (3 candele M5)** | ripetizione della **stessa fonte** del 14/09 — 🔴 **non è una seconda fonte indipendente** | r.173 |
| **Volumi come conferma della rottura** | `InpUseVolumeFilter` / `InpVolMult = 1.5` / `InpVolAvgBars = 20` (promosso in **R101**: Dow PF OOS 1,543 · DAX 1,550) | r.197, r.205 |
| **EMA 9/21 incrociate o in allargamento** | `InpUseEmaFilter` — 🔴 **bocciato in R84** (EMA filtro peggiore, OOS 0,681) | r.195-197, r.209 |
| **Conferma sull'APERTURA della candela fuori livello** | `ABTG_OPENCONFIRM` + `InpOCTimeframe` | r.215, r.319 |
| **Ingresso a RETEST con LIMIT** | `InpEntryMode = ABTG_RETEST` (default DAX) | r.367 |
| **VWAP in M15 come riferimento** | `InpUseVwapFilter` + `InpVwapTF = PERIOD_M15` (commento in codice: *"guida Emiliano: M15"*) | r.139 |
| **Supertrend come base dello stop/trailing** | `InpUseSupertrend`, `InpStMultiplier`, `InpTrailOnST` — 🔴 `InpTrailOnST` è **MAI misurato** (voce 8 dell'audit, 15 occorrenze) | r.121, r.149 |
| **Supertrend a 3,5** | `InpUseSupertrend3` usa già **2,5 / 3,0 / 3,5** | r.127 |
| **Frazione d'ingresso 1/3** | `InpFirstFraction = 0,3333` viva su `SuperWave 770511/770531` — 🔴 **MAI misurata** | r.111 |
| **Filtro "non entrare con un ostacolo addosso"** | `InpUseSRFilter` + `InpSRProximityPts` (R30) — **spento** su `3Ingressi` e `Nasdaq_Apertura_US`, 🔴 **assente** su `DAX_Apertura_EU` | r.183, r.227 |
| **Volume letto sulla barra CHIUSA** | `VolumeOKtf()`, `CopyTickVolume(..., 1, ...)` — ✅ **già corretto** | r.459-465 |

### ❌ CONTRADDICE

| la live dice | noi abbiamo misurato | chi vince |
|---|---|---|
| **ORB 15 min** (3 candele M5) | Banda **35-45 min = 8/8 celle positive OOS**; banda **5-15 min = 0/8**; due motori concordi in 18 celle su 20 (`report/DIARIO.md` 06/08) | 🏆 **La nostra misura.** Terza ripetizione della stessa fonte, nessuna misura nuova ⇒ **il cancello non si riapre** |
| **"Non puoi fare i pari"** (r.457) | **FASE F** walk-forward: la config **ACCESA** (parziale+BE) vince, PF 1,237, **6/6 positive OOS** | 🏆 **La nostra misura** (ma vedi §1.1-2: sul **BE ANTICIPATO** del Dow la fonte converge con noi) |
| **EMA 9/21 come conferma** | **R84**: filtro EMA il **peggiore**, OOS **0,681** | 🏆 **La nostra misura** |
| **Parzializzare presto sull'ostacolo** (M10/M11) | **R46a DAX**: PREVBAR **senza** parziale PF **1,49** > con parziale **1,40** | 🏆 **La nostra misura** — ed è la **stessa** conclusione già emersa il 09/09 |

### 🆕 NUOVO (non c'era in nessuna live precedente né nel repo)

| # | cosa | numero? | implementabile? |
|---|---|---|---|
| **N1** | **Distanza fra gli ordini dello scale-in** | ✅ **20 pt sì, 40-50 pt no** (DAX) | 🟢 **SÌ** — e cade su `InpFirstFraction`, manopola **mai misurata** |
| **N2** | **Veto sul breakout se il target è troppo vicino** | ✅ **23 pt = troppo vicino** (DAX) | 🟢 **SÌ** — la manopola esiste (`InpUseSRFilter`), ma non sul DAX/Nasdaq Apertura |
| **N3** | **Volume normalizzato sul tempo residuo della candela** | 🟡 regola, non numero | ✅ **già fatto** — vale come **validazione**, non come lavoro |
| **N4** | **Retest condizionale: retest SOLO se la candela di rottura è "troppo lunga"** | ❌ **nessuna soglia detta** | 🔴 **NO** — manca il numero. → domanda a Emiliano |
| **N5** | **Regola di regime weekly×daily** (weekly LONG + daily INCERTO ⇒ **aspettati laterale**, fada i bordi) | 🟡 qualitativa | 🟡 **forse** — è un filtro a 2 TF, codificabile, ma senza definizione operativa di "incerto" |
| **N6** | **Il 3°/4° test dello stesso livello è quello che rompe** | ✅ **3ª volta** (r.161) | 🟡 conteggio dei tocchi: codificabile, ma la regola non è dichiarata come tale |
| **N7** | **Selezione del livello: più tocchi > più vicino; escludi la barra in corso; a parità vince il numero tondo** | 🟡 algoritmo senza soglie | 🟢 **SÌ**, e mezzo è già in casa |
| **N8** | **Stop sopra il VWAP invece che a fondo canale** (*"la chicca"*) | ❌ | 🟡 sarebbe un nuovo `ENUM_ABTG_SL` (SL su VWAP). **Non esiste da noi** |

---

## 1.6 🎯 L'INCROCIO CON LA ROSA DI OTTOBRE (le 4 candidate)

Candidate come indicate alla sessione: `SuperWave DOW H1` (U30USD, `770511`) ·
`Nasdaq Apertura US` (NASUSD) · `MaxMin ORO` (XAUUSD) · `DAX Apertura EU in RETEST`
(D30EUR, `770101`). Dossier: `report/ROSA_OTTOBRE_2026-09-18.md`.
⚠️ **Nota di onestà**: in quel dossier la riga `MaxMin` che ho trovato è
`MaxMinNotte_DAX_Short_Ott` **`770411` su D30EUR**, non su XAUUSD (r.59, r.106, r.282).
**Non risolvo la discrepanza** — la segnalo, perché non cambia il verdetto qui sotto
(la live non parla né di oro né di MaxMin).

| sedia | la live la tocca? | cosa ne esce |
|---|---|---|
| **DAX Apertura EU in RETEST** (D30EUR) | ✅✅ **la live È sul DAX, tutta** | Il materiale più pertinente: ORB (contraddetto dalla nostra misura), retest (§1.1-5, non estraibile), veto di prossimità (N2, **il filtro non c'è su questo EA**), livelli DAX del giorno |
| **SuperWave DOW H1** (U30USD) | 🟡 **indirettamente, ma sul punto giusto** | `InpFirstFraction = 0,3333` = *"un terzo"* di r.111, **mai misurato**. La live aggiunge il **secondo grado di libertà** (distanza 20 pt). Anche `InpTrailOnST` (trailing su Supertrend, **mai misurato**) è descritto a r.149 |
| **Nasdaq Apertura US** (NASUSD) | 🟡 **solo per struttura** | Stesso motore d'apertura, ma la live parla del cash europeo. Unica nota: *"volevo guardare anche l'SMP [= S&P]... giornata in fase crescente"* (r.129-131) — **contesto, non parametro** |
| **MaxMin ORO** (XAUUSD) | 🔴 **NO** | **Una sola occorrenza di "oro" in 472 righe** (r.143: *"i prezzi sono anche sull'oro"*), incidentale e **[NON CHIARO]** nel significato. **Zero materiale.** |

---

## 1.7 ❓ LA DOMANDA APERTA DI CASA: **long vs short** — la live NON risponde

La domanda era: *il lato LONG e il lato SHORT non si comportano allo stesso modo*
(EURUSD H4 in archivio: long **0/28**, short **26/26**; sul campo `SuperWave`
guadagna solo sugli short). **Cosa dice la live?**

**L'unica frase con una direzionalità asimmetrica** è r.143:

> *"quando ci sono queste candele così importanti di rifiuto, di solito **la partita
> si gioca proprio dove sono i prezzi adesso**, cioè **io lì in prima istanza vado
> sempre short**, nel senso pur mantenendo la posizione long... tendo comunque a
> farmi lo short e vedere fin dove lo posso portare"*
> e r.145: *"molto probabilmente **scenderà per una ventina di punti** perché **deve
> prendere la liquidità** per fare quel balzetto"*

> ### 🔴 **Ma questa NON è un'asimmetria long/short.** È un **fade condizionato alla struttura** (*sulla punta di una candela di rifiuto, il primo movimento è contrario*), e vale **simmetricamente** nei due versi: sul minimo di una candela di rifiuto dice la stessa cosa al contrario (*"la rottura di quei minimi e il ritorno"*, r.191).
> 👉 **Verdetto: su long vs short, questa trascrizione non porta NIENTE.** Zero
> occorrenze di un'affermazione del tipo *"gli short funzionano meglio dei long"* o
> viceversa. **Il buco resta aperto e va chiuso con una misura nostra, non con una
> live.**

---

# 📇 PARTE 2 — LA SCHEDA (formato di casa)

```
FILE             docs/live_emiliano/trascrizioni/LIVE_EMILIANO_2026-09-18.txt
                 (472 righe · 50.866 byte · TurboScribe auto)
RELATORE/CANALE  Emiliano (FTD/ABTG) — live mattutina delle 08:30.
                 Al monitor per l'85% del tempo: LUCA (allievo).
                 Altri nomi citati: Paolo, Giacomo/Giacomino, Giorgia, Cinzia,
                 Marcus, Giuliano, Alessandro, Consuelo, Christian, Mattia.
OGGETTO          DAX (D30EUR/DE40) cash europeo, sessione d'apertura.
                 Nessun EA, nessun automatismo, nessuna prop citata.
                 Formato: analisi top-down guidata + operatività in diretta.
```

**PARAMETRI CON VALORE** → §1.2, tabella completa P1-P21 (21 voci, tutte con
citazione e riga). 🔴 Tutti *dichiarati da fonte esterna*, nessuno è un criterio nostro.

**MECCANISMI** → §1.3, M1-M20.

**REGOLE PROP CITATE** → 🔴 **NESSUNA. Zero.** Verificato con conteggio termine per
termine (§1.0-bis). L'unico accenno alla protezione del capitale è l'aneddoto di
r.403-405 (*"Ho rischiato quello che ho guadagnato prima"*), che non ha una soglia.

**NUMERI DI PERFORMANCE** → 🔴 **NESSUNO.** Nessun win rate, nessun profitto mensile,
nessun "challenge passate", nessun conto in dollari. **È l'unica live della serie
senza un solo numero di performance dichiarato** — il che, paradossalmente, la rende
**più credibile** della media: non c'è niente da vendere.
*(Unico valore monetario: r.135, "sei 8 euro o meno, 8.50" — è il P/L a schermo di
Luca in quel momento, **[TRASCRITTO dubbio]**, e non è una performance.)*

**BANDIERE ROSSE** → §1.4: **6 bandiere, ZERO rosse piene** (4 arancioni, 2 ambra).
Martingala 0 · griglia 0 · recovery 0 · mediazione 0 · no-stop 0 · trucchi anti-prop 0.

**COSA C'ERA A SCHERMO E NON NEL PARLATO** → §3.

**COSA NE COPIAMO** → §4 (proposte, **nessuna azione**).

---

# 📸 PARTE 3 — COSA ERA A SCHERMO E NON NEL PARLATO (le domande per Claudio)

La trascrizione è **solo audio**. Tutta la live è *"guarda qui"*, *"vedi questa
zona"*, *"tracciami una riga lì"*. 🔴 **Questi pannelli/grafici NON li conosco e non
li deduco.** Se servono, serve lo screenshot.

| # | cosa mostra | perché ci serve | dove nella live |
|---|---|---|---|
| **S1** | 🔴 **Il grafico M5 al momento dell'ORB** (*"L'Orb è aperto, **qui sono tre candele**"*) | È l'unica prova che l'ORB sia davvero **3 × M5 = 15 min** e non 3 × M15. Oggi è `[INFERITO]`. **Decide se la contraddizione col nostro 35-45 min è reale** | **r.173** |
| **S2** | 🔴 **Il pannello ordini con le size** (*"0,5 lì, 0,5 sulla media 100 e un contratto"*) | Ci serve l'**unità** (lotti? contratti? mini?) e il **rischio in valuta** per capire se il 1/3-2/3 è per size o per rischio. Oggi l'unità è `[INFERITO]` | **r.157, r.185, r.345** |
| **S3** | 🟠 **La finestra dello strumento e l'orologio** | Chiuderebbe il buco del **FUSO** (§1.2): con l'orologio a schermo + l'ultima candela, gli orari 09:10/11:07 diventano convertibili in ora server | r.141, r.459 |
| **S4** | 🟠 **L'imbalance tracciato sul grafico** (*"la distanza, circa, sono 37 punti"*) | Ci serve vedere **da dove a dove** è misurato l'imbalance: senza, N4 resta non implementabile | **r.329-331** |
| **S5** | 🟠 **Le impostazioni del Supertrend** (*"che è un tre e mezzo"*) | Il **periodo ATR** non è mai detto. Noi abbiamo `InpStAtrPeriod = 10`. Un pannello chiuderebbe il confronto | **r.125-127** |
| **S6** | 🟡 **L'istogramma dei volumi** (Luca confonde volumi e un altro indicatore, r.225) | Capire **quale** volume guarda (tick volume? real volume? un indicatore terzo?) — il nostro filtro usa `tick_volume` | **r.225** |
| **S7** | 🟡 **La "zona di protezione" tracciata** (*"segnami la zona di presezione, il canale dove i prezzi si fermano"*) | **Sesta live consecutiva** in cui questo concetto compare senza una regola di costruzione dichiarata. Uno screenshot con la zona tracciata varrebbe più di mille righe | **r.457** |

---

# ✅ PARTE 4 — COSA NE COPIAMO (proposte, ZERO azioni)

> 🔴 **Niente di quanto segue è stato fatto. Sono proposte da firmare, e i parametri
> di rischio restano di Claudio.**

| # | proposta | perché ora | costo | classe |
|---|---|---|---|---|
| **C1** | 🥇 **Mettere ad asse `InpFirstFraction` (+ distanza del 2° ordine) su `SuperWave DOW H1`** | Voce **17 dell'audit = MAI misurata**, 14 occorrenze nel repo, valore vivo **0,3333** mai giustificato, **e adesso una fonte esterna dà lo stesso numero e in più la distanza (20 pt sì / 40-50 pt no)**. È una sedia della rosa di ottobre | un round a tick reali su U30USD | 🟢 misura, non cambio |
| **C2** | 🥈 **Misurare `InpUseSRFilter` (off/on) sul `Nasdaq Apertura US`** — dove la manopola **c'è già** ed è solo spenta | N2 è il meccanismo più pulito della live e **il codice R30 esiste**. Su Nasdaq è **zero righe di codice**: è un asse | 1 round | 🟢 **misura pura** |
| **C2-bis** | **Portare `InpUseSRFilter` sul `DAX_Apertura_EU`**, dove è **assente** | solo **dopo** che C2 dice se il filtro paga. Portarlo prima sarebbe scrivere codice per un'ipotesi | 1 modifica + cancello + firma | 🟠 tocca codice |
| **C3** | 🥉 **Chiudere il buco del BE con `InpBEBufferPts`** (voce 14 audit, MAI misurata) | Risponde alla critica di Emiliano (*"i pari"*, r.457) **senza** spegnere il BE che la FASE F ha promosso. È la via corta al numero, non un cambio di criterio | un asse | 🟢 misura |
| **C4** | **Domande a Emiliano** (lui si è offerto per il confronto: r.37, *"settimana prossima... un'oretta"*) | vedi sotto | zero | 🟢 |

### 📨 LE 4 DOMANDE DA FARGLI (chiudono buchi che la live lascia aperti)

1. 🔴 **«Quanto dev'essere lunga la candela di rottura perché tu NON entri al break e
   aspetti il ritracciamento sull'imbalance?»** — r.389 dà la regola senza la soglia.
   È l'unico pezzo davvero nuovo della live e manca il numero.
2. 🔴 **«L'ORB è 3 candele di QUALE timeframe?»** (r.173) — decide se la
   contraddizione col nostro 35-45 min è reale o è un malinteso di TF.
3. 🟠 **«Come si traccia, operativamente, una zona di protezione?»** — sesta live
   consecutiva senza una regola di costruzione (S7).
4. 🟠 **«Hai un tetto di perdita GIORNALIERA? E cambia su un conto prop?»** — la live
   non lo dice mai, e oggi ci è costato una challenge. Il suo aneddoto (*"ho rischiato
   quello che ho guadagnato prima"*, r.405) suggerisce che una regola ce l'ha, ma non
   l'ha detta.

---

## 📎 FILE COLLEGATI

- 🗂️ **Fonte archiviata**: `docs/live_emiliano/trascrizioni/LIVE_EMILIANO_2026-09-18.txt`
  *(e recuperata lo stesso giorno anche `LIVE_EMILIANO_2026-09-16.txt`, che era rimasta
  fuori dal repo dal 16/09)*
- 🚨 `report/BREACH_FUNDEDNEXT_2026-09-18.md` — il breach di stamattina (§1.0-bis)
- 🪑 `report/ROSA_OTTOBRE_2026-09-18.md` — le candidate (§1.6)
- 🔧 `report/AUDIT_USCITE_2026-09-09.md` — TABELLA B, voci 8/10/13/14/17/18 "MAI"
- 🔧 `report/CENSIMENTO_USCITE_MAI_PROVATE_2026-09-11.md` — `InpFirstFraction` su 770511/770531
- 🎙️ Live precedenti: `report/ANALISI_LIVE_EMILIANO_2026-09-09.md` ·
  `backtest_pipeline/caccia_strategie/ANALISI_TRASCRIZIONI_2026-09-14.md`

---

# 🔍 CHIUSURA DEL 18/09 — **la domanda n.2 non serve più: la risposta è nella trascrizione**

**Contesto**: Claudio ha comunicato che **non è possibile fare domande a Emiliano** (non
è stato bene). Le quattro domande proposte al §4 vanno quindi rilette: **quali si possono
chiudere da soli?**

## ✅ DOMANDA 2 — *«L'ORB è 3 candele di QUALE timeframe?»* → **CHIUSA. È M5.**

Il timeframe **è dichiarato**, due volte, nella stessa pagina di trascrizione:

| riga | citazione testuale |
|---|---|
| **r.167** | *«uno guarda il time frame di riferimento che **era l'M5 adesso**»* |
| **r.173** | *«Adesso vado a vedere l'Orb. L'Orb è aperto, **qui sono tre candele**… posso aspettarmi che con **una candela M5** che rompe sotto posso andare a short»* |

➡️ **3 candele × M5 = 15 minuti.** Il `[INFERITO]` del referto diventa **[VERIFICATO]**.

> ## 🔴 **Conseguenza: la contraddizione col nostro numero È REALE, non era un malinteso di timeframe.**
> Speravo nell'ipotesi assolutoria (3 candele di **M15** = 45 minuti = **esattamente la
> nostra banda vincente**). **Non regge: la trascrizione dice M5.**

🏆 **E allora vince la nostra misura, per la terza volta e senza appello**: banda
**35-45 min → 8 celle su 8 positive fuori campione**, banda **5-15 min → 0 su 8**, due
motori concordi 18 volte su 20 (`DIARIO.md`, 06/08).
👉 **Il cancello dell'ORB non si riapre**, e adesso il motivo è scritto con la citazione
accanto invece che con un'inferenza.

## 🔄 DOMANDA 1 — *«quanto dev'essere lunga la candela di rottura?»* → **diventa una MISURA nostra**

Era l'unica cosa davvero nuova della live (r.389: *«non sono voluto entrare direttamente
alla rottura dell'orb perché **avevo visto la candela troppo lunga**»*), e mancava solo la
soglia.

🟢 **E una soglia non si chiede: si misura.** Abbiamo il banco, i dati e i due motori
di apertura già in archivio. La forma della misura è quella di casa: si aggiunge un asse
**«lunghezza della candela di rottura in ATR»**, si guarda se esiste una banda in cui il
break fallisce più spesso, e **si dichiara l'attesa prima**.

💡 **Ed è meglio così, non peggio**: una soglia **misurata** batte una soglia
**ricordata** — e non dipende da nessuno.

## 🔴 DOMANDE 3 e 4 — **restano APERTE, e vanno marcate come tali**

- **3** *«come si traccia operativamente una zona di protezione?»* — sesta live consecutiva
  senza una regola di costruzione. 🔴 **Non chiudibile da noi**: manca proprio la
  definizione, non un numero.
- **4** *«hai un tetto di perdita giornaliera?»* — 🟠 **decaduta come domanda a lui**: la
  risposta che ci serve non è la sua abitudine personale, è **il muro del prodotto prop
  che sceglieremo** e **la soglia del nostro Guardian**. Tutte e due sono già sul tavolo di
  Claudio (`report/QUALE_PROP_PER_I_NOSTRI_EA_2026-09-18.md`,
  `report/IL_GUARDIAN_CONTRO_LA_REGOLA_CHE_CI_HA_UCCISI_2026-09-18.md`).

---

*Chiusura scritta il 18/09/2026. Nessuna domanda è stata inviata a nessuno.*

---

# 🔗 AGGIORNAMENTO DEL 21/09/2026 — arrivata una live PIU' VECCHIA (10/04/2026)

Claudio ha caricato `trascrizioni/LIVE_EMILIANO_2026-04-10.txt` (208 righe, stessi
relatori + Paolo Scaglione e Renzo, **tutta sul DAX**). Il referto e':

> 📄 **`report/ANALISI_LIVE_EMILIANO_2026-04-10.md`**

**Cosa tocca di QUESTO documento** (senza duplicarne i contenuti — si legge li'):

| voce del 18/09 | cosa dice la live del 10/04 |
|---|---|
| 🔴 **Domanda aperta n.2** — *«l'ORB e' 3 candele di QUALE timeframe?»* | ✅ **CHIUSA**: r.95 del 10/04 dice in chiaro che il range e' *"il massimo al minimo della candela in M15"* → **15 minuti**. 👉 **La contraddizione col nostro 35-45 min (8/8 OOS) e' REALE**, non un malinteso di TF. Quarta ripetizione della **stessa** fonte = **una** fonte |
| **N1** — distanza fra gli ordini dello scale-in (*20 pt si' · 40-50 pt no*) | 🟢 **Terzo punto sulla stessa curva**: r.95 del 10/04 → **59 punti = troppo distanti** (*"e' molto probabile che i prezzi mi toccano il primo e rimbalzano"*). La soglia della fonte sta **fra 20 e 40 punti indice DAX**. ⚠️ **Stessa fonte: taratura coerente, non verifica indipendente** |
| **C1** — `InpFirstFraction` mai misurata | 🟢 **Rinforzata**: r.93 del 10/04 → *"**un terzo** lo vado a piazzare"* = il nostro `0,3333`. E il referto nuovo aggiunge un bersaglio: `ABTG_EMA200` (`771531`), dove `InpOrder1Atr=0.10` / `InpOrder2Atr=0.35` non sono mai stati misurati |
| **N2 / C2** — veto sul breakout se il target e' troppo vicino (`InpUseSRFilter`) | 🔴 **RIQUALIFICATO, e la differenza conta**: la live del 10/04 descrive lo stesso veto ma con **ostacoli DIVERSI** (medie 14/50/100/200 e **Supertrend**, non PDH/PDL+tondi), sul **TF SUPERIORE a scala** (H1→H4→D1, non lo stesso TF), e in forma di **BANDA** (26-30 pt = troppo poco · 170-500 pt = troppo lontano). 👉 **R30 non lo chiude**, ma ne alza l'asticella: nel referto nuovo la proposta e' una **SONDA in sola lettura**, non un input da ottimizzare |
| 🚩 **Bandiere rosse** | 🔴 **La serie "due live pulite di fila" SI INTERROMPE**: la live del 10/04 contiene **media valore / averaging down con size progressiva** (10+10+20 contratti su posizione in perdita), **ammessa dalla fonte stessa**: *"non e' piu' il mio x per cento, diventa l'x per cento piu' il rischio della seconda operazione"* (r.127-129). **Marcata NON ADOTTABILE.** Piu' tre bandiere minori (fra cui *"non ho il permesso di chiudere"*, r.179, incompatibile con un limite di perdita giornaliera) |
| ✅ **Conferme nuove** | 🟢 `InpBufferPoints = 1000` (10 punti indice sotto i minimi della notte) confermato **parola per parola** da una fonte che opera sullo **stesso strumento e sullo stesso broker BCM** (r.93 vs `ABTG_MaxMinNotte.mq5` r.140) · `OPENCONFIRM` confermato, con **r.145 che alza la conferma "almeno in H1"** = il nostro `InpOCTimeframe` |
| 🔴 **Buco nuovo trovato** | L'**Open Weekly come BIAS DIREZIONALE** (r.81, r.95) **non esiste in nessun nostro EA**: l'unico che legge `iOpen(PERIOD_W1,0)` e' `ABTG_WOL.mq5` (r.154) e lo usa come **bersaglio**, non come spartiacque. ⚠️ **Non diventa una proposta**: la fonte non da' nessuna soglia |

*Aggiornamento scritto il 21/09/2026. Nessuna azione eseguita: EA, preset, forward e
conto reale 10105439 non toccati.*

---

# 🔗 SEGUITO DEL 25/09/2026 — nuova live, referto separato
👉 `backtest_pipeline/caccia_strategie/ANALISI_TRASCRIZIONI_2026-09-25.md`. Tocca questo referto
in due punti: **(1)** §1.1-2 *"non puoi fare i pari"*: il 25/09 la fonte fa **BE a +20 punti e
chiude metà** (r.165-167), dopo aver detto nella stessa live che dimezzare è inutile (r.139) →
contraddizione **aperta**, nessuna regola estraibile sul BE; **(2)** §1.1-1 frazione d'ingresso:
arrivano altri numeri (*"un lotto e due lotti"*, 0.2/0.5/grosso, distanza 15-20 punti), nessuna
misura. `InpFirstFraction` resta **MAI misurato**.
