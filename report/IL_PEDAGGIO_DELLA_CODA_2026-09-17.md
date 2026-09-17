# 🔦 IL PEDAGGIO DELLA CODA — 17/09/2026

> **In una riga**: il runner **rifà ogni notte i round già misurati**, e questo
> vale **circa l'80% del tempo macchina**. A tredici giorni dal 1° ottobre,
> potare la coda restituirebbe ~11 ore di macchina a notte.
>
> Sola lettura: nessuno script toccato, `CODA.txt` non modificato, nessun
> preset, nessun conto. Il conto reale 10105439 non è coinvolto (il banco è
> `C:\MT5_Backtest`, conto 50504400).

---

## 🔴 IL FATTO, VERIFICATO DUE VOLTE

**`-Rifai` è CABLATO nella riga di lancio del runner.**
`backtest_pipeline/righe/RIGA_ROUND_VPS.ps1` r.649:

```
"-Rifai","-Force","-TerminaleBacktest",$cartellaBT)
```

Non è un'opzione: è sempre passato. Il commento due righe sopra (*"senza, il
driver SALTA i CSV gia' presenti"*) descrive un ramo che **non viene mai
preso**. Inoltre r.630-635 cancella i due CSV omonimi **prima** della corsa.

**La prova diretta, sullo stesso round in due notti consecutive** — referti
`REFERTO_RUNNER_20260915_033005.txt` e `..._20260916_033005.txt`, round
`r127a` (SupRev NAS H1, Modello 4):

| notte | esito | durata |
|---|---|---:|
| 15/09 | uscita 0 (riuscito) | **8.245 s** (2h17) |
| 16/09 | uscita 0 (riuscito) | **5.728 s** (1h35) |

Stessa riga, stesso pin, stesso risultato, due volte. **~3h50 di macchina per
una misura che era già in mano dalla prima notte.**

## 📊 QUANTO PESA

Misurato sommando le righe `ESEGUITO in Ns` dei referti veri:

- **16/09**: ~**8,1 h su 11,0** (74%) spese su round già riusciti la notte prima.
- **15/09**: ~**9,6 h su 10,6** (90%).
- **57 round** compaiono in entrambe le notti, nessuno saltato.

La coda cresce e non viene mai potata: **48 → 63 → 69 → 86 → 122 righe** in
cinque giorni. E i round NUOVI stanno sempre in fondo: **ogni round nuovo paga
il pedaggio di tutti i vecchi**.

## 🟢 LE BUONE NOTIZIE, che vanno dette accanto

- **Nessun tetto taglia la coda**: `runner_abtg.ps1` r.733 è un `foreach` senza
  contatore, senza `break`, senza timeout. La riga 122 viene eseguita come la 1.
- **I round nuovi di stanotte girano tutti** (36 su 41; i 5 armati dopo le 03:30
  — `r174a`, `r175a`, `r176a`, `r177a`, `r178a` — girano domani, ~13 min).
- **Il referto di stanotte non manca: non è ancora scaduto.** Con 122 righe la
  fine stimata è ~20:08 CEST, contro le 14:12/14:31 delle notti scorse (69/86
  righe). L'attività risulta `Running` con prossima corsa programmata
  (`CODA_11_canali_e_attivita_20260916_033005.log` r.21-26).
  🚨 **Soglia di diagnosi**: se alle **21:00 CEST** non è arrivato nulla, allora
  è un problema vero (token o round piantato), non un ritardo.
- **I 23 "falliti" del 16/09 non sono uno spreco**: 12 sono uscita 3 (*"girato
  con rilievi, NON è un fallimento"*), 10 degli 11 a uscita 2 hanno
  `@FRAZIONEIS 1.0` e quindi l'OOS non può esistere per costruzione (classe
  395, documentata ieri). **Il fallimento vero è UNO: `cemad02`, 122 secondi.**

## ⚠️ UN SECONDO DIFETTO, a costo zero di macchina

`runner_abtg.ps1` r.770 compone il nome del log come *basename dello script* +
*ora di avvio del runner*. Tutti i round usano lo stesso script e la stessa ora
→ **scrivono tutti sullo stesso file, sovrascrivendosi**. Nel repo c'è un solo
`RIGA_SOTTILE_ROUND_20260916_033005.log`, ed è l'ultimo round della notte. Il
referto dice *"guarda il log"* 23 volte e il log esiste per uno solo.
Una `$Etichetta` nel nome del file lo risolverebbe.

## 🎯 LA DECISIONE, che è di Claudio

Due rimedi, nessuno dei due eseguito (il perimetro del runner è sola lettura):

1. **Potare `CODA.txt`** delle righe già misurate con successo (spostandole in
   uno storico, non cancellandole). Restituisce **~11 h di macchina a notte** =
   circa **70 round nuovi in più per notte** al ritmo attuale.
2. **Togliere `-Rifai` dal cablaggio** di `RIGA_ROUND_VPS.ps1` r.649, così il
   driver salta da solo i CSV già presenti (è il comportamento che il suo stesso
   commento descrive). Tocca lo script del runner → **firma di Claudio**.

⚠️ **Il margine si sta chiudendo**: oggi la corsa dura ~16,6 h stimate su una
finestra di 24. Al ritmo di armamenti attuale bastano **4-5 giorni** per
sfondare le 24 h — e allora il tappo diventa reale, non più teorico.

## 📌 Nota minore, verificata e innocua

Il runner scarica `CODA.txt` **una volta sola** alle 03:30. Il commit `b61d68b7`
(17/09 06:24 UTC) ha ruotato i pin di 21 righe *dopo* lo scarico: stanotte
quelle 21 girano sui pin vecchi. **Verificato che non cambia niente**:
l'emendamento portava solo commenti (la dichiarazione della classe 395), nessuna
direttiva di misura. I numeri di stanotte restano validi.
