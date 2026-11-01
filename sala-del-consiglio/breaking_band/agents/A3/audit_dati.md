# A3 / R002 - Audit dati M1 oro e geometria a priori

Script: `agents/A3/audit_dati.py` (eseguito con `python3 -I audit_dati.py <cartella exp_all> --json out.json`; solo numpy). Self-check dello script su dati sintetici (costruzione barre H1, Bollinger su serie costante, formula win rate di pareggio, Bollinger cumsum vs calcolo diretto): 4/4 SUPERATI. Nessun backtest di regole, nessun parametro ottimizzato. Etichette: FATTO_VERIFICATO = calcolato dallo script sui CSV; INFERENZA / DA_VERIFICARE dichiarate.

Convenzioni: spread in punti, 1 punto = 0,01 USD (INFORMAZIONE_DEL_COMMITTENTE, dal brief). Orari = ora server come nel CSV (nessuna conversione; il brief dice che l'ora server BCM non e rilevante qui, ma le tabelle per ora sono in ora server). Le barre H1/M15 sono allineate a :00 del tempo del CSV; esiste una barra se ha almeno 1 M1.

## 1. Audit dati

### 1.1 Copertura e integrita temporale (FATTO_VERIFICATO)
| Periodo | Righe | Primo | Ultimo | Duplicati ts | Ordine violato | Malformate | H1 | M15 |
|---|---|---|---|---|---|---|---|---|
| 2013 | 348,647 | 2013-01-01 23:05 | 2013-12-31 16:59 | 0 | 0 | 0 | 5,874 | 23,440 |
| 2018 | 349,730 | 2018-01-02 07:00 | 2018-12-31 18:59 | 0 | 0 | 0 | 5,873 | 23,487 |
| 2020 | 351,258 | 2020-01-02 04:00 | 2020-12-31 18:59 | 0 | 0 | 0 | 5,904 | 23,611 |
| 2025-26 | 611,062 | 2025-01-02 00:05 | 2026-09-30 23:59 | 0 | 0 | 0 | 10,280 | 41,095 |

- Righe = righe dati (header escluso). Intervalli: i quattro file sono anni solari 2013, 2018, 2020 e gen 2025 - 30 set 2026 (non "ott 2026": l'ultima riga e 2026-09-30 23:59).
- Bordi: 2018 inizia il 02/01 alle 07:00 e 2020 il 02/01 alle 04:00 (primi giorni parziali); 2013 finisce il 31/12 alle 16:59. Effetto trascurabile (< 1 giorno per file) ma i periodi non sono anni completi esatti.
- Nessun timestamp duplicato, nessuna violazione dell'ordine temporale, nessuna riga malformata, nessuna riga di sabato (le righe di domenica, ~2.800-3.000 per file, sono la riapertura serale del mercato: coerente con apertura domenica ~23:00).
- 2025-26: 611.062 righe su ~21 mesi, in linea con gli altri file (~350k/anno).

### 1.2 Buchi (FATTO_VERIFICATO)
Un buco = differenza > 1 minuto tra righe consecutive. "Weekend" = buco >= 24 h che contiene un sabato (durata mediana 2.951 min ~ 49 h nel 2013-2020, 3.011 min nel 2025-26; massimo 4.396-4.581 min nei weekend lunghi). Pausa giornaliera = buco di 60-119 min.
| Periodo | 2-5 min | 6-59 min | 60-119 min (pausa giornaliera) | 120-1439 min | weekend (contiene sabato) | altro >=1440 min non weekend | Minuti mancanti (escl. weekend) |
|---|---|---|---|---|---|---|---|
| 2013 | 327 | 17 | 181 | 23 | 52 | 1 | 19,705 |
| 2018 | 37 | 1 | 186 | 18 | 52 | 1 | 18,471 |
| 2020 | 272 | 4 | 189 | 17 | 52 | 0 | 16,726 |
| 2025-26 | 49 | 101 | 350 | 8 | 91 | 2 | 30,028 |

- Buchi anomali (>= 120 min feriali, escluso weekend): 2013 = 24, 2018 = 19, 2020 = 17, 2025-26 = 10. Sono quasi tutti: (a) feste (Natale 24-26/12: 2.281, 2.011, 1.701 min; Capodanno 2025-26: 1.511 min; festivi USA con chiusura anticipata 216-306 min, es. 21/01/2013, 18/02/2013, 27/05/2013, 04/07/2013, 02/09/2013, 28/11/2013; stessi giorni negli altri anni); (b) pause serali allungate di 126-132 min in periodi ricorrenti (ott-nov 2013, mar 2018, mar 2020, ott-nov 2018): INFERENZA = cambio di orario legale tra USA e server (non verificato).
- Elenco completo dei 20 buchi piu lunghi per periodo: nel JSON dello script (campo `buchi_anomali_top20`), riproducibile.
- Buchi brevi (2-59 min): 2013 = 344, 2018 = 38, 2020 = 276, 2025-26 = 150. INFERENZA: minuti senza tick (notte, bassa liquidita; nel 2025-26 concentrati all'ora server 23 con 92 buchi di 6-59 min). Non e un errore, ma significa che M1 non e una griglia completa: le barre H1 che contengono buchi sono costruite con meno di 60 M1.
- Minuti mancanti totali (escluso weekend): 19.705 / 18.471 / 16.726 / 30.028 (la maggior parte e la pausa giornaliera ~1-2 h in cui il mercato e chiuso).
- Nessun "buco silenzioso" in mezzo alla sessione oltre a quanto sopra: DA_VERIFICARE solo se un buco di pochi minuti in sessione (es. 2013, 20 buchi iniziati all'ora 0) sia mancanza dati del broker o assenza di tick.

### 1.3 Valori anomali (FATTO_VERIFICATO)
| Controllo | 2013 | 2018 | 2020 | 2025-26 |
|---|---|---|---|---|
| high<low | 0 | 0 | 0 | 0 |
| high<max(open,close) | 0 | 0 | 0 | 0 |
| low>min(open,close) | 0 | 0 | 0 | 0 |
| prezzi<=0 | 0 | 0 | 0 | 0 |
| nan | 0 | 0 | 0 | 0 |
| tickvol==0 | 0 | 0 | 0 | 0 |
| barre_piatte(h==l) | 1792 | 831 | 770 | 143 |
| spread==0 | 439 | 94 | 144 | 0 |
| spread<0 | 0 | 0 | 0 | 0 |
| salti_close_>0,5%_in_1_minuto | 57 | 1 | 59 | 183 |
| salti_close_>1%_in_1_minuto | 9 | 0 | 5 | 21 |
| max salto close in 1 min (%) | 1.81 | 0.65 | 1.87 | 2.06 |
| range M1 massimo (USD) | 20.25 | 13.34 | 37.21 | 108.65 |
| prezzo min - max | 1180 - 1696 | 1160 - 1366 | 1451 - 2075 | 2614 - 5597 |

- Coerenza OHLC perfetta: nessun high < low, nessun high sotto max(open,close), nessun low sopra min(open,close), nessun prezzo <= 0 o NaN.
- ANOMALIA: spread = 0 in 439 righe (2013), 94 (2018), 144 (2020) e 0 nel 2025-26. Non sono distribuite a caso: in 2013 364 su 439 sono a luglio 2013 (distribuite su tutte le ore); in 2020 115 su 144 a maggio 2020 e 27 ad aprile (soprattutto ore server 10-15). INFERENZA: spread non registrato/valore mancante. Un test che usa questo spread sottostima il costo in quelle ore; impatto sul totale < 0,13% delle righe (439/348.647) ma DA_TRATTARE (A4: sostituire con lo spread mediano dell'ora o escludere, e dichiararlo).
- Salti di chiusura >1% tra due righe consecutive: 9 (2013), 0 (2018), 5 (2020), 21 (2025-26); massimo 2,06%. ATTENZIONE: la metrica include le riaperture dopo weekend/festivi (es. 21/07/2013, 05/01/2020, 23/02/2020, 08/03/2020, 05/04/2026, 12/04/2026, 24/05/2026 sono domeniche: gap di apertura, non salti intraday). Gli altri cadono su date di forte volatilita (15/04/2013, 24/03/2020, 02/02/2026), plausibili. Non sono evidenti errori di dato; DA_VERIFICARE con fonte indipendente (non disponibile). Per A4: i gap di riapertura entrano nell'ATR e negli stop.
- Barre piatte (high = low): 1.792 / 831 / 770 / 143: tipiche di minuti con un solo tick.
- Il livello di prezzo cambia molto: 1.180-1.696 (2013), 1.160-1.366 (2018), 1.451-2.075 (2020), 2.614-5.597 (2025-26). Conseguenza: le distanze in dollari non sono confrontabili tra periodi; per questo la geometria e in unita ATR.

### 1.4 Spread (USD = punti x 0,01) - FATTO_VERIFICATO
| Periodo | min | p50 | media | p90 | p99 | max | (p50/p90/p99 in punti) |
|---|---|---|---|---|---|---|---|
| 2013 | 0.00 | 0.36 | 0.38 | 0.52 | 0.84 | 6.27 | 36/52/84 |
| 2018 | 0.00 | 0.21 | 0.21 | 0.27 | 0.40 | 1.35 | 21/27/40 |
| 2020 | 0.00 | 0.17 | 0.23 | 0.41 | 1.60 | 17.44 | 17/41/160 |
| 2025-26 | 0.04 | 0.21 | 0.23 | 0.30 | 0.45 | 15.36 | 21/30/45 |

Spread per ora del giorno (ora server; formato p50 / p90 / p99 in USD; n indicato solo se < 10.000 righe nell'ora):
| Ora server | 2013 | 2018 | 2020 | 2025-26 |
|---|---|---|---|---|
| 00 | 0.41 / 0.57 / 0.90 | 0.23 / 0.28 / 0.42 | 0.20 / 0.67 / 1.61 | 0.25 / 0.33 / 0.49 |
| 01 | 0.38 / 0.51 / 0.78 | 0.23 / 0.27 / 0.39 | 0.18 / 0.49 / 1.61 | 0.25 / 0.32 / 0.47 |
| 02 | 0.37 / 0.52 / 0.89 | 0.22 / 0.27 / 0.40 | 0.17 / 0.45 / 1.60 | 0.25 / 0.33 / 0.46 |
| 03 | 0.35 / 0.50 / 0.76 | 0.23 / 0.27 / 0.40 | 0.18 / 0.45 / 1.66 | 0.25 / 0.32 / 0.44 |
| 04 | 0.34 / 0.50 / 0.68 | 0.23 / 0.27 / 0.40 | 0.18 / 0.49 / 1.61 | 0.24 / 0.32 / 0.41 |
| 05 | 0.33 / 0.50 / 0.67 | 0.23 / 0.27 / 0.40 | 0.18 / 0.48 / 1.62 | 0.24 / 0.32 / 0.43 |
| 06 | 0.32 / 0.49 / 0.65 | 0.22 / 0.26 / 0.39 | 0.17 / 0.44 / 1.63 | 0.26 / 0.33 / 0.45 |
| 07 | 0.30 / 0.48 / 0.71 | 0.20 / 0.25 / 0.39 | 0.16 / 0.36 / 1.64 | 0.20 / 0.31 / 0.42 |
| 08 | 0.29 / 0.48 / 0.69 | 0.20 / 0.25 / 0.39 | 0.16 / 0.33 / 1.61 | 0.19 / 0.26 / 0.35 |
| 09 | 0.28 / 0.47 / 0.68 | 0.21 / 0.25 / 0.39 | 0.16 / 0.34 / 1.60 | 0.19 / 0.26 / 0.34 |
| 10 | 0.29 / 0.47 / 0.73 | 0.21 / 0.25 / 0.39 | 0.16 / 0.33 / 1.33 | 0.19 / 0.26 / 0.34 |
| 11 | 0.28 / 0.47 / 0.70 | 0.21 / 0.25 / 0.39 | 0.17 / 0.34 / 1.23 | 0.19 / 0.26 / 0.35 |
| 12 | 0.29 / 0.47 / 0.72 | 0.20 / 0.25 / 0.39 | 0.16 / 0.32 / 1.33 | 0.20 / 0.26 / 0.33 |
| 13 | 0.33 / 0.53 / 1.49 | 0.20 / 0.24 / 0.39 | 0.15 / 0.30 / 1.25 | 0.20 / 0.27 / 0.35 |
| 14 | 0.32 / 0.49 / 0.90 | 0.19 / 0.24 / 0.38 | 0.13 / 0.26 / 1.18 | 0.21 / 0.27 / 0.37 |
| 15 | 0.32 / 0.50 / 0.98 | 0.19 / 0.24 / 0.38 | 0.13 / 0.26 / 0.96 | 0.19 / 0.27 / 0.37 |
| 16 | 0.31 / 0.47 / 0.73 | 0.19 / 0.24 / 0.38 | 0.14 / 0.28 / 0.87 | 0.19 / 0.26 / 0.35 |
| 17 | 0.39 / 0.51 / 0.79 | 0.20 / 0.25 / 0.39 | 0.15 / 0.29 / 0.96 | 0.19 / 0.27 / 0.37 |
| 18 | 0.40 / 0.57 / 0.97 | 0.20 / 0.25 / 0.39 | 0.15 / 0.32 / 1.26 | 0.19 / 0.29 / 0.40 |
| 19 | 0.40 / 0.58 / 0.94 | 0.20 / 0.25 / 0.39 | 0.16 / 0.32 / 1.15 | 0.19 / 0.28 / 0.41 |
| 20 | 0.43 / 0.60 / 0.85 | 0.20 / 0.26 / 0.39 | 0.16 / 0.34 / 1.53 | 0.19 / 0.28 / 0.39 |
| 21 | 0.48 / 0.62 / 0.86 | 0.23 / 0.34 / 0.42 | 0.21 / 0.57 / 1.33 | 0.21 / 0.34 / 0.79 |
| 22 | n.d. (nessuna barra) | n.d. (nessuna barra) | 0.20 / 0.28 / 0.31 (n=225) | 0.24 / 0.56 / 1.21 (n=5580) |
| 23 | 0.46 / 0.64 / 0.99 | 0.23 / 0.32 / 0.45 | 0.25 / 0.81 / 1.93 | 0.26 / 0.30 / 0.34 |

Letture (FATTO): lo spread mediano e uguale nel 2018 e nel 2025-26 (0,21 USD) e piu alto nel 2013 (0,36); le code sono pesanti nel 2020 (p99 = 1,60, max 17,44 USD). Le ore server 21-23 e 0-1 sono tra le piu care (rollover): 2013 0,41-0,48; 2018 0,23; 2020 0,20-0,25 (con p90 fino a 0,81). Nel 2025-26 lo spread notturno (ore 23-6) e 0,24-0,26 contro 0,19-0,21 nelle ore 8-20. Spread mediano a 0,21 USD significa 21 punti; per un conto FTMO lo spread reale puo differire: DA_VERIFICARE (i dati sono del broker BCM, non FTMO).

## 2. Geometria rischio/rendimento a priori (nessun pattern guardato)

Definizioni (dichiarate prima dei numeri): barre H1 e M15 da M1; Bollinger(20, 2) sulle chiusure, deviazione standard di popolazione; ATR(14) di Wilder; "mediana" = linea centrale = SMA(20) (interpretazione: il target e la media centrale delle bande; la mediana vera dei 20 prezzi sarebbe diversa, vedi limiti). Per ogni barra, alla sua chiusura: d_inf = (SMA - banda inf)/ATR, d_sup = (banda sup - SMA)/ATR, larghezza = (banda sup - banda inf)/ATR. Scartate le prime 20 barre.

Fatto strutturale (FATTO_VERIFICATO e ovvio per costruzione): con Bollinger simmetriche d_inf = d_sup = 2 sigma/ATR in ogni barra (differenza massima osservata: 3,2e-14, solo arrotondamento); la larghezza e esattamente 2 x d. Quindi "distanza SMA-banda inferiore" e "banda superiore-SMA" sono la stessa statistica, e lo stesso vale per long (ingresso sulla banda inferiore, target SMA) e short.

Win rate di pareggio. Trade con stop S = 3 ATR e target T = distanza dall'ingresso (sulla banda opposta) alla SMA = d (in ATR). Costo c = spread in ATR, pagato una volta (ingresso e uscita a mercato; vedi limiti).
- Senza costo: EV = p*T - (1-p)*S = 0 => p* = S/(S+T).
- Con costo: p*(T-c) - (1-p)*(S+c) = 0 => p* = (S+c)/(S+T).
- Scenario "mediano" = target uguale alla mediana di d del periodo; costo c = mediana su tutte le barre di (spread mediano M1 del periodo / ATR della barra).
Questo e un calcolo aritmetico sulla geometria, non un backtest.

#### H1
| Periodo | Barre valide | ATR$ p50 | dist.(SMA-inf)=(sup-SMA) ATR p10/p50/p90 | Larghezza ATR p10/p50/p90 | Spread med. $ | Costo ATR p50 (p10-p90) | Target ATR (mediana) | R:R | WR pareggio senza costo | WR pareggio con spread mediano | WR pareggio per barra senza / con costo (p10-p50-p90) |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 2013 | 5,855 | 4.16 | 1.11 / 1.98 / 3.78 | 2.22 / 3.96 / 7.57 | 0.36 | 0.087 (0.057-0.131) | 1.981 | 0.66 | 60.2% | 62.0% | 44-60-73% / 45-62-75% |
| 2018 | 5,854 | 2.24 | 1.17 / 1.94 / 3.48 | 2.34 / 3.89 / 6.96 | 0.21 | 0.094 (0.071-0.117) | 1.943 | 0.65 | 60.7% | 62.6% | 46-61-72% / 48-63-74% |
| 2020 | 5,885 | 5.38 | 1.07 / 1.77 / 3.33 | 2.14 / 3.55 / 6.66 | 0.17 | 0.032 (0.019-0.052) | 1.775 | 0.59 | 62.8% | 63.5% | 47-63-74% / 48-63-75% |
| 2025-26 | 10,261 | 15.13 | 1.21 / 2.00 / 3.59 | 2.43 / 4.00 / 7.17 | 0.21 | 0.014 (0.008-0.030) | 2.000 | 0.67 | 60.0% | 60.3% | 46-60-71% / 46-60-72% |
#### M15
| Periodo | Barre valide | ATR$ p50 | dist.(SMA-inf)=(sup-SMA) ATR p10/p50/p90 | Larghezza ATR p10/p50/p90 | Spread med. $ | Costo ATR p50 (p10-p90) | Target ATR (mediana) | R:R | WR pareggio senza costo | WR pareggio con spread mediano | WR pareggio per barra senza / con costo (p10-p50-p90) |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 2013 | 23,421 | 1.90 | 1.10 / 1.83 / 3.39 | 2.19 / 3.66 / 6.78 | 0.36 | 0.189 (0.108-0.324) | 1.831 | 0.61 | 62.1% | 66.0% | 47-62-73% / 49-66-79% |
| 2018 | 23,468 | 1.05 | 1.13 / 1.89 / 3.31 | 2.25 / 3.77 / 6.62 | 0.21 | 0.200 (0.132-0.277) | 1.886 | 0.63 | 61.4% | 65.5% | 48-61-73% / 50-66-78% |
| 2020 | 23,592 | 2.60 | 1.06 / 1.73 / 3.13 | 2.13 / 3.45 / 6.25 | 0.17 | 0.065 (0.035-0.115) | 1.727 | 0.58 | 63.5% | 64.9% | 49-63-74% / 50-65-76% |
| 2025-26 | 41,076 | 6.98 | 1.17 / 1.91 / 3.38 | 2.34 / 3.82 / 6.75 | 0.21 | 0.030 (0.016-0.066) | 1.912 | 0.64 | 61.1% | 61.7% | 47-61-72% / 48-62-73% |

Lettura dei numeri (FATTO_VERIFICATO):
- La distanza mediana banda-SMA e ~1,7-2,0 ATR in tutti i periodi e i due timeframe (range dei p50: 1,73 - 2,00). Contro uno stop a 3 ATR il rapporto target/stop e 0,58 - 0,67.
- Win rate di pareggio SENZA costo: 60,0% - 63,5% (mediano). Con spread mediano: 60,3% (H1 2025-26) fino a 66,0% (M15 2013). Su H1 il costo sposta il pareggio di +0,3 / +1,9 punti percentuali (2025-26: +0,3; 2020: +0,7; 2013: +1,7; 2018: +1,9); su M15 di +0,6 / +4,1 punti (2025-26: +0,6; 2020: +1,4; 2013: +3,9; 2018: +4,1) perche l'ATR M15 e piccolo rispetto allo spread.
- Dispersione: il win rate di pareggio per singola barra va da ~44-49% (p10) a ~71-74% (p90) senza costo, fino al 79% (M15 2013 p90 con costo). Il p10 e il p90 dipendono dalla barra: quando le bande sono strette (d ~ 1,1 ATR) serve ~73% di vittorie, quando sono larghe (d ~ 3,5 ATR) basta ~47%.
- Costo spread: H1 = 0,01 - 0,09 ATR (mediana), mai > 0,25 ATR; M15 = 0,03 - 0,20 ATR; quota di barre M15 con costo > 0,25 ATR = 25,0% (2013), 19,9% (2018), 0,1% (2020), 0% (2025-26). Con lo spread p90 al posto del mediano (costo = spread p90 / ATR mediano per barra) il pareggio con target mediano e: H1 = 60,4% (2025-26), 62,7% (2013), 63,1% (2018), 64,4% (2020); M15 = 61,9% (2025-26), 66,7% (2018), 66,8% (2020), 67,8% (2013).
- Il target e sempre > spread: nessuna barra ha d <= c (quota 0%).
- Larghezza mediana delle bande: 3,5 - 4,0 ATR (H1) e 3,5 - 3,8 ATR (M15).

## 3. Cosa implica per la strategia (senza testare le regole del pattern)

1. Soglia di win rate necessaria (FATTO + INFERENZA sulla scelta del target): con stop 3 ATR e target = SMA di ingresso sulla banda opposta, la strategia deve vincere circa 60-63% dei trade prima dei costi e circa 60-66% dopo lo spread mediano (H1 ~60-64%, M15 ~62-66%). Non e un'asticella bassa: un win rate del 50% o 55% perderebbe sistematicamente.
2. Cosa dice la geometria su un mercato senza alcun vantaggio (INFERENZA da teoria): per un moto browniano senza deriva la probabilita di toccare +T prima di -S e S/(S+T), cioe esattamente il win rate di pareggio senza costo. Quindi "entrare sulla banda opposta" non da nessun vantaggio per costruzione: il vantaggio, se esiste, deve venire dal fatto che dopo il pattern la probabilita di arrivare alla SMA prima dello stop a 3 ATR supera S/(S+T) di un margine almeno pari allo spread. Il costo e quindi un dente fisso contro il quale servono +0,3 / +4 punti percentuali di edge in piu sul win rate.
3. Timeframe: a parita di stop in ATR il costo in termini di ATR e circa 2,1-2,2 volte piu alto su M15 che su H1 (mediana costo 0,03-0,20 vs 0,01-0,09 ATR; l'ATR scala con la radice del tempo): il test su M15 e piu esposto allo spread, soprattutto nei periodi 2013 e 2018 (spread mediano 0,36 / 0,21 USD contro ATR M15 1,9 / 1,0 USD).
4. Asimmetria: con R:R = 0,6-0,67 un solo stop (3 ATR) cancella 1,5-1,7 target. Il profit factor atteso al pareggio e 1,0; per un PF lordo di 1,2 serve un win rate sopra il pareggio di circa 4 punti percentuali (PF = p*T / ((1-p)*S); con T/S = 0,65 il pareggio e p = 60,6% e PF = 1,2 richiede p = 64,9%, prima del costo).
5. Condizione che aiuta: il target deve essere ricalcolato (SMA mobile) e i filtri della Checklist (compressione, rientro ordinato) selezionano barre con bande strette o larghe diversamente dalla media: se il pattern seleziona barre con bande strette (d ~ 1,1 ATR), il pareggio sale a ~73%; se seleziona barre con bande larghe (d ~ 3,5 ATR), scende a ~46%. Il test sulle regole deve quindi riportare la distribuzione di d AL MOMENTO dell'ingresso e confrontare il win rate osservato con il pareggio DI QUELLE barre, non con quello medio (suggerimento ad A4/A7).
6. Un test che non facesse pagare lo spread nei periodi con spread = 0 (2013-07, 2020-05) sottostimerebbe il costo.

## 4. Limiti (dichiarati)
- Costo modellato come spread mediano pagato una sola volta (ingresso a mercato sul lato sfavorevole, uscita sul lato sfavorevole). Slippage, commissioni, swap non inclusi (non presenti nei dati).
- L'ingresso e supposto esattamente sulla banda opposta, l'uscita esattamente sulla SMA e sullo stop esattamente a 3 ATR: nella realta, ingresso alla barra dopo (gap) e gap sullo stop peggiorano il risultato. Il pareggio calcolato e un limite inferiore.
- Il target "mediana" nella Checklist (non verificato qui) puo essere la linea centrale o la mediana dei prezzi; qui = SMA(20), ricalcolata ogni barra, mentre R003 prevede ricalcolo ogni 3 barre: la distanza reale tra ingresso e target cambia mentre il trade e aperto.
- La distribuzione della geometria e su TUTTE le barre, non sulle barre dove il pattern scatta (volutamente: nessun pattern guardato). Il pareggio effettivo del pattern dipende dalle barre selezionate (vedi 3.5).
- Spread del broker BCM, non FTMO: DA_VERIFICARE per il conto prop.
- Il dato M1 viene da un solo broker: non verificabile con altra fonte; i buchi di pochi minuti non distinguono "nessun tick" da "dato perso".
- Dati usati: file con sola ora server e senza informazione sul fuso; ATR e Bollinger sono calcolati su barre attraverso i buchi (la barra dopo un weekend ha un true range che include il gap: gonfia l'ATR di poche barre per settimana, effetto stimato < 1% delle barre; non quantificato esattamente).
