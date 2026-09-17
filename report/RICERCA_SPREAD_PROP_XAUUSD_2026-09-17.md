# 🥇 Ricerca costi XAUUSD tra prop firm — 17/09/2026

> Ricerca esterna pura: nessun file di progetto, EA, preset o conto toccato.
> **WebFetch bloccato al 100% anche stavolta** (policy dell'organizzazione,
> non specifica delle prop — verificato con WebFetch e curl diretto via
> proxy, entrambi rifiutati). Solo WebSearch ha funzionato: **ogni numero
> qui sotto è [SECONDARIA]** (letto in uno snippet di ricerca, mai sulla
> pagina ufficiale), tranne l'aritmetica di conversione, che è calcolata da
> zero e verificata con un contro-esempio.

## Il fatto aritmetico che conta

1 lotto standard XAUUSD = 100 once troy. Un movimento di $0,01 = $1,00/lotto.
**Costo spread in USD/lotto = (spread in $/oncia) × 100.** Con spread raw
10-30 cent, il costo vero è **$10-30/lotto** — un ordine di grandezza sopra
quanto molti articoli SEO scrivono (uno di essi, `proptradingvibes.com`,
calcola il costo dell'oro come se un lotto fosse 10 once invece di 100: il
suo "$8,50/lotto" dichiarato torna solo con quell'errore). Conseguenza: **lo
spread pesa 2-8 volte la commissione fissa** sull'oro — la domanda giusta è
"chi ha lo spread più basso", non "chi ha la commissione più bassa", ma è
proprio lo spread che nessuna prop pubblica come numero statico.

## Il ritrovamento che conta: FundedNext scala col prezzo dell'oro

FundedNext è l'unica fra le prop esaminate con una commissione sull'oro
**percentuale sul nozionale**, non fissa per lotto. Il tasso esatto è
**irrisolto** (4 letture incompatibili trovate, dallo stesso help center):

| lettura | costo a oro $4.296/oz (oggi) |
|---|---:|
| 0,0016% (Stellar 1/2-Step, solo apertura) | $6,87/lotto |
| 0,0018% (Stellar Lite) | $7,73/lotto |
| formula "2 × Trade Value × 0,004%" (dal 12/01/2026) | **$34,37/lotto** |
| $7/lotto fisso (Stellar Instant, struttura vecchia) | $7,00/lotto |

Se la formula percentuale è quella vera, il costo **sale con l'oro**: a
$3.000/oz sarebbe $24, al massimo storico di gennaio 2026 ($5.602/oz)
sarebbe $44,82 — **+40% di costo dal 2024 a oggi senza che nessuno cambiasse
un listino.** FTMO invece ha **commissione zero sui metalli**: il costo
totale coincide col solo spread, senza questa seconda voce che cresce da
sola.

## Classifica (confidenza dichiarata per voce — quasi tutto vuoto)

| # | Prop firm | Spread XAUUSD | Commissione oro | Confidenza |
|---|---|---|---|---|
| 1 | FTMO | non pubblicato | $0 sui metalli | commissione [SECONDARIA, 2 fonti] · spread [NULLA] |
| 2 | The5ers | non pubblicato | ~$4/lotto | [SECONDARIA, debole] |
| 3 | Alpha Capital | non pubblicato | CONTRADDITTORIA ($0 vs $5/lotto secondo due fonti) | [NULLA] |
| 4 | FundingPips | non pubblicato | $5-7/lotto FX, oro non specificato | [SECONDARIA, non sull'oro] |
| 5 | FundedNext | "10-25 cent" raw ($10-25/lotto) | PERCENTUALE, irrisolto (vedi sopra) | struttura [SECONDARIA] · tasso [IRRISOLTO] |
| 6-8 | E8/Funded Trading Plus/City Traders Imperium | non trovato | non trovato | [NULLA] |

Due prop **da depennare**: **Fidelcrest** ha cessato operativamente il
4/03/2024 (trader non rimborsati secondo più fonti). **MyForexFunds** è
viva ma reduce da 3 anni di limbo legale (causa CFTC respinta con pregiudizio
il 13/05/2025, CFTC condannata a ~$3,1M di sanzioni, rientro operativo da
aprile 2026) — rischio di controparte alto per una prima challenge.

## Cosa non si è potuto vedere

Ogni pagina ufficiale (ftmo.com, fundednext.com, alphacapitalgroup.uk,
the5ers.com) e i due comparatori di spread live (myfxbook.com/prop-firms-
spreads, fxverify.com/tools/prop-firm-spreads — proprio le fonti giuste per
questa domanda). Nessuno spread medio numerico verificato per nessuna prop.

## Proposta per il numero vero

1. **Misurare lo spread reale sul campo**: conti demo/trial su FTMO,
   FundedNext, Alpha Capital + uno script MQL5 di sola lettura che loggi
   `SymbolInfoInteger(SPREAD)` su XAUUSD per qualche giorno. Costo: poche ore
   di sviluppo + 3-5 giorni di raccolta, zero euro (demo gratuite), zero
   rischio (terminali demo separati, mai i quattro BCM vivi).
2. **Chiedere per iscritto a FundedNext** il tasso commissione esatto su
   XAUUSD prima di comprare qualunque challenge lì — il range letto va da
   $6,87 a $34,37 per lotto, un fattore 5.

## Verdetto (sul dato disponibile, dichiaratamente parziale)

FTMO è la candidata strutturalmente più economica sull'oro perché è l'unica
con commissione zero sui metalli — il costo totale è il solo spread, senza
una seconda voce che cresce con il prezzo dell'oro. Se FTMO abbia anche lo
spread più basso non è verificabile da qui.

## Fonti (tutte SECONDARIA — nessuna aperta direttamente)

- propvator.com/blog/ftmo-trading-conditions/
- allproptradingfirms.com/understanding-spreads-and-commissions-at-ftmo/
- help.fundednext.com (articoli 10701368, 11641300)
- fundednext.com/general-rules/cfds/symbols-and-conditions
- proptradingvibes.com/blog/fundednext-spreads-and-commissions (⚠️ errore aritmetico sul lotto, vedi sopra)
- fxempire.com/prop-firms/the5ers, /alphacapitalgroup
- alphacapitalgroup.uk/symbols
- propvator.com/blog/e8-markets-max-lot-size/
- myfxbook.com/prop-firms-spreads, fxverify.com/tools/prop-firm-spreads (non apribili)
- fxnx.com/en/blog/best-prop-firms-gold-scalping-2026-spread-test
- vettedpropfirms.com/fidelcrest-alternatives/
- financemagnates.com (causa CFTC MyForexFunds)
- forbes.com/advisor/investing/gold-price/ (prezzo oro)
