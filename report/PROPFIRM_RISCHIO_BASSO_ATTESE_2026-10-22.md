# Prop Firm Gold EA v2.5: rischio manuale 0,25% / 0,5% / 0,75%, attese scritte PRIMA dei numeri (22/10/2026)

**Non controllata da agenti.** Segue `PROPFIRM_MANUALE_V2_LETTURA_2026-10-22.md`: con il rischio manuale la mappa dei menu e confermata (perdita peggiore per operazione = rischio% di 80.000), nessuna cella tiene sul periodo lungo; la piu vicina era 0,5% con protezione (DD 10,4% di 80K, PF 1,08, mesi positivi 51%). Domanda di Claudio: un rischio **piu basso** porta il periodo lungo sotto il 10%?

## Cosa si fa
XAUUSD, **M30, modello 1 (OHLC 1 minuto), 80.000, leva 1:100**, Use Starting Balance, `InpRiskType=1` (Manual), 10 passate singole in due finestre (**W1 2025.01.01-2026.10.01** = T1-T5, **W2 2018.01.01-2026.10.01** = T6-T10):
| cella | InpRiskPercent | protezione giornaliera 4% |
|---|---|---|
| d1 | **0,25** | spenta |
| d2 | **0,25** | accesa |
| d3 | **0,5** | accesa (RIPETIZIONE di c4: controllo della componente casuale dichiarata dal venditore) |
| d4 | **0,75** | spenta |
| d5 | **0,75** | accesa |
Riferimenti gia misurati (c3/c4/c5/c6 di PF2): 0,5% spenta W1 +10.335 / DD 4,5% / W2 +14.735 / 11,3%; 0,5% accesa W1 +11.772 / 4,2% / W2 +15.973 / 10,4%; 1,0% spenta W1 +24.922 / 8,7% / W2 +31.339 / 21,4%.
**Deviazione dichiarata dallo script PF2:** il tetto "barre generate" passa da 100.000 a 150.000 (nella PF2 le W2 sono uscite KO per un falso allarme: la finestra era intera, primo affare 02/01/2018). La lettura controlla comunque primo e ultimo affare.

## Soglie (invariate)
S-N >= 150, S-M >= 60% mesi positivi, S-H, **S-DD <= 10% dal deposito (DD equity / 80.000) e <= 15,2% dal picco**, S-NOSCALA (rapporto lotti <= 3, <= 10 posizioni). Una cella "TIENE" solo se passa tutto in ENTRAMBE le finestre.

## Previsioni dichiarate ORA
- **F1** tutti gli input applicati e perdita peggiore per operazione vicina al rischio%: -200 (0,25%), -600 (0,75%) entro +/-15%: 80%.
- **F2 (scala col rischio)**: il DD di equity in W2 a 0,25% e fra 0,35 e 0,65 volte quello a 0,5% (a pari protezione): 60%. Il lotto minimo 0,01 e lo scatto di 0,01 possono rendere la scala irregolare a 0,25%: possibile.
- **F3 (DD W2)**: a 0,25% il DD di equity sta **sotto il 10% di 80.000 in W2** (sia con sia senza protezione): **85%**; a 0,75% **sopra il 10%**: 85%.
- **F4 (ripetizione)**: d3 ripete c4 con netto entro +/-15% in entrambe le finestre: 70%. Se differisce di piu, la componente casuale del venditore non e trascurabile e ogni confronto fra celle va letto con quel margine.
- **F5 (netto)**: il netto a 0,25% e fra 0,3 e 0,7 volte quello a 0,5% (stessa finestra e protezione): 65%.
- **F6 (S-M e S-NOSCALA)**: in W2 **nessuna cella raggiunge il 60% di mesi positivi e nessuna ha rapporto lotti <= 3** (le due soglie non dipendono solo dalla scala del rischio): 85%. Quindi **nessuna cella TIENE in W2**: 85%.
- **F7 (durata)**: W1 meno di 3 minuti a passata, W2 meno di 30: 80%.

## Cosa NON dice
Server BCM GMT+1 contro GMT+2/+3 del venditore; un solo EA, la protezione chiude tutto il conto; nessuna taglia e nessun consiglio di acquisto: la scelta del rischio e di Claudio.
