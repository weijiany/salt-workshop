RED = \033[0;31m
GREEN = \033[0;32m
NO_COLOR = \033[0m

init:
	@echo "${RED}check whether install vagrant-scp"
	@if vagrant plugin list | grep vagrant-scp -q; then echo "${GREEN}vagrant-scp installed"; else vagrant plugin install vagrant-scp; fi

collect: init
	@echo "${NO_COLOR}collect salt config files to ./dist"
	@mkdir -p ./dist
	@rm -rf ./dist/*
	@rsync -a ./pillar/* ./dist/pillar --delete
	@rsync -a ./salt/* ./dist/salt --delete
	@vagrant ssh salt-master -c "rm -rf ~/srv/*"
	@for salt_dir in $$(ls ./dist); do vagrant scp ./dist/$${salt_dir} salt-master:~/srv/ > /dev/null; done
	@echo "${NO_COLOR}Collect done in ./dist"
