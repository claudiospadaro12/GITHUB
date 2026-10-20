# Triage dei Market "popolari" con agenti: criteri scritti PRIMA di leggere le pagine (20/10/2026)

**Non controllata da agenti (il documento); le schede le compilano agenti, i loro rapporti sono DICHIARAZIONI che il coordinatore ri-verifica a campione.** Richiesta di Claudio: "di questi EA + popolari sul Market, cosa testiamo? riesci con gli agenti a fare le analisi per capire quale puo' fare al caso nostro?" (3 screenshot della classifica Popolare, 20/10/2026).
## Gia' misurati (esclusi dal triage)
The Gold Reaper, Prop Firm Gold EA, Smart Gold Hunter, EA Super Trend XAUUSD, TitanForge, Quantum Titan/iGold/Commander/Emperor, PolyGold, AI Golden Life, My AI Gold, Gold Beaver, Drifter, Dynamic Liquidity Intelligence, Ghost Scalper, Pac Man BTC, Scalping Robot Pro, Ultimate Breakout, Wave Rider, Waka Waka, Institutional SMC Robot, Nebula, Gold Trade Pro, Goldbot One, Gold Phantom, The ORB Master, DayTrade Pro. Cripto-solo (Bitcoin Chill, Scalping di Bitcoin, Consenso Btcusd, Bestia di Ethereum) fuori scopo.
## Cosa serve a Claudio
Un EA che, a 80.000 EUR e con regole prop, **passi le soglie S-* nel tester** e sia **poco correlato** con Gold Reaper/Prop Firm (le soglie: S-N >= 150 operazioni in 21 mesi, S-M >= 60% mesi positivi, S-DD <= 10% dal deposito, S-NOSCALA, S-COSTO >= 3x spread, S-CORR <= 0,5, S-PORT). Il triage NON misura niente: serve a scegliere quali **demo installare** per il tester (il tester gira solo sugli EA installati sul terminale BCM).
## Regole di classificazione (indipendenti dal prezzo e dal profitto dichiarato)
- **C (scarto)** se almeno una: griglia / martingala / averaging / "recovery" / raddoppio dopo perdita (dichiarato, o visibile nel signal: posizioni aperte che si accumulano contro il prezzo, equity DD molto piu' grande del balance DD); nessuno stop loss per operazione; solo crypto; nessuna informazione sulla logica E nessun signal e nessun backtest verificabile; promessa "garantita"/"IA" senza meccanismo e senza prova.
- **A (installare la demo e testare ora)** se: nessun flag C, **e** almeno una evidenza esterna (signal MQL5 pubblico di almeno 20 settimane con DD dichiarato < 25%, oppure backtest con ticks reali documentato con numeri coerenti) **e** meccanismo descritto plausibile.
- **B (forse)**: nessun flag C ma evidenza debole o assente.
- Segnalare comunque: scalper (sensibile a spread/latenza: S-COSTO), uno SL molto piu' largo del TP (coda: % vincenti alta ma perdite grandi), dipendenze da URL/calendario (non funzionano nel tester), simboli non disponibili su BCM, prezzo/affitto, preset/file .set scaricabili, recensioni critiche (testo).
- **Bonus decorrelazione** (annotare, non cambia la classe): indici o forex invece di oro.
## Cosa NON si fa
Nessun consiglio di acquisto e nessuna taglia (decisioni di Claudio); nessuna previsione di rendimento; ogni dato con la fonte (URL); cio' che non si e' potuto leggere = [NON VERIFICATO].
