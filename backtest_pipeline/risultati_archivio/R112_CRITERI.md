# ✍️ R112 — IL CONTRATTO DELL'EMADOW: SHORT-ONLY, E A QUALE DIAL? — CRITERI [DA FIRMARE]

**Origine**: Claudio, 26/08/2026 sera — _"PREPARA IL ROUND CONTRATTO EMADOW
SHORT"_ — dopo il titolo di R110: il lato short dell'EMA200 Dow è la prima
cella dei lati con **merito pieno** sugli indici (OOS PF 1,891, n 302,
DD 2,66% contro 7,83% della sedia intera).
**Sedia in oggetto**: `ABTG_EMA200` su U30USD H1, sedia viva **771531**
(rischio in campo 0,65%, conto 100k dry-run).
**Driver**: `righe/RIGA_R112_EMADOW_CONTRATTO.ps1` (marcatore
`MARCATORE_RIGA_R112_v1`). **File prova**: `prove/R112_*.txt` — **quattro**.
**Riga da mandare**: `righe/RIGA_R112_DA_MANDARE.md`.

---

## 0. 📌 CHE ROUND È — e la dichiarazione d'onestà che lo regge

R110 ha **consegnato la misura**; per regola R52 e G5 non poteva toccare la
sedia: _"questa sedia potrebbe essere short-only"_ è una **proposta di
modifica di contratto = un round con quello come oggetto**. Questo è quel
round.

**🔴 LA DICHIARAZIONE CHE VIENE PRIMA DI TUTTO: I NUMERI DI R110 SONO GIÀ
STATI VISTI.** Questo round NON è una scoperta fresca e non finge di
esserlo. Se il cancello si scrivesse dopo aver visto i numeri E si potesse
ritoccare dopo averne visti altri, sarebbe la definizione del curve
fitting. Le protezioni, tutte e tre dichiarate:

1. **Il cancello di portafoglio è CONGELATO QUI, prima dei numeri nuovi**
   (§ 6), ed è quello storico di casa (R46/R54), non uno inventato per
   l'occasione.
2. **I dial sono TRE e CONGELATI QUI: 1,0% / 2,0% / 3,0%** — e la loro
   derivazione è dichiarata apertamente invece che nascosta: 7,83/2,66 ≈
   2,9 (il rapporto dei DD di R110) dice che il dial a pari-DD sta vicino
   al 3%, e lo si INCORNICIA con 2% e 3%. Vietato aggiungere dial
   intermedi a risultati visti (§ 10, D5): un 2,5% "perché il 2 passava
   quasi" è pesca.
3. **Le misure NUOVE sono davvero nuove**: la peggior giornata (mai
   misurata su questa sedia, né sul metro né sui lati), la scala del DD
   col dial (che NON è aritmetica: compounding, margini, tetti di volume —
   R109 ha misurato il tetto che morde all'8,9% delle operazioni), e la
   riproduzione del banco (§ 5, G0-B — stavolta APPLICABILE).

**Cosa NON è:** non è un'ottimizzazione (nessun parametro del MOTORE si
muove: si muove il CONTRATTO — lato e rischio); non è un deploy (G5);
non è la Seconda Caccia (il motore è vivo e verde).

---

## 1. 🧭 LE QUATTRO CELLE

Tutte su U30USD H1, finestra 2024.09.26→2026.06.30, split 40/60, modello 4
(tick reali), deposito 100.000 — **le stesse di R110, dichiaratamente**:
è l'unico modo di leggere R112 accanto a R110, ed è ciò che rende G0-B
possibile.

| cella | AllowLong | AllowShort | InpRiskPercent | cos'è |
|---|---|---|---|---|
| `00_metro` | true | true | 1,0 | **la sedia viva com'è** — denominatore, G0-C, e stavolta anche la SUA peggior giornata |
| `01_short_r1` | false | true | 1,0 | lo short di R110, riprodotto — **il gate del banco (G0-B)** |
| `02_short_r2` | false | true | **2,0** | la scala del dial, primo gradino |
| `03_short_r3` | false | true | **3,0** | la scala del dial, il gradino di pari-DD atteso |

I delta rispetto all'antenato sono **di contratto e solo di contratto**:
`InpAllowLong`, `InpRiskPercent`, `InpMagic`. Nient'altro si muove.

## 2. 🔢 MAGIC (blocco vergine 7634xx — verificato sul repo il 26/08)

| cella | coppia gemella |
|---|---|
| 00_metro | 763400 / 763401 |
| 01_short_r1 | 763410 / 763411 |
| 02_short_r2 | 763420 / 763421 |
| 03_short_r3 | 763430 / 763431 |

**VIETATI e controllati dal driver**: 771531 (sedia viva), 771501
(sorgente), tutto il blocco 7633xx (bruciato da R110).

## 3. 🧬 GLI ANTENATI — la catena è dichiarata

- `00_metro` → antenato `prove/R110_EMADOW_00_metro.txt` (delta: `InpMagic`)
- `01_short_r1` → antenato `prove/R110_EMADOW_02_short.txt` (delta: `InpMagic`)
- `02_short_r2` / `03_short_r3` → antenato `prove/R110_EMADOW_02_short.txt`
  (delta: `InpMagic` + `InpRiskPercent`)

Gli antenati di R110 erano a loro volta gatati contro R103: la catena
R103 → R110 → R112 è **controlli, non frasi**.

## 4. 📤 LA MISURA NUOVA: LA PEGGIOR GIORNATA — convenzione CONGELATA PRIMA

`ABTG_EMA200` scrive **da sempre, a ogni fine test**, un CSV per-trade
nella cartella comune (`abtg_trades_ABTG_EMA200_U30USD_<magic>.csv`, una
riga per ogni CHIUSURA, con `close_time` e `net_profit`). In magic-sweep
ogni pass scrive il file del PROPRIO magic — è l'uso previsto dal
commento nel sorgente. Da lì il driver calcola:

- **giornata** = somma dei `net_profit` chiusi nella stessa **data server**
  (raggruppamento per data: nessun ordinamento richiesto → l'instabilità
  di `Sort-Object` della checklist 81 non ha presa qui);
- **peggior giornata** stampata con **DUE denominatori, tutti e due**:
  in % del **deposito fisso 100k** e in % dell'**equity a inizio giornata**
  (deposito + cumulato dei giorni precedenti);
- ⚠️ **LIMITE DICHIARATO, il più importante**: questa è la peggior
  giornata dei **CHIUSI**. Il muro giornaliero delle prop (e il Guardian)
  guardano l'**equity FLOTTANTE**, che qui non c'è — R109 ha misurato
  quanto pesa la differenza. Quindi questa misura **sottostima** ed è un
  **pavimento**, non il numero del muro: si dichiara in ogni tabella.
- **IS: n/d PER COSTRUZIONE.** Il driver generico corre gamba IS e poi
  gamba OOS nella stessa chiamata (righe 465-468: prima IS, poi OOS) e
  l'export sovrascrive il file del magic a ogni gamba: **sopravvive
  l'ultima**. Il driver NON assume che sia l'OOS: **lo misura** — tutte le
  `close_time` del CSV devono cadere nella finestra OOS; se una sola cade
  in IS, il file è di un'altra gamba e la peggior giornata di quella cella
  esce **n/d**, mai un numero sbagliato.
- **Igiene**: prima della corsa il driver **cancella** dalla cartella
  comune ogni `abtg_trades_ABTG_EMA200_U30USD_7634*.csv`; dopo, pretende
  file **freschi** (LastWriteTime ≥ avvio) e **riconcilia** il numero di
  righe col `n` OOS dell'OPTFRAME (tre stati: OK / SCARTO DICHIARATO /
  MANCANTE→n/d).
- **Bonus gemelli (G0-C-bis)**: i DUE CSV per-trade di una cella (un
  magic per gemello) devono essere **identici riga per riga tranne la
  colonna magic**. È il G0-C portato al livello del singolo trade.

## 5. 🚧 I CANCELLI DEL BANCO

### G0-A · ANTENATO — 🔴 fatale, per cella
Confronto riga per riga PER NOME contro l'antenato del § 3, delta ammessi
e nient'altro. Gira PRIMA di MT5.

### G0-B · RIPRODUZIONE DI R110 — ✅ **APPLICABILE, per la prima volta, e 🔴 FATALE**
R110 e R112 girano su **stesso banco** (modello 4, tick reali), **stessa
finestra**, **stesso split**, **stessi input** (il magic non tocca la
logica). Quindi — per la prima volta da quando esiste questa macchina —
c'è **qualcosa da riprodurre**:

> `00_metro` e `01_short_r1` devono riprodurre **al centesimo** (profitto,
> PF, DD, n — IS e OOS) i CSV di R110 archiviati al pin in
> `prove/R110_CSV_EMADOW/`.

Se non riproducono, **si ferma tutto**: vorrebbe dire che il banco non è
riproducibile fra corse — una notizia più grossa del round, da referto suo.

### G0-C · GEMELLI — 🔴 fatale, per cella
Due righe identiche al centesimo. Più il **G0-C-bis** del § 4 sui per-trade.

### G0-D · Stella, valori, asse unico (`InpMagic`), magic vietati — 🔴 fatali.

### G1 · MISURABILITÀ — n OOS ≥ 30 per cella (atteso: largamente superato,
R110 ha fatto 302-517). Sotto: NON MISURABILE, mai "non funziona".

## 6. ⚖️ IL CANCELLO DI PORTAFOGLIO — il cuore del round (decisione **D2**)

È il cancello **storico di casa** (R46/R54: _"più profitto OOS **e** DD non
peggiore"_), esteso con la misura nuova. Un dial `d ∈ {1,0 / 2,0 / 3,0}`
rende la cella short **CANDIDATA AL CONTRATTO** se, **in OOS**:

- **(a)** profitto(short, d) **>** profitto(metro, 1%), **E**
- **(b)** DD equity(short, d) **≤** DD equity(metro, 1%), **E**
- **(c)** peggior giornata(short, d) **≤** peggior giornata(metro, 1%)
  (stesso denominatore, quello fisso; se una delle due è n/d il criterio
  (c) è **NON VALUTABILE** e la candidatura resta **SOSPESA**, non
  promossa), **E**
- **(d)** profitto IS(short, d) **> 0** (coerenza di verso, come G2/R54).

**Se passano più dial, il candidato è il PIÙ BASSO** (decisione D2-bis:
a parità di cancello si sceglie la fragilità minima, non il profitto
massimo — scegliere il dial più alto perché rende di più è esattamente la
selezione che il criterio del centro-altopiano esiste per vietare).

**Letture obbligate accanto al verdetto** (non cancelli, ma nel referto):
- **tetto di volume** (lezione R109): volume massimo osservato e quota di
  trade al volume massimo, per cella — se al 3% il broker tappa i lotti,
  il DD misurato è "gentile" e va detto;
- **compounding**: al 2-3% l'equity si muove — PF e DD NON scalano
  lineari, ed è il motivo per cui si misura invece di moltiplicare;
- **conversione campo**: ogni dial va letto anche ×0,65 (2,0→1,3% /
  3,0→1,95% per trade in campo) e confrontato col **cap C1 = 3,25% di
  rischio aperto** firmato il 18/08: una sedia short-only a 1,95% per
  trade impegna fino a **il 60% del cap con un solo SL vivo** — è un fatto
  di portafoglio che la delibera dovrà pesare.

## 7. 🚫 G3 — dichiarato NON APPLICABILE
Un solo motore, un solo mercato: la coerenza cross-motore qui non esiste.
Il contesto cross-motore resta quello di R110 (SUPNAS short verde-indizio,
SWDOW short rosso) e il referto lo RIPORTA, senza rimisurarlo.

## 8. 📤 COSA PUÒ USCIRE DA R112 — e cosa no (G5)

- ❌ **Nessun deploy esce da qui.** La sedia 771531 non si tocca, il
  forward non si tocca, nessun .set nuovo va sul VPS.
- ✅ Se un dial passa il cancello: il referto produce la **PROPOSTA DI
  DELIBERA** (spegnere 771531 e accendere la sedia short-only al dial
  candidato, magic nuovo, in parallelo mai sopra la vecchia — regola di
  casa), con DD e peggior giornata promessi PER il censimento dei
  contratti. **La firma della delibera è un atto separato di Claudio.**
- ✅ Se nessun dial passa: la sedia resta com'è, e il referto dice quale
  criterio è mancato — anche quello è un numero che oggi non abbiamo.
- 🗒️ In ogni caso: la peggior giornata del METRO (la sedia viva!) entra
  agli atti — oggi il censimento dei contratti non ce l'ha.

## 9. 📅 FINESTRA E LIMITI, PRE-DICHIARATI

- **Un solo regime** (21 mesi di salita): un verdetto qui vale per questa
  epoca. La prova di regime lunga sul Dow resta BLOCCATA (HistData non ha
  il Dow; Dukascopy è decisione aperta). Chi legge il referto lo legge
  con questo sopra la testa.
- La spina dorsale di R110 resta valida e NON viene rimisurata: l'EMADOW
  short è verde in IS e OOS, ma i sotto-periodi non sono misurati.
- Durata attesa: 8 gambe (~3-4 min l'una a tick reali) ≈ **30-45 minuti**.

## 10. 🖊️ LE DECISIONI DA FIRMARE [DA FIRMARE]

| # | decisione | proposta |
|---|---|---|
| **D1** | perimetro | 4 celle del § 1, magic § 2, finestra/split/banco di R110 |
| **D2** | cancello di portafoglio | § 6 (a)+(b)+(c)+(d); **D2-bis**: fra i dial che passano vince il più basso |
| **D3** | G0-B riproduzione di R110 | APPLICABILE e FATALE (§ 5) |
| **D4** | peggior giornata | convenzione § 4: chiusi per data server, doppio denominatore, limite floating dichiarato, IS n/d per costruzione, riconciliazione col n OPTFRAME |
| **D5** | anti-pesca | i dial sono {1, 2, 3} e **non si aggiungono dial a risultati visti**; un dial intermedio richiede un round nuovo con firma nuova |
| **D6** | esito e uso | § 8: nessun deploy; candidatura → proposta di delibera separata col check del cap C1 |

**Firma proposta: "FIRMO R112"** (con eventuali PROPOSTE). La corsa vera
parte solo a criteri firmati: il driver cerca il lucchetto in tutto questo
file. Il giro a vuoto parte comunque e serve a leggere questi criteri.
