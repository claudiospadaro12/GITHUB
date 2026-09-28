# Nota per Gemini -- Londra ORB e Nightly sei simboli: cosa e' misurato, cosa no, e cosa chiediamo (28/09/2026)

Da Claudio Spadaro (progetto ABTG, challenge FTMO in corso). Allegato: `LETTURA_ROUND_CORTI_A_2026-09-28.pdf`,
la lettura del round A (R250 / R258 / R259) fatta dal lettore automatico con criteri congelati PRIMA dei numeri.
Qui il riassunto e la domanda. Regole di casa in fondo: valgono anche per le proposte.

## 1. Cosa e' stato misurato oggi

**R258 -- Londra ORB (`ABTG_Londra_ORB`, GBPUSD ed EURUSD, tick reali, walk-forward)**
Motore: canale 06:00-07:00 server, ingresso al breakout con buffer, tre ore di sessione provate (7, 8, 9),
soglia minima del range (`InpMinRangePips`) come asse, blocchi gemelli/buffer/inizio range, stagioni (in fase
con l'ora legale), screening OHLC 2008-2024. Deposito 10000, IS e OOS separati.

| simbolo | ora | Trades OOS | PF IS / PF OOS | DD fisso IS / OOS | stop mediano | costo (40x spread+comm.) |
|---|---|---|---|---|---|---|
| GBPUSD | 7 | 306 | 0,70 / 0,74 | 34,6% / 54,9% | 3-8 pip | ESCLUSO PER COSTO |
| GBPUSD | 8 | 296 | 1,05 / 0,97 | 19,9% / 38,2% | 8-13 pip | escluso (13,3x) |
| GBPUSD | 9 | 294 | 0,80 / 0,82 | 29,7% / 32,3% | 13-18 pip | FRAGILE |
| EURUSD | 7 | 306 | 0,65 / 0,87 | 35,1% / 37,0% | 3-8 pip | ESCLUSO PER COSTO |
| EURUSD | 8 | 296 | 1,18 / 0,91 | 15,7% / 30,0% | 8-13 pip | escluso (13,3x) |
| EURUSD | 9 | 293 | 0,83 / 0,70 | 26,4% / 53,0% | 8-13 pip | escluso (13,3x) |

Alzando la soglia del range il PF sale ma il campione crolla sotto 100 operazioni (a 20 pip: 24-86 trade
OOS): non e' leggibile. L'ora della sessione non decide (differenze entro il rumore, delta 0,33 di PF a n~300).
Il tester addebita la commissione (verificato: 992 deal, -2.560 EUR). Un'ipotesi nata da un PDF esterno
("Londra apre alle 7 server") NON e' confermata dai numeri.

**R259 -- Nightly (`ABTG_Nightly`, fade notturno) su AUDUSD, USDJPY, XAUUSD, XAGUSD, DAX, Dow, screening OHLC**
Tutti e sei fuori per RISCHIO alla gestione di default (Equity DD 7-62% a 1%), PF OOS sotto 1 tranne XAUUSD 0,996
(n 140). XAGUSD zero operazioni in IS (problema di storico/motore, non "senza edge"). L'ipotesi del PDF ("sui
mercati attivi di notte il fade peggiora") non e' contraddetta: AUDUSD 0,95 e USDJPY 0,67 stanno sotto i simboli
"dormienti" gia' misurati (0,59-1,05).

**R250 -- orologio del candidato Nasdaq (770201)**: due celle su sei nulle per un cancello formale; con la sola
finestra A il verdetto e' "orologio" (non "stagione") ma sotto 150 operazioni: indizio, non prova.

## 2. Cosa NON e' misurato (e quindi il candidato NON e' archiviato come morto)
Per la regola di casa un candidato si dichiara MORTO solo con cinque caselle piene: PF, n+DD, **gestione
dell'uscita messa ad asse**, simboli gemelli, TF cambiato. Per Londra ORB e Nightly manca la terza: l'uscita
(stop/target/trailing/parziali/timestop) non e' mai stata messa ad asse su questi motori. Quindi il verdetto
di oggi e' "NON ANCORA MISURATO", con i numeri sopra nel registro.

## 3. La domanda per Gemini
Sui numeri sopra, **quali meccanismi di USCITA o di FILTRO** varrebbe la pena misurare per primi, e perche'?
Esempi che accettiamo: timestop, target a multipli del range, trailing sul canale, filtro di volatilita' (ATR,
range minimo in rapporto allo spread), filtro notizie, compressione asiatica prima di Londra. Per ogni proposta:
il meccanismo, l'ipotesi che lo giustifica, e cosa deve uscire dal test perche' valga.

## 4. Regole di casa (vincolanti anche per le proposte)
- **Niente parametri nuovi dello stesso motore**: su un motore che fa 0,70-0,97 in OOS su ~300 operazioni una
  griglia piu' fitta trova solo picchi di rumore. Si allarga su MECCANISMI, uscite, simboli, TF; non sui parametri.
- Merito: PF >= 1,10 in IS e OOS, n >= 150 posizioni, cella al CENTRO dell'altopiano (mai il picco).
- Costo: stop >= 40 x (spread + commissione). Su GBPUSD/EURUSD la frontiera e' ~11-13 pip: uno stop piu'
  stretto e' escluso a prescindere dal PF.
- Rischio: DD alla taglia di volo dentro il muro FTMO (10% totale, 5% giornaliero) con margine.
- Ogni cambiamento si paga con una prova fuori campione (walk-forward a tick reali), e la taglia la decide Claudio.
