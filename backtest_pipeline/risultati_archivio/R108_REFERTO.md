# 🏁 R108 — REFERTO DEL ROUND: BREAKING BAND SU M15 (GBPUSD · EURUSD · AUDUSD)

_Corsa: 25/08/2026 21:24-21:48 (0,4 ore), pin `de7134e`, driver
`RIGA_R108_BB_M15.ps1` v1. Esito driver: **PARZIALE** — 1 cella su 6 con il
PASSO 0 non misurabile (EURUSD M15, deal non accoppiati), tutte le altre OK.
**[AGG. 26/08: quel "non accoppiati" era un difetto del PARSER
(`Sort-Object` non stabile), non dell'EA. PROBLEMA CHIUSO e PASSO 0
RECUPERATO — vedi il blocco PROBLEMA APERTO in fondo.]**
Zip agli atti: `R108_BB_M15_CORSA_20260825_2124.zip`. Criteri FIRMATI da
Claudio il 25/08 ("FIRMO CON PROPOSTE", D1-D6, verbale in `R108_CRITERI.md`)._

## ✅ IL BANCO E' SANO — G0 3/3 al centesimo

| Metro H1 (modello 1, come R103 — criteri D1) | Atteso | Misurato |
|---|---|---|
| GBPUSD | +5.415 / PF 1,199 / n 126 | **identico, prima op. inclusa** |
| EURUSD | +8.271 / PF 1,936 / n 59 | **identico** |
| AUDUSD | +5.365 / PF 1,541 / n 64 | **identico** |

L'EA e' stato ricompilato adesso, i gemelli sono identici, l'antenato R103 e'
verificato dal gate nuovo (checklist 72). Quello che segue e' il motore, non
il banco.

## 📊 LA RISPOSTA: **IL BREAKING BAND NON SCENDE A M15**

| Cella M15 (tick reali, 2022.07-2026.06) | INTERA | IS (2+2) | OOS (2+2) |
|---|---|---|---|
| GBPUSD | **−8.754 / PF 0,823 / n 227** | −1.351 / 0,935 | −7.511 / 0,743 |
| EURUSD | **−8.872 / PF 0,637 / n 87** | −4.104 / 0,712 | −4.973 / 0,533 |
| AUDUSD | **−3.131 / PF 0,865 / n 118** | −2.762 / 0,781 | −381 / 0,965 |

**Tre simboli, sei finestre su sei, tutte rosse.** Lo stesso identico motore
(unico input diverso: `InpTF` 16385→15) che a H1 e' VIVO con PF 1,20-1,94.

## ⚖️ I CANCELLI, APPLICATI A MANO

- **G2 (positivo in entrambe le finestre, PF OOS ≥ 1,10):** **0 su 3.**
- **G3 (coerenza cross-simbolo):** **COERENTE — ed e' quello che rende il NO
  definitivo per questa epoca**: non e' "un simbolo storto", e' il TF.
- **Emendamento A:** GBPUSD ha **n=227 sulla finestra intera → il merito e'
  MISURABILE A PIENO TITOLO, e dice NO** (PF 0,823). EURUSD (87) e AUDUSD
  (118) restano sotto i 150: merito formalmente sospeso, ma coerente col
  GBPUSD misurato — e il rischio (regola B) si legge: DD 7-14% a taglia 1%,
  peggior giornata max −2,03%, mai vicino al muro.
- **G5:** nessuna promozione, nessun tocco alle BB H1 vive. Ovvio, ma scritto.

## 🔍 LE DUE LETTURE FINI — quelle che valgono piu' del verdetto

1. **NON e' morto di COSTO: e' morto di SEGNALE.** Il cancello S0a era
   SUPERATO dove misurabile (GBPUSD take lordo 5,4× lo spread, AUDUSD 3,6×).
   Ma il rapporto take/perdita e' crollato scendendo di TF: a H1 il GBPUSD
   incassa 13 pip mediani contro perdite da 40 (e vince spesso); a M15
   incassa 6,65 contro perdite da 16,5 — la geometria della banda a M15
   raccoglie meta' e sbaglia uguale. Il paper del soffitto (arXiv 2605.04004)
   parlava del costo su M5; qui il costo passava, **e' l'edge che non c'e'**.
2. **LA FREQUENZA NON SCALA COL NUMERO DI BARRE.** Attesa dichiarata PRIMA
   (~155/finestra, [INFERITA]): misurato 107/120 su GBPUSD, 49/38 su EURUSD,
   61/57 su AUDUSD. Le barre sono 4× ma i trade ~2× (o meno): i pattern della
   banda a M15 si formano meno spesso di quanto il calendario prometta.
   **La riga della tesi "operativita' M5/M15" (`BREAKING_BAND_TESI.md`) e'
   ora MISURATA E FALSA su M15 per questi tre simboli** — la tesi va
   aggiornata con questo rimando.

## 🚨 PROBLEMA APERTO (1) e RILIEVI

- ~~**EURUSD M15: 2 deal non accoppiati**~~ → **CHIUSO il 26/08. Non era
  l'EA: era il PARSER del driver.** Stessa causa provata su R109
  (`R109_INDAGINE_DEAL_2026-08-26.md`, checklist 81): `$deal | Sort-Object Ora`
  (riga **652** di `RIGA_R108_BB_M15.ps1`) — **`Sort-Object` non e' stabile** e
  sui deal che condividono lo **stesso secondo** ne inverte l'ordine, facendo
  sembrare spaiata una sequenza perfetta.

  **La prova** (riparsing indipendente dei sei `.htm` in ordine nativo, che e'
  l'ordine di ticket — cronologico e senza pari):

  | cella | in | out | alternanza nativa | gruppi a pari secondo | anomalie referto |
  |---|---|---|---|---|---|
  | **EURUSD M15** | 87 | 87 | **PERFETTA** | **1** | **2** |
  | GBPUSD M15 | 227 | 227 | PERFETTA | 0 | 0 |
  | AUDUSD M15 | 118 | 118 | PERFETTA | 0 | 0 |
  | EURUSD metro H1 | 59 | 59 | PERFETTA | 0 | 0 |
  | GBPUSD metro H1 | 126 | 126 | PERFETTA | 0 | 0 |
  | AUDUSD metro H1 | 64 | 64 | PERFETTA | 0 | 0 |

  **L'unica cella con un gruppo a pari secondo e' l'unica cella segnalata**, e
  le altre cinque sono il controllo positivo a zero. Il gruppo e' uno solo:

  ```
  2025.10.27 15:15:01 | aff 148 | EURUSD | buy  | in  | vol 6.35 | px 1.16395 | R108 BB EURUSD CONT L
  2025.10.27 15:15:01 | aff 149 | EURUSD | sell | out | vol 6.35 | px 1.16404 | tp 1.16400
  ```
  (posizione aperta e chiusa in TP **entro lo stesso secondo** — legittimo su
  tick reali). Riprodotto il ciclo `Passo0` (righe 659-707) in Python: ordine
  nativo → **n=87, anomalie 0**; col gruppo invertito → **n=86, anomalie 2**,
  cioe' **esattamente** il numero del referto driver. In R108 il `Passo0` non
  ha il controllo sul volume che ha R109, quindi un gruppo invertito costa
  **sempre 2** anomalie: la firma "2 deal" = **un solo** gruppo, e torna.

  E il conteggio giusto e' quello dei CSV: **n=87**, come gia' scritto nella
  tabella qui sopra. **`MaxPositions=1` non e' mai stato violato.**

- **PASSO 0 di EURUSD M15, RECUPERATO** dal parse pulito (nessun tester speso,
  bastava l'`.htm` gia' in archivio). Era l'unico `n/d` del round:

  | | EURUSD M15 |
  |---|---|
  | n / vincenti / perdenti | 87 / 48 / 39 |
  | take netto **mediano** | **5,30 pip** (medio 7,29) |
  | take **lordo** mediano | 6,80 pip = **4,53x** lo spread → **S0a SUPERATO** |
  | perdita mediana | **9,50 pip** |
  | durata mediana | 5,43 barre M15 (media 13,68) |
  | peggior giornata | **−1,73%** il 2026.04.19 |

  **E rafforza la lettura 1 del round, invece di scalfirla**: anche EURUSD
  **passa il cancello del costo** (4,53x, come GBPUSD 5,4x e AUDUSD 3,6x) e
  muore lo stesso, con la stessa geometria storta — **incassa 5,3 e perde
  9,5**. Il terzo simbolo che mancava ora dice la stessa cosa: **non e' morto
  di costo, e' morto di segnale.** La peggior giornata rientra nel "max
  −2,03%" gia' dichiarato, che quindi non cambia.

  > Il **verdetto del round non si muove di un euro**: PF, DD e n vengono dai
  > CSV OPTFRAME, che non passano dal parser dei deal. Restava n/d una
  > *misura di contorno*, ed era n/d **per un difetto nostro**.
- **Riserva D2 su tutti i numeri a modello 4**: la profondita' tick di
  GBPUSD/EURUSD/AUDUSD non e' misurata in repo (unica misura esistente:
  U30USD). La riserva e' stampata dal driver su ogni simbolo. Nota: la
  riserva ammorbidirebbe un SI'; un NO su sei finestre coerenti non cambia.
- **Canarini n<150 per finestra** su tutte le celle M15 (vedi sopra).
- **Classe 76 avvistata in natura**: la frase di ripresa in fondo al referto
  driver contiene il testo dell'ultimo PROBLEMA al posto del comando (la
  variabile del foreach sopravvissuta al ciclo) — lo stesso difetto che il
  verificatore di R109 ha trovato e corretto nel driver R109 poche ore prima.
  Cosmetico, nessun numero toccato; se R108 dovesse mai rigirare, il fix e'
  gia' noto.

## 🧭 CONSEGUENZE PER LA CACCIA M5/M15 (la domanda della challenge)

- **La frequenza forex per la challenge NON verra' dal Breaking Band a M15.**
  La porta "abbasso il TF di un motore vivo" si e' chiusa sul primo e piu'
  economico candidato — ed e' costata **24 minuti di tester**, non giorni.
- I candidati M15 restanti hanno tutti take piu' grassi in rapporto al costo:
  **indici** (R109 ATR Exhaustion in rampa: take atteso 20-50 punti vs spread
  1-2) e **oro** (KA-Gold, in coda). Il verdetto R108 non li tocca: il collo
  era il segnale della banda, non il TF in se'.
- Il verdetto vale per **questa finestra (2022-2026) e questi tre simboli**;
  nessuna nuova griglia sul motore M15 (Seconda Caccia: quella e' pesca).
