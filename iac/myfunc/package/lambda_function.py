import mastodon
from mastodon import Mastodon
import boto3
import os
import random
import re

def lambda_handler(event, context):
    BASE_URL = "https://botsin.space"
    BUCKET_NAME = "movieframebucket"
    keyArray = []
    ssm = boto3.client("ssm")

    # You can use the get_parameter (singular) method here, 
    # I am using multiple params in my other project and was 
    # just re-using code to save time.
    auth_keys = ssm.get_parameters(
        Names=["my_consumer_key"], WithDecryption=True)
    access_token = auth_keys["Parameters"][0]["Value"]

    m = Mastodon(access_token=access_token, api_base_url=BASE_URL)

    s3 = boto3.resource("s3")
    s3bucket = s3.Bucket(BUCKET_NAME)

    try:
        for obj in s3bucket.objects.filter(Prefix="taxi_driver_frames/"):
            # add all frame key values from episode to an array
            keyArray.append("{0}".format(obj.key))
    except Exception as e:
        # If there is an error, raise the exception and stop the function
        raise e

    numFrames = len(keyArray)
    randomFrame = random.randint(0, numFrames)
    KEY = keyArray[randomFrame]
    print("frame from second # " + str(randomFrame))
    s3.Bucket(BUCKET_NAME).download_file(KEY, "/tmp/local.jpg")
    
    random_objectNumber = re.search(r'\d+', KEY).group()
    time_in_seconds = int(random_objectNumber)
    minutes, seconds = divmod(time_in_seconds, 60)
    hours, minutes = divmod(minutes, 60)
    time_format = "{:02d}:{:02d}:{:02d}".format(hours, minutes, seconds)
    frameInfo = "Taxi Driver | {:02d}:{:02d}:{:02d}".format(hours, minutes, seconds)

    # We have to first create a media ID when uploading an image
    media = m.media_post("/tmp/local.jpg")
    # Then we can reference this media ID in our status post
    m.status_post(status=frameInfo, media_ids=media)


    os.remove("/tmp/local.jpg")
    return None