-- Find the number of days a US track has stayed in the 1st position for both the US and worldwide rankings. Output the track name and the number of days in the 1st position. Order your output alphabetically by track name.
-- If the region 'US' appears in dataset, it should be included in the worldwide ranking.

-- spotify_daily_rankings_2017_us

-- position:int
-- trackname:varchar
-- artist:varchar
-- streams:int
-- url:varchar
-- date:datetime

-- spotify_worldwide_daily_song_ranking

-- id:int
-- position:int
-- trackname:varchar
-- artist:varchar
-- streams:int
-- url:varchar
-- date:datetime
-- region:varchar


with pos_us as
         (
             select
                 *
             from spotify_daily_rankings_2017_us
             where position = 1
         ),

     pos_w as
         (
             select
                 *
             from spotify_worldwide_daily_song_ranking
             where position = 1
         ),
     join_us_and_world as (
         select
             u.date as dateus
              ,u.trackname as track
              ,w.date as datew
         from pos_w w
                  inner join pos_us u
                             on w.url = u.url
     )

select
    track
     ,count(distinct dateus)

from join_us_and_world
where dateus = datew
group by track
