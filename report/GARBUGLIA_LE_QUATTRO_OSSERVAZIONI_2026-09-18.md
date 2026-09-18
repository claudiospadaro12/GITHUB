# 📬 LE OSSERVAZIONI DI GARBUGLIA — **arrivate il 13/09, entrate in casa il 18/09**

**18/09/2026** · fonte: `docs/garbuglia/RISPOSTA_DOSSIER_ABTG_2026-09-13_Garbuglia.pdf`
(3 pagine, testo estratto in `..._testo.txt`) · risponde a
`report/DOSSIER_METODO_ABTG_2026-09-11.pdf`, che è in repo.

---

## 🥇 LA RIGA DI TESTA

> ### 🔴 **Il suo punto 1 dice che il nostro cancello di costo è espresso in SPREAD mentre il costo vero è il TRIPLO. Verificato da me nel nostro stesso referto di flotta: è peggio di come lo pone lui — usiamo DUE DENOMINATORI DIVERSI contro LA STESSA SOGLIA, nello stesso documento.**
> ### 🔴 **E tocca una conclusione che ho scritto STAMATTINA: l'«ESCLUSO PER COSTO» di EURUSD H4 vale in costo pieno (22,2×) e NON vale in spread (73,5×).**
> ### ✅ **Nessuno dei quattro punti smonta l'impianto. Tre sono unità di misura da dichiarare, uno è una misura da aggiungere. Sono tutti e quattro CHIUDIBILI, e tre costano zero tempo macchina.**

🔴 **Il documento NON era mai entrato nel progetto**: cercato repo-wide il 18/09,
zero file col suo nome e **zero referti che lo citano**. È rimasto fuori **cinque giorni**.

---

## 1. 💰 IL CANCELLO DI COSTO È IN DUE UNITÀ DIVERSE — e il difetto è NOSTRO, verificato

### Cosa dice lui
Il cancello è `stop >= 40 × spread`, ma il costo vero sul nostro conto è
`spread + commissione`. Sul suo conto il rapporto è **2,87×**. Quindi una sedia che
passa a 40× **in spread** può avere un costo pieno pari al **7,2% dello stop**, e al
pavimento duro arriva al **21,5%**.

### Cosa ho trovato io, aprendo il nostro referto

| dove | cosa dice |
|---|---|
| `CANCELLO_COSTO_FLOTTA_2026-09-10.md` **r.170** | `DI LAVORO: stop >= 40 × **spread**` |
| **r.171** | `DURO: stop >= 13,3 × **spread**` |
| **r.394**, **r.485** (intestazioni) | colonna `**spread**` → `stop/spr` → `40x?` |
| 🔴 **r.460** (intestazione) | colonna `**spread+comm**` → `stop/spr` → `40x?` |

> ## 🔴 **Nello STESSO referto, due tabelle mettono denominatori DIVERSI sotto la STESSA soglia da 40×. Le sedie giudicate nelle due tabelle NON sono confrontabili fra loro, e nessuna etichetta lo dice.**

### E il rapporto vero, misurato su EURUSD
`spread mediana 0,200` + `commissione 0,4636` = **0,6636** ⇒ il costo pieno vale
**3,32× lo spread** (lui sul suo conto misura 2,87× — stesso ordine).
➡️ **40× in spread = 12,1× in costo pieno**, cioè **sotto il nostro stesso pavimento
DURO** se quest'ultimo si legge in costo pieno.

### 🔥 COSA CAMBIA OGGI, e va detto subito

Stamattina ho concluso che EURUSD H4 era **«ESCLUSO PER COSTO»** usando l'ancora
indipendente `772162` (ATR H4 = 14,7 pip). Rifatto nelle due unità:

| denominatore | conto | contro 40× |
|---|---:|---|
| **spread solo** (la lettera della regola, `CLAUDE.md` e r.170) | 14,7 / 0,200 = **73,5×** | ✅ **PASSA, e largamente** |
| **costo pieno** (quello che ho usato io, e che usa il registro) | 14,7 / 0,6636 = **22,2×** | 🔴 non passa |

> ### 🔴 **Quindi «EURUSD H4 escluso per costo» NON È STABILITO: dipende da quale unità vale. E la stessa ambiguità colpisce l'esclusione di EURUSD H1 (20,8× in costo pieno = 45,0× in spread), scritta in `REGISTRO_TEST.md` r.2394 e mai messa in discussione.**

⚠️ **Non risolvo io quale sia l'unità giusta: è un CRITERIO, e i criteri sono di
Claudio.** Le due letture non sono equivalenti e la scelta cambia il verdetto su
più di una sedia.

### 🤔 La sua domanda diretta, che giriamo a Claudio
> *«Il 40× è su spread o su costo pieno? E la commissione, dove entra nel giudizio di
> una sedia?»*

💡 E la sua osservazione più bella, che è la nostra regola applicata a noi: *«la
distanza fra il vostro 2,5% e il mio 20% è in gran parte un artefatto di unità di
misura — i due sistemi non sono a otto volte di distanza, sembravano lontani perché
misuravano due cose diverse»*.

🟢 **Una cosa la indovina e va riconosciuta**: sospetta che `13,3` sia
«verosimilmente 40/3, non una conversione». È esatto: 40/3 = 13,33.

---

## 2. 📏 IL CAMPIONE OOS RICHIESTO PIÙ GRANDE DELL'IS

Il dossier chiede `n OOS >= 95` e `n IS >= 57`: **è l'unico posto dove il FUORI
campione è richiesto più numeroso del DENTRO**, ed è il contrario di come si spezza
una corsa.
Il suo sospetto (dichiarato come supposizione): **etichette scambiate**, e lo deduce
dal nostro esempio §6.2, dove la stessa corsa spezzata dà **84 e 143**.
👉 **Domanda: com'è divisa la corsa, e in che ordine vanno letti quei due numeri?**
⚠️ Con `FrazioneIS 0,40` di fabbrica l'IS è il **40%**, quindi è il PIÙ PICCOLO: la
sua lettura è coerente col nostro driver e la tabella del dossier probabilmente no.
**[DA VERIFICARE sul dossier, non fatto in questo giro.]**

---

## 3. 🏔️ L'ALTOPIANO NON È EVIDENZA INDIPENDENTE — **è il punto più profondo dei quattro**

> *«Celle adiacenti condividono la maggioranza delle operazioni. Quindi un blocco
> contiguo di celle che passano i cancelli **emerge anche quando il vantaggio è
> zero**, per il solo fatto che il parametro agisce con continuità. La regola
> dell'altopiano protegge dal picco isolato — rumore puntuale — ma non dalla
> selezione multipla.»*
>
> *«L'altopiano risponde a **questa cella è stabile?**, non a **un altopiano così è
> raro?**. Sono due domande diverse e oggi ne misurate una sola.»*

🔴 **E ci colpisce dove abbiamo appena lavorato**: oggi un agente ha osservato, da
solo, che le 30 celle di R29a *«girano in gran parte sulle stesse operazioni, quindi
il campione efficace è vicino a UNO»*. 👉 **È la stessa identica osservazione, trovata
in casa e da fuori nello stesso giorno, su due documenti diversi.** Non è una
coincidenza: è un difetto strutturale del nostro modo di selezionare.

✅ **Il rimedio che propone costa quasi zero, perché il motore ce l'abbiamo già**: la
forza bruta su 200.000 griglie casuali usata per i pareggi irrisolti serve, **con lo
stesso codice**, a costruire la **distribuzione nulla dell'altopiano** — quanto è
lungo il blocco contiguo più lungo in una griglia **senza vantaggio**, a parità di
celle e di correlazione fra vicine. Se il blocco del candidato cade dentro il 90°
percentile del nulla, **l'altopiano non sta dicendo niente**.

---

## 4. 📉 IL DRAWDOWN HA UNA SOGLIA MA NON UNA DISTRIBUZIONE

> *«Un drawdown di backtest è **una realizzazione**, non la distribuzione. Le stesse
> identiche operazioni in ordine diverso producono un massimo drawdown diverso.»*
> *«Il margine 7 → 10 non è tre punti: è tre punti meno una coda che non è stata
> misurata.»* (il moltiplicatore che dichiara è 1,5-2×, e lo dichiara **incerto**)

🟢 **Ed è coerente con la nostra stessa frase migliore**, che lui cita: *«un drawdown
è un fatto accaduto, non una stima»* — vero, **ma il fatto accaduto è UNO, e la prova
prop la si supera contro tutti gli altri ordinamenti possibili di quello stesso fatto.**
✅ Offre i riordini del suo Monte Carlo: *«un pomeriggio di lavoro»*.

---

## 5. 🔍 LA SUA RETTIFICA SU DI SÉ, e vale la pena leggerla

Apre il documento **correggendo un proprio numero**: dichiarava `RR 3` e `win rate
35%` (⇒ aspettativa 0,40 × SL), ma i PF misurati che riporta (**2,17 · 2,24 · 2,80 ·
3,01**) implicano win rate **42,0-50,1%** e aspettative **0,68-1,00 × SL**. *«Le due
cose non stanno insieme.»* Elenca tre spiegazioni possibili e dice di non sapere
quale sia vera.

🔴 **E si segnala da solo l'ipotesi che ci tocca**: se la spiegazione è la **(b)**
— uscita non a RR fisso, parziale + pareggio + runner — allora il metodo di
estrazione dello slippage dalla cronologia, *«la cosa più utile del documento»*, vale
**solo sulle operazioni non gestite**. 👉 **E i nostri EA hanno TP1 parziale e
breakeven**: se applichiamo quel metodo al nostro storico, va prima verificato che il
nostro RR sia fisso davvero, *«e non fisso fino al primo parziale»*.

🟢 Come l'ha trovata: *«non guardando se il numero tornava, ma provando a romperlo
— cioè applicando il vostro §5.3 al mio stesso documento. È costato dieci minuti.»*

---

## 6. ✅ COSA SI PUÒ FARE, e quanto costa

| # | azione | costo | chi |
|---|---|---|---|
| 1 | 🔴 **Dichiarare l'unità del cancello di costo** (spread o costo pieno) ed etichettare le tabelle di `CANCELLO_COSTO_FLOTTA` | **zero macchina** | 🔴 **FIRMA DI CLAUDIO** (è un criterio) |
| 2 | Rileggere le esclusioni per costo già pronunciate nell'unità firmata — a partire da **EURUSD H1 e H4** | zero macchina | noi |
| 3 | Verificare l'ordine di `n IS` / `n OOS` nel dossier (punto 2) | zero macchina | noi |
| 4 | **Distribuzione nulla dell'altopiano** col codice delle 200.000 griglie già scritto | poco, ed è CPU non tester | noi |
| 5 | **Riordini Monte Carlo del DD** sulle sedie della rosa | un pomeriggio | noi, o i suoi dati |
| 6 | Verificare che il nostro RR sia fisso **davvero** prima di usare il suo metodo sullo slippage | zero macchina | noi |

---

## 7. 🕳️ BUCHI DICHIARATI DI QUESTO REFERTO

- **Non ho riaperto `DOSSIER_METODO_ABTG_2026-09-11.pdf`**: i suoi riferimenti ai
  nostri §3.1, §5.3, §6.2, §6.5 sono **[NON VERIFICATI]** in questo giro. Il punto 2
  resta quindi **una supposizione sua non controllata da noi**.
- **Il rapporto costo/spread 3,32× è di EURUSD**, non della flotta: cambia per simbolo
  (la commissione è sul nozionale, lo spread no).
- **Non ho letto le sue 17 misure di ingresso e 15 di uscita**: non sono in repo.
- ⚠️ **Il testo del PDF è stato estratto da me** con un decodificatore scritto al
  momento: le citazioni fra virgolette vengono da `..._testo.txt`, non da una lettura
  visiva delle tre pagine. Se un numero sembra strano, si riapre il PDF.

---

*Documento ricevuto da Claudio il 18/09/2026 e archiviato lo stesso giorno. Nessun
EA toccato, nessun round armato, nessun criterio modificato: il punto 1 è una
domanda a Claudio, non una decisione presa.*
