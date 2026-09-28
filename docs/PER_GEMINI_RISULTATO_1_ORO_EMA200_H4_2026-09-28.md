# PER GEMINI — RISULTATO 1: la griglia EMA200 H4 sull'ORO dice NO (28/09/2026)

Scritto da Claude per Gemini (Agente 3 «Proponente» + Agente 4 «Avvocato del diavolo»). Tutti i numeri vengono dal repo
`claudiospadaro12/GITHUB`, branch `lavoro`: `report/LETTURA_ROUND_CORTI_C2_2026-09-28.md` (PASS del cancello `8c19d0e0`)
e `report/LETTURA_ROUND_CORTI_C_2026-09-28.md` (PASS `f7d95442`). L'EA e' `ABTG_EMA200.mq5` (690 righe, gia' allegato).
Dove non c'e' un numero c'e' scritto NON MISURATO. Niente e' stato cambiato in campo.

## 1. Il motore, in tre righe
EMA200 su H4: ingresso in due gambe (`InpOrder1Atr` = distanza della gamba 1 in ATR, `InpOrder2Atr` = gamba 2), stop ATR
(`InpSLatr`), obiettivo in R (`InpTP_RR`), parziale al primo target (`InpTP1Pct`). E' la sedia **771531** in campo su FTMO
(U30USD H1) e la base del candidato oro. Qui si parla della cella oro XAUUSD H4.

## 2. Il round (R264d1-d4 "C2"): griglia 3x3 O1 x O2 + asse dell'uscita, OHLC M1, deposito 100.000, rischio 1%
Finestra IS 2017.01-2023.12 (7 anni: laterale 2017-18, toro 2019-20, laterale 2021-22, toro 2023) · OOS 2024.01-2026.06 (2,5 anni).
### 3.2 XAUUSD (G0 R264d: ROSSO [letto dalla riga C, non rifatto]) -- IS 2017-2023: laterale 2017-2018, toro 2019-2020, laterale 2021-2022, toro 2023

| O1 \ O2 | O2 0.5 IS PF / n / DD -- OOS PF / n / DD | O2 0.6 IS PF / n / DD -- OOS PF / n / DD | O2 0.7 IS PF / n / DD -- OOS PF / n / DD |
|---|---|---|---|
| O1 0.10 | 0.810 / 678 / 17.05 -- 1.223 / 291 / 6.22 | 0.831 / 668 / 14.29 -- 1.446 / 282 / 5.87 | 0.824 / 654 / 12.74 -- 1.646 / 274 / 5.11 |
| O1 0.20 | 0.813 / 789 / 16.02 -- 1.310 / 332 / 6.18 | 0.836 / 777 / 13.32 -- 1.535 / 311 / 6.02 | 0.816 / 750 / 12.74 -- 1.625 / 300 / 5.22 |
| O1 0.30 | 0.811 / 880 / 16.61 -- 1.346 / 397 / 6.40 | 0.818 / 867 / 13.84 -- 1.547 / 364 / 6.31 | 0.813 / 834 / 12.73 -- 1.599 / 343 / 5.51 |

fonte: `ROUND_R264d1..R264d3/*_IS_ohlc_*.csv` e `*_OOS_ohlc_*.csv` [MISURATO dal CSV, PF sui deal]; OOS 2024.01-2026.06 = la finestra del genetico: conferma DEBOLE (R264 par. 4), NON cieca a livello di vicinato

- S5 INERZIA: O1 morde su tutti e tre i file
- S2 CENTRO = MEZZO O1 0,20 / O2 0.6: PF IS **0.836** (il PICCO della griglia e' O1 0.20 / O2 0.6 PF 0.836: si scrive, NON si sceglie); medie di fila 0,10/0,20/0,30 = 0.822/0.822/0.814, di colonna = 0.811/0.828/0.818; BORDO (fila esterna >= mezzo + 0,08; falso allarme simulato 0,2-8,8%): no; celle IS >= 1,10: 0 su 9; 4 vicini del mezzo >= 1,00: False; PF OOS mezzo 1.535 (conferma DEBOLE >= 1,10)
- S1 CAMPIONE: n IS al mezzo 777 deal >= 276 (= 150 pos x 1,838); OOS 311 deal >= 276
- S3 RISCHIO al mezzo (a qualunque n, Emendamento B): DD IS 13.32 / DD OOS 6.02 a 1% contro 10.0 -> **SOPRA IL MURO: NO PER RISCHIO**; derivato a 2,00 (x1,956-1,990) [DERIVATO]: IS 26.06-26.51, OOS 11.78-11.98 -- OHLC SOTTOSTIMA: sopra boccia, sotto NON dimostra
- S4 SEGNI: REGIME; S6 DEFAULT (proxy O1 0,10 / O2 piu' vicina a 0,35): O2 0.5 PF IS 0.810 (il centro NON la batte di 0,05: IL DEFAULT VA BENE); banda H (classe 178): SOTTO le due bande (0.836 < 0,85): lato BASSO, oltre H_FETTA (l'IS perde piu' di quanto H_FETTA prevedesse) e lontano da H_MOTORE (1,15-1,40). Il sospetto 'baco o pin non arrivato' della testa par. 7 e' del lato ALTO (> 1,40): qui NON si applica, e il pin e' verificato (P0 sul CSV, par. 0; classe 166 della riga)
- **VERDETTO S8 (per nome): NO PER RISCHIO (S3)** [G0 XAUUSD ROSSO: l'OOS contro il genetico e' NON CONFRONTABILE, l'IS resta leggibile da solo] -- S7: Modello 1 BOCCIA e non PROMUOVE: il massimo e' PASSA LO SCREENING -> serve il tick (2024.07.05 -> 2026.06.30 o storico esterno)
- Emendamento della finestra: l'IS si misura in operazioni (777 deal ~ 423 posizioni [DERIVATO 1,838 deal/pos]); il VECCHIO (IS) giudica il RISCHIO (DD IS 13.32), il RECENTE (OOS) il MERITO (PF OOS 1.535); rischio: VIOLATO (DD <= 10,0% @1% in IS e OOS; boccia a qualunque n, Emendamento B)
- LE DUE SPIEGAZIONI di IS < 1,00 / OOS >= 1,10 (S4; classe 178, per nome): (a) REGIME -- il motore rende solo nel toro dell'oro 2024-26; (b) STORICO -- lo storico M1 2017-23 del PC di backtest non e' quello di oggi (prezzi/spread): D0 ok (par. 0) la esclude SOLO sul TASSO dei deal, NON su prezzi o spread (testa par. 11: storico M1 dal 2017 [NON VERIFICATO]). Nessuna misura di questa raccolta le separa. Prova di regime dell'IS (Emendamento C: IS 2017-2023: laterale 2017-2018, toro 2019-2020, laterale 2021-2022, toro 2023 -- PF < 1 anche nel toro 2019-2020?): **NON MISURATA** -- il per-trade della raccolta parte dal 2024.01.05 (solo OOS) e il CSV d'ottimizzazione da' UN numero per 7 anni. Il NO PER RISCHIO regge sotto (a) (un DD e' un fatto, Emendamento B); sotto (b) poggerebbe su uno storico sbagliato: si legge NO PER RISCHIO SU QUESTO STORICO, dichiarato.
- DD alle taglie [DERIVATO, R193b B3, da Equity DD % max(IS, OOS) al mezzo a 1.00%]: 0.50%: 6.90-6.66%; 1.50%: 19.30-19.99%; 2.00%: 24.87-26.65% -- **NESSUNA PROPOSTA DI TAGLIA**
- per-trade 796532 (cella InpOrder1Atr=0.3, gamba OOS): posizioni 179, PF in posizioni (k 1.8183 tolto) 1.347, EP 45.27 EUR/pos, DD a saldo chiuso 5.888 % (picco 2024.11.08, fondo 2025.07.08), peggior giornata -1.095 % (2024-01-17, denominatore = saldo a inizio giornata), deal/posizione 2.218 [MISURATO dal per-trade]
- per-trade 796533 (cella InpOrder1Atr=0.3, gamba OOS): posizioni 164, PF in posizioni (k 1.8178 tolto) 1.550, EP 65.81 EUR/pos, DD a saldo chiuso 5.484 % (picco 2024.11.08, fondo 2025.07.08), peggior giornata -1.098 % (2024-01-17, denominatore = saldo a inizio giornata), deal/posizione 2.220 [MISURATO dal per-trade]
- per-trade 796534 (cella InpOrder1Atr=0.3, gamba OOS): posizioni 155, PF in posizioni (k 1.8171 tolto) 1.602, EP 67.39 EUR/pos, DD a saldo chiuso 4.403 % (picco 2024.11.08, fondo 2025.08.22), peggior giornata -1.094 % (2024-01-17, denominatore = saldo a inizio giornata), deal/posizione 2.213 [MISURATO dal per-trade]
- certificato di morte (09/09): coperte da QUESTO round: (1) PF, (2) n e DD, (3) uscita ad asse; dall'ARCHIVIO, per nome: (4) gemelli = R139a EMA200 AUDJPY H4 (16,5 anni, OHLC): `risultati_prove/dal_vps/ABTG_EMA200/ABTG_EMA200_AUDJPY_IS_ohlc_r139a.csv`: PF 0.780-0.807, n 757-768, DD 15.35-16.94% a 1% [MISURATO dal CSV d'archivio]; `risultati_prove/dal_vps/ABTG_EMA200/ABTG_EMA200_AUDJPY_OOS_ohlc_r139a.csv`: PF 0.949-1.008, n 1322-1345, DD 16.89-20.44% a 1% [MISURATO dal CSV d'archivio] + R139b EMA200 GBPUSD H4 (OHLC): `risultati_prove/dal_vps/ABTG_EMA200/ABTG_EMA200_GBPUSD_IS_ohlc_r139b.csv`: PF 0.803-0.838, n 856-875, DD 17.73-20.32% a 1% [MISURATO dal CSV d'archivio]; `risultati_prove/dal_vps/ABTG_EMA200/ABTG_EMA200_GBPUSD_OOS_ohlc_r139b.csv`: PF 1.127-1.139, n 1292-1321, DD 10.05-11.05% a 1% [MISURATO dal CSV d'archivio] (i G0 ROSSI della riga C su GBPJPY/GBPUSD/AUDJPY NON riempiono la casella: controllo di banco, griglie SALTATE) | (5) TF = R32a EMA200 XAUUSD H1 (prove/R32a_ema200_xauusd.txt, @DAQUANDO 2024.09.26: finestra recente, NON il 2017-23): `risultati_prove/ABTG_EMA200/ABTG_EMA200_XAUUSD_IS_r32a.csv`: PF 0.561-0.846, n 258-308, DD 9.27-15.29% a 1% [MISURATO dal CSV d'archivio]; `risultati_prove/ABTG_EMA200/ABTG_EMA200_XAUUSD_OOS_r32a.csv`: PF 0.843-1.110, n 345-387, DD 8.35-12.61% a 1% [MISURATO dal CSV d'archivio] (il TF e' cambiato; il RISCHIO 2017-23 a H1 resta NON MISURATO); certificato COMPLETO (3 caselle da QUESTO round + 2 dall'ARCHIVIO, per nome qui accanto): un NO qui e' un NO con certificato [PF IS mezzo 0.836, OOS 1.535]
- USCITA R264d4 (asse InpTP1Pct sul centro; 0 spegne parziale, BE e trailing: deal = posizioni): IS PF 0/25/50/75 = 0.798/0.845/0.836/0.826 (n 229/893/777/700, DD 19.35/12.80/13.32/14.03); OOS PF 1.284/1.568/1.535/1.506 (DD 6.45/5.75/6.02/6.23); 25/50/75 entro 0,03: IS si, OOS NO (0.062); TP1Pct 0 piu' basso e con DD piu' alto del 50 (come sul Dow): IS si, OOS si -> **l'uscita a parziale/BE/trailing regge (nessuna notizia)**
  - M1-M3 TP1Pct 0 contro il CONTROLLO TP1Pct 50 dello stesso file (modello leggi_r255 par. 10, sul CSV): M1 passa, M2 fallisce, M3 fallisce -- calcolato anche sotto 150: INDIZIO, non verdetto
  - M1-M3 TP1Pct 25 contro il CONTROLLO TP1Pct 50 dello stesso file (modello leggi_r255 par. 10, sul CSV): M1 passa, M2 fallisce, M3 passa
  - M1-M3 TP1Pct 75 contro il CONTROLLO TP1Pct 50 dello stesso file (modello leggi_r255 par. 10, sul CSV): M1 passa, M2 fallisce, M3 fallisce
  - per-trade 796535 (cella TP1Pct=75, OOS): posizioni 158, PF in posizioni (k 1.8199 tolto) 1.509, EP 66.56 EUR/pos, DD a saldo chiuso 5.681 % (picco 2024.11.08, fondo 2025.07.08), peggior giornata -1.097 % (2024-01-17, denominatore = saldo a inizio giornata), deal/posizione 1.861 [MISURATO dal per-trade]




Tutta la storia, cella di mezzo (profitti lordi / perdite lorde): IS 59.844 / 71.592 = PF 0,836 (−11.748 EUR) · OOS 31.957 /
20.822 = 1,535 (+11.134) · **9,5 anni insieme: 91.801 / 92.414 = PF 0,993, −614 EUR a rischio 1% su 100.000**.

## 3. Il verdetto di casa e perche'
- **NO PER RISCHIO su questo storico**: DD 13,32% a rischio 1% in IS (muro FTMO 10%) su un OHLC che SOTTOSTIMA. Regola di casa:
  «il vecchio giudica il rischio, il recente il merito»; un DD e' un fatto, non si media (media 9,65% = un conto mai esistito).
- Certificato di morte (5 punti): PF, n e DD, uscita ad asse (`InpTP1Pct` 0/25/50/75: IS 0,798/0,845/0,836/0,826) da questo round;
  gemelli dall'archivio (R139a AUDJPY H4 IS PF 0,78-0,81, R139b GBPUSD H4 IS 0,80-0,84); TF dall'archivio (R32a XAUUSD H1 PF
  0,56-0,85, ma solo dal 2024.09).
- **Il recente e' buono ma NON CONFRONTABILE**: il G0 (riproduzione al centesimo dell'archivio del genetico) e' ROSSO su 4 simboli su 4:
**DIAGNOSI DEL ROSSO (classe 913, [MISURATO] dal CSV e dal per-trade della gemella; banco contro genetico)**: R264c GBPJPY: n +21, PF -0.017, posizioni al pavimento 0,01: 0 su 144 | R264d XAUUSD: n +105, PF -0.072, posizioni al pavimento 0,01: 61 su 187 | R264a GBPUSD: n +46, PF -0.032, posizioni al pavimento 0,01: 0 su 212 | R264b AUDJPY: n +5, PF -0.091, posizioni al pavimento 0,01: 0 su 148 | R265a EURUSD: n +26, PF -0.051, posizioni al pavimento 0,01: 0 su 104 (banco della scansione NON VERIFICATO: si riporta, non entra nella firma) -> **CAUSA NON DIMOSTRATA. Lo stesso segno (n del banco PIU' ALTO, PF PIU' BASSO del genetico) su tutti i 4 ROSSI di R264, e 3 simboli (GBPJPY, GBPUSD, AUDJPY) SENZA nessuna posizione al pavimento: il lotto 0,01 (causa nominata dalla testa R264 par. 5 per l'oro) NON e' la causa COMUNE, e l'attesa VERDE della testa sui forex e' SMENTITA. Sull'oro il pavimento resta una causa AGGIUNTIVA possibile, NON dimostrata. Ipotesi per nome: H_BINARIO (il sorgente a HEAD non e' 0953846c del genetico: 3af47ed9 lotto da OrderCalcProfit, 344a11b9 breakeven); H_STORICO (i tick BCM di oggi non sono quelli del 01/08); H_SPEC (commissione/swap del simbolo nel tester di oggi). La misura che le separa: lo STESSO G0 col binario 0953846c (rifa' l'archivio -> H_BINARIO; non lo rifa' -> H_STORICO/H_SPEC)**
  Causa NON DIMOSTRATA (non e' il pavimento del lotto: sul forex 0 posizioni a 0,01). Ipotesi per nome: il binario (H_BINARIO: quello
  di oggi contro `0953846c` del genetico), lo storico dei tick (H_STORICO), le specifiche del simbolo (H_SPEC). Misura che le separa:
  rifare il G0 col binario `0953846c`.

## 4. Le due spiegazioni del «7 anni sotto 1, 2,5 anni sopra», nessuna separata
(a) REGIME: il motore ha edge solo nel toro dell'oro 2024-26 (alta direzionalita'); (b) STORICO: le barre M1 BCM pre-2024 sono diverse
o sporche (il controllo D0 sul numero di operazioni per anno e' dentro la banda, 0,79-0,89, ma non dice nulla su prezzi e spread).
La prova per regime dell'IS (PF < 1 ANCHE nel toro 2019-20?) e' **NON MISURATA**: i per-trade coprono solo l'OOS.

## 5. Cosa chiediamo a Gemini (con le regole di casa: niente griglie di parametri su un motore senza edge; ogni proposta con
## attesa dichiarata PRIMA, contro-esempio, piano di misura e costo)
1. **Filtro di regime EX ANTE** (la tua guida, punto 5): proponi una definizione di regime che NON usi i risultati del backtest
   (es. ATR D1 relativo, pendenza EMA200 D1, ADX D1), con la soglia fissata PRIMA e con il contro-esempio obbligatorio: «se il filtro
   spegne anche il 2024-26, il filtro non separa niente». Dichiara quale numero produrrebbe l'ipotesi (b) STORICO se fosse vera.
2. **Come separare REGIME da STORICO senza il per-trade del 2017-23**: quale misura, con quali file (CSV IS/OOS per cella sono disponibili,
   i per-trade solo OOS)? Un round a tick sul 2019-20 (toro) costa ~4 min/file: e' la via piu' corta?
3. **Il G0 ROSSO**: leggendo `ABTG_EMA200.mq5`, c'e' qualcosa nel codice (ordine dei due ordini, arrotondamento del lotto, `InpSLatr`
   sull'ATR di apertura barra vs tick) che rende il risultato dipendente dal modello tick/OHLC o dal binario? Righe, non opinioni.
4. **Uscita**: `InpTP_RR` e `InpSLatr` non sono mai stati messi ad asse sul 2017-23. Vale la pena, o e' «parametri di un motore morto»?
   Rispondi con la regola zero in mano.
5. **Avvocato del diavolo**: costruisci il caso in cui una tua proposta migliorerebbe l'IS per una ragione diversa da quella dichiarata.

Vincoli: nessuna martingala/griglia/recovery; stop >= 40 x (spread + commissione); centro dell'altopiano mai il picco; ogni numero con
la fonte o NON MISURATO. Le proposte tornano a Claudio e a Claude e passano dal cancello prima di qualunque modifica.
