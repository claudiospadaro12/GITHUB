# Quadro unico degli EA testati, famiglie chiuse e richiesta di revisione (18/11/2026)

**Natura:** riepilogo di misure GIA FATTE (tester/simulatore). Nessun giudizio su lotti, taglie, conti, prop o acquisti: lo decide Claudio. Conti reali 10105439, FTMO e VPS non toccati. Dove un numero non e qui sotto, rimando al file; **nessun numero e stato aggiunto o arrotondato oltre le fonti**.

## 1. EA testati fuori campione (fonte: `CANCELLO_CHIUSURA_2026-11-09.md`, `RISULTATI_FOREX_OOS_2026-11-08.md`, `CONFRONTO_TRIO_ORO_FOREX_4K_2026-11-05.md`)
| EA | Mercato | Verdetto | Misure principali | Limite piu importante |
|---|---|---|---|---|
| Goldbot One (L0 Prop, L3 Combo) | oro | TESTATO BENE | 4 anni a 80k + 2005-2012 (8/8 positivi), tick 2025 -6%, venerdi -9/-10% | solo oro, un percorso per anno, margine/leva oro FTMO non verificati |
| Gold Trade Pro (Combo) | oro | CON LIMITI | 5 livelli; Prop DD 11,7% nel 2020 non regge; Combo <6%; 2005-2012 8/8 | chiusura venerdi costa -31% nel 2020 |
| Gold Reaper (L0, L3) | oro | CON LIMITI | tick -8%; Randomization 50 = percorso casuale (scarto 6-46%) | rumore; L0 da solo non regge nel 2013 |
| Gold Phantom (L0, L1, L3) | oro | CON LIMITI | tick -3%; scala x2,11-2,17 a 160k | rumore; 2013 anno critico |
| **Stability Pro low risk** | forex | **TESTATO BENE** | 12 anni: DD max 18,6%, 12/12 positivi; tick -14%; costi FTMO 91% | giro D (80k) non fatto, flottante non simulato |
| Daytrade Pro Max9 / Max20 | forex | CON LIMITI | 12/12 positivi; DD max 9,1% / 20,4%; costi 96% | sensibile ai tick (2025 peggior anno) |
| Luna AI (4DD) | forex | CON LIMITI | DD 22,7%, 10/12 positivi; saldo min 3.174 (a 4k) | tick -83%; costi FTMO zona grigia; orari GMT non verificati |
| Apex Trader (Conservative; Ultra) | forex, **griglia** | CON LIMITI | DD 27,1% / 32,9%; 11/12 e 10/12; giorni a -23% | griglia; Cons e Ultra correlati 0,97 (stessa strategia) |

**Correlazione giornaliera con il trio oro** (2013/2020/2025): Apex da 0,00 a +0,08; Daytrade Pro +0,09 a +0,19; Luna -0,03 a -0,01; Stability -0,06 a +0,08 (Stability con Apex 0,25). Giorni di perdita in comune: Daytrade Pro 24-31 osservati contro 14-16 attesi. **Causa nota (`CONFRONTO_TRIO_ORO_FOREX_4K_2026-11-05.md` sez. 4): Daytrade Pro opera anche XAUUSD; senza la gamba oro la correlazione col trio e 0,00-0,05, la sola gamba oro e a +0,48-+0,66; nel 2025 tutto l'utile di Daytrade Pro viene dall'oro (senza oro Max9 circa -22, Max50 circa -298).** Quindi Daytrade Pro NON e un diversificatore forex puro: la parte che lo diversifica dall'oro non ha dato utile nel 2025. Correlazione fra i set oro tra loro: non riportata in questo quadro.

## 2. Famiglie chiuse senza candidati
| Famiglia | Misura | Esito |
|---|---|---|
| Breakout D1 oro (nostri disegni 0-3, 80 set) | G1-G4 | nessun candidato; il set di Wim (OPT2) passa G2-G4, non G1 (t 2,65, 95 operazioni) |
| 64 vicini di Wim (motore background) | IS+OOS1+OOS2 | 64/64 passano: plateau, quasi-copie, filtro non selettivo |
| Fade del falso breakout oro | 24 set, 2015-2017 | 0 passano, PF netto 0,61-0,89 |
| Orari fissi oro | 4 fasce | nessuna passa |
| Moduli lezioni Nasdaq M1 (stop pre-apertura) e M3 (breakout con conferma) | 20 set, 2015-2017 | 0 passano; lordo ~0 |
| Breakout D1 Nasdaq (stesso tipo, nostro motore) | 8 set, 2015-2017 | 0 passano (PF 0,86-1,20, t <= 0,8) |
| Bitcoin Reaper / Scalp Pro | 56 passate FTMO 2018-2025 | nessun set passa (commissioni) |
| Indicement / ORB Master (indici) | 21 mesi 2025-26 BCM | Indicement PF 0,95-1,04; ORB Master 7/7 in perdita; **nessun fuori campione**: assenza di prova |
Contatore dei looks di oggi: fade 24, Nasdaq M1/M3 20, breakout Nasdaq 8, 64 vicini; ogni famiglia con porte e previsioni scritte prima dei numeri.

## 3. Cosa distingue gli EA che reggono (nota `CLAU12_COSA_RENDE_DIVERSO_WIM_2026-11-18.md`)
Orizzonte di giorni o stop larghi, payoff asimmetrico, costo piccolo rispetto allo stop; i tentativi intraday a bassa asimmetria perdono per costi. Il vantaggio dell'oro D1 di Wim e legato alla tendenza 2015-2024 (2025-26: +45 e +150 EUR su FTMO).

## 4. Rischi aperti (da dire a Gemini)
- **Tutti gli EA sono dello stesso autore/motore (famiglia WSC):** il rischio di fornitore e di motore comune non e misurato; non sappiamo se FTMO li tratti come la stessa strategia (domanda del 14/11 senza risposta).
- Test solo su barre da 1 minuto (tick reali solo 2025), un percorso per anno, flottante non ricostruito, Guardian simulato solo sul realizzato; regole FTMO (leva oro, limiti di lotto, 2.000 richieste/giorno, pendenti nel weekend, copy trading) non verificate.
- Apex e a griglia; Luna e Daytrade Pro sensibili ai tick; i dati `_EXT` degli indici hanno orologio verificato solo per 2015, 2020, 2025-26.

## 5. Richiesta per la revisione Gemini
"Leggi questo quadro e i file citati. Per ogni EA e per ogni famiglia chiusa segnala: (a) conclusioni non supportate dai numeri; (b) rischio di sovra-adattamento o di selezione dei periodi; (c) cosa misureresti in piu e con quale criterio scritto prima; (d) correlazioni e code di perdita condivise da stimare. **Non dare consigli su lotti, taglie, prop da scegliere o acquisti.**"
