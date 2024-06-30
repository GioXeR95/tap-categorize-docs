FROM python
ENV PATH /usr/src/app/bin:$PATH
WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
# Install tesseract-ocr
RUN apt-get update && apt-get install -y tesseract-ocr
#COPY bin/* ./
COPY python-manager.sh /
RUN chmod +x /python-manager.sh
#CMD [ "bash", "/python-manager.sh"]
ENTRYPOINT [ "/python-manager.sh" ]