.PHONY: all

default: install run

install:
	@bundle install

run:
	@bundle exec rspec

clean:
	rm -rf ./tmp

