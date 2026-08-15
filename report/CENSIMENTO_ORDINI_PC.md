# 🧾 CENSIMENTO DEGLI ORDINI — quanto del conto vivo non è del portafoglio

_15/08/2026, `censimento_ordini.ps1` su entrambe le macchine, 60 giorni di
giornale. Risponde alla domanda aperta da `CACCIA_TICKET_770101.md` §6._

---

## 0. Il controllo che rende validi tutti i numeri che seguono

Ogni trade del CSV ha un `pid` (position id) che coincide con il ticket
dell'ordine che ha aperto la posizione. Incrociando i `pid` con i ticket
`PIAZZATO` dei due giornali, ogni trade finisce in tre pile: **PC**, **VPS**,
**ignoto**.

> **Degli ignoti, quanti hanno il magic di un EA? ZERO. Nessuno.**

Tutti i trade non attribuiti sono **senza magic**, cioè manuali o da telefono —
e infatti gli ordini piazzati dall'app mobile non passano dal giornale di un
terminale desktop. Sono concentrati **prima del 22/07**, quando il conto era
operato a mano.

**Conseguenza: per i trade degli EA — gli unici che riguardano il portafoglio —
l'attribuzione è completa al 100%.** Nessun buco, nessun "non lo so".

---

# 🔴 IL NUMERO

| il PC ha piazzato | |
|---|---:|
| ordini | **174** |
| giorni distinti | **16** (06/07 → 14/08) |
| conti toccati | **solo il 50503392**, il conto vivo |
| simboli | D30EUR **151**, XAUUSD 9, NASUSD 7, USOIL 3, EURNZD 3, CADCHF 1 |
| di quegli ordini, **eseguiti** | **33 trade veri** |
| **netto dei 33** | **−511,28** |

Non erano due giornate. Erano **sedici**, sparse su sei settimane.

## 1. Il conto piccolo, riletto

Prendendo la finestra in cui l'attribuzione è completa — **dal 22/07**, da
quando il conto lo operano gli EA e non più le mani:

| | trade | netto |
|---|---:|---:|
| **PC** (fantasma) | 21 | **−475,56** |
| **VPS** (la flotta vera) | 175 | **+93,14** |
| manuali residui | 1 | +41,72 |
| **totale letto finora** | 197 | **−340,70** |

> ## Il conto piccolo dal 22/07, tolto il PC, fa **+134,86** invece di −340,70.
>
> **La flotta sul VPS non è in perdita. È in leggero utile.** Il rosso del
> periodo del vivaio è il fantasma.

Per due settimane abbiamo letto quel rosso come "varianza sul win rate"
(R47). La varianza c'è, ed è misurata. Ma **il segno lo dava un'altra cosa.**

> ### ⚠️ PRECISAZIONE OBBLIGATORIA (15/08, dopo un'obiezione di Claudio)
>
> **Tutto quello scritto qui sopra riguarda SOLO il conto piccolo (50503392).**
> Il fantasma ha toccato **quel conto e basta**: sul **100k (50504263) i trade
> piazzati dal PC sono ZERO**, verificato.
>
> **Il 100k e' a −826,86 dal via, e quel rosso e' vero al 100%.** Non c'e'
> niente da depurare.
>
> Citare il "+134,86" o il "+31,84" **senza mettere accanto il −826,86 del
> 100k e' fuorviante**, ed e' esattamente l'errore che ho fatto nel
> presentarlo. Il conto che conta per la prop e' il 100k, ed e' in perdita.
>
> **Settimana 09-15/08, i due conti insieme, gia' depurati: −795,02.**

## 2. Il magic 770101 era un miscuglio di due macchine

| | trade | netto |
|---|---:|---:|
| `DAX Apertura EU` piazzato dal **PC** | **15** | **−437,87** |
| `DAX Apertura EU` piazzato dal **VPS** | 11 | −211,65 |

Lo stesso magic, sullo stesso conto, da due macchine diverse, con **config
diverse**. Ogni statistica calcolata su quel magic negli ultimi trenta giorni
mescolava due popolazioni. Non era rumore: erano due EA.

## 3. 💥 Il 29 luglio: lo stesso segnale, due volte, da due macchine

```
29/07  08:53:56   VPS   SELL 1,60 D30EUR   -120,80
29/07  08:53:56   PC    SELL 1,60 D30EUR   -115,04
```

**Stesso secondo. Stesso simbolo. Stessa direzione. Stesso volume.**
**−235,84 su un segnale solo**, cioè rischio doppio senza che nessuno lo
avesse deciso.

È lo stesso identico incidente refertato il 05/08 fra `DAX Apertura EU` e
`Apertura Marco` — ma qui i due EA non sono nemmeno sulla stessa macchina, e la
mitigazione A1 (`InpMaxPosSimbolo`, che conta le posizioni sul terminale) **non
poteva vederlo**: un terminale non vede i pendenti dell'altro finché non sono
eseguiti.

## 4. Altre due cose che il censimento tira fuori

**a) Il 22/07 il PC ha aperto NASUSD con la firma `DAX Apertura EU BUY`**
(buy 2,10, +15,46). Sul PC il DAX Apertura era attaccato a un **grafico
Nasdaq**: non è solo "una copia in più", è una copia **su un altro mercato**,
con parametri pensati per il DAX.

**b) 126 ordini FALLITI dal PC**, di cui **104 `Invalid price`**, 14 `Invalid
request`, 7 `Market closed`, 1 `Position doesn't exist`. Sono tentativi andati
a vuoto — ma sono anche la misura di quanto quell'istanza abbia provato a
operare, oltre alle 174 volte in cui c'è riuscita.

## 5. Cosa cambia, concretamente

**Sui numeri già scritti:**
- Le pagelle dal 22/07 in poi hanno attribuito al portafoglio **−475,56** che
  non erano suoi. **Non si riscrivono** (sono il verbale di quel che è
  successo), ma da oggi si legge la colonna giusta.
- Il magic 770101 va ricalcolato **solo sui trade del VPS** prima di
  confrontarlo con qualunque backtest.
- R47 ("il conto è sotto per varianza sul win rate") resta valido come misura
  del payoff, ma **la premessa "il conto è sotto" era in parte falsa**.

**Sulle cose da fare:**
1. ✅ Il rubinetto è già chiuso: ultimo ordine del PC il **14/08**, poi
   AutoTrading spento, EA staccato, ini del tester blindati.
2. ⬜ **Il controllo di tenuta**: rilanciare questo censimento fra una
   settimana. Se il PC ha piazzato **zero** ordini nuovi, il lucchetto tiene e
   il caso si chiude. È l'unica prova che vale.
3. ✅ **FATTO il 15/08 alle 13:53** — staccato l'ultimo (`Default\chart01.chr`,
   `BULGE_MULTI_SIGNAL_ARANCIO_L` su CADCHF), salvato in
   `MQL5\Profiles\_STACCATI_20260815_135315`, reversibile con `-Annulla`.
   **Sul PC ora ci sono ZERO EA attaccati, su entrambi i terminali.**

   _(storia)_ Staccare gli EA non nostri dai grafici del PC — sono loro la fonte dei
   104 `Invalid price`. **Censiti il 15/08: sono 11 grafici, 8 EA distinti**,
   tutti nel profilo `Default` del terminale `215D85D7...` (il referto del
   14/08 ne contava 10: ce n'era uno in piu', un secondo
   `BULGE_MULTI_SIGNAL_ARANCIO_S`).

   **Non sono "di terzi": sono LE FONTI del nostro lavoro** — PTE_V3_23 ->
   ABTG_PTE, GOLDEN_CROSS_V03 -> ABTG_GoldenCross, BULGE_MULTI_SIGNAL ->
   ABTG_BreakingBand, NIGHT_BREAK_BOX -> ABTG_MaxMinNotte, NQ_v21_S e' l'EA
   dell'amico gia' misurato e bocciato il 12/08. Vanno staccati perche' stanno
   su un terminale collegato al conto vivo, non perche' non siano nostri.

   Si fa **a mano in MT5** (tasto destro > Consulenti esperti > Rimuovi): cosi'
   grafici e template restano, e la bulge si continua a guardare a occhio.
   `backtest_pipeline/stacca_ea_terzi.ps1` stampa la checklist coi simboli e,
   rilanciato a lavoro finito, verifica che il conto sia sceso a zero.

   **Controllo di chiusura: `grafici con EA NON NOSTRI: 0`.**

   > ### 🔄 AGGIORNAMENTO 15/08 ore 13:50 — ne resta UNO
   >
   > Rilanciata l'anteprima, il profilo `Default` **non ha piu' 19 grafici: ne
   > ha UNO**, e sopra c'e' `BULGE_MULTI_SIGNAL_ARANCIO_L` su **CADCHF**.
   > Gli altri dieci EA non nostri non compaiono piu'.
   >
   > **[VERIFICATO]** dal referto: 1 grafico con EA non nostro, 28 senza, 0
   > nostri. Il secondo terminale (`73B7A242...`) e' pulito su tutti e quattro
   > i profili.
   >
   > **[INFERITO] il perche'**: MT5 riscrive il profilo attivo quando si
   > chiude. Claudio ha aperto MT5 la mattina (screenshot delle 07:00, grafico
   > **CADCHF,H1**, profilo `Default` in basso a destra) e chiudendolo ha
   > salvato **lo stato a schermo** — un grafico solo. I 19 di prima erano
   > l'ultimo salvataggio precedente.
   >
   > **E spiega lo screenshot delle 07:00**: Claudio scriveva "non c'e' nemmeno
   > un EA attaccato", ma su quel CADCHF **l'EA c'era** — e si vedeva pure, le
   > bande verdi sul grafico sono la Bulge. Non guardava il profilo sbagliato:
   > guardava il grafico giusto senza vedere la faccina.
   >
   > **Resta una cosa sola da fare, ed e' un grafico.** -> **fatto alle 13:53.**
   >
   > **E le date di salvataggio hanno confermato l'inferenza**: il profilo
   > `Default` di BCM risulta salvato **il 15/08 alle 10:07** (gli altri tre
   > profili BCM sono fermi al **06/07**). Cioe' e' stato riscritto proprio
   > quando Claudio ha chiuso MT5 in mattinata. Non era piu' un'ipotesi.
   >
   > **Identificati anche i due terminali** (da `origin.txt`):
   > `215D85D7...` = `C:\Program Files\BCM Markets MT5 Terminal` (il conto
   > vivo) · `73B7A242...` = `C:\Program Files\Pepperstone MetaTrader 5`.
4. ⬜ Ricalcolare le classifiche del forward escludendo i 33 trade del PC.

## 5-bis. 🚨 LA COSA PIU' GRAVE, vista in uno screenshot del 15/08 alle 07:00

Barra del titolo di MT5 **sul PC**:

```
50503392 - BCMMarkets-Server: Conto Demo - Hedge - BCM Markets Ltd - [CADCHF,H1]
```

> **Il PC di backtest e' LOGGATO SUL CONTO VIVO.**

Le posizioni e i pendenti che si vedono in basso (`EMA200 DOW L1/L2`,
`LARRY EURAUD S`, `LARRY ORO L`) **non sono aperti da li'**: un terminale
collegato a un conto vede tutto quello che c'e' sul conto, chiunque l'abbia
messo. Quelli sono della flotta del VPS. Nessun allarme su quello.

**L'allarme e' la riga del titolo.** Tutto il caso del fantasma — 174 ordini,
33 trade, −511,28 — sta in piedi su una condizione sola: **il PC e' collegato
al conto che vale soldi**. Gli EA attaccati e AutoTrading sono i due
interruttori, ma il filo e' quello.

Finche' il filo c'e', bastano due distrazioni in fila (apro il profilo
sbagliato + accendo AutoTrading per una prova) e riparte tutto. E le abbiamo
gia' viste succedere.

**La chiusura vera del caso non e' staccare gli EA: e' scollegare il PC dal
conto vivo.** Il tester non ne ha bisogno — gira sullo storico, non sul conto —
e per scaricare i dati basta un conto demo qualunque, separato.

## 6. Il limite, dichiarato

La finestra è di **60 giorni** e i giornali disponibili sono 22 sul PC e 47 sul
VPS. Prima del 22/07 l'attribuzione è incompleta **per i trade manuali**, che
non passano dal giornale desktop. Per i trade con magic — gli unici che
contano qui — non manca niente: zero ignoti con magic, su 592 trade in
finestra.

Il netto del conto in quel periodo (−15.835 di trade manuali) **non è oggetto
di questo referto** e non va confuso col portafoglio.
