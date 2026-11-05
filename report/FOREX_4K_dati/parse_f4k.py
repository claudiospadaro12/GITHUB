import re,glob,json,os,sys
rows={}
for ref in glob.glob('forex4k/z*/*/*/*/REFERTO_ANNO80K_TRANCHE.txt'):
    parts=ref.split('/')
    folder=parts[3]  # e.g. APEX_ApexConservativeGrid_2020
    t=open(ref,encoding='utf-8',errors='replace').read()
    m=re.search(r'operazioni (\d+)\s+netto (-?[\d.]+)\s+PF ([\d.]+|inf|-)\s+DD equita ([\d.]+)\(([\d.]+)%\)\s+DD saldo ([\d.]+)\(([\d.]+)%\)',t)
    fb=re.search(r'final balance (-?[\d.]+)',t)
    so=re.search(r'righe stop out nei giornali (\d+), no money (\d+)',t)
    st=re.search(r'STATO (\w+)',t)
    dep=re.search(r'deposito (\d+) EUR',t)
    ini=re.search(r'input imposti confermati dal report: (\w+)',t)
    ex=re.search(r'EX5: (\S+)',t)
    r=dict(folder=folder,ea=ex.group(1) if ex else '?',stato=st and st.group(1),dep=dep and int(dep.group(1)),
      ops=m and int(m.group(1)),net=m and float(m.group(2)),pf=m and m.group(3),ddE=m and float(m.group(4)),ddEp=m and float(m.group(5)),
      ddS=m and float(m.group(6)),ddSp=m and float(m.group(7)),final=fb and float(fb.group(1)),stopout=so and int(so.group(1)),nomoney=so and int(so.group(2)),
      setconf=ini and ini.group(1))
    # qualita
    q=re.search(r'qualita (\d+)%',t); r['q']=q and int(q.group(1))
    rows[folder]=r
json.dump(rows,open('forex4k_res.json','w'),indent=1)
print(len(rows))
for k in sorted(rows):
    r=rows[k]
    print(f"{k:50s} {r['ea'][:30]:30s} {r['stato']} dep{r['dep']} ops{r['ops']} net{r['net']} PF{r['pf']} DDe {r['ddEp']}% ({r['ddE']}) fin{r['final']} SO{r['stopout']} NM{r['nomoney']} set:{r['setconf']} q{r['q']}")
