# RESOCONTO CONSOLIDATO DI TUTTI GLI EA - SOPRA 1, SOTTO 1, NON MISURATO - 05/10/2026

> **DOCUMENTO INTERNO. NON ESCE. BOZZA, NON PASSATA DAL CANCELLO** (`controlla_riga.py` + `controllo-preventivo` da fare: niente di questo file va a Claudio ne' al VPS prima di un PASS).
> Nato dalla richiesta di Claudio del 05/10/2026: *"un resoconto di tutti gli EA creati con PF sopra 1 e quelli sotto 1, che backtest, che anni, che tipologie di mercati hanno superato, se migliorabili e cosa serve"*.
>
> **REGOLA FERREA: questo file e' una VISTA dei sette documenti di gruppo, NON una nuova misura.** Nessun numero e' nuovo: ogni cifra e' copiata da un gruppo (G1, G2, G3, G4, G5, G6a, G6b) e la riga dice da quale (colonna "rimando": gruppo + id di riga della tabella del gruppo + scheda). Le etichette (SOPRA / SOTTO / NON MISURATO, NULLO / ZONA GRIGIA / EFFETTO / NON ANCORA MISURATO) e le affidabilita' (A-D) sono **ereditate**: non ho scritto nessun verdetto nuovo, nessun "morto" (serve il certificato a 5 caselle) e nessun "NON CONFRONTABILE / REGIME" dove un gruppo non l'aveva gia' scritto. Dove due gruppi dicono cose diverse **lo dichiaro** (sez. 0.4 e sez. 4).
> Quello che e' mio e non dei gruppi sta in tre posti dichiarati: i **conteggi** (rifatti con uno script che rilegge le tabelle: sez. 0.2 e Appendice A), l'**ordinamento** dei "cosa serve" (sez. 3) e le righe marcate **[CONSOLIDATORE]** (aritmetica su date o numeri dei gruppi, mai una misura).
> **Perimetro**: sola lettura d'archivio. Nessun round lanciato, nessun EA / preset / parametro / taglia / conto toccato, nessun file di altri agenti toccato, VPS non toccato. Forward = solo demo e non classifica; niente challenge o trial nel documento.
>
> **Fonti** (tutte sul branch `lavoro`, HEAD `df54239b`, gia' passate dal cancello di giudizio dei rispettivi agenti; le ultime versioni, con i conteggi e le affidabilita' corretti dai cancelli):
> `report/RESOCONTO_EA_PIANO_2026-10-05.md` (regole e formato) · `..._G1_APERTURE_...` · `..._G2_EMA200_SW_ORB_...` · `..._G3_NOTTE_EVENTI_BULGE_...` · `..._G4_FOREX_AGOSTO_...` · `..._G5_SUPERTREND_GOLDEN_ORO_...` · `..._G6A_CACCE_BREAKOUT_...` · `..._G6B_CACCE_REVERSAL_MEDIE_...` (tutti `report/RESOCONTO_EA_*_2026-10-05.md`). Foglio delle firme richiamato, non ripetuto: `report/FIRME_DA_FARE_2026-10-05.md`.

---

## 0. IN DIECI RIGHE

1. **Perimetro: 116 righe di EA in sette gruppi** (G1 26 · G2 14 · G3 14 · G4 12 · G5 19 · G6a 17 · G6b 14; una riga puo' raggruppare 2-4 file gemelli o copie). Il totale e' stato **rifatto con uno script che rilegge le tabelle dei sette file** (sez. 0.2): coincide con i conteggi dichiarati dai gruppi, gruppo per gruppo.
2. **SOPRA 1**: **59 righe** hanno almeno una cella SOPRA (G1 7 · G2 8 · G3 9 · G4 7 · G5 14 · G6a 9 · G6b 5); **solo 6** hanno **solo** celle SOPRA. "Sopra 1" **non vuol dire buono**: quasi sempre e' una cella con n < 150, o con SEGNO INVERTITO, o indistinguibile da 1 (la soglia D2 di ZONA GRIGIA non e' firmata), o NO PER RISCHIO / ESCLUSA PER COSTO.
3. **SOTTO 1**: **65 righe** hanno almeno una cella SOTTO (G1 8 · G2 9 · G3 10 · G4 8 · G5 12 · G6a 9 · G6b 9); **12** hanno **solo** celle SOTTO. **53 righe stanno in tutte e due le liste**: la regola del piano (la classe e' per CELLA, mai una media) fa si' che quasi ogni EA abbia celle da entrambe le parti. Il numero che conta non e' "quanti EA sopra" ma "quali celle, con che n, in che regime".
4. **NON MISURATO**: **40 righe** (+ **5 EREDITA**: copie e pin che valgono la riga della madre; G1 3, G3 1, G5 1). Dentro il NM c'e' una cosa che pesa: **numeri gia' pagati e non leggibili** (CSV rimasti sul VPS o referti senza CSV): G4 **35 round** (14-20/09), G6a **6 round** (R141e, R145a/b, R148a/bL/bS), G6b **5 round** solo dichiarati. Vedi **sez. 3(a), con la scadenza di calendario (verso il 20/10)**.
5. **Differenza "con screening" / "solo tick"** (la dichiara G6a con due viste affiancate, gli altri gruppi hanno regole diverse: sez. 0.4): su G6a, **9 SOPRA / 9 SOTTO / 8 entrambe / 7 NM** con le celle a barre o esterne, **7 / 8 / 6 / 8** solo con i tick. Applicando la vista "solo tick" a G6a il totale scende da 59/65/53/40 a **57 SOPRA / 64 SOTTO / 51 entrambe / 41 NM** (sez. 0.2).
6. **Affidabilita'**: **A = zero** in tutti e sette i gruppi (nessuna cella ha due regimi misurati uno per uno con n OOS >= 150 posizioni). **B "pulita"** (tick, OOS vero, n >= 150 posizioni, IS dalla stessa parte): i gruppi ne nominano **tre**: `771531` EMA200 U30USD H1 (257 pos), `770101` DAX long (193 pos), il candidato Dow breakout su U30USD (199 pos, "NON ANCORA MISURATO come sedia"). Le altre B che i gruppi citano hanno SEGNO INVERTITO, o n solo in deal, o NO PER RISCHIO / ESCLUSE PER COSTO, o finestra piena senza OOS.
7. **Regimi**: sui tick BCM il regime e' **uno solo** (rialzo dal 26/09/2024 per gli indici, 05/07/2024 per il forex); orso / laterale / crollo sono **NON MISURATO** su tutte le sedie indice. L'unico posto dove i quattro regimi hanno un numero e' un feed **esterno `_EXT`** (finestre dichiarate diverse da gruppo a gruppo, 2011-2024: sez. 2.3) o le barre a n minuscolo (1-67 operazioni): nessuna cella li passa tutti (sez. 2).
8. **Certificato di morte**: **nessun EA intero e' dichiarato MORTO**. Una sola *cella* ha il 5/5 dichiarato (EMA200 oro H4 base, G2, per rischio). I SOTTO sono "sotto 1, non ancora morto" con scritto la casella che manca; alcuni sono "capitolo chiuso con numero" (G3, regola 19/08: Londra e BreakinBox) ma non MORTI.
9. **Cosa serve, in una frase**: prima **trasportare i CSV gia' girati** (zero macchina, ma con una **scadenza: `carica_risultati.ps1` guarda solo gli ultimi 30 giorni**, quindi i CSV del 14-21/09 escono dalla finestra **verso il 20/10**), poi circa quaranta misure da **pochi minuti a ~45 minuti** sul PC di backtest (costi e fonti in sez. 3b, costi dei gruppi), poi le **decisioni di Claudio** (D2, SEGNO INVERTITO, regola screening, ecc.: sez. 3d). L'unica misura che compra *regime* per le sedie vive costa **90-348 ore di calcolo** e una firma.
10. **Lettura d'insieme**: e' un archivio molto piu' ricco di quanto sembri (i gruppi hanno trovato celle sopra 1 nascoste dentro EA dati per "morti", e round gia' girati dati per "mai girati"), ma le sedie schierabili sono ancora pochissime e quasi tutte stanno su **un solo regime e n sotto 150**: la distanza fra "PF sopra 1" e "sedia schierabile" e' tutta li'.

### 0.1 Conteggi per gruppo (righe del piano) - dichiarati dai gruppi, ritrovati dallo script

| gruppo | righe | file (se dichiarati) | entrambe | solo SOPRA | solo SOTTO | solo NM | EREDITA | almeno 1 SOPRA | almeno 1 SOTTO | fonte del conteggio |
|---|---:|---|---:|---:|---:|---:|---:|---:|---:|---|
| G1 aperture, Live5m, DAX M3 | 26 | n.d. | 5 | 2 | 3 | 13 | 3 | 7 (10 con le 3 EREDITA) | 8 (11 con le 3 EREDITA) | G1 sez. 8 |
| G2 EMA200, SuperWave, ORB | 14 | 15 | 8 | 0 | 1 | 5 | 0 | 8 | 9 | G2 sez. 0.1 |
| G3 notte, eventi, Bulge, Londra | 14 | 14 | 8 | 1 | 2 | 2 | 1 | 9 | 10 | G3 sez. 2 (il gruppo scrive "solo NM 3" = 2 + la copia Nightly_Ottimizzato) |
| G4 forex di agosto, Fibo, Corso | 12 | 14 | 7 | 0 | 1 | 4 | 0 | 7 | 8 | G4 sez. 2 |
| G5 SupRev, GoldenCross, oro | 19 | 25 | 12 | 2 | 0 | 4 | 1 | 14 | 12 | G5 sez. 0.4 |
| G6a cacce breakout (vista con screening) | 17 | 17 | 8 | 1 | 1 | 7 | 0 | 9 | 9 | G6a sez. 2 (A) |
| G6a (vista solo tick) | 17 | 17 | 6 | 1 | 2 | 8 | 0 | 7 | 8 | G6a sez. 2 (B) |
| G6b cacce reversal e medie | 14 | 14 | 5 | 0 | 4 | 5 | 0 | 5 | 9 | G6b sez. 2 |
| **TOTALE (G6a con screening)** | **116** | - | **53** | **6** | **12** | **40** | **5** | **59** | **65** | somma (controllo: 53+6+12+40+5 = 116) |
| TOTALE (G6a solo tick) | 116 | - | 51 | 6 | 13 | 41 | 5 | 57 | 64 | idem, con la riga G6a-T |

Celle sottostanti, dove il gruppo le dichiara: **G1 49 celle** = 17 SOPRA + 16 SOTTO + 16 NM (50 righe di tabella, di cui 3 EREDITA) · **G5 111 righe di tabella** = 66 SOPRA + 39 SOTTO + 6 NM (sono gruppi di celle dello stesso round, non 111 celle) · **G6b 203 celle** sotto 33 righe di tabella = 51 SOPRA + 152 SOTTO · G2, G3, G4, G6a: non dichiarano un totale celle. **Le celle dei sette gruppi non si sommano**: hanno unita' diverse (cella, gruppo di celle dello stesso round).

### 0.2 Verifica con script (non a mano)

`conta.py` (riportato in Appendice A) rilegge dai sette file `.md` le tabelle (G1 tab. 1; G2 tab. 0; G3 tab. 1; G4 tab. 1; G5 tab. 0.2 e 0.3; G6a tab. 1.1; G6b tab. 1.1), ricava per ogni riga di EA se ha celle SOPRA / SOTTO / solo NM e **confronta con i conteggi scritti dai gruppi**. Esito: **8 righe su 8 UGUALI** (G1, G2, G3, G4, G5, G6a-A, G6a-T, G6b); **G1 celle 17/16/16 = 49** e **G5 111 = 66+39+6** ritrovate. Un solo intervento manuale, dichiarato nello script: in **G3 la riga 14 (AllineaLondra)** la classe SOPRA e' scritta senza la parola "SOPRA" ("una cella OHLC ~1,01, IS 0,89: SEGNO INVERTITO") e G3 sez. 2 la conta in SOPRA: lo script la tratta come il gruppo. Dove lo script ha dovuto interpretare il testo (G2, G3, G4: classe nella colonna "classe + aff."; G1: prefisso `CONTESA` = NM) la regola e' scritta nello script. Controllo di tenuta: 53 + 6 + 12 + 40 + 5 = 116 righe.

### 0.3 Come leggere la tabella principale (sez. 1)

- **Una riga per EA o famiglia del piano** (116), nell'ordine e con la numerazione del piano (colonna `#` = riga della tabella della sez. 4 del piano). Per ogni riga la **cella SOPRA di riferimento** e' quella che il gruppo indica come cella di contratto o la piu' avanzata (non "la col PF piu' alto": scegliere il picco e' vietato dalla regola di casa: centro dell'altopiano, mai il picco). Dove non esiste nessuna cella SOPRA scrivo "nessuna SOPRA" e metto accanto la cella SOTTO di riferimento (marcata **SOTTO:**).
- **Tipo di dato**: `[T]` tick reali BCM (indici dal 26/09/2024, forex dal 05/07/2024, oro dal 10/07/2024 secondo G3) · `[B]` barre OHLC (screening: non promuove e non boccia, il DD e' un limite inferiore) · `[E]` feed esterno `_EXT` · `[G]` tick generati · `s.OOS` = finestra piena senza OOS · `T?` = tipo non dichiarato dalla fonte · `[DICH]` = numero scritto in un referto, nessun CSV in repo.
- **n**: `pos` = posizioni, `deal` = deal di uscita (colonna `Trades` del tester; con parziale 50% una posizione fa 1-2 deal, fattore 1,00-2,31). Dove la fonte non lo dice, `n` senza unita' e' come nella fonte. **INV** = SEGNO INVERTITO (IS e OOS da parti opposte di 1). **s/SOPRA formale** = PF >= 1,00 ma indistinguibile da 1 (D2 non firmata).
- **Deposito / rischio**: dichiarati accanto al DD quando la fonte li da'; DD a 1% e a 2% non si confrontano.
- **Affidabilita'** (piano 5.4): A = n OOS >= 150 pos + OOS vero + >= 2 regimi; B = n >= 150 ma un solo regime; C = 30-149 (merito sospeso); D = < 30; `C*` = senza OOS (massimo assegnabile C). Dove il gruppo dice "provvisoria (B o C)" per n solo in deal lo riporto.
- **Regimi**: per default "toro" = il rialzo 2024-26 (con la discesa feb-apr 2025 dentro); "NM" = NON MISURATO. Dove un gruppo ha un numero per regime lo riporto (sez. 2 li raccoglie).
- **"Migliorabile?"**: parole dei gruppi (si' / no / non so / non ancora misurabile) + cosa serve in breve; il dettaglio con costi e fonti e' in sez. 3.
- **"Rimando"**: gruppo + id di riga della tabella del gruppo (es. G1 1a-1i = righe 1a...1i della tab. 1 di G1) + scheda.

### 0.4 Dove i gruppi non applicano la stessa regola (dichiarato, non risolto)

| tema | G1 | G2 | G3 | G4 | G5 | G6a | G6b |
|---|---|---|---|---|---|---|---|
| cella a barre `[B]` senza OOS e senza tick: SOPRA/SOTTO o NM? | quasi nessuna cella `[B]` classificata (770250 su `NASUSD_EXT` citata come screening) | conta come SOPRA/SOTTO (con screening) | **NM come merito** (piano 5.3), vale per il rischio | **NM come merito** (piano 5.3), vale per il rischio | **SOPRA/SOTTO con suffisso s.OOS** (D3 applicata) | **due viste affiancate** (A con screening, B solo tick) | SOPRA/SOTTO con "screening" nella classe |
| righe EREDITA (copie, pin, standalone) | 3 righe EREDITA contate in piu' (10/11); le 3 `standalone` NON ereditano (motori diversi, diff 1.484-1.944 righe) | `standalone/` EREDITA, logica non diffata | Nightly_Ottimizzato contata fra i "solo NM" | - | 4 copie EREDITA (riga a parte); GC standalone = v1.00, **non eredita** | nessuna copia | nessuna copia (PointBreak e SuperFilter esistono solo in `standalone/`) |
| SEGNO INVERTITO: dove va? | segnalato | segnalato | **PROPOSTA D20: "NON CONFRONTABILE / REGIME"** (SOPRA G3 da 9 a 6 EA) | segnalato | **PROPOSTA D14** (19 righe su 105; 15 su 66 SOPRA) | segnalato | segnalato (8 righe) |
| unita' n e soglia 150 | `B` provvisoria (B o C) sulle celle in deal | n in deal dove non c'e' il per-trade | D / P dichiarate | motori senza parziale: deal = pos; con parziale la colonna conta deal | forbice deal/2,31..deal; B solo da 346 deal | stessa regola di G5 (346 deal) | deal = pos verificato nel sorgente |
| zona grigia del PF (D2) | "ZONA GRIGIA" usata in 2 celle | "SOPRA formale (indistinguibile da 1)" | idem | idem | idem | idem | idem |

**Conseguenza per i totali**: i numeri 59 / 65 / 40 sono la **somma di sette regole non identiche**. Sono comunque tutti ritrovati dalle tabelle: cio' che non si puo' fare e' leggerli come "59 EA buoni su 116". La **regola di etichetta "con o senza screening"** e **D2** e **SEGNO INVERTITO** sono tre decisioni di Claudio (sez. 3d) che cambierebbero i totali.

---

## 1. TABELLA PRINCIPALE: UNA RIGA PER EA / FAMIGLIA

Colonne: `#` (riga del piano) · EA · ruolo · classe (SOPRA / SOTTO / NM / ENTRAMBE = celle da tutte e due le parti) · **cella SOPRA di riferimento: PF IS / OOS - n - DD** · **backtest: dato - anni - TF - simboli** · **regimi** · aff. · migliorabile? · rimando.

### 1.1 G1 - APERTURE DAX / DOW / NASDAQ, LIVE5M, DAX M3 (26 righe)

Finestra standard G1: tick 2024.09.26 -> 2026.06.30 (~21 mesi); IS ->2025.06.09, OOS 2025.06.10-> per DAX e Dow; Nasdaq: IS ->2025.06.30, OOS 2025.07.01->. **Il TF del grafico e' INERTE per sorgente** sui motori d'apertura (range letto su M1): M5, M15, M30, H1, H4 sono la stessa cella a tick.

| # | EA | ruolo | classe | cella SOPRA di riferimento: PF IS / OOS - n - DD | backtest: dato - anni - TF - simboli | regimi | aff. | migliorabile? | rimando |
|---:|---|---|---|---|---|---|---|---|---|
| 1 | `ABTG_DAX_Apertura_EU` | sedie 770101 long e 770105 short | ENTRAMBE (long SOPRA; short CONTESA -> NM; breakout e RangeMode 1-2 SOTTO) | 770101 long RETEST: PF 1,126 / 1,397 - 132 / 193 pos - DD 5,44 / 7,23% (100k, 1%) | [T] 2024.09.26-2026.06.30 (~21 mesi) - D30EUR M5. Short 770105: 0,965 / 0,957 (R270d) contro 0,846 / 1,065 (R251b), stessa config = **CONTESA**; DD 12,31 / 12,05% = NO PER RISCHIO | toro (un regime). Orso/laterale/crollo NM (storico DAX 2010-2018 scaricato, mai importato). Stagione: estate 1,390 (96) / inverno 0,899 (85) [taglio R251] | B (IS 132 < 150: merito sospeso sull'IS) | long: si' (poco). Short: non ancora misurabile (R252 + riconciliazione 0,957/1,065) | G1 1a-1i; scheda 1 |
| 2 | `ABTG_DAX_Apertura_EU_Ottimizzato` | variante storica (770111, 26/07) | SOPRA (senza OOS) | A2 solo long breakout: PF 1,49 (media 1,25) - 314 tr - DD 3,8% (finestra unica) | [T?] citazione di registro, CSV originale non in repo; 2024.01.01-2026.06.30 dichiarata, tick BCM solo dal 2024.09.26 - D30EUR M5 | toro (un regime) | C* | non ancora misurabile su OOS | G1 2; scheda 2 |
| 3 | `ABTG_DAX_Apertura_EU_Pin9fca` | copia pin `9fca63d9` | EREDITA 1a/1b | - (diff vs pin = 0; vs HEAD +460 righe, tutte del filtro SPAZIO opt-in OFF) | - | - | - | - | G1 3; sez. 5 |
| 4 | `ABTG_DAX_Apertura_EU_TrailFix` | variante di prova non in campo (guardia trailing 25/09) | NM | nessuna (prova di neutralita' mai girata) | - | - | - | si' (girare la neutralita') | G1 4 |
| 5 | `trailfix_9fca63d9/CLAU12_DAX_Apertura_EU.mq5` | variante di prova non in campo | NM | nessuna (soglia equivalente a TrailFix, log diverso) | - | - | - | si' | G1 5 |
| 6 | `standalone/ABTG_DAX_Apertura_EU.mq5` | copia "tutto-in-uno" v1.00 del 26/07 | NM | nessuna (**motore diverso**, non eredita: diff 1.944 righe) | - | - | - | no | G1 6; sez. 5 |
| 7 | `ABTG_Apertura_Marco` | sedia RITIRATA 06/08 (770301) | ENTRAMBE (7a SOPRA, 7b e 7c SOTTO) | 7a D30EUR M5 solo long buf 600: PF 1,244 - n 309 (finestra unica) - DD 4,69% (10k) | [T?] 2024.01.01-2026.06.30 - D30EUR M5. SOTTO: 7b due lati 0,789-0,858; 7c NASUSD M5 22/22 < 1 (0,502-0,842) | toro | C* | no (doppione di 770101, ritirato per rischio doppio) | G1 7a-7c; scheda 7 |
| 8 | `ABTG_Apertura_3Ingressi` | laboratorio R83 | ENTRAMBE | 8a D30EUR M15 RETEST a limite: PF 1,078 / 1,188 - 197 / 311 deal - DD 7,03 / 10,60% (1%) | [T] 21 mesi - D30EUR M15. SOTTO: 8c NASUSD M15 3/3 (OOS 0,873 / 0,624 / 0,978; R84: 9/9 celle OOS negative) | toro | B provvisoria (n in deal) | non ancora misurabile ("il retest vince sul DAX") | G1 8a-8c |
| 9 | `DAX_MASTER_PROP` | esterno (DAXMasterEA v2.0 + 5 protezioni) | NM | nessuna (1,51 dichiarato, esterno - 69 tr - DD 5,45% a 10k: non classifica) | [E,G] DE40 M15 Tickmill demo, 2023-2024, 0% tick reali, solo IS | rialzo | - | non ancora misurabile | G1 9 |
| 10 | `ABTG_Dow_Apertura_US` | sedia 770202 long | ENTRAMBE (10a SOPRA; 10b short e 10c SOTTO) | 10a U30USD M5 long RETEST range 35', filtro EMA H4: PF 1,222 / 1,270 - 56 / 96 pos - DD 5,67 / 4,39% (100k, 1%) | [T] 21 mesi - U30USD M5. SOTTO: short 1,511 / 0,840 su 73 (INV); 10c (SOTTO B) breakout nudo max 0,997 (96 celle) / 1,106-1,214 (143), FADE 0,806, DELAYED max 0,978 | toro; stagione estate 0,886 (84) / inverno 1,493 (68) (orologio G1 aperto) | C | non ancora misurabile (orologio in fase) | G1 10a-10c; scheda 10 |
| 11 | `ABTG_Dow_Apertura_US_Pin9fca` | copia pin | EREDITA 10a | - (diff 0 vs pin e vs HEAD) | - | - | - | - | G1 11 |
| 12 | `ABTG_Dow_Apertura_US_TrailFix` | variante di prova non in campo | NM | nessuna | - | - | - | si' | G1 12 |
| 13 | `trailfix_9fca63d9/CLAU12_Dow_Apertura_US.mq5` | variante di prova non in campo | NM | nessuna | - | - | - | si' | G1 13 |
| 14 | `ABTG_Nasdaq_Apertura_US` | sedie 770260 retest due lati (in campo dal 21/09), 770250 gated short, 770201 breakout SPENTA 18/08 | ENTRAMBE | 14a 770260 NASUSD M5 RETEST: PF 1,221 / 1,215 - 82 / 102 pos - DD 7,31 / 7,86% (80k, 2,00%). In piu' 14k candidato U30USD breakout: PF 1,259 / 1,481 - 157 / 199 pos - DD 7,17 / 6,62% (10k, 1%): NON ANCORA MISURATO come sedia | [T] 21 mesi - NASUSD M5 (770250: M15). SOTTO: 14e breakout 1,241 / 0,859 (INV), 14g short 3,220 / 0,460 (INV). 770250 [B] NASUSD_EXT 2020-2024: 1,84 su 93 (screening, mai tick) | toro; 770250 su feed esterno copre crollo + orso 2022 (screening) | C (14k: B) | si' (14a); 14k: si' | G1 14a-14k; schede 14 |
| 15 | `ABTG_Nasdaq_Apertura_US_Ottimizzato` | variante storica 770211 (spenta 18/08) | SOPRA (senza OOS, rischio rosso) | RangeMode 2: PF 1,34 (finestra piena) - 340 tr - DD 11,6% | [T?] 25/07/2026, finestra piena - NASUSD M5 | toro | C* | no (NO PER RISCHIO; gemella 770201 fa 0,859 in OOS) | G1 15 |
| 16 | `ABTG_Nasdaq_Apertura_US_Pin9fca` | copia pin | EREDITA 14 | - (diff vs HEAD = 22 righe di commenti) | - | - | - | - | G1 16 |
| 17 | `ABTG_Nasdaq_Apertura_US_TrailFix` | variante di prova non in campo | NM | nessuna | - | - | - | si' | G1 17 |
| 18 | `trailfix_9fca63d9/CLAU12_Nasdaq_Apertura_US.mq5` | variante di prova non in campo | NM | nessuna | - | - | - | si' | G1 18 |
| 19 | `esterni/Nasdaq_PreOpen_Breakout_EA.mq5` (+ `.ex5` orfano) | esterno, mai girato | NM | nessuna | .mq5 mai girato; `.ex5` senza sorgente (non misurabile) | - | - | no (ESCLUSO PER COSTO: 13,33x al pavimento duro + fuso cablato) | G1 19 |
| 20 | `standalone/ABTG_Nasdaq_Apertura_US.mq5` | monolite del 26/07 | NM | nessuna (**motore diverso**: diff 1.702 righe) | - | - | - | no | G1 20; sez. 5 |
| 21 | `ABTG_DAX_Live5m` | "morto" tenuto in osservazione | SOTTO | nessuna SOPRA. **SOTTO:** PF 0,935 / 0,857 - 225 / 342 deal - DD 26,07 / 39,74% (@2%) | [T] 2024.01.01-2026.06.30 (parte su tick non reali) - D30EUR M5, candela pre-apertura 5' | toro | B provvisoria | non ancora misurabile (NON ANCORA MORTO: 2/5 caselle) | G1 21; scheda 21 |
| 22 | `ABTG_DAX_Live5m_v2` | "morto" in osservazione | SOTTO | nessuna SOPRA. **SOTTO:** PF 1,006 / 0,925 - 80 / 202 - DD 4,70 / 14,16% (1%) | [T] stessa finestra - D30EUR M5 long-only | toro | C | non ancora misurabile (ESCLUSO PER COSTO M5, 11,5-13,1x < 13,3x) | G1 22 |
| 23 | `ABTG_Nasdaq_Live5m` | 770203, "morto" in osservazione | SOTTO | nessuna SOPRA. **SOTTO:** PF 1,015 / 0,956 - 116 / 175 deal - DD 12,3 / 22,5% (2%) | [T] stessa finestra - NASUSD M5 | toro | B provvisoria | non ancora misurabile (NO PER RISCHIO; ESCLUSO PER COSTO 13,33x; NON ANCORA MORTO) | G1 23 |
| 24 | `ABTG_DAX_M3` | "morto" (osservazione) | NM | nessuna (zero CSV: il "33% combo positive" del piano non e' verificabile) | `.ini` 2024.01.01-2026.06.30, Model=1, mai girato con risultato in repo - D30EUR M3 | - | - | si' (prima corsa a tick con IS/OOS) | G1 24; sez. 3 r.1 |
| 25 | `DAX_M3_Supertrend` | riscrittura v2 esterna | NM | nessuna (nessun CSV, nessun referto) | - | - | - | si' | G1 25 |
| 26 | `standalone/ABTG_DAX_M3, _DAX_Live5m, _Nasdaq_Live5m` | copie del 26/07 | NM | nessuna (diversi dalla root: 131 / 212 / 212 righe di diff) | - | - | - | no | G1 26 |

### 1.2 G2 - EMA200, SUPERWAVE, ORB (14 righe, 15 file)

Finestra standard G2: tick 2024.09.26 -> 2026.06.30, IS fino al 2025.06.09, OOS dal 2025.06.10 (circa 21 mesi, un solo regime), rischio 1% salvo scritto.

| # | EA | ruolo | classe | cella SOPRA di riferimento: PF IS / OOS - n - DD | backtest: dato - anni - TF - simboli | regimi | aff. | migliorabile? | rimando |
|---:|---|---|---|---|---|---|---|---|---|
| 27 | `ABTG_EMA200` | sedia 771531 U30USD H1; gemelli H4 nativi 771511-15 (mai operanti) | ENTRAMBE | **U30USD H1 L+S (771531)**: PF 1,201 / 1,524 - 257 pos OOS (517 deal); IS 132 pos non ricontabile - rischio 7,83% a 1% | [T] 21 mesi - U30USD H1. SOTTO gemelli: D30EUR H1 0,928 / 0,783; NASUSD H1 0,755 / 0,693 (DD OOS 20,97%). Oro H4 base [B]: 0,836 (2017-23) / 1,535 (2024-26) (MISTA, NON CONFRONTABILE, certificato 5/5 per rischio) | solo il rialzo. GBPUSD H4 su 16,5 anni [B]: SEGNO INVERTITO su 4 celle su 4 = REGIME. PF per regime fuori dal rialzo NM | B | si' (rischio, uscita); regime: non ancora misurabile | G2 tab. 0; scheda 1.1 |
| 28 | `ABTG_EMA200_Ottimizzato` | sedia 971501 XAUUSD H4 (firma 23/08: prop NO a nessuna taglia) | ENTRAMBE | XAUUSD H4: PF 0,658 / 1,495 (INV) - 39 / 67 deal - **NO PER RISCHIO: DD 22 anni 45,91% a 1% contro 4,40% promesso** | [T] 21 mesi + [B] 22 anni solo per il rischio. SOTTO: M15 0,675 / 0,868; M20 0,524 / 0,975 | toro oro 2024-26 | C | no (rischio) | G2 tab. 0; scheda 1.2 |
| 29 | `ABTG_EMA200_Multi_BANCO` | copia di banco (mandato 01/10), v0.10 | NM | nessuna | - | - | - | non ancora misurabile | G2 tab. 0; scheda 1.3 |
| 30 | `standalone/ABTG_EMA200.mq5` | copia "tutto-in-uno" | NM (EREDITA) | nessuna (9 input in meno, logica non diffata) | - | - | - | - | G2 tab. 0; scheda 1.4 |
| 31 | `ABTG_SuperWave` | sedia 770531 U30USD H2 (candidata/demo); 770532 GBPUSD H2 SPENTA 24/08 | ENTRAMBE | **U30USD H2 (770531)**: PF 5,571 (n 32) / 1,762 - 50 pos OOS (88 deal) - DD OOS 4,27% (CSV) contro 2,96% (censimento), non riconciliati | [T] 21 mesi - U30USD H2. GBPUSD H2 [B] 6,5 anni PF 0,79, DD 13,4%, 5 anni su 7 negativi. SOTTO: D30EUR H1 max 0,84; NASUSD H1 OOS 0,73-0,84 su 9 celle su 9 | GBPUSD [B]: orso 2022 0,96 (51) - crollo 2020 1,07 (17; anno intero 0,86 su 69) - toro 2021 0,56 (65) - laterale 2019 0,80 (61). U30USD: solo il rialzo | C | non ancora misurabile | G2 tab. 0; scheda 2.1 |
| 32 | `ABTG_SuperWave_DOW_H1_Ottimizzato` | sedia 770511 U30USD H1 | NM (CONTESA); short SOTTO; celle R120 SOPRA (INV) | contratto: PF 1,849 / 1,328 **oppure** 1,482 / 1,243 - n pos NM (forbice 62-143; 143 o 131 deal) - DD 3,91 contro 4,17%. R120 trailing spento: b00 0,903 / 1,187, e00 0,978 / 1,284 (INV) | [T] 21 mesi - U30USD H1. SOTTO: solo short 0,429 su 84 deal (DD 7,53%) | solo il rialzo | C | si' (riconciliare; uscita) | G2 tab. 0; scheda 2.2 |
| 33 | `ABTG_SuperWave_DAX_H4_Ottimizzato` | 770512 D30EUR H4, non in campo | ENTRAMBE | D30EUR H4 L+S: PF 1,285 (n 56, DD 3,32%) finestra piena, nessun OOS | [T] 2024.01-2026.06 nominale - D30EUR H4. SOTTO: TF scan M15-H3 OOS 0,61-0,96 | un regime | C | non ancora misurabile (campione: 0,12 op/g) | G2 tab. 0; scheda 2.3 |
| 34 | `ABTG_SuperWave_EA` | variante A (D30EUR M3, magic 990001) | NM | nessuna (misura d'effetto: confluenza H4/M3 **NULLO 6 celle su 6**, non PF) | confluenza su DAX 2010-18 + oro 2006-20 e 2021-26 [B] | - | - | no | G2 tab. 0; scheda 2.4 |
| 35 | `ABTG_ORB` | "marginale" nativo Nasdaq; sedia 770601 spenta 10/08 | ENTRAMBE | R7a NASUSD M5: PF 0,824 / 1,050 - 355 deal - DD 24,84 / 19,41% (SOPRA solo nominale, IS invertito; NO PER RISCHIO; costo 26,5x) | [T] 21 mesi - NASUSD M5 | toro | B | no | G2 tab. 0; scheda 3.1 |
| 36 | `ABTG_ORB_Ottimizzato` | sedia 770611 U30USD M5 solo long | ENTRAMBE | PF 1,250 / 1,674 (banco 100k) - 71 IS / 119 OOS pos - DD OOS 9,76% (muro 10%; con slippage 1,5 pt > 10%); costo 29,5x | [T] 21 mesi - U30USD M5. SOTTO: short OOS 0,52 (DD 26,4%); NASUSD (R97) 0,84-0,91 (n 135); D30EUR 0,94-1,02; oro 0,87-0,999 | solo il rialzo | C | si' (TF, gemelli, regime) | G2 tab. 0; scheda 3.2 |
| 37 | `ABTG_ORB_Fibo` | "morto" in osservazione | SOTTO | nessuna SOPRA. **SOTTO:** PF 0,803 / 0,851 - 75 deal (OHLC 0,835 / 0,968) | [T] R272 - NASUSD M5 | toro | C | no su questa cella (mancano uscita, gemelli, TF) | G2 tab. 0; scheda 3.3 |
| 38 | `ABTG_Londra_ORB` | "morto" in osservazione, mai in campo | ENTRAMBE | GBPUSD M5 ora 8, `InpMinRangePips`=10 (R258a): PF 1,088 / 1,034 - 156 / 253 deal - DD equity 14,17 / 23,32% (SOPRA nominale; NO PER RISCHIO + ESCLUSA PER COSTO 9,5-15,5x) | [T] GBPUSD/EURUSD M5 ore 7-8-9. SOTTO: a F=0 6 celle su 6 OOS < 1 (GBPUSD 0,74-0,97, EURUSD 0,70-0,91), DD 30-55%. R258 ha misurato l'ora giusta | toro (forex dal 2024-07) | B | no (rischio, costo) | G2 tab. 0; scheda 3.4; G3 4.15 |
| 39 | `ORB_OpeningRange` | esterno semplice | NM | nessuna (nessun CSV in tutta la storia git) | - | - | - | non ancora misurabile | G2 tab. 0; scheda 3.5 |
| 40 | `ORB_DAX_BASE_EA` · `ORB_DAX_PM_EA` | esterni (toolkit webinar 02/03/2026) | NM | nessuna | - | - | - | non ancora misurabile | G2 tab. 0; scheda 3.6 |

### 1.3 G3 - NOTTE, EVENTI, TREND-EMA, BULGE, LONDRA (14 righe)

Convenzioni G3: dati [T] su oro dal 2024.07.10, forex dal 2024.07.05, indici dal 2024.09.26. Le celle `[B]` senza OOS e senza tick sono **NM come merito** (piano 5.3) e valgono solo per il rischio.

| # | EA | ruolo | classe | cella SOPRA di riferimento: PF IS / OOS - n - DD | backtest: dato - anni - TF - simboli | regimi | aff. | migliorabile? | rimando |
|---:|---|---|---|---|---|---|---|---|---|
| 41 | `ABTG_MaxMinNotte` | sedia 770402 XAUUSD H2 (campo, demo); EA generico per i gemelli | ENTRAMBE (+ celle NM) | 1b XAUUSD solo long tick: PF 1,453 (finestra piena, senza OOS) - 93 pos (118 deal) - DD Equity 2,34% (saldo chiuso 1,97%), 0,5% 100k | [T] 2024.07.10-2026.06.30 (2 anni). Barre: 1a due lati [B] 2020.01.01-2026.06.30 PF 1,308 (NM come merito); 1c 22 anni [B] PF 1,096 su 725 pos. SOTTO: D30EUR long max 0,947 (0/41 celle a tick; R261a filtro S&P 0,883 su 72 pos); F40EUR/E50EUR/100GBP max 0,9985 / 0,8398 / 0,6717 | oro [B] 6,5 anni: toro 2020, laterale 2021-22, toro 2023-26; anni negativi 2021 e 2023 (PF per regime NON separato); 22 anni: 11 anni negativi su 23 | C | si' (taglia = firma; serve tick lungo) | G3 1a-1i; scheda 4.1 |
| 42 | `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` | sedia 770411 D30EUR M15 short + filtro S&P | ENTRAMBE | 2a: PF 1,878 / 2,160 - **14 pos** (21 deal) - DD OOS 1,92% (1%); n=14 non decide | [T] 2024.09.26-2026.06.30 (IS ~8,5 mesi, OOS ~12,7) - D30EUR M15. SOTTO ~1: 2b cella d+1 inverno 0,996 (17 pos) | toro; stagione, non regime | D | si' (campione e TF) | G3 2a-2b; scheda 4.2 |
| 43 | `ABTG_MaxMinNotte_DAX_Short_Ottimizzato_MFE` | copia di sola misura (R104) | NM | nessuna (n=29 < 30, non misurabile) | [T] 2024.09.26-2026.08.24, MFE | - | - | no | G3 3; scheda 4.3 |
| 44 | `ABTG_BreakinBox` | candidato chiuso 31/08 | SOPRA (formale, ~1) | gamba A PF 1,007 (416 deal) / gamba B RR 2,0 PF 1,106 (354 deal) - DD 24,1 / 19,7% = **NO PER RISCHIO** (finestra piena, senza OOS) | [T] 2024.09.26-2026.06.30 - D30EUR M15 (referto, CSV non in repo) | toro | B (s.OOS) | no (capitolo chiuso, regola 19/08) | G3 4; scheda 4.4 |
| 45 | `ABTG_Nightly` | candidato (fade notturno) | ENTRAMBE | 5c GBPUSD [B]: OOS 1,040 (IS 0,586) INV - 163 deal - DD IS 22,6% (NO PER RISCHIO) | SOTTO: 5a EURCHF [T] M5/M15 0,814 (IS 0,891) - 85 deal - DD 11,1/15,4%; 5b EURUSD/USDCHF [B] 0,861 / 0,970; 5d sei simboli R259 [B] 5 su 5 validi SOTTO | 1 regime (21 mesi); 7,5 anni non separati per regime | C (n 85-164) / B (AUDUSD, USDJPY n 480-500, ma [B]) | si' (finestra giusta + uscita; D6: giudicato su 21 mesi per errore di copia) | G3 5a-5d; scheda 4.5 |
| 46 | `ABTG_Nightly_Ottimizzato` | copia (439 righe) | EREDITA (= Nightly) | - | - | - | - | - | G3 6; scheda 4.6 |
| 47 | `ABTG_PTE` | sedie 771321 U30USD H1; 771322/771332 GBPUSD H1 (duello); 771323 USDJPY spenta 24/08 | ENTRAMBE | 7a GBPUSD H1 tick: OOS 1,378 (IS 40,98 su 20 deal) - 49 deal = 27 pos. 7c U30USD (771321): 1,171 (IS 1,178) - 40 deal = 23 pos - DD CSV 3,22% (contratto 2,18%) | [T] 2024.07.05-2026.06.30. SOTTO: 7d GBPUSD 13 anni [B] viva 0,972 (DD 17,68%), candidata 1,095 (DD 9,87%); 7e USDJPY 0,935 (INV); oro 0/16 celle | tick 1 regime; USDJPY funziona solo nel laterale (R80); GBPUSD orso 2022 con feed generato 0,75 | D | si' (chiudere la divergenza `_EXT` / nativo) | G3 7a-7f; scheda 4.7 |
| 48 | `ABTG_PTE_Ottimizzato` | variante ottimizzata (R74) | ENTRAMBE | GBPUSD: 14/14 celle sopra 1, PF 1,18-1,98 - n 47-52 deal (celle di griglia, non di contratto) | [T] GBPUSD/USDJPY, [B] U30USD. SOTTO: USDJPY 10/14 sopra (0,86-1,43), U30USD 7/14 (0,77-1,47) | 1 regime | D | si' | G3 8; scheda 4.8 |
| 49 | `ABTG_WOL` | D1 oro/indici (osservazione) | ENTRAMBE | 9b sweep: 3 celle coerenti IS+OOS su 55 coppie (NASUSD H1, NASUSD H2, SPXUSD H8); profitti +5..+190 su 10.000; DD 0,4-1,3% ("profitti da spread") | [T]+[B] 2024.01.01-2026.06.30. 9a D1 default: n 0-19 deal (non si misura) | 1 regime | D | si' | G3 9a-9c; scheda 4.9 |
| 50 | `ABTG_PostNews` | sedie 771201 ECB EURJPY / 771202 FOMC EURUSD / 771203 NFP USDJPY (demo piccolo) | SOTTO (candidati) + 3 sedie NM | nessuna SOPRA. **SOTTO:** ISM EURUSD 0,79 (IS 0,76) - 312 / 234 deal; 13:30 USDJPY 0,90 (IS 0,66) - 253 / 151 deal. Sedie: 4 CSV con Trades=0 = nessun PF | [B] SOLO REGISTRO (CSV non in repo), IS 2010-2015, OOS 2015-2023 | non separati | B-screening | non ancora misurabile (primo PF delle 3 sedie) | G3 10a-10c; scheda 4.10 |
| 51 | `ABTG_Bulge` | "Bulge viola" v5.20, in campo demo | ENTRAMBE | 11b GBPUSD: OOS 1,212 (IS 0,867) INV - 42 deal; 8 cross dollaro 1,096 (IS 0,742) INV - 233 deal | [B] 4 mesi (IS 2026.03.02-04.30, OOS 2026.05.02-06.29) - H1, 22 cross. SOTTO: 11a AMPIA 0,816 (IS 0,871) - 363 / 410 deal - DD 13,7 / 22,8% (0,80%, 10k) | 1 regime; R92BAB e' una riga diagnostica: il merito di una cella NON e' misurato | C-D (scheda 4.11) | si' (M1 lunga sulla cella di campo) | G3 11a-11c; scheda 4.11 |
| 52 | `BULGE_MASTER` | consolidamento esterno di 8 versioni | NM | nessuna | - | - | - | no | G3 12; scheda 4.12 |
| 53 | `ABTG_LondonFx` | contenitore R116, 3 motori | SOTTO | nessuna SOPRA. **SOTTO:** EURUSD 0,843 / 0,898 / 0,923; GBPUSD 0,763 (IS 0,688) - 1.132-2.253 deal - DD 31-61% | [T] 0,65% 100k, IS 2024.07.05-2025.04.21, OOS 2025.04.22-2026.06.30 - EURUSD/GBPUSD M15 | 1 regime | B | no (NO PER RISCHIO; chiuso 2 volte) | G3 13; scheda 4.13 |
| 54 | `ABTG_AllineaLondra` | allineamento 5 medie in Londra (P2 28/08) | ENTRAMBE | una cella OHLC ~1,01 (IS 0,89) INV (SOPRA formale) | SOTTO: tick EURUSD M15 0,70-0,88 (4 celle), 248-930 deal; OHLC 0,68-1,01 | 1 regime | B-C | si', ma prior pessimo | G3 14; scheda 4.14 |

### 1.4 G4 - FOREX "FAMIGLIE DI AGOSTO", FIBO, CORSO-JPY (12 righe, 14 file)

Convenzioni G4: tick forex dal 2024.07.05; WF "40/60" = IS ~8,5 mesi, OOS 2025.06.10-2026.06.30 (un regime); i motori BB, C2C, EZ, GapFill, PunteLarry non hanno parziale (deal = posizioni); FiboH4_Multi e GapContinuation hanno parziale (la colonna `Trades` conta deal). **Shortlist su dati full-period** (R33, R36, R38, R48): l'OOS vale "mezzo punto". Dato `[T nominale]` = modello 4 su finestra che parte prima del tick vero.

| # | EA | ruolo | classe | cella SOPRA di riferimento: PF IS / OOS - n - DD | backtest: dato - anni - TF - simboli | regimi | aff. | migliorabile? | rimando |
|---:|---|---|---|---|---|---|---|---|---|
| 55 | `ABTG_BreakingBand` | sedie 772161 GBPUSD / 772162 EURUSD / 772163 AUDUSD H1 (campo, demo) | ENTRAMBE | 772161 GBPUSD H1 pattern 2: OOS 1,748 (IS 2,736) - 26 pos (IS 13) - DD OOS 3,40-3,48%. EURUSD 3,870 (13 pos); AUDUSD 2,756 (11 pos) | [T] WF 10k/100k, OOS 2025.06.10-2026.06.30. SOTTO: M15 0/3 (GBPUSD 0,743 su n120); M30 0/3 (GBPUSD 1,087 n174 INV, EURUSD 0,882); R102 [B] 27,5 anni GBPUSD 0,897 (n522, DD 23,43%) | R102 [B] nativo (n 1-19): orso 2022 1,436 / 1,498 / 1,068; crollo 0,595 / 163,96 (n=1) / 0,372; toro 2021 0,482 / 0,837 / 1,213; laterale 2019 1,512 / 0,447 / 0,192 (GBPUSD / EURUSD / AUDUSD). Nessuna sedia le passa tutte | D | si' (uscita: round gia' girati, CSV da trasportare) | G4 1a-1j; scheda 4.1 |
| 56 | `ABTG_CostToCost` | sedie 772361 EURJPY H4 (campo); 772362 GBPCAD H4 e 772363 XAGUSD H4 spente 24/08 | ENTRAMBE | EURJPY H4 long: OOS 1,740 (IS 1,026) - 64 pos (IS 48) - DD 9,33% [WF 10k]; r127c 100k: OOS 1,523 (IS 1,177) - 242 pos (IS 153) - DD 12,26% (giornata -8,02%) = NO PER RISCHIO | [B] barre. WF OOS 13,5 mesi; r127c IS 2020.01.08 -> OOS 2026.06.30 - H4. SOTTO: EURJPY short 0,112 (n63); L+S 0,770 (n127); CHFJPY 0,864 / 0,586 / 0,789; GBPCAD 6,5 anni 0,92 (n382, DD 41,5%); XAG 0,70 (DD 16,4%) | [E] EURJPY: crollo-anno 2020 1,693 (67) - toro 2021 1,053 (46) - orso 2022 2,654 (43) - laterale 2019 1,385 (54) - **crollo puro feb-apr 2020 0,025 (23, DD 14,83%)** | C-screening (r127c: B-screening) | si' (uscita R214e/f, mai messi in coda) | G4 2a-2j; scheda 4.2 |
| 57 | `ABTG_EasyTrend` | sedie 772421 CHFJPY / 772422 GBPUSD H1 (campo); 772423 AUDJPY spenta 24/08 | ENTRAMBE | 772422 GBPUSD L+S TP1,5: OOS 1,492 (IS 1,258) - 41 pos (IS 26) - DD 4,58%. CHFJPY 1,248 (53 pos, DD 6,27%); AUDJPY 1,370 (54 pos) | [T] WF IS 2024.09.26 -> OOS 2026.06.30 - H1. SOTTO: EURGBP 0/16 (0,617-0,969); 6,5 anni [B] PF 1,01-1,07 con DD 15,8-21,8%; famiglia BOCCIATA in portafoglio (R49) | [E]: nessuno dei 3 tiene l'orso (0,930-0,993) ne' il crollo (0,391 / 0,732 / 0,963) | C | si' (TF H2/H4 mai provati) | G4 3a-3h; scheda 4.3 |
| 58 | `EasyTrend_EURUSD` | esterno H1 (replica del corso) | NM | nessuna (SOLO PROSA, `docs/Portafoglio_Strategie.md`: tick 2024-07->2026 PF 1,04, +319 EUR, DD 16%, 74 trade; OOS 2015-2024 PF 0,999 su 152) | nessun CSV / referto in repo | - | - | si' (recuperare il report originale: costo zero) | G4 3i; scheda 4.4 |
| 59 | `ABTG_GapFill` | sedie 772231-33 forex H1; 772234 U30USD e 772235 225JPY (sospese 25/09) | ENTRAMBE | WF OOS: AUDUSD fill100 2,890 (n12), GBPUSD fill100 5,026 (n8), EURUSD fill50 2,740 (n9); U30USD 1,301 (n20); 225JPY 1,137 (n15) | [T] WF, OOS 2025.06.10-2026.06.30 - H1. SOTTO: 225JPY fill50 0,752, fill100 0,760; U30USD fill50 0,694, fill75 0,959; 6,5 anni [B] 0 operazioni 2020-2023 | **9 finestre su 10 a Trades=0, 1 con n=1**: prova di regime non avvenuta | D | si' (campione; round d'uscita gia' girati, CSV non in repo) | G4 4a-4e; scheda 4.5 |
| 60 | `ABTG_GapContinuation` | sedia 774101 225JPY M1 (sospesa 25/09) | ENTRAMBE | cella gap1,00/OR15/TP_R3: OOS 1,398 - 70 deal (pos 30-70, unita' non riconciliata) - DD 11,59% (100k, 1%): **NO PER RISCHIO a 1%** | [T] 1 passata OOS 2025.06.10-2026.06.30, IS tick NM - M1. Griglia OHLC 54 celle: OOS 53/54 SOPRA, IS 42/54 SOTTO (INV); gap oltre 1,00 SOTTO (1,75 0,913; 2,00 0,694); lato short -2.182 (20 pos) | 1 regime | C | si' (per-trade per chiudere n) | G4 5a-5d; scheda 4.6 |
| 61 | `ABTG_PunteLarry` | sedie 772341 U30USD (sospesa 25/09), 772342 EURAUD, 772343 XAUUSD, 772344 GBPJPY, 772345 GBPUSD, 772346 EURCAD H1 | ENTRAMBE | 772341 U30USD L+S: OOS 1,784 (IS 1,724) - 38 pos (IS 16) - DD 3,87%. EURAUD 1,741 (33 pos) | [T] WF 10k/100k. SOTTO: GBPJPY short 0,108; XAUUSD short 0,890; NZDCAD short 0,680; 6,5 anni [B] EURAUD 1,05 (DD 17,1%); XAU DD 22 anni 29,74% @1% | [E]: GBPUSD toro 2,023 (19) - orso 1,783 (12) - laterale 0,336 (16) - crollo-anno 0,346 (20); oro toro 3,030 (11) - laterale 4,963 (7) - crollo-anno 3,474 (8) - orso 0,716 (2) (campioni 1-20) | C (U30USD, EURAUD); D le altre | si' (taglia XAU = firma) | G4 6a-6i; scheda 4.7 |
| 62 | `ABTG_FiboH4_Multi` | candidato multi-simbolo H4 (771602), mai in campo | ENTRAMBE | basket GBPUSD;USDJPY;EURUSD Lookback 8: OOS 1,092-1,094 (n82 deal) e 1,281 (n70, file XAUUSD); IS 0,56-0,70 su tutte (INV) | [B] 10k, 11-12 agosto. SOTTO: Lookback 12 OOS 0,819, 16 0,699; GBPUSD singolo 1999-2026 OOS 0,942-0,972 (n725-737 deal, DD 17,2-17,7%) | non separati | C-screening / B-screening | no su GBPUSD singolo (NO PER RISCHIO); NON ANCORA MORTO (certificato 2/5) | G4 7a-7b; scheda 4.8 |
| 63 | `ABTG_FiboH4_Corso` | candidato fedele al corso | NM | nessuna (mai girato, R93 criteri scritti) | - | - | - | si' | G4 7c; scheda 4.9 |
| 64 | `standalone/ABTG_FiboH4.mq5` (esiste SOLO li') e `standalone/ABTG_FiboH4_Multi.mq5` | copie "tutto-in-uno" | NM | nessuna (come FiboH4_Multi: nessuna misura valida) | - | - | - | no | G4 7d; scheda 4.10 |
| 65 | `ABTG_BreakoutCorso` | laboratorio, ex-sedia BREAKOUT_JPY spenta (R82, 18/08) | SOTTO | nessuna SOPRA. **SOTTO:** OOS 0,769-0,980 su 7 cross su 7 (USDJPY 0,884, EURJPY 0,902, GBPJPY 0,980, AUDJPY 0,839, CHFJPY 0,769, CADJPY 0,831, NZDJPY 0,817); EURJPY IS 1,112 (n895) -> OOS 0,902 (INV) - OOS 1.467-2.138 deal | [B] 10k 1%, 2007.02.12-2026.06.30, taglio IS/OOS 2014.11.13 - M15, 7 cross JPY | non separati | B-screening | no (TF M30/H1/H4 mai provati) | G4 8a; scheda 4.11 |
| 66 | `BREAKOUT_EA_JPY` · `BREAKOUT_EA_JPY_Multi` (+ `_v3` senza sorgente) | esterni v2.3/v2.4 | NM | nessuna (SOLO PROSA: paniere 7 cross JPY 2022-24 -20.853 EUR, PF 0,67-0,95 su tutte, DD 30-48%; indizio SOTTO) | - | - | - | no | G4 8b; scheda 4.12 |

### 1.5 G5 - SUPERTREND REVERSAL, GOLDENCROSS, ORO ESTERNI (19 righe, 25 file)

Convenzioni G5: n = **deal** (famiglia con parziale 50%, nessun per-trade: fattore deal/posizioni NM); aff. in posizioni con forbice (B solo da 346 deal). I TF-scan dell'oro `_Ottimizzato` e `_Multi_Ottimizzato` sono a **rischio 2%** nei CSV (CLASSIFICA_PF dice 1%). I PF "~2,74 / ~3,17" dei nativi sono **NON RIPRODOTTI** (sez. 4). Le "mediane TF" del censimento 09/09 non sono celle.

| # | EA | ruolo | classe (celle SOPRA / SOTTO / NM) | cella SOPRA di riferimento: PF IS / OOS - n - DD | backtest: dato - anni - TF - simboli | regimi | aff. | migliorabile? | rimando |
|---:|---|---|---|---|---|---|---|---|---|
| 67 | `ABTG_SupertrendReversal` | sedie 770922 XAG / 770923 DAX / 770924 Nikkei H4 / 770925 NASUSD H1 (nativa); 770901 collisione | ENTRAMBE (15 / 14 / 1) | NASUSD H1 L+S (770925): PF 1,079 / 1,387 - 53 / 85 deal - DD 1,2 / 0,7% | [T] 2024.09.26-2026.06.30 - H1/H4. SOTTO: oro H4 default 0,337 / 0,765 (il "nativo ~2,74" NON e' questa cella); D30EUR H4 [B] 4,606 / 0,843; GBPJPY H4 St 4,0 SOPRA ma crinale su una riga | solo il rialzo | C | si' (misure mancanti, non parametri) | G5 0.2 riga 1; S01-S30; scheda 1.1 |
| 68 | `ABTG_SupertrendReversal_Ottimizzato` | sedia 970901 XAUUSD H4 (rischio 2% nel CSV) | ENTRAMBE (5 / 1 / 0) | oro H4 L+S: PF 4,752 / 2,253 - 22 / 30 deal - DD 0,79 / 2,08% (PICCO: vicini H3/H6/H2 sotto 1) | [T] 2024.09.26-2026.06.30; oro 22 anni [B]: IS 2004-13 sotto 1, OOS 2013-26 sopra (INV). Il 2,74 e' NON RIPRODOTTO | solo il rialzo oro 2024-26 | D | si' (G0 oro + zip R99) | G5 0.2 riga 2; U01-U06; scheda 1.2 |
| 69 | `ABTG_SupertrendReversal_Multi` | sedia 771001 XAUUSD H4 (nativa, 1%) | ENTRAMBE (1 / 2 / 0); la cella di contratto e' SOTTO | cella SOPRA: M02 oro tick H3 PF 3,536 / 1,692 (n 15 / 30 deal); cella di contratto (SOTTO): oro H4 L+S default 0,709 / 0,686 - 15 / 14 deal | [T] 2024.09.26-2026.06.30 - TF scan | - | D | si', ma l'Ottimizzata e' il suo sostituto (casella 3 vuota) | G5 0.2 riga 3; M01-M03; scheda 1.3 |
| 70 | `ABTG_SupertrendReversal_Multi_Ottimizzato` | sedia 971001 XAUUSD H4 ("TOP" 3,17 bt; rischio 2% nel CSV) | ENTRAMBE (6 / 2 / 0) | oro H4 L+S: PF 4,506 / 2,907 - 33 / 49 deal - DD 3,15 / 4,50% (PICCO) | [T] 2024.09.26-2026.06.30. **DD 22 anni 16,90% a 1%: NO PER RISCHIO a 1%** | solo il rialzo oro 2024-26 | D-C | si' (ma rischio) | G5 0.2 riga 4; O01-O08; scheda 1.4 |
| 71 | `ABTG_SupRev_DAX_H4_Ottimizzato` | sedia 970912 D30EUR H4 (in campo sul piccolo, 0 operazioni) | ENTRAMBE (4 / 2 / 0) | D30EUR H4 L+S: PF 4,302 / 1,525 - 26 / 60 deal - DD OOS 4,2% (R110: 3,808 / 1,432 su 31 / 65) | [T] 21 mesi. Griglia finestra piena 1,96 (86, DD 5,74); costo H4 NON MISURATO (27,8-184x) | solo il rialzo | D-C | si' (campione: non prima del 2027) | G5 0.2 riga 5; X01-X06; scheda 1.5 |
| 72 | `ABTG_SupRev_NAS_H1_Ottimizzato` | sedia 970913 NASUSD H1 (in campo sul piccolo) | ENTRAMBE (9 / 4 / 0) | NASUSD H1 L+S: PF 1,342 / 1,688 - 69 / 86 deal - DD OOS 0,86-1,29% (3 binari, 3 cifre, tutte sopra 1: R110 1,386 / 1,581; R127a 1,298 / 1,613) | [T] 21 mesi. SOTTO: M30 e H3 sotto, StMult 2,5 e 4,0 SOTTO; **ESCLUSO PER COSTO 28,7x** | tick: solo il rialzo. [B][E] 2011-2022: laterale 2015-16 0,664 (55) SOTTO; vecchia 2011-12 1,152 (94); toro 2021 2,187 (8) / crollo-anno 2020 2,604 (5); orso 2022 0,958 (7) / crollo 0,396 (3) | C | **si': e' la cella di G5 piu' vicina a una sedia** | G5 0.2 riga 6; Y01-Y13; scheda 1.6 |
| 73 | `ABTG_SupRev_DOW_H1_Ottimizzato` | 970916 U30USD H1 (SPENTA 12/08), osservazione | ENTRAMBE (5 / 3 / 0) | U30USD H1 L+S: PF 0,923 / 1,436 (INV) - 118 / 155 deal - DD 6,3 / 4,8% | [T] 21 mesi. Griglia finestra piena 1,20 (273), DD 9,77. PICCO su 2 assi su 3; H1 costo FRAGILE 33,6-45,2x | solo il rialzo | C | no, non senza una tesi nuova | G5 0.2 riga 7; D01-D08; scheda 1.7 |
| 74 | `ABTG_SupRev_DOW_H4_Ottimizzato` | 970914 U30USD H4 (promozione REVOCATA 30/07) | ENTRAMBE (3 / 2 / 1) | U30USD H4 L+S: PF 3,651 / 2,324 - 30 / 49 deal - DD 3,6 / 2,7% | [T] 21 mesi. Il "0,79" della revoca e' NON RIPRODOTTO | solo il rialzo | D-C | si' (campione H4 non esiste) | G5 0.2 riga 8; W01-W06; scheda 1.8 |
| 75 | `ABTG_SupRev_CAC_H4_Ottimizzato` | 970915 F40EUR H4 (promozione REVOCATA 30/07) | ENTRAMBE (2 / 1 / 0) | F40EUR H4 (2,5/9/2,5): PFbest 1,794 - 65 - DD 3,48 (finestra piena, senza OOS); PFmed 8 celle 0,958 | [T] finestra piena. Split OHLC [B] 0,976 / 2,404 (INV) | - | C | si' (split a tick: 54 passate, ~5 min) | G5 0.2 riga 9; C01-C03; scheda 1.9 |
| 76 | `ABTG_SupRev_DAX_H1_Ottimizzato` | 970911 D30EUR H1 (SPENTA 11/08, IS rosso) | ENTRAMBE (3 / 2 / 0) | D30EUR H1 L+S: PF 0,730 / 1,866 (INV) - 67 / 156 deal - DD 5,5 / 4,5% | [T] 21 mesi. Griglia finestra piena 1,45 (223) | solo il rialzo | C | no (la decisione di Claudio resta) | G5 0.2 riga 10; V01-V05; scheda 1.10 |
| 77 | `ABTG_SupertrendInvert` | 770801 XAUUSD H1 (osservazione) | NM (0 / 0 / 1) | nessuna ("non opera": n 0-3 per cella su 20 serie) | [T]/[B] 225JPY, D30EUR, EURUSD, GBPJPY, NASUSD, U30USD, USDJPY, XAGUSD, XAUUSD, M15-H4 | - | - | si' (diagnosi a costo ~0) | G5 0.2 riga 11; I01; scheda 1.11 |
| 78 | `ABTG_GoldenCross` | sedie 770331-33 USDCHF / USDCAD / NZDUSD H4 (v1.00 in campo); 770301 oro H1 | ENTRAMBE (7 / 4 / 0) | USDCHF H4 v1.00: PF 3,628 / 2,188 - 20 / 17 deal - DD OOS 2,34% (R87a-V1; la v2.00 corretta e' piu' debole) | [T] da 2024.07.05 - H4. Sweep 31/07 96 celle x 8 simboli; EURJPY 72/72 SOTTO | solo il rialzo | D | si', ma e' una decisione di Claudio (ricompilare v2.00) | G5 0.2 riga 12; G01-G11; scheda 2.1 |
| 79 | `ABTG_GoldenCross_Ottimizzato` | sedia 970301 XAUUSD H1 | ENTRAMBE (4 / 2 / 0) | oro H1: PF 1,494 / 1,253 - 32 / 57 deal - DD 2,28 / 6,08% (ADX 20/25 OOS sotto 1) | [T] 21 mesi. **DD 22 anni 25,18% a 1% [B]: NO PER RISCHIO a 1%** | solo il rialzo oro | D-C | si' (rischio) | G5 0.2 riga 13; H01-H06; scheda 2.2 |
| 80 | `ABTG_GoldenCross_V1` | v1.00 congelata = versione IN CAMPO delle 4 sedie | SOPRA (1 / 0 / 0) | oro: PF 1,494 / 1,253 - 32 / 57 deal (4 simboli congelati) | [T] da 2024.07.05 | - | D | no (non va in campo di nuovo: firma R87) | G5 0.2 riga 14; V1-01; scheda 2.3 |
| 81 | 4 copie `standalone/` (GoldenCross, SupertrendReversal, _Multi, SupertrendInvert) | copie del 26/07 | EREDITA | nessuna (input in meno: GC -12, ST -5; GC standalone = v1.00, non eredita la root) | - | - | - | - | G5 0.2 riga 15; scheda 3.1 |
| 82 | `Gold_Ichimoku_TK_ATR_EA` | esterno (Pine v3), sedia FANTASMA 250604 rimossa a giugno | SOPRA (1 / 0 / 0) | XAUUSD H1 long-only: PF 1,311 su 553 (nessuno split) - DD equity 21,52% a 0,5% = **NO PER RISCHIO** | [B] 2020.01.01-2026.06.30, 100k 0,5% (R103) | 4 anni su 7 negativi (2021, 2022, 2024, 2026p) | B | no (rischio) | G5 0.2 riga 16; E-01; scheda 3.2 |
| 83 | `Gold_Scalper_TK_BB_BE_EA` | esterno oro M5 | NM | nessuna (sorgente: "v1.10 apriva 1174 trade/anno e perdeva" DICHIARATO) | - | - | - | non ancora misurabile | G5 0.2 riga 17; E-02; scheda 3.3 |
| 84 | `IchiCross_Gold_722` · `IchiTrend_Gold_Base` | esterni oro M5 | NM | nessuna ("PF 1,50, 198 trade, 5 anni" nel commento del sorgente = DICHIARATO, non entra) | - | - | - | non ancora misurabile | G5 0.2 riga 18; E-03; scheda 3.4 |
| 85 | `ORB_GOLD_FIBONACCI_EA` · `_v3.21` · `GoldBreakout_Levels` | esterni oro | NM | nessuna (nessun CSV; la v2.20 e' commentata "Risk=5%") | - | - | - | non ancora misurabile | G5 0.2 riga 19; E-04; scheda 3.5 |

### 1.6 G6a - CACCE WEB "BREAKOUT / STRUTTURA / VOLATILITA' / SESSIONE" (17 righe, nessuna sedia)

Convenzioni G6a: due viste affiancate, **A** (con le celle screening `[B]/[E]`) e **T** (solo tick). Finestra standard: tick indici 2024.09.26 -> 2026.06.30, IS 2024.09.26-2025.06.09 (183 feriali), OOS 2025.06.10-2026.06.30 (276 feriali). **Caveat orologio per tutti i 17**: i round usano ore server da estate; quota di giorni "inverno" IS 49,2% USA / 60,1% EU contro OOS 32,6% / 39,9% [DERIVATO dal gruppo]. Nessun forward demo per nessuno dei 17.

| # | EA | ruolo | classe A / T | cella SOPRA di riferimento: PF IS / OOS - n - DD | backtest: dato - anni - TF - simboli | regimi | aff. | migliorabile? | rimando |
|---:|---|---|---|---|---|---|---|---|---|
| 86 | `ABTG_CRT_TurtleSoup` | candidata (769100) | ENTRAMBE / SOTTO | A: `_EXT` M15 13/30 celle PF >= 1, cella robusta 1,18 (320 deal, DD 5,9%) [screening, DICH]. T: **SOTTO** meno peggio dei 30 0,656 / 0,726 (222 / 276 deal); gated 0,459 (s.OOS, n 1460) | [T] 2024.09.26-2026.06.30 + [E] `NASUSD_EXT` 2020-2024 - NASUSD M15 | [E] screening 2020-2024 mai a tick; nel toro a tick 0/30 | C (gated B) | non so (serve tick del regime di range: spesa = firma) | G6a C01-C04; scheda 4.1 |
| 87 | `ABTG_IBRetest` | candidata scartata dal cancello C0 (772900) | SOTTO / SOTTO | nessuna SOPRA. **SOTTO:** U30USD M30 0,382 / 0,697 (42 / 53); NASUSD 0,563 / 0,593 (35 / 49); D30EUR 1,211 / 0,965 (58 / 107, INV); famiglia 0,7798 su n 344 | [T] 10k 2024.09.26-2026.06.30 - M30 | toro | C | si', senza griglia (1 manopola); certificato 3/5 | G6a I01-I04; scheda 4.2 |
| 88 | `ABTG_LVNArbitro` | candidata (769900) | SOPRA / SOPRA | U30USD M30: PF 0,979 / 1,051 (INV) - 392 / 618 - DD 18,01 / 11,33% (10k) = **NO PER RISCHIO** | [T] 10k e 100k 2024.09.26-2026.06.30 - M30 | toro | B | non so (tesi nuova) | G6a L01-L02; scheda 4.3 |
| 89 | `ABTG_OpeningReversalB` | candidata (769400) | NM / NM | nessuna (IS PF 1,826 su n 2 = rumore; OOS 0 operazioni su 11 passate) | [T] 10k - U30USD M5 | - | D | non so (serve una tesi sui timeout) | G6a O01; scheda 4.4 |
| 90 | `ABTG_OutOfNoise` | candidata (7677xx) | NM / NM | nessuna (n=0 anche dopo il fix v1.01) | [T] 100k - NASUSD M15 | - | - | si' (diagnostica v1.02 mai girata) | G6a N01; scheda 4.5 |
| 91 | `ABTG_NySessionRetest` | candidata con preset demo (769501/769502), non attaccata | ENTRAMBE / ENTRAMBE | U30USD M15 slope 75: PF 1,374 / 1,427 (finestra unica, nessun OOS) - 115 deal (~85 pos) - DD 3,7%; nudo sl5 1,002 su 462 pos | [T] s.OOS 100k 2024.09.26-2026.06.30 - M15. SOTTO: sl7 0,95; slope 30 sl5 0,99 | toro | C (nudo e slope 15: B s.OOS) | si' (campione; gemello NASUSD) | G6a Y01-Y05; scheda 4.6 |
| 92 | `ABTG_DaxReEntry` | candidata (769300) | ENTRAMBE / ENTRAMBE | D30EUR M5 long break 20/40: PF 1,159 / 1,69-1,80 (finestra unica) - 92 / 57 - DD 4,6 / 2,5-2,9% | [T] s.OOS 2024.09.26-2026.06.30 - M5. SOTTO: short 0,38-0,54 | toro | C | si' (M1 scritto, mai girato) | G6a D01-D03; scheda 4.7 |
| 93 | `ABTG_DaxValueArea` | candidata (784105); metodo di Claudio | NM / NM | nessuna (R141e GIRATO, 5 notti, CSV non in repo) | [T] 100k - D30EUR M15 | - | - | si' (leggere i CSV: 0 min) | G6a V01; scheda 4.8 |
| 94 | `ABTG_HVAncora` | candidata (784104) | ENTRAMBE / ENTRAMBE | U30USD M30 k=1,0: PF 1,385 / 1,921 - 22 / 31 - DD 3,42 / 2,06% | [T] 100k 2024.09.26-2026.06.30 - M30. SOTTO: k=2,5 1,361 / 0,930 (INV) | toro | C-D | si' (meccanismo, non parametri) | G6a H01-H04; scheda 4.9 |
| 95 | `ABTG_AtrExhaustVol` | candidata (774412-774462 / 784103) | ENTRAMBE / ENTRAMBE | NASUSD M30 `InpProxMode` 1 (ATR): PF 0,972 / 1,229 (INV) - 70 / 96 - DD 5,69 / 4,14% | [T] 100k - M30. SOTTO: PERC 0,711 / 0,952 (153 / 224, DD 19,25 / 13,45%: NO PER RISCHIO); R109 6 celle M15 finestra unica 0,831-0,978 (n 655-927, DD 44,1-67,8%) | toro | C (PERC: B) | si' (gemello + uscita); certificato 4/5 | G6a A01-A03; scheda 4.10 |
| 96 | `ABTG_IntradayMomentum` | candidata (784101/784102) | ENTRAMBE / ENTRAMBE | NASUSD M30 L+S (R141a): PF 0,609 / 1,243 (INV) - 146 / 261 - DD 7,76 / 3,03% (100k, 0,65%); U30USD 0,599 / 1,035 | [T] 2024.09.26-2026.06.30 - M30 (TF inerte). SOTTO: R98 M5 `a` 1,22 / 0,80 | toro | B (OOS) / C (IS) | si' (D30EUR + orologio); **NON ANCORA MISURATO** | G6a M01-M08; scheda 4.11 |
| 97 | `ABTG_LiquiditySweep` | candidata/laboratorio (772603/772604, 779502) | ENTRAMBE / ENTRAMBE | GBPUSD M15 nudo (R89a): PF 0,232 / 1,057 - 14 / 24 - DD 7,74 / 5,87% | [T] 2024.07.05-... GBPUSD M15. SOTTO: R95 EURJPY [B] 2015.07.01-2026.06.30 0,65-0,80 (0/30), n 149-3641 | - | D (tick) | non so (tesi nuova) | G6a S01-S03; scheda 4.12 |
| 98 | `ABTG_FvgRetest` | candidata (775501), mai girata | NM / NM | nessuna (il "DD 42,9%" e' ritirato) | mai girato | - | - | si' (1 passo 0, file pronti) | G6a F01; scheda 4.13 |
| 99 | `ABTG_ImpulsoApertura` | candidata (769800), mai girata | NM / NM | nessuna | mai girato (R140a/b scritti, non in coda) | - | - | si' (2 file prova pronti) | G6a P01; scheda 4.14 |
| 100 | `ABTG_VolExpBreak` | candidata (775301) | NM / NM | nessuna in repo (R145a/b GIRATI, 7 notti, CSV non in repo) | [T] 100k - NASUSD e U30USD M30 | - | - | si' (leggere i CSV: 0 min) | G6a W01; scheda 4.15 |
| 101 | `ABTG_CanaleLento` | candidata "vivaio" (774301) | ENTRAMBE / NM | XAUUSD D1 `ExitMiddle`=1 [B]: IS 0/10 sopra 1 (0,843-0,987) / OOS 10/10 (1,113-2,017) - n 44-112 / 66-164 - DD 8,2-10,2% / 5,6-14,6% (screening, INV) | [B] 100k 1%, IS 2009.07.16-2016.04.27, OOS 2016.04.28-2026.06.30 - D1. `ExitMiddle`=0: cella del metodo 20/20/0 IS 1,123 (n 49) -> OOS 0,976 (n 86) | 17 anni di oro D1 [B], regimi non separati | screening | no senza tesi nuova (certificato 3/5, casella 5 non applicabile) | G6a K01-K02; scheda 4.16 |
| 102 | `ABTG_Cycle` | candidata (775701) | NM / NM | nessuna in repo (R148a/bL/bS GIRATI, 6 notti, CSV non in repo) | [T] 100k - NASUSD M30 | - | - | si' (leggere i CSV: 0 min) | G6a X01; scheda 4.17 |

### 1.7 G6b - CACCE WEB "REVERSAL / MEAN-REVERSION / STAGIONALI" e "MEDIE / OSCILLATORI / COPPIE / SCALPER" (14 righe, nessuna sedia)

Convenzioni G6b: `[MIS]` letto da CSV in repo e ricalcolato dal gruppo; `[DICH]` referto senza CSV; nessun EA ha parziale attivo nelle celle misurate (deal = posizioni, verificato nel sorgente); nessun "MORTO" scritto. Certificato a 5 caselle indicato come "k/5" dove il gruppo lo dichiara.

| # | EA | ruolo | classe | cella SOPRA di riferimento: PF IS / OOS - n - DD | backtest: dato - anni - TF - simboli | regimi | aff. | migliorabile? | rimando |
|---:|---|---|---|---|---|---|---|---|---|
| 103 | `ABTG_VwapRevert` | candidato (773400), passo 0 del 03/09 | SOTTO (0 / 4 / 0) | nessuna SOPRA. **SOTTO:** D30EUR M15 nudo PF 1,00 / 0,73 - 58 / 107 - DD OOS 24,38% (4 celle su 4; S0 non passa 4/4) | [T] [DICH] 100k 1% - M15 | toro | C | non so (M30/H1 mai provati) | G6b W01-W04; scheda 4.1 |
| 104 | `ABTG_MeanRevert` | candidato (773101), "famiglia chiusa" da R60 | SOTTO (0 / 6) | nessuna SOPRA. **SOTTO:** GBPUSD H1 6 celle Lookback 50-300: IS 0,837-0,946 / OOS 0,823-0,986 - n 120-774 / 185-1.160 - DD OOS 19,6-37,0% (12/12 passate PF < 1) | [B] screening, 11,5 anni - H1 | non separati | B-screening | no su GBPUSD H1; altri simboli/TF mai misurati | G6b M01; scheda 4.2 |
| 105 | `ABTG_TurnaroundTuesday` | candidato (774201), "famiglia chiusa" da R63 | SOTTO (0 / 24) | nessuna SOPRA. **SOTTO:** GBPUSD H1 24 celle: IS max 1,005 / OOS max 0,914 (n 333 / 497) - DD OOS 27,2-56,8% (0/24 OOS) | [B] screening, 16 anni - H1 | non separati | B-screening | non so (mai misurato fuori da GBPUSD) | G6b T01-T02; scheda 4.3 |
| 106 | `ABTG_InvEsaurimento` | candidato con contratto firmato 30/08 (769000, 769020) | ENTRAMBE (2 / 1) | NASUSD_EXT M15 E3 (finestra intera): PF 1,16 - n 215 - DD 8,16% (baseline 1,00 su 323). SOTTO: E1 0,95 (n 68, DD 9,93%) | [B][E] [DICH] feed esterno 2017-2020, nessuno split - M15 | 6 regimi nominati sul solo E3 (n 2-59, coprono 100 operazioni su 215): toro 2017 -5.604 (n 59), Q4-2018 +2.946 (n 18) | B-screening (s.OOS) | si' (tesi 'conferma' + gate di regime) | G6b I01-I03; scheda 4.4 |
| 107 | `standalone/ABTG_PointBreak.mq5` (esiste SOLO li') | candidato mai misurato (771101) | NM | nessuna (il "R60 12/12" e' di MeanRevert, non suo; nessun OnTester) | - | - | - | non so (serve decidere cosa misurare) | G6b 1.1 riga 10; scheda 4.5 |
| 108 | `standalone/ABTG_SuperFilter.mq5` (esiste SOLO li') | candidato mai misurato (771801) | NM | nessuna ("0 su 5" e' un precedente di famiglia, non una misura) | - | - | - | non so | G6b 1.1 riga 11; scheda 4.6 |
| 109 | `ABTG_CrossEma` | candidato (772500), mai schierato | ENTRAMBE (5 / 3) | K03 XAUUSD H1 filtro EMA200: PF 1,107 / 1,183 - 84 / 119 pos - DD 10,92 / 12,30% (unica cella con IS e OOS >= 1 e DD <= 15% in entrambe) | [T nominale] XAU (profondita' tick NON VERIFICATA), [T] D30EUR - H1. SOTTO: D30EUR cella A 0,948 / 0,924, cella D 0,844 / 0,973; 7 celle su 8 con DD > 15% in almeno una finestra | toro (21 mesi) | B-C | si', una cella: TF + gemelli + uscita | G6b K01-K08; scheda 4.7 |
| 110 | `ABTG_CrossEmaApertura` | candidato (779600), bocciato da R96 (23/08) | ENTRAMBE (1 / 3) | NASUSD M5 cella B (controllo orario, non promuovibile per firma): PF 1,06 / 1,00 - 256 / 410 - DD OOS 19,10% | [T] [DICH] referto, CSV assente - M5. SOTTO: cella A U30USD 0,96 / 0,92 (440 / 661, DD 35,50%); NASUSD 0,99 / 0,99 (437 / 643, DD 35,40%) | toro | B | non so; priorita' bassa | G6b P01-P04; scheda 4.8 |
| 111 | `ABTG_ChaosLyapunov` | candidato (769200), "tesi falsificata" 31/08 | ENTRAMBE (42 / 65 celle) | NASUSD_EXT M15 gate +0,09: PF medio 1,33; gated 1,789 (n 71, DD 8,78%) contro nudo 1,150 (n 395, DD 21,01%) | [B][E] [DICH] finestra unica 2020.01.01-2024.01.01 (nessuno split) - M15 | non separati | C (gate) / B-screening (nudo) | non so (rientra solo su un motore diverso) | G6b H01-H03; scheda 4.9 |
| 112 | `ABTG_AltaVelocita` | candidato (771401), "capitolo chiuso" 11/08 | SOTTO (0 / 45 celle) | nessuna SOPRA. **SOTTO:** GBPUSD v1 tick IS 0,625-0,821 / OOS 0,542-0,637 (n OOS 132-256) - DD OOS 18,8-37,5%; 7 simboli OHLC OOS 0,192-0,943 (DD fino a 50,5%) | [T] GBPUSD v1; [B] gli altri 7 simboli - 0/45 celle OOS >= 1 | un regime | B-C | no allo stato | G6b V01-V06; scheda 4.10 |
| 113 | `ABTG_HARSI` | candidato ("scan da fare" dal 02/08), EURUSD M5 | NM | nessuna (scan mai girato; ora ha OnTester, manca il file prova) | - | - | - | non so (spread EURUSD M5 non misurato) | G6b 1.1 riga 12; scheda 4.11 |
| 114 | `HARSI_Assistant` | strumento / trade-assistant manuale | NM | nessuna (non misurabile cosi' com'e': AutoTradeSignals=false, nessun OnTester) | - | - | - | no (strumento) | G6b 1.1 riga 13; scheda 4.12 |
| 115 | `ABTG_Relativo` | candidato (774601 D30EUR / 774602 NASUSD) | ENTRAMBE (1 / 1) | NASUSD M5 (metro U30USD) N=40 / sigma 1,35 / SL 2,75 ATR (R117): PF 0,754 / 1,189 (INV) - 87 / 154 - DD OOS 8,40% (E OOS +0,063 R in zona morta) | [T] [DICH] registro, CSV assente - M5. SOTTO: D30EUR 0,452 (DD 25,01%) | toro | B (MERITO SOSPESO: n IS 87) | si' (campione: SPXUSD + R117BIS) | G6b L01-L02; scheda 4.13 |
| 116 | `ABTG_ScalperDirezionale` | strumento di demo manuale (conto 50503635), v1.07 | NM | nessuna (non e' una strategia; CSV per-ondata non in repo) | - | - | - | no | G6b 1.1 riga 14; scheda 4.14 |

---

## 2. PER TIPOLOGIA DI MERCATO E PER REGIME

Il piano (5.7) fa leggere "tipologie di mercato" in **due modi**; qui li tengo separati.

### 2.1 Per classe di strumento (dove le celle sono SOPRA, secondo i gruppi)

| classe | dove ci sono celle SOPRA (righe della sez. 1) | dove NO / limite |
|---|---|---|
| **Indici USA e UE** (U30USD, NASUSD, D30EUR, F40EUR, 225JPY) | aperture DAX long (1, 2, 7, 8), Dow long (10), Nasdaq (14, 15), EMA200 U30USD H1 (27), SuperWave U30USD (31, 32), ORB U30USD (36), MaxMin DAX short (42), BreakinBox (44), SupRev su U30USD/NASUSD/D30EUR/F40EUR (68-76), GapFill/GapCont indici (59, 60), Larry U30USD (61), cacce G6a/G6b su indici (86, 88, 91, 92, 94-96, 110, 115) | gemelli indice dell'EMA200 SOTTO (D30EUR H1 0,783, NASUSD H1 0,693: riga 27); Live5m (21-23) SOTTO; tutte "un solo regime"; costo (frontiera `stop >= 40 x spread`): ESCLUSO PER COSTO nelle righe 22, 23, 72 (28,7x); costo 29,5x nella riga 36; FRAGILE nelle righe 1 e 14 (14k) |
| **Oro (XAUUSD)** | MaxMin solo long tick (41), EMA200 oro H4 OOS 1,495-1,535 (27, 28: IS invertito), SupRev oro H4 (68-70), GoldenCross oro H1 (78-80), Larry XAU long (61), CrossEma oro H1 (109, `[T nominale]`), Gold_Ichimoku [B] (82), CanaleLento [B] (101) | EMA200 oro H4: **NO PER RISCHIO** (DD 22 anni 45,91% a 1%, riga 28); SupRev Multi_Ott DD 22 anni 16,90% e GoldenCross Ott 25,18% a 1% (righe 70, 79); Gold_Ichimoku DD 21,52% a 0,5% (riga 82); profondita' tick XAUUSD non verificata (G6b-3) |
| **Forex** | BreakingBand, EasyTrend, Larry, GapFill WF a n 8-53 (55, 57, 59, 61); CostToCost EURJPY [B] (56); GoldenCross H4 (78); PTE tick n 20-27 pos (47); Bulge solo celle INV (51) | BB M15/M30 SOTTO (55); BreakoutCorso 7/7 OOS < 1 (65); LondonFx, AllineaLondra, Londra_ORB (38, 53, 54) SOTTO / NO PER RISCHIO; EZ EURGBP 0/16 (57); Larry GBPJPY short 0,108 (61) |
| **Argento (XAGUSD)** | SupRev H4 (G5 S06: 7,134 / 2,047 con IS su n=4) e CostToCost WF (SEGNO INVERTITO, G4 2h) | SupRev M15-H12: 8 TF su 8 SOTTO (G5 S07); CostToCost 6,5 anni 0,70 (G4 2h); le sedie 770922 (preset FW long-only) e 772363 (spenta 24/08) |
| **Energia / altri CFD** | GapFill WF su F40EUR, UKOIL, USOIL, SPXUSD: SOPRA con IS rosso (G4 4c, SEGNO INVERTITO) | "panchina regime", n 15-21 (D) |

### 2.2 Per regime: i NUMERI che esistono (e basta)

Regola dei gruppi: **un regime non misurato si scrive NON MISURATO, mai stimato**. L'unico posto dove i quattro regimi (toro / orso / laterale / crollo) hanno un numero e' un feed **esterno `_EXT`** (2019-2022) o le **barre a n minuscolo**. Su tick BCM il regime e' **uno solo** (il rialzo).

| EA / cella | dato | laterale 2019 | crollo (2020) | toro 2021 | orso 2022 | fonte |
|---|---|---|---|---|---|---|
| SuperWave GBPUSD H2 (riga 31) | [B] 6,5 anni | 0,80 (61) | 1,07 (17); anno intero 0,86 su 69 | 0,56 (65) | 0,96 (51) | G2 tab. 0, scheda 2.1 |
| CostToCost EURJPY H4 (riga 56) | [E] 100k 1% | 1,385 (54) | crollo-anno 1,693 (67); **crollo puro feb-apr 2020 0,025 (23, DD 14,83%)** | 1,053 (46) | 2,654 (43; giornata -10,07%) | G4 2c |
| CostToCost GBPCAD H4 (riga 56) | [E] | 0,852 (58) | crollo-anno 0,966 (63); crollo 0,497 (16) | 1,238 (61) | 0,611 (48) | G4 2g |
| EasyTrend GBPUSD (riga 57) | [E] 100k | 1,538 (35) | crollo-anno 0,763 (35); crollo 0,391 (10) | 1,014 (34) | 0,993 (32) | G4 3h |
| EasyTrend CHFJPY (riga 57) | [E] | - | crollo-anno 0,720 (40) | 1,166 (49) | 0,978 (30) | G4 3h |
| EasyTrend AUDJPY (riga 57) | [E] | 0,608 (44) | crollo-anno 0,988 (41) | 1,276 (44) | 0,930 (35) | G4 3h |
| BreakingBand GBPUSD / EURUSD / AUDUSD (riga 55) | [B] nativo (R102), n 1-19 | 1,512 (15) / 0,447 (10) / 0,192 (5) | 0,595 (7) / 163,96 (n=1) / 0,372 (3) | 0,482 (19) / 0,837 (9) / 1,213 (9) | 1,436 (9) / 1,498 (6) / 1,068 (7) | G4 scheda 4.1 §4 |
| BreakingBand GBPUSD / EURUSD (riga 55) | [E] R59 | 1,263 (12) / 0,369 (9) | crollo 0,998 (6); crollo-anno 1,030 (19) / 1,629 (4) | 0,971 (18) / 0,603 (9) | 0,928 (8) / 1,633 (7) | G4 scheda 4.1 §4 |
| PunteLarry GBPUSD (riga 61) | [E] R50/R59 | 0,336 (16) | crollo-anno 0,346 (20) | 2,023 (19) | 1,783 (12) | G4 6i |
| PunteLarry oro (riga 61) | [E] | 4,963 (7) | crollo-anno 3,474 (8) | 3,030 (11) | 0,716 (2) | G4 6i |
| GapFill EURUSD / GBPUSD (riga 59) | [E] R50/R59 | **9 finestre su 10 a Trades=0, 1 con n=1**: prova di regime non avvenuta | | | | G4 4e, sez. 7 |
| SupRev NASUSD H1 (riga 72) | [B][E] `NASUSD_EXT` | 0,664 (55) laterale 2015-16 | 2,604 (5) crollo-anno 2020; 0,396 (3) crollo 2020-02..04 | 2,187 (8) | 0,958 (7) | G5 Y09-Y12; vecchia 2011-12: 1,152 (94) |
| SupRev oro H4, 22 anni (riga 68) | [B] r127b, split ~2013.04 | IS 2004-2013 (toro dell'oro): **7/7 celle sotto 1** (0,792-0,855); OOS 2013-2026: **7/7 sopra** (1,053-1,125) | | | | G5 U05, D14 |
| EMA200 oro H4 (riga 27) | [B] R264d | IS 2017-23 0,836 contro OOS 2024-26 1,535: PF per regime NM; NON CONFRONTABILE | | | | G2 tab. 0 |
| EMA200 GBPUSD H4, 16,5 anni (riga 27) | [B] 2010-2026 | AUDJPY 0,78-0,81 / 0,95-1,01; GBPUSD 0,80-0,84 / 1,13: SEGNO INVERTITO su 4 celle su 4 = REGIME | | | | G2 tab. 0 |
| MaxMinNotte oro (riga 41) | [B] 6,5 anni / 22 anni | per anno, non per regime: toro 2020, laterale 2021-22, toro 2023-26; anni negativi 2021 e 2023; su 22 anni 11 anni negativi su 23 | | | | G3 1a, 1c |
| InvEsaurimento E3 (riga 106) | [B][E] 2017-2020, s.OOS | 6 regimi nominati sul solo E3, **n 2-59: coprono 100 operazioni su 215**; toro 2017 -5.604 (n 59), Q4-2018 +2.946 (n 18) | | | | G6b I03, G6b-8 |
| PTE (riga 47) | tick + [E] | USDJPY funziona solo nel laterale (R80); GBPUSD orso 2022 con feed generato 0,75; segno invertito col feed (R80: 4 cambi su 4, G4) | | | | G3 7a, 7b; G4 sez. 0 |

**Lettura onesta** (dei gruppi, G4 sez. 2 punto 4): nessuna sedia passa tutti i regimi; "passa" solo dove n <= 1. Il crollo puro (feb-apr 2020) e' **negativo** su CostToCost EURJPY (0,025, `_EXT`), EasyTrend GBPUSD (0,391) / CHFJPY (0,732) (`_EXT`), BreakingBand GBPUSD (0,595) / AUDUSD (0,372) (nativo R102), Larry GBPUSD (0,288, `_EXT`); i valori 0,732 e 0,288 sono nel testo di G4 e non nella sua tabella 1.

### 2.3 Il buco: dove i regimi esistono solo su feed `_EXT` o non esistono

- **Indici BCM a tick (le sedie su indice citate dai gruppi - 770101, 770105, 770202, 770260, 770250, 771531, 770511, 770611, 770411, 970913 - e le cacce G6a/G6b)**: un regime solo (rialzo con discesa feb-apr 2025). Orso / laterale / crollo = **NON MISURATO**. G1: "storico DAX 2010-2018 scaricato (HistData, 1,72 M barre M1), mai importato"; Nasdaq 2010-2026 a barre **usato, fra le aperture, solo da 770250**; **Dow: 0 byte oltre la validazione** (piano Dukascopy 90-348 ore, P0 fatto, P1 in attesa della mossa di Claudio: `FIRME_DA_FARE`).
- **Feed `_EXT`** (finestre dichiarate dai gruppi: 2018-2024 per i forex in G4; `NASUSD_EXT` 2011-2022 in G5, 2017-2020 in G6b per InvEsaurimento, 2020-2024 in G6a e G6b per CRT e Chaos; **non ho verificato se sono lo stesso feed**): i regimi 2019-2022 vivono **solo qui**, ma il feed **cambia anche il segno** (R80: 4 cambi su 4, G4 sez. 0), e per SupRev NASUSD H1 G5 segnala che il motore fa 13,3 op/anno su `_EXT` contro 77 sul nativo ("feed o epoca?": R113 coda, ~2 min). Il regime sul Nasdaq puo' essere un artefatto del feed.
- **Forex nativo BCM**: tick dal 05/07/2024; storico lungo a barre da 1999 per BB, EZ, Larry (R102/R103/R160-R171) ma **i CSV dei round d'uscita a 1999-2026 sono tra i 35 non in repo** (sez. 3a).
- **Oro**: tick dal 10/07/2024 (G3); **profondita' tick XAUUSD non verificata** (G6b-3: blocca la regola F6 sulle 4 celle oro di CrossEma, `[T nominale]`); PF per regime dell'oro 22 anni **non in repo** (zip R99/R100 fuori: G5 D21).
- **Prove di regime pronte ma non girate** (richiamo, non ripeto): tre specifiche (Nasdaq/S&P, DAX, Dow) + la regola unica **R-0** nel foglio `FIRME_DA_FARE`. Il foglio dice: sul **DAX** la regola tiene **3 finestre avverse distinte**; sul **Nasdaq 3 etichette avverse ma 2 episodi distinti**; con le firme obbligatorie la colonna "anni/dati" del dossier per Emiliano va da 10 NO / 2 PARZIALE / 0 SI a 6 NO / 6 PARZIALE / 0 SI (mai SI).

---

## 3. COSA SERVE, AGGREGATO E ORDINATO PER COSTO / VALORE

> **Separazione richiesta da Claudio: DECISIONI sue vs LAVORO nostro.**
> **LAVORO nostro** (nessuna firma sul contenuto, ma ogni riga e ogni script passa dai due cancelli prima di uscire): (a) trasporto dei CSV gia' girati, (b) misure a pochi minuti sul PC di backtest, (c) misure a zero macchina, (e) scrivere i lettori / convertitori / file prova che oggi non esistono. Nota: "lanciare un round" sul PC di backtest richiede comunque **via libera di Claudio per il lancio** (regola del 21/09) e **mai sul VPS** finche' una challenge e' viva.
> **DECISIONI di Claudio**: (d), piu' le firme del foglio `FIRME_DA_FARE_2026-10-05.md` (richiamate, non ripetute).
> **Avvertenza sui costi** (G6a R13, G6a-7): le stime dei documenti di caccia sono risultate **~2,5x sottostimate** sul banco VPS (R141a-e: 5,16 min stimati contro 13,2 misurati) e la velocita' del PC di backtest e' **non misurata**: tutte le stime "~N min" qui sotto sono **dei gruppi**, non mie, e vanno moltiplicate per 2-3 per pianificare.

### 3(a) PRIMA DI TUTTO, E CON UNA SCADENZA DI CALENDARIO: portare nel repo i CSV gia' girati

> ## 🔴 SCADENZA: VERSO IL 20/10/2026 (stima G6a) - FINESTRA DI 30 GIORNI DI `carica_risultati.ps1`
> `backtest_pipeline/carica_risultati.ps1` r.31 (`$GiorniIndietro = 30`) e r.111-112 (`$vivi = ... LastWriteTime -ge $soglia`) **scartano in silenzio i CSV piu' vecchi di 30 giorni** (riga di console: "NON guardati, piu' vecchi di 30 giorni"). Riletto da me sullo script il 05/10: la riga c'e' (r.31, r.111-112, r.210). I CSV dei round del runner sono stati scritti il **14-21/09**: **escono dalla finestra verso il 20-21/10/2026** `[STIMA G6a]`. Dopo quella data serve **alzare la variabile** (modifica di script = passa dal cancello) oppure copiarli a mano. **E' un'urgenza di calendario, non di macchina: costo 0 minuti di tester, ma ~15 giorni di tempo (da oggi 05/10).**
> **[CONSOLIDATORE]** (aritmetica sulle date dei gruppi, non una misura): G4 dichiara i 35 round "14-20/09" ma **non la data dell'ultima scrittura per singolo round**; se un file fosse stato riscritto l'ultima volta prima del 20/09 uscirebbe prima. Proposta (non decisione): portare tutto **entro ~13/10**, una settimana di margine.
> **[CONSOLIDATORE]** I 5 round di G6b (corse di agosto / inizio settembre: R96 23/08, INVES 30/08, CHAOS 31/08, passo 0 VwapRevert 03/09, R117 ~04/09) hanno **oggi gia' piu' di 30 giorni**: se i CSV esistono ancora, la riga standard li salterebbe gia' adesso; G6b stesso dice che zip e per-trade non sono in repo e li colloca sul PC di backtest `[INFERITO]` (non sul VPS dei round del runner). Dove stanno davvero e' **da verificare** prima di scrivere la riga.

| gruppo | round da trasportare | quanti | dove / quando | cosa sblocca | costo macchina | fonte |
|---|---|---:|---|---|---|---|
| **G4** | **BB** R161a-c, R174a, R176a, R177a · **GapFill** R157a, R159a, R167a-d, R168a-d, R175a, R178a · **Larry** R156a, R160a-e, R169a-f · **EZ** R171a-b · **C2C** (SL buffer) R146a, R146c · **GapCont** R162a | **35** | runner notturno, banco `50504400`, **14-20/09**; uscita 0 (3 round), 3 (14), 2 (18); CSV sul VPS, mai arrivati nel repo | **casella 3 del certificato (uscita)** per 6 EA e **storico lungo [B] con IS/OOS 1999-2026** per BB, EZ, Larry. Per i round a uscita 2 la presenza di operazioni e' **NON VERIFICATA** (17 su 18; R162a verificato: 9 righe, tutte Trades > 0) | **0 min** (i round sono costati 70-817 s l'uno sul banco) | G4 §3-bis, sez. 5 m.1, G4-12 |
| **G6a** | **R141e** (DaxValueArea) · **R145a, R145b** (VolExpBreak) · **R148a, R148bL, R148bS** (Cycle) | **6** | runner, 5-7 notti ciascuno, tutte uscita 0 (**37 esecuzioni**); CSV sul VPS | trasforma **3 EA NM su 7** (`DaxValueArea`, `VolExpBreak`, `Cycle`) in numeri. All'arrivo: controllare che IS e OOS di ogni round abbiano **la stessa data** e **8 righe** (il giro del 21/09 senza referto potrebbe aver lasciato una coppia mezza riscritta, G6a-1) | **0 min** | G6a sez. 5 m.1, 3-bis, G6a-1 |
| **G6b** | **passo 0 VwapRevert** (03/09) · **R96** CrossEmaApertura (23/08) · **INVES** InvEsaurimento (30/08, zip + per-trade E3) · **CHAOS + CHAOSABL** ChaosLyapunov (31/08) · **R117** Relativo (~04/09) | **5** | **solo dichiarati**: referti con PF/n/DD, CSV mai nel repo (non sono round del runner) | chiude le caselle 1-2 con un CSV per 5 EA; attribuisce le **115 operazioni** di InvEsaurimento E3 fuori da ogni regime; sblocca F6 sulle celle oro di CrossEma | **0 min** | G6b sez. 5 m.1, 3-bis, G6b-4, G6b-8 |
| | **totale: 35 + 6 + 5 = 46 sigle di round** | 46 | | | 0 min | |

**Chi lo fa e con che firma** (G4 m.1, G6a m.1, G6b m.1): per G4 e G6a una riga su una **finestra PowerShell sul VPS** (`carica_risultati.ps1`), **nessun terminale MT5 toccato**; per G6b una **sola copia dal PC di backtest** dove le corse di agosto sono nate (`[INFERITO]` dal gruppo). Ogni riga va fatta passare da `controlla_riga.py` e da `controllo-preventivo` **prima** di mandarla, con il bersaglio dichiarato per esteso (finestra PowerShell sul VPS oppure sul PC di backtest: mai "il VPS" e basta). G6a aggiunge che il **perimetro del runner resta sola lettura**: serve una firma. **Non scrivo nessuna riga qui.**

**Altri numeri gia' pagati e non in repo** (stesso difetto, **senza** la finestra dei 30 giorni dei round del runner):

| gruppo | cosa | stato | fonte |
|---|---|---|---|
| G1 | **R252** (short DAX in fase, 24 passate) | **zip mai tornato** (5-8 min dichiarati); serve lo zip sul Desktop di `DESKTOP-H4D7CAJ` | G1 §7 m.1, scheda 1 §11 |
| G1 | R274, R280, PRV_DAXAP_04, R214a-d, R215a, R231a, R275, R183, R180 | **nessun CSV in repo**; scritti, non girati (o girati e non tornati: R252) | G1 sez. 6 |
| G2 | CSV R234 | non in repo | G2 sez. 6 |
| G3 | BreakinBox, LondonFx, AllineaLondra, candidati PostNews (4 CSV), R17, forward | solo referti `[SOLO REGISTRO]`, nessun CSV in repo | G3 sez. 7, D22 |
| G5 | R110 lati, R236/R238, R99/R100 (zip fuori), R120a/c/d, A1 SUPREV_DOW_H1, G1PAOLO_*, R124a, R132a/b, R163a, R166a, R190c, R237a/b, PASSATA_STOP_SUPREV | numeri solo nei referti o stato di esecuzione `[NON VERIFICATO]` | G5 D19, D21 |
| G6a | R98, R95, R235, R109 (tabelle OPTFRAME), P0 CRT / NY / DaxReEntry | numeri **solo in referto** | G6a sez. 3-bis |
| G6a | **9 file prova scritti e mai girati**: R148g, R140a, R140b, A1_DAXREENTRY_M1, A1_NYRETEST_NASUSD, NOISE_M30 x2, PASSO0_FVGRET x2 | non in coda, non nei referti runner | G6a sez. 3-bis |

### 3(b) MISURE A POCHI MINUTI SUL PC DI BACKTEST (ordinate per costo, poi per valore dichiarato dal gruppo)

Tutte **solo sul PC di backtest** (`DESKTOP-H4D7CAJ`), mai sul VPS finche' una challenge e' viva. Il costo e' quello **scritto dal gruppo** (con la sua fonte); [STIMA] / [DERIVATO] sono etichette dei gruppi. Ordine **indicativo per l'estremo basso del costo** (poi per valore dichiarato dal gruppo): non e' un ordine di esecuzione. Ogni lancio richiede il via libera di Claudio (regola 21/09), salvo scritto altrimenti.

| costo | misura | gruppo | cosa chiude | fonte del costo |
|---|---|---|---|---|
| **~1 min** | G0 di riconciliazione 770105 short a parita' di finestra e banco (2 passate) | G1 | scioglie la CONTESA 0,957 / 1,065 della cella 1b | G1 §7 m.1 `[DERIVATO da R245 0,333 min/passata]`; "nessuna firma" |
| **~1 min + 2 di avvio** | riconciliare il contratto 770511 (cella 00, binario `872dba82`, export per-trade acceso) | G2 | contesa 1,849 / 1,328 contro 1,482 / 1,243 e le posizioni (forbice 62-143) | G2 §4 m.2 |
| **~45 s** (o 0 con il per-trade `cemad02` dal VPS) | IS in posizioni di 771531 (gamba IS, magic vergine, 100.000) | G2 | D1: IS 132 pos non ricontabile (forbice 103-237) | G2 §4 m.1 |
| ~1-2 min | certificato `ABTG_ORB_Fibo` | G2 (fuori classifica) | mancano uscita, gemelli, TF | G2 §4 |
| ~2 min | R113 coda "feed o epoca?" (3 celle) | G5 | decide se la prova di regime Nasdaq e' possibile | G5 §5 m.4 (firma lampo dei criteri) |
| ~2 min / ~2-10 min | certificato `TurnaroundTuesday` / `ChaosLyapunov` (2 celle split IS/OOS) | G6b | caselle del certificato; **la scelta se spendere questi minuti e' di Claudio (G6b-7)** | G6b §5 m.5 |
| ~3 min | uscita + TF di `ABTG_Londra_ORB` | G2 | casella 3 e TF | G2 §4 |
| ~3-5 + ~3-5 min | `SupRev_NAS_H1`: G0 sul binario in campo + R163a (14 passate) | G5 | binario (3 cifre), costo 28,7x mai misurato direttamente | G5 §5 m.1 `[STIMA da R127a]` |
| ~3-6 min | `SupertrendInvert`: diagnosi del perche' non opera (sonda a contatori = zero passate, poi G1PAOLO_10/11/12) | G5 | l'unico EA G5 senza un numero leggibile | G5 §5 m.5 |
| ~2-5 min | `IntradayMomentum`: IS per simbolo con per-trade (2 passate); OOS a 0 min dai per-trade gia' sul VPS | G6a | orologio inverno/estate vs inversione IS/OOS su 4 celle su 4 | G6a §5 m.2 `[STIMA]` |
| ~4 min | `AtrExhaustVol` gemelli U30USD e D30EUR M30 (4 passate); poi asse d'uscita 18 passate ~17 min | G6a | certificato 4/5, triplica il campione | G6a §5 m.4 |
| ~3-8 min | `NySessionRetest` gemello NASUSD (2-4 passate) | G6a | campione | G6a §5 m.5 |
| ~4 min / 3-7 min | Live5m: finestra d'ingresso 15'-60' con split / `DAX_M3` prima corsa a tick con IS/OOS | G1 | due "morti" con 2-5 caselle vuote | G1 §7 m.5 `[STIMA]`; firma sul TF d'ingresso |
| ~5,3 min (16 passate) | candidato Dow: R280 (+ rilettura R250 B, 0 min, 1 firma) | G1 | l'unica cella di G1 con n >= 150 in IS e OOS: se il merito e' un artefatto della griglia | G1 §7 m.2 |
| ~6 min (16 passate) | `VwapRevert` passo 0 a M30 e H1 (+ gemelli ~12-25 min) | G6b | M30/H1 mai provati, lo spread pesa meno | G6b §5 m.4 `[DER]` |
| ~6 min (~2 min a cella) | `PostNews`: primo PF/DD/n delle tre sedie (calendario 2010-2025, 599 eventi) | G3 | contratto NON MISURATO su 3 sedie vive | G3 §5 m.2 `[STIMA]` |
| ~7 min + sonda | `MaxMinNotte` DAX short: campione e TF (sonda `ABTG_Notte_Study`, `InpPlaceHour`, `InpMgmtTF` M15-H4, R214g) | G3 | se esiste una configurazione >= 150 pos senza sfondare 40x | G3 §5 m.4 |
| ~8-10 min | G0 dell'oro col binario `0953846c` (G2) = "G0 H4 sul binario attuale" (G5): **stessa misura vista da due gruppi, stesso costo; non l'ho verificato in codice** | G2, G5 | rende confrontabile l'OOS 1,22-1,65 dell'oro; sblocca 12 griglie SALTATE; PF per regime dell'oro con lo zip R99/R100 | G2 §4 m.3 `[STIMA da R264]`; G5 §5 m.3 |
| ~5-11 min | `Nightly`: 4 coppie native (16 celle, 32 passate) | G3 | D6 (il "morto" su 21 mesi); e' l'unico G3 sopra il pavimento di frequenza (1,937 op/g) | G3 §5 m.1 `[STIME]` |
| 4,8-11,2 min (32 passate) | C2C `exit 0` su 4 simboli nativi (EURJPY, CHFJPY, USDCHF, GBPCAD) | G4 | se `exit 0/1` tiene la giornata sotto il 5% a tick | G4 §5 m.3 |
| 0-12,6 min | R252 + PRV_DAXAP_04 (short DAX in fase, modi per lato) | G1 | decide se il DD 12,31 / 12,05% e' un artefatto dell'orologio; **0 se lo zip esiste** | G1 §7 m.1 |
| ~8-10 min | R125 e TF M10/M15 dell'ORB Dow; PF `SuperWave_EA` a tick ~10 min | G2 (fuori classifica) | | G2 §4 |
| 5-24 + 2,7-12 min | R274 (orologio 770260, 16 passate) + R214c/d (TF M15/M30, 8 passate) | G1 | frequenza d'inverno del Nasdaq; **serve prima scrivere il lettore (non esiste)** | G1 §7 m.3 |
| tetto 18 min (12 passate) | C2C R214e (tick, 3 uscite) + R214f (OHLC lungo) | G4 | la sedia con PF OOS 1,52 su n 242 e il suo tappo (giornata -8,02%); **mai messi in coda** | G4 §5 m.3 |
| ~10-20 min + compilazione | passo 0 `FvgRetest` (D30EUR M15) + `ImpulsoApertura` (D30EUR e U30USD M30), 16 passate | G6a | 2 EA mai misurati (certificato 0/5); `ImpulsoApertura` va compilato (F7) | G6a §5 m.3 |
| 15-25 min; ~10-60 min | `PASSATA_STOP_SUPREV` (2 passate U30USD H1); R120a/c/d uscita ad asse su 13 EA | G5 | costo 40x del corto indici; prerequisito casella 3 per ogni SOTTO/NM di G5 | G5 §5 m.2 (pronta, PASS 24/09, pin `7e255a82`, non risulta girata) |
| ~15-20 min | `HARSI`: scan EURUSD M5 (prima: misura dello spread, 0 min) | G6b | NM | G6b §5 |
| ~15 min | `MeanRevert` (6 celle x EURUSD/USDJPY/XAUUSD H1 + GBPUSD H4) | G6b | certificato 5/5 oppure candidato; vedi D-4 | G6b §5 m.5 |
| ~10-20 + fino a ~29 min | `Nightly` R220a-d + stadio 2 R259 | G3 | uscita ad asse | G3 §5 m.1 `[STIME]` |
| ~15 min (GapFill ~10 passate); ~3-5 min a file (EZ, Larry) | casella 5 (TF) di GapFill / EasyTrend / Larry | G4 | "H1 e basta" su 3 EA | G4 §5 m.4 `[STIMA]` |
| ~18-24 min (12-16 passate) | `InvEsaurimento` E3 e baseline a tick su D30EUR/U30USD M30-H1 | G6b | previsione scritta prima: rosso/piatto nel toro | G6b §5 m.4 |
| ~25-35 min | `CrossEma` K03 (XAUUSD H1 + filtro EMA200): TF H2/H4/M30, gemelli, un asse d'uscita | G6b | l'unica cella del gruppo con IS e OOS sopra 1 e DD sotto il muro | G6b §5 m.2 `[MIS]` su XAU H1 1,6-2,2 min/file |
| 3-11 min (+ 2-4 conv.) | prova di regime **DAX 2010-2018** (32 passate; 56 con variante B 6-19 min) | G1 | regime per DAX long/short | G1 §7 m.4; **il costo vero e' scrivere il convertitore con DST per giorno e il lettore; tre firme D-J/D-K/D-L** |
| 8-20 min (34 passate) | prova di regime Nasdaq `NASUSD_EXT` (gemella senza volumi; orologio EXT da rileggere); nucleo Nasdaq 63 passate 14-36 min | G1, `FIRME_DA_FARE` | regime per 770260 / 770250 / 970913 | G1 §7 m.4; foglio firme (F-A) |
| 34,1 min (30 celle / 60 passate; 2,0 min x 7 round di avvio) | `SuperWave` 770511: i 7 file gia' pronti (TP1Pct, TP1_R, BE, TP_RR, SLBuffer, TF M30) | G2 | casella 3 su una sedia SOPRA; sospesi in coda dal 21/09 | G2 §4 m.4 |
| 15-45 min | `Relativo`: A1 SPXUSD (4 passate) + R117BIS (8 passate), dopo le due letture a costo zero | G6b | campione (n IS 87); la famiglia a 2 simboli centra il pavimento 1,00/giorno (~1,05 `[DER]`) | G6b §5 m.3 |
| 15-60 min | `Bulge`: M1 sulla cella di campo a 16,5 anni (4 passate) | G3 | decide il ramo (niente griglie / apri l'uscita / tick) | G3 §5 m.3 `[DERIVATO]` |
| decine di minuti `[NON MISURATO]` | `PTE`: scarico M1 2019-2022 + rifare R80 (40 CSV) | G3 | divergenza `_EXT` / nativo, duello GBPUSD | G3 §5 m.5 (firma da confermare) |
| **90-348 ore di PC acceso** (CORE-A 63-244 h) + 30-60 min di tester | prova di regime **Dow Dukascopy** (F1) | G1, G2, `FIRME_DA_FARE` | l'unica misura che compra **regime** per le sedie vive (da B ad A) | G2 §4 m.5 `[DICHIARATO]`; **firma F1: spesa/storico** |

**Righe "migliorabile: si" senza stima di costo** (dichiarate dai gruppi, `[COSTO NON STIMATO]`): G3 1g, 1h, 1i, 7f, 9c (F40EUR/E50EUR/100GBP, EURUSD M15, NASUSD MaxMin, PTE DAX H1, WOL oro D1).

### 3(c) MISURE A ZERO MACCHINA (letture, trasferimenti, recuperi)

| misura | gruppo | cosa chiude | fonte |
|---|---|---|---|
| **leggere in sola lettura sul VPS i per-trade del 21/09** (`abtg_trades_ABTG_IntradayMomentum_NASUSD_784101.csv` 15,8 KB e `..._U30USD_784102.csv`; in totale **18 file per 9 EA di G6a** in `Common\Files`) e spezzare per orologio e lato: ogni file e' **una passata sola** (di norma l'OOS) | G6a | unita' n, split orologio/regime per gli OOS (G6a-2); per l'IS servono 2 passate (sez. 3b) | G6a §5 m.2, G6a-2 |
| ricaricare il per-trade `cemad02` (771531) dal VPS | G2 | IS in posizioni (D1) | G2 §4 m.1 |
| leggere `ReportTester_GapContinuation_225JPY_OOS_TICKREALI.xlsx` (**gia' in repo**, binario non letto da G4) e recuperare: report originali di `EasyTrend_EURUSD` (PF 1,04 n74) e del paniere `BREAKOUT_EA_JPY` (-20.853); PF di `PunteLarry` XAU a 22 anni (R100); la riga mancante del DD 1,9% di BB R34 (CSV dice 3,48%) | G4 | unita' n di GapCont (70 deal contro 30-70 pos); 3 righe NM | G4 §5 m.2 |
| recuperare lo zip R99/R100 (oro) | G5 | PF per regime dell'oro 22 anni (oggi solo il DD) | G5 §5 m.3, D21 |
| copiare zip/CSV di R96, R117, INVES (+ per-trade E3), CHAOS/CHAOSABL, per-trade passo 0 VwapRevert; leggere nel giornale del tester `XAUUSD: ticks data begins from` e le specifiche `InpPuntiPerIndice` / spread di SPXUSD | G6b | caselle 1-2 per 5 EA; regola F6 sulle 4 celle oro di CrossEma; 2 pre-condizioni bloccanti di A1 SPXUSD | G6b §5 m.1, G6b-3 |
| misurare lo spread EURUSD M5 (HARSI) | G6b | pre-condizione dello scan | G6b §5 |
| leggere i CSV di R141e, R145a/b, R148a/bL/bS appena trasportati | G6a | 3 EA da NM a numeri (sez. 3a) | G6a §5 m.1 |
| leggere `R141c` per il rischio di AtrExhaustVol: la cella ATR a floor acceso (72 idx) ha DD 4-6%, la PERC 13-19%; il "NO PER RISCHIO" di R109 (floor spento) non va esteso alla config riparata | G6a | due verdetti di rischio su config diverse (G6a-8) | G6a-8 |
| ricontare le caselle dei motori con referto senza CSV e correggere i documenti (sez. 4): censimento 22/09, giacimento, dossier Emiliano, contratti BB, ecc. | tutti | evita di rilanciare cio' che e' gia' stato fatto | sez. 4 |
| chiudere i magic dei file Ottimizzati leggendo i `.set` / preset (G1 DN1: 770111 contro 770102; 770211 contro 970201) e la tabella forward (G2-15: magic 971501 su AUDCHF `[NON VERIFICATO]`) | G1, G2 | collisioni di magic | G1 DN1; G2-15 |

### 3(d) CIO' CHE SERVE A CLAUDIO: DECISIONI E FIRME

**Le firme del foglio `report/FIRME_DA_FARE_2026-10-05.md` sono solo richiamate** (12 firme: **R-0 «FIRMO REGOLA REGIMI»** per prima; poi **F-A**, **D-J, D-K, D-L**, **F1** obbligatorie; **F-B** (raccomandata insieme a F-A), **F-A2, F-C, F-D** e due opzioni DAX opzionali; piu' le **domande aperte sue**: taglia 2,00% e muro 10%, **ora d'inverno DAX entro il 25/10** e USA entro il 02/11, sedia `771514`, M1 del DAX "2 su 3" o "tutte", dashboard SuperWave, PC di backtest per giorni). **Non le ripeto.**

**Decisioni NUOVE emerse dai gruppi** (non nel foglio), in ordine di quanto cambiano il resoconto:

| id | decisione | perche' conta (numero) | chi la propone |
|---|---|---|---|
| **D-1** | **D2: soglia di ZONA GRIGIA sul PF** (non esiste: "le soglie le fissa ogni misura prima dei dati") | senza soglia "SOPRA 1" per PF 1,00-1,10 e' rumore: G2 la incontra 3 volte (ORB nominale 1,050; ORB R8 1,03; SW Dow 1,243), G5 in S12 (1,073) e W04 (1,07), G1 in 1c / 14d (1,097 su 104). Il piano propone: affidabilita' C/D + nota "indistinguibile da 1" sotto l'errore tipico dichiarato (~0,2 su n=144 `[stima]` del dossier) | piano D2; G2-9; G5 §6 |
| **D-2** | **classe "NON CONFRONTABILE / REGIME"** per i SEGNO INVERTITO (IS e OOS da parti opposte di 1) | oggi sono SOPRA con etichetta; **G3: 9 EA in SOPRA scenderebbero a 6** (Nightly, Bulge, AllineaLondra); **G5: 19 righe su 105 sono INV** (15 su 66 SOPRA); G6a: IntradayMomentum e LVNArbitro hanno IS 0,60-0,98 con OOS sopra 1. Il piano 5.4 la prevede solo per "OOS sopra 1 ma storia sotto" (EMA200 oro H4) | G3 D20; G5 D14 |
| **D-3** | **regola di etichetta "con o senza screening"** (le celle `[B]/[E]`: contano in SOPRA/SOTTO o sono NM come merito?) | un lettore che vuole "gli EA sopra 1" ottiene **9 o 7** su G6a; sui sette gruppi 59 contro 57 SOPRA (sez. 0.1); G3/G4 le contano NM, G5/G6b SOPRA/SOTTO con suffisso | G6a-3 |
| **D-4** | **eccezione "non si spende" sui due morti con caselle vuote**: `RIESAME_MORTI_NOTTURNI` (22/09) scrive "MORTO VERO" per `MeanRevert` e `TurnaroundTuesday` ammettendo "il certificato NON e' pieno: non si spende" (r.75-76, r.492), in contrasto con la regola del 09/09 | o Claudio **firma l'eccezione** o **autorizza la misura** (~15 + ~2 min, OHLC, sez. 3b) | G6b-7 |
| **D-5** | **regola C0 per famiglia**: la regola C0 dice se si somma il campione fra simboli? `IBRetest`: il C0 e' applicato a un campione ottenuto sommando tre simboli diversi (famiglia n 209 contro n 35-107 per cella, tutte e tre < 150) con IS di segno opposto sul DAX (1,211) | coerente con "il pavimento si misura per famiglia" (firma 07/09), ma l'unita' del merito per cella e' sotto 150 | G6a-6 (cancello / Claudio) |
| **D-6** | **HARSI**: i numeri esistono solo su TradingView/OANDA: **8 `.xlsx`** (`HARSI_Backtest_-_Claudio_OANDA_XAUUSD_2026-06-26 (1..8).xlsx`) elencati da un log del VPS e mai letti; **se Claudio li ha ancora** | unico numero pre-esistente di HARSI (dato esterno OANDA XAUUSD: non entra in classifica, piano 5.2.5, ma apre la domanda su TF e SL/TP) | G6b-13 |
| **D-7** | **via libera ai lanci e alla riga di trasporto**: ogni round di sez. 3b e la riga `carica_risultati.ps1` di sez. 3a (perimetro del runner = sola lettura: serve una firma; modifica di `$GiorniIndietro` = modifica di script = cancello) | **scadenza ~20/10** (sez. 3a) | G4 m.1, G6a m.1, G6b m.1 |
| D-8 | G1: **firma pendente su `ClosePct 0 + BE`** del 770101 (OOS 1,491, +0,094 = dentro il rumore 0,147); decisione sul **TF d'ingresso** di Live5m | cambia la gestione di una sedia in campo | G1 scheda 1 §5; G1 §7 m.5 |
| D-9 | G3: **doppio contratto del `770411`** (DD OOS 1,9213% contro 3,1% a 1%: misurano finestre diverse, `[INFERITO]`): quale finestra fa il contratto; **oro MaxMin**: taglia (DD 22 anni 10,30% a 0,5% contro il contratto 10,0%), preset a due lati con magic nuovo, allungare lo storico a tick | corsia RISCHIO ambigua | G3 D19, sez. 5 |
| D-10 | G5: **GoldenCross v1.00 in campo contro v2.00 a HEAD** (ricompilare?), **taglie dell'oro** (DD 22 anni 9,02 / 16,90 / 25,18% a 1% per le sedie 970901 / 971001 / 970301) | le celle del 08/08 vanno lette come v1.00 | G5 D24; G5 §5 |
| D-11 | G4: **chi ha i report originali** di `EasyTrend_EURUSD` (PF 1,04 n74) e del paniere `BREAKOUT_EA_JPY` (-20.853) in `docs/Portafoglio_Strategie.md`; **taglia di Larry XAU** (DD 22 anni 29,74% a 1%, taglia 0,3% indicata da G4) | due righe NM si chiudono in una conversazione | G4-4; G4 6c, scheda 4.1 §11 |
| D-12 | G6a: **HVAncora**: scadenza delle ancore e' "di casa" (`InpAncoraBarre` 20, `InpAncoraSoloOggi` true): decidere se misurare la fedelta' alla fonte; **CRT** (tick del range 2022-23 non esistono: spesa); **PointBreak / SuperFilter** (serve un `OnTester` = modifica a un EA = firma + cancello); **ScalperDirezionale** (leggere i suoi CSV con `analizza_scalper.py`: serve Claudio) | | G6a-9, §5; G6b §5 |

### 3(e) LAVORO NOSTRO CHE OGGI NON ESISTE (da scrivere prima delle misure; nessuna firma sul contenuto)

- **lettori dei round** che non esistono: R252 / PRV_DAXAP_04, R274 / R214c-d (G1); i **quattro lettori** e ~15 file prova per la prova di regime Nasdaq (F-A); il **convertitore con DST per giorno** e il lettore per il DAX (D-L); il convertitore dell'orologio del Dow (P1: la riga e' pronta, `backtest_pipeline/righe/RIGA_LANCIA_DUKA_P1.txt`, aspetta la mossa di Claudio).
- **strato 2 del cancello** (`controllo-preventivo`) ancora da fare su: PRV_DAXAP_04a-h (strato 1 passato, strato 2 NON fatto: G1); **un lettore leggero sulle correzioni della seconda passata di G2** (G2 intestazione).
- **riallineare le tre specifiche di regime alla regola unica** (circa mezza giornata `[INFERITO]`, `FIRME_DA_FARE`) prima di firmare F-A e D-K.
- **correggere i documenti sbagliati** (sez. 4): i gruppi **non li hanno toccati**, e nemmeno io.
- **scrivere nel registro** lo stato vero dei round (G3 D21: R259, R268, R269 fermi a prima della corsa; G2-11: O4 e R258).

---

## 4. LE CORREZIONI A DOCUMENTI PRECEDENTI EMERSE DAI GRUPPI

> **Non ho modificato nessuno di questi file: li segnalo soltanto.** Colonne: il file sbagliato, cosa dice, cosa risulta dal gruppo, dove sta la correzione (gruppo + id: tutto scritto nel documento del gruppo). Prime sei righe = quelle che Claudio ha nominato.

| # | file sbagliato | cosa dice | cosa risulta | correzione |
|---:|---|---|---|---|
| 1 | **censimento 22/09 `report/CENSIMENTO_CASELLE_VUOTE_2026-09-22.md`** + **`report/I_FILE_FERMI_2026-09-22.md`** + `CODA.txt` (SOSPESO 21/09) | i file d'uscita di BB / GapFill / Larry / GapCont / EZ / C2C sono "scritti, mai girati" | **girati**: 35 round (14-20/09), CSV mai arrivati nel repo; "R214e/f" invece **non** sono mai stati messi in coda (quelli si' "scritti e mai girati") | G4 R12, G4-12, §3-bis |
| 2 | stesso censimento, §5.B | BB: "M30 mai provato, 6 passate, 9 min" | R108 (M15, 25/08) e R111 (M30, 26/08) **girati** (referti in repo, CSV no): TF provati M15, M30, H1, H4; casella 5 BB chiusa | G4 R3, G4-1 |
| 3 | stesso censimento, r.164 / r.168 / r.170 / r.424 | `Relativo` R117 "preparato e mai corso"; `CrossEmaApertura` R96 "non e' mai partito"; `InvEsaurimento` "mai misurato" | **girati**, referti con PF / n / DD (CSV mai in repo) | G6b R-D, G6b-2 |
| 4 | stesso censimento r.176; `CENSIMENTO_SCARTATI_PROSA_2026-09-09` A109; piano riga 90 | `OutOfNoise`: "passo 0 mai corso", "corretto e mai rigirato" | il passo 0 **e' corso** il 29/08 (v1.00 e v1.01, n=0 su 3 celle su 3); solo la v1.02 non e' mai girata | G6a R5 |
| 5 | stesso censimento r.162 / r.404 | `LiquiditySweep`: "R95b-e mai lanciati" | R95 = 5 TF x 3 celle x IS/OOS = **30 passate, 0/30** (`R95_REFERTO`) | G6a R9 |
| 6 | stesso censimento §3 | GapFill regimi: "16 CSV su 16 a Trades=0" | 18 file: **16 a zero e 2 con n=1** (lo stesso trade) | G4-11 |
| 7 | **"PointBreak R60"**: `report/GIACIMENTO_DI_CASA_2026-09-03.md` r.82 -> `report/CORSIA_DEMO_CANDIDATI.md` r.274 -> `CENSIMENTO_SCARTATI_PROSA` A103 -> piano riga 107 | `PointBreak` "SOTTO, R60 12/12 bocciate" | **R60 e' `ABTG_MeanRevert` GBPUSD H1** (6 `InpLookback`); PointBreak non e' mai stato misurato ("NON testabile come strategia", 0 `OnTester`): **NON MISURATO, non SOTTO** | G6b R-A, G6b-1 |
| 8 | **CanaleLento "n=20"**: `report/CACCIA_STOP_STRUTTURALE_2026-09-13.md` r.384, `REFERTO_ROUND63_64` ("1.768 trade OOS"), `CENSIMENTO_PF_MISURATI_2026-09-09` r.400, `CACCIA_MECCANISMI_SEI_FAMIGLIE_2026-09-26` r.470; piano riga 101 ("n<100") | "PF IS 0,87 / OOS 1,10 su n=20" | **20 = 20 CELLE**, 1.768 = somma sulle celle, 0,87 / 1,10 = mediane di 20 celle; n per cella 29-112 (IS) e 47-164 (OOS): "n<100" e' sbagliato anche in n | G6a R8, G6a-10 |
| 9 | `report/CENSIMENTO_CONTRATTI_v2.md` §4c e contratto 772161-63 | BB: n "26 -> NON MIS., forbice 11-26"; DD promesso 1,9% | **26 posizioni** (`InpTPMode=0`, 26 / 13 / 11 `position_id` distinti); il CSV R34 da' DD **3,48%** (R33 10k 3,40%): l'1,9% non e' riproducibile `[NON VERIFICATO]` | G4 R1, R2, G4-2, G4-8 |
| 10 | `CENSIMENTO_CASELLE_VUOTE` / `CENSIMENTO_LATO_SHORT_2026-09-09` | i lati di Larry (U30USD, EURAUD, XAU, GBPJPY, EURCAD) "mai misurati" | i CSV `wf_larry_*` hanno long / short / L+S per tutti e 8 i simboli di R38: **lati misurati** | G4 R6, G4-6 |
| 11 | `R102_REFERTO_DRIVER_BLOCCO1_20260824_0005.txt` | "3 finestre positive su 5" per le tre BB | sulle epoche vere: 2/5 GBPUSD, 3/5 EURUSD (due con n <= 6), 2/5 AUDUSD; il "3" conta la finestra COMUNE | G4 R4, G4-7 |
| 12 | `GIACIMENTO_DI_CASA` §6-7; `CENSIMENTO_SCARTATI_PROSA` A102; piano riga 65 | `BreakoutCorso`: "R12 48/48 OOS negative; R45 0/48" | non riscontrabile e **probabilmente mal attribuito** (R45 0/48 e' di altri EA); l'unica misura primaria in repo e' R82 (7/7 OOS < 1) | G4 R8, G4-5 |
| 13 | piano righe 58 e 66 (`EasyTrend_EURUSD`, `BREAKOUT_EA_JPY`) | "nessuna riga PF" | numeri **solo in prosa** in `docs/Portafoglio_Strategie.md` r.51-61 (PF 1,04 n74; -20.853): restano NM con indizio | G4 R9, G4-4 |
| 14 | `report/I_QUATTRO_INVISIBILI_2026-09-12.md` + `CENSIMENTO_SCARTATI_PROSA` A77 | `IntradayMomentum`: "OOS 0/6, COSTO C3" **e** "zero CSV, zero righe di registro" | "0/6" = 0 celle che passano i **cancelli**, non 0 PF >= 1 (5 celle su 6 hanno PF OOS >= 1); R98 ha referto e riga di registro r.1245; R141a/b **girati** con 4 CSV in repo | G6a R1, §3.1 |
| 15 | `CENSIMENTO_SCARTATI_PROSA` A105; piano riga 93 | `DaxValueArea` "morto su due gambe" | un **argomento per analogia**, nessun numero dell'EA; R141e e' **girato** (16-20/09, CSV non in repo) | G6a §3.1 |
| 16 | `CENSIMENTO_SCARTATI_PROSA` A59-A64; piano righe 91, 92, 95 | `AtrExhaustVol` "OOS 0,83-0,99 su n 655-927"; `NySessionRetest` "OOS 1,37-1,43"; `DaxReEntry` "OOS 1,69-1,80" | **non sono OOS**: finestra unica (R109 fino al 21/08, non al 30/06); la cella "migliore" e' scelta sullo stesso campione | G6a R6, R7, G6a-5 |
| 17 | `I_QUATTRO_INVISIBILI` r.25-30 | `HVAncora`: "attesa non raggiungibile, ~zero operazioni a k=1,0" | **22 e 31 operazioni**; il tappo e' un altro: 91 + 165 ancore scadute | G6a R10 |
| 18 | piano sez. 6 e i piani `LA_BANDA_BASSA`, `CASELLE_VUOTE`, `VIA_PIU_CORTA` | "R141a-e = 5,16 minuti" (formula T = 0,6 + 0,077 N) | **13,2 min misurati** (mediane runner) sul banco VPS: stime sottostimate ~2,5x | G6a R13, G6a-7 |
| 19 | piano riga 24 (G1) e `CENSIMENTO_SCARTATI_PROSA` A8 / `backtest_pipeline/REGISTRO_TEST.md` / `RISULTATI_OTTIMIZZAZIONE` | `ABTG_DAX_M3`: "33% combo positive" (e "21%, DD 21%") | **zero CSV in storia git**: non verificabile; classe SOTTO -> **NON MISURATO** | G1 §3 r.1, DN3 |
| 20 | piano riga 7 (G1) | `Apertura_Marco`: "nessun PF proprio" | 4 CSV in `Marco_Emiliano/valid_Marco_*` (44 passate, finestra unica) | G1 §3 r.2, DN2 |
| 21 | piano righe 6, 20, 26 e D12: "`standalone/` = copie dell'08/09 che EREDITANO" | copie "tutto-in-uno" | sono del **26/07**, **motori diversi** (diff 131-1.944 righe): non ereditano; `Pin9fca` DAX = pin `9fca63d9` ma **non HEAD** (+460 righe); `TrailFix` != `CLAU12` | G1 §3 r.6-8, §5, DN6-7 |
| 22 | piano riga 14 e `CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20` / dossier | Nasdaq 770260: "1,14 / 1,11 contro 1,22 / 1,22" | **due celle diverse** (ClosePct 0 contro 50, 10k/1% contro 80k/2%, `InpBreakevenAtTP1`): non e' una CONTESA; `Nasdaq_Ott` "0,91" e' del motore base, la Ott fa 1,34 | G1 §3 r.5, r.9, §4.1 |
| 23 | piano riga 1 / `RB`: 770105 short | "0,97 / 0,96" | **CONTESA**: 0,957 (R270d, 100k, dal 10/06/2025) contro 1,065 (R251b, 10k, dal 01/07/2025) sulla stessa config | G1 §3 r.12 |
| 24 | piano righe 27, 31, 32, 35, 37, 38 (G2, classi provvisorie) | `SuperWave_DOW_H1_Ott` SOPRA; `ABTG_ORB` SOTTO (R97); `Londra_ORB` NM; `ORB_Fibo` SOTTO (OHLC); gemelli EMA200 `[NON MISURATO]`; oro H4 SOTTO | CONTESA -> NM; ORB **MISTA** (R97 e' di `ORB_Ottimizzato`); Londra_ORB **MISTA** (R258 all'ora giusta); ORB_Fibo SOTTO **a tick** (0,803 / 0,851); gemelli **MISURATI SOTTO** (EMAGEM2 04/10); oro H4 **MISTA** | G2 sez. 0.2; G3 D14 |
| 25 | `report/DOSSIER_EXPERT_PER_EMILIANO_2026-10-05.md` | "OOS estate 2,05 su 169 uscite, inverno 0,87 su 88" | **posizioni** (169 + 88 = 257), non uscite; il censimento scrive 347 e 170 deal | G2-2 |
| 26 | tabella forward / contratto 770511 | "16 posizioni" (conteggio per righe) | con l'uscita parziale le righe sovrastimano: 770511 16 righe = 14 pos; 990001 13 righe = 5; 770531 14 = 13 | G2-3 |
| 27 | console di riga `R258` | "NULLO" su 22 file | artefatto del parser (virgola di `InpNewsCurrencies`, classe 883): i file sono validi; da scrivere nel registro (O4, R258) | G2-11 |
| 28 | piano riga 38 e D6; `ANALISI_PDF_LONDRA` | `Londra_ORB` "R45 0/48 + fuso sbagliato" | R258 (28/09) ha misurato l'ora giusta; **"R45 0/48" e' di `ORB_Ottimizzato`**, non di Londra_ORB | G3 R8, D14 |
| 29 | piano riga 41 (G3) | MaxMin: "oro tick OOS 1,45"; "DAX long 0/7" | 1,45 e' il **solo long** a tick (R268a), non il preset a due lati; il DAX long e' 0/41 celle a tick | G3 R1, R2 |
| 30 | `CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20` §4.2 contro `REGISTRO_TEST` r.666 | `770411`: DD 1,92% contro 3,1% | misurano finestre diverse (3,1% = IS+OOS, `[INFERITO]`): il doppio contratto e' **una decisione** | G3 R3, D19 |
| 31 | piano riga 50; `REGISTRO_TEST` r.1515+ | PostNews candidati ISM / 13:30 `[T]` | sono **`[B]`** (screening, CSV `[SOLO REGISTRO]`) | G3 R4, D15 |
| 32 | `CENSIMENTO_CONTRATTI_v2` §4a | PTE 771321 DD 2,18% | il CSV da' **3,22%**; l'origine del 2,18% non verificata | G3 R5, D16 |
| 33 | piano riga 49; `CENSIMENTO_PF_MISURATI_2026-09-09` | WOL "5 celle OOS n>=100 con PF 0,02-0,46"; colonne `oos_trades_max` < mediana | aggregazione guasta: ricalcolato da 28 CSV, lo sweep ha anche celle sopra 1; **il censimento non va usato per WOL** | G3 R7, D18 |
| 34 | `backtest_pipeline/REGISTRO_TEST.md` r.686-699, r.4521, r.4590 | R259, R268, R269 "non girati / IN CODA" | **girati il 28/09** (`LETTURA_ROUND_CORTI_A` / `D`); registro indietro | G3 R10, D21 |
| 35 | piano righe 67-70; `backtest_pipeline/CLASSIFICA_PF.md` | SupRev nativi oro "~2,74 / ~3,17"; "nativi ≈ ottimizzati" | il nativo oro H4 fa **0,337 / 0,765** (Multi 0,709 / 0,686); i 2,74 / 3,17 sono **NON RIPRODOTTI** (nessun CSV) | G5 D4, D15, D17 |
| 36 | piano righe 68-70, 74, 75; `CLASSIFICHE.md` | "OOS mediano 0,92-0,99", "1,14-1,71", Dow H4 "0,79", CAC "0,96" | sono **mediane TF** (non celle); lo 0,79 e' NON RIPRODOTTO, lo 0,96 e' la mediana di 8 celle | G5 D4, D16, D17 |
| 37 | piano riga 82; `CLASSIFICA_PF` ("rischio 1%") | `Gold_Ichimoku` "nessun PF"; celle TF-scan oro a rischio 1% | R103: **PF 1,311 su 553**; i TF-scan dell'oro `_Ottimizzato` / `_Multi_Ottimizzato` sono a **rischio 2%** nei CSV | G5 D18, §0 |
| 38 | `report/LE_QUATTRO_EPOCHE_GIA_MISURATE_2026-09-23.md` r.136 | `SupertrendReversal_Ott`: "4/7 anni negativi" | la tabella del driver R103 ne mostra **3** (2020, 2021, 2023): `[NON RICONCILIATO]` | G5 D22 |
| 39 | `report/RIESAME_MORTI_NOTTURNI_2026-09-22.md` r.75-76, r.492 | `MeanRevert`, `TurnaroundTuesday`: "MORTO VERO" | certificato non pieno: **NON ANCORA MISURATO** per la regola del 09/09 (decisione D-4) | G6b-7 |
| 40 | `REFERTO_ROUND63_64`, `CENSIMENTO_SCARTATI_PROSA` A110, `RIESAME_MORTI_NOTTURNI` D2 | `TurnaroundTuesday`: "11.928 operazioni" | = **24 x 497** (somma sulle celle); i martedi' sono 497 OOS + 333 IS | G6b R-C, G6b-6 |
| 41 | `backtest_pipeline/REGISTRO_TEST.md` r.2042; `TRASFORMAZIONI_CANDIDATE` r.534; `I_BOCCIATI_HANNO_UN_CERTIFICATO` §9.2; censimento 09/09 | `AltaVelocita`: "rosso 8/8 a tick", "numeri non nel registro"; 7 simboli contati due volte | i tick esistono solo per GBPUSD v1 (4 celle); **96 celle-passate = 45 celle distinte**; 0/48 OOS >= 1; i numeri ci sono nei CSV | G6b R-E, G6b-5 |
| 42 | `CENSIMENTO_SCARTATI_PROSA` A44-A45 | `ChaosLyapunov`: "1/105 in fascia", "gate largo IS 1,25-1,33" | **40 celle sopra 1**; non esiste IS (finestra unica); 1,25 / 1,33 sono PF medi per soglia | G6b R-F, G6b-9 |
| 43 | `CORSIA_DEMO_CANDIDATI.md` r.244; `CENSIMENTO_SCARTATI_PROSA` A79; header `ABTG_CrossEmaApertura` r.27 | `CrossEma`: "R86 EDGE/PF in blocco" | nessun numero R86 nella lapide; sui 16 CSV OOS >= 1 in 5 celle su 8 e **una cella (K03) con IS e OOS >= 1 e DD <= 15%** | G6b R-B, G6b-11 |
| 44 | `I_BOCCIATI_HANNO_UN_CERTIFICATO_2026-09-12.md` C.2; `REGISTRO_TEST` r.1274-1285 | `VwapRevert`: "PF [NON SCRITTO]"; "perde piu' dello spread" | il PF c'e' nel referto del passo 0 (OOS 0,73 / 0,80 / 0,64 / 0,73); netto -0,25 punti/trade contro spread 2,26 (11% dello spread): M30/H1 sono una misura legittima | G6b R-G, G6b-10 |
| 45 | `CLAUDE.md` (21/09) contro `NOTTE_2026-09-22` r.25 | il tester di `IntradayMomentum` che il 21/09 ha inchiodato il VPS era stato lanciato **a mano** (CLAUDE.md) oppure **"da una corsa del runner"** (NOTTE) | fonti discordi, **non risolto**; il `REFERTO_RUNNER` del 21/09 non e' in repo (l'elenco salta dal 20/09 al 23/09) | G6a G6a-1 |
| 46 | `CENSIMENTO_CASELLE_VUOTE` §4 e R94 | BB R94 (Bollinger 37/1,4): "p37 mai lanciati", `p20` "girato" | nessun CSV R94 in repo: non si sa se `p20` sia girato | G4-9 |

---

## 5. COSA NON E' STATO FATTO, E [NON COPERTO] EREDITATI

### 5.1 Non fatto in questo consolidato (per scelta o per regola)

- **Nessuna misura nuova, nessun CSV rimisurato.** Ho riletto dai file solo le **tabelle** per contare (sez. 0.2) e lo **script di `carica_risultati.ps1`** (r.31, r.111-112, r.210) per la scadenza della sez. 3a. Ogni PF / n / DD della sez. 1 e' copiato dal gruppo; **824 numeri** della tabella principale sono stati controllati uno per uno contro il file del gruppo citato (Appendice B): 0 non trovati.
- **Nessun verdetto nuovo, nessun "MORTO", nessun "NON CONFRONTABILE / REGIME"** dove il gruppo non l'aveva scritto (D-2 e' una decisione, non l'ho applicata).
- **L'ordine di riparazione per "edge" e' backlog, non adesso.** Non esiste qui una graduatoria di EA da riparare: l'ordinamento della sez. 3 e' per **costo / valore delle misure**, non una classifica di EA.
- **Nessuna caccia web nuova** (regola del 19/08: le cacce si fanno per meccanismi alternativi, non su richiesta di un resoconto).
- **Nessun documento sbagliato e' stato corretto** (sez. 4: solo segnalati).
- **Nessuna riga di lancio scritta**, nessun script `.ps1`, nessun round, nessun terminale, preset, EA, taglia, conto; VPS non toccato; niente FTMO / challenge / trial.
- **Cancello**: `controlla_riga.py --oggetto md` (strato 1) **da rilanciare sulla versione finale**; `controllo-preventivo` (strato 2) **non ancora eseguito**: questo file e' una **bozza**.

### 5.2 [NON COPERTO] ereditati dai sette gruppi (dichiarati, non finti)

| gruppo | cosa non e' coperto |
|---|---|
| **G1** | rilettura dei CSV di R246 / R251 / R253 / R255 / ROUND_ORB (numeri da mappe 03/10 e referti); il diff `DAX Pin9fca` contro HEAD letto **in parte** (225 righe non-commento: se una riga fuori dal filtro SPAZIO toccasse l'ingresso, "EREDITA" cade; DN10); G0 a parita' di pin e banco per 770260 **NON PROVATO**; avvisi "in fase" e "vergine" del candidato 14k misurati sulla cella vicina `InpEmaSlow=200`, non sulla 220; R252, R274, R280, PRV_DAXAP_04, R214a-d, R215a, R231a, R275, R183, R180 senza CSV |
| **G2** | R97 e R125 (mai girato) non riaperti; CSV R234 non in repo; specifiche Regime DAX / Nasdaq non riaperte; R97, R10, R11, R23, R264, scan SW nativo **non riletti cella per cella** `[NON VERIFICATO]` (non cambiano i conteggi per EA); `standalone/ABTG_EMA200` logica non diffata |
| **G3** | CSV non in repo: BreakinBox, LondonFx, AllineaLondra, candidati PostNews, R17, forward (letti dai referti); fattore deal/posizioni dei PTE a 13 anni non misurato (D24: >= 193 pos col fattore massimo); costo non stimato per le righe 1g, 1h, 1i, 7f, 9c; il referto WOL non ha il costo (D23) |
| **G4** | **i CSV dei 35 round non letti**; nessun ricalcolo oltre le riletture elencate; `ReportTester_GapContinuation_225JPY_OOS_TICKREALI.xlsx` (binario in repo) non letto; nessun diff root/standalone; nessun feed `_EXT` ricontrollato; i PF dei per-trade BB sono sul netto con commissioni (1,81 / 4,42 / 2,89 contro 1,73 / 3,86 / 2,75 del tester) |
| **G5** | scan OHLC a finestra unica (censimento 09/09: 118 + 113 righe + 10 `SupRevScr`) e TF-scan OHLC di D30EUR / CAC non letti cella per cella; R110 per i lati e R236 / R238 (CSV fuori repo); stato di esecuzione di R163a / R166a / R190c / R237; deposito dei round R123; finestra esatta delle prove FASE 0 del 07/08 (dedotta); fattore deal/posizioni **NON misurato** (nessun per-trade); PF per regime dell'oro 22 anni non in repo |
| **G6a** | nessun CSV dei round girati e non trasportati letto; tabelle OPTFRAME di R98, R95, R109, R235 solo da referti; sorgenti letti per input / intestazioni / righe citate, non riga per riga; PDF e paper non riaperti (arXiv 2605.04004, 2607.01550, SSRN 4824172, Gao-Han-Li-Zhou); nessun feed `_EXT` ricontrollato; nessuna operazione spezzata per orologio (l'effetto sulle classi e' `[NON MISURATO]`); fattore deal/pos misurato solo per `NySessionRetest` (1,354); `ImpulsoApertura` compilato? non verificabile; il referto runner del 21/09 non e' in repo |
| **G6b** | CSV di 5 round non in repo (nessun numero ricalcolato, tutti `[DICH]`); per-trade di R86 inesistenti in repo (deal = posizioni verificato solo nel sorgente); profondita' tick XAUUSD non verificata; finestre IS/OOS di R86 prese da `R86_CRITERI` e non dai CSV; versione (v1 / v1.1) dei 7 simboli di AltaVelocita non verificabile; 8 `.xlsx` HARSI / OANDA fuori repo; CSV per-ondata di ScalperDirezionale non in repo; `NASUSD_EXT` montato sul banco? non verificabile; costi `[STIMA]` / `[DER]` per analogia |
| **consolidatore** | numero di file di G1 non dichiarato dal gruppo (non lo ricavo); le righe marcate **[CONSOLIDATORE]** (finestra dei 30 giorni applicata alle date dei gruppi; "stessa misura" G2 m.3 / G5 m.3; due numeri diversi del crollo di Larry) sono aritmetica o lettura incrociata mia, **da far verificare dal cancello**; i totali 59 / 65 / 40 sommano sette regole non identiche (sez. 0.4) |

---

## APPENDICE A - IL CONTEGGIO, RIFATTO CON UNO SCRIPT CHE RILEGGE LE TABELLE

Script `conta.py` (sola lettura; legge i sette `.md` dalla cartella `report/`, o da `RDIR` per il controesempio). Output sotto.

```
# Rilegge le tabelle dei sette gruppi e ricontaa EA/righe per classe. Sola lettura.
import re, sys, os
R=os.environ.get('RDIR','/home/user/GITHUB/report/')
F={'G1':'RESOCONTO_EA_G1_APERTURE_2026-10-05.md','G2':'RESOCONTO_EA_G2_EMA200_SW_ORB_2026-10-05.md',
'G3':'RESOCONTO_EA_G3_NOTTE_EVENTI_BULGE_2026-10-05.md','G4':'RESOCONTO_EA_G4_FOREX_AGOSTO_2026-10-05.md',
'G5':'RESOCONTO_EA_G5_SUPERTREND_GOLDEN_ORO_2026-10-05.md','G6a':'RESOCONTO_EA_G6A_CACCE_BREAKOUT_2026-10-05.md',
'G6b':'RESOCONTO_EA_G6B_CACCE_REVERSAL_MEDIE_2026-10-05.md'}
L={g:open(R+f,encoding='utf-8').read().split('\n') for g,f in F.items()}
def rows(g,a,b):
    out=[]
    for i in range(a-1,b):
        l=L[g][i]
        if l.startswith('|') and not l.startswith('|---') and not l.startswith('|:'):
            out.append([c.strip() for c in l.strip().strip('|').split('|')])
    return out
def cls(txt):
    t=txt.upper()
    s='SOPRA' in t or 'MISTA' in t
    o='SOTTO' in t or 'MISTA' in t
    return s,o
res={}
# ---- G6b 1.1: colonna 'celle SOPRA / SOTTO / NM (righe)' e' indice 3
r=[x for x in rows('G6b',37,50) if x[0].isdigit()]
ent=so=sb=nm=0
for x in r:
    a,b,c=[int(v) for v in re.match(r'(\d+)\s*/\s*(\d+)\s*/\s*(\d+)',x[3]).groups()]
    if a and b: ent+=1
    elif a: so+=1
    elif b: sb+=1
    else: nm+=1
res['G6b']=dict(righe=len(r),entrambe=ent,soloSOPRA=so,soloSOTTO=sb,NM=nm,EREDITA=0)
# ---- G6a 1.1: classe A col 7, classe T col 8
r=[x for x in rows('G6a',35,51) if x[0].isdigit()]
for tag,col in (('G6a-A',7),('G6a-T',8)):
    ent=so=sb=nm=0
    for x in r:
        v=x[col].strip().upper()
        if v=='ENTRAMBE': ent+=1
        elif v=='SOPRA': so+=1
        elif v=='SOTTO': sb+=1
        else: nm+=1
    res[tag]=dict(righe=len(r),entrambe=ent,soloSOPRA=so,soloSOTTO=sb,NM=nm,EREDITA=0)
# ---- G5 0.2: colonna 2 'celle SOPRA / SOTTO / NM'
r=[x for x in rows('G5',40,58) if x[0].isdigit()]
ent=so=sb=nm=ered=0
for x in r:
    m=re.match(r'(\d+)\s*/\s*(\d+)\s*/\s*(\d+)',x[2])
    if not m:
        ered+=1; continue
    a,b,c=[int(v) for v in m.groups()]
    if a and b: ent+=1
    elif a: so+=1
    elif b: sb+=1
    else: nm+=1
res['G5']=dict(righe=len(r),entrambe=ent,soloSOPRA=so,soloSOTTO=sb,NM=nm,EREDITA=ered)
# G5 0.3 per cella: colonna 3 (classe)
rc=[x for x in rows('G5',66,177) if len(x)>4 and re.match(r'^[A-Z0-9-]+$',x[0])]
cnt={'SOPRA':0,'SOTTO':0,'NM':0}
for x in rc:
    c=x[3].upper()
    k='NM' if c.startswith('NM') else ('SOPRA' if c.startswith('SOPRA') else ('SOTTO' if c.startswith('SOTTO') else '?'))
    cnt[k]=cnt.get(k,0)+1
res['G5-celle']=cnt|{'righe':len(rc)}
# ---- G4 per riga EA: mappa id -> EA
def g4ea(i):
    n=re.match(r'(\d+)([a-z]?)',i); k=int(n.group(1)); s=n.group(2)
    if k==1:return 'BB'
    if k==2:return 'C2C'
    if k==3:return 'EZ_EURUSD' if s=='i' else 'EZ'
    if k==4:return 'GapFill'
    if k==5:return 'GapCont'
    if k==6:return 'Larry'
    if k==7:return {'a':'FiboH4_Multi','b':'FiboH4_Multi','c':'FiboH4_Corso','d':'standalone_Fibo'}[s]
    if k==8:return 'BreakoutCorso' if s=='a' else 'JPY_ext'
def collect(g,a,b,idcol,clscol,eafun,skip=lambda i:False):
    d={}
    for x in rows(g,a,b):
        i=x[idcol]
        if not re.match(r'^\d+[a-z]?$',i): continue
        if skip(i): continue
        t=x[clscol].replace('*','').strip()
        if t.startswith('NM') or t.startswith('NON MISURATO') or t.startswith('EREDITA'):
            s=o=False
        else:
            s='SOPRA' in t or 'MISTA' in t
            o='SOTTO' in t or 'MISTA' in t
        dd=d.setdefault(eafun(i),[False,False,False])
        dd[0]|=s; dd[1]|=o
        if not s and not o: dd[2]=True
    return d
def summ(d,eredita=()):
    ent=so=sb=nm=er=0
    for k,(s,o,n) in d.items():
        if k in eredita: er+=1
        elif s and o: ent+=1
        elif s: so+=1
        elif o: sb+=1
        else: nm+=1
    return dict(righe=len(d),entrambe=ent,soloSOPRA=so,soloSOTTO=sb,NM=nm,EREDITA=er)
# G4 colonna classe=7
d4=collect('G4',31,91,0,7,g4ea)
res['G4']=summ(d4)
# G3: mappa per numero
def g3ea(i):
    k=int(re.match(r'\d+',i).group(0))
    return {1:'MaxMinNotte',2:'DAX_Short_Ott',3:'MFE',4:'BreakinBox',5:'Nightly',6:'Nightly_Ott',7:'PTE',8:'PTE_Ott',9:'WOL',10:'PostNews',11:'Bulge',12:'BULGE_MASTER',13:'LondonFx',14:'AllineaLondra',15:'Londra_ORB(G2)'}[k]
d3=collect('G3',28,65,0,7,g3ea)
d3.pop('Londra_ORB(G2)',None)
# G3 classe colonna: nella tabella e' col 7 ('classe + affid.'), ma 'EREDITA' non contiene SOPRA/SOTTO
res['G3']=summ(d3,eredita=('Nightly_Ott',))
res['G3_dettaglio']={k:v for k,v in d3.items()}
# G2: per EA nome nella col 0; classe col 2; note: righe senza EA ripetono (usare ultimo)
d2={}
for x in rows('G2',23,57):
    if x[0].startswith('`') :
        ea=re.sub(r'`','',x[0]).strip()
        t=x[2].upper()
        s='SOPRA' in t or 'MISTA' in t
        o='SOTTO' in t or 'MISTA' in t
        dd=d2.setdefault(ea,[False,False,False]); dd[0]|=s; dd[1]|=o
res['G2_dettaglio']=d2
res['G2']=summ(d2)

# ---- G1 (ricostruito): 50 righe tabella, id -> numero riga EA del piano
rowsg1=[x for x in rows('G1',33,82) if re.match(r'^\**\d+[a-z]?\**$',x[0])]
cs=co=cn=ered=0; d1={}
for x in rowsg1:
    i=x[0].replace('*',''); t=x[3].replace('*','').strip()
    k=int(re.match(r'\d+',i).group(0)); dd=d1.setdefault(k,[False,False,False,False])
    if t.startswith('EREDITA'): dd[3]=True; ered+=1; continue
    if t.startswith('CONTESA') or t.startswith('NON MISURATO'): s_=o_=False; n_=True
    else: s_='SOPRA' in t; o_='SOTTO' in t; n_=not(s_ or o_)
    dd[0]|=s_; dd[1]|=o_; dd[2]|=n_; cs+=int(s_); co+=int(o_); cn+=int(n_)
ent=so=sb=nm=er=0
for k,(s_,o_,n_,e_) in d1.items():
    if e_: er+=1
    elif s_ and o_: ent+=1
    elif s_: so+=1
    elif o_: sb+=1
    else: nm+=1
res['G1']=dict(righe=len(d1),entrambe=ent,soloSOPRA=so,soloSOTTO=sb,NM=nm,EREDITA=er)
res['G1-celle']=dict(righe_tabella=len(rowsg1),celle_SOPRA=cs,celle_SOTTO=co,celle_NM=cn,EREDITA_righe=ered)
# ---- G3: override esplicito (classe SOPRA scritta senza la parola SOPRA)
d3['AllineaLondra'][0]=True   # riga 14: 'una cella OHLC ~1,01 (IS 0,89: SEGNO INVERTITO)' = SOPRA formale, G3 sez.2 la conta in SOPRA
res['G3']=summ(d3,eredita=('Nightly_Ott',))
# ---- conteggi dichiarati dai gruppi (sezioni dei file)
DICH={
 'G1':dict(righe=26,entrambe=5,soloSOPRA=2,soloSOTTO=3,NM=13,EREDITA=3),
 'G2':dict(righe=14,entrambe=8,soloSOPRA=0,soloSOTTO=1,NM=5,EREDITA=0),
 'G3':dict(righe=14,entrambe=8,soloSOPRA=1,soloSOTTO=2,NM=2,EREDITA=1),   # G3 sez.2 scrive 'solo NM 3' = MFE, BULGE_MASTER + Nightly_Ottimizzato (EREDITA)
 'G4':dict(righe=12,entrambe=7,soloSOPRA=0,soloSOTTO=1,NM=4,EREDITA=0),
 'G5':dict(righe=19,entrambe=12,soloSOPRA=2,soloSOTTO=0,NM=4,EREDITA=1),
 'G6a-A':dict(righe=17,entrambe=8,soloSOPRA=1,soloSOTTO=1,NM=7,EREDITA=0),
 'G6a-T':dict(righe=17,entrambe=6,soloSOPRA=1,soloSOTTO=2,NM=8,EREDITA=0),
 'G6b':dict(righe=14,entrambe=5,soloSOPRA=0,soloSOTTO=4,NM=5,EREDITA=0)}
DICH_CELLE={'G1-celle':dict(righe_tabella=50,celle_SOPRA=17,celle_SOTTO=16,celle_NM=16,EREDITA_righe=3),
            'G5-celle':dict(SOPRA=66,SOTTO=39,NM=6,righe=111)}
ordine=['G1','G2','G3','G4','G5','G6a-A','G6a-T','G6b']
print('gruppo   righe entr soloS soloT   NM EREDITA | esito (riletto dalle tabelle contro dichiarato dal gruppo)')
tot={k:0 for k in ('righe','entrambe','soloSOPRA','soloSOTTO','NM','EREDITA')}
for g in ordine:
    r=res[g]; d=DICH[g]; ok='UGUALE' if r==d else 'DIFFERENTE'
    print('%-7s  %5d %4d %5d %5d %4d %7d | %s' % (g,r['righe'],r['entrambe'],r['soloSOPRA'],r['soloSOTTO'],r['NM'],r['EREDITA'], ok))
    if g!='G6a-T':
        for k in tot: tot[k]+=r[k]
print('TOTALE (G6a nella vista A, con screening): righe %d | entrambe %d | solo SOPRA %d | solo SOTTO %d | NM %d | EREDITA %d' % tuple(tot[k] for k in ('righe','entrambe','soloSOPRA','soloSOTTO','NM','EREDITA')))
print('  => almeno una cella SOPRA (righe proprie) = %d ; almeno una cella SOTTO (righe proprie) = %d' % (tot['entrambe']+tot['soloSOPRA'], tot['entrambe']+tot['soloSOTTO']))
tt=dict(tot); r=res['G6a-T']; 
t2={k:tot[k]-res['G6a-A'][k]+r[k] for k in tot}
print('TOTALE (G6a nella vista T, solo tick): entrambe %d | solo SOPRA %d | solo SOTTO %d | NM %d => SOPRA %d, SOTTO %d' % (t2['entrambe'],t2['soloSOPRA'],t2['soloSOTTO'],t2['NM'],t2['entrambe']+t2['soloSOPRA'],t2['entrambe']+t2['soloSOTTO']))
for k,v in res.items():
    if k.endswith('celle'): print(k,v,'| dichiarato',DICH_CELLE[k], 'UGUALE' if (k=='G5-celle' and v==DICH_CELLE[k]) or (k=='G1-celle' and v==DICH_CELLE[k]) else 'DIFFERENTE')
```

**Output** (sul repo a HEAD `df54239b`):

```
gruppo   righe entr soloS soloT   NM EREDITA | esito (riletto dalle tabelle contro dichiarato dal gruppo)
G1          26    5     2     3   13       3 | UGUALE
G2          14    8     0     1    5       0 | UGUALE
G3          14    8     1     2    2       1 | UGUALE
G4          12    7     0     1    4       0 | UGUALE
G5          19   12     2     0    4       1 | UGUALE
G6a-A       17    8     1     1    7       0 | UGUALE
G6a-T       17    6     1     2    8       0 | UGUALE
G6b         14    5     0     4    5       0 | UGUALE
TOTALE (G6a nella vista A, con screening): righe 116 | entrambe 53 | solo SOPRA 6 | solo SOTTO 12 | NM 40 | EREDITA 5
  => almeno una cella SOPRA (righe proprie) = 59 ; almeno una cella SOTTO (righe proprie) = 65
TOTALE (G6a nella vista T, solo tick): entrambe 51 | solo SOPRA 6 | solo SOTTO 13 | NM 41 => SOPRA 57, SOTTO 64
G5-celle {'SOPRA': 66, 'SOTTO': 39, 'NM': 6, 'righe': 111} | dichiarato {'SOPRA': 66, 'SOTTO': 39, 'NM': 6, 'righe': 111} UGUALE
G1-celle {'righe_tabella': 50, 'celle_SOPRA': 17, 'celle_SOTTO': 16, 'celle_NM': 16, 'EREDITA_righe': 3} | dichiarato {'righe_tabella': 50, 'celle_SOPRA': 17, 'celle_SOTTO': 16, 'celle_NM': 16, 'EREDITA_righe': 3} UGUALE
```

**Controesempio** (regola del 10/09: provare a ROMPERE lo strumento prima di fidarsene). Ho copiato i sette file in una cartella a parte, **cambiato due righe** (G4: riga 8b da NM a SOPRA; G6b: una cella NM spostata in SOPRA) e rilanciato lo script con `RDIR` sulla copia: **G4 e G6b risultano DIFFERENTE** (G4: entrambe 7, solo SOPRA 1, solo SOTTO 1, NM 3 contro 7 / 0 / 1 / 4 dichiarato; G6b: entrambe 6, solo SOTTO 3 contro 5 / 4 dichiarato), le altre sei UGUALI, e il totale cambia (SOPRA da 59 a 61). Lo script **non e' un timbro**: vede le differenze.

## APPENDICE B - CONTROLLO "NESSUN NUMERO NUOVO"

`verifica_numeri.py` legge la tabella principale (sez. 1, righe 1-116) e per ogni numero scritto nelle colonne cella / backtest / regimi / aff. / migliorabile (decimali con virgola e interi, escluse date e id di riga; interi di 1-2 cifre senza virgola esclusi per rumore) controlla che compaia **come numero intero, non come parte di un altro** nel file del gruppo citato. Esito sulla versione finale: **824 numeri controllati, 0 non trovati.** Limite dichiarato: la ricerca e' sul file del gruppo, non sulla riga: un numero potrebbe esistere nel file ma in un'altra cella (confusione di cella). Per questo i numeri sono stati copiati dalle tabelle dei gruppi (non dalle schede) e rimandano all'id di riga.

**Secondo controllo, piu' stretto** (stesso metodo ma sulle sole righe citate dal rimando): per G1, G3, G4, G5, G6a, G6b **597 numeri, 19 fuori dalle righe citate**, tutti spiegati (date e magic; i regimi di BB dalla scheda 4.1 §4 di G4; il "DD 15,8-21,8%" di EasyTrend da G4 sez. 2; il DD IS 10,92% di K03 da G6b sez. 5; 2010-2018 dalla scheda 1 di G1). Per G2 (14 righe, senza id di riga) il controllo e' sulle righe della tabella 0 con lo stesso EA: **110 numeri, 0 fuori**. Controllo di tenuta della tabella: 116 righe, ciascun `#` una sola volta, ogni tabella con lo stesso numero di colonne su tutte le righe, nomi degli EA coerenti con le righe del piano. **Dichiarato**: gli script `verifica_numeri.py` e `verifica_righe.py` stanno nella cartella di lavoro della sessione e **non sono in repo** (solo `conta.py` e' riportato qui sopra).

---

## CHANGELOG
| data | cosa | perche' |
|---|---|---|
| 05/10/2026 | creato il consolidato (sez. 0-5, appendici A-B): 116 righe, 7 gruppi; bozza, NON passata dal cancello | richiesta di Claudio del 05/10/2026: resoconto consolidato di tutti gli EA |
