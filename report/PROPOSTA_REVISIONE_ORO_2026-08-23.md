# 🖊️ PROPOSTA DI REVISIONE — le 3 sedie oro della corsia RISCHIO (R100)

_Preparata il 23/08/2026 su richiesta di Claudio ("SI, PREPARAMI LA PROPOSTA
SEDIA PER SEDIA"). E' una PROPOSTA: ogni riga si applica solo con la sua
firma. Tutte le riscalature di taglia sono [APPROSSIMATO: lineari], come da
convenzione di CONTRATTI_SEDIE.md. I numeri sono LIMITI INFERIORI (OHLC)._

## Il metro comune (dichiarato prima)
- Muro prop totale: 10%. Muro giornaliero: 5%.
- La corsia RISCHIO decide la TAGLIA e l'eleggibilita' prop. Il MERITO
  (se la sedia si guadagna lo slot) resta giudicato dalla finestra
  recente e dal forward — qui non si tocca.

---

## S01 — EMA200_Ottimizzato (971501, H4, oggi 1,0%) — il caso peggiore
**Misurato:** DD 22 anni **45,91%** (promesso 4,40% → sforo 10,4x) ·
peggior giornata −1,91% · regime 2,8–5,3% · n=1894 (~86 op/anno).

| taglia | DD 22 anni atteso | peggior giornata |
|---:|---:|---:|
| 1,0% (oggi) | 45,9% | −1,9% |
| 0,5% | 23,0% | −1,0% |
| 0,25% | 11,5% | −0,5% |
| 0,2% | 9,2% | −0,4% |

**PROPOSTA:** 🔴 **prop: NON ELEGGIBILE a nessuna taglia sensata** (per
stare nel muro serve 1/5 della taglia, e a 0,2% il contributo e'
decorativo). **Demo: ridurre a 0,25%** e riscrivere il contratto con
**DD promesso 11,5%** — oppure, se il forward recente non giustifica lo
slot (censimento frequenza del 22/08 alla mano), **spegnere**. La scelta
fra le due e' di merito, non di rischio: la corsia rischio dice solo che
a 1% questa sedia e' fuori scala.

---

## S02 — MaxMinNotte (770402, H2, oggi 1,0%)
**Misurato:** DD 22 anni **19,72%** (promesso 5,30% → sforo 3,7x) ·
peggior giornata −1,07% · **regime TORO 2021: 9,37% in un anno solo** ·
LATERALE 8,24%. Curiosita' agli atti: 435 giorni fra il primo pendente
piazzato e il primo eseguito.

| taglia | DD 22 anni | TORO 2021 | peggior giornata |
|---:|---:|---:|---:|
| 1,0% (oggi) | 19,7% | 9,4% | −1,1% |
| 0,5% | 9,9% | 4,7% | −0,5% |

**PROPOSTA:** 🟠 **ridurre a 0,5%** e riscrivere il contratto con **DD
promesso 10,0%** (limite inferiore, 22 anni). Il dato che morde non e'
solo il lungo periodo: il TORO 2021 da solo fa 9,4% a 1% — un ANNO
storto a taglia piena mangia quasi tutto il muro. A 0,5% i numeri
rientrano ovunque. **Prop: eleggibile SOLO a 0,5% o meno.**

---

## S03 — PunteLarry (772343, H1, oggi 1,0%)
**Misurato:** DD 22 anni **29,74%** (promesso 3,50% → sforo 8,5x) ·
**peggior giornata −3,91%** (misura dal report; la seconda misura
indipendente OPTFRAME dice −2,20%: la verita' sta probabilmente in
mezzo, entrambe sotto il muro ma la prima ci va vicina) · regime 1,0–3,2%
· **n=213 in 22 anni = ~10 op/anno: frequenza bassissima** — il DD lungo
e' fatto di strisce perse su ANNI, non di un evento.

| taglia | DD 22 anni | peggior giornata (report) |
|---:|---:|---:|
| 1,0% (oggi) | 29,7% | −3,9% |
| 0,5% | 14,9% | −2,0% |
| 0,3% | 8,9% | −1,2% |

**PROPOSTA:** 🟠 **ridurre a 0,3%** e riscrivere il contratto con **DD
promesso 9,0%**. MA con la domanda di merito scritta accanto: a ~10
operazioni l'anno per 0,3% di rischio, questa sedia produce un contributo
minuscolo — se il tagliando dei 6 mesi (firma 18/08) non la giustifica,
**spegnere e liberare lo slot** e' la scelta piu' onesta. Prop: solo a
0,3% o meno, e solo se sopravvive al tagliando.

---

## Le tre righe da firmare (una per sedia — si puo' firmare in blocco o singolarmente)
```
[x] S01 EMA200_Ott:  demo 1,0% -> 0,25% + contratto DD 11,5% | prop: NO
[x] S02 MaxMinNotte: demo 1,0% -> 0,5%  + contratto DD 10,0% | prop: solo <= 0,5%
[x] S03 PunteLarry:  demo 1,0% -> 0,3%  + contratto DD 9,0%  | prop: solo <= 0,3%
```

## ✍️ FIRMATE TUTTE E TRE da Claudio il 23/08/2026, in chat:
"FIRMO TUTTE E TRE, S01 RIDUCI A 0,25%" — dopo aver visto i numeri del
forward reale (MaxMinNotte: 2 trade, netto -2,60; PunteLarry: 1 trade,
+144,89 — entrambe lontanissime dalle 20 operazioni del giudizio di
merito). Contratti riscritti in CONTRATTI_SEDIE.md con fonte R100.
La porta di rientro resta quella del tagliando: a 20+ operazioni col
merito misurato, la taglia si puo' rialzare con firma nuova.

## E le due note di flotta che escono da questa revisione
1. **La famiglia Supertrend e' la spina dorsale giusta dell'oro**: base
   2,18% e Ottimizzato 9,02% sui 22 anni — gli unici profili lunghi
   puliti. Se si ridistribuisce peso sull'oro, si ridistribuisce li'.
2. Ogni riduzione di taglia qui e' calcolata SEDIA PER SEDIA: il DD
   COMBINATO delle 12 sedie resta non misurato — **il round di
   portafoglio oro resta la prossima priorita'** della corsia rischio.

## Esecuzione (dopo la firma)
Le taglie si cambiano sul VPS nel pannello input delle sedie (InpRiskPercent),
fuori orario di operativita' di ciascuna; i contratti si riscrivono in
CONTRATTI_SEDIE.md con fonte R100. Preparo la checklist operativa esatta
(sedia per sedia, con orari sicuri) alla firma.

## ✅ ESEGUITA E VERIFICATA (23/08, 15:49)
Censimento dai .chr dopo il salvataggio del profilo
(`risultati_archivio/censimento_rischio_2026-08-23_1549.txt`):
- 971501 EMA200 OTT -> **0.25** ✅
- 770402 MAXMIN ORO -> **0.5** ✅
- 772343 LARRY ORO  -> **0.3** ✅
- 970901 STREV OTT  -> 1.0 ✅ (non toccata, giusto cosi')
Somma del rischio dichiarato della flotta: 43,00% -> **42,05%**.

⚠️ ANOMALIA APERTA nello stesso censimento: `ORB_Ottimizzato U30USD 770611`
compare **DUE volte a 1.0** piu' una a 0.3 (alle 15:46 era una sola a 1.0).
Possibile grafico ORB DUPLICATO comparso col salvataggio del profilo —
classe di rischio del 29/07 (stesso segnale eseguito due volte, -235,84).
DA VERIFICARE PRIMA DELL'APERTURA DI LUNEDI' (14:25 server).
