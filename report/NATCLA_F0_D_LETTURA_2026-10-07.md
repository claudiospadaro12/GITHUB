# NATCLA F0 - lotto D (XAGUSD, EURJPY, EURCHF) - lettura del 07/10/2026

Fonte: `backtest_pipeline/risultati_archivio/NATCLA_F0_D_20261007/` (zip di Claudio, PC di backtest DESKTOP-H4D7CAJ, BCM demo 50503392, pin e2f0506b, EA v1.04, 20:55-21:03).
Lettore: `backtest_pipeline/leggi_natcla_f0.py` (autotest 87/87). Modello 1 OHLC M1, InpSoloConta: NESSUN PF, NESSUN DD, NESSUN merito.

## Fatti
- 18 passate su 18 OK (3 simboli x 6 configurazioni), 28-33 s a passata. VERIFICA ADX: MetaQuotes 18/18. Compilazione 0/0.
- Setup totali per famiglia (3 simboli): AUDIO_H1 1362, AUDIO_H4 315, AUDIO_H12 121, AUDIO_D1 65, M2_H1 1216, M2_H4 354. Soglia E3 = 300: SOPRA per H1/H4/M2; SOTTO per H12/D1 (merito sospeso per n; rischio si giudica lo stesso).
- Costo (stop >= 40 x pedaggio, con commissione): **XAGUSD PASSA IL LAVORO su tutte le sei configurazioni**; EURCHF FRAGILE su H1/H4/M2 e ESCLUSO PER COSTO su H12/D1; EURJPY ESCLUSO PER COSTO ovunque (senza commissione FRAGILE). Esclusione PER COSTO = numero in tabella del lettore, non PF.
- Regime (proxy prezzo linea primo->ultimo tocco, AUDIO_H1): XAGUSD +85,3% (regime di forte rialzo: un solo regime), EURJPY +5,7%, EURCHF -5,2%.
- Orologio forex: setup prima/dubbia/dopo il cambio 26/12/2024-02/02/2025 letti dal lettore; sono solo conteggi.

## Non misurato / da non leggere troppo
- Nessun PF/DD (Modello 1 puo' solo bocciare). Il passo 1 (tick reali) non e' partito.
- 171 righe-ordine con stop_ped dell'EA fuori tolleranza rispetto a |p-SL|/spread (lotto B: 740). Causa NON indagata; in SoloConta non muove ordini, ma il costo in tabella usa lo spread del CSV: da chiarire prima di fidarsi del bordo FRAGILE.
- XAGUSD: una finestra con un solo regime e +85% -> setup abbondanti non provano nulla sul merito.
- Nessuno spread_vivo: 28 simboli senza misura dello spread vivo.
