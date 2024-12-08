-- POSTGRESQL
-- задание 6
-- создание таблиц

CREATE TABLE Transactions (
    Client_id INT NOT NULL,
    Report_date DATE NOT NULL,
    Txn_amount INT NOT NULL
);

CREATE TABLE Rates (
    Report_date DATE NOT NULL,
    CCY_code INT NOT NULL,
    CCY_rate NUMERIC(10, 4) NOT NULL
);

INSERT INTO Transactions (Client_id, Report_date, Txn_amount) VALUES
(123456, '2020-01-05', 5000),
(123457, '2020-01-15', 2000),
(123456, '2020-01-20', 15000),
(123458, '2020-02-01', 7000);

INSERT INTO Rates (Report_date, CCY_code, CCY_rate) VALUES
('2019-12-31', 840, 61.91),
('2020-01-10', 840, 61.26),
('2020-01-15', 840, 61.50),
('2020-02-01', 840, 100);

-- Напишите sql запрос, который будет переводить сумму транзакций в usd (ccy_code = 840)
-- с учётом того, что в таблице rates данные только за рабочие дни. Транзакции, совершенные в
-- выходные, пересчитываются по курсу последнего рабочего дня перед праздником/выходным.
-- Результат: Клиент, дата, сумма транзакций в usd.

-- подзапрос на получение курсов на каждую дату
-- если на дату нет курса (например это праздник), то я беру прошлую дату, ближайшую к этой
WITH good_rates AS (
    SELECT
        r1.Report_date,
        r1.CCY_rate
    FROM Rates AS r1
    WHERE r1.CCY_code = 840

    UNION ALL

    SELECT
        t.Report_date,
        (
            SELECT r2.CCY_rate
            FROM Rates AS r2
            WHERE r2.CCY_code = 840
              AND r2.Report_date <= t.Report_date
            ORDER BY r2.Report_date DESC
            LIMIT 1
        ) AS CCY_rate
    FROM Transactions AS t
    WHERE NOT EXISTS (
        SELECT 1
        FROM Rates AS r3
        WHERE r3.CCY_code = 840 AND r3.Report_date = t.Report_date
    )
)
SELECT
    t.Client_id,
    t.Report_date,
    ROUND(t.Txn_amount / gr.CCY_rate, 2) AS txn_in_usdt
FROM Transactions AS t
LEFT JOIN good_rates AS gr
ON t.Report_date = gr.Report_date;