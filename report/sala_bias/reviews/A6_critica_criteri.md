# A6 - Critica indipendente ai criteri dello studio S1 (revisione PRIMA dei numeri) - 26/10/2026
**Ruolo:** revisore critico indipendente, progetto SALA-BIAS-001. **Oggetto:** `criteri_studio_S1.md` (congelato da C0), letto insieme a `brief.md`, `GUIDA_BIAS_testo.txt` e `report/INDICATORE_MULTI_TF_BIAS_ANALISI_2026-10-26.md` (parametri degli screenshot).
**Cosa ho guardato dei dati:** SOLO la struttura del CSV D1 (intestazione, giorni della settimana, date duplicate, tick volume medio per anno, ampiezza media High-Low domenica/feriali). Nessun rendimento, nessun segnale, nessuna statistica sull'esito: la revisione resta "prima dei numeri". Non ho letto `agents/`.
**Etichette:** VERIFICATO = controllato da me sul CSV o sui testi. STIMA = ragionamento con ipotesi dichiarate. NON VERIFICATO = memoria o ipotesi.

## Sintesi in 8 righe
1. Il disegno di base e sano: ingresso a `open[t+1]`, segnali a barre chiuse, soglie scelte prima, criterio t >= 2 come ostacolo vero, nessun tuning. Non trovo un difetto di "falsi positivi da cinque criteri insieme": l'AND li riduce (voce 8).
2. **Bloccante B1:** il CSV D1 contiene **1.084 barre di domenica su 6.851 (15,8%)**, barre minuscole (ampiezza media High-Low dal 2010: 5,1 USD contro 28,4 dei feriali; tick volume circa il 3% di un feriale). I criteri non dicono cosa farne ("settimana = lunedi-venerdi per data", "h giorni di borsa"). Cambia ogni numero e rende possibile un look-ahead sulla W1.
3. **Bloccante B2:** nessun test di causalita (look-ahead) nei criteri. Swing a 3 barre per lato e BOS/CHoCH sono il punto classico dove il futuro entra. A7 "solo dalla guida" non lo prende: puo ripetere lo stesso errore.
4. **Alta:** riscaldamento EMA 200 W1 incoerente nel testo (2005-01-03 -> 2008-07-01 sono 182 settimane, meno di 200), criteri 3 e 4 non operativi (quale h, quale definizione, campione sovrapposto o no, "8 osservazioni per stato" impossibili a h=20 non sovrapposto), potenza statistica molto bassa con verdetto solo binario, spec della replica non congelata, confronto con deriva che non protegge da cio che si crede.
5. Il vero rischio dello studio non e il falso positivo ma il **falso negativo travestito da "nessun vantaggio dimostrato"** (stima: per passare t >= 2 serve uno spread di circa 1,7% per 20 giorni).
6. La replica e un proxy non validato contro l'originale: l'accordo A7 verifica la coerenza fra due implementazioni della stessa guida, non la fedelta al prodotto.
7. Le soglie 15 e 50 non sono tarate sui dati (bene), ma 50 contraddice la scala "FORZA" della guida: non chiamarla "forte".
8. In fondo: 16 modifiche numerate da adottare prima di eseguire.

---

## Parte 1 - Obiezioni per voce

Formato: **punto contestato / ragione / evidenza / modifica concreta / gravita**.

### O1 - Barre di domenica, definizione di settimana e di "giorno di borsa" (BLOCCANTE)
- **Punto:** "Barre W1 costruite dalle D1 (settimana = lunedi-venerdi per data)", "h = 5 e h = 20 giorni di borsa", "usa solo barre chiuse fino a t".
- **Ragione:** il file ha barre di domenica in ogni anno, fino al 2026. Conteggio per giorno della settimana su 6.851 righe (VERIFICATO): lun 1.152, mar 1.162, mer 1.161, gio 1.157, ven 1.135, **dom 1.084**, nessun sabato, nessuna data duplicata. Domeniche per anno: 45-52 fino al 2023, 41 nel 2024, 31 nel 2025, 30 nel 2026 (parziale). Sono barre di circa un'ora: tick volume medio domenicale 2010 = 1.348 contro 46.134 dei feriali; 2025 = 6.425 contro 248.399; ampiezza media High-Low dal 2010 = 5,10 contro 28,35 (VERIFICATO).
- **Conseguenze concrete se non regolato:**
  1. "h giorni" contati in barre diventa circa 0,84 h giorni reali (h=5 sono ~4,2 giorni di borsa, h=20 sono ~16,8).
  2. Il segnale del venerdi t ha come "apertura t+1" la barra della domenica (ok come prezzo, ma un'implementazione che scarta le domeniche e una che le tiene danno rendimenti diversi).
  3. "lunedi-venerdi per data" lascia la domenica orfana. Se un implementatore usa `isocalendar()`/raggruppamento ISO, la domenica va nella settimana PRECEDENTE: la barra W1 "chiusa" il venerdi conterrebbe un'ora di domenica successiva alla chiusura. E una fuga di futuro piccola ma reale, e proprio del tipo che il test di causalita deve catturare.
  4. RSI 14, ATR 14, EMA 20/50/200, swing a 3 barre, "price action 8 candele" e lookback 150 barre sono tutti calcolati su una serie in cui il 16% delle barre e un'ora di mercato: i lookback si accorciano in tempo reale, gli swing a 3 barre per lato si rompono con mini-barre, il price action "ultime 8 candele" ne include 1-2 che non dicono niente.
  5. A4 e A7 possono scegliere diversamente: l'accordo >= 85% si abbasserebbe per una ragione banale.
  6. Nota: l'indicatore originale, girando su BCM, probabilmente vede quelle barre di domenica come barre D1. La scelta "pulita" e quindi una differenza dichiarata dalla replica, non un dettaglio.
- **Modifica:** regola unica scritta nei criteri: le barre di domenica vengono **fuse nel lunedi successivo** (open = open della domenica, high = max, low = min, close = close del lunedi, tick volume = somma). Da li in poi esistono solo giorni lun-ven. W1 = gruppo lun-ven delle barre fuse (open del lunedi fuso, close del venerdi). h conta barre fuse. **Corsa di sensibilita** con barre grezze (domeniche tenute come barre D1, W1 aperta alla domenica) riportata come solo-report. Dichiarare nel verdetto che l'originale vede probabilmente le domeniche.
- **Gravita: Bloccante** (cambia ogni numero, e decisione di una riga).

### O2 - Allineamento temporale e look-ahead: manca un test (BLOCCANTE)
- **Punto:** "Il bias a fine giorno t usa solo barre chiuse fino a t (D1) e fino all'ultima settimana chiusa (W1)". E l'ingresso "all'apertura del giorno t+1".
- **Cosa ho controllato:** la logica di base e corretta. Segnale su close[t], ingresso su open[t+1], uscita su close[t+h]. Il rendimento = close[t+h]/open[t+1] - 1 non usa nessun dato non disponibile se l'implementazione e disciplinata. La guida dice "niente repaint, solo barre chiuse". Il D1 a fine giorno e eseguibile (decisione a mezzanotte server, ordine all'apertura).
- **Dove puo comunque entrare il futuro (ragionamento, non evidenza di un bug esistente):**
  - Swing "3 barre per lato" (screenshot): un massimo/minimo e confermato solo 3 barre DOPO. Se la funzione di struttura marca lo swing alla barra i e lo usa a t >= i, e look-ahead di 3 barre. Su W1 sono 3 settimane. BOS/CHoCH ne ereditano l'errore. Questo e il bug piu comune nelle repliche di "market structure".
  - Normalizzazioni a finestra (ATR, "variazione dallo score di picco recente", medie su tutta la serie) calcolate sull'intera serie invece che a scorrimento.
  - "Ultima settimana chiusa" non definita: a venerdi sera la settimana e chiusa nei fatti; ma "closed bars" nel terminale la rende disponibile solo all'apertura della barra W1 successiva.
- **Perche A7 non basta:** A7 scrive "solo dalla guida" e confronta i segni. Due implementazioni derivate dalla stessa guida possono condividere lo stesso errore di tempo (stessa interpretazione di "swing"). L'accordo tra loro non e un test di causalita.
- **Modifica:** test obbligatorio nell'autotest, con esito che invalida lo studio se fallisce:
  1. **Test del prefisso:** per almeno 300 date t (tutte le ultime-barre di settimana, le prime di settimana, 20 date attorno a ogni 1 gennaio e a ogni lunedi dopo un buco di 3+ giorni, il resto casuale con seme fisso) ricalcolare punteggio per TF e Overall usando SOLO le barre fino a t (W1: fino all'ultima W1 chiusa). Deve coincidere con il valore della corsa sulla serie intera entro 1e-9 per ogni componente.
  2. **Test della serie sporcata:** sostituire tutte le barre dopo t con numeri casuali: i punteggi a t non cambiano.
  3. **Test di allineamento del rendimento:** un esempio fatto a mano nell'autotest (5 barre note) che verifica `close[t+h]/open[t+1]-1` e che nessuna formula usi `close[t]` come prezzo d'ingresso.
  4. **Regola W1:** la W1 della settimana k entra nel calcolo dal primo giorno **dopo** il suo ultimo giorno (dal lunedi fuso successivo). A venerdi sera t si usano le settimane <= k-1. E conservativa, equivale a cio che mostra il terminale a barre chiuse, e rimuove l'ambiguita del venerdi.
- **Gravita: Bloccante** (costa poco e il look-ahead e la causa singola piu probabile di un segnale che sembra buono e non lo e).

### O3 - Riscaldamento EMA 200 su W1 (ALTA)
- **Punto:** "Periodo di studio 2005-01-03 / 2026-10-16 (le prime barre servono da riscaldamento per EMA 200 su W1: circa 4 anni; i numeri si leggono dal 2008-07-01, quando EMA 200 W1 esiste davvero)".
- **Ragione, incoerenza interna (VERIFICATO con date):** da 2005-01-03 a 2008-07-01 passano 182 settimane, meno di 200. La frase "esiste davvero" e falsa se il riscaldamento inizia al 2005-01-03. Il file inizia al 2004-06-11: partendo dalla prima settimana (2004-06-14) la 200a barra W1 e a inizio aprile 2008 e al 2008-07-01 si hanno circa 212 barre. Quindi il riscaldamento va dichiarato dal 2004-06-14 e non dal 2005. Perche buttare 6 mesi di storia?
- **Convergenza (calcolo, STIMA robusta):** il peso del seme in un EMA di periodo 200 dopo n barre e circa (1 - 2/201)^n = e^(-0,01 n). n=212: **12%**. n=300 (circa marzo 2010): 5%. n=400: 1,8%. A luglio 2008 il prezzo dell'oro e piu del doppio del primo valore (384 nel 2004) e l'EMA 200 W1 ha ancora il 12% di peso sul seme: sottostima il livello medio, sposta il segno "prezzo sopra/sotto media" e "ordine 20>50>200" verso BULLISH proprio nel 2008-2010. Effetto probabilmente moderato (e un livello di riferimento lento), ma tocca la meta cronologica 1 del criterio 3 e il periodo del crollo del 2008, quello dove i BEARISH servono.
- **Altra metà del problema:** la guida dice che con storico insufficiente "l'EMA 200 o un intero timeframe possono comparire come N/A". Il terminale originale puo quindi avere regole diverse (N/A, componente omessa e pesi riportati a 100, o EMA su una finestra di barre finita). Non e noto. Le regole prima di 200 barre vanno scritte.
- **Modifica:** (1) scrivere "riscaldamento dalla prima barra del file, 2004-06-14"; (2) specificare il seme dell'EMA (primo valore o SMA delle prime 200 barre: una sola scelta, uguale per A4 e A7); (3) specificare cosa fa la componente Trend prima di 200 barre (N/A con pesi dei componenti riportati a 100 o EMA 200 esclusa); (4) lettura primaria dal 2008-07-01 come scritto, **piu una corsa di robustezza dal 2010-04-01** (seme < 5%); (5) il verdetto positivo richiede che i cinque criteri valgano anche nella corsa dal 2010-04, altrimenti dicitura "sensibile al riscaldamento".
- **Gravita: Alta** (incoerenza nel testo + tocca direttamente criterio 3).

### O4 - Fine del campione e finestre incomplete (MEDIA)
- **Punto:** "2005-01-03 / 2026-10-16".
- **Ragione (VERIFICATO):** il CSV finisce al 2026-10-21 (file scritto il 21/10 alle 20:01: l'ultima barra potrebbe essere ancora incompleta). Un t = 2026-10-16 con h = 20 richiede un'uscita attorno al 2026-11-13, che non esiste. "Periodo di studio fino al 16/10" e ambiguo: ultimo t o ultima uscita? Le implementazioni possono troncare in silenzio (finestra piu corta, NaN trattati come 0, ultima barra incompleta come chiusura).
- **Modifica:** regola scritta: un'osservazione (t, h) entra solo se esiste la barra t+h **completa**; l'ultima barra del file (2026-10-21) e esclusa dal calcolo delle uscite (ammessa solo se verificato che e chiusa); nessun NaN e nessuna finestra accorciata. Riportare l'ultimo t incluso per h=5 e h=20 (atteso: circa la fine di settembre per h=20).
- **Gravita: Media.**

### O5 - Sovrapposizione, significativita e potenza (ALTA)
**5a - La t-statistica non e specificata.**
- Non e scritto: Welch o pooled, uguaglianza delle varianze, definizione di SE, quali sono "i 5 offset" quando h=20 (0..4 darebbe cinque campioni quasi identici shiftati di 1 giorno; per decorrelarli servono 0,4,8,12,16), se la "mediana dei t" si applica anche allo spread riportato.
- **Modifica:** t di Welch a due campioni (BULLISH vs BEARISH) con osservazioni a distanza h; offset = {0, h/5, 2h/5, 3h/5, 4h/5} arrotondati (h=20: 0,4,8,12,16; h=5: 0,1,2,3,4); si riporta la mediana dei 5 t e anche il min e il max.

**5b - Persistenza degli stati e pochi episodi indipendenti.**
- Il non-sovrapposto elimina la sovrapposizione dei rendimenti, ma non il fatto che gli stati siano lenti (la W1 cambia a fine settimana, la D1 con EMA e struttura persiste settimane). Le osservazioni BEARISH vengono da pochi episodi contigui (stima: poche decine di osservazioni da una decina di episodi al massimo; NON VERIFICATO, perche non ho guardato i segnali). All'interno di un episodio i rendimenti condividono regime di volatilita e di deriva: il t di Welch sovrastima i gradi di liberta effettivi. I pochi crolli (2008 T4, aprile 2013, marzo 2020: da memoria, NON VERIFICATO) possono dominare.
- **Modifica:** accanto al t, un **p-value per permutazione con spostamento circolare** (circular shift): si fa scorrere la serie degli stati contro quella dei rendimenti di un lag casuale >= 60 giorni (almeno 2.000 permutazioni, seme fisso, Python puro), si ricalcola lo spread a h=20 sul campione completo (sovrapposto, perche la permutazione conserva la dipendenza). Conserva frequenza, persistenza e deriva degli stati. **Criterio 2 passa solo se t (non sovrapposto) >= 2,0 E p unilaterale <= 0,05.** In piu: riportare numero di episodi (run contigui) per stato.

**5c - Potenza: il test e quasi certo di non passare anche se un effetto utile esiste (STIMA).**
- Ipotesi (NON VERIFICATE, da controllare dopo): volatilita annua dell'oro ~16,5% -> sigma a 20 giorni ~4,7%; campione dal 2008-07: circa 230 osservazioni non sovrapposte a h=20; quota BEARISH 15-25% -> circa 35-55 osservazioni; BULLISH circa 130-150.
- SE dello spread ~ 4,7 x sqrt(1/140 + 1/40) ~ **0,85% per 20 giorni**. Per t >= 2 serve uno spread di circa **1,7%** a 20 giorni; per avere potenza 80% serve **circa 2,4%**. Per confronto, la deriva media dell'oro 2008-2026 (circa 900 -> 4.100 USD in 18 anni, memoria, NON VERIFICATO) e circa 0,7% per 20 giorni. Il test richiede uno spread pari a 2-3 volte la deriva dell'intero periodo.
- Se lo spread vero fosse 0,5-1,0% (un filtro di tendenza decente), la probabilita che t >= 2 sia attorno al 5-16%. Il resto dei criteri la abbassa ancora. La previsione P2 di C0 (20% per tutti e cinque) e probabilmente alta; la mia stima grezza e **sotto il 10%** anche con un effetto reale moderato.
- **Conseguenza di disegno:** "nessun vantaggio dimostrato" sara l'esito quasi qualunque cosa sia vero, e il brief ne fa discendere "no motivato" e nessun EA. Un esito debole per potenza non e un esito negativo.
- **Modifica:** (1) terza etichetta di verdetto, **"NON CONCLUSIVO (potenza)"**: se lo spread (a, 20) non e significativo ma l'intervallo di confidenza al 90% (da bootstrap a blocchi o permutazione) include +1,0%/20 giorni, il verdetto e "non dimostrato, non escluso", e l'EA resta non proposto ma NON si scrive "il bias non funziona"; (2) riportare l'MDE (spread minimo rilevabile al 80%) calcolato dai dati effettivi; (3) regola dei minimi: spread di uno stato valutabile solo con >= 30 osservazioni non sovrapposte e >= 8 episodi, altrimenti "non valutabile" (non "fallito").
- **Gravita: Alta.**

### O6 - Deriva incondizionata dell'oro: protegge davvero da cio che si pensa? (ALTA)
- **Punto:** "per questo il confronto e con la deriva incondizionata e non con zero" e criterio 5.
- **Ragionamento (esatto):** lo **spread = media(BULL) - media(BEAR) non contiene la deriva**: una costante aggiunta a tutti i rendimenti si cancella nella differenza. La forte deriva positiva NON puo produrre uno spread > 0 per se. Quindi le frasi "gli stati BULLISH saranno piu frequenti, per questo..." giustificano il criterio 5 per una ragione sbagliata: la maggiore frequenza di BULLISH incide sulla **precisione** (pochi BEARISH, vedi O5c), non sul **bias** dello spread. Cio che conta davvero con una deriva forte:
  1. **Momentum di serie temporale genuino.** Un oro che sale a lungo, con un indicatore in ritardo, produce BULLISH dopo rialzi: se i rendimenti hanno persistenza (documentata per le materie prime, NON VERIFICATA qui), lo spread e positivo anche per un filtro banale. La domanda (b) "il bias ha valore?" e allora "ha valore **oltre un filtro banale**?". I criteri non lo chiedono.
  2. **Un EA short non vuole "sotto la deriva", vuole sotto zero.** Criterio 5 richiede eccesso BEARISH < 0 rispetto alla media di tutti i giorni; con una deriva di +0,7% anche un BEARISH a +0,3% passa il criterio e perde soldi se usato per vendere. Va riportata la media assoluta del BEARISH.
  3. **Il criterio 5 non ha soglia di significativita.** Passa con +0,01%.
  4. Il benchmark "media di tutti i giorni" va calcolato sullo **stesso insieme di t** (stessa finestra, stesso h, stesse esclusioni): scriverlo.
- **Modifica:** (1) riscrivere la motivazione nei criteri (la deriva incide sulla potenza e sul confronto assoluto, non sul bias dello spread); (2) **benchmark banale** passato per la stessa macchina e riportato: segno di (close D1 - EMA 200 D1) e segno del rendimento a 250 giorni (entrambi calcolati con dati <= t); e il verdetto dice se il bias replicato fa meglio dello spread del benchmark banale (solo report: se non lo batte, la frase obbligatoria e "nessun valore aggiunto sul filtro banale"); (3) **permutazione circolare** come in 5b (il suo nullo conserva frequenza e persistenza); (4) riportare media assoluta BULL e BEAR con intervallo; (5) criterio 5 con la stessa lettura unilaterale: eccesso BULL > 0 con t non sovrapposto >= 1,0 e eccesso BEAR < 0 (segno) piu riporto della media assoluta.
- **Gravita: Alta.**

### O7 - Criteri 1-4: ambiguita operative (ALTA)
- **Criterio 1** richiede quattro spread (definizioni a/b x h 5/20). La definizione (b) (|score| >= 50) puo avere pochissime osservazioni BEARISH (due TF contemporaneamente fortemente ribassisti sono rari in un oro in rialzo: STIMA, non verificata). Con poche decine di osservazioni da 3-6 episodi, il segno dello spread (b) e una moneta: la regola "tutti i criteri devono valere" trasforma una variabile quasi casuale in una condizione di fallimento.
- **Criterio 3 (due meta)** non dice quale h, quale definizione, campione sovrapposto o no. La prima meta (2008-07/2016-12) contiene il riscaldamento (O3), la seconda (2017-2026) il rally 2024-2026 (memoria: oro da circa 2.000 a oltre 4.000 USD, NON VERIFICATO) che puo dominare da solo la meta.
- **Criterio 4 (60% degli anni con >= 8 osservazioni per stato)**: a h=20 non sovrapposto ci sono circa 12,6 osservazioni all'anno in totale: **8 per OGNI stato e impossibile**. Se invece le 8 sono giorni sovrapposti, 8 giorni consecutivi (con h=20) sono un'unica osservazione indipendente: soglia vuota. Non e scritto come si arrotonda il 60% (su N anni), cosa succede se gli anni valutabili sono pochi, e come si tratta un anno parziale (2008 mezzo, 2026 fino a settembre). Inoltre sotto l'ipotesi nulla con anni indipendenti P(>= 11 su 18 con p=0,5) = circa 24%: un criterio di segno annuale da solo ha scarso potere discriminante, bene come controllo di eterogeneita, non come prova.
- **Modifica:** testo esplicito: criteri 3-5 sull'orizzonte **h=20, definizione (a)** (eventuali altri solo riportati), con spread puntuale calcolato su **tutti i giorni (sovrapposti)** (il punto e senza bias, la significativita e solo nel criterio 2); anno "valutabile" se ha >= 20 giorni in ciascuno dei due stati; 60% = ceil(0,6 x anni valutabili); se gli anni valutabili sono < 10, criterio 4 "non valutabile" (porta al verdetto NON CONCLUSIVO, non a "fallito"); anni parziali inclusi con la stessa regola. Criterio 1: nella definizione (b), applicare la regola dei minimi di 5c.
- **Gravita: Alta.**

### O8 - Confronti multipli e falsi positivi con i cinque criteri insieme (controllato, nessun difetto sul punto; BASSA)
- **Cosa ho controllato:** i criteri sono in AND, direzione prestabilita, nessuna scelta di parametro post hoc, soglie fisse. Il criterio 2 (t >= 2 unilaterale, p circa 0,023) e condizione necessaria: la probabilita congiunta di tutti e cinque sotto "nessun potere predittivo" e al piu ~2,3% (e probabilmente 1-1,5%, perche gli altri criteri hanno probabilita < 1 condizionale). I criteri 1, 3, 4, 5 sono correlati tra loro e con il 2: non sono cinque barriere indipendenti, ma l'AND non gonfia il falso positivo.
- **Cosa resta (non nei cinque criteri):** i gradi di liberta nascosti sono altrove: (i) la scelta dell'implementazione della replica (swing, pendenza, "ordine delle medie"); (ii) "si studiano entrambe" se A7 non concorda (due repliche = due esiti da scegliere); (iii) la mediana sugli offset (conservativa, ok); (iv) i regimi (solo riportati, ok). Coperti dalle modifiche O2, O11.
- **Modifica minore:** scrivere nei criteri che la probabilita nominale di falso positivo e circa 2% e che l'AND non la riduce di molto (evita che qualcuno legga "5 criteri" come 5 prove indipendenti).
- **Gravita: Bassa.**

### O9 - Scelta delle soglie 15 e 50 (MEDIA)
- **Soglia 15 (dalla guida):** scritta prima, nessun tuning: ok. Applicata allo score composito di due TF (media pesata 54,5/45,5) anziche a un TF singolo: la scala e la stessa (-100..+100), ma quando W1 e D1 sono discordi il composito si avvicina a zero e il NEUTRAL aumenta. Non e un difetto, e da dichiarare.
- **Soglia 50 (scelta qui):** contraddice la tabella FORZA della guida: 30-69 = "NEUTRO" (direzione presente ma non convincente), 70-89 = "FORTE". Quindi "forte >= 50" non e "forte" nel senso dell'indicatore. Dire "forte" a 50 e fuorviante per chi legge il verdetto.
- **Rischio nascosto:** nessuna regola scritta sul caso in cui (b) abbia troppo poche osservazioni. Senza regola, chi vede i numeri e tentato di spostare 50 a 40 o 70. Lo vieta solo "modifica = nuova decisione Dxxx", ma non protegge da un cambio "innocente".
- **Modifica:** (1) rinominare (b) "segnale deciso (|score| >= 50)" e non "forte"; (2) scrivere ora che le soglie NON si cambiano dopo aver visto i numeri; (3) soglia 70 (la FORTE della guida) come terza lettura **solo-report**, se n >= regola dei minimi; (4) riportare le frequenze degli stati (giorni e episodi) come primo output, prima di ogni spread.
- **Gravita: Media.**

### O10 - Definizione dei regimi (MEDIA)
- **Punto:** anno LONG/SHORT/LATERALE dal rendimento annuo, pool 2009-2025, LONG >= +10%, SHORT <= -5%.
- **Ragione:** il regime e definito **dalla stessa variabile che si misura** (il rendimento dell'anno). Condizionare sul risultato introduce un bias meccanico: in un anno LONG i rendimenti a 5-20 giorni sono mediamente positivi per costruzione, anche dopo i giorni BEARISH (che quindi appaiono "sbagliati"); in un anno SHORT accade il contrario. Lo spread per regime non dice "il bias funziona nei trend e non nei laterali": dice una cosa diversa e in parte tautologica. Non e utilizzabile come filtro, perche il regime non e noto a t.
- **Altri difetti:** (i) SHORT avra pochi anni (probabilmente 2-3, NON VERIFICATO) e circa 12 osservazioni non sovrapposte per anno: campioni da 25-40 osservazioni, quindi aneddoti; (ii) il pool 2009-2025 lascia fuori 2008 (da luglio) e 2026 (fino a settembre), che entrano nello studio principale ma restano senza regime: scrivere se sono esclusi dalla tabella per regime; (iii) soglie "come per gli EA" non sono calibrate per l'oro (deriva alta: LONG sara la maggioranza degli anni).
- **Modifica:** (1) etichettare la tabella "regimi EX-POST, non utilizzabili come filtro, non indicano causalita"; (2) riportare numero di anni, osservazioni e episodi per cella; (3) aggiungere un secondo taglio **EX-ANTE**, noto a t, solo-report: terzili del percentile di ATR 14 D1 su finestra mobile (calcolati con dati <= t) e segno del rendimento a 250 giorni; (4) dichiarare gli anni esclusi (2008, 2026).
- **Gravita: Media.**

### O11 - Validita della replica come proxy dell'indicatore (ALTA per la parte "congelamento", MEDIA per il resto)
**11a - La specifica della replica non e congelata.**
- I criteri congelano lo studio, non la replica. Ogni scelta di implementazione (swing, "ordine delle medie", soglie dei voti, come "corpi pieni" diventa un numero) e un parametro libero. Dopo aver visto che il verdetto e "nessun vantaggio", chi implementa e tentato di "correggere" la replica; dopo aver visto "vantaggio", di non toccarla. Asimmetria da evitare.
- **Modifica:** nell'addendum ai criteri, registrare **SHA256** di: (i) il documento di specifica della replica, (ii) il codice di riferimento A4, (iii) il CSV D1, (iv) lo script di studio. Qualunque cambio dopo il primo numero invalida lo studio (nuova decisione Dxxx e nuova esecuzione, mai sostituzione del verdetto).

**11b - A7 verifica la coerenza, non la fedelta.**
- A4 e A7 sono derivati dalla stessa guida, probabilmente dalla stessa famiglia di modelli, con gli stessi default (fractal, RSI 14, MACD 12/26/9): gli errori sono correlati, l'accordo li sovrastima. Nessuna delle due viene confrontata con valori reali della dashboard (la guida mostra "valori di fantasia"). Gli screenshot danno solo i **parametri di ingresso** (EMA 20/50/200, RSI 14, MACD 12/26/9, ATR 14, pendenza 5 barre, lookback struttura 150, swing 3 per lato, price action 8, soglia 15): VERIFICATO nel file di analisi. "A7 solo dalla guida" non li vede e li indovinera: un disaccordo banale.
- **L'accordo sul segno >= 85% non e informativo** con una prevalenza BULLISH alta (se entrambe dicono BULLISH nel 60% dei giorni, l'accordo atteso per caso e gia > 50%; un filtro "prezzo > EMA 50 D1" probabilmente concorda con entrambe a > 75% senza condividere nulla: STIMA, non verificata).
- **Modifica:** (1) dare a A4 e A7 lo stesso elenco di parametri degli screenshot; (2) misura di accordo su tre stati a soglia 15 con **kappa di Cohen >= 0,70** oltre a >= 85% di accordo, piu correlazione dei punteggi grezzi >= 0,90; (3) riportare l'accordo di ciascuna con il filtro banale di O6 (se l'accordo A4-A7 non supera quello con il filtro banale, "replica indipendente" non e dimostrata); (4) il criterio decisivo: **le due repliche devono dare lo stesso esito sui cinque criteri**; un 90% di accordo giornaliero con esiti diversi e disaccordo.

**11c - "si studiano entrambe" senza regola di sintesi.**
- Doppia analisi senza regola e una biforcazione. **Modifica:** verdetto positivo solo se entrambe le repliche soddisfano tutti i criteri; in caso contrario "la replica dipende dalle scelte di implementazione" e non si dichiara nessun vantaggio.

**11d - Validazione contro l'originale: possibile e a costo quasi zero (decisione di Claudio).**
- Un piccolo script sul PC di Claudio (non un EA, nessun ordine) che ogni ora scrive su CSV il testo degli oggetti della dashboard (W1, D1, Overall, con data e ora server) darebbe, dopo poche settimane, la serie reale dell'originale su W1 e D1 (cambiano lentamente) con cui misurare l'accordo di segno della replica. Altrimenti restano le 2-3 schermate datate gia richieste a Claudio. Fuori dall'esecuzione di S1; da proporre.
- **Gravita complessiva: Alta (11a, 11c), Media (11b, 11d).**

### O12 - Componente volume e qualita del dato (MEDIA/BASSA)
- Il tick volume BCM sull'oro **cresce di due ordini di grandezza** (medio feriale: 1.287 nel 2005, 9.424 nel 2008, 46.134 nel 2010, 117.530 nel 2022, 403.286 nel 2026: VERIFICATO). Una componente "volume in crescita nella direzione" che usi livelli assoluti o confronti con una media troppo lunga e non stazionaria: incorpora un trend di dati che non e il mercato. Con barre fuse (O1) la componente deve usare rapporto volume/media mobile breve. Nel periodo 2005-2008 i tick sono pochi: dato sottile.
- Peso 10%, "solo conferma": effetto basso sull'esito, ma non azzerabile.
- Verifiche di qualita gia fatte (VERIFICATO): nessuna data duplicata (6.851 uniche); scarti fra date consecutive: 1 giorno 5.665, 2 giorni 1.074, 3 giorni 91, 4 giorni 19, 5 giorni 1: coerenti con feriali, festivi e domeniche mancanti. Non ho verificato la coerenza OHLC (H >= max(O,C), L <= min(O,C)).
- **Modifica:** nell'autotest, controllo OHLC e assenza di barre a range zero; la componente volume definita con rapporto a media mobile corta (stessa scelta per A4/A7); dichiarare che il dato 2005-2008 e sottile.
- **Gravita: Media/Bassa.**

### O13 - Orizzonti (5 e 20 giorni) rispetto a cio che l'indicatore misura (MEDIA/BASSA)
- La struttura su W1 ha lookback 150 barre (circa 3 anni) e l'EMA 200 W1 e un orizzonte di anni; l'indicatore descrive un contesto che potrebbe legarsi a movimenti di mesi, non di 1-4 settimane. Un esito negativo a 5-20 giorni non dice nulla sul 60 giorni (circa 3 mesi). Aggiungere h=60 in confronto moltiplica i test; come **solo-report** non intacca il verdetto.
- **Modifica:** h=60 solo-report (stessa macchina, nessun criterio), con la frase "il verdetto riguarda 5 e 20 giorni".
- **Gravita: Media/Bassa.**

### O14 - Spread significativamente negativo (MEDIA)
- Il disegno prevede solo la direzione "trend-following". Se lo spread a 20 giorni fosse significativamente **negativo** (t <= -2), il disegno dice solo "nessun vantaggio": ma sarebbe un'informazione (comportamento contrarian) che la tentazione e di invertire dopo, sullo stesso dataset (data-snooping).
- **Modifica:** regola scritta: t <= -2 (e permutazione p <= 0,05 dalla parte opposta) si riporta come "segnale inverso", **non adottabile come regola senza nuovo studio su dati nuovi**.
- **Gravita: Media.**

### O15 - Costi (controllato, nessun difetto; BASSA)
- Uno spread di 16 punti nella colonna SPREAD degli ultimi giorni e dell'ordine dello 0,01% sul prezzo (4.100 USD): trascurabile contro un effetto cercato di 0,5-2% a 20 giorni. Il testo "nessun costo, lo scrivo" e corretto per **questo** studio. Per un EA (non qui) restano swap sui CFD, slippage, spread allargati nelle notizie.
- **Gravita: Bassa.**

### O16 - Fuso orario del server (controllato; nessun impatto)
- Le barre D1 sono delimitate alla mezzanotte server; l'ora (CLAUDE.md: 1 ora indietro rispetto all'Italia; brief: "UTC+1 fisso") conta per l'intraday (InpSessionHour) e non per il D1 giornaliero. L'unica interazione e il contenuto della barra di domenica e della barra del venerdi (chiusura del mercato spostata dall'ora legale USA): coperto da O1. Nessuna modifica.
- **Gravita: nessun difetto.**

### O17 - Dipendenza da un solo percorso e riserva fuori campione (BASSA)
- Un solo strumento, un solo percorso storico, dominato da un super-ciclo rialzista. Dichiarato in "Cosa NON dice". Non c'e una riserva vergine: il periodo 2017-2026 e usato in tutti i criteri.
- **Modifica:** (1) report-only: spread senza gli anni 2025-2026 (leave-out) e senza il 2008; (2) frase obbligatoria: qualunque regola di un eventuale EA derivata da S1 non puo essere tarata su 2008-2026 oro D1; la validazione richiede dati nuovi (forward da 2026-10-22, indici, export M1). Coerente con "fuori perimetro" del brief.
- **Gravita: Bassa.**

---

## Parte 2 - Scenario di fallimento: "tra sei mesi lo studio risulta fuorviante: cause piu probabili, gia coperte?"

| # | Causa probabile | Come sembrerebbe | Coperta oggi? | Dove si copre |
|---|---|---|---|---|
| F1 | Look-ahead nello swing/BOS o nella W1 (ISO, domenica, venerdi) | Spread positivo e stabile in ogni sotto-periodo, t alto | **No** (A7 non basta) | O1, O2 |
| F2 | Barre di domenica gestite in modo diverso da A4, A7 e dal terminale; indicatori su serie "sporca" | Accordo A4/A7 basso o replica che non riproduce l'originale | **No** | O1 |
| F3 | "Nessun vantaggio dimostrato" letto come "il bias non funziona": test a potenza bassa (MDE circa 2,4%/20gg, stima) | Si chiude la strada EA su un esito non informativo | **No** (verdetto solo binario) | O5c, terza etichetta |
| F4 | Il verdetto (positivo o negativo) attribuito all'indicatore originale, mentre e la replica | Claudio usa il numero per decidere sull'originale | **Parziale** ("Cosa NON dice"; manca la frase obbligatoria e la validazione) | O11d, frase obbligatoria |
| F5 | Spread positivo dovuto solo al momentum banale dell'oro (un filtro "prezzo > EMA 200" fa lo stesso), preso come merito del bias | "Il bias ha valore" quando lo ha ogni trend-follower in un super-ciclo | **No** | O6 benchmark banale, permutazione |
| F6 | Significativita gonfiata da pochi episodi (2008, 2013, 2020) | t >= 2 con 40 osservazioni da 6 episodi | **No** | O5b |
| F7 | Riscaldamento EMA 200 W1 non convergente nella prima meta; il 2008-2010 pesa sul criterio 3 | Spread diverso nella prima meta, spiegato "dal crash" | **Parziale** (dichiarato ma incoerente nel testo) | O3 |
| F8 | Regimi letti come filtro (regime definito dall'esito dell'anno) | "Nei trend funziona, nei laterali no": una tautologia usata come regola | **Parziale** ("senza criterio di accettazione"; manca la dichiarazione ex-post) | O10 |
| F9 | Parametri della replica ritoccati dopo i numeri; due repliche e scelta della piu "favorevole" | Replica migliorata dopo il primo verdetto negativo | **No** (spec non congelata, "studiano entrambe" senza regola) | O11a, O11c |
| F10 | Criteri 3-4 interpretati in modo diverso fra chi li esegue (h, definizione, soglia 8) | Lo stesso studio, due verdetti | **No** | O7 |
| F11 | Verdetto esteso a DAX e Nasdaq (dove Claudio opera) o a intraday | "Il bias funziona/non funziona" detto sugli indici | **Parziale** ("solo oro"; da ripetere nel verdetto) | frase obbligatoria |
| F12 | Fine campione troncata male, ultima barra incompleta, volume non stazionario | Errore piccolo e difficile da vedere | **No** | O4, O12 |
| F13 | Spread negativo significativo invertito dopo (snooping) | "Ho scoperto che il bias e contrarian" | **No** | O14 |

---

## Parte 3 - Cosa NON ho trovato (da non leggere come difetti)
- **Ingresso a open[t+1] e uscita a close[t+h]:** coerente, nessuna scorciatoia se implementata come scritto. Il segnale e noto a close[t] ed eseguibile.
- **Soglia 15 dalla guida:** corretta e scritta ora.
- **AND dei cinque criteri:** non produce falsi positivi (O8).
- **Esclusione dei mesi prima del 2008-07 dalle statistiche:** giusta nell'intento; da correggere solo nelle date (O3).
- **Pesi 54,5 / 45,5:** corretti (30/55 e 25/55).
- **Nessun costo:** corretto per questo orizzonte (O15).
- **Ora del server:** nessun impatto sul D1 (O16).
- **Previsioni dichiarate prima (P1-P5):** buona pratica. P2 = 20% mi pare alta (O5c), ma e una scommessa dichiarata, non un difetto.

---

## Parte 4 - Elenco numerato delle modifiche raccomandate PRIMA di eseguire lo studio

**Bloccanti**
1. **Domeniche:** fondere le barre di domenica nel lunedi successivo (open della domenica, max, min, close del lunedi, volumi sommati); W1 e "h giorni" sulle barre fuse; corsa di sensibilita con barre grezze solo-report; dichiarare che l'originale probabilmente vede le domeniche. (O1)
2. **Test di causalita obbligatori** nell'autotest: prefisso (>= 300 date, tolleranza 1e-9), serie sporcata dopo t, esempio fatto a mano di `close[t+h]/open[t+1]-1`; esito negativo invalida lo studio. (O2)

**Alte**
3. **Regola W1:** la settimana k entra nel calcolo dal primo giorno dopo il suo ultimo giorno (venerdi sera usa le settimane <= k-1). (O2)
4. **Riscaldamento:** partire dalla prima barra (2004-06-14), correggere il testo (182 settimane non sono 200), scrivere il seme dell'EMA e cosa fa il Trend prima di 200 barre; lettura primaria dal 2008-07-01 e robustezza dal 2010-04-01; verdetto positivo solo se vale anche dal 2010-04. (O3)
5. **Inferenza:** t di Welch, offset {0,4,8,12,16} a h=20 e {0..4} a h=5; riportare mediana, min e max; **aggiungere** p-value per permutazione circolare (spostamento >= 60 giorni, >= 2.000 permutazioni, seme fisso): criterio 2 passa solo con t >= 2,0 E p <= 0,05 unilaterale. (O5a, O5b)
6. **Terza etichetta di verdetto "NON CONCLUSIVO (potenza)"**, MDE riportato, regola dei minimi (>= 30 osservazioni non sovrapposte e >= 8 episodi per stato, altrimenti "non valutabile", non "fallito"). (O5c, O7)
7. **Operativizzare criteri 3-5:** h=20, definizione (a), spread puntuale su tutti i giorni; anno valutabile se >= 20 giorni per stato; 60% = ceil(0,6 x anni valutabili); < 10 anni valutabili = non valutabile; anni parziali con la stessa regola. (O7)
8. **Benchmark banale** nella stessa macchina (segno di close D1 - EMA 200 D1 e segno del rendimento a 250 giorni), permutazione circolare come nullo, media assoluta di BULL e BEAR; riscrivere la motivazione della deriva (la deriva non cambia lo spread, cambia la potenza e il confronto assoluto); criterio 5 con t >= 1,0 sull'eccesso BULL e riporto della media assoluta BEAR. (O6)
9. **Congelamento della replica:** SHA256 di specifica, codice A4, CSV e script di studio nell'addendum; ogni modifica successiva = nuova decisione e nuova esecuzione. (O11a)
10. **Regola per due repliche:** verdetto positivo solo se A4 e A7 soddisfano entrambe tutti i criteri; altrimenti "la replica dipende dalle scelte". Accordo A7: kappa >= 0,70 oltre a >= 85%, correlazione dei punteggi grezzi >= 0,90, e confronto con il filtro banale; dare a A7 gli stessi parametri degli screenshot. (O11b, O11c)

**Medie**
11. **Fine campione:** un'osservazione (t,h) entra solo con la barra t+h completa; ultima barra 2026-10-21 esclusa dalle uscite; nessun NaN come zero; riportare l'ultimo t incluso. (O4)
12. **Soglie:** rinominare (b) "segnale deciso" (non "forte"); scrivere che 15 e 50 non si cambiano dopo i numeri; 70 come lettura solo-report; frequenze degli stati ed episodi come primo output. (O9)
13. **Regimi:** etichetta "EX-POST, non utilizzabile come filtro"; anni, osservazioni, episodi per cella; esclusioni dichiarate (2008, 2026); secondo taglio EX-ANTE (terzili di ATR 14 D1 e segno del rendimento a 250 giorni, dati <= t). (O10)
14. **Spread significativamente negativo:** si riporta come "segnale inverso, non adottabile senza dati nuovi". (O14)
15. **Qualita dei dati e volume:** controllo OHLC e range zero nell'autotest, componente volume con rapporto a media mobile corta, dato 2005-2008 dichiarato sottile; h=60 e leave-out 2025-2026 / 2008 come solo-report. (O12, O13, O17)

**Bassa, di prassi**
16. **Frasi obbligatorie nel verdetto:** (a) "verdetto sulla replica, non sull'indicatore originale (non validata)"; (b) "solo oro, solo W1+D1, solo barre giornaliere, 5 e 20 giorni; nessuna conclusione su indici, intraday, EA"; (c) "nessun vantaggio dimostrato non significa nessun vantaggio" con l'MDE; (d) "nessuna regola EA tarabile su questi dati". Proposta separata a Claudio (decisione sua): script di sola lettura che registri su CSV i testi della dashboard originale su W1 e D1 per validare la replica. (O8, O11d, O17)

---
*Nota di metodo:* le stime di potenza (sigma a 20 giorni, quota BEARISH, deriva dell'oro) sono ipotesi mie, **non verificate sui dati dello studio** (non li ho guardati per scelta); vanno ricalcolate dai numeri effettivi nell'esecuzione (MDE). Le date e i conteggi del CSV sono verificati.
