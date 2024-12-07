-- POSTGRESQL
-- задание 6
-- создание таблиц
-- создам таблицу users

-- таблица по итогу не пригодилась((
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE Friends (
    user_id INT NOT NULL,
    friend_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (friend_id) REFERENCES Users(user_id)
);

CREATE TABLE Likes (
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- вставка данных

INSERT INTO Users (user_id, name) VALUES
(1, 'Макар'),
(2, 'Лиза'),
(3, 'Илик'),
(4, 'Рома');

INSERT INTO Friends (user_id, friend_id) VALUES
(1, 2),
(1, 3),
(2, 3),
(2, 4),
(3, 4);

INSERT INTO Likes (user_id, post_id) VALUES
(2, 101),
(2, 102),
(3, 101),
(3, 102),
(3, 103),
(1, 103),
(4, 103),
(4, 104),
(1, 105),
(2, 106);

-- Для некоторого пользователя user_id = 1 сформировать ленту рекомендаций, то есть список
-- постов в порядке убывания популярности среди его друзей. Из рекомендаций исключить посты,
-- которые пользователь уже лайкнул.

WITH t AS (SELECT l.post_id, COUNT(*) FROM Likes l
LEFT JOIN Friends f ON l.user_id = f.friend_id
WHERE f.user_id = 1
GROUP BY l.post_id)

SELECT t.post_id AS recommendation FROM t
LEFT JOIN Likes l ON t.post_id = l.post_id AND l.user_id = 1
WHERE l.post_id IS NULL
ORDER BY t.count DESC, t.post_id;




