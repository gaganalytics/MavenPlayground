-- Breaking down each table. Let's begin with restaurants. We'll find the spread of restaurants across different attributes. 

-- Let's find out the percentage of restaurants that offer different Alcohol_Service. 

	select distinct(Alcohol_Service)
	from restaurants

	select Alcohol_Service, count(*) as Number_Of_Restaurants, Round(cast(count(*)*100 as float)/cast(sum(count(*)) over() as float),2) as Percentage_of_Restaurants 
	from restaurants 
	group by Alcohol_Service
	order by 2 desc

-- Let's find out the percentage of restaurants that allow smoking vs no-smoking.

	select distinct(Smoking_Allowed)
	from restaurants

	select Smoking_Allowed, count(*) as Number_Of_Restaurants, Round(cast(count(*)*100 as float)/cast(sum(count(*)) over() as float),2) as Percentage_of_Restaurants 
	from restaurants 
	group by Smoking_Allowed
	order by 2 desc

-- How restaurants are distributed based on price points. 

	select distinct(Price)
	from restaurants

	select Price, count(*) as Number_Of_Restaurants, Round(cast(count(*)*100 as float)/cast(sum(count(*)) over() as float),2) as Percentage_of_Restaurants 
	from restaurants 
	group by Price
	order by 2 desc

-- Restaurants that provide parking vs no parking vs public parking vs valet parking

	select distinct(Parking)
	from restaurants

	select Parking, count(*) as Number_Of_Restaurants, Round(cast(count(*)*100 as float)/cast(sum(count(*)) over() as float),2) as Percentage_of_Restaurants 
	from restaurants 
	group by Parking
	order by 2 desc

-- Spread of restaurants by location. 
	
	select distinct(City)
	from restaurants

	select City, count(*) as Number_Of_Restaurants,  Round(cast(count(*)*100 as float)/cast(sum(count(*)) over() as float),2) as Percentage_of_Restaurants 
	from restaurants
	group by City
	order by 2 desc

-- Let's look at the different cuisines restaurants provide and the number and percentage of restaurant that provide a specific type of cuisine. 
	
-- There are a total of 23 distinct cusines across restaurants in Mexico in the given dataset.
	select distinct(Cuisine)
	from restaurant_cuisines

	 
-- Spread of restaurants based on the specific cuisines. 
	select Cuisine, count(*) as Number_Of_Restaurants, Round(cast(count(*)*100 as float)/cast(sum(count(*)) over() as float),2) as Percentage_of_Restaurants 
	from restaurant_cuisines 
	group by Cuisine
	order by 2 desc


-- Breaking down the ratings. 

-- The customers have rated the restaurants on a scale of 0-2, 0 being the lowest and 2 being the highest across Overall, Food and Service ratings for a restaurant. 

-- Finding the highest rated restaurants (0-2) and the number of ratings the restaurants received. Creating it as a view to use it later when joining with other tables. 

	Create view RestaurantByRatings as
	select Restaurant_ID, count(*) as Number_of_Ratings, round(Avg(Overall_Rating),2) as Average_Overall_Rating, round(Avg(Food_Rating),2) as Average_Food_Rating, round(Avg(Service_Rating),2) Average_Service_Rating,
	(select round((Avg(Overall_Rating)+Avg(Food_Rating)+Avg(Service_Rating))/3,2) as AverageRating) as Total_Average_Rating 	-- I used a subquery to calculate the Total_Average_Rating but would be open to a more efficient of calculating that column. 
	from ratings
	group by Restaurant_ID

-- Looking at the Top 5 restaurant by Total_Average_Rating (Aggregate of average of each rating i.e. food rating, service rating, overall rating)
	select top 5 *
	from RestaurantByRatings
	order by Number_of_Ratings desc, Total_Average_Rating desc

-- Breaking down the consumers table. There are a total of 138 consumers across 3 states and 4 cities.  

	select distinct(State), City
	from consumers
	group by State, City

-- Let's understand consumer demographics. 

-- Population density by cities 

	select City, count(*) as Number_Of_Consumers, round(cast(count(*)*100 as float)/cast(sum(count(*)) over () as float),2) as Percentage_of_Consumers
	from consumers
	group by city
	order by 2 desc

-- Marital Status 

	select Marital_Status, count(*) as Number_Of_Consumers, round(cast(count(*)*100 as float)/cast(sum(count(*)) over() as float),2) as Percentage_of_Consumers
	from consumers 
	group by Marital_Status
	order by 2 desc

-- Occupation

	select Occupation, count(*) as Number_Of_Consumers, round(cast(count(*)*100 as float)/cast(sum(count(*)) over() as float),2) as Percentage_of_Consumers
	from consumers 
	group by Occupation
	order by 2 desc
	-- Almost 82% of the population are students i.e., 113 students from a total of 138 consumers. 

-- Transportation_Method

	select Transportation_Method, count(*) as Number_Of_Consumers, round(cast(count(*)*100 as float)/cast(sum(count(*)) over() as float),2) as Percentage_of_Consumers
	from consumers 
	group by Transportation_Method
	order by 2 desc

-- Smokers v/s Non-smokers

	select Smoker, count(*) as Number_Of_Consumers, round(cast(count(*)*100 as float)/cast(sum(count(*)) over() as float),2) as Percentage_of_Consumers
	from consumers 
	group by Smoker
	order by 2 desc

-- Alcohol Consumption Levels

	select Drink_Level, count(*) as Number_Of_Consumers, round(cast(count(*)*100 as float)/cast(sum(count(*)) over() as float),2) as Percentage_of_Consumers
	from consumers 
	group by Drink_Level
	order by 2 desc

-- Understanding age density. We will use cases to create appropriate bins. 
-- First, let's look at the minimum and maximum age in the dataset. 
	
	select min(Age) as Minimum_Age,(select max(age)) as Maximum_age
	from consumers

-- Let's create 3 bins to separate our consumers based on age groups. (18-35, 36-50, 51 & above)
	
	select
		case
		when Age >=18 and Age <=35 then '18-35'
		when Age >=36 and Age <=50 then '36-50'
		when Age >=51 and Age <=82 then '50 & Above'
		end as Age_range,
		count(case
		when Age >=18 and Age <=35 then '18-35'
		when Age >=36 and Age <=50 then '36-50'
		when Age >=51 and Age <=82 then '50 & Above'
		end) as Number_of_customers 
	from consumers 
	group by case
		when Age >=18 and Age <=35 then '18-35'
		when Age >=36 and Age <=50 then '36-50'
		when Age >=51 and Age <=82 then '50 & Above'
		end
	order by 2 desc

--  Understanding whether the consumers have independent or dependent children 

	select Children, count(*) as Number_Of_Consumers, round(cast(count(*)*100 as float)/cast(sum(count(*)) over() as float),2) as Percentage_of_Consumers
	from consumers 
	group by Children
	order by 2 desc
	
-- Looking at Consumer budgets 

	select Budget, count(*) as Number_Of_Consumers, round(cast(count(*)*100 as float)/cast(sum(count(*)) over() as float),2) as Percentage_of_Consumers
	from consumers 
	group by Budget
	order by 2 desc

-- Finally! The consumer_preferences table. 
	
	select Preferred_Cuisine, count(*) as Number_of_Consumers, round(cast(count(*)*100 as float)/cast(sum(count(*)) over() as float),2) as Percentage_of_Consumers
	from consumer_preferences
	group by Preferred_Cuisine
	order by 2 desc

-- Understanding consumer preferences.What is the most preferred cuisine among the population?

	select cp.Preferred_Cuisine, count(*) as Number_Of_Consumers, round(cast(count(*)*100 as float)/cast(sum(count(*))  over() as float),2) as Percentage_Of_Consumers
	from consumers c
	join consumer_preferences cp on c.Consumer_ID = cp.Consumer_ID
	group by cp.Preferred_Cuisine
	order by 3 desc

-- Let's look at students specifically.

	select c.Occupation, cp.Preferred_Cuisine, count(*) as Number_Of_Consumers, round(cast(count(*)*100 as float)/cast(sum(count(*))  over() as float),2) as Percentage_Of_Consumers
	from consumers c
	join consumer_preferences cp on c.Consumer_ID = cp.Consumer_ID
	where c.Occupation = 'Student'
	group by cp.Preferred_Cuisine, c.Occupation
	order by 3 desc
	-- Students account for almost 82% of the total population and 28% of students prefer eating Mexican Cuisine making it the most preferred cusisine among students followed by American and Pizzeria. 
	
-- Comparing consumer budgets with restaurant budgets

	select c.Occupation, c.Budget, r.Price, IIF(c.Budget = r.Price, 'Yes', 'No') as Price_VS_Budget_Satisfaction--, count(c.Budget) as Number_Of_Consumers, count(r.Price) as Number_Of_Restaurants
	from consumers c 
	join ratings rat on c.Consumer_ID = rat.Consumer_ID
	join restaurants r on rat.Restaurant_ID = r.Restaurant_ID
	--where c.Consumer_ID = 'U1002'
	--where IIF(c.Budget = r.Price, 'Yes', 'No') = 'Yes' --IIF(condition, value 1, value 2) allows you to compare values from one column to another for equality. 
	group by c.Occupation, c.Budget, r.Price, IIF(c.Budget = r.Price, 'Yes', 'No')
	order by count(c.Budget) desc

	/* 
	
	1. What are the consumer demographics? Does this indicate a bias in the data sample?
	Ans. The consumers are spread across 4 different cities in Mexico with majority of them (62%) from San Luis Potosi. 
		 Almost 90% of the consumers are single and 82% of all consumers account for Students. 
		 59% of the consumers prefer travelling via public transport.

	2. Are there any demand & supply gaps that you can exploit in the market?
	Ans. 29% of the population prefers eating Mexican cuisine, with American (3.33%) being the second most preferred cuisine, and Cafeteria and Pizzeria tying as the third most preferred cuisine (2.73%). 

	3. If you were to invest in a restaurant, which characteristics would you be looking for?


	4. What can you learn from the highest rated restaurants? Do consumer preferences have an effect on ratings?

	*/