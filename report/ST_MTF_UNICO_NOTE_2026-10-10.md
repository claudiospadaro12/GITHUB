# ST MTF con tasto UNICO: note di consegna (10/10/2026)

**File:** `mql5/Indicators/ABTG_ST_MTF_Unico.mq5` (v1.00, 1066 righe, ASCII, fine riga LF, senza BOM)
**SHA256:** `5c731f94d1f1ef26bbb1dfce706497f0a280f7a0abed89b789c38f7a4ecc33c1`
**Collaudo a secco:** `python3 backtest_pipeline/collaudo_st_mtf_unico.py` (usa anche `backtest_pipeline/collaudo_st_mtf_unico_sim.cpp`)
**Stato:** NON ANCORA PASSATO DAL CANCELLO (`controllo-preventivo`). NON ancora compilato in MetaEditor: qui non c'e' MetaEditor.

## 1. Cosa e'

La richiesta (Claudio, per una collega): la sua dashboard **"ST MTF-1"** ha tre tasti SuperTrend
(2.5, 3.0, 3.5), e lei vuole **un tasto UNICO, accanto agli altri, che accende TUTTI E TRE i
SuperTrend e li spegne con lo stesso tasto**.

Il sorgente dell'originale non c'e': abbiamo solo 3 screenshot dei suoi **Dati in Ingresso**.
Quindi l'indicatore e' stato **ricostruito**, con un **nome diverso** (`ABTG_ST_MTF_Unico`)
per non confonderlo con l'originale. Puo' stare installato accanto all'originale; meglio non
attaccarli tutti e due allo stesso grafico (doppie linee).

E' un indicatore di **sola visualizzazione**: nessun ordine, nessun trade, nessun file scritto,
nessuna GlobalVariable, nessun oggetto altrui toccato. Tutti i suoi oggetti iniziano con
`ABTGSTU_` e vengono tolti, uno per uno per nome, quando lo si rimuove.

## 2. Il tasto UNICO

- Sta **subito a destra dei tre tasti ST** (sotto, se la pulsantiera e' in colonna).
- **Lo stesso tasto accende e spegne**: se i SuperTrend abilitati sono **tutti accesi**, un clic
  li **spegne tutti**; in **ogni altro caso** (nessuno, uno o due accesi) un clic li **accende tutti**.
- Colore: **viola** (`clrDarkViolet`, parametro `InpUnicoOnColor`) quando sono tutti accesi,
  **grigio** (`InpButtonInactiveColor`) negli altri casi. Si aggiorna anche quando si usano
  a mano i tre tasti ST.
- Un SuperTrend disabilitato (`InpEnableSTn = false`) non ha tasto e non partecipa a UNICO.
  Con zero SuperTrend abilitati, UNICO non compare.
- Parametri nuovi, sezione `=== Pulsante UNICO ===`: `InpShowUnico` (true), `InpUnicoText`
  ("UNICO"), `InpUnicoWidth` (64), `InpUnicoOnColor` (clrDarkViolet).

### Tabella di verita' (estratta dal codice VERO, compilato e confrontato con la specifica)

Tre SuperTrend abilitati. 1 = acceso, ordine (2.5, 3.0, 3.5).

| Stato prima | UNICO prima | Dopo 1 clic | UNICO dopo | Dopo 2 clic |
|---|---|---|---|---|
| 000 | grigio | 111 (accende tutti) | viola | 000 |
| 100 | grigio | 111 (accende tutti) | viola | 000 |
| 010 | grigio | 111 (accende tutti) | viola | 000 |
| 110 | grigio | 111 (accende tutti) | viola | 000 |
| 001 | grigio | 111 (accende tutti) | viola | 000 |
| 101 | grigio | 111 (accende tutti) | viola | 000 |
| 011 | grigio | 111 (accende tutti) | viola | 000 |
| 111 | viola | 000 (spegne tutti) | grigio | 111 |

Con il 3.0 disabilitato: 000/100/001 -> 101 (viola); 101 -> 000 (grigio); il 3.0 non viene mai toccato.
Provati in tutto 64 casi (8 combinazioni di abilitazione x 8 stati), anche al secondo clic.

## 3. Cosa e' stato preso dagli screenshot (FATTO)

Tutti i parametri, con **stesso nome, stesso valore di default, stesso ordine delle sezioni**:
Layout Pulsantiera, Dimensioni UI, Parametri SuperTrend, Abilita SuperTrend, DEFAULT SuperTrend
Attivi, Opzioni Avanzate, Stile Linee SuperTrend, Colori Linee per Timeframe, Label Livelli
SuperTrend, DEFAULT Timeframe Attivi, Colori Pulsanti (92 voci fra sezioni e parametri: il
collaudo le confronta una per una). Ogni descrizione **comincia col nome del parametro**
(es. `InpCorner - angolo della pulsantiera`), cosi' la collega puo' confrontare riga per riga con
l'originale anche se l'originale mostrava i nomi nudi.

## 4. Cosa e' stato DEDOTTO (non si vede negli screenshot)

Ogni deduzione e' scritta anche in testa al file come `[DEDOTTO n]`.

1. **Tasto principale "ST MTF"** (`InpMainButtonWidth`): apre/chiude la pulsantiera; le linee
   restano come sono. Verde (`InpButtonMainColor`) aperta, rosso (`InpButtonOffColor`) chiusa.
2. **11 tasti TF** M1 M3 M5 M15 M30 H1 H4 H12 D1 W1 MN1: acceso = `InpButtonOnColor` (Lime),
   spento = `InpButtonInactiveColor`. **M3 e H12 sono timeframe nativi di MT5** (`PERIOD_M3`,
   `PERIOD_H12`, gia' usati in altri file del repo).
3. **3 tasti "ST 2.5" "ST 3.0" "ST 3.5"**: acceso = `InpButtonSTActiveColor` (Crimson).
4. **Tasto comando "DEFAULT"** (`InpCommandButtonWidth`, `InpButtonDefaultColor`): rimette TF e
   ST ai valori DEFAULT dei parametri.
5. **Ordine a schermo**: ST MTF | 11 TF | 3 ST | UNICO | DEFAULT.
6. **Una linea orizzontale per ogni TF acceso x ST acceso**, al livello attuale del SuperTrend
   **calcolato su quel TF**, colore del TF, stile e spessore del suo ST. Il livello e' quello
   della **barra in formazione** di quel TF (come lo si vede sul grafico di quel TF: puo' cambiare
   finche' la barra non chiude).
7. **Etichetta** "`<TF> <moltiplicatore> VERDE|ROSSO [prezzo]`", a `InpLabelRightOffsetPx` (280)
   px dal bordo destro, `InpLabelVerticalOffsetPx` (-8) px rispetto alla linea (= un po' sopra).
   Colore: `InpLabelSameColorAsLine` vince; poi `InpLabelColorByTrend` (Lime su / Red giu');
   altrimenti `InpFixedLabelColor`.
8. **Stato dei tasti conservato al cambio di simbolo/TF** del grafico (in un oggetto invisibile del
   grafico, niente file). Si riparte dai DEFAULT quando si cambiano i parametri o si rimette
   l'indicatore.
9. **Ordine dei parametri di stile**: Style1, Style2, Style3, poi Width1, Width2, Width3 (come
   elencati; l'originale potrebbe alternarli: non cambia niente nel funzionamento).

Calcolo del SuperTrend: **la stessa funzione `SW_STCore` della SuperWave v4.1**, copiata identica
(il collaudo lo verifica carattere per carattere): ATR = media semplice del True Range (la
convenzione di `iATR` di MT5), bande che si stringono soltanto. Se l'originale usa un'altra
variante (per esempio ATR di Wilder), i livelli possono differire di poco: e' la prima cosa da
confrontare (sezione 7).

## 5. Cosa NON si vede e quindi NON e' garantito uguale all'originale

- il **comportamento esatto** dei tasti comando dell'originale (ce n'e' solo "DEFAULT"? ce ne sono
  altri, tipo "tutti accesi/tutti spenti"? Il colore `InpButtonOffColor` rosso fa pensare a
  qualcosa che qui e' stato assegnato al tasto principale chiuso);
- la **grafica** dell'originale (testi dei tasti, bordi, posizione delle etichette, se le linee
  sono orizzontali intere o segmenti);
- se l'originale disegna il livello della **barra chiusa** o di quella **in formazione**;
- se l'originale conserva lo stato dei tasti al cambio di TF;
- la formula esatta del suo ATR.

## 6. Come installare (sul PC della collega)

1. Copiare `ABTG_ST_MTF_Unico.mq5` nella cartella `MQL5\Indicators` del suo MetaTrader 5
   (MT5: menu **File > Apri cartella dati**, poi `MQL5\Indicators`).
2. Aprire il file in **MetaEditor** (doppio clic, oppure dal Navigatore) e premere **F7** (Compila).
3. In MT5, Navigatore > Indicatori > clic destro > **Aggiorna**; poi trascinare
   **ABTG_ST_MTF_Unico** sul grafico.

## 7. Cosa controllare dopo

1. **Compilazione: 0 errori, 0 avvisi** (scheda "Errori" in basso in MetaEditor). Se compare anche
   un solo avviso, mandarne la riga esatta.
2. In alto a sinistra la pulsantiera: **ST MTF | M1 ... MN1 | ST 2.5 | ST 3.0 | ST 3.5 | UNICO | DEFAULT**.
   **UNICO subito a destra di ST 3.5.**
3. All'avvio: accesi **H1 H4 H12 D1** e **ST 3.5**; UNICO **grigio**; entro 1-2 secondi 4 linee
   tratteggiate (H1 blu, H4 rosso, H12 corallo, D1 verde) con la scritta VERDE/ROSSO.
4. **Clic su UNICO**: accende tutti e tre gli ST (12 linee), UNICO diventa **viola**.
   **Secondo clic**: li spegne tutti e tre, UNICO torna **grigio**.
5. Coi tre tasti ST a mano: UNICO e' viola **solo** quando sono accesi tutti e tre.
6. **Confronto coi livelli dell'originale**: stesso grafico, stesso TF, stesso ST (per esempio H4
   3.5): le due linee devono coincidere o quasi. Se differiscono di molto, vedi sezione 8.
7. Cambiare TF del grafico (per esempio M5 -> M15): i tasti tengono lo stato.
8. Togliere l'indicatore: devono sparire **tutti** i suoi tasti e linee, e nient'altro.

## 8. Se qualcosa non torna

- **Errori o avvisi in compilazione**: mandare a Claudio la schermata della scheda "Errori" (riga e
  testo). Niente va corretto a mano.
- **Una linea manca** su un TF: nella scheda **Esperti** dopo 60 s compare una riga
  "`<TF> su <simbolo> senza dati sufficienti`": lo storico di quel TF non e' ancora arrivato
  (succede la prima volta su W1/MN1 o su un simbolo nuovo). Aprire una volta il grafico di quel TF
  di solito basta.
- **Livelli diversi dall'originale**: mandare due schermate (originale e questo) sullo stesso
  grafico, con il valore di una linea: si capisce se cambia la formula dell'ATR o la barra usata.
- **Scritte sovrapposte**: due linee molto vicine danno scritte una sopra l'altra (le etichette non
  si impilano). Si puo' spegnere `InpShowLevelLabels` o qualche TF.
- **Tasti illeggibili** (testo bianco su verde Lime): cambiare `InpButtonOnColor` o
  `InpButtonTextColor`.
- **Pulsantiera in un altro angolo** (`InpCorner` diverso da in alto a sinistra): non provato su un
  terminale vero; se i tasti escono dallo schermo, rimettere `CORNER_LEFT_UPPER` e segnalarlo.

## 9. Collaudo a secco (cosa prova e cosa NON prova)

`python3 backtest_pipeline/collaudo_st_mtf_unico.py` -> **325 controlli ok, 0 FAIL** sul file con lo SHA256 sopra.

- **A) logica UNICO**: le funzioni pure **vere**, estratte dal `.mq5` e compilate C++
  (`-Wall -Werror`), contro una specifica scritta dal testo della richiesta: 64 casi + doppio clic.
- **B) calcolo**: `SW_STCore` identica a quella della SuperWave v4.1 (gia' collaudata).
- **C) statica**: i 92 input contro gli screenshot; nessuna API vietata (ordini, file,
  GlobalVariable, `ObjectsDeleteAll`, `ChartSet*`, `Sleep`); ogni oggetto nasce dal prefisso ed e'
  ripulito per nome; timer acceso e spento; ASCII senza BOM.
- **D) simulazione del codice intero**: il `.mq5` tradotto in C++ con sostituzioni meccaniche e
  compilato con AddressSanitizer/UBSan sopra finti MQL5 (oggetti, CopyRates sintetico, array con
  controllo dei limiti). Sessione completa in 4 varianti (base, ST2 disabilitato, in colonna, angolo
  destro): posizioni e colori dei tasti, linee e etichette, 360 confronti livello = SuperTrend sulla
  barra in formazione, ridisegno solo se cambia qualcosa, dati mancanti (mai una linea inventata o
  vecchia), cambio TF, gara fra vecchia e nuova istanza (autoriparazione), rimozione senza fughe,
  oggetto altrui intatto.
- **Contro-esempi**: 20 mutazioni del sorgente vero (clic sbagliato, abilitazione ignorata, ordine dei
  tasti, fuga di oggetti, valore vecchio riusato, barra chiusa invece che in formazione, accesso fuori
  array, ...): **tutte prese**. Due controlli all'inizio NON le prendevano (ordine dei tasti guardato
  solo sulla prima occorrenza; prezzo guardato su un solo TF dove la barra chiusa e quella in
  formazione coincidevano): sono stati rinforzati prima della consegna.

**NON prova**: la compilazione MQL5 vera (firme esatte delle funzioni di MT5, avvisi specifici di
MetaEditor), la grafica reale (dimensioni dei testi, angoli diversi da in alto a sinistra con un
terminale vero), il comportamento di `CopyRates` su storico reale che si scarica, e l'uguaglianza
con l'originale "ST MTF-1".
