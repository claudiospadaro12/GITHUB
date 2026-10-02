# FORZA FX — specifica della dashboard (versione NOSTRA), 02/10/2026

**Fonte letta per intero:** la guida della dashboard del corso (40 pagine, PDF + pptx con
le stesse slide, materiale di terzi NON copiato nel repo). Qui le regole sono **riassunte
con parole nostre** e numerate; ogni regola porta la pagina da cui viene.
**Implementazione:** `mql5/Indicators/ABTG_ForzaFX_Dashboard.mq5` (nome nostro, nessun marchio).
**Collaudo:** `backtest_pipeline/collaudo_forza_fx.py`.

**Perimetro (dichiarato prima di tutto):**
- e' una dashboard di **SOLA VISIONE**: nessun ordine, nessuna rete, nessun file, nessun
  accesso al conto. Lo dice anche la guida (p.3, p.35: "non e' un robot").
- **NON** implementiamo le 4 strategie operative (p.22-25), il protocollo in 6 passi
  (p.26-29), la checklist (p.37), ne' consigli su stop, target, R:R o size: sono regole di
  trading discrezionale **non misurate** (nessun numero di operazioni, nessun backtest
  nella guida).
- **NIENTE misure di performance in questo giro.** La forza valutaria nei nostri verbali e'
  sempre stata letta **a colori e mai misurata** (`report/ANALISI_LIVE_EMILIANO_2026-09-09.md`
  G4; precedente Y8 in `backtest_pipeline/caccia_strategie/ANALISI_LIVE_PAOLO_2026-09-03.md`:
  "CHF -0,26, JPY +0,25... tutti e due negativi", numeri incoerenti). Prima si costruisce uno
  strumento i cui numeri si possono **ricalcolare a mano**, poi (eventualmente) si misura.

Legenda: **[GUIDA]** = regola esplicita della guida · **[SCELTA]** = la guida e' ambigua o
muta, la scelta e' nostra e dichiarata · **[INCOERENZA]** = la guida contraddice se stessa
(verificato con la sua stessa formula) · **[PROMESSA]** = affermazione commerciale non
verificabile, NON ripresa come fatto.

---

## 1. I prezzi di riferimento (p.4)

Per ogni simbolo e ogni timeframe (TF) la cella guarda **la candela IN CORSO** di quel TF:

| nome | significato |
|---|---|
| `C` | prezzo attuale (Bid live) = chiusura provvisoria della candela in corso |
| `O0` | apertura della candela in corso |
| `H0`, `L0` | massimo e minimo **finora** della candela in corso |
| `H1`, `L1` | massimo e minimo della candela **precedente** (chiusa) |

[GUIDA] Nessuna media, nessun oscillatore: solo confronti di prezzo (p.4).
[GUIDA] La cella mostra lo stato "rispetto all'apertura della candela CORRENTE" (p.35):
quindi una cella D1 descrive **la giornata di oggi finora**, W1 **la settimana finora**,
MN **il mese finora**. Non c'e' nessun "periodo" da scegliere: il periodo e' la candela in
corso di ciascun TF. Questo e' il punto che nei verbali non era mai verificabile, e qui lo
diventa (sez. 4.5).

## 2. Lo stato della cella (p.5-8, p.20)

### 2.1 Le sei condizioni della guida
| stato | condizione [GUIDA] | colore [GUIDA, pptx] |
|---|---|---|
| UP (rialzo moderato) | `C > O0` e `C <= H1` | verde chiaro `#22C55E` |
| UP_BREAK (breakout) | `C > H1` | verde scuro `#16A34A` |
| DN (ribasso moderato) | `C < O0` e `C >= L1` | rosso chiaro `#EF4444` |
| DN_BREAK (breakdown) | `C < L1` | rosso scuro `#B91C1C` |
| FAIL_UP (rottura in su respinta) | `H0 > H1` e poi `C <= H1` | nero `#1C1C1C` |
| FAIL_DN (rottura in giu' respinta) | `L0 < L1` e poi `C >= L1` | grigio `#6B7280` |

### 2.2 [SCELTA] Le condizioni si SOVRAPPONGONO: ordine di precedenza
La guida le elenca come se fossero esclusive, ma non lo sono: un prezzo sopra l'apertura che
e' salito oltre `H1` ed e' rientrato soddisfa **sia** UP **sia** FAIL_UP. Le slide "bordo +
riempimento" (p.10, p.21: "sopra Open ma breakout fallito") dicono che in quel caso il
riempimento e' il FAIL. Ordine che adottiamo:
1. `C > H1` -> **UP_BREAK** · `C < L1` -> **DN_BREAK** (la rottura in atto vince su tutto);
2. altrimenti, se `H0 > H1` **e** `L0 < L1` (candela che ha rotto da tutti e due i lati ed e'
   rientrata) -> **FAIL_DOPPIO** (settimo stato, la guida non lo prevede; valore 0, colore
   grigio scuro `DimGray`);
3. altrimenti `H0 > H1` -> **FAIL_UP** · `L0 < L1` -> **FAIL_DN**;
4. altrimenti `C > O0` -> **UP** · `C < O0` -> **DN**;
5. altrimenti (`C == O0`, nessuna rottura, nessun fail) -> **NEUTRO** (ottavo stato; valore
   0, riempimento **bianco**).
Uguaglianze: le soglie sono quelle della guida, alla lettera (`>` stretto per la rottura,
`<=` per il rientro). Prezzi confrontati come arrivano dal terminale (stessi decimali).

### 2.3 Bordo e riempimento (p.9, p.10, p.21)
[GUIDA] **Bordo** = dove sta il prezzo rispetto all'apertura: verde se `C > O0`, rosso se
`C < O0`. [SCELTA] grigio chiaro se `C == O0`. **Riempimento** = lo stato di 2.2.
[GUIDA] Le combinazioni lette dalla guida: bordo verde + verde scuro = "long ideale";
bordo verde + nero = "long in pericolo"; bordo verde + grigio = "long incerto"; e le
speculari in rosso. Nella dashboard le mostriamo solo come **colori + tooltip**, senza
consigli operativi.

### 2.4 [SCELTA] Valore numerico dello stato
La guida (p.13) da' i numeri per la forza: UP_BREAK **+2**, UP **+1**, FAIL_DN **+0,5**,
FAIL_UP **-0,5**, DN **-1**, DN_BREAK **-2**. [SCELTA] NEUTRO e FAIL_DOPPIO valgono **0**.
Il segno del fail e' quello della guida: una rottura in su respinta pesa **contro** il rialzo.

### 2.5 [SCELTA] Il giorno precedente del lunedi' (classe 1065)
Sul feed BCM (UTC+1, vedi CLAUDE.md "fuso orario") il forex ha spesso una **candela D1 della
domenica sera** di un'ora. Presa alla lettera, la guida userebbe come `H1/L1` del lunedi' il
massimo e minimo di quell'ora: la cella D1 del lunedi' andrebbe in breakout/fail per niente.
Per il **solo D1** la candela precedente e' **l'ultima candela da lunedi' a venerdi'** prima
di quella in corso (sabato e domenica saltati; input `InpD1SaltaWeekend`, default attivo).
Classe 1069: se fra le 7 candele D1 lette c'e' un **sabato**, il simbolo quota tutti i giorni
(cripto, se Claudio ne mette uno in lista) e allora **ogni giorno conta**: lo dicono i dati, non
la sessione dichiarata dal broker. Il forex con la candela della domenica non ha mai un sabato.
[NON COPERTO] H4/H1 il lunedi' mattina hanno come precedente una candela corta della
domenica: e' una candela vera di quel TF, la lasciamo.

## 3. La matrice (p.9, p.11, p.39)

- [GUIDA] 28 coppie in riga x 9 TF in colonna: **M1, M5, M15, M30, H1, H4, D1, W1, MN**,
  piu' una colonna **SEGNALE** (in inglese nella guida: SIGNAL) col testo del punteggio di
  confluenza (sez. 5).
- [GUIDA] Testi del segnale: **STRONG BUY / BUY / WEAK + / (vuoto) / WEAK - / SELL /
  STRONG SELL** (p.15). Colori dal pptx (slide 15): STRONG BUY `#16A34A`, BUY `#22C55E`, WEAK
  grigio `#8B949E`, SELL `#EF4444`, STRONG SELL `#B91C1C`.
- [GUIDA] Click (p.9, p.19, p.39): **simbolo -> grafico D1** di quel simbolo; **cella ->
  grafico di quel TF**; **valuta nel pannello forza -> filtra la matrice** alle sue 7
  coppie; riga delle Top Opportunities -> grafico D1.
- [SCELTA, sicurezza] I click **non cambiano MAI il grafico che ospita la dashboard** (cosi'
  non si ricarica ne' perde lo stato): aprono o riusano un grafico "di lettura" separato.
  Se quel grafico ha un EA attaccato, **non si tocca** e se ne apre uno nuovo (classe 930);
  dopo ogni apertura si controlla per 10 s che il grafico nuovo non abbia ereditato un EA
  dal template `default.tpl`, e se si' parte un `Alert` (classe 951).
- [GUIDA] "Aggiornata ogni 1 secondo" (p.9). [SCELTA] Il timer gira ogni secondo, ma i dati
  storici si scaricano **solo quando una candela di quel TF si apre** (vedi sez. 11).

## 4. Forza delle valute (p.12-14)

### 4.1 Pesi per TF — estratti e **verificati** (scritti nella guida, NON dedotti)
[GUIDA] p.13 (algoritmo) e p.11 (grafico a barre) danno gli stessi numeri:

| TF | M1 | M5 | M15 | M30 | H1 | H4 | D1 | W1 | MN | **somma** |
|---|---|---|---|---|---|---|---|---|---|---|
| peso | 1 | 1 | 2 | 3 | 4 | 6 | 10 | 15 | 20 | **62** |

Verifica dell'affermazione "D1+W1+MN = 45/62 = 73%": 10+15+20 = **45**; 45/62 = **72,58%**,
arrotondato **73%**: **torna**. Il collaudo lo ricontrolla dai pesi del sorgente.

### 4.2 La formula
[GUIDA] p.12-13, riscritta:
- per ogni cella (coppia `XXXYYY`, TF `t`) si prende il valore dello stato `v` (sez. 2.4);
- la valuta **base** `XXX` riceve `+ v x peso(t)`, la valuta **quotata** `YYY` riceve
  `- v x peso(t)` (il segno opposto della quotata e' l'errore classico: il collaudo lo prova);
- `forza[c] = somma_delle_celle / (n_coppie[c] x somma_pesi x 2)`;
- il "x 2" e' il valore massimo dello stato: quindi **`forza[c]` sta in [-1, +1]** (p.13).
- [GUIDA] si ordina dalla piu' forte alla piu' debole e si disegnano le barre (p.13).

[SCELTA] Denominatore con dati mancanti: si sommano solo le celle **con dati**; il
denominatore e' `2 x somma dei pesi delle celle usate` per quella valuta. Con tutte le 252
celle valide coincide **esattamente** con la formula della guida (7 coppie x 62 x 2 = 868).
Il pannello scrive la **copertura** (celle valide su 252) e "PARZIALE" se non e' completa.
[SCELTA] Un TF spento negli input esce anche dalla forza, e il pannello stampa i pesi
effettivamente usati e la loro somma.

### 4.3 Identita' algebrica — verificata sulla formula
- **La somma dei numeratori e' sempre ZERO**: ogni cella da' `+v·w` alla base e `-v·w`
  alla quotata. Vale sempre, anche con dati mancanti (ed e' **esatta** in virgola mobile:
  tutti i termini sono multipli di 0,5 con pesi interi).
- **La somma delle FORZE e' zero se e solo se i denominatori sono uguali** (o nei casi
  particolari in cui i numeratori si compensano). Con le 28 coppie complete ogni valuta sta
  in **7 coppie** e ha denominatore 868: somma delle forze = 0 (a meno dell'ultimo bit).
  Se il broker non ha una coppia, o una cella non ha dati, le due valute di quella coppia
  hanno denominatore piu' piccolo e **la somma delle forze NON e' piu' zero**. La dashboard
  lo dice: stampa nel Journal la somma e "denominatori uguali: si/no".
- **Antisimmetria**: rovesciando tutti gli stati (UP<->DN, BREAK<->BREAK opposto,
  FAIL_UP<->FAIL_DN) tutte le forze cambiano segno.
- Conseguenza pratica per la foto di Claudio (CHF +0,33, USD +0,19, GBP +0,04, EUR -0,18,
  NZD -0,18; AUD, CAD, JPY senza numero nella descrizione): **se** quella dashboard usa la
  formula della guida con le 28 coppie complete, AUD+CAD+JPY deve fare **-0,20** (circa,
  con l'arrotondamento a 2 decimali). Non verificabile da qui: i tre numeri mancano.

### 4.4 [INCOERENZA] Gli esempi numerici della guida escono dal suo stesso intervallo
- p.13 dice che la forza sta in [-1, +1]. Ma p.16 usa **GBP = +1,82, USD = -1,75**, p.31
  **JPY +1,50, USD -1,20**, il grafico di p.12 ha l'asse fino a **2**, e p.14 parla di
  "top > +1 e bottom < -1" e di "distanza top-bottom > 2,0". Con la formula di p.13 sono
  **impossibili** (il massimo e' 1, la distanza massima e' esattamente 2,0). Il collaudo
  lo prova per forza bruta. Quindi: o la dashboard del corso usa un'altra normalizzazione
  (non scritta), o gli esempi sono inventati. **Noi seguiamo la formula scritta.**
- p.12 dice che la normalizzazione serve perche' "USD ed EUR sono in 7 coppie, CHF/AUD/NZD/
  CAD in meno". **Falso** per l'elenco di 28 coppie: tutte e 8 le valute compaiono in
  **esattamente 7** coppie (8 valute, 28 = 8x7/2). La normalizzazione conta solo con elenchi
  incompleti o personalizzati. Il collaudo lo conta sull'elenco di default.

### 4.5 La diagnosi nel Journal (il punto che i verbali non avevano)
Ogni `InpDiagMinuti` minuti (default 15), alla prima copertura completa e a ogni click sul
titolo, la dashboard stampa nella scheda Esperti:
- una riga con i pesi usati e la loro somma;
- 4 righe con le 28 coppie e i 9 valori di stato per ciascuna (`?` = cella senza dati);
- una riga per valuta con numeratore, denominatore e forza a 4 decimali, e la somma.
Con queste righe la forza si **ricalcola a mano** (o con
`python3 backtest_pipeline/collaudo_forza_fx.py --diag file.txt`).

## 5. Punteggio di confluenza (p.15-17)

[GUIDA] Quattro componenti, pesi 40/30/20/10:
`Punteggio = (Allineamento x 40 + DiffForza x 30 + Rotture x 20 + Sanity x 10) / 100 x 100`
(cioe' semplicemente la somma pesata), in [-100, +100].
[GUIDA] Soglie (p.15, p.34): `>= 90` STRONG BUY, `>= 70` BUY, `>= 40` WEAK +, sotto 40 nessun
testo, e specularmente `<= -40` WEAK -, `<= -70` SELL, `<= -90` STRONG SELL. Le soglie 90 e 70
sono input nella guida (`InpThresholdStrong`, `InpThresholdNormal`); [SCELTA] anche 40 diventa
un input.

Le definizioni dei componenti sono **vaghe**; ogni scelta qui sotto e' nostra:

| componente | cosa dice la guida | [SCELTA] formula adottata, in [-1, +1] |
|---|---|---|
| **Allineamento** (40%) | "quanti dei 4 TF strategici (H4/D1/W1/MN) puntano nella stessa direzione; i Fail contano come inversi" | media sui TF H4, D1, W1, MN (quelli accesi) di `dir`: +1 per UP, UP_BREAK, FAIL_DN; -1 per DN, DN_BREAK, FAIL_UP; 0 per NEUTRO/FAIL_DOPPIO |
| **DiffForza** (30%) | "forza della base meno forza della quotata, diviso 2" | `(forza[base] - forza[quotata]) / 2` (sta in [-1,+1] per costruzione) |
| **Rotture** (20%) | "percentuale di TF in breakout reale vs TF attivi; penalita' per ogni Fail; non conta il semplice rialzo/ribasso" | media sui TF accesi di: +1 UP_BREAK, -1 DN_BREAK, -0,5 FAIL_UP, +0,5 FAIL_DN, 0 altrimenti (il fail pesa contro la direzione respinta, come nella forza) |
| **Sanity** (10%) | "coerenza delle correlazioni: ALIGN bonus, DIVERGE penalita'" | sez. 6: +1 ALIGN, -1 DIVERGE, 0 MIXED o nessuna correlazione, **moltiplicato per la direzione D1 della coppia** (il bonus spinge nel verso della coppia, la penalita' contro) |

[SCELTA] Il numero mostrato e' **arrotondato all'intero** e l'etichetta si decide **sul
numero arrotondato**: cosi' etichetta e numero non si contraddicono mai a video (un 89,6
mostrato "90" e' STRONG BUY). [SCELTA] Senza dati su tutti i TF accesi della coppia, il
segnale mostra `...` invece di un numero calcolato su celle mancanti.
[SCELTA] **Nessuna rinormalizzazione** quando la Sanity non si applica: con la formula
letterale le 23 coppie senza correlazione hanno massimo **±90**, quindi STRONG BUY solo col
massimo pieno degli altri tre componenti. E' una conseguenza della guida, la dichiariamo
(domanda aperta n.2 nella nota).

[INCOERENZA] I casi studio non si ricalcolano con le loro stesse definizioni:
- p.30 GBPUSD "STRONG BUY **+94**": i quattro pezzi scritti fanno 38+28+17+8 = **91**, non 94;
  "6/7 TF rialzisti" darebbe 34,3/40, non 38; "5 rotture su 7" darebbe 14,3/20, non 17;
  e "DiffForza" scrive diff 3,57 (p.30) dove p.16 scrive 1,785 per gli stessi numeri.
- p.31 USDJPY: 39+25+19+8 = 91 (torna), ma "4 rotture su 6" darebbe 13,3/20, non 19.
- p.19 mette USDJPY a **-81 SELL** e p.31 a **-91 STRONG SELL**: due istanti diversi,
  probabilmente; non lo dice.
Quindi i casi studio sono **illustrativi**, non un riferimento numerico per il collaudo.

## 6. Controllo delle correlazioni ("Sanity Check", p.18)

[GUIDA] Sette coppie strumento-strumento con segno atteso: DAX-EURUSD (+), FTSE-GBPUSD (-),
Nikkei-USDJPY (+), Oro-DXY (-), WTI-USDCAD (-), ASX200-AUDUSD (+), DAX-WTI (-, "condizionale").
Esiti: ALIGN (rispettata), DIVERGE (violata), MIXED (almeno uno neutro o in fail).
[SCELTA]:
- **TF del confronto: D1** (input `InpSanityTF`). La guida non lo dice; D1 e' quello che la
  guida chiama "direzionalita' primaria" (p.27).
- direzione di uno strumento = stato della cella su quel TF: +1 UP/UP_BREAK, -1 DN/DN_BREAK,
  0 per NEUTRO e per tutti i FAIL (cioe' MIXED, come dice la guida);
- ALIGN se `dir(coppia) == segno x dir(strumento)`, DIVERGE se opposto, MIXED se uno e' 0;
- **solo le 5 correlazioni che toccano una delle 28 coppie entrano nel punteggio**:
  EURUSD (DAX `D30EUR`, +), GBPUSD (FTSE `100GBP`, -), USDJPY (Nikkei `225JPY`, +), AUDUSD
  (ASX `200AUD`, +), USDCAD (WTI `USOIL`, -). Tutti e cinque i nomi BCM sono nel repo
  (`docs/BROKER_ESTERNO_MAPPA.md`, colonna BCM: `USOIL` = WTI; ordini su `USOIL` sul conto
  `50503392` in `report/CENSIMENTO_ORDINI_PC.md`). Su un altro broker un nome assente lascia la
  riga MIXED e la diagnosi lo scrive. Oro-DXY e DAX-WTI **non entrano** (nessuna delle 28
  coppie; il DXY su BCM `[NON VERIFICATO]`). Elenco modificabile dall'input `InpSanityMappa`.
- un simbolo correlato assente o senza dati = MIXED (0), mai inventato.

## 7. Top Opportunities (p.19)

[GUIDA] Le prime 5 per punteggio (input `InpTopOppCount`), click -> D1.
[SCELTA] Selezione: le N con **|punteggio| piu' alto** fra quelle con dati e con
|punteggio| >= soglia WEAK (40); a parita' vince l'ordine dell'elenco simboli. Mostrate in
ordine di punteggio **con segno**, dal piu' alto al piu' basso (l'esempio di p.19 e' cosi':
+94, +87, +73, -81, -91). Meno di N righe se meno di N coppie superano la soglia.

## 8. Colori (p.20, pptx)

Vedi 2.1 e 3. [SCELTA] Pannello **chiaro** come la foto di Claudio (sfondo quasi bianco,
testo scuro), non il tema scuro della guida. Bianco = NEUTRO; DimGray = FAIL_DOPPIO; cella
senza dati = bianca con un puntino e tooltip col motivo.
**[DOMANDA]** il "bianco" della foto di Claudio e' il nostro NEUTRO o e' il grigio chiaro
del FAIL_DN? Senza la foto in mano non si decide (domanda aperta n.1 nella nota).

## 9. Input della guida (p.34) e cosa ne facciamo

| guida | nostro | note |
|---|---|---|
| `InpAssetClass` FOREX_28 / INDICES | non c'e': elenco simboli libero `InpSimboli` | la modalita' indici non e' nel perimetro |
| `InpSymbolSuffix` | `InpSuffisso` | aggiunto a ogni nome; valute lette dalle prime 6 lettere del nome SENZA suffisso |
| `InpCellSize` 18 | `InpCellaPx` 18 | scalato coi DPI (classe 952) |
| `InpRefreshMs` 1000 | timer fisso 1 s | i dati storici non si ricaricano col timer (sez. 3) |
| `InpThresholdStrong/Normal` 90/70 | `InpSogliaForte/Normale` + `InpSogliaDebole` 40 | |
| `InpReuseChart` true | `InpRiusaGrafico` true | mai il grafico della dashboard |
| `InpShowSanity` true | `InpMostraSanity` true | |
| `InpTopOppCount` 5 | `InpTopOpp` 5 | |
| `InpUseM1`, `InpUseM5` (FAQ) | `InpUsaM1`...`InpUsaMN` | il TF spento esce anche da forza e confluenza |

## 10. [PROMESSA] Affermazioni non verificabili — NON riprese come fatti
- "sell **ad alta probabilita'**" (p.8), "**Alta probabilita'** ma anche alta volatilita'" (p.14);
- "Inversione **probabile**" (p.8), "i Fail su D1/H4 **spesso precedono inversioni veloci**" (p.25);
- "Strategia 1 — **la piu' affidabile. 3-5 setup/settimana**" (p.22): nessun conteggio, nessun backtest;
- "**Forza massima**" / "**Debolezza massima**" / "setup primario" (p.6, 7, 10, 16);
- "Protegge da segnali che contraddicono la struttura macro" (p.16) e i razionali delle
  correlazioni ("70%+ ricavi FTSE da estero", "oro anti-dollaro per definizione", "stessa
  economia — proxy quasi diretto", p.18): affermazioni di mercato, **nessuna misura** della
  correlazione ne' della sua stabilita';
- "La pazienza e' un **edge reale**" (p.32, 38) e "il mercato premia chi sa leggere la
  struttura" (p.40);
- "Solo price action puro, niente indicatori in ritardo" (p.4): e' una cornice, non un
  vantaggio misurato (anche "la candela precedente" e' un dato del passato).
La guida stessa avverte che i pesi "non sono ottimizzati" (p.17): e' l'unica frase sui numeri
che prendiamo alla lettera.

## 11. [SCELTA] Dati e aggiornamento (lezioni della SuperWave v4.1)

La guida dice solo "aggiornata ogni secondo". Come lo facciamo, e perche':
- **Ogni secondo**: un `SymbolInfoTick` per simbolo (nessuna copia di serie). Con quel prezzo
  si aggiornano chiusura, massimo e minimo **della candela in corso** di ogni TF, e lo stato.
- **`CopyRates` solo quando si apre una candela nuova di quel TF** (2 candele; 6 per il D1,
  per saltare il weekend), a rotazione, con un tetto di `InpCaricaMax` per secondo (40). A
  mezzanotte M1...D1 si aprono insieme su 28 coppie: il tetto le spalma su qualche secondo.
- **Correzione degli estremi**: un prezzo letto una volta al secondo perde le punte di mezzo
  secondo, e con esse i FAIL (la rottura respinta e' proprio una punta). Ogni
  `InpCorrezioneSec` (60) secondi si leggono **3 candele M1** per simbolo e i loro massimi e
  minimi rientrano nelle celle. Costo misurato in simulazione: circa 40 CopyRates al minuto per le
  candele nuove + ~33 per la correzione, contro le ~4.000 al minuto della SuperWave 4.00.
- **Una cella senza dati NON si azzera**: tiene l'ultimo stato valido e il tooltip dice
  perche' (storico non scaricato, serie in ritardo sull'ultimo tick, simbolo assente). Prima
  del primo dato valido la cella e' gialla pallida.
- **ChartRedraw** solo se un colore o un testo e' cambiato davvero.
- **Stato persistente** (filtro della valuta, grafico di lettura) in GlobalVariable legate al
  grafico: sopravvive a un cambio di TF del grafico ospite.

Il collaudo lo prova su 2 mesi di XAUUSD M1 veri (sezione R): con tutti i tick lo stato e'
uguale al riferimento a ogni passo e c'e' **una sola** CopyRates per candela nuova; campionando
solo apertura e chiusura del minuto **senza** correzione gli stati sbagliano (decine di
migliaia di FAIL invisibili), **con** la correzione tornano giusti a ogni chiusura.

## 12. Fuori perimetro (deliberatamente)
Strategie 1-4, protocollo, checklist, stop/target/R:R/size, modalita' INDICES (p.36), file
`.tpl` di sovrapposizione (p.33), profili MT5. La dashboard **mostra**; non decide e non misura.
