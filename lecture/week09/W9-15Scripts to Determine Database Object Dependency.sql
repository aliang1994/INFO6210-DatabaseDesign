
/* Scripts to determine database object dependency */


USE LIANG_WENQING_TEST;


SELECT DB_NAME() AS dbname, 
 o.type_desc AS referenced_object_type, 
 d1.referenced_entity_name, 
 d1.referenced_id,  
 (SELECT ', ' + OBJECT_NAME(d2.referencing_id)
    FROM sys.sql_expression_dependencies d2
    WHERE d2.referenced_id = d1.referenced_id
    ORDER BY OBJECT_NAME(d2.referencing_id)
    FOR XML PATH('')) AS dependent_objects_list
FROM sys.sql_expression_dependencies  d1 
JOIN sys.objects o 
ON  d1.referenced_id = o.[object_id]
GROUP BY o.type_desc, d1.referenced_id, d1.referenced_entity_name
ORDER BY o.type_desc, d1.referenced_entity_name;

/* Improve report formatting with the STUFF function */

SELECT 
	DB_NAME() AS dbname, 
	o.type_desc AS referenced_object_type, 
	d1.referenced_entity_name,
	d1.referenced_id, 
	STUFF( (SELECT ', ' + OBJECT_NAME(d2.referencing_id)
	FROM sys.sql_expression_dependencies d2
	WHERE d2.referenced_id = d1.referenced_id
	ORDER BY OBJECT_NAME(d2.referencing_id)
	FOR XML PATH('')), 1, 1, '') AS dependent_objects_list
FROM sys.sql_expression_dependencies  d1 
JOIN sys.objects o 
ON  d1.referenced_id = o.[object_id]
GROUP BY o.type_desc, d1.referenced_id, d1.referenced_entity_name
ORDER BY o.type_desc, d1.referenced_entity_name;

/* More details about the STUFF function can be found at:
https://msdn.microsoft.com/en-us/library/ms188043.aspx
*/

/* Use FOR XML PATH to format report */

-- Without using FOR XML PATH

SELECT ', ' + OBJECT_NAME(referencing_id)
FROM sys.sql_expression_dependencies
ORDER BY OBJECT_NAME (referencing_id);

-- Use FOR XML PATH to format report

SELECT ', ' + OBJECT_NAME(referencing_id)
FROM sys.sql_expression_dependencies
ORDER BY OBJECT_NAME (referencing_id)
FOR XML PATH('');

/* More details about Use FOR XML PATH can be found at:
https://msdn.microsoft.com/en-us/library/bb510462.aspx
*/









