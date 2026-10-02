# ABTG Pulsanti Grafico - nota per Claudio (02/10/2026)

**File:** `mql5/Indicators/ABTG_Pulsanti_Grafico.mq5` (indicatore, SOLA VISIONE: non apre, non modifica e non chiude ordini; nessuna rete; nessun file).
**Collaudo:** `backtest_pipeline/collaudo_pulsanti_grafico.py` (esito completo in `backtest_pipeline/risultati_archivio/PULSANTI_GRAFICO_COLLAUDO_2026-10-02.txt`).
**Stato:** NON compilato (qui non c'e' MetaEditor). Collaudo statico + funzioni di calcolo vere compilate in C++ + misure su dati reali XAUUSD: tutto verde. **Prima di arrivare a te passa dal cancello indipendente.**

## 1. Cosa fa, in una riga

In alto a sinistra c'e' **una barra sottile di rettangolini colorati**. Un clic accende, un altro clic spegne. All'avvio e' **tutto spento**: il grafico resta pulito, l'indicatore non disegna niente finche' non accendi qualcosa.

| Rettangolino | Colore del tasto | Cosa compare |
|---|---|---|
| EMA 200 | rosso | EMA 200 rossa, spessa 3 |
| EMA 50 | bianco | EMA 50 bianca, spessa 2 |
| EMA 9 / EMA 21 | rosa e giallo (un tasto diviso in due, si accendono insieme) | EMA 9 rosa e EMA 21 gialla, spesse 1 |
| BOLLINGER | grigio-azzurro | bande 20 / 2: media tratteggiata + banda alta e bassa |
| SUPERTREND | verde | Supertrend ATR 10 x 3,0: verde sotto il prezzo (trend su), rosso sopra (trend giu') |
| LIVELLI | arancio | livelli con il NOME in italiano + prezzo (par. 4) |
| HEIKIN ASHI | viola | candele Heikin Ashi al posto di quelle normali |
| ORDINE CONSIGLIATO | azzurro | ingresso, stop loss, 3 TP tratteggiati + pannello OPERAZIONE in alto a destra (par. 5) |

- **Acceso** = rettangolino a colore pieno con bordo marcato; **spento** = fondo scuro con il contorno del suo colore e la scritta grigio chiaro (si legge sempre).
- Passandoci sopra col mouse compare un piccolo suggerimento ("ACCESO, clic = spegni").
- Il clic **non ricarica** l'indicatore e **non cambia** simbolo o TF: si riscrive solo cio' che si vede.
- Con HEIKIN ASHI spento le tue candele restano esattamente come sono. Acceso: le candele normali vengono nascoste e allo spegnimento (o quando togli l'indicatore, o cambi simbolo/TF) tornano con i **tuoi** colori.

## 2. Come installarlo e provarlo in 5 minuti

**Su quale terminale:** un terminale MT5 **DEMO** sul tuo PC, su un grafico **SENZA EA**. Non sul VPS mentre la challenge opera, mai sul reale `10105439` (`C:\BCM_Reale`) ne' sul FTMO `541452707` (`C:\FTMO`).
Prima di cominciare scriviti il numero di conto del terminale scelto. Se hai piu' terminali aperti, questa riga **legge e basta** (finestra PowerShell sullo stesso PC, non tocca nessun terminale) e stampa numero del processo, titolo con il conto e cartella:

```
Get-Process terminal64 | select Id, MainWindowTitle, Path
```

1. Copia `ABTG_Pulsanti_Grafico.mq5` in `MQL5\Indicators\` del terminale scelto (File > Apri cartella dati).
2. Aprilo in MetaEditor e premi **F7**: devono uscire **0 errori**. Annota gli avvisi, se ce ne sono, e mandameli.
3. Trascinalo su un grafico (es. XAUUSD M5). Devi vedere solo la barra in alto a sinistra, nient'altro.
4. Clicca, uno alla volta: EMA 200, EMA 50, EMA 9/21, BOLLINGER, SUPERTREND -> ogni linea compare e scompare subito.
5. HEIKIN ASHI: le candele cambiano; ricliccalo: tornano le tue, con i tuoi colori.
6. LIVELLI: compaiono le righe con il nome a destra (es. `MAX GIORNO PRECEDENTE 24.998,25`). Scorri il grafico: le scritte seguono le righe.
7. ORDINE CONSIGLIATO: compaiono INGRESSO (azzurra), STOP LOSS (rossa), TP1/TP2/TP3 (verde fosforescente), tutte tratteggiate, e il pannello OPERAZIONE in alto a destra. Cambia TF: il setup diventa quello del nuovo TF.
8. Cambia TF e torna indietro: i tasti accesi restano accesi. Togli l'indicatore e rimettilo: riparte tutto spento.
9. Nella scheda Esperti non deve comparire niente a ogni clic (solo eventuali righe "fuori intervallo" se hai messo input strani).

## 3. Come ridimensionare la barra (input)

| Input | Default | Cosa fa |
|---|---|---|
| `InpBarraX` | 4 | distanza dal bordo sinistro (px) |
| `InpBarraY` | 20 | distanza dal bordo alto (px): sta sotto la riga del simbolo. Se usi il pannello One Click Trading, portalo a ~70 |
| `InpTastoH` | 19 | altezza dei rettangolini (px) |
| `InpTastoFont` | 7 | dimensione della scritta |
| `InpTastoPxCar` | 6 | larghezza per carattere: alzalo per rettangolini piu' larghi, abbassalo per piu' stretti |
| `InpTastoSpazio` | 2 | spazio fra un rettangolino e l'altro |

Le misure si ingrandiscono da sole sugli schermi ad alta risoluzione (DPI). Gli `InpDefaultAcceso*` (tutti `false`) decidono cosa e' acceso alla PRIMA apertura; dopo comandano i tasti.

## 4. LIVELLI: definizione esatta

**Tutte le ore sono ORA SERVER del broker (quella delle candele), non l'ora italiana.** Il "giorno" e' la candela D1 del server, la settimana la W1 (in MT5 parte la domenica), il mese la MN1. Su BCM: d'estate server = ora italiana - 1, d'inverno server = ora italiana (`report/OROLOGIO_BCM_2026-09-24.md`).

| Nome sul grafico | Input (default) | Come si ricava | Stile |
|---|---|---|---|
| MAX GIORNO PRECEDENTE | `InpLiv_GiornoPrecMax` (si') | massimo della candela D1 del giorno precedente (*) | tratteggiato |
| MIN GIORNO PRECEDENTE | `InpLiv_GiornoPrecMin` (si') | minimo della stessa candela | tratteggiato |
| CHIUSURA GIORNO PRECEDENTE | `InpLiv_GiornoPrecChiusura` (si') | chiusura della stessa candela | tratteggiato |
| APERTURA DI OGGI | `InpLiv_OggiApertura` (si') | apertura della candela D1 in corso (nel weekend, a mercato chiuso, e' l'ultima candela D1 con quotazioni: il venerdi') | continuo |
| MAX DI OGGI / MIN DI OGGI | `InpLiv_OggiMax/Min` (si') | massimo/minimo della candela D1 in corso; si aggiornano a ogni tick | continuo |
| MAX / MIN SETTIMANA PRECEDENTE | `InpLiv_SettPrecMax/Min` (si') | massimo/minimo della candela W1 precedente | tratteggiato |
| MAX / MIN MESE PRECEDENTE | `InpLiv_MesePrecMax/Min` (**no**) | massimo/minimo della candela MN1 precedente | tratteggiato |
| MAX NOTTE / MIN NOTTE | `InpLiv_NotteMax/Min` (si') | massimo/minimo delle candele M1 fra `InpNotteDaOra:InpNotteDaMin` del giorno prima e `InpNotteAOra:InpNotteAMin` di oggi, estremi compresi (default **23:00 -> 04:59**, cioe' 00:00-05:59 italiane d'estate: e' il box delle sedie DAX "massimi e minimi della notte", stessi numeri di `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` e dei suoi preset). Durante la notte si allarga col prezzo. Fra le 23:00 e la mezzanotte server resta quella della notte PRIMA (come l'EA); la nuova compare a mezzanotte. Se la notte di oggi non ha quotazioni (weekend, festivo) si usa l'ultima che ne ha | continuo |
| NUMERO TONDO SOPRA / SOTTO | `InpLiv_TondoSopra/Sotto` (**no**) | multiplo del passo subito sopra e subito sotto il prezzo (se il prezzo e' proprio sul multiplo, quello sopra e quello sotto). Passo `InpTondoPasso`; 0 = automatico: oro 10, forex 0,0100 (yen 1,00), indici 100, o 1000 da 30.000 in su | puntinato |
| ULTIMO MASSIMO H4 / ULTIMO MINIMO H4 | `InpLiv_H4Max/Min` (**no**) | ultimo swing H4 (massimo piu' alto delle `InpH4Ampiezza`=2 candele H4 per lato, con 2 candele chiuse a destra) **non ancora superato** da nessuna candela H4 successiva, quella in corso compresa | tratteggiato |

(*) **Giorno precedente** = l'ultima candela D1 prima di oggi che cade da lunedi' a venerdi'. Quindi il **lunedi' il giorno precedente e' il venerdi'**, anche se il broker ha una candela di un'ora la domenica sera (chi riapre il forex alle 23 di domenica). Per i simboli che quotano **anche il sabato** (cripto) conta ogni candela: lo si vede **nei dati** (fra le ultime 10 candele D1 ce n'e' una di sabato), non dalla sessione dichiarata dal broker. Dopo un festivo vale l'ultimo giorno lavorativo con quotazioni.

- **Colori:** sopra il prezzo = colore "resistenza", sotto = colore "supporto" (il nome non cambia). Famiglie: giorno rosso/blu, settimana arancio/verde acqua, mese magenta/viola, notte giallo/verde, numeri tondi grigio chiaro/scuro, H4 rosa/azzurro. Tutti modificabili negli input.
- **Scritte:** al bordo destro, appena sopra la loro riga. Se due livelli hanno **lo stesso prezzo** diventano una riga sola: `MAX GIORNO PRECEDENTE / MAX SETTIMANA PRECEDENTE 24.998,25`. Se sono solo **vicini**, le scritte si scalano verso il basso e non si sovrappongono. Formato italiano: punto per le migliaia, virgola per i decimali.
- Il tasto e' uno solo (LIVELLI). Quali livelli compaiono lo decidono gli input `InpLiv_*`.

## 5. ORDINE CONSIGLIATO: che cos'e' e come si calcola

**E' un calcolatore di stop e target, NON un segnale validato.** Il pannello lo scrive in fondo: *SETUP INDICATIVO - NON VALIDATO: i lotti sono indicativi*. Le misure fatte finora (H4+M3, EMA200) non hanno dimostrato un vantaggio nell'entrare all'inversione: il nome "ORDINE CONSIGLIATO" e' il tuo, il contenuto e' un calcolo. **Nessun ordine viene inviato.**

Regole (le stesse della SuperWave v4.1, stessi default):
- **Ingresso** = chiusura della candela in cui il Supertrend **3,5** (ATR 10) si e' girato, sul **TF del grafico**. Solo candele CHIUSE: dentro la candela in corso non cambia mai.
- **Stop loss** = valore del Supertrend su quella candela. **R** = distanza ingresso-stop.
- **TP1 / TP2 / TP3** = ingresso + 1R / 2R / 3R (BUY) o meno (SELL): `InpTP1_R/2_R/3_R`.
- **Lotti** = rischio `InpRiskPct`=1% del **saldo**, diviso 40/30/30 (`InpSize1/2/3`), arrotondati **per difetto** al passo del simbolo (con la tolleranza che non sbaglia i multipli esatti: 0,29 resta 0,29), dentro minimo e massimo del simbolo; valore del tick in perdita del broker. Il rischio e' scritto anche in valuta del conto. Il saldo si **legge** (sola lettura) solo per questo.
- Il setup resta **fisso** fino alla prossima inversione. Se manca: pannello "in attesa di inversione" con il motivo.
- **Stato** dalla candela dopo l'inversione: APERTO / TPk raggiunto / INVALIDATO (stop toccato) / TP poi stop / stop e TP nella stessa candela (ordine non noto).
- **Cambio TF:** il setup e' quello del TF in cui guardi. Cambi TF = vedi il setup di quel TF (versione semplificata della selezione della SuperWave: niente griglia, niente memoria).
- Funziona anche con il tasto SUPERTREND spento.
- **Linee:** INGRESSO **azzurra** tratteggiata (terzo colore, per non confonderla ne' col verde dei TP ne' col rosso dello stop), STOP LOSS **rossa** tratteggiata, TP1/2/3 **verde fosforescente** (#39FF14) tratteggiate; scritte `INGRESSO 24.998,25`, `STOP LOSS ...`, `TP1 ...`.
- **Pannello:** stessa posizione (alto a destra), stesse righe, stesso carattere (Consolas) e stessi colori della SuperWave, con una riga in piu' in fondo (l'avviso). Differenza voluta: i numeri sono in **formato italiano** (24.998,25 e 0,20 lotti), come le scritte sulle linee.

## 6. Supertrend: quale ho usato e perche'

Una sola implementazione in tutto il file: **la `SW_STCore` della SuperWave v4.1**, ricopiata identica (il collaudo lo verifica riga per riga). ATR = **media semplice** del true range, come `iATR` di MT5 (misurato: scarto massimo 1,1e-14 contro la formula di MT5). Perche' non le altre due:
- `ABTG_Confluenza.mqh` (quella di `ABTG_Segnali_EMA_BB_ST`) ha come default l'ATR di **Wilder**, non quello chiesto;
- `ABTG_Supertrend.mq5` legge un handle `iATR` (dati da aspettare) e confronta la chiusura con la banda della **stessa** candela invece che di quella prima: in rari casi gira una candela prima o dopo.
- Il tasto SUPERTREND usa moltiplicatore **3,0** (`InpStMolt`); il setup di ORDINE usa **3,5** (`InpSetupMolt`, come la SuperWave). Stessa funzione, stesso periodo ATR: cambia solo il moltiplicatore. Quindi la linea verde/rossa che vedi **non e'** quella che decide il setup: se vuoi che coincidano, metti `InpStMolt = 3,5`.
- La linea e' disegnata in due pezzi (verde e rosso) senza il trattino diagonale all'inversione. Effetto collaterale: un trend che dura una sola candela non si vede (un punto solo).

## 7. Stato dei tasti e riavvio

- Lo stato resta al **cambio di simbolo, di TF e di parametri** (GlobalVariable con il numero del grafico nel nome).
- Si cancella quando **togli** l'indicatore o **chiudi** il grafico.
- **Riavvio del terminale:** se il grafico riprende lo stesso numero interno (ChartID), i tasti tornano come li avevi lasciati; altrimenti si riparte da tutto spento. Quale dei due succede **[NON VERIFICATO]**.
- Se cambi un `InpDefaultAcceso*` dalla finestra degli input, per quel tasto vince l'input.
- Se il terminale si chiude in crash con HEIKIN ASHI acceso e riapri il grafico senza candele: rimetti l'indicatore e tornano da sole; a mano: F8 > Colori.

## 8. Cosa NON e' coperto

- **Compilazione MQL5 [NON VERIFICATA]:** controllati parentesi, buffer, identificatori, costanti, funzioni chiamate, variabili che nascondono globali (l'avviso `c2` della v4.1); il blocco di calcolo e' compilato in C++ senza avvisi. Le chiamate al terminale no.
- **Nel terminale [NON VERIFICATO]:** pulsanti col bordo colorato (`OBJPROP_BORDER_COLOR`), scritte al bordo destro (`ChartTimePriceToXY`), nascondere le candele con `clrNONE`, riscrittura dei buffer da un clic. Sono tecniche gia' usate negli altri indicatori del progetto, non provate in questo file.
- **Scritte dei livelli:** seguono le righe a ogni tick, a ogni scorrimento/zoom e ogni secondo; con il ridimensionamento automatico della scala un ritardo di un secondo e' possibile.
- **EMA 50 bianca su sfondo bianco** non si vede: cambia `InpColEma50` se usi lo sfondo chiaro.
- **Un indicatore per grafico**, e non insieme ad altri che nascondono le candele (`ABTG_Segnali_EMA_BB_ST`, SuperWave in HA): si disturbano.
- **Notte, differenza possibile con l'EA [DEDOTTO dal codice, NON misurato]:** `ComputeBox` dell'EA MaxMinNotte cerca la candela delle 23:00 con `iBarShift(..., false)`: se a quell'ora non c'e' una candela M1 (mercato fermo), prende quella **prima**, cioe' l'ultima della sera precedente, e la mette nel box. L'indicatore usa solo le candele **dentro** la finestra. Nel repo non ci sono M1 del DAX per misurare quante volte succede.
- **Giorno precedente sui dati del broker:** la regola "lunedi' -> venerdi'" e' misurata su XAUUSD in ora UTC (dove la candela della domenica c'e' sempre). Su BCM l'oro riapre a mezzanotte server e non ha la candela della domenica; il forex si'. Per le cripto il sabato si riconosce dalle candele D1 (cancello del 02/10, classe 1069: prima dipendeva dalla sessione dichiarata dal broker, non verificabile qui); provato solo sulla logica, **[NON VERIFICATO su BTCUSD BCM]**.
- **Codice di raccordo (fuori dalle funzioni di calcolo) [NON PROVATO a comportamento]:** e' protetto da 94 "ancore" (una riga cambiata viene vista), non da una prova di comportamento. Misura del cancello del 02/10: mutanti scritti alla cieca su righe NON ancorate, 8 su 10 restano verdi (classe 1068). Quello che lo prova davvero sono gli 8 passi del par. 2 nel terminale.
- **Testi lunghi:** alcune righe (stato "stop e TP nella stessa barra ... (ordine non noto)", livelli fusi a tre nomi) superano i 63 caratteri; se il terminale tronca le scritte si vedono tagliate. Uguale alla SuperWave v4.1 **[NON VERIFICATO]**.
- **Schermo stretto:** barra (circa 600 px) e pannello OPERAZIONE (circa 360-460 px) su un grafico largo meno di ~1.000 px si toccano: sposta la barra con `InpBarraY`.
- I lotti sono indicativi: dipendono dal valore del tick dichiarato dal broker.
- Le ore nel pannello sono **ora server**.

## 9. Difetti trovati nelle funzioni riusate

1. **SuperWave v4.1, commento di `SW_NormLots`:** dice che 0,3/0,01 fa 29,999999999999996. Falso: in virgola mobile fa **30,0 esatto**. La funzione e' giusta (ha la tolleranza), il commento no. Nella copia di QUESTO file il commento e' corretto (0,29 / 0,57 / 0,58); il codice resta identico. I multipli che un `MathFloor` senza tolleranza sbaglia davvero sono 0,29 / 0,57 / 0,58 (28,999999999999996...). Al primo giro il mio collaudo, fidandosi di quel caso, non prendeva il mutante "MathFloor nudo": ora lo prende (classe 1066).
2. **SuperWave v4.1, livelli:** il tasto LIVELLI (lettura con `CopyRates` di `InpLevelsLook+2` candele) e il ricalcolo a ogni tick usano finestre che partono a **una candela di distanza**: uno swing proprio sul bordo sinistro compare dopo il tick e non dopo il clic. Effetto minimo, segnalato e non corretto (fuori perimetro). Qui non si applica: LIVELLI ora sono livelli nominati.
3. **SuperWave v4.1, avviso `c2`:** `int s2,c2;` in `OnChartEvent` nasconde il buffer globale `c2[]`. Il collaudo lo ritrova sul sorgente vero (e' il controesempio del rilevatore); qui nessuna variabile nasconde una globale.
4. **SuperWave v4.1, Heikin Ashi:** la prima candela parte da `open[0]` invece che da (apertura+chiusura)/2 come in `ABTG_Segnali`: differenza solo sulle prime candele, si dimezza a ogni candela. Ho usato la formula di `ABTG_Segnali`.
5. **EA MaxMinNotte:** vedi par. 8 (box notte e `iBarShift`), dedotto e non misurato.

## 10. Cosa prova il collaudo (numeri)

Comando: `python3 backtest_pipeline/collaudo_pulsanti_grafico.py` (completo, XAUUSD M1 2021-2026). Esito: **270 controlli verdi, 0 rossi** (233 al primo giro; +37 aggiunti dal cancello indipendente del 02/10: ancore e mutanti sul codice di raccordo).

- **Calcoli uguali bit per bit:** EMA, Bollinger, i due Supertrend e Heikin Ashi del sorgente vero (compilati in C++) contro lo specchio Python: 0 candele diverse su 7 serie (sintetiche, pareggi esatti con le bande, costante, XAUUSD M5 e H1 reali) x 3 insiemi di parametri. Calcolo a pezzi come fa il terminale (candela in corso prima "falsa" poi vera) = calcolo intero: 0 differenze.
- **Contro riferimenti indipendenti:** Bollinger contro media e deviazione di Python (scarto 1,1e-16); ATR contro la formula di MT5 (1,1e-14); EMA contro la formula chiusa (2,3e-15); swing H4 contro forza bruta su 462 casi, anche reali (0 differenze).
- **Giorno precedente:** su 1.771 giorni reali coincide sempre con l'ultimo giorno lun-ven con quotazioni (0 diversi). **Caso che deve scattare:** 289 lunedi' con la candela della domenica: la regola "candela prima" sbaglia in 289, la nostra in 0. Massimo/minimo/chiusura del giorno, della settimana (297) e del mese (68) precedenti = minuti grezzi: 0 diversi.
- **Notte:** finestra uguale al calendario su 410 istanti; 12 istanti di weekend/festivo in cui si usa la notte prima.
- **ORDINE tick per tick** (XAUUSD M5 reale, uno stato per ogni minuto, 19.689 stati, 92 inversioni): ingresso **mai** cambiato dentro la candela ne' fra candele senza inversione. Controesempio: con l'ingresso sulla candela in formazione cambierebbe 367 volte.
- **Lotti con risposta nota:** saldo 10.000, 1% = 100, R 5,00 $ sull'oro -> 0,20 lotti, quote 0,08 / 0,06 / 0,06.
- **Mutanti sul sorgente vero (83, tutti presi; 46 al primo giro + 37 del cancello, che prima del rinforzo restavano verdi):** fra questi quelli chiesti: ingresso mobile, stop sbagliato, TP al segno sbagliato, lotto invertito (nella funzione e negli argomenti), MathFloor senza tolleranza, giorno precedente con la domenica, setup col moltiplicatore della linea, OnDeinit senza ripristino delle candele, EMA 50 che mostra la 200.
- **Non prova:** la compilazione MQL5 e il comportamento dentro il terminale (par. 8).

## 11. Domande per te

1. **Altri livelli:** hai scritto "ecc ecc". Quali altri vuoi? Non ne ho aggiunti di mia iniziativa (per esempio: massimo/minimo della sessione di Londra o di New York, chiusura della settimana precedente, apertura della settimana).
2. **Numeri tondi:** il passo automatico (oro 10; forex 0,0100, yen 1,00; indici 100, da 30.000 in su 1000) ti va bene? Per il Dow preferisci 100 o 1000?
3. **Pannello ORDINE:** ho messo i numeri in formato italiano (24.998,25; 0,20 lotti) come le scritte sulle linee, mentre la SuperWave scrive 24998.25. Va bene, o lo vuoi identico anche nel formato?
4. **Supertrend:** linea a 3,0 e setup a 3,5 (come la SuperWave). Preferisci che la linea verde/rossa sia la stessa del setup (3,5)?
