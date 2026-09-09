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

---
---

# 🧩 AGGIORNAMENTO — è arrivato anche il gemello **D30EUR**, e ha una sorpresa dentro

**Etichetta**: `P0IBRTDAX` · stesso pin `bfaab024` · **RILIEVI 0** · PID non bersaglio identici prima e dopo · **G1 determinismo OK** (772900 e 772950 identiche alla cifra).

## 📊 D30EUR, nudo

| | IS | OOS |
|---|---|---|
| Trades | **58** | **107** |
| Profit | **+260,68** | −83,97 |
| **Profit Factor** | **1,21062** | **0,96493** |
| Equity DD % | **2,7988** | **5,2515** |
| Peggior Giornata % | −0,6474 | −0,6773 |
| Sharpe | +2,51 | −0,50 |
| Stop Mediano (punti indice) | 113,35 | 110,60 |
| Sedute con IB | 170 | 267 |
| Long / Short | 29 / 29 | 56 / 51 |
| **Reject** | **45** | **49** |
| Flat Chiusure | 35 | 68 |
| Lotto Al Minimo | 1 | 2 |

### 😮 È il migliore dei tre, e di parecchio
**PF 1,21 in IS con DD 2,80%** — l'unica finestra positiva di tutta la caccia su questo motore. **Long 29 / Short 29 in IS: perfettamente simmetrico.** Il costo passa (113/110 punti contro una frontiera di 64-68 = **~68× lo spread**).

### 🧊 Ma non regge fuori campione, e non serve nessuna teoria per dirlo
**OOS: PF 0,96493 su 107 operazioni, DD 5,25%, Sharpe −0,50.** Lo stesso simbolo, senza che nessuno abbia ottimizzato niente (il passo 0 non ha assi di merito), passa da **+260,68 a −83,97**. Non è una degradazione da overfitting — **non c'era niente su cui fare overfitting**: è puro campionamento. 58 operazioni non bastano a distinguere PF 1,21 da PF 1,00.

---

## 🧮 LA FAMIGLIA COMPLETA — **C0 conferma lo scarto, e con più forza di prima**

| | n | Lordo vinto | Lordo perso | PF |
|---|---|---|---|---|
| U30USD | 95 | 1.285,63 | 2.373,60 | 0,542 |
| NASUSD | 84 | 1.179,51 | 2.040,38 | 0,578 |
| D30EUR | 165 | 3.808,74 | 3.632,03 | **1,049** |
| **FAMIGLIA** | **344** | **6.273,89** | **8.046,02** | **0,7798** |

**Per finestra**: IS **n=135 · PF 0,7356** — OOS **n=209 · PF 0,8124**.

### 👉 Adesso **la finestra OOS da sola** ha **n = 209 ≥ 150** e **PF 0,812 < 1,10**
Il cancello C0 non scatta più su un campione aggregato: scatta su **una singola finestra a campione pieno**. È il caso più netto possibile.

### 📉 E c'è un secondo motivo, indipendente: **la FREQUENZA di famiglia non arriva al pavimento**
344 operazioni su ~440 sedute con tre simboli = **0,78 op/giorno di famiglia**, contro il pavimento firmato il 07/09 di **1,00 op/giorno per famiglia**. Anche se l'edge ci fosse stato, la famiglia sarebbe stata sotto il pavimento. **Due cancelli indipendenti, stesso verdetto.**

## ⚖️ VERDETTO CONFERMATO: **`ABTG_IBRetest` SCARTATO.** Nessuna griglia.

🚫 **E qui va detto ad alta voce quello che NON si fa.** D30EUR è il simbolo migliore dei tre e ha una finestra a PF 1,21. Tenere **solo il DAX** e mandarlo in griglia sarebbe **esattamente** la mossa vietata dalla regola del 19/08: scegliere a posteriori il simbolo che è uscito bene, su un campione (58 operazioni) troppo sottile per distinguere il segnale dal caso, e su un motore la cui famiglia fa PF 0,78. **È così che nasce la cella verde per caso che brucia la challenge.** Il criterio era congelato prima; il numero non lo cambia.

---

## 🔍 IL DIFETTO CHE AVEVO DICHIARATO PRIMA SI È MISURATO DA SOLO — **94 rifiuti**

Nel file prova D30EUR avevo scritto, prima della corsa:
> *"su D30EUR la finestra utile è ~11 ore contro ~5,5 dei due indici USA, quindi un ingresso serale in liquidità sottile è POSSIBILE. Se i contatori mostrano segnali concentrati dopo le 16:30 server, quello è un difetto DA MISURARE nella griglia, non da correggere adesso di nascosto."*

**Colonna `Reject`: 45 (IS) + 49 (OOS) = 94 ordini rifiutati** su ~259 tentativi, cioè **il 36%**. Sugli altri due: NASUSD **16**, U30USD **2** in IS. La firma è inequivocabile: è il cancello sullo spread (`InpMaxSpreadPctOfStop = 2,5%` di uno stop di ~113 punti = ~2,8 punti indice) che **rifiuta i segnali serali** del DAX, quando lo spread si allarga.

**Il cancello ha fatto il suo mestiere.** Ma va detto anche cosa **non posso** affermare: **da queste colonne non conosco l'ORA dei 165 trade riempiti.** Per dirlo servirebbe una colonna con l'istogramma dell'ora d'ingresso, **che non esiste ancora**. Quindi: il numero del DAX **non è sporco per prova**, è **non verificabile su quel punto** — e la differenza fra le due frasi è tutta la differenza fra una misura e un'opinione.

📌 **Miglioria da portarsi dietro sui prossimi EA**: una colonna `Ora Ingresso Mediana` (o tre contatori per fascia oraria) nell'`OnTester`. Costa dieci righe e chiude questo buco per sempre.

---

## 🔮 LE MIE PREVISIONI SUL DAX: **sbagliate, e stavolta fuori range**

Avevo dichiarato **0,18-0,28 op/seduta** per entrambi i gemelli. D30EUR ha fatto **165 operazioni su 437 sedute = 0,378** — **fuori dalla forbice, sopra**. Non è la previsione fine ad essere caduta: è **la forbice principale**.

**Perché ho sbagliato**: ho stimato la frequenza dalla meccanica (rottura → ritorno → fallimento) senza tenere conto che sul DAX la finestra utile è il doppio. Più ore = più sedute in cui la sequenza si completa. **Era scritto nel mio stesso file prova, due paragrafi sopra, e non l'ho usato per correggere la stima.** Segnato: *quando dichiaro una frequenza attesa, la finestra oraria entra nel conto, non solo la meccanica.*

Bilancio delle previsioni su questo motore: **U30USD centrata** (0,214 dentro 0,20-0,32), **NASUSD centrata** (0,189 dentro 0,18-0,28), **D30EUR fuori**. Due su tre.

## ✅ E LA PREVISIONE CHE CONTAVA HA RETTO
Avevo scritto, prima delle due corse: *"mi aspetto che confermino"*. **Hanno confermato**: famiglia PF 0,78, C0 scatta. La sorpresa del DAX ha cambiato **quanto** il motore perde, non **se** perde — e il verdetto, che era la domanda, è arrivato in dieci minuti di macchina invece che in una settimana di griglia.
