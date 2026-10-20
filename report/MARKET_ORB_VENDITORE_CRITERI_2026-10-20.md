# EA ORB (Opening Range Breakout) dello stesso venditore del Gold Reaper: criteri scritti PRIMA di scaricarlo e misurarlo (20/10/2026)

**Non controllata da agenti.** Claudio scarica la demo dal Market per cercare un EA SCORRELATO da Prop Firm e Gold Reaper. Si applica lo stesso percorso (setaccio -> test a fondo -> S-CORR/S-PORT); spesa e taglie sue.

## Perche' puo' essere scorrelato (ipotesi, da misurare)
Un ORB entra sulla rottura del range dell'apertura di una sessione (orario fisso), gli altri due sono su logiche diverse (Prop Firm, Gold Reaper). Ma se tradano lo stesso simbolo (oro) e le rotture capitano nelle stesse giornate di movimento, la correlazione puo' restare alta: **non si assume, si misura.**

## Da sapere PRIMA del test (Claudio, dalla pagina del Market / pannello input)
Nome esatto dell'EA, simbolo/i dichiarati, timeframe dichiarato, orari di sessione negli input e **in quale ora sono scritti (server, GMT, ora italiana)**. Il server BCM e' un'ora indietro rispetto all'ora italiana: un orario d'apertura sbagliato di un'ora cambia completamente il range.

## Soglie (invariate) e due in piu' specifiche per ORB
- Le solite: S-N >= 150 operazioni, S-M >= 60% mesi positivi e somma > 0, S-H (gen25-mag26 e giu26-set26 entrambe > 0), S-DD (perdita dal deposito <= 10%, DD <= 15,2%), S-NOSCALA (lotto max/min <= 3, <= 10 posizioni), S-COSTO (>= 3 volte lo spread), costo doppio (netto > 0, PF > 1,10).
- **S-CORR** <= 0,50 con Prop Firm e con Gold Reaper (strumento congelato); **S-PORT** tetto <= 10% del conto con Prop Firm + Gold Reaper + ORB.
- **S-ORA (nuova)**: spostando di +1 ora e di -1 ora l'orario di apertura/sessione, il netto della corsa continua resta > 0 e il PF > 1,10 (se l'EA ha l'orario fra gli input; altrimenti [NON TESTABILE]). Serve perche' tester, server e ora italiana sono tre orologi diversi: un EA che funziona solo a un orario esatto e' fragile.
## Previsioni dichiarate ORA
- **O1**: r (giornaliero) ORB / Prop Firm <= 0,30; ORB / Gold Reaper fra 0,20 e 0,50.
- **O2**: meno di 400 operazioni in 21 mesi (circa una al giorno al massimo) e DD mensile < 15,2%.
- **O3**: S-ORA fallisce per almeno una delle due direzioni (ORB sensibile all'orario).

## Aggiunta (20/10): DayTrade Pro (stesso venditore, altri simboli, poco quotato)
Stesse regole, con queste differenze scritte PRIMA di vederlo:
- **Simboli diversi dall'oro**: gli script di test hanno XAUUSD scritto dentro; serve una variante per simbolo. Prima si verifica che il simbolo esista sul BCM, che il tester abbia i **ticks reali al 100%** su 21 mesi (altrimenti la tranche non conta) e il nome esatto (suffissi). **S-COSTO si rifa con lo spread di QUEL simbolo** letto dal report/giornale, non con i 0,18 EUR dell'oro.
- **Giudizio di scorrelazione**: S-CORR <= 0,50 con Prop Firm e Gold Reaper come sempre; scorrelato dall'oro NON vuol dire che guadagni: l'edge si misura con le stesse soglie (S-M, S-H, S-DD, costo doppio).
- **Valutazione bassa sul Market**: prima del test si leggono i commenti negativi (Claudio li incolla): se dicono "perde", "non apre", "serve il set del venditore" o "solo su un broker", lo scrivo come ipotesi da verificare, non come verdetto.
- **Previsione D1**: DayTrade Pro passa meno soglie di The ORB Master; fiducia bassa.

## Aggiunta (20/10): i file .set del venditore (dal rischio piu' basso al piu' alto)
Regole scritte PRIMA di vedere un set:
- Il test dei set serve a **misurare**, non a scegliere il piu' redditizio: ogni set e' valutato con le STESSE soglie S-*; fra quelli che le passano tutte non si sceglie per profitto. **Il livello di rischio da usare e' una decisione di Claudio** (taglia), non mia.
- I set di uno stesso EA non sono prove indipendenti: cambiano soprattutto lotto/rischio e la stessa strategia produce gli stessi mesi. Che "passino tutti" dice poco di piu' di "passa il base".
- Prima fase: **una corsa continua per set** (circa 3 minuti ciascuna); i set che non superano S-DD o il costo doppio si scartano senza test lungo; i superstiti fanno poi le 21 tranche mensili.
- Gli input si IMPONGONO dal .ini e si **verificano valore per valore nel report** (un nome di input sbagliato il tester lo ignora in silenzio e si misura il default: errore GRC del 19/10). Per questo servono i file .set originali.
- Previsione **S1**: aumentando il rischio il netto cresce quasi in proporzione ma il DD cresce piu' che in proporzione nei set alti; il set piu' alto non passa S-DD (<= 10% dal deposito).
