# S3b: la barra della sera cambia il box del MaxMin? Risultati (23/10/2026)
Eseguita con `RIGA_LANCIA_SONDE_APERTURA_PC_S3B.txt` (pin 2f5cdf4e). **Compilazione sul PC: 0 errori, 0 avvisi.** Solo lettura. CSV in `backtest_pipeline/risultati_sonde_2026-10-23/ABTG_SONDA_BOX2.csv`. Criteri congelati prima: `report/SONDE_S3B_CRITERI_2026-10-23.md` (soglie arbitrarie, scelte dopo S3 e prima di S3b); lettore `backtest_pipeline/sonda_s3b_giudizio.py`.
**Esito congelato: MATERIALE.**
- 322 giorni lun-ven (30/07/2025 - 22/10/2026), 316 con un box nominale (n_nom >= 1). In **tutti** i giorni la barra contaminante e' esattamente 1.
- La barra della sera **cambia il box in 78 giorni su 316 (24,7%)**: 34 volte il massimo, 44 volte il minimo. Fra questi la mediana del cambio e' il **21,7% dell'ampiezza nominale** del box (25 giorni oltre 30 punti).
- **Lunedi' diverso: SI.** 34 giorni su 64 (53,1%) contro 17,5% per martedi'-venerdi' (9 su 64, 11 su 63, 12 su 63, 12 su 62 per i singoli giorni).
- Ampiezza mediana: box dell'EA 116,9 punti il lunedi' (nominale senza la barra: 104,4); martedi'-venerdi' 75,7-104,2 (nominale 73,0-100,7): **il lunedi' la barra della sera allarga il box di circa 12 punti mediani, gli altri giorni quasi niente.**
- **Giorni anomali (n_nom < 100): 7.** Box nominale vuoto (n_nom = 0, quindi l'EA usa la sola barra della sera): 24, 25, 26 e 31 dicembre 2025, 1 gennaio e 1 maggio 2026. Il 6 aprile 2026 (lunedi' di Pasqua) ha 6 barre nominali. Sono giorni in cui il box dell'EA e' una barra o poche barre.
**Cosa significa e cosa NO:**
- Il codice (e quindi i backtest, il forward e la sedia in campo) usa SEMPRE questo box. Cio' che e' misurato dal MaxMin include questo comportamento; **non e' un errore dimostrato e non dice se il PF sarebbe migliore senza la barra.**
- Il box reale e' "00:00-04:59 server + una barra della sera", non "23:00-04:59": l'intestazione e il set (BoxStart 23) non lo dicono.
- Un eventuale quesito "senza la barra della sera" cambierebbe soprattutto i lunedi' e pochi altri giorni. Con 14 posizioni OOS (circa 13 operazioni l'anno) **nessuna variante avrebbe merito misurabile**: si potrebbe leggere solo se cambia il numero di giorni con ordine.
- S1, S2 e S3 sono uscite identiche alla prima esecuzione (S2: 91 su 318 giorni, mediana 8,2%): la sonda e' riproducibile.
