.PHONY: test

deps:
	pip install -r requirements.txt
	pip install -r test_requirements.txt

test:
	PYTHONPATH=. py.test --verbose -s
test_smoke:
	curl --fail 127.0.0.1:5000
lint:
	flake8 hello_world test

run:
	PYTHONPATH=. FLASK_APP=hello_world flask run

docker_build:
	docker build -t hello-world-printer .

docker_run: docker_build
		docker stop hello-world-printer-dev
		docker rm hello-world-printer-dev
		docker run \
		--name hello-world-printer-dev \
		-p 5000:5000 \
		-d hello-world-printer  # uruchomienie w tle serwisu

USERNAME=lenaww
TAG=$(USERNAME)/hello-world-printer

docker_push: docker_build
		@docker login --username $(USERNAME) --password $${DOCKER_PASSWORD}; \
		docker tag hello-world-printer $(TAG); \
		docker push $(TAG); \
		docker logout;
		