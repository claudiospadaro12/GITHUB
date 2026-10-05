# SCHEDA LIVE EMILIANO - 05/10/2026 (lunedi': "DAX, EURUSD e oro: pendenti, hedging e il primo scarico dell'apertura")

**Fonte unica:** `data/trascrizioni/LIVE_EMILIANO_2026-10-05.txt` (302 righe per `wc -l`, **303 per `cat -n`** perche' l'ultima
non ha l'a-capo finale; 30.283 byte; trascrizione automatica; commit `d0b54e75`). Letta per intero, riga per riga. Nessuna
navigazione, nessun completamento da memoria: dove cito il repo lo dico col file.
**Analista:** estrattore di trascrizioni (agente `analista-trascrizioni`), 05/10/2026.
**Come si leggono i riferimenti:** `r.NN` = numero di riga `cat -n` (le righe vuote contano). Le citazioni sono **verbatim**,
con le storpiature della trascrizione lasciate com'erano ("orodollo" = EURUSD, "Loro" = oro, "German"/"Das" = DAX, "ejami" =
hedging, "ordi dipendenti" = ordini pendenti); le sciolgo solo in §4.1 e fra parentesi quadre.

> ## REGOLA CHE VALE SOPRA TUTTO
> **Da questo materiale non si muove NIENTE.** Ogni numero qui dentro e' una **dichiarazione di una fonte esterna**
> `[DICHIARATO, NON verificato]`, mai un criterio nostro. Nessun preset, EA, conto, sedia o forward e' stato toccato per
> scrivere la scheda; nessun round lanciato. Le "misure proposte" della Parte 3 sono **specifiche**, non file prova e non
> righe di lancio: ognuna passa dal cancello (`controlla_riga.py` / `controlla_prova.py` + `controllo-preventivo`) prima di
> esistere, e i round girano **solo sul PC di backtest**.

Etichette: **[TRASCRITTO]** c'e' scritto (cito) - **[TRASCRITTO dubbio]** c'e' scritto ma puo' essere un errore di trascrizione -
**[INFERITO]** lo deduco (dico da cosa) - **[INCERTO] / [NON CHIARO]** non lo so e non lo deduco - **[DICHIARATO, NON
verificato]** numero o affermazione del relatore - **[DERIVATO]** calcolo mio da numeri scritti, formula nel testo -
**[LETTO nel repo]** viene da un file nostro, col nome - **[NON MISURATO]** il dato non c'e'.

**Orari.** La trascrizione **non dichiara mai il fuso**. Emiliano dice "sono le 9 e 10" (r.227) e "sette minuti l'apertura del
DAS" (r.69): coerente con l'apertura cash del DAX alle 09:00 **ora italiana** `[INFERITO]`, non dettata come tale. **Non converto
nessun orario del parlato.** Promemoria per chi legge: BCM e' UTC+1 fisso (`report/OROLOGIO_BCM_2026-09-24.md`), quindi il 05/10
(Italia ancora in ora legale) il server BCM e' un'ora indietro rispetto all'Italia `[DERIVATO da OROLOGIO_BCM]`; dal 26/10 no.

---

# PARTE 0 - IN TESTA: il giudizio su expert, PF, storico, regimi (Claudio sta per chiedere proprio questo a Emiliano)

> ## RISPOSTA SECCA: **in questa live NON c'e' niente di diretto.**
> `grep` sul testo (case-insensitive): **0** occorrenze di *profit factor*, *PF*, *storico*, *anni/anno*,
> *regime*, *drawdown*, *win rate*, *walk-forward*, *expert*, *challenge*, *prop*, *FTMO*, *funded* (**solo** *"profitto"* due volte, r.223 e r.231, come parola comune; **"EA"** e **"backtest"** una e due volte: r.3, r.17, vedi J1). Zero frasi su quanti anni servono
> a fidarsi di un EA, zero su bull/bear/laterale/crollo come criterio di validazione. **Non si puo' attribuirgli nessun parere
> sul criterio dei "~10 anni + piu' regimi" ne' sulla domanda 5 della mail** (`report/MAIL_PER_EMILIANO_2026-10-05.md`).

Quello che c'e' (poco, e tutto **[DICHIARATO, NON verificato]**), in ordine di rilevanza per Claudio:

| # | cosa dice | citazione | dove | che cosa vale |
|---|---|---|---|---|
| J1 | **Sta lui stesso facendo backtest di un EA sull'oro e "non produce risultati buoni"**: un "high frequency spreader su Lord [= oro]" | *"sto facendo andare in backtest un EA, quindi in realta' dovrei abilitare il trading"* (r.3) · *"sto facendo fare a Lord una serie di backtest su questo sistemino che e' un high frequency spreader su Lord, solamente che per il momento non produce risultati buoni"* (r.17) | r.3, r.17 | **E' l'unico aggancio** alla domanda di Claudio: Emiliano fa backtest in prima persona e ne parla con un criterio (risultati "buoni"/"non buoni") **che qui non e' detto**: nessun PF, nessun numero di anni, nessun periodo, nessun costo. **Domanda da fargli** (§6 D1): con che metro dice "non buoni"? Nota a margine: dice che il backtest in corso *"si scominterà un attimo la piattaforma"* [sic, STT] mentre fa live (r.17) |
| J2 | **Il suo "regime" e' la direzione multi-timeframe del giorno**, non una finestra di anni: si sceglie lo strumento che ha weekly e daily nella stessa direzione; quando c'e', *"posso anche sbagliarmi in grazia ma il profitto me lo porto, sicuro"* | *"andare a trovare gli strumenti che ti diano su Devi e su Wi-Fi la direzione"* (r.221) · *"quando ho la direzione dei Wi-Fi dei Devi, posso anche sbagliarmi in grazia, ma il profitto mi lo porto, sicuro"* (r.223) [TRASCRITTO dubbio: "Devi"="daily", "Wi-Fi"="weekly"] | r.33, r.221-223, r.297 | E' un'**affermazione empirica non misurata** ("allineamento W1+D1 = profitto sicuro"). **Non e' un criterio di validazione degli EA**; e' il suo filtro di giornata. Va confrontata con i nostri filtri di direzione (§2 C7) |
| J3 | **La volatilita' del giorno rispetto alla media e' un semaforo**: l'EURUSD ha fatto 96-97 pip di notte contro una media giornaliera di 51 (fonte: sito Mataf) ⇒ *"per forza c'e' qualcosa"*, *"toccare l'orodollo mi sembra abbastanza pericoloso"* | r.43-61 | r.43-61 | **Un regime di volatilita'** applicato a mano. Non e' un criterio sugli EA; e' un'ipotesi di filtro (§2 C8) |
| J4 | **Il lunedi' e' un giorno da evitare/ridurre**: *"oggi sarebbe bene alzare le mani e stare tranquilli... in generale lunedi' non e' mai questa grande figata. Tutti ritornano a lavorare"* | r.229 | r.229 | Un **regime di calendario** dichiarato, non misurato. Poi opera comunque su tre strumenti (B4) |
| J5 | **Il mercato "cambia" e conta il contesto di giornata**: lo stesso livello (EMA200 H1 sul DAX) lo tratta come ostacolo il lunedi' all'apertura, ma *"di solito se va sulla media un sorgettino con uno scopo stretto ci potrebbe anche stare. Adesso no"* | r.105 | r.99-109 | Mostra che per lui **la stessa regola vale o no a seconda del contesto** (volumi, apertura, direzione): nessun valore fisso. E' l'opposto di un expert a parametri fissi: da tenere presente quando gli si chiede di giudicare le nostre sedie |

**Cosa NON si deve scrivere nel referto a Claudio:** "Emiliano dice che serve storico lungo / che 21 mesi non bastano / che il PF
conta": **non e' scritto.** Le uniche cose vicine sono J1-J5, e nessuna e' un criterio di validazione. La risposta alle sue cinque
domande dovra' venire **da Emiliano, a voce o per iscritto**: questa live puo' solo suggerire le domande a margine (Parte 6).

---

# PARTE 1 - LA SINTESI (la pagina che si legge per prima)

## 1.0 La riga che conta

> **Su 303 righe: 20 voci di parametro (nessuna e' una regola completa e verificabile), 18 meccanismi, 9 bandiere (1 ROSSA PIENA:
> hedging come alternativa allo stop; 4 arancioni; 4 ambra), ZERO regole prop, ZERO trucchi anti-prop, ZERO frasi su PF/storico/regimi
> degli expert.** Il tono e' operativo: Emiliano *"fa"* il trading in diretta (DAX, EURUSD, oro) e lo spiega mentre lo fa
> (*"e' stata una live un po' operativa, un po' tanto, vi chiedo scusa, mi sono fatto prendere un po' la mano"*, r.301).
> **Il pezzo piu' importante per noi non e' un parametro: e' una bandiera.** A r.235-243 descrive, in prima persona, **l'hedging come
> alternativa allo stop**: *"Io ho due possibilita'... prendere lo stop... oppure ejami [hedging]... metto sul massimo, sul minimo della
> candela precedente un ordine contrario della stessa quantita'"*. E' il meccanismo che **la nostra regola di casa esclude** (REGISTRO
> r.10, r.290, r.355; `report/ANALISI_LIVE_EMILIANO_2026-07-17.md` B1) ed e' la **seconda volta** che compare (07/17: *"eggiato"*).
> **Il secondo pezzo:** l'**EMA200 H1 come ostacolo del DAX all'apertura** (r.99-131, r.195-207) e il **"primo scarico"** dell'apertura
> (r.141-155) sono **due ipotesi che il repo ha gia' misurato in forma vicina e trovato nulle** (§2 C4-C5): la live le ripete, non le prova.
> **Il terzo:** la **cascata W1+D1** e il **semaforo di volatilita'** sono filtri di regime **mai misurati sul DAX** (§2 C7-C8).

## 1.1 Che cosa e' questa live, e che cosa NON e'

- **Chi parla:** Emiliano (host), **da solo in prima persona**; interlocutori in chat citati per nome (Matti, Luca, Tommy/Tommaso,
  Valerio, Edo, "Mario"): usati solo come etichetta. **Attribuzione:** le frasi sul "primo scarico" (r.141-157) vengono da **Tommy** (allievo) e
  da Emiliano che le **riformula**: non sono una sua regola scritta `[INFERITO]`.
- **Quando:** **lunedi' 05/10/2026** (lui stesso: *"lunedi' non e' mai questa grande figata"*, r.229). Comincia **prima dell'apertura del DAX**
  (r.69: *"sette minuti l'apertura"*; r.117: *"Mancano 20 secondi"*; r.125: *"Aperto German"*) e arriva a *"sono le 9 e 10"* (r.227) `[INFERITO: ora italiana]`.
  Parte da una live **notturna** della domenica sera sull'oro (r.3, r.7, r.235).
- **Non e' una prop.** Zero `prop`, `FTMO`, `funded`, `challenge`, `drawdown`. Nessuna regola di limite giornaliero, nessuna percentuale di rischio,
  nessun capitale dichiarato.
- **Qualita':** media-bassa. **Il passo r.273-295 e' un artefatto di trascrizione**: la frase *"Allora, sale di due."* ripetuta **33 volte** (`grep -o`, conteggio mio) **non e' una regola di raddoppio**
  (non e' martingala): e' un loop dello speech-to-text. Parti incomprensibili sono segnalate una per una. r.73-83 sono una digressione sul lago di Lecco: scartata.

## 1.2 Strumenti, setup, orari, parametri citati (valori) - tutto `[DICHIARATO, NON verificato]`

| strumento | che cosa fa / dice | valori citati |
|---|---|---|
| **EURUSD** (*"orodollo"*) | weekly **e** daily ribassisti → *"range palesemente short"*; cerca un punto d'ingresso short sulla media; il 61,8% di Fibonacci come *"massima estensione"* | notte **96-97 pip** contro media giornaliera **51 pip** (Mataf); ingresso/target *"sul livello di 51 pips"* con confluenza; sell di **1** e di **2**; media a **14** in M5 (P1-P6) |
| **DAX** (*"German"*, *"Das"*) | opera **short** all'apertura (EMA200 H1 + numero tondo + Supertrend), poi **chiude lo short e va long** su **25.200**; ordine **"civetta"** piccolo, poi la parte importante piu' lontana | civetta **2 contratti**, **4** sotto la media, **10/20** "la parte importante" `[TRASCRITTO dubbio]`; distanze **400** e **150 punti**; media **89**; "40 punticini" (P9-P15) |
| **Oro** (*"Loro"*) | **sconsigliato** (*"meglio non tradarlo"*, r.19) ma opera lo stesso: buy stop pre-apertura, poi si ritrova con long e short e **si "lega"** (hedging) | livelli (prefisso non detto): supporto **19-29**, obiettivi **55, 66, 75**, Fib **38,2**; *"un contratto long e due contratti short"*, *"due sell da due e un buy da uno"* (P16-P19) |
| **ORB** su DAX e oro | *"adesso sono le 9 e 10, manca ancora 5 minuti per prendere in considerazione l'ORB su German e sull'oro"*; oro: *"due ORB: sessione europea e americana"* (15:30) | **09:15** `[INFERITO]` (stesso del *"nel 2015"* del 02/10); durata range **non dichiarata** (P7-P8) |
| **Stop** | in pari; **sotto il VWAP** *"come sempre"*; **sotto il Supertrend**; *"uno stop di cinque"* (oro, buy stop); stop unico per tutte le gambe | nessuna distanza in punti, tranne r.121 (P17) |

## 1.3 Regole di rischio / prop

**Nessuna regola prop. Nessun limite giornaliero. Nessuna percentuale.** Le uniche regole di rischio sono personali e qualitative:
*"devo essere conservativo"* (r.67), *"entrare prima dell'apertura e' rischiosissimo"* (r.95-97), *"io alleggerisco"* (r.211), *"io qua non voglio
perdere da questa operazione, assolutamente"* (r.213), *"State attenti sempre all'apertura della candela"* (r.299), *"bisogna stare fermi"* (r.107).

## 1.4 Numeri dichiarati (mai criteri nostri)

*"ho chiuso la live a meno mille"* (la live notturna, r.7); *"25 euro il caffe' pagato"* (DAX, 2 contratti, r.209); *"numero tondo che ci sta dando gia'
cento euro"* (r.267); *"100, 25, cosi' lui mi ha pagato"* (r.299). **Nessun risultato netto della giornata.** Nessun capitale, nessun R. Tutte
cronaca di una mattina, **n = 1, un regime**.

## 1.5 Bandiere rosse (dettaglio in §4.6)

**1 rossa piena - HEDGING** come alternativa allo stop (B1). **4 arancioni:** stop non definito prima dell'ingresso (B2); scale-in con range
ampio e stop comune (B3); consiglia di non operare l'oro e lo opera (B4); size corretta in diretta (B5). **4 ambra:** flip short→long sullo
stesso indice in minuti (B6); pendenti notturni sull'oro chiusi in perdita (B7); vittoria presentata come prova (B8); assoluti non verificati (B9).
**Trucchi anti-prop: 0.** Recovery/mediazione/griglia: 0 parole (ma B1 e B3 ne sono parenti: vedi sotto).

## 1.6 Quello che NON c'e' (verificato con `grep`)

| pratica cercata | occorrenze | nota |
|---|---:|---|
| prop / FTMO / funded / challenge / drawdown | 0 / 0 / 0 / 0 / 0 | (`prop` compare solo dentro "proprio") |
| martingala / raddoppio / griglia / recupero / copy | 0 / 0 / 0 / 0 / 0 | **"sale di due" x33 = loop STT**, non raddoppio |
| "senza stop" | 0 | *stop* compare **15 volte** (`grep -o -i`, include "stoppo"); ma in B2 lo stop e' **da trovare dopo** l'ingresso |
| PF / storico / anni / regime / expert (come giudizio) | 0 | Parte 0 |
| VWAP / Supertrend / Fibonacci / media 200 | 1 / 7 / 1 / 4 | a differenza del 02/10 (*"senza indicatori"*), **oggi usa gli indicatori** |

---

# PARTE 2 - IL CONFRONTO COL REPO: cosa conferma, cosa contraddice, cosa e' nuovo

Fonti lette: `report/SCHEDA_LIVE_EMILIANO_2026-10-02.md`, `...-09-30.md`, `report/ANALISI_LIVE_EMILIANO_2026-09-18.md` (testata, sintesi e riga F),
`report/APERTURE_DAX_MAPPA_2026-10-03.md`, `report/APERTURE_DOW_MAPPA_2026-10-03.md`, `report/APERTURE_NASDAQ_MAPPA_2026-10-03.md` (testata),
`report/EMA200_GEMELLI_STATO_2026-10-03.md`, `report/CENSIMENTO_ORB_2026-09-29.md`, `report/DOSSIER_EXPERT_PER_EMILIANO_2026-10-05.md`,
`backtest_pipeline/REGISTRO_TEST.md` (righe citate). **Convergenze con Emiliano = NON indipendenti** (stessa scuola: il corso e' la fonte di molte nostre sedie).

| # | tema | live 05/10 | repo `[LETTO nel repo]` | verdetto |
|---|---|---|---|---|
| C1 | **Massimi/minimi della notte + ORB come strumenti del mattino** | *"Noi dobbiamo andare a tirare fuori i nostri vecchi massimi e minimi della notte. E l'orb. Cioe' non c'e' un'altra soluzione qua"* (r.171); *"i massimi della notte li ho gia' bruciati"* (r.39) | `770411` MaxMin DAX **short** sul box notturno (PF OOS 2,16 su **14** posizioni: n<30, il PF non si legge); rottura LONG del box **0/18 celle** (scheda 30/09 §4.3); ORB Dow `770611` | **CONFERMA l'impianto** (stessa scuola). Non e' una prova di merito |
| C2 | **Non entrare prima dell'apertura** | *"entrare prima dell'apertura e' troppo rischioso"* e *"rischiosissimo"* (r.95-97) | ritest `770101`/`770105`: armano **dopo** il range di 35' (mai pre-apertura) → coerente. **`770411` arma alle 08:59 IT** (scheda 30/09 §1.2 #5) = pre-apertura → **tensione**. Prior: `PRV_DAXAP_03`, ritardo +5/+10/+15: IS sale (2,60 / 4,03 / 4,66), OOS crolla (1,130 / 0,568 / 0,325) su **13-15 deal** = non leggibile (mappa DAX §2.6) | **CONFERMA per i ritest, TENSIONE per `770411`**. E **contraddice il 02/10** (stesso relatore): *"il rischio in questo caso e' ancora moderato"* (scheda 02/10 B4). Due live, due regole |
| C3 | **ORB a 15 minuti (09:15)** | *"sono le 9 e 10, manca ancora 5 minuti per... l'ORB"* (r.227) → range 09:00-09:15 `[INFERITO]` | censimento ORB §0.4: *"Emiliano (15 min): contraddetto sul DAX in OOS, non contraddetto sul Dow in OOS"*; DAX breakout 5-15' **0/4 OOS**, il solo valore positivo in entrambe le finestre e' **35'**; costo del range 15' = **33,9x** su BCM (sotto 40), 43,3x FTMO (mappa DAX §3.1); ORB Dow 15' **vive** (OOS PF 1,67 n=119) | **CONTRADDICE sul DAX, non sul Dow.** Gia' agli atti dal 29/09: **non si rimisura** |
| C4 | **EMA200 H1 come ostacolo del DAX all'apertura** | *"e' proprio sulla media del 200... In H1"* (r.101); *"German. Respinto. Da la media al 200 in H1"* (r.129-131); *"Abbiamo la media che spinge"* (r.205) | EMA200 sul DAX: **H1 0/28 celle positive** (PF mediano 0,811; cella esatta OHLC 0,848 su 777 deal, DD 14,53%), **corto tick OOS 0,724** (R234b); il rimbalzo al primo tocco **non si distingue da una passeggiata casuale** (0,47-0,49 contro 0,48-0,49; dossier §B3). L'EMA200 **vive solo sul Dow H1** (PF OOS 1,52 su 257 posizioni): *"edge specifico del Dow H1"* | **CONTRADDICE come regola generale.** Per lui e' **un evento** (lunedi' 05/10), non una statistica. **Si ripete dal 30/09** (confluenza EMA200 H1 + tondo + Supertrend dei colleghi): ripetizione dello stesso paradigma, non conferma |
| C5 | **"In apertura, su un livello importante, scarica sempre in direzione opposta"** | *"In prima istanza fa sempre quello scarico... Apre e salta. Apre e scarica"* (r.141-145, **Tommy**); *"In prima istanza in apertura scarica sempre in direzione opposta"* (r.155); *"aperto sopra ma poi andato subito giu', scarico dei volumi"* (r.209) | `RANGE_FADE` DAX: **0 celle su 24 con PF >= 1**, due lati OOS 0,772; stop ad ATR M5 = **13,7x lo spread: ESCLUSO PER COSTO** (M15 23,6x); lemma del REGISTRO (r.1571-1577): *"il fade e' lo specchio del breakout sugli stessi prezzi... paga lo spread due volte"*; **per lato e TF M30/H1: NON MISURATO** (casella 5). Il **fade con confluenza** e' gia' la misura **M-2 del 30/09**, mai eseguita | **TENSIONE + ipotesi gia' in lista.** "Sempre" e' un assoluto di un allievo (B9). Specifica S2 (Parte 3) |
| C6 | **Numero tondo come livello d'ingresso/estensione** | *"sul mio rotondo di 300"* (r.209), *"Long su 25.200"* (r.251), *"bisogna lavorare sotto il numero tondo per l'estensione"* (r.257), *"Numero tondo che ci sta dando gia' cento euro"* (r.267) | `SRBlocked` conosce PDH/PDL e numeri tondi **solo come ostacoli** (opt-in, spento: scheda 02/10 §1.5 #1). Una misura del tondo **come livello d'ingresso**: `[NON VERIFICATO da me]` che esista | **RIPETIZIONE del 02/10** (25.000 allora, ora 25.200). Entra come confluenza in S2 |
| C7 | **Cascata: weekly e daily nella stessa direzione prima di tutto** | r.33, r.221-223, r.297 | Dow `770202`: **filtro EMA H4 1/50 = "la manopola che fa il Dow"** (spento PF 1,03 / DD 14,9%; acceso 1,24 / 6,9%; mappa Dow §5 M3); `771531`: bias EMA14; **DAX Apertura: `InpUseEmaFilter=false`, Supertrend e VWAP spenti** (EA, r.262-281; `NOTTE_2026-09-24`: *"sul DAX i filtri sono spenti"*). Un filtro **D1/W1 per lato sul DAX**: `[NON MISURATO]` (non lo trovo in nessuna mappa) | **CONFERMA l'idea, NUOVO sul DAX.** Limite duro: la finestra tick e' ~21 mesi, il **W1 non e' misurabile** (EMA50 settimanale = 50 settimane di riscaldamento) |
| C8 | **Semaforo di volatilita': notte >> media = prudenza** | 96-97 pip contro 51 (r.43-61) | `InpUseAtrFilter` vive **solo** in `ConfirmOK()`, chiamata da BREAKOUT/FADE/DELAYED/GAPFILL, **non dal RETEST** (inventario N9, `INVENTARIO_MOTORI_APERTURA_2026-09-24.md` r.80): **sui ritest vivi non esiste nessun filtro di regime di volatilita'** | **NUOVO** (mai misurato sui ritest). Specifica S1(b) |
| C9 | **Ordine "civetta" + parte importante piu' lontana** | *"l'ordine civetta mi piazzo con quattro contatti... la parte importante dell'operazione me la metto sui 400"* (r.209) | `ABTG_SuperWave`: `InpFirstFraction=0,3333` (1/3 a mercato + 2/3 su pendente a 20 pip), **mai ad asse** (`SUPERWAVE_LE_56_PASSATE_FERME_2026-09-23.md` r.215); `R124a_U30USD_04_firstfraction.txt` **scritto il 09/09, mai girato**. La live del **18/09** diceva *"un terzo o due terzi"*; quella del **02/10** *meta'/meta'*; oggi **~2 su 20** (circa 0,10) `[TRASCRITTO dubbio]` | **CONFERMA il tema** (stessa persona, **non indipendente**), ma **la frazione NON e' stabile** da una live all'altra (1/3-2/3, 1/2, ~0,10): `[INFERITO]` e' discrezionale, non una regola. R124a (0,33→0,93) **non copre** lo 0,10 |
| C10 | **Parziale, stop in pari, stop sotto VWAP/Supertrend, "alleggerisco"** | r.211, r.215, r.255, r.273, r.295, r.301 | preset DAX/Dow: **TP1 50% + BE + trailing PREVBAR M5**; SuperWave: trailing Supertrend **paga** (spento: PF IS 1,49 → 0,90); `InpUseVwapFilter=false` | **CONFERMA la ricetta d'uscita** (gia' nostra). **Stop sotto VWAP**: `[NON VERIFICATO]` se misurato come stop |
| C11 | **HEDGING come gestione della perdita** | r.235-243 (B1) | **esclusione di casa**: REGISTRO r.10 (*"NIENTE hedging/martingala"*), r.290, r.355; `ANALISI_LIVE_2026-07-17` B1 rossa (la live del 28/09 non lo conteneva: *"hedging 0"*) | **CONTRADDICE la nostra regola.** Non si misura, non si copia |
| C12 | **Due ORB sull'oro (europeo + americano 15:30)** | r.227 | ORB oro **gia' misurato e negativo**: G1 `ORB_Ottimizzato` XAUUSD 30' (R10) OOS PF 0,87-0,999, nessuna cella verde in entrambe; G2 Londra (R45a) **0/8 IS e 0/8 OOS**; G3 sonda 15:30 su M1: **fenomeno assente** (5 candele stesso colore 4,78% contro 6,25% di una monetina) e **costo 5,10x** contro 40x. **Aperto e mai misurato:** ORB 30-60' su M30/H1 (censimento ORB §10) | **CONTRADDICE per costruzione, nessuna misura nuova**: non si riapre. Il buco vero e' un altro e c'e' gia' |
| C13 | **Pendenti notturni sull'oro** | *"con ordi presenti chiarati a un livello di dicembre 39, in short"*, *"mettendo gli ordi dipendenti come ho messo oggi"* (r.7, r.29) `[NON CHIARO]` | candidato `MaxMin oro` (box notturno): tick OOS 1,45 su 93 pos; **22 anni a barre PF 1,10, DD 10,3%, 11 anni negativi su 23** (dossier §B2.9) | **CONVERGE nell'idea** (pendenti sul livello della notte), livello e lato non dettati. Niente da aggiungere |
| C14 | **Lato del DAX: oggi short, poi long** | r.203, r.251-255 | ritest short `770105`: PF **0,965 / 0,957**, DD OOS **12,3%** (bocciato per rischio); long `770101` OOS 1,397 su 193 pos | **Il "due lati insieme" di Emiliano e' una scelta di giornata**; da noi i lati si misurano **per lato** (regola 25/08) |
| C15 | **Lunedi' come giorno debole** | r.229 | nessuna misura per giorno della settimana sulle sedie indice (`grep` su registro e report: solo un "cumulo del lunedi'" di `GapFill`, altra cosa) | **NUOVO.** Specifica S1(c) |

**Una cosa che il repo registra e che sta accanto alla B1:** il 30/09 Claudio ha chiuso la challenge FTMO dopo **tre trade manuali sull'oro**
(sell 5,00 -572,05; buy 5,00 -301,47; buy 2,00 -125,91; `HANDOFF.md` r.44). Non e' un giudizio su nessuno: e' il fatto che la **gestione discrezionale in perdita
sullo stesso strumento** (long e short alternati) e' la forma esatta che B1 descrive. Va letta come promemoria di casa, non come confronto fra persone.

---

# PARTE 3 - LE MISURE PROPOSTE (SPECIFICHE: nessun file prova, nessuna riga, nessuna decisione)

Ordine di valore per **una sedia schierabile**, che e' **basso** qui (la live e' discrezionale, gli unici pezzi misurabili sono filtri e
un'ipotesi di fade). Per ognuna: **attesa e contro-esempio scritti PRIMA di qualunque numero**; **costo**; i round girano **solo sul PC di
backtest `DESKTOP-H4D7CAJ`**, mai sul VPS. Regole di casa applicate: nessuna griglia su motori senza edge (il lato corto del DAX retest e' a PF 0,96: lo si legge per
**forma e rischio**, mai per parametri); **due lati sempre**; **n >= 150** per il merito (dove non c'e': si dichiara che il merito e' sospeso); **regime dichiarato**
(21 mesi, **un solo regime**: rialzo con discesa feb-apr 2025); **40 x spread** (DAX: 68,0 idx BCM, 53,2 FTMO P95) come primo cancello; **orologio dichiarato**.

## S1 - "La cascata del mattino": tre split ex post sui per-trade che gia' esistono (priorita' 1; **zero passate di tester**)

- **Perche':** sono le **tre cose che la live aggiunge e che non sono mai state misurate sul DAX** (C7 bias di direzione, C8 volatilita' della notte, C15 lunedi')
  e si possono leggere **senza ripetere nessun round**, sui per-trade del ritest long `770101` (193 posizioni OOS, 132 IS: `[LETTO mappa DAX §2.1]`) e, **solo per forma e rischio**, dello short `770105`.
  `[NON VERIFICATO da me]` quali per-trade IS esistono e dove: e' la prima cosa da controllare (§6 Q2).
- **Tre definizioni, congelate ora, una per split, senza scansione:**
  - **(a) bias D1** = segno di `Close_D1[1] - EMA50_D1[1]` (stessa forma del filtro "EMA 1/50" del Dow, TF D1). **Si perdono le prime ~50 barre D1** dal 2024.09.26 `[DERIVATO]`
    (l'IS-era scende da ~8,5 a ~6 mesi, **n IS long ~90** `[DERIVATO: 132 x 6/8,5]`). **W1: DICHIARATO NON MISURABILE** su 21 mesi (warm-up di 50 settimane): nessuna proxy inventata.
  - **(b) notte/ADR** = range della notte (**stessa finestra del box del `770411`**, letta dal suo preset, **non scelta qui**) / media dei range giornalieri a 14 giorni. **Evento = rapporto >= 2,0**:
    il 2,0 e' *"il doppio"* di Emiliano (r.53) **usato solo per definire l'evento**, non come criterio nostro. **Passo 0:** contare i giorni-evento; se **< 15 su ~459 feriali** `[459 = LETTO mappa Nasdaq §0.2]` → *"campione inesistente: chiusa"*, senza leggere nessun PF.
  - **(c) lunedi'** contro martedi'-venerdi' (l'unica partizione, quella che dice lui).
- **Attese (scritte ora):**
  (a) **long:** |ΔPF(allineato − tutti)| <= 0,15 in **entrambe** le ere (0,147 = banda di rumore gia' misurata nella mappa DAX §2.1 riga "parziale") e quota di giorni con bias rialzista **>= 70%** (e' un rialzo): il filtro e' **quasi muto** → *"il default va bene"*.
  **short (forma):** campione < 80 posizioni → **si leggono DD e distribuzione, non il PF**.
  (b) conteggio **< 15 giorni** (la notte >2x la media e' rara). (c) |ΔPF(lunedi' − altri)| <= **0,30**: con ~65 posizioni di lunedi' l'errore tipico e' ~0,2 x √(144/65) ≈ 0,30 `[DERIVATO da "errore tipico ~0,2 a n=144", dossier §B2.9: una stima]`.
- **Contro-esempio (cosa mi smentisce):** (a) lo **short allineato** con **PF >= 1,20 su >= 50 posizioni** e il **non allineato <= 0,85**, **in IS-era e OOS-era** ⇒ *il filtro di direzione fa al DAX short quello che fa al Dow* ⇒ **passo 2, non automatico**: prova di regime con il DAX esterno 2010-2018 (1,72 milioni di barre M1, **SOLO_PROVA_REGIME, mai importato**: serve una firma). (c) PF(lunedi') < 0,85 **e** PF(altri) > 1,25 in entrambe le ere con n >= 40.
  **Molteplicita' dichiarata prima:** 5-6 confronti a banda ~1 sigma ⇒ **almeno una sporgenza per caso e' l'attesa**: una sporgenza isolata **non vale**; vale solo una che regge **in entrambe le ere e nel controllo per stagione**.
- **Controlli obbligati:** (i) lettura **dentro stagione** (estate cash / inverno 1h prima), perche' i per-trade di `770101` **mescolano le due tempistiche** (`OROLOGIO_BCM_2026-09-24.md`; mappa DAX §4); (ii) stesso split su un **insieme casuale** di giorni con la stessa frequenza.
- **Regime / limite:** **un solo regime**; **merito sospeso** (n < 150 dopo ogni split): si giudicano **forma e rischio**. **Certificato di morte:** un esito negativo **non archivia** niente (mancano TF, gemelli, gestione).
- **Costo:** **0 minuti di Strategy Tester.** Lavoro: un lettore sui per-trade + D1 del `D30EUR` (copertura da verificare, §6 Q3) + i due cancelli: **ore, non giorni** `[NON MISURATO]`.
- **Non fa:** non tocca nessuna sedia, nessun preset; **non** propone `InpUseEmaFilter` acceso sul DAX (e' una decisione che dipende dall'esito).

## S2 - "Il primo scarico dell'apertura DAX": studio di eventi con controllo casuale (priorita' 2; **zero tester**; estende M-2 del 30/09)

- **Perche':** e' la **stessa domanda di M-2 del 30/09** (il fade con confluenza aggiunge qualcosa oltre l'inversione della rottura?), ora con un **evento preciso** (apertura cash + EMA200 H1 + tondo) che Emiliano e Tommy dichiarano *"sempre"* (C4-C5). E' un **meccanismo alternativo sulla stessa inefficienza** (regola della seconda caccia), **non** parametri di un motore morto.
- **Passo 0 - costo-first, aritmetica, 0 minuti:** un fade ha bisogno di uno stop; il pavimento e' **stop >= 40 x spread = 68,0 idx (BCM, 1,70) / 53,2 (FTMO P95 1,33)** `[LETTO mappa DAX §3]`. Il movimento che lui cita, *"50 punti"* (r.153) `[DICHIARATO]`, e' **sotto 68,0**: se la **mediana del movimento di ritorno** misurato e' < 68 punti, **R < 1 per costruzione** e lo studio **chiude da solo** per costo (con il numero accanto), senza leggere nessuna probabilita'.
- **Passo 1 - definizione congelata (una sola):**
  sessioni = tutti i feriali `D30EUR` 2024.09.26-2026.06.30 (**~459**); **t0 = apertura cash del DAX ricavata da UTC** (08:00 UTC d'inverno, 07:00 UTC d'estate; sul server BCM UTC+1 fisso = ore 09:00 d'inverno / 08:00 d'estate; **non si usa l'ora fissa 8**, quindi e' "in fase" per costruzione);
  **F** = direzione della prima candela M5 `[t0, t0+5']`; **inversione** = a `t0+35'` (durata del range vivo, non scelta qui) il prezzo sta **dal lato opposto** a F rispetto a `open(t0)`;
  **confluenza** (due condizioni separate dichiarate: **A** = EMA200 H1 vicina, **B** = numero tondo vicino) con **una sola banda: |open − livello| <= 0,3 x ATR14(H1)** (la banda **della nostra sedia `771531`**: ordini a 0,2/0,3 ATR, non scelta da lui; **tondo = multiplo di 100 punti** `[INFERITO dai tre esempi 25.000 / 25.200 / "300"]`).
  **Lati:** F su (inversione = short) e F giu' (inversione = long) **entrambi**: 2 condizioni x 2 lati = 4 confronti, dichiarati.
- **Controlli:** (i) base **incondizionata** P(inversione) su tutti i giorni; (ii) **stesso test a un orario di controllo senza apertura** (`t0' = t0 + 2h`, dichiarato) per escludere una mean-reversion generica; (iii) **bootstrap** sui giorni (banda al 95%).
- **Attesa (scritta ora):** **nessuna differenza** fra condizionata e incondizionata oltre la banda bootstrap; P(inversione) incondizionata **0,50 ± 0,05**. Ragioni gia' in casa: lemma *"fade = specchio del breakout a costo doppio"* (REGISTRO r.1571-1577), `RANGE_FADE` DAX **0/24**, EMA200 al primo tocco **0,47-0,49 contro 0,48-0,49** (dossier §B3).
- **Contro-esempio:** P(inversione | A) o P(inversione | B) **sopra la banda superiore in IS-era E in OOS-era con n >= 40 per era**. **n atteso:** la quota di giorni con la confluenza e' `[NON MISURATA]`; se fosse 15-25% → **70-115 giorni totali = 35-55 per era = sul bordo**: se < 40 per era l'esito e' *"non misurabile per campione"*, **non "morto"**.
- **Cancello a valle:** se passa, **non entra nell'imbuto**: serve stop >= 40 x spread con TF di gestione **M30/H1** (M5 = 13,7x e M15 = 23,6x sono **esclusi per costo**, mappa DAX §3.2); un solo regime; **orologio dichiarato**.
- **Costo:** **0 passate di tester.** Python su M1 `D30EUR` (copertura da verificare, §6 Q3). Condivide il codice con M-2 del 30/09: **ore, non giorni** `[NON MISURATO]`.
- **Prior da ricordare:** `PRV_DAXAP_03` (ritardare l'ordine del `770411`): IS sale, OOS crolla su 13-15 deal: **non si legge**. Lo studio S2 e' la versione **a campione pieno** di quella domanda.

## S3 - Girare **R124a** (gia' scritto): la frazione d'ingresso, con un limite dichiarato (priorita' 3; **~1,3 minuti**)

- **Che cosa:** `backtest_pipeline/prove/R124a_U30USD_04_firstfraction.txt` (`ABTG_SupRev_DOW_H1_Ottimizzato`, U30USD H1; asse `InpFirstFraction` = 0,3333 / 0,5333 / 0,7333 / 0,9333; **attese B1-B5 e soglie gia' scritte nel file**: non le riscrivo). Scritto il **09/09, mai girato** (`USCITE_DELLA_ROSA_2026-09-19.md` r.119).
- **Perche' da questa live:** il **tema ricorre tre volte** (18/09, 02/10, 05/10) **ma la frazione non e' stabile** (1/3-2/3, 1/2, ~0,10: C9). Questo **abbassa** il valore: l'asse di R124a **non arriva a 0,10** (sotto ~0,13 si misura il pavimento del lotto, non il parametro: dichiarato nel file). **Non e' una conferma di Emiliano: e' un buco nostro che costa un minuto.**
- **Costo:** **1,3 minuti** di tester `[DICHIARATO nel file / ROUND_ALTOPIANO_SUPREV r.361]`; **cautela scritta nel file**: *"il numero 1,43648 e' stato prodotto da un binario che non esiste piu'"* → la cella 0,3333 e' la sentinella e **va letta per prima**. Passa dai due cancelli come tutto il resto. **E' una corsa di ricerca sul PC di backtest; **la riga di lancio passa dai due cancelli** come tutte le altre (nessuna riga e' preparata qui).

## S4 - "Il 05/10 al minuto" (**zero macchina**, una domanda a Claudio; stile M-1 del 30/09)

- **Domanda:** il DAX stamattina ha fatto davvero **"apre e scarica"** sulla EMA200 H1 (r.129-131, r.209) e **che cosa hanno fatto le sedie** (`770411`, `770101`, `770105`)?
- **Cosa serve:** uno screenshot M5 `D30EUR` (BCM) o `GER40.cash` (FTMO) **08:50-09:40 ora italiana** + il giornale delle sedie del 05/10 (**con il numero di conto e la cartella del terminale scritti in testa**). Oggi 05/10 e' ancora ora legale: il server BCM e' un'ora indietro (§orari).
- **Attesa (scritta ora):** la prima candela M5 dopo l'apertura cash ha il massimo **sopra** l'apertura e **chiude sotto** (e' la descrizione r.209: *"aperto sopra ma poi andato subito giu'"*). **Contro-esempio:** la prima M5 **chiude sopra** l'apertura ⇒ la mattina descritta non e' quella che vedo.
- **Costo:** zero. **Limite:** **n = 1 giorno**: **e' una domanda, non evidenza**; serve solo a **ancorare la lettura** e a vedere se `770411` ha armato/trigger-ato in pre-apertura (C2).

## S5 (CONDIZIONATA a una risposta di Emiliano) - "l'estensione = volatilita' media" su EURUSD

- **Non la parametrizzo adesso:** *"io mi metto sul livello di 51 pips... dove quella e' la massima istensione"* (r.57) **non dice da dove si misura l'estensione** (dall'apertura giornaliera? dal minimo notturno? dal massimo?). Con due ancoraggi possibili, scegliere io = **una scansione**: classe vietata.
  **Prima si chiede l'ancoraggio** (§6 D4). Se risponde, e' uno studio di eventi su forex dove **lo storico lungo esiste** (dati nativi EURUSD dal 1971, ~27 anni a barre: dossier §C), **quindi l'unico studio di questa scheda che potrebbe soddisfare "~10 anni + piu' regimi"** (a barre: forma, non PF). **Attesa gia' nota:** nulla (stesso lemma del fade). **Costo:** zero tester.

## Cosa NON propongo (col motivo)

- **Hedging / "ejami" / lock con pendenti** (B1): **esclusione di casa**, nessuna misura.
- **ORB oro europeo + americano:** **gia' misurato e negativo** (C12); l'unico buco (ORB 30-60' M30/H1) e' gia' nel censimento ORB.
- **ORB DAX a 15':** DAX 5-15' **0/4 OOS** (C3); non si rimisura.
- **EMA200 H1 come ostacolo su DAX/oro:** **0/28** e rimbalzo ~casuale (C4).
- **Griglie su ingresso/stop del lato corto del DAX retest** (PF 0,96): regola del 19/08.
- **Nessuna modifica in forward, nessun preset, nessun filtro news, nessuna taglia.** Il filtro news dei preset FTMO resta una decisione di Claudio (gia' agli atti dal 02/10).

---

# PARTE 4 - LA SCHEDA DI CASA

```
FILE             data/trascrizioni/LIVE_EMILIANO_2026-10-05.txt  (303 righe cat -n, 30.283 byte)
RELATORE/CANALE  Emiliano (host, opera in prima persona); partecipanti in chat; live pubblica
OGGETTO          Lunedi' 05/10 mattina: DAX (apertura 09:00 IT), EURUSD, oro; analisi weekly/daily, volatilita' Mataf,
                 EMA200 H1 + numero tondo, ordine "civetta", hedging sull'oro, ORB 09:15, chiusura parziale
```

## 4.1 Le ricostruzioni dell'ascolto (tutte [INFERITO], nessuna entra in un numero)

| nel testo | lo leggo come | su che base |
|---|---|---|
| "orodollo", "Neurodollaro", "l'euro dollaro" | **EURUSD** | r.89 *"Germo, Neurodollaro e Oro"*; r.295-297 *"l'euro dollaro"* |
| "Loro", "Lord", "loro" (r.17, 111, 123, 231, 261) | **oro** (XAUUSD) | r.5 *"Parto con l'oro"*; r.17 *"high frequency spreader su Lord"* |
| "German", "Das", "DAS", "DAX che vada" | **DAX** | tutta la live |
| "orb", "orgo", "l'orb" | **ORB** | indicazione di Claudio gia' agli atti |
| "Wiki", "Wheatley", "Wi-Fi" | **weekly** | scheda 18/09 (*"weekly -> wiki"*) |
| "Devi", "Deni", "Daily" | **daily** | idem |
| "pre-section", "presection", "perception", "intersection", "cross-section" | zona di prezzo (supporto/resistenza/proiezione) | **mai definita** (anche il 30/09 e il 02/10) |
| "ordi dipendenti", "impedenti", "ordi presenti" | **ordini pendenti** | r.7, r.29, r.69 |
| "ejami", "leggiato", "ligiato" | **hedging / "legato"** (posizione di segno opposto) | r.241 *"Io adesso non sono leggiato, io adesso ho quattro contratti short e uno long"*; scheda 17/07 (*"eggiato"*) |
| "Cell di uno, cell di due" | **sell** di 1 e di 2 | r.65 |
| "WAP", "move up" | **VWAP** | scheda 18/09 (confermata dal contesto) |
| "contattini", "contatti" | **contratti** | r.209, r.251, r.257 |
| "Matti", "Mataf" | un partecipante / il sito **Mataf** | r.43-47 |
| "super trenz", "super trend" | **Supertrend** | r.211, r.253 |
| "Allora, sale di due." x33 (r.273-295) | **artefatto STT** | ripetizione identica, nessun contenuto |
| "rotondo di 300", "numero tondo" | numero tondo (prefisso 25.xxx **non detto** per il "300"; *"25.200"* r.251 e' detto) | r.209, r.251 |
| "tinenziamente", "tendenzialmente" | tendenzialmente | uso ricorrente |

## 4.2 Cronologia della live

| riga | cosa succede |
|---|---|
| r.1-7 | saluti; live decisa *"ieri"*; backtest in corso sull'oro; la live notturna dell'oro **chiusa "a meno mille"** |
| r.7-31 | **oro**: livelli, Fibonacci, H1/H4/D1/W1, *"meglio non tradarlo"*; *"preferisco non mettere nessun ordine"* |
| r.33-67 | **cascata W+D**: DAX negativo/incerto; **EURUSD ribassista** → volatilita' Mataf 51 pip contro 96-97 di notte; sell di 1 e 2; media 14 |
| r.69-97 | **7 minuti all'apertura DAX**; volumi in incremento; *"entrare prima dell'apertura e' rischiosissimo"* |
| r.99-131 | **DAX sulla EMA200 H1**; buy stop sull'oro; **apertura 09:00** (r.125); DAX *"respinto"* dalla EMA200 H1 |
| r.133-157 | **Tommy**: *"in prima istanza fa sempre quello scarico"*; 50 punti |
| r.161-221 | DAX incerto → max/min notte + ORB; **short sul tondo con ordine civetta**; corregge la size (*"e' di tre"*); cerca dove mettere lo stop |
| r.221-229 | **la "ciclista"/scaletta**: W+D → multi-TF → confluenze → ORB (09:15; oro: europeo e americano); *"oggi sarebbe bene alzare le mani"* |
| r.231-247 | **oro: hedging** (*"ejami"*), pendenti sul max/min della candela precedente |
| r.249-271 | DAX: chiude lo short, **va long su 25.200**; ordini 10/20; *"sono entrato con tutto"* |
| r.273-295 | **artefatto STT** (33 ripetizioni) poi EURUSD: stop sotto VWAP *"come sempre"* |
| r.295-303 | EURUSD, 61,8%, *"100, 25"*, apertura candela, chiusura, saluti |

## 4.3 PARAMETRI CON VALORE (20 voci; tutte [dichiarato, NON verificato])

| # | parametro | valore | citazione | dove | chiaro? |
|---|---|---|---|---|---|
| P1 | EURUSD **volatilita' media giornaliera** | **51 pips** (fonte: Mataf) | *"L'orodollo ha una volatilita' media di 51 pips. Cioe', vuol dire che... l'istensione tra massimo e minimo e' di 51 pips"* | r.49 | chiaro; **periodo e metodo di Mataf NON dichiarati** |
| P2 | EURUSD **movimento notturno** | **96-97 pips** | *"ha fatto 97 piti questa notte"* (r.43) · *"Ne ha fatti 96 di notte"* (r.49) | r.43, r.49 | le due cifre **differiscono** (STT?); **notte = quali ore: NON detto** |
| P3 | soglia di anomalia | **>2x la media**; *"20 pips e' un miracolo"* (la notte tipica) | *"e' andato oltre il doppio della sua volatilita' di notte"* · *"se l'orodollo lo fa a dire tanto, 20 pips, e' un miracolo"* | r.53, r.55 | chiaro; **e' una sua impressione, non una soglia di sistema** |
| P4 | ingresso/target a **1 x volatilita' media** | **51 pips** + confluenza; *"di solito, quando arriva alla fine dell'estensione, di solito rimbalza"* | *"io mi metto sul livello di 51 pips e mi metto o long o short, dove quella e' la massima istensione in concomitanza sempre di confluenze"* | r.57-59 | **ancoraggio NON detto** (da dove si misura?) → S5 |
| P5 | Fibonacci EURUSD | **61,8%** = *"massima estensione"*; *"61.8 puo' cambiare proprio la sua direzione"*; *"arrivato proprio a 30, al 31"* | | r.297 | il "30/31" `[NON CHIARO]` |
| P6 | EURUSD: media e taglie | **media a 14** (M5); sell di **1** e di **2** | *"c'e' la media a 14, quindi mi alzo un pochino di piu'. Devo essere conservativo"* · *"Cell di uno, cell di due"* | r.65-67 | `[TRASCRITTO dubbio]` (unita' delle taglie non detta) |
| P7 | **ORB DAX/oro**, orario | **09:15** `[INFERITO]` (*"sono le 9 e 10, manca ancora 5 minuti"*) | *"adesso sono le 9 e 10, manca ancora 5 minuti per prendere in considerazione l'ORB su German e sull'oro"* | r.227 | **ora IT inferita**; **durata del range NON dichiarata** (coerente con il *"nel 2015"* del 02/10 = 09:15) |
| P8 | **ORB oro** | **15:30** (americano) + **sessione europea** = *"due ORB sull'oro"* | *"Sull'oro sarebbe meglio farlo alle 15.30, pero' lo possiamo prendere in considerazione durante la sessione europea"* | r.227 | **fuso non dichiarato** (15:30 = apertura USA in ora italiana `[INFERITO]`); non converto |
| P9 | **timing pre-apertura DAX** | 7 minuti → 3 minuti → 20 secondi | *"sette minuti l'apertura del DAS"* (r.69) · *"Ragazzi, tre minuti"* (r.95) · *"59. Mancano 20 secondi"* (r.117) | r.69, r.95, r.117 | solo contesto; l'apertura e' a r.125 |
| P10 | **EMA200 H1 sul DAX** come ostacolo | *"proprio sulla media del 200... In H1"*; poi *"Respinto"* | r.101, r.131, r.195-207 | r.99-131 | **chiaro come cronaca**; nessuna statistica |
| P11 | **numeri tondi DAX** | *"rotondo di 300"* (prefisso non detto) · **25.200** (long) · *"sui 20"* · *"cento euro"* | *"Long su 25.200... Metto due contattini qua, due li metto qua, sopra la media, e in realta' i 10 e i 20 li metto sotto"* | r.209, r.251-253, r.267 | 25.200 chiaro; **"i 10 e i 20" `[NON CHIARO]`** (contratti? punti?) |
| P12 | **distanze dei pendenti DAX** | **400 punti** · **150 punti** | *"Cioe' sono 400 punti"* (r.175) · *"Ma metto qua. 150 punti"* (r.179) · *"me la metto sui 400, quindi l'operazione ha un range importante"* (r.209) | r.175-179, r.209 | chiaro il numero; **da dove si misurano NON detto** |
| P13 | **media 89** sul DAX | *"una media 89, mi sembra"* | r.253 | r.253 | `[TRASCRITTO dubbio]` (*"mi sembra"*); **non e' una nostra media** |
| P14 | **movimenti DAX** dichiarati | **50 punti** (apertura) · *"i 40 punticini del German"* · *"32"* | *"ti ha gia' fatto cinquanta. Cinquanta punti"* (r.151-153) · *"i tosti, i 40 punticini del German"* (r.253) | r.151-153, r.253-255 | **cronaca**, non parametri |
| P15 | **taglie DAX** | **civetta 2 contratti**; **4** *"sotto la media"*; **10/20** (la normale?); *"di tre"* (corretta); *"ordine di dieci sul numero tondo"*; *"venti contattini... la parte piu' importante"* | *"entro con due contattini, perche' con due? Cioe' diciamo che entro con 10, con 20, perche' e' l'ordine civetta questo"* | r.209-211, r.257, r.263 | **`[TRASCRITTO dubbio]` pesante**: non e' chiaro se 10/20 siano taglie abituali o ordini; **capitale e valore del punto NON detti** |
| P16 | **taglie oro** | *"un contratto long e due contratti short"* (r.231) · *"due sell da due e un buy da uno"* (r.237) · *"quattro contratti short e uno long"* (r.241) · buy *"di tre"* (r.113) | | r.113, r.231-241 | **le tre descrizioni NON sono coerenti fra loro** (1+2? 2x2+1? 4+1?) `[TRASCRITTO dubbio]` |
| P17 | **stop** | **in pari**; **sotto il VWAP** *"come sempre"*; **sotto il Supertrend**; *"uno stop di cinque"* (oro, buy stop); *"lo stop di tutto me lo metto qua sotto"* (stop unico) | *"L'operazione io la stoppo sotto, sotto il WAP eh, come sempre"* (r.295) | r.121, r.215, r.271-273, r.295 | chiaro il *dove*; **distanze in punti NON dette** (tranne r.121, senza unita') |
| P18 | **livelli oro** | supporto **19-29**, obiettivi **55**, **66**, terzo livello **75**; Fib **38,2** (M15) | *"tra il 19 e il 29 era l'area di supporto... A 66 e' il primo livello obiettivo di rialzo, siamo a 55... il terzo livello e' 75"* | r.9-13, r.25 | **il prefisso (migliaia) NON e' detto**: non si possono confrontare con prezzi nostri |
| P19 | **oro weekly** | *"cinque settimane di ribasso"* (r.17) · *"viene da 4 settimane in basso"* (r.19) | | r.17, r.19 | **si contraddice da solo** (4 o 5) |
| P20 | **esiti dichiarati** | **-1.000** (live notturna) · **+25 euro** (2 contratti DAX) · **+100 euro** (tondo) · *"100, 25"* | r.7, r.209, r.267, r.299 | | **nessun netto**, nessun R, nessun capitale; *"100, 25"* `[NON CHIARO]` (125? due cifre?) |

## 4.4 MECCANISMI (18)

| # | meccanismo | come descritto | dove |
|---|---|---|---|
| M1 | **Cascata strumento**: weekly e daily nella stessa direzione prima di tutto | *"andare a trovare gli strumenti che ti diano su Devi e su Wi-Fi la direzione"* | r.33, r.221-223, r.297 |
| M2 | **Multi-timeframe e confluenze**: si lavora dove piu' livelli coincidono | *"Io vado a lavorare i punti strategici dove ci sono piu' confluenze"* | r.225 |
| M3 | **Max/min della notte come livello** (anche "bruciati") | *"i massimi della notte li ho gia' bruciati"* | r.39, r.171 |
| M4 | **Volatilita' media come estensione/target** (Mataf) | P1-P4 | r.47-61 |
| M5 | **Volumi in incremento = breakout in corso** | *"I volumi in incremento rispetto alla media. Ha fatto un breakout? L'ha fatto, si'"* | r.79-85, r.95 |
| M6 | **Non entrare prima dell'apertura** | *"Entrare prima dell'apertura e' rischiosissimo"* | r.95-97 |
| M7 | **"Primo scarico" dell'apertura su livello importante, in direzione opposta** (Tommy, ripreso da Emiliano) | *"In prima istanza in apertura scarica sempre in direzione opposta"* | r.141-155, r.209 |
| M8 | **EMA200 H1 come ostacolo/respinta** | *"Respinto. Da la media al 200 in H1"* | r.99-131, r.195-207 |
| M9 | **Numero tondo come livello d'ingresso e di estensione** ("sotto il numero tondo" per chi vuole sicurezza) | *"li mette da il numero tondo in giu', perche' c'e' il super trenz"* | r.209, r.251-257, r.267 |
| M10 | **Ordine "civetta"** (piccolo, di sondaggio) + parte importante piu' lontana *"in un range"* | *"l'ordine irrisorio e' un ordine ridicolo... mi da' l'idea, la percezione di dove sta andando il mercato"* | r.209 |
| M11 | **Alleggerire in presenza di Supertrend** contrario/forte | *"Io alleggerisco perche' tre con il super trend capisco guadagnare di meno"* | r.211, r.253 |
| M12 | **Stop**: in pari (con il rischio di essere preso e *"ripartire"*), sotto liquidita'/VWAP/Supertrend | r.215-217, r.273, r.295 | r.215-217 |
| M13 | **Hedging con pendenti di pari quantita' sul max/min della candela precedente** | *"metto sul massimo, sul minimo della candela precedente un ordine contrario della stessa quantita'"* | r.239-243 |
| M14 | **ORB DAX e oro (europeo + americano)** | r.227 | r.227 |
| M15 | **Flip**: chiude lo short e va long sullo stesso indice | *"ho chiuso lo short su German e sono long, adesso sono long su German"* | r.255 |
| M16 | **Chiusura parziale "a gradini"** (una posizione alla volta) | *"io liquido una posizione su German... chiudo un'altra posizione"* | r.255, r.295, r.301 |
| M17 | **Pendenti notturni sull'oro** | *"con ordi presenti chiarati a un livello"* | r.7, r.29 |
| M18 | **Quando non operare**: segnale incerto/oro/lunedi' → *"alzare le mani"*, *"stare fermi"* | r.19, r.27-31, r.107, r.229 | |

## 4.5 I RISULTATI DICHIARATI

Vedi §1.4 e P20: **nessuno e' un risultato netto**; **nessuno e' un criterio**. Cronaca di una mattina (n = 1).

## 4.6 BANDIERE ROSSE (9)

| # | bandiera | citazione che la prova | dove | grado |
|---|---|---|---|---|
| B1 | **HEDGING come alternativa allo stop** (oro): posizioni opposte sullo stesso strumento *"per non chiudere la perdita"* | *"Io ho due possibilita'... Quella di prendere lo stop... oppure ejami. Oppure ejami vuol dire che metto sul massimo, sul minimo della candela precedente un ordine contrario della stessa quantita'. Io adesso non sono leggiato, io adesso ho quattro contratti short e uno long e questo in realta' che cosa prevede? Prevede che sto rischiando, non ho chiuso la perdita"* (r.239-241) · *"io queste vizie mi sono sostanzialmente ligiato... In questo momento la perdita non e' chiusa"* (r.235-237) | r.235-243 | **ROSSA PIENA**. `[TRASCRITTO dubbio]` su *"ejami"* (= hedging, per contesto e per la scheda 17/07): **il contenuto (ordine contrario di pari quantita') lo conferma**. Seconda volta che compare (07/17). Esclusa dalla nostra regola |
| B2 | **Stop non definito prima dell'ingresso** | *"Dove lo metto? Io vorrei sapere, sapete che lo stop messo qua non ha senso, eh? Lo stop finanziario, pero' non voglio perdere capacita'"* (r.217) · *"Io qua non voglio perdere da questa operazione, assolutamente"* (r.213) | r.213-219 | **ARANCIONE** (stessa classe del B1 del 30/09 e del 02/10): entra e **poi** cerca lo stop |
| B3 | **Scale-in con range ampio e stop comune** (parenti di griglia/mediazione) | *"mi ha preso l'ordine di dieci sul numero tondo e adesso mi sto riempiendo... la terza parte me la metto su 86"* (r.263) · *"ho dato un range importantissimo perche' mi preparo"* (r.209) · *"sono largo... sono entrato con tutto e lo stop di tutto me lo metto qua sotto"* (r.271) | r.209, r.263-271 | **ARANCIONE**: tre gambe a livelli diversi + stop unico + *"entrato con tutto"*; **non e' una martingala** (nessun raddoppio per perdita) |
| B4 | **Consiglia di non operare l'oro e lo opera** | *"l'oro tendenzialmente oggi sembra meglio non tradarlo"* (r.19) · *"oggi sarebbe bene alzare le mani e stare tranquilli"* (r.229) · poi *"ho un contratto long e due contratti short"* (r.231) | r.19, r.229-231 | **ARANCIONE**: la regola dichiarata e l'azione divergono nella stessa live |
| B5 | **Size sbagliata corretta in diretta** | *"Ah e' di tre? E' di tre cazzo? Perche' e' di tre? E' un po' eggegerato... Attenzione, attenzione"* (r.209) · *"mi sono fatto prendere un po' la mano"* (r.247, r.301) | r.209-211, r.247, r.301 | **ARANCIONE** |
| B6 | **Flip short→long sullo stesso indice in pochi minuti** | *"ho chiuso lo short su German e sono long"* (r.255) | r.251-255 | **AMBRA** |
| B7 | **Pendenti notturni sull'oro chiusi in perdita** | *"L'ho chiuso la live a meno mille"* (r.7) | r.7 | **AMBRA** `[TRASCRITTO dubbio]` (frase spezzata) |
| B8 | **Vittoria presentata come prova**, n = 1 | *"25 euro il caffe' pagato"* (r.209), *"cento euro"* (r.267), *"cosi' lui mi ha pagato"* (r.299) | | **AMBRA** |
| B9 | **Assoluti non verificati** | *"fa sempre quello scarico"* (r.141, Tommy) · *"scarica sempre in direzione opposta"* (r.155) · *"il profitto mi lo porto, sicuro"* (r.223) | | **AMBRA** |

**Trucchi anti-prop: 0.** Nessuna sezione "VIETATO PER NOI" da aprire.

## 4.7 COSA C'ERA A SCHERMO E NON NEL PARLATO (da chiedere a Claudio)

| # | cosa | perche' serve | dove |
|---|---|---|---|
| S1 | **Il grafico DAX H1/M5 con la EMA200** e il punto della respinta (r.101, r.131) | stabilire **quanto** respinge, quanti punti, e il livello vero | r.99-131 |
| S2 | **Il pannello ordini del DAX** (civetta, 4, 10/20, stop) | le taglie sono `[TRASCRITTO dubbio]` (P15) | r.209-271 |
| S3 | **La dashboard** (*"vedo tutto rosso"*, r.233) | direzione W+D per strumento, "forza valuta" | r.233-235 |
| S4 | **La pagina Mataf** (51 pip) e **il periodo** | senza non si ricostruisce la media | r.45-49 |
| S5 | **I livelli dell'oro** (prefisso) e il **grafico Fibonacci** | senza il prefisso nulla si confronta | r.9-13, r.25 |
| S6 | **Il pannello dell'oro**: quante gambe, quali verso, quali stop | P16 e B1 sono incoerenti fra loro | r.231-247 |

## 4.8 COSA NE COPIAMO

**Niente come regola, niente come parametro.** Quello che si prende sono **le specifiche S1-S5** (domande e misure) e **un promemoria di casa**: la B1 (hedging) e' la bandiera che
gia' conoscevamo, ora **vista dal vivo**. Tutti i numeri sono dichiarati e senza campione.

---

# PARTE 5 - SCARTI (cio' che non e' estraibile)

- **Introduzione e regia** (r.1-5, r.89-93, r.133-139, r.157-161, r.181-193): battute, chi c'e'/non c'e', saluti. Zero contenuto.
- **La digressione sul lago di Lecco** (r.73-83): scartata.
- **Il loop STT** (r.273-295, 33 volte *"Allora, sale di due."*): **nessun contenuto**.
- **Frasi spezzate attorno ai livelli** (r.9-15, r.175-179, r.193-207): numeri storpiati o senza prefisso, riportati solo dove ho potuto dire cosa manca.
- **Il pezzo su "Japan"** (r.259: *"Ha senso lavorare in Japan? Per me no. Emi, e' una centinaio e cinque, non e' poco solida?"*): `[NON CHIARO]` (JPY? Nikkei?); non interpreto.

---

# PARTE 6 - LE DOMANDE

## Per Claudio (screenshot e file, dichiarando il terminale)

- **Q1.** Lo screenshot M5 del DAX 05/10 08:50-09:40 ora italiana (S4) e **il giornale di `770411`/`770101`/`770105` del 05/10**: dire **su quale terminale** (BCM `50503392`, `C:\FTMO`, `541452707` ecc.) e **in quale ora** e' scritto ogni log (log MT5 = ora locale del PC; grafico = ora server).
- **Q2.** Quali **per-trade IS** esistono per `770101` (e `770105`)? (serve a S1; il referto 03/10 cita solo l'OOS: `ROUND_R270...`, `792520`).
- **Q3.** Il file **M1 del `D30EUR`** sul PC di backtest `DESKTOP-H4D7CAJ` copre 2024.09.26-oggi? e il **D1**? (serve a S1 e S2).
- **Q4.** La **dashboard** e il **pannello oro** di Emiliano (S3, S6), se li ha: servono a capire quante gambe aveva l'oro.

## Per Emiliano (Claudio gli sta scrivendo/parlando: queste nascono dalla live)

- **D1.** *"Il backtest sull'oro di cui parli (high frequency spreader) non produce risultati buoni"*: **con che metro lo dici?** (PF, drawdown, quanti anni, quale periodo, quali costi?). E: come giudichi un EA **prima** di metterlo in campo?
- **D2.** **Storico e regimi:** quanto storico ti serve, secondo te, per fidarti di un EA su indici? (la sua risposta e' **la risposta mancante a "~10 anni + regimi"**: questa live non la contiene.)
- **D3.** **Il filtro W1+D1:** *"quando ho la direzione, posso sbagliarmi ma il profitto me lo porto"*: **quanto spesso** non c'e' allineamento? Quanti giorni a trimestre salti per questo?
- **D4.** **I 51 pips:** da dove misuri l'estensione (apertura del giorno? minimo notturno?) e **quante** volte rimbalza davvero? (condiziona S5)
- **D5.** **L'EMA200 H1 sul DAX all'apertura:** quante volte su dieci respinge davvero? Hai una statistica o e' impressione? (noi misuriamo ~casuale su DAX H1)
- **D6.** **L'hedging dell'oro:** e' una tecnica che usi sempre o solo quando *"non ti accasi"*? Che ruolo ha rispetto allo stop? (la nostra regola di casa lo esclude: serve solo a capire.)
- **D7.** **La frazione d'ingresso:** la "civetta" e' sempre ~1/10 della taglia, o varia? (R124a copre 0,33-0,93.)

---

## Chiusura

- **Niente e' stato eseguito.** Nessun preset in campo, nessun EA, nessun conto (reale `10105439`), nessun parametro di rischio. Nessun numero della live e' diventato criterio.
- **Dichiarato come ponteggio:** questa e' una **scheda di lettura**, non un avanzamento verso una sedia. L'unica voce che puo' avvicinare qualcosa e' **S1/S2**, e **solo come domande a costo zero di tester** con attesa negativa/nulla scritta prima.
- **Il dato piu' solido** non e' di Emiliano: e' la **B1** (hedging), **gia' esclusa** dalla nostra regola, e la **convergenza non indipendente** su cascata/notte/ORB.
- **Fonti lette:** `data/trascrizioni/LIVE_EMILIANO_2026-10-05.txt` (**intera**) · `report/SCHEDA_LIVE_EMILIANO_2026-10-02.md` (**intera**) · `...-09-30.md` (§1-§5) ·
  `report/ANALISI_LIVE_EMILIANO_2026-09-18.md` (testata/sintesi) · `...-07-17.md` e `...-09-09.md` (righe sul hedging) · `report/APERTURE_DAX_MAPPA_2026-10-03.md` (intera) ·
  `report/APERTURE_DOW_MAPPA_2026-10-03.md` (§4-§7) · `report/APERTURE_NASDAQ_MAPPA_2026-10-03.md` (§0) · `report/EMA200_GEMELLI_STATO_2026-10-03.md` (§1-§2) · `report/CENSIMENTO_ORB_2026-09-29.md` (§0, §10) ·
  `report/DOSSIER_EXPERT_PER_EMILIANO_2026-10-05.md` · `report/MAIL_PER_EMILIANO_2026-10-05.md` · `backtest_pipeline/prove/R124a_U30USD_04_firstfraction.txt` · `HANDOFF.md` (r.44) ·
  `backtest_pipeline/REGISTRO_TEST.md` (righe citate). **Non letti:** i CSV per-trade delle sedie DAX, i dati M1 del `D30EUR`, il giornale delle sedie del 05/10.
