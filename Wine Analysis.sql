##############################################################
### BASICS - group by, having, order by, distinct, max/min ###
##############################################################

#1. What is the average price of wine from each country? Only include countries with more than 5 wines. Sort Highest to lowest.
# determines most affordable countries for wine
select country, avg(price) as avg_price
from wine
group by country
having count(*) > 5
order by avg_price desc;

#2. What is the average points from each country? only include countries with more than 5 wines. Sort highest to lowest
# determines highest quality wine
select country, avg(points) as avg_points
from wine
group by country
having count(*) > 5
order by avg_points desc;

#3. calculate the points by price for each country that has more than 5 wines
# determines best value for wine
select country, (sum(points) / sum(price)) as points_price
from wine
where country is not null
group by country
having count(*) > 5
order by points_price desc;


#4. find the countries for which the lowest quality wine(s) are from.
select distinct country
from wine
where points = (select min(points)
from wine);

#sub 1: find lowest points
select min(points)
from wine;

#5. find the countries for which the highest quality wine(s) are from.
select distinct country
from wine
where points = (select max(points)
from wine);

#sub1
select max(points)
from wine;

####################################
### Subqueries, joins, wildcards ###
####################################
#1. How many wines have received higher points than the most expensive wine?
#complete query
select count(*)
from wine
where points > 
(select points
from wine
where price = 
(select max(price)
from wine));

#sub find points of that wine
select points
from wine
where price = (select max(price)
from wine);

#sub find max price
select max(price)
from wine;

#2. How many US wines have received higher points than the average point of French wine? 
select count(*)
from wine
where country = 'US' and points > (select avg(points)
from wine
where country = 'france');

#3. What percentage of French wines are variation of chardonnay?
select (chard / fran)
from (select count(*) as fran
from wine
where country = 'france') as sub1, (select count(*) as chard
from wine
where country = 'france' and variety like '%chardonnay%') as sub2;

#sub
select count(*) as franc
from wine
where country = 'france';
#sub
select count(*) as chard
from wine
where country = 'france' and variety like '&chardonnay%';

#4. what is the most common variety of wine in England?
#complete query
select variety, count(*)
from wine
where country = 'england'
group by variety
having count(*) = (select max(mycount)
from (select country, variety, count(*) mycount
from wine
where country = 'england'
group by variety) as sub1);

#sub2 find the max
select max(mycount)
from (select variety, count(*) as mycount
from wine
where country = 'england'
group by variety) as sub1;

#sub1 find count of each variety in england
select variety, count(*) as mycount
from wine
where country = 'england'
group by variety;


#5. how does the cost of England's sparkling blend comapre to the rest of the world?
select is_england - not_england
from (select avg(price) as is_england
from wine
where variety = 'sparkling blend' and country = 'england') as sub1, (select avg(price) as not_england
from wine
where variety = 'sparkling blend' and country != 'england') as sub2;

#sub2
# find avg cost of world not including england
select avg(price) as not_england
from wine
where variety = 'sparkling blend' and country != 'england';

#sub1
#find avg cost of england
select avg(price) as is_england
from wine
where variety = 'sparkling blend' and country = 'england';

#6. how does the quality of England's sparkling blend comapre to the rest of the world?
select is_england - not_england
from (select avg(points) as is_england
from wine
where country = 'england' and variety = 'sparkling blend') as sub1, (select avg(points) as not_england
from wine
where country != 'england'  and variety = 'sparkling blend') as sub2;

#sub1 england
select avg(points) as is_england
from wine
where country = 'england' and variety = 'sparkling blend';

#sub2 world
select avg(points) as not_england
from wine
where country != 'england'  and variety = 'sparkling blend';


#7.Get the unduplicated continent name(s) for which have the highest quality points score.
#complete query
select distinct continent
from country_list as cl
inner join wine as w
on cl.country = w.country
where wine_id in (select wine_id
from wine
where points = (select max(points)
from wine));

# Step 2: find wine ID's with max points
select wine_id
from wine
where points = (select max(points)
from wine);

# Step 1: find highest point score
select max(points)
from wine;

#8.Retrieve the winery, continent and designation of the wines for which the price
# is greater than the highest price of wines who's description contains 'chocolate'.

#complete query
select winery, continent, designation
from wine as w
inner join country_list as cl
on w.country = cl.country
where wine_id in (select wine_id
from wine
where price > (select max(price)
from wine
where description like '%chocolate%'));

# Step 2: find wines with higher price than below
select wine_id
from wine
where price > (select max(price)
from wine
where description like '%chocolate%');

# Step 1: find max price of 'chocolate' wine
select max(price)
from wine
where description like '%chocolate%';



