#!/usr/bin/env bash

#default test

echo 'Default test'
echo 'Test 1'
./cerca.py --key '["parc","musica"]'
echo 'Test 2'
./cerca.py --key '({"location":"horta"},{"name":["musica","parc"]})'
echo 'Test 3'
./cerca.py --key '["horta",{"name":"parc","content":"música"}]'
echo 'Test 4'
./cerca.py --key '"parc"'

echo 'Testing language'
echo 'Test 5'
./cerca.py --key '["parc","musica"]' --lan es
echo 'Test 6'
./cerca.py --key '({"location":"horta"},{"name":["musica","parc"]})' --lan en
echo 'Test 7'
./cerca.py --key '["horta",{"name":"parc","content":"música"}]' --lan fr
echo 'Test 8'
./cerca.py --key '"parc"' --lan cat

