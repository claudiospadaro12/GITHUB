# 🪦 REFERTO SONDA M0PB — PASSO 0 (31/08/2026, corsa 19:35)

**VERDETTO: MORTO 12/12 (6 corse × 2 lati), AI CRITERI CONGELATI PRIMA DEI
NUMERI.** Il promosso 9/10 della caccia frequenza del 31/08 cade al PASSO 0:
**la frequenza promessa non esiste sui nostri indici** e, dove la frequenza
quasi c'e' (M5), **l'aritmetica del rischio lo condanna comunque (H8)**.
Nessuna corsa a tick va lanciata. Nessuna griglia di recupero (regola della
seconda caccia: mai "parametri diversi dello stesso motore morto").

---

## 📦 Il banco (fresco, verificato)

- Zip: `SONDAM0PB_CORSA_20260831_1935.zip` — referto `modo: CORSA`,
  `data: 2026-08-31 19:35:56`, pin `4e1cdf8` (riga v2 approvata dal
  verificatore lo stesso giorno).
- **Compilazione dell'EA nuovo: OK** (54 KB) — primo collaudo superato.
- Collaudi 6/6 verdi: righe 2/2 per CSV, autotest 0/12 falliti, RsiDivMax
  0.000 (T1), AtrDiv non-zero 9,6-16,4% (T3: ATR alla Pine davvero diverso
  da iATR), PuntoIdx 1,000 (T8), eco mult 2,75, conteggi identici fra le 2
  passate (determinismo). Cache tester 0/0. Grep contatore puro: 0 chiamate.
- Gemellaggio prova M5/M15 VALIDO. CSV `*_OOS` presenti ma **0 byte**
  (gamba degenere FrazioneIS 1.0, come atteso: nessun numero da finestra non
  dichiarata). PROBLEMI 0, RILIEVI 0.
- Spot-check indipendente in sessione: F1 e RR ricalcolati dalle colonne
  grezze (`Segnali Long/Short` / `Giorni Contati`, take/stop mediani)
  riproducono la tabella del referto al millesimo.
- Finestra 2024.09.26 → 2026.06.30, modello 2 (open prices), **un solo
  regime (toro)** — ma qui si contavano occasioni, non merito.

## 📊 La tabella (passata fedele al Pine, modo 1)

| corsa | lato | sig/gg | take med (idx) | stop med (idx) | RR | WR necessario | VERDETTO |
|---|---|---:|---:|---:|---:|---:|---|
| U30_M5 | L / S | 0,504 / 0,520 | 46,9 / 55,0 | 69,4 / 81,0 | 0,677 / 0,679 | 64% | MORTO / MORTO |
| U30_M15 | L / S | 0,147 / 0,205 | 103,8 / 118,8 | 145,7 / 159,9 | 0,712 / 0,743 | 62-63% | MORTO / MORTO |
| NAS_M5 | L / S | 0,492 / 0,500 | 30,1 / 47,4 | 42,0 / 64,1 | 0,716 / 0,739 | 62-63% | MORTO / MORTO |
| NAS_M15 | L / S | 0,187 / 0,167 | 52,3 / 91,2 | 97,0 / 130,8 | 0,539 / 0,697 | 63-70% | MORTO / MORTO |
| DAX_M5 | L / S | 0,451 / 0,490 | 27,7 / 40,5 | 44,3 / 58,4 | 0,625 / 0,693 | 63-66% | MORTO / MORTO |
| DAX_M15 | L / S | 0,211 / 0,172 | 53,5 / 78,1 | 78,8 / 108,7 | 0,679 / 0,718 | 63-64% | MORTO / MORTO |

## 🔎 La lettura, cancello per cancello

- **F1 (frequenza ≥ 1/giorno per lato): 0/12.** Il lato migliore di tutta la
  griglia fa **0,52 segnali/giorno** (U30 M5 short) — la meta' della soglia.
  Su M15 si scende a 0,15-0,21. Il "60-70% win rate, alta frequenza" della
  pagina TradingView sui NOSTRI indici in RTH vale **un segnale ogni 2 giorni
  per lato**. Osservazione onesta (NON un ri-giudizio: il criterio congelato
  e' per lato): anche sommando i due lati, M5 fa 0,94-1,02/giorno totali —
  al pelo del minimo di Claudio, e comunque irrilevante perche'...
- **H8 (RR ≥ 0,70, FIRMA 2): 7/12 sotto soglia, e i 5 sopra sono a 0,70-0,74.**
  Lo stop a 2,75×ATR e' strutturalmente piu' largo del take
  (highest/lowest 12): il motore chiede un **win rate del 62-70% solo per
  pareggiare l'attesa 0,075R** — la zona che in casa non ha mai pagato.
  T10 (sweep aritmetico): per portare U30_M5 long a RR 0,70 servirebbe
  mult ≈ 2,66 — e stringere lo stop aumenta gli stop presi, costo che la
  sonda non vede. **Nessun mult va pescato per far passare il cancello.**
- **F2 (take mediano > 7 punti indice): 12/12 PASSANO, e alla grande**
  (27-119 punti). L'unico cancello verde: quando il segnale arriva, lo
  spazio c'e'. Non basta: senza frequenza e senza RR, lo spazio e' decor.
- Gradiente F6 (M5 vs M15): coerente e monotono su tutti e tre i simboli
  (piu' barre = piu' segnali, take e stop scalano con l'ATR del TF). Il
  contatore si comporta in modo fisicamente sensato: **la bocciatura e' del
  motore, non del banco.**

## ⚰️ Registro dei caduti — voce nuova

**M0PB (Momentum Pull Back, Marcns/TradingView GnsUpEsB, MPL 2.0):** impulso
RSI(6) estremo + rientro EMA(5). Morto al PASSO 0 il 31/08/2026: frequenza
0,15-0,52 segnali/giorno/lato (soglia 1,00) su 3 indici × 2 TF, RR da
mediane 0,54-0,74 con stop 2,75×ATR (soglia 0,70, FIRMA 2), win rate
necessario 62-70%. Preso col contatore puro (zero ordini): **costo del
verdetto = una compilazione + 12 passate open-prices (~minuti), zero corse a
tick sprecate.** La geometria del take (F2 largamente verde) non salva un
motore che non genera occasioni. NON ritestare con altre griglie; un
eventuale rientro solo con un MECCANISMO diverso sulla stessa inefficienza.

## ➡️ La seconda caccia e' GIA' consegnata (stesso giorno)

La regola del 19/08 chiede meccanismi alternativi, non parametri nuovi. Sono
gia' nel vivaio, stessa missione frequenza:
1. **LondonFx** (EURUSD M5, canale SMA5 Londra, RR 1,875 dichiarato: al
   cancello H8 basta il 42% di win rate netto — contro il 62-70% chiesto da
   M0PB). Bozza congelata: `prove/LONDONFX_FREQUENZA_BOZZA.txt`. Prossimo
   passo: costruire la sonda di conteggio (stesso stampo di ABTG_SondaM0PB).
2. **Sonda dell'Orologio** (FX, una posizione per sessione): pronta dal
   28/08, mai girata — riga gia' scritta.

_Fonti: zip `SONDAM0PB_CORSA_20260831_1935.zip` (referto + 6 CSV OPTFRAME a
2 passate + 2 prova) · `mql5/Experts/ABTG_SondaM0PB.mq5` a pin `4e1cdf8` ·
criteri congelati in `prove/M0PB_FREQUENZA_M5/M15.txt` e nel dossier
`caccia_strategie/CACCIA_FREQUENZA_2026-08-31.md`._
