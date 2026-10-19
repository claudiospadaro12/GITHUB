# Prop Firm Gold EA -- ripetizioni della corsa continua (S-STAB): regole e previsioni scritte PRIMA dei numeri (19/10/2026)

Contesto: nel test a fondo il Prop Firm Gold EA ha passato tutte le soglie (continua +1.591 EUR, PF 1,26, 673 operazioni, drawdown dal picco 7,8%, lotto 0,01, massimo 3 posizioni). La pagina del Market dichiara una **randomizzazione** (e nel setaccio H1 e M15 hanno dato +550 e +524 a parita' di operazioni). Regola S-STAB scritta prima (`MARKET_SELEZIONE_PER_ACQUISTO_ATTESE_2026-10-19.md`): **lo stesso giro ripetuto 3 volte, le soglie valgono sul PEGGIORE**.
## Cosa si fa
`RIGA_LANCIA_STAB_PROPFIRM.txt`: **3 nuove corse continue** (01/01/2025 - 01/10/2026, XAUUSD H1, 5.000 EUR, input non imposti) con lo stesso `.ex5` e lo stesso script `DEEP_TESTER_TRANCHE.ps1` (`-Tranche 22`). Insieme alla corsa del test a fondo sono **4 corse**; le soglie si valutano sul **peggiore delle 4**. Controllo input obbligatorio (devono coincidere con quelli del setaccio).
## Soglie sul peggiore delle 4 corse (valgono come per il test a fondo, adattate alla corsa continua)
- **S-N**: operazioni >= 150.
- **S-M**: profitto netto > 0 e **>= 60% dei mesi di calendario positivi** (dai deal chiusi, per mese).
- **S-H**: somma > 0 in gen 2025 - mag 2026 **e** in giu 2026 - set 2026.
- **S-DD**: perdita massima dal deposito <= 10% **e** drawdown di equity dal picco <= 15,2% (sostituisce il "drawdown mensile": nella continua non ci sono mesi indipendenti; e' piu' severo).
- **S-NOSCALA**: lotto max/min <= 3, <= 10 posizioni contemporanee.
- **S-COSTO**: profitto medio per operazione >= 3 volte lo spread (circa 0,18 EUR per 0,01 lotto, stima 20 punti).
- Se **una** corsa su 4 non soddisfa una soglia, **S-STAB e' smentita** per quella soglia.
## Previsioni dichiarate ORA
- **P6**: le 4 corse **non sono tutte identiche** (la randomizzazione agisce nel tester) ma restano **tutte positive**, con profitto fra +500 e +2.500 EUR.
- **P7**: il profit factor di ogni corsa resta sopra 1,10.
- Se le 4 corse sono IDENTICHE al centesimo, la randomizzazione nel tester non agisce (si scrive cosi'), e la stabilita' va giudicata da una finestra diversa, non da ripetizioni identiche.
