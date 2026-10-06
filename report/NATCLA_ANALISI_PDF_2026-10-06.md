# Ea Nat&Cla - Analisi fresca del PDF "Strategia SUPERTREND REVERSAL"

> BOZZA, NON PASSATA DAL CANCELLO. Non esce verso Claudio/VPS come verdetto: e' una estrazione.

**FILE** `data/natcla/ABTG-SUPERTREND_REVERSAL.pdf` (31 pagine, "Realise 04.05.2025", Alfio Bardolla Training Group; la copertina porta il marchio "Trading Forex Diary")
**FONTE UNICA** il PDF: testo (`ABTG-SUPERTREND_REVERSAL_testo.txt`) + immagini (`data/natcla/pdf_pagine/pNN.png` a 80 dpi; le pagine p08, p10, p11, p12, p20, p21, p22, p25, p26 e i ritagli di intestazione di p04/p08/p22 sono stati riletti a 150-400 dpi con pymupdf). Nessun web, nessun altro file del repo (sorgenti EA e resoconti NON letti), audio della collega NON analizzati qui.
**ETICHETTE** `[TRASCRITTO]` = c'e' scritto nel PDF (testo o scritta dentro l'immagine), cito. `[IMMAGINE]` = lo leggo da un grafico (descrivo, indico il pNN.png). `[INFERITO]` = lo deduco da piu' passaggi, dico quali. `[INCERTO]` = non determinabile. `DICHIARATO` = numero del relatore, NON verificato, MAI criterio nostro.

Pagine rilette una per una: 1-8, 10-12, 14-18, 20-23, 25, 26, 28, 30. Le pagine 2, 9, 13, 19, 24, 27, 29, 31 sono disclaimer / copertine di sezione / questionario / saluto, senza regole operative (il testo estratto e' completo per esse; p29 e' testo del questionario).

---

## 0. LA SINTESI IN CIMA (cosa e' davvero scritto)

**Cuore della strategia, nelle parole del PDF** (p05): *"La strategia Supertrend Reversal si basa sui rimbalzi del prezzo sul Supertrend, confermati da una candela successiva."*

**Regole core che un EA puo' leggere alla lettera:**
1. Indicatore: **Supertrend (10, 3.5)** `[TRASCRITTO p07]` (nelle immagini il Supertrend e' disegnato in tre linee 2.5 / 3.0 / 3.5, ma solo la **3.5** entra nelle regole: p11 passo 1, p20 fig.1, p25).
2. TF consigliati: **H4 - D1 - W1** `[TRASCRITTO p05, p06, p25]`.
3. **Tocco**: il prezzo "tocca o viola" il Supertrend **con l'ombra**, senza chiudere significativamente oltre (p06, p14, p20).
4. **Chiusura**: il corpo della candela chiude **vicino** al Supertrend (p14, p20, p25) - "vicino" NON quantificato.
5. **Conferma**: la candela successiva **apre all'interno** del Supertrend (floor/ceiling); se apre fuori il setup e' invalidato (p06, p14, p20, p25).
6. **Confluenza** (sine qua non, p21): un livello tecnico (S/R, EMA 200, Fibonacci) vicino al rimbalzo; se assente "e' consigliabile evitare l'operazione".
7. **Ingresso frazionato**: 1/3 a mercato + 2/3 su pendente a circa **+-20 pip** dal primo (p17, p21, p26), oppure due pendenti (1/3 e 2/3) se la candela successiva apre lontano dal Supertrend (p11, p21).
8. **SL**: sotto il minimo recente o il Supertrend (long), sopra il massimo recente o il Supertrend (short); i livelli tecnici prevalgono (p17). Nell'immagine p21 fig.4: "STOP LOSS a 5 PIP 2 Ordine pendente".
9. **TP**: livelli tecnici superiori (S/R D1/H4); primo obiettivo EMA 14, poi EMA 89, poi altri livelli/pivot (p17). Al primo obiettivo "posso ridurre la size e portare lo stop in pari" (p17; p18; p26).
10. **R/R minimo**: **>= 1:1** (p17) ma **>= 1:2** (p26): CONTRADDIZIONE.

**Cio' che NON e' meccanico e non e' quantificato** (e sono quasi tutte le condizioni di filtro): "vicino", "volatilita' sufficiente", "congestione", "gap/spike", "eventi macro imminenti", "distanza compatibile con la volatilita' media giornaliera", "barriere", Fibonacci (quale swing), Multipivot/Opposing (indicatore non descritto), metodo Larry Williams (non descritto).

**Contraddizioni principali** (dettaglio al §C): (1) timing della candela: p14 dice "seconda meta' = setup NON valido", p25 dice "seconda meta' = timing favorevole"; (2) R/R >=1:1 (p17) vs >=1:2 (p26); (3) il secondo ingresso e' "su breakout successivo" (p12) vs "pendente +-20 pip" (p17/p21/p26) vs nell'immagine p11 a ~10 pip; (4) TF consigliati H4/D1/W1 ma gli esempi di ingresso (p08, p11) sono su **H1**; (5) EMA 200 e' sia confluenza (p16, p21 fig.3) sia barriera (p14 riga 7); (6) la chiave del quiz p30 (Q3 = C) non coincide con la tabella p14.

**Bandiere rosse (regole di casa):** il frazionamento mette **2/3 della size sul secondo ingresso, piu' lontano dal prezzo e CONTRO il movimento** (media al peggio con size doppia del primo ingresso): bandiera "size crescente / media in perdita". Non ci sono martingala sulle perdite, griglie aperte, recovery, no-SL (lo SL c'e' sempre), ne' trucchi anti-prop. Dettaglio al §D.

**Numeri di performance nel PDF: ZERO** (nessun win rate, profitto, drawdown). I soli numeri sono esempi di mosse in pip (52 pip, 99 pip, ~100 pip) e non vanno trattati come statistiche.

**Domande aperte:** in coda, §F (27 domande, raggruppate).

---

## 1. SCHEDE PER SEZIONE DEL PDF

Convenzione colonne: **meccanizzabile** = si / no / parziale.

### PARTE I - Introduzione (pp. 3-8)

#### p03 - copertina Parte I
Disclaimer standard. Nessuna regola.

#### p04 - "Il Supertrend: dalla direzione alla decisione" (testo + immagine `p04.png`)
Testo `[TRASCRITTO]`: *"Creato da Oliver Seban per riconoscere l'inizio di una nuova fase di mercato. Combina direzione del trend e segnali operativi (buy/sell). Funziona come livello tecnico dinamico, adattandosi al prezzo. Usato in quattro modalita' principali: Supporto/Resistenza dinamica / Segnali di ingresso (cross del prezzo) / Conferma direzione trend / Impostazione di stop loss dinamici."*
Immagine `[IMMAGINE p04.png]`: grafico `EURUSD.bcm,H4` (intestazione leggibile a 400 dpi: "EURUSD.bcm,H4 1.13936 1.13950 1.13909 1.13927"), con tre linee Supertrend etichettate **S/T 2.5, S/T 3.0, S/T 3.5**. Le linee sono verdi sotto il prezzo nel trend rialzista, rosse sopra il prezzo nel ribasso; compaiono segmenti verticali gialli/arancioni ai cambi di direzione `[IMMAGINE]`.

| regola | valore | pagina | meccanizzabile | ambiguita' |
|---|---|---|---|---|
| Ideatore dell'indicatore | Oliver Seban | p04 | n/a | nessuna fonte per la formula esatta |
| Linee Supertrend mostrate | 2.5 / 3.0 / 3.5 (tre multipli) | p04 img, p08 img | parziale | non dice che le tre linee siano un unico indicatore multi-moltiplicatore ne' perche' le altre due servano |
| Quattro usi del Supertrend | S/R dinamica, ingresso su cross del prezzo, conferma trend, SL dinamico | p04 | parziale | solo il primo (S/R dinamica / rimbalzo) viene sviluppato nelle regole; "cross del prezzo" e "SL dinamico" non sono poi definiti (SL dinamico = trailing sulla linea? p17 lo usa come livello da cui piazzare lo SL, non dice se segue) |

#### p05 - "Il Supertrend: livello tecnico e bussola del reversal" (testo + immagine)
Testo `[TRASCRITTO]`: *"si basa sui rimbalzi del prezzo sul Supertrend, confermati da una candela successiva"*; *"Il Supertrend agisce come supporto o resistenza dinamica"*; *"Particolarmente efficace su timeframe ampi (H4, D1, Weekly), dove riduce il rumore di mercato e aumenta l'affidabilita' dei segnali"*; *"Piu' potente se combinato: Media Mobile 200 periodi / Livelli di Fibonacci / Supporti/Resistenze statiche"*.
Immagine `[IMMAGINE p05.png]`: ritaglio di grafico con ellisse tratteggiata blu attorno al punto in cui il Supertrend rosso e la "EMA A200" (linea rosa) quasi coincidono; Supertrend rosso (3 linee) che scende. Nessun testo numerico.

| regola | valore | pagina | meccanizzabile | ambiguita' |
|---|---|---|---|---|
| Logica | rimbalzo sul ST + candela successiva di conferma | p05 | si (nucleo) | "rimbalzo" e "conferma" definiti a p06/p14/p20 |
| TF efficaci | H4, D1, Weekly | p05 | si | "particolarmente efficace", non "obbligatorio" qui; p06 e p25 lo rendono "consigliato"/checklist |
| Rinforzi | EMA200, Fibonacci, S/R statiche | p05 | parziale | EMA200 si, Fibo/S&R no senza definizione |
| Ellisse: ST coincide con EMA200 | confluenza | p05 img | si (distanza ST-EMA200) | soglia di "coincide" mancante |

#### p06 - "Dal segnale al contesto: le regole del reversal" (tabella)
`[TRASCRITTO]` quattro punti chiave: **Timeframe consigliati: H4 - D1 - W1** ("Piu' affidabilita', meno rumore di mercato"); **Rimbalzo sul Supertrend**: *"Il prezzo tocca o viola il livello, segnale iniziale di possibile inversione"*; **Conferma della candela successiva**: *"Deve aprire all'interno del Supertrend per validare il setup"*; **Confluenza tecnica**: *"L'ingresso e' valido solo se supportato da livelli chiave (Fibonacci, EMA 200, S/R)"*.

| regola | valore | pagina | meccanizzabile | ambiguita' |
|---|---|---|---|---|
| TF | H4 - D1 - W1 | p06 | si | "consigliati", non vietato altro TF; ma esempi su H1 (p08, p11) |
| Rimbalzo = tocco/violazione del livello | prezzo "tocca o viola" | p06 | si (high/low vs linea ST) | "viola" quanto? p20 precisa: solo con l'ombra, senza chiudere significativamente oltre |
| Conferma = apertura candela successiva "all'interno" | open_next dentro il ST | p06 | si | "all'interno" = lato trend della linea? vedi §C-6 |
| Confluenza obbligatoria | S/R, Fibo, EMA200 | p06 | no/parziale | "valido solo se" -> obbligatoria; elenco di livelli non esaustivo (p26 aggiunge PTE, Weekly Open Line) |

#### p07 - "Costruire il contesto: il setup" (tabella)
`[TRASCRITTO]` **Indicatori essenziali:** *"Supertrend (10, 3.5): Livello chiave per individuare il rimbalzo"*; *"EMA 14 - 89 - 100 - 200: Supporti/resistenze dinamici e direzione macro"*; *"Livelli di Fibonacci: Zone di ritracciamento e confluenza"*; *"Multipivot & Opposing: Aree di decisione storica e strategica"*. **Opzionali:** *"W%R o RSI & Bollinger Bands: Filtri di eccesso, divergenze e volatilita'"*.

| regola | valore | pagina | meccanizzabile | ambiguita' |
|---|---|---|---|---|
| Supertrend | (10, 3.5) | p07 | si | il PDF non dice che "10" sia il periodo ATR ne' il metodo ATR, ne' il prezzo sorgente (HL2/close) `[INFERITO: 10=periodo, 3.5=moltiplicatore, da lettura standard; NON scritto]` |
| EMA | 14, 89, 100, 200 | p07 | si | prezzo applicato (close) non detto; metodo (EMA) dato dal nome |
| Fibonacci | zone di ritracciamento/confluenza; livelli 38.2, 50, 61.8 (p16) | p07, p16 | no | swing di riferimento non definito |
| Multipivot & Opposing | "aree di decisione storica e strategica" | p07 | no | indicatore/algoritmo non descritto; in p08 e' una colonna "OPPOSING" con etichette H1/M1/M5/M15 e linee pivot (R1-R3, S1-S3) disegnate |
| W%R o RSI + Bollinger | opzionali, nessun parametro | p07 | no | nessuna regola d'uso, nessun periodo/soglia |

#### p08 - "Il setup grafico della strategia" (immagine `p08.png`, 150 dpi)
Immagine `[IMMAGINE p08.png]`: grafico con intestazione leggibile a 400 dpi **"GBPAUD.bcm,H1 2.08432 2.08596 2.08310 2.08414"** e asse date 14-18 Apr 2025. Callout (frecce dal testo al grafico): **EMA 200, S/T 3.5, Pivot Fibo** (tre a destra in alto, vicino al prezzo che risale sotto il ceiling rosso), **EMA 100, EMA 89, EMA 14, S/T 2.5, S/T 3.0** (in basso). Una colonna verticale "OPPOSING" con etichette H1, M1, M5, M15 a destra. Linee pivot tratteggiate con etichette R1/R2/R3/S1/S2/S3 e "Pivot" `[IMMAGINE]`.

| regola | valore | pagina | meccanizzabile | ambiguita' |
|---|---|---|---|---|
| Mappa di lettura | ST 3.5 + EMA 14/89/100/200 + Pivot Fibo + Opposing | p08 img | parziale | Pivot Fibo/Opposing non definiti; nessun valore numerico |
| TF del grafico d'esempio | H1 | p08 img | n/a | contraddice "H4-D1-W1" di p06 (vedi §C-4) |
| Simbolo del grafico d'esempio | GBPAUD (intestazione), ma p11 mostra lo stesso grafico etichettato "GBPCHF" | p08 img / p11 | n/a | incoerenza di etichetta (§C-8) |

---

### PARTE II - La strategia (pp. 9-12)

#### p09 - copertina Parte II
Disclaimer. Nessuna regola.

#### p10 - "Le regole di ingresso. Due vie per lo stesso obiettivo" (due immagini `p10.png`)
Immagini `[IMMAGINE p10.png]`:
- **Sinistra - "Ingresso con ordini pendenti (Or. passivo)"**: candele H-like in salita verso il Supertrend rosso (linea spessa rossa) e la EMA200 (rosa) sopra; l'ultima candela ha una lunga ombra superiore che attraversa il ST. Etichette: **"OP 2 - size 2/3"** (in cima all'ombra, sopra il ST e vicino a "R1 2.08585") e **"OP 1 - size 1/3"** (in prossimita' della linea ST). Etichetta pivot "Pivot 2.08196".
- **Destra - "Ingresso con ordini market (Or. attivo)"**: candela verde grande, poi candela piccola rossa con ombra superiore che tocca il ST rosso, poi candela rossa che e' marcata **"Ingresso Market"**; etichette pivot (R1/R2/R3/S1/S2) con valori nell'ordine di 0.588-0.595 (cifre minuscole, lettura approssimata) `[IMMAGINE]`. Simbolo e TF non leggibili `[INCERTO]`.

| regola | valore | pagina | meccanizzabile | ambiguita' |
|---|---|---|---|---|
| Due modalita' di ingresso | passiva (due pendenti) / attiva (market) | p10 | si | quando usare l'una o l'altra: p21 (apertura vicina -> market + pendente; lontana -> due pendenti) |
| Size pendenti | OP1 1/3, OP2 2/3 | p10 img | si | "della size" = di quale size totale? (rischio totale, lotti?) |
| Short su ST ceiling: ingresso marcato sulla candela successiva (rossa) al tocco | market | p10 img destra | si | prezzo esatto di ingresso (open? dopo movimento?) |

#### p11 - "Regole di ingresso con ordine pendente" (testo + immagine `p11.png`)
Testo `[TRASCRITTO]`: **1** *"Overview dell'operativita': Il prezzo si trova ad una distanza del Supertend 3.5 compatibile con la volatilita' media giornaliera"*; **2** *"Presenza di livello tecnico a sostegno del reverse: S/R, Fibonacci o EMA aumentano la validita' del segnale"*; **3** *"Posiziono due ordini pendenti: 1 ordine = 1/3 della size / 2 ordine = 2/3 della size / S/L e T/P come da money manegement"*.
Immagine `[IMMAGINE p11.png]` (150 dpi): etichetta **"GBPCHF.bcm H1"** e **"Volatilita' media GBPCHF ~100 PIP"**; una freccia blu da un minimo fino al ST con scritta **"99. PIP"** (movimento di circa 99 pip prima di arrivare sul ST); **"OP 1 - size 1/3"** e **"OP 2 - size 2/3"** vicino al ST rosso/EMA200 rosa, con OP1 piu' vicino al ST e OP2 piu' in alto; sull'asse prezzo `[IMMAGINE]` compaiono i riquadri **2.08505** (OP1) e **2.08604** (OP2): differenza ~**9,9 pip** (lettura visiva, approssimata). Intestazione stessa scala prezzi del grafico di p08 (2.0845...).

| regola | valore | pagina | meccanizzabile | ambiguita' |
|---|---|---|---|---|
| Distanza prezzo-ST "compatibile con la volatilita' media giornaliera" | esempio: GBPCHF volatilita' media ~100 pip, mossa di 99 pip | p11 testo + img | parziale | `[INFERITO]` = prima del tocco il prezzo ha percorso circa 1 ADR; nessuna soglia/tolleranza scritta, nessun "ADR" definito (periodo, metodo) |
| Livello tecnico a sostegno | S/R, Fibonacci o EMA | p11 | parziale | vedi confluenze |
| Due ordini pendenti | 1/3 + 2/3 della size | p11 | si | direzione dei pendenti: nell'immagine OP2 e' PIU' LONTANO dal prezzo di OP1, cioe' contro il movimento (short: OP2 sopra OP1) |
| Distanza tra OP1 e OP2 | immagine ~10 pip (lettura approssimata); testo p17/p21/p26: +-20 pip | p11 img vs p17/p21 | si | contraddizione 10 vs 20 (§C-3), il tipo di pendente (limit vs stop) non e' scritto |
| SL/TP | "come da money management" | p11 | no | nessun valore |

#### p12 - "Regole di ingresso con esecuzione a mercato" (testo + immagine `p12.png`)
Testo `[TRASCRITTO]`: **1** *"Rimbalzo evidente sul Supertrend"*; **2** *"Candela chiude vicino al livello, con struttura di indecisione o inversione"*; **3** *"La candela successiva apre all'interno del Supertrend e conferma la direzione"*; **4** *"Esiste una confluenza tecnica a supporto dell'operazione"*; *"Ingresso Market con size frazionata (es. 1/3 ora, 2/3 su breakout successivo); S/L e T/P come da money manegement"*.
Immagine `[IMMAGINE p12.png]`: stesso grafico di p10-destra: ST rosso spesso, **"Res D1"** (linea tratteggiata verde in alto), **"OP 2 - size 2/3"** disegnato al livello Res D1 (SOPRA l'ingresso, quindi contro il movimento in un short), **"Ingresso Market - 1/3 size"** sulla candela rossa dopo il tocco; pivot R1-R3/S1/S2.

| regola | valore | pagina | meccanizzabile | ambiguita' |
|---|---|---|---|---|
| Rimbalzo "evidente" | non definito | p12 | no | "evidente" non misurabile |
| Candela di tocco: struttura di "indecisione o inversione" | non definita (doji? pin bar? engulfing?) | p12 | parziale | nessun criterio di forma (rapporto ombra/corpo) |
| Candela successiva "apre all'interno e conferma la direzione" | open dentro il ST + "conferma" | p12 | parziale | "conferma la direzione" = deve muoversi/chiudere nel verso? (p21: "Entra immediatamente se il prezzo si muove nella direzione prevista") |
| Frazionamento market | 1/3 market ora, 2/3 "su breakout successivo" | p12 | parziale | "breakout successivo" non definito e diverso da "pendente +-20 pip" (p17); nell'immagine OP2 e' a "Res D1" (livello di resistenza D1), cioe' un livello tecnico, non un offset in pip |

---

### PARTE III - Studio Setup e Money management (pp. 13-18)

#### p13 - copertina Parte III. Disclaimer.

#### p14 - "Setup valido o non valido? Impara a riconoscerli in 10 secondi" (tabella, testo)
Tabella `[TRASCRITTO]` (7 righe: Valido / Non valido):
1. Interazione con ST: *"Il prezzo tocca o viola il Supertrend (con l'ombra)"* / *"Nessun contatto tra prezzo e Supertrend"*.
2. Chiusura: *"Candela chiude vicino al Supertrend"* / *"Chiusura troppo lontana dal livello"*.
3. Apertura candela successiva: *"Apre all'interno del Supertrend"* / *"Apre fuori dal Supertrend (setup invalidato)"*.
4. Livelli tecnici: *"Presente una confluenza con EMA/Fibo/S&R"* / *"Nessun livello tecnico visibile o troppo distante"*.
5. Timing: *"Il prezzo arriva sul Supertrend nella prima meta' della candela"* / *"Il contatto avviene nella seconda meta' della candela in particolare ultimi 5 min, rischio di rottura"*.
6. Contesto/volatilita': *"Volatilita' normale o favorevole al movimento"* / *"Mercato piatto o con gap/spike irregolari"*.
7. Barriere: *"Nessuna barriera tecnica imminente"* / *"Ostacoli vicinissimi al target (Fibo, EMA200, livelli psicologici)"*.

| regola | valore | pagina | meccanizzabile | ambiguita' |
|---|---|---|---|---|
| Tocco con l'ombra | high/low oltre la linea ST | p14 r1 | si | |
| Chiusura vicino | non quantificata | p14 r2 | parziale | serve una distanza (es. in ATR o % del range) |
| Apertura successiva dentro | open_next lato-trend della linea | p14 r3 | si | definizione di "dentro" (§C-6) |
| Livello tecnico vicino | EMA/Fibo/S&R "ne' troppo distante" | p14 r4 | parziale | distanza non quantificata |
| **Timing**: primo tempo valido / secondo tempo non valido, "in particolare ultimi 5 min" | meta' candela; ultimi 5 minuti | p14 r5 | parziale (serve dato intrabarra) | **CONTRADDICE p25** (§C-1); su TF H4/D1 "ultimi 5 min" ha senso solo su dato intrabarra |
| Volatilita' | normale/favorevole vs piatto o gap/spike | p14 r6 | no | nessuna soglia |
| Barriere dopo l'ingresso | nessuna imminente (Fibo, EMA200, tondi) | p14 r7 | parziale | "vicinissimi" non quantificato; EMA200 qui e' barriera (vedi §C-5) |

#### p15 - "Barriere tecniche: quando la strategia va messa in pausa" (testo)
`[TRASCRITTO]` quattro condizioni di non operativita': **"La candela non tocca ne' viola il floor del Supertrend -> Nessun rimbalzo = nessun pattern = nessun ingresso"**; **"Presenza di congestione o volatilita' insufficiente -> Il prezzo si muove lateralmente, senza direzione"**; **"Presenza di gap o spike irregolari -> I movimenti improvvisi alterano la lettura tecnica"**; **"Supporti o resistenze statiche troppo vicine al punto d'ingresso -> Rischio di rimbalzo contrario o mancato spazio operativo"**.

| regola | valore | pagina | meccanizzabile | ambiguita' |
|---|---|---|---|---|
| Nessun tocco = nessun ingresso | | p15 | si | |
| Congestione / volatilita' insufficiente = fuori | non quantificato | p15 | parziale | serve soglia (ATR/ADX/range) - ADX non e' nel PDF |
| Gap/spike irregolari = fuori | non quantificato | p15 | parziale | soglia gap/spike non data |
| S/R statiche "troppo vicine" all'ingresso = fuori | non quantificato | p15 | parziale | distanza minima in pip/ATR mancante |

#### p16 - "Condizioni da monitorare, non da evitare" (testo)
`[TRASCRITTO]` **1.** *"La coincidenza del rimbalzo sul Supertrend con un livello di Fibonacci (es. 38.2%, 50%, 61.8%) rafforza il segnale. Il problema si pone solo se il Fibonacci agisce come ostacolo immediato all'estensione del movimento, ad esempio nel caso di un TP troppo vicino o irraggiungibile a causa di un Fibo forte."* **2.** *"Se il Supertrend coincide con la EMA 200 o con un numero tondo importante (es. 1.3000, 1.5000), si tratta di una confluenza tecnica molto potente. In questi casi, l'affidabilita' del pattern aumenta, perche' l'inversione e' protetta da piu' livelli difensivi."*

| regola | valore | pagina | meccanizzabile | ambiguita' |
|---|---|---|---|---|
| Fibonacci retracement | 38.2%, 50%, 61.8% | p16 | parziale | swing di partenza/arrivo non detto; ritracciamento di che gamba? |
| Fibo come ostacolo al TP | TP "troppo vicino/irraggiungibile" => problema | p16 | parziale | distanza minima TP-Fibo non data |
| Numeri tondi | es. 1.3000, 1.5000 | p16 | si (livelli a passo fisso) | il passo dei "tondi" per ogni simbolo (es. 0.0050? 0.0100?) non detto; esempi solo su forex a 4-5 decimali |
| ST coincidente con EMA200 | confluenza "molto potente" | p16 | si | tolleranza di "coincide" non data |

#### p17 - "Strategia OK, ma e' la gestione che fa il trade" (tabella, testo)
`[TRASCRITTO]`:
- **Esecuzione iniziale (size frazionata):** *"1/3 della posizione entra a mercato, se il segnale e' valido e confermato. 2/3 rimanente su ordine pendente +-20 pips, per evitare ingressi prematuri."*
- **Gestione SL:** *"In posizione long -> SL sotto il minimo recente o il Supertrend. In posizione short -> SL sopra il massimo recente o il Supertrend. SL dinamico = spazio per respirare, ma senza compromettere il rischio. Se presenti livelli tecnici prevalgono i livelli tecnici."*
- **Gestione TP:** *"Posizionato su livelli tecnici superiori (supporti/resistenze su D1, H4...) Quando arrivo al primo obiettivo posso ridurre la size e portare lo stop in pari. La EMA 14 e' il primo obiettivo naturale che i prezzi raggiungono. Segue poi, la EMA 89, infine posso valorizzare anche gli altri livelli tecnici o livelli pivot. Rischio/Rendimento minimo consigliato: >= 1:1)."*

| regola | valore | pagina | meccanizzabile | ambiguita' |
|---|---|---|---|---|
| 1/3 a mercato | 33,3% della "posizione" | p17 | si | "posizione" = rischio o lotti totali? |
| 2/3 su pendente | 66,7% su ordine pendente a +-20 pip dal primo | p17 | si | "+-20 pips": direzione (contro? a favore?) ambigua nel testo; l'immagine p21 fig.4 lo mostra CONTRO (sotto il ST per un long); pip su qualunque simbolo/TF (CHFJPY, GBPAUD, D1/H1) con lo stesso numero? |
| SL long | sotto min recente o ST | p17 | parziale | "o": quale dei due? il piu' lontano? il piu' vicino? "minimo recente" = quante barre? |
| SL short | sopra max recente o ST | p17 | parziale | idem |
| "I livelli tecnici prevalgono" sullo SL | | p17 | no | quali, a che distanza, quale priorita' fra min recente/ST/livelli |
| TP | livelli tecnici superiori (S/R D1, H4) | p17 | no/parziale | nessuna regola di scelta fra livelli; nessun TP numerico |
| Primo obiettivo | EMA 14 (poi EMA 89, poi altri livelli/pivot) | p17 | si | e' un target mobile (EMA si muove); e' prezzo corrente della EMA al momento dell'ingresso o dinamico? |
| Riduzione size al primo obiettivo | "posso ridurre la size" (facoltativo) | p17 | parziale | frazione non detta; "posso" non e' una regola |
| Break-even al primo obiettivo | "stop in pari" | p17 (e p18, p26) | si | "in pari" = prezzo medio di entrata? con 2 ordini a prezzi diversi, quale prezzo? |
| R/R minimo | **>= 1:1** | p17 | si | **contraddice p26 (>= 1:2)** |

#### p18 - "La strategia protegge, il money management conserva" (tabella)
`[TRASCRITTO]`: *"Break-even dopo il primo target raggiunto: Sposta lo SL a pari per eliminare il rischio residuo"*; *"Lascia correre le operazioni su timeframe ampi: Piu' ampio e' il TF, piu' valore ha la pazienza"*; *"Adatta SL e TP alla volatilita' attuale: Stop troppo stretti = falsi stop-out | Stop troppo ampi = gestione inefficiente"*; *"Preferisci SL su livelli tecnici e multipivot: La struttura del grafico ti da' zone reali di difesa, non numeri arbitrari"*; *"Obiettivo finale: Conservare il capitale, ridurre l'impatto degli errori"*.

| regola | valore | pagina | meccanizzabile | ambiguita' |
|---|---|---|---|---|
| BE dopo il primo target | SL a pari | p18 | si | "primo target" = EMA 14 (p17)? |
| Lascia correre su TF ampi | nessun trailing/cap descritto | p18 | no | nessuna regola d'uscita oltre TP/BE |
| SL/TP adattati alla volatilita' | nessuna formula (ATR?) | p18 | no | tensione con quiz p29 Q4 (opzione "SL in base alla volatilita' media" = risposta B, ma la chiave dice C) |
| SL su livelli tecnici/multipivot | | p18 | no | multipivot non definito |
| Rischio per trade (%), massimo drawdown, numero di trade aperti | **NON PRESENTI** | p18 | - | assenti (§E) |

---

### PARTE IV - Case study (pp. 19-23)

#### p19 - copertina Parte IV. Disclaimer.

#### p20 - "Case study: reversal su Supertrend con ingresso market" (testo + Figure 1, 2 in `p20.png`, 150 dpi)
Testo `[TRASCRITTO]`: *"Rimbalzo sul livello del Supertrend: Il prezzo tocca o viola con la sola 'ombra' della candela il Supertrend senza chiudere significativamente al di sopra o al di sotto. Questo movimento e' considerato un potenziale punto di inversione. Il rimbalzo diventa significativo se il corpo della candela chiude vicino al Supertrend, suggerendo una perdita di forza del trend attuale."* *"Apertura della candela successiva: deve avvenire all'interno del 'floor' del Supertrend. In caso contrario, il segnale e' invalidato. [...] Se il prezzo apre al di fuori del 'floor', nella candela successiva, il segnale viene invalidato."*
Immagini `[IMMAGINE p20.png]`: **Fig.1** una serie di candele rosse discendenti verso una linea verde piatta (il ST); l'ultima candela (piccola, rossa) ha l'ombra inferiore che attraversa la linea; didascalia dentro la figura *"La candela viola con la sua ombra il livello di SUPERTREND 3.5"*; una linea rossa piu' in basso. **Fig.2** stessa sequenza + una candela verde minuscola che apre appena sopra la linea verde; didascalia *"La candela successiva apre all'interno del 'floor' del SUPERTREND in prossimita' dello stesso"*; la linea rossa in basso e' etichettata **"EMA 200"**.

| regola | valore | pagina | meccanizzabile | ambiguita' |
|---|---|---|---|---|
| Tocco con l'ombra, senza chiudere "significativamente" oltre il ST | | p20 | si | quanto e' "significativamente"? Se il corpo chiude oltre di poco (violazione di chiusura), conta come setup o no? |
| Chiusura vicina | corpo chiude vicino al ST | p20 | parziale | non quantificata |
| Apertura successiva "all'interno del floor" | open_next al di qua della linea (nel verso del trend ST) | p20 fig.2 | si | `[INFERITO]` dalla fig.2 (la candela verde apre SOPRA la linea verde, a pochi pip) |
| Apertura "in prossimita'" | | p20 fig.2 | parziale | distanza non quantificata; p21 distingue apertura vicina vs lontana |
| ST 3.5 | etichettato nella fig.1 | p20 | si | conferma che e' la 3.5 la linea del rimbalzo |

#### p21 - "Dalla conferma all'esecuzione: ordine market e struttura tecnica" (testo + Figure 3, 4 in `p21.png`, 150 dpi)
Testo `[TRASCRITTO]`: *"Una condizione sine qua non per confermare l'ingresso e' la presenza di un livello tecnico, nelle immediate vicinanze del rimbalzo, che fa da argine alla potenziale prosecuzione del trend rafforza il segnale. Se assente, e' consigliabile evitare l'operazione. Per tracciare i livelli di supporto e resistenza e' sempre consigliabile usare il metodo di Larry Williams."* *"Ingresso e gestione ordini: Se l'apertura della candela successiva avviene all'interno ed in prossimita' del Supertrend si posiziona: un Ordine a mercato: Entra immediatamente se il prezzo si muove nella direzione prevista. Un Ordine pendente: Piazzato sopra/sotto il Supertrend per evitare falsi segnali a circa 20 PIPO dal primo ordine. Se invece il prezzo apre lontano dal supertrend si posizionano due ordini pendenti con il criterio anzidetto."*
Immagini `[IMMAGINE p21.png]`: **Fig.3** sequenza discendente verso linea verde (ST) con linea rossa sotto etichettata **"La EMA 200 forma un livello tecnico che ostacola la prosecuzione del TREND"** (cioe' la EMA 200 e' il livello "argine" dietro il ST, dal lato dove il prezzo andrebbe se il trend proseguisse). **Fig.4**: il rimbalzo e la salita; etichette **"Take profit"** (a livello della media blu, in alto), **"1 Ordine a Mercato"** (appena sopra la linea ST verde), **"2 Ordine (pendente)"** (SOTTO la linea ST verde e vicino alla EMA200 rossa), in rosso **"STOP LOSS a 5 PIP 2 Ordine pendente"** (lo SL sta 5 pip oltre il 2 ordine).

| regola | valore | pagina | meccanizzabile | ambiguita' |
|---|---|---|---|---|
| Confluenza = condizione "sine qua non" | livello tecnico "nelle immediate vicinanze" | p21 | parziale | distanza; quali livelli; il metodo Larry Williams non e' descritto |
| Metodo S/R | "metodo di Larry Williams" | p21, p25 | no | metodo non descritto nel PDF |
| Apertura vicina al ST | market immediato "se il prezzo si muove nella direzione prevista" + 1 pendente | p21 | parziale | "si muove nella direzione prevista" = quanti pip / quanto tempo? |
| Pendente | "sopra/sotto il Supertrend", "circa 20 PIPO dal primo ordine" ("PIPO" = refuso) | p21 | si | "sopra/sotto": per un long, SOTTO (fig.4); 20 e' "circa" |
| Apertura lontana | "due ordini pendenti con il criterio anzidetto" | p21 | parziale | "lontana" non quantificata; il primo dei due dove sta? |
| SL | **5 pip oltre il 2 ordine pendente** (fig.4) | p21 fig.4 | si (nell'esempio) | e' solo scritta in figura, non nel testo; p17/p26 dicono "sotto/sopra ST o min/max recente": quale vale? |
| TP | a livello della media blu (fig.4) | p21 fig.4 | parziale | `[IMMAGINE]` coerente con "EMA 14 primo obiettivo" di p17, ma la figura non nomina la EMA |

#### p22 - "D1 e H4: i timeframe dell'eccellenza" (immagine `p22.png`, 150 dpi + ritaglio a 400 dpi)
Immagine `[IMMAGINE p22.png]`: screenshot MT5 (sfondo nero) **"CHFJPY.bcm,H4 174.597 174.799 174.275 174.362"**, pannello ordine con **0.20** lotti (SELL 174.363 / BUY 174.382, quindi spread leggibile ~**1,9 pip** `[INCERTO: sono le due quote in pannello, lettura a 400 dpi]`; in basso a destra "Spread: 9" `[INCERTO: illeggibile]`). Tre linee Supertrend rosse sopra il prezzo (ceiling a 174.78 piatto), medie, e due sotto-finestre: **"PeakRepairerStrict"** (indicatore non nominato altrove) e **"ATR(14) 0.4351"**. Etichette: **"1^ violazione"**, **"2^ violazione"**, **"Rimbalzo deciso"** (tre candele consecutive che arrivano al ceiling: verde, rossa con ombra, rossa decisa), parentesi **"52 PIP"** (dal ceiling al livello dove arriva la discesa), e **"Possibile obiettivo se compatibile con ATRh1"** con freccia verso una media blu. Asse date "9 May 2025 ... 21 May 08:00". Elenco schede-grafico in basso: UKOIL, D30EUR, SPXUSD, 225JPY, USOIL, GBPUSD, GBPJPY, AUDCAD, EURUSD, GBPCAD, EURGBP, CHFJPY (M5/M15/H1/H4/Daily).

| regola | valore | pagina | meccanizzabile | ambiguita' |
|---|---|---|---|---|
| "D1 e H4: TF dell'eccellenza" | titolo | p22 | si | |
| Violazioni multiple del ST prima del rimbalzo | "1^ violazione", "2^ violazione", "rimbalzo deciso" | p22 img | no/parziale | il PDF non dice se serve una seconda violazione, se la prima va ignorata, ne' quale delle tre candele e' il "segnale" (tocco) e quale la "conferma" |
| Esempio di movimento | **52 pip** (DICHIARATO, esempio, non statistica) | p22 img | n/a | misura da dove a dove: dal ceiling (174.78) circa al livello del rimbalzo `[INCERTO]` |
| Obiettivo | "compatibile con ATRh1" | p22 img | no | "ATRh1": ATR su H1? ATR orario? ATR(14) dichiarato nel pannello sotto (0.4351 su H4) |
| Indicatore "PeakRepairerStrict" | presente nel grafico, non spiegato | p22 img | no | non appartiene ai passaggi della strategia nel testo |
| Simboli: CHFJPY H4 | esempio | p22 img | n/a | gli indici/petrolio nell'elenco schede non sono citati come mercato della strategia |
| Date nel grafico | fino al 21 May 2025 | p22 img | n/a | precedono/seguono la data di "Realise 04.05.2025"? (§C-9) |

#### p23 - "Takeaway finali" (testo)
`[TRASCRITTO]`: *"Strategia adatta a trader tecnici e pazienti. Richiede capacita' di lettura e attesa del segnale giusto. Essenziale la disciplina operativa. Seguire la procedura e' piu' importante che 'avere ragione'. Check-list, confluenze e money management = chiavi del successo. Il vero vantaggio e' strutturale, non emotivo."* Nessuna regola operativa. (Il "vantaggio strutturale" e' un'affermazione senza numeri: DICHIARATA, NON verificata.)

---

### PARTE V - Check list operativa (pp. 24-26)

#### p24 - copertina Parte V. Disclaimer.

#### p25 - "Check list operativa. Parte 1: prima di premere buy o sell" (testo + immagine `p25.png`)
`[TRASCRITTO]` **1. Condizioni di contesto:** *"Timeframe corretto (H4, D1 o Weekly)"*; *"Volatilita' sufficiente / assenza di congestione"*; *"No eventi macro imminenti / calendario economico controllato"*. **2. Segnale tecnico:** *"Il prezzo tocca o viola con l'ombra il livello del Supertrend (3.5)"*; *"Il corpo della candela chiude vicino al Supertrend (non lontano)"*; *"La candela successiva apre all'interno del Supertrend (floor/ceiling)"*; *"Timing favorevole: il contatto avviene nella **seconda meta' della candela**"*. **3. Confluenze tecniche:** *"Presenza di livello statico o dinamico (S/R, EMA 200, Fibo) vicino al punto di rimbalzo"*; *"Supporto/resistenza tracciato con metodo (es. Larry Williams o multipivot opposing)"*; *"Nessuna barriera tecnica immediata in direzione del trade (es. Fibo ostile o congestione)"*.

| regola | valore | pagina | meccanizzabile | ambiguita' |
|---|---|---|---|---|
| TF | H4, D1, Weekly | p25 | si | |
| Volatilita'/congestione | "sufficiente/assenza" | p25 | no | nessuna soglia |
| Eventi macro | "no eventi imminenti" | p25 | parziale | finestra pre/post-evento e impatto non dati |
| Tocco con ST 3.5 | | p25 | si | |
| Corpo chiude vicino | | p25 | parziale | non quantificato |
| Apertura successiva dentro | | p25 | si | |
| **Timing: contatto nella SECONDA meta' della candela = favorevole** | | p25 | parziale | **contraddice p14** (§C-1) |
| Confluenze statica/dinamica | S/R, EMA200, Fibo | p25 | parziale | |
| Nessuna barriera immediata | | p25 | parziale | |

#### p26 - "Check list operativa. Parte 2: ingresso, gestione e mentalita'" (testo + immagine `p26.png`)
`[TRASCRITTO]` **4. Confluenze con altre strategie:** *"EMA 200"*, *"PTE"*, *"WEEKLY OPEN LINE"* (tre voci senza spiegazione). **5. Piano di ingresso:** *"Entry a mercato (1/3 size) se il pattern e' chiaro"*; *"Entry pendente (2/3 size) +-20 pip dal primo ingresso"*; *"SL dinamico posizionato sotto/sopra il Supertrend o minimo/massimo recente"*; *"TP calcolato su livelli tecnici superiori + RR >= 1:2"*. **6. Gestione del follow-up:** *"Porta lo SL a pareggio dopo il primo TP"*; *"Lascia correre le operazioni su TF ampi se il contesto lo consente"*; *"Nessuna modifica impulsiva in corso d'opera (rispetta il piano)"*; *"Documenta il trade nel diario operativo"*.

| regola | valore | pagina | meccanizzabile | ambiguita' |
|---|---|---|---|---|
| Confluenze con altre strategie | EMA 200, PTE, Weekly Open Line | p26 | no/parziale | **PTE** e **Weekly Open Line** non definiti nel PDF (rimandano ad altre strategie ABTG, non fornite qui); non si sa se siano filtri o solo "confluenze" opzionali |
| Entry market | 1/3 size | p26 | si | |
| Entry pendente | 2/3 size, +-20 pip dal primo ingresso | p26 | si | |
| SL | sotto/sopra ST o min/max recente | p26 | parziale | vedi p17 |
| TP + RR | livelli superiori; **RR >= 1:2** | p26 | parziale | **contraddice p17 (>= 1:1)** |
| BE dopo il "primo TP" | SL a pareggio | p26 | si | |
| Trailing | nessuno descritto | p26 | - | assente |
| Diario operativo | | p26 | n/a | non e' regola di EA |

---

### PARTE VI - Questionario (pp. 27-31)

#### p27 - copertina Parte VI. Disclaimer.

#### p28-p29 - Questionario (testo + `p28.png`)
Domande e risposte multiple `[TRASCRITTO]`:
- **Q1** "pattern di reversal e' valido quando": A chiude sopra EMA14; B rimbalza sul ST e chiude lontano; **C tocca il ST con l'ombra e la candela successiva apre all'interno del livello**; D prezzo laterale.
- **Q2** ruolo della candela successiva: A target; B continuita' del trend; **C validare il rimbalzo aprendo all'interno del ST**; D segnale RSI.
- **Q3** "Quando e' sconsigliato entrare a mercato": A confluenza con EMA200; **B prezzo arriva sul ST nella seconda meta' della candela**; **C prezzo non tocca il ST**; D rimbalza su Fibo 50%.
- **Q4** gestione SL: A fisso 30 pip; B in base alla volatilita' media; **C sotto/sopra ST o min/max recente**; D automatico in base al tempo.
- **Q5** frazionamento 1/3+2/3: A leva; B ridurre precisione; **C gestire l'incertezza e confermare la direzione**; D entrare piu' velocemente.
- **Q6** tipo di trader: A impulsivi; **B tecnici e pazienti, con disciplina**; C solo M1; D breakout aggressivi.

#### p30 - Soluzioni `[IMMAGINE p30.png]`
**1 C, 2 C, 3 C, 4 C, 5 C, 6 B.**

| regola (ricavata dal quiz) | valore | pagina | meccanizzabile | ambiguita' |
|---|---|---|---|---|
| Valido = tocco con ombra + open successiva dentro | | p28 Q1 / p30 | si | coerente con p06/p14/p20 |
| Il frazionamento serve a "gestire l'incertezza e confermare la direzione" | | p29 Q5 | n/a | motivazione dichiarata dell'ingresso a 2 tempi |
| SL fisso 30 pip = risposta SBAGLIATA | | p29 Q4 | si (vieta SL fisso) | e anche "SL in base alla volatilita' media" e' marcata sbagliata, in tensione con p18 |
| Q3: la chiave dice C (non tocca = sconsigliato) | | p28/p30 | - | l'opzione B (seconda meta') e' presentata come alternativa: per p14 sarebbe valida come "sconsigliato", per la chiave non lo e' (§C-1) |
| Strategia non per M1 | | p29 Q6 | si | conferma TF ampi |

#### p31 - "Grazie per l'attenzione. Il metodo e' il vero vantaggio. Il resto... e' solo rumore." Nessuna regola.

#### p01-p02 - copertina e disclaimer legale. Nessuna regola. (Data "Realise 04.05.2025" in p01.)

---

## 2. TABELLA GENERALE "regola | valore | pagina | meccanizzabile | ambiguita'"

| # | regola | valore | pagina | meccanizzabile | ambiguita' |
|---|---|---|---|---|---|
| 1 | Indicatore base | Supertrend (10, 3.5) | p07, p25 | si | significato di "10", sorgente prezzo, tipo ATR non scritti `[INFERITO]` |
| 2 | Altre linee ST disegnate | 2.5, 3.0 | p04, p08 img | n/a | non usate nelle regole |
| 3 | Medie mobili | EMA 14, 89, 100, 200 | p07, p08 | si | prezzo applicato non detto; EMA 100 e 89 compaiono solo nel setup grafico/target (89), non in condizioni di ingresso |
| 4 | Pivot | "Multipivot & Opposing", "Pivot Fibo", R1-R3/S1-S3 | p07, p08, p10, p12 | no | tipo di pivot e periodi non detti |
| 5 | Opzionali | W%R o RSI, Bollinger | p07 | no | nessun parametro/soglia |
| 6 | TF | H4, D1, W1 | p05, p06, p22, p25 | si | esempi su H1 (p08, p11) |
| 7 | Tocco | high/low "tocca o viola" il ST con l'ombra | p06, p14, p20, p25 | si | "viola" quanto |
| 8 | Chiusura | corpo chiude "vicino" al ST | p14, p20, p25 | parziale | soglia assente |
| 9 | Conferma | open candela successiva "all'interno" del ST | p06, p14, p20, p25 | si | definizione di "dentro" `[INFERITO]` |
| 10 | Invalidazione | open successiva fuori dal ST | p14, p20 | si | cosa fare dopo (aspettare nuovo segnale? annullare i pendenti?) non detto |
| 11 | Confluenza | S/R, EMA200, Fibo; "sine qua non" | p06, p21, p25 | parziale | distanza e tolleranza assenti |
| 12 | Livelli S/R | "metodo di Larry Williams"/multipivot | p21, p25 | no | metodo non descritto |
| 13 | Fibonacci | 38.2 / 50 / 61.8 | p16 | parziale | swing non definito |
| 14 | Numeri tondi | es. 1.3000, 1.5000 | p16 | si | passo per ogni simbolo |
| 15 | Timing candela | prima meta' valida / ultimi 5 min no (p14) vs seconda meta' favorevole (p25) | p14, p25 | parziale | contraddizione |
| 16 | Volatilita' | "sufficiente / normale"; esempio ADR GBPCHF ~100 pip, mossa 99 pip | p11, p14, p15, p25 | no | nessuna soglia, ADR non definito |
| 17 | Gap/spike | evitare | p14, p15 | no | soglia assente |
| 18 | Macro news | "no eventi imminenti" | p25 | parziale | finestra assente |
| 19 | Barriere/ostacoli vicini | evitare | p14, p15, p16, p25 | parziale | "vicinissimi" non quantificato |
| 20 | Ingresso market | 1/3 size | p17, p26 | si | |
| 21 | Ingresso pendente | 2/3 size, +-20 pip | p17, p21, p26 | si | direzione, tipo di ordine, scadenza, pip su ogni simbolo |
| 22 | Due pendenti | 1/3 + 2/3 se apertura lontana | p10, p11, p21 | parziale | distanza fra i due: 20 testo vs ~10 immagine |
| 23 | SL | sotto/sopra min/max recente o ST; 5 pip oltre il 2 ordine (fig.4) | p17, p21 fig.4, p26 | parziale | quale dei criteri |
| 24 | TP | livelli tecnici superiori; EMA14 -> EMA89 -> altri/pivot | p17 | parziale | selezione del livello |
| 25 | R/R minimo | >= 1:1 (p17) / >= 1:2 (p26) | p17, p26 | si | contraddizione |
| 26 | Parziale | "posso ridurre la size" al primo obiettivo | p17 | parziale | frazione non detta |
| 27 | Break-even | SL a pari dopo il primo target/TP | p17, p18, p26 | si | prezzo di BE con due prezzi di entrata |
| 28 | Trailing | non descritto ("lascia correre su TF ampi") | p18, p26 | no | assente |
| 29 | Uscita su flip del ST | non descritta | - | - | assente |
| 30 | Rischio %, lotti, max posizioni | non descritti ("come da money management") | p11, p12 | - | assenti |
| 31 | Sessioni/orari | non descritti (solo timing nella candela) | - | - | assenti |
| 32 | Simboli | solo esempi: EURUSD (p04), GBPAUD/GBPCHF (p08/p11), CHFJPY (p22), simbolo non leggibile (p10/p12) | vari | n/a | nessuna lista di mercati |
| 33 | Performance dichiarate | NESSUNA | - | - | - |

---

## 3. (A) REGOLE MECCANIZZABILI IN UN EA (stato "dal PDF, senza interpretazione nostra")

Meccanizzabili con pochi o nessun dubbio (basta un parametro in input):
1. Calcolo Supertrend (10, 3.5) e lettura della linea (floor se trend rialzista, ceiling se ribassista) `[parametri TRASCRITTI p07; periodo/ATR INFERITO]`.
2. EMA 14/89/100/200.
3. Filtro TF in {H4, D1, W1}.
4. Tocco: massimo/minimo della candela chiusa supera/raggiunge il ST dal lato trend (p06, p14, p20).
5. Conferma: apertura della candela successiva al di qua della linea ST (p06, p14, p20).
6. Frazioni di size 1/3 e 2/3 (p10, p11, p17, p21, p26).
7. Distanza +-20 pip tra i due ingressi (p17, p21, p26).
8. SL dal minimo/massimo recente o dal ST (p17) e SL a 5 pip oltre il 2 ordine nell'esempio (p21 fig.4).
9. TP su EMA 14 / EMA 89 (p17).
10. BE dopo il primo target (p17, p18, p26).
11. R/R minimo come filtro numerico (valore da chiarire: 1:1 o 1:2).
12. Esclusione per "nessun tocco".

Meccanizzabili solo dopo aver fissato un parametro che il PDF non da' (vedi §F): "chiude vicino", "apre in prossimita'/lontano", "minimo recente", "numeri tondi", "ADR compatibile", "livello tecnico vicino", "TP troppo vicino a un Fibo".

## 4. (B) REGOLE DISCREZIONALI E COSA SERVE PER RENDERLE MISURABILI

| regola discrezionale | pagina | cosa serve per renderla misurabile (da chiedere, non da inventare) |
|---|---|---|
| Fibonacci 38.2/50/61.8 come confluenza | p07, p16 | quale swing (ultimo high/low? su quale TF?), tolleranza di "coincidenza" |
| Multipivot & Opposing / Pivot Fibo | p07, p08, p25 | quale indicatore, quali periodi (giornaliero/settimanale?), quale formula di pivot; il file dell'indicatore |
| S/R "metodo di Larry Williams" | p21, p25 | descrizione del metodo (algoritmo), oppure l'indicatore usato |
| Supply & demand | non citato nel PDF | - |
| "Struttura di indecisione o inversione" della candela di tocco | p12 | quali pattern ammessi (doji, pin bar, engulfing) e soglie corpo/ombra |
| Congestione/volatilita' insufficiente/piatto | p14, p15, p25 | indicatore e soglia (ATR minimo? range minimo?) |
| Gap/spike irregolari | p14, p15 | soglia (X volte l'ATR? gap > Y pip all'apertura?) |
| Eventi macro imminenti | p25 | calendario fonte, impatto minimo, finestra prima/dopo |
| "Barriere" vicino al target | p14, p15, p16, p25 | distanza minima TP-barriera, elenco barriere valide |
| "Lascia correre se il contesto lo consente" | p18, p26 | regola di uscita oggettiva (trailing? TP aperto?) |
| Scelta tra livelli di TP | p17 | criterio di selezione fra EMA14, EMA89, S/R D1/H4, pivot |
| "Distanza compatibile con la volatilita' media giornaliera" | p11 | formula ADR, tolleranza |
| "PTE" e "Weekly Open Line" | p26 | cosa sono (altre strategie ABTG) e se sono filtri obbligatori o opzionali |
| Violazioni multiple del ST (1^/2^) | p22 | se si conta il numero di tocchi e con quale regola |

## 5. (C) AMBIGUITA' E CONTRADDIZIONI INTERNE

1. **Timing della candela (CONTRADDIZIONE).** p14 riga 5: *"Il prezzo arriva sul Supertrend nella prima meta' della candela"* = valido; *"Il contatto avviene nella seconda meta' della candela in particolare ultimi 5 min, rischio di rottura"* = NON valido. p25 (checklist): *"Timing favorevole: il contatto avviene nella seconda meta' della candela"*. p28 Q3 propone "seconda meta' della candela" fra le opzioni di "quando e' sconsigliato", e la chiave p30 sceglie **C** (non tocca), non B. Tre pagine, due versioni opposte. Inoltre il concetto richiede dato intrabarra (non basta la candela chiusa).
2. **R/R minimo.** p17: *"Rischio/Rendimento minimo consigliato: >= 1:1)"* vs p26: *"TP ... + RR >= 1:2"*.
3. **Secondo ingresso.** (a) p12: *"2/3 su breakout successivo"*; (b) p17: *"2/3 rimanente su ordine pendente +-20 pips"*; (c) p21: pendente "sopra/sotto il Supertrend ... circa 20 PIPO dal primo ordine"; (d) immagine p11: OP1 e OP2 distano circa 10 pip (lettura visiva a 150 dpi, riquadri 2.08505 e 2.08604); (e) immagine p12: OP2 = al livello "Res D1". Non e' chiaro se e' un offset fisso, un livello tecnico o un breakout.
4. **TF consigliati vs esempi.** p05, p06, p25: H4-D1-W1; p22: "D1 e H4: i TF dell'eccellenza". Ma p08 e p11 usano grafici **H1** per illustrare setup e ordini pendenti (p11 intestazione "GBPCHF.bcm H1").
5. **EMA 200: confluenza o barriera?** Come confluenza: p05 ("piu' potente se combinato con EMA200"), p06, p16 punto 2 ("confluenza tecnica molto potente"), p21 fig.3 (EMA200 e' il livello "che ostacola la prosecuzione del trend"). Come barriera: p14 riga 7 elenca tra gli *"Ostacoli vicinissimi al target (Fibo, EMA200, livelli psicologici)"* il setup non valido. `[INFERITO]` si concilia con la direzione: EMA200 DIETRO il ST (lato invalidazione) = confluenza; EMA200 TRA l'ingresso e il TP = barriera. **Il PDF non lo dice esplicitamente.** Stessa doppia natura per Fibonacci e numeri tondi (p16 vs p14).
6. **Cosa significa "apre all'interno del Supertrend".** p20 fig.2: la candela successiva apre "all'interno del floor ... in prossimita' dello stesso"; nel grafico apre appena sopra la linea (long). `[INFERITO]` = dal lato del trend rispetto alla linea. Non e' chiaro cosa accade se apre all'altezza della linea o se la candela di tocco ha gia' chiuso oltre. Inoltre p12 aggiunge "e conferma la direzione", che p14/p20/p25 non richiedono.
7. **"Reversal" vs direzione del Supertrend.** I casi disegnati (p20, p21 fig.4, p22, p10) sono ingressi nel verso del Supertrend dopo un tocco della linea (ritracciamento sul floor in uptrend, rimbalzo contro il ceiling in downtrend). Il nome "reversal" e "inversione" (p05, p06, p20) indica l'inversione del movimento di ritracciamento. Non viene detto cosa fare quando il prezzo CHIUDE oltre la linea (flip del Supertrend): nessuna regola di uscita su flip, nessuna regola d'ingresso su flip (p04 cita "Segnali di ingresso (cross del prezzo)" ma non lo sviluppa).
8. **Etichetta simbolo.** p08 intestazione (400 dpi): "GBPAUD.bcm,H1 2.08432 2.08596 2.08310 2.08414"; p11: "GBPCHF.bcm H1 ... Volatilita' media GBPCHF ~100 PIP", con la stessa scala prezzi (2.0845...). Per evidenza interna al PDF le due etichette indicano lo stesso grafico e non possono essere entrambe giuste `[INCERTO quale]`. La "volatilita' media ~100 pip" e' quindi da attribuire a un simbolo incerto.
9. **Data.** p01 "Realise 04.05.2025"; il grafico di p22 mostra candele fino al "21 May 2025" e p08 il 14-18 Apr 2025. Se la data e' 4 maggio 2025 un grafico del 21 maggio non puo' esserci; se fosse 5 aprile non ci sarebbero grafici del 18 aprile. `[INCERTO]` (non cambia le regole, ma indica che il PDF e' stato assemblato in momenti diversi).
10. **SL.** p17/p26: SL sotto/sopra il minimo/massimo recente OPPURE il Supertrend; p21 fig.4: SL 5 pip oltre il 2 ordine; p18: SL "su livelli tecnici e multipivot" + "adatta SL e TP alla volatilita'"; p29 Q4: la risposta corretta e' "SL sotto/sopra ST o min/max recente" e sono segnate sbagliate sia "SL fisso a 30 pip" sia "SL in base alla volatilita' media". Quattro criteri, nessuna priorita'.
11. **"Primo obiettivo" vs "primo TP".** p17: "primo obiettivo = EMA 14"; p18: "primo target raggiunto"; p26: "dopo il primo TP". Non e' detto se il primo target chiude una quota (e quale) o se e' solo un trigger per il BE.
12. **"Size".** Si parla di "1/3 della size", "1/3 della posizione", "size gestita": non e' detto se 1/3+2/3 = 100% del rischio per trade o se ciascun ordine ha il proprio rischio.
13. **Pendenti "per evitare ingressi prematuri" (p17) vs "per evitare falsi segnali" (p21).** Funzione dichiarata ambigua; l'immagine p21 fig.4 mostra il 2 ordine SOTTO la linea ST per un long.
14. **"20 pip".** Un valore fisso in pip, sullo stesso numero per H1 e D1 e per coppie con valore del pip diverso (p22 CHFJPY: pip = 0,01; p04 EURUSD: 0,0001): non e' detto se si scala.

## 6. (D) BANDIERE ROSSE (regole di casa, CLAUDE.md)

| bandiera | evidenza (citazione + pagina) | gravita' |
|---|---|---|
| **Size crescente / media in perdita (il 2 ordine, 2/3, e' piu' grande del primo, 1/3, e viene piazzato CONTRO il movimento)** | p10/p11/p17: *"1/3 della posizione entra a mercato ... 2/3 rimanente su ordine pendente +-20 pips"*; immagine p21 fig.4: "2 Ordine (pendente)" SOTTO la linea ST per un long, con SL a 5 pip oltre; immagine p11: OP2 sopra OP1 per uno short; immagine p12: "OP 2 - size 2/3" a "Res D1" sopra l'ingresso market short | ALTA come struttura: raddoppia la size proprio dove la tesi del primo ingresso viene messa alla prova; il rischio totale dipende da un "money management" che il PDF non fornisce. NON e' martingala (nessun raddoppio dopo una perdita) ne' griglia aperta (due ordini, SL dichiarato) |
| **Rischio per trade indefinito** | p11, p12: *"S/L e T/P come da money manegement"* senza valore | ALTA per la challenge: il PDF non da' ne' risk %, ne' lotti, ne' loss massima per trade |
| **Ingresso su breakout successivo** (2/3) | p12 | MEDIA: potrebbe essere scaling-in in direzione favorevole, ma l'immagine lo piazza al livello Res D1 sopra l'ingresso short |
| **Nessuna regola di uscita su flip** del Supertrend e nessun cap su "lascia correre" | p18, p26 | MEDIA: operazioni su TF ampi senza stop/uscita oggettiva oltre lo SL iniziale |
| Martingala / recovery / griglia / no-SL | **NON presenti**: lo SL e' sempre previsto (p17, p21 fig.4, p26) | - |
| Trucchi anti-prop / mascheramento EA | **NON presenti** nel PDF | - |
| Dichiarazioni di performance | nessuna (solo "il vero vantaggio e' strutturale, non emotivo", p23: DICHIARATO, non verificato) | - |

Nota di casa: le bandiere sono segnalazioni, non decisioni; il confronto con i criteri del progetto si fa dopo, a parte.

## 7. (E) COSA IL PDF NON DICE E SERVIREBBE A UN EA (da chiedere, non da inventare)

- **Rischio**: % del conto per trade (e se vale per i due ordini insieme), lotti, max posizioni aperte, max per simbolo, cap giornaliero/perdita massima.
- **Supertrend**: significato di "10" (periodo ATR?), tipo di ATR (SMA/RMA), prezzo sorgente (HL2/close), se le linee 2.5/3.0 hanno un ruolo.
- **Ordine**: tipo di pendente (limit/stop), scadenza, cosa succede se il primo ordine e' stoppato prima che scatti il 2, dove sta lo SL se il 2 ordine non scatta, cosa succede al 2 ordine dopo il BE.
- **Soglie**: "chiude vicino", "apre in prossimita'/lontano", "minimo recente" (n barre), "troppo lontano/vicino" per i livelli, "vicinissimi" per le barriere.
- **Filtri numerici**: volatilita' minima, gap/spike, news.
- **Uscite**: frazione da chiudere al primo obiettivo, trailing, uscita su flip, uscita temporale, regola di scelta del TP quando i livelli sono vari.
- **Simboli e sessioni**: quali coppie/indici, orari (nessuno citato), pip per ogni simbolo, spread massimo accettabile.
- **Come si comporta con barra in formazione**: i segnali si valutano a barra chiusa (apertura della successiva) o intrabarra (timing dentro la candela)?
- **Dati degli indicatori**: Multipivot & Opposing, Pivot Fibo, PeakRepairerStrict, metodo Larry Williams, PTE, Weekly Open Line: i file/descrizioni degli indicatori.
- **Evidenza di prestazione**: nessuna (nessun backtest, nessun forward, nessuna statistica nel PDF).

## 8. A SCHERMO E NON NEL PARLATO / NELLE IMMAGINI ILLEGGIBILI

(Il PDF non e' un audio; qui l'equivalente e' "cosa si vede nelle immagini e il testo non dice".)
- p10/p12: simbolo e TF dei due grafici con prezzi ~0.589-0.595 non leggibili `[INCERTO]`.
- p22: "Spread: 9" in basso a destra a 400 dpi non leggibile con certezza; il pannello ordine mostra 0.20 lotti (default del pannello MT5, non una regola).
- p22: "PeakRepairerStrict" (sotto-finestra) e ATR(14) = 0.4351 mostrati senza spiegazione.
- p08/p10/p11: colori/stile delle linee non sono associati a un'etichetta oltre ai callout; la separazione EMA 89/100 nelle immagini e' un'ipotesi visiva.
- p11: distanza OP1-OP2 letta dall'asse prezzi (2.08505 / 2.08604) a 150 dpi; da confermare con l'originale.

## 9. COSA NE COPIAMO

Niente "copia": il PDF non da' numeri di performance ne' parametri di rischio. Utile come **lista di regole da misurare** (dopo il confronto con l'EA esistente, a parte).

---

## F. DOMANDE DA FARE A CLAUDIO / ALLA COLLEGA

**Su Supertrend e candele**
1. "Supertrend (10, 3.5)": 10 e' il periodo ATR? Il prezzo sorgente e' HL2? E' l'indicatore di Oliver Seban con le tre linee 2.5/3.0/3.5 (p04, p08)? Le linee 2.5 e 3.0 servono a qualcosa?
2. "Chiude vicino al Supertrend" (p14, p20, p25): che distanza massima (pip, ATR, % del range)?
3. "Apre all'interno del Supertrend" (p06, p20): significa "dal lato del trend rispetto alla linea" (cioe' sopra il floor per un long)? E se il corpo del tocco ha gia' chiuso oltre la linea, il setup e' scartato o vale?
4. Il "timing" (p14: prima meta' valida, seconda meta' no; p25: seconda meta' favorevole): quale delle due vale? E il criterio si applica anche a H4/D1/W1 (ultimi 5 minuti su una candela W1)?
5. "Struttura di indecisione o inversione" (p12): quali candele (doji, pin bar, engulfing)?
6. p22 ("1^ violazione", "2^ violazione", "rimbalzo deciso"): serve contare i tocchi? Quale candela e' il segnale?

**Su confluenze e livelli**
7. Quali confluenze sono OBBLIGATORIE (p21 "sine qua non") e a che distanza massima dal rimbalzo? Basta una (EMA200 oppure Fibo oppure S/R)?
8. Fibonacci: su quale swing (ultimo massimo-minimo di quale TF) e con che tolleranza?
9. Multipivot & Opposing / Pivot Fibo / PeakRepairerStrict / metodo Larry Williams: che indicatori sono, con quali parametri? Ci potete dare i file?
10. "PTE" e "Weekly Open Line" (p26): sono filtri obbligatori o solo bonus? Dove sono descritti?
11. EMA200 come confluenza (p16) e come barriera (p14): e' corretto che e' confluenza se sta dietro il Supertrend e barriera se sta tra ingresso e TP?
12. "Numeri tondi" (p16): ogni 100 pip? ogni 50? e sugli indici/oro?

**Su ingressi e size**
13. "1/3 + 2/3": e' 100% del rischio per trade diviso in due ordini, o due ordini con rischio proprio? Con quale rischio % per trade?
14. Il 2/3 va CONTRO il movimento (come nelle immagini p11, p21 fig.4) o a favore ("breakout successivo", p12)? A quanti pip: 20 (testo) o ~10 (immagine p11)? Gli "stessi 20 pip" su H1 e su D1, e su CHFJPY e EURUSD?
15. Se la candela successiva apre "lontano", il primo dei due pendenti dove sta?
16. Tipo di pendente (limit/stop), durata del pendente, e cosa succede se il primo ordine viene stoppato prima del secondo.
17. Quando si usa il market e quando solo i pendenti (p21)? "Il prezzo si muove nella direzione prevista": di quanto, in quanto tempo?
18. "Volatilita' media giornaliera ~100 pip" (p11): e' ADR a quanti giorni? La "distanza compatibile" ha una tolleranza? Il simbolo del grafico e' GBPCHF (p11) o GBPAUD (p08)?

**Su uscite**
19. R/R minimo: >= 1:1 (p17) o >= 1:2 (p26)?
20. Dov'e' lo SL: quale fra "minimo recente" (quante barre?), "Supertrend", "5 pip oltre il 2 ordine" (p21 fig.4), "livello tecnico/multipivot"? Che priorita'? E dopo che il 2 ordine e' scattato, lo SL e' unico per entrambi?
21. Al "primo obiettivo" (EMA 14?) quanta size si chiude? E il BE e' al prezzo medio dei due ingressi?
22. "Lascia correre" (p18, p26): c'e' un trailing (sul Supertrend? sulla EMA 14?) o TP fisso? Che succede se il Supertrend si capovolge (flip)?

**Su filtri, simboli e contesto**
23. Soglie per "volatilita' sufficiente", "gap/spike irregolari", "congestione" e per "eventi macro" (che finestra? quali eventi?).
24. Su quali simboli e TF si opera davvero (nel PDF solo esempi: EURUSD H4, GBPAUD/GBPCHF H1, CHFJPY H4)? Anche indici/petrolio?
25. Ci sono orari/sessioni da evitare? Giorni (venerdi, rollover)? Spread massimo?
26. Il segnale si valuta SEMPRE a barra chiusa, o in tempo reale (per il timing "seconda meta' della candela")?
27. Esiste una versione piu' recente del PDF o una documentazione di prestazioni (backtest/forward) di questa strategia? Il PDF non ne contiene.

---

*Controlli fatti prima della consegna:* ogni regola riporta pagina e (per le immagini) il file pNN.png; i numeri nelle immagini (2.08505/2.08604, 52 pip, 99 pip, ATR 0.4351, intestazioni dei simboli) sono stati riletti ad almeno 150 dpi o 400 dpi (intestazioni); tutto cio' che e' lettura visiva approssimata e' marcato `[IMMAGINE]`/`[INCERTO]`. Nessun numero di performance e' presente nel PDF. Nessuna fonte esterna e' stata usata.
