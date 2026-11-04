# A7 - R008: verifica delle citazioni di codice e preset
Sala del Consiglio, progetto ORB_PAOLO, 04/11/2026. Autore: A7 (controllo indipendente, solo lettura). Nessun test eseguito, nessun dato toccato, nessun file modificato fuori da `agents/A7/`.

## 0. Metodo e perimetro
- Riaperti i sorgenti nello stato attuale di `materiali/`: `ABTG_ORB.mq5` (469 righe), `ABTG_ORB_Ottimizzato.mq5` (1483, v1.04), `ABTG_ORB_Emiliano.mq5` (1809, v1.01), `preset_live_ORB_Ottimizzato.txt` (111). Per le colonne di sinistra della tabella (regole di Paolo) ho riletto anche il testo del PDF (`pdftotext`, 14 pagine; numerazione slide di A7 confermata: 10 regole, 11 money, 12 reality check).
- Righe: `Ott:NNN`, `ORB:NNN`, `Emi:NNN`, `preset:rNN` (primo blocco XAGUSD r.1-55; il secondo, U30USD r.57-111, e' identico: `diff` dei valori = nessuna differenza, cambia solo la riga di intestazione).
- Esiti: VERO = la citazione regge cosi' com'e'; IMPRECISO = regge nella sostanza ma la formula/la riga/il perimetro vanno corretti; FALSO = contraddetta dal sorgente; NON VERIFICABILE = i materiali non bastano.
- Esito sintetico: **nessuna citazione FALSA tra quelle che sostengono le conclusioni del CONFRONTO**. Le tre verifiche attive (sez. 3) confermano le tre tesi. Trovate 7 imprecisioni nel CONFRONTO (righe 4b, 5d, 6a, 12b, S4.3b, S4.5, S4.6: da correggere o qualificare), 2 "VERO con nota", 1 errore di colonne in una tabella di A7 (P08d), 2 righe di A7 sbagliate di una unita' (Ott:418, Ott:378).

---

## 1. CONFRONTO sezione 3 - riga per riga
Per ogni riga controllo le tre colonne EA e, dove cita il PDF, la colonna "Regola di Paolo".

| # | Citazione (CONFRONTO sez. 3) | Esito | Nota / riga verificata |
|---|---|---|---|
| 1a | Box 15 min: ORB "5 min prima (14:25-14:30)" | VERO | `ORB:34-37` (14/25/14/30), commento `ORB:8-9`, calcolo `ORB:154-172`. |
| 1b | Box 15 min: Ott live "15:30-15:45" | VERO | `preset:r.3-6`. |
| 1c | Ott: "giusta solo con USA in ora solare" | VERO | Coerente con CLAUDE.md (server GMT+1 fisso; cash USA = 14:30 server con USA in DST, 15:30 con USA in ora solare; USA in ora solare dal 01/11/2026). Nessuna logica DST in Ott (grep `dst`/`ora solare`/`ShiftMin` = 0 risultati). |
| 1d | Ott: "la barra M1 delle 15:45 entra in parte" | VERO | `Ott:413-414` `iBarShift(M1,tEnd)` con `tEnd`=15:45; `Ott:417` `count=|iS-iE|+1`. Il range ha 16 barre M1 (15:30..15:45). "In parte" dipende dal primo tick >=15:45 (`Ott:381`): entita' a runtime NON VERIFICABILE (gia' dichiarato). |
| 1e | Emiliano: "DIVERSA (come ORB; `InpAutoUSDST` opt-in spento)" | VERO | `Emi:180-183` (14:25-14:30), `Emi:268` `InpAutoUSDST=false`, logica `Emi:506-523`, `Emi:638-639`. |
| 2a | Candela M5: ORB "ASSENTE (ordini pendenti)" | VERO | `ORB:189-212` BuyStop/SellStop, nessuna lettura di candele. |
| 2b | Ott: pendenti STOP al tocco di livello+10, "lo spike fa scattare l'EA", `UseCloseConfirm=false` | VERO | `preset:r.31`; ramo `Ott:388-391` -> `TryPlace` `Ott:430-476`; `Ott:438` `buyPx=gRangeHigh+entryDist`, `EntryDistance` `Ott:612-617` = `InpEntryPoints*InpK` = 10 unita' di PREZZO. Un ordine stop a high+10 si riempie al primo tocco, spike compreso. |
| 2c | Emiliano "DIVERSA (come Ott)" | VERO | `Emi:603-610`, `Emi:657-707`; `InpUseCloseConfirm=false` `Emi:247`. |
| 3 | Ingresso alla chiusura: ORB/Ott/Emi "DIVERSA (intrabar)"; Ott "fino alle 22:00" | VERO | Scadenza pendente 600' (`Ott:441`, `preset:r.11`) ma `EndOfDay` alle 22:00 (`preset:r.7-8`, `Ott:373`, `Ott:1043-1051`) arriva prima (15:45+600' = 01:45). |
| 4a | Stop: ORB "IMPLEMENTATA" | VERO con nota | `ORB:51` default `OPPRANGE`, `ORB:226,234`: SL esattamente sull'estremo opposto. Paolo scrive "un gocciolino fuori" (slide 10): nessun buffer in ORB (A7 P06c lo dice; nella riga del CONFRONTO non compare). |
| 4b | Stop Ott: "`SLMode=3` = mezzo box (`entry - 0,5*range`)" | VERO nella formula, IMPRECISO nel nome | `preset:r.16`; `Ott:121` enum; `Ott:629` `sl=entry-0.5*(gRangeHigh-gRangeLow)-SLBuffer()`, buffer = 0 (`preset:r.30`). La formula e' esatta. Ma "mezzo box" fa pensare al centro del box: lo stop sta a `rangeHigh+10-0,5*range` = **centro del box + 10**, cioe' a 0,5 range dall'ENTRY, non dal bordo. Vedi verifica attiva 1. |
| 4c | Emiliano stop "IMPLEMENTATA (default)" | VERO | `Emi:197` default OPPRANGE, `Emi:872,881`. |
| 5a | TP: ORB "DIVERSA: 2R" ; Emiliano "DIVERSA: 2R" | VERO | `ORB:56` e `Emi:202` `InpTP_R=2.0`, `Emi:203` `TPMode=R`; TP `ORB:195,207`. |
| 5b | Ott: `TPMode=1`, mult 1,5 -> TP = entry + 1,5*range = **3R** sullo stop a mezzo box | VERO | `preset:r.22-23`; `Ott:451-452`. Verifica attiva 1: (1,5*range)/(0,5*range) = 3,00 esatto, indipendente da EntryPoints e K. |
| 5c | `InpTP_R=1.0` nel preset e' **inerte** (trappola di lettura) | VERO | `preset:r.21`. Con `TPMode=1` il ramo `Ott:451` ignora `InpTP_R`; altri usi: `Ott:589` (solo CloseConfirm, spento), `Ott:677` (dentro `ManageTP1`, dopo l'uscita anticipata `Ott:656-666`). Quindi mai raggiunto. |
| 5d | Colonna Paolo: "TP 1:1 («3R è ambizioso»)" | IMPRECISO | PDF slide 12: «3 è ambizioso» (non «3R»), con "con uno stop da 143 punti ne dovresti fare 450". Lo "1:1 conservativo" e' slide 10. Citazione virgolettata da correggere. |
| 6a | Parziale: ORB "parziale = stesso prezzo del TP (superfluo)" | IMPRECISO | `ORB:256` `tgt=openP+risk*InpTP_R` con `risk=openP-sl` e `sl` = stop CORRENTE (`ORB:250,254`). Coincide col TP (`ORB:195`) solo finche' lo stop non e' stato spostato. Con `InpUseTrailEMA=true` di default (`ORB:59`, trailing `ORB:282-291`, senza legame col parziale) lo stop sale, `risk` diminuisce e il livello del parziale scende SOTTO il TP; se lo stop supera l'apertura `risk<=0` -> `return` (`ORB:255`) e il parziale non scatta mai. Quindi "superfluo" non e' garantito (e A7 stessa lo dava "NON VERIFICATO"). Lo stesso vale per `Emi:205` e per i default Ott. |
| 6b | Ott: "ASSENTE (`TP1Pct=0` -> anche il breakeven e' inerte)" | VERO | `preset:r.24-25`; `Ott:656-666` (vedi verifica attiva 2). |
| 6c | Emiliano: "opt-in Piano A spento" | VERO | `Emi:263` `InpPlanAUse=false`; Piano A `Emi:977-1031`. |
| 6d | Colonna Paolo: "Parziale 50% (DAX 30-40 pt) + BE+1 euro" | VERO | PDF slide 10: "50% ... (DAX: 30-40 punti)"; "Stop in pari, piu' un euro: non mi piace vedere zero". |
| 7a | Il resto: ORB "trailing EMA9 M5" | VERO | `ORB:282-291`, default `ORB:59`; in piu' uscita su chiusura EMA9 (`ORB:277-281`, default `ORB:62`). |
| 7b | Ott: "trailing EMA9 M5 senza soglia, dalla prima barra" | VERO | `preset:r.26`; `Ott:826-848`: unica condizione `newSL>sl && newSL<bid`; `ManageRunner` (da `Ott:378`, una volta per barra M5) non dipende ne' da `gPart1` ne' da un profitto minimo. "Dalla prima barra" = dalla prima nuova barra M5 dopo il fill (la barra in cui avviene il fill non c'e': `newBar` e' valutato all'inizio del tick). Quanto spesso l'EMA9 sia sopra lo stop: NON VERIFICABILE senza dati (dichiarato nel CONFRONTO sez. 8). |
| 7c | Emiliano "come ORB" | VERO | Default `Emi:207,210`; runner `Emi:1121-1188`; sospeso solo col Piano A (`Emi:1105`). |
| 8a | Contesto: ORB/Emi "ASSENTE" | VERO | grep `SuperTrend`, `VWAP`, `PERIOD_H1`, `PERIOD_H4`, `retest` = 0 risultati nei tre sorgenti. EMA9/EMA21 in ORB servono solo a trailing/uscita (`ORB:105-106`, EMA21 mai letta). |
| 8b | Ott: "filtro EMA200 M5 (una volta alle 15:45), non nel PDF" | VERO | `preset:r.34` `UseEma200Filter=true`, `r.17` `InpExecTF=5`; periodo 200 = default (`Ott:199`, non nel preset); `Ott:300` handle; `Ott:327-335`; chiamato in `TryPlace` `Ott:445` (long) -> valutato alla piazzatura. Se fallisce `TryPlace` ritorna true (fase PLACED) = giornata persa. PDF: nessun "200"/EMA lunga; cita solo "medie ordinate" (slide 7). |
| 8c | Ott: "`UseEmaFilter` e `UseVolumeFilter` non hanno effetto con i pendenti" | VERO | Vedi verifica attiva 3. |
| 9 | Trend/short: ORB "entrambe", Ott "solo long (`AllowShort=false`)", Emi "entrambe" | VERO | `ORB:47-48`; `preset:r.15`, `Ott:460` (ramo short saltato); `Emi:193-194`. |
| 10 | Resistenze H1/H4, "troppo lontana", retest, TP tecnico, size ridotta: ASSENTE x3 | VERO | grep negativo (vedi 8a). Per Emi `InpMaxLateMin` (`Emi:262`, `Emi:596-601`) non e' un filtro "troppo lontana" (protezione da riavvio). |
| 11 | Box stretto: ORB "nessun filtro"; Ott `MaxRangePct=0,8%` "tetto molto largo, tipo diverso"; Emi "opt-in spento" | VERO | `preset:r.36`, `Ott:505-506`, chiamato `Ott:434`; `Ott:503-504` `MinRangePct` (`preset:r.35`=0). Emi: `Emi:260-261`, `Emi:734-751`. "Molto largo" e' giudizio: 0,8% del Bid corrente (es. circa 320 punti su un indice a 40.000, **assunzione sul livello di prezzo, non verificata**). |
| 12a | Rischio: "IMPLEMENTATA (1%)" in tutti | VERO | `ORB:65`, `ORB:329-344`; `preset:r.40`, `Ott:1067-1096` (usa `OrderCalcProfit`, fallback tick value); `Emi:275`, `Emi:1383-1422`. Su `ACCOUNT_BALANCE` (`Ott:1070`). |
| 12b | Ott: "con stop a mezzo box il lotto e' ~doppio rispetto a uno stop sul lato opposto, a pari rischio nominale" | IMPRECISO | Rapporto lotti = (dist. stop lato opposto)/(dist. stop mezzo range) = `(range+E)/(0,5*range)` = `2+2E/range`: 2,2x con range 100 e E=10; 2,5x con range 40; 3x con range 20. E' "almeno il doppio", non "~doppio". Inoltre lotto forzato al minimo (`Ott:1094-1095`) puo' alterare il rapporto. |
| 13a | Max 3% al giorno: ORB "ASSENTE" | VERO | Nessun tetto % in `ORB.mq5`; `InpOneTradePerDay` dichiarato (`ORB:41`) e mai letto (grep: unica occorrenza r.41). |
| 13b | Ott: "ASSENTE nel sorgente; Guardian in `.mqh` esterno non nei materiali -> NON VERIFICATO" | VERO | `Ott:106` `#include <ABTG_PausaGuardian.mqh>`, `Ott:118` `InpUsaGuardian=true`, `preset:r.2`, chiamata `Ott:444`. Il file non e' in `materiali/` ne' tra i file tracciati del repo (`git ls-files`: solo `ABTG_ApertureCore.mqh` e `OptFrame.mqh`). Il commento `Ott:107-117` dichiara fail-open nel tester. Resta NON VERIFICABILE se equivalga a un tetto 3%. |
| 14 | DAX di mattina: ASSENTE (ORB/Emi) e "nel preset live" | VERO nei materiali | Il preset ha solo XAGUSD e U30USD (`preset:r.1`, `r.57`). Non si puo' escludere un'istanza DAX/Nasdaq non rappresentata nel file (A7 lo scrive; vedi sez. 2, punto 5). |
| 15 | Cambio ora legale: ORB "valori fissi"; Ott "fissi, a mano"; Emi "solo USA, opt-in spento" | VERO | Nessuna logica in `ORB`/`Ott`; `Emi:505-523` (2a dom. marzo / 1a dom. novembre, solo USA, `InpAutoUSDST=false`). Il "due volte l'anno" e' la regola CLAUDE.md. |

---

## 2. CONFRONTO sezione 4 - punti 1-6 (e sez. 1)
| # | Citazione | Esito | Nota |
|---|---|---|---|
| S4.1 | "Ingresso: Paolo = chiusura di M5 fuori dal box; EA live = ordine pendente al tocco. La regola che Paolo scrive per escludere gli spike non e' applicata." | VERO | Righe 2b/3 sopra; PDF slide 6 "Gli spike non contano". La CloseConfirm esiste ma e' spenta (`preset:r.31`); anche accesa non richiede "apre fuori" (`Ott:558-560`). |
| S4.2 | "Struttura R/R: Paolo = stop sul lato opposto, TP 1:1. EA live = stop a mezzo box, TP 3R. Due strategie diverse (stop piu' stretto, target piu' lontano...)" | VERO con qualifica | Numeri: verifica attiva 1. "Stop piu' stretto" vale sempre; "target piu' lontano" (in punti) vale solo se range > 2E (con E=10 unita' di prezzo: range > 20); sotto, il TP live e' piu' vicino di quello di Paolo. La "win rate attesa molto diversa" e' un'inferenza, non una citazione. |
| S4.3 | "Gestione: ... nessun parziale, breakeven inerte, trailing EMA9 automatico senza soglia" | VERO | Righe 6b, 7b; verifica attiva 2. |
| S4.3b | "(rischio indicato dallo stesso Paolo: «stop troppo stretto che ti fa uscire»)" | IMPRECISO | PDF slide 12: "STOP TROPPO STRETTO - Messo sulla candela da 5 minuti precedente, ti fa uscire dal trade". Il virgolettato e' una ricomposizione, e Paolo parla di stop sulla candela M5 precedente, non di stop a meta' box o di trailing EMA9. L'applicazione al live e' un'estensione (plausibile, ma non detta da Paolo). Riformulare senza virgolette. |
| S4.4 | "L'EA ha EMA200 e tetto 0,8%, che Paolo non cita; non ha nulla di cio' che Paolo cita (SuperTrend, VWAP, livelli)" | VERO con nota | EMA200 e 0,8% non sono nel PDF. Ma Paolo cita "medie" (ordinate nella direzione, slide 7) e "volumi": il live non ha un filtro medie come quello (EmaSideOK e' spento e irraggiungibile) ne' i volumi (idem). Corretto dire "non cita EMA200 specificamente". |
| S4.5 | "Strumenti/ora: live su argento e Dow; Paolo parla di Nasdaq e DAX. Orari live corretti solo con USA in ora solare." | IMPRECISO sul perimetro | Il preset contiene SOLO XAGUSD e U30USD (`preset:r.1`, `r.57`): "nei materiali". Il CONFRONTO sez. 1 afferma "il live gira su XAGUSD e U30USD, **non** su Nasdaq ne' DAX": non e' dimostrabile dai materiali (A7 §P01c/P12 scrive correttamente "NON VERIFICATO"). Qualificare: "il preset live fornito riguarda...". Aggiunta: per XAGUSD `EntryPoints*K` = 10 unita' di PREZZO (`Ott:612-617`, `preset:r.12-13`; lo stesso header Emiliano dice che l'argento non e' in tabella K, `Emi:20-21`): non verificabile che sia voluto (vedi nota 1 della verifica attiva 1). |
| S4.6 | "ORB, Ott ed Emiliano sono lo stesso codice con default uguali" | IMPRECISO | Ott vs Emi: vero per dichiarazione (`Emi:15-17`, derivata "riga per riga", tutto il nuovo opt-in) - regge come dichiarazione, non provato con un diff. ORB e' un altro file (469 vs 1483 righe): stessa LOGICA di default, ma NON lo stesso codice: ORB ha `InpOneTradePerDay` mai letto (`ORB:41`), `SelPos` non hedge-safe (`ORB:356`, `PositionSelect(_Symbol)`), niente HALFRANGE/TPMode/CloseConfirm/filtri/Guardian. Formula corretta: "stessa logica di default; ORB e' la versione base, Ott/Emi i derivati". |
| S4.6b | "la distinzione del PDF («Emiliano = volatilita' d'apertura, ORB = trend») nei nostri EA non ha un riscontro operativo" | VERO | PDF slide 12: "Quella di Emiliano prende la volatilita' d'apertura; l'ORB prende il trend". Nei sorgenti: nessuna modalita' "trend" distinta; `Emi:4-49` descrive solo opzioni opt-in. |
| S1 | "condivide solo il box da 15 minuti e l'apertura USA" | VERO | Sono anche i soli elementi coincidenti in A7 §3 punto 5 (con lo scarto della barra 15:45). |
| S1b | "Ingresso, stop, target, gestione e filtri sono diversi" | VERO | Righe 2-8 sopra. |
| S7 | "C0 ne ha riletto 6 nel sorgente"; elenco: `SLforLong`+HALFRANGE, calcolo TP in `TryPlace`, `InpTP1Pct<=0`, valori preset | VERO (contenuto) / non verificabile (il "6") | Tutti i passaggi elencati sono esatti (`Ott:624-632`, `Ott:451-452`, `Ott:656-666`, preset). Il conteggio "6" non corrisponde a un elenco di 6 voci distinte (3 passaggi di codice + 1 gruppo di valori preset). Trascurabile. |
| S7b | Preset: `SLMode=3, TP_R=1.0, TPMode=1, TPRangeMult=1.5, TP1Pct=0.0, UseCloseConfirm=false, UseEma200Filter=true, MaxRangePct=0.8` | VERO | `preset:r.16, 21, 22, 23, 24, 31, 34, 36`. |

---

## 3. Verifica attiva sui tre punti piu' pesanti (ragionamento sul codice)

### 3.1 Stop a mezzo box e TP a 1,5 box = 3R nel preset live
Catena di calcolo, solo da codice e preset (`TryPlace`, `Ott:430-476`):
- `E = EntryDistance() = max(InpEntryPoints*InpK, stopsLevel*_Point)` = 10 (prezzo) (`Ott:612-617`, `preset:r.12-13`).
- `entry = buyPx = rangeHigh + E` (`Ott:438`).
- `SL = entry - 0,5*(rangeHigh-rangeLow) - 0` (`Ott:629`, `SLBuffer=0` per `preset:r.30`). Quindi `SL = rangeHigh + E - 0,5*range = centro_box + E`.
- `dist = buyPx - SL = 0,5*range` esatto (`Ott:448`): **1R live = 0,5*range**, indipendente da E.
- `TP = buyPx + range*1,5` (`Ott:451`, `TPMode=1`, `TPRangeMult=1,5`, `InpTP_R` ignorato).
- `(TP-entry)/(entry-SL) = 1,5*range / 0,5*range = 3,00`. Il 3R e' CORRETTO e non dipende da E, K, ne' dal livello di prezzo. (Piccoli scarti solo dall'arrotondamento al tick di `NormalizePrice`; slippage del preset = 0, `preset:r.54`.)

Esempi numerici (E=10, unita' di prezzo; long, `preset` live):

| range | box H / L | entry | SL live | dist. stop live (=1R) | TP live (dist.) | Paolo: stop (dist.) | Paolo: TP 1:1 (dist.) | rapporto lotti Paolo->live |
|---|---|---|---|---|---|---|---|---|
| 100 | 40.100 / 40.000 | 40.110 | 40.060 (centro 40.050 + 10) | 50 | 40.260 (150 = 3R) | 40.000 (110) | 40.220 (110) | 2,2x |
| 40 | 40.040 / 40.000 | 40.050 | 40.030 (centro 40.020 + 10) | 20 | 40.110 (60 = 3R) | 40.000 (50) | 40.100 (50) | 2,5x |
| 20 | 40.020 / 40.000 | 40.030 | 40.020 (= bordo alto del box) | 10 | 40.060 (30 = 3R) | 40.000 (30) | 40.060 (30) | 3,0x |
| 10 | 40.010 / 40.000 | 40.020 | 40.015 (SOPRA il bordo alto) | 5 | 40.035 (15 = 3R) | 40.000 (20) | 40.040 (20) | 4,0x |

Conclusioni:
1. Il 3R del CONFRONTO e' esatto. La distanza dello stop in R rispetto al range e' 0,5 dall'ENTRY; rispetto alla distanza di Paolo (range + E) e' `0,5/(1+E/range)` = 45% con range 100.
2. "Stop a mezzo box" e' una abbreviazione: lo stop e' a `centro + E`, cioe' dentro il box nella meta' alta solo se range > 2E; a range = 2E coincide col bordo alto; sotto 2E sta sopra il bordo (fuori dal box!). La formula scritta nel CONFRONTO (`entry - 0,5*range`) e' giusta; la parola "mezzo box" va accompagnata dalla formula (come gia' nella tabella).
3. "Target piu' lontano" (CONFRONTO S4.2) vale in punti solo per range > 2E (TP live 1,5*range contro Paolo range+E); a range = 2E i due TP coincidono (riga 20); sotto, il TP live e' piu' vicino. Il 3R resta vero nell'unita' R del live.
4. Nota 1 (da non perdere, NON VERIFICABILE): su XAGUSD il preset ha K=1 e EntryPoints=10, cioe' E = 10 unita' di PREZZO (`Ott:614`). Se il range di 15 minuti dell'argento e' molto sotto 20 unita' di prezzo (cosa plausibile per un metallo quotato a decine di dollari, ma i materiali non danno quotazioni ne' range), allora per XAGUSD vale il caso "range < 2E": pendente molto lontano dal box e stop sopra il bordo. Il comportamento reale di XAGUSD va chiesto a Claudio o misurato; non e' una citazione del CONFRONTO ma incide su "il live gira su argento".
5. Il commento del sorgente `Ott:163-165` ("STRETTISSIMO (50% del range)", riferito a R55; stesso testo `Emi:215-217`) supporta la qualifica "stop stretto" ma e' una descrizione a parole di 0,5 range, non dice dove sta rispetto al box.

### 3.2 Breakeven inerte con `InpTP1Pct=0`
- `InpBreakeven` compare nel sorgente solo in: dichiarazione (`Ott:154`), commento (`Ott:650`), il messaggio di avviso (`Ott:662-663`) e **un unico uso operativo**, `Ott:697` dentro `ManageTP1`.
- `ManageTP1` (`Ott:646-717`): `if(!SelPos()) return;` (648), poi `if(InpTP1Pct<=0) { avviso una tantum; return; }` (`Ott:656-666`), prima di ogni calcolo di parziale o breakeven (da `Ott:667`). Con `preset:r.24` `InpTP1Pct=0.0` il codice esce sempre: nessun parziale e nessuno stop in pari, anche con `InpBreakeven=true` (`preset:r.25`). Il commento `Ott:649-655` e il messaggio `Ott:662` lo dichiarano esplicitamente.
- Non c'e' altro percorso di breakeven: `ManageRunner` (`Ott:722-...`) fa solo uscita su chiusura EMA e trailing EMA9; nessun riferimento a `InpBreakeven`.
- ESITO: VERO. Precisazione utile: "breakeven inerte" non significa "stop mai alzato": il trailing EMA9 (`Ott:826-848`, `preset:r.26`) puo' portare lo stop sopra l'apertura se l'EMA9 sale oltre l'entry e sta sotto il Bid; avviene per effetto del trailing, non della regola "stop in pari".
- In ORB (`ORB:246`) e Emi (`Emi:893-...`) col default `TP1Pct=50` il breakeven e' invece attivo (dopo il parziale).

### 3.3 `UseEmaFilter`, `UseVolumeFilter`, `MinBodyPct` senza effetto con i pendenti
- `EmaSideOK` (`Ott:515-525`): unico punto di chiamata `Ott:571`. `VolumeOK` (`Ott:531-544`): unico punto di chiamata `Ott:573`. `InpMinBodyPct`: unico uso `Ott:568`. Tutti e tre dentro `TryCloseConfirmEntry` (`Ott:551-610`).
- `TryCloseConfirmEntry` e' chiamata solo da `Ott:398`, nel blocco `gPhase==ORB_ARMED && newBar`. `gPhase` diventa `ORB_ARMED` solo in `Ott:386` (`ArmCloseConfirm`), che si esegue solo se `InpUseCloseConfirm` e' true (`Ott:384`). Il preset ha `InpUseCloseConfirm=false` (`preset:r.31`): si va in `TryPlace` (`Ott:388-391`) e la fase passa direttamente a `ORB_PLACED`.
- `TryPlace` applica soltanto `RangeWideEnough` (434), `SpreadOK` (435), Guardian (444), `Ema200SideOK` (445/460). Nessun filtro EMA9/21, volume o corpo.
- ESITO: VERO per i tre. Inoltre, `InpUseEmaFilter=false` (`preset:r.33`) e `InpUseVolumeFilter=false` (`preset:r.37`) sono comunque spenti: "senza effetto neanche se accesi, con i pendenti" e' la formulazione esatta. Stessa struttura in Emi (`Emi:816-818`, `Emi:813`).

---

## 4. Righe di A7 (`confronto_regole_EA.md`) da correggere
| Punto in A7 | Problema | Correzione |
|---|---|---|
| P01a, Ott: "count +1 `Ott:418`" | Riga sbagliata di 1 | `count=MathAbs(iS-iE)+1` e' a `Ott:417`; `Ott:418` e' `if(count<1)`. |
| P06a, Ott: "`Ott:378,395-399,604`" | Riga imprecisa | La definizione di `newBar` e' `Ott:377`; `Ott:378` e' `if(newBar){...ManageRunner()}`. Cio' che serve a quel punto: 377 (+395-399, 604). |
| P08d (tabella): colonne ORB e Ott scambiate | Errore di colonne | La cella ORB contiene il testo del live ("ASSENTE nel live... INERTE") e la cella Ott quello di ORB ("DIVERSA dove attiva, `ORB:261`..."). Corretto: ORB = DIVERSA (stop in `openP` esatto, `ORB:261`, senza +1); Ott live = ASSENTE (inerte, `preset:r.25`, `Ott:656-666`). Il CONFRONTO (riga "Parziale 50% ...") ha l'assegnazione giusta. |
| P06b, Ott: "SL = entry - 0.5*(range) ... cioe' a meta' del box" | Imprecisione | Lo stop e' a 0,5 range dall'entry = centro del box + E (`Ott:629`); non a meta' del box. |
| P08c, ORB: "il livello del parziale e' ... lo STESSO prezzo del TP" | Vero solo se lo stop non si e' mosso | Il livello e' `openP + (openP-slCorrente)*TP_R` (`ORB:254,256`); col trailing EMA9 attivo di default si abbassa o il parziale non scatta (`risk<=0`, `ORB:255`). Vale anche per Emi/Ott a default. |
| P09a, Ott: "il lotto e' circa il doppio" | Troppo basso | `(range+E)/(0,5*range)` = 2,2x (range 100) ... 3x (range 20): "almeno il doppio". |
| §5.10 e P10 ultima riga: "ORB e Emiliano sono lo stesso codice con default identici" | Imprecisa per ORB | Stessa logica di default, codice diverso (vedi S4.6). Ott/Emi: identici per dichiarazione header, non provato. |
| §0 e P12a, XAGUSD | Osservazione, non errore | Vale anche la nota 1 di 3.1 (E = 10 unita' di prezzo su argento). |
| Righe `Emi:` e `ORB:` restanti | Nessun errore | Tutte controllate (elenco in 5) e corrette. |

## 5. Citazioni di A7 controllate senza rilievi (elenco di riscontro)
- `ORB`: 7, 8-9, 34-37, 38-40, 41 (+grep), 42, 44-48, 51, 56, 57, 59, 62, 65, 105-106, 135, 142-146, 154-172, 189-212, 195/197/207/209, 216-221, 226/234, 250-261, 277-291, 295, 309-314, 329-344 (342-343).
- `Ott`: 106, 107-118, 118, 121, 128-131, 163-165, 192, 199, 300, 327-335, 343-347, 355-356, 373, 381-391, 395-399, 407-425 (414), 430-476, 434, 437-457, 441, 444-445, 451, 456, 471, 505-506, 515-525, 531-544, 551-610 (558-560, 567-569, 571, 573, 604), 612-617, 622, 629, 638, 646-717 (649-666, 677), 826-848, 1043-1051, 1067-1096 (1094-1095).
- `Emi`: 15-17, 20-21, 28-31, 36-39, 180-183, 187, 193-194, 197, 202-205, 207, 210, 215-217, 244, 247, 249-250, 258-272, 268, 275, 413, 505-523, 529-537, 558-559, 596-601, 603-610, 632-652 (638-639), 657-707, 671, 734-751, 760-770, 776-789, 796-855 (818), 867, 872, 881, 891-963 (939, 952), 977-1031 (1014-1023), 1105, 1121-1188, 1383-1422 (1412-1418, 1421).
- `preset`: tutte le righe citate (1, 2, 3-6, 7-8, 10, 15, 16, 21-26, 29-31, 33-37, 40) e la tesi "secondo blocco identico, +56" (confermata con `diff`).

## 6. Limiti di questa verifica
- Non ho eseguito niente e non ho tick/dati: restano NON VERIFICABILI primo tick delle 15:45, frequenza con cui il trailing EMA9 alza lo stop, comportamento reale di XAGUSD, contenuto del Guardian (`ABTG_PausaGuardian.mqh` non e' nei materiali ne' tra i file tracciati del repo).
- Confronto con il PDF limitato al testo (`pdftotext`, tutte le 14 pagine) e solo per le citazioni che compaiono nelle tabelle di CONFRONTO e A7; nessun controllo visivo delle immagini.
- La verifica sul diff Ott/Emi si basa sull'header (`Emi:15-17`); non ho fatto un diff riga per riga dei due file.
- Le sezioni 2, 5, 6, 8, 9 del CONFRONTO (PDF, testabilita', rischi di backtest, domande) non contengono citazioni di codice e non sono state verificate qui, a parte il fuso orario (coerente con CLAUDE.md).
