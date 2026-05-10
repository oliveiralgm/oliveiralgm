-- Write a query to calculate the distribution of comments by the count of users that joined Meta/Facebook between 2018 and 2020, for the month of January 2020.

-- The output should contain a count of comments and the corresponding number of users that made that number of comments in Jan-2020. For example, you'll be counting how many users made 1 comment, 2 comments, 3 comments, 4 comments, etc in Jan-2020. Your left column in the output will be the number of comments while your right column in the output will be the number of users. Sort the output from the least number of comments to highest.

-- To add some complexity, there might be a bug where an user post is dated before the user join date. You'll want to remove these posts from the result.

-- fb_users

-- id: int
-- name: varchar
-- joined_at: datetime
-- city_id: int
-- device: int

-- fb_comments

-- user_id: int
-- body: varchar
-- created_at: datetime

-- Solution:

select
  numb_comments,
  count(user_id)
from (
  select
    u.id as user_id,
    count(c.created_at) as numb_comments
  from fb_users u
  left join fb_comments c 
    on c.user_id = u.id
  where c.created_at > u.joined_at and c.created_at::varchar like '2020-01%'
  and extract(YEAR from joined_at) between 2018 and 2020
  group by u.id
) t
group by numb_comments
order by numb_comments
