/* SmartLanduseDB
 * Author: ssa
 * Creation date: 5/28/2024
 */
MACHINE
    SmartLanduseDB

DEFINITIONS
    zone_struct == struct(
        zone_id: INT,
        name: seq(0..255)
    );
    
    province_struct == struct(
        province_id: INT,
        zone_id: INT,
        name: seq(0..255),
        geomorphology: seq(0..255),               
        climate: seq(0..255)               
    );
    
    administrative_region_struct == struct(
        administrative_region_id: INT,
        name: seq(0..255)
    );
    
    administrative_region_zone_struct == struct(
        administrative_region_id: INT,
        zone_id: INT
    );
    
    administrative_district_struct == struct(
        administrative_district_id: INT,
        administrative_region_id: INT,
        name: seq(0..255)
    );
    
    administrative_district_province_struct == struct(
        administrative_district_id: INT,
        province_id: INT
    );
    
    ae_group_struct == struct(
        ae_group_id: INT,
        name: seq(0..255),
        description: seq(0..255)
    );
    
    ae_type_struct == struct(
        ae_type_id: INT,
        ae_group_id: INT,
        name: seq(0..255),
        relief: seq(0..255),
    	otlozheniya: seq(0..255),
    	pochva: seq(0..255),
    	climate: seq(0..255)
    );
    
    province_ae_type_struct == struct(
        province_id: INT,
        ae_type_id: INT
    );
    
    ae_type_property_struct == struct(
        ae_type_id: INT,
    	name: seq(0..255),
    	units: seq(0..255),
    	value: seq(0..255)   
    )
    
    
    
    

ABSTRACT_VARIABLES
    zone,    
    province,
    administrative_region,
    administrative_region_zone,
    administrative_district,
    administrative_district_province,
    ae_group,
    ae_type,
    province_ae_type,
    ae_type_property

    
INVARIANT

    zone: FIN(zone_struct) & 
    !(zone1, zone2).(zone1: zone & zone2: zone & 
        zone1'zone_id = zone2'zone_id => 
        zone1 = zone2) &

    province: FIN(province_struct) &
    !(province1, province2).(province1: province & province2: province & 
        province1'province_id = province2'province_id => 
        province1 = province2) &
    
    administrative_region: FIN(administrative_region_struct) &
    !(ar1, ar2).(ar1: administrative_region & ar2: administrative_region & 
        ar1'administrative_region_id = ar2'administrative_region_id => 
        ar1 = ar2) &

    administrative_region_zone: FIN(administrative_region_zone_struct) &
    !(arz1, arz2).(arz1: administrative_region_zone & arz2: administrative_region_zone & 
        arz1'administrative_region_id = arz2'administrative_region_id &
        arz1'zone_id = arz2'zone_id => 
        arz1 = arz2) &
    
    administrative_district: FIN(administrative_district_struct) &
    !(ad1, ad2).(ad1: administrative_district & ad2: administrative_district & 
        ad1'administrative_district_id = ad2'administrative_district_id => 
        ad1 = ad2) &
    
    administrative_district_province: FIN(administrative_district_province_struct) &
    !(adp1, adp2).(adp1: administrative_district_province & adp2: administrative_district_province & 
        adp1'administrative_district_id = adp2'administrative_district_id &
        adp1'province_id = adp2'province_id => 
        adp1 = adp2) &
    
    ae_group: FIN(ae_group_struct) &
    !(ae_group1, ae_group2).(ae_group1: ae_group & ae_group2: ae_group & 
        ae_group1'ae_group_id = ae_group2'ae_group_id => 
        ae_group1 = ae_group2) &
    
    ae_type: FIN(ae_type_struct) &
    !(ae_type1, ae_type2).(ae_type1: ae_type & ae_type2: ae_type & 
        ae_type1'ae_type_id = ae_type2'ae_type_id => 
        ae_type1 = ae_type2) &
    
    province_ae_type: FIN(province_ae_type_struct) &
    
    ae_type_property: FIN(ae_type_property_struct)  &
    !(aetp).(aetp: ae_type_property => aetp'name /= [0]) &
    !(aetp1, aetp2).(aetp1: ae_type_property & aetp2: ae_type_property & 
        aetp1'ae_type_id = aetp2'ae_type_id & aetp1'name = aetp2'name => 
        aetp1 = aetp2)
    
    


INITIALISATION

    zone:= {} ||    
    province:= {} ||
    administrative_region:= {} ||
    administrative_region_zone:= {} ||
    administrative_district:= {} ||
    administrative_district_province:= {} ||
    ae_group:= {} ||
    ae_type:= {} ||
    province_ae_type:= {} ||
    ae_type_property:= {}
    


OPERATIONS
    
    
insert_into_zone (aname) = 
PRE aname: seq(0..255)
THEN
    ANY pk WHERE pk: INT & not(#(azone).(azone: zone & azone'zone_id = pk))
    THEN
       zone:= zone \/ {rec(zone_id: pk, name: aname)} 
    END
END;


insert_into_province (azone_id, aname) = 
PRE azone_id: INT & aname: seq(0..255)
THEN
    ANY pk WHERE pk: INT & not(#(aprovince).(aprovince: province & aprovince'province_id = pk))
    THEN
       province:= province \/ {rec(province_id: pk, zone_id: azone_id, name: aname, geomorphology: [0], climate: [0])}  
    END
END;

insert_into_administrative_region (aname) = 
PRE aname: seq(0..255)
THEN
    ANY pk WHERE pk: INT & not(#(ar).(ar: administrative_region & ar'administrative_region_id = pk))
    THEN
       administrative_region:= administrative_region \/ {rec(administrative_region_id: pk, name: aname)} 
    END
END;

insert_into_administrative_region_zone (anadministrative_region_id, azone_id) = 
PRE anadministrative_region_id: INT & azone_id: INT
THEN
    administrative_region_zone:= 
    administrative_region_zone \/ 
    {rec(administrative_region_id: anadministrative_region_id, zone_id: azone_id)} 
END;

insert_into_administrative_district (anadministrative_region_id, aname) = 
PRE anadministrative_region_id: INT & aname: seq(0..255)
THEN
    ANY pk 
    WHERE 
        pk: INT & 
        not(#(ad).(ad: administrative_district & ad'administrative_district_id = pk ))
    THEN
       administrative_district:= 
       administrative_district \/ 
       {rec(administrative_district_id: pk, administrative_region_id: anadministrative_region_id, name: aname)}  
    END
END;

insert_into_administrative_district_province (anadministrative_district_id, aprovince_id) = 
PRE anadministrative_district_id: INT & aprovince_id: INT
THEN
    administrative_district_province:= 
    administrative_district_province \/ 
    {rec(administrative_district_id: anadministrative_district_id, province_id: aprovince_id)} 
END;

insert_into_ae_group (aname) = 
PRE aname: seq(0..255)
THEN
    ANY pk WHERE pk: INT & not(#(aeg).(aeg: ae_group & aeg'ae_group_id = pk ))
    THEN
       ae_group:= ae_group \/ {rec(ae_group_id: pk, name: aname, description: [0])} 
    END
END;

insert_into_ae_type (anae_group_id, aname, arelief, anotlozheniya, apochva, aclimate) = 
PRE 
    anae_group_id: INT & 
    aname: seq(0..255) &  
    arelief: seq(0..255) & 
    anotlozheniya: seq(0..255) & 
    apochva: seq(0..255) &
    aclimate: seq(0..255) 
THEN
    ANY pk WHERE pk: INT & not(#(aet).(aet: ae_type & aet'ae_type_id = pk))
    THEN
       ae_type:= ae_type \/ {rec(ae_type_id: pk, ae_group_id: anae_group_id, name: aname, 
               relief: arelief, otlozheniya: anotlozheniya, pochva: apochva, climate: aclimate)} 
    END
END;

insert_into_province_ae_type (aprovince_id, anae_type_id) = 
PRE aprovince_id: INT & anae_type_id: INT
THEN
    province_ae_type:= 
    province_ae_type \/ 
    {rec(province_id: aprovince_id, ae_type_id: anae_type_id)} 
END;

insert_into_ae_type_property (anae_type_id, aname, anunits, avalue) = 
PRE anae_type_id: INT & aname: seq(0..255) &  anunits: seq(0..255) & avalue: seq(0..255)
THEN
    ae_type_property:= 
    ae_type_property \/ 
    {rec(ae_type_id: anae_type_id, name: aname, units: anunits, value: avalue)} 
END



END
