# 🔬 REFERTO ROUND 7 — ORB @NASUSD: il primo paziente del binario B

_Girato l'08/08/2026 sera, driver generico, tick reali, M5 (il TF live: l'EA usa
PERIOD_CURRENT), NASUSD, 2024.09.26 → 2026.06.30, taglio 40%.
File prova: `R7a_ORB_finestra_attuale.txt` + `R7b_ORB_finestra_apertura.txt`
(diagnosi, ipotesi e falsificazione scritte PRIMA dei numeri)._

## La diagnosi dal codice (prima dei numeri)

1. **Range = candela di PRE-mercato 14:25–14:30**: lo stop OPPRANGE sta sull'estremo
   opposto di una candelina di 5 minuti, dentro il rumore dell'apertura, con 10 punti
   di buffer sul Nasdaq.
2. **Difetto meccanico VERO, trovato e corretto**: `InpOneTradePerDay` dichiarato e
   mai letto — dopo lo stop il pendente opposto restava vivo 600' e riapriva al
   contrario (il "si gira e ristoppato" del 06/08 live). Fix nel sorgente (commit
   4dcf06f), attivo in questa misura; sul VPS arriva con la prossima ricompilazione.
   _Aggiornamento 08/08 sera: su richiesta di Claudio il file del corso `ABTG_ORB`
   e' stato RIPRISTINATO intatto; il fix (con cui r7/r8 sono stati misurati) vive
   ora in `ABTG_ORB_Ottimizzato` (magic 770611), il laboratorio parallelo._

## I numeri (tick reali, griglia 2 finestre × buffer 10/150 × lati)

**R7a — finestra pre-mercato (quella live):**

| buffer/lati | IS | OOS |
|---|---:|---:|
| 10 / short sì (LIVE) | **−1477,26** · PF 0,82 · DD 24,8% · 222 | +689,83 · PF 1,05 · DD 19,4% · 355 |
| 10 / solo long | −1596,56 | −498,96 |
| 150 / short sì | −382,38 | −320,43 |
| 150 / solo long | −151,46 | −668,65 |

**R7b — range formato DOPO l'apertura (14:30→15:05, la durata di DAX/Dow):**

| buffer/lati | IS | OOS |
|---|---:|---:|
| 10 / short sì | +191,94 · PF 1,06 | **−317,01** |
| 10 / solo long | −322,61 | **−276,10** |
| 150 / short sì | −16,87 | **−324,51** |
| 150 / solo long | +165,69 · PF 1,69 · **64 trade** | **−207,42** |

**Zero celle su 8 positive in entrambe le finestre.**

## Le tre cose che il round ha stabilito

1. **L'ipotesi geometria è FALSIFICATA dalla regola pre-scritta.** La condizione era
   «7b batte 7a in entrambe le finestre»: in IS sì (uniformemente), in OOS no. La
   geometria giusta ferma l'emorragia — DD da 20–25% a 2–10%, IS da −1477 a ±200 —
   ma non crea un edge. Curare la geometria rende l'ORB innocuo, non profittevole.
2. **Convergenza con una misura indipendente**: la FASE M aveva già bocciato il
   breakout sul Nasdaq (19 celle su 20 negative in OOS) e promosso il solo RETEST
   (+279/+219) — che è esattamente ciò che il `Nasdaq Apertura` live già fa, sullo
   stesso simbolo e nella stessa mezz'ora. Due strade, stessa conclusione: **sul
   Nasdaq il breakout non paga; l'ORB non ha un edge distinto da un EA già in flotta.**
3. **L'OHLC su M5 abbelliva di 3–4 volte** (FASE 0: IS −407 → tick −1477; OOS +2867 →
   +690): terza conferma della regola «sotto M15 lo screening OHLC è fuorviante».

## Verdetto (dal criterio pre-dichiarato in R7a)

> «Se TUTTE le 8 celle sono rosse in entrambe le finestre a tick reali, l'ORB non ha
> un edge distinto dal Nasdaq Apertura: **candidato allo spegnimento** (decisione di
> Claudio, non del backtest).»

La condizione si è verificata. Il rischio live corrente dell'ORB è la config peggiore
del lotto (IS −1477, DD 24,8%). Non c'è nessuna griglia da fare: il binario B su
questo motore si chiude con «capito perché fallisce: idea sbagliata per questo
mercato», che è un risultato — l'alternativa era continuare a pagarlo per scoprirlo.

**Nota di famiglia**: ORB_Fibo (stesso simbolo, FASE 0 anch'essa senza celle verdi,
stesso input `InpOneTradePerDay` mai letto) ha la stessa forma; al suo turno partirà
già con questo precedente sul tavolo.

## Dove sono i numeri

`backtest_pipeline/risultati_prove/ABTG_ORB/*_r7a.csv, *_r7b.csv` (8 finestre, coi
CSV della FASE 0 OHLC accanto per il confronto).
