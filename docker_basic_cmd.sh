# To perform a complete prune, including all unused data and volumes
docker system prune -a --volumes -f

# specify a project name explicitly using the -p flag when running docker-compose 
docker-compose -p my_project_name up
# run in detached mode
docker-compose -p up -d
