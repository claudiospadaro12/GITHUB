# UBS volatility breakout M15 sugli indici: criteri e previsioni (21/11/2026, scritti PRIMA di qualunque numero nostro)
**Natura: CRITERI.** Solo tester/demo; VPS e reale 10105439 non toccati; nessun giudizio su lotti/taglie/acquisti; soglie non si abbassano dopo i numeri.
**Cosa si misura:** se i numeri di Wim sui suoi set volatility M15 degli indici (report del Library pack, tick, 13/05/2025-13/11/2026: `UBS_LIBRARY_PACK_POSTIS_2026-11-21.csv`) si ripetono con i NOSTRI dati nativi BCM a tick reali. Esplorativo sui dati di Wim (393 confronti), confermativo solo qui.

## 1. Insieme dei set (regola fissata ora, NON scelto dai PF di Wim)
**TUTTI** i set "volatility breakout" (Run_Strategy=2) su indici M15 presenti nel Library pack, anche quelli con PF basso di Wim: 15 set distinti per contenuto: US30 = U3V12 (Till), U3V08, VOL_M15_a, b, c, g; US500 = U5W10, VolUS500_a, c, g; USTEC = NAS_VOL_M15_A, B, C, D, E. **Esclusi per regola:** Indicement (S/R, gia visto debole post-IS), ORB Master (range), scalper H1 (US30_1H_Scalp: sensibili ai tick), altri timeframe.
IS dichiarati da Wim: NAS_VOL_M15_A, B, E = 2020-2023; gli altri non dichiarati (possono includere 2025-26: limite).

## 2. Esecuzione
Terminale principale BCM, demo 50503392, solo tester, EA `Ultimate_Breakout_EA_WSC_V9.5` (non aggiornato). Simboli BCM nativi con tick reali: `U30USD` (US30), `SPXUSD` (US500), `NASUSD` (USTEC); `ForceSymbol` imposto al simbolo BCM, `Risk=0`, `StartLots=0.1`. **Modello 4 (tick reali), M15, deposito 100000 EUR, 01/01/2025 -> 13/11/2026**, una passata per set = 15 passate. Contatore di campagna +15.
Analisi a posteriori sulle operazioni, due segmenti: **P = 01/01/2025-12/05/2025** (non nella finestra di Wim: indipendente) e **Q = 13/05/2025-13/11/2026** (la sua).

## 3. Cancelli per ogni set (tutti sul Modello 4)
- **G1:** operazioni >= 60 e PF >= 1,20 sull'intera finestra.
- **G2:** PF >= 1,0 in P (se >= 8 operazioni) E in Q.
- **G3 (recovery):** profitto netto / DD massimo >= 1,5.
- **G4 (mesi):** almeno il 60% dei mesi con operazioni chiusi non negativi.
- **G5 (confronto con Wim):** operazioni nostre in Q entro +-35% di quelle di Wim (tick). Fuori range = "non confrontabile" (simbolo/pip/orario diversi): non e una bocciatura ma il set NON puo essere dichiarato candidato.
- **Candidato** = G1+G2+G3+G4 e G5 non violato. Un set che passa G1 ma non G2 = "vantaggio non confermato".
- **Correlazione:** fra candidati, correlazione dei P&L giornalieri > 0,7 -> se ne tiene uno; poi con gli EA oro (a parte).
- **Passo successivo solo per i candidati:** stessa finestra a 1 minuto (rapporto tick/1 minuto >= 0,7), perturbazione dei parametri, e solo poi ottimizzazione.

## 4. Previsioni (scritte ora)
- **V-1** Almeno 10 set su 15 con operazioni nostre in Q entro +-35% di Wim (G5): 60%.
- **V-2** Mediana del PF tick nostro in Q sui 15 set >= 1,0: 70%; >= 1,2: 35%.
- **V-3** Almeno un set passa G1-G4 e G5: 35%; almeno 3: 10%.
- **V-4** I set US30 hanno mediana PF superiore a US500 e USTEC: 75%.
- **V-5** I set con PF di Wim >= 2 (VOL_M15_a, g) scendono sotto 1,5 con i nostri dati: 60%.
- **V-6** Il segmento P ha PF >= 1,0 per almeno meta dei set: 55%.

## 5. Cosa NON sappiamo
Se i tick nativi BCM coprono tutto il 2025 (la riga del Passo 0 lo dice; se mancano mesi, la qualita nel manifest); se il filtro news/calendario MQL5 (attivo in U3V12/U3V08) funziona nel tester; se i "pip" dei set coincidono con i punti dei simboli BCM; l'orario (AutoGMT vero, server BCM GMT+1 fisso); la derivata dei dati di Wim (broker e feed diversi); selezione dei set di Wim fatta dopo i risultati.
**Peso:** 15 passate a tick su indici, stimo 2-5 ore sul PC (non misurato per gli indici).
