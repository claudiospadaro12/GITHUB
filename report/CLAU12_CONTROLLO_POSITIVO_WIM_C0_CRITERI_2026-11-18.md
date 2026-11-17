# Controllo positivo: il set di Wim (C0) passa le NOSTRE porte G1-G3 (e G4)? Criteri e previsioni scritti PRIMA dei numeri (18/11/2026)

**Natura:** misura su tester, dati FTMO, nessun ordine reale. Nessun giudizio su lotti, taglie, conti o acquisti. Richiesta di Claudio (18/11): "voglio sapere se gli EA di Wim superano G1, G2 e G3" -> "usa OPT2_ORO.set e prepara i criteri".

## 1. Perche (e cosa NON e questo test)
- Le porte G1-G6 sono state scritte per i NOSTRI disegni; gli 80 set bocciati (disegni 0-3) sono stati giudicati con quelle soglie. **Mai le abbiamo applicate a un sistema che ha davvero un vantaggio noto.** Se il set di Wim non le passa, le soglie sono sospette; se le passa, le porte distinguono e i nostri 80 "nessun candidato" sono credibili.
- **NON e una prova che Wim abbia un vantaggio futuro:** Wim ha ottimizzato i suoi parametri su 2013-2023, quindi per lui il "dentro-campione" non e indipendente. Passare G1-G3 e atteso e non dimostra nulla sul futuro; **calibra solo le nostre porte.** Il fuori-campione vero resta G4-G6.
- **Limite dichiarato (non e un test cieco):** il centro C0 e gia noto su FTMO 2015-2022 (+3.574 EUR, PF 2,69, 139 operazioni, DD 386), su 2023-24 (+1.107, PF 3,15), 2025 e 2026 (hold-out gia aperto su BCM e FTMO). Le previsioni qui sotto sono scritte con quelle informazioni gia in mano.

## 2. Cosa si misura
- **EA:** `WIM\Ultimate_Breakout_EA_WSC_V9.5.ex5` (gia nel terminale FTMO di prova), **set `OPT2_ORO.set`** letto dal PC (`C:\MT5_BCM_Opt\MQL5\Profiles\Tester\OPT2_ORO.set`), **non copiato nel repository** (e un file di Wim). Parametri di C0: ST1_MinDist_to_HL 550, ST1_Expiration_hours 480, Exit_stop 600, Exit_limit 1700 (il resto del set invariato; lo script si ferma se Risk != 0 o StartLots != 0,1).
- **Impostazioni:** FTMO di prova, XAUUSD D1, Modello 1, deposito 100.000 EUR, lotto 0,1, tester senza ordini. Netto = tester - 3,6 EUR a operazione (36 EUR/lotto, come per tutti i disegni); t sulla serie del netto per giornata di uscita.
- **12 passate:** G1 (IS 2015-01-01 -> 2020-12-31, C0); G3 (2015-17 e 2018-20, C0); G4 (OOS 2021-22 e 2023-24, C0); G2 (7 vicini di C0 sul IS 2015-2020).
- **Vicini (G2), un passo di griglia FTMO per volta dal centro** (passi della griglia 625: MinDist 350/450/550/650/750, Scadenza 96/192/288/384/480, Stop 450/600/750/900/1050, Limit 1300/1700/2100/2500/2900): MinDist 450 e 650; Scadenza 384 (480 e sul bordo, un solo vicino); Stop 450 e 750; Limit 1300 e 2100. **7 vicini.** Nota: sui dati FTMO MinDist 450 e 550 danno risultati identici in 100 coppie su 125 (parametro quasi inerte): il vicino 450 sara probabilmente un doppione del centro e fa salire artificialmente la quota "in profitto".
- **Hold-out G5 (2025-01 -> 2026-10):** gia consumato per C0 (BCM e FTMO, 16/11 e 17/11). **Non si rilancia ne si usa come porta**: resta solo informativo (FTMO: 2025 +45 EUR PF 1,22 su 22 operazioni; 2026-01/10 +150 EUR PF 1,94).
- **G6 (tick, BCM 2024-07-15 -> 2024-12-31):** non rilanciato qui. I dati V3 gia misurati sul C0 (tick/candele ~0,98-0,99 nel 2024-H2) si citano solo se ritrovo i numeri di C0 nel repository; altrimenti **G6 = "non valutata"**. Non e una porta di questo controllo.

## 3. Porte (identiche a quelle dei disegni 0-3, NESSUNA soglia ritoccata)
- **G1 (IS 2015-2020, netto):** profitto > 0, PF netto >= 1,30, operazioni >= 100, recovery >= 1,5, **t >= 3,3** (soglia alzata per il numero di set guardati; per un solo set la soglia piu giusta sarebbe 3,0: **riporto il t anche contro 3,0 solo come informazione, la porta resta 3,3**).
- **G2 (vicini, IS 2015-2020):** >= 70% dei vicini in profitto netto (con 7 vicini: **almeno 5**) e PF netto mediano dei vicini >= 0,8 x PF netto di C0.
- **G3 (meta IS):** 2015-2017 e 2018-2020 entrambe con profitto netto > 0 e PF netto >= 1,10.
- **G4 (OOS 2021-22 e 2023-24):** PF netto >= 1,20 e profitto netto > 0 in ENTRAMBE, >= 20 operazioni ciascuna, WFE (profitto netto per mese OOS / profitto netto per mese IS) >= 0,5 (in ciascuna delle due finestre).

## 4. Previsioni (scritte ora, con le informazioni gia in mano)
- G1 passa: **60%** (punto debole: ~104 operazioni attese nel solo 2015-2020 contro il minimo 100, e il t mai calcolato).
- Operazioni IS >= 100: **55%**. PF netto IS >= 1,30: **95%**. Recovery >= 1,5: **97%**. t >= 3,3 (se le operazioni bastano): **75%**.
- G2 passa: **85%**. G3 passa: **75%**. G1+G2+G3 tutte: **45%**.
- G4 passa: **65%**.
- Se G1 fallisce, e solo per il numero di operazioni (< 100): **70%**.

## 5. Come si legge l'esito (regole scritte ora)
1. **C0 passa G1-G3:** le porte distinguono un sistema che funziona; i nostri 80 set non superano barre che un sistema vero supera. Nessuna soglia da toccare.
2. **C0 fallisce su UN solo componente di G1 (es. operazioni 98 su 100):** lo riporto cosi com'e, **le soglie non si ritoccano per salvarlo**. Posso proporre in un documento separato una soglia nuova con motivazione scritta ex ante, valida **solo per i controlli futuri**; **nessuno degli 80 set gia bocciati viene ripescato** con soglie diverse (lo storico dei looks resta).
3. **C0 fallisce piu componenti, o G2/G3:** le porte sono sospette; stessa regola del punto 2 per ogni modifica.
4. **In ogni caso** l'esito non cambia il giudizio sul vantaggio futuro di Wim (vedi sezione 1).
5. Il risultato va in questo file (sezione 6) con la tabella completa, anche se brutto.

## 6. Risultato
*(da compilare dopo il lancio; nessun numero ancora)*
