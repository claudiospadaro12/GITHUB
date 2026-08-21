# ✅ PRIMA DI MANDARE UNA RIGA DI LANCIO — la lista, eseguita

_Scritto il 15/08/2026 dopo che Claudio ha detto "stai facendo troppi
errori". Aveva ragione: sette righe di lancio sbagliate in una sera, e il
filo comune era sempre lo stesso — **avevo mandato la riga senza aprire lo
script a cui puntava**._

**Questa non e' una promessa: e' una lista da eseguire.** Nessuna riga esce
prima di averla passata tutta.

---

## 1. 📖 APRO LO SCRIPT. Ogni volta, anche se l'ho scritto io un'ora fa.

Non "mi ricordo cosa fa". **Lo leggo.** Sei errori su sette di quella sera
sarebbero morti qui.

## 2. 🔍 Cerco i DIFETTI GEMELLI

Se ho appena corretto un difetto in uno script, **lo cerco in tutti gli altri
prima di mandare qualunque riga**. Il 15/08 la trappola dei "60 secondi di
silenzio = ha finito" e' stata corretta in `prepara_broker_esterno.ps1` la
mattina e ha colpito `scarica_storico.ps1` la sera, uccidendo quattro corse.

Grep secchi da fare:
```
fermoDa -ge        (euristiche del silenzio)
Desktop            (la raccolta, punto 2 della regola delle righe di lancio)
```

## 3. 🎯 Il file dei parametri e' quello GIUSTO?

Una riga puo' essere sintatticamente perfetta e puntare alla cosa sbagliata.
Il 15/08 la riga R58 puntava a `prove\ABTG_PTE.txt`, che e' una **griglia da
16 celle**, mentre serviva **la cella viva congelata**. Sarebbero state ore di
tick reali per produrre una tabella da cui scegliere — cioe' l'ottimizzazione
che i nostri Spearman vietano.

**Domanda secca: questa riga CERCA o VERIFICA?** E il file che le passo fa la
stessa cosa?

## 4. 🔒 Il SHA contiene davvero la correzione che sto annunciando?

Il 15/08 ho mandato una riga dicendo "questa ha la guardia mercato-chiuso",
pinnata a un commit **precedente** a quella guardia.

```
git log --oneline -1 -- <il file che sto pinnando>
```
Se il commit del file e' piu' vecchio del SHA che scrivo, **il SHA e' buono**.
Se e' piu' nuovo, sto mentendo. Nel dubbio: **HEAD**.

---

## ⚙️ E due regole di traffico, sempre valide

**UNA MACCHINA, UN LAVORO.** Il PC di backtest ha **un solo MT5**. Prima di
mandare una riga che apre MT5, dichiaro cosa deve essere finito prima. Il
15/08 ho scritto "sono due macchine diverse e non si pestano i piedi": falso,
ed e' il tipo di frase che fa ammazzare una corsa da tre ore.

**Se lo script puo' spegnere qualcosa, lo dico nella riga stessa**, non in
fondo al messaggio.

---

> **Il criterio con cui giudicare questa lista**: se la prossima riga di
> lancio e' sbagliata, il problema non e' che manca un controllo — e' che non
> l'ho eseguita.

---

## 5. 🧪 SE LA RIGA USA `-Prova`: PRIMA UN GIRO A VUOTO

**Aggiunto il 16/08/2026, dopo aver capito R58.**

Il driver ha `-SoloControllo`: non lancia niente e stampa **esattamente** cosa
passerebbe a MT5.

```
    parametri in [TesterInputs] : N
    spazzolati                  : N
        <NomeParametro>          N celle
    celle per finestra          : N
```

**Si legge quella stampa e si confronta col file prova. Se non coincide, ci si
ferma li'** — in un minuto, non dopo due ore di tick reali.

### Perche' esiste questo punto

In R58 avevo scritto un file prova con **tutte le righe a flag `N`**, cioe'
zero assi da spazzolare. Il driver, in quel caso, **rifiuta di lanciare**:

```powershell
if($Sweep.Count -eq 0 -and $Errori.Count -eq 0){
  [void]$Errori.Add("nessun parametro da spazzolare: sarebbe un backtest singolo, non un walk-forward")
}
```

La corsa e' andata avanti con la **griglia di default** dell'EA, e me ne sono
accorto solo leggendo le `.ini` a posteriori. **Un giro a vuoto da un minuto
lo avrebbe mostrato prima di partire.**

### E il difetto gemello da ricordare (documentato nel driver, riga ~393)

> _"un pin scritto `Nome=35` imposta il VALORE ma NON spegne il flag di
> ottimizzazione che MT5 ricorda dall'ultima griglia di quell'EA -> il tester
> rispazzola la griglia vecchia nonostante il pin."_

**MT5 si ricorda i flag della griglia precedente.** Per questo i pin si
scrivono sempre in forma completa `v||v||0||v||N`, mai `Nome=v` secco.

### Regola pratica

> **Un file prova deve avere almeno UN asse con flag `Y`.**
> Se la domanda e' "voglio misurare UNA sola cella", non e' un walk-forward:
> serve un altro strumento, non questo driver.

---

## 🆕 AGGIUNTE DEL 18/08/2026 — tre giri a vuoto in una notte, tre controlli nuovi

_Contesto: la correzione del rischio nei .chr ha richiesto TRE tentativi.
Nessuno dei tre difetti era nella checklist. Adesso ci sono._

## 5. 🌍 CULTURA INVARIANTE, SEMPRE (il VPS e' Windows in ITALIANO)

`[double]::TryParse("2.0")` senza cultura, su it-IT, legge il punto come
separatore delle MIGLIAIA: viene fuori VENTI. Il 18/08 lo script "abbassa
rischio" ha visto 4 file e ne ha corretti 0 per questo.
**Ogni parse/format di numeri decimali nei .ps1 destinati al VPS usa
`InvariantCulture`. Grep secco: `TryParse|::Parse|ToString` senza
`InvariantCulture` vicino = riga da rifare.**

## 6. ⏱️ LA CACHE DI GITHUB RAW TIENE ~5 MINUTI

Se lo script e' stato pushato da poco, `raw.githubusercontent.com/.../lavoro/...`
puo' servire la versione VECCHIA (successo il 18/08: fix pushato, Claudio ha
rilanciato dopo 2 minuti, ha girato il bug). **Dopo un push fresco la riga
punta all'HASH del commit, non al branch — e quando possibile aggiunge il
controllo di versione (`Select-String` su un marcatore che esiste solo nella
versione nuova) PRIMA di eseguire.**

## 7. 🛑 GLI SCRIPT CHE SCRIVONO NEI FILE DI MT5 PRETENDONO MT5 CHIUSO

MT5 riscrive i .chr e i config all'uscita: una correzione applicata con MT5
aperto viene cancellata. **Ogni script che scrive in `MetaQuotes\Terminal`
apre con la guardia `Get-Process terminal64` e SI RIFIUTA se lo trova. E la
riga in chat dice esplicitamente: prima chiudi MT5, poi lancia, poi riapri.**
Bonus imparato lo stesso giorno: se il referto sul Desktop ha una riga
`data:` interna, dire a Claudio QUALE data deve leggerci — due volte ha
rimandato in buona fede il file vecchio delle 23:57.

---

## 🆕 AGGIUNTE DEL 18/08/2026 (sera) — trovate verificando `sistema_desktop.ps1`

## 8. 🕳️ SE L'`irm` FALLISCE, IL `;` TIRA DRITTO E GIRA LA COPIA VECCHIA

`irm ...; & "$env:USERPROFILE\script.ps1"` — il punto e virgola **non e' un
`&&`** (e su PS 5.1 il `&&` non esiste nemmeno). Se il download fallisce
(rete, 404, path sbagliato nella URL, TLS) l'errore rosso scorre via e la
riga esegue **la copia vecchia rimasta nel profilo**: e' esattamente il bug
del 10/08 (`maxmin_oro.ps1`) che l'`irm` doveva uccidere, tornato dalla
finestra. Tre pezzi, sempre tutti e tre:

```powershell
Remove-Item $p -ErrorAction SilentlyContinue          # 1: niente copia vecchia da eseguire
irm $u -OutFile $p -ErrorAction Stop                  # 2: errore TERMINANTE = la riga muore qui
if(-not (Select-String -Path $p -SimpleMatch -Pattern '<marcatore nuovo>' -Quiet)){ throw 'SCRIPT VECCHIO' }
```

Il marcatore e' una stringa che esiste **solo** nella versione nuova: copre
insieme la cache raw (punto 6) e il download andato a male.

## 9. 🧯 LA RISCRITTURA NON PUO' PERDERE LA SICUREZZA DEL GEMELLO

Il punto 2 dice "se correggo un difetto, lo cerco negli altri script". Il
rovescio e' altrettanto vero e costa di piu': `riordina_desktop.ps1` (14/08)
aveva `-Annulla` e un **log CSV `Origine,Destinazione`** per rimettere tutto
al suo posto; `sistema_desktop.ps1` (18/08), che fa lo stesso mestiere, era
nato con un log di sole frasi — **irreversibile**. Prima di mandare la riga
di uno script che ne rifa un altro: elencare le funzioni di SICUREZZA del
gemello (annulla, log macchina, guardie, `-Prova`) e verificare che ci siano
tutte. Corollario: due script che archiviano lo stesso Desktop in DUE alberi
diversi vanno dichiarati in chat, o Claudio si ritrova due archivi.

## 10. 💥 `$ErrorActionPreference = "Stop"` + ciclo di file = corsa monca e senza log

In un ciclo che sposta/scrive N file, **un solo file bloccato** (aperto in
Excel, in uso da MT5) fa saltare tutto lo script: quello che era gia' stato
mosso resta mosso e **il log finale non viene mai scritto**. Nei cicli su
file: `try{...}catch{ segnala e continua }`, e il log si scrive **sempre**,
anche a corsa interrotta. Stessa famiglia: il file di log scritto in una
cartella creata solo dentro il ramo "ho spostato qualcosa" esplode il giorno
in cui non si sposta niente — la cartella del log si crea **prima** di
scriverci.

## 11. 🏷️ UNA WHITELIST DI NOMI NON PUO' MANGIARSI LA BLACKLIST DEL GEMELLO

_Aggiunto il 18/08/2026 (sera), trovato verificando `sistema_cartelle.ps1`
**prima** dell'invio: il difetto era gia' committato, non e' ipotetico._

`riordina_desktop.ps1` (14/08) dichiara a chiare lettere, righe 15-16:
_"le cartelle gia' tematiche di Claudio (EASYTREND, INDICATORI, PIANO DI
TRADING, ...): sono gia' ordine, **non si spostano**"_ — ed e' implementata
come "nome non riconosciuto = resta fermo". Quattro giorni dopo
`sistema_cartelle.ps1` mette **quegli stessi nomi** (`EASYTREND`,
`INDICATORI`, `PIANO DI TRADI*`, `FILE WORD*`, `ALTA VELOCIT*`, `BREAKOUT`,
`PROCE*`) nella lista delle **riconosciute**, cioe' da spostare. Una
decisione presa e scritta viene ribaltata in silenzio da uno script nuovo
che nessuno ha riletto accanto al vecchio.

Due controlli, da fare insieme, su ogni script che decide PER NOME:
1. **La whitelist del nuovo si confronta riga per riga con le ESCLUSIONI
   dichiarate (anche solo nei commenti) dagli script gemelli precedenti.**
   Se un nome sta in una lista "mai toccare" del passato e nella lista
   "sposta" del presente: o e' un cambio di idea **dichiarato in chat e
   confermato da Claudio**, o e' un difetto.
2. **La cartella di destinazione deve dire la verita' sul contenuto.**
   `PIANO DI TRADING` dentro una cartella che si chiama `cartelle_test` e'
   una bugia archiviata: fra un mese non la ritrova nessuno, perche' la
   cerchera' fra i documenti. Famiglie diverse -> destinazioni diverse,
   oppure si lasciano ferme.

---

## 🆕 AGGIUNTE DEL 18/08/2026 (notte) — trovate verificando `installa_guardian.ps1`

## 12. 💾 IL BACKUP SENZA GUARDIA SI AUTO-DISTRUGGE AL SECONDO LANCIO

_Difetto vero, gia' committato in `installa_guardian.ps1` (a81632d, riga 58),
trovato PRIMA dell'invio della riga._

```powershell
if(Test-Path -LiteralPath $dest){ Copy-Item -LiteralPath $dest ($dest + ".prima_v110") -Force }
```

Primo lancio: `.prima_v110` = il file ORIGINALE, rollback perfetto.
**Secondo lancio** (e Claudio rilancia spesso: "non ero sicuro, rifaccio"):
`$dest` ormai contiene gia' la versione nuova, e `-Force` ci scrive sopra il
backup. Il rollback e' morto in silenzio, senza un errore rosso.

**Regola: un backup si scrive SOLO SE NON ESISTE GIA'.**
```powershell
$bak = $dest + ".prima_v110"
if((Test-Path -LiteralPath $dest) -and -not (Test-Path -LiteralPath $bak)){ Copy-Item -LiteralPath $dest $bak -Force }
```
Se serve davvero uno storico, il backup si data (`.prima_v110_20260818_2312`),
non si sovrascrive mai.

## 13. 🚦 SE LO SCRIPT CHIAMATO FA `exit 1`, LA CODA DELLA RIGA TIRA DRITTO

Estensione del punto 8 dal lato dell'USCITA. Il punto 8 copre l'`irm` che
fallisce; questo copre lo script che **parte, si accorge di un problema e si
ferma da solo**: `& $p; <riga di raccolta>` esegue la raccolta lo stesso e
scrive sul Desktop un referto che sembra buono ed e' la FOTO DEI FILE VECCHI.
E' esattamente il referto stantio del 17/08, ma prodotto da noi.

```powershell
$global:LASTEXITCODE = 0                      # 1: azzero PRIMA, o resta sporco dal comando precedente
& $p -Ref $h                                  # 2: lo script
if($LASTEXITCODE -ne 0){ throw "FALLITO: ..." }  # 3: -ne 0, NON -eq 0
```

⚠️ **`if($LASTEXITCODE -eq 0)` non basta**: uno script che finisce bene
**senza** istruzione `exit` NON tocca `$LASTEXITCODE`, che in una console
appena aperta vale `$null` — e `$null -eq 0` e' `$false`, quindi la raccolta
verrebbe saltata proprio quando e' andato tutto bene. Si azzera prima e si
controlla `-ne 0`.

Corollario che vale sempre: **ogni referto di raccolta porta dentro una riga
`data:`**, e la riga in chat dice a Claudio che quella data deve essere di
ADESSO.

---

## 🆕 AGGIUNTE DEL 18/08/2026 (notte) — trovate verificando `lancia_r81.ps1`

## 14. 🟢 IL GIRO A VUOTO CHE ESCE 0 ANCHE SE UN PEZZO E' FALLITO

_Difetto vero, gia' committato in `lancia_r81.ps1` (f2f9030, righe 171-177 e
204-223), trovato PRIMA dell'invio della riga._

Il punto 13 copre lo script che fa `exit 1` mentre la coda tira dritto. Questo
e' **il rovescio, ed e' peggio perche' non si vede**: uno script che lancia N
sotto-lavori, ne registra i falliti in una lista (`$falliti`), **non la
consulta mai** e chiude il ramo `-SoloControllo` con `exit 0` secco. La riga in
chat ha il suo bravo `if($LASTEXITCODE -ne 0){ throw ... }` — **e non scatta
mai**. Il guard e' decorativo, e Claudio manda avanti la corsa vera da due ore
credendo che il controllo sia passato.

Due controlli, insieme:
1. **Il codice d'uscita del giro a vuoto deve dipendere dai sotto-lavori**, non
   dal fatto di essere arrivato in fondo:
   `if($falliti.Count -gt 0 -or $senzaAnteprima.Count -gt 0){ exit 1 }`.
2. **Se non lo fa, la riga se lo verifica da sola** — contando gli ARTEFATTI
   che il giro a vuoto avrebbe dovuto produrre (le anteprime `.ini`, un file
   per sotto-lavoro): `if($a.Count -ne 6){ throw '...' }`.

**E gli artefatti INTERMEDI vanno ripuliti PRIMA, come gli script scaricati**
(punto 8) e come i referti (punto 13). Le anteprime `anteprima_*.ini` restano
sul disco fra un giro e l'altro: se stavolta la variante C non ne produce
nessuna, il riepilogo stampa **quella del giro precedente** e Claudio confronta
coi criteri dei numeri vecchi, in buona fede. E' il referto stantio del 17/08
travestito da anteprima. Nella riga: `Remove-Item "...\anteprima_r81*.ini"
-ErrorAction SilentlyContinue` prima di lanciare.

## 15. 🔁 IL RILANCIO MIRATO CHE NON RILANCIA NIENTE

Stesso script, stessa sera. `walkforward_generico.ps1` (riga 580) **salta i CSV
gia' presenti** se non gli si passa `-Rifai` — ed e' giusto cosi', e' quello che
permette di riprendere una corsa interrotta. Ma il driver del round
(`lancia_r81.ps1`) **non ha `-Rifai` e non lo inoltra**: la riga documentata
"se serve rifare UNA variante: `-Solo D`" **non rifa' un bel niente** su una
variante gia' fatta. Gira per dieci secondi, rifa' solo la raccolta e stampa
tutto verde.

**Regola: prima di scrivere in un referto una riga di "rilancio mirato", si
verifica che il gemello chiamato non abbia una guardia di idempotenza che la
annulla.** O si inoltra il `-Rifai`, o la riga cancella prima i file di quella
variante e lo DICE.

---

## 🆕 AGGIUNTE DEL 18/08/2026 (notte) — trovate verificando `dukascopy_m1.py`

## 16. ☠️ LA CACHE DI RIPRESA CHE SI AVVELENA DA SOLA

_Difetto vero, gia' committato in `dukascopy_m1.py` (7ca2629, righe 165-194),
trovato PRIMA dell'invio della riga. Riprodotto: file troncato in cache ->
`LZMAError` -> ora saltata **a ogni rilancio, per sempre**._

Il punto 15 dice che una guardia di idempotenza puo' annullare un rilancio.
Questo e' il caso peggiore della famiglia: una **cache di ripresa** — quella
che rende interrompibile una corsa da due notti — scritta **senza atomicita'
e senza verifica**. Se la corsa muore a meta' di una `write` (Ctrl+C, riavvio,
disco pieno) resta sul disco un file **troncato**. Al rilancio la cache dice
"ce l'ho gia'", lo rilegge, la decodifica esplode, quel pezzo viene saltato —
e non si recuperera' **mai piu'**, perche' nessun rilancio lo riscarica. Il
buco resta silenzioso e il codice d'uscita resta 0.

Stessa trappola con la risposta **200 che non e' il dato** (pagina d'errore
del CDN, risposta troncata): finisce in cache come se fosse buona.

Tre pezzi, sempre tutti e tre, su qualunque cache "riprendi da dove eri":
```python
if non_decodificabile(dati_dalla_cache): os.remove(file)   # 1: la cache si BUTTA, non si salta
if not decodificabile(dati_scaricati):   non_scrivere()    # 2: in cache ci va solo roba valida
open(tmp,"wb").write(...); os.replace(tmp, definitivo)     # 3: scrittura ATOMICA
```
**Corollario per la riga in chat**: "puoi interrompere e riprendere" e'
una promessa che va **provata**, non dichiarata. Se la si scrive in un
referto, prima si simula l'interruzione.

## 17. 🐍 L'INTERPRETE DATO PER PRESENTE (e lo stub del Microsoft Store)

_Il referto Dukascopy scriveva "Python c'e' gia': `run_all.ps1` lo invoca".
`run_all.ps1` (righe 116-121) fa l'ESATTO contrario: `Get-Command` con
`-ErrorAction SilentlyContinue` e il ramo "Python non trovato: uso gli .ini
gia' presenti (nessun problema)". Cioe' il gemello lo tratta da **opzionale**:
non e' una prova di presenza, e' una prova che qualcuno aveva gia' il dubbio._

E' la famiglia della `@DAQUANDO` inventata, applicata agli strumenti: **la
presenza di un interprete/eseguibile e' MISURATA o DICHIARATA MANCANTE, mai
dedotta dal fatto che uno script lo nomina.**

E su Windows non basta `Get-Command python`: esiste l'**alias di esecuzione
del Microsoft Store** in `...\AppData\Local\Microsoft\WindowsApps\python.exe`,
che **non e' Python** — apre la pagina dello Store e torna subito. La riga
sembra partita e non ha fatto niente.

```powershell
$py=(Get-Command python.exe -EA SilentlyContinue | ? { $_.Source -notlike "*\WindowsApps\*" } | select -First 1).Source
if(-not $py){ $py=(Get-Command py.exe -EA SilentlyContinue | select -First 1).Source }
if(-not $py){ throw "PYTHON ASSENTE: installalo da python.org con 'Add python.exe to PATH'" }
$global:LASTEXITCODE=0; & $py -c "import sys; sys.exit(0 if sys.version_info>=(3,8) else 1)"
if($LASTEXITCODE -ne 0){ throw "PYTHON TROPPO VECCHIO O NON FUNZIONANTE: $py" }
```
Vale per ogni dipendenza esterna che la riga assume: si verifica **prima**,
con un throw, non si scopre a corsa avviata.

---

## 🆕 AGGIUNTE DEL 18/08/2026 (notte) — trovate verificando il TORNEO JPY (R82)

## 18. 📐 LA PROFONDITA' DELLO STORICO MISURATA SU UN TF, LA CORSA GIRATA SU UN ALTRO

_Difetto vero, gia' committato in `prove/TORNEO_JPY_CRITERI.md` (d63ca2d, §3.4) e
nei 7 file prova `R82a..g`, trovato PRIMA dell'invio della riga._

La finestra del round e' `@DAQUANDO 2007.02.12`, e la data e' **misurata** — la
sonda del 17/08 la dichiara `PrimaDataTF H1`. Ma il giro 1 gira a **modello 1
(OHLC su M1)**, e il tester di MT5 costruisce **sempre** le sue barre dal **M1**:
la profondita' che morde e' quella dell'**M1**, che **non e' mai stata misurata**.
Nei broker la profondita' M1 e' regolarmente molto piu' corta di quella H1.

E' la famiglia della `@DAQUANDO` inventata (punto 11), col trucco che stavolta
**il numero e' misurato davvero** — solo su un'altra grandezza. Il controllo
sembra fatto, e non c'e'.

> **La data d'inizio si misura sul TIMEFRAME CHE IL TESTER USA DAVVERO**
> (M1 per i modelli 0/1/2), non sul TF su cui e' comoda la sonda. E la riga in
> chat dice a Claudio **quale RIGA del referto leggere**, non solo quale file:
> "la riga `M1` di tutti e sette, colonna `PrimaDataServer`".

⚠️ **Precisazione misurata il 18/08 (notte), leggendo `ABTG_HistoryDownloader.mq5`
riga 229-232: sulle righe `TICK` la colonna `PrimaDataServer` vale SEMPRE `-`**
(per i tick il downloader non chiede `SERIES_SERVER_FIRSTDATE`, che e' una cosa
delle barre). Quindi: **barre -> `PrimaDataServer`; TICK -> `PrimaDataLocale`.**
Chi applicasse "leggi PrimaDataServer" alla riga TICK leggerebbe un trattino e
concluderebbe che i tick non ci sono. A modello 4 la riga che conta e' `TICK`.

Corollario di traffico: prima di bruciare le ore della griglia intera, si gira
**un solo simbolo** (`-Solo`) come canarino. Costa mezz'ora e misura sul serio
compilazione, profondita' vera, CSV prodotti e passate gemelle.

## 19. ⏳ IL TIMEOUT DI DEFAULT PIU' CORTO DELLA DURATA CHE IL REFERTO STESSO STIMA

_Difetto vero: il referto del torneo stima il passo 0 in **1-3 ore** e la riga
chiamava `scarica_storico.ps1` **senza `-TimeoutMin`**, cioe' col default di
**90 minuti** (riga 47)._

Allo scadere del timeout lo script **non e' un errore**: esce dal ciclo, trova
`$visto = $true`, **ammazza MT5 con `Stop-Process -Force` a meta' scaricamento**,
stampa il referto di quello che c'e' e **finisce con codice 0**. La riga in chat
sembra riuscita, il `.zip` sul Desktop e' pieno, e lo storico e' monco: e' il
referto stantio del 17/08 rifatto in casa, stavolta con l'aggravante che il
processo e' stato ucciso mentre scriveva le cache dello storico.

Due controlli, insieme:
1. **La durata stimata nel referto e il `-TimeoutMin` (o equivalente) dello
   script chiamato si confrontano NUMERO CONTRO NUMERO.** Se la stima e' 1-3
   ore, il timeout non puo' essere 90 minuti: la riga lo passa esplicito.
2. **Un timeout non puo' uscire 0.** Se lo script chiamato non lo distingue da
   una fine regolare, lo si dice nella riga e si controlla l'artefatto (qui: la
   colonna `Verdetto` di tutte le righe del referto, non la sola presenza del
   file).

## 20. 🧾 IL COLLAUDO CHIESTO A CLAUDIO CHE CON QUEL TASTO NON PUO' USCIRE

_Il referto del torneo chiedeva: "**F7** su `ABTG_BreakoutCorso.mq5` e copia qui
le tre righe `[BRK][AUTOTEST]`". Quelle righe le stampa `OnInit`
(`ABTG_BreakoutCorso.mq5` riga 199, `if(InpAutoTest) TestCasoDelCorso();`):
**F7 compila e basta, non esegue niente**. E il `.mq5` non e' nemmeno dentro
`MQL5\Experts` finche' non ci gira il driver, che ce lo copia lui (riga 567 di
`walkforward_generico.ps1`) — quindi in MetaEditor non c'e' proprio niente da
premere._

**Quando la riga chiede a Claudio un OUTPUT, si verifica dove nasce quell'output
e se il gesto richiesto lo produce davvero.** Print in `OnInit` = serve
un'ESECUZIONE (test singolo nello Strategy Tester), non una compilazione. E se
l'artefatto non e' ancora installato sulla macchina, si dice **chi** ce lo
installa e **quando**.

⚠️ E mai "attacca l'EA a un grafico" per farlo stampare: sul PC di backtest il
terminale e' collegato al conto vivo (`walkforward_generico.ps1` righe 592-600,
il DAX partito davvero il 14/08). Il collaudo si fa nel **tester**, in test
singolo.

---

## 🆕 AGGIUNTE DEL 18/08/2026 (notte) — trovate verificando `histdata_m1.py`

## 21. 📋 IL BLOCCO MULTI-RIGA INCOLLATO NON E' UN PROGRAMMA

_Difetto vero, gia' committato nella bozza del par. 7 di
`REFERTO_HISTDATA_FATTIBILITA.md` (f3b5eb9), trovato PRIMA dell'invio._

Tre righe una sotto l'altra dentro un blocco ```powershell **non sono uno
script**: incollate in console sono **tre comandi indipendenti**. Il punto 8
copre l'`irm` seguito da `;` (stessa riga), il punto 13 copre l'`exit 1` non
guardato — **questo copre il caso in cui la guardia c'e' e non serve a
niente**, perche' un `throw` alla riga 1 termina solo la riga 1: la riga 2
parte lo stesso, un istante dopo, sulla copia vecchia o sul nulla.

Nella bozza HistData: `irm` (riga 1), `python --autotest` (riga 2),
`python --esplora` (riga 3). Con l'`irm` a 404 partivano lo stesso le altre
due; con l'autotest rosso partiva lo stesso l'esplorazione.

> **Regola: una riga di lancio a piu' passi si consegna come UN SOLO comando.**
> O one-liner con `;` (dove un `throw` non catturato ferma davvero il resto
> della riga), o — meglio, perche' resta leggibile — tutto dentro
> `& { ... }`, graffe comprese, **e la chat dice "incolla il blocco INTERO"**.

## 22. 🧭 IL REFERTO CHE ISTRUISCE SUL PASSO DOPO ANCHE QUANDO NON C'E' NIENTE

_Difetto vero e **riprodotto** (`histdata_m1.py` v1, righe 943-959): lanciata
`--esplora` con il canale di rete morto, lo script ha correttamente scritto
"CONTROLLO POSITIVO FALLITO, non si misura niente" **e subito sotto** ha
stampato "PROSSIMO PASSO: copiare il/i CSV in `MQL5\Files`, lanciare
`ABTG_ImportaStoricoEsterno`...". Nessun CSV esisteva. Uscita: **0**._

E' il fratello del referto stantio: non un file vecchio, ma **istruzioni vere
per un artefatto che non e' mai nato**. Chi legge il fondo del referto (cioe'
tutti: e' li' che si guarda cosa fare adesso) parte col passo successivo su
dati inesistenti.

> **La coda "prossimo passo" di un referto si stampa SOLO SE gli artefatti che
> quel passo consuma esistono davvero** (`if csv_prodotti:`), e il referto
> chiude con una riga `ESITO: OK` / `ESITO: FALLITO -- <n> problemi` che dice
> la stessa cosa del codice d'uscita. Le due cose non possono divergere.

---

## 🆕 AGGIUNTE DEL 18/08/2026 (notte) — trovate verificando `lancia_r84.ps1` e `lancia_r83.ps1`

## 23. 🥫 L'ARTEFATTO DI INPUT SCADUTO: il passo dopo lo mangia senza guardare la data

_Difetto vero, gia' committato in `lancia_r84.ps1` (riga 196) e `lancia_r83.ps1`
(riga 189), trovato PRIMA dell'invio della riga._

I punti 13 e 14 coprono gli artefatti che uno script **produce** (referto,
anteprime). Questo copre quelli che **consuma**, prodotti da un passo
precedente, magari ieri. Il PASSO 0 dei due driver fa:

```powershell
if (-not (Test-Path -LiteralPath $CsvStorico)) { Muori "il referto non c'e'..." }
```

`Test-Path` e basta. Se la sonda dello storico e' fallita, o e' stata uccisa dal
timeout, sul Desktop resta il referto **della settimana prima**: il controllo
sulla profondita' dei tick lo legge, lo trova coerente e **passa in silenzio**.
Il round parte su una misura vecchia — ed e' il referto stantio del 17/08,
stavolta in ingresso invece che in uscita.

Due pezzi, insieme:
1. **La riga che PRODUCE l'artefatto lo cancella prima di rifarlo**
   (`Remove-Item $csv -Force -EA SilentlyContinue`), cosi' una corsa fallita non
   lascia in piedi il file vecchio.
2. **Lo script che lo CONSUMA ne guarda l'ETA', non solo l'esistenza:**
   ```powershell
   $eta = (New-TimeSpan -Start (Get-Item -LiteralPath $f).LastWriteTime -End (Get-Date)).TotalHours
   if($eta -gt 48){ Muori ("questo referto ha " + [int]$eta + " ore: rifai la misura prima di girare.") }
   ```

### 23-bis. 📼 E IL LOG DI IERI CHE FA DA SEGNALE DI FINE (pagato il 18/08, ore 21:17)

_Stessa famiglia, scoperto DENTRO un guardiano scritto apposta contro il
difetto n.8 delle euristiche del silenzio. `scarica_storico.ps1` fotografa la
lunghezza dei log PRIMA di partire e poi rilegge "solo il nuovo" —_

```powershell
if ($da -gt 0 -and $da -lt $fs.Length) { [void]$fs.Seek($da, ...) }   # SBAGLIATO
```

_ma quando un file **non e' cresciuto** la condizione e' falsa, il `Seek` non
viene fatto e il file viene letto **DA CAPO**: il `=== FINITO` della corsa di
**ieri sera** e' stato preso per quello di adesso, MT5 e' stato ammazzato **15
secondi** dopo il lancio e il CSV e' rimasto a **0 byte**. Il PASSO 0 e' finito
"riuscito"._

> **Un "ho gia' visto il segnale di fine" va cercato SOLO nei byte scritti dopo
> l'inizio della corsa.** File non cresciuto = niente da leggere, si salta:
> ```powershell
> if ($da -ge $fs.Length) { $fs.Close(); continue }
> if ($da -gt 0) { [void]$fs.Seek($da, [System.IO.SeekOrigin]::Begin) }
> ```
> E il caso opposto va conservato: un log **creato dopo** la fotografia ha
> `$da = 0` e si legge **tutto**, altrimenti si perde il FINITO vero.
> Corollario: la contromisura a un difetto (il marcatore di fine contro il
> silenzio) **puo' avere il suo difetto**. Si prova con log finti, prima.

## 24. 📌 IL PIN CHE NON COPRE IL PEZZO PIU' IMPORTANTE (perche' lo scarica il gemello)

_Difetto vero, gia' committato in `walkforward_generico.ps1` (riga 78-79 e
129-136), trovato PRIMA dell'invio della riga di R83/R84._

Il punto 6 dice "dopo un push fresco la riga punta all'HASH". Ma la riga pinna
solo quello che scarica **lei**. Qui il driver di round pinna i `.ps1` e i file
prova all'hash, poi chiama `walkforward_generico.ps1`, che ha dentro:

```powershell
$EABranch="lavoro"
... Invoke-WebRequest -Uri "$RawBase/mql5/Experts/$Expert.mq5" -OutFile $srcFile
catch{ ... Write-Host "(download fallito: uso la copia locale gia' scaricata)" }
```

cioe' **riscarica l'EA da `lavoro` HEAD ignorando `-Rif`**, e se il download va
male **ripiega in silenzio sulla copia locale**. Su un round che dura due notti
questo vuol dire: un push a meta' corsa cambia il motore **fra una cella e
l'altra**, e un confronto fra celle (o un canarino di equivalenza) non misura
piu' niente. La riga sembra pinnata e l'artefatto che conta di piu' non lo e'.

> **Prima di scrivere "riga pinnata a `<sha>`", si elenca cosa scarica il
> GEMELLO chiamato, e da dove.** Se scarica da HEAD: (1) la riga confronta byte
> a byte HEAD contro il pin e si ferma se differiscono
> (`if((irm "$b/lavoro/$f") -ne (irm "$b/$sha/$f")){ throw }`), (2) la chat
> dichiara il **congelamento del branch** per tutta la durata del round, e
> (3) il fix vero (inoltrare `-Rif`, togliere il ripiego silenzioso) va in coda
> come lavoro a se', dichiarato nel referto.

---

## 🆕 AGGIUNTA DEL 19/08/2026 — trovata verificando il collaudo di `_ImportaStoricoEsterno_v2`

## 25. 🎚️ IL PRESET VECCHIO NON SPEGNE L'INPUT NUOVO (e MT5 si ricorda l'ultimo)

_Difetto vero, trovato PRIMA dell'invio: i tre `.set` scritti il 18/08
(`MQL5\Presets\abtg_import_*.set`) contengono 8 input; la v2 dello script ne ha
**due in piu'** (`InpShiftDstAware`, `InpAutoTest`)._

Il punto 5 ha gia' il difetto gemello sul **tester** (_"un pin `Nome=35`
imposta il valore ma NON spegne il flag che MT5 ricorda dall'ultima griglia"_).
Questo e' lo stesso meccanismo nella **finestra dei parametri di uno script o
EA**: un input che il `.set` **non nomina** non torna al suo default quando
carichi il preset — resta **l'ultimo valore usato a mano**, che MT5 conserva.

Sequenza che sarebbe successa domattina: giro di autotest con
`InpAutoTest = true` (a mano), poi `Carica > abtg_import_NASUSD.set` per
l'import vero. Il preset non nomina `InpAutoTest`, quindi resta **true**: lo
script stampa *"MODO AUTOTEST: NON viene importato nulla"* ed **esce**. Tre
import "riusciti" che non hanno importato niente, e un referto che non si
aggiorna — cioe' i numeri di ieri riletti come quelli di oggi (punto 23).

> **Quando uno script/EA guadagna un input NUOVO, i preset vecchi vanno
> RISCRITTI, non riusati "tanto il default e' giusto".** Il default vale al
> primo avvio, non dopo che qualcuno ha toccato quel campo. La riga di lancio
> lo fa da sola, e in modo idempotente (togli le righe di quell'input, poi
> riaggiungile):
> ```powershell
> $righe = @(Get-Content -LiteralPath $set | Where-Object { $_ -notmatch '^(InpAutoTest|InpShiftDstAware)=' })
> $righe += "InpShiftDstAware=true"; $righe += "InpAutoTest=false"
> Set-Content -LiteralPath $set -Value $righe -Encoding ASCII
> ```
> Corollario dello stesso giro: **`Print()` di uno script MQL5 finisce nella
> scheda "Esperti" e in `MQL5\Logs\<data>.log`, NON nel Journal** (che sta in
> `logs\`). Chiedere "copiami il Journal" e' chiedere il file sbagliato: e' il
> punto 20 visto dal lato del POSTO, non del gesto.

---

## 🆕 AGGIUNTA DEL 19/08/2026 — trovata verificando il collaudo della migrazione Guardian

## 26. ☢️ IL COLLAUDO CHE PUO' FARE DANNO MENTRE MISURA

_Difetto vero, gia' scritto in un referto (`REFERTO_MIGRAZIONE_GUARDIAN_PREPARAZIONE.md`,
FASE 1: "sul Guardian mettere `InpAutotest=true`, avviarlo su un grafico
qualsiasi, leggere la scheda Esperti"). Trovato PRIMA dell'invio._

Il punto 20 chiede: **l'output che sto chiedendo, quel gesto lo produce?** Qui
la risposta era si'. La domanda che mancava e' l'altra meta':

> **oltre a stampare, quella cosa COSA FA?**

`ABTG_Guardian` con i suoi default e' **armato**: `InpAction = 0`
(CHIUDI+BLOCCA) e `InpCloseAllMagics = true`. E `OnInit` **non si ferma dopo
l'autotest**: prosegue, scrive le GlobalVariable, arma `EventSetTimer(1)` e
chiama subito `OnTimer()`. Sul PC di backtest il terminale e' collegato al
**conto vivo**, lo stesso su cui opera la flotta del VPS: se in quel momento la
giornata fosse oltre il limite, `FlattenAll()` **chiuderebbe tutte le posizioni
del conto** — per leggere tre righe di autotest.

Non e' teorico: e' lo stesso terminale che il 14/08 ha piazzato un ordine vero
partendo da un backtest (punto 20, nota finale).

Tre domande, prima di far girare qualcosa **per leggerne l'output**:
1. **Cosa tocca oltre allo schermo?** posizioni, ordini, file di MT5,
   GlobalVariable, preset. Se tocca il conto: si **disarma** prima (qui:
   `InpAction=1`, soglie a 0) o si va nel **tester**.
2. **L'autotest e' un ramo che ESCE, o solo un pezzo di strada?** Se `OnInit`
   continua dopo, il collaudo non e' isolato: `return(INIT_SUCCEEDED)` subito
   dopo i `Print` sarebbe la forma giusta, e va chiesta.
3. **Su quale CONTO e su quale ISTANZA gira?** Un terminale "di prova" collegato
   al conto vivo non e' di prova. E dove ci sono due istanze (qui `-V3` per il
   100k), la riga sceglie quella giusta **per nome** e si rifiuta se non la
   riconosce — mai `Select-Object -First 1` su tutti i `terminal64.exe`.

---

## 🆕 AGGIUNTA DEL 19/08/2026 — trovata verificando le bozze del par. 16 (HistData v4)

## 26. 🗜️ DUE CHIAMATE NELLO STESSO BLOCCO, UNA SOLA RACCOLTA: la seconda cancella la prima

_Difetto vero e **RIPRODOTTO** (bozza 16.2 del referto HistData, gia' committata).
Lo script raccoglie da solo sul Desktop, e va benissimo — finche' lo si chiama
UNA volta. La bozza lo chiamava **due** volte nello stesso blocco (indici, poi
EURUSD in un'altra cartella)._

Due meccanismi che si sommano, ed e' il secondo che uccide:
1. il referto ha il nome al **minuto** (`referto_..._0757.txt`): due corse
   ravvicinate producono lo **stesso nome** e la seconda sovrascrive;
2. la raccolta apre lo zip in modo `"w"`, che **tronca**: lo zip finale
   contiene **solo** i file dell'ultima chiamata.

Eseguito: la prima chiamata (la misura buona) e' sparita da cartella **e** zip,
e al suo posto e' rimasto il referto della seconda, che era pure **fallita**
(`NESSUNA BARRA ... ESITO: FALLITO`). La riga diceva "manda lo zip in chat":
Claudio avrebbe mandato in buona fede **la foto del fallimento al posto della
misura**. E' il referto stantio del 17/08 con un meccanismo nuovo — non un file
vecchio, ma un file **giusto sovrascritto da uno sbagliato** nello stesso minuto.

> **Se un blocco chiama lo stesso strumento piu' di una volta, la raccolta non
> puo' restare quella automatica dello strumento.** Dopo OGNI chiamata si mette
> l'artefatto in una cartella di sosta con un **nome proprio**, e lo zip si fa
> in fondo, una volta sola:
> ```powershell
> $r=Get-ChildItem "$dsk\referto_*.txt" | Sort-Object LastWriteTime | Select-Object -Last 1
> Copy-Item $r.FullName "$stag\vol_INDICI.txt" -Force      # <- nome PROPRIO, subito
> ...
> Compress-Archive -Path "$stag\*" -DestinationPath $zip -Force
> ```
> E la riga in chat dice **quali file devono esserci dentro**, per nome: se ne
> manca uno si vede prima di mandarlo, non dopo.

### 26-bis. 🟢 E IL GATE CHE UCCIDE IL RISULTATO BUONO

Stessa verifica, bozza 16.1. `--estrai` su una finestra **vuota** esce **1** —
ma la finestra vuota **era l'ipotesi che stavamo cercando di confermare** (buco
di feed). Il `throw` scattava **dopo** che il referto era gia' scritto e
**prima** della riga che dice a Claudio di mandarlo: schermo rosso, nessuna
istruzione, risposta buona abbandonata sul disco. Il messaggio del `throw`
diceva perfino "mandala lo stesso" — a una riga che era gia' morta.

> **Prima di mettere `throw` su `$LASTEXITCODE`, si stabilisce se quel codice
> ≠ 0 significa "la corsa e' andata male" o "la corsa e' riuscita e la risposta
> non ti piace".** Nel secondo caso il gate va sull'**ARTEFATTO** (esiste? e'
> di adesso?), e l'esito si stampa in giallo senza fermare la raccolta:
> ```powershell
> if(-not $ref){ throw "NON PARTITA: nessun referto" }
> if((New-TimeSpan -Start $ref.LastWriteTime -End (Get-Date)).TotalMinutes -gt 10){ throw "REFERTO STANTIO" }
> if($rc -ne 0){ Write-Host "ESITO FALLITO: e' gia' una risposta, manda il referto" -ForegroundColor Yellow }
> ```

---

## 🆕 AGGIUNTA DEL 19/08/2026 — trovata verificando l'installazione di `ABTG_LivelliChiave`

## 27. 🔨 INSTALLO IN **N** POSTI, COMPILO IN **UNO**: il sorgente c'e' ovunque, l'indicatore da nessuna parte

_Difetto vero, trovato PRIMA dell'invio. La riga copiava `ABTG_LivelliChiave.mq5`
in **tutte** le cartelle dati MT5 del VPS (APPDATA + Program Files, quelle con
`MQL5\Experts`) e chiudeva con una sola frase: "Ora MetaEditor (F4 da MT5) ->
apri il file da Indicators -> F7"._

Il punto 20 chiede: **il gesto che sto chiedendo produce l'output?** Qui la
risposta e' si'... **in un posto solo**. `F7` compila il `.mq5` **dove sta**, e
scrive l'`.ex5` accanto al sorgente: cioe' nella cartella dati del **terminale
da cui e' stato aperto MetaEditor**. Negli altri N-1 terminali resta il sorgente
**non compilato**, e il Navigatore di MT5 elenca gli **`.ex5`**, non i `.mq5`.

Sul VPS ci sono piu' istanze (il punto 26 lo dice gia': `-V3` per il 100k).
Sequenza che sarebbe successa: la riga stampa tre percorsi in verde, Claudio
compila dal terminale A, apre il grafico sul terminale B e **non trova
l'indicatore nel Navigatore**. Riga tornata indietro, non per un bug, ma perche'
la riga ha promesso "INSTALLATO IN: 3" a proposito di un artefatto che a quel
punto esisteva in 1.

> **Se la riga installa in piu' posti, deve dire quante volte va fatto il gesto
> che rende l'artefatto USABILE** — e distinguere in chiaro **cosa e' copiato**
> (il sorgente, N volte) da **cosa e' compilato/attivo** (l'`.ex5`, una volta per
> terminale). Vale per ogni coppia sorgente/binario: `.mq5`->`.ex5`, preset,
> template.

### 27-bis. 🌳 E L'ALBERO DI METAEDITOR NON SI ACCORGE DEI FILE NUOVI

Stesso giro. Se MetaEditor era **gia' aperto** quando la riga ha copiato il file,
il suo Navigatore mostra l'albero **fotografato all'apertura**: il file nuovo non
c'e', e "aprilo da Indicators" diventa un giro a vuoto con Claudio che cerca una
cosa che sul disco c'e' gia'. La riga lo dice da sola: **se MetaEditor era
aperto, chiudilo e riaprilo** (o tasto destro sulla cartella -> Aggiorna).

### 27-ter. 🧪 E LA GUARDIA DI COPIA CHE GUARDA IL NOME, NON IL CONTENUTO

Trovato **eseguendolo**, nello stesso giro. La riga verificava la copia cosi':

```powershell
Copy-Item -LiteralPath $tmp -Destination $dst -Force -EA Stop
if(-not (Test-Path -LiteralPath $dst)){ throw "copiato ma non trovato" }
```

Riprodotto: se in `$dst` esiste una **cartella** con lo stesso nome del file,
`Copy-Item` ci mette il file **dentro** e `Test-Path` trova la **cartella** ->
la riga stampa `INSTALLATO IN` e **non ha installato niente**. E' il guardiano
decorativo del punto 14, applicato alla copia. Una verifica di copia si fa sul
**contenuto**, non sull'esistenza di un nome:

```powershell
$len=(Get-Item -LiteralPath $tmp).Length
...
$v=Get-Item -LiteralPath $dst -EA Stop
if($v.PSIsContainer -or $v.Length -ne $len){ throw "copia NON verificata" }
```

---

## 🆕 AGGIUNTA DEL 19/08/2026 — trovata verificando la diagnosi "dove stanno le copie"

## 28. 🔭 IL CONTEGGIO CHE DEVE SPIEGARE UN ALTRO CONTEGGIO SI FA SULLO STESSO PERIMETRO

_Difetto vero, trovato PRIMA dell'invio. `censimento_rischio.ps1` (riga 27) legge
**solo** `%APPDATA%\MetaQuotes\Terminal` e ha dato 55,30% invece di 43,30%. La
riga diagnostica scritta per spiegare quello scarto scandiva **APPDATA PIU'
`C:\Program Files*`**, e mescolava le due fonti in un elenco unico._

I punti 18 e 23 coprono la misura fatta sulla grandezza sbagliata e l'artefatto
di ingresso scaduto. Questo copre il caso in cui **lo strumento che deve
spiegare un numero non guarda lo stesso mondo che quel numero ha guardato**.
Le copie trovate in Program Files non erano MAI entrate nel 55,30%: elencate
senza etichetta avrebbero portato ad accusare della duplicazione dei file che
nel totale sbagliato non c'erano, e lo scarto non sarebbe tornato lo stesso.

> **Uno strumento diagnostico dichiara il suo PERIMETRO e lo confronta, riga per
> riga, con quello dello strumento che deve spiegare.** Se e' piu' largo (e va
> bene che lo sia: si scopre di piu') ogni risultato porta un'etichetta
> `[DENTRO]` / `[FUORI]`, e i totali si fanno **solo sul perimetro originale**.
> E la riga stampa l'aritmetica per esteso — `somma copie` / `somma sedie
> uniche` / `differenza` — perche' e' la differenza che si stava cercando, non
> l'elenco.

### 28-bis. 🤫 `-ErrorAction SilentlyContinue` DENTRO UN CICLO CHE CONTA = totale corto e sicuro di se'

Il punto 10 dice che `$ErrorActionPreference="Stop"` in un ciclo su file fa una
corsa monca. **Il rovescio costa di piu' quando il risultato E' un conteggio**:

```powershell
$t=Get-Content -LiteralPath $c.FullName -Raw -Encoding Unicode -EA SilentlyContinue
if(-not $t){ continue }        # file sparito dal totale, e nessuno lo sapra' mai
```

Riprodotto su un albero finto: un `.chr` illeggibile e' uscito dal referto senza
una riga di traccia, e in fondo c'era scritto `totale file trovati: 6` — un
numero preciso, tondo e **sbagliato**. Con MT5 **aperto** non e' ipotetico: e'
il lock del 14/08 gia' pagato in `elenco_ea_attaccati.ps1`, che infatti legge
con `[IO.FileShare]::ReadWrite` (righe 77-85) e **decide l'encoding dal BOM**
(righe 88-101) invece di imporne uno.

> **In un ciclo che produce un conteggio, ogni `continue` silenzioso va contato
> e ELENCATO nel referto**, e l'esito finale lo dice: `ESITO: PARZIALE -- n file
> non letti`. Un totale senza il numero degli scarti non e' un totale, e'
> un'opinione. Corollario gemello: `-Encoding Unicode` imposto a mano su file
> che potrebbero non esserlo trasforma un errore di lettura in **zero risultati
> silenziosi** — l'encoding si sceglie dal BOM, mai per decreto.

---

## 🆕 AGGIUNTA DEL 19/08/2026 — trovata verificando la pulizia dei 12 `.chr` fantasma

## 29. 🕛 LA GUARDIA COSTRUITA SU "OGGI" SI SPEGNE DA SOLA A MEZZANOTTE

_Difetto vero, trovato PRIMA dell'invio di una riga **distruttiva** (cancellare
12 `.chr` orfani nel profilo ORO mentre MT5 e' aperto). L'unica cosa che
separava i 12 file morti dai 12 grafici VIVI era il timestamp:_

```powershell
$limite=(Get-Date).Date.AddHours(12).AddMinutes(30)   # SBAGLIATO
if($it.LastWriteTime -ge $limite){ salta }            # i vivi sono delle 13:08
```

La riga e' culture-safe (nessun parse di data da stringa: giusto). Ma
`(Get-Date).Date` **e' una cosa diversa a ogni giorno che passa**: rilanciata
dopo mezzanotte — e Claudio rilancia di notte, il 17/08 e il 18/08 i giri a
vuoto sono tutti dopo le 23 — il limite diventa **le 12:30 di DOMANI**, i file
vivi delle 13:08 di oggi ci finiscono **sotto**, e la protezione **non protegge
piu' niente**. Riprodotto: `13:08 di oggi -ge 12:30 di domani` = `False`.
Nessun errore, nessun rosso: la guardia c'e', ha smesso di funzionare.

> **Una soglia temporale che divide "cosa e' vivo" da "cosa e' morto" si ancora
> all'ISTANTE MISURATO, non a "oggi".** Si scrive assoluta, col costruttore a
> interi (culture-free, nessuna stringa da interpretare):
> ```powershell
> $limite=New-Object DateTime 2026,8,19,12,30,0
> ```
> Cosi' la riga vale domani, fra una settimana e al secondo rilancio: e' la
> stessa fotografia che l'ha giustificata. **Se un numero della riga viene da
> una misura, nella riga ci va la MISURA, non un modo di ricalcolarla.**

### 29-bis. 🧊 E LA FOTOGRAFIA SU CUI SI BASA UNA CANCELLAZIONE VA RICONTROLLATA A RUNTIME

Stessa riga. La premessa era: _"i vivi sono chart29-40, riscritti alle 13:08;
i fantasma sono chart41-52, fermi alle 11:53"_. Se fra la diagnosi e il lancio
MT5 riordina o risalva il profilo, quella premessa **puo' non essere piu' vera**
e i nomi non vogliono piu' dire niente. Prima di cancellare, la riga verifica
che il mondo sia ancora quello misurato — e se non lo e', **si ferma**:

```powershell
$vivi=@($tutti | Where-Object { $_.LastWriteTime -ge $limite })
if($vivi.Count -eq 0){ Rec "STOP: nessun grafico salvato dopo il limite: la fotografia non e' piu' vera." Red; return }
```

Corollario, per le righe distruttive: il backup si scrive con i **byte gia'
letti** dall'handle condiviso (`[IO.File]::WriteAllBytes`), non con `Copy-Item`
— con MT5 aperto la lettura condivisa riesce dove la copia puo' fallire — e si
verifica sulla **lunghezza**, non con `Test-Path` (punto 27-ter).

---

## 🆕 AGGIUNTA DEL 20/08/2026 — trovata verificando la misura dei TICK di U30USD

## 30. ⏸️ IL GUARDIANO DI PROGRESSO CHE GUARDA UN FILE CHE, NELLA FASE PIU' LUNGA, NON CRESCE PER COSTRUZIONE

_Difetto vero, gia' committato in `scarica_storico.ps1` (righe 296-314) e
dichiarato come "residuo" in `REFERTO_R83_R84_PREPARAZIONE.md` (par. 529)
senza mai essere curato. Trovato PRIMA dell'invio della riga che doveva
misurare la profondita' dei tick reali di U30USD._

Il punto 8 dice che **il silenzio non e' fine corsa**, e la cura fu una rete:
"CSV fermo da 15 minuti -> mi fermo". Ma quella rete guarda **la lunghezza del
CSV**, e la riga `TICK` di quel CSV la scrive `ABTG_HistoryDownloader.mq5`
(righe 219-232) **solo QUANDO `DownloadTicks` ha finito**: fra
`TICK : scarico...` e `=== FINITO` possono passare **ore** in cui il file, per
costruzione, **non cresce di un byte**. Su una corsa perfettamente SANA la
guardia scatta, `Stop-Process -Force` ammazza MT5 **in mezzo allo scaricamento
dei tick** (mentre scrive le cache `bases\...\ticks\`), il referto esce **senza
la riga TICK** e lo script **finisce 0**. E' il punto 19 (il timeout che esce 0)
con l'aggravante che qui **non e' nemmeno il timeout dichiarato**: `-TimeoutMin`
puo' valere 240 e la corsa muore a 15 minuti.

Il 18/08 la misura NASUSD/D30EUR e' passata solo perche' i tick erano gia' in
cache e tutto il PASSO 0 e' durato ~12 minuti: **la guardia non e' scattata per
fortuna, non per progetto.**

> **Un guardiano di progresso deve osservare un segnale che la fase LENTA
> produce davvero.** Prima di scriverlo (o di fidarsene) si va a vedere, nel
> codice di CHI SCRIVE, **quando** quel file viene scritto: se e' scritto solo
> alla fine, non e' un indicatore di progresso, e' un indicatore di FINE.
> Due forme accettabili:
> ```powershell
> if ($coda -match "TICK : scarico") { $faseTick = $true }   # 1: fase dichiarata dal log...
> if ($len -eq $ultimaLen) { if ($faseTick) { continue }     #    ...e li' il silenzio e' NORMALE
> ```
> oppure si misura **l'artefatto che cresce davvero** (la cartella
> `bases\<server>\ticks\<simbolo>`). Se non esiste nessun segnale, la fase si
> dichiara e l'unico limite ammesso e' `-TimeoutMin`.
> Corollario: **la fine anticipata di un guardiano non puo' uscire 0** (punto
> 19.2), e chi chiama controlla comunque **la riga che quella fase doveva
> produrre** (`U30USD,TICK`), mai il solo codice d'uscita.

---

## 🆕 AGGIUNTA DEL 20/08/2026 — trovata verificando le due righe di R84 (ablazione filtri Nasdaq)

## 31. 🪞 L'ANTEPRIMA CHE NON RISPECCHIA I PARAMETRI CHE LE HAI PASSATO

_Difetto vero, gia' committato in `walkforward_generico.ps1` (riga 514 contro
riga 645), trovato PRIMA dell'invio della riga del giro a vuoto di R84._

Il punto 5 dice: *"si legge la stampa di `-SoloControllo` e si confronta col
file prova"*. Il punto 14 dice che il giro a vuoto puo' uscire 0 anche se un
pezzo e' fallito. Questo e' il terzo modo di rompere un giro a vuoto, ed e' il
piu' subdolo perche' **l'anteprima esce, e' fresca, ed e' sbagliata**: il ramo
di prova scrive un valore **HARDCODED** al posto del parametro ricevuto.

```powershell
# riga 514, ramo -SoloControllo
Model=4
# riga 645, corsa VERA
Model=$Modello
```

`-Modello 1` in giro a vuoto stampa comunque `Model=4`. Su R84 non e'
ipotetico: i criteri (`prove/R84_ABLAZIONE_CRITERI.md` §3.1) prevedono
**esplicitamente** di scendere a modello 1 se i tick degli indici non ci sono —
cioe' esattamente il caso in cui l'anteprima mentirebbe, e l'illusione OHLC in
questa casa ha gia' revocato una promozione (SupRev DOW H4, FIRMA 5).

Stessa riga, secondo sintomo: **il parametro che DISTINGUE i sotto-giri e' morto
nel ramo di prova**. `-Etichetta` e' usata solo a riga 608, *dopo* l'`exit 0` di
riga 538, e il nome dell'anteprima (riga 504) e'
`anteprima_<EA>_<Simbolo><Broker>.ini` — **senza etichetta**. Nove celle sullo
stesso EA e sullo stesso simbolo scrivono **nove volte lo stesso file**: alla
fine ne resta **UNA**, quella dell'ultima cella, e non c'e' niente che lo dica.
E' il punto 26 (due chiamate, una sola raccolta) visto dal lato del *dry-run*.

> **Prima di fidarsi di un `-SoloControllo`/`-Prova`/`--dry-run`, si apre il
> RAMO DI PROVA e si verifica, parametro per parametro, che scriva le VARIABILI
> e non delle costanti** — e che il nome dell'artefatto contenga **il
> discriminante** dei sotto-giri. Due contromisure, dal lato della riga, senza
> toccare lo script:
> ```powershell
> Remove-Item $anteprima -Force -EA SilentlyContinue   # PRIMA di ogni sotto-giro
> ...
> Move-Item $anteprima (Join-Path $sosta "R84$c.ini") -Force   # nome PROPRIO, SUBITO
> if($n -ne 9){ throw "ANTEPRIME $n invece di 9" }
> ```
> E il fix allo script (`Model=$Modello`, etichetta nel nome dell'anteprima) va
> in coda come lavoro a se', dichiarato nel referto.

### 31-bis. 🫥 IL FILTRO CHE, SE GLI MANCA IL DATO, DIVENTA NEUTRO IN SILENZIO

_Stesso giro. Le celle **H** e **I** di R84 accendono `InpUseCorrelation` su
`InpCorrSymbol="SPXUSD"`, ma il PASSO 0 dei criteri (§3.1) misura la profondita'
di **`NASUSD` e basta**._

`ABTG_Nasdaq_Apertura_US.mq5`, `SymbolTrendDir()` righe 1620-1635:

```mql5
if(hf == INVALID_HANDLE || hs == INVALID_HANDLE) return(0);
...
if(CopyBuffer(hf,0,1,1,f) == 1 && CopyBuffer(hs,0,1,1,s) == 1) dir = ...
```
e al chiamante: `int c = SymbolTrendDir(...); if(c != 0) bias = CombineBias(bias, c);`

Storico del simbolo guida assente o troppo corto -> `0` -> **il filtro non filtra
niente** e la cella esce **identica alla baseline**. Il round scriverebbe *"la
correlazione e' neutra"* misurando invece **un filtro che non ha mai girato**.
E' lo stesso ragionamento con cui gli stessi criteri (§6) escludono apposta il
filtro news (*"un CSV che non copre il periodo produce una cella identica alla
baseline e sembrerebbe filtro neutro: sarebbe un numero falso"*) — solo che li'
il pericolo era stato visto, e sul simbolo guida no.

> **Ogni SIMBOLO SECONDARIO che un EA legge (correlazione, hedge, indice guida)
> e' un ingresso storico esattamente come il simbolo testato: entra nel PASSO 0,
> con la sua riga misurata.** Grep secco sul `.mq5` prima di ogni round:
> `Symbol\s*=|CopyRates\(\s*\w+\s*,|iMA\(\s*sym` — ogni chiamata che NON usa
> `_Symbol` e' un simbolo da misurare. E se il codice degrada a "neutro" quando
> il dato manca, la cella non e' "non misurabile": e' **non eseguita**, e va
> distinta.

---

## 🆕 AGGIUNTA DEL 20/08/2026 — trovata verificando i primi due passi di `dukascopy_m1.py`

## 32. 📏 LA BANDA DI PLAUSIBILITA' COL RAPPORTO ≥ 10: lo sfondamento non si ferma, RIENTRA

_Difetto vero, gia' committato in `dukascopy_m1.py` (cd72df1, riga 94:
`"USA30IDXUSD": ("U30USD", 6000.0, 60000.0)`) e **RIPRODOTTO** prima
dell'invio della riga. Ora e' un caso dell'autotest (n.7)._

Il punto 23 copre l'artefatto di INPUT scaduto. Questo copre il **numero
scritto in tabella che scade**: una "banda plausibile" serviva a scegliere il
divisore 10^k del prezzo (il `.bi5` di Dukascopy contiene interi). Il gemello
`histdata_m1.py` aveva gia' pagato le **bande stantie** — i prezzi 2026 che
sfondavano i tetti scritti nel 2024 — e li' lo sfondamento faceva **fermare**
lo script. **Qui no**, e la differenza e' tutta in un rapporto:

```
banda 6000-60000  ->  60000 / 6000 = ESATTAMENTE 10
mediana 60.100 (Dow a +13% da oggi):
   /1    = 60100  fuori banda
   /10   =  6010  DENTRO  <-- unico candidato: accettato
   /100  =   601  fuori banda
```

Un solo candidato = nessun dubbio = **nessun fermo**. Lo script scrive un CSV
col Dow a **6.010 punti invece di 53.400/60.100**, il referto dice `ESITO: OK`
e il codice d'uscita e' **0**. Il passo dopo (import in MT5, prova di regime)
gira su prezzi divisi per dieci: gli ATR, gli stop e i target sono tutti
plausibili fra loro, quindi **niente sembra rotto**.

La zona in cui uno sfondamento si ferma pulito e' **(tetto , 10 x pavimento)**:
- rapporto **< 10** -> quella finestra esiste (con 8000-70000: 70.000-80.000);
- rapporto **= 10** -> finestra **VUOTA**: sfondi e rientri, in silenzio;
- rapporto **> 10** -> c'e' pure una zona di **ambiguita'** (due candidati:
  fermo pulito, va bene) **e** sopra il tetto si rientra lo stesso in silenzio.

> **Regole, per ogni tabella di bande/soglie plausibili:**
> 1. **rapporto max/min < 10**, e il tetto sopra il prezzo di OGGI con margine
>    dichiarato (`# Dow ~53.400 il 20/08/2026`): la banda porta la sua data;
> 2. **il valore scelto dall'euristica finisce nell'ARTEFATTO**, non solo a
>    schermo (qui: `divisore usato 100` nel referto), cosi' l'errore di un
>    fattore 10 e' leggibile da chi apre il file;
> 3. **l'audit della tabella e' un caso dell'autotest**, che elenca le bande
>    ancora da rifare invece di lasciarle invisibili (qui restano `NASUSD` e
>    `S500USD`: rapporto 20 e 13,3, da ribasare su un prezzo MISURATO).

---

## 🆕 AGGIUNTA DEL 21/08/2026 — trovata verificando la riga R92-SCAN BULGE

## 33. 👯‍♂️ DUE ARTEFATTI DESCRIVONO LA STESSA CELLA, NE GIRA UNO SOLO — e il giro a vuoto controlla l'ALTRO

_Difetto vero, gia' committato (pin `fe430a5`), trovato PRIMA dell'invio della
riga. `prove\R92_scan_BULGE.txt` dice `Risk_Percent=0.8`; il blocco
`elseif($EA -eq "ABTG_Bulge")` di `scan_market.ps1` (riga 382) dice
`Risk_Percent=1.0||1.0||0||1.0||N`. **Gira il secondo.** Il primo, `0,8`, e'
il numero **FIRMATO** da Claudio il 21/08 ("c,firmo 0,8,misura entrambe") ed
e' quello che fa reggere il cap C1 (0,80 x `Max_Trades` 4 = 3,20% <= 3,25%)._

Il punto 3 chiede "il file dei parametri e' quello GIUSTO?". Il punto 31
chiede che l'anteprima rispecchi i parametri. **Questo e' il terzo caso, ed e'
il piu' insidioso: i due file esistono ENTRAMBI, sono ENTRAMBI giusti nella
forma, e il giro a vuoto valida QUELLO CHE NON GIRA.** Il `-SoloControllo` del
PASSO 1 esce verde su `prove\R92_scan_BULGE.txt` — un file che nella strada
(A) non viene aperto da nessuno.

E non era cosmetico: `Max_Daily_Loss_Pct=2.0` con rischio **1,0%** salta il
kill switch dopo **2** stop, con **0,8%** dopo **3**. Cambiano gli ingressi,
cambia `n` — e `n >= 30` e' la **prima soglia firmata** del round. La riga
avrebbe misurato un motore diverso da quello firmato, con l'aggravante che
tutti e tre i documenti (criteri, file prova, riga di lancio) dicevano 0,8.

> **Quando la stessa cella e' scritta in DUE posti (verbale + copia esecutiva),
> la riga di lancio non si fida del commento "se cambi qui cambia anche li'":
> fa il DIFF, nome per nome e valore per valore, e si ferma se non coincidono.**
> Se il diff non si puo' fare a mano, lo fa la riga sulla copia scaricata,
> **prima di lanciare**, e il gate e' sullo STATO FINALE (non sul replace):
> ```powershell
> $t = Get-Content -LiteralPath $p -Raw
> $t = $t -replace '(?m)^Risk_Percent=1\.0\|\|1\.0\|\|0\|\|1\.0\|\|N\s*$','Risk_Percent=0.8||0.8||0||0.8||N'
> Set-Content -LiteralPath $p -Value $t -Encoding ASCII
> if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'Risk_Percent=0.8||0.8||0||0.8||N' -Quiet)){ throw 'RISCHIO NON FIRMATO' }
> ```
> Cosi' il gate regge anche **dopo** che qualcuno ha corretto il sorgente e
> ri-pinnato la riga: un gate scritto come "il replace ha trovato qualcosa"
> esplode il giorno in cui non c'e' piu' niente da sostituire.
>
> Corollario di traffico: **il giro a vuoto deve girare sullo STESSO artefatto
> della corsa vera.** Se il driver del round ha la griglia scritta dentro di
> se', un `-SoloControllo` su un file prova esterno **non e' il giro a vuoto di
> quel round**: e' il giro a vuoto di un altro round. Va detto in chat, o non
> va messo.

### 33-bis. 🧱 L'`#include` DELL'EA NUOVO: nessuno lo installa, e il compilatore lo scopre a corsa avviata

_Stessa verifica. `ABTG_Bulge.mq5` (riga 177) fa `#include <ABTG_PausaGuardian.mqh>`
e chiama `ABTG_AutotestGuardia()`, che **esiste solo dalla v1.20 dell'include**
(commit `ad593c9`, 19/08). `scan_market.ps1` (riga 415) e `walkforward_generico.ps1`
(riga 142) scaricano **solo il `.mq5`**: l'include non lo installa NESSUNO dei
due. Sul PC di backtest lo mette li' `installa_guardian.ps1`, che e' un altro
lavoro, di un'altra sera._

Il punto 17 dice che una dipendenza esterna si **MISURA**, mai si deduce. Il
punto 27 copre la coppia sorgente/binario. Questo e' il pezzo che mancava: **le
dipendenze INTERNE di un sorgente** (`#include`, `#import`, indicatori
custom chiamati per nome). Se manca, o se e' vecchia di una versione, il
sintomo non e' "il file non c'e'": e' `'ABTG_AutotestGuardia' - undeclared
identifier` **dentro il driver**, che stampa `ERRORE compilazione` ed esce 1 —
e se la riga non guarda il codice d'uscita (punto 13) la raccolta parte lo
stesso su zero CSV.

> **Prima di una riga che compila un EA MAI COMPILATO su quella macchina: grep
> degli `#include` non di sistema nel `.mq5`, e la riga li INSTALLA lei, dal
> pin, verificando la LUNGHEZZA (punto 27-ter) e un MARCATORE della versione
> giusta** (qui: `ABTG_AutotestGuardia` dentro il `.mqh`). E si compila da
> riga di comando (`metaeditor64.exe /compile:<file> /log`), non chiedendo a
> Claudio di premere F7 su un file che sulla sua macchina non c'e' ancora
> (punto 20).

---

## 🆕 AGGIUNTA DEL 21/08/2026 — trovata verificando la riga R93 (FiboH4 a due gambe)

## 34. 📢 IL CANARINO CHE VIVE SOLO IN UNA `Print`: in OTTIMIZZAZIONE non lo legge NESSUNO

_Difetto vero, gia' committato in `ABTG_FiboH4_Multi.mq5` (`PrintContaNews()`,
righe 900-914) e in `ABTG_FiboH4_Corso.mq5` (`PrintConta()`, righe 1116-1136),
trovato PRIMA dell'invio della riga di R93._

Il punto 20 chiede: *"il gesto che sto chiedendo produce quell'output?"*. Questo
e' la stessa domanda applicata alla **MODALITA'**: `walkforward_generico.ps1`
scrive **sempre** `Optimization=1` nell'`.ini` (riga 645), quindi **tutte** le
passate di un round girano sugli **AGENTI**. Le `Print` di un agente **non
compaiono nella scheda Esperti del terminale**: finiscono nei log per-agente
(`Tester\Agent-127.0.0.1-30xx\logs\`), che nessuno script raccoglie e che nello
zip non ci sono.

In R93 quei due `Print` erano i canarini **non trattabili** del round:
`bloccate=N (X%)` (se e' 0 il filtro news non e' stato eseguito e la cella si
butta) e `SETUP PIAZZATI=P` (se e' 0 la gamba B non ha misurato niente, non
"perde"). Con 68 passate tutte in ottimizzazione, **nessuno dei due sarebbe
stato leggibile** — e la gamba A, se il calendario non fosse arrivato agli
agenti, sarebbe uscita **identica alla baseline**: due misure della stessa cosa,
senza un artefatto che lo dica. E il `REFERTO_R93.txt` istruiva a leggerli
(punto 22: istruzioni vere per un artefatto mai nato).

> **Un canarino deve viaggiare coi DATI, non con lo schermo.** In MQL5 la strada
> esiste ed e' gia' in casa: i contatori si mettono nell'array di `FrameAdd`,
> che attraversa il confine agente -> terminale, e `OnTesterDeinit` (che gira
> **sul terminale**) li scrive come COLONNE del CSV di ottimizzazione:
> ```mql5
> double stats[13];                       // era 10
> stats[10] = (double)gNewsBlocchi;       // + header "News Bloccate"
> stats[11] = (double)gNewsBarreViste;    // + header "News Interrogazioni"
> stats[12] = (double)gNewsCount;         // + header "News Eventi"
> ```
> **Header e riga si toccano INSIEME**, o le colonne scalano di posto.
> Regola di lettura: prima di scrivere in un referto *"leggi la riga X nella
> scheda Esperti"*, si stabilisce **in che modalita' gira quella passata**.
> Test singolo -> la `Print` si vede. Ottimizzazione -> **si vede solo cio' che
> sta in una colonna**.

### 34-bis. 🪞 E IL CANARINO LETTO DALLA PARTE CHE LO SCRIVE, non da quella che lo riceve

_Stessa verifica. Il canarino del pin di stringa (`InpSymbols` pinnato con
l'ordine `USDJPY;EURUSD;GBPUSD`, diverso dal default compilato) era giusto e
misurato. Ma sia la riga in chat sia il driver (`lancia_r93.ps1`, righe 522-525)
dicevano di controllarlo **nell'anteprima `.ini` del giro a vuoto**._

L'anteprima **la scrive il nostro script**, copiando il file prova: li' dentro
`InpSymbols` dira' **sempre** `USDJPY;EURUSD;GBPUSD`, anche il giorno in cui MT5
lo ignora. E' il guardiano decorativo del punto 14 applicato a un canarino: il
controllo esce verde per costruzione, e il difetto che ha prodotto il vecchio
"0/8" passerebbe **una seconda volta**.

> **Un canarino si legge SEMPRE nell'artefatto prodotto da CHI DOVEVA
> RICEVERE il dato** — qui la colonna `InpSymbols` del CSV di MT5 — mai
> nell'artefatto scritto da chi lo manda. E si elencano **tutti** gli esiti
> possibili, non due: qui il terzo era `InpSymbols = USDJPY` **da solo**,
> cioe' il `;` troncato dal parser dell'`.ini` — un basket da 1 cross invece di
> 3, con `n` a un terzo e nessuno che se ne accorge.

## 35. 🗂️ L'ISTRUZIONE DI SPEZZARE LA CORSA CONTRO LA RACCOLTA CHE SI AZZERA

_Difetto vero, gia' committato in `lancia_r93.ps1` (righe 495-498) e scritto
come consiglio nel par. 14 dei criteri: *"Si puo' spezzare: `-Gamba A` (24
passate) e `-Gamba B` (44 passate) in due sere"*._

Il punto 26 copre due chiamate **nello stesso blocco**. Questo copre due
chiamate **in due sere**, ed e' peggio perche' in mezzo si dorme:

```powershell
if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }   # la sera dopo cancella la sera prima
...
Compress-Archive -Path (Join-Path $dest "*") -DestinationPath $zip -Force
```

La seconda serata **rade al suolo** la cartella di raccolta e riscrive lo zip:
dentro ci finisce **solo la gamba B**, il referto dice `MANCANTI: nessuno`
(perche' conta solo le celle di QUESTO giro) e Claudio manda in buona fede
meta' round credendo di mandarlo intero.

> **Prima di scrivere in un referto "si puo' spezzare in due sere", si apre la
> RACCOLTA e si guarda se e' cumulativa o distruttiva.** Se e' distruttiva:
> o la cartella di sosta si tiene per gamba (`R93_FIBOH4\A\`, `R93_FIBOH4\B\`)
> e lo zip si fa in fondo, o l'istruzione diventa **"manda lo zip DOPO OGNI
> gamba, il secondo sovrascrive il primo"**. Non si lascia scegliere a chi
> incolla.
