-- POSTGRESQL
-- задание 3
-- создание таблиц
create table Department (
dep varchar(50),
id int
);
create table Managers (
manger varchar(50),
dep int,
salary bigint
);

-- вставка данных
INSERT INTO Department (dep, id)
VALUES
  ('IT', 1),
  ('HR', 2),
  ('Finance', 3),
  ('Sales', 4),
  ('Marketing', 5),
  ('Business', 6);

INSERT INTO Managers (manger, dep, salary)
VALUES
  ('Alice', 1, 70000),
  ('Andrew', 1, 80000),
  ('Bob', 2, 55000),
  ('Charlie', 3, 80000),
  ('David', 4, 60000),
  ('Eva', 5, 65000);


-- Нужно написать SQL-запрос, который выведет список названий каждого отдела с максимальной
-- заработной платой его сотрудников (если в отделе нет сотрудников, то вывести в поле MAX(salary)
-- NULL).
-- Я отсортировала данные по максимальной зарплате, отделы, где нет сотрудников, находятся внизу списка
SELECT d.dep, MAX(m.salary) AS max_salary FROM Department AS d
LEFT JOIN Managers AS m ON d.id = m.dep
GROUP BY d.dep
ORDER BY max_salary DESC NULLS LAST;