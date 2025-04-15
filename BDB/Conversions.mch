/* Conversions
 * Author: ssa
 * Creation date: 4/2/2025
 */
MACHINE
    Conversions

SEES Math

//ABSTRACT_CONSTANTS
    //hms2deg,
    //dms2deg,
    //asec2deg

//PROPERTIES
    //hms2deg = %(hh, mm, ss).(hh: REAL & mm: REAL & ss: REAL | hh*15.0 + mm*15.0/60.0 + ss*15.0/3600.0) &
    //hms2deg: REAL*REAL*REAL --> REAL & 
    //!(hh, mm, ss).(hh: REAL & mm: REAL & ss: REAL =>  hms2deg(hh, mm, ss) = hh*15.0 + mm*15.0/60.0 + ss*15.0/3600.0) &
    
    //dms2deg = %(dd,mm,ss).(dd: REAL & mm: REAL & ss: REAL | dd + mm/60.0 + ss/3600.0) &
    //dms2deg: REAL*REAL*REAL --> REAL & 
    //!(dd,mm,ss).(dd: REAL & mm: REAL & ss: REAL =>  dms2deg(dd, mm, ss) = dd + mm/60.0 + ss/3600.0) &
  
    // asec2deg = %(asec).(asec: REAL | asec/3600.0)
    //asec2deg: REAL --> REAL & 
    //!(asec).(asec: REAL =>  asec2deg(asec) = asec/3600.0) 

OPERATIONS

res <-- hms2deg(hh, mm, ss) =
PRE 
    hh: REAL & mm: REAL & ss: REAL
THEN
    res:= hh*15.0 + mm*15.0/60.0 + ss*15.0/3600.0
END;    

res <-- dms2deg(dd, mm, ss) = 
PRE 
    dd: REAL & mm: REAL & ss: REAL
THEN
    res:= dd + mm/60.0 + ss/3600.0
END;    

res <-- asec2deg(asec) = 
PRE 
    asec: REAL
THEN
    res:= asec/3600.0
END;    


ra, de <-- rel2abs(bRA, bDE, theta, rho) = 
PRE
    bRA: REAL & bDE: REAL & theta: REAL & rho: REAL 
THEN
   ANY theta0, theta1, th, dd, dd1, da, da1 WHERE
       theta0: REAL & theta0 = theta - 360.0*real(trunc(theta/360.0)) &
       theta1: REAL & (theta0 < 0.0 => theta1 = 360.0 + theta) & (theta0 >= 0.0 => theta1 = theta) &
       th: REAL & th = theta0 * pi/180.0 &
       dd: REAL & dd = rho/sqrt(1.0 + (tan(th)**2)) &
       da: REAL & da = abs(dd)*abs(tan(th)) & 
       dd1: REAL & da1: REAL & 
       (theta1 < 90.0 & bDE < 0.0 => dd1 = 0.0 - dd & da1 = da) & 
       (theta1 >= 90.0 & theta1 < 180.0 & bDE > 0.0 => dd1 = 0.0 - dd & da1 = da) &
       (theta1 >= 180.0 & theta1 < 270.0 & bDE > 0.0 => da1 = 0.0 - da & dd1 = 0.0 - dd) &
       (theta1 >= 180.0 & theta1 < 270.0 & bDE <= 0.0 => da1 = 0.0 - da & dd1 = dd) &
       (theta1 >= 270.0 & bDE < 0.0 => da1 = 0.0 - da & dd1 = 0.0 - dd) &
       (theta1 >= 270.0 & bDE >= 0.0 => da1 = 0.0 - da & dd1 = dd) 
   THEN           
       ra, de := bRA + da1, bDE + dd1
   END
END    
    
END
