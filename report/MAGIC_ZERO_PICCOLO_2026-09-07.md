# 🔴 IL CONTO PICCOLO NON È UN LABORATORIO PULITO

**661 operazioni su 1284 non appartengono a nessun EA nostro**, e valgono
**−18.706,94 €** contro i **−1.235,41 €** di tutta la flotta messa insieme.

Trovato la notte del 07/09/2026, misurando un'altra cosa.

---

## 📊 IL NUMERO

`data/statements/trades_auto.csv` — conto **DEMO piccolo 50503392**,
periodo **30/03/2026 → 07/09/2026**:

| blocco | trade | netto |
|---|---:|---:|
| **MAGIC 0** — nessun EA nostro | **661** | **−18.706,94 €** |
| sedie con magic (la flotta) | 623 | **−1.235,41 €** |

### Dove sta la perdita, per simbolo (solo blocco magic 0)
| simbolo | trade | netto |
|---|---:|---:|
| **XAUUSD** | **485** | **−17.066,92 €** |
| D30EUR | 40 | −510,24 |
| USDJPY | 5 | −196,84 |
| XAGUSD | 3 | −147,42 |
| _(altri 31 simboli)_ | 128 | ~−790 |

**Una singola operazione XAUUSD ha perso −7.287,15 € con lotto 3,00.**

---

## 🧨 PERCHÉ CONTA: le letture di quel conto sono CONTAMINATE

`backtest_pipeline/analizza_trades.py` **non filtra il magic 0**. Riga 131:

```python
perEA[r.get("strategy") or ("magic " + str(r.get("magic", "?")))].append(r)
```

Raggruppa per `strategy`, e quando manca ripiega su `"magic <n>"`. 👉 **Le 661
operazioni entrano nei totali** come se fossero una strategia qualsiasi.

Quindi il netto del piccolo che leggiamo ogni sera **non è il netto della
flotta**: è **flotta + qualcos'altro**, e quel qualcos'altro pesa **quindici
volte** la flotta.

> ### 👉 La flotta sul piccolo, dal 30/03 al 07/09, ha fatto **−1.235,41 €** su
> **623 operazioni**. Non −18.706. È un conto diverso.

---

## ✅ DA DOVE VENGONO — **RISPOSTA DI CLAUDIO, 07/09/2026 notte**

> _"Sul conto piccolo demo avevo iniziato a farlo manuale. Da quando vedi
> costanza nei commenti, vuol dire che siamo partiti solo con EA. **I trade
> senza commenti non li calcolare nel conto piccolo.**"_

Erano il **suo trading manuale**. Le tre ipotesi (manuale / copy trading /
EA senza magic) sono chiuse dalla prima. ❌ Il segnale copiato e il PAMM
**non c'entrano**.

### 📐 E il confine è MISURATO, non scelto

| controllo | risultato |
|---|---|
| `strategy` vuota **e** `magic` 0 | **661** operazioni |
| `strategy` vuota ma `magic` ≠ 0 | **0** |
| `strategy` piena ma `magic` 0 | **0** |
| **ultima** operazione senza commento | **27/07/2026** |
| dal **28/07/2026** in poi | **264 operazioni, TUTTE con commento** |

👉 "Senza commento" e "magic 0" sono lo **stesso identico insieme**: il
filtro non deve scegliere fra i due criteri, li pretende **entrambi** e
segnala se un giorno dovessero divergere. E la data del passaggio a solo-EA
non l'ho decisa io: **è dove i numeri smettono**.

### 📊 Il conto piccolo, letto come va letto

| periodo | flotta (con commento) | manuale (fuori dal conto) |
|---|---:|---:|
| 30/03 → 27/07 | 359 op · **−290,71 €** | 661 op · **−18.706,94 €** |
| **28/07 → 07/09** (solo EA) | 264 op · **−944,70 €** | **0 op · 0,00 €** |
| **totale flotta** | **623 op · −1.235,41 €** | — |

---

## 🔧 FATTO: il filtro è nel codice

`backtest_pipeline/analizza_trades.py`, patch del 07/09/2026:
- le operazioni senza commento **escono dal totale** della flotta;
- **non vengono cancellate**: compaiono in un blocco dichiarato
  *"🚫 Fuori dal totale — operazioni SENZA COMMENTO"*, con netto e simboli
  — stesso schema dei `RESIDUI SU DISCO` del censimento;
- si tolgono **prima** di scegliere la giornata, altrimenti un giorno di sole
  manuali (il 16/06: 55 operazioni, zero EA) diventerebbe "la giornata";
- ⚠️ **canarino**: se il blocco compare per una data **dal 28/07 in poi**, la
  pagella lo dice in chiaro — o il confine è cambiato, o qualcuno ha operato
  a mano;
- 🔴 se i due criteri dovessero **divergere** su una riga, quella riga
  **resta nel totale** e viene segnalata col suo `pid`: non la classifico da solo.

Il **100k è pulito** e verificato: 27 operazioni, cinque magic, **zero**
`strategy` vuote. La patch non lo tocca.

---

## ✅ E LA BUONA NOTIZIA, dalla stessa misura

Il sospetto che mi aveva fatto scavare era un altro: `LotByRisk` in **80 EA su
80** finisce con `MathMax(minLot, ...)`, che **alza il lotto al minimo** quando
il rischio ne chiederebbe meno — facendo salire il rischio vero sopra lo 0,65%
dichiarato, e potenzialmente sfondando il cap C1 = 3,25% firmato il 18/08.

**Misurato sul dry-run 100k (saldo 102.855):**

| sedia | peggior perdita | **% del saldo** |
|---|---:|---:|
| DAX Apertura 770101 | −647,82 | **0,63%** |
| ORB 770611 | −405,35 | **0,39%** |
| SupertrendReversal 770901 | −205,45 | **0,20%** |

> ### ✅ **Il rischio dichiarato REGGE.** 0,63% contro 0,65% promesso: il floor
> del lotto **non morde** a quella taglia di conto. Il timore era legittimo, la
> misura lo scioglie.

⚠️ Ma vale **per il 100k**. Su un conto **più piccolo** lo stesso floor
morderebbe di più, ed è esattamente la pre-condizione che l'agente ha messo
sulla sedia `NY RETEST` prima di accenderla in demo. Lì resta aperta.

---

## 📋 COSA FARE, in ordine

1. ✅ **FATTO** — chiesto a Claudio: erano il suo trading manuale (07/09 notte).
2. ✅ **FATTO** — magic 0 separato in `analizza_trades.py`, fuori dal totale
   ma mostrato. Un numero che mescola due cose non è un numero.
3. 🔁 **Rileggere le pagelle passate** sapendo questo: i netti giornalieri del
   piccolo che citano un totale di conto vanno riletti. ⚠️ **Non si
   rigenerano in blocco**: il blocco 100k di ogni pagella calcola il saldo
   **cumulato a oggi**, quindi rigenerare una giornata di giugno le
   scriverebbe dentro il saldo di settembre. Riguardano comunque solo le
   pagelle **fino al 27/07**; da lì in poi erano già pulite.
4. 🟢 **Il 100k non è toccato**: lì i tre magic sono tutti nostri.
