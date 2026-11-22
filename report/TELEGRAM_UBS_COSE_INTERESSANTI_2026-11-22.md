# Gruppo Telegram UBS e prop firm: cose interessanti (lettura del 22/11/2026, dal 13/11)
Fonti: letture in sola lettura del Claude del browser (file in `telegram_ubs_2026-11-22/`) e pagine ufficiali FTMO. Tutto cio che viene da utenti del gruppo e **testimonianza non verificata**.

## UBS Optimizer App (strumento di Wim)
- **Dove si scarica:** nessun link: file `.exe` (circa 71 MB) allegato da Wim nell'argomento "UBS Optimizer App". Ultima versione vista: **18/11 10:17** (`UBS Optimizer…p_20261118.exe`); il 17/11 "updated for UBS 9.8". Versioni: 1.4 (14/11), 1.5/1.6 (15/11).
- **Requisito:** l'MT5 usato dall'app deve stare **fuori da `Program Files`** (Wim, 16/11 e 20/11). Il nostro terminale principale e li; il portatile `C:\MT5_BCM_Opt` no.
- **Cosa fa:** stress test dei set (anche a tick reali), costruzione di portafogli bilanciati, "Run backtest in MT5" del portafoglio con l'autoloader, assistente AI via MCP, piu di 350 set gia testati nella libreria. Wim: "I do 1M OHLC for longterm tests, and realticks for comparison" (come noi).
- **Library pack:** "UBS Library pack 2026-11-14.zip" (43,5 MB). "UPDATED SETS UBS_V9.8.zip" (5,6 MB, 18/11).
- **Wim sui prop:** "there are no prop firms set files for UBS" (18/11).

## "Invalid stops" e versione 9.8
Nessun messaggio sul passo del prezzo degli indici, su "Invalid stops" o su cosa cambia nella 9.8 (solo "latest UBS version fixed some issues in autoloader for range breakout", 15/11). **Da chiedere a Wim.**

## Backtest di Zairex_ (`Full back test UBS.rar`, 41,8 MB, pubblicato il 26/08/2026, NON scaricato)
Vantage, tick reali 100%, **2020 - 22/08/2026**, ritardo 5 ms, 312 set (320 originali), autoloader di Wim **rischio per strategia = 3** (lotti variabili; proporzione per riportare a 0,1 lotti). Deposito e lotti non indicati. Sergio ha allegato `UBS_sets_profit_factor.xlsx` (39 KB, "ordered by profit factor", 26/08 15:17): **da scaricare a mano e allegare senza aprirlo** se vogliamo il PF di tutti i set (inclusi i Dow M15 come `g`) su un altro broker.

## Prop firm: voci della comunita (non verificate)
- FTMO: "I got banned in the end" (con Gold Reaper e GTP; 4% / 3% di risultato, 6% di DD totale), "FTMO ban me (no EAs)", "I wouldn't trust EAs on it", "FTMO is great for manual".
- **Concept Trading e iFunds** indicate come EA-friendly: "10% max DD, no daily DD, EAs, news trading e weekend ammessi" (da verificare sui loro siti: prompt in `PROMPT_PROP_CONCEPT_IFUNDS` nella chat del 22/11).
- **Pagine ufficiali FTMO (letta il 22/11):** EA ammessi; avvertono che altri trader possono usare lo stesso EA e chiedono una **strategia unica**, niente copy trading fra registrazioni; vietati software/strumenti che danno un vantaggio sleale, **EA con piu di 2.000 richieste al server al giorno**, coperture fra conti; per i conti futures e live regole piu dure sul copiare le decisioni di terzi. Fonti: ftmo.com/en/forbidden-trading-practices, /faq/which-instruments-can-i-trade-and-what-strategies-am-i-allowed-to-use, /faq/how-many-accounts-can-i-have, /blog/what-to-look-out-for-when-choosing-an-expert-advisor.

## Altro
- **Range Reaper** (EA di Wim, 20/11, 99 $ per 24 ore, solo MQL5): sostituisce ORB Master; basato sui set di BK (breakout di range, 11 mercati inclusi indici). BK sul rischio per strategia: "does not account for SL sizes... for range breakout the SL size is based on the Range": con range grande e lotti grandi la perdita e grande (stesso effetto del giorno peggiore del Dow: -7% in un giorno).
- **Community Share di Till (21/11):** 10 set oro H1 (G50449, G50455, G50482, G50561, G50601, G80381, G80388, G80449, G80480, G80482), correlazioni 0,40-0,74: una famiglia sola (non li abbiamo ancora testati). Portafoglio "UBSChristmas" (Till, da Mistermember).
- Altri pacchetti: BOOMONE (7 set Boom/Crash solo ICTrading), UBS-V9.8, RangeReaper.zip (6,3 MB: statistiche).

## Zairex Community Pack (pagina HTML allegata da Claudio il 22/11; letta come testo, nessuno script, nessun link esterno oltre ai font)
14 set UBS di Wim (12 oro, BTC H1/Reaper) con le sole USCITE rioptimizzate (10 parametri Exit_*: stop, target, trailing, breakeven), allenate su 2021-01-01 -> 2024-03-01, provate su 2024-03-08 -> 2026-08-22 (Vantage, tick reali 100%, 100.000 per test). Dichiarato: pacchetto +53% sul periodo "mai visto", DD massimo 4,35%, PF 1,74, 3.984 operazioni; "ogni set batte il suo originale" (PF su 13 su 14, DD piu basso in 11 su 14).
**Lettura critica:** (1) "A set only made this pack if it came out ahead there": il filtro e fatto sul periodo "non visto", quindi non e piu fuori campione: i numeri sono gonfiati dalla selezione; (2) 12 set su 14 sono oro: una famiglia sola, quasi la stessa operazione ripetuta (come i 10 set oro di Till); (3) oro in forte salita nel periodo: qualunque inseguitore di trend guadagna; (4) sono set di Wim (Goldbot One, GTP) con uscite cambiate: per FTMO resta il problema della strategia non unica; (5) 2 anni e mezzo, un solo broker. **Utile come idea** (le uscite pesano molto: BTC H1_N +406% di profitto, +259% di DD), **non come flotta**: il metodo che usiamo noi (cancelli V1-V4 senza scegliere sul periodo di verifica) e piu prudente.
