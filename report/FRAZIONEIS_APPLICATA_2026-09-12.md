# 🔓 `@FRAZIONEIS` APPLICATA — la corsia sottile e' in pari, e la toppa e' uscita piu' robusta di come e' entrata

**12/09/2026** · branch `lavoro` · driver `backtest_pipeline/walkforward_generico.ps1`
**Mandato**: applicare la direttiva `@FRAZIONEIS` come progettata in
`report/SBLOCCARE_I_VENTI_2026-09-12.md` — **non ridisegnarla** — e rimettere in
pari `RIGA_SOTTILE_ROUND.ps1`, cosi' che i ~20 file prova che dichiarano un
taglio IS/OOS 0.50 nei propri criteri possano girare sulla corsia ROUND **senza
nessuna firma nuova di Claudio**.

## 📄 AVVERTENZA SU QUESTO DOCUMENTO
🚫 **Qui dentro NON c'e' NESSUNA riga di lancio.** Niente da mandare a Claudio,
niente da incollare sul VPS, **nessun terminale MT5 da aprire**. Tutti i blocchi
recintati sono `console` — trascrizioni di comandi che ho lanciato **io su questa
macchina Linux**, con la loro uscita vera — o `text` (citazioni di sorgente che
sta gia' nel repo). Nessuna delle prove qui sotto ha sfiorato il VPS, e **nessuno
dei quattro terminali MT5** (`50503392` · `50504263` · `10105439` · `50504400`)
e' stato toccato: `pwsh` gira su Linux, con `-SoloControllo`, che si ferma
**prima** di aprire MT5.

---

# 1️⃣ IL RISULTATO IN UNA RIGA

🟢 **FATTA, PROVATA, E CON UN BUCO IN PIU' CHIUSO** — un buco che ho trovato
provando a rompere la mia stessa toppa, non leggendola.
**+170 / −0 righe** nel driver. Zero regressione, **misurata sui 19 round in
coda e non assunta**. Cancelli a 0. Pin e impronta rifatti e verificati via
`raw`.

🔴 **E dichiaro subito cos'e' questa consegna: e' PONTEGGIO.** Non ha prodotto
nemmeno una misura di mercato. Vale perche' sblocca ~20 round fermi da settimane
su una sedia (DAX apertura EU, `D30EUR`) — e **quelli** sono lavoro sulla sedia.
A tre settimane da ottobre, venti round fermi per un argomento mancante erano un
collo di bottiglia. Non lo sono piu'.

---

# 2️⃣ COSA HO CAMBIATO, RIGA PER RIGA

Cinque blocchi, tutti **additivi**: `git diff` dice **+170 / −0**, cioe' **non ho
cancellato nemmeno una riga esistente**.

```console
$ git diff --numstat e6c0d70e HEAD -- backtest_pipeline/walkforward_generico.ps1
170     0       backtest_pipeline/walkforward_generico.ps1

$ git diff -U0 e6c0d70e HEAD -- backtest_pipeline/walkforward_generico.ps1 | grep '^@@'
@@ -163,0 +164,8 @@
@@ -177,0 +186,4 @@ param(
@@ -247,0 +260 @@ Write-Host "    MARCATORE_WALKFORWARD_GENERICO_v5_INCLUDE" ...
@@ -573,0 +587,150 @@ if($Direttive.ContainsKey("FINOA")){
@@ -763,0 +927,7 @@ Write-Host ""
```

| # | dove (righe NUOVE) | cosa | perche' |
|---|---|---|---|
| **0** | **r.164-171** | nota di dottrina nel blocco «COMPATIBILITA' DEI MARCATORI» | dichiara che **v6 e' ADDITIVO** e che **v5_INCLUDE non si tocca** perche' le due corsie lo cercano. Chi aggiungera' un v7 legge la regola invece di indovinarla. |
| **1** | **r.186-189** | `[switch]$FrazioneDallaRiga` in `param()`, subito dopo `-FinoDallaRiga` | gemello di `-FinoDallaRiga`: dichiara che `-FrazioneIS` **vince** su `@FRAZIONEIS`. Senza, i due tagli che si contraddicono fanno **morire** la corsa. |
| **2** | **r.260** | `MARCATORE_WALKFORWARD_GENERICO_v6_FRAZIONEIS` | **ACCANTO** al v5, non al suo posto. |
| **3** | **r.587-736** | il blocco `@FRAZIONEIS`, subito **dopo** la chiusura di `@FINOA` | il cuore. ~100 righe di commento (la trappola, la collisione dei 35 script, il buco del parser) + ~50 di codice. |
| **4** | **r.927-933** | `Write-Host ("    taglio IS/OOS: FrazioneIS " + $FrazioneIS)` accanto alle due finestre | **attribuibilita'**: prima il driver stampava le finestre ma **non il taglio che le ha prodotte**. Con `@FRAZIONEIS` il taglio puo' venire dal file prova: senza questa riga il log che il runner pubblica non basta a ricostruirlo. |

## 🔑 IL PEZZO 3, IL CODICE VERO (r.679-736)

```text
foreach($rp in $righeProva){
  if($rp.Trim() -match '^@FRAZIONEIS\s*$'){ Muori (...senza valore...) }   # <-- il buco che ho trovato io
}
if($Direttive.ContainsKey("FRAZIONEIS")){
  $frzTesto = $Direttive["FRAZIONEIS"]
  if($frzTesto -notmatch '^[0-9]*\.?[0-9]+$'){ Muori (...non e' un numero decimale con il PUNTO...) }
  $frzNum = [double]::Parse($frzTesto, [Globalization.CultureInfo]::InvariantCulture)
  if($frzNum -le 0.0 -or $frzNum -gt 1.0){ Muori (...e' fuori campo: ammesso 0 < f <= 1...) }
  if($PSBoundParameters.ContainsKey("FrazioneIS")){          # <<< LA CHIAVE
    if([math]::Abs($FrazioneIS - $frzNum) -gt 0.000001){
      if($FrazioneDallaRiga){ ...riquadro magenta... }
      else { Muori ("DUE TAGLI IS/OOS, DIVERSI, E NON SCELGO IO...") }
    }
  } else {
    $FrazioneIS = $frzNum
    Write-Host ("    taglio IS/OOS preso da '@FRAZIONEIS' nel file prova: " + $FrazioneIS)
    if($FrazioneIS -ge 1.0){ ...ATTENZIONE: gamba OOS DEGENERE... }
  }
}
```

🔴 **`$PSBoundParameters.ContainsKey("FrazioneIS")`, e NON `-not $FrazioneIS`.**
E' il punto su cui il mandato insisteva, ed e' il paragrafo 3 qui sotto.

---

# 3️⃣ 🔴 IL CONTRO-ESEMPIO — non ho verificato che la mia risposta fosse coerente: ho provato a ROMPERLA

## 💀 3.a — LA TRAPPOLA 1, RIPRODOTTA CON `pwsh` VERO
Non "ragionata", non "citata dal referto precedente": **rieseguita**.

```console
$ pwsh -NoProfile -Command '...'
cultura corrente        : it-IT
separatore decimale     : [,]

--- LO SCHEMA NAIF, [double]$t : che cosa fa su locale italiana ---
  [double]"0.50"                       = 0.5
  [double]::Parse("0.50") (no cultura) = 50        <<<<<< CINQUANTA
--- LO SCHEMA DEL DRIVER, con InvariantCulture ---
  [double]::Parse("0.50",Invariant)     = 0.5
--- E LA TRAPPOLA 1, riprodotta: (-not <double>) ---
  (-not 0.40) vale : False   <-- schema @SIMBOLO: condizione SEMPRE falsa, direttiva IGNORATA
  (-not 0.0)  vale : True    <-- e con -FrazioneIS 0 la logica si INVERTE
  (-not "")   vale : True    <-- perche' su [string] lo schema @SIMBOLO invece FUNZIONA
```

🟢 **Due cose in un colpo, e la seconda non era nel mandato:**
1. `(-not 0.40)` e' `False` → lo schema di `@SIMBOLO` avrebbe **ignorato sempre**
   la direttiva. E `(-not "")` e' `True` → **ecco perche' su `@SIMBOLO`,
   `@PERIODO`, `@DAQUANDO` quello schema invece funziona**: sono `[string]` con
   default `""`. La differenza non e' stilistica, e' di tipo.
2. 🔴 **`[double]::Parse("0.50")` senza cultura su locale `it-IT` restituisce
   `50`.** Il driver usa `InvariantCulture` e restituisce `0.5`. Il VPS ha
   locale italiana: **questa non e' teoria.**

## 💀 3.b — E POI HO COSTRUITO IL DRIVER SBAGLIATO, E L'HO FATTO GIRARE
Perche' «(-not 0.40) e' False» e' un fatto sul linguaggio, non sulla toppa. Ho
scritto un `walkforward_GUASTO.ps1` **identico al mio tranne una riga** — la mia
guardia sostituita dalla riga "ovvia" per analogia con `@SIMBOLO` — e li ho
lanciati **sullo stesso file prova, con lo stesso comando**:

```console
########## IL DRIVER GUASTO, sul file che dichiara 0.50 ##########
   EXIT=0
       MARCATORE_WALKFORWARD_GENERICO_v6_FRAZIONEIS      <-- PROMETTE la capacita'
       taglio IS/OOS: FrazioneIS 0.4                     <-- e gira a 0.40
       IS  2024.09.26 - 2025.06.09
       OOS 2025.06.10 - 2026.06.30

########## IL DRIVER VERO, stesso file, stesso comando ##########
   EXIT=0
       taglio IS/OOS preso da '@FRAZIONEIS' nel file prova: 0.5
       taglio IS/OOS: FrazioneIS 0.5
       IS  2024.09.26 - 2025.08.13
       OOS 2025.08.14 - 2026.06.30
```

🔴 **Il driver guasto esce con 0, stampa il marcatore che promette di leggere la
direttiva, e produce la finestra SBAGLIATA senza una riga di avviso.** E' il
guasto travestito da riparazione, visto in faccia. **Questa e' la prova che il
paragrafo 3 non e' pedanteria.**

## 🟢 3.c — LA VERIFICA CONTRO NUMERI SCRITTI DA QUALCUN ALTRO (regola del 10/09)
Non ho verificato la mia formula contro se stessa. Le due finestre che escono nel
caso 1 sono confrontate con quelle che **`R128b` dichiara da mesi**:

```console
$ grep -n '2025.08.13\|2025.08.14' backtest_pipeline/prove/R128b_bersaglio_D30EUR.txt
103:#          IS  2024.09.26 -> 2025.08.13   230 feriali   ~163 ingressi
104:#          OOS 2025.08.14 -> 2026.06.30   229 feriali   ~162 ingressi
```
✅ **Identiche al giorno.** E l'Emendamento A e' rispettato: ~163 e ~162, sopra
il pavimento di 150.

## 🎯 3.d — IL CONTRO-ESEMPIO CHE DISCRIMINA
«Con la direttiva esce 2025.08.13» da sola non dice niente: **quale numero
produce l'ALTRA spiegazione?** Stesso comando, stesso driver, file **senza** la
direttiva:

```console
########## CONTRO-ESEMPIO: stesso comando, file SENZA @FRAZIONEIS ##########
    taglio IS/OOS: FrazioneIS 0.4
    IS  2024.09.26 - 2025.06.09
    OOS 2025.06.10 - 2026.06.30
###EXIT=0
```
✅ **La banda separa i due casi**: 2025.08.13 con la direttiva, 2025.06.09 senza.
**65 giorni di calendario, ~33 operazioni.** Il test distingue, quindi il suo
"0.5" dice qualcosa.

---

# 4️⃣ LE QUATTRO USCITE + LE SEI VALIDAZIONI, ESEGUITE

`pwsh 7.4.6`, driver vero, EA vero (`ABTG_DAX_Apertura_EU`, 2368 righe
scaricate), copia vera di `R128b` con `@FRAZIONEIS 0.50` inserita dopo
`@DAQUANDO`, sempre con `-SoloControllo`.

## 🪑 CASO 1 — nessun `-FrazioneIS`, file dice `0.50` (**e' il caso della corsia sottile**)
```console
=== WALK-FORWARD GENERICO - ABTG_DAX_Apertura_EU ===
    MARCATORE_WALKFORWARD_GENERICO_v5_INCLUDE
    MARCATORE_WALKFORWARD_GENERICO_v6_FRAZIONEIS
    sorgente: 2368 righe
    include nostri pronti: 3 su 3
    input trovati: 82   (blindati al default: 82)
    taglio IS/OOS preso da '@FRAZIONEIS' nel file prova: 0.5
--- controlli ---
    parametri in [TesterInputs] : 81
    spazzolati                  : 1
        InpTP1_R                   7 celle
    celle per finestra          : 7   ->  14 pass a tick reali in tutto
    controlli passati.
    taglio IS/OOS: FrazioneIS 0.5
    IS  2024.09.26 - 2025.08.13   (qui si sceglie)
    OOS 2025.08.14 - 2026.06.30   (qui si verifica, e NON si guarda per scegliere)
=== SOLO CONTROLLO: MT5 non e' stato aperto ===
###EXIT=0
```

## 🔴 CASO 2 — `-FrazioneIS 0.40` + file `0.50` → **MUORE** (e' il caso dei 35 script)
```console
###EXIT=1
!!! DUE TAGLI IS/OOS, DIVERSI, E NON SCELGO IO.
    -FrazioneIS passato a mano : 0.4
    '@FRAZIONEIS' nel file     : 0.5
    Il file prova dice che il campione si taglia in un punto, la riga
    di lancio ne dice un altro. Le due finestre IS/OOS che ne escono
    sono DIVERSE, e le soglie sono firmate su UNA delle due: una delle
    due e' sbagliata, si guarda QUALE.
    Se la differenza e' VOLUTA, si dichiara: aggiungi -FrazioneDallaRiga.
```

## 🟣 CASO 3 — `-FrazioneIS 0.40 -FrazioneDallaRiga` + file `0.50` → divergenza DICHIARATA
```console
###EXIT=0
*********************************************************************
  ATTENZIONE: IL TAGLIO IS/OOS NON E' QUELLO DEL FILE PROVA.
    '@FRAZIONEIS' nel file   : 0.5
    -FrazioneIS usato DAVVERO: 0.4
  Vince la riga di lancio perche' e' stato passato -FrazioneDallaRiga.
  I numeri che escono NON descrivono la cella del file prova.
*********************************************************************
    taglio IS/OOS: FrazioneIS 0.4
    IS  2024.09.26 - 2025.06.09
    OOS 2025.06.10 - 2026.06.30
```
🟢 **E gira DAVVERO a 0.40**: la finestra che esce e' quella diversa, e il
riquadro lo dice. Non e' un avviso decorativo.

## 🤐 CASO 4 — `-FrazioneIS 0.50` + file `0.50` → **passa muto**
```console
###EXIT=0
  righe che parlano di FRAZIONEIS/divergenza:
3:    MARCATORE_WALKFORWARD_GENERICO_v6_FRAZIONEIS
21:    taglio IS/OOS: FrazioneIS 0.5
    IS  2024.09.26 - 2025.08.13
    OOS 2025.08.14 - 2026.06.30
```
✅ **Nessun riquadro, nessuna morte.** Solo il marcatore e la riga di
attribuibilita'.

## 🧪 LE SEI VALIDAZIONI — e i **due messaggi DISTINTI**
```console
=========== @FRAZIONEIS 0,50   ===  EXIT=1
   !!! la direttiva '@FRAZIONEIS 0,50' non e' un numero decimale con il PUNTO.
       Si scrive come lo vuole il driver: '@FRAZIONEIS 0.50'. Niente virgola,
       niente percentuale, niente frazione con la barra.
=========== @FRAZIONEIS 50%    ===  EXIT=1
   !!! la direttiva '@FRAZIONEIS 50%' non e' un numero decimale con il PUNTO.
=========== @FRAZIONEIS 1/2    ===  EXIT=1
   !!! la direttiva '@FRAZIONEIS 1/2' non e' un numero decimale con il PUNTO.
=========== @FRAZIONEIS 1.5    ===  EXIT=1
   !!! la direttiva '@FRAZIONEIS 1.5' e' fuori campo: ammesso 0 < f <= 1.
       1.0 = UNA SOLA TRANCHE (gamba OOS degenere, si dichiara).
=========== @FRAZIONEIS 0      ===  EXIT=1
   !!! la direttiva '@FRAZIONEIS 0' e' fuori campo: ammesso 0 < f <= 1.
=========== @FRAZIONEIS 1.0    ===  EXIT=0
       taglio IS/OOS preso da '@FRAZIONEIS' nel file prova: 1
       ATTENZIONE: FrazioneIS 1.0 = UNA SOLA TRANCHE. La gamba OOS e' DEGENERE
       (finestra vuota): il CSV _OOS non descrive niente. Dichiaralo nel referto.
       IS  2024.09.26 - 2026.06.30
       OOS 2026.07.01 - 2026.06.30     <-- finestra INVERTITA = vuota, come promesso
```
✅ **`1.5` e `0` NON dicono "non e' un numero decimale"**: 1.5 *e'* un numero
decimale, e' solo fuori campo. Il difetto che il referto di progetto aveva
trovato nella prima stesura **non e' tornato**.

## 🔨 E SETTE PROVE IN PIU', CHE IL MANDATO NON CHIEDEVA
```console
R1) -FrazioneIS 0 + file 0.50  -> EXIT=1  DUE TAGLI IS/OOS (la trappola dell'INVERSIONE non morde)
R2) @FRAZIONEIS -0.5           -> EXIT=1  non e' un numero decimale con il PUNTO
R2) @FRAZIONEIS abc            -> EXIT=1  non e' un numero decimale con il PUNTO
R2) @FRAZIONEIS .5             -> EXIT=0  0.5   IS 2024.09.26 - 2025.08.13
R2) @FRAZIONEIS 1              -> EXIT=0  1     IS 2024.09.26 - 2026.06.30
R2) @FRAZIONEIS 0.5000001      -> EXIT=0  0.5000001  (la tolleranza 1e-6 non e' un colabrodo)
R4) @frazioneis   0.50         -> EXIT=0  0.5   (minuscolo + doppio spazio: il parser normalizza)
R6) @FRAZIONEIS 0.50 # commento-> EXIT=1  non e' un numero decimale (muore RUMOROSO, non indovina)
```

---

# 5️⃣ 🐛 IL BUCO CHE HO TROVATO PROVANDO A ROMPERE LA MIA TOPPA — e non era previsto da nessuno

## Il fatto
```console
######## '@FRAZIONEIS' SENZA VALORE (prima della riparazione) ########
   nel file -> [178:@FRAZIONEIS]
   EXIT=0
       taglio IS/OOS: FrazioneIS 0.4
       IS  2024.09.26 - 2025.06.09
```
🔴 Il parser generico (r.493) accetta solo `^@(\w+)\s+(.+)$`: una riga
`@FRAZIONEIS` **senza valore** non matcha, **non entra in `$Direttive`**, e il
mio blocco non scatta nemmeno. Il file **crede** di aver dichiarato un taglio, il
driver gira a 0.40, **e non dice niente**. 👉 *Lo stesso guasto silenzioso che
questa direttiva ripara, rientrato dalla porta di servizio.*

## 🔍 E IL BUCO NON E' MIO: E' DEL PARSER, ED E' CONDIVISO. Misurato.
```console
######## e lo stesso buco esiste OGGI su @FINOA? prova: '@FINOA' da sola ########
   175:@SIMBOLO  D30EUR
   176:@PERIODO  M5
   177:@DAQUANDO 2024.09.26
   178:@FINOA
   EXIT=0
       OOS 2025.06.10 - 2026.06.30      <-- tira dritto sulla data di fabbrica, muto
```
```console
$ righe @ totali nei file prova: 1969
$ righe @ MALFORMATE (oggi ignorate IN SILENZIO): 5
     backtest_pipeline/prove/ABTG_BandFade.txt           121 '@DAQUANDO'
     backtest_pipeline/prove/ABTG_CanaleLento.txt        142 '@DAQUANDO'
     backtest_pipeline/prove/ABTG_RangeBudget.txt        188 '@DAQUANDO'
     backtest_pipeline/prove/ABTG_TurnaroundTuesday.txt  316 '@DAQUANDO'
     backtest_pipeline/prove/SESSIONREOPEN_ORO_BOZZA.txt 164 '@DAQUANDO'
```

🟢 **Perche' su tre direttive su cinque il buco non morde**: `@SIMBOLO`,
`@PERIODO`, `@DAQUANDO` hanno default `""`, quindi il silenzio lo intercetta il
cancello di r.574-579 (`if(-not $Simbolo){ Muori ... }`). **`@FINOA` e
`@FRAZIONEIS` hanno un default VALIDO**, e quindi no.

## ✅ COSA HO FATTO, E COSA NON HO FATTO — e il perche' e' misurato
- ✅ **Ho chiuso SOLO il mio** (r.679-686), con una guardia che e' un **no-op
  dimostrato**: nessuno dei 675 file prova contiene `@FRAZIONEIS`, figuriamoci
  senza valore. Ora `@FRAZIONEIS` nuda **muore**:
  ```console
  ######## '@FRAZIONEIS' senza valore, ORA ########
     EXIT=1
     !!! nel file prova c'e' una riga '@FRAZIONEIS' SENZA VALORE.
         Cosi' com'e' il parser la BUTTA VIA e il driver gira col taglio di
         fabbrica (0.40) senza dirlo a nessuno: il file crede di aver
         dichiarato una cosa, i CSV ne raccontano un'altra.
         Si scrive col valore attaccato: '@FRAZIONEIS 0.50'.
  ######## '@FRAZIONEIS   ' con soli spazi ########
     EXIT=1  (stesso messaggio: il Trim() lo prende)
  ```
- 🔴 **NON ho toccato il parser, e lo dichiaro invece di farlo di nascosto.** La
  riparazione giusta sta li' e vale per **tutte e cinque** le direttive, ma il
  parser e' **inchiodato al byte da un pin** e cambierebbe il comportamento dei
  **cinque file** qui sopra: oggi muoiono sul cancello di r.574-579, ma **una
  riga di lancio che passi `-DaQuando` a mano li fa girare**, e per loro il
  cambio non e' un no-op. 👉 **Va misurato in un lavoro suo.** Metterlo dentro
  qui, in una toppa progettata per un'altra cosa, sarebbe stato allargare senza
  pagare la prova.

📌 **Classe nuova per `CHECKLIST_RIGA_DI_LANCIO.md`**: *«una direttiva `@NOME`
scritta senza valore non matcha `^@(\w+)\s+(.+)$`, viene buttata via in silenzio,
e se la direttiva ha un default VALIDO il driver gira col default senza avvisare.
Oggi colpisce `@FINOA` e `@FRAZIONEIS`. Provato il 12/09 con `pwsh` vero.»*
🔴 **Non l'ho scritta io in checklist**: quel file e' stato riscritto da un altro
agente 20 minuti prima (commit `394a94e`, −308 righe) e non tocco un file in
mano a qualcun altro. **Va aggiunta**, ed e' il primo NON FATTO del paragrafo 9.

---

# 6️⃣ 🔴 LA REGRESSIONE — la cosa piu' importante, e la prima volta l'ho sbagliata

## 6.a — LA PRIMA CORSA ERA UN FALSO PASS, E LO DICO
Il primo giro ha stampato **19 round su 19 «IDENTICO»**. Sembrava perfetto. **Ma
tutti e 19 uscivano con EXIT=1.** Un fallimento *identico* non e' una regressione
passata: e' due corse che muoiono nello stesso punto e non provano **niente**.

```console
=== ultime righe del round 1 ===
walkforward_generico.ps1: Cannot bind parameter because parameter 'Prova' is
specified more than once.
```
👉 Era un difetto **del mio banco di prova** (passavo `-Prova` due volte), non del
driver. 🔴 **Se avessi guardato solo la colonna "IDENTICO" avrei consegnato un
PASS inventato.** E' esattamente la classe 254 in un'altra veste: **un esito che
non distingue non e' un esito.** Banco riparato, corsa rifatta.

## 6.b — LA REGRESSIONE VERA: driver AL PIN contro driver TOPPATO, sui 19 round della coda
Metodo: estratti i 19 round da `CODA.txt`, lanciato **ciascuno due volte** — una
col driver preso da `git show e6c0d70e:` (quello che la coda scarica **davvero**)
e una col driver toppato — con `-SoloControllo`, e **diffato l'output**
normalizzando solo i percorsi assoluti e le **2 righe di log nuove**.

```console
SHA vecchio (al pin): 62A53763A186195DBE3FB3DAEE01B45A53B80F09BDC831B68046BD50F7CBB7BC
SHA nuovo  (toppato): BF53EC27C98316A8F648009BC2B73B9A9ED6A298C02CBB04E62E3530FAF59875

#   prova                                   Evc  Enu  IS vecchio              IS nuovo                DIFF
1   R132c_nearatr_U30USD.txt                0    0    2024.09.26 - 2025.06.09  2024.09.26 - 2025.06.09  IDENTICO
2   R133b_filtrovolumi_U30USD.txt           0    0    2024.09.26 - 2025.06.09  2024.09.26 - 2025.06.09  IDENTICO
3   R133c_ampiezzabox_D30EUR.txt            0    0    2024.09.26 - 2025.06.09  2024.09.26 - 2025.06.09  IDENTICO
4   R136a_slatr_U30USD.txt                  0    0    2024.09.26 - 2025.06.09  2024.09.26 - 2025.06.09  IDENTICO
5   R136b_primobersaglio_U30USD.txt         0    0    2024.09.26 - 2025.06.09  2024.09.26 - 2025.06.09  IDENTICO
6   R136c_parziale_U30USD.txt               0    0    2024.09.26 - 2025.06.09  2024.09.26 - 2025.06.09  IDENTICO
7   R136d_trailing_U30USD.txt               0    0    2024.09.26 - 2025.06.09  2024.09.26 - 2025.06.09  IDENTICO
8   R127c_orologio_EURJPY.txt               0    0    2020.01.01 - 2022.08.06  2020.01.01 - 2022.08.06  IDENTICO
9   R126a_costo_bufferatr_U30USD.txt        0    0    2024.09.26 - 2025.06.09  2024.09.26 - 2025.06.09  IDENTICO
10  R127b_sllookback_XAUUSD.txt             0    0    2004.06.11 - 2013.04.06  2004.06.11 - 2013.04.06  IDENTICO
11  R126b_stop_lookback_U30USD.txt          0    0    2024.09.26 - 2025.06.09  2024.09.26 - 2025.06.09  IDENTICO
12  R126d_costo_bufferatr_NASUSD.txt        0    0    2024.09.26 - 2025.06.09  2024.09.26 - 2025.06.09  IDENTICO
13  COLLAUDO_EMADOW_05_tf_U30USD.txt        0    0    2024.09.26 - 2025.06.09  2024.09.26 - 2025.06.09  IDENTICO
14  R120b_U30USD_11_vivo.txt                0    0    2024.09.26 - 2025.06.09  2024.09.26 - 2025.06.09  IDENTICO
15  R120b_U30USD_00_nuda.txt                0    0    2024.09.26 - 2025.06.09  2024.09.26 - 2025.06.09  IDENTICO
16  R120b_U30USD_01_notrail.txt             0    0    2024.09.26 - 2025.06.09  2024.09.26 - 2025.06.09  IDENTICO
17  R120b_U30USD_10_noflip.txt              0    0    2024.09.26 - 2025.06.09  2024.09.26 - 2025.06.09  IDENTICO
18  R120e_U30USD_11_vivo_TAGLIA.txt         0    0    2024.09.26 - 2025.06.09  2024.09.26 - 2025.06.09  IDENTICO
19  R120e_U30USD_00_nuda_TAGLIA.txt         0    0    2024.09.26 - 2025.06.09  2024.09.26 - 2025.06.09  IDENTICO
```
✅ **19/19 EXIT=0 su ENTRAMBI** (quindi arrivano davvero alle finestre: l'esito
distingue), **finestre invariate**, output identico.
🟢 E i round **8** e **10** valgono doppio come controllo: hanno finestre
**diverse** (`@DAQUANDO`/`@FINOA` propri, 2020 e 2004) e restano diverse **nello
stesso modo** in entrambi i driver. Se la mia toppa avesse toccato il calcolo
della finestra, quei due sarebbero i primi a spostarsi.

## 6.c — E IL DIFF GREZZO, senza normalizzazione, per far vedere che non nascondo niente
```console
=== DIFF GREZZO (nessuna normalizzazione oltre al percorso) vecchio -> nuovo ===
2a3
>     MARCATORE_WALKFORWARD_GENERICO_v6_FRAZIONEIS
15a17
>     taglio IS/OOS: FrazioneIS 0.4
### righe: vecchio=32  nuovo=34
```
✅ **Esattamente due righe aggiunte, zero righe cambiate, zero righe togliete.**

## 6.d — 🔴 IL CASO DELLA CODA (la regressione numero uno): resta 0.40, e non muore
Il caso che gira stanotte e' **nessun `-FrazioneIS` passato + nessun
`@FRAZIONEIS` nel file**. Provato: `taglio IS/OOS: FrazioneIS 0.4`, `IS
2024.09.26 - 2025.06.09`, **EXIT=0**, nessun riquadro, nessuna morte, nessun
avviso. **Solo una riga informativa in piu'.** ✅
⚠️ **E il fatto va conservato**: `-FrazioneIS` **non viene passato dalla coda**, e
il default del driver e' `0.40`. Oggi coincide con cio' che serve a quei round,
ma **coincidenza non e' garanzia**: il giorno che uno di quei file prova volesse
un altro taglio, ora ha la direttiva per dirlo.

## 6.e — ZERO `@FRAZIONEIS` nel repo, verificato da me e non ereditato
```console
$ grep -rl "@FRAZIONEIS" backtest_pipeline/prove/     ->  0 file  (exit grep = 1)
$ file prova totali (prove/*.txt)                     ->  675
$ @FRAZIONEIS in tutto il repo, escluso report/        ->  nessuna occorrenza
$ script che passano -FrazioneIS                      ->  35
```
🟢 **Quindi la regressione sui 153/675 file prova e sui 19 round e' ZERO per
COSTRUZIONE**, non per fortuna: chi non scrive la direttiva non cambia
comportamento di una virgola.
🟢 **E i 35 script** che passano `-FrazioneIS` esplicitamente sono il **caso 4**
(accordo) o il caso 2 (collisione) — e per essere caso 2 servirebbe un
`@FRAZIONEIS` nel loro file prova, che **non c'e' in nessuno**. Oggi: tutti muti.

## 6.f — LE DUE CORSIE CERCANO `v5_INCLUDE`, E LO TROVANO
```console
$ pwsh -c 'Select-String -SimpleMatch ... (lo STESSO comando delle corsie)'
  MARCATORE_WALKFORWARD_GENERICO_v5_INCLUDE            -> True
  MARCATORE_WALKFORWARD_GENERICO_v3_EXECMODE           -> True
  MARCATORE_WALKFORWARD_GENERICO_v4_TERMINALE_BACKTEST -> True
  MARCATORE_WALKFORWARD_GENERICO_v6_FRAZIONEIS         -> True
```
`RIGA_SOTTILE_ROUND.ps1` r.387 e `RIGA_ROUND_VPS.ps1` r.104 cercano
**`v5_INCLUDE`** con `Select-String -SimpleMatch` **sul FILE scaricato**: e' li',
intatto (x2 nel file). ✅
🟢 **E nessuna delle due parsa lo stdout per posizione o per conteggio righe**:
`RIGA_SOTTILE_ROUND.ps1` r.563-564 lo **ristampa tutto** con un `foreach`. Le 2
righe nuove non possono spostare niente.

---

# 7️⃣ 🔑 IL GIRO DI PIN — l'UNDICESIMO, e la sequenza era cambiata sotto i piedi

## 7.a — LA BASE VERA, verificata da me
Il referto di progetto diceva di partire da `fb9b4731`. 🔴 **Era vecchio**: nel
frattempo un altro agente ha chiuso il **ri-pinnaggio della coda** (`955f6a3`).
Verificato da me, da git, non creduto:

```console
$ grep -v '^#' backtest_pipeline/coda/CODA.txt | grep RIGA_SOTTILE_ROUND | awk '{print $1}' | sort | uniq -c
     19 1445abf80666883ea2f6a4ecb983e91a2eb26834          <-- 19/19, un pin solo
$ grep -c 'fb9b4731\|e6c0d70e\|8027068f\|0c7d98af' backtest_pipeline/coda/CODA.txt
5      <-- e sono TUTTI E CINQUE COMMENTI (r.228, 238, 239, 240, 242), zero righe eseguibili
$ SHA del driver a e6c0d70e : 62A53763...F7CBB7BC  ==  $SHA_WALK scritto   ✅ combacia
```
👉 La catena **era sana** quando ho cominciato: `CODA.txt` → `1445abf8`
(contenitore) → `$PIN = e6c0d70e` (driver) → `$SHA_WALK = 62A53763...`.

## 7.b — 🔴 IL PIN `1445abf8` DELLA CODA RESTA VALIDO E INTENZIONALE, e non l'ho toccato
**`CODA.txt` NON e' stato modificato da me.** I 19 round di stanotte continuano a
scaricare `RIGA_SOTTILE_ROUND.ps1` da `1445abf8`, che pinna il driver a
`e6c0d70e` — **il driver SENZA `@FRAZIONEIS`**. Quindi:
- 🟢 il mio commit **non puo' rompere la coda del weekend**: i pin sono congelati;
- 🟢 e **non doveva provare a entrarci**: nessuno dei 19 file prova dichiara
  `@FRAZIONEIS` (verificato), quindi entrarci **non porterebbe niente** e
  rischierebbe 19 round che girano bene cosi'.

🔴 **E L'ORDINE PER CHI VORRA' PORTARE `@FRAZIONEIS` IN CODA — si sbaglia una
volta sola:**
1. **PRIMA** la riga sottile (`$PIN` + `$SHA_WALK`), commit, push;
2. **POI** la colonna dei pin in `CODA.txt`, sul commit che contiene quella riga.
**Mai il contrario.** Al contrario le righe muoiono su `$SHA_WALK` — che e' il
modo **giusto** di rompersi, ma resta un round perso e una notte buttata.
📌 Ed e' un passo **separato e successivo**, da fare **quando esistono i file
prova che usano la direttiva**. Oggi non esistono.

## 7.c — LE DUE RIGHE NUOVE IN `RIGA_SOTTILE_ROUND.ps1` (**+78 / −2**)
```text
r.338  $PIN       = '115254dc64b2c7ac9493a33b8f5bbc09f814ea1b'
r.381  $SHA_WALK  = 'BF53EC27C98316A8F648009BC2B73B9A9ED6A298C02CBB04E62E3530FAF59875'
r.357  $SHA_ROUND = '348ED5330C18DCD41D736B0709B880A8EC9BF8A4B700B044999BC7099D0A315B'   <-- NON TOCCATA
r.387  $MARC_WALK = "MARCATORE_WALKFORWARD_GENERICO_v5_INCLUDE"                          <-- NON TOCCATO
```
- `$SHA_ROUND` **NON e' stata toccata** — e l'ho **ricalcolata sul blob del pin
  nuovo per dirlo, non assunta**: `348ED533...` a `115254dc` e' identica a
  `348ED533...` a `e6c0d70e`.
- `$MARC_WALK` **resta `v5_INCLUDE`**: nel driver il `v6` e' stato **aggiunto
  accanto**, non al posto.
- 🟢 **La lista bianca sugli argomenti non e' toccata di una virgola.** Lo dice
  il cancello da solo: `param block RICONOSCIUTO (Expert,Prova,Etichetta,
  Modello,Deposito,SoloControllo)` — **zero argomenti nuovi**, zero caratteri
  nuovi ammessi, nessun parametro che possa nominare un percorso.
- Il commento dell'undicesimo giro sta **accanto** agli altri dieci (r.128-337),
  come hanno fatto i dieci prima di me. **Nessun commento vecchio cancellato**
  (−2 righe = le due valorizzazioni sostituite).

## 7.d — 🔴 LA VERIFICA VIA `raw`, che e' la condizione per cui questo giro vale
Il runner scarica da **`raw`**, non da git: verificare solo su git non
dimostrerebbe che la catena funziona.

```console
=== 1) HTTP del driver al pin nuovo ===
  HTTP 200   byte 102955
=== 2) sha256 di quello che ARRIVA da raw ===
  BF53EC27C98316A8F648009BC2B73B9A9ED6A298C02CBB04E62E3530FAF59875
=== 3) sha256 dell'albero locale ===
  BF53EC27C98316A8F648009BC2B73B9A9ED6A298C02CBB04E62E3530FAF59875
=== 4) sha256 del blob git al pin ===
  BF53EC27C98316A8F648009BC2B73B9A9ED6A298C02CBB04E62E3530FAF59875
=== 5) marcatore v5 nel file SCARICATO (e' quello che la corsia controlla) ===
  2
=== 6) la toppa 270 (Remove-Item dell'ex5) e' dentro? ===
  1
=== 7) merge-base: 124db40 (toppa 270) e' antenata del pin nuovo? ===
  SI (exit 0)
=== e i FILE PROVA sono al pin nuovo? (la corsia li scarica dallo STESSO $PIN) ===
  R132c_nearatr_U30USD.txt   -> HTTP 200
  R136a_slatr_U30USD.txt     -> HTTP 200
  R128b_bersaglio_D30EUR.txt -> HTTP 200
```
✅ **Tutti e TRE gli sha combaciano** (`raw` = albero locale = blob git).
🟢 **E la toppa classe 270 del decimo giro resta dentro**: il pin nuovo e'
**discendente**, non un ramo diverso.

## 7.e — 🔑 E L'IMPRONTA PROVATA CON **IL COMANDO DELLA CORSIA**, non col mio
`sha256sum | tr a-z A-Z` e' il *mio* modo di calcolarla. La corsia usa
`Get-FileHash` (r.432 e dintorni). Se i due formati non coincidessero, il round
morirebbe sull'impronta **con l'impronta giusta scritta dentro** — il peggiore
dei fallimenti, perche' manda a cercare il guasto nella rete.

```console
$ pwsh -NoProfile -Command '(Get-FileHash -Algorithm SHA256 <driver scaricato da raw>).Hash'
  Get-FileHash del driver scaricato : BF53EC27C98316A8F648009BC2B73B9A9ED6A298C02CBB04E62E3530FAF59875
  $SHA_WALK scritto nella corsia    : BF53EC27C98316A8F648009BC2B73B9A9ED6A298C02CBB04E62E3530FAF59875
  COMBACIANO                        : True
  marcatore v5 nel file scaricato   : True
```
✅ **Maiuscolo, senza separatori, identico.** Il formato non e' un'assunzione.

## 7.f — E IL CONTRO-ESEMPIO, altrimenti quei "combacia" non valgono niente
```console
=== al pin PRECEDENTE e6c0d70e la toppa @FRAZIONEIS c'e'? ===
  0        <-- la stringa 'FRAZIONEIS' compare ZERO volte nel driver
=== e il suo sha e' DIVERSO da quello nuovo? ===
  62A53763A186195DBE3FB3DAEE01B45A53B80F09BDC831B68046BD50F7CBB7BC
  nuovo: BF53EC27C98316A8F648009BC2B73B9A9ED6A298C02CBB04E62E3530FAF59875
```
✅ **Il controllo distingue i due casi**, quindi il suo "uguale" dice qualcosa.
Se leggete ancora `62A53763...` da qualche parte, il pin punta a un driver
**senza** la direttiva e lo scarico muore sull'impronta: il fallimento giusto.

---

# 8️⃣ 🚦 I CANCELLI — da soli, senza pipe (classe 254)

```console
$ python3 backtest_pipeline/controlla_riga.py --oggetto ps1 backtest_pipeline/walkforward_generico.ps1
  PASSATI (6):
    OK   ASCII puro: walkforward_generico.ps1
    OK   compila: 0 errori dal parser PowerShell vero
    OK   param block RICONOSCIUTO (...,FrazioneIS,Modello,FinoDallaRiga,FrazioneDallaRiga,Deposito,...)
    OK   nessun costrutto pwsh-7-only
    OK   formati .NET
    OK   nessun Parse decimale senza cultura invariante
  ESITO: nessun difetto meccanico.                                      EXIT = 0

$ python3 backtest_pipeline/controlla_prova.py <copia di R128b CON @FRAZIONEIS>
  P_050.txt   ABTG_DAX_Apertura_EU.mq5   pin=81  celle= 7  OK
  file: 1 | celle totali: 7 | passate: 14 | problemi: 0   ESITO: OK      EXIT = 0
```
✅ **Nessuna lista bianca di direttive da aggiornare**: `controlla_prova.py` r.66
salta **ogni** riga che inizia con `@` (`s.startswith("@")`), e l'unico controllo
sulle direttive e' *"manca `@DAQUANDO`"* (r.112). Controllato, non assunto.

## 🔤 ASCII PURO — e il test l'ho provato CONTRO SE STESSO
```console
$ LC_ALL=C grep -nP '[^\x00-\x7F]' backtest_pipeline/walkforward_generico.ps1
   (nessuna riga)   esito grep = 1   ->  ZERO byte non-ASCII   ✅
$ LC_ALL=C grep -nP '[^\x00-\x7F]' <esca con 'è' e un'emoji>
   1:ciao è emoji [emoji]        esito = 0   ->  il test SA trovarli
```
🔴 **E qui ho beccato un difetto nel mio primo controllo**: avevo scritto
`grep -n '[^\x00-\x7F]'` **senza `-P`**, e GNU grep in BRE **non interpreta
`\x`** — il comando "passava" stampando tutto il file. Senza l'esca non me ne
sarei accorto. **Un controllo che non puo' fallire non e' un controllo.**

## 7.g — 🔴 «HO ROTTO LA CODA?» — la domanda si risponde con una misura, non con un ragionamento
Il mio commit sposta `$PIN` dentro `RIGA_SOTTILE_ROUND.ps1`. Le 19 righe in coda
scaricano **una copia congelata** di quel file da `1445abf8`. Che sia davvero
cosi' **l'ho percorso fino in fondo**, come lo percorre il runner:

```console
=== 1) la riga sottile CONGELATA che i 19 round scaricano (pin 1445abf8) ===
  RIGA_SOTTILE_ROUND @1445abf8 -> HTTP 200  byte 30541
=== 2) che PIN e che SHA_WALK porta QUELLA copia ===
  $PIN       = 'e6c0d70ef3bf61efd110ab4c9e7ee46e6ad40e7b'
  $SHA_WALK  = '62A53763A186195DBE3FB3DAEE01B45A53B80F09BDC831B68046BD50F7CBB7BC'
=== 3) il driver a QUEL pin, e la sua impronta contro IL SUO SHA_WALK ===
  driver @e6c0d70e -> HTTP 200  byte 92067
  Get-FileHash                    : 62A53763...F7CBB7BC
  atteso dalla copia congelata    : 62A53763...F7CBB7BC
  LA CODA DI STANOTTE E SANA      : True
  v5_INCLUDE nel driver congelato : True
=== 4) CODA.txt e' stata toccata da me? ===
  (vuoto = NO)
```
✅ **La catena della coda e' intatta e indipendente dalla mia.** I 19 round di
stanotte scaricano il driver **senza** `@FRAZIONEIS` e girano identici a come
sono stati collaudati.

### 🐛 E QUI HO SBAGLIATO UN TEST PER LA TERZA VOLTA OGGI — e lo scrivo
Il controllo sopra, al primo giro, stampava anche:
```console
  FRAZIONEIS nel driver congelato : True      <-- ALLARME
```
cioe' *"la direttiva e' nel driver congelato"*, che sarebbe stato un guaio.
🔴 **Era falso, e la colpa era del mio test**: `Select-String` in PowerShell e'
**case-INsensitive per default**, e stava trovando il **parametro** `$FrazioneIS`
(r.171, r.758) — che nel driver vecchio c'e' da sempre — non la direttiva.
Rifatto con il comando fatto bene:
```console
$ grep -c 'ContainsKey("FRAZIONEIS")' <driver congelato>   ->  0   (nessun blocco)
$ grep -c 'FrazioneDallaRiga'         <driver congelato>   ->  0   (nessuno switch)
$ Select-String -SimpleMatch -CaseSensitive 'FRAZIONEIS'
    congelato -> False        nuovo -> True
```
✅ Il driver congelato ha **solo** il parametro, **non** la direttiva. Come deve.

## 7.h — 📋 TRE DIFETTI, TUTTI E TRE NEL MIO BANCO DI PROVA, NESSUNO NEL CODICE
Li metto insieme perche' raccontano una cosa sola, ed e' la lezione del 10/09:

| # | il test sbagliato | come si travestiva da PASS | come l'ho beccato |
|---|---|---|---|
| 1 | `grep -n '[^\x00-\x7F]'` **senza `-P`** | GNU grep in BRE non interpreta `\x`: il comando stampava tutto il file e non poteva dire "ASCII puro" | l'**esca** con `è` e un'emoji |
| 2 | `-Prova` passato **due volte** nel banco | 19/19 «IDENTICO» con **exit 1 su tutti**: un fallimento identico | ho guardato il **codice d'uscita**, non la colonna |
| 3 | `Select-String` **case-insensitive** | trovava `$FrazioneIS` e diceva che la direttiva era nel driver congelato | il confronto **grep case-sensitive** |

🔴 **Tre volte su tre il difetto era nello strumento che doveva misurare, non
nella cosa misurata.** E tre volte su tre il modo di beccarlo e' stato lo stesso:
**chiedersi quale numero produce l'ALTRA spiegazione**, invece di controllare che
il risultato fosse quello che mi aspettavo. Se avessi letto solo la colonna
"IDENTICO" avrei consegnato tre PASS inventati.

---

# 9️⃣ 🔴 COSA RESTA **NON MISURATO** — detto per intero

0. 🔴 **IL SECONDO STRATO DEL CANCELLO NON L'HO ESEGUITO, E NON POTEVO.** La
   regola del 09/09 vuole **due** strati: `controlla_riga.py` (deterministico) **e**
   l'agente **`controllo-preventivo`** (giudizio). Il primo e' passato su tutti e
   tre i file, da solo e senza pipe. 🔴 **Il secondo no: in questa sessione non ho
   uno strumento per lanciare un sottoagente**, quindi `.claude/agents/controllo-preventivo.md`
   **non e' stato invocato**. Lo dico invece di far finta che un PASS meccanico
   sia un PASS: **non lo e', e la regola lo dice a chiare lettere.**
   🟢 Attenuante di fatto, non di principio: **niente e' uscito verso Claudio o
   verso il VPS.** `CODA.txt` non e' stata toccata, nessuna riga di lancio e'
   stata prodotta, nessun round e' in coda. La condizione bloccante della regola
   — *"niente esce senza un PASS"* — **non e' stata violata**, perche' niente e'
   uscito. 👉 **Ma prima che `@FRAZIONEIS` entri in coda, quel secondo strato va
   fatto passare.** E' il primo lavoro di chi raccoglie questa consegna.
1. 🔴 **Il buco del parser su `@FINOA` e' APERTO.** Una riga `@FINOA` senza
   valore passa liscia oggi (provato, EXIT=0, nessun avviso). Ho chiuso solo
   `@FRAZIONEIS`. La riparazione giusta sta nel parser di r.493, vale per tutte
   e cinque le direttive, e **cambia il comportamento dei 5 file prova con
   `@DAQUANDO` senza valore** (elencati al paragrafo 5): **va misurata in un
   lavoro suo.**
2. 🔴 **La classe nuova NON e' in `CHECKLIST_RIGA_DI_LANCIO.md`.** Il testo
   pronto e' al paragrafo 5. Non l'ho scritta perche' quel file e' stato
   riscritto da un altro agente 20 minuti prima (`394a94e`): **va aggiunta.**
3. 🔴 **`@FRAZIONEIS` non e' stata scritta in NESSUN file prova.** Il mandato
   chiedeva il driver + il giro di pin, e mi sono fermato li'. Le **20 (21) edit
   da una riga** sono elencate nel referto di progetto (`SBLOCCARE_I_VENTI`,
   paragrafo 6), ancore verificate. 🔴 **E `R128a` merita un `@FRAZIONEIS 0.40`
   esplicito**, che e' il taglio che il suo stesso file dichiara **non
   opzionale**: cosi' l'ancora dell'08/08 e' protetta dalla guardia invece che
   dalla memoria di chi lancia.
4. 🔴 **Nessun round e' girato.** Non ho toccato MT5, non ho toccato il VPS, non
   ho messo niente in coda. Il passo 5 del referto di progetto — **un
   `-SoloControllo` su UN round dalla corsia VERA**, che deve stampare `taglio
   IS/OOS preso da '@FRAZIONEIS': 0.5` e `IS 2024.09.26-2025.08.13` — **resta da
   fare sul VPS**, e non e' burocrazia: e' l'unico modo di distinguere «la
   direttiva funziona» da «la direttiva e' ignorata in silenzio» **nella catena
   vera**, con lo scarico dal pin e il controllo d'impronta. Le mie prove girano
   in locale, sul file, non attraverso `raw`.
5. ⚠️ **`Muori()` esce con `1`, non con `9`.** Il mandato diceva `exit 9` in
   quattro punti; il driver ha `function Muori($t){ ...; exit 1 }` (r.256) da
   sempre. 👉 **E' il mandato a essere impreciso, e NON ho toccato `Muori`**:
   cambiarla cambierebbe **ogni percorso di morte** del driver, per 35 script e
   due corsie, in una toppa che parla d'altro. Misurato che **nessuno gatta sul
   valore**: `RIGA_ROUND_VPS.ps1` r.656-659 stampa `rc` come *"informativo: il
   verdetto sta sui CSV, non qui"* (classe 154), e in `RIGA_SOTTILE_ROUND.ps1`
   non esiste alcun confronto con `9`. Quello che conta — **muore, rumoroso,
   prima di girare, con exit non-zero e il messaggio esatto** — e' provato.
6. ⚠️ **La tolleranza `1e-6`.** `@FRAZIONEIS 0.4000001` con `-FrazioneIS 0.40`
   passerebbe muto. **Non e' un difetto misurato, e' una scelta non provata**:
   nessuno scrive un taglio con sette decimali, ma se un giorno servisse una
   griglia fine di frazioni, quella soglia va rivista.
7. ⚠️ **Il messaggio di formato accetta gli interi.** `@FRAZIONEIS 1` passa e
   vale 1.0, pur dicendo *"numero decimale con il PUNTO"*. Voluto (`1` e `0`
   devono poter essere scritti), ma la formulazione e' **imprecisa**: rifiuta la
   virgola, la percentuale e la barra, non pretende il punto.
8. ⚠️ **`.ps1` letti come ANSI da PowerShell 5.1**: ASCII puro **verificato**, ma
   l'esecuzione su **Windows PowerShell 5.1** (il VPS) **non e' stata provata** —
   qui gira `pwsh 7.4.6`. Il cancello ha la regola *"nessun costrutto
   pwsh-7-only"* e passa; il costrutto piu' recente che ho usato
   (`$PSBoundParameters.ContainsKey`, `[double]::Parse` con cultura,
   `[math]::Abs`) e' in PowerShell **dalla 2.0**. Ma **dichiarato, non provato.**
9. ⚠️ **Il punto debole della RADICE resta quello del referto di progetto**:
   venti round poggiano su **una sola** misura (i 325 ingressi di R120), con un
   margine del **+8%** sul pavimento di 150. Se quei 325 fossero sbagliati,
   cadono tutti e venti insieme. **Non e' un motivo per non lanciare — e' un
   motivo per non arrotondare mai quel numero.**

---

# 🔟 🎯 DOVE SIAMO

🟢 Il taglio IS/OOS **e' entrato nell'identita' della cella**, dove stava gia'
il simbolo, il TF e le due date. La corsia ROUND ha finalmente **tutti e cinque**
i canali, e il file prova non puo' piu' dichiarare una cosa mentre i CSV ne
raccontano un'altra.
🟢 Il meccanismo esce **piu' sicuro** di come e' entrato: **tre morti nuove**
dove prima c'erano tre silenzi (collisione, formato/campo, direttiva senza
valore). Un cancello in piu', non uno in meno.
🔴 **E resta ponteggio.** Il numero di mercato lo fara' il primo round che gira
con `@FRAZIONEIS 0.50` scritta dentro — e quello **non e' ancora partito**.

**Prossimo passo piu' corto, e vale una sedia**: le 21 edit da una riga ai file
prova, poi **un** `-SoloControllo` dalla corsia vera. Se stampa
`IS 2024.09.26-2025.08.13`, si apre la coda. Se stampa `2025.06.09`, **si ferma
tutto** — e almeno lo sapremo in un secondo invece che in una notte. 💪
