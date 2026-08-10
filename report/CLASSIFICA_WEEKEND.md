# 🏆 CLASSIFICA DEL WEEKEND — chi va verso la prop, chi resta su MT5

> **AGGIORNAMENTO 10/08 — SESTO CANDIDATO: ORO NOTTURNO (MaxMinNotte@XAUUSD, cella 250/H2).** R17 walk-forward: 16/20 celle verdi, OOS 20/20 positivo (PF 1,46–2,27), cella candidata OOS +1.023 · PF 1,91 · DD 5,3% · ~33 posizioni. Asterischi: OOS>IS (regime volatile), n al pelo, storico 16 mesi. Referto: `REFERTO_ROUND17_ORO_NOTTE.md`. Prossimo: per-trade R19 + vivaio.


_Aggiornata il 08/08 dopo il primo giro completo: 42 lavori, 84 CSV OHLC + 54 tick reali.
Referto completo: `backtest_pipeline/risultati_archivio/REFERTO_WEEKEND_FASE0.md`._

## I criteri, dichiarati prima (07/08, sera)

**🥇 CANDIDATO PROP** solo se, **a tick reali**: (1) positivo in tutte e due le finestre ·
(2) PF ≥ 1,10 fuori campione · (3) celle vicine positive, non un picco isolato ·
(4) DD OOS < 10% all'1%. **Regola TF di Claudio**: H1 preferito (chiude in giornata),
H4 accettato solo se batte l'H1 su profitto E PF fuori campione. Sotto H1 niente prop.

**⚠️ Aggiunto l'08/08, dichiarato apertamente**: minimo **30 trade OOS** per cella —
il weekend ha prodotto celle "perfette" con 11 trade e PF 335, cioè fortuna. Vale da ora.

Chi non passa **non viene spento da un backtest**: resta su MT5 al rischio che decide
Claudio. Ma non tocca una prop.

---

## 🥇 CANDIDATI PROP (4 criteri a tick reali, vicini positivi)

| EA | dove | TF | OOS | PF OOS | DD OOS | nota |
|---|---|---|---:|---:|---:|---|
| **ABTG_MaxMinNotte_DAX_Short_Ott** | D30EUR (config live) | box notturno M15 | **+618,31** | **2,192** | **1,88%** | 🆕 R2: altopiano sul buffer 750–1500, cella live riprodotta AL CENTESIMO. ⚠️ ~20 trade OOS/cella: sotto il minimo dei 30, lo colma solo il forward |
| **ABTG_SupertrendReversal** | **225JPY (Nikkei)** | **H2** (riferimento per la regola TF; altopiano H2·H3·H4, QUARTA conferma) | **+1863,34** (aggr. H2–H4: +4225,85/113 trade) | **1,653** | **0,88%** | 🆕 R5 col sizing corretto a 100k: tutti e 3 i criteri del file prova passati (scala ~70×, forma, prop). **Scongelato.** Caveat: OOS guardata 4 volte → conferma dal forward; sul VPS gira ancora il lotto minimo finché non si ricompila |

| **ABTG_Dow_Apertura_US** (ricetta DAX) | U30USD | RETEST 35 · buffer 1000 · offset 400 · **SOLO LONG** · PREVBAR M5 | **+653,56** (vicini +1098/+1188) | **1,275** | **4,18%** | 🆕 R6: 5 criteri su 5, altopiano OOS su tutta la riga SOLO LONG (n=130). ⚠️ finestra non vergine (vale mezzo punto). ✅ **DEPLOYATO 08/08 15:34**: il live ora gira la cella misurata (era BREAKOUT 15/200 long+short) — il forward è partito |

| **ABTG_ORB_Ottimizzato (ORB-EMA200)** | U30USD | M5 · solo long · OR 15' · stop 50% range · EMA200 · TP 1,5× range · trailing EMA9 | **+4002,54** | **1,657** | **9,92%** ⚠️ | 🆕 R13→R15: primo candidato NATO IN LABORATORIO (altopiano su 2 mercati + banco vergine + gestione). **DOPPIO ASTERISCO**: DD passa per 8 centesimi e solo nella cella (vicino TP 1,0× = 11,2%); terza guardata OOS Dow = mezzo punto; 13° ribaltamento (trailing: IS dice no, OOS dice sì). MAI stato live: eventuale forward su DEMO, decisione di Claudio |

_Quattro candidati: MaxMinNotte, Nikkei, la ricetta DAX sul Dow — che promuove la
ricetta stessa a METODO (2 indici su 3; il Nasdaq resta l'eccezione misurata) — e
l'ORB-EMA200 nato in laboratorio. Per tutti la conferma finale è il forward._

## 🥈 A UN CRITERIO DAL TRAGUARDO

| EA | dove | cosa passa | cosa manca |
|---|---|---|---|
| ABTG_EMA200 | SPXUSD H4 | OOS +567,07 PF 1,595 DD 2,22% (n=111); vicini TF verdi; sanità al centesimo | 🆕 R3: il periodo 225 è ROSSO nelle due finestre → criterio dichiarato non passato. Nota: il 200 non è un numero pescato — è l'identità (comportamentale) della strategia; il lato 150–175 è verde. La decide il forward |
| **ABTG_GoldenCross_Ottimizzato** | XAUUSD **H1** | IS +299,35 PF 1,494 · OOS +308,30 PF 1,253 DD 6,08% (57 trade OOS) | R2: il vicinato ADX non è verde (20 → −136,56 OOS, ed era la migliore IS: NONO ribaltamento). 10≡15 al centesimo: il filtro ADX non contribuisce. 🆕 R4: **cross-symbol 0/3** (DAX/Dow/Nasdaq tutti rossi, in tre modi diversi) → per la regola pre-dichiarata l'edge è oro-specifico o rumore: la riga pesa di meno. Giudica il forward, con aspettative basse |
| **ABTG_SuperWave_DOW_H1_Ott** | U30USD **H1** | IS +1022 PF 1,849 · OOS +463 PF 1,328 DD 3,91% (n=143) | 🆕 R3: **OOS verde su TUTTE e 5 le celle StMult** (+144…+746, PF 1,10–1,61, n≥134) — la superficie più larga vista. Ma il 2,0 in IS fa −65 → criterio stretto no, per la seconda volta per un soffio. In cima ai quasi, giudica il forward |
| ABTG_SupRev_NAS_H1_Ott | NASUSD H1+H2 | H1: OOS +300,61 PF 1,688 DD 0,86% (n=86) | 🆕 R3: cresta di due anche su StMult (3,0–3,5 verdi, PF 1,47–1,69) ma il 2,5 è rosso → criterio stretto no. Due assi, due creste da due celle, la config live dentro entrambe: margini stretti, giudica il forward |
| ABTG_EMA200 | AUDJPY H12/D1 | 4 criteri formali | **11–12 trade OOS**: sotto il minimo |
_(ORB-EMA200 promosso ai candidati dopo R15 — vedi sopra)_

## 🖥️ RESTANO SU MT5 (misurati a tick reali, non da prop)

Picchi isolati (il criterio 3 esiste per loro): `SupertrendReversal_Multi_Ott` XAUUSD H4
(OOS +2108 PF 2,907 **ma H3 −701**; R3: su StMult cresta 2,5–3,0 ma il 2,0 IS fa −643 e il 3,0 ha 27 trade — resta qui) · `SupertrendReversal_Ott` XAUUSD H4 · `SupRev_DAX_H4`
H4 · `SupRev_DOW_H4` H4 · `SupRev_DOW_H1` H2/H4 · `SupertrendReversal` XAUUSD H3, NASUSD
H1/H4 · `Multi` H3. Più: `EMA200_Ott` XAUUSD (criterio 1 mai passato: IS rossa, OOS verde
— inversione di regime) · `GoldenCross` base XAUUSD (PF OOS 1,066) · `EMA200` XAUUSD/
GBPUSD/GBPJPY (picchi isolati o campioni piccoli) · `SupRev_DAX_H1` (H4 con PF 1,026) ·
XAGUSD **non giudicabile** (storico argento corto: 71 trade IS contro 336 OOS).

## 🔴 MISURATI NEGATIVI A TICK REALI — ✅ SPENTI da Claudio l'08/08 sera

| EA | rischio (era) | IS | OOS | DD OOS |
|---|---:|---:|---:|---:|
| DAX Live 5m | 2% | −626,33 | **−2218,56** | **39,74%** |
| DAX Live5m v2 | 1% | +11,10 | −393,74 | 14,16% |
| Nasdaq Live 5m | 2% | +98,96 | −326,54 | 19,40% |

Decisione presa l'08/08 sera: **tutti e tre rimossi dai grafici** (passo 1 della
scaletta operativa). Eventuale ritorno solo dal binario B (motore), non da tarature.
(E la divergenza OHLC→tick su queste tre dice una regola nuova: **sotto M15 lo screening
OHLC è fuorviante**, non impreciso.)

## ❌ NIENTE EDGE NEMMENO IN SCREENING (OHLC, nessuna cella positiva nelle 2 finestre)

`EMA200@200AUD` · `GoldenCross@NZDUSD/USDCAD/USDCHF` · `MaxMinNotte@EURUSD` · `Nightly` ·
`ORB` · `ORB_Fibo` · **`PTE@XAUUSD`** (16 celle TP1×TF, nessuna positiva nelle due
finestre — e lo storico oro è ora verificato buono) · `PostNews@EURUSD/EURJPY` ·
`SupRev_CAC@F40EUR` · `SupertrendInvert` · `SupertrendReversal@D30EUR` · `WOL`.

## 📌 Dati e finestre

Oro ✅ e Nikkei ✅ coprono le finestre (rilevatore trade/mese ok) — **B9 oro chiusa**.
Argento ❌ storico corto: numeri IS non validi. SPXUSD: campioni IS piccoli sui TF alti.
Rischio non uniformato fra EA (default di ciascuno): confrontare rapporti, non euro.
