# 🔬 REFERTO ROUND 14 — il banco vergine sul Dow: L'ALTOPIANO REGGE

_Girato il 09/08/2026 sul laboratorio `ABTG_ORB_Ottimizzato`, tick reali, M5,
U30USD — mercato MAI toccato dal motore ORB in nessun round precedente.
Lancio allargato a 24 celle (stop ATR/FIXED/50% × TP 1,0/1,5× × EMA200 on/off ×
tetto 0,8% on/off). Traguardo e falsificazione scritti PRIMA in
`R14_ORB_banco_vergine_Dow.txt`. File: `*_r14.csv`._

## Il traguardo pre-dichiarato

> Maggioranza delle celle della regione (stop ATR/50% × TP 1,0/1,5×, EMA200 ON)
> positiva in ENTRAMBE le finestre, e almeno una cella con PF OOS ≥ 1,10 e n ≥ 30.

## Il risultato: PASSATO

**5 celle su 8 della regione verdi in entrambe le finestre** — e il cuore
(stop 50% range + EMA200) verde su tutte e 4 le sue celle:

| cella (EMA200 ON, solo long) | IS | OOS |
|---|---:|---:|
| 50% / TP 1,0× (tetto 0,8) | **+2035,13 · PF 1,436 · DD 7,9% · 71** | **+1861,48 · PF 1,223 · DD 14,3% · 119** |
| 50% / TP 1,0× (no tetto) | +1706,24 · PF 1,345 · 74 | +1895,52 · PF 1,227 · 120 |
| 50% / TP 1,5× (tetto / no) | +2156,84 · PF 1,404 / +1803,53 · PF 1,320 | +1730,32 · PF 1,183 / +1764,36 · PF 1,186 |
| ATR / TP 1,0–1,5× | piatte (−457…+143) | +1053…+1510 · PF 1,11–1,17 |

**La concordanza fra i due mercati arriva fino al dettaglio**: lo stop 50%
range era il sotto-blocco più solido anche sul Nasdaq (IS PF 1,14–1,22).
La firma della pista, ora confermata su banco vergine:

> **SOLO LONG · apertura USA · OR 15' (14:30→14:45 server) · pendenti STOP ·
> EMA200 su M5 come filtro · stop = 50% dell'ampiezza del range ·
> TP = 1,0–1,5× l'ampiezza · un trade al giorno · chiusura 21:00.**

Rilevatori: trade/mese IS 8,8 vs OOS 9,4 (sane); niente righe identiche
(tutti gli assi girano); il tetto 0,8% è neutro-positivo.

## I freni (scritti qui perché non si perdano)

1. **DD OOS 14–17% all'1%** sulle celle migliori: il criterio prop (<10%)
   NON passa. Colpa prevedibile del "niente BE/parziale/trailing" —
   la gestione è l'oggetto del round 15.
2. **Vento di regime**: sul Dow TUTTE e 24 le celle OOS sono positive —
   la finestra giu-2025→giu-2026 premia qualsiasi long. Il segnale vero è
   che la regione regge anche in IS (periodo diverso) e sul Nasdaq (dove
   l'OOS NON era generosa). Ma il vento va dichiarato: la conferma finale
   resta il forward, come per tutti.
3. Vicinato FIXED: profitti giganti (OOS +7431) con DD 34–46% — inutilizzabile,
   e monito su cosa succede a ignorare la geometria dello stop.
4. Su NASUSD il TP migliore era 1,5×, sul Dow 1,0×: dentro l'altopiano,
   ma il centro esatto differisce — non pinnare mai la cella singola.

## Classifica e prossimo passo

Criteri prop: (1) ✅ (2) ✅ PF OOS 1,18–1,23 (3) ✅ altopiano su 2 assi + 2
mercati (5) ✅ n=119–136 — **(4) ❌ DD**. Quattro su cinque: la pista entra in
classifica fra i 🥈 "a un criterio dal traguardo" come **ORB-EMA200 (lab)**.
**Round 15 (Dow): gestione del DD** — parziale+BE e trailing EMA sulla regione
50%-range, per vedere se il DD scende sotto il 10% senza uccidere il PF.
Nessun deploy: il laboratorio non è mai andato live e non ci va da un backtest.

## Dove sono i numeri

`backtest_pipeline/risultati_prove/ABTG_ORB_Ottimizzato/*_r14.csv` (+ r13 per
il gemello Nasdaq).
