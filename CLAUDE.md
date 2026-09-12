# Note di progetto — DA RICORDARE SEMPRE

## 🎯 OBIETTIVO CON UNA DATA (Claudio, 08/09/2026)
**La challenge prop parte ai PRIMI DI OTTOBRE 2026.** Da fine settembre
Claudio vuole avere gli expert pronti. Dall'08/09 restano ~3 settimane.
- Ogni lavoro vale in proporzione a quanto avvicina una **sedia schierabile
  il 1° ottobre**. Il resto scala.
- Conseguenza gia' misurata: la **frequenza** diventa il requisito principale
  (una sedia da 1 op/giorno accesa oggi arriva a 150 operazioni a marzo, non
  a ottobre) e la banda buona sugli indici e' **M30/H1**, non M5/M15
  (frontiera del costo `stop >= 40 x spread`).
- Carta bianca a Claude sulle decisioni operative, MA restano di Claudio:
  **conto reale 10105439**, **parametri di rischio e taglie**, **spendere
  soldi**. E il perimetro del runner resta **sola lettura**: si allarga solo
  con una firma nuova. Verbale: `report/MANDATO_2026-09-08.md`.

## ⛑️ REGOLA #1 — SALVA SEMPRE SU GITHUB (richiesta esplicita di Claudio)
**Ad OGNI passo significativo → commit + push su GitHub, SUBITO.** Claudio non deve MAI rischiare di perdere lavoro se la chat si blocca/riempie (è già successo spesso).
- Branch di lavoro attuale: **`lavoro`** (qui è consolidato TUTTO).
- Dopo ogni: analisi salvata, modifica EA, nuovo file, decisione presa → aggiorna il file giusto (`PROMEMORIA_APERTURE.md`, `CLASSIFICHE.md`, `HANDOFF.md`, ecc.) e **pusha**.
- Ciò che non è pushato = perso. Nel dubbio, committa.
- Per ripartire in una chat nuova: leggere `HANDOFF.md` + `PROMEMORIA_APERTURE.md` + `CLASSIFICHE.md` sul branch sopra.

## 🖥️ REGOLA DEI TERMINALI MULTIPLI (richiesta esplicita di Claudio, 06/09)
**Sul VPS ci sono TRE terminali MT5 aperti contemporaneamente** (piccolo 50503392,
100k 50504263, reale 10105439): confondersi di finestra è facile e costa caro
(si rischia di attaccare/toccare l'EA sbagliato sul conto sbagliato). Da qui in
avanti, OGNI VOLTA che chiedo a Claudio di aprire/toccare un terminale specifico:
1. **dichiaro SEMPRE il numero di conto** (non "il piccolo", anche il numero:
   50503392 / 50504263 / 10105439) E la cartella programma che lo identifica
   (`BCM Markets MT5 Terminal` = piccolo, `... -V3` = 100k, `C:\BCM_Reale` = reale);
2. **non chiedo MAI a Claudio di riconoscere la finestra "a occhio"** dal solo
   titolo: se serve, fornisco la stringa di sola lettura che stampa PID + titolo
   + cartella (`Get-Process terminal64 | select Id, MainWindowTitle, Path`),
   così il riconoscimento è un fatto stampato, non un'inferenza sua;
3. vale per QUALSIASI istruzione manuale in MT5 (trascinare un EA, aprire un
   grafico, leggere Esperti), non solo per le righe di lancio PowerShell.
Nato da un incidente reale (06/09): senza il numero di conto in chiaro, un
attacco EA destinato al piccolo è stato quasi fatto sul terminale del REALE.

### 🖊️ AMPLIAMENTO DEL 12/09/2026 — «SCRIVIMI SEMPRE SU CHE TERMINALE MANDARE LA STRINGA»
Richiesta testuale di Claudio, ed e' **BLOCCANTE come il resto della regola**:
> _"SCRIVIMI SEMPRE SU CHE TERMINALE MANDARE LA STRINGA"_

Quindi **ogni** stringa che gli arriva porta in TESTA, prima del blocco di
codice, la riga del bersaglio. E la risposta e' una di queste quattro, scritta
per esteso — mai "il piccolo", mai "quello di prima":
- 🖥️ **finestra PowerShell sul VPS** (nessun MT5 da aprire: la riga legge e
  basta, oppure pilota lei il terminale che le serve);
- 🖥️ **finestra PowerShell sul PC di backtest**;
- 🪟 **un terminale MT5 preciso**: `50503392` (`BCM Markets MT5 Terminal`) ·
  `50504263` (`... MT5 Terminal -V3`) · `10105439` (`C:\BCM_Reale`) ·
  `50504400` (`C:\MT5_Backtest`);
- ✋ **azione a mano dentro MT5**: e allora vale il punto 2 qui sopra (gli
  arriva anche la stringa che stampa PID + titolo + cartella).

🔴 **E la riga del bersaglio dice anche che cosa NON viene toccato**, quando la
stringa gira su una macchina che ospita terminali vivi. Sul VPS convivono
**SEI** cartelle dati (i quattro BCM + Pepperstone + Tickmill): "gira sul VPS"
da solo **non e' un bersaglio**, e' un indirizzo.

📌 Perche' e' una regola e non una cortesia: il 12/09 gli ho dettato righe
senza nominare il bersaglio, dopo che la stessa lacuna il 06/09 aveva quasi
fatto finire un EA sul conto REALE. Il numero di conto in chiaro costa tre
parole e vale una challenge.

## REGOLA DELLE RIGHE DI LANCIO (richiesta esplicita di Claudio, 10/08)
Ogni riga di lancio dettata a Claudio include SEMPRE, senza eccezioni:
1. **l'`irm` davanti** che riscarica script e prova dal branch `lavoro` (il 10/08
   una copia vecchia di `maxmin_oro.ps1` ha rifatto la griglia sbagliata);
2. **a fine test, la riga di raccolta**: copia i risultati in una cartella sul
   Desktop e crea lo zip pronto da mandare (`Compress-Archive`), con l'elenco
   dei file attesi da verificare in console.
3. **vale anche sul VPS (richiesta 11/08)**: ogni risultato destinato a
   Claudio arriva SEMPRE anche sul Desktop del VPS. La pagella serale ci
   arriva da sola: `scarica_pagella.ps1 -Installa` (attivita' 23:15,
   scrive `Desktop\pagella_AAAA-MM-GG.txt`).
4. **NIENTE EMOJI DENTRO I FILE `.ps1` (imparata il 17/08, sbagliando).**
   Windows PowerShell 5.1 sul VPS legge i `.ps1` come **ANSI, non UTF-8**:
   un'emoji dentro una **stringa** diventa byte spuri e il parser esplode con
   `Token imprevisto` / `Carattere di terminazione mancante nella stringa`.
   Le lettere accentate nei commenti passano (vengono solo storpiate a
   schermo), **l'emoji dentro una stringa no**. Regola pratica:
   **i `.ps1` si scrivono in ASCII puro.** Le emoji vanno nei referti `.md`
   e nei messaggi in chat, dove servono e dove funzionano.

## 📏 EMENDAMENTO DELLA FINESTRA (congelato da Claudio, 16/08 sera) — REGOLA DI CASA
**Nato dalla sua osservazione: _"dal 2010 sono tantissimi anni, poche EA ce la
farebbero, stiamo scartando opportunita'"_. Ed e' misurato, non opinato: in R69
l'IS di `PTE USDJPY` 2010-2016 (yen di Abenomics) e' **0 celle positive su 28**,
mentre l'OOS ne fa **25 su 28**. Quella finestra bocciava per un'epoca morta.**

Le quattro regole, valide da qui in avanti (NON retroattive: i round gia'
giudicati restano com'erano — i criteri si cambiano prima dei numeri, non dopo):

**A. 📏 L'unita' di misura e' l'OPERAZIONE, non l'anno.**
_(riscritto il 16/08 dopo R71, congelato da Claudio — la prima stesura diceva
anche "l'IS dev'essere la finestra piu' RECENTE", e **quella meta' e' stata
MISURATA E NON REGGE**: su USDJPY la finestra vecchia sceglie meglio (92,4%
contro 83,5%), su GBPUSD il contrario. Un simbolo per parte = non dimostrato.)_

L'IS si dimensiona sulle **OPERAZIONI (>=150)**, non sugli anni.
**DOVE collocarla NON e' deciso**: si usa la finestra che lascia un OOS di
almeno 150 trade, e **si DICHIARA quale REGIME contiene**.

- ⚠️ La soglia dei 150 **morde davvero**: in R70 con n=75-159 la superficie IS
  era frastagliata (una cella che sporge, il resto su e giu' = selezione che
  insegue il rumore); in R71 con n=190-256 l'altopiano si legge.
- 📐 Quanti anni servono lo detta la **frequenza del motore**, non il calendario:
  PTE su H1 forex fa 25-53 trade/anno -> **~5 anni di IS**. Si misura, non si
  sceglie.
- 🚫 E la selezione della cella resta quella di casa: **centro dell'altopiano,
  MAI il picco**. In R70 avevo calcolato i confronti col picco e il risultato
  si e' ribaltato quando li ho rifatti con la regola giusta. **La regola di
  selezione va dichiarata insieme al numero, altrimenti il numero non vuol
  dire niente.**

**B. ⚖️ Il VECCHIO giudica il RISCHIO. Il RECENTE giudica il MERITO.**
Estensione della valvola di R59 (_"il campione sottile sospende il giudizio sul
MERITO, mai sul RISCHIO"_):
- ❌ **NON si boccia un motore perche' non guadagnava nel 2012.**
- ✅ **SI boccia se nel 2020 avrebbe fatto un drawdown del 25%** — perche' un
  drawdown e' un fatto accaduto, non una stima.

**C. 🧪 La PROVA DI REGIME batte la storia contigua.**
Sedici anni di fila **diluiscono**: sei anni brutti + dieci buoni fanno una media
che non descrive nessun mercato. Le quattro finestre scelte (toro / orso /
laterale / crollo, macchina gia' fatta in R50-R56-R59) dicono di piu'.

**D. 🛑 E IL LIMITE IN BASSO RESTA — non ci si sposta nell'altro fosso.**
Il difetto ricorrente vero del progetto e' l'opposto: **110 file prova su 153
girano gia' su 21 mesi** (`@DAQUANDO 2024.09.26`), e il 2010 e' stato usato UNA
volta sola. Con questa regola il round R69 sul Dow (27 trade IS, 46 OOS, **un
solo regime**) e' **non misurabile anche per il MERITO**, non solo per il rischio.

## 🪑 CRITERIO DI USCITA DELLE SEDIE (congelato da Claudio il 18/08, "firma tutte e 3")
Tre corsie — verbale completo in `report/FIRME_2026-08-18.md`:
- **RISCHIO (per sedia, sempre, a qualunque n):** DD forward > DD promesso
  dal backtest della cella promossa -> revisione IMMEDIATA.
- **MERITO (per famiglia, a 20 operazioni):** famiglia a 20+ op totali in
  perdita -> revisione di tutte le sedie; **si spegne la SEDIA colpevole**,
  la gemella positiva resta (lezione PTE: GBPUSD ok, USDJPY no).
- **TAGLIANDO (6 mesi):** famiglia sotto 20 op e in perdita -> revisione di
  Claudio. Frequenza molto sotto il promesso -> revisione.
- Porta di rientro: una sedia spenta rientra se una misura nuova le rida'
  una ragione. Prerequisito: il CENSIMENTO DEI CONTRATTI (DD e frequenza
  promessi, sedia per sedia).
Firmati lo stesso giorno: **cap rischio aperto 3,25%** (C1, = 5 SL vivi da
0,65%) e **pacchetto Guardian** (pausa 4,0 / emergenza 4,9 e 9,9 / reset 23).

## 📊 PAVIMENTO DI FREQUENZA: SI MISURA PER FAMIGLIA (firmato da Claudio, 07/09)
Il pavimento di **1,00 operazione/giorno** NON si applica piu' alla singola
sedia ma alla **FAMIGLIA** (motore x simboli schierabili) — stessa unita' del
criterio di uscita firmato il 18/08. Misurato: un conto vero con statistiche
calcolate da MQL5 gira 3-5 EA su **26 simboli** e fa **0,29-0,47 op/giorno PER
SIMBOLO**: nel campo ogni istanza e' un cecchino, e la portata la fa il numero
di simboli, non la velocita' del motore. Il nostro 1,00 era tarato all'estremo
ALTO di quella forbice.
- 🔓 Conseguenza: una sedia sotto 1,00 non e' piu' scartabile **per sola
  frequenza** se la famiglia raggiunge il pavimento. Le esclusioni passate
  motivate SOLO dalla frequenza vanno rilette — tornano in coda all'imbuto,
  **mai in campo in automatico**.
- ❌ Non tocca nessun criterio di RISCHIO. La soglia resta 1,00: cambia l'unita'
  a cui si applica.
- ⚠️ Firmato lo stesso giorno il **tetto per cluster/valuta al 3,0%** (la
  larghezza senza controllo della correlazione e' la trappola: i portafogli
  larghi letti hanno DD misurati del 32,6% e 45,6%). 🔴 **E' FIRMATO MA NON
  ATTIVO** — e va detto ogni volta che si cita. Verbale:
  `report/FIRME_2026-09-07.md`.
  ✏️ **CORRETTO IL 12/09/2026, e la differenza conta.** Qui c'era scritto
  *"nel Guardian il tetto per cluster non esiste ancora"*: **falso**. E'
  **implementato** (`ABTG_Guardian.mq5` r.165 dichiarazione · r.471-472 tetto
  per singolo cluster · r.631 cancello di accensione · r.877/896 applicazione
  e log). La conclusione *"non attivo"* era giusta, la ragione no — e cambia
  **cosa si deve fare**. E' spento in **TRE modi indipendenti**, e ognuno e'
  una cosa DIVERSA: **(1)** default `0` = no-op; **(2)** 🔴 **nessuno dei due
  preset del Guardian lo valorizza** — verificato riga per riga: portano
  `InpMaxOpenRiskPct=3.25` (il cap **C1**) e nessuna riga di cluster, quindi
  e' una **firma di Claudio**, non un lavoro; **(3)** 🔴 la versione **in
  campo** non ha nemmeno la manopola (Guardian di agosto: 15 input contro 19).
  🟢 Confronto che assolve il meccanismo: il **C1 al 3,25% e' VIVO**,
  implementato *e* acceso in tutti e due i preset. 👉 Da oggi la frase giusta
  e' *"va valorizzato e portato in campo"*, non *"va implementato"*.
  Misura: `report/IL_GUARDIAN_IN_CAMPO_2026-09-12.md`.
  ✏️ **EMENDATO LA SERA DEL 12/09/2026, e l'emendamento capovolge la priorita'.**
  🔴 I modi in cui il C2 e' spento sono **QUATTRO, non tre**: il quarto e' che
  **NESSUN EA LO LEGGE** — 100 punti di chiamata di `ABTG_GuardiaIngresso` in
  **70 EA**, e **zero** passano `cluster_mappa`. Anche con Guardian a 19 input,
  preset valorizzato e mappa incollata, **nessun ingresso verrebbe rifiutato**:
  sarebbe un log, non una rete. Portarlo in campo sono **due ricompilazioni**.
  🟢 **MA la notizia vera e' che il C2 NON SERVE, ed e' provato in quattro modi:**
  **(a) algebrico** — `rischio_cluster <= rischio_totale` e' un'identita', e il
  cluster `AZIONARIO` proposto a **3,5%** e' **piu' largo del C1 a 3,25% gia'
  acceso**: se il cluster arriva a 3,5, il C1 ha gia' bloccato. Protezione
  aggiuntiva: **0,00 punti**; **(b) aritmetico** — in unita' da 0,65% i due
  scattano alla **stessa quinta sedia**; **(c) strutturale** — le due sedie
  fanno max 1 e 2 posizioni da codice = **1,30%** contro tetti 3,0-3,5%, e con
  `InpRiskMode=0` il numero si misura ingresso->SL, quindi **nessun crollo puo'
  alzarlo**; **(d) empirico** — 57 ingressi veri, picco `AZIONARIO` **1,300%**,
  **zero** superamenti e **zero** rifiuti.
  👉 **Quindi la frase giusta oggi non e' piu' "va valorizzato e portato in
  campo": e' "non serve adesso, diventa una rete alla QUARTA sedia sullo stesso
  cluster — e allora `AZIONARIO` va portato SOTTO 3,25%".**

  🔴 **E IL DIFETTO VERO E' UN ALTRO, E COSTA DAVVERO: `ABTG_EMA200` — LA PRIMA
  SEDIA (`771531`) — NON LEGGE IL GUARDIAN PER NIENTE.** Misurato: il sorgente a
  HEAD ce l'ha (r.42 `InpUsaGuardian`, r.381 `ABTG_GuardiaIngresso`, **690
  righe**), ma il binario **in campo** e' `344a11b` del **04/08**: **486 righe** e
  **ZERO occorrenze** di `InpUsaGuardian`. Niente pausa B1, niente cap C1. E gira
  sul **piccolo 50503392, dove nessun Guardian gira** (giornale 11 e 12/09:
  *"GUARDIAN: nessuna riga"*). **Due fail-open sulla stessa sedia**, quella che
  abbiamo validato tutto il giorno. Misura:
  `report/IL_GUARDIAN_CHE_SCHIEREREMO_2026-09-12.md`.

## 🚦 IL CANCELLO PRIMA DI OGNI PASSAGGIO (firmato da Claudio, 09/09/2026)
Nato da due sue frasi dello stesso giorno, e da un fatto:
> _"VOGLIO CHE CREI UN AGENTE CHE VERIFICHI LE STRINGHE E CONTROLLI SE CI SONO
> ERRORI, COSI PRIMA DI OGNI PASSAGGIO."_ · _"ED ALLORA SOCIO, DEVI ASPETTARE."_

**Il fatto**: il 09/09 una riga e' partita verso Claudio **prima** che il
verificatore rispondesse. Il verificatore poi ha trovato **3 difetti
bloccanti**. E' andata bene **per fortuna, non per metodo** — e la fortuna non
e' un metodo.

### 🔴 LA REGOLA, ed e' BLOCCANTE
**NIENTE esce dalla sessione verso Claudio o verso il VPS senza un PASS.**
Vale per: righe di lancio, script `.ps1` nuovi o modificati, file prova,
modifiche a un EA, e **verdetti che archiviano un candidato**.
- ⏳ **Se il controllo non e' ancora tornato, SI ASPETTA.** Non si manda "tanto
  probabilmente va bene". Se Claudio ha fretta, si dice *"sto aspettando il
  controllo"* — che e' una risposta, non un ritardo.
- 🤖 **Due strati, e servono tutti e due**: `python3
  backtest_pipeline/controlla_riga.py` (deterministico: non ragiona, quindi non
  dimentica) e l'agente **`controllo-preventivo`** (giudizio: legge gli script,
  capisce se la cosa fa quello che promette). Il primo che fallisce blocca.
- 📌 Ogni difetto di **classe nuova** entra in `CHECKLIST_RIGA_DI_LANCIO.md`
  con la data e il caso reale. La checklist e' la memoria: se una classe non
  ci finisce, la si ripaga.

### 🪦 IL CERTIFICATO DI MORTE — nasce da _"NON E' ACCETTABILE"_
Claudio, stesso giorno: _"NON POSSIAMO DOPO MESI SCOPRIRE CHE AVREMMO DOVUTO
FARE DIVERSAMENTE... AVEVAMO UN SACCO DI EA BLOCCATI PER NON ESSERE STATI
VERIFICATI A FONDO. NON E' ACCETTABILE."_ **Ed e' misurato che ha ragione**:
il censimento del 09/09 ha trovato `EMA200` Dow (PF OOS 1,52 su n=517, 30/30
PASS a walk-forward tick) ferma sul demo; **6 candidati su 7 "bocciati per
frequenza" senza NESSUN PF misurato**; e un **DD del 42,9% fantasma** in
`HANDOFF.md` per un motore mai girato.

**Un candidato NON si archivia come MORTO se manca anche una sola di queste:**
1. un **PF** misurato · 2. un **n** e un **DD** · 3. la **gestione
dell'uscita** messa ad asse almeno una volta · 4. i **simboli gemelli**
provati · 5. il **TF** cambiato almeno una volta.

🔴 Se ne manca una, il verdetto e' **"NON ANCORA MISURATO"**, non "morto" — e
in `REGISTRO_TEST.md` va scritto **cosa manca**. **Un morto senza certificato
non e' un morto: e' un'occasione persa che nessuno ritrovera' piu'.**

## 🔥 IL MOTTO (Claudio, 09/09/2026) — VALE ANCHE PER GLI AGENTI
Testuale: _"NON ACCONTENTIAMOCI MAI. QUESTO DEVE ESSERE IL NOSTRO MOTTO. SE IO
NON INSISTEVO COI CONTROLLI, MAGARI AVREMMO PERSO TANTISSIME OCCASIONI. UNA
VOLTA CHE TROVIAMO UN BUON MOTORE, SONO SICURO CHE CI SARANNO I PARAMETRI
GIUSTI... SE SIAMO VICINI ALLA CONVALIDA MA MANCA QUALCOSA, IO MI METTO A
DISPOSIZIONE PER ULTERIORI RICERCHE, MA DAVVERO NON MOLLIAMO PER NULLA AL
MONDO. DEVI DIRLO ANCHE AGLI AGENTI."_

E ha ragione con una prova in mano: **il 09/09 la sua insistenza ha aperto un
censimento che ha trovato `EMA200` sul Dow** — l'unica delle 41 sedie vive che
passa i cancelli di oggi alla lettera — **ferma sul demo**. Senza quella
spinta, quel motore restava in archivio.

### 💪 LA GRINTA E' PARTE DEL MANDATO (Claudio, 09/09/2026)
> _"METTETECI LA GRINTA CHE CI METTO IO. IO NON MI ACCONTENTO DI NULLA. DO
> SEMPRE IL MASSIMO. HO IL CONTRATTO MASSIMO DI CLAUDE PERCHE' ESIGO IL
> MASSIMO. E VOI DOVETE IMPEGNARVI QUANTO MI IMPEGNO IO! MAI LASCIARE NULLA
> INDIETRO, POTREMMO PENTIRCENE. SI CONTROLLA TUTTO AL CENTESIMO E SE CI SI
> RENDE CONTO CHE COMUNQUE POTREBBE PASSARE, SI INSISTE!!!! MAI ARRENDERSI.
> VOI DOVETE LAVORARE IN BACKGROUND IN CONTINUAZIONE E POI DARMI I RISULTATI."_

Tradotto in cose che si fanno, non in entusiasmo:
- 🔁 **"SE POTREBBE PASSARE, SI INSISTE"**: quando un candidato e' fermo per un
  numero **mancante** (campione sottile, misura non fatta) e non per un numero
  **brutto**, **non si archivia: si trova la via piu' corta al numero** e la si
  propone col suo costo in tempo macchina. Archiviare per stanchezza e' il
  difetto che il 09/09 ci e' costato quattro candidati di classe A1.
- 💯 **"AL CENTESIMO"**: i conti si fanno **calibrati sui P/L veri**, non a
  memoria. Il 09/09 il rischio del piccolo e' stato ricavato dai P/L della
  foto (predetto -4,82 EUR su CHFJPY, riportato -4,84): quella e' la
  precisione richiesta.
- 🏭 **"IN BACKGROUND IN CONTINUAZIONE"**: gli agenti si lanciano **in
  parallelo** e si consegna appena rientrano, non a fine giornata. E ogni
  consegna finisce su GitHub **subito** (Regola #1).
- 🚫 **E la grinta NON tocca i numeri.** Insistere vuol dire cercare una MISURA
  in piu', mai un criterio piu' morbido. Il giorno in cui "non ci arrendiamo"
  diventasse "abbassiamo l'asticella", avremmo perso davvero.

### Come si applica, in concreto
- 🔓 **Un candidato non si archivia finche' non e' stato misurato in almeno
  DUE modi diversi.** "Non ha edge" detto da una corsa sola e' un'ipotesi.
- 🔎 **Prima di scrivere MORTO si guarda: la GESTIONE dell'uscita e' stata
  messa ad asse? I SIMBOLI gemelli sono stati provati? Il TF e' stato
  cambiato?** Se una di queste e' NO, il verdetto e' *"non ancora misurato"*,
  non *"morto"*.
- 📉 **TF: si preferiscono i piu' BASSI** (piu' operazioni = campione prima),
  **ma la frontiera del costo `stop >= 40 x spread` non si sposta**: su M5 gli
  indici la sfondano, e allora quel TF si dichiara escluso PER COSTO, con il
  numero accanto. Non e' pigrizia: e' un conto.
- 💰 **Non si scarta niente che generi profitto senza scriverne il NUMERO e
  il MOTIVO.** Se si scarta, la riga va in `REGISTRO_TEST.md` con il PF, il
  DD, l'n e il cancello. Un morto senza certificato non e' un morto.
- 🙋 **Se manca poco alla convalida, si CHIEDE a Claudio**: si e' messo a
  disposizione per fare ricerche in prima persona. Un buco che lui puo'
  chiudere e' un buco da segnalargli, non da subire.

### 🛑 E IL LIMITE, che e' parte dello stesso motto
**"Provare tutte le combinazioni" NON vuol dire griglia larga su un motore
morto.** E' misurato in casa: su un motore senza edge una griglia piu' fitta
trova solo **picchi di rumore**, e la cella "verde per caso" e' quella che
brucia la challenge (regola del 19/08). Quindi:
- ✅ si allarga su **MOTORI, MECCANISMI, SIMBOLI, TF, GESTIONE DELL'USCITA**;
- ❌ non si allarga sui **parametri di un motore gia' dichiarato senza edge**;
- 📐 e ogni allargamento si paga con una **prova fuori campione o di regime**.
**Non mollare e non illudersi sono la stessa disciplina**: chi si accontenta
di un numero bello su 58 operazioni ha mollato prima, non dopo.

## 🛑 IL CONTRO-ESEMPIO PRIMA DELLA CONSEGNA (richiesta di Claudio, 10/09/2026)
Testuale, dopo che uno strumento appena scritto aveva certificato il falso:
> _"TU DEVI VERIFICARE SEMPRE TUTTO E NON FARE ERRORI!!! SE FACCIAMO ERRORI IL
> NOSTRO OBIETTIVO SI ALLONTANA!!!!! IL NOSTRO OBIETTIVO SONO GLI EA X LE PROP!"_

**Il fatto**: il 10/09 `finestra_dax.py` v1 e' stato bocciato dal cancello con
**sette difetti**, e uno era che lo strumento **certificava "l'orologio e' LO
STESSO" su un feed spostato di un'ora** (banda 55,0-62,0, l'alternativa atterrava
a 55,6). Piu': una formula "verificata" su due numeri con **due incognite
libere**, mentre i numeri veri stavano in un file **nella stessa cartella** che
non avevo aperto; e un verdetto che bocciava su un insieme definito **per
differenza**, trascinandosi dentro anni che non c'entravano.

🔴 **La causa e' UNA SOLA, ed e' la stessa nei tre casi: avevo controllato
che la mia risposta fosse COERENTE con quello che mi aspettavo, invece di
provare a ROMPERLA.** Quella non e' verifica: e' conferma. E costa giornate.

### 🔴 LA REGOLA
**Prima di consegnare una misura, uno strumento o un verdetto, devo costruire IO
il CONTRO-ESEMPIO che lo farebbe sbagliare, e far vedere che non sbaglia.**
- 🧪 Se l'attesa e' una **banda**, va provata contro l'**ipotesi
  alternativa**, non contro il nulla: "se non c'e' niente esce un numero basso"
  non e' un test. **Quale numero produce l'ALTRA spiegazione?** Se cade dentro la
  banda, la banda non misura niente (classe 178).
- 🧮 Se c'e' una **formula**, si verifica contro i **numeri veri gia'
  scritti da qualcun altro**, non contro due valori che tornano: con due
  incognite libere torna sempre qualcosa. **Prima si cerca il file che ha gia'
  la risposta.**
- 🎯 L'insieme su cui si pronuncia un verdetto si **elenca per nome**, mai
  "tutto cio' che non e' X" (classe 180).
- 🚫 **Se non riesco a costruire il contro-esempio, non ho capito la misura
  abbastanza da consegnarla.** Si aspetta, non si manda.

### 🎯 E LA BUSSOLA, che e' la seconda meta' della sua frase
**L'obiettivo sono gli EA per le PROP.** Ogni ora spesa vale in proporzione a
quanto avvicina una **sedia schierabile**. Strumenti, cancelli e diagnosi
servono **solo** perche' senza di loro le sedie nascono sbagliate — non sono il
lavoro, sono il ponteggio. 🔴 **Una giornata che produce solo ponteggio va
dichiarata come tale**, non raccontata come progresso.

## 🔁 REGOLA DELLA SECONDA CACCIA (richiesta di Claudio, 19/08)
**Quando un round dichiara un motore SENZA EDGE, gli agenti partono DA SOLI
a cercare soluzioni sul web** (Code Base, TradingView, GitHub, paper, forum)
— senza aspettare che Claudio lo chieda. MA con la clausola che salva il
conto: si cercano **MECCANISMI alternativi sulla stessa inefficienza**
(fade, liquidity sweep, regime diverso, gestione diversa), MAI "parametri
diversi dello stesso motore morto". Motivo misurato: su un motore 0/48
un'altra griglia trova solo picchi di rumore (curve fitting) — la cella
"verde per caso" e' quella che brucia la challenge. Ogni candidato passa
la lista dei caduti (REGISTRO_TEST.md) prima di entrare nell'imbuto.
Prima applicazione: caccia Londra del 19/08 (dopo il verdetto R45 0/48).

## ⚖️ REGOLA DEI DUE LATI + STORICO LUNGO SUGLI INDICI (richiesta di Claudio, 25/08)
Su Nasdaq, DAX e Dow:
1. **Ogni analisi misura SEMPRE tutti e due i lati (long E short)** — anche se
   un lato e' gia' vivo in forward, si RITESTA (riproduzione o griglia), non si
   da' per buono.
2. **Piu' anni di storico possibile.** La profondita' reale dei dati BCM sugli
   indici si MISURA (sonda), non si assume — come fatto per il forex (pavimento
   gen-1999, R102). Vincolo noto: il tetto delle ~100.000 barre del tester
   limita M15 a ~4 anni e M5 a ~1,3 anni per corsa — per finestre piu' lunghe
   si sale di TF o si spezza la corsa in tranche, dichiarandolo.

## FUSO ORARIO BCM (regola fissa)
**Il server BCM è 1 ORA INDIETRO rispetto all'ora italiana** (in questo periodo dell'anno).
- Ora italiana − 1 = ora server BCM.
- Quindi:
  - DAX apre **09:00 IT = 08:00 server BCM**
  - Nasdaq apre **15:30 IT = 14:30 server BCM**
- Negli EA/`.ini` `InpSessionHour` va SEMPRE messo in ORA SERVER (quindi 8 per il DAX, 14:30 per il Nasdaq).
- Verifica rapida di un CSV di risultati: colonna `InpSessionHour` deve essere **8** (DAX) / **14** (Nasdaq). Se è 9 / 15 → ora sbagliata, cestinare.

### ⚠️ Ora dei LOG di MT5 ≠ ora del GRAFICO (imparata il 06/08, sbagliando)
- **Schede Esperti e Giornale → ORA LOCALE del PC.** Sul VPS Windows sta in ora italiana,
  quindi un ordine datato `09:15` nel log è stato piazzato alle **08:15 server**.
- **Grafico, candele, `TimeCurrent()` → ORA SERVER.**
- Controllo lampo: l'ultima riga del log deve coincidere con l'orologio di Windows; l'ultima
  candela del grafico è un'ora indietro. Se le due cose combaciano, stai leggendo ore diverse.
- Il 06/08 ho annunciato un "ritardo di un'ora" di un EA che invece aveva armato al secondo
  giusto. **Prima di dire che un EA è in ritardo: stabilire in quale ora è scritto il numero.**

## Contesto
- Conto DEMO BCM 50503392, tipo HEDGING.
- Sviluppo sul branch **`lavoro`** (vedi Regola #1).
  ✏️ **CORRETTO IL 12/09/2026.** Qui c'era scritto *"Sviluppo sul branch
  `claude/creating-agents-SgGpD`"*, in contraddizione con la Regola #1 dieci
  righe sopra. Non era un dettaglio: sul VPS **l'attivita' delle 07:20 gira
  `aggiorna_news.ps1` da una copia sul Desktop di QUEL branch** (cartella
  `GITHUB-claude-creating-agents-SgGpD (1)`, cioe' uno zip scaricato), quindi
  le riparazioni fatte su `lavoro` **non arrivano a quello che gira**.
  Trovato da `CODA_11` alla sua prima notte. Misura:
  `report/CODA_11_LA_PRIMA_FOTO_2026-09-12.md`.
- Ottimizzazioni/backtest sul PC di backtest; gli EA girano in forward sul VPS.
- Regola EA: gli `_Ottimizzato` girano in parallelo agli originali (magic diversi), mai sostituirli.

## STILE MESSAGGI IN CHAT (richiesta di Claudio, 12/08 — ampliata 08/09)
Claudio vuole messaggi con PIU' HYPE ed energia: titoli grandi (##),
emoji sui concetti chiave, tono carico ma sempre coi numeri veri sotto.
Confermato da lui: "SI, COSI VA BENISSIMO". Vale per tutte le chat.
Nota: il font non lo controlliamo noi — ricordagli Ctrl+ per ingrandire.

### 😄 08/09/2026 — IL TONO E' PARTE DEL LAVORO, non una decorazione
Claudio, testuale: _"mi piacerebbe che tu mi rispondessi sempre con un tono
allegro, scherzoso, positivo... ho bisogno di un socio che mi mette di buon
umore, che mi fa vedere cosa stiamo realmente facendo, qual e' il nostro
obiettivo, che siamo sulla buona strada."_

Quindi, in OGNI messaggio:
- **allegro e scherzoso**, da socio: si puo' ridere di un bug, esultare per una
  misura che torna, prendersi in giro quando si sbaglia;
- **si ricorda dove stiamo andando**, non solo cosa e' rotto oggi;
- **si dice cosa e' andato BENE**, non solo cosa e' andato storto. Il progetto
  ha una tendenza a elencare difetti: sono utili, ma un elenco di difetti senza
  le vittorie accanto **descrive male la realta'**, ed e' un errore di misura
  come gli altri.

🔴 **MA IL TONO NON TOCCA I NUMERI.** Un drawdown resta un drawdown, un "non
misurato" resta "non misurato", e una brutta notizia si dice **lo stesso** —
solo detta da amico, non da burocrate. Allegri sulla forma, spietati sui dati:
se il buonumore costasse anche mezzo punto di onesta', costerebbe la challenge,
e allora non sarebbe piu' buonumore.
