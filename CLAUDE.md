# Note di progetto — DA RICORDARE SEMPRE

## ⛑️ REGOLA #1 — SALVA SEMPRE SU GITHUB (richiesta esplicita di Claudio)
**Ad OGNI passo significativo → commit + push su GitHub, SUBITO.** Claudio non deve MAI rischiare di perdere lavoro se la chat si blocca/riempie (è già successo spesso).
- Branch di lavoro attuale: **`lavoro`** (qui è consolidato TUTTO).
- Dopo ogni: analisi salvata, modifica EA, nuovo file, decisione presa → aggiorna il file giusto (`PROMEMORIA_APERTURE.md`, `CLASSIFICHE.md`, `HANDOFF.md`, ecc.) e **pusha**.
- Ciò che non è pushato = perso. Nel dubbio, committa.
- Per ripartire in una chat nuova: leggere `HANDOFF.md` + `PROMEMORIA_APERTURE.md` + `CLASSIFICHE.md` sul branch sopra.

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
- Sviluppo sul branch `claude/creating-agents-SgGpD`.
- Ottimizzazioni/backtest sul PC di backtest; gli EA girano in forward sul VPS.
- Regola EA: gli `_Ottimizzato` girano in parallelo agli originali (magic diversi), mai sostituirli.

## STILE MESSAGGI IN CHAT (richiesta di Claudio, 12/08)
Claudio vuole messaggi con PIU' HYPE ed energia: titoli grandi (##),
emoji sui concetti chiave, tono carico ma sempre coi numeri veri sotto.
Confermato da lui: "SI, COSI VA BENISSIMO". Vale per tutte le chat.
Nota: il font non lo controlliamo noi — ricordagli Ctrl+ per ingrandire.
