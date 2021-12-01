from urllib.request import urlopen

def CIRconvert(ids):
    try
        url = 'http://cactus.nci.nih.gov/chemical/structure/'+ids+'/smiles'
        ans = urlopen(url).read().decode('utf8')
        return ans
    except:
        return 'NaN'

    identifiers = ['insert_name_IUPAC_to_list']

for ids in identifiers:
    print ('', CIRconvert(ids),'')


