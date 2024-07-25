-- check if facility_id and facility_name are one to one relation
-- (confirm that facility_name does not have mis-spelling)
with check_table as
	(
select 
	facility_id,
	max(facility_name) as max_fac_name,
	min(facility_name) as min_fac_name,
	case
		when max(facility_name) = min(facility_name) then 'Same'
		else 'Different'
	end as facility_name_check
from "postgres"."Hospital_data".hcahps_data
group by facility_id
)

select
count(*)
from check_table
where facility_name_check='Different'