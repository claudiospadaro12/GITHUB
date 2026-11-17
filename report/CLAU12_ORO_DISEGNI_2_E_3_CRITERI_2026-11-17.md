# CLAU12 oro: due disegni nuovi (breakout a stop stretti con pendenti persistenti; rimbalzo ai livelli) - criteri e previsioni scritti PRIMA di qualsiasi numero (17/11/2026, sera)

**Natura:** piano di prova su tester, dati FTMO. Nessun giudizio su lotti, taglie, conti o acquisti. Decisione di Claudio (17/11, sera): "1 e 2" = (1) un nuovo disegno di breakout con stop stretti e pendenti longevi, ispirato agli ordini di grandezza visibili nel set di Wim ma scritto da noi; (2) una logica diversa, il rimbalzo ai livelli. Parte da `CLAU12_BREAKOUT_ORO_CRITERI_2026-11-17.md` (disegno 0: 18 set, **nessun candidato**).
**Trasparenza sul disegno:** questi disegni nascono DOPO aver visto il risultato negativo del disegno 0 e gli ordini di grandezza dei parametri di Wim (stop 600, target 1700, scadenza 480 ore, in punti; unita non verificata: su XAUUSD a 2 decimali 1 punto = 0,01 USD, quindi 6 e 17 USD contro un ATR D1 di circa 10-12 USD nel 2019). Non e una replica indipendente; il dentro-campione 2015-2020 e gia stato guardato dal disegno 0, quindi **il giudizio vero e il fuori-campione (G4)**, non G1.

## 1. Prerequisiti (bloccanti)
- Template **1.03** (nuovo input `InpRearm`: `false` = i pendenti restano fino a riempimento/scadenza e se ne piazzano di nuovi solo quando non ce ne sono; `true` = come 1.02, cancellazione e riarmo a ogni barra) compila con 0 errori e passa una **passata di controllo a occhio per ciascun disegno** (10 operazioni lette a mano: ordini al livello +/- offset, stop/target alle distanze previste, persistenza dei pendenti nel disegno 1, ordini limit dalla parte giusta nel disegno 2, una sola posizione). Se c'e un difetto, si corregge e i numeri di quel giro non si usano. Previsione: almeno un difetto da correggere nei due controlli: 50%.
- Dati FTMO, terminale `Mt5_Ftmo_Prova` (login scaduto: il tester parte, P3 superata).

## 2. Disegno 1 - breakout a stop stretti, pendenti persistenti
Ingresso BREAKOUT, `InpRearm=false`, stop e target **in punti fissi** (`SL_FIXED_PTS`, `TP_FIXED_PTS`), un solo trade al giorno, lotto 0,1, nessun break-even/trailing, offset 0,10 ATR e distanza minima 0,20 ATR come prima. L9 su 4 fattori, per **D1** e **H4**:
| Fattore | livelli |
|---|---|
| A. Stop (punti) | 400 / 600 / 800 |
| B. Target (punti) | 1200 / 1700 / 2400 |
| C. Countback (barre) | D1 10 / 20 / 40; H4 30 / 60 / 120 |
| D. Scadenza (barre) | D1 5 / 10 / 20; H4 30 / 60 / 120 |
Righe L9 (0-based): 0000, 0111, 0222, 1012, 1120, 1201, 2021, 2102, 2210. **18 set.**
**Rischio noto:** con stop da 4 a 8 USD, il Modello 1 (candele da 1 minuto) puo sovrastimare i risultati (ambiguita stop/target dentro la stessa candela; gli scalper UBS e Scalper Claudio sono crollati a tick reali). Per questo G6 (tick, proxy BCM) e obbligatoria prima di qualunque conclusione e la previsione e prudente.

## 3. Disegno 2 - rimbalzo ai livelli (limit)
Ingresso LIMIT (sell limit appena sotto il massimo delle ultime N barre, buy limit appena sopra il minimo), `InpRearm=true`, stop = ATR, target = multiplo del rischio, un solo trade al giorno, lotto 0,1, offset 0,10 ATR, distanza minima 0,20 ATR. L9 su 4 fattori, **D1** e **H4**:
| Fattore | livelli |
|---|---|
| A. Countback (barre) | D1 10 / 20 / 40; H4 30 / 60 / 120 |
| B. Stop (ATR) | 1,0 / 1,5 / 2,5 |
| C. Target (R) | 1,0 / 1,5 / 2,0 |
| D. Scadenza (barre) | D1 1 / 3 / 6; H4 6 / 18 / 36 |
Stesse righe L9. **18 set.** (Un rimbalzo e per natura quasi opposto a un breakout sugli stessi livelli: se funziona, e un candidato di diversificazione rispetto al breakout e al set di Wim.)

## 4. Contatore e soglie
- **Looks di campagna:** 18 (disegno 0) + 18 + 18 = **54 set**, piu fino a 8 vicini per ogni finalista di G1 (max 3 per disegno): **fino a ~102**. Soglia di significativita: 0,05/102 circa 0,0005 monolaterale, z circa 3,3. **La statistica t richiesta sale da 3,0 a 3,3 per entrambi i disegni** (piu looks, soglia piu alta; non e una modifica a posteriori per ottenere un risultato). Conseguenza dichiarata: con ~150 operazioni passa solo chi ha un PF netto nettamente sopra 1,5.
- **Porte (stesse del disegno 0, tranne t):** G1 (IS 2015-2020, netto): profitto > 0, PF netto >= 1,30, operazioni >= 100, recovery >= 1,5, **t >= 3,3**. G2 perturbazione (>= 70% dei vicini in profitto, PF mediano >= 0,8 x). G3 (entrambe le meta IS in profitto, PF >= 1,10). **G4 (OOS 2021-22 e 2023-24, netto): PF >= 1,20 e profitto > 0 in entrambi, >= 20 operazioni, WFE >= 0,5.** G5 hold-out 2025-01 -> 2026-10 (aperto una sola volta, informativo; non puro: l'andamento dell'oro e noto). G6 tick (proxy BCM 2024-07-15 -> 2024-12-31): PF tick/candele >= 0,7, DD tick <= 1,5 x, operazioni +/- 10%.
- Costi: netto = tester - 3,6 EUR a operazione (36 EUR/lotto con 0,1); lo swap e gia nel tester.
- Correlazione con Wim C0 (stesse giornate, `Correlazione.py`): etichetta soltanto (<= 0,30 diverso; 0,30-0,60 parente; > 0,60 stessa cosa).

## 5. Previsioni (scritte ora)
| Evento | Disegno 1 | Disegno 2 |
|---|---|---|
| Almeno un set con PF netto >= 1,30 e >= 100 operazioni | 35% | 20% |
| Almeno un set passa G1 (t >= 3,3) | 20% | 10% |
| Passa G1-G4 | 10% | 5% |
| Il migliore dei 18 ha PF netto > 1,15 (il migliore del disegno 0) | 60% | 40% |
| Passa anche G6 (tick) | 6% | 4% |
| Il migliore ha H4 come timeframe | 50% | 50% |
Almeno uno dei due disegni arriva a G4: 13%.

## 6. Regole d'arresto
- Se NESSUN set di un disegno supera G1: **"nessun candidato" per quel disegno**, senza secondo batch e senza ritoccare soglie. Se nessuno dei due supera G1: la famiglia "breakout/rimbalzo a livelli sull'oro in questo spazio di parametri" e chiusa; si decide con Claudio se passare ad altro (per esempio gli EA nostri gia esistenti o il simulatore Python).
- Nessun finalista va in demo/conto prima di G1-G4 e G6 e di una decisione di Claudio.
- Soglie non ritoccate dopo aver visto i numeri; ogni set guardato in piu aggiorna il contatore e la soglia e viene dichiarato.

## 7. P2 dei due disegni (17/11/2026, sera; terminale FTMO, XAUUSD D1, 2019-01-01 -> 2019-03-01, template 1.03) - esito: SUPERATA, nessun difetto
- **Disegno 1 (breakout, stop 400 pt, target 1200 pt, pendenti persistenti):** stop esattamente 4,00 USD e target esattamente 12,00 USD dall'ingresso (es. buy stop 1285,16, stop 1281,16, target 1297,16); chiusure registrate come `sl`/`tp` ai prezzi previsti (-35,3 EUR a stop su 0,1 lotti); ordine opposto cancellato al riempimento; **i pendenti restano** finche non scadono o si riempiono (journal: "pendenti persistenti ancora attivi") e si riarmano alla barra dopo la scadenza (a 01:05 server, dopo i 10018 delle 00:00); una sola posizione alla volta; nessun ordine duplicato.
- **Disegno 2 (rimbalzo, limit, stop 1,0 ATR, target 1,0 R):** buy limit sotto e sell limit sopra il prezzo (es. buy limit 1236,61 con stop 1225,21 e target 1248,01: 11,40 e 11,40); riarmo a ogni barra con ritentativi (10018) fino alla riapertura; un ordine opposto cancellato al riempimento; 4 operazioni nel periodo, 3 a target e 1 a stop; una sola posizione.
- **Dettaglio da conoscere (non un difetto dell'EA):** la scadenza dei pendenti viene arrotondata dal tester alla mezzanotte successiva (es. 5 barre da 03/01 01:05 -> scaduti il 09/01 00:00 invece dell'08/01 01:05): la scadenza effettiva e fino a un giorno piu lunga. Vale per tutti i set allo stesso modo.
- **Previsione "almeno un difetto" (50%): sbagliata (nessun difetto).** I numeri del giro (9 e 4 operazioni) non si usano. Il batch dei 36 set (porta G1, t >= 3,3) puo partire.
