# Controllo spread della prova a tre regimi: previsioni scritte PRIMA dei numeri (21/10/2026)

**Non controllata da agenti.** Origine: lo spread storico del laterale 2022-23 vale 0 punti (par. 8/9 dei criteri). 8 passate, OHLC a 1 minuto, 80.000 EUR, stessi input della prova RG3: Goldbot One D1 (Risk 9999, step 3000 e 6000, MaxRisk 6.0, StartLots 0.01), The Gold Reaper H1 (set del venditore), Prop Firm Gold EA H1 (default con rischio esplicito). Finestre: RIALZO-S 01/08/2019-01/08/2020 (R +39,6%, spread 14), LATERALE-S 01/06/2018-01/06/2019 (R +0,4%, spread 15). TRANCHE1-2 Goldbot One rialzo (step 3000/6000), TRANCHE3-4 laterale; TRANCHE5-6 Gold Reaper rialzo/laterale; TRANCHE7-8 Prop Firm rialzo/laterale.
## Previsioni
- **S1** input imposti confermati dal report in 8/8: 85%.
- **S2** Goldbot One PF >= 1,2 in entrambe le finestre e entrambi gli step: 75%.
- **S3** Gold Reaper PF >= 1,2 in entrambe: 70%.
- **S4** Prop Firm Gold EA: PF < 1,1 nel LATERALE-S: 60%; PF >= 1,2 nel RIALZO-S: 55%.
- **S5** correlazione giornaliera Goldbot One-Gold Reaper: <= 0,5 nel LATERALE-S: 50%; fra 0,45 e 0,70 nel RIALZO-S: 65%.
- **S6** DD combinato Goldbot One + Gold Reaper <= 10% di 80.000 in entrambe: 65%.
- **S7** rapporto lotti Goldbot One <= 3 in entrambe: 55%; Gold Reaper > 3: 85%.
- **S8** ogni EA con n >= 60 in entrambe: 90%; ogni passata sotto 15 minuti: 80%.
## Come si legge
Come in `REGIMI_ORO_TRE_EA_LETTURA_2026-10-21.md`: PF, DD in % di 80.000 e dal picco, n, long/short, correlazione dentro la finestra, DD combinato. Se Goldbot One e Gold Reaper tengono (PF >= 1,2) anche con questi spread, la conclusione "reggono fuori dal rialzo" ha due finestre laterali e due rialzi; se no, il laterale 2022-23 era gonfiato dallo spread.
## Limiti
Un anno per finestra; il RIALZO-S contiene il crollo di marzo 2020; modello OHLC; spread del tester non verificato (se il tester non usa lo spread delle barre il controllo non cambia nulla: lo si vedra' dal confronto); EA Market a periodo di ottimizzazione ignoto.
