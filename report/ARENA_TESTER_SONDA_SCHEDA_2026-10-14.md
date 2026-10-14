# 🧪 ARENA NEL NOSTRO STRATEGY TESTER — scheda della PRIMA SONDA (14/10/2026)

> **Stato: BOZZA v2, in cancello.** Lo strato 2 (`controllo-preventivo`, 14/10) ha trovato e corretto tre difetti (classi 1437, 1438, 1439): lo script e' passato a **v2** (impronta del `.ex5` ricontrollata dopo ogni passata), quindi la riga e' tornata col **pin di zeri** (si rifiuta di partire) finche' lo script v2 non e' committato e ripinnato; il lettore sospende i verdetti finche' `PIN_PASSATI` non contiene quel pin. Niente di questo e' partito.
> Richiesta di Claudio (14/10): _«provare l'Arena vera nel nostro Strategy Tester... Procedi»_.

## 1. Cosa misura, e perché
- **L'EA**: «Arena Nexus Grid Smart XAU MT5» **1.20**, prodotto di terzi del MQL5 Market, **scatola nera** (nessun sorgente, mai decompilato). Natura letta sul demo `50503392`: griglia + scala di lotti + recupero a cesto, **senza SL iniziale** (`report/MARKET_SCHEDA_FINLABX_CF_DZR_2026-10-13.md`, `report/MARKET_MOTORE_FINLABX_RICOSTRUZIONE_2026-10-13.md`).
- **La domanda**: il demo ha mostrato due giorni in positivo (+487,31 il 13/10, +817,57 il 14/10 a lotto 0,01 su ~4.900 EUR **[LETTO nel conto]**) e **nessuna giornata contraria**; un demo **senza slippage** (731/731 ingressi a prezzo esatto, `report/MARKET_CLASSIFICA_2026-10-14.md` §5). Un utente del Market scrive che il suo backtest ha fatto **+31.000 USD su 1.000 e poi ha perso quasi tutto il 28/09/2026** (`docs/MARKET_EA_CENSIMENTO.md`) — **[DICHIARATO DA TERZI, non verificato]**. La sonda misura nel tester a tick reali **la CODA che il demo non ha ancora mostrato**.
- **Due passate, due lotti separati** (XAUUSD M1, Modello 4 = tick reali, deposito 5.000 EUR, leva 1:500, ExecutionMode=0, lotto base 0,01):
  - **SONDA1 (fumo)** `2026.09.28 → 2026.09.29`: il solo 28/09 (il tester esclude la data «a», misurato in GBA R1A). Timeout 20 min.
  - **SONDA2** `2026.07.01 → 2026.09.30`: tre mesi, **stessa finestra della tranche T1 di GBA** (sullo stesso PC: 25.648.545 tick, 88.416 barre, 100% tick reali **[MISURATO 10/10 e 14/10]**: è l'ancora del feed). Timeout 240 min. Parte **solo se** la SONDA1 ha un report leggibile con ≥ 1 operazione, input confermati dal report, nessun timeout **e** stima di durata (≈ 65 × tempo di test della SONDA1) ≤ 240 min.

## 2. File (worktree, NON committati) e SHA256
| file | SHA256 |
|---|---|
| `backtest_pipeline/righe/ARENA_TESTER_SONDA.ps1` (marcatore `MARCATORE_ARENA_TESTER_SONDA_v2`) | `38103274C94220BC098AD1675AEF8036875C02BF3105B8D0E75687602C2B5C76` |
| `backtest_pipeline/righe/RIGA_LANCIA_ARENA_TESTER_SONDA.txt` (BOZZA v2, pin di zeri: lo SHA cambia quando il pin vero entra) | `33E9F2B1F1205E0816E6CA563D3688ACCAC872618AA2CF7C70E992EDCD833A44` |
| `backtest_pipeline/leggi_arena_tester.py` (lettore, sola lettura; `PIN_PASSATI` da riempire col pin della riga v2) | vedi il referto del cancello (cambia quando entra il pin) |

## 3. ✋ I passi a mano di Claudio (PRIMA della riga)
**Bersaglio: 🪟 terminale MT5 `50503392` nella cartella `C:\Program Files\BCM Markets MT5 Terminal` sul PC di backtest `DESKTOP-H4D7CAJ`. NON il VPS, NON il reale `10105439`, NON `C:\MT5_Backtest`, NON `C:\FundedNext_Manuale`.** Prima di toccarlo, la finestra si riconosce da una riga stampata, non a occhio (🖥️ PowerShell sul PC di backtest): `Get-Process terminal64 | select Id, MainWindowTitle, Path`.
1. Aprire MT5 da `C:\Program Files\BCM Markets MT5 Terminal` (conto demo `50503392` del PC di backtest).
2. Scheda **Market → Acquistati** (o la pagina del prodotto) → **Installa** l'Arena Nexus Grid Smart XAU MT5 **[NON VERIFICATO nei dettagli del menu]**. ⚠️ Installare su un altro PC **consuma un'attivazione** del prodotto (quante ne restano: **[NON VERIFICATO]**). Se la pagina offre la versione **Demo** gratuita (funziona solo nel tester), per questa sonda basta quella e non consuma attivazioni **[NON VERIFICATO]** — scelta di Claudio.
3. **NON attaccarlo a nessun grafico** (la riga si ferma se trova un EA sui grafici salvati: il 14/08 da questa macchina sono partiti ordini veri).
4. **Chiudere MT5**, poi lanciare la riga (finestra PowerShell sul PC di backtest).

## 4. Attese scritte PRIMA dei numeri (le stesse del docstring del lettore)
- **(A)** La SONDA1 apre ≥ 1 operazione. Se zero: l'EA nel tester non opera o lo rifiuta (licenza, DLL, simbolo, versione demo) → **MISURA MANCANTE**, non errore.
- **(B)** Mediana del netto per giorno (prima di un eventuale stop out) **≥ 100 EUR** a 0,01 con 5.000 EUR → stesso ordine del demo; **< 100** → demo ottimista. Si giudica **sulla SONDA2**. Alternativa: il tester come il demo **non ha slippage**, quindi un tester sotto soglia NON si spiega con lo slippage: restano **feed/spread** e **regime** (due giorni di ottobre contro un trimestre); questa sonda non li separa.
- **(C)** **CADUTA = DD di equità ≥ 10% del deposito (≥ 500 EUR) dentro il 28/09** (data server BCM). SONDA1: DD di equità del report (la finestra è il giorno). SONDA2: perdita d'equità **stimata** dentro il giorno (limite inferiore). Alternativa col numero **[INFERITO]**: con lotto cresciuto col saldo (≈ 32× il nostro), la stessa traiettoria a 0,01 vale ≈ 31.000/32 ≈ 1.000 USD ≈ 850 EUR ≈ **17%** → sopra soglia. **Nessuna caduta in SONDA1 NON smentisce l'utente** (vedi §5, punti 3-4).

## 5. Contro-esempi (costruiti per rompere la misura) e come sono coperti
1. **L'EA rifiuta il tester** (licenza, DLL, versione demo, simbolo): report assente o zero operazioni → KO dichiarato come misura mancante; SONDA2 non parte; il giornale (estratto, righe di errore) va nello zip. Provato a secco (rami `zero` e `noreport`).
2. **Report vuoto / troncato / di due EA / commenti diversi**: il lettore li riconosce (autotest 3, 4, 4b, 5, 6) e non stampa misure sui deal se il report non riconcilia (deposito + deal = ultimo saldo = netto: autotest 10).
3. **Il cesto del venerdì**: la SONDA1 parte **a conto vuoto il lunedì**; con `InpFridayGapProtection=false` un cesto aperto venerdì 25/09 e il gap del weekend **non ci sono**. Li vede solo la SONDA2. (Variante possibile, NON fatta perché fuori dal mandato: SONDA1 dal 25/09.)
4. **L'orologio** (classe 1436): il «28/09» dell'utente è nell'orologio del **suo** broker **[NON NOTO]**; BCM è UTC+1 fisso. Il lettore stampa anche 27/09 e 29/09.
5. **Storia tick mancante a settembre 2026**: la finestra T1 è già stata girata a tick reali su questo PC (100%, 25,6 M tick). Comunque: qualità ≠ 100% o «ticks data begins» dopo l'inizio = KO; il lettore confronta tick e barre della SONDA2 con l'ancora.
6. **Spesa di tempo**: la durata dell'Arena nel tester è **[NON MISURATA]**. Guardia: la SONDA2 non parte se la stima supera il timeout (ramo `stima` provato a secco). Caso peggiore della riga: ~285 min.
7. **Due `.ex5` Arena / nessuno / nome con spazi**: zero o due = stop prima del tester (provati a secco, anche con maiuscole diverse e con un nostro `Arena_*.ex5` fuori da Market, che NON conta); il nome con spazi va nel `.ini` così com'è (**[NON VERIFICATO]** che il tester lo accetti: se no, SONDA1 senza report).
8. **Enum**: `InpTradeMode` e `InpGoldPulseTheme` non si impongono; il tester usa il default **o l'ultimo valore salvato nel tester [NON VERIFICATO quale]**: il valore usato è letto dal report e dal giornale.
9. **Stop out**: con 5.000 EUR è **la coda cercata**, non un KO (deviazione D4, classe 1425 letta). Dopo lo stop out il conto è morto: il lettore lo dice e, se è prima del 28/09, dichiara C **NON MISURATO** dalla SONDA2 (autotest 9).
10. **Accoppiamento in→out**: il report del tester non ha l'identificativo di posizione; il lettore lo ricostruisce (grappoli dello stesso secondo, T/P e S/L dell'ordine), conta gli ambigui e oltre il 5% stampa i cesti come APPROSSIMATI (autotest 7); netto per giorno e lotti vivi non ne dipendono.

## 6. Cosa NON si può concludere
Un trimestre = un regime; tester **senza slippage né latenza**; feed BCM (non lo `XAUUSD.sd` dell'utente); enum non scelti da noi; **nessun merito** (n per regime) — e la natura (griglia + scala di lotti + recupero senza SL iniziale) resta **fuori dall'imbuto prop** qualunque cosa esca. Verdetto massimo: **NON ANCORA MISURATO**.

## 7. La decisione dopo (SOLO dopo aver letto la sonda)
Sonda con **lotto 0,03 / 0,05 / 0,10** e **finestra più lunga** (la coda scala col lotto; più regimi); se la stima di durata supera il timeout, **tranche mensili**; eventuale contro-prova con `ExecutionMode` a ritardo casuale come proxy dello slippage. Ogni passo nuovo con attese scritte prima e il suo cancello.

## 8. Controlli fatti dallo Sviluppatore (strato 2 ancora da fare)
- `controlla_riga.py --oggetto riga`: unico BLOCCANTE il **pin di zeri** (atteso); con un pin vero (copia temporanea) **nessun difetto meccanico**. `--ps1`: nessun difetto meccanico.
- Parser pwsh: 0 errori (ps1 e riga). Binder statico su tutti i comandi (classe 586/1385): nessun problema vero (solo i falsi positivi noti `-File`/`-Encoding`/`-NoNewline`), nessun `-ForegroundColor` doppio. ASCII puro.
- Prova a secco in pwsh (macchina finta `DESKTOP-H4D7CAJ`, terminale finto che scrive report e giornale nel formato vero): rami **nessun Market, Market vuoto, solo altri .ex5, due .ex5, un .ex5 (rc 0, zip completo), zero operazioni, report assente, timeout (KO, nessuna chiusura forzata, PID stampato), stima oltre il timeout, EA su un grafico salvato, blocco GBA occupato, blocco di un altro driver occupato, pin di zeri**.
- Lettore: autotest 28/28 verdi; letto un report VERO del tester (GBA R1A_03: 557 operazioni, riconciliazione esatta, commissione 3,42 EUR/lotto a giro); 94.000 deal / 78 MB in ~30 s.
- **NON verificato (il tester gira solo sul PC di backtest)**: che il tester accetti il `.ex5` del Market col percorso `Market\<nome con spazi>.ex5`; il formato delle righe input nel giornale; che l'Arena operi nel tester; la sua velocità; il valore degli enum; il nome esatto del file nel Market.
