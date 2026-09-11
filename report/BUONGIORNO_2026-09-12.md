# ☀️ BUONGIORNO CLAUDIO — la notte del 12/09/2026

> Hai detto *"domani mattina voglio vedere grandi cose o mi incazzo"*.
> 😄 Non ti incazzare: leggi la riga qui sotto.

# 🛡️ STANOTTE NESSUNO SCRIPT DI QUESTA CASA PUO' PIU' SPEGNERE IL CONTO REALE

Erano **11 punti** del repo. Adesso sono **zero**. E non e' una cosa che
cercavo: e' saltata fuori scavando per un'altra.

---

## 1. 🚨 LA COSA GROSSA — l'arma che avevamo in casa da mesi

**Undici** script facevano questo, **senza nessuna condizione**:

```powershell
Get-Process terminal64 | Stop-Process -Force
```

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

`report/PACCHETTO_VPS_v2_2026-09-12.md`. Due difetti, **tutti e due
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
> sono **10 CSV `_ohlc`** in archivio. Senza quel secondo controllo,
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
| scatole **backtestate** sull'oro | 22:00 -> 06:59 (112 passate) · 22:00 -> 04:59 (4) |
| passate sulla scatola vera | 🔴 **ZERO** |

👉 **Quel 5,3% e' promesso da una cella che non e' quella schierata.**

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

- il **cancello di giudizio** sul pacchetto VPS (🔴 finche' non torna PASS,
  quel pacchetto **non si lancia** — e' la regola del 09/09, e il 09/09 e'
  andata bene **per fortuna, non per metodo**);
- il file prova per la **scatola vera della sedia oro**.

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
