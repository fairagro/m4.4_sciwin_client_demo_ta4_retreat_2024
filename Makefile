FILES = \
	calculation.py \
	plot.py \
	population.csv \
	requirements.txt \
	.gitignore \
	remote_data/speakers.csv \
	remote_data/speakers_revised.csv
BASE_URL = https://raw.githubusercontent.com/fairagro/m4.4_hello_world/refs/heads/master

prepare_folder:
	@mv .git _.git
	@for file in $(FILES); do \
		wget $(BASE_URL)/$$file || echo "$(BASE_URL)/$$file failed"; \
	done
	@python -m venv .venv
	@.venv/bin/pip install -r requirements.txt
	@echo "export PATH=\$$PATH:~/m4.4_sciwin_client/target/debug\nsource .venv/bin/activate" > set_env.sh
	@echo "\n\n\033[0;32mRun 'source set_env.sh' to apply the changes to the current shell.\033[0m'"

all: prepare_folder

clean:
	@rm -rf .git
	@mv _.git .git
	@find . -mindepth 1 \( -name 'Makefile' -o -name 'Readme.md' -o -path './.git' -prune \) -o -exec rm -rf {} +

