<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import ="vo.*" %>
<%@ page import = "java.util.*" %>
<%
	// 1
	// 페이지 알고리즘
	request.setCharacterEncoding("utf-8");
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	String word = request.getParameter("word");

		
	
	// 2
	int rowPerPage = 10;
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
	
	// lastPage 처리
	String cntSql = null;
	PreparedStatement cntStmt = null;
	
	if(word==null){
		cntSql = "SELECT COUNT(*) FROM employees";
		cntStmt = conn.prepareStatement(cntSql); 
	} else {
		cntSql = "SELECT COUNT(*) FROM employees WHERE first_name LIKE ? OR last_name LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+word+"%");
		cntStmt.setString(2, "%"+word+"%");
	}
	
		ResultSet cntRs = cntStmt.executeQuery();					
		int cnt = 0;
		if(cntRs.next()){
			cnt = cntRs.getInt("COUNT(*)");
		}
		
		int lastPage = cnt / rowPerPage;
		if(cnt % rowPerPage != 0){
			lastPage = lastPage + 1; // lastPage++, lastPage+=1
		}
	
	// 한페이지당 출력할 emp 목록
	String empSql = null;
	PreparedStatement empStmt = null;
	
	if(word==null){
		empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees ORDER BY emp_no ASC LIMIT ?, ?";
		empStmt = conn.prepareStatement(empSql);
		empStmt.setInt(1, rowPerPage * (currentPage -1));
		empStmt.setInt(2, rowPerPage);
	} else {
		empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees WHERE first_name LIKE ? OR last_name LIKE ? ORDER BY emp_no ASC LIMIT ?, ?";
		empStmt = conn.prepareStatement(empSql);
		empStmt.setString(1, "%"+word+"%");
		empStmt.setString(2, "%"+word+"%");
		empStmt.setInt(3, rowPerPage * (currentPage -1));
		empStmt.setInt(4, rowPerPage);
	}
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
	<h1 class="container mt-3 p-3 text-center bg-dark text-warning rounded">사원목록</h1>
	
	<!-- 사원 검색 -->
	<div class="container mt-2 p-2">
		<form method="post" action="<%=request.getContextPath()%>/emp/empList.jsp">
			<label for="word">사원 찾기 : </label>
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
	<table class="table table-hover text-center">
		<tr>
			<th><mark>사원번호</mark></th>
			<th><mark>FirstName</mark></th>
			<th><mark>LastName</mark></th>
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
	<ul class="pagination justify-content-center">
	<%
		if(word == null){ // 검색결과 없을 시,
	%>
			<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1">첫페이지</a></li>
		<%
			if(currentPage > 1){
		%>
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>">이전</a></li>
		<%
			}
			if((currentPage>lastPage-1)&&(currentPage-3>1)){
		%>
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-2%>"><%=currentPage-2%></a></li>
		<%
			}
			if((currentPage>lastPage-2)&&(currentPage-2>1)){
		%>
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-2%>"><%=currentPage-2%></a></li>
		<%
			}
			if(currentPage-1>1){
		%>
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-2%>"><%=currentPage-2%></a></li>
		<%
			}
			if(currentPage>1){
		%>
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>"><%=currentPage-1%></a></li>
		<%
			}
		%>	<!-- 현재페이지 -->
			<li class="page-item"><span class="page-link text-warning bg-dark"><%=currentPage%></span></li>
		<%
			if(currentPage<lastPage){
		%>
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>"><%=currentPage+1%></a></li>
		<%
			}
			if(currentPage+1<lastPage){
		%>
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+2%>"><%=currentPage+2%></a></li>
		<%
			}
			if(currentPage<3&&currentPage+2<lastPage){
		%>
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+3%>"><%=currentPage+3%></a></li>
		<%
			}
			if(currentPage<2&&currentPage+3<lastPage){
		%>
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+4%>"><%=currentPage+4%></a></li>
		<%
			}
			if(currentPage < lastPage){
		%>
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>">다음</a></li>
		<%
			}
		%>
			<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>">마지막페이지</a></li>
	<%		
		} else { // 검색결과 있을 시,
	%>	
			<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1&word=<%=word%>">첫페이지</a></li>
		<%
			if(currentPage > 1){
		%>
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>">이전</a></li>
		<%
			}
			if((currentPage>lastPage-1)&&(currentPage-3>1)){
		%>
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-2%>&word=<%=word%>"><%=currentPage-2%></a></li>
		<%
			}
			if((currentPage>lastPage-2)&&(currentPage-2>1)){
		%>
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-2%>&word=<%=word%>"><%=currentPage-2%></a></li>
		<%
			}
			if(currentPage-1>1){
		%>
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-2%>&word=<%=word%>"><%=currentPage-2%></a></li>
		<%
			}
			if(currentPage>1){
		%>
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>"><%=currentPage-1%></a></li>
		<%
			}
		%>	<!-- 현재페이지 -->
			<li class="page-item"><span class="page-link text-warning bg-dark"><%=currentPage%></span></li>
		<%
			if(currentPage<lastPage){
		%>
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>"><%=currentPage+1%></a></li>
		<%
			}
			if(currentPage+1<lastPage){
		%>
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+2%>&word=<%=word%>"><%=currentPage+2%></a></li>
		<%
			}
			if(currentPage<3&&currentPage+2<lastPage){
		%>
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+3%>&word=<%=word%>"><%=currentPage+3%></a></li>
		<%
			}
			if(currentPage<2&&currentPage+3<lastPage){
		%>
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+4%>&word=<%=word%>"><%=currentPage+4%></a></li>
		<%
			}
			if(currentPage < lastPage){
		%>
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>">다음</a></li>
		<%
			}
		%>
			<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>&word=<%=word%>">마지막페이지</a></li>
	<%		
		}
	%>
	</ul>
	</div>
</body>
</html>