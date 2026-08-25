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

---

## 🆕 AGGIUNTE DEL 21/08/2026 — trovate verificando la RIGA SONDA MEDIAZIONE

## 36. 📉 IL TETTO "MAX BARRE NEL GRAFICO": il broker ha la storia, il TERMINALE si rifiuta di darla

_Difetto vero, gia' committato in `backtest_pipeline/righe/RIGA_SONDA_MEDIAZIONE.md`
(commit `3cf171f`, PASSO 2 tabella riga 2), trovato PRIMA dell'invio. Il canarino
c'era **nel referto** (`SONDA_MEDIAZIONE_FREQUENZA_2026-08-21.md` riga 181) e
**non nella riga**, cioe' nell'unico dei due documenti che Claudio esegue._

Il punto 18 copre la profondita' **misurata sul TF sbagliato**. Questo copre il
caso in cui la profondita' e' giusta ovunque — sul server, nel `.hcc` locale, nel
referto del PASSO 0 — e a troncarla e' **Strumenti > Opzioni > Grafici > "Max
barre nel grafico"**. `CopyRates`/`CopyBuffer` **non superano quel tetto**: non
danno errore, non riempiono un log, **restituiscono meno barre e basta**. Uno
`Script`/EA che chiede 300.000 barre H1 ne riceve 65.000 e misura undici anni al
posto di sedici, con un numero perfettamente coerente con se stesso.

La riga della Sonda aveva un gate — e non mordeva:

```
atteso  "barre lette intorno a 90.000"        <- ed erano ~103.000 (16,6 anni x ~6.200/anno)
allarme "sotto ~20.000 = manca lo storico"    <- un quinto dell'atteso
```

Con il tetto a 65.000 il conteggio perde **un terzo** della finestra e il gate
**esce verde**: fra la soglia d'allarme e il valore vero c'e' un fattore 5 di
terra di nessuno. E' la banda di plausibilita' del punto 32 col rapporto
sbagliato, applicata alle barre.

> **Tre pezzi, insieme, su ogni riga che legge storico da un grafico (non dal tester):**
> 1. **la riga lo dice PRIMA**: _"Strumenti > Opzioni > Grafici > Max barre nel
>    grafico = Illimitato"_, e che quel tetto **tronca in silenzio**;
> 2. **il numero atteso si calcola, non si arrotonda a occhio**: H1 forex =
>    ~6.200 barre/anno (120/settimana), quindi dal 2010 a oggi ~103.000. La
>    soglia d'allarme sta **vicino** all'atteso (90.000), non a un quinto;
> 3. **il tetto ha una firma riconoscibile e va cercata a macchina: `barre_lette`
>    IDENTICO su tutti i simboli.** Il broker non da' mai lo stesso numero tondo
>    a tre cross diversi; il tetto si'. E il gate vero non e' sulle barre ma
>    sulla **data d'inizio della finestra EFFETTIVA** scritta nell'artefatto.
>
> ⚖️ E si distingue: **finestra corta perche' il TETTO** = difetto, si rilancia.
> **Finestra corta perche' il BROKER non ha altro** = e' la risposta, si dichiara
> nel referto e non ferma niente (punto 26-bis).

## 37. 🎯 DUE PASSI DELLA STESSA RIGA CHE CERCANO LO STESSO TERMINALE CON DUE SELETTORI DIVERSI

_Difetto vero, stessa riga, stesso commit. Il PASSO 0 chiama `scarica_storico.ps1`,
che sceglie il terminale cosi' (riga 65):_

```powershell
$_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*"   # e SOLO se fallisce: "*BCM Markets*"
```

_I PASSI 1 e 3, riscritti a mano dentro la riga, usano il **ripiego** come
selettore **principale**: `-like "*BCM Markets*" -and -notlike "*-V3*"`._

Il punto 28 dice che uno strumento diagnostico deve guardare **lo stesso
perimetro** dello strumento che spiega. Questo e' la stessa legge dentro una
**catena di passi**: il PASSO 0 scarica 100.000 barre nella cartella dati del
terminale **A**, il PASSO 1 compila nel terminale **B**, il PASSO 2 gira su B e
il PASSO 3 legge i CSV di B. Su una macchina con **una sola** installazione i due
selettori coincidono e non si vede niente; il giorno che ne compare una seconda
(ed e' gia' successo: il `-V3` del 100k esiste apposta) la sonda misura uno
storico che non e' mai stato scaricato. `Get-ChildItem -Recurse` per giunta non
promette **nessun ordine**: il "primo" puo' cambiare fra un giro e l'altro.

Non e' l'errore di chi ha scritto il selettore: e' l'errore di averlo
**riscritto**. Un selettore copiato a mano da uno script gemello degrada di una
riga per volta, e la riga che si perde e' sempre quella specifica.

> **Se piu' passi della stessa riga devono colpire lo stesso bersaglio (terminale,
> cartella dati, istanza, conto), il selettore si copia IDENTICO dallo script
> gemello che gia' lo risolve — fallback compreso — e OGNI passo STAMPA il
> bersaglio che ha scelto**, cosi' la divergenza si legge in console invece di
> essere dedotta da un conteggio sbagliato:
> ```powershell
> Write-Host ("terminale scelto: " + $t.DirectoryName + "   (DEVE essere lo stesso del passo precedente)")
> ```
> Corollario: se il bersaglio e' scritto in due posti, vale il punto 33 — si fa
> il **diff**, non ci si fida del fatto che "tanto la macchina e' quella".

---

## 🆕 AGGIUNTE DEL 21/08/2026 — trovate verificando la riga R94 (Bollinger 37/1.4 sul BreakingBand)

## 38. 🧊 IL CANARINO SERVITO DALLA **CACHE DEL TESTER**: non e' un controllo dei dati

_Difetto vero, trovato PRIMA dell'invio della riga R94, e **misurato sui file**:
la cella di canarino di R94 (`GBPUSD`, `InpBBPeriod=20`, `InpBBDev=2.0`,
`InpMinRR=0`, magic 772101, finestra 2024.09.26-2026.06.30, deposito 100k,
tick reali) e' **la stessa identica passata** che R91 ha gia' calcolato il
21/08: `risultati_archivio/r91_csv/ABTG_BreakingBand_GBPUSD_OOS_r91a.csv`,
`Pass 0` -> `Profit 3160.10 | PF 1.73020 | Equity DD 3.4801 | Trades 26`.
E il sorgente dell'EA non e' cambiato dal 20/08 (`e528527`)._

Il punto 23 copre l'artefatto di INPUT scaduto e il punto 26 la raccolta che si
sovrascrive. Questo copre il caso in cui **e' MT5 a servire il risultato vecchio**:
`walkforward_generico.ps1` lo documenta gia' da solo (righe 684-694)

> _"E' la CACHE del tester: MT5 ripesca pass gia' calcolati (anche di griglie
> vecchie) e NON riesegue le celle chieste se le ha in cache."_

Una riga di lancio che scrive **"il canarino e' anche il controllo dei dati: se
i tick fossero cambiati, corti o mancanti, quelle righe non tornerebbero"** sta
promettendo una cosa che la cache annulla: **una passata ripescata non legge un
tick.** Il canarino tornerebbe **identico anche con lo storico sparito** — e le
celle NUOVE (in cache non ci sono) girerebbero sui dati veri. Il round
confronterebbe **due misure fatte su due mondi diversi**, che e' esattamente il
contrario di quello per cui il canarino esiste.

> **Se il canarino di un round e' una passata GIA' GIRATA (stessi input, stesso
> simbolo, stessa finestra, stesso binario), non e' un canarino finche' non si
> svuota `<cartella dati>\Tester\cache`.** Si fa a MT5 chiuso, e si dice in
> chat che quella cella **rigira** invece di essere ripescata:
> ```powershell
> $cacheT = Join-Path $DataFolder "Tester\cache"
> if(Test-Path $cacheT){ Remove-Item (Join-Path $cacheT "*") -Recurse -Force }
> ```
> ⚠️ **Solo `Tester\cache`. MAI `bases\<server>\ticks\`**, che e' la cache dello
> STORICO: cancellarla vuol dire riscaricare i tick e trasformare un round da
> due ore in una notte.
> Corollario gia' scritto nel driver: **un pass non rieseguito non scrive
> nemmeno i file per-trade** — se i `abtg_trades_*` non compaiono freschi, la
> cella e' stata ripescata.

## 39. 🩺 IL `-SoloControllo` DEL DRIVER GENERICO **NON COMPILA** — vale per TUTTI i round

_Difetto vero, gia' committato in `walkforward_generico.ps1`, misurato riga per
riga: il ramo `if($SoloControllo){` apre alla **riga 503** e chiude con
`exit 0` alla **riga 538**; la compilazione (`metaeditor64.exe /compile:`) sta
alla **riga 603**, cioe' **65 righe dopo l'uscita**._

Il punto 5 dice "se la riga usa `-Prova`: prima un giro a vuoto", il punto 14 che
il giro a vuoto puo' uscire 0 con un pezzo fallito, il punto 31 che l'anteprima
puo' mentire. **Questo e' il quarto modo, ed e' il piu' silenzioso: il giro a
vuoto non tocca il compilatore.** Quindi un `#include` mancante o vecchio di una
versione (punto 33-bis), un identificatore non dichiarato, un errore di sintassi
nel `.mq5` appena scritto **non si vedono nel giro a vuoto** e saltano fuori
**a corsa avviata**, come `ERRORE compilazione` — con la raccolta che parte su
zero CSV se la riga non guarda il codice d'uscita (punto 13).

> **Il giro a vuoto di un round che tocca un EA deve COMPILARE.** Finche' il
> driver generico non lo fa, lo fa il driver di round, da riga di comando
> (`metaeditor64.exe /compile:<file> /log`), **anche in `-SoloControllo`**, e:
> 1. **cancella il `.ex5` PRIMA** (punto 27: un binario di ieri fa passare il
>    gate su una compilazione fallita oggi);
> 2. **aspetta l'ARTEFATTO, non il processo.** MetaEditor e' **single-instance**:
>    se ne gira gia' una copia, il processo appena lanciato **torna subito** e
>    la compilazione avviene nell'altra istanza. Un controllo fatto sul ritorno
>    del processo fallisce su una compilazione perfettamente sana:
>    ```powershell
>    Remove-Item -LiteralPath $ex5 -Force -EA SilentlyContinue
>    $t0=Get-Date; & $MetaEditor ("/compile:"+$src) "/log" | Out-Null
>    while((-not (Test-Path -LiteralPath $ex5)) -and ((New-TimeSpan -Start $t0 -End (Get-Date)).TotalSeconds -lt 180)){ Start-Sleep -Seconds 2 }
>    if(-not (Test-Path -LiteralPath $ex5)){ <stampa il .log> ; Muori "compilazione FALLITA" }
>    ```
> 3. e la riga in chat dice di chiudere **anche MetaEditor**, non solo MT5.
>
> Il fix vero (far compilare il driver generico anche in `-SoloControllo`) resta
> in coda come lavoro a se', **dichiarato nel referto** — non a memoria.

## 34-ter. 📢 I LOG DEGLI AGENT: la radice sbagliata, e il fatto che in ottimizzazione **non c'e' niente da raccogliere**

_Difetto vero, trovato PRIMA dell'invio della riga R94. `lancia_r94.ps1`
raccoglieva i log del tester da **due** radici — `<cartella dati>\Tester` e
`<installazione>\Tester` — e **non** da `%APPDATA%\MetaQuotes\Tester`, dove
stanno gli agent locali (`Agent-127.0.0.1-30xx\logs`). La terza radice non e'
un'ipotesi: la usa il **gemello della stessa famiglia**,
`righe/RIGA_NOTTE2_DUKA_R91.ps1` riga 859, scritto due giorni prima. E' il
punto 9 (la riscrittura che perde la sicurezza del gemello) applicato ai log._

Ma la cosa che conta di piu' e' la seconda meta', ed e' il punto 34 preso sul
serio: **in ottimizzazione le `Print` degli agent non vengono eseguite.** Il
`PrintFunnel()` di `ABTG_BreakingBand` gira dentro `OnTester()`, cioe'
**sull'agente**, e `walkforward_generico.ps1` scrive **sempre**
`Optimization=1`. Quindi il funnel **non esiste**, in nessuna radice: R91 per
leggerlo ha dovuto lanciare una **passata singola** con `Optimization=0`
(`RIGA_NOTTE2_DUKA_R91.ps1` righe 848-856), e infatti l'aveva capito.

> **Una raccolta "best effort" di un artefatto che non puo' nascere non e' best
> effort: e' il punto 22 (istruzioni per un artefatto mai nato) con una cartella
> vuota a fare da alibi.** Prima di scriverla nella riga, due domande:
> 1. **quel `Print` gira in ottimizzazione?** Se no: o si mette il contatore in
>    una **colonna** (`FrameAdd` -> `OnTesterDeinit`, come R93), oppure si
>    aggiunge una **passata singola** dedicata, oppure **si dichiara che quel
>    numero il round non ce l'ha**. Le tre strade sono legittime; fingere che
>    ci sia non lo e'.
> 2. **la radice e' quella giusta?** Gli agent NON stanno sotto la cartella dati
>    del terminale. Si scandiscono tutte e tre le radici, e **il conteggio dei
>    log raccolti finisce nel referto** (`log degli agent raccolti: 0`), cosi'
>    lo zero si legge invece di essere dedotto.

---

## 🆕 AGGIUNTE DEL 21/08/2026 — trovate verificando la riga R95 (LiquiditySweep sui cross JPY)

_(Nota di tracciabilita': questi due punti sono stati scritti dalla verifica di
R95 ma sono finiti dentro il commit `4af9625` di un'altra sessione, che ha usato
`git add -A` mentre erano ancora nel working tree. E' esattamente il rischio che
si corre lavorando in parallelo: **si committano solo i file propri**.)_

## 40. 🚧 IL GATE CHE NON PUO' MORDERE — tre modi, tutti e tre nella STESSA riga

_Difetti veri, gia' committati in `backtest_pipeline/righe/RIGA_R95_LIQSWEEP_JPY.ps1`
(commit `da9e764`), trovati PRIMA dell'invio. R95 vive o muore sul suo PASSO 0:
quattro condizioni di stop dichiarate, di cui **due non potevano scattare mai** e
**una non poteva passare mai**._

Il punto 14 dice che un guardiano puo' essere **decorativo**. Questo dice **come**
diventa decorativo, e sono tre meccanismi diversi che si riconoscono a grep.

### 40. 📐 `(?m)^...$` SU TESTO UNITO CON `\r\n`: in .NET quel `$` NON matcha

E' il piu' velenoso perche' sembra la cosa piu' innocua del mondo:

```powershell
$inputs = ($out -join "`r`n")
if($inputs -notmatch '(?m)^InpSwingBars=4$'){ throw "InpSwingBars non e' stato pinnato a 4" }
```

In .NET, in modalita' multilinea, **`$` matcha la posizione PRIMA di `\n`** — e se
davanti al `\n` c'e' un `\r`, quella posizione non e' raggiungibile dopo aver
consumato `4`. Il match **fallisce sempre**, il `throw` scatta **sempre**, e il
messaggio d'errore accusa una cosa che e' perfettamente a posto: il pin c'era.
Riprodotto sui tre gate del PASSO 0 di R95 (`InpSwingBars`, `InpTF_Struttura`,
`InpMagic`): **il PASSO 0 non sarebbe partito mai**, e la diagnosi in console
avrebbe mandato a cercare il difetto nel file prova, che era sano.

E il rovescio e' peggio, perche' e' **silenzioso**: la stessa regex usata al
positivo (`if($t -match '(?m)^Pinnato=1$'){ ok }`) fa uscire il controllo
**verde-per-assenza** su un testo LF e **rosso** su un testo CRLF — cioe' il
verdetto dipende da chi ha scritto il file, non da cosa c'e' scritto.

> **Ogni `$` dentro una regex multilinea si scrive `\r?$`. Sempre, anche quando
> "tanto il file e' LF".** Il testo non e' quasi mai quello che si crede:
> `Get-Content` toglie i terminatori, `-join "`r`n"` li rimette, `-Raw` conserva
> quelli del disco, e `raw.githubusercontent.com` serve il blob **com'e'**.
> Grep secco prima di mandare: `\(\?m\)\^[^']*\$'` — ogni occorrenza senza `\r?`
> davanti al `$` e' una riga da rifare.
> _(Nella stessa riga R95 la forma giusta c'era gia', due schermate sopra:
> `-replace '(?m)^\[Experts\]\r?$'`. Chi l'ha scritta lo sapeva. **Sapere non
> basta: si fa il grep.**)_

### 40-bis. 🔢 IL NUMERO ATTESO DEL GATE SCRITTO A MEMORIA, NON CONTATO SULL'ARTEFATTO

Stessa riga, passo 1d. Il gate confronta i 5 file prova fra loro — idea giusta,
e' il punto 33 applicato bene — ma con una costante presa a occhio:

```powershell
if($base.Count -ne 31){ throw ("il file prova base ha " + $base.Count + " righe vive, ne attendevo 31") }
$div = 0; for($i=0;$i -lt 31;$i++){ ... }
```

Contate: **32** (3 direttive `@` + 29 parametri), in tutti e cinque. La riga
muore al passo 1d, **prima di compilare, prima del PASSO 0, prima di qualunque
cosa** — un giro a vuoto in piu' per un numero che nessuno aveva contato. E il
ciclo a `31` non avrebbe nemmeno confrontato l'ultima riga: quella con `InpMagic`.

E' la famiglia della `@DAQUANDO` inventata (punto 11) applicata alla **soglia del
gate**: il gate misura, ma il numero contro cui misura e' **dichiarato**.

> **La costante di un gate o si MISURA sull'artefatto vero e si scrive con la
> data della misura accanto, o si ricava a runtime dal primo artefatto** (`$base.Count`)
> **e allora il gate diventa "tutti uguali fra loro", che e' la domanda vera.**
> Un `for` che scorre un indice fisso su una collezione di lunghezza variabile
> non e' un confronto: e' un confronto parziale che tace su cosa ha saltato.

### 40-ter. 🕳️ `[void]` SUL `TryParse`: il gate piu' importante del round passa in silenzio

Stessa riga, gate G2 — quello sulla **copertura dei dati**, l'unico che secondo i
criteri puo' fermare il round:

```powershell
$d1 = [datetime]::MinValue
[void][datetime]::TryParse($Passo0.PrimaData.Replace(".","-"),$INV,...,[ref]$d1)
if($d1 -gt $limite){ $Fatale = "i dati NON coprono la finestra" }
```

`TryParse` **non lancia**: e' fatto apposta. Se la data non si parsa (formato
cambiato, riga vuota, CSV mangiato dall'ANSI, separatore diverso) `$d1` resta
`MinValue`, `MinValue -gt 2016.01.01` e' `$false`, **e il gate passa**. Il round
parte, e la cosa che il gate doveva impedire — misurare una finestra che non
esiste — succede lo stesso, con in piu' un referto che dice che il gate e'
passato.

> **`TryParse` esiste per farsi guardare il ritorno. `[void]` davanti a un
> `TryParse` e' sempre un difetto**, e su un gate e' il difetto che rende
> inutile tutto il resto:
> ```powershell
> if(-not [datetime]::TryParse($s,$INV,[Globalization.DateTimeStyles]::None,[ref]$d1)){
>   $Fatale = "PASSO 0 / G2: non riesco a leggere la data '" + $s + "'. Il gate sulla copertura NON e' stato eseguito."
> }
> ```
> Regola generale: **"non ho potuto misurare" e "ho misurato e va bene" devono
> essere due esiti DIVERSI.** Ogni volta che collassano nello stesso ramo, il
> gate e' decorativo. Vale per `TryParse`, per un `catch{ continue }`, per una
> cartella di log vuota (punto 34-ter) e per un `Test-Path` su un artefatto mai
> nato (punto 22).

## 41. 🏷️ IL GATE E LA CORSA CHE CONDIVIDONO IL MAGIC: la corsa cancella la prova del gate

_Difetto vero, stessa riga, stesso commit — e con il **precedente gia' scritto
negli stessi criteri** che la riga esegue. `R95_CRITERI.md` §1.2 riporta di R82:
"i per-trade della IS sono stati sovrascritti da quelli della OOS (**il nome del
file contiene il magic, non la finestra**)". Sei righe dopo, gli stessi criteri
assegnano al PASSO 0 il magic **779500** — che e' anche il magic dei **5 file
prova della griglia**._

Il punto 26 copre due chiamate nello stesso blocco, il 35 due serate. Questo
copre **il gate e la corsa che gate protegge**, ed e' peggio dei due perche' la
prova che sparisce e' proprio quella che autorizzava la corsa.

`ABTG_LiquiditySweep.mq5` chiama `ExportTrades()` da `OnTester()`, cioe' **a ogni
passata**, ottimizzazione compresa, e il nome e'
`Common\Files\abtg_trades_<EA>_<Simbolo>_<magic>.csv`. Sequenza reale:

1. PASSO 0, passata singola magic 779500 -> il per-trade del gate esiste, si legge, il gate passa;
2. la catena parte: **30 passate, stesso magic, su piu' agent in parallelo**, tutte sullo stesso file;
3. la raccolta a fine corsa copia `abtg_trades_..._779500.csv` sul Desktop chiamandolo **`passo0_pertrade_779500.csv`**.

Nello zip che Claudio manda c'e' un file col nome del gate e dentro **l'ultima
passata di ottimizzazione che e' riuscita a scriverlo**. Nessun errore, nessun
rosso: e' il referto stantio del 17/08 con il nome giusto sopra.

> **Due pezzi, insieme:**
> 1. **l'artefatto di un gate si mette in SOSTA con un nome proprio SUBITO dopo
>    averlo prodotto** (punto 26), **prima** dei controlli e non alla fine — cosi'
>    esiste anche quando il gate esce rosso ed e' proprio il caso in cui serve:
>    ```powershell
>    Copy-Item -LiteralPath $pt -Destination (Join-Path $Sosta ("passo0_pertrade_"+$m+".csv")) -Force
>    ```
> 2. **la fase di controllo e la fase di misura non condividono il magic.** Il
>    magic e' il **discriminante nel nome dell'artefatto** (punto 31): se due fasi
>    lo condividono, l'artefatto non distingue piu' le fasi. Un magic vergine in
>    piu' costa zero. E il ritorno e' doppio: e' anche il canarino con cui
>    `walkforward_generico.ps1` (righe 690-694) distingue **una cella rigirata da
>    una ripescata dalla cache** (punto 38) — canarino che, col magic condiviso,
>    trova il file gia' li' dal PASSO 0 e risponde sempre "e' girata".

### 41-bis. 🧯 E LA RACCOLTA "CHE SI FA SEMPRE" CHE NON PUO' GIRARE: variabili nate dentro il `try`

Stessa riga. La raccolta e' fuori dal `try`, come vuole il punto 10 — ma usa
`$Comune`, che viene assegnata **dentro** il `try`, a meta' strada. Su qualunque
errore precedente (e il 40-bis e' esattamente uno di quelli) `Join-Path $Comune ...`
esplode dentro il `try` della raccolta, si stampa `!! raccolta incompleta` e
**il REFERTO non viene scritto affatto**: proprio nella corsa fallita, che e'
l'unica in cui il referto serve a capire perche'.

> **Tutto cio' che la raccolta usa si dichiara PRIMA del `try` che puo' fallire**
> (percorsi, cartelle di sosta, contenitori), oppure la raccolta lo guarda
> (`if($Comune){...}`). Prova secca da fare a tavolino, senza eseguire niente:
> **si mette un `throw` finto alla prima riga del `try` e si legge quali
> variabili la raccolta trova a `$null`.**

---

## 🆕 AGGIUNTE DEL 21/08/2026 — trovate RI-verificando la riga R93 dopo le correzioni

### 35-bis. 🎯 LA RACCOLTA RESA CUMULATIVA PER `-Gamba`, RIMASTA DISTRUTTIVA PER `-Solo`

_Difetto vero, in `lancia_r93.ps1` v2 (righe 673-697), trovato nel giro di
ri-verifica: il punto 35 era stato chiuso **per la strada che lo aveva prodotto**
(`-Gamba A` una sera, `-Gamba B` l'altra) e lasciato aperto **per l'altra strada
che lo stesso documento consiglia**._

```powershell
$gambeGirate = @($celle | ForEach-Object { $_.G } | Select-Object -Unique)
foreach ($g in $gambeGirate) {
  $dg = Join-Path $dest $g
  if (Test-Path $dg) { Remove-Item $dg -Recurse -Force }   # ripulisce la GAMBA INTERA
  ...
}
foreach ($c in $celle) { ... copia SOLO le celle di $celle ... }   # e ne rimette UNA
```

La pulizia ragiona per **gamba**, il riempimento ragiona per **cella**. Finche' si
lancia una gamba intera i due perimetri coincidono e non si vede niente. Ma il
par. 14 dello stesso documento consiglia `-Solo "A1" -Rifai` per rifare una cella:
li' `$celle` ha **un** elemento, la cartella `A\` viene **rasa al suolo** e ci
rientrano **2 CSV su 12**. Lo zip si rifa' su quello che resta, il referto scrive
`MANCANTI (di questo giro): nessuno` — perche' conta solo la cella di QUESTO giro —
e la frase di guardia messa apposta nel referto (*"vale solo per le GAMBE girate
stasera"*) non copre il caso, perche' parla di gambe e il buco e' fra le celle.

> **Quando si ripara una raccolta distruttiva, il perimetro della PULIZIA deve
> essere lo stesso perimetro del RIEMPIMENTO.** Regola pratica: si ripulisce solo
> se si sta rifacendo l'insieme intero (`if ($Solo -eq "") { Remove-Item ... }`),
> altrimenti si sovrascrive e basta. E la verifica non si fa sul flag che ha
> generato il difetto: **si fa su TUTTI i flag che il documento consiglia** —
> `-Gamba`, `-Solo`, `-Rifai`, il rilancio a mano.

### 42. 🫥 LA RIGA DI RIPARAZIONE CHE RIUSA UNA VARIABILE DEL BLOCCO PRECEDENTE

_Difetto vero, par. 14 di `R93_CRITERI.md`, sezione "Se serve RIFARE una cella"._

```powershell
& powershell -ExecutionPolicy Bypass -File $p -Rif lavoro -Solo "A1" -Rifai
```

`$p` era stato assegnato **dentro** il `& { ... }` del blocco 2. `&` su uno
scriptblock apre uno **scope figlio**: quando il blocco finisce, `$p` non esiste
piu'. Incollata da sola, questa riga passa a `-File` una stringa vuota e
PowerShell si mangia l'argomento dopo (`-Rif`) come se fosse il nome dello script:
errore oscuro, e Claudio non ha modo di capire che il colpevole e' una variabile
evaporata due blocchi fa.

> **Ogni riga destinata a Claudio si legge come se fosse l'UNICA cosa incollata
> in una finestra appena aperta.** Nessuna variabile viaggia fra un blocco e
> l'altro: o si riscrive il percorso per esteso
> (`"$env:USERPROFILE\lancia_r93.ps1"`), o la riga ha il suo `& { ... }` completo
> di `irm`, marcatore e guardia MT5. Il punto 21 dice che tre righe in un blocco
> non sono un programma; questo dice che **cinque blocchi in una chat non sono
> una sessione**.

### 40-quater. 👁️ L'ATTESO DA CONFRONTARE A OCCHIO, CALCOLATO CON UNA FORMULA CHE NON E' QUELLA DELL'EA

_Difetto vero, `R93_CRITERI.md` par. 5.5 e par. 14 blocco 3 (in DUE punti)._

Il blocco 3 manda Claudio a leggere nel test singolo una riga di autotest e a
confrontarla **carattere per carattere** con questa, stampata nei criteri:

```
geometria su pattern 100-110 (range 10): target100=100.00 | EZ1 [98.20 - 99.20] | EZ2 [88.20 - 89.20] | banda=1.00
```

L'EA pero' ha `InpEZ1near/far = 1,78/1,88` e `InpEZ2near/far = 2,78/2,88`, e
`LivelloFibo()` fa `alto - k*(alto-basso)`: su 100-110 stampera'
`EZ1 [91.20 - 92.20] | EZ2 [81.20 - 82.20]`. I numeri del documento vengono da
`k = 1,08/1,18/2,08/2,18`, che nell'EA **non esistono**. Esito: o Claudio ferma il
round per un falso allarme sull'unico gesto che certifica la geometria della gamba
B, o impara che gli attesi del documento sono "circa" — e allora il gesto non
serve piu' a niente.

> E' il **40-bis applicato all'occhio umano invece che a un `if`**: un `throw`
> sbagliato almeno esplode, un atteso sbagliato stampato in chat **erode la
> fiducia nei controlli**, che e' peggio.
> **Ogni numero atteso stampato in una riga di lancio si RICALCOLA con la
> formula dell'EA e i suoi default veri, prima di scriverlo** — e se la formula
> e' in tre righe di codice, si esegue quella, non si va a memoria.

---

## 🆕 AGGIUNTA DEL 21/08/2026 — trovata alla **TERZA** verifica di R93 (verdetto PASS)

### 43. 📍 LA CITAZIONE DI RIGA CHE DRIFTA DOPO LA CORREZIONE — la mappa che non segue il territorio

**Contesto.** In questa casa i criteri non dicono *"lo script ripiega sulla copia
locale"*: dicono *"`walkforward_generico.ps1` ha `$EABranch="lavoro"` scritto
fisso (**riga 78**)"*. E' il metodo che ci ha salvati: **si cita la riga, e il
verificatore va a leggerla.** Il punto 1 di questa checklist e' esattamente
quello.

**Il difetto.** Quando lo script citato viene modificato (o cresce sopra la riga
citata), **la citazione non si sposta con lui**. La FRASE resta vera, il NUMERO
diventa falso. Misurato su R93 v3, tre casi in un documento solo:

| il documento dice | dove sta davvero | la frase e' |
|---|---|---|
| `$EABranch="lavoro"` a **riga 78** | riga **91** (la 78 e' un commento sullo spread) | ✅ vera |
| l'anteprima scrive solo la finestra IS, **righe 526-527** | righe **518-519** (le 526-527 sono `ShutdownTerminal` e `Report=`) | ✅ vera |
| copia e compila alle **righe 601-603** | righe **602-603** | ✅ vera |

**Perche' costa, anche quando la frase e' giusta.** Il verificatore che apre la
riga 78 e ci trova un commento sullo spread ha due strade, ed **entrambe sono un
giro a vuoto**:
1. **cerca a mano** il codice vero altrove — tempo speso a rifare una mappa che
   qualcuno aveva gia' fatto;
2. **conclude che la citazione e' inventata** e boccia una riga sana. E questo e'
   il caso peggiore: **un FAIL falso costa a Claudio esattamente quanto un PASS
   falso**, perche' rimanda un round che era pronto. La cache di raw e l'MT5
   aperto non sono gli unici modi di bruciare una serata: **anche il
   verificatore che sbaglia ne brucia una.**

Ed e' la stessa famiglia del **40-bis/40-quater**: un numero scritto a memoria
invece che misurato sull'artefatto. Li' era l'atteso di un gate e l'atteso di un
occhio umano; qui e' l'indirizzo della prova.

> ✅ **REGOLA.** Ogni numero di riga citato in un documento di round si
> **riverifica sull'artefatto nel commit che si sta per lanciare**, non su quello
> in cui era stato scritto. Un `grep -n` per ogni citazione, prima del push:
> costa dieci secondi e vale la mappa.
> 🥈 **Se il numero non lo si vuole mantenere, si cita il MARCATORE invece della
> riga** (`cerca $EABranch=` , `cerca "Model=4"`): il marcatore si sposta da solo
> col codice, il numero no. **Una citazione che non si puo' mantenere e' meglio
> scritta come pattern da cercare che come indirizzo fisso.**

---

## 🆕 AGGIUNTE DEL 21/08/2026 — trovate RI-verificando la riga R94 dopo le correzioni

### 44. 🚨 LA SPIA CHE NON DISTINGUE "SALTATA" DA "NON GIRATA": il falso allarme sul percorso di RIPRESA che il documento stesso consiglia

_Difetto vero, `lancia_r94.ps1` v2 righe 472-522, trovato nel giro di
ri-verifica. E' il **rovescio** del punto 38: li' il problema era una spia che
**mancava**, qui e' la stessa spia che **suona quando non deve**._

Il punto 38 ha messo la spia giusta — *"un pass ripescato dalla cache non scrive
i per-trade"* — e il driver la implementa cosi':

```powershell
if ($ptPresi -eq 0) {
  Write-Host "    RIPESCATA dalla cache invece che eseguita (punto 38)..."
  $ripescate += $c.K            # -> finisce nel referto che legge Claudio
}
```

Ma **"nessun per-trade fresco" ha DUE cause, non una**, e la seconda e' sana:
`walkforward_generico.ps1` alla riga 615 **salta** la finestra il cui CSV esiste
gia' (`"$tag gia' fatto, salto"`). Una cella saltata **non apre MT5** e quindi
**non riscrive i per-trade** — esattamente come una ripescata.

E la riga di lancio **consiglia proprio quel percorso**: *"SE LA CORSA SI
INTERROMPE: si rimanda lo stesso BLOCCO 2. Le celle gia' fatte vengono saltate:
la ripresa qui e' sana e va usata."* Esito: alla prima interruzione — su 24
passate a tick reali, cioe' ore di macchina — il referto avrebbe scritto
`CELLE SENZA PER-TRADE FRESCO (sospette di RIPESCAGGIO dalla cache): A20 A37 B20`
su celle **perfettamente sane**, e proprio sul **canarino**, che e' il controllo
per cui il round esiste. Claudio avrebbe fermato tutto in buona fede.

> **Ogni spia costruita sull'ASSENZA di un artefatto deve enumerare TUTTE le
> strade per cui quell'artefatto puo' mancare, e chiamarle con nomi diversi.**
> Qui: si guarda **prima** se i CSV della cella ci sono gia' (= il driver la
> saltera'), e allora l'esito e' `CELLE SALTATE`, non `sospette di ripescaggio`.
> ```powershell
> $saltata = (($giaFatte -eq 2) -and (-not $Rifai) -and (-not $SoloControllo))
> if ($ptPresi -eq 0) { if ($saltata) { $saltate += $c.K } else { $ripescate += $c.K } }
> ```
> E la distinzione **non e' solo cosmetica: aggiunge un'informazione che serve**.
> Una cella saltata ha i numeri di un giro precedente, in cui la cache era stata
> svuotata **allora** e non adesso: se e' una cella di canarino, va scritto che
> il suo controllo vale **per quel giro**.
>
> 🧪 **La verifica si fa sul percorso che il documento CONSIGLIA**, non solo su
> quello dritto: e' lo stesso principio del 35-bis (`-Gamba` sistemato, `-Solo`
> no). Se la riga dice "se si interrompe, rimanda lo stesso blocco", allora la
> ripresa **e' un caso d'uso normale** e i controlli si leggono in quello stato.

### 45. 🧟 IL RESIDUO DELLA CORREZIONE DICHIARATA CHIUSA — e' un problema di METODO, non di contenuto

_Difetto vero, trovato nella stessa ri-verifica di R94, in DUE posti diversi
dopo che il difetto era stato dichiarato chiuso al 100%._

Il difetto D2 di R94 era: *"la riga promette il funnel `[BB-FUNNEL]`, che in
ottimizzazione non puo' esistere"* (punto 34-ter). La correzione e' stata fatta
bene **dove il difetto era stato citato** — la sezione del funnel, il referto,
la stampa a schermo — e **sopravvissuta in due posti che nessuno ha rigrepato**:

| dove | cosa diceva ancora | perche' conta |
|---|---|---|
| `lancia_r94.ps1` riga 37, **intestazione** | *"porta via i LOG DEGLI AGENT (li' c'e' il funnel [BB-FUNNEL]...)"* | e' il **riassunto di cosa fa lo script**: il primo posto che legge la sessione dopo |
| `R94_CRITERI.md` riga 306, **tabella "cosa e' stato verificato"** | *"Unico residuo: `lot<=0` (riga 1133), **contato dal funnel**"* | quel file **viaggia nello zip**: manda Claudio a cercare un artefatto che non esiste |

Nello stesso file, venti righe piu' sotto, c'era gia' scritto che quella frase
era sbagliata (*"Era: 'l'unico scarto e' contato dal funnel' — un rimando a un
artefatto inesistente"*). **Il documento conteneva l'errore e la sua smentita,
non riconciliati.**

> **Chiudere un difetto non e' correggere il punto in cui e' stato segnalato: e'
> un `grep` del CONCETTO su TUTTI gli artefatti del round**, commenti e
> intestazioni compresi.
> ```
> grep -rn 'BB-FUNNEL\|funnel' <driver> <riga> <criteri> <file prova>
> ```
> Regola pratica, e vale come criterio di accettazione di una correzione:
> **la stringa che nominava il difetto deve comparire SOLO dove si spiega che e'
> stato corretto.** Se compare ancora in un posto che *afferma* la cosa vecchia,
> il difetto **non e' chiuso**, e' stato **spostato**.
> ⚠️ Corollario sui verbali: quando un documento tiene insieme il testo vecchio
> e la nota di correzione, **si riconcilia il testo vecchio**, non si aggiunge
> solo la nota in fondo — perche' le tabelle si leggono per prime e le note in
> fondo per ultime.

---

## 🆕 AGGIUNTE DEL 21/08/2026 — trovate RI-verificando la riga R95 dopo le 12 correzioni

_Contesto: la v2 della riga R95 chiudeva davvero tutti e dodici i difetti della
prima verifica (contati: 32 righe vive nei 5 file prova, `\r?` davanti a ogni `$`
multilinea, tre radici di log con "zero letti = FATALE", magic 779502 vergine,
sosta prima dei gate, header e `StringFormat` dell'EA a 16 colonne su tutti e tre
i rami). **I due difetti nuovi stanno DENTRO due delle correzioni**: una non fa
niente, l'altra legge un campo che non esiste. E' la lezione del 23-bis
generalizzata — **la contromisura ha il suo difetto, e va verificata come se
fosse codice nuovo, perche' lo e'.**_

## 46. 🧯 `-LiteralPath` SU UN PERCORSO CHE CONTIENE UN WILDCARD: non cancella niente, e dice che ha cancellato

_Difetto vero, `backtest_pipeline/righe/RIGA_R95_LIQSWEEP_JPY.ps1` riga 344
(commit `88eb08f`), trovato PRIMA dell'invio. E' la correzione del punto 38
(svuotare `Tester\cache`) **resa inerte dalla riga dopo**._

```powershell
$nc = @(Get-ChildItem -LiteralPath $cache -File -EA SilentlyContinue).Count
Remove-Item -LiteralPath (Join-Path $cache "*") -Recurse -Force -EA SilentlyContinue
Dico ("Tester\cache svuotata (" + $nc + " file).") "Green"      # <-- MENTE
```

`-LiteralPath` vuol dire **"il valore e' usato esattamente com'e' scritto,
nessun carattere e' interpretato come wildcard"**. Quindi `...\cache\*` non e' "il
contenuto di cache": e' un file **che si chiama `*`**, che su Windows non puo'
esistere. `Remove-Item` non trova niente, `-EA SilentlyContinue` mangia l'errore,
e il `Dico` subito sotto stampa **in verde** il numero di file che c'erano
**prima** — cioe' proprio il numero che fa sembrare riuscita la cancellazione che
non e' avvenuta.

Il veleno e' che nasce **per riflesso**: il resto dello script usa `-LiteralPath`
ovunque, ed e' giusto (`-LiteralPath <cartella> -Filter "*.csv"` e' corretto: il
wildcard sta nel `-Filter`, non nel percorso). L'unico punto in cui il wildcard
sta **nel percorso** e' quello in cui `-LiteralPath` lo uccide. Lo snippet del
punto 38 in questa stessa checklist e' scritto giusto (`Remove-Item (Join-Path
$cacheT "*") -Recurse -Force`, posizionale = `-Path`): la correzione e' stata
copiata **e migliorata a mano**, e la "migliorata" e' il difetto.

Conseguenza misurata su R95: alla **prima** corsa non cambia niente (magic
vergine, celle mai girate), ma a **ogni rilancio** le 30 passate sono identiche e
MT5 le **ripesca dalla cache** senza scrivere i per-trade — con i CSV a 3 righe,
`ESITO: OK`, e il canarino anti-cache del driver (righe 690-694) spento. E' il
punto 38 che si riapre da solo dopo essere stato dichiarato chiuso.

> 🥇 **Grep secco prima di mandare: `LiteralPath[^|)]*\*`.** Ogni occorrenza in
> cui l'asterisco sta **dentro il percorso** e non dentro un `-Filter` e' una
> riga da rifare.
> 🥈 **E la cancellazione si VERIFICA, non si annuncia**: si conta prima, si
> conta **dopo**, e si stampano tutti e due i numeri. Un `Remove-Item` con
> `-EA SilentlyContinue` non ha nessun modo di dirti che non ha fatto niente.
> ```powershell
> $nc = @(Get-ChildItem -LiteralPath $cache -Recurse -File -EA SilentlyContinue).Count
> Get-ChildItem -LiteralPath $cache -Force -EA SilentlyContinue | Remove-Item -Recurse -Force -EA SilentlyContinue
> $nr = @(Get-ChildItem -LiteralPath $cache -Recurse -File -EA SilentlyContinue).Count
> if($nr -gt 0){ [void]$Problemi.Add("cache NON svuotata: " + $nr + " file su " + $nc + " rimasti") }
> Dico ("Tester\cache: " + $nc + " prima, " + $nr + " dopo.")
> ```
> ⚠️ Il perimetro resta comunque **solo** `Tester\cache`: `Get-ChildItem` su
> quella cartella non puo' raggiungere `bases\<server>\ticks` in nessun caso.
> Corollario generale: **una guardia che cancella si misura sull'EFFETTO
> (quanto e' rimasto), mai sull'INTENZIONE (quanti ce n'erano).**

### 46-bis. 🕳️ LA COLONNA LETTA CON UN NOME CHE NEL CSV NON C'E': PowerShell risponde `$null` e tira dritto

_Stessa riga, riga 408, ed e' **la correzione del D9** (leggere il referto dello
storico invece di fingere di averlo letto):_

```powershell
[void]$Note.Add("PASSO 0-A: " + $r.Simbolo + " " + $r.Timeframe + " prima data " + $r.PrimaDataLocale + " -> " + $r.Stato)
```

`ABTG_StoricoScaricato.csv` lo scrive `mql5/Scripts/ABTG_HistoryDownloader.mq5`
riga 140, e le sue colonne sono
`Simbolo,Timeframe,Barre,PrimaDataLocale,PrimaDataServer,**Verdetto**`.
**`Stato` non esiste.** Senza `Set-StrictMode`, una proprieta' inesistente su un
oggetto di `Import-Csv` vale `$null` **in silenzio**: la nota esce come
`PASSO 0-A: EURJPY M1 prima data 2015.01.05 -> ` e finisce cosi', nel referto,
con l'aria di essere completa. Il campo perso e' esattamente quello che dice
**"IL BROKER NON HA PIU' STORICO"**, cioe' l'unica ragione per cui il PASSO 0-A
esiste. In piu' la colonna citata e' quella sbagliata: `scarica_storico.ps1`
chiude stampando _"la colonna che serve e' **PrimaDataServer**"_, e
`PrimaDataLocale` e' solo quello che c'e' gia' sul disco.

E' il 40-ter ("non ho potuto misurare" e "ho misurato e va bene" nello stesso
ramo) applicato al **contratto con l'artefatto di un gemello**: il punto 33 dice
di non fidarsi di due artefatti che descrivono la stessa cosa, questo dice di non
fidarsi nemmeno dello **schema** di un artefatto che scrive qualcun altro.

> **I nomi delle colonne di un CSV altrui si LEGGONO nel codice che lo SCRIVE**
> (`FileWrite(fh,"Simbolo","Timeframe",...)`), non si ricordano — e la lettura
> porta la sua guardia, cosi' un cambio di schema si legge invece di sparire:
> ```powershell
> if(("" + $r.Verdetto) -eq ""){ [void]$Problemi.Add("referto storico senza colonna Verdetto: formato cambiato, NON letto.") }
> ```
> Regola gemella del punto 34-bis (_il canarino letto dalla parte che lo scrive_):
> qui il canarino e' letto dalla parte giusta, ma **con la chiave sbagliata**, e
> il risultato e' lo stesso — una stringa vuota che passa per una misura.

---

## 🆕 AGGIUNTE DEL 21/08/2026 — trovate alla **TERZA** verifica della riga R95

_Contesto, e va detto prima dei due punti perche' e' il punto vero: la v3 di
R95 chiude davvero N1, N2, N3 e N4 (cache contata prima E dopo, `Verdetto` letto
col nome giusto, `Livelli Buttati` nel referto, v1.11 ovunque, 32 righe vive e
diff 2 misurati sull'artefatto). **E per la TERZA volta di fila esce un difetto
che vive DENTRO una correzione**: la prima volta erano 12 difetti nuovi, la
seconda 2 nati nelle correzioni, la terza uno nato in una correzione (47) e uno
sopravvissuto a una correzione dichiarata chiusa (48). Non e' sfortuna: e' che
**una correzione si verifica come codice nuovo, e non si verifica solo nel punto
in cui e' stata scritta.**_

## 47. 🔔 LA SPIA TARATA SU UN PARAMETRO CHE LA RIGA STESSA PASSA: non puo' che essere rossa

_Difetto vero, `backtest_pipeline/righe/RIGA_R95_LIQSWEEP_JPY.ps1` righe 410 e
443 (commit `0eac2cf`), trovato PRIMA dell'invio. E' la correzione del punto
46-bis (leggere la colonna `Verdetto` invece della colonna `Stato`, che non
esiste): la CHIAVE e' stata corretta, il SIGNIFICATO no._

```powershell
& powershell.exe ... -File $ScStorico -Simboli $Sym -Da "1995.01.01" ...
...
elseif($verd -match "(?i)non ha piu' storico"){ [void]$Problemi.Add("il BROKER NON HA PIU' STORICO ...") }
```

Quel `Verdetto` non e' un giudizio assoluto sullo storico: `ABTG_HistoryDownloader.mq5`
(riga 199) lo calcola **contro il parametro che gli abbiamo passato noi**:

```mql5
else if(srvFirst > from + 86400)   verdetto = "IL BROKER NON HA PIU' STORICO";
```

con `from = StringToTime(InpDataInizio)` = **1995.01.01**, che e' proprio la data
che la riga passa per dire *"dammi tutto quello che hai"*. Nessun broker ha
EURJPY dal 1995: **il verdetto e' "IL BROKER NON HA PIU' STORICO" per
costruzione, su M1 e su M15, a ogni corsa, anche quando lo storico copre la
finestra con anni di margine.**

Conseguenza misurata leggendo il resto della riga: due `$Problemi` garantiti →
`ESITO: PARZIALE -- 0 file su 5 non sono OK, e 2 problemi in elenco. NON e' un
round completo`, **uscita 1**, e un blocco rosso che dice a Claudio *"la finestra
si SPOSTA, non si scarica"* su una finestra sana. Il difetto e' peggiore di un
gate che tace: **e' un gate che grida sempre**, e dopo due corse nessuno lo
guarda piu' — che e' il modo in cui muoiono anche i gate buoni intorno.

Nella v2 la stessa informazione finiva in una **Nota** ed era innocua. La
correzione l'ha promossa a **Problema** senza ricalcolare cosa significasse.

> 🥇 **Un valore letto dall'artefatto di un gemello si interpreta leggendo la
> FORMULA che lo produce, non il suo NOME.** `Verdetto`, `Stato`, `OK`, `COMPLETO`
> sono etichette relative a un ingresso: si va a vedere **contro cosa** sono
> calcolate.
> 🥈 **Se l'ingresso lo passa la riga stessa, la spia va tarata sullo stesso
> numero della domanda vera.** Qui: o si passa `-Da $DaQuando` (e allora
> `COMPLETO` vuol dire davvero "copre la finestra"), o si smette di leggere
> `Verdetto` e si confronta `PrimaDataServer` con `$DaQuando`.
> 🥉 **E i valori possibili si enumerano TUTTI** (qui erano cinque: `NESSUN DATO`,
> `server non risponde`, `MANCA STORICO LOCALE`, `IL BROKER NON HA PIU' STORICO`,
> `COMPLETO`): la riga ne trattava **due**, e gli altri tre — tutti brutti —
> cadevano nel ramo silenzioso del "va bene". E' il 40-ter di nuovo.
> **Regola pratica: si scrive la guardia al positivo** (`if($verd -ne "COMPLETO")`),
> cosi' un valore nuovo non puo' passare per buono.

## 48. 🧬 LE VARIABILI SONO USCITE DAL `try`, LA **FUNZIONE** NO

_Difetto vero, stessa riga, `function CsvDi` alla riga **694** — dentro il `try`
che va da 189 a 772 — usata alla riga **790**, dentro la raccolta che sta
**fuori**. **Riprodotto**, non dedotto (`pwsh`, throw finto prima della
definizione): `!! raccolta incompleta: The term 'CsvDi' is not recognized...`_

E' il **punto 41-bis dichiarato chiuso e riaperto un centimetro piu' in la'**.
Li' la regola era: *"tutto cio' che la raccolta usa nasce PRIMA del `try` che puo'
fallire"*, e in v2 sono state spostate fuori `$Comune`, `$Sosta`, `$Risultati`.
**Nessuno ha pensato che anche una FUNZIONE e' una cosa che la raccolta usa** —
e in PowerShell una `function` **non e' dichiarativa: e' un'istruzione che
definisce il nome quando il flusso ci passa sopra.** Se il flusso non ci arriva,
il nome non esiste, e con `$ErrorActionPreference="Stop"` la chiamata e' un
errore TERMINANTE.

Perche' e' bloccante e non cosmetico: il `throw` che salta la definizione e'
**esattamente il caso normale di questa riga** — i quattro gate del PASSO 0
(`G1` per-trade vuoto, `G2` dati che non coprono, `G3` gemelli divergenti,
`G4` tetto che morde o zero log letti) sono `throw` **prima** della sezione 5.
Cioe': **il referto non viene scritto proprio nelle corse in cui il gate ferma il
round**, che sono le uniche in cui il referto serve a capire perche'. Sul Desktop
resta una cartella `R95_..._<stamp>` **vuota**, nessuno zip, e la console
stampa comunque il percorso dello zip inesistente.

> **La prova del 41-bis si rifa' cosi', e stavolta anche sui NOMI:** si mette un
> `throw` finto alla prima riga del `try` e si guarda cosa la raccolta trova a
> `$null` **o non trova affatto**. Grep secco:
> ```
> awk '/^try\{/{t=NR} /^function /{if(t)print NR": "$0}' <script>
> ```
> Ogni `function` definita dentro il `try` e chiamata fuori e' una riga da
> spostare. **Le funzioni di servizio stanno in cima, sopra il `try`, sempre** —
> accanto a `Dico`, `Titolo` e `Scarica`, dove le altre stavano gia' e dove
> questa non e' stata messa solo perche' e' nata piu' tardi.

---

## 49. 🪞 IL DRIVER SALTA PER **FINESTRA**, NON PER CELLA: ogni spia costruita sulla CELLA deve dichiarare anche lo stato **A META'**

_Difetto vero, trovato alla **terza** verifica della riga R94 — e nato **dentro
la correzione** del punto 44, fatta il giorno prima. Il conteggio
`$giaFatte` era misurato **per finestra** (IS, OOS) e poi **collassato in un
booleano** (`-eq 2`): con `$giaFatte -eq 1` la cella non finiva ne' fra le
`SALTATE` ne' fra le sospette, e il referto scriveva `PER-TRADE FRESCHI: tutte
le celle GIRATE hanno scritto la loro serie` **mentre una delle due gambe non
era stata rigirata affatto**._

`walkforward_generico.ps1` salta **dentro** il ciclo delle finestre
(righe 612-616):

```powershell
foreach($w in $WF){
  $tag="$($Expert)_$($Simbolo)_$($w.Tag)$Suffisso"
  $done=Join-Path $Results "$tag.csv"
  if((Test-Path $done) -and -not $Rifai){ ... continue }
```

Quindi **l'unita' di ripresa e' la FINESTRA**, mentre l'unita' di cui parlano
il file prova, la riga di lancio, il referto e le soglie e' la **CELLA**.
Interrompere la corsa durante l'OOS lascia l'**IS** sul disco: al rilancio la
cella ha **una gamba di ieri e una di oggi**, e tutto cio' che il round aveva
preparato "per cella" (svuotamento della cache, spia dei per-trade, frase sul
canarino) **vale per meta'**.

> 🪞 **E il difetto e' l'immagine speculare di quello che correggeva:** il punto
> 44 nasceva da una spia che **gridava dove doveva tacere**; la sua correzione ha
> prodotto una spia che **tace dove deve dichiarare**. Quando si aggiunge un
> ramo a una spia, i rami vanno **enumerati tutti e tre** — *ok*, *allarme*,
> **e lo stato intermedio** — non due.

**Regola.** In un round dove la ripresa e' consentita:
1. **non collassare** un conteggio per finestra in un booleano: `0` / `parziale`
   / `completo` sono **tre** stati, e il secondo va **dichiarato**, non ignorato;
2. la spia stampa e scrive nel referto una **voce propria** per lo stato
   intermedio (`CELLE A META'`), che dica **da quale giro viene ogni gamba**;
3. le frasi di garanzia si scrivono **per differenza**, non per affermazione:
   ❌ *"le tre celle di canarino sono state rigirate a cache vuota"*
   ✅ *"le celle di canarino **non elencate come SALTATE o A META'** sono state
   rigirate adesso, a cache vuota"*;
4. e la riga offre la **riparazione pronta** (`-Solo <cella> -Rifai`), dicendo
   cosa cambia nella raccolta quando la si usa.

> 🧪 **Come si prova, e costa un minuto:** si costruisce un albero finto con
> **0, 1 e 2** CSV della stessa cella e si esegue la logica dei rami. Con
> `-Rifai` nessuno dei due stati deve accendersi (si rifa' tutto). Se la
> matrice non e' stata **eseguita**, la spia non e' stata verificata: e' stata
> letta.

---

## 🆕 AGGIUNTA DEL 21/08/2026 — trovata alla **QUARTA** verifica della riga R95

_Contesto, e vale come dato del round: R95 ha prodotto **12** difetti al primo
giro, **2** al secondo (nati dentro le correzioni), **2** al terzo (uno nato in
una correzione, uno residuo), e al quarto **1 residuo + 2 nuovi**. Quattro giri
su quattro con almeno un difetto che vive **dentro una correzione o accanto ad
essa**. La v4 chiude davvero D1 e D2 (referto scritto nella corsa fermata:
**riprodotto** con un `throw` finto alla prima riga del `try`; `-Da $DaQuando`
che arriva a `InpDataInizio`). Il difetto nuovo qui sotto e' **riprodotto**, non
dedotto._

## 50. 🪞 IL REFERTO DEL **GIRO A VUOTO** INDISTINGUIBILE DA QUELLO DELLA CORSA VERA

_Difetto vero, `backtest_pipeline/righe/RIGA_R95_LIQSWEEP_JPY.ps1` righe 821-822
e 891-901 (commit `9199e75`), **RIPRODOTTO** con `pwsh`: lanciato in
`-SoloControllo`, il referto chiude con_

```
ESITO: OK -- tutti i file hanno prodotto le righe attese, nessun problema in elenco.
```

_avendo prodotto **zero passate** e con la tabella dei lavori a `IS -1 / OOS -1`
su tutte e cinque le righe. Uscita **0**._

Il punto 14 copre il giro a vuoto che **esce 0 anche se un pezzo e' fallito**.
Questo copre il caso in cui il giro a vuoto e' andato **benissimo** — e proprio
per questo produce un artefatto che **mente sul round**:

| cosa | corsa vera | giro a vuoto | uguali? |
|---|---|---|---|
| cartella sul Desktop | `R95_LIQSWEEP_JPY_<stamp>` | `R95_LIQSWEEP_JPY_<stamp>` | **si'** |
| zip | `R95_LIQSWEEP_JPY_<stamp>.zip` | idem | **si'** |
| referto dentro | `REFERTO_R95.txt` | `REFERTO_R95.txt` | **si'** |
| riga `data:` | di adesso | di adesso | **si'** |
| ultima riga | `ESITO: OK` | `ESITO: OK` | **si'** |

La riga `data:` — la contromisura del punto 13 contro il referto stantio —
**non protegge**, perche' il referto del giro a vuoto e' fresco davvero. E il
giro a vuoto non e' un caso di scuola: e' **la riga stessa** a prescriverlo
(punto 5 di questa checklist), quindi succede **prima di ogni corsa**, cioe' il
file sbagliato sul Desktop c'e' sempre e ha lo stesso nome di quello giusto.

> **Un artefatto prodotto in una MODALITA' diversa porta la modalita' nel NOME,
> dentro il referto, e nella riga di ESITO.** Tutti e tre, perche' si guardano
> in tre momenti diversi (il Desktop, l'apertura del file, il fondo del file):
> ```powershell
> $Modo = "CORSA VERA"
> if($SoloControllo){ $Modo = "GIRO A VUOTO (-SoloControllo)" }
> elseif($SaltaPasso0){ $Modo = "CORSA VERA CON PASSO 0 SALTATO" }
> $Tag  = if($SoloControllo){ "CONTROLLO_" } else { "" }
> $Cart = Join-Path $Dsk ("R95_..._" + $Tag + $Stamp)      # 1: il NOME
> [void]$R.Add("modo: " + $Modo)                            # 2: DENTRO
> if($SoloControllo){                                       # 3: l'ESITO
>   [void]$R.Add("ESITO: GIRO A VUOTO COMPLETATO -- N anteprime .ini. NESSUNA passata, NESSUN CSV, NESSUN numero di round.")
> }
> ```
> ⚠️ **La frase dell'ESITO non puo' essere generica.** Qui diceva *"tutti i file
> hanno prodotto le righe attese"*: e' vera per il codice (nessun file era
> `-ne "OK"`) e falsa per il mondo (nessun file ha prodotto niente). **Una frase
> di esito che resta vera solo perche' il perimetro e' vuoto va riscritta.**
> Regola gemella: **ogni switch che cambia cosa la corsa MISURA** (`-SoloControllo`,
> `-SaltaPasso0`, `-Rifai`, `-Solo`) **si scrive nel referto**, anche quando non
> genera nessun problema. `-SaltaPasso0` qui era coperto solo perche' aggiungeva
> un `$Problemi`: coprire per effetto collaterale non e' coprire.


---

> 📌 **NOTA DI TRACCIABILITA' (21/08/2026).** Il punto **50** era stato scritto
> come "49" da una sessione parallela mentre un'altra occupava lo stesso numero
> (la spia della cella A META'). Rinumerato dalla sessione principale, contenuto
> intatto. **In una checklist che si cita per numero, due punti con lo stesso
> numero sono peggio di un punto mancante** — ed e' la terza volta oggi che due
> sessioni si incrociano sullo stesso file: si controlla `git diff --cached
> --name-only` prima di ogni commit, e il numero si prende **rileggendo il file
> appena prima di scrivere**, non da quello che si ricorda.

---

## 🆕 AGGIUNTA DEL 21/08/2026 — trovata alla **QUINTA** verifica della riga R95

## 51. 🔫 L'`.ini` PASSATO A `terminal64 /config` SENZA `[Experts] AllowLiveTrading=false`: aprire MT5 per MISURARE riarma la flotta

_Difetto vero, `backtest_pipeline/scarica_storico.ps1`, l'`.ini` di `-Auto`
(sezione "4b. modalita' AUTOMATICA"). Trovato PRIMA dell'invio, verificando il
PASSO 0-A della riga R95 — che quello script lo chiama._

L'`.ini` con cui `scarica_storico.ps1` avvia il terminale ha **due sezioni**:

```ini
[Charts]
MaxBars=2000000000

[StartUp]
Script=ABTG_HistoryDownloader
ScriptParameters=abtg_storico.set
```

Manca `[Experts] AllowLiveTrading=false`. E `/config` **non apre un tester: apre
il TERMINALE**, che carica l'ultimo profilo con i suoi grafici e gli EA
attaccati sopra. Sul PC di backtest quel terminale e' collegato al conto
50503392: e' esattamente il meccanismo che il **14/08** ha fatto partire un DAX
Apertura in breakout da un grafico M3 di prova, e per cui
`walkforward_generico.ps1` porta quelle due righe con dodici righe di commento
sopra (riga 627). Qui lo script apre il terminale **per leggere una colonna di
un CSV**, e lo tiene aperto per minuti mentre scarica lo storico.

**La misura che rende il punto non opinabile** — un `grep` su tutta la
pipeline, 28 script che scrivono un `.ini` per il terminale:

```
grep -n "AllowLiveTrading" backtest_pipeline/*.ps1 backtest_pipeline/righe/*.ps1
```

**27 ce l'hanno. Uno no**, ed e' proprio quello che la riga R95 chiama al
PASSO 0-A. Il difetto e' vecchio quanto lo script (15/08); e' diventato vivo
oggi, perche' fino a ieri `scarica_storico.ps1` si lanciava a mano e adesso lo
lancia una riga di round dentro la sua catena.

> ✅ **REGOLA.** **Ogni `.ini` che finisce in `terminal64.exe /config:` porta
> `[Experts] AllowLiveTrading=false` + `AllowDllImport=false`, anche quando
> l'`.ini` non parla di tester** — `[StartUp] Script=`, `[Charts]`, un `.ini`
> di sola configurazione: se apre il terminale, riarma il profilo.
> 🧪 **E il controllo si fa a grep sul PERIMETRO INTERO, non sullo script che
> si sta guardando**: il difetto gemello non vive dove e' stato corretto, vive
> dove nessuno ha guardato. Qui la contromisura del 14/08 era stata messa in
> **27 file su 28** — un tasso di copertura che *sembra* chiusura e non lo e'.
> ⚠️ **Corollario per le righe di lancio**: quando una riga chiama uno script
> gemello che apre MT5, la riga risponde anche per quello che il gemello fa
> **oltre** a stampare (punto 26). "Non tocca nessuna sedia viva" e' una
> promessa che si verifica **negli script chiamati**, non solo nel proprio.

---

## 🆕 AGGIUNTA DEL 21/08/2026 — trovata alla prima verifica della riga R96 (incrocio EMA di sessione all'apertura USA)

## 52. 🏷️ IL PARAMETRO CHE DA' IL NOME AL ROUND E CHE UN ARTEFATTO DI INIZIALIZZAZIONE RENDE **INERTE**

_Difetto vero, `mql5/Experts/ABTG_CrossEmaApertura.mq5` + `R96_CRITERI.md`.
Trovato leggendo il CODICE del motore invece della sua descrizione, come chiede
il punto 1. Non l'ha visto nessun gate: la riga di lancio e' sana._

R96 si intitola **"l'incrocio delle medie 9/21 ri-seminate all'apertura"**, e
l'ancora **e' davvero costitutiva** (le medie sono ricalcolate da un seme, non
sono le continue lette in una finestra oraria: il mandato e' rispettato). Ma
basta fare l'algebra del seme per vedere che **9 e 21 non entrano nel segnale
dominante**:

```mql5
// EmaSessione_Calc: e = chiusure[0]; poi e = c[i]*a + e*(1-a)
// alla SECONDA barra di sessione (n=2, cioe' InpMinBarreSessione):
//   fPrev = sPrev = c0          <-- il seme: le due medie COINCIDONO
//   fNow  = c0 + af*(c1-c0)     af = 2/(9+1)  = 0,2
//   sNow  = c0 + as*(c1-c0)     as = 2/(21+1) = 0,0909
// CrossDirezione usa fPrev<=sPrev, che qui e' VERO PER COSTRUZIONE:
//   c1 > c0  ->  fNow > sNow  ->  +1 LONG      (sempre)
//   c1 < c0  ->  fNow < sNow  ->  -1 SHORT     (sempre)
```

Cioe': **ogni sessione genera un incrocio GARANTITO alla seconda barra**, e la
sua direzione e' `sign(c1 - c0)` — **identica con 9/21, con 5/13 o con 8/21**,
perche' `af > as` e' l'unica cosa che conta. Con `CountPositions()>0` che blocca
i doppioni e la posizione che muore a fine finestra, quel trade e' **il trade
dominante di ogni sessione**. R96 misura il **momentum delle prime due barre M5
dopo la campanella**, non l'incrocio 9/21.

**Due conseguenze, e la seconda e' la piu' cara:**

1. Il **cancello proprio del round** (`R96_CRITERI.md` par. 4.2: *"se A e B hanno
   `Incroci Sessione` entro il ±10% l'ancora e' COSMETICA"*) **non puo' mordere**:
   in cella A il conteggio ha un pavimento strutturale (`Incroci >= Sessioni`)
   che in cella B non esiste. E' il **punto 40 visto dal lato dell'EA** invece
   che da quello della regex: li' il gate non mordeva per un `$` senza `\r?`, qui
   non morde per un'identita' algebrica del motore.
2. `R96_CRITERI.md` par. 6-bis autorizza **IN ANTICIPO** a *"chiudere il capitolo
   incrocio EMA 9/21 in questa casa"* se R96 esce senza edge. Sarebbe **chiudere
   un capitolo che il round non ha aperto**: nessun numero di R96 dice niente su
   9/21, perche' 9 e 21 non hanno mosso il segnale dominante.

> ✅ **REGOLA.** **Prima di scrivere i criteri, si fa l'algebra del parametro che
> da' il nome al round su un caso limite dell'EA (la prima barra, il seme, il
> primo tick, l'array vuoto): se in quel caso il parametro non cambia l'esito, il
> round NON puo' intitolarsi a lui.** Il nome del round e' una promessa su cosa
> verra' misurato, e un referto che conclude su un parametro inerte e' peggio di
> un referto sbagliato: **chiude una strada che nessuno ha percorso**.
> 🧪 **Il controllo pratico**: si prende il parametro del titolo, gli si dà due
> valori molto diversi (9/21 e 5/13) e si chiede *"il segnale della prima
> occorrenza cambia?"*. Se la risposta e' no, o si sposta il gate dove il
> parametro morde (qui: `InpMinBarreSessione`, che pero' i criteri stessi pinnano
> e vietano di spazzolare), o **si cambia il titolo e la conclusione ammessa**.
> 📏 **E la contromisura minima e' una COLONNA, non una frase** (punto 34):
> l'artefatto inerte si conta, cosi' il referto dice *quanti* trade vengono dal
> seme invece di dichiararlo a parole.

---

## 🆕 AGGIUNTA DEL 21/08/2026 — trovata verificando il PASSO 3 di R92 (dopo il ri-pin)

## 53. 🧟 IL RI-PIN NON RIPULISCE GLI ARTEFATTI DEL PIN SBAGLIATO (e la ripresa idempotente li fa passare per nuovi)

_Difetto vero, trovato PRIMA dell'invio, nella riga **corretta** del PASSO 3 di
R92 — cioe' nella riga scritta APPOSTA per riparare il difetto n.33
(`Risk_Percent=1.0` nella copia esecutiva) dopo il ri-pin a `bdaf360`._

La giornata del 21/08 ha pagato **due volte la stessa classe**: la mattina un
PASSO 0 pinnato a uno `scarica_storico.ps1` **senza** `AllowLiveTrading=false`;
il pomeriggio un PASSO 3/4 pinnato a uno `scan_market.ps1` che girava a rischio
**1,0%** contro lo **0,80% firmato**. In tutti e due i casi la riparazione e'
stata la stessa: **commit di fix + nuovo pin + guardia `Select-String` sul
marcatore**. Ed e' li' che si nasconde il terzo giro:

> **La guardia di versione guarda lo SCRIPT. I NUMERI sbagliati sono
> nell'ARTEFATTO, e l'artefatto e' rimasto sul disco.**

`scan_market.ps1` (riga 456) ha la ripresa, ed e' giusto che ce l'abbia:
```powershell
if(Test-Path $done){ Write-Host "gia' fatto, salto" -ForegroundColor DarkGray; continue }
```
Se in `%USERPROFILE%\r92\risultati_scan_ABTG_Bulge\` ci sono i CSV prodotti dal
pin **vecchio**, la riga nuova: scarica lo script giusto, **supera tutte e due le
guardie sul rischio**, stampa due righe grigie, **non lancia nemmeno una
passata** e lascia in piedi i numeri a 1,0%. Il controllo scritto nel documento
("devono esserci 2 file con 2 righe di dati ciascuno") **esce VERDE**. Il difetto
appena corretto rientra dalla finestra travestito da corsa riuscita.

Aggravante misurata: l'`.ini` viene scritto **dopo** il `Test-Path` (righe
457-497), quindi su un simbolo saltato resta l'`.ini` **vecchio** — e l'`.ini` e'
l'**unica prova cartacea** del rischio che finisce nello zip della raccolta. Il
referto direbbe `Risk_Percent=1.0` accanto a un CSV vecchio, e sarebbe l'unico
posto in cui la bugia si vede.

> **Regole, da applicare INSIEME ogni volta che si ri-pinna una riga dopo un fix
> che cambia i NUMERI (non la forma):**
> 1. **Si elencano gli ARTEFATTI che il pin sbagliato puo' aver gia' prodotto**
>    (CSV, `.ini`, per-trade, referti, cache) e la riga nuova **li cancella o si
>    ferma**. Un fix di rischio/soglia/finestra invalida i file, non solo lo
>    script.
> 2. **La cancellazione si VERIFICA** (punto 46: un file aperto in Excel non si
>    cancella e nessuno se ne accorge): dopo il `Remove-Item` con wildcard si
>    ricontano i file e si `throw` se ce n'e' ancora.
> 3. **Il gate finale sta sulla FRESCHEZZA, non sulla presenza**: `$t0=Get-Date`
>    prima di lanciare, e ogni artefatto atteso deve avere
>    `LastWriteTime -ge $t0`. E' l'unico controllo che regge anche quando la
>    cancellazione fallisce in silenzio.
> 4. **Quello che la riga NON puo' cancellare da sola lo DENUNCIA**: se restano
>    artefatti di ALTRI simboli/celle prodotti dal pin vecchio, il passo corto
>    (il banco) si ferma e lo dice, invece di lasciarli entrare nel passo lungo.
>    Mai una cancellazione a sorpresa di una corsa da ore: si chiede.

⚠️ **Corollario di lettura**: "il pin e' corretto" e "i numeri sono di questo
pin" sono **due affermazioni diverse**. La prima si dimostra con `git`, la
seconda solo con la **data** dell'artefatto.

### 53-bis. ⏱️ E QUANDO LA RIPRESA E' **VOLUTA**, LA FRESCHEZZA NON PUO' FARE DA GATE

_Limite della regola 3 qui sopra, misurato subito dopo, verificando il **PASSO 4**
di R92 (le 88 passate) — cioe' applicando il punto 53 al passo LUNGO invece che
al banco._

La regola 3 dice "`$t0=Get-Date` prima di lanciare, ogni artefatto atteso deve
avere `LastWriteTime -ge $t0`". Regge sul passo **corto**, dove tutto e' rifatto.
Sul passo **lungo** e' **falsa due volte**:
1. **GBPUSD e' gia' stato fatto al PASSO 3**: i suoi 2 CSV, 2 `.ini` e 4
   per-trade sono piu' vecchi di `$t0` **ed e' giusto cosi'** — la ripresa e' il
   motivo per cui il banco esiste. Un gate sulla freschezza li boccerebbe tutti;
2. **una corsa da ore si interrompe** (riavvio, MT5 toccato per sbaglio): al
   rilancio la ripresa di `scan_market.ps1` salta i simboli gia' fatti, che
   restano legittimamente vecchi.

> **Se la ripresa e' voluta, il discriminante non e' la DATA: e' il CONTENUTO
> dell'artefatto CARTACEO.** Qui l'`.ini` gemello di ogni CSV e' l'unico posto in
> cui il rischio e' scritto (lo dice il punto 53 stesso), quindi la coppia
> CSV -> `.ini` diventa la prova:
> ```powershell
> foreach($f in @(Get-ChildItem $res -Filter "scan_*.csv")){
>   $ip = Join-Path $ind ($f.BaseName + ".ini")     # <- stesso BaseName: CSV e ini si accoppiano per nome
>   if(Select-String -LiteralPath $ip -SimpleMatch -Pattern "Risk_Percent=0.8||0.8||0||0.8||N" -Quiet -EA SilentlyContinue){ $ripresi+=$f.Name } else { $stantii+=$f.Name }
> }
> if($stantii.Count -gt 0){ <stampa il comando di pulizia>; throw "CSV di un pin DIVERSO" }
> ```
> `.ini` mancante = classificato **stantio** (`Select-String` su un file che non
> c'e' con `-EA SilentlyContinue` restituisce `$false`: verificato, non dedotto).
> E la freschezza non si butta via, si **degrada a numero nel referto**: "CSV
> gia' presenti (ripresa): N / scritti da questa corsa: M". Un conteggio che
> Claudio legge, non un gate che boccia.

⚠️ **E gli artefatti SENZA gemello cartaceo vanno trattati a parte.** I per-trade
`abtg_trades_<EA>_<SIM>_<magic>_viola<EA|PINE>.csv` hanno nomi **deterministici**
(nessuna data dentro): un avanzo si sovrascrive **solo se quel simbolo rigira**.
Se il simbolo non produce CSV (storico assente) l'avanzo **sopravvive e viene
contato** negli 88. Regola: si cancellano prima i per-trade **ORFANI** — quelli
di un simbolo che **non ha nessun CSV** — e la cancellazione si verifica (punto
46). Gli altri si tengono: sono la ripresa.

⚠️ **Corollario sul conteggio atteso**: se un numero atteso e' scritto a mano
(`per-trade: attesi 88`) e la corsa ne produce meno **per una ragione vera** (un
simbolo senza storico), il gate va legato all'**invariante**, non alla costante:
`attesi = 2 x nCsv`. Il "88 col pieno" resta stampato accanto, come promemoria.
Un CSV mancante e' una **RISPOSTA** (simbolo senza storico), non un guasto: va in
una lista a parte e **non** fa `ESITO: FALLITO`, o il referto trasforma un dato
in un allarme.

---

## 🆕 AGGIUNTA DEL 22/08/2026 — trovata verificando `aggiorna_verifica_orb.ps1` (gemelli ORB)

## 54. 🧟‍♂️ LA COMPILAZIONE FALLITA IN PRODUZIONE NON E' UN NO-OP: lascia il `.ex5` VECCHIO che OPERA, sotto un `.mq5` NUOVO che MENTE

_Difetto vero, gia' committato in `aggiorna_verifica_orb.ps1` (0c0261f, righe
76-90), trovato PRIMA dell'invio della riga. Lo script scarica il `.mq5` v1.02
sopra il v1.00 del conto piccolo e compila — ma non installa
`ABTG_PausaGuardian.mqh` (punto 33-bis, gia' scritto il 21/08 e ripetuto qui)._

Il punto 33-bis copre l'`#include` mancante **nel tester**, dove il costo e' una
corsa persa. Questo e' lo stesso difetto **su un terminale LIVE**, e li' il
fallimento non e' neutro. Due cose che nessun altro punto dice:

1. **Il vecchio binario resta OPERATIVO.** Compilazione fallita = nessun `.ex5`
   nuovo, quindi al riavvio MT5 ricarica **il `.ex5` di prima** e il conto
   continua a operare con la versione vecchia — qui la v1.00 **senza nessuna
   integrazione Guardian**, cioe' senza pausa giornaliera e senza cap rischio.
   Un referto che stampa `compilazione: ERRORE` in rosso e' **corretto e
   insufficiente**: deve dire *quale versione sta girando ADESSO su quel conto*.
2. **Il sorgente nuovo accanto al binario vecchio avvelena la diagnosi
   successiva.** L'indagine del 22/08 ha stabilito cosa girava sui due conti
   **leggendo il `.mq5`** nella cartella dati. Se una compilazione fallita lascia
   li' il `.mq5` v1.02 sopra un `.ex5` v1.00, la prossima indagine legge v1.02 e
   conclude "sono allineati": il metodo di misura viene distrutto dalla riga che
   doveva sistemare le cose. E' il referto stantio del 17/08, con la vittima che
   e' lo **strumento di diagnosi**.

> **Una riga che ricompila un EA su un terminale che opera:**
> - installa **tutte** le dipendenze `#include` non di sistema (punto 33-bis),
>   dal pin, verificate per LUNGHEZZA e MARCATORE;
> - fa il **backup datato** di `.mq5` **e** di `.ex5` prima di toccarli (punto
>   12) — il `.ex5` vecchio e' l'unica prova di cosa stava girando davvero;
> - decide "compilato" confrontando il `LastWriteTime` del `.ex5` **prima e
>   dopo** (non "esiste" e non "e' recente": il file c'era gia');
> - se la compilazione FALLISCE, **rimette a posto il `.mq5` dal backup** e lo
>   dice: sorgente e binario devono restare la stessa versione, sempre;
> - stampa in chiaro `versione PRIMA -> versione DOPO` per ogni istanza, e in
>   caso di errore le ultime righe del log di MetaEditor (`/log:<file>`, che
>   nessuno leggeva) dentro lo zip della raccolta.

---

## 🆕 AGGIUNTA DEL 22/08/2026 — trovata verificando `verifica_autotest_guardian.ps1`

## 55. 🎯 IL GATE RIPARATO SUL FALSO POSITIVO CHE PERDE IL VERO POSITIVO

_Difetto vero, gia' committato in `backtest_pipeline/verifica_autotest_guardian.ps1`
(`2c435ca`, riga 214), trovato PRIMA che Claudio rilanciasse. Ed e' nato **da una
correzione giusta**: e' questo che lo rende una classe a se'._

Prima stesura (`be30db5`): `$_ -match "FAIL"`. Falso allarme misurato sul referto
del 22/08 — **12 "FAIL" tutti falsi**, perche' `-match` e' case-insensitive e i
NOMI dei casi contengono `fail-open` / `FAIL-OPEN`
(`ABTG_PausaGuardian.mqh`: _"cap timbrato 300 s fa (Guardian morto) -> libero,
FAIL-OPEN"_). Correzione, mezz'ora dopo:

```powershell
$fallite = @($righeAutotest | Where-Object { $_.TrimEnd() -cmatch 'FAIL$' })
```

**Quel `FAIL$` non matcha MAI.** Il verdetto lo stampa `ABTG_AutotestCaso()`
(righe 716-717) come `(ok ? "PASS" : "*** FAIL ***")`: una riga fallita
**finisce con `***`**, non con `FAIL`. Il gate e' passato da "sempre rosso a
sproposito" a **"non puo' piu' essere rosso"** — cioe' dal punto 47 al punto 14
in una riga sola, e il secondo stato e' molto peggiore: `exit 0`, zip verde sul
Desktop, e l'autotest del freno P1 poteva fallire tutti e 26 i casi senza che
nessuno lo vedesse. Su un freno del RISCHIO.

Il meccanismo generale: **si stringe un gate guardando l'esempio che sbagliava
(il falso positivo) e non l'esempio che deve prendere (il vero positivo)** — che
in quel momento non c'era sotto gli occhi, proprio perche' era tutto verde.

> ✅ **REGOLA. Quando si restringe un gate, lo si riprova su ENTRAMBI i campioni,
> e il campione POSITIVO si prende dal SORGENTE che lo produce, non dalla
> memoria.** Qui bastava aprire il `PrintFormat` che scrive la riga.
> ```powershell
> $fallite = @($righe | Where-Object { $_ -cmatch '\*\*\*\s*FAIL\s*\*\*\*' })
> ```
> 🧪 **E ogni gate "conta i cattivi" porta accanto il suo CONTROLLO POSITIVO che
> conta i buoni**, altrimenti "0 falliti" e "0 righe capite" sono indistinguibili:
> ```powershell
> $passate = @($righe | Where-Object { $_.TrimEnd() -cmatch 'PASS$' })
> if($passate.Count -eq 0){ throw "non ho riconosciuto NESSUN verdetto: il parser e' cieco, non l'autotest verde" }
> ```
> ⚠️ **Corollario di traffico**: una correzione pushata mentre la riga precedente
> e' gia' in mano a Claudio cambia lo script sotto ai piedi di chi lo sta
> verificando (qui: `be30db5` -> `2c435ca` a verifica in corso). E' l'ennesima
> ragione del punto 6: **la riga si pinna all'HASH**, e l'hash si rilegge dopo
> ogni push, non prima.

---

## 🆕 AGGIUNTE DEL 22/08/2026 — trovate verificando la riga R97 (ORB stop-largo su NASUSD)

## 56. 🚚 LA CARTELLA DI SOSTA CONDIVISA FRA GIRO A VUOTO E CORSA VERA: il documento prescrive il travaso, poi la raccolta lo mette nello zip del round

_Difetto vero, gia' committato in `backtest_pipeline/righe/RIGA_R97_ORB_NASUSD.ps1`
(`822a34a`), trovato PRIMA dell'invio a Claudio. Corretto in `85874e5`._

Il punto 41 dice: **l'artefatto di un gate si mette in sosta appena prodotto**,
cosi' esiste anche quando il gate esce rosso. Giusto, e R97 lo faceva. Il punto
41 pero' non dice **quando la sosta si SVUOTA**, e li' si e' aperto il buco.

La riga R97 usa una sola cartella `$Work\sosta` per tutto: gli `.ini` del PASSO
0, i per-trade del gate, il log del compilatore e — **solo nel giro a vuoto** —
le quattro `anteprima_r97*.ini`. La raccolta finale copia **in blocco tutto il
contenuto della sosta** nella cartella sul Desktop e nello zip.

Il documento della riga **prescrive** (giustamente) di fare **prima il giro a
vuoto e poi la corsa vera**. Quindi:

1. il giro a vuoto lascia in sosta 4 `anteprima_r97*.ini`;
2. la corsa vera **non le riproduce** (le anteprime le scrive solo
   `-SoloControllo`), quindi **non le sovrascrive**;
3. la raccolta della corsa vera le copia nello zip del round.

Risultato: **dentro lo zip del round finiscono quattro `.ini` che non hanno
girato**, con la finestra IS e `Model=4` scritto come costante — mescolati agli
`.ini` veri, con lo stesso prefisso, e indistinguibili senza guardare l'ora del
file. E' il referto stantio del 17/08, ma nascosto **dentro** l'unico zip che
Claudio guarda, e prodotto **dalla procedura corretta**, non da un errore
dell'operatore.

E' una classe a se' rispetto ai punti vicini: non e' il punto 50 (li' mente **il
referto**, qui il referto e' onesto e mentono gli **allegati**), non e' il punto
53 (li' e' il ri-pin, qui sono due MODI diversi dello stesso pin), non e' il
punto 31 (li' l'anteprima si sovrascriveva da sola, qui il problema e' che
**sopravvive**).

> ✅ **REGOLA. Ogni cartella di lavoro condivisa fra due MODI della stessa riga
> (giro a vuoto / corsa vera / ripresa) si SVUOTA all'inizio di ogni giro, e il
> conteggio si fa prima e dopo.** Non si perde niente: la sosta e' una copia di
> lavoro, l'archivio e' la cartella datata sul Desktop, che non si sovrascrive
> mai (punto 12).
> ```powershell
> $nSosta = @(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue).Count
> if($nSosta -gt 0){
>   Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
>   $nDopo = @(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue).Count
>   if($nDopo -gt 0){ [void]$Problemi.Add("sosta: $nDopo file di un giro PRECEDENTE non cancellati: possono finire nello zip spacciandosi per artefatti di adesso.") }
> }
> ```
> 🧪 **E la prova che serve al verificatore**: prendere l'elenco dei file che la
> raccolta copia e chiedersi, per ognuno, **quale MODO lo produce**. Un file che
> nasce solo in un modo e viene raccolto in tutti e' un file che mente.

### 56-bis. 🪆 LA SECONDA MISURA ANNIDATA NEL RAMO IN CUI LA PRIMA E' RIUSCITA: irraggiungibile proprio quando serve

_Stesso file, stesso commit, stessa correzione._

Il gate firmato di R97 chiede **due misure indipendenti** della conversione
punti-MT5/punto-indice: (1) la distanza dello stop letta dal log del tester,
(2) i decimali della colonna `price` del per-trade. La struttura era:

```powershell
if($letti -eq 0){ $Fatale = "zero log" }
elseif($fattori.Count -eq 0){ $Fatale = "nessuna riga capita" }
else{
    ... misura 1 ...
    if(Test-Path $ptA){ ... misura 2, il CONTROLLO ... }   # <-- QUI DENTRO
}
```

La misura di controllo **stava dentro il ramo "la misura 1 e' riuscita"**. Nei
due rami di fallimento — che sono esattamente i casi in cui il round si ferma —
**non veniva nemmeno tentata**, benche' il per-trade fosse gia' sul disco, in
sosta, e la risposta si leggesse in tre righe di codice a costo zero.

Il costo misurato di quel `{ }` : il referto della corsa fermata stampa
`digits = -1 -> fattore 0`, e il rilancio parte **alla cieca**, senza sapere se
il guasto e' "l'EA non ha piazzato ordini" (round da ripensare) o "il log non e'
stato letto" (rilancio identico con un'opzione diversa). **Un altro giro di
macchina per sapere una cosa che era gia' sul disco.**

Attenzione a non correggerlo dalla parte sbagliata: la misura di controllo
tirata fuori **non deve aprire il gate**. La firma chiede **due misure che
concordano**; una sola resta un `$Fatale`. Cambia il REFERTO, non il verdetto.

> ✅ **REGOLA. Una misura RIDONDANTE si esegue SEMPRE, fuori dai rami della
> misura primaria, e serve a DIAGNOSTICARE il fallimento, non a sostituirlo.**
> Se il codice la salta quando la primaria fallisce, non e' una ridondanza: e'
> una decorazione del caso felice.
> 🧭 **Come si trova**: per ogni "controllo incrociato" chiedersi *"in quale ramo
> vive, e quel ramo e' raggiungibile quando il controllo servirebbe?"*.

---

## 🆕 AGGIUNTA DEL 22/08/2026 (notte) — trovata verificando la riga R98 (A1 Intraday Momentum su NASUSD)

## 57. ✍️ IL CRITERIO **FIRMATO** CHE ASSEGNA UNA MISURA A UNO STRUMENTO CHE NON PUO' PRODURLA

_Difetto vero, gia' committato in
`backtest_pipeline/risultati_archivio/R98_CRITERI.md` (`5e19162`, par. 2.1 e la
riga "Stato del percorso" in fondo), trovato PRIMA dell'invio della riga._

Il punto 20 copre **il gesto chiesto a Claudio che non produce l'output**
(_"F7 compila e basta"_). Questo e' lo stesso meccanismo un piano piu' su, ed e'
peggio da maneggiare: **e' il DOCUMENTO FIRMATO a prescrivere lo strumento
sbagliato**, e un documento firmato non si corregge dopo — i criteri si cambiano
**prima** dei numeri, mai dopo.

R98, par. 2.1, sul canarino (n IS atteso ~180, **[INFERITO]**):

> _"E' un'inferenza, non una misura. **Va confermata con `-SoloControllo`** prima
> di leggere un solo risultato."_

**`-SoloControllo` non apre MT5.** Non esiste nessuna passata, nessun per-trade,
nessun `n`: puo' confermare gli **ARTEFATTI** (file prova, finestre, celle,
magic, `.ini`), **mai i NUMERI**. Il criterio, letto alla lettera, chiede a un
giro a vuoto una cosa che il giro a vuoto non puo' avere. Le due uscite
sbagliate, ed e' facile prenderle entrambe in buona fede:

- ❌ **fingere di eseguirlo**: si lancia `-SoloControllo`, esce verde, si scrive
  "canarino confermato" e si e' confermato **il nulla** (e' il gate decorativo
  del punto 14, con la firma sotto);
- ❌ **correggere il criterio**: si riapre un documento firmato **dopo** averlo
  firmato, che e' esattamente cio' che la regola di casa vieta.

> ✅ **REGOLA. Si DICHIARA una TRADUZIONE, e la si scrive in tre posti.**
> Non si tocca il criterio firmato e non si finge di eseguirlo: si dice
> **(1) perche' lo strumento prescritto non puo' farlo**, **(2) dove la misura
> viene fatta davvero**, **(3) che l'INTENTO e' conservato**. E la traduzione va
> ripetuta **nel driver, nel referto e nel documento della riga** — nel referto
> soprattutto, perche' e' l'unico dei tre che Claudio ha davanti quando legge i
> numeri.
>
> In R98 la traduzione buona era gia' li' e regge: il canarino lo misura il
> **PASSO 0** della corsa vera, contando le operazioni **per data** sul per-trade
> della passata singola — cioe' **prima** delle 32 passate della griglia e
> **prima** che si legga un solo risultato, che e' letteralmente cio' che il par.
> 2.1 chiede (_"prima di leggere un solo risultato"_). E **non blocca**, perche'
> il criterio stesso dice che sotto ~100 si applica l'Emendamento **regola B**
> (merito sospeso, rischio giudicato lo stesso).
>
> 🧭 **Come si verifica che una traduzione sia ONESTA — tre domande, tutte e tre:**
> 1. **conserva l'INTENTO?** (qui: "misurato prima di leggere i numeri" -> si')
> 2. **conserva il MOMENTO?** Una misura spostata *dopo* la decisione che doveva
>    informare non e' una traduzione, e' una rinuncia.
> 3. **conserva il COSTO?** Se la traduzione fa spendere le ore di macchina che
>    il criterio voleva risparmiare, va detto in chat **quante**.
>
> ⚠️ **E il giro a vuoto deve dirlo DA SOLO.** Il suo referto non puo' limitarsi
> a tacere sul numero mancante: deve scrivere che il canarino **NON e' stato
> misurato** e **dove** si misura, o al primo verde qualcuno lo scambiera' per la
> conferma del par. 2.1. In R98 la riga c'e' (`$Note` del ramo `-SoloControllo`),
> ed e' quella che rende la traduzione verificabile invece che dichiarata.

---

## 🆕 AGGIUNTA DEL 23/08/2026 — trovata verificando la riga R99 (oro su 22 anni, misura del RISCHIO)

## 58. 🔢 LA COLONNA LETTA CONTANDO DALLA FINE: la colonna FACOLTATIVA in fondo sposta tutto, e quello che esce e' un NUMERO PLAUSIBILE

_Difetto vero, gia' committato in `backtest_pipeline/righe/RIGA_R99_ORO_RISCHIO.ps1`
(`9ce568c`, funzione `LeggiDeal`), trovato **e RIPRODOTTO** prima dell'invio.
Corretto leggendo l'INTESTAZIONE._

Il punto 46-bis copre la colonna letta **per NOME** quando quel nome nel file non
c'e': PowerShell risponde `$null` e tira dritto. Questo e' il caso **peggiore
della stessa famiglia**, e va distinto proprio perche' il sintomo e' opposto:
la colonna e' letta **per POSIZIONE dalla fine**, e quando la tabella ha una
colonna facoltativa in coda **non esce `$null` — esce il valore della colonna
ACCANTO**, che e' un numero perfettamente formato.

R99 leggeva i deal del report `.htm` del tester cosi':

```powershell
$prof = NumInv $celle[$celle.Count-2]     # "il profitto e' il penultimo"
$sald = NumInv $celle[$celle.Count-1]     # "il saldo e' l'ultimo"
```

La tabella dei deal di MT5 ha in fondo una colonna **`Comment`/`Commento`**
(e questo EA ci scrive dentro `STREV OTT`). Con quella colonna presente:
`$prof` prende il **SALDO** (~100.000) e `$sald` prende il **commento** (`$null`).
La somma per giornata diventa una somma di **saldi**, sempre positiva; il minimo
partiva da un pavimento `$peggio = 0.0` e non scendeva mai.

**Misurato sui due campioni**: con la colonna commento la peggior giornata usciva
**`0,00%` con la data VUOTA**; senza, la stessa storia dava **`-3,52%`**. Cioe'
uno dei **tre numeri FIRMATI** del round, confrontato con un muro prop del **5%**,
sarebbe arrivato a Claudio come **verde pieno** — mentre i criteri dello stesso
round dicono, testualmente, _"un numero inventato dentro un verdetto firmato
sarebbe peggio di un numero mancante"_.

E il pavimento a zero e' la seconda meta' del difetto: **"non ho trovato nessuna
giornata perdente" e "la peggior giornata vale 0,00%" erano indistinguibili.**

> ✅ **REGOLA, tre pezzi.**
> 1. **Una colonna si individua leggendo l'INTESTAZIONE, mai contando le celle**
>    — e l'intestazione e' **LOCALIZZATA** (`Profit`/`Profitto`, `Balance`/`Saldo`:
>    il terminale di casa puo' essere in italiano).
> 2. **Se l'intestazione non si riconosce, si torna VUOTI**, e chi chiama scrive
>    `NON MISURATA`. Non si indovina la posizione: e' il controllo positivo del
>    punto 55 applicato alle colonne.
> 3. **Nessun accumulatore di minimo parte da un pavimento** (`0.0`): si parte da
>    `$null` e si prende il minimo VERO, cosi' "non trovato" e "trovato e vale
>    zero" restano due cose diverse.
>
> 🧪 **Come si prova, e va provato**: si costruiscono **due** report finti, con e
> senza la colonna in coda, e si guarda se il numero cambia. Se cambia, la
> lettura e' posizionale e va rifatta. Trenta secondi, e qui separavano un
> `-3,52%` da uno `0,00%` firmato.

---

## 🆕 AGGIUNTA DEL 23/08/2026 — trovata verificando la riga R100 (tutta la flotta oro su 22 anni)

## 59. 🔁 LA RIPRESA DICHIARATA CHE RIPRENDE SOLO LA PARTE ECONOMICA (e il documento promette che salta il resto)

_Difetto vero, gia' committato in `backtest_pipeline/righe/RIGA_R100_ORO_FLOTTA.ps1`
(`9fbe18d`, intestazione righe 90-93 e messaggio del tetto ore) e ripetuto in
`RIGA_R100_DA_MANDARE.md`. Trovato PRIMA dell'invio della riga. Corretto in
`adbc27c`._

Il punto 15 copre il **rilancio mirato che non rilancia niente**: la guardia di
idempotenza del gemello annulla il `-Solo D`. Questo e' **il rovescio, ed e'
peggio perche' costa ore invece di secondi**: la guardia di idempotenza c'e' e
funziona — ma copre **una frazione minuscola del lavoro**, mentre il commento
in testa allo script e il documento della riga promettono che salta **l'unita'
grossa**.

R100 scriveva, in tre posti:

> _"RIPRESA ATTIVA: una sedia con tutti i CSV gia' presenti viene SALTATA e
> DICHIARATA"_ · _"Rilancia: la ripresa salta le sedie gia' fatte"_ ·
> _"le sedie e le finestre gia' fatte vengono saltate e dichiarate"_

**Nel codice non esisteva nessun salto per sedia.** Il `Test-Path` di ripresa
stava **solo** dentro il ciclo delle sei finestre di regime. Il PASSO 0 — una
passata SINGOLA piu' due GEMELLE, **tutte e tre su 22 anni** — veniva rifatto
**per ogni sedia, a ogni lancio**.

**Il conto, e va fatto cosi': in DURATA SIMULATA, non in numero di passate.**
Per sedia: PASSO 0 = 3 x 22 anni = **66 anni-sedia**; le sei finestre
(10 mesi, 3 mesi, 12, 12, 6, 4, per due gemelle) = **7,8 anni-sedia**.
👉 **Il rilancio "che riprende" rifaceva il ~90% del lavoro e ne saltava il
~10%** — su un round stimato **2-6 ore**, con Claudio convinto di ripartire da
dove si era interrotto.

E la ragione per cui il salto per sedia **non si puo' semplicemente
aggiungere** e' la parte che rende questo punto una classe a se': il criterio B
(peggior giornata) si legge dal **report `.htm`**, che vive nella **sosta**, e
la sosta **si svuota a ogni giro** (punto 56). Una sedia "saltata" tornerebbe
**senza uno dei tre numeri firmati**. Cioe' le due contromisure — ripresa e
sosta pulita — **si contraddicono**, e il documento nascondeva la
contraddizione dichiarando una capacita' che non c'era.

> ✅ **REGOLA, tre pezzi.**
> 1. **"La ripresa e' attiva" non e' una frase: e' una TABELLA.** Per ogni
>    pezzo di lavoro si scrive **si rifa' / si salta**, e accanto **quanto
>    pesa** — in durata simulata, in passate, in minuti. Se il documento non
>    puo' riempire quella tabella, la ripresa non e' stata verificata.
> 2. **Il peso si misura sull'UNITA' CHE COSTA**, non sul conteggio degli
>    artefatti. "5 CSV su 7 gia' presenti" non vuol dire niente se i 2 mancanti
>    sono 22 anni e i 5 presenti sono tre mesi ciascuno.
> 3. **Se la ripresa vera non c'e', il documento dice quella che c'e'** — qui
>    `-SoloSedia <id>`, una sedia alla volta — e **avverte che ogni giro
>    produce uno zip suo, da mandare tutti**. Una ripresa dichiarata e assente
>    e' peggio di nessuna ripresa: senza, si sa di dover ricominciare.
>
> 🧭 **Come si trova, in trenta secondi**: si cerca la guardia di idempotenza
> (`Test-Path ... -and -not $Rifai`) e si guarda **in quale ciclo vive**. Se
> vive nel ciclo interno e la promessa parla del ciclo esterno, il difetto c'e'.

---

## 🆕 AGGIUNTE DEL 23/08/2026 — trovate verificando `archivia_test_desktop.ps1`

## 60. 🎭 IL PATTERN SCRITTO IN REGEX E CONFRONTATO CON `-like`: la whitelist sembra giusta e non prende NIENTE

_Difetto vero, gia' committato in `backtest_pipeline/archivia_test_desktop.ps1`
(`a4a6b75`, riga 51), trovato **e RIPRODOTTO** prima che la riga girasse._

Il punto 46 copre `-LiteralPath` su un percorso che contiene un wildcard: un
carattere speciale trattato come letterale. **Questo e' lo specchio**, ed e' piu'
insidioso perche' il pattern e' *bello da leggere*:

```powershell
$Pattern = @( 'R[0-9]+_*', ... )          # "le cartelle R97_, R100_, ..."
foreach ($pat in $Pattern) { if ($v.Name -like $pat) { ... } }
```

In `-like` **le parentesi quadre sono un set di UN carattere e il `+` e'
LETTERALE**. Quindi `'R[0-9]+_*'` matcha `R5+_qualcosa` e **non matcha mai**
`R97_...` ne' `R100_...`. Misurato:

```
R97_ORB_NASUSD_CORSA    -like 'R[0-9]+_*'  ->  False
R100_ORO_FLOTTA.zip     -like 'R[0-9]+_*'  ->  False
R5+_test                -like 'R[0-9]+_*'  ->  True
```

Il pattern PRINCIPALE della lista chiusa — quello delle cartelle di round, cioe'
il 90% del lavoro — era **inerte**. Lo script sarebbe girato, avrebbe stampato
tutto verde e archiviato **zero** cartelle di round: e' il gate decorativo del
punto 14, spostato dal codice d'uscita al MOTORE DI CONFRONTO.

E il difetto gemello, nello stesso file: la guardia anti-raddoppio del prefisso
(`if ($v.Name -match '^\d{4}-\d{2}-\d{2}_\d{4}_')`) era **CODICE MORTO** — un
nome gia' prefissato non supera nessun pattern della lista, quindi la guardia
non poteva scattare mai. Una guardia irraggiungibile e una guardia che funziona
si assomigliano molto, in lettura.

> ✅ **REGOLA. Un pattern si prova sui NOMI VERI, non si rilegge.** Tre righe:
> ```powershell
> foreach($n in @('R97_ORB','R100_ORO.zip','ROBA_mia')){ "{0,-20} {1}" -f $n,($n -match $rx) }
> ```
> E si sceglie il motore prima di scrivere il pattern: **`-like` per i wildcard
> di shell** (`*`, `?`), **`-match` con regex ancorata** (`'^R[0-9]+[_-]'`) per
> tutto cio' che ha classi, quantificatori o alternative. I due linguaggi si
> assomigliano abbastanza da ingannare, e `[0-9]` e' valido in ENTRAMBI con
> significati diversi: e' li' che si scivola.
> 🧪 **E ogni guardia va provata sull'esempio che dovrebbe FARLA SCATTARE**
> (punto 55): se non si riesce a costruire quell'esempio, la guardia e' morta.

## 61. ⏰ L'AUTOMATISMO A ORARIO FISSO ATTRAVERSA IL LAVORO DEGLI ALTRI (e la cartella "ferma" non lo e')

_Stesso file, stesso commit. L'attivita' pianificata sposta le cartelle dal
Desktop **ogni sera alle 23:30**._

Un'attivita' pianificata non e' un comando: e' un comando che parte **quando
capita**, cioe' anche in mezzo a tutto il resto. Due collisioni misurate, e
nessuna delle due si vede leggendo lo script da solo:

1. **Contro una corsa VIVA.** I round durano **2-6 ore** (R100) e scrivono la
   loro cartella **sul Desktop mentre girano**. Alle 23:30 l'archiviatore
   la sposta **sotto i piedi del driver**, che continua a scrivere su un
   percorso che non esiste piu' o se ne ricrea uno a meta'. Il round non
   fallisce in modo rumoroso: si **spezza in due cartelle**.
2. **Contro un altro automatismo.** `scarica_pagella.ps1 -Installa` scrive
   `Desktop\pagella_AAAA-MM-GG.txt` **alle 23:15**; la lista chiusa conteneva
   `'pagella_*'`. Quindici minuti dopo la pagella spariva dal Desktop — e
   `recupera_100k.ps1` (righe 44-46) la **cerca proprio li'**, quindi avrebbe
   detto "NIENTE TROVATO" in perfetta buona fede. Due automatismi di casa, uno
   che produce e uno che nasconde, **scritti a quattro giorni di distanza**.

E la contromisura ovvia — *"non toccare cio' che e' stato scritto da poco"* —
**non funziona se scritta nel modo ovvio**, ed e' la meta' che vale la pena
ricordare:

> ⚠️ **Il `LastWriteTime` di una CARTELLA non cambia quando si scrive dentro una
> SOTTOCARTELLA.** Cambia solo quando si aggiunge/toglie un figlio DIRETTO.

Verificato: cartella `round/` con `round/sub/csv.csv` appena scritto ->
`LastWriteTime` della radice **1,2 secondi piu' vecchio** del contenuto. Una
cartella di risultati in cui il driver sta versando CSV in `sub/` sembra
**ferma da ore**. Quindi la guardia di freschezza la lascia passare, **e il
prefisso data che le si mette davanti e' sbagliato** — cioe' salta proprio la
promessa per cui lo script esiste ("l'ordine alfabetico e' quello cronologico").

> ✅ **REGOLA, tre pezzi.**
> 1. **Prima di installare un'attivita' pianificata si elencano gli ALTRI
>    automatismi sulla stessa cartella e i loro ORARI**, e si dice chi produce e
>    chi consuma. Un artefatto che un altro script CERCA per percorso fisso non
>    entra in nessuna lista "sposta".
> 2. **Chi sposta roba mentre puo' esserci una corsa viva salta cio' che e'
>    fresco** (`-MinutiFermo`, default 30) e lo DICHIARA a schermo.
> 3. **L'eta' di una cartella e' il MASSIMO RICORSIVO dei suoi figli**, mai il
>    `LastWriteTime` della radice:
>    ```powershell
>    $t = $v.LastWriteTime
>    if($v.PSIsContainer){ foreach($f in @(Get-ChildItem -LiteralPath $v.FullName -Recurse -Force -EA SilentlyContinue)){ if($f.LastWriteTime -gt $t){ $t = $f.LastWriteTime } } }
>    ```

### 61-bis. 🗑️ E IL LOG DI UN GIRO VUOTO CHE COPRE IL LOG DEL GIRO CHE AVEVA MOSSO

Trovato **eseguendo** la correzione, non leggendola. Lo script e' rieseguibile e
scrive un log CSV `Origine,Destinazione` per poter fare `-Annulla` (punto 9).
Ma `-Annulla` prendeva **il log piu' RECENTE**, e il secondo lancio — quello che
non trova piu' niente da spostare, cioe' il caso NORMALE — ne scriveva uno
**vuoto**. Da quel momento `-Annulla` rispondeva `Rimessi a posto: 0` **per
sempre**, con tutti i file ancora spostati e nessun errore. La rete di sicurezza
si stacca da sola al primo rilancio innocuo.

> ✅ **Un log di ANNULLAMENTO si scrive solo se c'e' qualcosa da annullare, e
> chi lo rilegge cerca l'ultimo NON VUOTO.**
> ```powershell
> if($Righe.Count -gt 0){ $Righe | Export-Csv -LiteralPath $LogCsv -NoTypeInformation }
> ...
> $ultimo = Get-ChildItem $LogDir -Filter "archivio_*.csv" | Sort-Object LastWriteTime -Descending |
>           Where-Object { @(Import-Csv -LiteralPath $_.FullName).Count -gt 0 } | Select-Object -First 1
> ```
> E' la famiglia del punto 12 (il backup che si auto-distrugge al secondo
> lancio), col rilancio innocuo al posto di `-Force`.

## 62. 🧵 LA FUNZIONE CHE TORNA UNA LISTA DI UNO: `$lista[0]` diventa un CARATTERE

_Difetto vero introdotto **dalla correzione stessa** del punto 61 e trovato
**eseguendola** (mai spedito). E' la ragione per cui una simulazione vale piu'
di una rilettura._

```powershell
function Trova-Desktop { ...; return @($lista) }
$Desktops = Trova-Desktop          # <-- SBAGLIATO
$Principale = $Desktops[0]
```

PowerShell **srotola** una collezione di un solo elemento nell'elemento stesso:
con UN solo Desktop — **il caso normale** — `$Desktops` e' una **stringa**, e
`$Desktops[0]` non e' il percorso ma il suo **primo carattere**. Misurato:
l'archivio veniva creato in **`C\ARCHIVIO_TEST`**, un percorso RELATIVO alla
cartella corrente. E niente si accorge di niente: `$Desktops.Count` vale `1`
lo stesso e il `foreach` gira una volta sola, correttamente.

E' il cugino del punto 46-bis (la colonna letta con un nome che non c'e': PS
risponde `$null` e tira dritto): qui non risponde `$null`, risponde una cosa
**plausibile** — un carattere e' una stringa valida da dare a `Join-Path`.

> ✅ **REGOLA. `@()` sulla RICEZIONE, non solo sul `return`.**
> `$x = @(Funzione-Che-Torna-Lista)`. Il `@()` dentro la funzione non protegge
> niente: lo srotolamento avviene **all'uscita**.
> 🧭 **Dove si annida**: ogni `$roba[0]`, `$roba.Count -eq 1`, `Select-Object
> -First 1` su qualcosa che *"tanto ne trova sempre almeno due"*. Il caso a
> UNO e' quello che gira in produzione tutti i giorni.

---

## 🆕 AGGIUNTA DEL 23/08/2026 — trovata verificando la riga R101 (ablazione dei filtri su Dow e DAX)

## 63. 🧨 LA VIRGOLA A FINE RIGA DENTRO UN HASHTABLE: lo script non PARSA, e l'analisi statica non lo vede

_Difetto vero, gia' committato in `backtest_pipeline/righe/RIGA_R101_ABLAZIONE.ps1`
(`bdd77e9`, righe 306-324), trovato **e RIPRODOTTO** prima dell'invio della riga.
Corretto in `e4c1afa`._

```powershell
$VIVA = @{
 "DOW" = @(@("InpSessionHour","14"), ... ,@("InpSlippagePts","0")),   # <-- questa virgola
 "DAX" = @(@("InpSessionHour","8"),  ... ,@("InpSlippagePts","0"))
}
```

In PowerShell le voci di un hashtable letterale si separano con **una nuova riga
o un `;`**. Una **virgola a fine riga CONTINUA l'espressione**: il separatore di
riga viene mangiato, e il parser legge

```
"DOW" = @(...) , "DAX" = @(...)
```

cioe' un'**assegnazione a una stringa letterale**. Misurato con
`[System.Management.Automation.Language.Parser]::ParseFile`:

```
2 errori -- righe 306 e 315
"The assignment expression is not valid. The input to an assignment operator
 must be an object that is able to accept assignments, such as a variable..."
```

Riprodotto in isolamento su sei righe: **con la virgola 2 errori, senza 0.**

**Perche' e' una classe nuova e non "una svista".** E' un errore di **PARSE**,
non di runtime: su PS 5.1 il `.ps1` sarebbe morto **prima di eseguire una sola
riga**, quindi nessuna guardia interna dello script poteva intercettarlo — ne'
il gate dei criteri, ne' il gate della stella, ne' la raccolta. E soprattutto:

> ⚠️ **Nessun controllo per BILANCIAMENTO lo trova.** Le graffe, le tonde e le
> quadre erano **0/0/0**, le stringhe tutte chiuse, l'ASCII puro: il documento
> della riga certificava tutti e tre i controlli, ed erano tutti e tre **veri**.
> Il file era **lessicalmente perfetto e sintatticamente rotto.** Un tokenizer
> scritto per l'occasione non e' un parser.

**E la seconda meta', che e' quella che costa**: il preparatore aveva
**dichiarato** il buco (_"in questo ambiente non c'e' PowerShell, il `.ps1` non
e' mai stato parsato da un interprete vero"_) e aveva concluso _"per questo la
riga 1 e' il giro a vuoto"_. Dichiarare un buco **non e' chiuderlo**: il giro a
vuoto sarebbe tornato indietro in dieci secondi con un errore rosso, ma il pin
era gia' scritto nel documento, la riga gia' pronta da incollare, e il giro a
vuoto sarebbe diventato **il terzo giro a vuoto della serie del 17/08** — quelli
che questa checklist esiste per uccidere PRIMA dell'invio.

> ✅ **REGOLA, tre pezzi.**
> 1. **Il parse si FA, non si dichiara impossibile.** Se `pwsh` non c'e'
>    nell'ambiente, si **installa** (tarball ufficiale, due minuti):
>    ```bash
>    curl -sSL -o /tmp/pwsh.tar.gz https://github.com/PowerShell/PowerShell/releases/download/v7.4.6/powershell-7.4.6-linux-x64.tar.gz
>    mkdir -p /opt/pwsh && tar -xzf /tmp/pwsh.tar.gz -C /opt/pwsh && chmod +x /opt/pwsh/pwsh
>    ```
>    ```powershell
>    $e=$null; $t=$null
>    [void][System.Management.Automation.Language.Parser]::ParseFile($f,[ref]$t,[ref]$e)
>    if($e.Count){ $e | ForEach-Object { "riga $($_.Extent.StartLineNumber): $($_.Message)" }; throw 'NON PARSA' }
>    ```
>    E' la stessa regola del punto 17 (_"la presenza di un interprete e'
>    MISURATA o DICHIARATA MANCANTE"_) applicata **al verificatore invece che
>    allo script**: qui l'interprete mancante non fa fallire una corsa, fa
>    **passare per buono** un file rotto.
> 2. **Se il parse davvero non si puo' fare, la riga NON esce col pin scritto.**
>    Si consegna dicendo _"parse non fatto: il primo giro a vuoto E' il parse"_,
>    e il pin si scrive **dopo** che quel giro e' tornato verde.
> 3. **Dove si annida**: ogni tabella dati scritta a mano e allineata a colonne
>    — `@{...}`, `param(...)`, array di array multilinea. La virgola finale e'
>    innocua in un **array** (`@(1,2,`) e **letale** in un **hashtable**, e le
>    due cose si scrivono nella stessa riga. Grep di partenza:
>    ```
>    grep -nP '\),\s*$' <file>.ps1        # virgola a fine riga: e' dentro un @{ } ?
>    ```
>
> 🧪 **E dopo il parse, si ESEGUE quello che si puo' eseguire.** Sullo stesso
> R101 il verificatore ha girato i gate veri sui 20 file prova stubbando il
> download (`Invoke-WebRequest` -> `Copy-Item` dal repo locale) e ha provato il
> parser del CSV **sotto cultura it-IT** con un artefatto sintetico che aveva
> l'intestazione VERA dell'OPTFRAME: `1.27013` letto `1,27013` (non `127013`),
> colonne ignote -> `null`, una riga sola -> `NON VALIDO`. Un parse pulito dice
> solo che il file **si legge**; l'esecuzione dice che **fa quello che promette**.

## 64. I NUMERI NEGATIVI POSIZIONALI SONO STRINGHE, E "STRINGA -gt 0" MENTE SOLO SU WINDOWS (pagato il 23/08, corsa R101)

**Il fatto.** Nella corsa vera di R101 la famiglia DAX si e' fermata al gate
G0 con verdetto `NON RIPRODOTTO -- n OOS 270 contro -1 agli atti` — ma il
`-1` era il SENTINELLA "n non agli atti" e il gate sul n aveva la guardia
`if($fam.NAtti -gt 0 -and ...)` scritta apposta per saltarlo. Il metro DAX
aveva RIPRODOTTO PF e DD (1.397 vs 1.400 con tolleranza 0.01, DD 7.23
esatto): nove gradini non sono partiti per un confronto che non doveva
nemmeno esistere.

**Le DUE cause, tutte e due necessarie:**
1. **Un argomento posizionale `-1` a una funzione con parametri NON tipizzati
   arriva come STRINGA `"-1"`, non come intero.** `F "DAX" ... 7.23 -1 "..."`
   -> `$n` e' `[string]"-1"`. I positivi (`130`) arrivano interi; SOLO i
   negativi diventano stringhe.
2. **`"stringa" -gt 0` e' un confronto di STRINGHE culture-aware** (il RHS
   viene convertito a stringa, non il LHS a numero). E su .NET il risultato
   dipende dal SISTEMA: con NLS (Windows PowerShell 5.1, il PC di backtest)
   il trattino e' un carattere IGNORABILE al peso primario, quindi
   `"-1" -gt "0"` confronta `"1"` con `"0"` -> **VERO**. Con ICU
   (pwsh/Linux, dove gira il verificatore) -> **FALSO**.

**Perche' il verificatore non l'ha visto:** l'aveva eseguito davvero — su
pwsh/Linux, dove il difetto NON si manifesta. E' la prima classe di difetto
che passa un'esecuzione REALE del verificatore e cade solo sull'OS di
destinazione.

**Le regole:**
1. **Ogni parametro numerico di funzione si TIPIZZA** (`[int]$n`,
   `[double]$pf`): il tipo al parametro converte qualunque cosa arrivi.
2. **Ogni confronto con un sentinella numerico si CASTA sul posto**
   (`[int]$x -gt 0`), anche se "dovrebbe" essere gia' un numero.
3. **Grep di partenza** sui driver:
   `grep -nE '\$[A-Za-z.]+ -(gt|lt|ge|le|eq|ne) [0-9-]' file.ps1` — ogni
   hit dove il LHS puo' venire da un argomento posizionale, da un CSV o da
   una property non tipizzata e' un sospetto.
4. **Per il verificatore:** quando un confronto ha un LHS di tipo incerto,
   la prova non e' "l'ho eseguito e va": e' stampare
   `$x.GetType().Name` nel punto incriminato. Il tipo e' il fatto;
   l'esito del confronto su Linux non trasferisce a Windows.

## 65. L'ELENCO SENZA APICI NELLA RIGA DI CHAT: la virgola fa un ARRAY, e l'array diventa "a b c" (trovato PRIMA dell'invio, verificando R102 il 23/08)

_Riprodotto sul codice vero del driver: `& $p -SoloSedia C01,C02,C03` ->
`exit 1`, il blocco non parte._

In *argument mode* la virgola e' l'operatore di array: `-P a,b,c` passa
`@('a','b','c')`. Se il parametro e' `[string]`, il binder converte l'array
unendo con **`$OFS` (default: spazio)** -> `"a b c"`. Chi splitta su `,`
trova **un token solo**. Identico su PS 5.1 e 7: e' binding, non cultura,
non OS.

Aggravante di famiglia: se l'`exit 1` scatta **prima del `try`**, non nasce
nessuno zip, e la coda della riga che dice "lo zip esiste lo stesso:
mandalo" rimanda Claudio sullo zip del **blocco precedente**. E il giro a
vuoto non lo vede, perche' non passa quel parametro.

**Due pezzi.**
1. Nella riga: **ogni elenco va fra apici** — `-SoloSedia 'C01,C02,C03'`.
2. Nello script: chi riceve un elenco splitta su `'[,\s]+'`, non su `','`,
   cosi' tutte e due le forme funzionano.

**E la regola generale**: un parametro che il giro a vuoto **non passa**
non e' stato provato da nessuno. Se la corsa vera ha uno switch in piu',
si prova quello switch — anche solo mandando in secco il ramo di selezione.

E' il terzo membro della famiglia "PowerShell converte da solo e nessuno
se ne accorge" (62: la lista-di-uno che si srotola; 64: il negativo
posizionale che diventa stringa) — e l'unico che colpisce **la riga di
chat** invece dello script.

## 66. LA CONVENZIONE DI SENTINELLA APPLICATA A META' DELLE COLONNE (R103, 24/08 - il difetto stava a sei righe dal commento che lo vieta)

Il driver dichiarava, in un commento esplicito: "un numero NON MISURATO si
scrive n/d, non -1.00 ... nel referto sarebbe il peggior refuso possibile".
E poi: DD partiva da -1.0 (-> n/d, giusto), PF da **0.0** (-> "0.000", un
numero PLAUSIBILE che si legge "ha perso tutto"), e n veniva stampato
GREZZO (-> "-1").

**REGOLA**: una convenzione di sentinella si dichiara una volta e si
verifica su TUTTE le colonne - e il modo di verificarla costa zero: **si fa
girare il round su una sedia che NON produce numeri e si LEGGE la riga per
intero**. Rileggere il codice non basta: qui l'autore aveva scritto la
regola E il difetto nello stesso file. (Parente di 47 e 58, ma quelli
parlano di LEGGERE un numero plausibile; questo di SCRIVERLO.)

## 67. LA REGOLA SCRITTA DUE VOLTE NELLA PROSA E MAI IMPOSTA DAL CODICE (R103, 24/08 - -TickReali senza -SoloGruppo 'INDICI')

Gli artefatti dicevano DUE volte, a lettere chiare, "un OHLC e un tick
reale non devono nemmeno poter finire nella stessa tabella" - e il codice
li lasciava finire nello stesso zip, sotto un nome che dichiarava tick
reali per tutti.

**REGOLA**: quando un criterio dice "non devono nemmeno poter", quella
frase e' una SPECIFICA DI GUARDIA, non un avvertimento. Si cerca nel
codice l'if che la fa rispettare: se non c'e', la regola non esiste. Il
controllo da fare a ogni verifica: **elencare gli switch del driver e
provare le combinazioni che il DA_MANDARE non propone** - sono quelle che
nessuno ha mai eseguito.

## 68. IL VERDETTO BINARIO SENZA LO STATO "NON HO FATTO NIENTE" (25/08, ABTG_ChiudiSedie v1.00, preso PRIMA dell'invio)

Un esito calcolato su QUEL CHE RESTA (restaP==0 && restaO==0 -> PULITO)
non distingue "ho pulito" da "NON HO TROVATO NIENTE DA PULIRE". E il caso
"non trovo niente" e' il refuso piu' comune che esista: il SELETTORE
SBAGLIATO (un magic con una cifra storta). La v1.00 avrebbe stampato
ESITO: PULITO su una revisione mai cominciata, con la posizione orfana
della sedia vera ancora viva - l'incidente del 24/08 riprodotto dallo
strumento nato per impedirlo.

**REGOLA**: ogni verdetto calcolato sullo stato residuo deve avere un
TERZO STATO per "il selettore non ha corrisposto a nulla" - e se le cause
non sono distinguibili dal codice, si dicono TUTTE, non si sceglie la
piu' bella. (Parente di 66: la' la vittima era una colonna, qui la RIGA
DI VERDETTO che la riga di lancio dice di leggere.)

## 69. LA CANCELLAZIONE PREVENTIVA SPACCIATA PER CONTROLLO DI FRESCHEZZA (25/08, stessa verifica)

"Cancello l'artefatto vecchio, poi controllo che esista" SEMBRA piu'
forte del LastWriteTime prima/dopo (punto 54) - e lo e', FINCHE' LA
CANCELLAZIONE RIESCE. Fatta con -ErrorAction SilentlyContinue (28-bis)
degrada in silenzio a "esiste", cioe' al controllo che il punto 54 vieta
per nome: MT5/MetaEditor/antivirus tengono il file aperto, la Remove-Item
fallisce zitta, e il Test-Path trova l'artefatto VECCHIO stampando OK.

**REGOLA**: se cancelli prima, devi FALLIRE RUMOROSAMENTE se il file
sopravvive - e il timestamp lo verifichi LO STESSO. Vale per ogni
artefatto su una macchina dove il produttore e' vivo e tiene i file
aperti.

## 70. L'ELENCO ATTESO SCRITTO NELL'ORDINE DEL DOMINIO, STAMPATO DAL CODICE IN ORDINE ALFABETICO (R107, 25/08 - preso PRIMA dell'invio)

Il DA_MANDARE prometteva, fra le righe che Claudio deve confrontare a
schermo per dare il via libera alla corsa vera:

```
- in testa: `famiglie 3 (DOW, DAX, NAS)`, `celle 6 (di cui LONG: 3)`, ...
```

Il driver pero' costruisce quell'elenco cosi':

```powershell
$FamAttive = @($Lavori | ForEach-Object { $_.Fam } | Sort-Object -Unique)
...
Write-Host ("    famiglie ... " + $FamLavoro.Count + "   (" + ($FamAttive -join ", ") + ")")
```

`Sort-Object -Unique` **ordina**: a schermo esce `(DAX, DOW, NAS)`, non
`(DOW, DAX, NAS)`. L'ordine del DOMINIO (Dow per primo perche' e' il metro
e la riga di paragone del round) non e' l'ordine ALFABETICO, e nessuno dei
due e' sbagliato: e' il documento che promette il primo mentre il codice
stampa il secondo.

**Perche' e' una classe a se' e non il 40-quater.** Il 40-quater dice
_"ogni numero atteso si RICALCOLA con la formula dell'EA"_: li' il rimedio
e' rifare il conto. Qui non c'e' nessun conto da rifare — il valore e'
giusto, e' **l'ORDINE** a essere diverso, e l'unico modo di accorgersene e'
**ESEGUIRE il blocco che stampa e confrontare la stringa carattere per
carattere con quella scritta nel documento**. Rileggere il codice non
basta: `Sort-Object -Unique` si legge come "togli i doppioni" e il fatto
che ordini anche passa inosservato (e' lo stesso inganno del punto 62, dove
`-Unique` su una lista di uno srotolava una stringa).

**Il costo se passa**: Claudio confronta, vede due elenchi diversi, e
**ferma il round per un falso allarme** — oppure impara che gli attesi del
documento sono "circa", e allora il gesto del confronto non serve piu' a
niente. E' il danno del 40-quater (erosione della fiducia nei controlli)
per una causa diversa.

> ✅ **REGOLA**: ogni stringa che il documento chiede a Claudio di
> CONFRONTARE A SCHERMO va **prodotta eseguendo il codice che la stampa**,
> e incollata nel documento **dall'output**, mai riscritta a mano
> nell'ordine che sembra naturale. Sospetti di partenza in ogni driver:
> `Sort-Object`, `-Unique`, `Group-Object`, `Get-ChildItem` (che ordina per
> nome), le chiavi di un `@{}` (che in PowerShell **non** hanno ordine
> garantito: serve `[ordered]@{}`).

---

## 71. IL `.ps1` SENZA `[CmdletBinding()]` NON RIFIUTA I PARAMETRI CHE NON CONOSCE: il refuso in un interruttore diventa LA CORSA VERA (R108, 25/08 - preso PRIMA dell'invio, e RIPRODOTTO)

_Difetto vero, gia' committato in `RIGA_R108_BB_M15.ps1` (3d5a3a8) e, alla
verifica, in **tutti e dodici** i driver di round del repo: `grep -c
CmdletBinding` su `RIGA_R95` ... `RIGA_R108` dava **0 su 12**._

Uno script con il solo blocco `param(...)` — cioe' la forma che usiamo
sempre — **non fa binding stretto**: un parametro con un nome che non
esiste non e' un errore, finisce in `$args` e lo script **prosegue in
silenzio**. Riprodotto su uno script-sonda:

```
& ./sonda.ps1 -Pin 'X' -Riprendi
   ->  Pin=X SoloControllo=False args=[-Riprendi]      # uscita 0
```

Nessun rosso, nessun avviso. Il punto 14 dice che una guardia puo' essere
decorativa; questo e' peggio, perche' **non c'e' proprio nessuna guardia da
guardare**: il refuso non viene MAI segnalato, ne' da PowerShell ne' dallo
script.

**Il costo se passa, misurato su R108.** La riga del giro a vuoto e'
`& $p -Pin $pin -SoloControllo`. Con **una L sola** — `-SoloControlo` —
`$SoloControllo` resta `$false` e quella non e' piu' l'anteprima da un
minuto: e' **la corsa vera**, 18 passate a **tick reali** su 4 anni di M15,
partita credendo di fare il controllo. Stessa famiglia: `-ScreenOhlcM1`
invece di `-ScreenOhlcM15` (lo screen veloce diventa il round lungo),
`-SoloSimbol 'GBPUSD'` (un simbolo diventa tutti e tre), `-CriteriFirmat`
(che pero' fallisce in modo BUONO: exit 2). E' esattamente il rovescio del
punto 65: li' l'elenco senza apici arrivava **storto**, qui il parametro
non arriva **per niente**.

E non e' un caso raro: i nomi degli interruttori sono lunghi, italiani e
somiglianti fra loro (`-SoloControllo` / `-SoloCella` / `-SoloSimbolo`), e
Claudio li ribatte a mano quando riprende una corsa.

> ✅ **REGOLA**: ogni `.ps1` che si detta a Claudio si apre con
> **`[CmdletBinding()]` sopra `param(`**. Costa una riga e trasforma ogni
> nome di parametro sbagliato in un **errore di binding terminante**, prima
> che lo script tocchi MT5:
> ```powershell
> [CmdletBinding()]
> param([string]$Pin = "", [switch]$SoloControllo, ...)
> ```
> Verificato eseguendo, sullo stesso script: con `[CmdletBinding()]`
> `-SoloControlo` da' *"A parameter cannot be found that matches parameter
> name 'SoloControlo'"* e **muore**.
> Prerequisito: lo script **non deve usare `$args`** (con `[CmdletBinding()]`
> non e' piu' disponibile) — si controlla con un grep prima di aggiungerlo.
> ⚠️ **E' un difetto di FAMIGLIA**: quando lo si corregge in un driver, si
> fa il giro degli altri (punto 2). Il 25/08 e' stato corretto in R108;
> gli altri undici restano esposti, ed e' dichiarato.

---

## 72. IL GATE DIFFERENZIALE NON PUO' VEDERE LA CORRUZIONE SIMMETRICA: si confronta col GEMELLO, mai con l'ANTENATO (R108, 25/08 - preso PRIMA dell'invio, e RIPRODOTTO)

_Difetto vero, gia' committato in `RIGA_R108_BB_M15.ps1` (3d5a3a8), trovato
facendo girare il driver su una copia CORROTTA del repo._

Un round che misura **una variabile sola** costruisce due celle che devono
differire su quella e su nient'altro, e ci mette sopra un gate: in R108 e'
il **gate della stella** — _"la cella M15 differisce dalla sua cella metro
esattamente su `InpTF` (+ `InpMagic`)"_. E' un gate ottimo, e nella verifica
ha preso **16 corruzioni su 17**.

Quella che non prende e' la **corruzione SIMMETRICA**: la stessa riga
storta in **tutte e due** le celle. Riprodotto — `InpBBPeriod` portato da
20 a 25 nel file metro **e** nel file M15 di GBPUSD:

```
stella: verde      valori: verdi      asse unico: verde      magic: verdi
ESITO: GIRO A VUOTO COMPLETATO                                 uscita 0
```

**Ed e' ovvio a posteriori e invisibile a priori**: un diff fra A e B non
puo' accorgersi di niente che sia uguale in A e in B. Restavano scoperti
**64 dei 70 input** — tutti tranne i sei che qualche altro gate pinna per
valore (`InpTF`, `InpPatternMode`, `InpMinRR`, `InpMinTPatATR`, `InpTPMode`,
`InpMaxPositions`...).

**Perche' non basta dire "tanto poi lo prende il gate a valle".** In R108 lo
prendeva **G0**, che confronta i numeri della cella metro con quelli agli
atti di R103 — ma **tre passate piu' tardi**, e col messaggio sbagliato:
G0 dice _"il metro non si riproduce"_, cioe' **"il banco e' storto"**,
quando il fatto vero e' **"il file e' storto"**. Su un round dove il metro
esiste apposta per riprodurre un round precedente, quella diagnosi manda a
cercare il guasto nella parte sana.

> ✅ **REGOLA**: quando una cella e' dichiarata **COPIATA** da un artefatto
> che gia' esiste in repo (la cella viva di un round precedente, un preset
> congelato, un `.set`), il gate non puo' fermarsi al confronto **fra le
> celle nuove**: si scarica **l'ANTENATO al pin** e si confronta la cella
> con lui, dichiarando in una lista **i soli delta ammessi** (in R108:
> `InpMagic`, `InpComment`, `InpNewsCurrencies`). Cosi' la frase _"il blocco
> input e' copiato riga per riga da X"_, che oggi sta solo nel commento in
> testa al file prova, diventa **un controllo**.
> ⚠️ **Il confronto si fa PER NOME, non per posizione**: l'antenato puo'
> avere una riga in piu' o in meno (in R108 ne ha una: `InpNewsCurrencies`),
> e un confronto posizionale sfasa tutto il resto e accusa quaranta righe
> sane — e' il punto 58 (la colonna contata dalla fine) applicato alle righe.
> Provato: 8 corruzioni simmetriche su 8 fermate, e i file sani ripassano.

---

## 🆕 AGGIUNTE DEL 25/08/2026 — trovate verificando RIGA_STORICO_INDICI (storico lungo degli indici)

## 73. ➕ IL `+` DENTRO UN `@(...)` CON LE VIRGOLE: la virgola lega piu' stretto, e l'array diventa **UNA RIGA SOLA**

_Difetto vero, gia' committato in `RIGA_STORICO_INDICI.ps1` (bcc483f, righe
1058-1064 e 885-886), trovato PRIMA dell'invio e **RIPRODOTTO ESEGUENDO**._

In PowerShell la **virgola ha precedenza piu' alta del `+`**. Quindi questo:

```powershell
Set-Content $set -Value @(
  "InpSimboli=" + ($chiesti -join ","),
  "InpTF=M15,H1",
  "InpFileCsv=ABTG_ContaBarreEXT.csv",
  "InpAutoTest=false")
```

non e' un array di quattro righe: e' `"InpSimboli=" + (array di tutto il
resto)`, cioe' **UNA stringa sola**. Eseguito, il `.set` usciva cosi':

```
[InpSimboli=NASUSD_EXT InpTF=M15,H1 InpFileCsv=ABTG_ContaBarreEXT.csv InpAttesaSec=30 InpTettoAtteso=100000 InpAutoTest=false]
righe: 1
```

**Il costo se passa**: MT5 carica quel preset, `InpSimboli` diventa quella
frase intera, `SymbolExist()` fallisce, il referto della verifica esce
`SIMBOLO NON ESISTE` — e tutti e cinque gli altri input restano **all'ultimo
valore usato a mano** (punto 25). Cioe' una serata a cercare un import che era
andato benissimo. Stessa riga, stessa sera, la variante innocua: l'anteprima
del CSV con intestazione, numero di barre e anni **appiccicati sulla stessa
riga**.

> ✅ **REGOLA**: dentro un `@(...)` **ogni elemento che contiene un `+` va fra
> parentesi sue** — `@(("a: " + $x), ("b: " + $y))` — oppure si costruisce
> l'array con `$righe += (...)` una riga per volta (che e' anche l'unica forma
> che si legge bene in un diff).
> ⚠️ **E non si vede rileggendo**: la riga sbagliata e quella giusta sono
> identiche a meno di due parentesi. Si vede **solo eseguendo e guardando
> l'artefatto**: `Get-Content $set | %{ "[" + $_ + "]" }` e si contano le
> righe. Ogni file di parametri generato da uno script si stampa cosi' almeno
> una volta. Parente di 63 (la virgola di troppo in un hashtable) e di 65
> (l'elenco senza apici in chat): la famiglia e' **"la punteggiatura di
> PowerShell che cambia il TIPO di quello che hai scritto"**.

## 74. 🧠 LA RAM DELLA FASE BATCH E' UN CANCELLO COME LO SPAZIO DISCO — e si misura PRIMA, sul parser vero

_Trovato il 25/08 verificando la conversione a 16 anni di `histdata_m1.py`.
Il costruttore aveva scritto "stimo ~1 GB, non so misurarlo da qui": **si
misurava**, e il numero vero era **quasi il quadruplo**._

`--converti` tiene tutte le barre del simbolo in un dizionario prima di
scrivere il CSV. Misurato eseguendo il **suo** parser (`leggi_righe_histdata`)
su 400.000 barre vere e leggendo l'RSS: **~690 byte per barra**.

| finestra | barre | RAM |
|---|---:|---:|
| 2019-2026, la corsa **gia' girata** il 18/08 | 2,5 M | ~1,7 GB |
| 2010-2026, quella nuova | 5,6 M | **~3,8 GB** |

**Dove fa male**: il `MemoryError` non arriva all'inizio, arriva **in fondo**,
dopo che lo scarico e' finito — la parte lunga — e su un PC con MT5 aperto
prima ancora arriva lo swap. E' il difetto 19 (la durata stimata contro il
timeout) applicato alla MEMORIA invece che al tempo.

> ✅ **REGOLA, in tre pezzi**:
> 1. **si misura**: si fa girare la funzione vera dello strumento su un
>    campione (10^5 righe basta) e si legge l'RSS. Costa un minuto e
>    trasforma un "stimo ~1 GB" in un numero.
> 2. **si spezza NEL MODO IN CUI LO STRUMENTO FILTRA DAVVERO.** Qui
>    `--converti` **ignora `--da/--a`** e ingerisce tutti gli zip **della
>    cartella**: spezzare per intervallo avrebbe prodotto CSV cumulativi e la
>    concatenazione un file **pieno di duplicati, grosso e plausibile**.
>    Spezzare per **cartella** e' esatto. **Prima di spezzare si legge come il
>    filtro e' implementato**, non come si chiama l'opzione.
> 3. **il pezzo si DICHIARA nel referto**: un artefatto nato da tre passate
>    non e' lo stesso artefatto nato da una, e chi lo usera' fra un mese deve
>    saperlo dal file, non dalla chat.
> ⚠️ E la taglia della tranche non si sceglie a occhio: si prende **quella che
> quella macchina ha gia' retto** (qui 2,5 M barre, 18/08).

## 75. 🔤 `FileWrite` SU UN HANDLE `FILE_CSV` NON METTE GLI APICI: una virgola nel testo sposta le colonne, e chi legge **TRONCA senza errore**

_Difetto vero, gia' committato in `ABTG_ContaBarreEXT.mq5` (bcc483f, righe 191
e 276), trovato PRIMA dell'invio e **RIPRODOTTO**._

MQL5 scrive i campi cosi' come sono. La colonna diagnostica piu' importante
dello script era:

```
SIMBOLO NON ESISTE (import non fatto, o MT5 chiuso male dopo l'import)
```

Con `Import-Csv` dall'altra parte, quel campo diventa **due colonne**, la
seconda non ha intestazione e **viene buttata via in silenzio**. Provato:

```
ESITO LETTO: [SIMBOLO NON ESISTE (import non fatto]
```

Nessun errore, nessun avviso: solo la meta' della frase che spiegava **cosa
fare**. Ed e' sempre la riga peggiore a perderci, perche' le frasi lunghe (con
le virgole) sono quelle dei casi anomali.

> ✅ **REGOLA**: in un CSV a virgole prodotto da MQL5, **nessun campo di testo
> puo' contenere una virgola** — si scrive con `;` o con ` - `, e ci si mette
> una funzione di rete (`StringReplace(t,",",";")`) sull'ultima colonna, quella
> libera. Vale al contrario per chi legge: se una colonna di testo arriva
> tronca a meta' frase, **non e' il testo ad essere corto, sono le colonne ad
> essere scivolate** (e' il punto 58 visto dal lato di chi SCRIVE).

---

## 🆕 AGGIUNTE DEL 25/08/2026 — trovate verificando R109 (`RIGA_R109_ATREXH.ps1`), tutte e tre **ESEGUENDO**

## 76. 🫥 LA VARIABILE DEL `foreach` SOPRAVVIVE AL CICLO, E VENT'ANNI DOPO UNA STRINGA IN APICI DOPPI SE LA MANGIA

_Difetto vero, gia' committato in `RIGA_R109_ATREXH.ps1` (298ac2c, riga 2143),
trovato PRIMA dell'invio e **RIPRODOTTO**. Rileggere il codice NON bastava: il
difetto si e' visto solo aprendo il referto che la riga aveva appena scritto._

La coda del referto voleva **mostrare** un pezzo di comando:

```powershell
[void]$R.Add("      Una riga '& $p ...' incollata da sola riusa la copia locale")
```

`$p` doveva essere **testo**, il path dello script scaricato dal blocco della
chat. Ma e' in **apici DOPPI**, quindi PowerShell lo espande — e nello script
`$p` **esiste**: e' la variabile del ciclo dei problemi, venti righe piu' su.

```powershell
foreach($p in $Problemi){ [void]$R.Add("  - " + $p) }
```

⚠️ **In PowerShell la variabile di un `foreach` NON muore col ciclo**: resta
in scope, e vale **l'ULTIMO elemento**. Riprodotto:

```
PRIMA (apici doppi): Una riga '& SECONDO: un problema lungo che finirebbe dentro la frase ...' incollata da sola
DOPO  (apici sing.): Una riga '& $p ...' incollata da sola
```

Le due facce sono **tutte e due cattive** e si alternano da sole:
- **zero problemi** -> `$p` e' vuota, e la frase esce mozza: `Una riga '&  ...'`;
- **almeno un problema** -> nel mezzo della frase ci finisce **un paragrafo
  intero**, e sembra un guasto del referto proprio nella corsa andata male.

E' il difetto di quoting piu' banale che esista (`$` dentro apici doppi) con
un'aggravante che lo rende invisibile: di solito una variabile inesistente
espande a **vuoto** e qualcuno se ne accorge; qui esisteva, e diceva
un'altra cosa.

> ✅ **REGOLA**: **una stringa che deve MOSTRARE del codice si scrive in apici
> SINGOLI.** Sempre, anche quando "tanto quella variabile non c'e'".
> E il controllo si fa **ESEGUENDO e leggendo l'artefatto**, non rileggendo il
> sorgente: sul sorgente `"... $p ..."` si legge come si voleva scriverlo.
> Grep di partenza su ogni driver, prima di mandare:
> `grep -n '"[^"]*\$[a-z]' <file>.ps1` e, per le variabili di ciclo,
> l'elenco dei `foreach(` e dei `ForEach-Object { param($x)` gia' usati nel file.

## 77. ♻️ LA RICETTA DEL PIN CHE RISCRIVE SE STESSA (e il suo stesso controllo)

_Difetto vero, gia' committato in `RIGA_R109_DA_MANDARE.md` (b26ba67), trovato
PRIMA dell'invio e **RIPRODOTTO due volte** (la prima correzione era ancora
sbagliata)._

Ogni foglio `*_DA_MANDARE.md` ha in fondo la ricetta che sostituisce il
segnaposto col commit vero. Era scritta cosi':

```bash
sed -i "s/@@PIN@@/$SHA/g" backtest_pipeline/righe/RIGA_R109_DA_MANDARE.md
grep -c "@@PIN@@" backtest_pipeline/righe/RIGA_R109_DA_MANDARE.md   # DEVE dare 0
```

Il `/g` su **tutta la pagina** non tocca solo i tre blocchi di lancio: tocca
anche **la riga del `sed`, la riga del `grep` e la prosa che spiega cos'e' il
segnaposto**. Dopo il primo pin la pagina dice `<sha> e' un segnaposto e va
sostituito`, e **la ricetta e' morta**: alla prossima ri-pinnatura — che
succede sul serio, il 25/08 e' successo sullo storico indici, dove `826f008`
non conteneva l'ultima correzione del driver — cerca un token che non c'e'
piu' e **non sostituisce niente, uscendo 0**.

⚠️ E la trappola ha un secondo giro: la prima correzione, che restringeva il
`sed` ai soli punti d'uso (`s|\$pin='@@PIN@@'|...|`), **conteneva a sua volta
il token per esteso** e si riscriveva lo stesso. Misurato: il controllo
`grep -c` dava **5** invece di **3**.

> ✅ **REGOLA, in tre pezzi:**
> 1. **il token si COMPONE in una variabile**, cosi' la ricetta non contiene
>    mai la stringa che sta cercando: `TOK='@@PIN'"@@"`;
> 2. **si sostituiscono i PUNTI D'USO, non la pagina** (`s|\$pin='$TOK'|...|g`
>    piu' la riga del riquadro, `s|^$TOK\$|$SHA|`): la prosa che spiega deve
>    restare leggibile anche dopo;
> 3. **DUE conteggi, non uno**: `grep -c "\$pin='$SHA'"` **deve dare 3** e
>    `grep -c "\$pin='$TOK'"` **deve dare 0**. Il solo "0 segnaposto rimasti"
>    lo supera a mani basse anche un `sed` che **non ha matchato niente** —
>    e' il guardiano decorativo del punto 14 applicato a un `sed`.
> 4. e la pagina porta anche la ricetta di **RI-PINNATURA** (vecchio -> nuovo,
>    con i due conteggi), perche' il pin si rifa' piu' spesso di quanto si creda.
>
> 🧪 **Si prova su una COPIA della pagina prima di scriverla nel foglio.** Costa
> dieci secondi e questa e' stata sbagliata due volte di fila.

### 77-bis. 🧟 E LA RI-PINNATURA CHE RISCRIVE LA **STORIA** (sbagliata dallo stesso verificatore, la sera stessa)

_Aggiunto il 25/08 dopo averlo **eseguito**: la ricetta di ri-pinnatura scritta
poche ore prima -- quella che doveva rimediare al difetto qui sopra -- era
sbagliata a sua volta._

Quando il pin va rifatto (e va rifatto: il 25/08 **due volte**, `826f008` sullo
storico indici e `cf6126d` su R109), il segnaposto non c'e' piu' e si sostituisce
il **pin vecchio**. La ricetta diceva:

```bash
VECCHIO=<il pin scritto adesso nella pagina>
sed -i "s|$VECCHIO|$NUOVO|g" "$F"
grep -c "$NUOVO" "$F"     # DEVE dare 4
```

Due difetti, e il secondo e' quello cattivo:

1. **`<il pin scritto adesso nella pagina>` e' ambiguo.** In pagina i pin
   compaiono anche **ABBREVIATI**: un `grep -o 'cf6126d[0-9a-f]*' | head -1`
   pesca il `cf6126d` a **sette** caratteri della prosa, non lo SHA a 40.
2. ☠️ **Un `sed` largo riscrive la MEMORIA.** La pagina conteneva la riga
   _"il pin `cf6126d` e' BRUCIATO -- non lanciare niente con quello"_ e la
   tabella dei difetti che spiega **perche'**. Misurato: la sostituzione larga
   prendeva **6 occorrenze invece di 4**, e la pagina finiva per dire
   **"il pin `<quello NUOVO>` e' BRUCIATO"** — cioe' l'esatto contrario del
   vero, sulla riga piu' importante della pagina.

> ✅ **REGOLA**: **il pin vecchio si legge DAI PUNTI D'USO, e si sostituisce solo
> li'.** Le menzioni in prosa di un pin sono **storia** (perche' e' stato
> bruciato, cosa conteneva): **non si toccano mai**.
> ```bash
> VECCHIO=$(grep -oE "\\\$pin='[0-9a-f]{40}'" "$F" | head -1 | grep -oE '[0-9a-f]{40}')
> sed -i "s|\$pin='$VECCHIO'|\$pin='$NUOVO'|g; s|^$VECCHIO\$|$NUOVO|" "$F"
> grep -c "\$pin='$NUOVO'" "$F"     # DEVE dare 3
> grep -c "\$pin='$VECCHIO'" "$F"   # DEVE dare 0
> ```
> ⚠️ E il conteggio atteso **cambia** fra la prima pinnatura e le successive
> (perche' la pagina intanto si e' riempita di storia): si **riconta sulla
> pagina vera**, non si copia il numero dalla volta prima.

## 78. 🗓️ L'ARTEFATTO CHE PORTA DELLE DATE MA NON PORTA **LA PROPRIA**: l'eta' si misura su un numero che non e' quello

_Difetto vero, gia' committato in `RIGA_R109_ATREXH.ps1` (298ac2c, righe
1261-1268) **e promesso nei criteri firmandi** (`R109_CRITERI.md` §4.2:
"sopra i 30 giorni esce un rilievo anche se il file c'e'"). Trovato PRIMA
dell'invio, sul file vero._

Il punto 23 dice: **chi consuma un artefatto ne guarda l'ETA', non solo
l'esistenza**, e propone `LastWriteTime`. Qui il punto 23 era stato letto,
applicato... e **tutte e due le strade mentivano**:

1. il `LastWriteTime` e' quello del file **scaricato al pin adesso**: dice
   sempre *"oggi"*, qualunque sia l'eta' della misura. Non e' un controllo, e'
   un timbro;
2. il driver allora ripiegava sulla **prima data DENTRO il CSV**:
   ```powershell
   $dm = [regex]::Match((Get-Content $tk -Raw),'(\d{4}\.\d{2}\.\d{2})')
   if($dm.Success){ $s.TickData = $dm.Groups[1].Value + " (prima data nel CSV)" }
   ```
   ma `misura_tick_U30USD.csv` contiene `2024.09.26` — che e' **l'inizio dello
   STORICO DEL BROKER**, non il giorno in cui la sonda ha girato. La misura era
   del **2026-08-20**, cioe' di **sei giorni prima**.

Il referto stampava `[file: 2024.09.26]` accanto a una misura fresca: **un
falso allarme garantito**, di quelli che fermano un round da otto ore (punto
44). E il rilievo dei 30 giorni **promesso nei criteri non esisteva proprio**
(punto 57: il criterio firmato che assegna una misura a uno strumento che non
puo' produrla).

La data vera stava, e sta, **solo nel referto gemello**
`REFERTO_MISURA_TICK_U30USD.txt`, riga `data: 2026-08-20 19:53:55`.

> ✅ **REGOLA**: **la data di un artefatto non e' una data QUALSIASI trovata
> dentro l'artefatto.** Prima di misurare l'eta' di qualcosa si risponde a
> due domande, per iscritto:
> 1. **questo file contiene la propria data di produzione?** Aprirlo e
>    guardarlo. Molti CSV di misura contengono le date del **dominio**
>    (inizio storico, prima operazione) e nessuna data di **produzione**;
> 2. **se no, chi ce l'ha?** Di solito il `.txt`/`.md` gemello scritto dallo
>    stesso strumento. **Si scarica anche quello, al pin, e finisce nello zip.**
>
> E se il gemello non c'e', **si dichiara che il controllo dell'eta' NON e'
> stato fatto** — non lo si da' per superato (28-bis, il verde per assenza).
> ⚠️ Corollario per chi SCRIVE uno strumento di misura: **ogni artefatto porta
> dentro la propria riga `data:`**, CSV compresi. Il gemello e' una toppa.

---

## 🆕 AGGIUNTA DEL 25/08/2026 — **il primo difetto di questa serie arrivato fino al PC di Claudio**

## 79. 🔠 LE VARIABILI DI POWERSHELL SONO **CASE-INSENSITIVE**: `$a` di un ciclo distrugge `$A` della configurazione, e il giro a vuoto esce **0**

_Difetto vero, **girato sul PC di Claudio** (giro a vuoto R109 delle 21:48,
zip `R109_ATREXH_CONTROLLO_20260825_2148`, pin `cf6126d`), trovato da Claudio
leggendo gli `.ini` dello zip — **non** dal verificatore, che aveva provato le
fabbriche `.ini` in isolamento. **Riprodotto**, e ce n'erano **DUE** nello
stesso file._

`RIGA_R109_ATREXH.ps1` dichiarava la finestra del round con due nomi corti:

```powershell
$Da = "2024.09.26"        # FromDate
$A  = "2026.08.21"        # ToDate
```

Novecento righe piu' sotto, il **gate della STELLA** — a **scope di script** —
si prendeva due variabili di comodo:

```powershell
$a = $Vive[$la[0].Prova]      # <<< $a E' $A. In PowerShell non esiste il maiuscolo.
$b = $Vive[$sh[0].Prova]
```

Da li' in poi `$A` **non e' piu' una data**: e' un **array di 41 stringhe**, gli
input della cella LONG dell'ultimo simbolo. E il colpo di grazia e' la
**conversione implicita**: passato a un parametro `[string]$a`, PowerShell
unisce l'array con `$OFS`, cioe' **uno spazio**. Nell'`.ini` che ha girato:

```
FromDate=2024.09.26
ToDate=InpUsaGuardian=true||true||0||true||N InpPivotLeft=5||5||0||5||N InpPivotRight=5||...
```

e nel referto: `2024.09.26 -> InpUsaGuardian=true||...`.

**Quattro cose lo rendono la classe piu' cattiva vista finora:**

1. 🟢 **il giro a vuoto e' uscito `ESITO: OK`, codice 0.** Le fabbriche `.ini`
   avevano gate su 41 parametri, `Period`, `Model`, `Symbol`, l'asse Y, il
   magic, `AllowLiveTrading` — **e nessuno sulle DATE**. La finestra e' meta'
   di quello che un backtest MISURA, e non era controllata.
2. 🤫 **MT5 non protesta**: con un `ToDate` invalido non si sa cosa faccia
   (forse corre fino a oggi). La corsa vera avrebbe prodotto numeri
   **plausibili su una finestra NON DICHIARATA**.
3. 👀 **A schermo sembrava tutto giusto**: la riga `FINESTRA : 2024.09.26 ->
   2026.08.21` si stampa **PRIMA** del gate della stella, cioe' prima del
   danno. Chi guardava la console non poteva vedere niente.
4. 🧪 **La verifica in isolamento non poteva trovarlo.** Il verificatore aveva
   provato le due fabbriche chiamandole da uno script di prova, dove `$A` non
   veniva mai sporcata. **Il difetto non e' nella funzione: e' nel FLUSSO
   DELLE VARIABILI dello script.**

### E il gemello nello stesso file, che non era ancora esploso

Stesso audit, stesso file: `$RefTxt` si chiamava **`$R`** (l'ArrayList del
referto, `[void]$R.Add(...)` 180 volte), e nella costruzione del referto c'era

```powershell
foreach($r in $AutotestRighe){ [void]$R.Add("    " + $r) }
```

`$r` **e'** `$R`. Al primo giro l'ArrayList diventa una **stringa**, e
`[void]$R.Add(...)` muore con *"[System.String] does not contain a method
named 'Add'"*. Riprodotto. **Nel giro a vuoto non succede** — `$AutotestRighe`
e' vuoto e il ramo non gira — **ma nella corsa vera si', sempre**: dopo 3-12
ore di tick reali il referto sarebbe uscito **troncato alla sezione
dell'autotest**, con `RACCOLTA PARZIALE` e nessuna tabella.

> ✅ **REGOLA, in quattro pezzi:**
> 1. **Nomi CORTI solo per le temporanee, nomi LUNGHI per configurazione e
>    stato.** `$Da`/`$A` diventano `$DataDa`/`$DataA`, `$R` diventa `$RefTxt`.
>    Una variabile che vive per tutto lo script **non puo' chiamarsi con una
>    lettera**, perche' prima o poi qualcuno usera' quella lettera in un ciclo.
> 2. **L'audit si fa sull'AST, non a occhio** — e va fatto su **ogni** driver
>    prima dell'invio: si elencano le assegnazioni **fuori dalle funzioni**
>    (assegnazioni **e variabili di `foreach`**) e si cercano le chiavi che
>    compaiono con **grafie diverse**:
>    ```powershell
>    # collisione = stessa chiave .ToLower(), grafie diverse
>    $ast.FindAll({param($n) $n -is [Language.AssignmentStatementAst] -or $n -is [Language.ForEachStatementAst]},$true)
>    ```
>    ⚠️ **Una collisione fa male solo se la temporanea e' assegnata DOPO che la
>    variabile lunga e' nata**: in `R103`, `R107` e `R108` la stessa coppia
>    `$R`/`$r` esiste ed e' **innocua** perche' tutti i `foreach($r ...)` stanno
>    **prima** della riga che crea `$R`. E' una mina disinnescata: si segnala
>    lo stesso, perche' basta spostare una riga per armarla.
> 3. **LE DATE SONO UN PARAMETRO COME GLI ALTRI, e si controllano come gli
>    altri.** In ogni fabbrica di `.ini`, tre controlli sugli ARGOMENTI e uno
>    sull'ARTEFATTO:
>    ```powershell
>    if($da -notmatch '^\d{4}\.\d{2}\.\d{2}$'){ throw }          # forma
>    if(-not [datetime]::TryParseExact($a,"yyyy.MM.dd",...)){ throw }  # giorno che esiste
>    if($d2 -le $d1){ throw }                                     # verso
>    if($testo -notmatch ('(?m)^ToDate=' + [regex]::Escape($a) + '\r?$')){ throw }  # nel testo
>    ```
>    e il **giro a vuoto rilegge le due righe DALL'`.ini`**, non dalla variabile
>    che le ha prodotte.
> 4. **Il referto che stampa una finestra impossibile deve DIRLO**, non
>    limitarsi a mostrarla: chi legge il fondo del referto non riapre gli `.ini`.
>
> 🧨 **E la lezione di metodo, che vale piu' del difetto**: provare una funzione
> **chiamandola da un test** dimostra che la funzione e' giusta, **non** che
> riceve gli argomenti giusti. Il giro a vuoto va letto **aprendo gli artefatti
> che produce** — qui bastava aprire un `.ini` dello zip, ed e' esattamente
> quello che ha fatto Claudio.

---

## 🆕 AGGIUNTA DEL 25/08/2026 — trovata verificando R110 (i lati vivi sugli indici)

## 80. 🫥 LA COLONNA EREDITATA DAL ROUND GEMELLO CHE LA FAMIGLIA NUOVA NON ESPORTA: il sentinella ONESTO camuffa un criterio IMPOSSIBILE

_Difetto vero, gia' committato in `RIGA_R110_LATI_VIVI.ps1` (righe 91-93 e
538-541), in `R110_CRITERI.md` (§ 5 G4-bis e § 5.1) e in
`RIGA_R110_DA_MANDARE.md` (punto 6 delle "cose da guardare per prime"),
trovato PRIMA dell'invio e **RIPRODOTTO** eseguendo il parser vero del driver
sull'intestazione VERA dei quattro EA del round._

R110 nasce dichiarandosi *"`RIGA_R107_LATI_SHORT.ps1` adattata da TRE famiglie
a QUATTRO"*. Insieme alla macchina, si e' ereditata **una colonna**:

```
# nel driver R110, come commento:
#  L'intestazione VERA e' MISURATA sugli artefatti (OPTFRAME esteso):
#    Pass,Profit,...,Equity DD %,Trades,Peggior Giornata %,...
```

La frase *"MISURATA sugli artefatti"* **era vera** — sugli artefatti di R107.
I tre EA d'apertura di R107 scrivono un OPTFRAME a **11 colonne**
(`Peggior Giornata %`, `Perdite Consecutive Max`, `Serie Perdente Peggiore`).
I **quattro** EA di R110 scrivono `double stats[7]` e l'header

```
"Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades"
```

cioe' **otto colonne, senza la peggior giornata**. E' il punto 18 (la misura
fatta sulla grandezza sbagliata) applicato **alla FAMIGLIA** invece che al
timeframe: il controllo sembra fatto, e la cosa misurata e' un'altra.

**Ma quello che rende la classe nuova e' come FINISCE, non come nasce.** Il
punto 66 ha imposto la convenzione onesta: *un numero non misurato si scrive
`n/d`*. Qui la convenzione funziona **perfettamente** — e proprio per questo:

| | |
|---|---|
| il parser cerca la colonna per nome | non la trova, torna `$null` — **giusto** |
| il sentinella resta al valore iniziale | `99.9` |
| il formattatore stampa | **`n/d`** — **giusto** |
| il referto dichiara la convenzione | *"`n/d` = non misurato"* — **giusto** |

Ogni singolo pezzo si comporta bene, **e il risultato e' che una colonna
STRUTTURALMENTE IMPOSSIBILE e' indistinguibile da una colonna che stavolta
non e' uscita.** Il controllo positivo del parser non aiuta (`kPg` e'
facoltativo: il CSV si legge benissimo senza).

**Il costo, misurato su R110.** I criteri **[DA FIRMARE]** dicevano, al
cancello G4-bis: _"LA PEGGIOR GIORNATA, SEMPRE — per ogni cella, sempre,
anche a `n` sottile. E' rischio, e il rischio non si sospende mai"_, e il
foglio della riga mandava Claudio a leggerla per prima fra le voci di
rischio. Firmata quella riga, il round sarebbe uscito con **dodici celle su
dodici a `n/d`** in quella colonna — e un criterio firmato non si corregge
dopo (punto 57). Le due uscite sbagliate sarebbero state: fermare il round
per un falso allarme sul parser, oppure imparare che i criteri sono "circa".
Aggravante: la strada per averla **esisteva** (R103 la misurava dai deal del
report `.htm`) e nessuno l'aveva confrontata con quella ereditata.

> ✅ **REGOLA, in tre pezzi.**
> 1. **Quando un round e' l'adattamento di un gemello, si rifa' la LISTA
>    DELLE COLONNE sul SORGENTE della famiglia NUOVA**, non si eredita
>    l'intestazione. Grep secco, un EA per volta:
>    ```
>    grep -o 'string head = "[^"]*"' <EA>.mq5
>    grep -o 'double stats\[[0-9]*\]'  <EA>.mq5
>    ```
>    Se le colonne che i criteri nominano non ci sono **tutte**, il criterio
>    va riscritto **prima della firma**, non tradotto dopo.
> 2. **Ogni colonna nominata in un criterio porta accanto CHI la produce.**
>    "peggior giornata" non e' una grandezza: e' `stats[8]` di *quell'*
>    OPTFRAME, oppure i deal di un report `.htm`, oppure i per-trade
>    `abtg_trades_*` — e sono tre strumenti diversi, con tre disponibilita'
>    diverse. In R110 il quarto EA (`ABTG_SupRev_DAX_H4_Ottimizzato`) **non
>    ha nemmeno `ExportTrades()`**: nemmeno il ripiego era uniforme.
> 3. **Una colonna che NON PUO' uscire si dichiara nel referto, non si
>    lascia al sentinella.** Il `n/d` da solo dice *"stavolta no"*; serve la
>    riga che dice *"MAI, e per questo motivo"*, e il driver la scrive
>    **verificandolo a runtime** (`$cols -notcontains 'Peggior Giornata %'`
>    -> RILIEVO), non a commento.
>
> 🧭 **Dove si annida**: ogni round "adattato da", ogni parser con colonne
> **facoltative** (`if($null -ne $kPg)`), ogni criterio che elenca metriche
> con la formula *"sempre, anche a n sottile"*. La domanda secca, una per
> metrica: **"chi scrive questo numero, e l'ho aperto?"**

---

## 🆕 AGGIUNTA DEL 26/08/2026 — dall'indagine sui "deal anomali" di R109

## 81. 🎲 `Sort-Object` **NON E' STABILE**: riordina cio' che era GIA' in ordine, e l'errore che produce e' PLAUSIBILE e punta sul BERSAGLIO SBAGLIATO

_Difetto vero, **girato nella corsa vera di R109** (25/08) e diagnosticato il
26/08 (`risultati_archivio/R109_INDAGINE_DEAL_2026-08-26.md`, commit `06a0cac`).
**Riprodotto** in modo indipendente dal verificatore._

`RIGA_R109_ATREXH.ps1`, riga 710, dentro il parser dei deal:

```powershell
$ordinati = @($deal | Sort-Object Ora)
```

Un gesto **difensivo** — "ordino per sicurezza" — che ha introdotto il difetto
che voleva evitare. `Sort-Object` di PowerShell **non e' stabile**: sulle chiavi
**uguali** l'ordine d'uscita e' **arbitrario**. (Il parametro `-Stable` esiste
**solo da PowerShell 7**: sul PC di Claudio, che ha **Windows PowerShell 5.1**,
non c'e' — quindi "aggiungo `-Stable`" **non e' una correzione che arriva sul
posto**.)

Su dati di mercato i **pari ci sono sempre**: due deal nello stesso **secondo**
sono la norma (posizione aperta e stoppata dentro il secondo; oppure chiusura di
un trade e apertura del successivo). Ogni gruppo invertito trasforma una coppia
`in`/`out` perfetta in `out`/`in`, e da li' la sequenza sembra **spaiata**.

**I numeri, misurati sulla corsa vera:**

| cella | gruppi a pari secondo | n prodotto | false anomalie |
|---|---|---|---|
| D30EUR long  | 3 | 815 (vero 818) | 6  |
| D30EUR short | 6 | 921 (vero 927) | 13 |
| U30USD long  | 1 | 885 (vero 886) | 2  |
| U30USD short | 4 | 920 (vero 923) | 7  |
| NASUSD long  | **0** | 655 (vero 655) | **0** |
| NASUSD short | 3 | 740 (vero 743) | 6  |

**34 false anomalie e 16 operazioni perse.** NASUSD long era pulita **solo
perche' non aveva deal a pari secondo**: il controllo positivo perfetto, arrivato
per caso. Riprodotto qui: **un gruppo invertito = 2 anomalie e 1 operazione
persa**, e l'aritmetica `anomalie = 2·A + 3·B` torna su **sei celle su sei**.

### Perche' e' una classe a se', e non il punto 70

Il **70** dice che `Sort-Object -Unique` **ORDINA** dove credevi solo
deduplicasse: si scopre **confrontando due stringhe a schermo**, ed e' un
fastidio di presentazione. Questo dice che `Sort-Object` **RIORDINA CIO' CHE ERA
GIA' IN ORDINE** quando la chiave ha dei pari — e **non si vede affatto**,
perche' non produce un errore: produce un **errore PLAUSIBILE**.

☠️ **Ed e' questa la parte cara.** Il driver ha scritto:

> _"deal NON accoppiati o con volume diverso. Con UNA POSIZIONE ALLA VOLTA e
> InpTP1Pct=0 **non dovrebbe succedere**"_

cioe' ha accusato **l'EA** — l'unico pezzo innocente della catena — con una
frase tecnicamente ineccepibile. Sono state bruciate ore a cercare un difetto
nel motore e nel tester, che erano puliti: il conteggio giusto ce l'avevano
**tre testimoni indipendenti** (CSV OPTFRAME, deal `out` dell'`.htm`, per-trade
scritto dall'EA), e **l'unico dissenziente era il nostro parser**.

> ✅ **REGOLA, in tre pezzi:**
> 1. **Non si ordina cio' che arriva gia' ordinato da una fonte con chiave
>    univoca.** I deal dell'`.htm` sono in ordine di **TICKET**, che e'
>    cronologico e **non ha pari**. Il sort non serviva a niente.
> 2. **Se ordinare serve davvero, la chiave deve avere una SPAREGGIO UNIVOCO**:
>    `Sort-Object Ora, @{Expression={[long]$_.Affare}}` — e allora la colonna di
>    spareggio va **letta e conservata** dal parser (in R109 `LeggiDeal` la
>    scartava, ed e' il motivo per cui la scorciatoia non era disponibile).
>    ⚠️ **Vale doppio per i timestamp al secondo**: su dati di mercato i pari
>    non sono un caso limite, sono la regola.
> 3. **"Arriva gia' ordinato" e' un'ASSUNZIONE, e si MISURA**: si controlla la
>    monotonia e, se il file la smentisce, **si DICHIARA e non si misura** —
>    non si riordina alla cieca, che e' il difetto di sopra:
>    ```powershell
>    $fuoriOrdine = 0
>    for($i=1; $i -lt $ordinati.Count; $i++){ if($ordinati[$i].Ora -lt $ordinati[$i-1].Ora){ $fuoriOrdine++ } }
>    if($fuoriOrdine -gt 0){ $r.Stato = "NON MISURATO: i deal NON arrivano in ordine..."; return $r }
>    ```
>
> 🧪 **E il test si scrive coi PARI COSTRUITI APPOSTA.** Una batteria su dati
> con chiavi tutte diverse **non puo' vedere questo difetto**: e' esattamente
> perche' il report finto del verificatore aveva orari tutti distinti che il
> difetto e' passato. Ogni parser che ordina va provato con **almeno un gruppo
> di record a chiave identica**.

### 81-bis. 🛡️ E LA GUARDIA HA FUNZIONATO — va detto, perche' e' la parte da NON cambiare

Il driver **non ha inventato numeri**: si e' accorto che qualcosa non tornava,
ha **rifiutato** di dare le misure del Passo 0, ha scritto `n/d` invece di zeri,
ha marcato la cella `NON AFFIDABILE` e ha messo dieci righe nei PROBLEMI. Ha
sbagliato **la diagnosi**, non il comportamento. La classificazione "anomalo"
non era troppo stretta: era **giusta**, ed era l'**input** a essere corrotto
prima di arrivarci.

> **Corollario**: quando una guardia scatta, la prima domanda non e' _"la guardia
> e' troppo severa?"_ ma **_"chi ha toccato il dato PRIMA della guardia?"_**.
> Allentare la guardia avrebbe nascosto il difetto e lasciato in piedi 34
> anomalie invisibili e 16 operazioni mancanti.

⚠️ **E il verdetto di RISCHIO del round non e' toccato**: DD 44-68% e peggior
giornata −9,72% vengono dai **CSV OPTFRAME**, cioe' dalla curva di equity del
tester, che **non passa dal parser dei deal**. Un difetto del parser non e' mai
una scusa per rimandare la lettura di un drawdown che viene da un'altra fonte:
**prima si stabilisce QUALE misura passava dal pezzo rotto**, e solo quella si
sospende.

---

## 🆕 AGGIUNTA DEL 25/08/2026 (notte) — trovata RI-verificando R110 **dopo la firma di Claudio**

## 82. 🔏 IL GATE CERCA UN TOKEN LETTERALE, LA PROSA LO NOMINA: la firma data resta INVISIBILE, e il referto la nega agli atti

_Difetto vero, gia' committato in `R110_CRITERI.md` (`40e5bcf`), trovato PRIMA
dell'invio e **RIPRODOTTO eseguendo il driver vero sul file vero al pin**._

Claudio firma. Il titolo del documento passa da `CRITERI **[DA FIRMARE]**` a
`CRITERI **FIRMATI**`, e in testa arriva il timbro: _"FIRMO R110 — Claudio,
25/08/2026 sera"_. Ma il gate del driver e' scritto cosi':

```powershell
$daFirmare = (Select-String -LiteralPath $critFile -SimpleMatch -Pattern '[DA FIRMARE]' -Quiet)
```

`-SimpleMatch` cerca la stringa **in tutto il file**, non nel titolo — **ed e'
giusto che lo faccia**: un lucchetto rimasto in una sezione E' un pezzo non
firmato. Il problema e' che nel file ne restavano **due**, e nessuna delle due
era il titolo:

| riga | cos'era | perche' era rimasta |
|---|---|---|
| 11 | _"Questo documento porta `[DA FIRMARE]` nel titolo, e il driver LO LEGGE al pin"_ | **la prosa che SPIEGA il lucchetto**, diventata falsa con la firma (punto 45) |
| 607 | `## 10. LE SEI DECISIONI — **[DA FIRMARE]**` | il lucchetto del paragrafo delle decisioni, tolto solo dal titolo |

**Misurato, eseguendo il driver sul file firmato:**

```
corsa vera SENZA -CriteriFirmati  ->  EXIT=2   "NON PARTO: I CRITERI NON SONO FIRMATI"
corsa vera CON  -CriteriFirmati   ->  EXIT=0, e nel referto TRE frasi FALSE:
    stato dei criteri: NON FIRMATI (il file porta ancora [DA FIRMARE])
    switch di questo giro: -CriteriFirmati (FIRMA IN RIGA di Claudio: ...)
    RILIEVO: "I criteri portano ancora [DA FIRMARE] ... la firma e' quella data in riga"
```

**Il costo, ed e' doppio.** Davanti: Claudio legge la sua stessa firma in testa
al documento e il driver gli risponde che non ha firmato — e' il gate che grida
sempre del punto 47, con l'aggravante che stavolta grida **contro un fatto
scritto**. Dietro, ed e' peggio: la pagina prescrive `-CriteriFirmati`, quindi
il round **parte lo stesso** e il **referto** — l'unico artefatto che resta agli
atti — dichiara `NON FIRMATI` su un round firmato, e attribuisce la firma a una
"firma in riga" che non c'e' mai stata. Fra un mese, chi apre lo zip per sapere
se quel round era autorizzato, trova la risposta **sbagliata**.

### Perche' e' una classe a se'

Il **77** dice che una ricetta `sed` non puo' contenere il token che cerca. Il
**45** dice che un difetto chiuso sopravvive dove nessuno ha rigrepato. Questo
e' il caso in cui i due si sommano su un **interruttore di autorizzazione**: la
prosa che spiega un gate a token letterale **e' essa stessa un input del gate**,
e resta indietro esattamente quando lo stato cambia — cioe' **il giorno della
firma**, l'unico giorno in cui quel gate viene davvero esercitato.

> ✅ **REGOLA, in quattro pezzi:**
> 1. **Un token di stato (`[DA FIRMARE]`, `[BOZZA]`, `TODO`, `[BLOCCATO]`) non
>    si NOMINA mai nel documento che lo porta.** La prosa dice *"il lucchetto
>    della firma"*, non lo scrive. Altrimenti spegnere lo stato e' impossibile
>    senza rendere illeggibile la spiegazione.
> 2. **Cambiare stato e' un `grep -c`, non una modifica al titolo**: dopo la
>    firma, `grep -cF '<token>' <file>` **deve dare 0**. E' il doppio conteggio
>    del punto 77 applicato alla firma. (Qui dava **2**.)
> 3. **Le frasi che il referto scrive sullo stato si costruiscono sul VALORE
>    LETTO, mai su un ramo solo.** `if($CriteriFirmati)` non basta: serve
>    `if($CriteriFirmati -and $daFirmare)` per "firma in riga" e il ramo
>    `elseif($CriteriFirmati)` per **"switch INERTE, il file era gia' firmato"**.
>    Uno switch di bypass che si autodescrive sempre allo stesso modo mente
>    meta' delle volte.
> 4. ⚠️ **E la variabile di stato nasce PRIMA del `try`** (41-bis): la raccolta
>    la usa, e su un throw precedente `$null` si legge **"firmato"** — cioe' il
>    referto dichiarerebbe un'autorizzazione che non ha mai verificato.
>
> 🧪 **E si prova nei DUE versi** (punto 55): col lucchetto tolto la corsa vera
> deve **partire senza lo switch**, e col lucchetto rimesso deve tornare a
> **exit 2**. Provati tutti e due: 0/2 e 2/2.
> 🔁 **Corollario per le righe di lancio**: quando il gate si apre, lo switch di
> bypass **si toglie dalla riga**. Lasciarlo "tanto e' innocuo" lo trasforma in
> un bypass permanente scritto nella pagina, che il giorno in cui qualcuno
> rimette un lucchetto **non fara' fermare niente**.
