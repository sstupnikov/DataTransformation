create table agroecological_group_registry."tmp_ae_group" (
	administrative_region varchar,
	zone varchar,
	province varchar,
	administrative_district varchar,
	ae_group varchar,
	description varchar,
	ae_type varchar, 
	topsoil_thickness varchar,
	humus_content varchar,
	рhkcl varchar,
	hydrolytic_acidity varchar,
	ground_water_level varchar,
	relief varchar,
	otlozheniya varchar,
	pochva varchar,
	climate varchar
);



create or replace procedure agroecological_group_registry.init_ae_group(f_name varchar)
    language 'plpgsql'
as $body$
declare
    r_group record;
	v_zone_id bigint;
	v_province_id bigint;
	v_administrative_region_id bigint;
	v_administrative_district_id bigint;
	v_ae_group_id bigint;
	v_ae_type_id bigint;
begin
	truncate table agroecological_group_registry.tmp_ae_group;
	execute format (
		'copy agroecological_group_registry.tmp_ae_group from ''' || f_name || ''' delimiter ''|'' header csv force not null description, relief, otlozheniya, pochva, climate;'
	);
    for r_group in select * from agroecological_group_registry.tmp_ae_group
    loop
		select zone_id into v_zone_id from agroecological_group_registry."zone" where name is not distinct from r_group.zone;
		if v_zone_id is null then
			insert into agroecological_group_registry."zone" (name) values (r_group.zone);
			select zone_id into v_zone_id from agroecological_group_registry."zone" where name is not distinct from r_group.zone;
		end if;

		select province_id into v_province_id from agroecological_group_registry."province" where name is not distinct from r_group.province and zone_id = v_zone_id;
		if v_province_id is null then
			insert into agroecological_group_registry."province" (zone_id, name) values (v_zone_id, r_group.province);
			select province_id into v_province_id from agroecological_group_registry."province" where name is not distinct from r_group.province and zone_id = v_zone_id;
		end if;

		select administrative_region_id into v_administrative_region_id from agroecological_group_registry."administrative_region" where name is not distinct from r_group.administrative_region;
		if v_administrative_region_id is null then
			insert into agroecological_group_registry."administrative_region" (name) values (r_group.administrative_region);
			select administrative_region_id into v_administrative_region_id from agroecological_group_registry."administrative_region" where name is not distinct from r_group.administrative_region;
			insert into agroecological_group_registry."administrative_region_zone" (administrative_region_id, zone_id) values (v_administrative_region_id, v_zone_id);
		end if;

		select administrative_district_id into v_administrative_district_id from agroecological_group_registry."administrative_district" where name is not distinct from r_group.administrative_district and administrative_region_id = v_administrative_region_id;
		if v_administrative_district_id is null then
			insert into agroecological_group_registry."administrative_district" (administrative_region_id, name) values (v_administrative_region_id, r_group.administrative_district);
			select administrative_district_id into v_administrative_district_id from agroecological_group_registry."administrative_district" where name is not distinct from r_group.administrative_district and administrative_region_id = v_administrative_region_id;
			insert into agroecological_group_registry."administrative_district_province" (administrative_district_id, province_id) values (v_administrative_district_id, v_province_id);
		end if;

		select ae_group_id into v_ae_group_id from agroecological_group_registry."ae_group" where name is not distinct from r_group.ae_group;
		if v_ae_group_id is null then
			insert into agroecological_group_registry."ae_group" (name) values (r_group.ae_group);
			select ae_group_id into v_ae_group_id from agroecological_group_registry."ae_group" where name is not distinct from r_group.ae_group;
		end if;

		select ae_type_id into v_ae_type_id from agroecological_group_registry."ae_type" where name is not distinct from r_group.ae_type and ae_group_id = v_ae_group_id;
		if v_ae_type_id is null then
			insert into agroecological_group_registry."ae_type" (ae_group_id, name, relief, otlozheniya, pochva, climate) values (v_ae_group_id, r_group.ae_type, r_group.relief, r_group.otlozheniya, r_group.pochva, r_group.climate);
			select ae_type_id into v_ae_type_id from agroecological_group_registry."ae_type" where name is not distinct from r_group.ae_type  and ae_group_id = v_ae_group_id;
			insert into agroecological_group_registry."province_ae_type" (province_id, ae_type_id) values (v_province_id, v_ae_type_id);

			if r_group.topsoil_thickness is not null then
				insert into agroecological_group_registry."ae_type_property" (ae_type_id, name, units, value) values (v_ae_type_id, 'мощность пахотного слоя', 'см', r_group.topsoil_thickness);
			end if;
			if r_group.humus_content is not null then
				insert into agroecological_group_registry."ae_type_property" (ae_type_id, name, units, value) values (v_ae_type_id, 'содержание гумуса', '%', r_group.humus_content);
			end if;
			if r_group.рhkcl is not null then
				insert into agroecological_group_registry."ae_type_property" (ae_type_id, name, units, value) values (v_ae_type_id, 'рнkcl', 'рнkcl', r_group.рhkcl);
			end if;
			if r_group.hydrolytic_acidity is not null then
				insert into agroecological_group_registry."ae_type_property" (ae_type_id, name, units, value) values (v_ae_type_id, 'гидролитическая кислотность', 'мг-экв на 100 г', r_group.hydrolytic_acidity);
			end if;
			if r_group.ground_water_level is not null then
				insert into agroecological_group_registry."ae_type_property" (ae_type_id, name, units, value) values (v_ae_type_id, 'уровень грунтовых вод', 'м', r_group.ground_water_level);
			end if;
		end if;
    end loop;
end;
$body$;



create table agroecological_group_registry.tmp_ae_group_climate (
	administrative_region varchar,
	zone varchar,
	province varchar,
	administrative_district varchar,
	geomorphology varchar,
	climate varchar
);

create or replace procedure agroecological_group_registry.init_ae_group_climate(f_name varchar)
    language 'plpgsql'
as $body$
declare
    r_group record;
	v_zone_id bigint;
	v_province_id bigint;
begin
	truncate table agroecological_group_registry.tmp_ae_group_climate;
	execute format (
		'copy agroecological_group_registry.tmp_ae_group_climate from ''' || f_name || ''' delimiter ''|'' header csv;'
	);
    for r_group in select * from agroecological_group_registry.tmp_ae_group_climate  
    loop
		select zone_id into v_zone_id from agroecological_group_registry."zone" where name is not distinct from r_group.zone;
		select province_id into v_province_id from agroecological_group_registry."province" where name is not distinct from r_group.province and zone_id = v_zone_id;
		if v_province_id is not null then
			update agroecological_group_registry."province" set geomorphology = r_group.geomorphology, climate = r_group.climate where province_id = v_province_id;
		end if;
    end loop;
end;
$body$;



