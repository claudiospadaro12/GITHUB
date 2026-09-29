# R246 inverno — la casella d+1 (R246m..r): armare ALLA CASH d'inverno

Round: `RIGA_R246_INVERNO` (pin 782d7280), girato il 29/09 17:41-17:47 sul PC di backtest, tick reali, deposito 100000, rischio 1 (come R246).
Archivio: `backtest_pipeline/risultati_archivio/ROUND_R246_INVERNO_2026-09-29/`. Giudizio riproducibile: `python3 backtest_pipeline/r246_giudizio_d1.py` (autotest incluso).
Criteri: quelli congelati in `prove/R246m` par. 5 e 5.1, `R246o`, `R246q`, PRIMA dei numeri.

## 1. Cancelli (prima dei numeri)
- **G1 determinismo**: PASS su tutti e 6 i file (gemelle identiche, anche al centesimo: a differenza del d0 di R246 dove Dow a/c erano NULLI per 1 centesimo).
- **G2 coerenza finestre**: IDENTICI su tutte e 3 le coppie (n-m, p-o, r-q), per entrambe le gemelle.
- **S1 sentinella dell'orologio**: DAX VERDE, MaxMin VERDE (GIALLO non scattato: 14 e 21 uscite), **Dow ROSSO**: 1 uscita su 112 dopo le 18:31 — `2026.05.25 23:05:00`, 15,9 lotti, -765,00.
  - Regola congelata: S1 ROSSA = round Dow **NULLO**. Non la riscrivo a numeri visti.
  - Diagnosi (descrittiva): 25/05/2026 e' un lunedi' di festa USA (Memorial Day); la posizione e' rimasta aperta oltre le 18:30 e chiusa alla riapertura. E' un giorno **d'estate**: fuori dalle misure d'inverno.
  - **Prova di invarianza**: togliendo quella posizione, PF, posizioni, Q2 e Qf2 d'inverno del Dow restano identici (0,916 / 40 / 0,951 / 2,087) su entrambe le gemelle. Quindi la lettura del Dow qui sotto e' **SOSPESA per regola, ma non dipende dal difetto**. Sbloccarla o no e' una firma di Claudio.

## 2. Numeri (feriali d'inverno A+B, posizioni = n; PF sui deal)
| EA | d0 inverno (arma 1h PRIMA della cash) | d+1 inverno (arma ALLA cash) | d0 estate (alla cash) |
|---|---|---|---|
| **DAX 770101** | PF 1,389 · 168 pos · 0,764/g | PF **1,184** · 138 pos · **0,627/g** | PF 1,108 · 0,662/g |
| **Dow 770202** (sospeso S1) | PF 1,492 · 68 pos · 0,378/g | PF **0,916** · 40 pos · **0,222/g** | PF 0,886 · 0,303/g |
| **MaxMin DAX short** | PF 2,558 · 16 pos · 0,073/g | PF **0,996** · 17 pos · 0,077/g | PF 1,450 · 0,046/g |

Verdetti (zone congelate 0,30 / 0,70):
- **DAX — FREQUENZA (decide): Qf2 = 1,35 → OROLOGIO** (1,29-1,39 al jackknife, 0 cambi). Posizioni 138 <= 151,5 (soglia OROLOGIO). PF non discriminante (classe 178): Q2 0,73 solo lettura.
- **Dow — SOSPESO (S1)**; lettura: Q2 0,95 e Qf2 2,09 → OROLOGIO; PF 0,916 contro soglia OROLOGIO <= 1,046. Jackknife: Q2 [0,58 ; 1,18], il verdetto cambia in 4 posizioni su 293.
- **MaxMin — FREQUENZA (indizio debole)**: Qf2 -0,17 → STAGIONE (17 pos >= 13,6). PF non discriminante: 0,996 scritto, non decide.

## 3. Cosa dicono i numeri e cosa NO
- **Stessa stagione, stessi giorni, solo l'ora cambia**: in tutti e tre i motori armare 1h prima della cash d'inverno da' PF piu' alto di armare alla cash (DAX 1,39 contro 1,18; Dow 1,49 contro 0,92; MaxMin 2,56 contro 1,00) e, per DAX e Dow, piu' frequenza. E' il confronto pulito che mancava.
- **Per FTMO d'inverno** (arma alla cash da fine ottobre / 02/11) la casella che descrive quello che faranno le sedie e' **d+1**, non i numeri di contratto: PF DAX ~1,18 (non 1,39), Dow ~0,92 su 40 posizioni, MaxMin ~1,0 su 17. Serie ricostruita come la vedrebbe FTMO (d0 estate UE + d+1 inverno UE, [INFERITA]): DAX PF 1,143 (295 pos, DD saldo 9,50%), MaxMin PF 1,187 (28 pos), Dow PF 0,836 (123 pos, DD saldo 5,74%, senza il verdetto).
- **n**: Dow 40 e MaxMin 17 sono sotto 150: merito SOSPESO (Emendamento B: il DD si legge sempre). DAX a 138 è sotto 150: indizio.
- **Residui dichiarati (R246m par. 5)**: sul Dow il PF e la frequenza misurano OROLOGIO + candela H4 insieme [quota NON MISURATA]; il rischio 2,00 e il Guardian su FTMO contro rischio 1 e Guardian spento qui, feed FTMO, correlazione MaxMin su SPXUSD: ogni conseguenza per FTMO resta [INFERITA].
- **NON dimostrato**: perche' l'arma pre-cash renda di piu' (la causa non e' isolata: potrebbe essere la finestra del range che include il preopen). E la differenza tra d0-inverno e d+1-inverno non e' un'indicazione da applicare da sola.

## 4. Cosa si firma / decide (di Claudio)
1. **Orologio delle sedie a ora fissa entro il 25/10** (gia' in coda): questo round aggiunge un dato — d'inverno FTMO alla cash rende meno di 1h prima. La misura diretta della cella "FTMO d'inverno arma 1h prima della cash" e' esattamente il **d0 inverno** di R246 (gia' misurato, sopra). Da firmare: se spostare l'ora d'inverno, e con che test in forward (una sedia per volta, mai il reale).
2. **Sblocco del Dow S1** (invarianza dimostrata): si', no, o rifacimento con S1 che escluda i festivi USA.

## 5. Non tocca
Nessun preset, nessuna taglia, nessuna sedia, nessun conto (FTMO 541452707, REALE 10105439, 50503392, 50504263, 50503635, 50504400). Sola lettura.
