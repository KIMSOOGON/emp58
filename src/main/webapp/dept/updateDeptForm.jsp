<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "vo.*" %>
<%
	// 1. 요청분석
	request.setCharacterEncoding("utf-8");
	String deptNo = request.getParameter("deptNo");
	
	// 2. 업무처리
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("수정Form 드라이버로딩완료");
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://localhost:3306/employees","root","java1234");
	System.out.println("수정Form Connection 완료 :"+conn);
	String sql = "select dept_name deptName from departments where dept_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	System.out.println("수정Form stmt : "+stmt);
	stmt.setString(1,deptNo);
	ResultSet rs = stmt.executeQuery();
	
	String deptName = null;
	
	if(rs.next()){
		deptName = rs.getString("deptName");
	}
	
	// 3. 출력
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<h1>부서명 수정</h1>
	<form method="post" action="<%=request.getContextPath()%>/dept/updateDeptAction.jsp">
		<table>
			<tr>
				<td>부서번호</td>
				<td><input type="text" name="deptNo" value="<%=deptNo%>" readonly="readonly"></td>
			</tr>
			<tr>
				<td>부서이름</td>
				<td><input type="text" name="deptName" value="<%=deptName%>"></td>
			</tr>	
		</table>
		<button type="submit">Update</button>
	</form>
</body>
</html>