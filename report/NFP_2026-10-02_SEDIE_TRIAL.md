# NFP di venerdi' 02/10/2026 e le sedie della Free Trial FTMO: nota decisionale

Scritta la notte del 01/02-10-2026, a mandato ("pensateci voi stanotte"). **Sola lettura**: nessun preset, EA, conto, terminale o VPS toccato, nessuna riga di lancio. **Non decide niente**: rischio, taglie e sedie sono di Claudio. Ogni proposta operativa qui sotto e' una *proposta da passare dal cancello*, non un'istruzione.
Etichette: [MISURATO] letto in un file del repo (con fonte) · [DERIVATO] calcolo mio da numeri scritti · [INFERITO] dedotto, dico da cosa · [NON MISURATO] il dato non c'e' · [DA VERIFICARE A VISTA] serve un occhio su MT5.
Ore: **server FTMO = ora italiana + 1** (misurato sul trial il 30/09 notte, 00:12 contro 23:12, `HANDOFF.md` blocco 01/10; regola in `CLAUDE.md`). Il 02/10 nessun cambio d'ora (Europa 25/10, USA 01/11): **IT = UTC+2, server FTMO = UTC+3**.

✏️ **Cancello indipendente (notte 01/02-10): PASS dopo sei correzioni chirurgiche, tutte gia' dentro il testo qui sotto.** (1) sez. 0: il rinvio del dato ha un meccanismo concreto (shutdown federale all'inizio dell'anno fiscale USA, 01/10) e va guardato; (2) sez. 0: la sonda `CODA_01` di stanotte **non decide** se 770101 e 771531 ci sono (rilegge il profilo salvato), decide la faccina; (3) sez. 0 e 6: prima del muro FTMO del 10% scattano **due soglie nostre** (allarme della regola 4 dei 14 giorni a 148.000, pavimento del Guardian a 145.120 con 30 giorni di pausa): ora sono in tabella; (4) sez. 6: "meno di uno stop" era contato con lo stop di oggi, il giorno dopo lo stop e' piu' piccolo; (5) sez. 5.2: al NFP del 04/09 **una** posizione dello stesso motore SuperWave (Dow **H2**, non sul trial) era aperta e ha chiuso a stop; (6) sez. 3.3: la guardia di `news-export.yml` descritta come nel commento del workflow, non come nel codice. Aggiunte senza cambiare nessuna conclusione: il riquadro "in sei righe", la riga di coerenza con la D7 della scheda Paolo, l'allarme 148.000 nella lettura dell'opzione (a). Nessuna opzione e' stata spinta o tolta. Classi 1057-1058 in `CHECKLIST_RIGA_DI_LANCIO.md`.

---

## 0. LA PAGINA DELLE 07:00

> **In sei righe** (il dettaglio e' sotto):
> 1. NFP **venerdi' 02/10, 14:30 italiane = 15:30 server FTMO** (12:30 UTC). Prima cosa: che esca davvero (shutdown USA possibile dal 01/10: se salta, giornata normale).
> 2. **Esposte al rilascio**: DAX 770105 e 770411 (piu' 770101 se e' attaccata), Dow H1 770511 (piu' 771531 se e' attaccata), Bulge (3 cross col dollaro). **Non esposte**: Dow 770202, Nasdaq 770260, ORB 770621, che partono 60' dopo.
> 3. **A vista su `1514806751` (`C:\FTMO`)**: 770101 e 771531 ci sono? Il profilo salvato dice no, il registro dice si'. Decide la faccina.
> 4. **Il filtro news non e' una leva pronta**: file assente in `C:\FTMO`, serve lo shift +60, si legge solo all'avvio, mai misurato.
> 5. **Budget** (partenza ~154.184): pausa a -5.600, allarme della regola 4 a 148.000 (-6.184), emergenza a -7.200. Due stop DAX come il 01/10 portano **sotto 148.000**.
> 6. **Quattro opzioni** (a niente, b staccare sedie piatte, c Algo spento 14-16 IT, d filtro news): **decidi tu**. Scadenze: DAX entro 08:55 IT, Algo entro 14:00, USA entro 15:25.

**Il dato.** NFP (Non-Farm Employment Change + Unemployment Rate + Average Hourly Earnings), **venerdi' 02/10 alle 14:30 italiane = 15:30 server FTMO = 12:30 UTC**.
- Fonte [MISURATO]: `data/abtg_news.csv` al commit `47c46a6a` (28/09, generato dal feed Forex Factory in ora `Europe/Rome`, `agent/news_export.py`): tre righe `2026.10.02 14:30;High;USD;...`. Concordano `report/PACCHETTO_POSTNEWS_TRE_GRAFICI_2026-09-19.md` r.200 ("venerdi' 02/10/2026") e Paolo nella live del 01/10 ("alle due e mezza", scheda r.65).
- ✏️ **Correzione al mandato**: 14:30 italiane d'estate sono **12:30 UTC**, non 13:30 UTC. Ora server FTMO 15:30 confermata.
- 🔴 Limite: il file in repo e' **vuoto (0 byte) dal 29/09** (commit `fa8a0153`): non ho una conferma piu' fresca del 28/09. Un rinvio del dato all'ultimo momento [NON VERIFICATO]: va guardato sul calendario stamattina. **Il meccanismo concreto c'e'**: il 01/10 comincia l'anno fiscale federale USA, e se i fondi non sono stati approvati il BLS **non pubblica** (precedente: ottobre 2025, il NFP del 03/10/2025 non e' uscito per lo shutdown [memoria del modello, NON in repo]). Il feed del 28/09 non lo puo' sapere. **Se il dato salta, domani e' un venerdi' normale e questa nota non serve.** Controllo: Forex Factory (calendario del giorno) o la pagina del BLS, stamattina.
- Data ricalcolata [DERIVATO]: settimana di riferimento di settembre = 06-12/09 (il 12 e' sabato); terzo venerdi' dopo = **02/10**; 08:30 New York (EDT, UTC-4) = 12:30 UTC = 14:30 Roma (CEST) = 15:30 server FTMO (UTC+3).

**Chi e' esposto alle 15:30 server (14:30 IT)** (dettaglio sez. 2):
| gruppo | sedie | rispetto al dato |
|---|---|---|
| 🔴 DAX | 770101 long, 770105 short, 770411 short | posizione aperta fra le 10:00 e le 19:30 server: **puo' essere DENTRO al dato**; le RETEST possono anche **nascere** dal picco del dato (sorvegliano fino alle 19:30) |
| 🔴 Dow H1, 24 ore | 771531 EMA200, 770511 SuperWave | ordini e posizioni a qualsiasi ora, **niente chiusura del venerdi'**: dentro al dato e anche nel weekend |
| 🟠 Forex | Bulge viola 772720 (15 cross, 3 con USD) | ingressi alle ore tonde H1: una posizione delle 15:00 e' aperta al rilascio |
| 🟢 USA apertura | 770202 Dow, 770260 Nasdaq, 770621 ORB Dow | il range parte alle **16:30** server: **tutto DOPO** il dato, nella volatilita' che lascia |

Nota di coerenza: la domanda **D7** della scheda Paolo (`SCHEDA_LIVE_PAOLO_2026-10-01.md` r.348) chiede se devono saltare la giornata **le sedie USA**: sono proprio le **meno** esposte (flat al rilascio, partono 60' dopo). Le esposte al rilascio sono le DAX, le due Dow H1 e il Bulge.

**Il filtro news, oggi, non e' una leva pronta.** E' spento in tutti i preset (`InpUseNewsFilter=false`, confermato nei `.chr` in campo, sonda `CODA_08` 01/10). E se lo si accendesse cosi' com'e', **non proteggerebbe**: (1) nessuna attivita' scrive il file news dentro `C:\FTMO` (la 07:20 scrive solo nel piccolo BCM); (2) il calendario e' in ora italiana e su FTMO serve `InpNewsShiftMinutes=60`, altrimenti la finestra si chiude **30 minuti prima** del dato; (3) l'EA legge il file **solo all'avvio** (`OnInit`); (4) con la finestra di default 30/30 le tre sedie USA non verrebbero toccate (operano dalle 16:30); EMA200 e SuperWave bloccano solo i nuovi ingressi e **non chiudono** le posizioni aperte.

**La sedia NFP (PostNews 771203)**: **non** e' sul trial. Sul piccolo BCM e' attaccata ma **cieca** (il suo file e' stato svuotato il 07/09): domani non opera da nessuna parte [INFERITO dal codice e dalla foto di `Common\Files`, sez. 4].

**Misurato sui NFP passati: troppo poco per dire qualcosa sul merito.** FTMO: zero NFP nel periodo vissuto. Piccolo BCM, NFP del 07/08 e del 04/09: **nessuna** posizione delle sedie del trial aperta all'istante del dato (n=2 giorni; una SuperWave Dow **H2**, stesso motore ma non sul trial, si': chiusa a stop, sez. 5.2). Contratto in backtest, 4 NFP del calendario in repo: 7 posizioni (6 ingressi), somma circa -2,2 R [DERIVATO, n=7]. Verdetto: **[NON MISURATO]**. Le celle del contratto sono state misurate **col filtro spento, quindi con dentro i giorni di NFP** (~12/anno).

**Il budget del giorno** (Guardian v1.12, reset 01:00 server = mezzanotte IT; equity di partenza ~154.184 [MISURATO, riga Guardian 22:23 server del 01/10, tutto piatto]):
| soglia | in EUR | equity a cui scatta | in stop pieni da 2,00% (~3.084) |
|---|---:|---:|---:|
| pausa nuovi ingressi 3,5% x 160.000 | 5.600 | ~148.584 | 1,8 |
| emergenza 4,5%: chiude TUTTO e blocca il giorno | 7.200 | ~146.984 | 2,3 |
| muro giornaliero FTMO 5% (regola 2-Step; per la trial [NON MISURATO]) | 8.000 | ~146.184 | 2,6 |
| 🟠 allarme della **regola 4 dei 14 giorni** (`TRIAL_14_GIORNI_CRITERI`): "si spegne Algo e si guarda" | 6.184 | 148.000 | 2,0 |
| 🔴 pavimento del **Guardian** 9,3%: chiude tutto e **30 giorni di pausa** (= trial finita per noi) | 9.064 | 145.120 | 2,9 |
| muro 10% FTMO (2-Step; trial [NON MISURATO]) | 10.184 | 144.000 | 3,3 |
Fra l'emergenza del Guardian e il muro giornaliero restano **800 EUR = 0,26 stop**: uno slittamento da NFP sulla chiusura forzata li puo' mangiare [NON MISURATO lo slittamento FTMO su un NFP]. Gli 800 valgono **a conto piatto all'01:00 server** (stanotte lo e', Guardian in pausa): il Guardian prende come base l'**equita'** al reset (codice r.378), la base FTMO del giorno per la trial e' [NON MISURATO].

**Le quattro opzioni (decide Claudio; dettaglio sez. 7)**:
| | cosa | rischio residuo al dato | costo |
|---|---|---|---|
| **a** | non fare niente | tutto quello sopra, Guardian attivo (emergenza a -7.200) | zero; e' la configurazione misurata dal contratto |
| **b** | staccare a mano l'EA di alcune sedie (a sedia piatta e senza pendenti) | solo le sedie lasciate | ~2 posizioni attese perse se si staccano DAX+EMA200+SuperWave [DERIVATO]; rischio di sbagliare gli input al riattacco (gia' successo col Bulge il 01/10) |
| **c** | Algo Trading spento 14:00-16:00 IT (15:00-17:00 server) | posizioni e **pendenti gia' sul server restano e possono riempirsi**; BE/trailing/parziali fermi; **la chiusura d'emergenza del Guardian non parte finche' Algo e' spento** | ORB perde la giornata (piazza alle 16:45 server, dentro la finestra); le RETEST DAX che rompono nella finestra perdono quel lato; riaccendere entro le 16:05 IT o si perdono anche Dow/Nasdaq |
| **d** | filtro news acceso su una sedia via preset | dipende dalla sedia (sez. 3): chiude i DAX alle 15:00 server; con 30/30 non tocca gli USA | file news da portare in `C:\FTMO` + shift 60 + riavvio dell'EA + **firma** + cancello; configurazione **mai misurata**; viola la regola 2 dei 14 giorni ("se serve si spegne la sedia, non si ritocca") |

**Da guardare stamattina, prima di tutto il resto** [DA VERIFICARE A VISTA]: la sonda `CODA_01` del 01/10 03:30 legge il profilo salvato di `C:\FTMO` (file `.chr` del **30/09 23:24**): **12 grafici, 10 EA, e fra questi NON ci sono 770101 (DAX long) ne' 771531 (EMA200)**, che il 30/09 c'erano (chart01, chart04). Il registro del trial dice che ci sono. Se davvero non ci sono, la loro esposizione e' zero e l'opzione b per loro e' gia' fatta. 🔴 La sonda `CODA_01` delle 03:30 di stanotte **non lo decide**: rilegge lo stesso profilo salvato, e se nessuno lo ha risalvato ripete la foto del 30/09 23:24 (la sonda stessa la chiama "TIEPIDA"); le fonti si contraddicono gia' (`HANDOFF.md` r.11: Algo acceso alle ~00:30 con le sette vecchie e Bulge/ORB "non ancora attaccati", mentre il profilo delle 23:24 ha gia' Bulge e ORB e non ha 770101/771531). Il giornale del 01/10 (`CODA_09` di stanotte) lo prova **solo se** c'e' una riga di quelle sedie (un LIMIT `EMA200` o un `RETEST BUY` DAX); l'assenza non prova niente (alla rottura al rialzo delle 13:36 server, quella che ha fermato lo short 770105, la pausa del Guardian era gia' accesa: equita' ~153.900, perdita del giorno ~3,8% [DERIVATO dal cronistorico], quindi un 770101 attaccato avrebbe consumato il lato senza piazzare). **Decide la faccina** sui grafici GER40.cash M5 e US30.cash H1 del terminale **`1514806751` (`C:\FTMO`)**. Per riconoscere la finestra vale la regola dei terminali multipli (`CLAUDE.md`, punto 2: la stringa di sola lettura PID + titolo + cartella).

**Orologio delle decisioni (ora italiana)**: DAX entro le **08:55** (770411 piazza alle 08:59, il range DAX parte alle 09:00) · opzione c entro le **14:00** · sedie USA entro le **15:25** (range alle 15:30) · se si spegne Algo, riaccenderlo **entro le 16:05** (le RETEST USA armano alle 16:05).

---

## 1. Orologio e data, con le fonti

| evento | ora IT | ora server FTMO | UTC | fonte |
|---|---|---|---|---|
| reset giorno del Guardian (pausa azzerata, base nuova) | 00:00 | 01:00 | 22:00 (01/10) | `InpDailyResetHour=1`, `.chr` del Guardian in `CODA_08` 01/10 [MISURATO] |
| 770411 piazza il SELL STOP | 08:59 | 09:59 | 06:59 | preset FTMO `InpPlaceHour=9`, `InpPlaceMin=59` |
| range DAX Apertura (770101/770105) | 09:00-09:35 | 10:00-10:35 | 07:00-07:35 | preset `InpSessionHour=10`, `InpRangeMinutes=35` |
| 770411: cancella il pendente non scattato | 09:30 | 10:30 | 07:30 | `InpEntryCutoffHour=10`, `InpEntryCutoffMin=30` |
| **NFP** | **14:30** | **15:30** | **12:30** | sez. 0 |
| apertura cash USA, range Dow/Nasdaq/ORB | 15:30 | 16:30 | 13:30 | preset `InpSessionHour=16`/`InpRangeStartHour=16`, `...Min=30` |
| ORB piazza i pendenti | 15:45 | 16:45 | 13:45 | `InpRangeEndHour=16`, `InpRangeEndMin=45` |
| Dow/Nasdaq RETEST armate | 16:05 | 17:05 | 14:05 | range 35' |
| chiusura forzata DAX, Dow, Nasdaq, 770411 | 18:30 | 19:30 | 16:30 | `InpCloseHour=19`, `InpCloseMin=30`, `InpCloseAtEnd=true` |
| ORB fine giornata (cancella e chiude) | 22:00 | 23:00 | 20:00 | `InpEndHour=23`, `InpCloseAtEnd=true` |

Altri dati USA ad alto impatto il 02/10 nel feed del 28/09: solo i tre NFP alle 14:30 IT [MISURATO]. Il feed elenca solo l'impatto "High".

---

## 2. Sedia per sedia: che cosa puo' fare domani e quando

Fonte dell'elenco in campo: sonda `CODA_01_sedie_attaccate_20261001_033004.log` (profilo `Default` di `C:\FTMO`, `.chr` del 30/09 23:24) e `CODA_08` (input letti dai `.chr`). Taglie: preset FTMO e `.chr` [MISURATO]; il lotto si calcola sul **bilancio** (`CalcLotByRisk`, `PIANO_FREE_TRIAL_FTMO_2026-09-30.md` par. 1), quindi 2,00% di ~154.184 = **~3.084 EUR = 1,93% di 160.000** [DERIVATO].

| sedia (magic) | in campo sul trial? | rischio | piazza ordini (server) | tiene posizioni (server) | rispetto alle 15:30 server |
|---|---|---|---|---|---|
| DAX Apertura long RETEST (770101) | 🔴 **[DA VERIFICARE A VISTA]**: assente dal profilo del 30/09 23:24 | 2,00% | arma alle 10:35; il BUY LIMIT nasce alla rottura del massimo del range **in qualsiasi momento fino alle 19:30**, vale 120' | fino a TP/SL/pareggio o 19:30 | **PRIMA** (ingresso) e **DURANTE** (tenuta); anche **DOPO**: il picco del dato puo' fare da rottura [MISURATO sul codice al pin `9fca63d9`: `MonitorRetest` r.1465-1546 non ha un'ora limite, solo la chiusura di sessione r.673-677] |
| DAX Apertura short RETEST (770105) | si (`chart10`) | 2,00% | come sopra, lato short (il 01/10: limit alle 11:11:50) | fino alle 19:30 | come sopra |
| MaxMinNotte DAX short (770411) | si (`chart08`) | 2,00% | SELL STOP alle 09:59, cancellato alle 10:30 se non scattato | fino alle 19:30 | **DURANTE** (se e' scattato e non e' ancora a SL/TP) |
| Dow Apertura long RETEST (770202) | si (`chart02`) | 2,00% | range 16:30-17:05, limit da 17:05 | fino alle 19:30 | **DOPO** (60' dopo il dato il range e' ancora da cominciare) |
| Dow Apertura short (770212) | no (non in `CODA_01`) | - | - | - | non in campo |
| Nasdaq RETEST L+S (770260) | si (`chart03`) | 2,00% | come 770202 | fino alle 19:30 | **DOPO** |
| EMA200 Dow H1 L+S (771531) | 🔴 **[DA VERIFICARE A VISTA]**: assente dal profilo del 30/09 23:24 | 2,00% **totale** sulle due gambe | due LIMIT a nuova barra H1 se il prezzo e' nella fascia **e non ha gia' posizioni o pendenti** (pin r.186), scadono dopo 6 barre; `InpUseCutoff=false` | senza orario; **`InpFridayClose=false`**: anche nel weekend | **PRIMA, DURANTE e DOPO**; puo' entrare con un limit piazzato fino a 6 ore prima |
| SuperWave Dow H1 (770511) | si (`chart05`) | 2,00% | segnale a barra chiusa H1, pendente 3 barre, `InpUseTimeWindow=false` (0-24) | pareggio, trailing sul Supertrend, uscita al cambio; **nessuna chiusura del venerdi'** nel sorgente al pin `872dba82` (grep: zero) | **PRIMA, DURANTE e DOPO**, anche nel weekend |
| ORB Ottimizzato Dow long (770621) | si (`chart11`) | 0,3% | range 16:30-16:45, BUY STOP alle 16:45, valido fino alle 23:00 | fino alle 23:00 | **DOPO** (Paolo: "su NFP l'ORB non si fa", [DICHIARATO], scheda 01/10 V17) |
| Bulge viola (772720) | si (`chart12`, profilo 30/09; ripristinato a preset il 01/10 sera con commento "BULGE VIOLA") | 0,8% x 4 (preset) **oppure** 1,0% x 3: **[NON NOTO]** dopo il ripristino (`TRIAL_14_GIORNI_CRITERI_2026-10-01.md`, registro) | alle ore tonde H1 (barra chiusa), 24 ore, 15 cross (NZDUSD, USDCAD, USDCHF con USD) | fino a TP/SL; kill switch: 4 SL/giorno, 3 di fila, -2% di bilancio chiuso | **PRIMA e DURANTE**: un ingresso delle 15:00 e' aperto al rilascio. Tetto proprio 3,2% (0,8x4) o 3,0% (1,0x3) |
| MaxMin oro (770402) | no (`SCHIERA_FTMO.ps1` non la copia di proposito) | - | - | - | non in campo |
| PostNews ECB/FOMC/NFP (771204/771202/771203) | no | - | - | - | non in campo (sez. 4) |
| Guardian (779001) | si (`chart06`) | non trada | - | - | pausa 3,5%, emergenza 4,5% con chiusura di TUTTI i magic (`InpCloseAllMagics=true`), cap C1 4,00% |

**Rischio aperto possibile all'istante del dato** [INFERITO dal codice del Guardian, gia' misurato in campo]: il cap C1 al 4,00% e' una **bandiera sul rischio gia' aperto** (non somma l'ingresso nuovo, e un pareggio porta lo stop di quella posizione a zero): il tetto reale e' "sotto il 4%, piu' l'ultimo ingresso", cioe' **fino a ~6%** con un ingresso DAX/Dow da 2%. Misurato il 01/10 alle 10:00-10:06: **4,62%** aperto insieme (`TRIAL_GIORNO1_ANALISI_2026-10-01.md` par. 3). In EUR, ordine di grandezza: 3.000-9.600 se tutto quello che e' aperto va a stop insieme, prima dello slittamento.

**Lo slittamento sullo stop** il 01/10, giornata normale: DAX 1,16 punti su 67 (55 EUR) e 0,41 su 257 [MISURATO, stesso referto par. 6]. In un NFP sul feed FTMO: **[NON MISURATO]**.

---

## 3. Il filtro news: che cosa farebbe se lo si accendesse

### 3.1 Il meccanismo, sedia per sedia (sorgenti ai pin del binario in campo)
Tutti leggono lo stesso formato: `AAAA.MM.GG HH:MM;Impatto;Valuta;Titolo`, separatore `;`, dalla sandbox del terminale (`FileOpen` **senza** `FILE_COMMON`: cartella dati `46C9F8E9...\MQL5\Files` di `C:\FTMO`, non `Common\Files`) [MISURATO, grep `FileOpen(InpNewsFile` nei sette sorgenti]. Finestra = da `ora - InpNewsBeforeMin` a `ora + InpNewsAfterMin`, con `ora = riga + InpNewsShiftMinutes`; filtra `Impatto >= InpNewsMinImpact` (3 = High) e, se `InpNewsCurrencies` non e' vuoto, la valuta.

| sedia | binario in campo (pin, righe) | HEAD (righe) | finestra di default | cosa fa nella finestra | effetto sul NFP di domani con 30/30 e shift giusto (finestra 15:00-16:00 server) |
|---|---|---|---|---|---|
| 770101/770105 DAX | `CLAU12_DAX_Apertura_EU` = `9fca63d9`, 2425 | 2885 | 30/30, valute tutte | **chiude le posizioni e cancella i pendenti** (`InpNewsFlatten=true`, r.663-670) e non arma/piazza (r.693, 750, 760) | posizione DAX chiusa a mercato alle 15:00; dalle 16:00 la RETEST riprende a sorvegliare e puo' rientrare |
| 770411 MaxMin | `5fc0bc31`, 619 | 619 | 30/30 | chiude e cancella (r.164-165) | posizione chiusa alle 15:00 |
| 770202 Dow, 770260 Nasdaq | `9fca63d9`, 2205 / 2624 | 2205 / 2644 | 30/30 | chiude e cancella | **nessuno**: la loro giornata parte alle 16:30. Per saltare il giorno servirebbe `InpNewsAfterMin` di almeno ~240 |
| 770621 ORB | `19312c8b`, 1463 | 1483 | 30/30, `InpNewsCurrencies=USD` | chiude per ticket e cancella (r.361-370), non piazza | **nessuno** (piazza alle 16:45) |
| 771531 EMA200 | `26a18566`, 552 | 690 | **60/30** | **solo** salta i nuovi ordini a nuova barra (r.188). **Non chiude**, non cancella | non piazza alla barra delle 15:00; i limit gia' piazzati e le posizioni aperte restano |
| 770511 SuperWave | `872dba82`, 645 | 774 | 30/30 | **solo** salta i nuovi segnali (r.188). Non chiude | come EMA200 |
| 772720 Bulge | `c4426c53` (= HEAD), 2234 | 2234 | `Use_News_Filter=false`, `News_Block_Hours=7,9,11,12,15,22` | **non ha calendario**: blocca i nuovi ingressi in quelle **ore UTC, tutti i giorni** (`IsNewsHour`, r.1038-1053, `TimeGMT`) | l'ora 12 UTC = 15:00-15:59 server copre il NFP, ma acceso blocca **6 ore al giorno ogni giorno**: non e' un interruttore per il NFP |
| 779001 Guardian | `d884f7e1`, 498 | - | nessun filtro news | - | - |

- **Binario in campo contro HEAD** [MISURATO]: il pin e' piu' vecchio di HEAD per DAX, Nasdaq, EMA200, SuperWave, ORB (righe sopra); per Dow e MaxMin coincide nel numero di righe. **Il meccanismo news e' lo stesso a pin e a HEAD**: `LoadNews()` e' chiamata **solo** in `OnInit` (grep: 2 occorrenze per file, definizione + chiamata). Che i `.ex5` in campo vengano da quei pin e' [INFERITO]: la sonda `CODA_06` del 01/10 conta per i `CLAU12_*` le righe del pin + 1 (fine file), e i `.chr` in campo hanno tutte le chiavi news.
- **Conseguenza pratica**: il file va messo **prima**, poi si cambia l'input (il cambio di input riavvia l'EA, che rilegge il file). Se il file manca, l'EA scrive `file news ... non trovato ... Filtro news disattivato di fatto` (DAX r.507) e prosegue **come se il filtro fosse spento**: fallisce aperto.

### 3.2 I due contro-esempi dell'orologio (prima di consegnare: dove si rompe)
Il calendario di casa e' in **ora italiana** (`report/PRESET_FTMO_OROLOGIO_2026-09-20.md` par. 5 punto 3, misurato su FOMC invernale ed estivo; il feed del 28/09 da' Core PCE alle 14:30 = 08:30 ET in ora di Roma). Su FTMO (IT+1):
| come e' scritta la riga | `InpNewsShiftMinutes` | finestra 30/30 risultante (server) | esito |
|---|---:|---|---|
| `2026.10.02 14:30` (Roma, come la produce il repo) | **60** | 15:00-16:00 | ✅ copre il dato |
| `2026.10.02 14:30` (Roma) | 0 (valore in tutti i preset FTMO oggi) | 14:00-15:00 | 🔴 si chiude **30' prima** del dato: chiude i DAX un'ora e mezza prima e lascia il rilascio scoperto |
| `2026.10.02 15:30` (gia' in ora server) | 60 | 16:00-17:00 | 🔴 tutta **dopo** il picco |
| `2026.10.02 15:30` (gia' in ora server) | 0 | 15:00-16:00 | ✅ copre, ma il file non segue piu' la convenzione di casa |

### 3.3 Chi aggiorna il file news, e dove arriva (stato misurato)
1. **Sorgente**: `data/abtg_news.csv` sul branch `lavoro`, scritto da GitHub Actions: `news-export.yml` (cron 04:40 UTC; la guardia nel **codice** `agent/news_export.py` r.239-249 esce 1 solo se cade il feed obbligatorio, mentre "zero eventi futuri" e' solo un avviso dalla classe 461: il commento del workflow descrive ancora la 460) **e** `daily-report.yml` via `run_report.py` r.113-123, che chiama `write_abtg_news` **senza nessuna guardia** e poi committa il file com'e', anche vuoto. [MISURATO] E `news-export.yml` **non ha prodotto nessun commit dopo quello a mano del 19/09** (`git log --grep "news EA: aggiorna"`): dal 21/09 l'unico scrittore effettivo e' `daily-report` (commit "snapshot + news EA del giorno").
2. **Stato della sorgente**: dimensione per commit: 717 byte (19/09) · 331 (24/09) · 438 (28/09, **contiene il NFP del 02/10**) · **0 byte dal 29/09** (`fa8a0153`, "snapshot + news EA del giorno", cioe' `daily-report`). Da allora nessun commit sul file: e' ancora vuoto [MISURATO, `git log`].
3. **Il ponte sul VPS**: attivita' `ABTG_AggiornaNews` alle 07:20, che oggi esegue **`C:\ABTG\aggiorna_news.ps1`** (non piu' la copia sul Desktop del vecchio branch che `CLAUDE.md` descrive al 12/09: superata dalla sonda `CODA_11` del 01/10 [MISURATO]). Esito: **0 il 28/09, 1 il 29/09 e il 30/09** [MISURATO, `CODA_11` del 29/09, 30/09, 01/10]. Coerente con la versione v2 dello script, che rifiuta un file vuoto e lascia in campo quello di prima [INFERITO: che sul VPS giri proprio la v2 non e' stampato dalla sonda]. Esito del 01/10 07:20: non ancora in nessuna sonda.
4. **Dove scrive**: **solo** nella cartella dati del terminale `BCM Markets MT5 Terminal` (piccolo 50503392); il 100k `-V3` e il reale sono vietati per nome (`aggiorna_news.ps1` r.55 e r.88). **`C:\FTMO` non e' mai un bersaglio** dell'attivita' [MISURATO sul codice]: lo script accetta `-TerminaleDati` per nominare un altro terminale, ma l'attivita' non lo passa (argomenti in `CODA_11` del 01/10). Quindi il piccolo ha con ogni probabilita' ancora la copia del 28/09, con il NFP del 02/10 [INFERITO, non letto].
5. **Cosa c'e' in `C:\FTMO\...\MQL5\Files\abtg_news.csv`**: **[NON MISURATO]** (nessuna sonda lo legge). `Common\Files\abtg_news.csv` del VPS ha 2 righe del 10/09 (solo la BCE) [MISURATO, `CODA_05` 01/10], ma gli EA FTMO non leggono `Common`.
6. `mql5/Files/abtg_news.csv` in repo (quello citato nella scheda D7) e' un **file statico** (FOMC/BCE di fine anno, nessun NFP dopo il 06/03): non e' il canale vivo. La scheda D7 ha ragione sul fatto (nessuna riga del 02/10 li'), ma il feed vivo la riga l'aveva il 28/09.

### 3.4 Che cosa servirebbe per accendere il filtro su una sedia (proposta, non pronta)
1. **Firma di Claudio** (e' una modifica di input durante la trial: regola 2 di `TRIAL_14_GIORNI_CRITERI_2026-10-01.md` chiede di scriverla con data e ora, e dice "se serve, si spegne la sedia, non si ritocca").
2. Un file `abtg_news.csv` nella cartella dati di `C:\FTMO` (`46C9F8E9FF0C747B2B5E09BCC13D5237\MQL5\Files`) con l'intestazione e almeno la riga `2026.10.02 14:30;High;USD;Non-Farm Employment Change`. Portarcelo e' una **scrittura sul VPS**: serve una riga nuova, che passa da `controlla_riga.py` + `controllo-preventivo` con il bersaglio dichiarato (finestra PowerShell sul VPS, scrive solo in `C:\FTMO`, non tocca 50503392, 50504263, 10105439, 50504400, Pepperstone, Tickmill). **Oggi quella riga non esiste.**
3. Sulla sedia scelta, nella finestra Input: `InpUseNewsFilter=true`, `InpNewsShiftMinutes=60`, e finestre scelte da Claudio (per le sedie USA, con 30/30 non cambia niente).
4. Verifica in Esperti: `news caricate: N eventi dal file 'abtg_news.csv'` con N >= 1. Se compare `non trovato`, il filtro e' spento di fatto.
5. Il giorno dopo, rimettere `false` (altrimenti la configurazione resta diversa da quella misurata) e scriverlo nel registro.

---

## 4. La sedia dedicata al NFP: PostNews USDJPY 771203

| dove | stato | fonte |
|---|---|---|
| **trial `1514806751`** | **non attaccata** | `CODA_01` 01/10: nessun `ABTG_PostNews` sul profilo di `C:\FTMO` [MISURATO] |
| preset FTMO in repo | punta a `abtg_news_postnews_2010_2025_UTC.csv` (ultima riga 03/07/2025): **cieca anche se la si attaccasse** | `CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` r.350 [MISURATO] |
| piccolo `50503392` | attaccata (`chart42`, USDJPY M5, 1,3%), legge `Common\Files\abtg_news_live_2026-09-04.csv`, **svuotato il 07/09** (solo intestazione) | `CODA_08` e `CODA_05` del 01/10; `POSTNEWS_NEUTRALIZZATE_2026-09-07.md` [MISURATO] |
| comportamento a file vuoto | `InpRestrictToNews=true` + nessuna riga del giorno = "nessuna notizia nel CSV oggi: niente ordini" | `ABTG_PostNews.mq5` r.251 [MISURATO sul codice] |
| contratto | DD e PF **[NON MISURATO]** | `CONTRATTI_DELLE_SEDIE_FTMO` r.70 |
| l'ultima volta che ha operato | 04/09, `NFP PostNews SELL` USDJPY 0,23, +38,16 (prima della neutralizzazione) | `ReportHistory_50503392_2026-10-01.xlsx` [MISURATO] |

Domani, quindi, **nessuna sedia opera il NFP di proposito**, su nessun conto [INFERITO].

---

## 5. Esposizione misurata sui NFP e sui giorni di dati USA

### 5.1 FTMO (challenge 22-30/09 + trial 01/10)
- NFP nel periodo: **zero** (04/09 e' prima del 22/09).
- Dati USA "High" nel periodo secondo i feed del repo (`d7ff1af5` del 24/09, `47c46a6a` del 28/09): solo **30/09 14:30 IT** (Core PCE, PIL finale) = 15:30 server. Quel giorno l'unica posizione della flotta e' 770411, chiusa alle 10:03 (`FTMO_541452707_cronistorico_2026-09-30.xlsx`). **n = 1 giorno, 0 posizioni esposte.** [MISURATO]

### 5.2 Piccolo BCM 50503392 (stesse famiglie, feed BCM, lotti piccoli; BCM d'estate = IT-1, dato alle 13:30 BCM)
Fonte: `data/statements/ReportHistory_50503392_2026-10-01.xlsx` (Affari, commento d'ingresso). Date: 07/08 (`report/coach_paolo/NEWS_BREAKOUT_OCO_NFP_2026-09-03.md` r.498) e 04/09 (`mql5/Files/abtg_news_live_2026-09-04.csv`).
| giorno | famiglia (commento) | ingresso -> uscita (ora BCM) | netto EUR | aperta al dato? |
|---|---|---|---:|---|
| 07/08 | DAX Apertura EU RETEST BUY | 08:58 -> 09:30 (pareggio) | +5,40 | no, prima |
| 07/08 | Nasdaq Apertura US SELL | 15:11 -> 15:13 (pareggio) | +0,19 | no, dopo |
| 07/08 | Dow Apertura US BUY | 15:25 -> 17:30 (chiusura a ora) | -18,68 | no, dopo |
| 04/09 | DAX Apertura EU RETEST BUY | 08:40 -> 11:30 (pareggio) | +2,16 (+30,78 la gemella sul 100k) | no, prima |
| 04/09 | SUPERWAVE DOW H1 L 1/3 + 2/3 | 03/09 17:00 -> 04/09 11:33 (SL) | -16,97 | no, chiusa 2 ore prima |
| 04/09 | EMA200 DOW L1 + L2 | 21:30 -> 21:31 (SL) | -40,30 | no, 8 ore dopo |
**Nessuna posizione delle sedie del trial aperta all'istante del dato in 2 NFP su 2.** n=2 giorni, 8 posizioni: [NON MISURATO] per qualunque giudizio.
✏️ Contro-esempio cercato e trovato (cancello): il 04/09 **una** posizione dello **stesso motore SuperWave sul Dow ma in H2** (`SW DOW H2 L 1/3` e `2/3`, posizioni 3311232/3311234, aperte il 03/09 23:05-23:15 BCM, **non e' una sedia del trial**) era aperta al rilascio delle 13:30 BCM e ha chiuso **a stop alle 15:13 BCM**, -26,04 -26,06 = **-52,10** [MISURATO, stesso file]. Uno su uno, nessun giudizio: ma "nessuna famiglia esposta" sarebbe stato falso.

### 5.3 Contratto in backtest (per-trade OOS 2025.06.10-2026.06.30, file in `AUDIT_RISCHIO_FLOTTA_2026-10-01.md` par. 0.1)
Date NFP prese **solo** dal repo: 03/07/2025 (`abtg_news_postnews_2010_2025_UTC.csv`), 09/01, 06/02, 06/03/2026 (`mql5/Files/abtg_news.csv`). 🔴 Il repo **non ha** le date NFP di agosto-dicembre 2025 e aprile-giugno 2026 (lo stesso buco e' gia' scritto in `R245_IL_DD_DELLA_FINESTRA_VERGINE_2026-09-25.md` par. 3): non le scrivo a memoria. Le date del repo non sono verificate contro il calendario ufficiale [NON VERIFICATO].
| sedia | posizioni chiuse nei 4 giorni NFP | netto a 1% su 100.000 | ~R [DERIVATO, netto/1.000] | R medio del contratto per posizione |
|---|---|---|---:|---:|
| 770101 | 3 (03/07 +544,92; 06/02 -1.150,50; 06/03 +536,64) | -68,94 | ~-0,07 | +0,088 |
| 770202 | 2 (03/07 +45,00; 09/01 -1.090,52) | -1.045,52 | ~-1,05 | +0,071 |
| 771531 | 2 gambe dello stesso ingresso (06/02, -540,63 x 2) | -1.081,26 | ~-1,08 | - |
| 770411 | 0 | 0 | 0 | - |
Totale 7 posizioni (6 ingressi), ~-2,2 R. R medi del contratto da `AUDIT_RISCHIO_FLOTTA` r.242. Il per-trade ha solo le uscite: non dice se la posizione era aperta al rilascio. **[NON MISURATO]**: 7 posizioni non distinguono un effetto NFP dal rumore.

**Che cosa misurerebbe davvero** (proposta, non lanciata): un calendario NFP 2025-2026 verificato (fonte: BLS o il feed), poi lo stesso per-trade spezzato in giorni NFP / altri giorni, con l'istante del rilascio dentro o fuori dalla posizione. Costa zero passate di tester se si usa un per-trade con ingresso e uscita; quello in repo ha solo le uscite.

---

## 6. Il conto di domani, in numeri

| voce | valore | fonte |
|---|---:|---|
| equity / bilancio a sera 01/10 (tutto piatto) | 154.184,36 | riga Guardian 22:23 server, `TRIAL_GIORNO1_ANALISI` par. 9 [MISURATO] |
| perdita del 01/10 | -3,63% sull'equity a sera; -3,90% sul bilancio delle 16:45 (153.754,32) | stesso referto par. 1 e 9 (il -3,9% del mandato e' il secondo) |
| base del giorno 02/10 per il Guardian | equita' alle 01:00 server, ~154.184 se nulla si muove di notte | `ABTG_Guardian.mq5` pin `d884f7e1` r.378 [INFERITO il valore] |
| uno stop pieno a 2,00% | ~3.084 (1,93% di 160.000) | [DERIVATO] |
| Bulge, uno stop | 1.233 (0,8%) o 1.542 (1,0%) | [DERIVATO] |
| Bulge, tetto proprio | 4.934 (0,8x4) o 4.626 (1,0x3) | [DERIVATO] |
| ORB, uno stop | 463 (0,3%) | [DERIVATO] |
| pausa Guardian | perdita del giorno >= 5.600 | `.chr` Guardian `CODA_08` |
| emergenza Guardian: chiude tutti i magic, blocca il giorno | >= 7.200 | idem; codice r.414-426 |
| pavimento totale Guardian (9,3%) | equity <= 145.120: chiude tutto e mette **30 giorni di pausa** | codice r.404-413, 436 |
| distanza dal muro 10% FTMO (144.000) | 10.184 = 6,4% di 160.000 = 3,3 stop da 2% | [DERIVATO]; regola trial [NON MISURATO] |

Lettura [DERIVATO]: due stop pieni da 2% in fila (3.084 + 3.022 = **6.106**: il secondo si calcola sul bilancio gia' sceso) accendono la pausa **e portano l'equity a ~148.079, 79 EUR sopra l'allarme della regola 4 dei 14 giorni (148.000: "si spegne Algo e si guarda")**; il terzo porta oltre l'emergenza, che chiude tutto a ~-7.200. Dopo una giornata d'emergenza l'equity sarebbe ~146.984: **1.864 sopra il pavimento del Guardian (145.120, 30 giorni di pausa)** e 2.984 sopra il muro 10% FTMO. Lo stop del giorno dopo si calcola sul bilancio piu' basso (2% di ~146.984 = **~2.940**): il pavimento del Guardian sarebbe a **0,63 stop**, il muro FTMO a ~1,0 stop. Il trial non muore domani per un NFP se il Guardian chiude in tempo; ne esce con **meno di uno stop** prima del nostro stesso pavimento.

---

## 7. Le opzioni, con costo e rischio

### (a) Non fare niente
- **Rischio**: sez. 2 e 6. Al rilascio possono essere aperte le DAX, EMA200, SuperWave e il Bulge; ordine di grandezza fino a ~4,6-6% del conto se tutto va a stop insieme, piu' lo slittamento da NFP [NON MISURATO]. Il Guardian chiude tutto a -7.200.
- **Costo**: zero. E' la configurazione che il contratto ha misurato (celle col filtro spento, quindi con i NFP dentro: `PRESET_FTMO_OROLOGIO_2026-09-20.md` par. 5 punto 1).
- **A favore** [INFERITO]: la trial esiste per misurare la meccanica (`TRIAL_14_GIORNI_CRITERI`); esecuzione e slittamento su un NFP sul feed FTMO sono proprio un dato che non abbiamo, e che una challenge vera incontrera' (in Evaluation non ci sono restrizioni news: `docs/RISPOSTA_SUPPORTO_FTMO_2026-09-29.md` punti 2-4).
- **Contro**: il margine dal muro 10% e' di 3,3 stop (dal pavimento del Guardian 2,9); una giornata come il 01/10 (due stop DAX, -6.403) su un NFP porta l'equity a ~147.781: **sotto l'allarme 148.000 della regola 4** (Algo spento per regola gia' scritta), a ~0,9 stop dal pavimento del Guardian e ~1,3 dal muro FTMO [DERIVATO].

### (b) Staccare a mano l'EA di una o piu' sedie
- **Cosa toglie**: l'esposizione di quella sedia per la giornata.
- **Quando si puo' fare senza lasciare orfani**: solo a sedia **piatta e senza pendenti**. Un EA staccato lascia sul server i pendenti (con la loro scadenza) e le posizioni con il loro SL/TP, ma **senza** la chiusura delle 19:30, il pareggio, il trailing e la parziale. Quindi: DAX (770101/770105/770411) **prima delle 08:59 IT**; USA (770202/770260/770621) **prima delle 15:30 IT**; EMA200 e SuperWave solo se in quel momento non hanno posizioni o pendenti (lavorano 24 ore: va guardato).
- **Costo in operazioni** [DERIVATO dalle frequenze promesse, `CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` par. 6]: DAX 770101 0,70/g + 770411 0,05/g (+ 770105 [NON MISURATO]); EMA200 0,93/g; SuperWave ~0,29/g: **~2 posizioni attese** se si staccano le cinque esposte al dato. Le tre USA: ~0,71/g (+ ORB [NON MISURATO]). Su ~10 giorni di borsa della trial, un giorno e' ~10% del campione di frequenza di quelle sedie.
- **Rischio di processo**: riattaccare vuol dire rimettere gli input giusti. Il 01/10 il Bulge ha girato ore con gli input di default dopo un riattacco (`TRIAL_14_GIORNI_CRITERI`, registro). Va riattaccato **col preset** e controllato in Esperti (`CONFIG IN USO -> ...`). Il riattacco e' reload-safe (guardia sui deal del giorno).
- **Regola dei 14 giorni**: compatibile ("si spegne la sedia, non si ritocca"); va scritto nel registro con l'ora.
- Bersaglio: terminale **`1514806751` (`C:\FTMO`)**, con la stringa di identificazione della regola dei terminali multipli. E' un'azione a mano in MT5.

### (c) Algo Trading spento dalle 14:00 alle 16:00 IT (15:00-17:00 server)
- **Che cosa resta vivo**: posizioni aperte con SL/TP sul server (il server le chiude se toccati) **e i pendenti gia' piazzati, che il server puo' riempire anche ad Algo spento** (una RETEST DAX o un limit EMA200 piazzati prima delle 15:00 possono scattare sul picco).
- **Che cosa si ferma** [MISURATO sul codice, salvo dove indicato]:
  - pareggio, trailing, parziale al TP1 (DAX/Dow/Nasdaq hanno `InpTP1_ClosePct=50`): non eseguiti nella finestra;
  - **il Guardian**: e' un EA come gli altri; se l'emergenza scatta ad Algo spento, la chiusura fallisce, ma il blocco del giorno resta scritto e la chiusura si ripete a ogni giro di timer, quindi **parte appena Algo torna verde** (r.414-426). Per due ore la rete d'emergenza e' **rimandata**, non persa;
  - **ORB**: piazza alle 16:45 server, dentro la finestra; se l'invio fallisce, `TryPlace` ritorna `true` e la fase passa a "piazzato" senza ordine (pin `19312c8b` r.430-476): **perde la giornata**;
  - **RETEST DAX**: il lato si marca come "rotto" **prima** dell'invio (r.1483/1516): una rottura dentro la finestra **consuma quel lato per tutto il giorno**;
  - Bulge, SuperWave: i segnali delle barre 15:00 e 16:00 si perdono (si valutano a barra chiusa) [INFERITO]; EMA200 riprova alla barra dopo [INFERITO: il controllo e' "nessuna posizione e nessun pendente"].
- **Margine orario**: 16:00 IT = 17:00 server; le RETEST Dow/Nasdaq armano alle **17:05 server = 16:05 IT**: **5 minuti** di margine. Il range 16:30-17:05 si costruisce senza ordini, quindi non soffre.
- **Rischio di processo**: dimenticare di riaccendere. Precedente reale: il 21/09 Algo spento dopo un riavvio, EA attaccati ma muti (`CLAUDE.md`, pronto soccorso).
- **Costo**: ORB della giornata, i segnali Bulge/SuperWave di due barre, eventuali lati RETEST. **Non** riduce l'esposizione di cio' che e' gia' aperto al dato.
- Ordine di grandezza del rischio residuo: lo stesso di (a) per le posizioni gia' aperte alle 15:00 server, **senza** la chiusura d'emergenza fino alle 17:00 server.

### (d) Accendere il filtro news su una sedia con un preset
- **Cosa serve**: sez. 3.4 (firma, file in `C:\FTMO` tramite una riga nuova che passa dal cancello, shift 60, riavvio dell'EA, verifica in Esperti, ritorno a `false` il giorno dopo). Oggi **niente di questo e' pronto**.
- **Effetto per sedia**: sez. 3.1. In concreto, con 30/30: **DAX chiuse alle 15:00 server** (si realizza quello che c'e' in quel momento, vincita o perdita, e si rinuncia al resto della corsa fino alle 19:30); **USA nessun effetto**; EMA200/SuperWave nessuna chiusura; Bulge non ha questo filtro.
- **Rischio residuo**: per la sedia filtrata, quello dello slittamento della chiusura alle 15:00 (prima del dato, spread normali [INFERITO]); per le altre, come (a).
- **Costo**: configurazione **mai misurata** (celle misurate col filtro spento); e' una modifica di input durante la trial (registro); tempo: la riga del file va scritta, passata dal cancello e lanciata **prima** delle 08:59 IT per le DAX.
- **Rischio di errore**: lo shift (sez. 3.2). Con lo shift lasciato a 0, il filtro chiude i DAX alle 14:00 server e lascia scoperto il rilascio: **peggio di (a)**, perche' toglie la posizione e non protegge niente.

### Una variante che esiste ma non propongo per domani
Il canale del Guardian (variabili globali `ABTG_PAUSA_GIORNO_1514806751` e `ABTG_PAUSA_FINO_...`, `ABTG_PausaGuardian.mqh` v1.20 r.97-106) permetterebbe in teoria una "pausa nuovi ingressi" a orario senza spegnere Algo e senza togliere la chiusura d'emergenza. Ma vuol dire scrivere a mano in F3 due date in secondi, cosa **mai provata**; e le RETEST DAX consumano comunque il lato (la guardia viene controllata dopo la marcatura, r.1483/1503). Resta un'idea da misurare, non uno strumento.

---

## 8. Che cosa NON ho fatto, e i limiti
- Non ho verificato la data del NFP contro una fonte ufficiale fuori dal repo: le fonti sono il feed del 28/09, il referto PostNews e Paolo. Lo stato dei fondi federali USA al 01/10/2026 (shutdown si' o no) **non e' noto** da qui.
- Non ho letto il contenuto di `C:\FTMO\...\MQL5\Files` (nessuna sonda lo legge), ne' l'esito della 07:20 del 01/10.
- La presenza di 770101 e 771531 sul trial e' contraddetta dal profilo salvato del 30/09 23:24: [DA VERIFICARE A VISTA].
- Gli input del Bulge dopo il ripristino della sera del 01/10 (0,8x4 o 1,0x3) non sono noti.
- Le regole della Free Trial (muro giornaliero, muro totale, base del calcolo giornaliero) restano [NON MISURATO]: i numeri usano quelle del 2-Step.
- Nessuna sedia e' stata giudicata nel merito: qui si parla solo di rischio ed esposizione.

## Fonti
`HANDOFF.md` (blocco 01/10) · `report/TRIAL_GIORNO1_ANALISI_2026-10-01.md` · `report/TRIAL_14_GIORNI_CRITERI_2026-10-01.md` · `report/PIANO_FREE_TRIAL_FTMO_2026-09-30.md` · `report/PACCHETTO_BULGE_ORB_TRIAL_2026-10-01.md` · `report/SCHEDA_LIVE_PAOLO_2026-10-01.md` (D7, V17-V18) · `report/PRESET_FTMO_OROLOGIO_2026-09-20.md` · `report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` · `report/AUDIT_RISCHIO_FLOTTA_2026-10-01.md` · `report/POSTNEWS_NEUTRALIZZATE_2026-09-07.md` · `report/PACCHETTO_POSTNEWS_TRE_GRAFICI_2026-09-19.md` · `report/R245_IL_DD_DELLA_FINESTRA_VERGINE_2026-09-25.md` · `docs/RISPOSTA_SUPPORTO_FTMO_2026-09-29.md` · `backtest_pipeline/coda/referti/CODA_01, 05, 06, 08, 09, 11 del 20261001_033004` (e `CODA_01`/`CODA_11` del 29-30/09) · `mql5/Presets/FTMO/*.set` · sorgenti ai pin: `ABTG_DAX_Apertura_EU`, `ABTG_Dow_Apertura_US`, `ABTG_Nasdaq_Apertura_US` (`9fca63d9`), `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` (`5fc0bc31`), `ABTG_EMA200` e `ABTG_PausaGuardian.mqh` (`26a18566`), `ABTG_SuperWave_DOW_H1_Ottimizzato` (`872dba82`), `ABTG_ORB_Ottimizzato` (`19312c8b`), `ABTG_Bulge` (`c4426c53`), `ABTG_Guardian` (`d884f7e1`), `ABTG_PostNews` (HEAD r.251) · `backtest_pipeline/aggiorna_news.ps1` · `run_report.py` · `.github/workflows/news-export.yml`, `daily-report.yml` · `data/abtg_news.csv` (storia git) · `data/statements/ReportHistory_50503392_2026-10-01.xlsx`, `trades_100k.csv`, `FTMO_541452707_cronistorico_2026-09-30.xlsx`, `ReportHistory_trial_1514806751_2026-10-01.xlsx` · per-trade OOS `772501`, `772505`, `770413`, `763400`.
