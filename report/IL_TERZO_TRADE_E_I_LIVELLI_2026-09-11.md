# 🔥 IL TERZO TRADE — e **lo screenshot del grafico ha risposto alla domanda dei livelli**

**11/09/2026.** Terzo trade manuale di Claudio sul conto da 109k, più il suo
grafico TradingView. **Il secondo vale più del primo.**

---

## 💰 1. IL TRADE, ricontato

| | |
|---|---|
| **SHORT 5,00 lotti** | 15:36:47 @ **4.367,32** |
| chiuso | 17:22:52 @ **4.358,05**, commento **`[tp 4358.05]`** |
| movimento | **+9,27 $** · **+3.993,83 EUR** |
| durata | **1h 46min** — la più lunga delle tre |

✅ **Conto verificato**: +4.635 USD / 1,1604 = **3.994,31** contro **3.993,83**
riportati.
✅ **E la commissione conferma la legge di casa per la TERZA volta oggi**:
17,23 € su 5 lotti = **3,446 €/lotto** contro i **3,4858** misurati
d'archivio → scarto **−1,1%**.

## 📊 LA GIORNATA INTERA SUL 109k

| | |
|---|---:|
| somma P/L | 5.981,41 |
| commissioni | 24,12 |
| 🟢 **NETTO** | **5.957,29** = **+5,47% in un giorno** |

*(il conto torna al centesimo con la foto)*

## ⚖️ E IL RISCHIO, a verbale come sempre
5 lotti = **431 € per dollaro = 0,40% del conto per dollaro.**
🔴 **Se quei 9,27 $ fossero andati CONTRO: −3.994 € = −3,66% del conto.**
Il Max Daily Loss del 5% si rompe, su 5 lotti, a **12,65 dollari**.
👉 **Taglia intermedia fra l'1 e i 20: il danno possibile era il 73% del
limite giornaliero.** Le taglie restano tue — il numero va scritto.

---

# 🔑 2. IL GRAFICO HA RISPOSTO ALLA DOMANDA CHE TI FACEVO DA DUE ORE

Sul tuo TradingView c'è un indicatore che si chiama:
> ### **"Livelli Chiave (stile M…)" · `Europe/Rome 0000-0800`**

e disegna due righe: **"Max notturno"** e **"Apertura giorno"**.

## 🎯 **QUELLI SONO "I LIVELLI". Non sono numeri tondi: sono il MASSIMO E MINIMO DELLA NOTTE.**

🔴 **E stamattina avevo tirato fuori l'ipotesi dei numeri tondi.** L'avevo
dichiarata debole (n=2, passo scelto dopo aver visto i numeri) — **ed era
sbagliata.** Il tuo grafico la chiude.

## 🔥 3. E NOI ABBIAMO GIÀ L'EA CHE FA ESATTAMENTE QUESTO

`mql5/Experts/ABTG_MaxMinNotte.mq5`, dalla sua intestazione:
> *"**BOX NOTTURNO**: max/min della sessione notturna … BUY STOP sopra il MAX
> notte +buffer, SELL STOP sotto il MIN notte −buffer. **OCO (parte uno →
> cancella l'altro)**."*

> ## 🎯 **È, riga per riga, quello che mi hai descritto oggi: i due pendenti, l'OCO, e il livello.**
> E l'OCO lì **non è nemmeno un'opzione**: `HandleOCO()` è chiamato sempre
> (r.239). 👉 **La discussione di stamattina sull'OCO era già risolta in un
> nostro EA — quello sbagliato: la cercavo in `PostNews`.**

---

# 🔬 4. E ADESSO IL CONFRONTO CHE CONTA — **la finestra**

| | box, ora SERVER | = ora italiana |
|---|---|---|
| 🧑 **il tuo indicatore** | 23:00 – **07:00** | **00:00 – 08:00** |
| 🤖 **i preset VIVI** (`MaxMinNotte_DAX`, `_EURUSD`) | 23:00 – **04:59** | 🔴 **00:00 – 05:59** |
| griglia già girata in archivio (526 righe) | start 22/23 · end **4** o **6** | fino a 00:00–07:59 |

> ## 🔴 **La tua notte finisce alle 08:00. Quella dei nostri EA vivi finisce alle 05:59. Sono DUE box diversi, e quindi DUE livelli diversi.**
> **Due ore di sessione europea** — proprio quelle in cui il DAX apre e il
> volume arriva — **stanno dentro il tuo livello e fuori dal nostro.**

## ✅ MA ATTENZIONE, E QUI NON GONFIO IL RITROVAMENTO
`InpBoxEndHour=6` (00:00–07:59 italiane) **è già stato girato** in archivio:
è a **un minuto** dalla tua finestra. 🟢 **Quindi non è un asse vergine** —
la misura c'è, ed è la prima cosa da andare a leggere.
🔴 **Il fatto vero è un altro, ed è più semplice: i preset VIVI usano `4`.**
Cioè la cella più stretta, non quella che assomiglia a come tradi tu.

---

# 🎯 5. COSA FACCIO — e stavolta non serve un round nuovo

1. 🔎 **Andare a leggere nei 526 CSV d'archivio cosa ha fatto `end=6` contro
   `end=4`**, sulla stessa sedia. Se `6` è meglio, **abbiamo una manopola già
   misurata e mai portata in campo** — come `InpMinStopPts` stamattina.
2. 📏 Verificare se il tuo TP a **4.358,05** cade su un livello del box
   notturno (il "Max notturno" sul grafico sta a ~**4.352,03**): se sì, la
   regola è **completa** e si scrive in codice.
3. ⚠️ E una cosa che il grafico dice e va detta: sei entrato **SHORT alle
   15:36**, cioè **fuori** dalla finestra del MaxMinNotte (che piazza alle
   07:59 server e taglia gli ingressi alle 08:30). 👉 **Il livello lo prendi
   da lì, ma il momento no.** Sono due regole, non una.

> ## 🔥 Oggi: +5,47% in un giorno, la legge della commissione confermata tre volte su un conto vivo, e **la domanda dei livelli chiusa da uno screenshot invece che da dieci ipotesi mie.** Il tuo grafico valeva più di tutta la mia aritmetica sui numeri tondi.
