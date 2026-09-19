# ⏱️ LA FREQUENZA DELLA ROSA — **nessuna famiglia raggiunge il pavimento**

**19/09/2026** · richiesta di Claudio, nata dal report settimanale: due sedie della rosa non
avevano operato in tutta la settimana.
Pavimento firmato il **07/09**: **1,00 operazione/giorno PER FAMIGLIA** (motore × simboli
schierabili), non per sedia.

---

## ① IL NUMERO, in due unità e su due finestre

Fonte: `data/statements/trades_auto.csv`, conteggio per `magic`, giorni **lavorativi** (lun-ven).
**Segnali** = aperture distinte al minuto — serve perché `SuperWave` apre **due gambe** per
segnale (1/3 a mercato + 2/3 pendente), e contarle come due operazioni raddoppia il numero.

| famiglia | pos | **segn** | ultima op | gg fermi | **op/gg** *(finestra attiva)* | **op/gg** *(fino a oggi)* |
|---|---:|---:|---|---:|---|---|
| **DAX_Apertura_EU** `770101` | 39 | 38 | 17/09 | 1 | pos **0,886** · seg **0,864** | pos 0,867 · seg **0,844** |
| **MaxMinNotte** `770402`+`770411` | 16 | 16 | 17/09 | 1 | pos **0,571** | pos **0,552** |
| **SuperWave** `770511` | 16 | **9** | **07/09** | **9** | pos 0,516 · seg **0,290** | pos 0,400 · seg **0,225** |
| Nasdaq_Apertura_US `770250` | 2 | 2 | 18/09 | 0 | 0,500 *(n=2, non misurabile)* | 0,500 |

> # 🔴 **NESSUNA FAMIGLIA RAGGIUNGE 1,00.** La migliore è il DAX a **0,86-0,89**, e le altre stanno fra **0,23 e 0,57**.

---

## ② 🔴 IL CASO CHE PESA DI PIÙ: **`SuperWave` fa 0,29, non 0,52**

Contata in **posizioni** dà 0,516. Ma le sue 16 posizioni sono **9 segnali**: il motore apre
1/3 a mercato + 2/3 in pendente **sullo stesso istante**.
👉 **In operazioni vere fa 0,290 sulla finestra attiva e 0,225 se si conta fino a oggi** — un
quarto del pavimento. **Ed è ferma da 9 giorni lavorativi.**

⚠️ **È lo stesso errore che Claudio mi ha corretto il 18/09** (*«è il SuperWave DOW L o S 1/2 o
2/3, VERIFICA»*) e che mi è rientrato dalla finestra nella colonna del rischio. Qui l'ho evitato
**prima** di scrivere il numero.

## ③ 🟢 E LA COSA CHE IL PAVIMENTO DEL 07/09 DICE, ed è la via d'uscita

La firma dice testualmente che la portata la fa **il numero di simboli**, non la velocità del
motore: *«un conto vero gira 3-5 EA su **26 simboli** e fa 0,29-0,47 op/giorno PER SIMBOLO»*.

👉 **Le nostre frequenze per simbolo (0,29-0,89) sono già DENTRO quella forbice, e il DAX la
supera.** Il problema non è che i motori siano lenti: **è che ogni famiglia gira su uno o due
simboli.**

| famiglia | simboli oggi | per arrivare a 1,00 servono |
|---|---:|---|
| DAX_Apertura_EU | **1** | **2** simboli *(0,886 × 2 = 1,77)* — e il motore ha già girato su `F40EUR` |
| MaxMinNotte | **2** | **4** *(0,286/simbolo → serve larghezza)* |
| SuperWave | **1** | **4** *(0,29/simbolo)* |

⚠️ **È un conto di proporzionalità, non una misura**: presuppone che il motore si comporti sugli
altri simboli come su questo — e **R83 ha misurato che non è vero** (*«la stessa regola cambia
segno fra mercati»*). 🔴 **Ogni simbolo nuovo va rimisurato, non ereditato.**

---

## ④ COSA VUOL DIRE PER IL 1° OTTOBRE

Da oggi al 1° ottobre ci sono **~8 giorni lavorativi**. Alle frequenze misurate, l'intera rosa
produce:

| famiglia | op/gg | **op attese entro il 1/10** |
|---|---:|---:|
| DAX | 0,844 | **~7** |
| MaxMinNotte | 0,552 | **~4** |
| SuperWave | 0,225 | **~2** |
| **totale rosa** | **1,62** | **~13** |

🔴 **Tredici operazioni**: non bastano a dare un contratto a nessuna sedia che oggi non ce l'ha,
e non bastano a portare `770260`/`770261` dai loro 94 e 108 ai 150 del pavimento.
🟢 **Ma la challenge non si vince col numero di operazioni: si vince col RISULTATO.** Il numero
che manca per dire *«bastano o no»* è la **taglia**, ed è firma di Claudio.

---

## ⑤ 🕳️ I LIMITI DI QUESTA MISURA, dichiarati
1. **Il denominatore.** Ho usato i **giorni lavorativi** fra la prima e l'ultima operazione. Se
   una sedia è stata spenta e riaccesa dentro quella finestra, la sua frequenza risulta **più
   bassa** del vero. 🔴 **Lo storico delle accensioni non l'ho incrociato**: [NON MISURATO].
2. **Le finestre sono corte**: 4 settimane per MaxMinNotte, 6 per SuperWave, 9 per il DAX. Una
   frequenza su 4 settimane non è una frequenza annuale.
3. **`770250`** ha n=2: lo 0,500 **non è un numero**, è un segnaposto.
4. **Non ho contato i giorni di festività di borsa**, solo i weekend: le frequenze vere sono
   leggermente **più alte** di quelle scritte qui.

---
*Fonti: `data/statements/trades_auto.csv` (aggregato per `magic`, aperture distinte al minuto per
i segnali) · `CLAUDE.md` §«PAVIMENTO DI FREQUENZA» per la firma del 07/09 ·
`report/PAGELLA_SETTIMANA_2026-09-19.md` per l'assenza di `770511` e `770411` dalla settimana.*
