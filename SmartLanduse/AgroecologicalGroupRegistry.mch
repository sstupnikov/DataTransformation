/* AgroecologicalGroupRegistry
 * Author: ssa
 * Creation date: 5/29/2024
 */
MACHINE
    AgroecologicalGroupRegistry

DEFINITIONS
    tmp_ae_group_struct == struct(
	    administrative_region: seq(0..255),
	    zone: seq(0..255),
	    province: seq(0..255),
	    administrative_district: seq(0..255),
	    ae_group: seq(0..255),
	    description: seq(0..255),
	    ae_type: seq(0..255), 
	    topsoil_thickness: seq(0..255),
	    humus_content: seq(0..255),
	    phkcl: seq(0..255),
	    hydrolytic_acidity: seq(0..255),
	    ground_water_level: seq(0..255),
	    relief: seq(0..255),
	    otlozheniya: seq(0..255),
	    pochva: seq(0..255),
	    climate: seq(0..255)
    )

OPERATIONS
    
extract(records) = 
PRE records: FIN(tmp_ae_group_struct) 
THEN
    skip
END;    

select_record_to_transform =
skip;

transform_zone = 
skip;

transform_province = 
skip;

transform_region = 
skip;

transform_district = 
skip;

transform_group = 
skip;

transform_type = 
skip;

transform_topsoil = 
skip;

transform_humus = 
skip;

transform_phkcl = 
skip;


transform_acidity = 
skip;

transform_water_level = 
skip

END
