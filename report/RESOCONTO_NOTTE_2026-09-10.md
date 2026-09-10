# 🌙 COSA E' SUCCESSO STANOTTE — 09→10/09/2026

## 🙋 PRIMA L'ONESTA': **io stanotte NON ho lavorato.**
Dopo che Claudio e' andato a letto (01:40) la sessione e' rimasta ferma. Dall'01:40 a
stamattina c'e' **UN SOLO commit**, ed e' **automatico**: `79f9062 — snapshot + news EA del
giorno [skip ci]`, delle 05:00.
👉 **Tutto quello che segue l'ha fatto la MACCHINA, non io.** E' comunque tanto.

---

## 🎯 IL RUNNER HA GIRATO LA CODA INTERA — **prima volta in assoluto**

```
righe di coda: 10
ESEGUITO: 10      RIFIUTATO: 0
```
| | ieri (09/09) | stanotte (10/09) |
|---|---|---|
| eseguite | 4 su 10 | ✅ **10 su 10** |
| rifiutate | 🔴 6 (404) | ✅ **0** |

**La riparazione dei pin di ieri mattina ha funzionato.** `CODA_05`-`10` non erano **mai**
girate: stanotte hanno girato tutte, cancelli **G1 e G2 passati** su tutte e dieci, tempi
2-44 secondi.

---

# 💎 LA NOTIZIA GROSSA: **LO SLIPPAGE SUL CONTO REALE E' MISURATO**

Ieri sera avevo scritto: *"`SlippageLogger` sul reale: ancora ZERO deal"*. **Non e' piu'
vero, e la correzione e' bella:**

```
conto 10105439 @ BCMMarkets-Server   tipo: REALE
deal esaminati 2161   registrati NUOVI: 3   scansioni 27.266   autotest: 0 falliti
```

### 📏 IL NUMERO, dal deal vero
| | |
|---|---|
| operazione | `DAX Apertura EU RETEST BUY` · magic **770101** · D30EUR |
| quando | **08/09 12:50:48** (ora server) |
| prezzo **richiesto** | 25.983,10 |
| prezzo **eseguito** | 25.983,80 |
| **SLIPPAGE** | **+0,70 punti indice** (avverso) = **0,21 €** su 0,30 lotti |

### 🟢 E l'uscita in STOP: **slippage 0,00**
| gruppo | n | mediana | max | costo |
|---|---:|---:|---:|---:|
| D30EUR **INGRESSI** | 1 | **0,700** | 0,700 | 0,21 € |
| D30EUR **uscita SL** | 1 | **0,000** | 0,000 | **0,00 €** |
| magic 770101 uscite SL | 1 | **0,000** | 0,000 | **0,00 €** |

👉 Sul campione che c'e' (**n=1 per gruppo: e' un indizio, non una statistica**) lo stop e'
stato riempito **al prezzo esatto**, e l'ingresso ha pagato **0,7 punti indice**.
📐 Per confronto: la **frontiera del costo** su D30EUR e' `40 x spread` = **64-68 punti
indice**. Uno slippage di 0,7 e' **l'1% di quella soglia**: non e' lui il problema.

## 🚨 E LO STRUMENTO HA TROVATO UNA TRAPPOLA CHE NESSUNO CERCAVA
Testuale dal referto:
> *"**ATTENZIONE: la fonte B coincide con l'eseguito in TUTTE le righe.** Vuol dire che
> questo server **NON riporta il livello richiesto nel prezzo dell'ordine**: una misura
> basata su B direbbe **'slippage zero' su QUALUNQUE conto**. Sulle righe dove esiste, fa
> fede la fonte C."*

🔴 **Tradotto: il modo piu' ovvio di misurare lo slippage su BCM darebbe SEMPRE ZERO.** Non
perche' non c'e', ma perche' il server non scrive il dato dove uno andrebbe a cercarlo.
Chi lo misurasse cosi' concluderebbe *"su BCM non c'e' slippage"* — e sarebbe **falso**.
👉 Lo strumento se ne e' accorto **da solo** e ha usato la fonte giusta. Se ne fosse
accorto fra sei mesi, avremmo portato in una prop un numero inventato.

---

## 🔴 UN DIFETTO NUOVO, trovato dalla prima corsa di `CODA_05`
```
=== CARTELLA ...  programma: C:\MT5_Backtest       profilo attivo: 'Default'   -> la cartella del profilo attivo NON ESISTE
=== CARTELLA ...  programma: BCM Markets MT5 Terminal   profilo attivo: 'ORO'  -> NON ESISTE
... e cosi' per tutti e SEI i terminali
```
👉 **Il censimento delle sedie via file `.chr` non funziona su nessun terminale**: la
cartella del profilo attivo non e' dove lo script la cerca. Da qui viene il buco gia'
dichiarato *"foto `.chr` ferma al 25/08"*. **Adesso sappiamo perche'.**

## 🖥️ E UNA SCOPERTA UTILE PER OGGI: **sul VPS ci sono SEI terminali, non quattro**
`C:\MT5_Backtest` · `BCM Markets MT5 Terminal` (piccolo) · `BCM Markets MT5 Terminal -V3`
(100k) · `C:\BCM_Reale` · **`Pepperstone MetaTrader 5`** · **`Tickmill Europe MT5 Terminal`**
🎯 **Pepperstone e' sul VPS** — quindi la sonda sugli indici Pepperstone (`GER40`, la
"domanda mai fatta") si puo' fare **senza toccare il PC**.

## ✅ E una conferma che i round di ieri sono andati dove dovevano
`CODA_06` legge i sorgenti compilati sul terminale da backtest:
`ABTG_SupRev_DOW_H1_Ottimizzato.mq5 v1.01 — compilato 2026-09-09 19:53` = **R123**.
`ABTG_DAX_Apertura_EU.mq5 — 09:37` e `ABTG_Nasdaq_Apertura_US.mq5 — 09:54` = **R120**.
Nessuna sorpresa, nessun binario inatteso.

## 📓 `CODA_09` — il giornale operativo
Conto **50504400** (backtest): **0 righe di ordine** l'08 e il 09/09 → **non ha operato**,
com'e' giusto. Nessuna riga Guardian.

---

## 🎯 COSA ASPETTA CLAUDIO STAMATTINA
1. 🔍 **Il censimento del terminale**, 10 secondi — l'ultimo passo prima dell'import dei
   nove anni di DAX (le tre firme D-G, D-B e D-H sono gia' a verbale).
2. 🟢 **La sonda indici Pepperstone**: adesso sappiamo che il terminale e' sul VPS.
3. 🔴 **Il difetto dei profili `.chr`**: da riparare, altrimenti il censimento delle sedie
   resta cieco.
