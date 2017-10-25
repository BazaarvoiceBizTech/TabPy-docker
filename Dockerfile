from continuumio/miniconda:latest

# avoid errors with "source activate"
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# stop the setup script from running the server on install
# cat setup.sh | grep -v 'bash "$STARTUPPATH/startup.sh" $PORT' > install.sh
# basically just removes the startup line and rename the new file to install.sh

RUN git clone https://${GITHUB_TOKEN}@github.com/BazaarvoiceBizTech/bv_tools.git

RUN git clone https://github.com/BazaarvoiceBizTech/TabPy.git && \
	cd TabPy && \
	cat setup.sh | grep -v 'bash "$STARTUPPATH/startup.sh" $PORT' > install.sh && \
	/bin/bash -c "source install.sh"

RUN source activate Tableau-Python-Server && \
	pip install --upgrade pip && \
	pip install numpy pandas scikit-learn==0.17.1 scipy textblob nltk vaderSentiment && \
	pip install reverse_geocoder geopy && \
	python -m textblob.download_corpora lite && \
	python -m nltk.downloader vader_lexicon
	
ADD start.sh /start.sh

ENTRYPOINT bin/bash start.sh