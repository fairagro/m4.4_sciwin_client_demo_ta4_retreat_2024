FILES = \
	calculation.py \
	plot.py \
	population.csv \
	requirements.txt \
	.gitignore \
	remote_data/speakers_revised.csv
BASE_URL = https://raw.githubusercontent.com/fairagro/m4.4_hello_world/refs/heads/master

prepare_folder:
	@rm -rf .git
	@for file in $(FILES); do \
		wget $(BASE_URL)/$$file || echo "$(BASE_URL)/$$file failed"; \
	done
	@python -m venv .venv
	@.venv/bin/pip install -r requirements.txt
	@git init
	@echo "export PATH=\$$PATH:~/m4.4_sciwin_client/target/debug\nsource .venv/bin/activate" > set_env.sh
	@git add .
	@git commit -m "initial commit"
	@echo "Run 'source set_env.sh' to apply the changes to the current shell."

all: prepare_folder

clean:
	@find . -mindepth 1 ! -name 'Makefile' ! -name 'Readme.md' -exec rm -rf {} +