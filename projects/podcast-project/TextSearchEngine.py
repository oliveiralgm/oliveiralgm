import os
from whoosh.index import create_in
from whoosh.fields import Schema, TEXT, ID
from whoosh.qparser import QueryParser
from whoosh import index
from whoosh import scoring
from whoosh.index import open_dir
import sys


#def createSearchableData(root):
'''
Schema definition: title(name of file), path(as ID), content(indexed
but not stored),textdata (stored text content)
'''
schema = Schema(title=TEXT(stored=True), path=ID(stored=True),
                content=TEXT(stored=True))
if not os.path.exists("indexdir"):
    os.mkdir("indexdir")

# Creating a index writer to add document as per schema
ix = index.create_in("indexdir", schema)
ix = index.open_dir("indexdir")
writer = ix.writer()

# writer.add_document(title=u"My document", content=u"This is my document!",
# path=u"/a")
# writer.add_document(title=u"My document1", content=u"This is my document dog!",
# path=u"/a")
# writer.add_document(title=u"My document2", content=u"This is my document cat!",
# path=u"/a")
# writer.add_document(title=u"My document3", content=u"This is my document dog and cat!",
# path=u"/a")
#
# writer.commit()

root = "corpus"

filepaths = [os.path.join(root, i) for i in os.listdir(root)]
for path in filepaths:
    fp = open(path, 'r', encoding="ISO-8859-1")
    print(path)
    text = fp.read()
    writer.add_document(title=path.split("/")[1], path=path, content=text)
    fp.close()
writer.commit()


# root = "corpus"
#createSearchableData(root)



ix = open_dir("indexdir")
print("Type what do you want to search:")
query1 = input()
# query_str is query string
# query_str = sys.argv[1]

query_str = query1
print("How many documents do you want to show?")
# Top 'n' documents as result
topN = int(input())

# topN = int(sys.argv[2])



with ix.searcher() as searcher:
    query = QueryParser("content", schema=ix.schema)
    q = query.parse(query_str)
    results = searcher.search(q, limit=topN)
    results.fragmenter.surround = 1000
    #my_cf = highlights.ContextFragmenter(maxchars=100, surround=60)
    result_index = 1
    for hit in results:
        #print(len(hit))

        print("Result: " + str(result_index))
        print("Title: " + hit['title'])
        print(" ")
        #print(hit['content'])
        hitstemp = hit.highlights('content', top=10)
        parsedHits = hitstemp.split("...")
        parsedHitsIndex = 1
        for hits in parsedHits:
            print("Result " + str(parsedHitsIndex) + ":  " + hits)
            print(" ")
            parsedHitsIndex = parsedHitsIndex + 1
        result_index = result_index + 1
    # for i in range(topN):
    #     print(results[i]['title'], results[i].highlights('content'))