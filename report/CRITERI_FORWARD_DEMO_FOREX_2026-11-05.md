# Forward demo dei candidati forex di Wim — CRITERI e PREVISIONI (05/11/2026, scritti PRIMA dei numeri)

**Natura: CRITERI, non ancora avviato.** Nasce da `RISULTATI_FOREX_4K_2026-11-05.md` (7 candidati su 70 passate) e da `CONFRONTO_TRIO_ORO_FOREX_4K_2026-11-05.md` (correlazione col trio oro). Il reale 10105439 e il trial FTMO non vengono toccati da questo test. Lotti, rischio e passaggio al reale restano decisioni di Claudio: qui si decide solo cosa si misura e quando si ferma.

## 1. Cosa può e cosa non può dire un forward demo di 8 settimane
- **Può dire**: se l'EA gira senza errori (licenza, URL, orari, margine), se apre un numero di operazioni coerente col tester sulle stesse settimane, se i costi reali per operazione (spread, commissioni, swap) sono vicini a quelli del tester, se qualcosa va storto in modo grosso.
- **Non può dire** se l'EA guadagna. Operazioni attese in 8 settimane (dal tester): Daytrade Pro ~65-75, Luna ~100-145, Stability low ~70-170, Apex Conservative ~275-560. Pochi per un giudizio di profitto. Il netto non è un criterio di promozione, serve solo come allarme.
- Lo slippage dell'esecuzione reale non si vede su un conto demo (Wim: "I basically never run demo accounts anymore"). Il test misura il funzionamento, non l'esecuzione.
- Il confronto principale è con una **replica nel tester** sulle stesse settimane (stesso set, stesso deposito, Modello 1): le differenze tra live-demo e replica sono il risultato, non il profitto in sé.

## 2. Decisioni di Claudio prima di partire (le mie proposte di default sono sotto)
| # | Decisione | Proposta di default | Perché |
|---|---|---|---|
| D1 | Quali set | **uno per EA**: Stability Pro `low risk`, Luna `4DD`, Apex `ConservativeGrid`, Daytrade Pro `Max20 medium` | Set dello stesso EA fanno le stesse operazioni (Apex 3.623 nel 2013 in tutti e 5 i set; Daytrade Pro 383 in tutti e 3): cambia solo il lotto. Provarne più d'uno dello stesso EA aggiunge poco. Il salto di rischio (es. Daytrade Pro `Max50`) viene dopo, a EA validato |
| D2 | Dove | un conto demo BCM nuovo da **4.000 EUR** con tutti e 4 gli EA (come nel reale), magic diversi tra loro e da ogni altro EA e `_Ottimizzato` | Misura anche l'effetto del portafoglio. Il DD per singolo EA si ricostruisce solo dalle operazioni, non dall'equity |
| D3 | Su quale macchina | **VPS** (regola del progetto: gli EA girano in forward sul VPS), ma solo dopo aver misurato RAM/CPU con un terminale in più (coda aperta) | Il VPS si è impallato; un quinto terminale peggiora. Alternativa: PC di backtest a tester fermo |
| D4 | Registro dell'equity | screenshot serale di saldo/equity/margine **più** il report storico xlsx settimanale (come quelli del 05/11). Se vuoi il minimo/massimo giornaliero senza screenshot posso scrivere un piccolo logger (richiede la tua approvazione) | Il report storico non contiene l'equity minima: senza registro il DD in equity non si misura |
| D5 | Data di partenza | tu; il test dura **almeno 8 settimane** (56 giorni) dalla prima operazione. Se parte a novembre include Natale/Capodanno (spread alti, liquidità bassa): lo segno nel referto | |

## 3. Impostazione (uguale per tutti)
- Set del venditore **non modificati** (tutti i valori del file `.set` già usato nei 70 test). Registro lo SHA256 di ogni set prima della partenza e confronto gli input mostrati dal terminale con il file.
- Per replicare il tester: Apex e Luna con `AutoGMT=false` e offset 1/1 (BCM è GMT+1 fisso, come nel tester). Usare `AutoGMT=true` dal vivo è una prova separata, non in questo giro.
- Gli EA di Wim richiedono gli URL consentiti (`forexeasolutions.org`, `forexeasolutions.services`) per la licenza. **NON VERIFICATO** che licenza/attivazioni dei 4 EA permettano un ulteriore conto demo: da controllare prima di partire (fase A).
- Orario Luna: la finestra del venditore è "23:00-01:00 server ICMarkets" = 21-23 GMT; con offset 1/1 il tester l'ha tradotta in un orario BCM che **non ho verificato** (voce già in coda). Fase A: confrontare l'orario delle prime operazioni live con quello del tester.
- Cambio d'ora: BCM resta GMT+1 fisso (regola del progetto). Se un EA ha orari in GMT, controllare i cambi d'ora di fine marzo/ottobre (non toccano un test che finisce a gennaio).
- Nessuna modifica ai set durante il test. Se un EA va fermato a mano, lo annoto con data e motivo; non si riparte "come nuovo".

## 4. Cosa si registra
Ogni sera: saldo, equity, margine libero e livello di margine, operazioni aperte e chiuse per magic, eventuali errori nel giornale Esperti. Ogni domenica: report storico xlsx del conto. A fine test: replica nel tester per le stesse settimane con gli stessi quattro set, e confronto operazione per operazione (conteggi, direzione, orario) e costi per operazione.

## 5. Stop (valgono subito, in ogni momento)
| Condizione | Azione |
|---|---|
| DD equity del conto > **35% (1.400 EUR)** dal picco | si fermano tutti e 4 gli EA, referto e analisi prima di ripartire |
| Perdita in un giorno > **15% (600 EUR)** | si ferma l'EA responsabile, analisi |
| Stop out, o righe "no money" ricorrenti | si ferma, analisi |
| Livello di margine < **300%** | segnalazione; sotto 150% si ferma |
| Errori di licenza/URL/esecuzione ricorrenti per più di 3 giorni | si ferma l'EA, la causa va chiarita prima |
| Operazioni mai aperte in due settimane consecutive da un EA che ne apre in media almeno 5 a settimana nel tester | segnalazione; dopo 4 settimane senza operazioni si ferma |
Soglie fissate adesso: sul DD, 35% è il limite del criterio "candidato" dei 70 test; 15% in un giorno è sotto i -20/-25% che Apex ha fatto nel 2013 e 2017.

## 6. Riferimenti storici dei 4 set sommati (realizzato, tester, per calibrare le soglie)
Somma dei quattro set scelti come se fossero un conto unico da 4.000 (corse indipendenti, solo realizzato, flottante non incluso):
| Anno | Netto | DD sul saldo realizzato | Peggior giorno | Peggior finestra di 8 settimane | Finestre di 8 settimane in perdita |
|---|---|---|---|---|---|
| 2013 | +2.382 | 1.193 | -1.003 | -701 | 29% |
| 2017 | +2.778 | 832 | -803 | -418 | 21% |
| 2020 | +5.922 | 329 | -157 | +190 | 0% |
| 2022 | +5.328 | 322 | -306 | +275 | 0% |
| 2025 | +2.737 | 218 | -153 | +212 | 0% |
Nel 2013 e 2017 il peggio viene da un solo giorno di Apex (chiusura griglia in perdita) e, nel 2013, da Luna in perdita. Da 2020 in poi le finestre di 8 settimane non sono mai negative in questo insieme. Un test di 8 settimane copre quindi **una sola finestra**: non rappresenta il peggio storico.

## 7. Esito dopo le 8 settimane (per ogni EA e per il conto)
- **PASSA al passo successivo** (decisione sul reale e sul lotto: di Claudio): tutte vere:
  1. fase A superata (nessun errore, licenza e orari coerenti);
  2. operazioni live (posizioni chiuse) tra **0,7 e 1,3** volte quelle della replica nel tester sulle stesse settimane, e almeno il 70% delle operazioni live ha una controparte nella replica (stessa direzione, apertura entro 15 minuti dalla replica);
  3. costo medio per operazione (spread + commissioni + swap) live **<= 1,5 volte** quello del tester;
  4. DD equity del conto **<= 20% (800 EUR)** per tutte le 8 settimane; nessuno stop;
  5. netto del conto **>= -5% (-200 EUR)**.
  Numero minimo di operazioni per singolo EA, altrimenti l'EA resta "non valutabile" e si prolunga: Daytrade Pro 35, Luna 55, Stability low 35, Apex Conservative 140.
- **PROLUNGA** di altre 8 settimane: se una soglia è mancata di poco, DD tra 20% e 35%, netto tra -5% e -10%, o numero di operazioni insufficiente.
- **SCARTA o rimanda alla revisione**: uno stop scattato, operazioni live fuori da 0,5-1,5 volte la replica, costo > 3 volte il tester, netto sotto -10% (-400 EUR), o un comportamento non spiegato.
- La correlazione coi P&L giornalieri del trio sul reale (dal 05/11 con i set Medium, non più i set a 3.745 testati) si misura ma **non decide**: con 56 giorni l'errore standard è circa 0,13. Segnalo |r| > 0,30 (due volte lo scarto), non lo uso per promuovere o scartare. Daytrade Pro è atteso più correlato per la gamba oro (0,5-0,66 sulla sola gamba).
- "Passa" non significa "adatto al reale": significa che funziona come nel tester per otto settimane, senza dire nulla sui prossimi mesi.

## 8. Previsioni dichiarate ORA (non misurate)
- **F1** I 4 EA aprono operazioni nella prima settimana senza errori di licenza/URL: 70%.
- **F2** Le operazioni live sono tra 0,7 e 1,3 volte la replica per almeno 3 EA su 4: 55%.
- **F3** DD equity del conto <= 20% in tutte le 8 settimane: 75%.
- **F4** Netto del conto dopo 8 settimane > 0: 70% (le finestre in perdita storiche: 21-29% nel 2013/17, 0% dopo).
- **F5** Almeno un EA con costo per operazione > 1,5 volte il tester: 40%.
- **F6** Apex Conservative ha un giorno peggiore di -10% (-400 EUR) in 8 settimane: 7% (storia: 2 giorni nel 2013, 1 nel 2017, 0 dopo).
- **F7** Nessuno stop scatta nelle 8 settimane: 70%.
- **F8** Tutti e 4 gli EA PASSANO: 30%. Almeno 3 su 4: 55%. Almeno uno prolungato o scartato: 70%.
- **F9** Luna: orario delle prime operazioni live coincidente con quello del tester: **nessuna previsione** (il tester non è mai stato confrontato con la finestra del venditore).

## 9. Limiti dichiarati
- Un conto demo, un periodo di 8 settimane, 4 EA insieme sullo stesso saldo (lotti calcolati sul saldo comune). Il DD per singolo EA non si legge dall'equity.
- I set sono quelli del venditore pensati per EA singolo: Wim consiglia di ridurre il rischio quando girano insieme più suoi EA (3 EA a 1/3 del rischio, 4 a 1/4, per i suoi combo oro). La regola è scritta per EA sullo stesso mercato; qui sono mercati diversi ma **non verificato** se la regola vale. Il test mostra il comportamento a rischio pieno, non un portafoglio calibrato.
- Replica nel tester: Modello 1 (barre di 1 minuto), nessuno slippage; spread e commissioni del tester non confrontati con quelli reali BCM (il confronto dei costi serve a questo).
- Leva e margine reali del conto BCM non verificati (leva del tester 1:100). Il bonus di 2.500 del reale non c'è sulla demo.
- Nessun giudizio su acquisto, lotto o taglia del conto reale.
