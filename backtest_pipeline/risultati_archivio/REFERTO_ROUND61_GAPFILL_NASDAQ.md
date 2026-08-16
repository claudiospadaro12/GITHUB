# 🎯 R61 — LA SPAZZOLATA GAPFILL SUL NASDAQ (16/08/2026)

_La misura che `REFERTO_FASE_B_C5.md` aveva ordinato e che nessuno aveva
mai lanciato: **"GAPFILL: misura da rifare in grande, spazzolando
`InpGapMinPoints` e `InpGapMinRR`. Con 19 trade non si decide niente."**_

**Banco:** `ABTG_Nasdaq_Apertura_US` · NASUSD · M5 · **Modello 4 (tick reali)** ·
deposito 100.000 · rischio 1% · `InpEntryMode=1 (GAPFILL)` ·
**`InpSessionHour=14` (ora server BCM = 15:30 IT)** · `InpUseVolumeFilter=0`.
IS **2024.09.26 → 2025.06.09** · OOS **2025.06.10 → 2026.06.30**.
Dati grezzi: `risultati_archivio/GapFill_Nasdaq/`.

---

## 1. ✅ IL RISULTATO: 24 celle su 24 positive fuori campione

| pts | RR | IS profit | PF | n | **OOS profit** | **PF** | **n** | DD% | pegg.GG% |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 50 | 0,5 | 11.033,88 | 2,000 | 39 | **8.100,16** | 1,838 | 33 | 5,08 | −1,03 |
| 50 | 1,0 | 9.652,12 | 2,211 | 28 | **7.649,67** | 2,007 | 26 | 3,91 | −1,03 |
| 100 | 1,0 | 9.392,54 | 2,179 | 26 | **7.772,60** | 2,063 | 24 | 3,90 | −1,03 |
| 150-300 | 1,0 | 9.392,54 | 2,179 | 26 | **7.260,42** | 1,993 | 23 | 3,90 | −1,03 |
| 50-300 | 1,5 | 8.911,34 | 2,301 | 23 | **5.915,09** | 1,954 | 19 | 3,90 | −1,03 |
| 50-300 | 2,0 | 4.501,32 | 1,661 | 19 | **7.752,81** | 2,871 | 16 | 2,92 | −1,03 |

**Nessuna cella rossa fuori campione.** Il PF OOS sta fra **1,84 e 2,87**, il
drawdown fra **2,92% e 5,08%**, e la peggior giornata e' **−1,03% in tutte e
24 le celle** — cioe' un solo stop pieno, che e' esattamente cio' che ci si
aspetta da un motore a **una posizione, un trade al giorno**.

E il confronto con la FASE B torna: alla cella pinnata (pts 150, RR 1,5) il
round fa **n=19 OOS con PF 1,954**, contro il **n=19 con PF 1,937** del
referto originale. **Stessi trade**, profitto diverso solo per la taglia del
deposito. La misura e' riproducibile.

---

## 2. 🔴 MA LE CELLE DISTINTE SONO **SEI**, NON 24

Ed e' il difetto che conta piu' del risultato.

| profit IS | n | quali celle |
|---:|---:|---|
| 11.033,88 | 39 | RR 0,5 · pts **50** |
| 10.856,52 | 36 | RR 0,5 · pts 100-300 → **5 celle identiche** |
| 9.652,12 | 28 | RR 1,0 · pts **50** |
| 9.392,54 | 26 | RR 1,0 · pts 100-300 → **5 celle identiche** |
| 8.911,34 | 23 | RR 1,5 · pts **50-300** → **6 celle identiche** |
| 4.501,32 | 19 | RR 2,0 · pts **50-300** → **6 celle identiche** |

> ### `InpGapMinPoints` NON MORDE sopra i 100 punti.
> Da 100 a 300 le righe sono **identiche al centesimo**, in IS e in OOS. La
> soglia taglia qualcosa solo fra 50 e 100 (due trade), e sopra i 100 non
> taglia piu' niente: **su NASUSD i gap che restano sono tutti piu' grandi
> di 300 punti.**

**Conseguenza:** 48 pass a tick reali hanno prodotto **6 risposte**. E
soprattutto: **l'altopiano sull'asse `pts` e' un'illusione** — non e' una
regione robusta, sono la stessa corsa ripetuta sei volte. La robustezza vera
va letta **solo sull'asse RR**, che di valori ne ha quattro.

⚠️ Chi legge la tabella senza questo paragrafo conclude "24 su 24, che
altopiano". **Sono 6 su 6, ed e' comunque un buon risultato — ma e' un altro
numero.**

---

## 3. 🎯 LA CELLA: **RR 1,0**, pts qualunque fra 50 e 300

Scelta **sull'IS soltanto**, come pretende il metodo, e col **centro
dell'altopiano, mai il picco**:

- il picco IS e' `pts 50 / RR 0,5` (11.033,88) → **non si prende**;
- l'asse RR ha quattro valori tutti positivi: il centro sta fra **1,0 e 1,5**;
- fra i due si prende **RR 1,0**, perche' ha **piu' trade** (26 IS / 23-26 OOS
  contro 23 / 19) e sotto n=20 il PF non si giudica.

**Verifica OOS (che NON e' servita a scegliere): +7.260 / +7.772, PF ~2,0,
n 23-26, DD 3,90%.**

E il metodo regge da solo: **anche prendendo il picco IS** si sarebbe finiti
su +8.100 OOS. Qui, per una volta, Spearman non morde — ma la regola resta,
perche' e' stata scritta su tredici misure e non su questa.

### 🏛️ Cancello prop

| | valore | muro |
|---|---:|---|
| peggior giornata | **−1,03%** | −5% 🟢 |
| DD OOS | **3,90%** | −10% 🟢 |
| serie perdente peggiore | **−3.004,67** (−3,0% su 100k) | 🟢 |
| frequenza | **~2 trade al mese** | 🟡 ottimo passeggero, pessimo pilota |

---

## 4. ⚠️ COSA QUESTO ROUND **NON** DICE

1. **Non ha risposto alla domanda della FASE B.** La domanda era _"le
   occasioni salgono restando redditizie?"_. Le occasioni salgono
   **abbassando** la soglia (150→50 porta l'OOS da 19 a 26 trade a RR 1,0),
   ma **50 e' il valore piu' basso spazzolato**. La direzione giusta era
   sotto, e li' non siamo andati. 👉 **Prossima griglia: `pts` 0-50.**
2. **n resta piccolo**: 16-33 trade OOS. Sopra il pavimento dei 15, ma la
   cella RR 2,0 (n=16, PF 2,871) **non e' giudicabile sul PF** e il suo
   numero non va citato come se lo fosse.
3. **Il "gap" su un CFD 24/5 e' ancora da verificare** (limite (a) del
   dossier G): se NASUSD quota quasi 24 ore, quello che l'EA chiama gap e'
   il **movimento notturno**, non un vuoto di prezzo. La tesi resterebbe
   sensata ma **diversa da quella dichiarata**. Si verifica guardando se
   ci sono barre M1 fuori sessione.
4. **Una finestra sola, un simbolo solo.** Sono i numeri migliori
   dell'arsenale: la reazione giusta e' il sospetto, non la festa.

---

## 5. 🐛 UN BUG TROVATO NEL BLOCCO OPTFRAME — riguarda TUTTI gli EA

Le due ultime colonne prop escono **uguali**:

```
Perdite Consecutive Max : -3005      (formattata %.0f)
Serie Perdente Peggiore : -3004.67
```

`OnTester` scrive `stats[8]=TesterStatistics(STAT_MAX_CONLOSSES)` e
`stats[9]=TesterStatistics(STAT_CONLOSSMAX)`. Escono **entrambe in denaro**,
quindi la colonna intitolata _"Perdite Consecutive Max"_ **non contiene un
conteggio**: l'informazione _"quante perdite di fila"_ — che per una prop e'
una domanda vera — **oggi non ce l'abbiamo su nessun EA**.

**[INCERTO]** quale delle due costanti MT5 dia il conteggio: va verificato
sulla documentazione e poi corretto nel blocco OPTFRAME, che e' inlinato in
tutti gli EA testabili.

---

## 6. 🚦 VERDETTO

> **Il GAPFILL del Nasdaq regge, ed e' il candidato piu' forte uscito oggi:
> PF OOS ~2,0 con DD 3,90% e peggior giornata −1,03%. Ma il round va
> RIFATTO con l'asse giusto (`pts` 0-50), perche' quello spazzolato non
> mordeva e ha prodotto sei risposte invece di ventiquattro.**

**Prossimi passi, in ordine:**
1. griglia `pts` **0-50** × RR 0,5-1,5 → la domanda della FASE B, per intero;
2. verifica del **gap su CFD 24/5** (barre M1 fuori sessione);
3. solo dopo: **prova di regime** sulla cella congelata;
4. e il round separato gia' indicato dal dossier G: **RETEST col filtro
   volumi** (OOS +274,35 · PF 1,109 · DD 3,68%), che scatta su giorni
   diversi dal GAPFILL e quindi ci convive.
