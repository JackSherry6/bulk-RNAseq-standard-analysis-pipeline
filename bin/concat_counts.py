#!/usr/bin/env python

import argparse
import pandas as pd
import csv
import os

parser = argparse.ArgumentParser(description="Merge multiple count files")
parser.add_argument('--counts', nargs='+', help='List of count files to merge', required=True)   # + sign allows multiple filenames 
parser.add_argument('-o', '--out', help='Output filename', required=True)

args = parser.parse_args()

df = pd.DataFrame()
for f in args.counts:
    tsv_data = pd.read_csv(f, sep="\t")
    filename = os.path.splitext(os.path.basename(f))[0]
    col_name = filename.split('.')[0]
    tsv_data.columns = [tsv_data.columns[0], col_name]
    if df.empty:
        df = tsv_data
    else: 
        df = df.merge(tsv_data, on=tsv_data.columns[0], how='outer')

df.to_csv(args.out, index=False)