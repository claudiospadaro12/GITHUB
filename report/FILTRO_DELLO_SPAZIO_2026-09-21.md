# 📏 IL FILTRO DELLO SPAZIO — 21/09/2026

**Che cosa è**: una **sonda dentro l'EA** che misura, prima di ogni ingresso,
**quanto spazio c'è fino al primo ostacolo sul timeframe superiore** — e che
**di default non fa assolutamente nulla**.

| campo | valore |
|---|---|
| File toccato | `/home/user/GITHUB/mql5/Experts/ABTG_DAX_Apertura_EU.mq5` (magic **770101**) |
| Diff | **460 righe aggiunte, 0 righe cancellate** contro il **PIN SCHIERATO `9fca63d9`** (`git diff --numstat 9fca63d9 HEAD -- mql5/Experts/ABTG_DAX_Apertura_EU.mq5`) |
| Default | `InpSpaceMode = 0` (**OFF**) + `InpSpaceMinR = 0` + `InpSpaceMaxR = 0` |
| Compilato? | ❌ **No.** Nessun MetaEditor qui. Non è mai girato, da nessuna parte |
| Schierato? | ❌ **No.** Nessun preset toccato, nessun `.set`, nessun terminale |
| Gemelli Dow/Nasdaq | ❌ **Non toccati**, per mandato |

---

## ✏️ VERSIONE 2 — RISCRITTO DOPO LA BOCCIATURA DEL CANCELLO (21/09/2026)

La **versione 1 di questo referto è stata BOCCIATA** dal cancello del 09/09
(`controlla_prova.py` + agente `controllo-preventivo`) con **4 difetti bloccanti
e 6 rilievi**. Non è una nota di cortesia: **quattro di quei dieci cambiavano una
conclusione**, e uno avrebbe reso il round **muto**. Dove il testo è stato
corretto, **è scritto che cosa diceva prima e perché era sbagliato** — cancellare
l'errore invece di raccontarlo è il modo di rifarlo.

| # | Difetto | Dove è stato riparato | Classe |
|---|---|---|---|
| **R-1** | 🔴 contro-esempio costruito su **metà** del meccanismo: valeva per il pavimento, **si capovolge** col tetto | § 2, riscritta in 🅰️ / 🅱️ | **520** |
| **R-2** | 🔴 il cancello guardava il ramo di fallimento **rumoroso** mentre il dominante è **silenzioso** | § 4 e tabella dei cancelli, riga 2 | **521** |
| **R-3** | 🔴 file prova intitolato *«pronto»* e **mai passato** da `controlla_prova.py` | § «I FILE PROVA», ora due file **verdi** | **522** |
| **R-4** | 🔴 diff misurata contro l'**antenato** (`cd5bf255`) invece che contro il **pin schierato** (`9fca63d9`) | tabella in testa + § prova del no-op | **523** |
| **R-5** | censimento *«esattamente 2 punti di chiamata»* che **omette** le funzioni accessorie | § ②, ora tabella di 8 righe | **524** |
| **R-6** | nota d'archivio (*«MT5 ignora lo step, 07/08»*) **già ritirata** dal repo | § Fase 2 | **525** |
| **R-7** | 🔑 sonda il cui **intero prodotto** passa da un logger condizionato da un input **non pinnato**, e `Print()` è spento in ottimizzazione | § «PRIMA: il difetto che ha salvato il round» | **526** |
| **R-8** | numeri di riga del sorgente **spostati due volte** | riverificati col `grep`, tutto il referto | *(nessuna classe nuova: è la disciplina già scritta — si rifà il `grep`, non si ricopia)* |
| **R-9** | motivazione **contraddittoria** per tenere il tetto fuori dalla griglia | § Fase 2, sostituita con R-1 | *(vedi 520)* |
| **R-10** | due citazioni imprecise (la barra H4; la r.83-84 della trascrizione) | § 4 e § «IL MECCANISMO» | *(nessuna classe nuova: riverificate sulla trascrizione)* |

Le classi **520-526** sono scritte per esteso in
`backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md`.

---

# 🔴 PRIMA DI TUTTO: I CONTRO-ESEMPI

Questa sezione sta **in testa e non in fondo** perché è la parte che conta di
più. Se leggete solo un pezzo di questo referto, leggete questo.

## 1. 🪦 IL CONTRO-ESEMPIO MISURATO, E VALE PIÙ DI TUTTI GLI ALTRI: **R30**

Non è un'ipotesi: **questo filtro ha già un parente stretto in casa, ed è stato
bocciato con i numeri in mano.**

`SRBlocked()` / `InpUseSRFilter` (`ABTG_Nasdaq_Apertura_US.mq5` r.361-365 e
r.1982 · `ABTG_Apertura_3Ingressi.mq5` r.2097-2136) fa **esattamente la stessa
cosa**: veta l'ingresso se c'è un ostacolo davanti entro N punti. Misurato il
12/08 sul Nasdaq — fonte letta di prima mano, non citata a memoria:
`backtest_pipeline/risultati_archivio/REFERTO_ROUND30_REGALI_AMICO.md`:

| cella | IS profit | IS PF | OOS profit | OOS PF | OOS DD% |
|---|---|---|---|---|---|
| baseline | +69,62 | 1,07 | **+476,33** | 1,27 | 5,77 |
| **SRFilter acceso** | **+221,31** | **1,27** | 🔴 **−56,86** | 🔴 **0,97** | 6,80 |

> 🔴 **La cella PIÙ BELLA in campione era l'UNICA ROSSA fuori campione.**
> Tagliava **13 trade su 99 (13%)** — e **tagliava quelli buoni**. Da allora è
> `InpUseSRFilter=false` in **TUTTI** i preset.

**La differenza fra il nostro filtro e R30 esiste** (ostacoli *dinamici* —
medie e Supertrend — invece di PDH/PDL e numeri tondi; **TF superiore** invece
dello stesso TF; **banda** invece di solo pavimento) **ma è una differenza di
ingredienti, non di famiglia.** Il meccanismo è lo stesso: *"non entrare con un
ostacolo addosso"*.

### 👉 La conseguenza, ed è la ragione per cui il codice è fatto così
1. **Le due soglie nascono a ZERO.** Non esiste ancora un numero: esiste solo
   una distribuzione da misurare. Un default "ragionevole" sarebbe **un numero
   inventato**, ed è precisamente il modo in cui si rifà R30 con un altro nome.
2. **Il MODO 1 (sola misura) è la consegna vera.** Il modo 2 esiste solo perché
   un giorno, *se* i numeri diranno qualcosa, non si debba riscrivere il codice.
3. **Anche il modo 2, con le soglie a 0, non blocca niente.** È verificabile nel
   codice — `stretto` (r.1868) e `largo` (r.1873) nascono **tutti e due** da una
   soglia `> 0` — ed è dichiarato nel log di avvio (r.564-566: *«nessuna soglia
   accesa -> NON bloccherà MAI, nemmeno in modo 2»*).

## 2. 🐂 IN QUALE REGIME QUESTO FILTRO FA PEGGIO — e la risposta è DOPPIA, perché il meccanismo è doppio

Il mandato diceva: *«in un trend forte le medie vengono attraversate di
continuo, quindi è un ammazza-trend»*.

🔴 **Qui la prima stesura di questo referto ha sbagliato, e il cancello del
21/09 l'ha bocciata: aveva costruito il contro-esempio su METÀ del proprio
meccanismo** — il **pavimento** — **e presentato la conclusione come se valesse
per tutto il filtro. Col TETTO acceso la conclusione si CAPOVOLGE.** Il filtro
ha due manopole con **segno opposto**, e vanno risposte separatamente.

### 🅰️ Col solo PAVIMENTO (`InpSpaceMinR > 0`, `InpSpaceMaxR = 0`): **NON è ammazza-trend**

In un **trend forte al rialzo**, le EMA 14/50/100/200 H4 stanno **SOTTO** il
prezzo. Per un **long**, quindi, stanno **dietro le spalle**: `SpazioConsidera()`
le scarta (**r.1699**, `if(d <= 0) return;`), `SpazioFinoAOstacolo()` torna
`DBL_MAX` (**r.1801**), `nessunOstacolo` diventa vera (r.1858) e `stretto`
**non può essere vera** perché è protetta da `!nessunOstacolo` (**r.1868**).
🟢 Nel trend conclamato, sul lato del trend, il **pavimento** è **permissivo**,
non ammazza-trend.

🔴 **Morde altrove, e il posto dove morde è peggio:**

- **Morde all'INIZIO dei movimenti.** Il prezzo è "dentro" il ventaglio delle
  medie **esattamente quando un regime sta cambiando**: è lì che una EMA sta
  poco sopra un long. Il filtro tiene le **continuazioni tardive** e taglia le
  **partenze**. La fonte stessa lo ammette in diretta (r.95, **verbatim**): *«la
  forza da sotto è uscita dal credimento, sta rompendo»* — detto **dopo** aver
  deciso di non entrare per mancanza di spazio. **Avevano rinunciato a un
  movimento che poi è arrivato.**
- **Morde in CONTROTENDENZA.** Su un long controtrend tutte e quattro le medie
  sono davanti: bloccato quasi sempre. Può essere un bene — ma è una **scelta
  direzionale mascherata da filtro di spazio**, e va misurata per lato.
- **Morde nei giorni COMPRESSI**, quando le medie sono ammassate sul prezzo:
  cioè nei giorni in cui i segnali sono già pochi. Il taglio **non è uniforme**,
  si concentra.

### 🅱️ Col TETTO acceso (`InpSpaceMaxR > 0`): **è ESATTAMENTE un ammazza-trend**

La riga che decide è **r.1873**, ed è da leggere carattere per carattere:
```
bool largo = (InpSpaceMaxR > 0 && (nessunOstacolo || spazio > dist*InpSpaceMaxR));
```
👉 `nessunOstacolo` sta in **OR**, non in AND. E `nessunOstacolo` è **la
fotografia esatta del trend conclamato** descritto in 🅰️: tutte le medie dietro
le spalle → spazio infinito → **`largo` è VERA** → in modo 2 l'ingresso viene
**rifiutato**.

🔴 **Quindi il tetto morde proprio il caso che il pavimento lasciava passare, e
quel caso è il migliore del motore**: il long nel rialzo conclamato, lo short nel
ribasso conclamato. Non è un effetto collaterale: è la lettura letterale della
fonte (r.39, *«è troppo distante»*) **applicata a un caso che la fonte non stava
guardando** — lì Emiliano aveva davanti un livello *lontano*, non **nessun
livello**.

### 👉 E LA CONSEGUENZA, che non è prudenza ma semantica
**`InpSpaceMaxR` resta a 0 e NON entra in nessuna griglia** — né in R195a/R195b,
né in un'eventuale fase 2.
🔴 Il motivo **non** è quello scritto nella prima stesura (*«due assi nuovi
insieme si confondono»*): era una ragione **contraddittoria**, perché la griglia
proposta ne portava già due (soglia **e** TF). Il motivo vero è che **pavimento e
tetto non sono due tacche dello stesso asse: sono due meccanismi di segno
opposto**, che mordono su **popolazioni disgiunte** — `stretto` vive **solo** se
`!nessunOstacolo`, `largo` morde **soprattutto** quando `nessunOstacolo`.
👉 **Accendere il tetto significa misurare un ALTRO esperimento**, che merita un
nome, un file prova e un contro-esempio suoi. Mescolarlo alla misura del
pavimento produrrebbe una tabella in cui nessuno saprebbe più quale dei due ha
mosso i numeri.

## 3. 🔗 IL DIFETTO CHE NON ERA NEL MANDATO: la soglia in R è **correlata alla larghezza del range**

La soglia è `spazio >= k × dist`, e su questa sedia `dist` **non è un numero
qualsiasi**: con `InpSLMode = SL_RANGE` lo stop è il **bordo opposto del range di
apertura**. Quindi:

> **range di apertura largo → `dist` grande → il filtro morde di più.**

E la configurazione validata di questa sedia è **proprio quella a range largo**
(`ABTG_DEF_RANGE_MIN 35`: *"fuori campione 8 celle su 8 in utile con 35-45, 0 su
12 sotto"*). 🔴 **Il filtro è quindi sistematicamente più severo nelle mattine
volatili, che sono le mattine su cui l'edge di questa sedia è stato misurato.**

Non è un motivo per non misurarlo. È un motivo per **incrociare i blocchi con la
larghezza del range** quando si leggeranno i numeri: se i blocchi si concentrano
sulle mattine larghe, il filtro non sta selezionando lo spazio, sta selezionando
la volatilità — e allora è un altro esperimento, con un altro nome.

## 4. ⏱️ Gli altri tre modi in cui sbaglia

- **Un ostacolo non è un muro.** Una EMA H4 non è una barriera: il prezzo le
  attraversa continuamente. L'intera premessa (*"la media ferma il prezzo"*) è
  **un'assunzione non misurata**. Il modo 1 serve proprio a metterla alla prova.
- **Il livello è vecchio di ALMENO una barra — e "almeno" è la parte che conta.**
  Si legge lo **shift 1** del TF superiore (niente sguardo nel futuro, scelta
  obbligata). Le barre H4 del server si aprono a 00:00 / 04:00 / 08:00 / 12:00:
  alla decisione delle ~08:35 server la barra **in corso** è quella aperta alle
  **08:00**, quindi lo shift 1 è la barra **aperta alle 04:00 e CHIUSA alle
  08:00**. 🔴 I **~35 minuti** sono quindi un **LIMITE INFERIORE**, non il
  ritardo tipico: **quel livello non cambia più fino alle 12:00 server**, perché
  è solo allora che la barra delle 08:00 chiude e lo shift 1 scorre. Un retest
  che scatta alle 11:00 sta leggendo una EMA vecchia di **tre ore**.
  Trascurabile per EMA100/200, **non** trascurabile per EMA14 H4.
- **Il fail-open asimmetrico — e adesso si CONTA.** Se un handle non nasce o
  `CopyBuffer` torna a vuoto, quell'ostacolo **non si conta** e il filtro lascia
  passare. È il verso giusto in cui sbagliare per un cancello — ma vuol dire che
  **i numeri del modo 1 sono un limite INFERIORE**.
  🔴 **E qui il cancello del 21/09 ha trovato il difetto che avrebbe reso la
  misura illeggibile senza che nessuno se ne accorgesse.** La prima stesura
  chiedeva di controllare che il giornale **non contenesse** righe *"handle
  EMAxx non creato"*. Quella riga però esce **solo** quando `iMA()` torna
  `INVALID_HANDLE` (r.1683-1686): è il ramo **raro, e per fortuna rumoroso**.
  Il ramo **probabile** è l'altro — `CopyBuffer(...) < 1` (r.1785), cioè
  l'**EMA200 su H4 non ancora calcolata a inizio finestra**: servono ~200 barre
  H4 ≈ **33 giorni** — e quel ramo faceva `continue` **in silenzio**. 👉 Un
  giornale pulito sarebbe stato compatibile **sia** con *"tutti gli ostacoli
  letti"* **sia** con *"metà degli ostacoli mai guardata"*, e la distribuzione
  sarebbe risultata spostata verso `nessun ostacolo` senza spiegazione.
  🟢 **Riparato nel codice**: quel ramo ora incrementa `gSpazioBufKo` (r.1787),
  scrive la sua riga (r.1788-1789) e il riepilogo di fine corsa stampa
  **`FILTRO SPAZIO - letture di ostacolo FALLITE: N`** (r.716-717). **Il
  cancello si punta su quel numero** — vedi la tabella «cosa serve per
  firmarlo».

## 5. 🚦 E il contro-esempio operativo: **oggi non c'è un modo indolore di metterlo in campo**

Il modo 1 è prezioso perché misura **sulle operazioni vere**. Ma:

- la **challenge FTMO è viva da stamattina** (21/09) e le sedie stanno operando;
- mettere il modo 1 in campo significa **ricompilare e riattaccare** la sedia
  `770101`, che nel censimento del 07-08/09 risulta attaccata sul terminale del
  **conto REALE** (`C:\BCM_Reale`, `report/giornata_2026-09-07.md` r.63)
  — perimetro **esplicitamente fuori mandato**;
- e la procedura di aggiornamento di questo EA richiede **RIPRISTINA**, che
  rimette i default compilati (è la causa misurata del sizing sbagliato del
  23/07-14/08, fix C4 del 02/09).

🔴 **Quindi: il modo 1 in campo NON è gratis e NON è una decisione nostra.** La
misura che si può fare **subito e a costo zero di rischio** è quella **nel
tester**. È quella che propongo qui sotto.

---

# 🎬 IL MECCANISMO E DA DOVE NASCE

Fonte: `trascrizioni/LIVE_EMILIANO_2026-04-10.txt`. Righe **testuali**:

**Il pavimento — troppo poco spazio (r.71-73):**
> *«Vai a fare l'analisi multi-frame. Siamo in H1, vai in H4. In H4 c'è spazio
> per portare del profitto? C'abbiamo subito la media.»*
> *«Cosa può succedere? C'è poco spazio. Allora, non si può fare. Ovviamente, in
> maniera cautelativa, è giusto tirare il suo piede dall'acceleratore.»*

**Quanto è "poco" (r.83 — tutta la citazione sta lì, e solo lì):**
> *«Perché c'è traffico sotto i minimi della notte c'è traffico, 30 punti,
> giusto? Secondo me sono pochini.»*
>
> *(🔴 La prima stesura attribuiva questo passo a «r.83-84» e ci aggiungeva un
> secondo pezzo, «Sono pochini.». Verificato sul file: la **r.84 è VUOTA**, tutta
> la citazione sta in **r.83**, e quel secondo pezzo è un **doppione** di
> «Secondo me sono pochini» già contenuto nella stessa riga. La ripresa vera sta
> in **r.85** ed è un'altra frase: «Sono pochini. Allora, io lo aspetterai sulla
> media 200. Poi ti dico dove sono posizionato io.». Una citazione gonfiata non
> aggiunge prova: la toglie.)*

**Il tetto — troppo lontano (r.39):**
> *«Sono 170 punti. Se dovessimo andare a questo livello qua, nel prezzo attuale
> sono 500 rubi, è troppo distante.»*
>
> *(«rubi» è un errore di trascrizione per «punti»: la riga successiva riprende
> con «500 punti? Ma di cosa stai parlando?». Cito com'è scritto, non come mi fa
> comodo.)*

**E la riga che vale più di tutte — r.93**, dove il meccanismo è per intero in
tre righe, compresi i numeri e la scala dei timeframe:
> *«quando piazzo l'ordine non mi basta vedere che ce l'ho in H1 vado in H4, in
> H4 c'è spazio per scendere, sì c'è un po' di spazio ma questa zona in realtà la
> vedo pericolosa, quindi i minimi da notte oggi non li farei **perché c'è poco
> spazio ma poco spazio sono circa 30 punti 26 punti in realtà** la media
> dovrebbe sostenere la media in H4 **anche se la media è a 14** [...] poi vado a
> vedere in D1 abbiamo dello spazio»*

👉 Tre cose **confermate dalla fonte**, non dedotte da noi: l'ostacolo è una
**media sul TF superiore** (e nomina proprio la **14**, che è `InpSpaceEma1`);
*"poco"* vale **26-30 punti**; e la scala è **H1 → H4 → D1**, che è esattamente
il ruolo di `InpSpaceTF`.

👉 **È una BANDA, non un pavimento.** Si sta fermi sia quando davanti c'è
traffico subito, sia quando il livello di riferimento è a casa di Dio.

---

# 🧱 LE DECISIONI DI PROGETTO, E PERCHÉ

| # | Decisione | Perché |
|---|---|---|
| **1** | **Soglie in multipli di R**, non in punti | *«30 punti»* sul DAX e sul Nasdaq sono due cose diverse. `spazio >= k × dist` si normalizza da sola su qualunque simbolo. E dice una cosa vera: **se lo spazio è minore del bersaglio, l'operazione non ci può arrivare** — aritmetica, non opinione |
| **2** | **Tre modi**, con lo 0 = no-op assoluto | Il modo 1 misura senza cambiare un trade. È la differenza fra proporre un'idea e proporre un numero |
| **3** | 🔴 **Soglie a ZERO di default**, e il modo 2 con soglie a 0 **non blocca** | R30. Nessun numero è stato misurato: inventarne uno "ragionevole" è il modo in cui si sbaglia |
| **4** | **Si misura SEMPRE, si filtra solo dopo** | `SpazioFuoriBanda()` conta, riempie l'istogramma e scrive la riga **prima** di guardare le soglie. Con le soglie spente il modo 1 è una **sonda a pieno regime**, non un filtro inerte |
| **5** | **Istogramma in R + segnali persi PER LATO** | Il pavimento di frequenza è **1,00 op/giorno per FAMIGLIA** (firma 07/09) e la famiglia Aperture sta a **1,407**. Un filtro che taglia il 13-30% può portarla sotto: sarebbe un PF più bello su una sedia **non schierabile**. Il costo in frequenza è **parte della misura**, non un dettaglio |
| **6** | **Solo barre chiuse (shift 1)** | La barra 0 del TF superiore si muove ancora: usarla sarebbe leggere un livello che nel backtest non esisteva |
| **7** | **Ostacoli dietro le spalle scartati** | Un long non è ostacolato da una media che gli sta sotto |
| **8** | **Agganciato solo a `MonitorRetest()`** | È il motore che gira davvero su questa sedia. 🟠 Su altri motori il filtro **non verrebbe mai interrogato**: il codice lo **dice a voce alta** all'avvio, perché *"un flag acceso che non fa niente e non lo dice"* è il bug del 05/08 daccapo |

### ⚠️ La metà ambigua, dichiarata e non nascosta — ed è la stessa di 2-🅱️
Con `InpSpaceMaxR > 0`, il caso **"nessun ostacolo davanti"** viene trattato come
**"troppo lontano"** → morde (**r.1873**, `nessunOstacolo` in OR). È la lettura
fedele di r.37-39 (*il livello non è governabile*), ma è **una scelta, non un
fatto** — 🔴 **e quella scelta è precisamente ciò che trasforma il filtro in un
ammazza-trend**, come misurato nel contro-esempio 2-🅱️ qui sopra. Il modo 1
misura quante volte capita (colonna `nessun ostacolo` dell'istogramma): **quel
numero dirà quanto costerebbe.** Finché `InpSpaceMaxR = 0`, non ha nessun
effetto — ed è per questo che **resta a 0 e fuori da ogni griglia**.

### 🚫 Quello che il filtro NON fa
❌ non tocca parziale, breakeven, trailing, chiusura di fine sessione · ❌ non
tocca il sizing · ❌ non tocca gli altri motori d'ingresso · ❌ **blocca solo
l'APERTURA**, mai la gestione di una posizione già viva.

---

# ✅ LA PROVA CHE IL DEFAULT È UN NO-OP — si vede, non si dice

**Misura oggettiva, prima di tutto — e contro il PIN SCHIERATO, non contro
l'antenato del lavoro.**

🔴 La prima stesura misurava contro `cd5bf255`, che è il commit da cui *questo
ramo* è partito: quel numero dice **quanto ho scritto io**, non **quanto il file
si discosta da ciò che gira in campo**. Il metro giusto è il pin schierato.

```
git diff --numstat 9fca63d9 HEAD -- mql5/Experts/ABTG_DAX_Apertura_EU.mq5
460     0     <- 460 aggiunte, ZERO cancellazioni
```
`9fca63d9` è il pin dichiarato per questa sedia in
`report/SCHIERAMENTO_FTMO_2026-09-20.md` r.179 (`770101` DAX Apertura · `D30EUR`
M5, 2425 righe attese). **460 e non più 429** perché dopo la bocciatura del
cancello sono entrate tre patch: la **guardia interna** in `SpazioFuoriBanda`
(r.1854), il contatore **`gSpazioBufKo`** (r.482, r.1787) e la riga di riepilogo
delle **letture fallite** (r.714-717).

👉 **E perché nella prima stesura i due numeri coincidevano?** Perché su
*questo* file, fra pin e antenato, non c'è nessuna differenza:
```
git diff 9fca63d9 cd5bf255 -- mql5/Experts/ABTG_DAX_Apertura_EU.mq5
(nessun output)
```
🔴 Cioè: era **una coincidenza, non una verifica**. Sarebbe bastato che qualcuno
avesse toccato la sedia fra il 19 e il 21 perché il referto dichiarasse un numero
che non descriveva niente — e nessuno se ne sarebbe accorto.

E l'elenco delle righe **originali** cancellate è **vuoto**: nessuna riga
preesistente è stata modificata o rimossa. Il codice vecchio è tutto lì, intatto.

### Il percorso del codice con `InpSpaceMode = 0`, punto per punto

**① Il cancello d'ingresso — r.1945-1949 (ramo LONG) e r.1986-1990 (ramo SHORT)**
```
if(InpSpaceMode != ABTG_SPACE_OFF && !skip && dist > 0 &&
   SpazioFuoriBanda(true, entry, dist))
  {
   if(InpSpaceMode == ABTG_SPACE_ATTIVO) skip = true;
  }
double lot = skip ? 0.0 : CalcLotByRisk(dist);     <- riga ORIGINALE, intatta
```
`InpSpaceMode != ABTG_SPACE_OFF` è **falsa alla prima clausola**. MQL5 valuta
`&&` in **corto circuito**: `SpazioFuoriBanda()` **non viene chiamata**. Quindi
a default: nessun calcolo, nessun handle creato, nessuna riga di log, `skip`
**mai toccata**. Le due righe successive (`lot`, `tp`) e la `if(!skip && lot > 0
&& dist > 0)` sono **le righe originali, byte per byte**.

**② Le funzioni nuove sono IRRAGGIUNGIBILI a default — e il censimento è
ELENCATO PER NOME, non riassunto in un numero.**

🔴 La prima stesura scriveva *«verificato con grep: esistono esattamente 2 punti
di chiamata»*. È vero **solo per `SpazioFuoriBanda`**: le due funzioni
**accessorie** (`SpazioTfLabel` e `SpazioBandaTesto`) ne hanno altri, e un
censimento presentato come esaustivo che li omette è un censimento che **non si
può controllare**. Eccolo intero, `grep` per `grep`:

| funzione | definita a | chiamata da | fuori dalla guardia? |
|---|---|---|---|
| `SpazioFuoriBanda` | r.1848 | r.1946 (LONG) · r.1987 (SHORT) — le due righe ① | ❌ no |
| `SpazioFinoAOstacolo` | r.1759 | r.1857, dentro `SpazioFuoriBanda` | ❌ no |
| `SpazioAssicuraHandles` | r.1667 | r.1765, dentro `SpazioFinoAOstacolo` | ❌ no |
| `SpazioConsidera` | r.1695 | r.1792 · r.1798, dentro `SpazioFinoAOstacolo` | ❌ no |
| `SpazioSupertrendLivello` | r.1712 | r.1797, dentro `SpazioFinoAOstacolo` | ❌ no |
| `SpazioBucket` | r.1808 | r.1865, dentro `SpazioFuoriBanda` | ❌ no |
| **`SpazioTfLabel`** | r.1652 | r.1685 (`SpazioAssicuraHandles`) · r.1789, r.1883, r.1886 (catena sopra) · **r.556 (`OnInit`)** | ❌ no: la r.556 è dentro `if(InpSpaceMode != ABTG_SPACE_OFF)` aperto a **r.552** |
| **`SpazioBandaTesto`** | r.1821 | r.1894 (`SpazioFuoriBanda`) · **r.556 (`OnInit`)** · **r.702 (`OnDeinit`)** | ❌ no: r.556 sotto la guardia di r.552, r.702 sotto quella di **r.696** |

👉 **Il no-op regge lo stesso** — ogni singolo punto di chiamata, accessorie
comprese, sta dietro un `if(InpSpaceMode != ABTG_SPACE_OFF)` — **ma adesso lo si
può verificare senza fidarsi di me**: la tabella si rifà con otto `grep` e i
numeri o tornano o no.

🟢 **E c'è una cintura in più, messa dopo il cancello**: `SpazioFuoriBanda` si
difende **da dentro** (r.1854, `if(InpSpaceMode == ABTG_SPACE_OFF) return(false);`),
esattamente come fa il parente `SRBlocked` (`ABTG_Apertura_3Ingressi.mq5`
r.2099). Se un domani qualcuno la chiamasse da un ramo nuovo **dimenticando la
guardia**, il default resterebbe un no-op.

**③ Gli handle indicatore non nascono nemmeno.** Sono creati **pigramente**,
dentro `SpazioAssicuraHandles()`, **non** in `OnInit`. A modo spento quella
funzione non viene mai raggiunta → `gSpaceEmaH[]` resta `INVALID_HANDLE` → l'EA
**non crea un solo handle in più** di prima. *(Ecco perché non sono in `OnInit`:
è una scelta, non una dimenticanza.)*

**④ `OnInit` e `OnDeinit`: log identici.** Entrambe le aggiunte sono dentro
`if(InpSpaceMode != ABTG_SPACE_OFF)`. Il ciclo di rilascio in `OnDeinit` scorre
4 handle tutti `INVALID_HANDLE` e non fa nulla. 👉 **Un giornale prodotto prima e
uno prodotto dopo si confrontano riga per riga.**

**⑤ Il `.set` esistente resta valido.** I `.set`/`.ini` MT5 sono `nome=valore`,
**indipendenti dall'ordine**: i preset attuali non nominano gli input nuovi,
che quindi atterrano sul default compilato (**0 = spento**). Nessun preset è
stato aperto né modificato.

### 🧪 E il controllo che romperebbe tutto questo, se fosse falso
> **Il modo 1 deve riprodurre il P/L del modo 0 AL CENTESIMO.**

Non è una formalità: è **il** test di regressione. Il modo 1 tocca handle,
contatori e log ma **non deve spostare un solo trade**. Se il tester dà anche un
centesimo di differenza fra `InpSpaceMode=0` e `InpSpaceMode=1` a parità di
tutto il resto, **c'è un bug e la misura non si legge**. Questa cella va girata
**per prima**.

---

# 📐 COME SI MISURA

## 🔴 PRIMA: IL DIFETTO CHE HA SALVATO IL ROUND — la sonda sarebbe stata MUTA

È il rilievo più istruttivo dei dieci, e non si vede leggendo il codice: si vede
leggendo **come il codice viene lanciato**.

**Tutto** il prodotto di questa sonda — la riga per segnale, l'istogramma, il
riepilogo, il contatore delle letture fallite — passa da **`ABTGLog()`**
(r.495-500), che stampa **solo se `InpVerbose`** (r.497). E `Print()` in MT5
**NON viene eseguito in OTTIMIZZAZIONE**.

👉 Cioè: la prima stesura proponeva di raccogliere la distribuzione con un **file
prova**, che è per definizione un'**ottimizzazione**. Il round sarebbe girato
fino in fondo, avrebbe prodotto un CSV di risultati perfettamente normale, e il
giornale sarebbe stato **VUOTO**. 🔴 **E un giornale vuoto è indistinguibile da
"il filtro non è mai stato interrogato"**: avremmo concluso qualcosa, o peggio
concluso niente, senza sapere di non aver misurato.

**Perciò il lavoro si spezza in due, ed è così che è stato congelato:**

| | che cos'è | come si lancia | cosa produce |
|---|---|---|---|
| **FASE 0** | il test di regressione | **ottimizzazione a 2 celle** (file prova) | i **numeri del report**: bastano, il giornale non serve |
| **FASE 1** | la misura vera | 🔴 **TEST SINGOLO**, `Optimization=0` | il **giornale**, che è tutta la consegna |

🟢 E `InpVerbose` è adesso **pinnato a `1`** in entrambi i file prova, così la
Fase 0 non dipende da un default che qualcuno potrebbe cambiare sul grafico.

## Fase 0 — il controllo di sanità (obbligatorio, prima di tutto) — **DUE FILE PROVA, E PASSANO IL CANCELLO**

🔴 **La prima stesura di questo referto intitolava questo blocco «Il file prova,
pronto» e poi ammetteva, due righe sotto, di non averlo creato** — mentre il
corpo che mostrava sarebbe stato **bocciato** da `controlla_prova.py`. "Pronto"
era una parola sbagliata su una cosa mai passata dal cancello.

🟢 **Adesso i due file esistono, sono congelati e sono VERDI:**

| file | lato | esito di `python3 backtest_pipeline/controlla_prova.py` |
|---|---|---|
| `backtest_pipeline/prove/R195a_spazio_LONG_DAX_D30EUR.txt` | **LONG** | ✅ `pin=7 celle=2 OK` · 4 passate · **0 problemi** |
| `backtest_pipeline/prove/R195b_spazio_SHORT_DAX_D30EUR.txt` | **SHORT** | ✅ `pin=7 celle=2 OK` · 4 passate · **0 problemi** |

**Come è stato risolto il problema dei due assi**: non facendo la griglia.
L'asse è **uno solo** — `InpSpaceMode=0||0||1||1||Y`, cioè **spento contro sola
misura** — e tutto il resto è **pinnato** (7 pin, `InpVerbose` compreso). Attesa
congelata prima dei numeri: **profitto, PF, DD ed `n` IDENTICI AL CENTESIMO** fra
le due passate. Se si muove un centesimo, **c'è un bug e il round si ferma lì**.

*(Nota sul cancello: `controlla_prova.py` riconosce l'asse come `ENUM_ABTG_SPACE`
e conta **2 celle** fra 0 e 1 ignorando il passo — è la regola degli enum,
dimostrata sotto.)*

## Fase 1 — LA MISURA VERA (modo 1, soglie spente) 🥇 — **TEST SINGOLO, non un file prova**
**Questa è la consegna.** Nessuna soglia, nessuna griglia, nessuna scelta: si
raccoglie **la distribuzione dello spazio** su tutti i segnali storici.

🔴 **E non può vivere nel formato dei file prova**, per due motivi che si
sommano: (a) in ottimizzazione il giornale è muto (vedi sopra); (b) un file prova
**senza asse Y** viene bocciato dal cancello con *"celle = 0"* — **e fa bene**,
perché quel formato esiste per pilotare ottimizzazioni. Le impostazioni della
Fase 1 sono quindi scritte **in fondo ai due file prova**, come testo, da
riportare a mano nel tester (o in un `.ini` con `Optimization=0`).

- **2 corse** (una per lato), `InpSpaceMode=1`, `InpSpaceMinR=0`, `InpSpaceMaxR=0`,
  `InpVerbose=1`, `Optimization=0`.
- Output da leggere nel **giornale Esperti** (NON dal report):
  - una riga per segnale: `SPAZIO long: entry ... ostacolo EMA100 H4 a ... = 0.66R ...`
  - in coda, `FILTRO SPAZIO - distribuzione LONG/SHORT: <0,5R=.. | 0,5-1R=.. | ...`
  - 🔴 e `FILTRO SPAZIO - letture di ostacolo FALLITE: N` — **se N > 0 la
    distribuzione è spostata e i numeri sono un limite inferiore.**
- **L'analisi che conta** si fa **incrociando le righe di log con i trade del
  report** (entrambi hanno prezzo d'ingresso e orario): *lo spazio davanti
  separa i vinti dai persi, sì o no?* 🔴 **Se la risposta è NO, il lavoro finisce
  qui e il modo 2 non si accende mai.** Costo totale: quasi zero.

## Fase 2 — solo SE la fase 1 dice di sì: la curva della soglia
Griglia `InpSpaceMode=2`, `InpSpaceMinR` = **0 / 0,5 / 1,0 / 1,5 / 2,0** ×
`InpSpaceTF` = **H1 / H2 / H3 / H4** → **20 celle per finestra, 40 pass**.
- 🔑 **`InpSpaceMinR=0` È IL CONTROLLO dentro la griglia**: deve riprodurre la
  baseline esatta. Senza, la tabella non ha metro (stessa disciplina del
  `InpTrailStartR=0` nella prova gemella).
- ⚠️ `InpSpaceTF` è `ENUM_TIMEFRAMES`: **MT5 ignora lo step** e spazzola i membri
  fra start e stop → H1→H4 dà H1, H2, H3, H4.
  🔴 **La prova NON è più quella "misurata il 07/08"**, che questo repo ha già
  **ritirato**: `report/R128_USCITA_APERTURE_2026-09-11.md` r.135-141 la
  classifica *«LA VERIFICA CHE NON DISCRIMINA»* — era
  `InpTrailTF=5||1||1||5`, da M1 a M5 con passo 1, dove **aritmetica ed
  enumerazione danno la STESSA risposta** (1,2,3,4,5). Citarla oggi sarebbe
  appoggiarsi a una nota d'archivio che in casa non vale più.
  🟢 **La conclusione resta vera, e la prova buona è un'altra**, reale e in
  archivio: `InpTF=16385||15||1||16408||Y` ha prodotto **11 righe**
  (`15, 20, 30, 16385, 16386, 16387, 16388, 16390, 16392, 16396, 16408`, oltre
  40 CSV in `risultati_prove/`) dove **l'aritmetica ne avrebbe fatte 16.394** —
  `backtest_pipeline/prove/R128_USCITA_CRITERI.md` r.583-592, riverificata in
  `report/AUDIT_AL_CENTESIMO_2026-09-12.md` r.103-110. E il driver lo implementa
  così apposta: `backtest_pipeline/walkforward_generico.ps1` r.786-789
  (*«ENUM: MT5 IGNORA LO STEP e spazzola i membri fra start e stop»*, con il
  conteggio per appartenenza e non per aritmetica) e la tabella dei membri a
  r.405-410, `PERIOD_M20=20` compreso.
  ⚠️ *(La nota d'archivio citava `r.348-349 e r.526-530`: riverificato oggi,
  quelle righe nel file di HEAD sono tutt'altro — download degli include e nota
  su `@FINOA`. Numeri di riga corretti qui sopra.)*
- Il tetto `InpSpaceMaxR` **non entra in questa griglia**, e il motivo **non** è
  quello scritto nella prima stesura (*«due assi nuovi insieme»* — ragione
  contraddittoria, visto che questa griglia ne ha già due: soglia **e** TF).
  🔴 Il motivo vero è il contro-esempio **2-🅱️**: pavimento e tetto sono **due
  meccanismi semanticamente diversi**, di segno opposto, che mordono su
  **popolazioni disgiunte**. Accendere il tetto non aggiunge una tacca a questo
  esperimento: **ne apre un altro**, che vuole un nome, un file prova e un
  contro-esempio suoi.

### 📁 I FILE PROVA — esistono, sono due, e sono passati dal cancello

🔴 **Qui la prima stesura aveva il difetto più imbarazzante del lotto**: il
blocco si intitolava *«Il file prova, PRONTO»* e la riga successiva ammetteva
*«Non l'ho creato io»*. Un corpo di file prova stampato in un referto **non è un
file prova**: è un suggerimento. E quel corpo, passato oggi da
`controlla_prova.py`, sarebbe stato **bocciato** — portava due assi (soglia e TF)
per una misura che di assi non ne vuole nessuno, e nessun pin su `InpVerbose`.

🟢 **Adesso i due file esistono, sono congelati in repo e sono VERDI:**

| file | lato | asse | cancello |
|---|---|---|---|
| `backtest_pipeline/prove/R195a_spazio_LONG_DAX_D30EUR.txt` | **LONG** | `InpSpaceMode` 0→1 | ✅ `pin=7 celle=2 OK` · 4 passate · **0 problemi** |
| `backtest_pipeline/prove/R195b_spazio_SHORT_DAX_D30EUR.txt` | **SHORT** | `InpSpaceMode` 0→1 | ✅ `pin=7 celle=2 OK` · 4 passate · **0 problemi** |

Corpo (identico nei due file salvo il lato):
```
@SIMBOLO  D30EUR
@PERIODO  M5
@DAQUANDO 2024.09.26

InpAllowShort=0||0||0||0||N
InpRiskPercent=1.0||1.0||0||1.0||N
InpVerbose=1||1||0||1||N
InpSpaceMinR=0||0||0||0||N
InpSpaceMaxR=0||0||0||0||N
InpSpaceTF=16388||16388||0||16388||N
InpSpaceMode=0||0||1||1||Y
```

**👉 Come è stato risolto il problema dei due assi: non facendo la griglia.**
La domanda della Fase 0 non è *"quale soglia è la migliore"* — è *"il modo 1
sposta un trade, sì o no?"*. Quella domanda vuole **un asse solo**, a **due
valori**, e **tutto il resto pinnato**: 7 pin, `InpSpaceTF` compreso (che è
pinnato, non spazzolato) e `InpVerbose` compreso. Il tetto e il TF **non
entrano**: entrerebbero in un altro esperimento (2-🅱️ e il punto sopra).

⚠️ **I pin non sono facoltativi** (stessa lezione della prova gemella):
`InpAllowShort=0` perché il SOLO LONG del 07/08 è stato fatto **sul grafico, non
nel codice** (nel sorgente è ancora `true`); `InpRiskPercent=1.0` perché il
`#define` dice 1,0 ma tutte le fasi precedenti girano all'1% e al 2% i numeri
non si confrontano più con niente; 🟢 **`InpVerbose=1`** perché **tutta** la
consegna della sonda passa da `ABTGLog` (vedi il riquadro in testa a questa
sezione) e un default non è una garanzia.

⚠️ **Regola dei due lati (25/08)**: non una prova con un flag, **due file
separati**. Il lato short non si dà per buono.

🔴 **E la Fase 1 NON è in questi file, ed è giusto così**: il formato dei file
prova pilota ottimizzazioni, e un file senza asse Y il cancello lo boccia con
*"celle = 0"*. Le impostazioni della Fase 1 (**test singolo**, `Optimization=0`,
`InpSpaceMode=1`) stanno **in fondo a ciascuno dei due file**, come testo.

## 🕐 Tempo macchina
🔴 **Non ho un numero misurato e non lo invento.**
- **FASE 0**: `controlla_prova.py` conta **2 celle × 2 finestre = 4 passate** per
  file, quindi **8 passate** in tutto per i due lati. Trascurabile.
- **FASE 1**: **1 corsa per lato**, test singolo. Trascurabile.
- **FASE 2** (solo se la fase 1 dice di sì): stessa geometria, stesso simbolo,
  stessa finestra della prova `backtest_pipeline/prove/ABTG_DAX_Apertura_EU.txt`,
  che è da **50 pass** contro i **40** della griglia proposta → costo dello
  **stesso ordine di grandezza**, ricavabile dal registro di quella corsa.

🖥️ **E gira sul PC DI BACKTEST, non sul VPS** (firma del 21/09, dopo che stamattina
il tester ha inchiodato la macchina delle sei sedie).

---

# ✍️ COSA SERVE PER FIRMARLO

| # | Cancello | Stato |
|---|---|---|
| 1 | Modo 1 riproduce il modo 0 **al centesimo** | ⏳ da girare |
| 2 | 🔴 **`FILTRO SPAZIO - letture di ostacolo FALLITE:` deve essere `0`** (r.716-717) — **e in più** il giornale non contiene righe *"handle EMAxx non creato"* (r.1685-1686) | ⏳ da girare |
| 3 | La fase 1 mostra che lo spazio **separa vinti e persi** | ⏳ **è il cancello vero**: se no, si chiude qui |
| 4 | La soglia scelta regge **fuori campione**, non solo IS | ⏳ — è esattamente dove R30 è morto |
| 5 | **Centro dell'altopiano, MAI il picco**; i vicini (soglia **e** TF) anch'essi migliori | ⏳ |
| 6 | Costo in **frequenza** per lato: la famiglia resta **≥ 1,00 op/giorno** | ⏳ |
| 7 | **Due lati** misurati separatamente (25/08) | ⏳ |
| 8 | I **file prova** passano `controlla_prova.py` | ✅ **fatto**: R195a e R195b, `celle=2`, 4 passate, **0 problemi** |
| 8-bis | La **riga di lancio** passa il cancello (`controlla_riga.py` + `controllo-preventivo`) | ⏳ la riga non è ancora stata scritta |
| 8-ter | 🔴 La **Fase 1 NON parte come ottimizzazione** (`Optimization=0`) e `InpVerbose=1` | ⏳ — se salta, il giornale è muto e la misura non esiste |
| 9 | Firma di Claudio prima di qualunque cosa vada in campo | ⏳ |

🔴 **In assenza di tutto questo: NON SI TOCCA NIENTE.** I default restano 0/0/0,
che è esattamente il comportamento di oggi.

---

# 🧭 IN SINTESI, da socio

🟢 Quello che è andato **bene**: il meccanismo della live è stato tradotto in una
forma **misurabile** (in R, non in punti; banda, non pavimento) e — soprattutto —
in una forma che **misura prima di filtrare**. Il modo 1 ci fa sapere quanto
costerebbe l'idea **senza rischiare un euro e senza spostare un trade**.

🟢 **E quello che è andato bene davvero, il 21/09**: il cancello ha bocciato la
prima stesura di questo referto con **4 difetti bloccanti e 6 rilievi**, e uno
solo di quelli — la sonda che passa tutta da `ABTGLog`, con `Print()` spento in
ottimizzazione — **avrebbe reso il round MUTO senza che nessuno se ne
accorgesse**. Non sarebbe stato un errore rumoroso: sarebbe stato un CSV normale
e un giornale vuoto. 👉 **È il metodo che funziona, non una lista di colpe**: le
correzioni sono arrivate prima che il lavoro uscisse. Le sette classi nuove
(**520-526**) sono in `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md`.

🟠 Quello che va detto **chiaro**: questa è **ponteggio**, non una sedia. Non
avvicina di un centimetro il 1° ottobre finché la fase 1 non produce un numero.
E c'è un precedente misurato (**R30**) che dice che questa famiglia di filtri
**ha già mentito una volta**, ed era molto convincente mentre lo faceva.

🔴 E la cosa più onesta di tutte: **il risultato più probabile di questa misura è
che il filtro non serva.** Il codice è scritto apposta perché, in quel caso, non
ci sia niente da smontare — basta lasciare i default dove sono.
