# ✅ PASSI OPERATIVI — in ordine, uno alla volta (08/08/2026, sera)

_Scaletta chiesta da Claudio («ANDIAMO IN ORDINE, PROCEDIAMO»). Ogni passo ha i valori
esatti: niente da ricordare a memoria. Spuntare e passare al successivo._

---

## PASSO 1 — ✅ FATTO (08/08 sera) — Live5m: fermare l'emorragia

I tre EA sono **misurati negativi a tick reali fuori campione** e girano live:

| grafico sul VPS | rischio | OOS | DD OOS |
|---|---:|---:|---:|
| DAX Live 5m | **2%** | **−2218,56** | **39,74%** |
| DAX Live5m v2 | 1% | −393,74 | 14,16% |
| Nasdaq Live 5m | 2% | −326,54 | 19,40% |

**Consiglio: spegnerli tutti e tre** (il DAX al 2% è il rischio singolo più grosso della
flotta). Come: sul grafico → tasto destro sull'EA → **Elenco Esperti → Rimuovi**, oppure
Proprietà → scheda Comune → togli la spunta ad "Consenti trading live".
Alternativa se non vuoi spegnerli: Proprietà → `InpRiskPercent` a **0,25** su tutti e
tre (continuano a produrre forward quasi gratis). La decisione è tua; la misura è quella.

**ESITO: Claudio li ha spenti tutti e 3 l'08/08 sera.** Eventuale ritorno dal binario B.

## PASSO 2 — ✅ FATTO (08/08 15:14, verificato da screenshot) — DAX OTT: trailing allineato

Il grafico `ABTG_DAX_Apertura_EU_Ottimizzato` su D30EUR gira ancora TRAIL FIXED su M1
(i parametri vivono sul grafico: la ricompilazione NON li ha toccati). La config
validata è PREVBAR su M5. Proprietà dell'EA →

- `InpTrailMode` = **1** (PREVBAR)
- `InpTrailTF`  = **5** (M5)

Tutto il resto invariato. (Niente ricompilazioni: solo F7 sul grafico → Proprietà.)

**ESITO: screenshot delle 15:14 dell'08/08 — PREVBAR + 5 Minutes impostati, soglia 0.0R,
rischio 1%, TP1 1R/50%, BE on. Confermato con OK.**

## PASSO 3 — ✅ FATTO (08/08 15:23, verificato da screenshot) — Nikkei allineato alla cella H2

Il forward del Nikkei (`ABTG_SupertrendReversal` su 225JPY) va allineato alla cella
di riferimento misurata nel round 5 (H2, altopiano H2–H4). Proprietà dell'EA →

- `InpStMult` = **3.5** (ora 3.0)

⚠️ Il grafico deve essere **H2**. Ricordo: finché non ricompili sul VPS l'EA gira col
lotto minimo (sizing vecchio) — va bene così per ora, prima misura poi codice.

**ESITO (più ricco del previsto): il confronto col CSV r5 ha trovato TRE disallineamenti,
non uno** — il "H2" della candidatura è il TF OPERATIVO INTERNO (`InpTF`), non il periodo
del grafico, e il grafico girava `InpTF=H4`, short spento e TP 2,5R contro i 2,0R della
misura. Corretti tutti e tre da Proprietà: `InpTF=2 Hours` · `InpStMult=3.5` ·
`InpAllowShort=true` · `InpTP_RR=2.0`. Ora il forward gira ESATTAMENTE la cella
misurata (OOS +1863,34 · PF 1,653 · DD 0,88%). Lotto minimo finché non si ricompila.**

## PASSO 4 — ✅ FATTO (08/08 15:34, verificato da screenshot) — Dow: ricetta DAX deployata

Round 6: 5 criteri su 5 (OOS +653,56 · PF 1,275 · DD 4,18% · 130 trade, altopiano).
Vale mezzo punto (finestra non vergine): il punto intero lo dà il forward — che parte
solo se deployi. Il grafico live U30USD gira ancora BREAKOUT 15/200 long+short.

Proprietà dell'EA `ABTG_Dow_Apertura_US` sul grafico live (M5) — **valori che cambiano**:

| parametro | vecchio (live) | NUOVO |
|---|---|---|
| `InpEntryMode` | BREAKOUT | **2 = RETEST** |
| `InpRangeMinutes` | 15 | **35** |
| `InpBufferPoints` | 200 | **1000** |
| `InpRetestOffsetPts` | — | **400** |
| `InpAllowShort` | 1 | **0 (SOLO LONG)** |
| `InpTrailMode` | (verifica) | **1 = PREVBAR** |
| `InpTrailTF` | (verifica) | **5 (M5)** |

E questi devono già essere così (verifica al volo): `InpRangeMode=0`, `InpAllowLong=1`,
`InpRiskPercent=1.0`, `InpTP1_R=1.0`, `InpTP1_ClosePct=50`, `InpBreakevenAtTP1=1`,
`InpUseTrailing=1`, `InpSessionHour=14`, `InpSessionMin=30` (ora server!),
`InpOneTradePerDay=1`. **Magic: lasciare quello del grafico live** (non 770202, che era
del tester).

**ESITO: Claudio ha deciso SI' e deployato alle 15:34.** Il live girava una config [DOW]
personalizzata (TP secco 1,5R senza parziale ne' BE) diversa da quella stimata: le
modifiche vere sono state 8 (range 35, RETEST, buffer 1000, offset 400, short OFF, TP
1R, parziale 50%, BE on); trailing gia' PREVBAR M5, magic gia' 770202. Un errore di
battitura (parziale 5.0 invece di 50.0) beccato allo screenshot di controllo e corretto
prima dell'OK. Da oggi il forward del Dow gira ESATTAMENTE la cella del round 6.

## PASSO 5 — 🧪 Round 4: GoldenCross cross-symbol (PC di backtest, 3 lanci)

Test di robustezza già pronto (`R4_GoldenCross_cross.txt`), MAI girato. Non promuove
nessuno per regola dichiarata: pesa la riga XAUUSD. Tre lanci, uno per simbolo, dalla
cartella del driver sul PC di backtest (una riga per volta):

```
powershell -ExecutionPolicy Bypass -File .\walkforward_generico.ps1 ABTG_GoldenCross_Ottimizzato -Prova prove\R4_GoldenCross_cross.txt -Simbolo D30EUR -Etichetta r4
powershell -ExecutionPolicy Bypass -File .\walkforward_generico.ps1 ABTG_GoldenCross_Ottimizzato -Prova prove\R4_GoldenCross_cross.txt -Simbolo U30USD -Etichetta r4
powershell -ExecutionPolicy Bypass -File .\walkforward_generico.ps1 ABTG_GoldenCross_Ottimizzato -Prova prove\R4_GoldenCross_cross.txt -Simbolo NASUSD -Etichetta r4
```

(Il TF viene dal file prova: H1, lo stesso del live. Poi zip dei CSV come al solito.)

---

## Dopo questi cinque

- Binario B, primo paziente: **ORB @NASUSD** (stop dentro il rumore d'apertura — la
  malattia curata sul DAX col RETEST).
- Binario D: OnTester per HARSI e SuperWave_EA.
- Famiglie non-aperture sul VPS: codice vecchio, si aggiornano con `aggiorna_ea.ps1`
  **+ RIAVVIO di MetaTrader** (la ricompilazione scarica gli EA dai grafici!).
- Weekend: la coda rifà la FASE 0 degli EA cambiati; sveglia automatica già attiva.
