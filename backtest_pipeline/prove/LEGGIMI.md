# `prove/` — una prova per EA, con l'ipotesi scritta PRIMA

Un file per EA, stesso nome del `.mq5`. Dentro ci stanno **tre cose**, in
quest'ordine, e l'ordine non è decorativo:

1. **L'IPOTESI**, in italiano. Perché ci aspettiamo che quel parametro conti.
   Se non si riesce a scriverla, non è un esperimento: è una spazzolata.
2. **I CRITERI DI ACCETTAZIONE**, prima di vedere i numeri. Servono a non
   spostare l'asticella dopo — cosa facilissima con la tabella davanti.
3. **LO SWEEP**, nel formato di MT5: `Nome=default||start||step||stop||Y`.

Righe che cominciano con `#` sono commento. Tutto il resto degli input
dell'EA viene **pinnato automaticamente al suo default, letto dal `.mq5`**:
non serve elencarli, e non possono restare liberi per sbaglio.

## Le righe `@`: le poche cose che il codice non sa

```
@SIMBOLO  D30EUR
@PERIODO  M5            <- il TF del grafico nel tester
@DAQUANDO 2024.09.26    <- inizio storico VERO, misurato
```

Si possono anche passare da riga di comando (`-Simbolo`, `-Periodo`,
`-DaQuando`): l'argomento vince sulla direttiva.

`@PERIODO` conta davvero solo per gli EA che usano `PERIOD_CURRENT` senza
un input `InpTF`: per quelli **il Period del tester È la strategia**, e il
driver lo dice a schermo prima di partire.

## Quando serve una riga con flag `N`

Il pinning automatico prende il default **del sorgente**. Ma il valore che
gira in forward può essere diverso, perché è stato cambiato **sul grafico**:
in quel caso va riscritto qui, con flag `N`, altrimenti si misura un EA che
non esiste. Le righe del file prova **vincono** su quelle automatiche.

Due casi già veri oggi, tutti e due su `ABTG_DAX_Apertura_EU`:

- `InpAllowShort` nel sorgente è ancora `true`; il **SOLO LONG** del 07/08
  è stato fatto sul grafico.
- `InpRiskPercent` nel sorgente è `2.0`; tutte le fasi misurate sono girate
  all'**1%**, e al 2% i numeri non si confrontano più con niente.

## Le trappole già pagate, che il driver adesso blocca da solo

- **sweep degenere**: flag `Y` ma `start == stop` o `step == 0`. Non spazzola
  niente e su un **enum** MT5 non produce nemmeno un pass: il 07/08 sono
  usciti 4 CSV vuoti dopo una notte di macchina.
- **enum**: MT5 ignora lo `step` e spazzola i membri **fra start e stop**.
  Gli estremi contano, lo step no. Il driver conta le celle così, e te le
  dice **prima** di lanciare: quel numero sono ore di macchina.
- **parametro doppio**: se un nome compare due volte in `[TesterInputs]`,
  MT5 produce zero passate. Il driver si ferma prima.
- **nome inesistente**: un parametro che l'EA non ha, MT5 lo ignora **in
  silenzio** e la fase risponde a un'altra domanda. Qui è un errore.
- **EA senza `OnTester`**: girerebbe senza produrre niente da leggere. Sono
  22 su 61 (`scheda_ea.py`, 07/08). Il driver rifiuta di partire.

## Come si lancia

Prima **sempre** il giro a vuoto: non apre MT5, controlla tutto, dice quante
celle sono e ti fa vedere l'`.ini` che lancerebbe.

```
powershell -ExecutionPolicy Bypass -File .\walkforward_generico.ps1 -Expert ABTG_PTE -SoloControllo
```

Poi, se il numero di celle torna:

```
powershell -ExecutionPolicy Bypass -File .\walkforward_generico.ps1 -Expert ABTG_PTE
```

⚠️ Il parametro si chiama `-Expert`, **non** `-EA`: `-EA` è l'alias di `-ErrorAction` e
PowerShell rifiuta di caricare lo script. (Provato: `MetadataError ... conflicts with the
parameter alias of the same name`.) Si può anche omettere del tutto — il nome dell'EA è il
primo argomento posizionale: `.\walkforward_generico.ps1 ABTG_PTE -SoloControllo`.

I CSV finiscono in `risultati_prove\<EA>\<EA>_<SIMBOLO>_IS.csv` e `_OOS.csv`.
Senza `-Rifai` i CSV già fatti non si rifanno: si può spegnere il PC e
riprendere.

## Il prerequisito che vale per tutti

Lo storico del simbolo deve partire da dove crediamo. Sugli indici i driver
dicevano `2024.01.01` e i dati partivano dal **26/09/2024**: metà finestra IS
non esisteva. Si misura con `scarica_storico.ps1 -Simboli "XXX" -SoloReferto`
e si passa la data vera con `-DaQuando`.
