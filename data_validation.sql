select
	*
from "postgres"."Hospital_data".hcahps_data
where upper(facility_name) like '%HOUSTON VA MEDICAL CENTER%'
where facility_id = '200018' and lower(hcahps_question) like '%"always" clean%'
	

Facility Name
HOUSTON VA MEDICAL CENTER

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
	
--- same facility name may have different facility_id
with check_table as
	(
select 
	facility_name,
	max(facility_id) as max_id,
	min(facility_id) as min_id,
	case
		when max(facility_id) = min(facility_id) then 'Same'
		else 'Different'
	end as facility_name_check
from "postgres"."Hospital_data".hcahps_data
group by facility_name
)
select
count(*)
from check_table
where facility_name_check='Different'

select 
	facility_name,
	count(facility_id)
from "postgres"."Hospital_data".hcahps_data
group by facility_name
order by 2 desc
	
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
	

	
-- hcahps_question and hcahps_answer_description are redundant
select
	distinct(hcahps_question),
	hcahps_answer_description
from "postgres"."Hospital_data".hcahps_data
order by hcahps_question

-- 21 of the questions are useless, because the answer percent value is all null 
select 
	distinct(hcahps_question)
from "postgres"."Hospital_data".hcahps_data
where hcahps_answer_percent is null

-- understand rest of the 72 questions

select 
	distinct(hcahps_question)
from "postgres"."Hospital_data".hcahps_data
where hcahps_answer_percent is not null
order by 1

-- each question has three answer options:
-- "Strongly Agree", "Agree", "Disagree" (4 x 3 questions)
--	"rating of 9 or 10", "7 or 8", "5 or 6" (1 x 3 questions)
-- "always", "usually", "sometimes or never" (16 x 3 questions)
-- "Yes", "No"	 (5 x 2 questions)
-- question categories: communication / informative, service, facility (quiet / clean)
select 
	distinct(hcahps_question)	
from "postgres"."Hospital_data".hcahps_data
where hcahps_answer_percent is not null and hcahps_question like '%"Agree"%'

select 
	distinct(hcahps_question)
from "postgres"."Hospital_data".hcahps_data
where hcahps_answer_percent is not null and lower(hcahps_question) like '%rating of%'

-- check if ratings of (5 or 6), (7 or 8), (9 or 10) always have a sum of 100%
with rating_sum_check as
(
select 
	facility_id, -- checking by facility_id won't result in rating_sum>100, use facility name will have rating_sum>100
	sum(hcahps_answer_percent) as rating_sum
from "postgres"."Hospital_data".hcahps_data
where lower(hcahps_question) like '%rating of%'
group by facility_id
)
select * from rating_sum_check where rating_sum<100

--- facilities with >100% were found, and after checking, it is because some facilities have the same name but different facility_id
select 
/*	facility_name,
	hcahps_question,
	hcahps_answer_percent
*/
	*
from "postgres"."Hospital_data".hcahps_data
where lower(hcahps_question) like '%rating of%' and facility_name = 'CITIZENS MEDICAL CENTER'



	
select 
	distinct(hcahps_question)
from "postgres"."Hospital_data".hcahps_data
where hcahps_answer_percent is not null and lower(hcahps_question) like '%always%'

select 
	distinct(hcahps_question)
from "postgres"."Hospital_data".hcahps_data
where hcahps_answer_percent is not null and (hcahps_question) like '%YES%'

-- 12 answers about doctors corresponds to 4 questions
-- can identify positive answers by "always"
select 
	distinct(hcahps_question)
from "postgres"."Hospital_data".hcahps_data
where hcahps_question like '%doctors%'

-- 12 answers about nurses corresponds to 4 questions
-- can identify positive answers by "always"
select 
	distinct(hcahps_question)
from "postgres"."Hospital_data".hcahps_data
where hcahps_question like '%nurses%'

-- 12 answers about staff corresponds to 4 questions
-- can identify positive answers by "always" or "agree"
select 
	distinct(hcahps_question)
from "postgres"."Hospital_data".hcahps_data
where hcahps_question  like '%staff%'



	
-- check start date and end date
-- all rows have the same start and end date, 1/1/2022 - 12/31/2022
select
	distinct(end_date)
from "postgres"."Hospital_data".hcahps_data


-- total survey distributed = completed_survery / survey_response_percentage
-- Is it proportional to hospital size?