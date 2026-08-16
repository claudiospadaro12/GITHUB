# 🎯 R62 — GAPFILL Nasdaq: LA SOGLIA VERSO IL BASSO (16/08/2026)

_Il seguito di R61. Domanda della FASE B, per intero: **"le occasioni salgono
restando redditizie?"**_

**Banco:** identico a R61 riga per riga (verificato con `diff`: differiscono
solo i due assi). NASUSD M5, **tick reali**, deposito 100.000, rischio 1%,
`InpEntryMode=1`, **`InpSessionHour=14`**, volumi OFF.
IS 2024.09.26→2025.06.09 · OOS 2025.06.10→2026.06.30.
Griglia **`pts` 0-50 × `RR` 0,5/1,0/1,5 = 18 celle**. Dati:
`risultati_archivio/GapFill_Nasdaq/`.

---

## 1. LA RISPOSTA: **le occasioni salgono, ma NON restano redditizie**

**18 celle su 18 positive fuori campione**, e l'asse stavolta morde davvero
(10 celle distinte su 18, contro le 6 su 24 di R61). Ma la direzione e'
inequivocabile:

| RR | da `pts 50` | a `pts 0` | trade in piu' | profitto in piu' | **per trade** |
|---:|---|---|---:|---:|---:|
| 0,5 | n=33 · +8.100,16 | n=43 · +6.763,32 | **+10** | **−1.336,84** | **−133,68** |
| 1,0 | n=26 · +7.649,67 | n=32 · +6.464,96 | **+6** | **−1.184,71** | **−197,45** |
| 1,5 | n=19 · +5.915,09 | n=21 · +4.588,19 | **+2** | **−1.326,90** | **−663,45** |

> 🎯 **I trade che si guadagnano abbassando la soglia sono PERDENTI, a tutti
> e tre gli RR.** Ogni occasione in piu' costa fra 134 e 663 euro.

E peggiora tutto il resto, sempre nella stessa direzione:

| | `pts 50` | `pts 0` |
|---|---|---|
| PF OOS (RR 1,0) | **2,007** | 1,706 |
| DD OOS (RR 0,5) | **5,08%** | **6,02%** |
| PF OOS (RR 0,5) | **1,838** | 1,545 |

✅ **Il criterio 5 non scatta**: la cella `pts=0` **non** e' la migliore — e'
la peggiore per qualita' in ogni riga. **La tesi "il gap e' l'edge"
sopravvive alla falsificazione.** La soglia serve davvero.

---

## 2. 🔬 MA IL PERCHE' E' PIU' INTERESSANTE DEL RISULTATO

**`InpGapMinPoints` e `InpGapMinRR` non sono due manopole: sono due manopole
sulla STESSA cosa, e la seconda domina.**

Il filtro RR (EA righe 1466 e 1482) pretende `reward/risk >= InpGapMinRR`,
dove `reward` e' la distanza dal prezzo alla chiusura precedente — **cioe' il
gap stesso** — e `risk` e' lo stop, che ha un pavimento: `InpMinStopPts=500`.

Quindi il filtro RR **impone gia' da solo una soglia di gap**:

| RR | gap minimo implicito | asse `pts` spazzolato |
|---:|---:|---|
| 0,5 | **~250 punti** | R61: 50-300 · R62: 0-50 |
| 1,0 | **~500 punti** | idem |
| 1,5 | **~750 punti** | idem |

> 🔴 **Ecco perche' in R61 la soglia in punti non mordeva fra 100 e 300: il
> filtro RR aveva gia' alzato il pavimento a 250-750 punti.** Non era un
> difetto dei dati, era un asse ridondante — e nessuno se n'era accorto,
> nemmeno chi ha scritto la FASE B.

**Conseguenza operativa:** `InpGapMinPoints` non e' la leva da girare su
questo motore. Se un giorno si volesse davvero cambiare il numero di
occasioni, la leva vera e' **`InpMinStopPts`** (che muove il pavimento
implicito), non la soglia in punti.

---

## 3. ⚠️ `pts = 20` E' UN PICCO IN CAMPIONE, E NON TIENE

Salta all'occhio nella tabella IS, **a tutti e tre gli RR**:

| RR | pts 0/10 | **pts 20** | pts 30-50 |
|---:|---:|---:|---:|
| 0,5 | 12.830,67 | **13.817,24** | 11.336,94 / 11.033,88 |
| 1,0 | 10.947,07 | **12.106,96** | 9.652,12 |
| 1,5 | 9.518,96 | **10.669,78** | 8.911,34 |

Un solo valore che batte i vicini **da entrambi i lati, su tre righe
indipendenti**. Fuori campione **sparisce**: a RR 1,0 `pts 20` fa
esattamente lo stesso di `pts 30` (+7.461,63), e a RR 1,5 lo stesso di
`pts 30-50` (+5.915,09).

**E' il manuale della cella migliore**: sarebbe stata la scelta di chi guarda
l'IS e ordina per profitto. La regola del centro dell'altopiano l'ha evitata
senza bisogno di sapere niente dell'OOS. **Tredicesima conferma su
quattordici.**

---

## 4. ✅ LA CELLA REGGE, ED E' LA STESSA DI R61

Scelta **sull'IS soltanto**, centro dell'altopiano: la regione piatta a
RR 1,0 e' **`pts` 30-50** (IS 9.652,12 identico su tutti e tre).

| | R61 | **R62** |
|---|---|---|
| cella | RR 1,0 · pts 50 | RR 1,0 · pts 40-50 |
| OOS profit | +7.649,67 | **+7.649,67** |
| PF | 2,007 | **2,007** |
| n | 26 | **26** |
| DD | 3,91% | **3,91%** |

**Identica al centesimo, in due round indipendenti.** La misura e'
riproducibile.

### 🏛️ Cancello prop — passato

**Peggior giornata OOS: −1,03% in TUTTE E 18 le celle**, contro il cancello
inasprito a −2,0% e il muro prop di −5%. Cioe' **un solo stop pieno**:
`InpOneTradePerDay` tiene anche con la soglia a zero. Era il rischio che
avevo scritto nel criterio 3, e non si e' materializzato.

---

## 5. ✍️ UNA CORREZIONE CHE DEVO A ME STESSO

Nel file prova di R62 avevo scritto, come **[INFERITO]**, che questo motore
_"non trada il gap di apertura, trada il gap del WEEKEND: un trade per
lunedi'"_, basandomi su n=36 contro ~37 settimane in IS.

**Era troppo forte.** A `pts=0` / RR 0,5 l'IS fa **n=47** su ~180 giornate,
cioe' il **26%** dei giorni: piu' dei soli lunedi'. L'ipotesi va ammorbidita:
il motore trada **i giorni con un gap grande**, che i lunedi' li contengono
ma non li esauriscono.

⚠️ **La verifica vera resta aperta e non l'ha sciolta questo round**: se
NASUSD su BCM quota quasi 24 ore, quello che l'EA chiama "gap" e' il
**movimento notturno**. Si guarda se ci sono barre M1 fuori sessione.

---

## 6. 🚦 VERDETTO

> **La domanda della FASE B ha risposta, ed e' NO: abbassare la soglia
> aggiunge occasioni che perdono. La cella di R61 (RR 1,0, pts 30-50) resta
> quella buona, confermata al centesimo da un secondo round indipendente —
> PF OOS 2,007, DD 3,91%, peggior giornata −1,03%, n=26.**
>
> **E il filone "piu' occasioni" e' chiuso da questa parte:** `InpGapMinPoints`
> e' un asse ridondante, schiacciato dal pavimento implicito del filtro RR.

**Cosa resta da fare, in ordine:**
1. **verifica del gap su CFD 24/5** — barre M1 fuori sessione su NASUSD. E'
   il presupposto della tesi, ed e' l'unica cosa che puo' ancora ribaltare
   il nome della strategia (non i numeri);
2. **prova di regime** sulla cella congelata (parametri CONGELATI, nessuna
   ottimizzazione);
3. **n=26 in 12,7 mesi** = ~2 trade al mese: sopra il pavimento dei 15, ma
   il forward per un verdetto vero e' lungo. Ottimo passeggero;
4. il round separato gia' indicato dal dossier G: **RETEST col filtro
   volumi** (OOS +274,35 · PF 1,109 · DD 3,68%), che scatta su giorni
   diversi e quindi convive col GAPFILL.
