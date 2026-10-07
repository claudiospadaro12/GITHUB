# PTE Dashboard LEGGERA: la nostra versione della tabella PTE (07/10/2026)

> **Stato: strato 1 PASS dove si può provare senza MetaTrader · strato 2 (`controllo-preventivo`, 07/10) PASS CON RISERVA dopo correzioni meccaniche (serie vuota che non si riempiva mai, collaudo rinforzato da 39 a 62 mutanti, cifra "3 volte" corretta, bersaglio "sul VPS") · le correzioni sono state riguardate da un lettore indipendente (PASS CON RISERVA), che ha chiesto 3 correzioni meccaniche (ancora strutturale sulle uscite prima di CopyRates, nome oggetto 'pannello', 37 simboli/FTMO 1514806751): fatte, collaudo 66/66. RISERVA RESIDUA: mai compilata in MetaEditor.**
> Mai compilata: qui non c'è MetaEditor. La prima compilazione la fai tu (F7).

File:
- indicatore: `mql5/Indicators/ABTG_PTE_Dashboard_Leggera.mq5`
- collaudo: `backtest_pipeline/collaudo_pte_dashboard_leggera.py` (si rigira con `python3 backtest_pipeline/collaudo_pte_dashboard_leggera.py`)

## 1. Cosa fa

Disegna la stessa tabella della `PTE_V3_18 3.18` (finestra in alto a sinistra, colonne **PAIR / H1 / H4 / D1**, le 5 liste di simboli dell'originale), ma con carico minimo:

- **solo visione**: nessun ordine, nessuna rete, nessun file, **zero handle** di indicatori;
- **calcola solo quando un simbolo/TF chiude una barra**, mai a ogni tick (timer di 1 secondo e orario della prossima barra tenuto in memoria);
- copia **il minimo di barre** che serve (131 con i default: ATR lento 100 + 30 barre di ricerca + 1);
- **254 oggetti** (35 simboli x 3 TF) creati una volta sola; un oggetto viene toccato solo se cambia testo o colore, e il grafico si ridisegna solo in quel caso;
- niente frecce, niente candele Heikin Ashi disegnate, niente canali disegnati: **la dashboard è la tabella**.

Il carico, in numeri **[STIMA, non misura]**: a regime H1+H4+D1 su 35 simboli fanno circa **45 copie di dati all'ora** (una ogni ~80 secondi). All'avvio riempie la tabella in ~6 secondi (max 20 celle al secondo). Se l'originale ricalcolasse ~105-111 celle **a ogni tick** (ipotesi che spiegherebbe gli scatti, **non verificata**: non abbiamo il sorgente), con 2-5 tick al secondo sarebbero centinaia di ricalcoli al secondo.

## 2. Come si legge una cella — 🔴 IPOTESI DI LAVORO, da confermare

Dalla schermata del 07/10 ore 20:22 e dagli input dell'originale, la nostra lettura è:

- **cella accesa** = su quel simbolo/TF c'è stata una **DOJI col corpo FUORI dal canale TMA** (lento, veloce, uno dei due o entrambi: input `InpCanale`, default "uno dei due" come il `CHSEL_EITHER` dell'originale) in una delle ultime **30 barre chiuse**; si mostra la più recente;
- **scritta** = **ora della candela** della doji su H1/H4, **giorno della settimana** su D1 (Sun, Mon, ...);
- **VERDE** = doji **sotto** il canale (rialzista), **ROSSO** = doji **sopra** il canale (ribassista);
- l'ora è **ora SERVER** del broker, come le candele del grafico. Su BCM il server è **UTC+1 fisso**: d'estate = ora italiana − 1, d'inverno = ora italiana (CLAUDE.md, 24/09).

La logica di calcolo è **copiata** dall'EA `ABTG_PTE.mq5` (TMA non-repaint, doji, Heikin Ashi a 2 barre di seme) e il collaudo verifica che il testo copiato sia identico.

## 3. ⚠️ La notizia del collaudo: la nostra lettura ACCENDE TROPPE CELLE

Misura **sull'oro HistData** (un simbolo, feed **non BCM**, non la dashboard originale): quota del tempo in cui la cella è accesa.

| impostazione | H1 | H4 | D1 |
|---|---:|---:|---:|
| **default** (HA come l'EA, TMA dell'EA, uno dei due, 30 barre) | 71% | 73% | 69% |
| TMA centrata (la nostra ipotesi dell'originale) | 42% | 46% | 43% |
| candele giapponesi + **entrambi** i canali | 21% | 24% | 22% |
| **schermata di Claudio** (37 simboli, un istante: 7/37, 0/37, 4/37) | **19%** (7) | **0%** (0) | **11%** (4) |

Cosa dice, e cosa **non** dice:
- con i default la nostra tabella sarebbe accesa **da quasi 4 a più di 6 volte più** dell'originale (H1 71% contro 19%, D1 69% contro 11%; H4 73% contro 0%): o la lettura delle celle è diversa, o le barre di ricerca sono meno di 30, o la doji dell'originale è più severa;
- "giapponesi + entrambi i canali" si avvicina all'H1 della schermata, ma è **un indizio, non una prova**: un simbolo contro 37, un istante contro tre anni. **Non ho cambiato i default per inseguire quel numero**: sarebbe tarare a occhio su una foto;
- l'**H4 tutto vuoto** nella schermata è il dato più strano: con una regola "ultime N barre" uguale per tutti i TF, H4 dovrebbe accendersi come H1. Fa pensare a una finestra **a tempo** (es. solo oggi/ieri) o a una condizione in più. Per questo serve la tua risposta alla domanda 2.

E una differenza **certa** da aspettarsi: anche se tutto il resto fosse identico, la TMA dell'EA (non-repaint, quindi **in ritardo di mezzo periodo**) e una TMA centrata (che **ripittura**) danno la **stessa cella solo nel ~59-65% degli istanti** sull'oro. Quindi, anche nel caso migliore, circa 4 celle su 10 possono differire per il solo calcolo del canale. Per vederlo c'è l'input `InpTmaModo = TMA centrata`: è la **nostra ipotesi** di come è fatta l'originale (TMA centrata classica, mezza-lunghezza = periodo, solo barre chiuse), **non** la sua formula.

## 4. Come confrontarla con l'originale (consegnata con riserva: prima F7 a cura di Claudio)

🪟 **Bersaglio: SOLO il terminale MT5 `50503635` (`C:\MT5_MANUALE`), sul VPS.** **Non viene toccato nessun altro terminale** del VPS: né FTMO `1514806751` (`C:\FTMO`, ex `541452707`), né piccolo `50503392`, né 100k `50504263`, né banco `50504400` (`C:\MT5_Backtest`), né Pepperstone, né Tickmill, e **MAI il REALE `10105439` (`C:\BCM_Reale`)**. Prima di toccare una finestra, riconoscila con questa riga (🖥️ **finestra PowerShell sul VPS**, sola lettura, non apre né tocca nessun terminale):

```
Get-Process terminal64 | select Id, MainWindowTitle, Path
```

La finestra giusta è quella con `Path` dentro `C:\MT5_MANUALE` **e** titolo che porta `50503635`. Se il titolo porta un altro numero, sei sul terminale sbagliato: fermati.

✋ Poi, a mano dentro quel terminale:
1. `File > Apri cartella dati > MQL5 > Indicators`: copia `ABTG_PTE_Dashboard_Leggera.mq5`; aprilo in MetaEditor e premi **F7**. Se esce anche un solo errore, mandami il testo: è la prima compilazione di sempre.
2. Sullo **stesso grafico** dove gira l'originale aggiungi la nostra con **`InpOffsetX = 420`** (così sta a destra dell'originale e non si sovrappongono) e **`InpModoConfronto = true`**.
3. Aspetta ~10 secondi (riempimento), poi **una schermata** con le due tabelle affiancate.
4. Ripeti cambiando **un input alla volta** (una schermata per ognuno): `InpCandela = Candele giapponesi` · `InpTmaModo = TMA centrata` · `InpCanale = Entrambi`. Conta le celle uguali su 105: **è una misura**, e ci dice quale lettura è giusta.
5. Passando il mouse su una cella, il tooltip mostra la distanza del corpo dal canale in ATR (> 0 = fuori): dove le due tabelle non coincidono, ci dice se è mancato poco o tanto.

## 5. Cosa NON è provato

- **Compilazione MQL5**: mai fatta. Il collaudo controlla parentesi, firme delle funzioni e numero di argomenti, ma non il compilatore vero.
- **Aspetto grafico**: posizioni, font, colori. Gli angoli diversi da "Left upper" **non sono provati**.
- **Terminale**: `SeriesInfoInteger`, `CopyRates` sui simboli fuori dal Market Watch (con `InpSoloMarketWatch = false` potrebbero restare senza dati), lunghezza massima dei tooltip.
- **Carico reale**: le cifre sopra sono **[STIMA]**, nessuna misura sul tuo terminale.
- **Feed**: i numeri sono sull'oro HistData (orologio +6 h, convenzione di `collaudo_natcla.py`), **non** sul feed BCM.
- **Equivalenza con l'originale**: impossibile senza il sorgente. È esattamente ciò che misura il confronto del punto 4.
- Non implementati, e dichiarati: email/push, pulsanti del grafico (CHART BUTTONS: non sappiamo cosa fanno), frecce, canali e Heikin Ashi disegnati. Gli alert ci sono solo popup/suono, **spenti** come nell'originale.

## 6. Cosa è provato (strato 1, collaudo PASS)

- **Statico**: ASCII puro, parentesi, 36 funzioni MQL5 distinte controllate per firma, nessuna funzione di trading/rete/file/handle, default degli input = specifica, funzioni copiate identiche all'EA.
- **Raccordo**: la copia dei dati sta dietro al controllo "barra nuova"; copia il numero minimo di barre; il grafico si ridisegna solo se qualcosa cambia; gli oggetti si cancellano all'uscita; gli alert scattano solo su segnale nuovo dell'ultima barra chiusa, mai al primo calcolo.
- **Numeri**: la funzione vera (estratta e compilata in C++) sulla **finestra minima** di barre dà **lo stesso risultato** dello specchio Python calcolato sull'intera serie: **0 differenze** su 7 configurazioni x H1/H4/D1 (~96.000 istanti), più i casi scritti a mano (doji al bordo del 10%, ATR, TMA, uscita "stretta" dal canale) e il testo delle celle su 2000 istanti casuali.
- **Contro-esempi**: con 2 sole barre di seme la Heikin Ashi ricorsiva **diverge** (quindi il confronto morde); un ATR "alla Wilder" si distingue dall'iATR di MT5 fino al 25-37%.
- **39 mutanti ciechi su 39 presi** (copie fuori dal repo) nella prima stesura; il cancello (strato 2, 07/10) ne ha scritti altri **28 su righe di raccordo non scelte dall'autore** e **23 erano VERDI** (fra questi: tabella sempre vuota, Market Watch invertito, cursore fermo sulla cella 0, colonna H4 riempita con dati H8, suffisso ignorato). Dopo le ancore aggiunte: **62 mutanti su 62 presi**, poi **66 su 66** dopo le 3 correzioni del lettore indipendente.
- **Correzione del cancello**: se la serie di un simbolo/TF risultava vuota (`SERIES_LASTBAR_DATE` = 0), la cella si rinviava **senza mai chiamare `CopyRates`**, cioè senza mai chiedere al terminale di costruire la serie: se il terminale la costruisce solo su richiesta di una copia, quella cella non si sarebbe **mai** riempita. Ora con la serie vuota si copia (in un indicatore non blocca) e, se torna corta, si rinvia con attesa crescente. Contro-esempio a modello: col terminale "costruisce solo su richiesta" la versione vecchia non si riempie mai in 3 ore, la nuova in 2 s; col terminale "costruisce da sola" le due fanno **le stesse 4 copie**. Quale dei due sia il comportamento vero di MT5 **non è verificato**: la correzione non costa niente in tutti e due i casi.

## 7. Domande a Claudio

1. **Cosa vuol dire davvero una cella accesa** dell'originale? Doji col corpo fuori dal canale? Il colore è la direzione attesa (verde = sotto il canale)? L'ora è quella della **candela della doji**?
2. **Fino a quanto indietro guarda?** Nella schermata l'H1 mostra segnali fino a ~22 ore prima, il D1 fino a 6 giorni, l'**H4 è tutto vuoto**: c'è una finestra a tempo o una condizione in più?
3. **I simboli sono 35 o 37?** Le 5 liste che ho fanno **35** (28 coppie forex + XAUUSD + USOIL + 5 indici). Se l'originale ne mostra 37, quali sono gli altri due? Non li ho inventati.
4. **Quali simboli e quali TF usi davvero?** Se sono meno, la tabella è ancora più leggera.
5. **La doji si cerca sulle candele Heikin Ashi o su quelle giapponesi?** L'originale disegna le HA, ma non sappiamo su quali candele cerca la doji.
6. **Cosa fanno i CHART BUTTONS** dell'originale (aprono il grafico del simbolo cliccato?).
7. Sul terminale `50503635` i simboli hanno un **suffisso** (es. `EURUSD.r`)? Se sì, va messo in `InpSuffisso`.
