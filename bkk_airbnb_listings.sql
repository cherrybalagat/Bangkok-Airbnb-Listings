/* Creating table and copying data from CSV */
CREATE TABLE bkk_airbnb (
	id int,
	name text,	
	hots_id numeric,
	host_total_listings numeric,
	neighbourhood text,
	latitude numeric,
	longitude numeric,
	property_type text, 
	room_type text,
	accommodates numeric,
	bedrooms numeric,
	amenities text,
	price text,
	minimum_nights numeric,
	number_of_reviews numeric,
	review_scores_rating numeric,
	review_scores_accuracy numeric,
	review_scores_cleanliness numeric,
	review_scores_checkin numeric,
	review_scores_communication numeric,
	review_scores_location numeric,
	review_scores_value numeric,
	instant_bookable boolean,
	reviews_per_month numeric
);

COPY bkk_airbnb
FROM 'D:\bkk_listings.csv'
DELIMITER ','
CSV header;

/* Delete null values */
DELETE FROM bkk_airbnb
WHERE accommodates = 0 	
	OR number_of_reviews = 0 
	OR review_scores_accuracy IS NULL
	OR host_total_listings IS NULL;

/* Null values in bedrooms does not mean no rooms, so null values are set to 1*/
UPDATE bkk_airbnb
SET bedrooms = 1
WHERE bedrooms IS NULL;

/* Remove comma and $ sign from price */
UPDATE bkk_airbnb
SET price = REPLACE(price,',','');

UPDATE bkk_airbnb
SET price = TRIM(LEADING '$' FROM price);

/* Change price data type from text to numeric */
ALTER TABLE bkk_airbnb
ALTER COLUMN price TYPE numeric
USING price::numeric;

/*Add column for count of amenities */
ALTER TABLE bkk_airbnb
ADD COLUMN number_amenities numeric;

UPDATE bkk_airbnb
SET number_amenities = (((CHAR_LENGTH(amenities)- CHAR_LENGTH(REPLACE(amenities,',',''))))+1); 

/* Count number of distinct host IDs */
SELECT COUNT(DISTINCT(host_id)) 
FROM bkk_airbnb;

/*Count number of total listings per distinct host IDs */
SELECT DISTINCT(host_id), 
	   host_total_listings 
FROM bkk_airbnb
ORDER BY host_total_listings DESC;

/* Show total count of listings and distinct hosts per neighborhood */
SELECT DISTINCT(neighbourhood), 
	   COUNT(neighbourhood) as listings, 
	   COUNT(DISTINCT(host_id)) as distinct_hosts 
FROM bkk_airbnb
GROUP BY neighbourhood
ORDER BY COUNT(neighbourhood) DESC;

/*Show average price per neighborhood */
SELECT DISTINCT(neighbourhood), 
	   ROUND(AVG(price),2) 
FROM bkk_airbnb
GROUP BY neighbourhood
ORDER BY ROUND(AVG(price),2) DESC;

/*Show count of listings and average price per neighborhood */
SELECT DISTINCT(neighbourhood), 
	   COUNT(neighbourhood), 
	   ROUND(AVG(price),2)  
FROM bkk_airbnb
GROUP BY neighbourhood
ORDER BY COUNT(neighbourhood);

/*Show distinct property types and count of listings per type*/
SELECT DISTINCT(property_type), 
	   COUNT(property_type)  
FROM bkk_airbnb
GROUP BY property_type
ORDER BY COUNT(property_type) DESC;

/* Show max number of accommodates and count of listings */
SELECT DISTINCT(accommodates), 
	   COUNT(accommodates) 
FROM bkk_airbnb
GROUP BY accommodates
ORDER BY accommodates DESC;

/* Show max number of bedrooms and count of listings */
SELECT DISTINCT(bedrooms), 
	   COUNT(bedrooms) 
FROM bkk_airbnb
GROUP BY bedrooms
ORDER BY bedrooms DESC;

/* Show count of instant bookable listings */
SELECT DISTINCT (instant_bookable), 
	   COUNT(instant_bookable) 
FROM bkk_airbnb
GROUP BY instant_bookable;

/* Show top 10 listings with highest reviews per month */
SELECT id, 
	   host_id, 
	   name, 
	   neighbourhood, 
	   reviews_per_month 
FROM bkk_airbnb
ORDER BY reviews_per_month DESC
LIMIT 10;

/* Show top 10 listings with most number of amenities */
SELECT id, 
	   host_id, 
	   name, 
	   neighbourhood, 
	   number_amenities, 
	   price, amenities 
FROM bkk_airbnb
ORDER BY number_amenities DESC
LIMIT 10


