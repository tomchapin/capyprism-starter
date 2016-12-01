.PHONY: all

default: install run

install:
	@bundle install

run:
	@bundle exec rspec

clean:
	rm -rf ./tmp

selenium-grid-start:
	docker run -d --name=grid -p 4444:24444 -p 5900:25900 --shm-size=1g --restart always elgalu/selenium
	$(MAKE) selenium-grid-wait
	echo "Selenium grid is now running"

selenium-grid-stop:
	docker rm -vf grid
	echo "Selenium grid killed"

selenium-grid-status:
	docker inspect --format="{{ .State.Running }}" grid

selenium-grid-wait:
	docker exec grid wait_all_done 30s

selenium-grid-soft-start:
	($(MAKE) selenium-grid-status && echo "Selenium grid is already running") || $(MAKE) selenium-grid-start

selenium-grid-soft-stop:
	($(MAKE) selenium-grid-status && $(MAKE) selenium-grid-stop) || echo "Selenium grid is not running"