create database Healthcare_data;
use Healthcare_data;

CREATE TABLE hospitals ( hospital_id INT AUTO_INCREMENT PRIMARY KEY,
  hospital_name VARCHAR(200) NOT NULL, city VARCHAR(100),
  state VARCHAR(100),postal_code VARCHAR(20));

CREATE TABLE doctors (
  doctor_id INT AUTO_INCREMENT PRIMARY KEY, first_name VARCHAR(100), last_name VARCHAR(100),
  specialty VARCHAR(100), hospital_id INT, FOREIGN KEY (hospital_id) REFERENCES hospitals(hospital_id));

CREATE TABLE patients (
  patient_id INT AUTO_INCREMENT PRIMARY KEY, first_name VARCHAR(100), last_name VARCHAR(100),
  date_of_birth DATE, gender ENUM('Male','Female','Other'), phone VARCHAR(20),
  email VARCHAR(150), hospital_id INT, FOREIGN KEY (hospital_id) REFERENCES hospitals(hospital_id));

CREATE TABLE appointments (
  appointment_id INT AUTO_INCREMENT PRIMARY KEY, patient_id INT, doctor_id INT, hospital_id INT,
  appointment_datetime DATETIME, status ENUM('Scheduled','Completed','Cancelled'), FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
  FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id), FOREIGN KEY (hospital_id) REFERENCES hospitals(hospital_id));

CREATE TABLE payments (
  payment_id INT AUTO_INCREMENT PRIMARY KEY, appointment_id INT, patient_id INT, amount DECIMAL(10,2),
  method ENUM('Cash','Card','UPI','Insurance'), status ENUM('Pending','Paid','Failed','Refunded'),
  payment_datetime DATETIME, FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id),
  FOREIGN KEY (patient_id) REFERENCES patients(patient_id));


CREATE TABLE first_names (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(50));
INSERT INTO first_names (name) VALUES
('Aarav'),('Vivaan'),('Aditya'),('Vihaan'),('Arjun'),
('Sai'),('Krishna'),('Rohan'),('Aryan'),('Dhruv'),
('Rahul'),('Siddharth'),('Manish'),('Kiran'),('Prakash'),
('Priya'),('Sneha'),('Meera'),('Ananya'),('Neha');

CREATE TABLE last_names (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(50));
INSERT INTO last_names (name) VALUES
('Sharma'),('Reddy'),('Patel'),('Gupta'),('Kumar'),
('Iyer'),('Nair'),('Mehta'),('Singh'),('Das'),
('Chowdhury'),('Banerjee'),('Joshi'),('Verma'),('Chopra');

CREATE TABLE numbers (n INT PRIMARY KEY);

INSERT INTO numbers (n)
SELECT t1.a + t10.a*10 + t100.a*100 + t1000.a*1000
FROM 
  (SELECT 0 a UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
   UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t1
CROSS JOIN 
  (SELECT 0 a UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
   UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t10
CROSS JOIN 
  (SELECT 0 a UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
   UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t100
CROSS JOIN 
  (SELECT 0 a UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
   UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t1000
WHERE t1.a + t10.a*10 + t100.a*100 + t1000.a*1000 BETWEEN 1 AND 10000;

INSERT INTO hospitals (hospital_name, city, state, postal_code)
SELECT CONCAT(ELT((n % 5)+1,'Apollo','Care','Global','Sunshine','Narayana'), ' Hospital ', n),
       ELT((n % 5)+1,'Hyderabad','Vijayawada','Guntur','Vizag','Tirupati'),
       'Andhra Pradesh',
       CONCAT('52', LPAD(n,3,'0'))
FROM numbers
WHERE n <= 5000;

INSERT INTO doctors (first_name,last_name,specialty,hospital_id)
SELECT fn.name, ln.name,
       ELT((n % 6)+1,'Cardiology','Orthopedics','Pediatrics','Dermatology','Neurology','General Medicine'),
       ((n - 1) % 5000) + 1
FROM numbers
JOIN first_names fn ON fn.id = ((n % (SELECT COUNT(*) FROM first_names)) + 1)
JOIN last_names ln ON ln.id = ((n % (SELECT COUNT(*) FROM last_names)) + 1)
WHERE n <= 5000;

INSERT INTO patients (first_name,last_name,date_of_birth,gender,phone,email,hospital_id)
SELECT fn.name, ln.name,
       DATE_ADD('1970-01-01', INTERVAL (n % 18000) DAY),
       ELT((n % 3)+1,'Male','Female','Other'),
       CONCAT('+91-', LPAD(7000000000+n,10,'0')),
       CONCAT(fn.name,'.',ln.name,n,'@mail.com'),
       ((n - 1) % 5000) + 1
FROM numbers
JOIN first_names fn ON fn.id = ((n % (SELECT COUNT(*) FROM first_names)) + 1)
JOIN last_names ln ON ln.id = ((n % (SELECT COUNT(*) FROM last_names)) + 1)
WHERE n <= 5000;

INSERT INTO appointments (patient_id,doctor_id,hospital_id,appointment_datetime,status)
SELECT ((n - 1) % 5000) + 1, ((n - 1) % 5000) + 1, ((n - 1) % 5000) + 1,
       DATE_ADD(NOW(), INTERVAL n HOUR),
       ELT((n % 3)+1,'Scheduled','Completed','Cancelled')
FROM numbers
WHERE n <= 5000;

INSERT INTO payments (appointment_id,patient_id,amount,method,status,payment_datetime)
SELECT ((n - 1) % 5000) + 1, ((n - 1) % 5000) + 1,
       ROUND(500 + (n % 10)*100,2),
       ELT((n % 4)+1,'Cash','Card','UPI','Insurance'),
       ELT((n % 4)+1,'Pending','Paid','Failed','Refunded'),
       DATE_ADD(NOW(), INTERVAL n MINUTE)
FROM numbers
WHERE n <= 5000;

-- Verify data import is successful
select * from appointments;
select * from doctors;
select * from hospitals;
select * from patients;
select * from payments;

-- 1.Different specialities
Select distinct specialty from doctors;
-- 2.Doctors by Speciality
Select doctor_id,first_name,last_name, specialty from doctors
where specialty= 'Orthopedics';
-- 3.Doctors in Orthopedics
select count(*) from doctors
where specialty= 'Orthopedics';
--  4.Doctors in 'Pediatrics'
Select doctor_id,first_name,last_name, specialty from doctors
where specialty= 'Pediatrics';
select count(*) from doctors
where specialty= 'Pediatrics';
-- 5.Doctors in Dermatology
Select doctor_id,first_name,last_name, specialty from doctors
where specialty= 'Dermatology';
select count(*) from doctors
where specialty= 'Dermatology';
-- 6.Doctors in Neurology
Select doctor_id,first_name,last_name, specialty from doctors
where specialty= 'Neurology';
select count(*) from doctors
where specialty= 'Neurology';
-- 7.Doctros in General Medicine
Select doctor_id,first_name,last_name, specialty from doctors
where specialty= 'General Medicine';
select count(*) from doctors
where specialty= 'General Medicine';
-- 8.Doctros in Cardiology
Select doctor_id,first_name,last_name, specialty from doctors
where specialty= 'Cardiology';
select count(*) from doctors
where specialty= 'Cardiology';
-- 9.List doctors ordered by specialty 
SELECT doctor_id, first_name, last_name, specialty FROM doctors ORDER BY specialty;

--  10.Different hospital data
Select distinct hospital_name from hospitals;
-- 11. city wise hospital data
select hospital_name, city from hospitals;
-- 12. No.of Hospitals in Guntur 
select count(*) from hospitals where city= 'Guntur';
-- 13.No.of care hospitals in city Tirupati
Select hospital_name,city from hospitals where hospital_name= 'Care Hospital 123';
-- 14.List of Hospitals order by city(City-wise hospital data)
Select hospital_name,city from hospitals order by city;
-- 15.List of Hospitals order by postal_code
Select hospital_name,postal_code,city from hospitals order by postal_code;

-- Patients data
select * from patients;
-- 16.No.of Female Patients
select count(patient_id) from patients where gender='Female';
-- 17.No.of male patients
select count(patient_id) from patients where gender='Male';
-- 18.Calculate each patient's age
SELECT patient_id, first_name, last_name, TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) AS age
FROM patients;
-- 19. Count patients by age
SELECT TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) AS age, COUNT(*) AS total_patients
FROM patients GROUP BY age ORDER BY age;
-- 20.Group patients into age ranges
SELECT CASE
         WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) < 18 THEN 'Child'
         WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 18 AND 35 THEN 'Young Adult'
         WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 36 AND 60 THEN 'Adult'
         ELSE 'Senior'
       END AS age_group,
       COUNT(*) AS total_patients
FROM patients
GROUP BY age_group;
-- 21.Oldest patient
SELECT patient_id, first_name, last_name, date_of_birth,
       TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) AS age
FROM patients
ORDER BY date_of_birth ASC
LIMIT 1;
-- 22.Youngest patient
SELECT patient_id, first_name, last_name, date_of_birth,
       TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) AS age
FROM patients
ORDER BY date_of_birth DESC
LIMIT 1;
-- 23.Payments info
select distinct status from payments;
select distinct method from payments;
-- 24.count of patients, when payment is failed
select count(*) from payments where status= 'failed';
select count(*) from payments where status= 'refunded';
select count(*) from payments where status= 'Pending';
-- 25.No.of failed transactions, via UPI
select count(*) from payments where status= 'failed' and method='UPI';
-- 26.No.of failed transactions, via Card
select count(*) from payments where status= 'failed' and method='card';
-- 27.No.of failed transactions, via Card
select count(*) from payments where status= 'failed' and method='cash';
-- 28. No.of failed transactions, via Insurance
select count(*) from payments where status= 'failed' and method='Insurance';
-- 29. No.of pending transactions, via Insurance
select count(*) from payments where status= 'pending' and method='Insurance';
--  30. All payments made today
SELECT * from payments WHERE DATE(payment_datetime) = CURDATE();
-- 31.Payments made in the last 7 days
SELECT * FROM payments WHERE payment_datetime >= CURDATE() - INTERVAL 7 DAY;
-- 32.Payments made in December 2025
SELECT *  FROM payments WHERE YEAR(payment_datetime) = 2025 AND MONTH(payment_datetime) = 12;
-- 33. Total payment amount in December 2025
select sum(amount) from payments WHERE YEAR(payment_datetime) = 2025 AND MONTH(payment_datetime) = 12;
-- 34. Total payment amount today
SELECT sum(amount) from payments WHERE DATE(payment_datetime) = CURDATE();
-- 35. amount paid via UPI
SELECT sum(amount) from payments WHERE  method= 'UPI';
-- 36. Total no.of patients per Hospital
select h.hospital_name, count(p.patient_id) as TotalPatients  from hospitals h
join patients p on h.hospital_id=p.hospital_id
group by hospital_name
order by TotalPatients desc;
-- 37. Number of appointments per doctor
select concat(first_name,'',last_name) as Doctorname, count(appointment_id) from doctors
join appointments on doctors.doctor_id=appointments.doctor_id
group by Doctorname
order by count(appointment_id) desc;
-- 38. Average appointments per doctor per month
SELECT CONCAT(d.first_name, ' ', d.last_name) AS DoctorsName, DATE_FORMAT(a.appointment_datetime, '%Y-%m') AS month,
 COUNT(a.appointment_id) AS appointments_in_month FROM doctors d 
 JOIN appointments a ON d.doctor_id = a.doctor_id
 GROUP BY DoctorsName, month ORDER BY appointments_in_month DESC;
 -- 39.Total revenue per hospital
 select sum(p.amount) as TotalRevenue, h.hospital_name from payments p
 join patients T on p.patient_id=T.patient_id
 join hospitals h on T.hospital_id=h.hospital_id
 group by hospital_name
 order by TotalRevenue desc;
 -- 40. Average payment per appointment
 select avg(p.amount) as Avgpayment,a.appointment_id from payments p
 join appointments a on p.patient_id=a.patient_id
 group by a.appointment_id;
 -- 41. Top 5 doctors by revenue generated
 select concat(d.first_name,'',d.last_name) as DoctorName, sum(p.amount) as Revenue from doctors d
 join appointments a on a.doctor_id=d.doctor_id
 join payments p on a.appointment_id=p.appointment_id
 group by DoctorName
 order by Revenue desc limit 5;
 -- 42. Revenue per patient 
 SELECT p.patient_id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, SUM(pay.amount) AS total_spent
FROM patients p
JOIN appointments a ON p.patient_id = a.patient_id
JOIN payments pay ON a.appointment_id = pay.appointment_id
GROUP BY p.patient_id, patient_name
ORDER BY total_spent DESC;
-- 43. Doctor workload by hospital
SELECT h.hospital_name, d.first_name, COUNT(a.appointment_id) AS appointments_count FROM hospitals h
JOIN appointments a ON h.hospital_id = a.hospital_id
JOIN doctors d ON d.doctor_id = d.doctor_id
GROUP BY h.hospital_name, d.first_name
ORDER BY h.hospital_name, appointments_count DESC;
-- 44. Patients with failed payments
SELECT p.patient_id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name FROM patients p 
LEFT JOIN appointments a ON p.patient_id = a.patient_id 
LEFT JOIN payments pay ON a.appointment_id = pay.appointment_id 
WHERE pay.status='Failed';
-- 45.Patients with multiple hospitals visited
SELECT p.patient_id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, COUNT(DISTINCT h.hospital_id) AS hospitals_visited FROM patients p 
JOIN appointments a ON p.patient_id = a.patient_id 
JOIN hospitals h ON a.hospital_id = h.hospital_id 
GROUP BY p.patient_id, patient_name
HAVING hospitals_visited > 1 
ORDER BY hospitals_visited DESC;
-- 46. Patient lifetime value (LTV)
SELECT p.patient_id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, SUM(pay.amount) AS lifetime_value
FROM patients p
JOIN appointments a ON p.patient_id = a.patient_id
JOIN payments pay ON a.appointment_id = pay.appointment_id
GROUP BY p.patient_id, patient_name
ORDER BY lifetime_value DESC;
-- 47. Appointment-to-payment lag (days)
SELECT a.appointment_id, DATEDIFF(pay.payment_datetime, a.appointment_datetime) AS days_to_payment
FROM appointments a
JOIN payments pay ON a.appointment_id = pay.appointment_id
ORDER BY days_to_payment DESC;
-- 48. Patients with highest average spend per appointment
SELECT p.patient_id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
       AVG(pay.amount) AS avg_spend_per_appointment
FROM patients p
JOIN appointments a ON p.patient_id = a.patient_id
JOIN payments pay ON a.appointment_id = pay.appointment_id
GROUP BY p.patient_id, patient_name
ORDER BY avg_spend_per_appointment DESC
LIMIT 10;
-- 49. Doctors working across multiple hospitals
SELECT d.doctor_id, d.first_name, COUNT(DISTINCT h.hospital_id) AS hospitals_served FROM doctors d 
JOIN appointments a ON d.doctor_id = a.doctor_id 
JOIN hospitals h ON a.hospital_id = h.hospital_id
 GROUP BY d.doctor_id, d.first_name
 HAVING hospitals_served > 1
 ORDER BY hospitals_served DESC;
 -- 50. Patients with cancelled appointments
 SELECT p.patient_id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, 
 COUNT(a.appointment_id) AS cancelled_count FROM patients p 
 JOIN appointments a ON p.patient_id = a.patient_id WHERE a.status = 'Cancelled' 
 GROUP BY p.patient_id, patient_name ORDER BY cancelled_count DESC;
 -- 51. Hospital revenue vs cancellations
 SELECT h.hospital_name, SUM(pay.amount) AS total_revenue,
 SUM(CASE WHEN a.status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_appointments FROM hospitals h 
 JOIN appointments a ON h.hospital_id = a.hospital_id 
 LEFT JOIN payments pay ON a.appointment_id = pay.appointment_id 
 GROUP BY h.hospital_name ORDER BY total_revenue DESC;
 -- 52. Patient retention (appointments across multiple years)
SELECT p.patient_id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, COUNT(DISTINCT YEAR(a.appointment_datetime)) AS active_years FROM patients p 
JOIN appointments a ON p.patient_id = a.patient_id 
GROUP BY p.patient_id, patient_name
HAVING active_years > 1 ORDER BY active_years DESC;
-- 53. Doctor ranking by patient volume and revenue
SELECT d.first_name,
       COUNT(DISTINCT a.patient_id) AS unique_patients,
       SUM(pay.amount) AS total_revenue,
       RANK() OVER (ORDER BY SUM(pay.amount) DESC) AS revenue_rank,
       RANK() OVER (ORDER BY COUNT(DISTINCT a.patient_id) DESC) AS patient_rank
FROM doctors d
JOIN appointments a ON d.doctor_id = a.doctor_id
JOIN payments pay ON a.appointment_id = pay.appointment_id
GROUP BY d.first_name;
-- 54. Running Total of Hospital Revenue
SELECT h.hospital_name, DATE(a.appointment_datetime) AS day, 
SUM(pay.amount) AS daily_revenue, SUM(SUM(pay.amount)) OVER (PARTITION BY h.hospital_name ORDER BY DATE(a.appointment_datetime)) AS cumulative_revenue FROM hospitals h 
JOIN appointments a ON h.hospital_id = a.hospital_id 
JOIN payments pay ON a.appointment_id = pay.appointment_id 
GROUP BY h.hospital_name, day ORDER BY h.hospital_name, day;
-- 55. Patient Appointment History
SELECT p.patient_id,
       CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
       a.appointment_datetime,
       LAG(a.appointment_datetime) OVER (PARTITION BY p.patient_id ORDER BY a.appointment_datetime) AS previous_appointment,
       LEAD(a.appointment_datetime) OVER (PARTITION BY p.patient_id ORDER BY a.appointment_datetime) AS next_appointment
FROM patients p
JOIN appointments a ON p.patient_id = a.patient_id
ORDER BY p.patient_id, a.appointment_datetime;
-- 56. Average Payment vs Appointment Payment
SELECT a.appointment_id, pay.amount AS payment_amount, 
AVG(pay.amount) OVER (PARTITION BY a.hospital_id) AS avg_payment_in_hospital FROM appointments a 
JOIN payments pay ON a.appointment_id = pay.appointment_id;
-- 57. First appointment per patient
SELECT p.patient_id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, a.appointment_datetime,
ROW_NUMBER() OVER (PARTITION BY p.patient_id ORDER BY a.appointment_datetime) AS appointment_order
FROM patients p
JOIN appointments a ON p.patient_id = a.patient_id
ORDER BY p.patient_id, appointment_order;
-- 58. Top hospitals by monthly revenue
SELECT h.hospital_name, DATE_FORMAT(a.appointment_datetime, '%Y-%m') AS month, SUM(pay.amount) AS monthly_revenue, 
DENSE_RANK() OVER (PARTITION BY DATE_FORMAT(a.appointment_datetime, '%Y-%m')
 ORDER BY SUM(pay.amount) DESC) AS revenue_rank FROM hospitals h
JOIN appointments a ON h.hospital_id = a.hospital_id 
JOIN payments pay ON a.appointment_id = pay.appointment_id GROUP BY h.hospital_name, month;
-- 59.Days since last appointment
SELECT p.patient_id,
       CONCAT(p.first_name, ' ', p.last_name) AS patient_name, a.appointment_datetime, DATEDIFF(a.appointment_datetime,
		LAG(a.appointment_datetime) OVER (PARTITION BY p.patient_id ORDER BY a.appointment_datetime)) AS days_since_last
FROM patients p
JOIN appointments a ON p.patient_id = p.patient_id
ORDER BY p.patient_id, a.appointment_datetime;
-- 60. Next scheduled appointment
SELECT p.patient_id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, a.appointment_datetime,
LEAD(a.appointment_datetime) OVER (PARTITION BY p.patient_id ORDER BY a.appointment_datetime) AS next_appointment
FROM patients p
JOIN appointments a ON p.patient_id = a.patient_id
ORDER BY p.patient_id, a.appointment_datetime;
-- 61. Moving Average – 3 month rolling revenue
SELECT DATE_FORMAT(a.appointment_datetime, '%Y-%m') AS month, SUM(pay.amount) AS monthly_revenue,
       AVG(SUM(pay.amount)) OVER (ORDER BY DATE_FORMAT(a.appointment_datetime, '%Y-%m')
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_avg_revenue
FROM appointments a
JOIN payments pay ON a.appointment_id = pay.appointment_id
GROUP BY month
ORDER BY month;
-- 62. Identify latest appointment per doctor
SELECT d.first_name, a.appointment_id, a.appointment_datetime,
ROW_NUMBER() OVER (PARTITION BY d.doctor_id ORDER BY a.appointment_datetime DESC) AS rn
FROM doctors d
JOIN appointments a ON d.doctor_id = a.doctor_id
WHERE rn=1;
-- 63. Top 3 patients by lifetime spend
WITH ranked_patients AS ( SELECT p.patient_id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, SUM(pay.amount) AS total_spent, 
RANK() OVER (ORDER BY SUM(pay.amount) DESC) AS spend_rank FROM patients p 
JOIN appointments a ON p.patient_id = a.patient_id 
JOIN payments pay ON a.appointment_id = pay.appointment_id
GROUP BY p.patient_id, patient_name )
SELECT * FROM ranked_patients WHERE spend_rank <= 3;
-- 64. Next doctor assigned to patient
SELECT p.patient_id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, d.first_name,
 LEAD(d.first_name) OVER (PARTITION BY p.patient_id ORDER BY a.appointment_datetime) AS next_doctor FROM patients p
 JOIN appointments a ON p.patient_id = a.patient_id JOIN doctors d ON a.doctor_id = d.doctor_id;
-- 65.Payment percentile per patient
SELECT p.patient_id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
SUM(pay.amount) AS total_spent,
CUME_DIST() OVER (ORDER BY SUM(pay.amount)) AS spend_percentile
FROM patients p
JOIN appointments a ON p.patient_id = a.patient_id
JOIN payments pay ON a.appointment_id = pay.appointment_id
GROUP BY p.patient_id, patient_name;























