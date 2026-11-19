#!/usr/bin/env python3
"""Fogli riassuntivi dei fotogrammi di un video (uno ogni STEP secondi, nome f_00001.jpg...).
Uso: python3 -I fogli_fotogrammi.py <cartella o zip dei fotogrammi> <cartella di uscita> [step_secondi=20] [colonne=5] [righe=4] [larghezza_tile=384]
Produce foglio_001.jpg, foglio_002.jpg... con l'orario (h:mm:ss) scritto su ogni riquadro."""
import sys,os,glob,zipfile,tempfile,re
from PIL import Image,ImageDraw,ImageFont
src,out=sys.argv[1],sys.argv[2]
step=int(sys.argv[3]) if len(sys.argv)>3 else 20
cols=int(sys.argv[4]) if len(sys.argv)>4 else 5
rows=int(sys.argv[5]) if len(sys.argv)>5 else 4
tw=int(sys.argv[6]) if len(sys.argv)>6 else 384
os.makedirs(out,exist_ok=True)
if src.lower().endswith('.zip'):
    d=tempfile.mkdtemp(); zipfile.ZipFile(src).extractall(d); src=d
files=sorted(glob.glob(os.path.join(src,'**','f_*.jpg'),recursive=True))
def ora(n):
    s=(n-1)*step; return '%d:%02d:%02d'%(s//3600,(s%3600)//60,s%60)
try: font=ImageFont.truetype('DejaVuSans-Bold.ttf',20)
except Exception: font=ImageFont.load_default()
per=cols*rows; nfogli=0
for i in range(0,len(files),per):
    blocco=files[i:i+per]; tiles=[]
    for j,f in enumerate(blocco):
        n=int(re.search(r'f_(\d+)',os.path.basename(f)).group(1))
        im=Image.open(f).convert('RGB'); h=int(im.height*tw/im.width); im=im.resize((tw,h))
        dr=ImageDraw.Draw(im); t=ora(n); dr.rectangle([0,0,10+11*len(t),26],fill=(0,0,0)); dr.text((4,2),t,fill=(255,255,0),font=font); tiles.append(im)
    th=max(t.height for t in tiles); W=cols*tw; H=((len(tiles)+cols-1)//cols)*th
    sheet=Image.new('RGB',(W,H),(30,30,30))
    for j,t in enumerate(tiles): sheet.paste(t,((j%cols)*tw,(j//cols)*th))
    nfogli+=1; sheet.save(os.path.join(out,'foglio_%03d.jpg'%nfogli),quality=80)
print('fotogrammi',len(files),'fogli',nfogli,'cartella',out)
