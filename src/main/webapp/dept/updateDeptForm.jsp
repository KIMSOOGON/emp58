<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "vo.*" %>
<%
	// 1. 요청분석
	request.setCharacterEncoding("utf-8");
	String deptNo = request.getParameter("deptNo");
	if(deptNo == null){ // deptList의 링크로 호출하지 않고 updateDeptForm.jsp 주소창에 직접 호출하면 deptNo는 null값이 된다.
		response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
		return;
	}
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
	
	Department dept = null;
	
	if(rs.next()){
		dept = new Department();
		dept.deptNo = deptNo;
		dept.deptName = rs.getString("deptName");
	}
	
	// 3. 출력
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>updateDeptFrom</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<style>
		table,th,tr,td{
			border:1px solid grey;
		}
	</style>
</head>
<body style="background-color:rgb(230,245,240)">
	<!-- 메뉴 partial jsp 구성 -->
	<div>
		<jsp:include page="../inc/menu.jsp"></jsp:include>
	</div>
	<h1 class="container mt-3 p-3 text-center bg-light rounded">부서명 수정</h1>
	<form method="post" action="<%=request.getContextPath()%>/dept/updateDeptAction.jsp">
		<table class="table table-hover table-bordered text-center" style="background-color:rgb(240,220,210)">
			<tr>
				<td>1) 부서번호</td>
				<td><input type="text" name="deptNo" value="<%=dept.deptNo%>" readonly="readonly"></td>
			</tr>
			<tr>
				<td>2) 부서이름</td>
				<td><input type="text" name="deptName" value="<%=dept.deptName%>"></td>
			</tr>	
		</table>
		<div class="text-center">
			<button type="submit" class="btn btn-outline-primary">Update</button>
		</div>
	</form>
</body>
</html>