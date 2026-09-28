# 📨 Il parere di Emiliano sul piano di trading (ricevuto il 28/09/2026) e dove siamo, punto per punto

Mail inoltrata da Claudio il 28/09/2026 mattina: *"Risposta di Emiliano alla mia mail sul piano di trading. E' il suo
punto di vista"*. Il piano che Emiliano ha letto e' quello del **dry-run 100k** (`50504263`, rischio 0,65%, citazione
del p99 ~10,4%: `report/DEPLOY_GUARDIANO_100K.md` r.72). La challenge FTMO `541452707` e' in corsa dal 22/09 con **sette**
sedie al **2,00%** ciascuna (sei in CODA_01 del 28/09 + la `770105` DAX short viva dal 25/09 ma assente dalla sonda per la
classe 822: `report/DIPENDENZA_NELLO_STRESS_2026-09-28.md` punto 0): i suoi punti valgono **di piu'** li', non di meno.

## Il testo (verbatim)

> 1. Il rischio operativo dello 0,65% non ha ancora un margine sufficiente rispetto al vincolo totale. Nei tuoi stessi
> Monte Carlo il p99 riscalato resta circa al 10,4%, quindi oltre il limite del 10%. Inoltre il Guardiano interviene al
> limite formale, mentre nella realta' slippage, commissioni, posizioni simultanee e latenza possono portarti oltre prima
> che la chiusura sia completata. Il limite tecnico deve avere un buffer interno piu' conservativo del limite della prop.
>
> 2. Le correlazioni giornaliere vicine allo zero sono utili, ma non bastano. Devi controllare la dipendenza condizionale
> nelle giornate di stress: apertura USA, shock macro, volatilita' estrema e casi in cui piu' EA sullo stesso indice o su
> indici collegati ricevono segnali contemporaneamente.
>
> 3. Trenta trade di forward sono un buon checkpoint operativo, non una validazione statistica definitiva. [...] Userei 30
> trade come prima revisione, poi richiederei anche coerenza per regime, slippage, distribuzione di MFE/MAE e stabilita'.
>
> 4. Il Guardiano deve essere testato come componente critica: riavvio terminale/VPS, perdita di connessione, ordini
> pendenti residui, mancata risposta del broker, cambio giorno del server, calcolo dell'equity e concorrenza tra EA.
> Farei test deliberati di failure injection, non soltanto dry-run normale.
>
> 5. Eviterei di assumere che 2.000 rimescoli dei giorni esauriscano il rischio di sequenza. Mantieni i blocchi temporali
> e prova anche stress con clustering delle perdite e peggioramento simultaneo di spread e slippage.
>
> [...] il criterio per passare alla challenge non deve essere soltanto "30 trade e numeri simili". Deve essere: nessuna
> anomalia infrastrutturale irrisolta, rischio di coda sotto il limite con buffer reale, comportamento coerente nei regimi
> e procedure di emergenza provate. [...] Mai mulàr. — Emiliano

## Dove siamo, punto per punto (fatti dal repo, 28/09)

| # | punto | cosa abbiamo gia' MISURATO | cosa MANCA | verdetto |
|---|---|---|---|---|
| 1 | buffer sotto il limite | Guardian FTMO: emergenza al **9,3%** contro il 10% FTMO = **0,7 punti (560 EUR)**; pausa giornaliera 3,5 contro 5 FTMO; cap del rischio aperto 4,00% (`ABTG_Guardian_FTMO_2Step.set`). Saldo 75.841,54 (DD 5,20%): due stop pieni al 2% insieme (~3.030 EUR) portano a ~72.800, sopra l'emergenza 72.560 | il **superamento** oltre lo stop (gap, slippage, latenza di chiusura di piu' posizioni) non e' misurato: il MC tratta la fermata a 9,3 come ESATTA (`MC_CON_ORO_E_BLOCCHI` r.172: *"il muro FTMO vale 0,0 per costruzione"*); lo SlippageLogger sul reale non ha ancora deal | 🔴 **HA RAGIONE, ed e' piu' stretto di quanto sa**: 560 EUR di margine con posizioni da ~1.500 EUR. Il 18/09 una prop ci ha gia' chiuso una challenge in guadagno per la regola giornaliera (`BREACH_FUNDEDNEXT_2026-09-18.md`) |
| 2 | dipendenza nelle giornate di stress | MC v2 a blocchi di giornata intera: tenere insieme le sedie dello stesso giorno costa **1,4 punti** di P(PASS) rispetto all'IID (`MC_CON_ORO_E_BLOCCHI`) | la dipendenza **condizionata** (apertura USA, dati macro, ATR alto) non e' misurata. Su FTMO **quattro sedie su sette stanno sugli indici USA**, tre sul Dow (770202, 771531, 770511) + Nasdaq 770260 (le altre tre sul DAX); la 770212 in firma ne aggiungerebbe una quinta | 🔴 **HA RAGIONE**; misurabile subito a costo macchina zero dai per-trade |
| 3 | 30 trade non validano | il criterio firmato il 18/08 e' gia' diverso: RISCHIO per sedia a qualunque n, MERITO per famiglia a 20 op, tagliando a 6 mesi (`FIRME_2026-08-18.md`); nel backtest il merito chiede n >= 150 | MFE/MAE e slippage in forward non sono nel criterio | 🟢 **d'accordo**, siamo gia' li' sul principio; aggiungere MFE/MAE e' lavoro vero |
| 4 | failure injection sul Guardian | 6 sedie su 6 censite il 24/09 leggono il Guardian (`GUARDIAN_SEI_SEDIE_2026-09-24.md`); la settima, `770105` (attaccata il 25/09), **[NON VERIFICATA]**; canarino riparato (08/09); EA reload-safe; collaudo fase 1 = **revisione statica**, dichiarato *"nessuna riga dice funziona"* | **nessun test deliberato** di riavvio, disconnessione, pendenti residui, cambio giorno, broker che non risponde. Esempio fresco: la sonda del 28/09 ha scritto "il conto non ha operato" su una notte in cui ha chiuso una posizione (classe 896) | 🔴 **HA RAGIONE**: e' il buco piu' grande, e richiede le mani di Claudio su un demo |
| 5 | rischio di sequenza | v1 ricampionava gia' giornate intere; v2 a blocchi; stress costi (spread/slippage) fatto per SEDIA sull'oro (`STRESS_ORO_LONG_2026-09-27.md`) | nessuno stress CONGIUNTO: perdite a grappolo + spread e slippage peggiorati insieme + superamento dello stop del Guardian | 🟠 **mezza ragione**: i blocchi ci sono, lo stress congiunto no |

## Il criterio che propone per andare live

*"Nessuna anomalia infrastrutturale irrisolta, rischio di coda sotto il limite con buffer reale, comportamento coerente
nei regimi, procedure di emergenza provate."* Detto onestamente: la challenge FTMO e' partita il 22/09 **prima** che i
punti 1, 2 e 4 fossero chiusi. Il suo criterio vale adesso per due decisioni che restano di Claudio: **aggiungere sedie**
(770212, oro long) e **il passo dopo la challenge**.

Le decisioni su taglie, soglie del Guardian e sedie restano di Claudio: qui non si propone nessun numero.
