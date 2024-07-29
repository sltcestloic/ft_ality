NAME = ft_ality

.PHONY: all
all: $(NAME)

$(NAME): opam build

.PHONY: opam
opam:
	OPAMYES=true opam update
	OPAMYES=true opam upgrade
	opam install dune

.PHONY: build
build:
	dune build
	mv _build/default/bin/$(NAME).exe $(NAME)
