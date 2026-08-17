# CATALOGO DELLA BIBLIOTECA

> ⚠️ **Nota di legittimita' (cacciatore-config-prop, 18/08):** i preset dei
> prodotti a pagamento (Gold Phantom, Gold Reaper, Prop Firm Pass) sono
> **pubblicati dal venditore stesso su URL pubblici `c.mql5.com`**, scaricabili
> senza pagare e senza login. **Sono archiviati SOLO i `.set` (testo di
> configurazione), MAI l'EA.** Se un vendor li ritira, la nostra copia resta
> come prova di cio' che era pubblico il 18/08/2026.

| data | file | fonte/URL | cosa e' | perche' preso | da chi |
|---|---|---|---|---|---|
| 18/08/2026 | `set/TheGoldReaper_propfirm_cmql5-31-1047_2026-08-18.set` | `https://c.mql5.com/31/1047/propfirm__1.set` | preset "prop firm" ufficiale del vendor (Profalgo Ltd) di The Gold Reaper MT5 | contiene `PropFirmMaxDailyDD=4` / `MaxAllowedDD=9`: la prima gamba del pattern 4/9 | cacciatore-config-prop |
| 18/08/2026 | `set/GoldPhantom_*.set` (7 file) | `https://c.mql5.com/31/1765/The_Gold_Phantom_setFiles.zip` | i 7 preset ufficiali del vendor: LowRisk, MediumRisk, HighRisk, combo, **Propfirm**, **Propfirm_combo**, live account settings | il **diff normale→prop** e il **diff prop→prop_combo** (DD 9→4 quando l'EA condivide il conto) sono la lezione n.1 della notte | cacciatore-config-prop |
| 18/08/2026 | `schede/GoldPhantom_readMe_cmql5-31-1765_2026-08-18.txt` | stesso zip | il readMe del vendor che spiega a cosa serve ogni preset | dichiara a parole la regola "combo = rischio piu' basso perche' condivide il conto" | cacciatore-config-prop |
| 18/08/2026 | `set/PropFirmPassEA_*.set` (5 file) | `https://c.mql5.com/31/1790/V2_Set_Files.zip` | i 5 preset ufficiali di Prop Firm Pass EA (ALGOECLIPSE LTD) | lista di input col prefisso `Inp` quasi identica alla nostra: buffer, pausa morbida, reset ora+minuto | cacciatore-config-prop |
| 18/08/2026 | `set/FTMOSmartTrader_*.set` (6 file) | blog MQL5 `https://www.mql5.com/en/blogs/post/765121` (01/11/2025) | preset Conservative/Moderate/Aggressive + 3 set numerati di "FTMO Smart Trader EA" | cap giornaliero in **VALUTA** (non in %) e moltiplicatore lotti `DOWN_LOTS` — caso di studio di cosa NON copiare | cacciatore-config-prop |
| 18/08/2026 | `set/TheImpossibleProp_*.set` (4 file) | blog MQL5 `https://www.mql5.com/en/blogs/post/769728` (07/05/2026) | preset di produzione v1.1 e v2.0 di "The Impossible Prop" EURUSD/GBPUSD, **con commenti riga per riga sul PERCHE' di ogni cambio** | il preset piu' istruttivo trovato: sezioni PROTECTION / NEWS / SHIELD / PROP FIRM / PARALLEL AWARENESS con valori veri | cacciatore-config-prop |
| 2026-08-18 | schede/Quantum_Titan_MT5_2026-08-18.md | MQL5 Market via screenshot di Claudio | scheda prodotto a pagamento (1.199 USD) | bocciato al setaccio: DD 37-40% vs muro 10% | chat principale |
| 18/08/2026 | `set/UltimateEAPropFirms_*.set` (8 file) | blog MQL5 `https://www.mql5.com/en/blogs/post/752189` (18/03/2023) | preset **Phase_1 / Phase_2 / Funded** dello stesso EA + 3 preset di ottimizzazione | l'unica fonte trovata con i **tre stadi della challenge nello stesso EA**: risponde alla riga A3 del PIANO_PROP | cacciatore-config-prop |
| 18/08/2026 | `schede/UltimateEAPropFirms_manuale_mql5blog752189_2026-08-18.md` | stesso blog | manuale pubblico dell'EA | contiene la frase esplicita "tieni il daily DD *sotto* la regola, es. 4,9 se la prop impone 5" — la 4a gamba indipendente del buffer | cacciatore-config-prop |
| 18/08/2026 | `schede/TheImpossibleProp_guida-settings_mql5blog769728_2026-08-18.md` | blog MQL5 769728 | guida ai preset TIP | contiene la **matematica del rischio combinato di 2 EA su un conto prop** (0,75% × 2 = 1,5% < 5%) e il meccanismo sibling via GlobalVariables | cacciatore-config-prop |
| 18/08/2026 | `set/RangeBreakoutDaytrader_*.set` (32 file) | blog MQL5 `https://www.mql5.com/en/blogs/post/760349` (21/12/2024, aggiornato 2026) | preset di un **range-breakout daytrader** su USDJPY / US30 / XAUUSD / BTCUSD, 4 livelli di rischio (ExtraLow/Low/Medium/High), piu' versioni nel tempo | e' la **famiglia piu' vicina alle nostre sedie di apertura**; scala di rischio 2,4 / 4,8 / 10 / 20 e filtro news a 5 minuti su calendario Forex Factory | cacciatore-config-prop |
| 18/08/2026 | `schede/CALENDARIO_news-2022-2025_UTC+2_cmql5-31-1421_2026-08-18.csv` (17.413 righe) e `..._news-2021-2024_...-1257_...csv` (20.386 righe) | `https://c.mql5.com/31/1421/news.csv` · `https://c.mql5.com/31/1257/news.csv` | **export del calendario economico MT5 in CSV**: `data ora;paese;impatto(0-3);evento` | 🔴 **rende BACKTESTABILE un filtro news** (il blocco dichiarato in PIANO_PROP D1). ⚠️ gli orari sono in **UTC+2** (verificato ricalcolando ISM e ADP): su BCM = UTC+1 va tolta **un'ora**. Sta in `schede/` perche' la biblioteca ha solo tre stanze — servirebbe una stanza `dati/` | cacciatore-config-prop |

> 🔤 **Nota di encoding:** parecchi `.set` di MetaTrader sono salvati in **UTF-16LE**
> (`UltimateEAPropFirms_*`, `RangeBreakoutDaytrader_*`). Sono archiviati **come
> sono**, per poterli ricaricare in MT5 senza conversioni. Per leggerli a riga di
> comando: `iconv -f UTF-16 -t UTF-8 file.set`.
