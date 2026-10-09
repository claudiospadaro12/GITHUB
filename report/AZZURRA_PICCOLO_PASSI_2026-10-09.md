# AZZURRA SUL PICCOLO 50503392: i passi a mano dopo la copia (09/10/2026)

**Decisione di Claudio, 09/10:** _"Lascia i default [domande 1-5 e candela di test: solo corpo, com'e' ora],
rischio Azzurra 0,5%, e proviamolo nel conto DEMO PICCOLO 50503392, NON nel conto della trial."_

Stato al momento della scrittura: **preparato, NON ancora passato dal cancello** (controllo-preventivo +
verificatore-stringhe + lettore indipendente). Finche' non c'e' il PASS, niente di questo esce verso il VPS.

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

1. **Rischio aperto delle due Bulge sul piccolo: 5,2%.** Bulge VIOLA 4 x 0,8% = 3,2% + Azzurra 4 x 0,5% = 2,0%.
   E' **sopra il cap C1 firmato (3,25%)**, che sul piccolo comunque **non lo applica nessuno**. Claudio lo sa e
   l'ha deciso il 09/10. E le altre sedie del piccolo si **sommano** a questo numero.
2. **Kill switch giornaliero 2% PER ISTANZA, non per conto.** Ogni EA conta solo i SUOI deal chiusi (filtro sul
   magic) della giornata: Bulge 772700 e Azzurra 774500 hanno ciascuno il suo 2% e i suoi 4 SL. Il kill switch
   **blocca i NUOVI ingressi**, non chiude le posizioni aperte, e **non guarda il flottante**. Giornata peggiore
   delle sole due Bulge, a stop pieni: **circa 4%** realizzato (fatto dal codice, non misurato in campo).
3. **Sul piccolo NON gira nessun Guardian.** `InpUsaGuardian=true` resta acceso per standard di casa, ma senza
   Guardian e' **fail-open**: niente pausa B1, niente cap C1. Lo script **non** porta il Guardian ne' l'include.
4. **L'Azzurra NON e' MAI stata compilata in MetaEditor** (ne' backtestata). Il collaudo 63/63 prova la logica a
   tavolino. **Se F7 da' anche un solo errore: NON attaccare niente, riporta gli errori.**
5. Da sapere (non misurato): Azzurra e Bulge VIOLA girano sugli **stessi 22 cross** dello stesso conto. La VIOLA
   entra **contro** l'impulso, l'Azzurra **a favore**: sullo stesso cross possono trovarsi aperte in versi
   opposti (il conto e' hedging, quindi e' permesso). Si vede dai magic.

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

1. Nella finestra MT5 col titolo **50503392**: tasto **F4** (apre il MetaEditor **di quel** terminale).
2. Controllo del MetaEditor giusto: `File > Apri cartella dati` deve aprire una cartella che finisce con
   **`215D85D767A1C39E22D242C8114BF9F5`**. Se finisce con un altro nome: **chiudere il MetaEditor e non compilare**.
3. Nel Navigatore del MetaEditor: `Experts\ABTG_BulgeAzzurra.mq5` -> aprirlo -> **F7**.
4. Scheda **Errori** in basso: deve dire **`0 errors`** (i warning si annotano e si riportano, non bloccano).
   F7 compila **solo questo file**: le sedie gia' attaccate (Bulge VIOLA compresa) **non vengono toccate**.
5. **Se c'e' anche un solo errore: STOP.** Screenshot della scheda Errori, niente grafici, niente preset.
   Non si aggiorna l'include a mano (sarebbe una firma).

---

## PASSO 3: attaccare A SECCO su UN SOLO grafico (terminale 50503392)

L'autotest `[BULGE][AUTOTEST]` si stampa all'**avvio dell'EA sul grafico** (OnInit), **non** con F7. Quindi
lo si legge **attaccando l'EA con il trading SPENTO per lui**, e lo si accende solo dopo.

1. Nella finestra MT5 col titolo **50503392**: Navigatore -> tasto destro su **Expert Advisors** -> **Aggiorna**:
   deve comparire `ABTG_BulgeAzzurra`.
2. **Un grafico NUOVO**: `File > Nuovo grafico > EURUSD`, timeframe **H1** (l'EA lavora sempre su H1 per tutti i
   22 cross; il grafico serve solo a dargli i tick). **UN SOLO grafico**: due copie con lo stesso magic 774500
   si pesterebbero (Max_Trades e kill switch contati insieme, segnali doppi).
3. Trascinare `ABTG_BulgeAzzurra` sul grafico. Nella finestra che si apre:
   - scheda **Input** -> **Carica** -> `ABTG_BulgeAzzurra_piccolo_demo.set`; poi controllare a vista
     `InpMagic = 774500`, `InpComment = BULGE_AZZURRA`, `Risk_Percent = 0.5`, `Max_Trades = 4`,
     `Use_Azure = true`, `Use_Purple = false`;
   - scheda **Comune**: **togliere** la spunta "Consenti Algo Trading" (**solo per questo EA**, e solo per ora);
   - **OK**.
4. Scheda **Esperti** del terminale (non "Giornale"). Le righe sono quelle con il nome `ABTG_BulgeAzzurra (EURUSD,H1)`:
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
5. **Se compare anche UN solo `*** FAIL ***` o `NON mettere in campo`**: togliere l'EA dal grafico
   (tasto destro -> Expert Advisors -> Rimuovi) e mandare lo screenshot. Fine.

---

## PASSO 4: accendere (terminale 50503392), solo se il passo 3 e' tutto PASS

1. Sul grafico EURUSD H1 dell'Azzurra: **F7** (proprieta' dell'EA) -> scheda **Comune** -> **mettere** la spunta
   "Consenti Algo Trading" -> **OK**. L'EA si riavvia e ristampa l'autotest (normale).
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
