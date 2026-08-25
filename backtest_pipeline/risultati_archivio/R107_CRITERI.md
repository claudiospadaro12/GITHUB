# ✍️ R107 — IL RICONTROLLO DEI LATI SHORT (Dow · DAX · Nasdaq) — CRITERI **[DA FIRMARE]**

**Perimetro**: `risultati_archivio/R107_CODA_LATI_SHORT.md` (richiesta di Claudio
del 25/08/2026: _"Mettilo in coda. Ricontrollo short DAX e Nasdaq e Dow"_).
**Driver**: `righe/RIGA_R107_LATI_SHORT.ps1` (marcatore `MARCATORE_RIGA_R107_v1`).
**File prova**: `prove/R107_*.txt` — **sei**.
**Riga da mandare**: `righe/RIGA_R107_DA_MANDARE.md`.

> 🔒 **Questo documento porta `[DA FIRMARE]` nel titolo, e il driver LO LEGGE.**
> Finché la stringa è lì, la **corsa vera** si ferma con `exit 2`. Il **giro a
> vuoto** parte lo stesso (non apre MT5, non produce nessun numero, e serve
> proprio a far leggere questi criteri prima di firmarli).
> Le decisioni da firmare sono **tre**, e stanno al § 10.

---

## 0. 📌 DA DOVE NASCE — e cosa **non** è

Nasce davanti a un fatto: il **candelone rosso dell'apertura Dow delle 14:30**
del 25/08, che la sedia solo-LONG ha **correttamente ignorato**. La domanda di
Claudio è legittima e vecchia: **quel lato lì, spento, ha edge oggi?**

**Cosa NON è questo round:**

- ❌ **Non è un'ablazione** (quella era R101: nove filtri, una stella).
  Qui si muove **un asse solo**, ed è la **direzione**.
- ❌ **Non è una griglia e non è un'ottimizzazione.** Non c'è nessun parametro
  spazzolato: **l'unico asse con flag `Y` in tutti e sei i file prova è
  `InpMagic`**, che è il controllo d'igiene dei gemelli.
- ❌ **Non è un round di deploy.** Vedi G5.
- ❌ **Non è una "seconda griglia su un motore morto"** — sul Nasdaq questo
  punto è delicato e ha un paragrafo suo, il § 7.

---

## 1. 🧭 IL METODO — due celle per famiglia, e cambiano **solo i due lati**

Per ogni famiglia:

| cella | cos'è |
|---|---|
| `00_metro` / `00_riflong` | la cella **LONG**, congelata input per input |
| `01_short` | **la stessa identica cella** con `InpAllowLong=0` e `InpAllowShort=1` |

**E NIENT'ALTRO cambia.** Non un buffer, non un offset, non un floor di stop,
non un TP, non un sotto-parametro di un filtro spento. La differenza fra i due
file di una famiglia è **letteralmente di due righe** (più `InpMagic`).

### 1.1 Come è garantita l'attribuzione — è **verificata**, non promessa

Il driver, **prima di aprire MT5**, fa quattro cose sui file veri scaricati al pin:

1. **Gate delle righe**: ogni file ha il numero di righe vive atteso
   (**DOW 74 · DAX 75 · NAS 89**), misurato sul file, non ricordato.
2. **Gate della stella**: il `01_short` differisce dal `00_metro` della sua
   famiglia **esattamente** su `InpAllowLong`, `InpAllowShort`, `InpMagic` —
   e su nient'altro. Contare "3 righe diverse" non basterebbe: **tre righe
   sbagliate darebbero lo stesso conteggio**.
3. **Gate della geometria viva**: ogni file contiene, riga per riga, i valori
   della sedia viva del § 2. La stella garantisce che i file siano **uguali fra
   loro**; questo garantisce che siano uguali **alla sedia**. Due file identici
   e sbagliati passerebbero la stella.
4. **Gate dei valori propri**: `InpAllowLong`/`InpAllowShort` valgono `1/0` nel
   metro e `0/1` nello short. Se i due file fossero **scambiati**, i gate 2 e 3
   resterebbero verdi e questo no (checklist 34-bis).

---

## 2. 🧊 LE CELLE CONGELATE — input per input, con la fonte

### 2.1 🇺🇸 DOW — `ABTG_Dow_Apertura_US` v1.01 · U30USD M5 · magic vivo **770202**

`prove/R107_DOW_00_metro.txt` è la **copia carattere per carattere** del blocco
input di `prove/R101_DOW_00_viva.txt`. Le uniche righe toccate: `InpMagic` e la
testata. Verificato con `diff` il 25/08: **una riga di differenza, ed è il magic**.

La geometria, in chiaro: ora **14:30 SERVER** (= 15:30 IT), range 35',
`InpEntryMode=2` (**RETEST**), `InpRangeMode=0`, buffer **1000** punti, offset di
retest **400**, EMA H4 **accesa** (`EmaFast=1` = il prezzo, `EmaSlow=50`,
`FilterTF=16388`), `InpSLMode=0` (stop sull'estremo opposto del range), TP1 a
**1,0 R** con parziale **50%** e **breakeven**, trailing **PREVBAR M5**, floor di
stop **500** punti con `InpSkipIfTight=0`, un trade al giorno, chiusura **17:30
server**, rischio **1,00%**.

> ✅ **Questa geometria è già stata verificata a grafico da Claudio il 23/08**
> (`R101_CRITERI.md` § 10.1, i due controlli: `InpMinStopPts 500`,
> `InpSkipIfTight false`, range min/max 0). **R107 non ri-chiede quella verifica**
> perché non ha cambiato nulla di quella cella — ed è per questo che il file
> prova è una copia e non una riscrittura.

### 2.2 🇩🇪 DAX — `ABTG_DAX_Apertura_EU` v1.01 · D30EUR M5 · magic vivo **770101**

Stessa cosa: copia carattere per carattere di `prove/R101_DAX_00_viva.txt`.
Ora **08:00 SERVER** (= 09:00 IT), range 35', RETEST, buffer **500**, offset
**200**, EMA **spenta**, floor di stop **0** con `InpSkipIfTight=1`,
`InpAllowReverse=0`. Verificata a grafico il 23/08 (il secondo dei due controlli
di R101 era proprio `InpAllowShort 0` sul DAX).

### 2.3 🇺🇸 NASDAQ — `ABTG_Nasdaq_Apertura_US` v1.02 · NASUSD M5 — ⚠️ **è una TRASPOSIZIONE**

Qui **non esiste nessuna sedia viva** con questa geometria: il magic **770201 è
SPENTO e resta spento**. Quindi:

- 🔴 **non c'è nessun numero agli atti da riprodurre** → **nessun gate G0** sulla
  famiglia NAS. Va scritto nel referto in chiaro: `G0 NAS: NON APPLICABILE`.
  *Non applicabile* **non è** *superato*.
- 🔴 la cella `00_riflong` **non è un metro**: è un **riferimento**, cioè un
  denominatore. Serve solo a dare un senso al numero dello short.

**Che geometria si usa**: la **geometria viva del DOW, trasposta di peso**
(stesso file input, `@SIMBOLO NASUSD`, più il blocco R30). Il Dow è il genitore
giusto: stessa sessione (apertura USA **14:30 server**), stessa famiglia di
strumento.

> ⚠️ **IL LIMITE DELLA TRASPOSIZIONE, dichiarato PRIMA dei numeri.**
> `InpBufferPoints` e `InpRetestOffsetPts` sono in **punti assoluti**. 1000 punti
> = 10 punti indice: su un Dow a ~44.000 è lo **0,023%**, su un Nasdaq a ~20.000
> è lo **0,05%** — il **doppio** in termini relativi.
> ➡️ **Conseguenza obbligata sulla lettura**: se le celle NASUSD escono rosse, il
> risultato è **"la geometria del Dow non si trasporta sul Nasdaq"**, NON *"il
> Nasdaq non ha edge in apertura"*. Sono due frasi diverse e **solo la prima è
> misurata qui**. È la decisione **D1** del § 10.

**Il blocco R30** (15 input, pinnati **spenti**): `InpUseVolRegime` e
`InpUseSRFilter` esistono solo in questo `.mq5` (round 30, mai validati).
**MISURATO nel sorgente il 25/08**: `UpdateVolRegime()` ritorna alla prima riga
se l'interruttore è falso, `VolRegimeSL()` ritorna lo stop invariato,
`SRBlocked()` ritorna `false` subito. Con i due a 0, **il motore Nasdaq è il
motore Dow** — e infatti il `diff` dei due core (fatto il 25/08) non mostra
nessun'altra differenza di logica, solo i default degli input e il blocco R30.
Il Nasdaq **non ha** `InpAllowReverse` (ce l'ha solo il DAX): infatti non compare.

### 2.4 ⚖️ Rischio 1,00% nei file prova, 0,65% in campo

Come R101 § 2.4 e per lo stesso motivo (confrontabilità con R46/R54/R101).
➡️ **Ogni DD di questo round è all'1%.** Per confrontarlo col forward del 100k
**si moltiplica per 0,65**. Chi salta la conversione confronta due cose diverse.

---

## 3. 🔢 LE SEI CELLE E I MAGIC

| famiglia | cella | file prova | lati | magic gemelli | è un metro? |
|---|---|---|---|---|---|
| DOW | `00_metro` | `R107_DOW_00_metro.txt` | 1 / 0 | **761000 / 761001** | ✅ sì (G0) |
| DOW | `01_short` | `R107_DOW_01_short.txt` | 0 / 1 | **761010 / 761011** | ➕ G0-bis (§ 5) |
| DAX | `00_metro` | `R107_DAX_00_metro.txt` | 1 / 0 | **761100 / 761101** | ✅ sì (G0) |
| DAX | `01_short` | `R107_DAX_01_short.txt` | 0 / 1 | **761110 / 761111** | ❌ è **la misura nuova** |
| NAS | `00_riflong` | `R107_NAS_00_riflong.txt` | 1 / 0 | **761200 / 761201** | ❌ **riferimento**, non metro |
| NAS | `01_short` | `R107_NAS_01_short.txt` | 0 / 1 | **761210 / 761211** | ❌ |

**Blocco magic `761xxx`**: verificato libero in tutto il repo il 25/08/2026
(`grep -rhoE '\b761[0-9]{3}\b'` → **zero occorrenze**). I blocchi confinanti sono
occupati e vanno lasciati stare: `760xxx` R103, `750xx` R104, `79xxxx` R102,
`7732xx/7733xx` R101, `7726xx` R54, `7728xx` R98.

**Magic VIETATI e controllati nel codice**: `770202` e `770101` (le due sedie
vive di questo round), `770201` (Nasdaq Apertura — **spenta, ma un'identità
spenta resta occupata**), più le sedie confinanti sugli stessi simboli
(`770611`, `770601`, `770411`, `770901`) e i blocchi dei round recenti.

> 🧬 **`magic del SORGENTE` ≠ `magic del FILE PROVA`.** I tre `.mq5` dichiarano
> `ABTG_DEF_MAGIC` `770202` / `770101` / `770201`: quello è **l'identità del
> motore**, e il gate di versione controlla **quello**. I magic `761xxx` stanno
> nei file prova e sovrascrivono il default **dentro il tester**. Confonderli è
> il difetto che R100 ha dovuto correggere a mano su due sedie.

**Costo della corsa**: 6 celle × 2 finestre × 2 gemelle = **24 passate**,
**12 CSV**, **2 righe per CSV**.

---

## 4. 📅 FINESTRE — le standard, senza sconti

| | |
|---|---|
| simboli | **U30USD**, **D30EUR**, **NASUSD**, **M5** |
| storico | `@DAQUANDO` **2024.09.26** — muro del feed BCM sugli indici, misurato (`REFERTO_SONDA_STORICO_17-08.md`, che dà **NASUSD COMPLETO** da quella data) |
| fine | **2026.06.30** |
| split | **40 / 60** (`FrazioneIS 0.40`, default del driver generico) |
| **IS** | **2024.09.26 → 2025.06.09** |
| **OOS** | **2025.06.10 → 2026.06.30** |
| modello | **4 = TICK REALI** |
| deposito | **100.000** |
| spread | `Spread=0` scritto nell'ini = spread **corrente** del feed, dichiarato. **Non è uno stress e non è una misura** |

Sono le finestre di **R88 / R97 / R98 / R101**. Il file di coda proponeva anche
_"+ coda 2026.07-08 se il driver la regge"_: **la proposta è respinta qui, e il
motivo è tecnico** — allungare `@DAQUANDO`→`Fino` sposta anche il punto di split
al 40%, quindi cambierebbe **sia l'IS sia l'OOS** e i numeri non sarebbero più
confrontabili né con R54 né con R101. Una coda si aggiunge in un round che ha la
coda come oggetto, non di straforo in un round di riproduzione.

### 4.1 🚩 I limiti della finestra — **e per un round sui LATI sono decisivi**

**Questo è il paragrafo che il file di coda chiedeva di riprendere, e va letto
prima di ogni tabella.**

1. 🔴 **21 MESI DI INDICI IN SALITA.** Il lato short parte **svantaggiato per
   REGIME**, non per merito. Un _"niente edge short"_ qui **non chiude la
   domanda per sempre: la chiude PER QUESTA EPOCA.**
   **Emendamento regola C**: la prova di regime batte la storia contigua — e
   sugli indici **non la possiamo fare** (Pepperstone non esiste,
   `R54_LATO_MAI_MISURATO_TESI.md` § 5).
2. 🔴 **QUESTO OOS È GIÀ STATO GUARDATO MOLTE VOLTE** (R14, R15, R16, R35, R46,
   R51, R54, R88, R101…). R54 § 4 lo contava già come *"la quarta guardata"*.
   R107 aggiunge sei celle. **Con tante guardate sulla stessa finestra, qualcuno
   esce verde per caso**: è la ragione di G3.
3. 🟠 **IL CAMPIONE SARÀ SOTTILE SUGLI SHORT COL FILTRO EMA.** Sul Dow lo short
   aveva **n 73** (R54): sopra la soglia G1 di 30, ma **sotto i 150**
   dell'Emendamento regola A. Sul NASUSD, stessa geometria, atteso simile o
   peggio.

### 4.2 🦴 LA LETTURA PER **SPINA DORSALE** — dove stanno le discese

**Il fatto di calendario, ed è verificabile su qualunque grafico:** la discesa
documentata dentro questa finestra è la **correzione di febbraio-aprile 2025**
(con i minimi di aprile). Cade **dentro l'IS** — l'IS finisce il **2025.06.09**.

➡️ **Conseguenza sulla lettura, scritta PRIMA dei numeri:**

> Se la cella short esce **positiva in IS e negativa in OOS**, la prima ipotesi
> **non è** "il lato è instabile / è rumore": è che **l'edge dello short viva
> nelle discese, e l'IS ne contenga una mentre l'OOS quasi no.**

E c'è un precedente che punta esattamente lì: R54 chiamò quel risultato *"il 28°
ribaltamento"* e lo lesse come *"rumore di regime"*. **Guardando il calendario,
la spiegazione più semplice è un'altra**: la cella short del Dow faceva IS
**+6.463 · PF 1,511 · DD 2,68%** e OOS **−2.592 · PF 0,840**, e la crisi di
aprile 2025 sta **tutta** nella prima finestra.

> ⚠️ **[INFERITO], e resta [INFERITO] anche dopo questo round.** R107 **non
> misura** i sotto-periodi: non sa dire quanto del profitto IS venga da
> febbraio-aprile, e **non sa** se l'OOS contenga discese di ampiezza
> paragonabile. Non lo assuma nessuno: **non è misurato qui**.

**Perché non lo misuriamo adesso** (è la decisione **D3** del § 10): una finestra
dedicata `2025.02.01 → 2025.04.30` sono ~60 giorni di borsa, e questi motori
fanno **~1 operazione al giorno**. Sul DAX (EMA spenta) darebbe forse ~50-60
operazioni; **sul Dow e sul Nasdaq, con l'EMA H4 che taglia gli short, ne
darebbe una manciata — sotto il cancello G1 per costruzione.** Un numero che
nasce già non misurabile non si produce: si scrive che serve **un round di prova
di regime fatto apposta**, con finestre scelte sull'ampiezza e non sul calendario.

---

## 5. 🚧 I CANCELLI

### G0 · RIPRODUZIONE DEL METRO — 🔴 **FATALE, per famiglia**

| famiglia | la cella `00` OOS deve dare | fonte |
|---|---|---|
| **DOW** | **PF 1,270 · DD 4,394% · n 130** | `REFERTO_ROUND54_LATI_DOW.md` § 1 (riga "solo LONG") **e** `R101_REFERTO.md` riga 26, che l'ha riprodotto il 23/08 |
| **DAX** | **PF 1,397 · DD 7,23% · n 270** | `R101_REFERTO.md` righe 27 e 68 (è R101 che ha messo **agli atti** il n del DAX: IS 175 / OOS 270) |
| **NAS** | 🚫 **NON APPLICABILE** — nessun numero agli atti, nessuna sedia viva | § 2.3 |

**Tolleranza proposta**: **±0,01 su PF, ±0,10 punti % su DD, n ESATTO**.
Stessa di R101, che con quella tolleranza ha riprodotto **entrambi** i metri.

**Se il metro non si riproduce, la FAMIGLIA si ferma** e la sua cella short non
viene nemmeno lanciata: sopra un metro sbagliato non misurerebbe niente.
**Le altre famiglie vanno avanti** (una sedia storta non porta via anche le altre).

> ⚠️ **Il gate sul `n` del DAX ADESSO si applica**, a differenza di R101 che
> dovette scriverlo `-1` = *non dichiarato*. Il numero è entrato agli atti il
> 23/08. **E il sentinella `-1` va confrontato con un cast esplicito**
> (checklist 64: il `-1` posizionale arriva come **stringa**, e `"−1" -gt 0` è
> **vero su Windows e falso su Linux** — è il difetto che il 23/08 fermò la
> famiglia DAX con il metro riprodotto).

### G0-bis · IL DOW SHORT È UNA **RIPRODUZIONE**, non una misura nuova — 🟠 **non fatale, ma rumoroso**

R54 (14/08/2026) ha già girato **esattamente** questa cella, su **esattamente**
questa finestra e questa geometria (`prove/R54a_lato_DOW_apertura.txt`, cella
`0/1`, magic 772601):

| | profit | PF | DD | n |
|---|---:|---:|---:|---:|
| **IS** | **+6.463,44** | **1,511** | **2,68%** | 73 |
| **OOS** | **−2.591,58** | **0,840** | **8,62%** | 73 |

Verdetto R54: **BOCCIATO per MERITO, non per campione** (n 73 ≫ 30).

➡️ **Quindi `R107_DOW_01_short` è un SECONDO METRO.** Deve ridare quei numeri.
**Se non li ridà, il banco è sospetto e anche DAX e NASUSD vanno letti con
riserva** — perché il difetto sarebbe della macchina, non del mercato.

**Perché NON è fatale** (e va detto): R54a pinnava **meno input** (lasciava ~30
al default compilato), R107 li pinna tutti. Che i due insiemi coincidano è
**dimostrato sul lato LONG** (R101 ha riprodotto R54 al centesimo con lo stesso
pinning) e **inferito** sul lato short. Un gate fatale su un'inferenza
fermerebbe il round per una ragione che qui nessuno può diagnosticare (non c'è
MT5). ➡️ **Compromesso**: G0-bis **non ferma la famiglia**, ma finisce nei
**PROBLEMI**, quindi l'esito della riga diventa `PARZIALE` e Claudio **deve**
aprire il referto.

### G1 · MISURABILITÀ (per cella short)

**n OOS ≥ 30** → sotto, il verdetto è **"NON MISURABILE"**, **mai** *"non
funziona"*. Stessa soglia e stessa formulazione di R54 criterio 2 e di R101 G1.
**È l'esito atteso come possibile su NASUSD** (EMA H4 accesa su un lato short in
un mercato che sale).

### G2 · MERITO DEL LATO SHORT — proposta: **quella di R54, identica**

Una cella short diventa **CANDIDATA** solo se:

- **(a)** **PF OOS ≥ 1,10**, **E**
- **(b)** **positiva anche in IS**.

**Perché quella e non un'altra**: è **letteralmente il criterio 3 di R54**. Se si
cambia il metro adesso, il confronto Dow-2026 contro Dow-2025 non vuol più dire
niente — e il Dow è la riga di controllo di tutto il round. È la decisione **D2**
del § 10.

⚠️ **G2 non si legge da solo**: una cella short che passa G2 **non sostituisce**
la sedia viva. Per quello servirebbe il cancello di portafoglio di R46/R54
(*più profitto OOS **e** DD non peggiore*), e comunque una **firma** (G5).

### G3 · COERENZA CROSS-MERCATO — 🔴 il cancello che protegge dal rumore

> **Un lato short verde su UN SOLO indice, dentro una finestra guardata dieci
> volte, è un picco isolato — non un risultato.**

È il criterio 2(c) di R46, quello che in R46 **fermò un candidato che faceva
+31%**. Qui vale così: se lo short è verde su **uno** dei tre e rosso sugli
altri due, **non è un candidato**; è materiale per una domanda, non per una firma.

⚠️ **Eccezione dichiarata**: NASUSD è una **trasposizione** (§ 2.3), non una
sedia. **Un NASUSD rosso non è una smentita** di un eventuale DAX verde: dice
solo che la geometria del Dow non si trasporta. G3 quindi si applica **in pieno
fra DOW e DAX**, e su NASUSD **solo in direzione positiva** (un NASUSD verde
rinforza; un NASUSD rosso non toglie).

### G4 · CAMPIONE (Emendamento regola A e regola B)

L'Emendamento chiede **≥ 150 operazioni**. Attesi: DAX short ~270 (EMA spenta),
Dow short **73** (misurato da R54), NASUSD short ignoto e probabilmente basso.

**Emendamento regola B — la valvola**: *"il campione sottile sospende il giudizio
sul MERITO, mai sul RISCHIO"*.

- **RISCHIO**: si giudica **sempre**, a qualunque `n`. Un DD è un fatto accaduto.
- **MERITO sul DAX** (n atteso ~270): si giudica.
- **MERITO sul Dow** (n 73) e **su NASUSD**: 🔴 **SOSPESO per regola.** Producono
  **indizi** e servono a G3 come conferma di direzione, non come promotori.
  (Stessa scelta firmata in R101, decisione 3.)

### G5 · **NESSUNA PROMOZIONE ESCE DA QUESTO ROUND**

Sta già scritto nel perimetro (`R107_CODA_LATI_SHORT.md` § 3) e si conferma:
**se lo short mostrasse edge, è una FIRMA di modifica contratto (o una sedia
nuova) con referto suo.** Le due sedie toccate stanno sul conto 100k. R107
produce **informazione**, non deploy.

### 5.1 📊 Cosa si scrive nel referto, per ogni cella

Sempre, e sempre col `n` accanto: `profitto IS/OOS · PF IS/OOS · DD IS/OOS ·
n IS/OOS · Δ vs la cella long della stessa famiglia (PF e DD) · peggior giornata
% · esito G1 · esito G2 · esito G3`.

E **la riga della spina dorsale** (§ 4.2): per ogni short, il confronto
**IS contro OOS** con la frase che dice **dove sta la discesa** — non per
concludere, ma perché nessuno legga un IS verde come "funziona" o un OOS rosso
come "non funziona per sempre".

> 🔴 **CONVENZIONE DI SENTINELLA, valida per TUTTE le colonne** (checklist 66):
> un numero **non misurato** si scrive **`n/d`**. Mai `-1`, mai `0.000`.
> `0.000` su un PF è un numero **plausibile** che si legge *"ha perso tutto"*.
> La convenzione vale per profitto, PF, DD, `n` **e** peggior giornata: nel
> difetto di R103 era applicata a metà delle colonne, sei righe sotto il
> commento che la vietava.

---

## 6. 🚫 COSA NON SI SPAZZOLA — e perché

- **Nessun parametro.** Zero griglie. L'unico asse `Y` è `InpMagic`.
- **Nessun filtro nuovo.** Chi volesse "aiutare lo short" con un filtro sta
  facendo **un altro round** (ed è quello che R101 ha già fatto sui long).
- **Nessuna cella `long+short`.** R54 l'ha già misurata sul Dow e l'ha bocciata
  due volte (meno profitto **e** DD quasi doppio). Sul DAX **non è misurata** e
  resta un debito dichiarato: se il DAX short passasse G2, quella cella diventa
  il round successivo, non un'aggiunta in corsa.
- **Nessuna riscalatura della geometria sul NASUSD** (§ 2.3, decisione D1).

---

## 7. 🕳️ IL REGISTRO DEI CADUTI E LA **SECONDA CACCIA** — il caso NASUSD

**La regola** (19/08): quando un round dichiara un motore senza edge, si cercano
**meccanismi alternativi sulla stessa inefficienza**, **mai** *"parametri diversi
dello stesso motore morto"*. Ogni candidato passa la lista dei caduti **prima**
di entrare nell'imbuto.

**Cosa dice `REGISTRO_TEST.md` sul Nasdaq in apertura** (letto il 25/08):

- riga **A4**: *"Nasdaq_Apertura_US · NASUSD · **candela H1 prec**, ora 14:30 ·
  **SOLO LONG**, floor 0-400, buffer 50-350 · real tick · 0% combo pos, best
  **PF 0,91** · 🔴 morto"*;
- *"**CONCLUSIONE M5 (definitiva)**: il breakout M5 in apertura è morto sul
  Nasdaq anche coi filtri di Emiliano"* (baseline PF 0,63-0,84);
- *"**CONCLUSIONE APERTURA (definitiva)**: il breakout M5 in apertura funziona
  SOLO sul DAX, SOLO LONG. Su Nasdaq/FTSE/Dow → morto"*;
- e i capitoli **R97 (ORB)** e **R98 (Momentum)** su NASUSD: **nessun edge**.

**Il registro NON vieta la cella di R107.** E la prova sta **nella stessa
pagina**:

> 🔥 **La stessa "conclusione definitiva" dichiara morto anche il DOW**
> (*"U30USD · Dow · buffer 200 LONG · −9 · PF 0,997 · 🔴 morto"*).
> **E oggi il Dow è una sedia viva che fa PF 1,270.**

Non perché si siano cambiati i parametri: **perché è cambiato il meccanismo.**
Quelle righe misuravano la **rottura secca** del range; la sedia viva entra sul
**RETEST** (`InpEntryMode=2`, range 35', offset 400). Sono due inneschi diversi.
**Il retest sul Nasdaq non risulta misurato in nessuna riga del registro**, e il
lato **short** meno che mai.

➡️ **Verdetto sul passaggio dal registro: la cella si fa, e il round DICHIARA
questa storia** invece di limitarsi a scrivere *"è libera"*.

⚠️ **La clausola di prudenza, per non usare il precedente come un permesso
generale**: la stessa pagina che ha sbagliato sul Dow **può avere ragione sul
Nasdaq**. Su NASUSD abbiamo **tre** verdetti negativi indipendenti (aperture,
ORB, momentum) e **uno** di essi (R98) misura proprio i lati: *"solo SHORT:
IS PF 0,37 · OOS PF 0,92 — gli short perdono ovunque"*. Motore diverso, quindi
**non è un verdetto su questa cella** — ma è un **prior direzionale**, e sta
scritto qui **prima** dei numeri, non dopo.

---

## 8. 📤 COSA PUÒ USCIRE DA R107, e cosa no

**Può uscire:**

- ✅ una **misura** del lato short su tre geometrie di apertura, sulla finestra
  standard, a tick reali;
- ✅ una **riproduzione** (o una smentita) del numero R54 sul Dow;
- ✅ il **primo numero in assoluto** sul lato short della geometria DAX viva —
  la riga A3 del registro è "in coda" da un anno;
- ✅ una **proposta di round successivo**: `long+short` sul DAX, oppure una
  **prova di regime** fatta apposta (§ 4.2).

**NON può uscire:**

- ❌ nessun cambio al forward, nessuna sedia accesa, nessun contratto modificato;
- ❌ nessuna frase del tipo *"il lato short non ha edge"* senza il pezzo
  *"in questa epoca, su questa geometria"*;
- ❌ nessun giudizio sul Nasdaq **in generale** a partire da una trasposizione.

---

## 9. ⚙️ ESECUZIONE

- **24 passate** (6 celle × 2 finestre × 2 gemelle), **12 CSV**, tick reali.
  **[STIMA, non una previsione]**: R101 fece 80 passate sugli stessi due simboli
  in poche ore; qui sono meno di un terzo, più un simbolo nuovo (NASUSD), i cui
  tick sono **già agli atti** dal 2024.09.26 (sonda del 17/08, e R98 ci ha già
  girato sopra). `-OreMax` **10**, che è un tetto sull'**inizio** di nuovi file,
  non un'accetta su un lavoro in corso.
- **Una macchina, un lavoro**: R107 parte solo quando nessun altro round sta
  toccando il terminale.
- **Ripresa**: `-SoloEa 'DAX'` (o `'DOW,NAS'`) e `-SoloCella <file>`.
  In tutti e due i casi **la cella long della famiglia rigira**: è il
  denominatore, e senza denominatore la short non si legge. Costa **2 CSV**,
  non una passata sprecata.
- **Il round non scarica storico** e non tocca `bases\<server>\ticks`.
- **Il round non scrive una riga di MQL5** e non tocca il forward.

---

## 10. ✍️ LE TRE DECISIONI — **[DA FIRMARE]**

> Finché questa sezione porta `[DA FIRMARE]` nel titolo del documento, la corsa
> vera non parte. Si firma **a numeri non visti**: è la regola di casa, e questo
> round tocca **due sedie che stanno sui soldi**.

### D1 · La geometria NASUSD

**Proposta: trasposizione LETTERALE della geometria del Dow** (buffer 1000,
offset 400, in punti assoluti), **con il limite dichiarato** al § 2.3 e la
lettura obbligata *"non si trasporta"* invece di *"non ha edge"*.
**Alternativa scartata**: riscalare buffer/offset per il rapporto dei prezzi o
degli ATR. Scartata perché sarebbe **un parametro nuovo scelto a tavolino senza
misura** — cioè l'inizio della pesca, su un simbolo che ha già tre bocciature.
👉 **[ ] SÌ, trasposizione letterale   [ ] NO, si fa altro (dire cosa)**

### D2 · Il cancello di merito sullo short

**Proposta: identico a R54 criterio 3 — PF OOS ≥ 1,10 E positivo in IS.**
**Alternativa scartata**: un cancello più permissivo (es. "PF > 1,00"). Scartata
perché cambiare il metro adesso rende incomparabile il Dow-2026 col Dow-2025, e
il Dow è la riga di controllo di tutto il round.
👉 **[ ] SÌ, quello di R54   [ ] NO (dire quale)**

### D3 · La finestra di DISCESA dedicata (febbraio-aprile 2025)

**Proposta: NO, non in R107.** Motivo aritmetico al § 4.2: ~60 giorni di borsa
× ~1 operazione/giorno, con l'EMA H4 che taglia gli short → **sotto G1 per
costruzione** su Dow e NASUSD. Un numero che nasce già non misurabile non si
produce. **Al suo posto**: la lettura per spina dorsale del § 4.2 (dichiarativa,
costa zero) e la proposta di un **round di prova di regime** fatto apposta.
👉 **[ ] SÌ, va bene così (solo lettura)   [ ] NO, voglio anche la finestra dedicata**

### 10.1 🟢 Cosa **non** serve firmare, e perché

- **Non serve una nuova verifica a grafico** delle celle vive: R107 non le ha
  toccate, sono la copia byte per byte dei file R101 già verificati da Claudio
  il 23/08 (§ 2.1 e 2.2).
- **Non serve firmare G5**: "nessuna promozione" è già nel perimetro del 25/08.

---

## 11. 🚫 QUELLO CHE R107 **NON** FARÀ, dichiarato

1. **Non promuove e non boccia niente in forward.** G5.
2. **Non giudica il driver.** La riga produce i CSV, li conta e mette a referto i
   delta. **I cancelli G1-G5 li applica il REFERTO DEL ROUND, a mano.** In
   particolare G3 **non è meccanizzabile**: è un ragionamento su tre tabelle.
3. **Non è un walk-forward nuovo** e non ottimizza: zero parametri spazzolati.
4. **Non misura lo spread**, non misura i sotto-periodi, non misura il regime.
5. **Non chiude la domanda sul lato short.** La chiude **per questa epoca e per
   queste tre geometrie** — ed è già più di quanto sapevamo il 24/08.
