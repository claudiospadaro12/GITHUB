# FORZA FX — la nostra dashboard della forza valutaria (nota per Claudio, 02/10/2026)

**Che cos'e':** la versione NOSTRA della dashboard della guida che hai mandato (matrice
28 coppie x 9 timeframe, forza delle 8 valute, punteggio di confluenza, TOP, correlazioni).
**Di sola visione**: non apre ordini, non usa la rete, non scrive file, non tocca il conto.
**Il punto nuovo**: i numeri della forza si possono **ricalcolare a mano** (o con un comando)
dalle righe che la dashboard stampa nella scheda Esperti. Nei nostri verbali la forza
valutaria e' sempre stata **letta a colori e mai misurata** (Emiliano 09/09 G4; Paolo 03/09
Y8, "CHF -0,26 e JPY +0,25: tutti e due negativi?"). Qui ogni numero ha la sua formula.

> 🔴 **NIENTE misure di performance in questo giro.** La dashboard si costruisce prima e si
> misura dopo. Un colore verde non e' un segnale validato: nessuno (ne' la guida ne' noi) ha
> mai contato quante volte "STRONG BUY" e' stato seguito da un rialzo.

File:
- indicatore: `mql5/Indicators/ABTG_ForzaFX_Dashboard.mq5`
- specifica con tutte le scelte: `docs/FORZA_FX_SPEC_2026-10-02.md`
- collaudo (senza MetaEditor): `python3 backtest_pipeline/collaudo_forza_fx.py`

---

## 1. La formula, in chiaro

**Periodo:** non c'e' un periodo da scegliere. Ogni cella guarda **la candela IN CORSO** del suo
TF contro la candela precedente: la cella D1 e' "oggi finora", W1 "questa settimana", MN
"questo mese", M1 "questo minuto".

**Stato della cella** (C = prezzo attuale, O0 = apertura della candela in corso, H1/L1 =
massimo/minimo della precedente, H0/L0 = massimo/minimo finora):

| stato | quando | valore | colore |
|---|---|---|---|
| UP_BREAK | C > H1 | +2 | verde scuro |
| UP | C > O0, dentro il range precedente | +1 | verde chiaro |
| FAIL_DN | ha sfondato L1 ed e' rientrato | +0,5 | grigio |
| FAIL_UP | ha sfondato H1 ed e' rientrato | -0,5 | nero |
| DN | C < O0, dentro il range precedente | -1 | rosso chiaro |
| DN_BREAK | C < L1 | -2 | rosso scuro |
| NEUTRO / doppio fail | C = O0 / ha sfondato da tutti e due i lati | 0 | bianco / grigio scuro |

Il **bordo** della cella e' verde se C > O0, rosso se C < O0.

**Pesi per TF** (dalla guida, verificati: somma 62, e D1+W1+MN = 45/62 = 72,6%, cioe' il "73%"
della guida torna):

| M1 | M5 | M15 | M30 | H1 | H4 | D1 | W1 | MN |
|---|---|---|---|---|---|---|---|---|
| 1 | 1 | 2 | 3 | 4 | 6 | 10 | 15 | 20 |

**Forza di una valuta:**
`forza = somma(valore x peso x segno) / (n_coppie x 62 x 2)`, segno **+** se la valuta e' la
base della coppia (EUR in EURUSD), **-** se e' la quotata (USD in EURUSD). Sta sempre fra -1 e +1.

**Identita' che puoi controllare tu:** con tutte le 28 coppie, **la somma delle 8 forze fa zero**.
Se manca una coppia (o una cella non ha dati), non fa piu' zero: la dashboard lo scrive.

## 2. Cosa copiare e dove (2 minuti)

🪟 **Bersaglio: un terminale MT5 DEMO sul PC di BACKTEST, su un grafico SENZA EA — NON il VPS.**
Non va su nessun terminale del VPS (`50503392` in `BCM Markets MT5 Terminal`, `50504263` in
`... MT5 Terminal -V3`, il reale `10105439` in `C:\BCM_Reale`, il FTMO `541452707` in `C:\FTMO`):
e' di sola visione, ma su quei terminali girano le sedie e non c'e' ragione di aggiungere grafici li'.
✋ Prima di toccare MT5, in una 🖥️ **finestra PowerShell sul PC di backtest** stampa quale
terminale e' aperto (riga di sola lettura, non modifica niente) e **annota il numero di conto**
che compare nel titolo del terminale scelto:

```
Get-Process terminal64 | select Id, MainWindowTitle, Path
```

Poi, nel terminale che hai riconosciuto dalla cartella stampata:
1. **File -> Apri cartella dati** -> `MQL5\Indicators\` -> copia li' `ABTG_ForzaFX_Dashboard.mq5`.
2. **F4** (MetaEditor) -> apri il file -> **F7**. Atteso: **0 errori**. Se ci sono avvisi
   (warning), mandaci la scheda Errori: non l'ho mai compilato (qui non c'e' MetaEditor).

## 3. Provarla in 5 minuti

1. **File -> Nuovo grafico** (un simbolo qualunque, es. EURUSD H1). Controlla che in alto a
   destra **non ci sia un EA** (nessuna faccina): la dashboard va su un grafico vuoto.
2. Navigatore -> Indicatori -> `ABTG_ForzaFX_Dashboard` -> trascina sul grafico -> **OK** coi
   valori di default.
3. Scheda **Esperti**: deve comparire
   `[ForzaFX] avvio: 28 coppie, 5 strumenti di correlazione, TF accesi 9, pesi M1=1 ... (somma 62)`.
   Su un terminale BCM i 5 strumenti delle correlazioni esistono tutti (`USOIL` e' il WTI di BCM:
   sul conto BCM `50503392` ci sono gia' stati piazzati ordini su `USOIL`,
   `report/CENSIMENTO_ORDINI_PC.md`). Su un altro broker puo'
   comparire `... non trovato`: quella correlazione resta MIXED, il resto funziona.
4. In **5-10 secondi** le celle passano da **giallo pallido** (nessun dato) ai colori. Quando
   tutte hanno dati compare nel Journal il blocco `[ForzaFX diag] motivo=prima copertura
   completa` (una riga di intestazione, 4 righe "celle", una riga "forze", la somma, 4 righe
   "punteggi").
5. **Controllo a mano di UNA cella** (il piu' importante): passa il mouse su `EURUSD` colonna
   `D1`: il tooltip dice apertura di oggi, massimo e minimo di **ieri** (il lunedi': di
   **venerdi'**, non della candela della domenica sera). Confrontali con il grafico D1 di
   EURUSD (Finestra Dati, Ctrl+D).
6. **Click** su una valuta nel pannello FORZA -> restano solo le sue 7 coppie; di nuovo -> tutte.
   **Click** su una cella -> si apre un grafico **separato** di quella coppia a quel TF; il
   grafico della dashboard **non cambia** (e un grafico con un EA non viene mai toccato).
7. **Click sul titolo** -> stampa la diagnosi. Prima di tutto confronta a occhio **2 valute** del
   pannello FORZA con la riga `forze` della diagnosi (es. `EUR ... forza=+0.1234` deve comparire
   nel pannello come `EUR +0,12`, sulla riga di EUR). Poi selezionala nella scheda Esperti (tasto destro
   -> Copia), incollala in un `.txt` e mandacela: con
   `python3 backtest_pipeline/collaudo_forza_fx.py --diag file.txt` ricalcoliamo le 8 forze
   dalle 28 righe e diciamo se tornano al centesimo.

## 4. Se il broker aggiunge un suffisso

Su BCM i nomi sono senza suffisso (`EURUSD`). Se un broker usa `EURUSD.m`, scrivi `.m` in
`InpSuffisso`: viene aggiunto a tutte le 28 coppie. In alternativa puoi scrivere i nomi
completi direttamente in `InpSimboli` (le valute si leggono dalle prime 6 lettere). I simboli
delle correlazioni (`InpSanityMappa`) si scrivono **esatti**, senza suffisso automatico. Un
simbolo che non esiste lo dice nel Journal e la sua riga resta gialla: niente si inventa.

## 5. Cosa NON e' coperto (detto chiaro)

- 🔴 **Non compilato**: il collaudo prova la logica (le funzioni vere estratte dal file e
  compilate in C++, 2,5 mesi di oro M1 veri tick per tick, 54 mutanti del blocco puro presi) ma
  non MetaEditor ne' il disegno a schermo. Il primo F7 e' tuo.
- 🟠 **Il codice di "raccordo"** (quello fra le funzioni pure e lo schermo) e' provato solo in
  parte, e lo dico col numero (classi 1068, 1074, 1076). Dopo i due giri dell'autore, il
  **cancello indipendente** ha scritto 4 giri di mutanti CIECHI su righe nuove e ne ha trovati
  verdi **4 su 37, 14 su 16, 10 su 10, 7 su 10**. Fra i verdi non c'era solo "resa a video": c'erano
  righe che decidono i **dati** (massimo e minimo di `CopyRates` scambiati, TF della colonna
  sbagliato, indici simbolo/TF, una cella azzerata quando i dati non sono pronti) e il **numero**
  del pannello forza preso dalla riga invece che dalla valuta. Il codice su quelle righe e' giusto
  (letto riga per riga); mancava la prova. Ora il collaudo ha **5 controlli di comportamento** sul
  raccordo (nessuna cella si azzera fuori dall'avvio; ogni campo di `CopyRates` al suo posto;
  indici di cella sempre `k = simbolo x 9 + TF`; ogni livello scritto dalla sua variabile; pannello
  forza sempre per valuta) piu' 67 ancore, e **39 mutanti di raccordo presi**. Restano **18 verdi
  dichiarati**: decimali e testi dei tooltip, colori e impaginazione, ridisegno, il click sul titolo
  senza diagnosi, piu' 2 equivalenti. Nessuno di questi puo' aprire un ordine o cambiare il grafico
  della dashboard. **Li copre solo la prova a mano del par. 3.** E vale la lezione del giro 4: su
  righe mai toccate ~7 mutanti su 10 restano verdi, quindi il **controllo a mano di una cella**
  (punto 5) e il confronto del **pannello con la diagnosi** (punto 7) non sono facoltativi.
- **Nessuna misura di performance**: ne' della forza, ne' del punteggio, ne' delle correlazioni.
- **Il punteggio di confluenza** (colonna SEGNALE) e' definito in modo vago dalla guida: le
  quattro formule sono **scelte nostre** dichiarate in spec. sez. 5. E i casi studio della guida
  **non si ricalcolano** con le sue stesse regole (GBPUSD "+94" somma a 91).
- **Gli esempi della guida escono dalla sua formula**: "GBP +1,82", "distanza > 2" sono
  impossibili con la formula scritta (massimo 1, distanza massima 2,0). Seguiamo la formula.
- **Le correlazioni** (DAX-EURUSD ecc.) sono quelle **dichiarate dalla guida, mai misurate**;
  i nomi BCM sono quelli del repo (`D30EUR`, `100GBP`, `225JPY`, `200AUD`, `USOIL` = WTI,
  `docs/BROKER_ESTERNO_MAPPA.md`); Oro-DXY e DAX-WTI non entrano (nessuna delle 28).
- **Le 4 strategie, il protocollo, stop/target/size della guida: NON implementati.** Sono
  regole discrezionali senza un numero di operazioni dietro.
- Il **lunedi'** H4/H1 confrontano con la candela corta della domenica sera (solo il D1 la salta;
  e il D1 smette di saltare il weekend da solo se fra le candele lette c'e' un sabato: cripto).
- Che in MQL5 `MathRound(-89.5)` dia `-90` ("lontano da zero", come in C) e' un'ipotesi
  `[NON VERIFICATA]` in MetaEditor: tocca solo i punteggi con mezzo punto esatto.
- Che `CHART_EXPERT_NAME` di un grafico appena aperto sia leggibile entro 10 secondi (per
  l'allarme "il template ha portato un EA") e' `[NON VERIFICATO]` nel terminale (come per la 951).

## 6. Domande aperte (4)

1. Nella tua foto ci sono celle **bianche**: nella guida il bianco non esiste (c'e' il
   **grigio** del FAIL_DN). Da noi bianco = prezzo **uguale** all'apertura. Il tuo bianco e'
   quello o e' il grigio chiaro? E, se ce l'hai, i numeri di **AUD, CAD, JPY** della stessa
   foto: con la formula della guida AUD+CAD+JPY deve fare circa **-0,20** (gli altri cinque
   sommano +0,20). E' il primo controllo vero sulla dashboard del corso.
2. Il punteggio di confluenza con la formula **letterale** ha massimo **90** per le 23 coppie
   senza correlazione (manca il 10% della correlazione): STRONG BUY quasi impossibile.
   Lasciamo cosi' (fedeli alla guida) o **rinormalizziamo** a 100 quando la correlazione non
   esiste?
3. Su BCM c'e' un **indice del dollaro** (DXY)? Market Watch -> cerca "dx" o "usdx". Basta il
   nome: servirebbe solo per la correlazione Oro-DXY, che oggi resta fuori. (Il petrolio WTI non
   serve chiederlo: su BCM e' `USOIL`, gia' nel repo.)
4. Il corso da' anche il **sorgente** o i **valori esatti** del Confluence Score (come
   contano Allineamento e Rotture)? Con una schermata della loro dashboard in cui si vedono
   **insieme** matrice e forze, possiamo dire se usano davvero la formula scritta.
