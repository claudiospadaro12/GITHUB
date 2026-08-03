# 🎙️ Live Emiliano 03/08 — regole operative estratte

_Fonte: trascrizione automatica della sessione del 03/08/2026 (`LIVE_EMILIANO_03826_20260803_083001153.txt`)._
_⚠️ La trascrizione è **rumorosa**: "ORV/org" = ORB, "SMP" = S&P 500, "vini" = minimi, "presection" = pre-session, "bandieri moniger" = bande di Bollinger. Dove il testo è ambiguo lo segnalo._

---

## 🔴 1. La regola d'ingresso dell'ORB NON è quella che abbiamo implementato

Testuale:

> *"la strategia dell'ORB prevede di entrare **quando non alla violazione** ma quando la candela mi apre sotto il livello, con volume"*
> *"quando la candela mi apre col culetto sotto questo livello short, quando la candela mi apre col culetto sopra questo livello long"*

**[VERIFICATO nel testo]** Non è un ordine STOP sulla rottura. È: si aspetta che una candela **apra già oltre** il livello, e solo allora si entra.

Il nostro `ABTG_ORB` entra con **pendenti STOP** a `InpEntryPoints=10` oltre l'estremo — cioè esattamente "alla violazione", la cosa che lui dice di *non* fare.

Abbiamo già il pezzo per provarlo: `InpUseCloseConfirm` (entra alla **chiusura** di una candela oltre il livello) più `InpMinBodyPct`. **È implementato, opt-in, e non è mai stato testato.** Non è identico — "apre oltre" è ancora più tardivo di "chiude oltre" — ma è la stessa famiglia e si misura con quello che c'è.

> 💡 Questo è coerente con tutta la nostra caccia al motore: il RETEST è stato bocciato, il FADE bocciato, il DELAYED mai testato. La versione di Emiliano è **una conferma ritardata**, la stessa idea del DELAYED: non inseguire la rottura.

## 🔴 2. Il volume è obbligatorio, non opzionale

> *"l'ORB lo utilizziamo con i volumi, **è fondamentale** utilizzarlo con i volumi"*

**[VERIFICATO]** Nel nostro `ABTG_ORB` il filtro volumi è `InpUseVolumeFilter = false` di default. Nella sua descrizione è parte della strategia, non un extra.

Si incastra con l'ablazione: sul Nasdaq il volume è **l'unico** filtro che porta informazione (PF 0,90 → 1,15). Sul Dow invece è rumore. L'ORB gira su NASUSD, quindi la sua insistenza sui volumi è **coerente col mercato su cui lo applica**.

## 🟡 3. Il range di 15 minuti non è quello del nostro EA

> *"utilizzerò la candela 15 minuti… facciamo un massimo, facciamo un minimo, e finché sta all'interno di questo range non si tocca nulla"*
> *"l'ORB si può applicare agli indici, meglio alle 15:30"*

**[INCERTO — contraddizione da risolvere]** Il nostro `ABTG_ORB` usa il range **14:25→14:30 server**, cioè i **5 minuti PRIMA** dell'apertura USA. Quel valore è verificato: coincide esattamente con l'`ORB_Indicator_V15` (screenshot F7 del 03/08).

Qui invece descrive una candela da **15 minuti**, e dal contesto è **dopo** l'apertura. Sono due cose diverse che portano lo stesso nome:

| | finestra | rispetto all'apertura |
|---|---|---|
| `ORB_Indicator_V15` + nostro EA | 5 min (14:25–14:30) | **prima** |
| descrizione a voce del 03/08 | 15 min | **dopo** |

Non ho elementi per dire quale sia "l'ufficiale". Va chiesto a lui: è la differenza fra due strategie diverse, non una sfumatura.

## 🟢 4. I livelli che conta — conferma di quello che già facciamo

> *"i punti più importanti in un grafico sono i **massimi e minimi del giorno precedente** e sono i **massimi e minimi della notte**"*

**[VERIFICATO]** È esattamente `InpRangeMode = PREV` / `PREVBAR` dei nostri EA delle aperture. Nessuna modifica da fare: la logica dei livelli è allineata.

Ed è anche la spiegazione del fallimento dei `DAX_Live5m` di quella stessa mattina: hanno comprato **29 punti sotto il massimo notturno**, cioè dentro il range — il contrario di questa regola. Gli EA "buoni" hanno comprato 3 punti sopra la rottura e hanno funzionato.

## 🟡 5. Correlazione con l'S&P — usata sul DAX, da noi testata solo sul Nasdaq

> *"quando c'è questa situazione vado a vedere l'S&P… se l'S&P non sale, il DAX non sta dando respiro all'operazione"*
> *"l'S&P è completamente scorrelato dal DAX, quindi non sto facendo riferimento all'S&P"*

**[VERIFICATO nel testo]** La usa come **conferma direzionale in tempo reale**: se l'S&P non accompagna, riduce l'ambizione.

Noi abbiamo `InpUseCorrelation` con `InpCorrSymbol=SPXUSD` e l'abbiamo misurata **solo sul Nasdaq** (ablazione gradino 6: da 0,81 a 0,80, irrilevante). **Sul DAX non è mai stata provata**, ed è lì che lui la usa. Da mettere in coda.

## 🟢 6. Regola di stop giornaliero

> *"se dovessi prendere il secondo stop, da profitto a perdita, mi fermo. **È una mia regola**"*

Due stop e si chiude la giornata. Nessuno dei nostri EA ha questo: hanno `InpOneTradePerDay`, che è più restrittivo su un simbolo ma non coordina nulla a livello di flotta. È una regola di **conto**, non di EA — imparentata col tetto di rischio di flotta che serve per il dry-run prop.

## 🟡 7. Bande di Bollinger

> *"i valori delle bande di Bollinger, 37.3 in apertura DAX, 22 sulle valute e 22 anche quando il DAX smette di essere volatile, tipo da mezzogiorno"*

**[INCERTO]** "37.3" nella trascrizione può essere periodo 37 / deviazione 3, oppure altro. Il "22" invece ricorre due volte e sembra un periodo. Serve conferma da lui prima di implementare qualsiasi cosa: qui tirare a indovinare significa costruire su un numero inventato.

---

## 📉 La sessione in sé: cosa dicono i numeri, senza giudizi

Conto da **3 000 €**, leva, martingala/antimartingala e coperture. Il testo dice, in sequenza:

- *"ero più di 1 200"* (in profitto)
- *"adesso sono sotto di 700 euro rispetto al capitale"*
- *"sono sotto quasi 800 euro, che peccato, anziché essere più"*
- *"investendo 3 000 sono indietro sotto capitale"*

Da **+1 200 a −800**. E la sua diagnosi è: *"delle volte sono ambizioso quando non lo devo essere"*.

**Questo è esattamente il fenomeno che la FASE A ha misurato**, e vale la pena metterlo a verbale perché è la stessa cosa vista da due lati:

> Sul DAX, **il 48% dei trade perdenti era stato prima a +0,5R**, e il 23% a +1R intero.

Lui lo ha vissuto in diretta e l'ha attribuito a un difetto di carattere. I nostri 3 500 trade dicono che è **strutturale**: quasi metà delle perdite ti mostra prima un profitto. Non è ambizione — è come si comporta il mercato all'apertura. Il che è anche il motivo per cui il *breakeven* è la cosa più promettente da misurare nella FASE B.

⚠️ Nota per noi: quella mattina lui operava con **martingala e coperture su un conto da 3 000 €**. È una modalità che nessuno dei nostri EA implementa e che **non intendo trasformare in codice**: moltiplica il rischio proprio quando si sta sbagliando, ed è incompatibile con qualsiasi regola prop (−5% giornaliero). Lo annoto perché è la differenza principale fra quello che si vede nella live e quello che stiamo costruendo.

---

## ✅ Cosa ne facciamo — in ordine di valore

| # | Azione | Perché |
|---|---|---|
| 1 | **Testare `InpUseCloseConfirm` sull'ORB** | è già implementato, mai provato, ed è la regola d'ingresso che lui descrive (non inseguire la rottura) |
| 2 | **Accendere il filtro volumi di default sull'ORB** | lui lo chiama fondamentale; l'ablazione conferma che sul Nasdaq è l'unico che porta informazione |
| 3 | **Chiedere a lui: range ORB 5 min pre-apertura o 15 min post?** | sono due strategie diverse con lo stesso nome, e non è una domanda a cui i dati possono rispondere |
| 4 | **Provare la correlazione SPXUSD sul DAX** | lui la usa lì, noi l'abbiamo misurata solo sul Nasdaq |
| 5 | Chiedere i valori delle bande di Bollinger | "37.3" non è interpretabile |

Il punto 1 e il 2 sono già coperti da `test_orb_toolkit.ps1` (6 passi A–F), scritto e mai lanciato.
