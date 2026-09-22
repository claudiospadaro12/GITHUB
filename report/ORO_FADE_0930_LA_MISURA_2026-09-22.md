# 🥇🔄 IL **FADE** DELLE ESPLOSIONI DELL'ORO ALLE 09:30 ET — **BOCCIATO**, e non per un pelo

**22/09/2026** · misura su **due campioni indipendenti** · strumento nuovo
`backtest_pipeline/sonda_fade_oro.py` · **niente toccato in campo, nessuna sedia proposta**

---

## 0. 🎯 LA DOMANDA, e perche' valeva la pena farla

`report/ORO_2021_2026_LA_MISURA_2026-09-22.md` aveva misurato che **SEGUIRE**
l'esplosione delle 09:30 ET **perde**, su due campioni indipendenti. Il verso opposto —
**fare FADE**, cioe' entrare **contro** l'esplosione alla fine della finestra — aveva
**mediana positiva in tutte e due le finestre**. 🟠 Sembrava una porta aperta.

🔴 **Ma la mediana non e' il PF.** Un fade puo' avere mediana positiva e PF sotto 1,
perche' ogni tanto l'esplosione **continua** e si riprende in una volta quello che ha
dato in venti. E' il **rischio strutturale del fade su un breakout**.

> ### 🔴 **E quel rischio non e' un'ipotesi teorica: si e' MISURATO, ed e' esattamente quello che succede.**

---

## 1. ✅ PRIMA DEI NUMERI: LE ANCORE, E SONO PASSATE TUTTE E DUE

La definizione di esplosione **non e' stata reinventata**: e' **importata per nome** da
`backtest_pipeline/anatomia_esplosioni_oro.py` (finestre 30', `mov = close(ultimo) −
open(primo)`, esplosione se `|mov| >= 0,40 × ATR14 giornaliero`, fascia 09:30 di New York
col suo calendario DST). Se quel file cambia, cambia anche questo: niente soglia
copia-incollata.

| campione | barre M1 | finestra misurata **dal dato** | finestre 30' | esplosioni 09:30 ET | attese | esito |
|---|---|---|---|---|---|---|
| **2006-2020** (Oanda) | 4.884.366 | 2006-03-19 → 2020-05-14 | 154.787 | **111** | 111 | ✅ **PASSATA** |
| **2021-2026** (HistData) | 1.979.587 | 2021-01-03 → 2026-09-18 | 64.343 | **51** | 51 | ✅ **PASSATA** |

🟢 **Le due ancore tornano al numero esatto**: i numeri di questo referto si confrontano
con quelli vecchi. Se non fossero tornate, lo strumento si sarebbe **fermato da solo**
(`sys.exit(2)`), non avrebbe stampato un referto incomparabile.

🟢 **AUTOTEST: 11 prove su 11**, girate **prima** di leggere un solo dato vero —
niente look-ahead (troncare il futuro non cambia il passato: le 6 operazioni del campione
troncato sono identiche nel campione intero), il costo tolto e' **esattamente 2 per giro**
(col contro-esempio che verifica che a **3** costi il controllo **rifiuta**), l'ingresso
avviene **dopo** la fine della finestra, il verso del fade e' l'opposto dell'esplosione.

### 🔴 E UNA DISCREPANZA CHE VA DETTA, non nascosta: il COSTO
L'incarico dice **«0,2003 $/oncia PER LATO, quindi 2 costi per giro»**. Ma
`report/ORO_1530_CANCELLO_COSTO_2026-09-10.md` par. 2.4 scrive **testuale**: *«Costo pieno
di un **GIRO COMPLETO** sull'oro: 0,16 $ (spread) + 0,0403 $ (commissione) = **0,2003 $**»*,
e `anatomia_esplosioni_oro.py` r.80 lo rilegge allo stesso modo. 🔴 **Le due letture
differiscono di 2x.**
👉 **Non ho scelto la comoda**: il numero **principale** e' quello **SEVERO**
(2 × 0,2003 = 0,4006 $/giro, la lettura dell'incarico), e quello documentato
(0,2003 $/giro) e' stampato accanto come sensibilita'. **Con il costo piu' leggero il
verdetto non cambia** (i PF salgono di 3-5 centesimi: si vede nelle tabelle sotto).

---

## 2. 🔴 IL RISULTATO — **il PF sta sotto 1 quasi ovunque, e la soglia non la tocca nessuno**

**Soglia dichiarata PRIMA dei numeri, e non si e' spostata: PF netto >= 1,20 su TUTTI E DUE
i campioni.** Con n=51 e n=111 un 1,05 non vuol dire niente.

### 📉 2006-2020 — n = 111 esplosioni (110 con uscita disponibile)

| uscita | **PF netto** | netto totale | mediana | a favore | **peggiore singola** | **5 peggiori** | 5 migliori / lordo vincente |
|---|---|---|---|---|---|---|---|
| **+15 min** | **0,970** | −14,95 $ | +1,13 $ | 53,6% | **−95,89 $** | −226,44 $ | 30,9% |
| **+30 min** | **0,839** | −114,18 $ | −0,49 $ | 48,2% | **−97,79 $** | −262,10 $ | 31,2% |
| **+60 min** | **0,920** | −72,35 $ | +0,53 $ | 52,7% | **−161,05 $** | −376,75 $ | 31,4% |

### 📉 2021-2026 — n = 51 esplosioni (49 con uscita disponibile)

| uscita | **PF netto** | netto totale | mediana | a favore | **peggiore singola** | **5 peggiori** | 5 migliori / lordo vincente |
|---|---|---|---|---|---|---|---|
| **+15 min** | **1,014** | +2,93 $ | +2,55 $ | 59,2% | −57,67 $ | −149,33 $ | 36,7% |
| **+30 min** | **0,866** | −44,49 $ | +2,39 $ | 61,2% | −56,10 $ | −209,25 $ | 37,2% |
| **+60 min** | **1,477** | +150,62 $ | +5,84 $ | 59,2% | −61,01 $ | −186,60 $ | 40,3% |

*(cifre in dollari d'oggi, oro 4.330 $; costo applicato in RELATIVO — 0,004552% del prezzo
per costo — perche' applicare 0,2003 $ piatti all'oro del 2008 a 800 $ sarebbe un pedaggio
finto. La versione a dollari piatti e' nel referto grezzo, ed e' **peggiore**.)*

> ### 🔴 **ZERO uscite su tre passano la soglia su TUTTI E DUE i campioni. Il +60' del 2021-2026 e' l'unico a passare su UNO — e la sezione 4 spiega perche' quel numero non vuol dire niente.**

---

## 3. 🎯 **LA PREVISIONE DEL RISCHIO STRUTTURALE SI E' AVVERATA ALLA LETTERA**

Era scritto nell'incarico, **prima** di misurare: *«un fade puo' avere mediana positiva e
PF sotto 1»*. Ecco le due righe che lo dimostrano, e sono le righe piu' istruttive del
referto:

| riga | mediana | quante vanno a favore | **PF netto** |
|---|---|---|---|
| **2021-2026, +30 min** | **+2,39 $** 🟢 | **61,2%** 🟢 | **0,866** 🔴 |
| 2006-2020, +15 min | +1,13 $ 🟢 | 53,6% 🟢 | 0,970 🔴 |

> ### 🔴 **Il fade a +30' del campione nuovo VINCE SEI VOLTE SU DIECI, ha la mediana positiva — E PERDE SOLDI.**
> Perche' quando perde, perde **grosso**: la peggiore singola operazione del 2006-2020 a
> +60' vale **−161,05 $** contro una mediana di **+0,53 $**. 👉 **La coda e' 304 volte la
> vincita tipica.** Venti giorni a raccogliere spiccioli, uno a restituirli tutti.

### 🟢 Una cosa va detta, ed e' a favore del fade
🟢 **Il contro-esempio «lotteria» NON e' scattato.** Le 5 migliori operazioni valgono
**31-40%** del lordo vincente, sempre **sotto** la soglia del 50%. 👉 Quindi il fade
**non e' una lotteria vinta da cinque giorni**: e' peggio in un senso e meglio in un
altro — **non c'e' proprio niente da vincere**, ma nemmeno un numero gonfiato da pochi
colpi. Il verdetto e' **«nessun vantaggio»**, non **«vantaggio finto»**. La differenza
conta, perche' dice che **non serve cercare la cella giusta**: non c'e'.

---

## 4. 🧪 I TRE CONTRO-ESEMPI — e uno di loro **uccide anche il PF 1,477**

### 🧪 CONTRO-ESEMPIO 2/A — **la permutazione degli esiti**, quello che pesa
Le esplosioni restano **quelle vere**, il verso del fade resta **quello vero**, `n` resta
**identico**: si permuta **solo il SEGUITO**, attaccando a ogni esplosione il seguito di un
**altro giorno**, stessa fascia e stesso anno. **400 ripetizioni.** La domanda e' l'unica
che conta: *il seguito VERO premia il fade piu' del seguito di un giorno a caso?*

| campione | uscita | **PF vero** | PF finto, mediana | **banda P5-P95 del finto** | **quante volte il FINTO batte il VERO** |
|---|---|---|---|---|---|
| 2021-2026 | +15 | 1,014 | 0,890 | 0,47 – 1,66 | **36,0%** 🔴 |
| 2021-2026 | +30 | 0,866 | 0,930 | 0,49 – 1,72 | **58,0%** 🔴 |
| **2021-2026** | **+60** | **1,477** | 0,961 | **0,47 – 1,82** | **12,8%** 🔴 |
| 2006-2020 | +15 | 0,970 | 0,912 | 0,57 – 1,42 | **43,5%** 🔴 |
| 2006-2020 | +30 | 0,839 | 0,967 | 0,56 – 1,55 | **68,8%** 🔴 |
| 2006-2020 | +60 | 0,920 | 0,988 | 0,59 – 1,60 | **59,5%** 🔴 |

> ### 🔴 **SEI righe su SEI vengono battute dal caso piu' del 5% delle volte. Il seguito vero di un'esplosione NON e' distinguibile dal seguito di un giorno qualunque.**
> E qui c'e' **il numero che vale tutto il referto**: con n=49, la banda di puro rumore va
> da **PF 0,47 a PF 1,82**. 👉 **Il famoso 1,477 del +60' cade DENTRO quella banda**, e il
> caso lo batte **12,8 volte su 100**. 🔴 **Non e' un motore: e' il posto dove si ferma la
> pallina quando n e' cinquanta.**

### 🧪 CONTRO-ESEMPIO 2/B — la passeggiata aleatoria a volatilita' appaiata
Le **forme** delle barre (`h/o`, `l/o`, `c/o`) sono permutate dentro **lo stesso
minuto-del-giorno** fra giorni diversi, e il prezzo e' ricatenato: l'orologio della
volatilita' resta identico, sparisce **solo** la sequenza.

🔴 **E ha una DEBOLEZZA che va dichiarata prima del suo numero**: permutando le barre si
distrugge anche il **raggruppamento** della volatilita', e le esplosioni **crollano** — da
111 a **61** sul campione vecchio, da 51 a **16** sul nuovo. **Un null con un terzo delle
operazioni del vero non e' appaiato: e' un altro esperimento.** 👉 **Per questo il
contro-esempio che pesa e' il 2/A, non questo** — ed e' il motivo per cui il 2/A e' stato
scritto.

🔴 **Detto cio', il suo verdetto e' ancora piu' brutale, e va riportato: sul 2006-2020 la
passeggiata a +15' fa PF 1,136 — cioe' SOPRA la soglia di 1,05 che avevo dichiarato come
"allora la misura si butta", e SOPRA il fade vero (0,970).** Il fade vero **perde contro
una serie finta**. (Con n=61 anche questo e' rumore — la banda del 2/A lo conferma — ma la
regola l'avevo scritta io, e scatta.)

### 🧪 CONTRO-ESEMPIO 3 — **e se il fade rendesse uguale a QUALUNQUE ora?**
Se guadagna ovunque allo stesso modo, non e' l'ora delle 09:30: e' il fade in generale, e
il ritrovamento delle 09:30 **non c'entra**.

| campione | **09:30 ET**, PF +30 | **monte unico di TUTTE le altre fasce** | n delle altre | quante fasce battono le 09:30 (+30') |
|---|---|---|---|---|
| 2006-2020 | **0,839** | **0,790** (n=1.036) | 1.036 | **3 su 12** |
| 2021-2026 | **0,866** | **1,031** (n=360) | 360 | **1 su 3** |

> ### 🔴 **Le 09:30 non sono speciali per il fade. Sul campione nuovo il monte di TUTTE LE ALTRE FASCE (PF 1,031, n=360) fa MEGLIO delle 09:30 (0,866).**
> 🟢 E si noti il contrasto che chiude il cerchio: le 09:30 **sono** speciali per
> l'ESPLOSIONE (5,75x il tasso medio, confermato su due feed) — ma **la specialita'
> finisce li'.** L'ora dice **quando** il mercato si muove, **non da che parte tornera'**.

---

## 5. 🏁 IL VERDETTO CONTRO LA SOGLIA DICHIARATA

| uscita | PF 2006-2020 | PF 2021-2026 | soglia 1,20 su **tutti e due** | esito |
|---|---|---|---|---|
| +15 min | 0,970 | 1,014 | ❌ nessuno dei due | 🔴 **BOCCIATO** |
| +30 min | 0,839 | 0,866 | ❌ nessuno dei due | 🔴 **BOCCIATO** |
| +60 min | 0,920 | 1,477 | ❌ solo uno, e dentro il rumore | 🔴 **BOCCIATO** |

> # 🔴 **IL FADE DELLE 09:30 ET E' BOCCIATO. Su 6 misure (3 uscite x 2 campioni) il PF netto passa la soglia UNA volta, e quella volta il caso la batte il 12,8% delle volte.**

🟢 **E la buona notizia c'e', anche se non e' quella che speravamo**: la domanda e' chiusa
**con i numeri in mano, in una serata, su 6,8 milioni di barre M1**, invece di finire in un
round da giorni-macchina sul PC di backtest. **Una porta che si chiude misurata vale
un'ora di lavoro; una porta lasciata socchiusa costa settimane.** E la porta che resta
aperta sull'oro — quella vera — e' un'altra: **l'ORA esiste ed e' riprodotta**, quindi
quello che manca non e' il *quando*, e' il **meccanismo**.

---

## 6. 🛑 CHE COSA **NON** E' MISURATO — e va scritto, se no non e' un certificato

Per la regola di casa del 09/09 (*«un morto senza certificato non e' un morto»*), quello
che questa misura **non** ha toccato:

1. 🔴 **Il fade e' NUDO: nessuno stop, nessun target, uscita secca a orologio.** E' stato
   dichiarato prima dei numeri, ed e' un **limite vero**: uno stop cambia la coda, che e'
   proprio la cosa che qui si misura. 👉 Ma la direzione del limite e' **a favore del
   verdetto, non contro**: senza stop la coda e' quella **vera** del mercato, e il PF e'
   gia' sotto 1. Uno stop **taglia le perdite grosse ma paga il premio in operazioni
   chiuse in perdita**, e non trasforma un 0,84 in un 1,20 quando il contro-esempio 2/A
   dice che **non c'e' segnale** da cui partire.
2. ⚪ **Nessun DD di portafoglio** (la coda c'e', il drawdown per sedia no): non serviva,
   perche' la misura si ferma prima — sul PF.
3. ⚪ **Nessun simbolo gemello, nessun TF diverso**: questa e' una misura su **una fascia
   oraria di un simbolo**, non un censimento di famiglia. Il certificato di morte pieno
   riguarderebbe *«il fade come meccanismo»*, e **questo referto non lo rilascia**: chiude
   **il fade delle esplosioni alla fascia 09:30 ET, a uscita d'orologio**, che e' la
   domanda che era stata posta.
4. 🟢 **Nessuna delle due soglie e' stata spostata dopo aver visto i numeri.** La 1,20, la
   regola della lotteria al 50% e la soglia 1,05 della passeggiata erano scritte
   **nell'intestazione dello strumento** prima della prima corsa — e la 1,05 e' scattata
   **contro di noi**, ed e' riportata lo stesso.

---

## 📁 FONTI E RIPRODUCIBILITA'

| cosa | dove |
|---|---|
| strumento | `backtest_pipeline/sonda_fade_oro.py` (ASCII puro, 0 byte non-ASCII, autotest 11/11) |
| referto grezzo 2006-2020 | `backtest_pipeline/risultati_prove/SONDA_FADE_ORO_2006_2020.txt` |
| referto grezzo 2021-2026 | `backtest_pipeline/risultati_prove/SONDA_FADE_ORO_2021_2026.txt` |
| definizione di esplosione | **importata** da `backtest_pipeline/anatomia_esplosioni_oro.py` |
| dati 2021-2026 | `backtest_pipeline/risultati_prove/oro_m1_utc_2021_2026` (6 file, gia' in repo) |
| dati 2006-2020 | 🔴 **RISCARICATI IL 22/09**, e lo dichiaro: la cache `/tmp/sonda_st_cache` conteneva **solo 2013-2018**. Ripresi i 99 mesi mancanti dalla **stessa sorgente** del round originale (`FutureSharks/financial-data`, percorso `currencies/oanda/XAU_USD/`). Copertura risultante **identica** all'originale — 2006 parte da **marzo** e 2020 finisce a **maggio** perche' **a monte non esiste altro**, non perche' abbia tagliato io. 🟢 **La prova che la ricostruzione e' fedele: l'ancora delle 111 esplosioni torna al numero esatto.** |
| misura precedente | `report/ORO_2021_2026_LA_MISURA_2026-09-22.md` |

🔵 **Nessuna riga inviata a Claudio, niente sul VPS, forward non toccato, nessuna sedia
proposta.**

**Righe di lancio per riprodurre** (girano **qui**, zero MT5):
```
python3 backtest_pipeline/sonda_fade_oro.py --dati backtest_pipeline/risultati_prove/oro_m1_utc_2021_2026 \
    --etichetta 2021-2026 --random-walk --fuori backtest_pipeline/risultati_prove/SONDA_FADE_ORO_2021_2026.txt
python3 backtest_pipeline/sonda_fade_oro.py --dati <cartella oro 2006-2020> \
    --etichetta 2006-2020 --random-walk --fuori backtest_pipeline/risultati_prove/SONDA_FADE_ORO_2006_2020.txt
```
