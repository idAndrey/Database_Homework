WITH RECURSIVE
	Subordinates AS (
		SELECT 
			EmployeeID, 
			Name, 
			ManagerID, 
			DepartmentID, 
			RoleID
		FROM Employees
		WHERE ManagerID = 1  
		UNION ALL
		SELECT 
			e.EmployeeID, 
			e.Name, 
			e.ManagerID, 
			e.DepartmentID, 
			e.RoleID
		FROM Employees e
		INNER JOIN Subordinates s ON e.ManagerID = s.EmployeeID
	)
SELECT 
    s.EmployeeID AS EmployeeID,
    s.Name AS EmployeeName,
    s.ManagerID AS ManagerID,
    COALESCE(d.DepartmentName, 'NULL') AS DepartmentName, 
    COALESCE(r.RoleName, 'NULL') AS RoleName,              
    COALESCE((
        SELECT STRING_AGG(p.ProjectName, ', ') 
        FROM Projects p 
        WHERE p.DepartmentID = s.DepartmentID
    ), 'NULL') AS ProjectNames,                             
    COALESCE((
        SELECT STRING_AGG(t.TaskName, ', ') 
        FROM Tasks t 
        WHERE t.AssignedTo = s.EmployeeID
    ), 'NULL') AS TaskNames                                
FROM Subordinates s
LEFT JOIN Departments d ON s.DepartmentID = d.DepartmentID
LEFT JOIN Roles r ON s.RoleID = r.RoleID
ORDER BY s.Name;