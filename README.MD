## Requirements
1. Install Docker CLI
2. Recommend creating a virtual env for local development outside of docker
    1. `python3 -m venv myvenv`
    2. `source myvenv/bin/activate`  or `myvenv\Scripts\activate` for windows
    3. `pip install -r requirements.txt`

## Set Up
1. `git clone https://github.com/phansiri/innovation_challenge_testing.git`
2. `cd root directory`
3. Create `.env` in the `iiimef_project` directory with something like:
```.env
DJ_SECRET_KEY=super-secret-key
DJ_ALLOWED_HOSTS=localhost 127.0.0.1 [::1] 0.0.0.0
DJ_DEBUG=True
```
4. go back to the root directory with the `docker-compose` file
5. `docker-compose up --build`
6. Open a browser and navigate to [localhost:8000](http://localhost:8000/)
7. When finished, press `control + c` to stop the docker container
8. `docker-compose down` to delete the stopped container

### Some good commands to know with docker and django
1. `docker-compose run web python manage.py makemigrations`
2. `docker-compose run web python manage.py migrate`
