grunt build-dev
grunt spec

python www/manage.py runserver 9999 &
sleep 10

./run_jasmine.coffee http://127.0.0.1:9999/spec/