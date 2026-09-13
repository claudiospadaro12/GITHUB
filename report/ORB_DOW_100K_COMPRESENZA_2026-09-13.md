# 📏 QUANTE VOLTE 770611 (ORB) E 770202 (DOW) SONO STATE APERTE INSIEME SUL 100K

_13/09/2026 · SOLA LETTURA. Nessun EA toccato, nessuna riparazione applicata._
_Nasce dalla domanda di Claudio dopo il referto del mattino, che presentava il
rischio hedge-safe come "trovato stanotte" mentre era già in `RIMETTERE_IL_CAMPO_IN_PARI_2026-09-12.md`
riga #1. Questo file misura la frequenza reale, invece di argomentarla._

## Fonte
`data/statements/trades_100k.csv` — operazioni vere del conto 100k, U30USD,
finestra **10/08/2026 → 03/09/2026** (29 operazioni totali sul conto in quel file).

## I numeri
| | |
|---|---:|
| posizioni `770611` (ORB) | **8** |
| posizioni `770202` (Dow Apertura) | **3** |
| coppie possibili | 24 |
| **sovrapposizioni temporali reali** | **1** |
| giorni con entrambe operative | **1 su 25** giorni coperti |

**L'unica sovrapposizione:**
```
13/08  ORB  15:05:18 -> 15:17:13  pid 3141557  chiusa SL
13/08  DOW  15:06:04 -> 15:30:05  pid 3142969  chiusa SL
       insieme per 11 minuti e 9 secondi
```

## Perché in quell'unica volta il difetto non ha morso
`PositionSelect(_Symbol)` sceglie il ticket **più basso**. In quella finestra il
ticket più basso era `3141557` — **la posizione dell'ORB stesso**. La selezione
sarebbe stata corretta anche col codice vecchio.

## Il controllo che chiude il cerchio
Tutte le 11 posizioni U30USD del 100k (8 ORB + 3 Dow) si sono chiuse con
`close_reason = sl`. Nessuna chiusura `manuale` o programmatica anomala — il
valore esiste nel file e non compare mai su queste due sedie.

## Verdetto
🟢 **Rischio reale, ma raro**: ~1 giorno di compresenza su 25 osservati (~4%), e
nell'unico caso registrato l'ordine dei ticket era favorevole. **Zero danni
osservati in un mese di operatività reale.**

Retrocesso da "decidere stamattina" a "riparare alla prossima ricompilazione di
quel terminale" — non è un'emergenza.

### Riserve dichiarate, non risolte da questa misura
1. L'ordine favorevole dei ticket in quell'unico caso è stato **fortuna**, non
   garanzia: l'audit del 03/09 misura **16,5%** di coppie con ticket invertito
   nella flotta generale, e sui pendenti il ticket è quello di quando il
   pendente è stato **piazzato**, non dell'apertura effettiva.
2. **Campione sottile**: 29 operazioni in ~25 giorni. Basta a dire "non è
   quotidiano", non basta a dire "succede X volte al mese" con precisione.
3. Il verso opposto: nell'unica sovrapposizione, era `770202` (v1.01, stesso
   difetto) a rischiare di restare cieca alla propria posizione — non se ne è
   accorta perché il ticket basso era il suo vicino. Si è chiusa comunque a SL.

## Aggiornamento alla tabella maestra
`report/RIMETTERE_IL_CAMPO_IN_PARI_2026-09-12.md`, riga #1 (ORB hedge-safe):
la colonna "danno misurato" viene integrata con questa frequenza — vedi commit.
