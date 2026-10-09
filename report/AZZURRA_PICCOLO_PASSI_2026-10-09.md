# AZZURRA SUL PICCOLO 50503392: i passi a mano dopo la copia (09/10/2026)

**Decisione di Claudio, 09/10:** _"Lascia i default [domande 1-5 e candela di test: solo corpo, com'e' ora],
rischio Azzurra 0,5%, e proviamolo nel conto DEMO PICCOLO 50503392, NON nel conto della trial."_

Stato al momento della scrittura: **preparato, NON ancora passato dal cancello** (controllo-preventivo +
verificatore-stringhe + lettore indipendente). Finche' non c'e' il PASS, niente di questo esce verso il VPS.
**controllo-preventivo (strato 2) 09/10: FAIL corretto qui**, in modo mirato (avvisi 1, 2, 5, nuovo 6 sulla trial
FTMO viva; bersaglio dei passi 2-4; grafico EURGBP invece di EURUSD; righe ERR attese a secco; proprieta' da menu;
ora dell'accensione; NON VERIFICATO). **Lettore indipendente 09/10: riga e script PASS** (SHA al pin
riscaricato = quello dichiarato, cancello deterministico verde, 8 contro-esempi eseguiti su banco); su questa
pagina tre aggiunte mirate (stato della trial per pesare A/B/C, passo 4 secondo la scelta, ORB CADCHF della
trial e banco fra i NON VERIFICATI). Il passo 4 aspetta la scelta A/B/C di Claudio (avviso 6).

---

## 0. Cosa c'e' nel pacchetto

| file | ruolo | SHA256 |
|---|---|---|
| `mql5/Experts/ABTG_BulgeAzzurra.mq5` (pin `31a11096`) | l'EA, **non toccato** | `b6b06347f6f73b4e0f8de508087e48d089b911ee4ccac250f8beb8be032a926b` |
| `mql5/Presets/sedie_piccolo/ABTG_BulgeAzzurra_piccolo_demo.set` | il preset del piccolo | `9f6492b92746ca464adc58a32a252d81a480de759237aac3531c037179e38a4d` |
| `backtest_pipeline/righe/SCHIERA_AZZURRA_PICCOLO.ps1` | lo script SOLO COPIA | `c09b39335c517de727d1f794ad8d5dbff525b21add3b2b461a1410d7066d0f3c` (v2, pin `81ebc5e8`) |
| `backtest_pipeline/righe/RIGA_SCHIERA_AZZURRA_PICCOLO.txt` | la riga da incollare (pin `81ebc5e8`) | vedi `git` |

**Il preset** = default dell'EA, confrontati a macchina **54 input su 54** (nessun nome in piu', nessuno in
meno), con **una sola** differenza voluta: `Risk_Percent` **0.8 -> 0.5**. Rispetto al modello
`ABTG_Bulge_v520_piccolo_SOLO_VIOLA.set` cambiano: `Use_Purple` true->false, `Use_Azure`=true (nuovo),
`Azure_MaxRetraceRangeATR`=1.5 e `Azure_FirstTouchOnly`=false (nuovi, = default: "solo corpo, ogni tocco"),
`ADX_Apply_On_Azure`=false (nuovo), `Risk_Percent` 0.8->0.5, `InpMagic` 772700->**774500**,
`InpComment` BULGE_V520->**BULGE_AZZURRA**, e `Use_ADX_Filter` false->**true** (default dell'EA:
**non cambia niente per l'AZZURRA**, perche' `ADX_Apply_On_Azure=false` e i segnali BLU/VIOLA/ARANCIO sono
spenti; costa solo 22 handle ADX in piu'). `Symbols_List` = gli stessi 22 cross del preset Bulge.
`Max_Trades=4` e' il default: **4 x 0,5% = 2,0% di rischio aperto** per questa istanza.
Commento ordini: prefisso 13 caratteri, il piu' lungo e' `BULGE_AZZURRA_AZZURRA_L` = **23 < 31** (regola
della specifica: prefisso <= 21).

---

## AVVISI IN CHIARO (da leggere PRIMA del passo 1)

1. **Rischio aperto delle due Bulge sul piccolo: 5,2%.** Bulge 772700 (VIOLA; se il BLU sia ancora acceso e'
   NON VERIFICATO, il numero non cambia) 4 x 0,8% = 3,2% + Azzurra 774500 4 x 0,5% = 2,0%. Magic diversi: la
   Bulge e l'Azzurra non si contano a vicenda (Max_Trades, doppioni e kill switch filtrano per magic).
   E' **sopra il cap C1 firmato (3,25%)**, che sul piccolo comunque **non lo applica nessuno**. Claudio lo sa e
   l'ha deciso il 09/10. E le altre sedie del piccolo si **sommano** a questo numero.
   Per ordine di grandezza (sonda `CODA_01` del 09/10 03:30, profilo ORO, **28 sedie**): la somma dei campi
   `rischio` delle altre sedie del piccolo, una posizione ciascuna, fa **circa 19%** (BreakingBand 3 x 1,0;
   GapFill 3 x 1,0; PunteLarry 3,8; PostNews 3 x 1,3; e le altre); con le due Bulge **circa 24%**. Unita' del
   campo non verificata EA per EA: e' un ordine di grandezza, non una misura. Ultimo saldo letto del piccolo:
   **5.430,99 EUR** (30/09, HANDOFF).
2. **Kill switch giornaliero PER ISTANZA, non per conto.** Ogni EA conta solo i SUOI deal chiusi (filtro sul
   magic) della giornata server: si ferma a **4 SL nel giorno**, **3 SL consecutivi** o **perdita chiusa >= 2%**
   (conta come "SL" ogni chiusura in perdita, anche un TP sotto la commissione). Il kill switch **blocca i NUOVI
   ingressi**, non chiude le posizioni aperte, e **non guarda il flottante**. Quindi la giornata peggiore NON e'
   2% per istanza: quando scatta, possono restare aperte **fino a 3 posizioni** (Max_Trades 4 meno quella appena
   chiusa), che possono andare a stop dopo. Limite da codice, a stop di 1 R esatto e senza gap: **Azzurra circa
   3,5%** (4 SL x 0,5 + 3 aperte x 0,5) e **Bulge 772700 circa 5,6%** (4 SL x 0,8 + 3 x 0,8), cioe' **fino a
   circa 9% lordo in un giorno per le due Bulge insieme** (le vincite intercalate lo riducono; gap e slittamento
   sullo stop lo aumentano). Fatto dal codice (r.1121-1180), non misurato in campo.
   _(Correzione del controllo-preventivo 09/10: qui c'era scritto "circa 4%", che contava solo il 2% di soglia
   per istanza e dimenticava le posizioni ancora aperte quando il kill switch scatta.)_
3. **Sul piccolo NON gira nessun Guardian.** `InpUsaGuardian=true` resta acceso per standard di casa, ma senza
   Guardian e' **fail-open**: niente pausa B1, niente cap C1. Lo script **non** porta il Guardian ne' l'include.
4. **L'Azzurra NON e' MAI stata compilata in MetaEditor** (ne' backtestata). Il collaudo 63/63 prova la logica a
   tavolino. **Se F7 da' anche un solo errore: NON attaccare niente, riporta gli errori.**
5. Da sapere (non misurato): Azzurra e Bulge VIOLA girano sugli **stessi 22 cross** dello stesso conto. La VIOLA
   entra **contro** l'impulso, l'Azzurra **a favore**: sullo stesso cross possono trovarsi aperte in versi
   opposti (il conto e' hedging, quindi e' permesso). Si vede dai magic. Plausibilmente raro (tutte e due escono
   alla mediana, e per aprire dalla banda opposta il prezzo deve attraversarla), ma non misurato. Stesso conto,
   stessa famiglia di meccanismo: `ABTG_BreakingBand` (772161-772163, continuazione) gira gia' su GBPUSD, EURUSD,
   AUDUSD del piccolo, e li' l'Azzurra puo' **raddoppiare** lo stesso ingresso.
6. **LA TRIAL FTMO 1514806751 (`C:\FTMO`) E' VIVA e la Bulge VIOLA della trial (magic 772720) gira su 15 dei 22
   cross dell'Azzurra** (preset `ABTG_Bulge_v520_SOLO_VIOLA_FTMO_TRIAL.set`: NZDUSD, USDCAD, USDCHF, EURGBP, EURNZD,
   GBPAUD, GBPNZD, AUDJPY, AUDCAD, AUDNZD, NZDJPY, NZDCAD, NZDCHF, CADJPY, CADCHF). Giornale della trial,
   sonda `CODA_09` del 09/10 03:30: Guardian `stato=OK pausa=off`, rischio aperto 1,61%, scade il 14/10.
   La regola scritta dal supporto FTMO (`PIANO_FREE_TRIAL_FTMO_2026-09-30.md` par. 3, punto 8) vieta posizioni
   **OPPOSTE fra conti diversi**, anche demo di un altro broker, anche su strumenti **correlati**, senza soglia,
   anche se accidentali; che valga per la Free Trial e' [NON MISURATO] e la casa la tratta come SI'. La VIOLA
   entra **contro** l'impulso, l'Azzurra **a favore**: accendere l'Azzurra sui 22 cross **aggiunge occasioni di
   posizioni opposte con la trial** (stesso cross raro per la ragione del punto 5; cross correlati, es. AUD/NZD/CAD,
   non stimato). E' lo stesso tema gia' aperto dal 01/10 per la Bulge 772700 del piccolo (HANDOFF, "Decisioni
   aperte": pausa o ridotto ai 7 cross comuni), che Claudio non ha ancora chiuso.
   **Per pesare la scelta** (aggiunto dal lettore indipendente, 09/10): la trial **non puo' piu' raggiungere
   l'obiettivo** (+8.000: servivano +22.916,29 l'08/10, `FTMO_TRIAL_AUTOPSIA_2026-10-08.md`) ed e' viva **sul filo**:
   Guardian sbloccato l'08/10 con `InpTotalDDPct 9.9` (pavimento 144.160, `PRIORITA_EA_E_DA_FARE_2026-10-08.md`),
   muro FTMO a 144.000, equity **147.248,38** il 09/10 03:30 (`CODA_09`) = circa **3.250 EUR** dal muro. Quindi
   quello che l'opzione A mette in gioco **non e' l'esito della trial** (gia' deciso dall'obiettivo) ma una
   violazione della regola dell'hedging registrata da FTMO a nome di Claudio, con conseguenze sulle prossime
   challenge **[NON MISURATO]** (la domanda al supporto non e' mai stata chiusa).
   **DOMANDA A CLAUDIO, PRIMA DEL PASSO 4** (il passo 0-3 non apre posizioni):
   - **A.** accendere subito sui 22 cross, accettando il rischio sulla trial fino al 14/10;
   - **B.** fare il passo 3 (autotest) ora e il **passo 4 dopo il 14/10** (trial scaduta): zero rischio, costa
     ~5 giorni di forward;
   - **C.** `Symbols_List` ridotta ai 7 cross che la trial NON ha (EURUSD, GBPUSD, AUDUSD, USDJPY, GBPJPY, GBPCAD,
     CHFJPY): cambia un default -> preset nuovo, riga nuova, cancello di nuovo; resta la correlazione fra cross
     diversi.
   Finche' Claudio non sceglie, **il passo 4 non si fa.**

---

## PASSO 0: la riga di copia

**Bersaglio:** finestra PowerShell sul VPS `VMI3047753`, **sessione Windows Administrator** (quella dove girano
i terminali). Scrive **solo** nella cartella dati del terminale del conto DEMO PICCOLO **50503392**
(`C:\Program Files\BCM Markets MT5 Terminal`, cartella dati `215D85D767A1C39E22D242C8114BF9F5`), sottocartelle
`MQL5\Experts` e `MQL5\Presets`, piu' il Desktop del VPS.
**Non tocca:** FTMO challenge 541452707 e trial 1514806751 (`C:\FTMO`), 100k 50504263 (`...MT5 Terminal -V3`), REALE 10105439
(`C:\BCM_Reale`), manuale 50503635 (`C:\MT5_MANUALE`), banco 50504400 (`C:\MT5_Backtest`), Pepperstone, Tickmill.

La riga e' in `backtest_pipeline/righe/RIGA_SCHIERA_AZZURRA_PICCOLO.txt` (una riga sola, pin `81ebc5e8`; v1 al pin `c00eb8c3` superata dal cancello del 09/10: mancava la trial 1514806751 fra i rifiuti e la sessione Administrator non era inchiodata). Il
terminale 50503392 **puo' e deve restare APERTO**: la riga non compila e non tocca processi, e le serve vederlo
vivo per certificarlo. Uscite:
- **0** = i 2 file sono nel terminale 50503392 e gli include per F7 ci sono -> passo 1;
- **2** = copiati, ma `ABTG_PausaGuardian.mqh` o `Trade.mqh` del terminale non tornano -> **F7 dara' errori: fermarsi**, mandare lo zip;
- **1** = FERMO (nessuna scrittura) -> mandare lo zip `Desktop\SCHIERA_AZZURRA_PICCOLO_<data>.zip`.

Le serrature dello script (provate su un banco simulato, 19 scenari su 19 come attesi): UN solo terminale col
titolo che comincia per 50503392, proprietario = utente della sessione (da Master scatta: la copia sotto
Master e' MORTA, 03/09), origin.txt = cartella di quell'eseguibile, nome cartella = `215D85...` del censimento,
`bases\BCMMarkets-Server`, giornale che nomina 50503392 e **nessuno** di FTMO / 541452707 / 1514806751 / 10105439 /
50504263 / 50503635 / 50504400 / Pepperstone / Tickmill. Un file gia' presente e **diverso** = FERMO, mai
sovrascritto.

---

## PASSO 1: riconoscere la finestra giusta (FATTO STAMPATO, non a occhio)

**Bersaglio:** finestra PowerShell sul VPS `VMI3047753`, sessione Administrator. **Sola lettura**: non apre,
non chiude e non tocca nessun terminale.

```powershell
Get-Process terminal64 | select Id, MainWindowTitle, Path
```

La riga che conta e' quella con il titolo della finestra che **comincia per `50503392`** e con il percorso
del programma nella cartella del piccolo, cioe' la cartella BCM **senza** il suffisso V3 nel nome.
Annotare il suo **Id**.
Tutti i passi sotto si fanno **solo** nella finestra MT5 con **50503392** nel titolo.

---

## PASSO 2: F7 (terminale 50503392, `C:\Program Files\BCM Markets MT5 Terminal`)

**Bersaglio:** azione a mano dentro MT5, terminale del conto DEMO PICCOLO **50503392**
(`C:\Program Files\BCM Markets MT5 Terminal`), riconosciuto dal passo 1. **Non tocca:** trial 1514806751
(`C:\FTMO`), 100k 50504263 (`...MT5 Terminal -V3`), REALE 10105439 (`C:\BCM_Reale`), manuale 50503635
(`C:\MT5_MANUALE`), banco 50504400 (`C:\MT5_Backtest`), Pepperstone, Tickmill.

1. Nella finestra MT5 col titolo **50503392**: tasto **F4** (apre il MetaEditor **di quel** terminale).
2. Controllo del MetaEditor giusto: `File > Apri cartella dati` deve aprire una cartella che finisce con
   **`215D85D767A1C39E22D242C8114BF9F5`**. Se finisce con un altro nome: **chiudere il MetaEditor e non compilare**.
3. Nel Navigatore del MetaEditor: `Experts\ABTG_BulgeAzzurra.mq5` -> aprirlo -> **F7**.
4. Scheda **Errori** in basso: deve dire **`0 errors`** (i warning si annotano e si riportano, non bloccano).
   F7 compila **solo questo file**: le sedie gia' attaccate (Bulge VIOLA compresa) **non vengono toccate**.
5. **Se c'e' anche un solo errore: STOP.** Screenshot della scheda Errori, niente grafici, niente preset.
   Non si aggiorna l'include a mano (sarebbe una firma).

---

## PASSO 3: attaccare A SECCO su UN SOLO grafico (terminale 50503392, `C:\Program Files\BCM Markets MT5 Terminal`)

**Bersaglio:** azione a mano dentro MT5, terminale **50503392** (stesso del passo 2, stessa lista di cio' che
NON si tocca).

L'autotest `[BULGE][AUTOTEST]` si stampa all'**avvio dell'EA sul grafico** (OnInit), **non** con F7. Quindi
lo si legge **attaccando l'EA con il trading SPENTO per lui**, e lo si accende solo dopo.

1. Nella finestra MT5 col titolo **50503392**: Navigatore -> tasto destro su **Expert Advisors** -> **Aggiorna**:
   deve comparire `ABTG_BulgeAzzurra`.
2. **Un grafico NUOVO**: `File > Nuovo grafico > EURGBP`, timeframe **H1** (l'EA lavora sempre su H1 per tutti i
   22 cross; il grafico serve solo a dargli i tick). **EURGBP e non EURUSD**: sul piccolo ci sono gia' DUE grafici
   EURUSD H1 con una sedia (BreakingBand 772162, GapFill 772232; sonda `CODA_01` del 09/10), ed EURGBP non ne ha
   nessuno: cosi' al passo 4 e al passo 3.5 non si puo' aprire o togliere l'EA del grafico sbagliato.
   **Prima di trascinare**: nell'angolo in alto a destra del grafico nuovo **non deve esserci il nome di nessun
   EA**. Se c'e', non e' il grafico nuovo: **NON chiuderlo** (chiudere un grafico con una sedia la toglie dal
   conto), lasciarlo com'e' e aprirne un altro.
   **UN SOLO grafico**: due copie con lo stesso magic 774500 si pesterebbero (Max_Trades e kill switch contati
   insieme, segnali doppi).
3. Trascinare `ABTG_BulgeAzzurra` sul grafico. Nella finestra che si apre:
   - scheda **Input** -> **Carica** -> `ABTG_BulgeAzzurra_piccolo_demo.set`; poi controllare a vista
     `InpMagic = 774500`, `InpComment = BULGE_AZZURRA`, `Risk_Percent = 0.5`, `Max_Trades = 4`,
     `Use_Azure = true`, `Use_Purple = false`;
   - scheda **Comune**: **togliere** la spunta "Consenti Algo Trading" (**solo per questo EA**, e solo per ora);
   - **OK**.
4. Scheda **Esperti** del terminale (non "Giornale"). Le righe sono quelle con il nome `ABTG_BulgeAzzurra (EURGBP,H1)`:
   attenzione, il prefisso `[BULGE]` e' lo **stesso** della Bulge VIOLA, a distinguerle e' il **nome dell'EA**.
   Righe attese:
   - `[BULGE] Init OK | Simboli: 22 | Rischio: PER_TRADE 0.50% | Max trade: 4 | ADX: ON soglia=30.0 su: BLU | Kill: ON ...`
     (l'ADX "su: BLU" e' innocuo: il BLU e' spento);
   - `[BULGE] AZZURRA ON | ritracciamento ordinato: range <= 1.50 x ATR | tocco: OGNI tocco (come il VIOLA) | finestra impulso 40 barre | segnali accesi: AZZURRA`;
   - `[BULGE][AUTOTEST] magic 774500 | commento "BULGE_AZZURRA" | rischio 0.50% | segnali: AZZURRA`;
   - la riga `tag segnale:` con **tutti PASS**; `atteso col default: ... PASS`; le prove **A) B) C)** con
     **PASS** (la C dice `PASS (riprodotto)`, e' giusto cosi'); `VERDETTO: PASS. Signal_Bar_Offset=1`;
     `gestione (b) SPENTA`; la riga **`AZZURRA: ... -> PASS`**; **`VIOLA invariato ... PASS`**;
   - dall'include: `[AUTOTEST] ABTG_PausaGuardian: TUTTI I CASI PASSATI.`
   - **NON** devono esserci righe `Simbolo non trovato`.
   - **Atteso e innocuo durante il passo a secco**: se l'ultima candela H1 chiusa ha un segnale, compare una riga
     `[BULGE] LONG ERR | ...` o `[BULGE] SHORT ERR | ...` con un motivo di trading non consentito: e' l'ordine
     rifiutato perche' la spunta e' tolta. **Non e' un FAIL** e non apre niente.
5. **Se compare anche UN solo `*** FAIL ***` o `NON mettere in campo`**: sul grafico **EURGBP H1** che ha
   `ABTG_BulgeAzzurra` scritto nell'angolo in alto a destra (controllarlo PRIMA del clic), togliere l'EA
   (tasto destro sul grafico -> Expert Advisors -> Rimuovi) e mandare lo screenshot. Fine.

---

## PASSO 4: accendere (terminale 50503392, `C:\Program Files\BCM Markets MT5 Terminal`), solo se il passo 3 e' tutto PASS E Claudio ha scelto A/B/C dell'avviso 6

**Quando, secondo la scelta:** con **A** subito dopo il passo 3; con **B** non prima del **15/10** (trial scaduta);
con **C** **NON con questo preset**: serve il preset a 7 cross, una riga nuova e un cancello nuovo, e questo
passo 4 si riscrive.

**Bersaglio:** azione a mano dentro MT5, terminale **50503392** (stesso del passo 2, stessa lista di cio' che
NON si tocca).

1. Sul grafico **EURGBP H1** con `ABTG_BulgeAzzurra` nell'angolo in alto a destra: **tasto destro sul grafico ->
   Expert Advisors -> Proprieta'** (e' la stessa cosa del tasto F7 **del terminale**; NON premere F7 se in
   primo piano c'e' il MetaEditor, che invece ricompila) -> scheda **Comune** -> **mettere** la spunta
   "Consenti Algo Trading" -> **OK**. L'EA si riavvia e ristampa l'autotest (normale).
   **Quando**: nei primi minuti dopo un'ora tonda. Al riavvio l'EA valuta l'ultima candela H1 chiusa (punto 4
   qui sotto): acceso alle xx:40, un segnale di quella candela entrerebbe con 40 minuti di ritardo, cosa che
   l'EA in regime non fa mai (lui entra al primo tick della candela nuova).
2. Il bottone **Algo Trading** della barra in alto **e' gia' VERDE** per le altre sedie del piccolo:
   **NON cliccarlo.** Cliccandolo si **SPEGNE per tutte** le sedie del conto 50503392.
3. Nell'angolo del grafico l'EA deve risultare attivo (icona del cappello **blu** / faccina, non grigia).
4. **Da sapere:** al primo tick l'EA valuta subito l'ultima candela H1 chiusa di tutti i 22 cross, quindi
   **puo' aprire subito** se c'e' un segnale. E' il comportamento normale, uguale alla Bulge.
5. Screenshot della scheda **Esperti** e del grafico -> in chat.
6. Se nei giorni dopo nella scheda Esperti compaiono righe `[GUARDIA] ... INGRESSO BLOCCATO`, sul piccolo ci sono
   GlobalVariable vecchie di un Guardian: **non e' atteso** (la Bulge, stesso meccanismo, opera) e va riportato.

---

## COSA NON E' VERIFICATO DA QUI

- La **compilazione** (nessun MetaEditor in questo ambiente) e **qualunque backtest** dell'Azzurra.
- **Quale versione** di `ABTG_PausaGuardian.mqh` c'e' sul piccolo: lo script ne stampa byte, data, SHA e la
  presenza delle due funzioni che l'EA chiama (`ABTG_GuardiaIngresso`, `ABTG_AutotestGuardia`). Le due funzioni
  ci sono, con la stessa firma, gia' nella v1.51 (`e72546e4`), quella portata sul piccolo il 03/09.
- Che il **giornale del piccolo** non nomini per qualche motivo uno dei nomi vietati (FTMO, un altro conto):
  se lo fa, lo script **si rifiuta** (prudenza voluta) e lo dice nel referto.
- Che il **titolo** della finestra MT5 cominci col numero di conto: e' la forma standard di MT5, la stessa
  usata dalla riga della trial (`1514806751*`). Se non e' cosi', la riga si ferma e stampa la tabella.
- Che MT5 carichi il `.set` (ASCII, fine riga LF, stesso formato dei preset Bulge gia' in repo): per questo il
  passo 3.3 chiede di **controllare a vista** sei valori dopo il caricamento.
- **La trial FTMO** (avviso 6): la lista dei 15 cross e' quella del preset in repo, NON letta dal `.chr` vivo
  (la sonda `CODA_08` non ricostruisce `Symbols_List` della Bulge); che la regola dell'hedging fra conti valga
  per la Free Trial e' [NON MISURATO] (domanda al supporto mai chiusa); quanto spesso Azzurra (piccolo) e VIOLA
  (trial) si troverebbero opposte, sullo stesso cross o su cross correlati, non e' stimato.
  **E la Bulge potrebbe non essere l'unica sedia della trial sui 22 cross**: la sonda `CODA_02` del 09/10 legge nel
  giornale della trial (`C:\FTMO`, 08/10 16:30:37) un `ABTG_ORB_Ottimizzato (CADCHF,H1)` con un `BUY STOP` (5 righe),
  che **non** compare fra le 10 sedie del profilo attivo in `CODA_01` (li' l'ORB e' su US30.cash M5). Se quel grafico
  e' ancora aperto, CADCHF e' gia' fra i 15; il verso dell'ORB (rottura, a favore) e' lo stesso dell'Azzurra, quindi
  il rischio d'hedging su quel cross non cresce, ma l'elenco delle sedie trial sui cross **non e' chiuso**.
- **Il banco simulato "19 scenari su 19"** non e' in repo. Il lettore indipendente ne ha rifatto **8** con un banco
  suo (pwsh 7 su Linux, `Get-Process`/CIM finti, download VERO dai pin): sessione Master, `-V3` col titolo del
  piccolo, titolo `505033920...`, giornale con `1514806751`/`FTMO`, terminale chiuso, file gia' presente e diverso
  -> tutti **uscita 1, niente scritto**; include assente -> **uscita 2**; caso buono -> **uscita 0**, SHA dei due
  file riletti uguali ai congelati, **zero** file nella cartella `-V3`. Non e' Windows PowerShell 5.1 (quello lo
  copre il parser del cancello, non un'esecuzione).
- **Che la Bulge 772700 del piccolo giri col preset SOLO_VIOLA o ancora con BLU+VIOLA**: HANDOFF 01/10 lo dava
  "non ancora applicato" e la sonda `CODA_08` non ricostruisce gli `Use_*` della Bulge. Il rischio dell'avviso 1
  non cambia (lo limita Max_Trades), l'etichetta "Bulge VIOLA" si'.
- **Che la scritta "Consenti Algo Trading" e il menu `Expert Advisors -> Proprieta'/Rimuovi`** abbiano
  esattamente questi nomi nella build installata sul VPS: sono quelli dell'MT5 in italiano, non visti oggi.


## ESITO DEL PASSO 3 (09/10/2026 16:26:38, screenshot di Claudio, terminale 50503392, grafico EURGBP H1)
- Autotest dell'EA e del Guardian: **tutte le righe visibili PASS** (tag segnale, A/B/C, VERDETTO PASS, gestione (b) SPENTA, `AZZURRA: ... -> PASS`, `VIOLA invariato ... PASS`, `ABTG_PausaGuardian: TUTTI I CASI PASSATI`). Nessun `FAIL` o `Simbolo non trovato` nelle righe viste.
- **DIFETTO: `Rischio: PER_TRADE 0.80%` e `rischio 0.80%` invece di 0,50%** (decisione di Claudio 09/10): il preset `ABTG_BulgeAzzurra_piccolo_demo.set` NON risulta applicato (tutti gli altri valori coincidono coi default). Causa non provata; ipotesi: MT5 non ha caricato il `.set` ASCII con fine riga LF, o il "Carica" non e' stato eseguito. **Rimedio: Proprieta' -> Input -> `Risk_Percent = 0.5` a mano**, poi rileggere la riga `Rischio: PER_TRADE 0.50%`. Spunta "Consenti Algo Trading" dell'EA da tenere TOLTA finche' il passo 4 e' bloccato. Classe di checklist: un preset che il passo a secco deve RILEGGERE nell'Init OK (rischio, magic, commento) prima di dichiararlo caricato.
