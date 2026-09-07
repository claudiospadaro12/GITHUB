# 🖥️ IL QUARTO MT5 — il terminale da BACKTEST sul VPS

Nasce da Claudio (07/09/2026): _"decidi se fare tutto su VPS perché il PC
spesso sarà spento o in sospensione. Il VPS sarà sempre attivo."_
E dalla sua domanda subito dopo: **"apro un quarto conto demo?"**

---

## ✅ LA RISPOSTA: SÌ. E il motivo è la TUA regola, non una mia preferenza.

`CLAUDE.md`, **REGOLA DEI TERMINALI MULTIPLI** (06/09, nata da un attacco EA
quasi finito sul conto reale):
> _"dichiaro SEMPRE il numero di conto … non chiedo MAI a Claudio di
> riconoscere la finestra a occhio"_

Un quarto terminale su un **numero di conto NUOVO e diverso** rende ogni riga
di log, ogni `.chr` e ogni referto **attribuibile senza inferenza**. Riusare
un login già in campo (es. il piccolo 50503392 su due terminali) creerebbe
esattamente l'ambiguità che quella regola vieta.

## 🔴 MA DEVE ESSERE **BCM**. Non è negoziabile.

Il conto nuovo va aperto **sullo stesso broker**, BCM.

Se i tick e gli spread venissero da un altro broker, **ogni misura fatta finora
diventerebbe incomparabile**: i 252 milioni di tick del 03/09, i muri dello
storico (`@DAQUANDO 2024.09.26`), gli spread misurati (D30EUR 1,6-1,7 · U30USD
1,9-2,0 · NASUSD 1,6-1,8), la frontiera del costo `stop >= 40 x spread`.
Sarebbe un progetto nuovo, non lo stesso con una macchina in più.

---

## ⚠️ IL RISCHIO VERO, ED È QUELLO CHE MI PREOCCUPA: LA **CPU**

Un walk-forward a tick reali **satura la macchina**. E sul VPS quella macchina
è la stessa che tiene vivi **tre terminali con posizioni aperte**, di cui uno
con **soldi veri**.

🔴 **Un backtest che affama il forward può fargli perdere tick o ritardare un
ordine.** Non è teorico: è la stessa CPU.

### Le tre protezioni, da mettere PRIMA della prima corsa
1. **Tetto agli agenti del tester.** MT5 usa di default tutti i core. Va
   limitato a **metà** (o N-1), così il forward ha sempre aria.
2. **Finestra oraria dichiarata.** I round girano solo quando le sedie NON
   lavorano: le nostre aprono alle **08:00** (DAX) e **14:30** (Nasdaq/Dow)
   ora server. Finestra sicura: **00:00 - 06:30 server**.
3. **Un canarino sul forward.** Dopo ogni notte di backtest, si guarda se i
   terminali vivi hanno perso colpi (buchi nei log, ordini in ritardo). Se
   succede, il tetto agli agenti scende. **Si misura, non si spera.**

## 💾 E il disco
Il terminale nuovo **ri-scarica lo storico da zero**: i 252 milioni di tick
misurati il 03/09 non sono pochi. Va verificato lo spazio libero **prima**, non
quando il disco si riempie a metà di un round.

---

## 🔧 IL LAVORO SUL DRIVER — e qui c'è una trappola già pagata

`walkforward_generico.ps1` sceglie il terminale così: prende quello che contiene
`BCM Markets`, **escludendo** `-V3` e `BCM_Reale`. 👉 Un quarto terminale BCM
**finirebbe nel mucchio**, e il driver potrebbe puntare il piccolo invece del
nuovo — o viceversa.

**È esattamente la classe 37-quater**, pagata il 07/09: un ripiego che sceglie
il terminale sbagliato e non lo dice.

Quindi:
- l'installazione va in una cartella con un nome **inequivocabile**, es.
  `C:\MT5_Backtest`;
- il driver impara un parametro **`-TerminaleBacktest`** che punta **quello e
  solo quello**, e **muore** se trova qualcos'altro;
- e la guardia esistente resta: `-V3` e `BCM_Reale` restano **vietati**.

---

## 📋 I PASSI, IN ORDINE

| # | cosa | chi |
|---|---|---|
| 1 | **Aprire un conto DEMO BCM nuovo** (qualunque saldo) e segnarsi il numero | 👤 **Claudio** |
| 2 | Installare MT5 BCM in `C:\MT5_Backtest`, loggare quel conto | 👤 **Claudio** |
| 3 | **NON attaccare NESSUN EA.** Nessun grafico con esperti, mai | 👤 **Claudio** |
| 4 | Limitare gli agenti del tester a metà dei core | 👤 **Claudio** |
| 5 | Verificare spazio disco e scaricare lo storico | 🤖 riga che preparo io |
| 6 | Insegnare al driver `-TerminaleBacktest`, con la guardia che muore se sbaglia | 🤖 io |
| 7 | Prima corsa di prova: un round GIÀ FATTO, che deve **riprodurre** il numero noto | 🤖 io preparo, 👤 lui lancia |
| 8 | Canarino sul forward dopo la prima notte | 🤖 io |

> ### 🎯 IL PASSO 7 È IL PIÙ IMPORTANTE, E NON SI SALTA
> Il primo round sul terminale nuovo **non deve essere un round nuovo**: deve
> essere **uno già misurato**, che deve **riprodurre il numero alla cifra**.
> Se non lo riproduce, la macchina nuova non è la stessa macchina — e ogni
> numero che ci facciamo sopra è un numero diverso, non un progresso.
>
> L'ancora naturale è **R119**: `770611` OOS **2484,17 / PF 1,67490 / DD 6,5389%
> / 119 trade**, e `770101` OOS **1103,31 / PF 1,41105 / DD 4,3501% / 270 trade**.
> Stessa finestra, stesso preset, stesso `ExecutionMode=0`. **Deve uscire
> identico.**

---

## 🛑 E FINCHÉ NON C'È

"Tutto su VPS" vale per **letture, misure, cacce e codice** — che è già
tantissimo e gira da stanotte. **Non vale per i round**: quelli restano sul PC
di backtest finché il passo 7 non è verde.

Dirlo diversamente sarebbe una promessa, e le promesse qui non si fanno.
