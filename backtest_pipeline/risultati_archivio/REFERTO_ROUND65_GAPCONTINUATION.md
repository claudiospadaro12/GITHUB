# 🎯 R65 — `ABTG_GapContinuation` · 225JPY M1 · IL PRIMO CHE PASSA

_Terzo e ultimo dei tre EA adottati dal Code Base il 16/08. Screening **OHLC**
(Modello 1), deposito 100.000, rischio 1%, walk-forward 40/60.
IS **2024.09.26 → 2025.06.09** · OOS **2025.06.10 → 2026.06.30**._

**Cancelli verificati nella `.ini` generata:** fuso in **modo manuale**
(`InpSessionTimeMode=1`, apertura **01:00**, chiusura **07:30** ora server BCM),
**asimmetria long/short SPENTA** (`InpReduceRiskOnSmallSellGap=0`, entrambi i
rischi a 1,0%), magic **774101**. Dati: `risultati_archivio/GapContinuation/`.

---

## 1. ✅ IL CRITERIO ZERO PASSA, E DI MOLTO

Era **il** dubbio del file prova: _"l'evento e' raro per costruzione... se la
famiglia non arriva a 15 trade, il round non da' un verdetto sulla tesi: da'
un verdetto sul SIMBOLO"_.

| | IS | OOS |
|---|---:|---:|
| trade totali | **3.138** | **5.610** |
| n per cella | 39 – 86 | **69 – 151** |
| celle con n ≥ 15 | 54/54 | **54/54** |

**Il timore era infondato.** L'evento non e' raro: con soglie di gap fra 0,50%
e 1,00% ci sono decine di occasioni l'anno. Cade anche definitivamente
l'ipotesi "un trade per lunedi'" che avevo avanzato in R62 e gia' ammorbidito.

## 2. ✅ 53 CELLE SU 54 POSITIVE FUORI CAMPIONE — e 18 su 18 sulla diagonale

La regola del file prova e' esplicita: **si sceglie solo sulla diagonale
simmetrica** (`buy == sell`); le 36 celle fuori diagonale **misurano**
l'asimmetria, non si adottano.

| gap | OR | TP_R | IS profit | **OOS profit** | **PF** | n OOS | DD% |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 1,00 | 15 | 2 | **+3.013,85** ← *picco IS* | +4.415,05 | 1,217 | 69 | 12,09 |
| 1,00 | 15 | 3 | **+2.437,54** | **+7.542,65** | **1,363** | 69 | 11,78 |
| 1,00 | 10 | 2 | +334,59 | +7.727,28 | 1,361 | 75 | 8,90 |
| 0,50 | 15 | 2 | +143,76 | +7.449,13 | 1,225 | 116 | 13,80 |
| 0,75 | 15 | 2 | −767,98 | +7.739,35 | 1,294 | 92 | 12,97 |
| 0,75 | 5 | 3 | −5.910,24 | **+17.323,70** | **1,600** | 115 | — |

**Tutte e 18 le celle della diagonale sono verdi fuori campione**, con PF da
**1,217 a 1,600**.

## 3. 🎯 E QUI STA LA DIFFERENZA CON GLI ALTRI DUE

Anche qui la relazione IS→OOS e' **rovesciata** (quindicesima misura su
sedici): le celle piu' rosse dentro sono le piu' verdi fuori.

> **Ma stavolta l'inversione non fa male.** In `CanaleLento` l'inversione
> metteva la scelta del metodo **in rosso** (−812). Qui, **qualunque** cella
> della diagonale si scelga, fuori campione si guadagna: la peggiore fa
> **+4.415 con PF 1,217**.
>
> **Un edge che non dipende da quale cella indovini e' l'unica forma di
> robustezza che i nostri trent'anni di ribaltamenti non hanno mai smentito.**

### La cella, scelta sull'IS e col centro dell'altopiano

Il picco IS e' `gap 1,00 / OR 15 / TP_R 2` (+3.013,85) → **non si prende**.
Accanto, sempre IS-positiva: **`gap 1,00 / OR 15 / TP_R 3`**.

| | a rischio 1% | a taglia prop 0,65% | muro |
|---|---:|---:|---|
| OOS profit | **+7.542,65** | — | — |
| PF OOS | **1,363** | — | ≥1,10 🟢 |
| n OOS | **69** | — | ≥15 🟢 |
| DD OOS | 11,78% | **7,66%** | 10% 🟢 |
| peggior giornata | −1,00% | **−0,65%** | −5% 🟢 |

✅ **Criterio 1 passato** (OOS > 0 e PF ≥ 1,10). ✅ **Criterio 3 passato** (DD
mai sopra il 20%, peggior giornata sopra −2,5%). ✅ **Cancello prop passato con
margine su entrambi i muri.**

---

## 4. 🔴 MA IL CRITERIO 1 AVEVA UN AVVERTIMENTO, ED E' SCATTATO

Dal file prova, scritto prima dei numeri:

> _"Il confronto che rende il round interessante e' con il gemello opposto:
> `ABTG_GapFill` su 225JPY fa +76 OOS, PF 1,14. **Se ANCHE la continuazione e'
> verde sullo stesso simbolo e sullo stesso evento, non e' una doppia
> vittoria: e' il sospetto che una delle due stia leggendo rumore. Va detto,
> non festeggiato.**"_

**E' esattamente quello che e' successo.** Sullo stesso simbolo, sullo stesso
evento, **nella direzione opposta**:

| | tesi | OOS | PF |
|---|---|---:|---:|
| `ABTG_GapFill` (R36/R37) | il gap **si chiude** | +76 | 1,14 |
| `ABTG_GapContinuation` (R65) | il gap **continua** | **+7.542** | **1,363** |

Due scommesse opposte, entrambe verdi. **Una delle due sta leggendo qualcosa
che non e' la tesi dichiarata** — oppure le due meccaniche, malgrado i nomi,
non stanno prendendo lo stesso evento (soglie diverse, orari diversi,
gestione diversa).

🎯 **E' la domanda numero uno del prossimo round**, e si risponde in un modo
solo: **confrontando i trade, non i totali.** Servono i due
`abtg_trades_*.csv` e si guarda **quanti giorni sono in comune**. Se i due EA
operano negli stessi giorni in direzioni opposte, uno dei due e' rumore. Se
operano in giorni diversi, sono due motori diversi col nome sbagliato.

---

## 5. ⚠️ COSA QUESTO ROUND NON DICE

1. 🔴 **Il criterio 2 NON e' stato valutato.** Diceva: _"il lato SHORT si
   misura da solo, long e short vanno letti SEPARATAMENTE. Se regge solo il
   long, NON ha riempito il buco degli short."_ Il CSV di riepilogo **non
   separa i lati**. Serve `abtg_trades_ABTG_GapContinuation_225JPY_774101.csv`
   dalla cartella comune. **Finche' non e' letto, non si puo' dire che questo
   EA riempia il buco n.3.**
2. 🔴 **E' OHLC, quindi non e' un verdetto** (R57: cambiando solo il modello
   il segno dell'orso si e' ribaltato). Il verdetto e' a tick reali — e su
   225JPY i tick ci sono dal **2024.09.26**, quindi la finestra tick-real
   coincide con questa. **Si puo' fare subito.**
3. 🟡 **La regione IS-positiva sta nell'ANGOLO della griglia** (gap 1,00 = il
   massimo spazzolato, OR 15 = il massimo consentito dall'EA). Un altopiano
   che tocca il bordo non e' un altopiano: e' un pendio tagliato. **Il gap va
   spazzolato oltre 1,00** per vedere se il massimo e' li' o piu' in la'.
4. 🟡 **L'IS e' quasi tutto rosso** (14 celle negative su 18 in diagonale) e
   l'OOS tutto verde. Un ribaltamento **al contrario** e' comunque un
   ribaltamento: qualcosa e' cambiato fra le due finestre su 225JPY, e finche'
   non si sa cosa, il numero OOS va tenuto con le pinze.
5. Il fuso resta valido **solo per il periodo estivo misurato**: il DST di BCM
   e' una misura aperta (scadenza 25/10/2026).

---

## 6. 🚦 VERDETTO

> **PASSA lo screening — il primo dei tre.** 5.610 trade fuori campione, 53
> celle verdi su 54, la scelta del metodo a **PF 1,363 con DD 7,66% e peggior
> giornata −0,65% a taglia prop**. Nessun altro candidato di oggi era
> arrivato a questo punto.
>
> **Ma NON e' promosso**, e per due ragioni scritte prima dei numeri: il
> **criterio 2 non e' stato valutato** (lati non separati) e il **criterio 1
> ha fatto scattare l'avvertimento del gemello** (`GapFill` verde nella
> direzione opposta sullo stesso evento).

**I prossimi passi, in ordine:**
1. **Leggere i lati** dai `abtg_trades_*.csv` → criterio 2;
2. **Confronto giorno per giorno con `ABTG_GapFill`** → sciogliere il sospetto
   del gemello;
3. **Tick reali** sulla stessa finestra (i tick di 225JPY ci sono) → verdetto;
4. estendere il gap **oltre 1,00** → verificare che l'altopiano non sia un
   bordo;
5. **solo dopo** la prova di regime e l'eventuale forward.
