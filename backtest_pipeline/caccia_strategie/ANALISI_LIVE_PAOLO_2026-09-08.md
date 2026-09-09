# 🎙️ LIVE DI PAOLO, 08/09/2026 — cosa c'è di nuovo e cosa avevamo già

Trascrizione di ~7.500 parole. **La strategia è quella del box notturno**, ed è
la stessa famiglia del nostro `ABTG_Nightly`. Ma **una differenza c'è, ed è
meccanica**, non di parametro.

---

## 🟢 QUELLO CHE AVEVAMO GIÀ, e combacia
`mql5/Experts/ABTG_Nightly.mq5`, dall'intestazione del file:
> *"Sfrutta il range della sessione asiatica (box notturno) con ordini LIMITE ai
> bordi (fade / mean-reversion) … esclusione cross con mercati attivi di notte
> (JPY/AUD/NZD)"*

E Paolo, testuale:
> *"Tutti gli AUD non si fanno … tutti gli NZD non si fanno … GBPJPY no. Perché
> gli strumenti europei e americani la notte sono chiusi, hanno meno volatilità,
> sono più costanti."*

👉 **Stesso motore, stesso filtro strumenti.** Il nostro EA nasce da questo corso
e la trascrizione lo conferma. Orari: il nostro box è **22:00-04:59 server**,
piazzamento **05:00**, cutoff **07:00** — e Paolo dice *"si chiude alle 7 di
mattina"* e *"stavo sperimentando se fare il box alle 22 invece che a
mezzanotte"*. **Noi le 22 le usiamo già.**

---

# 🆕 LA COSA NUOVA, ed è UNA: **il BOX PROIETTATO**

Paolo, testuale:
> *"Questo box grigio che compare a mezzanotte si chiama **box proiettato**.
> Perché la casella interna è data dalla **MEDIA DEI BOX PRECEDENTI**. Le due
> fasce esterne sono date dall'intera volatilità espressa in una direzione."*

E poi, alla domanda diretta di un allievo:
> *"— Quindi il box si forma prima e poi noi operiamo dopo?
> — **Prima si mette l'ordine e poi si deve formare il box.**"*

## 🎯 QUESTA È UNA STRATEGIA DIVERSA DALLA NOSTRA

| | `ABTG_Nightly` (nostro) | **box proiettato** (Paolo) |
|---|---|---|
| il box è… | il **massimo/minimo REALIZZATO** della notte | la **MEDIA degli N box precedenti**, proiettata |
| quando si ordina | **DOPO** la chiusura del box (05:00) | **PRIMA** che la notte cominci |
| che cosa si scommette | che il prezzo **rientri** dai bordi realizzati | che la notte **ripeta la volatilità media** e rimbalzi ai bordi attesi |
| take profit | verso il centro | **la METÀ del box** |

> ### 👉 Non è un parametro diverso dello stesso motore: **è una previsione al
> posto di una reazione.** Rientra nella regola della seconda caccia (19/08) come
> **meccanismo alternativo sulla stessa inefficienza**, che è esattamente ciò che
> quella regola AMMETTE.

---

## 🔴 E IL BUCO CHE HO TROVATO GUARDANDO I NOSTRI DATI

`ABTG_Nightly` è stato girato su: **AUDUSD · D30EUR · EURUSD · GBPUSD · U30USD ·
USDCHF · USDJPY · XAGUSD · XAUUSD**.

Incrociando con la lista di Paolo:
- 🚫 **AUDUSD e USDJPY sono ESCLUSI dalla strategia** (mercati aperti di notte);
- 🚫 **indici e oro non sono valute**, e su quelli l'EA faceva **zero trade** per
  il baco del filtro QB (già agli atti, `REGISTRO_TEST.md` r.444);
- ✅ il verdetto negativo regge su **EURUSD, GBPUSD, USDCHF** (~160 trade a testa),
  che sono tre coppie **ammesse** da Paolo;
- 🔴 **MA le coppie che Paolo nomina per prime — `EURCHF`, `EURCAD`, `GBPCAD`,
  `EURGBP` — NON SONO MAI STATE GIRATE.** Sono le più "lente" di notte, cioè
  proprio quelle su cui la strategia dovrebbe funzionare meglio.

> ### 🎯 Non è "rifare la griglia su un motore morto" (vietato dalla regola del
> 19/08): è **girare il motore sulla popolazione di strumenti per cui è stato
> scritto**, e che non abbiamo mai provato. Popolazione diversa, non griglia diversa.

---

## 📋 LE DUE AZIONI, in ordine di costo

### 1. 💚 **Un PASSO 0 di `ABTG_Nightly` su EURCHF / EURCAD / GBPCAD / EURGBP**
Costo: **una corsa per simbolo** sulla macchina che ora abbiamo. L'EA è **già
scritto e già compilato**. È la cosa più economica dell'intera coda.
⚠️ Attenzione dichiarata prima: sono coppie **a bassissima volatilità**, quindi
**il costo (spread) pesa di più** in proporzione. La frontiera di casa
`stop >= 40 x spread` va verificata **prima** di leggere qualunque PF.

### 2. 🔬 **Il box proiettato: una SPEC, non subito un EA**
Serve definire, e sono tutte cose che la trascrizione **non dice**:
- 🔴 **N**, quanti box precedenti fanno la media — Paolo dice *"per n giorni"* e
  **non dà il numero**. È il parametro che decide tutto;
- come si costruiscono le due fasce esterne (*"l'intera volatilità espressa in
  una direzione"* è una frase, non una formula);
- se il box parte a **mezzanotte** o alle **22:00** — e Paolo stesso dice che
  **lo sta ancora sperimentando** e che *"andrebbe testato"*.

👉 **Sono tre parametri liberi su una strategia mai misurata.** Con 22 giorni
alla challenge, **prima l'azione 1**, che costa una corsa e usa codice esistente.

---

## 🧊 E DUE COSE MINORI, agli atti
- **Mataf** come fonte dell'ADR (media dei movimenti notturni per valuta): utile
  come riferimento esterno, **non è un segnale**.
- **Pivot custom a multipli del 25%** del prezzo di apertura come livelli di
  confluenza. Paolo lo consiglia rispetto al Fibonacci. Non è la strategia:
  è un indicatore di contorno.

## 🚫 Nessuna bandiera rossa
Nessun recovery, nessuna griglia, nessuna martingala. **Ordini pendenti con stop,
chiusura a orario fisso.** È una strategia disciplinata.
