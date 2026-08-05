# Trailing a base candela su DAX e Nasdaq — 05/08

**24 pass tick reali, M5, 2024.01 → 2026.06.** DAX 440 trade, Nasdaq 260 trade.
Gestione fissa: TP 1,5R, niente parziale, niente BE. DAX senza filtri, Nasdaq con volumi 1,5×.

## I numeri

### DAX (D30EUR, apertura 08:00 server)

| gestione | profit | PF | DD | Sharpe | R/trade |
|---|---:|---:|---:|---:|---:|
| **nuda** (riferimento) | −1.031,93 | 0,961 | **38,96%** | −1,11 | −0,0235 |
| trailing M1 | −801,30 | 0,883 | 13,83% | −5,00 | −0,0182 |
| trailing M2 | −1.302,23 | 0,853 | 17,84% | −5,00 | −0,0296 |
| trailing M3 | −589,23 | 0,947 | 18,85% | −2,23 | −0,0134 |
| trailing M4 | −339,08 | 0,973 | 18,14% | −1,12 | −0,0077 |
| **trailing M5** | **−78,78** | **0,994** | 19,74% | −0,24 | **−0,0018** |
| trailing M6 | −813,22 | 0,944 | 23,77% | −2,21 | −0,0185 |

### Nasdaq (NASUSD, apertura 14:30 server, volumi 1,5×)

| gestione | profit | PF | DD | Sharpe | R/trade |
|---|---:|---:|---:|---:|---:|
| **nuda** (riferimento) | −496,89 | 0,955 | 19,27% | −1,46 | −0,0191 |
| trailing M1 | −376,98 | 0,899 | **8,73%** | −5,00 | −0,0145 |
| **trailing M2** | **−177,26** | **0,965** | 10,84% | −1,61 | **−0,0068** |
| trailing M3 | −864,24 | 0,863 | 16,98% | −5,00 | −0,0332 |
| trailing M4 | −1.179,22 | 0,828 | 19,37% | −5,00 | −0,0454 |
| trailing M5 | −769,01 | 0,894 | 15,97% | −4,59 | −0,0296 |
| trailing M6 | −1.071,50 | 0,857 | 18,63% | −5,00 | −0,0412 |

## Tre conclusioni, in ordine di importanza

### 1. Nessuna combinazione è in profitto. Su nessuno dei due mercati.

24 combinazioni, 700 trade in tutto, **PF sempre sotto 1**. Il migliore in assoluto
(DAX, trailing M5) chiude a PF 0,994: non un sistema debole, un sistema **piatto**.
Con 440 e 260 trade non è rumore campionario.

Questo **conferma la FASE A** (3.500 trade, 8 indici): la rottura cieca del range
d'apertura ha aspettativa ~zero su 7 indici su 8. Il **Dow è l'eccezione**, non la regola,
e la sua validazione in walk-forward (40/40 combinazioni OOS in profitto) resta valida
proprio perché è stata fatta a parte.

### 2. Il trailing a base candela regge — ma come CONTROLLO DEL RISCHIO, non come edge.

Sul DAX taglia il drawdown da **38,96% a 19,74%** (a M1 addirittura 13,83%) e riduce la
perdita di 13 volte. Sul Nasdaq porta il DD da 19,27% a 8,73%. Su un sistema in profitto
questo varrebbe molto; su un sistema piatto sposta la perdita verso zero e basta.

### 3. Il TF del trailing NON è una proprietà generale. Ipotesi smentita.

Avevo scritto: *"se anche DAX e Nasdaq preferiscono M5 come il Dow, allora non è una
taratura per mercato ma una proprietà generale, e vale molto di più."*

**DAX → M5. Nasdaq → M2.** Due mercati, due ottimi diversi. È una taratura per mercato.
Il che vuol dire anche che va trattata con sospetto: un ottimo che cambia da strumento a
strumento su una curva non monotòna (Nasdaq: M1 −377, M2 −177, M3 −864) somiglia più a
un adattamento al rumore che a una proprietà del mercato.

## Una discrepanza da chiarire, non da nascondere

L'ablazione di inizio agosto dava il Nasdaq **con i volumi 1,5× a PF 1,15 su 152 trade**.
Qui, con i volumi accesi, sono **260 trade a PF 0,955**. Cambiano due cose: la gestione
(qui TP 1,5R + trailing) e il numero di trade. Prima di continuare a dare per buono il
filtro volumi sul Nasdaq va capito da dove viene la differenza.

## Cosa NON fare adesso

Continuare a limare la gestione su DAX e Nasdaq. La gestione è già stata portata al
meglio noto e il risultato è zero: **il problema è a monte, nell'ingresso**.

## Cosa fare

Nell'ordine, i due test già pronti:

1. `aperture_openconfirm.ps1` — 8 pass. La candela che **apre** oltre il livello contro
   l'ordine pendente che insegue la rottura.
2. `aperture_ingresso.ps1` — 40 pass. Durata del range (5/15/25/35/45) × buffer
   (100/300/500/700): i due numeri su cui poggia tutto il sistema delle aperture e che
   **non sono mai stati misurati**.
