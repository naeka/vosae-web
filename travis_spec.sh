grunt build-dev
grunt build-spec

python www/manage.py runserver 9999 &
sleep 10

grunt run-spec-travis