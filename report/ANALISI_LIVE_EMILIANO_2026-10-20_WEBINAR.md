# ANALISI WEBINAR EMILIANO - 20/10/2026 (sera, "lezione 2" di un workshop gratuito: strategia 200 con volatilita' media, reversal/breakout/break-in, stop e target ATR H1, strategia "Post News" FOMC, scalping con la candela media Mataf)

**Stato:** scheda scritta dal coordinatore il 21/10/2026, **non** dall'`analista-trascrizioni`, **non controllata da agenti**. Strato 1 (`controlla_riga.py --oggetto md`) da rieseguire prima del commit finale; strato 2 NON eseguito.
**Fonte unica:** `data/trascrizioni/WEBINAR_EMILIANO_2026-10-20_lezione2.txt` (copia byte per byte del file di Claudio `LIVE_PAOLO_20.10.26_2026-10-20_21-00-00-311.txt`, 60.381 byte, 34 righe lunghe, **nessun timestamp**). Il nome del file dice PAOLO ma chi parla si presenta come il responsabile del percorso e ringrazia Paolo Lavorenti come collaboratore: **[INCERTO]** che il relatore sia Emiliano; il nome file e' probabilmente un'etichetta sbagliata.
**Natura del documento:** e' un webinar di **promozione di un percorso a pagamento** ("workbook", "carte" da inviare al tutor, punti, "regalo finale", "chi entra nel percorso ha diritto agli algoritmi"), non una live operativa come le altre. Fuso orario: dichiara "ore 20" per il tasso FOMC e "20.30" per la conferenza stampa, e in un altro punto "8, 8.30, 8.40" (ora di New York): coerente con ora italiana [INFERITO]; in ora server BCM sono un'ora prima (CLAUDE.md).

> ## REGOLA CHE VALE SOPRA TUTTO
> **Da questo materiale non si muove NIENTE.** Ogni numero e' una dichiarazione del relatore: **[DICHIARATO DA LORO]**, non verificato, non e' un criterio ne' un parametro ne' una taglia. Nessun EA, preset, sedia, magic, conto (reale 10105439 compreso) e' stato toccato. Le ipotesi sotto sono **misure da fare**, con attesa scritta PRIMA dei numeri.

Etichette: **[TRASCRITTO]** · **[INFERITO]** (dico da cosa) · **[INCERTO]** · **[DERIVATO]** (calcolo mio) · **[LETTO nel repo: file]**.

---

## 0. La riga che conta
**Il webinar contiene tre regole con numeri, un solo "perche'" statistico (la benzina della volatilita' media) e nessun dato verificabile.** Le regole sono incomplete per un backtest (stop e target della strategia 200 sono "ATR H1" ma l'ingresso e' discrezionale: confluenze con supporti disegnati a mano). Solo la strategia "Post News" (FOMC) e' scritta punto per punto, ma ha **8 eventi l'anno**: in 21 mesi di tick BCM sono circa 14 eventi, **molto sotto il pavimento di 150 operazioni** delle nostre regole.
I numeri di performance mostrati ("1.358.000 EUR in un giorno, PF 7,97, DD 2,87%, 95% operazioni in positivo, oltre mille operazioni, commissioni 14.600") sono **[DICHIARATI]**, su un conto con "10 mila di bonus del broker" e leva dichiarata; non c'e' statement consegnato, non c'e' modo di verificare. Non entrano in nessuna tabella.

## 1. COSA C'E' DI NUOVO PER NOI (max 5)

| # | cosa | fonte nel testo | cosa dice il repo | IPOTESI misurabile (attesa scritta ora) |
|---|---|---|---|---|
| **W1** | **Stop = take profit = ATR(14) H1**: "88 punti in take profit e 88 in stop" sul DAX (esempio); l'ATR si legge su H1 al momento dell'ingresso. | "lo stop loss e' semplice, lo metto su questo numerino ... 88 punti" | Il 14/10 Emiliano aveva detto ATR H1 + 4 punti e ATR H1 DAX 37-40 [LETTO: ANALISI_LIVE_EMILIANO_2026-10-14.md N1]. 88 contro 37-40 e' un **conflitto non spiegato** (indice diverso? periodo? ATR in punti su un altro prodotto?). | Misurare l'ATR(14) H1 reale su D30EUR e sul Dow sullo storico BCM: se 88 e' fuori dall'intervallo storico, e' un errore o un altro strumento [attesa: ATR H1 DAX a 14/10 fra 35 e 60 con 70%]. |
| **W2** | **"Break-in" come terzo caso sulla EMA200**: il prezzo sorpassa la media ma la candela non apre sopra (apre sotto), quindi non e' breakout e si va contro il sorpasso. Regola di lettura: guarda **dove APRE la candela** rispetto alla media. | "se il culetto della candela mi apre sopra la media ... long ... break in quando lo sorpassa ma poi apre sotto" | `ABTG_EMA200`, `ABTG_CrossEma`, EMA200 D1 su M5: Dow H1 PF IS 1,20 / OOS 1,52 un solo regime; oro H4 PF 0,993 su 9,5 anni [LETTO: RESOCONTO_EA_PIANO_2026-10-05.md]. Il break-in come filtro d'ingresso non risulta misurato. | Classificare ogni incrocio EMA200 H1/H4 in reversal/breakout/break-in dal prezzo di apertura della candela e misurare l'esito a 10 barre per classe, su DAX, Dow, oro, in anni diversi [vedi CRITERI_TRE_REGIMI]. Attesa: nessuna classe con PF > 1,2 in tutti i regimi (60%). |
| **W3** | **Strategia Post News FOMC (otto volte l'anno)**: 30 minuti dopo il tasso (conferenza stampa), si lasciano passare due candele M5, si prende il massimo dei due massimi e il minimo dei due minimi, due ordini pendenti a **3 pip** fuori, **TP 50 pip, SL 25 pip**, solo EURUSD. Non si piazza se c'e' una resistenza forte appena sopra. | "TP 50 pips, stop loss 25 pips ... ordini pendenti a 3 pips" | Nel repo c'e' `abtg_news.csv` e un filtro notizie; nessuna strategia FOMC. | **Non testabile con le nostre regole**: circa 14 eventi in 21 mesi (n << 150), spread e slippage ai news non misurabili nel tester [NON MISURATO: costo ai news]. Al piu' una lettura descrittiva sugli eventi FOMC disponibili, con DD e peggior caso, **senza merito**. |
| **W4** | **Scalping sulla candela media Mataf**: a una certa ora (es. 14:00 per EURUSD) la candela media e' 24 pip; se la candela arriva a 25 pip si va contro e si chiude a 5-7 pip. | "se la candela arriva a 25 pips l'aspetto lì, lo sorto e mi porta a casa in scalping" | Non esiste nel repo. Stop non dichiarato. | Misurare la distribuzione: dopo che una candela H1 supera la sua escursione media oraria, la candela successiva e' di segno opposto? Su EURUSD H1 con storico lungo. Attesa: frequenza di inversione fra 48% e 54% (80%) cioe' nessun edge. **Specifica incompleta (manca lo stop)**: non e' un EA. |
| **W5** | **"Zero based allocation": al massimo il 20% del conto** (10.000 -> 2.000), e ingresso con **due ordini** da un terzo e due terzi a **20 pip** l'uno dall'altro, "non e' mediare, e' ottimizzare l'ingresso". | "entro sempre con due ordini ... distanziati di 20 pips" | Gia' noto: "secondo ordine doppio come unica operazione" e' una pratica da NON copiare [LETTO: ANALISI_LIVE_EMILIANO_2026-10-14.md N-bandiere]. | Nessuna misura nuova; e' una dichiarazione di sizing, e le taglie sono di Claudio. |

## 2. Quello che NON c'e'
Conteggi sul testo grezzo: oro / gold / GBA: **0**; Nasdaq / Dow: **0**; DAX: nominato come esempio di oggi ("German"); spread / slippage / commissioni come costo da testare: **0** (le commissioni compaiono solo come vanto: "14.600 a fronte di 1.300.000"); prop / FTMO / funded: **0**; martingala / griglia: nessuna parola ma **due ordini a distanza fissa** e leva "nei casi particolari"; EA da Market: **0**. Nessun fuso BCM, nessuna parola sull'inverno o sul cambio d'ora del 26/10 e 01/11.

## 3. Parametri dichiarati [tutti DICHIARATI da loro]
EMA 200 (esponenziale, "istituzionale"; sopra long, sotto short) e EMA 14 (primo obiettivo); due ordini a 20 pip, 1/3 + 2/3 della quantita'; volatilita' media da Mataf (EURUSD 53 pip su 10 settimane); ATR H1 (periodo non detto) per stop e target; ordini pendenti 3 pip fuori; FOMC TP 50, SL 25, 8 eventi/anno, EURUSD, candele M5; allocazione massima 20% del conto; "12-14 strategie" in uso (arsenale: Fibo H4, M200, ORB, Nasdaq M3, Post News).

## 4. Numeri di performance (tutti [DICHIARATI, NON verificati])
Conto "20 mila versati e 10 mila di bonus ai broker"; guadagno del giorno 1.358.000 EUR; commissioni di giornata 14.600; totale "5,5 milioni"; PF 7,97; DD 2,87%; 95% operazioni in positivo; piu' di mille operazioni; "il 20% dei partecipanti e' profittevole dopo sei mesi, il 50% dopo un anno, una parte non lo sara' mai". **Nessuno di questi e' collegato a uno statement consegnato.**

## 5. Bandiere
- **ROSSA — nessun dato verificabile, e dimensione fuori scala:** oltre 1,3 milioni in un giorno con 20+10 mila di capitale (+4.500% su 30 mila in un giorno) non e' compatibile con un rischio per operazione da "20% massimo" dichiarato; o la leva/lotto e' enorme, o il conto e' un altro. Non lo prendo come fatto.
- **ARANCIONE — conto con "bonus del broker":** i bonus cambiano le regole di margine e di prelievo; non e' un risultato replicabile da una prop.
- **ARANCIONE — incoerenza di numeri:** ATR H1 DAX 88 punti oggi, 37-40 il 14/10 (W1).
- **ARANCIONE — due ordini a distanza fissa con "leva nei casi particolari":** assomiglia a una media dell'ingresso; la regola S-NOSCALA delle nostre soglie lo guarderebbe.
- **AMBRA — marketing:** l'accesso agli "algoritmi" e' legato all'iscrizione a un percorso a pagamento; qui non ce n'e' nessuno in chiaro.
- **AMBRA — spiegazione "benzina della volatilita'" e "legge statistica" non misurata:** e' un'ipotesi (movimento a fine range medio = inversione), non una misura.

## 6. Cosa ne copiamo
**Niente.** Si possono misurare, a costo basso e senza toccare nulla, W1 (ATR H1 reale su DAX, Dow e oro) e W2/W4 come analisi descrittive su dati storici. W3 solo come lettura descrittiva dei circa 14 eventi FOMC disponibili. Prima di qualunque misura vale quanto scritto in `CRITERI_TRE_REGIMI_RIALZO_RIBASSO_LATERALE_2026-10-21.md` (finestre di regimi diversi).

## 7. Domande per Claudio / per Emiliano
1. Il relatore e' Emiliano? (il nome del file dice PAOLO). 2. L'ATR H1 del DAX da 88 punti di quale strumento e periodo era? 3. L'account con "10 mila di bonus" e' demo o reale, e c'e' uno statement consegnabile? 4. Il "livello di supporto D1" della strategia 200 e' tracciato con una regola scritta (Larry Williams, "massimi e minimi contrapposti")? Se si', si puo' codificare.

## 8. Verifiche e limiti
Letto l'intero file (35 righe in due pagine). Nessuna navigazione. Nessun calcolo su prezzi. Il fuso orario per i numeri FOMC e' una mia inferenza. Non ho misurato nulla nel repo: i riferimenti sono ai file citati.
