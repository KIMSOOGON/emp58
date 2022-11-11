<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%
	// 1. 요청분석
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 2. 요청처리 후 필요하다면 모델데이터를 생성
	final int ROW_PER_PAGE = 10; // 변수 앞에 final을 붙여 상수로 만들어준다. 페이지당 나타낼 행 수
	int beginRow = (currentPage-1)*ROW_PER_PAGE; // ...Limit beginRow, ROW_PER_PAGE (page의 시작행 설정)
	
	// 드라이브 로딩 및 접속
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("1) BoardList 드라이버로딩완료");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
	System.out.println("2) BoardList 접속완료 conn: "+conn);
	
	// 2-1.
	String cntSql = "SELECT COUNT(*) cnt FROM board"; // 전체 갯수 불러오는 쿼리
	PreparedStatement cntStmt = conn.prepareStatement(cntSql); // Prepare문으로 쿼리 생성하기
	ResultSet cntRs = cntStmt.executeQuery(); // ResultSet + executeQuery() 로 쿼리 실행하기
	int cnt = 0; // cnt값 초기화
	if(cntRs.next()){ // 쿼리로 불러온 cntRs값 대입해주기
		cnt = cntRs.getInt("cnt");
	}
	// 마지막페이지 구하기 (1)
	int lastPage = (int)Math.ceil((double)cnt / (double)ROW_PER_PAGE);
	/* 마지막페이지 구하기 (2)
	int lastPage = cnt / ROW_PER_PAGE;
	if(cnt % ROW_PER_PAGE != 0){
		lastPage = lastPage + 1;
	}
	*/
	
	// 2-2.
	String listSql = "SELECT board_no boardNo, board_title boardTitle, board_writer boardWriter FROM board ORDER BY board_no DESC LIMIT ?,?";
	PreparedStatement listStmt = conn.prepareStatement(listSql); // prepare문으로 쿼리 생성
	listStmt.setInt(1, beginRow); // Limit (?,?) 값에 대입
	listStmt.setInt(2, ROW_PER_PAGE); 
	ResultSet listRs = listStmt.executeQuery(); // 모델 source data
	ArrayList<Board> boardList = new ArrayList<Board>(); // 모델의 new data
	while(listRs.next()){
		Board b = new Board();
		b.boardNo = listRs.getInt("boardNo");
		b.boardTitle = listRs.getString("boardTitle");
		b.boardWriter = listRs.getString("boardWriter");
		boardList.add(b);
	}
	// 3. 출력
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>boardList</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	
	<style>
		a:link, a:active, a:visited{
			color:black;
			text-decoration:none;
		}
	</style>
</head>
<body style="background-color:rgb(246,243,230)">
	<!-- 메뉴 partial jsp 구성 -->
	<div>
		<jsp:include page="../inc/menu.jsp"></jsp:include>
	</div>
	
	<div class="container rounded bg-light">
		<h1 class="container mt-3 p-3 text-center bg-dark text-warning rounded">자유 게시판</h1>
		
		<!-- 3-1. 모델데이터(ArrayList<Board>) 출력 -->
		<table class="container rounded table table-hover table-striped text-center">
			<tr style="background-color:pink">
				<th>No</th>
				<th>제목</th>
				<th>작성자</th>
			</tr>
			
			<%
				for(Board b : boardList){
			%>
					<tr>
						<td><%=b.boardNo%></td>
						<!-- 제목 클릭시 상세보기 이동 -->
						<td>
							<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.boardNo%>">
								<%=b.boardTitle%>
							</a>
						</td>
						<td><%=b.boardWriter%></td>
					</tr>
			<%
				}
			%>
		</table>
		<!-- 게시판 등록 -->
		<div style="text-align:center">
			<a class="btn btn-outline-success text-success" href="<%=request.getContextPath()%>/board/insertBoardForm.jsp">글쓰기</a>
		</div>
		<br>
		
		<!-- 3-2. 페이징 -->
		<ul class="pagination justify-content-center">
			<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1">첫페이지</a></li>
			<%
				if(currentPage>1){
			%>
					<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>">이전</a></li>
			<%
				}
				if(currentPage-2>1){
			%>
					<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-3%>"><%=currentPage-3%></a></li>
			<%
				}
				if(currentPage-1>1){
			%>
					<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-2%>"><%=currentPage-2%></a></li>
			<%
				}
				if(currentPage>1){
			%>
					<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>"><%=currentPage-1%></a></li>
			<%
				}
			%>
				<li class="page-item"><span class="page-link text-warning bg-dark"><%=currentPage%></span></li>
			<%
				if(currentPage<lastPage){
			%>
					<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+1%>"><%=currentPage+1%></a></li>
			<%
				}
				if(currentPage+1<lastPage){
			%>
					<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+2%>"><%=currentPage+2%></a></li>
			<%
				}
				if(currentPage+2<lastPage){
			%>
					<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+3%>"><%=currentPage+3%></a></li>
			<%
				}
				if(currentPage<lastPage){
			%>
					<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+1%>">다음</a></li>
			<%
				}
			%>
			<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=lastPage%>">마지막페이지</a></li>
		</ul>	
	</div>
</body>
</html>