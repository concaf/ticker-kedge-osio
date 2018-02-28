run:
	./wait-for-it.sh redis:6379
	python app.py

