TEMP="./bare_conf.tex"
MODEL1_SRC=PathFollower.hs
OUTPUT=thesis.pdf
OUTPUT_SRC=thesis.md
REFS=references.bib
DISABLED_RULES=WHITESPACE_RULE,COMMA_PARENTHESIS_WHITESPACE,EN_QUOTES,CURRENCY_SPACE,CURRENCY,EN_UNPAIRED_BRACKETS

all: $(OUTPUT)

$(OUTPUT): $(OUTPUT_SRC)
	 pandoc --latex-engine=xelatex --listings --template=$(TEMP) $(OUTPUT_SRC) -o $(OUTPUT) --bibliography=$(REFS)

test-grammar:
	languagetool -d $(DISABLED_RULES) -l en $(OUTPUT_SRC)

test-spelling:
	aspell -c $(OUTPUT_SRC)

test: test-spelling test-grammar
