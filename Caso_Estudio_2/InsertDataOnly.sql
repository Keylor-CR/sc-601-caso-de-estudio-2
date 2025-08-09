-- =============================================
-- Script SOLO para insertar datos de productos
-- Caso de Estudio 2 - Tienda Deportiva  
-- =============================================

USE [Caso2DB];
GO

-- Limpiar productos existentes
PRINT 'Limpiando productos existentes...';
DELETE FROM [Products];

-- Resetear IDENTITY
DBCC CHECKIDENT ('Products', RESEED, 0);

-- Insertar productos por categoría
PRINT 'Insertando 20 productos de ejemplo...';

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

PRINT '✅ 20 productos insertados correctamente';

-- Verificar resultados
SELECT 
    Category AS 'Categoría',
    COUNT(*) AS 'Cantidad',
    MIN(Price) AS 'Precio Min',
    MAX(Price) AS 'Precio Max',
    SUM(Stock) AS 'Stock Total'
FROM Products 
GROUP BY Category
ORDER BY Category;

PRINT 'Datos listos para usar ✅';
