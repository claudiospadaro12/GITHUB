# Forward demo della Serie 4 (tre conti prop da 80.000 EUR) — PIANO, CRITERI e PREVISIONI (06/11/2026, scritti PRIMA dei numeri)

**Natura: PIANO, non ancora avviato.** Nasce da `ORO_GRADINI_RISULTATI_2026-11-06.md`, dalle combinazioni in `ORO_GRADINI_dati/` (`combo6.py`, `prop3.py`) e dai criteri generali di `CRITERI_FORWARD_DEMO_FOREX_2026-11-05.md`. Il reale 10105439, il trial FTMO e il VPS non vengono toccati da questo piano. Lotti, rischio, acquisti e passaggio a conti a pagamento restano decisioni di Claudio.

## 1. I tre conti (Serie 4: ogni EA su un solo conto)
| Conto | EA e set (file ufficiali di Wim, nessun valore modificato) | Origine nel tester |
|---|---|---|
| **A** | Daytrade Pro `Daytrade_Pro_Max9%DD_lowrisk.set` + The Gold Reaper `Gold_reaper_propfirm_combo_3GOLD.set` | Daytrade Pro Max9 e Reaper L3 Combo |
| **B** | Goldbot One `Goldbot_PropFirm_5_2.5.set` | Goldbot L0 Prop |
| **C** | Gold Trade Pro `Goldtrade_V4.0_prop firm_combo.set` (MaxRiskPerStrategy 0,5, limite giornaliero 4, Risk 3) + The Gold Phantom `GoldPhantom_Propfirm_combo_3GOLD.set` | GTP Combo e Phantom L3 Combo |
Luna 4DD resta fuori: da sola ha DD 25% nel 2013 e supera il 10% totale della FTMO.

## 2. Che cosa ci si aspetta dal tester (2013, 2020, 2025 a 80.000, solo realizzato)
| Conto | Operazioni a settimana | Netto a 8 settimane: peggiore / 10° percentile / mediana | Finestre di 8 settimane in perdita | Peggior giorno | DD sul saldo realizzato (max) |
|---|---|---|---|---|---|
| A | ~20 | −2.662 / −590 / +2.394 (+3,0%) | 16% | −3,2% | 5,0% (cons. 5,0-5,3%) |
| B | ~5 | −1.066 / +219 / +2.064 (+2,6%) | 7% | −2,6% | 2,6% |
| C | ~28 | −1.985 / +233 / +2.698 (+3,4%) | 7% | −3,3% | 5,8% |
Tre conti insieme: giorni in cui tutti e tre perdono nello stesso giorno 36 su 1.096 (3,3%): in 8 settimane (~40 giorni di mercato) ne ho attesi 1-2. Peggior giorno sui tre conti sommati −4.634 (−1,9% di 240.000), DD complessivo sul saldo 3,9%.

**Il tester dice anche che questi set rendono poco in fretta**: la mediana è +2,6/3,4% in 8 settimane, quindi un obiettivo FTMO del 5-10% richiede in genere più di 8 settimane. Il piano misura il funzionamento, non il tempo per superare una challenge.

## 3. Cosa può e non può dire il forward demo
- **Può dire**: se gli EA girano senza errori, se aprono un numero di operazioni coerente col tester sulle stesse settimane, se i costi per operazione sono vicini, se il Guardian scatta, se nei giorni neri i tre conti perdono insieme.
- **Non può dire** se guadagnano: 8 settimane sono pochi dati (Conto B ~40 operazioni). Il netto non è un criterio di promozione, serve come allarme.
- Lo slippage reale non si vede su demo (Wim: «I basically never run demo accounts anymore»).

## 4. Decisioni di Claudio prima di partire
| # | Decisione | Proposta di default | Perché |
|---|---|---|---|
| D1 | Conti | **tre demo nuovi da 80.000 EUR** sul BCM (o dove i prezzi e gli orari del tester coincidono), un terminale per conto | Il tester è calibrato su BCM (GMT+1 fisso). Un conto FTMO di prova è uno solo e scade |
| D2 | Macchina | PC di backtest a tester fermo, oppure VPS dopo la misura di RAM/CPU (3 terminali in più) | Il VPS si è già impallato una volta; i terminali del test occupano il PC |
| D3 | Registro | Guardian su ogni conto + screenshot serale + xlsx storico della domenica; aggiungere i tre terminali al perimetro del runner delle 03:30 (decisione tua) | L'equity minima non è nel report storico |
| D4 | Data di partenza | tu; durata **almeno 8 settimane** (56 giorni) dalla prima operazione | Se parte a novembre include Natale e Capodanno (spread alti) |
| D5 | Guardian | stesso schema del trial: 4,3% giornaliero, 9,3% totale; baseline totale = 80.000 | Come simulato nei test; il dayLoss riparte ogni giorno, il totDD resta fisso (verificato il 06/11) |
| D6 | Replica | io faccio girare nel tester gli stessi set sulle stesse settimane quando il periodo è finito (serve lo storico BCM aggiornato) | È il confronto principale |

## 5. Impostazione
- Set del venditore **non modificati**; SHA256 di ogni file registrato prima della partenza; input mostrati dal terminale confrontati col file.
- Magic number lasciati a quelli del venditore dove non c'è conflitto sullo stesso conto; nessun altro EA sugli stessi conti.
- `AutoGMT` attivo come nei set (nel tester vale `AutoGMT_Backtest` con offset 2/3): l'allineamento con il server del demo è **NON VERIFICATO**; fase A.
- URL consentiti per la licenza di Wim (`forexeasolutions.org`, `forexeasolutions.services`) su ogni terminale. **NON VERIFICATO** che licenza/attivazioni dei 5 EA permettano tre conti demo in più.
- Nessuna modifica ai set durante il test; ogni stop manuale con data e motivo.
- Regole FTMO su più conti con strategie simili e su EA: **non verificate**.

## 6. Fasi
- **Fase A (settimane 1-2)**: tecnica. Nessun errore di licenza/URL/simbolo, orari plausibili, lotti coerenti col set, Guardian attivo e baseline corretta.
- **Fase B (settimane 3-8)**: comportamento. Resoconto settimanale ogni domenica con operazioni, netto, DD, giorni peggiori per conto, giorni con tutti e tre i conti in perdita, costi per operazione.

## 7. Stop (valgono subito)
| Condizione | Azione |
|---|---|
| DD equity di un conto > **8% (6.400)** dal picco | si ferma quel conto, analisi |
| DD equity complessivo dei tre conti > **6% (14.400)** | si fermano tutti |
| Guardian scatta (giorno −4,3% in equity) | registro; **due scatti sullo stesso conto in 8 settimane** = stop e analisi |
| Stop out, righe "no money" o errori di licenza/URL per più di 3 giorni | si ferma l'EA |
| Un EA con >= 5 operazioni a settimana nel tester senza operazioni per due settimane | segnalazione; dopo 4 settimane si ferma |

## 8. Esito dopo le 8 settimane (per ogni conto)
- **PASSA** (decisione sul prossimo passo: di Claudio): tutte vere:
  1. fase A superata;
  2. operazioni live (posizioni chiuse) tra **0,7 e 1,3** volte quelle della replica; minimo assoluto in 8 settimane: A 80, B 20, C 110;
  3. costo medio per operazione <= **1,5 volte** il tester;
  4. DD equity del conto <= **6% (4.800)** per tutte le 8 settimane;
  5. nessuno scatto del Guardian;
  6. netto del conto >= **−2% (−1.600)**.
- **PROLUNGA** di altre 8 settimane: una soglia mancata di poco, DD tra 6% e 8%, netto tra −2% e −4%, o operazioni sotto il minimo.
- **SCARTA o rivedi**: stop scattato, operazioni fuori da 0,5-1,5 volte la replica, costo > 3 volte, netto sotto −4% (−3.200), o comportamento non spiegato.
- La correlazione e i giorni con tutti e tre i conti in perdita si misurano ma **non decidono**.
- "Passa" non vuol dire adatto a una challenge a pagamento: dice che funziona come nel tester per otto settimane.

## 9. Previsioni dichiarate ORA (non misurate)
- **F1** I tre conti operano nella prima settimana senza errori di licenza/URL/simbolo: 65%.
- **F2** Operazioni live tra 0,7 e 1,3 volte la replica su tutti e tre i conti: 50%.
- **F3** Nessuno scatto del Guardian su nessun conto in 8 settimane: 75%.
- **F4** DD equity <= 6% su tutti e tre i conti per le 8 settimane: 75%.
- **F5** Netto positivo su tutti e tre i conti dopo 8 settimane: 60%. Netto positivo sulla somma dei tre: 80%.
- **F6** Il conto A ha il DD più alto dei tre: 55%.
- **F7** Almeno un conto raggiunge +5% (4.000) in 8 settimane: 25%; tutti e tre: 3%.
- **F8** Almeno 3 giorni in cui tutti e tre i conti perdono insieme: 50%.
- **F9** Costo per operazione > 1,5 volte il tester in almeno un EA: 40%.
- **F10** Tutti e tre i conti PASSANO: 25%; almeno due: 55%.

## 10. Limiti dichiarati
- Un conto demo per EA-set, un solo periodo di 8 settimane (una sola finestra), tre EA oro sullo stesso mercato in giorni neri.
- Il tester è a barre da 1 minuto, solo realizzato; il flottante dei conti non è nei riferimenti della sezione 2.
- Spread e commissioni del demo non sono quelli di una challenge FTMO. Server e orari diversi dal BCM non sono misurati.
- Nessun giudizio su acquisti, lotti o taglie.
