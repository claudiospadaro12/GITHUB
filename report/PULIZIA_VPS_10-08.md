# PULIZIA VPS -- 10/08/2026 sera (decisione di Claudio: "VAI")

Conto: **50503392** (demo piccolo, vecchio MT5). Il -V3/100k NON si tocca.
Meccanica: per staccare un EA basta CHIUDERE IL SUO GRAFICO (o tasto
destro sul grafico -> Consulenti Esperti -> Rimuovi). A fine pulizia:
File -> Profili -> Salva profilo (sovrascrivi 'ORO').

## ⚠️ PRIMA DI TUTTO -- posizioni aperte dei morti
Nella scheda Trade: se un EA da spegnere ha posizioni aperte (si
riconoscono dal commento), CHIUDERLE A MERCATO prima di staccarlo --
un EA staccato non gestisce piu' stop e target. Caso noto: i 2 STREV
sull'oro del "gruppo di controllo" (04/08) -- l'esperimento si chiude
stasera con la pulizia: chiudere anche quelli e annotare l'esito.

## TIER 1 -- SPEGNERE (bocciati con referto, o bug noti)

| # | Grafico / EA | Perche' |
|---|---|---|
| 1 | **ABTG_ORB (corso) @ NASUSD M5** | bug pendente noto; oggi -42,91 in 4 min; magic 770601 |
| 2 | **ABTG_ORB_Fibo @ NASUSD M5** | FASE 0: niente edge |
| 3 | **ABTG_Nightly @ EURUSD M15** | FASE 0: niente edge; decreto 10/08 (matrice venerdi') |
| 4 | **ABTG_MaxMinNotte @ EURUSD M15** | FASE 0: niente edge su EURUSD. ⚠️ NON confondere col MAXMIN ORO su XAUUSD appena deployato (stesso EA, quello RESTA!) |
| 5 | **GoldenCross: TUTTI i 5 grafici** (XAUUSD H1, XAUUSD _Ottimizzato, NZDUSD/USDCAD/USDCHF H4) | capitolo chiuso oggi con R20 (9 lanci: 0 promossi) |
| 6 | **ABTG_PTE @ XAUUSD** | FASE 0: niente edge (16 celle, 0 positive) |
| 7 | **ABTG_WOL @ XAUUSD D1** | FASE 0: niente edge |
| 8 | **ABTG_SupertrendInvert @ XAUUSD H1** | FASE 0: niente edge |
| 9 | **ABTG_PostNews @ EURUSD e @ EURJPY** | FASE 0: niente edge (entrambe le istanze) |
| 10 | **SupRev CAC @ F40EUR H4** | FASE 0: niente edge |
| 11 | **ABTG_SupertrendReversal @ D30EUR H4** | FASE 0: niente edge su D30EUR |
| 12 | **ABTG_SupertrendReversal (base) @ NASUSD** | doppione dell'Ott (oggi 2 buy a 0 secondi); resta SOLO SupRev_NAS_H1_Ottimizzato |
| 13 | **ABTG_SupertrendReversal @ XAGUSD** | mai misurato (argento: storico corto); o si misura o si spegne |
| 14 | **ABTG_EMA200 (base): i 6 grafici** (XAUUSD, 200AUD, AUDJPY, GBPJPY, GBPUSD, SPXUSD) | 200AUD bocciato in FASE 0, gli altri mai misurati; resta SOLO EMA200_Ottimizzato @ XAUUSD |
| 15 | **ABTG_HARSI @ EURUSD M5** | mai misurato |

## TIER 2 -- VERIFICARE che siano davvero spenti (dal censimento lo erano)

Live5m x3 (spenti il 09/08) · DAX_M3 · Londra_ORB @ GBPUSD · Apertura
Marco · BULGE · IchiCross · NIGHT_BREAK_BOX @ XAUUSD (chiarire: EA o
indicatore? un minuto di sguardo).

## RESTANO IN FORWARD sul piccolo (la squadra + il vivaio)

| EA | Grafico | Ruolo |
|---|---|---|
| DAX Apertura EU | D30EUR M5 | squadra (config 2% storica: termine di paragone del 100k) |
| Dow Apertura US | U30USD M5 | squadra |
| MaxMinNotte DAX Short | D30EUR | squadra |
| SupertrendReversal | 225JPY H2 | squadra (Nikkei) |
| ORB_Ottimizzato | U30USD M5 | squadra (lab) |
| EMA200_Ottimizzato | XAUUSD | squadra (validato, in squadra dal 01/08) |
| SupRev_NAS_H1_Ottimizzato | NASUSD H1 | squadra |
| SuperWave_DOW_H1_Ottimizzato | U30USD H1 | squadra |
| **MaxMinNotte (MAXMIN ORO, 770402)** | **XAUUSD** | **VIVAIO -- deployato stasera, NON toccare** |
| ABTG_TradeExporter | NZDCAD H1 | servizio |
| Guardian? | -- | (solo sul 100k) |

Dubbi da un minuto di sguardo (decidere al momento con la regola "o si
misura o si spegne"): SUPERWAVE EA 1/2/3 su D30EUR (istanze multiple,
mai validate come gruppo) e SuperWave_DAX_H4_Ottimizzato.

## Dopo la pulizia
1. Salva profilo. 2. Screenshot della finestra Experts (lista completa)
   -> verifica mia campo-per-campo. 3. La pagella di domani deve mostrare
   SOLO commenti della squadra: ogni commento estraneo = sfuggito.
