# -*- coding: utf-8 -*-
"""
Created on Thu Apr  6 13:07:16 2023

@author: LG
"""

import pandas as pd
import os

# set path to domestic visitors folder
domestic_path = (r"C:\Users\LG\Desktop\C5 Input for participants\domestic_visitors")

# set path to foreign visitors folder
foreign_path = (r"C:\Users\LG\Desktop\C5 Input for participants\foreign_visitors")

# create an empty dataframe to store all domestic visitors data
domestic_df = pd.DataFrame()

# loop through all CSV files in domestic visitors folder and append to domestic_df
for file in os.listdir(r"C:\Users\LG\Desktop\C5 Input for participants\domestic_visitors"):
    if file.endswith('foreign_visitors_2016','foreign_visitors_2017','foreign_visitors_2018','foreign_visitors_2019'):
        df = pd.read_csv(domestic_path + file)
        domestic_df = domestic_df.append(df, ignore_index=True)

# create an empty dataframe to store all foreign visitors data
foreign_df = pd.DataFrame()

# loop through all CSV files in foreign visitors folder and append to foreign_df
for file in os.listdir(r"C:\Users\LG\Desktop\C5 Input for participants\foreign_visitors"):
    if file.endswith("domestic_visitors_2019","domestic_visitors_2018","domestic_visitors_2017","domestic_visitors_2016"):
        df = pd.read_csv(foreign_path + file)
        foreign_df = foreign_df.append(df, ignore_index=True)

# filter both dataframes to include data from 2016 to 2019 only
domestic_df = domestic_df[(domestic_df['Year'] >= 2016) & (domestic_df['Year'] <= 2019)]
foreign_df = foreign_df[(foreign_df['Year'] >= 2016) & (foreign_df['Year'] <= 2019)]

# save merged dataframes to CSV files
domestic_df.to_csv('domestic_visitors.csv', index=False)
foreign_df.to_csv('foreign_visitors.csv', index=False)
