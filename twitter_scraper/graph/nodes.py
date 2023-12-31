# %%
import os
import csv
import pandas as pd
import datetime as dt

from twitter_scraper import utils
from twitter_scraper import settings
from twitter_scraper.clean.tweets import TWEET_DTYPE
from twitter_scraper.clean.users import USER_DTYPE

logger = utils.get_logger(__file__)

NODE_DTYPE = {
    'user_id':          'int64',
    # 'user_id_str':      'string',
    'screen_name':      'string',
    # 'followers_count':  'int',
    # 'friends_count':    'int',
    # 'listed_count':     'int',
    # 'favourites_count': 'int',
    # 'statuses_count':   'int',
    
    ### Custom columns
    # 'total_tweets':     'int',
    # 'covid_tweets':     'int',
    # 'covid_pct':        'float',
    # 'is_covid':         'bool',
    # 'in_dc':            'float',
    # 'out_dc':           'float',
    'in_d':             'float',
    'out_d':            'float',
}

# %%
def get_nodes_df(tweets_df, users_df):
    nodes_df = tweets_df.groupby('user_id').agg(total_tweets=('user_id', 'size')).join(users_df.set_index('user_id'), how='inner')
    # nodes_df['covid_tweets']    = tweets_df[tweets_df['is_covid'] == True].groupby('user_id').size()
    # nodes_df['is_covid']        = nodes_df['covid_tweets'].transform(lambda x: x > 0)
    # nodes_df['covid_tweets']    = nodes_df['covid_tweets'].fillna(0).astype(int)
    # nodes_df['covid_pct']       = nodes_df['covid_tweets'] / nodes_df['total_tweets']
    nodes_df = nodes_df.join(users_df[['user_id', 'followers_count', 'friends_count']].set_index('user_id').rename(columns={
        'followers_count': 'out_d',
        'friends_count': 'in_d'
    }))
    nodes_df = nodes_df.reset_index(drop=False)
    return nodes_df.astype(NODE_DTYPE)

# %%
def nodes():
    start_time = dt.datetime.now(settings.TZ_INFO)
    
    utils.mkdir(os.path.dirname(settings.NODES_CSV))
    
    logger.info("START - Creating Graph data")
    users_dfs = utils.read_directory_files(settings.CLEAN_USERS_DIR, pd.read_csv, dtype=USER_DTYPE)
    users_df = pd.concat(users_dfs)
    tweets_df = pd.read_csv(settings.CLEAN_TWEETS_CSV, dtype=TWEET_DTYPE)

    logger.info("Creating Nodes df, this may take a while")
    nodes_df = get_nodes_df(tweets_df, users_df)
    nodes_df.to_csv(settings.NODES_CSV, index=False, quoting=csv.QUOTE_NONNUMERIC)
    logger.info("Wrote Nodes df")
    logger.info("Graph nodes saved: {}".format(settings.NODES_CSV))
    
    end_time = dt.datetime.now(settings.TZ_INFO)
    logger.info("END - Done creating Graph data")
    logger.info("Time elapsed: {} min".format(end_time - start_time))


if __name__ == '__main__':
    nodes()
