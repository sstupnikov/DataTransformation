/* Bindgap
 * Author: ssa
 * Creation date: 6/26/2024
 */
MACHINE
    Bindgap

DEFINITIONS

    SubstancesConv_struct == struct(
        SubstanceID: INT,
        UpdateStatus: INT,
        NumElements: INT,
        Compound: seq(0..255),
        Elements: seq(0..255)
    );
    
    PropertiesConv_struct == struct(
        NOMPROP: INT,
        UpdateStatus: INT,
        NAZVPROP: seq(0..255),
        HTML: seq(0..255)
    );
    
    DBContentConv_struct == struct(
        SubstanceID: INT,
        NOMPROP: INT,
        UpdateStatus: INT
    )

ABSTRACT_VARIABLES
    
    SubstancesConv,
    PropertiesConv,
    DBContentConv
    
INVARIANT
    
    SubstancesConv: FIN(SubstancesConv_struct) &
    !(subst1, subst2).(subst1: SubstancesConv & subst2: SubstancesConv & 
        subst1'SubstanceID = subst2'SubstanceID => 
        subst1 = subst2) &
    
    PropertiesConv: FIN(PropertiesConv_struct) &
    !(prop1, prop2).(prop1: PropertiesConv & prop2: PropertiesConv & 
        prop1'NOMPROP = prop2'NOMPROP => 
        prop1 = prop2) &
    
    DBContentConv: FIN(DBContentConv_struct) &
    !(cont1, cont2).(cont1: DBContentConv & cont2: DBContentConv & 
        cont1'SubstanceID = cont2'SubstanceID &
        cont1'NOMPROP = cont2'NOMPROP => 
        cont1 = cont2) 
    
    

    
INITIALISATION 
    
    SubstancesConv:= {} ||
    PropertiesConv:= {} ||
    DBContentConv:= {} 

END
