# The Gold Reaper MT5 (v5.1): PIANO DI LANCIO "R2" DELLA SCATOLA NERA, prima passata G0 (10/10/2026)

**BOZZA, NON passata dal cancello** (`controlla_riga.py` sulla riga `RIGA_TROVA_GOLD_REAPER.txt` e' stato fatto dallo sviluppatore come autoverifica; `verificatore-stringhe` e `controllo-preventivo` NON ancora invocati). **Nulla di quanto scritto qui e' stato eseguito.** Non e' una consegna a Claudio: e' un documento di lavoro per domani mattina, da rileggere dopo il PASS.

Dossier di riferimento (da leggere prima, e **anch'esso non passato dal cancello**): `report/MARKET_GOLD_REAPER_2026-10-10.md` (sezioni 4, 6, 8). Questo file ne **estrae e precisa** il piano di scatola nera nel tester (il dossier lo chiama "Fase A/B"; qui e' "R2" e si descrive solo la **prima passata G0** e il suo contorno).

Etichette, come nel dossier: **[VERIFICATO]** letto oggi su un file del repo, con il nome · **[DICHIARATO DA TERZI]** · **[DERIVATO]** aritmetica su numeri letti · **[INFERITO]** deduzione con la ragione · **[NON SO]** non ricavabile dal solo repo.

---

## 0. In breve

1. **Prima di tutto si chiarisce DOVE sta il demo.** La riga `backtest_pipeline/righe/RIGA_TROVA_GOLD_REAPER.txt` (sola lettura, un'unica riga) stampa il nome del PC e, per ogni cartella dati MT5 sotto `AppData`, a quale terminale appartiene e se contiene un `.ex5` con "Gold" o "Reaper" nel nome. Senza il suo esito **non si lancia niente** (sez. 1).
2. **Il demo NON gira mai sul VPS.** Per la firma di Claudio del 21/09 i round girano sul PC di backtest (`DESKTOP-H4D7CAJ`); se la riga dice che il demo e' sul VPS, **si ferma tutto** e si porta il demo sul PC di backtest (sez. 1.3).
3. **Solo Strategy Tester, mai su un grafico.** Il terminale BCM del PC di backtest e' loggato sul demo `50503392` (lo stesso numero del "piccolo" del VPS, con sedie vive) e da quella macchina il 14/08/2026 sono partiti ordini VERI [VERIFICATO: `backtest_pipeline/controlla_riga.py`, tabella `BERSAGLI_PER_MACCHINA`]. Trascinare il demo su un grafico lo farebbe operare su un conto vero (demo, ma vivo) (sez. 2).
4. **G0** = default venduti, due volte identica, XAUUSD H1, tick reali, dal 2025.03.01, deposito 100.000, grafico spento. Risponde a: *apre operazioni? e' deterministico? quanto costa una passata?* (sez. 3).
5. **Le attese sono scritte PRIMA** (sez. 5), con l'ipotesi alternativa accanto e il modo di falsificarle.
6. **Lecito/non lecito** e **cosa non si puo' sapere dal solo repo** sono alle sez. 6 e 9. Niente decompilazione, niente estrazione di stringhe dal `.ex5`, niente URL autorizzati, niente aggiramenti.

---

## 1. PASSO ZERO: dove sta il demo (le tre domande a, b, c)

### 1.1 Che cosa e' gia' noto e che cosa no
| punto | stato |
|---|---|
| (a) su quale PC e' il demo | **[NON SO].** La riga `RIGA_IDENTIFICA_TERMINALI.txt` (PASS) ha detto a Claudio che il PC su cui lavora stasera e' `DESKTOP-H4D7CAJ` (PC di backtest). Ma il demo **potrebbe essere stato scaricato dal terminale del VPS** (il "piccolo" 50503392, con sedie vive): le due macchine hanno **lo stesso percorso** del terminale BCM, quindi lo stesso nome della cartella dati (vedi 1.2). Il nome del PC, stampato dalla riga, e' l'unico modo per distinguere |
| (b) il file `.ex5` nel Market | **[NON SO]** come si chiami. Nel dossier il titolo e' "The Gold Reaper MT5" (barra del titolo dello screenshot: "The Gold Reaper MT5 5.1 (XAUUSD,H1)"); il nome del file in `MQL5\Experts\Market\` e' un'altra cosa e **non e' scritto in nessun file del repo** |
| (c) il demo gira nel tester | **[NON SO].** Il dossier lo dice due volte: lo screenshot e' la finestra delle proprieta' di un EA su grafico, **non** il pannello del tester; le regole del Market sul demo vengono da estratti di forum, non dal regolamento (dossier sez. 6.1 e 8 punti 2 e 6). Si verifica con G0, non si assume |

### 1.2 Perche' il nome della cartella dati NON basta a dire il PC (verificato, con un contro-esempio)
La cartella dati MT5 sotto `AppData\Roaming\MetaQuotes\Terminal\` ha per nome l'MD5 del percorso di installazione scritto in maiuscolo e in UTF-16 LE. **Verificato oggi, rifacendo il calcolo** sui tre hash gia' scritti nel repo da qualcun altro (`backtest_pipeline/righe/RIGA_TROVA_POSTNEWS.ps1`): `C:\Program Files\BCM Markets MT5 Terminal` -> `215D85D767A1C39E22D242C8114BF9F5`, `C:\Program Files\BCM Markets MT5 Terminal -V3` -> `BCA8AD18563BF5B64A433C2662D0A104`, `C:\BCM_Reale` -> `E23E1504A8D02A22179395F0652B86B6`: **tutti e tre tornano**.
Conseguenza: sul PC di backtest il terminale BCM ha **lo stesso hash** del "piccolo" del VPS. **Se la riga stampa `215D85D7...` NON dice su quale macchina siamo: lo dice il nome del PC.** E' per questo che la riga stampa il PC per primo, con il verdetto, e che l'etichetta della cartella dipende dal PC.

### 1.3 Come si legge l'esito della riga (decisione scritta prima)
**Bersaglio della riga:** finestra PowerShell, sul PC su cui Claudio ha scaricato (o crede di aver scaricato) il demo. Se non sa su quale, la lancia **una volta su ciascuno dei due PC** (stessa riga, nessun effetto).

| il nome del PC e' | e la riga trova il `.ex5` Gold/Reaper in | allora |
|---|---|---|
| `DESKTOP-H4D7CAJ` (PC di backtest) | la cartella con hash `215D85D7...` (terminale BCM del PC di backtest) | **ok**: si va a G0 (sez. 3). Si annota il percorso completo stampato |
| `VMI3047753` (VPS) | qualunque cartella | **STOP.** Il demo e' sul VPS (probabilmente sul piccolo 50503392, sedie vive): **non si lancia nessun tester li'** (21/09). Si scarica di nuovo il demo sul PC di backtest, **dal terminale BCM del PC di backtest**, con lo stesso account MQL5 (15-20 minuti, spesa zero, dossier sez. 6.6). Il file sul VPS **non si sposta e non si copia** (un `.ex5` del Market e' legato a quell'installazione e al venditore: copiarlo e' fuori perimetro, sez. 6) |
| `DESKTOP-H4D7CAJ` | nessuna cartella ma "origin.txt illeggibili > 0" o cartelle dati con nomi non in elenco | si legge a mano il percorso stampato: potrebbe essere un terminale che la tabella non conosce (portable, o un altro BCM). Non si indovina |
| qualunque | nessun file Gold/Reaper in nessuna cartella elencata | **non prova che il demo non esista**: puo' stare su un terminale portable (invisibile da `AppData`) o nel terminale del conto REALE, che la riga **non elenca** per scelta. Si rilancia sull'altro PC; se nemmeno li' c'e', Claudio scarica il demo dal terminale BCM del PC di backtest |
| qualunque | un file con Gold ma non Reaper (ad es. un altro prodotto) | **non e' questo EA.** Nel dossier esiste un omonimo (l'indicatore 178260) e un altro EA "Gold Scalper Pro" analizzato lo stesso giorno: la colonna `Gold_Reaper` della riga dice `solo Gold` / `solo Reaper` / `Gold+Reaper` proprio per questo |

### 1.4 Cosa la riga NON dice (dichiarato)
- Non vede i terminali **portable** (non hanno cartella sotto `AppData`).
- Non apre il `.ex5`, quindi **non ne verifica il contenuto ne' la versione** (v5.1): la versione si legge dalla finestra del tester (titolo delle proprieta', come nello screenshot: "5.1") o dal giornale del tester, **non dal nome del file** [NON SO se il nome la contiene].
- Non dice se il demo e' ancora valido/attivo, ne' se il terminale era aperto: legge solo directory e il testo di `origin.txt`.
- `origin.txt` e' scritto da MT5 in UTF-16; la riga lo legge con `Get-Content` e toglie i caratteri nulli, quindi regge sia con BOM sia senza. **Non e' stata lanciata su Windows 5.1**: e' stata collaudata solo su pwsh 7 su un albero finto (sez. 8).

---

## 2. Il bersaglio per le azioni a mano e i rischi (regola dei terminali multipli e del 12/09)

> 🪟 **BERSAGLIO di tutti i gesti manuali di questo piano (dopo l'esito di 1.3):** il terminale MT5 **BCM del PC di backtest** — PC `DESKTOP-H4D7CAJ`, cartella programma `C:\Program Files\BCM Markets MT5 Terminal`, loggato sul demo **50503392**.
> **NON toccati:** i terminali del VPS `VMI3047753` (il piccolo con lo stesso percorso e lo stesso conto 50503392 con sedie vive, il 100k 50504263, il reale 10105439, FTMO 541452707, il banco 50504400, il manuale 50503635).

1. **Prima di ogni gesto a mano in MT5**, per la regola del 06/09, Claudio **non riconosce la finestra a occhio**: lancia la riga di sola lettura gia' passata `RIGA_IDENTIFICA_TERMINALI.txt`, che stampa PID + titolo + cartella dei terminali aperti. Quello stampato e' il fatto (🖥️ finestra PowerShell sul PC di backtest).
2. **Il conto del terminale del PC di backtest e' 50503392**, lo stesso numero del piccolo del VPS (sedie vive). Un EA trascinato su un grafico di QUELLA finestra opererebbe sul conto **50503392**, cioe' sullo stesso conto su cui il piccolo del VPS ha le sedie vive (stesse posizioni, stesso saldo). **Quindi: il demo si usa SOLO dal pannello Strategy Tester, mai trascinato su un grafico, mai con "Algo Trading" acceso per lui.** Il tester non invia ordini al server.
3. **Il tester a tick reali occupa le CPU del PC di backtest.** Non si lancia mentre gira un altro round o una passata sullo stesso PC (si apre la scheda "Agenti" del tester e si guarda che non ci sia altro in corso) [NON SO cosa stia girando stasera su quel PC].
4. **Nessuna riga di lancio e' scritta qui**: questo piano e' di azioni a mano nel pannello, piu' la riga di sola lettura della sez. 1. La riga di **raccolta** (copiare report e giornale sul Desktop e fare lo zip, regola dell'11/08) si scrive **dopo** l'esito della riga TROVA, perche' nomina i percorsi veri, e passa dal cancello come tutto il resto (sez. 4.3).

---

## 3. La prima passata: G0 (azioni a mano nel pannello del Strategy Tester)

**Scopo, scritto prima:** (i) vedere **se il demo apre operazioni** nel nostro tester (se no: il canale e' nullo, si ferma, spesa zero); (ii) **se due lanci identici danno le stesse cifre** (determinismo, come il controllo "G0" gia' implementato in `backtest_pipeline/leggi_gba_r0.py` r.871-895: stesso n, profitto, PF, DD **e stessi affari**, id esclusi); (iii) **misurare quanto costa una passata** (decide le altre 11). **NON** e' un giudizio di merito: un solo regime (toro dell'oro).

### 3.1 Impostazioni (pannello "Impostazioni" del tester)
Valori **in stile dei round di casa** (`backtest_pipeline/gen_ini.py` r.57-70 e `GBA_R0_PASSATE.ps1` r.648: Currency EUR, Leverage 100, ExecutionMode 0, Optimization 0). I nomi delle voci nell'interfaccia italiana sono **[NON SO] salvo "Ogni tick basato su tick reali"**, che e' scritto cosi' in `CLAUDE.md`: Claudio li legge sullo schermo, non si fida del mio elenco.

| voce | valore | note |
|---|---|---|
| Expert Advisor | il demo trovato dalla riga (nome del file stampato) | **[NON SO il nome]**: dalla finestra apparira' probabilmente sotto `Market\...` |
| Simbolo | `XAUUSD` | nome del simbolo BCM per l'oro, come nei round R19/R134b e GBA [VERIFICATO nei .ini del repo] |
| Timeframe | **H1** | raccomandato dal venditore (dossier 3.2). Il periodo del grafico del tester **non** dovrebbe contare ("il grafico non conta", dichiarato dal venditore): [DICHIARATO DA TERZI], non verificato |
| Date | personalizzata, **2025.03.01 -> 2026.10.09** (ultimo venerdi' chiuso) | 2025.03.01 e' il pavimento **dimostrato** di tick reali sull'oro in R19 (151 operazioni, `prove/R134b_scatolaoro_XAUUSD.txt`). I giornali di R1A dicono che i tick BCM sull'oro **iniziano il 2024.07.10** (`report/GBA_R2_PIANO_2026-10-10.md` sez. 6.3): quindi si potrebbe partire prima, ma resta **[NON MISURATO]** per questo EA; si parte da 2025.03.01 come da compito. Tutta la finestra e' **dopo** il cambio d'orologio BCM (UTC+1 fisso dal 02/02/2025 al piu' tardi, `report/OROLOGIO_BCM_2026-09-24.md`), quindi l'ora server e' coerente su tutto l'arco |
| Forward | No | |
| Ritardi / modo di esecuzione | **nessun ritardo** (ExecutionMode 0, come tutti i round) | |
| Modellazione | **Ogni tick basato su tick reali** (Modello 4) | |
| Deposito | **100000** | come R19. La valuta e' quella del conto: **EUR nei report del repo** (`Valuta: EUR`). Quindi i P/L del report sono in EUR, mentre SL/TP/prezzi dell'oro sono in dollari per oncia: **non si mescolano** (sez. 4.1) |
| Leva | **1:100** | come i round di casa. Il segnale del venditore gira a 1:500 (dossier 3.4): [NON SO] se la leva cambia il lotto o gli ordini rifiutati (`CheckMargin` e' true) |
| Ottimizzazione | disabilitata | |
| Visualizzazione | **spenta** (grafico spento) | il tester va piu' veloce. Il default `update infopanel during testing=false` e' coerente |

### 3.2 Dati in ingresso (scheda "Dati in ingresso")
**Tutti i default venduti**, nessuna modifica. Prima di premere Start, Claudio manda lo **screenshot della scheda "Dati in ingresso"** (tutta, scorrendo) e quello di "Impostazioni": servono a confermare che i default del tester sono quelli dello screenshot del 10/10 (dossier sez. 2: 69 input; Auto, Max Total DD 30, Weighted true, OnlyUp true, Daily DD 0, Friday stop 25, NFP filtro true con offset 2/3, Backtest Speed normal).
Il report del tester, a fine passata, **riscrive gli input usati** nella sezione "Impostazioni" (verificato su un report di casa: `risultati_archivio/GBA_R0_R1A_20261010/GBA_R0_R1A.zip`, `report\GBA_R0_R1A_01_REPL_T1_m775800.htm`), quindi lo screenshot e' una doppia garanzia, non l'unica.

**Difetto noto e dichiarato di G0:** le finestre del filtro NFP usano gli offset `2` (inverno) e `3` (estate), mentre BCM e' UTC+1 fisso: le finestre intorno ai dati USA del primo venerdi' del mese **slittano di 1-2 ore** (dossier 6.2). G0 resta "i default venduti" come da compito; l'effetto si isola dopo, con una passata a offset 1/1 oppure filtri OFF (dossier 6.2). **Non e' una conclusione: e' una passata in piu' da fare.**

### 3.3 Il lancio, due volte
1. Messo a posto tutto, Start. **Annotare l'orario di inizio** e fermarsi a leggere il **giornale** (scheda "Giornale") quando compaiono le prime righe: cosa dice del demo? Se il giornale dice che il demo non puo' girare / che le funzioni web sono bloccate / un messaggio di licenza, **non si autorizza nessun URL** (sez. 6): si annota il testo **per intero** e si ferma la passata.
2. **Criterio di stop scritto prima:** se dopo il primo mese simulato (o dopo 5 minuti reali) i deal sono **zero**, non si aspetta la fine: si ferma e si manda lo screenshot del giornale. Se il giornale non da' segnali di vita (nessuna riga di inizializzazione), idem.
3. Fine passata: **dalla riga "Test passed in ..." del giornale** si legge la durata. Dal report: **"Qualita' dello Storico"** deve dire **"100% ticks reali"** (come nei report di casa); se dice altro, la passata **non e' a tick reali** e non si legge.
4. **Seconda passata, identica** (stessa finestra, stessi input). Nessuna modifica fra le due. Se il demo salva uno stato fra una passata e l'altra (il manuale dice che `OnlyUp` salva il picco di saldo in una variabile globale, v4.4: dossier 4.3), le due passate potrebbero differire per **questo** e non per rumore: [NON SO] se il tester azzera le variabili globali fra le passate. **Se differiscono, non si conclude "non deterministico": si guarda prima il giornale per righe di lettura dello stato**, e si annota la differenza (primo affare che differisce, scarto di profitto).

### 3.4 Che cosa si salva e dove
Per ciascuna delle due passate, **a mano**:
- il **report** (HTML) dal tasto destro sulla scheda dei risultati ("Rapporto" / "Report", voce di salvataggio in HTML: **etichetta esatta [NON SO]**, si legge sullo schermo). E' il formato che i nostri lettori gia' leggono (`leggi_gba_r0.py`, UTF-16, con la tabella **Ordini** e la tabella **Operazioni**). Nomi consigliati: `GR_G0a_default_XAUUSD_H1_20250301.htm` e `GR_G0b_...`.
- il **giornale** della passata. Due vie, la seconda e' la piu' sicura: copiare il testo dalla scheda "Giornale" (puo' essere lungo) **oppure** copiare il file del giorno da `<cartella dati>\Tester\logs\` (la cartella dati e' quella stampata dalla riga TROVA, col suo hash).
- gli **screenshot** di sez. 3.2 e uno del riepilogo finale (profitto, PF, n, DD, durata).
- **Dove**: una cartella sul Desktop del PC di backtest (crearla a mano, es. `GOLD_REAPER_R2`), per la regola dell'11/08. **Non** copiare il `.ex5` (sez. 6).

### 3.5 Quali file mi servono per leggerli (elenco secco)
| # | file | a cosa serve | se manca |
|---|---|---|---|
| 1 | **uscita completa della riga TROVA** (testo copiato o screenshot) | PC, terminale, nome del file, se il demo c'e' | non si parte |
| 2 | **report HTML di G0a** (e G0b) | n, PF, DD, **tabella Ordini** (tipo, volume "eseguito / richiesto", S/L, T/P, ora, stato, commento) e **tabella Operazioni** | non si estrae niente |
| 3 | **giornale** di G0a (e G0b) | durata ("Test passed in"), righe del demo (licenza, web, errori d'ordine, messaggi `Print`), "ticks data begins from" | durata e anomalie restano [NON MISURATE] |
| 4 | **screenshot** Impostazioni + Dati in ingresso (+ riepilogo) | conferma dei default e della versione "5.1" | il report li riscrive, quindi non blocca |

Se i file sono pochi e piccoli (decine di KB / qualche MB), basta **allegarli in chat**: la riga di raccolta serve solo se si vuole lo zip automatico.

---

## 4. Cosa si estrae (da questo e dai passi successivi), e come

### 4.1 Dove sta ogni misura nel report (verificato sul formato, non sul demo)
La tabella **Ordini** del report BCM italiano ha le colonne: *Orario di Apertura · Ordine · Simbolo · Tipo · Volume ("eseguito / richiesto") · Prezzo · S / L · T / P · Ora · Stato · Commento* [VERIFICATO su `risultati_archivio/GBA_R0_R1A_20261010/GBA_R0_R1A.zip` e su `risultati_archivio/ROUND_CORTI_A_2026-09-28/CCOMM_R258/CCOMM_R258.htm`, dove compaiono righe `sell stop` con stato `filled` e `buy stop` con stato `canceled`]. Il **Commento** porta il testo dell'EA (nei nostri report: "GBA_L", "sl 4038.85" a chiusura da SL). Quello del demo e' **[NON SO]**: il manuale dice che ogni trade porta l'ID della strategia nel commento (dossier 3.3).

| misura | da dove | calcolo |
|---|---|---|
| **tipo d'ordine** | Ordini: `Tipo`, `Stato` | conteggi per tipo (buy, sell, buy stop, sell stop, limit) e per stato (filled / canceled / expired) |
| **SL/TP in dollari** | Ordini: `Prezzo`, `S / L`, `T / P` | `|Prezzo - SL|` e `|TP - Prezzo|` **in unita' di prezzo** (USD per oncia), per ordine. **Non** in euro |
| **SL/TP in % del prezzo** | stesse | `|Prezzo - SL| / Prezzo` |
| **SL/TP in multipli di ATR** | stesse + **le NOSTRE barre H1** XAUUSD | ATR(14) H1 sull'ultima barra **chiusa** prima dell'ordine, calcolato da noi (non quello dell'EA, che non vediamo). Dati: barre nostre (HistData M1 in repo e/o export BCM) |
| **orari** | Ordini: `Orario di Apertura` (piazzamento) e `Ora` (riempimento) | distribuzione per **ora server** e giorno della settimana. Ora server BCM: italiana -1 d'estate, = italiana d'inverno dal 2025 (`OROLOGIO_BCM_2026-09-24.md`) |
| **sequenza dei lotti** | Operazioni: `Volume`, in ordine di tempo, per ID di strategia | serie dei lotti e rapporto lotto(n+1)/lotto(n) dopo una perdita |
| **ingressi dopo SL ("recover")** | Ordini + Operazioni | vedi 4.2 |
| **posizioni concorrenti** | Operazioni, intervalli di vita | quante aperte insieme, stessa direzione / opposte, per ID |

### 4.2 Il "recover" del venditore: come lo si prova o si esclude (definizione scritta PRIMA)
Nel dossier (sez. 5.1) e' la parola ambigua del venditore: "breakouts, protection, RECOVER. No grid. No martingale." (22/09/2026). Un ingresso opposto dopo uno SL **non basta** a dire "recover": un sistema breakout con ordini pendenti su entrambi i lati ha **gia' armato** il lato opposto quando il primo SL scatta. **L'ipotesi alternativa (innocente) e' proprio questa.** Si separano cosi':

- **Ingresso REATTIVO (sospetto recover):** l'ordine d'ingresso ha `Orario di Apertura` **successivo** all'uscita per SL della posizione precedente (stessa strategia, cioe' stesso ID/commento/magic), entro **N barre H1** dall'uscita. **N = 4 barre H1**, fissato ora, prima di vedere dati.
- **Ingresso PREESISTENTE (innocente):** l'ordine era gia' piazzato **prima** dell'uscita per SL.
- **Lotto dopo perdita:** lotto(n+1) > lotto(n) dopo una o due perdite consecutive della stessa strategia, **a parita' di metodo di lotto**. Con il metodo Max Total DD e `OnlyUp` (default G0) il lotto cambia con il saldo: **in G0 la serie dei lotti e' solo esplorativa**; la prova e' nelle passate B con `StartLots` fisso (dossier 6.3, E3).
- **Aggiunta contro il prezzo:** secondo ingresso nella **stessa** direzione di una posizione ancora aperta della **stessa** strategia a un prezzo **peggiore** del primo.

**Contro-esempio da costruire PRIMA di consegnare la lettura** (regola del 10/09): scrivere il lettore, farlo girare su un report sintetico con (a) un sistema che arma entrambi i lati (atteso: tutti gli ingressi dopo SL "PREESISTENTI", zero reattivi) e (b) uno che piazza un ordine nuovo dopo ogni SL (atteso: reattivi 100%). Se non distingue (a) da (b), non si consegna.

### 4.3 La riga di raccolta (da scrivere DOPO l'esito della riga TROVA)
Specifica, non codice: copia **soltanto** i `.htm` di report, i giornali del giorno e gli screenshot dalla cartella dati di quel terminale e dalla cartella scelta da Claudio, nella cartella del Desktop, e fa lo zip (`Compress-Archive`), con l'elenco dei file attesi. **Non nomina e non tocca** `Experts\`, `.ex5`, `.set`, `.ini`, ne' l'altro PC. Deve dichiarare in testa il bersaglio (🖥️ finestra PowerShell sul PC di backtest) e passare `controlla_riga.py` + `verificatore-stringhe` prima di arrivare a Claudio.

---

## 5. Le attese, scritte PRIMA dei numeri (E1-E10 dal dossier 6.4, con l'alternativa, piu' le attese di G0)

Congelate dal commit di questo file. Le soglie numeriche qui sotto che **non** vengono dal dossier sono mie e sono marcate [INFERITO].

### 5.1 Attese di G0 (nuove)
| # | domanda | attesa | come si falsifica / alternativa |
|---|---|---|---|
| G0-1 | il demo apre operazioni nel tester? | **si'**, n >= 1 in 19 mesi | n = 0 => canale nullo (il demo e' limitato nel tester), si ferma, spesa zero. **Alternativa**: il demo e' limitato per data/simbolo, e dopo alcuni giorni si ferma: per questo si guarda la **data dell'ultimo affare**, non solo il n |
| G0-2 | determinismo | G0a = G0b: stessi n, profitto, PF, DD e **stessi affari** (ora, tipo, direzione, volume, prezzo, profitto; id escluso) | una differenza => si guarda lo stato salvato (OnlyUp) prima di dire "non deterministico" |
| G0-3 | frequenza | **n debole**: fra **3 e 30 operazioni a settimana** su 19 mesi (~83 settimane) => circa 250-2.500 operazioni [INFERITO, debole]. Riferimenti, entrambi [DICHIARATO DA TERZI] e per impostazioni **non identiche**: 13 operazioni/settimana sul segnale del venditore; "~450 contro ~2.400" per un solo utente fra Auto ed Extreme, periodo ignoto | fuori banda => non e' una smentita del prodotto: e' un dato che dice che "default" qui non e' il default di quei numeri |
| G0-4 | qualita' storia | "100% ticks reali" nel report | altro valore => la passata non si legge |
| G0-5 | costo | **ipotesi di lavoro 3-15 minuti** a passata (dossier 6.6) [NON MISURATO su questo EA]. Riferimento di casa: GBA M1 3 mesi di tick = 16 secondi (giornale R1A) | la durata di G0a decide il costo di tutte le altre; se > 30 minuti, si rivede il numero di passate prima di lanciarne altre |

### 5.2 E1-E10 (dal dossier; invariate nella sostanza)
| # | misura | attesa | falsificazione |
|---|---|---|---|
| E1 | tipo d'ordine | >= 90% degli ingressi da **ordine pendente** (`buy stop` / `sell stop`) | prevalgono gli ordini a mercato => la mia deduzione (dossier sez. 5) e' sbagliata |
| E2 | SL a 0 | **zero** operazioni senza SL all'apertura | anche **uno** solo => bandiera rossa "nessuno stop". NB: con `Enable Virtual SL/TP` spento (default) lo SL e' sul server |
| E3 | lotto con StartLots fisso | **costante** in ogni passata B | cambia dopo una perdita => logica di lotto fuori dal metodo => bandiera "martingala" |
| E4 | posizioni concorrenti **della stessa strategia** | nessuna **opposta** insieme alla prima; nessuna **aggiunta nella stessa direzione contro il prezzo** | se esistono: hedge/averaging, scarto del setaccio. **Le strategie diverse possono coesistere in direzioni opposte senza che sia un difetto**: il confronto e' per ID |
| E5 | "recover" | definizione di 4.2: **zero** ingressi REATTIVI entro 4 barre H1 e **zero** aumenti di lotto dopo perdita a metodo fisso | basta un caso solido => la parola del venditore aveva senso, fuori perimetro. Se si trovano solo ingressi PREESISTENTI: **non** e' recover |
| E6 | additivita' | somma delle B1-B9 = B10 entro +/-5% sul numero di operazioni | se no: accoppiamento fra strategie |
| E7 | scala delle distanze | **IPOTESI A (mia)**: SL/prezzo costante. **IPOTESI B**: SL/ATR(H1,14) costante. **IPOTESI C (aggiunta qui)**: SL in dollari costante, cioe' nessuna scala | **coefficiente di variazione (CV)** calcolato **dentro ciascun ID di strategia** (non mescolando strategie con SL diversi, che gonfierebbe tutti e tre i CV); vince quello col CV piu' piccolo; se i due piu' piccoli sono entro il 20% l'uno dall'altro, **nessuna conclusione**. Il prezzo dell'oro deve essersi mosso abbastanza nella finestra (dossier: ~2.900 -> ~4.000-4.500) perche' A, B e C siano distinguibili: se il rapporto massimo/minimo del prezzo e' < 1,15, **A e C non si distinguono** e va scritto |
| E8 | orari e giorni | distribuzione per ora server, giorni, posizioni aperte nel weekend (Friday stop spento) | solo descrizione, nessuna soglia |
| E9 | prop | **peggior giornata** in % dei 100k (muro 5%), **peggior DD** (muro 10%), forma a scalini, n di giorni con >= 3 ingressi | numeri da confrontare coi muri, non con il "30%" del venditore |
| E10 | rischio per trade | perdita a SL / saldo; a quanto equivale `Max Risk Per Strat = 1.0` | passata extra opzionale |

### 5.3 Dopo G0 (decisione scritta prima, dal dossier 6.2)
- G0-1 fallito => **stop**, spesa zero.
- G0 apre operazioni ma **PF < 1,0** => "non riprodotto sul nostro feed in questa finestra; **NON ANCORA MISURATO** in altri regimi" (certificato di morte del 09/09: mancano gestione ad asse, TF, regimi). **Non "morto".**
- PF >= 1,0 => si passa alle passate G1-prop (set prop del venditore: moderate, Max DD 9, Daily DD 4, OnlyUp false) e alle B1-B10 (una strategia alla volta, `StartLots` 0,10, `Run Strategy k`), cioe' le altre 11 passate del dossier. Il "default venduto" **non** e' la configurazione prop (dossier 4.1).

---

## 6. Cosa e' lecito e cosa no (in aggiunta alla tabella 6.1 del dossier)

| azione | lecita? |
|---|---|
| lanciare il **demo scaricato col proprio account MQL5** nel Strategy Tester del **PC di backtest** e leggere report, giornale, ordini, operazioni | **SI'** (uso per cui il Market offre il demo; dal regolamento ufficiale **non ancora letto**, dossier punto 8.6) |
| misurare n, PF, DD, orari, tipo d'ordine, distanze SL/TP, lotti, durata, concorrenza **dall'output** | **SI'** |
| cambiare **un input alla volta** del demo nel tester (sono input pubblici) | **SI'** |
| **decompilare, disassemblare, estrarre stringhe o costanti dal `.ex5`, patchare, ispezionare la memoria** | **NO, mai** |
| **copiare il `.ex5` fuori dal terminale**, caricarlo in repo, mandarlo, spostarlo da un PC all'altro | **NO**: e' un prodotto con licenza; sul VPS si riscarica dal Market sul PC di backtest, non si copia |
| **autorizzare gli URL** del venditore (`forexeasolutions.*`, `tradewithwim.com`, `worldtimeserver.com`, `nfs.faireconomy.media`) in Strumenti > Opzioni > Expert Advisors, o intercettare quel traffico | **NO**. Nel tester le chiamate web non ci sono; se il demo si rifiuta di partire senza, **e' un risultato** (si annota) e la decisione di autorizzare o no e' di Claudio, non e' parte di questo piano |
| inserire una chiave di licenza, usare file "trovati", vetrine di terzi | **NO** |
| modificare l'orologio di Windows/del tester per aggirare una scadenza o un limite del demo | **NO** |
| usare i **parametri** letti (distanze, orari) come parametri nostri | **NO**: servono come ipotesi di FORMA; ogni parametro nostro va ricavato dall'altopiano dei nostri dati |
| mettere il demo su un grafico, su un conto, sul VPS | **NO** (sez. 2) |
| attribuzione: nessun codice del venditore entra in repo; se una forma ispira un nostro EA, il file prova lo dice con nome e versione | obbligatorio |

---

## 7. Costo e ordine

1. Riga TROVA (sola lettura): secondi. Eventuale ri-download del demo sul PC di backtest: 15-20 minuti di Claudio, spesa zero.
2. G0a + G0b: **[NON MISURATO]**, ipotesi di lavoro 3-15 minuti ciascuna.
3. Opzionale, **prima** di G0a se il costo spaventa: un **sondino di un mese** (2025.03.01 -> 2025.04.01) con i default, per vedere in pochi minuti se apre operazioni e quanto costa, senza lanciare 19 mesi per niente [INFERITO, mio, non nel compito: se Claudio lo vuole saltare lo salta].
4. Tutto il resto (G1-prop, B1-B10, 4 opzionali Fake Breakout, 1-2 per E10) resta nel dossier e **non parte** senza l'esito di G0.
5. La priorita' resta quella del 08/10 (gli EA sono la priorita'): il dossier lo mette **in coda, dopo GBA R2 e le sedie** (score 2/10 come EA da schierare). Questo piano costa pochissimo ma **non deve passare davanti** a una sedia schierabile.

---

## 8. Come e' stata collaudata la riga TROVA (e cosa NON e' stato collaudato)

- **Collaudata su un albero finto**, su Linux con pwsh 7, copia temporanea con i soli separatori di percorso adattati a `/` (nel repo la riga resta con i backslash di Windows): sette cartelle con hash, di cui il terminale del conto reale con un `.ex5` "Gold Reaper" dentro. Esito: il contenuto del reale **non viene elencato** (contro-esempio riuscito, anche con un'altra cartella il cui `origin.txt` nomina il reale con hash diverso); un `.ex5` "Gold Scalper" viene etichettato `solo Gold` e non confuso col Reaper; un `.ex5` fuori da `Market` viene trovato a parte; `origin.txt` assente o vuoto viene dichiarato; una cartella non esadecimale (`Common`) viene ignorata; le etichette cambiano col nome del PC (testato con i due nomi).
- **NON collaudata**: su **Windows PowerShell 5.1** (lo strato 1 verifica solo pwsh 7); sul **formato reale di `origin.txt`** (scritto da MT5, si assume UTF-16: la riga regge anche il caso senza BOM); su una **cartella reale con migliaia di file** (la ricerca fuori da `Market` percorre tutto `MQL5\Experts` in ricorsione, solo nomi).
- Cancello deterministico: `python3 backtest_pipeline/controlla_riga.py --oggetto riga backtest_pipeline/righe/RIGA_TROVA_GOLD_REAPER.txt` -> **nessun difetto meccanico, 0 bloccanti, 0 rilievi** all'ultima esecuzione. Alla prima stesura il cancello **bloccava** la riga perche' nominava per nome i percorsi dei terminali con sedie vive: e' stata riscritta classificando **per hash** (che e' una funzione verificata del percorso, 1.2) e non per percorso. **Non e' un aggiramento**: la riga continua a non toccare niente e non nomina nessun conto vietato in forma di bersaglio; resta da leggere a mano dal verificatore.
- **Non e' stata scritta una riga di raccolta**: la regola dell'11/08 (i risultati arrivano anche sul Desktop) qui si applica ai risultati del tester, che salva Claudio a mano (3.4); la riga TROVA stampa solo a schermo, come la riga di identificazione gia' passata, e il suo output lo copia Claudio. Se il verificatore vuole una raccolta anche per quella, e' una sua osservazione da recepire.

---

## 9. Che cosa NON si puo' sapere dal solo repo (elenco completo)

1. **Su quale PC e' il demo** e se e' presente nel terminale BCM del PC di backtest (la riga lo stabilira').
2. **Come si chiama il file** del demo in `MQL5\Experts\Market\` e se contiene "Gold" o "Reaper" (se non li contiene, la riga stampa anche i primi 40 altri `.ex5` del Market, ma il riconoscimento e' a occhio).
3. **Se il demo gira nel Strategy Tester**, con quali limiti (date, simboli, numero di operazioni, tempo), e se un limite del demo falsa la misura rispetto al prodotto a pagamento.
4. **Se il demo chiede URL/licenza** nel tester, e come reagisce se non li ha.
5. **Le etichette esatte** dell'interfaccia italiana per salvare il report, tranne "Ogni tick basato su tick reali".
6. **Se la versione del demo e' la 5.1**: lo screenshot dice 5.1 per il demo di Claudio, ma il file non e' stato visto; la versione nel report/giornale va confrontata.
7. **Il nome e il formato del Commento** degli ordini del demo (ID della strategia) e il **numero di magic per strategia** (8000+k o 8000+k-1, dossier punto 8.7).
8. **Se il tester azzera le variabili globali fra due passate** (rilevante per `OnlyUp`, quindi per il determinismo di G0).
9. **Il tempo-macchina per passata** (3-15 minuti e' un'ipotesi) e **cosa gira stasera** sul PC di backtest.
10. **La profondita' reale dei tick BCM sull'oro**: 2025.03.01 e' dimostrata (R19, 151 operazioni); 2024.07.10 e' scritta nei giornali di R1A ma **non provata** per questo EA.
11. **Il regolamento ufficiale del Market** sul demo e sull'analisi dell'output (dossier punto 8.6): le regole di sez. 6 sono prudenza di casa, non un parere legale.
12. **Tutto quello che e' scritto nel dossier alla sez. 8** (il codice, "recover", "backup" verso gli host del venditore, le statistiche dei terzi): invariato.

---

## 10. Fonti (tutte lette oggi nel repo)

- `report/MARKET_GOLD_REAPER_2026-10-10.md` (dossier, bozza non passata dal cancello)
- `backtest_pipeline/righe/RIGA_IDENTIFICA_TERMINALI.txt` (riga PASS, modello di stile) · `backtest_pipeline/righe/RIGA_TROVA_POSTNEWS.ps1` (tabella hash -> conto)
- `backtest_pipeline/controlla_riga.py` (lista bianca di sola lettura, tabella `BERSAGLI_PER_MACCHINA`, regole sui percorsi vietati)
- `backtest_pipeline/gen_ini.py`, `backtest_pipeline/righe/GBA_R0_PASSATE.ps1` (impostazioni di casa del tester) · `backtest_pipeline/leggi_gba_r0.py` (G0 e lettura del report)
- `backtest_pipeline/risultati_archivio/GBA_R0_R1A_20261010/GBA_R0_R1A.zip` e `.../ROUND_CORTI_A_2026-09-28/CCOMM_R258/CCOMM_R258.htm` (formato del report e del giornale del tester)
- `backtest_pipeline/prove/R134b_scatolaoro_XAUUSD.txt` (pavimento 2025.03.01) · `report/GBA_R2_PIANO_2026-10-10.md` sez. 6.3 (tick BCM dal 2024.07.10) · `report/OROLOGIO_BCM_2026-09-24.md` · `backtest_pipeline/caccia_strategie/CANCELLO_ACQUISTI_EA.md` (gradino 3)
- `CLAUDE.md` (regole: terminali multipli, 12/09 bersaglio in testa, 21/09 round non sul VPS, certificato di morte, contro-esempio)
