# Import libraries
import numpy as np
import pandas as pd
import string
import re
import gensim
import nltk

stop_list = nltk.corpus.stopwords.words('english')
stemmer = nltk.stem.porter.PorterStemmer()

def clean_text(text):
    text = re.sub(r'https?://\S+', '', text) # remove link
    text = re.sub(r'\n',' ', text)           # remove line breaks
    text = re.sub('\s+', ' ', text).strip()  # remove leading, trailing, and extra spaces
    text = re.sub(r'#', '', text)  # remove # from hashtag
    text = nltk.word_tokenize(text) # tokenize text
    text = [t.lower() for t in text] # change words into lower case
    text = [t for t in text if re.search('^[a-z]+$', t)] # only include alphabetic words
    text = [t for t in text if t not in stop_list] # remove stop words
    text = [stemmer.stem(t) for t in text] # steeming words
    return text





def process_text(df):   
    df['text_clean'] = df['text'].apply(lambda x: clean_text(x))
    df['text_clean_string'] = df['text_clean'].apply(lambda x: " ".join(x))
    return df
