if [[ $DEBUG == false ]]; then
    ROOT_DIR=/srv/milky/twitter_scraper
else
    ROOT_DIR=/home/milky/infocov/twitter_scraper
fi

DATA_DIR=${ROOT_DIR}/data
LOGS_DIR=${ROOT_DIR}/logs

INPUT_DIR=${DATA_DIR}/input
INPUT_HISTORY_DIR=${INPUT_DIR}/history
INPUT_LOCATIONS_DIR=${INPUT_DIR}/locations
INPUT_STOP_WORDS_DIR=${INPUT_DIR}/stop_words
INPUT_LOOKUPS_DIR=${INPUT_DIR}/lookups

OUTPUT_DIR=${DATA_DIR}/output
# PROCESSED_DIR=${DATA_DIR}/processed

ROOT_INPUT_BASELINE=${INPUT_DIR}/baseline-user-ids.json
# ROOT_INPUT_PROCESSED_USER_IDS=${INPUT_DIR}/processed-user-ids.json
# ROOT_INPUT_MISSING_USER_IDS=${INPUT_DIR}/missing-user-ids.json
# ROOT_INPUT_PROCESSED_USER_OBJS=${INPUT_DIR}/processed-user-objs.json
# ROOT_INPUT_MAX_TWEET_IDS=${INPUT_DIR}/max-tweet-ids.json

ROOT_INPUT_SENTIMENT=${INPUT_LOOKUPS_DIR}/sentiment-lookup.csv
ROOT_INPUT_LOCATIONS_HR=${INPUT_DIR}/locations/hr.json
ROOT_INPUT_STOP_WORDS_HR=${INPUT_STOP_WORDS_DIR}/hr.json
ROOT_INPUT_STOP_WORDS_EN=${INPUT_STOP_WORDS_DIR}/en.json

## Scrape
SCRAPE_DIR=${OUTPUT_DIR}/scrape
# Scrape tweets
SCRAPE_TWEETS_DIR=${SCRAPE_DIR}/tweets
# Scrape Users
SCRAPE_USERS_DIR=${SCRAPE_DIR}/users
SCRAPE_USERS_IDS_DIR=${SCRAPE_USERS_DIR}/ids
SCRAPE_USERS_OBJS_DIR=${SCRAPE_USERS_DIR}/objs

# SCRAPE_PROCESSED_DIR=${PROCESSED_DIR}/scrape
# SCRAPE_PROCESSED_USERS_DIR=${PROCESSED_DIR}/scrape/users/
# SCRAPE_PROCESSED_TWEETS_DIR=${PROCESSED_DIR}/scrape/tweets

## Clean
CLEAN_DIR=${OUTPUT_DIR}/clean
# Clean Tweets
CLEAN_TWEETS_DIR=${CLEAN_DIR}/tweets
# Clean Users
CLEAN_USERS_DIR=${CLEAN_DIR}/users

# CLEAN_PROCESSED_DIR=${PROCESSED_DIR}/clean
# CLEAN_PROCESSED_USERS_DIR=${PROCESSED_DIR}/clean/users/
# CLEAN_PROCESSED_TWEETS_DIR=${PROCESSED_DIR}/clean/tweets

## Graph
GRAPH_DIR=${OUTPUT_DIR}/graph

## Text
TEXT_DIR=${OUTPUT_DIR}/text


[ ! -d $ROOT_DIR ]              && mkdir $ROOT_DIR
echo "Created $ROOT_DIR"
[ ! -d $DATA_DIR ]              && mkdir $DATA_DIR
echo "Created $DATA_DIR"
[ ! -d $LOGS_DIR ]              && mkdir $LOGS_DIR
echo "Created $LOGS_DIR"

# Input
[ ! -d $INPUT_DIR ]             && mkdir $INPUT_DIR
echo "Created $INPUT_DIR"
[ ! -d $INPUT_HISTORY_DIR ]     && mkdir $INPUT_HISTORY_DIR
echo "Created $INPUT_HISTORY_DIR"
[ ! -d $INPUT_LOCATIONS_DIR ]   && mkdir $INPUT_LOCATIONS_DIR
echo "Created $INPUT_LOCATIONS_DIR"
[ ! -d $INPUT_STOP_WORDS_DIR ]  && mkdir $INPUT_STOP_WORDS_DIR
echo "Created $INPUT_STOP_WORDS_DIR"
[ ! -d $INPUT_LOOKUPS_DIR ]     && mkdir $INPUT_LOOKUPS_DIR
echo "Created $INPUT_LOOKUPS_DIR"

# Output
[ ! -d $OUTPUT_DIR ]            && mkdir $OUTPUT_DIR
echo "Created $OUTPUT_DIR"
# [ ! -d $PROCESSED_DIR ]         && mkdir $PROCESSED_DIR
# echo "Created $PROCESSED_DIR"

[ ! -d $SCRAPE_DIR ]            && mkdir $SCRAPE_DIR
echo "Created $SCRAPE_DIR"
[ ! -d $SCRAPE_TWEETS_DIR ]     && mkdir $SCRAPE_TWEETS_DIR
echo "Created $SCRAPE_TWEETS_DIR"
[ ! -d $SCRAPE_USERS_DIR ]      && mkdir $SCRAPE_USERS_DIR
echo "Created $SCRAPE_USERS_DIR"
[ ! -d $SCRAPE_USERS_IDS_DIR ]  && mkdir $SCRAPE_USERS_IDS_DIR
echo "Created $SCRAPE_USERS_IDS_DIR"
[ ! -d $SCRAPE_USERS_OBJS_DIR ] && mkdir $SCRAPE_USERS_OBJS_DIR
echo "Created $SCRAPE_USERS_OBJS_DIR"
# [ ! -d $SCRAPE_PROCESSED_DIR ] && mkdir $SCRAPE_PROCESSED_DIR
# echo "Created $SCRAPE_PROCESSED_DIR"
[ ! -d $SCRAPE_PROCESSED_USERS_DIR ] && mkdir $SCRAPE_PROCESSED_USERS_DIR
echo "Created $SCRAPE_PROCESSED_USERS_DIR"
[ ! -d $SCRAPE_PROCESSED_TWEETS_DIR ] && mkdir $SCRAPE_PROCESSED_TWEETS_DIR
echo "Created $SCRAPE_PROCESSED_TWEETS_DIR"

[ ! -d $CLEAN_DIR ]             && mkdir $CLEAN_DIR
echo "Created $CLEAN_DIR"
[ ! -d $CLEAN_USERS_DIR ]       && mkdir $CLEAN_USERS_DIR
echo "Created $CLEAN_USERS_DIR"
[ ! -d $CLEAN_TWEETS_DIR ]      && mkdir $CLEAN_TWEETS_DIR
echo "Created $CLEAN_TWEETS_DIR"
[ ! -d $GRAPH_DIR ]             && mkdir $GRAPH_DIR
# [ ! -d $CLEAN_PROCESSED_DIR ] && mkdir $CLEAN_PROCESSED_DIR
# echo "Created $CLEAN_PROCESSED_DIR"
[ ! -d $CLEAN_PROCESSED_USERS_DIR ] && mkdir $CLEAN_PROCESSED_USERS_DIR
echo "Created $CLEAN_PROCESSED_USERS_DIR"
[ ! -d $CLEAN_PROCESSED_TWEETS_DIR ] && mkdir $CLEAN_PROCESSED_TWEETS_DIR
echo "Created $CLEAN_PROCESSED_TWEETS_DIR"
echo "Created $GRAPH_DIR"
[ ! -d $TEXT_DIR ]            && mkdir $TEXT_DIR
echo "Created $TEXT_DIR"


DEBUG_DIR=/home/milky/infocov/twitter_scraper

DEBUG_DATA_DIR=${DEBUG_DIR}/data
DEBUG_INPUT_BASELINE=${DEBUG_DATA_DIR}/input/baseline-user-ids.json
# DEBUG_INPUT_PROCESSED_USER_IDS=${DEBUG_DATA_DIR}/input/processed-user-ids.json
# DEBUG_INPUT_MISSING_USER_IDS=${DEBUG_DATA_DIR}/input/missing-user-ids.json
# DEBUG_INPUT_PROCESSED_USER_OBJS=${DEBUG_DATA_DIR}/input/processed-user-objs.json
# DEBUG_INPUT_MAX_TWEET_IDS=${DEBUG_DATA_DIR}/input/max-tweet-ids.json

DEBUG_INPUT_SENTIMENT=${DEBUG_DATA_DIR}/input/lookups/sentiment-lookup.csv
DEBUG_INPUT_LOCATIONS_HR=${DEBUG_DATA_DIR}/input/locations/hr.json
DEBUG_INPUT_STOP_WORDS_HR=${DEBUG_DATA_DIR}/input/stop_words/hr.json
DEBUG_INPUT_STOP_WORDS_EN=${DEBUG_DATA_DIR}/input/stop_words/en.json

cp $DEBUG_INPUT_BASELINE                $ROOT_INPUT_BASELINE
echo "Copied $ROOT_INPUT_BASELINE"
# cp $DEBUG_INPUT_PROCESSED_USER_IDS      $ROOT_INPUT_PROCESSED_USER_IDS
# echo "Copied $ROOT_INPUT_PROCESSED_USER_IDS"
# cp $DEBUG_INPUT_MISSING_USER_IDS        $ROOT_INPUT_MISSING_USER_IDS
# echo "Copied $ROOT_INPUT_MISSING_USER_IDS"
# cp $DEBUG_INPUT_PROCESSED_USER_OBJS     $ROOT_INPUT_PROCESSED_USER_OBJS
# echo "Copied $ROOT_INPUT_PROCESSED_USER_OBJS"
# cp $DEBUG_INPUT_MAX_TWEET_IDS           $ROOT_INPUT_MAX_TWEET_IDS
# echo "Copied $ROOT_INPUT_MAX_TWEET_IDS"

cp $DEBUG_INPUT_SENTIMENT               $ROOT_INPUT_SENTIMENT
echo "Copied $DEBUG_INPUT_SENTIMENT"
cp $DEBUG_INPUT_LOCATIONS_HR            $ROOT_INPUT_LOCATIONS_HR
echo "Copied $ROOT_INPUT_LOCATIONS_HR"
cp $DEBUG_INPUT_STOP_WORDS_HR           $ROOT_INPUT_STOP_WORDS_HR
echo "Copied $ROOT_INPUT_STOP_WORDS_HR"
cp $DEBUG_INPUT_STOP_WORDS_EN           $ROOT_INPUT_STOP_WORDS_EN
echo "Copied $ROOT_INPUT_STOP_WORDS_EN"