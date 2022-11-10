<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import ="vo.*" %>
<%@ page import = "java.util.*" %>
<%
	// 1
	// 페이지 알고리즘
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 2
	int rowPerPage = 10;
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
	// lastPage 처리
	String countSql = "SELECT COUNT(*) FROM employees";
	PreparedStatement countStmt = conn.prepareStatement(countSql); 
	ResultSet countRs = countStmt.executeQuery();
	int count = 0;
	if(countRs.next()){
		count = countRs.getInt("COUNT(*)");
	}
	
	int lastPage = count / rowPerPage;
	if(count % rowPerPage != 0){
		lastPage = lastPage + 1; // lastPage++, lastPage+=1
	}
	
	// 한페이지당 출력할 emp 목록
	String empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees ORDER BY emp_no ASC LIMIT ?, ?";
	PreparedStatement empStmt = conn.prepareStatement(empSql);
	empStmt.setInt(1, rowPerPage * (currentPage -1));
	empStmt.setInt(2, rowPerPage);
	ResultSet empRs = empStmt.executeQuery();
	
	ArrayList<Employee> empList = new ArrayList<Employee>();
	while(empRs.next()){
		Employee e = new Employee();
		e.empNo = empRs.getInt("empNo");
		e.firstName = empRs.getString("firstName");
		e.lastName = empRs.getString("lastName");
		empList.add(e);
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body style="background-color:rgb(247,240,230)">
	<!-- 메뉴 partial jsp 구성 -->
	<div>
		<jsp:include page="../inc/menu.jsp"></jsp:include>
	</div>
	
	<div class="container rounded bg-light">
	<h1 class="container mt-3 p-3 text-center bg-dark text-warning">사원목록</h1>
	<div><mark class="text-primary">현재 페이지 : <%=currentPage%></mark></div>
	<table class="table table-border table-hover">
		<tr>
			<th>사원번호</th>
			<th>FirstName</th>
			<th>LastName</th>
		</tr>
		<%
			for(Employee e : empList){
		%>
				<tr>
					<td><%=e.empNo%></td>
					<td><%=e.firstName%></td>
					<td><%=e.lastName%></td>
				</tr>
		<%
			}
		%>
	</table>
	<!-- 페이징 코드 -->
	<div>
		<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1">첫페이지</a>
		<%
			if(currentPage > 1){
		%>
				<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>">이전</a>
		<%
			}
		
			if(currentPage < lastPage){
		%>
				<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>">다음</a>
		<%
			}
		%>
		<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>">마지막페이지</a>
	</div>
	</div>
</body>
</html>