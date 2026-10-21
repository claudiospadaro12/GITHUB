# R276b in PASSATA SINGOLA — criteri e attese scritti PRIMA dei numeri (21/10/2026)

Scritto prima di lanciare la riga. Non promuove niente, non tocca taglie, preset, sedie, conti.

## 0. Perche' una passata singola

R276b (T5, armo tardivo: InpSessionHour=19, InpCloseHour=21:45, un mese 2026.05.01-2026.06.01, deposito 80000) e' uscito con **zero operazioni** in tutte le gambe (IS, OOS, gemelle), per-trade vuoto. Lettura di quel giro: `report/R276_LETTURA_T3_T5_2026-10-21.md` — "NON CONFERMATO nel tester".

Quel "zero" ha DUE spiegazioni che l'ottimizzazione non distingue:
1. l'EA arma alle 19:00 ma un filtro del codice boccia ogni ingresso serale (volumi, spread, range, news, Guardian...);
2. l'EA non arma affatto, o il tester non gli da' dati/ordini la sera.

In ottimizzazione il tester NON esegue le Print dell'EA (giornale senza righe ABTG, misurato in R274 e R276). In **passata singola** (Optimization=0) le Print girano e finiscono nel giornale. Questa passata serve SOLO a leggere quel giornale.

## 1. Cosa gira

- EA `ABTG_Nasdaq_Apertura_US`, NASUSD M5, modello 4 (tick reali), 2026.05.01 -> 2026.06.01, deposito 80000 EUR, leva 100, ExecutionMode 0.
- Input: i primi valori delle righe `Inp...` di `backtest_pipeline/prove/R276b_T5_armo_tardivo_NASDAQ_NASUSD.txt` (sessione 19:00, range 35 min, flat 21:45, rischio 2%, Guardian acceso, **InpVerbose=1**). Magic 798631. Le tre stringhe (InpCorrSymbol, InpNewsFile, InpNewsCurrencies) NON sono nel file prova: restano come in R276b (non imposte).
- Sorgente EA e include al pin, SHA256 uguali a quelli del giro R276 (7F243CAC...AF744 / 3EC97115...A737): stesso motore di R276b.
- Un solo magic (niente gemelle): il determinismo e' gia' provato da R276; qui si legge il giornale.

## 2. Previsioni (probabilita', scritte ora)

| id | cosa vedremo | prob. |
|---|---|---|
| A | EA arma ogni giorno alle 19:00 ma lo scarto e' al filtro di **conferma rottura** ("rottura non confermata (ne' volumi ne' ATR...)") | 30% |
| B | scarto per **spread troppo alto** / range fuori limiti / stop sotto il floor ("saltato") | 20% |
| C | EA bloccato da **news / Guardian / "oggi ho GIA' operato" / tetto posizioni** | 10% |
| D | EA arma e piazza ordini (BUY/SELL STOP) ma i pendenti scadono/non scattano: report con 0 operazioni ma righe "STOP @" nel giornale | 15% |
| E | **almeno 1 operazione** nel report (contraddice lo zero di R276b: il giro in ottimizzazione era sbagliato) | 10% |
| F | **giornale senza righe dell'EA** nemmeno in passata singola (metodo non funziona) | 10% |
| G | altro | 5% |

## 3. Criteri di lettura (congelati ora)

- **M1 — metodo valido**: nel giornale c'e' almeno una riga `[Nasdaq Apertura US] avviato su NASUSD. Apertura server 19:00, range 35 min, flat 21:45.` e una `CONFIG IN USO`. Se no: **NON MISURATO**, nessuna conclusione sul T5 (caso F).
- **M2 — identita'**: il report .htm dice EA, simbolo NASUSD, periodo M5 2026.05.01-2026.06.01, deposito 80000. Altrimenti NON MISURATO.
- **T5 CONFERMATO nel tester** = nel per-trade/report almeno 1 posizione chiude fra le 19:35 e le 21:45 server (stesso criterio di R276b par. 1). Con 0 operazioni: **NON CONFERMATO nel tester** e la causa si legge dal conteggio dei messaggi del giornale (A-D). Un'uscita dopo le 21:45 si elenca per data. Una posizione che apre prima delle 19:05 e' anomala e si elenca.
- Il riepilogo meccanico del ps1 conta le righe per categoria e elenca i messaggi distinti con la frequenza; **la lettura e' di Claude e Claudio**, non dello script.
- Confronto con R276b: se il report ha operazioni > 0, il giro in ottimizzazione e' contraddetto e T5 va riletto da capo.

## 4. Limiti

Un mese, un anno, una sola passata. Non misura il vero riavvio del terminale ne' il Guardian reale. Il filtro volumi della sera dipende dai dati del broker nel tester. Non promuove nulla; non e' una prova sul comportamento live della sedia 770260.
