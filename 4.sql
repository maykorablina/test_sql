-- POSTGRESQL
-- задание 4
-- создание таблиц

create table Orders (
cust_id int,
prod_id int,
price bigint,
quantity bigint,
dat date
);

create table Customers (
FIO varchar(50),
id int
);

create table Products (
product varchar(50),
id int
);

-- вставка данных
INSERT INTO Customers (FIO, id)
VALUES
  ('Макар Вержбицкий', 1),
  ('Арсений Холкин', 2),
  ('Елизавета Сторожева', 3),
  ('Ильмир Кузахметов', 4),
  ('Анна Журавлева', 5);

INSERT INTO Products (product, id)
VALUES
  ('Мониторы', 1),
  ('Телефоны', 2),
  ('Наушники', 3),
  ('Клавиатуры', 4),
  ('Мыши', 5);

INSERT INTO Orders (cust_id, prod_id, price, quantity, dat)
VALUES
  (1, 3, 5000, 2, '2023-02-15'),
  (2, 5, 1500, 4, '2023-03-10'),
  (3, 4, 3000, 1, '2023-04-05'),
  (4, 1, 20000, 1, '2023-05-20'),
  (5, 2, 15000, 3, '2023-06-18'),
  (1, 5, 1500, 5, '2023-07-25'),
  (2, 3, 5000, 1, '2023-08-12'),
  (3, 2, 15000, 2, '2023-09-30'),
  (1, 1, 20000, 2, '2023-11-01'),
  (1, 2, 15000, 1, '2023-11-02'),
  (2, 3, 5000, 3, '2023-11-03'),
  (3, 1, 20000, 1, '2024-11-04'),
  (4, 4, 3000, 5, '2024-11-05'),
  (5, 5, 1500, 10, '2024-11-06'),
  (2, 4, 3000, 2, '2024-11-07'),
  (3, 2, 15000, 1, '2024-11-08'),
  (4, 3, 5000, 4, '2024-11-09'),
  (5, 1, 20000, 3, '2024-11-10');


-- Нужно написать SQL-запрос, который выведет список из ФИО каждого покупателя и названий 2
-- товаров, на которые этот покупатель потратил больше всего денег в прошлом году.

-- я решила вывести итог в виде таблицы с фио и списком товаров через запятую
-- потом я подумала, что, возможно, это не то, что вы от меня хотели,
-- поэтому я сделала еще один вариант с двумя столбцами
WITH total AS (
    SELECT
        c.FIO,
        p.product,
        o.price,
        o.quantity,
        (o.price * o.quantity) AS total_price
    FROM Customers AS c
    LEFT JOIN Orders AS o ON c.id = o.cust_id
    LEFT JOIN Products AS p ON o.prod_id = p.id
    WHERE EXTRACT(YEAR FROM o.dat) = EXTRACT(YEAR FROM CURRENT_DATE) - 1
),
almost_done AS (
    SELECT
        FIO,
        product,
        SUM(total_price) AS s_tot,
        ROW_NUMBER() OVER (PARTITION BY FIO ORDER BY SUM(total_price) DESC) AS r
    FROM total
    GROUP BY FIO, product
)
SELECT FIO, STRING_AGG(product, ', ' ORDER BY r) as most_spent FROM almost_done
WHERE r <= 2
GROUP BY FIO
ORDER BY FIO;

-- второй вариант запроса
WITH total AS (
    SELECT
        c.FIO,
        p.product,
        o.price,
        o.quantity,
        (o.price * o.quantity) AS total_price
    FROM Customers AS c
    LEFT JOIN Orders AS o ON c.id = o.cust_id
    LEFT JOIN Products AS p ON o.prod_id = p.id
    WHERE EXTRACT(YEAR FROM o.dat) = EXTRACT(YEAR FROM CURRENT_DATE) - 1
),
almost_done AS (
    SELECT
        FIO,
        product,
        SUM(total_price) AS s_tot,
        ROW_NUMBER() OVER (PARTITION BY FIO ORDER BY SUM(total_price) DESC) AS r
    FROM total
    GROUP BY FIO, product
)
SELECT
    FIO,
    MAX(CASE WHEN r = 1 THEN product END) AS most_bought_1,
    MAX(CASE WHEN r = 2 THEN product END) AS most_bought_2
FROM almost_done
WHERE r <= 2
GROUP BY FIO
ORDER BY FIO;