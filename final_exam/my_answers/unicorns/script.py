#!/usr/bin/python

import networkx as nx
import matplotlib.pyplot as plt
import pandas as pd
import time
from operator import itemgetter

UNICORNS = '../../unicorns/unicorns.tsv'
FUTURE_UNICORNS = '../../unicorns/future_unicorns.tsv'
INVESTORS = '../../unicorns/investors_in_unicorns.tsv'
FUTURE_INVESTORS = '../../unicorns/investors_in_future_unicorns.tsv'
CRUNCHBASE_COMPANIES = '../../unicorns/companies.csv'
CRUNCHBASE_INVESTORS = '../../unicorns/investments.csv'

def display_graph_info(graph):
    # print(graph.number_of_nodes(), "nodes")
    # print(graph.number_of_edges(), "edges")
    # print(nx.number_connected_components(graph), "connected components")
    # degree_seq = nx.degree(graph)
    # degrees = sorted(degree_seq.items(), key=itemgetter(1), reverse=True)
    # print("degree distribution top 10")
    # for i in range(0, 10): print(degrees[i])

    # ec = nx.eigenvector_centrality(graph)
    # ec = sorted(ec.items(), key=itemgetter(1), reverse=True)
    # print("eigenvector centrality top 10")
    # for i in range(0, 10): print(ec[i])

    # largest_component = max(nx.connected_component_subgraphs(graph), key=len)
    # print("diameter of largest component:", nx.diameter(largest_component))

    cl = nx.clustering(graph)
    print("clustering coefficient:", sum(cl.values()) / len(cl))

def plot_graph(graph):
    plt.figure(figsize=(20,12))
    pos = nx.fruchterman_reingold_layout(graph)
    nx.draw_networkx_nodes(graph, pos, node_size=70)
    nx.draw_networkx_edges(graph, pos, edgelist=[(u,v) for (u,v,d) in graph.edges(data=True)], width=0.25, edge_color="m", alpha=0.3)
    nx.draw_networkx_labels(graph, pos, font_size=7, font_family='sans-serif', font_color="b", alpha=0.2)
    plt.axis('off')
    plt.show()

def main():
    # # graph 1
    # start_time = time.time()
    # print("processing graph 1")
    # investor_table = pd.read_csv(INVESTORS, sep='\t', usecols=[0,1]) # only get useful columns
    # # print(investor_table.head())
    # companies = set()
    # investors = dict()
    # for _, row in investor_table.iterrows():
    #     companies.add(row['Company'])
    #     if row['Investor'] not in investors:
    #         investors[row['Investor']] = set()
    #     investors[row['Investor']].add(row['Company'])
    # graph1 = nx.Graph()
    # graph1.add_nodes_from(companies)
    # for comps in investors.values():
    #     if len(comps) > 1:
    #         for c in comps:
    #             for c2 in comps:
    #                 if(c != c2):
    #                     graph1.add_edge(c, c2)

    # display_graph_info(graph1)
    # print("graph 1 time taken:", time.time()-start_time, "seconds")
    # plot_graph(graph1)

    # # graph 2
    # start_time = time.time()
    # print("processing graph 2")
    # future_investor_table = pd.read_csv(FUTURE_INVESTORS, sep='\t', usecols=[0,1])
    # for _, row in future_investor_table.iterrows():
    #     companies.add(row['Company'])
    #     if row['Investor'] not in investors:
    #         investors[row['Investor']] = set()
    #     investors[row['Investor']].add(row['Company'])
    # graph2 = nx.Graph()
    # graph2.add_nodes_from(companies)
    # for comps in investors.values():
    #     if len(comps) > 1:
    #         for c in comps:
    #             for c2 in comps:
    #                 if(c != c2):
    #                     graph2.add_edge(c, c2)

    # display_graph_info(graph2)
    # print("graph 2 time taken:", time.time()-start_time, "seconds")
    # plot_graph(graph2)

    # graph 3
    start_time = time.time()
    print("processing graph 3")
    crunchbase_investor_table = pd.read_csv(CRUNCHBASE_INVESTORS, sep=',', usecols=['company_name', 'investor_name'])
    companies = set()
    investors = dict()
    for _, row in crunchbase_investor_table.iterrows():
        companies.add(row['company_name'])
        if row['investor_name'] not in investors:
            investors[row['investor_name']] = set()
        investors[row['investor_name']].add(row['company_name'])
    graph3 = nx.Graph()
    graph3.add_nodes_from(companies)
    for comps in investors.values():
        if len(comps) > 1:
            for c in comps:
                for c2 in comps:
                    if(c != c2):
                        graph3.add_edge(c, c2)

    display_graph_info(graph3)
    print("graph 3 time taken:", time.time()-start_time, "seconds")
    # plot_graph(graph3)

if __name__ == '__main__':
    main()
