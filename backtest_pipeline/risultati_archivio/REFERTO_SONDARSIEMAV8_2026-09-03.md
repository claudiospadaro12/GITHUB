# 🧪 SONDA RSI+EMA V8 — PASSO 0, verdetto della corsa del 03/09/2026

Corsa: 03/09 08:26 (pin `0f01962`), 7 corse × 2 passate, Modello 2 open
prices, finestra 2024.09.26→2026.06.30, zip `SONDARSIEMAV8_CORSA_20260903_0826`.
Giro a vuoto: PROBLEMI 0. Collaudi corsa: autotest 0/16 su 7/7, ambiguita' 0,
PuntoIdx 1,000 su 7/7 (oro compreso), determinismo 2 passate IDENTICO 7/7.

## ⚡ IL VERDETTO IN QUATTRO RIGHE
**NON PROMOSSO. Il verdetto di carta del 31/08 e' CONFERMATO DA UNA MISURA:
l'ablazione mostra che il filtro RSI toglie solo il 9-13% degli incroci EMA.
Il V8 e', nei numeri, un incrocio EMA(5/20) — famiglia SuperWave/ChaosLyapunov,
gia' morta due volte in casa.** Niente EA, niente griglie (seconda caccia).

## 1. F1 (frequenza): passata OVUNQUE, e non era in dubbio
2,0-6,6 segnali/giorno PER LATO su tutte e 7 le corse (M5 ~6,5-6,6; M15
~2,0-2,3; oro M15 2,23/2,30). L'osservazione di Claudio ("segnali frequenti")
era giusta. La frequenza non e' mai stata il problema di questo motore.

## 2. 🔬 L'ABLAZIONE — la domanda della scheda 31/08, risposta coi conteggi
| corsa | NUDO (soli incroci EMA) | SEGNALI VERI | il filtro toglie |
|---|---:|---:|---:|
| U30_M5 | 3674/3673 | 3291/3300 | **~10%** |
| U30_M15 | 1200/1200 | 1079/1096 | **~10%** |
| NAS_M5 | 3666/3665 | 3250/3274 | **~11%** |
| NAS_M15 | 1105/1105 | 1001/1002 | **~9%** |
| DAX_M5 | 3631/3630 | 3255/3245 | **~10%** |
| DAX_M15 | 1155/1155 | 1021/1033 | **~12%** |
| ORO_M15 | 1286/1287 | 1119/1152 | **~13%** |

Pending RSI armato su ~32% delle barre. **Il filtro non filtra: 9 incroci EMA
su 10 passano.** E' la clausola scritta nel referto stesso: "se SEGNALI ~ NUDO
il verdetto di carta risulterebbe CONFERMATO DA UNA MISURA". Confermato.
I conteggi NON sono toccati dal difetto di misura del punto 4.

## 3. Geometria (INDICAZIONE, limiti superiori dichiarati): moneta lanciata
MFE mediana ≈ MAE mediana ovunque; RR 0,92-1,17; win rate necessario 50-56%.
Sull'oro: MFE med 7,8-8,0 USD contro ATR mediano 5,67 — appena sopra la
fascia sospesa 5-7. Nessuna asimmetria da cui un edge possa nascere per
geometria. E il muro F4: a taglia di flotta 0,65% i segnali M5 varrebbero
19,5% di rischio aperto/giorno (M15: 8,45%) contro il cap C1 di 3,25% —
come EA di flotta sarebbe insostenibile anche VOLENDO prenderli tutti.

## 4. ⚠️ PROBLEMI 7 (dichiarati): le ESCURSIONI non sono certificate
Invariante V8 violato su tutte le corse: ~1-1,5% dei segnali ha MFE/MAE non
positive in modo 1 ("la finestra di misura non parte dove dovrebbe") — un
difetto DELLA SONDA, trovato dalla sonda. Le mediane MFE/MAE/RR vanno
lette come indicazione non certificata. **Il verdetto NON poggia su di
loro**: poggia sull'ablazione (conteggi, robusti) + famiglia gia' morta.
Se mai servisse certificare le escursioni si corregge la sonda e si rigira
(20 min); oggi non serve: nessun cancello di merito la richiede.
RILIEVI: barre saltate 66-292 (buchi minori di storico, dichiarati);
7 CSV *_OOS degeneri presenti come reperto, non letti.

## 5. Cosa resta in piedi
- **L'esperimento MANUALE di Claudio non e' toccato**: misura "Claudio col
  V8" (contesto + uscita HA + giudizio), non il V8 nudo. Il diario continua.
- Il segnale V8 come SVEGLIA sul telefono resta legittimo: dice "guarda il
  grafico", non "entra".
- NIENTE seconda griglia sul motore (regola della seconda caccia): la
  missione frequenza continua su LondonFx (in canna), RELATIVO e VGRSI
  (promossi della 4a battuta).
