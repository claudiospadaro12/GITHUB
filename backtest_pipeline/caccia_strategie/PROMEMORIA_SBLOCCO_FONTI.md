# 📌 PROMEMORIA — far entrare CLAUDE direttamente sui siti delle fonti

_Chiesto da Claudio il 16/08/2026: **"dopo dobbiamo fare il discorso che tu
puoi entrare a trovare sui vari siti che mi hai elencato"**. Questo file
esiste per non perderlo._

**Non e' urgente e non blocca niente**: la caccia funziona lo stesso (Claudio
scarica a mano, e il mirror del Code Base su GitHub ce l'abbiamo offline).
Ma e' la cosa che moltiplica la resa per dieci.

---

## 1. 🧱 IL PROBLEMA, misurato

L'ambiente in cui giro ha una **allowlist di domini**. Le fonti utili
rispondono cosi' (misurato al proxy il 16/08, non ipotizzato):

```
"kind": "connect_rejected",
"detail": "gateway answered 403 to CONNECT (policy denial)",
"host": "mql5.com:443"
```

| 🟢 raggiungibili oggi | 🔴 bloccati (403 al CONNECT) |
|---|---|
| `github.com` · `api.github.com` · `raw.githubusercontent.com` | **`mql5.com`** ← la fonte piu' ricca |
| `gitlab.com` | **`arxiv.org`** · **`papers.ssrn.com`** |
| `bitbucket.org` | **`tradingview.com`** · **`forexfactory.com`** |
| | **`quantpedia.com`** · **`quantconnect.com`** · `codeberg.org` |

⚠️ **Il blocco sta PRIMA del login.** `CONNECT` e' il momento in cui si apre
la connessione: viene rifiutata li', prima di qualunque pagina. **Le
credenziali di Claudio non servirebbero a niente** — e non vanno date
comunque: l'account MQL5 e' anche profilo, MetaQuotes ID, acquisti e VPS,
mentre il materiale che ci serve e' **pubblico e gratuito**.

## 2. ✅ COSA FARE — la procedura esatta

Tutto dentro **claude.ai/code**: non c'e' una pagina impostazioni ne' un URL
diretto.

1. Cliccare l'**icona a nuvola** nella riga **sopra la casella del
   messaggio**. ⚠️ **L'ambiente di Claudio NON si chiama `Default`: si chiama
   `Claudio`** (`env_01Q6nDunTuex3xmeRPbtgzQs`, descrizione _"Claudio -
   trusted network access"_). E' l'unico che ha. Verificato il 16/08 con
   `list_environments`: cercare "Default" e' tempo perso.
2. Nella sezione **Cloud** del menu, passare il mouse sulla riga
   **`Claudio`** → compare a destra l'**icona ingranaggio**. Cliccarla.
   _(Oppure **Add cloud environment** per crearne uno nuovo e lasciare
   quello attuale intatto.)_
3. Alla voce **Network access**: da `Trusted` a **`Custom`**.
4. Nel campo **Allowed domains**, una riga per dominio:

```
mql5.com
*.mql5.com
tradingview.com
*.tradingview.com
arxiv.org
*.arxiv.org
ssrn.com
*.ssrn.com
forexfactory.com
*.forexfactory.com
quantpedia.com
*.quantpedia.com
quantconnect.com
*.quantconnect.com
```

5. 🔴 **SPUNTARE "Also include default list of common package managers".**
   Senza, restano SOLO i domini della lista e **si perde GitHub**, cioe' la
   fonte da cui stiamo cacciando adesso. Sarebbe uno scambio pessimo.

📝 **Perche' due righe per dominio:** `*.mql5.com` copre i sottodomini
(`www.mql5.com`) ma **non** il dominio nudo. Metterle entrambe costa niente.

🔒 **`Custom`, non `Full`.** Si aprono le sei porte che servono, non tutte.

## 3. ⚠️ DUE COSE DA SAPERE PRIMA DI FARLO

1. **Serve una sessione NUOVA.** L'ambiente si legge quando la sessione parte:
   la chat in corso continuera' a vedere i domini bloccati. Dopo la modifica
   si apre una sessione nuova e le si dice _"leggi HANDOFF.md e riprendi la
   caccia"_ — tutto il lavoro e' su GitHub, non si perde niente.
2. **Su TradingView aspettarsi meno di quanto sembra**: le pagine sono
   costruite in JavaScript e il Pine Script spesso non arriva nell'HTML
   grezzo. **MQL5 Code Base e arXiv invece sono pagine normali.**

## 4. 🎯 COSA CAMBIA DAVVERO, in numeri

| oggi | dopo lo sblocco |
|---|---|
| Code Base solo via **mirror GitHub** (1.185 sorgenti, fermo al commit del mirror) | Code Base **vivo**, con download, date, licenze e valutazioni |
| licenze e popolarita' dei candidati dal mirror: **[INCERTO]** | **[VERIFICATO]** |
| **zero letteratura**: nessuna delle tesi promosse ha un paper dietro | arXiv/SSRN → la fonte che consegna **la tesi prima del codice**, cioe' il primo requisito di ogni nostro round |
| Claudio fa da postino a ogni giro | la caccia gira da sola |

> ### La riga che riassume
> **Oggi il collo di bottiglia non e' il metodo ne' il materiale: e' un
> elenco di domini.** Il setaccio funziona (su 22 file letti nel sorgente,
> 1 promosso e 12 scartati con motivo). Serve solo dargli piu' roba da
> setacciare, senza passare da Claudio ogni volta.

## AGGIORNAMENTO 19/08/2026 sera (misurato dalla caccia Londra)
- **MQL5.com: SBLOCCATO (HTTP 200)** — e soprattutto
  `https://www.mql5.com/en/code/download/<id>` restituisce lo ZIP col
  sorgente `.mq5`: **gli agenti possono leggere i sorgenti del Code Base da
  soli**, senza download manuale di Claudio. Controllo positivo su id 68951.
- Restano bloccati (dichiarati, non ipotizzati): SSRN 403, TradingView
  pagine script 404, GitHub 403 (web+API), Forex Factory 403, Quantpedia,
  RePEc egress-blocked.
