# -*- coding: utf-8 -*-
"""Genera il dossier metodologico ABTG in PDF, per il Claude Code di un collega."""
from reportlab.lib.pagesizes import A4
from reportlab.lib.units import mm
from reportlab.lib import colors
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib.enums import TA_LEFT
from reportlab.platypus import (BaseDocTemplate, PageTemplate, Frame, Paragraph,
                                Spacer, Table, TableStyle, KeepTogether)

OUT = "/home/user/GITHUB/report/DOSSIER_METODO_ABTG_2026-09-11.pdf"

INK   = colors.HexColor("#16202A")
SOFT  = colors.HexColor("#4B5A67")
RULE  = colors.HexColor("#C9D3DB")
MEAS  = colors.HexColor("#1C5A56")   # misurato
DEF   = colors.HexColor("#8C3A31")   # difetto
BOXM  = colors.HexColor("#E7EFEE")
BOXD  = colors.HexColor("#F5E6E3")
BOXN  = colors.HexColor("#EDF1F4")

def S(name, **kw):
    base = dict(fontName="Helvetica", fontSize=9.3, leading=13.2, textColor=INK,
                alignment=TA_LEFT, spaceAfter=5)
    base.update(kw)
    return ParagraphStyle(name, **base)

s_body  = S("body")
s_h1    = S("h1", fontName="Helvetica-Bold", fontSize=17, leading=20, spaceBefore=16,
            spaceAfter=3, textColor=INK)
s_h1s   = S("h1s", fontSize=9, leading=12, textColor=SOFT, spaceAfter=11)
s_h2    = S("h2", fontName="Helvetica-Bold", fontSize=11.2, leading=14, spaceBefore=11,
            spaceAfter=4)
s_h3    = S("h3", fontName="Helvetica-Bold", fontSize=9.6, leading=12.6, spaceBefore=7,
            spaceAfter=2, textColor=SOFT)
s_small = S("small", fontSize=8.2, leading=11, textColor=SOFT)
s_cell  = S("cell", fontSize=8.3, leading=11)
s_cellb = S("cellb", fontSize=8.3, leading=11, fontName="Helvetica-Bold")
s_mono  = S("mono", fontName="Courier", fontSize=8.2, leading=11)
s_lead  = S("lead", fontSize=10.4, leading=15, textColor=INK, spaceAfter=8)

def P(t, st=s_body):  return Paragraph(t, st)
def H1(t, sub=None):
    o = [P(t, s_h1)]
    if sub: o.append(P(sub, s_h1s))
    return o
def H2(t): return [P(t, s_h2)]
def H3(t): return P(t, s_h3)

def box(titolo, testo, kind="n"):
    bg = {"m": BOXM, "d": BOXD, "n": BOXN}[kind]
    ln = {"m": MEAS, "d": DEF, "n": SOFT}[kind]
    inner = [[Paragraph(titolo, S("bt", fontName="Helvetica-Bold", fontSize=7.6,
                                  leading=10, textColor=ln, spaceAfter=3))],
             [Paragraph(testo, S("bb", fontSize=8.6, leading=11.8))]]
    t = Table(inner, colWidths=[163*mm])
    t.setStyle(TableStyle([
        ("BACKGROUND", (0,0), (-1,-1), bg),
        ("LINEBEFORE", (0,0), (0,-1), 2, ln),
        ("LEFTPADDING", (0,0), (-1,-1), 7), ("RIGHTPADDING", (0,0), (-1,-1), 7),
        ("TOPPADDING", (0,0), (-1,0), 6), ("BOTTOMPADDING", (0,-1), (-1,-1), 6),
        ("TOPPADDING", (0,1), (-1,1), 0), ("BOTTOMPADDING", (0,0), (-1,0), 1),
    ]))
    return [Spacer(1,3), t, Spacer(1,6)]

def tabella(head, righe, widths, align_r=()):
    data = [[Paragraph(h, S("th", fontName="Helvetica-Bold", fontSize=7.4, leading=9.6,
                            textColor=SOFT)) for h in head]]
    for r in righe:
        data.append([Paragraph(c, s_cell) for c in r])
    t = Table(data, colWidths=widths, repeatRows=1)
    st = [("LINEBELOW", (0,0), (-1,0), 0.9, INK),
          ("LINEBELOW", (0,1), (-1,-2), 0.4, RULE),
          ("VALIGN", (0,0), (-1,-1), "TOP"),
          ("LEFTPADDING", (0,0), (-1,-1), 0), ("RIGHTPADDING", (0,0), (-1,-1), 7),
          ("TOPPADDING", (0,0), (-1,-1), 4), ("BOTTOMPADDING", (0,0), (-1,-1), 4)]
    for c in align_r: st.append(("ALIGN", (c,0), (c,-1), "RIGHT"))
    t.setStyle(TableStyle(st))
    return [Spacer(1,3), t, Spacer(1,7)]

# ----------------------------------------------------------------- contenuto
F = []

F += [Spacer(1, 4)]
F += [P("DOSSIER METODOLOGICO &mdash; PROGETTO ABTG", S("tt", fontName="Helvetica-Bold",
        fontSize=8, leading=11, textColor=SOFT, spaceAfter=8))]
F += [P("Come misuriamo un Expert Advisor<br/>prima di metterci dei soldi",
        S("big", fontName="Helvetica-Bold", fontSize=21, leading=25, spaceAfter=10))]
F += [P("Scritto l'11 settembre 2026 <b>per il Claude Code di un collega</b>. "
        "Non e' una presentazione: e' un manuale operativo. Ogni regola qui dentro e' "
        "nata da un errore che abbiamo pagato, e il caso reale sta scritto accanto "
        "alla regola perche' senza il caso la regola non si ricorda e non si applica.", s_lead)]
F += box("PREMESSA ONESTA",
    "Questo progetto <b>non ha ancora una strategia validata e schierata</b>. Su otto "
    "candidate, oggi ne passa tutti i requisiti <b>una</b>. Cio' che ha prodotto di "
    "valore, finora, e' il <b>metodo di misura</b>: un apparato che riconosce le "
    "illusioni prima che costino. Chi legge per copiare un EA vincente perde tempo; "
    "chi legge per copiare i cancelli, no.", "n")

# ---- 1
F += H1("1. Il contesto in cinque righe")
F += [P("Si costruiscono EA per MetaTrader 5 con l'obiettivo di superare la prova di una "
        "<b>prop firm</b> (societa' che affida capitale a chi supera un test a regole strette: "
        "target di profitto, tetto di perdita giornaliero e totale). La prova ha una data. "
        "Questo cambia tutto: <b>la frequenza diventa il requisito principale</b>, perche' una "
        "strategia da 1 operazione al giorno accesa oggi raggiunge le 150 operazioni fra "
        "sei mesi, non fra tre settimane.", s_body)]
F += [P("L'unita' di misura non e' l'EA ma la <b>sedia</b>: motore &times; simbolo &times; "
        "timeframe &times; configurazione, identificata da un <i>magic number</i>. Lo stesso "
        "motore su due simboli sono due sedie, e si giudicano separatamente &mdash; e' misurato "
        "che una puo' funzionare e la gemella no.", s_body)]

# ---- 2
F += H1("2. Cosa deve essere vero perche' una sedia si possa schierare",
        "Quattro requisiti, e vanno soddisfatti tutti e quattro insieme.")
F += tabella(["", "REQUISITO", "COSA VERIFICA DAVVERO"],
  [["R1","Cella promossa","Esiste un round che ha promosso <b>esattamente</b> la configurazione che gira. Senza, il rischio dichiarato descrive una cella diversa da quella in campo."],
   ["R2","Perdita massima dichiarata","Il drawdown di backtest <b>con deposito, rischio per operazione e modello del tester</b>. Un DD senza quei tre non e' un numero."],
   ["R3","Frequenza misurata","Operazioni al giorno. Si applica per <b>famiglia</b> (motore &times; simboli schierabili), non per singola sedia."],
   ["R4","Rischio vero = rischio dichiarato","Il piu' selettivo. Un tetto di rischio alimentato da input bugiardi <b>non e' una protezione</b>."]],
  [9*mm, 34*mm, 120*mm])
F += box("STATO REALE, 11/09/2026",
    "8 candidate. R2 e R3 pieni su 8/8. <b>R4 su 2/8.</b> Passano tutti e quattro: <b>UNA</b>. "
    "Il collo di bottiglia non e' il rendimento: e' che sei sedie su otto <b>rischiano fino al "
    "doppio di quello che dichiarano</b>, per un difetto di due righe.", "d")

# ---- 3
F += H1("3. I cancelli, con le soglie esatte")
F += H2("3.1 Cancelli di round (si congelano PRIMA di vedere i numeri)")
F += tabella(["CANCELLO", "SOGLIA", "NOTA"],
  [["Costo","stop &ge; <b>40 &times; spread</b> mediano <b>dell'ora in cui la sedia opera</b>","Chi non lo passa non si legge nemmeno, qualunque profitto abbia. Pavimento duro: <b>13,3&times;</b>."],
   ["Rischio (OOS)","DD fuori campione &le; <b>7,00%</b>","Si legge a qualunque numero di operazioni: un drawdown e' un fatto accaduto."],
   ["Rischio (IS)","DD dentro campione &le; <b>9,00%</b>",""],
   ["Merito","Profit Factor fuori campione &ge; <b>1,40</b>","Si legge SOLO fuori campione, e solo se il campione e' sufficiente."],
   ["Campione","n OOS &ge; 95 e n IS &ge; 57","Soglia di <b>leggibilita'</b>. Diversa dalla soglia di <b>merito</b> (150): vedi 4.1."],
   ["Altopiano","La cella scelta sta al centro di un blocco contiguo","Senza, il numero e' rumore. Vedi 3.3."]],
  [24*mm, 52*mm, 87*mm])
F += H2("3.2 Cancelli di portafoglio")
F += tabella(["", "VALORE", "STATO"],
  [["Cap sul rischio aperto simultaneo","3,25%","attivo"],
   ["Pausa giornaliera / chiusura d'emergenza","4,0% / 4,9%","attivo"],
   ["Tetto per cluster di valuta","3,0%","<font color='#8C3A31'><b>firmato ma NON attivo</b> &mdash; finche' non e' implementato e collaudato e' un'intenzione, non una protezione, e va detto ogni volta che si cita</font>"],
   ["Pavimento di frequenza (per famiglia)","1,00 op/giorno",""]],
  [58*mm, 26*mm, 79*mm])
F += H2("3.3 La regola di selezione della cella")
F += [P("<b>Mai il picco. Sempre il centro dell'altopiano.</b> Un picco isolato e' rumore; un "
        "altopiano e' un comportamento. Operativamente: si cercano i blocchi contigui di celle "
        "che passano tutti i cancelli, si prende il blocco piu' lungo, si tolgono le celle di "
        "bordo della griglia (hanno una vicina sola, quindi la verifica non e' possibile su di "
        "loro), e si sceglie il baricentro del blocco che resta.", s_body)]
F += box("PERCHE' E' SCRITTA COME PROCEDURA NUMERATA, E NON A PAROLE",
    "La prima stesura a parole ammetteva <b>due risposte diverse sulla stessa griglia</b>: due "
    "persone che partivano da celle diverse arrivavano a conclusioni opposte, e una delle due "
    "promuoveva una cella sul fianco di una salita &mdash; esattamente il caso che la regola "
    "diceva di evitare. Riscritta come procedura in otto passi e provata in forza bruta su "
    "<b>200.000 griglie casuali</b>: zero pareggi irrisolti. <b>Una regola di selezione che "
    "ammette due letture non e' una regola: e' un'opinione con un numero accanto.</b>", "d")

# ---- 4
F += H1("4. Le regole congelate", "Si cambiano PRIMA dei numeri, mai dopo. Ognuna ha il caso che l'ha generata.")
F += H2("4.1 L'unita' di misura e' l'OPERAZIONE, non l'anno")
F += [P("Il campione si dimensiona sulle <b>operazioni (&ge; 150)</b>, non sugli anni. Quanti anni "
        "servano lo detta la frequenza del motore, e si misura.", s_body)]
F += box("IL CASO",
    "Testavamo tutto dal 2010, che sembra prudente. Una strategia sullo yen risultava "
    "<b>0 celle positive su 28</b> nel 2010-2016 e <b>25 su 28</b> nel periodo recente. Non era "
    "una strategia scarsa: era un'epoca di mercato che non esiste piu'. <b>La finestra bocciava "
    "per il calendario, non per il merito.</b>", "d")
F += H2("4.2 Il VECCHIO giudica il RISCHIO. Il RECENTE giudica il MERITO.")
F += [P("Non si boccia un motore perche' non guadagnava nel 2012. <b>Si boccia se nel 2020 avrebbe "
        "fatto un drawdown del 25%</b> &mdash; perche' un drawdown e' un fatto accaduto, non una stima. "
        "Corollario operativo: sotto le 150 operazioni il <b>merito e' sospeso</b>, il <b>rischio no</b>.", s_body)]
F += H2("4.3 La prova di REGIME batte la storia contigua")
F += [P("Sedici anni di fila <b>diluiscono</b>: sei anni brutti piu' dieci buoni fanno una media che "
        "non descrive nessun mercato. Quattro finestre scelte (toro / orso / laterale / crollo) "
        "dicono di piu'. Il regime contenuto nel campione <b>si dichiara sempre</b>.", s_body)]
F += H2("4.4 Quando un motore e' senza edge, si cambia MECCANISMO, non parametri")
F += [P("Su un motore senza vantaggio reale, una griglia piu' fitta non trova un vantaggio: trova "
        "<b>picchi di rumore</b>. La cella verde per caso e' quella che brucia la prova. Si allarga su "
        "motori, meccanismi, simboli, timeframe e gestione dell'uscita; <b>non</b> sui parametri di un "
        "motore gia' dichiarato morto.", s_body)]
F += H2("4.5 Criterio di uscita di una sedia gia' in campo")
F += tabella(["CORSIA", "REGOLA"],
  [["Rischio (sempre)","DD reale &gt; DD promesso dal backtest della cella promossa &rarr; revisione immediata."],
   ["Merito (a 20 operazioni)","Famiglia a 20+ operazioni in perdita &rarr; si spegne la sedia colpevole, la gemella positiva resta."],
   ["Tagliando (6 mesi)","Famiglia sotto 20 operazioni e in perdita &rarr; revisione. Frequenza molto sotto il promesso &rarr; revisione."]],
  [34*mm, 129*mm])

# ---- 5
F += H1("5. L'apparato di verifica", "E' la parte che vale davvero, ed e' quella replicabile fuori dal trading.")
F += H2("5.1 Il cancello prima di ogni passaggio &mdash; BLOCCANTE")
F += [P("Niente esce dalla sessione senza un PASS. Vale per: comandi da eseguire, script nuovi o "
        "modificati, file di configurazione di un test, modifiche a un EA, e <b>verdetti che "
        "archiviano un candidato</b>. Due strati, e servono tutti e due:", s_body)]
F += tabella(["STRATO", "COSA FA", "PERCHE' SERVE"],
  [["Deterministico","Uno script che controlla forma, percorsi vietati, versioni, codifica, riferimenti a commit","Non ragiona, quindi <b>non dimentica</b>"],
   ["Di giudizio","Un agente separato che apre gli script e verifica che facciano quello che promettono","Ragiona, quindi <b>vede quello che la forma non cattura</b>"]],
  [30*mm, 70*mm, 63*mm])
F += box("E LA META' CHE COSTA DAVVERO",
    "<b>Se il controllo non e' ancora tornato, si aspetta.</b> Non si manda &laquo;tanto probabilmente "
    "va bene&raquo;. La regola e' nata il giorno in cui un comando e' partito prima che il "
    "verificatore rispondesse: il verificatore poi ha trovato <b>tre difetti bloccanti</b>. "
    "E' andata bene <b>per fortuna, non per metodo</b> &mdash; e la fortuna non e' un metodo.", "d")
F += H2("5.2 Il canarino")
F += [P("Prima di una prova costosa se ne lancia una minuscola, <b>progettata apposta per fallire "
        "rumorosamente</b> se qualcosa non va.", s_body)]
F += box("IL CASO CHE LO HA RESO LA REGOLA",
    "Prima di sei test pesanti, il canarino ha messo nel file di configurazione una chiave "
    "<b>inventata di sana pianta</b>. Ragionamento: se il programma e' onesto deve protestare; "
    "se non protesta, ignora le chiavi &mdash; e allora ignorava anche la mia. <b>Non ha protestato.</b> "
    "Quella chiave non esiste e veniva ignorata in silenzio. Senza il canarino avremmo prodotto un "
    "referto tutto verde: <b>una bugia con i numeri sotto</b>, la specie piu' pericolosa.", "m")
F += box("E IL COROLLARIO, PAGATO DOPO",
    "Un nostro canarino e' stato <b>cieco per due giorni</b>: il sistema che sorvegliava era passato "
    "a una versione nuova e scriveva il suo stato in caselle rinominate, mentre il canarino "
    "guardava le vecchie. Trovava tutto tranquillo perche' <b>guardava scatole vuote</b>. "
    "<b>Chi controlla va controllato: un canarino che non puo' morire e' una decorazione.</b>", "d")
F += H2("5.3 Il contro-esempio prima della consegna")
F += [P("Prima di consegnare una misura, uno strumento o un verdetto, bisogna costruire <b>da soli il "
        "contro-esempio che lo farebbe sbagliare</b>, e far vedere che non sbaglia.", s_body)]
F += tabella(["FORMA", "REGOLA OPERATIVA"],
  [["Se l'attesa e' una banda","Va provata contro l'<b>ipotesi alternativa</b>, non contro il nulla. &laquo;Se non c'e' niente esce un numero basso&raquo; non e' un test: quale numero produce l'ALTRA spiegazione? Se cade dentro la banda, la banda non misura niente."],
   ["Se c'e' una formula","Si verifica contro <b>numeri veri gia' scritti da qualcun altro</b>, non contro due valori che tornano: con due incognite libere torna sempre qualcosa. Prima si cerca il file che ha gia' la risposta."],
   ["L'insieme del verdetto","Si elenca <b>per nome</b>, mai come &laquo;tutto cio' che non e' X&raquo;."],
   ["Se non ci riesci","<b>Non hai capito la misura abbastanza da consegnarla.</b> Si aspetta."]],
  [40*mm, 123*mm])
F += box("LA CAUSA UNICA DIETRO A TUTTI I CASI IN CUI E' SERVITA",
    "Avevo controllato che la mia risposta fosse <b>coerente con quello che mi aspettavo</b>, invece "
    "di provare a <b>romperla</b>. Quella non e' verifica: e' <b>conferma</b>. E costa giornate.", "d")
F += H2("5.4 Il certificato di morte")
F += [P("Un candidato <b>non si archivia come morto</b> se manca anche una sola di queste cinque:", s_body)]
F += tabella(["", "COSA DEVE ESISTERE"],
  [["1","Un indicatore di redditivita' <b>misurato</b>"],
   ["2","Un numero di operazioni e un drawdown"],
   ["3","La gestione dell'uscita messa ad asse almeno una volta"],
   ["4","I simboli gemelli provati"],
   ["5","Il timeframe cambiato almeno una volta"]],
  [9*mm, 154*mm])
F += [P("Se ne manca una, il verdetto e' <b>&laquo;non ancora misurato&raquo;</b>, non &laquo;morto&raquo; &mdash; e va scritto "
        "<b>cosa manca</b>. Un morto senza certificato non e' un morto: e' un'occasione persa che nessuno "
        "ritrovera' piu'.", s_body)]
F += box("IL CASO, E HA PRODOTTO RISULTATI DUE VOLTE",
    "Il censimento degli archiviati ha trovato: <b>sei candidati su sette</b> bocciati &laquo;per "
    "frequenza&raquo; <b>senza un solo indicatore di redditivita' misurato</b>; un drawdown del 42,9% "
    "citato in un documento per un motore <b>mai eseguito</b>; e una strategia con numeri buoni ferma in "
    "demo perche' nessuno l'aveva ripresa. Un secondo passaggio, giorni dopo, ha trovato un candidato "
    "ancora sotto il titolo &laquo;morto, con certificato completo&raquo; che aveva il <b>drawdown scritto "
    "come trattino</b> mentre il censimento ce l'aveva: <b>era il piu' basso della tabella</b>.", "m")
F += H2("5.5 Il catalogo dei difetti")
F += [P("Ogni difetto di <b>classe nuova</b> entra in un catalogo con la data e il caso reale. Oggi conta "
        "<b>225 classi</b>. Non e' burocrazia: e' la memoria. Un difetto che non entra nel catalogo si "
        "ripaga, e il costo della seconda volta e' identico alla prima.", s_body)]

# ---- 6
F += H1("6. Le trappole, con il caso che le ha generate",
        "Questa e' la sezione da leggere per prima se hai poco tempo. Sono errori di misura, non di trading: si ripresentano in qualunque dominio.")

def trappola(titolo, caso, regola):
    return KeepTogether([H3(titolo),
        Paragraph("<b>Il caso.</b> " + caso, S("tc", fontSize=8.7, leading=11.8, spaceAfter=3)),
        Paragraph("<b>La regola.</b> " + regola, S("tr", fontSize=8.7, leading=11.8,
                   textColor=MEAS, spaceAfter=8))])

F += [trappola("Lo zero che era un file fermo",
    "Per giorni un rapporto automatico ha scritto <b>+0,00</b> su un conto. Sembrava una giornata "
    "piatta. Era un file che non si aggiornava da tre giorni, e il programma controllava soltanto che "
    "il file <b>esistesse</b>. &laquo;Nessuna operazione&raquo; e &laquo;dati non arrivati&raquo; uscivano identici.",
    "Uno zero non e' un risultato finche' non dimostri di aver guardato nel posto giusto. Uno strumento "
    "deve stampare <b>frasi diverse</b> per &laquo;non trovato&raquo;, &laquo;trovato ma vuoto&raquo; e &laquo;misurato zero&raquo;.")]
F += [trappola("Il totale letto su una finestra che non c'era",
    "Due sedie portavano l'etichetta <b>&laquo;campione pieno&raquo;</b> con 227 e 155 operazioni. Il 227 era "
    "della corsa a <b>finestra piena</b>, che non ha nessun fuori campione. Spezzata, la stessa corsa fa "
    "<b>84 e 143</b> &mdash; e sono sotto soglia tutte e due. L'etichetta diceva l'opposto del vero, su una "
    "colonna che decide.",
    "Un <i>n</i> non e' un numero: e' un numero <b>piu' la finestra da cui viene</b>. Una soglia pensata per una "
    "finestra <b>non si raggiunge sommandone due</b>.")]
F += [trappola("La guardia spenta da un token obbligatorio",
    "Il controllo automatico riconosceva una &laquo;guardia di sicurezza&raquo; per <b>presenza</b> della parola "
    "<i>throw</i> nel comando. Ma <b>ogni comando del progetto contiene un throw</b>: e' il controllo di "
    "versione, ed e' obbligatorio. Risultato misurato: un comando puntato sul <b>conto con soldi veri</b> "
    "riceveva la risposta &laquo;nessun difetto&raquo;. <b>Il buco era attivo su tutti i comandi, non su un caso raro.</b>",
    "Una guardia riconosciuta per <b>presenza</b> di un token invece che per <b>posizione</b> e' falsificabile da "
    "qualunque uso legittimo dello stesso token. Se quel token e' obbligatorio altrove nello stesso "
    "oggetto, la guardia non e' debole: <b>e' spenta</b>.")]
F += [trappola("La correzione che non insegue i suoi discendenti",
    "Corretto un numero sbagliato di un fattore 10, sono rimasti <b>tre numeri derivati</b>, uno <b>tre righe "
    "sotto nello stesso paragrafo</b>. Il peggiore sorreggeva un <b>ragionamento</b>: era la ragione scritta "
    "per non fare una certa prova, e col numero corretto quella ragione non reggeva piu'.",
    "Correggere e' il momento in cui si sbaglia di piu'. Dopo ogni correzione si cerca il <b>valore</b> nel "
    "progetto, non il concetto &mdash; e i figli piu' pericolosi sono quelli che sorreggono un argomento, "
    "perche' il numero si vede e l'argomento no.")]
F += [trappola("L'errore di categoria travestito da errore di misura",
    "Due fonti si contraddicevano di un fattore 3-5 sul costo di transazione: la nostra sonda diceva "
    "0,2-0,4, il fornitore 0,8-1,0. Per settimane e' rimasta una &laquo;contraddizione aperta&raquo;. La causa: il "
    "conto e' <b>a commissione</b>, e la commissione non era nel conto. 0,3 + 0,5 = <b>0,86</b>, cioe' la cifra "
    "del fornitore. <b>Erano vere tutte e due.</b>",
    "Quando due misure oneste si contraddicono, l'ipotesi da provare per prima non e' &laquo;una delle due "
    "sbaglia&raquo; ma <b>&laquo;stanno misurando due cose diverse&raquo;</b>. E non si mediano mai.")]
F += [trappola("Il banco di prova rotto, non l'esaminato",
    "Alzando un campione di test da 20 a 200 casi, 12 controlli sono diventati rossi insieme. Il difetto "
    "non era nel codice sotto esame: il <b>generatore</b> dei casi scriveva date impossibili che il lettore "
    "scartava in silenzio, e 169 casi su 200 sparivano. In un altro giro, un test scritto da me diceva "
    "&laquo;zero difetti&raquo; su tutto: cercavo una parola al singolare in un testo che la stampa al plurale.",
    "Quando molti controlli cadono <b>insieme</b>, si sospetta prima <b>il banco che esamina</b>. E un test che "
    "non ha mai visto un fallimento vero non e' un test: e' una decorazione.")]
F += [trappola("La regola che avrebbe buttato via cio' che cercava",
    "La regola di selezione, provata su otto griglie costruite apposta per romperla, su due falliva. Su "
    "una di quelle due &mdash; <b>il caso statisticamente piu' probabile al suo primo uso reale</b> &mdash; scartava "
    "il blocco col risultato migliore. Sull'altra, un gruppo di celle <b>perdenti</b> vinceva perche' era "
    "piu' lungo.",
    "Una regola nuova va <b>eseguita a mano su casi avversari costruiti apposta</b>, prima che tocchi dati "
    "veri. Sui dati veri un difetto di selezione e' invisibile: produce un numero plausibile.")]

# ---- 7
F += H1("7. Cosa NON facciamo", "Elencato, perche' l'assenza di una pratica e' un'informazione.")
F += tabella(["", "E PERCHE'"],
  [["Non si ottimizza su dati che hanno gia' deciso","Il fuori campione si guarda una volta sola."],
   ["Non si ammorbidisce un criterio dopo aver visto il numero","I criteri si firmano prima. Se il numero non piace, si dichiara l'esito."],
   ["Non si promuove su un picco","Solo il centro di un altopiano."],
   ["Non si tocca un parametro in campo per una singola giornata storta","Il test decide, il campo osserva. Un difetto <b>meccanico</b> invece si corregge subito."],
   ["Non si usa un modello approssimato per un verdetto","Serve solo a scremare. I verdetti si danno sui dati veri."],
   ["Non si sommano due finestre per raggiungere una soglia","Vedi 6."]],
  [72*mm, 91*mm])

# ---- 8
F += H1("8. Se dovessi portarti via tre cose sole")
F += box("1 &mdash; I CRITERI SI FIRMANO PRIMA DEI NUMERI",
    "E' l'unica difesa strutturale contro il costruirsi la risposta che si voleva. Tutto il resto "
    "dell'apparato serve a rendere questa regola <b>eseguibile</b> invece che <b>dichiarata</b>.", "m")
F += box("2 &mdash; VERIFICARE NON E' CONFERMARE",
    "Controllare che il risultato sia coerente con l'attesa e' <b>conferma</b>. La verifica e' costruire "
    "il caso che lo farebbe sbagliare e mostrare che non sbaglia. Se non riesci a costruirlo, non hai "
    "capito la misura abbastanza da consegnarla.", "m")
F += box("3 &mdash; UN ARCHIVIO CHE REGISTRA GLI ERRORI VALE PIU' DI UNO CHE REGISTRA I SUCCESSI",
    "225 classi di difetto catalogate con data e caso reale. Ogni volta che una si ripresenta, costa "
    "zero invece che una giornata. E un elenco di soli successi <b>descrive male la realta'</b>, "
    "che e' un errore di misura come gli altri.", "m")

F += [Spacer(1, 8)]
F += [P("Progetto ABTG &mdash; dossier metodologico, 11 settembre 2026. Ogni numero di questo documento "
        "viene da un file dell'archivio del progetto, con data e fonte. Nomi di conto, parametri "
        "operativi e configurazioni sono omessi di proposito. Dove una misura non esiste, il progetto "
        "scrive &laquo;non misurato&raquo; &mdash; e questo documento fa lo stesso.", s_small)]

# ----------------------------------------------------------------- render
def deco(canv, doc):
    canv.saveState()
    canv.setStrokeColor(RULE); canv.setLineWidth(0.5)
    canv.line(23*mm, 16*mm, 196*mm, 16*mm)
    canv.setFont("Helvetica", 7); canv.setFillColor(SOFT)
    canv.drawString(23*mm, 11*mm, "Progetto ABTG — dossier metodologico — 11/09/2026")
    canv.drawRightString(196*mm, 11*mm, "pag. %d" % doc.page)
    canv.restoreState()

doc = BaseDocTemplate(OUT, pagesize=A4,
                      leftMargin=23*mm, rightMargin=14*mm,
                      topMargin=18*mm, bottomMargin=22*mm,
                      title="Dossier metodologico ABTG",
                      author="Progetto ABTG")
frame = Frame(doc.leftMargin, doc.bottomMargin,
              A4[0]-doc.leftMargin-doc.rightMargin,
              A4[1]-doc.topMargin-doc.bottomMargin, id="f")
doc.addPageTemplates([PageTemplate(id="p", frames=[frame], onPage=deco)])
doc.build(F)
print("PDF scritto:", OUT)
