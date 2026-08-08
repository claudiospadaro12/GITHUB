# 🔬 REFERTO ROUND 4 — GoldenCross_Ottimizzato sugli indici (cross-symbol)

_Girato l'08/08/2026 sera sul PC di backtest, driver generico, tick reali (Model=4),
H1, 2024.09.26 → 2026.06.30, taglio IS/OOS al 40% (IS fino al 09/06/2025).
File prova: `prove/R4_GoldenCross_cross.txt` (ipotesi e regole scritte PRIMA)._

## L'ipotesi, com'era scritta

> Se l'edge è del pattern, su ALMENO UNO fra DAX, Dow e Nasdaq a H1 esce positivo in
> entrambe le finestre. Se su tre indici è rosso ovunque, quello su XAUUSD è
> probabilmente oro-specifico (legittimo, ma va scritto) o rumore.

Regola anti-pesca pre-dichiarata: **questo giro non promuove nessuno** — serve solo a
pesare la riga XAUUSD. Config identica al live (nessun parametro toccato), sweep sul
magic: due righe che devono essere identiche = controllo di coerenza gratis.

## Il risultato: ZERO su tre

| simbolo | IS Profit | IS PF | IS n | OOS Profit | OOS PF | OOS n | OOS DD | verde in entrambe? |
|---|---:|---:|---:|---:|---:|---:|---:|---|
| D30EUR (DAX) | **−385,67** | 0,506 | 32 | +132,51 | 1,133 | 60 | 3,92% | ❌ (IS rossa) |
| U30USD (Dow) | +15,08 | 1,026 | 31 | **−519,48** | 0,696 | 63 | 6,74% | ❌ (OOS rossa) |
| NASUSD (Nasdaq) | **−254,75** | 0,554 | 28 | −23,40 | 0,979 | 64 | 5,04% | ❌ (rosse entrambe) |

Coerenza magic-sweep: **6 finestre su 6 con le due righe identiche al centesimo** —
i test sono validi. Trade/mese IS↔OOS nella norma su tutti e tre (3,3–3,8 contro
4,7–5,0): nessun problema di storico.

E i tre fallimenti sono **tre modi diversi di non avere un edge**: il DAX perde in
campione e "vince" fuori (inversione di regime, come EMA200_Ott sull'oro), il Dow è
piatto in campione e perde fuori, il Nasdaq perde ovunque. Nessuna struttura, nessuna
direzione comune: rumore che cambia faccia.

## Verdetto (dalla regola scritta prima, non da me)

**Il pattern GoldenCross NON viaggia: l'edge misurato su XAUUSD H1 è oro-specifico o
rumore.** La riga XAUUSD (OOS +308,30 · PF 1,253 · 57 trade) resta vera — nessun
backtest la cancella — ma da oggi **pesa di meno**: le mancava già il criterio del
vicinato ADX (round 2: 9° ribaltamento, e 10≡15 = filtro inerte), ora le manca anche
la conferma cross-symbol. Due indizi indipendenti che puntano nella stessa direzione.

**Conseguenze operative:**
- Nessun cambio al live (la regola del giro: non si promuove e non si boccia nessuno).
- In classifica GoldenCross_Ott resta nei 🥈 ma in fondo, con la doppia nota.
- Il giudice che rimane è il forward su XAUUSD — con aspettative basse e dichiarate.
- I fratelli forex (NZDUSD/USDCAD/USDCHF, già senza edge in FASE 0) hanno ora una
  spiegazione più semplice: non è il simbolo sbagliato, è il pattern che non generalizza.

## Dove sono i numeri

`backtest_pipeline/risultati_prove/ABTG_GoldenCross_Ottimizzato/*_r4.csv`
(6 file: IS+OOS × D30EUR/U30USD/NASUSD).
