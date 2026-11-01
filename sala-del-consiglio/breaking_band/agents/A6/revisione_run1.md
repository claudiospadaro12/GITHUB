# A6 — Revisione critica del run primario (R007, fase 3)
Autore: A6. Ho letto: final/run1/primario.md e .json (incluso LOG_TRADE), congelati/*, decisions.md D001-D008, specifica_v1 (sezioni citate), agents/A4 (engine.py e signals.py per intero, run_test.py nelle parti baseline/verdetto, domande.md), agents/A7 (esito_pre_hash, piano_verifica, esiti), materiali/da_branch_lavoro/RIASSUNTO_PER_TERZI.md, protocolli. NON ho riletto V0_C0_RISERVATO (non serviva). NON ho rieseguito il run ne toccato i CSV. Ho eseguito soli calcoli sul JSON del run e UN controllo sintetico mio (sotto). Etichette: FATTO_VERIFICATO (calcolato da me o letto), INFERENZA, IPOTESI, DA_VERIFICARE.

## 0. Giudizio in breve
- Il motore e i segnali sono corretti per quanto posso verificare; il numero N=25 e coerente fra T1, T2, T3 e LOG. Non vedo un errore nei numeri.
- Il verdetto INCONCLUSIVO e quello giusto da pre-registrazione. Ma il vero limite non e N=25: la traduzione scelta lascia passare ~9% degli episodi (25/267) e le uniche 25 operazioni sono tutte in stati di bande strette (target a 0,23-1,74 ATR, mediana 1,0) dove lo stop a 3 ATR richiede un win rate di pareggio ~77%. Il risultato descrive questa nicchia, non "la Breaking Band".
- La Parte A resta NON_VALUTATA nel run: dei controlli post-run di A7 mancano V10, V11 (due esecuzioni stesso hash), V12 completo (20 trade per cella: ce ne sono 6) e V17. Finche non sono chiusi i numeri vanno riportati come "condizionali".
- Punteggio D001 proposto: 86/100 (sotto soglia 90, nessuna dimensione sotto 80). Dettaglio in sez. 6.

## 1. I miei controlli CK [B]: verificabilita ora e giudizio
Legenda: S = SUPERATO, P = PARZIALE, NE = non evidenziato/non eseguito. "Mia ispezione" = fatta io sul codice/JSON, senza fidarmi di A4/A7.
| CK | Verificabile ora? | Mia ispezione | Giudizio |
|---|---|---|---|
| CK-01 invarianza al troncamento | codice si, run no (il run non lo esegue) | Ho scritto un test mio (scratchpad/a6/trunc_check.py): 6 serie sintetiche a regimi x TF 60 e 30 x CONT/INV, tagli casuali + a ridosso dei segnali: 68 segnali, 20.151 controlli di episodi, 0 differenze sui segnali e 0 sul picco `p` (il caso del mutante S03 che A7 aveva visto sopravvivere). Letti per intero engine.py e signals.py: nessun indice futuro nel segnale. A7 su reale: solo 1 cella (2013 CONT H1, 8 segnali). | S (sintetico, mio + A7); reale PARZIALE (1 cella su 8: 2013 CONT H1) |
| CK-02 aggregazione barre | si | `costruisci_barre` (chiave `t//periodo`), ingresso alla prima M1 di j+1, gap tra chiusura barra e ingresso (0 min su tutti i 25 trade). A7: barre A4 = barre A7 identiche su 8 serie reali. Convenzione dichiarata: barre contate sulle ESISTENTI (un weekend vale 1 barra; T_MAX=30 e ricalcolo "3 ore" non sono tempo di calendario). | S |
| CK-03 perturbazione del futuro | codice si | stessa ispezione; A7 V02 sintetico S. | S |
| CK-04 niente normalizzazioni globali | si | Indicatori solo con finestre trailing. Unica statistica globale: mediana spread per ora usata per sostituire spread 0 (solo costi). Nessun trade ha spread sostituito (T9: 0/0). Nessuna concatenazione: un file = una serie. | S |
| CK-05 target ricalcolato | si, e dal LOG | Codice: ricalcolo con `sma20[j+r*m]` (barra chiusa), fase relativa all'ingresso, controllo prima dell'aggiornamento, `MKT` se gia superato, classificazione per P&L. Dal LOG: 2 trade su 25 (8%) hanno il target finale OLTRE il prezzo d'ingresso; uno e uscito "TP" con R = -0,115 (conteggiato come perdita: win% 25% in CONT_H1_2013 con 3 TP). A7 ricalcolo reale: schedule target identica (max diff 0). | S. Osservazione: la regola "ricalcolo 3 ore" puo trasformare un target in una perdita |
| CK-06 stop prima del target | codice si, evento reale no | Codice: SL prima di TP anche nella M1 d'ingresso, fill stop = `min(stop, open)`. Sul reale 0 eventi stesso minuto, quindi il ramo non e esercitato dai dati; A7 sintetico: 60/60 iniettati. | S (sintetico), non esercitato sul reale |
| CK-07 contabilita spread | si | Ricalcolata da me dal LOG: long `entry = open + spread`, costo = spread/D; spread 2013 ~0,27-0,41 USD, 2025-26 ~0,19-0,22 USD, coerenti con costo_spread_R (es. 2013: 0,27/6,2 = 0,044 R). Short: spread nella condizione di hit (ask = bid + spread), non in R: per lo stesso `d` il bid deve percorrere d + spread e il premio e d: stessa economia del long. A7: 1185 trade sintetici + 92 reali identici. | S |
| CK-08 simmetria | si | Un solo percorso (`_Vista` specchia High/Low/bande). A7 V05: 1603 trade speculari, 0 differenze. Lato reale: long 11 (media -0,07), short 14 (-0,23); la differenza non e un artefatto di segno (stessa asimmetria nelle linee di base: long -0,057 / short +0,028). | S |
| CK-09 un segnale per episodio, una posizione | si, dal LOG | Dal LOG: 25 trade = 25 episodi distinti, 0 coppie CONT/INV sullo stesso episodio, 0 sovrapposizioni temporali fra trade dello stesso periodo (nemmeno fra varianti), 0 scartati per posizione aperta. | S |
| CK-13 placebo | si, T7 | T7: CONT_H1 z=-0,08 (n=748), CONT_M30 z=0,93, INV_M30 z=-0,02: SUPERATO; INV_H1 n=90 (<100): NON_CONCLUSIVO (z=1,66) con il tetto di 300 anni; A7 a 700 anni: tutti SUPERATI (z max 0,71). Riserva: il generatore e di A4 (GARCH orario, niente weekend ne salti ne news, spread costante 25 punti): prova l'assenza di look-ahead, non la fedelta ai dati veri. | S con riserva (INV_H1 conclusivo solo a 700 anni, run A7) |
| CK-14 pattern piantati | si | A7: 136/136 sulla reimplementazione, 36/36 sul codice A4, con gemelli negativi per criterio, long e specchio. | S (sintetico) |
| CK-16/V21 reimplementazione indipendente | si | A7 sul reale: 8 serie (4 periodi x H1/M30 x CONT/INV), segnali ed episodi identici, 0 divergenze. Limite strutturale: A7 implementa la STESSA specifica, quindi un'interpretazione sbagliata condivisa (es. BAND_RIDING, sez. 2e) non emerge. | S |
| CK-20 hash CSV | si | `hash_dati_coincidono: True` x4 nel run; righe = audit A3. Codice: ho ricalcolato sha256 di engine/signals/params/run_test e test_*: coincidono con HASH_CODICE.txt e con `sha256_codice` del run. Documenti congelati: coincidono. | S |
| CK-21 unita spread | si | Spread nei trade 0,14-0,41 USD: plausibile per XAUUSD con 1 punto = 0,01 USD. | S |
| CK-22 copertura/buchi | si (A3) | Regola gap <= 180 min per l'ingresso: 0 trade con gap. Convenzione "barre esistenti" dichiarata. | S |
| CK-30 ipotesi primaria unica | si | Parte B congelata; il run riporta 1 primaria, 3 sotto-viste M30, 8 sensibilita. | S |
| CK-31 N minimo applicato | si | N=25 <30 -> INCONCLUSIVO, nessuna soglia ritoccata. | S |
| CK-32 hash prima del run | si | events.jsonl: E008 (documenti, 08:16) < E011 (codice, 09:34) < E012 (run, 09:36); registro A7: accesso ai CSV autorizzato e registrato alle 09:36:34, DOPO il run. Non posso provare l'assenza di esecuzioni non registrate (DA_VERIFICARE solo per logica: i file della V0 sono "mai eseguiti"). | S |
| CK-33 tabella interpretazioni | si | specifica sez. 8 (letta a campione). | S |
| CK-34 previsioni prima del run | si | criteri_previsioni_v1 congelato 08:16; scritto dopo A3/A5/A6. | S |
| CK-35 linea di base abbinata | si | B1: stesso periodo, stesso lato, D entro +-15%, stato di volatilita (sd<S50 e sd<=sd[-3]), esclusi i segnali; 2000 estrazioni; B0 e B2 esplorative. Abbinati 25/25. | S. Nota: l'abbinamento su D controlla la geometria, che e quello che serviva |
| Post-run A7: V10, V11, V12 (20/cella), V15, V17 | NE | V10: ho verificato a mano le somme (sez. 2a); V11 (due run, stesso hash): nessuna evidenza; V12: 6 trade a mano, non 20 per cella. | NON CHIUSI: la Parte A resta NON_VALUTATA |

## 2. Errori e anomalie nel risultato
### 2a. Coerenza imbuto T1 con T2 (verificata)
- Armati: 66+55+58+88 = 267 per CONT e per INV (stesso ciclo di vita); +1/-1: 131/136. Segnali: CONT 8+5+4+2 = 19, INV 1+1+1+3 = 6; eseguiti = segnali (0 scartati per posizione aperta, target oltre ingresso, gap, indicatori); N=25 = T2 = T3 (fasce 7+12+6; lato 11+14; periodi 9+6+5+5) = LOG (25). M30: 57+10 = 67. fine_episodi: 181+11+75 = 267. Nessuna incoerenza aritmetica.
- Casualita da non leggere: CONT C0 passa il 38,96% e C1a il 39,02% (perdita relativa 61,04% vs 60,98%): "stadio di maggiore perdita = tocco opposta" (Q15) e giusto per 0,06 punti.

### 2b. Il pareggio atteso ~78% non e un errore: e la geometria del segnale
- Ricalcolato dal LOG: distanza ingresso->target0 in ATR: media 0,97, mediana 1,00, min 0,23, max 1,74 (5 trade sotto 0,35 ATR). Pareggio = 3/(3+d): media 76,7% (= wr0 del run); con spread 78,4%. Il win rate osservato e 64% (CONT 57,9%, INV 83,3% su 6).
- Il cancello sd NON e la causa: Sa (senza `sd<S50`) da 27 trade contro 25; nel funnel CONT toglie 3 episodi su 23 (e il lag 1), in INV 0 su 6.
- Cause piu probabili (INFERENZA): (1) la selezione per stato: i segnali sono barre dove il tocco avviene a bande strette (nessuna candela >1,5 ATR nel ritracciamento: C1a elimina il 61% degli episodi che toccano; sd in calo) e dopo un ritracciamento lungo (dp 7-28 barre, mediana 16) in cui la SMA20 si e avvicinata al prezzo; (2) l'ingresso alla barra dopo: |ingresso - banda| mediano 0,36 ATR, cioe 37% della distanza media al target (il segno non e registrato, `abs`); (3) il ricalcolo del target a 3 ore accorcia ulteriormente.
- A3 lo aveva scritto prima del congelamento (audit_dati.md r.139-140: "se il pattern seleziona barre con bande strette (d ~ 1,1 ATR) il pareggio sale a ~73%; il test deve confrontare con il pareggio DELLE barre del segnale"). Q5 (58-70%, prob. 80%) usava il pareggio medio incondizionato (60-63%) contro un avviso gia in mano. E un difetto di previsione, non del test; il test ha risolto il problema con B1 abbinata su D.

### 2c. Contabilita dello spread
Coerente (CK-07). Un fatto operativo: in 2013 e 2018 lo spread e 0,14-0,32 USD contro target di 0,5-1,5 USD; nei 5 trade con d <0,35 ATR lo spread e piu della meta del premio lordo (es. 2013-03-13: premio 0,48 USD, spread 0,27). La media del costo e 0,023 R, che per i placebo era 0,04: piu bassa perche in 2025-26 (spread 0,2 su ATR 10-22) pesa pochissimo.

### 2d. Segno della media R rispetto a B1
- Osservata -0,16 R; B1: media nulla -0,009, p5 -0,178, p50 -0,001, p95 +0,146; percentile osservato 6,8% (p_B1 0,932 = frazione di estrazioni nulle >= osservata). Le linee di base B0 (0,94) e B2 (0,96) concordano. Il segno e coerente: nessuna inversione di lato (side = ep.d*lato_n; CONT dopo bulge rialzista = long, INV = short, come nel Riassunto; confermato da ricalcolo reale e da mano_trade_reali).
- Lettura corretta (IPOTESI, non risultato): i dati non mostrano alcun vantaggio e, se mai, vanno nel verso opposto; z ~ -1,5; test a due code p ~ 0,14. Con 25 trade e 16 vincite su un pareggio del 76,7%: P(<=16 vincite) = 0,11; per il solo CONT (11/19 su 75,2%) 0,074. Sono guardate fatte DOPO il risultato (esplorative) e non vanno scritte come "il pattern perde".
- Fragilita: il periodo 2013 vale -4,74 R su -4,0 totali (9 trade, p_B1 del periodo 0,99); togliendolo la media diventa +0,046 R e il PF 1,25 (T5, n=16). Il segno complessivo dipende da un singolo regime; i restanti 16 trade sono compatibili con zero.
- IC90 (bootstrap settimanale su 25 settimane = 25 trade): [-0,356 ; +0,029]. Il limite superiore e sotto eps=0,10: con N>=30 il verdetto sarebbe stato NESSUN VANTAGGIO RILEVANTE (PRELIMINARE). N=25 lo impedisce per soli 5 trade: il verdetto deve restare INCONCLUSIVO (regola congelata), ma il testo puo e deve riportare l'IC.

### 2e. Cause di morte dominanti e filtri che "si annullano" (trappole del RIASSUNTO_PER_TERZI)
- Dal JSON (somma dei 4 periodi): su 267 episodi armati, 162 (61%) muoiono per BAND_RIDING (`p - s > 20`) prima di toccare la banda opposta (36 prima della finestra, 126 dopo) e altri 12 per T_MAX; 256/267 episodi (96%) finiscono per un tetto di durata (181 BAND_RIDING + 75 T_MAX) e 11 per OPPOSTO. Resa: 25/267 = 9,4% (CONT 7,1%, INV 2,2%).
- E la trappola n. 3 del Riassunto ("tetto di durata auto-colpente"). Differenze: qui non azzera i setup (25 passano) e non e un tetto "della fase" ma una formalizzazione A1 ("in seguito `p - s <= 20`", specifica r.55) che NON viene dalla CK letterale (CK r.72: "impulso <= 20 candele", che a livello di barra e sempre vero: l'imbuto B6 passa 27.131 su 27.131 barre valide, cioe il criterio B6 e nullo). Il kill con `p` che si aggiorna uccide anche gli episodi che hanno ritracciato e poi ripartito.
- T_MAX NON e vincolante: Se50 da n=25 uguale alla primaria (Se20: 23). BAND_RIDING non ha NESSUNA sensibilita in T6: e la scelta con maggiore effetto sulla resa ed e l'unica non esplorata. [Raccomandazione] Dichiarare nel verdetto che la resa dipende in modo decisivo dalla lettura "p - s <= 20" e, se C0 vuole, una sensibilita POST-HOC su B6 (es. 30/40 barre o "solo alla barra di armamento"), registrata come esplorativa, non selezionabile, che non cambia il verdetto congelato.
- Altri filtri quasi inerti (sequenziali, quindi "inerti dopo gli altri"): SEQ elimina 8 episodi allo stadio C3 ma `episodi_eliminati_solo_da_SEQ` = 0 in H1 (1 in M30): in H1 la regola non cambia nessun segnale; `sd<S50` e `sd<=sd[-3]` passano il 100% in INV e rimuovono 3+1 episodi in CONT; I3 (banda piatta) 6/6 in INV. In INV l'intero blocco finale (I3, sd, sd lag) e ridondante dopo I2 e retest. Non sono errori; vanno solo riportati come "non vincolanti in questo campione" e non contati come "testati".
- Sb (INV con candela >1,0 ATR): 0 segnali INV (n=19 = solo CONT); `segnali_con_impulsiva_1.0_violata` = 25/25: conferma la trappola n. 1 del Riassunto; la primaria 1,5 e giusta.
- Sg (I1 solo da p): 31 segnali (30 trade), non svuota ne cambia la lettura: INV non e a zero per I1 (I1 perde 56%, ma e uno stadio fra molti).
- Non trovo "filtri che si annullano a vicenda" nel senso di zero segnali, ma trovo un imbuto in cui tre soli stadi (BAND_RIDING, tocco banda opposta, ritracciamento non impulsivo) decidono quasi tutto e due stadi dichiarati "misurati" (SEQ, sd) non incidono.

### 2f. Altre osservazioni
- 20 trade su 25 entrano in ora server 8-15; 9/25 nel 2013. Frequenza: ~5 trade/anno su H1 (25 su ~4,75 anni di dati). INFERENZA: SD(R)=0,60 (calcolata dal LOG); per vedere +0,10 R con potenza 80% servono ~225 trade (~43 anni a questo ritmo); per un IC90 con semi-ampiezza 0,10 ne servono ~100 (~19 anni). Estendere gli anni di D004 puo far uscire dall'INCONCLUSIVO (N>=30 e vicino) ma non puo rendere realistico un INDIZIO su H1-oro. M30 (67 trade) e esplorativo e non indipendente da H1 (stessi movimenti): non va sommato ne usato per "confermare".
- Il ricalcolo target e l'ingresso alla barra dopo sono scelte dichiarate (Guida/brief); i Protocolli parlano di entry limit sulla banda o market alla prima reazione: l'effetto della scelta sull'esito e non misurato (mi limito a dirlo).

## 3. Pre-mortem aggiornato: "fra sei mesi scopriamo che questo risultato era fuorviante"
1. (alta) Il risultato misura la traduzione, non la strategia: BAND_RIDING `p-s<=20`, T_MAX 30, ingresso alla barra dopo e SMA20 ricalcolata selezionano il 9% degli episodi, tutti con bande strette e target ~1 ATR. Con letture diverse (B6 solo all'armamento, ingresso al livello, target non ricalcolato) l'esito potrebbe cambiare segno. Non lo sappiamo e non lo abbiamo misurato.
2. (alta) Il segno e fatto da un solo anno (2013): leave-one-period-out +0,046 R senza 2013. Chiunque rifaccia il test con 4 anni diversi puo ottenere +0,05 o -0,3: a N=25 il "meno 0,16" e rumore.
3. (media) Fuori scopo: la Guida elenca MAJOR/MINOR (D1/H4/H1/M30); l'oro non c'e. Se Claudio o l'autore ripetono su EURUSD H1 trovano un'altra resa e un'altra geometria; il "no" sull'oro verra citato come "la strategia non funziona".
4. (media) Verifica non chiusa: V11 non eseguita, V12 a 6 trade, CK-01 reale su 1 cella. Un bug latente nel run completo (p. es. nel bootstrap, B1 o placebo; run_test.py e solo in parte ispezionato da A7 e da me) non emerge dai test sul nucleo.
5. (media) Lettura dei numeri: PF 0,51, p_B1 0,93, "IC fino a +0,03" vengono citati come prova di assenza di vantaggio (verdetto NESSUN VANTAGGIO che la regola congelata non assegna) o come "prova che il pattern e anti-predittivo".
6. (bassa) La fonte (D006) e confermata solo a parole: GUIDA_OPERATIVA_11.txt non coincide necessariamente con la guida firmata; Dichiarazione di Test = solo etichette; D15b (In-Bulge nel Pine) aperto; frase troncata sulla fine del bulge. Le interpretazioni su cui poggia BAND_RIDING sono nostre.
7. (bassa) Previsioni mal calibrate (Q1, Q5, Q14, Q17, Q19, Q23): se la relazione le usa per mostrare "il processo funziona" e fuorviante, vedi sez. 5.

## 4. Testo del verdetto: cosa si puo e non si puo dire
Si puo dire:
- Esito INCONCLUSIVO (N=25 <30; PRELIMINARE non assegnato). Verdetto automatico condizionale alla Parte A, che non e chiusa (V10, V11, V12, V17).
- Numeri descrittivi: N 25 (CONT 19, INV 6), media -0,16 R, PF netto 0,51, IC90 [-0,36 ; +0,03], p_B1 0,93, pareggio medio 78%, win rate 64%; sempre con "descrittivo, non stima di un effetto" e con la nota 2013 (senza: +0,05 R).
- "Su 4 periodi di oro H1 la traduzione produce ~5 operazioni/anno (9% degli episodi): troppo poche per concludere. I dati non mostrano alcun vantaggio; non lo escludono con le regole di decisione stabilite."
- Perimetro: oro fuori scopo della Guida (MAJOR/MINOR): ne un esito negativo confuta, ne uno positivo confermerebbe la strategia sui cross; M15 non testato (non ammesso); nessun dato EURUSD; 4 periodi = 4 regimi.
- Fonte: aggiornare la clausola 2: "Guida Operativa 11 confermata dal committente (INFORMAZIONE_DEL_COMMITTENTE, D006), non verificata da noi in modo indipendente"; restano mancanti: Dichiarazione di Test (solo etichette), screenshot standard; D15b aperto. L'addendum non tocca soglie/regole (hash invariato).
- Cosa e stato misurato e come: stop 3 ATR, target SMA20 ricalcolato ogni 3 ore, ingresso alla barra dopo, spread pagato (bid/ask), stop prima del target, nessuna uscita a tempo; soglie "molto/ordinato" = interpretazioni nostre (specifica sez. 8); pattern testati = soprainsieme dei validi per l'autore (congestione e rientro >=80% sono descrittori, non cancelli).
- Cosa e emerso come limite della traduzione: 61% degli episodi muore per BAND_RIDING (lettura `p-s<=20`), T_MAX non vincolante, SEQ e `sd` quasi inerti; target ~1 ATR contro stop 3 ATR (pareggio 77%).
- Prossimi passi: estendere i dati (D004) con una sola pre-registrazione, ma con aspettative esplicite (N~5/anno su H1); valutare se spostare la domanda su forex MAJOR/MINOR (Guida) e se chiarire con Claudio la lettura di B6 e dell'ingresso; non costruire EA ne indicatore sulla base di questo risultato.
Non si puo dire:
- "la strategia funziona / non funziona", "validata", "pronta per EA" (Parte C n. 9); "nessun vantaggio" senza "rilevante" e senza il vincolo N; "il pattern perde/e contro-tendenza/anti-predittivo"; "confermato su M30" (esplorativo, non indipendente); "p=0,93 = 93% di probabilita che non ci sia vantaggio" (e la frazione di estrazioni nulle >= osservata); "l'IC esclude il vantaggio" (la regola congelata lo consente solo da N>=30); qualunque estensione a EURUSD, FTMO, lotti, rischio, drawdown prop; "verificato localmente" finche V10, V11, V12, V17 non sono chiusi (formula A7, checklist sez. E: "NON prova un vantaggio statistico").
- Non attribuire il -0,16 a una causa (regime, 2013, geometria): e osservazione, non spiegazione.
- Le percentuali della Checklist (45-75%) non sono ne confermate ne smentite (campioni per fascia <30).
- Elencare nel testo i limiti non misurati: slippage, commissioni, swap, spread FTMO, drawdown/regole prop.

## 5. Previsioni Q1-Q26 gia valutabili (criteri_previsioni_v1, Parte F)
| Q | Previsione (prob.) | Osservato (run1) | Esito |
|---|---|---|---|
| Q1 | armati 40-250 (75%), <40 (15%), >250 (10%) | 267 | SBAGLIATO (accadde il 10%) |
| Q2 | N <30 (50%) | 25 | GIUSTO |
| Q3 | INCONCLUSIVO (50%) | INCONCLUSIVO | GIUSTO |
| Q4 | PF classi (se N>=30) | N<30; PF 0,51 (descrittivo) | N/A (condizione falsa) |
| Q5 | pareggio medio 58-70% (80%) | 78,4% (76,7% senza spread) | SBAGLIATO |
| Q6 | win rate >=55% (85%, non informativo) | 64% | GIUSTO (ma sotto il pareggio 77%) |
| Q7 | WR-WR0 >0 / >=+5 (se N>=30) | N<30; -12,7 punti | N/A (descrittivo: falso) |
| Q8 | p_B1 <=0,05/<=0,20/>=0,80 (se N>=30) | N<30; 0,932 | N/A (descrittivo: >=0,80) |
| Q9 | media nulla B1 in [-0,10;0] e PF in [0,80;1,02] (70%) | -0,009; PF p50 0,993 | GIUSTO |
| Q10 | LOPO (se m>0) | m<0 | N/A |
| Q11 | FINE_DATI+MKT <5% (90%) | 1/25 = 4% | GIUSTO (al limite) |
| Q12 | stesso minuto <1% (85%) | 0 | GIUSTO |
| Q13 | TARGET_OLTRE_INGRESSO <5% (80%) | 0 | GIUSTO |
| Q14 | SEQ elimina >=1 episodio CONT (85%); >=20% dei CONT che toccano (40%) | solo-SEQ H1 = 0 (M30 = 1); 8/90 = 8,9% (11/90 = 12% con SEQ violata) | prima parte SBAGLIATA; seconda GIUSTA (falso) |
| Q15 | CONT maggiore perdita = tocco banda opposta (70%) | C0 61,04% vs C1a 60,98% | GIUSTO (di 0,06 punti) |
| Q16 | INV maggiore perdita fra sd, retest, banda piatta (60%) | retest -73,9%; sd e banda piatta 0% | NON UNIVOCO (formulazione ambigua: indica solo "retest" se era l'opzione) |
| Q17 | N Sa >=2x primaria (80%) | 27 vs 25 | SBAGLIATO |
| Q18 | N M30 >=1,5x N H1 (60%) | 67 vs 25 = 2,7x | GIUSTO |
| Q19 | PF M30 < PF H1 (55%) | 0,666 vs 0,507 | SBAGLIATO |
| Q20 | placebo |z|<=3 al primo tentativo (90%) | |z| max 1,66 (INV_H1 non conclusivo, n=90) | GIUSTO (con la riserva di conclusivita) |
| Q21 | spread 0 sostituito <=1 trade (90%) | 0 | GIUSTO |
| Q22 | 2025-26 >50% del profitto (se m>0) | m<0 | N/A |
| Q23 | 2025-26 long > short (60%) | long 0,156 (n=2) < short 0,260 (n=3) | SBAGLIATO (n=5, senza significato) |
| Q24 | WR monotono per solidita (se >=3 fasce n>=8) | fasce n=7, 12, 6 | N/A |
| Q25 | n_prev (se n>=10 per strato) | n=4, 1 | N/A |
| Q26 | tutti i [B] di A7 SUPERATI al primo ciclo (45%) | V19 PARZIALE (S03), Parte A NON_VALUTATA, V10-V12/V17 aperti | NON AVVENUTO (coerente con 45%) |
- Bilancio: 12 giuste (inclusa Q14 seconda parte), 6 sbagliate (Q1, Q5, Q14a, Q17, Q19, Q23), 7 non valutabili (Q4, Q7, Q8, Q10, Q22, Q24, Q25), Q16 non univoca, Q26 evento non avvenuto (coerente con 45%). Brier medio sulle 16 previsioni binarie valutabili (esclusi Q1-Q3 multi-classe, Q16 non univoco): 0,218 (a 0,25 = nessuna informazione). Le giuste riguardano contabilita e robustezza del motore; gli errori riguardano la RESA e l'effetto dei filtri (Q1, Q14a, Q17) e la geometria (Q5), tutti sovrastimati con probabilita 80-85%. Lezione: gli imbuti vanno previsti con intervalli ampi, e un avviso di A3 va incorporato.

## 6. Punteggio di qualita proposto (griglia D001, stato: run1 + verifiche, prima della relazione finale R009)
| Dimensione | Peso | Mio punteggio | Evidenze |
|---|---|---|---|
| Aderenza | 15 | 90 | Brief rispettato: hash prima, previsioni scritte, spread pagato, stop-first, nessuna ottimizzazione, tutte le celle e sensibilita riportate; limite: oro fuori scopo Guida, traduzione "soprainsieme". |
| Correttezza ed evidenze | 25 | 88 | Ricalcolo indipendente di 92 trade reali identici, reimplementazione A7 con 0 divergenze sui 4 CSV, simmetria 1603 trade, placebo, mutanti 26/27, mio test di troncamento 0 differenze, aritmetica T1/T2/T3/LOG coerente. -12: V11 non eseguita, CK-01 reale su 1 cella, S03 chiuso solo per via indiretta, run_test.py ispezionato solo in parte, BAND_RIDING senza sensibilita. |
| Completezza | 15 | 82 | 16 celle + totali + sensibilita + B1/B0/B2 + T1-T9. Mancano: Parte A formalmente chiusa, relazione finale (R009), R010 (esempi PDF) non verificato nel run, B6 non esplorato, placebo a blocchi non eseguito. |
| Fattibilita e robustezza | 10 | 80 | Il run e riproducibile (hash, seed) ma il risultato e fragile (2013 decide il segno) e il disegno non puo produrre un verdetto sostantivo con ~5 trade/anno. |
| Utilizzabilita | 10 | 82 | Per Claudio il risultato e chiaro (INCONCLUSIVO, niente EA) ma i prossimi passi dipendono da decisioni sue (dati, scope forex, lettura di B6). |
| Verificabilita | 15 | 90 | Hash codice/dati/documenti, LOG con schedule dei target, JSON canonico con sha256, script di verifica di A7 rieseguibili. -10: V11/V12 aperti. |
| Qualita espositiva | 10 | 85 | primario.md e completo ma di 51 KB e illeggibile per un committente che vuole risposte brevi; serve la relazione finale breve. |
- Totale ponderato: 0,15*90 + 0,25*88 + 0,15*82 + 0,10*80 + 0,10*82 + 0,15*90 + 0,10*85 = 13,5 + 22,0 + 12,3 + 8,0 + 8,2 + 13,5 + 8,5 = **86,0** (soglia 90; nessuna dimensione sotto 80, ma Fattibilita e al limite).
- Per salire a >=90 senza toccare il verdetto: chiudere V10-V12/V17 (A7), registrare l'esito della seconda esecuzione (V11), una sensibilita POST-HOC dichiarata su B6 (opzionale), scrivere la relazione finale breve con le clausole di sez. 4. Non servono nuove soglie ne un secondo "primario".

## 7. Limiti della revisione
- Non ho rieseguito il run ne gli script di A7; il mio unico controllo e sintetico (trunc_check.py). Non ho ispezionato per intero run_test.py (bootstrap, placebo, tabelle) ne i test di A4.
- Le osservazioni 2d-2f sono calcolate su 25 trade scelti dopo il risultato: sono descrittive, non prove.
- Non ho letto V0_C0_RISERVATO: non era necessario per questa revisione.
