# ✍️ COSA DEVE DECIDERE E FIRMARE CLAUDIO
_Aggiornato: 10/09/2026, sera. **21 giorni al 1° ottobre.**_

Tre tipi di riga, e sono diversi:
- 🖊️ **FIRMA** — una decisione. La prendi tu, io non posso.
- 🖱️ **MANO** — un lavoro manuale su MT5 che solo tu puoi fare.
- 📏 **MISURA** — un numero che manca. Nessuna decisione, serve solo il dato.

---

# ⏸️ IN STANDBY PER DECISIONE DI CLAUDIO (08/09 sera)
**`ABTG_ImpulsoApertura` (magic 769800)** — l'EA scritto oggi che tira fuori
DAX SHORT e NASDAQ LONG nativamente. Avevo proposto il suo **passo 0 di
conteggio** (il round runner lo compilerebbe da solo): Claudio ha detto
_"teniamolo in standby"_. 👉 **Non lo lancio.** Il file prova non e' ancora
scritto: quando arriva il via, sono dieci minuti.

**`ABTG_OpeningReversalB`** e' invece **ARCHIVIATO** con verdetto scritto
(12 celle, mai piu' di 3 operazioni, frequenza 128 volte sotto il pavimento):
`report/P0_OPENINGREVERSALB_2026-09-08.md`. Ha la sua porta di rientro se una
misura nuova gli ridara' una ragione.

---

# 🔴 URGENTI — bloccano la strada verso il 1° ottobre

## 0. 🖊️ R125 — FIRMA SUI CRITERI, A NUMERI NON VISTI
📄 `backtest_pipeline/prove/R125_ORB_COSTO_CRITERI.md` · dossier `report/ROUND_ORB_ATR_PS5_2026-09-10.md`
💰 **Costo: ~7 minuti di macchina** (66 passate x 0,101 min/passata, ritmo MISURATO su R88).
🚦 **Sei giri di cancello, sei FAIL, tutti corretti.** Il sesto chiude:
*"SI', R125 e' lanciabile oggi con i buchi dichiarati"* — e i criteri ammettono
**una sola lettura**, dimostrato su **200.000 griglie**, non promesso.

### 🟢 COSA COMPRI CON LA FIRMA — sei MISURE
1. Se sull'asse del buffer esiste un **altopiano** e **a che costo**.
2. La **prima misura in assoluto** della geometria OPPRANGE su **DAX** e su **NASDAQ**
   (finora esiste solo sul Dow).
3. Il lato **short** del DAX, che nel censimento dei lati **non esiste**.
4. L'**ampiezza minima di range** (`InpMinRangePct`), manopola mai messa ad asse.
5. Il **parziale** (`InpTP1Pct`), idem.
6. La finestra **15 minuti** sul Nasdaq contro i 5 che gira oggi.

### 🔴 COSA **NON** COMPRI — e va letto, non saltato
- 🚫 **Nessuna sedia schierabile.** Sul **Dow e' impossibile per costruzione**:
  `n` e' **invariante 71/119 in tutte e 48 le celle** di R88a (verificato sul CSV
  primario: `Trades` ha **un solo valore distinto**). L'asse muove lo **stop**, non
  gli **ingressi**.
- 🟠 Su **DAX e Nasdaq** l'`n` atteso e' **90-190** e **100-220**, cioe' **a
  cavallo dei 150**: il merito **puo' restare sospeso anche li'**.
- 🚫 **Il round puo' chiudere senza scegliere NESSUNA cella** — la procedura ha
  tre uscite legittime a mani vuote. Rimedio dichiarato: asse esteso, +2 celle
  = 4 passate = **~0,4 minuti**.
- 🚫 **Niente tocca il conto reale 10105439.** La `770611` resta **sotto il
  pavimento di costo** (23,5x derivato / **29,5x misurato** contro 40x) e quella
  domanda resta **tua**, aperta anche dopo R125.

### 🔁 E il fatto che ha riaperto tutto
A parita' di rischio (1%) e sugli **stessi 119 trade**, il ramo **OPPRANGE** fa
**DD 3,84%** dove la geometria della sedia viva ne fa **9,76%** — 12/12 celle sotto
il cancello contro 12/12 sopra. 👉 **Il DD e' un fatto accaduto, quindi vale a
qualunque n** (Emendamento B). E' il **rischio** a essere leggibile, non il merito.


## 1. 🖱️ RICOMPILARE E RICARICARE LE 7 SEDIE COL FIX DEL LOTTO
**Cosa**: il bug del lotto è corretto in **15 sorgenti**, ma sui terminali gira
l'`.ex5`, non il sorgente. Finché non ricompili, quelle sedie **rischiano fino
al doppio del dichiarato**.
**Dove**: 6 sul piccolo **50503392** (`C:\Program Files\BCM Markets MT5 Terminal`),
1 sul 100k **50504263** (`... -V3`). 🟢 **Nessuna sul reale.**
**Perché è tuo**: ricompilare **cambia il volume** delle sedie vive. È la taglia,
e la taglia è una tua firma.
**Quanto vale**: porta il requisito R4 da **2 sedie a 5**. Senza, il piano di
ottobre resta a **2 sedie schierabili**.
📄 `report/FIX_LOTTO_PENDENTE_2026-09-08.md`

## 2. 🖱️ POSTNEWS EURUSD: `InpRiskPercent` **3.0 → 1.30**
**Stato al 10/09**: il `.chr` vivo dice **`InpRiskPercent=3.0` su TUTTE E DUE** (chart43 EURJPY 771201, chart44 EURUSD 771202) — **ma quella foto e' del 06/09 22:55**, cioe' PRIMA che Claudio controllasse, e un `.chr` si risalva solo al cambio profilo o alla chiusura del terminale. 🔴 **Quindi la foto NON smentisce il suo ricordo e NON conferma il 3.0 di adesso: l'unico modo di saperlo e' aprire il pannello F7 sul grafico.** I preset nel repo sono corretti (1.30) su tutti e due.
**Dove**: piccolo **50503392**, grafico **EURUSD M5**. Solo quel numero, nessun preset.
**Perché**: 3.0 significa **1,50% per gamba stoppata** (la size si calcola su
`InpRiskRefSLpips=50` mentre lo stop vero è 25). 1.30 = **0,65%**, la taglia firmata il 18/08.
📄 `report/FIRMA_POSTNEWS_130_2026-09-08.md`

## 2-bis. 🚨 COLLISIONE DI MAGIC: `ECB_EURUSD` e `FOMC_EURUSD` hanno **LO STESSO 771202**

**Trovato il 10/09** leggendo i `.chr` vivi sul piccolo **50503392**.

| preset | magic | filtro titolo | ora azione (server) |
|---|---:|---|---|
| `ABTG_PostNews_FOMC_EURUSD.set` | **771202** | FOMC | 19:40 |
| `ABTG_PostNews_ECB_EURUSD.set` | **771202** | ECB | 14:00 |

Il preset ECB EURUSD e' nato l'08/09 con l'intestazione *"NATO PER EVITARE UNA
COLLISIONE DI MAGIC"* — ma **riusa il magic della sedia FOMC**, che e' quella
gia' viva su `chart44.chr` (EURUSD, `InpNewsTitleMatch=FOMC`, azione 19:40).

🔴 **Cosa succede se un giorno si caricano tutte e due**: due sedie con lo
stesso magic **si vedono le posizioni a vicenda**. Con `InpUseOCO=true` (che e'
il default e sta scritto in tutti e due i `.chr`) la prima che si riempie fa
cancellare i pendenti **anche all'altra**. Oggi non morde perche' la ECB EURUSD
non e' mai stata caricata su nessun grafico — **ma il preset e' li', pronto**.

✅ **La riparazione e' un numero**: dare alla ECB EURUSD un magic libero
(es. **771204**). E' un cambio di file, non tocca niente in forward.
🔴 **Ma resta di Claudio**, perche' un magic identifica una sedia e cambiarlo
significa che le operazioni vecchie e nuove non si sommano piu' nelle statistiche.

## 3. ✅ LA BCE DEL 10/09: **CHIUSA — armata da Claudio, e ha sparato**
**Esito misurato**: la sedia ECB **EURJPY 771201** ha fatto la sua **prima
operazione in assoluto** e ha perso **80,90 EUR su 5.427,56 = 1,4905%**, contro
lo **0,65% del contratto scritto la mattina stessa**. **2,3 volte.**
📄 `report/CONTRATTO_POSTNEWS_ECB_771201_2026-09-10.md` (scritto PRIMA) ·
`report/POSTNEWS_ECB_ESITO_2026-09-10.md` (l'esito e la causa).

🔴 **La causa non e' il preset: e' il DEFAULT COMPILATO.** Il `.set` nel repo
dice 1.30 ed e' giusto; `mql5/Experts/ABTG_PostNews.mq5` riga **113** dice
`input double InpRiskPercent = 3.0;`. Il lotto uscito (**0,58**) e' quello del
3,0 — non quello dell'1,3 (che avrebbe dato **0,25**).
⚠️ **Nota da ripetere ogni volta che si cita il 3,0**: si traduce in **1,50%
per gamba stoppata**, non in 3,00%, perche' il lotto si dimensiona su
`InpRiskRefSLpips = 50` mentre lo stop piazzato e' **25**. Il 3,0 descrive
l'evento a doppio stop.

👉 **Resta aperto e diventa il punto 3-bis.**

## 3-bis. 🖱️ POSTNEWS: portare il **default compilato** al metro di casa (tutte e 3)
**Perche' non basta sistemare il `.set`**: il `.set` giusto **non protegge da un
`Resetta`**. Finche' il default compilato e' 3.0, **ogni ricarica riarma il 4,6x
in silenzio** — ed e' esattamente quello che e' successo il 10/09.
**Cosa serve**: cambiare la riga 113 e **ricompilare**. 🔴 **E' la TAGLIA,
quindi e' firma tua.**
📏 **E un numero che manca, da 30 secondi**: aprire **F7 su EURJPY** sul piccolo
**50503392** (cartella `BCM Markets MT5 Terminal`) e leggere `InpRiskPercent`:
dice **1.3** o **3.0**? Dice **quando** e' tornato a 3.0 — al `Resetta` o prima —
e chiude la ricostruzione.

---

# 🟠 IMPORTANTI — decidono la forma della challenge

## 4. 🖊️ QUALE PROP, E QUANDO SI PAGA
**Proposta**: **FTMO 2-Step 100k, conto SWING** (540€, promo 439€, rimborsati al 100%).
Muri **statici**, reset già allineato al nostro, e lo Swing chiude da solo i due
meccanismi che **non abbiamo**: filtro news e chiusura weekend.
**Riserva**: FundingPips 2 Step Standard.
🔴 **Prima di pagare, due numeri vanno confermati da te sul sito o dal supporto**:
   1. il muro totale è **statico o trailing**? (tutte le nostre misure assumono statico);
   2. il confine della giornata si calcola su **saldo** o **equity**, e a che ora?
⚠️ Il dossier è `[LETTO-VIA-SEARCH]`: il proxy blocca i siti delle prop, quindi
**nessuna pagina è stata aperta**. Verificabile in 30 secondi da browser.
💰 **Spendere soldi resta tuo, sempre.**
📄 `report/REGOLAMENTI_PROP_2026-09-08.md`

## 5. 🖊️ GUARDIAN: quale baseline giornaliera per quale conto
Il Guardian misura la giornata dall'**equità**; **FTMO dal saldo** alle 00:00.
Su 100k con −0,8% flottante al reset: pavimento FTMO 95.000, **il nostro 94.200**.
È pronto `InpDailyBaseline` (0=equità · 1=saldo · 2=max), **opt-in e spento**.
| conto | modo giusto | perché |
|---|---|---|
| **REALE** | **0 = equità** (come oggi) | il credito broker non prelevabile |
| **prop FTMO** | **1 = saldo** | è FTMO l'arbitro, non noi |
| FundingPips/The5ers | 2 = max | il loro regolamento |
👉 Si firma **quando si sceglie la prop** (punto 4). Non prima.
📄 `report/GUARDIAN_BASELINE_GIORNALIERA_2026-09-08.md`

## 6. 🖊️ IL RIPESCAGGIO — **⚠️ RITIRO LA MIA RACCOMANDAZIONE DI STAMATTINA**

Stamattina avevo scritto *"`SuperWave DAX H4` (770512) in corsia demo"*.
**Il pacchetto preparato stasera ha tirato fuori tre fatti che non avevo**, e
tutti e tre spingono dall'altra parte. Li metto in chiaro perche' la
raccomandazione era mia.

### 🔴 1. Il DD di 3,3% e' misurato all'**1,00%** di rischio, non allo 0,65%
Verificato nel CSV primario
(`risultati_archivio/SuperWave/valid_SuperWaveRT_D30EUR_H4_realtick.csv`,
`Pass 1`): `InpRiskPercent = 1`, `Trades 56`, `PF 1.28456`, `DD 3.3245`.
👉 Il "DD 3,3%" che avevo citato **non e' il DD alla taglia di casa.**

### 🔴 2. Sul piccolo, a 0,65%, il **pavimento del lotto** morde
D30EUR ha `VOLUME_MIN = 0,10` e `CONTRACT_SIZE = 10` (misurati, `REFERTO_R114.txt`
r.77-78). Su un conto da ~5.100 €, a 0,65%, il lotto **non** finisce al minimo
solo se lo stop sta sotto **~33 punti indice** — e uno stop Supertrend su DAX H4
quasi certamente non ci sta.
👉 In quel regime **`InpRiskPercent` non controlla piu' niente**, e il DD sul
piccolo diventa **~6,5%**, non 3,32%.
**E non e' teoria**: e' gia' successo il **20/08** sullo stesso motore e sullo
stesso conto (`DIARIO.md`: −72,32 su 5.076,62 = **1,42% contro un contratto da
1,0%**).

### 🔴 3. C'era gia' un NO agli atti, di ieri, e il suo argomento **regge**
`report/CORSIA_DEMO_SUPERWAVE_DAX_H4.md` (07/09) si intitola **"NON ACCENDERE"**:
il traguardo delle 150 operazioni cade nel **2029-2031**, contro il tetto di 18
mesi della corsia demo. **Non l'ho smontato: non l'avevo letto.**

### 📉 E il numero che chiude il discorso per ottobre
Frequenza misurata: **2,65 operazioni al MESE**.
👉 **Al 1° ottobre avra' fatto ~2 operazioni.** Per la challenge **non serve a
niente**: non e' una sedia in piu', e' una sedia che non fa in tempo a dire nulla.

> ### ✍️ RACCOMANDAZIONE CORRETTA: **non accendere adesso.**
> Non perche' il motore sia brutto — il merito resta **sospeso**, n=56 < 150 — ma
> perche' a 23 giorni dalla challenge **non puo' cambiare niente**, e alla taglia
> del piccolo **il rischio dichiarato non e' quello vero**.

### ✅ E la cosa che invece VALE, e costa zero
La domanda *"il pavimento del lotto morde davvero sulle sedie del piccolo?"* si
chiude **leggendo una riga del Giornale** — nessuna sedia da accendere. E'
esattamente il **passo 8** (il canarino) gia' in programma. Se il pavimento
morde, riguarda **tutte** le sedie del piccolo, non solo questa: e' una misura
che vale molto piu' di un'accensione.

📄 `report/CORSIA_DEMO_SUPERWAVE_DAX_2026-09-08.md` · preset pronto (44 input
copiati dal banco, 2 deviazioni e 4 buchi **dichiarati**) se un giorno la
decisione cambia.

# 🟡 DA DECIDERE CON CALMA — nessuna scadenza stretta

## 7. 🖊️ ALLARGARE IL PERIMETRO DEL RUNNER AI ROUND NOTTURNI
Oggi il runner è **sola lettura**: un round contiene 6 dei 24 divieti e verrebbe
**rifiutato** (verificato). Per farlo girare di notte servirebbe una firma nuova.
**Forma minima che proporrei**, non "apriamo tutto":
   1. una **seconda coda** `CODA_ROUND.txt`, separata;
   2. può eseguire **UN SOLO script** appuntato all'hash, nient'altro mai;
   3. `-TerminaleBacktest` **cablato** su `C:\MT5_Backtest`, non parametrizzabile;
   4. **finestra 00:00-06:30** server, quando le sedie non lavorano;
   5. **canarino sul forward**: se i terminali vivi perdono colpi, la coda si spegne da sola;
   6. il conto reale **fuori da tutto**, come oggi.
💡 Vale **un round a notte senza che tu ci sia**. Te lo scrivo per bene quando dici.

## 8. 🖊️ IL TICKMILL: si staccano i due EA non nostri?
`Gold_Ichimoku_TK_ATR_EA` (magic 250604) e `BREAKOUT_EA_JPY_v3` sono ancora
attaccati su un terminale **fermo dal 20/07**, che occupa **12,08 GB**.

## 9. 🖊️ CAP C2 PER CLUSTER — firmato il 07/09, **implementato ma SPENTO**
La mappa dei cluster è **una scelta tua** e non sta in nessun preset.
Finché non si accende, è **un'intenzione, non una protezione**, e va detto ogni
volta che si cita.

---

# 📏 MISURE CHE MANCANO (nessuna firma, solo il dato)
| # | cosa | perché serve |
|---|---|---|
| 10 | **saldo del piccolo 50503392** | lì molte sedie girano all'**1,0%**, non allo 0,65%: senza il saldo i suoi numeri non si riscalano |
| 11 | **conferma che i 3 agenti del tester** siano sul terminale da backtest | se il tetto sta sul terminale sbagliato **non protegge niente** |
| 12 | **profondità a tick di XAUUSD** | senza, **nessun verdetto di merito sull'oro** è possibile, per nessun candidato |
| 13 | **frequenza di `SuperWave NASUSD H1`** | è il numero che porterebbe la famiglia SuperWave sopra il pavimento di 1,00 |
| 14 | 🔴 **QUALE ALBERO COMPILA IL VPS: `mql5/Experts/` o `mql5/Experts/standalone/`?** | e' la domanda piu' economica e piu' pesante della lista. `standalone/ABTG_DAX_Apertura_EU.mq5` riga **33** e' ancora a `ABTG_DEF_RISK 2.0` mentre la copia principale e' a **1.0** dal 02/09: **il fix C4 ha toccato una copia sola**. Se il VPS compilasse la cartella `standalone/`, l'EA del **CONTO REALE 10105439** girerebbe al **doppio** del rischio firmato — e con lui altri 15 sorgenti. Aperta da **tre censimenti** (08/09 due volte, 10/09) e **mai chiusa**. Si chiude guardando dove punta MetaEditor sul VPS: **e' sola lettura, costa 30 secondi** |

---

## 🟢 E QUELLO CHE **NON** DEVI DECIDERE
Tutto il resto lo porto avanti io: cacce, round, censimenti, correzioni,
referti, la coda notturna di sola lettura. Se serve una tua firma **te la
chiedo con il numero di conto e la cartella in chiaro**, come oggi.
