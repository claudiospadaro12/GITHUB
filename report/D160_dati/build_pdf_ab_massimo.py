#!/usr/bin/env python3
from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.lib.units import mm
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, KeepTogether
from reportlab.graphics.shapes import Drawing, Rect, String, Line
OUT='/home/user/GITHUB/report/SCHEMA_A_B_GOLD_BUNDLE_PER_MASSIMO_2026-11-13.pdf'
ss=getSampleStyleSheet()
B=ParagraphStyle('B',parent=ss['Normal'],fontName='Helvetica',fontSize=9.5,leading=13)
S=ParagraphStyle('S',parent=B,fontSize=8.3,leading=11,textColor=colors.HexColor('#444444'))
H1=ParagraphStyle('H1',parent=ss['Title'],fontName='Helvetica-Bold',fontSize=17,leading=21,alignment=0,spaceAfter=2)
H2=ParagraphStyle('H2',parent=B,fontName='Helvetica-Bold',fontSize=11.5,leading=15,spaceBefore=8,spaceAfter=3,textColor=colors.HexColor('#1f3a5f'))
BL=ParagraphStyle('BL',parent=B,leftIndent=10,bulletIndent=0)
def P(t,st=B): return Paragraph(t,st)
def tbl(data,widths,hdr=True,zebra=True,fs=8.8):
    t=Table([[Paragraph(str(c),ParagraphStyle('c',parent=B,fontSize=fs,leading=fs+2.5)) for c in r] for r in data],colWidths=widths)
    st=[('GRID',(0,0),(-1,-1),0.4,colors.HexColor('#b8c2cc')),('VALIGN',(0,0),(-1,-1),'TOP'),('TOPPADDING',(0,0),(-1,-1),3),('BOTTOMPADDING',(0,0),(-1,-1),3)]
    if hdr: st+= [('BACKGROUND',(0,0),(-1,0),colors.HexColor('#dfe8f2'))]
    t.setStyle(TableStyle(st)); return t
doc=SimpleDocTemplate(OUT,pagesize=A4,leftMargin=16*mm,rightMargin=16*mm,topMargin=14*mm,bottomMargin=14*mm,title='Schema A e B - Gold Bundle di Wim',author='Claudio Spadaro')
E=[]
E.append(P('Schema A e B: Gold Bundle di Wim per la sfida FTMO 2-Step',H1))
E.append(P('Per Massimo - 13/11/2026 - STIME DA BACKTEST (tester BCM, 80.000 EUR), non previsioni. Nessuna indicazione su lotti, taglie o acquisti.',S))
E.append(P('1. Le due combinazioni',H2))
E.append(tbl([
 ['','<b>A - la piu sicura</b>','<b>B - la piu veloce a rischio basso</b>'],
 ['EA','Goldbot One + Gold Phantom','Goldbot One + Gold Phantom'],
 ['Goldbot One','livello L1: <font face="Courier">Goldbot_PropFirm_10_5.set</font>','livello L1: <font face="Courier">Goldbot_PropFirm_10_5.set</font>'],
 ['Gold Phantom','livello L0 (Prop): <font face="Courier">GoldPhantom_Propfirm_combo.set</font>','livello L1: <font face="Courier">GoldPhantom_Propfirm.set</font>'],
 ['Non inclusi','Gold Reaper, Gold Trade Pro, Daytrade Pro','Gold Reaper, Gold Trade Pro, Daytrade Pro'],
],[30*mm,72*mm,72*mm]))
E.append(P('2. Risultati nel tester (con i costi FTMO ipotizzati)',H2))
E.append(tbl([
 ['','A','B'],
 ['Fase 1 (+10%): giorni di calendario, mediana (caso lento 25%)','117 (172)','104 (153)'],
 ['Fase 2 (+5%): giorni di calendario, mediana','70','43'],
 ['<b>Totale tipico per le due fasi</b>','<b>~187 giorni (circa 6 mesi)</b>','<b>~147 giorni (circa 5 mesi)</b>'],
 ['Fallimenti (-5% in un giorno o -10% totale)','<b>0%</b>, anche con costi doppi','<b>2,7%</b> (3,1% con costi doppi)'],
 ['Partenze che arrivano al target','96,9%','97,3%'],
 ['Netto medio annuo su 80.000 EUR (costi centrali)','22.737 EUR','27.624 EUR'],
 ['Giorni con perdita >= 4,5% in equity (4 anni testati)','4','5'],
],[84*mm,45*mm,45*mm]))
# grafico tempi
d=Drawing(174*mm,48*mm)
sc=(174*mm-30*mm)/200.0
def bar(y,f1,f2,label,c1,c2):
    d.add(String(0,y+3,label,fontName='Helvetica-Bold',fontSize=9))
    x0=22*mm
    d.add(Rect(x0,y,f1*sc,12,fillColor=c1,strokeColor=None)); d.add(String(x0+f1*sc/2-6,y+3,str(f1),fontName='Helvetica',fontSize=8,fillColor=colors.white))
    d.add(Rect(x0+f1*sc,y,f2*sc,12,fillColor=c2,strokeColor=None)); d.add(String(x0+f1*sc+f2*sc/2-6,y+3,str(f2),fontName='Helvetica',fontSize=8,fillColor=colors.white))
    d.add(String(x0+(f1+f2)*sc+4,y+3,'%d gg'%(f1+f2),fontName='Helvetica',fontSize=8.5))
bar(22,117,70,'A',colors.HexColor('#1f3a5f'),colors.HexColor('#6b8fb5'))
bar(4,104,43,'B',colors.HexColor('#1f3a5f'),colors.HexColor('#6b8fb5'))
d.add(Rect(22*mm,42,8,6,fillColor=colors.HexColor('#1f3a5f'),strokeColor=None)); d.add(String(22*mm+11,42,'fase 1 (+10%)',fontName='Helvetica',fontSize=7.5))
d.add(Rect(22*mm+70,42,8,6,fillColor=colors.HexColor('#6b8fb5'),strokeColor=None)); d.add(String(22*mm+81,42,'fase 2 (+5%)',fontName='Helvetica',fontSize=7.5))
E.append(Spacer(1,4)); E.append(d)
E.append(P('3. Come sono stati calcolati',H2))
for t in [
 'Tester BCM, Modello 1 (barre da 1 minuto), anni 2013, 2018, 2020 e 2025, un percorso per anno; il Phantom ha un po\' di rumore proprio.',
 'Si parte da ogni giorno di gennaio-marzo di ogni anno. Fallisce se in un giorno l\'equity scende del 5% o se il totale scende del 10%; passa a +10% (fase 1) o +5% (fase 2). Giorni di calendario, non giorni di borsa.',
 'Tutte le 249 combinazioni possibili del Gold Bundle sono state provate (Goldbot, Phantom, Reaper a 4 livelli o spenti, piu Gold Trade Pro Combo). Criterio di scelta, fissato prima: fallimenti 0-3% anche con costi doppi, passaggio almeno 90%, poi il tempo totale piu corto.',
 'Il Gold Reaper non compare in nessuna combinazione con fallimenti a zero: le migliori che lo contengono fanno 3-10% di fallimenti.']:
    E.append(P(t,BL).__class__(t,BL,bulletText='-'))
E.append(P('4. Costi FTMO: cosa e reale e cosa e ipotesi',H2))
E.append(tbl([
 ['Commissione oro','0,0014% del nozionale (pagina Simboli FTMO); sul trial misurati 4,9-5,1 EUR a lotto','Reale'],
 ['Swap','Punti della scheda FTMO (oro: long -92,26, short -4,2); sul trial 32 EUR a lotto, quasi tutto swap','Reale dalla scheda; giorno del triplo swap non verificato'],
 ['Spread oro','FTMO non lo dichiara. Stime di terzi: 0,15-0,30 $ per oncia. Lo storico BCM usato dal tester ha mediana 0,22 $','<b>NON misurato</b>'],
 ['Slippage','Sul trial: mediana -0,05 $ per oncia sugli stop (23 stop), peggiore -0,32 $','Misurato, campione piccolo'],
 ['Costi extra usati nei calcoli','36 EUR a lotto oro (centrali) e il doppio (prudenti), oltre ai costi gia nel tester','Ipotesi mia, probabilmente prudente'],
],[34*mm,102*mm,38*mm],hdr=False))
E.append(P('Con costi doppi i tempi salgono del 15-30%; con costi dimezzati scendono di poco. L\'ordine di grandezza (5-6 mesi) non cambia.',S))
E.append(P('5. Cosa NON e verificato',H2))
for t in [
 '<b>Tester, non conto reale</b>: spread e slippage di FTMO, ordini rifiutati per margine e stop out non sono simulati.',
 '<b>Swing a leva 1:15 sull\'oro</b>: il margine arriverebbe a circa 50-59% del saldo; la risposta di FTMO su livello di stop out, posizioni opposte fra conti e news NON e ancora arrivata.',
 '<b>Giorni sopra il 4,5%</b>: A ne ha 4 e B 5 nei 4 anni testati (equity ricostruita dalle barre da 1 minuto). Il Guardian a 4,3% giornaliero e 9,5% totale va tenuto acceso.',
 '<b>Versioni dei set</b>: i nomi sono quelli dei test; va controllato file per file che siano le versioni correnti di Wim.',
 'Un solo percorso per anno, 4 anni: le percentuali di fallimento non sono garanzie.']:
    E.append(P(t,BL).__class__(t,BL,bulletText='-'))
E.append(P('Fonte: report/GOLD_BUNDLE_COMBINAZIONI_2026-11-13.md e TEMPI_SFIDA_CON_COSTI_2026-11-13.md. Documento non controllato da altri.',S))
doc.build(E)
print(OUT)
