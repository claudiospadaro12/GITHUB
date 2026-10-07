# ANALISI LIVE PAOLO - 06/10/2026 (martedi' sera: "ripasso mercati americani, correlazione Nikkei-S&P-DAX, ORB troppo largo, ripasso Forex")

**Stato: passata dal cancello il 07/10/2026** (strato 1 `controlla_riga.py --oggetto md` verde; strato 2 `controllo-preventivo`: **PASS CON RISERVE dopo correzioni**, elenco in fondo).
**Fonte unica:** `data/trascrizioni/LIVE_PAOLO_2026-10-06.txt` (269 righe per `cat -n`, 60.592 byte, trascrizione automatica TurboScribe).
Letta per intero, riga per riga. Nessuna navigazione, nessun completamento da memoria: dove cito il repo lo dico col file.
**Analista:** agente `analista-trascrizioni`, 07/10/2026.
**Come si leggono i riferimenti:** `r.NN` = numero di riga `cat -n`. **La trascrizione non ha timestamp**: per riascoltare un passo serve la
registrazione e la riga come ancora. **Due righe sono enormi** (r.151 ~11.000 caratteri e r.269 ~14.000): quando cito `r.151` o `r.269` aggiungo
la frase citata, perche' il solo numero non basta a ritrovare il punto.
Le citazioni sono **verbatim**, con le storpiature STT lasciate com'erano ("standard impulse" = S&P 500, "Japan" = Nikkei, "Don Johnson" = Dow o DAX
a seconda del punto, "diuno" = D1, "Wiki" = weekly); le sciolgo solo in §2.1.

> ## REGOLA CHE VALE SOPRA TUTTO
> **Da questo materiale non si muove NIENTE.** Ogni numero qui dentro e' una **dichiarazione di una fonte esterna** `[DICHIARATO, NON verificato]`,
> mai un criterio nostro. Nessun preset, EA, conto, sedia, forward o VPS e' stato toccato; nessun round lanciato; niente e' stato mandato a Claudio.
> Le "proposte di misura" della Parte 4 sono **specifiche**, non file prova e non righe di lancio: passano dal cancello prima di esistere e i round
> girano **solo sul PC di backtest**.

Etichette: **[TRASCRITTO]** c'e' scritto (cito) · **[TRASCRITTO dubbio]** c'e' scritto ma puo' essere un errore di trascrizione · **[INFERITO]** lo
deduco (dico da cosa) · **[INCERTO] / [NON CHIARO]** non lo so e non lo deduco · **[DICHIARATO, NON verificato]** numero o affermazione del
relatore · **[DERIVATO]** calcolo mio da numeri scritti, formula nel testo · **[LETTO nel repo]** viene da un file nostro, col nome ·
**[MISURATO]** numero nostro con il file · **[NON MISURATO]** il dato non c'e'.

**Orari.** Paolo **non dichiara mai il fuso del live** e parla in ora italiana (*"alle nove, quando apre la borsa di Francoforte"*, r.67; *"le 15 e 30 ...
apertura della borsa di New York"*, r.67). **Non converto nessun orario del parlato.** Dove dichiara lui il fuso (r.269: *"ora italiana ... ora del broker"*)
lo riporto. Promemoria nostro: BCM = UTC+1 fisso (`report/OROLOGIO_BCM_2026-09-24.md`); FTMO = IT+1.

---

# PARTE 1 - LA SINTESI (la pagina che si legge per prima)

## 1.0 La riga che conta

> **Su 269 righe: 33 parametri con valore (nessuno e' una regola completa e verificabile), 20 meccanismi, 8 bandiere (ZERO rosse; 3 arancioni;
> 5 ambra), ZERO regole prop, ZERO trucchi anti-prop, ZERO numeri di performance di conto.** La live ha **due meta' molto diverse**: (A) r.1-255 e' un
> **ripasso operativo** sui mercati americani/DAX (correlazione Nikkei-S&P-DAX, livelli, ORB, trailing stop, BCM che salta gli ordini);
> (B) r.255-269 e' la **lezione 01 "Introduzione al Forex"** per i nuovi (sessioni, orari broker, liquidita', COT, volumi, gap, rollover, bank holiday).
> **Il dato piu' solido per noi e' una convergenza di forma, non di numero:** Paolo abbandona l'ORB del giorno perche' *"sui primi 15 minuti ti fa un orbe di
> questo tipo, non e' piu' tradabile ... un rapporto di sorrendimento che non sta in piedi"* (r.165) e *"quando l'ho visto cosi' grande ho abbandonato l'orbe"* (r.205) e la nostra sedia ORB Dow ha gia' quel filtro come input vivo
> (`InpMaxRangePct=0.8`, *"range ... sopra il tetto ... (movimento gia' fatto): niente setup oggi"*, `ABTG_ORB_Ottimizzato.mq5` r.201 e r.505-506,
> preset `ABTG_ORB_Ottimizzato_DOW_FTMO_TRIAL.set` r.91). **MA non e' una prova di merito**: il filtro nell'EA e' etichettato
> *"(edgeful)"* (r.201), cioe' viene da un'altra fonte esterna, non da Paolo: sono **due dichiarazioni esterne che convergono, nessuna delle due e' una misura** (e il corso resta la fonte di altre manopole nostre, scheda 10/01 §9.1).
> **Il pezzo piu' nuovo e piu' pericoloso per un EA** e' una frase sola, r.233-235: *"a me oggi e' capitato che sull'opening USA io ho fatto praticamente
> un algoritmo ce l'ho automatizzata e mi ha proprio saltato l'ordine ... Spesso me lo fa BCM. Quando c'e' un movimento forte non mi prende l'ordine."*
> Il **tipo d'ordine NON e' detto** (pendente o a mercato: `[NON CHIARO]`, D1); se fosse un pendente sull'apertura USA sarebbe **il tipo che usano le nostre sedie**, e direbbe che sul broker
> BCM un ordine puo' **non essere eseguito** nel movimento forte. E' una dichiarazione, non una misura: ma e' una **domanda concreta** sul nostro forward BCM (Parte 5, D1).
> **La seconda novita':** *"a me gli indici short non mi piace farli, mi piace farli longhe"* (r.151): una **preferenza di lato** esplicita sugli indici,
> opposta alle nostre sedie DAX short (`770105`, `770411`) e opposta all'operativita' short di Emiliano del giorno dopo (live 07/10).

## 1.1 Che cosa e' questa live, e che cosa NON e'

- **Chi parla:** Paolo (docente, host) con allievi che intervengono per nome (Maria, Gabriele/"Giacomino", Fabrizio, Natalia, Claudio [un allievo, non il nostro Claudio:
  `[INFERITO]` dal contesto: *"Claudio, ma in questo caso con Fibonacci ..."*, r.83], Cinzia, Tiziano). Emiliano e' citato, non presente: *"Avete seguito Emiliano?"* (r.13), *"oggi Emiliano sul
  canale Telegram ha parlato del trading stop"* (r.171).
- **Quando:** **martedi' 06/10/2026 sera** (*"Domani e' il 7"*, r.83; *"domani sera c'e' la FONC ... sono le NIMS ... su dei verbali"*, r.153 = FOMC **minutes** `[INFERITO]`). Ora di inizio non
  dichiarata. Non e' una live operativa in tempo reale: lavora su grafici **a mercato chiuso** (*"Siamo in una fase di congestione un po' su tutto"*, r.69).
- **Non e' una prop.** Zero `prop`, `FTMO`, `funded`, `challenge`, `drawdown`: verificato con `grep` (le 9 occorrenze di "prop" sono "proprio"/"proprieta'", **0** come parola intera).
- **Qualita':** media-bassa nella parte grafica (r.77-151: frasi spezzate, "standard impulse" per S&P, "Don Johnson" ambiguo fra Dow e DAX), **buona** nella lezione Forex (r.255-269, frasi lunghe ma coerenti).
- **Chiarezza degli strumenti:** molti riferimenti a livelli *"qui"*, *"questo"*, *"questa zona"* (a schermo): **nessun prezzo dettato** salvo 180 punti (r.151) e pochi altri.

## 1.2 I punti piu' importanti (ordinati per valore per noi)

| # | punto | dove | che cosa vale |
|---|---|---|---|
| 1 | **ORB: se il range dei primi 15' e' troppo largo, non si fa** ("non e' piu' tradabile durante il giorno ... un rapporto di sorrendimento che non sta in piedi") | r.165, r.205, r.213-215 | **CONVERGE** con `InpMaxRangePct` (sedia ORB Dow trial; il filtro e' marcato *"(edgeful)"* nell'EA r.201). Due fonti esterne, **zero misure**. Soglia **non dichiarata** da lui |
| 2 | **BCM salta gli ordini nei movimenti forti** (su apertura USA, ordine di un suo algoritmo; **tipo d'ordine non detto**) | r.231-235 | **NUOVO**, dichiarazione di terza parte su **un limite del nostro broker**. Va misurato sul nostro giornale (D1) |
| 3 | **Il pendente di domani sta sulla confluenza D1 EMA50 + H4 EMA200 + zona di liquidita'/imbalance**; *"tengo l'ingresso di sicurezza"* | r.149-151 | **NUOVO** come livello d'attesa. `ABTG_EMA200` legge l'EMA200 **del TF operativo**, non l'EMA50 D1 (scheda 10/01 §9.1) |
| 4 | **Preferenza long sugli indici** (*"gli indici short non mi piace farli"*) e rimozione del pendente di notte | r.151 | **MESSA IN DUBBIO** del lato short della flotta DAX; preferenza, non misura. **Contraddice** la sua stessa live 01/10 (ordine lasciato di notte sulla EMA200) |
| 5 | **Cascata di correlazione Nikkei -> S&P -> DAX** guidata in D1 + sei figure a schermo; *"negli ultimi mesi c'e' stata un po' di scorrelazione"* | r.71-77 | Ripete 01/10 (r.73-77, 191-195, 365-373). `770411` FTMO ha un solo anello (US500), Nikkei assente |
| 6 | **Box ORB in ora server**: Nasdaq 14:30-14:44:59, DAX 8:00-8:14:59 (ora BCM estate), *"un secondo prima della chiusura"* | r.269 | **Conferma** il nostro orario d'estate; **sara' sbagliato dal 26/10 (DAX) e dal 02/11 (USA)** se non si cambia: `OROLOGIO_BCM` |
| 7 | **Pre-ORB sul DAX**: box 5' (07:55-07:59:59 server), ordini **10 punti** sopra/sotto, stop sul lato opposto; *"a me non piace sul DAX"* | r.269 | **NUOVO numero** (10 punti) per la famiglia PreOpen. Costo-first: [DERIVATO] stop >= 20 punti = 11,8x lo spread 1,70 (sotto il pavimento duro 13,3x) |
| 8 | **Volume come conferma**: *"discesa senza volumi ... questo buco viene tappato rapidamente"* | r.269 | Ripete 01/10 (r.33). Nessuna soglia; volumi BCM = tick, non reali |
| 9 | **Lezione Forex:** orari broker ("un'ora in meno" per BCM), rollover 23:00 IT, gap = *"ingresso da scommettitore"*, bank holiday USA **12/10** (*"evitare EURUSD"*), disallineamento ora legale | r.269 | Il punto sul **disallineamento** (US apre 14:30 IT per ~2 settimane in autunno) e' coerente con quanto deduco da `OROLOGIO_BCM`; **il 12/10 e' un controllo di calendario** (D3) |
| 10 | **ADR del DAX:** qui *"180 punti"*, il 01/10 *"290 punti"* | r.151 vs 01/10 r.357-361 | **INCOERENZA interna dichiarata** (possibili metriche diverse): non si usa nessuno dei due |

## 1.3 Regole di rischio / prop

**Nessuna regola prop. Nessun limite giornaliero. Nessuna percentuale di rischio per trade.** L'unica frase di dimensionamento e' **ambigua**:
*"si entra su una strategia diversa che e' la rottura del breakout di apertura mattina, sempre con un terzo rischio e con uno stop"* (r.151) `[TRASCRITTO dubbio]`:
puo' essere "un terzo del rischio" (per ogni strategia in correlazione) o "un terzo rischio" = una frazione per ingresso. **Non e' una regola utilizzabile** (D2).
Le uniche protezioni dichiarate sono qualitative: *"Se non c'e' il segnale non si fa"* (r.171), *"imparare due o tre strategie bene ... provatele in demo e quando siete sicuri passate in reale"* (r.53),
*"bisogna imparare anche a aspettare la pazienza di aspettare"* (r.269), niente trading nei **bank holiday** (r.269).

## 1.4 Numeri dichiarati (mai criteri nostri)

**Zero esiti di conto.** Solo letture di mercato: Nikkei *"un punto e mezzo della notte"* (r.75) `[TRASCRITTO dubbio]`; *"ieri ha fatto il 3% oggi ha fatto l'1% stamattina l'ha fatto l'1%"* (r.151) `[INCERTO]` quale indice;
*"ieri mattina se uno si faceva l'orbe sul nasdaq ... aveva fatto circa ... sono 370 punti"* (r.151) `[TRASCRITTO dubbio]` (la cifra prima di "punti" manca); gap *"137 punti 140 punti"* (r.269). Tutti esempi, n = 1, un giorno.

## 1.5 Bandiere rosse (dettaglio in §2.7)

**Rosse piene: 0.** Arancioni: **B1** pendenti nel movimento forte su BCM + algoritmo personale che "salta" ordini (rischio di esecuzione, non di metodo); **B2** pendente lasciato/tolto
di notte in modo incoerente fra live; **B3** *"sempre con un terzo rischio"* ambiguo. Ambra: **B4** COT "il mercato va dalla parte opposta dei retail" (assoluto non misurato); **B5** gap-fill come scommessa
(lo dice lui); **B6** correlazioni dichiarate `[INCERTO]`; **B7** indicatore *"che sto testando"* mostrato ma non distribuito; **B8** uso di IA per analizzare video senza fidarsi (rischio di metodo dichiarato).
**Trucchi anti-prop: 0.** Recovery/mediazione/griglia/martingala: **0 parole** (verificato `grep`).

## 1.6 Quello che NON c'e' (verificato con `grep`, case-insensitive)

| pratica cercata | occorrenze | nota |
|---|---:|---|
| prop (intera) / FTMO / funded / challenge / drawdown | 0 / 0 / 0 / 0 / 0 | "prop" solo dentro "proprio" |
| martingala / raddoppio / griglia / recupero / hedging / copy | 0 / 0 / 0 / 0 / 0 / 0 | |
| "senza stop" | 0 | *stop* compare **25 volte**, tutte come SL di un'operazione o come "stop hunt"/"trading stop" |
| profit factor / backtest / statistica di strategia | 0 / 0 / 3 | "statistic" = base statistica del gap (r.269) |
| rischio per trade in %, lotti | 0 / 1 | "lott" = lotto/sizing nel pannello (r.243), nessun valore |
| M3, ATR, trailing "ATR" | 0 / 0 | **a differenza** di Emiliano 07/10 (3 e 2 occorrenze); M3 compare pero' in live Paolo piu' vecchie (`docs/live_paolo/`, 05/05, 07/05, 03/09) |

---

# PARTE 2 - LA SCHEDA DI CASA

```
FILE             data/trascrizioni/LIVE_PAOLO_2026-10-06.txt  (269 righe cat -n, 60.592 byte)
RELATORE/CANALE  Paolo (docente del corso Circle); allievi in chat; sera del 06/10/2026
OGGETTO          (A) r.1-45 amministrazione e domande dei nuovi; r.45-63 piattaforma Circle e strategie;
                 (B) r.63-151 ripasso apertura mercati: correlazione Nikkei-S&P-DAX, S&P ai massimi, Fibonacci, pendente D1 EMA50,
                     mercato americano il pomeriggio (Nasdaq); (C) r.155-255 ORB (chi lo ha inventato, quando non farlo, orari, pre-ORB,
                     trailing stop in punti, MT5 vs app mobile, BCM che salta ordini); (D) r.255-269 lezione 01 Forex (sei moduli,
                     operatori, sessioni, orari broker, Mataf, COT, volumi, rollover, gap, bank holiday)
```

## 2.1 Le ricostruzioni dell'ascolto (tutte [INFERITO]; dico da cosa; quelle che cambiano il significato sono in grassetto)

| nel testo | lo leggo come | su che base |
|---|---|---|
| "standard impulse", "Standard & Poor's" | **S&P 500** | r.125 *"le prime dieci ditte dello Standard & Poor's"*; scheda 10/01 |
| "Japan" | **Nikkei 225** | r.71 *"il Nikkei, il mercato giapponese"* |
| "Don Johnson", "Don Jones", "Dow Jones" | **Dow** in r.127 (composizione); in r.149-151 e r.157 **[NON CHIARO]**: puo' essere **Dow o DAX** | r.149 *"se questi due vanno lunghi e' probabile che anche il Don Johnson domattina vada lungo"* segue r.71-75 dove la catena finisce nel DAX: **non assegno** |
| "diuno", "di uno", "Diuno" | **D1** | r.73 *"tutti in di uno"*, r.151 *"studiando in diuno"* |
| "Wiki" | **weekly** | r.151 *"in wiki cosa vedo"* (schede precedenti) |
| "l'esfalo" (r.101) | **fakeout / stop hunt** `[TRASCRITTO dubbio]` | r.105-107 *"andarsi a prendere gli stop"* |
| "band driving" (r.139) | **band walking** (prezzo che cavalca la banda di Bollinger) | r.139 *"la banda non ci pensa ancora a chiudere"* |
| "ORB", "orbe", "orb", "org" | **ORB** | r.157 |
| "orba" (r.151) | ORB | |
| "super treno", "super trenz" | **Supertrend** | r.189-195 (*"super treno in H4"*) |
| **"Super treno inversa"** (r.201) | **"Supertrend inverso/reversal"** `[INFERITO]`: strategia diversa dall'ORB | r.201 *"Non e' piu' l'orbe. E' una nuova strategia"* |
| "le NIMS", "la FONC" | **FOMC minutes** / FOMC | r.153 *"Non e' la FONC, sono le NIMS ... su dei verbali"* |
| "Minus", "meeting di Minus" (r.83) | **minutes** `[TRASCRITTO dubbio]` | stesso passo |
| "Horloger" (r.269) | **rollover** | r.269 *"alle 23 ... si ferma un attimo ... i broker selezionano le piattaforme sul giorno successivo"* |
| "Mataf" / "MATAC" | sito **Mataf** (volatilita') | scheda 10/05 |
| "GDP" in *"un GDP, io lo faccio molto malvolentieri ... 21 pip"* (r.269) | **EURGBP** (*"euro e stellina"*) `[TRASCRITTO dubbio]` | stesso passo, *"scambi tra euro e stellina"* |
| "CHF Japan" ... *"il numero ha fatto 50 pip dieci volte quanto fa euro USD"* | **CHFJPY ~150 pip/giorno**; la seconda frase **non e' ricostruibile** (50 x 10 = 500?) | r.269 |
| "M0DC HF" (r.269) | **[NON RICOSTRUIBILE]**: un simbolo, non lo leggo | r.269 *"M0DC HF in m5"* |
| "COT report indicator" | indicatore **COT** (Commitment of Traders) su TradingView | r.269 |
| "il mediano trada" (r.151) | **"il medio/il mio metodo"** `[INCERTO]`: un allievo che riassume Paolo | r.151 |
| "serinite" (r.151) | **[NON CHIARO]** (stop? "ci metto..."?) | r.151 *"io ho messo un serinite"* |
| "esfalo", "Tibonacci" | Fibonacci | r.89 |
| "in Malta" (r.161, r.165) | **"in ogni caso"/"in realta'"** `[TRASCRITTO dubbio]` | r.161 *"In Malta ... ha fatto la meta' del movimento medio giornaliero"* |
| "il lord" (r.181) | **"l'ORB"** (e non l'oro) `[INFERITO]` | r.179-183 *"Non e' piu' lord, e' un'altra strategia"* seguito da ORB e Bollinger |

## 2.2 Cronologia della live

| riga | cosa succede |
|---|---|
| r.1-43 | saluti; domande dei nuovi; **giovedi' 08/10 la lezione e' spostata a venerdi'** (r.23-25); mail del 01/10 sul piano di training "in sospeso" (r.27-37) |
| r.45-63 | piattaforma **Circle**: corso di avvicinamento, sezione strategie (*"una ventina di strategie"*), cartelle indicatori/dashboard/toolkit; slide 00 la scorsa volta, oggi "introduzione al Forex" |
| r.63-69 | liquidita': aperture e chiusure; DAX 9-10 (e 11), picco 15:30; *"oggi ho fatto delle operazioni ma poi mi sono fermato"* |
| r.71-77 | **correlazione** Nikkei -> S&P -> DAX, schermata a sei figure, scorrelazione recente |
| r.77-151 | **S&P chiude sui massimi**, Fibonacci 127 (-> 161), D1 con Bollinger "in compressione/espansione", H1-H4 tutte long, **pendente su D1 EMA50 / H4 EMA200 / imbalance**, Nasdaq ai massimi storici da tre giorni, composizione indici, ORB Nasdaq di ieri |
| r.151-169 | **ORB**: nato per il Nasdaq 15:30; bene su S&P, meno sul Dow; oggi range troppo largo, non tradabile; *"Se non c'e' il segnale non si fa"* |
| r.171-177 | **trading stop**: in punti (non pip) |
| r.177-225 | caso di un allievo sull'ORB con **Bollinger/Supertrend H4/EMA200 H4**: *"Allora qui potevi fare un bel reverb, pero' non facevi nulla"* |
| r.227-255 | MT5 desktop vs app: P/L in euro; **BCM che si blocca e salta gli ordini**; pannello in sviluppo; box gialli e blu = l'EA ORB |
| r.255-269 | **lezione 01 Forex**: sei moduli, operatori, sessioni, orari broker, ORB box in ora server, due varianti ORB, Mataf, COT, volumi, rollover, gap, ora legale, bank holiday |

## 2.3 PARAMETRI CON VALORE (33 voci; tutte [DICHIARATO, NON verificato])

| # | parametro | valore | citazione | dove | chiaro? |
|---|---|---|---|---|---|
| P1 | strategie del corso | **~20** (*"una ventina"*); *"7-8"* per tema; imparane **2-3** | *"ci sono illustrate una ventina di strategie, che questo e' il nostro arsenale ... Il consiglio che diamo e' di imparare due o tre strategie bene, dopo che le avete viste, provatele in demo e quando siete sicuri passate in reale"* | r.51-53 | chiaro; *"7-8"* `[TRASCRITTO dubbio]` |
| P2 | orari di liquidita' (ora italiana) | **9-10** (anche verso le **11**) DAX; **15:30** picco; dopo **17:30** calma | *"la mattina tra le nove, quando apre la borsa di Francoforte, e le dieci, ma anche verso le undici ... picco verso le 15.30 ... dopo le 17.30, abbiamo un momento di calma"* | r.67 | chiaro; fuso non dichiarato = IT `[INFERITO]` |
| P3 | apertura Nikkei | **02:00** *"l'italiano"* | *"apre alle due di notte l'italiano"* | r.71 | chiaro (ora IT) |
| P4 | strumenti della schermata | **6 figure**: Nikkei, S&P, DAX, *"tutti in D1"* (+ altri TF) | *"noi mettiamo sei figure ... io metto il Nikkei, sopra lo standard, poi il DAX, tutti in di uno"* | r.73 | `[TRASCRITTO dubbio]` (D1 per tutti?) |
| P5 | momento di controllo | **08:30** (*"alle otto e mezzo della mattina"*) | *"quando mi metto davanti alla grafica, alle otto e mezzo della mattina"* | r.75 | **fuso non dichiarato** (ora IT o server?) `[INCERTO]` |
| P6 | Nikkei, movimento notturno | *"un punto e mezzo"* (+1,5%?) | *"la candela del Japan ... aveva fatto un punto e mezzo della notte"* | r.75 | `[TRASCRITTO dubbio]` (punti? percento?) |
| P7 | Fibonacci S&P | prezzo **rifiutato sul 127**; obiettivo **161**; ritracciamento **50%** sulla media | *"vedete sul 127? Si e' proprio fermata sul 127 qua"*; *"il suo prossimo obiettivo ... e' al 161"* | r.89-95, r.139 | chiaro; livelli in % di estensione |
| P8 | configurazione S&P | *"un massimo crescente e due minimi crescenti"*; *"una lunga fase di compressione"* | r.99 | r.99 | chiaro |
| P9 | conferma d'ingresso long (breakout) | **candela H1 che chiude "ben fuori"** da livello visto in H4; oppure **pullback** | *"qui siamo in H4 pertanto ci vuole una candela in H1 che chiuda ben fuori da questo livello"* | r.141-143 | chiaro; distanza "ben fuori" **non quantificata** |
| P10 | DAX, movimento medio | **180 punti/giorno** | *"180 punti punti che mediamente fa il DAX in un giorno"* | r.151 | `[TRASCRITTO dubbio]` e **incoerente** con 01/10 (**290** in 10 settimane, max 530; scheda 10/01 V20) |
| P11 | pendente di domattina | **D1 media 50** + zona di liquidita' + **imbalance**; coincide con **H4 media 200**; *"tenersi l'ingresso di sicurezza"* | *"in D1 c'e' la media 50 ... ho messo l'ordine che lo aspetto nella media 50 in D1"* | r.151 | prezzo **non dettato**; lato `[INCERTO]` (vedi §2.6 C2) |
| P12 | moto percentuale | *"ieri 3%, oggi 1%, stamattina 1%"* | *"ieri ha fatto no ha fatto il 3% oggi ha fatto l'1% stamattina l'ha fatto l'1%"* | r.151 | **soggetto `[INCERTO]`**: Nikkei? S&P? Il 01/10 lo stesso errore su "+3,3%" (scheda 10/01) |
| P13 | Weekly | ritracciamento a **38,2**; media *"78,6"* | *"si e' fermato a 38,2 pari pari ... la media dirigente e' su 78,6 per caso"* | r.151 | `[TRASCRITTO dubbio]` ("media dirigente"?) |
| P14 | Nasdaq | massimi storici da **3 giorni**; ritracciamento **38,2**; proiezione **gamba uguale** | *"il Nasdaq che ha rotto con decisioni massimi storici ormai tre giorni"*; *"qualora lui facesse una gamba uguale come proiezione"* | r.151 | chiaro |
| P15 | ORB Nasdaq di ieri | *"circa ... punti, sono 370 punti"* | *"ieri mattina se uno si faceva l'orbe sul nasdaq ... alle 15 e 30 era dentro da ieri e aveva fatto circa punti sono 370 punti"* | r.151 | `[TRASCRITTO dubbio]`; "ieri mattina" vs "15:30" **si contraddicono nella stessa frase** |
| P16 | dimensionamento per correlazione | *"sempre con un terzo rischio e con uno stop"* | r.151 | r.151 | **`[TRASCRITTO dubbio]` pesante** (B3) |
| P17 | petrolio | **non lo trada** (*"troppo erratico"*); incide sul **dollaro canadese** | *"il petrolio e' troppo erratico ... il petrolio incide molto sul dollaro canadese"* | r.151 | chiaro |
| P18 | ORB: strumenti | nasce per **Nasdaq 15:30**; **bene S&P**; **meno bene Dow** (*"pero' va bene anche fare sul Dow Jones"*) | *"La strategia ORB nasce per il NASDAQ alle 15.30 ... funziona meno bene sul Dow Jones, pero' va bene anche fare sul Dow Jones"* | r.157 | chiaro |
| P19 | ORB: consiglio | **mattina DAX, pomeriggio Nasdaq** | *"Comunque il mio consiglio e' farlo la mattina su DAX e il pomeriggio su NASDAQ"* | r.161 | chiaro; conferma 01/10 r.81 |
| P20 | movimento US | *"la meta' del movimento medio giornaliero"* gia' fatta prima dell'ORB | *"Oggi in Malta ha fatto la meta' del movimento medio giornaliero che fa"* | r.161 | chiaro come regola di lettura, **soglia non detta** |
| P21 | ORB: quando NON si fa | primi 15' con uscita *"cosi' alta, lontana dal punto di ingresso"*; *"rapporto di rendimento che non sta in piedi"* | *"in Malta hai una stazione come quella di oggi, dove sui primi 15 minuti ti fa un orbe di questo tipo, non e' piu' tradabile durante il giorno"* | r.165-167, r.205 | chiaro come regola; **soglia numerica NON dichiarata** |
| P22 | ORB: ingresso | candela che **apre e chiude fuori**; la prima | *"L'orbe si entra quando la candela chiude direttamente. Apre e chiude fuori. Quella e' la prima candela che apre e chiude fuori"* | r.209-211 | chiaro; conferma 22/09, 01/10 |
| P23 | ORB: stop | *"lo stoppi da quest'altra parte"*; *"quando tu hai un super treno a quattro punti questa non la puoi fare"* | r.213-215 | r.213-215 | **`[TRASCRITTO dubbio]`**: lato e distanza non dettati; "Supertrend a quattro punti" non chiaro |
| P24 | ORB e confluenza | **ORB + Bollinger**; contesto **H4**: Supertrend H4 *"quasi in confluenza con la media a 200"*, media 200 H4, media a **50** | *"Qui c'e' una coincidenza tra orbe e bande di Bollinger"*; *"in H4 qua c'e' il super treno ... quasi in confluenza con la media a 200"* | r.183-195, r.221 | chiaro; periodi del Supertrend/Bollinger **non dettati** |
| P25 | trailing stop MT5 | in **punti**, **non pip**: *"da 25.000 a 25.001 e' un punto"*; per 10 punti scrivere **1.000** | *"quando metti il trading stop, questi punti qua non sono pip, sono punti ... se con il tuo mouse fai un spostamento di 10 punti, qui ti ho riscritto 1.000. Allora devi scrivere 1.000"* | r.173-175 | `[INFERITO]` coerente con simbolo a 2 decimali (D30EUR BCM 24.998,25 nei nostri referti: `report/TRIAL_GIORNO1_STOP_DAX_2026-10-01.md`); il passo e' confuso |
| P26 | orario pannello ORB | **Nasdaq 14:30-14:44:59** (broker) = **15:30-15:45 IT**; **DAX 8:00-8:14:59** (broker); sempre **"un secondo prima"** | *"questo box ... si apre alle 15 e 30 l'ora italiana e si chiude alle 15 e 45 l'ora italiana si apre alle 14 e 30 l'orario broker e si chiude alle 14 e 45"*; *"dovrai mettere 8, 8, 14 e 59"* ; *"dovete settarla sempre un secondo prima della chiusura dell'ora perchè sennò dipende una candela in più"* | r.269 | chiaro; **fuso dichiarato: "io che uso BCM dovro' mettere l'ora in meno"** |
| P27 | pre-ORB (variante) | box **5 minuti** (**07:55-07:59:59**); ordini **10 punti** sopra e **10 punti** sotto; stop **lato opposto**; DAX | *"se io questo qua lo setto invece che 8 lo setto 07 e 55 07 59 e 59 ... va messo un ingresso 10 punti sotto e un ingresso 10 punti sopra ... quando arriva a toccare il prezzo viene messo lo stop dalla parte opposta"* | r.269 | chiaro; **tipo di DAX: dice "a me non piace sul DAX, funziona meglio sull'apertura americana"** |
| P28 | pre-ORB: esito di esempio | *"15 punti"* di profitto sul DAX se non si prendeva lo stop | *"quando togli questa candela qua di rifiuto ... sarebbe stato 15 punti DAX"* | r.269 | esempio, n = 1 |
| P29 | Mataf, finestra | **10 settimane** (*"per le dieci settimane precedenti"*) | r.269 | r.269 | chiaro (stessa del 01/10 r.357) |
| P30 | volatilita' media coppie | **EURGBP ~21 pip** ("21 pip ... pochi scambi"); **CHFJPY ~150 pip**; **EURNZD ~100 pip**; **EURJPY ~128 pip** | *"un movimento giornaliero di 21 pip ... CHF Japan in questo momento ha un movimento giornaliero di 150 pip ... euro NZD c'e' un aumento medio di 100 pip al giorno euro Japan di 128"* | r.269 | `[TRASCRITTO dubbio]` sui 21 (GBP) e sul 150; periodo = 10 settimane (Mataf) `[INFERITO]` |
| P31 | gestione in direzione | *"intervengo in direzione ... fa 20, 30, 40 pip, si parzializza, si portano a pari"* | *"quella alta riesco a uscirne in profitto che si interviene in direzione quello fa 20, 30, 40 pip si parzializza si portano su a piu' pari"* | r.269 | chiaro; conferma la ricetta del 01/10 (parziale + pari) |
| P32 | COT (posizionamento) | istituzionali **63.000k**, commerciali **40.000k**, retail **22.000k**; pubblicato **ogni venerdi'**; *"il mercato va dalla parte opposta di dove si posizionano i retailer"* | r.269 | r.269 | numeri `[TRASCRITTO dubbio]` (unita' "k"); strumento **EUR** (*"long sia sul euro sia sul dollaro"*) |
| P33 | rollover / orari broker | rollover **23:00 IT** (*"alle 23 ora italiana si ferma un attimo"*); sessione oceanica **22:00 GMT** = **24:00 IT estate / 23:00 inverno**; USA apre **14:30** (valute) / **15:30** (azioni); *"Londra alle 8, Francoforte alle 9"*; **"BCM = orario di Greenwich"** | r.269 | r.269 | **vedi §2.9: due affermazioni sull'orologio sono `[TRASCRITTO dubbio]` e una e' in tensione con la nostra misura** |

(Altri valori citati, non parametri: ADR/Mataf con *"21 pip"* r.269; gap *"137-140 punti"* r.269; *"il 12 ottobre"* bank holiday r.269; disallineamento ora legale r.269; *"giovedi' ... spostato a venerdi'"* r.23.)

## 2.4 MECCANISMI (20)

| # | meccanismo | come descritto | dove |
|---|---|---|---|
| M1 | **Correlazione guida**: il Nikkei (apre 02:00 IT) anticipa lo S&P, che anticipa il DAX; si aspetta il movimento dei primi due per giudicare il terzo | *"il DAX ... anticipa il movimento, se seguito dallo standard impulse, e' molto probabilmente seguito anche dal DAX"* | r.71-75 |
| M2 | **Pomeriggio:** la guida diventa il **Nasdaq** (il Nikkei e' chiuso) | *"al posto del Japan ci si mette il Nasdaq perche' in pomeriggio le 15 e 30 nel mercato giapponese e' chiuso"* | r.151 |
| M3 | **Livello d'attesa**: si sceglie un **ostacolo importante**, si aspetta che il prezzo ci arrivi, si tradano il rimbalzo | riformulazione di un allievo, non smentita: *"se si sceglie una zona di un ostacolo importante aspetta che il prezzo ci arrivi e poi lo trada sul rimbalzo"* | r.151 |
| M4 | **Confluenza di livelli** come qualita' del livello: D1 media 50 + H4 media 200 + zona di liquidita' + imbalance | *"io ho una media al 50 in D1 e una media al 200 in H4 che coincidono piu' o meno"* | r.151 |
| M5 | **Stop hunt / falso breakout** letto sul massimo assoluto dell'S&P (*"molti operatori ... messi con gli stop su questo punto"*) | r.101-107, r.135-137 | |
| M6 | **Conferma del breakout** con candela H1 *"che chiuda ben fuori"* (livello H4); o **pullback** | r.141-143 | |
| M7 | **Pendente di notte**: *"lo tolgo di notte"* (indice) ... mentre per un forex lo lascia: *"ritengo l'ordine pendente"* | r.151 vs r.269 | |
| M8 | **Preferenza di lato**: *"a me gli indici short non mi piace farli, mi piace farli longhe"* | r.151 | |
| M9 | **ORB (strategia nata per il Nasdaq 15:30)**; stop dal lato opposto `[TRASCRITTO dubbio]`; **filtro: range troppo largo -> niente** | r.157-167, r.205-215 | |
| M10 | **Cambio di strategia se il contesto la nega**: ORB non tradabile -> *"Supertrend inverso"* (altra strategia) | *"In H4 questo come si chiama? Si chiama super treno inversa. Non e' piu' l'orbe. E' una nuova strategia. Tutte le strategie vanno applicate valutando il contesto del prezzo."* | r.201-203 |
| M11 | **ORB + Bollinger** come coincidenza di livelli ("punto interessante") | r.183 | |
| M12 | **Contesto H4 prima dell'ORB**: *"Ti fai comunque un'analisi del mercato in H4. Devi dire in H4 quali ci sono i livelli"* | r.185-187 | |
| M13 | **Trailing stop in punti** (conversione) | r.173-177 | |
| M14 | **Pannello esecuzione/size** (in sviluppo): ordine a mercato con pop-up; target/stop in euro; *"regolare la size in modo tale che il tuo stop sia ..."*; *"non funziona ancora bene"* | r.235-243 | |
| M15 | **Variante pre-ORB** (box 5', ordini +/-10 punti, stop opposto) | r.269 | |
| M16 | **Volatilita' prima dello strumento**: *"dobbiamo cercare di andare sempre a tradare strumenti che abbiano una volatilita' adeguata"*; scartare le coppie a bassa volatilita' | r.269 | |
| M17 | **Volume**: *"una discesa senza volumi ... questo buco viene tappato rapidamente"*; ingresso dei volumi = stop dell'avversario | r.269 | |
| M18 | **COT** come segnale (retail contro il mercato) su H4 | r.269 | |
| M19 | **Gap-fill del weekend** (long/short per chiudere il gap, TP al riempimento) **sconsigliato**: *"non e' un ingresso da trader, e' un ingresso da scommettitore"* | r.269 | |
| M20 | **Giorni da evitare**: bank holiday (USA 12/10) -> si lascia stare EURUSD; *"le correlazioni in questo giorno saltano"* | r.269 | |

## 2.5 REGOLE PROP CITATE

**Nessuna.** Zero occorrenze di prop/FTMO/funded/challenge/drawdown. Non c'e' niente da etichettare VIETATO.

## 2.6 CASI OPERATIVI DEL GIORNO (e di ieri)

| # | caso | chi | cosa si vede/si dice | esito | righe |
|---|---|---|---|---|---|
| C1 | *"oggi ho fatto delle operazioni ma poi mi sono fermato"* | Paolo | nessun dettaglio | non dichiarato | r.69 |
| C2 | **Pendente per domattina** su D1 EMA50 / H4 EMA200 / imbalance | Paolo | *"ho messo l'ordine che lo aspetto nella media 50 in D1 ... lo tolgo di notte"* (poi *"a me gli indici short non mi piace farli"*) | **non eseguito** (intenzione) | r.149-151 |
| C3 | **ORB Nasdaq di ieri** (05/10) | ipotetico *"se uno si faceva l'orbe"* | *"era dentro da ieri e aveva fatto circa ... 370 punti"* | **esempio retrospettivo**, cifra `[TRASCRITTO dubbio]` | r.151 |
| C4 | **ORB di oggi**: range primi 15' troppo largo | Paolo | *"Io stamattina quando l'ho visto cosi' grande ho abbandonato l'orbe sul detto. Oggi non lo faccio."* | **nessuna operazione**; `[NON CHIARO]`: *"sul detto"* = Dow o DAX? | r.205 |
| C5 | **DAX: giornata laterale** | Paolo | *"e' rimasto tutto il giorno nel range della mattinata ... domani anche il DAX ... puo' darsi che affacci un bel movimento"* | osservazione | r.169 |
| C6 | **Caso di un allievo sull'ORB** | allievo (Cinzia?) | ORB + Bollinger; H4: Supertrend vicino EMA200 H4 -> *"era piu' facile che tornassi indietro che non andassi avanti. Infatti si e' fermato"* | **non operato** (retrospettivo); alternativa di Paolo: aspettarlo sui minimi con la media 50 | r.183-225 |
| C7 | **Ordine saltato su BCM** (algoritmo automatico, apertura USA di oggi) | Paolo | *"mi ha proprio saltato l'ordine. Cioe' e' partito al razzo perche' era gia' sui minimi e non mi ha preso l'ordine. Spesso me lo fa BCM. Quando c'e' un movimento forte non mi prende l'ordine."* | **mancato ingresso** (non e' una perdita); simbolo/ora/EA **non detti** | r.233-235 |
| C8 | **Piattaforma BCM si blocca** all'apertura americana | allievi + Paolo | *"A voi si blocca la piattaforma? Si, anche a me capita. Con BCM si."* | cronaca | r.231-233 |
| C9 | **Gap della domenica** (esempio) | Paolo | *"se uno entrava long qua si prendeva ... 137 punti 140 punti"* ; *"io non sono un amante di questi ingressi"* | esempio, strumento non detto | r.269 |
| C10 | **Pendente su forex lasciato di notte** (*"ero in ritardo ... ho messo un ordine pendente ... stanotte non ci arriva, magari domattina ci arriva e ritengo l'ordine pendente"*) | Paolo | strumento `[NON CHIARO]` ("investito"/"universo") | in attesa | r.269 |
| C11 | **Errori dichiarati** | Paolo | *"Quello che volevo vedere oggi l'ho visto"* (r.163, **non e' un errore**); l'unica ammissione e' sul suo **pannello**: *"non funziona ancora bene. Non ci ho lavorato"* (r.237) e sull'indicatore *"che non funziona ancora bene"* (r.229) | nessun errore di trading dichiarato | r.163, r.229, r.237 |

**P/L del giorno: non dichiarato.** Nessuna perdita, nessun profitto dichiarati dall'host.

## 2.7 BANDIERE ROSSE (verifica attiva sull'intero testo)

| # | bandiera | colore | prova | nota |
|---|---|---|---|---|
| B1 | **Esecuzione di ordini automatici (tipo non detto) nel movimento forte su BCM** + algoritmo personale | **arancione** | r.233-235 (*"Spesso me lo fa BCM"*) | non e' un difetto del metodo di Paolo: e' un **rischio di esecuzione** del broker che usiamo anche noi (D1) |
| B2 | **Pendenti di notte, due regole opposte** | arancione | r.151 *"lo tolgo di notte"* (indice) contro r.269 *"ritengo l'ordine pendente"* (forex) e contro 01/10 r.131 (ordine sulla EMA200 lasciato ieri sera) | **incoerenza** fra live: non si puo' copiare nessuna delle due senza chiedere a chi |
| B3 | **"sempre con un terzo rischio"** | arancione | r.151 | ambiguo: se significa 1/3 del rischio per ciascuna delle 3 strategie in correlazione, e' sizing; se significa terzo ingresso, e' scale-in. **Non si legge** (D2) |
| B4 | **COT "il mercato va dalla parte opposta dei retail"** | ambra | r.269 | assoluto non misurato |
| B5 | **Gap-fill** | ambra | r.269 *"ingresso da scommettitore"* | lo dice lui, **e' un avvertimento contro** |
| B6 | **Correlazioni e percentuali con soggetto incerto** (+1,5%, 3%/1%/1%, 370 punti) | ambra | r.75, r.151 | non utilizzabili |
| B7 | **Indicatore "che sto testando" + EA ORB non distribuito** | ambra | r.163, r.229, r.237 | mostrato a schermo, non dettato, *"non funziona ancora bene"*: non lo si usa |
| B8 | **IA per analizzare video** *"non li fido mai"* | ambra | r.151 | rischio di metodo dichiarato; zero valore operativo |

**Nessuna rossa:** nessun recovery, nessuna griglia di ordini, nessuna martingala, nessuna size crescente dopo una perdita, **nessun trucco anti-prop**, nessun hedging. **Le tre cose che il giorno dopo compaiono nella live di Emiliano
("chiudi meta' per coprire la perdita", stessa size sul retest, scala di size verso il livello) qui NON ci sono.**

## 2.8 NUMERI DI PERFORMANCE (tutti [DICHIARATO, NON verificato]; si registrano, non pesano)

**Nessun numero di performance di conto.** Solo letture di mercato (P6, P12, P15, P28, C9) e di volatilita' (P10, P30). Nessun win rate, drawdown, PF, profitto totale.

## 2.9 L'OROLOGIO (la parte che tocca davvero noi)

Paolo dice, in ordine:
1. *"noi lavoreremo con ... CET ... l'ora italiana ... in basso a destra della piattaforma; in alto a sinistra ... market watch ... l'orario del broker"* (r.269).
2. *"io che uso BCM dovro' mettere l'ora in meno"* (r.269) = BCM e' **un'ora indietro** rispetto all'Italia. **E' vero oggi (estate, fino al 25/10)** e coincide con `OROLOGIO_BCM_2026-09-24.md` (UTC+1 fisso). **Dal 26/10 non e' piu' vero** (d'inverno BCM = ora italiana).
3. *"per il nostro broker e' l'orario di Greenwich"* e *"000 che e' lo 000 dell'orario di broker"* (r.269): **in tensione con la nostra misura** (BCM = UTC+1 fisso, non GMT). Puo' essere una semplificazione di lezione (la mezzanotte del grafico non e' la mezzanotte GMT). **Non converto, non rimisuro: [INCERTO]**.
4. *"il disegnamento che c'e' per due settimane notturne e due settimane in primavera tra l'ora legale europea e l'ora legale americana per due settimane abbiamo l'ora sfalsata pertanto le borse americane non apriranno alle 15.30 o all'italiana non apriranno alle 14.30"* (r.269) `[TRASCRITTO dubbio]`: "disegnamento" = disallineamento, "notturne" = autunnali; la frase letterale dice *"non apriranno alle 14.30"*, il senso ricostruito (apertura USA alle 14:30 IT in quelle settimane) e' `[INFERITO]`. Dichiarato da lui, **coerente** con `OROLOGIO_BCM` (DAX cambia dal 26/10, USA dal 02/11 per le sedie a ora fissa) `[DERIVATO]`: in quella settimana la finestra di arming 14:30 delle sedie USA e' **per caso allineata**. **NON verificato da me sul calendario.**
5. *"il prossimo [bank holiday USA] che abbiamo il 12 ottobre ... lunedi' 12 ottobre ... tutte le banche statunitense sono chiuse ... si lascia stare EURUSD"* (r.269): [NON VERIFICATO da me se i mercati azionari USA (Nasdaq/Dow) siano aperti quel giorno]: **controllo di calendario broker** (D3).

## 2.10 COSA C'ERA A SCHERMO E NON NEL PARLATO (da chiedere a Claudio / ascoltare)

La registrazione non ha timestamp nel `.txt`: servono la riga e l'ascolto. In ordine di valore:

| # | cosa | riga | cosa chiedere |
|---|---|---|---|
| S1 | **tutti i livelli del pendente** di domattina (D1 EMA50, H4 EMA200, zona di liquidita', imbalance): nessun prezzo dettato | r.149-151 | screenshot D1/H4 con i livelli, **strumento e lato** |
| S2 | **l'indicatore che sta testando** (*"queste linee sono un indicatore che sto testando ... lo daro' appena funziona"*) | r.163, r.229 | cosa traccia; se Paolo lo distribuira' |
| S3 | **ORB di oggi troppo largo**: quanti punti, quale simbolo | r.165-167, r.205 | screenshot del box con quota in punti e simbolo |
| S4 | **box gialli e blu** = l'EA ORB di Paolo (*"Quello e' l'org. Ce l'avete"*) | r.249-251 | e' lo stesso EA/indicatore ORB del Circle? parametri |
| S5 | **tabella Mataf** (volatilita' per coppia/ora) | r.269 | screenshot con periodo (10 settimane?) e le coppie |
| S6 | **tabella COT** (63.000k / 40.000k / 22.000k) | r.269 | strumento e data |
| S7 | **esempi di gap e di volumi** con prezzi | r.269 | strumento e data degli esempi |
| S8 | **video IA** promesso *"un link stasera"* | r.151 | link, se arriva |
| S9 | **pannello esecuzione/size** (non distribuito) | r.235-243 | solo se Paolo lo rilascia |
| S10 | **il pendente "saltato" da BCM**: simbolo, ora, EA | r.233 | giornale del terminale, nel **suo** BCM (non nostro) |

---

# PARTE 3 - COSA E' NUOVO RISPETTO ALLE LIVE PRECEDENTI

Confronto con: `report/SCHEDA_LIVE_PAOLO_2026-10-01.md`, `report/ANALISI_LIVE_PAOLO_2026-09-29.md`, `report/LIVE_PAOLO_2026-09-22_SCHEDA.md`, `report/SCHEDA_LIVE_EMILIANO_2026-10-05.md` (per i punti che Paolo e Emiliano condividono).

| tema | gia' c'era | cosa aggiunge/cambia il 06/10 | tipo |
|---|---|---|---|
| ORB: strumenti e orari | 01/10 r.81-83 (DAX mattina, Dow/Nasdaq pomeriggio), 22/09 box 14:30-14:45 server | ripetizione; **Dow "meno bene" del Nasdaq e dell'S&P** (r.157) | CONFERMA/ripetizione |
| ORB: filtro "range troppo largo" | 22/09: stop opposto, 1:1; 01/10: TP fisso 30-40 punti | **NUOVO esplicito:** *"non e' piu' tradabile ... rapporto di rendimento che non sta in piedi"* (r.165-167); decide di non farlo | NUOVO |
| ORB: conferma "apre e chiude fuori" | 22/09, 01/10 r.39 | ribadita (r.209-211) | CONFERMA |
| Pre-ORB (box 5' prima) | 29/09 O3: Nasdaq 3 punti, Dow 2, M1, 5 minuti prima, uscita 20/60 | **DAX: 10 punti** sopra/sotto, 07:55-07:59:59 server, *"a me non piace sul DAX"* | NUOVO numero |
| Orario del box in ora server | 22/09 (pannello server) | **8:00-8:14:59 DAX, 14:30-14:44:59 Nasdaq**, *"un secondo prima"* | CONFERMA + dettaglio |
| EMA200 | 01/10: **D1** come linea su grafico basso, ordine "prima e dopo" | **EMA50 D1 + EMA200 H4** in confluenza come livello d'attesa del pendente (r.151) | NUOVO (D1 EMA50) |
| Lato indici | 01/10: nessuna preferenza dichiarata | **"gli indici short non mi piace farli"** (r.151) | NUOVO |
| Pendente di notte | 01/10: lasciato ieri sera sulla EMA200 (r.131) | **tolto di notte** (r.151); forex lasciato (r.269) | **CONTRADDICE se stesso** |
| ADR DAX | 01/10: **290** (10 settimane), max 530 | **180** punti/giorno (r.151) | INCOERENZA |
| Correlazioni | 01/10 r.365-373: DAX-S&P 46%, DAX-Nikkei 39%, Nikkei-S&P 79% | schermata a sei figure, scorrelazione recente; **nessuna percentuale** | ripetizione |
| Volumi | 01/10 r.33 (discesa senza volumi) | **volumi BCM contro TradingView: 5 tick di differenza**; COT; *"discesa senza volumi ... buco tappato"* | NUOVO dettaglio |
| Esecuzione BCM | mai trattata | **BCM salta ordini nel movimento forte; la piattaforma si blocca** (r.231-235) | **NUOVO, rilevante** |
| Trailing stop MT5 | mai trattato | **in punti, non pip** (r.173-177) | NUOVO |
| Orari broker/orologio | 22/09 (a voce IT, pannello server) | lezione sistematica; **"BCM = ora in meno"**, **"Greenwich"**, disallineamento ora legale, **12/10** | NUOVO (didattico) |
| Gap-fill | 29/09 e repo (`GapFill`) | **sconsigliato dal docente** (*"ingresso da scommettitore"*) | NUOVO giudizio |
| Strumenti tradabili | 01/10: forex, indici, oro | **forex, indici, oro e petrolio**; ma il petrolio e' *"troppo erratico"* per lui (r.151, r.261) | CHIARISCE |
| Cascata top-down | 01/10 r.447-461 (D1 -> H4 -> H1 -> M15) | S&P: *"dall'H1 all'H4 e' tutta lunga"*, D1 per le bande e il Nasdaq | ripetizione |
| M3 | 01/10: **0 occorrenze** | **0 occorrenze** anche qui | invariato (M3 c'e' da Emiliano 07/10 e in live Paolo piu' vecchie: `docs/live_paolo/` 05/05, 07/05, 03/09; `ABTG_DAX_M3` = "Strategia DAX M3" del corso) |
| Prop / challenge / risultati di conto | 01/10: **nessuna** | **nessuna** | invariato |

---

# PARTE 4 - COSA TOCCA I NOSTRI EA

Lette per questa parte (cito il file): `report/SCHEDA_LIVE_PAOLO_2026-10-01.md` §9 (mappa gia' costruita), `report/CENSIMENTO_ORB_2026-09-29.md` §0, `report/APERTURE_DAX_MAPPA_2026-10-03.md` §3, `report/OROLOGIO_BCM_2026-09-24.md` (riga di testata via `CLAUDE.md`), `mql5/Experts/ABTG_ORB_Ottimizzato.mq5` r.201 e r.505-506, `mql5/Presets/FTMO/ABTG_ORB_Ottimizzato_DOW_FTMO_TRIAL.set` r.91, `FLOTTA_ATTIVA.md`, `HANDOFF.md`, `report/PIANO_FREE_TRIAL_FTMO_2026-09-30.md`.
**Non letto** (dichiaro): i per-trade delle sedie, `ABTG_SuperWave.mq5`, `ABTG_Bulge.mq5` oltre le intestazioni, i giornali BCM/FTMO.
**Tutte le fonti qui sotto sono "[LETTO nel repo]"; i numeri del coach sono "[DICHIARATO, NON verificato]".** Le convergenze con Paolo **NON sono indipendenti**: il corso e' la fonte di parecchie nostre manopole.

## 4.1 CONFERMATI

| sedia / EA | cosa dice Paolo (citazione) | cosa c'e' da noi | verdetto |
|---|---|---|---|
| **ORB Dow trial** (`ABTG_ORB_Ottimizzato_DOW_FTMO_TRIAL.set`, magic 770621; piccolo 770611) | *"sui primi 15 minuti ti fa un orbe di questo tipo, non e' piu' tradabile durante il giorno ... un rapporto di rendimento che non sta in piedi"* (r.165-167); *"stamattina quando l'ho visto cosi' grande ho abbandonato l'orbe"* (r.205) | `InpMaxRangePct=0.8` (preset r.91; EA r.201: *"(edgeful) ampiezza MASSIMA del range in % del prezzo ... 0 = off"*; r.505-506 log *"movimento gia' fatto: niente setup oggi"*) | **CONFERMA la forma** del filtro. La nostra soglia e' % del prezzo, la sua e' il rapporto R:R dell'ingresso (non dichiarato). Il filtro viene da **edgeful**, non da Paolo: due fonti esterne, **nessuna misura**. **Non cambia nessun valore** |
| **ORB Dow, orari** | box 14:30-14:44:59 server (Nasdaq e, per estensione, Dow) (r.269) | preset trial: 16:30-16:45 **ora FTMO** (= IT+1) (`PIANO_FREE_TRIAL`); BCM piccolo in ora server | **COERENTE** (stesso 15:30-15:45 IT) |
| **Famiglia Apertura DAX** (`770101`/`770105`): il mercato del mattino e' il momento migliore | *"uno dei momenti migliori per tradare e' la mattina tra le nove ... e le dieci, ma anche verso le undici"* (r.67) | armano l'apertura DAX con range 35' (mappa DAX) | **CONFERMA** a livello generico (non indipendente) |
| **Parziale + pari** (ricetta d'uscita comune) | *"si parzializza, si portano a pari"* (r.269) | TP1 50% + BE + trailing PREVBAR M5 (scheda 10/05 §C10) | **CONFERMA** (gia' nostra) |
| **Bulge / cross volatili** | *"bisogna invece cercare valute con alta volatilita' e scartare mediamente quella bassa"*; CHFJPY ~150 pip, EURNZD ~100, EURJPY ~128 (r.269) | Bulge: cross yen e GBP nelle liste (`HANDOFF.md`: 7 cross comuni fra cui CHFJPY, GBPJPY); la selezione vera e' il costo (`stop >= 40 x spread`) | **CONFERMA qualitativa**, non indipendente; nessun numero suo entra |

## 4.2 CONTRADDETTI o MESSI IN DUBBIO

| sedia / EA | cosa dice Paolo (citazione) | cosa c'e' da noi | verdetto |
|---|---|---|---|
| **DAX short: `770105` (FTMO), `770411` MaxMin DAX short** | *"a me gli indici short non mi piace farli, mi piace farli longhe"* (r.151) | 770105 short: ritest PF 0,965/0,957, DD OOS 12,3% (bocciato per rischio, scheda 10/05 §C14 che cita mappa DAX); 770411: PF OOS 2,16 su **14** posizioni (n<30, **non si legge**, scheda 10/05 §C1) | **MESSO IN DUBBIO come preferenza, NON come misura.** Il giorno dopo Emiliano **shorta il DAX** (live 07/10): **i due coach non concordano sul lato**. Nessun numero nostro e' cambiato |
| **Nasdaq ORB "funziona molto bene sul Nasdaq"** (r.157) | *"funziona molto bene perche' dopo un periodo di oscillazione direzionale"* (r.157) | breakout nudo al tocco **chiuso** (R12 48/48 negative OOS, R45 0/48, R97 0/4 n=135; `CENSIMENTO_ORB` §0.3); Nasdaq 35-45 min: 1 cella su 8 (§0.4); **vive il RETEST** (n=102, PF OOS 1,109 o 1,215: **due contratti**, §0.7) | **CONTRADDETTO dai nostri numeri** per il breakout al tocco; **non per il retest**. Dichiarazione senza misura |
| **ORB Dow "meno bene"** (r.157) | *"funziona meno bene sul Dow Jones, pero' va bene anche fare sul Dow Jones"* | Dow breakout a due lati **n=197** (una delle due sole righe sopra 150 in OOS, `CENSIMENTO_ORB` §0.1) ma **non schierabile per rischio** (§2 riga 6); ORB Dow `ABTG_ORB_Ottimizzato` OOS 1,674 su n=119 (**merito sospeso**); Dow retest a 15' positivo in OOS (PF 1,42, §0.4); il gemello NASUSD **fallisce** (R97 0,84-0,91) | **CONTRADDETTO nel confronto relativo** (da noi il breakout Dow va meglio di quello Nasdaq), **non in assoluto**: sul Dow il merito e' **sospeso** (n < 150 o rischio). Il suo "meno bene" non e' misurato |
| **Pendenti su apertura USA (es. `770260` Nasdaq_Apertura_US, NASUSD M15)** | *"mi ha proprio saltato l'ordine ... Spesso me lo fa BCM. Quando c'e' un movimento forte non mi prende l'ordine"* (r.233-235) | `770260` L+S operativa in FTMO (non su BCM) (`PIANO_FREE_TRIAL`); sul BCM operano le sedie del piccolo e del 100k | **MESSO IN DUBBIO per le sedie che girano su BCM** (con la riserva che il **tipo d'ordine di Paolo non e' detto**, D1): se una sedia a pendente non viene eseguita nel movimento forte, **il forward sottostima la frequenza e il backtest (che riempie sempre) la sovrastima**. **NON verificato**: D1 |
| **`backtest_pipeline/REGISTRO_TEST.md` r.378-379** (sintesi "REGOLE PAOLO") | l'ORB e' una sua strategia attiva: *"il mio consiglio e' farlo la mattina su DAX e il pomeriggio su NASDAQ"* (r.161) | il registro dice *"Paolo ... NON fa breakout in apertura"* (r.379) e che *"fa soprattutto forex swing/reversal"* | **SUPERATO dalle live 22/09, 01/10, 06/10**: la sintesi del registro e' **vecchia** su questo punto. Nessuna modifica fatta (e' un file di storia): segnalo. Resta valido **r.382**: *"NON entrare se ... il prezzo e' troppo lontano dal livello di rottura"*, **la stessa idea** del suo "ORB troppo largo" (r.165-167) |
| **Orologio**: *"io che uso BCM dovro' mettere l'ora in meno"* (r.269) | | `OROLOGIO_BCM`: BCM = UTC+1 fisso; "IT - 1" vale **solo d'estate**; dal **26/10** DAX, dal **02/11** USA le sedie a ora fissa armano un'ora prima | **MESSO IN DUBBIO nel tempo**: la regola del docente smette di valere fra 19 giorni. Una nota per Claudio nella decisione gia' attesa **entro il 25/10** |
| **"BCM = Greenwich"** (r.269) | *"per il nostro broker e' l'orario di Greenwich"* | UTC+1 fisso (`OROLOGIO_BCM`) | **TENSIONE**, probabilmente semplificazione didattica; non si usa |

## 4.3 NUOVI DA MISURARE (SOLO come proposta, mai come criterio; ogni numero e' un'attesa scritta ORA, prima di guardare)

Ordine di valore per **una sedia schierabile**: **basso** (la live e' didattica; gli unici pezzi misurabili sono un filtro e un livello). Regole di casa applicate: nessuna griglia su
motori senza edge; **due lati sempre**; **n >= 150** per il merito (altrimenti il merito e' sospeso: si giudicano forma e rischio); **regime dichiarato**; **40 x spread** come primo cancello;
**orologio dichiarato**; costo in tempo macchina dove c'e'. **Nessuna riga di lancio e' preparata.**

### P-1 - "Confluenza D1 EMA50 + H4 EMA200 come livello d'attesa" (event study, zero tester)
- **Perche':** e' il livello del pendente di Paolo (r.151) e **non e' coperto** da nessuna nostra misura: la EMA200 di `ABTG_EMA200` e' quella **del TF operativo** (scheda 10/01 §9.1), il filtro `SRBlocked` conosce PDH/PDL e numeri tondi, non le medie.
- **Definizione da congelare (una sola, senza scansione):** t0 = barra in cui il prezzo entra a `<= 0,3 x ATR14(H4)` da entrambe le medie contemporaneamente (ordini a 0,2/0,3 ATR della cella viva di `771531`, HANDOFF 30/09: una banda gia' nostra, non scelta da lui); esito = rimbalzo di `>= 1 x ATR14(H4)` prima di un attraversamento di `>= 1 x ATR14(H4)` oltre il livello. **Lati: entrambi.**
- **Attesa (scritta ora):** **nessuna differenza** dal controllo casuale (livello a distanza uguale ma senza confluenza): la misura gia' fatta sul **singolo tocco** EMA200 (probabilita' 0,47-0,49 contro 0,48-0,49 del caso a H4: `DOSSIER_EXPERT_PER_EMILIANO` §B3) dice che il tocco **da solo** non separa dal caso; la **confluenza** e' una condizione in piu'.
- **Contro-esempio (cosa mi smentisce):** P(rimbalzo | confluenza) sopra la banda bootstrap al 95% del controllo **in entrambe le ere IS e OOS** con **n >= 40 per era**, su **almeno due** indici (DAX e Dow).
- **Costo:** **0 minuti di tester** (Python sulla cache H4/D1). `[NON STIMATO]` il lavoro. **n atteso:** `[NON MISURATO]`; se < 40 per era -> *"non misurabile per campione"*, **non "morto"**.
- **Non fa:** non tocca nessuna sedia; non propone di aggiungere un filtro.

### P-2 - "Esecuzione dei pendenti sul BCM nel movimento forte" (sola lettura del giornale: nessuna misura di mercato)
- **Perche':** r.233-235 e' una dichiarazione di un terzo sul **nostro broker**. Se vera, puo' alterare la frequenza delle sedie a pendente su BCM.
- **Cosa fare (specifica):** nei giornali **gia' esistenti** del piccolo `50503392` (cartella `BCM Markets MT5 Terminal`) e del 100k `50504263` (cartella `... MT5 Terminal -V3`) (**mai riconosciuti a occhio dal titolo**), contare i pendenti piazzati dalle sedie a pendente che **non sono stati eseguiti** mentre il prezzo **ha attraversato** il livello (differenza tra livello e prezzo di fill / "Order placed" senza "deal"). **Definizione da congelare:** pendente non eseguito = il giornale mostra un'attraversata del livello (da OHLC) e nessun deal entro 60 secondi `[valore di prova da dichiarare, non una soglia di merito]`.
- **Attesa:** **zero** casi (la saltata di Paolo e' sul **suo** algoritmo, non sulle nostre sedie). **Contro-esempio:** **>= 1** pendente attraversato e non eseguito nel campione forward.
- **Costo:** **zero** (sola lettura). **Limite:** n piccolissimo (forward di poche settimane); un esito "zero" **non lo smentisce**, un esito "uno" **si legge come presenza, non come tasso**.
- **Non fa:** non tocca nessun terminale. Se serve una stringa di lettura, parte con **numero di conto e cartella programma in testa** (regola dei terminali multipli).

### P-3 - "Pre-ORB DAX: costo prima del merito" (aritmetica, un minuto)
- **Passo 0:** ordini a **+/-10 punti** dal box con stop **sul lato opposto** (r.269): stop **>= 20 punti** `[DERIVATO: 10 + 10, **minimo** perche' non conosco l'ampiezza del box]`. Contro lo spread BCM **1,70**: **20 / 1,70 = 11,8x**; FTMO **1,23** (P95 1,33): **16,3x / 15,0x** `[DERIVATO]`. Il **pavimento duro 13,3x** e il **40x** sono in `APERTURE_DAX_MAPPA_2026-10-03.md` §3. **Lettura:** a BCM il pre-ORB DAX a 10 punti **sta sotto il pavimento duro**; a FTMO ci sta sopra ma **molto sotto il 40x**.
- **Attesa:** **escluso per costo**, con i numeri accanto. **Riferimento dei +/-10 punti `[NON CHIARO]`**: *"un ingresso 10 punti sotto e un ingresso 10 punti sopra il mercato"* (r.269) puo' voler dire dal **prezzo** (stop = 20 esatti) o dal **box** (stop = box + 20). Il box cade alle 07:55-07:59 server, ora 7 pre-mercato: spread BCM **2,80** mediana (`APERTURE_DAX_MAPPA` r.127), quindi se il riempimento avviene prima delle 08:00 il conto peggiora (20 / 2,80 = **7,1x**). **Contro-esempio:** se lo **stop reale** (distanza fra i due ordini) misurato e' >= **53,2** punti a FTMO P95 / >= **68,0** a BCM (40x, mappa DAX r.128) il costo regge e lo studio puo' proseguire; nella lettura "dal prezzo" questo non succede mai.
- **Costo:** **zero tester**. E' la prima riga, la scrivo cosi' perche' e' la conferma o la smentita di una frase di Paolo (*"a me non piace sul DAX"*) con un numero.

### P-4 - "Il filtro `InpMaxRangePct` letto contro l'ADR" (split ex post sui per-trade, zero tester; **solo se gia' esistono i per-trade ORB Dow**)
- **Perche':** la sua regola e' *"troppo largo = non conviene"*; la nostra e' un % del prezzo. **Una sola partizione** (decisa ora, senza scansione): range del giorno / ADR(14 giorni) sopra e sotto la mediana.
- **Attesa:** nessuna differenza di PF oltre la banda di rumore (stessa logica di S1 della scheda 10/05); campione OOS Dow ORB gia' noto (n=197) -> ~100 per meta'.
- **Contro-esempio:** PF(sopra mediana) < 0,85 **e** PF(sotto) > 1,25 in **entrambe** le ere con n >= 40.
- `[NON VERIFICATO da me]` dove stiano i per-trade dell'ORB Dow e se coprano **piu' regimi**; il 21 mesi sono **un regime**. **Costo:** ore, non giorni `[NON MISURATO]`.
- **Due lati:** la sedia trial e' **solo long** (preset r.3 e r.68-69: `InpAllowShort=false`): lo split legge **un lato solo**. Il lato short del filtro resta `[NON MISURATO]` e va dichiarato tale accanto al numero (regola dei due lati sugli indici).

### Cosa NON propongo (col motivo)
- **COT/retail contrarian**: nessun dato COT nel repo `[NON VERIFICATO]` e il segnale non e' per H1/intraday.
- **Gap-fill del weekend**: lo sconsiglia lui stesso; `GapFill` e' gia' nei motori d'apertura (mappa DAX), nessuna misura nuova da questa live.
- **Il pannello di sizing di Paolo** e **l'indicatore in test**: non distribuiti, non dettati.
- **Cambiare l'orario delle sedie in base a "BCM = ora in meno"**: la decisione sull'orologio e' di Claudio entro il 25/10, con la misura `OROLOGIO_BCM`.
- **Qualunque modifica in forward.**

---

# PARTE 5 - DOMANDE PER CLAUDIO (che conosce Paolo di persona)

| # | domanda | perche' |
|---|---|---|
| D1 | A Paolo: **su quale EA e quale simbolo** gli e' stato saltato l'ordine all'apertura USA (r.233)? Era un pendente? Su quale server (BCM demo o altro)? | verifica se riguarda **le nostre** sedie a pendente su BCM (P-2) |
| D2 | A Paolo: **che cosa vuol dire "sempre con un terzo rischio"** (r.151)? un terzo del rischio per strategia in correlazione, o un terzo ingresso? | e' l'unica frase di sizing della live |
| D3 | Il **12/10/2026**: i mercati **Nasdaq/Dow/DAX** sono aperti? (Paolo dice che le banche USA sono chiuse; **non so se le Borse lo siano**) | sedie USA FTMO/BCM operative quel giorno; controllo di calendario, **non** una decisione |
| D4 | A Paolo: **a che ora esatta** (e in quale fuso) il pendente su D1 EMA50 / H4 EMA200 e che **lato**? Lo ha poi tolto di notte? (C2) | r.149-151 non dice ne' prezzo ne' lato |
| D5 | A Paolo: **il range "troppo largo" dell'ORB**: quanti punti/quale % o rapporto R:R fa dire "oggi non lo faccio"? (r.165, r.205, r.213-215) | permette di confrontare con `InpMaxRangePct=0.8` |
| D6 | **Per riascoltare**: i passaggi di S1, S3, S5, S6 della registrazione (Claudio ha il link; il `.txt` non ha timestamp) | §2.10 |
| D7 | Pre-ORB DAX: **la "versione corretta del Circle"** (r.269 *"questa fa parte del percorso di scatting"* `[TRASCRITTO dubbio]`: scalping?) e quella che ci ha dato sono la stessa cosa? | per non confondere le due ORB nei confronti |

---

# PARTE 6 - NESSUNA AZIONE SUL CAMPO

- **Non toccato:** nessun preset, EA, sedia, conto, terminale, VPS, forward, parametro di rischio o taglia. Nessun round lanciato, nessuna riga di lancio scritta, nessun messaggio a Claudio.
- **Letto solo:** trascrizione `LIVE_PAOLO_2026-10-06.txt`; schede e dossier del repo citati; `mql5/Experts/ABTG_ORB_Ottimizzato.mq5` r.201 e r.505-506; preset `ABTG_ORB_Ottimizzato_DOW_FTMO_TRIAL.set` r.91.
- **Documento passato dal cancello (strati 1 e 2, 07/10).** Le proposte della Parte 4 restano **specifiche**: per diventare un file prova ripassano **di nuovo** dai due strati.

## Esito del controllo deterministico
`python3 backtest_pipeline/controlla_riga.py --oggetto md` su questo file e su `ANALISI_LIVE_EMILIANO_2026-10-07.md` (07/10/2026): **ESITO: nessun difetto meccanico**; 1 rilievo [225] (la prosa nomina il conto 50504263 in P-2: lettura di un giornale esistente, **nessuna stringa e nessun terminale toccato**). Strato 2 (`controllo-preventivo`) fatto il 07/10: **PASS CON RISERVE** dopo le correzioni elencate in fondo.

## Correzioni del cancello (strato 2, `controllo-preventivo`, 07/10/2026)
Fatte nel file prima della consegna, controllate alla fonte (`cat -n` della trascrizione, EA, preset, mappe):
- §1.0/§1.2: la citazione *"il range e' troppo grande, il rapporto di rendimento non sta in piedi"* **non esiste** in trascrizione: sostituita con le parole di r.165 e r.205.
- §1.0/§1.2/§4.1: `InpMaxRangePct` e' marcato *"(edgeful)"* nell'EA r.201: la convergenza e' fra **due fonti esterne**, non "Paolo che ha ispirato la manopola".
- §1.0/B1/§4.2: r.233-235 **non dice che l'ordine fosse pendente**: tipo d'ordine `[NON CHIARO]` (gia' in D1).
- §4.2 ORB Dow: "CONTRADDETTO" ridotto a **confronto relativo**; sul Dow il merito e' sospeso (n < 150 o rischio).
- P-3: il contro-esempio confondeva **box** e **stop** (stop = box + 20, oppure 20 esatti se i +/-10 sono dal prezzo); aggiunto lo spread dell'ora 7 (2,80).
- P-4: la sedia trial e' **solo long**: dichiarato che lo split legge un lato.
- Citazioni rese letterali (r.269 "dipende una candela", "disegnamento", "scatting"); percorso `backtest_pipeline/REGISTRO_TEST.md`; data "10/07" -> 07/10; M3 presente in live Paolo vecchie.
