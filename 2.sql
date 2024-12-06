-- POSTGRESQL
-- задание 2
-- создание таблицы
create table OrderDet (
manager varchar(50),
product varchar(50),
quantity bigint,
dat date
);

-- вставка данных
INSERT INTO OrderDet (manager, product, quantity, dat)
VALUES
  ('Алиса', 'Мониторы', 10, '2016-12-01'),
  ('Андрей', 'Телефон', 15, '2017-11-28'),
  ('Елизавета', 'Мониторы', 30, '2017-12-03'),
  ('Макар', 'Наушники', 30, '2016-11-25'),
  ('Роман', 'Мониторы', 50, '2017-12-02'),
  ('Роман', 'Наушники', 5, '2018-12-02'),
  ('Роман', 'Телефон', 25, '2016-12-02'),
  ('Светлана', 'Мониторы', 20, '2017-08-15'),
  ('Светлана', 'Мониторы', 11, '2017-09-10'),
  ('Игорь', 'Наручные часы', 12, '2016-05-20'),
  ('Дмитрий', 'Телефон', 9, '2018-07-10');


-- Нужно написать SQL-запрос, который выведет список продавцов,
-- которые продали в 2017 году более 30 штук товара 'мониторы'
SELECT manager FROM OrderDet
WHERE EXTRACT(YEAR from dat) = 2017 AND product = 'Мониторы'
GROUP BY manager HAVING SUM(quantity) > 30;