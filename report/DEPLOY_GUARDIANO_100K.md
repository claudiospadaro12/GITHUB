# DEPLOY -- DEMO 100K COL GUARDIANO (dry-run FTMO 2-Step)

## ✅ COMPLETATO il 09/08/2026 alle 20:22 -- IL DRY-RUN E' IN ACQUA

- Conto: **50504263** (BCM demo, 100.000 EUR, hedge) su istanza separata
  "BCM Markets MT5 Terminal **-V3**" del VPS; il vecchio 50503392 continua
  il forward sull'istanza originale, intoccato.
- Guardian su AUDCAD H1 col preset FTMO (verificato 11/11); pannello
  "Stato: OK - operativo", limiti 5%/10%, CHIUDI+BLOCCA.
- 5 EA verificati campo-per-campo da screenshot (legge rispettata; il
  Nikkei ha DI NUOVO salvato il deploy: lo script aveva pescato un
  grafico STREV sbagliato -- magic 770925, TF H1, mult 3.0, TP 2.5 --
  corretto a mano in 2H/3.5/2.0/770901):
  Guardian 779001 · DAX 770101 (0.65) · Dow 770202 (0.65) ·
  MaxMin 770411 (0.65) · Nikkei 770901 (0.65) · ORB 770611 (**0.3**).
- Algo Trading VERDE, profilo "SQUADRA 100K" salvato.
- .set generati con `estrai_set_forward.ps1` (v3) dai grafici del
  vecchio MT5, col rischio riscritto dallo script.
- Primi appuntamenti (ora server): box MaxMin 23:00 di stasera; DAX
  08:00; Dow/ORB 14:30.
- 22:08 -- settimo grafico: ABTG_TradeExporter su EURUSD H1 con
  InpFile=ABTG_Trades_100k.csv (file SEPARATO dal vecchio conto nella
  Common condivisa -- quinto errore di deploy beccato dallo screenshot:
  il primo tentativo aveva il nome file di default). Da domani la
  pagella puo' leggere entrambi i conti.

Il resto del documento e' la scaletta originale, conservata come
riferimento.


Deciso da Claudio il 09/08/2026 sera, dopo il referto di portafoglio
(`REFERTO_PORTAFOGLIO_R16.md`). Domenica sera = momento perfetto:
mercati chiusi, lunedi' si parte puliti.

## Le regole della missione

- E' un DRY-RUN: replica FTMO 100k (daily -5%, totale -10% statico,
  target +10k) su demo. Zero soldi veri. Il Guardiano ENFORCE (chiude
  e blocca) come farebbe la prop.
- **Il vecchio demo 50503392 NON si tocca**: il forward in corso
  continua identico. Il 100k e' una SECONDA istanza MT5.
- **Rischio per trade: 0,65%** (non 1%!) -- dal Monte Carlo a 5 serie:
  a 1% il p95 sfora il 10% FTMO; a 0,65% p95 ~8,3%, p99 ~10,4%.
  **ORB a 0,3%**: e' il candidato piu' giovane (doppio asterisco R15,
  +41k dei +73,8k del backtest sono suoi: mezzo peso finche' non ha
  30 trade forward).
- Tutti gli altri parametri = STESSI del forward attuale (gia'
  verificati da screenshot). Cambia SOLO il rischio.
- **Legge dello screenshot**: nessun grafico e' "fatto" senza verifica
  campo-per-campo (3 deploy, 3 errori beccati).

## FASE 0 -- Nuovo conto demo (dal VPS o dal PC, poi si logga sul VPS)

1. In MT5 (va bene quello vecchio per la richiesta): File -> Apri un
   conto -> BCM Markets -> **Demo** -> deposito **100.000**, valuta
   **EUR**, leva 1:100, tipo **HEDGING**.
2. ANNOTARE numero conto, password e server (stesso server del vecchio:
   il fuso resta ora italiana -1).
3. NON restare loggati col nuovo conto nel vecchio MT5: il vecchio
   deve tornare subito su 50503392 (il forward vive li').

## FASE 1 -- Seconda istanza MT5 sul VPS

1. Scaricare l'installer MT5 di BCM sul VPS.
2. Installare in una cartella DIVERSA: nella finestra di installazione
   -> Impostazioni -> percorso `C:\Program Files\BCM MT5 PROP`
   (nome cartella diverso = istanza separata con la sua cartella dati).
3. Avviare la nuova istanza -> login col conto NUOVO da 100k.
4. Verifica: in basso a destra il numero conto nuovo; il vecchio MT5
   intanto e' ancora aperto su 50503392. Due terminali, due conti.

## FASE 2 -- Portare gli EA nella nuova istanza

1. Nel VECCHIO MT5: File -> Apri cartella dati -> si apre Explorer.
   Nel NUOVO MT5: File -> Apri cartella dati -> secondo Explorer.
2. Copiare da vecchia a nuova: `MQL5\Experts\` -> tutti i file
   `ABTG_*.ex5` della squadra: Guardian, DAX_Apertura_EU,
   Dow_Apertura_US, MaxMinNotte_DAX_Short_Ottimizzato,
   SupertrendReversal, ORB_Ottimizzato.
   (Se ABTG_Guardian.ex5 non c'e': prima, nel vecchio ambiente,
   `.\aggiorna_ea.ps1 Guardian` e riavvio del vecchio MT5.)
3. Preset del Guardiano nella nuova cartella dati, `MQL5\Presets\`:
   scaricarlo sul Desktop con
   `irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/mql5/Presets/ABTG_Guardian_FTMO_2Step.set" -OutFile "$env:USERPROFILE\Desktop\ABTG_Guardian_FTMO_2Step.set"`
   e trascinarlo dentro.
4. Nel nuovo MT5: Navigatore -> tasto destro su Consulenti Esperti ->
   Aggiorna. Devono comparire tutti e 6.

## FASE 3 -- IL GUARDIANO PER PRIMO (mai il contrario)

Grafico EURUSD H1 (uno qualsiasi: governa tutto il conto), attaccare
`ABTG_Guardian`, caricare il preset `ABTG_Guardian_FTMO_2Step`,
verificare campo per campo:

| Campo | Valore |
|---|---|
| InpStartBalance | **100000** |
| InpDailyLossPct | 5.0 |
| InpTotalDDPct | 10.0 |
| InpDDMode | 0 (statico) |
| InpDailyResetHour | 0 |
| InpAction | **0 (chiude+blocca)** |
| InpCloseAllMagics | true |
| InpShowPanel | true |
| InpMagic | 779001 |
| InpComment | GUARDIAN FTMO 2STEP |
| InpVerbose | true |

SCREENSHOT -> verifica -> solo dopo si prosegue. Il pannello deve
mostrare: saldo 100.000, pavimento giorno 95.000, pavimento totale
90.000.

## FASE 4 -- I 5 EA, un grafico alla volta (screenshot dopo OGNUNO)

Parametri = quelli del forward attuale (verificati ai deploy 06-09/08);
qui sotto SOLO cio' che va controllato o cambia (il rischio!).

| # | EA | Grafico | Rischio | Controlli chiave |
|---|---|---|---|---|
| 1 | ABTG_DAX_Apertura_EU | D30EUR M5 | **0.65** | retest 35/500/200, solo long, TrailStartR 0, SessionHour **8** |
| 2 | ABTG_Dow_Apertura_US | U30USD M5 | **0.65** | retest 35/1000/400, solo long, TP1 1.0/50%, BE, trail M5, SessionHour **14:30** |
| 3 | ABTG_MaxMinNotte_DAX_Short_Ottimizzato | D30EUR M15 | **0.65** | default EA (box 23-4:59, piazza 7:59, solo short, magic 770411) |
| 4 | ABTG_SupertrendReversal | 225JPY H2 | **0.65** | InpTF 2H, long+short, TP_RR 2.0, magic 770901 |
| 5 | ABTG_ORB_Ottimizzato | U30USD M5 | **0.3** | range 14:30-14:45, solo long, SL 50% range, TP 1.5x, trailing EMA9, EMA200, tetto 0.8%, chiusura 21:00, magic 770611 |

Nota magic: sono gli stessi del vecchio demo -- conti DIVERSI, nessuna
collisione possibile. I commenti sugli ordini ci sono gia' in tutti
("DAX Apertura EU", "Dow Apertura US", "MAXMIN DAX SHORT", "STREV",
"ORB OTT"): si distinguono a colpo d'occhio nello storico.

## FASE 5 -- Accensione e prima notte

1. AutoTrading ON (pulsante verde) SOLO nella nuova istanza dopo che
   tutti gli screenshot sono verificati.
2. Controllo orologio: ora del grafico = ora italiana -1.
3. Primo banco di prova: MaxMinNotte arma il box stanotte alle 23:00
   server; DAX apre alle 8:00 server; Dow/ORB alle 14:30 server.
4. La pagella delle 23:00 continua sul vecchio conto; il nuovo conto
   entra in osservazione (pagella dedicata da decidere).

## Cosa NON fare

- Non toccare i parametri del vecchio demo per "allinearli": due
  esperimenti separati, ognuno col suo rischio.
- Non alzare il rischio se i primi giorni vanno bene: la taratura
  viene dal p99, non dall'umore.
- Non spegnere il Guardiano "per vedere": se scatta, ha ragione lui.
