.PHONY: all

default: install run

install:
	@bundle install

run:
	@bundle exec rspec

clean:
	rm -rf ./tmp

start-selenium-server:
	docker run -d --name=grid -p 4444:24444 -p 5900:25900 --shm-size=1g --restart always elgalu/selenium
	docker exec grid wait_all_done 30s

stop-selenium-server:
	docker exec grid stop
	docker stop grid
	docker rm -vf grid