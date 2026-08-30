# Offerta prop DA ANALIZZARE (Claudio, 30/08 - "analizza dopo")

Screenshot: `docs/prop_offerte/OrbitFunded_1M_instant_20260830.jpg` (ad sponsorizzato).

## DATI CHIAVE LETTI DALL'IMMAGINE
- **Firm**: Orbit Funded Prop
- **Prodotto**: **1M INSTANT ACCESS - NO CHALLENGE** (conto finanziato subito, niente fase di verifica)
- **Prezzo**: **$999** (coupon `WELCOME` = 10% OFF -> ~$899)
- **Max Drawdown**: **10% STATIC (No Trailing)** <- rilevante: statico, non trailing (piu' gestibile del trailing)
- **Daily Drawdown**: **5%**
- **Consistency**: **NO** (nessuna regola di consistenza)
- Claim marketing: "the best conditions for instant access"

## DA VERIFICARE NELL'ANALISI (dopo, quando Claudio lo chiede)
- Il modello "instant funding" e' spesso un prodotto diverso dalla vera prop: profit
  split, primi payout, refundable/non-refundable, regole nascoste nei ToS.
- Static 10% DD + 5% daily + no consistency + no challenge: MAPPARE sui nostri metri
  (METRO_PROP: -5% daily uccide; cap rischio aperto flotta 3.25%). Con 5% daily e 10%
  static, la nostra flotta a 0.65%/sedia ci sta comoda? Quante sedie in parallelo?
- Reputazione firm (payout reali, non solo marketing), regole EA/algo consentite,
  news trading, weekend holding, tempo minimo, min trading days.
- Confronto con FTMO 2-step (il nostro dry-run attuale 50504263) e col resto del piano prop.
- Chi analizza: cacciatore-config-prop (regole ufficiali) + architetto-prop (incastro flotta).
