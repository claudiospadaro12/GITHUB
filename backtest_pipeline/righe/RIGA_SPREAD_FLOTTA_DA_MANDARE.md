# 💸 SPREAD ORARIO FLOTTA — NASUSD · U30USD · D30EUR — DA MANDARE

**Che cos'è.** Una **MISURA**, non un test. Mette finalmente in campo il logger
dello spread di casa (promosso il **23/08, mai lanciato**) ed è la **v2**: legge
i **tick reali già sul disco** dei **tre indici della flotta** e produce, per
ognuno, la **tabella dello spread ORA PER ORA** (ora SERVER BCM):

1. 🚦 **LA RIGA CHE DECIDE — BID/ASK** (per simbolo). Se ci sono **molti tick
   solo-bid** (soglia ≥5%), ogni corsa a `Spread=0` su quel simbolo è
   **OTTIMISTA** e va rifatta imponendo `Spread = P95` misurato.
2. 📊 **SPREAD PER FASCIA ORARIA**: per ogni ora 0–23 (ora SERVER) →
   **media, MEDIANA, P95, max** in **PUNTI INDICE** (1 pto indice = 100 pti
   MT5, conversione **misurata su tutti e tre** i simboli).

**Perché adesso.** Direzione di Claudio (31/08 sera): _"dobbiamo usare simboli
col minimo attrito"_. Oggi **tutti** i prova usano `spread 2.0 [NON MISURATO]`.
Dopo questa corsa il 2.0 diventa un numero vero, per simbolo e per ora.

**Periodo di raccolta (dichiarato):** la finestra dei tick storici
`2024.09.26 → 2026.06.30` (~21 mesi, centinaia di giorni di mercato). **NON è**
una raccolta live di 3–5 giorni: è più larga, e **non tocca né VPS né mercato
aperto** — per questo la misura finisce in una corsa sola invece di durare
giorni.

**Non tocca il forward. Non promuove niente. Non ottimizza niente. Non committa.**

---

## 🛑🛑🛑 SI LANCIA **SOLO SUL PC DI BACKTEST — MAI SUL VPS** 🛑🛑🛑

> Questa riga **APRE e CHIUDE MT5 da sola** (StartUp Script via `.ini`,
> `AllowLiveTrading=false`). Sul **VPS** chiuderebbe il terminale che tiene su
> la **FLOTTA IN FORWARD**: **spegneresti gli EA veri.** Se trova MT5 **già
> APERTO**, **ESCE 1 e lo dice** (non lo ammazza) — a meno di `-ChiudiMT5`
> esplicito. **Sul PC di backtest, con MT5 CHIUSO, fuori dalle ore dei
> backtest.**

---

## ▶️ LA CORSA (blocco intero, un comando solo)

`<PIN>` = l'hash del commit che contiene QUESTO pacchetto. Il blocco cancella
ogni copia vecchia, riscarica la riga **dal pin**, verifica il **marcatore**
`MARCATORE_RIGA_SPREAD_FLOTTA_v2`; poi la riga scarica **anche il motore**
`ABTG_SpreadOrario.mq5` dal pin (marcatore `SPREAD ORARIO MULTI-SIMBOLO v2`),
lo **compila**, e cicla i tre simboli **in un solo MT5, su un solo grafico**
(il motore usa `SymbolSelect` + `CopyTicksRange`: niente grafici multipli).

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_SPREAD_FLOTTA.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SPREAD_FLOTTA.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SPREAD_FLOTTA_v2' -Quiet)){ throw 'SCRIPT VECCHIO: il file scaricato non ha il marcatore SPREAD_FLOTTA_v2.' };
    $global:LASTEXITCODE=0; & $p -Pin $pin; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: NON COMPLETO - leggi RIGA_REFERTO_SPREAD_FLOTTA.txt sul Desktop' } }
```

> Tre simboli per ~150M tick l'uno possono richiedere **ore**: è NORMALE,
> il timeout è **420 min**. La corsa è **RIPRENDIBILE** (vedi sotto): se muore
> a metà non si butta niente.

## 🔁 RIPRESA (pattern DUKA — il parziale non si butta)

- Il referto `REFERTO_SPREAD_FLOTTA.txt` viene **scritto e flushato SIMBOLO PER
  SIMBOLO**: è leggibile **in ogni momento**, anche a metà corsa (sta in
  `MQL5\Files` finché la riga non lo raccoglie).
- Ogni simbolo scrive **il suo CSV appena finisce**.
- Se la corsa esce **2 (PARZIALE)**, la console e il referto della riga stampano
  **i simboli mancanti** e la riga di ripresa già pronta, ad esempio:

```powershell
& $p -Pin $pin -Simboli "U30USD,D30EUR"
```

(ogni corsa fa la sua cartella `SPREAD_FLOTTA_<data>` sul Desktop: i CSV già
fatti della corsa prima **restano lì**, non vengono toccati).

---

## 📤 Cosa arriva sul Desktop

- Cartella `SPREAD_FLOTTA_<data>` con:
  - **`spread_orario_NASUSD.csv`**, **`spread_orario_U30USD.csv`**,
    **`spread_orario_D30EUR.csv`** — 24 righe orarie + riga `TUTTO`; colonne:
    `ora_server, tick_totali, tick_ask_usabili, tick_solo_bid, media_idx,
    mediana_idx, p95_idx, max_idx, overflow_tick`.
  - **`REFERTO_SPREAD_FLOTTA.txt`** — per ogni simbolo: la riga BID/ASK
    (quella che decide) + la tabella oraria impaginata.
  - **`RIGA_REFERTO_SPREAD_FLOTTA.txt`** — `data:` / `modo:` / esito / simboli
    fatti e mancanti (con la riga di ripresa).
  - gli ultimi log di MT5 (solo in cartella).
- Zip **leggero** `SPREAD_FLOTTA_<data>.zip` (solo csv + txt, senza log).

## 📖 COME SI LEGGE (i criteri, congelati dal 23/08 — qui solo estesi all'ora)

1. 🚦 **Prima la riga BID/ASK di ogni simbolo.** `% SOLO-BID ≥ 5%` → su quel
   simbolo **ogni corsa a `Spread=0` è OTTIMISTA**: si rifà imponendo
   `Spread = P95` misurato. (Su NASUSD la v1 ha già misurato **0.000%
   solo-bid**: atteso lo stesso sugli altri due, ma si misura, non si assume.)
2. 🕐 **Poi la tabella oraria, alle ORE DEL MOTORE** — non la media di giornata:
   - **NASUSD / U30USD** → ore **14–20** server (cash USA, apertura 14:30);
   - **D30EUR** → ore **8–16** server (cash DAX, apertura 08:00).
   Lo spread fuori seduta è più largo ed è **un altro mercato**: un motore
   notturno si giudica sulle ore notturne, uno di apertura sull'ora di apertura.
3. 💰 **Il confronto col metro C2 (cancello del costo):** il **TAKE LORDO
   MEDIANO** del motore deve essere **≥ 3× lo spread MEDIANO dell'ora in cui
   il motore lavora**. E la regola di lettura resta quella di casa: **fra
   2,5× e 3,5× il verdetto NON si dà** — zona grigia, si dichiara.
4. ⚖️ **"Minimo attrito" fra simboli:** a parità di motore, si confronta
   `mediana_idx` dell'ora di lavoro **divisa per l'ATR** (o per il take tipico)
   del simbolo — lo spread assoluto da solo non basta: 2 punti su un indice che
   si muove 40 non è come 2 punti su uno che si muove 15.
5. ⚠️ **Caveat dichiarati:** broker singolo (BCM); spread dai **tick del
   broker**, non spread di esecuzione live; **niente slippage** qui dentro;
   una sola finestra storica (21 mesi).

## 🔢 Codici d'uscita

- `0` → **misura COMPLETA**: riga di chiusura vista, TUTTI i CSV freschi,
  referto fresco.
- `2` → **PARZIALE / RIPRENDIBILE**: manca qualcosa; i simboli mancanti e la
  riga di ripresa sono stampati in console e nel referto della riga.
- `1` → fermato prima: **pin non valido**, terminale/compilazione, o **MT5 già
  APERTO** (rete che protegge il forward).

## ⚠️ CORREZIONI DEL 31/08 (dal FAIL del verificatore — v2 corretta, stesso marcatore, PIN NUOVO)
- Lo script ora RITENTA i blocchi di tick (i simboli appena selezionati
  rispondono -1 al primo accesso) e dichiara `blocchi persi:` nel referto —
  DEVE essere 0 per ogni simbolo, insieme a `tick letti` (decine/centinaia
  di milioni) e `point=0.01000`.
- Il cancello di compilazione cancella l'.ex5 prima e aspetta l'artefatto
  (MetaEditor DEVE essere CHIUSO prima di lanciare, oltre a MT5).
- La riga di RIPRESA e' ora SELF-CONTAINED (la vecchia usava variabili di un
  blocco morto): usare SOLO la STRINGA 3 consegnata in chat, coi simboli che
  il referto dichiara mancanti.
- Un CSV "fresco" ma vuoto NON esce piu' 0: si pretende tick_totali > 0.
- A FINE CORSA MT5 viene CHIUSO e resta chiuso: il PC torna pronto per i
  tester. NON lanciare questa riga mentre gira un backtest.
- Conversione 100 MISURATA su tutti e tre: NASUSD (R97 + v1 30/08),
  U30USD (R55/R97), D30EUR (Breakin 31/08).
