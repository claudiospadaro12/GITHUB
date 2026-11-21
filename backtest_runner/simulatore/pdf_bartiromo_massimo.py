from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib import colors
from reportlab.lib.units import mm
from reportlab.platypus import SimpleDocTemplate,Paragraph,Spacer,Table,TableStyle,PageBreak
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
pdfmetrics.registerFont(TTFont('DV','/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf'))
pdfmetrics.registerFont(TTFont('DVB','/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf'))
B=ParagraphStyle('b',fontName='DV',fontSize=9.2,leading=13,spaceAfter=4)
H1=ParagraphStyle('h1',fontName='DVB',fontSize=16,leading=20,spaceAfter=6)
H2=ParagraphStyle('h2',fontName='DVB',fontSize=11.5,leading=15,spaceBefore=8,spaceAfter=4,textColor=colors.HexColor('#1a3a5c'))
S=ParagraphStyle('s',fontName='DV',fontSize=8,leading=11,textColor=colors.HexColor('#444444'))
T=ParagraphStyle('t',fontName='DV',fontSize=8,leading=10.5)
TB=ParagraphStyle('tb',fontName='DVB',fontSize=8,leading=10.5)
def p(x,st=B): return Paragraph(x,st)
def tab(rows,w,head=True):
    data=[[p(str(c),TB if (head and i==0) else T) for c in r] for i,r in enumerate(rows)]
    t=Table(data,colWidths=[x*mm for x in w],repeatRows=1)
    t.setStyle(TableStyle([('GRID',(0,0),(-1,-1),0.4,colors.HexColor('#999999')),('BACKGROUND',(0,0),(-1,0),colors.HexColor('#e3ecf5')),('VALIGN',(0,0),(-1,-1),'TOP'),('LEFTPADDING',(0,0),(-1,-1),3),('RIGHTPADDING',(0,0),(-1,-1),3)]))
    return t
st=[]
st+= [p('Francesco Bartiromo: cosa abbiamo scoperto e testato',H1),
 p('Relazione per Massimo, 21/11/2026. Materiale: trascrizioni dei video YouTube del canale (sottotitoli automatici, possibili errori) e test su dati di mercato. Tutti i test sono stati scritti (criteri e previsioni) prima di vedere i numeri.',S),Spacer(1,4),
 p('In sintesi',H2),
 p('<b>1.</b> Il canale ha 197 video (12/2021 - 11/2026). Gli ultimi due anni sono quasi tutti sull\'oro (XAUUSD) con un metodo di liquidità, price action e multi-timeframe (SMC/ICT in versione sua).<br/>'
   '<b>2.</b> Ha pochissime regole <b>meccaniche</b>. Ne abbiamo estratte due che si possono scrivere come regola: l\'Asian range (00:00-08:00) e la conferma H1 alle 14-16. Il resto (quale massimo/minimo è un "punto liquido", la zona di ingresso nel timeframe basso, il target) è discrezionale per sua stessa ammissione.<br/>'
   '<b>3.</b> Tradotte in regole a macchina e provate sull\'oro dal 2004 al 2026 (circa 2.000-4.000 operazioni per regola): <b>nessuna delle 8 varianti ha un vantaggio</b>; profit factor in campione 0,74-0,88, fuori campione 0,79-0,99.<br/>'
   '<b>4.</b> I suoi "backtest" sono replay manuali di 6-20 operazioni con il target scelto a occhio: campioni troppo piccoli per dire qualcosa. Questo non prova che lui non guadagni, prova che le sue regole scritte non danno un vantaggio meccanico.')]
st+= [p('1. Cosa insegna e cosa abbiamo letto',H2),
 tab([['Video','Contenuto','Esito'],
  ['NsYH (100 mattine, Asian range)','Classifica l\'asiatico in 3 casi: direzionale (55), sweep singolo (34), sweep doppio (11). Dice "55% di win rate" se entri alle 3 di notte nella direzione giusta.','La direzione "giusta" si sceglie col senno di poi (circolare). Classificazione soggettiva.'],
  ['yDB8 ("90% oggettiva")','Conferma su H1 chiusa alle 14, 15 o 16: candela engulfing o doji su un massimo/minimo; stop a -0,27/-0,30 Fibonacci; target "a occhio"; niente break even. Campione: 10 trade, 6 target, 3 stop, 1 unfilled, RR 3,8-4,3.','Solo candela, stop e orario sono oggettivi. Il livello e il target no.'],
  ['MWZ3 e qouD (liquidità)','Il "punto liquido": massimo/minimo di un movimento impulso-ritracciamento, che raggruppa i massimi sotto, con inefficienza vicina e non ancora preso. Se preso: price action opposta; se no: "liquidità nemica".','Nessuna soglia numerica. Lo definisce "la parte più complicata" e rimanda a un percorso one-to-one a pagamento.'],
  ['Altri (wWgg, XkIX, MDF9, ndEr)','Replay manuali con rischio 1-2%: 10 trade 60%, 6 trade 83%, circa 20 trade 70%.','Campioni minuscoli, target scelto a posteriori.']],[38,80,62]),
 Spacer(1,3),p('Altri video non letti per intero (corso di 3 ore e altri sull\'oro): non danno regole diverse dalle precedenti secondo i titoli e gli estratti letti.',S)]
st+= [p('2. Le due regole come le abbiamo scritte',H2),
 p('<b>Dati:</b> oro FTMO a 1 minuto dal 2004 al 18/11/2026, orario = ora italiana (server FTMO meno 1 ora), costo 0,35 $ a operazione, un trade al giorno, stop prima del target se nella stessa barra. In campione = primo 70% dei giorni (fino al 09/03/2020), fuori campione = ultimo 30%.<br/>'
   '<b>Regola 1, Asian range:</b> range 00:00-07:59; dalle 8 alle 12 si guarda la prima barra M5 che esce dal range. Se esce e chiude dentro (sweep) si entra in senso opposto con stop sull\'estremo; se chiude fuori (breakout) si entra nella direzione con stop a metà range. Target 1R, 2R o lato opposto del range. Uscita forzata alle 17:30.<br/>'
   '<b>Regola 2, conferma H1:</b> livelli oggettivi (massimo/minimo del giorno prima, asiatico, Londra); la candela H1 che inizia alle 13, 14 o 15 supera un livello e chiude dalla parte opposta, ed è engulfing o doji. Doji: entra alla chiusura; engulfing: limite al 25% del range verso il ritracciamento. Stop a 0,27 x range oltre l\'estremo. Target 1R, 1,5R, 2R. Uscita forzata alle 20:00.<br/>'
   '<b>Sostituzioni nostre (non sue):</b> i livelli oggettivi, il 25% di ritracciamento e i target fissi. Sono le parti che nel video sono a occhio.')]
st+= [p('3. Risultati (oro 2004-2026)',H2),
 tab([['Regola e variante','Operazioni (IS+OOS)','PF in campione','PF fuori campione','Anni con R >= 0'],
  ['Asian sweep, target 1R','1.898','0,74','0,79','2 su 20'],
  ['Asian sweep, target 2R','1.898','0,83','0,84','5 su 20'],
  ['Asian sweep, target lato opposto','1.898','0,79','0,82','3 su 20'],
  ['Asian breakout, 1R','2.098','0,85','0,99','6 su 23'],
  ['Asian breakout, 2R','2.098','0,88','0,91','6 su 23'],
  ['Conferma H1 14-16, 1R','1.957','0,79','0,88','3 su 21'],
  ['Conferma H1 14-16, 1,5R','1.957','0,82','0,90','3 su 21'],
  ['Conferma H1 14-16, 2R','1.957','0,80','0,95','5 su 21']],[58,30,30,32,30]),
 Spacer(1,3),
 p('<b>Win rate al target 1R: 49%</b> (lui dichiara 60-83% su 6-20 trade manuali). Con la conferma H1: doji PF 0,81 in campione e 0,98 fuori; engulfing 0,75 e 0,63. Il lato long dello sweep è il peggiore (PF 0,65-0,70 in campione). Soglia per un candidato: PF in campione 1,3 o più e fuori campione sopra 1,2. <b>Nessuna cella supera nemmeno PF 1,0 in campione.</b> Tutte le previsioni scritte prima (nessun candidato 90%) sono risultate corrette.',B)]
st+= [p('4. Limiti da dichiarare',H2),
 p('• È la <b>nostra versione a macchina</b> delle sue regole: il take profit "a occhio" e la scelta della zona non sono testati.<br/>'
   '• L\'orario è il server FTMO meno un\'ora, senza correzione per le settimane in cui USA ed Europa hanno ora diversa. Costo fisso 0,35 $.<br/>'
   '• I sottotitoli YouTube possono avere errori; non abbiamo gli screenshot dei suoi grafici né lo "schemino" citato nei video.<br/>'
   '• Un EA fedele non è realizzabile: ogni versione sarebbe una interpretazione nostra.')]
st+= [p('5. Conclusione e domande',H2),
 p('<b>Conclusione:</b> dal canale di Bartiromo non esce nessun candidato EA. Le sue regole scritte (Asian range e conferma H1) non hanno vantaggio meccanico sull\'oro 2004-2026; il suo metodo reale dipende da una lettura discrezionale della liquidità che non è codificabile.<br/>'
   '<b>Domande per Massimo:</b><br/>'
   '1. Hai accesso a materiale (corso, schemi, definizioni scritte) in cui il "punto liquido" è definito con soglie numeriche? Senza, non possiamo testarlo fedelmente.<br/>'
   '2. L\'orario dei suoi grafici è l\'ora italiana (i video suggeriscono di sì, ma non lo dice)?<br/>'
   '3. Vuoi che proviamo una versione nostra del "punto liquido" (per esempio massimo H4 raggruppato con un\'inefficienza vicina non ancora toccata), dichiarata come nostra? Aspettativa di successo bassa.')]
SimpleDocTemplate('/home/user/GITHUB/report/BARTIROMO_PER_MASSIMO_2026-11-21.pdf',pagesize=A4,leftMargin=15*mm,rightMargin=15*mm,topMargin=14*mm,bottomMargin=14*mm,title='Bartiromo: scoperto e testato',author='ABTG').build(st)
