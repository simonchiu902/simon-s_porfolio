# Import libraries
import numpy as np
import pandas as pd
import string
import re
import gensim
import nltk
# from autocorrect import Speller

stop_list = nltk.corpus.stopwords.words('english')
stemmer = nltk.stem.porter.PorterStemmer()
# spell = Speller(lang='en')

def clean_text(text, LLM = False):
    text = re.sub(r'https?://\S+', '', text) # remove link
    text = re.sub(r'@[A-Za-z0-9_]+', '', text)         # remove @mentions
    text = re.sub(r'\n',' ', text)           # remove line breaks
    text = re.sub('\s+', ' ', text).strip()  # remove leading, trailing, and extra spaces
    text = re.sub(r'#', '', text)  # remove # from hashtag
    text = re.sub(r'[^\x00-\x7F]+', ' ', text)#remove non-ASCII characters
    if not LLM:
        text = nltk.word_tokenize(text) # tokenize text
        text = [t.lower() for t in text] # change words into lower case
        text = [t for t in text if re.search('^[a-z]+$', t)] # only include alphabetic words
        # text = [spell(t) for t in text]
        text = [t for t in text if t not in stop_list] # remove stop words
        text = [stemmer.stem(t) for t in text] # steeming words
    return text





def process_text(df, LLM = False):   
    df1 = df.copy()
    df1['text_clean'] = df1['text'].apply(lambda x: clean_text(x,LLM))
    if LLM:        
        return df1
    else:
        df1['text_clean_string'] = df1['text_clean'].apply(lambda x: " ".join(x))
        return df1
