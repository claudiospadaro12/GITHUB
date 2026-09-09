# 🚪 STUDIO GESTIONE APERTURE — il round che aspettava dal 14/08

**Etichetta**: `gestione_20260909` · **pin** `19611bae` · tick reali M5 · deposito 10.000 · rischio 1,0%
**Arrivati sul repo DA SOLI** dal VPS (`pubblica_risultati.ps1`, primo uso): Claudio era al lavoro.
Ingresso **fissato ai default**: l'unica cosa che cambia e' cosa succede DOPO l'ingresso.

---

## 🟢 D30EUR (DAX) — **48 celle, n da 325 a 524: tutte SOPRA il pavimento dei 150**

### 🏆 L'ALTOPIANO, non il picco
| parziale | trailing | PF | DD % | n | peggior giorno |
|---|---|---:|---:|---:|---:|
| **0 (spento)** | **PREVBAR** | **1,379** | **6,03** | 325 | −1,06% |
| **0 (spento)** | **PREVBAR** (BEatR on) | **1,351** | **6,14** | 325 | −1,05% |
| 50% *(la sedia VIVA)* | PREVBAR | 1,309 | 6,88 | 445 | −1,04% |
| 50% | PREVBAR (BE vari) | 1,296 | 6,89 | 445 | −1,05% |
| 0 | **OFF** | 1,106 | **22,21** | 325 | −1,10% |

Le **quattro celle in cima sono tutte `parziale OFF + PREVBAR`**, e restano fra 1,351 e
1,379 al variare del breakeven: **e' un altopiano, non una punta**. Le vicine
(parziale 50%) stanno a 1,296-1,309. La regola di casa e' rispettata.

### 📌 IL NUMERO CHE CONTA
**Togliere il parziale 50% porta il PF da 1,309 a 1,379 (+5,3%) e il DD da 6,88% a
6,03% (−12,4%). Meglio su TUTTI E DUE gli assi contemporaneamente.**
⚠️ Ma il campione cala da 445 a 325 operazioni (−27%): con parziale spento la
posizione resta aperta piu' a lungo e l'ingresso e' bloccato -> **e' il cancello G6
congelato stamattina** (se `n` si muove >20% il confronto e' da leggere con cautela).
Qui il movimento e' del 27%: **il confronto regge sulla direzione, non sul decimale.**

### 🛡️ E il trailing e' quello che tiene in piedi il rischio
Spegnerlo porta il DD da 6,03% a **22,21%**. Non e' un dettaglio di rifinitura:
e' la differenza fra una sedia schierabile e una che sfonda il muro prop.
🔴 `FIXED` invece va evitato: PF 1,154 ma profitto **328** contro 2.970 — e'
il difetto del 03/08 (trailing a punti fissi troppo stretto per una candela DAX).

---

## 🔴 NASUSD (Nasdaq) — **NESSUNA struttura d'uscita lo salva**

**Tutte e 48 le celle stanno sotto PF 1,00.** La migliore: **0,993** (parziale 50% +
PREVBAR, DD 16,91%, n 483). La peggiore: **0,860 con DD 48,72%**.

| trailing | PF migliore | DD |
|---|---:|---:|
| PREVBAR | 0,993 | 16,91% |
| FIXED | 0,945 | **7,16%** |
| ATR | 0,946 | 24,07% |
| **OFF** | 0,962 | **30-48,72%** |

👉 **Il verdetto non e' "manca la gestione giusta": e' che il motore non guadagna.**
Su 483-591 operazioni — **campione pieno, merito NON sospeso** — nessuna delle 48
strutture arriva a 1,00. Cambiare l'uscita sposta il DD (da 48,7% a 7,2%!), **non
il segno**.

---

## 🎯 LA TERZA CONFERMA INDIPENDENTE SULLO STESSO FATTO
Il parziale al 50% **costa**, e oggi lo dicono tre fonti che non si sono parlate:
1. **R46 (14/08)**, tick reali OOS: PREVBAR senza parziale **1,49** contro **1,40** col parziale;
2. **Questo round (09/09)**, tick reali: **1,379** contro **1,309**, e DD migliore;
3. **La live di Emiliano (09/09)**: parziale preso presto + stop allargato ->
   *"Profitto ridicolo. Ridicolo."* Verdetto suo, in diretta.

Tre strade diverse, stessa direzione. **Non e' piu' un'ipotesi.**

---

## 🕳️ BUCHI E LIMITI DICHIARATI
- Round a **rischio 1,0%**, non allo 0,65% del contratto di casa: i DD vanno
  riscalati (x0,65) per il confronto col campo. La **direzione** del confronto
  fra celle non cambia.
- **Il cancello C3 (costo) NON e' misurato in questo round**: lo stop mediano non
  e' fra le colonne. Su M5 la frontiera `40 x spread` e' quella che CLAUDE.md
  segnala come critica. **Prima di qualunque schieramento va misurato.**
- Molte celle sono **duplicate**: `InpBEatR` e `InpBreakevenAtTP1` risultano
  **inerti quando il trailing e' acceso** — stesso fenomeno della miniera di
  stamattina, trovato di nuovo qui.
- Nessuna promozione esce da qui: e' uno studio di STRUTTURA, e la decisione di
  toccare una sedia viva e' di Claudio.
