# PTE Dashboard LEGGERA: la nostra versione della tabella PTE (07/10/2026)

> **[SUPERATO dalla riga seguente: strato 2 fatto, collaudo ora 186 mutanti] Stato v1.10 (07/10/2026 sera): strato 1 (collaudo) TUTTO OK, **157/157 mutanti presi** (66 della v1.00 + 91 nuovi: click 19, HA/colori 19, doji 16, HIDE 7, REFRESH 7, EMA 13, Supertrend 10; scritti dall'autore, quelli ciechi veri li scrive il cancello). Un mutante era VERDE alla prima corsa (il controllo delle cifre nel nome cliccato): aggiunto il contro-esempio `PDL_s_1/` (senza quel controllo diventerebbe la riga 9), poi preso · strato 2 (`controllo-preventivo`) NON ANCORA FATTO: lo fa la sessione principale, quindi la v1.10 NON è consegnabile finché non torna un PASS.**
> **Strato 2 (`controllo-preventivo`, 07/10 sera): PASS CON RISERVA dopo 3 correzioni meccaniche fatte dal cancello** -- (1) **classe 930**: il click cambiava simbolo/TF anche a un grafico con un **EA** sopra (l'EA si sarebbe riavviato sull'altro strumento): ora con un EA sul grafico **non cambia niente** e lo dice con un `Alert`; (2) **classe 951**: il grafico aperto con `InpClickNuovoGrafico=true` e' sorvegliato 10 s (EA arrivato dal modello `default.tpl` -> `Alert`); (3) **classe 965**: ricalcolo incrementale ancorato all'ora. Il cancello ha scritto **18 mutanti ciechi suoi: 15 presi, 3 VERDI** (OnDeinit che non ripristina al click, spazio dentro il nome del tasto HIDE, chiavi `I` non cancellate -- quest'ultimo innocuo): ancore aggiunte, poi **+9 mutanti sulle correzioni**; collaudo intero rigirato: **183 mutanti** in lista. Serve un **secondo lettore indipendente** sulle tre correzioni (codice nuovo, scritto dal cancello). Classe nuova **1176** in checklist.
> 🪟 **Bersaglio: SOLO il terminale MT5 `50503635` (`C:\MT5_MANUALE`) sul VPS, su un grafico SENZA EA.** Non tocca FTMO `1514806751` (`C:\FTMO`), REALE `10105439` (`C:\BCM_Reale`), piccolo `50503392`, 100k `50504263`, banco `50504400`, Pepperstone, Tickmill (dettaglio e riga di riconoscimento al §4).
> **Mai compilata: qui non c'è MetaEditor.** La v1.00 (commit `5f3e4d0d`) era passata con riserva; la v1.10 è un file nuovo per metà e la sua prima compilazione la fai tu (F7).

File:
- indicatore: `mql5/Indicators/ABTG_PTE_Dashboard_Leggera.mq5` (v1.10)
- collaudo: `backtest_pipeline/collaudo_pte_dashboard_leggera.py` (si rigira con `python3 backtest_pipeline/collaudo_pte_dashboard_leggera.py`)

## 0. Novità della v1.10 — quello che Claudio ha chiesto

Le sue parole: _"NELLA DASHBOARD PTE MANCANO LO SWITCH PER LE CANDELE HEIKENASHI, SE CLICCO SIA SUL SIMBOLO CHE SULL'ORARIO, IL GRAFICO NON MI PORTA LI. POI MI SEGNALAVA LE CANDELE DOJI. VOGLIO CHE LO FAI ESATTAMENTE COM'ERA"_, poi _"C'ERA IL TASTO REFRESH"_, _"IL TASTO HIDE"_, _"IL TASTO DOJI ON/OFF"_, _"DI DEFAULT C'ERANO LE CANDELE HEIKENASHI"_ e _"aggiungi ai tasti INCROCIO EMA 9 E 21 e inserisci il SUPERTREND 3 LIVELLI DI PAOLO LAVORENTI"_.

🔴 **Nessuna di queste funzioni è la formula dell'originale**: il sorgente della `PTE_V3_18` non ce l'abbiamo. Sono la **nostra ricostruzione** da quello che Claudio descrive. "Esattamente com'era" si può ottenere solo confrontando con l'originale: per questo in fondo ci sono le domande e le schermate che servono.

### I tasti (due righe sopra la tabella)

| tasto | cosa fa | di default |
|---|---|---|
| **HIDE / SHOW** | nasconde la tabella; resta visibile **solo** questo tasto per riaprirla. Da nascosta: **nessuna copia di dati e nessun calcolo** della tabella (carico zero). Allo SHOW le celle si ricalcolano subito, come REFRESH | tabella visibile |
| **REFRESH** | azzera la cache di **tutte** le celle (orario prossima barra, attesa, ultima barra, "pronta"); il ricalcolo lo fa il timer **al ritmo normale** (20 celle al secondo): il click **non** copia dati, quindi non blocca il terminale | — |
| **HA ON/OFF** | candele **Heikin Ashi** sul grafico al posto delle native (le native diventano invisibili, colori a "nessuno") | **ACCESO** (come l'originale) |
| **DOJI ON/OFF** | **frecce** sulle doji fuori canale del grafico corrente nelle ultime 30 barre chiuse (stessa regola delle celle), verde sotto = rialzista, rosso sopra = ribassista; **tooltip** con ora e distanza del corpo dal canale in ATR. OFF = frecce tolte e **niente calcolo**. **Le celle della tabella NON cambiano** (decisione nostra: domanda 10) | acceso |
| **EMA 9/21** | le due EMA (chiusura) e una **freccia sull'incrocio**: blu sotto la candela = la 9 passa sopra la 21, magenta sopra = passa sotto | spento |
| **ST 3 LIV** | Supertrend a 3 livelli **2,5 / 3,0 / 3,5**, ATR 10, su HL2; per ogni livello verde sotto il prezzo (su) e arancio/rosso sopra (giù), sottile/medio/spesso | spento |
| **click sul SIMBOLO** | il grafico va su quel simbolo, **TF invariato** | — |
| **click su una CELLA** (anche sull'orario scritto) | il grafico va su **quel simbolo e quel TF** | — |
| **click sul TF dell'intestazione** (H1/H4/D1) | il grafico resta sul simbolo e passa a quel TF | — |

🔴 **Correzione del cancello (strato 2, 07/10 sera) — classe 930: se sul grafico della dashboard gira un EA, il click NON cambia simbolo né TF** (esce un `Alert` che lo dice). Cambiare simbolo a un grafico con un EA lo **riavvia sull'altro strumento**, col suo magic e il suo rischio: sul `50503635` il 27/09 girava `ABTG_ScalperDirezionale` (magic `779901`, XAUUSD M1). La v1.10 dell'autore non aveva questa guardia (che `ABTG_EMA200_Dashboard` e `SuperWave v4.1` hanno già). 👉 **Metti la dashboard su un grafico SENZA EA.**

Input nuovo `InpClickNuovoGrafico` (default `false`): con `true` il click **apre un grafico nuovo** invece di cambiare questo; per ~10 s la dashboard guarda se quel grafico è nato con un EA dentro (dal modello `default.tpl`, classe 951) e, se sì, lo dice con un `Alert`. Un simbolo che non è nel Market Watch viene **aggiunto** (`SymbolSelect`); se non esiste sul broker (suffisso sbagliato?) nel log Esperti esce il motivo.

### Come si comporta al click (cosa succede "dietro")
- Cambiare simbolo/TF del grafico **ricarica l'indicatore** (MT5 lo fa sempre). **Lo stato dei tasti sopravvive**: è in una **GlobalVariable del terminale** `PDLV_<numero del grafico>_...` (stessa tecnica di `ABTG_Pulsanti_Grafico.mq5`). Si cancella quando togli l'indicatore o chiudi il grafico. Se cambi un input "di partenza" (es. `InpHaDefault`), vale il nuovo input.
- **La cache della tabella NON sopravvive** (è un'istanza nuova): dopo ogni click la tabella **si riempie di nuovo in ~6 secondi**. È il prezzo di non leggere/scrivere file. Se ti dà fastidio, dimmelo: si può tenere il disegno vecchio finché arrivano i numeri nuovi.
- MT5 a volte chiude l'istanza vecchia **dopo** aver aperto la nuova: la vecchia allora cancella oggetti e rimette i colori. La v1.10 se ne accorge entro **1 secondo** e ripara (tabella, frecce, candele nascoste). Provato a tavolino con le funzioni vere dei colori, **nei due ordini**.

### ⚠️ Candele Heikin Ashi accese di default: la sicurezza dei colori
- I colori originali delle candele (5: candela su, candela giù, barra su, barra giù, linea) si **salvano PRIMA** di metterli a "nessuno" e si **rimettono** allo switch OFF, alla rimozione dell'indicatore e a **ogni** uscita.
- 🔴 **Se il terminale va in CRASH con HA acceso** (niente uscita pulita), il grafico può riaprirsi **senza candele**. Come recuperarle: **rimetti l'indicatore** (se trova tutte e 5 le proprietà a "nessuno" le rimette visibili con colori di ripiego verde/rosso), oppure a mano **F8 › Colori** e reimposti *Candela rialzista/ribassista*, *Barra su/giù* e *Grafico a linee*.
- Non usare l'HA di questa dashboard **insieme** all'HA di `ABTG_Pulsanti_Grafico` (o di `ABTG_Segnali_EMA_BB_ST`/SuperWave) sullo stesso grafico: due indicatori che nascondono le candele si salvano a vicenda i colori sbagliati.

### Le doji sul grafico: quale candela, e una misura che devi vedere
- **Default dichiarato**: le frecce usano **la regola delle celle** (`InpCandela` = Heikin Ashi "come l'EA", cioè la HA approssimata con 2 barre di seme di `ABTG_PTE.mq5`), così **freccia e cella dicono sempre la stessa cosa**. Le candele HA **disegnate** invece sono la HA classica ricorsiva (quella che si vede su qualunque grafico HA).
- 🔴 **Misura (oro HistData, NON BCM)**: con il default, su **56-69% delle frecce** la candela HA disegnata **non sembra una doji** al 10% (H1 537/964, H4 260/439, D1 50/72). **Contro-esempio**: con `InpCandela = Heikin Ashi ricorsiva` le frecce cadono su una doji disegnata nel **100%** dei casi (H1 899, H4 372, D1 64 frecce, zero eccezioni).
- Quindi se a te le frecce "sembrano sbagliate", **prova `InpCandela = Heikin Ashi ricorsiva`**: è un input, non serve ricompilare. Non ho cambiato il default da solo perché cambierebbe **anche le celle** della tabella (che seguono la stessa regola) e la scelta va fatta guardando l'originale: domanda 11.

### EMA 9/21 e Supertrend: cosa è fonte e cosa no
- **Incrocio EMA**: valutato **solo sulle barre CHIUSE** — barra `x` contro barra `x-1`, freccia sulla barra `x`; la barra in formazione **mai** (una freccia che appare e scompare col prezzo non serve a nessuno). Prime 21 barre dello storico escluse (riscaldamento della EMA). Caso limite dichiarato: se le due EMA sono **esattamente uguali** su una barra, conta come "dalla parte opposta" (con prezzi veri non capita in pratica). EMA identica a `iMA` di MT5 (seme = prima chiusura), testo **copiato** da `ABTG_Pulsanti_Grafico.mq5`.
- **Supertrend**: **lo stesso calcolo, parola per parola**, di `ABTG_Pulsanti_Grafico.mq5` v1.01 (`SW_STCore`) e di `EA_NatCla.mq5` (`NC_STCore`): il collaudo confronta il testo. Etichette:
  - moltiplicatori **2,5 / 3,0 / 3,5** — **[FONTE]** audio WA0090: _"tutti i tre livelli 2.5, 3, 3.5"_;
  - periodo ATR **10** — **[NOSTRA]**: l'audio non lo dice; 10 è l'indizio dello strumento del coach Lavorenti `PL-SUPERTREND 3_LIVELLI V09` (indizio esterno, non fonte: `report/NATCLA_SPECIFICA_2026-10-07.md` r.63-65);
  - formula HL2 ± k × ATR (ATR = media semplice come `iATR`) — **[NOSTRA+CASA]**.
  - ✏️ **Correzione di un'etichetta**: mi era stato chiesto di scrivere _"[FONTE: audio Paolo Lavorenti]"_. In repo gli audio sono **di una collega di Claudio** (`data/natcla/LEGGIMI.md`), che cita Paolo come chi aveva dato il PDF; lo strumento a 3 livelli è del coach Lavorenti. Ho scritto la fonte che il repo documenta. Se gli audio sono davvero di Paolo, dimmelo e cambio l'etichetta.
- **Seme e finestra** (misurati sull'oro): il Supertrend parte dalla barra `periodo` dello storico caricato; ripartendo da 12 punti diversi il valore coincide **bit per bit** con quello dell'intera serie dopo al massimo **53 barre (H1), 42 (H4), 26 (D1)**. La EMA 21 dopo **~240-260 barre** (scarto relativo < 1e-12). Quindi quello che vedi a destra del grafico **non dipende** da quanto storico ha caricato il terminale.

### Carico della v1.10 [STIMA]
- **Tabella**: invariata (solo a barra nuova di ciascun simbolo/TF, ~45 copie all'ora a regime); con **HIDE zero**.
- **Grafico corrente**: nessuna copia di dati (usa gli array del terminale). HA, EMA e Supertrend sono **incrementali**: al caricamento tutto lo storico una volta, poi a ogni tick **solo la barra in formazione** (O(1); il Supertrend 3 × 10 somme). Frecce doji, incroci EMA e canali **solo a barra nuova**. Con HA/EMA/ST **spenti** non si disegnano ma quel calcolo O(1) continua (riaccenderli non richiede di ricopiare lo storico); con DOJI spento le frecce **non si calcolano**.
- **Oggetti**: 260 per la tabella (era 254: +6 tasti) + al massimo 30 frecce doji. Le frecce degli incroci EMA sono **buffer** (possono essere centinaia sullo storico: niente oggetti).
- **Dimensione del file**: ~1.700 righe (era 820). Non è un problema di carico (il terminale esegue solo quello che serve), ma **lo split è possibile e lo propongo come opzione**: `ABTG_Pulsanti_Grafico.mq5` ha **già** EMA 9/21, Supertrend 3 livelli e HA (stesse funzioni, copiate). Se usi già Pulsanti su quel grafico, la dashboard potrebbe restare "tabella + doji + click" e lasciare EMA/ST/HA a Pulsanti. Non ho tolto niente: decidi tu (domanda 12).

### Cosa NON è provato nella v1.10 (oltre a "mai compilata")
- **Click**: che MT5 mandi `CHARTEVENT_OBJECT_CLICK` per etichette e rettangoli **non selezionabili** (è la pratica comune, non l'ho visto su un terminale); che `ChartSetSymbolPeriod` ricarichi l'indicatore come descritto.
- **Cambio di tipo del disegno** (`PLOT_DRAW_TYPE`) a indicatore acceso: lo usiamo per accendere/spegnere HA/EMA/ST senza ricalcolare; se il terminale non lo ridisegna subito, si vedrà al tick successivo.
- **HIDE** con `OBJ_NO_PERIODS`: gli oggetti restano ma non si vedono; non provato su un terminale.
- **Guardia EA (classe 930) e sorveglianza del grafico nuovo (951)**: provate a tavolino (ancore + mutanti), non su un terminale; che `CHART_EXPERT_NAME` di un grafico appena aperto sia leggibile entro 10 s e' [NON VERIFICATO], come in `ABTG_Confluenza_Dashboard`.
- **Ancora all'ora del ricalcolo incrementale (classe 965)**: se lo storico scorre senza che MT5 passi `prev_calculated = 0`, HA/EMA/Supertrend si ricalcolano da zero. Contro-esempio a modello (scratchpad del cancello): buffer che NON scorrono col dato -> senza ancora la HA sbaglia fino a 24,5 punti, con ancora 0; buffer che scorrono -> 0 e 0. Quale dei due sia MT5: [NON VERIFICATO]; l'ancora costa un confronto.
- **Persistenza** della GlobalVariable dopo un **riavvio** del terminale: il numero del grafico potrebbe cambiare → si riparte dagli input [NON VERIFICATO], come in Pulsanti.
- **Aspetto**: posizione e larghezza dei tasti (3 per riga, 96 pixel coi default), frecce, colori.
- **Feed**: tutte le misure sono sull'oro HistData, non sul feed BCM.

### Elenco dei tasti dell'originale (da Claudio) e cosa abbiamo fatto
| nell'originale (parole di Claudio) | nella v1.10 |
|---|---|
| switch candele Heikin Ashi (acceso di default) | **HA ON/OFF**, acceso di default |
| REFRESH | **REFRESH** |
| HIDE | **HIDE/SHOW** |
| DOJI ON/OFF | **DOJI ON/OFF** (solo frecce sul grafico) |
| click su simbolo e orario → il grafico ci va | **click** su simbolo, cella, TF |
| (aggiunta di Claudio, non dell'originale) | **EMA 9/21** con incrocio, **ST 3 LIV** |
| altri? | **domanda 9** |

---

# Sezioni della v1.00 (restano valide per la TABELLA; dove la v1.10 cambia qualcosa è scritto)

## 1. Cosa fa

Disegna la stessa tabella della `PTE_V3_18 3.18` (finestra in alto a sinistra, colonne **PAIR / H1 / H4 / D1**, le 5 liste di simboli dell'originale), ma con carico minimo:

- **solo visione**: nessun ordine, nessuna rete, nessun file, **zero handle** di indicatori;
- **calcola solo quando un simbolo/TF chiude una barra**, mai a ogni tick (timer di 1 secondo e orario della prossima barra tenuto in memoria);
- copia **il minimo di barre** che serve (131 con i default: ATR lento 100 + 30 barre di ricerca + 1);
- **254 oggetti** nella v1.00 (**260** nella v1.10: +6 tasti) (35 simboli x 3 TF) creati una volta sola; un oggetto viene toccato solo se cambia testo o colore, e il grafico si ridisegna solo in quel caso;
- ~~niente frecce, niente candele Heikin Ashi disegnate, niente canali disegnati~~ — **superato dalla v1.10** (§0): ora ci sono tasti HA, DOJI, EMA 9/21, ST 3 LIV, REFRESH, HIDE e il click; i canali TMA disegnati restano un input spento (`InpDisegnaCanali`).

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
2. Sullo **stesso grafico** dove gira l'originale (🔴 **un grafico SENZA EA**: se in alto a destra c'è il nome di un EA, scegline un altro) aggiungi la nostra con **`InpOffsetX = 420`** (così sta a destra dell'originale e non si sovrappongono), **`InpModoConfronto = true`** e — novità v1.10 — **`InpHaDefault = false`**: l'originale disegna già le sue Heikin Ashi, e due indicatori che nascondono le candele sullo stesso grafico si pestano i colori.
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
- Non implementati, e dichiarati: email/push, eventuali altri CHART BUTTONS dell'originale che Claudio non ha ancora descritto (domanda 9). Frecce, HA, canali e i tasti descritti da Claudio ci sono dalla v1.10. Gli alert ci sono solo popup/suono, **spenti** come nell'originale.

## 6. Cosa è provato (strato 1, collaudo PASS)

- **Statico**: ASCII puro, parentesi, 36 funzioni MQL5 distinte controllate per firma, nessuna funzione di trading/rete/file/handle, default degli input = specifica, funzioni copiate identiche all'EA.
- **Raccordo**: la copia dei dati sta dietro al controllo "barra nuova"; copia il numero minimo di barre; il grafico si ridisegna solo se qualcosa cambia; gli oggetti si cancellano all'uscita; gli alert scattano solo su segnale nuovo dell'ultima barra chiusa, mai al primo calcolo.
- **Numeri**: la funzione vera (estratta e compilata in C++) sulla **finestra minima** di barre dà **lo stesso risultato** dello specchio Python calcolato sull'intera serie: **0 differenze** su 7 configurazioni x H1/H4/D1 (~96.000 istanti), più i casi scritti a mano (doji al bordo del 10%, ATR, TMA, uscita "stretta" dal canale) e il testo delle celle su 2000 istanti casuali.
- **Contro-esempi**: con 2 sole barre di seme la Heikin Ashi ricorsiva **diverge** (quindi il confronto morde); un ATR "alla Wilder" si distingue dall'iATR di MT5 fino al 25-37%.
- **39 mutanti ciechi su 39 presi** (copie fuori dal repo) nella prima stesura; il cancello (strato 2, 07/10) ne ha scritti altri **28 su righe di raccordo non scelte dall'autore** e **23 erano VERDI** (fra questi: tabella sempre vuota, Market Watch invertito, cursore fermo sulla cella 0, colonna H4 riempita con dati H8, suffisso ignorato). Dopo le ancore aggiunte: **62 mutanti su 62 presi**, poi **66 su 66** dopo le 3 correzioni del lettore indipendente.
- **Correzione del cancello**: se la serie di un simbolo/TF risultava vuota (`SERIES_LASTBAR_DATE` = 0), la cella si rinviava **senza mai chiamare `CopyRates`**, cioè senza mai chiedere al terminale di costruire la serie: se il terminale la costruisce solo su richiesta di una copia, quella cella non si sarebbe **mai** riempita. Ora con la serie vuota si copia (in un indicatore non blocca) e, se torna corta, si rinvia con attesa crescente. Contro-esempio a modello: col terminale "costruisce solo su richiesta" la versione vecchia non si riempie mai in 3 ore, la nuova in 2 s; col terminale "costruisce da sola" le due fanno **le stesse 4 copie**. Quale dei due sia il comportamento vero di MT5 **non è verificato**: la correzione non costa niente in tutti e due i casi.

### 6-bis. Cosa è provato nella v1.10 (strato 1, collaudo PASS, 157/157 mutanti)
- **Struttura**: 32 buffer / 15 plot, ogni `SetIndexBuffer` all'indice giusto col tipo giusto (dati / colore / calcolo), tipo e colore di ogni plot.
- **Click**: `PD_Bersaglio` vera (compilata in C++) su **tutte le 105 celle**, i 35 simboli, i TF e **31 nomi da rifiutare** (tasti, titolo, frecce, indici fuori tabella, nomi storti). **Contro-esempio riga/colonna scambiata**: `PDL_r_2_1` deve dare simbolo 2 / TF 1, non 1 / 2; `PDL_t_2_34` (colonna 34 inesistente) va rifiutata e non letta come riga 34. Il raccordo (simbolo dalla RIGA, TF dalla COLONNA, `SymbolSelect`, grafico nuovo o questo) è ancorato.
- **Colori**: le funzioni VERE (`ColsHide`, `ColsRestore`, `RepairInvisibleNative`, `CuraColori`...) estratte e compilate su un **grafico finto con due istanze**: HA di default ON e rimozione, ricarico da click **nei due ordini**, crash, toggle; `clrNONE` letto come 4294967295 e come -1 → **14/14**. Il mutante "HA di default ON che dimentica di salvare i colori" è preso.
- **HA disegnata**: incrementale come `OnCalculate` (barra in formazione prima provvisoria poi vera) == HA ricorsiva dell'intera serie; **contro-esempio** `da = prev_calculated` (senza -1): resta la barra provvisoria.
- **Doji sul grafico**: `PD_Marca` == tutte le doji dello specchio nelle 30 barre chiuse, la prima == la cella, mai la barra in formazione (oro H1/H4/D1, 3 configurazioni, 0 differenze).
- **EMA 9/21** e **Supertrend 2,5/3,0/3,5**: bit per bit con uno specchio Python indipendente; testo identico a `ABTG_Pulsanti_Grafico.mq5` (e `NC_STCore` di `EA_NatCla.mq5`); incrocio == regola scritta su tutte le barre.
- **REFRESH / HIDE / DOJI OFF**: ancore + mutanti (una sola cache azzerata, copia in blocco nell'handler, HIDE che nasconde il suo tasto, HIDE che continua a copiare, DOJI OFF che lascia le frecce o le calcola lo stesso): **tutti presi**.

## 7. Domande a Claudio

1. **Cosa vuol dire davvero una cella accesa** dell'originale? Doji col corpo fuori dal canale? Il colore è la direzione attesa (verde = sotto il canale)? L'ora è quella della **candela della doji**?
2. **Fino a quanto indietro guarda?** Nella schermata l'H1 mostra segnali fino a ~22 ore prima, il D1 fino a 6 giorni, l'**H4 è tutto vuoto**: c'è una finestra a tempo o una condizione in più?
3. **I simboli sono 35 o 37?** Le 5 liste che ho fanno **35** (28 coppie forex + XAUUSD + USOIL + 5 indici). Se l'originale ne mostra 37, quali sono gli altri due? Non li ho inventati.
4. **Quali simboli e quali TF usi davvero?** Se sono meno, la tabella è ancora più leggera.
5. **La doji si cerca sulle candele Heikin Ashi o su quelle giapponesi?** L'originale disegna le HA, ma non sappiamo su quali candele cerca la doji.
6. ~~Cosa fanno i CHART BUTTONS~~ — risposta di Claudio: click su simbolo/orario apre il grafico; tasti HA, REFRESH, HIDE, DOJI ON/OFF (v1.10). Restano le domande 8-14 qui sotto.
7. Sul terminale `50503635` i simboli hanno un **suffisso** (es. `EURUSD.r`)? Se sì, va messo in `InpSuffisso`.

### Domande nuove per la v1.10 (per farla "esattamente com'era")
8. 📸 **Due schermate dell'originale, per favore**: (a) un grafico con **le doji segnalate** (si deve vedere com'è il segno: freccia, pallino, rettangolo? sopra/sotto la candela? colore?) e (b) il **pannello Input completo** dell'indicatore (tutte le schede scorrendo): così riproduco **nomi e valori** dei parametri invece di inventarli.
9. **C'erano altri tasti** oltre a HA, REFRESH, HIDE, DOJI ON/OFF e al click su simbolo/orario? E **a cosa serviva ciascuno**, in una riga? (es. REFRESH ricalcolava solo la tabella o anche il grafico? HIDE nascondeva anche le frecce sul grafico o solo la tabella?)
10. **DOJI OFF spegneva anche le celle accese della tabella**, o solo i segni sul grafico? Nella v1.10 spegne **solo i segni sul grafico**.
11. Nell'originale le doji si cercavano **sulle candele Heikin Ashi** (quelle disegnate) **o sulle giapponesi**? La misura del §0 dice che con la HA "come l'EA" più di metà delle frecce cade su candele HA che a occhio non sono doji; con la HA classica coincidono tutte. La tua risposta decide il default.
12. Usi già **`ABTG_Pulsanti_Grafico`** sullo stesso grafico? Se sì, EMA 9/21, Supertrend 3 livelli e HA ci sono già lì: preferisci la dashboard **solo tabella + doji + click** (più leggera) o **tutto in uno** come adesso?
13. Il click: deve cambiare **questo** grafico (default) o **aprirne uno nuovo** (`InpClickNuovoGrafico = true`)? E dopo un click la tabella si riempie di nuovo in ~6 s: ti va bene?
14. **Supertrend 3 livelli "di Paolo Lavorenti"**: gli audio in repo sono di una tua collega che cita Paolo; lo strumento con ATR 10 è il `PL-SUPERTREND 3_LIVELLI V09`. Il periodo ATR **10** e il calcolo su **HL2** sono quelli di Paolo? Se hai una schermata del suo pannello Input, risolve tutto.


> **Lettore indipendente (08/10): PASS CON RISERVA sulle tre correzioni** -- il codice e' giusto (compila a tavolino, indice `time[prev_calculated-1]` protetto da `!pieno`, guardia EA solo sul grafico corrente). 3 dei 12 mutanti suoi sulla sorveglianza del grafico nuovo restavano verdi (Alert ripetuti ogni secondo; lista mai compattata; overflow di `gNuovoN` -> indice 8 fuori range): ancore e mutanti aggiunti al collaudo (186 in lista). Limite dichiarato: oltre 8 grafici aperti dal click entro 10 s si scarta il piu' vecchio.
