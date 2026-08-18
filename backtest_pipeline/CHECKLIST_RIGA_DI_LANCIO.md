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
