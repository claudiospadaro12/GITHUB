# 📁 A2 — I PRESET DEL CONTO CHALLENGE: **cinque verificati, uno SCRITTO, e un buco nel cancello**

_Notte del 13/09. Azione **A2** del `PIANO_CHALLENGE_OTTOBRE_v2` — dichiarata li'
come **"Δ +1 sedia, ed e' il delta piu' economico del piano"**, perche' le taglie
vivono solo nei `.chr`._

---

## 1. 🟢 LA VERIFICA CHE NESSUNO AVEVA FATTO: i preset su file **corrispondono al campo?**

Un preset che NON corrisponde al campo e' **peggio di nessun preset**: da' la
sensazione di avere una rete e ne mette una diversa. Quindi l'ho misurato,
input per input, contro la foto dei profili del 12/09.

Conto **100k `50504263`** (cartella `... MT5 Terminal -V3`), **7 grafici**:

| sedia | magic | preset su file | esito |
|---|---|---|---|
| `ABTG_DAX_Apertura_EU` D30EUR | `770101` | ✅ | 🟢 **ogni input condiviso COINCIDE** |
| `ABTG_Dow_Apertura_US` U30USD | `770202` | ✅ | 🟢 **coincide** |
| `ABTG_MaxMinNotte_DAX_Short_Ott.` D30EUR | `770411` | ✅ | 🟢 **coincide** |
| `ABTG_SupertrendReversal` 225JPY | `770901` | ✅ | 🟢 **coincide** |
| `ABTG_ORB_Ottimizzato` U30USD | `770611` | ✅ | 🟢 **coincide** |
| `ABTG_TradeExporter` EURUSD | — | ❌ | ⚪ utilita' senza magic: non serve |
| 🔴 **`ABTG_Guardian` AUDNZD** | **`779001`** | ❌ **NESSUNO** | 🔴 **scritto stanotte** |

### 🧪 E il contro-esempio, perche' il mio primo conto diceva l'opposto
Il diff grezzo diceva **"DIVERGE"** su tutti e cinque: nel campo c'erano **31
input in piu'**. Invece di scriverlo, ho controllato **da dove vengono**:
```
InpMostraEma      EA DAX_Apertura: 0 occorrenze  ->  mql5/Indicators/ABTG_Look.mq5
InpBbPeriodo      EA DAX_Apertura: 0 occorrenze  ->  mql5/Indicators/ABTG_Look.mq5
InpMostraMaxIeri  EA DAX_Apertura: 0 occorrenze  ->  mql5/Indicators/ABTG_LivelliChiave.mq5
```
👉 Sono gli input degli **INDICATORI attaccati allo stesso grafico**: il `.chr`
contiene EA e indicatori insieme, e la ricostruzione li mischia. **Sugli input
che esistono in tutti e due, le differenze sono ZERO.**
📌 E' la stessa ambiguita' gia' dichiarata nell'intestazione del preset di
`771531` (`InpVerbose` che compariva due volte). Ora e' **misurata**, non supposta.

---

## 2. 🔴 IL BUCO VERO: **la rete di sicurezza del conto challenge non aveva un preset**

`ABTG_Guardian` magic **`779001`** — il Guardian che sorveglia **tutte** le sedie
del conto della challenge — viveva **solo dentro un `chart*.chr`**. Un click su
*"Ripristina"*, o un riattacco, e i quattro numeri firmati da Claudio il 18/08
sparivano **senza un errore a video**.

✅ Scritto: `mql5/Presets/ABTG_Guardian_50504263_779001_VIVO.set` — **16 input,
tutti COPIATI dalla foto**, nessuno scelto da me.

### 📏 E la foto misura **esattamente cosa manca al binario in campo**
| | |
|---|---:|
| input dichiarati in `ABTG_Guardian.mq5` a HEAD | **19** |
| presenti sul grafico vivo | **16** |
| **mancanti** | **3** |

E i tre mancanti sono **esattamente questi**:
```
InpDailyBaseline
InpMaxClusterRiskPct     <-- il tetto per CLUSTER (C2)
InpClusterMappa          <-- la mappa dei cluster
```
👉 **Il binario attaccato non ha nemmeno la manopola del C2**: non e' spenta,
e' **assente dal compilato**. Conferma **indipendente** (fonte diversa, metodo
diverso) della misura del 12/09.

⚠️ **Discrepanza dichiarata, e non la appiano**: il referto del 12/09 contava
*"15 input contro 19"*, questa foto ne conta **16**. I due conti **non tornano al
numero**. Concordano sulla cosa che decide (**le tre manopole del cluster non ci
sono**), divergono su quante ne restano. 👉 Chi rilegge: il numero di cui fidarsi
si ricava **rileggendo il binario**, non da nessuno dei due riassunti.

🟢 **E quello che e' VIVO E ACCESO**: `InpMaxOpenRiskPct=3.25` — il **cap C1**
firmato il 18/08 — piu' pausa B1 a **4,0**, emergenze a **4,9** e **9,9**, reset
alle **23**. Quattro firme di Claudio, tutte in campo.
📌 E il C2 **non serve adesso**: e' gia' provato in quattro modi che il cluster
`AZIONARIO` a 3,5% e' **piu' largo** del C1 a 3,25% gia' acceso. Diventa una rete
**alla quarta sedia** sullo stesso cluster.

---

## 3. 🔧 E UN BUCO NEL CANCELLO, trovato per sbaglio — **nessun `.set` passa da un cancello deterministico**

Ho lanciato `controlla_riga.py --oggetto prova` sul preset nuovo: **4 bloccanti**,
tutti per aver nominato i terminali e i conti.
🔴 **Ma poi l'ho lanciato sul preset `770202` GIA' IN REPO E ACCETTATO: ne fa 11.**

👉 Non e' il mio file a essere sbagliato: **`--oggetto prova` e' l'oggetto
sbagliato per un `.set`**. La regola `[TERMINALE]`/`[CONTO]` esiste per gli script
che **agiscono**; un preset e' **dati**, e la sua intestazione **DEVE** nominare il
conto — lo impone la regola dei terminali multipli del 06/09.

🔴 **Conseguenza da mettere agli atti**: `controlla_riga.py` ha gli oggetti
`riga`, `ps1`, `prova`, `md`. **Nessuno e' un `.set`.** Quindi oggi **i preset
non passano da nessun cancello deterministico** — e un preset e' esattamente la
cosa che, caricata sul terminale sbagliato, cambia la taglia di una sedia viva.
**Non lo risolvo stanotte** (toccare il cancello e' lavoro da fare svegli e da far
verificare): lo dichiaro, e sta qui.

---

## 4. 🧭 LA BUSSOLA, onesta

Questa e' **manutenzione, non una sedia nuova**. Il delta reale:
- 🟢 **cinque preset passano da "scritti" a "VERIFICATI contro il campo"** — prima
  nessuno l'aveva controllato, e un preset sbagliato e' una rete finta;
- 🟢 **la rete di sicurezza del conto challenge adesso esiste su file**;
- 🟢 **una conferma indipendente** che il C2 non e' in campo;
- 🔴 **un buco nel cancello, dichiarato.**

**Nessun parametro toccato. Nessun forward toccato. Nessuna taglia decisa.**
Il file e' una **fotografia**, non una proposta.
