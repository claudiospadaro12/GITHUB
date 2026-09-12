# 🔬 LE VERIFICHE ALLA FONTE — cosa ho ricontrollato delle consegne, e cosa e' venuto fuori

**12/09/2026, pomeriggio.** Regola del turno: *"VERIFICA almeno il ritrovamento
principale di ogni consegna ALLA FONTE, non fidandoti del riassunto
dell'agente."* Ecco i conti, uno per uno.

## 🟢 CONFERMATI (misurati da me, non letti)

| ritrovamento | come l'ho verificato | esito |
|---|---|---|
| **La seconda porta del rischio Nasdaq** | `sed -n '45,49p;117,121p' ABTG_Nasdaq_Apertura_US.mq5` | 🟢 **CONFERMATO, ed e' peggio di come l'avevo capito io**: `ABTG_DEF_RISK 2.0` compare **DUE volte** — r.47 (dentro un blocco che chiude con `#endif` poco prima) **e** r.119 dentro `#ifndef ABTG_DEF_RISK`. Cambiare **una sola** delle due puo' non bastare, e quale morde dipende da quale ramo compila |
| **`b5d904a` e' l'ultimo commit sul Nasdaq** | `git log -2 -- mql5/Experts/ABTG_Nasdaq_Apertura_US.mq5` | 🟢 **CONFERMATO**: il commit in testa a quel file e' **`WIP FASE 2 DRIVE: modifica in corso`**. Compilare `HEAD` compilerebbe **lavoro in corso** |
| **`b45dd00` = "NON COMPILARE"** | `git log --oneline -1 b45dd00` | 🟢 `IN CORSO D'OPERA -- NON COMPILARE: 10 EA e 2 strumenti` |
| **`storicoOk` = 7 per bersaglio** | `grep -c` sui tre EA | 🟢 **7 · 7 · 7 = 21**, esattamente come dichiarato |
| **Le classi nuove in checklist** | `grep -oE "^## [0-9]+"` + `uniq -c` | 🟢 255-259 presenti, **nessun duplicato nuovo** (101/26/5 sono vecchi) |

## 🔴 IL MIO QUINTO ERRORE DELLA GIORNATA, E LA STESSA CAUSA

Ho letto *"84 celle su 84 positive"* e sono andato a contare:
`valid_ABTG_EMA200_H1_realtick_U30USD.csv` ha **137 righe**. Stavo per scrivere
**"falso"**.

Poi ho costruito il contro-esempio invece di fermarmi alla conferma:

```
celle totali        : 137
positive (Profit>0) :  84
celle con Trades==0 :  53
fra quelle che OPERANO -> positive: 84 su 84
```

🟢 **L'agente aveva ragione.** Le 53 celle a `Trades == 0` non sono celle in
perdita: sono celle **che non operano** — combinazioni di parametri che non
generano nessun segnale. Su 84 celle che operano, **84 sono positive**.

🔴 **E la causa e' la STESSA di tutte le altre volte oggi**: ho confrontato un
numero di superficie (137 righe) **senza leggere la definizione della
popolazione** (celle che operano). E' la quinta volta in una giornata:
1. `CODA_04` aveva il nome della macchina in un log da cinque notti;
2. `CODA_03` aveva la definizione di "cartella dati" scritta nel codice (r.63);
3. `ROUND_ALTOPIANO_SUPREV` aveva i cancelli del round congelati prima;
4. `cATRpillar` contiene la sottostringa `catrp` (falso positivo del mio grep);
5. questa.

📌 **La regola che mi serve, scritta perche' me la ricordi**: quando un numero
mio contraddice un numero di un altro, **la prima ipotesi da provare e' che io
stia contando una popolazione diversa** — non che l'altro abbia sbagliato.

## 🟠 E UNA PRECISAZIONE CHE L'AGENTE NON AVEVA FATTO

**`84/84` con 53 celle inerti e' una frase piu' DEBOLE di `84/84` su una
griglia piena.** Il **39% dello spazio dei parametri non produce nessuna
operazione**: e' un fatto sulla superficie che va dichiarato accanto al 100%,
altrimenti la superficie sembra perfetta quando invece e' **perfetta dove
esiste**. Girato al cancello di giudizio come rilievo da verificare.

## ⏳ COSA STA ANCORA AL CANCELLO

Due pacchetti, **nessuno dei due e' uscito** (regola del 09/09):
1. **Ricompilazione del campo** — `RIGA_COLLAUDO_RICOMPILA.ps1` + il referto
   con gli 8 passi di sola firma. Deterministico: PASS. Giudizio: **in corso**.
2. **`EMA200` Dow** — 5 file prova + i criteri congelati. Deterministico: PASS.
   Giudizio: **in corso**, e gli ho chiesto di essere **severo su due punti**:
   la famiglia a **0,945 pos/giorno** togliendo una sedia firmata «prop: NO», e
   l'edge che vive su **un simbolo solo** (`U30USD` 98/98, ma `D30EUR` 0/80,
   `NASUSD` 2/83, `SPXUSD` 4/86).
