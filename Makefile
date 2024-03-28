all:
	ruby get.rb

jq:
	ruby get.rb | jq .

jless:
	ruby get.rb | jq . | jless
