# 🎯 Gemello NASUSD di `ABTG_IBRetest` — **CONFERMA**, e la famiglia arriva al cancello C0

**Data**: 09/09/2026 · **Etichetta**: `P0IBRTNAS` · **Pin**: `bfaab0248443d08c896b0c3adcd7c5fe6e900667`
**Terminale**: `C:\MT5_Backtest` (demo **50504400**) · tick reali · deposito 10.000 · `MaxBars=10000000`
**RILIEVI del referto: 0** · PID non bersaglio identici prima e dopo (`7824, 8664, 9780`) → **il conto reale 10105439 non è stato sfiorato**.

---

## 📊 I NUMERI, nudi

| | IS | OOS |
|---|---|---|
| Trades | **35** | **49** |
| Profit (su 10.000) | −441,72 | −419,15 |
| **Profit Factor** | **0,56297** | **0,59292** |
| Equity DD % | **5,8012** | **5,3076** |
| Peggior Giornata % | −1,0783 | −0,7741 |
| Stop Mediano (punti indice) | **128,10** | **167,20** |
| Stop Da Pivot | 18 / 35 | 27 / 49 |
| Lotto Al Minimo | **0** | **1** |
| Reject | 7 | 9 |
| Flat Chiusure | 17 | 35 |
| Sedute con IB | 172 | 272 |
| Rottura L/S | 126 / 110 | 190 / 169 |
| Ritorno L/S | 79 / 67 | 104 / 110 |
| Segnale L/S | 42 / 21 | 48 / 37 |
| Long / Short | 21 / 14 | 29 / 20 |

**Cancello G1 (determinismo)**: le due celle gemelle (`InpMagic` 772900 e 772950) danno numeri **identici alla cifra** in entrambe le finestre. ✅

---

## ✅ I CANCELLI CHE PASSA (e ne passa quattro su cinque, di nuovo)

- **FREQUENZA** — 84 operazioni su 444 sedute con IB = **0,189 op/seduta**. Attesa dichiarata prima: **0,18-0,28**. ✅ **dentro**, al bordo basso.
- **RISCHIO** — DD **5,80% / 5,31%**: sotto la soglia di bocciatura (10%) e perfino **sotto la fascia di allarme** (6-10%). È il numero di rischio più basso visto in tutta la caccia.
- **MURO GIORNALIERO** — −1,08% / −0,77% contro una soglia di −5,0%. ✅ larghissimo.
- **COSTO (C3)** — spread NASUSD misurato 1,6-1,8 punti indice → frontiera `40 × spread` = **64-72 punti**. Mediana **128,10 / 167,20** = **75× / 98× lo spread**. ✅ passa con ~2× di margine.
- **PAVIMENTO DEL LOTTO** — 1 caso su 84 (1,2%): il minimo del broker **non morde**, la corsa a `-Deposito 100000` **non serve**. Corsa risparmiata.
- **DUE LATI (regola 25/08)** — Long 50 / Short 34 = **60/40**, dentro il limite di 70/30 in entrambe le finestre. Il motore opera davvero da tutti e due i lati.

## 🔴 IL CANCELLO CHE NON PASSA

**PF 0,563 e 0,593.** Perde in **entrambe** le finestre, come sulla madre.

### ⚠️ E qui va detta una cosa scomoda sul "bel" numero di rischio
Il DD del 5,80% è basso **non perché il motore sia sicuro, ma perché perde piano**: la perdita è −4,42% del conto e il DD è 5,80%, cioè **la curva di equity è quasi solo discesa**. Un DD piccolo su un motore che perde non è una qualità: è un'emorragia lenta. Il cancello del rischio è passato, ma **non è un merito** — e va scritto così, altrimenti la tabella racconta una bugia.

---

## 🔮 LE MIE PREVISIONI: una giusta, due sbagliate

Dichiarate nel file prova **prima** della corsa:

| Previsione | Misurato | Esito |
|---|---|---|
| frequenza 0,18-0,28 op/seduta | **0,189** | ✅ **dentro** |
| "NASUSD nella **metà ALTA** della forbice" | bordo **basso** | ❌ **sbagliata** |
| "stop mediano **più largo** della madre" | 128/167 contro **239,75** → **più stretto** | ❌ **sbagliata** |

La forbice larga ha retto; le due previsioni fini no. Il Nasdaq è più rumoroso **in percentuale**, ma l'IB in **punti indice** gli esce più stretto di quello del Dow — e io avevo ragionato sul rumore invece che sulla scala del prezzo. Segnato.

---

## 🧮 LA FAMIGLIA — e il cancello **C0** scatta ADESSO

`C0`, congelato **prima** dei numeri (nei file prova dei due gemelli):
> *famiglia con **n ≥ 150** e **PF < 1,10** nella finestra peggiore → **SCARTO, senza griglia**.*

E il file prova della madre aveva già dichiarato l'unità di misura:
> *"Il PASSO 0 gira sulla finestra INTERA e **NON si spezza in IS/OOS**: con questi numeri spezzare adesso darebbe due campioni sotto soglia e nessuna informazione in più."*

**Conto della famiglia con DUE simboli su tre** (lordi ricostruiti da Profit e PF, `GL = |Profit|/(1−PF)`):

| | n | Lordo vinto | Lordo perso |
|---|---|---|---|
| U30USD IS | 42 | 447,75 | 1.170,84 |
| U30USD OOS | 53 | 837,88 | 1.202,76 |
| NASUSD IS | 35 | 569,01 | 1.010,73 |
| NASUSD OOS | 49 | 610,50 | 1.029,65 |
| **FAMIGLIA** | **179** | **2.465,14** | **4.413,98** |

### 👉 **n = 179 ≥ 150** · **PF di famiglia = 0,5585** · finestre separate: IS **0,466** (n=77), OOS **0,649** (n=102)
**Entrambe le condizioni di C0 sono soddisfatte. Il cancello scatta.**

### 📐 E il DAX non può ribaltarlo — è aritmetica, non opinione
Perché la famiglia arrivi a PF 1,10, il gemello D30EUR dovrebbe portare un lordo vinto di **~3.600** su un lordo perso di **~1.100** (ordine di grandezza atteso per ~100 operazioni): **PF ≈ 3,3**. Su ~120 operazioni servirebbe **PF ≈ 2,9**. Nessun motore intraday su indici fa PF 3 su 100 operazioni: se uscisse, **non sarebbe una promozione, sarebbe un baco da cercare**.

⚠️ **Due onestà sul conto sopra**: (1) i lordi sommati vengono da **quattro corse separate da 10.000 €** ciascuna, quindi il PF di famiglia è un rapporto legittimo ma **il DD NON è sommabile** (servirebbe una curva di equity unica, che non abbiamo); (2) le finestre prese **una per una** restano sotto i 150 (77 e 102) — è il campione **aggregato** a passare la soglia, ed è l'unità che il file prova aveva dichiarato.

---

## 🔍 IL DIFETTO STRUTTURALE, misurato: **il 62% dei trade muore di orologio**

`Flat Chiusure` = 52 su 84 su NASUSD (**61,9%**; sull'IS della madre erano 22 su 42, **52%**). Cioè: **la maggioranza delle operazioni non viene chiusa né dal TP a 2R né dallo stop, ma dal flat di fine seduta alle 21:00 server.**

Il motore rischia 1R e viene tagliato a metà strada **prima** di arrivare a 2R. E questo era **il rischio di porting numero 2, dichiarato per iscritto prima della corsa**:
> *"LA SCALA DI USCITE. La fonte esce a scaglioni 1R/2R/3R/4R/5R con breakeven a 2R. QUI NO: un TP unico a 2R, niente parziali, breakeven SPENTO."*

**Il rischio dichiarato si è misurato da solo.** Non è una scusa — un PF di 0,56 non lo salva un'uscita diversa — ma è un **fatto registrato**, ed è l'unico appiglio meccanico che questo motore lascia in eredità.

---

## ⚖️ VERDETTO

**`ABTG_IBRetest` — SCARTATO per EDGE dal cancello C0.** Famiglia a 179 operazioni, PF 0,559. Non passa alla griglia.

**Cosa NON si fa** (regola del 19/08): ritoccare `InpSmaLen`, `InpPivot`, `InpRR`, le soglie o l'orario di flat per far salire il PF. Sarebbe la griglia sul motore morto — e su un motore a PF 0,56 una griglia trova solo picchi di rumore.

**Cosa si può fare** (sempre regola del 19/08, la clausola buona): cercare un **MECCANISMO diverso sulla stessa inefficienza**. Il dato del 62% di chiusure per orologio dice dove guardare: **la gestione dell'uscita**, non il segnale d'ingresso. Sarebbe un **motore nuovo**, non una cella nuova di questo. Non lo apro senza una parola di Claudio: l'imbuto ha già candidati non ancora misurati (`ABTG_HVAncora`, i 7 ripescati per frequenza), e a 3 settimane dall'inizio della challenge il tempo di macchina vale più di un'idea in più.

## ✅ COSA LASCIA IN CASSA (e non è poco)
1. **Il cancello C0 è stato usato per la prima volta come regola**, con n sopra soglia e criterio congelato prima. Non è più un'impressione.
2. **Quattro cancelli su cinque passati due volte su due simboli**: l'EA è sano, la misura è deterministica (G1 identico), il costo è ampiamente coperto. Il codice non è da buttare.
3. **Tre motori bocciati in due giorni con criteri congelati**, e nessuno di loro è finito in forward. La macchina di misura sta facendo esattamente il suo mestiere: **costa dieci minuti dire di no, costa una challenge dire di sì per sbaglio.**

---

## 📎 DA FARE
- ⏳ **Manca il gemello `ROUND_P0IBRTDAX.zip`** (D30EUR): la corsa è partita, lo zip è sul Desktop del VPS. Va letto **lo stesso** — non per cambiare il verdetto (non può), ma perché **il rischio si legge a qualunque n** (Emendamento B) e il DAX è l'unico dei tre su cui il cutoff delle 20:00 server lascia una finestra da ~11 ore: se lì il DD sfondasse, sarebbe un'informazione sul **cutoff**, non sul PF.
