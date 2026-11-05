# #all-gold-eas, settembre 2026 - sintesi (file DISCORD_PASSATO_all-gold-eas_2026-09_2026-09.md, 5.105 messaggi, 01-30/09)

Letto da me per intero il blocco Wim/staff (righe 958-1110 del file) e ricontrollato il testo dei 26 "set modificati" degli utenti. Immagini e allegati NON letti. Numeri degli utenti = dichiarazioni non verificate. Restano da leggere gennaio-agosto di questo canale.

## Wim / staff (citazioni dal file, tutte con link nel file originale)
- 04/09 Wim: il set Gold Reaper che ha fatto "70k da 400 usd" usa "extreme trade frequency at 204% max allowed total drawdown". E' un cliente, non un riferimento di rischio ragionevole.
- 07/09 Wim: l'EA oro "doesn't check the leverage. Only your risk settings and your trade frequency and balance. You can't run high risk on low leverage... you'll get margin errors". Rilevante per FTMO (leva bassa).
- 09/09 Wim: poche operazioni dipendono dalla trade frequency e dal fatto che gli EA oro fanno breakout di livelli "importanti": se non ci sono livelli vicini al prezzo non operano.
- 20-21/09 Wim: tutti i suoi "max drawdown at 0.01lots" sono calcolati SENZA ridurre il lotto durante i drawdown (backtest a lotto fisso). Quindi il DD storico e' quello di un lotto che non diminuisce.
- 23/09 Wim: in Gold Reaper lo SL si puo' solo "aggiustare di qualche pip"; solo con UBS si imposta liberamente.
- 27/09 Marcus Wyatt (ruolo staff NON verificato): per scegliere le strategie serve "Trade Frequency = Manual strategy selection", che obbliga a usare Start Lots o Max Risk Per Strategy; con "Max Allowed Total Drawdown" non si puo' disattivare strategie. Ha tolto solo strategie con PF e P&L bassi; Gold Reaper S09 ha PF non buono ma "makes way more profit than any other strategy". Per il suo portafoglio: ogni EA spinto fino a ~40% di equity DD, poi ridotto per far posto agli altri 3, obiettivo ~30% max equity DD con tutti e 4 insieme. Le "raccomandazioni AI" dello screenshot le considera solo suggerimenti.
- 28/09 Wim: "not normal to have orders changed every second... suggest running with virtual expiration in any case"; "no, don't use virtual SL"; l'EA cambia lo SL solo ogni minuto; per le modifiche con autoloader si cambia ogni set file ("there are tools for that").
- 30/09 Wim: avvisi "hyperactivity" da ICMarkets circa una volta al mese, scattano a 2500-3000 messaggi, mai superati i 15000; poi "Add virtual trailingSL and TrailingTP for Gold EAs" (30/09): nuova versione degli EA oro.
- 28/09 Wim: bug noto, un EA non riconosce il proprio trade (non influisce sul trading), "fixed now in the update".
- 17/09 Wim: la versione piu' recente si scarica sempre dalla dashboard.

## Cosa fanno gli utenti (non verificato)
- Strategia 9 di Gold Reaper: piu' utenti la disattivano o la sostituiscono con UBS Scalp C (sattysingh56 15/09, Classicaltrading 30/09: backtest solo S09 al 30% DD "less stable in R/R", Flygplan 30/09). Disattivandola gli ordini pendenti gia' piazzati non vengono rimossi (Classicaltrading 30/09).
- Scalp C: maindfriik (conti "yolo") filtro NFP disattivato e ingressi multipli; rischio 8% per trade sui conti yolo, 3% per strategia sul conto principale, 2% per lo scalp (28/09); Bendy_Zion: "7 [perdite] this month, about to remove it" (28/09).
- "Max DD" del set Gold: 60 -> 120 (Alicanto 23/09; poi "false results, il DD separato era ~70%"); Ircle: TGP e TGR a 15% DD ciascuno; Andrew Soma (13/09): "300% growth with max 20% dd" da inizio anno con strategie dei 4 EA oro in UBS, lotti/fake breakout/orari news ottimizzati (nessuna evidenza allegata, immagini non lette).
- Hyperactivity: Micha9886 aveva lo stesso magic number su due strategie (UBS cambiava di continuo gli ordini): corretto cambiando i magic. Eugen: virtual TP/SL su ICM; DanM: virtual expiration.
- BIGDEX (23/09): conto reale 2.000$ con balance impostato a 10.000$ per avere lotti piu' grandi: pratica rischiosa, nessuna risposta di Wim nel file.

## Cosa cambia per noi
1. I nostri EA oro live (Reaper/Phantom/Goldbot): controllare se usano "manual strategy selection" e se la strategia 9 del Reaper e' attiva; se si', e' tra quelle piu' discusse. Non modifico nulla sul live senza decisione di Claudio.
2. Il DD storico a 0.01 lotti e' a lotto non decrescente: quando simuliamo il Guardian conviene tenere conto che il lotto reale cala (o no) a seconda del metodo di lotto usato.
3. Hyperactivity: i nostri _Ottimizzato hanno magic diversi dagli originali, quindi non dovrebbe succedere per magic duplicati; da non cambiare.
4. Nuova versione EA oro del 30/09 (virtual trailing): verificare quale versione e' installata sul VPS e sul PC di test prima di confrontare risultati.
5. Allegati utili (da scaricare a mano, dopo antivirus): `goldreaper.set` e `Gold_Reaper_yolo.set` di Alicanto (24/09, set "yolo", solo come ipotesi di rischio estremo, non per i test prop).
