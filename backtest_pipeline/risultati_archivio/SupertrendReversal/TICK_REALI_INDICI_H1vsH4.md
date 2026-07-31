# SupertrendReversal a TICK REALI — indici, H1 vs H4

_Validazione tick reali sui 4 indici principali. PFmed = mediana delle combo; PFbest = miglior pass; % combo positive = quota di parametrizzazioni redditizie (robustezza)._
_Fonte: `../supertrend_indici_validazione/` e `../SupRev_nuovi_indici/` (D30EUR=DAX, U30USD=Dow, NASUSD=Nasdaq, F40EUR=CAC)._

| Caso | PFmed | PFbest | DD best% | % combo positive | Giudizio |
|---|---|---|---|---|---|
| **Nasdaq H1** | 1,40 | 1,57 | **1,17** | **100%** | ⭐ eccellente |
| **Dow H4** | 1,77 | 2,77 | 4,00 | 75% | forte (vedi nota) |
| **DAX H4** | 1,31 | 1,96 | 5,74 | 75% | buono |
| Dow H1 | 1,07 | 1,20 | 9,77 | 75% | rischioso (DD ~10%) |
| DAX H1 | 1,05 | 1,45 | 5,57 | 50% | marginale |
| CAC H4 | 0,96 | 1,79 | 3,48 | 50% | scarta |

## 🔑 Verdetti per indice (H1 vs H4 a tick reali)
- **Nasdaq → H1** è il migliore in assoluto: PFmed 1,40, **100% delle combo positive**, DD bassissimo (1,17%). Robusto, non overfit. ⭐ ottimo prop.
  - ⚡ **Il TF sblocca il simbolo**: a **H4 il Nasdaq era spazzatura (PF 0,68)**; a **H1 diventa un candidato prop serio**. È il valore della matrice motore×TF: lo stesso simbolo passa da scarto a top solo cambiando timeframe. Nasdaq H1 chiude in giornata (come voluto) e diversifica bene con l'Oro (metallo, H4).
- **Dow → H4** nettamente meglio di H1 (PFbest 2,77 vs 1,20; H1 ha DD ~10% = rischioso).
- **DAX → H4** meglio di H1 (1,96 vs 1,45; H1 solo 50% combo positive = marginale).
- **CAC → SCARTARE**: a tick reali PFmed 0,96 e solo 50% combo positive. Solo il best pass (1,79) regge, la mediana è sotto 1.

## ✅ DOW — RICONFERMATO: SCARTATO (contraddizione risolta)
La contraddizione è **risolta** dalla revalidation pulita a tick reali (metodo PFmed su 6 indici, vedi `../../PROMEMORIA_APERTURE.md`):
**Dow (U30USD) H4 PFmed reale 0,79 → CROLLA sotto 1.** Era un'**illusione dell'OHLC** (PFmed OHLC 1,26): lo spread ottimistico dell'OHLC lo gonfiava, ai fill veri l'edge sparisce. Stesso destino di **ASX (200AUD): 0,78 → CROLLA**.
→ **Dow SCARTATO** e tolto dalla terna del Multi. (Il vecchio "1,77" di un run sporco è superato.)

## ⚠️ LEZIONE CHIAVE — overfit CAC (OHLC vs tick reali)
Lo scan **OHLC H4 dava CAC (F40EUR) a PF 7,37** — il migliore in assoluto. A **tick reali crolla a PFmed 0,96 → "scarta"**. È la prova provata del perché la validazione tick reali è obbligatoria: **l'OHLC aveva enormemente sovrastimato il CAC**. Il PFbest 1,79 è l'unico pass sopravvissuto (= `SupRev_CAC_H4_Ottimizzato` già in classifica), ma la strategia sul CAC è fragile.

## ✅ Verdetto tick reali DEFINITIVO — 6 indici (metodo PFmed robusto)
_Fonte autorevole: revalidation pulita in `../../PROMEMORIA_APERTURE.md`._

| Simbolo | PFmed reale | PFmed OHLC | DD% | Trade | Esito |
|---|---|---|---|---|---|
| Oro (XAUUSD) H4 | 1,46 | 1,59 | 1,19 | 44 | ✅ REGGE ⭐ |
| Argento (XAGUSD) H4 | 1,37 | 1,39 | 2,56 | 27 | ✅ REGGE |
| DAX (D30EUR) H4 | 1,05 | 1,06 | 2,09 | 50 | ✅ regge (marginale) |
| Nikkei (225JPY) H4 | 1,05 | 1,17 | 0,14 | 21 | ✅ regge (poco attivo) |
| **Dow (U30USD) H4** | **0,79** | 1,26 | 3,33 | 56 | ❌ CROLLA (illusione OHLC) |
| **ASX (200AUD) H4** | **0,78** | 1,01 | 1,60 | 42 | ❌ CROLLA |

**+ Nasdaq (NASUSD) H1 = 1,40 (DD 1,2%, 100% combo) ⭐** — il TF sblocca il simbolo (a H4 era 0,68).

## ❌ Ancora da validare a tick reali
- **IBEX (E35EUR) H1** — è uno dei **4 vincitori** ma **manca** la validazione tick reali in archivio → **da lanciare** (priorità: completa i 4 vincitori indici).
- Top scan OHLC non-indici: **XAUUSD H4** (7.37 OHLC⚠️→ da verificare), **CHFJPY H4**, **GBPJPY H4**, **AUDUSD H4**, **EURJPY H1**.
- _Attenzione: dopo il caso CAC, aspettarsi che alcuni PF alti OHLC si ridimensionino a tick reali._

## 🎯 Sintesi finale SupertrendReversal (per la prop)
- **In forward (5 cavalli)**: **Oro** H4, **Argento** H4, **DAX** H4, **Nikkei** H4 + **Nasdaq H1** ⭐. Preset robusti già creati e caricati.
- **Scarta**: **Dow** e **ASX** (crollano a tick reali, illusione OHLC), **CAC** (overfit, mediana <1), tutti gli **H1 degli indici europei** (marginali).
- **Terna Multi diversificata**: Oro (metallo) + Nikkei (indice, poco correlato, DD 0,14%) + un 2° indice — **NON Dow** (scartato).
- **Da validare**: **IBEX E35EUR H1** (4° vincitore mancante).
