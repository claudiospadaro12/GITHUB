# Confronto ORB "Metodo Paolo" vs i nostri EA (R004)

Sala del Consiglio, 04/11/2026. Redatto da C0 sulle relazioni di A2 (`agents/A2/regole_P.md`), A7 (`agents/A7/confronto_regole_EA.md`) e A6 (`agents/A6/critica_pdf_e_rischi.md`). Nessun test eseguito, nessun dato analizzato, nessuna taglia/lotto. Le citazioni di codice sono di A7; C0 ne ha riletto 6 nel sorgente (vedi sezione 7). Il resto è **claim di agente**, non prova.

## 1. In una frase
Il nostro `ABTG_ORB_Ottimizzato` live **non è il metodo di Paolo**: condivide solo il box da 15 minuti e l'apertura USA. Ingresso, stop, target, gestione e filtri sono diversi. Inoltre il live gira su **XAGUSD e U30USD (Dow)**, non su Nasdaq né DAX.

## 2. Il PDF: cosa è e cosa vale (A2 + A6)
- Fonte **secondaria**: riassunto (Chromium, 04/11/2026) di una call. Nessun numero di performance: «profittevole», «testata, funziona», «Nasdaq funziona meglio» sono dichiarazioni, non prove. I "50 historical days" sono un'impostazione dell'indicatore per rivedere i box a occhio, **non** una validazione.
- 45 sotto-regole: **9 oggettive, 19 parziali, 14 discrezionali, 2 "non nel PDF"**. Il nucleo codificabile è piccolo: box 15 min sull'orario, candela M5 che apre e chiude fuori, ingresso alla chiusura, stop sul lato opposto, TP 1:1, formula della size.
- Contesto (medie, SuperTrend, VWAP, volumi, "trend battezzato la mattina"), resistenze H1/H4, "troppo lontana", retest, TP tecnico e gestione del residuo **non sono codificabili senza nostre invenzioni** (mancano periodi, soglie, regola di aggregazione).
- 35/41/53 punti sono **esempi, non soglie** (53 = "si abbandona"; gli altri con retest).
- Il metodo non è falsificabile così com'è (slide 14: «il disegno è tuo»): un test negativo non confuta Paolo, uno positivo non lo conferma. Ogni esito riguarderà **la nostra operazionalizzazione**, mai "il metodo di Paolo".
- Incongruenze interne (A2/A6): 100/31 = 3,2 e non "4 volte"; 143×3 = 429 e non 450; 0,22 lotti torna solo con stop 50; parziale a 30–40 punti con box da 31 (cade sotto 1R); tre uscite in conflitto (TP 1:1 / TP tecnico / il resto corre); "box stretto" premiato ma "stop troppo stretto" vietato; "aspetta la rottura della resistenza" (entra più lontano) vs "troppo lontana non si entra".
- Punti assenti: orario/durata del box DAX, S&P mai citato, orario limite d'ingresso, riarmo dopo falsa rottura, trade al giorno, filtro notizie, uscita di fine sessione.

## 3. Regola per regola contro i nostri EA (sintesi da A7)

| Regola di Paolo | ABTG_ORB (default webinar) | **ABTG_ORB_Ottimizzato LIVE** | ABTG_ORB_Emiliano (default) |
|---|---|---|---|
| Box 15 min dopo l'apertura | DIVERSA: 5 min **prima** (14:25–14:30) | IMPLEMENTATA 15:30–15:45 (giusta solo con USA in ora solare; la barra M1 delle 15:45 entra in parte) | DIVERSA (come ORB; `InpAutoUSDST` opt-in spento) |
| Candela M5 che apre e chiude fuori, spike esclusi | ASSENTE (ordini pendenti) | **DIVERSA**: pendenti STOP al tocco di livello+10 → lo **spike fa scattare l'EA** (`InpUseCloseConfirm=false`) | DIVERSA (come Ott) |
| Ingresso alla chiusura | DIVERSA (intrabar) | DIVERSA (intrabar, fino alle 22:00) | DIVERSA |
| Stop oltre il lato opposto del box | IMPLEMENTATA | **DIVERSA**: `SLMode=3` = **mezzo box** (`entry − 0,5×range`) | IMPLEMENTATA (default) |
| TP 1:1 («3R è ambizioso») | DIVERSA: 2R | **DIVERSA, opposto**: `TPMode=1`, mult 1,5 → TP = entry + 1,5×range = **3R sullo stop a mezzo box**. `InpTP_R=1.0` nel preset è **inerte** (trappola di lettura) | DIVERSA: 2R |
| Parziale 50% (DAX 30–40 pt) + BE+1 € | parziale = stesso prezzo del TP (superfluo) | **ASSENTE** (`TP1Pct=0` → anche il breakeven è inerte) | opt-in "Piano A" spento |
| Il resto: SuperTrend/swing a mano | trailing EMA9 M5 | trailing EMA9 M5 **senza soglia, dalla prima barra** | come ORB |
| Contesto (medie, SuperTrend, VWAP, volumi) | ASSENTE | **ASSENTE**; c'è un filtro EMA200 M5 (una volta alle 15:45), non nel PDF; `UseEmaFilter` e `UseVolumeFilter` non hanno effetto con i pendenti | ASSENTE (opt-in spenti) |
| Trend a favore / short speculare | entrambe le direzioni | **solo long** (`AllowShort=false`) | entrambe |
| Resistenze H1/H4, "troppo lontana", retest, TP tecnico, size ridotta | ASSENTE | ASSENTE | ASSENTE |
| Box stretto meglio di box largo | nessun filtro | `MaxRangePct=0,8%` (tetto molto largo, tipo diverso) | opt-in spento |
| Rischio 1–2% per trade, size da stop | IMPLEMENTATA | IMPLEMENTATA (1%); con stop a mezzo box il lotto è ~doppio rispetto a uno stop sul lato opposto, a pari rischio nominale | IMPLEMENTATA |
| Max 3% al giorno | ASSENTE | ASSENTE nel sorgente; Guardian in `.mqh` esterno **non nei materiali** → NON VERIFICATO | ASSENTE |
| DAX di mattina | ASSENTE | ASSENTE nel preset live | ASSENTE |
| Cambio ora legale | valori fissi | fissi, a mano (due volte l'anno) | solo USA, opt-in spento |

## 4. Le differenze che contano (ordine d'importanza)
1. **Ingresso**: Paolo = chiusura di M5 fuori dal box; EA live = ordine pendente al tocco. La regola che Paolo scrive per escludere gli spike non è applicata.
2. **Struttura rischio/rendimento**: Paolo = stop sul lato opposto, TP 1:1. EA live = stop a mezzo box, TP 3R. Sono **due strategie diverse** (stop più stretto, target più lontano, win rate attesa molto diversa).
3. **Gestione**: Paolo = parziale + BE+1 + resto manuale. EA live = nessun parziale, breakeven inerte, trailing EMA9 automatico senza soglia (rischio indicato dallo stesso Paolo: "stop troppo stretto che ti fa uscire").
4. **Filtri**: l'EA ha EMA200 e tetto 0,8%, che Paolo non cita; non ha nulla di ciò che Paolo cita (SuperTrend, VWAP, livelli).
5. **Strumenti/ora**: live su argento e Dow; Paolo parla di Nasdaq (sera) e DAX (mattina). Orari live corretti solo con USA in ora solare.
6. **Emiliano**: ORB, Ott ed Emiliano sono lo stesso codice con default uguali; la distinzione del PDF ("Emiliano = volatilità d'apertura, ORB = trend") nei nostri EA non ha un riscontro operativo.

Nota (C0): il preset live è un'ottimizzazione nostra; stop a mezzo box e TP 3R derivano dal lavoro precedente (l'header del sorgente cita R55 per lo stop "stretto"), non da Paolo. Questo confronto **non dice** se il live sia meglio o peggio del metodo: dice che sono diversi.

## 5. Cosa è testabile con i dati che abbiamo
| Elemento | Dati | Testabile? |
|---|---|---|
| Nucleo oggettivo su Nasdaq (box 15 min, M5 fuori, ingresso alla chiusura, stop opposto, TP 1:1) | Nasdaq `_EXT` M1 2010–2026 | **Sì**, con ora corretta per periodo e costi dichiarati |
| Stessa cosa su S&P | S&P `_EXT` M1 2010–2026 | Sì, come replica (il PDF non lo cita) |
| Nucleo su DAX | D30EUR M1 da 09/2024 (~550 sedute, meno dopo la divisione estate/inverno) | Solo **descrittivo**: campione piccolo; orario box DAX non nel PDF |
| Ingresso a pendente vs a chiusura (differenza 1) | stessi dati | Sì |
| Uscita live (mezzo box/3R) sugli stessi segnali (differenza 2) | stessi dati | Sì, con ordine intra-barra dichiarato |
| Contesto (medie, SuperTrend, VWAP, volumi, trend) | dati ok, **regole no** | **No** senza nostre invenzioni (A2/A6) |
| Resistenze H1/H4, TP tecnico, retest, "troppo lontana" | idem | No (soglie/definizioni assenti); solo proxy dichiarati come nostri |
| Gestione manuale del residuo | — | **Non replicabile** |
| Spread/slippage reali | M1 `_EXT` senza spread (da verificare) | Solo scenari di costo dichiarati |
| Giorni a notizia | calendario notizie non verificato | Solo come analisi di concentrazione |

## 6. Rischi di un backtest (A6, riassunto)
Look-ahead sui filtri (imbalance a 3 barre, swing, H1 in formazione); orario server GMT+1 fisso (Nasdaq = 14:30 server per tutta l'ora legale USA, anche negli scarti con l'Italia; DAX 8/9 con l'Europa): un solo `InpSessionHour` per anno dà risultati di un'altra strategia; entry a chiusura con spread/slippage; ordine intra-barra su M1 con livelli a 35–50 punti; gestione manuale non replicabile; soglie in punti su 16 anni (l'indice è cambiato di un ordine di grandezza → soglie relative); sovradattamento di 31/35/41/53; test multipli (8 scelte binarie = 256 combinazioni); deriva rialzista del Nasdaq (live solo long) senza benchmark; campione DAX piccolo; provenienza/fuso dei file `_EXT` da verificare.

## 7. Verifiche di C0 sulle citazioni di A7 (parziale, R008 non completo)
Riletti nel sorgente `ABTG_ORB_Ottimizzato.mq5` e nel preset: `SLforLong` con `ORB_SL_HALFRANGE` (`entry − 0,5×(high−low)`); calcolo TP in `TryPlace` (`InpTPMode==ORB_TP_RANGE ? buyPx+(range)*InpTPRangeMult : buyPx+dist*InpTP_R`); `InpTP1Pct<=0` → ritorno anticipato con avviso che il breakeven non si attiva; preset: `SLMode=3`, `TP_R=1.0`, `TPMode=1`, `TPRangeMult=1.5`, `TP1Pct=0.0`, `UseCloseConfirm=false`, `UseEma200Filter=true`, `MaxRangePct=0.8`. **Confermati.** Non riletti da C0: citazioni di `ABTG_ORB.mq5` e `ABTG_ORB_Emiliano.mq5` e le righe sul trailing/Guardian → affidate ad A7 per R008 completo.

## 8. Limiti
- PDF letto da A2 con controllo visivo di 5 slide, da A7 di 1 (slide 9), da A6 di 5: dettagli presenti solo in immagini possono mancare.
- Guardian (`ABTG_PausaGuardian.mqh`) non nei materiali; per Emiliano non c'è preset (default).
- Comportamenti dipendenti da tick/dati (primo tick delle 15:45, frequenza con cui il trailing EMA9 alza lo stop) **non verificati**.
- Nessun controllo di questo documento è un test: tutto ciò che richiede dati è `NON_ESEGUITO`.

## 9. Domande per Paolo (da A6, le 10 che chiudono i punti ALTA)
1) candela di ingresso: prima che chiude fuori o interamente fuori? Caso apre-dentro/chiude-fuori. 2) il colore conta? 3) box con ombre o corpi; orario box DAX e fuso del grafico. 4) parametri di medie/SuperTrend/VWAP/volumi e se sono obbligatori. 5) come "battezza" il mercato. 6) cosa sono le resistenze, "a ridosso", e cosa prevale tra "aspetta la rottura" e "troppo lontana". 7) "troppo lontana": soglia fissa o relativa, da dove. 8) uscita: 1:1 su tutta la posizione o TP tecnico sul resto; parziale per il Nasdaq. 9) box massimo e stop minimo; cosa significa "1:4". 10) esiste uno storico di trade reali con costi e con i trade scartati?
