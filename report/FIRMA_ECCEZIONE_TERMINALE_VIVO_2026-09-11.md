# ✍️ VERBALE DI FIRMA — l'eccezione sulla riga PostNews (11/09/2026)

> 🗣️ **Claudio: _"Firmo"_**, in risposta alla scelta fra **(1)** autorizzare la
> riga così com'è e **(2)** spostare la verifica sul terminale da backtest.
> **Registro l'opzione 1.** Se intendevi la 2, dimmelo e cambio in un minuto —
> ma la 2 ha un costo dichiarato: **non verificherebbe più le sedie vere**.

---

## 🔄 PRIMA DI TUTTO: CORREGGO IL MIO STESSO ALLARME

Ti avevo presentato il rischio così: *"se il giro si interrompe fra la riga 393
e il ripristino, nella cartella delle sedie vive resta un sorgente che non è il
suo"*. 🔴 **Vera come descrizione del codice, FALSA come descrizione del
rischio** — avevo letto il pezzo che scrive e **non quello che protegge**.

**Cosa ho trovato rileggendo, e cambia il quadro:**

| protezione | dov'è | cosa fa |
|---|---|---|
| 🛡️ **MT5 e MetaEditor devono essere CHIUSI** | r.689-690, **ricontrollato** a r.1020 | 👉 **le 40 sedie NON stanno girando** mentre lo script lavora |
| 🛡️ **Sentinella letta in PRE-VOLO** | r.693-716 | *"se un giro è stato interrotto fra l'installazione e il ripristino, **qui si rimette a posto PRIMA di tutto**"* |
| 🛡️ **Backup prima di ogni scrittura** | r.387-393 | la destinazione è salvata col timestamp |
| 🛡️ **La sentinella RESTA se il ripristino fallisce** | r.1163 | il guasto non si cancella: resta scritto |

📌 **E quel pre-volo è la CLASSE 116**: questo identico rischio era **già stato
pagato e già blindato**, mesi fa. Non l'avevo visto.

> ### 🎯 Il mio allarme ha trovato una cosa vera — *scrive e compila lì* — e l'ha descritta **peggio di com'è**. La macchina di sicurezza c'era già, ed è fatta bene.

---

## 📜 COSA COPRE QUESTA FIRMA — scritto stretto

✅ Alla riga `RIGA_POSTNEWS_ECBFOMC_VERIFICA`, sul terminale **50503392**
(`C:\Program Files\BCM Markets MT5 Terminal`), è permesso:

1. installare **temporaneamente** un sorgente nella cartella `Experts`, con
   backup e sentinella;
2. **compilarlo** con `metaeditor64`;
3. cancellare l'`.ex5` e il log **prodotti da sé**;
4. rimettere tutto com'era.

🔒 **E solo alle tre condizioni che lo script già impone**: MT5 e MetaEditor
**chiusi**, **pin di 40 esadecimali** obbligatorio, **sentinella** scritta prima
di toccare e riletta al giro successivo.

## 🚫 COSA **NON** COPRE

- ❌ **Nessuna altra riga.** Vale per **questa riga**, non per il terminale.
  Ogni altra che punti lì resta **BLOCCATA**.
- ❌ **Niente sul conto REALE 10105439**, niente sul **100k 50504263**.
- ❌ **Nessuna modifica a parametri, preset o sedie.** Lo script mette un
  sorgente e lo toglie: **non tocca configurazioni**.
- ❌ **Non copre il lasciare qualcosa dentro.** Se il ripristino fallisce, il
  giro **è un incidente**, non un esito.

## 🆕 LA CONDIZIONE CHE AGGIUNGO IO, perché costa zero

🔴 Il punto debole residuo non è l'interruzione — quella è coperta. È che **se il
ripristino fallisce, la sentinella resta lì e nessuno la guarda finché non gira
un altro giro**, che potrebbe non arrivare mai.

✅ **Rimedio**: il runner notturno controlla ogni notte se esiste una sentinella
`POSTNEWS_VER_IN_CORSO.txt` rimasta indietro, e la stampa nel referto.
👉 Da *"speriamo che il prossimo giro se ne accorga"* a **"lo sappiamo entro 24
ore"**. È la **lettura di un file**: dentro il perimetro di sola lettura già
firmato.

---

## 📋 STATO DELLA RIGA

🔴 **Resta BLOCCATA dal cancello deterministico, e va bene così.** Il cancello
non conosce le eccezioni, e **non deve conoscerle**: un cancello con una lista
di deroghe è un cancello che si aggira.

👉 **Questa riga esce con l'autorizzazione scritta qui, citata per nome** — non
allentando la regola.
