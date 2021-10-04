#!bin/bash

bundle install

API_KEY=c2623c04dcd24d138824a8d8c8177446

if [! -f ./storage/dataBase/accounts.json]
then
	touch ./storage/dataBase/accounts.json
	echo [] > ./storage/dataBase/accounts.json
fi

if [! -f ./storage/dataBase/orders.json]
then
	touch ./storage/dataBase/orders.json
	echo [] > ./storage/dataBase/orders.json
fi

if [! -f ./storage/dataBase/services.json]
then
	touch ./storage/dataBase/services.json
	echo [] > ./storage/dataBase/services.json
fi

if [! -f ./.env]
then
	touch ./.env
	echo $API_KEY > ./.env
fi

ruby index.rb
