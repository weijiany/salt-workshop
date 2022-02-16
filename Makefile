RED = \033[0;31m
GREEN = \033[0;32m
NO_COLOR = \033[0m

init:
	@echo "${RED}check whether install vagrant-scp"
	@if vagrant plugin list | grep vagrant-scp -q; then echo "${GREEN}vagrant-scp installed"; else vagrant plugin install vagrant-scp; fi

collect: init
	@echo "${NO_COLOR}collect salt config files to ./dist"
	@mkdir -p ./dist
	@rsync -a ./pillar ./dist --delete
	@vagrant ssh salt-master -c "rm -rf ~/srv/*"
	@vagrant scp ./dist/* salt-master:~/srv/ > /dev/null
	@echo "${NO_COLOR}Collect done in ./dist"
