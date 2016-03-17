IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'NRTTECH\david.liu')
CREATE LOGIN [NRTTECH\david.liu] FROM WINDOWS
GO
CREATE USER [NRTTECH\david.liu] FOR LOGIN [NRTTECH\david.liu]
GO
