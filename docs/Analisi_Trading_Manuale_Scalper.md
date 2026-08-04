# Analisi dello stile di trading MANUALE e Spec di un EA "Scalper"

**Strumento:** XAUUSD (Oro) — **Timeframe operativo:** M5 (5 minuti)
**Conto:** demo BCM Markets #50503392, EUR, **Hedge**, volume base 0.5 lotti
**Giornata analizzata:** 2026-06-18 (una sola sessione)
**Fonti:** `8054311f-ReportHistory50503392.xlsx` (trade manuali), `Gold_Ichimoku_TK_ATR_EA.mq5` (EA esistente), `Gold_Ichimoku_ATR_Indicator_v3.pine` (indicatori a grafico)

> **Nota metodologica fondamentale.** Tutte le statistiche qui sotto sono **FATTI** estratti dallo statement. Tutto ciò che riguarda *perché* il trader entra/esce è **INFERENZA** ricavata da **un solo giorno** di trading: non è un campione statisticamente valido per affermare l'esistenza di un edge. Le inferenze sono marcate come tali.

---

## 0. Premessa importante: due livelli di lettura dei dati

Lo statement può essere letto in due modi, ed è importante non confonderli:

- **Livello POSIZIONE (21 trade):** ogni ingresso a 0.5 lotti aperto e chiuso = 1 trade. È il framing della richiesta. Il profitto indicato per ciascuno è già **netto delle commissioni** (~1.75 EUR/posizione).
- **Livello DEAL / leg (36 operazioni):** il trader chiude le posizioni **in due tranche da 0.25** (chiusura parziale) più la chiusura finale. Lo statement MT5 calcola le sue statistiche ufficiali su questo livello (36 deal).

I due livelli danno numeri ufficiali diversi (entrambi corretti):

| Metrica | Livello POSIZIONE (21) | Livello DEAL (36, da statement) |
|---|---|---|
| Profitto netto totale | **+824.76 EUR** (comm. incluse) | **+788.07 EUR** netto |
| Operazioni vincenti | 85.7% (18/21) | 86.11% (31/36) |
| Profit Factor | 3.17 | 2.89 |
| Payoff atteso/op | — | 21.89 EUR |

Sotto uso il **livello POSIZIONE (21 trade)** come richiesto, segnalando dove il livello deal cambia la lettura.

---

## 1. Profilo statistico dei 21 trade (FATTI)

| Metrica | Valore |
|---|---|
| Numero trade (posizioni) | 21 |
| **Vincenti** | **18 (85.7%)** |
| Perdenti | 3 (14.3%) |
| Profitto netto totale (comm. incluse) | **+824.76 EUR** |
| Profitto lordo (somma vincite) | +1205.28 EUR |
| Perdita lorda (somma perdite) | −380.52 EUR |
| **Vincita media** | **+66.96 EUR** |
| **Perdita media** | **−126.84 EUR** |
| **Payoff ratio (avg win / avg loss)** | **0.53** (la perdita media è ~1.9× la vincita media) |
| Profit Factor (gross win / gross loss) | 3.17 |
| Vincita più ampia | +352.25 EUR (trade #17) |
| Perdita più ampia | −204.97 EUR (trade #13) |
| **Durata media trade** | **~5.6 min** (mediana 4 min; min 0, max 20 min) |
| Commissioni totali (deal-level) | 36.69 EUR |

**Bias direzionale (FATTO):**

| Direzione | N | Netto EUR |
|---|---|---|
| **SELL** | **17** | **+911.22** |
| BUY | 4 | −86.46 |

- I 4 long sono tutti concentrati a inizio sessione (14:31–14:40, fase ancora interlocutoria) più un long isolato alle 16:14 che è **la seconda perdita peggiore** (−164.01). Da metà giornata in poi è **solo short**.
- **Tutti e 3 i trade perdenti** (16:14 buy −164, 16:30 sell −11.5, 17:48 sell −205) avvengono nella fascia centrale 16:00–18:00; le due grosse perdite (−164 e −205) sono **controtrend o anticipi** sull'onda ribassista.
- Il grosso del profitto arriva nel finale 19:59–20:30 (trade #17–#21: +351 cumulati nei tre principali) cavalcando l'ultima gamba di discesa.

**Distribuzione oraria (FATTO):** operatività concentrata in finestra **pomeridiana/serale 14:30–20:30 (ora server/EU)**, con tre cluster:
- 14:31–14:40 (3 long di apertura),
- 15:07–16:39 (mix, fase più rumorosa, contiene 2 delle 3 perdite),
- 17:48 (1 perdita isolata) e poi **19:31–20:30** (8 short, la parte più redditizia).

**Dimensione posizione (FATTO):** sempre 0.5 lotti in ingresso, chiusi tipicamente in 2× 0.25 (chiusura parziale). Size **fissa**, nessuno scaling sul rischio.

---

## 2. Stile inferito (INFERENZE da 1 giorno)

Il profilo è coerente con uno **scalper momentum intraday direzionale (trend-following) con gestione attiva del trade**. In dettaglio le regole *probabili* che spiegano i dati:

**a) Ingressi (INFERENZA).**
- Scalping puro su M5: ingressi a mercato, durata media ~5 minuti.
- Entra **in direzione del trend dominante della sessione** (oggi ribassista → quasi solo short).
- Frequenti **ingressi multipli ravvicinati / piramidazioni** sulla stessa gamba (es. 20:01, 20:02, 20:03 tre short in 90 secondi; 14:31–14:32 due long): aggiunge posizioni mentre il movimento prosegue.
- Lo **stack a grafico** (Ichimoku TK Cross 7/22/44/26 + Bollinger 20/2 in "ESPANSIONE" soglia 80% + custom "IN-BULGE/POST-BULGE" e "ABTG") suggerisce che il trigger sia una combinazione di **cross Tenkan/Kijun nella direzione del trend** confermato da **espansione delle bande di Bollinger** (volatilità in apertura = momentum). *Quale di questi sia il trigger esatto NON è deducibile dai dati: va confermato.*

**b) Gestione del trade (FATTO + INFERENZA).**
- **Break-even rapido (FATTO):** lo statement è pieno di ordini `[sl ...]` posizionati **al prezzo di ingresso** pochi secondi/minuti dopo l'apertura. Es. trade #2: entry 4274.23 alle 14:32, SL spostato a 4274.22 (≈ entry) e chiuso lì. Appena il trade va in profitto, lo stop viene portato a pareggio.
- **Chiusura parziale (FATTO):** chiude metà posizione (0.25) presto, in profitto, e lascia correre il resto con SL a break-even. Es. trade #6: chiude 0.25 a 4245.95 (+36.6) e l'altro 0.25 a 4246.01 (+35.3). Questo "incassa subito + rischio zero sul resto" spiega l'altissimo win-rate.
- **Stop iniziale stretto (FATTO):** sui trade ben gestiti la distanza entry→SL iniziale è piccola (decine di cent). Le **perdite grosse** nascono quando lo SL iniziale è **più largo** (#8 buy: SL a 4242.83 contro entry 4250.55 = ~7.7$; #13 sell: SL a 4222.56 contro entry 4217.86 = ~4.7$) e il prezzo lo colpisce prima che scatti il break-even.
- **TP fisso solo occasionale (FATTO):** solo 2 trade su 21 hanno un TP impostato (#12 e #21). La regola normale è uscita discrezionale/parziale, non TP.

**c) Filtro temporale (INFERENZA).** Opera in una finestra pomeridiana/serale (sessione US dell'oro, alta liquidità/volatilità), evitando le ore morte.

**Sintesi onesta dello stile:** *scalper momentum trend-following su M5, size fissa, con break-even quasi immediato e take-profit parziale → win-rate molto alto ma payoff < 1.* Il sistema "vive" di tante micro-vincite e **dipende dall'evitare/limitare le poche perdite grosse**. Funziona benissimo in una giornata di trend pulito (come questa), ma è strutturalmente fragile (vedi §5).

---

## 3. Confronto con l'EA esistente `Gold_Ichimoku_TK_ATR_EA`

L'EA esistente è un **trend-follower posizionale su H1** (replica fedele del Pine v3), un sistema **completamente diverso** dallo scalping manuale.

| Aspetto | EA esistente (Gold_Ichimoku_TK_ATR) | Trading manuale (scalper) |
|---|---|---|
| **Timeframe** | H1 (entrate solo a barra H1 chiusa) | **M5**, ingressi a mercato infragiornalieri |
| **Logica ingresso** | Cross Tenkan/Kijun (Donchian 7/22/44) + filtro Kumo; opzionali ADX/Espansione/Kijun | Cross TK + **Bollinger in espansione** + custom (BULGE/ABTG); momentum in direzione trend (INFERENZA) |
| **Direzione** | Default **Solo LONG** (config "validata") | **Both**, ma di fatto **prevalentemente SHORT** seguendo il trend del giorno |
| **N. posizioni contemporanee** | **Una sola** (no piramidazione) | **Multiple/piramidazioni** (3 short in 90s) |
| **Durata trade** | **Ore/giorni** (lascia correre fino al cross opposto) | **~5 minuti** (mediana 4 min) |
| **Uscita** | EXIT_CROSS (cross opposto) + SL ATR iniziale 1.5×ATR | **Break-even rapido + chiusura parziale 50%**; TP solo sporadico; uscita discrezionale |
| **Gestione stop** | SL ATR fisso (o trailing chandelier/Kijun secondo modalità) | **SL → break-even** in pochi secondi appena in profitto |
| **Sizing** | **Rischio % del balance** (default 0.5%) → lotto variabile | **Lotto fisso 0.5** (chiuso in 2×0.25) |
| **Frequenza** | Pochissimi trade (cross H1 su oro ≈ ~90/anno) | **21 posizioni in mezza giornata** |
| **Filtro orario** | Nessuno | Finestra pomeridiana/serale (INFERENZA) |
| **Profilo R/R** | Payoff alto / win-rate basso (lascia correre i winner) | **Payoff basso (0.53) / win-rate altissimo (86%)** |

**Perché sono due sistemi diversi.** L'EA condivide con il manuale solo *gli indicatori a grafico* (Ichimoku TK, Bollinger), ma la **filosofia è opposta**: l'EA è un sistema posizionale a bassa frequenza che "lascia correre i winner" su H1 con poche operazioni; il manuale è uno scalper ad alta frequenza su M5 che "incassa subito e mette in sicurezza". Riconfigurare l'EA esistente (cambiare timeframe a M5, direzione Both) **non basta**: mancano break-even rapido, chiusura parziale, piramidazione e filtro orario. Serve un **nuovo EA**.

---

## 4. Spec del nuovo EA "Scalper" (proposta IMPLEMENTABILE — MQL5, XAUUSD M5)

Obiettivo: replicare lo stile manuale. Nome proposto: **`Gold_Scalper_TK_BB_BE_EA.mq5`**.
Sfrutta gli stessi indicatori già a grafico, così il trader riconosce la logica.

### 4.1 Logica di ingresso (proposta — DA CONFERMARE)
Ingresso a mercato su barra M5 chiusa quando **tutte** le condizioni sono vere:
1. **Trigger momentum:** cross Tenkan/Kijun (Donchian 7/22, come l'EA esistente) nella direzione candidata, **oppure** prezzo che rompe il bordo Bollinger nella direzione del trend (da decidere quale dei due — vedi §5/Conferme).
2. **Filtro espansione Bollinger:** `bbWidth >= SMA(bbWidth, sqzLen) * sqzFactor` (bande ESPANSE, non in squeeze) — riproduce lo stato "ESPANSIONE 80%" del grafico.
3. **Filtro trend/direzione:** prezzo dal lato corretto della Kumo e/o Kijun (per allinearsi al trend del giorno; oggi short = prezzo sotto nuvola).
4. **Filtro orario di sessione** attivo (vedi input).
5. (Opzionale) consenso degli indicatori custom IN-BULGE/POST-BULGE / ABTG — **non disponibili in MQL5**, vanno ricostruiti o tradotti dal trader.

### 4.2 Gestione del trade (cuore dello stile)
- **SL iniziale stretto:** `InpInitialSL_USD` in dollari oro (default proposto 1.5–2.0$) **oppure** `InpAtrMultSL × ATR`. *Lo statement mostra SL iniziali piccoli sui trade buoni; le perdite grosse vengono da SL larghi → meglio uno SL stretto fisso.*
- **Break-even rapido:** quando il profitto raggiunge `InpBE_TriggerUSD` (default 0.5$ di movimento favorevole), sposta lo SL a `entry ± InpBE_OffsetUSD` (default 0.0 = pareggio esatto, come `[sl @ entry]` nello statement).
- **Chiusura parziale:** quando il profitto raggiunge `InpPartial_TriggerUSD` (default 0.6$), chiudi `InpPartialPct` (default 50%) della posizione. Il resto resta con SL a break-even.
- **Uscita del residuo:** trailing opzionale (chandelier ATR) **oppure** uscita su cross opposto Tenkan/Kijun **oppure** TP opzionale a `InpRunnerTP_USD`. Default proposto: trailing stretto.
- **Piramidazione (opzionale):** consenti fino a `InpMaxConcurrent` posizioni nella stessa direzione finché il trend tiene (replica i tripli short). Default 1 (prudente); 3 per fedeltà.

### 4.3 Money management
- Lotto fisso (`InpFixedLot`, default 0.5) **oppure** rischio % (`InpRiskPercent`) calcolato sullo SL iniziale. Default proposto: rischio % (più robusto del lotto fisso usato manualmente).
- Limiti di sicurezza: max perdita giornaliera, max numero trade/giorno.

### 4.4 INPUT proposti (con default)

```
// --- Indicatori (coerenti con EA/Pine esistenti) ---
InpTenkan            = 7        // Donchian Tenkan
InpKijun             = 22       // Donchian Kijun
InpSenkouB           = 44       // Donchian Senkou B
InpBBLen             = 20       // Bollinger lunghezza
InpBBMult            = 2.0      // Bollinger deviazioni
InpSqzLen            = 50       // media bbWidth per espansione
InpSqzFactor         = 0.8      // fattore squeeze (soglia espansione ~80%)
InpUseExpansion      = true     // richiedi bande ESPANSE all'ingresso
InpUseKumoFilter     = true     // prezzo dal lato giusto della nuvola
InpUseKijunFilter    = false    // close oltre Kijun

// --- Trigger d'ingresso (DA CONFERMARE quale) ---
InpEntryTrigger      = TK_CROSS // {TK_CROSS, BB_BREAK, BOTH}
InpTradeDirection    = DIR_BOTH // Both / Long / Short

// --- Gestione (lo stile manuale) ---
InpUseAtrSL          = false    // true: SL = ATR×mult ; false: SL fisso in $
InpInitialSL_USD     = 1.5      // SL iniziale (dollari oro) se non ATR
InpAtrLen            = 14
InpAtrMultSL         = 1.5      // se InpUseAtrSL
InpBE_TriggerUSD     = 0.5      // profitto in $ che attiva il break-even
InpBE_OffsetUSD      = 0.0      // SL a entry + offset (0 = pareggio)
InpUsePartial        = true     // chiusura parziale
InpPartial_TriggerUSD= 0.6      // profitto in $ per la parziale
InpPartialPct        = 50.0     // % chiusa alla parziale
InpRunnerExit        = TRAIL    // {TRAIL, CROSS, TP}
InpAtrTrailMult      = 1.5      // trailing chandelier per il residuo
InpRunnerTP_USD      = 0.0      // TP opzionale residuo (0 = off)
InpMaxConcurrent     = 1        // posizioni contemporanee stessa direzione (3=fedele)

// --- Filtro orario di sessione (ora server) ---
InpUseTimeFilter     = true
InpSessionStartHour  = 14       // inizio finestra
InpSessionEndHour    = 21       // fine finestra (no nuove entrate dopo)

// --- Money management & sicurezza ---
InpUseFixedLot       = false
InpFixedLot          = 0.5
InpRiskPercent       = 0.5      // % balance per trade (se non fixed lot)
InpMaxTradesPerDay   = 25
InpMaxDailyLossUSD   = 250      // stop operatività oltre questa perdita
InpMaxSpreadPoints   = 0        // 0 = off; consigliato impostarlo su oro M5

// --- Generali ---
InpMagic             = 250618
```

### 4.5 Note implementative
- Conto **Hedge**: per la chiusura parziale serve `trade.PositionClosePartial()` (o `Sell/Buy` di chiusura su volume parziale) gestendo correttamente il ticket.
- Break-even, parziale e trailing vanno valutati **ad ogni tick** (lo scalper agisce in secondi), mentre il **segnale d'ingresso** va valutato a barra M5 chiusa per evitare repaint.
- Gli indicatori custom **IN-BULGE/POST-BULGE [Claudio]** e **ABTG** non esistono in MQL5: se sono parte del trigger reale vanno **portati/ricostruiti** prima di poter replicare fedelmente.

---

## 5. Cosa serve CONFERMARE dal trader (bloccante per fedeltà)

1. **Trigger d'ingresso esatto:** cosa fa scattare l'entrata? Cross Tenkan/Kijun? Rottura banda di Bollinger? Segnale di IN-BULGE/POST-BULGE o ABTG? Una combinazione? — *senza questo la replica resta congetturale.*
2. **Ruolo dei custom IN-BULGE/POST-BULGE e ABTG:** sono filtri o trigger? Qual è la loro logica (così da poterli ricostruire in MQL5)?
3. **Quando porta lo SL a break-even:** dopo un numero fisso di pip/dollari? Dopo X secondi? Dopo la chiusura parziale?
4. **Quando e quanto parzializza:** sempre 50%? A quale livello di profitto? Più tranche?
5. **Regole di piramidazione:** quante posizioni max nella stessa direzione e con quale criterio aggiunge?
6. **SL iniziale:** valore fisso (quanti $/pip) o basato su volatilità/struttura? (i dati mostrano SL eterogenei).
7. **Filtro direzione del giorno:** come decide se la giornata è "short-only" o "long-only"? (HTF? Kumo? bias discrezionale?)
8. **Finestra oraria** e fuso (server vs locale).

---

## 6. Avvertenze oneste (rischio)

- **Campione minimo:** 1 sola giornata, 21 posizioni. **Statisticamente irrilevante** per dimostrare un edge. Qualunque conclusione sullo stile è descrittiva, non predittiva.
- **Giornata di forte trend ribassista:** lo short era "facile". Il 92.9% di win-rate sugli short riflette il contesto, non necessariamente l'abilità o la robustezza del sistema.
- **Payoff < 1 (0.53):** la perdita media (−126.84) è **~1.9× la vincita media** (+66.96). Il sistema regge **solo** grazie all'altissimo win-rate. Bastano **poche perdite grosse consecutive** (o una news/spike) per azzerare molte micro-vincite: profilo **fragile** (rischio di coda, simile a vendere opzioni). Le due perdite del giorno (−164, −205) da sole valgono 5–6 vincite medie.
- **Costi di transazione:** lo scalping M5 sull'oro paga **molto spread e commissioni** (36.69 EUR di commissioni su 36 deal in mezza giornata). Su size reale e spread reale (non demo) l'impatto è significativo e può erodere l'edge.
- **Esecuzione su demo:** fill, slippage e spread su demo BCM sono più favorevoli del reale. Break-even "esatto" e parziali precisi sono più difficili dal vivo.
- **Tutto da backtestare e validare:** servono mesi di dati M5 reali con spread/commissioni realistici, walk-forward e test su giornate **non-trend / laterali / news** prima di considerare l'EA affidabile. Iniziare in demo, poi micro-size.

---

## Appendice — Dettaglio dei 21 trade (FATTI)

| # | Ora in | Tipo | Entry | SL iniziale | Ora out | Out | Profitto netto EUR | Esito |
|---|---|---|---|---|---|---|---|---|
| 1 | 14:31 | buy | 4269.71 | 4269.70 | 14:33 | 4270.34 | +27.24 | W |
| 2 | 14:32 | buy | 4274.23 | 4274.22 | 14:33 | 4275.03 | +34.85 | W |
| 3 | 14:34 | buy | 4271.88 | 4271.99 | 14:40 | 4272.23 | +15.46 | W |
| 4 | 15:07 | sell | 4243.07 | 4242.79 | 15:09 | 4242.56 | +22.44 | W |
| 5 | 15:10 | sell | 4242.83 | 4242.28 | 15:14 | 4242.21 | +27.25 | W |
| 6 | 15:20 | sell | 4247.63 | 4246.01 | 15:30 | 4245.98 | +71.89 | W |
| 7 | 16:10 | sell | 4252.84 | 4252.65 | 16:10 | 4252.29 | +24.17 | W |
| 8 | 16:14 | buy | 4250.55 | 4242.83 | 16:18 | 4246.79 | −164.01 | **L** |
| 9 | 16:26 | sell | 4238.89 | 4238.70 | 16:27 | 4238.48 | +17.65 | W |
| 10 | 16:29 | sell | 4238.18 | 4233.84 | 16:32 | 4235.58 | +113.27 | W |
| 11 | 16:30 | sell | 4231.78 | 4231.31 | 16:34 | 4232.05 | −11.54 | **L** |
| 12 | 16:33 | sell | 4228.42 | 4228.07 (TP 4222.76) | 16:39 | 4228.07 | +15.25 | W |
| 13 | 17:48 | sell | 4217.86 | 4222.56 | 18:02 | 4222.56 | −204.97 | **L** |
| 14 | 19:31 | sell | 4224.49 | 4223.87 | 19:34 | 4223.90 | +25.95 | W |
| 15 | 19:36 | sell | 4221.79 | 4221.76 | 19:40 | 4221.60 | +8.50 | W |
| 16 | 19:48 | sell | 4221.22 | 4220.47 | 19:52 | 4220.07 | +50.17 | W |
| 17 | 19:59 | sell | 4219.83 | 4204.38 | 20:19 | 4211.76 | +352.25 | W |
| 18 | 20:01 | sell | 4217.21 | 4211.02 | 20:07 | 4211.02 | +270.17 | W |
| 19 | 20:02 | sell | 4213.92 | 4213.85 | 20:03 | 4213.85 | +3.06 | W |
| 20 | 20:03 | sell | 4212.24 | 4209.79 | 20:08 | 4209.79 | +106.94 | W |
| 21 | 20:12 | sell | 4204.54 | 4209.14 (TP 4204.11) | 20:30 | 4204.11 | +18.77 | W |

*Profitti già netti delle commissioni (~1.75 EUR/posizione). Quasi tutti i trade mostrano nello statement un ordine `[sl @ entry]` (break-even) e una chiusura parziale 0.25 prima dell'uscita finale.*
