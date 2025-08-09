-- =============================================
-- Script de Inicialización Completo
-- Caso de Estudio 2 - Tienda Deportiva
-- =============================================

USE master;
GO

-- Crear base de datos si no existe
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'Caso2DB')
BEGIN
    CREATE DATABASE [Caso2DB];
END
GO

USE [Caso2DB];
GO

-- =============================================
-- 1. CREAR TABLA DE PRODUCTOS
-- =============================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Products' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[Products] (
        [IdProduct] INT IDENTITY(1,1) NOT NULL,
        [Name] NVARCHAR(100) NOT NULL,
        [Description] NVARCHAR(500) NULL,
        [Price] DECIMAL(18,2) NOT NULL,
        [Stock] INT NOT NULL,
        [Category] NVARCHAR(50) NOT NULL,
        CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED ([IdProduct] ASC),
        CONSTRAINT [CK_Products_Price] CHECK ([Price] > 0),
        CONSTRAINT [CK_Products_Stock] CHECK ([Stock] >= 0),
        CONSTRAINT [CK_Products_Category] CHECK ([Category] IN ('Futbol', 'Basquetbol', 'Natacion', 'Tenis'))
    );
    
    PRINT 'Tabla Products creada correctamente';
END
ELSE
BEGIN
    PRINT 'Tabla Products ya existe';
END
GO

-- =============================================
-- 2. CREAR TABLAS DE IDENTITY (ASP.NET Identity)
-- =============================================

-- Tabla de Roles
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='AspNetRoles' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[AspNetRoles] (
        [Id] NVARCHAR(128) NOT NULL,
        [Name] NVARCHAR(256) NOT NULL,
        CONSTRAINT [PK_dbo.AspNetRoles] PRIMARY KEY CLUSTERED ([Id] ASC)
    );
    
    CREATE UNIQUE NONCLUSTERED INDEX [RoleNameIndex] ON [dbo].[AspNetRoles] ([Name] ASC);
    PRINT 'Tabla AspNetRoles creada correctamente';
END
ELSE
BEGIN
    PRINT 'Tabla AspNetRoles ya existe';
END
GO

-- Tabla de Usuarios
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='AspNetUsers' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[AspNetUsers] (
        [Id] NVARCHAR(128) NOT NULL,
        [Email] NVARCHAR(256) NULL,
        [EmailConfirmed] BIT NOT NULL,
        [PasswordHash] NVARCHAR(MAX) NULL,
        [SecurityStamp] NVARCHAR(MAX) NULL,
        [PhoneNumber] NVARCHAR(MAX) NULL,
        [PhoneNumberConfirmed] BIT NOT NULL,
        [TwoFactorEnabled] BIT NOT NULL,
        [LockoutEndDateUtc] DATETIME NULL,
        [LockoutEnabled] BIT NOT NULL,
        [AccessFailedCount] INT NOT NULL,
        [UserName] NVARCHAR(256) NOT NULL,
        [FirstName] NVARCHAR(100) NULL,
        [LastName] NVARCHAR(100) NULL,
        CONSTRAINT [PK_dbo.AspNetUsers] PRIMARY KEY CLUSTERED ([Id] ASC)
    );
    
    CREATE UNIQUE NONCLUSTERED INDEX [UserNameIndex] ON [dbo].[AspNetUsers] ([UserName] ASC);
    PRINT 'Tabla AspNetUsers creada correctamente';
END
ELSE
BEGIN
    PRINT 'Tabla AspNetUsers ya existe';
END
GO

-- Tabla de Relación Usuario-Rol
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='AspNetUserRoles' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[AspNetUserRoles] (
        [UserId] NVARCHAR(128) NOT NULL,
        [RoleId] NVARCHAR(128) NOT NULL,
        CONSTRAINT [PK_dbo.AspNetUserRoles] PRIMARY KEY CLUSTERED ([UserId] ASC, [RoleId] ASC),
        CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[AspNetRoles] ([Id]) ON DELETE CASCADE,
        CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE
    );
    
    CREATE NONCLUSTERED INDEX [IX_UserId] ON [dbo].[AspNetUserRoles] ([UserId] ASC);
    CREATE NONCLUSTERED INDEX [IX_RoleId] ON [dbo].[AspNetUserRoles] ([RoleId] ASC);
    PRINT 'Tabla AspNetUserRoles creada correctamente';
END
ELSE
BEGIN
    PRINT 'Tabla AspNetUserRoles ya existe';
END
GO

-- Tabla de Claims de Usuario
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='AspNetUserClaims' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[AspNetUserClaims] (
        [Id] INT IDENTITY(1,1) NOT NULL,
        [UserId] NVARCHAR(128) NOT NULL,
        [ClaimType] NVARCHAR(MAX) NULL,
        [ClaimValue] NVARCHAR(MAX) NULL,
        CONSTRAINT [PK_dbo.AspNetUserClaims] PRIMARY KEY CLUSTERED ([Id] ASC),
        CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE
    );
    
    CREATE NONCLUSTERED INDEX [IX_UserId] ON [dbo].[AspNetUserClaims] ([UserId] ASC);
    PRINT 'Tabla AspNetUserClaims creada correctamente';
END
ELSE
BEGIN
    PRINT 'Tabla AspNetUserClaims ya existe';
END
GO

-- Tabla de Logins de Usuario
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='AspNetUserLogins' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[AspNetUserLogins] (
        [LoginProvider] NVARCHAR(128) NOT NULL,
        [ProviderKey] NVARCHAR(128) NOT NULL,
        [UserId] NVARCHAR(128) NOT NULL,
        CONSTRAINT [PK_dbo.AspNetUserLogins] PRIMARY KEY CLUSTERED ([LoginProvider] ASC, [ProviderKey] ASC, [UserId] ASC),
        CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE
    );
    
    CREATE NONCLUSTERED INDEX [IX_UserId] ON [dbo].[AspNetUserLogins] ([UserId] ASC);
    PRINT 'Tabla AspNetUserLogins creada correctamente';
END
ELSE
BEGIN
    PRINT 'Tabla AspNetUserLogins ya existe';
END
GO

-- =============================================
-- 3. INSERTAR ROLES POR DEFECTO
-- =============================================
PRINT 'Insertando roles por defecto...';

-- Limpiar roles existentes si es necesario
DELETE FROM [AspNetUserRoles];
DELETE FROM [AspNetRoles];

-- Insertar roles
INSERT INTO [AspNetRoles] ([Id], [Name]) VALUES 
    (NEWID(), 'Admin'),
    (NEWID(), 'Usuario');

PRINT 'Roles insertados: Admin, Usuario';
GO

-- =============================================
-- 4. CREAR USUARIO ADMINISTRADOR POR DEFECTO
-- =============================================
PRINT 'Creando usuario administrador por defecto...';

DECLARE @AdminUserId NVARCHAR(128) = NEWID();
DECLARE @AdminRoleId NVARCHAR(128) = (SELECT Id FROM AspNetRoles WHERE Name = 'Admin');

-- Insertar usuario admin (admin@admin.com / admin123)
-- Password hash para 'admin123' generado con ASP.NET Identity
INSERT INTO [AspNetUsers] 
([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], 
 [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName], [FirstName], [LastName])
VALUES 
(@AdminUserId, 'admin@admin.com', 1, 
 'AQAAAAEAACcQAAAAEJOWJO5VK9vY8pFVh8XCkF5GKP8FG3P1W3HfRj9j3j7vPRZW8aJr7oZXGF3dFGk3KA==', 
 NEWID(), NULL, 0, 0, NULL, 1, 0, 'admin@admin.com', 'Admin', 'System');

-- Asignar rol de Admin al usuario
INSERT INTO [AspNetUserRoles] ([UserId], [RoleId]) VALUES (@AdminUserId, @AdminRoleId);

PRINT 'Usuario administrador creado:';
PRINT '  Email: admin@admin.com';
PRINT '  Password: admin123';
PRINT '  Rol: Admin';
GO

-- =============================================
-- 5. INSERTAR PRODUCTOS DE PRUEBA
-- =============================================
PRINT 'Insertando productos de prueba...';

-- Limpiar productos existentes
DELETE FROM [Products];

-- Resetear IDENTITY
DBCC CHECKIDENT ('Products', RESEED, 0);

-- Insertar productos por categoría
INSERT INTO [Products] ([Name], [Description], [Price], [Stock], [Category]) VALUES

-- FÚTBOL (5 productos)
('Balón de Fútbol Profesional', 'Balón tamaño 5 certificado FIFA, cuero sintético de alta calidad', 29.99, 50, 'Futbol'),
('Botines de Fútbol Nike', 'Botines de cuero sintético para césped natural con tacos de goma', 59.50, 40, 'Futbol'),
('Camiseta de Fútbol Oficial', 'Camiseta oficial de selección nacional, material Dri-FIT', 35.00, 30, 'Futbol'),
('Canilleras Profesionales', 'Protección ligera y resistente para jugadores profesionales', 12.99, 80, 'Futbol'),
('Guantes de Portero Adidas', 'Guantes con tecnología de agarre profesional, palma látex', 45.00, 25, 'Futbol'),

-- BÁSQUETBOL (5 productos)
('Balón de Básquetbol Spalding', 'Balón oficial de cuero compuesto tamaño 7, certificado FIBA', 34.99, 45, 'Basquetbol'),
('Zapatillas Jordan Basketball', 'Zapatillas de alta tracción con soporte de tobillo reforzado', 89.90, 35, 'Basquetbol'),
('Camiseta NBA Oficial', 'Camiseta sin mangas transpirable, material moisture-wicking', 22.50, 50, 'Basquetbol'),
('Aro de Básquet Regulable', 'Aro con red incluida para montaje en pared, altura ajustable', 60.00, 15, 'Basquetbol'),
('Muñequeras Nike', 'Muñequeras absorbentes de sudor, material elástico cómodo', 8.99, 60, 'Basquetbol'),

-- NATACIÓN (5 productos)
('Gafas de Natación Speedo', 'Lentes antivaho con protección UV y correa ajustable', 15.00, 70, 'Natacion'),
('Gorro de Natación Silicona', 'Gorro de silicona unisex, resistente al cloro', 7.50, 100, 'Natacion'),
('Bañador Hombre Competición', 'Bañador tipo slip resistente al cloro, secado rápido', 18.00, 40, 'Natacion'),
('Bañador Mujer Deportivo', 'Bañador deportivo una pieza con soporte ergonómico', 25.00, 35, 'Natacion'),
('Aletas de Entrenamiento', 'Aletas cortas para mejorar velocidad y técnica', 30.00, 20, 'Natacion'),

-- TENIS (5 productos)
('Raqueta de Tenis Wilson', 'Marco de grafito liviano con encordado de fábrica', 120.00, 25, 'Tenis'),
('Pelotas de Tenis Dunlop', 'Pack de 3 pelotas de presión alta, aprobadas por ITF', 6.99, 200, 'Tenis'),
('Grip Overgrip Pro', 'Empuñadura antideslizante con absorción de humedad', 4.50, 150, 'Tenis'),
('Bolso de Tenis Head', 'Bolso espacioso para raquetas y accesorios con correas ajustables', 45.00, 18, 'Tenis'),
('Red de Tenis Oficial', 'Red profesional para cancha estándar, material resistente', 150.00, 5, 'Tenis');

PRINT '20 productos insertados correctamente:';
PRINT '  - Fútbol: 5 productos';
PRINT '  - Básquetbol: 5 productos';
PRINT '  - Natación: 5 productos';
PRINT '  - Tenis: 5 productos';
GO

-- =============================================
-- 6. VERIFICACIÓN DE DATOS
-- =============================================
PRINT '============================================='
PRINT 'VERIFICACIÓN DE DATOS INSERTADOS'
PRINT '============================================='

-- Verificar productos por categoría
SELECT 
    Category AS 'Categoría',
    COUNT(*) AS 'Cantidad de Productos',
    MIN(Price) AS 'Precio Mínimo',
    MAX(Price) AS 'Precio Máximo',
    SUM(Stock) AS 'Stock Total'
FROM Products 
GROUP BY Category
ORDER BY Category;

PRINT '';

-- Verificar usuarios y roles
SELECT 
    u.UserName AS 'Usuario',
    u.Email AS 'Email',
    u.FirstName + ' ' + u.LastName AS 'Nombre Completo',
    r.Name AS 'Rol'
FROM AspNetUsers u
INNER JOIN AspNetUserRoles ur ON u.Id = ur.UserId
INNER JOIN AspNetRoles r ON ur.RoleId = r.Id
ORDER BY r.Name, u.UserName;

PRINT '';
PRINT 'INICIALIZACIÓN COMPLETA - SISTEMA LISTO PARA USAR';
PRINT '============================================='

-- Mostrar estadísticas finales
SELECT 
    'Productos' AS 'Tabla',
    COUNT(*) AS 'Registros'
FROM Products
UNION ALL
SELECT 
    'Usuarios' AS 'Tabla',
    COUNT(*) AS 'Registros'
FROM AspNetUsers
UNION ALL
SELECT 
    'Roles' AS 'Tabla',
    COUNT(*) AS 'Registros'
FROM AspNetRoles;

GO

PRINT '';
PRINT 'CREDENCIALES DE ACCESO:';
PRINT 'Administrador:';
PRINT '  Email: admin@admin.com';
PRINT '  Password: admin123';
PRINT '  Permisos: Crear, Editar, Eliminar productos';
PRINT '';
PRINT 'Para crear usuarios normales, usar el formulario de registro en la aplicación.';
