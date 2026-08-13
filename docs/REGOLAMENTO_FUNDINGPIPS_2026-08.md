# DOSSIER REGOLAMENTO FUNDING PIPS (indagine agente, 13/08/2026)

NOTA METODOLOGICA: fetch diretto delle pagine ufficiali BLOCCATO dal
proxy (fundingpips.com, help.fundingpips.com, freshdesk, archive.org).
Contenuti estratti con ricerche mirate sul testo delle pagine ufficiali
dell'help center: citazioni fedeli ma da ricontrollare aprendo gli URL
prima di qualsiasi acquisto. Fonti secondarie segnalate come tali.

## 1) Struttura programmi (100k)
5 modelli: 1 Step Flex, 2 Step Standard, 2 Step Flex, 2 Step Pro, Zero
(instant). 2 Step Standard: P1 8% (o 10%) / P2 5%, min 3 giorni P1,
tempo illimitato, daily 5%, max 10% STATICO. 2 Step Flex: 10%/6%,
daily 4%, max 12% statico. 1 Step Flex: daily 3%, max 12%. Pro: 6%/6%,
daily 3%, max 6%. Zero: daily 3%, max 5% TRAILING.

## 2) Daily loss / max loss (2 Step Standard)
"The Daily Loss Limit is 5% of the higher value between your opening
balance or opening equity for that day... resets at 00:00 Platform
Time (UTC+3)" -> 5% sul MAGGIORE tra balance/equity di apertura
giornata, floating incluso, reset 00:00 UTC+3 (~23:00 IT estate).
Max Loss: "10% of the starting account size... static floor that never
moves... including floating losses" -> statico, identico su Master.

## 3) EA e pratiche vietate (Trading Conduct and Security Standards)
Vietati: "gap trading, high-frequency trading, server spamming,
latency arbitrage, toxic trading flow, hedging, long-short arbitrage,
reverse arbitrage, tick scalping, server execution exploits, opposite
account trading, churning and burning". Copy tra utenti diversi e
gestione da terzi = termination.
EA di TERZI: solo come trade/risk manager, MAI per generare trade.
EA PROPRIETARI: automazione completa ammessa con prova di proprieta'
(fonte secondaria + vecchia pagina Freshdesk) -> DA CONFERMARE SCRITTO.
Martingala/grid: NON nominati -> ambiguo.
"Gap trading" definito: "opening trades shortly before a market closes
in order to exploit potential price gaps after it reopens" -> la
lettera non copre l'ingresso ALLA riapertura -> AMBIGUO, chiedere.

## 4) News
Valutazione: nessuna restrizione. Master (1/2 Step, Pro): profitti da
trade aperti/chiusi entro +-5 min da red news sulla valuta = DECURTATI
(intero profitto del trade), salvo trade aperto >=5h prima. Non e'
breach (soft). Zero: +-10 min HARD BREACH. SL/TP eseguiti in finestra
= "closed within window" -> decurtazione: ambiguo, chiedere. NESSUN
conto esente stile FTMO Swing.

## 5) Overnight/weekend — IL PUNTO CHIAVE
Overnight: ok ovunque. Weekend in valutazione: permesso.
WEEKEND SU TUTTI I MASTER: VIETATO dal 29/01/2026 ("temporaneamente",
ancora in vigore a giu-2026): auto-close il venerdi', non e' breach ma
la strategia muore. Zero: weekend = hard breach. Apertura alla
riapertura domenicale: nessun divieto esplicito MA vedi gap trading.

## 6) Consistency + "Risk Per Trade Idea"
Nessuna consistency in valutazione. Consistency Score 35% solo sui
reward On-Demand (payout trattenuto). Zero: 15% + 7 giorni
profittevoli/30gg. 1 Step Flex: 4 giorni >=0,5% per reward.
RISK PER TRADE IDEA (Master >=25k): max 2% di perdita combinata per
"idea" ("a single trade; splitting a trade into multiple positions; or
the same trade idea (opening a new position within 10 minutes in the
same direction)") -> HARD BREACH immediato, i profitti altrui non
compensano. Nota ambigua "under 10% Profit Target only" -> chiedere.

## 7) Conti multipli
$400k max totali; merge dal dashboard; copy tra PROPRI conti stessa
direzione ok; direzioni opposte tra conti = vietato; copy tra utenti
diversi = vietato. Altre prop firm: nessun divieto trovato -> scritto.

## 8) Economics 100k
2-Step ~$499 (fonte secondaria). Refund dopo il 4° payout (secondaria).
Split Standard per ciclo: Weekly 60% / Bi-weekly 80% / Monthly 100% /
On-Demand 90% (con consistency 35% + min 2%). Pro 80% weekly. Flex
85/95% bi-weekly. Zero 95%. Scaling: PRIME fino a $2M ma trailing 8%.

## 9) Piattaforme
MT5 (di nuovo da mar-2025), cTrader, Match-Trader. UTC+3. Leva 1:100
forex. Commissioni $5/lotto forex+metalli, indici/energie zero.
Broker/feed attuale non dichiarato.

## 10) Reputazione e storia
Feb-2024: MetaQuotes stacca MT5 (grey-label BlackBull) -> migrazione
piattaforme, MT5 tornato mar-2025. Trustpilot ~4.5/5 (51k+ rec.),
$260M+ payout dichiarati. Lamentele 2025-26: chiusure per Risk Per
Trade Idea, PRIME peggiorato (trailing), weekend ban improvviso
29/01/26 -> RISCHIO REGOLAMENTARE: cambi regole retroattivi sui funded.

## Pericoli per il NOSTRO portafoglio
1. Weekend ban sui Master -> gap-fill e notturni weekend MORTI da funded.
2. "Gap trading" vietato esplicitamente -> famiglia domenicale a
   rischio terminazione anche in valutazione.
3. Risk Per Trade Idea 2% hard breach: ingressi stessa direzione entro
   10 min si SOMMANO (0,65x3=1,95%).
4. News senza filtro: profitti decurtati (Master) / conto chiuso (Zero).
5. "Hedging" vietato genericamente: bracket OCO a rischio interpretativo.
6. Reset daily 00:00 UTC+3 != BCM: giornata di rischio da ricalcolare.
7. Storia di cambi regole improvvisi sui funded.
OK invece: 5-8 posizioni simultanee su strumenti diversi, mono-direzione,
no HFT/martingala, replica su altre firm (probabile, da confermare).

## Confronto finale (per NOI)
FTMO 2-Step+Swing NETTAMENTE meglio: weekend+news liberi, zero
consistency, regole stabili. The5ers in mezzo. Funding Pips: solo
eventuale sotto-famiglia intraday senza gap-fill su 2 Step Flex, con
filtro news e cap 2%/strumento/10min — e solo dopo risposte scritte.
