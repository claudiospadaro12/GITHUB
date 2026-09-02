# SCHEDA CANDIDATO -- "RSI + EMA Crossover Signals V8" (incollato da Claudio, 31/08/2026 sera)

**Fonte:** Pine v6, 52 righe, incollato in chat (autore non dichiarato, nessun link).
**Meccanica:** cross RSI(14) sopra/sotto la sua SMA(14) arma un pending;
il segnale scatta quando EMA(5) incrocia EMA(20) nello stesso verso;
il pending si annulla sul cross opposto (RSI o EMA). Segnali su barra
confermata. E' un INDICATORE: zero uscite, zero stop/take, zero sessione,
zero taglia, zero numeri d'autore.

## VERDETTO DI CARTA: NON PROMOSSO (31/08/2026)

Bocciato al confronto col registro dei caduti (regola d'ingresso dell'imbuto):
1. Trigger EMA-cross: SuperWave (EMA14x200) morto; Chaos Lyapunov (EMA 9/21
   + gate LLE) bocciato due volte (31/08).
2. Filtro armato sopra trigger generico = famiglia "filtro appiccicato",
   0/5 in casa.
3. Coppia RSI+EMA: M0PB morto lo stesso 31/08, 12/12 al passo 0
   (REFERTO_SONDAM0PB_2026-08-31.md).
4. Nessuna geometria propria (le uscite andrebbero inventate: rischio di
   misurare il contenitore, lezione LondonFx) e nessuna inefficienza nominata.

## PORTA DI RIENTRO (scritta ora, come da regola)
Se si vuole il numero vero: sonda di conteggio sullo stampo ABTG_SondaM0PB
(costo: mezzo cantiere + minuti di corsa). Criteri da congelare PRIMA:
F1 >= 1 segnale/giorno per lato; H8 RR da mediane >= 0,70 (FIRMA 2);
fascia F2 da definire per il simbolo scelto. Sotto uno qualunque: resta morto.

---

# PORTA DI RIENTRO **ESERCITATA** -- 02/09/2026

**Chi l'ha aperta:** Claudio, esplicitamente e **due volte** (01-02/09), contro
il verdetto di carta qui sopra. Motivo dichiarato: il candidato ha diritto a
essere ucciso dai **numeri**, non dall'analogia coi suoi parenti morti. Un
verdetto di carta confermato da una misura e' un esito **diverso e piu' solido**
di un verdetto di carta e basta.

**Stato: SONDA COSTRUITA. NESSUN NUMERO ANCORA.** Non e' stata compilata (in
questo ambiente non esistono MetaEditor ne' Strategy Tester) e non e' stata
lanciata. La riga di lancio la scrive un altro turno.

## Cosa e' stato consegnato
| cosa | dove |
|---|---|
| la sonda (contatore puro, zero ordini) | `mql5/Experts/ABTG_SondaRsiEmaV8.mq5` |
| criteri congelati PRIMA, M5 | `backtest_pipeline/prove/RSIEMAV8_FREQUENZA_M5.txt` |
| criteri congelati PRIMA, M15 (gemella) | `backtest_pipeline/prove/RSIEMAV8_FREQUENZA_M15.txt` |

Stampo: `ABTG_SondaM0PB.mq5` (collaudato sul campo il 31/08) + le migliorie di
`ABTG_SondaLondonFx.mq5` (ablazione contata dentro ogni passata; blocchi di
autotest contati contro un `#define`; verdetti come funzioni pure eseguite
dall'autotest; MFE/MAE con ritardo di misura, cosi' nessun segnale ha
l'orizzonte troncato).

## I cancelli, congelati PRIMA di qualunque numero
Sono **piu' severi** di quelli scritti nella porta qui sopra, non piu' morbidi:

- **F1** -- due condizioni in **AND**: segnali **totali (L+S) >= 2,00/giorno**
  (pavimento firmato da Claudio l'01/09) **E** **>= 1,00/giorno per lato**
  (pavimento della scheda del 31/08). Cade una qualunque -> **MORTO**.
- **F2** -- MFE mediana a **12 barre** (muro d'attrito), in punti indice:
  **> 7,0 VIVO | < 5,0 MORTO | 5,0-7,0 inclusi SOSPESO**
  `[SPREAD NON MISURATO, si scioglie col Code Base 74148]`.
  Disuguaglianze senza sovrapposizioni e senza buchi (clausola severa 31/08).
- **H8** -- RR da mediane (MFE/MAE) **>= 0,70**, altrimenti **MORTO PER
  ARITMETICA** senza spendere una corsa a tick (FIRMA 2 del 31/08).

## La domanda della scheda diventa un numero (ablazione)
L'accusa di carta era *"filtro appiccicato sopra trigger generico"*. La sonda la
**misura** invece di discuterla: in **ogni** passata escono, per lato,
`Segnali Nudo` (soli incroci EMA), `Armamenti Rsi`, `Pending Attivo` (barre col
latch armato) e `Segnali` (motore completo).
- Se `Segnali ~ Nudo` e il pending e' armato quasi sempre -> il filtro **non
  filtra**, il motore **e'** un incrocio di EMA, cioe' SuperWave / Chaos
  Lyapunov, gia' morti due volte: **l'accusa risulta MISURATA**.
- Se `Segnali << Nudo` -> il pending morde davvero, e la domanda torna a F1.

## Le due cose nuove rispetto allo stampo, e vanno controllate nel referto
1. **`Stato Ambiguo Long/Short` deve essere 0.** Il pending e' un **latch**: non
   dimentica per decadimento come una media, quindi ricostruirlo su una coda di
   barre non e' gratis. La sonda fa girare la macchina a stati **due volte** con
   semi opposti; se i due esiti divergono la barra e' ambigua, il segnale **non
   viene contato** (si tiene il seme pessimista: si sbaglia CONTRO il candidato)
   e il caso finisce in colonna. Se quelle colonne non sono zero, `InpWarmupBarre`
   e' troppo corto e **i numeri di quella corsa non valgono**.
2. **L'ordine degli eventi dentro la barra** (arma -> disarma -> segnala) e' la
   fedelta' vera al Pine, ed e' interrogato da **6 blocchi di autotest su 16**.
   Conseguenze dichiarate: armamento e segnale possono cadere sulla **stessa**
   barra; dopo un segnale un secondo incrocio EMA nello stesso verso **non** spara
   finche' l'RSI non riarma.

## Banco: IDENTICO alla corsa M0PB del 31/08 (voluto)
3 indici (U30USD lead, NASUSD, D30EUR) x {M5, M15}, modello **2** (solo prezzi
di apertura), finestra **2024.09.26 -> 2026.06.30**, **2 passate** sull'unico
asse `InpModoPrezzoIngresso` (1 = riga del verdetto, 0 = sensibilita' gratis).
Il confronto col morto del 31/08 dev'essere **diretto**, non "quasi".
I quattro numeri del motore (14/14/5/20) sono `#define`, **non** input: in un
PASSO 0 sweeparli servirebbe solo a pescare la cella che fa passare il pavimento.

## Attribuzione -- caso anomalo, va letto
Pine v6, 52 righe. **Autore IGNOTO** (non dichiarato nel sorgente).
**Provenienza: incollato in chat da Claudio, 01-02/09/2026** -- nessun link,
nessuna pagina: non e' stato possibile risalire alla fonte e non si e' finto di
averlo fatto. **Licenza NON DICHIARATA** (che non vuol dire "libera": vuol dire
**ignota**, ed e' piu' vincolante). Quindi: porting per **uso interno di misura**,
**NO redistribuzione come roba nostra**, e prima di qualunque EA operativo si
ritrova la fonte e si legge la licenza. Il sorgente **non** e' in
`biblioteca/sorgenti/` perche' lo schema di casa nomina i file con autore e
licenza, e qui i due campi non esistono.

## Verifiche statiche gia' fatte a macchina (02/09)
ASCII puro (0 byte > 127), 0 tab, 0 CR. Graffe/parentesi/quadre bilanciate.
Contatore puro: **0 chiamate di trading nel codice** (le uniche occorrenze in
tutto il file sono nelle righe di commento che le negano). **59 nomi di colonna =
59 specificatori = 59 argomenti**, `stats[56]` con indici contigui 0..55 e ogni
nome allineato al proprio valore. 13 input nel sorgente = 13 pin nel file prova,
nessun pin fantasma e nessun input non pinnato (errore n.3 della checklist).
16 blocchi di autotest, tutti prefissati, **zero dichiarazioni duplicate**, e il
contatore a runtime e' confrontato col `#define`. I 16 blocchi sono stati
**rieseguiti in una riproduzione indipendente del nucleo puro: 16/16 verdi**; la
stessa riproduzione, fatta girare su una passeggiata casuale tipo indice, da'
`Stato Ambiguo = 0`, `MFE/MAE >= 0` col modo 1 e `Segnali <= Nudo`.
**Resta da fare la sola cosa che conta: compilare e far girare.**
