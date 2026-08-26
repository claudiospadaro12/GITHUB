# 🛡️ ANALISI SOPRAVVIVENZA FASE FUNDED — "è più difficile passare o restare?" (26/08/2026)

_Verifica dell'ipotesi di Claudio del 26/08: **"è più difficile passare la
challenge che rimanerci"**. La casa sospettava la lettura ROVESCIATA (passare
è facile e veloce, SOPRAVVIVERE a lungo alla stessa taglia è il rischio vero).
Qui si MISURA, sui dati agli atti. SOLO ANALISI: nessuna riga, nessun criterio,
nessun EA toccato. Ogni scelta operativa che ne discende è una FIRMA di
Claudio, non un'ottimizzazione._

**Base dati**: identica ad `ANALISI_DIAL_TAGLIE_2026-08-26.md` (stesso pomeriggio):
`R105_dataset_giornaliero.csv`, finestra 2024.09.26 → 2026.06.30 (481 giorni),
flotta POST-REVISIONE "A+b" a **35 sedie vive** (spente F06/F09/F15/F21,
escluso F25) e **5 ridotte** (F04 ×0,65 · F05 ×0,25 · F07 ×0,30 · F08 ×0,50 ·
F16 ×0,50). Dial `d` = scala lineare di TUTTA la flotta. Base conto: 100k.
Muri stile prop come R106: **giornaliero −5%, totale −10%**.

---

## ✅ CONTROLLO POSITIVO — aggancio all'analisi del pomeriggio e a R105/R106

Stesse convenzioni, stessi numeri, prima di produrne di nuovi:

| numero agli atti | riprodotto qui | verdetto |
|---|---|---|
| R105: flotta 35 → **+274.745 €** | +274.745 € | ✅ |
| R105: DD **6,37%**, peggior giorno **−4,74% (25/05/26)** | 6.375 € = 6,37% su 100k; −4.737 € il 25/05/26 | ✅ |
| R106 A (+10%): **99,2%**, mediana **16 gg** | 99,2% (477/481), mediana 16 | ✅ |
| R106 B ×0,74: **98,3%**, mediana **22 gg**, worst −3,5 k€ | 98,3% (473/481), mediana 22, −3.505 € | ✅ |
| ANALISI DIAL: d=1,00 a target +8% → **pass 99,6%, mediana 12 gg** | 99,6% (479/481), mediana 12, 2 troncate | ✅ |

---

## ⚠️ AVVERTENZE MISURATE — da leggere PRIMA dei numeri

- **(a) Chiusure giornaliere = LIMITE INFERIORE del rischio, ovunque in questa
  pagina.** L'equity flottante intraday — quella che le prop guardano davvero —
  è invisibile al dataset. Ogni sopravvivenza qui sotto può solo PEGGIORARE nel
  reale, mai migliorare (onestà centrale di R106). E il peggior giorno chiuso a
  d=1,00 passa a **263 €** dal muro giornaliero: su chiusure.
- **(b) 481 giorni = UN SOLO regime, prevalentemente toro.** La sopravvivenza
  in un mercato ORSO non è misurata qui — rimando alla prova di regime
  (macchina R50-R56-R59, Emendamento C). Una flotta che in 21 mesi di toro non
  buca mai il −10% non ha dimostrato nulla su un 2020 o un 2022.
- **(c) Scaling lineare = approssimazione OTTIMISTA** (lezione R109: cap di
  volume, slippage che cresce con la taglia). Vale per profitti E per rischi.
- **(d) Le regole vere delle prop NON sono modellate**: payout ciclici, regole
  di consistenza, minimo giorni di trading, ricalcolo del muro dopo i prelievi,
  commissioni/fee della challenge. I "netti" qui sotto usano payout 80% e 90%
  come **[IPOTESI CONTRATTUALE, varia per prop]**.
- **(e) Variante TRAILING = approssimazione da chiusure.** R106 dichiara il
  trailing FTMO 1-step NON modellato; qui lo approssimo come DD di 10.000 €
  dal massimo di equity di CHIUSURA raggiunto nel periodo (high-water mark
  incluso il saldo iniziale). Il trailing vero delle prop (intraday, e in
  alcune il blocco del muro a breakeven dopo +buffer) resta NON modellato:
  la variante è dichiarata, non spacciata per la regola vera.

---

## 📊 TABELLA 1 — SOPRAVVIVENZA FUNDED per dial e orizzonte (rolling, tutti gli start)

Orizzonti 1/3/6/12 mesi = 21/63/126/252 giorni di borsa; start possibili:
461/419/356/230. Sopravvivere = mai un giorno chiuso ≤ −5% E mai DD totale
≥ 10.000 € (statico dal saldo iniziale del periodo; trailing = variante (e)).

| dial `d` | 1 mese | 3 mesi | 6 mesi | 12 mesi | 12 mesi TRAILING |
|---:|---:|---:|---:|---:|---:|
| 0,50 | 100% | 100% | 100% | **100%** (230/230) | 100% |
| 0,65 | 100% | 100% | 100% | **100%** | 100% |
| 0,74 | 100% | 100% | 100% | **100%** | 100% |
| 0,85 | 100% | 100% | 100% | **100%** | 100% |
| **1,00 (firmata)** | 100% | 100% | 100% | **100%** | **100%** |

**Perché tutto 100%, e perché NON è una garanzia.** Su chiusure, il peggior
giorno a d=1,00 è −4,74% (sotto il −5%) e il peggior DD trailing è 6.375 €
(sotto i 10.000): NESSUN muro viene toccato, statico o trailing — le due
varianti coincidono al centesimo proprio perché il DD massimo non arriva mai
in zona muro. Sono gli stessi due numeri del filo di rasoio: **263 € di
margine sul muro giornaliero** e un solo regime toro. Il 100% è il limite
superiore gentile, non il mondo.

### 🔦 Il supplemento che spiega tutto: DOVE si rompe la sopravvivenza (12 mesi)

| dial `d` | sopravvivenza 12m | come muore |
|---:|---:|---|
| 1,055 | 100% | (il worst day chiuso tocca −5,00% esatto: ultimo dial intero) |
| 1,10 | **87,8%** | 28/230 finestre bruciate dal muro GIORNALIERO |
| 1,15 | **87,8%** | idem (stesse finestre: quelle che contengono il 25/05/26) |
| 1,30 | **43,0%** | 131/230 bruciate (entrano in gioco altri giorni neri) |
| 1,50 | **0,0%** | 230/230: NESSUNA finestra annuale sopravvive |

👉 Il dirupo è lo STESSO dell'analisi dial (d≈1,055 sul giorno chiuso), ma in
funded morde molto più forte: a d=1,15 la challenge passa ancora il 96,7%
mentre la sopravvivenza annua è già all'87,8%; a d=1,30 → 96,7% contro
**43,0%**. Il muro trailing/totale invece si romperebbe solo a d≈1,57: **il
fronte funded è il muro GIORNALIERO**, come in challenge — ma con 21 volte
l'esposizione (sotto).

### ⏱️ La matematica dell'esposizione (il cuore dell'asimmetria)

Giorni chiusi oltre −3,5% a d=1,00: **2 su 481**. Attesi dentro una challenge
mediana (12 giorni): **0,05**. Attesi dentro un anno funded (252 giorni):
**1,05** — **21 volte tanto**. Il 25/05/26 (il giorno a 263 € dal muro) cade
nel 2,6% delle corse-challenge da 12 giorni, ma nel 12,2% delle finestre
annuali (e nel 100% degli anni che lo contengono per intero: l'anno solare
2026 vero l'avrebbe avuto DENTRO di sicuro). **La fase funded non è più
rischiosa per giorno: è più rischiosa perché di giorni ne contiene venti
volte tanti.** Ogni punto di margine dal muro vale 21 volte di più in funded
che in challenge.

## 💰 TABELLA 2 — Profitto mediano PER MESE di sopravvivenza (finestre 12 mesi)

Lordo = mediana del P&L delle 230 finestre annuali sopravvissute / 12.
Netto = lordo × payout **[IPOTESI CONTRATTUALE 80% / 90%, varia per prop]**.

| dial `d` | lordo/mese | netto 80%/mese | netto 90%/mese | mediana annua lorda (p10-p90) |
|---:|---:|---:|---:|---:|
| 0,50 | 6.062 € | 4.850 € | 5.456 € | 72,7 k€ (65,0-82,7) |
| 0,65 | 7.881 € | 6.305 € | 7.093 € | 94,6 k€ (84,5-107,6) |
| 0,74 | 8.972 € | 7.178 € | 8.075 € | 107,7 k€ (96,2-122,4) |
| 0,85 | 10.306 € | 8.245 € | 9.275 € | 123,7 k€ (110,5-140,6) |
| **1,00 (firmata)** | **12.125 €** | **9.700 €** | **10.913 €** | **145,5 k€** (130,0-165,5) |

(Aggancio di coerenza: il +13.083 €/mese dell'analisi dial è la MEDIA sui 21
mesi; qui è la MEDIANA delle finestre annuali rolling — tornano.)

## 🎛️ TABELLA 3 — LE DUE MANOPOLE: "passa a 1,00, poi scendi a d"

Fase 1 (uguale per tutte le righe): challenge a **d=1,00** → pass **99,6%**,
mediana **12 giorni** (analisi dial, riprodotta sopra). Fase 2: funded a `d`.
"Indice atteso annuo lordo" = pass% × sopravvivenza 12m × mediana annua
(indice di confronto, ottimista per (a)(b)(c)(d)).

| funded a `d` | sopravv. 12m | mediana annua lorda | indice atteso lordo | netto 80% [IPOTESI] | capello dal muro giornaliero |
|---:|---:|---:|---:|---:|---:|
| 0,50 | 100% | 72,7 k€ | 72,5 k€ | 58,0 k€ | 2,63 pt |
| 0,65 | 100% | 94,6 k€ | 94,2 k€ | 75,4 k€ | 1,92 pt |
| **0,74 (racc. R106)** | **100%** | **107,7 k€** | **107,2 k€** | **85,8 k€** | **1,49 pt** |
| 0,85 | 100% | 123,7 k€ | 123,2 k€ | 98,5 k€ | 0,97 pt |
| **1,00 = "resta a 1,00 sempre"** | 100% | 145,5 k€ | 144,9 k€ | 115,9 k€ | **0,26 pt (263 €)** |

**Lettura onesta della tabella.** Sulle chiusure misurate, "restare a 1,00"
domina in euro E pareggia in sopravvivenza (100% ovunque) — quindi la scelta
del dial funded NON si decide su questa tabella: si decide sul **capello dal
muro**, cioè sulla parte NON misurata (picchi intraday, regime orso), che in
funded pesa 21 volte una challenge. Scendere 1,00 → 0,74 costa il 26% del
lordo e compra **6 volte il margine** (263 € → 1.495 €) sull'unico muro che
nei dati si è mai avvicinato a mordere — e che a d=1,10 ammazza il 12% degli
anni, a 1,30 il 57%, a 1,50 tutti.

---

## ⚖️ IL VERDETTO SULL'IPOTESI DI CLAUDIO — risposta diretta

**"È più difficile passare la challenge che rimanerci"** — Claudio, 26/08.

1. **Sui numeri misurati, alla taglia firmata: SÌ, hai ragione — ma per un
   capello che non conta.** Pass challenge a d=1,00: **99,6%**. Sopravvivenza
   funded a 12 mesi, stessa taglia: **100,0%** (230/230, statico E trailing).
   Restare è risultato (marginalmente) più facile che passare — e pure quel
   99,6% non ha una sola morte vera dentro: le 2 non-passate sono TRONCATE
   dalla fine dei dati, non bruciate. La sopravvivenza a 12 mesi supera il
   pass-rate della challenge **a TUTTI i dial da 0,50 a 1,00**, già dal primo.
2. **Ma la casa non aveva torto sul MECCANISMO — solo, non scatta alla taglia
   firmata: scatta appena sopra.** Da d≈1,06 in su la classifica si ROVESCIA
   davvero: a 1,15 passi il 96,7% ma sopravvivi l'anno solo l'87,8%; a 1,30
   passi il 96,7% e sopravvivi il 43,0%. Il motivo è aritmetico: un anno
   funded contiene **21 volte** i giorni neri di una challenge da 12 giorni.
   **Passare è un centometro, restare è una maratona sullo stesso filo**: alla
   taglia firmata il filo regge (su chiusure, in un toro), un dial sopra no.
3. **Quindi la frase giusta per i contratti è: "passare e restare sono facili
   ALLO STESSO dial SOLO se il dial lascia margine dal muro giornaliero".**
   Il rischio vero della fase funded non è la media dei mesi: è UN giorno, il
   25/05/26, a 263 € dal muro, moltiplicato per l'esposizione di un anno —
   più tutto ciò che chiusure e regime toro non fanno vedere (avvertenze a-b).

## 🧭 RACCOMANDAZIONE DUE-DIAL (proposta, NON operativa: serve la FIRMA di Claudio)

- **Fase challenge: d=1,00** (la firmata). È il punto di massimo pass-rate
  misurato (99,6%, mediana 12 giorni): l'esposizione dura poco, il filo di
  rasoio si attraversa una volta sola e in fretta. Sopra 1,00 c'è il dirupo
  già refertato nell'analisi dial (NON alzare per "passare prima": compra
  1-4 giorni e vende pass-rate).
- **Fase funded: scendere a d=0,74** (la raccomandazione R106, confermata da
  quest'altra angolazione). Costa il 26% del lordo mediano (145,5 → 107,7 k€
  l'anno, ottimista), compra il margine 263 € → 1.495 € sul muro giornaliero
  — l'unico che i dati mostrano capace di uccidere — proprio nella fase in
  cui i giorni neri attesi sono 21 volte quelli della challenge. **d=0,85 è
  il compromesso intermedio** (0,97 pt di capello, 123,7 k€): meno margine di
  quanto R106 chiami "vero", più di quanto la firma attuale ne abbia.
- **Prima di qualunque firma**: prova di regime della flotta al dial scelto
  (avvertenza b — la sopravvivenza in orso qui NON è misurata) e lettura ad
  alta voce delle avvertenze (a)-(e). Le regole vere della prop scelta
  (trailing esatto, consistenza, payout) vanno lette sul contratto della
  prop, non su questa pagina.

_Riproducibilità: script in minuti dal dataset agli atti (filtro finestra,
revisione A+b, scala lineare, rolling su tutti gli start; muri −5% g / −10%
tot, statico e trailing da chiusure). Controllo positivo integrale in testa:
nessun numero pubblicato su base non riconciliata._
