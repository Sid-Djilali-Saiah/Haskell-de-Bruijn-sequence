##
##
## EPITECH PROJECT, 2018
## sid.djilali-saiah@epitech.eu
## File description:
## Makefile
##

NAME	=	deBruijn

RM		=	rm -f

all:	$(NAME)

$(NAME): clean
	@stack build
	cp `stack path --local-install-root`/bin/deBruijn-exe ./$(NAME)

clean:
	$(RM) $(NAME)

fclean:	clean
	@stack clean

re:		fclean all

watch:
	stack build --file-watch

test:
	@stack test --fast --file-watch --coverage

.PHONY: all clean fclean re watch test
