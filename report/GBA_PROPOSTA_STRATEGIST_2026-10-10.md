# GBA (ABTG_GoldBreakoutATR v1.10, magic 775800, XAUUSD M1) - PROPOSTA STRATEGIST: filtri di trend, momentum, volatilita', retest, lato (10/10/2026)

Autore: agente STRATEGIST (ottimizzazione Entry/Exit). **BOZZA, NON PASSATA DAL CANCELLO.** Solo carta e analisi di sola lettura su archivi gia' prodotti: nessun backtest eseguito sul PC di backtest, nessun EA/preset/conto/forward toccato, nessun file prova creato. **Non e' una consegna a Claudio finche' `controllo-preventivo` non l'ha letta.**
Etichette: **[MISURATO]** rifatto da me sui deal/giornali grezzi di R1A e R1B | **[PROXY]** simulatore a barre M1 HistData (`proxy_gba_r2reg.py`, esteso da me): NON e' il tester, NON e' il feed BCM | **[DERIVATO]** conto su numeri misurati | **[INFERITO]** ragionamento | **[NON MISURATO]** buco | **[POST-HOC]** letto sugli stessi dati 2026 su cui nasce l'ipotesi: IPOTESI, mai prova.
Fonti: `backtest_pipeline/risultati_archivio/GBA_R0_R1A_20261010/GBA_R0_R1A.zip` (REPL 0,05; 933 operazioni), `.../GBA_R0_R1B_20261010/GBA_R0_R1B.zip` (C010/C020/C035; uso la C035, 7.420 operazioni), `report/GBA_R0_R1A_LETTURA_2026-10-10.md`, `report/GBA_R0_R1B_LETTURA_2026-10-10.md`, `report/GBA_R2_PIANO_2026-10-10.md`, `report/GBA_PROPOSTA_MARKET_REGIME_2026-10-10.md` (agente gemello: ORA e trend H1/H4/D1; non lo ripeto), `backtest_pipeline/prove/GBA_R2_REGIME_2026-10-10.txt`, `docs/SAPERE_LIVE_PER_EA.md` (regola dei coach: retest, ADX 20/25, Bollinger), `backtest_pipeline/REGISTRO_TEST.md` (priori: R83 retest, CRT gate ADX, RSI+EMA V8, LONDONFX), sorgente `mql5/Experts/ABTG_GoldBreakoutATR.mq5` (SHA 1381E3DC..., letto: input r.118-186, `GbaDecidi`, `GbaLeggiSegnale`, `GbaApri`).
**Riproducibilita'**: gli script d'analisi stanno nella cartella di lavoro della sessione, **NON in repo** (mandato di commit: solo questo path). Metodo riscritto in sez. 3.1 perche' una sessione dopo il cancello possa rifarlo (buco 1).

---

## 0. IN DIECI RIGHE

1. **C'e' un solo segnale nei dati e nessuno dei tre blocchi chiesti dal capo lo contiene tutto: e' il MOMENTUM GIA' ALLINEATO sui TF 5-15 minuti al momento della rottura M1.** Le rotture in cui RSI/Stocastico/pendenza-EMA di M5-M15 sono gia' a favore perdono molto meno: terzile alto contro terzile basso, R1A (REPL, n=884 allineate): PF_V 1,17-1,46 contro 0,44-0,51 (RSI M15, RSI M5, Stoc M15, pendenza EMA50 M5 e M15); R1B C035 (n=6.992): 1,01-1,07 contro 0,59-0,64. Differenza di R medio per operazione: **+0,24-0,29 (R1A), +0,08-0,11 (C035)**, intervallo 90% bootstrap per giorno sempre sopra zero (es. RSI M15: [+0,13; +0,35] e [+0,06; +0,16]). [MISURATO, POST-HOC]
2. **Ma e' un effetto quasi tutto di T3 (gen-mar 2026), non del 2026 intero**: Delta R per tranche T1 / T2 / T3 = +0,04 / +0,16 / +0,33 (RSI M15, R1A) e +0,01 / +0,06 / +0,27 (C035). **Nelle tranche T1 e T2 anche la parte "buona" resta sotto 1** (C035, RSI M15 >= 65: T1 0,91, T2 0,91, T3 1,60). Sotto la regola S8 firmata (PF_V > 1,0 in OGNI regime misurato) **nessuna di queste celle passerebbe oggi**. [MISURATO]
3. **Fuori dalla scoperta l'effetto NON si vede.** Screening [PROXY] sulla cella larga, 5 anni (2021-2025, 2.200-8.400 operazioni all'anno): lift di PF del filtro rispetto al neutro **-0,03 / +0,03 in media, positivo in 1-4 anni su 5** (RSI M15 >= 65: -0,11 / +0,04 / +0,08 / -0,03 / -0,04). Nello stesso proxy il 2026 da' lift +0,24. Il proxy riproduce solo ~40% dell'effetto 2026 (Delta R +0,046 contro +0,110 del tester): **non e' una smentita, e' un'ipotesi che non ha ancora un secondo regime a favore**. [PROXY]
4. **Il test vero costa ZERO passate e zero codice**: le 12 passate di R2REG (C035 su T4-T9, tick reali, 2024.07-2025.12, migliaia di operazioni a tranche) contengono gia' ogni segnale con close/canale/EMA/ATR/ora; le feature di indicatore si calcolano da HistData con una procedura che ho gia' controllato (allineamento 99% sul 2026). **Proposta ST0: congelare ORA criteri e tagli, leggere R2REG "per feature" appena passa il cancello.** Solo se replica (criteri P1-P4, sez. 6) si scrive codice. Attesa scritta prima: Delta R poolato **-0,10 / +0,04**; smentita (l'ipotesi vive): **>= +0,05** con p5 > 0 e segno positivo in >= 4 tranche su 6.
5. **ADX, ampiezza Bollinger, percentili di ATR, ampiezza del canale: attesa NULLA e i dati lo confermano.** ADX M15 / H1 / M1: t da -0,35 a +0,91; ADX M5 +0,04 R (C035, IC90 [-0,00; +0,09]). **L'espansione dell'ampiezza di Bollinger ha segno CONTRARIO alla regola dei coach** (terzile alto PF_V 0,72-0,73 contro 0,88-0,91; C035 Delta R -0,063, IC90 [-0,107; -0,023]): entrare quando le bande si sono appena aperte e' peggio, non meglio. Percentile di ATR e larghezza del canale: nessuna forma. [MISURATO]
6. **Il retest (ingresso sul livello rotto invece che in corsa) non migliora il PF nel proxy**: REPL 2026 PF 1,011 -> 0,98-1,03 con n -12/-20%; C035 0,853 -> 0,84; nei 5 anni lift medio -0,045. Costa codice (ordine pendente con scadenza). **Non nei cinque.** Coerente con R83 del registro: il retest e' un duello **per mercato** (vince sul DAX, perde sul Nasdaq). [PROXY]
7. **Asimmetria long/short**: SELL peggiore di BUY nella C035 in tutte e 3 le tranche (T1 0,73 / 0,87, T2 0,78 / 0,80, T3 0,77 / 0,98; n >= 1.000 per lato e tranche), ma nella REPL il segno si ribalta in T3 (BUY 0,77, SELL 0,93) e **in T2, il ribasso, SELL non guadagna (0,73-0,78)**. Solo-BUY nel proxy: lift +0,05 in media, positivo 4 anni su 5, **PF resta 0,65-0,90 (< 1)**. Non crea edge; toglie una zavorra. 6 passate (BUY-only + SELL-only), zero codice. [MISURATO / PROXY]
8. **Uscita**: nessun trigger nuovo proposto. Uscire quando l'RSI M5 si rovescia: lift 0,00 (soglia 40, scatta quasi mai) e -0,03 (soglia 50, peggiora in 6 anni su 6). Le manopole di uscita esistenti sono gia' nel piano R2U. [PROXY]
9. **Frontiera di costo `stop >= 40 x spread` intatta**: nessun filtro cambia lo stop. REPL resta a 58,8x (PASSA); le celle larghe restano FRA (17-20x) e servono solo come lente sul meccanismo, mai come sedia.
10. **Costo totale**: ST0 0 passate; le quattro proposte senza codice (TrendTF M15, lato x2, AtrTF M5/M15) **18 passate, ~17 minuti**; le proposte con codice (RSI, Stocastico, pendenza) partono **solo se ST0 replica**: +6 passate di scoperta e +12 di validazione ciascuna (~17 minuti), piu' il lavoro di `mql5-ea-developer` e due strati di cancello. 56 s a passata [MISURATO in R1B], PC di backtest, mai sul VPS.

---

## 1. LE 5 PROPOSTE PRIORITARIE (ordinate per beneficio / costo)

| # | Proposta | Input | Esiste? | Neutro (= oggi) | Valori | Passate | Minuti | Beneficio atteso (banda scritta prima) | Priorita' |
|---|---|---|---|---|---|---:|---:|---|---|
| **ST0** | Lettura "per feature" di R2REG: momentum / ADX / Bollinger / pendenza, tagli congelati ORA | nessuno (lettura) | si' (dati di R2REG) | - | RSI M15 (primaria), RSI M5, Stoc M15, pendenza EMA50 M5 e M15; ADX M5 e BB-espansione (attesa nulla) | **0** | 0 (circa 1 ora di analisi) | decide se vale scrivere codice; Delta R poolato atteso -0,10 / +0,04 | **1** |
| **ST1** | Momentum allineato RSI(14) su M15: ingresso solo se RSI e' dal lato della rottura | **NUOVO** `InpRsiMinAligned` (+ `InpMomTF`) | **NO (codice)** | 0.0 = spento | 60, 65 | 6 scoperta (REPL x 3 tranche x 2) + 12 validazione C035 T4-T9 | ~6 + ~11 | REPL: n 220-460, PF_V 0,90-1,25 (post-hoc 1,11 / 1,25; proxy 0,91 / 1,12 dopo calibrazione); **GATED da ST0** | **2** (beneficio piu' alto, ma condizionato) |
| **ST2** | EMA100 su M15 (medie lunghe su TF superiore): estende MR3 del dossier gemello (H1/H4/D1) con M15 | `InpTrendTF` | **si'** | 0 = TF del segnale | M15 (aggiungere M5 solo se serve completezza) | 3 (6 con M5) | ~3 (~6) | n 600-800, PF_V 0,78-0,95, |lift| <= 0,06; attesa NULLA: chiude la casella | **3** |
| **ST3** | Lato: solo-BUY e solo-SELL, per chiudere "i due lati" con la sequenza vera | `InpAllowShort` / `InpAllowLong` | **si'** | true / true | false (un file ciascuno) | 3 + 3 | ~6 | solo-BUY n 420-520 PF_V 0,84-0,95; solo-SELL n 470-560 PF_V 0,72-0,88; non crea edge | **4** |
| **ST4** | Scala dell'ATR: stop/trail/BE/spread calcolati sull'ATR di M5 o M15 invece che di M1 | `InpAtrTF` (oggi "[APERTO]") | **si'** | 0 = TF del segnale | M5, M15 | 6 | ~6 | n 2.300-3.400, PF_V 0,68-0,90, costo PASSA (50-95x) [DERIVATO]; frontiera di frequenza, non di PF | **5** |

**Non nei cinque (con il numero accanto)**: Stocastico M15 (`InpStochMinAligned`) e pendenza EMA (`InpSlopeMinATR`) = stessa famiglia di ST1, si fanno SOLO dopo ST0 e non prima di ST1 (sono correlati 0,70-0,82 con l'RSI: contano come UNA ipotesi); ADX (`InpAdxMin`); espansione Bollinger (`InpBbwMaxExp`); retest (`InpRetestBars`); uscita su rovesciamento di momentum. Spec e numeri in sez. 4 e 5.

---

## 2. COSA E' GIA' PROVATO (con le fonti) E COSA NO

**Provato (R1A, R1B; un regime, gen-set 2026, tick reali Modello 4):** REPL PF_V 0,855 su n=933; C010/C020/C035 0,830 / 0,819 / 0,817 su 3.918 / 6.949 / 7.420; lordo dei costi ~0 (-0,014 R +- 0,028, `GBA_R2_PIANO` 1.5): **nessun filtro crea un edge che non c'e'; puo' solo togliere la parte che perde di piu'**. Il filtro di spread e' un pavimento di ATR (`GBA_R2_PIANO` 1.8).
**Provato altrove nel registro (priori, non sono GBA):**
- **ADX come cancello**: CRT Turtle Soup, gate ADX(D1) <= 30 era "valido su OHLC" ma **a tick reali PF 0,459 contro 0,462 senza gate** (`REGISTRO_TEST.md`, saga CRT 31/08). Lascito tecnico: gli handle `iADX`/`iATR` su D1 **non popolano nel tester**; per M5/M15 non e' noto: **gate G0 obbligatorio** (sez. 4, ST1).
- **RSI come filtro**: RSI+EMA V8 (il filtro toglie solo il 9-13% degli incroci, non e' un filtro vero); LONDONFX (RSI taglia il 73-77% dei segnali: filtro vero, ma su altro motore e solo passo 0). Nessuno dei due dice niente su GBA.
- **Retest**: R83 (18/19-08): DAX PF OOS 1,19 contro 1,04 dello stop (il retest vince), **Nasdaq 0,62 contro 0,87 (il retest perde)**; regola scritta: *"ogni estensione a un altro indice RIFA' il duello, non eredita il retest"*. Vale per un altro motore (apertura, ordine LIMIT): per il GBA e' una **tesi nuova**, quindi non e' una riesumazione.
- **Slope**: NY Session Retest, "slope VWAP: monotono, DD dimezzato" ma n=114 < 150 (muro R59). Stessa famiglia concettuale (pendenza) e **stessa trappola** (campione sottile).
**Sovrapposizioni col dossier gemello `GBA_PROPOSTA_MARKET_REGIME`:** la loro MR0 e' la stessa idea di ST0 applicata all'ORA (lettura per fetta gratis su R2REG); la loro MR3 e' `InpTrendTF` H1/H4/D1. **Non le ripeto**: ST2 aggiunge M15 allo stesso file (una variabile, un file); ST0 aggiunge le feature di indicatore alla stessa lettura. Loro 4.10 dice che il lato lo decide R2REG per regime e non propongono `AllowShort=false`: ST3 e' piu' costoso di una lettura e lo tengo al quarto posto per questo.
**Mai provato sul GBA:** nessun oscillatore, nessuna pendenza, nessun ADX, nessuna ampiezza Bollinger, nessun retest, `InpAtrTF` e `InpAllowShort/Long` mai messi ad asse (verificato: nessun file prova GBA li varia; `GBA_R2_REGIME` ha solo `InpSpreadMaxATR`).

---

## 3. LE MISURE CHE HO FATTO (tutte POST-HOC o PROXY: ipotesi, non prova)

### 3.1 Metodo [MISURATO] e il controllo che l'ha corretto
Ho ricaricato i deal dei report .htm e le righe `[GBA] segnale ...` dei giornali con `leggi_gba_uscite.operazioni()` (stesso lettore del piano R2): 933 operazioni R1A, 7.420 C035. Per ogni operazione ho cercato la barra M1 HistData del segnale (proxy: `proxy_gba_r2reg.carica()`, tempo server) e calcolato **a quell'istante, senza guardare avanti**: RSI(14) / Stoc(14,3,3) / EMA50 pendenza su 5 barre / ADX(14) su M5, M15 e H1 (barre aggregate dai M1, ultima barra chiusa), RSI e ADX e Stoc su M1, EMA 100/300/1000 su M1, EMA50/200 su M5/M15/H1, ampiezza Bollinger(20,2) (livello, percentile su 1.440 barre, rapporto con 10 barre prima), ATR (percentile su 1.440 barre, rapporto con ATR(100)), ampiezza del canale in ATR, "estensione" della chiusura oltre il canale in ATR. Per i lati SELL le feature direzionali sono specchiate (RSI "allineato" = 100 - RSI). 28 feature.
**Controllo di allineamento e correzione (il punto piu' importante del metodo):** ho confrontato close / EMA100 / ATR del giornale (BCM) con quelli ricalcolati su HistData alla barra scelta. **La prima volta il 10% degli ingressi non tornava (scarto mediano 12,6 USD in marzo 2026, 73% delle operazioni del mese)**: nelle settimane fra il cambio d'ora USA e quello europeo le barre HistData e il server BCM sono sfasati di un'ora. Quella prima lettura dava t = 4,85 sul trend lungo (EMA300): **era un artefatto del disallineamento**. Corretta la scelta della barra (provo sfasamenti 0 / +1 ora / -1 ora e tengo solo quello in cui |close| <= 1,5 USD e |ATR| <= 1,0): **884 su 933 (R1A) e 6.992 su 7.420 (C035) operazioni allineate**; sfasamento di 1 ora corretto su 187 e 547; scartate 49 e 428. Dopo la correzione scarto mediano |close| 0,27 / 0,22 USD, |ATR| 0,075 / 0,062; ATR entro 0,5 nel 99%. Il t del trend lungo e' sceso da 4,85 a 2,10. **Tutte le cifre di questo dossier sono sul campione allineato.** (Lo stesso accorgimento servira' su R2REG: nel 2024 il server forex era IT-1 tutto l'anno, vedi `OROLOGIO_BCM`.)

### 3.2 Terzili delle feature [MISURATO, POST-HOC] (campione allineato; "alto" = terzile con la feature piu' a favore della rottura)

| feature | R1A REPL: basso / medio / alto (PF_V) | t (alto-basso) | R1A Delta R, IC90 per giorno | C035: basso / medio / alto | C035 t | C035 Delta R, IC90 |
|---|---|---:|---|---|---:|---|
| pendenza EMA50 M5 (5 barre, in ATR M1) | 0,51 / 0,70 / **1,46** | +3,98 | +0,29 [+0,16; +0,41] | 0,61 / 0,80 / 1,07 | +3,55 | +0,10 [+0,05; +0,15] |
| pendenza EMA50 M15 | 0,44 / 0,87 / 1,39 | +3,66 | +0,25 [+0,13; +0,37] | 0,60 / 0,87 / 1,01 | +3,47 | +0,10 [+0,05; +0,15] |
| Stocastico M15 (allineato) | 0,48 / 0,89 / 1,24 | +3,66 | +0,25 [+0,14; +0,36] | 0,60 / 0,83 / 1,06 | +3,81 | +0,11 [+0,06; +0,15] |
| **RSI M15 (allineato)** | 0,46 / 1,01 / 1,17 | +3,56 | +0,24 [+0,13; +0,35] | 0,59 / 0,86 / 1,03 | **+3,98** | +0,11 [+0,06; +0,16] |
| RSI M5 (allineato) | 0,50 / 0,80 / 1,34 | +3,52 | +0,24 [+0,13; +0,36] | 0,64 / 0,82 / 1,01 | +2,77 | +0,08 [+0,03; +0,13] |
| EMA1000 distanza (medie lunghe, in ATR) | 0,62 / 0,82 / 1,19 | +2,36 | -- | 0,70 / 0,87 / 0,90 | +1,85 | -- |
| EMA300 distanza | 0,60 / 0,87 / 1,09 | +2,10 | +0,15 [+0,04; +0,26] | 0,65 / 0,89 / 0,94 | +1,98 | -- |
| ADX M5 | 0,57 / 0,93 / 1,04 | +2,24 | +0,15 [+0,04; +0,26] | 0,79 / 0,71 / 0,96 | +1,54 | +0,04 [-0,00; +0,09] |
| ADX M1 / M15 / H1 | nessuna forma | +0,91 / -0,35 / +0,64 | -- | nessuna forma | -0,35 / -0,53 / -0,31 | -- |
| ampiezza Bollinger, espansione (10 barre) | 0,91 / 0,89 / **0,73** | -0,81 | -0,06 [-0,19; +0,08] | 0,88 / 0,90 / **0,72** | **-2,30** | **-0,06 [-0,11; -0,02]** |
| percentile ATR, percentile Bollinger, ampiezza canale, estensione oltre il canale | nessuna forma (t da -0,52 a +0,29) | | | nessuna forma | | |

Tagli (terzili del campione, **congelati qui per ST0**): C035 RSI M15 basso <= 48,509 / alto > 57,951; RSI M5 <= 53,640 / > 61,001; Stoc M15 <= 40,449 / > 72,138; pendenza EMA50 M5 <= -0,110 / > 0,653; M15 <= -0,667 / > 0,912; ADX M5 <= 18,500 / > 26,912; espansione Bollinger <= 1,012 / > 1,417.
**Controllo di molteplicita'**: massimo |t| su 28 feature osservato 3,98 (R1A); rimescolando R fra le operazioni 0 permutazioni su 1.000 lo eguagliano. **Limite**: la permutazione per operazione ignora il raggruppamento per giorno, quindi e' ottimista; per questo riporto sopra l'intervallo bootstrap PER GIORNO (che resta sopra zero, ma con la distribuzione piu' larga). Le cinque feature in testa sono correlate 0,70-0,94 fra loro: **contano come UNA ipotesi** ("il momentum di M5-M15 e' gia' a favore"), non come cinque conferme.
**Soglie naturali, non terzili** (per le celle proposte): R1A, RSI M15 allineato >= 60: n=369 PF_V 1,11 (T1 0,89 / T2 0,77 / T3 1,37); **>= 65: n=243 PF_V 1,25 (1,19 / 0,94 / 1,40)**; >= 70: n=138 PF_V 1,59 (sospeso, n < 150). C035: >= 60 n=1.888 PF_V 1,08 (0,83 / 0,90 / 1,38); >= 65 n=1.005 PF_V 1,19 (0,91 / 0,91 / 1,60). RSI M5 >= 65: R1A n=295 PF_V 1,34 (0,76 / 1,15 / 1,65); C035 n=1.332 PF_V 1,14 (0,82 / 1,02 / 1,47). I decili grezzi dell'RSI M15 non sono monotoni (PF 0,30 0,40 0,60 1,03 1,39 0,88 0,57 0,98 1,25 1,75): **il picco del decile alto non si usa**, le soglie sono numeri tondi scelti a priori.
**Lato dentro il momentum**: RSI M15 >= 65, R1A: BUY 1,86 (n=92), SELL 1,02 (n=151). La zavorra SELL non sparisce con il filtro.

### 3.3 Dove vive l'effetto [MISURATO]
Delta R (alto-basso) per tranche, T1 / T2 / T3. **R1A**: RSI M15 +0,04 / +0,16 / +0,33; RSI M5 -0,11 / +0,17 / +0,35; Stoc M15 +0,15 / +0,07 / +0,37; pendenza M5 +0,11 / +0,11 / +0,40; pendenza M15 +0,01 / -0,08 / +0,43. **C035**: RSI M15 +0,01 / +0,06 / +0,27; RSI M5 +0,05 / +0,01 / +0,17; Stoc M15 +0,04 / +0,04 / +0,26; pendenza M5 +0,03 / +0,02 / +0,25. **Il segno e' quasi sempre positivo, ma l'ordine di grandezza e' T3.** T3 e' laterale-volatile (+4,1%, ER 0,035, ATR/prezzo 5,84 bp), la tranche piu' ricca di segnali (557 di 933) e di movimenti di impulso: un filtro che separa "impulso in corso" da "rottura senza spinta" ha proprio li' il suo terreno.
**Quota dei motivi d'uscita**: nel terzile alto TRAIL_PROFIT e' 30-32% (contro 21-22% nel basso) e l'R medio del TRAIL_PROFIT 0,97-1,04 (contro 0,73-0,76); BE invariato (32%); SL iniziale ~1% in tutti. Cioe' il filtro **non cambia la meccanica**, sposta operazioni dal "trailing sotto l'ingresso" (45-46% -> 33-35%) al "trailing in profitto".

### 3.4 Screening fuori scoperta, 2021-2025 [PROXY, non verdetto]
Simulatore a barre sulle M1 HistData (esteso da `proxy_gba_r2reg.simula`: stesse uscite, stesso spread per ora di settembre 2026 applicato a tutti gli anni, **gli stessi livelli di costo**; i livelli assoluti di PF non contano, conta il lift rispetto al neutro dello stesso anno). **Controllo del mio simulatore**: con il filtro spento riproduce `simula` operazione per operazione (n e netto identici su 3 tranche: 658 / 246 / 113). **Calibrazione**: REPL 2026 proxy PF 1,011 su n=1.017 contro tester 0,855 su n=933: il proxy e' ottimista di ~+0,16 PF e +9% di operazioni.
Cella C035 (migliaia di operazioni: 2.200-8.400 all'anno), lift PF = PF(filtro) - PF(neutro) nello stesso anno:

| filtro | 2021 | 2022 | 2023 | 2024 | 2025 | positivi su 5 | media | **2026 (scoperta)** |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| RSI M15 >= 60 | -0,13 | +0,06 | 0,00 | -0,08 | -0,02 | 2 | -0,03 | +0,08 |
| RSI M15 >= 65 | -0,11 | +0,04 | +0,08 | -0,03 | -0,04 | 2 | -0,01 | **+0,24** |
| RSI M5 >= 65 | +0,04 | -0,01 | +0,10 | +0,01 | +0,04 | **4** | +0,03 | +0,08 |
| Stoc M15 >= 70 | -0,09 | +0,02 | +0,01 | -0,04 | +0,03 | 3 | -0,02 | +0,08 |
| Stoc M15 >= 80 | -0,08 | -0,02 | 0,00 | -0,02 | +0,03 | 1 | -0,02 | +0,19 |
| pendenza EMA50 M5 >= 0,5 ATR | -0,11 | +0,04 | -0,05 | -0,05 | +0,04 | 2 | -0,02 | +0,06 |
| pendenza EMA50 M15 >= 0,5 ATR | -0,03 | 0,00 | +0,02 | -0,03 | +0,12 | 2 | +0,01 | +0,07 |
| EMA100 su M15 (`InpTrendTF`) | -0,03 | +0,01 | 0,00 | -0,01 | +0,03 | 2 | 0,00 | +0,05 |
| EMA100 su H1 | +0,01 | -0,06 | +0,04 | -0,01 | +0,04 | 3 | +0,00 | +0,04 |
| solo-BUY | -0,03 | +0,06 | +0,14 | +0,01 | +0,06 | **4** | **+0,05** | +0,05 |
| retest W=12, profondita' 0,25 ATR | -0,10 | +0,04 | -0,16 | +0,01 | -0,01 | 2 | -0,05 | -0,01 |

**Cosa dice**: in 5 anni a regimi diversi i filtri di momentum danno un lift medio entro +-0,03 e positivo in 1-4 anni su 5: **nessuna prova di replica**. **Cosa NON dice**: (a) il proxy riproduce solo ~40% dell'effetto nel 2026 stesso (Delta R RSI M15 alto-basso: proxy +0,046, tester C035 +0,110; stessa cosa per le altre feature), quindi e' uno strumento **debole**: un effetto vero della meta' di quello del 2026 non si vedrebbe bene; (b) i costi della cella larga sono schiaccianti (PF neutro 0,61-0,78 negli anni 2021-2025): sul PF il filtro ha poco margine. L'unica lettura onesta e': **ipotesi nata e confermata nel 2026, senza conferma altrove, con uno strumento di conferma debole**. Per questo ST0 (tick reali, 2024-25, migliaia di operazioni) vale piu' di questo screening.
**La cella REPL fuori dal 2026 e' vuota** [PROXY]: operazioni per anno 1 / 3 / 3 / 8 / 210 / 1.035 (2021...2026). Conferma `GBA_R2_REGIME` E1: la REPL e' un fenomeno da meta' 2025.

### 3.5 Retest [PROXY]
Regola simulata: dopo un segnale valido (filtro di spread incluso) si aspetta per W barre un ritorno del prezzo al livello rotto (+ profondita' d ATR dal lato interno), ordine LIMIT con riempimento al livello o all'apertura se peggiore, una sola posizione per volta anche durante l'attesa; uscite identiche, tempo contato dal riempimento. REPL 2026 (3 tranche, neutro PF 1,011, n=1.017):

| cella | n | PF | note |
|---|---:|---:|---|
| W=3, profondita' 0 | 821 | 0,888 | |
| W=6, 0 | 826 | 0,927 | |
| W=12, 0 | 839 | 0,919 | |
| W=6, 0,25 ATR | 897 | 1,001 | |
| W=12, 0,25 | 895 | 0,984 | |
| W=12, 0,50 | 940 | 0,986 | |
| W=24, 0,25 | 889 | 1,029 | **il migliore, +0,02: dentro il rumore** |
| C035: W=6 / 12 / 12(0,5) | 6.106 / 6.075 / 6.386 | 0,843 / 0,842 / 0,844 | neutro 0,853 |

Fra il 12% e il 20% dei segnali non ritesta mai entro W: e' proprio quella la quota di operazioni che il retest perde (le vincenti che corrono senza fermarsi: R medio piu' alto). Il guadagno di prezzo d'ingresso viene mangiato dalla perdita di quelle. **Il retest e' una tesi legittima sui mercati con rottura-falsa (DAX apertura); sul GBA a M1 il proxy non la sostiene.**

### 3.6 Uscita su rovesciamento di momentum [PROXY]
Chiudere al mercato quando l'RSI(14) M5 allineato scende sotto una soglia (dopo l'ingresso, al primo ciclo): cella C035 lift PF per anno 2021...2026 = 0,00 / 0,00 / 0,00 / 0,00 / 0,00 / +0,00 con soglia 40 (scatta per l'1-2% delle operazioni: inerte) e **-0,04 / -0,03 / -0,05 / -0,04 / -0,02 / -0,03** con soglia 50. REPL 2026: 0,00 e -0,05. Il trailing + BE esistenti hanno gia' la funzione. **Non proposto.**

### 3.7 Volatilita' [MISURATO]
Tre famiglie provate sui dati: (a) percentile ATR (1.440 barre): R1A terzili 0,90 / 0,74 / 0,87, t -0,24; C035 t +1,36 (non monotono); (b) ampiezza Bollinger: percentile 0,95 / 0,79 / 0,78 (R1A) e 0,93 / 0,69 / 0,87 (C035): niente "compressione che precede la rottura"; **espansione recente: segno negativo** (sez. 3.2); (c) ampiezza del canale in ATR: 0,88 / 0,83 / 0,81, t +0,26. Il tema "spreme-e-poi-scatta" dei coach (Std Dev in espansione come conferma, Paolo, `SAPERE_LIVE_PER_EA` T6) **non e' sostenuto**; la direzione opposta e' debole (t -2,3 su un solo lotto di sette) e non sopravvive a un confronto multiplo su 28 feature. [POST-HOC]
Dato gia' presente nel dossier gemello e coerente: ATR d'ingresso non monotono (0,68-0,79 sotto 4, 0,86-0,91 fra 4 e 7, 0,98 sopra 7).

---

## 4. LE PROPOSTE, UNA PER UNA (attese scritte PRIMA di qualunque numero nuovo)

**Regole comuni congelate ora** (non si cambiano dopo i numeri):
- **Una variabile per file prova**; cella neutra = comportamento identico a oggi; ogni file ha la sua cella neutra come controllo tecnico (deve riprodurre i numeri di R1A sulla stessa tranche: REPL T1 n=128, PF 0,83, T2 248 / 0,77, T3 557 / 0,89). **Asse tecnico** (gemella sul magic) per il cancello G1: obbligatorio nei file con passate a Modello 1; a Modello 4 si fa cosi' come in R1A.
- **Si allarga sui MECCANISMI, non sui valori** (regola 19/08): ogni asse ha **2-3 valori tondi scelti a priori**, nessuna griglia fitta; la cella da riportare, se serve, e' il **centro dell'altopiano**, mai il picco; con due valori l'altopiano non si legge e conta il segno concorde.
- **Lettura del merito**: S1 (n >= 150), S2 (costo), S8 (rumore: PF_V <= 1,03 = indistinguibile dalla REPL), S9 (un filtro che toglie piu' del 40% delle operazioni e' SELEZIONE, non miglioramento: si scrive cosi'), e la regola per regimi firmata il 10/10 (PF_V > 1,0 in ogni regime con n >= 150, long e short separati). **A un filtro non si assegna mai "regge"**: "regge" e' solo la regola dei regimi.
- **Frequenza**: la REPL fa 4,8 operazioni/giorno; RSI M15 >= 65 la porta a ~1,3/giorno (27% di 4,8), >= 60 a ~1,9/giorno (40%): sopra il pavimento di famiglia di 1,00/giorno, sotto il 3,0/giorno che il dossier gemello usa come soglia di allarme; si dichiara.
- Tick reali (Modello 4), XAUUSD M1, lotto fisso 1,00, deposito 1.000.000, tranche T1/T2/T3 di R1A (scoperta). **Mai sul VPS.** `GBA_R0_PASSATE.ps1` v4 accetta oggi solo `InpSpreadMaxATR` come variabile di cella: la generalizzazione e' gia' prevista in `GBA_R2_PIANO` 3.5 (lavoro, non macchina).

### 4.1 ST0 - Lettura "per feature" di R2REG (zero passate, zero codice)
- **Idea**: le 12 passate di R2REG (REPL e C035, T4-T9) producono i report .htm e i giornali con una riga di segnale per ogni rottura (close / canale / EMA / ATR / ora). Con la procedura di 3.1 (HistData + controllo di allineamento) si ricostruiscono le feature e si legge il Delta R alto-basso **con tagli gia' congelati (sez. 3.2)**, per tranche.
- **Ipotesi congelate (10/10/2026, prima di R2REG)**:
  - **Primaria: RSI(14) M15 allineato.** Tagli: basso <= 48,509, alto > 57,951.
  - **Secondarie (stessa ipotesi, quattro conferme possibili):** RSI M5 (53,640 / 61,001), Stoc M15 (40,449 / 72,138), pendenza EMA50 M5 (-0,110 / 0,653), pendenza EMA50 M15 (-0,667 / 0,912).
  - **Attesa nulla (lette gratis):** ADX M5 (18,500 / 26,912), espansione Bollinger (1,012 / 1,417), ADX M15, ADX H1, percentile ATR, ampiezza del canale.
- **Attesa (scritta prima)**: la C035 2024-25 ha n per tranche ~1.300-2.400 (`GBA_R2_REGIME` E2), quindi n_alto e n_basso ~400-800 a tranche. **Delta R poolato (RSI M15) fra -0,10 e +0,04, centro -0,03**; segno positivo in <= 3 tranche su 6. Fondamento: proxy 2021-2025 media -0,023 (anni: -0,072 / +0,014 / -0,067 / -0,027 / +0,039), moltiplicato per 2,4 (fattore di attenuazione del proxy) = ~-0,06; il 2026 stesso (tester) da' +0,110.
- **Smentita (l'ipotesi vive)**: criteri P1-P4 di sez. 6.
- **Limiti dichiarati**: (a) la cella C035 nel 2024-25 e' **FRA o ESCLUSA PER COSTO** (`GBA_R2_REGIME` E6: 7-17x), quindi prova che il meccanismo esiste o no su quella popolazione, **non che valga sulla REPL**; (b) la REPL nel 2024-25 e' quasi vuota (proxy 216 operazioni su 6 tranche): il merito e' NON MISURATO li'; (c) l'orologio dell'oro prima del 2025 [NON MISURATO]: la procedura di allineamento prova 0 / +1 / -1 ora per operazione e dichiara quanti scarti; se gli scarti superano il 25% di una tranche, la tranche e' NON MISURATA; (d) **dipende da R2REG**: oggi il lotto ha il cancello strato 2 in FAIL (commit 14e28ff4, c85ccf7c, citati dal dossier gemello): se non passa, ST0 e' NON MISURATO.
- **Costo**: 0 passate; ~1 ora di analisi (script da archiviare in repo dopo il cancello). **Beneficio**: decide se si pagano ~35 passate e un giorno di codice.

### 4.2 ST1 - Momentum RSI allineato (NUOVO input, richiede codice; condizionato a ST0)
- **Input**: `InpRsiMinAligned` (**double**, **default 0.0 = spento**), `InpMomTF` (**ENUM_TIMEFRAMES**, default `PERIOD_M15`, **pin**, non asse), `InpRsiPeriod` (**int**, default 14, pin). Campo di valori: 0 - 80; **celle 60 e 65**, piu' il neutro 0. Il valore 70 (n=138 in R1A, sospeso) non si prova in scoperta.
- **Regola**: all'apertura di una barra nuova, dopo `GbaDirezione`, leggere l'RSI(14) dell'ultima barra chiusa di `InpMomTF` con `GbaShiftChiusa()` (nessun guardare avanti); BUY richiede RSI >= x, SELL richiede 100 - RSI >= x; altrimenti motivo di rifiuto nuovo `GBA_MOMENTO` con contatore e riga di log. **Neutro**: x = 0 non legge nemmeno l'indicatore (zero differenza di comportamento, handle non creato).
- **Neutralita' da provare**: la cella 0 deve riprodurre n=128 / 248 / 557 e PF 0,83 / 0,77 / 0,89 di R1A (G1).
- **Meccanismo**: la rottura M1 che sorge mentre M15 e' gia' in spinta nella stessa direzione tende a continuare (trailing in profitto 30-32% contro 21-22%, R medio 0,97-1,04 contro 0,73-0,76); la rottura in un M15 neutro o contrario e' piu' spesso un falso. **Verso OPPOSTO al RSI classico** (non e' ipercomprato -> vendi): qui RSI alto = continuazione.
- **Attesa (REPL, 3 tranche, scritta prima)**: **cella 60**: n **340-460**, PF_V **0,90-1,20**; **cella 65**: n **220-320**, PF_V **0,95-1,30**. Fondamento: sottoinsieme post-hoc 1,11 / 1,25 (n=369 / 243); proxy con sequenza 1,067 / 1,275 meno la calibrazione di 0,16 = 0,91 / 1,12; la selezione sugli stessi dati gonfia il sottoinsieme, la sequenza lo sgonfia. Per tranche: T3 > 1,0, **T1 e T2 sotto 1,0 con probabilita' alta** (post-hoc 0,89 / 0,77 a 60). **Nessuna cella oltre 1,3**.
- **Smentita**: PF_V <= 1,03 su n >= 150 in 2 tranche su 3 (S8): rumore del 2026. Se PF_V >= 1,3 su n >= 150 con T1 e T2 anch'esse > 1,1: sorpresa, vale il controesempio di S4 (migliore operazione < 25%, senza le 5 migliori > 0) e scatta subito la validazione.
- **Controesempio costruito prima**: "il filtro vince in T3 e basta" - lo si legge dalla colonna per tranche; "il filtro riduce n del 55-75%": S9, si dichiara selezione se R medio per operazione non sale oltre +0,03 (il tester 2026 dice +0,08 / +0,11).
- **Costo**: codice (`mql5-ea-developer` + `controllo-preventivo` + collaudo) + **6 passate di scoperta** (REPL x 2 celle x 3 tranche ~ 6 min) + **12 passate di validazione** (C035 x 2 celle x T4-T9, ~11 min) + **G0 sul handle**: la prima riga di segnale deve stampare il valore RSI e coincidere con quello ricostruito da HistData entro 3 punti (nel registro: gli handle `iADX`/`iATR` su D1 non popolavano nel tester; su M15 non e' noto).
- **Validazione fuori campione**: (1) ST0 sul 2024-25 PRIMA di tutto; (2) cella C035 con filtro su T4-T9 contro la C035 neutra di R2REG: **lift = PF_V(filtro) - PF_V(neutro) nella stessa tranche**, criterio P1-P3; (3) T0 dal 01/10/2026: a 1,3 operazioni/giorno (cella 65) 150 operazioni arrivano verso **meta' marzo 2027**, a 1,9/giorno (cella 60) verso **meta' gennaio 2027** [DERIVATO, senza festivi]; il rischio si legge subito, il merito aspetta.

### 4.3 ST2 - EMA su TF superiore: M15 (input ESISTENTE, zero codice)
- **Input**: `InpTrendTF` (ENUM_TIMEFRAMES, default `PERIOD_CURRENT` = TF del segnale), `InpEmaPeriod = 100` fisso. **Celle**: `PERIOD_M15` (e, per completezza, `PERIOD_M5`), da aggiungere al file di MR3 (H1, H4, D1) se questo parte: **una variabile, un file**. **Attenzione (dal dossier gemello)**: `InpTrendTF` SOSTITUISCE l'EMA di M1 invece di sommarsi.
- **Meccanismo**: l'EMA100 di M15 (~25 ore di M1) dice da che parte sta il mercato "grande" della sessione; si entra solo con la rottura a favore. E' la versione "media lunga su TF superiore" chiesta dal capo, la meno costosa.
- **Attesa (REPL, 3 tranche)**: n **600-800** (proxy M15: 734 su 1.017 = 72%; M5: 832 = 82%); PF_V **0,78-0,95**, |lift| <= 0,06 (proxy +0,04 M15, +0,06 M5 in 2026; media 2021-25 +0,00 / +0,00). Post-hoc sul tester: distanza dall'EMA M15 / H1 t=+1,9 / +1,8: debole. **Smentita (il TF alto salva il motore)**: PF_V >= 1,15 con n >= 300 in 2 tranche su 3.
- **Costo**: 3 passate per cella (3 per M15, 6 con M5) ~3-6 min. Zero codice, zero cancello sul sorgente. **Valore**: chiude una casella "mai messa ad asse" a costo quasi nullo; l'attesa e' NULLA, e' un risultato.

### 4.4 ST3 - Lato: solo-BUY e solo-SELL (input ESISTENTI, zero codice)
- **Input**: `InpAllowShort` (bool, default `true`) = `false` (solo BUY); `InpAllowLong` = `false` (solo SELL). Un file per variabile.
- **Perche' ha un senso, anche se il dossier gemello dice di lasciarlo a R2REG**: R2REG legge i lati dai deal (sottoinsieme), ma **non misura l'effetto di sequenza** (con solo-BUY gli slot lasciati liberi dai SELL vengono riempiti da BUY che oggi non entrerebbero). La C035 ha SELL <= BUY in 3 tranche su 3 con n >= 1.000 per lato (sez. 0, punto 7): e' il dato piu' solido sulla forma di asimmetria. Costo basso, benefico piccolo.
- **Meccanismo**: l'oro ha deriva positiva e i breakout SELL arrivano piu' spesso su rimbalzi in tendenza al rialzo; ma **in T2 (ribasso, -16%) il SELL non guadagna (0,73-0,78)**: la tesi "ci vuole il lato contro-trend per perdere" non basta. **Non e' un trend-follower** (conferma del dossier gemello).
- **Attesa**: solo-BUY n **420-520**, PF_V **0,84-0,95** (sottoinsieme R1A 0,89 su n=443, R1B 0,89-0,91; proxy lift +0,09 in 2026, +0,05 in media 2021-25); solo-SELL n **470-560**, PF_V **0,72-0,88**. **Smentita**: solo-BUY >= 1,03 su n >= 150 (sorpresa) o solo-SELL >= solo-BUY in 2 tranche su 3 (l'asimmetria e' un artefatto di T3).
- **Caveat**: segno ribaltato nella REPL in T3 (BUY 0,77, SELL 0,93) e in T1 (BUY 2,25, SELL 0,46 su n=51 / 61: sospeso, n < 150). **Un solo regime**; un solo-BUY e' una scommessa sulla deriva, non un edge: lo si tratta come riduzione della zavorra, mai come sedia.
- **Costo**: 6 passate ~6 min. **Se ST1 parte**: la forma giusta dell'asimmetria e' un margine SELL aggiuntivo (`InpShortMomExtra`, default 0.0), non il blocco: da proporre solo se SELL resta indietro anche dentro il filtro (a RSI M15 >= 65 R1A: BUY 1,86 / SELL 1,02).

### 4.5 ST4 - Scala dell'ATR: M5 o M15 (input ESISTENTE, zero codice)
- **Input**: `InpAtrTF` (ENUM_TIMEFRAMES, "[APERTO]" nel sorgente, default `PERIOD_CURRENT`). **Celle**: `PERIOD_M5`, `PERIOD_M15`. Segnale, canale ed EMA restano a M1.
- **Cosa muove, TUTTO insieme (confondimento dichiarato)**: l'ATR e' usato per stop iniziale, trailing, BE **e filtro di spread**. Con ATR M5 (~5,25 USD) lo stop passa da ~5 a ~13 USD e `spread <= 0,05 x ATR` diventa ~0,26 USD (quasi sempre vero): entrano molti piu' segnali. **Il confondimento e' limitato da R1B**: allargare il filtro di spread a M1 da solo lascia PF_V a 0,82-0,83; quindi una differenza oltre 0,82-0,83 e' scala di stop/trailing.
- **Meccanismo**: lo stop 2,5 ATR(M1) ~ 2-6 volte lo spread e' stretto; con la scala del TF superiore il costo pesa 2-4 volte meno (stop/spread ~52x con M5, ~94x con M15 [DERIVATO su proxy, mediana sui segnali, +0,04 di commissione]: **PASSA** la frontiera 40x con TUTTI i segnali, a differenza delle celle larghe a M1 che sono FRA).
- **Attesa**: n **2.300-3.400** a 3 tranche (proxy M5 2.923, M15 3.752, x0,92); PF_V **0,68-0,90** (proxy 0,93 meno la calibrazione di 0,16 = 0,77; la REPL-proxy neutra e' 1,011, quindi la cella e' ~0,08-0,11 peggio nel proxy). **Smentita**: PF_V >= 1,03 su n >= 150.
- **Valore**: e' il solo modo, a costo zero di codice, di avere una cella che PASSA il costo con ~15 operazioni/giorno; ma il proxy dice che il PF non c'e'. Resta una casella aperta ("A1 punto aperto", `GBA_R2_PIANO` sez. 2) che si chiude con 6 passate.
- **Costo**: 6 passate ~6 min.

### 4.6 Proposte con codice, condizionate (NON nei cinque)
| id | input NUOVO (tipo, default neutro) | valori | meccanismo | attesa (scritta prima) | smentita | costo |
|---|---|---|---|---|---|---|
| ST5 Stocastico | `InpStochMinAligned` (double, 0.0 = spento) + K 14, D 3, slow 3 su `InpMomTF` | 70, 80 | come ST1 ma su posizione nel range di 14 barre M15 | REPL: n 300-440 (>=70) / 190-280 (>=80); PF_V 0,90-1,20 / 0,95-1,30 (post-hoc 1,22 / 1,32; proxy 1,09 / 1,45 meno 0,16 = 0,93 / 1,29). Correlazione 0,82 con l'RSI M15: **non aggiunge informazione se ST1 non passa** | PF_V <= 1,03 | codice + 6 + 12 passate; si fa SOLO dopo ST1 e SOLO come variante dello stesso blocco |
| ST6 Pendenza EMA | `InpSlopeMinATR` (double, -99.0 = spento), `InpSlopeTF` (default M5), `InpSlopeEmaPeriod` 50, barre 5 (pin) | 0,5; 0,75 | EMA50 di M5 in pendenza a favore, normalizzata sull'ATR M1 | REPL: n 280-490; PF_V 0,92-1,25 (post-hoc 1,29 / 1,46 su terzili; proxy 1,095 / 1,012) | PF_V <= 1,03 | come ST1; **nota**: proxy a 0,75 ATR e' piu' basso di 0,5 (1,012 contro 1,095): non monotono nel proxy, picco/incertezza |
| ST7 ADX | `InpAdxMin` (double, 0.0 = spento) su `InpMomTF`, ADX(14) | 20, 25 | filtro di forza (coach V57: <20 laterale) | attesa NULLA: |lift| <= 0,05; ADX M5 post-hoc +0,04 R, M15 -0,35 t | PF_V >= 1,10 con n >= 150 | codice + 6 + 12 passate; **si legge gratis in ST0 prima**; priore di casa CRT: il gate ADX non salva a tick |
| ST8 Espansione Bollinger | `InpBbwMaxExp` (double, 0.0 = spento): salta se BBW(20,2)/BBW[10 barre prima] > x | 1,2; 1,4 | evita di entrare con le bande appena aperte | attesa: lift +0,00/+0,05 (post-hoc: segno negativo dell'espansione; un solo lotto su due) | lift <= 0 | codice + passate; **si legge gratis in ST0 prima** |
| ST9 Retest | `InpRetestBars` (int, 0 = ingresso a mercato), `InpRetestDepthATR` (double, 0.25, pin) | 6, 12, 24 | ordine LIMIT sul livello rotto +0,25 ATR dal lato interno, scadenza W barre, nessun nuovo segnale durante l'attesa | REPL: n 820-940; PF_V -0,10 / +0,02 rispetto al neutro (proxy 0,89-1,03 contro 1,01); C035 0,84 | lift >= +0,05 con n >= 150 in 2 tranche su 3 | **codice non banale** (ordine pendente, scadenza, reload-safety) + 9 + 18 passate; la lista dei caduti non ha il GBA, ma R83 dice che e' una duello per mercato |
Tutte: neutro = comportamento identico a oggi, una variabile per file, cella al centro dell'altopiano, mai picco.

---

## 5. TABELLA ORDINATA PER BENEFICIO / COSTO (tutte le ipotesi esaminate)

Beneficio = probabilita' qualitativa che l'esito cambi una decisione x ampiezza (alto/medio/basso), giudicata dai numeri di sez. 3; costo = passate/minuti e lavoro di codice.

| rango | id | cosa | codice | passate | minuti | beneficio | motivo del rango |
|---:|---|---|---|---:|---:|---|---|
| 1 | ST0 | lettura per feature su R2REG (momentum, ADX, BBW, pendenza) | no | 0 | ~0 (1 h di analisi) | **alto** | unico test fuori scoperta a tick reali; decide ST1/ST5/ST6/ST7/ST8 |
| 2 | ST2 | `InpTrendTF` M15 (+M5) | no | 3-6 | 3-6 | basso | casella "mai a asse" chiusa gratis; attesa nulla e' un risultato |
| 3 | ST3 | `InpAllowShort/Long` = false | no | 6 | 6 | basso-medio | chiude "i due lati" con la sequenza vera; asimmetria 3/3 tranche su C035 |
| 4 | ST4 | `InpAtrTF` M5 / M15 | no | 6 | 6 | medio (frequenza e costo, non PF) | unica via a una cella che passa il costo con tanti trade; PF atteso 0,7-0,9 |
| 5 | ST1 | RSI M15 allineato 60 / 65 | **si'** | 6 + 12 | 6 + 11 (+ codice) | **medio-alto, condizionato** | l'unico segnale con t ~4 che sopravvive a 28 letture, ma 2026-specifico e concentrato in T3 |
| 6 | ST5 / ST6 | Stoc M15 / pendenza EMA | si' | 6 + 12 ciascuna | ~17 ciascuna | medio (stessa ipotesi di ST1) | correlati 0,70-0,82 con l'RSI: ripetono, non aggiungono |
| 7 | ST7 | ADX 20 / 25 | si' | 6 + 12 | ~17 | basso | attesa nulla; priore CRT negativo |
| 8 | ST8 | espansione Bollinger | si' | 6 + 12 | ~17 | basso | un solo lotto su due, segno contrario ai coach |
| 9 | ST9 | retest | **si' (non banale)** | 9 + 18 | ~25 | basso | proxy -0,05 a +0,02; R83 dice per-mercato |
| -- | (uscita su momentum) | chiudere se RSI M5 si rovescia | si' | -- | -- | nullo | lift 0,00 / -0,03 nel proxy: **non proposta** |
| -- | (percentile ATR, ampiezza canale, estensione) | filtri di volatilita' puri | si' | -- | -- | nullo | t da -0,5 a +1,4, nessuna forma: **non proposti**; percentile ATR resta in coda nel dossier gemello (MR4) per "misurabilita' tra regimi" |

Nel ranking ho messo ST1 al quinto posto per rapporto beneficio/costo (costa codice) pur essendo la proposta con il beneficio potenziale piu' alto, per il motivo della sez. 0, punti 2-4: **prima si guarda se l'ipotesi replica (ST0, gratis), poi si paga il codice**.

---

## 6. LA PROVA FUORI CAMPIONE: LOTTI, CRITERI CONGELATI, TEMPI

**Partizione dei dati** (dichiarata): 2026 T1-T3 (R1A/R1B) = **lotto di scoperta, contaminato da questo dossier** (le soglie sono nate li'); T4-T9 (R2REG, 2024.07.10-2025.12.31, tick reali) = **validazione**; dal 2026.10.01 = **T0, in avanti**. **Qualunque passata di una cella-filtro su T1-T3 e' in-sample**: serve a calibrare la sequenza e a verificare l'implementazione (la cella e' un sottoinsieme delle operazioni neutre, piu' i rientri), mai come prova.

**Criteri P1-P4 per la primaria di ST0 (RSI M15 allineato; congelati ora)**. Una tranche e' valida se n_alto >= 100 e n_basso >= 100 e gli scarti di allineamento < 25%; altrimenti NON MISURATA.
- **P1** Delta R (alto-basso, R medio per operazione) > 0 in **>= 4 delle tranche valide su 6**;
- **P2** Delta R poolato **>= +0,05** (meta' circa del +0,110 della C035 2026);
- **P3** 5mo percentile del Delta R poolato, bootstrap per giorno (>= 2.000 ricampionamenti, seed fisso), **> 0**;
- **P4** le quattro secondarie (RSI M5, Stoc M15, pendenza M5, pendenza M15) devono avere Delta R poolato > 0 in almeno 3 su 4, e la loro soglia sul percentile e' l'**1%** (non 5%) per tenere conto di 4 letture.
Se P1-P4 passano: **l'ipotesi "il momentum M5-M15 allineato filtra i falsi breakout" sopravvive a un secondo regime (2024-25, toro), a tick reali**; parte ST1 (codice, poi le celle). Se P1 o P3 falliscono: **ipotesi del 2026, nessun codice**. Se passano P2-P3 ma non P1: segnale di regime (concentrato in poche tranche), si scrive cosi' e si rinvia a T0. **Il merito si legge solo sopra le 150 operazioni; il rischio a qualunque n.**
**Il giudizio sul PF resta quello di casa**: nessuna cella-filtro e' "regge" fuori dalla regola per regimi; nel 2026 la parte buona della cella e' < 1 in T1 e T2.

**Perche' non basta il 2026 per promuovere**: Delta R per tranche e' T3-dominato, PF_V del lato "buono" in T1 e T2 resta 0,77-0,94; un criterio "PF_V > 1,0 in ogni regime con >= 150 operazioni" lo boccerebbe oggi. Il filtro *ripulisce*, non crea.

**T0 (dal 01/10/2026)**: lista celle e criteri sopra sono congelati qui. Frequenza attesa per cella: RSI M15 >= 60 ~1,9/giorno, >= 65 ~1,3/giorno (base 4,8/giorno). 150 operazioni: ~metà gennaio 2027 (>=60) e ~meta' marzo 2027 (>=65) [DERIVATO].

---

## 7. COSTO IN TEMPO MACCHINA (PC di backtest `DESKTOP-H4D7CAJ`, mai VPS)

56 s a passata a tick reali [MISURATO in R1B; 43-53 s in R1A]. Lavoro di generalizzazione di driver e lettore (una chiave per file) gia' previsto in `GBA_R2_PIANO` 3.5, non macchina.

| lotto | contenuto | passate | minuti | condizione |
|---|---|---:|---:|---|
| ST0 | lettura R2REG per feature | 0 | 0 | R2REG deve passare il cancello |
| ST2 | `InpTrendTF` M15 (+M5) | 3 (6) | 3 (6) | nessuna |
| ST3 | solo-BUY + solo-SELL | 6 | 6 | nessuna |
| ST4 | `InpAtrTF` M5 + M15 | 6 | 6 | nessuna |
| **incondizionato** | ST2 + ST3 + ST4 | **15-18** | **15-17** | -- |
| ST1 scoperta | RSI REPL 60 / 65 x 3 tranche | 6 | 6 | **ST0 replica (P1-P4)** + codice + cancello |
| ST1 validazione | RSI C035 60 / 65 x T4-T9 | 12 | 11 | idem |
| ST5 / ST6 / ST7 / ST8 (ciascuna) | scoperta + validazione | 18 | 17 | dopo ST1 / su richiesta |
| ST9 retest | 3 celle x 3 tranche + 18 | 27 | 25 | su richiesta, codice non banale |
| **Caso centro (ST0 non replica)** | solo l'incondizionato | **15-18** | **15-17** | -- |
| **Caso pieno (ST0 replica, solo ST1)** | incondizionato + ST1 | **33-36** | **32-34** | -- |
Il lavoro dei due strati di cancello sul codice (`mql5-ea-developer`, collaudo, `controllo-preventivo`) e' stimato in un giorno per ST1 [NON MISURATO].

---

## 8. I CONTRO-ESEMPI COSTRUITI PRIMA DELLA CONSEGNA (due hanno corretto la conclusione)

- **"Il trend lungo (EMA300/1000) e' il filtro vincente"** (prima lettura: t=4,85, PF 1,59 contro 0,41, 3 tranche su 3). **Rotto dal controllo di allineamento**: era un artefatto del disallineamento orario HistData/BCM in marzo 2026 (73% di quelle operazioni con feature sbagliate). Dopo la correzione t=2,10 e PF 1,09 contro 0,60; il vincitore diventa il momentum di M5-M15. **La conclusione precedente e' ritirata.**
- **"L'effetto momentum e' reale perche' sopravvive a 28 feature"** (permutazione, 0/1.000): ridimensionato. La permutazione ignora i giorni; l'effetto e' T3-dominato (sez. 3.3); la replica sulla C035 e' nello STESSO regime. Rimane: IC90 per giorno sopra zero e replica su un set diverso di operazioni.
- **"Il proxy dice che il filtro non replica nel 2021-25"**: provato contro il suo stesso 2026: il proxy riproduce solo il 40% dell'effetto. Lo screening e' dichiarato **debole**, e il verdetto passa a ST0 su tick reali.
- **"Il retest e' la regola dei coach, quindi migliora"**: provato nel proxy e contro R83 (stesso concetto, mercato diverso): non migliora il PF; conferma "duello per mercato".
- **"Solo-BUY toglie la zavorra"**: provato contro T2 (ribasso): il SELL perde anche li' (0,73-0,78), quindi non e' solo deriva; contro T3 della REPL (SELL 0,93 > BUY 0,77): segno non stabile. Ridimensionato a "lift piccolo, positivo 4 anni su 5, PF < 1".
- **Equivalenza "filtro spento = comportamento di oggi"**: provata nel simulatore (n e netto identici a `simula`); nell'EA e' una condizione da verificare con la gemella (G1) e la cella neutra su R1A.
- **"L'uscita su momentum aiuta"**: provata e smentita nel proxy (lift 0 / -0,03).

---

## 9. COSA NON HO VERIFICATO (buchi dichiarati)

1. **Gli script d'analisi non sono in repo** (mandato di commit: solo questo path). Metodo in 3.1; vanno archiviati e passati dal cancello prima che R2REG si legga con la stessa procedura. Nessuno dei miei strumenti e' passato da `controlla_prova.py`/`controllo-preventivo`.
2. **Le feature sono ricalcolate su HistData**, non lette dall'EA: nessun RSI/Stoc/ADX/pendenza e' mai stato letto da MT5. Controllo: allineamento di close / EMA / ATR sul 95-99%, ma gli indicatori su M5/M15/H1 sono calcolati da me sulle M1 aggregate (stesse formule di MT5: Wilder per RSI/ADX, SMA del true range per l'ATR, K stocastico lento a 3), e **non ho verificato i valori contro un indicatore reale del terminale**. Il G0 di ST1 lo fa.
3. **Il proxy e' un simulatore a barre** (niente tick, niente slittamento, spread di settembre 2026 ovunque, ordine peggiore all'interno della barra): ottimista di ~+0,16 PF sulla REPL 2026; riproduce ~40% del Delta R. I numeri [PROXY] sono lift, non PF.
4. **Orologio**: le tranche T8-T7 (ott 2024 - mar 2025) hanno un orologio incerto per l'oro [NON MISURATO]; il mio allineamento per operazione prova 0 / +1 / -1 ora, ma non e' stato provato su un anno con server IT-1.
5. **Un solo regime di scoperta**: gen-set 2026. T3 pesa molto; T1 e T2 sono sotto 150 operazioni per cella-filtro sulla REPL (T1 ~50-90, T2 ~70-170), cioe' **il merito per tranche e' per lo piu' sospeso**.
6. **La C035 nel 2024-25 e' esclusa per costo** (7-17x): ST0 prova il meccanismo su una popolazione che non diventera' mai sedia; non vale come prova per la REPL.
7. **Dipendenze**: R2REG ha il cancello strato 2 in FAIL (dal dossier gemello); `GBA_R0_PASSATE.ps1` v4 accetta solo `InpSpreadMaxATR` come variabile di cella: le righe di ST2/ST3/ST4 richiedono prima la generalizzazione del driver.
8. **Non ho letto i report .htm di R1B oltre la C035**; C010/C020 non sono stati usati.
9. **Valori numerici MQL5 delle costanti di timeframe** (`PERIOD_M15 = 15`, `PERIOD_M5 = 5`, `PERIOD_H1 = 16385`) da far verificare al cancello contro la documentazione prima di scrivere il file prova.
10. **Non ho verificato se le righe di segnale per i segnali SCARTATI** (`SALTATO`) sono stampate a Modello 4 nei giornali di R2REG con lo stesso formato: ST0 usa solo le righe degli ingressi, che sono nel formato verificato su R1A / R1B.
11. **Nessuna probabilita' numerica** di replica: non ho un modo misurato per darla. Le bande di attesa sono scritte prima e sono larghe di proposito.
12. **La cifra "~40% dell'effetto"** viene da UN confronto (RSI M15, Delta R proxy +0,046 contro +0,110): per le altre feature i rapporti vanno da ~0,4 a ~0,6 (stesso ordine); non e' una costante.

---

## 10. COSA SERVE DA CLAUDIO (nessuna spesa)

1. **Il via a ST0** (nessuna passata, nessun codice): serve solo che R2REG passi il cancello e venga eseguito sul PC di backtest `DESKTOP-H4D7CAJ` (decisione gia' sua/del lotto); ST0 si legge dai suoi report.
2. **Il via alle tre prove senza codice** (ST2, ST3, ST4: 15-18 passate, ~17 minuti) quando il driver e' generalizzato: puo' essere dopo R2REG e dopo R2U.
3. **Una firma sul codice di ST1**, ma **solo dopo** che ST0 replica: dire "si'" a priori a un EA che aggiunge un input significa pagare un giorno di sviluppo per un'ipotesi che i dati fuori campione potrebbero spegnere.
4. **Nessun parametro di rischio, taglia o conto toccato.** Il lotto resta 1,00 fisso, nessuna sedia, nessun preset.
