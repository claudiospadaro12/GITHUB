# 📬 R111 — **LA RIGA DA MANDARE** (Breaking Band su **M30**: GBPUSD · EURUSD · AUDUSD)

**Round**: R111 — **DOV'È IL CONFINE DELL'EDGE?**
**Criteri**: `risultati_archivio/R111_CRITERI.md` — ⚠️ **[DA FIRMARE]**, e la
stringa c'è **apposta** (vedi § *IL CANCELLO DELLA FIRMA*). **Sette decisioni**,
tutte **PRE-FIRMATE CON PROPOSTE**.
**Driver**: `righe/RIGA_R111_BB_M30.ps1` (marcatore `MARCATORE_RIGA_R111_v1`).
**Gemello**: `righe/RIGA_R108_BB_M15.ps1` — stesso EA, stessi simboli, TF diverso.
**File prova**: `prove/R111_GBPUSD_00_metroH1.txt`, `R111_GBPUSD_01_m30.txt`,
`R111_EURUSD_00_metroH1.txt`, `R111_EURUSD_01_m30.txt`,
`R111_AUDUSD_00_metroH1.txt`, `R111_AUDUSD_01_m30.txt` — **sei**.

---

## ❓ LA DOMANDA — **una sola, e chirurgica**

Il Breaking Band **VIVE a H1** ed è **MISURATO** (R103: GBPUSD PF **1,199** n126
· EURUSD **1,936** n59 · AUDUSD **1,541** n64, su 6,5 anni).
Lo stesso motore **MUORE a M15** ed è **MISURATO** (R108, ieri sera: **sei
finestre su sei rosse**, e morto **di segnale, non di costo** — il cancello S0a
passava).

> ### **M30 è il punto di mezzo, e non l'ha mai misurato nessuno. Dov'è il confine?**

```
H1   R103   PF 1,199 / 1,936 / 1,541      VIVO, tre sedie in campo
M30  R111        ???                       <<< QUESTO ROUND
M15  R108   PF 0,823 / 0,637 / 0,865      MORTO, 0 su 6 finestre
```

**Costo di sviluppo: ZERO righe di MQL5.** `InpTF` è già un `input` del sorgente
(riga 213) — e quella riga, letta il 25/08, commenta:
`// TF operativo (guida: D1/H4/H1/M30)`. 👉 **M30 sta nella lista dei TF che
l'autore del motore dichiara. M15 non c'era.** Non è una prova (un commento non è
una misura), ma è la differenza fra *"proviamo un TF a caso"* e *"proviamo
l'ultimo TF che il motore nomina"*.

---

## 🟢 PERCHÉ NON VIOLA LA **SECONDA CACCIA** — e la risposta è coi numeri

| l'obiezione | la risposta |
|---|---|
| *"il motore è stato dichiarato morto ieri"* | ❌ **No.** È morto **a M15**, cioè **un punto**. A **H1** è **vivo** e ha **tre sedie in campo** |
| *"state rigirando una griglia"* | ❌ **Non c'è nessuna griglia**: l'unico flag `Y` è `InpMagic`, e il driver si ferma se ne trova un secondo. **Zero parametri spazzolati** |
| *"è pesca"* | ❌ È **un punto nuovo fra due punti misurati**, stessa cella viva, **un solo input diverso**. E i criteri § 8 dichiarano **PRIMA** cosa si legge in **ognuno** dei quattro esiti — **compreso il rosso, che CHIUDE il capitolo** |

🔒 **Il paletto che rende la cosa onesta**: se M30 esce rosso, *"abbasso il TF del
Breaking Band"* si **chiude**. **Niente M20, niente M10, niente M5, nessun
ripescaggio, nessuna nuova griglia.**

---

## 🧭 LA LETTURA DEL CONFINE — **scritta PRIMA di vedere un numero**

È il cuore del round, ed è nei criteri § 8. Il referto si legge **contro questa
tabella**, non raccontando i numeri.

| esito | lettura | conseguenza |
|---|---|---|
| **A** · M30 **verde** su ≥2 simboli (G2 pieno, G3 coerente) | il confine sta fra **M30 e M15** | apre **un round di VALIDAZIONE nuovo** (prova di regime, spread **misurato**, tick **misurati**). 🔴 **NON una sedia** (G5, decisione D7) |
| **B** · M30 **rosso ovunque** (0 su 3) | il confine sta fra **H1 e M30** | **CAPITOLO CHIUSO.** La frequenza forex per la challenge non verrà da questa famiglia |
| **C** · **misto** (un simbolo verde) | **G3 dice NO** | un simbolo su tre è **rumore** — è il cancello che in R46 fermò un candidato da **+31%**. Resta una riga a registro |
| **D** · `n` < 20 per finestra, o **finestra ACCORCIATA** su tutti e tre | il round ha misurato **il tetto delle barre o i tick**, non il motore | **NON MISURABILE**, che **non è un NO** e non chiude niente |

> ⚠️ **Se a numeri visti salta fuori una QUINTA lettura, va scritta e firmata
> PRIMA di essere usata** — e a quel punto non è più una lettura di R111: è un
> round nuovo.

---

## 🌉 IL PONTE — la parte che vale mezzo round

```
R108  M15                     |========== 2022.07 -> 2026.06 ==========|
R111  M30   |===== IS 2018.07 -> 2022.06 =====|===== OOS 2022.07 -> 2026.06 =====|
```

👉 **L'OOS di R111 È la finestra intera di R108.** Stessa epoca, stessi simboli,
stesso motore, stesso modello (tick reali): fra le due **cambia una cosa sola, il
timeframe**. Il driver stampa il confronto **simbolo per simbolo** dentro il
referto, contro questi numeri già misurati:

| simbolo | M15 (R108, misurato) | M30 (R111, OOS) |
|---|---|---|
| GBPUSD | −8.754 / PF 0,823 / n 227 | *da misurare* |
| EURUSD | −8.872 / PF 0,637 / n 87 | *da misurare* |
| AUDUSD | −3.131 / PF 0,865 / n 118 | *da misurare* |

⚠️ **Caveat dichiarato**: rispetto ai **parametri** (che non tocchiamo) l'OOS
resta OOS; rispetto alla **nostra conoscenza dell'epoca**, no — quell'epoca
l'abbiamo già guardata a M15. Non è un difetto, è il prezzo del ponte, e si dice.

---

## 🔴 IL CANCELLO DELLA FIRMA — **la PRE-FIRMA c'è, e il lucchetto resta chiuso APPOSTA**

Claudio ha già dato una **pre-firma**, il 25/08 sera: **_"FIRMO R111"_**. Ma è
**sul PERIMETRO** — *«BB M30, il confine fra l'H1 vivo e l'M15 morto»* — **non
sulle sette decisioni**, che sono state scritte **dopo**, **prima dei numeri**, e
**restano smentibili finché la corsa non parte**.

Perciò `R111_CRITERI.md` conserva `[DA FIRMARE]`, e il driver lo legge al pin:

- il **giro a vuoto parte lo stesso** (non apre MT5, non produce nessun numero);
- la **corsa vera si ferma con `exit 2`**, a meno di `-CriteriFirmati` — che è
  la **registrazione della pre-firma**, e finisce **scritta nel referto**.

> 🔏 **E il lucchetto nel file dei criteri è UNO SOLO, nel titolo** — la prosa
> che lo spiega **non lo nomina**, e non è pignoleria: è la **checklist 82**,
> nata il 25/08 su R110, dove ne erano rimasti **due** in prosa e il round è
> uscito a `exit 2` **su criteri firmati**, con il referto che agli atti
> dichiarava *NON FIRMATI* un round firmato. Regola: **il giorno in cui si
> toglie il lucchetto, `grep` del token su `R111_CRITERI.md` deve dare ZERO**, e
> `-CriteriFirmati` **si toglie dalla riga** (il driver lo dichiara *INERTE* e
> lo scrive nel referto, invece di descriversi sempre allo stesso modo).

**Le sette decisioni** (§ 11 dei criteri, tutte con la proposta già scritta):

| | decisione | ✅ proposta |
|---|---|---|
| **D1** | il **metro G0** gira a **modello 1 (OHLC M1)**, come R103 e R108? | **SÌ** — è l'unico modello che riproduce quel numero; in R108 ha fatto **G0 3/3 al centesimo** |
| **D2** | la **profondità dei TICK** non è misurata, e qui la finestra è il **doppio** | **SI GIRA E SI DICHIARA** (come R108). ⚠️ **Ma se l'esito è VERDE la riserva diventa BLOCCANTE**: la riserva ammorbidisce un **sì**, non un **no** |
| **D3** | **finestra M30** `2018.07 → 2026.06`, **IS/OOS 4+4** | **SÌ** — otto anni per dare alla INTERA una chance dei 150; 4+4 per avere **due regimi diversi** e per far coincidere l'**OOS col ponte** |
| **D4** | **spread** di S0a | **1,5 pip DICHIARATO**, `[SPREAD NON MISURATO]` accanto a ogni verdetto. **Lo stesso di R108 apposta**: cambiarlo renderebbe i due S0a incomparabili |
| **D5** | se **S0 o G0 falliscono su un simbolo** | **quel simbolo si chiude, gli altri proseguono** |
| **D6** | 🔴 la **lettura del confine si dichiara PRIMA** (i quattro esiti qui sopra) | **SÌ** — ed è **la decisione che rende R111 una misura**. Senza, un round non può produrre un **NO**: ci sarà sempre un motivo per riprovare |
| **D7** | se l'esito è **A (verde)** | **NON è una promozione** (G5): è un **round di validazione nuovo**, con criteri nuovi |

> 🚦 **E RESTA IL CANCELLO DEL TRAFFICO: una macchina, un lavoro.**
> ⚠️ **R109 sta girando stanotte sul PC di backtest.** R111 parte **solo** quando
> quel round ha finito e nessun altro tocca il terminale.

---

## 📌 IL PIN — **`6e7d34c0debd3a49f98cf7227ee59f238cad6191`**

```
6e7d34c0debd3a49f98cf7227ee59f238cad6191
```

🔴 **Finché lì sopra c'è il segnaposto, la riga NON si detta**: va sostituito col
commit vero. *(Frase scritta così apposta — resta vera anche dopo la pinnatura,
quando lì sopra c'è uno SHA: checklist **77**, la prosa che spiega deve restare
leggibile in tutti e due gli stati.)*
Sequenza — **il token si COMPONE in una variabile**, così la ricetta non contiene
mai la stringa che sta cercando (checklist **77**), e **si sostituiscono i PUNTI
D'USO, non la pagina**, altrimenti dopo il primo pin la ricetta stessa è morta:

```bash
cd /percorso/del/repo
F=backtest_pipeline/righe/RIGA_R111_DA_MANDARE.md
TOK='@@PIN'"@@"
# 1. i file che il driver SCARICA, se sono cambiati
git add backtest_pipeline/righe/RIGA_R111_BB_M30.ps1 \
        backtest_pipeline/prove/R111_*.txt \
        backtest_pipeline/risultati_archivio/R111_CRITERI.md
git commit -m "R111: driver, file prova e criteri"
git push
SHA=$(git rev-parse HEAD)
# 2. il pin dentro QUESTA pagina, che il driver NON scarica
sed -i "s|\$pin='$TOK'|\$pin='$SHA'|g; s|^$TOK\$|$SHA|; s|IL PIN — \*\*\`$TOK\`\*\*|IL PIN — **\`$SHA\`**|" "$F"
# 3. I DUE CONTEGGI, e servono TUTTI E DUE
grep -c "\$pin='$SHA'" "$F"    # DEVE dare 6  (i sei blocchi di lancio)
grep -c "\$pin='$TOK'" "$F"    # DEVE dare 0
git add "$F" && git commit -m "R111: pin" && git push
```

⚠️ **Il solo _"0 segnaposto rimasti"_ non basta**: lo supera a mani basse anche un
`sed` che **non ha matchato niente** — è il guardiano decorativo del punto 14
applicato a un `sed`. Servono **entrambi** i conteggi.

### 🧟 SE IL PIN VA RIFATTO (e va rifatto più spesso di quanto si creda)

Il segnaposto non c'è più: si sostituisce il **pin vecchio**, e **solo nei punti
d'uso**. ☠️ **Le menzioni in prosa di un pin sono STORIA** (perché è stato
bruciato, cosa conteneva): **non si toccano mai**, o la pagina finisce per dire
*"il pin ⟨quello NUOVO⟩ è BRUCIATO"*, cioè l'esatto contrario del vero
(checklist **77-bis**, sbagliata due volte di fila prima di venire giusta).

```bash
F=backtest_pipeline/righe/RIGA_R111_DA_MANDARE.md
NUOVO=$(git rev-parse HEAD)
VECCHIO=$(grep -oE "\\\$pin='[0-9a-f]{40}'" "$F" | head -1 | grep -oE '[0-9a-f]{40}')
echo "vecchio=$VECCHIO  nuovo=$NUOVO"
sed -i "s|\$pin='$VECCHIO'|\$pin='$NUOVO'|g; s|^$VECCHIO\$|$NUOVO|; s|IL PIN — \*\*\`$VECCHIO\`\*\*|IL PIN — **\`$NUOVO\`**|" "$F"
grep -c "\$pin='$NUOVO'" "$F"    # DEVE dare 6
grep -c "\$pin='$VECCHIO'" "$F"  # DEVE dare 0
```

⚠️ E il numero atteso **si riconta sulla pagina vera**, non si copia dalla volta
prima: la pagina intanto si riempie di storia.

---

## ⚠️ COSA SAPERE PRIMA DI LANCIARE

- **MT5 e MetaEditor DEVONO essere chiusi.** Col terminale aperto il tester non
  gira (zero CSV); con MetaEditor aperto la compilazione torna subito **senza
  compilare**. La riga si rifiuta di partire in tutti e due i casi.
- **NESSUNA SEDIA VIVA VIENE TOCCATA.** Magic **vergini, blocco `764xxx`**
  (`grep -rEo '\b7640[0-9]{2}\b'` su tutto il repo: **zero occorrenze**, 25/08).
  Sono **vietati e controllati nel codice** i magic delle sedie vive e quelli di
  **R103** (`7600xx` — cioè **proprio le tre BreakingBand di questo round**),
  **R107** (`7610xx`), **R108** (`7620xx`, il gemello), **R110** (`763xxx`) e
  **R109** (`7744xx`).
- **30 passate**: per ogni simbolo la cella metro fa **3** lanci (1 singola + 2
  gemelle) e la cella M30 ne fa **7** (1 + 2 intera + 2 IS + 2 OOS).
- **Due modelli, e non è una svista**: metro H1 a **modello 1 (OHLC M1)** perché
  R103 è girato così; M30 a **modello 4 (TICK REALI)** perché è il giudizio.
- **Zero parametri spazzolati.** L'unico asse `Y` è `InpMagic`.
- **Il round non scarica storico** e non tocca `bases\<server>\ticks`.
- 🔧 **Se non è già stato fatto**: MT5 → Strumenti → Opzioni → Grafici →
  **"Max barre nel grafico" = Illimitato**. Il driver scrive comunque
  `[Charts] MaxBars=2000000000`, ma **[INFERITO], non misurato**, che il tester
  lo onori. ⚠️ **E stavolta conta**: la finestra M30 è di **8,0 anni** contro un
  tetto di **8,0 anni** — siamo **al limite, non sotto**.
- ⏱️ **Durata [STIMA, non una previsione] — ma poggia su un MISURATO**: R108 ha
  fatto **le stesse 30 passate** (12 metro in OHLC + 18 a tick reali su **4 anni**
  di M15) in **24 minuti**, corsa vera del 25/08 agli atti. Qui le barre sono
  circa le stesse (~100.000: è lo stesso tetto), i **tick sono circa il doppio**
  perché la finestra è doppia. ➡️ **40-60 minuti.** `-OreMax 12` è un tetto
  sull'**inizio** di nuovi lavori, non un'accetta su un lavoro in corso.

---

## 1️⃣ PRIMA il giro a vuoto (pochi minuti, **nessuna passata**)

> ⚠️ **Non è a costo zero sul terminale**: scarica gli artefatti al pin,
> **installa `ABTG_PausaGuardian.mqh`** in `MQL5\Include` e **COMPILA l'EA**.
> Quello che **non** fa: non apre MT5 per testare, non cancella nessun artefatto.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $t0=Get-Date; $pin='6e7d34c0debd3a49f98cf7227ee59f238cad6191'; $p="$env:USERPROFILE\RIGA_R111.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R111_BB_M30.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R111_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo; $rc=$LASTEXITCODE;
    $z=@(Get-ChildItem "$env:USERPROFILE\Desktop\R111_BB_M30_*.zip" -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($z.Count -eq 0){ Write-Host '!!! NESSUNO ZIP DI ADESSO: la riga si e'' fermata prima della raccolta. Copia lo SCHERMO, non cercare file.' -ForegroundColor Red }
    else { Write-Host ('ZIP: ' + $z[0].FullName) -ForegroundColor Green };
    if($rc -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Leggi i PROBLEMI nel REFERTO.' -ForegroundColor Red } }
```

### Cosa deve dire

```
    simboli ......................  3   (AUDUSD, EURUSD, GBPUSD)
    celle ........................  6   (di cui METRO: 3)
    passate ......................  30   (metro 3 = 1 singola + 2 gemelle; M30 7 = 1 + 2 + 2 + 2)
    righe vive per file prova ....  70
    righe per CSV di ottimizz. ...  2   (le due gemelle di controllo)

    METRO H1 : 2020.01.01 -> 2026.06.30   modello 1 (OHLC M1, come R103)
    M30      : 2018.07.01 -> 2026.06.30   modello 4 (TICK REALI)
        IS  2018.07.01 -> 2022.06.30     OOS 2022.07.01 -> 2026.06.30
```

> ⚠️ **`(AUDUSD, EURUSD, GBPUSD)` è in ORDINE ALFABETICO, non nell'ordine del
> dossier.** La lista è costruita con `Sort-Object -Unique`, che **ordina**. Il
> driver lo dice da solo a schermo. **Un falso allarme qui costa un giro** — è il
> punto **70**, pagato su R107.

E poi, in ordine:

- `criteri: NON FIRMATI (il file porta ancora [DA FIRMARE])` — **è giusto così**,
  ed è la forma voluta (vedi il cancello della firma qui sopra);
- `6 file prova scaricati al pin, 70 righe di input ciascuno`;
- `gate della STELLA: ogni cella M30 differisce dalla sua cella metro SOLO su InpTF`;
- **SEI righe di antenato, due per simbolo** — `gate dell'ANTENATO R108 <sim>:
  ... (delta: InpComment, InpMagic)` e `gate dell'ANTENATO R103 <sim>: ...
  (delta: InpComment, InpMagic, InpNewsCurrencies)`.
  ⚠️ **L'elenco dei delta esce in ORDINE ALFABETICO, e adesso è deterministico**:
  nasce dalle chiavi di un hashtable, che in PowerShell **non hanno ordine** (e su
  .NET l'hash delle stringhe è randomizzato **per processo**). **Misurato il
  25/08: sei corse, quattro ordini diversi degli stessi tre nomi.** Il driver
  adesso li **ordina** prima di stamparli — altrimenti questa riga non avrebbe
  potuto combaciare quasi mai, ed è il punto **70** (un falso allarme qui costa
  un giro);
- `valori, pattern VIVO, TF del grafico, asse unico e 42 magic vergini verificati NEI FILE`;
- `ABTG_BreakingBand.mq5 al pin, version 1.03, InpTF e' un input libero`;
- **tre righe `profondita' TICK <simbolo>:`** — ⚠️ **diranno `NON MISURATA`, ed è
  la decisione D2**: non è un guasto del driver, è un buco vero del repo;
- `include installato: ABTG_PausaGuardian.mqh (... byte)`;
- `COMPILATO ABTG_BreakingBand v1.03 (.ex5 riscritto adesso, rc=0)`;
- 🆕 **per ogni `.ini`, la riga `finestra letta NELL'INI: <da> -> <a>`** — è la
  **checklist 79**, e la ragione per cui c'è la trovi due sezioni più giù;
- in fondo: `.ini scritti e verificati: 18 su 18` e `ESITO: GIRO A VUOTO COMPLETATO`.

> ⚠️ **Quello che il giro a vuoto NON può fare.** `-SoloControllo` **non apre
> MT5**: non esiste nessun `n`, nessun PF, nessun DD, **nessun G0 e NESSUN
> cancello zero S0**. Conferma gli **artefatti**, mai i numeri.

---

## 2️⃣ POI la corsa vera — con `-CriteriFirmati`

`-CriteriFirmati` **registra la pre-firma del 25/08** e la scrive nel referto.
Se prima vuoi smentire una delle sette decisioni, si cambia **il file dei
criteri** e poi si gira: **i criteri si cambiano PRIMA dei numeri, mai dopo.**

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $t0=Get-Date; $pin='6e7d34c0debd3a49f98cf7227ee59f238cad6191'; $p="$env:USERPROFILE\RIGA_R111.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R111_BB_M30.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R111_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -CriteriFirmati; $rc=$LASTEXITCODE;
    $z=@(Get-ChildItem "$env:USERPROFILE\Desktop\R111_BB_M30_*.zip" -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($rc -eq 2){ Write-Host '!!! CRITERI NON FIRMATI: non e'' partito NIENTE e NON c''e'' nessuno zip. Leggi le sette decisioni qui sopra.' -ForegroundColor Red }
    elseif($z.Count -eq 0){ Write-Host '!!! NESSUNO ZIP DI ADESSO: la riga si e'' fermata prima della raccolta. Copia lo SCHERMO, non cercare file.' -ForegroundColor Red }
    else { Write-Host ('ZIP DA MANDARE: ' + $z[0].FullName) -ForegroundColor Green;
           if($rc -ne 0){ Write-Host 'ESITO: PARZIALE, SCREEN O FERMO - lo zip esiste: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } } }
```

Si incolla **il blocco INTERO**: è **un comando solo** (checklist 21). Tre righe
staccate sarebbero tre comandi indipendenti, e un `throw` alla prima non
fermerebbe le altre.

> ⚠️ **Perché qui il messaggio è GIALLO e nel giro a vuoto è ROSSO.** Nella corsa
> vera `exit 1` può voler dire *"la corsa è riuscita e la risposta non ti
> piace"* — per esempio un **S0a FALLITO**, che è **LA RISPOSTA del round** e non
> un guasto. Gli artefatti **esistono** e vanno mandati lo stesso.

### 🔁 Se serve riprendere

> ⚠️ **Ogni riga di ripresa è un BLOCCO INTERO, con il suo `irm` e la sua
> guardia** (checklist **42**). `$p` e `$pin` nascono **dentro** il `& { ... }`,
> che è uno **scope figlio**: quando quel blocco finisce **non esistono più**.
> Una riga `& $p -Pin $pin ...` incollata da sola in una console nuova muore; e
> — peggio — incollata in una console **ancora calda** funziona, ma riusa la
> **copia locale già scaricata** e il **pin di prima** (difetto del 10/08).

**Un simbolo solo** (qui GBPUSD, l'unico col campione atteso sopra i 150):

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $t0=Get-Date; $pin='6e7d34c0debd3a49f98cf7227ee59f238cad6191'; $p="$env:USERPROFILE\RIGA_R111.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R111_BB_M30.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R111_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -CriteriFirmati -SoloSimbolo 'GBPUSD'; $rc=$LASTEXITCODE;
    $z=@(Get-ChildItem "$env:USERPROFILE\Desktop\R111_BB_M30_*.zip" -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($rc -eq 2){ Write-Host '!!! CRITERI NON FIRMATI: non e'' partito NIENTE e NON c''e'' nessuno zip.' -ForegroundColor Red }
    elseif($z.Count -eq 0){ Write-Host '!!! NESSUNO ZIP DI ADESSO: la riga si e'' fermata prima della raccolta. Copia lo SCHERMO, non cercare file.' -ForegroundColor Red }
    else { Write-Host ('ZIP DA MANDARE: ' + $z[0].FullName) -ForegroundColor Green;
           if($rc -ne 0){ Write-Host 'ESITO: PARZIALE, SCREEN O FERMO - lo zip esiste: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } } }
```

**Due simboli** — ⚠️ **l'elenco va FRA APICI** (checklist 65: senza, la virgola fa
un **array** e il binder lo unisce con uno spazio):

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $t0=Get-Date; $pin='6e7d34c0debd3a49f98cf7227ee59f238cad6191'; $p="$env:USERPROFILE\RIGA_R111.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R111_BB_M30.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R111_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -CriteriFirmati -SoloSimbolo 'EURUSD,AUDUSD'; $rc=$LASTEXITCODE;
    $z=@(Get-ChildItem "$env:USERPROFILE\Desktop\R111_BB_M30_*.zip" -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($rc -eq 2){ Write-Host '!!! CRITERI NON FIRMATI: non e'' partito NIENTE e NON c''e'' nessuno zip.' -ForegroundColor Red }
    elseif($z.Count -eq 0){ Write-Host '!!! NESSUNO ZIP DI ADESSO: la riga si e'' fermata prima della raccolta. Copia lo SCHERMO, non cercare file.' -ForegroundColor Red }
    else { Write-Host ('ZIP DA MANDARE: ' + $z[0].FullName) -ForegroundColor Green;
           if($rc -ne 0){ Write-Host 'ESITO: PARZIALE, SCREEN O FERMO - lo zip esiste: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } } }
```

**Una cella sola** (la cella METRO del suo simbolo rigira lo stesso: senza il
metro il numero non si legge — costa 3 passate, non una corsa sprecata):

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $t0=Get-Date; $pin='6e7d34c0debd3a49f98cf7227ee59f238cad6191'; $p="$env:USERPROFILE\RIGA_R111.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R111_BB_M30.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R111_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -CriteriFirmati -SoloCella 'R111_GBPUSD_01_m30.txt'; $rc=$LASTEXITCODE;
    $z=@(Get-ChildItem "$env:USERPROFILE\Desktop\R111_BB_M30_*.zip" -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($rc -eq 2){ Write-Host '!!! CRITERI NON FIRMATI: non e'' partito NIENTE e NON c''e'' nessuno zip.' -ForegroundColor Red }
    elseif($z.Count -eq 0){ Write-Host '!!! NESSUNO ZIP DI ADESSO: la riga si e'' fermata prima della raccolta. Copia lo SCHERMO, non cercare file.' -ForegroundColor Red }
    else { Write-Host ('ZIP DA MANDARE: ' + $z[0].FullName) -ForegroundColor Green;
           if($rc -ne 0){ Write-Host 'ESITO: PARZIALE, SCREEN O FERMO - lo zip esiste: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } } }
```

### 🩺 E se il tempo dei tick reali fosse proibitivo: lo SCREEN veloce

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $t0=Get-Date; $pin='6e7d34c0debd3a49f98cf7227ee59f238cad6191'; $p="$env:USERPROFILE\RIGA_R111.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R111_BB_M30.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R111_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -CriteriFirmati -ScreenOhlcM30; $rc=$LASTEXITCODE;
    $z=@(Get-ChildItem "$env:USERPROFILE\Desktop\R111_BB_M30_*.zip" -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($rc -eq 2){ Write-Host '!!! CRITERI NON FIRMATI: non e'' partito NIENTE e NON c''e'' nessuno zip.' -ForegroundColor Red }
    elseif($z.Count -eq 0){ Write-Host '!!! NESSUNO ZIP DI ADESSO: la riga si e'' fermata prima della raccolta. Copia lo SCHERMO, non cercare file.' -ForegroundColor Red }
    else { Write-Host ('ZIP DA MANDARE: ' + $z[0].FullName) -ForegroundColor Green;
           if($rc -ne 0){ Write-Host 'ESITO: PARZIALE, SCREEN O FERMO - lo zip esiste: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } } }
```

🔴 **E QUESTO GIRO NON PUÒ PRODURRE UN VERDETTO, per costruzione**: ogni riga M30
esce `NON GIUDICABILE`, **nessun verdetto S0a** viene dato, il referto chiude con
`ESITO: SCREEN OHLC -- NESSUN VERDETTO` e **esce 1**, e la cartella si chiama
`SCREENOHLC`. Al massimo produce **il permesso** di un giro a tick reali.
*(Che l'OHLC inganni sui TF bassi è misurato in casa — `REGISTRO_TEST.md` §2 —
ma **su M30 non è misurato né in un senso né nell'altro**, e non si assume.)*

---

### 📅 LE DUE RIGHE CHE CLAUDIO DEVE LEGGERE NEL REFERTO, PRIMA DI MANDARE LO ZIP

1. **`modo:`** — dice `CORSA` (il round), `CONTROLLO` (giro a vuoto: **non è il
   round, non si manda come risultato**) o `SCREENOHLC` (**non giudicabile**);
2. **`data:`** — **deve essere di ADESSO**. Se è di ieri è un referto **stantio**.

---

## 📦 COSA TORNA INDIETRO

Cartella e zip sul Desktop: `R111_BB_M30_<MODO>_<data>_<ora>` — dentro:

- **`REFERTO_R111.txt`** ← **è questo che conta**;
- **12 CSV** di ottimizzazione (2 righe l'uno: le gemelle di controllo);
- **6 report `.htm`** delle passate singole — ⚠️ **sono la fonte di TUTTO il
  PASSO 0**: prima operazione, take in pip, durata in barre, peggior giornata.
  Se mancano, il cancello zero non esiste;
- **18 `.ini`**, quelli che hanno girato davvero;
- i **sei file prova al pin** + i **sei antenati** (`ANTENATO_R108_*` e
  `ANTENATO_R103_*`), così lo zip porta dentro anche **il metro del metro**;
- `compile_BreakingBand.log` e i per-trade, quando l'EA li scrive.

---

## 🚩 LE COSE DA GUARDARE PER PRIME NEL REFERTO

1. 🔬 **I TRE VERDETTI G0.** Devono dire **`RIPRODOTTO`** su tutti e tre — PF, DD,
   `n` **e la prima operazione**. 👉 Se un metro non torna, **quel simbolo si è
   fermato e la sua cella M30 non è nemmeno partita**.
2. 🧱 **LA COLONNA `FINESTRA` DEL PASSO 0.** ⚠️ **In R111 è il rischio n.1**:
   `@DAQUANDO 2018.07.01` è **derivato** dal tetto delle 100.000 barre, e la
   finestra è di **8,0 anni su un tetto di 8,0** — **al limite, non sotto**. Se
   dice `ACCORCIATA`, **il 4+4 non è più 4+4** e va riscritto nel referto **PRIMA
   di leggere qualunque numero**.
3. 🌉 **LA TABELLA DEL PONTE.** M30-OOS contro M15-INTERA, **stessa epoca**: è il
   confronto per cui la finestra è stata scelta così.
4. 📊 **LA FREQUENZA.** L'attesa è **[INFERITA]**, ma stavolta **interpolando fra
   due punti MISURATI** (H1 di R103, M15 di R108): **~265 GBPUSD · ~113 EURUSD ·
   ~136 AUDUSD** sulla INTERA di 8 anni. ⚠️ **E la conseguenza è dichiarata
   PRIMA**: con queste attese **nessuna finestra IS/OOS arriva a 150** e **solo
   GBPUSD** ha una speranza sulla INTERA — il **merito pieno** nasce giudicabile
   **su un simbolo solo**. È lo stesso quadro di R108, dove il NO è stato
   leggibile perché **le sei finestre erano concordi**.
5. 🚨 **IL CANCELLO ZERO S0a.** ⚠️ **E qui la lettura è diversa da R108**: a M30 i
   bersagli sono **più grandi** che a M15, dove S0a **passava già**. Quindi
   l'attesa è che passi — e **un `SUPERATO` non dice NIENTE sul merito**. A
   decidere sarà **G2/G3**. Tre stati: `SUPERATO`, `FALLITO`, **`SOSPESO`**
   (rapporto fra 2,5× e 3,5×: la soglia poggia su uno spread **non misurato**).
6. ⏱️ **LA DURATA IN BARRE.** Non è un cancello, è una misura. Se la mediana esce
   **1-3 barre**, va scritto come **allarme sulla robustezza anche a cancelli
   verdi** (`arXiv 2605.04004` §6.2: i segnali intraday sopravvissuti tengono
   **12-15 barre**).
7. 🧨 **LA TABELLA `G4: LA PEGGIOR GIORNATA`** — quattro viste, muro prop
   **−5,00%**. 👉 **Il rischio non si sospende mai** (Emendamento regola B): un DD
   e una giornata si leggono **a qualunque `n`**, anche col merito sospeso.
8. 🆕 **LA RIGA `ordinamento dei deal (checklist 81)`.** Dice se i deal sono stati
   presi **nell'ordine della fonte** (giusto) o **riordinati**, e **quanti gruppi
   a pari secondo** c'erano. Se compare un'anomalia di accoppiamento, **quella
   riga si legge PRIMA di sospettare dell'EA** — vedi la sezione qui sotto.
9. 🎫 **LE TRE RIGHE `profondita' TICK`.** Diranno `NON MISURATA`: è la decisione
   **D2**, ed è il rischio più concreto del round. ⚠️ **La riserva ammorbidisce
   un SÌ, non un NO.**

---

## 🎲 IL DIFETTO CHE È ARRIVATO MENTRE R111 SI COSTRUIVA — e come è stato tolto

Il 26/08 è entrata in checklist la classe **81**: **`Sort-Object` non è stabile**.
Sulle chiavi **uguali** l'ordine d'uscita è **arbitrario**, e `-Stable` esiste
solo da PowerShell 7 (sul PC c'è **5.1**). Il parser dei deal di R109 aveva
`$deal | Sort-Object Ora` — un gesto **difensivo** — e nella corsa vera ha
prodotto **34 false anomalie e 16 operazioni perse**, accusando **l'EA**, l'unico
pezzo innocente della catena.

**R111 copiava quel parser dal gemello R108. È stato corretto, e la correzione è
stata ESEGUITA:**

- **non si ordina più**: si usa **l'ordine della fonte** (i deal dell'`.htm` sono
  in ordine di **ticket**, cronologico e senza pari);
- **la monotonia si MISURA, non si assume**: il driver conta i **salti
  all'indietro** e i **gruppi a pari secondo**, e li **stampa nel referto**;
- se la fonte **non** fosse monotona, riordina **solo** con uno **spareggio
  univoco** — il numero d'**AFFARE**, che il parser ora **legge e conserva**
  (R109 lo scartava: per questo la scorciatoia non c'era) — **e lo dichiara**;
- se lo spareggio non c'è: **NON MISURATO**, e non si stima;
- **quando la guardia scatta, il driver NON accusa l'EA** (lezione **81-bis**):
  manda a confrontare i **tre testimoni indipendenti** (CSV OPTFRAME, deal `out`
  dell'`.htm`, per-trade dell'EA).

> ⚠️ **E un sospetto onesto, aritmetico e non dimostrato**: il referto R108
> registra *"EURUSD M15: **2 deal non accoppiati**"*, lasciato a registro come
> *"da capire"*. **Un gruppo invertito = 2 anomalie e 1 operazione persa.** È
> esattamente il numero che questo difetto produce. Non cambia il verdetto rosso
> di R108 (che viene da **quattro CSV concordi**, e i CSV non passano dal
> parser), ma la riga *"da capire"* adesso ha un candidato.

---

## ✅ COSA È GIÀ STATO VERIFICATO — **eseguendo**, prima dell'invio

🟡 **Nessun MT5 qui**: tutto ciò che segue è stato fatto girare col **parser vero
di PowerShell** e con **i file veri del repo**, mai a occhio.

**93 controlli eseguiti, 0 falliti**, in quattro batterie:

**1) Il driver, staticamente** — `[Parser]::ParseFile` → **0 errori**, 20.590
token; **ASCII puro** (0 byte non-ASCII, regola del 17/08); **0 token PS7-only**;
**cl.73**: 0 espressioni binarie non parentesizzate dentro `@(...)`; **cl.79**:
audit sull'**AST** delle assegnazioni e dei `foreach` fuori dalle funzioni →
**0 collisioni di grafia** (e `$Ea` è diventato `$NomeEa`: nessuna variabile di
configurazione con un nome corto); **cl.76**: le 11 stringhe in apici doppi con
espansione sono **tutte** URL o here-string di `.ini`, verificate una per una.

**2) Le date e le due fabbriche di `.ini`** (43 controlli) — `GateDate` passa
sulle quattro finestre vere e **ferma** il `ToDate` di R109 (righe di input
incollate), il `ToDate` vuoto, i trattini, il **30 febbraio**, il **mese 13**, il
**29 febbraio di un non bisestile**, la finestra **al contrario**, quella **lunga
zero** e un **array convertito in stringa**; `GateDateIni` prende un `ToDate`
diverso, una riga mancante, e **il punto della data non fa da jolly**
(`2018x07x01` **non** passa). Poi **18 `.ini` scritti e riletti da disco**:
`Symbol`, `Period` H1/M30, `Model` 1/4, `MaxBars`, `AllowLiveTrading=false`,
`InpTF` 16385/30, le **quattro finestre** giuste per tipo di lancio, **30 magic
tutti distinti** (764000…764057), **zero `||` nella passata singola**, **un solo
asse `Y`** nell'ottimizzazione. E il gate **morde dentro la fabbrica**: con una
data storta **nessun `.ini` viene scritto**.

**3) I gate sugli artefatti** (25 controlli) — su un **repo locale corrotto un
pezzo alla volta**. Controllo positivo: i sei file veri passano tutto. Poi:
**8 corruzioni SIMMETRICHE** (`InpBBPeriod`, `InpBBDev`, `InpSL_ATRmult`,
`InpBulgeWidthMult`, `InpBEatATR`, `InpMaxTradesPerDay`, `InpTP1Pct`,
`InpImpulseATR`) → **8 su 8 fermate dal gate dell'antenato R108**; **R108 corrotto
DOPO la sua corsa** (la stessa riga storta in R108 *e* nelle due celle R111) →
**fermata dal secondo antenato, R103** — ed è il motivo per cui gli antenati sono
**due**; `InpTF` scambiato, `InpTF` a **15** (il TF di R108), un terzo input
mosso, il **`InpPatternMode` del cacciatore** (tutti a 2), il magic **760030** di
R103, un magic **duplicato**, un **secondo asse `Y`**, `@DAQUANDO`/`@PERIODO`/
`@SIMBOLO` storti, `InpMinRR` e `InpMinTPatATR` **accesi**, il **rischio**
cambiato, una **riga tolta**, e il magic **identico all'antenato**.

**4) La batteria dei PARI, checklist 81** (25 controlli) — **coi pari costruiti
apposta**, perché una batteria a chiavi tutte distinte **non può vedere questo
difetto** (è esattamente perché il report finto di R108 aveva orari tutti diversi
che è passato). Un report `.htm` con l'intestazione **vera** di MT5 italiano,
**due gruppi a pari secondo**, e i numeri **calcolati a mano prima**: take
mediano **45,0 pip**, perdita mediana **20,0**, durata mediana **2,0 barre M30**
(se `barSec` fosse rimasto 900 uscirebbe 4,0 — anche quello è provato),
`n=4`, **0 anomalie**, **2 gruppi a pari misurati**, **0 salti all'indietro**.
📌 **Con la CONTROPROVA**: sugli **stessi dati**, il codice **vecchio** inventa
**fino a 4 anomalie e scende a n=2**. Più: fonte **non monotona** → riordino con
lo **spareggio** e dichiarazione; non monotona **senza** spareggio → **NON
MISURATO** e nessuna stima; `TrovaReport` con **due file allo stesso istante** →
**25 chiamate, sempre lo stesso file**.

### 🔍 E POI LA VERIFICA INDIPENDENTE (25/08 sera) — **sei correzioni, tutte ESEGUITE**

Il verificatore ha rifatto tutto **eseguendo il driver vero end-to-end** su un
MT5 finto (terminale, MetaEditor e tester sostituiti da stub, artefatti veri del
repo): **giro a vuoto → exit 0** con i 18 `.ini` scritti e riletti; **corsa vera
completa → exit 0** con G0 3/3, S0a, tabella madre, ponte e G4; **corsa vera
senza `-CriteriFirmati` → exit 2** con le sette decisioni a schermo;
**`-ScreenOhlcM30` → exit 1** e ogni riga M30 `NON GIUDICABILE`; **G0 rotto →
i tre simboli si fermano e le celle M30 non partono**; **dieci corruzioni del
repo, dieci fermate, controprova verde**; **batteria dei PARI** sul `Passo0`
vero (in/out nello stesso secondo, out+in nello stesso secondo con volumi
diversi, tre deal nello stesso secondo, fonte non monotona con e senza
spareggio) → **MISURATO senza anomalie** dove deve, **NON MISURATO dichiarato**
dove non c'è la chiave; **cultura it-IT** → `NumInv`, i formati e `GateDate`
identici all'invariante. Correzioni applicate:

| # | cosa | classe |
|---|---|---|
| 1 | i criteri **nominavano** il proprio lucchetto in prosa (3 occorrenze invece di 1): toglierlo dal titolo **non** avrebbe aperto il gate, e la tabella dei criteri prometteva il contrario | **82** |
| 2 | `-CriteriFirmati` si autodescriveva **con un ramo solo**: su un file già firmato — o **mai letto** — il referto avrebbe messo agli atti una frase falsa. Adesso sono **tre rami sul valore letto**, e lo stato nasce **prima del `try`** | **82** · **41-bis** |
| 3 | l'elenco dei **delta dell'antenato** usciva dalle chiavi di un hashtable: **sei corse, quattro ordini diversi**. Adesso è ordinato, e questa pagina combacia | **70** |
| 4 | due rimandi `criteri par. 4.1` dove il paragrafo è il **4.2** — e uno finisce nei PROBLEMI del referto, proprio quando scatta il rischio n.1 del round | **43** |
| 5 | il backup del `.mq5`/`.ex5` si chiamava `.prima_r108_`: l'artefatto che deve dire *cosa girava prima di R111* portava il nome di un altro round | **45** |
| 6 | la prosa del pin restava falsa dopo la pinnatura (*"il valore qui sopra è un segnaposto"* sotto uno SHA vero) | **77** |

🟡 **NON verificato, e va detto**: tutto ciò che richiede **MT5** — la
compilazione vera, il comportamento del tester, **se il tester onori `MaxBars`**
(e qui la finestra è **al limite**), **se i tick reali ci siano davvero** sui tre
simboli, la durata reale, e **ogni singolo numero**. **Il giro a vuoto copre gli
artefatti; i numeri li può dare solo la corsa.**

> ⚠️ **Il rischio residuo più concreto, dichiarato: i TICK** (decisione **D2**),
> e in R111 pesa **il doppio** di R108 perché la finestra è doppia. Se i tick
> reali di BCM partissero dopo il 2018, **la metà IS girerebbe su un ripiego
> senza dirlo**. Controllo indiretto gratis: se la **prima operazione** cade
> molto dopo il 2018.07.01 su **tutti e tre** i simboli, il sospetto n.1 è
> proprio quello.
