# 📅 DA QUANDO PARTE LO STORICO SU BCM — misurato, non ipotizzato

_15/08/2026, 18:39. Prodotto da `scarica_storico.ps1 -Simboli "GBPUSD"
-Timeframes "M1,H1" -Da 2015.01.01 -Auto`._

```
Simbolo,Timeframe,Barre,PrimaDataLocale,PrimaDataServer,Verdetto
GBPUSD,M1,4317541,2014.12.30,1993.05.11,MANCA STORICO LOCALE: rilancia
GBPUSD,H1,72199,2010.07.06,1993.05.11,MANCA STORICO LOCALE: rilancia
GBPUSD,TICK,70491074,2024.07.05,-,TICK REALI PARZIALI
```

## 🎯 La riga che comanda

> **I TICK REALI su BCM partono dal 2024.07.05.** Sono **70.491.074**.

Le barre arrivano molto piu' indietro (M1 dal 2014, H1 dal 2010), ma per il
**modello 4** contano solo i tick. Quindi ogni test a tick reali su BCM ha
come limite invalicabile **il 5 luglio 2024**, ed e' il numero da passare a
`-DaQuando`.

## ⚠️ Due cose in questo referto NON vanno prese per buone

**1. `PrimaDataServer 1993.05.11` e' spazzatura.** E' lo stesso artefatto gia'
smascherato lo stesso giorno su Pepperstone (1993.04.28, 1993.04.05,
1993.04.27). BCM non ha il forex dal 1993. `SERIES_SERVER_FIRSTDATE` mente
quando la serie non e' sincronizzata: su USDCAD abbiamo visto **tre risposte
diverse in 26 minuti**.

**2. Quindi `MANCA STORICO LOCALE: rilancia` e' un FALSO ALLARME.** Quel
verdetto confronta la data locale (2014) con quella del server (1993): siccome
la seconda e' finta, il confronto non significa niente. **Non si rilancia per
quello.**

> 🔧 **Difetto noto, non ancora corretto**: la funzione `Verdetto` di
> `ABTG_HistoryDownloader.mq5` si fida di `SERIES_SERVER_FIRSTDATE`. Finche'
> non e' sistemata, la colonna `Verdetto` va letta con questa avvertenza
> accanto. **Scritto qui perche' non si perda.**

## 📌 Cosa se ne fa

- **R58** (PTE a tick reali su GBPUSD): `-DaQuando 2024.07.05 -Fino 2026.06.30`
  → circa **24 mesi**, IS ~9,5 / OOS ~14,5.
- **Da misurare allo stesso modo**: i tick degli INDICI (`D30EUR`, `U30USD`,
  `NASUSD`, `SPXUSD`, `225JPY`), per poter fare lo stesso test sulle sedie
  grosse.

**Attenzione a cosa NON dice**: i tick reali dal luglio 2024 **non** coprono
ne' l'orso 2022 ne' il crollo 2020. Servono per validare il **riempimento**,
mai la **robustezza di regime**.
