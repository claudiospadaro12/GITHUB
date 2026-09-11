# 🔓 COME ARRIVARE ALLE FONTI — cosa funziona e cosa no

**Nasce dalla caccia notturna del 12/09**, che su 11 bersagli di rete ne ha
trovati **4 irraggiungibili**. Questo file evita di riprovarli ogni volta.

---

## 🟢 CANALI CHE FUNZIONANO

### 🆕 La ricerca del Code Base MQL5 — **si aggira dal web** (scoperto 12/09)
🔴 **Il problema**: la ricerca interna di MQL5 (`/en/search#!keyword=`) è una
pagina **JavaScript**: torna solo il template, **zero risultati**. Per mesi
abbiamo potuto cercare nel Code Base **solo per navigazione**.

✅ **Il rimedio**: una ricerca web **ristretta al dominio `mql5.com`**.
👉 **È il primo modo che abbiamo per cercare il Code Base per PAROLA CHIAVE.**
📌 Prima resa: ha tirato fuori le schede **55064 · 55630 · 76951**, mai
setacciate prima — fra cui l'attrezzo del calendario nel tester.

### Altri canali verdi
- **download diretto dei sorgenti** dal Code Base (attenzione: diversi file
  sono in **UTF-16**, vanno convertiti prima di leggerli);
- **articoli MQL5** col codice nella pagina;
- **README** su GitHub via raw.

---

## 🔴 CANALI BLOCCATI — non riprovarli a ogni giro

| fonte | esito | quando |
|---|---|---|
| `github.com` interfaccia | **403** | 11-12/09 |
| `codeload.github.com` | **403** | 12/09 |
| `jsDelivr` | **000** | 12/09 |
| `raw.githubusercontent` su nome preso dal README | **404** | 12/09 |
| Quantpedia | **502** | 12/09 |
| SSRN · ForexFactory · earnforex | 403 / 403 / 000 | 11/09 |
| ForexFactory calendario | **403** (blocca i bot) | 11/09 |

⚠️ **E la distinzione che conta**: un **5xx** vuol dire *"non adesso"*, non
*"non esiste"*. Quantpedia va **riprovata**, non archiviata.

---

## 📏 LA REGOLA CHE VIENE DA QUI
🔴 **Se una fonte non si apre, il candidato è `NON VALUTABILE` — mai
"promettente".**
Il 12/09 un EA trovato su GitHub sembrava interessante dal README, ma il
sorgente **non è stato leggibile da nessuno dei quattro canali**. 👉 È stato
archiviato come **non valutabile**, non come candidato.
**Un titolo e uno screenshot di equity non sono una fonte.**
