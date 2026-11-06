# Controllo preliminare: Apex Conservative sul conto reale (06/11/2026) — da fare a mercato chiuso, PRIMA di attaccarlo

**Natura: lista di controllo e criteri scritti prima.** Non attacca niente e non tocca il reale 10105439: i controlli li fa Claudio guardando il terminale; io leggo gli esiti che mi manda. La decisione di attivare Apex, il lotto e la taglia sono di Claudio. Dati di riferimento: `RISULTATI_FOREX_4K_2026-11-05.md` (Apex Conservative a 4.000 EUR) e `CONFRONTO_TRIO_ORO_FOREX_4K_2026-11-05.md`.

## A. Verifiche (da compilare: SI / NO / non so)
| # | Verifica | Dove si guarda | Esito atteso | Esito |
|---|---|---|---|---|
| 1 | Licenza e attivazioni di Wim valgono per il conto reale | Sito/area acquisti di Wim, o prima apertura dell'EA: nel giornale "Esperti" deve comparire "License found" | licenza trovata | |
| 2 | URL consentiti | MT5, Strumenti > Opzioni > Expert Advisor > Consenti WebRequest: `https://forexeasolutions.org` e `https://forexeasolutions.services` | presenti | |
| 3 | I tre simboli esistono sul reale | Market Watch: tasto destro > Simboli, cercare AUDCAD, AUDNZD, NZDCAD; segnare i nomi esatti (suffissi) | stessi nomi del tester | |
| 4 | Specifiche dei simboli: lotto minimo, passo, spread tipico, commissione, swap | Market Watch > tasto destro > Specifiche | lotto minimo 0,01, nessuna commissione extra | |
| 5 | Copia del set verificata | Aprire il set `Apex_ConservativeGrid.set` dal pacchetto di Wim: confrontare i valori della tabella B con la finestra Input dell'EA | tutti uguali | |
| 6 | Il lotto parte da 0,01 sul tuo saldo | Passo lotto 3000 su saldo 3.911: 0,01 | 0,01 | |
| 7 | Il lotto si calcola sul saldo e non sull'equity col bonus | Nel manuale Apex, voce `BalanceToUse` / `BalanceSource` (nel set vale 1); altrimenti primo ordine: se il lotto è 0,02 o più, ferma e scrivimi | NON VERIFICATO | |
| 8 | Magic number | Quello del set è 1999654: deve essere diverso dagli altri EA sul reale (oro: 75000, 8000, ...) | unico | |
| 9 | Il Guardian copre anche Apex | Il Guardian guarda il conto, non il singolo EA: controllare che il totale e il giornaliero siano quelli attuali | attivo, stato OK | |
| 10 | Fuso orario | Set: `AutoGMT` falso, offset 1 e 1 (BCM = GMT+1 fisso): come nel tester | invariato | |
| 11 | Un solo cambio per volta | Nessun'altra modifica ai set oro nello stesso giorno | sì | |
| 12 | Dove gira il terminale reale (PC o VPS) e se regge un EA con 3 grafici in più | Gestione attività del computer | RAM/CPU non vicine al limite | |

## B. Valori del set da confrontare (Apex_ConservativeGrid)
| Parametro | Valore |
|---|---|
| Coppie (`OneChartSetup_Pairs`) | AUDCAD;AUDNZD;NZDCAD; (RunOneChartSetup = true, grafico M15) |
| `LotsizeStep` | 3000 |
| `LotsizeVariation` | 1;1;2; |
| `StartLots` | 0,01 |
| `AutoLotMode` | 3 |
| `OnlyUp` | true |
| `UsePendingOrders` | true |
| `Max_Spread` / `Max_Spread_Delete` | 18 / 23 |
| `MaxAllowedDD` / `MaxAllowedDDPerc` | 0 / 0 (nessuno stop del drawdown dell'EA) |
| `EnableMaxPipsDD` / `HardSLDistance` | true / 2000 |
| `AutoGMT` / offset inverno / estate | false / 1 / 1 |
| `MagicNumber` | 1999654 |
| `ManualBalance` | 0 |

## C. Che cosa ci si aspetta nei primi giorni (dal tester a 4.000 EUR)
| Cosa | Atteso |
|---|---|
| Operazioni (posizioni chiuse) | 35-70 a settimana (1.800-3.600 all'anno) |
| Lotti | 0,01, a volte 0,02 |
| Pendenti | sulle tre coppie, a mercato aperto |
| Giorni con perdita grossa | rari: dal 2020 il peggior giorno è tra −0,2% e −3,7%; nel 2013 e 2017 −20/−25% |
| DD tipico | 10-24% (circa 400-920 EUR) |

## D. Uscite scritte ora (per Apex da solo; la taglia è di Claudio)
| Condizione | Azione |
|---|---|
| Perdita realizzata di un giorno > **10% (circa 390 EUR)** | segnalazione, mi mandi il riepilogo |
| Perdita di Apex dal suo picco > **25% (circa 980 EUR)**, cioè oltre il massimo del tester (23,6%) | si ferma Apex |
| Perdita realizzata di un giorno > **20% (circa 780 EUR)** | si ferma Apex |
| Il Guardian chiude e blocca | si ferma Apex e analisi |
| Lotto > 0,02 al primo ordine, o ordini fuori dalle tre coppie | si ferma e controllo i valori |
| Nessuna operazione per 3 giorni di mercato aperto | verifica licenza/URL/spread |

## E. Registro (una riga per giorno, per le prime due settimane)
| Giorno | Operazioni chiuse | P&L realizzato | Equity min / max | Lotto max | Errori nel giornale | Guardian |
|---|---|---|---|---|---|---|
| | | | | | | |

## F. Previsioni dichiarate ORA (non misurate)
- **P1** Licenza e URL funzionano al primo tentativo: 70%.
- **P2** Nei primi 5 giorni di mercato aperto Apex apre almeno 20 operazioni: 85%.
- **P3** Il lotto resta a 0,01-0,02: 80%.
- **P4** Nessun giorno oltre −10% nelle prime due settimane: 90%.
- **P5** DD di Apex sotto il 15% nelle prime due settimane: 85%.
- **P6** Il netto di Apex dopo due settimane è positivo: 60%.

## G. Limiti
Tester a barre da 1 minuto, un percorso per anno, solo profitti realizzati; swap e slippage reali non simulati; il flottante non è misurato; la verifica 7 è NON VERIFICATO. Il test a 21 mesi del trio oro sul reale è in corso: il risultato può cambiare il quadro del Medium.

## H. Spread e costi: cosa c'è nei numeri e quanto pesano (aggiunto 06/11)
- **Nel tester**: commissioni (come da specifica del simbolo sul demo BCM: circa −2,5 EUR per lotto aperto sull'Apex), swap, e lo **spread memorizzato nello storico M1 del BCM**. Slippage: nessuno (`ExecutionMode=0`).
- **Dubbio sullo spread recente**: nello storico M1 EURUSD lo spread mediano è 4 punti nel 2013, 3 nel 2018, 2 nel 2020 e **0 nel 2025-26 (59% delle barre a zero)**. Gli anni recenti possono quindi sottostimare lo spread reale. Per l'oro 2025-26 la mediana è 21 punti, plausibile. Non ho confrontato lo storico con lo spread vivo del reale.
- **Sensibilità di Apex Conservative**: 22-49 lotti aperti all'anno in 1.800-3.600 operazioni; ogni pip di spread in più rispetto al tester costa circa (lotti aperti x 9 EUR per pip, stima mia):
| Anno | Netto nel tester | Costo di +1 pip | Netto con +1 pip | Netto con +2 pip |
|---|---|---|---|---|
| 2013 | +153 | −441 | −288 | −729 |
| 2017 | +715 | −308 | +407 | +99 |
| 2020 | +1.716 | −369 | +1.347 | +978 |
| 2022 | +1.382 | −295 | +1.087 | +792 |
| 2025 | +913 | −204 | +709 | +505 |
- **Lettura**: se lo spread reale di AUDCAD, AUDNZD e NZDCAD è anche solo 1 pip più largo di quello del tester, Apex Conservative perde il 12-30% del guadagno (e nel 2013 va in negativo). Daytrade Pro Max9 ha costo di +1 pip di circa 50 EUR all'anno: molto meno sensibile.
- **Verifica 4 della sezione A da fare con numeri**: leggere lo spread vivo (colonna Spread del Market Watch, a più orari, e con la sessione asiatica) su AUDCAD, AUDNZD, NZDCAD sul reale. Se la mediana è oltre 1,5 pip, il risultato del tester non regge.
