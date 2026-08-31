# 🎙️ ANALISI LIVE EMILIANO (FTD/ABTG) — 31/08/2026, mattina (08:30)

**Data referto:** 31/08/2026 · **Analista:** estrattore trascrizioni
**Mandato:** estrarre OGNI valore, OGNI meccanismo, OGNI regola. **Non riassumere.**
**Fonte unica:** la trascrizione TurboScribe caricata da Claudio
(`0d96c7ed-LIVE_EMILIANO_31.08.26_20260831_083032752.txt`). Niente memoria,
niente web, niente "completamento" dei buchi.

> ⛔ **REGOLA CHE VALE SOPRA TUTTO: nessun parametro della flotta si muove da
> questo materiale.** Referto di **LETTURA**. In chiusura: **nessuna azione sul
> forward.** 🔒 Nessun file di EA, nessun `.set`, nessun `.ini` toccato: qui i
> sorgenti sono stati solo **letti**.

**Etichette:** `[TRASCRITTO chiaro]` = c'è scritto e il contesto lo conferma ·
`[TRASCRITTO dubbio]` = lo speech-to-text ha quasi certamente storpiato ·
`[INFERITO]` = lo deduco da più passaggi, e dico quali · `[INCERTO]` ·
`[DICHIARATO, NON VERIFICATO]` = numero o statistica del relatore.

---

## 0. 🗂️ IL FILE — che cos'è davvero

| Voce | Dato |
|---|---|
| File | `0d96c7ed-LIVE_EMILIANO_31.08.26_20260831_083032752.txt` |
| Dimensioni | **55.365 byte · 9.159 parole · 51 righe** |
| ⚠️ Struttura | 🔴 **La riga 51 da sola è 47.621 caratteri = l'86% dell'intero file**, un unico blocco senza punteggiatura di paragrafo. Ci sta dentro TUTTO: il corso macro, l'avvertimento sugli ordini pendenti, l'analisi oro, l'analisi DAX, l'operatività, la gestione. Le citazioni da lì sono marcate **`r.51 (blocco unico)`** |
| Lettura | **Integrale, 51/51 righe** (compreso il blocco unico) |
| Relatore | **EMILIANO** — `[INFERITO]`, non è mai chiamato per nome nel testo, ma: parla in prima persona del "conto piccolo… i soliti 20 mila", cita "la lezione che faccio all'università", dice _"la prima interazione da quando sono uscito dall'ospedale"_ (r.51) — **coerente con la scheda del 24/08** (`caccia_strategie/ANALISI_LIVE_EMILIANO_2026-08-24.md`: "Emiliano assente per intervento") e con la serie 27-28/08 |
| Ospite | **GIACOMO / "Giacomino"** — r.1-45, intervento tecnico su **MT5 + intelligenza artificiale** `[TRASCRITTO chiaro]` |
| Presenti citati | Leonardo, Giuseppe, Salva, Daniela (Paschi), Roberto, Giuliano, Pasquale, Luca — `[TRASCRITTO]`, grafie incerte |
| Formato | Live Zoom: **(A)** demo MT5-AI di Giacomo (r.1-45) · **(B)** apertura del **percorso di MACROECONOMIA APPLICATA** (r.47-51) · **(C)** analisi multi-TF su ORO e DAX con operatività in diretta (r.51) |
| 🕐 Timestamp nel nome file | `20260831_083032` → `[INFERITO]` live delle **08:30 del 31/08**. **Il fuso di quel timestamp non è dichiarato da nessuna parte. Non lo converto.** |
| Partecipanti | _"siamo in 1981"_ (r.5) — `[TRASCRITTO dubbio]`: quasi certamente **198** o **1.981** iscritti/collegati, oppure un'ora. **Non usabile.** Poi _"c'è meno 85"_ (r.13), illeggibile |

---
---

# ⭐ PARTE 1 — LA SINTESI INCROCIATA (la pagina da leggere per prima)

## 1.1 🏆 LE TRE COSE CHE VALGONO DAVVERO

### 🥇 1. L'AVVERTIMENTO SUGLI ORDINI PENDENTI NEI RILASCI — vale per NOI, subito, e non è un'opinione di mercato: è una descrizione di microstruttura

> _"il problema è che sui dati **il book di negoziazione**… noi sul forex
> vediamo **esclusivamente il primo livello**… non abbiamo ad esempio le
> quantità su tutti i livelli, sui 10 livelli, 20 livelli come ne abbiamo sui
> futures. **Poco prima del rilascio del dato questi livelli si svuotano**,
> cioè **viene tolta la liquidità**… **potrebbe filarti l'ordine** che tu hai
> messo a un determinato prezzo e **potrebbe eseguirlo addirittura molto
> distante dal tuo livello di ingresso**… perché **qua non c'è liquidità** e
> quindi il primo ordine va a mercato, **l'ordine pendente viene mandato a
> mercato dal broker ma non trova niente** e la prima quantità che soddisfa
> quel prezzo la trova molto distante. **Questo è il rischio sui non-farm
> payroll, spesso succede sui CPI**"_ — r.51 (blocco unico) `[TRASCRITTO chiaro]`

🔴 **Perché ci riguarda in modo diretto e misurabile: 36 dei nostri 97 EA in
`mql5/Experts/` piazzano ORDINI PENDENTI STOP** (`ORDER_TYPE_BUY_STOP` /
`SELL_STOP` — verificato con grep, non a memoria), e **le sedie in forward non
hanno filtro news** (R101: news OUT per criterio; `DOSSIER_NEWS_FILTER_2026-08-21.md`).
Il meccanismo che descrive è **esattamente la coda a sinistra** che
`report/METRO_PROP.md` §G3.2 cerca di beccare:

> _"se il misurato **supera** il teorico → gap/slippage oltre lo stop"_ (METRO_PROP r.410)

➡️ **NON è una modifica. È un rafforzamento della corsia prop-hardening già
aperta**: lo stress-slippage del collaudatore ha ora una **motivazione di
microstruttura dichiarata da un professionista**, e un **elenco di eventi
nominati**: **NFP e CPI**. E si aggancia alla domanda già scritta in
METRO_PROP §7 (_"`ABTG_DAX_Apertura_EU` entra alle 08:00 server in punto…
i comunicati tedeschi delle 08:00 lo sono [news]. **Da chiarire.**"_).
📌 Terzo indizio indipendente della stessa cosa dopo Paolo 24/08
("il doppio dello stop" preso in diretta su candela news del DAX).

---

### 🥈 2. LA GESTIONE "CHIUDI IL PRIMO PEZZO → STOP A PARI" — e NOI CE L'ABBIAMO GIÀ NEL CODICE

> _"chiudo la prima… perché così **posso gestirmi l'operazione a rischio di
> zero**, porto sullo stop… **se torno indietro io lo stop lì pari e non perdo
> niente, posso solo guadagnare**"_ — r.51 `[TRASCRITTO chiaro]`
> (nel testo "stop li pari" / "sullo score alla" = **stop a pari / breakeven**,
> `[TRASCRITTO dubbio]` sulla grafia, **chiaro nel senso**)

✅ **VERIFICA NEL SORGENTE (non a memoria):** `mql5/Experts/ABTG_Apertura_3Ingressi.mq5`
riga **316**:
`input bool InpBreakevenAtTP1 = true; // Sposta stop in pari dopo la parziale`
e riga **2216**: `// Gestione posizione: parziale al 1o target, breakeven, trailing`.
**È letteralmente la stessa regola, già implementata, già con lo stato
per-ticket** (r.2241: _"parziale + breakeven + trailing, con stato PER-TICKET"_).

➡️ **Niente da adattare. Convergenza pura: quello che lui insegna a mano, noi
lo eseguiamo in automatico.** ⚠️ Attenzione a NON confondere: il "3 Ingressi"
del nostro EA è un **duello fra TRE STILI di ingresso** (STOP / LIMIT sul
retest / MARKET, r.256), **non** tre ordini scalati come i suoi tre livelli.

---

### 🥉 3. LA REGOLA DELL'ERRORE DI ESECUZIONE — un meccanismo di protezione, non una bandiera

Emiliano entra **in direzione sbagliata per errore di click**, in diretta:

> _"sono entrato **involontariamente in sello** [= sell]… cosa ho combinato…
> **la mia regola dice: hai sbagliato, hai cliccato involontariamente, non so
> cosa hai fatto, ma sei entrato in una posizione diversa dal tuo piano** …
> **la mia regola mi impone di [chiudere] l'operazione anche se io ho una
> perdita di 15 euro**… **quello che faccio io lo dovete fare anche voi**"_
> — r.51 `[TRASCRITTO chiaro]` sul senso, `[TRASCRITTO dubbio]` su "sello"/"di più"

🟢 **Questo va nella colonna dei MECCANISMI, non delle bandiere.** È una regola
di igiene: **posizione non prevista dal piano = chiusura immediata, costi quel
che costi (15 €).** È la stessa filosofia del nostro **cancello A1**
(`InpMaxPosSimbolo`, r.253 di `ABTG_Apertura_3Ingressi.mq5`): non si convive
con una posizione che il piano non ha previsto. Anche per un EA: **un ticket
orfano/inatteso non si "lascia lavorare".**

---

## 1.2 📊 TABELLA DI CONVERGENZA (e l'avvertenza che la ridimensiona)

> 🚨 **AVVERTENZA DI CASA, PRIMA DEI NUMERI:** le live del **27/08, 28/08 e
> 31/08 sono lo STESSO relatore, sullo STESSO corso**. **Sono UNA fonte, non
> tre.** La ripetizione qui misura la **coerenza interna del relatore**, non
> l'indipendenza delle fonti. L'unica convergenza che vale come surrogato di
> verifica è quella con **le nostre misure** (colonna a destra).

| Parametro / regola | 27/08 (Emiliano) | 28/08 (Emiliano) | **31/08 (questa)** | Paolo (24-25/08) | 🧪 **NOSTRA MISURA** |
|---|---|---|---|---|---|
| **Volumi come conferma di rottura** | ✅ | ✅ ("solo da H1 in giù") | ✅ _"se non c'è l'incremento di volumi lui rompe e torna indietro"_ | ✅ | 🟢 **R101: `02_volumi` unico filtro sopravvissuto a G1+G2+G3** |
| **Retest come conferma** | ✅ | ✅ | ✅✅ _"il retest mi dà **la certificazione** che questa è un'area importante"_ | ✅ | 🟢 **geometria RETEST già nostra** (`InpEntryMode=1`, r.256) |
| **Pre-section = laterale dove il prezzo è stato più a lungo** | ✅ | ✅ (definizione + M15) | ✅ _"zona di liquidità dove lui si è fermato per più tempo, quindi diventa una zona importante"_ | — | 🔴 **rilevatore di pre-section NON esiste da noi** (spunto S4 del 28/08, ancora aperto) |
| **Analisi multi-TF obbligatoria** | ✅ | ✅ ("2 usi: livelli + pre-section") | ✅ **catena esplicita M(onthly)→W→D→H4→H1→M15** | ✅ (teorema 3 TF) | 🟡 nostre sedie: **TF singolo** + qualche filtro TF superiore |
| **Numeri tondi / livelli psicologici** | ✅ (26.300) | — | ✅ _"guardate dove si ferma: **numero tondo**"_ · _"i prezzi sono vicini al numero tondo"_ | — | 🔴 **mai misurato da noi** |
| **Livello valido solo con massimi/minimi CONTRAPPOSTI** | 🟡 | 🟡 | ✅✅ **regola esplicita e negativa**: _"**non invento, non traccio**"_ | — | 🔴 non meccanizzato |
| **Stop a pari dopo la parziale** | — | — | ✅ | ✅ | 🟢🟢 **`InpBreakevenAtTP1=true` GIÀ NEL CODICE** |
| **Slippage/ordini pendenti sulle news** | — | — | ✅✅ **spiegazione di microstruttura + NFP/CPI nominati** | ✅ ("il doppio dello stop", 24/08) | 🟡 **corsia prop-hardening aperta** (METRO_PROP G3.2, §7) |
| **Price action > indicatori** | ✅ | ✅✅ | ✅ _"lasciate stare che ci sono diverse configurazioni… **io lavoro così oggi con voi, senza niente**"_ (toglie tutto, lascia volumi + separatore di periodo) | 🔴 **contrario** (Supertrend) | — |

## 1.3 ⚔️ CONTRADDIZIONI — dentro la stessa live e con le precedenti

| # | Contraddizione | Le due citazioni | Peso |
|---|---|---|---|
| **X1** | 🔴 **Ordini pendenti sì / no**, a 20 righe di distanza | _"vado a mettere gli ordini pendenti e vi vado a mettere questo"_ ⟷ _"**io non metto gli ordini pendenti** e la motivazione che vi do… nel momento in cui il mercato arriva su quel livello **sto attento**"_ (entrambe r.51) | 🔴 **ALTO.** Il metodo di ingresso non è deciso nemmeno per lui. Non se ne ricava una regola |
| **X2** | 🔴 **Opera CONTRO il proprio protocollo, dichiarandolo** | _"vi ho detto **mantenete il protocollo** eccetera… **il protocollo dice** se hai il long o short nella giornata, e il DAX in giornata è **short**, quindi tendenzialmente **rispetto al protocollo l'operazione non si dovrebbe fare**"_ → e poi entra **long** | 🔴 **ALTO.** Vedi bandiera **B2** |
| **X3** | 🟡 **In quanti pezzi si divide l'ordine** | _"la mia size da 20 **la divido in 4**"_ ⟷ _"**lo divido in tre ordini**"_ ⟷ _"il terzo ordine è quello che mi permette di pestarlo di più"_ | 🟡 **MEDIO.** Il numero di pezzi non è un parametro: è a sensazione |
| **X4** | 🟡 **Direzione dell'oro** | _"sembra più long, diciamo che è long"_ ⟷ _"**io l'oro non direi che è long, io non lo direi che è long, io non direi che è long**"_ (ripetuto 3 volte) ⟷ poi _"cerco long, cerco long"_ | 🟡 Legittimo (trend di fondo vs micro-struttura), ma **il risultato in trascrizione è illeggibile** |
| **X5** | 🟢 **Rispetto al 28/08 sui volumi** | 28/08: _"i volumi si guardano dall'H1 in giù"_. Oggi guarda i volumi **in M15 e H1** ✅ e dice _"il monthly… io lo guardo **esclusivamente per tirare due righe** supporto e resistenza"_ | 🟢 **COERENTE**, nessuna contraddizione |

## 1.4 🚩 LE BANDIERE — quattro, e una sola è rossa piena

| # | Bandiera | La citazione che la prova | Colore |
|---|---|---|---|
| **B1** | 📣 **"Algoritmo predittivo sulle valute" REGALATO all'evento di Rimini** — **zero numeri**: nessun win rate, nessun campione, nessun backtest, nessuna metodologia | _"vi farò, spero di farvi **il regalo dell'algoritmo, quello predittivo sulle valute**, quindi è un **lavoro pazzesco**, nel momento in cui saremo [a] Rimini… però lì è un modo per presentarlo"_ (r.51) | 🚩🚩 **ROSSA — marketing.** Un algoritmo "predittivo" annunciato senza **una singola metrica** non è materiale valutabile. Si archivia, non si aspetta |
| **B2** | ⚠️ **Viola il proprio protocollo in diretta** (X2) e lo dice ad alta voce agli allievi | vedi X2 | 🚩 **AMBRA-ROSSA.** L'incoerenza fra piano dichiarato ed esecuzione è **il rischio n.1 di una challenge**. Da noi il piano lo esegue il codice, non la mano: **è un punto a favore dell'automatismo** |
| **B3** | ⚠️ **Vuole ALZARE la leva perché il margine "immobilizza"** | _"adesso **la leva la voglio un po' più alta** perché il margine che viene tenuto è quasi di **2000 euro**, cioè **non posso muovermi** per un po' se faccio 10 contratti"_ (r.51) | 🚩 **AMBRA.** Ragionamento di **margine**, non di rischio. Su un conto da 20k, 10 contratti DAX con SL "sotto il canale" è **fuori dal metro di casa** (0,65%/sedia, cap aperto 3,25%). **Si registra, non si imita** |
| **B4** | ⚠️ **Ingresso scalato su 3 livelli = MEDIAZIONE (non martingala)** | _"metto gli ordini… primo livello, secondo livello… **il terzo ordine è quello che mi permette di pestarlo di più con 10 contratti**"_ · _"il mio stop è qua sotto"_ (r.51) | 🟡 **AMBRA CHIARA.** ⚠️ **È aggiunta di size a prezzi peggiori** → per definizione è **averaging/mediazione**. **NON è martingala** (nessun raddoppio dopo una perdita chiusa) e **NON è recovery/griglia** (c'è **UNO stop unico sotto il canale** per tutti i pezzi). Ma **molte prop mettono averaging e grid nella stessa riga di divieto**, e `METRO_PROP` r.535 dichiara che su The5ers/FundingPips/E8/Alpha **non sappiamo** cosa dicono di grid/martingala/averaging: **buco aperto** |
| ✅ | **ASSENTI:** martingala vera, recovery, griglia, no-stop-loss, trucchi anti-prop, copy-trading mascherato, randomizzazione | — | 🟢 **Ricerca fatta sull'intero file: NIENTE di tutto questo.** Lo stop c'è sempre ed è dichiarato prima dell'ingresso |

---
---

# 📋 PARTE 2 — LA SCHEDA

```
FILE            0d96c7ed-LIVE_EMILIANO_31.08.26_20260831_083032752.txt
RELATORE        EMILIANO [INFERITO] + ospite GIACOMO [TRASCRITTO chiaro]
CANALE          Live mattutina del corso (FTD/ABTG) — Zoom, 08:30
OGGETTO         (A) MT5 + AI Assistant/MCP · (B) apertura corso MACRO applicata
                (C) analisi multi-TF ORO + DAX con operatività reale in diretta
```

## §A — 🤖 MT5 + INTELLIGENZA ARTIFICIALE (Giacomo, r.1-45)

### A.1 Cosa dicono ESATTAMENTE

| # | Affermazione | Citazione testuale | Etichetta |
|---|---|---|---|
| A1 | **MT5 ha introdotto l'AI da poco; è il terzo aggiornamento, "circa un mesetto"** | _"la MetaTrader ha inserito, **è il terzo aggiornamento che fanno, quindi circa un mesetto**, la possibilità di collegarci direttamente le intelligenze artificiali"_ (r.15) | `[TRASCRITTO chiaro]` · 🔬 **NON VERIFICATO DA NOI** (nessuna navigazione) |
| A2 | **Si apre da un tasto nel terminale** | _"tramite **questo tasto qui** che voi vedete, si apre **l'assistente AI integrato**"_ (r.15) | `[TRASCRITTO chiaro]` · 🕳️ **quale tasto, dove: A SCHERMO, NON DETTATO** |
| A3 | 🏆 **PERCORSO DI CONFIGURAZIONE — l'unico dato veramente riutilizzabile** | _"il settaggio da fare… è andare in **strumenti → opzioni** e andare su **AI Assistant**, dove vi chiedono **le API, ovvero le chiavi di connessione**"_ (r.17) | `[TRASCRITTO chiaro]` · ✅ **verificabile da Claudio in 10 secondi sul terminale** |
| A4 | **Provider citati** | _"quindi **QNAN, Tropic, DeepSeek**, per dirvene una, c'è anche la parte di **NVIDIA** che ha dei modelli interessanti, **oppure tramite MCP**"_ (r.17) | 🟡 `[TRASCRITTO dubbio]` — **"QNAN" = Qwen** `[INFERITO]`, **"Tropic" = Anthropic** `[INFERITO]` (più avanti dice _"io uso solo Cloud"_ = **Claude**). DeepSeek e NVIDIA `[TRASCRITTO chiaro]` |
| A5 | **API = una stringa lunga "48 o 50 cifre"** | _"vi dà **una stringa di codice che di solito sono 48 o 50 cifre**, adesso non mi ricordo esattamente, e gli andate a dire dopo anche **il modello**"_ (r.19) | 🟡 `[TRASCRITTO dubbio]` sul numero — lui stesso dice "non mi ricordo esattamente". **Numero da NON usare** |
| A6 | 🔑 **API = CREDITI A PAGAMENTO, ≠ abbonamento** | _"**richiede crediti e quindi soldi**… **richiede che il credito venga utilizzato, non va sul piano di abbonamento che avete**… **non è che comprate l'abbonamento e potete utilizzare le API**"_ (r.19) · _"io uso solo Cloud e **Cloud lo mette a pagamento**"_ (r.21) | `[TRASCRITTO chiaro]` · ✅ **distinzione corretta e importante** |
| A7 | 🏆 **MCP = server LOCALE, niente cloud, niente chiavi, niente crediti** | _"**L'MCP vi permette di non utilizzare le chiavi API** ma collegarlo direttamente, ed è come se l'intelligenza artificiale **leggesse i dati all'interno della MetaTrader senza esserci collegata**. Praticamente **è un server che gira in locale sul vostro PC, quindi i dati non sono in cloud, non ci sono chiavi, non c'è niente, e non vi utilizza crediti**"_ (r.21) | `[TRASCRITTO chiaro]` — descrizione **coerente** con cos'è un MCP. 🔬 **Che ESISTA un MCP ufficiale MetaQuotes: NON VERIFICATO** |
| A8 | 🏆 **In Claude gli MCP si chiamano "CONNETTORI"** | _"**Cloud non si chiama MCP, ma li chiama connettori**"_ (r.29) · _"Li trovate nella voce **personalizza**… **eccoli qua, connettori**. **Mi hanno cambiato l'interfaccia**"_ (r.31-35) | `[TRASCRITTO chiaro]` · ⚠️ **lui stesso sbaglia il percorso in diretta** (_"no, ho sbagliato, perdonate, mi sono confuso"_, r.33) e dichiara che **l'interfaccia è cambiata** → **percorso a scadenza, non un dato stabile** |
| A9 | **Procedura: Aggiungi → nome (es. "mt5") → URL** | _"voi fate **aggiungi**, gli date **il nome che volete, tipo mt5**… **andate a prendere l'URL che è questo**"_ (r.35-37) | 🔴 `[TRASCRITTO]` ma **L'URL È A SCHERMO E NON È MAI DETTATO** → 🕳️ **buco n.1 da chiedere a Claudio** |
| A10 | 🔴🏆 **IL VINCOLO CHE CONTA: funziona SOLO con l'app desktop installata sul PC dove c'è MT5** | _"e **funzionerà solo però su Cloud installato sulla MetaTrader, cioè sul PC. NON funziona in Cloud** [= nella versione web], quindi voi dovete utilizzare **l'applicazione di Cloud all'interno del computer, sennò non vi funziona**"_ (r.37) | `[TRASCRITTO chiaro]` sul senso; `[TRASCRITTO dubbio]` sulla resa ("Cloud"=Claude, e il secondo "in Cloud"=nel browser/web) · **`[INFERITO]` dal contesto: server MCP locale → il client deve stare sulla stessa macchina.** Coerente con A7 |
| A11 | 🔴 **LA DEMO NON HA FUNZIONATO IN DIRETTA** | _"**È bello che la diretta, non si connette. Devo capire come mai.**"_ (r.39) | `[TRASCRITTO chiaro]` · 🚩 **Nessuna funzionalità è stata VISTA funzionare.** Tutto ciò che segue è **descritto, non dimostrato** |
| A12 | **Funzioni promesse** | _"analizzare **l'esposizione del portafoglio**"_ · _"**leggere i dati sul grafico**"_ (r.15) · _"**avete tre ordini su euro-dollaro e vi dice: attenzione che sei sovraesposto** su euro-dollaro… **c'è il rischio di rischiare troppo rispetto al conto**"_ (r.41) | `[DICHIARATO, NON VERIFICATO]` — **esempio verbale, non mostrato** (vedi A11) |
| A13 | **Documento promesso** | _"vi faccio **un breve documentino** su tutta la parte relativa all'**ISO 93**"_ (r.29) → `[TRASCRITTO dubbio]`, quasi certamente **"MCP"** storpiato · _"lo mando nelle **comunicazioni importanti**"_ (r.45) | 📌 **Da recuperare quando esce: sarà più affidabile del parlato** |
| A14 | Contorno, non azionabile | _"CiaGPT ha migliorato molto"_, _"è uscita la nuova [AI] cinese… è quella di Alibaba"_, _"**Perflexity** è molto bello, per le ricerche è ottimo"_, sondaggio in chat: _"**la maggior parte utilizzano Cloud e CiaGPT**"_ (r.23-27) | 🟢 **SCARTO** — chiacchiera sui modelli, nessun valore operativo |

### A.2 ⚖️ COSA SIGNIFICA PER NOI — la posizione di casa, scritta nero su bianco

> ### 🔴 **IL NOSTRO FLUSSO DI BACKTEST NON CAMBIA. PUNTO.**
> Le nostre corse **PRETENDONO MT5 CHIUSO** (è il presupposto di tutta la
> pipeline `.ps1` → tester). **Un assistente AI attaccato a un terminale
> aperto non ha nessun posto nel backtest**, e questa live non porta un solo
> argomento per cambiare idea. **Nessuna modifica alla pipeline.**

> ### 🔴 **E SUL FORWARD: SOLO LETTURA. MAI ORDINI VIA AI.**
> L'unico interesse teorico è **monitoraggio/lettura** (esposizione, stato
> delle sedie). ⛔ **Nessun ordine, nessuna modifica di parametro, nessuna
> chiusura passa da un'AI collegata al terminale.** È la regola di casa: **il
> forward non si tocca** — e un canale che *può* scrivere ordini è, di per sé,
> una porta aperta su un conto vivo.

| ⚠️ Rischio non nominato nella live | Perché conta per noi |
|---|---|
| 🔴 **L'AI Assistant, se ha i permessi di trading, è un canale di scrittura sul conto** | Giacomo parla **solo** di lettura ed esposizione. **Non dice una parola sui permessi.** 🕳️ **Buco grave**: prima ancora di provarlo si deve sapere **se può piazzare ordini e come lo si impedisce** |
| 🟡 **Terminale del VPS** | Il VPS è la macchina delle sedie vive. **A10 impone client + MT5 sulla stessa macchina** → installarci sopra un client AI significa **toccare la macchina di produzione**. ⛔ **Non si fa** |
| 🟡 **Regole prop sui tool automatici** | `METRO_PROP` non ha una riga su "assistenti AI collegati al terminale". **Non lo sappiamo.** Prima di qualunque prova su conto prop: **si chiede alla prop** |
| 🟢 **Se mai si provasse: PC di backtest, conto DEMO, MT5 già chiuso per le corse** | Sandbox naturale. **Ma non c'è nessuna urgenza e nessun beneficio misurato** |

---

## §B — 🌍 IL CORSO DI MACROECONOMIA APPLICATA (r.47-51)

### B.1 Le AFFERMAZIONI STATISTICHE — tutte DICHIARATE, nessuna misurata da noi

| # | Affermazione | Citazione | Etichetta |
|---|---|---|---|
| **S1** | **Dataset: tutti i macro-dati da Forex Factory dal 2006 + prezzi veri di valute e oro dal 2006 a "qualche giorno fa"** | _"**Partiamo tutti da Forex Factory**… ho creato un sistema che mi ha permesso di **scaricare tutti i dati macroeconomici rilasciati dal 2006** e contestualmente ho preso **l'andamento veri delle valute e dell'oro dal 2006** in avanti… **li ho messi in relazioni**"_ (r.49-51) | 🔴 `[DICHIARATO, NON VERIFICATO]` — vedi **B.2**, dove il confronto col nostro dossier morde |
| **S2** | 🏆 **"Le valute stanno in trading range nel 70% del tempo, nel 30% prendono la direzione"** | _"ho un'altra statistica che tendenzialmente **le valute stanno in trading range nel 70% del tempo e nel 30% invece prendono la direzione**"_ (r.51) | 🔴 `[DICHIARATO, NON VERIFICATO]` · 🚩 **Nessuna definizione di "trading range", nessun TF, nessun campione, nessun periodo, nessuna coppia.** Così com'è **non è falsificabile** → non è una statistica, è un titolo |
| **S3** | **Nessun singolo dato muove una valuta da solo** | _"la prima cosa interessante… **che non c'è un dato che da solo fa muovere una valuta in maniera direzionale**"_ (r.51) | 🔴 `[DICHIARATO, NON VERIFICATO]` — 🟢 **plausibile e utilmente NEGATIVA**: smonta il "trade sulla singola news" |
| **S4** | 🏆 **Il prezzo si muove per lo SCARTO DAL CONSENSO, non per il dato** | _"**il movimento avviene per la differenza che c'è tra quello che aspetta il mercato e il dato che viene effettivamente rilasciato**"_ · _"**che cosa muove il tasso di cambio: è lo scarto rispetto al consenso**"_ · _"si muove per la differenza tra questo valore… e il previsto"_ (r.51) | 🔴 `[DICHIARATO]` · 🟢 **è il concetto standard di "sorpresa"**, coerente e ripetuto **tre volte** in forme diverse |
| **S5** | **Le REVISIONI fanno parte della sorpresa** | _"**tratta revisioni e comportamenti come parte della sorpresa**"_ (r.51, letto da slide) | 🔴 `[DICHIARATO]` · 📌 **Nota tecnica pesante per chiunque provi a replicarlo:** implica che il dataset debba conservare **le revisioni**, non solo il primo rilascio |
| **S6** | **L'impulso iniziale NON è la direzione** | _"il rilascio di un dato ha **un movimento impulsivo molto forte in una direzione, delle volte va prima da una parte poi dall'altra**… **non è detto che quella sia la direzione che mantiene il giorno dopo** o la settimana dopo… **in quel momento vengono scaricate delle posizioni**"_ (r.51) | 🔴 `[DICHIARATO]` · ⚠️ **Contrasto diretto con qualunque motore "post-news momentum"**: vedi `ANALISI_CORSO_POSTNEWS_2026-08-18.md` |
| **S7** | **Regola: "non inseguire il primo impulso"** | _"**poi non inseguire il primo impulso**"_ (r.51, slide) | 🔴 `[DICHIARATO]` — conseguenza operativa di S6 |
| **S8** | **Gerarchia dei dati che muovono una valuta** | _"**tassi di interesse, PIL e occupazione**"_ · _"il **PIL** è… **la fotografia di un paese**"_ · _"i **tassi di interesse** sono forse **uno dei pilastri più importanti**… **tassi elevati attraggono gli investitori esteri**… aumenta la domanda e quindi il valore della valuta"_ · _"**bilancia commerciale**… differenza tra importazioni ed esportazioni"_ · _"**l'inflazione elevata erode il potere d'acquisto**… **svaluta la moneta**"_ · _"**l'occupazione, che sono gli NFP**… c'è **un dato disaggregato molto importante degli NFP sulla disoccupazione**"_ (r.51) | 🔴 `[DICHIARATO]` · 🟢 **manuale standard, nessuna pretesa di originalità.** Citati anche: **salari**, **geopolitica**, **carry trade** ("lo vedremo dopo") |
| **S9** | **Segnale dal mercato obbligazionario: il DIFFERENZIALE, non il rendimento** | _"ci sono delle **forti indicazioni dai mercati obbligazionari**… **il differenziale della coppia e non solo il rendimento**"_ (r.51) | 🔴 `[DICHIARATO]` · 🕳️ **quale scadenza (2y? 10y?): NON DETTO** |
| **S10** | **Regola di riduzione rischio su divergenza** | _"**se tassi, cambio e rischio divergono, si riduce il rischio**"_ (r.51, slide) | 🔴 `[DICHIARATO]` · 🕳️ **di quanto si riduce: NON DETTO. Nessun numero** |
| **S11** | **Unità di analisi: il TRIMESTRE** | _"prenderemo in considerazione **un trimestre**, il trimestre va a identificare **il ciclo completo di un possibile intervento delle banche centrali**"_ (r.49) | 🔴 `[DICHIARATO]` · 📌 **scelta dichiarata, motivata, e almeno coerente** |
| **S12** | **"Ho utilizzato l'intelligenza artificiale" per fare le statistiche** | _"ho fatto delle **statistiche importanti, ho utilizzato l'intelligenza artificiale** e ho trovato delle cose interessanti"_ · _"ho fatto **una piccola slide attraverso notebook**"_ (r.51) | 🚩 `[TRASCRITTO chiaro]` — **AMBRA.** Non squalifica nulla, ma: **statistiche prodotte da un'AI, senza codice, senza campione e senza replica dichiarati.** Nel nostro metro, questo **non è un numero**: è un'affermazione |

### B.2 🧪 IL CONFRONTO COL REPO — dove S1 diventa importante

`backtest_pipeline/caccia_strategie/DOSSIER_NEWS_FILTER_2026-08-21.md` §1A,
**misurato da noi il 21/08**:

| Cosa | Noi | Lui |
|---|---|---|
| Fonte del calendario | **Forex Factory** (via mirror GitHub) | **Forex Factory** ✅ **stessa fonte** |
| `forexfactory.com` diretto | 🛑 **403 da questa macchina — FONTE NULLA** | ci accede |
| Miglior dataset in mano | `spoluan/forex-factory-scraper`: **2010→2023**, **65.271 righe**, MIT, fuso **UTC+8 con DST USA — MISURATO DA NOI** | **2006→2026** dichiarato |
| Riserva | `EPSOFT/dataset-forexfactory`: **2007→2023** dichiarato, colonne `[INCERTO]` | — |
| Revisioni conservate? | **[INCERTO], mai verificato** | **le usa** (S5) |

➡️ **Conclusione onesta:** il suo dataset, se esiste come descritto, **copre
2006-2009 e 2024-2026, che a noi mancano** — e **conserva le revisioni**, che
non sappiamo se i nostri dataset abbiano. **Non possiamo né verificarlo né
replicarlo con le fonti aperte da questa macchina.** Va scritto così, senza
sminuirlo e senza crederci.

### B.3 ⚙️ IL METODO OPERATIVO MACRO — i parametri con valore

| # | Parametro / regola | Citazione | Etichetta |
|---|---|---|---|
| **M1** | 🏆 **SI ENTRA SOLO ALL'USCITA DAL TRADING RANGE. Mai a metà canale** | _"**la posizione andremo a prendere esclusivamente quando uscirà dal trading range**… quando uscirà dal trading range **allora noi sapremo la direzione, long o short**. **NON entriamo a metà, all'interno del canale**, ma entreremo **esclusivamente quando uscirà fuori dal trading range**"_ (r.51, ripetuto 3 volte di fila) | 🟢 `[TRASCRITTO chiaro]` — **la regola più insistita di tutta la parte macro** |
| **M2** | **La DIREZIONE viene dal bias macro, il TIMING dalla rottura** | _"**devo prendere posizione in base a quelle che sono le indicazioni che vengono date dall'economia** di un paese"_ · _"come nasce il bias: **confrontando le due economie su crescita, inflazione, [politica], tassi… rischi e flussi**"_ (r.51) | 🟢 `[TRASCRITTO chiaro]` — 📌 **separazione netta direzione/timing, concettualmente pulita** |
| **M3** | **Il trigger di ingresso: chiusura del CORPO fuori dal range** | _"l'ingresso sarà **quando esce col sederino sotto o col sederino sopra**"_ (r.51) | 🟡 `[TRASCRITTO dubbio]` sulla parola ("sederino"/"culetto"/"colettino" ricorrono) · **`[INFERITO]` = chiusura del corpo oltre il livello**, coerente con la stessa regola del 27-28/08 |
| **M4** | 💰 **SIZE 1-2-3%** | _"le **size** ovviamente le manteniamo, a livello operativo, diciamo **nell'ordine dell'1, 2, 3%**"_ (r.51) | 🟡 `[TRASCRITTO chiaro]` sul numero, **`[INCERTO]` sul significato**: 1-2-3% **di rischio per trade** o **di capitale impegnato**? **Non lo dice.** ⚠️ Se è rischio/trade, **il 3% è 4,6 volte il nostro 0,65% per sedia** |
| **M5** | 🛑 **STOP DISTANTE — esplicitamente diverso dal loro intraday** | _"sappiate che qua però **le operazioni avranno uno stop distante**: **non abbiamo uno stop vicino come la nostra operatività**"_ (r.51) | 🟢 `[TRASCRITTO chiaro]` · 🕳️ **QUANTO distante: MAI DETTO. Nessun ATR, nessun punto, nessuna percentuale** |
| **M6** | ⏳ **ORIZZONTE: 1-2 mesi** | _"**il [tempo] massimo delle operazioni può essere un mese, ma tendenzialmente un mese, due mesi**"_ (r.51) | 🟢 `[TRASCRITTO chiaro]` · 🔴 **Nota di casa: 1-2 mesi di holding = overnight e weekend continui → costo swap e, sulle prop, esposizione ai divieti di overnight/weekend.** METRO_PROP §3 (overnight) è **direttamente investito** da questo metodo |
| **M7** | **Frequenza: rara e dichiarata tale** | _"**non avremo le occasioni tutti i giorni** su questo"_ (r.51) | 🟢 `[TRASCRITTO chiaro]` — 🟢 **onestà da annotare** |
| **M8** | **Il bias multiday serve anche all'intraday** | _"sai che in quel momento l'euro-dollaro sta salendo e quindi **valuterai degli ingressi anche a livello intraday con una maggiore chiarezza**"_ (r.51) | 🟡 `[TRASCRITTO chiaro]`, 🚩 **ma è esattamente il punto dove un bias non misurato inquina l'operatività misurata.** Da noi: **un filtro si accende solo se un round lo promuove** |
| **M9** | **Routine pre-mercato obbligatoria: guardare il calendario** | _"**la prima cosa che voi dovete fare nel vostro piano di trading… prima di mettervi a operare, guardare questa pagina, guardare i market mover**"_ (r.51) | 🟢 `[TRASCRITTO chiaro]` |
| **M10** | **Lettura del calendario: rosso = market mover; arancione senza orario = non lavorabile; bank holiday = poco movimento** | _"oggi che è **il 31 agosto** non abbiamo nessun dato **con la casella rossa**"_ · _"il **CPI preliminare** viene dato **sull'arancione**, **non sappiamo neanche quando viene rilasciato** durante la giornata"_ · _"**è un bank holiday**… il **GBP** è bank holiday, quindi **sulla sterlina probabilmente i movimenti non arriveranno in maniera importante** perché **non ci sono gli istituzionali** che lavorano"_ (r.51) | 🟢 `[TRASCRITTO chiaro]` · 📌 **La regola "bank holiday → niente istituzionali → niente movimento" è meccanizzabile** (è un flag di calendario) e **da noi non esiste** |
| **M11** | **Le tre colonne da leggere: precedente / previsto / rilasciato** | _"dobbiamo andare a vedere **qual è il valore vecchio, il valore del rilascio precedente, il previsto**… e si muove per la differenza tra questo valore che uscirà **55.3** e il previsto"_ (r.51) | 🟡 numero **`[TRASCRITTO dubbio]`**: **55.3** è attribuito al **PMI manifatturiero**, ma nella frase **non è chiaro se sia il precedente o il previsto**. **Numero non usabile** |
| **M12** | 🚩 **L'algoritmo automatico promesso** | _"ho costruito un algoritmo **che farà tutto in automatico**, metterà in relazione i dati che escono, **ma non solo: con le API… va a prendere tutti i discorsi delle banche centrali, tutte le news geopolitiche**… una serie di dati esterni **che va a matchare** con i dati rilasciati"_ (r.51) | 🔴 `[DICHIARATO, NON VERIFICATO]` · vedi bandiera **B1** |

---

## §C — 📈 LA PARTE OPERATIVA IN DIRETTA (r.51)

### C.1 La CATENA MULTI-TIMEFRAME, dettata per intero

| TF | A cosa serve, con le sue parole | Etichetta |
|---|---|---|
| **Monthly** | _"il monthly io lo guardo tendenzialmente **esclusivamente per tirare due righe, supporto e resistenza**… quando i prezzi vanno vicini al massimo della candela precedente, allora diventano **punti di interesse**"_ · _"il monthly **lo vedete una volta a settimana**"_ | 🟢 `[TRASCRITTO chiaro]` ("montri" = monthly) |
| **Weekly + Daily** | 🏆 _"**sono i due timeframe più importanti in assoluto dal punto di vista dello studio**"_ | 🟢 `[TRASCRITTO chiaro]` |
| **H4** | contesto e zone di pre-section: _"a livello H4 qua c'era **una zona di pre-section importante**"_ | 🟢 |
| **H1** | conferma/disaccordo + volumi: _"l'H1 è **in accordo o disaccordo**… abbiamo **una doppia conferma della zona**"_ | 🟢 |
| **M15** | 🏆 **TF OPERATIVO**: _"**vado in M15 per operare**… per capire **dove sono nel timeframe operativo** e cosa faccio"_ | 🟢 — ✅ **identico al 28/08** |

### C.2 I MECCANISMI operativi — con la citazione che li prova

| # | Meccanismo | Citazione | Etichetta |
|---|---|---|---|
| **C1** | 🏆 **LIVELLO VALIDO SOLO CON MASSIMI E MINIMI CONTRAPPOSTI — e se non ci sono, NON SI TRACCIA** | _"andiamo a tracciare i livelli **con massimi e minimi contrapposti**… in realtà **sono spaiati**… quindi sul monthly **non abbiamo un livello operativo**… **non è possibile. Non invento, non invento, non traccio**"_ | 🟢🟢 `[TRASCRITTO chiaro]` — **la regola negativa più forte della live: si dichiara l'assenza di segnale.** Metodologicamente **è la nostra stessa disciplina** |
| **C2** | **Definizione di "massimo/minimo contrapposto"** | _"**questi fanno due candele di massimo, questi sono candele di minimo: questo è un livello di supporto**"_ | 🟡 `[TRASCRITTO]` ma **descritto indicando lo schermo** → 🕳️ **quante candele servono, che tolleranza: NON DETTO** |
| **C3** | **Sui MASSIMI ASSOLUTI non si traccia niente** | _"si è fermato in un punto dove **sarà difficile capire i livelli perché siamo sui massimi assoluti**… **non abbiamo riferimento del passato, non possiamo tracciare alcun livello**"_ (sul DAX) | 🟢 `[TRASCRITTO chiaro]` — 📌 **meccanizzabile e con conseguenza vera**: su nuovi massimi, i motori a livelli sono ciechi |
| **C4** | 🏆 **IL RETEST È LA CERTIFICAZIONE DELLA ZONA** | _"**cosa vi dà la conferma che questa zona è una zona ufficialmente riconosciuta come zona di price action?**… **è il retest**: lui esce dal canale, va a ritestare… **il retest mi dà la certificazione che questa è un'area importante**"_ · _"**vado a vedere sempre il retest**… se sono nella zona di congestione **il retest è molto importante**… **e se ti scappa il prezzo, chi se ne frega: tanto devi [aspettare il] retest**" | 🟢🟢 `[TRASCRITTO chiaro]` — 🏆 **la frase "se ti scappa il prezzo, chi se ne frega" è la disciplina anti-FOMO in forma pura** |
| **C5** | **La zona nasce dal TEMPO passato in laterale** | _"in passato i prezzi si sono messi **nella fase laterale** e hanno creato **un floor solido dal punto di vista della liquidità**"_ · _"**questa zona di liquidità dove lui si è fermato per più tempo, diventa una zona importante**"_ | 🟢 `[TRASCRITTO chiaro]` — ✅ **identica alla definizione del 28/08** (E3) |
| **C6** | 🏆 **VOLUMI CRESCENTI = condizione della rottura** | _"aspetterò che cosa uscirà dalla parte superiore **con un incremento — questo è fondamentale — l'incremento di volumi, perché se non c'è l'incremento di volumi lui rompe e torna indietro**"_ · _"adesso… **i volumi sono in decrescita**… non stanno crescendo"_ | 🟢🟢 `[TRASCRITTO chiaro]` — 🟢 **converge con R101 (`02_volumi`)** |
| **C7** | **Struttura: massimi/minimi crescenti; cambia solo se rompe la struttura** | _"la prima cosa che devo andare a vedere è **massimi e minimi crescenti o decrescenti**… **la struttura di uno strumento cambia quando va a inficiare massimi e minimi contrapposti confermati**"_ · _"**non è ancora cambiata perché non ha fatto un minimo inferiore a questi due**"_ | 🟢 `[TRASCRITTO chiaro]` |
| **C8** | **NUMERI TONDI come livello** | _"guardate dove si ferma: **numero tondo**"_ · _"io **entrerei perché numero tondo, zona di pre-section**"_ · _"**i prezzi sono vicini al numero tondo con una candela ribassista**"_ | 🟢 `[TRASCRITTO chiaro]` — ✅ converge col 27/08 (26.300) |
| **C9** | **Pianificare i TRE numeri PRIMA di entrare** | _"nel momento in cui tu prendi la decisione **devi sapere come gestire, come individuare l'ingresso, individuare lo stop e individuare il target** — cosa che **pochi di voi**, anche se è semplice, fanno. **Io devo pianificare tutto**"_ | 🟢🟢 `[TRASCRITTO chiaro]` |
| **C10** | 🏆 **STOP SOTTO IL CANALE, non appiccicato** | _"**lo stop lo devo mettere sotto il canale**"_ · _"il mio stop è qua sotto, il mio stop è qua sotto"_ · _"**io ho già calcolato lo stop**"_ | 🟢 `[TRASCRITTO chiaro]` · ✅ coerente col 28/08 (E13) · 🕳️ **valore numerico MAI dettato** |
| **C11** | ⚖️ **INGRESSO DIVISO SU 3 LIVELLI DEL CANALE, con size CRESCENTE verso il basso** | _"**voglio dividere l'ordine in 4, la mia size da 20 la divido in 4**"_ · _"**il DAX me lo vado a prendere nella parte mediana**"_ · _"**io faccio primo livello, secondo livello, oppure uno mette gli ordini tutti al terzo livello**"_ · _"**il terzo ordine lo metto nella parte finale: è quello che mi permette di pestarlo di più, con 10 contratti**"_ · _"**metto la parte più importante [in basso] e vedrete, come sempre, uscirò indenne**" | 🟡 `[TRASCRITTO chiaro]` sul meccanismo, **`[TRASCRITTO dubbio]` su ogni quantità** (X3) · 🚩 **bandiera B4: è mediazione con stop unico** |
| **C12** | 🏆 **GESTIONE: chiudi il pezzo PIÙ VICINO AL PREZZO → stop a pari sul resto** | _"**chiudo la prima**… così **posso gestirmi l'operazione a rischio di zero**"_ · _"**l'ingresso che è più vicino ai prezzi è quello che mi dà fastidio**… **l'ordine più vicino al prezzo deve essere l'ordine da mandare via, e [poi] gestire lo stop a pari**"_ · _"se torno indietro **lo stop a pari e non perdo niente: posso solo guadagnare**"_ | 🟢🟢 `[TRASCRITTO chiaro]` — 🥈 **il pezzo #2 della sintesi: già nel nostro codice** |
| **C13** | ⚠️ **AMMETTE DI NON AVER GESTITO IN TEMPO** | _"adesso guardate: situazioni dove… **ci siamo messi a parlare, ma in realtà non abbiamo gestito. Non ho gestito l'ordine più vicino al prezzo**"_ | 🟢 `[TRASCRITTO chiaro]` — 🏆 **onestà rara in una live**, e **argomento involontario a favore dell'automatismo**: la regola c'era, la mano no |
| **C14** | ✅ **REGOLA DELL'ERRORE: posizione fuori piano = chiusura immediata** | vedi §1.1 🥉 | 🟢🟢 `[TRASCRITTO chiaro]` |
| **C15** | **Chiusura finale: cancella l'ordine residuo e porta a casa** | _"io mi gestisco **cancellando questo ordine**, che **di 89 euro me li porta a casa**, e **270 euro li posso solo guadagnare** perché posso mettere lo stop"_ | 🟡 `[TRASCRITTO dubbio]` sui due numeri (sintassi rotta) · 🔴 **esito finale del trade: MAI DICHIARATO** |
| **C16** | **Correlazioni dichiarate** | _"**se l'oro sale, il DAX scende e viceversa** — diciamo **non è sempre sempre così**"_ · _"il DAX si basa su quali correlazioni? Su **euro-dollaro**… poi **il petrolio**"_ | 🔴 `[DICHIARATO, NON VERIFICATO]` · 🧪 **Da noi il filtro correlazione è già stato MISURATO E BOCCIATO** (R101/G3: incoerente fra Dow e DAX; Paolo il 24/08: _"le correlazioni sono andate tutte a farsi fottere"_). **Noi abbiamo il numero, lui l'opinione** |
| **C17** | **Grafico pulito** | _"lasciate stare che ci sono diverse configurazioni… **io lavoro così oggi con voi, senza niente: volumi, separatore di periodo e prezzo**"_ · _"questi sono **esperimenti che sto facendo con gli algoritmi**"_ | 🟢 `[TRASCRITTO chiaro]` · 🕳️ **cosa siano gli "esperimenti con gli algoritmi" a schermo: MAI SPIEGATO** |
| **C18** | **La prima operazione su un conto nuovo serve ad accettare i termini** | _"ogni volta quando aprite **un conto nuovo**… la prima cosa che dovete fare è **fare la prima operazione**… **non preoccupatevi della size perché viene stoppata: devi accettare i termini**"_ | 🟢 `[TRASCRITTO chiaro]` — 🟢 **nota pratica innocua e vera per molti broker.** Utile a Claudio all'apertura di un conto prop |

### C.3 💰 I NUMERI DELL'OPERATIVITÀ — tutti quelli che ci sono

| Valore | Cosa | Citazione | Etichetta |
|---|---|---|---|
| **20.000 €** | 🏆 **il conto "piccolo" da cui riparte** | _"ho aperto… il conto piccolo… **quindi i soliti 20 mila**"_ | 🟢 `[TRASCRITTO chiaro]` — **ripetuto e coerente** |
| **1.000-2.000 €** | conti che dichiara di **non** usare per la live | _"**non ho un conto da 1000 o 2000 euro**, ma **volutamente non sono ripartito** da 1000 o 2000 perché **vi ho già dimostrato conti piccoli**… **devo avere del margine per lavorare** davanti a tutti"_ | 🟢 `[TRASCRITTO chiaro]` |
| **size "da 20", divisa in 4** poi **in 3** | dimensione totale e frazionamento | _"la mia size **da 20** la divido **in 4**"_ / _"**lo divido in tre ordini**"_ / _"**10 e 20, 10 e 20**"_ | 🔴 `[TRASCRITTO dubbio]` + **contraddittorio (X3)** — **non è un parametro, è una descrizione a braccio** |
| **10 contratti** | il "pezzo" pesante | _"il terzo ordine… **con 10 contratti**"_ · _"**se faccio 10 contratti**, qual è il margine…"_ | 🟡 `[TRASCRITTO chiaro]` ma **strumento e valore-punto non dichiarati** |
| **20 contratti** | il pezzo mediano | _"nella parte mediana **metto un ventino di contratti**"_ · _"**se prendo 20 contratti**…"_ | 🟡 `[TRASCRITTO dubbio]` |
| **~2.000 €** | 🏆 **margine per 10 contratti** | _"**il margine che viene tenuto è quasi di 2000 euro**, cioè **non posso muovermi** per un po' se faccio 10 contratti"_ | 🟢 `[TRASCRITTO chiaro]` — 📌 **su 20k = il 10% del conto immobilizzato in un solo pezzo su tre** → vedi **B3** |
| **20.000** | _"sono 20.000 a favore"_ | _"se faccio 10 contratti **sono 20.000 a favore**"_ | 🔴 `[TRASCRITTO dubbio]` — frase rotta. **`[INFERITO]`, non certo:** esposizione nozionale. **NON USABILE** |
| **40-50-60 punti** | 🏆 **TARGET dichiarato dell'operazione** | _"questa è un'operazione dove, se tutto va bene, **dovranno provare 40, 50, 60 punti**"_ | 🟢 `[TRASCRITTO chiaro]` — **il target più preciso della live** |
| **"10 lunghi punti"** | ambizione minima del primo pezzo | _"questo ordinino che ho appena messo… **vorrei portare almeno 10 [?] punti**"_ | 🔴 `[TRASCRITTO dubbio]` — probabile **"10 punti"** o **"100 punti"**. **Non usabile** |
| **26.392** | 🏆 **prezzo DAX in diretta** | _"**siamo a 26392**… i prezzi sono vicini al numero tondo con una candela ribassista"_ | 🟢🟢 `[TRASCRITTO chiaro]` — ✅ **CONTROLLO INCROCIATO SUPERATO**: il referto del 27/08 registra **26.278 / 26.300 / 26.386** sullo stesso strumento. **Lo speech-to-text qui non ha sbagliato** |
| **~"71" / "76"** | livelli intra-canale (26.371 / 26.376?) | _"la parte mediana potrebbe essere **71**"_ · _"adesso vediamo, ci sono quasi **76**"_ | 🟡 `[INFERITO]` = **26.371 / 26.376**, coerenti con 26.392. **Plausibili, non certi** |
| **15 €** | perdita dell'ordine sbagliato chiuso per regola | _"**anche se io ho una perdita di 15 euro**"_ | 🟢 `[TRASCRITTO chiaro]` |
| **89 € / 270 €** | numeri di chiusura | vedi C15 | 🔴 `[TRASCRITTO dubbio]` |
| **"le 10, le 9-10"** | ora dichiarata durante il trade | _"adesso siamo alle 10, alle 9-10, non è che ricordo"_ | 🔴 **`[INCERTO]` — LUI STESSO NON SA CHE ORA È, E IL FUSO NON È DICHIARATO.** 🛑 **REGOLA DI CASA: NON SI CONVERTE.** Un orario col fuso sbagliato è peggio di nessun orario |
| **"il bonus 1,50"** | _"mi hanno dato il bonus 1,50"_ | — | 🔴 `[TRASCRITTO dubbio]` — **incomprensibile. SCARTATO** |
| **"100, 200, 300 mila €"** | 🚩 **entità dei suoi P/L sul conto grande** | _"degli ingressi dove **non guadagno 100, 200, 300 mila euro o ne perdo 100, 200 o 300**"_ · _"**è stata fatta una performance fuori dal comune, ma prendendomi dei bei rischi**… ci sono state anche **delle cose toste**"_ | 🔴🔴 `[DICHIARATO, NON VERIFICATO]` — **nessun estratto conto, nessuna percentuale, nessun periodo.** 🟢 Va però riconosciuto: **ammette esplicitamente i rischi presi e le perdite** |

### C.4 📉 Le due analisi, in due righe

- **ORO (XAUUSD):** monthly = **nessun livello tracciabile** (C1) → weekly = supporto trovato e **tenuto** → daily = **trading range** con **retest** che certifica la zona → H4/H1 = zona di pre-section, prezzo in mediana → **M15: sta fermo**. Conclusione: _"**in M15 sto fermo**… se dovessi valutare un ingresso long col culetto sopra questo livello… **ho subito un ostacolo di pre-section**"_. 🟢 **Nessuna operazione sull'oro. Ha aspettato.**
- **DAX (German):** monthly **verde, sui massimi assoluti → nessun livello** (C3) → weekly: _"**è in un contesto di forze molto importanti**… ha tentato di fare nuovi massimi, **non ce l'ha fatta: c'è una presa di posizione dei venditori**"_ → daily/H4/H1 **short** → **entra comunque LONG** su numero tondo + pre-section, **contro il proprio protocollo** (X2/B2), su 3 livelli, poi sbaglia un ordine in sell, lo chiude per regola, chiude un pezzo, mette lo stop a pari, cancella l'ultimo pendente. **Esito finale: NON DICHIARATO.**

---
---

# 🧭 PARTE 3 — CONFRONTO COL REPO, DOMANDE, SCARTI

## 3.1 🧪 Cosa dicono che NOI GIÀ FACCIAMO (verificato nel repo, non a memoria)

| Loro | Noi | Verdetto |
|---|---|---|
| Volumi come conferma di rottura (C6) | **R101: `02_volumi` unico filtro sopravvissuto a G1+G2+G3** | 🟢 **LO FACCIAMO, ED È MISURATO** |
| Retest come conferma (C4) | `InpEntryMode=1` = **LIMIT sul retest** (`ABTG_Apertura_3Ingressi.mq5` r.256) — già in duello in R83 | 🟢 **LO FACCIAMO** |
| Chiudi la parziale → stop a pari (C12) | **`InpBreakevenAtTP1 = true`** (r.316), gestione **per-ticket** (r.2241) | 🟢🟢 **LO FACCIAMO GIÀ IN AUTOMATICO** |
| Pianificare ingresso/stop/target prima (C9) | Ogni sedia ha SL/TP/flat **negli input**, prima del lancio | 🟢 **STRUTTURALE DA NOI** |
| Posizione fuori piano → si chiude (C14) | Cancello **A1** `InpMaxPosSimbolo` (r.253) | 🟢 **Stessa filosofia** |
| Correlazione oro/DAX, DAX/EURUSD (C16) | **BOCCIATA da G3 in R101** | 🟢 **NOI ABBIAMO IL NUMERO, LORO L'OPINIONE** |
| Slippage sui pendenti nelle news (§1.1) | **36/97 EA usano pendenti STOP**; news filter **spento**; METRO_PROP §G3.2 + §7 | 🟡 **CORSIA APERTA, ora con una motivazione in più** |

## 3.2 🔴 Cosa NON facciamo (delta reali, tutti **SPUNTI**, nessuno azionabile oggi)

| # | Delta | Costo | Priorità |
|---|---|---|---|
| **S-A** | **Rilevatore di PRE-SECTION** (laterale con più tempo di permanenza) | 🔧🔧 medio | 🟡 già aperto il 28/08 (S4). **Invariato** |
| **S-B** | **Filtro "massimi/minimi contrapposti"**: se non ci sono, **il motore non opera** (C1) | 🔧🔧 medio | 🟡 **elegante, ma serve una definizione numerica che lui NON dà** |
| **S-C** | **Numeri tondi** come livello/filtro (C8) | 🔧 basso | 🟡 **mai misurato da noi**; 2 fonti (27/08 + 31/08) **ma è UNA fonte sola** |
| **S-D** | **Flag "bank holiday"** dal calendario → giornata declassata (M10) | 🔧 basso (il campo c'è nei dataset FF) | 🟡 **candidato pulito**, e già abbiamo i CSV del `DOSSIER_NEWS_FILTER` |
| **S-E** | **Cieco sui massimi assoluti** (C3): un motore a livelli su nuovi massimi non ha riferimenti | 📖 lettura | 🟢 **verifica di coerenza**, non una modifica |
| **S-F** | **Stress-slippage sui pendenti in finestra NFP/CPI** | 🔧 medio | 🟠 **la più utile alla challenge**: si aggancia a G3.2, già progettata |
| ⛔ | **Metodo macro multiday (M1-M6)** | — | 🔴 **NON CANDIDATO.** 1-2 mesi di holding, stop "distante" senza numero, size 1-2-3% senza definizione: **incompatibile con il metro di casa e con i muri prop.** Si archivia come cultura |

## 3.3 📸 LE DOMANDE PER CLAUDIO — gli screenshot ai minuti giusti

| # | Cosa manca | Dove | Perché serve |
|---|---|---|---|
| **D1** | 🔴🏆 **L'URL DEL CONNETTORE MCP** — dettato mai, mostrato sì | r.37: _"andate a prendere **l'URL che è questo**"_ | **Senza quello, tutta la §A è aria.** È il campo che rende la cosa verificabile |
| **D2** | 🔴 **Il pannello `Strumenti → Opzioni → AI Assistant`** | r.17 | **Serve per sapere se c'è un permesso di TRADING** e come si spegne. Domanda n.1 di sicurezza (§A.2) |
| **D3** | 🟡 **La schermata del connettore in Claude** (percorso aggiornato) | r.31-35 — lui stesso sbaglia il percorso e dice che l'interfaccia è cambiata | Il percorso a voce è **già scaduto** |
| **D4** | 🟡 **Il "documentino" di Giacomo** nelle "comunicazioni importanti" | r.29, r.45 | **Sarà più affidabile del parlato.** Da recuperare quando esce |
| **D5** | 🔴 **Le slide macro** (fatte "attraverso notebook") | r.51 | Contengono **le regole non negoziabili lette a voce** e forse **i numeri veri delle statistiche S2** |
| **D6** | 🔴🏆 **La pagina/tabella da cui esce il "70% in trading range"** | r.51 | **Senza campione, TF e definizione, S2 non è verificabile.** È l'affermazione più citabile e la meno sostenuta |
| **D7** | 🟡 **Il grafico ORO con i livelli weekly/daily tracciati** | r.51 | I livelli sono **indicati a mano sullo schermo**, mai letti: senza i prezzi, C1-C5 restano definizioni senza esempio |
| **D8** | 🟡 **Il grafico DAX M15 con i 3 ordini e lo stop** | r.51 | **L'unico modo per avere il rapporto stop/target vero.** Ora abbiamo solo "40-50-60 punti" di target e **zero** sullo stop |
| **D9** | 🟡 **Il "protocollo" che ha mandato agli allievi** | r.51: _"rispetto al protocollo che vi ho mandato"_ | È un **documento scritto**: vale più di tre live |
| **D10** | 🟢 **La schermata Forex Factory del 31/08** | r.51 | Per verificare M10 (rosso/arancione/bank holiday) e il **55.3** di M11 |

## 3.4 🗑️ GLI SCARTI — cosa è stato letto e buttato, col motivo

| Materiale | Perché scartato |
|---|---|
| Confronto Claude/ChatGPT/Gemini/Qwen/Perplexity (r.23-27) | **Chiacchiera sui modelli.** Zero valore operativo |
| _"siamo in 1981"_, _"c'è meno 85"_ (r.5, r.13) | **Illeggibili.** Nessuna ricostruzione onesta possibile |
| Cena di giovedì, evento di Rimini, iscrizioni (r.51) | **Logistica del corso.** Solo l'annuncio dell'algoritmo è stato tenuto (**B1**) |
| _"le guerriglie extraterrestri"_, _"200mila innovatori"_, _"il pianto…"_ | **Rumore dello speech-to-text.** Non ricostruibili |
| _"mi hanno dato il bonus 1,50"_ | **Incomprensibile** |
| Teoria macro da manuale (PIL, tassi, bilancia commerciale) | **Tenuta in S8 come elenco**, ma **non è materiale da imbuto**: è cultura generale |
| Nomi degli allievi e interazioni di chat | **Nessun contenuto numerico** |

---

## 4. 🔒 CONCLUSIONE

> ### ⛔ **NESSUNA AZIONE SULLA FLOTTA. NESSUNA MODIFICA ALLA PIPELINE.**
> Non un filtro, non una soglia, non un orario, non una taglia, non un magic.
> **MT5 resta CHIUSO durante i backtest.** **Il forward non si tocca, e
> nessuna AI riceve mai il permesso di piazzare ordini.**
>
> Bilancio: **§A 14 affermazioni tecniche · §B 12 statistiche dichiarate +
> 12 regole di metodo · §C 18 meccanismi + ~18 valori numerici etichettati ·
> 5 contraddizioni · 4 bandiere (1 rossa, 3 ambra) · 6 spunti · 10 domande.**
>
> 🏆 **Il pezzo che vale di più è, ancora una volta, una VERIFICA NEL SORGENTE
> CHE CI DÀ RAGIONE:** la gestione che Emiliano insegna a mano — *chiudi il
> pezzo più vicino al prezzo, porta lo stop a pari, "non perdo niente, posso
> solo guadagnare"* — è **già scritta nel nostro codice** come
> `InpBreakevenAtTP1 = true` (`ABTG_Apertura_3Ingressi.mq5` r.316), con stato
> per-ticket. E nella stessa live lui **ammette di non essere riuscito a
> eseguirla** perché stava parlando (*"non ho gestito l'ordine più vicino al
> prezzo"*). **È il miglior argomento a favore dell'automatismo che la live
> potesse regalarci, ed è involontario.**
>
> 🥈 **Il pezzo più utile alla challenge è l'avvertimento sui pendenti:**
> *"poco prima del rilascio del dato questi livelli si svuotano… l'ordine
> pendente viene mandato a mercato dal broker ma non trova niente… potrebbe
> eseguirlo addirittura molto distante"* — **NFP e CPI nominati**. Con **36
> dei nostri 97 EA che piazzano pendenti STOP** e **zero filtro news**, questo
> non è colore: è la coda a sinistra che `METRO_PROP` §G3.2 sta già cercando.
>
> 🚩 **E la bandiera rossa è di marketing, non di rischio:** un *"algoritmo
> predittivo sulle valute"* promesso in regalo a un evento, **senza un solo
> numero**. Si archivia. Non si aspetta, non si cita, non entra nell'imbuto.

---

### 🔗 Referti collegati
- `risultati_archivio/ANALISI_LIVE_EMILIANO_2026-08-28.md` — la live di giovedì: definizione di **pre-section**, **M15**, **volumi da H1 in giù**, spunto S4 (rilevatore di pre-section) che **qui resta invariato**
- `risultati_archivio/ANALISI_LIVE_EMILIANO_2026-08-27.md` — le due regole, il numero tondo **26.300**, i prezzi DAX 26.278/26.386 usati qui come **controllo incrociato del 26.392**
- `caccia_strategie/ANALISI_LIVE_EMILIANO_2026-08-24.md` — Paolo in sostituzione ("Emiliano assente per intervento"): **coerente con _"da quando sono uscito dall'ospedale"_**; slippage vissuto in diretta
- `caccia_strategie/DOSSIER_NEWS_FILTER_2026-08-21.md` §1A — **il confronto dei dataset Forex Factory** (§B.2): noi 2010-2023, lui dichiara 2006-2026
- `caccia_strategie/ANALISI_CORSO_POSTNEWS_2026-08-18.md` — **in tensione con S6/S7** ("non inseguire il primo impulso")
- `report/METRO_PROP.md` §G3.2 (r.410) e §7 (r.139-145) — slippage oltre lo stop e news trading; **r.535**: il buco dichiarato su grid/martingala/**averaging** presso The5ers/FundingPips/E8/Alpha, che la bandiera **B4** rende meno teorico
- `mql5/Experts/ABTG_Apertura_3Ingressi.mq5` — **r.316** (`InpBreakevenAtTP1`), **r.253** (cancello A1), **r.256** (i tre stili di ingresso, da **non** confondere con i tre livelli scalati di Emiliano), **r.2216/2241** (parziale + breakeven + trailing per-ticket)

---

_Referto compilato leggendo il file **integralmente, 51/51 righe**, compreso il
blocco unico della r.51 (**47.621 caratteri = l'86% del file**). Ogni valore ha
la sua citazione. Ogni incrocio col repo è verificato **nel sorgente o nel
referto citato**, mai a memoria. **Nessun file eseguibile è stato modificato.**_
