# 🎓 ANALISI TRASCRIZIONI — MODULI **FIBO H4** e **MEDIA 200** (corso di Manuela Negro)

**Data:** 18/08/2026 sera · **Ordine di Claudio:** _"capire se si possono
meccanizzare e passare i nostri controlli per obiettivo prop firm"_.

**Fonte:** **8 trascrizioni**, lezioni **18-20** (Fibo H4) e **21-25** (Media
200), in `backtest_pipeline/caccia_strategie/trascrizioni_corso_2026-08-18/`
— **74.256 caratteri, letti per intero, riga per riga.**

**Consegne gemelle** (le specifiche montate per un developer — qui NON si
duplicano, si linkano):
- 📐 `backtest_pipeline/prove/FIBOH4_CORSO_SPEC.md`
- 📊 `backtest_pipeline/prove/MEDIA200_CORSO_SPEC.md`

> 🔒 **Nessuna modifica al forward. Nessun EA toccato. Nessun round lanciato.**
> Qui si misura e si propone. Decide Claudio.
>
> ⚠️ **Fonte SOLO AUDIO.** Zero slide, zero PDF per entrambi i moduli — a
> differenza del Breakout, dove le 10 slide della lez. 40 avevano chiuso 6
> ambiguita' su 10. **Le slide di questi due moduli sono citate 10 volte in
> totale (_"ritorniamo alle slide"_) e mai lette.** E' la richiesta n.1.
>
> 🎙️ **RELATORE: [INCERTO], ma NON e' la relatrice del Breakout.** Il modulo
> Breakout era di voce femminile (_"io sono entrat**a**"_); qui la voce e'
> maschile (_"sono molto impegnat**o**"_, _"saro' piu' confident**e**",
> _"io personalmente sono un trader"_). Usa il **"noi"** (_"come ti abbiamo
> spiegato"_): e' un corso a piu' docenti. `docs/live_emiliano/CATALOGO_STRATEGIE_CORSO.md`
> attribuisce la Media 200 a **Paolo** e il file prova del Fibo dice
> _"piano FiboH4 **di Paolo**"_ → **[INFERITO]: e' Paolo.** Non e' scritto nelle
> trascrizioni: nessun nome viene mai pronunciato.

---

# PARTE 1 — 🔥 LA SINTESI, PRIMA DI TUTTO

## 1.1 I due verdetti in due righe

| modulo | meccanizzabilita' | verdetto imbuto |
|---|---|---|
| 📐 **FIBO H4** | **50% secco** (17 regole certe su 34 decisioni) · **79%** con 8 assunzioni dichiarate | 🟡 **SI, MA SOLO COME RI-MISURA**: il nostro EA implementa **una geometria diversa da quella insegnata**, e il "0/8" in archivio non ha mai giudicato la strategia del corso |
| 📊 **MEDIA 200** | **48% secco** (16 su 33) rimbalzo · **45%** (5 su 11) break-in/break-out · **79% / 73%** con le assunzioni | 🟢 **il rimbalzo NON serve all'imbuto — ci e' gia' passato e ha VINTO** (R29, 30/30). 🟢 **SI per il break-in/break-out della lez. 25: e' materia nuova, e ha il trigger piu' pulito di tutte e 8 le lezioni** |

## 1.2 🚨 IL FATTO PIU' PESANTE DELLA SERATA

> **Il nostro `ABTG_FiboH4_Multi` non implementa la strategia del corso.
> Implementa una strategia diversa che porta lo stesso nome. Il "0/8 promossi"
> della fascia B (10-11/08) ha bocciato la NOSTRA geometria, non quella
> insegnata — e non lo sapevamo perche' nessuno aveva mai letto le lezioni.**

Due divergenze di **geometria** (non di sfumatura), dimostrate in
`FIBOH4_CORSO_SPEC.md` §3.2, §3.3, §10:

| | corso | `ABTG_FiboH4_Multi.mq5` | fattore |
|---|---|---|---|
| **Dove vanno i 2 ordini** | sui **due bordi di UNA banda** (1,78-1,88 *oppure* 2,78-2,88), distanti **0,10 × range ≈ 5-10 pip** | **uno su 1,88 e uno su 2,88**, distanti **1,0 × range** | 🔴 **~×10** |
| **Dove va il target** | il **livello 100** = estremo di **partenza** del pattern → `0,88 × range` da EZ1 | l'**estremo opposto** (livello 0,0) → `1,88 × range` | 🔴 **×2,1** |
| **Quale stop** | **7 metodi alternativi**; nell'esempio pratico usa **R:R 1:1, 17 pip** | **il 4,236 fisso**, il piu' largo dei 7, **mai messo a sweep** | 🔴 **~×4** |

🧮 **E l'aritmetica dice quanto costa:** con lo stop 4,236 e il target
all'estremo opposto, la gamba EZ1 dell'EA ha un **R:R strutturale di 0,80** →
le serve **win rate > 56%** solo per pareggiare, **prima** di spread e
commissioni. Con la lettura del corso quella stessa gamba ha un profilo
completamente diverso.

> ⚖️ **Cosa NON sto dicendo:** che la strategia funzioni. Sto dicendo che
> **il 0/8 non e' il verdetto che credevamo di avere.** Il referto in archivio
> chiudeva cosi': _"Mai piu' senza una tesi nuova."_ ✅ **La tesi nuova ora c'e',
> ha tre numeri dietro, ed e' falsificabile in un round.**

### 🔎 Come l'ho dimostrato (perche' un'inferenza va mostrata, non annunciata)
Il corso detta **quattro** livelli Fibo (1,88 · 1,78 · 2,88 · 2,78) ma mette
l'etichetta _"entry zone"_ **solo su due**. La banda 1,88−1,78 vale
`0,10 × range`; con un pattern engulfing H4 tipico di 50-100 pip fa **5-10 pip**
— ed e' **esattamente** quello che il relatore misura fra i suoi due ordini:
> _"sono abbastanza vicini, quindi **circa 5 pip**, anche qua siamo in H4, posso
> stabilire **10 pip** di distanza"_ (lez. 20)

Due numeri indipendenti che coincidono. **Il nostro EA non ha 1,78 e 2,78 da
nessuna parte nel sorgente.**

## 1.3 🏆 IL SECONDO FATTO PESANTE: la MEDIA 200 del corso è il nostro EMA200 — e noi abbiamo fatto meglio del corso

**Richiesta esplicita di Claudio.** Dettaglio completo in
`MEDIA200_CORSO_SPEC.md` §11. La sintesi:

**✅ La macchina e' IDENTICA, punto per punto:** EMA 200 esponenziale su close ·
EMA 14 come primo target · ATR 14 per lo stop · **due ordini limite** attorno
alla media · stop **oltre il secondo ordine** · parziale **50% + stop in pari** ·
trailing su EMA14 · distanza operativa **50-70 pip** · cancellazione dei pendenti
non eseguiti. I commenti dentro `ABTG_EMA200.mq5` citano _"guida ~5 pip"_,
_"guida ~15 pip"_, _"guida ~50/70 pip"_, _"guida: H4/D1"_: **sono i numeri di
queste cinque lezioni.**

**🔴 Ma le due differenze che contano vanno CONTRO il corso — e sono quelle che
hanno prodotto il risultato:**

| | il corso dice | noi facciamo | esito |
|---|---|---|---|
| **Timeframe** | **H4/D1**. Su H1: _"un time frame ... che gli istituzionali **non utilizzano**"_ | **H1** | **R29: 30 celle su 30 a PASS pieno**, PF OOS 1,52, DD 7,21%, 444 trade |
| **Mercato** | **solo valute** (giro del Market Watch) | **U30USD (Dow)**, un **indice**, mai nominato in 5 lezioni | idem |
| **Il terreno del corso** | il forex | **EURUSD in R29** | ❌ **BOCCIATO** (7/30 PASS sparsi, PF 1,08-1,13, DD fino al 12%) |

> 🎯 **La lezione, che vale oltre questo referto:** il corso ci ha dato **la
> macchina**; **l'edge ce lo siamo dato noi, disobbedendo a due sue indicazioni
> esplicite.** E' la conferma sul campo di `caccia_strategie/LEGGIMI.md`:
> _"si raccoglie la MECCANICA e la TESI, mai il risultato"_.

**🔴 E c'e' una cosa che al nostro EA MANCA, ed e' il cuore del corso:** il
**filtro dell'arrivo sulla media** (spike vs candela piena). Il relatore lo
chiama _"**l'unica cosa sulla quale stare attenti**"_ di tutta la strategia.
L'intestazione del nostro sorgente lo ammette per iscritto:
_"NON automatizzato ... **timing intra-candela. Restano all'occhio umano**"_.
**E' quantificabile** (§1.7) → **e' la proposta numero 1 della serata.**

## 1.4 📊 TABELLA DEI VALORI CONVERGENTI

> ⚠️ **Avvertenza metodologica obbligatoria: qui la convergenza vale POCO.**
> Le 8 trascrizioni sono **8 lezioni dello stesso relatore nello stesso corso**:
> sono **UNA fonte, non otto**. La ripetizione distingue solo cio' che il corso
> **sostiene stabilmente** da cio' che ha detto **una volta sola** (e che quindi
> puo' essere un lapsus o un errore di speech-to-text).

### FIBO H4
| parametro | valore | lezioni | robustezza interna |
|---|---|---|---|
| Timeframe | **H4, solo H4** | 18 (×3 nella stessa frase) | 🟢 martellato |
| Livelli Fibo | **1,88 · 1,78 · 2,88 · 2,78** (+ 4,236 nativo) | 18 | 🟢 dettati uno per uno, con l'ordine delle operazioni |
| Distanza minima prezzo→zona | **50-60 pip** | 19 (×4) | 🟢 dominante |
| Distanza (deroga) | 35 pip _"se stai li' a guardare"_ | 19 | 🟠 discrezionale |
| Split size | **1/3 + 2/3** | 19 | 🟢 una volta ma inequivoco |
| Pattern | **engulfing totale, ombre incluse, max 2 candele** | 19 (×4), 20 (×5) | 🟢 martellato |
| Lookback | **8-12 candele** | 19, 20 | 🟠 oscilla fra "8-10" e "8,10,12" |
| Zona preferita | **la seconda** | 19 | 🟢 chiaro |
| Distanza fra i 2 ordini | **~5 pip / 10 pip** | 20 | 🟠 due valori |
| Target finale | **il 100 di Fibonacci** | 19, 20 | 🟢 stabile |
| Primo target | **la prima entry zone** | 20 | 🟠 una volta sola (e la 19 la contraddice) |
| Al primo target | **50% + stop in pari** | 19, 20 | 🟢 stabile |
| Cancellazione pendenti | **18:30-19:00** (anche 18:45) | 18, 19 | 🟠 finestra |
| Weekend | **MAI esposti** | 18 | 🟢 la regola piu' netta |
| **Filtro news** | **OBBLIGATORIO**, deroga a >=100 pip | 18 | 🟢 chiaro e implementabile |
| **Rischio %** | — | **MAI** | 🔴 **buco** |
| **"Fine di un trend"** | — | **MAI definito** | 🔴 **buco bloccante** |
| **Fuso orario** | — | **MAI dichiarato** | 🔴 **buco** |

### MEDIA 200
| parametro | valore | lezioni | robustezza interna |
|---|---|---|---|
| Media | **EMA 200, esponenziale, su CLOSE** | 21 | 🟢 **periodo + metodo + prezzo applicato: il parametro meglio dettato di tutto il corso** |
| Media target | **EMA 14, esponenziale, close** | 21, 23 | 🟢 stabile |
| ATR | **periodo 14** | 23 | 🟢 chiaro |
| Timeframe | **H4 o D1** ("istituzionali"); H1 solo per rifinire | 21 (×3), 24 | 🟢 stabile |
| Distanza prezzo→media | **50 / 60 / 70 pip max** | 21 (×2), 22 (×2), 23 | 🟢 **dominante** |
| Scarto: troppo vicino | 12 pip | 21 | 🟢 esempio numerico |
| Scarto: troppo lontano | 120 pip | 22 | 🟢 chiaro |
| Ordini | **2 pendenti limite** (3° facoltativo) | 22 | 🟢 stabile |
| Distanza fra i 2 ordini | **20 pip su H4** (10/15/20 per TF) | 22 | 🟢 chiaro, aritmetica coerente (212 punti) |
| Size | **piccola davanti, grande oltre la media** | 22 (×3) | 🟢 principio stabile, 🟠 nessun rapporto dichiarato |
| Stop | **1 o 2 ATR sotto l'ORDINE PIU' GRANDE** | 23, 24, 25 | 🟢 **la regola di rischio meglio definita del modulo** |
| Al primo target | **50% + stop in pari** | 22, 23, 24 (×2), 25 | 🟢 martellato |
| Filtro d'arrivo | **spike = si resta · candela piena = si cancella** | 23 (×3), 24 (×2) | 🟢 concetto stabile, 🔴 **zero soglie** |
| **Rischio %** | — | **MAI in 5 lezioni** | 🔴 **buco** |
| **Filtro news** | — | **MAI nominato** | 🔴 **buco (e il modulo gemello lo rende obbligatorio!)** |
| **Tetto posizioni / correlazione** | — | **MAI** | 🔴 **buco — il killer prop** |
| **Overnight / weekend** | — | **MAI affrontati** | 🔴 buco |
| **Qualunque numero di performance** | — | **MAI** | 🔴 **zero, in 45.944 caratteri** |

## 1.5 ⚔️ LE CONTRADDIZIONI

| # | modulo | contraddizione | dove | esito |
|---|---|---|---|---|
| 1 | Fibo | **quando si dimezza?** lez. 19: _"dimezzo e porto lo stop in pari **quando arriva al 100**"_ · lez. 20: si dimezza sulla **prima entry zone**, il 100 e' la **chiusura totale** | 19 vs 20 | ✅ risolta a favore della **20**: dimezzare sul target finale non ha senso operativo |
| 2 | Fibo | **la "terza zona"** — _"se sono nella seconda e terza zone"_ | 19 | ✅ lapsus: sono state dettate **due** zone (4 livelli) |
| 3 | Fibo | **il lookback**: "8-12" vs "8-10" vs "8, 10, 12" | 19, 20 | 🟠 aperta, impatto basso (a sweep) |
| 4 | Fibo | **18:30 vs 18:45 vs 19:00** nella stessa frase | 19 | 🟠 aperta, impatto basso |
| 5 | Fibo | **regola dura + scappatoia**: _"non vanno portati over night"_ MA _"puoi anche pensare di portarla over night"_ | 18 | ⚖️ la scappatoia **non ha criterio**: per un EA si ignora |
| 6 | **Media 200** | 🔴 **il SEGNO DEL TRADE.** Lez. 21: _"segnale di acquisto quando il prezzo **attraversa la media dal basso verso l'alto**"_ (attraversamento). Lez. 22-24: si compra il **ritorno** sulla media col prezzo gia' sopra (rimbalzo). **Sono opposti.** | 21 vs 22-24 | ✅ risolta: la definizione della **21 appartiene alla lezione 25** (break-in/break-out) e non e' raccordata. 🔴 **Ma chi si ferma alla 21 implementa il segno invertito** |
| 7 | **Media 200** | 🔴 **il target del break-in**: _"il primo naturale obiettivo del prezzo e' **sempre la media**"_ — ma si e' appena entrati **rompendo** la media, che sta **dietro** al prezzo | 25 | ✅ frase copiata dal modulo del rimbalzo. **Da scartare** |
| 8 | **fra i due moduli** | 🔴 **IL FILTRO NOTIZIE.** Fibo H4: obbligatorio, con fonti (Forex Factory/Investing), lista eventi e deroga a 100 pip. Media 200: **mai nominato in 5 lezioni** | 18 vs 21-25 | 🔴 **APERTA — lo stesso corso e' incoerente con se stesso su una regola che tocca le prop** |
| 9 | Media 200 | **size "1,05" = "50 mila euro"** — 50.000 su lotti da 100.000 fa **0,50** | 21 | ✅ **[TRASCRITTO dubbio] risolto**: la lez. 22 dice _"size **0,50**"_ |
| 10 | Media 200 | **"1 ATR o 2 ATR?"** — _"all'inizio 1 ATR e poi inserire 2 ATR"_ (progressione o varianti?), ma anche _"17 e' poco per un timeframe H4"_ | 23 | 🟠 **aperta**, e il corso sembra preferire **2 ATR** |

## 1.6 🚩 BANDIERE ROSSE DEL SETACCIO — il bilancio (ed e' migliore del previsto)

| bandiera | Fibo H4 | Media 200 |
|---|---|---|
| Martingala / raddoppio dopo la perdita | 🟢 **assente** | 🟢 **assente** |
| Griglia | 🟢 assente | 🟢 assente |
| Recovery / mediare in perdita | 🟢 assente | 🟢 assente |
| Hedge | 🟢 assente | 🟢 assente |
| Operare senza stop loss | 🟢 **stop sempre presente** | 🟢 **stop sempre presente, ancorato all'ordine piu' grande** |
| Trucchi anti-prop | 🟢 **le prop non sono mai nominate** | 🟢 idem |

> ✅ **Su entrambi i moduli il setaccio del §4 non trova niente.** Va detto
> chiaro: **l'impianto di rischio e' sano.**
>
> ⚠️ **L'unica cosa che SOMIGLIA a un ingrandimento in perdita — e non lo e'.**
> Entrambi i moduli entrano con **due ordini a prezzi progressivamente
> peggiori** (Fibo: 1/3 + 2/3; Media 200: 0,50 + 1,50). **Non e' martingala:** la
> size totale e' **decisa prima**, gli ordini sono **pendenti pre-impegnati**, e
> **lo stop unico sta oltre entrambi** (_"lo stop loss lo metto **sempre
> sull'ordine piu' grande, sotto**"_). Perdita massima **limitata e nota in
> partenza**. 🟠 **L'appunto vero:** la motivazione data e' **sempre psicologica**
> (_"mindset"_, _"per non andare in sofferenza"_, _"condizionamenti
> psicologici"_), **mai il rischio**.

### 🟠 Le quattro bandiere gialle che restano
1. 🔴 **L'"80-85%"** (Fibo, lez. 18): _"invertira' ... con una certa statistica
   di circa l'**80-85%** delle volte"_. **E' l'unico numero di performance dei
   due moduli e non ha niente dietro**: nessun campione, nessun periodo, nessun
   broker, e nemmeno una definizione di "invertira'" (di quanto? entro quando?).
2. 🔴 **"Statisticamente provata"** (Media 200, lez. 25) con **zero numeri** in
   45.944 caratteri.
3. 🟠 **Nessun esempio di operazione PERDENTE** viene mostrato in **8 lezioni**.
   Solo esempi vincenti scelti dal relatore = selection bias per costruzione.
4. 🟠 **Lo spostamento degli ordini "se arriva con forza"** (Media 200, lez. 24):
   il livello di invalidazione **insegue il prezzo**. ⚖️ Precisazione dovuta:
   sono **ordini pendenti, non posizioni aperte** — non e' un allargamento di
   stop. Ma il grilletto non ha soglia.

## 1.7 🏛️ CONFORMITA' PROP — i due moduli sono molto diversi

| voce | 📐 FIBO H4 | 📊 MEDIA 200 |
|---|---|---|
| **Filtro news** | 🟢 **OBBLIGATORIO** (Forex Factory/Investing · esclusione per valuta · deroga a >=100 pip · lista NFP/tassi/CPI/governatori) | 🔴 **mai nominato** |
| **Overnight** | 🟢 **vietato** (cancella alle 18:30-19), 🟠 con scappatoia discrezionale | 🔴 mai affrontato — su H4/D1 le posizioni durano **giorni per costruzione** |
| **Weekend** | 🟢 **"mai e qua dico mai"** — con motivazione corretta (gap, swap, impossibilita' di intervenire) | 🔴 mai affrontato |
| **Cap giornaliero** | 🔴 assente | 🔴 assente |
| **Tetto posizioni / correlazione** | 🔴 assente (_"lo fai su tutto"_) | 🔴 **assente e piu' grave** (_"un giro su **tutte le valute**"_) |
| **Rischio per operazione** | 🔴 **mai dichiarato** | 🔴 **mai dichiarato** (~**1,6%** ricostruito dall'esempio AUDCAD) |
| **Umano nel ciclo** | 🟠 conferma visiva sui livelli tecnici | 🔴 **per progetto**: trailing manuale, controllo _"ogni ora"_ dal cellulare, spostamento ordini a occhio |

> 🚨 **IL KILLER PROP, ed e' lo stesso per entrambi (e lo stesso del Breakout
> JPY): NESSUN TETTO SULL'ESPOSIZIONE AGGREGATA.**
> La routine e' _"giro su tutte le valute, ordini su ognuna che sta nella
> distanza giusta"_. In una mattina in cui il dollaro e' a 60 pip dalla media su
> sei cross, si aprono **sei posizioni nella stessa scommessa**:
> `6 × ~1,6% ≈ **10% a rischio in un verso**`.
> Contro un daily loss del **5%** (`report/METRO_PROP.md` §2 — la nostra peggior
> giornata **misurata** e' **−2,06%**), e' **una violazione a portata di una sola
> mattina**. **La parola "correlazione" non compare in 74.256 caratteri.**
>
> ⚖️ **In compenso, e va detto:** il **Fibo H4 e' il modulo piu' prop-compatibile
> uscito finora dal corso** — filtro news obbligatorio, niente overnight, niente
> weekend, stop sempre presente. Sono **esattamente** le tre voci su cui il
> modulo Breakout era scoperto (`ANALISI_CORSO_BREAKOUT_2026-08-18.md` §1.8).

## 1.8 🎯 MERCATI E TIMEFRAME DICHIARATI (e il confronto col nostro repo)

| | 📐 FIBO H4 | 📊 MEDIA 200 |
|---|---|---|
| **Timeframe dichiarato** | **H4 e SOLO H4** — _"non si scende di time frame"_ | **H4 o D1**; H1 solo per rifinire il punto d'ordine |
| **Mercati dichiarati** | **tutti i cross forex**; preferiti **GBPUSD** e **USDJPY** | **tutte le valute** (giro del Market Watch) |
| **Indici / oro** | ❌ **mai nominati** | ❌ **mai nominati** |
| **Cosa gira da noi** | `ABTG_FiboH4_Multi` su `GBPUSD;USDJPY;EURUSD`, H4 → **coerente col corso** | `ABTG_EMA200` **U30USD H1** → 🔴 **incoerente col corso, ed e' la sedia che funziona** |

## 1.9 ❓ LE DOMANDE PER CLAUDIO (in ordine di quanto sbloccano)

1. 🔴🔴 **LE SLIDE DI ENTRAMBI I MODULI.** Citate **10 volte** (_"ritorniamo
   alle slide"_, _"sono tutti i valori raffigurati nella slide"_) e **mai
   lette**. Nel Breakout hanno chiuso **6 ambiguita' su 10** e alzato la
   meccanizzabilita' dal 71% all'87%. **Costo zero, resa massima.**
2. 🔴 **Uno screenshot del Fibonacci tracciato con la linea "100" visibile**
   (lez. 19 o 20). Chiude in 5 secondi la **divergenza del target** (§1.2) —
   che vale un fattore **2,1** sul rendimento atteso.
3. 🔴 **Uno screenshot del pannello Fibo con le 4 descrizioni** (lez. 18).
   Conferma o smentisce che l'entry zone sia una **banda** — fattore **10** sulla
   distanza fra gli ordini.
4. 🔴 **Il fuso della piattaforma** (l'orologio MT4 in basso a destra, un
   qualsiasi screenshot). Vale per **entrambi** i moduli: gli orari 08:00 /
   18:30-19:00 sono **inutilizzabili senza**. E su H4 il fuso del broker sposta
   anche **l'allineamento delle candele**.
5. 🔴 **Quale % di rischio insegna questo relatore?** **Mai pronunciata in 8
   lezioni.** Sta probabilmente nei "capitoli precedenti" a cui rimanda (_"tutti
   i concetti di stop loss ... li abbiamo gia' spiegati ampiamente"_).
6. 🟠 **I minuti in cui indica uno "spike" e una "candela bella piena"** (Media
   200, lez. 23/24): servono a calibrare le due soglie del filtro d'arrivo — che
   e' **l'unico filtro d'ingresso della strategia**.
7. 🟠 **Esiste un backtest di questi due moduli nel corso?** In 8 lezioni **non
   c'e' un solo numero di performance** oltre all'"80-85%" nudo.

## 1.10 🧭 COSA PROPONGO (proposta, non azione)

> 🔒 Nessuna modifica applicata. Nessun round lanciato.

### 🥇 PRIMA — **il filtro d'arrivo della MEDIA 200**, su `ABTG_EMA200`
E' **l'unico buco del corpus pienamente quantificabile senza inventare la
strategia**: il corso da' la **forma** della regola, a noi mancano due soglie.
```
spike  := ombra_lato_media / range_barra >= X      [X ~ 0,4-0,5]
pieno  := |close-open| / (high-low)     >= Y       [Y ~ 0,7-0,8]
timing := tocco della media entro i primi 30 min della barra H1 -> OK
          tocco entro i primi ~2 min con barra "piena"          -> CANCELLA
```
**Perche' prima di tutto:** agisce sulla **sedia 12**, l'unico 30/30 del
progetto; e' **A/B puro** (on/off, nessun altro parametro cambia); e va nella
direzione della **selettivita'**. ⚠️ E porta con se' un rischio da dichiarare
prima: su H1 la "barra oraria" della regola **coincide** con la barra operativa
— la regola del corso e' pensata per **H4 operativo + H1 di sorveglianza**.
**Va scritto nel file prova che stiamo trasportando la regola su un impianto
diverso da quello per cui e' stata pensata.**

### 🥈 SECONDA — **il break-in/break-out della lez. 25**: EA nuovo
E' **materia genuinamente nuova** (nessun nostro EA la copre) e ha il trigger
**piu' pulito di tutte e 8 le lezioni**: _"la candela successiva alla violazione
**apre sopra la media**"_ → **binario, oggettivo, testabile senza una sola
assunzione**. Costo di porting basso: riusa la EMA200, l'ATR, la gestione a
parziale + BE che `ABTG_EMA200` ha gia'.
⚠️ **Il segno del trade e' OPPOSTO al rimbalzo:** e' un EA nuovo, **non un flag**
di `ABTG_EMA200`. Magic vergine.

### 🥉 TERZA — **ri-misurare il FIBO H4 con la geometria del corso**
Il 0/8 in archivio diceva _"mai piu' senza una tesi nuova"_. **La tesi c'e'**
(§1.2) e ha tre gambe indipendenti e falsificabili:
1. entry zone = **banda**, 2 ordini a `0,10 × range`;
2. target = **livello 100**, parziale sulla zona precedente;
3. `InpSLratio` **a sweep** (4,236 vs R:R 1:1 vs 1 ATR) — non e' mai stato mosso.
Piu' il **filtro "fine di un trend"** in A/B (§1.11), che oggi **non esiste** e
che il corso dichiara **precondizione assoluta**.
⚠️ **Costo:** non e' un ritocco di parametri, e' **un EA diverso**. Va deciso
se vale, dato un 0/8 gia' in archivio.

### 🚫 QUARTA — cosa NON propongo
- **Non** propongo di toccare il forward. Nessuno dei tre punti sopra tocca una
  sedia viva: sono round di misura.
- **Non** propongo di portare questi due moduli su una prop **cosi' come sono**:
  senza tetto sull'esposizione aggregata (§1.7) **non superano il nostro
  cancello**, prima ancora che quello della prop.

## 1.11 🔴 LE TRE ASSUNZIONI PIU' PESANTI (che sono NOSTRE, non del corso)

Se si apre un round, **queste vanno scritte nel file prova PRIMA dei numeri**:

| # | buco del corso | assunzione proposta | perche' e' pesante |
|---|---|---|---|
| 1 | **"la fine di un trend"** (Fibo) — mai definita in 28.312 caratteri, ma dichiarata **precondizione assoluta** (_"scartiamo a priori"_) | filtro misurabile A/B (es. `\|close − EMA50\| > k·ATR`, o pendenza EMA50) | **e' la condizione che scarta la maggior parte dei segnali.** Un EA senza non fa "Fibo H4": fa "engulfing ovunque" |
| 2 | **quale dei 7 stop loss** (Fibo) | sweep: 4,236 (attuale) vs R:R 1:1 (quello che il relatore usa **davvero** nell'esempio) vs 1 ATR | **cambia il rischio di ~4 volte a parita' di segnale** |
| 3 | **la % di rischio** (entrambi) | **0,65% di casa.** ❌ **NON** l'1% preso in prestito dal modulo Breakout: relatore diverso, modulo diverso | ricostruire ~1,6% da un esempio su conto altrui **non e' una regola del corso** |

---

# PARTE 2 — 📇 LE SCHEDE, LEZIONE PER LEZIONE

---

## 📐 MODULO FIBO H4 (lezioni 18-20)

### 📄 SCHEDA 1 — `18. FIBO H4 SET UP.GRAFICO E IMPOSTAZIONE DELLA STRATEGIA.txt`

| campo | contenuto |
|---|---|
| **FILE** | `18. FIBO H4 SET UP...txt` (~9.400 caratteri) |
| **RELATORE** | voce **maschile**, non nominata `[INCERTO]` — vedi nota in testa |
| **OGGETTO** | Setup dell'oggetto Fibonacci + impianto operativo (TF, orari, giorni, universo, news). **La lezione a piu' alta densita' di parametri del modulo.** |

**PARAMETRI CON VALORE**

| parametro | valore | citazione | etichetta |
|---|---|---|---|
| Piattaforma | MT4 | _"Fibo H4 e' un indicatore che si trova all'interno dell'MT4"_ | 🟢 chiaro |
| **Timeframe** | **H4, solo H4** | _"il time frame operativo e' quello di H4 e ... **solo H4, non si scende di time frame, solo H4**"_ | 🟢 **martellato ×3** |
| **Livelli Fibo** | **1,88 · 1,78 · 2,88 · 2,78** | _"metti **1.88** ... scrivi **entry zone** ... metterai **1.78** ... e lasci vuoto questo campo ... metti **2.88** ... **entry zone** ... metterai **2.78**"_ | 🟢 **chiaro: dettati uno per uno, con le descrizioni** |
| Livello nativo | **4,236** | _"i valori determinati dalla piattaforma di Fibonacci arrivano proprio al **4.236**"_ (altrove _"423.6"_) | 🟢 chiaro (le due forme sono lo stesso numero) |
| Colore | giallo, in contrasto col fondo | | (cosmetico) |
| Grafico | candele giapponesi, senza griglia | | (cosmetico) |
| **Ora di impostazione** | **08:00** | _"la strategia va impostata al mattino alle 8"_ | 🟢 chiaro, 🔴 **fuso non dichiarato** |
| **Cancellazione pendenti** | **18:30-19:00** | _"se gli ordini non vengono eseguiti entro le **18.30-19** vanno cancellati"_ | 🟢 chiaro, 🔴 fuso non dichiarato |
| Giorni | **lun-gio**, ven occasionale | _"noi lo utilizziamo dal lunedi' al giovedi'"_ | 🟢 chiaro |
| Giorni migliori | martedi' e mercoledi' | | 🟠 senza dato |
| Universo | tutti i cross; **GBPUSD e USDJPY** i migliori | _"i cross che hanno statisticamente i maggiori segnali sono **Gbpsd e Usd yen** ... ma **lo fai su tutto**"_ | 🟢 chiaro (_"Gbpsd"_ = GBPUSD) |
| Deroga news | **>= 100 pip** di distanza | _"il prezzo e' distante almeno di **100 pip**, posso prendere in considerazione"_ | 🟢 chiaro |
| **80-85%** | statistica di inversione | _"invertira' la sua posizione ... con una certa statistica di circa l'**80-85%** delle volte"_ | 🔴 `[dichiarato, NON verificato]` — **niente dietro** |

**MECCANISMI**
- 🟢 **Filtro notizie obbligatorio** con fonti (**Forex Factory**, **Investing**),
  **esclusione per valuta** (_"se c'e' un dato che impatta su Usd, non vado a
  prendere in considerazione le valute che hanno come numeratore o denominatore
  il dollaro"_), **lista eventi** (_"i non peroli"_ = NFP, _"Fan Perol"_ = Non
  Farm Payrolls, tassi d'interesse, CPI, discorsi dei governatori) e **deroga a
  100-150 pip**. `[TRASCRITTO]` — **la parte migliore dell'intero modulo.**
- 🟢 **Divieto di esposizione nel weekend**, con motivazione tecnica corretta:
  _"succede una guerra ... ti trovi il mercato alla domenica ... con un **gap up
  o gap down** ... ti fa saltare dello swap e puo' aumentare la perdita"_.
- 🟠 **Scappatoia overnight**: _"con un corretto money management **se lo
  desideri** ... **puoi anche pensare** di portarla over night"_.

**REGOLE PROP CITATE:** nessuna (le prop non sono mai nominate).

**NUMERI DI PERFORMANCE:** **solo** l'80-85% `[dichiarato, NON verificato]`.

**BANDIERE ROSSE**
- 🔴 **L'80-85% e' l'unico numero del modulo e non ha campione, periodo, broker,
  cross, ne' una definizione di "inversione".**
- 🟠 _"GBPUSD e USDJPY **statisticamente** i migliori"_ senza un solo confronto.
- 🟢 Nessuna bandiera del setaccio §4.

**A SCHERMO E NON NEL PARLATO** 🖼️
1. 🔴 **Le SLIDE** — _"sono tutti i valori che sono raffigurati **nella slide**
   che ti ho fatto vedere in precedenza, quindi non preoccuparti, **sono
   scritti**"_. La fonte scritta esiste e non ce l'abbiamo.
2. 🔴 Il **pannello Fibo Proprieta'** con le 4 descrizioni (conferma della banda).
3. 🔴 L'**orologio della piattaforma** (fuso).

**COSA NE COPIAMO** ✅ i 4 livelli Fibo · H4 · orari (con l'assunzione sul fuso) ·
giorni · universo · **tutto il filtro notizie**. 🚫 Non copiamo l'80-85% ne' la
scappatoia overnight.

---

### 📄 SCHEDA 2 — `19. FIBO H4 PATTERN, REGOLE D'INGRESO E GESTIONE DELL'OPERAZIONE PT. 1.txt`

| campo | contenuto |
|---|---|
| **FILE** | `19. ... PT. 1.txt` (~9.100 caratteri) |
| **OGGETTO** | Il pattern, il tracciamento del Fibo, il piazzamento degli ordini. **La lezione fondativa.** |

**PARAMETRI CON VALORE**

| parametro | valore | citazione | etichetta |
|---|---|---|---|
| **Pattern** | candela **coperta totalmente**, ombre incluse, da **1 o 2** candele successive | _"assorbe completamente **anche gli spike**"_ · _"**massimo due**"_ | 🟢 chiaro, ribadito 4 volte |
| **Precondizione** | **fine di un trend**, mai in laterale | _"se siamo in una **fase laterale scartiamo a priori**, solo alla fine di un trend"_ | 🟢 chiara come **regola**, 🔴 **mai definita come misura** |
| **Lookback** | **8-12 candele** | _"tengo in considerazione per andare indietro **massimo dalle 8 alle 12 candele**"_ | 🟠 oscilla |
| Tracciamento | **massimo↔minimo, nei due versi** | _"unisco semplicemente il massimo con il minimo e viceversa"_ | 🟢 chiaro |
| **Distanza minima prezzo→zona** | **50-60 pip** | _"una distanza minima di almeno **50-60 pip**, proprio per dare allo strumento la possibilita' di esprimersi"_ | 🟢 chiaro ×4 |
| Deroga | **35 pip** con presenza umana | _"se siamo a **35** devi stare li' a guardare l'operazione"_ | 🟠 discrezionale |
| Zona preferita | **la seconda** | _"l'entry zone migliore ... e' **la seconda**"_ | 🟢 chiaro |
| **Split size** | **1/3 + 2/3** | _"metto **un terzo della size e due terzi** sotto"_ | 🟢 chiaro |
| Cancellazione | 18:45 / 18:30 / 19:00 | | 🟠 tre valori |
| Esclusioni | candele con _"movimenti importanti"_ | _"queste candele io non le prendo in considerazione, **mai!**"_ | 🔴 **enfatica, senza soglia** |
| Se prezzo addosso a EZ1 | **si usa solo EZ2** | _"non metto qui gli ordini pendenti, ma prendo in considerazione **solo la seconda entry zone**"_ | 🟢 regola chiara |
| Stop | 7 metodi alternativi | (vedi SPEC §6) | 🔴 **nessun criterio di scelta** |
| **Rischio %** | _"sara' **una percentuale** del capitale"_ | | 🔴 **la percentuale non viene detta** |

**MECCANISMI**
- **Ordini pendenti, sempre due**, motivati dal _"mindset"_ (§1.6).
- **Conferma sui livelli tecnici del passato**: _"verifico sempre nel passato se
  corrispondono a dei livelli tecnici, quindi supporti, resistenze o delle aree
  di liquidita'"_ `[TRASCRITTO]` → 🔴 **lettura visiva, non meccanizzabile.**
- **Gestione**: _"dimezzo e porto lo stop in pari"_ → 🔴 ma il **quando**
  contraddice la lez. 20 (§1.5 n.1).
- **Rimando esterno**: _"sempre con gli stessi criteri di stop loss che ti
  abbiamo spiegato **nei capitoli precedenti**"_ → **il modulo non e'
  autosufficiente.**

**REGOLE PROP CITATE:** nessuna. **NUMERI DI PERFORMANCE:** nessuno.

**BANDIERE ROSSE**
- 🔴 **La precondizione decisiva ("fine di un trend") e' dichiarata e mai
  definita.** Il relatore passa in rassegna i cross dicendo _"laterale, lascia
  stare"_ **senza mai dire in base a cosa**.
- 🔴 **Sette stop loss alternativi senza criterio di scelta.**
- 🟠 La **"terza zona"** che non esiste (§1.5 n.2).
- 🟠 _"questa operazione non la faccio perche' sono molto impegnato"_ — l'esempio
  mostrato **non e' un'operazione fatta**, e' un backtest a occhio sul passato.
- 🟢 Nessuna bandiera del setaccio §4.

**A SCHERMO E NON NEL PARLATO** 🖼️
1. 🔴 **Le slide** (_"Torniamo alle slide"_ ×2).
2. 🔴 Il Fibo tracciato con la linea **100** (chiude la divergenza del target).
3. 🟠 Cross, date e prezzi degli esempi (AUDCAD, AUDCHF): **zero prezzi assoluti
   in tutta la lezione**.

**COSA NE COPIAMO** ✅ pattern engulfing totale · lookback 8-12 · distanza minima
50 pip · split 1/3+2/3 · preferenza per EZ2 · regola "addosso a EZ1 → solo EZ2".
🚫 Non copiamo: la conferma visiva sui livelli, la deroga a 35 pip, il gate
sull'esperienza, la "terza zona".

---

### 📄 SCHEDA 3 — `20. FIBO H4 PATTER, REGOLE D'INGRESSO E GESTIONE DELL'OPERAZIONE PT. 2.txt`

| campo | contenuto |
|---|---|
| **FILE** | `20. ... PT. 2.txt` (~9.700 caratteri) |
| **OGGETTO** | Passaggio in rassegna dei cross + gestione + stop. **La lezione che contiene i due numeri che dimostrano la banda.** |

**PARAMETRI CON VALORE**

| voce | valore | citazione | etichetta |
|---|---|---|---|
| 🔑 **Distanza fra i 2 ordini** | **~5 pip**, _"posso stabilire 10 pip"_ | _"sono abbastanza vicini, quindi **circa 5 pip**, anche qua siamo in H4, posso stabilire **10 pip** di distanza"_ | 🟢 chiaro — 🔥 **e' il numero che dimostra che l'entry zone e' una BANDA** (§1.2) |
| Esempio R:R | **17 pip** stop / **17 pip** target = **1:1** | _"ho una distanza di circa **17 pip** al primo livello obiettivo, posso mettere **17 pip** ... rapporto **1 a 1**"_ | 🟢 chiaro — **e' lo stop che il relatore usa DAVVERO** |
| **Primo target** | **la prima entry zone** | _"sai che l'obiettivo e' la prima entry zone, quindi la prima entry zone e' il **primo obiettivo**"_ | 🟢 chiaro |
| Al primo target | **stop in pari + chiudi meta'** | _"Prendi lo stop, lo porti in pari, **chiudi meta' posizione**"_ | 🟢 chiaro, ×2 |
| **Target finale** | **il 100 di Fibonacci** | _"porti fino al **100**, dove **chiuderai tutta la posizione**"_ | 🟢 chiaro, ×2 |
| Media di comodo | **media 14** | _"mettiamo una media 14, la media 14 **non ci da' nessun livello tecnico**"_ | 🟠 provata e scartata in diretta |
| Confluenza | **media 200** sul 100 | _"Fino il 100 che **corrisponde anche alla media** ... potresti anche inserire la **media 200** ... la **concomitanza delle due strategie**"_ | 🟠 **rimando esplicito al modulo Media 200**, senza regola |
| Esempio finale | **71 pip** | _"qua si parla di **71 pip**, 71 pip sono soldi"_ | 🟠 `[dichiarato, NON verificato]` — esempio scelto |
| Ancoraggio del minimo | _"il minimo che completa la chiusura ... **e' il minimo successivo**"_ | | 🟠 **frase rotta, due letture** (SPEC §4.4) |

**MECCANISMI**
- **Ordini rappresentati con linee tratteggiate** prima di piazzarli (didattico).
- **Rassegna in diretta di 4-5 cross** (AUDCAD, "Caggi HF"=CADCHF?/AUDCHF,
  EURJPY): **quasi tutti scartati** per lateralita' o copertura incompleta. 🟢
  **Utile: mostra che il filtro scarta moltissimo** — e conferma indirettamente
  che senza filtro di trend l'EA vede **molti piu' segnali** del corso.
- **Stop: sette metodi** elencati di fila (SPEC §6), chiusi con
  _"tutti i concetti di stop loss ... li abbiamo gia' spiegati ampiamente nelle
  lezioni e nei capitoli precedenti"_.

**REGOLE PROP CITATE:** nessuna. **NUMERI DI PERFORMANCE:** solo il "71 pip".

**BANDIERE ROSSE**
- 🟠 **Nessun esempio perdente** nemmeno qui: chiude con _"71 pip sono soldi"_.
- 🟠 **Gate sull'esperienza** ripetuto: _"quando sarai piu' esperto potrai andare
  anche indietro"_, _"i casi particolari li vedremo nel live trading"_.
- 🟢 Nessuna bandiera del setaccio §4. 🟢 Chiude con il consiglio corretto:
  _"incomincia a esercitarti su un **conto demo** ... allora potrai passare al
  conto reale"_.

**A SCHERMO E NON NEL PARLATO** 🖼️ tutti i prezzi (zero valori assoluti), il Fibo
tracciato, i livelli tecnici indicati col mouse.

**COSA NE COPIAMO** ✅ **la scala dei target** (EZ precedente → 100) · il parziale
50% + BE · **il test-case 5-10 pip fra gli ordini** (che vale come prova della
banda) · lo stop R:R 1:1 **come candidato allo sweep**.

---

## 📊 MODULO MEDIA 200 (lezioni 21-25)

### 📄 SCHEDA 4 — `21. MEDIA 200 PERIODI E L'INSERIMENTO SUL GRAFICO...txt`

| campo | contenuto |
|---|---|
| **FILE** | `21. MEDIA 200 PERIODI...txt` (~12.500 caratteri, **il piu' lungo del corpus**) |
| **OGGETTO** | Tesi, indicatori, timeframe, routine mattutina, filtro di distanza. |

**PARAMETRI CON VALORE**

| parametro | valore | citazione | etichetta |
|---|---|---|---|
| **EMA 200** | **200, esponenziale, su CLOSE** | _"inseriamo **200**, mettiamo **esponenziale**, se non viene di default perche' di default dovrebbe venire semplice, ... l'applichiamo **sul close**"_ | 🟢 **il parametro meglio dettato di tutto il corso** |
| **EMA 14** | primo target | _"ho inserito anche la **media a 14 periodi** ... ti puo' dare un'indicazione di dove poter stabilire il **primo target**"_ | 🟢 chiaro |
| **Timeframe** | **H4/D1**; H1 solo per rifinire | _"H4, daily, weekly e monthly"_ · _"l'H1 ... **gli istituzionali non utilizzano** e io lo utilizzo semplicemente per **migliorare la qualita' dell'ordine**"_ | 🟢 chiaro |
| Ora del giro | **08:00** (_"mi alzo alle 7"_) | | 🟢 chiaro, 🔴 fuso non dichiarato |
| **Distanza prezzo→media** | **50-60-70 pip max** | _"prendo tutte quelle valute che hanno una distanza dalla media di **circa 50 pip, 60 pip, anche 70 pip al massimo**"_ | 🟢 chiaro |
| Esempio accettato | **51 pip** (AUDCAD) | _"abbiamo **51 pip** su AudiCAD di distanza"_ | 🟢 test-case |
| Esempio scartato | **12 pip** (AUDCHF) | _"la distanza e' di circa **12 pip** ... **No, allora passo avanti**"_ | 🟢 test-case |
| Conto d'esempio | **~30.000 EUR** | | 🟢 chiaro |
| Size | _"posso inserire **1,05** ... sto entrando con **50 mila Euro**"_ | | 🔴 **[TRASCRITTO dubbio]**: 50.000/100.000 = **0,50**, non 1,05 (§1.5 n.9) |
| Leva | _"una **leva 1 a 2**, molto bassa"_ | | 🟢 coerente con 0,50 lotti su 30k |

**MECCANISMI**
- **Filtro di distanza** come primo setaccio della mattina, con motivazione:
  _"devo dare spazio ai prezzi di evolversi durante la giornata"_.
- **Doppio timeframe**: H4 per la strategia, H1 per il punto d'ordine.
- 🔑 **Il concetto dell'"arrivo"** compare gia' qui: _"bisogna stare sempre molto
  attenti a **come il mercato arriva sulla media**"_, con AUDUSD che _"tocca la
  media, rimbalza e poi va a bucare"_.

**REGOLE PROP CITATE:** nessuna. **NUMERI DI PERFORMANCE:** nessuno.

**BANDIERE ROSSE**
- 🔴 **CONTRADDIZIONE SUL SEGNO DEL TRADE** (§1.5 n.6): la definizione di
  "segnale di acquisto/vendita" data qui e' un **attraversamento**, opposta al
  rimbalzo che le lez. 22-24 insegnano.
- 🟠 **La tesi "istituzionale" e' un racconto**: _"quando tu versi i soldi in
  banca ... i soldi vengono poi reinvestiti"_ — affermato 5 volte, **mai
  misurato**. Il pezzo difendibile e' un altro: _"piu' riduci il time frame e
  piu' c'e' rumore"_.
- 🟠 **La size "1,05"** non torna con "50 mila euro".
- 🟢 Nessuna bandiera del setaccio §4.

**A SCHERMO E NON NEL PARLATO** 🖼️ il pannello Moving Average · il puntatore che
misura le distanze · il Market Watch · il nome del **broker** (_"stiamo
utilizzando questo broker"_ — **mai pronunciato**, ed e' un **conto reale**).

**COSA NE COPIAMO** ✅ EMA200 esponenziale close · EMA14 · H4/D1 · **filtro di
distanza 50-70 pip con i due test-case (51 ✅ / 12 ❌)**. 🚫 Non copiamo la
definizione di segnale della lez. 21 (contraddice il resto).

---

### 📄 SCHEDA 5 — `22. MEDIA 200 POSIZIONAMENTO DEGLI ORDINI PENDENTI.txt`

| campo | contenuto |
|---|---|
| **FILE** | `22. ... ORDINI PENDENTI.txt` (~10.000 caratteri) |
| **OGGETTO** | Quanti ordini, dove, con quale size. |

**PARAMETRI CON VALORE**

| voce | valore | citazione | etichetta |
|---|---|---|---|
| Ordini | **2** (3 facoltativi) | _"potreste addirittura dividere in tre ordini, ma per ragioni di semplicita' vado a inserire **due ordini**"_ | 🟢 chiaro |
| **Posizione** | 1° sul lato del prezzo, **2° oltre la media** | _"il secondo ... lo vado a inserire **sotto la media in H4**"_ | 🟢 chiaro |
| **Distanza fra i 2** | **~20 pip su H4** | _"la distanza sono circa **20 pip**, perche' **212 sono punti**"_ | 🟢 chiaro ✅ **aritmetica coerente** (212/10 = 21,2) |
| Scala per TF | **10 / 15 / 20** | _"possono essere **10, 15, 20** a seconda del time frame, in H4 **20 pip sono corretti**"_ | 🟢 chiaro |
| Size | **0,50** poi **1,5** | _"abbiamo deciso una size **0,50**"_ · _"metto **1.5**"_ | 🟢 chiaro (⚠️ **esempio, non regola**) |
| Capienza conto | _"posso entrare con **due, tre lotti**"_ | | 🟠 su 30k = leva 6,7-10:1 |
| Scarto per distanza | **120 pip** = troppo lontano | _"se fosse distante **120** molto probabilmente non verrai eseguito"_ | 🟢 chiaro |
| Altro esempio | **40 pip** fra gli ordini = _"molto distanti"_ | | 🟠 contraddice i 20 "corretti"? no: e' un caso mal riuscito, e lo dice |

**MECCANISMI**
- **Ordini lasciati per tutta la giornata** (_"li lascio per la giornata"_) → 🟠
  **implica esposizione fino a fine giornata e oltre: overnight mai affrontato.**
- **Il 2° ordine su un livello tecnico letto in H1** (piu' minimi/massimi
  contrapposti) → 🔴 **non meccanizzabile come detto.**
- **Autocritica utile**: _"avrei potuto metterlo un po' piu' vicino ... **piu'
  distante e' piu' il rischio che tu non venga eseguito con la parte piu'
  importante**"_ → 🟢 il corso riconosce il compromesso.

**REGOLE PROP CITATE:** nessuna. **NUMERI DI PERFORMANCE:** nessuno.

**BANDIERE ROSSE**
- 🟠 **La motivazione dello split e' interamente psicologica** (_"condizionamenti
  psicologici"_, _"per il tuo mindset, per la tua serenita'"_), mai di rischio.
- 🟠 _"nel momento in cui tu sei eseguito su questo tipo di strategia, **sei
  ragionevolmente sicuro** ... che tu ti troverai un bel profitto"_ →
  `[dichiarato, NON verificato]`, **zero numeri**. ⚖️ Attenuante: aggiunge subito
  _"la certezza non c'e' nessuno"_.
- 🟢 Nessuna bandiera del setaccio §4: stop presente, size pre-impegnata.

**A SCHERMO E NON NEL PARLATO** 🖼️ i prezzi degli ordini · i livelli tecnici
indicati col mouse in H1 · lo strumento di misura.

**COSA NE COPIAMO** ✅ due ordini a **20 pip su H4** (10/15/20 per TF) · 2° oltre
la media · size crescente. 🚫 Non copiamo la lettura visiva del livello tecnico.

---

### 📄 SCHEDA 6 — `23. MEDIA 200 REGOLE D'INGRESSO, IDENTIFICAZIONE LIVELLO DI TARGET.txt`

| campo | contenuto |
|---|---|
| **FILE** | `23. ... REGOLE D'INGRESSO...txt` (~10.000 caratteri) |
| **OGGETTO** | 🔑 **Il filtro dell'arrivo sulla media** + i tre metodi di target/stop. **La lezione piu' importante del modulo.** |

**PARAMETRI CON VALORE**

| voce | valore | citazione | etichetta |
|---|---|---|---|
| 🔑 **Filtro d'arrivo (buono)** | **spike nella prima mezz'ora** | _"Se avviene con uno **spike nella prima mezz'ora**, c'e' la probabilita' maggiore che **tocchi il livello e ritorni**"_ | 🟢 concetto chiaro, 🔴 **nessuna soglia** |
| 🔑 **Filtro d'arrivo (cattivo)** | **candela piena senza spike, 2 min dall'apertura** | _"la candela e' **bella piena senza spike** e a **2 minuti dall'apertura** sei in prossimita' della media, allora ... **puoi spostare gli ordini oppure li puoi cancellare**"_ | 🟢 concetto chiaro, 🔴 nessuna soglia |
| Sorveglianza | **ogni fine di candela oraria** | _"ogni fine della candela oraria andare a vedere dove sono i prezzi rispetto alla media"_ | 🟢 chiaro |
| **Target 1** | **EMA 14** | _"il **primo livello di target e' la media 14**, il piu' semplice"_ | 🟢 chiaro |
| **ATR** | **periodo 14** | _"average through range ... con **periodo 14**"_ | 🟢 chiaro |
| Esempio ATR | **0,17 → 17 pip** | _"l'ATR corrisponde a **0.17**, per cui mettero' **17 pip** di stop"_ | 🟠 **[TRASCRITTO dubbio]** sul formato (su 5 decimali l'indicatore mostra 0,00170), 🟢 **i 17 pip sono confermati 4 volte** |
| **SL 2 ATR** | **34 pip** | _"posso pensare di inserire uno stop loss ... a **34 pip**, quindi a **2 ATR** sul timeframe in H4"_ | 🟢 chiaro |
| Giudizio del corso | _"**17 e' poco per un timeframe H4**"_ | | 🟢 → **il corso preferisce 2 ATR** |
| 🔑 **Ancoraggio dello stop** | **sotto l'ULTIMO ordine (il piu' grande)** | _"se prendi un ATR scegli **17 pip sotto l'ultimo ordine**, perche' li abbiamo divisi e **l'ultimo ordine e' l'ordine piu' importante**"_ | 🟢 **la regola di rischio meglio definita** |
| Ancoraggio del target | **dal PRIMO ordine** | _"il portare profitto lo scelgo dal **primo ordine** 17"_ | 🟢 chiaro |
| Metodo alternativo | supporti/resistenze (_"metodo di **Larry Williams**"_) | _"lo tratteremo magari piu' avanti"_ | 🔴 **rimandato, mai spiegato** |

**MECCANISMI**
- **Tenere due grafici della stessa valuta**, H4 e H1, affiancati.
- **Tre strade per target e stop**: EMA14 · ATR (1× o 2×) · S/R → 🟠 **nessun
  criterio di scelta.**

**REGOLE PROP CITATE:** nessuna. **NUMERI DI PERFORMANCE:** nessuno.

**BANDIERE ROSSE**
- 🔴 **Il filtro d'ingresso piu' importante della strategia e' descritto a
  gesti.** "Spike", "bella piena", "con decisione", "con forza": **zero numeri**.
  ⚖️ **Ma e' pienamente quantificabile da noi** (§1.10) — la forma della regola
  c'e' tutta.
- 🟠 **"Metodo di Larry Williams" citato e rimandato** — stesso buco gia'
  annotato in `docs/live_emiliano/CATALOGO_STRATEGIE_CORSO.md` (_"manca il
  materiale 'punte di Larry'"_). **Secondo modulo che ci sbatte contro.**
- 🟢 Nessuna bandiera del setaccio §4.

**A SCHERMO E NON NEL PARLATO** 🖼️ 🔴 **gli esempi grafici di "spike" e "candela
piena"** — sono **il** materiale che serve per calibrare le due soglie.

**COSA NE COPIAMO** ✅ **la forma del filtro d'arrivo** (da quantificare) ·
EMA14 come target 1 · ATR14 · SL 1-2 ATR **sotto l'ordine piu' grande** · TP
**dal primo ordine**.

---

### 📄 SCHEDA 7 — `24. MEDIA 200 GESTIONE DELL'OPERAZIONE, OBBIETTIVI DI TARGET E STOP LOSS.txt`

| campo | contenuto |
|---|---|
| **FILE** | `24. ... GESTIONE DELL'OPERAZIONE...txt` (~9.500 caratteri) |
| **OGGETTO** | Gestione, break-even, trailing manuale. **La lezione col test-case numerico completo.** |

**PARAMETRI CON VALORE — l'esempio AUDCAD, aritmetica verificata**

| voce | valore | citazione | etichetta |
|---|---|---|---|
| Livello di stop individuato | **0,89906** | _"sul livello che abbiamo identificato, **089906**"_ | 🟢 chiaro |
| **SL piazzato** | **0,89890** | _"lo metterei a **089890**"_ | 🟢 chiaro (**1,6 pip sotto** — regola del numero tondo) |
| **TP piazzato** | **0,90556** | _"lo piazzero' a **090556**"_ | 🟢 chiaro |
| Base del calcolo | **2 ATR** | _"proviamo a immaginare che abbiamo stabilito i **2 ATR**"_ | 🟢 chiaro |
| ATR su **D1** | **78 pip** | _"vado a calcolarmi la [A]TR che corrisponde a **78** ... perche' siamo in un timeframe **daily**"_ | 🟢 chiaro |
| ATR (altro es.) | **33 → 2 ATR = 66** | _"se leggo 33 metto 33 ... se faccio 2 [A]TR sono **66**"_ | 🟢 chiaro |
| Gestione | **1 ATR → chiudi meta' + BE → corri a 2 ATR** | _"a una [A]TR **liquidare meta' posizione e portare lo stop in pari** e far correre l'operazione al secondo obiettivo dei due ATR"_ | 🟢 chiaro |
| Sorveglianza | **2ª-3ª ora della candela** | _"presta attenzione soltanto verso la **seconda o la terza ora** delle candele"_ | 🟢 chiaro |
| Numeri tondi | si evitano | _"il numero tondo e' una **soglia psicologica**"_ | 🟢 chiaro |

🧮 **VERIFICA ARITMETICA (nostra, e TORNA):**
```
entry ~ SL + 2 ATR = 0,89890 + 0,00340 = 0,90230
TP - entry = 0,90556 - 0,90230 = 0,00326 = 32,6 pip  ~  2 ATR (34)
```
✅ Coerente entro **1,4 pip** con la sua stessa regola (_"lo metto leggermente
sotto il livello obiettivo"_). **R:R ~1:1, simmetrico a 2 ATR.**
➡️ **E' il test di regressione migliore prodotto da tutto il corso finora.**

**MECCANISMI**
- **Stop e TP inseriti direttamente sull'ordine** (_"in macchina"_): 🟢 stop
  **vero** al broker, non virtuale.
- **Trailing manuale**: _"lo sposto nella parte inferiore della candela"_ →
  🟠 meccanizzabile, ma **non e' detto su quale TF**.
- 🟠 **Spostamento degli ordini** _"se i prezzi arrivano con forza"_ (§1.6 n.4).
- 🔴 **Umano nel ciclo esplicito**: _"la piattaforma MT4 ha un'applicazione sul
  cellulare dove **ogni ora** ... vado a vedere l'operazione"_.

**REGOLE PROP CITATE:** nessuna. **NUMERI DI PERFORMANCE:** nessuno.

**BANDIERE ROSSE**
- 🟠 **Lo spostamento degli ordini** allontana il livello di invalidazione, senza
  soglia sul grilletto (⚖️ ma sono **pendenti**, non posizioni: non e' un
  allargamento di stop).
- 🟠 **Umano nel ciclo per progetto** — incompatibile con un EA senza tradurre
  le regole in soglie.
- 🟢 Nessuna bandiera del setaccio §4. 🟢 **Ottima igiene**: stop e TP sempre
  agganciati all'ordine.

**A SCHERMO E NON NEL PARLATO** 🖼️ il grafico dell'esempio (cross confermato
AUDCAD, **data mai detta**) · gli esempi di spike/candela piena · il pannello
di modifica ordine.

**COSA NE COPIAMO** ✅ **il test-case numerico completo** · 1 ATR → parziale +
BE → 2 ATR · TP/SL leggermente prima dei livelli tondi. 🚫 Non copiamo trailing
manuale, controllo dal cellulare, spostamento "con forza".

---

### 📄 SCHEDA 8 — `25. STRATEGIA BREAKIN BREAKOUT MEDIA 200.txt`

| campo | contenuto |
|---|---|
| **FILE** | `25. STRATEGIA BREAKIN BREAKOUT MEDIA 200.txt` (**3.608 caratteri — il piu' corto**) |
| **OGGETTO** | 🆕 **Una SECONDA strategia, non una variante.** Segno opposto al rimbalzo. |

**PARAMETRI CON VALORE**

| voce | valore | citazione | etichetta |
|---|---|---|---|
| 🔑 **Trigger** | la candela **successiva** alla violazione **APRE** oltre la media | _"la **modalita' operativa e' l'apertura della candela sopra la media 200 per una direzione buy** o l'apertura della candela sotto la media 200 per una direzione sell"_ | 🟢 **il trigger piu' pulito di tutte e 8 le lezioni: binario e oggettivo** |
| Qualita' della violazione | candela **ampia, piena, senza spike, chiude sui massimi** | _"la forza viene espressa dalla **volatilita'**, quindi dall'**ampiezza della candela** ... molto piena **senza spike** ... **chiude sui massimi**"_ | 🟠 quantificabile da noi |
| Contesto | **3 minimi** = inversione | _"**tre minimi sono una condizione di inversione**"_ | 🟠 **una volta sola**, nessuna tolleranza |
| Size 1 | **piccola**, all'apertura della candela | | 🟢 chiaro |
| Size 2 | **grande**, pendente **sul retest della media** | _"inseriro' la **parte piu' importante** sopra la media **nel retest della media**"_ | 🟢 **chiaro ed elegante: il grosso entra al prezzo migliore** |
| Scala della size | piu' lontana l'apertura, meno si entra | _"piu' e' distante e piu' entrerai con poco"_ | 🔴 **nessuna scala** |
| **Stop** | **ATR sotto l'ultimo ordine** (es. **25 pip**) | _"se l'ATR e' di **25 pip**, inseriro' **sotto l'ultimo ordine** 25 pip"_ | 🟢 chiaro |
| Stop alt. | sotto il livello dei minimi multipli (_"1, 2, 3, 4 volte che arriva su questo livello"_) | | 🟢 chiaro |
| Gestione | 1 ATR → meta' + stop in pari | | 🟢 chiaro |
| 🔴 **Target** | _"il primo naturale obiettivo del prezzo e' **sempre la media**"_ | | 🔴 **INCOERENTE** (§1.5 n.7): si e' appena rotta la media, che sta **dietro**. Frase copiata dal modulo del rimbalzo → **da scartare** |

**MECCANISMI**
- **Il rischio trasformato in ingresso**: _"il rischio lo trasformiamo in
  un'**opportunita'**, inserendo una size all'ingresso dell'apertura della
  candela ... poi inseriro' la parte piu' importante sopra la media nel
  **retest**"_ `[TRASCRITTO]` → 🟢 **struttura sana**: piccola sul momentum,
  grande sul pullback, stop unico oltre entrambi.

**REGOLE PROP CITATE:** nessuna.

**NUMERI DI PERFORMANCE:** 🔴 _"e' una strategia **molto solida, statisticamente
provata**, che utilizziamo tutti i giorni in live"_ — `[dichiarato, NON
verificato]`, **zero numeri**. E' la frase di chiusura del modulo.

**BANDIERE ROSSE**
- 🔴 **"Statisticamente provata" senza una sola statistica.**
- 🔴 **Il target incoerente** (vedi sopra).
- 🟠 **3.608 caratteri per una strategia intera**: e' un accenno, non una
  lezione. Molte regole sono rimandate a _"gia' spiegato ampiamente"_.
- 🟢 Nessuna bandiera del setaccio §4.

**A SCHERMO E NON NEL PARLATO** 🖼️ **tutto l'esempio grafico** (cross, date,
prezzi: **niente**) · l'ATR a schermo · i tre minimi indicati col mouse.

**COSA NE COPIAMO** ✅ **il trigger (apertura oltre la EMA200) — e' materia
nuova e testabile senza assunzioni** · lo stop ATR sotto l'ultimo ordine ·
l'ingresso piccolo sul momentum + grande sul retest.
🚫 **NON copiamo il target "sempre la media"** (incoerente).

---

# PARTE 3 — 🗑️ GLI SCARTI

**Nessuna delle 8 trascrizioni e' stata scartata.** Tutte hanno prodotto almeno
un parametro con valore. La piu' povera e' la **25** (3.608 caratteri) — ma e'
proprio quella che porta la **materia nuova**, quindi non e' uno scarto.

### ❌ Cosa NON c'e' in NESSUNA delle 8 trascrizioni (e che era lecito aspettarsi)
- ❌ **Una percentuale di rischio per operazione** — in nessuno dei due moduli
- ❌ **Un solo numero di backtest** (N operazioni, win rate, drawdown, periodo,
  broker). L'unica cifra e' l'**"80-85%"** nudo del Fibo
- ❌ **Un solo esempio di operazione PERDENTE**, raccontato per intero
- ❌ Qualunque menzione di **correlazione** fra i cross scansionati
- ❌ Qualunque menzione di **prop firm**, drawdown giornaliero, tetto posizioni
- ❌ Qualunque menzione di **spread** o costi (accennato una volta e subito
  archiviato: _"al limite pagherai le commissioni ovviamente"_)
- ❌ **Il fuso orario della piattaforma**, in entrambi i moduli
- ❌ **Indici e materie prime**: entrambi i moduli sono **solo forex**
- ❌ Il **nome del relatore** e il **nome del broker** (conto reale a schermo)

---

# 📎 APPENDICE — INDICE DELLE CONSEGNE

| file | contenuto |
|---|---|
| `backtest_pipeline/prove/FIBOH4_CORSO_SPEC.md` | 📐 **spec implementabile Fibo H4** — 34 decisioni, geometria derivata, 6 divergenze col codice, 8 assunzioni da dichiarare |
| `backtest_pipeline/prove/MEDIA200_CORSO_SPEC.md` | 📊 **spec implementabile Media 200** — 33+11 decisioni, **confronto punto per punto con `ABTG_EMA200`** (§11), test-case AUDCAD verificato |
| **questo file** | sintesi incrociata + 8 schede + scarti |
| `.../trascrizioni_corso_2026-08-18/modulo_fiboh4/` · `/modulo_media200/` | le 8 trascrizioni (fonte) |
| `caccia_strategie/ANALISI_CORSO_BREAKOUT_2026-08-18.md` | il referto gemello sul **modulo Breakout** (lez. 34-40) |
| `mql5/Experts/ABTG_FiboH4_Multi.mq5` | il codice confrontato — **6 divergenze** |
| `mql5/Experts/ABTG_EMA200.mq5` | la **sedia 12**, R29 30/30 — **12 differenze col corso** |
| `backtest_pipeline/risultati_archivio/REFERTO_CODA_FASCIA_B.md` | il **0/8 del FiboH4** che questo referto rimette in discussione |
| `backtest_pipeline/risultati_archivio/REFERTO_ROUND29_EMA200_WF.md` | il **30/30 dell'EMA200** su Dow H1 |
| `report/METRO_PROP.md` §2 §3 §7 | le regole prop toccate (daily loss, overnight/weekend, news) |
| `docs/live_emiliano/CATALOGO_STRATEGIE_CORSO.md` | il censimento del 12/08 che gia' collegava "Media 200 (Paolo)" a `ABTG_EMA200` |
