/* Metabase
 * Author: ssa
 * Creation date: 6/27/2024
 */
MACHINE
    Metabase

DEFINITIONS
    
    "MetabaseDef.def"
    
    

ABSTRACT_VARIABLES
    
    SystemInfo,
    PropertiesInfo,
    DBContent

INVARIANT

    SystemInfo: FIN(SystemInfo_struct) &
    !(system1, system2).(system1: SystemInfo & system2: SystemInfo & 
        system1'DBID = system2'DBID & system1'SystemID = system2'SystemID => 
        system1 = system2) &
    
    PropertiesInfo: FIN(PropertiesInfo_struct) &
    !(prop1, prop2).(prop1: PropertiesInfo & prop2: PropertiesInfo & 
        prop1'DBID = prop2'DBID & prop1'PropID = prop2'PropID => 
        prop1 = prop2) &
    
    DBContent: FIN(DBContent_struct) &
    !(content1, content2).(content1: DBContent & content2: DBContent & 
        content1'DBID = content2'DBID & 
        content1'SystemID = content2'SystemID & 
        content1'PropID = content2'PropID => 
        content1 = content2) 
    
    
    

INITIALISATION
    
    SystemInfo:= {} ||
    PropertiesInfo:= {} ||
    DBContent:= {}

OPERATIONS

/*
delete_from_SystemInfo(adbid, asystemid) = 
PRE adbid: INT & asystemid: INT
THEN
    SystemInfo := SystemInfo - 
        { rcrd | rcrd: SystemInfo & rcrd'DBID = adbid & rcrd'SystemID  = asystemid}
END;

update_SystemInfo(adbid, asystemid, anelements, anelemnumber, asysteminfo, adecsription, anupdatestatus) =
PRE 
    adbid: INT & 
    asystemid: INT &
    anelements: seq(0..255) &
    anelemnumber: INT &
    asysteminfo: seq(0..255) &
    adecsription: seq(0..255) &
    anupdatestatus: INT
THEN
    SystemInfo := 
    (SystemInfo - 
        { rcrd | rcrd: SystemInfo & rcrd'DBID = adbid & rcrd'SystemID  = asystemid}) \/
    {rec(DBID: adbid, SystemID: asystemid, ElemNumber: anelemnumber, UpdateStatus: anupdatestatus,
        Elements: anelements, SystemInfo: asysteminfo, Description: adecsription)}
END;

insert_into_SystemInfo(adbid, asystemid, anelements, anelemnumber, asysteminfo, adecsription, anupdatestatus) =
PRE 
    adbid: INT & 
    asystemid: INT &
    anelements: seq(0..255) &
    anelemnumber: INT &
    asysteminfo: seq(0..255) &
    adecsription: seq(0..255) &
    anupdatestatus: INT
THEN
    SystemInfo :=  SystemInfo \/
    {rec(DBID: adbid, SystemID: asystemid, ElemNumber: anelemnumber, UpdateStatus: anupdatestatus,
        Elements: anelements, SystemInfo: asysteminfo, Description: adecsription)}
END;    
*/

result <-- getNewSystemID(adbid) = 
PRE adbid: INT
THEN
    IF card({ system | system: SystemInfo & system'DBID = adbid }) = 0
    THEN
        result:= 1
    ELSE
        result:= max({ systemid | systemid: INT & 
            #(system).(system: SystemInfo & system'DBID = adbid & system'SystemID = systemid) }) + 1
    END
END;    

UpdateSystemInfo(adbid, asystemid, anelements, anelemnumber, asysteminfo, adescription, anupdatestatus) =
PRE
    adbid: INT & 
    asystemid: INT &
    anelements: seq(0..255) &
    anelemnumber: INT &
    asysteminfo: seq(0..255) &
    adescription: seq(0..255) &
    anupdatestatus: INT
THEN
    IF anupdatestatus = 2 
    THEN
       SystemInfo := SystemInfo - 
        { rcrd | rcrd: SystemInfo & rcrd'DBID = adbid & rcrd'SystemID  = asystemid}         
    ELSE
        IF anelements = [0] or size(anelements) < 3 or anelemnumber < 1            
        THEN
            skip
        ELSE
            IF #(rcrd).(rcrd: SystemInfo & rcrd'DBID = adbid & rcrd'SystemID = asystemid)
            THEN // Update
                SystemInfo :=
                (SystemInfo - { rcrd | rcrd: SystemInfo & rcrd'DBID = adbid & rcrd'SystemID  = asystemid}) \/
                {rec(DBID: adbid, SystemID: asystemid, ElemNumber: anelemnumber, UpdateStatus: 1, 
                        Elements: anelements, SystemInfo: asysteminfo, Description: adescription)}
            ELSE // Insert
                SystemInfo :=  SystemInfo \/
                {rec(DBID: adbid, SystemID: asystemid, ElemNumber: anelemnumber, UpdateStatus: 1,
                        Elements: anelements, SystemInfo: asysteminfo, Description: adescription)}
            END
        END
    END        
END;    

// Elements value is like "-Ge-Li-Zn-"
// ElemNumber is a number of elements in Elements
// "-" ASCII symbol code is 45
result <-- GetElementsCountFromString(anelements) = 
PRE anelements: seq(0..255)
THEN
    IF size(anelements) < 3 
    THEN 
        result := 0
    ELSE
        result := card({ ii | ii: INT & ii >= 1 & ii <= size(anelements) & anelements(ii) = 45 })
    END
END;

UpdatePropertiesInfo(adbid, apropid, aname, adescription, awwwtemplatepage, anupdatestatus) =
PRE
    adbid: INT & 
    apropid: INT &
    aname: seq(0..255) &
    adescription: seq(0..255) &
    awwwtemplatepage: seq(0..255) &
    anupdatestatus: INT
THEN
    IF anupdatestatus = 2 
    THEN
       PropertiesInfo := PropertiesInfo - 
        { rcrd | rcrd: PropertiesInfo  & rcrd'DBID = adbid & rcrd'PropID  = apropid}         
    ELSE
       IF #(rcrd).(rcrd: PropertiesInfo & rcrd'DBID = adbid & rcrd'PropID = apropid)
       THEN // Update
           PropertiesInfo :=
           (PropertiesInfo - { rcrd | rcrd: PropertiesInfo & rcrd'DBID = adbid & rcrd'PropID = apropid}) \/
           {rec(DBID: adbid, PropID: apropid, Name: aname, Description: adescription, 
                   WWWTemplatePage: awwwtemplatepage, UpdateStatus: 1)}
       ELSE // Insert
           PropertiesInfo := PropertiesInfo \/
           {rec(DBID: adbid, PropID: apropid, Name: aname, Description: adescription, 
                   WWWTemplatePage: awwwtemplatepage, UpdateStatus: 1)}
       END
    END        
END;

UpdateDBContent(adbid, asystemid, apropid, anupdatestatus) =
PRE
    adbid: INT & 
    asystemid: INT &
    apropid: INT &
    anupdatestatus: INT
THEN
    IF anupdatestatus = 2 
    THEN
       DBContent := DBContent - 
        { rcrd | rcrd: DBContent  & rcrd'DBID = adbid & rcrd'SystemID = asystemid & rcrd'PropID  = apropid}         
    ELSE
       IF #(rcrd).(rcrd: DBContent & rcrd'DBID = adbid & rcrd'SystemID = asystemid & rcrd'PropID = apropid)
       THEN // Update
           DBContent :=
           (DBContent - { rcrd | rcrd: DBContent & rcrd'DBID = adbid & rcrd'SystemID = asystemid & rcrd'PropID = apropid}) \/
           {rec(DBID: adbid, SystemID: asystemid, PropID: apropid, UpdateStatus: 1)}
       ELSE // Insert
           DBContent := DBContent \/
           {rec(DBID: adbid, SystemID: asystemid, PropID: apropid, UpdateStatus: 1)}
       END
    END        
END



END
