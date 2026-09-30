# R92b -- RIGA DIAGNOSTICA (R92BAB): CRITERI, scritti PRIMA dei numeri (30/09/2026)

Stato di questo file: **scritto prima di qualunque corsa della riga R92BAB**. Nessun numero di R92BAB esiste.
Se un numero uscito suggerisse un criterio migliore, vale dal round dopo.

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
  `Symbols_List` ha il default di **153 caratteri**: se il troncamento vale, nel tester arriva `...EURNZD,GBPJP` (63 caratteri, ultimo simbolo INVALIDO).
  Il troncamento da solo **non spiega** il guasto (non blocca nessuno): e' una seconda cosa da misurare, e riguarda la VALIDITA' di R92b anche se il tester parte.

## 2. IL DISEGNO: sei lavori, un solo cambiamento alla volta

Tutti sul PC di backtest DESKTOP-H4D7CAJ, terminale `C:\Program Files\BCM Markets MT5 Terminal` (demo 50503392), in questo ordine, **2 passate per gamba**
(asse tecnico sul magic, come RFWD), `ABTG_Bulge` v5.20 NON modificato, cella = l'AMPIA di R92be (preset AMPIO), Modello 1 (OHLC M1), deposito 10000.
Finestra CORTA per tutti: `@DAQUANDO 2026.03.02 @FINOA 2026.06.30 @FRAZIONEIS 0.5` = 120 giorni, `Meta = 2026.03.02 + floor(120 x 0,5) = 2026.05.01`
(calcolato, non a memoria): IS `2026.03.02-2026.05.01`, OOS `2026.05.02-2026.06.30` (fine esclusiva, classe 992: si verifica sul giornale).
Lo scopo e' vedere se il tester PARTE, non misurare il merito: Trades>0 e' **informativo** (B, con un solo simbolo, puo' legittimamente avere zero operazioni).

| job | file prova | `Symbols_List` | simboli | caratteri | cambia rispetto al precedente |
|---|---|---|---|---|---|
| **P** | `R92BAB_P_controllo_positivo.txt` | (EA diverso) | 1 | - | CONTROLLO POSITIVO: il file di 770101 che oggi ha girato 28 passate, finestra agosto, tick reali, magic nuovi |
| **A** | `R92BAB_A_cross22.txt` | i 22 cross | 22 | 153 | il caso che e' morto il 30/09 |
| **B** | `R92BAB_B_GBPUSD.txt` | `GBPUSD` | 1 | 6 | numero e lunghezza scendono insieme (precedente R92: funzionava) |
| **C** | `R92BAB_C_cross8.txt` | 8 cross | 8 | 55 | sotto il limite dei 63 caratteri |
| **D** | `R92BAB_D_cross8_largo.txt` | **gli stessi 8 cross di C**, 14 spazi dopo ogni virgola | 8 | **153** | SOLO la lunghezza (come A); l'EA toglie gli spazi di ogni simbolo |
| **A2** | `R92BAB_A2_cross22_replica.txt` | i 22 cross | 22 | 153 | REPLICA di A (stessi input, magic diverso) a fine giro |

Perche' D e A2, che non erano nella richiesta a tre (B, C, A): **senza D, A contro C cambia DUE cose** (numero dei simboli e lunghezza) e la lettura
"limite di stringa o di numero" non si separa; con D, C contro D cambia solo la lunghezza e D contro A solo il numero. **Senza A2 un guasto di A a inizio
giro e' indistinguibile da un avviamento difficile del terminale.** Senza P, "tutti falliscono" e' indistinguibile da "il tester di questo PC e' rotto adesso".
Magic nuovi e diversi per ogni job (7994xx, 7995xx): nessuna passata ripescata dalla cache del tester.

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
| 5 | tutti OK (A e A2 compresi) | il guasto del 30/09 **non si riproduce**: stato transitorio del terminale/tester. **NON e' provato che fosse la cache**: la riga non la svuota | rilancio di R92b; cache da svuotare a mano (solo `Tester\cache`, mai `bases`) e' una scelta di Claudio |
| 6 | A o A2 OK, l'altro KO/MISTO, o D KO con A OK, o C KO con D OK | **non monotono**: un guasto non deterministico, non un limite | piu repliche prima di qualunque modifica; nessuna ipotesi H_ regge |
| 7 | **P KO o MISTO** | il tester di questo PC e' guasto ADESSO: **nessun verdetto su A/B/C/D** (sono uscite dallo stesso stato) | rilancio a freddo (terminale e cache: decide Claudio); non si tocca l'EA |
| 8 | qualunque job OK_TRONCATO | partito **ma** col cesto tagliato: per R92b il numero sarebbe su meno simboli (e uno invalido) | vale anche se A parte: il cesto da 22 NON puo' viaggiare cosi' |

Gli stati possibili sono piu delle righe (6 job x 5 stati): quelle non elencate **non hanno lettura**, si scrive `NON PREVISTO` e si guardano i log.

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
Il collaudo a macchina (`backtest_pipeline/collaudo_riga_R92BAB/`) gira sotto PowerShell 7 con un driver finto.
