<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%> <!-- HashMap<키,값>, ArrayList<요소> -->
<%
	// 1) 요청분석
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
	final int ROW_PER_PAGE = 15;
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
		cntSql = "SELECT COUNT(*) FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE e.first_name LIKE ? or e.last_name LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+word+"%");
		cntStmt.setString(2, "%"+word+"%");
	}
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0;
	if(cntRs.next()){
		cnt = cntRs.getInt("COUNT(*)");
	}
	int lastPage = cnt / ROW_PER_PAGE;
	if(cnt % ROW_PER_PAGE != 0){
		lastPage = lastPage + 1;
	}
	
	// salaries List
	String sql = null;
	PreparedStatement stmt = null;
	
	if(word == null){
		sql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, CONCAT(e.first_name, ' ', e.last_name) name FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no ASC LIMIT ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, ROW_PER_PAGE * (currentPage-1));
		stmt.setInt(2, ROW_PER_PAGE);
	} else {
		sql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, CONCAT(e.first_name, ' ', e.last_name) name FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE e.first_name LIKE ? or e.last_name LIKE ? ORDER BY s.emp_no ASC LIMIT ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+word+"%");
		stmt.setString(2, "%"+word+"%");
		stmt.setInt(3, ROW_PER_PAGE * (currentPage-1));
		stmt.setInt(4, ROW_PER_PAGE);
	}
	ResultSet rs = stmt.executeQuery();
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(rs.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("empNo", rs.getInt("empNo"));
		m.put("salary", rs.getInt("salary"));
		m.put("fromDate", rs.getString("fromDate"));
		m.put("name", rs.getString("name"));
		list.add(m); 
	}
	rs.close();
	stmt.close();
	conn.close();
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Salary List</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body style="background-color:rgb(247,240,230)">
	<!-- 메뉴 partial jsp 구성 -->
	<div>
		<jsp:include page="../inc/menu.jsp"></jsp:include>
	</div>
	<div class="container rounded bg-light">
		<h1 class="container mt-3 p-3 text-center bg-dark text-warning rounded">연봉 목록</h1>
		
		<!-- 사원 검색 -->
		<div class="container mt-2 p-2">
			<form method="post" action="<%=request.getContextPath()%>/salary/salaryMapList.jsp">
				<label for="word" class="text-primary">사원 찾기 : </label>
				<input class="rounded" type="text" name="word" 
						<%
							if(word != null){
						%>
								value="<%=word%>"
						<%
							} else {
						%>
								placeholder="이름을 입력하세요"
						<%
							}
						%> 
							id="word">
				<button class="btn btn-outline-dark btn-sm" type="submit">검색</button>
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
		
		<table class="table text-center rounded">
			<tr style="background-color:pink">
				<th>사원번호</th>
				<th>이름</th>
				<th>연봉</th>
				<th>계약일자</th>
			</tr>
			<%
				for(HashMap<String, Object> m : list){
			%>		
					<tr>
						<td><%=m.get("empNo")%></td>
						<td><%=m.get("name")%></td>
						<td><%=m.get("salary")%></td>
						<td><%=m.get("fromDate")%></td>
					</tr>	
			<%		
				}
			%>
		</table>
		<!-- 페이징코드 -->
		<ul class="pagination justify-content-center">
		<%
			if(word == null){ // 검색하지 않은 초기화면
		%>
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=1">1st</a></li>
		<%	
				if(currentPage>1){ // 이전
		%>
					<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=currentPage-1%>">before</a></li>
		<%
				}
				if(currentPage-1>1&&currentPage>lastPage-1){ // -2
		%>
					<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=currentPage-2%>"><%=currentPage-2%></a></li>
		<%
				}
				if(currentPage>1){ // -1
		%>
					<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=currentPage-1%>"><%=currentPage-1%></a></li>
		<%
				}
		%>
				<!-- 현재page -->
				<li class="page-item"><span class="page-link text-warning bg-dark"><%=currentPage%></span></li>
		<%
				if(currentPage<lastPage){ // +1
		%>
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=currentPage+1%>"><%=currentPage+1%></a></li>
		<%
				}
				if(currentPage+1<lastPage&&currentPage<2){ // +2
		%>
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=currentPage+2%>"><%=currentPage+2%></a></li>
		<%
				}
				if(currentPage<lastPage){ // 다음
		%>
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=currentPage+1%>">next</a></li>
		<%
				}
		%>		
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=lastPage%>">End</a></li>
		<%
			} else { // 검색할 경우 word 페이징 처리해주기
		%>		
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=1&word=<%=word%>">1st</a></li>
		<%	
				if(currentPage>1){ // 이전
		%>
					<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>">before</a></li>
		<%
				}
				if(currentPage-1>1&&currentPage>lastPage-1){ // -2
		%>
					<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=currentPage-2%>&word=<%=word%>"><%=currentPage-2%></a></li>
		<%
				}
				if(currentPage>1){ // -1
		%>
					<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>"><%=currentPage-1%></a></li>
		<%
				}
		%>
				<!-- 현재페이지 -->
				<li class="page-item"><span class="page-link text-warning bg-dark"><%=currentPage%></span></li>
		<%
				if(currentPage<lastPage){ // +1
		%>
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>"><%=currentPage+1%></a></li>
		<%
				}
				if(currentPage+1<lastPage&&currentPage<2){ // +2
		%>
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=currentPage+2%>&word=<%=word%>"><%=currentPage+2%></a></li>
		<%
				}
				if(currentPage<lastPage){ // 다음
		%>
					<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>">next</a></li>
		<%
				}
		%>
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=lastPage%>&word=<%=word%>">End</a></li>
		<%
			}
		%>
		</ul>
	</div>
</body>
</html>