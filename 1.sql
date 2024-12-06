-- POSTGRESQL
-- задание 1
-- создание таблицы
create table Empl (
id int,
start_time date,
final_time date
);

-- вставка данных
INSERT INTO Empl (id, start_time, final_time)
VALUES
  (1, '2023-01-01', '2023-12-31'),
  (2, '2022-06-15', '2023-06-14'),
  (3, '2024-03-01', '2024-12-31');

-- Нужно написать SQL-запрос, который выведет список сотрудников, которые уволились в этом месяце.
-- Не уточняется, какие поля надо вывести, выведу только айдишники
SELECT id FROM Empl
WHERE EXTRACT(MONTH FROM final_time) = EXTRACT(MONTH FROM CURRENT_DATE);
