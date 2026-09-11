# ☀️ BUONGIORNO CLAUDIO — la notte del 12/09/2026

> Hai detto *"domani mattina voglio vedere grandi cose o mi incazzo"*.
> 😄 Non ti incazzare: leggi la riga qui sotto.

# 🛡️ STANOTTE NESSUNO SCRIPT DI QUESTA CASA PUO' PIU' SPEGNERE IL CONTO REALE

Erano **14 punti** del repo. Adesso sono **zero** — e stavolta lo **zero e' una
misura**, non una mia dichiarazione: lo rifa' una macchina
(`backtest_pipeline/audit_kill_terminali.py`: **239 file, 17 chiusure, 0
nude, 0 ambigue**). E non e' una cosa che cercavo: e' saltata fuori scavando
per un'altra.

> ✏️ **E qui devo correggere me stesso, perche' e' la lezione piu' importante
> della notte.** A meta' lavoro avevo dichiarato *"erano 11, adesso zero"*.
> 🔴 **Era falso.** Ne restavano **tre**, e **due erano vivi** — li ha trovati
> il cancello **dopo** la mia dichiarazione.
> **Perche' li avevo persi**: cercavo la **forma** (`Get-Process` e
> `Stop-Process` sulla stessa riga) invece della **semantica** — li' stavano su
> righe diverse, legati da una variabile.
> 🚨 **E il colpo peggiore**: la regola giusta l'avevo scritta **io**, poche ore
> prima, **dentro quello stesso file** — *"un ramo morto con l'arma carica
> resta un'arma"* — e **non l'avevo applicata 213 righe sopra, sul kill
> identico**. Una regola scritta e non applicata a se stessi **non e' una
> regola: e' una frase.**
> ✅ Adesso i tre sono chiusi, e soprattutto **il numero non lo scrivo piu' io**:
> lo conta uno strumento che si auto-prova **sui casi che mi avevano
> ingannato** (autotest 9 su 9).

---

## 1. 🚨 LA COSA GROSSA — l'arma che avevamo in casa da mesi

**Undici** script facevano questo, **senza nessuna condizione**:

> ⛔ **QUESTO NON SI INCOLLA DA NESSUNA PARTE** — e' l'esempio del difetto,
> non una riga da lanciare. Per questo non e' marcato come PowerShell:
> il cancello, giustamente, mi ha bocciato il referto la prima volta.

    Get-Process terminal64 | Stop-Process -Force

Tradotto: **non sbagliano terminale — li ammazzano TUTTI.** Compreso
`C:\BCM_Reale`, **conto 10105439**, mentre ha posizioni aperte.

🔴 **E non e' un'ipotesi da lavagna: e' gia' successo.** Sta scritto nel
nostro stesso runner (`runner_abtg.ps1:139`): *"il 10/09 ChiudiMT5Pulito
ammazzo' anche il REALE"*.

**Adesso ogni chiusura e' CHIRURGICA**: muore solo il terminale che *quello
script* ha avviato, confrontando il percorso del processo con quello che lo
script stesso ha lanciato.

### 🧪 E la variabile non l'ho scelta a occhio
Per tutti e 8 i file ho verificato **a macchina** che la variabile (a)
esista, (b) sia assegnata **prima** della riga del kill, (c) sia **la
stessa** usata per avviare il terminale.
👉 **Il controllo ha bocciato la mia prima scelta** su `RIGA_DIAG_GBPUSD`
(li' `$Terminal` non esiste proprio). Senza quel controllo avrei consegnato
un filtro che non prende niente e lascia il tester appeso. **Il
contro-esempio ha pagato, ancora una volta.**

---

## 2. 🎯 IL PACCHETTO VPS E' RIFATTO — e ieri sera NON si sarebbe lanciato

`report/PACCHETTO_VPS_v3_2026-09-12.md`. Due difetti, **tutti e due
bloccanti**, trovati **prima** che la riga partisse:

### 🔴 (a) R133 non era lanciabile. Proprio per niente.
La riga sottile passa il pin al driver, e **il driver prende il FILE PROVA
da quel pin**. Al pin di ieri i tre file R133 **non esistono** — li abbiamo
scritti dopo. Non un numero sbagliato: **lo scarico sarebbe morto e basta**.

### 🔴 (b) I tre file R132 dicevano `-Modello 1` scrivendoci accanto "TICK REALI"
**E' il contrario.** `4` = tick reali, `1` = OHLC, solo screening. Lanciato
cosi', R132c girava OHLC e il suo cancello di riproduzione **falliva per
costruzione**, portandosi dietro R132a e R132b. Tre round buttati.

> 🧪 **Il contro-esempio, perche' la prova stia in piedi.** Con modello
> diverso da 4 il driver aggiunge `_ohlc` al nome del CSV, e i CSV di
> riferimento **non ce l'hanno**. Ma l'assenza di un'etichetta prova
> qualcosa **solo se quell'etichetta funziona davvero**: e funziona — ci
> sono **14 CSV `_ohlc`** in archivio (328 in tutto il repo). Senza quel secondo controllo,
> *"non c'e' `_ohlc`"* poteva voler dire solo *"quel pezzo di codice non ha
> mai funzionato"*.

### 🟡 (c) Un tag che non serviva a niente — ma la casa aveva gia' risolto
`@FINOA` (la data di FINE della finestra) finiva nel driver **e poi non
veniva mai usato**. Sta in **111 file prova**, 44 con una data diversa.

🟢 **Danno: ZERO, e non per fortuna.** Ho cercato il contro-esempio e l'ho
trovato: **il 31/08 la casa aveva gia' chiuso la porta in 32 script
dedicati**, che passano la data e la confrontano col file. Io ho chiuso
**l'ultima** rimasta: la riga sottile, nata l'11/09, l'unica che non passa
di li'. **Questa e' una bella notizia sul nostro metodo**, non una brutta.

---

## 3. 🪑 UNA SEDIA VIVA GIRA UNA SCATOLA CHE NON ABBIAMO MAI MISURATO

**`MaxMinNotte` sull'oro, magic 770402.** Viva davvero: **9 operazioni** nei
trade veri, e un **DD promesso del 5,3%** scritto in `HANDOFF.md`.

| | |
|---|---|
| scatola che gira **in campo** | **23:00 -> 04:59** |
| scatola su cui e' misurato **tutto** l'archivio dell'oro | 22:00 -> 06:59 (112 passate) |
| passate sulla scatola vera | 🔴 **ZERO** |

### ✏️ E qui correggo un numero che avevo dato io poche ore fa
Avevo scritto *"DD promesso 5,3%"*. **E' il numero VECCHIO.** Quello vero,
misurato da R100 su 22 anni, e' **19,72%** — **3,7 volte** il promesso — e il
verdetto era gia' 🔴 **REVISIONE**. Il contratto firmato il **23/08** dimezza
il rischio a 0,5% e promette **10,0%**.

🔴 **Ma anche il 19,72% e' misurato sulla scatola 22:00->06:59.** Quindi:
**nessun numero di questa sedia descrive l'oggetto che sta in campo.**

### 🚨 E c'e' una terza cosa, che tocca la firma del 23/08
Le **9 operazioni sono tutte e nove a volume 0,01**, cioe' **il lotto
minimo**. E `LotByRisk()` finisce con `MathMax(minimo, ...)`: se il lotto
calcolato sta sotto il minimo, **viene schiacciato sul minimo**.
👉 Il contratto dimezza il rischio **assumendo che il DD si dimezzi con lui**
(lo dichiara: *"APPROSSIMATO lineare"*). Ma **se la taglia era gia' incollata
al pavimento, dimezzare non ha dimezzato niente.**
⚠️ Onesta': ho misurato **il sintomo** (9 su 9 alla stessa taglia minima con
stop diversi) e **la riga che schiaccia**. **Non** ho calcolato il lotto
teorico su quel saldo. Sintomo + meccanismo, non la misura diretta.

🧪 **Contro-esempio, perche' l'allarme resti della misura giusta**: la
gemella DAX **770411** e' **a posto** — archivio 23:00->04:59, **154
passate**, identica al preset. 🟢 **E' UNA sedia, non un difetto di
processo.** Un round da **8 passate** la chiude (te lo sto preparando).

---

## 4. 📏 E TI CORREGGO UN NUMERO CHE AVEVO DATO IO

La tua scatola **00:00–08:00 ora italiana**, tradotta in ora server, **non
e' 7: e' 6**. Il parametro non nomina il bordo, nomina **l'ultima candela
inclusa**. E c'e' anche un motivo meccanico: i pendenti si piazzano alle
**07:59 server**, quindi con 7:59 la candela di fine sarebbe **quella ancora
in formazione**.

> `InpBoxStartHour=23` · `InpBoxEndHour=6` · `EndMin=59` ✅

📌 Il bello: **la risposta stava gia' in un file nostro, nella stessa
cartella.** E' la regola del 10/09 — *"prima si cerca il file che ha gia' la
risposta"* — e stavolta l'abbiamo applicata.

---

## 5. 🔧 LE MANOPOLE MORTE: 1.129 passate che non hanno misurato niente

Censimento rifatto da zero (`report/MANOPOLE_INERTI_v2_2026-09-12.md`):
**2.083 CSV, 61.829 passate**. Su 13 file dove l'inerzia e' documentata:
**1.284 passate -> 155 esiti distinti**, cioe' **1.129 passate (88%) buttate
via** — manopole girate che l'EA **non leggeva nemmeno**, perche' un altro
interruttore le teneva spente.

**Tre caselle da riaprire, 36 passate in tutto (~3 minuti):**

| casella | perche' | sedia |
|---|---|---|
| `InpLevelTF` | **mai messo ad asse in 0 CSV su 2.083**, ed e' l'unica cosa che decide i livelli | 770250, viva sul piccolo |
| `InpUseCloseConfirm` x `InpUseVolumeFilter` | filtro **scritto e mai eseguito**: 52 gruppi su 52 morti | 770611 |
| `InpMinBoxPts` | 18/18 identici: la scala era **fuori range di 10 volte** | 770402 / 770411 |

E **quattro NON si riaprono**, col numero accanto: motori a **PF
0,707–0,922** su campioni da 87 a 445 operazioni. 🚫 Non si insiste su un
motore morto: quella e' la regola del 19/08.

---

## 5-bis. 🧰 E IL CANCELLO ADESSO **COMPILA**

Trovato stanotte, ed era un buco nel **controllore**, non nel controllato:
il cancello ha stampato *"nessun difetto meccanico"* su un file che **non
compilava affatto**. Tutti i suoi controlli erano **testuali** — ASCII,
formati, ore, terminali — e **nessuno** guardava se il file fosse PowerShell
valido. 📌 E' la stessa classe che abbiamo pagato l'11/09, quando contavo le
graffe a mano.

✅ Adesso chiama **il parser vero**, e un errore di sintassi **blocca**. E se
`pwsh` non c'e' sulla macchina, **lo dichiara invece di tacere** — un cancello
che salta un controllo in silenzio fa credere di averlo fatto.

🧪 **E il contro-esempio, la prima volta, NON ha sparato**: avevo tagliato una
riga a caso da un file sano per "romperlo", e il cancello l'ha dato buono —
**perche' aveva ragione**, il file era ancora valido. 👉 *Un contro-esempio
che non fallisce non ha verificato niente.* Rifatto con tre rotture costruite
apposta: **3 FAIL su 3**, e due sono **esattamente le classi che avevamo gia'
pagato** (la graffa dell'11/09 e la stringa non chiusa del 17/08).
**Collaudo: 19 script su 19 compilano.**

### 🧪 E il kill chirurgico non l'ho solo scritto: l'ho **eseguito**
`backtest_pipeline/prove_strumenti/prova_kill_chirurgico.ps1` — rilanciabile
con una riga, non tocca niente (i processi sono finti). **5 prove su 5**:

| prova | esito |
|---|---|
| il **vecchio** kill prendeva tutti e cinque, **reale compreso** | ✅ dimostrato |
| il **nuovo** prende **solo il banco**, in entrambe le forme | ✅ |
| se il bersaglio fosse il piccolo, il filtro **lo segue** (quindi non e' una lista nera cablata) e **non** prende il reale | ✅ |
| la trappola del prefisso: `C:\MT5_Backtest` **non** cattura `C:\MT5_Backtest_V3` | ✅ |

---

## 6. 🙋 QUELLO CHE DECIDI TU (io non ci metto mano)

1. 🔴 **IL REPO E' PUBBLICO.** Verificato l'altro ieri. Da allora non
   scrivo piu' saldi, equity o P/L del reale e del 109k in nessun file
   nuovo. **Ma le quattro strade restano da scegliere tu**
   (`report/IL_REPO_E_PUBBLICO_2026-09-12.md`).
2. 🖥️ **Il VPS gira ancora il runner v2**: finche' non installi la v3,
   **nessun round parte**. Il pacchetto e' pronto, il primo passo **non
   tocca niente** (e' solo un collaudo a secco).
3. 🪑 **La sedia oro 770402**: la misuro e basta, o la vuoi spenta intanto?
   **Io non la tocco**: le sedie vive e il rischio sono roba tua.

---

## 7. ⏳ COSA STA ANCORA GIRANDO MENTRE DORMI

🟢 **Sono rientrati tutti e due, e hanno lavorato.**

**Il cancello di giudizio sul pacchetto VPS ha detto FAIL**, con **due
difetti bloccanti** — e aveva ragione su tutti e due:
1. la riga di verifica della coda controllava **1** round invece di **4**:
   con tutto perfetto avrebbe stampato ROSSO e **la notte si perdeva per un
   numero copiato**;
2. 🔴 **una guardia che avevo aggiunto io stanotte armava una mina**: faceva
   morire `RIGA_DIAG_GBPUSD -Passo C`, che cambia la finestra **apposta** e
   lo dichiara nel suo stesso codice. E la mia frase *"danno zero"* era
   **falsa**: avevo censito un lato solo della contraddizione.
   ✅ Riparato **senza ammorbidire la guardia**, con un interruttore che
   obbliga a **dichiarare** l'intento da tutte e due le parti.

👉 **Il pacchetto e' stato rifatto (v3) e adesso i cancelli passano tutti.**
📌 E questo e' il punto: **il difetto piu' pericoloso di stanotte l'ho
prodotto io, e l'ha preso il cancello.** La regola del 09/09 — *"niente esce
senza un PASS"* — stanotte si e' ripagata da sola.

**E il secondo agente ha consegnato i due file prova per la sedia oro**
(`R134b` + `R134c`), con l'ancora d'archivio cifra per cifra e tre correzioni
ai miei numeri, tutte accolte.

---

## 8. 🧭 E LA BUSSOLA, detta onestamente

**Alla challenge mancano ~19 giorni.** Stanotte ho prodotto soprattutto
**ponteggio**: cancelli, riparazioni, censimenti. Niente di tutto questo e'
una sedia nuova, e va detto cosi'.

🟢 **Ma il ponteggio di stanotte vale**, e si misura: ha tolto **un'arma
puntata sul conto reale**, ha impedito **tre round buttati**, ne ha resi
**lanciabili altri tre** che ieri sarebbero morti sullo scarico, e ha aperto
**tre caselle mai misurate su due sedie vive** al prezzo di **tre minuti di
tester**.

💪 **Il primo passo, stamattina, non installa e non tocca niente.** Poi si
va a prendere quelle tre caselle.
