:-(clause(weapon(_,_,_,_,_),_); consult('base.pro')).

menu:-
	nl,
	write('*********************************'),nl,
    write('*         W E A P O N S         *'),nl,
    write('*********************************'),nl,
    write('* 1. - View the knowledge base  *'),nl,
    write('* 2. - Add new weapon           *'),nl,
    write('* 3. - Update weapons           *'),nl,
    write('* 4. - Remove weapons           *'),nl,
	write('* 5. - Add new Category         *'),nl,
	write('* 6. - Add new Type             *'),nl,
	write('* 7. - Guess the weapon game    *'),nl,
    write('* 8. - Quit                     *'),nl,
    write('*********************************'),nl,
	nl,
	write('Select and confirm with a dot: '),
    read(X),
    menu1(X).

menu1(1):-
		consult('base.pro'),
		nl,nl,
		write('Enter name of the weapon (confirm with a dot): '),nl,
		read(Name),nl,
		!,
		search(Name),
		continue(Answer),
		(Answer = y, menu1(1) ; menu).

menu1(2):-
		nl,nl,
		write('Enter name of the weapon: '),
		read(Name),nl,
		write('Select category (small_arms/artillery): '),
		read(Category),nl,
		write('Select type: '),
		read(Type),nl,
		write('Enter caliber: '),
		read(Caliber),nl,
		write('Enter origin: '),
		read(Origin),nl,
		(weapon(Name,Category,Type,Caliber,Origin), write('The weapon already exists'), nl ;
		assertz(weapon(Name,Category,Type,Caliber,Origin)), write('Weapon added')),
		continue(Answer),
		(Answer = y, menu1(2) ; menu).

menu1(3):-
		consult('base.pro'),
		nl,nl,
		write('Enter name of the weapon: '),
		read(Name),nl,
		(retract(weapon(Name,Category,Type,Caliber,Origin)),
		write('Set new category: '),
		read(Category_New),nl,
		write('Set new type: '),
		read(Type_New),nl,
		write('Set new caliber: '),
		read(Caliber_New),nl,
		write('Set new origin: '),
		read(Origin_New),nl,
		assertz(weapon(Name,Category_New,Type_New,Caliber_New,Origin_New)),
		write('The weapon has been updated');
		nl,
		write('Weapon not found')),
		continue(Answer),
		(Answer = y, menu1(3) ; menu).
		
menu1(4):-
		consult('base.pro'),
		nl,nl,
		write('Enter name of the weapon: '),
		read(Name),nl,
		(retract(weapon(Name,_,_,_,_)),
		write('The weapon has been deleted');
		nl,
		write('Weapon not found')),
		continue(Answer),
		(Answer = y, menu1(4) ; menu).

menu1(5):-
		nl,nl,
		write('Enter new category name: '),
		read(Category),nl,
		write('Describe new category as below:'),nl,
		write('This weapon (verb) (noun/adjective)'),nl,
		write('verb:'),read(Verb),nl,
		write('noun/adjective:'),read(Noun),nl,
		
		append('const.pro'),nl,nl,
		write('description('),
		write(Category),
		write('):-'),nl,
		write('	true('),
		write(Verb),write(','),
		write(Noun),write(').'),nl,
		told,nl,
		write('New category has been added!'),!,
		continue(Answer),
		(Answer = y, menu1(5) ; menu).

menu1(6):-
		nl,nl,
		write('Enter new type name: '),
		read(Type),nl,
		write('Select category (small_arms/artillery):'),
		read(Category),nl,
		write('Describe new type as below:'),nl,
		write('This weapon (verb) (noun/adjective)'),nl,
		write('verb:'),read(Verb),nl,
		write('noun/adjective:'),read(Noun),nl,

		append('const.pro'),nl,nl,
		write('description('),
		write(Type),
		write('):-'),nl,
		write('	description('),
		write(Category),write('),'),nl,
		write('	true('),
		write(Verb),write(','),
		write(Noun),write(').'),nl,
		told,nl,
		write('New type has been added!'),!,
		continue(Answer),
		(Answer = y, menu1(6) ; menu).

menu1(7):-
		prepare_game,
		ensure_loaded('temp.pro'),
		ensure_loaded('const.pro'),
		make,
		start,
		menu.

menu1(8):-		
		save_base,
		retractall(weapon(_,_,_,_,_)),
		write('Bye!'),
		nl,nl,
		tell('temp.pro'),write(''),told,
		get0(_),
		halt.

menu1(_):-	
		nl,nl,
		write('Wrong option!'),
		nl,
		menu.

search(Name):-
		not(weapon(Name, Category, Type, Caliber, Origin)),
		write('There is no such weapon...'),nl,
		!.

search(Name):-
		weapon(Name, Category, Type, Caliber, Origin),
		write('Category:'),write(Category),nl,
		write('Type:'),write(Type),nl,
		write('Caliber:'),write(Caliber),nl,
		write('Origin:'),write(Origin).

continue(Answer):-
		nl,
		write('Continue? y/n'),nl,
		read(Answer).

save_base:-
		tell('base.pro'),
		write(':-dynamic weapon/5.'),nl,
		save,
		told.

save:-		
		weapon(Name, Category, Type, Caliber, Origin),
		write(weapon(Name,Category,Type,Caliber,Origin)),
		write(.),
		nl,
		fail.
save.

prepare_game:-
		tell('temp.pro'),
		list_all_clauses_in_memory,
		told.

list_all_clauses_in_memory:-
		weapon(Name, Category, Type, Caliber, Origin),
		write('weapon('),
		write(Name),
		write('):-'),nl,
		write('	description('),write(Type),write('),'),nl,
		write('	true(caliber,'),write(Caliber),write('),'),nl,
		write('	true(origin,'),write(Origin),write(').'),nl,nl,
		fail.
list_all_clauses_in_memory.

:-dynamic xtrue/2.
:-dynamic xfalse/2.

:-(clause(weapon(_),_); consult('temp.pro')).
:-(clause(description(_),_); consult('const.pro')).
:-(clause(true(_,_),_); consult('const.pro')).
:-(clause(false(_,_),_); consult('const.pro')).

true(X,Y):-
			xtrue(X,Y),
			!.

true(X,Y):-
			not(xfalse(X,Y)),
			ask(X,Y,yes).

false(X,Y):-
			xfalse(X,Y),
			!.

false(X,Y):-
			not(xtrue(X,Y)),
			ask(X,Y,no).

ask(X,Y,yes):-
			!,
			write('Does it '),write(X),write(' '),write(Y),write('? (y/n)'),nl,
			read(Answer),
			Answer = y,
			assertz(xtrue(X,Y)).

ask(X,Y,no):-
			!,
			write('Does it '),write(X),write(' '),write(Y),write('? (y/n)'),nl,
			read(Answer),
			Answer = n,
			assertz(xfalse(X,Y)).

clear_facts:-
			write('clearing answers...'),nl,
			retractall(xtrue(_,_)),
			retractall(xfalse(_,_)).

play(X):-weapon(X).

start:-
		nl,nl,
		write('I will try to guess your weapon!'),nl,
		play(X),nl,nl,
		write('I know! It is '),write(X),write('!!!'),nl,nl,
		write('One more time? (y/n)'),nl,
		read(Answer),
		(Answer = y, clear_facts, start ; !, clear_facts, write('Done!'),nl, get0(_), menu).
		
start:-
		nl,nl,
		write('Sorry, I have no idea :('),nl,
		write('One more time? (y/n)'),nl,
		read(Answer),
		(Answer = y, clear_facts, start ; !, clear_facts, write('Done!')),nl.
