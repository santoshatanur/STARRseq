from scipy import stats as sp
from sys import argv

script, filepath = argv
pidn = "A"
ref = []
alt = []
refm = []
altm =[]
altmean = 0
refmean = 0
reflen =0
altlen =0
p=0
s=0
with open(filepath) as fp:
   for line in fp:
      ln = line.split("\t") 
      idn = ln[0]
      if idn != pidn:
           #s,p = sp.stats.mannwhitneyu(ref,alt,alternative="two-sided")           
           reflen = len(ref)
           altlen = len(alt)
           if reflen > 0:
              refmean = sum(ref)/reflen
           if altlen > 0:
              altmean = sum(alt)/altlen
           if refmean > 0:
              fold = (altmean - refmean) / refmean
           else:
              fold = "INF"
           if refmean > 0 or altmean > 0: 
              s,p = sp.stats.mannwhitneyu(ref,alt,alternative="two-sided")
           else:
              s = "NA"
              p = "NA"
  
           print(str(pidn) + "\t" + str(refmean) + "\t" + str(altmean) + "\t" + str(fold)  + "\t" +  str(p)) 
           ref = []
           alt = []
           refm = []
           altm = []
           if ln[1] != "NA":
              ref.append(float(ln[1]))
           if ln[2] != "NA":
              alt.append(float(ln[2]))    
      if idn == pidn:
           if ln[1] != "NA":
              ref.append(float(ln[1]))
           if ln[2] != "NA":
              alt.append(float(ln[2]))
      pidn = idn      
