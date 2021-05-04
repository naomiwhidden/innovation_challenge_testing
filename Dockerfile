FROM python:3.9
ENV PYTHONUNBUFFERED=1
WORKDIR /code
COPY requirements.txt /code/
RUN python3 -m pip install --upgrade pip && pip install -r requirements.txt
COPY . /code/