IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'NRTTECH\zchen')
CREATE LOGIN [NRTTECH\zchen] FROM WINDOWS
GO
CREATE USER [NRTTECH\zchen] FOR LOGIN [NRTTECH\zchen]
GO
GRANT EXECUTE TO [NRTTECH\zchen]
GRANT VIEW DEFINITION TO [NRTTECH\zchen]
