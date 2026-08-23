# R100 — REFERTO: la flotta oro sui 22 anni. TRE SEDIE IN REVISIONE (corsia rischio).

**Data verdetto: 23/08/2026. Corsa OHLC M1 (limite inferiore del rischio,
mai un permesso), pin `adbc27c`, zip `R100_ORO_FLOTTA_CORSA_20260823_1449`,
durata 36 minuti, 11 sedie misurate su 12 (S10 fermata dal gate: EA troppo
giovane, prima operazione 2025 — dichiarata, non misurabile su questa
finestra; S12 finestra ACCORCIATA dichiarata, parte dal 2008). Criteri:
estensione invariata di R99, firmata da Claudio.**

## LA TABELLA MADRE (rischio 1,00% — GRUPPO 1 = taglia viva misurata; GRUPPO 2 = taglia di riferimento, DD-per-1%)

| sedia | TF | DD promesso | **DD 22 anni** | 2x? | peggior giorno | verdetto |
|---|---|---:|---:|---|---:|---|
| **EMA200_Ottimizzato** (971501) | H4 | 4,40% | **45,91%** | **SI (10,4x)** | −1,91% | 🔴 **REVISIONE** |
| **MaxMinNotte** (770402) | H2 | 5,30% | **19,72%** | **SI (3,7x)** | −1,07% | 🔴 **REVISIONE** |
| **PunteLarry** (772343) | H1 | 3,50% | **29,74%** | **SI (8,5x)** | −3,91% | 🔴 **REVISIONE** |
| SupRev_Multi_Ott | H4 | n/d | 16,90 | n/d | −1,85% | 🟡 senza metro |
| GoldenCross_Ott | H1 | n/d | 25,18 | n/d | −1,96% | 🟡 senza metro |
| SupertrendReversal | H4 | n/d | **2,18** | n/d | −0,54% | 🟡 senza metro |
| SupRev_Multi | H4 | n/d | 7,36 | n/d | −1,60% | 🟡 senza metro |
| EMA200 (base) | H4 | n/d | **55,02** | n/d | −2,36% | 🟡 senza metro |
| GoldenCross | H1 | n/d | 22,34 | n/d | −1,95% | 🟡 senza metro |
| SupertrendInvert | H1 | — | — | — | — | ⛔ non misurata (gate: EA del 2025) |
| PTE | H4 | n/d | 24,22 | n/d | −1,24% | 🟡 senza metro |
| WOL | D1 | n/d | 1,17 (finestra ACCORCIATA dal 2008) | n/d | −0,06% | 🟡 senza metro |
| _SupRev_Ottimizzato (R99)_ | H4 | 9,0 (riempito) | 9,02 | no | −0,68% | ✅ dentro |

(+ Gold_Ichimoku: NON MISURABILE per costruzione — l'EA non esporta risultati.)

## La decisione MECCANICA, come firmata: TRE REVISIONI
Il criterio firmato dice: DD lungo > 2x il promesso -> REVISIONE, corsia
RISCHIO del 18/08, senza altre discussioni. E' scattato su TUTTE E TRE le
sedie che un contratto numerico ce l'avevano:
- **EMA200_Ott: promesso 4,4%, misurato 45,9% — DIECI VOLTE oltre.**
- PunteLarry: 8,5x oltre. MaxMinNotte: 3,7x oltre.
La revisione e' di Claudio: il round segnala, non spegne.

## La lettura onesta, nelle due direzioni
**Contro il panico:** il DD dei 22 anni e' il rischio di TENERE la sedia
per sempre a quella taglia. Le finestre di regime (10 mesi-1 anno) stanno
quasi tutte sotto il 5-9%, e le peggiori giornate sono TUTTE dentro il
muro prop del 5% (la peggiore: PunteLarry −3,91%). Su un orizzonte da
challenge (settimane), nessuna di queste sedie e' una bomba a orologeria
imminente.
**Contro l'autoassoluzione:** i contratti promettevano 3,5-5,3% come
rischio della sedia, e il rischio vero di lungo periodo e' 20-46%. **I
numeri promessi erano finestra-corta spacciata per rischio della sedia** —
l'errore che l'Emendamento B esiste per impedire. E in piu': 9 sedie
girano SENZA nessun contratto di rischio, e la concentrazione (12 grafici
sull'oro) somma esposizioni che nessuno ha mai misurato INSIEME.

## Cosa propone il round (decisioni di Claudio, in ordine)
1. **Le 3 revisioni**: per ciascuna — o si RISCRIVE il contratto col
   numero dei 22 anni (accettando che a quella taglia il lungo periodo
   vale 20-46%), o si RIDUCE la taglia, o si SPEGNE. Nessuna va portata
   in prop alla taglia attuale con questi numeri.
2. **Il round di PORTAFOGLIO oro** (la domanda successiva ovvia, ora
   urgente): 12 sedie sullo stesso simbolo — il DD COMBINATO non e' la
   somma ne' il massimo, va misurato dai per-trade sovrapposti.
3. **Censimento .chr nuovo del VPS** per dare una taglia vera alle 9
   sedie del GRUPPO 2 (oggi: DD-per-1%, riscalabile ma senza verdetto).
4. Nota positiva da non perdere: **SupertrendReversal base (2,18%) e la
   gemella Ottimizzato di R99 (9,02%)** sono le sedie oro col lungo
   periodo piu' pulito — la famiglia Supertrend regge la storia meglio
   di tutte.

## Igiene di corsa
Parser del criterio B: ha funzionato su tutte le 11 sedie (colonne
riconosciute, netto = Profitto+Commissioni+Swap). Magic 78xxxx vergini,
gate dei gemelli passato ovunque, S11 compilata con 1 warning (in zip).
ESITO tecnico: PARZIALE (S10 fermata dal gate — legittimo, dichiarato).
