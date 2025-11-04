#!/usr/bin/env python

import argparse
import csv

parser = argparse.ArgumentParser(description='Description of your script')
parser.add_argument('-i', dest='input', help='Description of input', required=True)
parser.add_argument('-o', dest='output', help='Description of output', required=True)
args = parser.parse_args()

with open(args.input, 'rt') as fin, open(args.output, 'wt') as fout:
    writer = csv.writer(fout, delimiter="\t")
    writer.writerow(["ensembl_gene_id", "gene_name"])

    seen_genes = set()  # To avoid duplicate gene_id entries

    for line in fin:
        if line.startswith("#"):
                continue
        
        fields = line.strip().split("\t")
        if len(fields) < 9:
                continue
        
        attributes = fields[8]

        # Parse attributes
        attr_dict = {}
        for attr in attributes.strip().split(";"):
            if attr.strip() == "":
                continue
            try:
                key, value = attr.strip().split(" ", 1)
                attr_dict[key] = value.strip('"')
            except ValueError:
                continue
        
        gene_id = attr_dict.get("gene_id")
        gene_name = attr_dict.get("gene_name")

        if gene_id and gene_name and gene_id not in seen_genes:
            writer.writerow([gene_id, gene_name])
            seen_genes.add(gene_id)
