# 📋 RESOCONTO DELLA GIORNATA — martedì 23/09/2026, ore 21:00

**Giorno 3 della challenge FTMO `541452707`.** Mancano **8 giorni** al 1° ottobre.
Questo è il punto sul PROGETTO. Il netto del giorno lo dà la **pagella delle 23:00**
(`report/giornata_2026-09-23.md`, altra chat): qui non si rifà l'analisi trade per trade.

---

## 🤖 COSA HA FATTO LA MACCHINA DA SOLA

### 🟢 Il runner notturno sul VPS — 03:30:04, e stanotte è andata BENE
`REFERTO_RUNNER_20260923_033004.txt`, letto riga per riga:

| voce | numero |
|---|---|
| corsie eseguite | **12** |
| di cui in corsia **ROUND** | 🟢 **0** |
| corsie in **SOLA LETTURA** | **12 su 12** |
| cancelli G1+G2 | **passati su tutte** |
| uscita 0 | **12 su 12** |
| rifiutate · fallite | **0 · 0** |
| esito | **COMPLETO** |

✅ **Nessun tester acceso sul VPS stanotte.** La firma del 21/09 non è stata violata.

🔴 **MA il meccanismo è ancora ARMATO, e questo va detto.** Il referto dichiara da sé il
proprio perimetro: *"SOLA LETTURA + **corsia ROUND sul solo `C:\MT5_Backtest`**"*. Cioè: la
corsia che accenderebbe il **banco `50504400`** — quello che il 21/09 ha inchiodato la
macchina mentre le sei sedie operavano — **esiste ancora** ed è registrata come attività
pianificata sul VPS. Stanotte non è partita **perché la coda era vuota**, non perché
qualcuno l'ha chiusa. 👉 È una sicura tolta, non un'arma scarica.

### 🎙️ La caccia automatica
Pubblicato alle **04:21** `backtest_pipeline/caccia_strategie/ANALISI_LIVE_PAOLO_2026-09-03.md`
— **767 righe**, estrazione integrale (121/121 righe della trascrizione) della live del 03/09
più i parametri dell'indicatore ORB V17.
✅ È un **referto di sola lettura** e lo dichiara in testa: **zero modifiche alla flotta**.

---

## 💶 IL CONTO

### 🎉 LA NOTIZIA VERA: lo SlippageLogger sul REALE `10105439` HA I PRIMI DEAL
Per settimane quella riga rispondeva "nessun file". Stanotte no.

```
ABTG_SlippageLogger_10105439_deal.csv   16 righe   ultima scrittura 22/09 12:13
deal esaminati 10.782 | registrati NUOVI 15 | autotest: 0 casi falliti
```

**Tutto e solo `magic 770101` (DAX Apertura EU RETEST BUY) su `D30EUR`.** Nessun'altra sedia
del reale ha prodotto un deal. Segno: **positivo = AVVERSO** (abbiamo pagato peggio).

| gruppo | n | mediana | P95 | max | media | costo tot |
|---|---|---|---|---|---|---|
| **D30EUR INGRESSI** | 6 | **−0,100** | 0,700 | 0,700 | 0,033 | **0,03 €** |
| **D30EUR uscite in SL** | 6 | **0,000** | 1,700 | 1,700 | 0,367 | **0,81 €** |

*(punti indice)*

- 🟢 **Gli ingressi ci riempiono in MEDIANA MEGLIO del richiesto.** Costo totale su sei
  ingressi: **3 centesimi**.
- 🟢 **La mediana dello stop è 0,000**: nel caso tipico lo stop è onorato al prezzo.
- 🟠 **La coda però c'è**: la peggiore è **1,700 punti indice** (11/09 10:45, chiesto
  25502,90 → eseguito 25501,20, **0,68 €**). È **P95 e max insieme**, cioè un evento solo.
- 🟢 **Coerenza delle tre fonti del prezzo richiesto: C e B d'accordo 6 su 6 (100%)** — il
  commento del server e il prezzo dell'ordine raccontano la stessa cosa.

🔴 **E ORA IL LIMITE, che vale quanto i numeri: n = 6 per lato.** Un simbolo, una sedia, un
broker, sei ingressi. **Questo è un PRIMO NUMERO, non una misura.** Non si tocca nessun
parametro su questa base, e non entra in nessun cancello finché non cresce.

### 🏆 Challenge FTMO `541452707`
🔴 **NON MISURATO da qui oggi**, ed è una limitazione dello strumento, non una notizia: la
foto del runner è delle **03:30**, quindi **la sessione di oggi non ci sta dentro**. Il dato
del giorno arriva dalla **pagella delle 23:00**.

Quello che la foto dice: **8 grafici** sul profilo `Default` di `C:\FTMO` — le **sei sedie**
`CLAU12_*` (DAX/Dow/Nasdaq Apertura, EMA200, SuperWave DOW H1, MaxMinNotte DAX Short), più
**`CLAU12_Guardian` (magic 779001)** e `ABTG_TradeExporter`. 🟢 Il Guardian **c'è ed è
attaccato**.

---

## 🔬 COSA HO DECISO IO (carta bianca, e ogni decisione col suo numero)

Giornata **tutta sul ponteggio** dopo le 18:00, e va dichiarata così.

1. **Classe 684 chiusa** (`81f52b59`) — due correzioni su `R237a/b` applicate a metà: il testo
   nuovo incollato sopra il vecchio, e la frase **sopravvissuta era quella imperativa**. Righe
   attive verificate **identiche**: erano modifiche di solo commento.
2. **Classe 685** (`99825986`, corretta in `c1b16cf2`) — il driver memorizza qualunque
   `@NOME valore` ma ne **rilegge cinque**: un typo tipo `@FRAZIONE 0.50` gira sul **default
   di fabbrica 0,40 in silenzio**. Contro-esempio eseguito: **4 file rotti, 4 verdi** dal
   cancello che avevamo.
3. 🔴 **E il cancello mi ha bocciato, con ragione.** Il mio check spingeva ad aggiungere
   `@DAQUANDO` a 8 file `POSTNEWS_*` — che un **altro** cancello (`GateProva`, r.511) **vieta**
   di averlo, perché lì la data dev'essere **misurata, non scritta a mano**. Avrei introdotto
   esattamente il guasto che la classe previene. Riparato con un marcatore **dentro un
   commento**: righe vive **34→34** e **35→35**, inerte per tutti e due i lettori.
4. **Classe 686** (`73000098`) — il blocco nuovo stava dietro alla risoluzione dell'EA, quindi
   **446 file su 874 non lo vedevano**, e i **5** file col caso di punta erano **tutti** fra
   quei 446: copertura viva **0 su 5**. Ora **874 su 874**.
5. 🪃 **Una correzione a me stesso.** Il difetto che mi ero appuntato — *"`controlla_prova.py`
   non legge `@FRAZIONEIS` e conta sempre `celle × 2`"* — **non esisteva**: `$WF` è un array
   letterale di due elementi (r.935). **Un difetto appuntato a memoria e mai verificato è un
   difetto inventato.**
6. 🛠️ **E un errore di metodo pagato oggi**: ho dichiarato buona una riparazione verificata con
   `ast.parse`, che **parsa e non compila** — era rotta. Da qui in avanti: `py_compile`.

**Non-regressione su tutto**: celle **1581 = 1581**, passate **3162 = 3162**, i **15 file dei
round rc 0**.

---

## ⚠️ COSA ASPETTA CLAUDIO

Due cose. **Tutte e due sono di RISCHIO, quindi sono tue e io non le tocco.**

### 1. 🛡️ Il Guardian su FTMO ha un cap DIVERSO da quello firmato — confermi?
Letto dal `.chr` di `C:\FTMO`, `chart06`, `CLAU12_Guardian` magic `779001`:

```
InpMaxOpenRiskPct = 4.00        <-- FTMO
InpMaxOpenRiskPct = 3.25        <-- i due ABTG_Guardian sugli altri terminali
```

Il **3,25%** è quello che hai firmato il 18/08 (C1 = 5 stop vivi da 0,65%). Su FTMO le sei
sedie girano a **rischio 2,0 ciascuna**, quindi **4,00 = esattamente DUE stop vivi**.
🟢 Come disegno **torna** — è il C1 riscalato alla taglia della challenge, non un numero a
caso. Ma **il numero firmato era un altro**, e io non cambio cap di rischio: te lo metto
davanti. **Se il 4,00 è voluto, basta un sì e lo metto agli atti.**

### 2. 🌙 Il runner notturno sul VPS: lo sospendiamo?
La corsia ROUND è ancora registrata sul VPS con bersaglio il banco `50504400`. Stanotte non è
partita solo perché **la coda era vuota**. Sospenderla è **un'azione sul VPS**, quindi serve
una riga, e la riga **passa dal cancello prima di arrivarti**.
👉 Dimmi solo **sì**, e la preparo. Le corsie di sola lettura (giornali, spread, pagella)
restano: quelle non consumano CPU.

---

## 🎯 DOMANI

1. 🥇 **Lo zip `ROUND_PRONTI_2026-09-23.zip`** dei 13 round. Si apre **nell'ordine già
   congelato** in `report/COME_SI_LEGGONO_I_13_ROUND_2026-09-23.md` — scritto **prima** che i
   numeri arrivassero, così non me li scelgo dopo averli visti.
2. 🚦 **I due cancelli incrociati per primi** (T1 su R234a, l'ancora di R235), prima di
   guardare qualunque cella: se il banco non riproduce, **nessun numero di quel round vale**.
3. 🔴 **R236a/b nascono SOSPESI** e il referto deve **aprire** con *"CANCELLO DEL COSTO: NON
   PRONUNCIATO"*. Da quella corsa si scrive **solo la sopravvivenza**.
4. 🛡️ La riga per le **sedie mute su FTMO** è pronta e non l'hai ancora lanciata: serve il
   nome della cartella dati di `C:\FTMO` (File → Apri cartella dati).
5. 📧 FTMO: mail partita oggi. **Nessun sollecito prima del 30/09.**

---

🔴 **LA RIGA ONESTA DI OGGI:** questa giornata ha prodotto **ponteggio**, non una sedia. Buon
ponteggio — due guasti muti chiusi, uno dei quali avrebbe fatto misurare finestre sbagliate
senza dirlo — ma **il 1° ottobre lo spostano gli EA**, e oggi non ne abbiamo aggiunto nessuno.
Il lavoro che conta sta macinando adesso sul PC di backtest.

🟢 **E la riga bella, che è vera quanto l'altra:** dopo settimane di "nessun file", **il reale
ha cominciato a parlare**. Sei ingressi, mediana migliore del richiesto, stop onorato al
prezzo nel caso tipico. È poco, ed è un inizio.
