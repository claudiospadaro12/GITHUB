# 🧨 FAILURE INJECTION SUL GUARDIAN — procedura in BOZZA (punto 4 del parere di Emiliano)

**28/09/2026** · branch `lavoro` · **BOZZA: NIENTE DI QUESTO DOCUMENTO È STATO ESEGUITO.**
Nessun terminale aperto, nessun `.mq5` toccato, nessun preset modificato, nessuna riga mandata al VPS
o al PC di backtest. Le righe che serviranno (elencate al §9) **non sono scritte qui**: le scrive la
sessione dopo e passano dai due cancelli.
✋ Taglie, soglie del Guardian, `pretendi_guardian`, ricompilazioni in campo: **firme di Claudio**. Qui
non si propone nessun numero. Dove il codice ha un difetto, è un **RILIEVO con la riga** (§6), non una
correzione.

> *«Il Guardiano deve essere testato come componente critica: riavvio terminale/VPS, perdita di
> connessione, ordini pendenti residui, mancata risposta del broker, cambio giorno del server, calcolo
> dell'equity e concorrenza tra EA. Farei test deliberati di failure injection, non soltanto dry-run
> normale.»* — Emiliano, `docs/PARERE_EMILIANO_2026-09-28.md` punto 4

---

## 0️⃣ LA RISPOSTA IN SEI RIGHE

1. 🔴 **Nessuno dei 15 guasti qui sotto è mai stato provocato apposta.** Il collaudo del 02/09 era
   revisione statica (`COLLAUDO_ENFORCEMENT_FASE1_2026-09-02.md` r.10) e il suo criterio 8 (Guardian
   rimosso) risulta ancora **DA COLLAUDARE** (r.52): nessun altro referto in repo lo dà per eseguito.
2. 🎯 **Si prova la versione che gira su FTMO, non HEAD**: Guardian **v1.12 @ `d884f7e1`** (498 righe) +
   include **v1.20 @ `26a18566`** (398 righe), identificati per impronta in `GUARDIAN_SEI_SEDIE_2026-09-24.md` §3.2.
3. 🖥️ **Tutto sul PC di backtest `DESKTOP-H4D7CAJ`, su un conto demo DEDICATO** (§2). Sul VPS **niente**
   finché la challenge `541452707` è viva (firma del 21/09).
4. 🔴 **Il codice dice fail-open in 7 dei 15 casi** (G02, G04, G06, G07, G12, G13, G14), e in un ottavo
   (G08b, il filling) dipende da un file ancora da leggere: il freno si spegne o si allenta **senza una
   riga di log che lo dica**. ✏️ Il grado non è lo stesso per tutti e sette: in **cinque** (G04, G06, G07,
   G12, G14) basta che il guasto accada; in **G13** vale nelle ore **fra** le due ore di reset (fra 1 e 23:
   22 ore su 24); in **G02** serve anche che le GlobalVariable si perdano col crash, e questo è
   `[NON MISURATO]` (la variante G02b, che le cancella a mano, è invece certa). Tre (G02, G04, G13) colpiscono direttamente il muro giornaliero, cioè la
   modalità di morte che il Monte Carlo dà per annullata dal Guardian (18,2% → 0,0%,
   `IL_PIANO_DEGLI_OTTO_GIORNI_2026-09-23.md` §3.2).
5. 🆕 **Tre rilievi nuovi sul codice** (§6): la chiusura d'emergenza è **l'unico `CTrade` su FTMO che non
   imposta il filling** (le sei sedie censite il 24/09 lo fanno, la settima `770105` è `[NON VERIFICATA]`; se la libreria standard lo adatta da sola in chiusura è
   solo igiene: `[DA VERIFICARE]`, verifica più corta in G08), il Guardian **non forza mai il salvataggio** delle sue
   GlobalVariable, e **nulla impedisce due Guardian** sullo stesso conto.
6. ⏱️ Costo per Claudio: **~1 h di preparazione una volta** + **tre sedute da ~1,5 h** + **5 minuti il 26/10**.
   Le prime due sedute coprono i sette guasti ad ALTA priorità.

---

## 1️⃣ CHE COSA SI PROVA: IL BINARIO IN CAMPO

| pezzo | in campo su `C:\FTMO` | a HEAD oggi | perché conta per i test |
|---|---|---|---|
| `ABTG_Guardian.mq5` | **v1.12**, pin `d884f7e1`, **498 righe**, 16 input | v1.14, 899 righe, 19 input | la v1.14 cambia l'avvio (stampa la baseline in `OnInit`, r.619-620) e aggiunge `InpDailyBaseline`: **i test G01-G03 e G09 vanno rifatti** se Claudio porta in campo la v1.14 |
| `ABTG_PausaGuardian.mqh` | **v1.20**, pin `26a18566`, **398 righe** | v1.6x, 2461 righe | per chiamate a due argomenti la logica B1/C1 è la stessa, ma si compila **quella del pin** |
| preset | `ABTG_Guardian_FTMO_2Step.set` letto dal `.chr` (`CODA_08` del 24/09 r.3437-3458; stessi valori in quello del **28/09**, r.2177-2196) | idem | ancora 80000 · emergenza 4,5 · DD 9,3 statico · pausa 3,5 · cap 4,00 · reset ora 1 · `InpAction=0` · `InpCloseAllMagics=true` |
| sedie | **sette**: le sei censite il 24/09, tutte con `InpUsaGuardian=true` e **nessuna con `pretendi_guardian`**, più la `770105` (DAX short, attaccata il 25/09, assente dalla sonda per la classe 822: `docs/PARERE_EMILIANO_2026-09-28.md` punto 4), `[NON VERIFICATA]` su Guardian e filling | idem | è il motivo per cui G04 è fail-open |

📌 **Tutti i numeri di riga "v1.12 r.N" e "v1.20 r.N" di questo documento sono contati sui file al pin**
(`git show d884f7e1:mql5/Experts/ABTG_Guardian.mq5`, `git show 26a18566:mql5/Include/ABTG_PausaGuardian.mqh`),
non su HEAD. Dove cito HEAD lo scrivo.

---

## 2️⃣ IL BANCO: DOVE, SU QUALE CONTO, E CHE COSA NON SI TOCCA

### 2.1 🖥️ La macchina: **PC di backtest `DESKTOP-H4D7CAJ`**. Il VPS è fuori.
- **VPS: nessun test, nessun terminale aperto, nessun EA attaccato**, finché la challenge FTMO
  `541452707` è viva. È la firma del 21/09 (`CLAUDE.md`, "I ROUND NON GIRANO PIU' SUL VPS") estesa per
  prudenza a qualunque prova che carichi la macchina o apra finestre MT5: sul VPS convivono **tutte le
  cartelle dati elencate al §2.3** (censimento `CODA_08` del 28/09) e un test sbagliato di finestra lì
  costa la challenge.
- **Sul PC di backtest si prova solo quando nessun round sta girando**: il tester si mangia le CPU e
  falserebbe i tempi di reazione del Guardian (G06, G08, G12 misurano secondi).

### 2.2 🔴 Il conto: **NON `50503392`**, anche se il PC è loggato lì. Perché.
Il PC di backtest ha un MT5 loggato sul **piccolo `50503392`** (`SOSPENSIONE_SEDIE_DEMO_2026-09-25.md`
r.82; `NOTTE_2026-09-26.md`: le chiusure di quel conto viste in pagella arrivano da lì). Usarlo per
questi test sarebbe sbagliato per tre ragioni, tutte lette nel codice:
1. **`FlattenAll()` chiude TUTTO il conto**, qualunque magic (v1.12 r.341-361, `InpCloseAllMagics=true`
   nel preset): una prova di breach su `50503392` chiuderebbe anche le posizioni delle sedie attaccate
   al PC e quelle rimaste sul server dal terminale del VPS.
2. **Le GlobalVariable portano il login nel nome** (v1.12 r.270-281, v1.20 r.165): un Guardian di prova
   su `50503392` scriverebbe `ABTG_PAUSA_GIORNO_50503392` e **fermerebbe le sedie del PC** che leggono il canale.
3. **L'include del pin (v1.20) andrebbe copiato nella cartella `MQL5\Include` del terminale che compila
   i round**, che oggi compila con l'include di `lavoro`: i round nascerebbero con l'include sbagliato
   (parente della classe 892).

👉 **Proposta (decisione di Claudio, non costa soldi): un conto DEMO BCM NUOVO, in una cartella MT5
NUOVA e separata sul PC di backtest.** In questo documento: **`[CONTO_GUASTI]`** e
**`[CARTELLA_GUASTI]`**. Finché i due valori non sono scritti qui dentro al posto dei segnaposto,
**nessun test parte**.
- 💶 **Deposito del demo**: quello che rende raggiungibile il cap C1 del preset (4,00% dell'equity) con
  **una** posizione a lotto minimo e stop a distanza normale. La condizione è
  `perdita allo stop del lotto minimo >= 4,00% x deposito`; il numero lo ricava la sessione dopo dalle
  specifiche del simbolo. **Non è una taglia**: è un conto finto dedicato.
- 🧪 **Variante FTMO (facoltativa, decisione di Claudio)**: un **conto di prova gratuito FTMO**
  (`[CONTO_TRIAL]`, cartella `[CARTELLA_TRIAL]`, sempre sul PC di backtest). È **l'unico modo** di provare
  la chiusura d'emergenza sui simboli FTMO (G08b) e l'orologio FTMO al cambio d'ora (G10) **senza
  toccare `541452707`**. `[DA VERIFICARE da Claudio]`: che la prova gratuita esista ancora, che sia
  gratuita, e che il suo server abbia lo stesso orologio e le stesse specifiche del server della challenge.

### 2.3 🚫 La lista di chi NON si tocca, per nome (vale per OGNI passo di OGNI test)
| conto | cartella | dove | perché è qui |
|---|---|---|---|
| **FTMO `541452707`** | `C:\FTMO` | VPS | la challenge viva |
| **REALE `10105439`** | `C:\BCM_Reale` | VPS | soldi veri |
| **100k `50504263`** | `BCM Markets MT5 Terminal -V3` | VPS | dry-run |
| **banco `50504400`** | `C:\MT5_Backtest` | VPS | spento per firma del 21/09 |
| **manuale `50503635`** | `C:\MT5_MANUALE` | VPS | conto a mano |
| **Pepperstone** | `C:\Program Files\Pepperstone MetaTrader 5` | VPS | terminale vivo di un altro broker |
| **Tickmill** | `C:\Program Files\Tickmill Europe MT5 Terminal` | VPS | sedie vive (XAUUSD, USDJPY: `CODA_08` 28/09) |
| **piccolo `50503392`** | `C:\Program Files\BCM Markets MT5 Terminal` sul VPS **e** sul PC (tabella macchina→terminale del driver dei round, `I_ROUND_SUL_PC_DI_BACKTEST_2026-09-21.md` §3.1; stato attuale del PC da rileggere con R-A, ultima misura 10/09) | VPS **e** PC | §2.2 |

### 2.4 🎯 La riga del bersaglio, in testa a ogni test
> 🖥️ **PC di backtest `DESKTOP-H4D7CAJ`** · ✋ **azione a mano dentro MT5** sul terminale **`[CONTO_GUASTI]`**
> (`[CARTELLA_GUASTI]`), riconosciuto dalla riga PID + titolo + cartella (§9, riga R-A), **mai a occhio** ·
> **NON si tocca**: il terminale `50503392` sullo stesso PC (`C:\Program Files\BCM Markets MT5 Terminal`), e
> sul VPS nulla: FTMO `541452707`, REALE `10105439`, 100k `50504263`, banco `50504400`, manuale `50503635`,
> piccolo `50503392`, Pepperstone, Tickmill (cartelle al §2.3).

Nei test la riga è ripetuta in forma breve (**BERSAGLIO B**), con le eventuali aggiunte.

---

## 3️⃣ PREPARAZIONE, UNA VOLTA SOLA (P0-P7) — ~60-90 minuti di Claudio

| # | passo | chi | fatto quando |
|---|---|---|---|
| P0 | Aprire il demo `[CONTO_GUASTI]` e installare MT5 in `[CARTELLA_GUASTI]` (installazione separata, modalità portable) | Claudio | il titolo della finestra mostra `[CONTO_GUASTI]` e la riga R-A stampa **due** `terminal64` con due cartelle diverse |
| P1 | Copiare nella cartella **i file al pin** (Guardian `d884f7e1`, include `26a18566`) verificando l'impronta come fa `SCHIERA_FTMO.ps1` r.176-186 | riga R-B | impronte 2/2 uguali a quelle dello script |
| P2 | F7 del Guardian **dentro `[CARTELLA_GUASTI]`** | Claudio | `0 errors, 0 warnings` |
| P3 | Preset di prova = **copia di `ABTG_Guardian_FTMO_2Step.set`** in cui cambiano **solo** i campi dichiarati test per test (ancora, ora di reset, `InpAction`). Le percentuali 4,5 / 9,3 / 3,5 / 4,00 **restano quelle del campo**: si prova la configurazione vera | sessione dopo | diff del preset di prova contro quello di casa, riga per riga |
| P4 | **Sonda d'ingresso**: un piccolo EA di prova **da scrivere** (nome proposto `ABTG_SondaIngresso`, file nuovo, compilato con l'include v1.20 del pin) che a orari fissi chiama `ABTG_GuardiaIngresso(true,"SONDA_n")` e, se passa, apre il lotto minimo con SL. Stampa **da sé** una riga per ogni tentativo e ogni esito, e imposta il livello di log di `CTrade` su TUTTO (classe 896) | sessione dopo, passa dai cancelli | autotest di compilazione + una corsa a secco |
| P5 | Il canarino `mql5/Scripts/ABTG_CanarinoGuardian.mq5` compilato nella cartella di prova | Claudio | `[DA VERIFICARE]` che compili con l'include v1.20: se usa funzioni della v1.6x, al suo posto si usa la finestra **F3** (Variabili globali: nome, valore, ora di modifica) con una foto |
| P6 | Scarto orologio PC ↔ server BCM annotato (ora del Market Watch accanto all'orologio di Windows, nella stessa foto) | Claudio | un numero in minuti. Oggi atteso −1 h (BCM UTC+1 fisso, `CLAUDE.md` 24/09); **dal 25/10 atteso 0** |
| P7 | Scheda **Trade** di `[CONTO_GUASTI]` vuota (zero posizioni, zero pendenti) e **Algo Trading verde** | Claudio | foto |

🧹 **Pulizia a fine seduta**: rimuovere Guardian di prova, sonde e secondo Guardian (G13) dai grafici,
**salvare il profilo** (altrimenti al riavvio tornano), cancellare da F3 **solo** le GlobalVariable che
contengono `[CONTO_GUASTI]` nel nome, e far girare la riga di raccolta R-D.

---

## 4️⃣ COME SI OSSERVA — e la trappola della classe 896

🔴 **Gli ordini riusciti NON finiscono nel giornale Esperti.** Il `CTrade` del Guardian non chiama
`LogLevel` (0 occorrenze in v1.12): il default stampa **solo gli errori**. Gli stop colpiti dal server
vanno nel giornale del **terminale** (`Logs\`), non in `MQL5\Logs\` (classe 896,
`backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md` r.36141). Quindi *"nessuna riga d'ordine"* vuol dire
*"nessun ordine fallito"*, **mai** *"nessuna operazione"*.

Le quattro fonti ammesse, e l'orologio in cui sono scritte:
| fonte | che cosa dice | orologio |
|---|---|---|
| **Righe `[GUARDIAN]`** (Esperti) | stato, breach, pausa, cap, riga ogni 300 s | colonna del log = **ora del PC**; le date *dentro* il testo (es. "fino a …") = **ora server** |
| **Righe della sonda P4** e righe **`[GUARDIA]`** stampate dall'include (v1.20 r.304 e r.312) | ogni tentativo d'ingresso, bloccato o no | ora del PC |
| **Storico del conto** (deal e ordini cancellati) | **la verità** su cosa è stato aperto, chiuso, cancellato, e quando | **ora server** |
| **Giornale del terminale** (`Logs\`) | connessione persa/ritrovata, Algo Trading, stop lato server, avvio e chiusura del terminale | ora del PC |

📐 **Il canarino / F3** fa la **foto delle GlobalVariable** prima e dopo ogni guasto: è l'unico modo di
vedere lo **stato** (baseline del giorno, pausa, blocco) invece del comportamento.

---

## 5️⃣ I QUINDICI GUASTI

Legenda del codice: 🔴 **fail-open** = il freno si spegne o si allenta · 🟢 **fail-closed** = si ferma
o resta fermo · 🟠 **misto**.

### Due strumenti che molti test usano (derivati dal preset, non soglie proposte)
- 🔧 **Trucco dell'ancora** per far scattare i limiti **senza perdere niente**: il Guardian misura i
  limiti in euro sull'ancora `InpStartBalance` (v1.12 r.393-394: `dailyLimit = InpDailyLossPct% x gStart`,
  `totalLimit = InpTotalDDPct% x gStart`), mentre la perdita del giorno è in euro dalla baseline
  (r.397). Quindi, a percentuali di campo invariate:
  - **DD totale subito**: ancora `A >= equity / (1 - InpTotalDDPct/100)` → `gStart - eq >= totalLimit` (r.398, r.404);
  - **perdita giornaliera con un lotto minimo**: ancora piccola, tale che `InpDailyLossPct% x A` sia sotto
    il costo di spread di una posizione a lotto minimo aperta **dopo** la baseline.
  Cambiare l'ancora riavvia il Guardian (`OnDeinit` + `OnInit`), ma **la baseline del giorno resta** (r.303-311).
  🧮 Esempio (numeri di comodo, non una taglia): equity del demo 10.000 e DD 9,3% → `A >= 10.000 / 0,907 =
  11.025,36`; con `A = 11.100` il limite è `0,093 x 11.100 = 1.032,30` e la distanza `11.100 - 10.000 = 1.100`
  lo supera → breach al primo secondo. Giornaliero: se lo spread di un lotto minimo costa 0,50, serve
  `0,045 x A < 0,50`, cioè `A < 11,11`; con `A = 10` il DD totale **non** scatta (`10 - 10.000 < 0`).
  🔴 Con un'ancora così piccola la finestra fra pausa (3,5% di A) e emergenza (4,5% di A) è larga **dieci
  centesimi**: in pratica **ogni pausa accesa col trucco timbra anche il blocco del giorno** (r.417, anche in
  `InpAction=1`).
- 🧽 **Stato di partenza di OGNI test** (le GlobalVariable sopravvivono fra un test e l'altro, e i blocchi
  sono latch): prima di ogni test la foto F3 deve mostrare `ABTG_PAUSA_GIORNO_[CONTO_GUASTI]` = 0,
  `..._BLOCKDAY_V2` diverso da `..._DAYKEY_V2`, `..._FAILED` assente o 0, **salvo** che il test chieda
  proprio quello stato. Se no: rimuovere il Guardian → pulizia F3 (solo GV con `[CONTO_GUASTI]`) →
  riattacco. Due latch non si spengono da soli: **`FAILED` nel codice non viene MAI azzerato** (unica
  scrittura r.410; né il giorno nuovo r.377-381 né `OnInit` lo toccano) e dopo un DD totale `PAUSA_FINO`
  sta 30 giorni avanti (r.436) e non si accorcia mai (r.215). Senza questa regola un test **eredita** il
  latch del precedente: la pausa di G01/G02 maschera il cap di G04(a) e G15 (la guardia dà precedenza alla
  pausa sul cap, v1.20 r.140-141), e il breach di G12(c) o G06(b) toglie la riga di breach che G07(c) e
  G08(a) usano come orologio (r.414: con il blocco già timbrato non si ristampa).
- 🔧 **`InpAction=1` (SOLO ALLARME)** per i test che vogliono la pausa **senza** la chiusura. 🔴 Attenzione
  al rilievo R3 del 02/09: il blocco del giorno resta timbrato anche in `InpAction=1`, e rimettendo
  `InpAction=0` lo stesso giorno il Guardian **chiude tutto al primo secondo**. Sul conto dedicato è
  innocuo, ma i test che lasciano un blocco (G05, G08a, G07c) vanno **in fondo alla seduta**.

---

### G01 · Riavvio PULITO del terminale a metà giornata (File → Esci, poi riapertura)
**1. Il codice.** 🟢 Stato ricostruito. `OnDeinit` mette il battito a 0 (v1.12 r.335); le GlobalVariable
restano. Alla riapertura `OnInit` rilegge l'ancora dal preset (r.294), il picco dalla GV (r.298) e **non
tocca la baseline** se la chiave del giorno coincide (r.304); la pausa resta con la sua scadenza
(r.312-313); il cap viene azzerato e ricalcolato subito (r.314, r.324). Finestra di fail-open sul cap: il
tempo fra la chiusura e il primo `OnTimer` (X12 del 02/09).
**2. Come si provoca.** BERSAGLIO B. Con una posizione a lotto minimo aperta e la pausa accesa (trucco
dell'ancora, `InpAction=1`): foto canarino/F3 → File → Esci → attesa 2 minuti → riapertura → foto.
**3. PASS/FAIL (scritto prima).** ✅ PASS: dopo la riapertura `ABTG_GUARD_[CONTO_GUASTI]_DAYSTART_V2`,
`..._DAYKEY_V2`, `ABTG_PAUSA_GIORNO_…` e `ABTG_PAUSA_FINO_…` **uguali** alla foto di prima; nessuna riga
`[GUARDIAN] nuovo giorno prop`; la sonda resta `INGRESSO BLOCCATO -- PAUSA`. ❌ FAIL: la baseline cambia
o la pausa sparisce.
**4. Rischio del test.** Nullo sul conto dedicato. L'unico rischio è **chiudere il terminale sbagliato**:
si chiude **dalla finestra** riconosciuta con R-A, mai da Gestione attività.

### G02 · Riavvio BRUTALE (il "Riavvia" del pannello VPS, un crash) — e le GlobalVariable perse
**1. Il codice.** 🔴 **Fail-open se le GV non sopravvivono.** Il Guardian **non chiama mai
`GlobalVariablesFlush()`** (0 occorrenze in v1.12 **e** a HEAD): che le modifiche fatte durante la
sessione arrivino sul disco dopo un'uccisione del processo dipende da MT5, ed è `[NON MISURATO]`. Se si
perdono:
- manca `DAYKEY_V2` → `OnInit` lo tratta come **giorno nuovo** (v1.12 r.304) e cattura la baseline
  all'**equity del riavvio** (r.307): 🔴 **la perdita già fatta nella giornata si azzera in silenzio**, e
  non c'è riga che distingua "giorno nuovo" da "variabile persa" (in v1.12 `OnInit` non stampa niente
  sulla baseline, r.303-311);
- manca `BLOCKDAY_V2` → un blocco d'emergenza già scattato **viene dimenticato**;
- mancano `PAUSA_GIORNO`/`PAUSA_FINO` → la pausa sparisce;
- 🟢 l'ancora **no**: viene dal preset (r.294), quindi il **DD totale** si ricalcola giusto a ogni secondo (r.398).
Variante **G02b** (stesso effetto, provocabile con certezza): cancellare da F3 **solo** `DAYKEY_V2` →
al secondo dopo `OnTimer` vede `0 != pk` (r.375) e riscatta la baseline, **con** la riga
`nuovo giorno prop` a metà giornata (r.382). Già segnalato a HEAD il 18/09
(`IL_GUARDIAN_CONTRO_LA_REGOLA_CHE_CI_HA_UCCISI_2026-09-18.md` buco 7).
**2. Come si provoca.** BERSAGLIO B, e in più: **il processo si termina per PID**, preso dalla riga R-A
(percorso = `[CARTELLA_GUASTI]`), da Gestione attività → Dettagli → Termina attività. **Mai per nome**
(sul PC ci sono due `terminal64`). Sequenza: avviare il terminale; far fare al Guardian un **cambio di
giorno durante la sessione** (ora di reset di prova = l'ora server successiva) così che `DAYKEY` sia
scritta **in questa sessione e mai passata da una chiusura pulita**, esattamente come in campo; accendere
la pausa; foto; attendere 5 minuti; terminare per PID; riaprire; foto.
**3. PASS/FAIL.** ✅ PASS: le tre GV uguali alla foto e nessuna `nuovo giorno prop` al riavvio. ❌ FAIL:
una qualunque delle tre assente o diversa. 🔴 **Il FAIL è l'esito più costoso di tutto il documento.**
🧪 **Contro-esempio che il test deve reggere**: *"il PASS esce perché MT5 ha salvato comunque in uscita"*
→ il giornale del terminale **non** deve contenere la riga di chiusura normale del terminale prima della
riapertura; se c'è, l'uccisione non è stata brutale e il test si ripete.
⚠️ **Limite dichiarato**: terminare il processo è **meno** severo di un reset della macchina (la cache del
disco di Windows sopravvive). **Un FAIL qui vale anche per il VPS; un PASS no.**
**4. Rischio del test.** Uccidere il terminale sbagliato (`50503392` sul PC): si contiene col PID dalla
riga R-A e col controllo, dopo, che l'altro terminale sia ancora connesso.

### G03 · Riavvio A CAVALLO dell'ora di reset
**1. Il codice.** 🟠 Al riavvio la chiave è cambiata → baseline = **equity al momento del riavvio**
(v1.12 r.304-307), non all'ora del reset: se nel frattempo le posizioni si sono mosse, la giornata parte
da un numero diverso da quello di FTMO (che usa il **saldo** delle 00:00 CE(S)T). Il verso può essere
favorevole o sfavorevole. E **nessuna riga lo dice**: in v1.12 la stampa del giorno nuovo sta solo in
`OnTimer` (r.382), ma `OnInit` ha già allineato la chiave.
**2. Come si provoca.** BERSAGLIO B. Ora di reset di prova = ora server successiva; posizione a lotto
minimo aperta; File → Esci **prima** dell'ora; riapertura 10-20 minuti **dopo**.
**3. PASS/FAIL.** È una **misura**, non un sì/no: si annota `DAYSTART_V2` (foto) contro il saldo e
l'equity **all'ora del reset** ricostruiti dallo Storico. ✅ PASS del test = i tre numeri sono stati
presi; il verdetto sul rischio è la differenza in euro, scritta accanto.
**4. Rischio del test.** Nullo; richiede di esserci a un'ora precisa.

### G04 · Guardian STACCATO, sedie attaccate
**1. Il codice.** 🔴 **Fail-open per disegno.** `OnDeinit` azzera il battito (v1.12 r.335). Le GV restano,
quindi per gli EA il canale **esiste** (v1.20 r.189-194). Il cap è un timestamp che invecchia e **scade
entro 120 s** (v1.20 r.73-74, r.114-118). La pausa **resta** fino alla sua scadenza (r.97-106). Nessuna
delle sei sedie censite passa `pretendi_guardian` (la settima, `770105`, `[NON VERIFICATA]`) (`GUARDIAN_SEI_SEDIE_2026-09-24.md` §5.4), quindi il motivo 3
(v1.20 r.135-145) non scatta mai. E soprattutto: **sparisce la chiusura d'emergenza**. Nessuna riga
avvisa: la guardia stampa `via libera` solo se prima stava bloccando (v1.20 r.302-304).
**2. Come si provoca.** BERSAGLIO B. Due varianti: (a) **cap acceso e pausa SPENTA** (posizione con SL
oltre il 4,00% dell'equity; foto F3 con `PAUSA_GIORNO` = 0 — con la pausa accesa la sonda resterebbe
ferma per PAUSA e il test misurerebbe (b), v1.20 r.140-141), sonda che tenta ogni 10 s → tasto destro sul grafico del Guardian → Expert Advisors →
Rimuovi, orario annotato al secondo; (b) **pausa accesa**, stessa rimozione.
**3. PASS/FAIL.** È il **criterio 8 del 02/09**, mai eseguito. (a) ✅ comportamento conforme al codice =
la sonda passa da `INGRESSO BLOCCATO -- CAP` a `via libera` **entro 120-130 s** dalla rimozione e apre
(Storico). (b) ✅ conforme = la sonda **resta bloccata** fino all'ora in `PAUSA_FINO`. Qualunque altro
esito è un FAIL della nostra comprensione del codice. 🔴 **E il verdetto di rischio si scrive a parte**:
il fail-open diventa un **fatto misurato**, col suo numero di secondi, per la firma di Claudio su
`pretendi_guardian`.
**4. Rischio del test.** Nullo. Rimettere il Guardian e verificare le due righe d'avvio (r.318-323).

### G05 · `Algo Trading` SPENTO dopo un riavvio
**1. Il codice.** 🟠 Il Guardian **non controlla mai** se può fare trading (0 occorrenze di
`TERMINAL_TRADE_ALLOWED` / `MQL_TRADE_ALLOWED` in v1.12): continua a girare e a scrivere, ma al breach
`FlattenAll()` fallisce ogni chiusura. La riga dice lo stesso **"CHIUSO TUTTO"** (r.411-412, r.418-419),
con accanto un conteggio `(0 ordini)`. Il blocco viene timbrato (r.410/r.417) e il **ri-tentativo ogni
secondo** (r.423-426) chiude appena l'Algo Trading torna verde. Le sedie non possono aprire (🟢 per gli
ingressi), ma **il freno d'emergenza è inerte** (🔴 per le posizioni aperte, che restano protette solo
dal loro SL sul server).
**2. Come si provoca.** BERSAGLIO B. Posizione a lotto minimo aperta → pulsante **Algo Trading** su
spento → breach per ancora (DD totale) → attesa 60 s → Algo Trading su verde.
**3. PASS/FAIL.** ✅ PASS: con Algo Trading spento compare la riga `DD TOTALE SFONDATO … (0 ordini)` e la
posizione **resta** nella scheda Trade; entro pochi secondi dalla riaccensione lo **Storico** mostra la
chiusura. ❌ FAIL: la posizione resta aperta dopo la riaccensione (il ri-tentativo non funziona).
**4. Rischio del test.** Lascia `FAILED` timbrato sul conto di prova (latch): pulizia da F3 (solo GV con
`[CONTO_GUASTI]`), test in fondo alla seduta.

### G06 · PERDITA DI CONNESSIONE
**1. Il codice.** 🔴 **Cieco e muto.** Nessun controllo della connessione (0 occorrenze di
`TERMINAL_CONNECTED`). Durante il buco: l'equity letta (r.367) è **l'ultima nota**; `TimeCurrent()` si
**ferma**, quindi si fermano il battito (r.371, ma anche gli EA hanno l'orologio fermo e lo vedono
"vivo"), il cambio di giorno (r.374) e perfino la **riga periodica** (r.489, che conta 300 s di
`TimeCurrent`): il Guardian **smette di scrivere** senza dire perché. Il server intanto muove i prezzi e
FTMO misura sul server. Al ritorno della connessione il primo `OnTimer` valuta l'equity vera; se il
breach c'è, chiude, e se la chiusura fallisce ri-tenta ogni secondo.
**2. Come si provoca.** BERSAGLIO B, e in più: **si isola solo `[CARTELLA_GUASTI]`**, in uno dei due modi,
da scegliere nella sessione dopo: (i) proxy inesistente in Strumenti → Opzioni → Server di **quel**
terminale (`[DA VERIFICARE]` che basti a staccarlo); (ii) regola del firewall di Windows in uscita sul
**solo** `terminal64.exe` di `[CARTELLA_GUASTI]` (riga R-C, da aggiungere e togliere). Varianti:
(a) buco di 2 minuti con posizione aperta; (b) durante il buco, breach per ancora → `FlattenAll` fallisce
→ ripristino.
**3. PASS/FAIL.** (a) ✅ conforme = nel giornale del terminale compaiono perdita e ripristino, e nelle
righe `[GUARDIAN]` **non** compare niente sulla connessione (è la misura del rilievo R-6). (b) ✅ PASS:
dopo la riga di connessione ritrovata, lo **Storico** mostra la chiusura entro pochi secondi. ❌ FAIL:
posizione ancora aperta dopo il ripristino.
**4. Rischio del test.** 🔴 **Isolare il terminale sbagliato**: una regola del firewall troppo larga
staccherebbe anche `50503392` o i download dei round. Controllo obbligatorio **durante** il buco: l'altro
terminale del PC resta connesso. Controllo obbligatorio **dopo**: la regola non esiste più.

### G07 · ORDINI PENDENTI RESIDUI
**1. Il codice.** 🔴/🟢 Due facce.
- 🔴 **Pausa e cap non toccano i pendenti.** Lo dice l'include stesso (v1.20 r.27-30: *"un ordine PENDENTE
  già piazzato quando il cap era libero scatterà lo stesso"*), e il rischio aperto conta **solo le
  posizioni** (v1.12 r.171-199, giro su `PositionsTotal()` r.177: buco **B6**). Le sedie Apertura lavorano
  a stop pendenti.
- 🟢 **Al breach i pendenti vengono cancellati**, di qualunque magic (r.353-359), **dopo** le posizioni:
  un pendente che si riempie fra le due fasi lo prende il ri-tentativo del secondo dopo (r.423-426).
- 🟠 Un EA **staccato** lascia i suoi pendenti sul server (`SOSPENSIONE_SEDIE_DEMO_2026-09-25.md` r.62).
**2. Come si provoca.** BERSAGLIO B. (a) Pausa accesa con `InpAction=1` → pendente a lotto minimo,
con SL, a pochi punti dal prezzo → attesa del riempimento. (b) Due-tre pendenti con SL la cui perdita
allo stop, sommata, supera il cap → lettura di `rischioAperto=`. (c) `InpAction=0`, pendenti piazzati,
breach per ancora.
**3. PASS/FAIL.** (a) ✅ conforme = il pendente **si riempie** durante la pausa (Storico: ora del deal
dopo la riga `PAUSA NUOVI INGRESSI attiva`). È la **misura del buco**, non una promozione. (b) ✅
conforme = `rischioAperto=0.00%` e `cap=off` con i pendenti vivi. (c) ✅ PASS: nello Storico **tutti** i
pendenti risultano cancellati entro pochi secondi dalla riga del breach, e **nessuno** si riempie dopo.
❌ FAIL: un pendente sopravvive o si riempie dopo il breach.
**4. Rischio del test.** Nullo sul demo. Il (c) lascia il blocco del giorno: in fondo alla seduta.

### G08 · Il BROKER NON RISPONDE o RIFIUTA la chiusura
**1. Il codice.** 🟠 `FlattenAll()` manda una chiusura per posizione **senza leggere il retcode** e
**senza ri-tentativo interno** (v1.12 r.350, r.358: conta solo i `true`). L'unico ri-tentativo è il giro
del secondo dopo (r.423-426), che è la cosa giusta per un rifiuto temporaneo. Tre casi:
- **(a) mercato chiuso** (pausa giornaliera degli indici): ogni secondo un tentativo fallito, una riga
  d'errore di `CTrade` al secondo per tutta la pausa, chiusura alla riapertura **al prezzo della
  riapertura**;
- **(b) modo di riempimento**: 🔴 il Guardian **non imposta il filling** (0 occorrenze di
  `SetTypeFilling` in v1.12 e a HEAD), mentre **tutte e sei le sedie censite il 24/09** chiamano
  `SetTypeFillingBySymbol(_Symbol)` (DAX `@9fca63d9` r.434 · Dow r.393 · Nasdaq r.447 · MaxMin `@5fc0bc31`
  r.137 · SuperWave `@872dba82` r.133 · EMA200 `@26a18566` r.123; la settima `770105` `[NON VERIFICATA]`: se gira lo stesso binario della 770101 ha la stessa riga). Se il `CTrade` della libreria del
  terminale adatti da solo il filling in chiusura è `[DA VERIFICARE]` nel `Trade.mqh` di `C:\FTMO`
  (sola lettura). ⚖️ **Non è un fatto che la chiusura fallisca**: nelle build recenti la libreria standard
  chiama `FillingCheck(simbolo)` dentro `PositionClose` e adatta il filling al simbolo **della posizione**
  (non a quello del grafico NZDJPY); se è così, R-1 è solo igiene. Oggi nel repo non c'è una copia di quel
  file, quindi nessuna delle due cose è dimostrata. 🔴 **La strada di chiusura del Guardian sui simboli FTMO
  non è mai stata percorsa**;
  🔎 **La verifica più corta, prima di G08(b) e a costo zero** (qui solo descritta: la riga la scrive la
  sessione dopo e passa dai cancelli): sul VPS, **in sola lettura**, il file
  `MQL5\Include\Trade\Trade.mqh` della cartella dati `46C9F8E9FF0C747B2B5E09BCC13D5237` (programma
  `C:\FTMO`, conto `541452707`); si cerca `FillingCheck` **dentro il corpo** di `CTrade::PositionClose` e si
  legge la data del file contro quella dell'`.ex5` del Guardian (**2026-09-20 16:58**, `CODA_06` del 28/09):
  conta la libreria **con cui è stato compilato**, quindi un file più recente dell'`.ex5` non chiude la
  domanda. Nessun terminale toccato, e **mai** aprendo il file in un editor (un salvataggio per errore
  cambierebbe la libreria con cui `C:\FTMO` ricompila). Esito: `FillingCheck` presente e file non più recente
  → R-1 scende a igiene e G08(b) a priorità MEDIA; assente → G08(b) resta ALTA;
- **(c) nessuna risposta / timeout**: non si provoca a comando. L'approssimazione è G06(b).
**2. Come si provoca.** BERSAGLIO B. (a) posizione su un indice aperta prima della sua pausa giornaliera;
breach per ancora **durante** la pausa. (b) **Solo sul conto di prova FTMO** `[CONTO_TRIAL]`
(`[CARTELLA_TRIAL]`, stesso PC, stessa lista §2.3 da non toccare): una posizione a lotto minimo per
simbolo delle sedie (`US30.cash`, `US100.cash`, `GER40.cash`), breach per ancora. Sul demo BCM la stessa
prova dice solo che la chiusura funziona **su BCM**.
**3. PASS/FAIL.** (a) ✅ PASS: chiusura nello Storico entro pochi secondi dalla riapertura; si annotano
anche **quante righe d'errore** ha scritto il log durante la pausa. (b) ✅ PASS: tutte le posizioni chiuse
al primo giro, **nessun** errore di modo di riempimento nel giornale. ❌ FAIL: un errore di riempimento →
il freno d'emergenza **non funziona su FTMO**, ed è una notizia da portare a Claudio **subito**.
**4. Rischio del test.** (a) lascia il blocco del giorno. (b) richiede il secondo conto: stessa disciplina
di bersaglio, **tre** terminali sul PC.

### G09 · CAMBIO GIORNO DEL SERVER (e il fine settimana)
**1. Il codice.** 🟠 Il giorno cambia **solo quando `TimeCurrent()` avanza** oltre l'ora di reset
(v1.12 r.106-112, r.374-383): cioè al primo tick dopo l'ora 1. La nuova baseline è l'**equity** (r.378),
FTMO usa il **saldo** delle 00:00 CE(S)T: con una posizione in perdita flottante sul confine il Guardian è
**più permissivo** della prop (crepa già misurata, `GUARDIAN_SEI_SEDIE_2026-09-24.md` §4.3). Al cambio si
azzerano pausa e blocco (r.379-381). Nel fine settimana l'orologio è fermo: il giorno nuovo del lunedì
parte al primo tick, con dentro il gap del weekend delle sedie che dormono in posizione (`771531`, `770511`).
**2. Come si provoca.** BERSAGLIO B. Ora di reset di prova = ora server successiva; pausa accesa
(`InpAction=1`); una posizione a lotto minimo in perdita flottante sul confine. Variante weekend: la stessa
posizione tenuta dal venerdì al lunedì sul demo.
**3. PASS/FAIL.** ✅ PASS: la riga `[GUARDIAN] nuovo giorno prop: baseline=X (pausa morbida azzerata)`
compare nel primo minuto dopo l'ora di reset (ora server); `PAUSA_GIORNO` torna 0; la sonda torna a
passare. Si annota **X contro il saldo** allo stesso istante: la differenza in euro è la crepa, misurata.
❌ FAIL: nessuna riga, oppure la pausa sopravvive al giorno nuovo.
**4. Rischio del test.** Nullo.

### G10 · CAMBIO D'ORA del 25/10/2026
**1. Il codice.** 🟠 `InpDailyResetHour=1` è un'ora **fissa del server** (v1.12 r.72, r.110). È giusta
solo se il server FTMO passa a GMT+2 insieme all'Europa; i referti di casa **si contraddicono**
(`IL_CONFINE_DEL_GIORNO_2026-09-23.md` §3.3): se il server restasse a GMT+3, il nostro giorno partirebbe
alle **23:00 CET**, un'ora prima di FTMO. Il salto dell'orologio avviene alle 04:00 server, **dopo**
l'ora 1: niente doppio reset.
**2. Come si provoca.** **Non si provoca: si osserva.** Il demo BCM **non serve** (BCM è UTC+1 fisso).
Due strade, decide Claudio: (a) sul conto di prova FTMO `[CONTO_TRIAL]` (PC di backtest): scarto
server-GMT lunedì 26/10 e ora della riga `nuovo giorno prop`; (b) una sonda di **sola lettura** della
corsia notturna su `C:\FTMO` (scarto `TimeTradeServer()-TimeGMT()`): è una lettura, non un'iniezione, ma
è una riga nuova sul VPS e **passa dai cancelli**.
**3. PASS/FAIL.** ✅ PASS: dopo il 25/10 lo scarto del server FTMO è **+2** e la riga del giorno nuovo cade
alle 01:00 server = 00:00 CET. ❌ FAIL: scarto **+3** → l'ora di reset va rifirmata **prima** del 26/10.
**4. Rischio del test.** Nullo; è una data, non un'azione.

### G11 · CALCOLO DELL'EQUITY E DEL RISCHIO APERTO
**1. Il codice.** 🟢/🟠 L'equity è quella del conto, flottante incluso (v1.12 r.367): la stessa grandezza
di FTMO, ma **campionata una volta al secondo** (r.317) mentre FTMO guarda ogni tick (buco dichiarato il
18/09 §5). Il rischio di ogni posizione è la perdita allo stop calcolata da `OrderCalcProfit`, con ripiego
su valore e dimensione del tick (r.138-158), e le posizioni **senza SL** sono escluse (r.182-188).
**2. Come si provoca.** BERSAGLIO B. Due posizioni a lotto minimo su simboli in **valute diverse** dal
conto (un indice USA, un indice EUR), SL vicini; si leggono `rischioAperto=` e il pannello; si lasciano
colpire gli stop.
**3. PASS/FAIL.** ✅ PASS: la perdita **realizzata** allo stop (Storico) coincide con quella **prevista**
dal Guardian a meno di **commissione + swap + differenza fra prezzo dello SL e prezzo del deal**, tutte e
tre leggibili nello Storico. ❌ FAIL: resta uno scarto che quelle tre voci non spiegano. 🟢 Variante
gratuita: la stessa verifica **in sola lettura** sui dati già raccolti della challenge (righe
`rischioAperto=` di `CODA_09` contro le chiusure a stop viste nello Storico), se una sedia ha chiuso a stop pieno.
**4. Rischio del test.** Nullo.

### G12 · CONCORRENZA TRA EA
**1. Il codice.** 🔴 Tre modi.
- **(a) Due ingressi nello stesso secondo.** Il cap è calcolato **dopo**, una volta al secondo, sulle
  posizioni già aperte (v1.12 r.440-459); la guardia legge una bandiera (v1.20 r.288-294) e **non prenota
  niente**. Due sedie che chiedono nello stesso secondo passano entrambe. Con il cap a 4,00% e sedie al
  2,00%, **tre** ingressi simultanei passerebbero: su FTMO quattro sedie su sette stanno sugli indici USA
  e due armano all'apertura di New York; altre due (`770101`, `770105`) armano insieme sull'apertura del DAX.
- **(b) Pendenti che si riempiono insieme** all'apertura: invisibili al cap (G07).
- **(c) Chiusura e rientro.** Se pausa ed emergenza scattano **nello stesso secondo** (un gap),
  `FlattenAll()` (r.416) gira **prima** di `SetPausa()` (r.432 per la soglia, r.435 per il blocco): per la durata delle chiusure una sedia
  che vede sparire la sua posizione può rientrare. Il ri-tentativo del secondo dopo la richiude, al costo
  di uno spread.
**2. Come si provoca.** BERSAGLIO B. (a) Due sonde P4 su due grafici, magic diversi, orario di tentativo
**identico al secondo**, con una posizione già aperta che porta il rischio poco sotto il cap. (c) Sonda in
modalità "rientra appena chiusa", breach per ancora che salta pausa ed emergenza insieme.
**3. PASS/FAIL.** (a) ✅ conforme al codice = entrambe aprono e il `rischioAperto=` successivo supera il
cap: si annota **di quanto**. È la misura dello sforamento, per la firma di Claudio. (c) ✅ conforme = si
annota se nello Storico c'è un deal della sonda **fra** la riga del breach e la riga della pausa, e in
quanti secondi il ri-tentativo lo ha chiuso.
**4. Rischio del test.** Nullo sul demo. Le sonde non devono **mai** finire in una cartella del VPS: nome
diverso da ogni sedia, e la riga di raccolta verifica che non siano state copiate altrove.

### G13 · DUE GUARDIAN sullo stesso conto
**1. Il codice.** 🔴 **Nulla lo impedisce e nulla lo segnala**: `OnInit` non cerca un fratello. Due
istanze nello stesso terminale scrivono **le stesse** GlobalVariable (v1.12 r.270-281). Con preset
identici il danno è piccolo (doppie chiusure, righe d'errore). Con **ore di reset diverse** (per esempio
un Guardian del 100k con reset 23 caricato per errore) ognuna vede la chiave del giorno dell'altra come
"diversa" (r.375) e **riscatta la baseline a ogni secondo** (r.377-378): 🔴 **la perdita del giorno non
si accumula mai e l'emergenza giornaliera non scatta più**. ✏️ **Ma solo in una finestra oraria**: le
due chiavi (`PropDayKey()` r.106-112, ora `t - h x 3600`) differiscono solo quando l'ora server `H` sta
**fra** le due ore di reset (`h1 <= H < h2`); fuori da lì coincidono e i due Guardian convivono. Con
reset 1 e 23 la finestra è 01:00-22:59 server, 22 ore su 24. Due Guardian su **due terminali** loggati sullo
stesso conto: le GV sono per terminale, quindi le sedie dell'altro terminale non vedono né pausa né cap.
**2. Come si provoca.** BERSAGLIO B. Secondo grafico, stesso binario, preset di prova con **ora di reset
diversa**, scelta in modo che l'ora server del test stia **fra** le due ore di reset (per esempio 1 e 23 con
il test fra le 02:00 e le 22:00 server: fuori da quella finestra il fail-open non c'è e il test esce
"non conforme" per un motivo sbagliato); posizione a lotto minimo in perdita.
**3. PASS/FAIL.** ✅ conforme al codice = nel log compare `nuovo giorno prop` **a ogni secondo** e in F3
l'ora di modifica di `DAYSTART_V2` si aggiorna di continuo. È la prova del fail-open. Qualunque altro
esito va capito prima di andare avanti.
**4. Rischio del test.** Il log si allaga in pochi minuti: durata del test breve, e il secondo Guardian
va **rimosso e il profilo salvato** prima di chiudere la seduta.

### G14 · Guardian riattaccato SENZA preset (o col preset sbagliato)
**1. Il codice.** 🔴 Con i default del sorgente l'ancora è 0 → viene dalla GV già scritta (r.295), ma le
soglie diventano **5,0 / 10,0**, cioè **esattamente i muri FTMO** (margine zero), pausa 4,0, cap 3,25 e
reset all'**ora 0** (r.68-78): un'ora prima del confine FTMO. Per onestà: il **cap** invece si **stringe**
(3,25 contro 4,00); il 🔴 viene da emergenza, DD e pausa che si allentano. Nessun avviso, ma le due righe d'avvio
stampano tutto (r.318-323).
**2. Come si provoca.** BERSAGLIO B. Rimuovere il Guardian e riattaccarlo **senza** caricare il preset.
**3. PASS/FAIL.** ✅ PASS del test = le due righe d'avvio mostrano i default e il pannello li conferma.
Il valore del test è **la procedura**: dopo **ogni** riattacco in campo si leggono quelle due righe.
**4. Rischio del test.** Nullo.

### G15 · Sedie che partono PRIMA del Guardian dopo un riavvio
**1. Il codice.** 🟠 Al riavvio i grafici si caricano in ordine (su `C:\FTMO` il Guardian è `chart06`,
`GUARDIAN_SEI_SEDIE_2026-09-24.md` §1.1). Nel frattempo il battito è vecchio: il cap è già scaduto
(fail-open per i secondi del caricamento), la pausa invece tiene fino alla sua scadenza. Se le GV sono
andate perse (G02), `ABTG_CanaleEsiste()` è falso (v1.20 r.189-194) e le sedie passano tutte.
**2. Come si provoca.** Come G01, ma con il **cap acceso e la pausa SPENTA** (dentro G01 e G02 la pausa è
accesa e maschera il cap: la guardia controlla la pausa per prima, v1.20 r.140-141), e con la sonda su un
grafico **precedente** a quello del Guardian. Dentro G02 si osserva solo il caso "GV perse".
**3. PASS/FAIL.** Si annota il primo tentativo della sonda dopo la riapertura e la prima riga
`[GUARDIAN] avviato`: se la sonda **passa prima** con il cap che prima del riavvio la bloccava, la finestra
è misurata in secondi.
**4. Rischio del test.** Nullo.

---

## 6️⃣ I RILIEVI SUL CODICE — trovati leggendo, nessuno corretto

| # | rilievo | dove (v1.12 al pin, se non detto) | effetto | nuovo o già noto |
|---|---|---|---|---|
| **R-1** | 🔴 la chiusura d'emergenza **non imposta il filling**, le sei sedie censite sì (la settima `[NON VERIFICATA]`) | `CTrade gTrade` r.96, `SetExpertMagicNumber` r.316, nessun `SetTypeFilling`; sedie: sei righe citate in G08 | `[DA VERIFICARE]`: se la `PositionClose` della libreria adatta il filling al simbolo della posizione (`FillingCheck`, build recenti) è solo igiene; se non lo fa, la chiusura d'emergenza su FTMO **può** essere rifiutata e il +13,7 del Monte Carlo andrebbe rimisurato. Verifica più corta: lettura di `Trade.mqh` di `C:\FTMO` (G08) | 🆕 |
| **R-2** | 🔴 nessun `GlobalVariablesFlush()` | 0 occorrenze in v1.12 e a HEAD | lo stato del freno (baseline, blocco, pausa) sopravvive a un crash **solo se MT5 lo ha già salvato** | 🆕 |
| **R-3** | 🔴 nessuna difesa da un secondo Guardian | `OnInit` r.257-326 | con ore di reset diverse la baseline si riscatta ogni secondo (r.375-378) e il freno giornaliero muore, **nelle ore fra le due ore di reset** (r.106-112; 1 e 23 → 22 ore su 24) | 🆕 |
| **R-4** | 🔴 "variabile persa" = "giorno nuovo" | r.304 (`OnInit`), r.375 (`OnTimer`) | la perdita del giorno si azzera; a HEAD è r.608 e r.715 | noto dal 18/09 (a HEAD) |
| **R-5** | 🟠 la riga del breach dice "CHIUSO TUTTO" anche con zero chiusure riuscite | r.411-412, r.418-419 | chi legge il log crede chiuso un conto aperto; la verità è solo nello Storico | 🆕 |
| **R-6** | 🟠 nessun controllo di connessione né di permesso di trading | 0 occorrenze di `TERMINAL_CONNECTED`, `TERMINAL_TRADE_ALLOWED`, `MQL_TRADE_ALLOWED` | cieco e muto durante una disconnessione (anche la riga periodica si ferma, r.489) e con Algo Trading spento | 🆕 |
| **R-7** | 🟠 `OnInit` v1.12 non stampa la baseline quando cambia giorno all'avvio | r.303-311 | un riavvio a cavallo del reset non lascia traccia nel giornale (la v1.14 lo stampa, HEAD r.619-620) | 🆕 |
| **R-8** | 🟠 `FlattenAll()` prima di `SetPausa()` nello stesso giro | r.416 contro r.432 e r.435 | finestra di rientro se pausa ed emergenza scattano insieme | 🆕 |
| **R-9** | 🔴 il cap è a posteriori e cieco sui pendenti | r.171-199, r.440-459; v1.20 r.27-30 | sforamento con ingressi simultanei e pendenti | noto (B6, 02/09) |
| **R-10** | 🔴 nessuna sedia pretende il Guardian | v1.20 r.282-286; sei sedie censite a due argomenti, la settima `[NON VERIFICATA]` | Guardian staccato = sedie libere e nessuna chiusura d'emergenza | noto (24/09 §5.4) |
| **R-11** | 🟠 baseline dall'equity, FTMO dal saldo | r.307, r.378 | più permissivi della prop con flottante negativo sul confine | noto (24/09 §4.3) |
| **R-12** | 🟠 `PropDayKey()` non limita l'input, `NextResetTime()` sì | r.110 contro r.122 | con un'ora fuori scala il giorno e la scadenza della pausa divergono | noto (18/09, a HEAD) |

✋ **Nessuna correzione proposta qui.** R-1, R-2, R-3, R-6 sono modifiche al Guardian: nuovo pin, F7 e
riattacco su `C:\FTMO` a challenge viva. **Decide Claudio**, con i risultati dei test davanti, non prima.

---

## 7️⃣ LA TABELLA FINALE

Priorità = **quanto costa alla challenge se il guasto accade e il Guardian si comporta come dice il
codice**. ALTA = il freno giornaliero o d'emergenza sparisce senza avviso (la modalità di morte che il
Monte Carlo dà per annullata). MEDIA = il freno arriva tardi o in modo diverso da FTMO. BASSA = già
dichiarato, oppure solo procedura.

| # | guasto | comportamento dal codice | provato? | costo per Claudio | priorità |
|---|---|---|---|---|---|
| G02 | riavvio brutale, GV perse | 🔴 fail-open se le GV non sopravvivono: perdita del giorno azzerata, blocco dimenticato (r.304-307) | ❌ NO | 30 min | 🔴 **ALTA** |
| G08 | broker rifiuta / filling / mercato chiuso | 🟠 ri-tenta ogni secondo; 🔴 filling mai impostato (R-1) | ❌ NO | 20 min (a) + 30 min (b, conto di prova FTMO) | 🔴 **ALTA** |
| G12 | concorrenza tra EA | 🔴 ingressi simultanei e pendenti sforano il cap | ❌ NO | 30 min | 🔴 **ALTA** |
| G04 | Guardian staccato | 🔴 fail-open per disegno, cap scade in 120 s, emergenza sparita | ❌ NO (criterio 8 del 02/09 mai eseguito) | 15 min | 🔴 **ALTA** |
| G05 | Algo Trading spento | 🟠 ingressi fermi, emergenza inerte, riga ingannevole | ❌ NO | 15 min | 🔴 **ALTA** |
| G13 | due Guardian | 🔴 baseline riscattata ogni secondo con reset diversi, nelle ore fra i due reset | ❌ NO | 15 min | 🔴 **ALTA** |
| G06 | perdita di connessione | 🔴 cieco e muto; chiude al ritorno | ❌ NO | 25 min | 🔴 **ALTA** |
| G09 | cambio giorno server / weekend | 🟠 baseline = equity, non saldo | ❌ NO (crepa misurata nel codice, mai in campo) | 20 min + attesa | 🟠 MEDIA |
| G10 | cambio d'ora 25/10 | 🟠 ora fissa del server, giusta solo se FTMO passa a GMT+2 | ❌ NO | 5 min il 26/10 | 🟠 MEDIA (**con scadenza**) |
| G03 | riavvio a cavallo del reset | 🟠 baseline all'ora del riavvio, nessuna riga | ❌ NO | 20 min + ora precisa | 🟠 MEDIA |
| G07 | pendenti residui | 🔴 pausa e cap non li vedono; 🟢 il breach li cancella | ❌ NO | 30 min | 🟠 MEDIA |
| G15 | sedie prima del Guardian al riavvio | 🟠 cap scaduto per i secondi del caricamento | ❌ NO | variante di G01 col cap (~10 min) | 🟢 BASSA |
| G11 | calcolo equity e rischio | 🟢 grandezza giusta, campionata a 1 s | ❌ NO | 30 min (o sola lettura) | 🟢 BASSA |
| G14 | riattacco senza preset | 🔴 soglie = muri FTMO, reset ora 0; righe d'avvio lo dicono | ❌ NO | 10 min | 🟢 BASSA (è procedura) |
| G01 | riavvio pulito | 🟢 stato ricostruito dalle GV | ❌ NO (in campo verificato solo il filo, 19/08) | 20 min | 🟢 BASSA |

**Totale**: preparazione ~60-90 min una volta + ~5 h di prove, in tre sedute + 5 minuti il 26/10.

---

## 8️⃣ L'ORDINE PROPOSTO DELLE SEDUTE — e che cosa resta a Claudio

| seduta | test | perché in quest'ordine |
|---|---|---|
| **0** | P0-P7 | senza banco dedicato non parte niente |
| **1** (~1,5 h) | G01 → G15 (variante di G01: cap acceso, pausa spenta) → **G02** → G02b → G04 → **G05** per ultimo | la famiglia "riavvio": è quella del pronto soccorso di `CLAUDE.md`, e G05 lascia un latch |
| **2** (~1,5 h) | **G12** → G13 → G07(a,b) → **G08(a)** → G07(c) per ultimo | la concorrenza va fatta **a mercato aperto**; G08(a) cade sulla pausa giornaliera di un indice |
| **3** (~1,5 h) | G06 → G09 → G03 → G11 → G14 | G09 e G03 richiedono di esserci all'ora di reset di prova |
| **26/10** | G10 | data fissa, 5 minuti |
| **se Claudio apre il conto di prova FTMO** | G08(b), G10(a) | gli unici due che il demo BCM non può dire |

⏰ **Fuori dalle finestre in cui le sedie FTMO armano** (09:00 e 15:30 italiane): non per interferenza
tecnica (il banco è su un altro conto e un'altra macchina) ma perché in quei minuti Claudio deve poter
guardare `C:\FTMO` senza avere **tre** finestre MT5 aperte davanti.

✋ **Resta di Claudio**: aprire `[CONTO_GUASTI]` (ed eventualmente `[CONTO_TRIAL]`) · il deposito del demo ·
se e quando fare le sedute · che cosa fare dei risultati (R-1, R-2, R-3, R-6, `pretendi_guardian`,
ricompilazioni su `C:\FTMO`).

---

## 9️⃣ LE RIGHE CHE SERVIRANNO — solo che cosa devono fare (le scrive la sessione dopo, passano dai cancelli)

| riga | dove gira | che cosa deve fare | che cosa NON deve toccare |
|---|---|---|---|
| **R-A** | 🖥️ finestra PowerShell sul **PC di backtest** | stampare PID, titolo e cartella di **ogni** `terminal64` aperto, così `[CARTELLA_GUASTI]` si riconosce per fatto stampato | sola lettura |
| **R-B** | 🖥️ finestra PowerShell sul **PC di backtest** | preceduta dall'`irm` dal branch `lavoro`; estrarre Guardian `@d884f7e1` e include `@26a18566`, verificarne l'impronta come `SCHIERA_FTMO.ps1` r.176-186, copiarli **solo** in `[CARTELLA_GUASTI]\MQL5`, rifiutare se la cartella di destinazione non è quella | la cartella dati del terminale `50503392` del PC |
| **R-C** | 🖥️ finestra PowerShell sul **PC di backtest**, come amministratore | aggiungere e poi togliere una regola del firewall in uscita **solo** sull'eseguibile di `[CARTELLA_GUASTI]`, stampando alla fine che la regola non esiste più | ogni altro eseguibile, compreso il `terminal64` di `50503392` |
| **R-D** | 🖥️ finestra PowerShell sul **PC di backtest** | raccolta a fine seduta: copiare `MQL5\Logs`, `Logs` e i referti del canarino di `[CARTELLA_GUASTI]` in una cartella sul Desktop, fare lo zip, elencare in console i file attesi | nessuna scrittura fuori dal Desktop |
| **R-E** *(solo G10 b)* | 🖥️ corsia di **sola lettura** del runner su `C:\FTMO` | stampare lo scarto server-GMT del terminale FTMO dopo il 25/10 | nessuna scrittura, nessun EA, nessun ordine |
| **P4** | file `.mq5` **nuovo** | la sonda d'ingresso (§3) | nessuna sedia esistente; nome diverso da ogni sedia |

🔴 **Niente emoji dentro quelle righe** (Regola delle righe di lancio punto 4): PowerShell 5.1 legge i
`.ps1` come ANSI.

---

## 🔟 I CONTRO-ESEMPI CHE HO COSTRUITO CONTRO QUESTO DOCUMENTO

| # | *«e se…»* | risposta |
|---|---|---|
| ① | *«hai letto HEAD e in campo vola altro»* | 🟢 ogni riga citata è **al pin** (§1); dove cito HEAD lo scrivo. I sei `SetTypeFillingBySymbol` sono letti ai **pin** delle sedie, non a HEAD |
| ② | *«un PASS di G04 esce perché nessuno ha provato a entrare»* | 🟢 per questo esiste la sonda P4: tenta a orari fissi e stampa **ogni** tentativo. Tre minuti senza tentativi = `NON MISURATO`, non PASS (stessa regola del 02/09 §2.6) |
| ③ | *«un PASS di G02 esce perché MT5 ha salvato in una chiusura normale»* | 🟢 il giornale del terminale non deve avere la riga di chiusura normale; e un PASS da uccisione del processo **non** certifica un reset della macchina (dichiarato) |
| ④ | *«la chiusura "riuscita" la leggi dalla riga del Guardian»* | 🟢 no: R-5 mostra che quella riga dice "CHIUSO TUTTO" anche a zero chiusure. **Ogni PASS di chiusura si legge nello Storico** (classe 896) |
| ⑤ | *«il test del filling sul demo BCM prova FTMO»* | 🔴 no, ed è scritto in G08: su BCM prova BCM. Per FTMO serve `[CONTO_TRIAL]` o nessuna prova |
| ⑥ | *«il trucco dell'ancora è una soglia travestita»* | 🟢 le percentuali del campo restano (4,5 / 9,3 / 3,5 / 4,00): si sposta solo l'ancora su un conto finto, e la formula viene dal codice (r.393-398). Nessun numero per il campo |
| ⑦ | *«il 7 su 15 fail-open è contato per differenza»* | 🟢 elencati per nome: **G02, G04, G06, G07, G12, G13, G14**. G08 è contato **a parte** perché il suo 🔴 (filling) è condizionato a un file non letto; G05 è 🟠 perché ferma gli ingressi anche se rende inerte l'emergenza. ✏️ E dentro i sette il grado è dichiarato (§0 punto 4): **G02** è condizionato a una perdita delle GV `[NON MISURATA]`, **G13** a una finestra oraria |
| ⑧ | *«i test si passano lo stato l'uno con l'altro»* | 🟢 sì, se non si pulisce: pausa, blocco e `FAILED` sono latch nelle GlobalVariable. Per questo ogni test parte da una foto F3 di stato pulito (§5, "Stato di partenza") |

---

## 1️⃣1️⃣ CHE COSA QUESTO DOCUMENTO NON FA

- ❌ Non esegue niente e non dice che il Guardian **funziona** o **non funziona**: dice **che cosa dice il
  codice** e **come si misura**. Un test conforme al codice che è fail-open **non è una buona notizia**:
  è un fatto misurato da portare alla firma.
- ❌ Non propone soglie, taglie, né un valore per `pretendi_guardian`.
- ❌ Non tocca nessun `.mq5`, nessun preset, nessun terminale, nessun conto.
- ❌ Non chiude il punto 4 di Emiliano: lo chiude **l'esecuzione**, seduta per seduta, con i referti in repo.

🧭 **La bussola**: il +13,7 del Monte Carlo sta tutto su una frase, *«il Guardian chiude davvero a 4,5%»*.
Questo documento è l'elenco dei modi in cui quella frase può essere falsa, e il prezzo per scoprirlo
**su un conto finto**, prima che lo scopra la challenge. 🛡️

*Bozza del 28/09/2026. Letti: `docs/PARERE_EMILIANO_2026-09-28.md`, `ABTG_Guardian.mq5` (HEAD e
`@d884f7e1`), `ABTG_PausaGuardian.mqh` (HEAD e `@26a18566`), `ABTG_Guardian_FTMO_2Step.set`, le sei sedie
ai loro pin (solo `SetTypeFilling` e GlobalVariable), `GUARDIAN_SEI_SEDIE_2026-09-24.md`,
`IL_GUARDIAN_IN_CAMPO_2026-09-12.md`, `CANARINO_GUARDIAN_CIECO_2026-09-08.md`,
`COLLAUDO_ENFORCEMENT_FASE1_2026-09-02.md`, `IL_GUARDIAN_CONTRO_LA_REGOLA_CHE_CI_HA_UCCISI_2026-09-18.md`,
`BREACH_FUNDEDNEXT_2026-09-18.md`, `IL_CONFINE_DEL_GIORNO_2026-09-23.md`, `SOSPENSIONE_SEDIE_DEMO_2026-09-25.md`,
`IL_PIANO_DEGLI_OTTO_GIORNI_2026-09-23.md` §3.2, classe 896 della checklist.*

*Cancello strato 2 del 28/09 su `44d7d93f`: 12 rilievi riletti sul codice al pin (confermati; R-1 riscritto come
`[DA VERIFICARE]` con la verifica più corta, R-3 con la sua finestra oraria, R-8 con r.432); aggiunti lo stato di
partenza dei test (classe 902), la finestra di G13 (classe 901), la settima sedia `770105` e le cartelle dati per nome
(classi 755 e 761).*
