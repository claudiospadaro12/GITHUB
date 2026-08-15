# 🔥 PIANO DI RI-TEST TOTALE — criteri congelati PRIMA dei numeri

_15/08/2026. Claudio: "voglio ritestare tutti gli EA, voglio riprovare a
trovare parametri migliori. Ce la dobbiamo dare."_

**Ci sto, e si fa.** Ma si fa nella versione che puo' funzionare, non in
quella che i nostri stessi dati hanno gia' bocciato. Questo file esiste per
scrivere i criteri **adesso**, prima di vedere un solo numero.

---

## 1. ⚠️ IL NUMERO CHE DECIDE COME SI FA: Spearman NEGATIVO

`Spearman` misura se l'ordine delle celle **in campione** predice l'ordine
**fuori campione**. Ecco tutti i valori che abbiamo misurato noi:

| round / strumento | Spearman IS→OOS |
|---|---|
| R11 ORB DAX | **−1,00** |
| DAX apertura (asse RangeMode) | −0,90 |
| Nasdaq (RangeMode PREVBAR) | −0,80 |
| altre righe R-serie | −0,70 · −0,60 · −0,60 · −0,30 |
| R-serie recente (Dow) | −0,357 |
| DAX retest | −0,277 |
| Nasdaq | +0,042 |

**Undici misure su dodici sono NEGATIVE.**

> 🚨 **Spearman negativo vuol dire una cosa sola: sulla nostra finestra corta,
> scegliere la cella migliore in campione e' PEGGIO che sceglierne una a
> caso.** Non "poco utile": **peggio del caso**.

Quindi "cercare parametri migliori" **sugli stessi 21 mesi** non e' neutro,
e' **dannoso**: piu' si cerca, piu' si trova rumore, e il rumore poi si paga.

**Ma il numero che rende Spearman negativo e' la LUNGHEZZA della finestra,
non l'idea di ottimizzare.** Ed e' esattamente quello che oggi cambia.

## 2. 🚀 Cosa e' cambiato oggi (e perche' adesso il ri-test ha senso)

| | prima (BCM) | adesso (Dukascopy) |
|---|---|---|
| storico indici | **21 mesi** | **14 anni** (2012→2026) |
| regimi coperti | **1** (indici in salita) | **almeno 4**: crollo 2020, orso 2022, 2018, 2015 |
| finestre OOS possibili | **1** | **4-5 in sequenza** |

**Una finestra OOS e' UN campione. Cinque finestre sono un test.** E' questo
il salto, non il fatto di rilanciare le griglie.

## 3. 🧭 IL PIANO, in quattro fasi e in quest'ordine

### FASE 0 — I DATI (senza questa, tutto il resto e' aria)
Portare dentro lo storico lungo degli indici. Cancello ZERO gia' congelato in
`PROVA_REGIME_CRITERI.md`: differenza media dalle chiusure native BCM
**> 0,05% del prezzo** oppure **< 80%** di barre in comune → **il simbolo non
si usa**. Prima si sistema il feed, poi si misura.

### FASE 1 — PROVA DI REGIME A PARAMETRI CONGELATI
Tutte le celle vive, **esattamente come sono**, sulle 4 finestre di regime.
**Qui non si cerca niente: si verifica.** Rischio di overfitting: **zero**.

Risponde alla domanda vera: **chi sopravvive a un mercato che non sale?**

Esito per ogni cella, dichiarato ora:
- positiva in **≥3 regimi su 4** → 🟢 **robusta**, resta e puo' passare alla fase 2
- positiva in **2 su 4** → 🟡 resta a **taglia ridotta**, con l'avvertenza scritta
- positiva in **≤1 su 4** → 🔴 **esce dal portafoglio**

### FASE 2 — RI-OTTIMIZZAZIONE, ma SOLO sui sopravvissuti e SOLO a finestre multiple
Qui si cercano davvero parametri migliori, e stavolta si puo':

1. **Walk-forward ANCORATO A FINESTRE MULTIPLE** (rolling), non un solo
   split IS/OOS. Minimo **4 finestre** consecutive.
2. **Si sceglie il CENTRO DELL'ALTOPIANO che resta buono in TUTTE le
   finestre**, mai la cella migliore in una sola. Regola di sempre.
3. **Un parametro nuovo entra solo se batte quello vivo in ≥3 finestre su 4.**
   Vincere in una finestra non e' una prova, e' un aneddoto.

### FASE 3 — IL PORTAFOGLIO DECIDE L'ULTIMA PAROLA
Standard invariato: **"aggiunge profitto E abbassa le code"**. In tutto il
progetto e' passato **4 volte**. Un parametro che migliora la singola sedia
ma alza le code del portafoglio **non entra**.

## 4. 🔬 LA MISURA NUOVA, che vale quanto il resto del piano

**Spearman diventa una metrica di prima classe, misurata e scritta in ogni
round.**

- Se su **14 anni** Spearman IS→OOS diventa **positivo** → l'ottimizzazione su
  quella famiglia **ha senso**, e i parametri nuovi si possono adottare.
- Se resta **negativo anche su 14 anni** → 🛑 **quella famiglia non e'
  ottimizzabile, punto.** I suoi parametri si congelano al centro
  dell'altopiano e non si toccano mai piu'.

**In entrambi i casi abbiamo imparato qualcosa di definitivo**, e smettiamo
di sospettarlo: lo sappiamo. Questo, da solo, vale il ri-test.

## 5. 🛑 Le tre cose che NON si fanno, decise ora

1. **Non si ri-ottimizza sui 21 mesi di BCM.** Spearman dice che li' cercare
   e' peggio che non cercare.
2. **Non si tocca nessun parametro in forward** finche' non e' passato dalle
   fasi 1→2→3. Le sedie vive continuano a girare come sono.
3. **Non si cercano parametri nuovi sui dati vecchi durante la fase 1.**
   Sarebbe overfitting su una finestra piu' lunga: **lo stesso errore con
   piu' anni**.

## 6. 📋 Perimetro: cosa entra nel ri-test

- **Indici** (DAX, Dow, Nasdaq, S&P, Nikkei): la parte che oggi si sblocca.
  Qui stanno le sedie grosse — Apertura EU/US, ORB, EMA200, SuperWave.
- **Forex e metalli**: gia' fatti in R50 su 4 regimi, con feed HistData
  validato. **Da estendere** alle celle non ancora coperte.
- **Il vivaio**: resta fuori. Vale la regola dei **15 trade**, e non si
  ri-ottimizza qualcosa che non ha ancora un verdetto forward.

---

> ### La frase che tiene insieme tutto
> **Non stiamo rifacendo le stesse griglie sperando in un numero migliore:
> stiamo portando le stesse strategie davanti a quattordici anni e quattro
> regimi che non hanno mai visto.** Chi passa lo avra' dimostrato. Chi non
> passa, lo avremo scoperto adesso invece che con i soldi veri.
