<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	request.setCharacterEncoding("utf-8");
	// 1. 요청분석(Controller)
	
	// 2. 업무처리(Model) -> 모델데이터(단일값 or 자료구조형태(배열, 리스트, ...))
	

	// (1) maria 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("1. 드라이버 로딩 성공"); // 디버깅
	
	// (2) 접속
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/employees","root","java1234");
	System.out.println("2. conn : "+conn); // 디버깅
	
	// (3) 쿼리 생성
	PreparedStatement stmt = conn.prepareStatement(
			"select dept_no deptNo,dept_name deptName from departments order by dept_no asc");
	System.out.println("3. stmt : "+stmt); // 디버깅
	
	// (4) 쿼리 실행
	ResultSet rs = stmt.executeQuery(); // <- 모델데이터 ResultSet은 일반적인 타입이 아니고 독립적인 타입도 아니다
	// ResultSet rs라는 모델자료구조를 좀더 일반적이고 독립적인 자료구조로 변경을 하자
	
	ArrayList<Department> list = new ArrayList<Department>();
	while(rs.next()){ // ResultSet의 API(사용방법)를 모른다면 사용할 수 없는 반복문
		Department d = new Department();
		d.deptNo = rs.getString("deptNO");
		d.deptName = rs.getString("deptName");
		list.add(d);
	}
	
	// 3. 출력(View) -> 모델데이터를 고객이 원하는 형태로 출력 -> 뷰(리포트)
	for(Department d : list){ // 자바문법에서 제공하는 포이치문
		
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	
	<style>
		table, td, th, tr {
			border: 1px solid pink;
			width: 10%;
			height: 50px;
			margin: auto;
		}
	</style>
</head>
<body style="background-color:rgb(247,240,230)">
	<h1 class="container text-center bg-light">Departments List</h1>
	<div class="container mt-3 text-center">
		<!-- 부서목록출력(부서번호 내림차순) -->
		<table class="table table-bordered">
			<thead>
				<tr>
					<th><mark>부서번호</mark></th>
					<th><mark>부서이름</mark></th>
					<th><mark>수정</mark></th>
					<th><mark>삭제</mark></th>
				</tr>
			</thead>
			<tbody>
				<%
					for(Department d : list){
				%>
					<tr>
						<td><%=d.deptNo%></td>
						<td><%=d.deptName%></td>
						<td><a class="btn btn-primary btn-sm" href="<%=request.getContextPath()%>/dept/updateDeptForm.jsp?deptNo=<%=d.deptNo%>">수정</a></td>
						<td><a class="btn btn-danger btn-sm" href="<%=request.getContextPath()%>/dept/deleteDept.jsp?deptNo=<%=d.deptNo%>">삭제</a></td>
					</tr>
				<%		
					}
				%>
			</tbody>
		</table>
	</div>
	<div class="container text-end">
		<a class="btn btn-outline-success btn-sm" href="<%=request.getContextPath()%>/dept/insertDeptForm.jsp">부서 추가</a>
	</div>
</body>
</html>