<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import ="vo.*" %>
<%@ page import = "java.util.*" %>
<%
	// 1
	request.setCharacterEncoding("utf-8");
	String word = request.getParameter("word");
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	if(word!=null){
		System.out.println(word);
	}
	// 2
	int rowPerPage = 15;
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
	
	/*
	  SELECT s.emp_no empNo
	     , s.salary salary
	     , s.from_date fromDate
	     , s.to_date toDate
	     , e.first_name firstName 
	     , e.last_name lastName
	  from
	  salaries s INNER JOIN employees e 
	  ON s.emp_no = e.emp_no
	  LIMIT ?, ?   
	*/
	
	// lastPage 처리
	String cntSql = null;
	PreparedStatement cntStmt = null;
	
	if(word==null){
		cntSql = "SELECT COUNT(*) FROM salaries";
		cntStmt = conn.prepareStatement(cntSql);
		System.out.println("-- 삐빅, word null, 전체 갯수 확인중 --");
	} else {
		cntSql = "SELECT COUNT(*) FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE e.first_name LIKE ? OR e.last_name LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+word+"%");
		cntStmt.setString(2, "%"+word+"%");
		System.out.println("-- 빠밤, 검색결과 갯수 확인중 --");
	}
	
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0;
	if(cntRs.next()){
		cnt = cntRs.getInt("COUNT(*)");
	}
	int lastPage = cnt / rowPerPage;
	if(cnt % rowPerPage !=0){
		lastPage = lastPage + 1;
	}
		
	// 페이지 당 출력될 salaries List
	String sql = null;
	PreparedStatement stmt = null;
	
	if(word == null){
		sql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no ASC LIMIT ?,?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, rowPerPage * (currentPage -1));
		stmt.setInt(2, rowPerPage);
		System.out.println("-- 삐빅, word null, 전체 목록 출력중 --");
	} else {
		sql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE e.first_name LIKE ? OR e.last_name LIKE ? ORDER BY s.emp_no ASC LIMIT ?,?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+word+"%");
		stmt.setString(2, "%"+word+"%");
		stmt.setInt(3, rowPerPage * (currentPage -1));
		stmt.setInt(4, rowPerPage);
		System.out.println("-- 빠밤, 검색결과 출력중 --");
	}
	ResultSet rs = stmt.executeQuery();
	ArrayList<Salary> salaryList = new ArrayList<>();
	while(rs.next()){
		Salary s = new Salary();
		s.emp = new Employee(); // ☆☆☆☆☆
		s.emp.empNo = rs.getInt("empNo");
		s.salary = rs.getInt("salary");
		s.fromDate = rs.getString("fromDate");
		s.toDate = rs.getString("toDate");
		s.emp.firstName = rs.getString("firstName");
		s.emp.lastName = rs.getString("lastName");
		salaryList.add(s);
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
		<h2 class="container mt-3 p-3 text-center bg-dark text-warning rounded">급여 지급 내역</h2>
		
		<!-- 사원 검색 -->
		<div class="container mt-2 p-2">
			<form method="post" action="<%=request.getContextPath()%>/salary/salaryList1.jsp">
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
		<table class="table text-center rounded" >
			<tr style="background-color:pink">
				<th>사번</th>
				<th>급여($)</th>
				<th>기간(1년)</th>
				<th colspan="2">NAME</th>
			</tr>
			<%
				for(Salary s : salaryList){
			%>
					<tr>
			             <td><%=s.emp.empNo%></td>
				         <td><%=s.salary%></td>
				         <td><%=s.fromDate%> ~ <%=s.toDate%></td>
				         <td><%=s.emp.firstName%></td>
				         <td><%=s.emp.lastName%></td>
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
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/salary/salaryList1.jsp?currentPage=1">1st</a></li>
		<%	
				if(currentPage>1){ // 이전
		%>
					<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/salary/salaryList1.jsp?currentPage=<%=currentPage-1%>">before</a></li>
		<%
				}
				if(currentPage-1>1&&currentPage>lastPage-1){ // -2
		%>
					<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/salary/salaryList1.jsp?currentPage=<%=currentPage-2%>"><%=currentPage-2%></a></li>
		<%
				}
				if(currentPage>1){ // -1
		%>
					<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/salary/salaryList1.jsp?currentPage=<%=currentPage-1%>"><%=currentPage-1%></a></li>
		<%
				}
		%>
				<!-- 현재page -->
				<li class="page-item"><span class="page-link text-warning bg-dark"><%=currentPage%></span></li>
		<%
				if(currentPage<lastPage){ // +1
		%>
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/salary/salaryList1.jsp?currentPage=<%=currentPage+1%>"><%=currentPage+1%></a></li>
		<%
				}
				if(currentPage+1<lastPage&&currentPage<2){ // +2
		%>
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/salary/salaryList1.jsp?currentPage=<%=currentPage+2%>"><%=currentPage+2%></a></li>
		<%
				}
				if(currentPage<lastPage){ // 다음
		%>
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/salary/salaryList1.jsp?currentPage=<%=currentPage+1%>">next</a></li>
		<%
				}
		%>		
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/salary/salaryList1.jsp?currentPage=<%=lastPage%>">End</a></li>
		<%
			} else { // 검색할 경우 word 페이징 처리해주기
		%>		
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/salary/salaryList1.jsp?currentPage=1&word=<%=word%>">1st</a></li>
		<%	
				if(currentPage>1){ // 이전
		%>
					<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/salary/salaryList1.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>">before</a></li>
		<%
				}
				if(currentPage-1>1&&currentPage>lastPage-1){ // -2
		%>
					<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/salary/salaryList1.jsp?currentPage=<%=currentPage-2%>&word=<%=word%>"><%=currentPage-2%></a></li>
		<%
				}
				if(currentPage>1){ // -1
		%>
					<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/salary/salaryList1.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>"><%=currentPage-1%></a></li>
		<%
				}
		%>
				<!-- 현재페이지 -->
				<li class="page-item"><span class="page-link text-warning bg-dark"><%=currentPage%></span></li>
		<%
				if(currentPage<lastPage){ // +1
		%>
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/salary/salaryList1.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>"><%=currentPage+1%></a></li>
		<%
				}
				if(currentPage+1<lastPage&&currentPage<2){ // +2
		%>
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/salary/salaryList1.jsp?currentPage=<%=currentPage+2%>&word=<%=word%>"><%=currentPage+2%></a></li>
		<%
				}
				if(currentPage<lastPage){ // 다음
		%>
					<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/salary/salaryList1.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>">next</a></li>
		<%
				}
		%>
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/salary/salaryList1.jsp?currentPage=<%=lastPage%>&word=<%=word%>">End</a></li>
		<%
			}
		%>
		</ul>
	</div>
</body>
</html>