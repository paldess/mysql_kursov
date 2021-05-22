ALTER table products 
	add constraint products_users_fk foreign key (user_id)
	references users(id)
	on delete cascade;


create table financial_data(
	user_id int unsigned not null primary key,
	number_card bigint unsigned,
	date_card date,
	cvv int unsigned,
	updated_at timestamp default current_timestamp on update current_timestamp,
	created_at timestamp default current_timestamp);
	
drop view if exists financial_data_view; 
create view financial_data_view as
	select user_id, concat('****', right(number_card, 4)) from financial_data;



select * from financial_data_view;

insert into financial_data(user_id, number_card, date_card, cvv) value('1', '11112222333344445566', '5/12/20', '456');

select * from orders_view;
drop view if exists orders_view; 
create view orders_view as
	select id, '****' as product_id, user_id, status_order_id from orders;
	

create index first_name_idx on users(first_name);
create index first_name_last_name_idx on users(first_name, last_name);
create index name_products_idx on products(name_product);
create index price_idx on products(price);

delimiter //
create trigger date_card_insert before insert on financial_data
	for each row BEGIN 
		if new.date_card <= now() THEN 
			SIGNAL SQLSTATE '45000' set message_text='срок действия карты истек';
		end if;
	END

delimiter ;

delimiter //
create trigger from_user_to_from_user_insert before insert on messages
	for each row BEGIN 
		if new.from_user_id = new.to_user_id THEN 
			SIGNAL SQLSTATE '45000' set message_text='нельзя написать самому себе';
		end if;
	END

delimiter ;

update product_descriptions set created_at =
	(select created_at from products where product_descriptions.product_id=products.id)  ;




