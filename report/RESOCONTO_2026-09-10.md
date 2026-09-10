# 📋 RESOCONTO DELLA GIORNATA — 10/09/2026

**21 giorni al 1° ottobre.** Punto sul PROGETTO (la pagella dei trade è un'altra
cosa, gira alle 23:00 e scrive `report/giornata_2026-09-10.md`: il netto del
giorno si legge lì, non qui).

---

## 🤖 COSA HA FATTO LA MACCHINA DA SOLA

**Runner del VPS, corsa delle 03:30** (`REFERTO_RUNNER_20260910_033002.txt`):
**10 righe di coda, tutte con cancelli G1/G2 passati, tutte uscita 0.** Perimetro
sola lettura rispettato.

🔴 **Ma due strumenti sono ROTTI, e uno è quello che serve di più:**
- **`CODA_08_preset_dai_chr`** → *"TOTALE SEDIE STAMPATE: 0"*. È lo strumento che
  dovrebbe leggere **cosa gira davvero sui grafici**. 👉 Conseguenza misurata
  oggi: **tutte** le geometrie del referto della flotta sono lette dal
  **sorgente e dai `.set`**, non dal grafico vivo. Se un `.chr` avesse altri
  valori, alcune misure cadono. **È il primo pezzo di ponteggio da riparare.**
- **`CODA_05_foto_fresca`** → gira e esce 0, ma non trova la cartella dei profili
  `.chr` su nessuno dei 6 terminali. Stessa famiglia.

**`SlippageLogger` sul conto REALE 10105439**: 🟢 **i deal ci sono** — 3 file,
`ABTG_SlippageLogger_10105439_deal.csv` con 4 righe, ultima scrittura
**08/09 14:35**. Primo dato utile: `D30EUR` `770101` ingresso eseguito a
25.983,80 contro 25.983,10 richiesto = **+0,70 punti indice** di slippage in
entrata. ⚠️ **n=1 per gruppo: è un indizio, non una statistica.** E dall'08/09 il
file non cresce.

**Caccia automatica**: nessun dossier nuovo pubblicato oggi dalla Routine ogni-2-giorni.

---

## 💶 IL CONTO

| | |
|---|---|
| **dry-run 100k** | **+2,85%** · 27 chiusure in 16 giornate · peggior giornata realizzata **−0,648%** — fonte `PIANO_CHALLENGE_OTTOBRE.md` r.311 |
| **mancano al target +10%** | **~7,15 punti percentuali** |
| **al ritmo attuale** | ≈1,8 mesi grezzo · **≈3,1 mesi normalizzato** (r.253) → 🔴 **il target NON arriva entro il 1° ottobre a questo ritmo** |
| **conto piccolo 50503392** | oggi la sedia `PostNews ECB EURJPY 771201` ha fatto la sua **prima operazione in assoluto**: **−80,90 EUR = 1,4905%** contro lo **0,65% promesso** nel contratto scritto la mattina stessa. Dettaglio in `report/POSTNEWS_ECB_ESITO_2026-09-10.md` |

---

## 🔬 COSA HO DECISO IO (in autonomia, col numero accanto)

1. 🔓 **Riaperto il ramo `OPPRANGE` dell'ORB**, che era archiviato. Motivo
   misurato: a parità di rischio (1%) e sugli **stessi 119 trade**, fa **DD
   3,84%** dove la geometria viva ne fa **9,76%** (12/12 celle sotto il cancello
   contro 12/12 sopra). Era stato bocciato da un `PF IS >= 1,10` misurato **1,063
   a n=71**, cioè sotto i 150 dove l'Emendamento A **sospende il merito**:
   **numero mancante, non numero brutto.**
2. 🔭 **Applicato alla FLOTTA INTERA il cancello del costo**, che R55 aveva
   dichiarato *"gratis"* il 15/08 e nessuno aveva mai incassato. Esito:
   **6 sedie vive sotto il pavimento 40x**, nessuna sotto il pavimento duro,
   **19 NON ANCORA MISURATE** (nessuna archiviata come morta).
3. 📏 **Trovato che lo stop non è più una stima per 21 sedie**: le gambe chiuse
   in stop di `trades_auto.csv` **sono** la distanza pagata. Per `770611`:
   **59,0 punti indice su 7 gambe vere** — e da lì il range implicito del Dow è
   **~118**, cioè **sopra** la banda che R125 aveva inferito (~94, banda 85-103).
4. 🐛 **Corretta un'attribuzione sbagliata che camminava da settimane**: quattro
   file davano a `770611` la finestra **14:25-14:30**, che è di `770601`. La
   radice era `PIANO_PROVA_GENERALE_FTMO.md` r.222, che citava come fonte il
   preset dell'altra sedia. Chiuso il campo: `770611` si riempie alle
   **14:45:13/14:45:31**, `770601` alle **14:30:00/14:30:51**.

---

## ❌ E DOVE HO SBAGLIATO IO, OGGI — perché il resoconto lo deve dire

Il cancello ha bocciato il mio lavoro **tre volte di fila**, e aveva ragione
tutte e tre. **Otto classi nuove nate dai MIEI difetti** (189-196), più cinque
dal referto della flotta (197-202) e tre dal terzo giro (203-205).

| difetto | cosa avevo scritto | cos'era |
|---|---|---|
| **189** | *"la cella è al centro dell'altopiano, non il picco — regola di casa"* | **era il picco**, su tutte e tre le metriche. Avevo invocato una regola **senza applicarla** |
| **191** | un contro-esempio dichiarato *"smentito"* | la prova portata era **irrilevante all'ipotesi**: con `lotto = R / stop`, la geometria viva porta **~2,2× il nozionale** |
| **192** | *"il round costa ~67 minuti"* | **~7**. Le 2,3 ore erano di **tutta la notte** |
| **193** | *"ho corretto il numero"* | avevo lasciato **tre figli** in giro, uno **tre righe sotto**, e uno **sorreggeva un argomento** |
| **196** | *"tre misure indipendenti"* | due leggono **la stessa riga di CSV**, e la terza **non è mai girata** |
| **203** | *"chiuso, verificato col grep"* | la correzione era arrivata ai `.md` e **non al file prova**, che è l'unico dei tre che **si esegue** |

🎯 **La lezione della giornata, e vale più delle undici classi**: *correggere è il
momento in cui si sbaglia di più*. Un numero corretto lascia figli sparsi, e i
più pericolosi sono quelli che **sorreggono un argomento** — perché il numero si
vede, l'argomento no.

🔴 **E la correzione che smonta il titolo che avevo dato alla giornata:**
su **U30USD il round R125 NON PUÒ fare il numero**. Verificato da me sul CSV:
`Trades` ha **un solo valore distinto su tutte e 48 le celle** (IS 71 / OOS 119).
L'asse del buffer muove lo stop, **non gli ingressi**. Quindi R125 può comprare
*"se l'altopiano esiste e a che costo"* — una **misura**, non una sedia.

---

## ⚠️ COSA ASPETTA CLAUDIO

Solo le cose che toccano il **conto reale 10105439**, i **parametri di rischio**
o **spendere soldi**. Tutto in `report/DA_FIRMARE.md`.

| # | cosa | perché è tua |
|---|---|---|
| **3-bis** | 🖱️ `ABTG_PostNews`: **default compilato 3.0 → metro di casa** | è la **taglia**, e serve una ricompilazione. Il `.set` giusto **non protegge da un `Resetta`**: finché il default è 3.0 ogni ricarica riarma il 4,6× in silenzio — ed è quello che è successo oggi |
| **14** | 📏 **quale albero compila il VPS**, `mql5/Experts/` o `standalone/`? | `standalone/ABTG_DAX_Apertura_EU.mq5:33` è ancora a **2.0** mentre la principale è a 1.0 dal 02/09. Se il VPS compilasse `standalone/`, l'EA del **conto reale** girerebbe al **doppio**. **Sola lettura, 30 secondi.** Aperta da tre censimenti, mai chiusa |
| **R125** | 🖊️ firma sui criteri **a numeri non visti** | 🔴 **NON ANCORA PRONTA DA FIRMARE**: il quarto giro di cancello non è tornato. Non te la mando finché non c'è un PASS |

🚫 **E quello che NON ti sto promettendo:** nessuna sedia nuova è pronta oggi.
Il ramo OPPRANGE è **riaperto**, non promosso: a n=119 il merito resta **sospeso**.

---

## 🎯 DOMANI

1. ⏳ Chiudere il **quarto giro di cancello** su R125 e, se è PASS, portarti la
   firma con scritto **esattamente cosa compra**.
2. 🔧 **Riparare `CODA_08`**: senza di lui non sappiamo cosa gira davvero sui
   grafici, e oggi quel buco ha reso condizionate diverse misure.
3. 📏 **Spread orario dei simboli mancanti**: `spread_flotta/` ha **3 file su 13
   simboli vivi**, e su quattro coppie forex legge **zero**. Con lo spread vero
   a 1,0 pip, **otto sedie che "passano" non passerebbero più**.
4. 🔓 Guardare le **manopole mai messe ad asse** trovate oggi, prima fra tutte
   `InpSLBufferAtr` di `SuperWave_DOW` (esiste, è a **0**, e la sedia sta al
   **96% del pavimento**: manca pochissimo).
