# SCHEDA LIVE EMILIANO - 30/09/2026 ("la challenge dei colleghi in diretta")

**Fonte unica:** `data/trascrizioni/LIVE_EMILIANO_2026-09-30.txt` (408 righe per `wc -l`, 59.597 byte, trascrizione
automatica, commit `07516dc0`). **Ogni `r.NNN` e' il numero di riga di QUEL file.** Letta per intero, riga per riga.
Nessuna navigazione, nessun completamento da memoria. Dove cito il repo lo dico col file.
**Analista:** estrattore di trascrizioni (agente `analista-trascrizioni`), 01/10/2026.

> ## REGOLA CHE VALE SOPRA TUTTO
> **Da questo materiale non si muove NIENTE.** Ogni numero qui dentro e' una **dichiarazione di una fonte esterna**
> `[dichiarato, NON verificato]`, mai un criterio nostro. Nessun preset, EA, conto o forward e' stato toccato per
> scrivere la scheda. I criteri restano quelli di casa (REGISTRO_TEST, FIRME, certificato di morte).

Etichette: **[TRASCRITTO]** c'e' scritto, cito la riga - **[INFERITO]** lo deduco da piu' passaggi (dico quali) -
**[INCERTO]** / **[NON CHIARO]** non lo so e non lo deduco - **[LETTO nel repo]** viene da un file nostro, col nome.

---

# PARTE 1 - LA SINTESI (la pagina che si legge per prima)

## 1.0 La riga che conta

> **Su 408 righe: 21 voci di parametro/valore (la meta' sono numeri di contorno, nessuna e' una regola con soglia completa),
> 24 meccanismi, 6 bandiere (1 rossa parziale, 3 arancioni, 2 ambra), ZERO regole prop, ZERO trucchi anti-prop.**
> Il pezzo piu' solido **non e' un numero**: e' una **coincidenza di giornata che si verifica**. La mattina del 30/09
> il DAX e' "partito in quarta" all'apertura (r.119, r.223) e **la nostra `770411` (MaxMin DAX SHORT) e' stata
> stoppata a -1.535,91 EUR alle 09:03:09 ora italiana [DERIVATO]**, meno di quattro minuti dopo aver venduto, mentre
> **tre colleghi (Cinzia, Edo, Consuelo) prendevano un LONG all'apertura o in pre-apertura** e lo chiudevano al
> target / in profitto (dichiarato, cifre solo per Cinzia). E' **n = 1 giorno, un regime**: non pesa come merito. **Pesa come DOMANDA** (§4.2 e §6).

## 1.1 Che cosa e' questa live, e che cosa NON e'

- **La "challenge" di cui parla l'host NON e' una prop.** E' un **esercizio di allenamento di fine corso**: *"oggi
  mettiamo in pratica tutto quello che abbiamo imparato in questi due mesi"* (r.15); *"oggi c'e' la challenge...
  oggi tutti dovete consegnare a me e a Paolo il vostro statement"* (r.17); *"ognuno applichera' la strategia sulla
  quale si e' specializzato"* (r.19); *"scelga due o tre piani di trading"* (r.115). Si opera su **demo o reale
  piccolo** (r.63, r.137) e si manda lo **statement** a Emiliano e Paolo (r.17, r.165, r.407-409). **Nessuna regola
  FTMO/prop, nessun drawdown limite, nessun capitale prop.** `[INFERITO da r.15-19 e dall'assenza di qualunque
  termine prop in 408 righe: ftmo 0, funded 0, challenge 4 (nel senso dell'esercizio, r.17 e r.89, o come modo di dire, r.351 *"devi superare mille challenge cosi'"*)]`.
- **Chi parla:** l'**host (Emiliano)** conduce e commenta; **sette-otto partecipanti** operano e raccontano. Nomi
  usati solo come etichetta per le righe (STT instabile: Cinzia/"Roska", Consuelo/"suelo", Natti/Nati/"Matti",
  Edo, Marco, Valerio/"Vale" (r.175 lo chiama "Mario": `[INCERTO]` se sono la stessa persona), "Silizia", Samara, Luca per la regia). Nessun dato personale riportato.
- **Orari:** la trascrizione **non ha orari**. Dal contenuto la live e' girata **dopo l'apertura del DAX** (r.119:
  Cinzia e' gia' long "perche' hai partito in quarta"). L'ora esatta e' `[NON DICHIARATA]`; i colleghi sono in
  Italia, quindi "le 9" (r.109) e "alle otto e mezza" (r.351) sono `[INFERITO: ora italiana]`, **fuso non dichiarato**.

## 1.2 Le cinque cose piu' utili per noi (in ordine)

| # | cosa | perche' vale | etichetta |
|---|---|---|---|
| 1 | **Il 30/09 al minuto**: la mossa di apertura che i colleghi descrivono e' la stessa che ha stoppato la `770411` | trasforma una live di opinioni in un evento verificabile con uno screenshot M5 (§5, misura M-1, costo zero) | [INFERITO], da confermare |
| 2 | **Il lato OPPOSTO dello stesso livello**: i colleghi giocano il minimo/massimo della notte **col FADE + confluenza** (EMA200 H1 + EMA50 H4, Supertrend H1, max giorno prima, gap, numero tondo); noi giochiamo la **ROTTURA, e solo short** | e' l'unico asse davvero diverso dalla nostra `770411`; la rottura LONG del box DAX e' gia' misurata morta (0/18 celle, §4.3), il fade con confluenza **no** | [TRASCRITTO] + [MISURATO sul CSV] |
| 3 | **"Cost to cost" = costa a costa di Larry Williams** (bande di Bollinger orizzontali, mattine laterali, **indici**) | in casa esiste gia' `ABTG_CostToCost` (Larry); i file prova che ho visto (R102/R103) sono **EURJPY/GBPCAD/XAGUSD**, nessuno su indici `[NON VERIFICATO fino in fondo: non ho aperto tutti i CSV degli scan]`: asse SIMBOLI, con il cancello di costo da calcolare PRIMA (§5, M-3) | [INFERITO] + [LETTO nel repo] |
| 4 | **Freno dopo gli stop**: "tre stop di fila" + "target massimo giornaliero di stop finanziario... anche in guadagno" (r.311-313) | esiste nel nostro Guardian come **P1 (v1.30) e S1 (v1.40), opzionali e SPENTI**; l'include pinnato sulla trial e' v1.20 (§4.4). Decisione di Claudio, non misura | [TRASCRITTO] + [LETTO nel repo] |
| 5 | **Ingresso: pre-apertura (08:30 IT) a piccola size, o apertura se "parte con decisione", o dopo l'ORB** - e il target e' sempre l'**EMA200 H1** se vicina | tre momenti di ingresso diversi dal nostro (il `770411` arma alle 08:59 IT, il `770101` non entra prima delle 09:35 IT); l'EMA200 come **target** e' gia' nel `770411` (`InpUseEMA200Target=true`) ma non nel `770101` | [TRASCRITTO] + [LETTO nel preset] |

## 1.3 Quello che NON c'e' (verificato con `grep`, conteggio per termine)

| pratica cercata | occorrenze | nota |
|---|---:|---|
| prop / FTMO / funded / drawdown-limite | 0 / 0 / 0 / 3 | i 3 "drawdown" sono il drawdown **personale** dell'host sull'oro ieri (r.299) |
| martingala / raddoppio / griglia / hedging / mediazione | 0 / 0 / 0 / 0 / 0 | |
| "recuper*" | 4 | r.285 x3 = il **prezzo** che "recupera" una candela; r.311 = *"revenge trading, vuoi recuperare di piu'"*, citato come **errore da evitare** |
| trucchi per aggirare le prop | **0** | **nessuna sezione "VIETATO PER NOI" da aprire** |

---

# PARTE 2 - LA SCHEDA DI CASA

```
FILE             data/trascrizioni/LIVE_EMILIANO_2026-09-30.txt  (408 righe - 59.597 byte)
RELATORE/CANALE  Emiliano (host) + partecipanti del corso; Zoom; collegata alla serie di live gia' agli atti
                 (REGISTRO_TEST "REGOLE EMILIANO MONZA", report/ANALISI_LIVE_EMILIANO_2026-09-28.md).
OGGETTO          Sessione di allenamento del 30/09: analisi multi-TF e operativita' mattutina su DAX
                 (principale), oro, EURUSD, con studio dei correlati (S&P, Nikkei). Nessun EA, nessuna prop.
```

## 2.1 Le ricostruzioni dell'ascolto (tutte [INFERITO], nessuna entra in un numero)

| nel testo | lo leggo come | su che base |
|---|---|---|
| "metri 200", "la 1200", "la 200" (r.19, r.53, r.57) | **EMA200** | indicazione di Claudio per "metri 200"; r.59 *"l'89 e la 100... qui sulla 200"*. "1200" e "1800" (r.53) restano `[NON CHIARO]` |
| "orbo", "orb" (r.23, r.25, r.151) | **ORB** | indicazione di Claudio |
| "norma" (r.19) | probabilmente **ORB** | l'elenco *"chi lavora norma, chi lavora presection, chi lavora le bande di bollinger, chi lavora metri 200, chi lavora massimi minimi"* sono 5 strategie: ORB, pre-section, Bollinger, EMA200, max/min. `[INFERITO]` |
| "cost to cost" (r.23, r.37, r.215) | **"costa a costa"**: operare da un bordo all'altro di un range | `ABTG_CostToCost.mq5` (intestazione: *"tradare da costa a costa dentro il range"*, Larry Williams) e `backtest_pipeline/prove/COSTTOCOST_TESI.md` `[LETTO nel repo]` |
| "livelli di Larry" (r.31, r.33, r.77) | **punte/swing di Larry Williams** tracciati su weekly e daily | stesso EA `CostToCost` ("punte di Larry"); `[INFERITO]` |
| "pre-section", "presezione", "fray section" (r.263, r.351, r.393) | **una zona/canale di prezzo** con parte alta, centro e "floor" | stesso termine nel referto del 18/09 (*"canale basso della pre-section"*); il significato esatto **non e' dichiarato nemmeno la'** |
| "bike" (r.247-249) | **buy** | contesto: *"sono entrato con un bike qui, e un altro a chiusura del gap"* |
| "6 ridotte" (r.37) | **size ridotte** | contesto: *"entro con... ridotte per fare un po' il costo-to-cost"* |
| "SMP"; "Japan"; "German/Darcy/Dark Cell" (r.69-71, r.191, r.215) | **S&P 500**; **Nikkei**; **DAX** | contesto di tutta la live `[INFERITO]` |
| "Wiki/Wikileaks/Wheatley" (r.43, r.49) | **weekly** | stesso pattern gia' visto il 28/09 (*"weekly -> 'Wheatley'"*) |
| "Super Trend Invert" (r.23-25) | **Supertrend Reverse/Inverte** | ricorrente nelle live |
| "entrata in apertura a Londra" (r.129) | l'apertura del **DAX** | Cinzia opera il DAX; `[INCERTO]`, non e' Londra |
| "telepression", "T3", "2015", "R8" (r.351, r.297) | -- | `[NON CHIARO]`, non interpreto |

## 2.2 PARAMETRI CON VALORE

Tutti **[dichiarato, NON verificato]**. Colonna "chiaro?" = affidabilita' del numero come trascritto.

| # | parametro | valore | citazione (troncata) | riga | chiaro? |
|---|---|---|---|---|---|
| P1 | Target all'apertura DAX | **appena sotto la EMA200** (H1), solo se **vicina** | *"metto il target appena sotto la media 200"* · *"se e' troppo distante... non lo metto in apertura il target"* | r.111, r.127, r.147 | [TRASCRITTO] chiaro |
| P2 | Guadagno cercato in apertura | **20-30 punti** ("pip") | *"quei 20-30 pip me li porto a casa"* | r.113 | chiaro sul numero; l'unita' e' `[INFERITO: punti indice]` |
| P3 | Parziale e stop in pari | **ogni 20 punti** | *"come piano di trading, ogni 20 punti parzializzo e stop in pari. La prima parzializzazione, poi... un livello obiettivo"* | r.287 | chiaro; **attribuzione NON chiara** (host o partecipante) |
| P4 | Rapporto rischio/rendimento | **1:2** ("piu' o meno") | *"il rapporto rischio rendimento dovrebbe essere uno a due... piu' o meno"* | r.351 | chiaro; e' una **domanda dell'host**, risposta vaga |
| P5 | RR del piano oro di Natti | **~1:1** ("quasi uno a uno") | *"sarei andata quasi uno a uno. Stop Loss e Take Profit"* | r.403 | chiaro |
| P6 | Target Fibonacci (oro) | **38,2** poi **50** | *"potrebbe arrivare a 38.2"* · *"38. 50, guarda caso, proprio si ferma su H1"* · *"Take Profit a 31"* | r.381, r.395-399 | 38,2 e 50 chiari; **"31" e' `[TRASCRITTO dubbio]`** (forse 38,2) |
| P7 | Distanza fra ordini DAX | **178 punti**, giudicata "troppo" | *"la distanza... 178 punti troppo"* | r.351 | `[TRASCRITTO dubbio]`: non dice fra quali due ordini |
| P8 | Stop consecutivi che fermano | **3 stop di fila** + **target massimo giornaliero** (nessun valore) | *"i tre stop di fila e poi un target massimo giornaliero di stop finanziario"* | r.311 | chiaro sul 3; **il target non ha numero** |
| P9 | P&L per trade di Cinzia (DAX) | vince **20-30 EUR**, perde **30-40 EUR**; oggi **+30 EUR** aperto | *"magari guadagno 20 euro, 30 euro... quando perdo, ne perdo 30, 40"* · *"stai guadagnando... 30 euro"* | r.153-155, r.135 | chiaro (conto piccolo, r.137) |
| P10 | EURUSD di ieri (29/09) | **+12-13 EUR**, size **"0 0 0 0 5 e 1"** | *"tipo di 12 euro 13 euro... con quanto sei entrata? con 0 0 0 0 5 e 1"* | r.351 | profitto chiaro; **size `[TRASCRITTO dubbio]`** (forse 0,05 e 0,1 lotti) |
| P11 | Terza spinta | **"due volte... se ci va la terza... potrebbe romperlo"** | *"sono andati due volte, se ci va la terza tendenzialmente potrebbe romperlo"* | r.351 | chiaro |
| P12 | Deviazione standard VWAP | **seconda** deviazione come livello | *"c'era anche la seconda standard deviation del VWAP"* | r.351 | chiaro |
| P13 | Volume come freno | **volumi decrescenti** vs candele d'apertura => prezzo si puo' fermare; **ultima candela M15 al 50%** dei volumi => non supera i precedenti | *"se fa volumi... decrescenti rispetto ai volumi delle candele dell'apertura, allora c'e' probabilita' che il prezzo si possa fermare"* · *"e' solo al 50% dei volumi"* | r.209-211, r.271 | chiaro; ⚠ **r.233-235 dice l'opposto** ("volumi crescenti... rallenta"): `[TRASCRITTO dubbio, inversione STT probabile]` |
| P14 | Medie citate come livelli | **EMA200 (H1, H4, H12/H1)**, **EMA50 (H4 e weekly)**, 89-100 (H4), 21, 9 | *"EMA 200 in H1 e un EMA 50 in H4 che praticamente coincidono"* | r.59, r.101, r.279, r.351 | 200/50 chiari; "H12" e "EMA 4" (r.351, r.367) `[dubbio]` |
| P15 | TF di lavoro dichiarati | Weekly > Daily > **H4 > H1** > M15 ("giocate in fuga") ; Natti M30/H1/H4 | *"scendo in M15 e provo a fare delle giocate in fuga"* | r.53-63, r.351 | chiaro |
| P16 | Durata di un'operazione oro "veloce" | **5-10 minuti** | *"un'operazione da 5-10 minuti"* | r.283 | chiaro |
| P17 | Livello oro citato | **4277** ("livello di Larry... short") | *"Quanto e' questo short? 4277"* | r.281 | numero chiaro; e' un livello, non un parametro |
| P18 | Orari | **"aspetterei le 9"**; ordini pre-apertura **"alle otto e mezza"** | *"aspetterei le 9, vedrei la prima reazione"* · *"io in realta' ero entrata alle otto e mezza"* | r.109, r.351 | chiari; **fuso non dichiarato** `[INFERITO: IT]` |
| P19 | Bollinger | **nessun periodo/deviazione dichiarato oggi** | *"bande di Bollinger se sono orizzontali"* | r.23, r.37, r.215 | -- (i 37/3 e 20-22 sono nelle live precedenti, non qui) |
| P20 | ORB | **nessuna durata dichiarata oggi** | *"massimi e minimi della notte... e poi l'orb"* · *"se no, io aspetto l'orb"* | r.23-25, r.151 | -- |
| P21 | Livelli DAX parlati | "1200", "1800", "635" | -- | r.53, r.255 | `[NON CHIARO]`: probabili storpiature; **non interpreto** |

## 2.3 MECCANISMI (24, in ordine di apparizione)

| # | meccanismo | come descritto | riga |
|---|---|---|---|
| M1 | **Piano scritto PRIMA**: strumento, strategia, dove lo stop, dove l'uscita, size | *"devi avere... dove mettere lo stop e dove mettere il profitto. Lo sai? Punto. E lo devi applicare"* | r.19, r.115, r.225-227, r.371-375 |
| M2 | **Cascata multi-TF**: Weekly -> Daily -> H4 -> H1 (-> M15) e scenari 1/2/3 | *"scenario 1, scenario 2, scenario 3"* | r.29-33, r.53-61, r.97, r.109 |
| M3 | **Se laterale/incerto: "gioco in difesa"**, size ridotte, ordini lontani su confluenze; *"incertezza, gioco in difesa. Questo deve essere l'automatismo"* | non vieta di operare nel range: *"non e' giusto non operare... e' un'opportunita'"* (r.49) | r.37, r.49, r.55-67, r.105, r.219 |
| M4 | **Livelli della notte + del giorno prima + numero tondo + resistenza daily** come punti d'ingresso | Edo, Consuelo, Natti | r.249-255, r.347-349, r.381 |
| M5 | **Confluenza di livelli**: Supertrend H1, EMA200 H1, EMA50 H4, VWAP + 2a dev std, chiusura del gap | *"c'e' il massimo della notte e in piu' il super trend in H1"* | r.249, r.347-351 |
| M6 | **Ordini pendenti in PRE-apertura a piccola size** (due piccoli + uno piu' sotto) | *"avevo messo due ordini piccoli e un altro l'avevo messo qui sotto"* | r.247-249, r.351 |
| M7 | **Ingresso all'apertura SE parte con decisione E la strada e' libera fino alla EMA200; altrimenti attendere l'ORB** | *"se vedo che parte proprio con decisione, io mi ci butto dentro... se no, io aspetto l'orb"* | r.111, r.147-151 |
| M8 | **Target sulla EMA200 H1**, solo se vicina | vedi P1 | r.111, r.127, r.147, r.251 |
| M9 | **Parziale + stop in pari ogni 20 punti** | vedi P3 | r.287 |
| M10 | **Uscita immediata se il prezzo parte in direzione opposta** | *"se vedo che dopo parti in direzione opposta, chiudo subito"* | r.155 |
| M11 | **Studio dei correlati: S&P e Nikkei guidano il DAX** | *"capendo dove si ferma il Japan sappiamo dove sciottare il DAX"* | r.69-71, r.191-199, r.351 |
| M12 | **Volumi come freno** (decrescenti => si ferma) | vedi P13 | r.209-213, r.271-273 |
| M13 | **Controtendenza = operazione veloce** | *"quando tu sei in un contesto short e tu vai long... l'operazione deve essere abbastanza veloce"* | r.351 |
| M14 | **La terza spinta rompe** il livello | vedi P11 | r.351 |
| M15 | **VWAP come mean-reversion con 2a deviazione**; l'host dichiara *"io ho un sistema automatico che lavora sulla base della distanza dei prezzi dal VWAP"* | si allontana dal VWAP, tocca la 2a dev, torna al VWAP | r.351 |
| M16 | **Di notte non si fa niente: si aspetta** | *"di notte non fai niente, aspetti, e vedi l'evoluzione"* | r.293 |
| M17 | **Stop dopo 3 perdite di fila + tetto finanziario giornaliero, anche in guadagno** | *"anche in guadagno ti devi fermare... quando stai guadagnando in un target finanziario ti fermi"* | r.311-313 |
| M18 | **Guardare le news/calendario** (nessuna ora, nessun numero) | *"ricordatevi sempre di guardare le news, il calendario"* | r.351 |
| M19 | **"Nightly": indicatore che traccia il box notturno** (aree bianche); parametri modificabili anche per la sessione diurna | *"il nightly... traccia il box notturno di default"* | r.353-355 |
| M20 | **Piano oro di Natti**: pendente sopra il massimo della notte, TP Fibonacci 38,2, SL sotto i minimi | vedi P5-P6 | r.381-403 |
| M21 | **Semplicita'**: *"sul mercato funzionano le cose semplici"* | in risposta a un grafico "con troppa roba" | r.361-365 |
| M22 | **Ordini su livelli di "pre-section"**, stop/target "dal punto di vista tecnico" | Edo | r.263-265 |
| M23 | **Checklist mattutina spuntata voce per voce** | *"tutte le mattine... una a una la spunto"* | r.375 |
| M24 | **Statement + descrizione della strategia applicata** a fine giornata, anche se non si e' operato (si manda la motivazione) | -- | r.17, r.165, r.407-409 |

## 2.4 I RISULTATI DELLA GIORNATA DEI COLLEGHI (tutti [dichiarato, NON verificato], mai come criterio)

**Nessun risultato aggregato dichiarato.** Cio' che si legge, partecipante per partecipante:

| chi | strumento | cosa fa | esito dichiarato | riga |
|---|---|---|---|---|
| Cinzia | DAX (H1) | **long a mercato all'apertura** perche' "parte in quarta"; TP appena sotto EMA200; **stop "ancora da mettere"** | **+30 EUR** aperto (r.135); **"arrivato a target"** (r.141); l'host: *"l'unica che ha fatto i soldi"* (r.161) | r.119-141 |
| Edo | DAX | **due buy in PRE-apertura**: uno sopra il massimo della notte, uno sotto a chiusura del gap; stop sotto; **TP su EMA200 H1** | chiuso al TP (*"non ho voluto rischiare e me la sono chiusa"*), **EUR non dichiarati**; poi **sell** su max del giorno prima + resistenza daily + numero tondo, stop sopra, **esito non dichiarato** | r.247-255 |
| Consuelo | DAX | **long** in pre-apertura al **minimo notte** (EMA200 H1 + EMA50 H4 coincidenti, ordini alle 08:30); poi **short** al **massimo notte** + Supertrend H1 + max giorno prima (un ordine su due eseguito) | *"ho chiuso comunque in profitto"*; host: *"e' entrata bene... si era chiusa bene"*; **EUR non dichiarati** | r.347-351 |
| Marco | DAX (demo) | piano: max/min notte + ORB + Supertrend Invert; stamattina **"gioco in difesa"**, ordini lontani | nessuna operazione dichiarata; l'host: *"decidi di non operare"* | r.21-25, r.63-67 |
| Natti | DAX / oro | DAX: pendenti lasciati e **eseguiti durante la giornata**, tenuti aperti "sbagliando"; oro: **non ha operato** (non stava bene), descrive il piano pendente sopra max notte | esito DAX **non dichiarato** `[TRASCRITTO dubbio]` | r.351, r.381-403 |
| (EURUSD, nome `[NON CHIARO]`, forse Consuelo) | EURUSD M15, **ieri 29/09** | long contro il contesto short, due ordini, chiusa al primo profitto "perche' me la sono fatta sotto" | **+12-13 EUR** | r.351 |
| Valerio (r.175 "Mario"? `[INCERTO]`) | Nikkei + DAX | studio Nikkei (l'host: *"su Japan... non operare"*); poi sul DAX **sell** in alto a fine candela d'impulso, in zona Bollinger "cost to cost" e parte alta del volume profile | non dichiarato | r.181-217 |

Lettura onesta: **tre operatori (Cinzia, Edo, Consuelo) hanno preso un LONG all'apertura o in pre-apertura** (Edo e
Consuelo poi anche uno short su livelli alti), uno era in difesa (Marco), uno ha messo un sell in alto (Valerio). Il DAX e' poi **"fermato"** a un livello gia' toccato due volte
(r.337, r.351). **n = 3-4 persone, un giorno, un regime, nessuna cifra verificabile.**

## 2.5 REGOLE PROP CITATE

**Nessuna. Zero.** Verificato con `grep` (§1.3). La "challenge" e' un esercizio, il limite perdita e' **personale**
("tre stop di fila", "target finanziario", r.311).

## 2.6 NUMERI DI PERFORMANCE

Solo quelli del §2.4 e P9-P10: **tutti `[dichiarato, NON verificato]`**, in EUR su **conto piccolo**, senza campione.
Nessun win rate, nessun profitto mensile, nessuna "challenge passata" dichiarata.

## 2.7 BANDIERE ROSSE

| # | bandiera | citazione che la prova | riga | grado |
|---|---|---|---|---|
| B1 | **Posizione aperta senza stop (temporaneamente), rischio non calcolato** | *"lo stop loss, che ovviamente devo ancora mettere... perche' ho un conto piccolo"*; l'host: *"non hai calcolato il rischio, dov'e'?"* | r.135-137 | **ROSSA PARZIALE** (la fonte la riconosce e la corregge subito; resta la classe "no-SL") |
| B2 | **Ingresso "a sensazione", non da piano** | *"stai andando sulla base di una sensazione. Non e' un piano"* (detto dall'host) | r.157 | arancione |
| B3 | **Controtendenza** (EURUSD long in contesto short; sell su livelli alti con DAX che sale) | *"quando sei in un contesto short e vai long... deve essere veloce"* | r.351 | arancione |
| B4 | **Ordini lasciati aperti oltre il piano / tenuti "sbagliando"** | *"gli ho tre minuti aperti sbagliando... tenere le posizioni aperte e'..."* | r.351 | arancione `[TRASCRITTO dubbio]` |
| B5 | **Troppi indicatori sul grafico** (Fibonacci + box + piu' TF) | *"l'impressione e' di troppa roba"* (host a Natti) | r.361 | ambra |
| B6 | **Vittoria presentata come prova** ("brava... hai portato a casa un risultato" ma "non e' semplice, credi") | l'host stesso relativizza: *"ha portato a casa del profitto, ma... rischiando"* | r.143, r.229 | ambra - **l'host e' piu' severo di noi sul +30 EUR** |

**Trucchi anti-prop: 0.** Niente da documentare come intelligence.

## 2.8 COSA C'ERA A SCHERMO E NON NEL PARLATO (da chiedere a Claudio)

| # | cosa | perche' serve | riga |
|---|---|---|---|
| S1 | **Grafico DAX del mattino** (livelli massimo/minimo della notte, gap, EMA200 H1, Supertrend H1) | senza non si sa **quale** minimo/massimo "della notte" usano: noi usiamo il box 00:00-05:59 IT | r.247-255, r.347-351 |
| S2 | **Il box "nightly" (aree bianche)**: ore del box | e' il confronto diretto con il nostro box notturno | r.353-355 |
| S3 | **Gli statement dei colleghi** (ora di entrata/uscita, size, stop in punti, P&L) | e' l'unico dato **con orari** che esiste per questa giornata: l'host li ha chiesti a tutti (r.17, r.165) | r.17, r.165, r.407 |
| S4 | **Grafico oro con livello 4277 e media 50 weekly** | solo se interessa il long oro in bozza | r.279-281 |
| S5 | **Pannello ordini di Natti (distanze, TP Fibonacci)** | "TP a 31" e "178 punti" sono dubbi | r.351, r.399 |

## 2.9 COSA NE COPIAMO

**Niente come regola, niente come parametro.** Quello che si prende sono **DOMANDE e MISURE** (Parte 5), perche' ogni
numero e' dichiarato, non misurato, e non c'e' una sola soglia IF-THEN completa (P3, P4 e P1 hanno un valore ma non
una regola di costruzione).

---

# PARTE 3 - SCARTI (cio' che non e' estraibile)

- Lo **studio Nikkei/S&P** (r.97-107, r.181-213): analisi discrezionale di livelli senza numeri; `[NON CHIARO]` dove
  stanno i livelli. Resta M11 come meccanismo, senza regola.
- **Analisi weekly/daily** (r.29-61): lettura di grafici; i numeri parlati ("1200", "1800") sono storpiati.
- **Interruzioni tecniche e regia** (r.1-13, r.73-95, r.173-179, r.329-343): zero contenuto.
- Il **piano dell'oro di Natti** (r.381-403) e' un'ipotesi non eseguita: registrato in M20, mai come risultato.

---

# PARTE 4 - LA MAPPA SUI NOSTRI EA

Fonti lette: `mql5/Presets/FTMO/*.set` (7 sedie + Bulge + ORB trial), `docs/PARERE_EMILIANO_2026-09-28.md`,
`report/ANALISI_LIVE_EMILIANO_2026-09-28.md`, `docs/Analisi_EA_DAX.md`, `report/PIANO_PROP.md` (grep mirato, 423 KB),
`backtest_pipeline/REGISTRO_TEST.md` (sezioni MaxMinNotte, Live5m, "REGOLE EMILIANO MONZA"),
`report/audit_ea/SCHEDA_770101_DAX_APERTURA_2026-09-28.md`, `HANDOFF.md`, `report/FTMO_CHALLENGE_CHIUSURA_2026-09-30.md`.
⚠ **`report/PARERE_EMILIANO_2026-09-28.md` NON esiste a quel percorso**: il file e' **`docs/PARERE_EMILIANO_2026-09-28.md`**
(e quel parere riguarda rischio/Guardian/Monte Carlo, **non** gli orari d'ingresso: qui non aggiunge niente di operativo).

## 4.1 Le sedie, in una tabella (orari FTMO -> italiani con l'offset dichiarato dal repo: **FTMO = ora italiana + 1** [LETTO nei preset FTMO]; **nessun orario "della live" e' convertito**)

| sedia (FTMO, rischio 2,00%) | cosa fa [LETTO nel `.set`] | cosa dice la live | coincide / diverge |
|---|---|---|---|
| **`770411` MaxMinNotte DAX SHORT** (GER40.cash M15) | box **00:00-05:59 IT**; **ordine STOP a 08:59 IT** (`InpPlaceHour/Min=9/59` FTMO) fino a **09:30 IT** (`InpEntryCutoff=10:30` FTMO), scadenza 90'; **solo short**; buffer **1000 punti = 10,00 indici** [DERIVATO: Point 0,01]; SL ATR(14)x**2,5** `[INFERITO: InpSLMode=1 = ATR, non riletto dal sorgente]`; **TP1 1R 50% + BE**, TP2 3R, **target EMA200**, finale 4R, trailing ATRx2; filtro correlazione **US500** (EMA 14/100 H1); **un ciclo al giorno** | Marco: *"massimi e minimi della notte, classico"* (r.23-25). Edo/Consuelo: ordini a **massimo/minimo della notte** con confluenze; Natti oro: pendente sopra il max notte. **"Di notte non fai niente"** (r.293) | **COINCIDE**: livelli notte; ordine pendente oltre il livello; **target EMA200** (P1/M8). *Nota: la regola "10 punti oltre il max/min della notte" e' in REGISTRO "REGOLE EMILIANO MONZA" (RICORRENTE); il `770411` nasce da quella metodologia: **non e' una conferma indipendente**.* **DIVERGE**: (a) **solo SHORT, solo ROTTURA**, i colleghi giocano **entrambi i lati e col FADE + confluenza**; (b) ordine armato **un minuto PRIMA della cash**, i colleghi **a 08:30 IT a piccola size** o **dopo** aver letto l'apertura; (c) nessuna confluenza multi-TF nel nostro; (d) **stop 2,5 ATR M15** (63,25 punti il 30/09) contro "stop sopra il massimo del giorno prima" (r.351) |
| **`770101` DAX Apertura LONG** (GER40.cash M5) | range **09:00-09:35 IT** (`InpSessionHour=10`, `InpRangeMinutes=35` FTMO); buffer **5,00**; **RETEST**: BUY LIMIT a rangeHigh - **2,00**, scadenza 120'; SL = rangeLow - 5,00; **TP1 1R 50% + BE**, TP **3R**, **trailing sul minimo M5 precedente**; **nessun filtro acceso**; un ciclo/giorno; chiusura 18:30 IT | ORB come piano (r.19-25, r.151) **senza durata**; ingresso **all'apertura** se parte con decisione (r.111, r.147) | **DIVERGE** sull'**orario**: noi **mai prima delle 09:35 IT**, i colleghi **in pre-apertura o nei primi minuti**. La live e' **ambivalente** sull'ingresso all'apertura: *"nel momento in cui decidi di entrare in apertura perche' vedi che i prezzi partono, ci puo' stare"* (r.131) e subito dopo *"non e' un piano"* (r.157). La durata ORB **non e' un dato di oggi**: non riapre il cancello (35-45' = 8/8 OOS contro 5-15' = 0/8, DIARIO r.54 citato dal referto del 28/09) |
| **`770105` DAX Apertura SHORT** | identica alla `770101` col solo `InpAllowShort=true` | idem | idem; **frequenza `[NON MISURATO]`** (SCHEDA 770101) |
| **ORB `770621` Dow** (trial, US30.cash) | range **16:30-16:45 FTMO = 15:30-15:45 IT** (15'), solo long, filtro EMA200, trailing EMA9/21, **`InpRiskPercent=0.3`** scritto nel `.set` trial (il pacchetto dichiara il rischio non deciso) | oggi **nessuna durata ORB**; il Dow non e' trattato | **NON COMPARABILE oggi**; la live cita ORB solo sul DAX |
| **`771531` EMA200 Dow** (US30.cash H1) | rimbalzo **sull'EMA200 nella direzione del trend**; due LIMIT vicino alla EMA200 (0,2 e 0,3 ATR), SL 1 ATR, TP 2R, **filtro EMA14**; la **conferma multi-timeframe e' dichiarata NON automatizzata** (intestazione `ABTG_EMA200.mq5`) | Consuelo: *"EMA 200 in H1 e EMA 50 in H4 che praticamente coincidono... magari rimbalza"* (r.351); Natti: *"Reversal su EMA200 e Supertrend"* (r.369) | **COINCIDE il meccanismo**; **la live aggiunge esattamente l'ingrediente che il nostro EA lascia fuori: la confluenza fra TF diversi**. E' un asse (M-4), non un parametro |
| **Bulge v5.20 "viola"** (15 cross forex H1, trial) | mean-reversion su **Bollinger "bulge"**, TP = mediana BB, SL ATRx3, BB 20/2 | *"bande di Bollinger orizzontali per fare cost to cost"* (r.23), Bollinger in zona laterale (r.215) | **COINCIDE la famiglia** (bande + ritorno alla media), **DIVERGE il mercato**: noi forex H1, i colleghi **indici al mattino**. Su indici il Bulge **non e' mai stato girato** `[NON VERIFICATO da questa scheda]` |

## 4.2 La coincidenza del 30/09 (la cosa piu' concreta)

| fatto | fonte | etichetta |
|---|---|---|
| `770411` ha **venduto GER40.cash a 25.442,19 alle 09:59:13 ora FTMO**, **stop a 25.505,44 alle 10:03:09 FTMO**, 23,95 lotti, **-1.535,91 EUR** | `HANDOFF.md` (riga "FTMO 541452707, 30/09 ~10:05") | [LETTO nel repo] |
| In ora italiana (FTMO = IT + 1): **08:59:13 e 09:03:09**; distanza dello stop **63,25 punti** | aritmetica sui due numeri sopra | [DERIVATO] |
| "ho visto che hai partito in quarta" (Cinzia long all'apertura) e *"non mi sarei aspettato un rialzo cosi' importante del Darcy"* (host) | r.119, r.223 | [TRASCRITTO] |
| Cinzia, Edo e Consuelo **long** in pre-apertura/apertura, chiusi **al target o "in profitto"** (cifre solo per Cinzia, +30 EUR) | §2.4 | [dichiarato, NON verificato] |
| **Quindi**: la mossa che i colleghi chiamano "partito in quarta" **e' con ogni probabilita' quella che ha stoppato il `770411` a 09:03 IT** | -- | **[INFERITO]**: la trascrizione non ha orari e non nomina il livello; **non e' provato** |

**Contro-esempio costruito prima di consegnare:** se il DAX avesse toccato 25.505,44 alle 09:03 **e poi fosse
rientrato sotto 25.442,19**, la "partenza in quarta" dei colleghi sarebbe un'altra fase della mattina e questa
sezione cade. Si decide con **un grafico M5** (misura M-1), non con un'altra lettura della trascrizione.

**Che cosa NON dice questa coincidenza:** non dice che il `770411` e' rotto (un solo stop non e' il merito; la
contabilita' di casa dice `[NON ANCORA MISURATO]` per tutte le sedie, `FTMO_CHALLENGE_CHIUSURA_2026-09-30.md` §3).
Dice che **la stessa mattina, sullo stesso strumento, due logiche opposte** (la nostra: rottura short del minimo
notte; la loro: long con confluenza) hanno dato esiti opposti: un'osservazione di **un giorno**, che si usa come
domanda.

## 4.3 Il lato "contrario": che cosa e' gia' misurato e che cosa no

- **Rottura LONG del box notturno DAX: MISURATA, morta.** `backtest_pipeline/risultati_archivio/MaxMinNotte/080957cf-valid_MaxMin_D30EUR.csv`
  (72 passate, tick, `InpRiskPercent=1`, correlazione OFF): **SOLO LONG = 18 celle, PF 0,716-0,947, mediana 0,755,
  0/18 sopra 1,00, n 145-173, DD 10,3-24,0%**; **SOLO SHORT = 18 celle, PF 0,991-1,187, 17/18 sopra 1,00, n 101-118**;
  due lati insieme PF 0,828-0,992, 0/18. [MISURATO da me riaprendo il CSV oggi.] **Regola dei due lati: soddisfatta
  per la ROTTURA** (l'ultima volta nel REGISTRO era "unica viva: short").
- **Il FADE del livello notturno con confluenza: NON MISURATO.** E' quello che i colleghi giocano (Consuelo: long
  *al minimo notte* "per prendere il rimbalzo"; Consuelo, Edo e Valerio: short *al massimo notte* o su livelli alti). **Il REGISTRO dice che
  "il fade e' lo specchio del breakout sugli stessi prezzi di scatto: a somma quasi nulla, e paga lo spread due volte.
  Invertire una strategia perdente non e' un meccanismo nuovo"** (lapide FADE POST-NOTIZIA, r.1571-1577).
  **Quindi il fade del massimo notte e' lo specchio della rottura LONG (0/18) e va giudicato SOLO per cio' che la
  confluenza aggiunge, mai per l'inversione in se'.** Questo e' il punto di partenza della misura M-2.

## 4.4 "Cosa fanno dopo uno stop" e "tetti giornalieri"

| aspetto | live | nostro [LETTO nel repo] |
|---|---|---|
| Dopo uno stop sul DAX | **nessuna regola di rientro dichiarata**; chiudere subito se parte contro (r.155); la regola e' di **fermarsi dopo 3 stop di fila** (r.311) | `InpOneTradePerDay=true` su `770101/770105/770411`: **un solo ciclo/giorno per sedia** (piu' severo di "3 di fila") |
| Tetto giornaliero | **target finanziario** di perdita **e anche di guadagno**, **senza valore** (r.311-313) | Guardian: **pausa morbida** perdita giornaliera + cap rischio aperto C1; **stop a obiettivo raggiunto (S1, include v1.40) e freno perdite consecutive (P1, include v1.30): opzionali e SPENTI** (`mql5/Include/ABTG_PausaGuardian.mqh` r.19-45, r.87-93). La trial usa l'include **v1.20** (`PACCHETTO_BULGE_ORB_TRIAL_2026-10-01.md` §1), che per cronologia di versione **non** li ha `[DERIVATO]` |
| 3 SL consecutivi | *"tre stop di fila"* (r.311) | gia' **dentro gli EA**: Bulge `Max_Consecutive_SL=3` e `Max_SL_PerDay=4` e `Max_Daily_Loss_Pct=2.0` (preset trial); `DAX_MASTER_PROP` `InpMaxConsecutiveSL=3`, scope DAILY o CROSSDAY (`docs/Analisi_EA_DAX.md` §5, "stile Emiliano"). **Convergenza non indipendente** (quel codice nasce dalla metodologia Emiliano) |
| Quando NON operare | notte (r.293); giorni in cui non si ha un piano; giornate senza forma; news da guardare (r.351) | News filter **spento** su tutti i `.set` FTMO letti (`InpUseNewsFilter=false`); chiusura venerdi' `InpFridayClose=false` su `771531` |

## 4.5 Dove la live e' piu' severa di noi

L'host critica **l'ingresso senza stop e senza rischio calcolato** (r.135-137, r.157, r.225-227): *"dobbiamo sempre
avere in chiave dove mettere lo stop e dove uscire"*. **E' la stessa disciplina del nostro Guardian e della
`CalcLotByRisk`** (la taglia si adatta allo stop, non il contrario). Nessun divario da colmare qui.

## 4.6 Il parere del 28/09 e questa live

`docs/PARERE_EMILIANO_2026-09-28.md` chiede un **buffer interno piu' conservativo del limite prop** (punto 1) e parla di
rischio di coda, non di orari d'ingresso. Questa live **non lo contraddice e non lo estende**: il suo "limite" e'
personale (tre stop, target giornaliero, r.311-313) e senza cifre. Il fatto del 30/09 lo **conferma dal lato nostro**:
margine al muro **997 EUR** contro uno stop pieno da ~1.500 (`FTMO_CHALLENGE_CHIUSURA_2026-09-30.md` §2 e §5: *"il
margine si misura in STOP PIENI"*). `report/PIANO_PROP.md` non e' stato riletto per intero (423 KB): l'ho usato solo per
cercare le sedie `770411/770101/771531/770105/770621/Bulge` e non ho trovato niente che contraddica la mappa.

---

# PARTE 5 - PROPOSTE DI MISURA (nessuna eseguita, nessuna decisione)

Ordine di valore per **una sedia schierabile**. Per ognuna: **attesa e contro-esempio scritti PRIMA di qualunque
numero**; **costo in tempo macchina** (i round girano **solo sul PC di backtest `DESKTOP-H4D7CAJ`**, mai sul VPS).

### M-1 - "Il 30/09 al minuto" (conferma o smentita della §4.2)
- **Domanda:** il massimo del DAX tra 08:59 e 09:03 IT ha toccato **25.505,44** e la mossa e' continuata?
- **Attesa (scritta ora):** il massimo M5 della candela 09:00-09:05 IT e' **>= 25.505,44** e la candela chiude
  **sopra 25.442,19**.
- **Contro-esempio:** massimo >= 25.505,44 **ma** chiusura M5 sotto 25.442,19 (spike e rientro) => la "partenza in
  quarta" dei colleghi **non** e' quella che ci ha stoppato; la coincidenza e' casuale.
- **Costo:** **zero macchina**. Uno screenshot M5 `GER40.cash` (FTMO) o `D30EUR` (BCM) 08:50-09:30 IT di Claudio,
  **dichiarando il terminale** (FTMO `C:\FTMO`, trial `1514806751`).

### M-2 - Il FADE del livello notturno CON confluenza sul DAX (lato mai misurato)
- **Domanda:** la confluenza (EMA200 H1 / EMA50 H4 vicine al livello, Supertrend H1, max giorno prima) aggiunge
  informazione **oltre** alla pura inversione della rottura?
- **Attesa (scritta ora):** **NO**. Per il lemma del REGISTRO (fade = specchio del breakout a costo doppio) e per
  la rottura LONG gia' morta (0/18), il fade senza confluenza fa **PF < 1,00** alla taglia di casa; **con** la
  confluenza il PF **non supera il controllo casuale a pari frequenza** (il confronto delle lapidi del fade post-notizia, REGISTRO r.1571-1573) di piu' del rumore.
- **Contro-esempio:** una zona **contigua** di celle (non una cella sola, regola "centro dell'altopiano, mai il
  picco") che **batte il controllo casuale a pari frequenza** in **almeno due finestre di regime** con **n >= 40
  per finestra**. Se c'e', il fade con confluenza e' un meccanismo **diverso**, non l'inversione.
- **Limite dichiarato prima:** su ~21 mesi di tick DAX (dal 2024.09.26) la confluenza taglia gli n **sotto 150**:
  il **MERITO resta sospeso** (emendamento A) e si giudica **RISCHIO e frequenza**. Si dichiara anche **l'orologio**:
  BCM e' UTC+1 fisso (`OROLOGIO_BCM_2026-09-24.md`), quindi "le 08:30 IT" e' 07:30 BCM d'estate e 08:30 BCM d'inverno.
- **Costo macchina:** `[NON MISURATO]`. Stima d'ordine `[INFERITO]`: sonda a barre chiuse M5/M15 su M1 del D30EUR
  (Python o EA a candela chiusa), **senza Strategy Tester a tick**, **ore e non giorni** sul PC di backtest. Prima di
  lanciare: cancello + riga, e serve il controllo che **il file M1 del D30EUR copra** 2024.09.26-oggi.
- **Certificato di morte (CLAUDE.md):** non e' un archivio, e' un asse nuovo: **simboli gemelli** (US30/US100 dove
  il livello notte esiste) e **TF** vanno scritti prima del round, non dopo.

### M-3 - `ABTG_CostToCost` su INDICI al mattino (asse SIMBOLI), **costo-first**
- **Domanda:** il "costa a costa" di Larry Williams (range laterale, bande orizzontali) ha senso sul DAX/Dow/Nasdaq
  a M30/H1 nelle prime ore, come dicono Marco (r.23, r.37) e Valerio (r.215)?
- **Attesa (scritta ora):** il **cancello di costo** `stop >= 40 x spread` **non passa** a M30 (in casa **zero**
  motori di classe S su 14 lo passano a M30; il `CostToCost` stesso compare in quella lista con **3,4x** su EURJPY e **2,7x** su GBPCAD,
  REGISTRO r.3004-3010; il TF di quella lista e' M30 per il titolo dell'elenco, **non riletto da me**). Quindi **la misura costo-first chiude da sola** a M30; **H1 e' l'unica banda in dubbio**.
- **Contro-esempio:** se a **H1** (o H4) il rapporto stop/spread su un indice e' **>= 40x** misurato con lo spread
  vero (`PREOPEN_COSTO_*`, SpreadLogger), allora il motore **entra in coda all'imbuto** e si apre un round.
- **Costo:** **zero macchina per il primo passo** (aritmetica su file che esistono: `backtest_pipeline/prove/PREOPEN_COSTO_DAX_M15.txt`
  e gemelli); **solo se passa**, un round come R102/R103 sul PC di backtest, costo `[NON MISURATO]`.
- **Precedente da ricordare:** `CostToCost` XAGUSD **PF 0,70, 6/7 anni negativi, spenta il 24/08**; mediane PF
  **0,713 / 0,755 / 0,655** dai CSV `scan_h1` e `scan_h4` (`AUDIT_USCITE_2026-09-09.md` r.276-277). Il motore **non parte favorito**.

### M-4 - EMA200: confluenza multi-TF e target EMA200 (asse GESTIONE DELL'USCITA / TF)
- **Domanda:** (a) la conferma "EMA200 H1 + EMA50 H4 coincidenti" (Consuelo, r.351) migliora il rimbalzo del
  `771531`? (b) il target su EMA200 H1 (P1/M8) e' applicabile al `770101`?
- **Attesa (scritta ora):** (b) **NO per costruzione**: il `770101` e' un LONG di **rottura con il trend** (prezzo
  sopra il range, spesso sopra l'EMA200), quindi l'EMA200 sta **sotto** il prezzo e **non puo' essere un target**;
  il target EMA200 dei colleghi funziona perche' **entrano contro-EMA200 e la inseguono**. `[INFERITO]`: lo verifico
  con la frazione di ingressi del `770101` con EMA200 H1 **sopra** l'entry.
- **Contro-esempio:** se in **almeno il 30%** dei 193 ingressi OOS l'EMA200 H1 e' **sopra** l'entry e **entro 3R**,
  il target EMA200 ha senso su quel sottoinsieme. `[Il 30% e' una soglia di LETTURA mia, serve solo a decidere se
  vale la pena aprire un round: NON e' un cancello e non entra in nessun criterio.]`
- **Costo:** (b) **zero macchina**: lettura del per-trade della cella R119/R47a (193 posizioni; il file esatto `[NON VERIFICATO da questa scheda]`) + EMA200 H1 del D30EUR, minuti.
  (a) e' **un round vero** (modifica `ABTG_EMA200`: **firma/mql5-ea-developer + cancello**), `[NON MISURATO]`.
- **Stato gia' agli atti da NON rifare:** EMA200 su DAX/Nasdaq corto = **MORTO** (H1 0/56, H4 1/90 rumore, `R234b`);
  la prova TF M30/H2/H3 e' **scritta il 23/09** (`prove/R234b_tf_EMA200SHORT_D30EUR.txt`): **non so se e' girata**
  `[NON VERIFICATO da questa scheda]`. Prima si guarda se R234b ha un esito.

### M-5 - Freno dopo gli stop (P1/S1 del Guardian): MC sulla flotta
- **Domanda:** "3 stop di fila" e "target giornaliero" (r.311-313) cambiano **P(PASS)** della flotta?
- **Attesa (scritta ora):** **poco** sulle sedie DAX, che sono **un ciclo al giorno** (`InpOneTradePerDay=true`):
  "3 di fila" scatta raramente. **Eccezione da guardare**: `771531` ha `InpMaxTradesPerDay=0` (nessun tetto) e
  il 22/09 ha fatto **due stop nello stesso giorno** (`HANDOFF.md`, "771531 22/09 x2"): e' la sedia dove un freno
  "di fila" puo' contare. Il **tetto di guadagno** (S1) toglie invece le code positive.
- **Contro-esempio:** un MC sul per-trade (blocchi di giornata, come v2 di `MC_CON_ORO_E_BLOCCHI`) in cui P1 o S1
  **alzano** P(PASS) di piu' dell'errore di campionamento.
- **Costo:** **minuti, in locale**; ma **la decisione e' una FIRMA di Claudio** (parametro di rischio) e va in coda
  **dopo** il cancello. **Non si tocca il Guardian in campo.**

---

# PARTE 6 - LE DOMANDE PER CLAUDIO (che li conosce di persona)

1. **Gli statement dei colleghi del 30/09** (Cinzia, Edo, Consuelo): *ora di entrata e uscita, size, stop in punti,
   TP, P&L, lato*. L'host li ha chiesti a tutti (r.17, r.165). **E' l'unico dato con orari** e chiude la M-1 senza
   screenshot nostro. Puoi chiederli a Emiliano?
2. **Uno screenshot M5 del DAX 30/09 08:50-09:30 IT** con i livelli notte usati da Edo/Consuelo (S1/S2), dichiarando il
   terminale. Con questo la M-1 si chiude in un minuto.
3. **"Cost to cost"**: Emiliano intende il **costa-a-costa di Larry Williams** (punte di struttura) o il **fade bordo-
   bordo di Bollinger orizzontali**? Con **quale periodo/deviazione** al mattino sugli indici? (Oggi non lo dice;
   nelle live precedenti 37/3 per il DAX giornaliero, 20-22 in laterale: REGISTRO "REGOLE EMILIANO MONZA".)
4. **Pre-apertura 08:30-09:00 IT**: Emiliano la considera **area operativa a piccola size** (come Edo/Consuelo) o
   **no-trade**? Il `770411` arma alle **08:59 IT**: la scelta di quell'orario e' stata fatta **guardando** una sua
   regola o per il vincolo del box?
5. **"Tre stop di fila + target finanziario giornaliero"**: che **cifra** ha in mente per il target (in R, in %, in EUR)?
   E vale anche **al rialzo** (stop in guadagno)? (Serve per capire se S1 e' la stessa cosa.)
6. **Il lato long del fade al minimo della notte** (Consuelo, Edo): ha un **filtro** che lo distingue da "comprare
   ogni minimo"? Edo parla di **gap** e di **chiusura del gap** come confluenza (r.247-249): e' **un filtro** o **il
   motivo**?
7. **"norma" (r.19)** e' ORB? (per "orbo" e "metri 200" = EMA200 l'indicazione c'e' gia'; per "norma" no).

---

## Chiusura

- **Niente e' stato eseguito.** Nessun preset in campo, nessun EA, nessun conto (reale `10105439`, trial
  `1514806751`, ex-challenge `541452707`), nessun parametro di rischio. Nessun numero della live e' diventato criterio.
- Consegnato **un solo file**: questo. Commit per path esplicito, `lavoro`.
- **Dichiarato come ponteggio:** questa e' una **scheda di lettura**, non un avanzamento verso una sedia. L'unica
  voce che puo' avvicinare una sedia schierabile e' **M-1 -> M-2** (il lato mai misurato dello stesso livello su cui
  e' gia' schierata la `770411`), e anche quella **non decide niente finche' non gira sul PC di backtest**.
