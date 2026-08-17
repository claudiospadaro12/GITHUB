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
