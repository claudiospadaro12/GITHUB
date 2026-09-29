# R246 inverno — la casella d+1 (R246m..r): armare ALLA CASH d'inverno

Round: `RIGA_R246_INVERNO` (pin 782d7280), girato il 29/09 17:41-17:47 sul PC di backtest, tick reali, deposito 100000, rischio 1 (come R246).
Archivio: `backtest_pipeline/risultati_archivio/ROUND_R246_INVERNO_2026-09-29/`. Giudizio riproducibile: `python3 backtest_pipeline/r246_giudizio_d1.py` (contro-esempi: `--autotest`). **Tutti** i numeri qui sotto, Dow compreso, escono da quel comando; quelli delle celle -1h d'estate (PF 0,774 / 1,038, DD 14,05% / 5,55%) da `python3 backtest_pipeline/r246_giudizio.py`.
Criteri: quelli congelati in `prove/R246m` par. 4, 5 e 5.1, `R246o`, `R246q`, PRIMA dei numeri.
Corretto dal cancello strato 2 (29/09): Dow sospeso anche dal G1 di R246a/c, lettura congiunta del par. 5.1, bande X2/Y2, confronto con l'estate di R246, DD della serie FTMO contro il contratto (classe 919).

## 1. Cancelli (prima dei numeri)
- **G1 determinismo**: PASS su tutti e 6 i file (gemelle identiche al centesimo).
- **G2 coerenza finestre**: IDENTICI su tutte e 3 le coppie (n-m, p-o, r-q), per entrambe le gemelle.
- **S1 sentinella dell'orologio**: DAX VERDE, MaxMin VERDE (GIALLO non scattato: 14 e 21 uscite), **Dow ROSSO**: 1 uscita su 112 dopo le 18:31 — `2026.05.25 23:05:00`, posizione 188, 15,9 lotti, -765,00 (R246m, tutte e due le gemelle). La manopola morde lo stesso: 0 uscite su 177 prima delle 16:05.
  - Regola congelata (R246a par. 5): S1 fallita = round Dow **NULLO**. Non la riscrivo a numeri visti.
  - Diagnosi: 25/05/2026 e' il lunedi' di Memorial Day (festa USA), un giorno **d'estate** (fuori dalle misure d'inverno). Che la chiusura delle 18:30 sia fallita per la pausa festiva del future USA e sia avvenuta alla riapertura (23:05) e' **[INFERITA]**: l'orario coincide con il calendario festivo CME, ma l'orario di sessione BCM di quel giorno non e' in repo. Il d0 quel giorno e' uscito alle 17:25 (prima della pausa).
  - **Prova di invarianza** (stampata dallo script): togliendo la posizione 188, PF, posizioni, Q2 e Qf2 d'inverno del Dow restano identici (0,916 / 40 / 0,951 / 2,087) su entrambe le gemelle.
  - 🔴 **E il Dow e' sospeso una SECONDA volta, per un'altra ragione**: Q2 e Qf2 usano come riferimenti le d0 di R246 (R246a, R246c), che sono **NULLE per G1** (il centesimo del 30/09/2024, `REFERTO_R246_2026-09-24.md` §1). Quel G1 e' **ancora aperto** (strade a/b/c di `REFERTO_R246` §1.5, `IL_MERITO_E_D_INVERNO` punto 5). Invarianza: con la gemella m+50 Q2 0,951195 contro 0,951196, Qf2 identico, stesse zone.

## 2. Numeri (feriali d'inverno A+B, posizioni = n; PF sui deal)
| EA | d0 inverno (arma 1h PRIMA della cash) | d+1 inverno (arma ALLA cash) | d0 estate (alla cash) |
|---|---|---|---|
| **DAX 770101** | PF 1,389 · 168 pos · 0,764/g | PF **1,184** · 138 pos · **0,627/g** | PF 1,108 · 157 pos · 0,662/g |
| **Dow 770202** (SOSPESO: S1 + G1 dei riferimenti) | PF 1,492 · 68 pos · 0,378/g | PF **0,916** · 40 pos · **0,222/g** | PF 0,886 · 84 pos · 0,303/g |
| **MaxMin DAX short** | PF 2,558 · 16 pos · 0,073/g | PF **0,996** · 17 pos · 0,077/g | PF 1,450 · 11 pos · 0,046/g |

Verdetti (zone congelate 0,30 / 0,70):
- **DAX — FREQUENZA (decide): Qf2 = 1,35 → OROLOGIO** (1,29-1,39 al jackknife, 0 cambi su 624). Posizioni 138 <= 151,5 (soglia OROLOGIO) e **dentro la banda H_OROLOGIO** [133,6 ; 151,7]. PF non discriminante (classe 178): Q2 0,73 solo lettura (1,184 cade dentro tutte e due le bande).
- **Dow — SOSPESO (S1 + G1 dei riferimenti)**; lettura, **"orologio + candela H4"** come il par. 5.1 impone per qualunque zona: Q2 0,95 → OROLOGIO (PF 0,916 dentro la sola banda H_OROLOGIO; soglia OROLOGIO <= 1,046), **fragile**: al jackknife Q2 [0,58 ; 1,18], cambia zona in 4 posizioni su 293. Qf2 2,09 → OROLOGIO per la regola, ma **40 posizioni stanno SOTTO tutte e due le bande** (H_OROLOGIO [48,5 ; 64,4]): la frequenza d'inverno alla cash e' scesa sotto anche quella estiva (0,222 contro 0,303/g), cosa che **nessuna delle due ipotesi prevede**. Candidato: la candela H4 che fa da cancello del giorno (R246m par. 1.4) — **[NON MISURATO]**.
- **MaxMin — FREQUENZA (indizio debole): Qf2 -0,17 → STAGIONE** (17 pos >= 13,6, dentro la banda H_STAGIONE [11,1 ; 20,9]). PF: R246q *"non si legge per nessuna decisione"*.

**Lettura congiunta con R246 (par. 5.1, congelata)**:
- **Dow PF: Q estate 0,251 STAGIONE + Q2 inverno 0,951 OROLOGIO → INTERAZIONE** (tutte e due sospese): l'effetto dell'orologio NON e' lo stesso d'estate e d'inverno. Il par. 5.1 dice che sul Dow un'INTERAZIONE *"puo' venire dalla candela e non dalla stagione"*.
- Frequenza (il 5.1 e' scritto per Q/Q2: qui per analogia, lettura): DAX OROLOGIO in tutte e due le stagioni (Qf 1,13 + Qf2 1,35); Dow idem (sospeso); MaxMin STAGIONE in tutte e due (Qf -0,64 + Qf2 -0,17).

## 3. Cosa dicono i numeri e cosa NO
- **Stessa stagione, stessi giorni, solo l'orologio cambia** (d0 inverno contro d+1 inverno): d'inverno la cella 1h prima della cash ha reso piu' della cella alla cash — DAX PF 1,39 contro 1,18 e 0,764 contro 0,627 pos/g. E' la casella che mancava ed e' pulita sul DAX. **Non** lo e' sul Dow (cambia anche la candela H4, e il Dow e' sospeso: 1,49 contro 0,92 si scrive, non decide) ne' sul MaxMin (16 contro 17 posizioni, PF non letto per R246q).
- 🔴 **E NON e' un "armare prima rende di piu'" valido tutto l'anno**: d'estate R246 ha misurato l'opposto sul DAX — la cella 1h prima della cash ha fatto **PF 0,774 contro 1,108** della cella alla cash, con DD saldo **14,05% contro 5,55%** (`REFERTO_R246` §5.2). Sul Dow d'estate 1,038 contro 0,886, dentro la banda H_STAGIONE. Il vantaggio del pre-cash sta nei due inverni misurati, non nell'orologio in se'.
- **Per FTMO d'inverno** (arma alla cash dal 26/10 DAX e MaxMin, dal 02/11 Dow) la casella piu' vicina a quello che faranno le sedie e' **d+1**, non i numeri di contratto — **[INFERITA]**: feed BCM, rischio 1 contro 2,00, Guardian spento, correlazione MaxMin su SPXUSD, e sul Dow la candela H4 (R246m par. 1.4). Sul feed BCM: DAX PF ~1,18 (non 1,39), Dow ~0,92 su 40 posizioni (sospeso), MaxMin ~1,0 su 17.
- **Serie ricostruita come la vedrebbe FTMO** (d0 estate UE + d+1 inverno UE, calendario UE, 457 feriali, [INFERITA]): DAX PF 1,143 (295 pos), MaxMin PF 1,187 (28 pos), Dow PF 0,836 (123 pos, sospeso).
- 🔴 **Rischio (Emendamento B, si legge a qualunque n)**: il DD saldo della serie "come FTMO" e' **piu' alto** di quello del d0 tutto l'anno, stesso metodo, stessa finestra A+B, rischio 1: **DAX 9,50% contro 6,06%**, Dow 5,74% contro 4,65%, MaxMin 5,40% contro 2,00%. Sul DAX il DD va dal picco del 05/03/2026 al fondo del 13/05/2026, per meta' dai giorni d+1 di marzo (-5.625,94) e per meta' dai d0 d'estate (-5.280,54). A rischio 2,00 e col Guardian acceso su FTMO la cifra **non si deriva** da questa. DD della sola d+1 d'inverno: DAX 5,40%, Dow 2,69%, MaxMin 4,67%.
- **n**: Dow 40 e MaxMin 17 sono sotto 150: merito SOSPESO. Anche il DAX a 138 e' sotto 150: indizio.
- **NON dimostrato**: perche' d'inverno la cella pre-cash renda di piu' (la causa non e' isolata, e d'estate sul DAX va al contrario); quanto del Dow e' candela H4 (quota [NON MISURATA]). La differenza tra d0 inverno e d+1 inverno non e' un'indicazione da applicare da sola.

## 4. Cosa si firma / decide (di Claudio)
1. **Orologio delle sedie a ora fissa entro il 25/10** (gia' in coda). Questo round aggiunge un dato: sul feed BCM, d'inverno, la cella alla cash (quella che FTMO fara' senza interventi) ha reso meno di quella 1h prima, e la serie "come FTMO" ha un DD piu' alto del contratto. La cella "FTMO d'inverno con l'ora spostata di -1h" su feed BCM e' il **d0 inverno** di R246 (gia' misurato, sopra) — **[INFERITA]** per FTMO, ai residui: feed, spread, rischio 2,00, Guardian, e sul Dow una candela H4 diversa (FTMO leggerebbe 11-15 BCM, il d0 legge 08-12 BCM). Da sapere prima di firmare: d'estate il pre-cash sul DAX ha perso (PF 0,774). Decisione tutta di Claudio: se spostare l'ora d'inverno, e con quale prova in forward (una sedia alla volta, mai il reale).
2. **Il Dow**: lo sblocco dell'**S1** e' **FIRMATO** (`report/FIRME_2026-09-29.md` F1, commit 51f24302). Resta **aperto il G1 di R246a/c**, cioe' i riferimenti su cui Q2 e Qf2 poggiano: finche' non si decide quello (strade a/b/c di `REFERTO_R246` §1.5) la lettura del Dow resta **sospesa**. Nota per chi rilegge F1: la sua riga "Effetto" (*"verdetto OROLOGIO sia PF sia frequenza"*) va letta insieme a questo e al par. 5.1: sul PF la lettura congiunta e' **INTERAZIONE**, fragile, e scritta "orologio + candela H4".

## 5. Non tocca
Nessun preset, nessuna taglia, nessuna sedia, nessun conto (FTMO 541452707, REALE 10105439, 50503392, 50504263, 50503635, 50504400). Sola lettura.
