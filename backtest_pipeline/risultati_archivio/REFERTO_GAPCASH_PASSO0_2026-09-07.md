# 🔴 GAPCASH NASDAQ — PASSO 0 — **SCARTO** — 07/09/2026

> ## IL FENOMENO C'E'. IL SEGNO E' ROVESCIATO.
> Le giornate di gap cash esistono su BCM e sono **piu' frequenti dell'atteso**
> (77 contro ~62). Ma il rimbalzo dei 15 minuti **non c'e': c'e' il contrario.**
> Un effetto misurato su 2.568 giornate di dato ESTERNO, con controllo e
> monotonia, **si rovescia sui tick BCM**. Costo della scoperta: **8 minuti di
> macchina** invece di un round di merito, un EA scritto e settimane di forward.

- Contratto congelato (06/09, prima di qualunque numero BCM): `backtest_pipeline/prove/GAPCASH_NAS_PASSO0.txt`
- Dossier di caccia: `backtest_pipeline/caccia_strategie/CACCIA_NASDAQ_MECCANISMI_2026-09-06.md` §2
- Sonda: `mql5/Experts/ABTG_SondaGapCash.mq5` (**prima compilazione in assoluto: 0 errori, 0 avvisi**)
- Pin della corsa: `4bf50bbf88f74a22a0c06648969c204f941ee2cf`
- CSV grezzi: `risultati_archivio/gapcash_passo0_csv/`
- NASUSD M5, Modello 4 (tick reali **misurati**: 166.509.474 dal 2024.09.26), `@DAQUANDO 2024.09.26 -> 2026.06.30`

---

## 1. 🎯 IL VERDETTO, CANCELLO PER CANCELLO

| criterio | esito | numero |
|---|---|---|
| **P0-1 frequenza** | 🟢 **PASSA** | **77 giornate-evento** (cancello 25; attese ~62) |
| **P0-2 separazione** | 🔴 **SCARTO** | **-0,0487%** evento contro **-0,0134%** controllo |
| **P0-3 costo** | 🔴 SCARTO | take mediano **-8,0** contro spread campana 1,8 |
| **P0-4 geometria** | (nessun cancello) | p75 di \|MAE\| = **0,3635%** |
| **P0-5 due lati** | 🔴 frequenza PASSA, separazione SCARTO anche sullo SHORT | |
| **P0-6 lunedi'** | 🟢 PASSA | 18 su 77 = **23,4%** (cancello 40%) |

**VERDETTO COMPLESSIVO: SCARTO.**

## 2. 🔀 IL CONFRONTO CHE UCCIDE IL CANDIDATO

```
dato ESTERNO (HistData, 2.568 giornate):   evento +0,0988%   controllo +0,0112%
tick BCM     (questa corsa, 77 eventi) :   evento -0,0487%   controllo -0,0134%
```

**Il segno e' invertito su tutte e due le colonne.**

⚠️ **La trappola aritmetica, evitata**: il rapporto e' **3,64x**, cioe' "supera"
il cancello del 3x. Ma **sono negativi tutti e due** — 3,64 volte piu' negativo.
Il criterio congelato chiede `media_evento > 0` **E** `>= 3x`, in quest'ordine,
e la sonda ha applicato il primo. 👉 Il caso degenere era stato **previsto per
iscritto dall'autore della sonda PRIMA della corsa** (*"il criterio degenera se
media_tutti <= 0: diventa vero per aritmetica"*).

## 3. 🧪 LA MISURA SI E' AUTO-VERIFICATA

La corsa di CONTROLLO (gate spento) non e' un verdetto: e' il collaudo della
misura, ed e' passata su tutti e quattro i punti.

```
1. il gate e' davvero SPENTO:                   Eco Gate Spento = 1        -> SI
2. a gate spento ogni giornata valida e' evento: 446 contro 446            -> SI
3. la media di CONTROLLO misurata DUE volte:    -0,0134% contro -0,0134%   -> COINCIDONO
4. gemelli di determinismo:                                                   IDENTICI
```

Non e' un numero solo: sono **due misure indipendenti** che danno lo stesso
risultato. Il numero negativo e' reale, non un artefatto della macchina.

## 4. 📉 E LA MONOTONIA — L'ARGOMENTO PIU' FORTE DEL DOSSIER — SI ROMPE

Sull'esterno la media **cresceva in modo MONOTONO** al crescere della soglia
(0,060 -> 0,079 -> 0,099 -> 0,100 -> 0,118 -> 0,190): era **la** prova che non
fosse rumore, ed era il test che il 05/09 aveva ucciso la reversione overnight
su DAX e S&P.

Sui tick BCM: **4 rotture su 7**. Il referto lo scrive netto:
> _"il gate non e' una manopola pulita su questo feed"_

## 5. ✅ PERCHE' E' UN BUON RISULTATO

Il dossier del 06/09 aveva scritto, **prima**, il motivo n.1 per cui poteva morire:

> _"🔴 Il dato e' ESTERNO, non e' BCM. E' il feed HistData, e il referto del 26/08
> lo dichiara **'cancello qualita' del feed IN VERIFICA'** con il **22,9% di giorni
> sospetti nel 2023**. Il PASSO 0 serve proprio a rifare la misura sui nostri tick."_

**E' successo esattamente quello.** Il passo 0 ha fatto il lavoro per cui esiste.

🔒 **La cassaforte 2021-2026 dello storico esterno resta SIGILLATA** e non serve
piu' aprirla: il candidato e' morto prima, sul dato che conta.

## 6. 🗂️ COSA RESTA A VERBALE

- 🟢 **La sonda `ABTG_SondaGapCash` funziona**: 1.997 righe scritte senza mai
  vedere un compilatore, compilata al primo colpo con **0 errori e 0 avvisi**,
  e i suoi controlli interni (eco del gate, gemelli, doppia misura del
  controllo) hanno tutti risposto. E' riusabile se un giorno si volesse
  misurare lo stesso meccanismo su un altro simbolo.
- 🔴 **La collisione P0-7 resta agli atti e NON e' sciolta** (questo passo 0 non
  la scioglie, la dichiara): su una mattina di gap in giu' la sedia **GATED
  SHORT 770250** vende e questo motore avrebbe comprato — opposti, stesso
  simbolo, stesso minuto, stesso conto. Non serve piu' per questo candidato,
  ma il precedente vale per il prossimo che entrera' su NASUSD alle 14:30.
- ⚠️ **Igiene**: 53 giornate scartate per poche barre M1, 98 letture M1 fallite,
  0 giornate troncate, aperture non esatte **0 su tutte le soglie**.
- 🟢 **La classe 155 ha funzionato al primo giro vero**: due CSV di una corsa
  PRECEDENTE **non** sono stati allegati allo zip, e il referto li elenca con
  nome e ora. Il difetto era stato trovato ~40 minuti prima, in verifica.

---

_Corsa eseguita da Claudio sul PC di backtest (terminale PICCOLO 50503392) il
07/09/2026: giro a vuoto alle 15:09, corsa vera alle 15:17. Zero problemi._
