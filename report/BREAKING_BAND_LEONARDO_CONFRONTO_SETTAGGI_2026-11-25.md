# Breaking Band: i file e le lezioni di Leonardo contro il nostro codice v4.2 (25/11/2026)
Riletti: `LEONARDO_VIDEO_BANDE_SINTESI_2026-11-19.md` (le due video lezioni, ~9.500 parole, trascrizioni in `LEONARDO_VIDEO_dati/`), la Guida Operativa 11 e la checklist tabellare (`sala-del-consiglio/breaking_band/materiali/`), i protocolli IN-BULGE e POST-BULGE, `BREAKINGBAND_V4_AUDIT_E_PIANO_2026-11-19.md` (v4 di Massimo), il codice `BreakingBand_ALLCROSSES_v42.mq5`. **Non ho riguardato i fotogrammi: la sintesi del 19/11 dice che non aggiungono regole.**
## 1. Quello che Leonardo usa per giudicare la qualita (checklist ufficiale)
Solidita % = Congestione iniziale 25% + Bulge 25% + Ritracciamento/rientro 20% + Comportamento delle bande 15% + Test del pattern 10% + Conferme tecniche 5%. **Invalidazioni assolute** (un solo SI = pattern non valido): candela > 1,5 ATR nel ritracciamento (continuazione) o > 1,0 ATR nel rientro (inversione), banda inclinata contro, banda che si gonfia al test, ritracciamento disordinato, tocco della banda opposta nell'inversione, deviazione standard ancora alta. **Bonus** (non pesati): candela di rigetto non impulsiva, rientro molto graduale, rigetto netto al retest (0-1 valido, 2-3 buono, 4+ superiore).
**Tabella di Leonardo: solidita 85-100% = Ottimo (successo 65-75%); 70-84% = Buono (55-65%); 55-69% = Medio (45-55%); < 55% = Debole (< 45%).**
## 2. Il nostro codice v4.2 contro il metodo
| Punto | Leonardo (lezioni e checklist) | v4.2 (nostro porting) |
|---|---|---|
| Bollinger / ATR | BB 20/2 SMA sulla chiusura; ATR 14 RMA | uguale (ATR a media semplice: differenza piccola) |
| **Bulge** | TUTTI e 6 i criteri: bande "a bocca di coccodrillo", dev. standard > SMA50, candele 1,5-3 ATR, movimento netto, mediana lontana, impulso <= 20 candele | **qualunque tocco della banda** (massimo >= banda alta o minimo <= banda bassa) |
| Congestione prima del bulge | 25% del punteggio (CS 4/5 criteri o CDA) | **non controllata** |
| **Continuazione** | ritracciamento diretto con candele piu piccole, dev. standard SOTTO la SMA50, nessuna candela > 1,5 ATR, ombre <= 1,5 corpo | solo il tocco del livello salvato della banda opposta, **nessun controllo di ordine o dimensione delle candele** |
| **Inversione** | rientro alla mediana senza toccare l'opposta, **banda dell'impulso piatta o a favore**, candele piccole, nessuna banda che si gonfia | mediana poi ritorno alla banda; **nessun controllo sulla banda** |
| **Conteggio** | "prima bulge = continuazione; **seconda e terza = inversione** (scenario ideale)" | 1a e 2a = continuazione, **3a = inversione** (differente) |
| TP | mediana, **corretto ogni 2-3 ore** | mediana a ogni barra, solo a favore |
| **Break-even** | opzionale dopo >= 1 ATR (protocollo post-bulge) | **forzato a +1 ATR** in v4.2: ammazza molti vincitori |
| Orari e notizie | mattina 7-9 italiane; niente posizioni aperte con notizie a 14:30; Forex Factory | **nessun filtro** |
**Lettura:** v4.2 non implementa la qualita che Leonardo giudica a occhio. Esegue **6.967 operazioni** (circa 32 per coppia e anno) contro gli "9 su 10" che Leonardo seleziona a vista. Il gap non e un difetto del metodo: e che il codice prende TUTTI i tocchi, non quelli che passano la checklist.
## 3. Un numero che pesa: la tabella di Leonardo contro la geometria
Nel nostro porting (misura prudente, costi inclusi): win 38,9%, vincita media +0,62R, perdita media -0,43R (molte uscite a pari per il BE), **pareggio 40,9%**; solo inversioni: win 59,3%, +0,33R / -0,44R, pareggio 57,5% (209 operazioni). Con SL 3 ATR e TP sulla mediana (circa 1 ATR) il pareggio teorico e **75-78% di vittorie**: **anche l'"Ottimo" di Leonardo (65-75%) sta al limite o sotto**. La statistica dichiarata ("90%") non e coerente con la sua stessa tabella.
## 4. Cosa implica
- La domanda giusta non e "Claude Desktop sa classificare?" ma: **il punteggio della checklist di Leonardo, calcolato in modo oggettivo, separa i setup buoni dai cattivi?**
- Si puo fare senza guardare grafici: codifico i criteri della checklist (soglie fissate PRIMA dei numeri, dove la checklist e qualitativa le scelgo io e lo scrivo), calcolo solidita % e invalidazioni per ogni setup v4.2 su 10 cross H1 2005-2026, e confronto R medio per Ottimo / Buono / Medio / Debole, IS contro OOS.
- Poi la **prova alla cieca con i grafici** su un piccolo campione, per vedere se l'occhio aggiunge qualcosa oltre al punteggio.
