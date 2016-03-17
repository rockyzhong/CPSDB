IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'cps')
CREATE LOGIN [cps] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [cps] FOR LOGIN [cps]
GO
GRANT EXECUTE TO [cps]
GRANT VIEW DEFINITION TO [cps]
