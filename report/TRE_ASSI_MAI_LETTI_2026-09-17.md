# 🔎 TRE ASSI MAI LETTI — misure a costo zero di macchina (17/09/2026)

> Stesso metodo che ieri ha prodotto tre misure vere sulle "medaglie" del
> censimento: round **già girati**, CSV **già nel repo**, asse **mai letto da
> nessuno**. Zero passate di tester.
>
> Sola lettura: nessun preset, nessun EA, nessuna sedia toccata. Le decisioni
> che toccano una sedia viva restano **firma di Claudio**.

---

## 🟢 PRIMA IL CENSIMENTO, detto corto

Su **2.176 CSV di risultato** e **75 round base** con i numeri in repo, i round
numerati `R<n>` sono **praticamente tutti già letti**. L'unica eccezione vera è
**R87b**. Il buco grosso stava **fuori dalla numerazione**: la famiglia di
etichette `pt*` del 09/08 (`ptd`, `ptc`), che nessuno ha mai cercato perché non
si chiama "R-qualcosa".

⚠️ **Trappola evitata e verificata**: *"etichetta non citata" ≠ "asse non
letto"*. `r43b/c/d` hanno **zero citazioni** ma 64 celle su 64 già lette nel
referto del round base. Ogni candidato è passato dalla verifica del referto, non
dal solo grep.

---

## 🥇 `ptc` — LA REGOLA DEI DUE LATI, MISURATA SU `770202`

**Questa è la misura che vale di più**, perché risponde con numeri fuori
campione a una domanda che la Regola dei Due Lati (25/08) impone di fare, su una
**candidata del terzetto di ottobre**. Verificata da me direttamente sui CSV
`risultati_prove/ABTG_Dow_Apertura_US/ABTG_Dow_Apertura_US_U30USD_{IS,OOS}_ptc.csv`
(gemelli `770202`/`770203` identici su tutte le righe → banco pulito).

| RangeMin | lato | IS: PF · n · DD% | OOS: PF · n · DD% |
|---|---|---|---|
| 25 | LONG | 1,12921 · 75 · 4,53 | **1,48698** · 138 · 5,24 |
| **35 (VIVA)** | **LONG** | **1,22247 · 74 · 5,67** | **1,27013 · 130 · 4,39** |
| 45 | LONG | 🔴 **0,84332** · 62 · 5,18 | **1,63876** · 115 · 2,65 |
| 25 | L+S | 1,13213 · 150 · 9,07 | 1,20506 · 218 · **9,92** |
| 35 | L+S | **1,37179** · 147 · 5,53 | 🔴 **1,09627** · 203 · **8,68** |
| 45 | L+S | 1,23281 · 131 · 4,77 | 1,15974 · 187 · 7,29 |

### 🎯 Il risultato, sulla manopola esatta della regola

Accendere lo **SHORT** sulla cella viva (RM 35):
- ✅ **+56% di operazioni** fuori campione (130 → 203) — e la frequenza è il
  requisito numero uno per ottobre;
- 🔴 **il DD OOS quasi raddoppia**: 4,39% → **8,68%**;
- 🔴 **il PF OOS scende sotto la soglia di casa**: 1,27013 → **1,09627** (< 1,10).

E in campione succede **l'opposto** (1,222 → 1,372): è un'**inversione IS/OOS
pulita sullo stesso asse**. Chi avesse guardato solo l'in-sample avrebbe acceso
lo short.

👉 **La configurazione viva (solo LONG) è confermata dai numeri fuori campione**,
e il prezzo dello short è ora misurato invece che immaginato: **+56% di
frequenza pagata con +4,3 punti di drawdown e −0,17 di PF.**

⚠️ **E una trappola accanto**: `RM 45 LONG` è il **migliore OOS dell'intera
corsa** (PF 1,63876, DD 2,65%) ma è **rosso in campione** (PF 0,84332, −2.156).
Non si tocca.

---

## 🥈 `ptd` — LA SUPERFICIE DI `770101`, la sedia che gira anche sul reale

180 celle (12 `RangeMinutes` × 15 `BufferPoints`) su `ABTG_DAX_Apertura_EU`
D30EUR M5, a **taglia 100k**. Gemelli `770111`/`770112`: **0 divergenze su 180
coppie × 2 finestre** → banco pulito.

🔴 **Il file prova non ha criteri congelati propri** (dice *"qui non si giudica
nessuno: si raccolgono le serie"*). Quindi da qui **non esce un verdetto di
promozione** — escono sanità, mappa del rischio, e la verifica della cella viva.

### La cella viva è la MIGLIORE delle 20 verdi in entrambe le finestre

| finestra | PF | n | DD % | Profit |
|---|---|---|---|---|
| IS | 1,12634 | 175 | 5,44 | +3.789 |
| OOS | **1,39709** | 270 | 7,23 | +18.030 |

Su 180 celle, **20 sono verdi (PF ≥ 1,10) in IS *e* in OOS**. Ordinandole per PF
OOS: **la cella viva è prima**, la seconda è la sua vicina di buffer.

🔵 **E c'è una misura nuova**: lungo l'asse **BUFFER** la sedia viva è un **vero
centro d'altopiano** (le vicine BP 400 e BP 600 stanno dentro la banda di casa:
ΔPF −4,8% e −10,6%, ΔDD +0,07 e +0,31 pp); lungo l'asse **RANGE** è un **bordo**
(RM 30 sta fuori: −21,3% di PF, +2,29 pp di DD). Il setaccio del 12/09 aveva
letto i due assi **separatamente** e concluso giustamente "il valore in campo va
bene" — ma non aveva la superficie.

### 🛡️ La mappa del rischio, mai disegnata prima
- **15 celle su 180 sfondano il muro di casa** (DD > 15% a rischio 1,00%): tutte
  nell'angolo `RM 5-15` con buffer ≤ 600. I due estremi: **RM10/BP100 → DD OOS
  24,98%** e **RM5/BP100 → 24,36%**. La regione viva (RM 35-60) sta fra 3,6% e 9,8%.
- **`Peggior Giornata %` OOS fra −1,0086% e −1,1524% su TUTTE e 180 le celle.**
  👉 Il muro **giornaliero** della prop non morde su nessuna configurazione di
  questa sedia, a questa taglia. Fatto nuovo, utile per il piano di ottobre.

### ⚠️ Due ribaltamenti IS→OOS
- La riga **RM 40** è la migliore dell'intero OOS (PF 1,17-1,39 su tutti e 15 i
  buffer) ma è **negativa ovunque in IS** (0,83-0,99).
- Il **picco IS** (RM30/BP100, PF 1,44362) in OOS fa **1,01135** con DD 9,84%.
  Il solito: scegliere il picco = scegliere il rumore.

---

## 🥉 `R87b` — 576 celle su quattro sedie vive: nessun allarme, e una direzione

Griglia a 6 assi su `GoldenCross` (XAUUSD `970301` + USDCHF `770331` + USDCAD
`770332` + NZDUSD `770333`), 144 celle × 4 simboli × 2 finestre = **1.152
passate mai lette**. Criteri congelati in `risultati_archivio/R87_CRITERI.md`.

### 🟢 La notizia buona, ed era l'unica che chiedeva una decisione rapida
- **R1 (DD > 15% → bocciata per rischio): 0 celle su 576.** Massimo assoluto
  **9,15%** a rischio pinnato 1,00% (le sedie girano a 0,65%).
- **R3 (*"la v2.00 sfonda dove la V1 non lo faceva"* = allarme sulla sedia viva):
  NON SCATTA.** Era l'esito che avrebbe richiesto un intervento. **Non c'è.**

### 🔴 Ma il round è in gran parte illeggibile, per il suo stesso criterio
Il cancello §5.1 (n = IS+OOS per cella) falcia la griglia: **302 celle su 576
sono "non misurabili"** (n < 10) e altre 190 ammettono solo l'ispezione. Il
canarino stimava 15-40 operazioni IS sul forex; la mediana vera è **1 su USDCHF,
3 su USDCAD, 2 su NZDUSD, 9 su XAUUSD** — ottimista di un ordine di grandezza.
👉 I PF mostruosi della griglia (fino a **3524,80**) sono celle da 2 operazioni
senza perdenti: per il criterio congelato **non si scrivono come PF**.

### 🟠 Verdetto congelato: "solo picchi isolati", su tutti e quattro
Centri d'altopiano col test di casa: **0 su XAUUSD, 0 su USDCHF, 0 su USDCAD**;
su NZDUSD 2, ma degeneri (n IS = 6) e cadono appena si chiede il test anche in
campione. **Nessun preset esce da qui**, come i criteri vietavano in anticipo.

### 🥇 Una cosa vera però c'è, ed è la stessa su tre simboli indipendenti
Guardando **solo** le celle che superano il cancello di leggibilità (n ≥ 30) e
sono verdi in entrambe le finestre, **lo stesso angolo vince su 3 simboli su 4**:
`MaxDistATR 1.5 · AdxMin 20 · HACount 2 · Lookback 7`.

| simbolo | IS | OOS |
|---|---|---|
| XAUUSD | PF 1,5078 · n 52 · DD 5,10 | PF **1,4004** · n 84 · DD 5,19 |
| USDCHF | PF 1,4990 · n 30 · DD 4,36 | PF **1,4626** · n 34 · DD 2,71 |
| NZDUSD | PF 1,7216 · n 10 · DD 1,28 | PF 1,3277 · n 29 · DD 4,63 |

Contro la configurazione **in campo** su XAUUSD (OOS PF 1,1944, n 66, DD 6,31):
la cella fa **OOS PF +0,21, profitto +143%, DD −1,12 pp** — ma **IS PF −0,21 e
IS DD +2,69 pp**.

👉 **È una DIREZIONE, non una proposta**: `InpAdxMin 15→20` e `InpHACount 3→2`.
Il campione resta 30-84 contro il pavimento di 150 → **merito sospeso**, e il
verdetto §5.4 vieta di uscire con un preset. La strada la scrivono i criteri
stessi: un round su **dati lunghi**, e **un asse per volta**.

### 🔴 Due limiti strutturali del round, dichiarati
- **L'ancora non è nella griglia**: la configurazione in campo usa `AdxMin 15` e
  `Lookback 8`, valori **fuori** dagli assi spazzati (verificato anche sui
  numeri: 0 corrispondenze). Quindi da R87b **non si può dire se la sedia viva
  stia al centro o al bordo** della superficie.
- **`Peggior Giornata %` non esiste in questi CSV** → il cancello R2 dei criteri
  congelati **non è verificabile**. `[NON MISURATO]`, non dimenticato.

---

## 📌 COSA RESTA APERTO

1. **`ptd` e `ptc` meritano criteri congelati a posteriori**, per poter essere
   citati come misure e non solo come descrizione: sono superfici con **n sopra
   il pavimento** su due sedie vive, a taglia 100k.
2. Un round `_EXT` su dati lunghi per l'angolo del GoldenCross — un asse per
   volta. Costa macchina, non firma.
3. 🔴 **Nessun preset vivo è stato toccato** e nessuno va toccato senza la firma
   di Claudio: né le quattro GoldenCross, né `770101` (che gira anche sul conto
   reale **10105439**, quindi la sua mappa di rischio conta doppio), né `770202`.
