# VIVAIO R23 — deploy dei 5 candidati sul demo piccolo (scaletta)

## ✅ ESEGUITO l'11/08 alle 12:45 — verifica meccanica 5/5
Deploy fatto da Claudio coi preset di `deploy_vivaio_r23.ps1`; controllo
campo-per-campo via `verifica_vivaio_r23.ps1` sui .chr salvati:
**TUTTO OK 5/5** (le prime 3 passate al primo colpo; SW GBPUSD mancava
solo il Salva-profilo, sistemato e riverificato). Magic, TF, BE, rischio
e commenti tutti esatti. Il conteggio del vivaio parte da ora:
10 trade/mercato = collaudo, 30/famiglia = verdetto.

Conto: **50503392** (demo piccolo, VECCHIO MT5 — NON il -V3/100k).
Schema: identico al MAXMIN ORO (primo deploy pulito 24/24). Verifica con
screenshot campo-per-campo PRIMA di attivare: la legge dello screenshot
ha beccato errori in 5 deploy su 6.

## CRITERI DEL VIVAIO (congelati ORA, prima del primo trade — accordo
## con Claudio dell'11/08: "10 risultati, 30 e' eccessivo")
- **10 trade PER MERCATO = cancello di COLLAUDO**: il forward somiglia al
  backtest? (spread/slippage, orari giusti, size da 1%, niente
  comportamenti alieni). Un mercato che al collaudo e' un disastro esce
  SUBITO. Superarlo NON promuove: autorizza a continuare.
- **30 trade PER FAMIGLIA = verdetto di promozione al 100k**:
  - famiglia PTE = Dow + GBPUSD + USDJPY sommati (stessa identica
    configurazione H1/BE0,5 su tre mercati: e' UN sistema, ~9 trade/mese
    attesi -> ~3,5 mesi);
  - famiglia SuperWave = Dow + GBPUSD sommati (stessa cella H2, ~12
    trade/mese attesi -> ~2,5 mesi).
  Promozione se la famiglia e' in utile con comportamento da referto E
  nessun singolo mercato e' disastroso. Cosi' i tempi restano umani
  (2,5-3,5 mesi, non anni) e il campione resta statisticamente onesto.
- Il conteggio parte dal primo trade CHIUSO post-deploy; fa fede la
  pagella (commenti sotto).

## I 5 GRAFICI DA APRIRE (tutti input default TRANNE quelli elencati)

| # | EA (Navigatore) | Simbolo | TF grafico | Input da cambiare | Magic | Commento |
|---|---|---|---|---|---|---|
| 1 | ABTG_PTE | U30USD | H1 | InpTF=H1 · InpTP1_ATRmult=0.5 · InpRiskPercent=1.0 | **771321** | PTE DOW |
| 2 | ABTG_PTE | GBPUSD | H1 | InpTF=H1 · InpTP1_ATRmult=0.5 · InpRiskPercent=1.0 | **771322** | PTE GBPUSD |
| 3 | ABTG_PTE | USDJPY | H1 | InpTF=H1 · InpTP1_ATRmult=0.5 · InpRiskPercent=1.0 | **771323** | PTE USDJPY |
| 4 | ABTG_SuperWave | U30USD | H4 | InpTF=H2 · InpRiskPercent=1.0 | **770531** | SW DOW H2 |
| 5 | ABTG_SuperWave | GBPUSD | H4 | InpTF=H2 · InpRiskPercent=1.0 | **770532** | SW GBPUSD H2 |

Magic 771321-23 / 770531-32: VERGINI (verificato su repo+flotta l'11/08).
NON riusare i magic del backtest (771311-16, 770521-24): il forward deve
essere distinguibile dai test nei CSV.

## ⚠️ Prima di attivare, per OGNI grafico
1. Algo Trading verde (bottone globale) e faccina sorridente sul grafico.
2. Screenshot della finestra input -> me lo mandi -> verifica mia
   campo-per-campo (soprattutto: magic giusto, commento giusto, rischio
   1.0, InpTF giusto — sul SuperWave il TF del GRAFICO e' H4 ma
   l'InpTF dell'EA e' H2, non confonderli).
3. A fine deploy: File -> Profili -> Salva (sovrascrivi il profilo).
   La pagella di stasera deve mostrare i 5 commenti nuovi appena operano.

## Note
- PTE e SuperWave BASE erano nella lista dei morti della pulizia del
  10/08 PERCHE' bocciati sul simbolo di casa (XAUUSD/D30EUR): questi 5
  grafici sono celle NUOVE su mercati NUOVI, non una riabilitazione.
  I .ex5 sono ancora installati nel Navigatore (la pulizia toglieva i
  GRAFICI, non la libreria): si riusano quelli.
- Rischio complessivo aggiunto: 5 EA x 1% per trade sul demo piccolo.
  Il portafoglio simulato (R23) dice correlazioni deboli: attese poche
  sovrapposizioni, ma il vivaio serve anche a verificarle dal vivo.
- Verdetti: 10/mercato = collaudo, 30/famiglia = promozione. Scritti
  sopra, non si ritoccano a partita in corso.
