/* Math
 * Author: ssa
 * Creation date: 4/2/2025
 */
MACHINE
    Math

ABSTRACT_CONSTANTS
    
    trunc,
    pi,
    sqrt,
    tan,
    abs

PROPERTIES
    
    trunc = %xx.(xx: REAL | floor(xx)) &
    
    pi = 3.14159265 &
    
    sqrt: REAL --> REAL &
    !xx.(xx: REAL => sqrt(xx)*sqrt(xx) = xx) &
    
    tan: REAL --> REAL &
    
    abs: REAL --> REAL & 
    !xx.(xx: REAL & xx >= 0.0 => abs(xx) = xx) &
    !xx.(xx: REAL & xx < 0.0 => abs(xx) = 0.0 - xx)    

END
