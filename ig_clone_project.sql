

#                             ...............PROJECT IG_CLONE................




use ig_clone;

# 1. Create an ER diagram or draw a schema for the given database.




# 2. We want to reward the user who has been around the longest, Find the 5 oldest users.

select * from users 
order by created_at 
limit 5;




# 3. To understand when to run the ad campaign, figure out the day of the week most users register on? 

with cte as
(select count(dayname(created_at)) as no_users, dayname(created_at) as day_name,
max(count(dayname(created_at))) over() maxi
from users
group by dayname(created_at)
order by no_users desc)
select*,
no_users=maxi as e
from cte
having e =1;
# 4. To target inactive users in an email ad campaign, find the users who have never posted a photo.


select u.id,username,p.id
from users as u
left join photos as p
on u.id = p.user_id
where p.id is null;



/*   select id,username
     from users
     where id not in ( select user_id 
                       from photos);  */



# 5. Suppose you are running a contest to find out who got the most likes on a photo. Find out who won?



with likes_cte as
( select photo_id,count(user_id) as no_likes
from likes
group by photo_id
order by no_likes desc
limit 1 )

select p.id,p.user_id,u.username,no_likes
from photos as p
inner join likes_cte as lc
on p.id = lc.photo_id
inner join users as u 
on u.id = p.user_id;

select id from users where id not in ( select user_id from likes);


# 6. The investors want to know how many times does the average user post.


select ((select count(id) from photos)/(select count(id) from users)) as avg_post;




# 7. A brand wants to know which hashtag to use on a post, and find the top 5 most used hashtags.


select t.id,tag_name,count(tag_id) as top_g
from tags as t
inner join photo_tags as pt
on t.id = pt.tag_id
group by tag_id
order by top_g desc
limit 7;




# 8. To find out if there are bots, find users who have liked every single photo on the site.

select 
username,count(u.id) as total
from likes as l
inner join users as u
on u.id = l.user_id
group by u.id
having total = (select count(id) from photos);





# 9. To know who the celebrities are, find users who have never commented on a photo.



select u.id,username,comment_text
from users as u
left join comments as c
on u.id = c.user_id
where comment_text is null;



/*  select username,id
    from users
    where id not in (select user_id
				     from comments);  */




# 10. Now it's time to find both of them together, find the users who have never commented on any photo 
#     or have commented on every photo. 


with user_comments as
(select
username,count(u.id) as total,comment_text as no_comment
from users as u
left join comments as c
on u.id = c.user_id
group by u.id
having total = (select count(id) from photos)
	or no_comment is null)

 
 select username,
        case when no_comment is null then 'not_commented'
        else 'commented_on every_photo'
		end as status
from user_comments;
 

