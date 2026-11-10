# UBS: ripasso di tutto cio che e stato estratto da Discord, dai video e dal manuale (10/11/2026)

**Natura: RIPASSO DOCUMENTALE, nessun test nuovo.** Rilette le sintesi gia nel repo (`UBS_DISCORD_2026-11-03/*`, `UBS_VIDEO_WIM_SINTESI_2026-10-31.md`, `UBS_COMMENTI_MQL5_ANALISI_2026-10-31.md`) e il **manuale UBS** (`ultimate-breakout-manual.pdf`, 4/11, che era gia caricato e che avevo segnato "non letto": errore mio, ora letto). Etichette: **[Wim]** = scritto da Wim (da sintesi ricontrollate in parte; `Digital_Wim` e un bot e NON conta come Wim); **[utenti]** = dichiarazioni non verificate di chi posta, spesso selezionate (chi perde scrive meno); **[manuale]** = letto qui; **[nostro]** = misurato da noi. I canali general-trade-talk, newbies-corner, automated-support, karnek_questions e altri NON sono stati letti; le immagini (circa 480 nel passato) nemmeno; nessun allegato scaricato.

## 1. Il metodo di Wim, in breve
- Sceglie le strategie ottimizzando su **2013-2023 (in-sample)**, controlla **2004-2012 e 2024-2025 fuori campione**, con **1 minuto OHLC** su dati **MetaQuotes** per forex e oro (IC Markets per indici e crypto), lotto fisso (oro 0,1 con "Adjust Lotsize to Variable Values", poi DD diviso 10) [Wim, video 1 e manuale]. Nel video le tre strategie A/B/C hanno **DD a 0,01 lotti di 63/55/84 $ misurato su 2004-2025** [video 1, fotogramma].
- Ogni set porta scritto **`HistoricalMaxDD`** (in $ a 0,01 lotti). Il lotto del metodo "use Max Risk Per Strategy" e calcolato perche quel DD stia dentro la percentuale scelta [manuale]. **"It's the responsibility of the client to run tests with the set files provided... I can't adjust it to the broker"** [Wim 04/09, V]. Cioe: il numero va rifatto sul proprio broker.
- Portafoglio: strategie non correlate, stesso `MaxRiskPerStrategy` per tutte, AutoLoader (cartella `Common\Files\Sets`, `ForceSymbol` esatto, magic diversi) [manuale, Wim]. "Non cerchiamo risultati belli, cerchiamo di bilanciare"; recovery factor >= 3 [V]; 5-7 EA al massimo per conto; "30 breakout sull'oro sono correlati" [V].
- **Regola pratica sul rischio** [Wim 18/06, V]: il **DD combinato del portafoglio da 30 set e circa 4-5 volte il rischio per strategia**; livelli 2 = basso, 4 = medio, 8 = alto; il suo live a 30-44 set usa 3% per strategia ("15-20% di DD massimo secondo i miei test"); per stare sicuri 0,5-1.
- Test di Wim "45 set a 2% per strategia, 2025-26, 100k fissi": +187.206, DD 5,66% [commenti MQL5] su un periodo di oro in forte rialzo e set costruiti su quegli anni.
- Prop dentro UBS [Wim, manuale, video 3]: **Max Daily Drawdown** (conta anche il flottante; quando e superato **chiude solo i trade dell'EA stesso** e aspetta il giorno dopo; consiglia 4 se il limite e 5; la base del calcolo e **in conflitto fra le fonti**: "equity massima del giorno meno equity minima del giorno" [Wim 22/03, V] contro "base non detta" [video]), chiusura a equity minima e massima. Tutte a 0 nei set.
- Broker: gli scalp sono molto sensibili (Vantage meglio di IC); per scalp sempre real ticks; **MetaQuotes "non funziona" per gli scalp** [Wim 26/10].

## 2. Quello che dicono gli utenti [non verificato]
- **Ottobre 2026 e stato negativo per quasi tutti i set oro**: malek -10,5% al 20/10 e poi -26% nel mese; JOHN -20%; Eugen -5% / -12%; langesi circa 20% di DD in un giorno (backtest 35% su 20 anni); un utente: "ottobre negativo da almeno 3 anni". Wim live: -7% a ottobre secondo un utente.
- Slippage sui pendenti = la maggior parte dei problemi: un conto demo "top 16" mostra slippage totale -4.715 € contro +1.056 € di realizzato; Mistermember: slippage costa il 40% del profitto. Backtest +50% contro live -18% nello stesso periodo (utente).
- Risultati spettacolari (da 400 a oltre 100k, +365%) citati da utenti poi espulsi o su conti cent/demo; i rischi alti (8% per trade, "YOLO") bruciano i conti.
- Set Gold Scalp C: il migliore per molti, ma molto sensibile al broker e con serie di 3-5 SL. Non e uno dei nostri.
- **FTMO (utenti, NON verificato)**: ban per "correlated trading" con la stessa strategia su piu conti; tetto 400k per la stessa strategia (**confermato da FTMO il 10/11, vedi `FTMO_RISPOSTE_TRACCIA_2026-11-09.md`**); max 200 pendenti; iperattivita "3-5k messaggi al giorno = avviso, 15k = rischio di disabilitazione" (**non coincide con le 2.000 richieste scritte da FTMO**: vale la cifra di FTMO).
- Wim su FTMO/prop [Wim]: "UBS for sure... completely unique setups if you put some work in it"; su IC Markets `FridayStopHour` a 22 "per evitare contestazioni di gap trading".

## 3. Confronto con le nostre misure e cosa cambia
1. **U1 pilota [nostro]**: 4 set su 6 hanno un DD su BCM da 1,4 a 4,6 volte il dichiarato. Per quello che Wim dice (il numero va rifatto sul proprio broker; i suoi dati sono MetaQuotes), **e atteso**, non e una sorpresa. Il pilota pero era su **2013-2026**, mentre il dichiarato e probabilmente su **2004-2025**: **il confronto non era omogeneo**. U1b e stato cambiato (periodo lungo 2005-2026 come passata principale, 2013-2026 come secondaria). Prima di lanciare nessun numero e stato visto.
2. **Dati MetaQuotes**: la spiegazione piu semplice della differenza e il dato storico. Per verificarla serve U1c su un terminale MetaQuotes-Demo (passo manuale tuo).
3. **Non e "il set uguale per tutti = strategia diversa dalla nostra"**: i set standard di Wim li hanno migliaia di clienti. Per il tetto di 400.000 $ per strategia (FTMO, 10/11) valgono come **la stessa strategia**. Solo un portafoglio **costruito da noi** (ottimizzazione, combinazione) puo essere "unico", ma e un lavoro lungo e con rischio di sovraottimizzazione (Wim sceglie la curva "a occhio"; il suo `UBS Optimizer` non e ancora uscito). **Non e un vantaggio automatico di UBS.**
4. **Oro troppo correlato**: i breakout sull'oro sono correlati fra loro [Wim]. La riduzione del DD viene dalla diversificazione fra mercati (indici di paesi diversi, correlazione quasi zero [utenti]). Un portafoglio UBS solo-oro non diversifica.
5. **Rischio per strategia e limiti FTMO**: con 4-5 volte il rischio per strategia come DD combinato, e DD su BCM fino a 4,6 volte il dichiarato, un portafoglio con 2% per strategia puo sforare il 10% totale. Con 0,5-1% e dati ricalibrati puo stare dentro. **Da misurare in U2**, non da assumere.
6. **Max Daily Drawdown dell'EA non basta**: chiude solo i suoi trade, la base non e quella di FTMO (balance di inizio giornata; per Wim e max-min dell'equity del giorno, secondo una fonte). **Il Guardian resta necessario.**
7. **Slippage dei pendenti**: il tester non lo riproduce; la differenza fra test e live puo essere grande per breakout a ordini pendenti (e UBS e fatto di breakout). Il forward in demo non misura lo slippage [Wim: "non uso piu demo"].
8. **OnlyUp** acceso in tutti i set (lotti che salgono e non scendono dopo un DD), e `FridayStopHour` come impostato: sono da guardare dentro ogni portafoglio (gap trading e weekend su FTMO Standard).
9. **Licenza e conti**: numero massimo di conti per licenza **non trovato**; l'AutoLoader non funziona sul VPS di MQL5 [utenti]; nel nostro tester la licenza e accettata [nostro]. UBS V9.5, prezzo di listino 1.699 $ [commenti MQL5].

## 4. Errori o lacune miei emersi in questo ripasso
- Il manuale era caricato dal 27/10 (zip) e dal 4/11 (PDF) e l'avevo lasciato come "da leggere": corretto adesso.
- Il periodo del DD dichiarato non era stato messo a confronto con il periodo del pilota: corretto in U1b.
- Il pilota non era testato fuori campione e usava dati BCM: ora e dichiarato come limite e c'e U1c.
- Una frase vecchia del pilota ("il numero scritto nel set non e affidabile da solo") va letta cosi: **non e affidabile su BCM; su MetaQuotes non lo sappiamo ancora**.

## 5. Da verificare (aperto)
1. Su quale periodo e con quali dati Wim ha misurato `HistoricalMaxDD` per i set oro (chiedere a Wim o nella documentazione): `NON TROVATO`.
2. La base del calcolo di "Max Daily Drawdown" (equity massima meno minima, oppure da inizio giornata?).
3. Il numero massimo di conti per licenza UBS.
4. Se i set "client" (cartella Clients) e quelli di terzi hanno controlli di qualita: nel ripasso nessuno e verificato.
5. U1b (DD BCM, 37 set, due periodi), U1c (MetaQuotes), U2 (lotto da rischio): vedi `UBS_U1B_CRITERI_2026-11-10.md`.

Nessun giudizio su acquisti, taglie o lotti.
