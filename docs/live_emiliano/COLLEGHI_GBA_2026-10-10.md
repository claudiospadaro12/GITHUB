# Messaggi dei colleghi sull'EA oro di Emiliano (GBA) - raccolta

Regola: tutto cio' che segue e' **[DICHIARATO DA TERZI]**, non misurato da noi e **mai un criterio**. Serve a scegliere COSA misurare (ipotesi), con le nostre regole (R57 tick reali, certificato di morte, criterio per regimi firmato il 10/10: `report/FIRME_2026-10-10.md`).

## 10/10/2026 14:51 - gruppo "FTD", Roberto Mazzardi (screenshot di Claudio, ore 15:18)
Testo (trascritto dallo screenshot):
> "Ho fatto analizzare a Claude i parametri della strategia di Emiliano e gli ho fatto fare dei backtest (per quello che possano valere su Onam). Risultato migliore applicare la strategia in M5 di notte. Circa il doppio del conto su 2 anni con Max DD del 7%-11%. Con tantissime operazioni. Di giorno e' un disastro su tutti i timeframe. Si salva H1, ma di poco. Sicuramente mancano accorgimenti che avra' fatto Emiliano o che si possono valutare, oltre a quel poco che ha detto, ma al momento mi ha dato questo risultato... Qualcun altro ha provato a elaborare qualche backtest?"
Poi risponde Consu: "No io devo farlo tra stasera e ..." (testo tagliato).

### Che cosa dice (4 ipotesi) e che cosa NON dice
1. **H-M5N**: TF **M5**, solo di **notte**: ~+100% del conto in ~2 anni, DD massimo 7-11%, "tantissime operazioni".
2. **H-GIORNO**: di giorno "un disastro su tutti i timeframe"; **H1** si salva "di poco".
3. Mancano "accorgimenti" (filtri/uscite) che Emiliano potrebbe avere.
4. Dati di **"Onam"** (non e' il nostro feed BCM) [NON NOTO cosa sia: broker o fonte dati].
**Non dichiara**: broker/feed e se tick reali o OHLC; quali 2 anni; che cosa e' "notte" (ore e fuso); lotto/rischio per trade (il "doppio del conto" e il DD dipendono dalla taglia); spread assunto; numero di operazioni; PF; long/short; se i parametri sono quelli della foto di Emiliano (canale 48, EMA100, SL 2,5 ATR...) o rieseguiti/ottimizzati; costi (commissioni/swap); fuori campione. **Senza questi punti il confronto coi nostri numeri non e' possibile.**

### Incrocio con le nostre misure (BCM, tick reali, 2026, M1, cella 0,05; R1A)
- **Di giorno e' un disastro** e' COERENTE in direzione con la nostra lettura per fascia oraria (S6, report/GBA_R0_R1A_LETTURA_2026-10-10.md): europa PF_V 0,52 (n=132), USA apertura 0,70 (n=381, segno concorde 3/3 tranche, p=0,009). **La notte (asia 00-07 server) e' la fascia meno cattiva ma NON positiva su M1: PF_V 0,94 (n=142), non distinguibile da zero.** [MISURATO, M1, una sola finestra, un regime].
- **M5 non l'abbiamo misurato**: e' la casella 5 del certificato di morte (TF) ancora aperta. Ipotesi [DERIVATA]: a M5 l'ATR e' piu' grande e il rapporto stop/spread migliora, quindi la frontiera del costo (stop >= 40 x spread) e' meno stretta che a M1; report/GBA_R2_PIANO_2026-10-10.md valuta la stima.
- "Doppio in 2 anni, DD 7-11%" **non e' confrontabile** senza il rischio per trade: l'EA di Emiliano usa lotto fisso; il nostro R1A e' a lotto fisso 1,00 con deposito fittizio 1.000.000 (il DD in % non si legge). Va rifatto con rischio dichiarato.

### Che cosa se ne fa (nessun criterio cambia)
- **Misura proposta** (dentro il piano R2, casella 5 + fascia oraria): EA a **M5** e finestra notturna fissata PRIMA dei numeri (es. asia 00-07 server BCM, sapendo che l'orologio BCM e' UTC+1 fisso dal dicembre 2024 e segue Londra prima), tick reali 2024.07.10-2026.09.30, a regimi, con long e short separati, secondo il criterio firmato il 10/10 (PF netto > 1,0 in OGNI regime con >= 150 operazioni). Anche H1 come asse di confronto, perche' lo cita.
- **Domande da fare a Roberto** (per rendere il suo numero confrontabile): vedi report/GBA_R2_PIANO_2026-10-10.md (§ domande al collega) o messaggio in chat.
- **Non** si adotta M5 notturno come parametro in forward, **non** si cambia nessuna sedia: e' un'ipotesi da misurare.
