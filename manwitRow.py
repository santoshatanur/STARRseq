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
p1=0
s1=0
with open(filepath) as fp:
   for line in fp:
      ln = line.split("\t") 
      idn = ln[0]
      if ln[1] != "NA" and ln[3] != "NA":
         ref = [float(ln[1]),float(ln[3])]
         alt = [float(ln[2]),float(ln[4])]
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
            s1,p1 = sp.stats.ttest_ind(ref,alt)
         else:
            s = "NA"
            p = "NA"
            s1 = "NA"
            p1 = "NA"
      else:
        alt = [float(ln[2]),float(ln[4])]
        altlen = len(alt)
        if altlen > 0:
            altmean = sum(alt)/altlen
        fold = "NA"
        s = "NA"
        p = "NA"
        s1 = "NA"
        p1 = "NA"
  
      print(str(idn) + "\t" + str(refmean) + "\t" + str(altmean) + "\t" + str(fold)  + "\t" +  str(p) + "\t" +  str(p1)) 
