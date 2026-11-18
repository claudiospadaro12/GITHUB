# MAX-MIN della notte (DAX): criteri e previsioni scritti PRIMA dei numeri (18/11/2026)
Natura: simulatore Python su M1 esterni `D30EUR_M1.csv` (HistData, ora di New York con ora legale USA: verificato, picco di ampiezza a 03:00 NY = 09:00 CET in inverno, estate e nov-dic). Nessun ordine, nessun giudizio su lotti/taglie. Regole dai PDF `014_Piano_Trading_-_MAX-MIN_ABTG.pdf` e `010_ABTG-MAX-MIN_20250925.pdf` (sintesi: `LEZIONE_MAX_MIN_NOTTE_REGOLE_2026-11-18.md`).
## Qualita dei dati (scoperta del 18/11, prima dei numeri)
Dal confronto mese per mese dei prezzi: **2019-01 -> 2020-06 = DAX** (10.900-13.500, crollo di marzo 2020); **2020-07 -> 2023-11 = NON DAX** (3.200-4.400, livello Euro Stoxx 50, meno barre); **2023-12 -> = di nuovo DAX** (16.700). Il file non e una serie DAX continua. Uso: **DAX 2019-01..2020-06** per la selezione; **2020-07..2023-11 come secondo mercato europeo** (strumento diverso, dichiarato); **DAX 2024** quando arriva lo zip. Il 2025-26 non si apre.
## Regola (dai PDF; ora convertita da New York a CET/CEST con le regole di ora legale USA ed EU reali, comprese le settimane di scarto)
- **Box notturno:** massimo e minimo di **02:00-07:59:59 CET** (strategia e slide). Variante B: 00:00-05:59 (il piano scritto la riporta nel punto ii: contraddizione).
- **Ordini** alle 08:59: BUY STOP = massimo notte + buffer, SELL STOP = minimo notte - buffer; **buffer 10 punti** (scala DAX a 12.000). Validi 09:00-11:00 CET e poi cancellati. **OCO assunto:** al fill si cancella l'opposto; se entrambi scattano nello stesso minuto, giorno saltato. Una operazione al giorno.
- **Gestione A (scala 3 parti da 1/3):** target 30, 87, 113 punti dall'ingresso; dopo il 1° stop in pari, dopo il 2° stop a +30. Variante **gestione B:** tutto al 1° target (30). **Stop A:** 30 punti dall'ingresso; **variante stop B:** estremo opposto del box (+ buffer). **Uscita forzata alle 11:45 CET** (esempio delle slide). SL prima dei target se nella stessa barra.
- Punti scalati sul prezzo (riferimento 12.000): costi **2,0 punti a operazione**; i risultati sono in "punti equivalenti a 12.000".
- **Non testati:** correlazioni con SPX/Nikkei, reversal (SELL/BUY LIMIT), filtri su volumi e "laterale", notizie, EMA 200 reale come target (sostituita dal 3° target fisso a 113), copertura in hedging.
## Griglia (8 set; contatore looks 8)
box {02:00-07:59; 00:00-05:59} x stop {30 punti; estremo opposto} x gestione {scala 3 parti; singolo target 30}.
## Porte
- **Selezione DAX 2019-01..2020-06:** netto > 0, PF netto >= 1,20, t >= 2,0, operazioni >= 100, positivo in entrambi i periodi 2019 e 2020-H1; max 3 candidati.
- **Validazione:** (1) secondo mercato europeo 2020-07..2023-11: stesse porte (n >= 100, PF >= 1,20, t >= 2,0, profitto > 0); (2) DAX 2024: profitto > 0 e PF >= 1,20. **Finalista** = passa selezione e (1); solo allora: vicini, BCM 2024-26 nativo (cancello D semplice), regole non testate. Nessun candidato = famiglia chiusa.
## Previsioni (scritte ora)
- >= 1 set passa la selezione: **25%** (periodo breve, filtro n >= 100 e t >= 2 severi); candidato passa la validazione (1): **8%**; finalista passa anche il DAX 2024: **3%**.
- La gestione A (scala) ha un PF aggregato piu alto della B (target singolo) in almeno 3 coppie di set su 4: **50%**.
- Il win rate osservato (obiettivo dichiarato dal corso: > 70%) e < 70%: **70%**.
