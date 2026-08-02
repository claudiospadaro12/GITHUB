# 🎯 PIANO PROP + CONTO PERSONALE — la rotta (brief Claudio, 02/08/2026)

> **La priorità n°1 è la PROP** (le prop), più di ogni altra cosa. Poi il conto personale.
> _"Dobbiamo farcela. È molto importante. Prendiamoci il tempo necessario."_ → metodo sui numeri, senza fretta.

---

## 1) 🏆 PROP — priorità massima

### Profilo EA prop ideale (parole di Claudio)
- **TF preferito: H1.** L'H4 spesso è troppo lento.
- **Durata trade:** chiusura **in giornata o max 2 gg**; accettabile fino a **4 gg**. Un mese è troppo. **Weekend OK** (si può tenere).
- **Gestione voluta:** **parziale + stop in pari + trailing** → **profitti COSTANTI**. Accetta di lasciare sul tavolo i "runner" (giorni in cui il prezzo corre tanto) in cambio di **costanza**.
- **Metrica che comanda:** **DD BASSO** + robustezza (è ciò che fa passare una challenge).

### ✅ Candidati che GIÀ rientrano nel profilo (validati tick reali)
| EA | Simbolo | TF | PF | DD% | Durata trade | Note |
|---|---|---|---|---|---|---|
| **SupRev H1** | Nasdaq | H1 | 1,40 | **1,2** | ~intraday/1gg | ⭐ il più vicino all'ideale |
| SupRev H4 | Nikkei | H4 | 1,05 | **0,14** | ~7h (reversal) | DD bassissimo (ma H4) |
| SupRev H4 | Oro | H4 | 1,46 | 1,2 | ~7h | chiude in giornata |
| GoldenCross H4 | USDCHF | H4 | ~2,6 | 1,9 | — | robusto |
| EMA200 H4 | 200AUD/SPX | H4 | 1,4-1,6 | 1,4-1,9 | — | il motore più robusto |

**Insight:** i motori **reversal (SupRev)** chiudono in fretta (7h-1gg) → sono i più adatti al vincolo "1-2 giorni". Il TF H1 accorcia ancora.

### 📋 Piano d'attacco PROP (in ordine)
1. **Validare a TICK REALI in H1** i motori sul TF che preferisci (l'H1 è poco esplorato):
   - **GoldenCross H1** ⬅️ primo: OHLC fortissimi (Oro 2,01 · USDJPY 1,97 · GBPUSD 1,78), tick reali H1 mai fatti.
   - SupRev H1 / EMA200 H1 su simboli scelti.
2. **Filtro DURATA:** d'ora in poi misuro la durata media trade di ogni candidato → tengo solo chi chiude entro ~2 gg (dal report reale o dai backtest per-deal).
3. **Walk-forward IS/OOS** sui finalisti H1 (anti-overfit) — ultimo cancello prima del dry-run.
4. **Dry-run sul demo 100k + Guardian** (FTMO 2-Step): si simula la challenge con i finalisti.
   - NB: FTMO 2-Step non ha limite di tempo → l'H4 lento sarebbe ammesso, ma tu preferisci H1 per costanza e rotazione del capitale. Seguiamo la tua preferenza.

---

## 2) 💻 CONTO PERSONALE — aperture M5
- **Puntare sulle aperture M5** (tua scelta).
- Motore: **confronto STOP vs RETEST** in corso (tick reali) → si sceglie quello che regge i costi.
- **Gestione = parziale + BE + trailing** (già come la vuoi tu): il **fix gestione per-ticket** del 01/08 fa scattare parziale/BE su OGNI posizione → profitti più costanti, niente più +800→−700.
- Filosofia: **accontentarsi del bottino "normale"** (parziale/BE/trailing) per avere **profitti costanti**, senza inseguire i massimi.

---

## 3) 🧭 Come lavoriamo
- **Osservazione:** tutta la flotta accesa sul demo fino alla **quadra del mese** (per il dataset completo).
- **Pagella per-EA settimanale** (magic/commento) → a fine mese si decide EA per EA: edge / bug / rumore.
- **Prendersi il tempo.** Niente scorciatoie: si promuove un EA solo quando i numeri (tick reali + walk-forward + dry-run) lo confermano.

_Obiettivo realistico: NON 52 EA buoni, ma pochi robusti e poco correlati — anche 1 solo EA prop-grade è un successo._
