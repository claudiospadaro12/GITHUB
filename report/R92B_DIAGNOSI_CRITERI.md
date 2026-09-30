# R92b -- RIGA DIAGNOSTICA (R92BAB): CRITERI, scritti PRIMA dei numeri (30/09/2026)

Stato di questo file: **scritto prima di qualunque corsa della riga R92BAB**. Nessun numero di R92BAB esiste.
Se un numero uscito suggerisse un criterio migliore, vale dal round dopo.
**EMENDATO dal cancello (controllo-preventivo) il 30/09/2026, sempre PRIMA di qualunque numero** (classi 996-997): par. 2 (cosa A NON e'),
par. 4 righe 5 e 8, nuovo par. 4-bis (il troncamento si decide dal confronto C/D), par. 7. Le parti emendate sono marcate `[EMENDATO]`.

## 1. IL PROBLEMA, con i fatti letti (non inferiti)

- Il 30/09 i due lanci di R92b (`risultati_archivio/ROUND_R92B_2026-09-30` e `..._secondo`) sono morti sul primo lavoro (R92b0, `ABTG_Bulge` v5.20,
  cesto dei 22 cross): giornale del tester `"ABTG_Bulge.ex5" X64`, dopo ~21 s cinque volte `OnTesterInit works too long...` e poi
  `OnTesterInit works too long. Tester cannot be initialized.`; **per ogni gamba** (IS e OOS), quindi 4 guasti nei due lanci (08:50, 08:52, 08:59, 09:01).
  Mai apparsa la riga `Experts\ABTG_Bulge.ex5 on GBPUSD,H1 from ... to ...`: il tester non e' mai arrivato a partire. Nessun giornale dell'agente.
- Lo stesso giorno (21:02-21:07) RFWD ha girato 7 job su 7 (28 passate, 6 minuti) con EA a UN simbolo e lo stesso driver: il terminale e il driver funzionano.
- L'EA non spiega il guasto da solo: `int OnTesterInit(){return(INIT_SUCCEEDED);}` (`mql5/Experts/ABTG_Bulge.mq5` r.2162), nessuna inizializzazione
  globale pesante (letto: globali = array dinamici e `CTrade`; l'include `ABTG_PausaGuardian.mqh` dichiara funzioni), `OnInit` (r.562) non gira in `OnTesterInit`.
- Precedente NON esclusivo del cesto: il 28/09 R258k e R258s (`ABTG_Londra_ORB`, UN simbolo) hanno perso una gamba con lo stesso messaggio
  (`report/LETTURA_ROUND_CORTI_A_2026-09-28.md`, classe 909). Frequenza di base su questa macchina **[NON MISURATA]**: 2 gambe su un numero non contato.
- Il cesto a 22 simboli **non e' mai girato in ottimizzazione** su questa macchina (R92 era un cross per passata, `prove/R92_scan_BULGE.txt` `Symbols_List=GBPUSD`).
- Limite di stringa: **nei nostri archivi e checklist NON c'e' nessuna misura** (grep su `*.md *.txt *.ps1 *.py`: zero). Fuori dal repo: il forum MQL5
  (<https://www.mql5.com/en/forum/310992>, aprile 2019, risposta di uno sviluppatore MetaQuotes) dice che in OTTIMIZZAZIONE un input `string` e' **troncato a
  63 caratteri** (in un backtest singolo no: `StringLen` 200 contro 63). Comportamento dichiarato: **troncamento silenzioso**, non errore ne' blocco.
  La documentazione (<https://www.mql5.com/en/docs/basis/variables/inputvariables>) da' per la stringa 254 meno la lunghezza del nome (191-253), e dice che gli input
  di tipo string non partecipano all'ottimizzazione come assi. **[DICHIARATO da fonte esterna, NON misurato su questo build 6230]**; il build del 2019 non e' il nostro.
  `Symbols_List` ha il default di **153 caratteri**: se il troncamento vale, nel tester arriva `EURUSD,...,EURNZD,` (63 caratteri = 9 simboli x 7, virgola finale compresa).
  `[EMENDATO]` Qui c'era scritto `...EURNZD,GBPJP` con "ultimo simbolo INVALIDO": **conto sbagliato** (ricontato a macchina: il 63esimo carattere e' la
  virgola dopo EURNZD). Quindi 9 simboli validi **piu' un elemento VUOTO** dopo `StringSplit`; che `iBands("")` lo tratti come il simbolo del grafico
  (GBPUSD due volte) e' **[NON VERIFICATO]**. Con un limite a 64 arriverebbe `...EURNZD,G` (simbolo invalido). Nessuno dei due casi da' un errore.
  Il troncamento da solo **non spiega** il guasto (non blocca nessuno): e' una seconda cosa da misurare, e riguarda la VALIDITA' di R92b anche se il tester parte.

## 2. IL DISEGNO: sei lavori, un solo cambiamento alla volta

Tutti sul PC di backtest DESKTOP-H4D7CAJ, terminale `C:\Program Files\BCM Markets MT5 Terminal` (demo 50503392), in questo ordine, **2 passate per gamba**
(asse tecnico sul magic, come RFWD), `ABTG_Bulge` v5.20 NON modificato, cella = l'AMPIA di R92be (preset AMPIO), Modello 1 (OHLC M1), deposito 10000.
Finestra CORTA per tutti: `@DAQUANDO 2026.03.02 @FINOA 2026.06.30 @FRAZIONEIS 0.5` = 120 giorni, `Meta = 2026.03.02 + floor(120 x 0,5) = 2026.05.01`
(calcolato, non a memoria): IS `2026.03.02-2026.05.01`, OOS `2026.05.02-2026.06.30` (fine esclusiva, classe 992: si verifica sul giornale).
Lo scopo e' vedere se il tester PARTE, non misurare il merito: Trades>0 e' **informativo** (B, con un solo simbolo, puo' legittimamente avere zero operazioni).

| job | file prova | `Symbols_List` | simboli | caratteri | cambia rispetto al precedente |
|---|---|---|---|---|---|
| **P** | `R92BAB_P_controllo_positivo.txt` | (EA diverso) | 1 | - | CONTROLLO POSITIVO: il file di 770101 che oggi ha girato dentro RFWD (4 passate: 2 x 2 gambe, delle 28 di RFWD), finestra agosto, tick reali, magic nuovi. Ha `OnTesterInit`/`OnTesterDeinit` (r.2356/2365): esercita lo STESSO avvio del frame expert su cui muore Bulge |
| **A** | `R92BAB_A_cross22.txt` | i 22 cross | 22 | 153 | `[EMENDATO]` il **cesto** del caso morto il 30/09, **non il caso**: vedi sotto |
| **B** | `R92BAB_B_GBPUSD.txt` | `GBPUSD` | 1 | 6 | numero e lunghezza scendono insieme (precedente R92: funzionava) |
| **C** | `R92BAB_C_cross8.txt` | 8 cross | 8 | 55 | sotto il limite dei 63 caratteri |
| **D** | `R92BAB_D_cross8_largo.txt` | **gli stessi 8 cross di C**, 14 spazi dopo ogni virgola | 8 | **153** | SOLO la lunghezza (come A); l'EA toglie gli spazi di ogni simbolo |
| **A2** | `R92BAB_A2_cross22_replica.txt` | i 22 cross | 22 | 153 | REPLICA di A (stessi input, magic diverso) a fine giro |

Perche' D e A2, che non erano nella richiesta a tre (B, C, A): **senza D, A contro C cambia DUE cose** (numero dei simboli e lunghezza) e la lettura
"limite di stringa o di numero" non si separa; con D, C contro D cambia solo la lunghezza e D contro A solo il numero. **Senza A2 un guasto di A a inizio
giro e' indistinguibile da un avviamento difficile del terminale.** Senza P, "tutti falliscono" e' indistinguibile da "il tester di questo PC e' rotto adesso".
Magic nuovi e diversi per ogni job (7994xx, 7995xx): nessuna passata ripescata dalla cache del tester.

`[EMENDATO]` **COSA A NON E'.** Il job morto il 30/09 e' **R92b0** (`prove/R92b0_controllo_offset0.txt`), non R92be. A ne prende il **cesto** (stessa
`Symbols_List` di 153 caratteri) ma cambia, rispetto a R92b0, **due cose in piu'**: (1) la **finestra**, 2022.01.01-2026.06.30 con `@FRAZIONEIS 0.7275`
(4,5 anni) contro 2026.03.02-2026.06.30 (4 mesi); (2) **cinque input di cella** (verificato con diff: `Bulge_Multi` 1.1->1.0, `Use_Orange` 0->1,
`Signal_Bar_Offset` 0->1, `Use_ATR_Filter` 1->0, `Use_ADX_Filter` 1->0, piu' `InpComment` BULGE->BULGE_V520A). Quindi **A2 replica A, non R92b0**:
in questa riga **non c'e' nessuna replica del caso che ha fallito**. Conseguenza sulla lettura: un A che MUORE riproduce il guasto nel banco corto
(e le righe 1-4 valgono, "nel banco corto"); un A che PARTE **non dice** che il guasto fosse transitorio (riga 5).

## 3. COSA LEGGE LA RIGA (per job) e COME DECIDE lo stato

Dal giornale del tester (`*Tester_logs*`, UTF-16, UNO PER GIORNO: si leggono solo le righe DOPO l'avvio della riga, data dal nome del file, ora ai millisecondi,
classe 940; giornale assente o vuoto = NON VERIFICABILE, mai "nessuna riga"): una **gamba** comincia a ogni riga `"<EA>.ex5" X64` e si attribuisce al job
che era in corso a quell'ora. Per ogni gamba: partita (riga `Experts\<EA>.ex5 on SIMBOLO,TF from ... to ...`) oppure guasto (`OnTesterInit works too long`
contate, e `Tester cannot be initialized`). Dal CSV di OptFrame: righe, Trades>0, e la colonna **`Symbols_List` come l'ha VISTA il tester** (lunghezza contro attesa).

| stato del job | regola |
|---|---|
| **OK** | 2 gambe su 2 partite, CSV `_IS` e `_OOS` freschi con 2 righe, `Symbols_List` del CSV lunga quanto la dichiarata |
| **OK_TRONCATO** | come OK, ma `Symbols_List` nel CSV **piu corta** della dichiarata: il tester e' partito **col cesto tagliato** (il forum MQL5 lo dice: 63) |
| **KO** | 2 gambe su 2 morte con `Tester cannot be initialized` |
| **MISTO** | una gamba partita e una morta (guasto non deterministico) |
| **NV** | giornale non verificabile; numero di gambe attribuite al job diverso da 2, o gamba con il nome di un altro EA; log e CSV in contraddizione (partita senza CSV completi, morta con CSV fresco); `Symbols_List` del CSV assente o piu LUNGA della dichiarata; rc 1 del driver; motore (SHA256 di EA, include, driver di walk-forward) o file prova diversi dal pin |
| **NON LANCIATO** | tetto di tempo superato |

La finestra girata si legge dalla riga `from ... to ...` e si confronta con la dichiarata (IS `2026.03.02-2026.05.01`, OOS `2026.05.02-2026.06.30`;
P: `2026.08.03-2026.08.17` e `2026.08.18-2026.09.01`): se differisce la riga lo scrive, la gamba resta comunque "partita" e il lettore ne tiene conto (classe 992).
La riga stampa anche un vettore compatto `STATI: P=.. A=.. B=.. C=.. D=.. A2=..` e **non emette nessun verdetto**: l'applicazione della tabella qui sotto e' lettura.

## 4. LA LETTURA, scritta prima. Condizione di validita': **P = OK** (altrimenti il banco non vale: vedi riga 7).

| # | osservazione | lettura | che cosa succede dopo (NON fatto da questa riga, ognuno vuole una firma) |
|---|---|---|---|
| 1 | B OK, C OK, **D KO**, A KO (A2 KO) | **H_STR**: conta la LUNGHEZZA (oltre ~63 c.), non il numero: D ha gli stessi 8 simboli di C e muore solo perche' e' lunga | `Symbols_List` non puo' viaggiare come unica stringa lunga: EA v5.21 con il cesto in tre input da <=63 c. o nel codice (mql5-developer, collaudatore, firma di Claudio); poi R92b |
| 2 | B OK, C OK, **D OK**, A KO (A2 KO) | **H_N**: conta il NUMERO dei simboli (22 handle/storici), non la lunghezza | spezzare il cesto in sotto-cesti (cambia il tetto unico Max_Trades/kill switch: decisione di Claudio) e misurare la soglia fra 8 e 22 |
| 3 | B OK, **C KO** (D KO, A KO) | soglia del numero **<= 8** | misurare 2 e 4 simboli; poi come riga 2 |
| 4 | **B KO** (P OK) | **H_ALTRO**: l'EA e' morto anche a un simbolo: il cesto e la stringa non c'entrano | ispezione dell'EA/ex5: ricompilare, confronto col R92 (v5.10) che girava, un lavoro suo |
| 5 | tutti OK (A e A2 compresi) | `[EMENDATO]` il guasto del 30/09 **non si riproduce NEL BANCO CORTO**. Tre spiegazioni restano aperte e questa riga **non le separa**: stato transitorio del terminale/tester, oppure la **finestra lunga** di R92b0 (4,5 anni), oppure i **cinque input** della cella R92b0. **NON e' "transitorio", NON e' "R92b sbloccato"**, e NON e' provato che fosse la cache (la riga non la svuota). E vale solo se il par. 4-bis dice "cesto intero" | rilancio di R92b con R92b0 **tal quale** per primo: e' lui la replica che qui manca. Se rimuore, il colpevole e' finestra o cella (un job a finestra lunga con la cella AMPIA li separa). Cache da svuotare a mano (solo `Tester\cache`, mai `bases`): scelta di Claudio |
| 6 | A o A2 OK, l'altro KO/MISTO, o D KO con A OK, o C KO con D OK | **non monotono**: un guasto non deterministico, non un limite | piu repliche prima di qualunque modifica; nessuna ipotesi H_ regge |
| 7 | **P KO o MISTO** | il tester di questo PC e' guasto ADESSO: **nessun verdetto su A/B/C/D** (sono uscite dallo stesso stato) | rilancio a freddo (terminale e cache: decide Claudio); non si tocca l'EA |
| 8 | qualunque job OK_TRONCATO | `[EMENDATO]` partito, con la colonna `Symbols_List` del CSV piu' corta: **da sola NON e' una prova di troncamento** (su D a 55 caratteri e' il collasso degli spazi, non un taglio). Si decide col par. 4-bis | se il par. 4-bis conferma il taglio: il cesto da 22 NON puo' viaggiare cosi', anche se A parte |

Gli stati possibili sono piu delle righe (6 job x 5 stati): quelle non elencate **non hanno lettura**, si scrive `NON PREVISTO` e si guardano i log.

## 4-bis. `[EMENDATO]` IL TRONCAMENTO SI DECIDE DAL CONFRONTO C/D, NON DALLA SOLA COLONNA

La colonna `Symbols_List` del CSV la scrive l'EA in `OnTesterDeinit` (`ABTG_Bulge.mq5` r.2164-2226) con `FrameInputs(pass, ...)`, **nel terminale**, non
negli agenti. Che `FrameInputs` restituisca il valore **visto dagli agenti** (e quindi l'eventuale taglio a 63) e' **[NON VERIFICATO]**: se il terminale
tiene la stringa intera e taglia solo quella spedita agli agenti, la colonna direbbe 153 su un cesto tagliato e la riga scriverebbe **OK** (falso OK).
**Controesempio che rompe la sola colonna**: taglio lato agente + colonna intera = A "OK", riga 5, rilancio di R92b su 9 simboli, senza una riga d'errore.

La misura che non dipende da `FrameInputs` e' **gia' nel disegno**: C e D hanno **gli stessi 8 simboli nello stesso ordine** e l'EA toglie gli spazi
(r.598-599); il magic non entra nelle decisioni (lo garantisce il gemello G1 dentro ogni job: le due passate devono essere identiche al centesimo).
Quindi, senza taglio, **C e D devono dare le STESSE righe** (Trades, Profit, Profit Factor, Equity DD %) in `_IS` e in `_OOS`. Con il taglio a 63,
D arriva con 3 simboli (EURUSD, GBPUSD, AUDUSD) piu' un elemento vuoto (par. 5.5) e **deve** differire da C.

| C | D | confronto C/D (CSV) | colonna di D | lettura |
|---|---|---|---|---|
| OK | OK | identici | 153 | **cesto intero a 153 caratteri**: vale anche per A e A2 (stessa lunghezza). Colonna e confronto concordano |
| OK | OK | **diversi** | 153 | **la colonna e' SMENTITA** (`FrameInputs` non vede il taglio): gli OK di A e A2 **non certificano** il cesto. Riga 5 non si applica |
| OK | OK_TRONCATO | identici | 55 | **collasso degli spazi** (parser dell'ini), non un taglio: D non e' un test di lunghezza (par. 5.4); righe 1-2 non si decidono |
| OK | OK_TRONCATO | diversi | 63 | **taglio confermato da due misure indipendenti**: riga 8 |
| altro | altro | - | - | la domanda del taglio resta **[NON MISURATO]**: nessun OK di A o A2 certifica il cesto |

Limite del confronto, dichiarato: "identici" prova il cesto intero **solo se in C ha operato almeno uno dei 5 simboli in coda** (NZDUSD, USDCAD,
USDCHF, USDJPY, EURGBP); il CSV di OptFrame non ha la colonna del simbolo. Se C ha pochi Trades (sotto 10) il confronto si dichiara **debole**. La terza
misura, a mano e non raccolta da questa riga, sono i per-trade `abtg_trades_ABTG_Bulge_GBPUSD_<magic>_violaEA.csv` in `Common\Files` del PC di
backtest (colonna `symbol`, scritti dagli AGENTI; sopravvive la gamba OOS): un deal su un simbolo oltre il 63esimo carattere esclude il taglio.
Prerequisito: in C e in D le due passate gemelle sono identiche fra loro (G1); se non lo sono, il confronto C/D non vale. Stesso controllo, gratis,
su A contro A2 (stessi input, magic diverso): se partono tutti e due devono essere identici, altrimenti il banco non e' deterministico.

## 5. CONTROESEMPI E LIMITI, dichiarati

1. **A parte ma C no** (riga 3 o 6): ne' H_STR (C e' corta) ne' H_N a soglia alta: o soglia bassa o rumore. Si sceglie guardando B e A2, non a occhio.
2. **D parte, A no, C ok**: e' H_N, NON H_STR. **D KO, C OK**: e' H_STR. **C e D hanno gli stessi simboli**: se differiscono e' la lunghezza (o rumore: A2 lo dice).
3. **Tutti OK non dimostra niente sulla causa**: A e' morto 4 volte su 4 in 12 minuti alle 08:50-09:02; che oggi passi significa che lo stato e' cambiato, non perche'.
4. **Il padding di D puo' essere alterato da MT5** (spazi collassati dal parser dell'ini). Lo si vede subito: `Symbols_List` nel CSV di D deve essere lunga 153; se e' 55 **D non e' un test di lunghezza** e la riga 1/2 non si decide (si scrive NV sulla distinzione, si propone un D' con un altro riempimento).
5. **Se il limite di 63 tronca a 63**, D (14 spazi dopo ogni virgola) diventa `EURUSD,<14 sp>GBPUSD,<14 sp>AUDUSD,<14 sp>`: tre simboli piu uno vuoto. Non e' un difetto del disegno: e' quello che il CSV mostrera' come lunghezza 63, ed e' l'informazione voluta.
6. **B con zero operazioni e' legittimo** (un simbolo, finestra di 4 mesi): per B e per tutti Trades>0 e' informativo; "partito" e' deciso dal giornale e dal CSV fresco, non dai Trades.
7. La riga **NON svuota Tester\cache e NON tocca nessun processo**: il perimetro resta sola lettura + round sul terminale del PC di backtest. La cache e' stata lasciata com'era dopo il 30/09: e' parte dello stato misurato.
8. **Un solo giro** = una sola realizzazione di un guasto che il 28/09 e' sembrato sporadico: A2 e le due gambe per job sono le sole repliche. Nessuna frequenza si ricava da qui.
9. **Non si misura il merito, non si promuove niente, non si propone nessuna taglia.**

## 6. TEMPO E COSTO

**[NON MISURATO].** Riferimenti: RFWD 7 job in 6 minuti (46-61 s per job, tick reali). Un job morto costa ~270 s (R92B del 30/09, driver compreso). Quindi: tutto OK ~6-8 minuti,
tutto KO fino a ~27 minuti. Tetto dichiarato **45 minuti**: i job non lanciati si scrivono NON LANCIATO. Costo in denaro: zero.

## 7. COSA NON PUO' VERIFICARE CHI HA SCRITTO LA RIGA

Windows PowerShell 5.1 reale, MT5, il tester, i tempi, il comportamento del parser dell'ini sugli spazi interni (punto 5.4), se il troncamento a 63 esiste nel build 6230.
`[EMENDATO]` Piu': se `FrameInputs` restituisce il valore visto dagli agenti (par. 4-bis); se la finestra lunga o la cella di R92b0 c'entrano (par. 2, riga 5):
nessun job di questa riga le prova. Il tetto dei 45 minuti si controlla **fra** un job e l'altro: un tester appeso dentro un job non viene interrotto
(il driver aspetta `WaitForExit()` senza tempo massimo, e la riga per scelta non chiude processi).
Il collaudo a macchina (`backtest_pipeline/collaudo_riga_R92BAB/`) gira sotto PowerShell 7 con un driver finto.
