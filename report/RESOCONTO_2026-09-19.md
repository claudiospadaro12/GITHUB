# 📋 RESOCONTO DELLA GIORNATA — sabato 19/09/2026, ore 21:00

> Questo è il punto sul **PROGETTO**. La pagella degli EA (netto trade per trade)
> è un'altra cosa e la scrive la Routine delle 23:00 in `report/giornata_2026-09-19.md`.

> ## 🧭 BUSSOLA — mancano **11 giorni** al 1° ottobre
> Oggi è stata in larga parte una giornata di **PONTEGGIO** (cancelli, canali, strumenti),
> e va dichiarata come tale. 🟢 **Ma con UNA conquista sulla sedia**: la prima famiglia
> che supera il pavimento di frequenza.

---

## 🤖 COSA HA FATTO LA MACCHINA DA SOLA

**Runner del VPS, corsa delle 03:30** (`REFERTO_RUNNER_20260919_033003.txt`):
**127 righe di coda**, tutte in corsia **LETTURA**, cancelli **G1 e G2 passati**,
**uscita 0** su tutte. Nessun round di backtest: il perimetro è sola lettura e
nessuna firma nuova era in coda.

**Caccia automatica**: 🔕 **niente di nuovo oggi.** Il dossier più recente in
`backtest_pipeline/caccia_strategie/` è del **14/09** (`ANALISI_TRASCRIZIONI_2026-09-14.md`).
La Routine gira ogni 2 giorni alle 08:00: il prossimo giro è atteso, non mancato.

**Cosa hanno trovato i referti** (le tre cose che contano):
1. 🔴 `CODA_11`: `ABTG_AggiornaNews` con **ultimo esito `4294770688`** per la
   seconda mattina di fila. È da lì che è partita tutta la caccia al canale news.
2. 🟢 `CODA_10`: sul **conto reale 10105439** lo `SlippageLogger` **ha finalmente dei deal**
   (sotto, §IL CONTO).
3. 🟢 Le altre tre attività (`PubblicaTrades`, `ScaricaPagella`, `Runner`) a **esito 0**
   su otto giorni: il guasto era **uno solo**.

---

## 💶 IL CONTO

| conto | operazioni | netto cumulato | finestra | fonte |
|---|---:|---:|---|---|
| **100k 50504263** (dry-run) | 35 | **+3.890,91** | 10/08 → 17/09 | `data/statements/trades_100k.csv` |
| piccolo 50503392 | 1.322 | −19.626,63 | 30/03 → 18/09 | `data/statements/trades_auto.csv` |

🎯 **Dry-run 100k: +3,89% su un target di +10%.** Mancano **+6.109,09**, cioè siamo al
**38,9% del traguardo**.
⚠️ Il numero del piccolo è la **storia intera** e contiene i trade dell'istanza fantasma
del 14/08 e tutto lo sperimentale: **non è il numero della flotta di oggi** e non va letto
come tale.

### 🟢 SÌ: lo `SlippageLogger` sul REALE ha i deal — ed è la prima misura vera che abbiamo

`ABTG_SlippageLogger_10105439_deal.csv`, **14 righe**, dal **08/09** al **17/09**,
tutte `D30EUR` magic `770101`. Autotest del logger: **0 casi falliti**.

| gruppo | n | mediana | P95 | max | media | unità |
|---|---:|---:|---:|---:|---:|---|
| **D30EUR uscite in SL** | 5 | **0,000** | 1,700 | 1,700 | **0,420** | punti indice |
| **D30EUR ingressi** | 5 | **−0,100** | 0,700 | 0,700 | **0,060** | punti indice |

*(segno positivo = avverso, abbiamo pagato peggio del richiesto)*

🟢 **La mediana dello scarto in ingresso è NEGATIVA**: metà degli ingressi è stata
riempita **meglio** del richiesto. Sulle uscite in stop la mediana è **zero**, con una
sola scivolata da 1,70 punti.
⚠️ **n=5 per gruppo: è un campione sottile.** Sospende il giudizio sul MERITO, non sul
RISCHIO — e sul rischio, per ora, non dice niente di brutto.

---

## 🔬 COSA HO DECISO IO (in autonomia, col numero accanto)

**1. Il cancello `controlla_riga.py`: rilievo, non blocco (classe 457).**
Riprodotto il difetto: uno script di 4 righe che scrive nella cartella dati del REALE e
poi fa `Stop-Process` usciva *«nessun difetto meccanico»*, uscita 0. Ora produce due
rilievi in chiaro. 🔴 **Ma NON blocca**, e la ragione è misurata su 249 `.ps1`:
bloccare tutti i nomi vietati → **141 script sani bocciati**; includendo i commenti →
**248 su 249**; solo `BCM_Reale` con backslash → **6 falsi positivi**, tutti *etichette*
(il più bello: `runner_abtg.ps1` r.457 è **il caso di prova del runner stesso**).
👉 Conclusione scritta in checklist: **un cancello testuale non distingue un BERSAGLIO da
un'ETICHETTA.**

**2. Rigenerato il calendario news e messo uno schedule giornaliero** (classi 459-461).
Il canale era morto dal **26/07**, non dal 16/09: `data/abtg_news.csv` era **0 byte** e il
workflow che lo genera aveva girato **UNA volta in vita sua, il 23/07**. Cinque anelli
tacevano in fila. Ho lanciato il workflow, corretto il generatore e aggiunto
`schedule: "40 4 * * *"` (40 min prima che il VPS lo scarichi alle 07:20 IT).
📉 Lo step è passato da **70 a 3 secondi** per corsa.

**3. Corretto il righello nel `LEGGIMI.md` della toppa** (classe 456).
Diceva di cercare `2090/2190/2122`: sono i numeri di `wc -l`, mentre `CODA_06` conta
**uno in più**. Con i numeri vecchi, domattina avremmo concluso che **la toppa non è
entrata** mentre è entrata. I numeri giusti sono **2091/2191/2123**.

**4. Riparato `CODA_02`** (classe 466).
Ordinava i log dal più recente e poi li rileggeva in quell'ordine sovrascrivendo:
la colonna *«ultima riga»* era **indietro di due giorni**. Morde sulla corsia
**TAGLIANDO** firmata il 18/08: una sedia che si ferma la scoprivamo con due giorni di
ritardo. Contro-esempio girato: prima usciva `17/09`, ora esce `19/09`.

**5. Lanciate quattro ondate di agenti**, tutte in sola lettura, tutte rientrate.

### 🙋 E GLI ERRORI MIEI DI OGGI, per nome
- 🔴 **La causa dei feed news l'avevo detta sbagliata.** Avevo scritto *«il fornitore
  rifiuta le richieste ravvicinate»*: dedotta da **un solo indizio**, mai misurata. Il log
  vero dice **404**: due indirizzi morti. Corretta la sera stessa, lasciando visibile la
  versione sbagliata con il perché.
- 🔴 **Il mio primo allarme sarebbe andato rosso ogni weekend.** Usciva 1 su «zero eventi
  futuri»: col solo feed `thisweek` vivo, dal venerdì sera è normale. È lo **stesso errore
  della 457** — allarme troppo largo — **due volte nello stesso giorno**.
- 🔴 **Ho messo un'emoji in un commento Python** di un file dichiarato `coding: ascii`:
  `SyntaxError`, e lo script di patch ha **troncato il file a 0 byte** prima di
  accorgersene. Recuperato da HEAD. Regola nuova: `s.encode("ascii")` **prima** di aprire
  in scrittura.
- 🔴 **Ho dato a Claudio la frequenza del DAX come 0,864: è 0,705.** Lo `0,864` era
  gonfiato dal difetto della guardia «un trade al giorno» (39 posizioni su 32 giornate,
  il 30/07 ne apre **cinque**).
- 🔴 **La mia ipotesi numero uno su `770202` è stata falsificata.** Avevo puntato
  sull'interferenza fra sedie: la sedia **non ha mai mandato l'ordine**, non c'è niente da
  chiudere. Il blocco del Nasdaq **non** spiega il silenzio del Dow.

---

## 🟢 LA CONQUISTA DI GIORNATA — la prima famiglia sopra il pavimento

| famiglia **Aperture** | posizioni | giornate | op/giorno |
|---|---:|---:|---:|
| `770101` DAX · D30EUR | **193** | 276 | 0,699 |
| `770202` Dow · U30USD | **96** | 276 | 0,348 |
| **TOTALE** | **289** | 276 | 🟢 **1,047** |

Si sommano perché sono **lo stesso motore** (`ABTG_ApertureCore.mqh`, r.53 del sorgente
del Dow). ✅ Verificato da me sul per-trade: 270 deal → **193 `position_id`** →
**193 giornate**. Posizioni, non gambe.

🔴 **In campo però fanno 0,834**, perché `770202` tace dal **28/08**. Misurato: **non è
rotta** — è una sedia **solo long** su un Dow che scende, e il suo livello di rottura non
è stato toccato. Prova a prezzo esatto: l'11/09 il vicino ORB ha piazzato un BUY STOP a
**52733,50**, che è **esattamente** `52723,50 + 10,00` del range di `770202`, e **non si è
mai eseguito**. La siccità massima misurata del motore è **23 sedute**; in campo siamo a
**15**.
🗓️ **Data in agenda: il 30/09** il silenzio tocca le 23 sedute. È il giorno prima della
challenge.

### 🪦 E le due strade di allargamento sono CHIUSE, coi certificati
- **SuperWave a TF bassi**: OOS PF **0,868** (M30, n=320) · **0,753** (M20) · **0,826**
  (M15) contro **1,328** a H1. A M30 ci sono 320 operazioni: **il merito è LETTO**, non
  sospeso. *(verificato da me sul CSV, Pass 2 e Pass 1.)*
- **Lato short dell'apertura**: IS **1,372** → OOS **1,096**, con il DD che **raddoppia**
  (4,39% → 8,68%). IS migliora mentre OOS peggiora: fallisce S4.
- **MaxMinNotte sui gemelli europei**: **0 celle su 216** con PF ≥ 1,10, DD fino al 48,3%.

🕳️ **L'unica casella vergine**: su **2.376 CSV**, `InpSessionHour` è stato messo ad asse
in **ZERO** round. Due file prova pronti, **16 passate, ~12 minuti**. Non lanciati.

---

## 🔍 E IL CAMPO GIRA CODICE VECCHIO — misurato sedia per sedia

**Su 8 coppie sedia × terminale della rosa, DUE girano HEAD. Sul piccolo 50503392: 0 su 5.**

| sedia | conto | revisione | Guardian |
|---|---|---|:--:|
| `770411` MaxMin DAX S | **50504263** | **HEAD** | 🟢 SÌ |
| `770101` DAX Apertura | **10105439** | **HEAD** | 🟢 SÌ |
| `770511` SuperWave | 50503392 | `344a11b9` 04/08 | no |
| `770402` MaxMin ORO | 50503392 | `08239510` **28/07** | no |
| `770101` DAX Apertura | 50503392 | `3af47ed9` 08/08 | no |
| `771531` EMA200 | 50503392 | `344a11b9` 04/08 | no |

🟢 **Il terminale più allineato del parco è il conto REALE.** Non gli serve niente.

⚠️ **L'F7 di stasera NON porta `770101` a HEAD**: il file patchato ha **0 occorrenze** di
`InpUsaGuardian` e `ABTG_DEF_RISK 2.0` (r.78) contro `1.0` a HEAD. **Verificato da me.**
🟢 **Ma il rischio VIVO resta 0,65%**, perché lo porta il preset (letto dai `.chr`: tre
grafici a `rischio 0.65`). Il pericolo è **latente**: premere «Ripristina» nella finestra
input riporterebbe il default al 2%.

---

## ⚠️ COSA ASPETTA CLAUDIO

**Sul conto reale 10105439: NIENTE.** Non serve che tu faccia nulla, ed è il terminale
messo meglio.

**Cose che toccano rischio / soldi e sono solo sue:**
1. ✍️ **Le taglie** per la challenge.
2. ✍️ **La scelta della prop** (FTMO 1:15 contro FundedNext 1:25).
3. ✍️ **Firma per compilare** i bersagli di `770511` (`872dba82`) e `771531` (`26a18566`):
   **nessuna firma oggi le copre**, e non sono mai state compilate da nessuna parte.
4. ✍️ **Firma per una corsa di controllo su `770402`**: a HEAD `InpOneTradePerDay` diventa
   effettivo e **cambia la frequenza** rispetto a R100. Va rimisurata prima, non dopo.
5. 🤔 **Una decisione, non una riparazione**: *vogliamo una sedia solo-long sul Dow a
   ottobre?* Il numero per rispondere c'è (OOS PF 1,270, DD 4,39%, 0,348 op/giorno).

**Gesto manuale, già firmato** (non tocca rischio né reale): **F7** sui tre Apertura —
🪟 MT5 **50503392**, `C:\Program Files\BCM Markets MT5 Terminal`. 🚫 NON `-V3`
(50504263) · NON `C:\BCM_Reale` (**10105439**) · NON `C:\MT5_Backtest` (50504400).

---

## 🎯 DOMANI

1. 🔎 **Verifica della toppa**: il `CODA_06` delle 03:30 deve stampare
   **2091 / 2191 / 2123** al posto di 2033 / 2133 / 2065.
2. 🔎 **Verifica del canale news**: l'attività delle 07:20 deve uscire **0**, e il
   calendario deve portare la data di domani. Prima corsa con lo schedule automatico.
3. 🟠 **Cercare una sorgente per la SETTIMANA ENTRANTE**: senza `nextweek`, il venerdì
   sera il calendario non contiene il lunedì. Tocca `ABTG_Nasdaq_Apertura_US.set`,
   l'unico preset con `InpUseNewsFilter` acceso.
4. 🎯 **`InpSessionHour`**: è l'unica manopola mai messa ad asse in 2.376 CSV, ed è
   l'unica via rimasta per alzare la portata della famiglia Aperture. File pronti, in
   attesa di firma.
5. 🔴 **Prerequisito di tutto**: la **chiusura per ticket**. Finché non è in campo, due
   sedie sullo stesso simbolo si ostacolano — ed è il motivo per cui le due sedie Nasdaq
   sono ferme.
