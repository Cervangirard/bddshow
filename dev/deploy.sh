# local deploymenet

docker network create db

docker run  -p 5432:5432 -d --name postgis --net db -e POSTGRES_USER="cervan" POSTGRES_PASSWORD="ok" postgis/postgis

docker run -e PORT_POSTGIS=5432 -e HOST_POSTGIS=postgis -e USER_POSTGIS="cervan" -e PASSWORD_POSTGIS="ok" -e NAME_BDD_POSTGIS=itdd -p 3838:3838 --name shinybdd --net db -d shinybdd && sleep 2 && open http://localhost:3838

