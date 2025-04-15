def hms2deg(hh,mm,ss):
  return hh*15.0+mm*15.0/60.0+ss*15.0/3600.0

def dms2deg(dd,mm,ss):
  return dd+mm/60.0+ss/3600.0
  
def asec2deg(asec):
  return asec/3600.0

def rel2abs(bRA,bDE,theta,rho):
  theta=theta-360.0*math.trunc(theta/360.0)
  if theta<0:
    theta=360.0+theta
  th=theta*math.pi/180.0
  dd=rho/math.sqrt(1.0+(math.tan(th)**2))
  da=abs(dd)*abs(math.tan(th))
  if theta<90.0:
    if bDE<0.0:
      dd=-dd
  elif theta<180.0:
    if bDE>0.0:
      dd=-dd
  elif theta<270.0:
    da=-da
    if bDE>0.0:
      dd=-dd
  else:
    da=-da
    if bDE<0.0:
      dd=-dd
#  print bRA,da
  return (bRA+da,bDE+dd)
