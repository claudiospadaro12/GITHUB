# R92b -- RIGA DIAGNOSTICA (R92BAB): CRITERI, scritti PRIMA dei numeri (30/09/2026)

Stato di questo file: **scritto prima di qualunque corsa della riga R92BAB**. Nessun numero di R92BAB esiste.
Se un numero uscito suggerisse un criterio migliore, vale dal round dopo.
**EMENDATO dal cancello (controllo-preventivo) il 30/09/2026, sempre PRIMA di qualunque numero** (classi 996-997): par. 2 (cosa A NON e'),
par. 4 righe 5 e 8, nuovo par. 4-bis (il troncamento si decide dal confronto C/D), par. 7. Le parti emendate sono marcate `[EMENDATO]`.
**EMENDATO dal SECONDO cancello (controllo-preventivo, passaggio indipendente) il 30/09/2026, sempre PRIMA di qualunque numero** (classi 998-1000):
par. 3 (la riga raccoglie il PER-TRADE degli agenti), par. 4 righe 1, 2, 4, 5, 6, 8, nuovo par. 4-ter (ordine di applicazione: ogni vettore ha UNA lettura),
par. 4-bis (niente limbo "debole": o certifica o NON MISURATO; gerarchia delle misure del taglio), par. 5.2, par. 7. Le parti sono marcate `[EMENDATO-2]`.
**EMENDATO dal TERZO cancello (controllo-preventivo) il 30/09/2026, sempre PRIMA di qualunque numero** (classi 1004-1005): par. 3 (simboli ESTRANEI
alla stringa dichiarata e gamba ricavata dalle date), par. 4-ter punto 5 (che cosa vuol dire "discordi") e conteggio, par. 4-bis gerarchia punti 1-3.
Le parti sono marcate `[EMENDATO-3]`.
**EMENDATO dal QUARTO cancello (controllo-preventivo, passaggio indipendente) il 01/10/2026, sempre PRIMA di qualunque numero** (classe 1013; riga
`C30EED9C` e bootstrap `13F9DDEE` NON toccati: gli emendamenti cambiano solo la LETTURA di cio' che la riga gia' stampa): par. 4 righe 2, 3, 4, 7,
nuovo par. 4-quater (i job PARTITI AL LIMITE), par. 5.10-5.11. Le parti sono marcate `[EMENDATO-4]`. La riga cita "il commit che porta questa riga"
(`aa6c2507`): la versione in vigore e' QUESTA, l'ultima sul ramo `lavoro` prima della riga `data:` del riepilogo della corsa.

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

`[EMENDATO-2]` **PER-TRADE DEGLI AGENTI (informativo, non cambia nessuno stato).** Per ogni job Bulge lanciato la riga copia in `PERTRADE\` della raccolta i file
`abtg_trades_ABTG_Bulge_GBPUSD_<magic>_violaEA.csv` di `Common\Files` scritti dopo l'avvio del job (i due magic dell'asse, es. A: 799401 e 799451) e stampa, per file:
deal di uscita, simboli con il loro conteggio, e quanti deal cadono su simboli **OLTRE il 63esimo carattere della stringa DICHIARATA** (A e A2: i 13 da GBPJPY a
CHFJPY; D: NZDUSD, USDCAD, USDCHF, USDJPY, EURGBP; B e C: nessuno, stringhe corte). Questi file li scrivono **gli AGENTI** in `OnTester` (`ABTG_Bulge.mq5`
r.2047-2100): e' la sola misura del taglio che NON passa da `FrameInputs`. IS e OOS hanno lo stesso magic: **sopravvive la gamba OOS** (2026.05.02-2026.06.30).
Che gli agenti locali scrivano davvero li' e' **[MISURATO]** il 28/09 (R250: 12 per-trade su 12, `report/LETTURA_ROUND_CORTI_A_2026-09-28.md`).
`[EMENDATO-3]` **Simboli ESTRANEI (classe 1004).** Il default di `Symbols_List` nell'EA (r.463) e' **proprio il cesto dei 22 cross**. Se l'input non arrivasse
agli agenti e l'EA girasse il default, D (o C, o B) mostrerebbe deal su simboli che **non sono nella sua stringa** e, fra questi, anche su NZDUSD...EURGBP: la
versione precedente della riga avrebbe stampato "taglio a 63 ESCLUSO" per D **proprio mentre D non riceveva la sua stringa**. Ora la riga conta anche i deal
su simboli fuori dalla stringa dichiarata e, se ce n'e' uno, stampa **NESSUNA LETTURA DEL TAGLIO** per quel file. **Su A e A2 questo controllo e' CIECO**
(stringa dichiarata = default): un deal di A oltre il 63esimo carattere prova che gli agenti hanno girato i 22 cross, **non** che li abbiano ricevuti
dall'input. **La gamba (classe 1005)** non si presume: il file lo riscrive ogni gamba (`FILE_WRITE`), e se la OOS muore resta quello della IS; la riga la
ricava dalle date di chiusura (ultima chiusura prima dell'inizio OOS = gamba IS) e, senza chiusure, dichiara che non si ricava. Un file **di una corsa
precedente** con lo stesso magic (scritto prima dell'avvio del job) non si legge.

## 4. LA LETTURA, scritta prima. Condizione di validita': **P = OK** (altrimenti il banco non vale: vedi riga 7).

| # | osservazione | lettura | che cosa succede dopo (NON fatto da questa riga, ognuno vuole una firma) |
|---|---|---|---|
| 1 | B OK, C OK, **D KO**, A KO (A2 KO) | **H_STR**: conta la LUNGHEZZA, non il numero: D ha gli stessi 8 simboli di C e muore solo perche' e' lunga. `[EMENDATO-2]` La soglia sta fra **56 e 153** caratteri e **non e' misurata**: il 63 del forum riguarda il TAGLIO silenzioso, non un blocco. Resta aperta una seconda spiegazione che questa riga non separa: **gli spazi di D** (contenuto, non lunghezza) + un limite di numero su A | EA v5.21 con il cesto in input da **<=55 caratteri** (la lunghezza MISURATA che parte, C: 8+8+6 simboli = tre input) o nel codice (mql5-developer, collaudatore, firma di Claudio); **prima di R92b un job di collaudo della v5.21** col cesto intero, perche' se la spiegazione vera e' la seconda la v5.21 rimuore |
| 2 | B OK, C OK, **D OK**, A KO (A2 KO) | **H_N**: conta il NUMERO dei nomi nella stringa, non la lunghezza. `[EMENDATO-2]` Il meccanismo "22 handle/storici" e' **[NON VERIFICATO] e poco compatibile col guasto**: gli handle si creano in `OnInit` (r.605-607) sugli AGENTI, DOPO che il tester e' inizializzato, mentre il guasto e' nel terminale prima che parta (`OnTesterInit` e' vuoto). La riga 2 dice COSA cambia, non PERCHE'. `[EMENDATO-4]` **E non separa il NUMERO dall'IDENTITA'**: da D ad A entrano 14 simboli NUOVI (EURNZD...CHFJPY); un guasto legato a UNO di loro (**H_SIM**) da' lo stesso vettore. Si scrive "H_N o H_SIM", e la misura della soglia fra 8 e 22 si fa con sotto-cesti che separino le due | spezzare il cesto in sotto-cesti (cambia il tetto unico Max_Trades/kill switch: decisione di Claudio) e misurare la soglia fra 8 e 22 |
| 3 | B OK, **C KO** (D KO, A KO) | ~~soglia del numero <= 8~~ `[EMENDATO-4]` **la soglia sta fra B e C, ma il salto B -> C cambia TRE cose insieme**: il numero (1 -> 8), la lunghezza (6 -> 55 caratteri) e l'identita' (7 simboli nuovi). H_N con soglia <=8, H_STR con soglia fra 7 e 55 e H_SIM su uno dei 7 danno **lo stesso vettore**: nessuna delle tre si dichiara | ~~misurare 2 e 4 simboli~~ `[EMENDATO-4]` "2 e 4 simboli" cambierebbe di nuovo numero e lunghezza insieme: servono un job a **parita' di numero** che cambi solo la lunghezza (riempimento INTERNO: il driver toglie gli spazi in testa e in coda, `walkforward_generico.ps1` r.854 `$v=$resto.Trim()`) e job a **parita' di lunghezza** che cambino l'identita'; poi come riga 2 |
| 4 | **B KO** (P OK) `[EMENDATO-2]` **e nessun altro job Bulge partito** (A, C, D, A2 tutti KO) | **H_ALTRO**: l'EA e' morto anche a un simbolo: il cesto e la stringa non c'entrano. Alternativa residua: stato guastato dal primo KO (A gira prima di B); contro, [MISURATO] il 28/09: dopo il guasto di R258k alle 09:02 le gambe successive sono partite fino alle 09:51. `[EMENDATO-4]` **"L'EA" e' una delle DUE spiegazioni, non la sola**: P differisce dai job Bulge anche per il **grafico del tester** (D30EUR M5 a tick reali contro GBPUSD H1 a Modello 1), quindi P OK **non assolve il grafico**. E i precedenti dicono che il messaggio **non e' proprio di Bulge**: R258k (GBPUSD M5) e R258s (EURUSD) erano **un altro EA** (`ABTG_Londra_ORB`), su grafici forex anche loro, morti con lo stesso messaggio; i job partiti di RFWD erano tutti su indici. Che il colpevole sia il grafico forex **non e' dimostrato** (R258 ha fatto partire molte altre gambe forex): e' una spiegazione aperta, non una lettura. Si scrive "H_ALTRO = EA v5.20 **oppure** grafico GBPUSD H1 / forex" | `[EMENDATO-4]` PRIMA di toccare l'EA, un job con un EA diverso **gia' partito su un grafico forex** messo su **GBPUSD H1, Modello 1** (separa EA da grafico); poi, se e' l'EA: ispezione dell'EA/ex5, ricompilare, confronto col R92 (v5.10) che girava, un lavoro suo |
| 5 | tutti OK (A e A2 compresi) `[EMENDATO-2]` **e A e A2 con Trades>0 in almeno una gamba** (attesi ~8 deal in 4 mesi anche alla frequenza bassa di R92: zero su 22 cross vuol dire che il tester parte ma il cesto non opera -> NON PREVISTO, si leggono i log degli agenti) | `[EMENDATO]` il guasto del 30/09 **non si riproduce NEL BANCO CORTO**. Tre spiegazioni restano aperte e questa riga **non le separa**: stato transitorio del terminale/tester, oppure la **finestra lunga** di R92b0 (4,5 anni), oppure i **cinque input** della cella R92b0. **NON e' "transitorio", NON e' "R92b sbloccato"**, e NON e' provato che fosse la cache (la riga non la svuota). E vale solo se il par. 4-bis dice "cesto intero" | rilancio di R92b con R92b0 **tal quale** per primo: e' lui la replica che qui manca. Se rimuore, il colpevole e' finestra o cella (un job a finestra lunga con la cella AMPIA li separa). Cache da svuotare a mano (solo `Tester\cache`, mai `bases`): scelta di Claudio |
| 6 | A o A2 OK, l'altro KO/MISTO, o D KO con A OK, o C KO con D OK. `[EMENDATO-2]` Anche: **B KO con un qualunque altro job Bulge partito**; **qualunque MISTO** | **non monotono**: nessuna ipotesi H_ regge. `[EMENDATO-2]` NON sempre rumore: **D KO con A OK** ha una spiegazione deterministica (gli SPAZI di D, che A non ha); un **MISTO** puo' essere la FINESTRA (IS e OOS hanno date diverse) | piu repliche prima di qualunque modifica; con D KO e A OK un job D' con un altro riempimento (nessuno spazio) prima di dire "rumore" |
| 7 | **P KO o MISTO** `[EMENDATO-4]` (P NV o NON LANCIATO: vedi lettura) | il tester di questo PC e' guasto ADESSO: **nessun verdetto su A/B/C/D** (sono uscite dallo stesso stato). `[EMENDATO-4]` Con **P NV o NON LANCIATO** (il 4-ter manda qui ogni P diverso da OK) la conseguenza e' la stessa, **nessun verdetto**, ma "guasto" NON si scrive: si scrive **banco NON VERIFICATO** col MOTIVO che la riga stampa per P | rilancio a freddo (terminale e cache: decide Claudio); non si tocca l'EA. `[EMENDATO-4]` **Un rilancio della STESSA riga non e' una replica**: i job gia' partiti trovano le loro passate nella cache del tester (stessi input, stessi magic), non riscrivono il per-trade e possono uscire NV. Si rilancia con magic NUOVI, o dopo aver svuotato `Tester\cache` (scelta di Claudio) |
| 8 | qualunque job OK_TRONCATO | `[EMENDATO]` partito, con la colonna `Symbols_List` del CSV piu' corta: **da sola NON e' una prova di troncamento** (su D a 55 caratteri e' il collasso degli spazi, non un taglio). Si decide col par. 4-bis. `[EMENDATO-2]` Su **A e A2** (nessuno spazio) una colonna piu' corta E' un taglio: il terminale tiene gia' il valore tagliato, e gli agenti non possono riceverne di piu' | se il par. 4-bis conferma il taglio: il cesto da 22 NON puo' viaggiare cosi', anche se A parte |

Gli stati possibili sono piu delle righe (6 job x 5 stati): quelle non elencate **non hanno lettura**, si scrive `NON PREVISTO` e si guardano i log.

## 4-ter. `[EMENDATO-2]` ORDINE DI APPLICAZIONE: ogni vettore STATI ha UNA lettura sola

Senza un ordine le righe si sovrapponevano: `B KO` con A, C, D, A2 partiti cadeva nella riga 4 ("l'EA e' morto anche a un simbolo") mentre 22 cross
erano partiti. Si applica **in quest'ordine, e ci si ferma alla prima che scatta** ("partito" = OK o OK_TRONCATO):
1. P diverso da OK -> **riga 7**.
2. un job Bulge NV o NON LANCIATO -> **NON PREVISTO** (si leggono i log; nessuna H_).
3. un job Bulge MISTO -> **riga 6**.
4. B KO -> **riga 4** se A, C, D, A2 sono tutti KO, altrimenti **riga 6**.
5. A e A2 discordi -> **riga 6**. `[EMENDATO-3]` "Discordi" = **uno partito (OK o OK_TRONCATO) e l'altro KO**; A OK con A2 OK_TRONCATO (o viceversa) NON e'
   "discorde" qui: passa avanti e prende la riga 8 (e il confronto A contro A2 del par. 4-bis dice che il banco non e' deterministico).
6. C KO -> **riga 3** se D, A (e A2) sono KO, altrimenti **riga 6**.
7. D KO -> **riga 1** se A (e A2) sono KO, altrimenti **riga 6**.
8. D OK_TRONCATO -> la causa (righe 1-2) **NON e' decidibile** (par. 5.4), si applica la riga 8.
9. A (e A2) KO -> **riga 2**. Altrimenti: tutti partiti -> **riga 5** alle sue condizioni (A/A2 OK e non OK_TRONCATO, Trades>0, par. 4-bis "cesto intero").
In ogni caso, se c'e' un OK_TRONCATO, **si aggiunge la riga 8**, che su A/A2 prevale sulla 5.
Contato a macchina su tutti i **7.776 vettori con P = OK** (6 stati x 5 job): ognuno riceve **una e una sola** lettura; 6.752 sono `NON PREVISTO`
(un NV o un NON LANCIATO), 977 riga 6, 20 "causa non decidibile", 15 con la riga 8 (`[EMENDATO-3]` ricontato: **12** con OK_TRONCATO su A o A2, dove la riga 8 prevale sulla 5, e **3** con OK_TRONCATO solo su B o C, dove
la riga 5 resta con la riga 8 aggiunta), e le righe 1, 2, 3, 4, 5 scattano ciascuna su un solo vettore
pulito (piu' le varianti con un OK_TRONCATO).
`[EMENDATO-4]` Ricontato a mano dal quarto cancello sullo stesso ordine: 6.752 + 977 + 20 + riga 1 (4) + riga 2 (4) + riga 3 (2) + riga 4 (1) + riga 5 (16, di cui
15 con un OK_TRONCATO: 12 su A/A2, 3 solo su B/C) = 7.776. Torna. Il par. 4-quater qui sotto NON cambia la partizione per stati: aggiunge una
condizione alle righe 1, 2, 3 e 5, come gia' facevano Trades>0 e il par. 4-bis per la riga 5.

## 4-quater. `[EMENDATO-4]` I job PARTITI AL LIMITE: il precursore del guasto si legge, non si butta

Il 30/09 ogni gamba morta ha scritto **cinque** `OnTesterInit works too long...` a ~15,5 s l'uno dall'altro e poi, alla sesta, `Tester cannot be
initialized` (giornale vero, `risultati_archivio/ROUND_RFWD_2026-09-30/LOG_TESTER/0002_Tester_logs_20260930.log` r.4-9). Una gamba che scrive da 1 a 5 di
quelle righe **e poi parte** ha mostrato il guasto ed e' sopravvissuta per pochi secondi: la riga la chiama PARTITA (giusto: e' partita) e stampa il numero
`OnTesterInit works too long: N righe` per job. **Controesempio che rompe le righe senza questo paragrafo**: D parte dopo 5 avvisi, A muore. La riga 2
direbbe "conta il NUMERO, la lunghezza e' innocua" proprio mentre la stringa lunga ha portato D a un passo dal guasto.
**Regola di lettura.** Un job PARTITO con N >= 1 e' **PARTITO AL LIMITE**. Se e' fra quelli che la lettura scelta usa come prova di **innocuita'**
(riga 1: B e C; riga 2: B, C e D; riga 3: B; riga 5: tutti i job Bulge), quella lettura NON si dichiara e si applica la **riga 6** (piu' repliche prima di
qualunque modifica), scrivendo accanto il vettore degli N per job (es. `N: A=6 B=0 C=0 D=3 A2=6`), che e' una misura di DOSE e va nel referto.
Le righe 4, 7 e 8 non cambiano (non poggiano sull'innocuita' di un job partito).

## 4-bis. `[EMENDATO]` IL TRONCAMENTO SI DECIDE DAL CONFRONTO C/D, NON DALLA SOLA COLONNA

La colonna `Symbols_List` del CSV la scrive l'EA in `OnTesterDeinit` (`ABTG_Bulge.mq5` r.2164-2226) con `FrameInputs(pass, ...)`, **nel terminale**, non
negli agenti. Che `FrameInputs` restituisca il valore **visto dagli agenti** (e quindi l'eventuale taglio a 63) e' **[NON VERIFICATO]**: se il terminale
tiene la stringa intera e taglia solo quella spedita agli agenti, la colonna direbbe 153 su un cesto tagliato e la riga scriverebbe **OK** (falso OK).
**Controesempio che rompe la sola colonna**: taglio lato agente + colonna intera = A "OK", riga 5, rilancio di R92b su 9 simboli, senza una riga d'errore.

La misura che non dipende da `FrameInputs` e' **gia' nel disegno**: C e D hanno **gli stessi 8 simboli nello stesso ordine** e l'EA toglie gli spazi
(r.598-599); il magic non entra nelle decisioni (lo garantisce il gemello G1 dentro ogni job: le due passate devono essere identiche al centesimo).
Quindi, senza taglio, **C e D devono dare le STESSE righe** (Trades, Profit, Profit Factor, Equity DD %) in `_IS` e in `_OOS`. Con il taglio a 63,
D arriva con 3 simboli (EURUSD, GBPUSD, AUDUSD) piu' un elemento vuoto (par. 5.5) e `[EMENDATO-2]` differisce da C **solo se C ha operato su almeno uno
dei 5 simboli in coda** (o se il tetto `Max_Trades`/kill switch ha legato i simboli fra loro): un C che ha operato solo su EURUSD/GBPUSD/AUDUSD, o che non
ha operato affatto, da' "identici" **anche col taglio**.
`[EMENDATO-2]` **Come si confronta**: la riga del Pass 0 di C contro la riga del Pass 0 di D, in `_IS` e in `_OOS`, colonne `Trades`, `Profit`, `Profit Factor`,
`Equity DD %`, **esatto sulle cifre stampate** (nessuna tolleranza: stesso motore, stessi dati, determinismo gia' preteso da G1).

| C | D | confronto C/D (CSV) | colonna di D | lettura |
|---|---|---|---|---|
| OK | OK | identici | 153 | `[EMENDATO-2]` **cesto intero a 153 caratteri SOLO SE il PER-TRADE di C mostra almeno un deal su NZDUSD, USDCAD, USDCHF, USDJPY o EURGBP** (oppure quello di D, riga PERTRADE "taglio ESCLUSO"). Altrimenti **[NON MISURATO]**: "identici" senza deal in coda non distingue niente |
| OK | OK | **diversi** | 153 | **la colonna e' SMENTITA** (`FrameInputs` non vede il taglio): gli OK di A e A2 **non certificano** il cesto. Riga 5 non si applica |
| OK | OK_TRONCATO | identici | 55 | **collasso degli spazi** (parser dell'ini), non un taglio: D non e' un test di lunghezza (par. 5.4); righe 1-2 non si decidono |
| OK | OK_TRONCATO | diversi | 63 | **taglio confermato da due misure indipendenti**: riga 8 |
| altro | altro | - | - | la domanda del taglio resta **[NON MISURATO]**: nessun OK di A o A2 certifica il cesto `[EMENDATO-2]` salvo la misura 1 della gerarchia qui sotto (per-trade di A/A2). Rientra qui anche una colonna di D lunga **ne' 153 ne' 55 ne' 63** (es. 62 = spazi ridotti a uno): D non e' stato un test di lunghezza |

Limite del confronto, dichiarato: "identici" prova il cesto intero **solo se in C ha operato almeno uno dei 5 simboli in coda** (NZDUSD, USDCAD,
USDCHF, USDJPY, EURGBP); il CSV di OptFrame non ha la colonna del simbolo. `[EMENDATO-2]` Qui c'era scritto "se C ha pochi Trades (sotto 10) il
confronto si dichiara **debole**": uno stato "debole" non aveva una lettura, e con Trades = 0 "identici" sarebbe passato per "cesto intero". **Tolto**:
o la condizione del deal in coda e' soddisfatta, o il taglio e' **[NON MISURATO]**.
`[EMENDATO-2]` **LA GERARCHIA DELLE MISURE DEL TAGLIO** (la riga ora raccoglie il per-trade, par. 3):
1. **PER-TRADE di A o A2** con un deal su un simbolo oltre il 63esimo carattere (GBPJPY...CHFJPY) -> il cesto di A e' arrivato **intero agli agenti**
   (`[EMENDATO-3]` intero = gli agenti hanno girato i 22 cross; che venissero dall'input e non dal default, identico, A non lo puo' dire: lo dicono 2 e 3). E' la misura
   diretta della domanda che conta per R92b, e prevale su tutte le altre;
2. **PER-TRADE di D** con un deal su NZDUSD...EURGBP `[EMENDATO-3]` **e nessun deal su simboli fuori dalla sua stringa** (riga PERTRADE senza
   "NESSUNA LETTURA DEL TAGLIO") -> nessun taglio a 63 per una stringa di 153 caratteri (vale per A per stessa lunghezza, con la riserva
   del contenuto diverso);
3. **CSV C/D identici + PER-TRADE di C con un deal in coda** `[EMENDATO-3]` (e nessun deal di C o di D fuori dalla stringa dichiarata) -> nessun taglio (la tabella qui sopra);
4. **taglio confermato**: colonna di A/A2 piu' corta (riga 8), oppure C/D diversi con C che ha operato in coda e D che nel per-trade ha SOLO
   EURUSD/GBPUSD/AUDUSD;
5. nessuna delle quattro -> **[NON MISURATO]**, e la riga 5 non si applica.
`[EMENDATO-2]` **Quanto e' probabile restare a [NON MISURATO]** (stima, non misura): alla sola frequenza misurata del motore, R92 = 106 operazioni sui 22
cross in 4,5 anni = **~1,07 per simbolo per anno** (cella base, v5.10; l'AMPIA non e' MAI girata: R92be e' morto con R92b), la gamba OOS di 2 mesi da'
~3,9 deal su A (di cui ~2,3 in coda: probabilita' di zero ~10%) e ~1,4 su C (di cui ~0,9 in coda: zero ~40%). Con l'ipotesi di Claudio (~10,5 per simbolo
per anno) il dubbio sparisce. Se esce [NON MISURATO], la via piu' corta e' **un job A a finestra lunga** (che serve comunque alla riga 5).
Prerequisito: in C e in D le due passate gemelle sono identiche fra loro (G1); se non lo sono, il confronto C/D non vale. Stesso controllo, gratis,
su A contro A2 (stessi input, magic diverso): se partono tutti e due devono essere identici, altrimenti il banco non e' deterministico.

## 5. CONTROESEMPI E LIMITI, dichiarati

1. **A parte ma C no** (riga 3 o 6): ne' H_STR (C e' corta) ne' H_N a soglia alta: o soglia bassa o rumore. Si sceglie guardando B e A2, non a occhio.
2. **D parte, A no, C ok**: e' H_N, NON H_STR. **D KO, C OK**: e' H_STR `[EMENDATO-2]` o gli SPAZI di D (riga 1). **C e D hanno gli stessi simboli**: se differiscono e' la lunghezza, il riempimento (o rumore: A2 lo dice).
3. **Tutti OK non dimostra niente sulla causa**: A e' morto 4 volte su 4 in 12 minuti alle 08:50-09:02; che oggi passi significa che lo stato e' cambiato, non perche'.
4. **Il padding di D puo' essere alterato da MT5** (spazi collassati dal parser dell'ini). Lo si vede subito: `Symbols_List` nel CSV di D deve essere lunga 153; se e' 55 **D non e' un test di lunghezza** e la riga 1/2 non si decide (si scrive NV sulla distinzione, si propone un D' con un altro riempimento).
5. **Se il limite di 63 tronca a 63**, D (14 spazi dopo ogni virgola) diventa `EURUSD,<14 sp>GBPUSD,<14 sp>AUDUSD,<14 sp>`: tre simboli piu uno vuoto. Non e' un difetto del disegno: e' quello che il CSV mostrera' come lunghezza 63, ed e' l'informazione voluta.
6. **B con zero operazioni e' legittimo** (un simbolo, finestra di 4 mesi): per B e per tutti Trades>0 e' informativo; "partito" e' deciso dal giornale e dal CSV fresco, non dai Trades.
7. La riga **NON svuota Tester\cache e NON tocca nessun processo**: il perimetro resta sola lettura + round sul terminale del PC di backtest. La cache e' stata lasciata com'era dopo il 30/09: e' parte dello stato misurato.
8. **Un solo giro** = una sola realizzazione di un guasto che il 28/09 e' sembrato sporadico: A2 e le due gambe per job sono le sole repliche. Nessuna frequenza si ricava da qui.
9. **Non si misura il merito, non si promuove niente, non si propone nessuna taglia.**
10. `[EMENDATO-4]` **Il controllo positivo controlla il TESTER, non il GRAFICO.** P e' un altro EA su un altro simbolo, un altro TF e un altro modello: un
    P OK dice che il tester di questo PC inizializza un frame expert ADESSO, non che lo inizializzi su **GBPUSD H1 a Modello 1**. Per questo la riga 4
    non puo' accusare l'EA da sola (vedi la riga 4). Un controllo positivo che assolva anche il grafico sarebbe un EA gia' partito messo su GBPUSD H1:
    questa riga non ce l'ha, e lo si dichiara invece di supplirlo con la lettura.
11. `[EMENDATO-4]` **Il salto B -> C e' l'unico del disegno che cambia piu' di una variabile senza un job che le separi** (numero, lunghezza, identita'):
    D separa la lunghezza da C, ma solo SOPRA gli 8 simboli. Sotto gli 8 la riga non separa niente, e la riga 3 lo scrive.

## 6. TEMPO E COSTO

**[NON MISURATO].** Riferimenti: RFWD 7 job in 6 minuti (46-61 s per job, tick reali). Un job morto costa ~270 s (R92B del 30/09, driver compreso). Quindi: tutto OK ~6-8 minuti,
tutto KO fino a ~27 minuti. Tetto dichiarato **45 minuti**: i job non lanciati si scrivono NON LANCIATO. Costo in denaro: zero.

## 7. COSA NON PUO' VERIFICARE CHI HA SCRITTO LA RIGA

Windows PowerShell 5.1 reale, MT5, il tester, i tempi, il comportamento del parser dell'ini sugli spazi interni (punto 5.4), se il troncamento a 63 esiste nel build 6230.
`[EMENDATO]` Piu': se `FrameInputs` restituisce il valore visto dagli agenti (par. 4-bis); se la finestra lunga o la cella di R92b0 c'entrano (par. 2, riga 5):
nessun job di questa riga le prova. Il tetto dei 45 minuti si controlla **fra** un job e l'altro: un tester appeso dentro un job non viene interrotto
(il driver aspetta `WaitForExit()` senza tempo massimo, e la riga per scelta non chiude processi).
Il collaudo a macchina (`backtest_pipeline/collaudo_riga_R92BAB/`) gira sotto PowerShell 7 con un driver finto.
`[EMENDATO-2]` Piu': che il per-trade venga scritto anche da una passata di ottimizzazione di un EA multi-simbolo su questo build (misurato solo su EA a un
simbolo, R250); che `""` (l'elemento vuoto dopo un taglio) sia risolto da `iBands`/`SymbolSelect` come il simbolo del grafico; la frequenza vera della cella AMPIA
(mai girata), da cui dipende se il per-trade avra' deal in coda (par. 4-bis, stima).
