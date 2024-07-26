select
	*
from "postgres"."Hospital_data".hcahps_data
	



-- check if facility_id and facility_name are one to one relation
-- (confirm that facility_name does not have mis-spelling)
-- same verification can be applied to address, city, state, zip_code, county_or_parish, telephone_number
-- all attributes mentioned above are verified
with check_table as
	(
select 
	facility_id,
	max(telephone_number) as max_fac_name,
	min(telephone_number) as min_fac_name,
	case
		when max(telephone_number) = min(telephone_number) then 'Same'
		else 'Different'
	end as facility_name_check
from "postgres"."Hospital_data".hcahps_data
group by facility_id
)

select
count(*)
from check_table
where facility_name_check='Different'

-- check if hcaphps_measure_id and hcaphps_question are one to one relation -- YES
with questionid_check_table as
	(
select 
	hcahps_measure_id,
	max(hcahps_question) as max_fac_name,
	min(hcahps_question) as min_fac_name,
	case
		when max(hcahps_question) = min(hcahps_question) then 'Same'
		else 'Different'
	end as hcaphps_question_check
from "postgres"."Hospital_data".hcahps_data
group by hcahps_measure_id
)

select
count(*)
from questionid_check_table
where hcaphps_question_check='Different'

-- check if survey_response_rate_percent and facility_id are one to one relation -- YES

with hcaphps_svy_resp_percent_check_table as
	(
select 
	facility_id,
	max(survey_response_rate_percent) as max_percent,
	min(survey_response_rate_percent) as min_percent,
	case
		when max(survey_response_rate_percent) = min(survey_response_rate_percent) then 'Same'
		else 'Different'
	end as hcaphps_svy_resp_percent_check
from "postgres"."Hospital_data".hcahps_data
group by facility_id
)

select
count(*)
from hcaphps_svy_resp_percent_check_table
where hcaphps_svy_resp_percent_check='Different'
	
-- hcahps_question and hcahps_answer_description are redundant
select
	distinct(hcahps_question),
	hcahps_answer_description
from "postgres"."Hospital_data".hcahps_data

-- Does each hospital have the same survey? (are number of questions the same?)
-- Yes, every hospital have a survey with 93 questions
with question_count_table as
(
select
	facility_id,
	count(distinct(hcahps_question)) as question_count
from "postgres"."Hospital_data".hcahps_data
group by facility_id
)
select
	facility_id
from question_count_table
where question_count != 93


-- total survey distributed = completed_survery / survey_response_percentage
-- Is it proportional to hospital size?