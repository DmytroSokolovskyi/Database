# 1. +Вибрати усіх клієнтів, чиє ім'я має менше ніж 6 символів.
SELECT *
FROM client
WHERE LENGTH(FirstName) < 6;
#
# 2. +Вибрати львівські відділення банку.+
SELECT *
FROM department
WHERE DepartmentCity = 'Lviv';
#
# 3. +Вибрати клієнтів з вищою освітою та посортувати по прізвищу.
SELECT *
FROM client
WHERE Education = 'high'
ORDER BY LastName;
#
# 4. +Виконати сортування у зворотньому порядку над таблицею Заявка і вивести 5 останніх елементів.
SELECT *
FROM application
ORDER BY idApplication DESC
LIMIT 5 OFFSET 10;
#
# 5. +Вивести усіх клієнтів, чиє прізвище закінчується на OV чи OVA.
SELECT *
FROM client
WHERE LastName LIKE '%ov'
   OR LastName LIKE '%ova';
#
# 6. +Вивести клієнтів банку, які обслуговуються київськими відділеннями.
SELECT *
FROM client
         JOIN department on client.Department_idDepartment = idDepartment
WHERE DepartmentCity = 'Kyiv';
#
# 7. +Вивести імена клієнтів та їхні номера телефону, погрупувавши їх за іменами.
SELECT client.FirstName,
       client.Passport
FROM client
ORDER BY FirstName;
#
# 8. +Вивести дані про клієнтів, які мають кредит більше ніж на 5000 тисяч гривень.
SELECT FirstName,
       LastName,
       Sum
FROM client
         JOIN application ON client.idClient = application.Client_idClient
WHERE application.Sum > 5000;
#
# 9. +Порахувати кількість клієнтів усіх відділень та лише львівських відділень.
SELECT COUNT(idClient) AS lvivDepartment
FROM client
         JOIN department ON client.Department_idDepartment = idDepartment
WHERE DepartmentCity = 'Lviv';
#
# 10. Знайти кредити, які мають найбільшу суму для кожного клієнта окремо.
SELECT MAX(Sum) AS maxCredit,
       CONCAT(idClient, ' ', FirstName, ' ', LastName)
FROM application
         JOIN client c ON c.idClient = application.Client_idClient
GROUP BY idClient;
#
# 11. Визначити кількість заявок на крдеит для кожного клієнта.
SELECT COUNT(CreditState),
       FirstName
FROM application
         JOIN client c ON c.idClient = application.Client_idClient
GROUP BY idClient;
#
# 12. Визначити найбільший та найменший кредити.
SELECT MIN(Sum),
       MAX(Sum)
FROM application;
#
# 13. Порахувати кількість кредитів для клієнтів,які мають вищу освіту.
SELECT COUNT(idApplication) AS creditByHighEducation
FROM application
         JOIN client c ON c.idClient = application.Client_idClient
WHERE Education = 'high';
#
# 14. Вивести дані про клієнта, в якого середня сума кредитів найвища.
SELECT AVG(Sum) AS srSUM,
       FirstName,
       LastName
FROM client
         JOIN application a ON client.idClient = a.Client_idClient
GROUP BY Client_idClient
ORDER BY srSUM DESC
LIMIT 1;

# 15. Вивести відділення, яке видало в кредити найбільше грошей
SELECT SUM(Sum) AS sum,
       Department_idDepartment
FROM client
         JOIN application ON client.idClient = application.Client_idClient
GROUP BY Department_idDepartment
ORDER BY sum DESC
LIMIT 1;

#
# 16. Вивести відділення, яке видало найбільший кредит.
SELECT Department_idDepartment,
       MAX(Sum)
FROM application
         JOIN client c ON application.Client_idClient = c.idClient
GROUP BY Department_idDepartment
limit 1;
#
# 17. Усім клієнтам, які мають вищу освіту, встановити усі їхні кредити у розмірі 6000 грн.
UPDATE application
    JOIN client c ON c.idClient = application.Client_idClient
SET Sum = 6000
WHERE Education = 'high';
#
# 18. Усіх клієнтів київських відділень пересилити до Києва.
UPDATE client
    JOIN department d ON d.idDepartment = client.Department_idDepartment
SET City = 'Kyiv'
WHERE DepartmentCity = 'Kyiv';
#
# 19. Видалити усі кредити, які є повернені.
DELETE
FROM application
WHERE CreditState = 'Returned';
#
# 20. Видалити кредити клієнтів, в яких друга літера прізвища є голосною.
DELETE a
FROM application AS a
         JOIN client c on Client_idClient = c.idClient
WHERE FirstName RLIKE '^[^aeiou].*';
#
#
# Знайти львівські відділення, які видали кредитів на загальну суму більше ніж 5000
SELECT idDepartment,
       DepartmentCity,
       Sum
FROM department
         JOIN client c on department.idDepartment = c.Department_idDepartment
         JOIN application a on c.idClient = a.Client_idClient
WHERE DepartmentCity = 'Lviv'
  AND Sum > 5000
GROUP BY idDepartment, Sum;
#
#
# Знайти клієнтів, які повністю погасили кредити на суму більше ніж 5000
SELECT CONCAT(idClient, ' ',
              FirstName, ' ',
              LastName) AS client,
       Sum
FROM client
         JOIN application ON client.idClient = Client_idClient
WHERE Sum > 5000
  AND CreditState = 'Returned';
#
#
# /* Знайти максимальний неповернений кредит.*/
SELECT MAX(Sum)
FROM application
WHERE CreditState = 'Not Returned';
#
#
# /*Знайти клієнта, сума кредиту якого найменша*/

SELECT FirstName,
       MIN(Sum) AS minSum
FROM client
         JOIN application a ON client.idClient = a.Client_idClient
GROUP BY FirstName
ORDER BY minSum
LIMIT 1;

#
#
#
# /*Знайти кредити, сума яких більша за середнє значення усіх кредитів*/
SELECT Sum,
       idApplication
FROM application
WHERE Sum > (SELECT AVG(Sum) FROM application);
#
#
# /*Знайти клієнтів, які є з того самого міста, що і клієнт, який взяв найбільшу кількість кредитів*/
SELECT *
FROM client
WHERE City = (SELECT City
FROM client
         JOIN application a ON client.idClient = a.Client_idClient
GROUP BY Client_idClient
ORDER BY  COUNT(Sum)DESC
LIMIT 1);
#
#
# #місто чувака який набрав найбільше кредитів
SELECT City,
       COUNT(Sum) AS skolko
FROM client
         JOIN application a ON client.idClient =  a.Client_idClient
GROUP BY Client_idClient
ORDER BY skolko DESC
LIMIT 1;
