# Hospital Rating Dashboard

[View dashboard on tableau public](https://public.tableau.com/app/profile/jin.tan7372/viz/Hospitalratingboard/Dashboard1)




> This tableau dashboard is inspired by a [youtube video from Data Wizardry](https://www.youtube.com/watch?v=6YwwHfxAfZI&list=PLGjBYLuhsuwdmh_gnMs_56t22P8L2vW72&index=3)
>
> The raw data can be downloaded from [Data Wizardry website](https://datawizardry.academy/hcahps-patient-satisfaction-dashboard/) (signing up needed)

### Understand the data
- Check whether the field information is consistent or not
-   hospital basic information, such as facility id, facility name, address, zip code, telephone number
- What are the questions in the survey
- What's answer percentage and what's survey response rate percentage, and how are they calculated? (unknown)

### Observations on hcahps data
- data is clean, facility basic information is all consistent
- questions are organized well
- questions can be categorized to facility (cleanliness, quiet), communication (with doctors, nurses, and staff), service (get help in time)

### Observations on hospital beds data
- mainly about how many beds a hospital has

### What we want to get from the data?
- For patients, looking for a good hospital in neighborhood area
- For hospitals, how to improve their service

### Dashboard:
- example dashboard from data wizardry:
-   filter by state and hospital size
-   define top box, hospital rating 9-10, contains always, usually
-   question delta from mean cohort, cohort hospital delta spread
-   survey response rate, and # of completed surveys


### Issued encountered during project
- One facility_name can be corresponding to several facility_id, making statistic value wrong
- How to easily categorize questions to facility (cleanliness, quiet), communication (with doctors, nurses, and staff), service (get help in time)? Right now i can only think of manualy assign category to each question
- How to adjust font color based on the darkness/lightness of its background
- The spread dot that I want to highlight sometimes is hidden by other does of similar values
