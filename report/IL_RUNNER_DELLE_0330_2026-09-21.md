# ⏰ IL RUNNER DELLE 03:30 — la regola firmata stamattina che stanotte si sarebbe disapplicata da sola

**Data**: 2026-09-21 · **Branch**: `lavoro` · **Pin del pacchetto**: `83664b6e`
**Righe pronte**: `backtest_pipeline/righe/RIGA_SOSPENDI_RUNNER_DA_MANDARE.md`
**Script**: `backtest_pipeline/righe/SOSPENDI_RUNNER_NOTTURNO.ps1`
(marcatore `MARCATORE_SOSPENDI_RUNNER_NOTTURNO_v1`)

---

## 1. 🔴 IL FATTO, e il conto alla rovescia

Il 21/09 alle ~09:29 — **prima mezz'ora del primo giorno di challenge FTMO** — il VPS
si è inchiodato: niente PowerShell, niente tasto destro, niente Gestione attività.
Causa letta dalla schermata: Strategy Tester a **«Ogni tick basato su tick reali»** sul
terminale banco `50504400` (`C:\MT5_Backtest`), sulla **stessa macchina** dove le **sei
sedie FTMO** stavano operando.

Claudio ha firmato la regola lo stesso giorno: **i round girano sul PC di backtest**
finché una challenge è viva. La regola è in `CLAUDE.md`.

🔴 **Ma una regola non spegne un'attività pianificata.** Misurato nel repo:

| dove | che cosa dice |
|---|---|
| `backtest_pipeline/runner_abtg.ps1` **r.91** | `[string]$Ora = "03:30",  # ora VPS della corsa notturna` |
| **r.653** | `$task = "ABTG_Runner"` |
| **r.654** | `$azione = "powershell -NoProfile -ExecutionPolicy Bypass -File $dest"` con `$dest = C:\ABTG\runner_abtg.ps1` (r.650) |
| **r.678** | `schtasks /Create /TN ABTG_Runner /TR "$azione" /SC DAILY /ST 03:30 /F` |

👉 **`ABTG_Runner` è registrata sul VPS, DAILY, 03:30.**

### 🔥 E non è un rischio teorico: la catena è viva e la coda è PIENA

Ho seguito la catena fino in fondo invece di fermarmi al nome, e sono **fatti contati**,
non impressioni:

1. **r.722** — il runner scarica la coda dal **branch `lavoro` in HEAD**, con cache-buster:
   `$urlCoda = $RawBase + "/" + $Branch + "/" + $CodaPath + "?cb=..."`. Cioè legge
   **esattamente il file che è nel repo adesso**.
2. **r.774** — per ogni riga della coda:
   `Start-Process -FilePath "powershell.exe" -ArgumentList $argv -NoNewWindow -PassThru -Wait`.
3. La riga di coda punta a `backtest_pipeline/righe/RIGA_SOTTILE_ROUND.ps1`, che a
   **r.1540** costruisce `$exeBanco = Join-Path $BancoBT "terminal64.exe"` e a **r.1616**
   lo lancia. **Questo è il tester.**
4. 📊 **Contate su `backtest_pipeline/coda/CODA.txt` adesso** (righe non commentate):

| misura | numero |
|---|---|
| righe **attive** in coda | **127** |
| di cui in corsia **ROUND** (`RIGA_SOTTILE_ROUND.ps1`) | **115** |
| di cui con **`-Modello 4` = «Ogni tick basato su tick reali»** | 🔴 **82** |

🔴 **Ottantadue corse a tick reali**, cioè **esattamente il modello che stamattina ha
inchiodato la macchina**, in coda su un runner che parte alle 03:30 sulla stessa
macchina delle sei sedie FTMO. Non ho trovato nel runner nessun meccanismo che salti
le righe già eseguite: la memoria di cosa è già girato è il **commento `#`** messo a
mano nella coda. Senza il gesto di stanotte, quelle 82 ripartono.

🕐 **Quel 03:30 è ora di Windows sul VPS = ora italiana** (02:30 ora server BCM). Non è
un orario di sessione: è l'orologio della macchina. Lo dico perché la distinzione
log/grafico è già costata un annuncio sbagliato il 06/08.

---

## 2. 🧾 COSA È STATO PRODOTTO — due righe separate, nell'ordine giusto

### PASSO 1 — la diagnosi, **di sola lettura**
Riga locale autonoma (nessun download, nessun pin: non serve, perché non scarica ed
esegue niente — classe 173). Stampa, per ogni attività di casa:
- **nome, cartella, stato** (`Ready` / `Disabled` / `Running`);
- **trigger** con `StartBoundary` e se il trigger è attivo;
- **l'azione eseguita e DA QUALE PERCORSO** ← è la casella che il 12/09 ci ha fregati:
  l'attività delle 07:20 girava da una copia sul Desktop, arrivata da uno zip di un
  **branch vecchio**, quindi le riparazioni su `lavoro` non arrivavano a quello che girava;
- **ultima corsa, ultimo esito, PROSSIMA esecuzione**;
- le attività di casa **attese ma non trovate**, per nome (classe 180: un insieme si
  elenca, non si definisce per differenza);
- **le copie del runner su disco** (`C:\ABTG` e Desktop) con byte e data;
- 🔎 e cattura anche **un'attività ribattezzata**: il filtro guarda pure il testo
  dell'azione (`runner|ABTG|coda`), non solo il nome.

### PASSO 2 — la sospensione, **reversibile e verificata**
`Disable-ScheduledTask` (**mai** `Unregister-ScheduledTask`, **mai** `schtasks /Delete`).
Lo script:
1. fotografa l'attività **PRIMA**;
2. disabilita;
3. **rilegge da zero** e pretende `State = Disabled` e nessuna prossima corsa —
   **il verdetto sta sull'artefatto, non sul codice di uscita** (classe 154);
4. elenca **cosa resta acceso stanotte** con stato e prossima corsa;
5. **conta i processi dei terminali prima e dopo** e stampa i due numeri: il «non ho
   toccato niente» è un fatto misurato, non una promessa;
6. raccoglie referto + zip sul Desktop del VPS (regola 11/08).

### PASSO 3 — la riga per **riaccendere**, scritta subito
`-Riaccendi` (`Enable-ScheduledTask`), con la stessa verifica sull'artefatto
(atteso `Ready`). Sta nello stesso documento: una sospensione senza la sua riga di
rientro è una sospensione che a challenge finita nessuno ricorda di sciogliere.

---

## 3. 🧪 I CONTRO-ESEMPI, costruiti ed ESEGUITI (regola del 10/09)

Lo script è stato fatto girare sotto **stub** dei cmdlet di pianificazione, provando
apposta i casi che lo farebbero mentire:

| caso provato | esito misurato | giusto? |
|---|---|---|
| nominale: l'attività passa `Ready` → `Disabled` | `FATTO`, **uscita 0** | ✅ |
| **il comando "riesce" ma lo stato NON cambia** | `NON RIUSCITO: lo stato dopo non e' quello atteso`, **uscita 1** | ✅ è il caso che conta |
| `Accesso negato` (serve l'amministratore) | errore stampato + istruzione, **uscita 1** | ✅ |
| l'attività **non esiste** | `NON HO CAMBIATO NIENTE` + elenco delle `*ABTG*` viste, **uscita 1** | ✅ |
| `-Riaccendi` da `Disabled` | `Ready`, **uscita 0** | ✅ |

🟢 Il secondo è il motivo per cui lo script esiste in questa forma: **un comando che
non protesta non è una prova che qualcosa sia cambiato.**

📌 Nota onesta di metodo: durante la prova il banco ha mostrato `stato PRIMA` vuoto.
Non era un difetto dello script — era lo **stub** (`$script:` in una funzione non-modulo
si risolve nello scope dello script *chiamante*). È stato isolato con un test a tre
righe **prima** di toccare il codice buono. Dichiarato perché la lezione è che un banco
rotto produce diagnosi sbagliate tanto quanto un programma rotto.

---

## 4. 🚦 IL CANCELLO DETERMINISTICO

| oggetto | esito |
|---|---|
| `--ps1 backtest_pipeline/righe/SOSPENDI_RUNNER_NOTTURNO.ps1` | **verde**, 6 passati, 0 bloccanti, 0 rilievi |
| `--riga` (passo 1, diagnosi) | **verde**, ASCII puro + «riga di SOLA LETTURA locale (lista bianca)» |
| `--oggetto md backtest_pipeline/righe/RIGA_SOSPENDI_RUNNER_DA_MANDARE.md` | **verde**, 10 passati, 1 rilievo |

Il rilievo è il **225**: la prosa nomina un conto vietato (`50504263`) alla riga 28 —
ed è **la riga che lo elenca per ESCLUDERLO**. Riletta a mano: corretta. È esattamente
il caso per cui il 225 è un rilievo e non un blocco.

---

## 5. ⚠️ LA PORTA CHE RIAPRE DA SOLA — e che va detta

`runner_abtg.ps1 -Installa` fa **`schtasks /Delete` e poi `/Create`** (r.677-678):
cioè **ricrea l'attività da zero, ABILITATA**. 👉 Finché la challenge è viva,
**`-Installa` non si lancia.**

Verificato che è l'**unico** modo in cui la sospensione può tornare indietro da sola:
il runner **non** si re-registra e **non** si ri-abilita quando gira; nessun altro
script di casa con un'attività pianificata (`pubblica_trades`, `scarica_pagella`,
`archivia_test_desktop`, `aggiorna_news`, i due `report_scheduler`) contiene
`Start-Process`, `terminal64` avviato o `metatester` — l'unico che nomina `terminal64.exe`
è `aggiorna_news.ps1` r.54, e lo fa con `Get-ChildItem`, cioè per **trovare le cartelle
dati**, non per avviare niente.

---

## 6. 🪑 COSA RESTA DA FARE (non è coperto da queste righe)

| cosa | stato |
|---|---|
| sospendere `ABTG_Runner` sul VPS | ⏳ **la riga è pronta, ma va lanciata da Claudio**: da qui non si tocca il VPS |
| 🟡 **la seconda cintura**: commentare le 115 righe ROUND attive in `CODA.txt` | ❌ **non fatto, e non l'ho fatto apposta**: è una modifica alla coda, cioè al lavoro di altri agenti in parallelo. Ma vale la pena dirlo — se l'attività viene riabilitata per sbaglio, la coda è ancora carica di 82 corse a tick reali |
| spegnere il terminale banco `50504400` finché la challenge opera | ❌ **non fatto**: è un gesto a mano dentro Windows, non è questa riga |
| verificare che stanotte non parta davvero niente | ⏳ si legge domattina con il **passo 1** (stessa riga, rilanciata): `stato = Disabled`, `PROSSIMA` vuota |
| lo stato reale delle attività sul VPS oggi | ❓ **non misurato da qui**: nessun accesso al VPS. Il passo 1 esiste apposta |

---

## 7. 📌 LA CLASSE NUOVA

**CLASSE 535** in `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md`:
*«la regola firmata che nessuno ha spento: un'attività pianificata sopravvive alla firma»*.
La domanda che entra nel cancello è una sola, e vale per ogni regola che cambia un
comportamento: **«questa cosa, chi la rifà stanotte senza di me?»** Se la risposta non
è *«nessuno, e l'ho verificato»*, la regola non è applicata: è scritta.
