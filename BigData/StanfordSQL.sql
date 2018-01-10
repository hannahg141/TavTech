-- Stanford SQL Movie-Rating Query Exercises
	-- DATA: https://lagunita.stanford.edu/c4x/DB/SQL/asset/moviedata.html

-- 1 Find the titles of all movies directed by Steven Spielberg. 
SELECT title from Movie where director = "Steven Spielberg";

-- 2 Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.
SELECT DISTINCT year from Movie, Rating 
WHERE stars >= 4 
AND Movie.mID = Rating.mID
ORDER BY year ASC;

-- 3 Find the titles of all movies that have no ratings. 
SELECT title from Movie
WHERE Movie.mID not in (SELECT mID from Rating);

-- 4 Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date. 
SELECT name from Reviewer, Rating
WHERE ratingDate is null
AND Reviewer.rID = Rating.rID;

--5  Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. 
SELECT Reviewer.name, Movie.title, stars, Rating.ratingDate
FROM Reviewer, Movie, Rating
WHERE Movie.mID = Rating.mID
AND Reviewer.rID = Rating.rID
ORDER BY Reviewer.name, Movie.title, stars;

-- 6 For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie. 
SELECT DISTINCT Reviewer.name, Movie.title
FROM Reviewer, Movie, Rating R1, Rating R2
WHERE R1.ratingDate < R2.ratingDate
AND R1.stars < R2.stars
AND Reviewer.rID = R1.rID
AND Reviewer.rID = R2.rID
AND R1.mID = Movie.mID
AND R2.mID = Movie.mID;

-- 7 For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title. 
SELECT Movie.title, max(Rating.Stars) 
FROM Movie, Rating 
WHERE Movie.mID  = Rating.mID
GROUP BY Movie.title
HAVING Count(Rating.mID) > 1
ORDER BY Movie.title;

-- 8 For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title. 
SELECT Movie.Title, MAX(stars) - MIN(stars) as spread
FROM Movie, Rating
WHERE Movie.mID = Rating.mID
GROUP BY Movie.mID
ORDER BY spread DESC, Movie.title;

-- 9 Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.) 
SELECT ABS(first - second) FROM 
(SELECT AVG(before) first FROM 
(SELECT AVG(stars) before 
FROM Movie, Rating
WHERE Movie.mID = Rating.mID
AND Movie.year < 1980
GROUP BY Rating.mID)),  
(SELECT AVG(after) second FROM
(SELECT AVG(stars) after
FROM Movie, Rating
WHERE Movie.mID = Rating.mID
AND Movie.year >= 1980
GROUP BY Rating.mID));


-- SQL Movie-Rating Query Exercises Extras
-- 1 Find the names of all reviewers who rated Gone with the Wind.
SELECT DISTINCT Reviewer.name 
FROM Reviewer, Movie, Rating 
WHERE Movie.title = "Gone with the Wind"
AND Movie.mID = Rating.mID
AND Reviewer.rID = Rating.rID;

-- 2 For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars. 
SELECT Reviewer.name, Movie.title, Rating.stars 
FROM Reviewer, Movie, Rating
WHERE Reviewer.name = Movie.director 
AND Reviewer.rID = Rating.rID
AND Movie.mID = Rating.mID;
 
 -- 3 Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".) 
 SELECT Reviewer.name
FROM Reviewer
UNION
Select Movie.title
FROM Movie
ORDER BY Reviewer.name, Movie.title;

-- 4 Find the titles of all movies not reviewed by Chris Jackson.
SELECT DISTINCT Movie.title from Movie, Rating
WHERE Movie.mID not in (SELECT Rating.mID 
            FROM Rating, Reviewer
            WHERE Reviewer.name = "Chris Jackson"
            AND Reviewer.rID = Rating.rID);
            

-- 5 For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order. 
SELECT DISTINCT R1.name, R2.name 
FROM Reviewer R1, Reviewer R2, Rating RA1, Rating RA2, Movie M1, Movie M2
WHERE R1.rID = RA1.rID
AND R2.rID = RA2.rID
AND RA1.mID = M1.mID
AND RA2.mID = M2.mid
AND R1.name != R2.name
AND R1.rID != R2.rID
AND RA1.rID != RA2.rID
AND RA1.mID = RA2.mID
AND R1.name < R2.NAME
ORDER BY R1.name, R2.name

-- 6 For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars. 
SELECT Reviewer.name, Movie.title, Rating.stars
FROM Reviewer, Movie, Rating
WHERE stars in (SELECT MIN(stars) FROM Rating)
AND Reviewer.rID = Rating.rID
AND Movie.mID = Rating.mID
GROUP BY title;

-- 7 List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order. 
SELECT title, AVG(stars) as averageRatings
FROM Movie, Rating
WHERE Movie.mID = Rating.mID
GROUP by title
ORDER BY averageRatings DESC, title;

-- 8 Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.) 
SELECT name 
FROM Reviewer, Rating 
WHERE Rating.rID = Reviewer.rID
GROUP BY Rating.rID
HAVING count(Rating.rID) >= 3;

-- 9 Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.) 
SELECT title, director 
FROM Movie
WHERE director in (SELECT director 
            FROM Movie
            GROUP by director
            HAVING count(title) > 1)
ORDER BY director, title;

-- 10 Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.) 
SELECT title, averages
FROM (SELECT title, AVG(stars) as averages
        FROM Rating join Movie using(mID)
        GROUP BY mID) 
WHERE averages IN (SELECT MAX(averages) 
                    FROM (SELECT title, AVG(stars) as averages
                            FROM Rating join Movie 
                            USING(mID)
                            GROUP BY mID))

-- 11 Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.) 
SELECT title, averages
FROM (SELECT title, AVG(stars) as averages
        FROM Rating JOIN Movie using(mID)
        GROUP BY mID) 
WHERE averages IN (SELECT MIN(averages) 
                    FROM (SELECT title, AVG(stars) as averages
                            FROM Rating join Movie 
                            USING(mID)
                            GROUP BY mID))
 
 
 -- 12 For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL. 
 SELECT director, title, MAX(stars)
FROM Movie, Rating
WHERE title IN (SELECT title 
                    FROM Movie, Rating
                    WHERE Movie.mID = Rating.mID
                    GROUP BY Rating.mID
                    HAVING MAX(stars))
AND Movie.mID = Rating.mID
AND director is not null
GROUP BY director
HAVING MAX(stars)
ORDER BY director;
              
   










