# Bulge VIOLA contro Breaking Band: perche' uno apre tantissimo e l'altro quasi niente (08/10/2026)

Mandato di Claudio (08/10): capire perche' il Bulge VIOLA (post-bulge, contro l'impulso, che lui chiama "inversione") apre tantissimi trade e il Breaking Band EA (`ABTG_BreakingBand.mq5`, che implementa la guida del corso) quasi nessuno, e confrontare la guida con il Bulge. Le due immagini mostrate sono dal PDF "Breaking Band - Esempi Operativi" (esempio 6.2 INVERSIONE valida, esempio 1.2 CONTINUAZIONE valida).

**SOLA LETTURA.** Nessun `.mq5`, preset o script toccato; nessun backtest lanciato; niente inviato a Claudio o al VPS. Il piano di misura del par. 4 e' **solo un piano**: lanciarlo e' una riga di lancio e passa dal cancello (strato 1 `controlla_riga.py` + strato 2 `controllo-preventivo`), che qui **non** sono stati invocati (questo file non e' ne' una riga di lancio ne' un verdetto che archivia un candidato).

Etichette: **[LETTO]** letto in un file del repo (riga citata) · **[DERIVATO]** calcolato da numeri scritti, il conto e' mostrato · **[INFERITO]** ragionamento dal codice, non verificato da una misura · **[NON MISURATO]** il dato non c'e'.

Versioni lette: `ABTG_BreakingBand.mq5` v1.05 (HEAD); `ABTG_Bulge.mq5` v5.20 (HEAD). Il binario BB in campo e' piu' vecchio (v1.02, `24f4b7a`; `report/CENSIMENTO_CAMPO_VS_MISURATO_2026-09-13.md` r.122-124 [LETTO]); il changelog v1.05 dice che con i default (`InpContEntryMode=0`) "nessun bit cambia" (`ABTG_BreakingBand.mq5` r.129-131 [LETTO]), quindi le righe citate valgono anche per il campo **a patto che quel changelog sia vero** [NON VERIFICATO sul binario].

---

## 0. Risposta in dieci righe

1. **Le due macchine non sono lo stesso metodo a cancelli diversi: sono due metodi.** Il BB e' la guida di Leonardo tradotta in una macchina a stati con **molti cancelli** (8 righe del par. 2 sono condizioni che il VIOLA non ha affatto); il Bulge VIOLA e' l'indicatore Pine di Claudio (`docs/breaking_band/indicatore_inbulge_claudio.pine` r.98-108 [LETTO]) tradotto riga per riga, e ha **6 condizioni piu' il filtro ATR** (r.1564-1574, 1391).
2. **Differenza n.1 (la piu' pesante): il VIOLA non richiede nessun bulge.** `isBulgeSig` (larghezza bande >= 1,1 x media a 50) e' calcolato in `CheckSignal` r.1404 ma e' usato **solo** da ARANCIO e BLU (r.1500-1506); la condizione del VIOLA (r.1564-1574) **non lo contiene**. Lo stesso nel Pine di Claudio (r.98-108: `postBulgeLong` senza `isBulge`) [LETTO]. L'"impulso" del VIOLA e' una **qualunque** candela direzionale col corpo >= 0,2 ATR che tocca la banda esterna (r.1436-1437). Il BB invece deve prima **validare un bulge**: fase >= 3 candele, >= 1 candela con range >= 1,5 ATR, movimento netto >= 1 ATR, larghezza >= 1,35 x, deviazione standard sopra la SMA50 (r.789-792, 872-886).
3. **Differenza n.2: il VIOLA non ha nessuna delle invalidazioni e dei controlli di "scarico" della guida.** Niente candele violente, zig-zag, spike, band riding, ri-espansione delle bande, deviazione standard in calo, bande in restringimento al retest. Il BB li ha tutti (r.941-985, 1206-1210).
4. **Differenza n.3: il Bulge non ha memoria e non consuma il setup; il BB si'.** Il Bulge rivaluta l'intera storia **a ogni barra chiusa**, per **40 barre** dopo l'impulso (r.1565), su **22 simboli** x 2 lati (r.463), con tetto 4 posizioni (r.412). Il BB lavora **un bulge alla volta** (r.781-783), la fase post dura **30 barre** (r.301) e il setup e' **consumato** al primo retest (r.1078), su **3 sedie** con pattern fissato per sedia.
5. **Frequenza misurata, stesso conto piccolo 50503392, stessi giorni (05-07/10):** Bulge VIOLA **19** posizioni chiuse (+3 BLU), BB **1** [LETTO, `report/giornata_2026-10-0{5,6,7}.md`]. Sull'apertura (CSV): VIOLA v5.20 **33 posizioni in 6 giorni di borsa (5,5/giorno)**, BB **5 in ~36 giorni di borsa a terminale acceso (0,14/giorno)** [DERIVATO da `data/statements/trades_auto.csv`; finestra 13/08-07/10, vedi par. 3.1] = circa **40 volte**.
6. Quel 40 si scompone in **~6x per numero di simboli** (>= 18 simboli VIOLA visti operare contro 3 sedie BB) **x ~6,6x per simbolo** (0,31 contro 0,046 operazioni per simbolo e giorno di borsa) [DERIVATO; il 6 sui simboli e' un limite inferiore, quindi il 6,6 per simbolo e' un limite superiore].
7. **Il BB non e' "rotto": fa quello che il suo contratto promette.** Contratto 772161/2/3 = ~2,0 + 1,0 + 0,8 = 3,8 op/mese (`report/CONTRATTI_SEDIE.md` r.136-138 [LETTO]); osservato 5 posizioni in ~1,6 mesi a terminale acceso (13/08-07/10 meno i sei giorni di terminale fermo 23-29/09) = ~3,0/mese [DERIVATO]. E il BB e' gia' stato **allentato per frequenza** (larghezza 1,5 -> 1,35, movimento netto 1,5 -> 1,0, `ABTG_BreakingBand.mq5` r.282/288).
8. **Il divario viene dal fatto che il VIOLA e' molto piu' largo, non dal fatto che sia piu' bravo.** Tutte le misure nostre sul Bulge stanno **sotto PF 1** (0,87 / 0,82 / 0,83 / 0,86 / 0,27, `report/BULGE_COME_MIGLIORARLO_2026-10-03.md` par. 1); sul BB il merito e' **sospeso** (n 11-26 < 150) e a 27,5 anni GBPUSD fa PF 0,897 (n 522, DD 23,43%) [LETTO]. **Piu' trade non e' piu' edge.**
9. **Quanto vale ciascuna condizione nel divario e' [NON MISURATO].** Esiste un solo funnel del BB (EURUSD, corsa solo CONTINUAZIONE, versione vecchia): 267 fasi tentate -> 62 bulge validi (23%) -> 8 trade; le invalidazioni di fase 2 sono contate anche per l'INVERSIONE, la fase 3 INV no (par. 3.1). Per il VIOLA non esiste nessun conteggio di candidati.
10. **Una misura a basso costo li separa** (par. 4): contare i segnali dei due rilevatori sullo stesso storico H1, aggiungendo/togliendo **una condizione della guida per volta**. Costo [STIMA]: 0 minuti di banco per la versione offline, ~15-60 minuti per quella nel tester; da firmare e passare dal cancello prima.

---

## 1. La guida, riassunta come elenco di condizioni (con la fonte)

Fonti: `docs/breaking_band/GUIDA_OPERATIVA_11.txt` (G, numeri = riga del `.txt`; pagina dal sommario r.10-33), `CHECKLIST.txt` (C), `PROMPT.txt` (P), `ESEMPI_OPERATIVI.txt` (E), `PROTOCOLLI_LEONARDO.md` (L).

**Nota sugli esempi [LETTO]:** `ESEMPI_OPERATIVI.txt` contiene **solo i titoli** (es. r.296-310 "6 Esempio n° 6 - INVERSIONE VALIDO / 6.1 Analisi pre-trade / 6.2 Follow-up post trade"); i grafici e le note stanno nelle immagini del PDF, che **nel repo non c'e' come testo**. Le quattro note di 6.2 che Claudio ha citato le prendo da lui, **non le ho potute verificare sul PDF**. Per l'esempio 1.2 (CONTINUAZIONE) Claudio non ha riportato le note: [NON DISPONIBILE].

### 1.1 INVERSIONE (post-bulge / contro-bulge)

| # | Condizione | Fonte |
|---|---|---|
| I1 | **Contesto**: la bulge sta in un trend gia' formato (rialzista a fine trend rialzista, ribassista a fine ribassista); **massima probabilita'** se e' la 3a bulge del trend (>= 2 precedenti). Detto come probabilita', non come cancello | G r.103-110 (p.4) |
| I2 | **Congestione iniziale** (CS standard, oppure CDA direzionale ammissibile) come fase preparatoria; la strategia si attiva solo se la congestione e' seguita da un bulge valido. Nella solidita' pesa 25% | G r.125-127, 186-188; C r.7-47 |
| I3 | **Bulge valido, tutti i criteri obbligatori**: bande 20/2 chiaramente espanse; deviazione standard sopra la SMA50 (o allontanamento strutturato da valori compressi); candele impulsive e direzionali **1,5-3 x ATR**; prezzo lontano dalla mediana; fase autonoma; **<= 20 candele**, niente band riding oltre 20 | G r.152-195 (p.6-7); C r.48-65 |
| I4 | **Rientro verso la mediana, che puo' superare leggermente, senza MAI toccare la banda opposta** (se la tocca il pattern non e' piu' inversione) | G r.81-83, 235-238, 252-253, 269-274, 314, 331; C r.72, 111-113, 186 |
| I5 | **Sequenza**: impulso con bulge -> rientro verso la mediana -> **retest (secondo tocco) della banda dell'impulso**: li' si entra, contro l'impulso | G r.88, 280, 305, 409-411; L Post-Bulge punti 1-3 |
| I6 | **Banda dell'impulso al retest piatta o inclinata a favore del trade** (short: piatta/discendente; long: piatta/ascendente), valutata **solo sulle 3 candele immediatamente precedenti** la candela di retest; contro = invalidazione automatica | G r.254-260, 338-342 (p.13) |
| I7 | **Bande in restringimento** dopo il bulge e **deviazione standard in calo** (idealmente sotto la SMA50: "il bulge deve essere finito"). Regola tecnica: in calo = >= 2 candele consecutive di discesa **oppure** sotto la SMA50 | G r.246-249, 261-264, 352-353, 396-399; P r.20-30 |
| I8 | **La banda dell'impulso non si gonfia di nuovo** durante il retest | G r.86, 386, 429 |
| I9 | **Rientro e retest non violenti**: "non e' richiesto rientro ordinato" (G r.123, 231) **ma** "il rientro e' violento composto da candele impulsive" invalida (r.92, 389); soglie scritte in due modi: candele **> 1 x ATR** nel rientro/retest (G r.318, 348; C r.174) e **> 1,5 x ATR** "impulsiva" (G r.378). Sono ammesse micro-rotazioni e piccoli zig-zag non impulsivi | G r.215-220, 318, 348, 378; C r.171-174 |
| I10 | **Nessun band riding** prolungato (20+ candele sulla banda dell'impulso) | G r.67, 421, 431 |
| I11 | **Tocco valido** solo se il corpo o lo spike interseca la banda; la sola prossimita' non basta | P r.14-19 |
| I12 | **Candela di reazione** (pin bar, doji di rigetto, piccolo engulfing non impulsivo): **regola opzionale / bonus non pesato** | G r.360-364; C r.209-217 |
| I13 | **News rosse** da evitare su H1/M30 | G r.365-366; C r.164 |
| I14 | **Uscite**: SL = 3 x ATR (regola fissa); TP obbligatorio sulla mediana, aggiornato "ogni 2-3 candele" (r.434) / "ogni 2-3 ore" (r.436: contraddizione interna); a >= 1 x ATR di profitto si puo' ridurre il rischio; mai allargare lo stop | G r.433-444; L Post-Bulge punti 3-4 |
| I15 | **Strumenti e universo**: MAJOR e MINOR; D1, H4, H1, M30; Bollinger 20/2; Standard Deviation con SMA50. **Nessun ADX** | G r.114-119 |
| I16 | **Solidita' pesata** (25 congestione / 25 bulge / 20 rientro / 15 bande / 10 test / 5 conferme): 85-100 ottimo ... < 55 debole | C r.192-206, 260-275 |

**Le 4 note dell'esempio 6.2 [LETTO da Claudio, non dal PDF]** corrispondono a: nota 1 "bulge dopo un trend rialzista" = I1; nota 2 "importante candela rialzista" = I3; nota 3 "ritracciamento sulla mediana e ritest della banda dell'impulso" = I4+I5; nota 4 "banda nel momento del retest valutata sulle 3 candele precedenti, ribassista e a favore di trend" = I6 (per uno short la banda superiore discendente e' "a favore", G r.256).

### 1.2 CONTINUAZIONE (in-bulge)

| # | Condizione | Fonte |
|---|---|---|
| C1 | **Contesto**: piu' efficaci le bulge nate in contesti di inversione (bulge ribassista a fine trend rialzista, rialzista a fine ribassista, **prima** bulge dopo un laterale). Probabilita', non cancello | G r.95-102 |
| C2 | Congestione iniziale e bulge valido: come I2-I3 | G r.125-127, 152-195; C r.7-65 |
| C3 | **Ritracciamento lento e diretto verso la banda OPPOSTA**, candele piccole, nessuna candela impulsiva, nessuno zig-zag marcato (micro-rotazioni ammesse), niente band riding 20+. "Ordinato" = almeno 80% di: nessuna candela > 1,5 x ATR; ombre <= 1,5 x corpo; range medio ridotto 30-50% (questi ultimi due "facoltativi") | G r.64-67, 215-228, 405-407; C r.74-100 |
| C4 | **La banda opposta DEVE essere raggiunta** (test obbligatorio), con candela non impulsiva; test impulsivo > 1,5 x ATR = invalidazione | G r.76-78, 242-243, 301, 330, 355, 379, 414; C r.138-140 |
| C5 | **Banda opposta: nessun requisito** di compressione o inclinazione ("puo' essere ancora gonfia"). **Contraddizione interna:** altrove la stessa guida chiede bande "in chiusura"/"in restringimento" anche per la continuazione | senza requisiti: G r.69-70, 240-244, 339, 358 · con requisiti: G r.71, 307, 353, 396-399 |
| C6 | **Deviazione standard** tornata sotto la SMA50 prima di entrare ("non entrare finche' la volatilita' non e' tornata normale") | G r.396-399; L In-Bulge punto 3 |
| C7 | **Entry** al tocco della banda opposta (corpo o spike); il protocollo di Leonardo dice "sul **retest** della banda opposta" | G r.73, 403, 408; L In-Bulge punto 4 |
| C8 | **Invalidazioni**: ritracciamento violento, candela > 1,5 x ATR, zig-zag prima della banda, band riding prolungato, test troppo violento | G r.74-79, 417-422 |
| C9 | Uscite, news, strumenti: come I13-I15 | G r.114-119, 365-366, 433-444 |

---

## 2. Regola per regola: guida | Breaking Band | Bulge VIOLA | chi e' piu' stretto

"Piu' stretto" = chi **esclude piu' setup**, giudicato **dal testo del codice**. Di quanto sia stretto, in operazioni, **non l'ho misurato** (par. 3-4).

| # | Regola | Guida | `ABTG_BreakingBand.mq5` (HEAD v1.05) | `ABTG_Bulge.mq5` VIOLA (v5.20) | Piu' stretto |
|---|---|---|---|---|---|
| 1 | **Contesto di trend** (bulge in trend formato; 3a bulge) | probabilita', I1/C1 (G r.95-110) | **assente** coi default: nessun controllo di bulge precedenti ne' di trend formato; l'unico filtro di trend del codice e' la pendenza della mediana del `InpContEntryMode=2` (solo CONT, default 0 = spento, r.317-319, 1145), che e' un'altra cosa [LETTO, grep] | **assente** | pari (nessuno lo implementa; e' la nota 1 di 6.2) |
| 2 | **Congestione iniziale** CS/CDA | preparatoria, peso 25% (C r.7-47) | `CongestionScore` r.706-751 calcolata a ogni bulge, ma `InpUseCongestionFilter=false` (r.338): solo loggata | assente | pari in pratica (BB l'ha ma spenta) |
| 3 | **Deviazione standard sopra la SMA50** (inizio bulge) | obbligatoria (G r.161-169; C r.55) | **obbligatoria**, `TryStartBulge` r.792 (`gStd[i] > gStdSma[i]`), e di nuovo per tenere viva la fase r.851 | **assente** (il Bulge non calcola la deviazione standard; `BB_Width_Len=50` e' la media della LARGHEZZA, r.265, 1202-1210) | **BB** |
| 4 | **Bande in espansione** | obbligatoria (G r.154-160) | larghezza >= **1,35 x** la media delle 20 barre precedenti (r.282, 789-791) | `isBulgeSig` = larghezza >= **1,1 x** media a 50 (r.266, 1404) **ma non entra nella condizione del VIOLA** (r.1564-1574); la usano solo ARANCIO/BLU (r.1500-1506) | **BB** (il VIOLA non la ha affatto) |
| 5 | **Soglia dell'impulso** ("importante candela" / 1,5-3 x ATR) | candele 1,5-3 x ATR, una dominante ammessa (G r.170-176; C r.57) | **>= 1 candela con range >= 1,5 x ATR** dentro la fase (r.821-823, 874; `InpBulgeMinImpBars=1` r.286; tetto 3x spento r.287) **piu'** fase >= 3 candele (r.872), netto >= 1,0 ATR (r.884), distanza dalla mediana >= 0,75 della semiampiezza (r.886) | impulso = **una barra** direzionale con **corpo >= 0,2 x ATR** che **tocca** la banda (`impDown`/`impUp` r.1436-1437): nessun minimo di durata, di range o di movimento netto | **BB, di molto** (corpo 0,2 ATR contro range 1,5 ATR: grandezze diverse, e il corpo e' sempre <= del range; il Bulge in piu' non chiede ne' fase ne' movimento netto) |
| 6 | **Finestra di barre** | impulso <= 20 candele; band riding > 20 (C r.63; G r.189-195) | bulge <= 20 (r.285, 857-858); post-bulge <= **30** dalla fine del bulge (r.301, 918) | impulso entro **20** barre dal segnale per ARANCIO/BLU (r.1501), entro **40** (`Lookback_Bars*2`) per il VIOLA (r.1565) | **BB** (30 dalla fine del bulge contro 40 dall'impulso; i punti di partenza sono diversi) |
| 7 | **Mediana toccata** dopo l'impulso | rientro verso la mediana, puo' superarla (G r.269-274) | `gReachedMedian` via `TouchMedian` r.640-641, 1061-1065 (un lato solo: per bulge giu' `high >= mediana`) | `midAfterImp`: una barra a cavallo della mediana (`high >= mediana >= low`) fra impulso e barra del segnale (r.1461-1467) | circa pari [DERIVATO]; il Bulge richiede la barra a cavallo |
| 8 | **Banda opposta mai toccata** | invalida se toccata (G r.93, 237, 252-253) | invalida alla **prima** barra che la tocca, compresa la barra del test (r.995-998) | `oppAfterImp` sulle barre fra impulso e barra del segnale (r.1465, 1474); **non** guarda la barra di conferma (`iCnf`) ne' la barra d'impulso (r.1461, 1470) | BB, di poco |
| 9 | **Banda dell'impulso piatta / a favore** (3 candele pre-retest) | piatta o a favore; contro = invalido (G r.254-260) | `SlopeBandaTest` r.666-675: barre i+1..i+3; tollerata una pendenza contraria di **0,05 ATR/barra** (r.312, 1202-1203); a favore: nessun limite | `lowerFlat`/`upperFlat`: `|banda(iSig) - banda(iSig+6)| <= 0,6 ATR` (r.1485-1488): **simmetrico**, su 6 barre, misurato sulla barra del segnale (non sulle 3 pre-retest); equivale a ~0,10 ATR/barra anche **contro** | BB sul lato "contro" (0,05 contro 0,10 ATR/barra); Bulge sul lato "a favore" (cap 0,6 ATR) [DERIVATO]; nel complesso **BB** |
| 10 | **Bande in restringimento** al retest | richiesto (G r.246-247, 352-353) | `BandeInChiusura` r.657-662, usata in `CheckEntryInversione` r.1206 (`Width(i) < Width(i+2)`) | **assente** | **BB** |
| 11 | **Deviazione standard in calo** al retest | richiesto (G r.262-264; P r.20-30) | `StdInCalo` r.647-654 (2 barre in discesa **oppure** sotto SMA50), usata r.1208 | **assente** | **BB** |
| 12 | **Banda non si rigonfia** | invalida (G r.86, 386) | morte della fase se larghezza > 1,05 x il massimo del bulge (r.970-976) e rifiuto se > 1,05 x la larghezza alla mediana (r.1210) | **assente** | **BB** |
| 13 | **Rientro violento / candele impulsive** | 1 candela > 1,0 ATR (G r.318, 348; C r.174) o > 1,5 ATR (G r.378) | INV: serve **un NUMERO di candele** > 1,5 ATR (`InpInvViolentBars=3`, r.295-296, 949-956); CONT: 1 candela > 1,5 ATR uccide (r.941) | **assente** (l'unico controllo e' `|corpo| <= 1,5 ATR` sulla barra di conferma, r.1324, quasi sempre vero) | **BB**; **ma sull'INV il BB e' PIU' LASSO della guida** (3 candele > 1,5 ATR contro 1 candela > 1,0 ATR): scelta dichiarata, changelog 1.01 punto A1 (r.189-197) |
| 14 | **Zig-zag / spike profondi / disordine** | da evitare (G r.367-368; C r.183) | zig-zag r.966-968 (solo CONT, candela contraria >= 1,5 ATR); spike con ombra >= 1,5 ATR r.958-964 (entrambi) | **assente** | **BB** |
| 15 | **Band riding** 20+ candele | invalida (G r.67, 421) | r.859-860 (nella fase bulge) e r.978-985 (nella fase post) | **assente** | **BB** |
| 16 | **Tocco della banda al retest** | corpo/spike interseca la banda (P r.14-19) | `TouchImpulseBand(i, 0,15 x ATR)`: conta il tocco anche a **0,15 ATR dalla banda** (r.314, 631-636, 1073-1074; buffer di Leonardo, L Post-Bulge punto 3) | `lows[iCnf] <= bbLowerCnf` (r.1567): tocco **vero** | **Bulge** (il BB e' piu' largo di 0,15 ATR) |
| 17 | **Candela di reazione** (bonus) | opzionale (G r.360-364) | `InpUseReversalCandle=false` (r.322, 1216) | VIOLA-EA `|corpo| <= 1,5 ATR` (r.1324; default r.290) oppure VIOLA-PINE `close>open` (spenta) | pari: nessuno dei due la usa come filtro |
| 18 | **Un trade alla volta** | non nella guida (e' scelta del BB) | `InpMaxPositions=1` per sedia (r.347, 1089) | 1 per (simbolo, commento) (r.1069-1079) **piu'** `Max_Trades=4` in totale (r.412, 855, 1247) | **BB** |
| 19 | **Filtro ADX** | **non e' nella guida** (r.118-119: Bollinger e deviazione standard) | **assente** (grep) | ADX >= 30 blocca (r.367-369, 1176-1197) ma **solo sul BLU** (`ADX_Apply_On_Purple=false`, r.371) | pari sul VIOLA: nessuno dei due lo applica |
| 20 | **Filtro di regime ATR** | non nella guida | **assente** | `AtrOk`: ATR di barra 1 fra 0,5 e 1,8 x la sua media a 20 (r.358-361, 1149-1160, 1391) | **Bulge** (unico filtro dove e' piu' stretto; nell'AMPIA di R92BAB era spento, nel preset trial acceso) |
| 21 | **Kill switch** giornaliero | non nella guida | assente | 4 SL/giorno, 3 consecutivi, -2,0% (r.393-396) | Bulge |
| 22 | **News rosse** | da evitare (G r.365-366) | opzionale, spento (r.351) | opzionale a ore UTC fisse, spento (r.378) | pari |
| 23 | **Universo / pattern** | MAJOR e MINOR, D1-M30 (G r.114-117) | **1 simbolo per sedia**, 3 sedie (GBPUSD INV+CONT, EURUSD solo CONT, AUDUSD solo INV), H1 | **22 simboli** (r.463), H1 cablato (r.605-607), entrambi i lati su tutti | **BB** |
| 24 | **Stato e consumo del setup** | — | macchina a stati: un bulge alla volta (r.781-783), setup consumato al primo retest (r.1078), `ResetPattern` | **nessuno stato**: ogni barra chiusa ricalcola tutto (r.849-857); lo stesso impulso puo' dare piu' ingressi, uno dopo la chiusura del precedente | **BB, di molto** [LETTO nel codice; effetto [NON MISURATO]] |
| 25 | **SL / TP** | SL 3 x ATR, TP mediana (G r.433-434) | SL 3 x ATR (r.1297), TP mediana aggiornato a ogni barra (r.577, 1304) | SL 3 x ATR (r.1254), TP mediana aggiornato a ogni tick (`UpdateAllTP`, r.864) | pari |

**Riepilogo del par. 2 [DERIVATO, conto delle 25 righe].** Il BB e' piu' stretto in **15** (righe 3, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14, 15, 18, 23, 24), il Bulge in **3** (16 tocco vero, 20 ATR di regime, 21 kill switch), pari in **7** (1, 2, 7, 17, 19, 22, 25). Le tre righe dove il Bulge e' piu' stretto sono **regole che non stanno nella guida** (ATR, kill switch) oppure una differenza di 0,15 ATR: non compensano le **8 righe (3, 4, 10, 11, 12, 13, 14, 15)** dove il VIOLA **non ha proprio** la condizione, piu' la riga 5 dove ne ha una versione molto piu' debole.

**Dove il BB NON e' la guida [LETTO]:** (a) numerose soglie "SCELTA NOSTRA" per i punti in cui la guida e' visiva (header r.94-97; 14 scelte dichiarate in `backtest_pipeline/prove/BREAKING_BAND_TESI.md`, tesi congelata v2); (b) INV piu' lasso della guida (riga 13); (c) buffer 0,15 ATR sul tocco (riga 16); (d) la solidita' % e' calcolata ma non filtra (`InpMinSolidita=0`, r.325). **Dove la guida si contraddice e il BB ha dovuto scegliere:** C5 (bande in chiusura sulla CONT), I9 (soglia 1,0 o 1,5 ATR), I14 (TP ogni 2-3 candele o ore).

---

## 3. FREQUENZA misurata (ogni numero con la sua fonte)

### 3.1 Breaking Band

| Misura | Cella | Finestra | n | Per anno [DERIVATO] | Fonte |
|---|---|---|---:|---:|---|
| Walk-forward OOS a tick, 10k | GBPUSD H1, pattern 2 (772161) | 2025.06.10-2026.06.30 (~13 mesi) | **26** (IS 13) | ~24,5 | `risultati_archivio/REFERTO_ROUND33_BREAKINGBAND_WF.md`; `RESOCONTO_EA_G4_FOREX_AGOSTO_2026-10-05.md` r.32 [LETTO] |
| idem | EURUSD H1, solo CONT (772162) | idem | **13** (IS 4) | ~12,3 | idem r.33 |
| idem | AUDUSD H1, solo INV (772163) | idem | **11** (IS 5) | ~10,4 | idem r.34 |
| 6,5 anni a barre `[B]` (R103) | GBPUSD / EURUSD / AUDUSD | 2020.01.01-2026.06.30 | **126 / 59 / 64** | 19,4 / 9,1 / 9,8 | `R103_REFERTO_FINALE.md` r.23-25 |
| 27,5 anni a barre `[B]` (R102) | GBPUSD / EURUSD / AUDUSD | 1999.01-2026.06.30 | **522 / 276 / 239** | 19,0 / 10,1 / 8,7 | `R102_REFERTO_BLOCCO1.md` r.38-40 |
| M30 (R111), OOS | GBPUSD / EURUSD / AUDUSD | 2022.07-2026.06 (4 anni) | **174 / 104 / 72** | ~43 / 26 / 18 | `RESOCONTO_EA_G4...` r.38 (riga 1g); M30 e M15 sono TF chiusi per PF < asticella |
| Contratto di frequenza | 772161 / 772162 / 772163 | promesso | ~2,0 / ~1,0 / ~0,8 al mese | -- | `report/CONTRATTI_SEDIE.md` r.136-138 |
| **Forward demo (piccolo 50503392)** | le 3 sedie | 13/08 (vivaio, `CAMPAGNA_ARSENALE.md` r.23-25) - 07/10 (ultima riga del CSV) = 40 giorni di borsa, meno 24, 25, 28, 29/09 a terminale fermo (23/09 19:35 - 29/09 ~19:40, `giornata_2026-09-29.md` r.107-108, 121-122) = **~36** | **5** posizioni (GBPUSD INV S 20/08; GBPUSD INV L 27/08; AUDUSD INV L 31/08; EURUSD CONT S 31/08 e 06/10) | 0,14 al giorno; ~3,0/mese | `data/statements/trades_auto.csv`, righe con `strategy` che inizia per "BB" [DERIVATO]; il G4 contava 4 fino al 18/09 (`RESOCONTO_EA_G4...` r.175). Altri fermi del terminale fra 13/08 e 23/09 [NON VERIFICATI]: se ci sono, il passo BB e' sottostimato |
| Forward 22/08 | le 3 sedie | primi giorni | 1 / 0 / 0 | -- | `CENSIMENTO_FREQUENZA_FLOTTA_2026-08-22.md` r.104-106 |
| **Funnel EURUSD H1, solo CONT** | 772162-like | finestra non scritta nel file; cartella `cal1` (`@DAQUANDO 2024.09.26`), fine 2026.06.29 -> ~21 mesi [INFERITO] | tentati **267** -> arrivati a validazione 267 (corti 91, senza impulsive 82, netto scarso 32) -> **62 bulge validi** -> CONT morti: candela > 1,5 ATR 19, zig-zag 24, spike 1, rigonfio 4 -> 9 segnali -> **8 trade** | -- | `backtest_pipeline/risultati_prove/ABTG_BreakingBand/cal1/funnel_bb_EURUSD.txt` [LETTO]. **Versione vecchia del codice** (il formato non ha `contEntryMode` ne' `rr`; la soglia del rientro stampata e' 1,00 ATR): ordine di grandezza, non una misura della v1.05 |

Lettura [DERIVATO]: la famiglia BB fa **~9-19 operazioni all'anno per sedia** (media di lungo periodo), cioe' **0,7-1,6 al mese**. Il suo obiettivo di taratura (cal1) era proprio "1-4 trade/mese per simbolo" (`prove/CAL_BB_DETECTOR.txt` r.7-10 [LETTO]).
**Buco [NON MISURATO]:** nessun funnel **completo** dell'INVERSIONE. Nello stesso file la **fase 2 INV c'e'** (la macchina tiene vivi entrambi i pattern anche con `pattern=0`): dei 62 bulge validi l'INV ne perde **51** (rientro violento 29 con la soglia vecchia "3 candele > 1,00 ATR", spike 2, rigonfio 8, tocco della banda opposta 12), mediana raggiunta 41, **11 retest** della banda dell'impulso [LETTO, r. "FASE 2 INV" e "FASE 2"]. La **fase 3 INV** (pendenza, bande in chiusura, deviazione standard, rigonfio al retest) e' a zero perche' la corsa era `pattern=0` (solo CONT) e i retest non sono stati valutati, non perche' fossero assenti.

### 3.2 Bulge VIOLA

| Misura | Cella | Finestra | n | Per simbolo / giorno [DERIVATO] | Fonte |
|---|---|---|---:|---|---|
| Backtest di **Claudio** (agli atti, non nostro) | BLU+VIOLA, GBPUSD + 5 cross, rischio 3%, dati al 40% | 2022.01.01-2026.03.30 (4,24 anni) | **268** | 63/anno; **10,5 per simbolo e anno** | `ABTG_Bulge.mq5` r.27-39; `R92_REFERTO.md` r.27-30 [LETTO]. Il **VIOLA da solo [NON MISURATO]**: il backtest e' BLU+VIOLA |
| **R92** (21/08), v5.10 col difetto del primo tick | solo VIOLA-EA (BLU e PINE impossibili), 22 cross | 2022.01.01-2026.06.30 | **106** | **1,07 per simbolo e anno** (4,8 per simbolo in 4,5 anni) | `R92_REFERTO.md` r.27-33, 104-110 [LETTO] |
| **R92BAB** (01/10), v5.20, Modello 1 OHLC | "AMPIA" (Blu+Viola+Arancio, ATR spento, Multi 1,0): **VIOLA sui 15 cross del trial** | 04/05-29/06/2026 (2 mesi) | **128** | **64/mese; 4,3 per cross e mese; ~51 per cross e anno** | `prove/BULGE_M1_cella_campo_lunga.txt` ("COSA SI ATTENDE"); `BULGE_COME_MIGLIORARLO_2026-10-03.md` par. 1 [LETTO]. VIOLA sui 22 cross: 190 (stessa riga, 4,3 per cross e mese) |
| Forward **antenato** (versione vecchia, difetto del primo tick), piccolo | `BULGE_MULTI_SIGNAL`: BLU **238**, VIOLA **50**, ARANCIO 9 = 297 | 01/04-08/06/2026 (49 giorni di borsa) | **50 VIOLA** | 1,02 al giorno sul basket; 0,046 per simbolo e giorno (22 simboli) | `data/statements/trades_auto.csv` [DERIVATO]; il 297 e' in `BULGE_COME_MIGLIORARLO...` par. 1 |
| Forward **piccolo xlsx**, versione vecchia | BLU+VIOLA, 22 cross | 30/04-30/09 | 159 | -- | `BULGE_PICCOLO_PER_CROSS_2026-10-01.md` r.3 (non riconciliato col 297 sopra: filtri/finestre diversi) |
| **Forward v5.20, piccolo 50503392** | **VIOLA** 33 (19 L + 14 S); BLU 13 | aperte 30/09-07/10 (**6 giorni di borsa**: 30/09, 01, 02, 05, 06, 07) | **33 VIOLA** (+13 BLU) | **5,5 VIOLA al giorno**; per giorno: 7, 3, 4, 9, 6, 4; >= 18 simboli diversi (EURNZD 5, USDCHF 3, USDJPY 3, ...) -> **0,31 per simbolo e giorno** (limite superiore, perche' i simboli sono >= 18). **Attenzione:** 2 delle 33 sono **XAUUSD** (02/10 e 06/10), che **non** sta nella lista di r.463 ne' in nessuno dei tre preset `sedie_piccolo/ABTG_Bulge_v520_piccolo_*.set` del repo: l'universo vero dell'istanza in campo e' [NON VERIFICATO]. E il CSV contiene **solo posizioni chiuse** (ultima chiusura 07/10 19:05): le aperture ancora aperte a quell'ora mancano, quindi 33 e' un limite inferiore | `data/statements/trades_auto.csv` (strategy `BULGE_V520_VIOLA_*`, magic 772700) [DERIVATO] |
| stesso, per giorno di chiusura | VIOLA | 05/10: 3L+2S = 5 · 06/10: 4L+5S = 9 · 07/10: 2L+3S = 5 | **19 chiuse in 3 giorni** (+3 BLU) | -- | `report/giornata_2026-10-05.md` r.25-28; `-06.md` r.23-24; `-07.md` r.25-29 [LETTO] |
| **Trial FTMO 1514806751** (preset VIOLA, 15 cross, piu' una seconda istanza con lista larga) | solo VIOLA | 01-06/10 (6 giorni di calendario = **4 giorni con aperture**: 01, 02, 05, 06) | **19** (10 vinte, netto -4.925,49) | 4,75 al giorno di borsa | `report/FTMO_TRIAL_AUTOPSIA_2026-10-08.md`; la separazione per commento VIOLA/BLU l'ho fatta io contando i commenti delle 19 aperture in `data/statements/ReportHistory_trial_1514806751_2026-10-08.xlsx` (il file ha un foglio solo; il commento sta nella sezione "Affari", colonna "Commento" delle righe `in` -- nella sezione "Ordini" quella colonna e' vuota: 11 `BULGE VIOLA_VIOLA_L`, 4 `..._S`, 1+1 `BULGE_V520_FT_VIOLA_*`, 1+1 `BULGE_VIOLA_*`) [DERIVATO] |

### 3.3 Confronto diretto

| | BB (3 sedie) | Bulge VIOLA v5.20 (piccolo) | rapporto [DERIVATO] |
|---|---:|---:|---:|
| Posizioni **chiuse** il 05-06-07/10, stesso conto | 1 (`BB EURUSD CONT S`, 06/10) | 19 VIOLA (+ 3 BLU) | 19 a 1 |
| Aperture per giorno di borsa | 0,14 (5 su ~36) | 5,5 (33 su 6) | ~40x (44x se si contano anche i giorni a terminale fermo) |
| ...per simbolo e giorno di borsa | 0,046 (3 simboli) | <= 0,31 (>= 18 simboli) | <= ~6,6x |
| Per simbolo e anno, lungo periodo | 8,7-19 (R102) | ~51 (R92BAB, 2 mesi, Modello 1, ATR spento) | ~3-6x |
| Per simbolo e anno, backtest di Claudio | -- | 10,5 (BLU+VIOLA, versione col primo tick) | **circa uguale a BB EURUSD/AUDUSD (10,1 / 8,7)** |

**Tre cose che il confronto dice e che e' facile perdere [DERIVATO]:**
1. Nel **backtest di Claudio** il Bulge faceva ~10,5 operazioni per simbolo e anno: **come il BB**, non 40 volte di piu'. "Tantissimi" nasce dal **v5.20** (lettura su barre chiuse) piu' dal **numero di simboli**. Il changelog lo prevedeva in direzione ("piu' operazioni", r.344-350) ma non in grandezza.
2. Il forward **antenato** faceva 50 VIOLA in 49 giorni su 22 simboli (0,046 per simbolo e giorno) = **lo stesso passo del BB** (0,046); il v5.20 e' **~5 volte** sopra l'antenato (sul cesto: 5,5 contro 1,02 al giorno). **La causa di questo salto interno al Bulge e' [NON MISURATA]**: candidati (non verificati) sono il difetto del primo tick sul simbolo del grafico, la saturazione di `Max_Trades` da parte di 238 BLU, regimi diversi (aprile-giugno contro fine settembre-ottobre), preset diversi.
3. Il campione del v5.20 e' **6 giorni di borsa, 33 eventi**: errore di Poisson ~17% (1 sigma) sul passo, **ma** non cambia l'ordine di grandezza.

---

## 4. IPOTESI sulla condizione piu' stretta che spiega il divario, e come misurarla

### 4.1 Le ipotesi (in ordine di peso atteso)

| ID | Ipotesi | Cosa e' LETTO | Cosa e' INFERITO | Misurata? |
|---|---|---|---|---|
| **H1** | **Il VIOLA non richiede un bulge, il BB si'.** Il BB scarta il 77% delle fasi tentate prima ancora di guardare il ritracciamento; il VIOLA parte da un qualunque tocco di banda con una candela da 0,2 ATR | VIOLA senza `isBulgeSig` (r.1564-1574 contro r.1500-1506); impulso 0,2 ATR (r.1436-1437); BB: bulge a 6 condizioni (r.789-792, 872-886); funnel EURUSD: 62 su 267 | che i tocchi di banda con corpo >= 0,2 ATR siano di ordini di grandezza piu' numerosi dei bulge validati: **plausibile ma senza un numero** | **no** |
| **H2** | **Il VIOLA non ha le invalidazioni della fase post.** Nel funnel CONT del BB i cancelli di fase 2 uccidono **48 dei 62** bulge validi (77%): candela > 1,5 ATR 19, zig-zag 24, spike 1, rigonfio 4 | assenti nel VIOLA (righe 13-15 del par. 2); numeri del funnel (versione vecchia) | quanti dei VIOLA aperti **avrebbero** violato una di queste: non si sa. Sull'INV, nella stessa corsa, la fase 2 ne uccide 51 su 62 (soglia vecchia del rientro, par. 3.1) | **no** (solo il BB; CONT completa, INV solo fasi 1-2) |
| **H3** | **Stato e consumo.** Il VIOLA puo' riaprire sullo stesso impulso per 40 barre, il BB entra una volta e azzera | r.849-857, 1565 contro r.781-783, 1078 | che una parte dei 33 VIOLA siano "ripetizioni" dello stesso impulso (es. EURNZD 5 VIOLA in 6 giorni): **non verificato** | **no** |
| **H4** | **Moltiplicatore simboli/lati.** 22 simboli x 2 lati contro 3 sedie con pattern fissato | r.463; `CONTRATTI_SEDIE.md` r.136-138 | -- | **si', in parte**: ~6x [DERIVATO, par. 3.3] |
| **H5** | **Al retest il BB pretende bande in restringimento, deviazione standard in calo, banda non gonfia, pendenza <= 0,05 ATR/barra; il VIOLA solo `|banda - banda[6]| <= 0,6 ATR`** | r.1201-1210 contro r.1485-1488 | peso: nella fase 3 CONT del funnel muoiono solo 4 su 13 (`bandeNonChiuse`); **sull'INV il funnel di fase 3 non c'e'** | **no** |

**Quale condizione e' "la" spiegazione:** H1 e H2 sono le due candidate; H4 e' misurata ed e' la parte facile del divario. **Non posso dire quale fra H1, H2, H3, H5 pesi di piu'**: nessuna e' stata isolata. Il divario per simbolo (~3-6x) puo' derivare da una sola di esse o da tutte.

### 4.2 Il piano di misura (NON ESEGUITO)

**Domanda unica:** sullo **stesso storico H1** e sugli **stessi simboli**, quanti segnali conta ciascun rilevatore se si **aggiunge/toglie una condizione della guida per volta**? Non e' una griglia di parametri: sono **ablazioni di meccanismo** (permesse dal motto e dalla regola del 19/08, che vieta le griglie sui parametri, non le misure di meccanismo).

**Misura A -- il Bulge VIOLA con le condizioni della guida aggiunte una alla volta** (la direzione che dice "quanto costa essere come il BB"). Passi cumulativi sul rilevatore VIOLA, sempre contando i candidati, **non** i trade:
- A0: VIOLA com'e' (r.1564-1574) = riferimento;
- A1: + `isBulgeSig` (la larghezza che il VIOLA non usa);
- A2: + deviazione standard > SMA50 all'impulso (condizione 3 della guida);
- A3: + impulso = range >= 1,5 ATR, fase >= 3 barre, netto >= 1 ATR (condizione 5);
- A4: + nessuna candela > 1,5 ATR / zig-zag / spike dopo l'impulso (righe 13-14);
- A5: + bande in restringimento e deviazione standard in calo al retest (10-11);
- A6: + setup consumato al primo retest (una sola apertura per impulso).
In parallelo la lettura **inversa** (leave-one-out: parto da A6 e tolgo una condizione per volta), perche' l'ordine cumulativo da' pesi diversi da quello a una condizione.

**Misura B -- il Breaking Band con le condizioni rilassate** (la direzione opposta). Il BB ha gia' i contatori `cB_*`, `cX_*`, `cE_*` e molti interruttori (`InpBulgeWidthMult`, `InpBulgeMinBars`, `InpBulgeMinImpBars`, `InpBulgeNetMoveATR`, `InpInvViolentBars`, `InpZigZagATR`, `InpDeepSpikeATR`, `InpReinflateTolPct`, `InpBandRidingMaxBars`, `InpPostBulgeMaxBars`); **mancano** gli interruttori per spegnere "bande in restringimento" e "deviazione standard in calo" sull'INV (r.1206-1208, cablati) e per saltare la validazione del bulge (H1).

**Come girarla (due strade, la prima per prima):**
1. **Offline su H1 OHLC esportate** (0 minuti di banco nel tester): uno script Python che ricalcola i due rilevatori (Bollinger 20/2, ATR 14, deviazione standard 20 con SMA50) e conta i candidati per ablazione. **Prima di fidarsi** lo script va **verificato sui gemelli**: deve riprodurre gli ingressi veri gia' scritti (per il BB, le 26/13/11 posizioni con data di `risultati_prove/trades_bb/`; per il Bulge, le aperture VIOLA del forward in `trades_auto.csv` e i 128 del R92BAB). Se non li riproduce, la misura non vale. Costo [STIMA]: scrittura + gemelli = lavoro di sviluppo, nessun tempo di banco; calcolo dei conteggi sulle 3 coppie x ~27 anni = secondi-minuti [NON MISURATO].
2. **Nel tester (Modello 1)** con copie `banco` dei due EA con contatori aggiunti (comportamento di trading identico, `mql5-ea-developer` + cancello; **mai** il campo). Riferimenti di costo [LETTI]: BB GBPUSD H1 1999-2026, 14 passate = 272 s (19 s/passata, `RESOCONTO_EA_G6B...` r.195); Bulge: 94,98 minuti proiettati per 26 passate di 16,5 anni su 22 cross (~3,7 minuti a passata, `prove/BULGE_M1_cella_campo_lunga.txt` r.80-84; `BULGE_COME_MIGLIORARLO...` par. 3 r.105 riporta solo i ~3,7 minuti): **proiezione da un controllo FALLITO, ordine di grandezza**. Per le 7 ablazioni A0-A6 x 3 simboli: BB 7 x 3 x 19 s = ~7 minuti; Bulge 7 x 3,7 min = ~26 minuti sul cesto da 22 (meno se limitato ai 3 simboli) [STIMA da riferimenti, [NON MISURATO] su queste celle]. **Gira sul PC di backtest, mai sul VPS** (regola del 21/09).

**Attese scritte PRIMA dei numeri (da congelare, non sono soglie):**
- se H1 e' la causa dominante, A1+A3 devono far scendere i candidati del VIOLA di **ordini di grandezza (>= 5x)** verso il passo del BB;
- se A0->A6 ancora lascia il VIOLA >= 3x sopra il BB per simbolo, la causa e' altrove (H3 stato/consumo, H5, o i simboli) e va misurata separatamente;
- il passo del BB per simbolo e' **8,7-19 l'anno** (R102): se l'A6 sul VIOLA cade **in quella banda**, i due rilevatori sono equivalenti a meno del setup.

**Contro-esempio costruito (la banda va provata contro l'ipotesi alternativa, non contro il nulla):** se la spiegazione fosse **solo il numero di simboli** (H4) e non le condizioni, A0 per simbolo dovrebbe cadere **nella banda del BB (8,7-19 l'anno)**. Se invece H1/H2 sono vere, A0 sta molto sopra (nell'ordine dei ~51/anno visti in R92BAB) e A6 scende verso la banda del BB: **le due ipotesi producono numeri diversi, quindi la misura le separa**. Resta un dubbio da chiudere con A0 stesso: i ~51/anno vengono da Modello 1 (OHLC) con ATR spento e due mesi soli; se lo script offline restituisse per A0 un passo ~10/anno, la differenza con R92BAB sarebbe un artefatto di banco, non delle condizioni (seconda banda, scritta prima).

**Cosa NON fa questo piano:** non dice se un VIOLA piu' stretto guadagna di piu' (misura candidati, non P/L); non valuta il costo (`stop >= 40 x spread`); non propone di cambiare nessun EA.

---

## 5. Cosa NON si puo' concludere

1. **Che il Breaking Band sia "meglio" o "piu' corretto".** Le misure nostre sul Bulge stanno sotto PF 1, ma il BB ha merito **sospeso** (n 11-26, un solo regime, G4 riga 1a-1c) e a 27,5 anni GBPUSD e' sotto 1 (0,897). Frequenza bassa e qualita' alta **non** sono la stessa cosa.
2. **Che allentare il BB sia la strada.** R91 ha mostrato che il filtro sul RR tagliava i trade migliori (+193 / +184 / +66 di aspettativa a trade); la regola del 19/08 vieta le griglie sui parametri di un motore **dichiarato** senza edge (il BB non lo e': ha il merito **sospeso**), ma ogni allargamento si paga con una prova fuori campione o di regime, e allentare per frequenza senza quella prova e' la stessa trappola; il BB e' gia' stato allentato una volta (CAL1). E il pavimento di frequenza e' **per famiglia**, non per sedia (firma 07/09).
3. **Che una singola condizione spieghi il divario.** Nessuna ablazione e' stata fatta: H1-H5 sono ipotesi.
4. **Che il Bulge VIOLA "sia" la guida.** Non lo e': e' l'indicatore Pine di Claudio (`indicatore_inbulge_claudio.pine`, triangolato in `risultati_archivio/TRIANGOLAZIONE_BULGE_PINE_2026-08-21.md`), e il Pine ha **per costruzione** un post-bulge senza `isBulge`. Che sia una scelta o una svista del Pine e' una domanda per Claudio [NON MISURATO]. (La stessa triangolazione ha trovato che l'IN-BULGE di Claudio entra in fade sulla banda dell'impulso, che e' *diverso* dalla CONTINUAZIONE della guida: nel par. 2 confronto solo il VIOLA con l'INVERSIONE.)
5. **Che i 33 VIOLA del v5.20 sarebbero "validi" secondo la guida.** Non ho verificato nessuna delle 33 aperture contro le 16 condizioni del par. 1.1, e non ho le immagini dell'esempio 6.2.
6. **Che il passo del v5.20 (5,5/giorno) sia stabile.** Sono 6 giorni di borsa, un solo regime; e il salto di ~5x sull'antenato non e' spiegato.
7. **Quanti dei VIOLA del forward sarebbero stati scartati dal BB**, in che ordine, e quanto P/L avrebbero portato: serve la misura A del par. 4.
8. **Che il binario BB in campo coincida con il HEAD letto qui** (v1.02 contro v1.05): coincide solo se vale il changelog.
9. **Il peso dell'INVERSIONE del BB**: il funnel disponibile e' di una corsa solo CONT e di una versione vecchia; per l'INV ha le fasi 1-2 (51 dei 62 bulge validi muoiono prima del retest, con la soglia vecchia del rientro a 1,00 ATR) ma **non la fase 3**; "il BB e' stretto" sull'INV e' provato sul codice e sulle fasi 1-2 di quella versione, non sulla v1.05 ne' sui cancelli del retest.
10. **Numeri di costo (spread) dei cross**: [NON MISURATO] (`BULGE_COME_MIGLIORARLO...` par. 5): le conclusioni sul "troppi trade" dal lato costo non si possono chiudere da qui.
11. **Le 106 di R92, le 128/190 di R92BAB e i 268 di Claudio non sono confrontabili fra loro** senza guardare cella, versione (primo tick o barre chiuse), modello (OHLC o tick), ATR acceso o spento e finestra: li ho messi nella stessa tabella per dare l'ordine di grandezza, non per sommarli.

---

## 6. Fonti riaperte e cosa non ho fatto

**Riaperti per questo confronto:** `docs/breaking_band/{GUIDA_OPERATIVA_11,CHECKLIST,PROMPT,ESEMPI_OPERATIVI,PROTOCOLLI_LEONARDO}`, `indicatore_inbulge_claudio.pine`; `mql5/Experts/ABTG_BreakingBand.mq5` (r.1-380, 540-1640, 1755-1800), `ABTG_Bulge.mq5` (r.1-680, 810-920, 1050-1600); `backtest_pipeline/risultati_archivio/{R92_REFERTO,REFERTO_ROUND33_BREAKINGBAND_WF,REFERTO_ROUND34_BB_PORTAFOGLIO,REFERTO_ROUND91_RR_BREAKINGBAND,R102_REFERTO_BLOCCO1,R103_REFERTO_FINALE,TRIANGOLAZIONE_BULGE_*}`; `backtest_pipeline/risultati_prove/ABTG_BreakingBand/cal1/funnel_bb_EURUSD.txt`; `backtest_pipeline/prove/{BULGE_M1_cella_campo_lunga,CAL_BB_DETECTOR,BREAKING_BAND_TESI}`; `report/{BULGE_COME_MIGLIORARLO_2026-10-03,FTMO_TRIAL_AUTOPSIA_2026-10-08,CONTRATTI_SEDIE,RESOCONTO_EA_G4_FOREX_AGOSTO_2026-10-05,CENSIMENTO_FREQUENZA_FLOTTA_2026-08-22,CENSIMENTO_CAMPO_VS_MISURATO_2026-09-13,giornata_2026-10-05/06/07}`; `data/statements/trades_auto.csv` e `ReportHistory_trial_1514806751_2026-10-08.xlsx` (solo conteggi, via Python a sola lettura).

**Non fatto:** nessun backtest; nessuna modifica a EA, preset, script, sedia, conto; nessuna riga di lancio; nessuna verifica sul binario in campo; nessuna lettura del PDF degli esempi (le note 6.2 sono quelle riferite da Claudio); `controllo-preventivo` non invocato (non e' una riga di lancio ne' un verdetto di archiviazione; il **piano del par. 4 non va lanciato** prima del cancello).

**Per Claudio, due domande che solo lui chiude:** (1) nel suo Pine il post-bulge senza `isBulge` e' voluto? (cambia la lettura della differenza n.1); (2) quale dei due comportamenti vuole come riferimento per il VIOLA: "ogni tocco dopo un impulso" (com'e' ora) o "dopo un bulge validato come dice la guida"? La seconda risposta e' una **firma sul motore**, non un lavoro.

---

## 7. Cancello (strato 2, controllo-preventivo, 08/10) -- correzioni meccaniche applicate

Esito **PASS con riserva**. Il file su disco era identico al commit `78776baa` (nessuna alterazione dopo il push). Codice riaperto riga per riga (25/25 righe della tabella del par. 2 con i numeri di riga, `ABTG_Bulge.mq5` v5.20 e `ABTG_BreakingBand.mq5` v1.05 a HEAD, Pine r.98-119): **la differenza n.1 e' confermata** (il VIOLA r.1564-1574 non contiene `isBulgeSig`, usato solo da ARANCIO/BLU r.1500-1506; il Pine r.100-119 non contiene `isBulge`). Numeri ricontati dalle fonti: 33 VIOLA (19 L + 14 S; 7/3/4/9/6/4), 18 simboli, 19 chiuse 05-07/10 (+3 BLU), 1 BB, 19 VIOLA sul trial (tutte VIOLA, nessuna BLU; 10 vinte, -4.925,49 con commissioni), 106 di R92, 268 in 4,24 anni, 128/190 di R92BAB, 50/297 dell'antenato: **confermati**. Corretti (meccanici, nessuna conclusione cambia di verso):
1. finestra del forward BB: era ancorata alla prima operazione (20/08) e contava 35 giorni dove sono 34; ora 13/08 (accensione) - 07/10 meno i 4 giorni a terminale fermo = ~36; il rapporto passa da ~38x a **~40x**, il per-simbolo da 6,4x a **6,6x** (par. 0 e 3) -- classe 1181;
2. 2 delle 33 VIOLA sono XAUUSD, fuori dalla lista di r.463 e dai preset del repo: universo in campo [NON VERIFICATO]; il CSV ha solo chiuse -> 33 e' un limite inferiore;
3. il funnel EURUSD ha **anche** la fase 2 dell'INV (51 su 62 morti): il buco e' solo la fase 3 INV (par. 0.9, 3.1, H2, 5.9) -- classe 1182;
4. riga 1 del par. 2: la r.14 del BB non e' una nota di contesto di trend; il solo filtro di trend del codice e' quello del `InpContEntryMode=2` (CONT, spento);
5. righe del G4 sfasate di una (r.32/33/34, M30 r.38); "~10-19" -> "~9-19" all'anno (R102 AUDUSD 8,7);
6. trial: il commento sta nella sezione "Affari", non in un "foglio Ordini";
7. fonte dei 94,98 minuti (`BULGE_M1_cella_campo_lunga.txt` r.80-84, proiezione da un controllo fallito);
8. par. 5.2: la regola del 19/08 vieta le griglie su un motore **dichiarato** senza edge; il BB ha merito sospeso (la cautela resta, con la ragione giusta).

**Riserva:** queste correzioni le ha fatte il cancello stesso: servono gli occhi di un **lettore indipendente** prima che il documento arrivi a Claudio.
