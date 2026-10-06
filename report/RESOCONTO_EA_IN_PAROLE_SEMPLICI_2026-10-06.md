# I NOSTRI EA IN PAROLE SEMPLICI - 06/10/2026

> **Cancelli del 06/10**: strato 1 (`controlla_riga.py --oggetto md`) senza difetti; strato 2 (`controllo-preventivo`) PASS CON RISERVE, correzioni applicate nel file (fonti ricontrollate con script; stato delle sedie riletto da `SOSPENSIONE_SEDIE_DEMO_2026-09-25.md` e `HANDOFF.md`). Nessuna riga di lancio dentro: niente di questo file va al VPS.
> **Cos'e'**: la versione leggibile dei due resoconti del 05/10 (`RESOCONTO_EA_CONSOLIDATO_2026-10-05.md` e il suo `..._AGGIORNAMENTO_CSV_2026-10-05.md`), scritta per rispondere alla tua richiesta: *"un resoconto di tutti gli EA creati con PF sopra 1 e quelli sotto 1, che backtest, che anni, che tipologie di mercati hanno superato, se migliorabili e cosa serve"*.
> **Regola ferrea**: nessun numero nuovo. Ogni cifra e' copiata dai due documenti o dalle tre letture dei CSV trasportati (`LETTURA_CSV_TRASPORTATI_A/B/C_...`). Le fonti stanno nelle note sotto le tabelle. I conteggi sono **proposte che valgono dopo le tue firme**, non etichette definitive.

---

## 1. IL QUADRO IN 10 RIGHE

**Le parole da sapere subito.** **PF** (profit factor) = euro guadagnati per ogni euro perso: sopra 1 l'EA guadagna, sotto 1 perde. **SOPRA / SOTTO** = il PF dell'esame di **una singola prova** sopra o sotto 1. **Primo periodo / esame** (in gergo *IS / OOS*): sul primo periodo si scelgono i parametri, l'esame e' il periodo dopo, mai visto. **Attenzione**: non ogni "esame" e' una prova indipendente. Per Larry e EasyTrend sullo storico lungo l'esame coincide con la finestra di un round gia' fatto (R103): e' una **replica**, non una conferma nuova; per `AtrExhaustVol`, `NySessionRetest`, `DaxReEntry` l'"esame" non c'era proprio (sez. 6, punto 8). **DD** (drawdown) = la discesa massima del conto durante il test. **Affidabilita'** A-D: A = almeno 150 posizioni nell'esame + esame vero + almeno due regimi di mercato; B = come A ma un solo regime; C = 30-149 operazioni (merito sospeso); D = meno di 30.

1. 💪 Abbiamo messo in fila **116 righe di EA** (una riga puo' raggruppare 2-4 file gemelli) in sette gruppi, piu' una lettura di **254 file di risultati** che hai trasportato il 05/10.
2. 📈 **59 righe hanno almeno una prova sopra 1** e **65 almeno una sotto 1**; **solo 6** sono sopra e basta. **53 stanno in tutte e due le liste**: quasi ogni EA ha varianti che vincono e varianti che perdono.
3. 🧮 Dopo i file trasportati, la **proposta** sposta tre cacce: **60 sopra / 68 sotto / 37 mai misurati** (prima 40). **Valgono solo dopo le tue firme sulle etichette** (sez. 5, punti 7-9) e non vanno letti come "60 EA buoni su 116". E il +1 sopra (da 59 a 60) e' **una sola prova di `VolExpBreak`**, PF 1,042: se la regola sui PF appena sopra 1 (punto 7) la lascia fuori, i sopra restano **59**.
4. ⚠️ "Sopra 1" **non vuol dire buono**: quasi sempre e' una prova con poche operazioni, o che va bene in un periodo e male nell'altro (*segno invertito*: nei test di sedie e candidate letti il 05/10 succede in **91 prove su 297**), o forse indistinguibile da 1 (la soglia non e' firmata), o col conto che scende troppo.
5. 🎯 Le prove che i documenti chiamano "B pulita" (a tick veri, esame vero, almeno 150 posizioni nell'esame, stesso verso nei due periodi) sono **tre**: l'EMA200 sul Dow `771531`, il DAX apertura long `770101` (il suo primo periodo pero' ha 132 posizioni, sotto 150), e un candidato Dow breakout (ancora "NON ANCORA MISURATO come sedia"). Tutte e tre su **un solo regime**.
6. 🕰️ **Tutto cio' che abbiamo a tick veri BCM e' un solo mercato: il rialzo.** Nessuna prova ha due regimi misurati, quindi il massimo livello di affidabilita' ("A") e' **a zero** su tutti e sette i gruppi.
7. 🪦 **Nessun EA e' dichiarato MORTO.** Per dirlo servono le cinque caselle del certificato (PF, n e DD, uscita messa ad asse, simboli gemelli, TF cambiato): dove ne manca una, il verdetto e' "NON ANCORA MISURATO". Una sola *prova* ha il certificato pieno: l'EMA200 sull'oro H4, per rischio.
8. 🛠️ Le misure che servono vanno da **0 minuti** (trasportare file) a **pochi minuti fino a circa un'ora** sul PC di backtest, fino a **90-348 ore** per la prova di regime sul Dow (stime da moltiplicare per 2-3, sez. 4).
9. 🗂️ Hai 18 decisioni in sospeso (sez. 5): nessuna e' nostra, e nessuna abbassa una soglia.
10. 🧭 Sintesi da socio: l'archivio e' piu' ricco di quanto sembrasse, ma le sedie schierabili sono ancora **pochissime** e quasi tutte su **un solo regime e con meno di 150 operazioni**: la distanza fra "PF sopra 1" e "sedia schierabile" sta tutta li'.

---

## 2. QUALI EA STANNO SOPRA 1 E QUALI SOTTO

**Come leggere le colonne.** *PF* = primo periodo → esame. *n* = quante operazioni: sotto 150 il giudizio sul merito resta sospeso. **Posizione** = un'operazione intera; **deal** = ogni singola esecuzione (con chiusura parziale una posizione fa piu' deal: il rapporto va da 1,00 a 2,31), quindi n in deal sembra piu' grande. **Tick** = dati reali tick per tick; **barre** = prova piu' grossolana (screening: serve a vedere se ne vale la pena, **non promuove e non boccia**, e il DD a barre e' un **minimo**: quello vero puo' essere piu' alto). **"~21 mesi"** = dal 26/09/2024 al 30/06/2026 (indici), il periodo che i nostri dati a tick coprono.

### 2.1 Sopra 1 (con le cautele scritte accanto)

| EA e suo ruolo | PF primo → esame | n e DD | Anni e mercato | Cosa dicono i documenti | Nota |
|---|---|---|---|---|---|
| **DAX apertura**, sedia `770101` (lato long) | 1,126 → 1,397 | 132 / 193 posizioni; DD 5,44 / 7,23% (1% a operazione, conto 100k) | tick, ~21 mesi, DAX, grafico M5 | SOPRA, affidabilita' B (primo periodo sotto 150: merito sospeso su quello). Su un altro indice (F40EUR): 1,440 → 0,770, segno invertito | 1 |
| **Dow apertura**, sedia `770202` (long) | 1,222 → 1,270 | 56 / 96 posizioni; DD 5,67 / 4,39% | tick, ~21 mesi, Dow, M5 | SOPRA, affidabilita' C (sotto 150). Provati 10 modi di uscire: quasi nessuno batte quello attuale in tutti e due i periodi | 2 |
| **Nasdaq apertura**, sedia `770260` | 1,221 → 1,215 | 82 / 102 posizioni; DD 7,31 / 7,86% (conto 80k, rischio 2%) | tick, ~21 mesi, Nasdaq, M5 | SOPRA, affidabilita' C | 3 |
| **EMA200**, sedia `771531` (Dow H1) | 1,201 → 1,524 | 257 posizioni nell'esame; DD 7,83% | tick, ~21 mesi, Dow, H1 | SOPRA, affidabilita' B: una delle tre prove pulite. Il primo periodo (132 posizioni) non e' ricontabile. Gli stessi EMA200 su DAX e Nasdaq sono SOTTO (0,783 e 0,693) | 4 |
| **SuperWave Dow** `770531` (H2, candidata; tolta dal demo il 25/09) e `770511` (H1) | 770531: 5,571 (su soli 32) → 1,762; 770511: contratto in tre versioni | 770531: 50 posizioni nell'esame; 770511: 131 deal nell'esame (versione 10k) o 184 (versione 100k) | tick, ~21 mesi, Dow | SOPRA, affidabilita' C. Per `770511` due versioni del contratto (1,482 → 1,243 e 1,397 → 1,220) si ritrovano nei test, **la terza (1,849 → 1,328) non la ritrova nessuno** | 5 |
| **ORB Ottimizzato**, sedia `770611` (Dow M5, solo long) | 1,250 → 1,674 | 71 / 119 posizioni; DD nell'esame 9,76% (il muro e' 10%) | tick, ~21 mesi | SOPRA, affidabilita' C. Sullo stesso EA: Nasdaq 7 prove su 7 passano da sopra a sotto (0,767-0,864) | 6 |
| **SupRev Nasdaq H1**, sedia `970913` | 1,342 → 1,688 | 69 / 86 deal; DD 0,86-1,29% | tick, ~21 mesi | SOPRA, e' la cella del gruppo piu' vicina a una sedia. Nel round R163a sette varianti su sette sopra 1 in entrambi i periodi (altre varianti, M30, H3 e due StMult, stanno sotto); **ma ESCLUSO PER COSTO (28,7x lo spread)** | 7 |
| **MaxMinNotte oro**, sedia `770402` (H2, solo long) | 1,453 su tutta la finestra, senza esame separato | 93 posizioni (118 deal); DD 2,34% a rischio 0,5% | tick da luglio 2024 (2 anni); a barre dal 2020 | SOPRA, affidabilita' C. Su barre: primo periodo 1,108 → esame 1,438 (693 deal), ma e' solo screening | 8 |
| **Forex "di agosto"**: BreakingBand GBPUSD `772161`, CostToCost EURJPY `772361`, EasyTrend GBPUSD `772422` | BB 2,736 → 1,748; CtC 1,026 → 1,740; ET 1,258 → 1,492 | BB 26, CtC 64, ET 41 posizioni nell'esame; DD 3,40 / 9,33 / 4,58% | tick forex da 07/2024, 10k-100k, H1 (CtC H4) | SOPRA ma n molto sotto 150 (affidabilita' C o D). CtC: la stessa cella a 100k nei file trasportati fa 1,016 → 1,741 (DD 9,45%), e il suo primo periodo 1,016 e' "sopra" solo formalmente. BB su 1999-2026 a barre: 0,714 → 1,123, segno invertito | 9 |
| **SupRev oro H4** (Ottimizzato `970901`) | 4,752 → 2,253 | 22 / 30 deal; DD 0,79 / 2,08% | tick ~21 mesi; barre 22 anni | e' un **picco** (le celle vicine stanno sotto 1). Su 22 anni a barre: primo periodo 2004-2013 sotto 1 su 7 prove su 7, esame 2013-2026 sopra su 7 su 7 (segno invertito) | 10 |
| **GoldenCross** USDCHF H4 e oro H1 | 3,628 → 2,188 (su 20 / 17 deal); oro 1,494 → 1,253 | USDCHF DD 2,34%; oro 32 / 57 deal | tick dal 07/2024 | SOPRA ma n molto bassi; l'oro su 22 anni ha DD 25,18% a rischio 1%: NO PER RISCHIO | 11 |

### 2.2 Sotto 1 (o sopra solo sulla carta)

| EA e suo ruolo | PF primo → esame | n e DD | Anni e mercato | Cosa dicono i documenti | Nota |
|---|---|---|---|---|---|
| **Nasdaq short** `770250` (ferma dal 25/09) | 1,257 → 0,948 | 57 / 47 deal; DD 4,54 / 3,63% | tick, ~21 mesi, M15 | SOTTO. Il "1,097 su 104" di prima era l'intera finestra: i due periodi vanno in versi opposti | 12 |
| **Larry sull'oro** `772343` | **PF 0,872; sotto 1 in 14 prove su 14** | 213 operazioni; DD 29,74% a rischio 1% (a barre: e' un minimo) | barre, 22 anni | SOTTO. Sui 21 mesi risultava "sopra", ma con affidabilita' D (molto bassa) | 13 |
| **EMA200 oro H4** `971501` | 0,658 → 1,495 | 39 / 67 deal | 21 mesi a tick; 22 anni a barre | NO PER RISCHIO: DD su 22 anni 45,91% contro il 4,40% promesso | 14 |
| **Live5m** DAX / Nasdaq (osservazione) | DAX 0,935 → 0,857; Nasdaq 1,015 → 0,956 | DAX 225 / 342 deal, DD 26,07 / 39,74% | tick (in parte non reali), M5, 2024-2026 | SOTTO, "non ancora morto" (DAX: 2 caselle su 5) | 15 |
| **Londra**: LondonFx, Londra_ORB, AllineaLondra | LondonFx EURUSD 0,843-0,923; Londra_ORB 1,088 → 1,034 (sopra solo sulla carta) | LondonFx 1.132-2.253 deal, DD 31-61%; Londra_ORB 156 / 253 deal, DD 14,17 / 23,32% | tick, 2024-2026, M5/M15 | LondonFx SOTTO e chiuso due volte; Londra_ORB NO PER RISCHIO e ESCLUSA PER COSTO; AllineaLondra sopra solo in una prova a barre (~1,01) | 16 |
| **Cacce a breakout nuove**: DaxValueArea, Cycle, VolExpBreak | DaxValueArea 8 prove su 8 sotto 1 (0,755-0,974); Cycle 12 su 12 (0,761-0,981); VolExpBreak 7 su 8 sotto, **una sola sopra: 1,123 → 1,042** (Dow) | 211-407 e 630-2072 operazioni; DD fino a 38,8% e 55,1%. VolExpBreak: 111 operazioni, DD 12,22% = NO PER RISCHIO | tick, ~21 mesi, M15/M30 | DaxValueArea e Cycle SOTTO, ma **non morti** (2 caselle su 5). VolExpBreak "sopra e sotto": il suo +1 nei conteggi dipende dalla tua firma sui PF appena sopra 1 (sez. 5, punto 7) | 17 |
| **Altri**: BreakoutCorso (7 cross yen), AltaVelocita, MeanRevert, TurnaroundTuesday | tutte sotto 1 nell'esame (BreakoutCorso 0,769-0,980; AltaVelocita 0 prove su 45 sopra) | n da centinaia a migliaia; DD fino a 50,5% | barre (AltaVelocita GBPUSD anche a tick): MeanRevert 11,5 anni, TurnaroundTuesday 16, BreakoutCorso dal 2007 | SOTTO; per MeanRevert e TurnaroundTuesday il "morto" va riletto (sez. 5, punto 11) | 18 |
| **Mai misurati** (copie, esterni, prove mai girate) | - | - | - | **37 righe** nella proposta (40 nel consolidato). Non sono ne' sopra ne' sotto: sono buchi | 19 |

**Note (fonti: documento + riga o sezione).** Consolidato (`cons.`) = `RESOCONTO_EA_CONSOLIDATO_2026-10-05.md`; Addendum (`add.`) = `..._AGGIORNAMENTO_CSV_...`; A / B / C = le tre letture. [1] cons. sez. 1 riga 1, gruppo G1 1a-1i; add. 1.2, B 4.1. [2] cons. riga 10; add. 1.2, B 4.2. [3] cons. riga 14 (G1 14a). [4] cons. riga 27; add. 1.2, B 4.5. [5] cons. righe 31-32; add. 1.2, B 4.6-4.7. [6] cons. riga 36; add. 1.2, B 4.8. [7] cons. riga 72; add. 1.2, B 4.12. [8] cons. riga 41; add. 1.2, B 4.9. [9] cons. righe 55-57; add. 1.1, A 4.1. [10] cons. riga 68 (G5 U01-U06) e sez. 2.2. [11] cons. righe 78-79. [12] add. 0 punto 4 e 1.2, B 4.3. [13] add. 0 punto 6, A 4.6. [14] cons. riga 28. [15] cons. righe 21-23. [16] cons. righe 38, 53, 54. [17] add. 1.3, C 4.3-4.4. [18] cons. righe 65, 104-105, 112. [19] add. 2.2. Le etichette di ruolo (sedia, candidata, spenta) sono quelle scritte nei documenti: **"sedia" qui vuol dire il ruolo, non che sia accesa**. Stato vero, dalle fonti di campo: sul demo piccolo `50503392` **tutte le sedie su indici sono tolte dal 25/09** (firma tua, `SOSPENSIONE_SEDIE_DEMO_2026-09-25.md`; elenco delle 16 in `HANDOFF.md` blocco 29/09), fra cui `770101`, `770202`, `771531`, `770531`, `770511`, `770611`, `970913`, `770250`. Sulla trial FTMO, secondo l'ultimo stato scritto (01/10, non ricontrollato oggi), girano `770101`, `770202`, `770260`, `771531`, `770511` (piu' `770105` e `770411`) (`HANDOFF.md` blocco 01/10).

---

## 3. CHE MERCATI HANNO ATTRAVERSATO

**Il fatto piu' importante del resoconto: sui tick veri BCM c'e' un solo mercato, il rialzo.** Gli indici partono dal 26/09/2024, il forex dal 05/07/2024, l'oro dal 10/07/2024 (dentro c'e' la discesa di febbraio-aprile 2025, ma e' dentro un rialzo). **Mercato in discesa, laterale, crollo: NON MISURATI su nessuna sedia sugli indici.**

Cosa significa per la fiducia, senza ammorbidire:
- 🔴 Un PF di 1,5 su 21 mesi di rialzo dice che l'EA funziona **in un mercato che sale**. Non dice nulla su cosa fara' se il mercato gira. Per questo l'affidabilita' massima e' a zero.
- 🔴 Dove un numero per regime esiste (feed esterno `_EXT` o barre con poche operazioni), **nessuna prova le passa tutte**. Esempi: nel crollo puro di febbraio-aprile 2020 CostToCost EURJPY fa **0,025** (23 operazioni, DD 14,83%), EasyTrend GBPUSD **0,391**, BreakingBand GBPUSD **0,595**; nel laterale 2015-16 SupRev Nasdaq fa **0,664** (55 operazioni).
- 🟢 Ci sono anche numeri buoni fuori dal rialzo: CostToCost EURJPY nell'orso 2022 fa 2,654 (43 operazioni), BreakingBand GBPUSD nell'orso 1,436 (9 operazioni): campioni piccoli, da non festeggiare.
- 🔴 E il feed esterno **cambia anche il segno**: in 4 cambi su 4 provati (R80) lo stesso EA gira al contrario. Il regime sul Nasdaq potrebbe essere un artefatto del feed.
- Il buco si chiude con dati lunghi: DAX 2010-2018 e' scaricato ma mai importato; per il Dow oltre la validazione ci sono zero byte (piano 90-348 ore, in attesa della tua firma F1). Anche firmando tutto, il foglio delle firme stima che nel dossier per Emiliano la colonna "anni / dati" non arriva mai a un "SI" pieno.

*Fonti: cons. sez. 0 punto 7, sez. 2.2-2.3; add. 0 punto 10.*

---

## 4. COSA E' MIGLIORABILE E COSA SERVE (dal meno al piu' caro)

> **Avvertenza onesta**: le stime di tempo sono dei gruppi e sono risultate **circa 2,5 volte sottostimate** (cinque round stimati 5,16 minuti ne hanno richiesti 13,2); la velocita' del PC di backtest non e' misurata. Moltiplica per 2-3. Le prove girano **sul PC di backtest, mai sul VPS** finche' una challenge e' viva, e ogni lancio ha bisogno del tuo via libera.

1. **0 minuti di macchina: portare e leggere file gia' girati.** Il test `r161c` (BreakingBand AUDUSD) esiste solo nell'archivio del Desktop VPS. **5 round di cacce** (VwapRevert, CrossEmaApertura, InvEsaurimento, ChaosLyapunov, Relativo) hanno solo il referto, non i file: restano illeggibili. Poi i file con le singole operazioni (18 file per 9 EA, piu' quello dell'EMA200 `771531`): servono per sapere date, lato e posizioni vere. *(La scadenza dei 30 giorni non pesa piu' per i file gia' trasportati.)*
2. **Da circa 1 a 6 minuti**: riconciliare il contratto `770511` (~1 min + 2 di avvio); l'IS in posizioni dell'EMA200 `771531` (~45 s); la prova "feed o epoca?" sul Nasdaq (~2 min); la diagnosi di `SupertrendInvert`, che non apre operazioni (~3-6 min); il primo PF delle tre sedie sulle notizie (PostNews, ~6 min).
3. **Da circa 4 a 35 minuti**: gemelli e uscite su `AtrExhaustVol` (~4 min piu' ~17), `Nightly` (~5-11 min), `CrossEma` oro (~25-35 min), e il Dow breakout candidato (~5,3 min). Per `SuperWave` `770511` i 7 file pronti erano stimati 34,1 min, ma **5 su 7 sono gia' girati** (i loro risultati sono fra i file trasportati): manca solo il TF M30 (`R190b`), costo da solo non scritto.
4. **Da 15 a 60 minuti e piu'**: `Relativo` (15-45), `Bulge` (15-60 min), `PTE` (decine di minuti, non misurato).
5. **90-348 ore di PC acceso**: la prova di regime sul Dow. E' **l'unica misura che compra regime per le sedie vive** (porta da B ad A) e richiede una tua firma di spesa.

**Cosa NON e' migliorabile, detto chiaro** (giudizio "migliorabile: no" dei gruppi, per rischio o costo; **non e' un certificato di morte**): EMA200 oro (rischio 45,91% contro 4,40%), Gold_Ichimoku (DD 21,52% a rischio 0,5%), SupRev Dow H1 (non senza una tesi nuova), ORB sul Nasdaq (SOPRA solo sulla carta, DD 24,84 / 19,41%, costo 26,5x).

*Fonti: cons. sez. 3(a)-3(c); add. 6.2 e sez. 3.2, 5.*

---

## 5. LE DECISIONI CHE SONO TUE

Nessuna e' una nostra proposta; nessuna abbassa una soglia di rischio o di promozione. Le firme di rischio, taglie e conto reale restano sempre e solo tue.

1. **Riaccendere la sedia Nasdaq short `770250`?** (ferma dal 25/09) Nel periodo d'esame perdeva: PF 0,948 su 47 deal. *(S-1)*
2. **Toccare la sedia Dow `770511`?** Le sue uscite alternative fanno meglio nei test, ma la regola di casa sceglie il centro dell'altopiano, mai il picco. *(S-2)*
3. **Cambiare uscita alla sedia Dow `770202`?** Nessuna alternativa batte quella attuale in entrambi i periodi, salvo due varianti di poco. Nessun cambio proposto. *(S-3)*
4. **Togliere il breakeven all'EMA200 `771531`?** Fa +49% di deal ma guadagna il 31% in meno e il DD sale (8,90 contro 7,83). Servono le singole operazioni per capire se sono operazioni vere. *(S-4)*
5. **DAX `770101`: stop minimo piu' largo (6800) e "niente chiusura parziale + breakeven"?** Il primo non peggiora i numeri; il secondo migliora di poco, dentro il rumore (firma gia' pendente). Nella stessa firma D-8 c'e' anche il TF d'ingresso di Live5m. *(S-5, D-8)*
6. **Larry sull'oro: taglia o spegnimento?** 22 anni, PF 0,872, DD 29,74% a rischio 1%. E chi ha i report originali di `EasyTrend_EURUSD` e del paniere yen? *(S-6, D-11)*
7. **Quando un PF appena sopra 1 conta come "sopra"?** Oggi non c'e' soglia: 1,042 (`VolExpBreak`), 1,038 (`HVAncora`) e 1,051 (`LVNArbitro`) sono "sopra" ma forse indistinguibili da 1. Da questa firma dipende anche il +1 sopra della proposta (60 o 59). *(S-7, D-1)*
8. **Come trattare un EA che va bene in un periodo e male nell'altro?** Oggi e' "sopra con etichetta"; potrebbe diventare "non confrontabile". Sposta i conteggi. *(S-7, D-2)*
9. **Le prove a barre e sui feed esterni contano come sopra/sotto o sono "non misurate"?** Cambia i totali (59 contro 57 sopra). *(S-7, D-3)*
10. **Provare stop diversi conta come "uscita messa ad asse" nel certificato?** E come leggere un numero di `Cycle` a 0,0023 dalla soglia. Non tocca nessuna sedia. *(S-8)*
11. **MeanRevert e TurnaroundTuesday: eccezione "non si spende" o circa 15 + 2 minuti per misurarli?** I documenti li chiamano "morto vero", ma per la regola del 09/09 sono "non ancora misurati". *(D-4)*
12. **IBRetest: si puo' sommare il campione di tre simboli?** Sommati fanno 209 operazioni, ma ognuno da solo sta sotto 150. *(D-5)*
13. **HARSI: hai ancora gli 8 file Excel di TradingView/OANDA?** Sono l'unico numero che esiste per quell'EA. *(D-6)*
14. **Via libera a lanciare le prove sul PC di backtest e a copiare dal VPS** i file delle singole operazioni e `r161c`? Il runner sul VPS lavora solo in lettura: serve la tua firma. *(S-9, D-7)*
15. **GoldenCross: ricompilare la v2.00 al posto della v1.00 in campo?** E le taglie dell'oro (DD su 22 anni 9,02 / 16,90 / 25,18% a rischio 1%). *(D-10)*
16. **`770411` DAX short: quale finestra fa il contratto?** DD 1,92% oppure 3,1%, misurano finestre diverse. E la taglia dell'oro MaxMin (DD 22 anni 10,30% a 0,5%, contro il 10,0% di contratto). *(D-9)*
17. **Il resto delle cacce (HVAncora, CRT, PointBreak e SuperFilter, ScalperDirezionale):** misurare la fedelta' alla fonte, spendere per i tick, autorizzare un `OnTester` (modifica a un EA = tua firma). *(D-12)*
18. **Le 12 firme del foglio `FIRME_DA_FARE`**, prima di tutte la regola unica sui regimi (R-0). Nel foglio ci sono anche le due date: ora d'inverno del DAX entro il 25/10 e USA entro il 02/11. *(foglio firme)*

*Fonti: add. 6.1 (S-1...S-9); cons. 3(d) (D-1...D-12).*

---

## 6. COSA TI ABBIAMO TROVATO DI SBAGLIATO NEI NOSTRI DOCUMENTI

I documenti non sono stati corretti: le smentite sono solo elencate, ognuna con la sua correzione nel documento di origine. In ordine di peso:

1. **`770250`**: "PF 1,097 su 104" era la finestra intera; separata, va da 1,257 a 0,948. E' una sedia ferma dal 25/09.
2. **Larry sull'oro**: "sopra su 21 mesi" diventa **sotto su 22 anni in 14 prove su 14** (PF 0,872, DD 29,74%).
3. **`770511`**: il contratto 1,849 → 1,328 **non lo riproduce nessuno dei 13 round**.
4. **Round "mai girati" che erano girati**: 35 round forex (14-20/09), 6 cacce, e i test di `770202`, `ORB`, `SupRev Nasdaq`. Ora 34 su 35 forex e 6 su 6 cacce sono leggibili.
5. **Un "morto" mai misurato**: `PointBreak` era dato per "bocciato 12/12", ma quel 12/12 era di `MeanRevert`; non e' mai stato misurato.
6. **`CanaleLento` "n=20"**: 20 erano le **prove**, non le operazioni (n vero 29-164).
7. **I "2,74 / 3,17" dei SupRev nativi sull'oro**: nessun file li riproduce; la cella nativa fa 0,337 → 0,765.
8. **Tre EA con "OOS" che non erano esame** (`AtrExhaustVol`, `NySessionRetest`, `DaxReEntry`): finestra unica, cella scelta sullo stesso campione.
9. **`DaxValueArea` "morto su due gambe"**: era un'analogia, senza numeri suoi. Ora ne ha (8 su 8 sotto 1) ma non e' morto: 2 caselle su 5.
10. **Le stime di tempo**: 5,16 minuti stimati contro 13,2 misurati (circa 2,5 volte sotto).

*Fonti: cons. sez. 4 (righe 1-46); add. sez. 3 (righe 1-36).*

---

**Da socio**: la direzione e' quella giusta: abbiamo smesso di fidarci delle frasi ("morto", "mai girato", "OOS") e controllato i file, e cosi' abbiamo trovato celle sopra 1 nascoste e prove date per sparite. La strada verso sedie davvero schierabili e' ancora lunga: i numeri veri dicono **poche sedie, un solo regime, campioni sotto 150**. Se non lo dicessimo, ti costerebbe piu' di una brutta notizia.
