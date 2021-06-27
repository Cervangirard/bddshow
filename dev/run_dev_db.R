## launching Postgre
pkgload::load_all()



system(intern = TRUE,
       'docker run  -p 5432:5432 -d --name postgres --net host -v /home/cervan/database:/var/lib/postgresql/data -e POSTGRES_DB="rr2021" -e POSTGRES_USER="cervan" -e POSTGRES_PASSWORD="ok" postgres' 
)

config <- list(dbname = Sys.getenv("NAME_BDD","rr2021"),
               host = Sys.getenv("HOST","127.0.0.1"),
               port = Sys.getenv("PORT",5432),
               user = Sys.getenv("USER","cervan"),
               password = Sys.getenv("PASSWORD","ok"))
connect <- connect_db(config$dbname,
           config$host,
           config$port,
           config$user,
           config$password)
if(!connect$connect){
  stop("pas de connection à la base")
}
