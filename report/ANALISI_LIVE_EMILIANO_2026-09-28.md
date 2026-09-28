# 🎙️ ANALISI LIVE EMILIANO — lunedì 28/09/2026, 08:30 (Volume Profile + operatività ORO/DAX)

**Data referto:** 28/09/2026 · **Analista:** estrattore trascrizioni
**Fonte unica e archiviata:** `docs/live_emiliano/trascrizioni/LIVE_EMILIANO_2026-09-28.txt`
(**78/79 righe (`wc -l` conta 78: l'ultima riga non ha newline finale; `cat -n` arriva a 79) ·
48.233 byte**, TurboScribe auto-generato, caricata da Claudio, committata a `0031f4af`).
**Ogni riferimento `r.NNN` è il numero di riga di QUEL file** (righe pari = vuote fra un
paragrafo e l'altro: sono paragrafi molto lunghi, alcuni superano i 3.000 caratteri in
un'unica riga). Niente memoria, niente web, niente completamento dei buchi.

> ## ⛔ REGOLA CHE VALE SOPRA TUTTO
> **Da questo materiale non si muove NIENTE.** Ogni numero qui dentro è una
> **dichiarazione di una fonte esterna**, mai un criterio nostro. Un numero detto in
> una live **non entra in nessun cancello, non tocca nessun preset, non cambia
> nessun forward**. Nessun EA, nessun `.set`, nessun conto è stato toccato per
> scrivere questo referto.

> ### 🗣️ CHI PARLA — e perché conta (diverso dal 18/09)
> Questa live è **quasi interamente Emiliano da solo**: parla, condivide schermo, opera
> in prima persona su ORO e DAX. È l'**opposto** della live del 18/09 (85% Luca al
> monitor). Luca viene **citato** due volte come fonte di un'opinione (*"Io concordo
> con la visione di Luca"*, r.73; *"vado ad inserire il Supertrend come dice Luca. Luca
> mi dici dov'è il Supertrend?"*, r.75) ma **non risulta mai al monitor**: [ATTRIBUZIONE
> NON CHIARA] su cosa esattamente ha detto Luca fuori da questi due riferimenti. Altri
> nomi citati solo come interlocutori in chat: **Roby/Robi/Robby/Roberto/Robin** (autore
> dell'indicatore, quasi certamente la stessa persona con la resa STT instabile),
> **Fabrizio** (r.59), **Federica Parigi** (interruzione personale, r.61), **Mattia**
> (r.79), **Giorgio** (assente, citato per la "Camera del Consiglio", r.31).

> ### ⚠️ QUALITÀ DELLA TRASCRIZIONE
> Medio-bassa, e con un tratto nuovo rispetto alle live precedenti: **paragrafi enormi
> senza punteggiatura** (r.27 da solo supera i 7.000 caratteri e mescola almeno sei
> argomenti diversi in un flusso unico). Storpiature sistematiche:
> **VWAP → "WAP"/"VVAP"** (stessa resa del 18/09 e del 25/09) · **weekly → "V1"/"Wheatley"
> (implicito)** · **Supertrend → "super training"/"super trem"** · **Claude Code →
> "Cloud Coder"/"l'Oculo Code"** · **ChatGPT → "IgpT"** · **DAX → "il German"/"l'aura"
> (r.33, [NON CHIARO])** · **candela → "cadere" (r.27, unico caso, probabile inciampo
> STT su "sui [una] candela a 15 minuti")** · **FastStone (screenshot tool) → "Fastone"**
> · **numero non riconosciuto → "trentasettocento"-style non presente oggi, ma prezzi
> smembrati**: *"3,40, 3,40"* (r.71), *"25 e 3,25, 25 e 3,24"* (r.77), *"5,26"* (r.77) —
> tutti **[NON CHIARO]**, probabili livelli DAX a 5 cifre con la punteggiatura persa
> nello speech-to-text (es. "25.325,00"?). **Non interpreto**: un numero indice storpiato
> è peggio di nessun numero.

---

# ⭐ PARTE 1 — LA SINTESI INCROCIATA

## 1.0 🔥 LA RIGA CHE CONTA

> **Su 79 righe (40 paragrafi): 19 parametri con valore, 18 meccanismi, 6 bandiere
> (ZERO rosse piene: martingala 0 · griglia 0 · hedging 0 · mediazione/recovery 0 ·
> no-stop 0 · trucchi anti-prop 0 · prop/FTMO/challenge/drawdown/giornaliero/capitale/
> perdita: 0 occorrenze — verificato con `grep` termine per termine).**
>
> **Il pezzo che vale di più non è un numero: è una frase che descrive il MECCANISMO
> che noi chiamiamo RETEST, detta con parole diverse e generalizzata a QUALSIASI
> livello** (r.27): *"quando c'è un ritest viene confermato il livello... quindi se i
> prezzi violano io non entro alla violazione, **metto un ordine pendente sul pull
> back**"*. 🟢 **Questo è, testualmente, `InpEntryMode = ABTG_RETEST` — già default sul
> DAX (`770101`/`770105`) — esteso dalla fonte a ORB, medie, supporti E ORA ANCHE alla
> Volume Area/POC del Volume Profile.** Non è nuovo come principio (confermato in 4
> live su 4 finora), ma oggi arriva **generalizzato esplicitamente**, non per un solo
> setup.
>
> **La seconda cosa che conta è una bandiera, non un numero**: lo stop del secondo
> ingresso sull'oro (0,5 lotti) viene calcolato a **1.000 €**, giudicato *"troppo"*, e
> **spostato più vicino per il conto in euro, non per un livello di struttura nuovo**
> (r.49) — la stessa classe di errore ("il rischio piegato al grafico" rovesciato: qui è
> "il grafico piegato al conto") già vista il 18/09 (bandiera B4) e coerente con la
> pratica del 25/09 (stop di 40 € dichiarati contro nessuno stop reale in campo).

---

## 1.1 🏆 LE COSE CHE VALGONO DAVVERO

### 🥇 1. IL VOLUME PROFILE — lezione teorica completa, e il principio d'ingresso è il NOSTRO RETEST generalizzato

| # | concetto | citazione | riga | etichetta |
|---|---|---|---|---|
| a | **Value Area = 70% dei volumi** (convenzione) | *"c'è un area che racchiude il 70% dei volumi che per convenzione è quello che ci interessa"* | **r.11** | 🟢 chiaro |
| b | **Alternativa 80%, ma si resta a 70%** | *"la value area potremmo metterla anche all'80%, ma per convenzione si lascia a 70"* | **r.31** | 🟢 chiaro |
| c | **POC = prezzo dove è stato scambiato il maggior volume** | *"il POC che invece è il prezzo a cui è stato scambiato il numero di contratti"* · *"il POC è il prezzo forse più importante, è il prezzo dove si è concentrato il picco di volume"* | r.11, r.15 | 🟢 chiaro |
| d | **HVN/LVN = zone di equilibrio / zone di vuoto** | *"high value node e low value node, sono zone dove il mercato ha contrattato a lungo e in modo equo... rappresentano un accordo tra compratori e venditori"* · *"low value node sono l'esatto opposto, sono zone dove è passato pochissimo volume"* | r.15, r.17 | 🟢 chiaro |
| e | **Forma "P" = forza compratori → aspetta il pullback in LVA/POC prima di comprare** | *"i volumi sono nella parte alta, la P... io andrò ad aspettare i prezzi che vanno nella low value area per andare poi a prendere il rialzo"* | **r.19** | 🟢 chiaro |
| f | **Forma "b" minuscola = forza venditori → pullback su POC/HVA prima di vendere** | *"come se fosse una lettera B minuscola... la forza dei venditori è più importante... cercheremo di entrare su un pullback volumetrico... su dei livelli che possono essere il POC o... la high value area"* | **r.21** | 🟢 chiaro |
| g | **Forma "B" maiuscola = battaglia sui minimi, difesi** | *"i venditori hanno spinto il prezzo giù, ma la pressione [di chi acquista] ha arrestato la caduta... noi cercheremo di entrare o sulla rottura dei minimi oppure meglio ancora sulla high value area o sul POC"* | **r.23** | 🟢 chiaro |
| h | **Fair Value Gap nasce da un Low Volume Node** | *"il Fair Value Gap... nasce proprio da un low volume node, cioè... quando usciamo dalla nostra area, vedete che qua ci sono scarsità di volumi e proprio questa scarsità di volumi permette poi al prezzo di prendere una direzione ben definita una volta che fa il breakout"* | **r.23** | 🟢 chiaro — **[dichiara di essere un concetto "che sui social non viene mai spiegato"]**, dichiarazione della fonte, non verificabile da noi |
| i | 🥇 **RETEST come regola generale d'ingresso** | *"quando c'è un ritest viene confermato il livello... quindi se i prezzi violano io non entro alla violazione, **metto un ordine pendente sul pull back**"* | **r.27** | 🟢 chiaro — **è la frase che vale di più della live (§1.0)** |
| j | **Conferma di breakout: volumi in aumento + candela con "sederino" oltre la HVA** | *"la conferma viene data da il sederino della candela che mi apre sopra la high value area, quindi dobbiamo andare a vedere i volumi a histogramma"* | **r.25** | 🟢 chiaro |
| k | **POC come bias direzionale** | *"il POC che ci dice se i prezzi stanno sopra sono prezzi in una condizione rialzista, se i prezzi stanno sotto in una condizione ribassista"* | **r.27** | 🟢 chiaro |

#### 🔬 IL CONFRONTO COL REPO — e qui c'è una scoperta vera, non solo una convergenza

🔴 **Il nostro stesso repo ha già una posizione scritta su questo tema, e dice NO
all'automazione.** `mql5/Experts/ABTG_DAX_M3.mq5` r.17-18 (intestazione dell'EA):

```
//  ⚠️ NON automatizzato (richiede occhio umano, come da guida):
//     Wyckoff, VWAP/POC, Supply&Demand, "qualita' del movimento".
```

E `backtest_pipeline/REGISTRO_TEST.md` r.379+394 (sintesi di **un'altra fonte**, Paolo,
sei live, **non Emiliano**): *"Paolo fa... Wyckoff/Volume Profile... Da NON
automatizzare: ...VWAP/volumi letti a occhio"*.

> ## 🟡 **Non è una contraddizione fra fonti (Emiliano non dice "automatizzatelo"): è
> una nostra decisione pregressa, presa guardando un'ALTRA fonte, che oggi la live di
> Emiliano rende più concreta.** Il Volume Profile, nella lettura di CASA NOSTRA prima
> di oggi, era già classificato "richiede occhio umano" — non per pigrizia, ma perché
> le forme "P"/"b"/"B" (h-i-j sopra) sono un **giudizio visivo sulla distribuzione**,
> non una soglia numerica. Oggi la live **conferma perché**: nessuna delle regole
> a-k sopra ha un numero che la renda una condizione IF-THEN pulita (quanto deve
> "assomigliare" a una P? quanti punti separano "P" da "B maiuscola"?).
> 👉 **Verdetto onesto**: il Volume Profile **non diventa un candidato per un file
> prova**. Resta un filtro di lettura discrezionale, coerente con la nostra stessa
> decisione di progetto.

**L'unico pezzo con potenziale operativo diretto è (i), il RETEST**, perché è
**esattamente** il meccanismo che già codifichiamo (`InpEntryMode = ABTG_RETEST`,
default su `770101`/`770105`). La fonte lo applica anche ai livelli del Volume Profile
(POC/VA), che noi non calcoliamo — quindi **non aggiunge un asse nuovo**, aggiunge
**una quarta conferma indipendente dello stesso principio**, dopo ORB (18/09), medie
(10/04) e massimo/minimo di ieri (25/09). 🔴 **E resta la stessa fonte**: quattro
conferme dallo stesso relatore non sono quattro verifiche indipendenti.

**L'imbalance/FVG ha già un cugino in casa, con una regola DIVERSA**:
`ABTG_DAX_M3.mq5` r.386 (fonte: Paolo, non Emiliano): *"Imbalance/FVG: se la candela
successiva chiude DENTRO l'imbalance → rientro (gap richiuso); se chiude FUORI →
prosecuzione"*. Emiliano oggi (r.27, r.45) descrive l'imbalance come **target di
rientro dopo lo stop** ("vado a ritentare un ingresso alla chiusura di un imbalance"),
non come segnale dentro/fuori sulla candela successiva. 🟡 **Sono letture compatibili
ma non identiche**: nessuna delle due è codificata da noi oggi, e nessuna delle due ha
un numero (quanto deve chiudere "dentro"? quanti punti di imbalance sono
significativi?).

---

### 🥈 2. L'OPERATIVITÀ SULL'ORO — long CONTRO il piano, e la bandiera dello stop spostato per soldi

**La sequenza, in ordine di citazione** (🔴 nota di onestà: il racconto NON è lineare —
r.27 narra già un primo ciclo stop→re-ingresso su M5, poi r.33 dice *"andiamo a vedere
di recuperare questo piccolo stop loss"* e da r.35 sembra ripartire/continuare lo
**stesso** trade con l'aula. Non risolvo la sequenza esatta, cito nell'ordine del file):

| # | momento | citazione | riga |
|---|---|---|---|
| 1 | **Piano dichiarato: weekly e daily SHORT** | *"i weekly, abbiamo un weekly ribassista, abbiamo un daily ribassista, quindi tendenzialmente noi dobbiamo entrare in show [short]"* | **r.27** |
| 2 | **Ma NON entra short dopo una candela enorme** | *"perché entrare in show dopo una candela di oltre... 100 dollari... su un livello di supporto, anche no"* | r.27 |
| 3 | **Sceglie il LONG contro-piano, sul supporto weekly** | *"cerco di sfruttare magari un long ribimbalzo che può fare soltanto se arriva sul livello importante"* · *"questo è un supporto weekly... si è fermato sul supporto weekly"* | r.27 |
| 4 | **Discesa "senza volume" come setup** | *"questa discesa senza volumi... sta scendendo senza volume, quindi è andato al di fuori della low value area"* | r.27 |
| 5 | **1° ingresso: stop ≈400 €, ≈1% dichiarato su "40.000"** | *"ho 400 euro di stop... 400 euro sono... se questo è 40.000 sarebbe meno di un per cento, sì, circa un per cento"* | **r.27** |
| 6 | **Stop preso** | *"sono uscito in stop, stop strettissimo"* | r.27 |
| 7 | **Re-ingresso pianificato sulla chiusura dell'imbalance** | *"andrei a ritentare un ingresso alla chiusura di un imbalance"* | r.27 |
| 8 | **Ripresa in diretta: size 1+2, stop sotto supporto** | *"metto un contratto e due contratti qua sul mio livello come ho indicato prima, uno e due... lo stop lo metto qua sotto"* | **r.35** |
| 9 | **Dichiara la controtendenza** | *"Ora, sto lavorando in controtendenza"* | **r.37** |
| 10 | **Stop sfiorato, riposiziona** | *"Mi ha sfiorato... quindi 0.5, mi ha sfiorato. Quindi questi li abbasso, mi metto uno sotto e uno qua"* | **r.39** |
| 11 | **Ammette che lo short avrebbe pagato** | *"il weekly è short, il daily è short... Ma con un movimento così importante di bassista che ha fatto la sessione asiatica... io non mi sono fidato di entrare in short. Anche se qua avrebbe pagato, non me la sono fidata"* | **r.41** |
| 12 | **0,5 lotti + due ordini spostati sul supporto** | *"Io sono entrato con uno 0.5 e ho spostato gli altri due ordini sul livello di supporto"* | r.43 |
| 13 | **Divide in tre, più rischio** | *"Quindi divido in tre. Qua mi sto prendendo un po' più di rischio"* | r.45 |
| 14 | 🚩 **Stop calcolato a 1.000 €, giudicato "troppo", spostato per SOLDI** | *"Lo stop di questo 0.5 sono 1000€, quindi tecnicamente andrebbe qua sotto. Non lo posso mettere qua sotto perché sono 1000€... troppo. Quindi scendi il game frame e lo metto sotto questi due massimi"* | **r.49** |
| 15 | **Target: 1-2 ATR, ATR(14) dichiarato** | *"cerca[i] l'ATR e cerco di fare uno o due ATR... prendo l'ATR, lo mettiamo a 14... sono 35 dollari l'H4... l'ATR ci dice 16 dollari"* | **r.79** |
| 16 | **Giustificazione ricorrente, non misurata** | *"questa operazione la tento sempre... perché il 90% delle volte vado a profitto"* | **r.27** |

> ## 🚩 BANDIERA (arancione): **la #14 è la stessa classe della bandiera B4 del 18/09**
> ("il rischio piegato al grafico"), ma **rovesciata**: lì lo stop restava sul grafico
> anche se sforava il budget; qui **lo stop viene spostato PER il budget in euro**,
> abbandonando il livello di struttura originale ("qua sotto" i due massimi, non più il
> livello indicato dal supporto/imbalance). **Non si copia nessuna delle due
> direzioni**: da noi lo stop è sempre di STRUTTURA (range/ATR/Supertrend), la taglia si
> adatta allo stop, mai il contrario (`CalcLotByRisk`, riga 1791-1828 di
> `ABTG_DAX_Apertura_EU.mq5`, stessa logica sull'oro).

> ## 🚩 BANDIERA (arancione): **controtendenza dichiarata due volte** (r.37, e implicita
> in r.41): sull'oro **e** sul DAX (§3 sotto). Coerente con il pattern già visto il
> 25/09 (bandiera R1, "ordini contro trend in pre-apertura contro la sua stessa
> regola") — **quarta occorrenza della stessa classe da parte della stessa fonte**
> (10/04 mediazione contro-piano, 18/09 nessuna, 25/09 R1, oggi). Non è indipendente:
> è lo **stesso tratto comportamentale che ricorre**.

#### 🔬 Confronto col repo

| voce | noi | la live |
|---|---|---|
| Sedia oro in bozza | `770402` (`ABTG_MaxMinNotte`, XAUUSD H2, box 23:00-04:59 BCM), R260a: PF **1,336** su **279 posizioni**, DD equity **4,52%** a **0,5%** — ancora in bozza, non in campo (`report/SEDIA_ORO_LONG_FTMO_BOZZA_2026-09-27.md`) | rischio per trade **variabile e più largo**: ≈1% (400€/40.000, 1° ingresso) poi uno stop calcolato a **~2,5%** (1.000€/40.000) giudicato eccessivo **a naso**, non contro una taglia fissa |
| Meccanismo | box notturno fisso, un ciclo/giorno, taglia `InpRiskPercent` fissa | discrezionale, size cresce a ogni ri-ingresso (1+2, poi 0,5+0,5+0,5), nessuna taglia fissa dichiarata |
| Direzione | R260a = **solo long** in bozza | oggi: **long contro il piano short** — non è comparabile a R260a (che è già solo-long) ma è la controprova che nella pratica dal vivo la direzione **si decide sul momento**, non dal piano settimanale |

🔴 **Nessun numero di oggi entra nel pacchetto `770402`**: sono trade discrezionali su
un conto/size non dichiarati, non misurabili, non convertibili in un parametro.

---

### 🥉 3. IL DAX — pendenti LONG contro il piano, "fuori dal mio piano" detto esplicitamente

| # | citazione | riga |
|---|---|---|
| Piano dichiarato | *"In DAX abbiamo weekly short, daily short"* | **r.53** |
| Setup operativo scelto | *"il DAX lo stop, aspettando Long sui minimi di venerdì in corrispondenza del super training [Supertrend] di H1"* | **r.67** |
| Confluenza VWAP | *"il DAX qua si è appoggiato sul VVAP"* | r.67 |
| Due livelli, due size | *"io mi vado a mettere 10 contratti sui minimi di venerdì... e 20 contratti me li metto su questo livello di supporto"* | **r.75** |
| Supertrend come confluenza | *"vado ad inserire il Supertrend come dice Luca"* | r.75 |
| Size ridiscussa, incoerente in diretta | *"ho messo 10 e 20, potrei mettere 5, potrei mettere 10 e 29, il conto me lo consente... potrei divenire 5, 10 e 10"* | **r.77** |
| Scadenza dei pendenti | *"se non vengo eseguito prima dell'America li cancello"* | r.77 |
| 🚩 **Ammissione esplicita di operare fuori piano** | *"oggi io non sto andando a eseguire il mio piano perché oggi ho Short e Weekly... sto andando fuori dal mio piano... in realtà il nostro piano ci dice se sei direzionale vai in direzionale, punto e basta"* | **r.77** |
| Alternativa short compatibile col piano, tenuta in riserva | *"un livello dove entrare Short... potrebbe essere 5,26... lo deciderò in divenire... metto 5 contrattivi qua"* | r.77 |
| Serve "il fegato" per entrare short | *"entrare Short devi avere il fegato, almeno si deve avere il fegato"* | **r.79** |
| Nessun livello D1 utile | *"se vado a vedere se in D1 c'è un livello, non c'è"* | r.79 |

> ### 🟡 Lettura, non bandiera piena: **tiene aperti entrambi i lati** (pendenti long
> "fuori piano" + un possibile short "in piano" più lontano), non abbandona la
> direzione del piano — la **esegue per ultima e più piccola** (5 contratti contro
> 10+20). È più simile a un hedging **di intenzione** (due ordini opposti pendenti)
> che a un abbandono del piano. 🟠 **Ma l'ammissione "sto andando fuori dal mio
> piano" resta testuale e va registrata come bandiera**, non minimizzata: è la fonte
> stessa a dirlo, senza che glielo si chieda.

#### 🔬 Confronto col repo — l'ORB, ancora

*"questo sui [una] candela a 15 minuti, quindi io lavoro l'ORB con un [una] candela a
15 minuti, quindi dopo 15 minuti traccio... un livello di massimo, di minimo"* (r.27,
🟡 `[TRASCRITTO dubbio]` su "cadere" = probabile "candela").

> ## ⚖️ **È una contraddizione numerica o no, rispetto al 18/09 ("ORB = 3 candele M5")?**
> **Nessuna contraddizione nel NUMERO finale**: 3×M5 = 15 minuti, e oggi la fonte dice
> di nuovo **15 minuti** — è la **quarta** volta che questa stessa fonte dichiara
> 15 minuti per l'ORB (18/09, 10/04, e ora), sempre la stessa fonte quindi **non**
> quattro verifiche indipendenti. 🟡 **Possibile differenza di MECCANISMO, non
> risolvibile dall'audio**: oggi dice "una candela a 15 minuti" (singola candela M15?)
> contro il 18/09 "tre candele" (3× M5 osservate mentre si formano). Il risultato
> numerico coincide, il modo di costruirlo potrebbe non coincidere — **non lo so, e non
> lo deduco**.
> 🏆 **Il cancello di casa non si riapre lo stesso**: la nostra misura resta
> **35-45 minuti = 8/8 celle OOS positive contro 5-15 minuti = 0/8** (`DIARIO.md`
> r.54, confermata nei referti del 18/09 e del 21/09). Una quarta ripetizione della
> stessa fonte non è una nuova prova.

---

### 4️⃣ LA SCHERMATA OPERATIVA — Bollinger 37,3, VWAP, Supertrend: **strumenti che oggi non abbiamo in campo**

| # | citazione | riga |
|---|---|---|
| Bollinger sull'oro | *"le bandi di Bollinger, io sull'oro le metto a 37,3, perché l'oro è molto volatile"* | **r.57** |
| Bollinger sul DAX, stesso valore | *"sia DAX che oro li vado a trattare con le bandi a 37,3"* | **r.59** |
| Bollinger ridotta in alta volatilità | *"se sono in una condizione di mercato dove... c'è proprio volatilità, scendo a 22"* | r.59 |
| Uso delle bande | *"vado a vedere se le bandi si distringono o si allargano"* (squeeze/espansione come lettura) | r.63 |

🔴 **Nessun EA in campo usa Bollinger Bands.** Verificato: nessuna occorrenza di
`iBands`/Bollinger in `ABTG_DAX_Apertura_EU.mq5`, `ABTG_MaxMinNotte.mq5`,
`ABTG_Dow_Apertura_US.mq5`, `ABTG_EMA200.mq5`, `ABTG_SuperWave.mq5`. Le uniche
occorrenze nel repo sono in EA **standalone non schierati** (`ABTG_BreakingBand.mq5`,
`ABTG_Bulge.mq5`, `ABTG_GoldenCross*.mq5`, indicatori dashboard). 🟡 **È un pezzo
davvero nuovo** — nessuna live precedente aveva dato un periodo (37) e una deviazione
(3) per le Bollinger — ma **senza una regola IF-THEN dichiarata** (solo "guardo
l'inclinazione e se si allargano"): non è implementabile senza altre misure.

VWAP e Supertrend confermano quanto già in casa (`InpUseVwapFilter`,
`InpUseSupertrend`, `InpStAtrPeriod = 10`, `InpStMultiplier = 2.5` di default,
`InpUseSupertrend3` = 2,5/3,0/3,5 — `ABTG_DAX_Apertura_EU.mq5` r.308-311), ma oggi
VWAP è usato **come livello-obiettivo** ("la mediana del VWAP... è un livello
obiettivo", r.73), **una terza forma d'uso diversa** da filtro (18/09: `InpVwapTF`)
e da stop (18/09: "la chicca", stop sopra il VWAP) — coerente con quanto già notato
il 25/09 ("VWAP usato in 3 modi diversi").

---

### 5️⃣ META — "Claude Code può lavorare direttamente sull'MT5" + la "Camera del Consiglio" di Giorgio

| # | citazione | riga |
|---|---|---|
| Generazione `.set` con IA | *"gli potrei far produrre già un file set ad esempio, quindi il file set è il file che qua sotto si va, carica, e gli potrei far produrre"* | **r.29** |
| Claude Code sull'MT5 | *"con Cloud Coder, in realtà, se io vado all'interno di Windows PowerShell con Cloud Coder, Cloud Coder può entrare e lavorare direttamente sull'MT5, su Betest [backtest], cioè può fare tantissime cose con Cloud Coder"* | **r.29** |
| Camera del Consiglio (Giorgio) | *"ha creato la Camera del Consiglio... nel blog qualsiasi cosa c'è la Camera del Consiglio che si confronta e gli dà le indicazioni"* | **r.31** |

> ### 🔗 Rilevante PER NOI, oggi stesso: `docs/COMANDO_GEMINI_AGENTI_EA_2026-09-28.md`
> Lo stesso giorno di questa live, Claudio ha fatto scrivere un comando per **tre/quattro
> agenti Gemini** (Lettore di EA, Auditor del sistema, Proponente, Avvocato del diavolo)
> che si confrontano e producono proposte **passate dal cancello prima di muovere
> qualunque cosa**. È la **stessa idea strutturale** della "Camera del Consiglio" di
> Giorgio (più agenti che si confrontano su un problema di trading/configurazione), con
> una differenza di casa che vale la pena scrivere: 🔴 **il nostro comando impone
> ESPLICITAMENTE il divieto di proporre azioni** (Agente 1 "non proporre ancora
> migliorie", Agente 3 "le proposte non si eseguono: tornano al cancello") — non sappiamo
> se la Camera del Consiglio di Giorgio abbia lo stesso vincolo, la fonte non lo dice.
> **Non è un'evidenza che il nostro sistema sia migliore o peggiore**: è solo la nota che
> l'idea di più agenti/IA che si confrontano prima di agire su un EA sta circolando
> **in parallelo, fuori e dentro il nostro giro**, lo stesso 28/09.

---

## 1.2 📋 TABELLA DEI VALORI — TUTTI i parametri con valore, in un posto solo

🔴 **Colonna "fonte" = sempre "dichiarato da Emiliano". Mai un criterio nostro.**

| # | parametro | valore | citazione (troncata) | riga | etichetta |
|---|---|---:|---|---|---|
| P1 | Value area | **70%** (convenzione) | *"racchiude il 70% dei volumi"* | r.11 | 🟢 chiaro |
| P2 | Value area alternativa | **80%** (scartata) | *"potremmo metterla anche all'80%, ma per convenzione si lascia a 70"* | r.31 | 🟢 chiaro |
| P3 | Righe di histogramma (Volume Profile) | **120** (punto di partenza) | *"le righe di histogramma, 120 come punto di partenza"* | r.31 | 🟢 chiaro |
| P4 | Giorni da mostrare (Volume Profile) | **10** | *"io ne metterei 10... io metterei 10 qua"* | r.27 | 🟢 chiaro |
| P5 | Riferimento orario indicatore | **BROKER**, non New York 17 | *"corrisponde al 17 di New York, ma siccome non corrisponde... noi dobbiamo mettere il riferimento broker"* | r.27 | 🟢 chiaro — **rilevante per il pacchetto ORO 770402 se mai si usasse questo indicatore** |
| P6 | Bollinger oro/DAX | **37, 3** (periodo, deviazione) | *"io sull'oro le metto a 37,3"* · *"sia DAX che oro... con le bandi a 37,3"* | r.57, r.59 | 🟢 chiaro sul numero |
| P7 | Bollinger in alta volatilità | **22** | *"scendo a 22"* | r.59 | 🟢 chiaro sul numero, 🟡 momento del giorno **[NON CHIARO]** ("a mezzogiorno, luna") |
| P8 | Stop 1° ingresso oro | **≈400 €** ≈ **1%** su **≈40.000** dichiarato | *"ho 400 euro di stop... se questo è 40.000 sarebbe meno di un per cento, sì, circa un per cento"* | **r.27** | 🟢 chiaro |
| P9 | Stop 2° ingresso oro (0,5) | **1.000 €** ≈ **2,5%**, giudicato eccessivo | *"Lo stop di questo 0.5 sono 1000€... troppo"* | **r.49** | 🟢 chiaro, [DERIVATO] la % |
| P10 | Size oro (1° ciclo) | **1 + 2** contratti | *"metto un contratto e due contratti"* | r.35 | 🟡 unità (lotti/contratti) [INFERITO] |
| P11 | Size oro (2° ciclo) | **0,5 / 0,5 / 0,5** | *"uno 0.5... 0,5, mi ha sfiorato... con uno 0.5"* | r.39, r.43, r.47 | 🟢 chiaro |
| P12 | Contratti DAX (minimi venerdì / supporto) | **10 / 20** | *"10 contratti sui minimi di venerdì... 20 contratti... su questo livello"* | **r.75** | 🟢 chiaro |
| P13 | Ridiscussione size DAX | **5 / 10 / 29** poi **5 / 10 / 10** | *"potrei mettere 5, potrei mettere 10 e 29... potrei divenire 5, 10 e 10"* | **r.77** | 🟡 **incoerente in diretta, la fonte stessa esita** |
| P14 | Size short DAX alternativo | **5 contratti** | *"metto 5 contrattivi qua"* | r.77 | 🟢 chiaro sul numero |
| P15 | Periodo ATR | **14** | *"prendo l'ATR, lo mettiamo a 14"* | r.79 | 🟢 chiaro |
| P16 | ATR H4 oro | **35 dollari** | *"sono 35 dollari l'H4"* | r.79 | 🟢 chiaro |
| P17 | ATR H1 oro | **16 dollari** | *"l'ATR ci dice 16 dollari"* | r.79 | 🟢 chiaro sul numero principale, 🔴 *"65, 71"* seguenti **[NON CHIARO]** |
| P18 | Target oro | **1-2 ATR** | *"cerca[i] di fare uno o due ATR"* | r.79 | 🟢 chiaro |
| P19 | ORB | **candela/candele a 15 minuti** | *"io lavoro l'ORB con un[a] cadere [candela] a 15 minuti"* | **r.27** | 🟡 `[TRASCRITTO dubbio]` sul termine, 🟢 chiaro sul numero — **4ª ripetizione della stessa fonte** |
| — | Livelli DAX (garbled) | *"3,40, 3,40"* · *"25 e 3,25, 25 e 3,24"* · *"5,26"* | r.71, r.77, r.77 | 🔴 **[NON CHIARO]** — probabili prezzi a 5 cifre con punteggiatura persa. Non interpreto |
| — | Win rate dichiarato (aneddotico) | **"90%"** su questo setup specifico | *"il 90% delle volte vado a profitto"* | r.27 | 🔴 **[dichiarato, NON verificato]** — nessuna misura, nessun campione dichiarato |

### ⏰ NOTA SUL FUSO — e perché NON converto

Nessun orario con fuso esplicito è citato oggi (a differenza del 18/09 che aveva
09:10/09:30/11:07/12:30). L'unico riferimento temporale è *"prima dell'America"*
(r.77, cancellazione dei pendenti DAX prima dell'apertura USA) — **relativo**, non
un orario assoluto: non richiede conversione e non entra in un fuso specifico.
👉 **Nessun orario convertito. Nessun orario entra in un `.set`.**

---

## 1.3 🧰 I MECCANISMI — 18, in ordine di apparizione

| # | meccanismo | come descritto | riga |
|---|---|---|---|
| M1 | **Specializzazione per strumento e per sessione** | *"specializzarsi su alcuni strumenti... e lavorarli in una delle due sessioni"* (europea/americana) | r.7 |
| M2 | **Volumi CFD = parziali**, non il volume reale di mercato (solo sui future) | *"i volumi che noi vediamo... sono volumi parziali... il reale volume di mercato lo possiamo vedere esclusivamente su futures"* | r.9 |
| M3 | **Value Area / POC / LVA** come struttura del Volume Profile | vedi §1.1-1 | r.11, r.15 |
| M4 | **HVN = equilibrio, LVN = vuoto → prezzo accelera nel vuoto** | vedi §1.1-1 | r.15, r.17 |
| M5 | **Candele/gap importanti "devono essere recuperati"** | *"sappiamo che una candela importante ribassista o rialzista deve essere recuperata"* | r.17 |
| M6 | **Forma P/b/B → dove aspettare il pullback** | vedi §1.1-1 | r.19, r.21, r.23 |
| M7 | **Fair Value Gap = Low Volume Node** | vedi §1.1-1 | r.23 |
| M8 | 🥇 **RETEST generalizzato: MAI entrare alla violazione, sempre pendente sul pullback** | vedi §1.0 e §1.1-1 | **r.27** |
| M9 | **Conferma di breakout = volumi crescenti + chiusura/apertura oltre la HVA** | vedi §1.1-1 | r.25 |
| M10 | **POC come bias direzionale (sopra/sotto)** | vedi §1.1-1 | r.27 |
| M11 | **Cascata multi-TF: D1 → H4 → weekly → H1 → M15 → M5**, restringendo il TF aumenta il rischio di falso segnale | *"più stringo il time frame e più c'è rischio che ho un falso segnale... l'H1 è il più importante"* | r.27 |
| M12 | **Discesa/salita "senza volume" come setup di ingresso in controtendenza** | *"questa discesa senza volumi... potrebbe auspicare un bel ingresso su questo livello"* | r.27, r.47 |
| M13 | **Imbalance come target di rientro dopo lo stop** | *"andrei a ritentare un ingresso alla chiusura di un imbalance"* | r.27, r.45 |
| M14 | **Rifiuto di entrare short dopo una candela enorme, anche se il piano lo richiede** | *"entrare in show dopo una candela di oltre... 100 dollari... anche no"* | r.27 |
| M15 | 🚩 **Stop spostato per il budget in euro, non per la struttura** | vedi §1.1-2, bandiera | **r.49** |
| M16 | **VWAP come livello-obiettivo (non solo filtro/stop)** | *"la mediana del VVAP... è un livello obiettivo"* | r.73 |
| M17 | **Bollinger come lettura di volatilità (squeeze/espansione), non come trigger** | vedi §1.1-4 | r.57-63 |
| M18 | **Pendenti con scadenza legata alla sessione successiva** | *"se non vengo eseguito prima dell'America li cancello"* | r.77 |

---

## 1.4 🚩 BANDIERE — **6, ZERO rosse piene**

| # | bandiera | citazione che la prova | riga | verdetto |
|---|---|---|---|---|
| **B1** | 🚩 **Stop spostato per il BUDGET in euro, non per la struttura** | *"Lo stop di questo 0.5 sono 1000€... troppo. Quindi scendi il game frame e lo metto sotto questi due massimi"* | **r.49** | 🟠 **arancione.** Il rischio si dimensiona sullo stop di struttura, mai il contrario — è quello che fa `CalcLotByRisk` da noi, alla lettera opposta |
| **B2** | 🚩 **Controtendenza dichiarata due volte** (oro long contro weekly/daily short; DAX pendenti long "fuori dal mio piano") | *"sto lavorando in controtendenza"* (r.37) · *"sto andando fuori dal mio piano"* (r.77) | r.37, r.77 | 🟠 **arancione.** Quarta occorrenza della stessa classe dalla stessa fonte (10/04, 25/09, oggi) — **non indipendente**, ma **ricorrente** |
| **B3** | 🚩 **"Devi avere il fegato"**: decisione dichiarata come coraggio/istinto, non come regola misurabile | *"entrare Short devi avere il fegato, almeno si deve avere il fegato"* | **r.79** | 🟡 **ambra.** Non è operativo, è un criterio soggettivo dichiarato apertamente come tale — **non implementabile e non da copiare** |
| **B4** | 🚩 **Size DAX incoerente in diretta** (10+20 → "5, 10 e 29" → "5, 10 e 10") | vedi P13 | r.75, r.77 | 🟡 **ambra.** La fonte stessa esita fra tre combinazioni diverse nello stesso minuto — segno che la size è decisa "in divenire", non da un piano scritto |
| **B5** | 🚩 **Win rate dichiarato non misurato, usato per giustificare un trade ripetuto sistematicamente** | *"questa operazione la tento sempre... perché il 90% delle volte vado a profitto"* | **r.27** | 🟡 **ambra.** `[dichiarato, NON verificato]` per definizione di casa — nessun campione, nessuna fonte esterna |
| **B6** | 🚩 **Ambiguità sulla giustificazione del rischio maggiore** ("mi sto prendendo un po' più di rischio") senza una taglia fissa dichiarata | *"Qua mi sto prendendo un po' più di rischio perché questo 0.5"* | r.45 | 🟡 **ambra.** Coerente con B1: il rischio cresce a sensazione, non per una regola scritta |

### ✅ ASSENZE VERIFICATE (ricerca su tutto il file, con conteggio `grep`)

| pratica cercata | occorrenze |
|---|---:|
| **martingala** | **0** |
| **griglia / grid** | **0** |
| **hedging** (esplicito) | **0** — anche se i pendenti DAX su entrambi i lati (§1.1-3) si avvicinano concettualmente |
| **recovery / mediazione / averaging down** | **0** — `recuper*` compare 6 volte, ma descrive sempre il prezzo che "recupera" un gap/imbalance, **mai** una posizione mediata |
| **trading senza stop** | **0** — ogni ingresso ha uno stop dichiarato, anche se spostato per motivi discutibili (B1) |
| 🔴 **trucchi per aggirare le regole prop** | **0** — e zero contesto: nessuna menzione di prop/challenge/FTMO/drawdown/perdita giornaliera/capitale in tutto il file |

> ## 🟢 **Materiale PULITO sulle bandiere rosse: nessuna martingala, griglia, hedging o
> mediazione — quarta live su cinque (18/09, 25/09, oggi puliti; 10/04 con media
> pianificata) senza la bandiera rossa piena.** Le bandiere di oggi sono tutte
> comportamentali (stop per soldi, controtendenza, decisione "di fegato"), non
> strutturali.

---

## 1.5 🔗 COSA CONFERMA / COSA CONTRADDICE / COSA È NUOVO

### ✅ CONFERMA

| cosa | dove ce l'abbiamo | riga della live |
|---|---|---|
| **RETEST come principio d'ingresso** | `InpEntryMode = ABTG_RETEST`, default `770101`/`770105` | r.27 — 4ª conferma dalla stessa fonte |
| **ORB ≈ 15 minuti** | ripetizione della stessa fonte (18/09, 10/04) — non una nuova prova | r.27 |
| **VWAP come riferimento operativo** | `InpUseVwapFilter` — usato oggi come 3° modo (livello-obiettivo) | r.73 |
| **Supertrend 2,5/3,0/3,5, ATR period 10 di default** | `InpUseSupertrend3`, `InpStAtrPeriod = 10` (`ABTG_DAX_Apertura_EU.mq5` r.308-311) | r.75, r.77 |
| **Volume come conferma del breakout** | `InpUseVolumeFilter` / `InpVolMult` (promosso R101) | r.9, r.25 |
| **Volume Profile/POC "richiede occhio umano"** | decisione già scritta in `ABTG_DAX_M3.mq5` r.17-18, presa guardando un'altra fonte (Paolo) | tutta la lezione teorica |

### ❌ CONTRADDICE (nessun numero nostro sfidato oggi — solo il solito ORB)

| la live dice | noi abbiamo misurato | chi vince |
|---|---|---|
| **ORB = candela/e a 15 minuti** | banda **35-45 min = 8/8 OOS positive**, **5-15 min = 0/8** (`DIARIO.md` r.54) | 🏆 **la nostra misura**, quarta volta, stessa fonte |

### 🆕 NUOVO

| # | cosa | numero? | implementabile? |
|---|---|---|---|
| **N1** | Volume Profile completo (Value Area/POC/HVN-LVN/forme P-b-B) | 🟡 solo 70%/80% per la Value Area | 🔴 **NO** — già classificato "richiede occhio umano" da una decisione precedente presa su un'altra fonte |
| **N2** | Fair Value Gap = Low Volume Node (definizione) | ❌ nessun numero | 🔴 **NO** — concetto, non soglia. Cugino diverso dell'FVG già in `ABTG_DAX_M3.mq5` r.386 (fonte Paolo) |
| **N3** | Bollinger 37,3 su oro/DAX, 22 in alta volatilità | ✅ numeri chiari | 🔴 **NO** — nessun EA in campo usa Bollinger; regola IF-THEN non dichiarata (solo "guardo l'inclinazione") |
| **N4** | Imbalance come target di rientro post-stop | ❌ nessun numero (quanti punti di imbalance?) | 🔴 **NO** — manca la soglia |
| **N5** | Indicatore gratuito "RM Volume Profile" di Roby, impostazioni (giorni 10, riferimento broker, 120 righe, VA 70%) | ✅ numeri chiari | 🟡 **installabile a costo zero** se si volesse usarlo come lettura visiva, **non come segnale automatico** (coerente con N1) |
| **N6** | Stop per budget in euro invece che per struttura | ❌ pratica da NON copiare | 🔴 **NO — VIETATO PER NOI**: è la B1 |

---

## 1.6 🎯 L'INCROCIO CON LE SEDIE FTMO GIÀ IN CAMPO (non più "rosa di ottobre": la challenge FTMO `541452707` è viva dal 22/09)

| sedia | la live la tocca? | cosa ne esce |
|---|---|---|
| **`770101`/`770105` DAX Apertura RETEST** (long/short) | ✅✅ **la live è sul DAX per metà del tempo** | Il RETEST generalizzato (M8) è coerente col nostro `InpEntryMode=2`; l'ORB "15 minuti" ripete (senza riaprire) il cancello chiuso il 18/09; nessun numero nuovo su distanze/offset (a differenza del 18/09, oggi non ci sono soglie tipo "20pt sì, 40-50pt no") |
| **`770402` MaxMinNotte ORO** (bozza, non in campo) | 🟡 **indirettamente**: la live opera dal vivo sull'oro, ma con size/stop discrezionali non comparabili a R260a (PF 1,336, DD 4,52% a 0,5%, box notturno fisso). **Nessun numero di oggi entra nel pacchetto** | §1.1-2 |
| **`770411` MaxMinNotte DAX short** | 🔴 **NO diretto** — la live oggi parla di pendenti LONG sul DAX (contro-piano), non del motore notturno short | — |

---

# 📇 PARTE 2 — LA SCHEDA (formato di casa)

```
FILE             docs/live_emiliano/trascrizioni/LIVE_EMILIANO_2026-09-28.txt
                 (78/79 righe · 48.233 byte · TurboScribe auto)
RELATORE/CANALE  Emiliano (FTD/ABTG) — live mattutina delle 08:30, quasi solista.
                 Citati come interlocutori, non al monitor: Luca, Roby/Robi/Robby/
                 Roberto/Robin, Fabrizio, Federica Parigi, Mattia, Giorgio (assente).
OGGETTO          Lezione teorica sul Volume Profile (Value Area, POC, HVN/LVN,
                 forme P/b/B, Fair Value Gap) + operatività in diretta su ORO
                 (long contro piano) e DAX (pendenti long contro piano + short
                 di riserva). Nessun EA, nessun automatismo, nessuna prop citata.
```

**PARAMETRI CON VALORE** → §1.2, tabella P1-P19 (19 voci, tutte con citazione e riga).
🔴 Tutti *dichiarati da fonte esterna*, nessuno è un criterio nostro.

**MECCANISMI** → §1.3, M1-M18.

**REGOLE PROP CITATE** → 🔴 **NESSUNA. Zero.** Verificato con `grep` su
prop/FTMO/funded/challenge/drawdown/giornaliero/perdita/capitale: tutte **0**
occorrenze in 79 righe.

**NUMERI DI PERFORMANCE** → 🔴 **Uno solo, aneddotico**: *"il 90% delle volte vado a
profitto"* (r.27), `[dichiarato, NON verificato]`, senza campione né fonte esterna.
Nessun altro numero di performance (win rate generale, profitto mensile, "challenge
passate", conto in dollari/euro con saldo).

**BANDIERE ROSSE** → §1.4: **6 bandiere, ZERO rosse piene** (2 arancioni, 4 ambra).
Martingala 0 · griglia 0 · hedging 0 · recovery/mediazione 0 · no-stop 0 · trucchi
anti-prop 0.

**COSA C'ERA A SCHERMO E NON NEL PARLATO** → §3.

**COSA NE COPIAMO** → §4 (proposte, **nessuna azione**).

---

# 📸 PARTE 3 — COSA ERA A SCHERMO E NON NEL PARLATO (le domande per Claudio)

| # | cosa mostra | perché ci serve | dove nella live |
|---|---|---|---|
| **S1** | 🔴 **Il grafico dell'oro con il Volume Profile applicato** (forme P/b/B, HVA/LVA disegnate) | L'unico modo per verificare se le forme descritte a voce corrispondono davvero a una regola ripetibile, o sono un giudizio *post-hoc* sul grafico che si vede in quel momento | **r.19-27** |
| **S2** | 🔴 **I livelli DAX garbled**: "3,40, 3,40" (r.71), "25 e 3,25, 25 e 3,24" (r.77), "5,26" (r.77) | Senza lo screenshot questi numeri restano `[NON CHIARO]` e non entrano in nessuna tabella | r.71, r.77 |
| **S3** | 🟠 **Il pannello ordini con size e stop in euro** (1+2 contratti, poi 0,5/0,5/0,5, stop 400€/1000€) | Ci serve l'**unità reale** (lotti? contratti CFD? mini?) e il **saldo del conto** per rendere P8/P9 confrontabili con qualunque taglia nostra | r.27, r.35-49 |
| **S4** | 🟡 **L'istogramma dei volumi al momento della conferma di breakout** (M9) | Capire se è tick volume o un altro indicatore, come nel 18/09 (Luca confondeva volumi e un altro indicatore) | r.25 |
| **S5** | 🟡 **Le impostazioni finali del Volume Profile di Roby** (dopo la correzione "riferimento broker") | Per sapere se corrispondono davvero a quanto Giorgio ha fatto produrre alla "Camera del Consiglio" (r.31) o restano diverse | r.27, r.31 |
| **S6** | 🟡 **Il momento "a mezzogiorno, luna" per Bollinger 22** | `[NON CHIARO]`: potrebbe essere un orario (le 12 + fuso ignoto), un evento ("Londra"?), o altro. Nessuna conversione possibile senza il fuso | r.59 |

---

# ✅ PARTE 4 — COSA NE COPIAMO (proposte, ZERO azioni)

> 🔴 **Niente di quanto segue è stato fatto. Sono proposte da firmare, e i parametri
> di rischio restano di Claudio.**

| # | proposta | perché ora | costo | classe |
|---|---|---|---|---|
| **C1** | **Nessuna proposta di codice dal Volume Profile.** Confermare per iscritto la decisione già presa (`ABTG_DAX_M3.mq5` r.17-18): Volume Profile/POC restano **fuori dall'automazione**, coerenti fra due fonti diverse (Paolo e oggi Emiliano) | Evita di riaprire un tema già chiuso senza un numero nuovo | zero | 🟢 conferma, non lavoro |
| **C2** | **Nessuna proposta sull'ORB**: quarta ripetizione della stessa fonte, stesso numero (15 min), cancello di casa già chiuso il 18/09 con una misura propria (35-45 min, 8/8 OOS) | Coerenza con la regola "non si riapre un cancello senza una misura nuova" | zero | 🟢 conferma |
| **C3** | **Domanda a Claudio, non a Emiliano** (nessun contatto disponibile dal 18/09): se in futuro arrivasse un contro-esempio numerico sul Volume Profile (una soglia per le forme P/b/B), rivalutare C1 | — | zero | 🟢 |

### 📌 Nota di onestà finale

Questa live, a differenza del 18/09 e del 25/09, **non produce nessun candidato per un
file prova**: la parte teorica (Volume Profile) è già stata classificata "richiede
occhio umano" da una decisione precedente; la parte operativa (oro, DAX) è
discrezionale, con size e stop non riconducibili a nessuna taglia nostra; l'unico
numero ripetuto (ORB 15 min) è già stato misurato e battuto tre volte. 🟡 **È comunque
un referto utile**: conferma che il RETEST resta il principio più solido della serie
(quarta conferma indipendente nella forma, non nella fonte), documenta due bandiere
comportamentali coerenti con pattern già visti (stop per soldi, controtendenza), e
chiude formalmente il dubbio sul tema Volume Profile con una fonte in più a favore
della decisione già presa.

---

## 📎 FILE COLLEGATI

- 🗂️ **Fonte archiviata**: `docs/live_emiliano/trascrizioni/LIVE_EMILIANO_2026-09-28.txt`
- 🎙️ Live precedenti: `report/ANALISI_LIVE_EMILIANO_2026-09-18.md` (modello di formato,
  con l'aggiornamento del 10/04 e il rimando al 25/09) ·
  `backtest_pipeline/caccia_strategie/ANALISI_TRASCRIZIONI_2026-09-25.md`
- 🧩 `docs/COMANDO_GEMINI_AGENTI_EA_2026-09-28.md` — il parallelo con la "Camera del
  Consiglio" (§1.1-5)
- 🥇 `report/SEDIA_ORO_LONG_FTMO_BOZZA_2026-09-27.md` — il pacchetto oro `770402`
  citato in §1.1-2 e §1.6
- 🇩🇪 `report/audit_ea/SCHEDA_770101_DAX_APERTURA_2026-09-28.md` — la sedia DAX viva,
  stesso giorno del referto
- 🧾 `mql5/Experts/ABTG_DAX_M3.mq5` r.17-18 · `backtest_pipeline/REGISTRO_TEST.md`
  r.371-394 — la decisione pregressa su Volume Profile/VWAP/POC "non automatizzabile"

*Referto scritto il 28/09/2026. Nessuna azione eseguita: EA, preset, forward e conto
reale 10105439 non toccati.*
