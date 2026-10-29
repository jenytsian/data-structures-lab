# make submit P=005-brackets    交題給 ds-judge
# make list                     列出 judge 上的題號

DS_JUDGE ?= $(HOME)/dev/projects/ds-judge
export DS_JUDGE

.PHONY: submit list

submit:
	@test -n "$(P)" || { echo "用法：make submit P=005-brackets"; exit 1; }
	@scripts/submit.sh $(P)

list:
	@ls $(DS_JUDGE)/problems
