# R101 — VERBALE DI FIRMA: l'ablazione dei filtri, rifatta su DOW e DAX

**Firmato da Claudio il 23/08/2026, in chat: "SI AD ENTRAMBE, FIRMO
L'ABLAZIONE SU DOW E DAX"** — nel contesto della sua richiesta esplicita:
*"VOGLIO MIGLIORARE GLI EA SUL CONTO DA 100K SU APERTURA DOW ED APERTURA
DAX. DOBBIAMO FARCELA"*.

## Cosa e' stato firmato (il perimetro, prima dei criteri)
- Si chiude il debito del 18/08: l'ablazione dei filtri era pronta sul
  Nasdaq, che R97+R98 hanno chiuso. Si RIFA' sui mercati dove l'edge
  misurato esiste: **U30USD (Dow) e D30EUR (DAX)**, sulle SEDIE VIVE della
  famiglia Apertura del conto 100k.
- Metodo della scala (come test_orb_toolkit): si parte dalla cella viva
  congelata e si toglie/aggiunge UNA variabile alla volta, per misurare
  quanto ogni filtro PAGA o COSTA. Nessuna griglia, nessuna pesca.
- Obiettivo dichiarato: candidati di MIGLIORAMENTO misurati per le sedie
  del 100k. Nessun parametro si tocca in forward: solo celle gemelle nei
  round; l'eventuale promozione e' una firma successiva.

## Cosa resta da scrivere PRIMA dei numeri (i criteri veri)
`R101_CRITERI.md` con: le celle vive congelate (input per input, con
fonte), la lista esatta dei filtri da ablare per ciascun EA, finestre
IS/OOS, cancelli, canarino. La stesura parte appena la macchina di
preparazione e' libera (R100 oro in corso). I criteri completi tornano
da Claudio per la firma finale prima di qualunque passata.

---

## ✅ AGGIORNAMENTO 23/08/2026 — LA PREPARAZIONE E' FATTA, MANCA SOLO LA FIRMA

Tutti i pezzi sono scritti, verificati e pushati. **Nessuna passata e'
partita, nessun sorgente EA e' stato toccato, il forward non e' stato
sfiorato.**

| pezzo | dove | stato |
|---|---|---|
| **Criteri di dettaglio** | `risultati_archivio/R101_CRITERI.md` | 🔴 **BOZZA — [DA FIRMARE]**, sei decisioni al par. 10 |
| **File prova** | `prove/R101_{DOW,DAX}_*.txt` (18) | ✅ scritti e verificati meccanicamente |
| **Driver** | `righe/RIGA_R101_ABLAZIONE.ps1` (`MARCATORE_RIGA_R101_v1`) | ✅ |
| **Righe di lancio** | `righe/RIGA_R101_DA_MANDARE.md`, pin `f91e320` | ✅ **dal verificatore**, non ancora mandate |

### 🔴 Il rilievo che ha cambiato la preparazione

**I default del sorgente `ABTG_Dow_Apertura_US.mq5` NON sono la cella viva.**
Il sorgente dichiara ancora la geometria vecchia (BREAKOUT 15/200, TP 0,5R,
niente parziale, niente BE); la sedia che gira coi soldi e' RETEST 35/1000/400
con TP1 1R, parziale 50% e BE, deployata il **09/08 alle 15:34**.
Costruire l'ablazione sui default avrebbe misurato i filtri **sopra un motore
che non esiste piu'**. Le celle vive sono percio' congelate **dagli artefatti**
(R54a, R46a/b, `PASSI_OPERATIVI.md`) e **riconfermate riga per riga sui CSV di
ottimizzazione veri**, non dai `#define`.

### 🚧 E il round non parte da solo

Il driver **si rifiuta di fare la corsa vera** finche' `R101_CRITERI.md` porta
`[DA FIRMARE]` (esce con codice 2 e spiega cosa fare). Il **giro a vuoto gira
lo stesso**, e va mandato per primo: verifica tutto, compila i due EA e non
apre il tester.

### 🛠️ E una cosa che Claudio ha chiesto e che NON e' un gradino

La **mediazione / ingresso in 2 tranche 1:2** (richiesta del 23/08): l'input
**non esiste** nei due sorgenti — verificato. Va in coda di sviluppo con la
spec completa (`R101_CRITERI.md` par. 8.1), e il suo vincolo *"rischio totale
del ciclo = 1R"* e' scritto li' come **il** requisito di sizing: e' esattamente
cio' che disinnesca la bandiera B1 del corso (*"rischio 2,5R venduto come 1R"*).
