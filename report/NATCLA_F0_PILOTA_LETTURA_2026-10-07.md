# 🧪 Ea Nat&Cla — il PILOTA F0 riletto dai CSV grezzi (07/10/2026)

**Che cosa e':** la seconda lettura, indipendente, del pilota girato da Claudio sul **PC di backtest** il 07/10 alle 14:50
(8 passate singole, OHLC M1, `InpSoloConta=true`, **nessun ordine**). L'ha fatta il controllo-preventivo, che ha ricontato
tutto con uno script suo, scritto da zero e senza importare il lettore. L'ha poi confrontato con `leggi_natcla_f0.py`.
**Che cosa NON e':** un giudizio di merito. Il Modello 1 conta i SETUP; PF e DD non si leggono (specifica 5.1).
**Dati:** `backtest_pipeline/risultati_archivio/NATCLA_F0_PILOTA_20261007/` · EA `EA_NatCla.mq5` v1.04, SHA256 `681DC882…`
(identico al pin `e2f0506b` e a HEAD) · prova `backtest_pipeline/prove/NATCLA_F0_conteggio_2026-10-07.txt` ·
specifica `report/NATCLA_SPECIFICA_2026-10-07.md`.

## 🎉 In una riga
**La macchina funziona.** EA_NatCla e' stato compilato davvero per la prima volta: **0 errori e 0 avvisi**. Tutti i numeri
del lettore si **riproducono al setup** partendo dai CSV grezzi. L'ADX e' quello di MetaQuotes. Sull'oro il conteggio BCM
cade **dentro** le attese scritte prima dei numeri. **Due cose pero' non vanno:**
- il **Dow non ha contato niente**, per una causa che il pacchetto non permette di dimostrare;
- sul **forex il cancello del costo e' FRA anche nel caso migliore**.

---

## 1. Il conteggio rifatto dai CSV grezzi
Regola della specifica (5.5): **n = SETUP**, cioe' righe con `nuovo_ep=1`, `tocco_n <= limite` (ST25 1, ST30 1, ST35 2,
E200 illimitato; i limiti sono letti dalla riga `#cfg;TocchiMax` di ogni CSV) e `ctx_arm=0`. Il conto e' fatto per linea.
Gli anni vanno dalla barra della riga VERIFICA ADX al 2026.06.30.

| config | simbolo | anni | ST25 | ST30 | ST35 | E200 | **setup** | set/anno | barre distinte | lettore |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| AUDIO_H1 | EURUSD | 1,988 | 231 | 193 | 51 | - | **475** | 239,0 | 427 | identico |
| AUDIO_H1 | GBPUSD | 1,988 | 233 | 191 | 52 | - | **476** | 239,5 | 429 | identico |
| AUDIO_H1 | XAUUSD | 1,974 | 194 | 175 | 41 | - | **410** | 207,7 | 380 | identico |
| M2_H1 | EURUSD | 1,988 | - | - | - | 390 | **390** | 196,2 | 390 | identico |
| M2_H1 | GBPUSD | 1,988 | - | - | - | 360 | **360** | 181,1 | 360 | identico |
| M2_H1 | XAUUSD | 1,974 | - | - | - | 294 | **294** | 148,9 | 294 | identico |
| entrambe | U30USD | - | 0 | 0 | 0 | 0 | **0** | - | - | KO (§3) |

- **Famiglia AUDIO_H1** (3 simboli): **1361** setup contro i 300 richiesti da E3. Divisi al 2025-07-01 fanno
  **705 prima e 656 dopo**, quindi entrambe le meta' superano 150. **Famiglia M2_H1: 1044.** **E0 (>= 70 per simbolo):
  3 vivi su 3.**
- **Il conteggio sull'oro, confrontato con HistData** (stessa regola, attese scritte prima dei numeri):

  | linea | episodi/anno, BCM contro HistData | entro il limite | ADX<=20 alla barra del tocco |
  |---|---|---|---|
  | ST25 | 150,0 / 151 | 98,3 / 101 | 16,7 / 16 |
  | ST30 | 129,7 / 121 | 88,7 / 84 | 13,7 / 18 |
  | ST35 | 92,2 / 97 | 86,1 / 88 | 16,2 / 16 |

  I setup all'anno sono **207,7 contro ~206 (rapporto 1,01)**: tutti i rapporti stanno nella banda 0,5-2 scritta prima, quindi
  **E0 e' COERENTE**. Il contro-esempio torna: contare le RIGHE invece degli episodi darebbe 1039 contro 734, cioe' x1,42.
- 🔴 **Cosa resta fuori da questo n**: con `InpSoloConta` ogni linea conta per conto suo. In campo invece `MaxSetupAperti=1`
  (il semaforo E7) lascia aperto **un solo setup alla volta su tutte le linee**. Le "barre distinte" (427 su 475) tolgono solo
  le collisioni nella stessa barra, **non** i setup che si sovrappongono su piu' barre. Il numero vero di setup operabili e'
  **sotto 427 per EURUSD, e di quanto e' [NON MISURATO]**: si misura solo con le durate, quindi in F1 a tick.
  La famiglia resta comunque larga rispetto a 300.

## 2. VERIFICA ADX — regge, con due precisazioni
Le righe dei log dicono che il valore del terminale coincide con il ricalcolo MetaQuotes **al centesimo**:

| simbolo | valore del terminale | ricalcolo MetaQuotes | ricalcolo Wilder |
|---|---:|---:|---:|
| EURUSD | 41,31 | 41,31 | 41,41 |
| GBPUSD | 25,08 | 25,08 | 34,35 |
| XAUUSD | 15,71 | 15,71 | 21,52 |

Le righe AVVIO sono tutte coerenti: v1.04, modalita AUDIO/EMA200, 1 u e 1 pip giusti per classe (forex 0.0001, oro 1.0,
indice 1.0 con pip 0.01), magic 778601/778621, `iADX MetaQuotes`, `solo conta SI`, placebo 0.
- **Le passate indipendenti sono 3, non 6**: le due configurazioni dello stesso simbolo verificano la **stessa barra sugli
  stessi dati**. Su EURUSD MetaQuotes e Wilder distano solo 0,10 (la tolleranza e' 0,05). La distinzione e' netta lo stesso,
  perche' la distanza dal terminale e' 0,00.
- **Che cosa prova**: che l'`iADX` incorporato in **questa build** usa la formula MetaQuotes. Tester e terminale usano lo
  stesso indicatore, quindi la conclusione vale anche per il campo, finche' la build e' la stessa. La riga **non** prova
  niente sul feed.
- **Il confronto con le attese** (BCM 16,7/13,7/16,2 contro iADX 16/18/16 e Wilder 40/36/36) e' giusto nel verso: i
  rapporti con Wilder sono 0,38-0,45, fuori dalla banda. Ma le attese vengono da **un altro feed** (HistData, orologio +6 h)
  e da **un'altra finestra** (2,19 anni contro 1,97). E' una **conferma**, non una prova: la prova e' la riga VERIFICA.

## 3. 🔴 U30USD: KO, e la causa NON e' quella che dice il driver
Nel MANIFEST il motivo e' *"l'EA non ha mai avuto dati sufficienti: 300 barre del TF"*. **E' una deduzione del driver**,
fatta dall'assenza della riga VERIFICA. **Il giornale del tester la contraddice alla lettera**:
- `U30USD,H1: 2363255 ticks, 9946 bars generated`, `quality of analyzed history is 100%`. Il tester ha quindi avuto
  **~9.950 barre H1** (EURUSD ne ha avute 12.277). Lo storico M1 c'e'. Il simbolo e' giusto e risolto (la riga AVVIO lo
  riconosce come indice/CFD). La finestra e' 2024.09.26-2026.06.30, cioe' il muro BCM degli indici gia' misurato
  (`report/APERTURE_DOW_MAPPA_2026-10-03.md` r.11).
- **L'EA e' rimasto vivo per tutta la finestra.** Ha scritto 990 righe IMBUTO (stampate solo se nel giorno ci sono
  valutazioni). Il CSV ha intestazione e 30 righe `#cfg`, ma **zero CONTA**.
- **Quindi `CaricaDati()` (EA r.1262-1280) ha reso `false` a OGNI barra**, per ~9.950 barre. Se avesse reso `true` una
  volta sola, la riga VERIFICA sarebbe stata stampata (r.1327). Anche il tempo e' coerente con un EA che esce subito:
  "Test passed" in **1,0-1,1 s su tutte e due le configurazioni**, contro 3,6-9,4 s dei simboli che hanno lavorato.
- **Quale delle quattro condizioni cade (r.1266 `Bars<302`, r.1267 `BarsCalculated`, r.1270 `CopyRates`, r.1274-1276
  `CopyBuffer`) e' [NON MISURATO].** Il pacchetto non lo puo' dire, per due ragioni. Il driver **conta** le righe IMBUTO
  ma ne **butta il contenuto**: il campo "linea n/d" direbbe se il guasto e' su ogni barra. E il driver non conserva le righe
  d'errore dell'EA: il filtro tiene solo `[NatCla]` e le righe `Tester`, quindi un `array out of range` non entrerebbe.
- **L'ipotesi piu' probabile**: l'indice e' l'unico simbolo del pilota **senza storia prima di FromDate**. La verifica e'
  cosi': EURUSD l'ha fatta alla barra 2024.07.04 23:00 e XAUUSD alla 2024.07.09 23:00, cioe' **prima** di FromDate, con
  la storia precaricata dal tester. Il riscaldamento **dentro** la finestra, che il collaudo dava per scontato
  (`ESITO_COLLAUDO.txt` punto 5: "indici H4 ~50 giorni…"), **non e' mai stato visto funzionare**. E' un'ipotesi, non una misura.
- **Che cosa serve, prima del lotto C e non dopo.** C ha 10 indici x 6 configurazioni = **60 passate a rischio dello stesso
  KO**. Basta UNA passata diagnostica: `U30USD AUDIO_H1` con **FromDate 2025.01.02**, cioe' con 3 mesi di storia BCM
  davanti (~1.400 barre H1).
  - Se la VERIFICA esce alla barra 2025.01.01 o prima, il guasto sta nel **riscaldamento dentro la finestra**. Allora tocca
    anche H4, H12 e D1 su **tutti** gli indici, e sui TF alti forex se il tester precarica poco.
  - Se non esce nemmeno cosi', il guasto e' del simbolo, e serve una riga di diagnosi dentro l'EA (v1.05, territorio dello
    sviluppatore: **non e' una sedia in forward**).
  - Nello stesso giro conviene mettere nel driver la **somma del campo "linea n/d" delle righe IMBUTO** e le **righe d'errore
    dell'EA** (§7).

## 4. 🔍 Le "123 righe-ordine incoerenti": NON e' un bug dell'EA ne' del lotto. E' arrotondamento in stampa
- Sono **123 sui setup**, e **258 su tutte le righe CONTA**: tutte EURUSD/GBPUSD AUDIO_H1, nessuna sull'oro e nessuna su M2.
  **Tutte e 258** si spiegano con **un punto di arrotondamento** della distanza stampata, sempre -1 punto
  (|p-SL| stampato = 14,9 pip, contro i 15,0 da cui l'EA ha calcolato `stop_ped`), piu' l'arrotondamento a un decimale di
  `stop_ped`.
- **La causa nel sorgente:** `ScriviConta` (r.2099-2113) calcola la scala da `lv0` **grezzo** (`LineaPrezzo`, HL2 +/- k·ATR:
  frazioni di mezzo punto) e divide la distanza **grezza** (15,000 u esatti) per il pedaggio. Poi stampa p e SL con
  `DoubleToString(_Digits)`, che li arrotonda **uno per uno**. Il lettore ricalcola dai prezzi arrotondati, e con spread
  0,1 pip **un punto diventa 1,0 di rapporto** (150 contro 149), oltre la tolleranza `0,06 + 0,2%`.
- **Il percorso che manda ordini veri e' pulito**: `ArmaScala` (r.1426-1430) normalizza **prima** la linea, poi i tre prezzi,
  poi lo SL, e calcola `stopPed` e i lotti (`CalcolaLotti`) dagli stessi prezzi normalizzati. **Nessun errore di stop o di
  lotto.** L'effetto sul cancello E2 e' al massimo 1 punto su 150 (0,7%).
- 👉 E' un **difetto di tolleranza del lettore**: deve ammettere +/-1 punto sulla distanza stampata. Qui e' **dichiarato e
  non corretto**, perche' il mandato era "non cambiare altro" e il conteggio dei setup non ne dipende. Si corregge col
  prossimo ritocco del lettore, con il suo mutante.

## 5. 💸 Il costo (E2): forex FRA nel caso migliore, oro PASSA
Il rapporto e' la mediana di |p-SL| / (spread della riga + commissione), sui setup:

| | ordine 1 (anticipo, 15 u) | ordine 2 (linea, 10 u) | ordine 3 (profondo, 5 u) | spread del tester, mediana |
|---|---:|---:|---:|---:|
| EURUSD AUDIO_H1 | **26,3** FRA | 17,5 FRA | **8,8 ESCLUSO** | 0,10 pip |
| GBPUSD AUDIO_H1 | 20,5 FRA | 13,7 FRA (a filo) | **6,8 ESCLUSO** | 0,20 pip |
| XAUUSD AUDIO_H1 | **62,5 PASSA** | 41,7 PASSA | 20,8 FRA | 0,20 USD |

- **EURUSD con il pedaggio del campo (0,6677 pip)**: 15 pip fanno **22,5x**, 10 pip 15,0x e 5 pip **7,5x**. Per il lavoro
  servono **26,71 pip** di stop e la geometria letterale ne da' **al massimo 15**: **nessun ordine passa il lavoro**,
  l'ordine profondo e' sotto il duro. E' esattamente la previsione della specifica 5.3, ora misurata. Lo stop agganciato
  alla volatilita' (assi A8 e H4) **non e' facoltativo**.
- **Lo spread del Modello 1 e' VARIABILE** (EURUSD da 0,1 a 9,6 pip, viene dalla barra M1). Cosi' si chiude il [NON MISURATO]
  scritto nella prova. Pero' la sua mediana e' **0,10 pip contro 0,20 del campo**: rapporto **0,50, proprio sul bordo** della
  banda "coerente". **Il costo del tester e' ottimista**, e il verdetto vero e' quello con lo spread del campo, qui sopra.
- ⚠️ Il lettore stampa **un solo verdetto per (simbolo, config)**, quello dell'ordine piu' lontano, come operativizzato nella
  prova r.61-62. La stessa prova (r.58-61) promette pero' il verdetto **per ORDINE**, con "ORDINE ESCLUSO PER ARITMETICA"
  sotto 13,3. **Il lettore non stampa che l'ordine profondo del forex e' escluso.** E' una lacuna di stampa: va aggiunta,
  e oggi la colma questa tabella.

## 6. ⏱️ Il tempo
Le passate OK durano 28-40 s (media 33). Il "Test passed" del tester pero' e' solo **1-9 s**: **il ~75-90% della passata e'
costo fisso** (avvio del terminale, attesa di 8 s per i log, raccolta). I TF alti hanno gli **stessi tick M1** e meno
calcolo per barra, quindi la stima regge anche per H4/H12/D1. Il Dow "morto" e' costato comunque 28 s. **F0 intera:
216 x ~30-33 s = 1,8-2,0 h.** Per lotto: A e B 66 passate (~35-40 min), C 66, D 18 (~10 min). I tetti 150/150/150/60 min
hanno margine di 4 volte.

## 7. 🔧 Le riserve sul driver `NATCLA_F0_PASSATE.ps1` (pin `e2f0506b`)
- **Il log di compilazione sul PC di backtest e' in INGLESE**: `Result: 0 errors, 0 warnings, 3657 ms elapsed`. Sul PC
  `DESKTOP-H4D7CAJ` **la riserva sulla lingua NON si conferma**, e il verdetto di compilazione del pilota e' stato letto
  davvero (0 e 0).
- Restano due riserve **teoriche** (classe 1168): `Remove-Item` del vecchio `.ex5` senza controllo (r.315) e lettura del log
  senza aspettare l'uscita di MetaEditor (r.352-354). In questo pilota non sono scattate. Lo provano il log fresco, il SHA
  dell'EA coerente e la versione 1.04 nell'AVVIO di ogni passata. La guardia r.198, che rifiuta di partire con
  MetaEditor/terminale aperti, rende molto improbabile un `.ex5` bloccato.
- **Decisione: lo script NON e' stato toccato e il pin resta `e2f0506b`.** Cambiarlo per una riserva non confermata
  costringerebbe a rifare tutto il collaudo (banco, 30 mutanti, riga) proprio prima dei lotti A, B e D, che col pin
  attuale funzionano. Il cambiamento minimo e' pronto e va messo **insieme** alle due righe di diagnosi per il lotto C
  (§3), in **un solo** nuovo pin:
  1. dopo r.315: `if(Test-Path -LiteralPath $ex5){ FermaCompilazione 'il vecchio .ex5 non si cancella: un compilato vecchio passerebbe per nuovo' }`;
  2. dopo il ciclo r.346-351: `$attE = 0; while(-not $pMe.HasExited -and $attE -lt 30){ Start-Sleep -Seconds 2; $attE = $attE + 1 }`;
  3. r.356, regex in due lingue: `'(\d+)\s+(?:errors?|errori),\s*(\d+)\s+(?:warnings?|avvisi)'`;
  4. diagnosi: sommare il campo `linea n/d` delle righe `[NATCLA-IMBUTO]` e tenere le righe con `critical|array out of range|zero divide`;
  5. poi `bootstrap.py <nuovo pin> <lotto>` e `collaudo.sh <nuovo pin>`, con i mutanti nuovi.
- Si aggiunge una **finestra mai letta**: lo stato e' `OK_FINESTRA_NON_LETTA` su 8 passate su 8, perche' la regex `$reFin`
  (r.389) non trova la riga di intestazione del tester. Le prove indirette sono coerenti: VERIFICA alla barra prima di
  FromDate, primo setup 2024.07.05 13:00, ultimo 2026.06.29. Ma **la finestra girata non e' verificata dal driver**.

## 8. Che cosa dimostra il pilota, e che cosa no
- ✅ **Dimostra**:
  - l'EA compila e gira in SoloConta senza mandare ordini, su forex e oro;
  - il conteggio e' **riproducibile al setup** dai CSV grezzi;
  - l'ADX e' l'`iADX` MetaQuotes;
  - la frequenza basta largamente per E3 (1361 per la famiglia AUDIO_H1);
  - sull'oro BCM il conteggio coincide con quello di HistData;
  - il costo del forex con la geometria letterale e' FRA anche con lo spread ottimista del tester.
- ❌ **Non dimostra**:
  - nessun merito: nessun PF e nessun DD, perche' il Modello 1 puo' solo bocciare;
  - funziona su **un solo regime** (oro +69,7% fra primo e ultimo tocco [PROXY]; EURUSD +5,3%, GBPUSD +3,4%), quindi
    l'Emendamento C non e' soddisfatto;
  - niente sugli indici;
  - il numero di setup **operabili** col semaforo E7.

## 9. 🚀 Come lanciare i lotti
1. **A, B e D adesso, col pin `e2f0506b` e le righe gia' generate.** Sono solo forex e argento, cioe' le classi che il pilota
   ha visto funzionare. Bersaglio: 🖥️ **finestra PowerShell sul PC di backtest**, che usa `C:\MT5_Backtest`
   (`50504400`). Non tocca nessun terminale del VPS (`50503392`, `50504263`, `10105439`, FTMO `541452707`). Ogni riga va
   **riverificata dal cancello** prima di uscire. I round non girano sul VPS: regola del 21/09.
   ⚠️ L'argento (XAGUSD) non e' nel pilota: se esce KO come il Dow, il guasto e' lo stesso del §3.
2. **C fermo** finche' la passata diagnostica del §3 non dice dove cade `CaricaDati`. Se il guasto e' il riscaldamento,
   per gli indici si sceglie un FromDate con storia davanti, oppure si corregge l'EA. **Lanciarlo cosi' produrrebbe con ogni
   probabilita' 60 KO.**
3. Per leggere: `python3 -I backtest_pipeline/leggi_natcla_f0.py <zip o cartella>`. Da oggi legge anche le cartelle estratte
   su Linux con i nomi a backslash.

## 🔧 Correzione fatta: il lettore e le cartelle con il backslash
`Compress-Archive` scrive i nomi come `csv\natcla_...`. Estratti con Python su Linux diventano **file col backslash nel
nome**, e il lettore in modalita cartella dava **8 KO(lettore) su 8**: misurato rimettendo lo zip in una cartella vuota.
Lo zip invece si leggeva gia', perche' li normalizzava. Ora anche la cartella normalizza e ricorda il percorso vero di ogni
file. Se due file **diversi** hanno lo stesso nome normalizzato, il lettore si ferma con un errore invece di sceglierne uno.
- **autotest 87/87**: 3 controlli nuovi, cioe' zip a backslash, cartella estratta da quello zip con lo stesso SHA del CSV, e
  il contro-esempio dell'ambiguita';
- **mutanti 47/47** presi (2 nuovi: M46 normalizzazione tolta, M47 ambiguita' accettata);
- l'uscita sul pilota vero e' **identica byte per byte** fra zip, cartella riordinata e cartella con i backslash.

## NON COPERTO
- La causa esatta del KO U30USD (§3): serve la passata diagnostica oppure il contenuto delle righe IMBUTO.
- Il numero di setup operabili col semaforo E7: si misura in F1.
- La finestra girata, letta dal driver: la regex non trova la riga (§7).
- PowerShell 5.1 e il driver sul PC vero: qui non si gira niente. Lo script non e' stato cambiato.
- La tolleranza `stop_ped` del lettore e la stampa del verdetto per ordine: dichiarate, non corrette.
