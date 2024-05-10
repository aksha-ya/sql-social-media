
--Queries

-- Location of User 
SELECT * FROM post
WHERE location IN ('agra' ,'maharashtra','west bengal');


-- Most Followed Hashtag

SELECT TOP 1 WITH TIES H.HASHTAG_NAME,COUNT(*) AS TOTAL_COUNTS FROM 
HASHTAGS H INNER JOIN HASHTAG_FOLLOW HT
ON H.HASHTAG_ID=HT.HASHTAG_ID
GROUP BY H.HASHTAG_NAME
ORDER BY TOTAL_COUNTS DESC

---Most Used Hashtag--
SELECT TOP 1  WITH TIES H.HASHTAG_NAME AS TRENDING_HASHTAGS,COUNT(*) AS NO_OF_TIMES_USED			
FROM HASHTAGS H INNER JOIN POST_TAGS P 			
ON H.HASHTAG_ID=P.HASHTAG_ID			
GROUP BY H.HASHTAG_NAME			
ORDER BY COUNT(H.HASHTAG_ID) DESC	

--Most Inactive user---

1)  SELECT U.USER_ID,U.USER_NAME AS INACTIVE_USER		
  FROM USERS U LEFT JOIN POST P		
  ON U.USER_ID=P.USER_ID		
  WHERE P.POST_ID IS NULL		


2)  SELECT USER_ID, USER_NAME AS 'MOST INACTIVE USER'
FROM USERS
WHERE USER_ID NOT IN (SELECT USER_ID FROM POST);


--MORE LIKED POSTS

WITH CTE AS (SELECT TOP 1 WITH TIES P.POST_ID,COUNT(P.POST_ID) AS COUNT_OF_LIKES
FROM POST P INNER JOIN POST_LIKES L
ON P.POST_ID=L.POST_ID
GROUP BY P.POST_ID
ORDER BY COUNT(P.POST_ID) DESC)

SELECT P.CAPTION,C.COUNT_OF_LIKES
FROM CTE C INNER JOIN POST P
ON C.POST_ID=P.POST_ID

--USERS AND THEIR POST COUNT
SELECT USER_ID,COUNT(POST_ID) AS USER_POST_COUNT
FROM POST
GROUP BY USER_ID

--AVERAGE POST PER USER--
SELECT ROUND((COUNT(post_id) / COUNT(DISTINCT user_id) ),2) AS 'Average Post per User' 
FROM POST

---- User who liked every single post---
SELECT username, Count(*) AS num_likes 
FROM users 
INNER JOIN post_likes ON users.user_id = post_likes.user_id 
GROUP  BY post_likes.user_id 
HAVING num_likes = (SELECT Count(*) FROM   post)

-- User Never Comment 
SELECT user_id, user_name AS 'User Never Comment'
FROM users
WHERE user_id NOT IN (SELECT user_id FROM comments)


--User Not Followed by anyone
SELECT USER_ID ,USER_NAME AS USERS_NOT_FOLLOWED_BY_ANYONE 
FROM USERS
WHERE USER_ID NOT IN(SELECT DISTINCT FOLLOWEE_ID FROM FOLLOWS)

-- User Not Following Anyone
SELECT USER_ID, USER_NAME AS 'User Not Following Anyone'
FROM USERS
WHERE USER_ID NOT IN (SELECT follower_id FROM follows);

-- Posted more than 5 times

SELECT USER_ID,COUNT(USER_ID) AS POST_COUNT FROM POST
GROUP BY USER_ID
HAVING COUNT(USER_ID)>5
ORDER BY POST_COUNT DESC

-- Followers > 40
SELECT FOLLOWEE_ID,COUNT(FOLLOWER_ID) AS FOLLOWER_COUNT  FROM FOLLOWS
GROUP BY FOLLOWEE_ID
HAVING COUNT(FOLLOWER_ID)>40
ORDER BY FOLLOWER_COUNT DESC

-- Any specific word in comment
SELECT * FROM comments
WHERE comment_text LIKE '%good|beautiful%'

-- Longest captions in post
SELECT USER_ID,CAPTION,LEN(CAPTION) AS CAPTION_LENGTH FROM POST
ORDER BY CAPTION_LENGTH DESC

---USER WITH MANY FOLLOWERS
SELECT FOLLOWEE_ID AS USER_ID,COUNT(FOLLOWER_ID) AS FOLLOWER_COUNT  FROM FOLLOWS
GROUP BY FOLLOWEE_ID
ORDER BY FOLLOWER_COUNT DESC





