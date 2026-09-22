# 📅 RESOCONTO DEL 22/09/2026 — **due famiglie chiuse, cinque righe sbloccate, tre difetti di classe nuova**

*(Questo e' il punto sul PROGETTO. La pagella degli EA e' un'altra cosa e gira alle 23:00 in
un'altra chat: scrive `report/giornata_AAAA-MM-GG.md`. Qui non si rifa' l'analisi trade per trade.)*

---

## 🤖 COSA HA FATTO LA MACCHINA DA SOLA

### 🔴 Il runner notturno del VPS: **due notti in silenzio**
L'ultimo referto pubblicato in `backtest_pipeline/coda/referti/` e' del **20/09 alle 03:30**, con `ESITO: PARZIALE`.
🔴 **Per le notti del 21 e del 22 non c'e' niente.**
⚪ **Perche' non lo so ed e' `[NON MISURATO]`**: le due spiegazioni sono *(a)* non e' partito,
*(b)* e' partito e non ha pubblicato. Le distingue una riga di **sola lettura** sul VPS — che e'
la stessa diagnosi gia' scritta il 21/09 in `backtest_pipeline/righe/RIGA_SOSPENDI_RUNNER_DA_MANDARE.md`, pin `83664b6e`.
👉 E la cosa **non e' neutra**: se il runner e' ancora attivo, alle **03:30 ora italiana**
rifa' da solo quello che il 21/09 ha inchiodato il VPS **mentre le sei sedie operavano**.

### 🎯 La caccia automatica: **due dossier, e uno vale da solo**
| dossier | la riga che conta |
|---|---|
| `caccia_strategie/DOSSIER_CONFIG_PF_2026-09-22.md` | 🔴 **28 preset ufficiali di vendor su indici decodificati riga per riga: ZERO usano un parziale. I nostri sei EA su sei ne prendono uno del 50%.** |
| `caccia_strategie/DOSSIER_ALZARE_PF_2026-09-22.md` | 🔴 Il nostro dossier del 23/08 cita un **T-statistic che non esiste piu'**: la versione corrente del paper dice **1,46**, non **3,23**. Costo della correzione: zero. Valore: non costruire una sedia su un numero ritirato. |

🟢 **E la prima convergenza vale la giornata**: il buco che la caccia esterna ha trovato
(*il parziale che nessun vendor usa*) e' **esattamente** la manopola che `R207A`/`R207B`
misurano. Non e' una coincidenza fortunata: e' la caccia esterna e la misura di casa che
arrivano sulla stessa domanda da due strade.
📌 Piu' **28 file `.set` di vendor** scaricati in `backtest_pipeline/caccia_strategie/biblioteca/set/`: numeri d'uscita copiabili, non
opinioni.

---

## 💶 IL CONTO

⚪ **Dry-run 100k**: `[NON AGGIORNATO OGGI]`. L'ultimo `trades_auto.csv` in
`data/statements/trades_auto.csv` e' del **21/09 alle 20:49**. Il netto del giorno lo dira' la **pagella delle 23:00**,
e non lo anticipo a memoria.
⚪ **SlippageLogger sul reale**: `[NESSUN DEAL NUOVO]`. L'unico log e'
`backtest_pipeline/coda/referti/CODA_10_slippage_20260920_033003.log`, del **20/09**. Da allora niente.
🔴 **Il primo stop vero della challenge** e' di oggi: **−1.757,68 € (−2,197%)** contro
**−1.590,37 € (−1,988%)** modellati — **+10,5%**, di cui **7,83 punti di slippaggio** (3,3 volte
lo spread). Fonte: `report/PRIMO_STOP_FTMO_2026-09-22.md`.
🟢 **`770411` e' dimostrata sotto il muro FTMO del 10%** (`report/IL_MURO_MISURATO_2026-09-22.md`).
🟢 **E oggi si e' aggiunta la `770260`**: `Equity DD %` **7,31% IS / 7,86% OOS**, tutti e due
sotto il muro — ma **non** e' merito di un round nuovo: e' la firma che Claudio ha messo il
**21/09 alle 20:22** (parziale al 50%), che nessuno aveva ancora letto in questa chiave.

---

## 🔬 COSA HO DECISO IO, col numero accanto

1. 💀 **Chiusa la famiglia SUPERTREND** — 16 EA in casa. 60 celle misurate su dati esterni
   (4 simboli x 5 TF x 5 definizioni di segnale), **zero** superano il criterio dichiarato
   prima. PF netto fra **0,425 e 1,281**, e il **1,281** e' la cella che il **rumore batte**
   (PF 1,296 su una passeggiata aleatoria). Due strade indipendenti — i nostri 16 EA a tick
   reali (PF OOS 0,75-1,01) e questa sonda (0,78-1,09) — danno **lo stesso numero**.
   Fonte: `report/SUPERTREND_IL_CERTIFICATO_2026-09-22.md`.
2. 🥇 **Chiuso l'ORO 2021-2026**: le **09:30 ET** si riproducono su un feed diverso e
   un'epoca diversa (**5,75x → 7,81x** contro **4,13x → 5,07x** del 2006-2020), **ma restano
   non seguibili**: continuazione mediana **−0,144%** a +60 min, e il controllo appaiato fa
   **+1,38**. Fonte: `report/ORO_2021_2026_LA_MISURA_2026-09-22.md`.
3. 🛡️ **Abbassato il tetto di R209A da 240 a 60 minuti** (poi 17 per R207A/B) dopo che il
   cancello ha mostrato che **il tetto e' l'ampiezza della finestra di rischio** di uno
   `Stop-Process` differito. E' una decisione operativa, non una firma.
4. 📦 **Messi in repo i 14 zip grezzi dell'oro (24 MB) e tenuti FUORI i 127 MB di CSV
   derivati**, col comando per rigenerarli scritto dentro `.gitignore`.

### 🔴 E GLI ERRORI DI OGGI, che il resoconto deve dire
- **La riga dell'oro** che avevo preparato stava su **8 righe fisiche**: in console PowerShell
  il `throw` **non ferma niente**, e le due guardie erano **decorative**. Classe **538**, gia'
  pagata il 21/09.
- **Ho dato a un agente una base di costo sbagliata** (*"~23 s a passata di questa famiglia"*):
  veniva da `R112`, che e' **un altro EA, un altro simbolo, un altro TF**. Classe **583**.
- **Il mio grep delle etichette era case-sensitive** e avrebbe mancato un `ETICHETTA:` in
  maiuscolo — su `R206a` succede davvero. Rifatto case-insensitive su tutti e cinque.
- **Il convertitore dell'oro ha bocciato una conversione GIUSTA** perche' giudicava
  sull'**argmax**, e il suo autotest aveva **un solo picco piantato**: era piu' facile della
  realta' esattamente dove conta. Classe **581**.

### 📝 Classi nuove entrate oggi: **577, 578, 579, 580, 581, 582, 583, 584, 585, 586**
La piu' cara e' la **585**: il ramo del tetto **uccideva il figlio ma non il nipote**, quindi
il round proseguiva **mentre la riga stampava «fermo il round»**. Ha richiesto di correggere
**cinque righe** gia' scritte, tre delle quali **gia' consegnate**.
La **586** ha prodotto uno strumento nuovo: `backtest_pipeline/controlla_binding.ps1`, collaudato **contro il contro-esempio**.

---

## ⚠️ COSA ASPETTA CLAUDIO

🔴 **Una firma sola, ed e' vecchia di un giorno: la SOSPENSIONE DEL RUNNER delle 03:30 sul
VPS.** E' una **scrittura** sul VPS, e il perimetro del runner e' **sola lettura** fino a una
sua firma. La riga di **diagnosi** (che non cambia niente) puo' partire subito.

🟢 **Per il resto: niente che tocchi il conto reale `10105439`, niente taglie, niente soldi.**
Le cinque righe pronte girano **sul PC di backtest**, non sul VPS, e nessuna chiede una firma:
il verdetto si scrivera' sui CSV, coi cancelli gia' congelati dentro i file prova.

---

## 🎯 DOMANI

1. 🔴 **Rigenerare `R203A`, `R172E`, `R205A`** con la correzione della classe 585: sono di
   prima, e il loro ramo del tetto **mente**.
2. 🔧 **Il rimedio vero della classe 166**: propagare `-Pin` al driver e alimentare
   `$EABranch` da li'. Oggi ci abbiamo messo una **toppa leggibile** (lo SHA256 nel referto),
   non una rete. E' un lavoro sul driver, non su una riga.
3. 📊 **Leggere i due dossier della caccia** e tradurre in proposte il buco del parziale —
   che e' gia' meta' misurato da `R207A`/`R207B`.
4. 🔎 **Capire perche' il runner tace da due notti**, con la riga di sola lettura.
5. ⚪ E resta aperto, dichiarato: **la riga dei binari FTMO non e' mai stata eseguita** — e'
   quella che dice se i sei EA che volano sono davvero quelli del repo.
