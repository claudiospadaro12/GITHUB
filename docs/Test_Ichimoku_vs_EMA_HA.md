# 🧪 TEST: Ichimoku-filtro+regime  VS  EMA9/21+Heikin Ashi

> Obiettivo: rispondere con **i numeri** (non a sensazione) alla domanda
> "meglio Ichimoku come filtro o EMA9/21 + Heikin Ashi?". Regola: chi vince
> non è chi *sembra* più bello, ma chi ha metriche **stabili** dentro e fuori
> campione. Un backtest bello in un periodo e brutto in un altro = **non ha edge**.

---

## PARTE 1 — Backtest oggettivo (file `Confronto_Ichimoku_vs_EMA_HA.pine`)

### Setup
1. Grafico **XAUUSD**, timeframe **M15** (o quello che usi per entrare).
2. Range dati su **Tutto/ESTESO** (non limitare dal pannello).
3. Aggiungi la strategia. In alto trovi **"MODALITA' DA TESTARE"**.

### Come si esegue (sempre a coppie sullo STESSO periodo)
Per ogni periodo, gira DUE volte cambiando solo la Modalità:

| | Modalità A | Modalità B |
|---|---|---|
| **Periodo 1 (in-sample)** — es. gen–giu 2026 | PF = ___ / Trade = ___ | PF = ___ / Trade = ___ |
| **Periodo 2 (out-of-sample)** — es. lug–dic 2026 | PF = ___ / Trade = ___ | PF = ___ / Trade = ___ |

Per tagliare il periodo: accendi **"Limita periodo"** e imposta le date.
Leggi **Profit Factor** e **# trade** dalla scheda **Strategia** (o dall'etichetta blu sul grafico).

### Come si legge (onesto, no auto-inganno)
- **Profit Factor (PF):** > 1 guadagna, < 1 perde. Ma non basta 1.05.
- **Il test vero è la STABILITÀ:** una modalità è migliore solo se il PF
  regge **in entrambi** i periodi. PF 1.4 in-sample e 0.9 out-of-sample = **illusione**, non edge.
- **# trade:** con meno di ~30 trade il PF non è affidabile (poco campione).
- **Attenzione al numero di operazioni:** mi aspetto [INFERITO] che la
  **Modalità B** (senza filtro di regime) faccia **molti più trade** — molti
  dei quali nel laterale = frustate. La **Modalità A** ne farà **meno ma più
  puliti**. La domanda non è "chi fa più trade", è "chi ha il PF stabile".

> ⚠️ Nessuna delle due è garantita vincente. Abbiamo già visto che gli
> incroci semplici spesso non hanno edge robusto. Se **entrambe** hanno PF
> instabile, la risposta onesta è: **il valore non è nell'indicatore, è nel
> processo** (bias + livello + candela + rischio 1%). Va bene scoprirlo: è
> esattamente ciò che ti fa smettere di cercare il Graal.

---

## PARTE 2 — Bar-replay manuale (per IMPARARE A VEDERE il regime)

Il backtest dà i numeri; il bar-replay ti allena l'occhio. Scegli **5 giornate
oro passate** (mix: 2 trend puliti, 2 range, 1 con news). Per ognuna, con lo
strumento **Replay** di TradingView, avanza candela per candela e compila:

```
DATA: __________   Tipo giornata: (trend su / trend giù / range / news)

--- Al momento di ogni segnale che vedi ---
Ora: _____   Modalità che dà segnale: (A / B / entrambe)
Prezzo era: SOPRA / SOTTO / DENTRO la nuvola Ichimoku?
ADX era: > 20 ?  (sì/no)     Bande: in espansione o piatte?
=> REGIME: TREND o RANGE?
Esito se fossi entrato (a candela chiusa, SL/TP ad ATR): +____ / -____ R

--- A fine giornata ---
Segnali Modalità A: ___ (vinti ___ / persi ___)
Segnali Modalità B: ___ (vinti ___ / persi ___)
Quanti segnali B erano in RANGE (ADX<20, dentro nuvola)? ___
Quanti di quelli hanno perso? ___
```

### Cosa stai cercando di dimostrare (a te stesso)
> I segnali che ti fregano sono quasi tutti **in range** (ADX basso, prezzo
> dentro/vicino la nuvola, bande piatte). La Modalità A quei segnali **non li
> dà** (filtro di regime). La Modalità B **sì** — ed è lì che perdi.

Se dopo 5 giornate il conteggio conferma questo, hai la tua risposta
**costruita sui dati**: non "Ichimoku sbaglia", ma "gli ingressi vanno presi
**solo in regime di trend**, e serve un filtro che ti tenga fuori dal range".

---

## 📌 La conclusione che conta (qualunque sia il vincitore)
> Il problema non era mai *quale* indicatore. Era **quando** lo usavi
> (trend vs range) e **come** entravi (freccia secca vs livello+conferma).
> Il test serve a farti VEDERE questo, così smetti di cambiare indicatore
> ogni settimana sperando nella magia.
