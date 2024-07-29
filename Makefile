NAME = ft_ality

.PHONY: all
all: $(NAME)

$(NAME): opam
	dune build
	mv _build/default/bin/$(NAME).exe $(NAME)

.PHONY: opam
opam:
	OPAMYES=true opam update
	OPAMYES=true opam upgrade
	opam install dune

.PHONY: nopam
nopam:
	dune build
	mv _build/default/bin/$(NAME).exe $(NAME)