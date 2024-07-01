/* MUService
 * Author: ssa
 * Creation date: 6/26/2024
 */
MACHINE
    MUService

DEFINITIONS

    "MUServiceDef.def"

CONSTANTS
    SystemInfoItemConst,
    PropertiesInfoItemConst,
    DBContentItemConst,
    MetaBaseConst

PROPERTIES
    SystemInfoItemConst: SystemInfoItem &
    SystemInfoItemConst = rec(SystemID: 0, Elements: [0], SystemInfo: [0],
        Description: [0], UpdateStatus: 0) &
    
    PropertiesInfoItemConst: PropertiesInfoItem &
    PropertiesInfoItemConst = rec(PropID: 0, Name: [0], Description: [0],
        WWWTemplatePage: [0], UpdateStatus: 0) &
    
    DBContentItemConst: DBContentItem &
    DBContentItemConst = rec(SystemID: 0, PropID: 0, UpdateStatus: 0) &
    
    MetaBaseConst = rec(
        SystemInfo: {SystemInfoItemConst}, 
        PropertiesInfo: {PropertiesInfoItemConst}, 
        DBContent: {DBContentItemConst}
    )

    

ABSTRACT_VARIABLES
    
    MetaBase
    
INVARIANT
    
    MetaBase: struct(
       SystemInfo: FIN(SystemInfoItem),
       PropertiesInfo: FIN(PropertiesInfoItem),
       DBContent: FIN(DBContentItem)
    )   
    
INITIALISATION
    
    // Initialisation with empty sets like below causes 'Unexpected Tag' during PO generation
    // MetaBase:= rec(SystemInfo: {}, PropertiesInfo: {}, DBContent: {})
    MetaBase:= MetaBaseConst 

OPERATIONS
    
initMetaBase = 
MetaBase:= MetaBaseConst
;

clearSystemInfo = 
MetaBase'SystemInfo:= {} 
;    

clearPropertiesInfo = 
MetaBase'PropertiesInfo:= {} 
;    

clearDBContent = 
MetaBase'DBContent:= {} 
;    

createNodeSystemInfoItem(value) =
PRE value: SystemInfoItem
THEN 
    MetaBase'SystemInfo := MetaBase'SystemInfo \/ {value}
END;    
    
createNodePropertiesInfoItem(value) =
PRE value: PropertiesInfoItem
THEN 
    MetaBase'PropertiesInfo := MetaBase'PropertiesInfo \/ {value}
END;    
        
createNodeDBContentInfoItem(value) =
PRE value: DBContentItem
THEN 
    MetaBase'DBContent := MetaBase'DBContent \/ {value}
END
    

END
