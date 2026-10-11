# PER GEMINI -- Breakout di canale su oro M5, filtro orario tolto (00-07 -> 24 ore): tre domande chiuse sui nostri numeri -- 11/10/2026

Scritto da Claude per Gemini, secondo `docs/gemini/PROTOCOLLO_SQUADRA_2026-10-08.md` (non e' allegato a questo file: lo passa esplicitamente l'invio, insieme alla memoria condivisa e alla BASE) e la BASE di conoscenza che ricevi in testa. Il pacchetto si legge da solo e contiene solo cio' che serve alle tre domande della sez. 6.
**Perche' esiste**: regola di casa dell'11/10, punto 1 (uno ZIP di misura letto genera un pacchetto con al massimo 3 domande falsificabili, una per chiamata). La misura E' gia' stata fatta e letta; questo pacchetto chiede dove la nostra lettura puo' sbagliare.
Niente preset, righe o script di lancio, conti, importi o nomi di terzi in questo documento.
**Nota importante**: il motore e' una **replica nostra** di una configurazione dichiarata da terzi (nel file prova la cella di partenza si chiama REPL e le sue soglie parlano di «dichiarazione ... RISCONTRO sul nostro feed»): i numeri dicono cosa fa *la nostra replica* sul feed del nostro broker, non cosa fa il motore di altri.

Etichette di questo pacchetto: **[FATTO]** = letto in un file del repo (la fonte e' accanto); **[CALCOLO]** = conto su fatti, scritto con i numeri; **[IPOTESI]** = ragionamento nostro, non verificato; **[NON MISURATO]** = il numero non esiste; **[NON ATTRIBUITA]** = un numero e' stato misurato ma la sua causa no.
**Cosa chiediamo, e come rispondere (ruoli del protocollo)**: **Q1** al ruolo **B** (avvocato del diavolo), **Q2** al ruolo **C** (auditor, UN conto solo), **Q3** al ruolo **B**. Una domanda per chiamata. Tabella `N | Affermazione | Etichetta (FATTO / CALCOLO / IPOTESI / NON LO SO) | Fonte (sezione del PACCHETTO, oppure "mia conoscenza di mercato, non verificata") | Verificabile da noi come | Costo`. Ogni affermazione senza fonte e' IPOTESI. "NON LO SO" e' una risposta valida e preferita a un numero inventato. Cita i NOMI degli input o dei campi, mai numeri di riga.

**I numeri di questo documento vengono dalla nostra lettura** (le uniche eccezioni, ognuna con la fonte accanto, sono i parametri e le regole del motore e i conteggi dei giornali dell'EA, in sez. 1 e 3.1, le due durate di esempio in sez. 4.1, dall'output di `analisi_m5h24.py` nell'archivio del lotto, e le soglie di spread di sez. 6 Q3 (2,4 volte; 0,257 contro 0,107 USD), dal file prova; i «dieci giorni» della tranche dal 01/10/2026, in sez. 6 Q3, sono un conto di calendario) [FATTO: `report/GBA_R2_M5_24H_LETTURA_2026-10-11.md`, commit 15b93366, SHA256 `b7e37b39af9ed342d6b997f49ba051a638830756960fba898ca99bfec125a102`; la lettura ha avuto un PASS del nostro cancello, commit 3046cfab]. Qui non c'e' nessun conto nuovo sui numeri della lettura. Le sezioni della lettura sono citate accanto a ogni blocco come «lettura §N».

---

## 1. Il motore e cosa cambia in questo lotto

- **Motore** [FATTO: pin della prova e codice dell'EA v1.10, SHA256 `1381E3DC...`; funzioni citate per nome]: alla chiusura di ogni barra M5. **Segnale**: long se la chiusura e' sopra il massimo delle 48 barre PRECEDENTI (esclusa la barra di segnale) E sopra l'EMA(100); short a specchio (minimo, sotto l'EMA); confronti stretti (`GbaDirezione`, `GbaCanale`; `InpChannelBars`, `InpEmaPeriod`). **Filtro di spread**: il segnale entra solo se lo spread e' <= 0,05 x ATR(14) (`GbaSpreadOk`, `InpSpreadMaxATR`). **Ingresso** a mercato al primo tick della barra successiva (`GbaApri`). **Stop iniziale** a 2,5 x ATR(14) dal prezzo d'ingresso (`InpSL_ATR`); nessun take profit. **Trailing**, solo a favore: lo stop va all'estremo raggiunto dall'ingresso (massimo per il long, minimo per lo short) meno/piu' 2,5 x ATR dell'ultima barra chiusa, a ogni tick (`GbaSLProposto`, `GbaSLMigliore`, `InpTrail_ATR`, `InpTrailAtrMode`=0). **Breakeven**: quando il profitto raggiunge 1,0 x ATR lo stop va al prezzo d'ingresso, se piu' favorevole del trailing (`GbaBeArmato`, `InpUseBreakeven`, `InpBE_TriggerATR`, `InpBE_OffsetATR`=0). **Uscita a tempo** dopo 48 barre M5, contate come barre ESISTENTI dall'ingresso (`iBarShift` in `GbaLeggiGestione`, `InpTimeExitBars`), non come minuti: per una posizione che attraversa la pausa dei prezzi (senza barre) l'uscita a tempo scatta dopo piu' di 240 minuti di orologio, se lo stop non la chiude prima (sez. 4.1: alcune delle 28 durano oltre 240 minuti, le altre escono a stop prima). EMA e ATR sul TF del segnale (`InpTrendTF`=0, `InpAtrTF`=0). Long e short accesi. **Una posizione per volta** per magic e simbolo (`GbaPosizioneAperta`): un segnale che arriva con una posizione aperta non entra [FATTO: lettura §5, «una per volta»]. Le uscite sono quasi tutte per STOP (lettura §2: 1.054 su 1.060), compreso lo stop spostato da trailing e breakeven (per le 28 posizioni della sez. 4.1 il commento d'uscita e' `sl <livello>`); l'uscita a tempo e' rara: lettura §2 «6 a mercato» e 6 righe «uscita a tempo» nei giornali dell'EA (T1 1, T2 3, T3 2) [FATTO: giornali nello zip archiviato].
- **Cosa cambia**: UNA sola variabile rispetto alla cella M5 gia' misurata (che chiamiamo R2NOTTEM5, filtro orario 00-07 ora server): l'input `InpHourEnd` passa da 7 a 24, cioe' **nessun filtro orario**, M5, stessi segnali [FATTO: lettura §1, righe «UNA variabile» e «stessi segnali di R2NOTTEM5»: confronto dei file di configurazione archiviati, differiscono solo in quell'input e nel nome del report; segnali dell'EA 1290 / 1129 / 1110 in T1 / T2 / T3, identici a R2NOTTEM5]. Il lotto si chiama R2M5H24.
- **Condizioni** [FATTO: lettura §1 e §2]: tick reali (100%), 3 passate su 3 riuscite (48-49 s l'una), lotto fisso (1 lotto), deposito fittizio 1.000.000 EUR (le percentuali di DD non si leggono), commissione del tester inclusa nel PF_V. **Tre tranche del 2026**: T1 luglio-settembre, T2 aprile-giugno, T3 gennaio-marzo (nove mesi); un solo broker, un solo orologio del server [FATTO: lettura §10]. Fasce orarie in ORA SERVER dell'ingresso.
- **Perche' la cella esiste**: la R2NOTTEM5 aveva dato PF_V 1,325 su n=303, ma per tranche 0,873 / 0,848 / 2,094. La domanda di chi dirige il progetto era: *conta la notte, o conta il TF?* Togliere il filtro orario e' la misura che confronta le due celle a parita' di TF e di filtro di spread [FATTO: file prova, sezione «CHE COSA MISURA»].
- **Cosa il lotto NON fa** [FATTO: lettura, intestazione e §10]: nessun verdetto di merito oltre l'esito neutro della sez. 2; nessuna promozione; **stato del motore: NON ANCORA MISURATO** (certificato a 5 caselle: PF e n/DD si'; uscita ad asse: lotto sull'uscita girato e letto l'11/10, non riesaminato qui; simboli gemelli NO; TF cambiato APERTA: M5 su 3 tranche, non sulle 9 del piano) [FATTO: lettura §11]. Non separa il TF dal filtro di spread: in tutte e due le celle il filtro e' 0,05 x ATR M5, quindi ogni «[TF]» di questo pacchetto vuol dire «M5 + filtro» [FATTO: lettura §10].

## 2. L'esito scritto prima dei numeri, e cosa ha detto

Gli esiti sono tre, neutri, e valgono sui soli PF_V e n stampati dal lettore passato [FATTO: file prova, sezione «GLI ESITI DI QUESTO LOTTO»; testo copiato alla lettera]:
> **Prima degli esiti**: la passata e' leggibile (G0 OK, CONTROLLO DIRETTO OK) e n totale >= 520; n < 520 = guasto, nessun esito.
> **(E1)** PF_V totale di H24 <= 1,03 -> 'cella H24 indistinguibile dalla REPL e da 1,0 (S8): non e' un candidato; si scrive il numero e la colonna per tranche. COMPATIBILE con [N] e con [R]: quale, lo DESCRIVONO la colonna per tranche e le sei fasce; nessuna delle due si scrive come verdetto'.
> **(E2)** PF_V totale >= 1,3 (n totale >= 150) E almeno 2 tranche con PF_V di tranche > 1,3 e n di tranche >= 150 ciascuna -> 'H24 rende nel totale e in almeno 2 tranche, a parita' di TF e filtro con R2NOTTEM5: COMPATIBILE con "la fascia non basta a spiegare M5 notte"; da dove venga (asia o 07-22) lo DESCRIVONO le sei fasce (unione 07-22 non stampata); filtro e TF restano non separati; si ripete in T0 (S10)'.
> **(E3)** TUTTO IL RESTO -> 'nessun verdetto: si scrive il numero e la colonna per tranche, T0 (S10)'.

La soglia di E1 viene da S8 del file prova: la cella di partenza REPL ha PF_V 0,855 con intervallo per giorno al 95% [0,70 ; 1,03], quindi una cella con PF_V <= 1,03 e' «indistinguibile dalla REPL e da 1,0» [FATTO: file prova, S8].

**Esito: E1** [FATTO: lettura §3]. Pre-condizioni soddisfatte (G0 OK, CONTROLLO DIRETTO OK, n totale 1.060 >= 520, nessun guasto). PF_V totale 0,918 <= 1,03. E2 non puo' valere insieme a E1; PF_V di tranche > 1,3 con n >= 150: 0 su 3.

Le tre spiegazioni descrittive, scritte prima (NON sono esiti, nessuna si scrive come verdetto) [FATTO: file prova, sezione «LE SPIEGAZIONI» e lettura §8]:
- **[N] «conta la notte»** (ipotesi dichiarata da terzi): atteso asia ~1,3, giorno < 1,0, totale 0,85-1,05.
- **[TF] «conta M5 + filtro, non la notte»**: atteso giorno che rende come la notte, totale >= 1,25.
- **[R] «conta il regime»**: atteso T3 >= 1,3, T1 e T2 < 1,0.

Cosa dice la lettura sulla compatibilita' [FATTO: lettura §8]: **[TF] non compatibile con la sua previsione** (totale 0,918, resto 07-24 0,858); **[N] compatibile sul totale, e anche nella meta' giorno come descrizione, non come esito** (asia 1,111, sul bordo basso di una banda larga 1,10-1,55 che non e' una soglia; europa e USA apertura < 1, ma pausa 1,13 e USA pomeriggio 1,33; il segno del giorno e' implicato dal netto 07-22 di -65.714, sez. 3.4); **[R] compatibile: sulla sola fascia asia lo schema c'e' (1,58 contro 0,87 / 0,79), sul totale per tranche no (T3 0,954); non separabile da [N] con tre tranche del 2026.** L'ipotesi intera di terzi (notte >= 1,3 in ogni tranche con n >= 150 e giorno < 1,0) e' **NON MISURABILE** da questo lotto (notte 93-109 per tranche; PF_V dell'unione delle fasce 07-22 non stampato da nessun lettore passato, anche se il netto 07-22 di -65.714 ne implica il segno: PF_V < 1,0, 0,820; sez. 3.4).

## 3. I numeri

### 3.1 Il totale e il confronto con le altre celle  [FATTO: lettura §2]
1 lotto fisso, deposito fittizio 1.000.000 EUR, commissione del tester inclusa nel PF_V.
| lotto / cella | n totale | PF_V totale | netto EUR | T1 n / PF | T2 n / PF | T3 n / PF |
|---|---:|---:|---:|---|---|---|
| **R2M5H24, M5 24 ore (questo lotto)** | **1.060** | **0,918** | **-40.072** | 336 / 0,897 | 343 / 0,873 | 381 / 0,954 |
| R2NOTTEM5, M5 00-07 (termine di confronto) | 303 | 1,325 | +37.319 | 93 / 0,873 | 97 / 0,848 | 113 / 2,094 |
| R2NOTTEM1, M1 00-07 | 143 | 0,928 | -5.047 | 6 / 0,110 | 33 / 0,471 | 104 / 1,123 |
| R1A, M1 24 ore (filtro 0,05 x ATR M1; PF_V; tranche a 2 decimali, uguali al PF del report) | 933 | 0,855 | -53.819 | 128 / 0,83 | 248 / 0,77 | 557 / 0,89 |

Il confronto con R1A mescola TF e filtro di spread: il solo confronto che isola la finestra oraria e' quello con R2NOTTEM5 [FATTO: lettura §2, nota sotto la tabella].
Altri numeri [FATTO: lettura §2]: frequenza 5,17 / 5,36 / 6,05 operazioni al giorno feriale; long 535 (PF_V 0,92, -19.947), short 525 (PF_V 0,92, -20.125); win rate 29%; uscite 1.054 a stop (PF 0,856; lo stop e' quello della posizione, che trailing e breakeven possono aver spostato, sez. 1), 6 a mercato (nei giornali dell'EA le righe «uscita a tempo» sono 6, sez. 1). Costo (mediana stop/spread) 59,7x con +0,04 USD/oz di commissione, soglia di casa 40x: PASSA. DD equity a 1 lotto: T1 22.802, T2 34.925, T3 47.781 EUR, contro R2NOTTEM5 (11.534 / 21.663 / 11.549): 1,98x / 1,61x / 4,14x (la nostra attesa scritta era «fino a ~3x» [INFERITO]: T3 e' fuori; non e' una soglia).

### 3.2 Attese scritte prima contro misura  [FATTO: lettura §4]
| voce | attesa scritta prima | misura | esito |
|---|---|---|---|
| n totale | ~1.045, banda 820-1.275 | 1.060 | dentro |
| n per tranche | ~335 / 340 / 370 | 336 / 343 / 381 | dentro |
| PF_V totale | 0,75-1,10 | 0,918 | dentro |
| fascia asia dentro H24 | n atteso ~290, banda 240-330 (n 200-350 = smentita); PF_V banda 1,10-1,55 (~R2NOTTEM5) | n 296; PF_V 1,111 | n dentro; PF_V sul bordo basso della banda (non e' una soglia) |
| DD «fino a ~3x» R2NOTTEM5 | ~3x | 1,98x / 1,61x / 4,14x | T3 fuori |
| effetto della sequenza sulla fascia asia | «PICCOLO» (330 contro 333 simulato) | n 296 contro 303 (-7), netto 12.732 contro 37.319 | n come previsto; **il netto no** |

### 3.3 Le sei fasce orarie  [FATTO: lettura §5]
| fascia (ora server dell'ingresso) | n | PF_V | netto EUR | PF_V per tranche T1 / T2 / T3 |
|---|---:|---:|---:|---|
| asia 00-07 | 296 | 1,111 | +12.732 | 0,87 / 0,79 / 1,58 |
| europa 07-12 | 230 | 0,560 | -50.552 | 1,09 / 0,62 / 0,35 |
| pausa 12-14 | 136 | 1,131 | +6.574 | 1,05 / 1,28 / 1,09 |
| USA apertura 14-17 | 227 | 0,654 | -44.981 | 0,48 / 0,72 / 0,70 |
| USA pomeriggio 17-22 | 159 | 1,332 | +23.244 | 1,72 / 1,11 / 1,36 |
| rollover 22-24 | 12 | 3,211 | +12.910 | n 1 / 9 / 2 (sospesa, n < 100) |
Test per fascia di casa (media di r contro zero, p < 0,0083, n >= 100, stesso segno in almeno 2 tranche): **nessuna fascia distinguibile da zero** (p piu' basso: europa 0,024). Verdetto per regime: NON MISURATO (nove mesi, nessun regime di 4 tranche).

### 3.4 Notte contro resto  [FATTO: lettura §5; strumento di analisi nostro, passato dal cancello con riserve SOLO per questa lettura descrittiva (commit 3046cfab), non promosso a lettore: vedi sez. 5]
Il resto 07-24 NON e' l'unione 07-22 della prova (include le 12 operazioni di rollover). Netto notte + resto = totale (controllato nella lettura).
| | n | netto EUR | netto medio EUR | PF_V |
|---|---:|---:|---:|---:|
| notte 00-07 | 296 | +12.732 | +43 | 1,111 |
| resto 07-24 | 764 | -52.804 | -69 | 0,858 |
Per tranche, notte: T1 93 / -3.818, T2 94 / -8.603, T3 109 / +25.154; resto: T1 243 / -7.174, T2 249 / -9.761, T3 272 / -35.869.
Il PF_V dell'unione 07-22 e' **NON MISURATO** per la regola della prova (nessun lettore passato lo stampa); il netto 07-22 e' -65.714, il che implica PF_V < 1,0 (0,820 con il nostro script): descrizione, non esito.

### 3.5 Bootstrap per giorno (descrittivo)  [FATTO: lettura §7; strumento nostro passato dal cancello con riserve SOLO per questa lettura descrittiva (commit 3046cfab), non promosso a lettore; 5.000 ricampionamenti, seed 12345, giorno server dell'ingresso]
| insieme | n | PF_V | giorni | IC95 |
|---|---:|---:|---:|---|
| H24 totale | 1.060 | 0,918 | 195 | [0,742 ; 1,123] |
| H24 fascia asia | 296 | 1,111 | 165 | [0,761 ; 1,594] |
| H24 resto 07-24 | 764 | 0,858 | 194 | [0,639 ; 1,112] |
| R2NOTTEM5 (ancora) | 303 | 1,325 | 167 | [0,930 ; 1,839] |
L'IC del totale contiene 1,0 e l'intervallo S8 della REPL [0,70 ; 1,03] [FATTO: lettura §7].

## 4. Le sorprese (DESCRIZIONE: nessuna e' un verdetto)

### 4.1 Ventotto posizioni attraversano la pausa dei prezzi  [FATTO: lettura §6; strumento nostro passato dal cancello con riserve SOLO per questa lettura descrittiva (commit 3046cfab), non promosso a lettore]
Pausa giornaliera dei prezzi: la regola che abbiamo nel repo e' il buco 23:00-00:05 server fino all'08/03/2026 e 22:00-23:00 dal 09/03; e' ripresa dalla nostra errata del lotto sull'uscita, **non rimisurata sui prezzi** [FATTO: lettura §12].
| | n | PF_V | netto EUR |
|---|---:|---:|---:|
| totale H24 | 1.060 | 0,918 | -40.072 |
| **attraversano la pausa** | **28** | 13,31 | **+62.800** |
| resto, tolte le 28 (insieme SELEZIONATO su una conseguenza del trattamento: non e' la cella) | 1.032 | 0,786 | -102.871 |
- **Il «resto» e' un insieme SELEZIONATO su una conseguenza del trattamento, non e' la cella.** Le 28 esistono solo per il trattamento (con il filtro 00-07 nessuna posizione arriva alla pausa: R2NOTTEM5 ne ha 0), quindi toglierle e' una selezione: quel 0,786 NON e' il PF della cella [FATTO: lettura §6, «Cosa NON dice»]. E' un numero contabile, da non usare come PF.
- Per tranche, attraversanti: T1 6 / +2.580, T2 8 / +17.041, T3 14 / +43.179.
- Tutte le 28 sono ingressi fra le 19:35 e le 21:50, quindi stanno nella fascia «USA pomeriggio»: senza di loro quella fascia ha n 131, PF_V 0,390, netto -39.555 (con le 28: n 159, PF_V 1,332, +23.244). Contabilmente; attribuzione [NON ATTRIBUITA].
- Escono tutte dopo la riapertura (fra le 23:05 e le 01:24 server; per 3, dopo un fine settimana), con commento `sl <livello>`; la piu' grande: +18.104, il netto singolo piu' alto dell'intero lotto. Alcune durano oltre i 240 minuti dell'uscita a tempo (sez. 1): per esempio una di T1 4:29:14 e, sul fine settimana 10-12/04, una di T2 2 giorni 1:40:54 [FATTO: elenco nell'output di `analisi_m5h24.py`, archivio del lotto].
- **Quanta parte del +62.800 venga dalla pausa stessa (uscita prevista contro uscita effettiva) NON e' misurato: [NON ATTRIBUITA].** Non diciamo che siano «un artefatto del tester» (in reale posizioni cosi' esistono, con gap reali) ne' che siano un edge. Non cambia E1, che e' definito sul PF_V totale 0,918.
- La conclusione non dipende dalla finestra scelta: con la regola del repo, con il buco dei tick misurato sui giornali 2026, e con il trading fermo l'insieme e' lo stesso (28 / +62.800 / resto 0,786); con una finestra larga 22:00-00:05 in ogni data sono 41 / +74.268 / resto 0,759; i due «resto» (0,786 e 0,759) sono insiemi SELEZIONATI su una conseguenza del trattamento: non sono la cella [FATTO: lettura §6, contro-esempi alla regola].

### 4.2 Sette ingressi notturni che H24 non ha  [FATTO: lettura §5; strumento nostro passato dal cancello con riserve SOLO per questa lettura descrittiva (commit 3046cfab), non promosso a lettore; l'intestazione del file dice ancora «Bozza, NON passata dal cancello»]
- Un ingresso e' identificato da (tranche, data-ora server dell'ingresso, lato). Fra la fascia asia di H24 e R2NOTTEM5: **296 ingressi comuni su 303**; per tutti e 296 stesso prezzo e volume d'ingresso, stesso stop iniziale, stessa ora d'uscita, stesso netto al centesimo. Presenti solo in H24: 0. **Presenti solo in R2NOTTEM5: 7**, netto **+24.587** (T1 0, T2 3 / +2.278, T3 4 / +22.309).
- I 7 hanno, in H24, una posizione gia' aperta che occupa lo slot (una per volta): 3 sono posizioni che attraversano la pausa (4.1), 4 sono ingressi delle 23:10-23:35. I 7 includono i rango 1, 2 e 5 su 303 di R2NOTTEM5 per netto.
- Sorteggiando 7 operazioni a caso su 303, la probabilita' che il netto rimosso sia >= +24.587 e' 0,0001 (20.000 estrazioni, seed 777). **Non e' una rimozione casuale**; la causa comune (la stessa mossa che fa vincere la posizione serale fa vincere anche l'ingresso dopo la riapertura) e' una lettura, non dimostrata.
- Effetto: la fascia asia dentro H24 e' la stessa sequenza di R2NOTTEM5 **tranne** quei 7 ingressi, ma PF_V 1,325 -> 1,111 e netto +37.319 -> +12.732; in netto i 7 sono il 66% del netto di R2NOTTEM5. La nostra attesa scritta prima diceva «effetto piccolo» (in n lo e'; in netto no).

## 5. Limiti, e chi ha fatto cosa  [FATTO: lettura §9, §10, §12]
- **Lettore** `leggi_gba_r0.py` (SHA256 `9CD02D2A...`): PASS del nostro cancello (commit 7b4b6c53); autotest 118 controlli. Secondo la nostra lettura ha stampato le sezioni di n, costo, PF_V, DD e lato, le fasce orarie e il rumore S8. **E' la fonte "passata" dei numeri di 3.1-3.3** (l'applicazione di E1/E2/E3 e' stata fatta a mano sulla prova, controllata dal cancello). Il lettore di notte `leggi_gba_notti.py` non e' applicabile: senza filtro 00-07 non c'e' una notte da leggere.
- **Strumenti di analisi nostri, passati dal cancello con riserve SOLO per questa lettura descrittiva (commit 3046cfab), non promossi a lettori** (le sez. 3.4, 3.5, 4.1 e 4.2 poggiano su di loro): `analisi_m5h24.py` (notte contro resto, bootstrap, sorteggio dei 7), `finestre_pausa_m5h24.py` (le finestre della pausa), `gba_ingressi_comuni.py` (ingressi comuni). L'intestazione di `gba_ingressi_comuni.py` dice ancora «Bozza, NON passata dal cancello». Riserve dichiarate sul primo: la soglia del sorteggio (24587.09) e il DD di una sezione sono scritti fissi nel codice; dipende dal terzo; la copertura degli errori «mercato chiuso» e' per data e non per istante; la regola della pausa e' fissa nel codice (d'inverno non include 22:00-22:55); contiene righe morte. I numeri sono stati ricontati dal cancello con un parser indipendente [FATTO: commit 3046cfab].
- **Tre tranche del 2026 (nove mesi), in-sample**: la fascia notturna e l'ipotesi di terzi sono state lette su questi dati. Le sei tranche 2024-25 e la tranche dal 01/10/2026 NON sono in questo lotto.
- **La regola della pausa e' ripresa dal repo, non rimisurata sui prezzi.**
- **Non si legge** per regime (nove mesi), per giornata (concentrazione per giornata: NON MISURATA), ne' l'unione 07-22 (PF_V NON MISURATO per la regola della prova; il segno e' implicato dal netto -65.714: < 1,0, 0,820).
- Non dice che la notte conta, non dice che non conta, non dice che il motore e' «morto» (il certificato e' incompleto), non promuove nessuna cella.

---

## 6. Le domande (una per chiamata). Per ognuna: dato, nostra attesa, contro-esempio

**Q1 (ruolo B) -- Quale spiegazione alternativa, diversa da [N] e [R], produrrebbe gli stessi numeri, e quale numero la mostrerebbe?**
Dato che la motiva: sez. 2 (esito E1, [TF] non compatibile, [N] e [R] compatibili e non separabili con tre tranche), sez. 3.3 (fasce con segno opposto: europa 0,560, USA pomeriggio 1,332) e sez. 4.1 / 4.2 (28 posizioni attraversanti; la fascia asia di H24 non e' la stessa sequenza di R2NOTTEM5: mancano 7 ingressi per posizione gia' aperta).
Domanda: costruisci il contro-esempio. Descrivi al massimo 3 situazioni concrete, compatibili con i dati dei punti sopra, in cui **«E1: PF_V totale 0,918 con fascia asia 1,111 e resto 0,858»** nascerebbe da una causa diversa da «la notte conta» e da «il regime conta» (esempi di forma, da non copiare: il totale che mescola fasce di segno opposto; la saturazione della posizione unica che sposta quali ingressi esistono; le 28 posizioni che attraversano la pausa). Per ognuna dici quale campo o numero del pacchetto la mostrerebbe, e se il lotto, cosi' com'e', NON la puo' mostrare e quale misura servirebbe. Rispondi NON LO SO dove il pacchetto non da' il dato.
Nostra attesa [IPOTESI]: il lotto non separa [N] da [R] (lo dice la nostra lettura) e non separa nemmeno queste due da un effetto di sequenza, perche' la fascia asia dentro H24 non coincide con R2NOTTEM5. Contro-esempio nostro: un totale vicino a 0,9 puo' essere la somma di fasce di segno opposto (europa 0,560 e USA pomeriggio 1,332): E1 sul totale non dice nulla sul segno della notte da solo, e la nostra lettura infatti non lo usa cosi'. Cosa non vediamo: il pacchetto non ha la durata delle posizioni per fascia, quindi la saturazione si vede solo per i 7 ingressi persi.

**Q2 (ruolo C) -- Si puo' dire, dai dati scritti, quanta parte del +24.587 dei 7 ingressi persi e' attribuibile al caso? UN conto solo.**
Dato che la motiva: sez. 4.2. R2NOTTEM5: n 303, netto +37.319. I 7 ingressi presenti solo in R2NOTTEM5: netto +24.587 (T1 0, T2 3 / +2.278, T3 4 / +22.309), con i rango 1, 2 e 5 su 303 per netto. Il nostro sorteggio di 7 operazioni a caso su 303 da' P(netto rimosso >= +24.587) = 0,0001 (20.000 estrazioni, seed 777; strumento passato con riserve, vedi sez. 5).
Domanda (UN conto, formula e controllo di verso; la deroga dei tre conti e' revocata): dai soli dati di sez. 4.2, e' calcolabile la quota del +24.587 attribuibile al caso? Se si': scrivi formula, numeri e controllo di verso (dici in che verso deve muoversi il risultato se i 7 fossero piu' o meno concentrati nelle operazioni migliori). Se serve un dato che il pacchetto non contiene (per esempio la dispersione del netto per operazione di R2NOTTEM5), **scrivi NON LO SO e nomina il dato**: per noi e' la risposta preferita a un numero inventato.
Nostra attesa [IPOTESI]: il pacchetto non contiene la dispersione del netto per operazione, quindi un intervallo non si calcola da qui; il nostro 0,0001 risponde a un'altra domanda («7 operazioni a caso su 303»), non a «quanta parte e' caso». Contro-esempio nostro: i 7 non sono un campione casuale (mancano per costruzione, perche' H24 ha una posizione gia' aperta), quindi un sorteggio uniforme non e' il nullo del meccanismo; la «causa comune» (sez. 4.2) e' una lettura, non dimostrata.

**Q3 (ruolo B) -- Quale misura separerebbe l'effetto TF dall'effetto filtro di spread, senza creare una griglia di parametri su questo motore?**
Dato che la motiva: sez. 1 e 5 (in tutte e due le celle il filtro e' 0,05 x ATR M5: il lotto non li separa). Dal file prova [DERIVATO dai giornali archiviati]: il filtro di spread e' un multiplo dell'ATR del TF del segnale, e a M5 lo 0,05 ammette uno spread 2,4 volte piu' largo che a M1 (soglia assoluta mediana di notte 0,257 contro 0,107 USD). Un lotto nostro che voleva misurare il filtro (R2M5SOGLIA) e' stato **scartato dal nostro cancello l'11/10: non poteva produrre altro che un conteggio**. Il motore e' **NON ANCORA MISURATO** (caselle aperte: simboli gemelli, TF su piu' tranche): non lo diciamo senza edge, ma E1 dice che questa cella non e' un candidato.
Regole che valgono per la risposta [FATTO: protocollo, regole 1, 3 e 6]: niente griglie larghe su un motore GIA' DICHIARATO senza edge: questo non lo e', e su un motore NON ANCORA MISURATO si misura (regola 6); si allarga su motori, meccanismi, simboli, TF, gestione dell'uscita, e ogni allargamento si paga con una prova fuori campione o di regime (regola 6); i criteri si cambiano prima dei numeri, mai dopo (regola 1). La richiesta di UNA sola misura e non di una griglia e' una scelta nostra. Costo di riferimento [FATTO: lettura §1]: una passata 48-49 s; l'intera corsa di 3 passate, 4 minuti [FATTO: lettura §1, righe «passate» e «zip nuovo»].
Domanda: proponi **una sola misura** (asse unico, finestra, cella di controllo, attesa scritta con banda E numero dell'ipotesi alternativa, cosa la falsificherebbe, costo in passate) che separi TF e filtro, oppure dici che non esiste senza una griglia e perche'. Dici anche se la misura puo' essere letta con n >= 150 per tranche, e quale contro-esempio la romperebbe.
Nostra attesa [IPOTESI]: le due direzioni che vediamo sono (a) un secondo TF a parita' di filtro e (b) un secondo valore del filtro a parita' di TF; nessuna ha ancora attesa scritta, e (b) assomiglia al lotto scartato. Contro-esempio nostro: ogni misura sul solo 2026 (nove mesi, in-sample) puo' separare i due effetti solo in quel periodo; la tranche dal 01/10/2026 ha dieci giorni.

---

## 7. Fonti nel repo (branch `lavoro`, commit di oggi, da `git log`)
- Lettura: `report/GBA_R2_M5_24H_LETTURA_2026-10-11.md`, commit 15b93366, SHA256 `b7e37b39af9ed342d6b997f49ba051a638830756960fba898ca99bfec125a102`; PASS del cancello: commit 3046cfab.
- File prova del lotto (esiti, attese, soglie): `backtest_pipeline/prove/GBA_R2_M5H24_2026-10-11.txt`, commit dbcade67, SHA256 `4dd1d39a...`; lettore: `backtest_pipeline/leggi_gba_r0.py` (SHA256 `9CD02D2A...`, PASS commit 7b4b6c53).
- Archivio del lotto: `backtest_pipeline/risultati_archivio/GBA_R2_M5_24H_20261011/` (output del lettore e `analisi_m5h24.py` in commit 4a484d3c; `finestre_pausa_m5h24.py` e il suo output in commit e3496944, entrambi passati con riserve per questa sola lettura; il terzo strumento, `gba_ingressi_comuni.py`, sta in `backtest_pipeline/` e non nell'archivio, commit a1786c32).
- Celle di confronto: `report/GBA_R2_NOTTE_M5_LETTURA_2026-10-11.md` (R2NOTTEM5, R2NOTTEM1) e `report/GBA_R0_R1A_LETTURA_2026-10-10.md` (R1A).
- Memoria, BASE e protocollo: `docs/gemini/MEMORIA_CONDIVISA.md`, `docs/gemini/BASE_CONOSCENZA_PER_GEMINI_2026-10-04.md`, `docs/gemini/PROTOCOLLO_SQUADRA_2026-10-08.md` (la memoria e la BASE vengono mandate in testa dall'invio; il protocollo viene passato esplicitamente dall'invio).
