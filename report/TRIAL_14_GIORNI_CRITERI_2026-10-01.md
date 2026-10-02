# Free Trial FTMO 160.000 EUR (login 1514806751): cosa misuriamo in 14 giorni, scritto PRIMA dei numeri

Decisione di Claudio, 01/10/2026: **nessuna sedia aggiunta** oltre alla flotta della challenge (770101, 770105, 770202, 770260, 771531,
770511, 770411 + Guardian 779001) piu' **ABTG_Bulge v5.20 solo viola** (magic 772720) e **ABTG_ORB_Ottimizzato Dow** (magic 770621).
Presto caricati da Claudio, Algo Trading acceso il 01/10 mattina. Il rischio per operazione e' quello dei preset, tranne quanto Claudio
ha cambiato a mano nella finestra Input (da dichiarare: Bulge: **Risk_Percent=1.0, Max_Trades=3** dichiarati da Claudio il 01/10; Total_Risk_Percent=2.0 lasciato nel preset ma INERTE con Risk_Mode=0: il tetto del Bulge e' 1,0 x 3 = 3,0%).

## Cosa si misura (e cosa NO)
- **SI: meccanica.** esecuzione, ordini rifiutati, lotto reale contro atteso (lotto massimo FTMO), orari/orologio (server = IT+1), comportamento
  del Guardian (pausa 3,5%, emergenza 4,5%, cap 4,00% come bandiera), richieste/giorno, slippage (prezzo di segnale contro fill).
- **SI: frequenza.** posizioni per sedia contro il promesso (RFWD_CRITERI: 770101 0,699/g, 770202 0,348, 770260 0,360, 771531 0,931, 770511
  ~0,294, 770411 0,051, 770105 [NON MISURATO]); Bulge viola e ORB: frequenza [NON MISURATA] prima di oggi.
- **NO: merito.** ~11 posizioni della flotta in 8 giorni: nessun PF di questa trial vale come criterio di promozione o di archiviazione.
  Nessuna sedia si dichiara morta o promossa con questi numeri (certificato a 5 punti).

## Regole fisse per i 14 giorni (valgono per tutti, anche per me)
1. **Nessun trade manuale** sul conto 1514806751 (il 30/09 i manuali sull'oro hanno chiuso la challenge). Nessuna posizione manuale su
   indici o oro su NESSUN conto (hedging fra conti, supporto FTMO punto 8).
2. **Nessuna modifica di input o di preset** senza scriverla qui con data e ora (cambia i dati). Se serve, si spegne la sedia, non si ritocca.
3. **Contatori giornalieri** (da Claudio o dal report MT5, a fine giornata server): posizioni aperte/chiuse per magic, stop pieni, equity,
   drawdown giornaliero e totale, righe del Guardian (pausa, emergenza), rifiuti di ordini, lotti reali.
4. **Soglie di allarme scritte ora** (non sono criteri di merito, servono a non tenere acceso un conto rotto): equity <= 148.000 (pavimento di
   attenzione, 7,5% sotto l'iniziale), o 3 stop pieni nello stesso giorno, o un ordine con lotto o stop anomalo, o un Guardian che non scrive
   per piu' di 10 minuti con Algo acceso: si spegne Algo e si guarda prima di riaccendere.
5. **Letture dichiarate prima**: una sedia con zero posizioni in 14 giorni ha P(zero) per sorte in `report/RFWD_CRITERI.md`; zero contro zero
   non e' falsificabile. Un rifiuto di ordine per volume massimo e' un difetto di mappa del lotto, non un difetto della sedia.
6. **Scadenze**: 25/10 cambio d'ora (ORB e sedie US armano un'ora dopo se la trial dura oltre); ~05/10 il conto 541452707 si spegne (esportare lo
   storico); risposta del supporto FTMO su Free Trial e hedging fra conti.

## Cose ancora aperte (Claudio)
Bulge del piccolo BCM 50503392 contro la trial (22 cross contro 15: pausa o ridotto ai 7 comuni); `Max_Trades` del Bulge 3 o 4; ORB Ottimizzato:
nei dati di casa ha PF 0,27 su 8 posizioni sul piccolo e 3 su 15 (-295,58) sul forward FTMO: tenuto per scelta di Claudio, "non ancora misurato".

## Registro delle modifiche agli input durante i 14 giorni (regola 2: si scrive con data e ora)
- **01/10/2026, sera (dopo le ~22:30 server, ora esatta [NON LETTA]; tutto piatto, Guardian in pausa fino all'01:00 server)** -- Bulge sul grafico NZDCHF,H1 (terminale `1514806751`, `C:\FTMO`): Claudio ha **ripristinato il preset** `ABTG_Bulge_v520_SOLO_VIOLA_FTMO_TRIAL.set` (Viola, 15 cross, magic 772720, Blu e ADX spenti) e ha **cambiato `InpComment` in "BULGE VIOLA"** (preset: `BULGE_V520_FT`). Motivo detto da Claudio: nessuno scritto; **[NON NOTI]** `Risk_Percent` e `Max_Trades` scelti dopo il ripristino (0,8/4 del preset o 1,0/3).
- **Storia da ricordare nella lettura dei 14 giorni**: dalle ~06:00 alle ~22:30 del 01/10 il Bulge ha girato con DUE configurazioni: prima il preset (commento `BULGE_V520_FT_*`, 0,8%), poi una a valori di default con Risk 1,0 / Max_Trades 3 (commento `BULGE_VIOLA_*`, Blu+ADX, 22 cross, magic 772700). I trade del 01/10 vanno attribuiti per commento; dal ripristino in poi la configurazione e' quella del preset (con il commento cambiato).
- Verifica del ripristino da leggere in Esperti: `[BULGE][AUTOTEST] magic 772720 | commento "BULGE VIOLA" | rischio ...%` e `[BULGE] Init OK | Simboli: 15 | Rischio: PER_TRADE x% | Max trade: N`. Il commento "BULGE VIOLA" non rompe l'estrazione del tag (`ABTG_Bulge.mq5` r.527-529 cerca `_VIOLA_` nel commento completo, che diventa "BULGE VIOLA_VIOLA_S").
- **02/10/2026, ~15:10 ora italiana (ora esatta [NON LETTA])** -- Demo piccolo BCM `50503392` (`C:\Program Files\BCM Markets MT5 Terminal`, profilo ORO), tre PostNews: Claudio ha cambiato **a mano** (F7) `InpNewsFile`, `InpActionHour/Min`, `InpExpiryHour/Min` come da `report/POSTNEWS_TRE_SEDIE_2026-10-02.md`: `771203` NFP USDJPY -> `abtg_postnews_calendario.csv`, azione 14:45, scadenza 17:59; `771201` ECB EURJPY -> stesso file, azione 15:00, scadenza 18:15; `771202` FOMC EURUSD -> stesso file, orari invariati (19:40/20:45). **[NON LETTI]** i valori effettivi dopo l'OK e le righe `[PostNews][NEWS] ... UTILI` in Esperti: verifica attesa da Claudio. Rischio 1,3, magic, SL/TP, OCO: invariati. **Da fare dopo il 28/10 e prima del 09/12:** `771202` azione 20:40, scadenza 21:45.
