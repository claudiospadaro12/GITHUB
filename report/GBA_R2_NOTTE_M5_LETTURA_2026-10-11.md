# GBA R2NOTTE -- lotti M1 e M5 (la notte a M1 e a M5): lettura del 11/10/2026

Fonte: `GBA_R0_R2NOTTEM5.zip` (pin 397bd24f, PC `DESKTOP-H4D7CAJ`, 09:19-09:22, 3 passate su 3 OK, 43 s l'una, compilazione 0 errori). Il lotto M1 e' arrivato dopo (`GBA_R0_R2NOTTEM1.zip`, stessa corsa, 3 passate OK, 09:19): la sezione 'M1 e confronto' in fondo. Lettore: `leggi_gba_notti.py` 1404C68D (PASS con riserve 30c23a17): le riserve C1-C3 sono TUTTE vere (file prova M5 SHA F6D0CFCD identico alla copia nello zip; nessuna riga NON VERIFICATO/NON trovata; soglia per notte letta dal file prova r.87). Lettura rifatta col parser INDIPENDENTE del cancello: **coincide al centesimo** (n, PF_V, netto, notti, notti negative, netto senza le 3 e le 5 migliori notti, finestre).

## Cancelli
- Periodo M5 vero: `InpSignalTF=5`, barre 16.787-17.684, 100% tick reali.
- **Controllo diretto**: 303 deal d'ingresso su 303 con ora server 00:00-06:59, fuori fascia 0. (29 posizioni nate di notte escono dopo le 07:00 o il giorno dopo: la notte e' definita dall'INGRESSO.)

## Numeri (PF_V netto di costi, 1 lotto)
| tranche | n | PF_V | netto | notti (negative) | senza le 3 migliori notti |
|---|---:|---:|---:|---|---:|
| T1 (lug-set) | 93 | 0,873 | -3.818 | 57 (40) | -13.520 FRAGILE PER NOTTE |
| T2 (apr-giu) | 97 | 0,848 | -6.325 | 54 (36) | -20.650 FRAGILE PER NOTTE |
| T3 (gen-mar) | 113 | **2,094** | +47.462 | 56 (29) | +28.177 non fragile |
| totale | 303 | **1,325** | +37.319 | 167 (105), q 0,629 | +18.034; senza le 5: +7.389 |
- Costo mediano 55,6x (0% sotto 13,3x): PASSA, ma FUORI dalla banda attesa 43-55x (di poco). PF_V totale 1,325: FUORI attesa (0,80-1,10). n 303: DENTRO (105-420). q 0,629: DENTRO (0,40-0,75).
- Bootstrap PER NOTTE del PF_V totale: **[0,943 ; 1,836]**: include 1,0. Finestre di 7 notti senza notti negative: **0 su 149**.
- Ancora R1A post-hoc (REPL a 24 ore, entrate in fascia): n 142, PF_V 0,944.

## Lettura contro quanto scritto prima
- E' la **SORPRESA** prevista dal file prova (r.88: PF_V >= 1,3 sul totale con n >= 150), non una conferma. Il file prova dice anche cosa serve perche' sia un INDIZIO: replica in 2 tranche su 3 con n >= 150 (qui **nessuna tranche ha n >= 150, e 2 su 3 perdono**) e niente FRAGILE PER NOTTE. Quindi **NON diventa INDIZIO**. Mai «H-M5N confermata» (r.90).
- **Controesempio (a) del piano, verificato**: M5 notte "vince" solo in T3 e perde in T1 e T2. La classificazione di regime (T1 e T3 laterale, T2 ribasso) NON la spiega: T1 e T3 sono lo stesso regime e danno 0,873 contro 2,094. Resta T3 come periodo (gen-mar 2026) e il suo ATR M5 piu' alto [dal proxy del piano]; per quanto riguarda il costo, T3 ha la mediana piu' alta (64x), non la piu' bassa.
- Lo scarto di netto fra T3 (+47.462) e l'ancora M1 post-hoc nella stessa tranche (+6.292, PF 1,12) potrebbe essere in parte scala [INFERITO, NON misurato qui]: a M5 l'ATR e' piu' alto (il piano cita 6,65 per T3, sul proxy) e quindi lo stop in euro a 1 lotto. Il PF non dipende dalla scala; il netto si'.
- **Non misurato qui**: M1 notte (lotto R2NOTTEM1), M5 a 24 ore (se la notte conta o e' il TF: controesempio (b) del piano), la tranche T0 (dal 01/10/2026, mai vista), il periodo 2024-25 (R2REG). La fascia 00-07 nasce dalla lettura per ora di R1A: in-sample.

## Stato
**NON ANCORA MISURATO.** Nessuna casella del certificato si chiude. Prossimo: il lotto M1 (zip mancante), poi la domanda a Gemini sul confronto, poi M5 a 24 ore (richiede riga nuova e cancello) e T0.

## M1 e confronto M1/M5 (zip arrivato dopo)
Lettura: `leggi_gba_notti.py` 1404C68D su entrambi gli zip (riserve C1-C3 tutte vere; copia file prova identica per M1 e M5) e parser indipendente: **coincidono** (M1: n 143, PF_V 0,928, netto -5.047,19, 53 notti di cui 33 negative, senza le 3 migliori notti -16.812, finestre di 7 notti pulite 0 su 35).
| tranche | M1 notte n / PF_V / netto | M5 notte n / PF_V / netto |
|---|---|---|
| T1 | 6 / 0,110 / -3.093 | 93 / 0,873 / -3.818 |
| T2 | 33 / 0,471 / -8.246 | 97 / 0,848 / -6.325 |
| T3 | 104 / 1,123 / +6.292 | 113 / 2,094 / +47.462 |
| totale | 143 / 0,928 / -5.047 (DENTRO l'attesa 0,75-1,10) | 303 / 1,325 / +37.319 (FUORI) |
- **M1 notte ridà l'ancora R1A post-hoc quasi identica** (142 contro 143 operazioni; T1 e T3 uguali al centesimo): filtrare la fascia nel tester o dopo da' la stessa cosa. Conferma la lettura dell'ancora e lo e' per il filtro orario.
- **Sullo stesso insieme di notti** (52 comuni): M1 142 operazioni PF_V 0,933; M5 118 operazioni PF_V 2,053. Ma M5 ha **167 notti con ingressi contro 53**: 115 notti di M5 non hanno nessun ingresso M1 (e 1 notte di M1 non ha ingressi M5). Non e' "la stessa cella cambiando il TF".
- **Confondente da misurare, non dimostrato [INFERITO]**: il filtro di spread e' un multiplo dell'ATR del timeframe del segnale (`InpSpreadMaxATR` 0,05); l'ATR a M5 e' piu' grande di quello a M1, quindi a M5 lo stesso numero lascia passare piu' spread. Segnali scartati per spread nel giornale: M5 107-216 per tranche su 1.110-1.290 segnali; M1 notte 1.706-2.302 per tranche (non confrontabili per denominatore). La cella M5 cambia due cose insieme: TF e filtro di spread effettivo. Prima di leggere "M5 funziona di notte" va separato (cella M5 con soglia di spread equivalente in assoluto, oppure M5 a 24 ore per il controesempio (b)): sono righe nuove, da far passare dal cancello, NON una griglia (una cella).
- **Stato: NON ANCORA MISURATO**, come sopra. Nessuna casella del certificato si chiude.
