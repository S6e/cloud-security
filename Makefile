help :
	clear
	@echo "--------------------------------------------------------------------------------"
	@echo " Installation of Security Showcase"
	@echo "--------------------------------------------------------------------------------"
	@echo " usage: make <target>"
	@echo " valid targets are:"
	@echo "                   "
	@echo " Tasks             "
	@echo " =============     "
	@echo " - install         - Installs and starts the tools of the showcase"
	@echo " - clean           - Deinstalls the showcase"
	@echo " - reinstall	  - Deinstalls and reinstalls the showcase"
	@echo "--------------------------------------------------------------------------------"

install :
	./bin/setup-api-gateway.sh
clean :
	./bin/cleanup.sh
reinstall:
	./bin/cleanup.sh
	./bin/setup-api-gateway.sh
	
