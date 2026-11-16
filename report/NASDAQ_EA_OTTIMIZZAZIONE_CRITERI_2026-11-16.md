# EA sul Nasdaq: criteri e previsioni per l'ottimizzazione (16/11/2026, scritti PRIMA di qualunque numero)

**Natura: CRITERI.** Nessuna passata lanciata. Solo demo e tester; reale 10105439, FTMO e VPS non si toccano; nessun giudizio su lotti, taglie o acquisti. Richiesta di Claudio (16/11): "anche EA sul Nasdaq". Metodo: lo stesso collaudato sull'oro (`UBS_PILOTA_ORO_OTTIMIZZAZIONE_CRITERI_2026-11-15.md` e `RISULTATI_UBS_PILOTA_ORO_GRIGLIA_2026-11-16.md`): griglia da 625 passaggi con TUTTI gli input in `[TesterInputs]`, **controllo bloccante: il passaggio centrale deve coincidere con una passata singola del preset**, poi fuori campione, metà periodo, tick, hold-out.

## 1. Cosa e gia noto (letto, non rimisurato)
- **Censimento del 19/09 (`QUANTI_SIMBOLI_PASSANO`, ramo `lavoro`):** nessuna combinazione sul Nasdaq passa i cancelli (n >= 150 e PF >= 1,10 in entrambe le finestre, DD <= 14%). `SuperWave` x NASUSD M15: bocciata nell'OOS (PF 0,906, 256 operazioni). `WOL` x NASUSD: ferma per campione, **non misurata**.
- **Storico `_EXT` (CLAUDE.md, diagnostica del 04/11):** `NASUSD_EXT` e `SPXUSD_EXT` esistono per **2015, 2020 e 2025-01 -> 2026-07**. Non seguono il server BCM (GMT+1 fisso): **l'apertura USA e a 14:30 anche in inverno**. 2015: 14:30 tutto l'anno; 2020 e 2025-26 (ora di Londra): 14:30, ma **13:30 nelle settimane con USA in ora legale e Europa in ora solare** (fine marzo, fine ottobre-inizio novembre). La convenzione cambia da un blocco di anni all'altro. Nei file `_EXT` `tickvol=1` e `spread=0`: **gli spread vanno modellati**, non ci sono nei dati.
- **Feed dal vivo BCM (NASUSD):** GMT+1 fisso: 15:30 italiane = 15:30 server in inverno e 14:30 server in estate (preset `ABTG_Nasdaq_Apertura_US.set`: 14:30, valido in estate).
- Dal nome e dalle intestazioni (non misurato da me): `Nasdaq_Apertura_US` (breakout di massimi/minimi della candela H1 precedente all'apertura, OCO, parziale 50% a 1R, stop in pari, trailing; modalita gap fill), `Nasdaq_Live5m` (candela dei 5 minuti prima, buffer 700 punti, filtro ampiezza 17-40 punti indice), `ORB` e `ORB_Fibo` (range 14:25-14:30 server).

## 2. Libreria degli orari (CLAU12_ORARI.mqh, in collaudo)
Le aperture si esprimono in ora di **New York (09:30)** e si convertono con la regola USA. **Modello dei DATI `_EXT`:** blocco 2015 = server a UTC+0 d'inverno e UTC+1 d'estate **con regola USA** (spiega "14:30 tutto l'anno"); blocchi 2020 e 2025-26 = **ora di Londra** (UTC+0 / UTC+1, regola UE: spiega i 13:30 delle settimane di scarto). **E una deduzione dai fatti del CLAUDE.md, NON verificata sui dati**: prima di usarla serve la prova (stampare, per alcune date, la barra delle 13:30 e 14:30 e il volume). **Finche l'EA non legge la libreria** le ore restano in ingresso a mano: per i test su `_EXT` si dividono i periodi in settimane "normali" e settimane di scarto, oppure si dichiara il limite.

## 3. Dati e finestre (da fissare DOPO la riga di sola lettura sulla copertura, PRIMA dei numeri)
- **Riga di sola lettura (da preparare):** per NASUSD, NASUSD_EXT, SPXUSD_EXT, U30USD, D30EUR: anni dello storico M1 e mesi dei tick reali, nel terminale principale e nel portable.
- **Regole di partenza (valgono salvo che la copertura le renda impossibili):** dentro-campione = **2015 e 2020** (due blocchi, passate separate sommate); fuori campione = **2025-01 -> 2025-12**; **hold-out = 2026-01 -> 2026-07**, mai aperto prima dei finalisti. Se un blocco ha meno di 100 operazioni per candidato, **non valutabile** (non si abbassa la soglia). **Niente periodi in mezzo tra i blocchi: non si inventano.**
- **Potere statistico basso:** pochi blocchi non contigui, circa 250 giorni di mercato l'uno. Lo dichiaro: un candidato che passa e un'indicazione, non una prova.

## 4. EA e ordine
1. **`Nasdaq_Apertura_US`** (preset di base `ABTG_Nasdaq_Apertura_US.set`; il live 770250 ha il suo preset invernale). 2. **`ORB`** USA. 3. **`Nasdaq_Live5m`**. Per ognuno: **controllo del preset** prima (passata singola sui blocchi: se PF < 1,0 in IS e OOS, **non si ottimizza**: si scrive "motore senza vantaggio misurato").
- **4 parametri liberi, 5 valori ciascuno (625 passaggi), centrati sul preset** (proposta da confermare dopo la lettura del codice): per `Nasdaq_Apertura_US`: `InpBufferPoints` (preset 300: 100/200/300/400/500), `InpTP1_R` (1,0: 0,5/0,75/1,0/1,25/1,5), `InpPendingExpiryMin` (120: 60/90/120/150/180), `InpTP1_ClosePct` (50: 30/40/50/60/70). **Restano fissi:** orari, rischio, lotto, filtri on/off, modalita d'ingresso, trailing. Lotto fisso (non rischio %) per confrontabilita.
- **Costi:** modello di spread per i dati `_EXT` (spread = 0): **stimare dallo spread BCM misurato** (da fare: foto del Market Watch) e dichiarare il valore; sensibilita a +50%.

## 5. Selezione e convalide (come sull'oro)
- Selezione grezza: PF >= 1,30, operazioni >= 100 in entrambi i blocchi dentro-campione, recovery >= 1,5, profitto > 0; zona stabile (>= 70% dei vicini); massimo 10 candidati per rendimento/DD fra combinazioni distinte + C0 (controllo = preset).
- **V1 (OOS 2025):** PF >= 1,20, profitto > 0, recovery >= 1, rendimento/DD >= 1,10 x C0. **V2:** PF >= 1,15 e profitto > 0 in ENTRAMBI i blocchi 2015 e 2020; rapporto DD fra i due <= 2,5. **V3 (tick, se esistono):** PF tick/M1 >= 0,7, DD <= 1,5 x M1, operazioni +-10%. **V4 (hold-out 2026-01/07):** PF >= 1,20, profitto > 0, rend./DD >= C0, **una sola volta**. **Un candidato che non regge in un blocco dove il preset regge non entra.**
- **Contatore di tentativi:** 625 per griglia, sommato al conteggio di campagna (oro 625 + 625 + 33 convalide).

## 6. Previsioni (scritte ora)
- **N-1** La copertura conferma i soli blocchi 2015, 2020, 2025-26 per NASUSD_EXT: 80%.
- **N-2** Il preset `Nasdaq_Apertura_US` ha PF >= 1,10 in tutti i blocchi dentro-campione e in OOS con >= 100 operazioni per blocco: 25%.
- **N-3** La mia deduzione sull'orologio dei dati (Londra / regola USA) si conferma sui dati: 65%.
- **N-4** Almeno un candidato ottimizzato passa V1 e V2: 15% (sull'oro la mia previsione era 25% ed e uscita sbagliata; qui i dati sono piu poveri e il motore non ha mai passato i cancelli).
- **N-5** Almeno un candidato passa anche V4: 5%.
- **N-6** Verdetto per la famiglia Nasdaq: "motore senza vantaggio misurato" 55%, "vantaggio piccolo e fragile" 35%, "candidato credibile" 10%.

## 7. Cosa NON sappiamo
Copertura vera di storico e tick NASUSD sul BCM; se l'orologio `_EXT` segue la deduzione; il costo reale (spread/slippage) sul Nasdaq; se i risultati dal vivo di `Nasdaq_Apertura_US` (770250) e `ORB` (770601) nel ramo `lavoro` dicono qualcosa di diverso (da leggere); se FTMO ha lo stesso orologio del feed BCM per il Nasdaq.
