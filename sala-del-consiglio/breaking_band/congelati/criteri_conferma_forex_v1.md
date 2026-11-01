# Conferma su ANNI NUOVI (forex H1) — pre-registrata PRIMA di avere i dati (C0, 01/11/2026)
Origine: il run di estensione su EURUSD (primaria: N=12, INCONCLUSIVO) e sulle tre esplorative ha mostrato, SOLO su H1, un quadro migliore dell'oro (EURUSD +0,29 R, GBPUSD +0,14, USDJPY +0,28, EURJPY -0,05; win rate 87% contro un pareggio atteso del 75-77%), mentre M30 e circa zero. Con N cosi piccoli e un'osservazione a posteriori (la sintesi tra le 4 coppie non era pre-registrata), NON e un risultato: serve un campione NUOVO.
## Dati nuovi (non ancora visti)
Stesse 4 coppie (EURUSD, GBPUSD, USDJPY, EURJPY) su 4 anni mai usati: 2015, 2017, 2019, 2022 (scelti ora, senza guardare niente). 16 CSV M1 BCM.
## Codice
Esattamente il codice v2 congelato (congelati/HASH_CODICE_V2.txt), nessuna modifica. L'unico codice nuovo ammesso e un aggregatore che unisce i log dei trade delle 4 coppie (stesso metodo del run, nessuna regola nuova) e calcola le statistiche pooled qui sotto: scritto da A4 e verificato da A7 PRIMA di aprire i nuovi CSV.
## Ipotesi di conferma H-C (UNICA)
Pooled H1 (continuazione + inversione) sulle 4 coppie, anni nuovi. Esplorative: M30; ogni coppia da sola; CONT e INV separati.
## Verdetto (tutte le condizioni per CONFERMATO)
1. N pooled >= 30 (altrimenti INCONCLUSIVO);
2. media R netta > 0 con limite inferiore IC90 (bootstrap a blocchi settimanali, 10.000 replicati) > 0;
3. win rate pooled >= pareggio atteso medio + 5 punti percentuali;
4. togliendo ciascuna coppia (leave-one-pair-out) la media R resta > 0;
5. con spread e costi maggiorati di 0,05 R per trade (copre commissioni: gli spread BCM dei CSV sono grezzi, p50 0-4 punti) la media R resta > 0.
Se N>=30 e IC90 contiene 0: NON DIMOSTRATO. Se N>=30 e limite superiore IC90 < +0,05 R: NESSUN VANTAGGIO RILEVANTE. "CONFERMATO" significa solo: ripetuto fuori campione su forex H1 a costi realistici; NON significa EA pronto, ne lotti, ne conto reale (resta il test a tick reali, la regola sul news filter e l'identica verifica su altri simboli).
## Previsioni (probabilita, scritte ora)
- N pooled: <30 / 30-59 / >=60 = 15% / 40% / 45%.
- Verdetto: CONFERMATO 22%, NON DIMOSTRATO 38%, NESSUN VANTAGGIO RILEVANTE 25%, INCONCLUSIVO 15%.
- media R netta pooled > 0: 55%; > +0,10: 28%.
- win rate pooled >= 80%: 40%; il win rate scende rispetto al 87% dei dati gia visti (regressione verso la media): 80%.
- almeno una coppia con media R < 0: 70%.
- M30 pooled media R > +0,05: 15%.
## Non modifica
Dopo l'hash di questo file nessun cambio di soglia, anni o coppie. Se un controllo fallisce: si corregge con registro e si rifa tutto.
