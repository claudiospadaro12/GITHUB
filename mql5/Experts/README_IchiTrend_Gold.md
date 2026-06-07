# IchiTrend Gold — EA base (XAUUSD, M5)

Versione **1.0 — solo le fondamenta**. È la base da testare su **conto DEMO** prima di
aggiungere parzializzazione, breakeven avanzato e piramidazione.

## Cosa fa

| Componente | Logica |
|---|---|
| **Direzione (Ichimoku)** | Rialzista se Tenkan>Kijun **e** prezzo sopra la nuvola (Kumo); ribassista nel caso opposto |
| **Innesco (Bollinger)** | Entro sulla **rottura della banda** nella direzione del trend (chiusura oltre la banda esterna). Bande compresse = nessuna rottura = nessun trade |
| **Stop loss** | Dinamico = `InpATR_SL` × ATR (si adatta alla volatilità) |
| **Trailing** | Dinamico = `InpATR_Trail` × ATR; mette al sicuro i profitti |
| **Rischio** | Lotto calcolato su `InpRiskPercent`% del capitale per trade |
| **Posizioni** | **Una sola per volta** (niente piramidazione in questa versione) |

> ⚠️ **Onestà:** lo stop a breakeven/trailing **riduce** il rischio ma non lo azzera.
> Su oro, slippage, gap e news possono comunque causare perdite. Testa sempre su demo.

## Installazione

1. In MT5: `File → Apri cartella dati`
2. Copia `IchiTrend_Gold_Base.mq5` in `MQL5/Experts/`
3. In MetaEditor premi **Compila** (F7) — non devono esserci errori
4. Torna su MT5, apri un grafico **XAUUSD M5** e trascina l'EA sopra
5. Abilita l'**Algo Trading** (pulsante in alto)

## Parametri principali

| Parametro | Default | Significato |
|---|---|---|
| `InpBBPeriod` | 20 | Periodo delle Bollinger |
| `InpBBDev` | 2.0 | Deviazioni standard: più alto = bande più larghe, rotture più rare/forti |
| `InpATR_SL` | 1.5 | Stop più largo se aumenti; più stretto se diminuisci |
| `InpATR_Trail` | 2.0 | Distanza del trailing dal prezzo |
| `InpRiskPercent` | 0.5 | % di capitale rischiata per trade (tienila bassa!) |
| `InpMaxSpread` | 50 | Spread massimo (in punti) per entrare |

## Come testarlo (workflow)

1. **Strategy Tester** di MT5 → simbolo XAUUSD, timeframe M5, modalità *"Ogni tick basato su tick reali"*
2. Periodo: almeno qualche mese, includendo fasi di trend **e** di laterale
3. Guarda non solo il profitto, ma **drawdown massimo**, **profit factor** e **numero di trade**
4. Riportami i risultati: aggiustiamo i parametri e poi aggiungiamo i pezzi successivi

## Prossimi passi (roadmap)

- [x] **v1.1** — Direzione Ichimoku + innesco rottura Bollinger + SL/trailing su ATR
- [ ] **v2** — Parzializzazione dopo X×ATR + stop a breakeven
- [ ] **v3** — Piramidazione controllata (solo con prima posizione a breakeven)
- [ ] **v4** — Filtro orari news ad alto impatto
