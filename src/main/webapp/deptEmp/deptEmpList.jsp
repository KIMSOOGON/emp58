<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="vo.*"%>
<%@ page import="java.util.*"%>
<%
	// 1. 요청분석
	request.setCharacterEncoding("utf-8");
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	String word = request.getParameter("word");
	
	// 2. 업무처리
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://localhost:3306/employees";
	String dbUser = "root";
	String dbPw = "java1234";
	
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl,dbUser,dbPw);
	
	// 페이징
	int rowPerPage = 10;
	
	// lastPage 처리
	String cntSql = null;
	PreparedStatement cntStmt = null;
	
	if(word==null){
		cntSql = "SELECT COUNT(*) FROM dept_emp";
		cntStmt = conn.prepareStatement(cntSql);
	} else {
		cntSql = "SELECT COUNT(*) FROM dept_emp de INNER JOIN departments d ON de.dept_no = d.dept_no WHERE d.dept_name LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+word+"%");
	}
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0;
	if(cntRs.next()){
		cnt = cntRs.getInt("COUNT(*)");
	}
	int lastPage = cnt / rowPerPage;
	if(cnt % rowPerPage != 0){
		lastPage = lastPage++;
	}
	
	// 목록 출력 쿼리
	String sql = null;
	PreparedStatement stmt = null;
	
	if(word==null){
		sql = "SELECT de.emp_no empNo, de.dept_no deptNo, d.dept_name deptName, de.from_date fromDate, de.to_date toDate, CONCAT(e.first_name, ' ', e.last_name) name FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no ORDER BY de.dept_no ASC LIMIT ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, rowPerPage * (currentPage-1));
		stmt.setInt(2, rowPerPage);
	} else {
		sql = "SELECT de.emp_no empNo, de.dept_no deptNo, d.dept_name deptName, de.from_date fromDate, de.to_date toDate, CONCAT(e.first_name, ' ', e.last_name) name FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE d.dept_name LIKE ? ORDER BY de.dept_no ASC LIMIT ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+word+"%");
		stmt.setInt(2, rowPerPage * (currentPage-1));
		stmt.setInt(3, rowPerPage);
	}
	System.out.println("stmt: "+stmt);
	ResultSet rs = stmt.executeQuery();
	
	ArrayList<DeptEmp> deptEmpList = new ArrayList<DeptEmp>();
	while(rs.next()){
		DeptEmp de = new DeptEmp();
		de.emp = new Employee();
		de.emp.empNo = rs.getInt("empNo");
		de.emp.firstName = rs.getString("name");
		de.dept = new Department();
		de.dept.deptNo = rs.getString("deptNo");
		de.dept.deptName = rs.getString("deptName");
		de.fromDate = rs.getString("fromDate");
		de.toDate = rs.getString("toDate");
		deptEmpList.add(de);
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
		<h1 class="container mt-3 p-3 text-center bg-dark text-warning rounded">부서 별 사원 목록</h1>
		
		<!-- 부서별 정렬하기 -->
		<div>
			<form method="post" action="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp">
				<label for="word">부서 검색 : </label>
				<input class="rounded" type="text" name="word"
						<%
							if(word != null){
						%>
								value="<%=word%>"
						<%
							} else {
						%>
								placeholder="부서 입력"
						<%
							}
						%> 
							id="word">
				<button class="btn btn-outline-primary btn-sm" type="submit">검색</button>
			</form>
		</div>
		<%
			if(word != null){
		%>
				<div>
					<span class="text-primary">'<%=word%>'</span> 검색 결과, 총 <span class="text-primary"><%=cnt%>건</span>이 검색되었습니다.
				</div>
		<%
			}
		%>
		<table class="table table-hover text-center">
			<tr style="background-color:pink">
				<th>부서번호</th>
				<th>부서명</th>
				<th>이름</th>
				<th>사원번호</th>
				<th>입사날짜</th>
				<th>퇴사날짜</th>
			</tr>
			<%
				for(DeptEmp de : deptEmpList){
			%>		
					<tr>
						<td><%=de.dept.deptNo%></td>
						<td><%=de.dept.deptName%></td>
						<td><%=de.emp.firstName%></td>
						<td><%=de.emp.empNo%></td>
						<td><%=de.fromDate%></td>
						<td><%=de.toDate%></td>
					</tr>
			<%		
				}
			%>
		</table>
		
		<!-- 페이징 처리 -->
		<ul class="pagination justify-content-center">
			<%
				if(word==null){
			%>
					<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=1">처음</a>
					<%
						if(currentPage > 1){ // 이전
					%>		
							<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage-1%>">이전</a></li>
					<%		
						}
					%>
					<li class="page-item"><span class="page-link text-warning bg-dark"><%=currentPage%></span></li>
					<%
						if(currentPage < lastPage){ // 다음
					%>		
						<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage+1%>">다음</a></li>
					<%		
						}
					%>	
					<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=lastPage%>">끝</a></li>
			<%						
				} else {
			%>
					<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=1&word=<%=word%>">처음</a>
					<%
						if(currentPage > 1){ // 이전
					%>		
							<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>">이전</a></li>
					<%		
						}
					%>
					<li class="page-item"><span class="page-link text-warning bg-dark"><%=currentPage%></span></li>
					<%
						if(currentPage < lastPage){ // 다음
					%>		
						<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>">다음</a></li>
					<%		
						}
					%>	
					<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=lastPage%>&word=<%=word%>">끝</a></li>
			<%		
				}
			%>
			</ul>
	</div>
</body>
</html>