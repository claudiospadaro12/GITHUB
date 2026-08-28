# 📧 Terza mail a FTMO — Gap Trading in Evaluation, risposta diretta richiesta

_Contesto: due risposte scritte ricevute (Nicolas Novak il 27/08 — definizione
tecnica precisa ma senza dire se vale in Evaluation; Romeo Pagani il 28/08 —
risposta più vaga, formulazione diversa, la domanda sull'Evaluation ancora
elusa). Claudio ha scelto: non un provvedimento prudenziale nostro, ma
**insistere che rispondano alla domanda**._

## ➡️ Testo pronto da incollare (rispondi allo stesso thread)

```
Hi,

Thank you for the previous replies. I've now asked this specific question
twice, in two separate emails, and I still haven't received a direct answer
to it — so let me ask it a third time, as plainly as I can.

Your Terms & Conditions state explicitly that the restrictions on News
Trading, Overnight Positions, and Weekend Holding do NOT apply during the
Evaluation process (Challenge, Verification, Free Trial) — only once an
account is funded.

Gap Trading is listed separately as a forbidden practice, and its
definition (as you described it) does not carry that same qualification.

My question is a single yes/no:

  Does the Gap Trading restriction apply during the Evaluation phases
  (Challenge / Verification / Free Trial), or does it — like News Trading,
  Overnight Positions, and Weekend Holding — apply only once the account is
  funded?

Please answer this one question directly: "it applies during Evaluation"
or "it applies only once funded." I don't need anything else re-explained;
I just need to know which of the two it is before I start trading, so I
don't unknowingly break a rule that may not even apply yet.

Thank you,
Claudio Spadaro
```

## 🎯 Perché è scritta così

- **Non ripete la domanda com'era prima** (quella con i 3 punti, che ha preso
  una risposta che ne ha ignorati 2 su 3) — la **riduce a una sola domanda
  binaria**, per non lasciare spazio a una terza risposta genericamente vera
  ma ancora non risolutiva.
- **Dice apertamente che sono già due i giri senza risposta** — non è
  un'accusa, è un fatto, e serve a far capire all'operatore che una terza
  risposta vaga non chiuderebbe la pratica.
- **Non aggiunge nessuna nuova domanda** (niente "tenere vs aprire", niente
  "pausa breve vs chiusura ≥2h" — quei dettagli restano aperti ma **dopo**
  questo, non prima: la domanda che blocca tutto è questa, le altre sono
  raffinamento).

## 📌 Stato in `PIANO_PROVA_GENERALE_FTMO.md` (X16)

✅ **CHIUSO 28/08** — risposta arrivata da Romeo Pagani, netta:

> _"It is very simple. If your strategy is gap trading, it is also not allowed
> in the Evaluation. Please refer to my email above: news trading and holding
> over the weekend are allowed during the Evaluation; gap trading is different
> and was mentioned in my previous email."_

**Il gap trading è vietato ANCHE in Evaluation** — è l'unica delle pratiche
vietate che non ha l'eccezione Evaluation-vs-funded (news trading e weekend
holding invece SONO permessi in Evaluation, come già chiuso in X1).

### ➡️ Conseguenza pratica, non ancora verificata
Serve capire quali EA della flotta aprono posizioni (a) a ridosso di news ad
alto impatto senza filtro attivo (`InpUseNewsFilter` è spesso `false` di
default — vedi `VERIFICA_FEDELTA_GOLDENCROSS_PDF_2026-08-19.md` §2.7 G14), o
(b) nelle 2 ore prima di una chiusura di mercato di almeno 2 ore, senza un
cutoff. È lo stesso tipo di buco già segnalato in **X15** (concentrazione di
rischio) — attivo da SUBITO, non solo a conto finanziato. **Proposto a
Claudio, non ancora auditato.**
