NAME = ft_ality

.PHONY: all
all: $(NAME)

$(NAME): opam build

.PHONY: opam
opam:
	OPAMYES=true opam update
	OPAMYES=true opam upgrade
	OPAMYES=true opam install ocamlsdl2
	OPAMYES=true opam install dune

.PHONY: build
build:
	dune build
	cp -f _build/default/bin/main.exe $(NAME)

.PHONY: clean
clean:
	rm -rf _build

.PHONY: fclean
fclean: clean
	rm -rf $(NAME)

.PHONY: re
re: fclean all