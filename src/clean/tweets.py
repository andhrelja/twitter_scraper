# %%
import os
import time
import csv
import pytz
import pandas as pd
import datetime as dt
from tqdm import tqdm

import utils
from utils import fileio
from twitter_scraper import settings

logger = utils.get_logger(__file__)

MIN_DATE = dt.datetime(2021, 8, 1, 0, 0, 0, 0, pytz.UTC)
MAX_DATE = dt.datetime(2022, 1, 31, 0, 0, 0, 0, pytz.UTC)


TWEET_DTYPE = {
    'id':               'string',
    'user_id':          'int',
    'full_text':        'string',
    'created_at':       'datetime64[ns, UTC]',
    'hashtags':         'object',
    'user_mentions':    'object',
    'retweet_user':     'object',
    'retweet_user_str': 'string',
	#'in_reply_to_status_id':      pd.Int64Dtype(),
	'in_reply_to_status_id_str':  'string',
	#'in_reply_to_user_id':        pd.Int64Dtype(),
	'in_reply_to_user_id_str':    'string',
	'in_reply_to_screen_name':    'string',
	'geo':              'object',
	'coordinates':      'object',
	# 'place':          'object',
	# 'contributors':   'object',
	# 'is_quote_status': 'bool',
    'retweet_count':    'int',
	'favorite_count':   'int',
	# 'favorited':      'bool',
	# 'retweeted':      'bool',
	# 'possibly_sensitive': 'bool',
	# 'lang': 'string',

    ### Custom columns
    'week': 'string',
    'month': 'string',
    'is_covid': 'bool'
}

# %%
def get_tweets_df():
    if not os.path.exists(settings.TWEETS_CSV):
        logger.info("Reading raw Tweet json, this may take a while")
        data = []
        for fn in tqdm(os.listdir(settings.USER_TWEETS_DIR)):
            content = fileio.read_content(os.path.join(settings.USER_TWEETS_DIR, fn), 'json')
            data += content

        tweets_df = pd.DataFrame(data)
        tweets_df['created_at'] = pd.to_datetime(tweets_df['created_at'], format='%a %b %d %H:%M:%S %z %Y')
        tweets_df['week']  = tweets_df['created_at'].dt.strftime('%Y-%W')
        tweets_df['month'] = tweets_df['created_at'].dt.strftime('%Y-%m')
        
        tweets_df = tweets_df[
            (tweets_df['created_at'] > MIN_DATE)
            & (tweets_df['created_at'] < MAX_DATE)
        ]

        tweets_df['full_text_nospace'] = tweets_df['full_text'].fillna('').str.replace(' ', '')
        tweets_df['is_covid_1'] = tweets_df['full_text'].fillna('').transform(lambda x: any(tag in x.lower()
                                                            for tag in settings.KEYWORDS['is_covid']))
        tweets_df['is_covid_2'] = tweets_df['full_text_nospace'].fillna('').transform(lambda x: any(tag.replace(' ', '') in x.lower()
                                                            for tag in settings.KEYWORDS['is_covid']))
        tweets_df['is_covid'] = tweets_df['is_covid_1'] | tweets_df['is_covid_2']
        tweets_df = tweets_df[list(TWEET_DTYPE.keys()) + ['week', 'month', 'is_covid']].astype(TWEET_DTYPE)
        
        logger.info("Writing Tweet model ...")
        tweets_df.to_csv(settings.TWEETS_CSV, encoding='utf-8', index=False, quoting=csv.QUOTE_ALL)
        return tweets_df
    
    logger.info("Reading Tweet model")
    tweets_df = pd.read_csv(settings.TWEETS_CSV, encoding='utf-8')
    tweets_df = tweets_df.astype(TWEET_DTYPE)
    return tweets_df


def get_nodes_df(tweets_df):
    user_df = pd.read_csv(settings.USERS_CSV, encoding='utf-8', index_col='user_id')
    nodes_df = tweets_df.groupby('user_id').agg(total_tweets=('user_id', 'size')).join(user_df, how='inner')
    nodes_df['covid_tweets']    = tweets_df[tweets_df['is_covid'] == True].groupby('user_id').size()
    nodes_df['is_covid']        = nodes_df['covid_tweets'].transform(lambda x: x > 0)
    nodes_df['covid_tweets']    = nodes_df['covid_tweets'].fillna(0).astype(int)
    nodes_df['covid_pct']       = nodes_df['covid_tweets'] / nodes_df['total_tweets']
    nodes_df                    = nodes_df.reset_index(drop=False)
    nodes_df['user_id_str']     = nodes_df['user_id'].astype(str)
    return nodes_df

# %%
def tweets(nodes=True):
    start_time = time.time()
    
    tweets_csv_dir, _ = os.path.split(settings.TWEETS_CSV)
    nodes_graph_dir, _ = os.path.split(settings.NODES_CSV)
    utils.mkdir(tweets_csv_dir)
    utils.mkdir(nodes_graph_dir)

    logger.info("Cleaning Tweets")
    tweets_df = get_tweets_df()
    logger.info("Done cleaning Tweets")
    logger.info("Tweet model saved: {}".format(settings.TWEETS_CSV))
    
    if nodes:
        logger.info("Creating Nodes df, this may take a while")
        nodes_df = get_nodes_df(tweets_df)
        nodes_df.to_csv(settings.NODES_CSV, encoding='utf-8', index=False, quoting=csv.QUOTE_NONNUMERIC)
        logger.info("Done creating Nodes df")
    logger.info("Graph nodes saved: {}".format(settings.NODES_CSV))
    
    end_time = time.time()
    logger.info("Time elapsed: {} min".format((end_time - start_time)/60))
    
# %%
if __name__ == '__main__':
    tweets(nodes=True)