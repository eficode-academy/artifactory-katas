FROM python:3.7-slim
COPY requirements.txt /requirements.txt
RUN pip install -r /requirements.txt
COPY aclean.py /aclean.py
ENTRYPOINT [ "python", "/aclean.py" ]