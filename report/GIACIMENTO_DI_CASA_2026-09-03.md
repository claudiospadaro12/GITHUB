# 🏺 GIACIMENTO DI CASA — censimento EA/sonde mai portati a verdetto
_Fronte C, quinta battuta caccia-frequenza — 03/09/2026 — branch `lavoro`.
Censimento eseguito da un agente di sola lettura (Explore, very thorough) e
trascritto dalla sessione principale; correzione della sessione segnalata
con [SESSIONE]._

## 0. 🔴 LA TESI DELLA 4ª BATTUTA È FALSIFICATA

La tesi diceva: *"ABTG_VwapRevert, ABTG_OutOfNoise, Sonda dell'Orologio,
ABTG_AllineaLondra: scritti e MAI girati"* — presentandoli come giacimento di
classe 4 (costruiti, senza riga, senza verdetto). **Nessuno dei quattro è di
classe 4**, verificato per assenza/presenza di artefatti:

| nome | ha una RIGA? | ha girato? | classe VERA |
|---|---|---|---|
| `ABTG_VwapRevert` | ✅ `RIGA_PASSO0_VWAPREV.ps1` + pagina + 4 prove | ❌ zero CSV/zip/referto | **3 — IN CANNA** |
| `ABTG_OutOfNoise` | ✅ `RIGA_PASSO0_OUTOFNOISE.ps1` | ✅ girato 29/08 (n=0, baco warmup, poi corretto v1.02) | **2 — GIUDICATO/SOSPESO in attesa di ri-corsa** |
| `ABTG_SondaOrologio` | ✅ `RIGA_SONDA_OROLOGIO.ps1` + 7 prove | [SESSIONE] **PARZIALMENTE girata**: celle 00/01/02 EURUSD fatte 31/08-01/09 (referto ricomposizione + corsa letti il 03/09, `OROLOGIO_VS_BREEDON_2026-09-03.md`); celle 03-06 GBPUSD/XAUUSD SOSPESE (lentezza tick generati, in attesa del ridisegno post-Passo C) | **3 — IN CANNA (4 celle)** |
| `ABTG_AllineaLondra` | ✅ `RIGA_ALLINEALONDRA.ps1` + 4 prove PASSO0 + referto preparazione (10 difetti corretti in rilettura) | ❌ zero referto | **3 — IN CANNA** |

> **Conseguenza operativa:** il giacimento più economico di casa **non è la
> classe 4** ma la **classe 3** — EA con riga scritta, prove congelate e
> criteri firmati che aspettano SOLO il PC. Costo per il passo 0: UNA CORSA,
> non una costruzione.

## 1. Metodo e perimetro
Universo: 125 file EA (103 top-level + 22 standalone, di cui 19 mirror) + 16
script = **122 artefatti distinti**. Prova di "mai girato" per ASSENZA di
artefatti (CSV/zip/REFERTO di corsa) in `risultati_archivio/` e
`risultati_prove/`, incrociata con FLOTTA_ATTIVA, CONTRATTI_SEDIE,
REGISTRO_TEST, prove/, righe/, git log. I `REFERTO_PREPARAZIONE_*` non sono
corse. Limite dichiarato: il confine classe 1/2 è un giudizio (l'ORB è in
flotta E "chiuso" dal forward): precedenza alla classe 1 se è su un grafico.

## 2. Conteggi per classe
| classe | n | quota |
|---|---:|---:|
| 1 — IN FLOTTA (vive + morti in osservazione + utility) | 58 | 47,5% |
| 2 — GIUDICATO (verdetto agli atti, fuori flotta) | 35 | 28,7% |
| 3 — IN CANNA (costruito + riga/prova pronte, aspetta il PC) | 7 | 5,7% |
| 4 — COSTRUITO, MAI GIRATO, SENZA RIGA | 8 | 6,6% |
| 5 — BOZZA/INCOMPLETO (import esterni mai integrati) | 14 | 11,5% |

## 3. Classe 1 — in flotta (58): spina dorsale SupRev/EMA200/GoldenCross/
SuperWave/PTE (16); intraday-aperture (11); sedie di caccia esterna (7:
GapContinuation 774101, GapFill, BreakingBand, CostToCost, EasyTrend,
PunteLarry, WOL); "morti in osservazione" (6: DAX_Live5m/_v2, Nasdaq_Live5m,
ORB, ORB_Fibo, ORB_Ottimizzato); scartati ma su grafico (4 SupRev);
terzi (Gold_Ichimoku, BREAKOUT_EA_JPY senza contratto); utility (10).

## 4. Classe 2 — giudicati (35), i principali
OutOfNoise (n=0 baco warmup, SOSPESO) · CRT_TurtleSoup (CHIUSO 31/08) ·
ChaosLyapunov (BOCCIATO) · SondaM0PB (MORTO 0/12) · SondaRsiEmaV8 (NON
PROMOSSO) · SondaLondonFx (PASSO 0 SUPERATO) · NySessionRetest (muto su H1)
· InvEsaurimento (E1 PF 0,95 / E3 PF 1,16) · DaxReEntry · BreakinBox ·
MeanRevert (R60 12/12 🪦) · CanaleLento, TurnaroundTuesday (R63/64) ·
LiquiditySweep (R89) · CrossEma (R86), CrossEmaApertura (R96) ·
IntradayMomentum (R98 bocciato dal cancello costo) · AtrExhaustVol (R109 DD
44-68% 🪦) · Apertura_3Ingressi (R83) · AltaVelocita · Bulge (R92) · FiboH4
(il "0/8" contato otto volte) · SondaMargine (R114) · Londra_ORB, DAX_M3 ·
BREAKOUT_EA_JPY_Multi (scartata pre-progetto) · varianti superate · studi
strumentali (Apertura_Study, SondaMediazione, SondaADR).

## 5. 🔫 Classe 3 — IN CANNA (7): il vero giacimento economico
| EA | meccanismo | TF | simbolo | esiste | manca |
|---|---|---|---|---|---|
| `ABTG_LondonFx` | canale Londra + RSI, 3 motori | M15 | EURUSD+GBPUSD | R116 FIRMATO, EA costruito 03/09, 112 autotest | riga del round + prima compilazione (previsione dichiarata: NO probabile, costo 1,7-3,3x l'edge) |
| `ABTG_SondaOrologio` | conta-occasioni per fascia oraria | H1 (celle) | GBPUSD, XAUUSD | 7 prove + riga (28/08); EURUSD fatta | ridisegno delle 4 celle sospese dopo il Passo C (stasera) |
| `ABTG_AllineaLondra` | allineamento 5 medie + sessione Londra | **M15** | EURUSD | 4 prove + riga + referto preparazione | **solo la corsa** |
| `ABTG_VwapRevert` | oltre 1σ volume-pesata + candela di rifiuto → ritorno a VWAP | **M15** | D30EUR | 4 prove + riga + tesi + bozza 18 celle | **solo la corsa**; il cancello S0 (spread D30EUR) ERA non adjudicabile — [SESSIONE] ORA LO E': `SPREAD_FLOTTA_MISURA_2026-09-03.md` da' D30EUR 1,6-1,7 pti in sessione |
| `ABTG_FvgRetest` | rientro nel Fair Value Gap | H4 | — | 1 prova + riga | la corsa; 🪦 famiglia SMC/FVG chiusa nel cimitero |
| `ABTG_ImportaTickEsterno` (script) | clone → `_DK` + CustomTicksReplace + sonda | — | Dow | riga `RIGA_DUKA_IMPORT_SONDA` (03/09), criteri congelati | BOZZA mai compilata + fine DUKA |
| `ABTG_Notte_Study` (script) | studio movimento notturno | — | — | `studio_notte.ps1` | la corsa |

## 6. 💎 Classe 4 — costruito, mai girato, senza riga (8)
| EA | meccanismo | TF | M5/M15? | manca | costo | cimitero? |
|---|---|---|---|---|---|---|
| `ABTG_SondaRelativo` | z-score del rapporto fra due simboli, uscita per convergenza | M5/M15 | ✅ bersaglio | riga + prove spezzate ([SESSIONE] in costruzione da un agente il 03/09, file ancora untracked = cantiere aperto) | BASSO (conta-occasioni, chassis M0PB/V8) | **NO** — mai provato in casa |
| `ABTG_OpeningReversalB` | fade del drive d'apertura fallito, 3 stadi di conferma, ingresso sul pullback | M5 (U30USD) | ✅ | riga + compile; criteri già congelati nella spec | MEDIO | ⚠️ CONFINANTE: fade nudo morto (R42 0/24, R60, R109); il ramo CONFERMATO mai misurato |
| `ABTG_DaxValueArea` | Value Area/POC governa l'apertura (balance=fade bordi, direzionale=accettazione) | M5 (D30EUR) | ✅ | riga + compile + conversione punti + tetto barre | MEDIO-ALTO | 🪦 su due fronti: tick-volume su CFD (regola Paolo); fade bordi R42/R60; breakout R45 0/48 |
| `ABTG_BreakoutCorso` | breakout del range (corso, lez. 34-40) | M15 | ✅ | tutto (né prova né riga) | MEDIO | 🪦 PIENO: R45 0/48, R12 48/48 OOS negative |
| `standalone/ABTG_PointBreak` | mean-reversion su rottura di punto | H1/D1 | ❌ | tutto | ALTO | 🪦 R60 |
| `standalone/ABTG_SuperFilter` | filtro sovrapposto | n/d | ❌ | tutto; mai toccato da 34 giorni | ALTO | 🪦 filtro appiccicato 0/5 |
| `ABTG_NFP_Study` (script) | studio uscita NFP | — | n/a | riga; mai toccato da 39 giorni | BASSO | n/a (misura) |
| `ABTG_SondaSessione` (script) | misura del gap chiusura/apertura | — | n/a | riga | BASSO | n/a (misura) |

## 7. Classe 5 — bozze/import mai integrati (14)
Tutti del 04/08 (uno del 26/07), mai toccati, zero riferimenti in pipeline:
DAX_M3_Supertrend, DAX_MASTER_PROP, BULGE_MASTER, EasyTrend_EURUSD,
GoldBreakout_Levels, Gold_Scalper_TK_BB_BE_EA, HARSI_Assistant,
IchiCross_Gold_722, IchiTrend_Gold_Base, ORB_DAX_BASE_EA, ORB_DAX_PM_EA,
ORB_GOLD_FIBONACCI_EA (+v3.21), ORB_OpeningRange. 5 sono ORB/breakout (🪦),
BULGE_MASTER è fade Bollinger (🪦 R108/R111), il resto duplica famiglie vive o
lapidi. **Nessuno merita spesa.**

## 8. 🎯 Shortlist (meccanismo non nel cimitero × TF basso × costo minore)
1. **`ABTG_SondaRelativo`** — unico meccanismo VERGINE del repo, M5/M15,
   costo minimo (conta-occasioni). Domanda-sonda: *su D30EUR M5 con metro
   U30USD, finestra 20 barre e soglia 1,05σ, quante convergenze/giorno per
   lato in 21 mesi, e la MFE mediana copre 3x lo spread misurato (1,6-1,7)?*
2. **`ABTG_OpeningReversalB`** — M5 Dow, criteri già congelati, il ramo
   "fade CONFERMATO a 3 stadi" mai misurato; cancello duro già scritto (se i
   giorni-segnale coincidono col 770202 → scarto). Domanda-sonda: *quante
   giornate in 21 mesi con failure≥3 E signal≥4 E follow-through≥60%, e
   quante NON coincidono coi giorni-segnale del magic 770202?*
3. **`ABTG_DaxValueArea`** — M5 DAX ma morto che cammina su due gambe;
   solo con riserva pesante.
⛔ Fuori: BreakoutCorso, PointBreak, SuperFilter, tutta la classe 5.

## 9. 📌 Raccomandazione in una riga
> Il giacimento non è dove la 4ª battuta lo cercava: il materiale già pagato
> e più vicino a un verdetto sono le **righe di classe 3 che aspettano solo
> il PC** — **AllineaLondra** (M15 EURUSD, 10 difetti già corretti) e
> **VwapRevert** (M15 DAX, oggi adjudicabile grazie allo spread misurato) su
> tutti — più le 4 celle sospese dell'Orologio dopo il Passo C. Della classe
> 4 vale la spesa una voce sola: **SondaRelativo**, già in costruzione.
