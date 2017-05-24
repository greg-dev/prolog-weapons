
description(small_arms):-
	true(use,bullets).

description(revolver):-
	description(small_arms),
	true(have,rotating_cylinder).

description(handgun):-
	description(small_arms),
	true(have,short_barrel).

description(submachine_gun):-
	description(handgun),
	true(have,more_than_10_bullets_in_magazine).

description(rifle):-
	description(small_arms),
	false(have,short_barrel).

description(assault_rifle):-
	description(rifle),
	true(use,intermediate_cartridges).

description(artillery):-
	false(use,gun_cartridges).

description(cannon):-
	description(artillery),
	true(have,flat_bullet_trajectory).

description(howitzer):-
	description(artillery),
	false(have,flat_bullet_trajectory).

description(grenade_launcher):-
	description(howitzer),
	true(use,grenades).

description(rocket_propelled_grenade_launcher):-
	description(grenade_launcher),
	true(is,anti_tank).