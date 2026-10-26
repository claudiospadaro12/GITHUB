from reportlab.lib.pagesizes import A4
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib import colors
from reportlab.lib.units import mm
out='GOLD_REAPER_RISPOSTA_ALLA_PROPOSTA_DI_VERIFICA_2026-10-26.pdf'
ss=getSampleStyleSheet()
TT=ParagraphStyle('TT',parent=ss['Title'],fontSize=17,spaceAfter=4)
H1=ParagraphStyle('H1',parent=ss['Heading1'],fontSize=12.5,spaceBefore=10,spaceAfter=4,textColor=colors.HexColor('#1f3a64'))
B=ParagraphStyle('B',parent=ss['BodyText'],fontSize=9.2,leading=12.4,spaceAfter=3)
C=ParagraphStyle('C',parent=B,fontSize=8.3,leading=10.4,spaceAfter=0)
S=ParagraphStyle('S',parent=B,fontSize=8,leading=10,textColor=colors.HexColor('#444444'))
BX=ParagraphStyle('BX',parent=B,backColor=colors.HexColor('#fff6e0'),borderPadding=4,borderColor=colors.HexColor('#e0b050'),borderWidth=0.5,spaceBefore=4,spaceAfter=6)
def P(t,st=B): return Paragraph(t,st)
def T(rows,w):
    t=Table([[P(str(c),C) for c in r] for r in rows],colWidths=[x*mm for x in w],repeatRows=1)
    t.setStyle(TableStyle([('GRID',(0,0),(-1,-1),0.3,colors.grey),('VALIGN',(0,0),(-1,-1),'TOP'),('BACKGROUND',(0,0),(-1,0),colors.HexColor('#e8eef7')),('LEFTPADDING',(0,0),(-1,-1),3),('RIGHTPADDING',(0,0),(-1,-1),3),('TOPPADDING',(0,0),(-1,-1),2),('BOTTOMPADDING',(0,0),(-1,-1),2)])); return t
def foot(c,d):
    c.saveState(); c.setFont('Helvetica',7); c.setFillColor(colors.grey); c.drawString(15*mm,8*mm,'Risposta alla proposta di verifica - The Gold Reaper - 26/10/2026'); c.drawRightString(195*mm,8*mm,'pag. %d'%d.page); c.restoreState()
doc=SimpleDocTemplate(out,pagesize=A4,leftMargin=15*mm,rightMargin=15*mm,topMargin=14*mm,bottomMargin=14*mm,title='Risposta alla proposta di verifica del Gold Reaper',author='Claudio Spadaro')
E=[]
E.append(P('Risposta alla proposta di verifica del Gold Reaper',TT))
E.append(P('Preparata il 26/10/2026 in risposta ai cinque punti proposti dal controllo indipendente. Complemento del "Rapporto dettagliato dei test" gia inviato; le fonti dei numeri sono li.',S))
E.append(P('In breve',H1))
E.append(P('L\'impostazione proposta e giusta e coincide con quella che il progetto aveva gia in programma: il test che corrisponde alla regola FTMO e la <b>equity minima di ogni giorno confrontata con il saldo di mezzanotte CE(S)T</b>, non il solo realizzato. Finora abbiamo il realizzato (0 giorni con perdita >= 3% sui 21 mesi; nel 2013 un giorno a -4,6%), che e un limite inferiore. Per rispondere in modo definitivo servono tre cose che non sono ancora state fatte: l\'export delle barre M1 (21 mesi e 2013), il giro con le protezioni spente e la simulazione di uno stop esterno. Il venerdi sera l\'ho gia calcolato (tabella sotto).',B))
E.append(P('Risposta punto per punto',H1))
E.append(T([['Proposta','Stato oggi','Cosa serve / limiti'],
['1. Equity minima giornaliera con prezzi M1 contro il saldo di mezzanotte CE(S)T, sui 21 mesi e sul 2013','Script di export M1 e lettore dell\'equity gia scritti e provati su dati di prova; <b>non ancora lanciati</b> sul PC di backtest. Oggi esiste solo il realizzato.','Lanciare l\'export M1 (21 mesi) e farne un secondo per il 2013 (lo script e la riga vanno estesi: nome file e date). Il Reaper ha fino a 11 posizioni (23 nel 2013): il flottante si ricostruisce dalle barre, quindi e una <b>stima</b> (lettura centrale = chiusura barra; pessimistica = estremo della barra). Per il 2013 le operazioni sono a Modello 1.'],
['2. Posizioni aperte il venerdi sera e a ridosso di CPI e Fed','Venerdi: calcolato ora (sotto). CPI/Fed: da fare.','Servono le date dei CPI e delle riunioni FOMC 2025-2026 (le recupero io da fonti pubbliche o me le conferma Claudio); poi si contano le posizioni aperte nelle finestre prima e dopo l\'evento.'],
['3. Giro con le protezioni spente','Non fatto.','Una corsa continua di 21 mesi a 80.000 con MaxAllowedDD=0 e PropFirmMaxDailyDD=0, tutto il resto come il set di Claudio. Ore di tester; lo preparo come riga (script di tranche da copiare con i due input cambiati).'],
['4. Se i numeri reggono: affitto della licenza e forward su demo','Dopo i punti 1-3.','Affitto o acquisto e decisione di Claudio (non conosco le opzioni di affitto del Reaper). Il forward segue la regola di casa: almeno 4 settimane su demo prima di qualsiasi reale, un EA alla volta.'],
['5. EA di protezione esterno al 3% di equity','Da simulare prima di decidere.','Vedi la sezione dedicata sotto.']],[40,50,90]))
E.append(P('Venerdi sera: cosa risulta dai 21 mesi (set di Claudio, 80.000 EUR)',H1))
E.append(T([['Misura','Valore'],
['Venerdi con almeno una posizione aperta alle 21:00 (ora del server)','20 su 91'],
['Posizioni aperte insieme di venerdi sera, massimo','5 (1,19 lotti in tutto)'],
['Posizioni che attraversano il fine settimana (aperte il venerdi alle 21:00, chiuse dopo)','31'],
['Posizione tenuta piu a lungo','circa 19 giorni (luglio 2026), chiusa a -549 EUR (compare su tre venerdi di fila)'],
['I cinque venerdi peggiori per risultato finale delle posizioni aperte','17/01/2025: -882 (2 posizioni, 0,54 lotti); 03, 10 e 17/07/2026: -549 (la stessa posizione); 21/02/2025: -515 (2 posizioni)'],
['Somma dei risultati finali di quelle posizioni','+540 EUR (10 perdenti su 31)']],[110,70]))
E.append(P('Nota di metodo: le posizioni sono ricostruite dalla lista delle operazioni accoppiando ingressi e uscite per direzione (primo dentro, primo fuori): e approssimato. Il risultato finale non dice quanto fosse il flottante la sera del venerdi ne il gap di apertura del lunedi: per questo serve l\'equity da barre M1. Il set di Claudio ha FridayStopHour=25, cioe nessuno stop del venerdi (le posizioni restano aperte nel fine settimana); FridayCloseOpen=true e un altro input di default, ma con quell\'ora impossibile non agisce.',B))
E.append(P('Giorno storto e protezione esterna: cosa sappiamo gia',H1))
for t in ['<b>Nel 2013 il Reaper ha avuto un giorno a -4,6% (-3.697 EUR) del saldo, sopra il 4% della sua protezione interna</b> e a 0,4 punti dal 5% di FTMO. Le protezioni interne non sono quindi un tetto garantito (la protezione si basa su soglie che l\'EA controlla a intervalli e con UseEquity=false non e chiaro se misuri l\'equity).',
'<b>Le guardie dei venditori al 5% sugli EA Umbra e Microedge hanno trasformato il flottante in perdita realizzata</b>: i giorni a -5% sono saliti da 5 a 11 e da 3 a 12, e il netto sui 21 mesi e sceso del 41% e del 69%, perche quegli EA rientrano spesso dal flottante.',
'<b>Sul conto reale la stessa dinamica e gia stata vissuta con il Guardian</b> (chiusura del flottante che poi sarebbe rientrato): per questo uno stop esterno va provato prima, non adottato per principio.',
'Il Reaper e diverso dagli EA con vincite piccole e perdita rara: a 80.000 ha vincita media +155 e perdita media -157, 74,7% di operazioni vincenti, posizioni fino a 19 giorni: uno stop esterno al 3% potrebbe tagliare perdite ma anche posizioni che poi recuperano.']:
    E.append(P('- '+t,B))
E.append(P('Come si verifica uno stop esterno: sull\'equity giornaliera ricostruita dalle barre M1 si applica una regola ipotetica (chiudi tutto se la perdita del giorno raggiunge il 3% o il 4% del saldo di mezzanotte, nessuna nuova operazione fino alla mezzanotte successiva) e si confronta il netto, il numero di giorni salvati e quello dei giorni in cui il taglio ha chiuso una posizione che sarebbe rientrata. E una simulazione sulla stima dell\'equity, non una misura: la conferma vera richiede un forward con l\'EA di protezione reale.',B))
E.append(P('Cosa decidere PRIMA di guardare i numeri (proposta di criteri, da confermare)',H1))
E.append(T([['Test','Soglia proposta'],
['Equity minima giornaliera (21 mesi e 2013)','nessun giorno con perdita sull\'equity oltre il -4,0% del saldo di mezzanotte (margine di 1 punto sul 5% FTMO); si riporta anche quanti giorni stanno fra -3% e -4%'],
['Protezioni spente (21 mesi)','netto positivo, DD equity <= 8.000 EUR (10% di 80.000) e nessun giorno con perdita realizzata >= 5%'],
['Stop esterno simulato al 3% / 4%','si riporta il costo in netto e il numero di giorni evitati; non e una soglia di acquisto']],[60,120]))
E.append(P('Le soglie sono una proposta mia: Claudio le conferma o le cambia prima del lancio, poi non si toccano.',S))
E.append(P('Ordine di lavoro consigliato',H1))
E.append(T([['#','Passo','Chi','Tempo'],
['1','Aspettare la fine della riga forex in corso (il PC fa un giro alla volta)','Claudio','da definire (10-30 ore possibili)'],
['2','Export M1: 21 mesi + 2013 (riga da estendere), poi lancio','io preparo, Claudio lancia','pochi minuti a export'],
['3','Giro del Reaper con protezioni spente (21 mesi, 80.000)','io preparo, Claudio lancia','alcune ore'],
['4','Date CPI e FOMC 2025-2026; lettura delle posizioni nelle finestre','io','calcolo'],
['5','Equity minima giornaliera e simulazione dello stop esterno','io','calcolo, dopo i punti 2-3'],
['6','Documento di decisione con le soglie sopra; se reggono: affitto e forward su demo','Claudio decide','4 settimane di demo']],[8,92,42,38]))
E.append(P('Limiti',H1))
E.append(P('Tutti i numeri sono del tester (un solo percorso storico, oro quasi sempre al rialzo negli ultimi 21 mesi); l\'equity ricostruita e una stima per gli EA a piu posizioni; la slippage non e misurata; l\'EA e la versione demo del Market (la versione a pagamento potrebbe differire); l\'orologio dell\'EA (AutoGMT con offset 2/3 contro un server BCM UTC+1 fisso) non e verificato dal vivo. Nessuna indicazione di acquisto, lotto o taglia: sono decisioni di Claudio.',B))
doc.build(E,onFirstPage=foot,onLaterPages=foot)
print('ok')
