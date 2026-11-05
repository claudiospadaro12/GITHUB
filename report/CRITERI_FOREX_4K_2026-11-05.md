# 4 EA forex di Wim alla taglia del conto reale (4.000 EUR) — CRITERI e PREVISIONI (05/11/2026, scritti PRIMA dei numeri)

**Natura: CRITERI, non ancora lanciato.** Richiesta di Claudio (05/11): vuole far crescere il conto reale (quasi 4.000 EUR), accetta fino al 50% di DD ("a me non importa, mi piacerebbe farlo crescere"). Il reale 10105439 non lo tocco io: lotti, rischio ed EA li decide Claudio. Questo e' solo un test nel tester sul conto virtuale.

## Perche' si rifa a 4.000 EUR
I test a 80k hanno fatto crescere i lotti col saldo (set "per saldo" pensati per conti piccoli): profitti e DD a 80k NON si trasferiscono a 4k (Apex `extremerisk` +1.072.063 nel 2020, ma -52k nel 2013, -27k nel 2017, -60k nel 2025). A 4.000 EUR i set girano alla taglia per cui sono disegnati e pesa il lotto minimo 0,01.

## Cosa si testa
- 4 EA: Daytrade Pro (D1), Luna AI Pro (M5, EURUSD con OneChartSetup), Stability Pro (M5), Apex Trader (M15). **14 set** del venditore, tutti i valori del set (nessun input forzato); il set `daytradePro_Prop` e' identico al `lowrisk` (stessi numeri a 80k) e non si ripete.
- 5 anni: 2025, 2022, 2020, 2017, 2013 (gli stessi del test a 80k, per confrontare). **70 passate**, deposito **4.000 EUR**, Modello 1 (barre 1 minuto), terminale BCM, solo tester. Indicement e ORB Master NON in questo giro (un solo periodo, perdono o pareggiano; vanno rifatti dopo con orari verificati).

## Cosa si misura
Per ogni passata: netto e rendimento % sul conto, PF, operazioni, DD equity relativa massima (% del conto) e assoluta (EUR), peggior giorno realizzato, giorni <= -10%, stop out e righe "no money", quota di operazioni al lotto minimo 0,01, conto finale. Confronto con la stessa passata a 80k.

## Criteri di lettura (fissati ora, sul limite dichiarato da Claudio: 50% di DD)
- **SCARTATO**: in almeno un anno DD equity relativa > 50% o conto finale < 2.000 EUR o stop out.
- **ZONA GRIGIA**: DD relativa massima fra 35% e 50% in almeno un anno (nessuno scartato). Non e' "candidato": il DD reale puo' essere 20-30% peggiore dello storico (Wim), quindi 35-50% nel test puo' diventare piu' del 50%.
- **CANDIDATO PER IL FORWARD IN DEMO**: DD relativa massima <= 35% in TUTTI gli anni **e** netto > 0 in almeno 4 anni su 5 **e** nessun anno con stop out. Candidato non vuol dire "adatto al reale": vuol dire "degno di 4-8 settimane di forward in demo, con magic diversi".
- Mai promosso su un solo anno. 70 passate: nessun "migliore" e' una scoperta; riporto l'intero quadro per EA, set e anno.

## Previsioni dichiarate ORA (non misurate)
- **S1** Almeno un set di Apex supera il 50% di DD relativa in un anno a 4k: 60%.
- **S2** A 4k il DD relativo e' piu' alto che a 80k (a parita' di set e anno) in almeno 3 EA su 4 (effetto del lotto minimo): 70%.
- **S3** Daytrade Pro `Max9DD lowrisk` ha DD relativa <= 35% in tutti e 5 gli anni: 80%; `Max20DD`: 55%; `Max50DD highrisk`: 20%.
- **S4** Luna `4DD` ha DD relativa <= 35% in tutti e 5 gli anni: 45%; `recommended` e `lowrisk`: 10% ciascuno.
- **S5** Stability Pro `low risk` ha DD relativa <= 35% in tutti e 5 gli anni: 35%.
- **S6** Apex `UltraConservativeGrid` ha DD relativa <= 35% in tutti e 5 gli anni: 25%.
- **S7** Almeno un set (dei 14) e' "CANDIDATO PER IL FORWARD": 60%. Piu' di 4 set candidati: 15%.
- **S8** Nessun set cresce piu' del 100% in un anno restando sotto il 35% di DD: 60%.
- **S9** Alcuni set a 4k mostrano righe "no money" o operazioni mancate per margine/lotto minimo: 50%.
- **S10** Tutte le 70 passate valide (deposito 4.000 confermato dal report): 75%.

## Cosa NON dice (limiti dichiarati)
- Un percorso per anno; OHLC a 1 minuto; nessuno slippage; costi del broker (spread/commissioni) quelli del tester sul BCM: NON verificato che coincidano con il reale. 2013 e 2017 con storico BCM piu' vecchio.
- Leva del tester 1:100: la leva reale del conto di Claudio NON verificata.
- Per le griglie (Apex) il DD equity del tester include le posizioni aperte, ma la perdita giornaliera con le posizioni aperte non e' misurata.
- Orari/`AutoGMT` degli EA nel tester NON verificati contro BCM (GMT+1 fisso). Il parametro "max DD a 0.01 lotti" legato a broker e prezzo NON ricalibrato (Wim: lo deve fare il cliente): qui si usano i valori del venditore.
- Correlazione col trio oro NON misurata in questo giro (passo successivo sui P&L giornalieri); Guardian non simulato.
- Nessun giudizio su acquisto, lotto o taglia, e nessuna modifica al live, al VPS o al reale.
