# Ea Nat&Cla - SPECIFICA dell'EA `EA_NatCla.mq5` (07/10/2026)

**STATO: specifica passata dal cancello il 07/10/2026 (strato 1 `controlla_riga.py --oggetto md` verde + strato 2
`controllo-preventivo`: PASS CON RISERVE, correzioni gia' applicate nel testo e marcate "corretto dal cancello").** Resta una
specifica, non codice: non autorizza a lanciare backtest ne' a toccare il VPS; il codice MQL5 che ne nascera' passa dal suo
cancello.

**Fonti delle REGOLE, e SOLO queste** (regola di Claudio: l'EA si basa solo sui file che ha mandato):
- `report/NATCLA_ANALISI_AUDIO_2026-10-06.md` (tre audio della collega, regole R1-R27, divergenze §10.1, 12 bloccanti §10.2;
  sorgenti `data/natcla/PTT-20261006-WA0090/91/92.txt`). Sigla nelle tabelle: **A-Rnn** = riga della tabella §2 dell'analisi audio.
- `report/NATCLA_ANALISI_PDF_2026-10-06.md` (PDF "Supertrend Reversal", sorgenti in `data/natcla/`). Sigla: **P-pNN** = pagina.

**Fonti delle CONVENZIONI DI CASA (struttura, NON regole di trading)** - dichiarate dove le uso, con la sigla **[CASA]**:
- `mql5/Experts/ABTG_SupertrendReversal.mq5` letto SOLO per struttura: chiamata Guardian, gruppi di input, imbuto di log,
  export per-trade, `OnTester`/OptFrame, calcolo del lotto con `OrderCalcProfit`, normalizzazione al tick size, `STOPS_LEVEL`,
  calcolo del Supertrend su HL2. **Nessuna sua regola di trading e nessun suo valore di parametro entra qui** (quell'EA ha
  trailing sul Supertrend, uscita su flip, parziale a 1R: NON sono nelle fonti Nat&Cla e NON sono in questa specifica).
- `mql5/Include/ABTG_PausaGuardian.mqh` (firma di `ABTG_GuardiaIngresso`, fail-open, buco B6 dei pendenti).
- `CLAUDE.md` (cancello del costo, emendamento della finestra, certificato di morte, centro dell'altopiano).
- Per i numeri di costo e di storico: `report/CANCELLO_COSTO_FLOTTA_2026-09-10.md`, `data/spread_vivo/`,
  `report/SCHEDE_SIMBOLO_PIANO_2026-10-05.md`, `REGISTRO_TEST.md`. Citati riga per riga dove servono.

Etichette: **[FONTE]** = scritto/detto nelle fonti (cito) · **[NOSTRA]** = operativizzazione nostra di una cosa che le fonti non
quantificano (sempre dichiarata, sempre un input) · **[CASA]** = convenzione del repo · **[MISURATO]** / **[DERIVATO]** /
**[STIMA]** / **[NON MISURATO]** come da casa.

---

## 0. SINTESI PER CLAUDIO (10 righe, senza tecnicismi)

1. Un solo EA, `EA_NatCla`, con un interruttore: **modo AUDIO** (come opera la collega a voce) o **modo PDF** (il documento "Supertrend Reversal").
2. Tutto cio' che la collega e il PDF NON dicono con un numero diventa una **manopola dichiarata**, mai una scelta nascosta: all'avvio l'EA stampa la configurazione effettiva.
3. Le taglie crescenti ("size piu' grosse", "dieci volte tanto", il 2/3 del PDF) sono **spente**: tutti gli ordini dello stesso setup hanno la stessa taglia, e il rischio TOTALE del setup e' fissato prima di entrare.
4. Il rischio per setup (0,25%) e' un **segnaposto da firmare**, non una nostra proposta. Niente martingala, niente recupero, niente griglia aperta: lo stop c'e' sempre.
5. **Una misura che pesa gia' oggi (aritmetica, non opinione)**: con i numeri letterali dell'audio (take profit 10, stop a 5-20 di distanza) **su nessuno degli 8 simboli con spread misurato la scala intera passa il cancello del costo di lavoro** (stop >= 40 x pedaggio): su EURUSD servono almeno 26,7 pip di stop, sugli indici 64-80 punti; solo sull'oro, contando 1 punto = 1 dollaro, passano i due ordini piu' lontani. Lo stop "letterale" va quindi misurato anche nella versione agganciata alla volatilita' (manopola gia' prevista).
6. Contato su un feed esterno dell'oro 2024-26 (NON BCM): il modo AUDIO su H1 fa circa **16-18 setup l'anno per linea** dopo il filtro ADX con l'**ADX standard di MT5** (quello che l'EA usa); **35-40** era il conto con la formula di Wilder, che sta piu' in basso e lascia passare il doppio *(corretto dal cancello sul codice 07/10, §5.4)*; il modo PDF su H4 circa **26 tocchi l'anno** sulla linea 3.5, prima delle conferme. Per avere 150 operazioni IS + 150 OOS sui tick veri (circa 2 anni) **bisogna sommare piu' simboli della stessa famiglia**.
7. Piano: passo 0 di solo conteggio su 36 simboli (circa 1 ora di PC [STIMA]), poi la base dei due modi sui simboli che passano il costo, poi le manopole una alla volta solo dove c'e' un motore vivo. Tutto sul **PC di backtest**, mai sul VPS.
8. Le soglie per dire "funziona" sono scritte **prima** dei numeri, ognuna con il numero che produrrebbe il caso "non c'e' niente": per esempio con 150 operazioni una strategia a caso supera PF 1,15 nell'11-13% dei casi (calcolo, §6), quindi la soglia sale.
9. Restano solo a te: **rischio e taglie**, **su quali simboli e su quale conto** andrebbe, e **se l'EA deve essere fedele alla collega o il meglio misurato** quando le due cose non coincidono.
10. Ogni risposta della collega alle 12 domande bloccanti **spegne manopole e accorcia i test** (tabella al §8).

---

## 1. TABELLA DELLE REGOLE: regola | fonte | input | valori | default | motivo del default

Convenzione dei default: **AUDIO / PDF** = valore che l'input assume quando e' lasciato su `DA_MODALITA` (vedi §2.1). Un input
impostato a mano vince sempre sulla modalita'. Le unita' "u" sono quelle di `InpUnita` (§1.5).

### 1.1 Indicatori

| # | regola | fonte (citazione) | input | valori | default AUDIO / PDF | motivo del default |
|---|---|---|---|---|---|---|
| I1 | Supertrend, periodo ATR | P-p07 *"Supertrend (10, 3.5)"*; audio: periodo **non detto** (A-R2) | `InpStAtrPeriodo` | 10 | 10 / 10 | l'unico numero nelle fonti. Nessun asse: non c'e' un secondo valore da provare |
| I2 | Supertrend, moltiplicatori | A-R2 WA0090 *"tutti i tre livelli 2.5, 3, 3.5"*; P-p04/p08 linee S/T 2.5/3.0/3.5 | `InpStMult1/2/3` | 2.5 / 3.0 / 3.5 | 2.5/3.0/3.5 | dichiarati da entrambe |
| I3 | Supertrend, calcolo | non detto da nessuna fonte (P §7 "prezzo sorgente (HL2/close)") | (fisso) | HL2 +- k x ATR, ATR = `iATR` di MT5 | - | **[NOSTRA+CASA]**: formula standard di Seban, stessa struttura del calcolo in `ABTG_SupertrendReversal.mq5` r.499-528 (copiata la STRUTTURA, non una regola). `iATR` di MT5 e' una media SEMPLICE del true range: dichiarato |
| I4 | Linee che generano setup | A-R11/R13/R14: tutte e tre operative; P-p11/p20/p25: **solo la 3.5** | `InpUsaST25`, `InpUsaST30`, `InpUsaST35` | bool | true,true,true / false,false,true | ciascuna modalita' letterale |
| I5 | Media lenta | A-R1 WA0092 *"la EMA 200"*; P-p07 *"EMA 14 - 89 - 100 - 200"* | `InpEmaLentaPeriodo` | 200, EMA su close | 200 / 200 | periodo e tipo dichiarati; il **close** come prezzo applicato e' **[NOSTRA]** (nessuna fonte lo dice) |
| I6 | EMA di target | P-p17 *"EMA 14 ... primo obiettivo ... Segue poi, la EMA 89"* | `InpEmaTp1`, `InpEmaTp2` | 14, 89 | (non usate) / 14, 89 | solo modo PDF |
| I7 | EMA 9 e 21, Bollinger | A-R4 *"la media 9 e la media 21"* (nessuna regola); A-R6 Bollinger *"per vedere in che direzione e'"*; P-p07 Bollinger "opzionali", nessun parametro | `InpLogContesto` | bool | true / true | **NON entrano in nessuna condizione**: ruolo non dichiarato. L'EA ne SCRIVE i valori nel CSV per-trade (EMA9, EMA21, larghezza Bollinger 20/2 [NOSTRA, solo per il log]) cosi' una lettura a posteriori puo' dire se separano i vincenti; trasformarli in filtro richiederebbe una regola che le fonti non danno |
| I8 | ATR di normalizzazione | nessuna fonte (P-p22 mostra un pannello ATR(14), immagine non regola) | `InpAtrNormPeriodo` | 14 | 14 / 14 | **[NOSTRA]**: unita' di misura per tutte le tolleranze "vicino/lontano" che le fonti non quantificano; 14 = valore da manuale di Wilder |

### 1.2 Direzione, timeframe, motori

| # | regola | fonte | input | valori | default AUDIO / PDF | motivo |
|---|---|---|---|---|---|---|
| D1 | Direzione | A-R26 **mai dichiarata** (letture A/B/C, §3.2 audio); P-p17 *"In posizione long ... In posizione short"* | `InpDirezione` | LONG / SHORT / ENTRAMBI | ENTRAMBI / ENTRAMBI | nei test i lati si girano **separati** (regola dei due lati di casa); ENTRAMBI e' solo il default di esercizio |
| D2 | Verso del rimbalzo | P-p20/p21 casi disegnati nel verso del Supertrend; audio: *"deve rimbalzare"* | (fisso) | long sul floor (ST sotto il prezzo), short sul ceiling | - | entrambe le fonti descrivono il rimbalzo SULLA linea, non il suo sfondamento. Una chiusura oltre la linea e' un **flip** del Supertrend: per costruzione non e' un setup |
| T1 | TF del segnale | A-R8 *"dall'H1 in su"*; A-R7 analisi H1/H4/H12/D1; P-p05/p06/p25 H4-D1-W1, esempi H1 (p08/p11) | `InpTF` | H1, H4, H12, D1, W1 | H1 / H4 | il piu' basso ammesso da ciascuna fonte (piu' operazioni = campione prima, regola di casa sui TF). L'EA **rifiuta TF sotto H1** (A-R8, A-R9 "non sotto"): `INIT_PARAMETERS_INCORRECT` |
| T2 | Analisi multi-TF | A-R7 "H1, H4, H12 e daily" senza regola di combinazione | (non codificata) | - | - | una **istanza per TF**, ognuna col suo magic. Come si combinano i TF non e' detto: non si inventa (§7) |
| M1 | Motore Supertrend | A-R20, P intero | (sempre attivo se almeno una `InpUsaSTxx`) | - | on / on | - |
| M2 | Motore "solo EMA 200" | A-R20 WA0092 *"sia solo sulla EMA 200, dall'H1 o H4 in su, non sotto, sia sul Supertrend"*; PDF: **mai** ingresso sulla sola EMA (audio §10.1) | `InpMotoreEma200`, `InpTocchiMaxEma` | bool; 0 = illimitato | false, 0 / false, 0 | e' un **secondo motore**: si misura come famiglia separata (una variabile alla volta), mai sommato alla base nel primo giro |

### 1.3 Tocco, conteggio, conferma

| # | regola | fonte | input | valori | default AUDIO / PDF | motivo |
|---|---|---|---|---|---|---|
| C1 | Definizione di tocco | A-R11 *"toccare"*; A-R13 *"violare ... e poi tornare"*; P-p06/p14/p20 *"tocca o viola ... con l'ombra"* senza chiudere oltre | `InpToccoDef` | RAGGIUNGE (low <= linea per il long) / SFIORA (low <= linea + `InpSfioraAtr` x ATR) | RAGGIUNGE / RAGGIUNGE | "tocca o viola con l'ombra" = l'estremo raggiunge o supera la linea. SFIORA (`InpSfioraAtr`=0,10 [NOSTRA]) e' l'asse per "toccare" letto largo |
| C2 | Linea di riferimento per il tocco | non detto | (fisso) | il tocco della barra i si misura contro la linea in vigore durante la barra i = valore calcolato alla chiusura della barra i-1 | - | **[NOSTRA]**: e' la linea "disegnata" nel momento del tocco; dichiarata perche' cambia di pochi punti il conteggio |
| C3 | "Violare e tornare" (2.5/3) contro "tocco e rimbalzo" (3.5) | A-R13/R14 vs A-R11; audio §3.6 "non detto" se e' lo stesso evento | (fisso) | stesso evento: estremo oltre la linea, chiusura dal lato del trend | - | una chiusura oltre la linea e' un flip (D2): "violare e tornare" con chiusura oltre non esiste come setup sulla stessa linea. Dichiarato come lettura |
| C4 | Massimo dei tocchi per linea | A-R11 3.5 *"una volta, al massimo due volte, di piu' no"*; A-R13 2.5 *"solo per la prima volta"*; A-R14 3 *"la stessa cosa"*; PDF: **nessun conteggio** (p22 disegna 1^/2^ violazione senza regola) | `InpTocchiMax25/30/35` | 0 = illimitato, 1, 2, ... | 1/1/2 / 0/0/0 | letterali. Il setup e' armabile se il tocco in arrivo e' il numero <= max |
| C5 | Episodio di tocco | non detto | (fisso) | barre consecutive che toccano = UN episodio; serve almeno una barra che non tocca per un nuovo episodio | - | **[NOSTRA]**: senza questa regola tre barre di fila sulla linea conterebbero come tre tocchi |
| C6 | Da quando si contano | A-R11 "da quando" **non detto**; audio domanda 8 | `InpResetConteggio` | AL_FLIP / AL_FLIP_O_DISTACCO (distacco >= `InpDistaccoAtr`=1,0 x ATR dalla linea azzera) | AL_FLIP / AL_FLIP | **[NOSTRA]**: il segmento di vita della linea (fra due flip) e' l'unita' naturale; il distacco e' l'asse per "il prezzo e' ripartito" |
| C7 | Chiusura vicina alla linea | P-p14/p20/p25 *"il corpo della candela chiude vicino al Supertrend"*, non quantificato; audio: non citato | `InpChiudeVicinoAtr` | 0 = spento, 0,25, 0,5, 1,0 (x ATR) | 0 / 0,5 | **[NOSTRA]** la tolleranza; 0,5 = centro dei tre valori provati |
| C8 | Conferma: la candela successiva apre "all'interno" | P-p06/p14/p20/p25 *"apre all'interno del Supertrend ... altrimenti setup invalidato"*; audio: **non citato** | `InpConfermaApertura` | bool | false / true | letterale per modalita'. "All'interno" = open dal lato del trend rispetto alla linea (P §C-6, [INFERITO] dalla fig.2 di p20) |
| C9 | Timing del tocco dentro la candela | P-p14 prima meta' valida **contro** P-p25 seconda meta' favorevole (contraddizione) | `InpTimingTocco` | IGNORA / PRIMA_META / SECONDA_META | IGNORA / IGNORA | contraddizione interna al PDF: nessun default puo' scegliere. Richiede tick (si misura solo a tick reali) |

### 1.4 Filtri di contesto

| # | regola | fonte | input | valori | default AUDIO / PDF | motivo |
|---|---|---|---|---|---|---|
| F1 | ADX massimo | A-R12 WA0090 *"deve essere a 20 non di piu' perche' se no rischia anche di sfondare"* (prima stima ritirata "20 25"); PDF: **ADX assente** | `InpAdxUsa`, `InpAdxMax` | bool; 20, 25 | on, 20 / off | 20 = valore finale dichiarato; 25 = la prima stima ritirata, unico altro numero della fonte |
| F2 | ADX periodo | **non detto** (A-R12, A-R5) | `InpAdxPeriodo` | 10, 14, 20 | 14 / 14 | **[NOSTRA]**: 14 = valore da manuale di Wilder; 10 e 20 ai lati per leggere un altopiano, non un picco |
| F3 | ADX: su quali linee | A-R12 detto **dentro** il paragrafo del 3.5; audio §4 punto 6 | `InpAdxAmbito` | SOLO_ST35 / TUTTE | SOLO_ST35 / - | letterale |
| F4 | ADX: su quale TF | non detto | (fisso) | stesso TF del segnale, barra chiusa | - | **[NOSTRA]**, dichiarata: un asse in piu' costerebbe passate senza una fonte che lo chieda |
| F5 | EMA 200 inclinata | A-R19 WA0092 *"non deve essere dritta, ma deve essere abbastanza inclinata"*; soglia e verso **non detti**; PDF: assente | `InpInclUsa`, `InpInclBarre`, `InpInclMinAtr`, `InpInclVerso` | bool; 20 barre; soglia in ATR (valori dal passo 0); QUALSIASI / CONCORDE | on, 20, 0, QUALSIASI / off | **[NOSTRA] la misura**: `incl = abs(EMA200[1] - EMA200[1+N]) / ATR14[1]`, N = 20 barre. Contro-esempio della misura: una EMA piatta in laterale da' ~0, una EMA in trend da' valori crescenti con la distanza prezzo-EMA. Sull'oro H1 2024-26 (feed HistData, NON BCM) la misura vale P25 0,34 · P50 0,69 · P75 1,18 · P90 1,70 [MISURATO]; su H4 0,38 / 0,78 / 1,23 / 1,68. **Quei numeri NON sono la soglia**: l'oro 2024-26 e' un toro, il forex in laterale stara' piu' in basso. Le tre soglie dell'asse si fissano ai **P25/P50/P75 della famiglia sul passo 0, prima di qualunque P/L**. Il default compilato `InpInclMinAtr`=0 e' un **no-op dichiarato** (il filtro lascia passare tutto) finche' il preset di F1 non porta il P50: l'EA lo scrive a log all'avvio. Verso: QUALSIASI e' letterale ("inclinata"), CONCORDE (su per il long) e' l'asse |
| F6 | Confluenza con la EMA 200 | A-R16 *"se c'e' la confluenza di media 200 ... sulla stessa altezza ... entro con le size ancora piu' grosse"* (bonus di TAGLIA); P-p21 *"condizione sine qua non ... Se assente, e' consigliabile evitare"* (con S/R, Fibo, EMA200) | `InpConfluenza`, `InpConflTolAtr` | SPENTA / SOLO_ETICHETTA / OBBLIGATORIA; 0,25, 0,5, 1,0 (x ATR) | SOLO_ETICHETTA / OBBLIGATORIA; 0,5 | AUDIO: la confluenza cambia solo la taglia, che e' bandiera spenta (§4): resta **un'etichetta nel CSV**, non un filtro. PDF: obbligatoria, ma **solo la EMA 200 e' meccanizzabile** (Fibo, S/R "Larry Williams", pivot non sono definiti: §7). Tolleranza `abs(linea - EMA200) <= k x ATR` **[NOSTRA]** |
| F7 | Spread massimo | non nelle fonti | `InpMaxSpreadPunti` | 0 = spento | 0 / 0 | **[CASA]** (stesso input di tutti gli EA). Spento: il costo si misura (§5.3), non si filtra di nascosto |

### 1.5 Ingresso, ordini, unita'

| # | regola | fonte | input | valori | default AUDIO / PDF | motivo |
|---|---|---|---|---|---|---|
| U1 | Pip o punti | A-R22 WA0091 *"10 pip"* contro WA0092 *"10 punti"*; P "pip" ovunque (p17/p21/p26) | `InpUnita` | AUTO_CLASSE / PIP / PUNTO_PREZZO / PUNTO_MT5 | AUTO_CLASSE | **[NOSTRA]** AUTO_CLASSE: forex = pip (0,0001; 0,01 sui JPY); indici = 1,0 punto indice; oro/argento = 1,0 USD. PUNTO_MT5 (`_Point`) e' tenuto come asse ma e' **escluso per aritmetica** su tutti i simboli misurati (§5.3): 10 punti MT5 su EURUSD = 1 pip di TP. Sull'oro l'asse vero e' 0,1 contro 1,0 USD |
| E1 | Tipo di ingresso | A-R21 WA0092 tre ordini a scala; P-p17/p26 *"1/3 ... a mercato ... 2/3 ... pendente +-20 pips"* | `InpTipoIngresso` | SCALA3_PENDENTI / MERCATO_PIU_PENDENTE | SCALA3 / MERCATO_PIU_PENDENTE | letterali |
| E2 | Scala AUDIO: posizione degli ordini | A-R21 *"5/10 punti sotto ... proprio sulla EMA o sul Supertrend ... un'altra leggermente sopra, di 5 punti"*; letture A/B in audio §3.2 | `InpScalaAnticipo`, `InpScalaOltre` | coppie (5,5), (10,5), (5,10) | (5,5) / - | **[NOSTRA] la normalizzazione**: tre ordini LIMIT = uno ad "anticipo" u PRIMA della linea (lato da cui arriva il prezzo), uno SULLA linea, uno "oltre" u DOPO la linea. Lettura B (short, specchio per il long): anticipo = "5/10 sotto", oltre = "5 sopra" -> (5,5) o (10,5). Lettura A (long letterale): anticipo = "5 sopra", oltre = "5/10 sotto" -> (5,5) o (5,10). Le tre coppie coprono entrambe le letture senza sceglierne una; (5,5) e' comune alle due e fa da base |
| E3 | Scala AUDIO: quando si piazza | A-R24 *"a volte dura anche qualche secondo"*; audio §4 punto 4 (ordini gia' piazzati?) | (fisso nel modo SCALA3) | ordini LIMIT armati in anticipo e riprezzati a ogni barra chiusa sulla nuova linea | - | **[NOSTRA]** dedotta da "qualche secondo" + "le size le metto ... sulla EMA o sul Supertrend": il tocco E' il riempimento. Dichiarato; e' il punto piu' forte da far confermare (bloccante 5-6) |
| E4 | PDF: secondo ordine | P-p17 *"2/3 rimanente su ordine pendente +-20 pips"*; P-p21 fig.4 pendente oltre la linea; P-p11 immagine ~10 pip | `InpPdfDistanzaSecondo` | 20, 10 (u) | - / 20 | 20 = testo (tre pagine); 10 = immagine p11 (lettura visiva approssimata) |
| E5 | PDF: apertura "lontana" dalla linea | P-p21 *"Se invece il prezzo apre lontano dal supertrend si posizionano due ordini pendenti"*; "lontano" non quantificato; primo pendente: posizione non detta (P §F-15) | `InpPdfAperturaLontana`, `InpPdfLontanoAtr` | SALTA / DUE_PENDENTI; 0,5 x ATR | - / SALTA, 0,5 | **[NOSTRA]** SALTA come base: il ramo DUE_PENDENTI richiede di inventare dove sta il primo ordine (sulla linea, dichiarato se acceso) |
| E6 | Scadenza dei pendenti PDF | non detta (P §7) | `InpScadenzaBarre` | 1 | - / 1 | **[NOSTRA]** una barra del TF del segnale |
| E7 | Setup contemporanei | non detto; audio bandiera B8 (3 ordini x 3 linee x piu' TF) | `InpMaxSetupAperti` | 1, 3 | 1 / 1 | **[NOSTRA]** prudente: un setup alla volta per istanza; quando un setup riempie, gli ordini armati delle altre linee si cancellano. 3 = asse di rischio, solo su motore vivo |

### 1.6 Taglia e rischio (bandiere: §4)

| # | regola | fonte | input | valori | default | motivo |
|---|---|---|---|---|---|---|
| S1 | Rischio del setup | **nessuna fonte**: audio R27 assente; P-p11/p12 *"come da money management"* | `InpRischioSetupPct` | % del saldo, TOTALE di tutti gli ordini del setup | **0,25** | **SEGNAPOSTO del progetto Nat&Cla, da firmare da Claudio.** Non e' una scelta nostra; serve solo a far girare il tester. I risultati si leggono in **multipli di R** cosi' non dipendono da questo numero |
| S2 | Pesi della scala AUDIO | A-R21 *"prima size un po' leggera, poi l'altra un po' piu' pesante"* (terza non detta) | `InpPesiScala` | "1:1:1", "1:2:1" | "1:1:1" | **bandiera B1 SPENTA**; "1:2:1" e' l'unica lettura numerica minima (leggera < pesante, terza = leggera [NOSTRA]) e si misura a parte, **a parita' di rischio totale** |
| S3 | Pesi PDF | P-p10/p11/p17/p26 1/3 + 2/3 | `InpPesiPdf` | "1:1", "1:2" | "1:1" | **bandiera SPENTA** come da mandato; "1:2" misurato a parte, a parita' di rischio totale |
| S4 | Confluenza = taglia piu' grossa | A-R16 | `InpMoltConfluenza` | 1,0 | 1,0 | **bandiera B3 SPENTA**. Un valore > 1 alza il rischio: l'EA lo tronca a `InpRischioMaxSetupPct` (default = `InpRischioSetupPct`), quindi **senza una firma non puo' alzare niente** |
| S5 | "Dieci volte tanto" | A-R17 *"non so, dieci volte tanto"* | **nessun input** | - | - | **non implementato** (§7): oggetto incerto, la collega stessa dice "non so" |

### 1.7 Stop e uscite

| # | regola | fonte | input | valori | default AUDIO / PDF | motivo |
|---|---|---|---|---|---|---|
| X1 | Criterio di stop | A-R23 WA0091 *"leggermente sopra qualche resistenza, se c'e'"* (nessun numero); P-p17/p26 *"sotto il minimo recente o il Supertrend"*; P-p21 fig.4 *"STOP LOSS a 5 PIP 2 Ordine pendente"*; P-p18 livelli/multipivot. **Quattro criteri, nessuna priorita'** (P §C-10) | `InpSLCriterio` | ORDINE_PROFONDO_PIU_BUFFER / ESTREMO_RECENTE / LINEA_PIU_BUFFER | ORDINE_PROFONDO / ESTREMO_RECENTE | **[NOSTRA] l'operativizzazione dell'audio**: la "resistenza" e' la linea su cui si opera e lo stop sta "leggermente" oltre l'ordine piu' profondo. **"Leggermente" = 5 u e' preso dalla collega stessa**: in WA0092 dice *"un'altra leggermente sopra, di 5 punti"*, cioe' usa "leggermente" per 5. "Se c'e'": se non c'e' altra resistenza vale lo stesso criterio (mai stop assente). PDF: il primo criterio scritto (p17, e risposta C del quiz p29 Q4); "livelli tecnici/multipivot" non meccanizzabili (§7) |
| X2 | Buffer dello stop | AUDIO: **nessun numero per lo stop** (A-R23); il "5" di WA0092 e' la posizione di un ORDINE, non dello stop. PDF: p21 fig.4 "STOP LOSS a 5 PIP" (scritta in figura, non nel testo) | `InpSLBuffer` | 5 u | 5 / 5 | PDF: dalla figura. AUDIO: **[NOSTRA]**, trasferimento del "leggermente = 5" dall'ordine allo stop (X1): e' una nostra lettura, NON una cifra detta dalla collega per lo stop *(corretto dal cancello 07/10: la v1 diceva "stessa cifra in entrambe le fonti")* |
| X3 | "Minimo recente" | P-p17 non quantificato | `InpSLEstremoBarre` | 3 | 3 / 3 | **[NOSTRA]**: barra del tocco + due precedenti |
| X4 | Stop comune e vincoli | P-p21 fig.4 stop comune; audio: non detto | (fisso) | UNO stop per tutto il setup; mai piu' vicino dell'ordine piu' profondo + buffer; mai dentro `SYMBOL_TRADE_STOPS_LEVEL` | - | stop comune = rischio totale noto prima di entrare (attenua B1). Se lo stop non e' calcolabile o viola i vincoli -> **setup scartato e contato nell'imbuto, mai aperto senza stop** |
| X5 | Take profit | A-R22 WA0091 *"10 pip"*, WA0092 *"10 punti dal Supertrend o EMA"*; P-p17 EMA14 poi EMA89, livelli superiori | `InpTPCriterio`, `InpTPDistanza` | FISSO_DALLA_LINEA / FISSO_DAL_RIEMPIMENTO / EMA14_POI_EMA89; 10 u | DALLA_LINEA, 10 / EMA14_POI_EMA89 | AUDIO letterale WA0092 ("dal Supertrend o EMA"); DAL_RIEMPIMENTO e' l'asse (audio §3.4). Nota letta in audio §3.2: con l'anticipo a 10 e TP a 10 dalla linea, l'ordine d'anticipo avrebbe TP a distanza 0 -> l'EA **non piazza** un ordine il cui TP non e' oltre il suo prezzo d'ingresso di almeno 1 u (contato nell'imbuto) |
| X6 | PDF: target dal lato giusto | P-p17 EMA14 / EMA89 | (fisso) | TP1 = EMA14 al momento dell'ingresso se sta dal lato del profitto; TP finale = EMA89 se dal lato del profitto e oltre TP1, altrimenti `InpRRMin` x rischio | - | **[NOSTRA]** il "congelamento" del target all'ingresso e il ripiego in R: senza, un'EMA dal lato sbagliato darebbe un TP in perdita |
| X7 | PDF: R/R minimo | P-p17 *">= 1:1"* contro P-p26 *">= 1:2"* | `InpRRMin` | 1,0, 2,0 | 0 (spento) / 1,0 | contraddizione: 1,0 e' il valore meno restrittivo, 2,0 l'asse. Nessuna preferenza |
| X8 | PDF: parziale e pareggio al primo obiettivo | P-p17 *"posso ridurre la size e portare lo stop in pari"*; p18, p26 BE | `InpParzialeTP1Pct`, `InpBEalTP1` | 0, 50; bool | 0, false / 0, true | "posso" = facoltativo: 0 base, 50 asse. BE al **prezzo medio ponderato** dei riempimenti [NOSTRA] (P §F-21) |
| X9 | Durata massima | A-R24 *"dura al massimo ... penso, un'oretta, neanche"* (osservazione, non regola) | `InpDurataMaxMin` | 0, 60 | 0 / 0 | e' un'osservazione: spenta in base, **asse di uscita** (serve anche al certificato di morte, casella 3) |
| X10 | Dopo il primo TP / dopo lo stop | non detto | (fisso) | al primo TP o allo stop del setup si cancellano i pendenti residui dello stesso setup; nessun riarmo sullo stesso episodio di tocco | - | **[NOSTRA]** e **anti-griglia**: impedisce che un ordine orfano entri dopo che il setup e' chiuso |

### 1.8 Convenzioni di casa (non regole di trading)

| input | default | da dove |
|---|---|---|
| `InpUsaGuardian` | true | **[CASA]** `ABTG_SupertrendReversal.mq5` r.32-44, firme B1/C1 del 18/08 (§2.5) |
| `InpMagic` | dal preset, blocco proposto **778600-778699** | **[CASA]** schema: `7786` + cifra motore (0 AUDIO, 1 PDF, 2 EMA200) + cifra TF (1 H1, 4 H4, 2 H12, 8 D1): es. 778601 = AUDIO H1, 778614 = PDF H4, 778624 = EMA200 H4. **Blocco verificato libero oggi** in `mql5/Experts/*.mq5` (nessun `InpMagic` 7786xx) e in tutto il repo fuori da `.claude/` (l'unico `778603` trovato e' un frammento di hash in un log). **Ricontrollato dal cancello il 07/10**: zero occorrenze di `7786xx` come numero intero in tutti i file del repo e su **tutti i 23 rami** locali e remoti (`git grep`), preset compresi; restano da ricontrollare i **preset vivi sui terminali** (non sono nel repo) prima della compilazione |
| `InpComment` | "NATCLA" + suffisso linea/ordine nel commento dell'ordine (es. `NATCLA_A_ST35_O2`) | [CASA] + attribuzione per-trade |
| `InpLogImbuto` | true | **[CASA]** imbuto di mortalita' dell'11/09 (r.111-198 del riferimento): contatori di rifiuto, solo log |
| `InpVerbose` | true | [CASA] |
| `InpSoloConta` | false | **[NOSTRA]** modalita' sonda per il passo 0: valuta tutto, scrive i setup nel CSV, **non manda ordini** |
| `InpPlaceboAtr` | 0 | **[NOSTRA]** strumento di misura (§6, E7): sposta ogni linea di k x ATR verso il prezzo. **Fuori dal tester l'EA rifiuta di partire se e' diverso da 0** |

---

## 2. LOGICA DELL'EA A STATI

### 2.1 Risoluzione della configurazione (OnInit)

Ogni input "ambiguo" ha un valore `DA_MODALITA` (default). In `OnInit` l'EA:
1. risolve ogni `DA_MODALITA` con la colonna AUDIO o PDF del §1;
2. **stampa nel Giornale e scrive in testa al CSV la CONFIGURAZIONE EFFETTIVA** (una riga per input, con l'etichetta
   `[FONTE]`/`[NOSTRA]`): nessuna scelta resta nascosta, e un report del tester si puo' sempre ricondurre ai valori veri;
3. rifiuta l'avvio (`INIT_PARAMETERS_INCORRECT`) se: `InpTF` < H1 (A-R8/R9); `InpPlaceboAtr` != 0 fuori dal tester;
   `InpRischioSetupPct` <= 0; `InpMoltConfluenza` x rischio > `InpRischioMaxSetupPct` (il troncamento e' dichiarato a log);
4. crea gli handle (`iATR` x2, `iMA` EMA200/14/89/9/21, `iADX`, `iBands` solo se `InpLogContesto`) e li rilascia in
   `OnDeinit` **[CASA]**. `iADX` = l'indicatore che MT5 chiama "ADX" (formula MetaQuotes), **non** `iADXWilder`: e' il default
   **per ASSUNZIONE [NOSTRA]** (l'audio dice solo "ADX a 20, non di piu'": ne' piattaforma, ne' formula, ne' periodo; vedi §5.4,
   motivazione riscritta dalla terza lettura 07/10); Wilder e' l'asse `InpAdxTipo` (A5).
   *(Precisato dal cancello sul codice 07/10: le due formule danno frequenze diverse di 2-10 volte, §5.4.)*

### 2.2 Le macchine a stati

Una macchina **per linea** L in {ST2.5, ST3.0, ST3.5, EMA200} (solo quelle attive), piu' un **semaforo di istanza**
(`InpMaxSetupAperti`). Tutto il segnale si valuta **a barra chiusa** (`OnNewBar`); gli ordini vivono sui tick.

```text
STATI DI UNA LINEA L
  INERTE ............ contesto non valido (filtri falliti, linea non calcolabile, conteggio esaurito)
  ARMATO ............ [solo SCALA3_PENDENTI] tre limit vivi attorno alla linea, riprezzati a ogni barra
  ATTESA_CONFERMA ... [solo MERCATO_PIU_PENDENTE] tocco valido sulla barra appena chiusa, si aspetta l'open successivo
  IN_POSIZIONE ...... almeno un ordine del setup riempito
  CHIUSO ............ setup finito (TP, SL, tempo): si aggiorna il contatore, nessun riarmo sullo stesso episodio

TRANSIZIONI
  INERTE -> ARMATO            OnNewBar: ContestoOk(L) && ToccoNumeroProssimo(L) <= MaxTocchi(L) && semaforo libero
  ARMATO -> ARMATO            OnNewBar: riprezza i tre limit sulla nuova linea (OrderModify; se FREEZE/STOPS lo vietano: cancella e riarma)
  ARMATO -> INERTE            OnNewBar: ContestoOk(L) falso, flip della linea, conteggio esaurito -> cancella i limit
  ARMATO -> IN_POSIZIONE      OnTradeTransaction: riempimento di un limit del setup -> cancella i limit delle ALTRE linee (semaforo)
  INERTE -> ATTESA_CONFERMA   OnNewBar (barra i chiusa): ToccoValido(L,i) && ChiudeVicino && ContestoOk(L) && conteggio ok
  ATTESA_CONFERMA -> IN_POSIZIONE  primo tick della barra i+1: open dal lato giusto (se InpConfermaApertura) -> mercato + pendente
  ATTESA_CONFERMA -> INERTE   open fuori (setup invalidato, P-p14/p20) oppure apertura "lontana" con SALTA
  IN_POSIZIONE -> CHIUSO      TP/SL del setup, durata massima, oppure tutti gli ordini scaduti senza riempimento
  CHIUSO -> INERTE            alla prima barra che NON tocca la linea (fine episodio, C5)
  qualunque -> INERTE          flip della linea: azzera il contatore (AL_FLIP) e cancella i pendenti NON riempiti
```

### 2.3 Pseudocodice

```text
OnNewBar():
  ImbutoGiro()                                     // [CASA] riepilogo giornaliero dei rifiuti
  per ogni linea L attiva:
     calcola linea[1], linea[2], dir[1], dir[2]    // Supertrend su HL2 con iATR(10); EMA200 per il motore M2
     se dir[1] != dir[2]: Flip(L); continue        // flip = nuovo segmento, contatore a 0, pendenti cancellati
     tocco = ToccoValido(L, barra 1)               // C1-C3: estremo raggiunge linea[2], chiusura dal lato del trend
     AggiornaEpisodi(L, tocco)                     // C5, C6
     se InpSoloConta: ScriviSetupCSV(L, ...) ; continue   // passo 0: niente ordini
     se stato(L)==ARMATO e !ContestoOk(L): CancellaLimit(L); stato=INERTE; conta rifiuto
     se stato(L)==INERTE:
        se modo SCALA3 e ContestoOk(L) e ProssimoTocco(L) <= MaxTocchi(L) e Semaforo(): ArmaScala(L)
        se modo MERCATO_PIU_PENDENTE e tocco e ChiudeVicino(L) e ContestoOk(L) e conteggio ok: stato=ATTESA_CONFERMA

ContestoOk(L):
  lato coerente con InpDirezione                   // D1
  ADX: se InpAdxUsa e (Ambito==TUTTE o L==ST3.5): ADX[1] <= InpAdxMax
  Inclinazione: se InpInclUsa: abs(EMA200[1]-EMA200[1+N])/ATR14[1] >= soglia (e verso concorde se CONCORDE)
  Confluenza: se OBBLIGATORIA: abs(linea[1]-EMA200[1]) <= k*ATR14[1]   (se SOLO_ETICHETTA: si scrive e basta)
  spread: se InpMaxSpreadPunti>0
  ritorna vero solo se tutti passano; il PRIMO che fallisce incrementa il suo contatore d'imbuto

ArmaScala(L):                                       // modo AUDIO (E2, E3)
  livelli = [linea + s*anticipo, linea, linea - s*oltre]   // s = +1 long (ordini sopra/su/sotto il floor), -1 short (specchio)
  SL = PrezzoStop(L, livelli)                       // X1-X4: comune, oltre l'ordine piu' profondo + buffer
  TP_i = linea + s*10u (DALLA_LINEA) oppure livello_i + s*10u (DAL_RIEMPIMENTO)
  scarta l'ordine i se TP_i non e' oltre livello_i di almeno 1u (X5) o se livello_i viola STOPS_LEVEL
  lotti = Lotto(R_setup, pesi, distanze livello_i->SL)  // stesso lotto per tutti se pesi 1:1:1 (S1-S2, sez. 2.4)
  per ogni ordine i rimasto:
     se !ABTG_GuardiaIngresso(InpUsaGuardian,"EA_NatCla"): conta cO_guardian; non inviare   // sez. 2.5
     BuyLimit/SellLimit(lotto, livello_i, SL, TP_i, commento "NATCLA_A_<L>_O<i>"); controlla retcode, logga il rifiuto

ConfermaPDF(L) al primo tick della nuova barra:     // modo PDF (C8, E1, E4, E5)
  se InpConfermaApertura e open non e' dal lato del trend rispetto a linea[1]: INERTE (invalidato), conta
  dist = abs(open - linea[1]) / ATR14
  se dist > InpPdfLontanoAtr: SALTA (default) oppure due limit [linea, linea - s*dist2]
  altrimenti: ordine a mercato + limit a s*InpPdfDistanzaSecondo OLTRE il primo ingresso (verso la linea, P-p21 fig.4)
  SL = PrezzoStop; TP1 = EMA14 congelata, TP finale = EMA89 o InpRRMin*R (X6); filtro R/R minimo (X7)
  stessa Guardia immediatamente prima di OGNI invio; il pendente scade dopo InpScadenzaBarre barre

OnTick():
  GestisciPosizioni():  BE/parziale al TP1 (PDF), durata massima (X9), cancellazione dei residui al primo TP o allo SL (X10)
  [il segnale NON si rivaluta sui tick: solo gestione]

OnTester():  ExportTrades esteso (sez. 2.6) + statistiche OptFrame                                   // [CASA]
```

### 2.4 Il calcolo del lotto (rischio del setup fissato PRIMA di entrare)

- Con stop comune e pesi w_i, il lotto base `b` si sceglie perche' **se TUTTI gli ordini si riempiono** la perdita allo stop sia
  esattamente `R_setup`: `b = R_setup / sum_i( w_i x PerditaPerLotto(d_i) )`, con `d_i` = distanza ingresso_i -> SL.
  Ordine i = `w_i x b`. Con pesi 1:1:1 tutti gli ordini hanno **lo stesso lotto** (mandato: "stessa size per tutti").
- `PerditaPerLotto` con `OrderCalcProfit` e ripiego sul tick value **[CASA]** (riferimento r.543-565, lezione 08/08 sul 225JPY).
- **Arrotondamento SEMPRE per difetto allo step**; se un ordine scende sotto `SYMBOL_VOLUME_MIN` **si scarta quell'ordine** (contato
  nell'imbuto). **Qui NON copio la convenzione del riferimento** (r.571 `MathMax(mn, ...)` arrotonda al lotto minimo, cioe' alza il
  rischio in silenzio sui conti piccoli): deviazione dichiarata, in senso prudente.
- Il rischio non dipende mai dal P/L passato (niente martingala): legge solo il **saldo** e `R_setup`.

### 2.5 Guardian di casa: come e dove

- `#include <ABTG_PausaGuardian.mqh>` e `input bool InpUsaGuardian = true;` **[CASA]**, testo del commento copiato dal riferimento
  r.33-44 (firme B1 pausa giornaliera e C1 cap rischio aperto del 18/08).
- Chiamata `ABTG_GuardiaIngresso(InpUsaGuardian,"EA_NatCla")` **immediatamente prima di ogni invio di APERTURA** (mercato E
  ciascun pendente), **mai in cima all'imbuto** e mai sulle chiusure: regola scritta nella libreria stessa (`ABTG_PausaGuardian.mqh`
  r.57-66), perche' altrimenti la macchina a stati non registrerebbe il tocco e l'EA entrerebbe dopo su un livello vecchio.
  Argomenti in coda lasciati al default neutro (P1/S1/P0/C2 spenti), come le chiamate della flotta.
- **Avvertenza fail-open nel tester, da scrivere in ogni referto di backtest**: nello Strategy Tester le GlobalVariable del
  Guardian non esistono, quindi la guardia **lascia passare tutto** (libreria r.1517-1520: input spento / canale inesistente /
  battito vecchio = passa). I backtest misurano l'EA **senza** pausa B1 e senza cap C1: e' voluto (confrontabilita'), ma vuol dire
  che il DD del tester **non** e' ridotto dal Guardian.
- **Avvertenza specifica di QUESTO EA (buco B6)**: C1 somma solo **posizioni con SL**; i pendenti non si contano
  (`ABTG_Guardian.mq5` r.90-93) e un pendente piazzato a cap libero **scatta lo stesso** dopo (libreria r.49-52). Con la scala
  AUDIO il rischio vive per lo piu' in pendenti: la guardia vede il setup solo mentre si riempie. Mitigazioni gia' dentro l'EA:
  `R_setup` fisso per costruzione (2.4) e `InpMaxSetupAperti`=1. Il tetto P0 per simbolo/lato **conta anche i pendenti** ma e'
  spento di default in tutta la flotta: accenderlo e' una decisione di rischio (firma), non di questa specifica.
- Ricordo da `CLAUDE.md` (12/09): una sedia che gira su un conto **senza** Guardian e' fail-open in campo. Prima di schierare,
  il binario compilato deve contenere `InpUsaGuardian` (verificabile) e il conto deve avere il Guardian vivo.

### 2.6 Log e CSV per-trade (servono alle attese del §6)

Oltre all'export di casa (`abtg_trades_<EA>_<simbolo>_<magic>.csv`, cartella comune **[CASA]**), un CSV `natcla_setup_...` con
una riga per setup (anche in `InpSoloConta`): ora apertura barra, linea, lato, numero del tocco nel segmento, ADX, inclinazione,
distanza linea-EMA200 in ATR, etichetta confluenza, ordini piazzati/riempiti, prezzi, SL, TP, **stop/pedaggio per ordine**
(spread al momento + commissione), EMA9, EMA21, larghezza Bollinger, esito in R, durata in minuti, motivo di chiusura. E' cio' che
permette di dividere i risultati per lato, linea e numero di tocco **senza** girare passate in piu'.

---

## 3. LE AMBIGUITA' COME ASSI, E QUANTO COSTANO

Regole di casa applicate: **una variabile alla volta** contro la base della propria modalita'; si apre un asse **solo** dove la
base non e' gia' morta con certificato; **mai griglie incrociate** nel primo giro. Unita' di costo: **passate** = celle x 2 lati
x 2 TF, **per simbolo** (la regola dei due lati di casa si applica a tutti i simboli, non solo agli indici).

### 3.1 Assi del modo AUDIO (base: tutte e tre le linee, 1/1/2 tocchi, ADX14 <= 20 solo sul 3.5, inclinazione P50, scala (5,5), stop ordine profondo + 5, TP 10 dalla linea)

| asse | ambiguita' (fonte) | valori | celle oltre la base | passate/simbolo |
|---|---|---|---:|---:|
| A1 ancora del TP | audio §3.4 | DALLA_LINEA / DAL_RIEMPIMENTO | 1 | 4 |
| A2 scala | audio §3.2 + "5/10" | (5,5) / (10,5) / (5,10) | 2 | 8 |
| A3 definizione di tocco | audio Q7 | RAGGIUNGE / SFIORA | 1 | 4 |
| A4 conteggio | audio Q8 | letterale / illimitato; reset AL_FLIP / DISTACCO | 2 | 8 |
| A5 ADX | A-R12 | spento; periodo 10; periodo 20; soglia 25; ambito TUTTE; formula Wilder (`InpAdxTipo`, aggiunta dal cancello 07/10) | 6 | 24 |
| A6 inclinazione EMA200 | A-R19 | spenta; P25; P75; verso CONCORDE | 4 | 16 |
| A7 linee | A-R11/13/14 | solo 2.5 / solo 3.0 / solo 3.5 | 3 | 12 |
| A8 stop | A-R23 | ESTREMO_RECENTE + 5 | 1 | 4 |
| A9 durata | A-R24 | 60 min | 1 | 4 |
| A10 unita' (solo oro) | audio §3.3 | 0,1 USD contro 1,0 USD | 0 (aritmetica, §5.3) | 0 |
| **Totale AUDIO** | | | **21** | **84** |

### 3.2 Assi del modo PDF (base: solo 3.5, conferma on, chiude vicino 0,5 ATR, confluenza EMA200 obbligatoria 0,5 ATR, mercato + limit a 20, stop estremo recente, TP EMA14/EMA89, R/R 1, BE al TP1, parziale 0)

| asse | ambiguita' (fonte) | valori | celle oltre la base | passate/simbolo |
|---|---|---|---:|---:|
| P1 conferma | P-p06 vs audio | off | 1 | 4 |
| P2 chiude vicino | P-p14 "vicino" | 0,25 / 1,0 | 2 | 8 |
| P3 confluenza | P-p21 vs audio | spenta; tolleranza 0,25 / 1,0 | 3 | 12 |
| P4 secondo ordine | P §C-3 | 10 invece di 20; ramo DUE_PENDENTI | 2 | 8 |
| P5 stop | P §C-10 | LINEA + 5; ORDINE_PROFONDO + 5 (fig.4) | 2 | 8 |
| P6 uscite | P §C-2, p17 | R/R 2; parziale 50 | 2 | 8 |
| P7 timing | P §C-1 | PRIMA_META / SECONDA_META | 2 | 8 |
| P8 durata | (asse di uscita) | 60 min | 1 | 4 |
| **Totale PDF** | | | **15** | **60** |

### 3.3 Motore EMA200 (M2) e bandiere di taglia

| famiglia | celle | passate/simbolo |
|---|---:|---:|
| M2 base (scala AUDIO sulla EMA200, inclinazione P50, nessun limite di tocchi) | 1 | 4 |
| M2 assi: tocco, inclinazione P25/P75/CONCORDE, TP dal riempimento, scala 2 varianti, stop, durata | 9 | 36 |
| Bandiera S2 pesi 1:2:1 (AUDIO) e S3 1:2 (PDF), **a parita' di rischio totale** | 2 | 8 |
| Placebo (E7): linea spostata di 1 x ATR, una per modalita' | 2 | 8 |

### 3.4 Totale e costo

- **Base (fase 1)**: 3 famiglie x 2 lati x 2 TF = **12 passate per simbolo**.
- **Assi completi (fase 2)**: 84 + 60 + 36 + 8 + 8 = **196 passate per simbolo** *(192 -> 196 il 07/10: cella Wilder in A5)*, ma **solo** sui simboli dove la base della
  famiglia non e' morta. Se la collega risponde alle bloccanti, il totale scende (tabella §8). *(Corretto dal cancello 07/10: la
  v1 sommava 40 per M2, cioe' anche le 4 passate della sua base, gia' contate nelle 12 della fase 1: 196 -> 192.)*
- Costo per passata a tick reali, ancore **misurate** in casa: 0,083 min/passata (R88a, tick M5, 21 mesi) - 0,333 min/passata
  (R245, 84 passate in 28 min); 20,1 s/passata Dow M5 (R202A). Il forex ha volumi di tick diversi dal Dow: banda larga.
  -> fase 2 su 5 simboli = 980 passate = **1,4-5,4 ore di PC** **[STIMA]** (980 x 0,083-0,333 min); base su 15 simboli = 180 passate = **15-60 min** **[STIMA]**.

---

## 4. BANDIERE ROSSE E COME SONO GESTITE

| # | bandiera (fonte) | gestione nell'EA | resta da decidere a |
|---|---|---|---|
| B1 | Scala con taglie crescenti sui riempimenti avversi (A §5 B1; P §D 2/3 contro il movimento) | pesi **1:1:1 / 1:1** di default; **stop comune**: `R_setup` e' la perdita se TUTTI gli ordini si riempiono, fissata prima di entrare; i pesi alternativi si misurano **a parita' di R** | Claudio, se mai si volessero accendere |
| B2 | "Dieci volte tanto" (A-R17) | **non implementato** | Claudio + collega (cosa vuol dire) |
| B3 | Taglia per convinzione con confluenza (A-R16) | `InpMoltConfluenza`=1,0; un valore > 1 e' troncato a `InpRischioMaxSetupPct` | Claudio (firma su un rischio piu' alto) |
| B4 | Stop non definito (A-R23) | criterio dichiarato e **sempre presente**; setup scartato se lo stop non e' calcolabile; **mai un ordine senza SL** | collega (numero vero) |
| B5 | R/R ignoto, TP piccolo contro stop largo | R/R scritto per ogni ordine nel CSV; nel modo PDF filtro R/R minimo | misura (§6 E3) |
| B6 | Cancello del costo | misurato per simbolo e per ordine (§5.3); nessun filtro nascosto | misura |
| B7 | Operazioni di pochi secondi | merito **solo** a tick reali; le barre possono solo bocciare | misura |
| B8 | Rischio aggregato (3 ordini x 3 linee x piu' TF) | `InpMaxSetupAperti`=1; Guardian C1 (con il buco B6 dei pendenti dichiarato, §2.5); una istanza per TF = rischio che si somma fra istanze: **da contare nel cap 3,25%** | Claudio (quante istanze) |
| B9 | Martingala / recovery / griglia | **assenti per costruzione**: lotto indipendente dal P/L passato, max 3 ordini per setup, nessun riarmo sullo stesso episodio, residui cancellati a fine setup (X10) | - |
| B10 | PDF: 2/3 "su breakout successivo" (p12) | **non implementato** (contraddice p17/p21/p26 e il livello "Res D1" non e' meccanizzabile) | collega |

---

## 5. PIANO DI BACKTEST

Tutto sul **PC di backtest**. Mai sul VPS (regola del 21/09: il banco `50504400` sul VPS resta spento finche' una challenge e'
viva). Questa specifica **non contiene righe di lancio**: le righe nasceranno dopo il cancello sul codice, con i loro controlli.

### 5.1 Simboli: i 36 di casa e che cosa e' misurabile

Lista da `report/SCHEDE_SIMBOLO_PIANO_2026-10-05.md` r.42; profondita' dalla tabella r.61-71 dello stesso file e dalle date dei
tick veri del tester (`report/RESOCONTO_EA_G3_NOTTE_EVENTI_BULGE_2026-10-05.md` r.12).

| classe | simboli | tick reali BCM (merito) | barre BCM (solo screening / rischio) | nota |
|---|---|---|---|---|
| Forex 22 | EURUSD, GBPUSD, AUDUSD, NZDUSD, USDCAD, USDCHF, USDJPY, EURGBP, EURNZD, GBPJPY, GBPAUD, GBPCAD, GBPNZD, AUDJPY, AUDCAD, AUDNZD, NZDJPY, NZDCAD, NZDCHF, CADJPY, CADCHF, CHFJPY | dal **05/07/2024** | M1 dal **01/01/2010** (GBPNZD dal 10/05/2010) | il blocco con piu' storia: rischio sul vecchio misurabile |
| Forex extra | EURJPY, EURCHF | **[NON MISURATO]** (non erano nella sonda dei 22) | **[NON MISURATO]** | una sonda di profondita' prima di usarli |
| Oro | XAUUSD | dal **10/07/2024** | H1 dal 11/06/2004; M1 **[NON MISURATO]** | il modello "OHLC M1" sul vecchio richiede di sapere da quando c'e' M1 |
| Argento | XAGUSD | **[NON MISURATO]** | H1 dal 07/11/2008 | idem |
| Indici 10 | D30EUR, U30USD, NASUSD, SPXUSD, 200AUD, 225JPY, F40EUR, E50EUR, E35EUR, 100GBP | dal **26/09/2024** | stessa data: **il broker non ha di piu'** | **un solo regime (toro)**. Prova di regime solo su `NASUSD_EXT` 2010-11 -> 2026-07 (ammesso); SPX e Nikkei EXT "in frigo"; DAX HistData 2010-18 sta sul VPS e non e' importato |

**Le barre possono solo bocciare**: in casa il PF a barre eccede quello a tick di 1,72-3,51 volte (`REGISTRO_TEST` sez. 0, citato in
`RESOCONTO_EA_G3` r.12) e il DD a barre e' un limite inferiore. Per QUESTO EA vale a maggior ragione: ordini limit sulla linea con TP
di 10 u si riempiono e si chiudono **dentro la stessa barra M1**, dove il modello OHLC non sa l'ordine degli eventi.

### 5.2 Timeframe

| famiglia | TF provati nella base | TF solo nel passo 0 (frequenza) | escluso, con il numero |
|---|---|---|---|
| AUDIO | H1, H4 | H12, D1 | sotto H1: vietato dalla fonte (A-R8) |
| PDF | H4, D1 | (H1 degli esempi p08/p11: un asse in piu' se la base H4 vive) | W1: ~52 barre l'anno; sull'oro D1 conta **3 tocchi/anno** sul 3.5 (tabella 5.4; **6** con l'orologio +5 h, stessa conclusione) e su W1, con un quinto delle barre, se ne attendono meno [STIMA]: sui tick (2 anni) anche sommando i 22 forex si resta sotto ~150 -> NON MISURABILE per il merito, non "morto" |
| M2 (EMA200) | H1, H4 | - | sotto H1 vietato (A-R9) |

### 5.3 Il cancello del costo, CALCOLATO (misura, non giudizio)

Criteri di casa (`report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.168-175): **lavoro** `stop >= 40 x pedaggio`, **duro**
`stop >= 13,3 x pedaggio`; il pedaggio e' **spread + commissione** (correzione dell'11/09, r.177-196: forex con commissione
`0,004%` del nozionale, indici 0, oro 3,48 EUR/lotto). Spread = mediana delle mediane orarie con 5 giornate, `data/spread_vivo/`
04-11/09/2026 [MISURATO, campione sottile: 5 giornate]. Commissione in pip **[DERIVATO]** con i cambi della stessa fonte (USD/EUR
0,8552) e USDJPY 153,46 (snapshot 10/09).

| simbolo | spread | commissione | pedaggio | stop min lavoro (40x) | stop min duro (13,3x) | geometria AUDIO letterale: distanza ingresso->SL per ordine | esito aritmetico |
|---|---:|---:|---:|---:|---:|---|---|
| EURUSD | 0,2 pip | 0,47 pip | **0,67 pip** | **26,7 pip** | 8,9 | 5 / 10 / 15 / 20 pip | **nessun ordine passa il lavoro**; l'ordine profondo (5) sotto il duro |
| GBPUSD | 0,3 | 0,54 | 0,84 | 33,8 | 11,2 | 5 / 10 / 15 / 20 | nessuno passa il lavoro; 5 e 10 sotto il duro |
| USDJPY | 0,3 | 0,61 | 0,91 | 36,6 | 12,2 | 5 / 10 / 15 / 20 | come GBPUSD |
| D30EUR | 1,6 pt | 0 | 1,6 | 64 | 21,3 | 5 / 10 / 15 / 20 pt | **tutti sotto il duro** |
| NASUSD | 1,8 | 0 | 1,8 | 72 | 23,9 | idem | tutti sotto il duro |
| U30USD | 2,0 | 0 | 2,0 | 80 | 26,6 | idem | tutti sotto il duro |
| 225JPY | 22 | 0 | 22 | 880 | 293 | idem | tutti sotto il duro |
| XAUUSD (u = 1 USD) | 0,21 USD | 0,04 USD | 0,25 | 10,0 | 3,3 | 5 / 10 / 15 / 20 USD | 15 e 20 passano; **10 appena sotto (39,9x: pedaggio 0,2507, stop minimo 10,03)**; 5 fra duro e lavoro |
| XAUUSD (u = 0,1 USD) | | | 0,25 | 10,0 | 3,3 | 0,5 / 1 / 1,5 / 2 USD | **tutti sotto il duro**: l'asse "pip dell'oro = 0,1" e' chiuso per aritmetica |

Come leggere le distanze: scala (5,5) con stop = ordine profondo + 5 -> ordine profondo 5, linea 10, anticipo 15; con anticipo 10
-> 20. **Contro-esempio del calcolo** (costruito per romperlo): senza commissione, EURUSD avrebbe pedaggio 0,2 e stop minimo
**8 pip**, e l'ordine sulla linea (10 pip) **passerebbe**. Il verdetto quindi dipende dalla riga della commissione; e il numero
26,7 si verifica contro quello scritto da altri: **R265 riporta 26,54 pip** per lo stesso cancello su EURUSD (`REGISTRO_TEST`,
28/09) - scarto 0,6%, dovuto allo spread orario contro la mediana. **Contro-esempio PDF**: la fig.4 di p21 (stop 5 pip oltre il
secondo ordine, primo ordine a ~25) da' su EURUSD 7,5x e 37x: anche il PDF letterale e' sotto il lavoro.

Conseguenze, scritte come misure:
- La geometria **letterale** dell'audio e' esclusa per costo su tutti gli 8 simboli misurati, salvo l'oro con u = 1 USD per gli
  ordini lontani. **Non e' un verdetto sulla strategia**: e' il motivo per cui l'asse A8 (stop su ESTREMO_RECENTE) e il TF H4 non
  sono facoltativi. Esempio misurato sull'oro (feed HistData, NON BCM): ATR14 H1 mediano **11,9 USD** = 47x pedaggio; H4
  **23,6 USD** = 94x.
- Anche con stop largo il **TP resta 10 u**: con stop 26,7 pip e TP 10 il R/R e' 0,37 e il pareggio, pedaggio incluso, chiede un
  tasso di vincita di circa **75%** [DERIVATO: (26,7+0,67)/(10-0,67+26,7+0,67)]. E' l'attesa da battere, scritta prima.
- GBPUSD e USDJPY hanno **ore con mediana 8,0 e 6,8 pip** (rollover) [MISURATO]: un limit che si riempie a quell'ora paga 10-30
  volte il pedaggio tipico. Il CSV registra lo spread di ogni riempimento; il filtro `InpMaxSpreadPunti` e' l'asse se serve.
- Gli altri 28 simboli: spread e ora **[NON MISURATO]**. Il passo 0 li legge dal tester; la commissione si ricava con la legge di
  casa, oppure dal report se il tester la applica (da verificare al passo 0: se il report non la contiene si sottrae a mano).

### 5.4 Frequenza attesa, misurata dove si puo'

Conteggio fatto oggi sul solo feed in repo (oro M1 HistData, `backtest_pipeline/risultati_prove/oro_m1_histdata_zip/`, NON BCM,
orologio spostato di +6 ore come approssimazione, finestra 10/07/2024 -> 18/09/2026 = 2,19 anni; Supertrend HL2 con ATR media
semplice; ADX di Wilder implementato da me) **[MISURATO su feed esterno]**:

| TF | linea | episodi di tocco/anno | entro il limite audio (1/1/2) | + ADX14 <= 20 |
|---|---|---:|---:|---:|
| H1 | 2.5 / 3.0 / 3.5 | 151 / 121 / 97 | 101 / 84 / 88 | **37 / 34 / 37** |
| H4 | 2.5 / 3.0 / 3.5 | 44 / 25 / 26 | 26 / 19 / 22 | 9 / 6 / 10 |
| D1 | 2.5 / 3.0 / 3.5 | 5 / 5 / 3 | 4 / 3 / 3 | 2 / 0 / 1 |

**Ricontato dal cancello (07/10), codice indipendente sugli stessi 14 zip**: episodi e limite audio **identici** su tutte e nove le
righe; la colonna ADX esce **40 / 36 / 36** su H1 (contro 37 / 34 / 37: differenza dovuta all'innesco dell'ADX di Wilder, non al
conteggio) -> "35-40 setup l'anno per linea" e' riproducibile. 🔴 **Ma H4 e D1 dipendono dall'orologio**: con lo spostamento **+5 h**
(la calibrazione di casa dei feed HistData, `SCHEDE_SIMBOLO_PIANO` §2.2) invece di +6, H1 resta identico mentre H4 sul 3.5 fa
25 / 23 / 9 e **D1 sul 3.5 fa 6 tocchi/anno invece di 3** (2.5: 10 invece di 5). Le righe H4/D1 della tabella sono quindi
**[DIPENDENTI DALL'OROLOGIO]**: la composizione delle candele H4/D1 cambia con l'ora del server (vedi §5.5).

🔴 **Corretto dal cancello sul CODICE (07/10): la colonna ADX qui sopra e' contata con la formula di WILDER, ma l'EA usa `iADX`
di MT5** (§2.1). Le due formule non sono la stessa misura: `iADX` (ADX.mq5 di MetaQuotes) divide +DM/-DM per il true range
**barra per barra** e liscia con una media esponenziale `2/(n+1)`; Wilder liscia TR e DM separatamente con `1/n`. Sull'oro H1 della
stessa finestra la mediana e' **28,9** con `iADX` contro **25,2** con Wilder, e la quota di barre <= 20 e' **17,3%** contro
**29,4%**. Ricontato dal cancello con un programma indipendente (specchio di ADX.mq5 ricostruito a memoria, stesso esito dello
specchio del collaudo; **[DA CONFERMARE sul terminale]**: un indicatore stampato in MT5 su 5 barre chiude il dubbio):

| TF | linea | entro il limite audio | + Wilder <= 20 | **+ `iADX` <= 20 (default EA)** | `iADX` alla barra PRIMA (quella in cui la scala si arma) | `iADX` <= 25 |
|---|---|---:|---:|---:|---:|---:|
| H1 | 2.5 / 3.0 / 3.5 | 101 / 84 / 88 | 40 / 36 / 36 | **16 / 18 / 16** | 21 / 23 / 21 | 38 / 38 / 38 |
| H4 | 2.5 / 3.0 / 3.5 | 26 / 19 / 22 | 11 / 6 / 10 | **5 / 1 / 1** | 5 / 2 / 2 | 10 / 6 / 8 |

Perche' il default resta `iADX` *(motivazione riscritta dalla terza lettura del codice, 07/10: quella di prima usava le immagini
del PDF, che **non contengono nessun ADX** — p22: sotto-finestre `PeakRepairerStrict` e `ATR(14)` — e che per decisione di Claudio
del 07/10 non sono piu' una fonte di questo EA)*: **e' un'ASSUNZIONE [NOSTRA], non una lettura della fonte.** L'audio (A-R12) dice
solo *"ADX a 20, non di piu'"* e *"aspetta che controllo"* (guarda il suo grafico): **piattaforma, formula e periodo NON sono
detti**. Se la collega usa MT5, quello che vede si chiama "ADX" ed e' `iADX`; se usa TradingView vede Wilder. Lo spostamento e'
**simmetrico** (oro H1 HistData 2021-01 -> 2026-09, 33.033 barre, ricontato dalla terza lettura con una quarta mano: Wilder <= 20 equivale in
quota a `iADX` <= ~23; `iADX` <= 20 equivale a Wilder <= ~17): con l'una o l'altra scelta, se la piattaforma e' l'altra il "20" si
sposta. Quindi `iADX` **non e' "la lettura piu' fedele"**: e' la lettura **nativa della piattaforma su cui gira l'EA** e la **piu'
stretta** (circa meta' dei setup: 16-18 contro 36-40 l'anno per linea sull'oro H1), cioe' l'errore prudente se l'assunzione e'
sbagliata. Il prezzo e' la frequenza (E0). Wilder resta una cella dell'asse A5 (§3.1), e la risposta della collega alla
bloccante 9 (che piattaforma usa?) decide: e' una domanda, non una misura. **Conseguenza da scrivere accanto a E0**: su H4 il filtro
letterale lascia **1-2 setup l'anno** sul 3.5 dell'oro: il modo AUDIO su H4 si legge solo come famiglia.

Lettura (attese, non verdetti): AUDIO H1 per simbolo ~35-110 setup/anno a seconda di quante linee vivono **prima** dell'inclinazione
-> in 2 anni di tick **70-220 per simbolo**: 150 IS + 150 OOS richiedono **2-4 simboli della stessa famiglia** sommati. PDF H4 sul
3.5: 26 tocchi/anno **prima** di conferma, chiusura vicina e confluenza -> **[STIMA]** 5-15 setup/anno per simbolo -> per 300 sui
tick servono **10-30 simboli**: il merito del PDF a tick e' misurabile solo sull'intera famiglia forex, altrimenti e' **SOSPESO**
(n). L'oro 2024-26 e' un toro: sul forex la frequenza puo' essere diversa; il passo 0 la misura su BCM.

### 5.5 Finestre (emendamento della finestra, CLAUDE.md 16/08)

- **Unita' = operazioni.** IS = la prima parte cronologica della finestra a tick in cui la famiglia somma **>= 150 operazioni**,
  OOS = il resto, **>= 150**. Se il totale e' < 300: merito **SOSPESO per n**, il rischio si giudica lo stesso.
- 🔴 **Un'"operazione" qui e' un SETUP, non un ordine ne' un deal** *(aggiunto dal cancello 07/10)*: i tre ordini della scala AUDIO
  (e i due del PDF) condividono la linea, lo stop e quasi sempre l'esito, quindi NON sono prove indipendenti. Contare gli ordini
  gonfierebbe n fino a 3 volte e renderebbe falsa la soglia del nullo del §6.1, che assume prove indipendenti. Il PF e il DD si
  calcolano sul P/L **per setup** (somma degli ordini riempiti), in R; il conto per ordine resta nel CSV solo come diagnosi.
- **Orologio** (`CLAUDE.md` 24/09, `report/OROLOGIO_BCM_2026-09-24.md`): l'EA **non ha regole d'orario**, quindi l'ora entra
  solo nella **composizione delle candele** H4/H12/D1 (e nell'ora del rollover, ore 22 server, dove GBPUSD/USDJPY hanno mediana
  8,0/6,8 pip). BCM oggi e' **UTC+1 fisso** (d'inverno = ora italiana, d'estate = ora italiana - 1); sugli indici UTC+1 su tutto
  l'arco tick; sul **forex** il vecchio orologio (UTC+0 d'inverno) vale fino al cambio fra il **26/12/2024 e il 02/02/2025**, cioe'
  **dentro** la finestra a tick (dal 05/07/2024) e dentro tutto il vecchio 2010-2024: le candele H4/D1 forex sono costruite su due
  orologi, e su un altro broker (FTMO, ora italiana + 1) sarebbero diverse. Misurato al §5.4 che H4/D1 sono sensibili a 1 ora di
  spostamento: F0 stampa i conteggi H4/D1 **separati prima e dopo il cambio**, e la riga del conto vero (domanda 2 del §8) li rifa'
  sull'orologio di quel broker.
- **Regime dichiarato**: la finestra a tick (luglio/settembre 2024 -> giugno 2026) e' **toro** su oro e indici (detto in casa,
  `RESOCONTO_EA_IN_PAROLE_SEMPLICI_2026-10-06.md` r.65); per il forex il passo 0 stampa per simbolo rendimento della finestra e
  ADX medio, e il regime si **scrive** accanto al numero, non si assume.
- **Il VECCHIO giudica il RISCHIO** (regola B): cella congelata, barre OHLC M1 forex 2010 -> giugno 2024, oro dal primo M1
  disponibile, `NASUSD_EXT` per il Nasdaq. Si legge **solo il DD in R e la peggior giornata in R**; essendo un limite inferiore, puo'
  solo bocciare. **Non si boccia per il merito del 2012.**
- **Prova di regime** (regola C): le quattro finestre toro/orso/laterale/crollo della macchina gia' fatta (R50-R56-R59) **si
  prendono dal registro**, non le ridefinisco qui.

### 5.6 Fasi, costo, e cosa decide ciascuna

| fase | che cosa | modello | passate | tempo PC [STIMA] | decide |
|---|---|---|---:|---|---|
| **F0** sonda | `InpSoloConta`=true su 36 simboli x 8 configurazioni (AUDIO H1/H4/H12/D1, PDF H4/D1, M2 H1/H4), finestra dei tick | OHLC M1 | 288 | **14-160 min**, centro ~65 (2,9-33 s/passata, mediana 13,5, R88) | setup/anno per simbolo; soglie P25/P50/P75 dell'inclinazione **fissate qui, prima di qualunque P/L**; stop/pedaggio per ordine; regime della finestra |
| **F1** base | i (simbolo, TF, famiglia) che F0 non esclude per costo, 2 lati | tick reali | 12 per simbolo | 15 simboli: **15-60 min** | motore vivo o no, per famiglia e lato |
| **F2** assi | §3, uno alla volta, solo sulle famiglie vive | tick reali | fino a 196 per simbolo | 5 simboli: **1,4-5,4 h** | quale lettura delle fonti regge; centro dell'altopiano |
| **F3** IS/OOS | cella scelta sull'IS col centro dell'altopiano, OOS una volta sola | tick reali | 2 per simbolo | minuti | merito |
| **F4** rischio | cella congelata sul vecchio a barre | OHLC M1 | 2 per simbolo | ordine dei minuti per passata **[STIMA NON AGGANCIATA]**: nessun round di casa cronometrato su 15 anni; R88 da' 2,9-33 s/passata OHLC sulle finestre di casa, lo scalaggio lineare sugli anni non e' misurato | rischio (puo' solo bocciare) |
| (dopo) | forward demo, mai prima del cancello e della firma | - | - | settimane | collaudo vero |

Regole di lettura, valide in tutte le fasi:
- **Centro dell'altopiano, MAI il picco**: per gli assi a tre valori (ADX 10/14/20, inclinazione P25/P50/P75, tolleranze
  0,25/0,5/1,0) si prende il centro se i vicini tengono; una cella che sporge da sola e' rumore.
- **Si tiene una variante solo se migliora l'INSIEME dei simboli della famiglia** (regola del segno, §6 E6), non l'aggregato.
- **Nessuna griglia su un motore senza edge** (regola 19/08): se la base di una famiglia e' morta con certificato, i suoi assi
  **non** si girano.
- **Certificato di morte a 5 caselle** prima di scrivere MORTO: (1) PF misurato, (2) n e DD, (3) uscita ad asse (A1/A9 o P6/P8),
  (4) simboli gemelli provati (la famiglia stessa), (5) TF cambiato (i due TF della base). Se ne manca una: **NON ANCORA
  MISURATO**, con la casella mancante scritta in `REGISTRO_TEST.md`. Con F1 + le due celle d'uscita di F2 il certificato e'
  completabile per ogni famiglia: costo 8 passate per simbolo.
- Ogni esclusione per costo si scrive col numero (stop/pedaggio) accanto.

---

## 6. ATTESE E SOGLIE, SCRITTE PRIMA DEI NUMERI

Ogni riga ha il **contro-esempio**: quale numero produrrebbe l'ipotesi alternativa. Se il numero dell'alternativa cade dentro la
soglia, la soglia non misura niente e va alzata.

### 6.1 La soglia del nullo (calcolo, non misura)

Modello: passeggiata casuale senza edge, TP e stop fissi, pedaggio come al §5.3; probabilita' binomiale esatta. **[CALCOLO]**

| geometria | PF del nullo | PF che il nullo supera nel 5% dei casi: n=150 / 300 / 500 | P(PF >= 1,15) del nullo: n=150 / 300 |
|---|---:|---|---|
| TP = stop, pedaggio 2,5% di R (sulla frontiera 40x) | 0,951 | **1,24** / 1,15 / 1,10 | 11,0% / 4,7% |
| TP = 2R, pedaggio 2,5% di R | 0,963 | 1,28 / 1,18 / 1,12 | 13,1% / 6,4% |
| TP 10 / stop 27 pip, pedaggio 0,67 (EURUSD all'ingresso del cancello) | 0,910 | 1,24 / 1,13 / 1,08 | 13,3% / 4,9% |

### 6.2 Le attese

| # | ipotesi | attesa e soglia (scritte ora) | contro-esempio: che cosa produce l'alternativa |
|---|---|---|---|
| **E0** | il passo 0 conta abbastanza | AUDIO H1: >= 70 setup per simbolo nella finestra dei tick (la base a tre linee con `iADX` solo sul 3.5 fa ~200/anno sull'oro, ~440 nei 2,19 anni). *Corretto dal cancello 07/10*: la sola linea 3.5 con `iADX` <= 20 fa ~16/anno su H1 (~34 nei 2,19 anni) e ~1-2/anno su H4: l'asse A7 "solo 3.5" **non** arriva a 70 per simbolo, si misura solo sulla famiglia | se su BCM esce un ordine di grandezza meno, o il calcolo del tocco e' sbagliato o il feed esterno inganna: si confrontano oro BCM e oro HistData **sulla stessa finestra** prima di andare avanti |
| **E1** | fedelta' della geometria (non dell'edge) | AUDIO H1: durata mediana <= 60 min (A-R24 "un'oretta neanche"); 60-180 = compatibile con un TF d'esecuzione piu' alto, si chiede; > 180 = **non e' il metodo della collega**, si ferma la lettura del merito | una passeggiata casuale con barriere a circa 1 ATR esce in circa 1-2 barre [CALCOLO: tempo atteso = distanza^2 / varianza per barra]: **anche un motore senza edge** ha durata mediana di ~1-2 h su H1. Quindi E1 controlla la geometria, **non** dimostra niente sul merito |
| **E2** | costo | per ogni (simbolo, TF, famiglia): stop/pedaggio mediano per ordine >= 40 (lavoro); < 13,3 = escluso per aritmetica | vedi §5.3: senza la commissione EURUSD passerebbe a 10 pip. Il cancello si calcola **con** la commissione |
| **E3** | merito della famiglia | IS e OOS: n >= 150 **setup** (non ordini, §5.5) ciascuno; PF >= **max(1,15; soglia del nullo al 5% per la geometria e l'n misurati, §6.1)**; R/R e tasso di vincita scritti accanto (pareggio a ~75% con TP 10 e stop 26,7) | il nullo supera 1,15 nell'11-13% dei casi a n=150: con la sola soglia 1,15, una cella su otto senza edge passerebbe l'OOS |
| **E4** | "il terzo e' il piu' sicuro" (A-R15) | tasso di vincita ST3.5 > ST2.5 di almeno 2 errori standard (**12-14 punti** con ~100 operazioni per linea [CALCOLO: errore standard della differenza 6-7 punti]) | senza edge il tasso di vincita dipende solo dalla geometria, uguale sulle tre linee: differenza attesa 0, con un errore standard di 6-7 punti |
| **E5** | "al massimo due tocchi, poi sfonda" (A-R11) | nella variante a conteggio illimitato (A4), PF dei tocchi 1-2 > PF dei tocchi >= 3 nella maggioranza dei simboli | senza edge il numero del tocco non conta: segno casuale per simbolo |
| **E6** | "ADX sopra 20 rischia di sfondare" (A-R12), e ogni filtro in generale | si tiene il filtro solo se migliora il PF nello stesso verso in **>= 6 simboli su 8** (o >= 9 su 12) della famiglia | un filtro che toglie operazioni a caso cambia il segno a caso: P(>= 6 su 8) = **14,5%**, P(>= 9 su 12) = **7,3%** [CALCOLO]. Su 8 simboli la regola e' debole: preferire famiglie >= 12 |
| **E7** | la LINEA conta (non solo un ritracciamento qualsiasi) | PF linea vera > PF placebo (`InpPlaceboAtr`=1,0) in >= 2/3 dei simboli | se l'edge e' del ritracciamento generico e non della linea, il placebo guadagna uguale: allora l'EA ha forse un edge, ma **non e' quello descritto dalla collega**, e va detto |
| **E8** | rischio | DD massimo a saldo chiuso e peggior giornata, **in R**. Il rischio massimo compatibile e' `r_max = 10% / DD_R` (muro 10% usato in casa, R264) e `4,0% / peggior_giornata_R` (pausa Guardian): il backtest consegna `r_max`, la taglia la sceglie Claudio | il DD a barre e' un limite inferiore: se a barre `r_max` e' gia' sotto il rischio che Claudio firmera' (oggi il segnaposto 0,25%: il confronto si rifa' col numero firmato), **boccia**; se e' sopra, **non promuove** |
| **E9** | bandiere di taglia (pesi 1:2:1 / 1:2) | a parita' di R totale: si riporta la differenza di PF e di DD_R; **nessuna accensione senza firma**, anche se migliora | i pesi spostano solo la distribuzione del rischio fra ordini: senza edge la differenza attesa e' rumore; con i riempimenti piu' profondi meno frequenti, i pesi verso la linea cambiano poco l'n |

---

## 7. COSA NON E' NEI FILE, E QUINDI NON E' NELL'EA

Non codificato (ne' come filtro, ne' come uscita). Se Claudio o la collega lo forniscono, entra come input nuovo con default neutro.

- **Livelli tecnici del PDF**: Fibonacci (swing non definito, P-p16), S/R col "metodo di Larry Williams" (P-p21/p25, metodo non
  descritto), Multipivot & Opposing / Pivot Fibo (P-p07/p08), PeakRepairerStrict (P-p22), PTE e Weekly Open Line come confluenze
  (P-p26), numeri tondi (passo non detto, P-p16). Quindi nel modo PDF la confluenza "sine qua non" e' **ridotta alla sola EMA 200**:
  e' un restringimento dichiarato, non la regola intera.
- **EMA 200 come barriera** fra ingresso e target (P-p14 r.7, solo [INFERITO] in P §C-5): non codificata.
- **Filtri non quantificati**: volatilita' sufficiente / congestione / gap e spike (P-p14/p15/p25), distanza "compatibile con la
  volatilita' media giornaliera" (P-p11), candela "di indecisione o inversione" (P-p12), eventi macro (P-p25: nessuna finestra).
- **Weekly "se c'e' il Supertrend vicino"** (A-R7): "vicino" non detto.
- **Combinazione dei TF** di analisi (A-R7): non detta; una istanza per TF.
- **Uscita su flip del Supertrend, trailing, "lascia correre"** (P-p18/p26, assenti in audio): nessuna regola oggettiva in nessuna
  fonte. Lo stop iniziale resta l'unica protezione oltre al TP.
- **Sessioni, orari, venerdi', rollover**: nessuna fonte. (Il filtro news e quello del venerdi' esistono in casa ma **non** sono
  in questo EA.)
- **"Dieci volte tanto"** (A-R17), **"non come in trend following"** (A-R25), **rischio per operazione e numero di posizioni**
  (A-R27; P "come da money management"), **W%R / RSI** (P-p07), **ruolo di EMA 9/21 e Bollinger** (solo log, §1.1 I7).
- **Il PDF del secondo ordine "su breakout successivo"** (P-p12) e il livello "Res D1" (P-p12, immagine).

---

## 8. DOMANDE RESIDUE PER CLAUDIO (solo quelle che nessun backtest puo' decidere)

1. **Rischio e taglie.** Il rischio per setup (segnaposto **0,25%** del saldo, totale di tutti gli ordini) e **quante istanze**
   (simboli x TF x famiglia) possono convivere dentro il cap del 3,25%. Il backtest ti consegna `r_max` in R (E8): la scelta e' tua.
   E se, dopo la misura a parita' di rischio, vuoi mai accendere le taglie della collega (pesi, confluenza): e' una firma.
2. **Simboli reali e conto.** Su quali strumenti opera davvero la collega, e **su quale conto/broker** girerebbe l'EA: commissioni,
   spread e orologio cambiano da BCM a FTMO, e il cancello del costo si rifa' per il conto vero.
3. **Fedelta' o misura.** Se la lettura che regge nei test e' diversa da quella che la collega descrive (per esempio stop agganciato
   alla volatilita' invece dei 5 punti), l'EA "Nat&Cla" deve restare fedele a lei o seguire la misura? Il backtest dice quale
   funziona, non quale e' "il suo metodo".
4. **Le 12 domande bloccanti restano utili** anche se non bloccano piu' il codice: ogni risposta spegne assi e accorcia i test.

| bloccante (audio §10.2) | assi che spegne | passate risparmiate per simbolo |
|---|---|---:|
| 1 quale fonte comanda | una modalita' intera | 60 (PDF) o 84 (AUDIO) |
| 2 direzione | nessuno (i due lati si misurano sempre, regola di casa); decide **cosa si schiera** | 0 |
| 3 ruolo delle linee 2.5/3, periodo ATR | A7 | 12 |
| 4 tocco, conteggio, conferma | A3, A4, P1 | 16 |
| 5 TF e momento della decisione | meta' della base TF, P7 | 6 + 8 |
| 6 ingresso (scala, "5/10", pendenti) | A2, P4 | 16 |
| 7 stop | A8, P5 | 12 |
| 8 take profit, BE, parziali | A1, P6 | 12 |
| 9 filtri (ADX: periodo, soglia, **quale ADX della piattaforma**; inclinazione, confluenza) | A5, A6, P3 | 52 |
| 10 ingresso sulla sola EMA 200 | M2 | 40 |
| 11 simboli e orari | riduce i simboli del passo 0 e di F1 | fino a 288 passate di F0 |
| 12 taglie e rischio | S2, S3 | 8 |

E una richiesta pratica da girare alla collega: **uno screenshot** di un suo setup con le tre size disegnate (audio Q24) vale piu'
di dieci risposte a voce.

---

## 9. NOTE PER IL CANCELLO (cosa ho deciso io, e i dubbi)

- **Decisioni mie, tutte dichiarate [NOSTRA] e tutte input**: misura dell'inclinazione (|EMA200[1]-EMA200[21]|/ATR14, soglie dal
  passo 0); normalizzazione della scala in "anticipo/oltre" che copre le letture A e B; ordini AUDIO come limit armati in anticipo
  (dedotto da "qualche secondo"); "leggermente" = 5 u preso dalla stessa collega (WA0092); stop = ordine profondo + 5 come lettura
  della "resistenza"; episodi di tocco e reset al flip; ATR14 come unita' delle tolleranze; ADX sul TF del segnale; target PDF
  congelati all'ingresso con ripiego in R; scadenza pendenti 1 barra; un setup alla volta; unita' AUTO_CLASSE (oro = 1 USD);
  lotto arrotondato per difetto con scarto sotto il minimo (deviazione dalla convenzione del riferimento, in senso prudente).
- **Sovrapposizione con la flotta - LETTA dal cancello il 07/10** (resoconti di casa, NON fonti di regole: le **regole** di
  `EA_NatCla` restano quelle dei due documenti, qualunque cosa dica quel codice):
  - **Modo PDF contro `ABTG_SupertrendReversal` (770901) e le sei `SupRev_*_Ottimizzato` (97091x)**: stesso documento, stesso
    Supertrend (10, 3.5), ma **uscite diverse** (quelle hanno trailing sul ST, uscita al flip, TP in R; qui EMA14/EMA89 senza
    trailing) e confluenza diversa (qualunque EMA entro 1,5 ATR contro sola EMA200 entro 0,5 ATR). Quindi **non e' un doppione da
    saltare**, ma il prior di casa va scritto accanto: `RESOCONTO_EA_G5_SUPERTREND_GOLDEN_ORO_2026-10-05.md` r.40-49 e r.230-233 =
    **MERITO SOSPESO** su tutte le celle sopra 1 (n OOS <= 114), **nessun MORTO**, sul **forex nessuna tipologia superata**
    (CHFJPY 0/12, AUDUSD solo celle a segno invertito), NASUSD H1 **ESCLUSO PER COSTO** stimato 28,7x. 👉 **Cosa non si spende**:
    F1 PDF su NASUSD H1 non parte se F0 conferma stop/pedaggio < 40x; il modo PDF su H1 resta un asse solo se la base H4 vive.
  - **Motore M2 contro `ABTG_EMA200` (771531)**: quell'EA mette gia' **due limit attorno alla EMA200** con stop oltre il secondo:
    M2 e' un **parente stretto**, non un motore nuovo. E in casa il fenomeno sotto c'e' gia' misurato:
    `RESOCONTO_EA_G2_EMA200_SW_ORB_2026-10-05.md` r.95-97: il **rimbalzo al primo tocco della EMA200 e' NULLO** su H4 forex
    (6 coppie Oanda 2005-2020: P 0,487 / 0,470 contro surrogati 0,478 / 0,491), 13 NULLO + 8 ZONA GRIGIA su 21 celle M5-H1 su
    DAX/oro/S&P, **NON ANCORA MISURATO** dentro i regimi. 👉 **Cosa non si spende**: per M2 si gira **solo la base (4 passate) +
    il placebo E7**; i suoi 36 assi partono **solo** se la base vive **e** batte il placebo. Attesa scritta ora: con quel prior, la
    base M2 deve uscire **non distinguibile dal placebo**; se esce diversa, prima si cerca l'errore, poi si festeggia.
  - **Correlazione, prima di schierare**: dal CSV per-trade si conta la quota di setup `EA_NatCla` che entrano **nella stessa
    barra e nello stesso verso** di un ingresso di 770901/97091x/771531 sullo stesso simbolo; sopra la soglia (da fissare nella
    prova, prima dei numeri) le due istanze contano come **una sola sedia** nel cap 3,25%. E' una misura, non una decisione.
- **Numeri presi da feed esterno**: frequenze e inclinazione dell'oro vengono da HistData con orologio approssimato (+6 h): servono
  a dimensionare il piano, non a decidere niente. Il passo 0 li rifa' su BCM.
- **Spread vivo**: 5 giornate, 8 simboli. Il cancello del §5.3 e' aritmetica su quel campione; si rifa' con lo spread del tester.
