#!/usr/bin/python3           
from math import radians, cos, sin, asin, sqrt, pi
from datetime import datetime, timedelta

import sys
import argparse 
import unicodedata
import ast
import os
import re
import xml.etree.ElementTree as ET
import urllib.request as url

languages = {'cat': 'http://www.bcn.cat/tercerlloc/pits_opendata.xml',
             'es': 'http://www.bcn.cat/tercerlloc/pits_opendata_es.xml',
             'en': 'http://www.bcn.cat/tercerlloc/pits_opendata_en.xml',
             'fr': 'http://www.bcn.cat/tercerlloc/pits_opendata_fr.xml'
            }  

ref_lan = {'cat': ['Nom', 'Tipus', 'Descripció', 'Direcció', 'Bicing[lliure]', 'Bicing[per agafar]',
                   'Telèfon', 'Punts d\'interés', 'Estacions de bicing'],
           'es': ['Nombre', 'Tipo', 'Descripción', 'Dirección', 'Bicing[libre]', 'Bicing[para coger]',
                  'Teléfono', 'Puntos de interés', 'Estaciones de bicing'],
           'en': ['Name','Type','Description', 'Address', 'Bicing[free]','Bicing[for taking]',
                  'Phone','Interest points', 'Bicing stations'],
           'fr': ['Nom','Type','Description', 'Adresse', 'Bicing[libre]','Bicing[apporter]',
                  'Téléphone','Points d\'intérêt', 'Bicing stations']
          }
URL_STATIONS = 'http://wservice.viabicing.cat/v1/getstations.php?v=1'


def distance(lon1: float, lat1: float, lon2: float, lat2: float) -> float:
    lon1, lat1, lon2, lat2 = map(radians, [lon1, lat1, lon2, lat2])
    dlon = lon2 - lon1
    dlat = lat2 - lat1
    a = sin(dlat / 2) ** 2 + cos(lat1) * cos(lat2) * sin(dlon / 2) ** 2
    return (6367 * 2 * asin(sqrt(a))) * 1000
    
    
def remove_accents(input_str: str) -> str:
    nfkd_form = unicodedata.normalize('NFKD', input_str.casefold())
    return u"".join([c for c in nfkd_form if not unicodedata.combining(c)])


#creating the arguments' parser
def get_arguments_parser():
    argumentparser = argparse.ArgumentParser()
    argumentparser.add_argument('--lan', default='cat')
    argumentparser.add_argument('--key', required = True)
    return argumentparser.parse_args()


def get_lan(parser):
    return parser.lan


def get_query(parser):
    try:
        return ast.literal_eval(remove_accents(parser.key)) if parser.key else []
    except (ValueError, SyntaxError):
        print('ERROR PARSING ARGUMENTS')
        quit()


#getting xml of the stations
def get_stations_xml():
    try:
        wpage = url.urlopen(URL_STATIONS) 
        xmlstations = wpage.read().decode('utf-8')
        wpage.close()
        return ET.fromstring(xmlstations) 
    except url.URLError:
        print('CONNECTION ERROR')
        quit()


#getting xml of the interest points
def get_interest_points_xml(language):
    try:
        url_lan = languages[language]
        wpage = url.urlopen(url_lan)
        xmlinteres = wpage.read().decode('utf-8')
        wpage.close()
        return ET.fromstring(xmlinteres)
    except url.URLError:
        print('CONNECTION ERROR')
        quit()

class Station(object):
    def __init__(self, id, lat, lon, street, num, height, slots, bikes):
        self.id = id
        self.latitud = float(lat)
        self.longitud = float(lon)
        self.street = street
        self.num = num
        self.height = height
        self.slots = int(slots)
        self.bikes =int(bikes)
        self.distance = 0

    @staticmethod
    def get_stations():
        root = get_stations_xml()
        stations = []
        for station in root.findall('station'):
            try:
                station = Station(station.find('id').text, station.find('lat').text, station.find('long').text, 
                                  station.find('street').text, station.find('streetNumber').text, station.find('height').text, station.find('slots').text, station.find('bikes').text)
                stations.append(station)
            except AttributeError:
                pass
        return stations
    

class InterestPoint(object):
    def __init__(self, district, barri, lat, lon, addr, name, phone, tipus, long_desc, short_desc):
        self.district = district
        self.barri = barri
        self.latitud = float(lat)
        self.longitud = float(lon)
        self.address = addr
        self.name = name
        self.phone = phone
        self.tipus = tipus 
        self.content = long_desc
        self.short_description = short_desc
        

    @classmethod
    def get_interest_points(cls, language, query):
        root = get_interest_points_xml(language)
        interest_points = []
        for ip in root.find('list_items').iter('row'):
            try:
                inp = InterestPoint(ip.find('addresses').find('item').find('district').text,
                                    ip.find('addresses').find('item').find('barri').text, ip.find('gmapx').text,
                                    ip.find('gmapy').text, ip.find('addresses').find('item').find('address').text,
                                    ip.find('name').text, ip.find('phonenumber').text, ip.find('type').text,
                                    ip.find('content').text, ip.find('custom_fields').find('descripcio-curta-pics').text)
                interest_points.append(inp)
            except AttributeError:
                pass
        return cls.interpret_query(interest_points, query)

    
    @classmethod
    def zipping(cls, l): #no funciona
        s = set(l[0])
        for i in range(1,len(l)):
            if l[i][0] == 1:
                return []
            s = s & set(l[i])
        return list(s)
    
    
    @classmethod
    def search_in(cls, query, param): #funciona
        if isinstance(query, tuple):
            for x in query:
                regex = re.compile(r'\b%s\b' % remove_accents(x))
                s = set(map(lambda x: regex.search(remove_accents(x)) != None,param)) 
                if (len(s) == 1 and False in s) or len(s) == 2:
                    return False
            return True
        elif isinstance(query, list):
            return True in list(map(lambda x: any(re.search(r'\b%s\b' % remove_accents(y),remove_accents(x)) for y in query), param))
        else:
            return any(re.search(r'\b%s\b' % remove_accents(query), remove_accents(x)) for x in param) 

    
    @classmethod
    def interpret_query(cls, interest_points, query):
        if isinstance(query, str): #funciona
            regex = re.compile(r'\b%s\b' % remove_accents(query))
            return list(filter(lambda x:
                                   regex.search(remove_accents(x.name)) != None or
                                   regex.search(remove_accents(x.address)) != None or
                                   regex.search(remove_accents(x.district)) != None or
                                   regex.search(remove_accents(x.barri)) != None, interest_points))
        elif isinstance(query, tuple) and len(query) > 0: #funciona
            return list(set(cls.interpret_query(interest_points, query[0])) & set(cls.interpret_query(interest_points, query[1:])))
        elif isinstance(query, list) and len(query) > 0:
            return list(set(cls.interpret_query(interest_points, query[0])) | set(cls.interpret_query(interest_points, query[1:])))
            #return cls.interpret_query(cls.interpret_query(interest_points, query[1:]), query[0])
        elif isinstance(query, dict): #funciona
            l1 = list()
            if 'name' in query.keys():
                l1 = list(filter(lambda x: cls.search_in(query['name'], [x.name]), interest_points))
                l1 = l1 if len(l1) != 0 else [1]
            
            l2 = list()
            if 'location' in query.keys():
                l2 = list(filter(lambda x: cls.search_in(query['location'],
                                                         [x.barri, x.address, x.district]), interest_points))
                l2 = l2 if len(l2) != 0 else [1]
        
            l3 = list()
            if 'content' in query.keys():
                l3 = list(filter(lambda x: cls.search_in(query['content'], [x.content]), interest_points))
                l3 = l3 if len(l3) != 0 else [1]

            alls = list(filter(lambda x: len(x) > 0, [l1, l2, l3]))
            return cls.zipping(alls) if len(alls) > 0 else []      
        else: 
            return interest_points if not isinstance(query,list) else []

    
class MyPoints:
    def __init__(self, stations, interest_points):
        self.all_stations = stations
        self.all_points = interest_points   
        

    @classmethod
    def print_header(self, query):
        return  '<html>' \
                '<head>' \
                '<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">' \
                '<meta charset="UTF-8">' \
                '<title> Query: \'{}\'</title>' \
                '</head>' \
                '<body>' \
                '<div class="container">' \
                '<h1>Query \'{}\':</h1><br>'.format(query, query)
    
    
    @classmethod
    def headers_table(cls, language):
        return  '<table class="table table-bordered table-hover">' \
                '<caption> {} </caption>' \
                '<tr>' \
                '<td><strong> {} </strong></td>' \
                '<td><strong> {} </strong></td>' \
                '<td><strong> {} </strong></td>' \
                '<td><strong> {} </strong></td>' \
                '<td><strong> {} </strong></td>' \
                '</tr>'.format(ref_lan[language][7], ref_lan[language][0], ref_lan[language][1], ref_lan[language][2], ref_lan[language][3], ref_lan[language][6])
            
            
    @classmethod
    def add_points(cls, stations, interest_points):
        s = ""
        for ip in interest_points:
            s += '<tr>' \
                    '<td> {} </td>' \
                    '<td> {} </td>' \
                    '<td> {} </td>' \
                    '<td>' \
                        '<li style="list-style-type:none"> {} </li>' \
                        '<li style="list-style-type:none"> {} </li>' \
                        '<li style="list-style-type:none"> {} </li>' \
                    '</td>' \
                    '<td> {} </td>' \
                '</tr>'.format(ip.name, ip.tipus, ip.content if len(interest_points) == 1 else 
                               ip.short_description,ip.address, ip.district, ip.barri, ip.phone)
        return s + '</table>'
        
        
    @classmethod
    def add_header_table2(cls, language):
        return '<table class="table table-bordered table-hover">' \
               '<caption> {} </caption>' \
               '<tr>' \
                    '<td><strong> {} </strong></td>' \
                    '<td><strong> {} </strong></td>' \
                    '<td><strong> {} </strong></td>' \
               '</tr>'.format(ref_lan[language][8], ref_lan[language][0], ref_lan[language][4], ref_lan[language][5])
    
    
    @classmethod
    def sort_stations(cls, stations, interest_point):
        for i in stations:
            i.distance = distance(interest_point.longitud, interest_point.latitud, i.longitud, i.latitud)
        stations = list(filter(lambda x: x.distance <= 500, stations))
        return sorted(stations, key=lambda x: x.distance)     

    
    @classmethod
    def sort_by_slot(cls, stations):
        #print(len(station))
        return list(filter(lambda x: x.slots > 0, stations))[:5]
    
    
    @classmethod
    def sort_by_bikes(cls, stations):
        #print(len(station))
        return list(filter(lambda x: x.bikes > 0, stations))[:5]

    @classmethod
    def add_stations(cls, language, stations, interest_points):
        s = ''
        for ip in interest_points:
            st = cls.sort_stations(stations, ip)
            slots = cls.sort_by_slot(st)
            bikes = cls.sort_by_bikes(st)
            s += '<tr><td> {} </td><td>'.format(ip.name) 
            for i in range(len(slots)):
                s += '<li style="list-style-type:none"> {} </li>' \
                     '<li style="list-style-type:none"> Slots: {} </li>' \
                     '<li style="list-style-type:none"> Bikes: {} </li>'.format(slots[i].street, slots[i].slots, slots[i].bikes )
                s += '<BR>' if i != len(slots) - 1 else ''
            s += '</td><td>'

            for i in range(len(bikes)):
                s += '<li style="list-style-type:none"> {} </li>' \
                     '<li style="list-style-type:none"> Slots: {} </li>' \
                     '<li style="list-style-type:none"> Bikes: {} </li>'.format(bikes[i].street, bikes[i].slots, bikes[i].bikes)
                s += '<BR>' if i != len(slots) - 1 else ''
            s += '</td></tr>'
        return s + '</table>' 
            
    @classmethod
    def print_footer(cls):
        return '</div></body></html>'
    

    @classmethod
    def create_html(cls, stations, interest_points, query, language):
        yield cls.print_header(query)
        yield cls.headers_table(language)
        yield cls.add_points(stations, interest_points)
        yield cls.add_header_table2(language)
        yield cls.add_stations(language, stations, interest_points)
        yield cls.print_footer()
    

def main():
    parser = get_arguments_parser()
    language = get_lan(parser)
    print('Getting stations...')
    stations = Station.get_stations()
    
    print('Getting interest points...')
    query = get_query(parser)
    interest_points = InterestPoint.get_interest_points(language, query)
    print('Creating HTML..')
    html = '\n'.join(MyPoints.create_html(stations, interest_points, query, language)) 
    
    print('Saving to disk...')
    if not os.path.exists(os.path.dirname("out/")):
        os.makedirs(os.path.dirname("out/"))
    with open("out/{}.html".format(datetime.now()), "w") as out_file:
        print(html, file=out_file)
    print('FINISH')

if __name__ == '__main__':
    main()