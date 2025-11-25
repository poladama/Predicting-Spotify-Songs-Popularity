# Predicting-Spotify-Songs-Popularity

Author: Polina Adamovich

This project was completed as part of the Data-Centric Computing class in my Data Science Master's program at the University of Pittsburgh.

## Data source: 
[Tidy Tuesday project on Github](https://github.com/rfordatascience/tidytuesday/tree/main/data/2020/2020-01-21)

## Problem statement

I framed the task of predicting song popularity as a **binary classification** problem. Instead of predicting the degree of a song's popularity, the model predicts whether a song will be popular or not. To achieve this, I transformed the continuous `track_popularity` variable into a `binary_outcome`: songs with a popularity score over 50 were classified as 1 (popular), and all others were classified as 0 (not popular).

## Input variables

**Categorical:**
- `playlist_genre`
- `key`: originally a numeric variable that I decided to treat as a non-numeric because it has low number of unique values which represent categories.
- `mode`: originally a numeric variable but I treated it as a non-numeric because it has only 2 unique values and these numbers represent categories, not quantities.

**Continuous:** 
- `danceability`
- `energy`
- `loudness`
- `speechiness`
- `acousticness`
- `instrumentalness`
- `liveness`
- `valence`
- `tempo`
- `duration_ms`

**Excluded variables**
- Identifier variables: `track_id`, `track_album_id`, `playlist_id`
- Name columns: `track_name`, `track_album_name`, `playlist_name`, `track_artist`
- `track_album_release_date` (too biased towards 2019)
- `playlist_subgenre`: Although I explored in the EDA, I excluded it from the final models. Because it is a nested category of `playlist_genre`, including both variables would create redundancy. This would lead to unstable coefficient estimates and harm interpretability.

## Key findings
- Playlist genre is the most influential predictor of popularity.  
- Loudness and energy are the strongest continuous features.  
- Findings were consistent across EDA, predictive models, and clustering analysis.

## Final model selection
- Model 4 (additive model with categorical and continuous variables, no interactions) was chosen based on 5-fold cross-validation and ROC AUC.  
- Chose simplest model with comparable performance to more complex models.

## Skills acquired
This project provided my first end-to-end quantitative analysis, solidifying skills in **Python, data analysis, visualization, and model evaluation**. Most importantly, I gained a **structured approach to problem-solving**.
