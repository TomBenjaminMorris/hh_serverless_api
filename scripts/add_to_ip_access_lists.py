import json
import os

#IP ranges available at https://ip-ranges.amazonaws.com/ip-ranges.json

with open('aws_ip_list.json') as f:
    d = json.load(f)
    for i in d['prefixes']:
      if 'ip_prefix' in i:
        if i['region'] == "eu-west-2":
          #os.system('atlas accessLists create {} --comment "Created using Atlas CLI"'.format(i['ip_prefix']))
          os.system('atlas accessLists delete {} --force'.format(i['ip_prefix']))
