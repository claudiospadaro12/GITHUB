from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.lib.units import mm
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib.enums import TA_LEFT
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, KeepTogether
from reportlab.graphics.shapes import Drawing, Rect, String, Line
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
pdfmetrics.registerFont(TTFont('DV','/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf'))
pdfmetrics.registerFont(TTFont('DVB','/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf'))
pdfmetrics.registerFontFamily('DV',normal='DV',bold='DVB')
INK=colors.HexColor('#0b0b0b'); INK2=colors.HexColor('#52514e'); GRID=colors.HexColor('#d9d8d3'); SURF=colors.HexColor('#fcfcfb')
C1=colors.HexColor('#2a78d6'); C2=colors.HexColor('#eb6834'); C3=colors.HexColor('#1baf7a'); BAND=colors.HexColor('#f0efec')
H1=ParagraphStyle('h1',fontName='DVB',fontSize=19,leading=23,textColor=INK,spaceAfter=3)
SUB=ParagraphStyle('sub',fontName='DV',fontSize=9.5,leading=13,textColor=INK2,spaceAfter=8)
H2=ParagraphStyle('h2',fontName='DVB',fontSize=12.5,leading=16,textColor=INK,spaceBefore=10,spaceAfter=4)
P=ParagraphStyle('p',fontName='DV',fontSize=9,leading=12.8,textColor=INK,spaceAfter=4)
PS=ParagraphStyle('ps',fontName='DV',fontSize=8,leading=11,textColor=INK2,spaceAfter=3)
BUL=ParagraphStyle('bul',parent=P,leftIndent=10,bulletIndent=0,spaceAfter=3)
CELL=ParagraphStyle('cell',fontName='DV',fontSize=7.8,leading=10,textColor=INK)
CELLB=ParagraphStyle('cellb',parent=CELL,fontName='DVB')
def p(t,s=P): return Paragraph(t,s)
def bul(t): return Paragraph(t,BUL,bulletText='•')
def tbl(data,widths,head=1,zebra=True,align_right_from=1,fs=7.8):
    rows=[[Paragraph(str(c),CELLB if r<head else CELL) for c in row] for r,row in enumerate(data)]
    t=Table(rows,colWidths=widths,repeatRows=head)
    st=[('VALIGN',(0,0),(-1,-1),'MIDDLE'),('LINEBELOW',(0,0),(-1,0),0.8,INK),('LINEBELOW',(0,1),(-1,-1),0.25,GRID),
        ('TOPPADDING',(0,0),(-1,-1),3),('BOTTOMPADDING',(0,0),(-1,-1),3),('LEFTPADDING',(0,0),(-1,-1),4),('RIGHTPADDING',(0,0),(-1,-1),4)]
    t.setStyle(TableStyle(st)); return t
def footer(c,doc):
    c.saveState(); c.setFont('DV',7); c.setFillColor(INK2)
    c.drawString(18*mm,10*mm,'Backtest su conto virtuale (Strategy Tester MT5). Non e\' una consulenza finanziaria.')
    c.drawRightString(A4[0]-18*mm,10*mm,'pag. %d'%doc.page); c.restoreState()

# ---------------- dati (tutti da report/ nel repo) ----------------
WIN=[ # etichetta, regime, periodo, R oro, spread mediano barre D1, modello GB / GR,PF
 ('2013-14','RIBASSO','01/04/2013-31/03/2014','-19,6%','23'),
 ('2018-19','LATERALE','01/06/2018-31/05/2019','+0,4%','15'),
 ('2019-20','RIALZO','01/08/2019-31/07/2020','+39,6%','14'),
 ('2022-23','LATERALE','01/06/2022-31/05/2023','+7,0%','0 (*)'),
 ('2024','RIALZO','01/01/2024-31/12/2024','+27,2%','5 (*)'),
 ('2025-26','RIALZO FORTE','01/01/2025-30/09/2026 (21 mesi)','+59,2%','16'),
]
# per EA: n, netto, PF, DD% di 80K (equity)
GB=[(329,'+18.062',2.04,'7,7%'),(279,'+7.818',1.51,'7,3%'),(289,'+15.135',1.74,'7,4%'),(316,'+10.979',1.55,'7,5%'),(265,'+11.632',1.68,'6,3%'),(451,'+25.157',1.83,'9,1%')]
GR=[(505,'+25.664',1.77,'8,1%'),(558,'+16.497',1.57,'5,3%'),(457,'+26.410',2.18,'6,4%'),(561,'+13.314',1.52,'7,3%'),(515,'+22.364',1.91,'7,5%'),(791,'+59.796',2.89,'4,8%')]
PF=[(396,'-5.234',0.94,'27,4%'),(491,'-1.782',0.97,'12,1%'),(435,'+952',1.01,'15,5%'),(436,'+1.437',1.02,'10,8%'),(426,'+17.981',1.29,'8,8%'),(673,'+34.130',1.25,'13,8%')]
CORR_GBGR=[0.63,0.41,0.55,0.44,0.55,0.54]; CORR_GBPF=[0.07,0.30,0.27,0.13,0.22,0.11]; CORR_GRPF=[0.07,0.32,0.24,0.10,0.24,0.12]
PORT_GBGR=['8,1%','8,2%','9,3%','9,0%','5,6%','5,9%']; PORT_GBGR6=['6,6%','5,5%','7,1%','6,7%','5,6%','4,5%']
PORT_GRPF=['18,6%','10,9%','13,3%','12,8%','9,3%','10,1%']

story=[]
def addt(x):
    story.append(x); story.append(Spacer(1,5))
def fc(v): return ('%.2f'%v).replace('.',',')
story.append(p('Tre expert advisor sull\'oro, provati in sei mercati diversi',H1))
story.append(p('Riepilogo dei backtest su XAUUSD (oro) &middot; conto virtuale da 80.000 &euro; &middot; 21 ottobre 2026 &middot; preparato con Claude',SUB))
story.append(p('Cosa e\' questo documento',H2))
story.append(p('Tre programmi di trading automatico (expert advisor, EA) comprati dal marketplace MQL5 sono stati provati nel simulatore di MetaTrader 5 su <b>sei periodi di mercato diversi</b>: rialzi, laterali e un ribasso. Lo scopo e\' capire se funzionano <b>solo quando l\'oro sale</b> o anche negli altri mercati, e se due di loro insieme si diversificano. Non sono soldi veri: sono simulazioni su un conto virtuale.'))
story.append(p('I tre EA',H2))
story.append(bul('<b>Goldbot One</b> (grafico giornaliero). Provato con lotto proporzionale al saldo (impostazione "LotsizeStep"): uno step piu\' piccolo vuol dire lotti piu\' grandi. Sono state provate due varianti, 3.000 e 6.000; il documento mostra la 3.000.'))
story.append(bul('<b>The Gold Reaper</b> (grafico a 1 ora), con le impostazioni del venditore verificate.'))
story.append(bul('<b>Prop Firm Gold EA</b> (grafico a 1 ora), con le impostazioni predefinite.'))
story.append(p('Le cinque cose da sapere',H2))
story.append(bul('<b>Goldbot One e Gold Reaper reggono in tutti i sei periodi</b>, compreso il ribasso 2013-14 e i laterali: profit factor (PF) fra 1,51 e 2,89, perdita massima (DD) sempre sotto il 10% del conto.'))
story.append(bul('<b>Prop Firm Gold EA no</b>: ha PF 1,25-1,29 nei rialzi recenti, ma 1,01 nel rialzo 2019-20, circa 1,0 nei laterali e 0,94 nel ribasso (perdita massima 27,4% del conto). Segue il mercato, non ha un vantaggio proprio.'))
story.append(bul('<b>Goldbot One e Gold Reaper si assomigliano</b>: la correlazione giornaliera dei loro risultati va da 0,41 a 0,63 nei sei periodi, sopra la nostra soglia di 0,5 in quattro su sei. Insieme diversificano poco, ma la perdita massima combinata resta sotto il 10% in ogni periodo.'))
story.append(bul('<b>Gli ultimi 21 mesi sono un caso estremo</b>: l\'oro ha fatto +59% in un solo regime. Per questo i test sono stati ripetuti su altri periodi.'))
story.append(bul('<b>Limiti seri</b>: un solo anno per regime, simulazione con dati a 1 minuto, spread storico in due periodi inaffidabile (vedi pagina 5), prodotti a periodo di ottimizzazione ignoto.'))
story.append(Spacer(1,4))
box=Table([[Paragraph('<b>Cosa questo documento NON dice:</b> non consiglia di comprare, di tenere o di quanto investire in nessun EA. Quelle sono decisioni personali. I numeri sono simulazioni; il mercato reale ha slippage, latenza, regole del broker e periodi mai visti.',CELL)]],colWidths=[174*mm])
box.setStyle(TableStyle([('BACKGROUND',(0,0),(-1,-1),BAND),('BOX',(0,0),(-1,-1),0.5,GRID),('LEFTPADDING',(0,0),(-1,-1),8),('RIGHTPADDING',(0,0),(-1,-1),8),('TOPPADDING',(0,0),(-1,-1),6),('BOTTOMPADDING',(0,0),(-1,-1),6)]))
story.append(box)
story.append(PageBreak())

# ----- pagina 2: grafico + finestre
story.append(p('I sei periodi di mercato',H1))
story.append(p('Come sono stati scelti: finestre di 12 mesi classificate dal prezzo dell\'oro con una regola scritta prima dei test (rialzo: +15% o piu\'; ribasso: -15% o meno; laterale: entro +/-8% con oscillazione massima sotto il 25%). Il 2025-26 e\' il periodo gia usato all\'inizio.',SUB))
wd=[['Periodo','Regime','Date','Oro (rendimento)','Spread mediano (punti)']]+[[w[0],w[1],w[2],w[3],w[4]] for w in WIN]
addt(tbl(wd,[18*mm,26*mm,52*mm,34*mm,34*mm]))
story.append(p('(*) Nel 2022-23 lo spread registrato nelle barre e\' 0 in 191 barre su 310 e nel 2024 e\' molto basso: i costi simulati in quei periodi potrebbero essere troppo bassi. Per questo sono stati aggiunti i periodi 2018-19 e 2019-20, scelti con spread realistico (14-15 punti).',PS))
story.append(Spacer(1,6))
story.append(p('Profit factor per periodo',H2))
story.append(p('Il profit factor (PF) e\' il guadagno lordo diviso la perdita lorda: sopra 1 la strategia guadagna, sotto 1 perde. La linea tratteggiata e\' PF = 1.',PS))

def chart():
    W,Hh=174*mm,78*mm
    d=Drawing(W,Hh)
    x0,y0,pw,ph=26,22,W-34,Hh-34
    ymax=3.0
    sc=lambda v: y0+ph*v/ymax
    for g in (0,1,2,3):
        d.add(Line(x0,sc(g),x0+pw,sc(g),strokeColor=GRID,strokeWidth=0.4))
        d.add(String(x0-4,sc(g)-2.5,str(g),fontName='DV',fontSize=7,fillColor=INK2,textAnchor='end'))
    d.add(Line(x0,sc(1),x0+pw,sc(1),strokeColor=INK,strokeWidth=0.8,strokeDashArray=[3,2]))
    n=len(WIN); gw=pw/n; bw=gw*0.24
    series=[(GB,C1),(GR,C2),(PF,C3)]
    for i,w in enumerate(WIN):
        gx=x0+gw*i+gw*0.5
        for k,(S,col) in enumerate(series):
            v=S[i][2]; bx=gx+(k-1)*(bw+1.5)-bw/2
            d.add(Rect(bx,sc(0),bw,sc(v)-sc(0),fillColor=col,strokeColor=SURF,strokeWidth=0.8))
            d.add(String(bx+bw/2,sc(v)+2,fc(v),fontName='DV',fontSize=6.3,fillColor=INK,textAnchor='middle'))
        d.add(String(gx,y0-9,w[0],fontName='DVB',fontSize=7.5,fillColor=INK,textAnchor='middle'))
        d.add(String(gx,y0-18,w[1].lower(),fontName='DV',fontSize=6.5,fillColor=INK2,textAnchor='middle'))
    # legenda
    lx=x0
    for lab,col in (('Goldbot One (step 3000)',C1),('The Gold Reaper',C2),('Prop Firm Gold EA',C3)):
        d.add(Rect(lx,Hh-9,7,7,fillColor=col,strokeColor=None)); d.add(String(lx+10,Hh-8,lab,fontName='DV',fontSize=7.5,fillColor=INK)); lx+=118
    return d
story.append(chart())
story.append(p('Lettura: Goldbot One e Gold Reaper stanno sopra 1 ovunque (1,51-2,89). Prop Firm Gold EA e\' sopra 1,2 solo nei rialzi 2024 e 2025-26, e sotto 1 nel ribasso.',P))
story.append(PageBreak())

# ----- pagina 3: tabella completa
story.append(p('Risultati per EA e per periodo',H1))
story.append(p('Conto virtuale 80.000 &euro;. "DD" = perdita massima dal picco di equity, in % degli 80.000 iniziali (piu\' severo della % dal picco). Netto in &euro;. Modello: Goldbot One e tutti i periodi fino al 2024 con dati a 1 minuto (OHLC); Gold Reaper e Prop Firm nel 2025-26 con tick reali.',SUB))
def block(nome,S,extra=''):
    rows=[[nome,'Operazioni','Netto (&euro;)','PF','DD']]
    for i,w in enumerate(WIN):
        rows.append(['%s %s'%(w[0],w[1].lower()),S[i][0],S[i][1],fc(S[i][2]),S[i][3]])
    return tbl(rows,[62*mm,26*mm,30*mm,22*mm,22*mm])
story.append(block('Goldbot One (step 3000)',GB)); story.append(Spacer(1,6))
story.append(block('The Gold Reaper',GR)); story.append(Spacer(1,6))
story.append(block('Prop Firm Gold EA',PF)); story.append(Spacer(1,6))
story.append(p('Oltre i numeri: lati e lotti',H2))
story.append(bul('<b>Nel ribasso 2013-14 Goldbot One guadagna di piu\' dagli short</b> (+11.068 dagli short contro +8.458 dai long), nel laterale 2018-19 pure (+7.170 contro +3.500). Nel 2025-26 invece l\'82% del profitto veniva dai long: e\' un EA che si adatta alla direzione.'))
story.append(bul('<b>Prop Firm Gold EA</b> nel ribasso ha perso 18.732 &euro; dai long e guadagnato 14.435 dagli short: i long pesano troppo.'))
story.append(bul('<b>Gold Reaper</b> usa molte posizioni insieme (fino a 17 contemporanee e lotti molto diversi fra loro, rapporto massimo/minimo 4,5-7,4): non passa il nostro controllo "niente scalata dei lotti", Goldbot One si (rapporto 2,1-3,0).'))
story.append(PageBreak())

# ----- pagina 4: correlazione e portafoglio
story.append(p('Si diversificano? Correlazione e perdita combinata',H1))
story.append(p('Correlazione giornaliera dei risultati realizzati: 0 = indipendenti, 1 = si muovono insieme. Soglia che ci siamo dati: 0,5.',SUB))
cr=[['Periodo','Goldbot One - Gold Reaper','Goldbot One - Prop Firm','Gold Reaper - Prop Firm']]
for i,w in enumerate(WIN): cr.append([w[0]+' '+w[1].lower(),fc(CORR_GBGR[i]),fc(CORR_GBPF[i]),fc(CORR_GRPF[i])])
addt(tbl(cr,[52*mm,40*mm,40*mm,40*mm]))
story.append(p('Goldbot One e Gold Reaper stanno sotto 0,5 solo nei due laterali (0,41 e 0,44), sopra 0,5 nei rialzi e piu\' alti nel ribasso (0,63). Con Prop Firm la correlazione e\' bassa, ma Prop Firm non regge i mercati non rialzisti.',P))
story.append(p('Perdita massima combinata (somma dei risultati realizzati, % di 80.000)',H2))
story.append(p('Tetto che ci siamo dati: 10% del conto. Se piu\' EA girano sullo stesso conto, la perdita massima insieme conta piu\' di quella di ognuno.',PS))
pr=[['Periodo','Goldbot One (step 3000) + Gold Reaper','Goldbot One (step 6000) + Gold Reaper','Gold Reaper + Prop Firm']]
for i,w in enumerate(WIN): pr.append([w[0]+' '+w[1].lower(),PORT_GBGR[i],PORT_GBGR6[i],PORT_GRPF[i]])
addt(tbl(pr,[52*mm,48*mm,48*mm,34*mm]))
story.append(p('Goldbot One + Gold Reaper resta sotto il 10% in tutti e sei i periodi. Qualunque coppia con Prop Firm lo supera quasi sempre (9,3%-18,6%).',P))
story.append(p('Come leggere le due varianti di Goldbot One',H2))
story.append(p('Lo "step" decide la dimensione dei lotti: con step 3000 la perdita massima e\' circa il doppio che con step 6000, e anche il guadagno. Nel 2025-26 lo step 3000 ha fatto +25.157 con DD 9,1% degli 80.000; lo step 6000 +11.173 con DD 4,0%. Quale usare e\' una scelta di rischio personale, non fatta qui.',P))
story.append(PageBreak())

# ----- pagina 5: limiti, metodo, uso con Claude
story.append(p('Metodo, limiti e come usare questo PDF',H1))
story.append(p('Come sono stati fatti i test',H2))
story.append(bul('Simulatore di MetaTrader 5 (Strategy Tester), conto virtuale 80.000 &euro;, leva 1:100, stessi input per ogni EA in tutti i periodi. Nessun parametro e\' stato cambiato dopo aver visto i risultati.'))
story.append(bul('Finestre scelte dal prezzo con regola scritta in anticipo; criteri e previsioni scritti prima dei numeri. Per ogni risultato sono state confrontate le previsioni: la maggior parte confermata, alcune smentite (per esempio Goldbot One nel ribasso e\' andato meglio del previsto).'))
story.append(p('Limiti da non dimenticare',H2))
story.append(bul('<b>Un anno per regime</b>: tre o quattro campioni non fanno una statistica solida.'))
story.append(bul('<b>Spread storico</b>: nelle barre del 2022-23 e del 2024 lo spread registrato e\' circa zero o molto basso; se il simulatore lo usa, i costi in quei periodi sono troppo bassi. Il controllo con periodi a spread realistico (2018-19, 2019-20) ha dato conclusioni uguali, ma non e\' provato che il simulatore usi lo spread delle barre.'))
story.append(bul('<b>Ribasso vecchio</b>: dopo il 2014 l\'oro non ha avuto nessun periodo di 12 mesi in calo del 15% o piu\'; quello usato e\' del 2013-14, con prezzo 1.300-1.600 contro oltre 4.000 oggi.'))
story.append(bul('<b>Prodotti a scatola nera</b>: non conosciamo il periodo su cui il venditore li ha ottimizzati; se include questi periodi, la prova non e\' fuori campione.'))
story.append(bul('<b>Non misurati</b>: slippage reale, latenza, margine reale del broker, regole prop firm, filtro notizie (nel simulatore usa orari diversi da quelli del broker).'))
story.append(p('Glossario veloce',H2))
addt(tbl([['Termine','Significato'],
 ['EA','Expert advisor: programma che fa trading in automatico.'],
 ['PF (profit factor)','Guadagno lordo / perdita lorda. Sopra 1 guadagna, sotto 1 perde.'],
 ['DD (drawdown)','Perdita massima dal punto piu\' alto del conto al punto piu\' basso successivo.'],
 ['Rialzo / laterale / ribasso','Regime del prezzo dell\'oro nei 12 mesi della finestra, definito con soglie scritte in anticipo.'],
 ['Spread','Differenza fra prezzo di acquisto e di vendita: e\' un costo a ogni operazione.'],
 ['OHLC a 1 minuto / tick reali','Livello di dettaglio dei dati nella simulazione: i tick reali sono piu\' precisi, ma esistono solo dal 2024 per questo broker.'],
 ['Correlazione','Quanto due strategie guadagnano e perdono negli stessi giorni.']],[40*mm,134*mm]))
story.append(p('Se vuoi analizzarlo con Claude (o un altro assistente AI)',H2))
story.append(p('Questo PDF e\' scritto per essere letto da una persona o caricato in una chat con un assistente AI. Suggerimento di domanda da incollare insieme al file:',P))
q=Table([[Paragraph('<i>"Leggi questo riepilogo di backtest di tre expert advisor sull\'oro. Spiegami in parole semplici: (1) quale dei tre sembra meno dipendente dal fatto che l\'oro salga; (2) quali sono i punti deboli della prova; (3) quali dati ti servirebbero per fidarti di piu\'; (4) quali rischi non sono misurati. Non darmi consigli di acquisto o di importi da investire: voglio capire il metodo."</i>',CELL)]],colWidths=[174*mm])
q.setStyle(TableStyle([('BACKGROUND',(0,0),(-1,-1),BAND),('BOX',(0,0),(-1,-1),0.5,GRID),('LEFTPADDING',(0,0),(-1,-1),8),('RIGHTPADDING',(0,0),(-1,-1),8),('TOPPADDING',(0,0),(-1,-1),6),('BOTTOMPADDING',(0,0),(-1,-1),6)]))
story.append(q)
story.append(p('Fonte dei numeri: report di simulazione archiviati dal progetto (tabelle per periodo, correlazioni e perdita combinata calcolate dai risultati giornalieri realizzati). Tutte le cifre sono simulate su conto virtuale.',PS))
doc=SimpleDocTemplate('/tmp/claude-0/-home-user-GITHUB/c2d73886-9ef2-5105-8937-d770bc36d6df/scratchpad/pdf_out/Riepilogo_tre_EA_oro_sei_regimi_2026-10-21.pdf',pagesize=A4,leftMargin=18*mm,rightMargin=18*mm,topMargin=16*mm,bottomMargin=16*mm,title='Tre expert advisor sull\'oro in sei mercati diversi',author='Preparato con Claude',subject='Riepilogo backtest XAUUSD')
doc.build(story,onFirstPage=footer,onLaterPages=footer)
print('ok')
