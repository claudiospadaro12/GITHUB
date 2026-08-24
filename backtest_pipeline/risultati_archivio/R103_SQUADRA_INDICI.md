# 🤝 R103 — LA PRIMA MISURA DI SQUADRA (i 15 indici INSIEME)

_Nata da una domanda di Claudio (24/08 pomeriggio): "ORB è l'EA migliore ma
io devo trovare gli EA che INSIEME mi fanno profittare. Ora sono sotto i
100k". È la domanda di PORTAFOGLIO — la classifica misura le sedie una per
una, questa misura la SQUADRA. Calcolata sommando giorno per giorno le
chiusure realizzate dei 15 report della corsa R103-Blocco1 (stessa finestra
21 mesi, taglie vive). [APPROSSIMATO]: somma di 15 backtest indipendenti da
100k ≈ un conto che le fa girare tutte; DD su chiusure = limite inferiore;
un solo regime; OHLC._

## La squadra intera (21 mesi, 2024.09.26 → 2026.06.30)
- **Profitto totale: +149.073 €**
- **DD combinato: ~6.785 € = 6,8% del conto** — le 15 sedie hanno DD singoli
  fra 0,7 e 6,5%: sommati farebbero >40%, INSIEME fanno 6,8%. **La
  diversificazione lavora**: non perdono tutte insieme.
- **Peggior giorno di squadra: −3.892 € (−3,9%) il 19/02/2025** — sotto il
  muro giornaliero prop del 5%, ma non di molto. Dentro quel giorno:
  EMA200 Dow −2.277, SuperWave H1 −670, Dow Apertura −662 → **è il cluster
  U30USD che perde in coro** (7 sedie su 15 stanno sul Dow).
- 453 giorni operati.

## Chi serve alla squadra (leave-one-out: la squadra SENZA quella sedia)

| sedia | senza di lei il profitto | e il DD | lettura |
|---|---:|---:|---|
| EMA200 Dow (I03) | −30.646 | ≈invariato | **motore di profitto puro**: il suo rischio lo assorbe la squadra |
| ORB Dow (I07) | −17.501 | −258 | idem — i suoi stop li pagano i giorni degli altri |
| DAX Apertura (I01) | −17.494 | **+349 (peggiora!)** | profitto E diversificazione: toglierla ALZA il rischio |
| GapFill Nikkei (I05) | −5.399 | **+730 (peggiora!)** | **il miglior diversificatore in rapporto al peso** |
| SupRev NAS (I11), SupRev DAX (I10), SuperWave H2 (I12) | −6.700÷−11.200 | peggiora | coprono giorni degli altri |
| SuperWave DOW H1 (I13) | −7.279 | **−1.213 (migliora)** | il taglio che riduce di più il rischio, al costo minore |
| MaxMinNotte DAX (I06) | −8.445 | −1.190 | riduce il rischio ma costa profitto |
| PTE Dow (I08), SupRev 770924 (I15) | −3.437 / −2.830 | ~0 | neutre sul rischio |

## Le tre conclusioni
1. **"Sotto i 100k" oggi = −0,1%.** Il banco di squadra dice che il normale
   include giornate da −3,9%: la varianza attuale è rumore di fondo.
2. **Il rischio vero della squadra non è una sedia: è il CLUSTER U30USD**
   (7 sedie sullo stesso indice, che nei giorni brutti perdono in coro).
   Le sedie DAX/Nikkei/NAS sono lì apposta — e i numeri mostrano che
   toglierle PEGGIOREREBBE il portafoglio.
3. Questa è la misura per UN gruppo su UNA finestra. **Il round di
   portafoglio completo (R105)** — 40 sedie, correlazioni, squadra ottima —
   si fa quando R103 ha misurato anche forex+metalli sui 6,5 anni, con la
   stessa macchina. Resta la priorità dichiarata della corsia rischio.
