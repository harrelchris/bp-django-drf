@echo off

:: Create virtual environment
if not exist .venv\ (
	python -m venv .venv
)

:: Activate virtual environment
call .venv\Scripts\activate

:: Update virtual environment
python -m pip install pip setuptools wheel --upgrade

:: Install dependencies
pip install -r requirements/dev.txt --upgrade

:: Create .env from example
if not exist .env (
	copy .\envs\dev.env .env
)

:: Delete the existing database
if exist db.sqlite3 (
	del db.sqlite3
)

:: Initialize a clean database
python app/manage.py makemigrations
python app/manage.py migrate

:: Delete migrations during development
:: del app\public\migrations\0001_initial.py

:: Load fixtures
:: python app/manage.py loaddata

:: Create super users
python app/manage.py createsuperuser --username root --email root@email.com --noinput
python app/manage.py createsuperuser --username sudo --email sudo@email.com --noinput
python app/manage.py createsuperuser --username user --email user@email.com --noinput
