/* Possible Choice Lists */
meals([healthy, normal, value, vegan, veggie]).
breads([italian_wheat, hearty_italian, honey_oat, parmesan_oregano, multigrain, flatbread]).
meats([chicken, beef, ham, bacon, salmon, tuna, turkey]).
veggies([cucumbers, green_bell_peppers, lettuce, red_onions, tomatoes, black_olives, jalapenos, pickles]).
topping_cheese([processed_cheddar, monterey_cheddar]).
topping_non_cheese([avocado, bacon, pepperoni]).
sauce_fatty([chipotle, bbq, ranch, chilli, mayo]).
sauce_non_fatty([tomato, honey_mustard, sweet_onion]).
sides([chips, cookies, hashbrowns, soup, drinks]).





/* Rules and queries */

/* index_recur/2*/
/* is to show all the options in the specified list with index */

% After showing all the options, it ends and ask customer to type number of the choice
index_recur(Last, List):-
    length(List, Length),
    Last is Length + 1,
    write('Type number of your choice (End with period ".")').

% It is a recursive function to iterate showing options,
% until it shows all available options
index_recur(Index, List):-
    nth1(Index, List, Elem),
    format('~w: ~w ~n', [Index, Elem]),
    Next is Index + 1,
    index_recur(Next, List).



/* index_recur_without_chosen/2 */
% To show all the options except ones that are already ordered
index_recur_without_chosen([], _) :-
    write('Type number of your choice').
index_recur_without_chosen([Head|Tail], List):-
    nth1(Head, List, Elem),
    format('~w: ~w ~n', [Head, Elem]),
    index_recur_without_chosen(Tail, List).





/* show_options_without_chosen/1 */
/* They are for orders that are possible to be multiple, for example sauce and veggies. */

% Given the list of index numbers of chosen order,
% it will show all possible orders that haven't been chosen yet.

show_options_without_chosen(Chosen_List, Option_List) :-
    findall(X,
            (
		length(Option_List, Y),
                between(1, Y, X),
                integer(X),
                \+ member(X, Chosen_List)
            ),
            Without_chosen),
    index_recur_without_chosen(Without_chosen, Option_List).




/* read_only/2 */
% is to avoid error steming from customer's input that is not in the index number.
% Only the integer in the specified list would be accepted,
% and this returns the accepted input in the 2nd argument (X).

% It has to be used after defining specified list, for example,
%      "meals(List), read_only(List, X)"  .

read_only(Specified_List, X):-
    read(Input),
    (
	integer(Input)
		->  (
			(length(Specified_List, Y), between(1, Y, Input))
				->  (Input = X);
				(
				writeln('Please answer in the numbers in the list'),
					read_only(Specified_List, X)
			)
                );
		writeln('Please answer in the numbers in the list'),
		read_only(Specified_List, X)
    ).





/* ~~~_option/1 */
/* are to store customer's choice into the knowledge base as selected_~~~/1 */
:- dynamic(selected_meal/1).
:- dynamic(selected_bread/1).
:- dynamic(selected_meat/1).
:- dynamic(selected_veggies/1).
:- dynamic(selected_topping/1).
:- dynamic(selected_sauce/1).
:- dynamic(selected_side/1).

% To avoid findall/3 to be failed when displaying the resulted order,
% we define initial facts of selected_~~~/1.
% Note that "init" is not anywhere in any possible choice list,
% so that it won't affect the result of findall/3.
selected_meal(init).
selected_bread(init).
selected_meat(init).
selected_veggies(init).
selected_topping(init).
selected_sauce(init).
selected_side(init).

meal_option(Input)    :- meals(L), nth1(Input, L, Elem), assertz(selected_meal(Elem)).
bread_option(Input)   :- breads(L), nth1(Input, L, Elem), assertz(selected_bread(Elem)).
meat_option(Input)    :- meats(L), nth1(Input, L, Elem), assertz(selected_meat(Elem)).
veggie_option(Input)  :- veggies(L), nth1(Input, L, Elem), assertz(selected_veggies(Elem)).
topping_option(Input) :- topping_cheese(L1), topping_non_cheese(L2),
                         append(L1, L2, L), nth1(Input, L, Elem),
                         assertz(selected_topping(Elem)).
sauce_option(Input)   :- sauce_fatty(L1), sauce_non_fatty(L2),
                         append(L1, L2, L), nth1(Input, L, Elem),
                         assertz(selected_sauce(Elem)).
side_option(Input)    :- sides(L), nth1(Input, L, Elem), assertz(selected_side(Elem)).



/* read_only_without_chosen/3 */
% will only read customer's input that is in the available list.

% Supposed to use after calling Chosen_list and Option_list,
% for example, "findall(A,selected_~~~_index(A), Chosen_List),
% veggies(Veg_List)"
read_only_without_chosen(Chosen_List, Option_List, X):-
    findall(B,
            (length(Option_List, Y),
             between(1, Y, B),
             integer(B),
             \+ member(B, Chosen_List)), Without_chosen),
    read(Input),
    (
	integer(Input)
		->  (
			(member(Input, Without_chosen))
				->  (Input = X);
				(
				writeln('Please answer in the numbers in the list'),
					read_only_without_chosen(Chosen_List, Option_List, X)
			)
                );
		writeln('Please answer in the numbers in the list'),
		read_only_without_chosen(Chosen_List, Option_List, X)
    ).


/* multiple_choice_veg/0 */
/* To get multiple selection of order for veggies. */
/* Consists of get_veg_option/0 & ask_next_veg/0. */

% For 2nd time round and after, I tried to remove chosen options when showing the options.
% Thus, for this purpose, I needed to store chosen index to KB.
% Here's selected_~~~_index/1 to do so.
:- dynamic(selected_veggies_index/1).
:- dynamic(selected_sauce_index/1).

selected_veggies_index(init).
selected_sauce_index(init).

get_veg_option:-
    findall(A,selected_veggies_index(A), Chosen_List),
    veggies(Veg_List),
    read_only_without_chosen(Chosen_List, Veg_List, Input),

    veggie_option(Input),
    assertz(selected_veggies_index(Input)),
    writeln('Do you want to add more? (Answer in \"y\" or \"n\")').


ask_next_veg:-
	read(Answer),
    (
	Answer == y ->  findall(A,selected_veggies_index(A), Chosen_List),
                        veggies(Veg_List),
                        show_options_without_chosen(Chosen_List, Veg_List),
                        multiple_choice_veg;
	Answer == n -> true;
	write('Please answer in \"y\" or \"n\" :'), ask_next_veg
    ).

multiple_choice_veg:-
    get_veg_option,
    ask_next_veg.





/* ask_next_sauce/0 */
% are to ask 2nd order of sauce

ask_next_sauce_non_fat:-
	read(Answer),
    (
	Answer == y -> (findall(A,selected_sauce_index(A), Chosen_List),
                    sauce_non_fatty(Sauce_non_fatty_List),
                    show_options_without_chosen(Chosen_List, Sauce_non_fatty_List),
                     
                    read_only_without_chosen(Chosen_List, Sauce_non_fatty_List, Sauce_non_fat_2),
                    sauce_option(Sauce_non_fat_2));
	Answer == n -> true;
	write('Please answer in \"y\" or \"n\"'), ask_next_sauce_non_fat
    ).

ask_next_sauce:-
	read(Answer),
    (
	Answer == y ->  findall(A,selected_sauce_index(A), Chosen_List),
                    (sauce_fatty(Sauce_fatty_List),
                     sauce_non_fatty(Sauce_non_fatty_List),
                     append(Sauce_fatty_List, Sauce_non_fatty_List, Sauce_List),
                     show_options_without_chosen(Chosen_List, Sauce_List),
                        
            		 read_only_without_chosen(Chosen_List, Sauce_List, Sauce_2),
            		 sauce_option(Sauce_2));
	Answer == n -> true;
	write('Please answer in \"y\" or \"n\"'), ask_next_sauce
    ).





/* write_list/1 */
/* Display all selected options at the end of the interaction.*/
write_list([]).
write_list([Head|Tail]):-
    (length([Head|Tail], 1), format('~w ~n', [Head]));
    (format('~w, ', Head), write_list(Tail)).





/* Interactions start with order/0 ____________________________________________________*/
order :-
    writeln('Welcome to Subway! Which meal would you like? Here\'s the options'),


    /* 1. meal option */
    % Ask and store the meal choice of customer into the knowledge base

    % Showing all options
    meals(Meal_List), index_recur(1, Meal_List),

    % Read customer's input only if it is in the Meat_List
    read_only(Meal_List, Meal), meal_option(Meal),



    /* 2. bread option */
    % Next, ask and store the bread choice into the knowledge base

    writeln('Alright, what kind of bread you would like today?'),
    breads(Bread_List), index_recur(1, Bread_List),
    read_only(Bread_List, Bread), bread_option(Bread),



    /* 3. meat option */
    % Then, ask and store the meat choice
    % for customer who chose neither veggie nor vegan meal.
    (
	% For veggie and vegan meal, meat options will not be offered.
	(selected_meal(veggie); selected_meal(vegan))
		-> true;
	(
		writeln('What about meat?'),
		meats(Meat_List), index_recur(1, Meat_List),

		read_only(Meat_List, Meat), meat_option(Meat)
        )
    ),



    /* 4. veggie choice */
    % After, ask veggie choice.

    writeln('Okay, got it.'),
    writeln('What kind of veggies can I get on here for you?'),
    veggies(Veg_List), index_recur(1, Veg_List),

    % Veggies can have multiple options,
    % so it will ask next until customer says it's done.
    multiple_choice_veg,



    /* 5. sauce option */

    % Unlike veggies, sauce choice would be up to 2,
    % or otherwise there'd be too much sauce going on.
    % Therefore, I make it to ask sauce order maximum time round of 2.
    writeln('Sure, which sauce do you want?'),
    (
	% For healthy meal, fatty sauces will not be offered.
	selected_meal(healthy)
		->  (
                     sauce_non_fatty(Sauce_non_fat_List),
                     index_recur(1, Sauce_non_fat_List),

                     read_only(Sauce_non_fat_List, Sauce_non_fat_1),
                     sauce_option(Sauce_non_fat_1),

                     assertz(selected_sauce_index(Sauce_non_fat_1)),
                     writeln('Do you want to add more? (Answer in \"y\" or \"n\") :'),

                     ask_next_sauce_non_fat
             );
            (
            sauce_fatty(Sauce_List1), sauce_non_fatty(Sauce_List2),
            append(Sauce_List1, Sauce_List2, Sauce_List),
            index_recur(1, Sauce_List),

            read_only(Sauce_List, Sauce_1), sauce_option(Sauce_1),
            assertz(selected_sauce_index(Sauce_1)),
            writeln('Do you want to add more? (Answer in \"y\" or \"n\") :'),

            ask_next_sauce
            )
	),
	writeln('Alright!'),



    /* 6. topping option */
    % Ask topping option

    % For value meal, no topping will be offered.
    (   selected_meal(value)
		-> true;
        (
		%\+ selected_meal(value),
		writeln('Anything on top?'),
		(
		        (
			% For vegan meal, cheese topping will not be offered.
			selected_meal(vegan)
				->	(
					topping_non_cheese(Topping_non_cheese_List),
					index_recur(1, Topping_non_cheese_List),

					read_only(Topping_non_cheese_List, Topping_non_cheese),
                                        topping_option(Topping_non_cheese)
					);

			topping_cheese(Topping_L1), topping_non_cheese(Topping_L2),
                        append(Topping_L1, Topping_L2, Topping_List),
			index_recur(1, Topping_List),

			read_only(Topping_List, Topping),
			topping_option(Topping)
			)
		)
	)
    ),



    /* 7. side option */
    % Ask for side order

    writeln('Alright, anything else from side menu?'),
    sides(Side_List), index_recur(1, Side_List),
    read_only(Side_List, Side), side_option(Side),
    writeln('Okay! Wait a second...'), nl, nl,



    /* 8. Display the order */
    % Finally, display the resulted order.

    writeln('Here\'s your order. Check if anything\'s wrong.'),nl,

    findall(A, (selected_meal(A), meals(ListA), member(A, ListA)), Order_meal),
    write('Meal: '), write_list(Order_meal), nl,

    findall(B, (selected_bread(B), breads(ListB), member(B, ListB)), Order_bread),
    write('Bread: '), write_list(Order_bread), nl,

    findall(C, (selected_meat(C), meats(ListC), member(C, ListC)), Order_meat),
    write('Meat: '), write_list(Order_meat), nl,

    findall(D, (selected_veggies(D), veggies(ListD), member(D, ListD)), Order_veggie),
    write('Veggies: '), write_list(Order_veggie), nl,

    findall(E, (selected_topping(E),
                   topping_cheese(LT1), topping_non_cheese(LT2), append(LT1, LT2, ListE),
                   member(E, ListE)), Order_topping),
    write('Toppings: '), write_list(Order_topping), nl,

    findall(F, (selected_sauce(F),
                   sauce_fatty(LS1), sauce_non_fatty(LS2), append(LS1, LS2, ListF),
                   member(F, ListF)), Order_sauce),
    write('Sauce: '), write_list(Order_sauce), nl,

    findall(G, (selected_side(G), sides(ListG), member(G, ListG)), Order_side),
    write('Side: '), write_list(Order_side), nl.


