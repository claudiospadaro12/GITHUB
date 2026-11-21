from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib import colors
from reportlab.lib.units import mm
from reportlab.platypus import SimpleDocTemplate,Paragraph,Spacer,Table,TableStyle
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
pdfmetrics.registerFont(TTFont('DV','/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf')); pdfmetrics.registerFont(TTFont('DVB','/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf'))
B=ParagraphStyle('b',fontName='DV',fontSize=9,leading=12.5,spaceAfter=3)
H1=ParagraphStyle('h1',fontName='DVB',fontSize=15,leading=19,spaceAfter=4)
H2=ParagraphStyle('h2',fontName='DVB',fontSize=11,leading=14,spaceBefore=7,spaceAfter=3,textColor=colors.HexColor('#1a3a5c'))
T=ParagraphStyle('t',fontName='DV',fontSize=7.8,leading=10); TB=ParagraphStyle('tb',fontName='DVB',fontSize=7.8,leading=10)
def p(x,s=B): return Paragraph(x,s)
def tab(rows,w):
    data=[[p(str(c),TB if i==0 else T) for c in r] for i,r in enumerate(rows)]
    t=Table(data,colWidths=[x*mm for x in w],repeatRows=1)
    t.setStyle(TableStyle([('GRID',(0,0),(-1,-1),0.4,colors.HexColor('#999999')),('BACKGROUND',(0,0),(-1,0),colors.HexColor('#e3ecf5')),('VALIGN',(0,0),(-1,-1),'TOP'),('LEFTPADDING',(0,0),(-1,-1),3),('RIGHTPADDING',(0,0),(-1,-1),3)])); return t
st=[p('Riepilogo della giornata, sabato 21/11/2026',H1),
 p('Tutti i test hanno criteri e previsioni scritti prima dei numeri, soglie mai allentate. Solo tester e dati: VPS e conto reale non toccati. Ramo: claude/verifica-siti-caccia-strategie-v5pzqv (31 commit del giorno, tutto inviato).',ParagraphStyle('s',parent=B,fontSize=8,textColor=colors.HexColor('#555555'))),
 p('In una riga',H2),
 p('<b>Nessun nuovo candidato EA trovato oggi.</b> Quello che regge resta il trend D1 long-only (oro, Bitcoin, Ethereum, argento): lo stesso motore di GoldenZoe. Tutte le altre famiglie provate sono chiuse.'),
 p('Test chiusi oggi',H2),
 tab([['Cosa','Risultato','Esito'],
 ['Bartiromo: Asian range e conferma H1 (8 varianti, oro 2004-2026)','PF in campione 0,74-0,88, fuori 0,79-0,99; win rate al 1R 49% (lui 60-83% su 6-20 trade manuali). Il "punto liquido" e il target sono discrezionali per sua ammissione.','Nessun candidato. PDF per Massimo inviato'],
 ['Supporti/resistenze LuxAlgo sull\'oro H1 2021-26','PF 0,82 (target) / 0,70 (uscita mobile); nel periodo degli screenshot PF 0,83','Non candidata: il "vince visivamente" e\' selezione dei tratti'],
 ['Famiglie A-D sui 33 mercati D1 (overnight, calendario, RSI(2), momentum)','A 0 celle; B 0 su 197; C solo Dow e Nasdaq (2 su 11, serve 3 per classe); D lordo 0%/mese','0 candidati'],
 ['RSI(2) long con M1 reali Nasdaq/S&P 2016-2026','PF 1,18 e 1,17 (soglia 1,2); P2 su 4 indici passa (t episodi 3,0)','Chiusa, per 0,02-0,03'],
 ['Filtri di regime sul trend D1 (mom250 isteresi, volatilita\')','F1 e F2: 0 mercati su 5; F3: 2 su 5 (oro, Bitcoin), serviva 3','Nessun filtro adottato'],
 ['Donchian 20/55 D1 su 17 mercati (fase 1 di GoldenZoe)','0 celle su 34; anche l\'oro: PF IS 1,51 ma t 1,1','Nessun mercato da portare al tester FTMO'],
 ['Supertrend (10 / 3,0) su tutti i simboli e TF (150 valutazioni)','1 cella (Bitcoin D1 long, isolata); gli short perdono ovunque','Nessun candidato'],
 ['Supertrend oro long: deriva, varianti, uscite','H4 PF 1,38 / 1,50 / 2,58 (t 1,7); batte gli ingressi casuali su H1 (p 0,03), H4 sul filo (0,057). Uscite HA/inclinazione/volume: tutte peggiori del cambio Supertrend (12 su 12)','Vantaggio debole, non confermato'],
 ['Correlazione Supertrend long con trend D1','H4 - Donchian D1: 0,44 giornaliera, 0,58 mensile; con oro fermo 0,69 / 0,75','"Diversifica poco": e\' esposizione all\'oro']],[52,88,40]),
 p('Altri lavori',H2),
 p('<b>Copertura FTMO (21 simboli, esportata):</b> storico M1 da 2008 (argento), 2011 (BTC), 2016 (ETH), dicembre 2017 (indici maggiori), 2019 (Dow, Australia). Indici solo 8-9 anni: troppo pochi per il cancello. Esclusi palladio e platino (spread 0,78% e 0,42%); rame, gas, DXY (storico dal 2024). Swap di BTC/ETH (-30 "interesse annuo") e del Dow (+265 punti) da verificare in demo. Commissioni non misurate.<br/>'
   '<b>Report settimanale (weekly_report_3):</b> il conto reale veniva letto con le colonne spostate: 161 trade del 19/10 contati come settimana, trattino nelle date, titolo +14.043 € fuorviante. Il bias "37%" con forex 0/5 era una misura sbagliata (dalle chiusure degli snapshot: 49/72 = 68%). Due patch pronte, <b>non applicate al ramo lavoro</b>. Reale del 19/10: -502,69 € in 161 trade in un giorno, lotti 0,01-0,17 (inferenza: oro).<br/>'
   '<b>Ricerca web (6 ricerche):</b> poche idee nuove; evidenza negativa sul trend nel forex dopo i costi (QuantInsti) e sul turn-of-month.'),
 p('Correzioni mie di oggi',H2),
 p('1) I dati dell\'oro 2021-26 erano gia\' sul server dal 19/11: l\'export ripetuto non serviva. 2) Il test S/R "2004-2020" girava in realta\' su 2004-2026. 3) Il riepilogo "Supertrend nessun vantaggio" era troppo netto sull\'oro long: corretto nel report.'),
 p('Aperto / prossimi passi',H2),
 p('• <b>GoldenZoe su piu\' mercati:</b> nessun mercato testabile dal D1; resta l\'oro (e forse argento, BTC, ETH con storico lungo).<br/>'
   '• Applicare le due patch (parser del reale, bias) al runner del ramo lavoro; esportare di nuovo lo storico di reale, challenge FTMO e 100k.<br/>'
   '• Misurare la correlazione del Supertrend/trend D1 con gli EA oro della flotta (Reaper, Phantom, Goldbot).<br/>'
   '• Ancora in sospeso: test Luna orario (mai partito), mail a FTMO (decide Claudio), Setting_canali_PTE.pdf, statement del reale dopo il 19/10.<br/>'
   '• Limiti di rete della sessione: Yahoo, algotr.substack.com e alphaarchitect.com non raggiungibili.')]
SimpleDocTemplate('/home/user/GITHUB/report/RIEPILOGO_GIORNATA_2026-11-21.pdf',pagesize=A4,leftMargin=15*mm,rightMargin=15*mm,topMargin=13*mm,bottomMargin=13*mm,title='Riepilogo della giornata 21/11/2026').build(st)
