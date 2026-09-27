# 🤖 Risposta di Gemini al briefing (27/09/2026) — con il confronto coi fatti di casa

Fonte: testo incollato da Claudio in chat il 27/09/2026 ("RISPOSTA DA GEMINI A CLAUDE: REVISIONE
METODOLOGIA ABTG E PROPOSTE"). Briefing inviato: `docs/BRIEFING_PER_GEMINI_2026-09-27.md`.

## 1. Conferme di Gemini (testuali, in sintesi)
- Imbuto e riproducibilità G0/G1: **CONFERMO**.
- Regola dell'altopiano (centro del blocco, mai il picco, estendere se tocca il bordo): **CONFERMO**.
- Aritmetica del Guardian (cap 4% = due posizioni al 2%; C2 ridondante sotto 4 sedie per cluster): **CONFERMO**.
- Lettura asimmetrica del rischio (n >= 60 per "rischio passato"): **CONFERMO**.

## 2. "Cosa manca" secondo Gemini — e cosa e' vero in casa
| Punto di Gemini | Stato di casa | Azione |
|---|---|---|
| Stress test (spread/slippage +30-50%) come cancello DURO prima del campo | Esiste l'agente `collaudatore-prop` e il cancello del costo 40x; il degrado NON e' un cancello formale nella selezione | 🟢 Accolto come proposta di criterio: `report/FIRME_*` quando Claudio firma. Intanto: stress sull'oro long dal per-trade R260a (post-processing, zero tester) |
| Oro long: NON schierare senza tick-by-tick (OHLC = limite inferiore del DD) | Gia' dichiarato nel referto B; tick oro BCM dal 2024.07.05 (profondita' [NON VERIFICATA]) | 🟢 **R268**: oro long a TICK sulla finestra tick contro OHLC stessa finestra (misura lo scarto OHLC->tick del DD) |
| Monte Carlo assume trade indipendenti (IID): ignora il crollo sistemico DAX/Dow/Nasdaq insieme | ✏️ CORRETTO 27/09 sera: la v1 ricampiona GIA' giornate intere (`m.serie` somma per giornata, referto v1 §6.1), quindi la correlazione intra-giornata fra le 4 sedie era conservata; qui c'era scritto "ricampiona per-trade per sedia", falso. Il buco vero era agganciare PER DATA le sedie nuove | 🟢 FATTO: `mc_challenge_ftmo_v2.py` + `report/MC_CON_ORO_E_BLOCCHI_2026-09-27.md`: IID vs blocchi misurato: l'IID per posizione e' ottimista di +4,1 punti PASS, MA scomposto (cancello f2da85f6, classe 870) la parte FRA sedie vale solo **+1,4** (4 sedie; -1,8 con la 770105), il resto (+3,8) e' DENTRO la 771531 (fino a 8 posizioni al giorno). 770105 e oro long agganciati per data |

## 3. Meccanismi proposti — confronto con la lista dei caduti
| Proposta | Cosa dice il REGISTRO | Verdetto |
|---|---|---|
| Londra: filtro "compressione asiatica" (ATR 00-07 nel 25° percentile di 20 giorni) | Mai misurato in questa forma. ⚠️ Tensione col cancello del costo: la compressione = canale stretto = stop stretto (nel nostro EA lo stop e' il canale). Regge solo se lo stop NON e' il canale (stop in ATR o al centro con TP in multipli) | 🟡 Candidato: serve un input nuovo (`mql5-ea-developer`) o `MaxMinNotte` con box 00-07 e `InpMaxBoxPts` (esiste!) come proxy della compressione: prova a costo zero |
| Dow short: fade dello sweep dei massimi europei nei primi 15' USA | **R95: sweep del pre-market, 0/30 celle** (caccia meccanismi 26/09 §C); R42 fade prima candela 0/24 | 🔴 Gia' misurato morto sul meccanismo base; una variante "massimo della sessione europea 08-14" non e' identica: si registra come variante, NON si rigira senza una differenza dichiarata |
| DAX notturno: abbandonare lo specchio S&P, mean reversion su VWAP/Bollinger M15 | Nightly (fade notturno) su D30EUR = R259 in corsa (escluso per costo 18-21x); Bollinger mean reversion su indici: nessuna corsa in casa con quel motore | 🟡 Candidato a MECCANISMO nuovo (serve EA o `ABTG_Nightly` con bande): passa da `cacciatore-strategie` per il sorgente pubblico |

## 4. Ruolo degli agenti: "capire PERCHE' un edge sparisce, non cercare a caso"
🟢 Accolto. Precedente di casa che gli da' ragione: `IL_MERITO_E_D_INVERNO` (770201: estate PF 0,98,
inverno 1,80) e' nato leggendo i per-trade, non da una griglia. Azione: **autopsia dei trade
persi in OOS** per DAX long (per-trade R261 795401/795402/795403), oro short vs long (795301/795302)
e Dow short (R54a), per ora del giorno, giorno della settimana, regime, ampiezza del box.

## 5. Cosa NON cambia
I cancelli non si abbassano; la taglia resta firma di Claudio; nessuna proposta di Gemini va in
campo senza file prova -> cancello -> round -> referto -> cancello.
