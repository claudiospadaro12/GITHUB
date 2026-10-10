# GBA (EA notturno oro di Emiliano) - R1A: replica a tick reali - lettura del 10/10/2026

Fonte: `GBA_R0_R1A.zip` (PC DESKTOP-H4D7CAJ, 10/10 10:14-10:17, pin 2f4a2a5b, EA ABTG_GoldBreakoutATR v1.10 SHA 1381E3DC). Archivio: `backtest_pipeline/risultati_archivio/GBA_R0_R1A_20261010/`. Lettore: `leggi_gba_r0.py`. Criteri S1-S7 scritti in `prove/GBA_R0_REPLICA_2026-10-09.txt` PRIMA dei numeri.

## Esito [MISURATO]
- 3 passate OK, 0 KO, qualita' storico **100% tick reali**, finestre uguali alle tranche, avvio e autotest si, compilazione 0 errori. **Il deposito 1.000.000 e' stato accettato dal tester** (era il dubbio aperto). Durata: 4 minuti in tutto (43-53 s a passata), molto sotto la stima di 9-60.
- Cella REPLICA (valori della foto di Emiliano: canale 48, EMA100, ATR14, spread max 0,05 ATR, SL/trail 2,5, tempo 48, BE a 1,0 ATR, lotto fisso 1,00), XAUUSD M1, 2026 gen-set, tre tranche:

| tranche | n | n/giorno | PF | DD equity (1 lotto, deposito fittizio) |
|---|---|---|---|---|
| T1 lug-set | 128 | 1,94 | 0,83 | 12.511 EUR |
| T2 apr-giu | 248 | 3,82 | 0,77 | 28.863 EUR |
| T3 gen-mar | 557 | 8,70 | 0,89 | 53.392 EUR |
| insieme | 933 | | **PF_V 0,855** | netto -53.819 EUR, win rate 26% |

- n e frequenza: DENTRO le attese scritte prima (60-260 / 125-500 / 350-1400).
- **Costo (S2): passa.** Mediana stop/spread 58,8x (p10 51,3); con +0,04 USD/oz a lato 49,4x; con +0,08 43,0x (34% sotto 40x). Il problema non e' il costo.
- Concentrazione: migliore operazione = 3% del profitto positivo; senza le 5 migliori netto -87.199 -> FRAGILE.
- **S4: la dichiarazione di Emiliano NON regge sul nostro feed** (PF_V 0,855 < 1,0; nessuna delle tre tranche sopra 1). Un solo regime (gen-set 2026), dichiarato.
- Ora (S6): nessuna fascia sopra la soglia corretta con segno concorde in 3 tranche a favore; USA apertura (n=381) PF_V 0,70 con lo stesso segno in 3 su 3 tranche (p=0,009, sopra la soglia 0,0083). La fascia "pausa" 12-14 (PF 2,03, n=89) e' SOSPESA per n<100.
- Lato: BUY PF_V 0,89 (n=443), SELL 0,83 (n=490).
- Il filtro di spread blocca il **95%** dei segnali liberi (16.967 su 17.908): con spread mediano 0,21-0,26 e soglia 0,05 x ATR (~0,10 USD) l'EA entra solo nei momenti di spread stretto. Questo e' il parametro piu' sensibile (e il pannello della collega mostrava 0,35).

## Da guardare (G0), non invalida le passate
- Errori dell'EA nel tester, tutti `retcode 10018 (market closed)` e tutti in T3: chiusura a tempo (102 dedup), spostamento SL (69), ordine non eseguito (8). Sono tentativi alle 21:56-21:59 server, cioe' al limite della pausa giornaliera dell'oro (22:00): l'EA continua a riprovare mentre il mercato chiude. [DERIVATO] Il mercato reale ha la stessa pausa, quindi non e' un artefatto del tester; resta da misurare quanto pesa sulle perdite grosse (max perdita a SL 5.526 contro mediana 1.112).

## Cosa NON e' stato misurato (certificato di morte, 5 caselle)
Il verdetto e' **"la replica non regge (un regime)", NON "morto"**. Mancano: casella 3 (gestione dell'uscita messa ad asse), 4 (simboli gemelli: argento, ecc.), 5 (TF cambiato). R1B (InpSpreadMaxATR 0,10 / 0,20 / 0,35 sulle stesse tre tranche, 9 passate, ~8 minuti a questo ritmo) e' il passo successivo scritto prima: una variabile sola, l'asse piu' sensibile. Nessuna griglia larga: i criteri S7 misurano la frontiera, non cercano la cella migliore.
