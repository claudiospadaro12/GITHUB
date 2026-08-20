# 🗂️ CODA — cosa si fa appena Claudio e' davanti al PC

> # 🆕 20/08 mattina — **R90 E' PRONTO IN BOZZA** (la prova di regime dello stop largo ORB)
>
> Scelto da Claudio stamattina dopo R88: **"facciamo C e poi A"** — prima la
> **regola C** (la prova di regime batte la storia contigua), poi la finestra.
>
> **La domanda del round:** *lo stop largo tiene il drawdown basso in TUTTI i
> regimi, o solo nel toro 2024-2026?* (in R88 lo stop largo ha fatto **DD 4,78%
> contro 7,89% in IS e 3,84% contro 9,76% in OOS**, con **lo stesso identico
> numero di trade**: 71 e 119 in entrambe le celle — verificato nei CSV.)
>
> **Pronti e pushati:**
> - `backtest_pipeline/risultati_archivio/R90_CRITERI.md` — **BOZZA DA FIRMARE**,
>   scritta a numeri di R90 mai visti (quelli di R88 si', e sta scritto in testa).
> - i 4 file prova, **2 sole celle ciascuno** (sedia viva vs stop largo, tutto il
>   resto pinnato identico, **zero griglia**):
>   `prove/R90a_toro_U30USD.txt` · `R90b_orso_U30USD.txt` ·
>   `R90c_laterale_U30USD.txt` · `R90d_crollo_U30USD.txt`.
>
> **Le quattro finestre** (tre riusate dalla macchina R50/R56/R59, una nuova):
> 🐂 TORO **2021.01.01→2021.12.31** · 🐻 ORSO **2022.01.01→2022.10.31** ·
> ↔️ LATERALE **2015.01.01→2015.12.31** *(NUOVA: il 2019 di R50 sul Dow e' un
> toro +22%, non un laterale)* · 💥 CROLLO **2020.02.01→2020.04.30**
> *(riserva gia' decisa: CROLLO_ANNO 2020 intero se esce sotto 30 trade)*.
>
> **Le tre soglie che contano, per la firma rapida:**
> 1. 🥇 **C1 — il cancello centrale**: **DD(stop largo) ≤ DD(sedia viva) + 0,10
>    punti percentuali in TUTTE E QUATTRO le finestre**, non nella media. *Un
>    vantaggio che sparisce in un regime non e' un vantaggio.*
> 2. 🔴 **C2 — muro assoluto, a QUALUNQUE n**: **DD > 20,00%** in una qualunque
>    finestra = bocciatura secca. (+ **C3 allarme prop**: DD > 10,00% si scrive
>    in prima pagina e va nel `PIANO_PROP.md`.)
> 3. 🏅 **Il MERITO si giudica SOLO sulla finestra recente** (PF ≥ 1,40 e
>    PF(largo) ≥ PF(viva): **gia' verdi da R88**, 1,8385 vs 1,6742).
>    ⚖️ **Correzione dichiarata, valida da questo round e non retroattiva: il
>    cancello "PF IS ≥ 1,10" NON si applica** — giudicava il MERITO sulla
>    finestra VECCHIA, cioe' l'opposto della regola B. E' quello che ha bloccato
>    R88, e R88 resta non promosso lo stesso.
>
> ### ⛔ R90 NON SI LANCIA FINCHE' NON ARRIVANO DUE COSE
> **(a) la misura della profondita' tick di U30USD**, che e' gia' in coda qui
> sotto (§4, `scarica_storico.ps1 -Simboli "D30EUR,U30USD" -Timeframes "M1,H1"
> -Da 2015.01.01 -Auto`). Se — contro le attese — i tick andassero piu' indietro
> del 26/09/2024, **i criteri si riscrivono**.
> **(b) la FIRMA dei criteri** da parte di Claudio.
>
> 🔴 **E c'e' un terzo blocco, misurato e scomodo: i DATI NON CI SONO ANCORA.**
> BCM ha U30USD dal **26/09/2024** con stato **`COMPLETO`** = *il broker non ce
> l'ha*, ne' tick ne' barre. Gli 8 simboli `_EXT` sono **tutti forex e oro**.
> Quindi le quattro finestre girano su **`U30USD_EXT` da Dukascopy
> (`USA30IDXUSD`, dati dal 2012), barre M1 OHLC, Modello 1** — e la conseguenza
> e' scritta prima: **quei numeri valgono SOLO per il RISCHIO, mai per il
> merito**. Prerequisiti in fila (tutti nel §3.4 dei criteri):
> `dukascopy_m1.py --autotest` e `--validazione` → import con **shift +5** →
> **cancello zero** (diff ≤ 0,05%, copertura ≥ 80%) → **canarino di
> riproduzione** (sulla sovrapposizione 2024-2026 il feed OHLC deve ritrovare lo
> **stesso verso** del fatto tick di R88, altrimenti non si legge niente) →
> **P5: `prova_regime.ps1` ha le finestre scritte fisse e non contiene il 2015**,
> serve un parametro finestra o un driver dedicato.
>
> ⚠️ **La riga di lancio NON e' stata scritta**: la fa un altro agente **dopo**
> la misura dei tick. E R90 **propone**: anche se passa tutto, la messa in campo
> e' una decisione separata, e la via di casa e' la **sedia gemella in parallelo
> con magic nuovo** (proposto **770612**, da verificare libero), **mai** la
> sostituzione della 770611.

> # 🔴 PRIMISSIMA COSA DEL 20/08: LA NOTTE NON E' PARTITA
>
> La riga notturna si e' fermata **tre volte** al gate del pin, con tre pin
> diversi (9a6d6bc, 869ed00, df3af40), sempre con:
> `BRANCH NON CONGELATO: ABTG_ORB_Ottimizzato.mq5 su 'lavoro' HEAD e' DIVERSO dal pin`.
> Nessun round e' girato. Zip prodotti ma vuoti di CSV.
>
> **FATTO MISURATO dalla sessione (non ipotesi):** i due file NON sono diversi.
> Scaricati da qui con curl, `lavoro` HEAD e il pin danno **39.456 byte
> entrambi, identici byte a byte** (`cmp` senza differenze), ASCII puro, nessun
> BOM, nessun CRLF, `InpSLBufferPts` presente 5 volte in entrambi.
> Quindi **il gate da' un falso positivo**: il problema e' nel CONFRONTO o in
> cosa riceve la macchina di Claudio, non nel repo.
>
> Tentativo gia' fatto e FALLITO (19/08 23:37, commit df3af40): conversione
> esplicita del contenuto scaricato da byte[] a stringa + TrimStart del BOM.
> Il gate si e' fermato lo stesso. **Quindi l'ipotesi byte[] e' esclusa.**
>
> ### La diagnosi da fare PRIMA di toccare altro (10 secondi, PC di backtest)
> ```powershell
> & { $u='https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/mql5/Experts/ABTG_ORB_Ottimizzato.mq5'
>   $r=Invoke-WebRequest -Uri $u -UseBasicParsing
>   Write-Host ("tipo Content : " + $r.Content.GetType().FullName)
>   $t = if($r.Content -is [byte[]]){ [Text.Encoding]::UTF8.GetString($r.Content) } else { [string]$r.Content }
>   Write-Host ("lunghezza    : " + $t.Length)
>   Write-Host ("InpSLBufferPts presente: " + ($t -match 'InpSLBufferPts'))
>   Write-Host ("primi 40 char: " + $t.Substring(0,40)) }
> ```
> - Se **InpSLBufferPts = False** -> la macchina riceve una copia VECCHIA:
>   e' la cache dell'edge CDN. Cura: aggiungere `?nocache=<random>` all'URL
>   oppure header `Cache-Control: no-cache` nel gate, e ri-lanciare.
> - Se **True** ma il gate si ferma lo stesso -> il difetto e' nel confronto
>   dentro lo script (riga ~237-245 di
>   `backtest_pipeline/righe/RIGA_NOTTE_R88_R87_R89_R86.ps1`): stampare le
>   lunghezze delle due stringhe e il primo carattere che differisce, invece
>   di confrontare alla cieca.
>
> ⚠️ **NON disattivare il gate**: la sua ragione e' vera (il driver
> `walkforward_generico.ps1` scarica sempre da HEAD, checklist punto 24).
> Va fatto funzionare, non spento.
>
> ✅ Cio' che INVECE e' pronto e non va rifatto: i 23 file prova, i 3 criteri
> in bozza (R86/R87/R89), R88 firmato, i 6 EA in repo, il collaudo Guardian
> completo (fasi 0-1-2 + BLOCCO 4 verdi).


> # ✍️ DOMATTINA 20/08 — COSA FIRMARE, E IN CHE ORDINE
>
> ## 🔴 PRIMA LE FIRME. POI SI APRONO GLI ZIP SIGILLATI. Mai il contrario.
>
> Stanotte tre round hanno girato **senza criteri firmati**. I CSV sono stati
> prodotti ma stanno in una **cartella sigillata sul Desktop** con dentro un
> `LEGGIMI_PRIMA` che vieta di guardarli. Le bozze dei criteri sono state
> scritte **a numeri mai visti** (dichiarazione di cieco in testa a ogni file,
> con data e ora: 19/08 ore ~23:20 italiane = ~22:20 server BCM).
> **Regola di casa: i criteri si cambiano PRIMA dei numeri, non dopo.**
> Se un numero uscito suggerisse un criterio migliore, quel criterio vale
> **dal round dopo**.
>
> ### L'ORDINE, uno per uno
>
> | # | cosa | file da leggere | quando si apre lo zip |
> |---|---|---|---|
> | **1** | ☕ **Caffe'.** Poi si legge, non si sbircia. | — | — |
> | **2** | ✍️ **Firmare R86** (ABTG_CrossEma, ablazione EMA 9/21 · DAX H1 + ORO H1) | `backtest_pipeline/risultati_archivio/R86_CRITERI.md` | **dopo** la firma |
> | **3** | ✍️ **Firmare R87** (GoldenCross v2.00: impatto dei 3 fix + griglia) — **e' il piu' delicato: tocca 4 SEDIE VIVE** | `backtest_pipeline/risultati_archivio/R87_CRITERI.md` | **dopo** la firma |
> | **4** | ✍️ **Firmare R89** (LiquiditySweep, GBPUSD M15 · sweep+reclaim su livello H4) | `backtest_pipeline/risultati_archivio/R89_CRITERI.md` | **dopo** la firma |
> | **5** | 📂 **Solo adesso**: si apre la cartella sigillata e si leggono i CSV, **nell'ordine dei criteri** (canarino → rischio → merito). | i tre file qui sopra, riletti | ✅ |
>
> ⚠️ **R88 e' gia' firmato** ("FIRMO R88", 19/08 ~18:05):
> `risultati_archivio/R88_CRITERI.md`. Non va rifirmato.
>
> ### Le tre soglie principali di ogni round, per la firma rapida
>
> **R86 — ablazione CrossEma** (i quattro cancelli sono quelli gia' congelati in
> R84, non sono nuovi):
> 1. 🐤 **Canarino**: se l'IS della cella NUDA esce **sotto 150 operazioni** →
>    **merito SOSPESO**, si legge il rischio. Per ogni cella filtrata, sotto
>    **30 operazioni totali** → "non misurabile", mai "peggiora".
> 2. 🟢 **"la gamba AGGIUNGE"** solo con **tutti e quattro**: n≥30 · segno
>    coerente fra IS e OOS · **PF campione intero ≥ PF(nuda) + 0,10** · **DD non
>    peggiore di 1,0 punto percentuale**.
> 3. 🔴 **Muro del rischio, a qualunque n**: **DD > 15,0%** o **peggior giornata
>    peggio di −7,5%** → bocciata per rischio, qualunque sia il PF. *(E' il muro
>    prop 10%/5% di METRO_PROP scalato dal rischio pinnato 1% alla taglia di
>    campo 0,65%: 10 ÷ 1,538 = 15,4 → 15,0. Etichettato [INFERITO].)*
>
> **R87 — GoldenCross v2.00** (⚠️ 4 sedie vive: XAUUSD 970301, USDCHF 770331,
> USDCAD 770332, NZDUSD 770333):
> 1. 🔬 **Sovrapposizione dei trade V1 vs v2.00** (chiave: ora d'ingresso +
>    direzione): **≥90%** = cambiamento cosmetico, contratto invariato · **<70%
>    o Δn>25%** = **"e' un'altra sedia"** → contratto da riscrivere e storia
>    forward azzerata per il criterio del 18/08.
> 2. ⚖️ **"i fix hanno MIGLIORATO"** = PF(v2.00) ≥ PF(V1) **+0,10 in entrambe le
>    finestre** e DD non peggiore di 1,0 pp. **"PEGGIORATO"** = PF ≤ PF(V1)
>    **−0,10** in almeno una finestra, o DD peggiore di >1,0 pp.
>    🔴 **In OGNI caso i fix RESTANO: un bug non si tiene perche' era
>    fortunato.** Se peggiora, la reazione ammessa e' **spegnere la sedia**, MAI
>    rimettere la v1.00 (§5.2 ③ del file: leggerlo, e' il punto delicato).
> 3. 🕸️ **Griglia R87b**: **selezione SOSPESA** (IS stimato **15-40** sul forex
>    H4, 40-120 sull'oro: tutti sotto 150). Si risponde solo *"esiste un
>    altopiano?"* = cella con **TUTTE** le vicine dentro **20% di PF e 1,5 pp di
>    DD** e **PF OOS ≥ 1,10**. **Nessun preset esce da R87.**
>
> **R89 — LiquiditySweep Londra** (candidato nuovo, mai girato):
> 1. 🐤 **Canarino di frequenza, si legge PRIMA del conto economico** (riga
>    `[LIQSWEEP][CONTEGGIO]`): **n trade IS < 30** o **livelli creati IS < 30**
>    → **round NON MISURABILE**, e la conclusione e' che `SwingBars=21` su H4 e'
>    troppo raro — **non** che manca l'edge. Fra 30 e 150 → merito sospeso.
> 2. 🧭 **Cella A (nuda) PASSA** solo con tutte e cinque: **PF OOS ≥ 1,20**
>    *(1,10 di casa +0,10 perche' riaprire un capitolo chiuso 48/48 costa piu'
>    che confermarlo)* · **PF IS > 1,00** con segno coerente · **DD OOS ≤ 15,0%**
>    · **peggior giornata ≥ −7,5%** · **n totale ≥ 60**.
> 3. 🕰️ **Cella B (finestra Londra)**: si tiene **solo se migliora l'INSIEME**
>    delle 9 passate — **mediana PF OOS ≥ PF(A) + 0,10** *e* **almeno 6 su 9**
>    sopra A *e* un altopiano vero. **Una sola ora che sporge = "l'orario non e'
>    il motore".** E **B non si legge se A e' bocciata sul RISCHIO o se il
>    canarino e' sotto 30.**
>
> ### 📌 Le due DECISIONI che servono a Claudio (non solo firme)
>
> - **R87, il "prima" da misurare** — proposta dell'architetto: usare
>   `mql5/Experts/ABTG_GoldenCross_V1.mq5` (v1.00 gia' congelata sul branch) per
>   **tutti e quattro** i simboli. **Verificato stanotte con `git show 8ad73f2`
>   + diff**: la `_Ottimizzato` v1.00 era il motore base v1.00 **meno** due gambe
>   opzionali (`InpUseBBExpand`, `InpHAAutoCount`) — quindi con quei due input
>   pinnati a 0 la V1 base copre anche l'oro. Servono **4 file prova gemelli**
>   `R87a_impatto_fix_*_V1.txt` (dettaglio in §3.2 di `R87_CRITERI.md`, magic
>   vergini proposti 7787{5,6,7,8}0/1). **Senza il "prima", R87a e' solo la
>   fotografia del DOPO e la frase "i fix hanno migliorato/peggiorato NON si
>   puo' scrivere.**
> - **PASSO 0 sui TICK, mai misurato per D30EUR, XAUUSD e i cambi H4.** Se i
>   tick partono dopo il `@DAQUANDO` dei file prova, **quei numeri non si
>   leggono** e i round si rilanciano (difetto n.18 della checklist). L'unica
>   riga `TICK` mai prodotta nel repo e' quella di GBPUSD (2024.07.05).
>
> ### ⚠️ Un controllo che vale per tutti e tre
> `walkforward_generico.ps1` ha `$EABranch="lavoro"` **scritto fisso**: gira
> sempre l'EA sulla **punta** del branch, non quello del `-Rif`. **Va dichiarato
> nel referto quale commit era sulla punta all'ora della corsa.** (Il BLOCCO 4
> del collaudo Guardian risulta chiuso VERDE la sera del 19/08, commit
> `8907a8f` — da confrontare con l'orario di raccolta dei CSV.)

> ## 🔬 ANOMALIA DA AUTOPSIA (19/08 pomeriggio): i gemelli ORB divergono nella GESTIONE
> Trade del 19/08 ore 14:56 server, U30USD, stesso ingresso AL SECONDO
> (53600.5, SL 53506.5) su piccolo (0.6 lot, 1%) e 100k (3.7 lot, 0.3%):
> - **100k**: trailing EMA9 ha alzato lo stop a 53563.5 -> colpito 15:15,
>   chiuso -117,37 (-0,39R).
> - **piccolo**: stop MAI mosso (log Esperti muto con Verbose=true),
>   posizione sopravvissuta al ritracciamento.
> Input identici (verificati da screenshot). Ipotesi principale: **.ex5 di
> BUILD diverse** fra le due istanze — probabile che il piccolo sia
> pre-correzione "trailing/BE agganciato al parziale" (lezione PTE 04/08)
> e con TP1Pct=0 il trailing non parta mai.
> DA FARE: stringa (verificata) che confronta data/size/hash di
> ABTG_ORB_Ottimizzato.ex5 nelle due cartelle dati; il BLOCCO 4 rimette
> comunque il 100k su build certificata di oggi; il piccolo si allinea in
> FASE 5. Conteggio famiglia ORB 770611 aggiornato: 3 trade chiusi, 0/3
> (criterio congelato: revisione a 15).

> **Nota tecnica dal verificatore (19/08, non bloccante):**
> `censimento_rischio.ps1` riga 43 legge i `.chr` con `Get-Content -Raw`
> SENZA FileShare e con `$ErrorActionPreference="Stop"` — con MT5 aperto un
> file bloccato fa morire TUTTO il censimento. Da portare alla lettura
> condivisa del gemello `elenco_ea_attaccati.ps1` (righe 77-102: FileShare
> ReadWrite + BOM/conteggio zeri). Modifica da fare a freddo e da far
> verificare, non in mezzo a un'operazione.

> ## ⚠️ AGGIORNAMENTO 19/08 (verificatore, durante il recupero template): gli 11 preset `recupero2/` NON nominano `InpUsaGuardian`
>
> Trovato dal verificatore col punto 25 della checklist (scritto ieri sera,
> ripagato stamattina): `InpUsaGuardian` e' nato OGGI (commit `5fc0bc3`,
> migrazione Guardian pezzo 6), i preset `recupero2/` vengono dai `.chr`
> delle 10:24 — cioe' da PRIMA che l'input esistesse. Un preset che non
> nomina un input non lo riporta al default: lascia l'ultimo valore usato.
>
> - **Oggi rischio pratico nullo**: i `.ex5` sul VPS piccolo sono
>   pre-migrazione (FASE 0 del collaudo non ancora eseguita), l'input non
>   esiste ancora sui grafici.
> - **Da fare DURANTE il collaudo Guardian (insieme alla FASE 2/BLOCCO 4)**:
>   rigenerare gli 11 preset `recupero2/` aggiungendo `InpUsaGuardian=true`
>   (valore firmato 18/08) e, per l'ORB, `InpSlippagePts=0.0`. Il preset
>   dell'ORB 770611 e' gia' stato installato con la riscrittura in riga
>   (blocco corretto dal verificatore, 19/08).
> - **Tre input richiedono una DECISIONE, non basta il default**:
>   `InpAllowReverse` (DAX Apertura 770101), `InpPendingAtr` +
>   `InpSLBufferAtr` (SuperWave DOW H1 770511) — anche questi assenti dai
>   `.chr` perche' piu' giovani dei grafici.


> ⚠️ **NOTA DI COORDINAMENTO FRA SESSIONI (19/08 mattina):** R81 e' stato
> **GIA' ESEGUITO il 18/08 pomeriggio** dalla sessione della flotta agenti:
> esiti in `risultati_archivio/REFERTO_ROUND81_USCITE.md` (variante C "solo
> BE poi correre" batte la sedia viva in entrambe le finestre, ~10-14
> posizioni: PROPONE, non promuove — pista M13, R81-bis su dati lunghi
> quando i dati _EXT passeranno il cancello). **NON rilanciarlo.** Sempre
> il 18/08 sera: R84 (ablazione filtri Nasdaq, 9/9 OOS negative) e R83
> (duello ingressi: retest incoronato sul DAX) — referti
> `REFERTO_ROUND84_ABLAZIONE.md` / `REFERTO_ROUND83_INGRESSI.md`.

> ## 🎌 AGGIORNAMENTO 19/08 mattina — dove `GapContinuation` calcola lo stop (letto nel sorgente)
>
> Primo trade in assoluto della sedia **774101** (deploy 16/08): `GAPCONT S`
> su 225JPY, **−51,90 in 29 minuti**, stop preso. Claudio ha chiesto di
> guardare il sorgente. **Lo stop NON e' un ATR.**
>
> ```cpp
> // ABTG_GapContinuation.mq5:1011 (ramo SELL)
> double stop = MathMax(g_range_high + buffer, tick.ask + broker_stop_distance);
> double buffer = InpStopBufferPoints * point;   // InpStopBufferPoints = 0.0
> // g_range_high = massimo delle barre M1 dei primi InpOpeningRangeMinutes = 10 min (:571-577)
> ```
>
> ### Tre conseguenze, in ordine di peso
> 1. 🔴 **Buffer ZERO.** Lo stop e' appoggiato **esattamente** sul massimo dei
>    primi 10 minuti. E su 225JPY BCM lo **spread e' ~80 punti** (scritto nel
>    codice stesso, riga 215): basta che il bid sfiori quel massimo perche'
>    l'ask lo superi. **Unico difetto meccanico della lista.**
> 2. ⚖️ **L'R non e' scelto: e' quanto sono stati larghi 10 minuti.** Nessun
>    ATR, nessuna normalizzazione. Ieri R = **479 punti** e **2,00 lotti**, la
>    posizione piu' grossa della flotta. Il rischio in % e' rispettato
>    (−51,90 ≈ 1%), ma la distanza dello stop e' un sottoprodotto, non una scelta.
> 3. ⏳ **Lo stop invecchia, l'ingresso no.** `InpMaxEntryMinutesFromOpen = 90`
>    ma lo stop resta ancorato ai primi 10. Ieri l'ingresso e' arrivato a
>    +15 min → **non e' il colpevole di stanotte**, ma lo diventa sui tardivi.
>
> ### ⚠️ E il FUSO, trovato cercando (vale piu' dello stop)
> `InpSessionTimeMode = SESSION_JST_DARWINEX_AUTO` **di default**. In AUTO:
> `9*60 - 9*60 + offset*60` con offset **3** ad agosto → apertura sessione
> alle **03:00 ora server**. Ma su BCM (server = ora italiana − 1) Tokyo apre
> alle **01:00**: in AUTO l'EA aprirebbe la finestra con **DUE ORE di ritardo**.
> 🟢 Ieri ha aperto giusto (ingresso 01:15:24 = +15 min dall'apertura vera),
> quindi sul grafico vivo **deve** essere `SESSION_MANUAL_SERVER` con
> `InpSessionOpenHour = 1`. **[INFERITO] dall'orario, NON letto dal preset.**
> La verifica e' una riga: `config_in_uso.ps1` sul VPS.
>
> ### 🧪 Il round che ne esce (zero righe di codice)
> **Sweep di `InpStopBufferPoints`** su 225JPY: l'input esiste gia'. Domanda
> secca: **un cuscinetto sopra il massimo dell'opening range paga o no?**
> 🛑 **Niente si tocca in forward: e' UN trade su 15.**

> ## 🧪 18/08 — ~~**R81 "PROCESSO ALLE USCITE" E' PRONTO DA LANCIARE**~~ ✅ **ESEGUITO 18/08 (vedi la nota di coordinamento in testa)**
>
> Nato dal trade vero di oggi (`MAXMIN DAX SHORT` **+324,48** sul 100k: il
> trailing ha incassato prima di un rimbalzo che avrebbe riportato il prezzo
> sopra l'ingresso). **Sei varianti di USCITA a INGRESSI IDENTICI** sulla sedia
> 770411 — A viva · B correre puro · C solo breakeven · D trail 3,5 ·
> E trail 1,0 · F TP secco 2R. Tick reali, 100k, 24 passate, stima 1-3 ore.
>
> - criteri congelati PRIMA dei numeri: `backtest_pipeline/prove/R81_USCITE_CRITERI.md`
> - riga di lancio (giro a vuoto + corsa vera), file attesi e checklist eseguita:
>   `backtest_pipeline/risultati_archivio/REFERTO_R81_PREPARAZIONE.md` §9
> - driver: `backtest_pipeline/lancia_r81.ps1` · commit pinnato **`f2f9030`**
>
> 🔒 **Nessuna modifica all'EA e nessuna modifica al forward.** I magic
> 7781xx sono nuovi. Se una variante vince, fa la trafila della candidata.
> 🚨 Limite dichiarato: **~20 chiusure per finestra** (le posizioni sono circa
> la meta') → **il round PROPONE, non promuove**. E la lettura per regime su
> D30EUR **non esiste**: lo storico BCM parte dal 2024.09.26, le quattro
> finestre di casa sono tutte precedenti.

> ## 🧨 AGGIORNAMENTO 17/08 — il difetto "pip" e' una FAMIGLIA, non un caso
>
> Trovato dal vivo sulle due gambe SuperWave aperte oggi sul Dow:
> `SUPERWAVE DOW H1 S 1/3` @ **53.648,50** e `S 2/3` @ **53.648,30**.
> **Venti centesimi**, non venti punti. `PipSize()` torna `_Point` quando
> `digits!=3,5`, quindi su U30USD (digits=2) `InpPendingPips=20` vale
> **0,20 punti = zero**: l'ingresso frazionato NON ESISTE su questo simbolo,
> ne' in forward ne' in nessun backtest fatto finora (R3 compreso).
> Stessa famiglia di R69/R74 (`InpSLbufferPips` della PTE sul Dow).
>
> ### ✅ FATTO OGGI — solo SuperWave
> `ABTG_SuperWave.mq5` + `_DOW_H1_Ottimizzato` + `_DAX_H4_Ottimizzato`:
> due manopole nuove, **`InpPendingAtr`** e **`InpSLBufferAtr`**.
> **Default 0 = si torna esattamente al calcolo in pip di prima.** Nessun EA
> in forward cambia comportamento finche' non le si mette a mano.
>
> Prova pronta: **`prove/R75_SuperWave_DOW_PENDING_ATR.txt`** — 7 celle,
> tick reali, e la **cella 0 e' il controllo** che riproduce il
> comportamento di oggi. Criteri congelati dentro il file.
>
> 🤝 **La PTE l'ha gia' fatta l'altra sessione** (`ABTG_PTE_Ottimizzato`,
> magic 771331, `InpSLbufferMode`, commit `dc16e7a` + R74). Il mio doppione
> e' stato **ritirato**: `ABTG_PTE.mq5` non e' toccato.
>
> ### 🔎 I GEMELLI ANCORA DA SISTEMARE (cercati, non ancora toccati)
> Tutti su indici a 2 decimali, quindi tutti con il buffer INERTE:
> `ABTG_SupRev_CAC_H4_Ottimizzato` · `_DAX_H1_` · `_DAX_H4_` · `_DOW_H1_` ·
> `_DOW_H4_` · `_NAS_H1_` (sei file, `InpSLBufferPips=3` -> 0,03 punti).
> Su forex il difetto NON c'e' (`ABTG_HARSI`, `ABTG_Londra_ORB`,
> `ABTG_Nightly`, `ABTG_PostNews`, `ABTG_FiboH4_Multi`, `EasyTrend_EURUSD`).
> **Non sono stati patchati oggi apposta**: sei EA = sei round, e la regola
> di casa e' una domanda per volta.

> ## ⚖️ AGGIORNAMENTO 16/08 NOTTE — R70 · R71, l'emendamento e' stato messo alla prova
>
> Claudio: _"dal 2010 sono tantissimi anni, stiamo scartando opportunita'"_.
> L'emendamento e' stato **congelato in `CLAUDE.md`** e poi **verificato**.
>
> **R70** (IS 2019-2022) e **R71** (IS 2016-2021), stessa griglia di R68/R69
> carattere per carattere, cambia solo la finestra. 8 CSV su 8, cancelli ok.
>
> ### Cosa e' uscito
> - ❌ **L'epoca NON era il colpevole.** L'IS e' **0/28 su ENTRAMBI i simboli**
>   anche nel 2016-2021 e nel 2019-2022, e l'OOS 2021-2026 e' **28/28 e 27/28**.
>   🎯 **NON E' IL CALENDARIO, E' IL 2021** (tassi zero+covid prima, dollaro
>   forte e tassi dopo). **La regola C e' dimostrata.**
> - ⚖️ **"La finestra recente sceglie meglio" = NON DIMOSTRATO**: USDJPY premia
>   la vecchia (92,4% vs 83,5%), GBPUSD la nuova (95,1% vs 57,7%). Un simbolo
>   per parte. 👉 **Il punto A e' stato RISCRITTO e ricongelato.**
> - ✍️ **RITRATTATO R70 §2**: i rapporti di cattura usavano il **picco** dell'IS,
>   che il criterio 1 vieta. Con la regola giusta il vantaggio si ribalta.
>   Nota in testa a `REFERTO_ROUND70_FINESTRA.md`.
> - 📉 **Buffer: 5ª e 6ª conferma sul DD** (GBPUSD 11,07 → 3,42%). Il profitto
>   invece si sposta ogni volta: **rischio stabile, rendimento instabile**.
> - 🪑 **`buffer 5` (config viva) finita male in 6 misure su 6.**
> - 🗃️ CSV archiviati in `risultati_archivio/csv_R69`, `csv_R70`, `csv_R71`
>   (quelli di R68 mancavano: errore corretto da R69 in poi).
>
> ### Prossimi passi, in ordine
> 1. ⏱️ **TICK REALI su `buf 25 / TP 3,0`** — centro dell'altopiano su
>    **entrambi** i simboli, sopravvive a tutte le finestre. **E' qui che
>    inizia il verdetto: tutto quanto sopra e' OHLC e PROPONE.**
> 2. 🔧 **Buffer in multipli di ATR** (`sl = entry − atr*(1+InpSLbufferATR)`)
>    su copia **`_Ottimizzato`** — R69 §7. Rende il parametro portabile e rende
>    il Dow misurabile (li' 30 pip valgono ~0,03 ATR).
> 3. 🔬 Sonda da 2 minuti: `SYMBOL_DIGITS` + `PipSize()` + `iATR(14)` sui tre
>    simboli → chiude l'unico **[INFERITO]** di R69.
> 4. 🪑 **Solo dopo**, e solo con la parola di Claudio, `PTE` in forward.
>
> 🔴 **NIENTE E' STATO TOCCATO IN FORWARD** in nessuno dei round R67-R71.

> ## 🧬 AGGIORNAMENTO 16/08 SERA TARDI — R67 · R68 · R69, la PTE ha un parametro tarato male
>
> **R67** ha trovato che nella PTE il target e' in ATR puro e lo stop e'
> ATR+buffer: **`InpSLbufferPips` e' una manopola sul TARGET IN R travestita
> da stop** (`R = ATR*TP2mult/(ATR+buffer)`). L'ipotesi dei "rifiuti" e'
> stata **verificata nel sorgente e ritirata** (con `SLfromDoji=0` quel
> `return` non scatta mai).
>
> **R68** (GBPUSD, 28 celle, 16 anni): a **R costante** il buffer fa **5 volte
> il profitto e META' del drawdown**. DD OOS da **17,9%** (buffer 0) a
> **6,7%** (buffer 30). **La config viva e' buffer 5: la seconda peggiore.**
>
> **R69** (USDJPY + U30USD, stessa griglia): 🎯 **la tesi regge — e' una
> proprieta' del motore.**
> - **USDJPY**: DD da **15,5% a 8,1%**, e a R costante il buffer **ribalta il
>   segno** (−2.584 → +6.796). 🔴 **La config viva (buf 5, magic 771323) e'
>   una delle TRE celle OOS-negative su 28** (−1.738, PF 0,976). E l'**IS e'
>   0/28**: con l'imbuto fatto bene, PTE USDJPY non sarebbe mai entrato in
>   vivaio (**ribaltamento n. 31**).
> - **U30USD**: asse **MORTO** — 46 trade in tutte e 28 le celle, DD identico
>   allo 0,007. Motivo trovato nel codice (`ABTG_PTE.mq5:146-150`): il buffer
>   e' in **pip**, l'ATR in **unita' dello strumento**. Sul Dow 30 pip valgono
>   **~0,03 ATR**. **Non e' un controesempio: e' una misura nulla.**
>
> 🔴 **NIENTE E' STATO TOCCATO IN FORWARD** (criterio 3 congelato prima dei numeri).
>
> ### Cosa fare da qui, in ordine
> 1. 🔧 **Buffer in multipli di ATR** (`sl = entry − atr*(1+InpSLbufferATR)`)
>    su una copia **`_Ottimizzato`**, mai sulla sedia viva. Rende il parametro
>    portabile su tutta la famiglia e rende il Dow misurabile.
> 2. 🔬 **Sonda da 2 minuti**: stampare `SYMBOL_DIGITS`, `PipSize()` e
>    `iATR(14)` su U30USD/USDJPY/GBPUSD → chiude l'unico **[INFERITO]** di R69.
> 3. ⏱️ **Tick reali** sulla cella che sopravvive ai due cambi (**buf 20-25**,
>    sta nell'altopiano di entrambi). **Prima di allora non c'e' verdetto.**
> 4. 🪑 **Solo dopo**: la domanda su `PTE USDJPY` in forward — decisione di Claudio.
>
> ✅ ~~**Da fare comunque**: verificare che sul PC non ci siano EA attaccati ai
> grafici del conto vivo~~ — **CHIUSO il 17/08 da Claudio: "Algo trading e'
> staccato su MT5 desktop".** Anche se un EA fosse rimasto su un grafico, con
> l'AutoTrading spento non puo' mandare ordini. Regola di
> `DAX_14-08_DUE_MOTORI.md` rispettata.

> ## 🌙 CHIUSURA DELLA SERATA 16/08 — sei round e una sedia nuova
>
> **R61 · R62** GAPFILL Nasdaq (cella confermata, l'asse `pts` e' ridondante)
> **R63** `TurnaroundTuesday` ⚰️ **MORTO** (0/24 OOS su 11.928 trade) — famiglia chiusa
> **R64** `CanaleLento` 🟡 non scegliibile (la cella del metodo perde −812)
> **R65 · R66** `GapContinuation` ✅ **PASSA**: PF **1,398** a tick reali,
> gemello sciolto, bordo della griglia chiuso. Unico criterio non passato:
> il **lato short** (−2.182).
>
> 🆕 **DEPLOY**: `ABTG_GapContinuation` su **225JPY M1, magic 774101**, conto
> piccolo, VPS, rischio 1%. E' la **prima sedia arrivata dalla caccia
> esterna**. Scheda completa in `FLOTTA_ATTIVA.md`.
> ⏳ Attesa **~3,7 operazioni/mese** → 15 trade a **dicembre**, 30 a **aprile**.
>
> ### 🎯 IL PROSSIMO PASSO E' LA PTE, ed e' pronto da lanciare
> `prove/PTE_ACCOPPIAMENTO_TP_SL.txt` — **32 celle, ZERO righe di codice**:
> le tre leve esistono gia' come input. Testa il difetto trovato dalla
> caccia L: in `ABTG_PTE.mq5` **stop e target sono calcolati
> indipendentemente** (`:329-330` vs `:338`), quindi il rapporto R regge
> **per caso, non per costruzione**.
> 🟢 **E adesso si puo' fare su 16 ANNI**: lo storico GBPUSD H1 e' stato
> misurato stasera — **locale dal 2010.07.06**, server dal **1993.05.11**.
> Si lancia con `-DaQuando 2010.07.06`.
>
> ### Cosa resta in fila dopo
> 1. **Pivot Supertrend** (9/10, dossier I) — l'EA va scritto, 3-4h
> 2. **Controllo ATR sullo STREV** — mezz'ora, sblocca tre candidati
> 3. **RETEST col filtro volumi** sul Nasdaq (+274,35 · PF 1,109 · DD 3,68%)
> 4. **Decisione sul lato short** di `GapContinuation` — a mente fredda
> 5. **Bug OPTFRAME**: "Perdite Consecutive Max" non e' un conteggio (39 EA)


> ## 🌙 PIANO DELLA NOTTE 16→17/08 — deciso da Claudio
>
> Claudio voleva mettere i tre EA nuovi sul VPS per l'apertura di stanotte.
> **Ha scelto invece di misurarli prima**, e la ragione sta nei numeri: i tre
> EA hanno **ZERO backtest, ZERO referti**, e due non hanno nemmeno
> `@DAQUANDO`. In piu' **non c'e' fretta**: GAPFILL fa ~2 trade al mese,
> TurnaroundTuesday 1 a settimana, CanaleLento tiene le posizioni per
> settimane. Perdere un'apertura non costa niente; accendere codice mai
> misurato costa il conto (il 14/08, −104,60 per UN EA non previsto).
>
> **Il VPS resta com'e'. Stanotte lavora il PC.**
>
> | passo | dove | cosa |
> |---|---|---|
> | 1 | MetaEditor | **compilare i 3 EA** (F7). Se uno da' errore, si manda il messaggio esatto |
> | 2 | MT5 aperto | misurare lo storico di **GBPUSD H1** e **XAUUSD D1** |
> | 3 | — | **chiudere MT5** |
> | 4 | PowerShell | i **tre screening in OHLC**, uno dopo l'altro (una macchina, un lavoro) |
>
> **Le tre griglie:** `CanaleLento` XAUUSD D1 **20 celle** · `TurnaroundTuesday`
> GBPUSD H1 **24 celle** · `GapContinuation` 225JPY M1 **54 celle**.
> Tutte e tre **Modello 1 (OHLC)**: e' screening, e i file prova lo dicono
> tutti e tre. 🔴 **Il verdetto sara' solo a tick reali** (R57: cambiando
> solo il modello il segno dell'orso si e' ribaltato).
>
> ⚠️ `@DAQUANDO` di GBPUSD e XAUUSD **non si inventa**: esce dal passo 2 e si
> passa con `-DaQuando`. Domattina va scritto nei due file prova.

> ## ✅ AGGIORNAMENTO 16/08 ore 14:30 — I PRIMI DUE PUNTI SONO FATTI
>
> **1. Screening `ABTG_MeanRevert`: FATTO e BOCCIATO.** 12 celle su 12 in
> perdita su 11 anni e mezzo, PF massimo 0,986, DD fino al 37%. Famiglia
> chiusa, prova di regime NON lanciata (sarebbe una macchina su un cadavere).
> Referto: `risultati_archivio/REFERTO_ROUND60_MEANREVERT.md`.
>
> **2. Sblocco dei domini: FATTO E VERIFICATO.** `mql5.com` risponde
> **HTTP 200** ("Free download of trading robots... MQL5 Code Base") e
> `arxiv.org` **HTTP 200** (API `export.arxiv.org` con risultati reali).
> 🔓 **Il Code Base e la letteratura adesso si aprono da soli.**
>
> ### ⚠️ TRAPPOLA GIA' PAGATA: LA SESSIONE NUOVA PARTE SUL BRANCH SBAGLIATO
> La prima sessione lanciata dopo lo sblocco e' partita su
> `claude/verifica-siti-caccia-strategie-v5pzqv`, che punta a un commit di
> **due mesi fa** — e quindi non trovava ne' questo file, ne' l'agente
> `cacciatore-strategie`, ne' il `SETACCIO_MANUALE.md`. **Non e' un bug: e'
> il branch.** Prima cosa da fare in ogni sessione nuova:
> ```
> git fetch origin lavoro && git checkout lavoro && git log --oneline -3
> ```
>
> ### ✅ AGGIORNAMENTO 16/08 ore 15:15 — PUNTO 3 FATTO, E LE TRE CACCE ANCHE
>
> **Punto 3 — `Nikkei225_Gap_Continuation`: sorgente ripescato e lavorato.**
> Trovato sul Code Base (`mql5.com/en/code/75301`, v1.50, 43.393 byte) e letto
> per intero. Gli input erano **31, non 39** (8 erano `input group`); fuso
> risolto in ora server BCM (**01:00-07:30**, col calcolo e col buco DST
> dichiarato); asimmetria 1,25% spenta e messa in misura come assi separati.
> 🔴 **Non lanciabile: nel sorgente manca `OnTester`** — serve
> `mql5-ea-developer`. Poi la misura di `@DAQUANDO` sullo storico **M1** di
> `225JPY` (non si eredita da R36/R37: quelli erano H1).
> Dossier: `caccia_strategie/CACCIA_2026-08-16_C_NIKKEI_GAP.md`.
>
> **Tre cacce sui tre buchi, chiuse.** Mandato nuovo di Claudio applicato
> (§5.F "motore grezzo da rifinire" + §7-bis "cancello prop", scritti nel
> file dell'agente):
>
> | caccia | buco | promosso |
> |---|---|---|
> | **D** | laterale | 🥇 `001 - Turnaround Tuesday` (Code Base 73674) **9/10** |
> | **E** | crollo | 🥇 `BreakoutStrategy` (Code Base 49272) **9/10** |
> | **F** | short simmetrico | 🥇 **lo stesso `001 - Turnaround Tuesday`, 10/10** |
>
> 🎯 **D e F sono arrivate allo stesso EA partendo da due buchi diversi, senza
> parlarsi.** Un solo file prova, `prove/ABTG_TurnaroundTuesday.txt`.
>
> 🔬 **La scoperta che pesa piu' dei tre candidati** e' nel dossier E:
> **arXiv 2607.01550** (Kurth, Eisler, Rej, Bouchaud — CFM, 02/07/2026, ~100
> futures, 1995-2025) misura che il trend **veloce** e' passato da Sharpe
> **0,84 a 0,12** dopo il 2009, ed e' svanito **proprio su indici e valute**
> mentre regge su materie prime e tassi. **Il nostro universo e' il
> sottoinsieme dove e' morto, e le ~210 celle ORB sono la versione piu'
> veloce di quel segnale.** Non ribalta nessun verdetto: dice dove cercare.
>
> ⚠️ **Nessuno dei tre e' lanciabile oggi**: a tutti manca `OnTester`, e i
> due `@DAQUANDO` non misurati restano vuoti apposta.
>
> ### 🎯 QUINDI IL PROSSIMO PASSO E' IL 3, non l'1 e non il 2
> E prima di cacciare: **leggere `caccia_strategie/SETACCIO_MANUALE.md`**
> (22 file gia' setacciati, non si ricontrollano) e usare **l'agente
> `cacciatore-strategie`**, non dei general-purpose.
>
> ⚠️ **I tre buchi NON si deducono: sono misurati.** Stanno in
> `report/ROBUSTEZZA.md` e nei referti R50/R59 —
> **LATERALE** (`LARRY_GBPUSD` −6.445 nel 2019) ·
> **CROLLO** (`BB` +502 dove Larry fa −708) ·
> **SHORT simmetrico** (14 celle vive quasi tutte long-only).


_Scritta il 16/08/2026 su sua richiesta: **"metti tutto in coda, quando arrivo
a casa davanti al pc facciamo tutto"**. Ordine pensato: prima le cose che
sbloccano le altre._

> ⚙️ **Regole che non cambiano**: MT5 CHIUSO sul PC di backtest · OHLC solo
> screening, verdetti solo a tick reali · **nessun parametro in forward si
> tocca** · commit e push a ogni passo.

---

## 1. ✅ ~~SCREENING DI `ABTG_MeanRevert`~~ — **FATTO, BOCCIATO (R60)**

**Stato:** EA **scritto e COMPILATO** (44.394 byte, verificato il 16/08),
file prova con `@DAQUANDO 2015.01.01` misurato. **Manca solo lanciarlo.**

**Riga 1 — giro a vuoto** (un minuto, non lancia niente). E' il **punto 5
della checklist**, nato dall'errore di R58.

```
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/18925cb9cc51bad7d493052737cb416a6f4b29fd/backtest_pipeline/prove/ABTG_MeanRevert.txt" -OutFile "$env:USERPROFILE\ABTG_MeanRevert.txt"; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/18925cb9cc51bad7d493052737cb416a6f4b29fd/backtest_pipeline/walkforward_generico.ps1" -OutFile "$env:USERPROFILE\walkforward_generico.ps1"; powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\walkforward_generico.ps1" -Expert ABTG_MeanRevert -Prova "$env:USERPROFILE\ABTG_MeanRevert.txt" -Modello 1 -Deposito 100000 -Etichetta mr1 -SoloControllo
```

✅ **Deve stampare `spazzolati: 1` e `InpLookback 6 celle`.**
🛑 Qualunque altra cosa: **fermarsi e mandare lo screenshot.**

**Riga 2 — lo screening vero** (solo se la 1 dice `6 celle`):

```
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\walkforward_generico.ps1" -Expert ABTG_MeanRevert -Prova "$env:USERPROFILE\ABTG_MeanRevert.txt" -Modello 1 -Deposito 100000 -Etichetta mr1; $d=Join-Path ([Environment]::GetFolderPath("Desktop")) "mr1"; New-Item -ItemType Directory -Force -Path $d | Out-Null; Copy-Item "$env:USERPROFILE\risultati_prove\ABTG_MeanRevert\*mr1*" $d -Force -EA SilentlyContinue; Copy-Item "$env:USERPROFILE\gen_*mr1*.ini" $d -Force -EA SilentlyContinue; Get-ChildItem $d | Select-Object Name,Length | Format-Table -AutoSize; Compress-Archive -Path "$d\*" -DestinationPath (Join-Path ([Environment]::GetFolderPath("Desktop")) "mr1.zip") -Force; Write-Host "`nZIP: Desktop\mr1.zip" -ForegroundColor Green
```

📦 Nello zip: i due CSV **e le due `.ini`** (servono per controllare cosa ha
ricevuto MT5 senza doverle chiedere dopo).

🎯 **Il criterio n.1 e' congelato e non si ammorbidisce:** deve essere
**positiva nel LATERALE 2019**, dove `LARRY_GBPUSD` fa **−6.445**. Se e' rossa
anche li', la tesi e' morta e la famiglia si chiude.

---

## 2. ✅ ~~SBLOCCARE I DOMINI DELLE FONTI~~ — **FATTO E VERIFICATO**

**Il passo che moltiplica tutto il resto.** Procedura completa, lista dei 14
domini pronta da incollare, avvertenze:
`backtest_pipeline/caccia_strategie/PROMEMORIA_SBLOCCO_FONTI.md`

In due righe: **claude.ai/code** → icona a nuvola sopra la casella del
messaggio → ingranaggio sull'ambiente → **Network access: `Custom`** → domini
uno per riga → ⚠️ **spuntare "Also include default list of common package
managers"** (senza, si perde GitHub). Poi serve una **sessione nuova**.

---

## 3. 🕳️ `Nikkei225_Gap_Continuation` — **ED E' UN MOTORE DI APERTURA**

Promosso "in coda" nella seconda battuta di caccia. Prima di lanciarlo servono
tre cose, tutte gia' scritte in `SETACCIO_MANUALE.md`:

1. **sfrondare i 39 input** (le manopole vere sono ~7)
2. ⚠️ **risolvere il fuso**: e' tarato sul Nikkei di **Darwinex**, noi siamo su
   `225JPY` con **BCM un'ora indietro rispetto all'Italia**. Un EA di sessione
   con l'ora sbagliata misura un altro mercato.
3. **togliere l'asimmetria** `InpSellFullRiskFromGapPct = 1.25` (rischio
   diverso fra long e short: odore di taratura)

---

## 4. 📊 MISURE APERTE, piccole ma bloccanti

- **DD OOS originale di `COST_EURJPY`** — e' **l'unico numero** che separa
  quella cella da una promozione di rango (criterio A di R59).
- **Indici a tick reali su BCM**: `-Simboli "D30EUR,U30USD" -Timeframes "M1,H1" -Da 2015.01.01 -Auto`
  → 🔗 **e' il prerequisito P0 di R90** (vedi il blocco in cima): se i tick di
  U30USD andassero piu' indietro del 26/09/2024, le quattro finestre di regime
  si rifanno a tick e non su barre Dukascopy.
- **Storico Pepperstone degli indici**, a mercato aperto.
- ~~**Blocco LZMA** per i `.bi5` di Dukascopy~~ → **FATTO il 18/08**: pipeline
  Python pronta in `backtest_pipeline/dukascopy/dukascopy_m1.py` (autotest
  6/6). Dal cloud la rete e' bloccata (403 misurato): **gira sul PC di
  Claudio**. Prossimo passo suo: `--validazione` (righe di lancio in
  `risultati_archivio/REFERTO_DUKASCOPY_FATTIBILITA.md`, sez. 7).

---

## 5. 🧭 IL FILONE NUOVO: **motori per le APERTURE di DAX e Nasdaq**

_Intuizione di Claudio, 16/08. Merita un posto in coda, e merita anche i
numeri che gia' abbiamo — perche' cambiano DOVE cercare._

### Cosa abbiamo gia' misurato sulle aperture (e non va rifatto)

| round | cosa | esito |
|---|---|---|
| batteria ORB (R7-R13) | ~210 celle a tick reali, 4 mercati | _"il breakout puro al tocco e' morto ovunque"_ |
| **R42** | il **FADE** del range di apertura, NASUSD + D30EUR | **0 celle positive su 48** |
| **R45** | ORB sulla sessione di Londra | **0 celle verdi su 48** |
| **R12** | ORB + EMA200 + volumi sul Nasdaq | **48 su 48 negative OOS** |

> 🎯 **La lettura che resta da R42, ed e' la bussola di questo filone:**
> _"agli estremi del range di apertura non c'e' edge in nessuna direzione —
> **paga solo il RETEST**."_ Ed e' esattamente cio' che fa
> `ABTG_DAX_Apertura_EU`, che e' **live con win rate 81,0%**.

### Quindi dove si cerca DAVVERO

🚫 **Non** rottura, **non** fade: quelle due porte sono chiuse con 96 celle.

✅ **Si cerca:**
1. **Implementazioni esterne del RETEST** — l'unica meccanica di apertura che
   nei nostri dati paga. Confrontarle con la nostra ricetta e' un test vero.
2. **Il GAP di apertura in CONTINUAZIONE** — ed e' il candidato del punto 3.
   Noi abbiamo `ABTG_GapFill` (il gap **si chiude**, R36, `225JPY` promosso);
   la direzione opposta **non l'abbiamo mai misurata**, ne' sul Nikkei ne'
   sugli indici europei e americani. **Il candidato in coda e' gia' un motore
   di apertura: la sua tesi si trasferisce dritta su DAX e Nasdaq.**
3. **Il lato SHORT dell'apertura** — R54 ha bocciato lo short del Dow
   (PF OOS 0,840 su 73 trade), ma su DAX e Nasdaq non e' mai stato misurato
   come motore nato short, solo come ramo aggiunto.

### Parole per la caccia, aggiornate

| ✅ cerca | ❌ gia' coperto |
|---|---|
| **retest · gap continuation · opening drive · first pullback · reversal** | breakout · opening range · ORB · range fade · session |

---

## 6. 🐢 SUL FONDO (non urgenti, ma agli atti)

- Monte Carlo con **DD trailing** (il muro che si muove col picco)
- ricompilare gli EA con la guardia A4 sul VPS
- **staccare il PC dal conto live 50503392**
- misurare il **DST su BCM** — scadenza **25/10/2026**
- `SW_GBPUSD` TORO non riproduce R50 → **[INCERTO]**, aperto

---

> ### La frase da rileggere quando si riparte
> **Il collo di bottiglia oggi non e' il metodo, e non e' il materiale: e'
> quanto materiale riusciamo a far passare dal setaccio.** Su 22 file letti
> nel sorgente in una mattina: **1 promosso, 1 in coda, 12 scartati con
> motivo scritto**. Il setaccio funziona. Serve solo dargli piu' roba —
> ed e' il punto 2.
