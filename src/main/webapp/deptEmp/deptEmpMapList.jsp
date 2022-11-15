<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>
<%
	// 1. 요청분석
	request.setCharacterEncoding("utf-8");
	String word = request.getParameter("word");
	// 페이징
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	if(word!=null){
		System.out.println(word);
	}
	
	// 2) 요청처리
	// 페이징 rowPerPage
	int rowPerPage = 10;
	// db연결 -> 모델생성
	// 매개변수에 들어가는 문자열도 변수화하여 집어넣는게 좋다. (매개변수에는 값을 직접적으로 넣지 않는게 좋다)
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://localhost:3306/employees";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl,dbUser,dbPw); // "프로토콜://주소:포트번호","",""
	
	// lastPage 처리
	String cntSql = null;
	PreparedStatement cntStmt = null;
	
	if(word==null){
		cntSql = "SELECT COUNT(*) FROM salaries";
		cntStmt = conn.prepareStatement(cntSql);
	} else {
		cntSql = "SELECT COUNT(*) FROM dept_emp de INNER JOIN departments d ON de.dept_no = d.dept_no WHERE d.dept_name LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+word+"%");
		System.out.println("검색결과 갯수 불러오기 성공!");
	}
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0;
	if(cntRs.next()){
		cnt = cntRs.getInt("COUNT(*)");
	}
	int lastPage = cnt / rowPerPage;
	if(cnt % rowPerPage != 0){
		lastPage = lastPage + 1;
	}
	
	// 목록 불러오기
	String sql = null;
	PreparedStatement stmt = null;
	
	if(word == null){
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
		System.out.println("검색결과목록 출력!");
	}
	ResultSet rs = stmt.executeQuery();
	ArrayList<HashMap<String,Object>> list = new ArrayList<HashMap<String,Object>>();
	while(rs.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("empNo", rs.getInt("empNo"));
		m.put("deptNo", rs.getString("deptNo"));
		m.put("deptName", rs.getString("deptName"));
		m.put("fromDate", rs.getString("fromDate"));
		m.put("toDate", rs.getString("toDate"));
		m.put("name", rs.getString("name"));
		list.add(m);
	}
	rs.close();
	stmt.close();
	conn.close();
	// DeptEmp.class 가 없다면
	// deptEmpMapList.jsp
	//ArrayList<> list = new ArrayList<DeptEmp>();
	//while(rs.next()){
	// ....
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
			<form method="post" action="<%=request.getContextPath()%>/deptEmp/deptEmpMapList.jsp">
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
				for(HashMap<String, Object> m : list){
			%>		
					<tr>
						<td><%=m.get("deptNo")%></td>
						<td><%=m.get("deptName")%></td>
						<td><%=m.get("name")%></td>
						<td><%=m.get("empNo")%></td>
						<td><%=m.get("fromDate")%></td>
						<td><%=m.get("toDate")%></td>
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
					<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/deptEmp/deptEmpMapList.jsp?currentPage=1">처음</a>
					<%
						if(currentPage > 1){ // 이전
					%>		
							<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/deptEmp/deptEmpMapList.jsp?currentPage=<%=currentPage-1%>">←</a></li>
					<%		
						}
					%>
					<li class="page-item"><span class="page-link text-warning bg-dark"><%=currentPage%></span></li>
					<%
						if(currentPage < lastPage){ // 다음
					%>		
						<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/deptEmp/deptEmpMapList.jsp?currentPage=<%=currentPage+1%>">→</a></li>
					<%		
						}
					%>	
					<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/deptEmp/deptEmpMapList.jsp?currentPage=<%=lastPage%>">끝</a></li>
			<%						
				} else {
			%>
					<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/deptEmp/deptEmpMapList.jsp?currentPage=1&word=<%=word%>">처음</a>
					<%
						if(currentPage > 1){ // 이전
					%>		
							<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/deptEmp/deptEmpMapList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>">←</a></li>
					<%		
						}
					%>
					<li class="page-item"><span class="page-link text-warning bg-dark"><%=currentPage%></span></li>
					<%
						if(currentPage < lastPage){ // 다음
					%>		
						<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/deptEmp/deptEmpMapList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>">→</a></li>
					<%		
						}
					%>	
					<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/deptEmp/deptEmpMapList.jsp?currentPage=<%=lastPage%>&word=<%=word%>">끝</a></li>
			<%		
				}
			%>
		</ul>
	</div>
</body>
</html>