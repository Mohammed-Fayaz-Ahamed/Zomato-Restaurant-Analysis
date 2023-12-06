use project1;


# Build a country Map Table
create view Country_table as select countrycode.*, count(distinct zomato.city) as 'Count of cities', count(zomato.RestaurantID) as 'Count of Restaurants',
currency.CurrencyrateINR, zomato.currency, 
round(avg(zomato.average_cost_for_two) *currency.CurrencyrateINR,2) as 'Average of avg_cost_for_two'
from zomato join countrycode
on zomato.CountryCode= countrycode.CountryCode 
join currency on countrycode.Country= currency.country
group by countrycode.CountryCode, countrycode.Country,currency.CurrencyrateINR,zomato.currency;

#Build a Calendar Table using the Column Datekey

create view Calender_table as select Datekey_Opening, year(Datekey_Opening) as 'Year', month(Datekey_Opening) as 'Month No',
date_format(Datekey_Opening,'%M') as 'Month Name', quarter(Datekey_Opening) as 'Quarter',
date_format(Datekey_Opening,'%Y-%M') as 'YearMonth', weekday(Datekey_Opening) as 'Weekday no', 
Dayname(Datekey_Opening) as 'Weekday name',
case when month(Datekey_Opening)-3 >0 then concat('FM',month(Datekey_Opening)-3) else concat('FM',month(Datekey_Opening)+9) end as 'Financial month',
case when quarter(Datekey_Opening)-1 >0 then concat('Q',quarter(Datekey_Opening)-1) else concat('Q',quarter(Datekey_Opening)+3) end as 'Financail Quarter'
from zomato;

#Find the Numbers of Resturants based on City and Country.
select City,count(RestaurantID) as 'Count of restaurant' from Zomato group by City Order by count(RestaurantID) desc;

select countrycode.country as 'Country',count(zomato.RestaurantID) as 'Count of restaurant' 
from countrycode join Zomato 
on countrycode.countrycode= zomato.CountryCode
group by countrycode.country Order by count(RestaurantID) desc;

# Numbers of Resturants opening based on Year , Quarter , Month

select year(Datekey_Opening) as 'Year', count(RestaurantID) as 'Count of restaurant'
from zomato group by year(Datekey_Opening) order by count(RestaurantID) desc;

select quarter(Datekey_Opening) as 'Quarter', count(RestaurantID) as 'Count of restaurant'
from zomato group by quarter(Datekey_Opening) order by count(RestaurantID) desc;

select date_format(Datekey_Opening,'%M') as 'Month', count(RestaurantID) as 'Count of restaurant'
from zomato group by date_format(Datekey_Opening,'%M') order by count(RestaurantID) desc;

# Count of Resturants based on Average Ratings
select case when Rating <2 then 1 when rating<3 then 2 when rating<4 then 3 else 4 end as avg_rating
, count(RestaurantID) as 'Count of restaurant' from zomato group by avg_rating;

# Create buckets based on Average Price of reasonable size and find out how many resturants falls in each buckets
select case when zomato.average_cost_for_two*currency.CurrencyrateINR <=150 then '0-100'
when zomato.average_cost_for_two*currency.CurrencyrateINR <=300 then '150-300'
when zomato.average_cost_for_two*currency.CurrencyrateINR <=500 then '300-500'
when zomato.average_cost_for_two*currency.CurrencyrateINR <=800 then '500-800'
when zomato.average_cost_for_two*currency.CurrencyrateINR <=1500 then '800-1.5K'
when zomato.average_cost_for_two*currency.CurrencyrateINR <=2000 then '1.5K-2K'
when zomato.average_cost_for_two*currency.CurrencyrateINR <=5000 then '2K-5K'
when zomato.average_cost_for_two*currency.CurrencyrateINR <=10000 then '5K-10K'
else '>10K' end as Price_Bucket, count(RestaurantID) as 'Count of Restaurants'
from zomato join countrycode
on zomato.CountryCode= countrycode.CountryCode 
join currency on countrycode.Country= currency.country
group by Price_Bucket order by count(RestaurantID) desc;

# Percentage of Resturants based on "Has_Table_booking"
select Has_Table_booking,concat(ROUND((COUNT(RESTAURANTID) / (SELECT COUNT(*) FROM zomato)) * 100 ),'%') AS  Pct_of_restaurants 
from zomato group by Has_Table_booking;

# Percentage of Resturants based on "Has_Online_delivery"
select Has_Online_delivery,concat(ROUND((COUNT(RESTAURANTID) / (SELECT COUNT(*) FROM zomato)) * 100 ),'%') AS Pct_of_restaurants 
from zomato group by Has_Online_delivery;

# count of cuisines city wise
select city , count(distinct cuisines) as 'Count of cuisines' from zomato group by city order by count(distinct cuisines) desc ;

# count of city by average rating
select case when Rating <2 then 1 when rating<3 then 2 when rating<4 then 3 else 4 end as avg_rating, count( distinct city) as count_of_city
from zomato group by avg_rating order by count( distinct city) desc;

# top 10 cuisines by restaurant count
select cuisines, count(RestaurantID) as count_of_restaurant from zomato group by cuisines order by count(RestaurantID) desc limit 10;


