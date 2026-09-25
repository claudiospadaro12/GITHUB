# 📼 ANALISI TRASCRIZIONE — LIVE EMILIANO 25/09/2026, 08:30 (DAX + GBPJPY, "conto piccolo")

**Fonte unica:** `docs/live_emiliano/trascrizioni/LIVE_EMILIANO_2026-09-25.txt`
(436 righe, 42.871 byte, TurboScribe auto-generato, caricata da Claudio; copia identica
dell'upload `fdc7c598-LIVE_EMILIANO_25.09.26_2026-09-25_08-30-00-176.txt`).
**Ogni `r.NNN` è il numero di riga di QUEL file.** Niente memoria, niente web.

> Regola che vale sopra tutto: **da questo materiale non si muove niente.** Ogni numero è
> una dichiarazione di una fonte esterna, mai un criterio nostro. Nessun EA, preset, forward
> o conto è stato toccato: il codice è stato solo LETTO.

**Numerazione.** È l'**8ª scheda** di questa serie di dossier (formato di
`ANALISI_TRASCRIZIONI_2026-09-14.md`, che era la 7ª). ⚠️ Attenzione al conteggio: quel dossier
chiamava già "ottava trascrizione" quella del 18/09 (referto a parte), e in archivio ci sono
anche il 16/09 e il 10/04. Contate come trascrizioni, questa è la **9ª delle live di settembre**.
Il numero cambia l'etichetta, non il contenuto.

**Qualità della trascrizione: medio-bassa.** Storpiature tipiche: **daily → "Dating"/"dedichi"**,
**weekly → "wiki"/"wikipedia"**, **VWAP → "move up"/"VVAP"/"WAP"** (stessa resa del 18/09),
**ATR → "la TR"**, **numero tondo → "tolbo"/"tolgo"/"nuovo tonno"**, **trading range →
"Editing Range"/"termine range"/"trigger range"**, **GBPJPY → "GBJ"/"GPJ"**, GBPCHF (?) →
"GBP-GHF"/"GHF"/"GDCHF"/"CHFGV" **[INCERTO]**, **size → "site"/"sites"/"sales"**.

---

## 🎯 LA RIGA CHE CONTA

**Su 1 trascrizione: 24 parametri con valore, 21 meccanismi, 9 bandiere (4 🔴 rosse, 3 🟠,
2 🟡), ZERO regole prop.** 🔴 **La serie "senza bandiere rosse" (14/09 e 18/09) si rompe di
nuovo, come con il 10/04: torna la media al ribasso pianificata**, stavolta chiamata "secondo giro".

**Il dato più solido non è un numero: è una forma di ingresso che il nostro round di domani
NON copre.** Emiliano fa esattamente l'ipotesi A di Unger (massimo del giorno prima come
livello), ma con il **terzo** tipo d'ordine: **rottura già avvenuta nella notte → LIMIT sul
ritorno al massimo di ieri, nel verso del trend** (r.45, r.63, r.67-69). R249 mette a
confronto STOP contro FADE sugli stessi livelli; il **RETEST** sul massimo/minimo di ieri
**non ha una riga**. E il nostro EA lo fa **senza scrivere codice** (vedi §3).
🔴 Ed è anche il caso che il referto Unger chiama **"giorno consumato"** (sonda sul future
2011-2018, non BCM: **36,6%** dei giorni il livello è già rotto prima delle 08:00) e tratta
come una **trappola** del braccio STOP: **per Emiliano quei giorni sono il setup.**

---

## 1. 🧮 LA SINTESI INCROCIATA — aggiornata con la live del 25/09

### 1.1 Tabella dei valori convergenti (fonte UNICA: Emiliano + i suoi allievi = **1 fonte**, non N)

| parametro | 25/09 | live precedenti | convergenza |
|---|---|---|---|
| **Distanza fra i pendenti (DAX)** | **20 punti** (r.37) · **15-20** (r.59) · **16 "troppo pochi"** dopo un'accumulazione (r.249) | 18/09: *"circa 20 punti"*, *"40-50 non ha senso"* | 🟢 **~20 punti in 2 live** — stessa fonte, quindi è coerenza del relatore, **non verifica** |
| **Size fra gli ordini** | 1 lotto + 2 lotti (r.35) · 0.2 / 0.5 / "più grosso" (r.49) · 0.020 / 0.040 (r.159) · 0.04 / 0.08 (r.241) | 14/09: *"1 lotto sopra, 2 sotto"* · 18/09: *"un terzo o due terzi"* | 🟢 **rapporto 1:2, più grosso verso il livello più forte, in 3 live** |
| **Filtro daily + weekly concordi** | regola esplicita (r.43, r.293-295, r.371) · oro scartato per W short / D incerto (r.75-79) | 09/09: dashboard *"Daily verde, Weekly verde, Monthly verde"* | 🟡 **2 live**, e la prima volta come **regola scritta** |
| **Breakeven** | **+20 punti → stop in pari, poi chiusa metà** (r.165-167) | 14/09: BE sì · 18/09: *"non puoi fare i pari"* | 🔴 **CONTRADDIZIONE aperta** fra live (v. 1.2) |
| **Stop su ATR** | ATR 21 pip (r.271-273) · ATR 49 → stop 54 (r.313-319) · ATR *"va calcolata quando viene fillato"* (r.299) | 09/09: *"la TR mi dice circa 28 punti"* · 14/09: ATR in H1 come sostituto del "wrap" | 🟢 **ATR come metro dello stop in 3 live**; periodo/TF **mai dettati** |
| **VWAP** | livello d'ingresso e confluenza con S/R H1 (r.47, r.153) · pendenti cancellati se salgono i volumi (r.423) | 18/09: stop sopra il VWAP (*"la chicca"*), VWAP M15 | 🟢 in 3 live, **usato in 3 modi diversi** (filtro, stop, ingresso) |
| **Numero tondo** | livello di ripiego se non c'è un massimo/minimo chiaro (r.27-33) | 09/09: *"numero tondo 800"* | 🟡 2 live |
| **Massimo di ieri + massimo della notte** | *"i due prezzi più importanti"* (r.35) | 09/09 e 10/04: livelli della notte | 🟢 ricorrente |

### 1.2 Contraddizioni

| # | cosa | prove |
|---|---|---|
| C1 | **BE e parziale sì o no** — nella STESSA live: *"È inutile che la dimezzo perché poi dopo prendermi lo stop in pari"* (r.139) e dopo 13 righe **BE a +20 e metà chiusa** (r.165-167), con il BE preso (r.177). Contro il 18/09 (*"non puoi fare trading con me e fare i pari"*). | 🟠 la fonte la risolve così: **si chiude tutto se si è entrati con 1 ordine e si è a target; si gestisce se si è entrati con 2** (r.143-145). È una regola sulla **size**, non sul prezzo |
| C2 | **Il massimo di ieri come ingresso**: *"hanno un [peso] superiore"* (r.45) e dopo 18 righe *"Lavorare i massimi del giorno precedente come livello di retest è più rischioso"* (r.63) | 🟡 resta aperta |
| C3 | **"Si opera solo in direzione"** (r.31, r.43) e poi **short su VWAP e numero tondo in pre-apertura con il DAX long** (r.49-51, r.67, r.259) | 🔴 bandiera R1 |
| C4 | **"Più giri solo in trading range, se è direzionale non puoi"** (r.373-377) contro *"Il DAX oggi era bello da trovare perché era semplice, era direzionale"* (r.257) | 🟠 le due condizioni sono dichiarate **sullo stesso DAX, lo stesso giorno** |
| C5 | **GBP "molto forte"** (r.71) ma **GBPJPY daily "fortemente short"** e stop sopra il massimo, cioè ordini short (r.83, r.271) | 🟡 può essere la trascrizione (valuta sbagliata) — **[TRASCRITTO dubbio]** |
| C6 | **Base del conto**: 400 € (r.9, r.387), *"40 euro sul 300"* (r.133), 46 € = 10% (r.125-127), 3-4 € = 1% (r.163) | 🟡 aritmetica che non torna — numeri non usabili |

### 1.3 Confronto col repo (codice letto, nessuna modifica)

| cosa dice la live | cosa abbiamo | verdetto |
|---|---|---|
| **RETEST del massimo/minimo di ieri** nel verso del trend (r.45, r.63) | `ABTG_DAX_Apertura_EU.mq5`: `InpEntryMode=ABTG_RETEST` (r.273, enum r.205 *"leva Emiliano"*) + `InpRangeMode=2 RANGE_PREVBAR` + `InpLevelTF=PERIOD_D1` (r.274-275). `ComputeLevels()` r.1113-1119 prende massimo e minimo della candela D1 chiusa; `MonitorRetest()` r.1907+ vede la rottura al primo tick (`ask >= buyTrig`) e piazza il BUY LIMIT sul livello (r.1956). **Quindi il giorno "rotto nella notte" diventa subito un LIMIT sul massimo di ieri: è proprio il setup della live** [INFERITO dal codice] | 🟢 **NUOVO e TESTABILE a ZERO codice** — R249 ha STOP e FADE, **non il RETEST** |
| Livelli di ieri come ipotesi | `report/METODO_UNGER_2026-09-24.md` §6 A · `prove/R249a..h` | 🟢 in casa, **ma solo due bracci su tre** |
| **VWAP come FILTRO di lato** | `InpUseVwapFilter` + `InpVwapTF=M15` (r.320-322) — **misurato in R101**: DAX PF OOS **−0,061**, Dow **+0,007**, G3 **incoerente** (`risultati_archivio/R101_REFERTO.md` r.75, r.93) | ⛔ **già misurato, niente candidato** |
| **VWAP come LIVELLO d'ingresso** (limit sul VWAP, r.47-49) | **non esiste** in `ABTG_DAX_Apertura_EU`. Vicino: `ABTG_VwapRevert` (reversione alla banda VWAP ± sigma, motore diverso). ✏️ **ERRATA 25/09 sera**: qui c'era scritto *"passo 0 mai corso"*, ripreso da `report/CENSIMENTO_CASELLE_VUOTE_2026-09-22.md` r.413-419. **Falso**: il passo 0 è **corso il 03/09** su D30EUR M15, 4 celle, **S0 NON PASSA su tutte e quattro** (rapporto punti/spread −0,11 / −0,21 / −0,14 / −0,21; `REGISTRO_TEST.md` r.1251; `risultati_archivio/vwaprevert/CORSA_2026-09-03_1711_FALSIFICATO.txt`) | 🟡 nuovo come ingresso; il pezzo di casa più vicino è **falsificato su D30EUR M15** (altri TF e simboli: [NON MISURATI]) |
| **Filtro daily + weekly concordi** (r.43, r.295) | **nessun input dedicato.** Ma `TrendBias()`/`CombineBias()` (EA r.2120-2174) **somma i filtri e dà "nessun ordine" se discordano**: `InpUseEmaFilter` con `InpFilterTF=D1` + `InpUseSupertrend` con `InpStTF=W1` = **"D e W concordi" a zero codice** [INFERITO dal codice] | 🟡 **approssimabile**, con una trappola (v. certificato) |
| **Numero tondo come INGRESSO** | `InpUseRoundLevels` esiste **solo come obiettivo** (r.341-343) — e come obiettivo **COSTA** su tutti e due gli indici (R101 `08_tondi`: DAX −0,090, Dow −0,057) · come veto di vicinanza in `ABTG_Apertura_3Ingressi` (`InpSRUseRoundNumbers`) | 🟡 come ingresso **non esiste**; come target è **misurato e bocciato** |
| **BE a +20 punti, metà chiusa** | `InpTP1_R=1.0` + `InpTP1_ClosePct=50` + `InpBreakevenAtTP1=true` (r.329-331) — **stessa struttura, in R invece che in punti fissi**; misurata in FASE F (PF 1,237 OOS, `AUDIT_USCITE_2026-09-09.md`) | 🟢 **già in casa**, in una forma migliore (in R scala con la volatilità) |
| **Frazionamento 1:2 su 2-3 livelli** | `ABTG_DAX_Apertura_EU` piazza **un** ordine. `InpFirstFraction` esiste su `SuperWave` (0,3333), **MAI misurato** (voce 17 di `AUDIT_USCITE`) | 🟡 già segnalato il 18/09 — la live aggiunge un **terzo** numero, non una misura |
| **Stop ATR "calcolato al fill"** | `InpSLMode=ABTG_SL_ATR` + `InpAtrSlMult` (r.326-327): l'ATR si legge al piazzamento del LIMIT, non al fill | 🟡 differenza reale ma piccola (minuti); non vale un round |
| **Forza delle valute / "distanza 4.9"** | nessun motore di forza valutaria. `ABTG_Relativo` è forza relativa fra **indici**, R117 **mai corso** | 🔴 **non testabile**: la dashboard non è nostra e **non si sa cosa misura** (domanda G4 del 09/09 ancora aperta) |

### 1.4 Le domande per Claudio (screenshot ai minuti giusti)

| # | cosa manca | dove |
|---|---|---|
| **G1 ⭐** | **Lo strumento del passaggio "ATR 49 → stop 54"** — non è mai nominato. Il contesto (subito dopo il riepilogo sulle valute, r.293-297) fa pensare a GBPJPY **[INFERITO, confidenza media]**, ma 10 righe prima GBPJPY ha già uno stop con *"la TR, 21 ... 21 pip"* (r.271-273). **49 "punti" = 4,9 pip o 49 pip?** E su che TF (dice *"sono in H4"*, poi *"scendi in H1"*, r.299)? | screenshot del grafico e dell'ATR a r.299-319 |
| **G2 ⭐** | **I prezzi del DAX**: "500", "509", "500-414", "4,60", "25.4" (r.21, r.33, r.39, r.327). Probabilmente 25.500 / 25.509 / 25.460 / 25.400 **[INFERITO, confidenza bassa]** | screenshot DAX M15/H1 con i livelli, ~08:50-09:15 |
| G3 | La dashboard della forza valutaria e la **"distanza 4.9"** (r.81): scala, formula, TF | screenshot della dashboard a r.81 |
| G4 | **Direzione e tipo degli ordini su GBPJPY** "sui minimi del giorno precedente" (r.87-89): sell stop (rottura) o sell limit (ritorno)? | screenshot della finestra ordini a r.89 |
| G5 | La media *"in H15 a 200"* e *"a H12"* (r.195): M15 200? H1? | screenshot a r.193-197 |
| G6 | Il VWAP: di sessione, giornaliero, ancorato? Su quale TF lo legge? (r.179: *"nel 2015"* = M15? **[dubbio]**; r.429 M15) | screenshot proprietà indicatore |
| G7 | Le size reali in lotti: "0.2 / 0.5" (r.49) contro "0.020 / 0.040" (r.159) — **stesso conto da ~400 €** | screenshot finestra ordine a r.49 |

⏰ **Fuso**: nessun fuso dichiarato. Le uniche ancore sono *"mancano nove minuti"* (r.69) e
*"mancano 30 secondi d'apertura"* (r.119), riferite all'apertura del DAX; la live parte alle 08:30
secondo il nome del file (ora italiana **[INFERITO]**). **Nessun orario convertito.**

---

## 2. 📇 LA SCHEDA (griglia di casa)

```
FILE            docs/live_emiliano/trascrizioni/LIVE_EMILIANO_2026-09-25.txt
RELATORE/CANALE Emiliano (live ABTG); interventi di allievi dalla chat (Pasquale, Marcus,
                Luca, Vittoria, Consuelo, Tommaso) — citati solo come interlocutori
OGGETTO         DAX all'apertura (retest, VWAP, numero tondo), GBPJPY (forza valutaria),
                oro (scartato); lezione su pazienza e "conto piccolo"
```

### PARAMETRI CON VALORE (24)

| # | parametro | citazione | r. | etichetta |
|---|---|---|---|---|
| P1 | Distanza fra 1° e 2° ordine | *"il secondo ordine, di solito devono stare distanti i 20 punti"* | 37 | 🟢 TRASCRITTO chiaro |
| P2 | Distanza fra gli ordini sul DAX | *"Gli ordini devono essere stati circa 15-20 punti, il DAX lo aspetto così"* | 59 | 🟢 chiaro |
| P3 | Distanza troppo corta dopo accumulazione | *"16 punti sono troppo pochi ... l'accelerazione potrebbe portarlo fino alla media, quindi gli ordini io li lascio ma li alzo"* | 249 | 🟢 chiaro |
| P4 | Size per livello | *"Io mi piazzo con un lotto e due lotti"* | 35 | 🟢 chiaro |
| P5 | Frazionamento su 3 livelli | *"il 0.2 piccolissimo sul VWAP, il 0.5 sul numero tondo e poi sopra ... a 509, mi metto un ordine più grosso"* | 49 | 🟡 dubbio (0.2/0.5 contro le 0.020/0.040 dopo) |
| P6 | Secondo giro: size | *"gli andrò qua con 0.020, 0.040"* | 159 | 🟡 dubbio (virgole) |
| P7 | Size al 2° tocco | *"Il secondo giro qua abbasso le size, metto una 04 e una 08"* | 241 | 🟡 dubbio |
| P8 | Numero tondo DAX | *"prendo il numero tondo, 500, 509"* | 33 | 🟡 dubbio (migliaia perse) |
| P9 | Livello DAX | *"500-414 potrebbe essere il primo livello"* | 21 | 🔴 dubbio forte |
| P10 | Massimo di ieri DAX | *"potrebbe essere il livello di 4,60"* | 39 | 🟡 dubbio |
| P11 | Numero tondo (fine live) | *"il numero tolbo è 25.4"* | 327 | 🟡 dubbio (25.400?) |
| P12 | Breakeven | *"20 punti d'asse, si porta lo stop in pari"* | 165 | 🟢 chiaro |
| P13 | Parziale | *"si chiude metà posizione e l'altra metà si lascia correre"* | 167 | 🟢 chiaro |
| P14 | Stop GBPJPY | *"con la TR, 21 ... Dobbiamo mettere 21 pip ... 195,514. Quindi lo stop e tutti e due lo mettiamo lì"* | 271-273 | 🟡 dubbio (prezzo) |
| P15 | Stop su ATR | *"La TR mi dice 49 punti ... 54, va bene ... al 54 mettiamo il stop"* | 313-319 | 🔴 dubbio (strumento e unità, G1) |
| P16 | ATR al fill | *"la TR va calcolata quando viene fillato l'ordine"* | 299 | 🟢 chiaro |
| P17 | Stop in euro | *"Dove metto lo stop? 25-26 euro. Non mi piace tanto."* | 309 | 🟡 [ATTRIBUZIONE NON CHIARA] |
| P18 | Stop massimo | *"uno stop all'interno dei 40 euro"* | 151 | 🟢 chiaro (= ~10% del conto dichiarato) |
| P19 | Distanza di forza valutaria | *"La maggiore distanza è 4.9 quindi vuol dire che questo è fortemente direzionale"* | 81 | 🟢 chiaro il numero, ignota la scala |
| P20 | Lotto sull'oro | *"possiamo lavorare anche l'oro con il 001"* | 71 | 🟡 dubbio (= 0,01) |
| P21 | Obiettivo giornaliero | *"giornata con 40 euro è la nostra giornata"* · *"40 euro è un po' il target ... anche con 2.000 euro, 3.000 euro"* | 141, 133 | 🟢 chiaro |
| P22 | Obiettivo per operazione | *"4 euro è l'1% del conto, che è l'obiettivo"* | 163 | 🟢 chiaro |
| P23 | Frequenza | *"Basta un'operazione al giorno"* · *"una o due operazioni al giorno"* | 133, 253 | 🟢 chiaro |
| P24 | News | *"alle 9, alle 10.15 su GPP ... non abbiamo niente di particolare"* | 15 | 🟡 dubbio (fuso non dichiarato) |

### MECCANISMI (21) — in forma IF-THEN

| # | regola | r. |
|---|---|---|
| M1 | **IF** weekly e daily puntano nello stesso verso **AND** il multi-TF conferma **THEN** si cerca un ingresso in quel verso; **ELSE** fermi | 43, 293-295, 371 |
| M2 | **IF** weekly e daily sono in contrasto (oro: W short, D incerto) **THEN** lo strumento non si fa | 75-79, 267 |
| M3 | **IF** si sceglie una valuta **THEN** si prende la coppia con la maggior distanza di forza nella dashboard (4.9 = "fortemente direzionale") | 81-85, 295-297 |
| M4 | **IF** la coppia è direzionale ma il prezzo è su un punto estremo **THEN** non si entra: si aspetta il livello (minimi di ieri) | 87-89, 253 |
| M5 | **IF** si lavorano valute **THEN** attenzione allo spread | 297 |
| M6 | I livelli più importanti sono **massimo di ieri e massimo della notte** | 35 |
| M7 | **IF** non si trova un massimo/minimo contrapposto **THEN** si usano spike isolati o il **numero tondo** | 27-33 |
| M8 | **IF** il prezzo è già oltre il massimo di ieri e della notte **THEN** non si compra in alto: si aspetta il ritorno (retest) sul massimo di ieri o sul supporto | 19, 39, 45, 67 |
| M9 | **IF** VWAP + supporto H1 (+ media) coincidono **THEN** livello forte ("confluenza") | 153, 195-197 |
| M10 | **IF** si piazzano più ordini **THEN** size crescente verso il livello più forte (0.2 VWAP → 0.5 tondo → grosso sul livello) | 49 |
| M11 | **IF** l'ordine è contro-trend **THEN** size ridotta | 51 |
| M12 | **IF** siamo in pre-apertura **THEN** "sale senza volumi", quindi un livello tecnico tiene di più | 57 |
| M13 | **IF** si è a target giornaliero con 1 solo ordine **THEN** si chiude tutto (niente BE, niente parziale) | 139-145 |
| M14 | **IF** si è entrati con 2 ordini **AND** +20 punti **THEN** stop in pari, chiusa metà, il resto corre | 145, 165-167 |
| M15 | **IF** si mette lo stop **THEN** su ATR, letta al fill | 271, 299, 313 |
| M16 | **IF** il livello viene toccato la 2ª volta **THEN** "potrebbe superarlo": size ridotta | 241 |
| M17 | **IF** i pendenti sono a ~16 punti dopo una lunga accumulazione **THEN** si alzano (dopo la rottura il prezzo accelera) | 249-251 |
| M18 | **IF** i volumi salgono **THEN** si cancellano i pendenti sul VWAP; **ELSE** restano | 423 |
| M19 | **IF** il mercato è in trading range **THEN** si ammettono "più giri"; **IF** è direzionale **THEN** no | 373-377 |
| M20 | **IF** rifiuto con doji + conferma **THEN** segnale | 101 |
| M21 | Non si insegue il prezzo: lo stop resta lontano | 191 |

### REGOLE PROP CITATE
**Nessuna.** Zero menzioni di prop, challenge, drawdown massimo, limite giornaliero.

### NUMERI DI PERFORMANCE — tutti [dichiarato, NON verificato]
46 € = *"10% del conto"* (r.125-127) · *"40 euro sul 300, più del 10%"* (r.133) · *"50 ... 60 euro.
Quasi 70. E il 20 per cento del conto"* (r.403-407) · *"il conto piccolo è triplicato"* (r.261) ·
*"fai il 10-20%"* in un giorno (r.189) · conto *"portato a 2.000"* (r.3) · *"avevo 400 ... perso 13"* (r.9).
🔴 **L'aritmetica non torna** (C6): **nessuno di questi numeri entra in un criterio.**

### 🚩 BANDIERE — 9 (4 🔴, 3 🟠, 2 🟡)

| # | bandiera | citazione | r. | verdetto |
|---|---|---|---|---|
| **R1** | 🔴 **Ordini contro trend in pre-apertura**, contro la sua stessa regola | *"se va in pre-apertura ... in pre-apertura senza volumi io qua mi metto"* · *"le operazioni ... voi non la fate"* · *"Noi ci siamo messi in short su VVAP in pre-apertura"* | 41-43, 67, 259 | 🔴 **la fonte dà una regola agli allievi e fa l'opposto.** Non si copia: da noi il verso lo decide la regola |
| **R2** | 🔴 **"Secondo/terzo giro" sullo stesso livello, con la size più grande SOTTO** = media al ribasso pianificata | *"io qua 1.020 ... e gli metto 1.040 qua"* · *"perché sotto c'è la parte più grande"* · *"se dovesse andarmi sotto io ottengo queste size, perché sono 20 punti ... la differenza la farò qua"* · *"attenzione al terzo o quarto giro"* | 157-161, 199, 321 | 🔴 **NON ADOTTABILE** — è la stessa classe del 10/04 (10+10+20 contratti) |
| **R3** | 🔴 **Ingresso "sbagliato apposta" per mostrare che si recupera** | *"Adesso ho sbagliato appositamente. Vediamo cosa succede"* · *"Voglio vedere se li recupero"* · *"quando è direzionale ... puoi anche sbagliare l'ingresso perché ... dovrebbe ritornare sui suoi valori"* | 341, 361, 255 | 🔴 **logica di recovery**: la tesi è "in trend il prezzo torna". È una scommessa, non una regola. Un EA che tiene la posizione sbagliata sperando che torni è quello che brucia la challenge |
| **R4** | 🔴 **Size a sensazione** | *"se io me la sento posso utilizzare, col conto piccolo, anche una terza quantità che metterò poco prima dello stop"* · *"sono entrato un po' pesantino. Non mi piace. Non mi sono reso conto"* · *"Come sono fatto io, lo spingo anche sul numero tondo"* | 117, 337-339, 207 | 🔴 **l'opposto del nostro 0,65% fisso per sedia.** E la "terza quantità poco prima dello stop" aggiunge rischio proprio dove la tesi è più debole |
| **R5** | 🟠 **Il conto piccolo "portato a 2.000 male, rischiando tanto"** | *"l'ho portato a 2.000 male, rischiando tanto"* · *"L'ultimo due volte sono preso dei rischi di bruciare"* | 3, 97 | 🟠 **autodenunciato** dalla fonte: vale come avvertimento, non come metodo |
| **R6** | 🟠 **Rischio per operazione implicito al 6-10% del conto** | *"uno stop all'interno dei 40 euro"* su ~400 € · *"25-26 euro"* | 151, 309 | 🟠 **incompatibile con qualunque regola prop**: con la perdita giornaliera al 4-5%, uno stop solo supera il limite |
| **R7** | 🟠 **BE e parziale sì/no nella stessa live** | r.139 contro r.165-167 (C1) | — | 🟠 da qui **non si estrae** una regola sul BE |
| **R8** | 🟡 **Obiettivo in euro fisso** (40 € "anche con 2.000-3.000") | r.133 | — | 🟡 il target si fissa in R o in %, non in euro |
| **R9** | 🟡 **Numeri di performance che non tornano** | r.9, 125-133, 387, 407 | — | 🟡 v. C6 |

**Assenze verificate (ricerca sull'intero file):** `martingal` 0 · `grid/griglia` 0 · `hedg` 0 ·
trucchi anti-prop 0 · prop/challenge/drawdown 0. `recuper*`: **3** (r.361, 363, 365, tutte in R3).

### COSA C'ERA A SCHERMO E NON NEL PARLATO
Tutti i prezzi dei livelli (G2), lo strumento e il TF dell'ATR 49 (G1), la dashboard (G3), la
direzione degli ordini GBPJPY (G4), la media "H15 a 200" (G5), il tipo di VWAP (G6), le size (G7).
La correzione in diretta di buy/sell (r.51-55: *"sopra hai messo il buy ... Il primo è sell e il
secondo è buy"*) dice che **nemmeno a voce si ricostruisce quali ordini fossero long e quali short**.

### COSA NE COPIAMO

| # | spunto | priorità | perché |
|---|---|---|---|
| **S1** | **Il terzo braccio di R249: RETEST sul massimo/minimo di ieri** — `ABTG_DAX_Apertura_EU`, `InpEntryMode=2`, `InpRangeMode=2`, `InpLevelTF=D1`, `InpSLMode=1` (ATR, come i due bracci), `InpMinRangePts=0` e `InpMaxRangePts=0` (la candela D1 supera sempre i 40 punti), lati separati | 🟢 **ALTA** | zero codice, famiglia viva, completa un confronto **già firmato** (STOP / FADE / LIMIT sugli stessi livelli) |
| S2 | Filtro "D e W concordi" come asse **su S1**, non da solo: `InpUseEmaFilter` D1 + `InpUseSupertrend` W1 | 🟡 media | filtro di trend = asse già misurato con esiti misti (R101: EMA H1 migliora l'OOS e peggiora l'IS; Supertrend×3 **ribaltone** di regime). Si prova solo **se S1 ha un motore** |
| S3 | VWAP come livello d'ingresso | 🟡 bassa | ✏️ ERRATA 25/09: `ABTG_VwapRevert` **non è "mai corso"**: passo 0 corso il 03/09, S0 negativo su 4 celle D30EUR M15 (`REGISTRO_TEST.md` r.1251). Il VWAP come **livello** resta non misurato |
| S4 | BE a +20 punti fissi | 🔴 no | abbiamo già il BE in R, misurato (FASE F), e la fonte si contraddice (R7) |
| S5 | Numero tondo come ingresso | 🔴 no | come obiettivo è **misurato e costa** su DAX e Dow (R101 `08_tondi`); come ingresso non c'è una regola di costruzione (quale tondo: 100? 50? il passo non è dettato) |
| S6 | Forza valutaria / "distanza 4.9" | 🔴 no | strumento non nostro, scala ignota |
| ⛔ | "Secondo giro", ingresso sbagliato apposta, terza quantità vicino allo stop, size a sensazione | **VIETATO PER NOI** | R2-R4 |

#### 🪪 Certificato dell'evento su D30EUR BCM (S1) — cosa è verificato e cosa no
- 🟢 **I livelli esistono**: massimo/minimo D1 di ieri, calcolabili con `iHigh/iLow(D1,1)` (EA r.1116-1117).
- 🟢 **Le quotazioni della notte esistono**: la famiglia `MaxMinNotte_DAX` gira su di loro.
- 🟠 **La frequenza del setup "rotto nella notte, poi ritorna" sui tick BCM: `[NON MISURATA]`.**
  L'unico numero è della sonda sul **future 2011-2018, non BCM** (36,6% di giorni "consumati"
  prima delle 08:00, `METODO_UNGER` §6 A). Quanti di quelli **tornano sul livello** entro la
  scadenza dell'ordine non lo sa nessuno.
- 🔴 **Trappola della finestra [INFERITO dal codice]**: lo storico indici BCM parte dal
  **2024.09.26**. Un filtro EMA **200 su D1** chiede ~10 mesi di barre e un'EMA lunga su **W1**
  chiede anni: se `CopyBuffer` fallisce, `TrendBias()` **non applica il filtro e non lo dice**
  (bias = 0 = nessun vincolo). Per S2 serve il Supertrend W1 (ATR 10: poche barre), non un'EMA W1.
- 🟠 **"Pre-apertura senza volumi"**: sul CFD il volume è **tick volume**. La regola M12 è
  misurabile solo in quella forma, e va detto.
- ⏰ **Orologio**: il 25/09 è estate, 08:00 server = 09:00 IT. D'inverno BCM (UTC+1 fisso) è
  alle 08:00 IT: la prova va **spezzata per stagione** (`report/OROLOGIO_BCM_2026-09-24.md`).
- ⚠️ **Sovrapposizione**: stessa fascia oraria della sedia `770101`: se S1 vive, si misura la
  correlazione **prima** di qualunque vivaio.

🧭 **Bussola, detta onesta**: niente di questo schiera una sedia entro il 1° ottobre. S1 è
**ricerca** che completa un round già pronto (R249); non è un candidato di campo.

---

## 3. ❌ SCARTI
Nessuna trascrizione scartata: è un file solo, e ha materiale. Dentro il file, **non diventano
spunto**: la lezione su pazienza/mindset (r.183-189, 223-237, 409-421: nessun numero), il corso
di scalping annunciato per ottobre (r.383), gli scambi personali con la chat (r.283-309, 385-395).

---

## 4. 📸 ADDENDUM — IL POST DELLO STESSO GIORNO (3 screenshot caricati da Claudio, 25/09 pomeriggio)

**Fonte:** due schermate MT5 del conto mostrato nel post (conto **live**, broker Onam Trading,
modalita' **Hedge**, valuta **EUR**; numero e intestatario **non trascritti di proposito**), ore
server 11:27:32 e 11:29:32. La terza schermata e' **nostra** (100k `50504263`, vedi §4.6).
**Tutti i numeri qui sotto sono letti dalla foto e ricontati in Python.** Niente toccato.

### 4.1 ⏰ L'orologio del conto [INFERITO]
La prima operazione del giorno apre alle **10:00:03 server** e chiude 25 secondi dopo con +39
punti: e' l'apertura cash del DAX (09:00 IT), quindi **server = ora italiana + 1** (come FTMO).
Contro-esempio: se il server fosse l'ora italiana, 10:00:03 sarebbe un minuto qualunque della
mattina, e uno scatto di 39 punti in 25 secondi a un orario casuale e' molto meno plausibile.
Da qui: i sell limit DAX sono stati piazzati alle **08:48, 09:06 e 09:07 italiane**, cioe' in
**pre-apertura e in apertura**, dentro la live.

### 4.2 🔢 Cosa si legge, ricontato
| | dato | fonte |
|---|---|---|
| saldo / equity alle 11:27 | 439,92 / 467,52 EUR; margine 20,31 per 0,4 lotti = **leva ~1:500** [DERIVATO: 0,4 x 25.385,55 / 20,31] | schermata 1 |
| valore del punto DAX | **1 EUR/punto/lotto** (39 punti x 1,0 = 39,00; 69 x 0,4 = 27,60) | schermate 1-2 |
| chiuso nel giorno | **+85,40 EUR** su 5 operazioni, tutte long `GEREUR` | schermata 2 |
| saldo d'inizio giornata | **387,92** [DERIVATO: 439,92 - 52,00 chiusi prima delle 11:27] -> fine 473,32 = **+22,0% in una mattina** | 1+2 |
| 1 lotto sul saldo d'inizio | nozionale **~65 volte il saldo**: 388 punti contro = conto azzerato | [DERIVATO] |
| stop sui DAX | **nessuno** su 5 chiuse + 1 aperta + 4 pendenti, salvo uno a 0,6 punti dall'ingresso (di fatto un pareggio) | schermate 1-2 |

### 4.3 ✅ Cosa chiudono dei buchi del §1 (G1-G7)
- **G7 / P5 — CHIUSO**: le size sono **lotti veri**: sell limit **0,2 @ 25.503,42 · 0,5 @ 25.517,24 · 1,0 @ 25.529,13** (size crescente verso l'alto, M10). **P7 — CHIUSO**: *"una 04 e una 08"* = buy **0,4 @ 25.385,55** (aperto) + buy limit **0,8 @ 25.373,02**. P6 (*"0.020, 0.040"*) resta non ricostruito.
- **G2 / P8 — CHIUSO in parte**: *"500, 509"* = il **tondo 25.500** (il primo sell limit sta a +3,42) e un **livello disegnato a 25.509,48** (etichetta sull'asse destro). Altri livelli disegnati: 25.468,00 e 25.384,66. P9-P11 restano [INFERITO].
- **G4 — CAMBIA**: la coppia con i pendenti a schermo non e' GBPJPY ma **CHFJPY** (la trascrizione diceva *"CHFGV"* [INCERTO]): **sell LIMIT** (ritorno), non sell stop: 0,6 @ 191,241 e 0,3 @ 190,989, **stop comune 191,510**.
- **G6 — CHIUSO in parte**: l'indicatore e' **"VWAP-ATR PRO v3.20"** su M15, con VWAP 25.403,5, *Z-Score* 1,53 -> 2,00 in due minuti, *MTF BULL*. Tipo di ancoraggio: [NON VISIBILE].
- **Distanza fra i pendenti — MISURATA DIVERSA dal dichiarato**: sell 13,82 e 11,89 punti; buy 12,53 e 17,50. La live diceva **15-20** (P1-P2): in campo **12-18**.
- G1, G3, G5: nessuna risposta nelle foto.

### 4.4 🚩 Le bandiere, ora con i numeri
- **R1 CONFERMATA**: tre sell limit DAX piazzati fra le 08:48 e le 09:07 IT **mentre l'indicatore dice MTF BULL** e mentre lui compra: long e short sullo **stesso** conto (hedge).
- **R2 CONFERMATA in esecuzione**: buy 0,8 @ 25.416,05 (10:47:44) e **un minuto dopo** buy 0,8 @ 25.398,55 (-17,5 punti), chiusi insieme a +11,20 netti; poi buy 0,4 @ 25.385,55 con **0,8 sotto** @ 25.373,02 = **la size doppia sotto**, il "secondo giro".
- **R6 SUPERATA dai fatti**: la live diceva *"stop entro 40 euro"*. Sui DAX **lo stop a piattaforma non c'e'**. Sul CHFJPY, se entrambi i limit si riempiono e va a stop: **~176 EUR = 37,7% dell'equity** [DERIVATO: valore del pip 1.000 JPY / 180,24 EURJPY = 5,55 EUR per lotto; ipotesi **lotto forex standard da 100.000**, non verificabile dalla foto: con un lotto da 10.000 sarebbe il 3,8%].
- In una prop con perdita giornaliera al 5%: **un solo stop CHFJPY vale ~7 giornate di limite**; un giorno DAX come il 24/09 (~575 punti di escursione a schermo) contro 1 lotto senza stop **azzera il conto**.

### 4.5 🎯 Cosa cambia per noi
- **Niente di schierabile**, e nessun candidato nuovo: il metodo e' discrezionale, senza stop, con media al ribasso. Resta valido **solo S1** (RETEST sul massimo/minimo di ieri), gia' scritto al §2 e senza codice nuovo.
- 🔴 **Rischio hedging per Claudio, e non e' teorico**: FTMO (`docs/RISPOSTA_SUPPORTO_FTMO_2026-09-25.md`) vieta posizioni **opposte su indici correlati su conti diversi**, demo compresi. Oggi la sedia FTMO `770101` era **long GER40 @ 25.468,62** mentre questi sell limit stavano a 25.503-25.529. **Copiare a mano i suoi ordini** su un qualunque conto di Claudio mentre FTMO e' long DAX, Dow o Nasdaq = **esattamente il caso vietato**.
- Il +22% in una mattina e' **vero** (e' nella CroniStoria), ma e' il rovescio della stessa medaglia: leva ~1:500, 1 lotto su 388 EUR, niente stop. **Non e' un criterio e non entra in nessuna tabella.**

### 4.6 🖥️ La terza schermata e' la nostra: 100k `50504263`, 13:15 IT
Giornale: 24/09 22:50:30-22:52:47 rimossi `ABTG_DAX_Apertura_EU`, `ABTG_Dow_Apertura_US`, `ABTG_MaxMinNotte_DAX_Short_Ottimizzato`, `ABTG_ORB_Ottimizzato` (U30USD), `Nasdaq_PreOpen_Breakout_EA`; 25/09 **13:14:47** rimosso `ABTG_SupertrendReversal` (225JPY,H2). Barra di stato: profilo **`SQUADRA 100K`**. **Gia' agli atti** (`report/SOSPENSIONE_SEDIE_DEMO_2026-09-25.md`, ESEGUITO): nessun dato nuovo; il **salvataggio del profilo** resta da confermare con `CODA_01` del 26/09.

---

## 5. 📜 ADDENDUM 2 — IL DECALOGO PUBBLICATO LO STESSO GIORNO (2 screenshot, 25/09 ~15:36 IT)

**Fonte:** post *"Regole imprescindibili per il tuo trading profittevole"* nella comunita' del
corso, firmato dal relatore, pubblicato ~5 ore prima delle 15:36 IT (= la mattina della live).
Dieci regole di principio, **zero parametri con valore**. Confronto riga per riga con il nostro
codice e con **la pratica della stessa mattina** (§4, foto della piattaforma).

| # | regola (sintesi fedele) | da noi | la stessa mattina, a piattaforma (§4) |
|---|---|---|---|
| 1 | Aspetta il mercato: entra quando si presenta la configurazione prevista | ogni EA entra solo a condizione | — |
| 2 | Scegli prima lo strumento | simbolo fisso per sedia; la scelta giornaliera non e' codificabile senza una regola (S6: no) | — |
| 3 | Parti dalla direzionalita' | filtri di trend misurati, esiti misti (R101) | 🔴 3 sell limit DAX con l'indicatore su *MTF BULL* (R1) |
| 4 | Accordo fra volume e D1 | su CFD il volume e' **tick volume** (M12); filtro D1 = S2 | — |
| 5 | Piu' timeframe | come la 3 | — |
| 6 | Confluenze concrete: **il VWAP, da solo, non basta** | 🟢 **concorda con TRE nostre misure**: `ABTG_VwapRevert` S0 negativo 4/4 (03/09) · Retest-VWAP nudo **PF 1,002** su n=625 (31/08) · filtro VWAP R101 DAX **−0,061** | — |
| 7 | **Piano prima dell'ordine: stop definito in anticipo, anche per un pendente** | 🟢 **stop sul server sempre**, per costruzione | 🔴 **nessuno stop a piattaforma** sui 4 pendenti DAX e sul long aperto (uno stop mentale e' [NON MISURATO]); il CHFJPY lo stop ce l'ha |
| 8 | **Dimensiona la posizione sul rischio**; conto piccolo = piu' disciplina | 🟢 `InpRiskPercent` fisso per sedia (FTMO 2,00, firma di Claudio) | 🔴 1 lotto su ~388 EUR senza stop; CHFJPY a stop ~37,7% dell'equity [DERIVATO, §4.4] |
| 9 | Rispetta il piano dopo la live: il pendente lasciato sul VWAP va gestito con le stesse regole | l'EA lo fa per costruzione | alle 11:27 server il VWAP e' a 25.403,5 e **nessun pendente sta li'** (il piu' vicino: buy limit 25.373,02); se prima c'era: [NON MISURATO] |
| 10 | Valuta il processo, non il profitto: *"abbiamo ... rispettato il rischio?"* | 🟢 e' il nostro cancello e il certificato di morte | la risposta della mattina, **con le regole 7 e 8 del decalogo stesso**, e' no sul lato DAX |

**Lettura.** Il decalogo e' **buono** e coincide quasi riga per riga con regole che da noi sono
**codice**, non buoni propositi (7, 8, 10). La regola 6 e' l'unica che porta un contenuto
tecnico, e **le nostre misure le danno ragione** (tre volte). Lo scarto fra regola scritta e
pratica dello stesso giorno (3, 7, 8) e' il motivo per cui una regola, da noi, vale solo quando
e' dentro l'EA.

**Cosa ne copiamo: niente di nuovo.** Nessun parametro, nessun candidato. Una fonte in piu'
(sempre la **stessa**, quindi non una verifica) a favore di principi gia' in campo.

**Trovato strada facendo:** l'errata al §1.3 e S3 (il passo 0 di `ABTG_VwapRevert` era dato per
*"mai corso"*, ed e' corso e falsificato il 03/09): l'errore viene dal censimento del 22/09, r.413-419.
