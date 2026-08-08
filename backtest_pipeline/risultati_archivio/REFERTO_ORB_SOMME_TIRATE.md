# 🏁 ORB — LE SOMME TIRATE

_Scritto l'08/08/2026 notte, a batteria completa. In una sera: 7 fonti raccolte
da Claudio, 8 round misurati (R7a/b, R8, R9, R10, R11, R12, R13), 4 mercati,
**~210 celle a tick reali**. Tutto sul laboratorio `ABTG_ORB_Ottimizzato`
(corso intatto). Referti singoli in questa cartella; CSV in
`risultati_prove/ABTG_ORB[_Ottimizzato]/`._

## Il tabellone

| round | ricetta (fonte) | mercato | esito |
|---|---|---|---|
| R7a/b | config live + geometria curata | NASUSD | ❌ 0/8 — la config live è la peggiore (IS −1477, DD 24,8%) |
| R8 | manuale ToolKit/webinar | NASUSD | ⚪ pareggio (PF OOS 1,02–1,03); i filtri fermano l'emorragia |
| R9 | utenti ABTG (TP 1:1, stop 50%, EMA200) | NASUSD | ❌ bocciata sui 3 punti, su quella base |
| R10 | manuale sull'oro ("come dice Emiliano") | XAUUSD | ❌ nessuna cella verde in entrambe |
| R11 | scheda "Dax Open Range" (0,2% + EMA50) | D30EUR | ❌ pareggio; 11° ribaltamento (Spearman −1,0) |
| R12 | articolo Fazen (15' + uscita a tempo) | NASUSD | ❌ 48/48 OOS negative (DD fino a 77%); 12° ribaltamento |
| R13 | edgeful (TP 0,5×, stop pieno, tetto 0,8%) | NASUSD | ❌ il claim; ✅ **ma trovato il primo ALTOPIANO** (sotto) |

## Le cinque verità che restano

1. **Il breakout puro al tocco è morto su tutti i mercati misurati.**
   Nasdaq (~150 celle), DAX (4), oro (4): perde o pareggia, sempre.
2. **Il RETEST è l'unico ingresso confermato** — dalla FASE M, dalla ricetta
   validata su DAX/Dow, e da Build Alpha che lo chiama "la configurazione a
   più alta probabilità". **Ce l'hai già live: si chiama famiglia Apertura.**
3. **I filtri delle fonti fermano l'emorragia, non creano l'edge** — e non
   sono universali: il volume aiuta sul Nasdaq (R8), affossa sull'oro (R10);
   l'EMA200 è inerte su una base (R9) e portante su un'altra (R13).
   I verdetti valgono per la base su cui sono misurati.
4. **I win-rate dichiarati dalle fonti (40–82%) non esistono** nelle nostre
   finestre da 30 mesi. Campioni da 23 trade e parametri "che cambieranno
   nel tempo" sono la firma dell'inseguimento della curva.
5. **L'IS ha mentito altre 3 volte in una sera** (10°→12° ribaltamento),
   incluso il rovescio perfetto di R11 (Spearman −1,0). La regola regge:
   l'IS dice se una regione esiste, mai quale cella scegliere.

## L'unica pista viva

**R13, altopiano: SOLO LONG + EMA200(M5) + OR 15' + TP 1,0–1,5× l'ampiezza +
stop ATR/50% range + sessione fino alle 21:00.** Otto celle verdi in ENTRAMBE
le finestre (6 con PF OOS ≥ 1,10, n ≥ 135) — mai successo prima. Freni già
scritti: ~150ª cella sul Nasdaq (multiple testing), DD OOS 11–15% (niente
prop cosi' com'è), campioni IS 73–81. **Vita o rumore lo decide il banco
vergine R14 sul Dow** (mai toccato dal motore ORB), criteri pre-dichiarati
nel file prova. Se passa: percorso normale (vicinato gestione per il DD,
classifica, decisione di Claudio). Se fallisce: era rumore selezionato, e
la famiglia ORB si chiude con onore — il breakout d'apertura, in tutte le
sue forme documentate, non paga sui nostri mercati.

## Il guadagno collaterale della serata

Fix `InpOneTradePerDay` (pendente che si girava — visto live il 06/08),
perimetro del filtro volume documentato, 3 rilevatori andati a segno (righe
identiche ×2, ribaltamenti ×3), un laboratorio ORB completo di 6 modi
d'ingresso/stop/target misurabili, e un backlog ordinato (fade del falso
breakout in cima). Il costo: una serata di CPU. L'alternativa era scoprirlo
col rischio live, a rate mensili.
