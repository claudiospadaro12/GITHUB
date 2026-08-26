# 🏁 R110 — REFERTO DEL ROUND: I LATI MAI MISURATI DEI MOTORI VIVI SUGLI INDICI

_Corsa: 26/08/2026 17:17-18:34 (1,3 ore), tick reali, pin `4d6952f`,
driver `RIGA_R110_LATI_VIVI.ps1`. Esito driver: **COMPLETO CON RILIEVI,
0 guasti** — 12 celle su 12, gemelli IDENTICI su tutte e quattro le
famiglie, G0-A (antenato) OK ovunque, criteri FIRMATI NEL FILE (corsa
senza switch, come promesso dalla checklist 82). Firma di Claudio
"FIRMO R110" del 25/08 sulle sei decisioni del § 10. Zip agli atti:
`R110_LATI_VIVI_CORSA_20260826_1717.zip`._

_Finestra 2024.09.26→2026.06.30, split 40/60 (le stesse di R107: è
l'unico modo di leggerli accanto). Rischio 1% nei file prova: **ogni DD
qui sotto va ×0,65 per confrontarlo col forward del 100k**. G0-B NON
APPLICABILE su tutte e quattro le famiglie (dichiarato, non "superato"):
i numeri R103 sono contesto di un altro banco (OHLC vs tick reali).
PeggGio% n/d PER COSTRUZIONE su tutto il round (D6/G4-bis): il rischio
si legge su DD equity e dDD contro il metro._

## 📊 LA TABELLA MADRE (OOS, tick reali; dPF/dDD = delta contro la sedia viva)

| FAM | cella | OOS prof | OOS PF | OOS DD | n OOS | dPF | dDD |
|---|---|---:|---:|---:|---:|---:|---:|
| SUPNAS | metro | +3.627 | 1,581 | 1,29 | 96 | — | — |
| SUPNAS | long | +1.928 | 1,448 | 1,62 | 62 | −0,13 | +0,33 |
| SUPNAS | **short** | +1.664 | **1,870** | 0,93 | 34 | +0,29 | −0,36 |
| SUPDAX | metro | +2.646 | 1,432 | 4,04 | 65 | — | — |
| SUPDAX | long | +1.719 | 1,589 | 2,12 | 36 | +0,16 | −1,92 |
| SUPDAX | short | +947 | 1,290 | 3,60 | **29** | −0,14 | −0,44 |
| SWDOW | metro | +3.455 | 1,220 | 4,21 | 184 | — | — |
| SWDOW | **long** | +10.369 | **3,280** | 2,14 | 100 | +2,06 | −2,07 |
| SWDOW | **short** | **−6.090** | **0,429** | 7,53 | 84 | −0,79 | +3,32 |
| EMADOW | metro | +23.321 | 1,524 | 7,83 | 517 | — | — |
| EMADOW | long | +5.671 | 1,241 | 8,90 | 241 | −0,28 | +1,07 |
| EMADOW | **short** | **+16.948** | **1,891** | **2,66** | **302** | +0,37 | **−5,17** |

(IS nel referto driver agli atti. La somma dei lati NON fa il metro,
per costruzione del motore — § 1.1 dei criteri, misurato nel sorgente.)

## ⚖️ I CANCELLI, APPLICATI A MANO

**G1 (n OOS ≥ 30):** 7 celle dei lati su 8 misurabili. **SUPDAX short
n 29 → NON MISURABILE** (esito atteso dai criteri per l'H4; "non
misurabile" ≠ "non funziona").

**G2 (PF OOS ≥ 1,10 E IS positivo):** lo passano SUPNAS long e short,
SUPDAX long, SWDOW long, EMADOW long e short. **Lo fallisce SWDOW
short** (OOS 0,429, IS positivo 1,446 — vedi spina dorsale).

**G4 (Emendamento: ≥150 op per il MERITO):** il giudizio di merito
pieno esiste **solo su EMADOW** (long 241, short 302 — come previsto
dai criteri: l'unico posto del parco dove un lato da solo ci arriva).
SUPNAS, SUPDAX, SWDOW: merito **SOSPESO per regola**, producono indizi.
Il RISCHIO si giudica sempre (regola B), e i DD sono nella tabella.

**G3 (coerenza cross-motore, il cancello anti-rumore):** il lato short
NON è un picco isolato ma NEMMENO un quadro unanime: **verde pieno su
EMADOW** (1,891, n 302), **verde-indizio su SUPNAS** (1,870, n 34),
**rosso su SWDOW** (0,429, n 84), **non misurabile su SUPDAX**. Due
logiche sullo stesso mercato (Dow) danno verdetti OPPOSTI — e la
spiegazione candidata è meccanica, non statistica: vedi sotto.

## 🥇 IL TITOLO DEL ROUND — EMADOW SHORT: LA PRIMA CELLA "PIENA" DEI LATI, ED È CANDIDATA

**EMA200 Dow, solo short: PF OOS 1,891 su 302 operazioni, IS positivo
(1,232, n 125), DD OOS 2,66% contro il 7,83% della sedia intera
(−5,17 punti). Passa G1, G2 e G4 per intero.** Al rischio di campo
(×0,65): DD ~1,7% contro ~5,1% della sedia. E il long da solo (1,241,
n 241, DD 8,90%) è il fratello DEBOLE: **su questa finestra quasi tutto
l'edge dell'EMA200 Dow sta nel lato corto — con un quinto del drawdown.**

⚠️ **Cosa NON segue da qui (G5 + R52):** la sedia 771531 NON si tocca.
"EMADOW potrebbe essere short-only (o a pesi diversi)" è una **proposta
di modifica di contratto = un round successivo con la sua firma**, che
dovrà applicare il cancello di portafoglio (più profitto OOS **e** DD
non peggiore) e reggere G3. Questo referto consegna la misura, non il
cambio.

## 🦴 LA SPINA DORSALE — perché SWDOW short rosso NON contraddice EMADOW short verde

Fatto di calendario (pre-dichiarato § 4.2): la discesa documentata della
finestra (feb-apr 2025) sta **nell'IS**; l'OOS è quasi tutto salita.

- **SWDOW short: IS verde (1,446) → OOS rosso (0,429).** Il pattern di
  R107 NAS short (IS 3,22 → OOS 0,46), di nuovo: **[INFERITO] l'edge di
  questi short vive nelle discese**, e l'OOS non ne contiene di simili.
  Terza occorrenza dello stesso disegno nell'archivio.
- **EMADOW short: verde in IS E in OOS (1,232 → 1,891).** È l'eccezione
  che pesa: **guadagna sul lato corto anche in un'epoca che sale.**
  Differenza meccanica candidata **[INFERITO]**: l'EMA200 apre short
  solo sotto la media — dentro le correzioni locali — mentre SuperWave
  flippa short anche in trend su. La misura vera dei sotto-periodi non
  è di questo round: è la **prova di regime**, che da stasera ha i dati
  (NASUSD_EXT ammesso; per il Dow non ancora).

## 🎯 LA RISPOSTA ALLA DOMANDA DI CLAUDIO ("Nasdaq e DAX short?")

- **Nasdaq**: il lato short di SupRev NAS è **verde anche in OOS**
  (1,870, DD sotto quello del long) — ma n 34: **indizio, merito
  sospeso**. Insieme a R107 (apertura short: morto in OOS) dice: sul
  NAS lo short "vive" solo dentro un motore di rimbalzo, non di
  rottura — da verificare in prova di regime sui 16 anni.
- **DAX**: H4 short **non misurabile** (n 29) su questa finestra; il
  DAX short di apertura era già NO EDGE misurato (R107). **La domanda
  DAX short resta aperta e senza motore candidato.**
- **Dow**: la risposta più netta del round — **short sì, ma dentro
  l'EMA200** (candidata piena), **short no dentro SuperWave** (rosso,
  DD +3,32 sul metro).

## 📌 A REGISTRO

- Magic 763xxx bruciati (12 celle × 2 gemelli).
- I 17 rilievi del driver sono risultati, non guasti; 0 problemi.
- I cinque motori simmetrici mai smontati del censimento (PTE Dow,
  PunteLarry, GapFill, SuperWave H2, SupRev Nikkei) restano **NON
  MISURATI** — il § 5 del censimento li tiene in coda.
- La finestra è UN regime (21 mesi in salita): ogni verdetto short vale
  **per questa epoca**. La prova di regime NASUSD_EXT (sbloccata oggi)
  è il seguito naturale per SUPNAS short; per EMADOW short serve prima
  il Dow lungo (Dukascopy/Pepperstone, decisione aperta).
- Costo del round: 1,3 ore di tester per dare un numero a 8 lati che
  giravano sui soldi senza averne mai avuto uno.
