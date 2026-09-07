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

## ❓ DA DOVE VENGONO — **NON MISURATO**, e non lo invento

Il campo `strategy` è **vuoto** e il magic è **0**. In MT5 il magic 0 vuol dire
"non piazzato da un EA con magic proprio". Le ipotesi possibili, **nessuna
verificata**:

1. **trading manuale** di Claudio sul demo;
2. **copy trading / segnale**: nell'area clienti BCM ci sono le voci *Social
   Trading* e *PAMM* (viste nello screenshot del 07/09). Un segnale copiato
   produce esattamente questo: nessun magic, nessun commento, molti simboli,
   concentrazione sull'oro;
3. un **EA senza magic** attaccato in passato.

🔴 **Non scelgo fra le tre.** Serve una domanda a Claudio o una lettura del
giornale del terminale, ed è la prima cosa da chiarire.

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

1. ❓ **Chiedere a Claudio da dove vengono le 661 operazioni.** È una domanda,
   non un lavoro.
2. 🔧 **Separare il magic 0 in `analizza_trades.py`**: non cancellarlo — va
   mostrato, ma **fuori dal totale della flotta**, come i `RESIDUI SU DISCO` del
   censimento. Un numero che mescola due cose non è un numero.
3. 🔁 **Rileggere le pagelle passate** sapendo questo: i netti giornalieri del
   piccolo che citano un totale di conto vanno riletti.
4. 🟢 **Il 100k non è toccato**: lì i tre magic sono tutti nostri.
